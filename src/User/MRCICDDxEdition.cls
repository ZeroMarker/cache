/// ICDDxEdition(2175)
Class User.MRCICDDxEdition Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = MRC_ICDDxEdition, StorageStrategy = SQLStorage ]
{

/// Childsub
Property EDChildsub As %Float [ InitialExpression = {$i(^MRC("ID",$p(%d(0),$c(1)),"ED",0))}, SqlColumnNumber = 2, SqlFieldName = ED_Childsub ];

/// DateFrom
Property EDDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = ED_DateFrom ];

/// DateTo
Property EDDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = ED_DateTo ];

/// Des Ref Edition
Property EDEditionDR As MRCICDEdition [ SqlColumnNumber = 3, SqlFieldName = ED_Edition_DR ];

/// MRC_ICDDx Parent Reference
Relationship EDParRef As MRCICDDx [ Cardinality = parent, Inverse = ChildMRCICDDxEdition, Required, SqlFieldName = ED_ParRef ];

Index RowIDBasedIDKeyIndex On EDChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 13;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.MRCICDDxEdition).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRCICDDxEdition","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.MRCICDDxEdition).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRCICDDxEdition","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.MRCICDDxEdition).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRCICDDxEdition","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.MRCICDDxEdition).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRCICDDxEdition","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.MRCICDDxEdition).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRCICDDxEdition","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>13</ExtentSize>
<Property name="EDChildsub">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="EDDateFrom">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="EDDateTo">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="EDEditionDR">
<Selectivity>16.6667%</Selectivity>
</Property>
<Property name="EDParRef">
<Selectivity>12.5000%</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="ED_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ED_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ED_Edition_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^MRC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>MRC_ICDDx.MRCID_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>ED_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ID"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{MRC_ICDDx.MRCID_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ED"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ED_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexEdition">
<Global>^MRC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>MRC_ICDDx.MRCID_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>ED_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ID"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{MRC_ICDDx.MRCID_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ED"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"Edition"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ED_Edition_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ED_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ED_RowId</SqlRowIdName>
<StreamLocation>^User.MRCICDDxEditionS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
