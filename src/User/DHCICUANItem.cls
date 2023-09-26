Class User.DHCICUANItem Extends %Library.Persistent [ ClassType = persistent, ProcedureBlock, SqlRowIdName = ICUANI_RowId, SqlTableName = DHC_ICU_ANItem, StorageStrategy = CacheSQLStorage ]
{

Relationship ICUANIParref As User.DHCICUArrange [ Cardinality = parent, Inverse = ChildDHCICUANItem, Required ];

/// For P5 ///Property ICUANIChildSub As %Numeric(SCALE = 0) [ InitialExpression = {$i(^DHCICUArrange($p($s($d(p1):p1,1:%d(0)),$c(1),1),"AN",0))}, Required, SqlColumnNumber = 2, SqlFieldName = ICUANI_ChildSub ];
Property ICUANIChildSub As %Numeric(SCALE = 0) [ InitialExpression = {$i(^DHCICUArrange($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"AN",0))}, Required, SqlColumnNumber = 2, SqlFieldName = ICUANI_ChildSub ];

Index ICUANIChildSubIndex On ICUANIChildSub [ IdKey, PrimaryKey, Unique ];

Property ICUANIDate As %Date [ SqlColumnNumber = 3, SqlFieldName = ICUANI_Date ];

Property ICUANITime As %Time [ SqlColumnNumber = 4, SqlFieldName = ICUANI_Time ];

Property ICUANIOpaDr As User.DHCANOPArrange [ SqlColumnNumber = 5, SqlFieldName = ICUANI_Opa_Dr ];

Property ICUANIAnMethodDr As %String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = ICUANI_AnMethod_Dr ];

Property ICUANIOperationDr As %String(TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = ICUANI_Operation_Dr ];

Property ICUANIAnalgesia As %String(TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = ICUANI_Analgesia ];

Property ICUANIAmtBloodLoss As %Float [ SqlColumnNumber = 9, SqlFieldName = ICUANI_AmtBloodLoss ];

Property ICUANIAmtUrineOutput As %Float [ SqlColumnNumber = 10, SqlFieldName = ICUANI_AmtUrineOutput ];

Property ICUANIAmtFluidInfused As %Numeric [ SqlColumnNumber = 11, SqlFieldName = ICUANI_AmtFluidInfused ];

Property ICUANIAmtBloodTranfused As %Float [ SqlColumnNumber = 12, SqlFieldName = ICUANI_AmtBloodTranfused ];

Property ICUANIReturnConsciousness As %String(TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = ICUANI_ReturnConsciousness ];

Property ICUANIReturnPositionDr As %String(TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = ICUANI_ReturnPosition_Dr ];

Property ICUANIReturnDate As %Date [ SqlColumnNumber = 15, SqlFieldName = ICUANI_ReturnDate ];

Property ICUANIReturnTime As %Time [ SqlColumnNumber = 16, SqlFieldName = ICUANI_ReturnTime ];

Property ICUANINote As %String(TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = ICUANI_Note ];

Storage CacheSQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="ICUANI_AmtBloodLoss">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ICUANI_AmtBloodTranfused">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ICUANI_AmtFluidInfused">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ICUANI_AmtUrineOutput">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ICUANI_AnMethod_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ICUANI_Analgesia">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ICUANI_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ICUANI_Note">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="ICUANI_Opa_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ICUANI_Operation_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ICUANI_ReturnConsciousness">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ICUANI_ReturnDate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="ICUANI_ReturnPosition_Dr">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ICUANI_ReturnTime">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="ICUANI_Time">
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
<Field>ICUANI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_ICU_Arrange.ICUA_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AN"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ICUANI_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCICUANItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
