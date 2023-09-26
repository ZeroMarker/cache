/// Description: 移动药房请领类型
Class User.PHAIPReqType Extends (%Persistent, User.Abstract) [ SqlRowIdName = PRT_RowID, SqlTableName = PHAIP_ReqType ]
{

Index PRTCODELOC On (PRTCode As Exact, PRTLocDR As Exact);

Index Type On PRTType As Exact;

Relationship ChildReqTypeItm As PHAIPReqTypeItm [ Cardinality = children, Inverse = ReqTypeItmParRef ];

Property PRTDesc As %String [ SqlColumnNumber = 2, SqlFieldName = PRT_Desc ];

/// 类型 1:送药,2:取药
Property PRTType As %String [ SqlColumnNumber = 3, SqlFieldName = PRT_Type ];

Property PRTColor As %String [ SqlColumnNumber = 4, SqlFieldName = PRT_Color ];

Property PRTCode As %String [ SqlColumnNumber = 5, SqlFieldName = PRT_Code ];

Property PRTLocDR As User.CTLoc [ SqlColumnNumber = 6, SqlFieldName = PRT_Loc_DR ];

Storage Default
{
<Data name="PHAIPReqTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PRTDesc</Value>
</Value>
<Value name="3">
<Value>PRTType</Value>
</Value>
<Value name="4">
<Value>PRTColor</Value>
</Value>
<Value name="5">
<Value>PRTCode</Value>
</Value>
<Value name="6">
<Value>PRTLocDR</Value>
</Value>
</Data>
<DataLocation>^CF.PHA.IP.ReqType</DataLocation>
<DefaultData>PHAIPReqTypeDefaultData</DefaultData>
<IdLocation>^CF.PHA.IP.ReqType</IdLocation>
<IndexLocation>^CF.PHA.IP.ReqTypei</IndexLocation>
<StreamLocation>^CF.PHA.IP.ReqTypes</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
