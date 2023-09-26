/// Tumor Metatstatic(2251)
Class User.PATumorMetatstatic Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_TumorMetatstatic, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On METChildsub [ IdKey, PrimaryKey, Unique ];

/// PA_Tumor Parent Reference
Relationship METParRef As PATumor [ Cardinality = parent, Inverse = ChildPATumorMetatstatic, Required, SqlFieldName = MET_ParRef ];

/// Childsub
Property METChildsub As %Float [ InitialExpression = {$i(^PATUM($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"MET",0))}, SqlColumnNumber = 2, SqlFieldName = MET_Childsub ];

/// Des Ref ICD
Property METMetastaticDR As MRCICDDx [ SqlColumnNumber = 3, SqlFieldName = MET_Metastatic_DR ];

/// Metastatic Site
Property METMetastaticSite As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = MET_MetastaticSite ];

/// UpdateDate
Property METUpdateDate As %Date [ SqlColumnNumber = 5, SqlFieldName = MET_UpdateDate ];

/// UpdateTime
Property METUpdateTime As %Time [ SqlColumnNumber = 6, SqlFieldName = MET_UpdateTime ];

/// Des Ref UpdateUser
Property METUpdateUserDR As SSUser [ SqlColumnNumber = 7, SqlFieldName = MET_UpdateUser_DR ];

/// Des Ref UpdateUserHospital
Property METUpdateUserHospitalDR As CTHospital [ SqlColumnNumber = 8, SqlFieldName = MET_UpdateUserHospital_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PATumorMetatstatic).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PATumorMetatstatic","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PATumorMetatstatic).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PATumorMetatstatic","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PATumorMetatstatic).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PATumorMetatstatic","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PATumorMetatstatic).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PATumorMetatstatic","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PATumorMetatstatic).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PATumorMetatstatic","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="MET_MetastaticSite">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MET_Metastatic_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MET_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MET_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MET_UpdateUserHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MET_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^PATUM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_Tumor.TUM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>MET_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_Tumor.TUM_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"MET"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MET_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>MET_RowId</SqlRowIdName>
<StreamLocation>^User.PATumorMetatstaticS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
