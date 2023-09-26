Class User.DHCStkDecimalItm Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = SDI_RowID, SqlTableName = DHC_StkDecimalItm, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On SDIChildsub [ IdKey, PrimaryKey, Unique ];

/// DHC_StkDecimal Parent Reference
Relationship SDISDParref As User.DHCStkDecimal [ Cardinality = parent, Inverse = ChildDHCStkDecimalItm, Required, SqlFieldName = SDI_SD_Parref ];

/// SDI_Childsub
Property SDIChildsub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = SDI_Childsub ];

/// SDI_Min
Property SDIMin As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = SDI_Min ];

/// SDI_Max
Property SDIMax As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = SDI_Max ];

/// SDI_DecimalLen
Property SDIDecimalLen As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = SDI_DecimalLen ];

Property SDIRoundType As %Library.String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = SDI_RoundType ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="SDI_DecimalLen">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SDI_Max">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SDI_Min">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SDI_RoundType">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCSD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_StkDecimal.SD_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>SDI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DHC_StkDecimal.SD_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SDI_Childsub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCStkDecimalItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
