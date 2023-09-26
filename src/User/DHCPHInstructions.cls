/// 名称: 目录主索引表
/// 编写者:基础数据平台组-陈莹
/// 编写日期: 2014-12-3
Class User.DHCPHInstructions Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = PHINST_RowId, SqlTableName = DHC_PHInstructions, StorageStrategy = SQLStorage ]
{

/// PHINST_RowId ^DHCPHINSTRUC
Parameter EXTENTSIZE = 250;

/// PHINST_Type_Dr
Property PHINSTTypeDr As User.DHCPHInstLabel [ Required, SqlColumnNumber = 2, SqlFieldName = PHINST_Type_Dr ];

/// PHINST_OrderNum
Property PHINSTOrderNum As %Library.Float [ Required, SqlColumnNumber = 3, SqlFieldName = PHINST_OrderNum ];

/// PHINST_Gen_Dr通用名
Property PHINSTGenDr As %Library.String [ Required, SqlColumnNumber = 4, SqlFieldName = PHINST_Gen_Dr ];

/// PHINST_Pointer_Dr 药品-剂型、检查-部位、病理-标本、心电-空 _
Property PHINSTPointerDr As %String [ Required, SqlColumnNumber = 5, SqlFieldName = PHINST_Pointer_Dr ];

/// PHINST_PointerType Drug,B _
Property PHINSTPointerType As %Library.String [ Required, SqlColumnNumber = 6, SqlFieldName = PHINST_PointerType ];

/// PHINST_Lib_Dr知识库标识
Property PHINSTLibDr As DHCPHLibaryLabel [ Required, SqlColumnNumber = 7, SqlFieldName = PHINST_Lib_Dr ];

/// PHINST_ActiveFlag是否可用
Property PHINSTActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ Required, SqlColumnNumber = 8, SqlFieldName = PHINST_ActiveFlag ];

/// PHINST_SysFlag系统标识
Property PHINSTSysFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ Required, SqlColumnNumber = 9, SqlFieldName = PHINST_SysFlag ];

/// PHINST_Sex
Property PHINSTSex As %Library.String(DISPLAYLIST = ",Male,Female,All", MAXLEN = 6, VALUELIST = ",M,F,A") [ SqlColumnNumber = 10, SqlFieldName = PHINST_Sex ];

/// PHINST_NurseUseTips用药提示（用于护士和病人）
Property PHINSTNurseUseTips As %Library.String(COLLATION = "Exact", MAXLEN = 800, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = PHINST_NurseUseTips ];

/// PHINST_DocUseTips用药提示（用于医生）
Property PHINSTDocUseTips As %Library.String(COLLATION = "Exact", MAXLEN = 800, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = PHINST_DocUseTips ];

/// PHINST_Note备注说明
Property PHINSTNote As %Library.String(COLLATION = "Exact", MAXLEN = 800, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = PHINST_Note ];

/// PHINST_CheckLevel检查级别
Property PHINSTCheckLevel As %Library.Float [ SqlColumnNumber = 14, SqlFieldName = PHINST_CheckLevel ];

// Property PHINSTDrugDr As User.PHCDrgForm [ SqlColumnNumber = 15, SqlFieldName = PHINST_Drug_Dr ];

/// PHINST_Drug_Dr药学项HIS _
/// PHINST_Mode管制级别
Property PHINSTMode As %Library.String(DISPLAYLIST = ",Warn,Control,Stat", MAXLEN = 7, VALUELIST = ",W,C,S") [ SqlColumnNumber = 15, SqlFieldName = PHINST_Mode ];

/// PHINST_Text不良反应/注意事项
Property PHINSTText As %Library.String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = PHINST_Text ];

/// PHINST_BMIMin
Property PHINSTBMIMin As %Library.Float [ SqlColumnNumber = 17, SqlFieldName = PHINST_BMIMin ];

/// PHINST_BMIMax
Property PHINSTBMIMax As %Library.Float [ SqlColumnNumber = 18, SqlFieldName = PHINST_BMIMax ];

/*
/// PHINST_PlanPregnancy
Property PHINSTPlanPregnancy As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = PHINST_PlanPregnancy ];

/// PHINST_Climacteric
Property PHINSTClimacteric As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 12, SqlFieldName = PHINST_Climacteric ];

/// PHINST_Menstrual
Property PHINSTMenstrual As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = PHINST_Menstrual ];

/// PHINST_Lactation
Property PHINSTLactation As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 33, SqlFieldName = PHINST_Lactation ];

/// PHINST_Pregnant
Property PHINSTPregnant As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 34, SqlFieldName = PHINST_Pregnant ];

/// PHINST_RenalFunction
Property PHINSTRenalFunction As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 35, SqlFieldName = PHINST_RenalFunction ];
*/
Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPHINSTRUC(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PHINST_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PHINST_BMIMax">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PHINST_BMIMin">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PHINST_CheckLevel">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PHINST_DocUseTips">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PHINST_Gen_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHINST_Lib_Dr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PHINST_Mode">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PHINST_Note">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PHINST_NurseUseTips">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PHINST_OrderNum">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHINST_PointerType">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHINST_Pointer_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHINST_Sex">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PHINST_SysFlag">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PHINST_Text">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PHINST_Type_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCPHINSTRUC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHINST_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{PHINST_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexGEN">
<Global>^DHCPHINSTRUC</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHINST_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"GEN"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHINST_Gen_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHINST_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexGP">
<Global>^DHCPHINSTRUC</Global>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>PHINST_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"GP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHINST_Gen_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHINST_PointerType}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHINST_Pointer_Dr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PHINST_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLIB">
<Global>^DHCPHINSTRUC</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHINST_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LIB"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHINST_Lib_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHINST_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTGP">
<Global>^DHCPHINSTRUC</Global>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>PHINST_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TGP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHINST_Type_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHINST_Gen_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHINST_PointerType}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PHINST_Pointer_Dr}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{PHINST_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PHINST_RowId</SqlRowIdName>
<StreamLocation>^User.DHCPHInstructionsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
