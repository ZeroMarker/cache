/// CF RT Hospital MR Type(1697)
Class User.CFRTHospMRType Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CF_RTHospMRType, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On MRTYPEChildsub [ IdKey, PrimaryKey, Unique ];

/// CF_RT Parent Reference
Relationship MRTYPEParRef As CFRT [ Cardinality = parent, Inverse = ChildCFRTHospMRType, Required, SqlFieldName = MRTYPE_ParRef ];

/// Childsub
Property MRTYPEChildsub As %Float [ InitialExpression = {$i(^CF("RT",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"MRTYPE",0))}, SqlColumnNumber = 2, SqlFieldName = MRTYPE_Childsub ];

/// Des Ref Hospital
Property MRTYPEHospitalDR As CTHospital [ SqlColumnNumber = 3, SqlFieldName = MRTYPE_Hospital_DR ];

/// Des Ref MRType
Property MRTYPEMRTypeDR As RTCMRecordType [ SqlColumnNumber = 4, SqlFieldName = MRTYPE_MRType_DR ];

/// Des Ref Volume
Property MRTYPEVolumeDR As RTCMRecordTypeVolumes [ SqlColumnNumber = 5, SqlFieldName = MRTYPE_Volume_DR ];

/// Date From
Property MRTYPEDateFrom As %Date [ SqlColumnNumber = 6, SqlFieldName = MRTYPE_DateFrom ];

/// Date To
Property MRTYPEDateTo As %Date [ SqlColumnNumber = 7, SqlFieldName = MRTYPE_DateTo ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CFRTHospMRType).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CFRTHospMRType","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CFRTHospMRType).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CFRTHospMRType","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CFRTHospMRType).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CFRTHospMRType","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CFRTHospMRType).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CFRTHospMRType","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CFRTHospMRType).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CFRTHospMRType","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="MRTYPE_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MRTYPE_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MRTYPE_Hospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MRTYPE_MRType_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MRTYPE_Volume_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^CF</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CF_RT.RTCF_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>MRTYPE_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{CF_RT.RTCF_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"MRTYPE"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MRTYPE_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexHospital">
<Global>^CF</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CF_RT.RTCF_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>MRTYPE_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{CF_RT.RTCF_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"MRTYPE"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"Hosp"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{MRTYPE_Hospital_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{MRTYPE_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indextype">
<Global>^CF</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CF_RT.RTCF_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>MRTYPE_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{CF_RT.RTCF_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"MRTYPE"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"Type"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{MRTYPE_MRType_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{MRTYPE_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>MRTYPE_RowId</SqlRowIdName>
<StreamLocation>^User.CFRTHospMRTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
