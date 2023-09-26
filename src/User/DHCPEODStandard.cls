/// 站点细项选择表
Class User.DHCPEODStandard Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ODS_RowId, SqlTableName = DHC_PE_ODStandard, StorageStrategy = SQLStorage ]
{

Parameter ClassName = "User.DHCPEODStandard";

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On ODSChildSub [ IdKey, PrimaryKey, Unique ];

/// 年龄上限
Property ODSAgeMax As %Library.Numeric(SCALE = 2) [ SqlColumnNumber = 11, SqlFieldName = ODS_AgeMax ];

/// 年龄下限
Property ODSAgeMin As %Library.Numeric(SCALE = 2) [ SqlColumnNumber = 10, SqlFieldName = ODS_AgeMin ];

/// ODS_ChildSub
Property ODSChildSub As %Library.String(COLLATION = "Exact", MAXLEN = 16, TRUNCATE = 0) [ InitialExpression = {$i(^DHCPEST(+%d(0),"OD",$p($p(%d(0),$c(1)),"||",2),"ODS",0))}, Required, SqlColumnNumber = 2, SqlFieldName = ODS_ChildSub ];

/// 上限
Property ODSMax As %Library.Numeric(SCALE = 4) [ SqlColumnNumber = 7, SqlFieldName = ODS_Max ];

/// 下限
Property ODSMin As %Library.Numeric(SCALE = 4) [ SqlColumnNumber = 6, SqlFieldName = ODS_Min ];

/// 是否正常值
Property ODSNatureValue As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = ODS_NatureValue ];

/// DHC_PE_OrderDetail Parent Reference
Relationship ODSParRef As User.DHCPEOrderDetail [ Cardinality = parent, Inverse = ChildDHCPEODStandard, Required, SqlFieldName = ODS_ParRef ];

/// 适应性别
Property ODSSex As %Library.String(DISPLAYLIST = ",Male,Female,No", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",M,F,N") [ SqlColumnNumber = 5, SqlFieldName = ODS_Sex ];

/// 模板
Property ODSTemplate As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = ODS_Template ];

/// 文本值
Property ODSTextVal As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ODS_TextVal ];

/// 单位
Property ODSUnit As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = ODS_Unit ];

/// 荒诞值
Property ODSHDValue As %String [ SqlFieldName = ODS_HDValue ];

/// 所见
Property ODSEyeSee As %String(MAXLEN = 200) [ SqlFieldName = ODS_EyeSee ];

/// 不打印
Property ODSNoPrint As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlFieldName = ODS_NoPrint ];

/// 进入小结
Property ODSSummary As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlFieldName = ODS_Summary ];

/// 默认
Property ODSDefault As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlFieldName = ODS_Default ];

/// 作废标记
Property ODSNoActive As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlFieldName = ODS_NoActive ];

/// 更新日期
Property ODSUpdateDate As %Date [ SqlFieldName = ODS_UpdateDate ];

/// 更新时间
Property ODSUpdateTime As %Time [ SqlFieldName = ODS_UpdateTime ];

/// 更信人 指向SS_User
Property ODSUpdateUserDR As %String [ SqlFieldName = ODS_UpdateUserDR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterDHCPESTODS">
<Data name="ODS_AgeMax">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ODS_AgeMin">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ODS_Default">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="ODS_EyeSee">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ODS_HDValue">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ODS_Max">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ODS_Min">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ODS_NatureValue">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ODS_NoActive">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="ODS_NoPrint">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ODS_Sex">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ODS_Summary">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="ODS_Template">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ODS_TextVal">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ODS_Unit">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ODS_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="ODS_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="ODS_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Global>^DHCPEST</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PE_Station.ST_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DHC_PE_OrderDetail.OD_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>ODS_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_PE_Station.ST_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"OD"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DHC_PE_OrderDetail.OD_ChildSub}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>"ODS"</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{ODS_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPEODStandardS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
