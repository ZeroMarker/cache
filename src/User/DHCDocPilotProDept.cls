Class User.DHCDocPilotProDept Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PPD_RowId, SqlTableName = DHC_DocPilotProDept, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PPDChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_DocPilotProject Parent Reference
Relationship PPDPPParRef As User.DHCDocPilotProject [ Cardinality = parent, Inverse = ChildDHCDocPilotProDept, Required, SqlFieldName = PPD_PP_ParRef ];

/// PPR_ChildSub
Property PPDChildSub As %Library.Float [ InitialExpression = {$i(^DHCDocPPD(+$s($d(initvalue):initvalue,1:%d(0)),0))}, Required, SqlColumnNumber = 2, SqlFieldName = PPD_ChildSub ];

/// 立项科室
Property PPDCreateDepartmentDr As User.CTLoc [ SqlColumnNumber = 3, SqlFieldName = PPD_CreateDepartment_Dr ];

/// 项目负责人
Property PPDStartUserDr As User.SSUser [ SqlColumnNumber = 4, SqlFieldName = PPD_StartUser_Dr ];

/// 委托研究者
Property PPDUserUserDr As User.SSUser [ SqlColumnNumber = 5, SqlFieldName = PPD_UserUser_Dr ];

/// 账号
Property PPDAccount As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = PPD_Account ];

/// 账号余额
Property PPDAccountSum As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = PPD_AccountSum ];

/// 账号预算
Property PPDAccountBudget As %Library.String [ SqlColumnNumber = 8, SqlFieldName = PPD_AccountBudget ];

/// 余额提醒
Property PPDWarnSum As %Double [ SqlColumnNumber = 9, SqlFieldName = PPD_WarnSum ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterIndex">
<Data name="PPD_Account">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PPD_AccountBudget">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PPD_AccountSum">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PPD_CreateDepartment_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PPD_StartUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PPD_UserUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PPD_WarnSum">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCDocPPD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_DocPilotProject.PP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L2}</Expression>
<Field>PPD_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_DocPilotProject.PP_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PPD_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCDocPilotProDeptS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
