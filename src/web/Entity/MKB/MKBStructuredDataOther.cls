Class web.Entity.MKB.MKBStructuredDataOther Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.Entity.MKB.MKBStructuredDataOther";

/// Pid
Property MKBSDRowid As %String;

/// rowid
Property MKBSDORowid As %String;

/// 名称
Property MKBSDOther As %String(MAXLEN = "");

/// 备注
Property MKBSDOtherNote As %String(MAXLEN = "");

/// 检索码
Property MKBSDOtherCode As %String(MAXLEN = "");

/// 标识
Property MKBSDOtherMark As %String;

}
