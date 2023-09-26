Class User.DHCCarPrvTpPHPoison Extends %Persistent [ ClassType = persistent, ProcedureBlock, SqlRowIdName = TPP_RowId, SqlTableName = DHC_CarPrvTpPHPoison, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On (TPPParRef, TPPChildsub) [ IdKey, PrimaryKey, Unique ];

Property TPPChildsub As %Float [ InitialExpression = {$i(^CT("CPT",$s($d(p1):p1,1:%d(2)),"PHPO",0))}, SqlColumnNumber = 3, SqlFieldName = TPP_Childsub ];

/// 控制类型：A - 提示，F - 禁止，P - 申请单，E - 越级，S - 系统申请
Property TPPControlType As %String(MAXLEN = 6, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = TPP_ControlType ];

Property TPPParRef As %String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = TPP_ParRef ];

/// 管制分类指针
Property TPPPoisonDR As User.PHCPoison [ SqlColumnNumber = 4, SqlFieldName = TPP_Poison_DR ];

/// 就诊类型
Property TPPEpisodeType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = TPP_EpisodeType ];

/// 审核权限
Property TPPChkVerify As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = TPP_ChkVerify ];

/// 院区指向 预留字段
Property TPPHospId As %String(TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = TPP_HospId ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="TPP_ChkVerify">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="TPP_ControlType">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="TPP_EpisodeType">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="TPP_HospId">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="TPP_Poison_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^CT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>TPP_ParRef</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>TPP_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"CPT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{TPP_ParRef}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="3">
<Expression>"PHPO"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TPP_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>TPP_RowId</SqlRowIdName>
<StreamLocation>^User.DHCCarPrvTpPHPoisonS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
