Class User.DHCICUCollectData Extends %Library.Persistent [ ProcedureBlock, SqlRowIdName = ICUCD_RowId, SqlTableName = DHC_ICU_CollectData, StorageStrategy = CacheSQLStorage ]
{

Relationship ICUCDParref As User.DHCICUArrange [ Cardinality = parent, Inverse = ChildDHCICUCollectData, SqlFieldName = ICUCD_Parref ];

Index ICUCDChildSub On ICUCDChildSub [ IdKey, PrimaryKey, Unique ];

/// For P5 ///Property ICUCDChildSub As %Numeric [ InitialExpression = {$i(^DHCICUArrange($p($s($d(p1):p1,1:%d(0)),$c(1),1),"C",0))}, Required, SqlColumnNumber = 2, SqlFieldName = ICUCD_ChildSub ];
Property ICUCDChildSub As %Numeric [ InitialExpression = {$i(^DHCICUArrange($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"C",0))}, Required, SqlColumnNumber = 2, SqlFieldName = ICUCD_ChildSub ];

Property ICUCDComOrdDr As User.DHCICUCRecordItem [ SqlColumnNumber = 3, SqlFieldName = ICUCD_ComOrd_Dr ];

Property ICUCDStartDate As %Date [ SqlColumnNumber = 4, SqlFieldName = ICUCD_StartDate ];

Property ICUCDStartTime As %Time [ SqlColumnNumber = 5, SqlFieldName = ICUCD_StartTime ];

Property ICUCDNote As %String [ SqlColumnNumber = 6, SqlFieldName = ICUCD_Note ];

Property ICUCDQty As %Float [ SqlColumnNumber = 7, SqlFieldName = ICUCD_Qty ];

Property ICUCDUpdateDate As %Date [ SqlColumnNumber = 8, SqlFieldName = ICUCD_UpdateDate ];

Property ICUCDUpdateTime As %Time [ SqlColumnNumber = 9, SqlFieldName = ICUCD_UpdateTime ];

Storage CacheSQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="ICUCD_ComOrd_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ICUCD_Note">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ICUCD_Qty">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ICUCD_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ICUCD_StartTime">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ICUCD_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ICUCD_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCICUArrange</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_ICU_Arrange.ICUA_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>ICUCD_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_ICU_Arrange.ICUA_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"C"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ICUCD_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCollectDateTime">
<Global>^DHCICUArrange</Global>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHC_ICU_Arrange.ICUA_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>ICUCD_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CData"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_ICU_Arrange.ICUA_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ICUCD_StartDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>+{ICUCD_StartTime}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ICUCD_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ICUCD_RowId</SqlRowIdName>
<SqlTableNumber>DHC_ICU_CollectData</SqlTableNumber>
<StreamLocation>^User.DHCICUCollectDataS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
