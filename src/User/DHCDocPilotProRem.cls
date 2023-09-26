Class User.DHCDocPilotProRem Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PPR_RowId, SqlTableName = DHC_DocPilotProRem, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PPRChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_DocPilotProject Parent Reference
Relationship PPRPPParRef As User.DHCDocPilotProject [ Cardinality = parent, Inverse = ChildDHCDocPilotProRem, Required, SqlFieldName = PPR_PP_ParRef ];

/// PPR_ChildSub
Property PPRChildSub As %Library.Float [ InitialExpression = {$i(^DHCDocPPR(+$s($d(initvalue):initvalue,1:%d(0)),0))}, Required, SqlColumnNumber = 2, SqlFieldName = PPR_ChildSub ];

/// PPR_RemAmount：汇款金额
Property PPRRemAmount As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PPR_RemAmount ];

/// PPR_RemUser_Dr：操作人
Property PPRRemUserDr As User.SSUser [ SqlColumnNumber = 4, SqlFieldName = PPR_RemUser_Dr ];

/// PPR_DateAdd：加入日期
Property PPRDateAdd As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = PPR_DateAdd ];

/// PPR_TimeAdd：加入时间
Property PPRTimeAdd As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = PPR_TimeAdd ];

/// PPR_Remitter：汇款人
Property PPRRemitter As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = PPR_Remitter ];

/// PPR_Receiver：接收人
Property PPRReceiver As User.SSUser [ SqlColumnNumber = 8, SqlFieldName = PPR_Receiver ];

/// PPR_Date：汇款日期
Property PPRDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = PPR_Date ];

/// PPR_Remark：备注
Property PPRRemark As %Library.String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = PPR_Remark ];

/// PPR_state:状态 A:申请 V:确认到账
Property PPRState As %Library.String(DISPLAYLIST = ",Apply,Verify", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",A,V") [ SqlColumnNumber = 11, SqlFieldName = PPR_State ];

/// PPR_Account账号
Property PPRAccount As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = PPR_Account ];

Property PPRFirstPay As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = PPR_FirstPay ];

/// PPR_Type:类型 I:IEC B:备案费 E:项目审核费
Property PPRType As %Library.String(DISPLAYLIST = ",IEC,BAF,EXAMF", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",I,B,E") [ SqlColumnNumber = 14, SqlFieldName = PPR_Type ];

Property PPRRemBeforeDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = PPR_RemBefore_Dr ];

Property PPRUser As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = PPR_User ];

Property PPRUserDr As User.SSUser [ SqlColumnNumber = 17, SqlFieldName = PPR_UserDr ];

Property PPRCount As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = PPR_Count ];

/// 付款记录时的主研究者
Property PPRMasterUserDR As User.SSUser [ SqlColumnNumber = 19, SqlFieldName = PPR_MasterUserDR ];

/// 付款记录时的合同标识[One,Two,Three,Four,Five]
Property PPRPayContract As %Library.String(DISPLAYLIST = ",One,Two,Three,Four,Five", MAXLEN = 6, SELECTIVITY = "16.6666%", TRUNCATE = 1, VALUELIST = ",O,T,TH,FO,FI") [ SqlColumnNumber = 20, SqlFieldName = PPR_PayContract ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterIndex">
<Data name="PPR_Account">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PPR_Count">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PPR_Date">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PPR_DateAdd">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PPR_FirstPay">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PPR_MasterUserDR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PPR_PayContract">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="PPR_Receiver">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PPR_RemAmount">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PPR_RemBefore_Dr">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PPR_RemUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PPR_Remark">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PPR_Remitter">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PPR_TimeAdd">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PPR_Type">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PPR_User">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PPR_UserDr">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PPR_state">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^DHCDocPPR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_DocPilotProject.PP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L2}</Expression>
<Field>PPR_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_DocPilotProject.PP_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>{PPR_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^DHCDocPPR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_DocPilotProject.PP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PPR_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{PPR_Date}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DHC_DocPilotProject.PP_RowId}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{PPR_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateAdd">
<Global>^DHCDocPPR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_DocPilotProject.PP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PPR_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DateAdd"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{PPR_DateAdd}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DHC_DocPilotProject.PP_RowId}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{PPR_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCDocPilotProRemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
