Class User.DHCEmTimeInterval Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ER_RowID, SqlTableName = DHC_EmTimeInterval, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// ER_Code
Property ERCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = ER_Code ];

/// ER_Desc
Property ERDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ER_Desc ];

/// 开始时间  ER_StartTime
Property ERStartTime As %Time [ SqlColumnNumber = 4, SqlFieldName = ER_StartTime ];

/// 结束时间  ER_EndTime
Property EREndTime As %Time [ SqlColumnNumber = 5, SqlFieldName = ER_EndTime ];

/// 是否可用  ER_ActiveFlag
Property ERActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = ER_ActiveFlag ];

/// 集团化医院  ER_Hosp_Dr
Property ERHospDr As User.CTHospital [ SqlColumnNumber = 7, SqlFieldName = ER_Hosp_Dr ];

/// 模块  ER_Module
Property ERModule As %Library.String [ SqlColumnNumber = 8, SqlFieldName = ER_Module ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEMTI)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ER_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ER_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ER_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ER_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ER_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ER_Module">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ER_StartTime">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCEMTI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ER_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{ER_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCEMTI</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ER_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({ER_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ER_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCEMTI</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ER_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({ER_Desc})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ER_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEmTimeIntervalS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
