#include "MainWindow.h"
#include "ui_MainWindow.h"
#include "UnitManageWindow.h"  // 包含 UnitManageWindow 头文件
#include <QStyle>

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent),
    ui(new Ui::MainWindow),
    unitManageWindow(nullptr)  // 初始化指针
{
    ui->setupUi(this);

    // 设置初始状态
    ui->stackedWidget->setCurrentIndex(0);
    resetAllButtons();

    // 设置信号槽连接
    setupConnections();
}

MainWindow::~MainWindow()
{
    delete ui;
    if (unitManageWindow) {
        delete unitManageWindow;
    }
}

void MainWindow::setupConnections()
{
    connect(ui->btnUnits, &QPushButton::clicked, this, &MainWindow::onBtnUnitsClicked);
    connect(ui->btnStations, &QPushButton::clicked, this, &MainWindow::onBtnStationsClicked);
    connect(ui->btnProtocols, &QPushButton::clicked, this, &MainWindow::onBtnProtocolsClicked);
    connect(ui->btnCommands, &QPushButton::clicked, this, &MainWindow::onBtnCommandsClicked);
    connect(ui->btnTests, &QPushButton::clicked, this, &MainWindow::onBtnTestsClicked);
    connect(ui->btnAnalysis, &QPushButton::clicked, this, &MainWindow::onBtnAnalysisClicked);
    connect(ui->btnSystem, &QPushButton::clicked, this, &MainWindow::onBtnSystemClicked);
    connect(ui->btnLogout, &QPushButton::clicked, this, &MainWindow::onBtnLogoutClicked);
}

void MainWindow::setActiveButton(QPushButton *btn)
{
    // 重置所有按钮状态
    resetAllButtons();

    // 设置当前按钮为活动状态
    btn->setProperty("active", true);
    btn->style()->unpolish(btn);
    btn->style()->polish(btn);
}

void MainWindow::resetAllButtons()
{
    // 获取所有侧边栏按钮
    QList<QPushButton*> buttons = ui->sideBar->findChildren<QPushButton*>();

    foreach (QPushButton *btn, buttons) {
        if (btn != ui->btnLogout) {  // 排除退出按钮
            btn->setProperty("active", false);
            btn->style()->unpolish(btn);
            btn->style()->polish(btn);
        }
    }
}

void MainWindow::onBtnUnitsClicked()
{
    setActiveButton(ui->btnUnits);

    // 如果窗口不存在，则创建并添加到 stackedWidget
    if (!unitManageWindow) {
        unitManageWindow = new UnitManageWindow(this);
        ui->stackedWidget->addWidget(unitManageWindow);
    }

    // 设置当前页面
    ui->stackedWidget->setCurrentWidget(unitManageWindow);
}

void MainWindow::onBtnStationsClicked()
{
    setActiveButton(ui->btnStations);
    ui->stackedWidget->setCurrentWidget(ui->pageStations);
}

void MainWindow::onBtnProtocolsClicked()
{
    setActiveButton(ui->btnProtocols);
    ui->stackedWidget->setCurrentWidget(ui->pageProtocols);
}

void MainWindow::onBtnCommandsClicked()
{
    setActiveButton(ui->btnCommands);
    ui->stackedWidget->setCurrentWidget(ui->pageCommands);
}

void MainWindow::onBtnTestsClicked()
{
    setActiveButton(ui->btnTests);
    ui->stackedWidget->setCurrentWidget(ui->pageTests);
}

void MainWindow::onBtnAnalysisClicked()
{
    setActiveButton(ui->btnAnalysis);
    ui->stackedWidget->setCurrentWidget(ui->pageAnalysis);
}

void MainWindow::onBtnSystemClicked()
{
    setActiveButton(ui->btnSystem);
    ui->stackedWidget->setCurrentWidget(ui->pageSystem);
}

void MainWindow::onBtnLogoutClicked()
{
    close();  // 关闭主窗口
}
