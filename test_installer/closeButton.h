//
// Created by uos on 2021/3/8.
//

#ifndef DEEPIN_GRAPHICS_DRIVER_MANAGER_CLOSEBUTTON_H
#define DEEPIN_GRAPHICS_DRIVER_MANAGER_CLOSEBUTTON_H

#include <QWidget>
#include <QLabel>
#include <DGuiApplicationHelper>

class CloseButton : public QWidget
{
Q_OBJECT

public:
    explicit CloseButton(QWidget *parent = nullptr);

    ~CloseButton() override;
Q_SIGNALS:
    void clicked();

protected:
    virtual void mousePressEvent(QMouseEvent *event);
    virtual void onThemeChanged(Dtk::Gui::DGuiApplicationHelper::ColorType type);

private:
    QLabel *m_label = nullptr;
    bool m_enable = true;
    QWidget *m_mainWidget = nullptr;
};

#endif //DEEPIN_GRAPHICS_DRIVER_MANAGER_CLOSEBUTTON_H
