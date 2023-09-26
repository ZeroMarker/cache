Class User.DHCRBCSessionTypeService Extends %Persistent [ ClassType = persistent, ProcedureBlock, SqlRowIdName = SER_RowId, SqlTableName = DHC_RBCSessionTypeService, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On (SERParRef, SERChildsub) [ IdKey, PrimaryKey, Unique ];

/// Des Ref RBC_Service
Property SERARCIMDR As ARCItmMast [ SqlColumnNumber = 3, SqlFieldName = SER_ARCIM_DR ];

/// Childsub
Property SERChildsub As %Float [ InitialExpression = {$i(^RBC("SESS",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"SER",0))}, SqlColumnNumber = 2, SqlFieldName = SER_Childsub ];

/// RBC_SessionType Parent Reference
Property SERParRef As %String(TRUNCATE = 1) [ Required, SqlFieldName = SER_ParRef ];

/// RBC_SessionType Parent Reference
Property SEREXCludeAdmReason As list Of User.PACAdmReason [ SqlColumnNumber = 4, SqlFieldName = SER_EXCludeAdmReason, SqlListType = SUBNODE ];

/// 院区关联
Property SERHospDR As CTHospital [ SqlColumnNumber = 5, SqlFieldName = SER_Hosp_DR ];

/// 挂号职称对应预开类型(正常医嘱OrderNorm,预开医嘱OrderPre,预开诊断OrderDiag)
Property SERType As %String [ SqlColumnNumber = 6, SqlFieldName = SER_Type ];

/// 预开诊断
Property SERDiagnoseDr As MRCICDDx [ SqlColumnNumber = 7, SqlFieldName = SER_DiagnoseDr ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="SER_ARCIM_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SER_DiagnoseDr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SER_EXCludeAdmReason">
<Node>"AdmReason"</Node>
</Data>
<Data name="SER_Hosp_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SER_Type">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^RBC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SER_ParRef</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>SER_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"SESS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SER_ParRef}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"SER"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SER_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>SER_RowId</SqlRowIdName>
<StreamLocation>^User.DHCRBCSessionTypeServiceS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
