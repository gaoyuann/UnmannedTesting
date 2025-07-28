#ifndef MAINWINDOW_H
#define MAINWindow_H

#include <QMainWindow>
#include <QStackedWidget>
#include <QPushButton>

// 前向声明
class UnitManageWindow;

namespace Ui {
class MainWindow;
}

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit MainWindow(QWidget *parent = nullptr);
    ~MainWindow();

private slots:
    void onBtnUnitsClicked();
    void onBtnStationsClicked();
    void onBtnProtocolsClicked();
    void onBtnCommandsClicked();
    void onBtnTestsClicked();
    void onBtnAnalysisClicked();
    void onBtnSystemClicked();
    void onBtnLogoutClicked();

private:
    Ui::MainWindow *ui;
    UnitManageWindow *unitManageWindow;  // UnitManageWindow 指针

    void setupConnections();
    void setActiveButton(QPushButton *btn);
    void resetAllButtons();
};

#endif // MAINWINDOW_H
