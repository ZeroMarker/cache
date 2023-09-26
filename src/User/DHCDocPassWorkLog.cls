Class User.DHCDocPassWorkLog Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = DHC_DocPassWorkLog, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On LogChildSub [ IdKey, PrimaryKey, Unique ];

/// LOG_ParRef
Relationship LogParref As DHCDocPassWorkDetail [ Cardinality = parent, Inverse = LogDetail, Required, SqlFieldName = LOG_ParRef ];

/// LOG_ChildSub
Property LogChildSub As %Numeric(SCALE = 0) [ InitialExpression = {$i(^DDPW(+$s($d(initvalue):initvalue,1:%d(0)),"Datail",$p($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"||",2),"Log",0))}, Required, SqlColumnNumber = 2, SqlFieldName = LOG_ChildSub ];

/// DDPWDL_User	修改人
Property DDPWDLUser As SSUser [ SqlColumnNumber = 3, SqlFieldName = DDPWDL_User ];

/// DDPWDL_Content	修改内容
Property DDPWDLContent As %String(COLLATION = "Exact", MAXLEN = 2000, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = DDPWDL_Content ];

/// DDPWDL_Date		修改日期
Property DDPWDLDate As %Date [ InitialExpression = {+$h}, Required, SqlColumnNumber = 5, SqlFieldName = DDPWDL_Date ];

/// DDPWDL_Time		插入时间
Property DDPWDLTime As %Time [ InitialExpression = {+$p($h,",",2)}, Required, SqlColumnNumber = 6, SqlFieldName = DDPWDL_Time ];

Storage SQLStorage
{
<SQLMap name="DataMaster">
<Data name="DDPWDL_Content">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DDPWDL_Date">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DDPWDL_Time">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DDPWDL_User">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DDPW</Global>
<Subscript name="1">
<Expression>{DHC_DocPassWork.DDPW_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Detail"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_DocPassWorkDetail.DDPWD_ChildSub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"Log"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{LOG_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>DDPWD_RowId</SqlRowIdName>
<StreamLocation>^User.DHCDocPassWorkLogS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
