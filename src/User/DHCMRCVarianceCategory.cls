Class User.DHCMRCVarianceCategory Extends %Persistent [ ClassType = persistent, ProcedureBlock, SqlRowIdName = VC_RowId, SqlTableName = DHC_MRC_VarianceCategory ]
{

Property VCCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = VC_Code ];

Property VCColour As %String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = VC_Colour ];

Property VCDateFrom As %Date [ SqlColumnNumber = 5, SqlFieldName = VC_DateFrom ];

Property VCDateTo As %Date [ SqlColumnNumber = 6, SqlFieldName = VC_DateTo ];

Property VCDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = VC_Desc ];

Property VCType As %String(DISPLAYLIST = ",Out,Var,NotInCPW,InCPWAgain", MINLEN = 3, TRUNCATE = 1, VALUELIST = ",O,V,N,IN") [ SqlColumnNumber = 7, SqlFieldName = VC_Type ];

Storage Default
{
<Data name="DataMaster">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>VCCode</Value>
</Value>
<Value name="3">
<Value>VCDesc</Value>
</Value>
<Value name="4">
<Value>VCColour</Value>
</Value>
<Value name="5">
<Value>VCDateFrom</Value>
</Value>
<Value name="6">
<Value>VCDateTo</Value>
</Value>
<Value name="7">
<Value>VRType</Value>
</Value>
<Value name="8">
<Value>VCType</Value>
</Value>
</Data>
<DataLocation>^DHCMRC("VC")</DataLocation>
<DefaultData>DataMaster</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMRC("VC")</IdLocation>
<IndexLocation>^DHCMRC("VC")(0)</IndexLocation>
<SqlRowIdName>VC_RowId</SqlRowIdName>
<StreamLocation>^User.DHCMRCVarianceCategoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
