/// PHC Generic             (PHCGE,135)
Class User.PHCGeneric Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlTableName = PHC_Generic, StorageStrategy = SQLStorage ]
{

Relationship ChildPHCGenericIngr As PHCGenericIngr [ Cardinality = children, Inverse = INGRParRef ];

Relationship ChildPHCGenericAlrgGroup As PHCGenericAlrgGroup [ Cardinality = children, Inverse = ALGParRef ];

Relationship ChildPHCGenericAlrgXSens As PHCGenericAlrgXSens [ Cardinality = children, Inverse = ALXSParRef ];

Relationship ChildPHCGenericRtForms As PHCGenericRtForms [ Cardinality = children, Inverse = RTFParRef ];

Relationship ChildPHCGenericInter As PHCGenericInter [ Cardinality = children, Inverse = INTParRef ];

/// Generic Name
Property PHCGEName As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = PHCGE_Name ];

/// Generic Code
Property PHCGECode As %String(COLLATION = "AlphaUp", MAXLEN = 100, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = PHCGE_Code ];

/// Des Ref to PHCCL
Property PHCGEPHCCLDR As PHCClass [ SqlColumnNumber = 4, SqlFieldName = PHCGE_PHCCL_DR ];

/// Generic Type
Property PHCGEType As %String(COLLATION = "AlphaUp", MAXLEN = 2, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = PHCGE_Type ];

/// Date From
Property PHCGEDateFrom As %Date [ SqlColumnNumber = 6, SqlFieldName = PHCGE_DateFrom ];

/// Date To
Property PHCGEDateTo As %Date [ SqlColumnNumber = 7, SqlFieldName = PHCGE_DateTo ];

/// DaysAfterMedsInterActive
Property PHCGEDaysAfterMedsInterActive As %Float [ SqlColumnNumber = 8, SqlFieldName = PHCGE_DaysAfterMedsInterActive ];

Index PHCGECodeUnqIdx1 On PHCGECode [ Unique ];

Index PHCGENameUnqIdx2 On PHCGEName [ Unique ];

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PHCGeneric).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PHCGeneric","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PHCGeneric).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PHCGeneric","OnAfterUpdate")
 d POFILUPD^at135
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PHCGeneric).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PHCGeneric","OnBeforeDelete")
 d VALDEL^at135({PHCGE_RowId})
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PHCGeneric).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PHCGeneric","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PHCGeneric","OnBeforeInsert")
}

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PHCGeneric).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PHCGeneric","OnAfterDelete")
}

Parameter EXTENTSIZE = 1000000;

Storage SQLStorage
{
<ExtentSize>1000000</ExtentSize>
<SqlIdExpression>$i(^PHCGE("GE",0))</SqlIdExpression>
<SQLMap name="DataMasterPHCGE">
<Data name="PHCGE_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHCGE_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHCGE_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PHCGE_DaysAfterMedsInterActive">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PHCGE_Name">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHCGE_PHCCL_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHCGE_Type">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^PHCGE</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PHCGE_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"GE"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{PHCGE_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPHCGECode">
<Global>^PHCGE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PHCGE_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"GE"</Expression>
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
<Expression>$$ALPHAUP({PHCGE_Code})</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{PHCGE_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPHCGEName">
<Global>^PHCGE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PHCGE_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"GE"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"Name"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({PHCGE_Name})</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{PHCGE_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPHCGEType">
<Global>^PHCGE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PHCGE_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"GE"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"Type"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({PHCGE_Type})</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{PHCGE_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PHCGE_RowId</SqlRowIdName>
<StreamLocation>^User.PHCGenericS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
