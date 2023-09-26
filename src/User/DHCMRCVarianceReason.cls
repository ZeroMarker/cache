Class User.DHCMRCVarianceReason Extends %Persistent [ ClassType = persistent, ProcedureBlock, SqlRowIdName = VR_RowId, SqlTableName = DHC_MRC_VarianceReason ]
{

Property VRCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = VR_Code ];

Property VRDateFrom As %Date [ SqlColumnNumber = 5, SqlFieldName = VR_DateFrom ];

Property VRDateTo As %Date [ SqlColumnNumber = 6, SqlFieldName = VR_DateTo ];

Property VRDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = VR_Desc ];

Property VRVarCategDR As DHCMRCVarianceCategory [ SqlColumnNumber = 4, SqlFieldName = VR_VarCateg_DR ];

Property VRType As %String(DISPLAYLIST = ",Add,Minus", MINLEN = 3, TRUNCATE = 1, VALUELIST = ",A,M") [ SqlColumnNumber = 7, SqlFieldName = VR_Type ];

Property VRActive As %String(DISPLAYLIST = ",Yes,No", MINLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = VR_Active ];

Storage Default
{
<Data name="DataMaster">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>VRCode</Value>
</Value>
<Value name="3">
<Value>VRDesc</Value>
</Value>
<Value name="4">
<Value>VRVarCategDR</Value>
</Value>
<Value name="5">
<Value>VRDateFrom</Value>
</Value>
<Value name="6">
<Value>VRDateTo</Value>
</Value>
<Value name="7">
<Value>VRType</Value>
</Value>
<Value name="8">
<Value>VRActive</Value>
</Value>
</Data>
<DataLocation>^DHCMRC("VR")</DataLocation>
<DefaultData>DataMaster</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMRC("VR")</IdLocation>
<IndexLocation>^DHCMRC("VR")(0)</IndexLocation>
<SqlRowIdName>VR_RowId</SqlRowIdName>
<StreamLocation>^User.DHCMRCVarianceReasonS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
