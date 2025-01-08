loadTemplate("org.kde.plasma.desktop.defaultPanel")

const panel = panels()[0];
panel.height = Math.round(gridUnit * 3);
panel.floating = true;
