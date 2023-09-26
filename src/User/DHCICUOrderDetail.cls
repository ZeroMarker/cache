Class User.DHCICUOrderDetail Extends %Library.Persistent [ ProcedureBlock, SqlRowIdName = ICUOD_RowId, SqlTableName = DHC_ICU_OrderDetail, StorageStrategy = CacheSQLStorage ]
{

Relationship ICUODParref As User.DHCICUOrder [ Cardinality = parent, Inverse = ChildDHCICUOrderDetail, SqlFieldName = ICUOD_Parref ];

Index ICUODChildSubIndex On ICUODChildSub [ IdKey, PrimaryKey, Unique ];

/// For P5 ///Property ICUODChildSub As %Float [ InitialExpression = {$i(^DHCICUOrder($p($s($d(p1):p1,1:%d(0)),$c(1),1),"D",0))}, Required, SqlColumnNumber = 2, SqlFieldName = ICUOD_ChildSub ];
Property ICUODChildSub As %Float [ InitialExpression = {$i(^DHCICUOrder($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"D",0))}, Required, SqlColumnNumber = 2, SqlFieldName = ICUOD_ChildSub ];

Property ICUODStartDate As %Date [ SqlColumnNumber = 3, SqlFieldName = ICUOD_StartDate ];

Property ICUODStartTime As %Time [ SqlColumnNumber = 4, SqlFieldName = ICUOD_StartTime ];

Property ICUODEndDate As %Date [ SqlColumnNumber = 5, SqlFieldName = ICUOD_EndDate ];

Property ICUODEndTime As %Time [ SqlColumnNumber = 6, SqlFieldName = ICUOD_EndTime ];

Property ICUODComOrdDr As User.DHCICUCRecordItem [ SqlColumnNumber = 7, SqlFieldName = ICUOD_ComOrd_Dr ];

Property ICUODAbbreviate As %String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = ICUOD_Abbreviate ];

Property ICUODQty As %Float [ SqlColumnNumber = 9, SqlFieldName = ICUOD_Qty ];

Property ICUODNote As %String [ SqlColumnNumber = 10, SqlFieldName = ICUOD_Note ];

Property ICUODUserDr As %String [ SqlColumnNumber = 11, SqlFieldName = ICUOD_User_Dr ];

Property ICUODUpdateDate As %Date [ SqlColumnNumber = 12, SqlFieldName = ICUOD_UpdateDate ];

Property ICUODUpdateTime As %Time [ SqlColumnNumber = 13, SqlFieldName = ICUOD_UpdateTime ];

Property ICUODEditFlag As %String(DISPLAYLIST = ",Normal,Edit,Changed,Delete,Removed", MAXLEN = 6, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",N,E,C,D,R") [ SqlColumnNumber = 14, SqlFieldName = ICUOD_EditFlag ];

Property ICUODICUODDr As User.DHCICUOrderDetail [ SqlColumnNumber = 15, SqlFieldName = ICUOD_ICUOD_Dr ];

Storage CacheSQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="ICUOD_Abbreviate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ICUOD_ComOrd_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ICUOD_EditFlag">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ICUOD_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ICUOD_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ICUOD_ICUOD_Dr">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="ICUOD_Note">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ICUOD_Qty">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ICUOD_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ICUOD_StartTime">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ICUOD_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ICUOD_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ICUOD_User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^DHCICUOrder</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_ICU_Order.ICUO_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>ICUOD_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_ICU_Order.ICUO_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"D"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ICUOD_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>ICUOD_RowId</SqlRowIdName>
<SqlTableNumber>DHC_ICU_OrderDetail</SqlTableNumber>
<StreamLocation>^User.DHCICUOrderDetailS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
