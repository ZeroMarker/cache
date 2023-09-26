/// 基础数据平台-临床知识库-诊断字典表
Class User.DHCExtIcdFeild Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = ICD_RowId, SqlTableName = DHC_ExtIcdFeild, StorageStrategy = SQLStorage ]
{

// ^DHCEXTICD

Parameter EXTENTSIZE = 250;

Property ICDCode As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = ICD_Code ];

Property ICDDesc As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ICD_Desc ];

Property ICDType As %String(DISPLAYLIST = ",ICD9,ICD10,非ICD", VALUELIST = ",9,10,99") [ SqlColumnNumber = 4, SqlFieldName = ICD_Type ];

Property ICDAcitveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = ICD_ActiveFlag ];

Property ICDSysFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = ICD_SysFlag ];

// 谷雪萍 2016-5-17 操作状态

Property ICDOpStatus As %String(DISPLAYLIST = ",放弃,确认", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",0,1") [ SqlColumnNumber = 7, SqlFieldName = ICD_OpStatus ];

// 备注

Property ICDRemark As %String(COLLATION = "Exact", MAXLEN = 1024, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = ICD_Remark ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEXTICD(0))</SqlIdExpression>
<SQLMap name="CodeIndex">
<Global>^DHCEXTICD</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ICD_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({ICD_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ICD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="DataMaster">
<Data name="ICD_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ICD_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ICD_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ICD_OpStatus">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ICD_Remark">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ICD_SysFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ICD_Type">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCEXTICD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ICD_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{ICD_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="DescIndex">
<Global>^DHCEXTICD</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ICD_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({ICD_Desc})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ICD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ICD_RowId</SqlRowIdName>
<StreamLocation>^User.DHCExtIcdFeildS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
