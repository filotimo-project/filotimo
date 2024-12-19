#!/bin/bash

cd /tmp/packages
dnf5 -y install mock rpmdevtools
mkdir -p /tmp/packages/{srpms,rpms}

for dir in */; do
    if [[ -d "$dir" ]]; then
        if [[ "$dir" == "srpms/" || "$dir" == "rpms/" ]]; then
            continue
        fi

        cd "$dir" || { echo "failed to enter $dir"; exit 1; }

        specfile=$(ls *.spec 2>/dev/null)

        if [[ -z $specfile ]]; then
            echo "no spec file in $dir"
            cd ..
            continue
        fi

        mkdir -p /tmp/packages/{srpms,rpms}/$dir

        spectool -g -R "$specfile" --define "_sourcedir $(pwd)" \
            || { echo "failed to download sources for $dir"; exit 1; }

        mock --isolation=simple --define "debug_package %{nil}" \
            --buildsrpm \
            --spec "$specfile" \
            --sources . \
            --resultdir=/tmp/packages/srpms/$dir \
            || { echo "failed to build srpm for $dir"; exit 1; }

        mock --isolation=simple --define "debug_package %{nil}" \
            --rebuild /tmp/packages/srpms/$dir/*.src.rpm \
            --resultdir=/tmp/packages/rpms/$dir \
            || { echo "failed to build rpm for $dir"; exit 1; }

        dnf5 -y install $(find /tmp/packages/rpms/$dir -type f -name '*.rpm' ! -name '*.src.rpm') || { echo "failed to install $dir rpm"; exit 1; }

        cd ..
    fi
done

mock --isolation=simple --scrub=all
dnf5 -y remove mock rpmdevtools
