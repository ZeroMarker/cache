/// 医嘱执行扩展表执行状态,需计费状态改变表;此状态用于医嘱执行后计费和判断重新计费的条件
Class User.OEOrdExecOrdStatus Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = OE_OrdExecOrdStatus, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On OSCHChildsub [ IdKey, PrimaryKey, Unique ];

/// OE_OrdExec Parent Reference
Relationship OSCHParRef As OEOrdExecExt [ Cardinality = parent, Inverse = ChildOEOrdExecOrdStatus, Required, SqlFieldName = OSCH_ParRef ];

/// Childsub
Property OSCHChildsub As %Numeric(SCALE = 0) [ InitialExpression = {$i(^OEORD($p(initvalue,"||"),"I",$p(initvalue,"||",2),"X",$p(initvalue,"||",3),"OSCH",0))}, SqlColumnNumber = 2, SqlFieldName = OSCH_Childsub ];

/// Date
Property OSCHDate As %Date [ SqlColumnNumber = 3, SqlFieldName = OSCH_Date ];

/// Time
Property OSCHTime As %Time [ SqlColumnNumber = 4, SqlFieldName = OSCH_Time ];

/// Des Ref Status
Property OSCHStatusDR As OECOrderStatus [ SqlColumnNumber = 5, SqlFieldName = OSCH_Status_DR ];

/// Des Ref User
Property OSCHUserDR As SSUser [ SqlColumnNumber = 6, SqlFieldName = OSCH_User_DR ];

/// Text Status
Property OSCHTextStatus As %String(COLLATION = "Exact", MAXLEN = 99, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = OSCH_TextStatus ];

/// Des Ref Status Change Reason
Property OSCHReasonDR As OECAdminStatusChReason [ SqlColumnNumber = 8, SqlFieldName = OSCH_Reason_DR ];

Property OSCHReasonComtent As %String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = OSCH_ReasonComtent ];

/// creater			郭荣勇
/// desc			保存数据(插入或更新)
/// date			2018.03.15
/// input:			OSCHParRef^OSCHStatusDR^OSCHUserDR^OSCHTextStatus^OSCHReasonDR^OSCHReasonComtent^OSCHRowId
/// w ##class(User.OEOrdExecOrdStatus).Save("319||12||4^4^4634^^^^")
ClassMethod Save(saveInfo As %String) As %String
{
	
	set $zt="SaveError"
	;s ^tmpgry("OEOrdExecOrdStatus")=saveInfo
	s OSCHParRef=$p(saveInfo,"^",1)
	i OSCHParRef="" Q "-1"
	s OSCHStatusDR=$p(saveInfo,"^",2)
	s OSCHUserDR=$p(saveInfo,"^",3)
	s OSCHTextStatus=$p(saveInfo,"^",4)
	s OSCHReasonDR=$p(saveInfo,"^",5)
	s OSCHReasonComtent=$p(saveInfo,"^",6)
	s OSCHRowId=$p(saveInfo,"^",7)
	
	s OSCHDate=$P($H,",",1)
	s OSCHTime=$P($H,",",2)
	if OSCHRowId'="" {
		s ThisObj=##class(User.OEOrdExecOrdStatus).%OpenId(OSCHRowId)
	}else{
		s ThisObj=##class(User.OEOrdExecOrdStatus).%New(OSCHParRef)
	}
	if $ISOBJECT(ThisObj) {
		d ThisObj.OSCHParRefSetObjectId(OSCHParRef)
		d ThisObj.OSCHStatusDRSetObjectId(OSCHStatusDR)
		i OSCHUserDR'="" d ThisObj.OSCHUserDRSetObjectId(OSCHUserDR)
		s ThisObj.OSCHTextStatus=OSCHTextStatus
		i OSCHReasonDR'="" d ThisObj.OSCHReasonDRSetObjectId(OSCHReasonDR)
		s ThisObj.OSCHReasonComtent=OSCHReasonComtent
		s ThisObj.OSCHDate=OSCHDate
		s ThisObj.OSCHTime=OSCHTime
		s sc=ThisObj.%Save()
		
		If $$$ISERR(sc) {
			Quit 100
		}
	}
	
	q 0
SaveError
	q "-201"
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Data Master">
<Data name="OSCH_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="OSCH_ReasonComtent">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="OSCH_Reason_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="OSCH_Status_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="OSCH_TextStatus">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="OSCH_Time">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="OSCH_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^OEORD</Global>
<PopulationType>nonnull</PopulationType>
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
<Field>OSCH_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{OE_OrdItemExt.OEORI_OEORD_ParRef}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OE_OrdItemExt.OEORI_Childsub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"X"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OE_OrdExecExt.OEORE_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>"OSCH"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{OSCH_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="DateIndex">
<Global>^OEORDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>OE_OrdItemExt.OEORI_OEORD_ParRef</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>OE_OrdItemExt.OEORI_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>OE_OrdExecExt.OEORE_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L8}</Expression>
<Field>OSCH_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OSCHDateT"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OSCH_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OSCH_Time}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OE_OrdItemExt.OEORI_OEORD_ParRef}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OE_OrdItemExt.OEORI_Childsub}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{OE_OrdExecExt.OEORE_Childsub}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{OSCH_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>OSCH_RowId</SqlRowIdName>
<StreamLocation>^User.OEOrdExecOrdStatusS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
