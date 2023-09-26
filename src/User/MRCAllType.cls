/// MRC Allergy Type        (MRCAT,156)
Class User.MRCAllType Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = MRC_AllType, StorageStrategy = SQLStorage ]
{

/// Abbreviation
Property MRCATCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = MRCAT_Code ];

/// Description
Property MRCATDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = MRCAT_Desc ];

/// Status
Property MRCATStatus As %String(COLLATION = "Exact", MAXLEN = 12, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = MRCAT_Status ];

/// Icon Name
Property MRCATIconName As %String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = MRCAT_IconName ];

/// Icon Priority
Property MRCATIconPriority As %Float [ SqlColumnNumber = 6, SqlFieldName = MRCAT_IconPriority ];

/// Tag Description
Property MRCATTagDescription As %String(DISPLAYLIST = ",Generic,Pharmacy Item,Ingredient", MAXLEN = 13, TRUNCATE = 1, VALUELIST = ",G,P,I") [ SqlColumnNumber = 7, SqlFieldName = MRCAT_TagDescription ];

/// Sequence
Property MRCATSequence As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = MRCAT_Sequence ];

/// Indeterminate Code
Property MRCATIndeterminateCode As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = MRCAT_IndeterminateCode ];

/// Date From
Property MRCATDateFrom As %Date [ SqlColumnNumber = 10, SqlFieldName = MRCAT_DateFrom ];

/// Date To
Property MRCATDateTo As %Date [ SqlColumnNumber = 11, SqlFieldName = MRCAT_DateTo ];

Index MRCATCodeUnqIdx1 On MRCATCode [ Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.MRCAllType).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCAllType","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.MRCAllType).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCAllType","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.MRCAllType).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCAllType","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.MRCAllType).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCAllType","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.MRCAllType).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCAllType","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^MRC("AT",0))</SqlIdExpression>
<SQLMap name="MRCATDataMasterMap">
<Data name="MRCAT_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MRCAT_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="MRCAT_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="MRCAT_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MRCAT_IconName">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MRCAT_IconPriority">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MRCAT_IndeterminateCode">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="MRCAT_Sequence">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MRCAT_Status">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MRCAT_TagDescription">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^MRC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>MRCAT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"AT"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{MRCAT_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="MRCATIndexMRCATCode">
<Data name="MRCAT_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^MRC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MRCAT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"AT"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({MRCAT_Code})</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{MRCAT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MRCATIndexMRCATDesc">
<Data name="MRCAT_Desc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^MRC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MRCAT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"AT"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"MRCAA_Desc"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({MRCAT_Desc})</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{MRCAT_RowId}</Expression>
<StartValue>1</StartValue>
<StopValue>999999999</StopValue>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>MRCAT_RowId</SqlRowIdName>
<StreamLocation>^User.MRCAllTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
