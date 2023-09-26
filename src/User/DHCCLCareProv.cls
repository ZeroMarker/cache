Class User.DHCCLCareProv Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = CLCP_RowId, SqlTableName = DHC_CL_CareProv, StorageStrategy = CacheStorage ]
{

Property CLCPCTLOCDr As %String [ SqlColumnNumber = 2, SqlFieldName = CLCP_CTLOC_Dr ];

Property CLCPDesc As %String [ SqlColumnNumber = 3, SqlFieldName = CLCP_Desc ];

Property CLCPAlias As %String [ SqlColumnNumber = 4, SqlFieldName = CLCP_Alias ];

Property CLCPFromDate As %Date [ SqlColumnNumber = 5, SqlFieldName = CLCP_FromDate ];

Property CLCPToDate As %Date [ SqlColumnNumber = 6, SqlFieldName = CLCP_ToDate ];

Property CLCPInActive As %Boolean [ SqlColumnNumber = 7, SqlFieldName = CLCP_InActive ];

Property CLCPIfDoctor As %Boolean [ SqlColumnNumber = 8, SqlFieldName = CLCP_IfDoctor ];

Property CLCPType As %String(DISPLAYLIST = ",Expert,Refresher,Informal,Student,Visitor", MAXLEN = 9, SELECTIVITY = "16.6667%", VALUELIST = ",E,R,I,S,V") [ SqlColumnNumber = 9, SqlFieldName = CLCP_Type ];

Property CLCPHospitslDr As DHCCLHospital [ SqlColumnNumber = 10, SqlFieldName = CLCP_Hospitsl_Dr ];

/// ANO_EditFlag
Property CLCPEditFlag As %Library.String(DISPLAYLIST = ",Normal,Edit,Changed,Delete,Removed", MAXLEN = 7, SELECTIVITY = "16.6667%", TRUNCATE = 1, VALUELIST = ",N,E,C,D,R") [ SqlColumnNumber = 11, SqlFieldName = CLCP_EditFlag ];

Index CtLoc On CLCPCTLOCDr As Exact;

Index Desc On CLCPDesc As Exact;

Index Alias On CLCPAlias As Exact;

Storage CacheStorage
{
<Data name="DHCCLCareProvDefaultData">
<Subscript>"1"</Subscript>
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CLCPEditFlag</Value>
</Value>
</Data>
<Data name="DataMaster">
<Value name="1">
<Value>CLCPCTLOCDr</Value>
</Value>
<Value name="2">
<Value>CLCPDesc</Value>
</Value>
<Value name="3">
<Value>CLCPAlias</Value>
</Value>
<Value name="4">
<Value>CLCPFromDate</Value>
</Value>
<Value name="5">
<Value>CLCPToDate</Value>
</Value>
<Value name="6">
<Value>CLCPInActive</Value>
</Value>
<Value name="7">
<Value>CLCPIfDoctor</Value>
</Value>
<Value name="8">
<Value>CLCPType</Value>
</Value>
<Value name="9">
<Value>CLCPHospitslDr</Value>
</Value>
</Data>
<DataLocation>^DHCCLCP</DataLocation>
<DefaultData>DHCCLCareProvDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCCLCP</IdLocation>
<IndexLocation>^DHCCLCPI</IndexLocation>
<SqlRowIdName>CLCP_RowId</SqlRowIdName>
<StreamLocation>^User.DHCCLCareProvS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
