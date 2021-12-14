#pragma once

#include <QAbstractListModel>
#include <QObject>
#include <QVector>

struct Product {
    QString name;
    double price = 0.0;
    int vat = 0; //[%]

    inline double calculateVatValue()
    {
        return price * static_cast<double>(vat) / 100.0;
    }
};

class ProductModel : public QAbstractListModel
{
    Q_OBJECT
public:
    enum RoleNames {
        ProductNameRole = Qt::UserRole,
        PriceRole,
        VatRole,
        VatValueRole,
    };
    Q_PROPERTY(double totalVat READ totalVat NOTIFY totalVatChanged)

    explicit ProductModel(QObject* parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;
    Qt::ItemFlags flags(const QModelIndex &index) const override;

    Q_INVOKABLE void addProduct(const QString& name, const QString& price, const QString& vat);

    inline double totalVat() { return m_totalVat; }

signals:
    void totalVatChanged();

private:
    QVector<Product> m_products;
    double m_totalVat = 0.0;
};
