/// creator: zhangjz
/// Description：工作量项目关联类别
/// Date:2018-07-30
Class DHCNMG.DB.MgNurWorkLoadItmSub Extends %Persistent
{

// Relationship WorkItm As DHCNMG.DB.MgNurWorkLoadItm [ Cardinality = parent, Inverse = ChildSub ];

Property WorkItm As DHCNMG.DB.MgNurWorkLoadItm [ SqlColumnNumber = 2, SqlFieldName = WorkItm ];

/// 关联用法
Property WorkRelInstruct As %String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = WorkRelInstruct ];

/// 关联医嘱
Property WorkRelArcim As %String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = WorkRelArcim ];

Index WorkItm On WorkItm;

Index ItmArcimInstr On WorkRelArcim;

Storage Default
{
<Data name="MgNurWorkLoadItmSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WorkItm</Value>
</Value>
<Value name="3">
<Value>WorkRelInstruct</Value>
</Value>
<Value name="4">
<Value>WorkRelArcim</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.DB.MgNurWorkLoadItmSubD</DataLocation>
<DefaultData>MgNurWorkLoadItmSubDefaultData</DefaultData>
<IdLocation>^DHCNMG.DB.MgNurWorkLoadItmSub</IdLocation>
<IndexLocation>^DHCNMG.DB.MgNurWorkLoadItmSubI</IndexLocation>
<StreamLocation>^DHCNMG.DB.MgNurWorkLoadItmSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
