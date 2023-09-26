Class User.DHCICUPrintRecord Extends %Library.Persistent [ ClassType = persistent, ProcedureBlock, SqlRowIdName = ICUPR_RowId, SqlTableName = DHC_ICU_PrintRecord, StorageStrategy = CacheSQLStorage ]
{

Relationship ICUPRParref As User.DHCICUArrange [ Cardinality = parent, Inverse = ChildDHCICUPrintRecord, Required, SqlFieldName = ICUPR_Parref ];

Index RowIDBasedIDKeyIndex On ICUPRChildSub [ IdKey, PrimaryKey, Unique ];

/// For P5 ///Property ICUPRChildSub As %Float [ InitialExpression = {$i(^DHCICUArrange($p($s($d(p1):p1,1:%d(0)),$c(1),1),"PR",0))}, SqlColumnNumber = 2, SqlFieldName = ICUPR_ChildSub ];
Property ICUPRChildSub As %Float [ InitialExpression = {$i(^DHCICUArrange($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"PR",0))}, SqlColumnNumber = 2, SqlFieldName = ICUPR_ChildSub ];

Property ICUPRDate As %Date [ SqlColumnNumber = 3, SqlFieldName = ICUPR_Date ];

Property ICUPRTime As %Time [ SqlColumnNumber = 4, SqlFieldName = ICUPR_Time ];

Property ICUPRDateTimeSeq As %Integer [ SqlColumnNumber = 5, SqlFieldName = ICUPR_DateTimeSeq ];

Property ICUPRPage As %Integer [ SqlColumnNumber = 6, SqlFieldName = ICUPR_Page ];

Property ICUPRPageRow As %Integer [ SqlColumnNumber = 7, SqlFieldName = ICUPR_PageRow ];

Property ICUPRPrintUserDr As %String(TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = ICUPR_PrintUser_Dr ];

Property ICUPRPrintDate As %Date [ SqlColumnNumber = 9, SqlFieldName = ICUPR_PrintDate ];

Property ICUPRPrintTime As %Time [ SqlColumnNumber = 10, SqlFieldName = ICUPR_PrintTime ];

Property ICUPREndDate As %Date [ SqlColumnNumber = 11, SqlFieldName = ICUPR_EndDate ];

Property ICUPREndTime As %Time [ SqlColumnNumber = 12, SqlFieldName = ICUPR_EndTime ];

Storage CacheSQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCICUArrange("PR",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ICUPR_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ICUPR_DateTimeSeq">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ICUPR_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ICUPR_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ICUPR_Page">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ICUPR_PageRow">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ICUPR_PrintDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ICUPR_PrintTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ICUPR_PrintUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ICUPR_Time">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCICUArrange</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_ICU_Arrange.ICUA_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>ICUPR_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_ICU_Arrange.ICUA_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ICUPR_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^DHCICUArrange</Global>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHC_ICU_Arrange.ICUA_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>ICUPR_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PrintDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_ICU_Arrange.ICUA_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ICUPR_Date}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ICUPR_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPage">
<Global>^DHCICUArrange</Global>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHC_ICU_Arrange.ICUA_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>ICUPR_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PrintPage"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_ICU_Arrange.ICUA_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ICUPR_Page}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ICUPR_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCICUPrintRecordS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
