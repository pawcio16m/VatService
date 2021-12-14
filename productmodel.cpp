#include "productmodel.h"
#include <QDebug>
#include <QLocale>

ProductModel::ProductModel(QObject* parent)
    : QAbstractListModel(parent)
{
}

int ProductModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return m_products.count();
}

QVariant ProductModel::data(const QModelIndex &index, int role) const
{
    int rowIndex = index.row();
    if ((rowIndex > -1) && (rowIndex < m_products.count()))
    {
        auto product = m_products.at(rowIndex);

        switch (role)
        {
            case ProductNameRole:
                return product.name;
            case PriceRole:
                return product.price;
            case VatRole:
                return product.vat;
            case VatValueRole:
                return product.calculateVatValue();
        }
    }
    return QVariant();
}

QHash<int, QByteArray> ProductModel::roleNames() const
{
    QHash<int, QByteArray> result;
    result.insert(ProductNameRole, QByteArrayLiteral("modelData_ProductName"));
    result.insert(PriceRole, QByteArrayLiteral("modelData_Price"));
    result.insert(VatRole, QByteArrayLiteral("modelData_Vat"));
    result.insert(VatValueRole, QByteArrayLiteral("modelData_VatValue"));
    return result;
}

Qt::ItemFlags ProductModel::flags(const QModelIndex &index) const
{
    Q_UNUSED(index)

    return Qt::ItemIsSelectable | Qt::ItemIsEnabled | Qt::ItemNeverHasChildren;
}

void ProductModel::addProduct(const QString& name, const QString& price, const QString& vat)
{
    auto locale = QLocale::system();
    beginInsertRows(QModelIndex(), rowCount(), rowCount());
    m_products.push_back(Product{.name = name,
                                 .price= locale.toDouble(price),
                                 .vat = vat.toInt()});
    m_totalVat += m_products.back().calculateVatValue();
    emit totalVatChanged();
    endInsertRows();
}
