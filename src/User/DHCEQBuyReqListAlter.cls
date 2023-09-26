Class User.DHCEQBuyReqListAlter Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = BRLA_RowID, SqlTableName = DHC_EQBuyReqListAlter, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// BRLA_BuyReqListDR
Property BRLABuyReqListDR As User.DHCEQBuyPlanList [ SqlColumnNumber = 2, SqlFieldName = BRLA_BuyReqListDR ];

/// BRLA_FirstFlag
Property BRLAFirstFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = BRLA_FirstFlag ];

/// BRLA_Hold1
Property BRLAHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = BRLA_Hold1 ];

/// BRLA_Hold2
Property BRLAHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = BRLA_Hold2 ];

/// BRLA_Hold3
Property BRLAHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = BRLA_Hold3 ];

/// BRLA_Hold4
Property BRLAHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = BRLA_Hold4 ];

/// BRLA_Hold5
Property BRLAHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = BRLA_Hold5 ];

/// BRLA_ManuFactory
Property BRLAManuFactory As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = BRLA_ManuFactory ];

/// BRLA_ManuFactoryDR
Property BRLAManuFactoryDR As User.DHCEQCManufacturer [ SqlColumnNumber = 6, SqlFieldName = BRLA_ManuFactoryDR ];

/// BRLA_Model
Property BRLAModel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = BRLA_Model ];

/// BRLA_ModelDR
Property BRLAModelDR As User.DHCEQCModel [ SqlColumnNumber = 4, SqlFieldName = BRLA_ModelDR ];

/// BRLA_Name
Property BRLAName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = BRLA_Name ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQBuyReqListAlter("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="BRLA_BuyReqListDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="BRLA_FirstFlag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="BRLA_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="BRLA_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="BRLA_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="BRLA_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="BRLA_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="BRLA_ManuFactory">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="BRLA_ManuFactoryDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="BRLA_Model">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="BRLA_ModelDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="BRLA_Name">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCEQBuyReqListAlter</Global>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{BRLA_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexBuyReqListDR">
<Global>^DHCEQBuyReqListAlter</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>BRLA_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"BuyReqListDR"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{BRLA_BuyReqListDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{BRLA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQBuyReqListAlterS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
