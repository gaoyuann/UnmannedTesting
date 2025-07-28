#include "UnitDialog.h"
#include "ui_UnitDialog.h"

UnitDialog::UnitDialog(QWidget *parent, Mode mode, const QStringList &unitData)
    : QDialog(parent),
    ui(new Ui::UnitDialog),
    m_mode(mode)
{
    ui->setupUi(this);

    // 根据模式设置窗口标题
    setWindowTitle(m_mode == NewUnit ? "新增参试单位" : "编辑参试单位");
    setFixedSize(500, 400);

    // 设置样式
    setStyleSheet(R"(
        QDialog {
            background-color: #f8f9fa;
            font-family: 'Microsoft YaHei', 'Segoe UI';
        }
        QLabel {
            color: #333333;
            font-size: 13px;
        }
        QLineEdit, QTextEdit {
            border: 1px solid #d0d0d0;
            border-radius: 4px;
            padding: 8px;
            font-size: 13px;
            background-color: white;
            color: #000000;
        }
        QLineEdit:focus, QTextEdit:focus {
            border: 1px solid #4a90e2;
            box-shadow: 0 0 0 2px rgba(74,144,226,0.2);
        }
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
    )");

    // 设置按钮样式
    ui->buttonBox->setStyleSheet("QPushButton { min-width: 80px; }");

    // 如果有传入数据，则填充表单
    if (!unitData.isEmpty()) {
        setUnitData(unitData);
    }
}

UnitDialog::~UnitDialog()
{
    delete ui;
}

QStringList UnitDialog::getUnitData() const
{
    return {
        ui->lineName->text().trimmed(),
        ui->lineAddress->text().trimmed(),
        ui->lineContact->text().trimmed(),
        ui->linePhone->text().trimmed(),
        ui->lineEmail->text().trimmed(),
        ui->textNotes->toPlainText().trimmed()
    };
}

void UnitDialog::setUnitData(const QStringList &data)
{
    if (data.size() >= 1) ui->lineName->setText(data[0]);
    if (data.size() >= 2) ui->lineAddress->setText(data[1]);
    if (data.size() >= 3) ui->lineContact->setText(data[2]);
    if (data.size() >= 4) ui->linePhone->setText(data[3]);
    if (data.size() >= 5) ui->lineEmail->setText(data[4]);
    if (data.size() >= 6) ui->textNotes->setPlainText(data[5]);
}
