Class User.DHCDocPassWorkDetail Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = DHC_DocPassWorkDetail, StorageStrategy = SQLStorage ]
{

/// DDPWDParRef	指向User.DHCDocPassWork.cls
Relationship DetailParref As DHCDocPassWork [ Cardinality = parent, Inverse = ChildDetail, Required, SqlFieldName = DDPWD_ParRef ];

Relationship LogDetail As User.DHCDocPassWorkLog [ Cardinality = children, Inverse = LogParref ];

Index RowIDBasedIDKeyIndex On DDPWDChildSub [ IdKey, PrimaryKey, Unique ];

/// DDPWDChildSub
Property DDPWDChildSub As %Numeric(SCALE = 0) [ InitialExpression = {$i(^DDPW($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"Datail",0))}, Required, SqlColumnNumber = 2, SqlFieldName = DDPWD_ChildSub ];

/// DDPWD_WorkType	类型	原有,出院,入院,转出,转入,手术,病危,病重,死亡,现有 
Property DDPWDWorkType As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = DDPWD_WorkType ];

/// DDPWDAdmDR
Property DDPWDAdmDR As PAAdm [ SqlColumnNumber = 4, SqlFieldName = DDPWD_Adm_DR ];

/// LocDr	患者就诊科室
Property DDPWDLocDR As CTLoc [ Required, SqlColumnNumber = 5, SqlFieldName = DDPWD_Loc_DR ];

/// CareDate 交班日期 
Property DDPWDCareDate As %Date [ InitialExpression = {+$h}, Required, SqlColumnNumber = 6, SqlFieldName = DDPWD_CareDate ];

/// DDPWDRemark
Property DDPWDRemark As %String(COLLATION = "Exact", MAXLEN = 2000, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = DDPWD_Remark ];

/// InsertDate		插入日期
Property DDPWDInsertDate As %Date [ InitialExpression = {+$h}, Required, SqlColumnNumber = 8, SqlFieldName = DDPWD_InsertDate ];

/// InsertTime		插入时间
Property DDPWDInsertTime As %Time [ InitialExpression = {+$p($h,",",2)}, Required, SqlColumnNumber = 9, SqlFieldName = DDPWD_InsertTime ];

/// InsertUserDR	交班人
Property DDPWDInsertUserDR As SSUser [ SqlColumnNumber = 10, SqlFieldName = DDPWD_InsertUser_DR ];

/// DDPWD_FDate 最后修改日期
Property DDPWDFDate As %Date [ InitialExpression = {+$h}, Required, SqlColumnNumber = 11, SqlFieldName = DDPWD_FDate ];

/// DDPWD_FTime	最后修改时间
Property DDPWDFTime As %Time [ InitialExpression = {+$p($h,",",2)}, Required, SqlColumnNumber = 12, SqlFieldName = DDPWD_FTime ];

/// DDPWD_UpdateUserDR	最后修改人
Property DDPWDUpdateUserDR As SSUser [ SqlColumnNumber = 13, SqlFieldName = DDPWD_UpdateUserDR ];

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##class(web.DHCDocPassWork).OnTrigger($g(%d(1)),"TAfterIns")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(web.DHCDocPassWork).OnTrigger($g(%d(1)),"TAfterUpd")
}

Storage SQLStorage
{
<SQLMap name="DataMaster">
<Data name="DDPWD_Adm_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DDPWD_CareDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DDPWD_FDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DDPWD_FTime">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DDPWD_InsertDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DDPWD_InsertTime">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DDPWD_InsertUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DDPWD_Loc_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DDPWD_Remark">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DDPWD_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DDPWD_WorkType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DDPW</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_DocPassWork.DDPW_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DDPWD_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_DocPassWork.DDPW_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Detail"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DDPWD_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAdmLocDate">
<Global>^DDPW</Global>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>DHC_DocPassWork.DDPW_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>DDPWD_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AdmLocDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DDPWD_Adm_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DDPWD_Loc_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DDPWD_CareDate}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DHC_DocPassWork.DDPW_RowId}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{DDPWD_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexAdmLocTypeDate">
<Global>^DDPW</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AdmLocTypeDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DDPWD_Adm_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DDPWD_Loc_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DDPWD_WorkType}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DDPWD_CareDate}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{DHC_DocPassWork.DDPW_RowId}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{DDPWD_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DDPWD_RowId</SqlRowIdName>
<StreamLocation>^User.DHCDocPassWorkDetailS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
