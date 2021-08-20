#include "client.h"

using namespace cm::data;

namespace cm {
namespace models {

Client::Client(QObject* parent)
	: Entity(parent, "client")
{
	reference = static_cast<StringDecorator*>(addDataItem(new StringDecorator(this, "reference", "Client Ref")));
	name = static_cast<StringDecorator*>(addDataItem(new StringDecorator(this, "name", "Name")));
	supplyAddress = static_cast<Address*>(addChild(new Address(this), "supplyAddress"));
	billingAddress = static_cast<Address*>(addChild(new Address(this), "billingAddress"));
	appointments = static_cast<EntityCollection<Appointment>*>(addChildCollection(new EntityCollection<Appointment>(this, "appointments")));
	contacts = static_cast<EntityCollection<Contact>*>(addChildCollection(new EntityCollection<Contact>(this, "contacts")));

	setPrimaryKey(reference);
}

Client::Client(QObject* parent, const QJsonObject& json)
	: Client(parent)
{
	update(json);
}

QQmlListProperty<Appointment> Client::ui_appointments()
{
	return QQmlListProperty<Appointment>(this, appointments->derivedEntities());
}

QQmlListProperty<Contact> Client::ui_contacts()
{
	return QQmlListProperty<Contact>(this, contacts->derivedEntities());
}

}}
