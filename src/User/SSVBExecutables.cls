/// VB Executables         (SSVBE,1145)
Class User.SSVBExecutables Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_VBExecutables, StorageStrategy = SQLStorage ]
{

Relationship ChildSSVBExecFields As SSVBExecFields [ Cardinality = children, Inverse = FLDParRef ];

Relationship ChildSSVBExecTranslation As SSVBExecTranslation [ Cardinality = children, Inverse = EXTRParRef ];

Relationship ChildSSVBMenuOptions As SSVBMenuOptions [ Cardinality = children, Inverse = SSVBOParRef ];

/// Code For the VB Executable
Property SSVBECode As %String(COLLATION = "Upper", MAXLEN = 10, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = SSVBE_Code ];

/// Description of the VB Executable
Property SSVBEDescription As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = SSVBE_Description ];

/// Display icon for executable
Property SSVBEDisplay As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ Required, SqlColumnNumber = 5, SqlFieldName = SSVBE_Display ];

/// Name of the Executable
Property SSVBEName As %String(COLLATION = "AlphaUp", MAXLEN = 20, TRUNCATE = 1) [ Required, SqlColumnNumber = 4, SqlFieldName = SSVBE_Name ];

/// Parameter
Property SSVBEParameter As %String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = SSVBE_Parameter ];

Index SSVBECodeUnqIdx1 On SSVBECode [ Unique ];

Parameter EXTENTSIZE = 346;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.SSVBExecutables).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSVBExecutables","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.SSVBExecutables).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSVBExecutables","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.SSVBExecutables).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSVBExecutables","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.SSVBExecutables).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSVBExecutables","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.SSVBExecutables).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSVBExecutables","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>346</ExtentSize>
<Property name="SSVBECode">
<Selectivity>1</Selectivity>
</Property>
<Property name="SSVBEDescription">
<Selectivity>1</Selectivity>
</Property>
<Property name="SSVBEDisplay">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="SSVBEName">
<Selectivity>1</Selectivity>
</Property>
<Property name="SSVBEParameter">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^SS("SSVBE",0))</SqlIdExpression>
<SQLMap name="IndextoDescription">
<Global>^SS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SSVBE_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"SSVBE"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({SSVBE_Description})</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{SSVBE_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndextoExecutable">
<Global>^SS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SSVBE_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"SSVBE"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"Executable"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({SSVBE_Name})</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{SSVBE_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="SSVBEMaster">
<Data name="SSVBE_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SSVBE_Description">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SSVBE_Display">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SSVBE_Name">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SSVBE_Parameter">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^SS</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SSVBE_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SSVBE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SSVBE_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>SSVBE_RowID</SqlRowIdName>
<StreamLocation>^User.SSVBExecutablesS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
