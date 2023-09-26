Class User.DHCMRDiagnosMainDiag Extends %Persistent [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = DHCMR_DiagnosMainDiag, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On DMDChildsub [ IdKey, PrimaryKey, Unique ];

/// MR_Diagnos Parent Reference
Relationship DMDParRef As MRDiagnos [ Cardinality = parent, Inverse = ChildDHCMRDiagnosMainDiag, Required, SqlFieldName = DMD_ParRef ];

/// Childsub
Property DMDChildsub As %Float [ InitialExpression = {$i(^MR($p($s($d(initvalue):initvalue,1:%d(0)),"||"),"DIA",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"DMD",0))}, SqlColumnNumber = 2, SqlFieldName = DMD_Childsub ];

/// 为主诊断更新日期
Property DMDDate As %Date [ SqlColumnNumber = 3, SqlFieldName = DMD_Date ];

/// 为主诊断更新时间
Property DMDTime As %Time [ SqlColumnNumber = 4, SqlFieldName = DMD_Time ];

/// 为主诊断更新人
Property DMDUserDR As User.SSUser [ SqlColumnNumber = 5, SqlFieldName = DMD_User_DR ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Datamaster">
<Data name="DMD_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DMD_Time">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DMD_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^MR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MR_Adm.MRADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>MR_Diagnos.MRDIA_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>DMD_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{MR_Adm.MRADM_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"DIA"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{MR_Diagnos.MRDIA_Childsub}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>"DMD"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DMD_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexData">
<Global>^DHCMRi</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MR_Adm.MRADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>MR_Diagnos.MRDIA_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>DMD_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{MR_Adm.MRADM_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"DATE"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{DMD_Date}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>"TIME"</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{DMD_Time}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>Sub</AccessType>
<Expression>{MR_Diagnos.MRDIA_Childsub}</Expression>
</Subscript>
<Subscript name="7">
<AccessType>Sub</AccessType>
<Expression>{DMD_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DMD_RowId</SqlRowIdName>
<StreamLocation>^User.DHCMRDiagnosMainDiagS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
