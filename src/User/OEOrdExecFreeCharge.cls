Class User.OEOrdExecFreeCharge Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = OE_OrdExecFreeCharge, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On FCCHChildsub [ IdKey, PrimaryKey, Unique ];

/// OE_OrdExec Parent Reference
Relationship FCCHParRef As OEOrdExecExt [ Cardinality = parent, Inverse = ChildOEOrdExecFreeCharge, Required, SqlFieldName = FCCH_ParRef ];

/// Childsub
Property FCCHChildsub As %Numeric(SCALE = 0) [ InitialExpression = {$i(^OEORD($p(initvalue,"||"),"I",$p(initvalue,"||",2),"X",$p(initvalue,"||",3),"FCCH",0))}, SqlColumnNumber = 2, SqlFieldName = FCCH_Childsub ];

/// Des Ref AdminStatus
Property FCCHFreeChargeFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 3, SqlFieldName = FCCH_FreeChargeFlag ];

/// Des Ref Status Change Reason
Property FCCHReasonDR As OECAdminStatusChReason [ SqlColumnNumber = 4, SqlFieldName = FCCH_Reason_DR ];

/// Date
Property FCCHDate As %Date [ SqlColumnNumber = 5, SqlFieldName = FCCH_Date ];

/// Time
Property FCCHTime As %Time [ SqlColumnNumber = 6, SqlFieldName = FCCH_Time ];

/// Des Ref User
Property FCCHUserDR As SSUser [ SqlColumnNumber = 7, SqlFieldName = FCCH_User_DR ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="datamaster">
<Data name="FCCH_Date">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="FCCH_FreeChargeFlag">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="FCCH_Reason_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="FCCH_Time">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="FCCH_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^OEORD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>OE_OrdItemExt.OEORI_OEORD_ParRef</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>OE_OrdItemExt.OEORI_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>OE_OrdExecExt.OEORE_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L7}</Expression>
<Field>FCCH_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{OE_OrdItemExt.OEORI_OEORD_ParRef}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{OE_OrdItemExt.OEORI_Childsub}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>"X"</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{OE_OrdExecExt.OEORE_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>Sub</AccessType>
<Expression>"FCCH"</Expression>
</Subscript>
<Subscript name="7">
<AccessType>Sub</AccessType>
<Expression>{FCCH_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>FCCH_RowId</SqlRowIdName>
<StreamLocation>^User.OEOrdExecFreeChargeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
