#ifndef SINGLE_RESOLUTION_WIDGET_H
#define SINGLE_RESOLUTION_WIDGET_H

#include "resolutionwidget.h"



class SingleResolutionWidget : public ResolutionWidget
{
    Q_OBJECT
public:
    explicit SingleResolutionWidget(ComDeepinDaemonGraphicsDriverInterface *graphicsDriver, const Resolution &resolution,  QWidget *parent = nullptr);

private Q_SLOTS:
    virtual void onThemeChanged(Dtk::Gui::DGuiApplicationHelper::ColorType type);
    // ResolutionWidget interface
public:
    void initUI();
    void setChecked(const bool checked);
};


#endif
