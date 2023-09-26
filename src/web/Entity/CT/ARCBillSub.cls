/// CreateDate:2012-08-13
/// Creator:基础数据平台 ，孙凤超
/// Function:帐单子组维护
/// Tables:ARC_BillSub，
Class web.Entity.CT.ARCBillSub Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.ARCBillSub";

/// 父表ID
Property ParentRowId As %String;

Property ARCSGCode As %String;

Property ARCSGRowId As %String;

/// 代码
Property ARCSGDesc As %String;

/// 描述
Property ARCSGAbbrev As %String;

/// 缩写
Property ARCSGChildSub As %String;

/// 孩子
Property ARCBGDesc As %String;

Property ARCSGARCBGParRef As %String;

Storage Default
{
<Data name="ARCBillSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.Entity.CT.ARCBillSubD</DataLocation>
<DefaultData>ARCBillSubDefaultData</DefaultData>
<IdLocation>^web.Entity.CT.ARCBillSubD</IdLocation>
<IndexLocation>^web.Entity.CT.ARCBillSubI</IndexLocation>
<StreamLocation>^web.Entity.CT.ARCBillSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
