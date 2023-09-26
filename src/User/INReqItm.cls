/// IN Req Item Trf/Iss     (INRQI,286)
Class User.INReqItm Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlTableName = IN_ReqItm, StorageStrategy = SQLStorage ]
{

/// Des Ref to CTUOM
Property INRQICTUOMDR As CTUOM [ SqlColumnNumber = 12, SqlFieldName = INRQI_CTUOM_DR ];

/// INRQI Childsub (New Key)
Property INRQIChildsub As %Numeric(SCALE = 0) [ InitialExpression = {$i(^INRQ($p(%d(0),$c(1),1),"RQI",0))}, Required, SqlColumnNumber = 7, SqlFieldName = INRQI_Childsub ];

/// Date Needed
Property INRQIDate As %Date [ Required, SqlColumnNumber = 10, SqlFieldName = INRQI_Date ];

/// Des Ref to INCI
Property INRQIINCIDR As INCItm [ Required, SqlColumnNumber = 4, SqlFieldName = INRQI_INCI_DR ];

/// Des Ref To INRQ
Relationship INRQIINRQParRef As INRequest [ Cardinality = parent, Inverse = ChildINReqItm, Required, SqlFieldName = INRQI_INRQ_ParRef ];

/// Request Quantity
Property INRQIReqQty As %Float(MAXVAL = 999999999, MINVAL = 0) [ Required, SqlColumnNumber = 5, SqlFieldName = INRQI_ReqQty ];

/// Request Type
Property INRQIType As %String(DISPLAYLIST = ",Issue,Transfer", MAXLEN = 8, TRUNCATE = 1, VALUELIST = ",I,T") [ SqlColumnNumber = 13, SqlFieldName = INRQI_Type ];

/// Request RefuseFlag
Property INRQIRefuseFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 8, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 14, SqlFieldName = INRQI_RefuseFlag ];

Property INRQIREQITMDR As User.INReqItm [ SqlColumnNumber = 15, SqlFieldName = INRQI_REQITM_DR ];

Index RowIDBasedIDKeyIndex On INRQIChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 1;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.INReqItm).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.INReqItm","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.INReqItm).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.INReqItm","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.INReqItm).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.INReqItm","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.INReqItm).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.INReqItm","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.INReqItm).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.INReqItm","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>1</ExtentSize>
<Property name="INRQICTUOMDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INRQIChildsub">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INRQIDate">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INRQIINCIDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INRQIINRQParRef">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INRQIReqQty">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INRQIType">
<Selectivity>33.3333%</Selectivity>
</Property>
<SQLMap name="DataMasterINRQI">
<Data name="INRQI_CTUOM_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INRQI_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INRQI_INCI_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INRQI_REQITM_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INRQI_RefuseFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INRQI_ReqQty">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INRQI_Type">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^INRQ</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>IN_Request.INRQ_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>INRQI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{IN_Request.INRQ_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"RQI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INRQI_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexRefuseFlag">
<Global>^INRQ</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>IN_Request.INRQ_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>INRQI_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Refuse"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INRQI_RefuseFlag}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IN_Request.INRQ_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INRQI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>INRQI_RowId</SqlRowIdName>
<StreamLocation>^User.INReqItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
