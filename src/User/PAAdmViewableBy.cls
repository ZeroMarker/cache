/// Adm Viewable By(2283)
Class User.PAAdmViewableBy Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_AdmViewableBy, StorageStrategy = SQLStorage ]
{

/// Des Ref CTLOC
Property VIEWCTLOCDR As CTLoc [ SqlColumnNumber = 6, SqlFieldName = VIEW_CTLOC_DR ];

/// Des Ref CareProv
Property VIEWCareProvDR As CTCareProv [ SqlColumnNumber = 5, SqlFieldName = VIEW_CareProv_DR ];

/// Des Ref CareProvType
Property VIEWCareProvTypeDR As CTCarPrvTp [ SqlColumnNumber = 7, SqlFieldName = VIEW_CareProvType_DR ];

/// Childsub
Property VIEWChildsub As %Float [ InitialExpression = {$i(^PAADM($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"VIEW",0))}, SqlColumnNumber = 2, SqlFieldName = VIEW_Childsub ];

/// Date From
Property VIEWDateFrom As %Date [ SqlColumnNumber = 3, SqlFieldName = VIEW_DateFrom ];

/// Date To
Property VIEWDateTo As %Date [ SqlColumnNumber = 4, SqlFieldName = VIEW_DateTo ];

/// PA_Adm Parent Reference
Relationship VIEWParRef As PAAdm [ Cardinality = parent, Inverse = ChildPAAdmViewableBy, Required, SqlFieldName = VIEW_ParRef ];

Index RowIDBasedIDKeyIndex On VIEWChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 15;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PAAdmViewableBy).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdmViewableBy","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PAAdmViewableBy).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdmViewableBy","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PAAdmViewableBy).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdmViewableBy","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PAAdmViewableBy).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdmViewableBy","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PAAdmViewableBy).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdmViewableBy","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>15</ExtentSize>
<Property name="VIEWCTLOCDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="VIEWCareProvDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="VIEWCareProvTypeDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="VIEWChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="VIEWDateFrom">
<Selectivity>1</Selectivity>
</Property>
<Property name="VIEWDateTo">
<Selectivity>1</Selectivity>
</Property>
<Property name="VIEWParRef">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="VIEW_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="VIEW_CareProvType_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="VIEW_CareProv_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="VIEW_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="VIEW_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^PAADM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_Adm.PAADM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>VIEW_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_Adm.PAADM_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"VIEW"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{VIEW_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>VIEW_RowId</SqlRowIdName>
<StreamLocation>^User.PAAdmViewableByS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
