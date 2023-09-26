/// RefDoctorClinicAlias(2486)
Class User.PACRefDoctorClinicAlias Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_RefDoctorClinicAlias, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On ALIASChildsub [ IdKey, PrimaryKey, Unique ];

/// PAC_RefDoctorClinic Parent Reference
Relationship ALIASParRef As PACRefDoctorClinic [ Cardinality = parent, Inverse = ChildPACRefDoctorClinicAlias, Required, SqlFieldName = ALIAS_ParRef ];

/// Childsub
Property ALIASChildsub As %Float [ InitialExpression = {$i(^PAC("REFD",$p($s($d(initvalue):initvalue,1:%d(0)),"||"),"CLN",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"ALIAS",0))}, SqlColumnNumber = 2, SqlFieldName = ALIAS_Childsub ];

/// Text
Property ALIASText As %String(COLLATION = "AlphaUp", MAXLEN = 64, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = ALIAS_Text ];

/// LOcation Code
Property ALIASLocationCode As CTLoc [ SqlColumnNumber = 4, SqlFieldName = ALIAS_LocationCode ];

/// System
Property ALIASSystem As SSInterface [ SqlColumnNumber = 5, SqlFieldName = ALIAS_System ];

/// Default Send
Property ALIASDefaultSend As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = ALIAS_DefaultSend ];

/// System Text
Property ALIASSystemText As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = ALIAS_SystemText ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACRefDoctorClinicAlias).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACRefDoctorClinicAlias","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACRefDoctorClinicAlias).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACRefDoctorClinicAlias","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACRefDoctorClinicAlias).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACRefDoctorClinicAlias","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACRefDoctorClinicAlias).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACRefDoctorClinicAlias","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACRefDoctorClinicAlias).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACRefDoctorClinicAlias","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Datamaster">
<Data name="ALIAS_DefaultSend">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ALIAS_LocationCode">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ALIAS_System">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ALIAS_SystemText">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ALIAS_Text">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PAC_RefDoctor.REFD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>PAC_RefDoctorClinic.CLN_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>ALIAS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"REFD"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PAC_RefDoctor.REFD_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"CLN"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PAC_RefDoctorClinic.CLN_Childsub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"ALIAS"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ALIAS_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAlias">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PAC_RefDoctor.REFD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>PAC_RefDoctorClinic.CLN_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>ALIAS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"REFD"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ALIAS"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({ALIAS_Text})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PAC_RefDoctor.REFD_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PAC_RefDoctorClinic.CLN_Childsub}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ALIAS_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ALIAS_RowId</SqlRowIdName>
<StreamLocation>^User.PACRefDoctorClinicAliasS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
