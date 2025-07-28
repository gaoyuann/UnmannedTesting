#include "UnitManageWindow.h"
#include "ui_UnitManageWindow.h"
#include "UnitDialog.h"

#include <QHeaderView>
#include <QMessageBox>
#include <QPainter>
#include <QStyledItemDelegate>
#include <algorithm>

// 复选框委托类实现
class CheckBoxDelegate : public QStyledItemDelegate {
public:
    using QStyledItemDelegate::QStyledItemDelegate;

    void paint(QPainter *painter, const QStyleOptionViewItem &option,
               const QModelIndex &index) const override {
        QStyleOptionViewItem opt = option;
        initStyleOption(&opt, index);

        painter->save();
        painter->setRenderHint(QPainter::Antialiasing, true);

        if (opt.state & QStyle::State_MouseOver) {
            painter->fillRect(opt.rect.adjusted(1,1,-1,-1), QColor(220, 230, 240));
        }

        QRect checkRect = QRect(opt.rect.x() + opt.rect.width()/2 - 8,
                                opt.rect.y() + opt.rect.height()/2 - 8,
                                16, 16);

        bool checked = index.data(Qt::CheckStateRole) == Qt::Checked;
        QColor checkColor = checked ? QColor(58, 110, 165) : QColor(200, 200, 200);

        painter->setPen(QPen(checkColor, 1.5));
        painter->setBrush(checked ? QBrush(checkColor) : QBrush(Qt::white));
        painter->drawRoundedRect(checkRect, 3, 3);

        if (checked) {
            painter->setPen(QPen(Qt::white, 2));
            painter->drawLine(checkRect.x()+4, checkRect.y()+8,
                              checkRect.x()+6, checkRect.y()+12);
            painter->drawLine(checkRect.x()+6, checkRect.y()+12,
                              checkRect.x()+12, checkRect.y()+4);
        }

        painter->restore();
    }
};

UnitManageWindow::UnitManageWindow(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::UnitManageWindow),
    currentPage(1),
    pageSize(10),
    totalPages(1)
{
    ui->setupUi(this);
    initUI();
    initPagination();
    loadTestData();
    updateTable();
    setupConnections();
}

UnitManageWindow::~UnitManageWindow()
{
    delete ui;
}

void UnitManageWindow::initUI()
{
    QString buttonStyle = R"(
        QPushButton {
            background-color: #3a6ea5;
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 4px;
            font-size: 13px;
            min-width: 80px;
        }
        QPushButton:hover {
            background-color: #4a90e2;
        }
        QPushButton:pressed {
            background-color: #2a5685;
        }
        QPushButton:disabled {
            background-color: #cccccc;
        }
    )";

    ui->btnAdd->setStyleSheet(buttonStyle);
    ui->btnEdit->setStyleSheet(buttonStyle);
    ui->btnDelete->setStyleSheet(buttonStyle);
    ui->btnSearch->setStyleSheet(buttonStyle);

    ui->lineSearch->setStyleSheet(R"(
        QLineEdit {
            padding: 8px 12px;
            border: 1px solid #d0d0d0;
            border-radius: 4px;
            font-size: 13px;
            min-width: 250px;
            background-color: white;
            color: #333333;
        }
        QLineEdit:focus {
            border: 1px solid #4a90e2;
            box-shadow: 0 0 0 2px rgba(74,144,226,0.2);
        }
    )");

    QStringList headers;
    headers << "" << "名称" << "地址" << "联系人" << "电话" << "邮箱";
    ui->tableUnits->setColumnCount(headers.size());
    ui->tableUnits->setHorizontalHeaderLabels(headers);

    ui->tableUnits->setStyleSheet(R"(
        QTableWidget {
            gridline-color: #e0e0e0;
            font-size: 13px;
            background-color: white;
            alternate-background-color: #f8f9fa;
            border: 1px solid #e0e0e0;
            border-radius: 4px;
            outline: 0;
        }
        QTableWidget::item {
            padding: 8px;
            border-bottom: 1px solid #f0f0f0;
            color: #333333;
        }
        QTableWidget::item:hover {
            background-color: #f0f7ff;
        }
        QHeaderView::section {
            background-color: #3a6ea5;
            color: white;
            padding: 8px;
            border: none;
            font-weight: 500;
        }
        QHeaderView {
            border-top-left-radius: 4px;
            border-top-right-radius: 4px;
        }
    )");

    auto header = ui->tableUnits->horizontalHeader();
    header->setSectionResizeMode(0, QHeaderView::Fixed);
    ui->tableUnits->setColumnWidth(0, 40);
    header->setDefaultAlignment(Qt::AlignCenter);

    ui->tableUnits->setAlternatingRowColors(true);
    ui->tableUnits->setSelectionMode(QAbstractItemView::NoSelection);
    ui->tableUnits->setEditTriggers(QAbstractItemView::NoEditTriggers);
    ui->tableUnits->verticalHeader()->setVisible(false);
    ui->tableUnits->setShowGrid(false);
    ui->tableUnits->setSortingEnabled(true);
    ui->tableUnits->setItemDelegateForColumn(0, new CheckBoxDelegate(this));

    ui->buttonLayout->setContentsMargins(12, 12, 12, 12);
    ui->buttonLayout->setSpacing(10);
    ui->verticalLayout->setContentsMargins(8, 8, 8, 8);
    ui->verticalLayout->setSpacing(8);
}

void UnitManageWindow::initPagination()
{
    QString paginationStyle = R"(
        QPushButton {
            min-width: 60px;
            padding: 4px 8px;
            background-color: #f0f0f0;
            border: 1px solid #d0d0d0;
            border-radius: 3px;
        }
        QPushButton:hover {
            background-color: #e0e0e0;
        }
        QPushButton:pressed {
            background-color: #d0d0d0;
        }
        QComboBox {
            padding: 4px;
            border: 1px solid #d0d0d0;
            border-radius: 3px;
            min-width: 60px;
        }
        QLabel {
            color: #666666;
        }
    )";

    ui->paginationWidget->setStyleSheet(paginationStyle);
    ui->comboPageSize->setCurrentIndex(0);
    ui->comboPage->clear();
    ui->comboPage->addItem("1");

    ui->horizontalLayout->setContentsMargins(12, 6, 12, 6);
    ui->horizontalLayout->setSpacing(8);
}

void UnitManageWindow::setupConnections()
{
    connect(ui->btnAdd, &QPushButton::clicked, this, &UnitManageWindow::onAdd);
    connect(ui->btnEdit, &QPushButton::clicked, this, &UnitManageWindow::onEdit);
    connect(ui->btnDelete, &QPushButton::clicked, this, &UnitManageWindow::onDelete);
    connect(ui->btnSearch, &QPushButton::clicked, this, &UnitManageWindow::onSearch);
    connect(ui->comboPage, QOverload<int>::of(&QComboBox::currentIndexChanged), this, &UnitManageWindow::onPageChanged);
    connect(ui->comboPageSize, QOverload<int>::of(&QComboBox::currentIndexChanged), this, &UnitManageWindow::onPageSizeChanged);
    connect(ui->btnFirst, &QPushButton::clicked, this, &UnitManageWindow::gotoFirstPage);
    connect(ui->btnPrev, &QPushButton::clicked, this, &UnitManageWindow::gotoPrevPage);
    connect(ui->btnNext, &QPushButton::clicked, this, &UnitManageWindow::gotoNextPage);
    connect(ui->btnLast, &QPushButton::clicked, this, &UnitManageWindow::gotoLastPage);
}

void UnitManageWindow::updatePagination()
{
    int totalItems = filteredData.isEmpty() ? unitData.size() : filteredData.size();
    totalPages = (totalItems + pageSize - 1) / pageSize;
    if (totalPages == 0) totalPages = 1;

    currentPage = std::clamp(currentPage, 1, totalPages);

    ui->comboPage->blockSignals(true);
    ui->comboPage->clear();
    for (int i = 1; i <= totalPages; ++i) {
        ui->comboPage->addItem(QString::number(i));
    }
    ui->comboPage->setCurrentIndex(currentPage - 1);
    ui->comboPage->blockSignals(false);

    ui->labelPageInfo->setText(
        QString("第 %1 页 / 共 %2 页 (%3 条)").arg(currentPage).arg(totalPages).arg(totalItems));

    ui->btnFirst->setEnabled(currentPage > 1);
    ui->btnPrev->setEnabled(currentPage > 1);
    ui->btnNext->setEnabled(currentPage < totalPages);
    ui->btnLast->setEnabled(currentPage < totalPages);
}

QList<QStringList> UnitManageWindow::getCurrentPageData() const
{
    const QList<QStringList>& data = filteredData.isEmpty() ? unitData : filteredData;
    qsizetype start = (currentPage - 1) * pageSize;
    qsizetype end = std::min(start + pageSize, data.size());

    QList<QStringList> pageData;
    for (qsizetype i = start; i < end; ++i) {
        pageData.append(data[i]);
    }
    return pageData;
}

void UnitManageWindow::updateTable()
{
    QList<QStringList> pageData = getCurrentPageData();
    ui->tableUnits->clearContents();
    ui->tableUnits->setRowCount(pageData.size());

    for (int i = 0; i < pageData.size(); ++i) {
        const QStringList &unit = pageData[i];

        QTableWidgetItem *checkItem = new QTableWidgetItem();
        checkItem->setFlags(Qt::ItemIsUserCheckable | Qt::ItemIsEnabled);
        checkItem->setCheckState(Qt::Unchecked);
        ui->tableUnits->setItem(i, 0, checkItem);

        for (int j = 0; j < unit.size(); ++j) {
            QTableWidgetItem *item = new QTableWidgetItem(unit[j]);
            item->setTextAlignment(Qt::AlignCenter);
            ui->tableUnits->setItem(i, j+1, item);
        }
    }

    updatePagination();
    emit statusMessageRequested(QString("共 %1 条记录").arg(filteredData.isEmpty() ? unitData.size() : filteredData.size()));
}

void UnitManageWindow::loadTestData()
{
    unitData.clear();
    for (int i = 1; i <= 50; ++i) {
        unitData.append({
            QString("测试单位%1").arg(i),
            QString("地址%1").arg(i),
            QString("联系人%1").arg(i),
            QString("1380000%1").arg(1000 + i),
            QString("test%1@example.com").arg(i)
        });
    }
}

QList<int> UnitManageWindow::getSelectedRows() const
{
    QList<int> selectedRows;
    for(int i = 0; i < ui->tableUnits->rowCount(); ++i) {
        if(ui->tableUnits->item(i, 0)->checkState() == Qt::Checked) {
            selectedRows.append(i);
        }
    }
    return selectedRows;
}

void UnitManageWindow::onAdd()
{
    UnitDialog dialog(this, UnitDialog::NewUnit);
    if (dialog.exec() == QDialog::Accepted) {
        unitData.append(dialog.getUnitData());
        filteredData.clear();
        currentPage = 1;
        updateTable();
        emit statusMessageRequested("新增单位成功", 3000);
    }
}

void UnitManageWindow::onEdit()
{
    QList<int> selectedRows = getSelectedRows();
    if(selectedRows.size() != 1) {
        QMessageBox::warning(this, "警告", "请勾选一条记录进行编辑");
        return;
    }

    int pageRow = selectedRows.first();
    int dataIndex = (currentPage - 1) * pageSize + pageRow;
    if (!filteredData.isEmpty() && dataIndex < filteredData.size()) {
        dataIndex = unitData.indexOf(filteredData[dataIndex]);
    }

    QStringList currentData = unitData[dataIndex];

    UnitDialog dialog(this, UnitDialog::EditUnit, currentData);
    if (dialog.exec() == QDialog::Accepted) {
        unitData[dataIndex] = dialog.getUnitData();
        if (!filteredData.isEmpty()) {
            int filteredIndex = filteredData.indexOf(currentData);
            if (filteredIndex != -1) {
                filteredData[filteredIndex] = dialog.getUnitData();
            }
        }
        updateTable();
        emit statusMessageRequested("编辑单位成功", 3000);
    }
}

void UnitManageWindow::onDelete()
{
    QList<int> selectedRows = getSelectedRows();
    if(selectedRows.isEmpty()) {
        QMessageBox::warning(this, "警告", "请勾选要删除的记录");
        return;
    }

    if(QMessageBox::question(this, "确认删除",
                              QString("确定要删除选中的 %1 条记录吗？").arg(selectedRows.size()),
                              QMessageBox::Yes|QMessageBox::No) != QMessageBox::Yes) {
        return;
    }

    std::sort(selectedRows.begin(), selectedRows.end(), std::greater<int>());

    QList<QStringList> itemsToDelete;
    for (int row : selectedRows) {
        int dataIndex = (currentPage - 1) * pageSize + row;
        if (!filteredData.isEmpty() && dataIndex < filteredData.size()) {
            itemsToDelete.append(filteredData[dataIndex]);
        }
    }

    for (const QStringList &item : itemsToDelete) {
        unitData.removeOne(item);
    }

    if (!filteredData.isEmpty()) {
        for (const QStringList &item : itemsToDelete) {
            filteredData.removeOne(item);
        }
    }

    currentPage = 1;
    updateTable();
    emit statusMessageRequested(QString("已删除 %1 条记录").arg(selectedRows.size()), 3000);
}

void UnitManageWindow::onSearch()
{
    QString keyword = ui->lineSearch->text().trimmed();
    if (keyword.isEmpty()) {
        filteredData.clear();
        currentPage = 1;
        updateTable();
        return;
    }

    filteredData.clear();
    for (const QStringList &unit : unitData) {
        for (const QString &field : unit) {
            if (field.contains(keyword, Qt::CaseInsensitive)) {
                filteredData.append(unit);
                break;
            }
        }
    }

    currentPage = 1;
    updateTable();
    emit statusMessageRequested(QString("搜索到 %1 条匹配记录").arg(filteredData.size()), 3000);
}

void UnitManageWindow::onPageChanged(int index)
{
    currentPage = index + 1;
    updateTable();
}

void UnitManageWindow::onPageSizeChanged(int index)
{
    static const int pageSizes[] = {10, 20, 50, 100};
    pageSize = pageSizes[index];
    currentPage = 1;
    updateTable();
}

void UnitManageWindow::gotoFirstPage()
{
    currentPage = 1;
    updateTable();
}

void UnitManageWindow::gotoPrevPage()
{
    if (currentPage > 1) {
        currentPage--;
        updateTable();
    }
}

void UnitManageWindow::gotoNextPage()
{
    if (currentPage < totalPages) {
        currentPage++;
        updateTable();
    }
}

void UnitManageWindow::gotoLastPage()
{
    currentPage = totalPages;
    updateTable();
}
