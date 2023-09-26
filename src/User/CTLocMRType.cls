/// CT Loc MR Type(1452)
Class User.CTLocMRType Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CT_Loc_MRType, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 62;

Index RowIDBasedIDKeyIndex On MRTYPEChildsub [ IdKey, PrimaryKey, Unique ];

/// CT_Loc Parent Reference
Relationship MRTYPEParRef As CTLoc [ Cardinality = parent, Inverse = ChildCTLocMRType, Required, SqlFieldName = MRTYPE_ParRef ];

/// Childsub
Property MRTYPEChildsub As %Float [ InitialExpression = {$i(^CTLOC($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"MRTYPE",0))}, SqlColumnNumber = 2, SqlFieldName = MRTYPE_Childsub ];

/// Des Ref MR Volume
Property MRTYPEMRVolumeDR As RTCMRecordTypeVolumes [ SqlColumnNumber = 3, SqlFieldName = MRTYPE_MRVolume_DR ];

/// Create If New
Property MRTYPECreateIfNew As %String(DISPLAYLIST = ",CreateOnFirstRequest,Prompt,RequestWithNoVolumes,RequestWithNoMRN", MAXLEN = 20, TRUNCATE = 1, VALUELIST = ",Y,P,NV,NMRN") [ SqlColumnNumber = 4, SqlFieldName = MRTYPE_CreateIfNew ];

/// Admission Type
Property MRTYPEAdmType As %String(DISPLAYLIST = ",InPatient,OutPatient,Emergency,HealthPromotion,All", MAXLEN = 15, TRUNCATE = 1, VALUELIST = ",I,O,E,H,A") [ SqlColumnNumber = 5, SqlFieldName = MRTYPE_AdmType ];

/// Link
Property MRTYPELink As %Float [ SqlColumnNumber = 6, SqlFieldName = MRTYPE_Link ];

/// Des Ref MR Type
Property MRTYPETypeDR As RTCMRecordType [ SqlColumnNumber = 7, SqlFieldName = MRTYPE_Type_DR ];

/// Des Ref CTLOC
Property MRTYPECreatLocationDR As CTLoc [ SqlColumnNumber = 8, SqlFieldName = MRTYPE_CreatLocation_DR ];

/// Volume Description
Property MRTYPEVolumeDesc As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = MRTYPE_VolumeDesc ];

/// Prompt
Property MRTYPEPrompt As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = MRTYPE_Prompt ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CTLocMRType).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTLocMRType","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CTLocMRType).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTLocMRType","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CTLocMRType).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTLocMRType","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CTLocMRType).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTLocMRType","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CTLocMRType).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTLocMRType","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>62</ExtentSize>
<Property name="MRTYPEAdmType">
<Selectivity>16.6667%</Selectivity>
</Property>
<Property name="MRTYPEChildsub">
<Selectivity>10.0000%</Selectivity>
</Property>
<Property name="MRTYPECreatLocationDR">
<Selectivity>11.1111%</Selectivity>
</Property>
<Property name="MRTYPECreateIfNew">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="MRTYPELink">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="MRTYPEMRVolumeDR">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="MRTYPEParRef">
<Selectivity>2.1739%</Selectivity>
</Property>
<Property name="MRTYPEPrompt">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="MRTYPETypeDR">
<Selectivity>5.2632%</Selectivity>
</Property>
<Property name="MRTYPEVolumeDesc">
<Selectivity>6.2500%</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="MRTYPE_AdmType">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MRTYPE_CreatLocation_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MRTYPE_CreateIfNew">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MRTYPE_Link">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MRTYPE_MRVolume_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MRTYPE_Prompt">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>8</Piece>
</Data>
<Data name="MRTYPE_Type_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MRTYPE_VolumeDesc">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^CTLOC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CT_Loc.CTLOC_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>MRTYPE_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{CT_Loc.CTLOC_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"MRTYPE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MRTYPE_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>MRTYPE_RowId</SqlRowIdName>
<StreamLocation>^User.CTLocMRTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
