Class User.DHCCarPrvTpPHPCp Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = TCP_RowId, SqlTableName = DHC_CarPrvTpPHPCp, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On (TCPParRef, TCPParRef2, TCPChild) [ IdKey, PrimaryKey, Unique ];

Property TCPParRef As %String [ SqlColumnNumber = 2, SqlFieldName = TCP_ParRef ];

Property TCPParRef2 As %String [ SqlColumnNumber = 3, SqlFieldName = TCP_ParRef2 ];

Property TCPChild As %Float [ InitialExpression = {$i(^CT("CPT",$s($d(p1):p1,1:%d(2)),"PHPO",$s($d(p2):p2,1:%d(3)),"CP",0))}, SqlColumnNumber = 4, SqlFieldName = TCP_Child ];

/// 指向医护人员
Property TCPCarPrvDR As CTCareProv [ SqlColumnNumber = 5, SqlFieldName = TCP_CarPrvDR ];

/// 是否处方权
Property TCPActive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = TCP_Active ];

/// 备注
Property TCPReMark As %String [ SqlColumnNumber = 7, SqlFieldName = TCP_ReMark ];

/// 审核权限
Property TCPChkVerify As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = TCP_ChkVerify ];

/// 控制类型：A - 提示，F - 禁止，P - 申请单，E - 越级，S - 系统申请
Property TCPControlType As %String(MAXLEN = 6, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = TCP_ControlType ];

Storage SQLStorage
{
<SQLMap name="DataMaster">
<Data name="TCP_Active">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="TCP_CarPrvDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="TCP_Child">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="TCP_ChkVerify">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="TCP_ControlType">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="TCP_ParRef">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="TCP_ParRef2">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="TCP_ReMark">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^CT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>TCP_ParRef</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>TCP_ParRef2</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>TCP_Child</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"CPT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{TCP_ParRef}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="3">
<Expression>"PHPO"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TCP_ParRef2}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="5">
<Expression>"CP"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{TCP_Child}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexCarPrv">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>TCP_ParRef</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>TCP_ParRef2</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>TCP_Child</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"CPDR"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{TCP_CarPrvDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TCP_ParRef}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{TCP_ParRef2}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{TCP_Child}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>TCP_Rowid</SqlRowIdName>
<StreamLocation>^User.DHCCarPrvTpPHPCpS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
