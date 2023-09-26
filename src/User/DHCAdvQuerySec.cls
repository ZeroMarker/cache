Class User.DHCAdvQuerySec Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = ADVQS_RowID, SqlTableName = DHC_AdvQuerySec, StorageStrategy = NewStorage1 ]
{

/// ADVQS_RepTyep_Dr	报告类型Id
Property ADVQSRepTyepDr As %String [ SqlColumnNumber = 2, SqlFieldName = ADVQS_RepTyep_Dr ];

/// ADVQS_Type	类型 1-按安全组,2-按科室，3-按用户
Property ADVQSType As %String [ SqlColumnNumber = 3, SqlFieldName = ADVQS_Type ];

/// ADVQS_Pointer	指向 与类型分别对应SS_Group,CT_Loc,SS_Use
Property ADVQSPointer As %String [ SqlColumnNumber = 4, SqlFieldName = ADVQS_Pointer ];

/// ADVQS_SecFlag	权限值 1仅自已,2仅本科室,3全院
Property ADVQSSecFlag As %String [ SqlColumnNumber = 5, SqlFieldName = ADVQS_SecFlag ];

/// ADVQS_AssessFlag	评估权限
Property ADVQSAssessFlag As %String [ SqlColumnNumber = 6, SqlFieldName = ADVQS_AssessFlag ];

/// ADVQS_InvaildFlag	作废权限
Property ADVQSInvaildFlag As %String [ SqlColumnNumber = 7, SqlFieldName = ADVQS_InvaildFlag ];

/// ADVQS_ShareFlag	分享权限
Property ADVQSShareFlag As %String [ SqlColumnNumber = 8, SqlFieldName = ADVQS_ShareFlag ];

/// ADVQS_FocusFlag	重点关注权限
Property ADVQSFocusFlag As %String [ SqlColumnNumber = 9, SqlFieldName = ADVQS_FocusFlag ];

/// ADVQS_FileFlag	归档权限
Property ADVQSFileFlag As %String [ SqlColumnNumber = 10, SqlFieldName = ADVQS_FileFlag ];

/// ADVQS_CaseShareFlag	案例共享权限
Property ADVQSCaseShareFlag As %String [ SqlColumnNumber = 11, SqlFieldName = ADVQS_CaseShareFlag ];

/// ADVQS_DeleteFlag	删除权限
Property ADVQSDeleteFlag As %String [ SqlColumnNumber = 12, SqlFieldName = ADVQS_DeleteFlag ];

/// ADVQS_CancelFlag	作废权限
Property ADVQSCancelFlag As %String [ SqlColumnNumber = 13, SqlFieldName = ADVQS_CancelFlag ];

/// 多院区改造 2021-04-12 cy
Property ADVQSHospDr As User.CTHospital [ SqlColumnNumber = 14, SqlFieldName = ADVQS_HospDr ];

Storage NewStorage1
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCADVQUS)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ADVQS_AssessFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ADVQS_CancelFlag">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ADVQS_CaseShareFlag">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ADVQS_DeleteFlag">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ADVQS_FileFlag">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ADVQS_FocusFlag">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ADVQS_HospDr">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="ADVQS_InvaildFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ADVQS_Pointer">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ADVQS_RepTyep_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ADVQS_SecFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ADVQS_ShareFlag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ADVQS_Type">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCADVQUS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ADVQS_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{ADVQS_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="HospRepTypeIndex">
<Global>^DHCADVQUS</Global>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>ADVQS_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HospRepType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ADVQS_HospDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ADVQS_RepTyep_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ADVQS_Type}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ADVQS_Pointer}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ADVQS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="RepTypeIndex">
<Global>^DHCADVQUS</Global>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>ADVQS_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RepType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ADVQS_RepTyep_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ADVQS_Type}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ADVQS_Pointer}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ADVQS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCAdvQuerySecS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
