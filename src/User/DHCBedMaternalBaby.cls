/// DHC_Bed_MaternalBaby
Class User.DHCBedMaternalBaby Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = BMB_RowId, SqlTableName = DHC_Bed_MaternalBaby, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// BMB_Ward_Dr
Property BMBWardDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = BMB_Ward_Dr ];

/// BMB_MotherBedType_Dr
Property BMBMotherBedTypeDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = BMB_MotherBedType_Dr ];

/// BMB_MotherLeftOffset
Property BMBMotherLeftOffset As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = BMB_MotherLeftOffset ];

/// BMB_MotherTopOffset
Property BMBMotherTopOffset As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = BMB_MotherTopOffset ];

/// BMB_MonherIntervalX
Property BMBMotherIntervalX As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = BMB_MotherIntervalX ];

/// BMB_MotherIntervalY
Property BMBMotherIntervalY As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = BMB_MotherIntervalY ];

/// BMB_Width
Property BMBWidth As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = BMB_Width ];

/// BMB_Height
Property BMBHeight As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = BMB_Height ];

/// BMB_BabyIntervalY
Property BMBBabyIntervalY As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = BMB_BabyIntervalY ];

/// BMB_MaxAttachBabies
Property BMBMaxAttachBabies As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = BMB_MaxAttachBabies ];

/// BMB_User_Dr
Property BMBUserDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = BMB_User_Dr ];

/// BMB_UpdateDate
Property BMBUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 13, SqlFieldName = BMB_UpdateDate ];

/// BMB_UpdateTime
Property BMBUpdateTime As %Library.Time [ SqlColumnNumber = 14, SqlFieldName = BMB_UpdateTime ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCBed("MaternalBaby",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="BMB_BabyIntervalY">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="BMB_Height">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="BMB_MaxAttachBabies">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="BMB_MotherBedType_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="BMB_MotherIntervalX">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="BMB_MotherIntervalY">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="BMB_MotherLeftOffset">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="BMB_MotherTopOffset">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="BMB_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="BMB_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="BMB_User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="BMB_Ward_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="BMB_Width">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCBed</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>BMB_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"MaternalBaby"</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<Expression>{BMB_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexWard">
<Global>^DHCBed</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>BMB_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"MaternalBaby"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Ward"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BMB_Ward_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{BMB_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCBedMaternalBabyS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
