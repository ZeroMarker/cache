/// MRC ICD Keywords        (MRCIK,345)
Class User.MRCICDkeyw Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = MRC_ICDkeyw, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On MRCIKChildsub [ IdKey, PrimaryKey, Unique ];

/// Des Ref to MRCID
Relationship MRCIKMRCIDParRef As MRCICDDx [ Cardinality = parent, Inverse = ChildMRCICDkeyw, Required, SqlFieldName = MRCIK_MRCID_ParRef ];

/// Name
Property MRCIKName As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = MRCIK_Name ];

/// MRCIK Childsub (NewKey)
Property MRCIKChildsub As %Numeric(SCALE = 0) [ InitialExpression = {$i(^MRC("ID",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"IK",0))}, SqlColumnNumber = 4, SqlFieldName = MRCIK_Childsub ];

/// Location
Property MRCIKLocation As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = MRCIK_Location ];

/// Name1
Property MRCIKName1 As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = MRCIK_Name1 ];

/// Name2
Property MRCIKName2 As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = MRCIK_Name2 ];

/// Name All
Property MRCIKNameAll As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = MRCIK_NameAll ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.MRCICDkeyw).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCICDkeyw","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.MRCICDkeyw).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCICDkeyw","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.MRCICDkeyw).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCICDkeyw","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.MRCICDkeyw).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCICDkeyw","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.MRCICDkeyw).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCICDkeyw","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCICDkeyw","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>1000000</ExtentSize>
<Property name="MRCIKChildsub">
<Selectivity>2.8571%</Selectivity>
</Property>
<Property name="MRCIKLocation">
<Selectivity>99.9993%</Selectivity>
</Property>
<Property name="MRCIKMRCIDParRef">
<Selectivity>0.0050%</Selectivity>
</Property>
<Property name="MRCIKName">
<Selectivity>0.0895%</Selectivity>
</Property>
<SQLMap name="DataMasterMRCIK">
<Data name="MRCIK_Location">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MRCIK_Name">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MRCIK_Name1">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MRCIK_Name2">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MRCIK_NameAll">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^MRC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>MRC_ICDDx.MRCID_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>MRCIK_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"ID"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{MRC_ICDDx.MRCID_RowId}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"IK"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MRCIK_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexLOC2">
<Global>^MRC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>MRC_ICDDx.MRCID_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>MRCIK_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ID"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Loc2"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MRCIK_Location}</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({MRCIK_Name2})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{MRC_ICDDx.MRCID_RowId}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{MRCIK_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocAll">
<Global>^MRC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>MRC_ICDDx.MRCID_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>MRCIK_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ID"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"LocAll"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MRCIK_Location}</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({MRCIK_NameAll})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{MRC_ICDDx.MRCID_RowId}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{MRCIK_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocation">
<Global>^MRC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>MRC_ICDDx.MRCID_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>MRCIK_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ID"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Loc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MRCIK_Location}</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({MRCIK_Name})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{MRC_ICDDx.MRCID_RowId}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{MRCIK_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMRCIKName">
<Global>^MRC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>MRC_ICDDx.MRCID_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>MRCIK_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"IK_Name"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({MRCIK_Name})</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MRC_ICDDx.MRCID_RowId}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MRCIK_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexName1">
<Global>^MRC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>MRC_ICDDx.MRCID_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>MRCIK_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ID"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Loc1"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MRCIK_Location}</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({MRCIK_Name1})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{MRC_ICDDx.MRCID_RowId}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{MRCIK_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>MRCIK_RowId</SqlRowIdName>
<StreamLocation>^User.MRCICDkeywS</StreamLocation>
<Type>%Storage.SQL</Type>
}

Parameter EXTENTSIZE = 1000000;

}
