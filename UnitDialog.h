#ifndef UNITDIALOG_H
#define UNITDIALOG_H

#include <QDialog>

QT_BEGIN_NAMESPACE
namespace Ui { class UnitDialog; }
QT_END_NAMESPACE

class UnitDialog : public QDialog
{
    Q_OBJECT

public:
    // 模式枚举
    enum Mode { NewUnit, EditUnit };

    explicit UnitDialog(QWidget *parent = nullptr, Mode mode = NewUnit,
                        const QStringList &unitData = QStringList());
    ~UnitDialog();

    QStringList getUnitData() const;
    void setUnitData(const QStringList &data);

private:
    Ui::UnitDialog *ui;
    Mode m_mode;
};

#endif // UNITDIALOG_H

