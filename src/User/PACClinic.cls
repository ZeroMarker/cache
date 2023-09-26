/// Clinic(2372)
Class User.PACClinic Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_Clinic, StorageStrategy = SQLStorage ]
{

/// Code
Property CLNCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = CLN_Code ];

/// Description
Property CLNDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = CLN_Desc ];

/// Address1
Property CLNAddress1 As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = CLN_Address1 ];

/// Address2
Property CLNAddress2 As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = CLN_Address2 ];

/// Des Ref City
Property CLNCityDR As CTCity [ SqlColumnNumber = 6, SqlFieldName = CLN_City_DR ];

/// Des Ref Zip
Property CLNZipDR As CTZip [ SqlColumnNumber = 7, SqlFieldName = CLN_Zip_DR ];

/// Phone
Property CLNPhone As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = CLN_Phone ];

/// Fax
Property CLNFax As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = CLN_Fax ];

/// Email
Property CLNEmail As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = CLN_Email ];

/// VEMD
Property CLNVEMD As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = CLN_VEMD ];

/// Date From
Property CLNDateFrom As %Date [ SqlColumnNumber = 12, SqlFieldName = CLN_DateFrom ];

/// Date To
Property CLNDateTo As %Date [ SqlColumnNumber = 13, SqlFieldName = CLN_DateTo ];

/// ProviderNo
Property CLNProviderNo As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = CLN_ProviderNo ];

/// Business Phone
Property CLNBusPhone As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = CLN_BusPhone ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACClinic).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACClinic","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACClinic).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACClinic","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACClinic).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACClinic","OnAfterUpdate")

 d POFILUPD^at2372
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACClinic).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACClinic","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACClinic).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACClinic","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^PAC("CLN",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="CLN_Address1">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CLN_Address2">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CLN_BusPhone">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="CLN_City_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CLN_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CLN_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="CLN_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="CLN_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CLN_Email">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CLN_Fax">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CLN_Phone">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CLN_ProviderNo">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="CLN_VEMD">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="CLN_Zip_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CLN_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CLN"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{CLN_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CLN_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CLN"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({CLN_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CLN_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CLN_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CLN"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({CLN_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CLN_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexProvider">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CLN_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CLN"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ProvNo"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CLN_ProviderNo}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CLN_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>CLN_RowId</SqlRowIdName>
<StreamLocation>^User.PACClinicS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
