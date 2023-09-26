Class User.DHCAppReadRecord Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = RRE_RowID, SqlTableName = DHC_AppReadRecord, StorageStrategy = SQLStorage ]
{

/// 医嘱ID  RR_OrdItm_Dr 
Property RREOrdItmDr As User.OEOrdItem [ SqlColumnNumber = 2, SqlFieldName = RRE_OrdItm_Dr ];

/// 检查病理号/检验条码  RR_LabNo 
Property RRELabNo As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = RRE_LabNo ];

/// 科室ID  RR_Loc_Dr 
Property RRELocDr As User.CTLoc [ SqlColumnNumber = 4, SqlFieldName = RRE_Loc_Dr ];

/// 用户ID  RR_User_Dr 
Property RREUserDr As User.SSUser [ SqlColumnNumber = 5, SqlFieldName = RRE_User_Dr ];

/// 阅读日期  RR_Date 
Property RREDate As %Library.Date [ SqlColumnNumber = 6, SqlFieldName = RRE_Date ];

/// 阅读时间  RR_Time 
Property RRETime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = RRE_Time ];

/// 阅读类型  RR_Type 
Property RREType As %Library.String(DISPLAYLIST = ",Report,Image", MAXLEN = 8, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",R,I") [ SqlColumnNumber = 8, SqlFieldName = RRE_Type ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCAPPRRE)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="RRE_Date">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="RRE_LabNo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RRE_Loc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="RRE_OrdItm_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RRE_Time">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="RRE_Type">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="RRE_User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCAPPRRE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RRE_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{RRE_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexOrdItm">
<Global>^DHCAPPRRE</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RRE_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"IndexOrdItm"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RRE_OrdItm_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RRE_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCAppReadRecordD</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
