/// DHC_ANC_Icon
Class User.DHCANCIcon Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ANI_RowId, SqlTableName = DHC_ANC_Icon, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// ANI_Code
Property ANICode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = ANI_Code ];

/// ANI_Desc
Property ANIDesc As %Library.String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ANI_Desc ];

/// ANI_Count
Property ANICount As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = ANI_Count ];

/// ANI_Height
Property ANIHeight As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = ANI_Height ];

/// ANI_Width
Property ANIWidth As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = ANI_Width ];

/// ANI_PositionX
Property ANIPositionX As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = ANI_PositionX ];

/// ANI_PositionY
Property ANIPositionY As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = ANI_PositionY ];

/// ANI_LineWidth
Property ANILineWidth As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = ANI_LineWidth ];

/// ANI_Shape
Property ANIShape As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = ANI_Shape ];

/// ANI_Data
Property ANIData As %Library.String(COLLATION = "Exact", MAXLEN = 80, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = ANI_Data ];

/// ANI_AnApply
Property ANIAnApply As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 12, SqlFieldName = ANI_AnApply ];

/// ANI_IcuApply
Property ANIIcuApply As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = ANI_IcuApply ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCANC("Icon",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ANI_AnApply">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ANI_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ANI_Count">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ANI_Data">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ANI_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ANI_Height">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ANI_IcuApply">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ANI_LineWidth">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ANI_PositionX">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ANI_PositionY">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ANI_Shape">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ANI_Width">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCANC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ANI_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Icon"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ANI_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCANCIconS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
