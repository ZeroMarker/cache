Class User.DHCEQSShareResource Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = RE_RowID, SqlTableName = DHC_EQSShareResource, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// RE_PutOnSetDR
Property REPutOnSetDR As User.DHCEQSPutOnSet [ SqlColumnNumber = 2, SqlFieldName = RE_PutOnSetDR ];

/// RE_ShareType
Property REShareType As %Library.String(DISPLAYLIST = ",设备,Room", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",0,1") [ SqlColumnNumber = 3, SqlFieldName = RE_ShareType ];

/// RE_EquipDR
Property REEquipDR As User.DHCEQEquip [ SqlColumnNumber = 4, SqlFieldName = RE_EquipDR ];

/// RE_SubID
Property RESubID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = RE_SubID ];

/// RE_SubName
Property RESubName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = RE_SubName ];

/// RE_HospitalDR
Property REHospitalDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = RE_HospitalDR ];

/// RE_LocDR
Property RELocDR As User.DHCEQCDepartment [ SqlColumnNumber = 8, SqlFieldName = RE_LocDR ];

/// RE_ManageLocDR
Property REManageLocDR As User.DHCEQCDepartment [ SqlColumnNumber = 9, SqlFieldName = RE_ManageLocDR ];

/// RE_OuterType
Property REOuterType As %Library.String(DISPLAYLIST = ",否,分院共享,全共享", MAXLEN = 4, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2") [ SqlColumnNumber = 10, SqlFieldName = RE_OuterType ];

/// RE_EquipName
Property REEquipName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = RE_EquipName ];

/// RE_EquipNo
Property REEquipNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = RE_EquipNo ];

/// RE_ModelDR
Property REModelDR As User.DHCEQCModel [ SqlColumnNumber = 13, SqlFieldName = RE_ModelDR ];

/// RE_LeaveFactoryNo
Property RELeaveFactoryNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = RE_LeaveFactoryNo ];

/// RE_RentLocDR
Property RERentLocDR As User.DHCEQCDepartment [ SqlColumnNumber = 15, SqlFieldName = RE_RentLocDR ];

/// RE_RentStatus
Property RERentStatus As %Library.String(DISPLAYLIST = ",在库,租赁中,预约租赁", MAXLEN = 4, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2") [ SqlColumnNumber = 16, SqlFieldName = RE_RentStatus ];

/// RE_WashFlag
Property REWashFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 17, SqlFieldName = RE_WashFlag ];

/// RE_InspectFlag
Property REInspectFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 18, SqlFieldName = RE_InspectFlag ];

/// RE_EquipStatus
Property REEquipStatus As %Library.String(DISPLAYLIST = ",完好,故障,报废", MAXLEN = 4, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2") [ SqlColumnNumber = 19, SqlFieldName = RE_EquipStatus ];

/// RE_PutOnFlag
Property REPutOnFlag As %Library.String(DISPLAYLIST = ",下架,上架", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",N,Y") [ SqlColumnNumber = 20, SqlFieldName = RE_PutOnFlag ];

/// RE_Hold1
Property REHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = RE_Hold1 ];

/// RE_Hold2
Property REHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = RE_Hold2 ];

/// RE_Hold3
Property REHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = RE_Hold3 ];

/// RE_Hold4
Property REHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = RE_Hold4 ];

/// RE_Hold5
Property REHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = RE_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQSShareResource("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="RE_EquipDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="RE_EquipName">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="RE_EquipNo">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="RE_EquipStatus">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="RE_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="RE_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="RE_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="RE_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="RE_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="RE_HospitalDR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="RE_InspectFlag">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="RE_LeaveFactoryNo">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="RE_LocDR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="RE_ManageLocDR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="RE_ModelDR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="RE_OuterType">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="RE_PutOnFlag">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="RE_PutOnSetDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RE_RentLocDR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="RE_RentStatus">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="RE_ShareType">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RE_SubID">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="RE_SubName">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="RE_WashFlag">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Global>^DHCEQSShareResource</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RE_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{RE_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexLoc">
<Global>^DHCEQSShareResource</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RE_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Loc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RE_LocDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RE_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPutOnSet">
<Global>^DHCEQSShareResource</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RE_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PutOnSet"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RE_PutOnSetDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RE_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSourceID">
<Global>^DHCEQSShareResource</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RE_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Equip"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RE_EquipDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RE_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQSShareResourceS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
