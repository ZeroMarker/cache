Class User.DHCEQWashList Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = WL_RowID, SqlTableName = DHC_EQWashList, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// WL_WashDR
Property WLWashDR As User.DHCEQWash [ SqlColumnNumber = 2, SqlFieldName = WL_WashDR ];

/// WL_MasterItemDR
Property WLMasterItemDR As User.DHCEQCMasterItem [ SqlColumnNumber = 3, SqlFieldName = WL_MasterItemDR ];

/// WL_ModelDR
Property WLModelDR As User.DHCEQCModel [ SqlColumnNumber = 4, SqlFieldName = WL_ModelDR ];

/// WL_QuantityNum
Property WLQuantityNum As %Library.Numeric(SCALE = 0) [ SqlColumnNumber = 5, SqlFieldName = WL_QuantityNum ];

/// WL_LocDR
Property WLLocDR As User.CTLoc [ SqlColumnNumber = 6, SqlFieldName = WL_LocDR ];

/// WL_LocSendUserDR
Property WLLocSendUserDR As User.SSUser [ SqlColumnNumber = 7, SqlFieldName = WL_LocSendUserDR ];

/// WL_ReturnUserDR
Property WLReturnUserDR As User.SSUser [ SqlColumnNumber = 8, SqlFieldName = WL_ReturnUserDR ];

/// WL_ReceiveUserDR
Property WLReceiveUserDR As User.SSUser [ SqlColumnNumber = 9, SqlFieldName = WL_ReceiveUserDR ];

/// WL_Hold1
Property WLHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = WL_Hold1 ];

/// WL_Hold2
Property WLHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = WL_Hold2 ];

/// WL_Hold3
Property WLHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = WL_Hold3 ];

/// WL_Hold4
Property WLHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = WL_Hold4 ];

/// WL_Hold5
Property WLHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = WL_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQWashList("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="WL_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="WL_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="WL_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="WL_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="WL_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="WL_LocDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="WL_LocSendUserDR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="WL_MasterItemDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="WL_ModelDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="WL_QuantityNum">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="WL_ReceiveUserDR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="WL_ReturnUserDR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="WL_WashDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCEQWashList</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>WL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{WL_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexLoc">
<Global>^DHCEQWashList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Loc"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{WL_LocDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{WL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMasterItem">
<Global>^DHCEQWashList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"MasterItem"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{WL_MasterItemDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{WL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexWash">
<Global>^DHCEQWashList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Wash"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{WL_WashDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{WL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQWashListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
