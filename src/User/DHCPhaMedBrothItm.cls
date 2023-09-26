/// 揭药子表（新疆中医院） 2017-08-23 hulihua 
/// d ##Class(User.DHCPhaMedBrothItm).%BuildIndices()
Class User.DHCPhaMedBrothItm Extends (%Persistent, %XML.Adaptor, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHMBI_RowID, SqlTableName = DHC_PhaMedBrothItm, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// sub上做个索引，对sub做个约束
Index RowIDBasedIDKeyIndex On PHMBIChildSub [ IdKey, PrimaryKey, Unique ];

/// 和主表做关联
Relationship PHMBIPHMBParRef As User.DHCPhaMedBroth [ Cardinality = parent, Inverse = ChildDHCPhaMedBrothItm, Required, SqlFieldName = PHMBI_PHMB_ParRef ];

/// 子表里面计数器
Property PHMBIChildSub As %Numeric(SCALE = 0) [ InitialExpression = {$i(^DHCPHAMEDB($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"I",0))}, Required, SqlColumnNumber = 2, SqlFieldName = PHMBI_ChildSub ];

/// 所送病区
Property PHMBIWardLocDR As User.CTLoc [ SqlColumnNumber = 3, SqlFieldName = PHMBI_WardLocDR ];

/// 应揭药日期
Property PHMBIUncovMedDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = PHMBI_UncovMedDate ];

/// 实际揭药日期
Property PHMBIActUncovMedDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = PHMBI_ActUncovMedDate ];

/// 实际揭药时间
Property PHMBIActUncovMedTime As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = PHMBI_ActUncovMedTime ];

/// 揭药标志
Property PHMBIUncovMedFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 7, SqlFieldName = PHMBI_UncovMedFlag ];

/// 应揭袋数
Property PHMBIUncovMedPocNum As %Library.Integer [ SqlColumnNumber = 8, SqlFieldName = PHMBI_UncovMedPocNum ];

/// 实揭袋数
Property PHMBIActUncovMedPocNum As %Library.Integer [ SqlColumnNumber = 9, SqlFieldName = PHMBI_ActUncovMedPocNum ];

/// 揭药备注
Property PHMBIRemarks As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = PHMBI_Remarks ];

/// 揭药人
Property PHMBIBrothDispUserDR As User.SSUser [ SqlColumnNumber = 11, SqlFieldName = PHMBI_BrothDispUserDR ];

/// 签收标志
Property PHMBINurseCheckFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 12, SqlFieldName = PHMBI_NurseCheckFlag ];

/// 签收人
Property PHMBINurseCheckUserDR As User.SSUser [ SqlColumnNumber = 13, SqlFieldName = PHMBI_NurseCheckUserDR ];

/// 签收日期
Property PHMBINurseCheckDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 14, SqlFieldName = PHMBI_NurseCheckDate ];

/// 签收时间
Property PHMBINurseCheckTime As %Library.Time [ SqlColumnNumber = 15, SqlFieldName = PHMBI_NurseCheckTime ];

/// 转科原病区
Property PHMBIOldWardLocDR As User.CTLoc [ SqlColumnNumber = 16, SqlFieldName = PHMBI_OldWardLocDR ];

/// 条码号
Property PHMBIBarCode As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = PHMBI_BarCode ];

/// 装箱号
Property PHMBIPHBoxDr As User.DHCPHBox [ SqlColumnNumber = 18, SqlFieldName = PHMBI_PHBox_Dr ];

/// 揭药批次
Property PHMBIBatNo As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = PHMBI_BatNo ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="IndexActDateWardBatNo">
<Global>^DHCPHAMEDBi</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHC_PhaMedBroth.PHMB_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>PHMBI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"ActDateWardBatNo"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHMBI_ActUncovMedDate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHMBI_WardLocDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHMBI_BatNo}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHC_PhaMedBroth.PHMB_RowID}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PHMBI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexActDateWardLoc">
<Global>^DHCPHAMEDBi</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_PhaMedBroth.PHMB_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PHMBI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"ActDateWordLoc"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHMBI_ActUncovMedDate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHMBI_WardLocDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_PhaMedBroth.PHMB_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHMBI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexBarCode">
<Global>^DHCPHAMEDBi</Global>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHC_PhaMedBroth.PHMB_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>PHMBI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"BarCode"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHMBI_BarCode}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_PhaMedBroth.PHMB_RowID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHMBI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexComFlagDateWard">
<Global>^DHCPHAMEDBi</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHC_PhaMedBroth.PHMB_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>PHMBI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"ComFlagDateWardLoc"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHMBI_UncovMedFlag}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHMBI_UncovMedDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHMBI_WardLocDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHC_PhaMedBroth.PHMB_RowID}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PHMBI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexNurseFlagWardLocDate">
<Global>^DHCPHAMEDBi</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHC_PhaMedBroth.PHMB_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>PHMBI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"NurseFlagWardLocDate"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHMBI_NurseCheckFlag}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHMBI_WardLocDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHMBI_ActUncovMedDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHC_PhaMedBroth.PHMB_RowID}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PHMBI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUncovMedFlag">
<Global>^DHCPHAMEDBi</Global>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHC_PhaMedBroth.PHMB_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>PHMBI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"UncovMedFlag"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHMBI_UncovMedFlag}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_PhaMedBroth.PHMB_RowID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHMBI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexWardLocPHBoxDr">
<Global>^DHCPHAMEDBi</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_PhaMedBroth.PHMB_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PHMBI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"WardLocPHBoxDr"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHMBI_WardLocDR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHMBI_PHBox_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_PhaMedBroth.PHMB_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHMBI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterMap">
<Data name="PHMBI_ActUncovMedDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHMBI_ActUncovMedPocNum">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PHMBI_ActUncovMedTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHMBI_BarCode">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PHMBI_BatNo">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PHMBI_BrothDispUserDR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PHMBI_NurseCheckDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PHMBI_NurseCheckFlag">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PHMBI_NurseCheckTime">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PHMBI_NurseCheckUserDR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PHMBI_OldWardLocDR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PHMBI_PHBox_Dr">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PHMBI_Remarks">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PHMBI_UncovMedDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHMBI_UncovMedFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHMBI_UncovMedPocNum">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PHMBI_WardLocDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCPHAMEDB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PhaMedBroth.PHMB_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PHMBI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_PhaMedBroth.PHMB_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHMBI_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPhaMedBrothItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
