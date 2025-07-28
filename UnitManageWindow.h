#ifndef UNITMANAGEWINDOW_H
#define UNITMANAGEWINDOW_H

#include <QWidget>
#include <QList>
#include <QStringList>
#include <QTableWidgetItem>

namespace Ui {
class UnitManageWindow;
}

// 前置声明复选框委托类
class CheckBoxDelegate;

class UnitManageWindow : public QWidget
{
    Q_OBJECT

public:
    // 构造函数
    explicit UnitManageWindow(QWidget *parent = nullptr);

    // 析构函数
    ~UnitManageWindow();

signals:
    // 状态消息信号
    void statusMessageRequested(const QString &message, int timeout = 0);

private slots:
    // 按钮操作槽函数
    void onAdd();
    void onEdit();
    void onDelete();
    void onSearch();

    // 分页操作槽函数
    void onPageChanged(int index);
    void onPageSizeChanged(int index);
    void gotoFirstPage();
    void gotoPrevPage();
    void gotoNextPage();
    void gotoLastPage();

private:
    Ui::UnitManageWindow *ui;

    // 分页相关变量
    int currentPage;
    int pageSize;
    int totalPages;

    // 数据存储
    QList<QStringList> unitData;
    QList<QStringList> filteredData;

    // 初始化函数
    void initUI();
    void initPagination();
    void setupConnections();

    // 更新函数
    void updatePagination();
    void updateTable();

    // 数据加载函数
    void loadTestData();

    // 辅助函数
    QList<QStringList> getCurrentPageData() const;
    QList<int> getSelectedRows() const;
};

#endif // UNITMANAGEWINDOW_H
