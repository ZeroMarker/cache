Class User.DHCPAAdmSheetsItem Extends %Persistent [ ClassType = persistent, ProcedureBlock, SqlRowIdName = SI_RowId, SqlTableName = DHC_PAAdmSheetsItem, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On SIChildsub [ IdKey, PrimaryKey, Unique ];

/// 新增日期
Property SIAddDate As %Date [ SqlColumnNumber = 11, SqlFieldName = SI_AddDate ];

/// 新增时间
Property SIAddTime As %Time [ SqlColumnNumber = 12, SqlFieldName = SI_AddTime ];

/// 新增人
Property SIAddUserDr As SSUser [ SqlColumnNumber = 13, SqlFieldName = SI_AddUser_Dr ];

///  Child Sub (New Key)
Property SIChildsub As %Float [ InitialExpression = {$i(^DHCPAADMS($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"I",0))}, Required, SqlColumnNumber = 2, SqlFieldName = SI_Childsub ];

/// 组项目号
Property SIGroupItemNo As %Float [ SqlColumnNumber = 5, SqlFieldName = SI_GroupItemNo ];

/// 组号
Property SIGroupNo As %Float [ SqlColumnNumber = 4, SqlFieldName = SI_GroupNo ];

/// 备注
Property SIGroupRemark As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = SI_GroupRemark ];

/// 医嘱所在组的状态
Property SIGroupStatus As %String(DISPLAYLIST = ",Stop,Verify,Add,Retract", MAXLEN = 7, TRUNCATE = 1, VALUELIST = ",S,V,A,R") [ SqlColumnNumber = 16, SqlFieldName = SI_GroupStatus ];

/// 医嘱指针
Property SIOEORIDR As OEOrdItem [ Required, SqlColumnNumber = 3, SqlFieldName = SI_OEORI_DR ];

/// Des Ref to DHCPAADMSheets
Relationship SISheetParRef As DHCPAAdmSheets [ Cardinality = parent, Inverse = ChildSheetsItem, Required, SqlFieldName = SI_Sheet_ParRef ];

/// 溶媒(母液),标志
Property SISolventFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 7, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 15, SqlFieldName = SI_SolventFlag ];

/// 医嘱状态
Property SIStatus As %String(DISPLAYLIST = ",Stop,Verify,Add,Retract", MAXLEN = 7, TRUNCATE = 1, VALUELIST = ",S,V,A,R") [ SqlColumnNumber = 7, SqlFieldName = SI_Status ];

/// 停止日期
Property SIStopDate As %Date [ SqlColumnNumber = 8, SqlFieldName = SI_StopDate ];

/// 停止时间
Property SIStopTime As %Time [ SqlColumnNumber = 9, SqlFieldName = SI_StopTime ];

/// 停止人
Property SIStopUserDr As SSUser [ SqlColumnNumber = 10, SqlFieldName = SI_StopUser_Dr ];

/// 本组药物的用法是静脉冲入,标志
Property SIVenousFillingFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 7, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 14, SqlFieldName = SI_VenousFillingFlag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="SI_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="SI_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="SI_AddUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="SI_GroupItemNo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SI_GroupNo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SI_GroupRemark">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SI_GroupStatus">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="SI_OEORI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SI_SolventFlag">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="SI_Status">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SI_StopDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="SI_StopTime">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="SI_StopUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="SI_VenousFillingFlag">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Global>^DHCPAADMS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PAAdmSheets.PAADMS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>SI_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_PAAdmSheets.PAADMS_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SI_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexOEORI">
<Global>^DHCPAADMS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHC_PAAdmSheets.PAADMS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>SI_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"OEORI"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SI_OEORI_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_PAAdmSheets.PAADMS_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>SI_RowId</SqlRowIdName>
<StreamLocation>^User.DHCPAAdmSheetsItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
