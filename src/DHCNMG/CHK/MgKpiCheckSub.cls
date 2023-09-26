Class DHCNMG.CHK.MgKpiCheckSub Extends %Persistent
{

Relationship Parref As DHCNMG.CHK.MgKpiCheck [ Cardinality = parent, Inverse = ChildSub ];

/// 检查条目
Property KpiItemSubDR As DHCNMG.DB.MgKpiItemSub [ Required, SqlColumnNumber = 2, SqlFieldName = KpiItemSubDR ];

/// 条目得分
Property CheckItemScore As %String [ SqlColumnNumber = 3, SqlFieldName = Check_ItemScore ];

Index parr On Parref;

Index par On (Parref, KpiItemSubDR);

Storage Default
{
<Data name="MgKpiCheckSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>KpiItemSubDR</Value>
</Value>
<Value name="3">
<Value>CheckItemScore</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.CHK.MgKpiCheckSubD</DataLocation>
<DefaultData>MgKpiCheckSubDefaultData</DefaultData>
<IdLocation>^DHCNMG.CHK.MgKpiCheckSubD</IdLocation>
<IndexLocation>^DHCNMG.CHK.MgKpiCheckSubI</IndexLocation>
<StreamLocation>^DHCNMG.CHK.MgKpiCheckSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
