/// PH Manufacturer         (PHMNF,527)
Class User.PHManufacturer Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PH_Manufacturer, StorageStrategy = SQLStorage ]
{

/// Manufacturer Name
Property PHMNFName As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = PHMNF_Name ];

/// Address
Property PHMNFAddress As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = PHMNF_Address, SqlListType = SUBNODE ];

/// Contact Number
Property PHMNFTel As %String(COLLATION = "Exact", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = PHMNF_Tel ];

/// Manufacturer Code
Property PHMNFCode As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = PHMNF_Code ];

/// 简称
Property PHMNFShortName As %String(COLLATION = "AlphaUp", MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = PHMNF_ShortName ];

/// Hospital
Property PHMNFHospitalDR As User.CTHospital [ SqlColumnNumber = 9, SqlFieldName = PHMNF_Hospital_DR ];

/// Index PHMNFCodeUnqIdx1 On PHMNFCode [ Unique ];
Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PHManufacturer).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PHManufacturer","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PHManufacturer).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PHManufacturer","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PHManufacturer).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PHManufacturer","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PHManufacturer).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PHManufacturer","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PHManufacturer","OnBeforeInsert")
}

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PHManufacturer).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PHManufacturer","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^PHMNF(0))</SqlIdExpression>
<SQLMap name="DataMasterPHMNF">
<Data name="PHMNF_Address">
<Node>"Address"</Node>
</Data>
<Data name="PHMNF_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHMNF_Hospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHMNF_Name">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHMNF_ShortName">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHMNF_Tel">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^PHMNF</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHMNF_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PHMNF_RowId}</Expression>
<StartValue>1</StartValue>
<StopValue>999999999</StopValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexName">
<Global>^PHMNF</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHMNF_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Name"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({PHMNF_Name})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PHMNF_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPHMNFCode">
<Global>^PHMNF</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHMNF_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({PHMNF_Code})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PHMNF_RowId}</Expression>
<StartValue>1</StartValue>
<StopValue>999999999</StopValue>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PHMNF_RowId</SqlRowIdName>
<StreamLocation>^User.PHManufacturerS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
