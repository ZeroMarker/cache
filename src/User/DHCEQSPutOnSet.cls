Class User.DHCEQSPutOnSet Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = POS_RowID, SqlTableName = DHC_EQSPutOnSet, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// POS_ShareType
Property POSShareType As %Library.String(DISPLAYLIST = ",设备,Room", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",0,1") [ SqlColumnNumber = 2, SqlFieldName = POS_ShareType ];

/// POS_EquipDR
Property POSEquipDR As User.DHCEQEquip [ SqlColumnNumber = 3, SqlFieldName = POS_EquipDR ];

/// POS_SubID
Property POSSubID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = POS_SubID ];

/// POS_ItemDR
Property POSItemDR As User.DHCEQCMasterItem [ SqlColumnNumber = 5, SqlFieldName = POS_ItemDR ];

/// POS_ModelDR
Property POSModelDR As User.DHCEQCModel [ SqlColumnNumber = 6, SqlFieldName = POS_ModelDR ];

/// POS_HospitalDR
Property POSHospitalDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = POS_HospitalDR ];

/// POS_LocDR
Property POSLocDR As User.DHCEQCDepartment [ SqlColumnNumber = 8, SqlFieldName = POS_LocDR ];

/// POS_ManageLocDR
Property POSManageLocDR As User.DHCEQCDepartment [ SqlColumnNumber = 9, SqlFieldName = POS_ManageLocDR ];

/// POS_AutoPutOnFlag
Property POSAutoPutOnFlag As %Library.String(DISPLAYLIST = ",否,是", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",0,1") [ SqlColumnNumber = 10, SqlFieldName = POS_AutoPutOnFlag ];

/// POS_OuterType
Property POSOuterType As %Library.String(DISPLAYLIST = ",否,分院共享,全共享", MAXLEN = 4, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2") [ SqlColumnNumber = 11, SqlFieldName = POS_OuterType ];

/// POS_FromDate
Property POSFromDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 12, SqlFieldName = POS_FromDate ];

/// POS_ToDate
Property POSToDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 13, SqlFieldName = POS_ToDate ];

/// POS_Status
Property POSStatus As %Library.String(DISPLAYLIST = ",新建,提交,审核,作废", MAXLEN = 5, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2,3") [ SqlColumnNumber = 14, SqlFieldName = POS_Status ];

/// POS_UpdateUserDR
Property POSUpdateUserDR As User.DHCEQCUser [ SqlColumnNumber = 15, SqlFieldName = POS_UpdateUserDR ];

/// POS_SubmitUserDR
Property POSSubmitUserDR As User.DHCEQCUser [ SqlColumnNumber = 16, SqlFieldName = POS_SubmitUserDR ];

/// POS_AuditUserDR
Property POSAuditUserDR As User.DHCEQCUser [ SqlColumnNumber = 17, SqlFieldName = POS_AuditUserDR ];

/// POS_Hold1
Property POSHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = POS_Hold1 ];

/// POS_Hold2
Property POSHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = POS_Hold2 ];

/// POS_Hold3
Property POSHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = POS_Hold3 ];

/// POS_Hold4
Property POSHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = POS_Hold4 ];

/// POS_Hold5
Property POSHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = POS_Hold5 ];

/// 资源项目
Property POSShareItemDR As DHCEQSCShareItem [ SqlColumnNumber = 23, SqlFieldName = POS_ShareItemDR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQSPutOnSet("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="POS_AuditUserDR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="POS_AutoPutOnFlag">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="POS_EquipDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="POS_FromDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="POS_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="POS_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="POS_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="POS_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="POS_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="POS_HospitalDR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="POS_ItemDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="POS_LocDR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="POS_ManageLocDR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="POS_ModelDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="POS_OuterType">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="POS_ShareItemDR">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="POS_ShareType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="POS_Status">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="POS_SubID">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="POS_SubmitUserDR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="POS_ToDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="POS_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Global>^DHCEQSPutOnSet</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>POS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{POS_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexEquip">
<Global>^DHCEQSPutOnSet</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>POS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Equip"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{POS_EquipDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{POS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexItem">
<Global>^DHCEQSPutOnSet</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>POS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Item"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{POS_ItemDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{POS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQSPutOnSetS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
