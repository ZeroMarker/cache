/// 
/// 护理月报工作量项目明细
/// 
Class DHCNMG.DB.MgReportItemSub Extends %Persistent [ Owner = {dhpm1} ]
{

Relationship Parref As DHCNMG.DB.MgReportItem [ Cardinality = parent, Inverse = ChildSub ];

/// 项目
Property DetailItem As %String [ SqlColumnNumber = 2, SqlFieldName = Detail_Item ];

/// 计算公式 分子
Property DetailMolecular As %String [ SqlColumnNumber = 3, SqlFieldName = Detail_Molecular ];

/// 计算公式 分母
Property DetailDenominator As %String [ SqlColumnNumber = 4, SqlFieldName = Detail_Denominator ];

Property DetailCreator As %String [ SqlColumnNumber = 5, SqlFieldName = Detail_Creator ];

Index Item On (Parref, DetailItem);

Storage Default
{
<Data name="MgReportItemSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DetailItem</Value>
</Value>
<Value name="3">
<Value>DetailMolecular</Value>
</Value>
<Value name="4">
<Value>DetailDenominator</Value>
</Value>
<Value name="5">
<Value>DetailCreator</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.DB.MgReportItemSubD</DataLocation>
<DefaultData>MgReportItemSubDefaultData</DefaultData>
<IdLocation>{%%PARENT}("ChildSub")</IdLocation>
<IndexLocation>^DHCNMG.DB.MgReportItemSubI</IndexLocation>
<StreamLocation>^DHCNMG.DB.MgReportItemSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
