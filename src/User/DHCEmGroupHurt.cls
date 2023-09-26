Class User.DHCEmGroupHurt Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = GHU_RowID, SqlTableName = DHC_EmGroupHurt, StorageStrategy = SQLStorage ]
{

/// 代码 GHU_Code 
Property GHUCode As %Text(MAXLEN = 30) [ SqlColumnNumber = 2, SqlFieldName = GHU_Code ];

/// 描述 GHU_Desc
Property GHUDesc As %Text(MAXLEN = 30) [ SqlColumnNumber = 3, SqlFieldName = GHU_Desc ];

/// 事件日期 GHU_CreateDate
Property GHUCreateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = GHU_CreateDate ];

/// 事件时间 GHU_CreateTime
Property GHUCreateTime As %Library.Time [ SqlColumnNumber = 5, SqlFieldName = GHU_CreateTime ];

/// 概要说明 GHU_GeneralSpec
Property GHUGeneralSpec As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = GHU_GeneralSpec ];

/// 详细说明 GHU_DetailSpec
Property GHUDetailSpec As %Library.String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = GHU_DetailSpec ];

/// 是否可用  GHU_ActiveFlag
Property GHUActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = GHU_ActiveFlag ];

/// 集团化医院  PH_Hosp_Dr
Property GHUHospDr As User.CTHospital [ SqlColumnNumber = 9, SqlFieldName = GHU_Hosp_Dr ];

/// 事件类型  GHU_Type //重大:Major
Property GHUType As %Text(MAXLEN = 30) [ SqlColumnNumber = 10, SqlFieldName = GHU_Type ];

/// 事件地点  GHU_Site 
Property GHUSite As %Text(MAXLEN = 100) [ SqlColumnNumber = 11, SqlFieldName = GHU_Site ];

/// 汇报对象  GHU_ReportFor //多选，@号分割
Property GHUReportFor As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = GHU_ReportFor ];

/// 汇报人  GHU_ReportUser_Dr 
Property GHUReportUserDr As User.SSUser [ SqlColumnNumber = 13, SqlFieldName = GHU_ReportUser_Dr ];

/// 汇报时间  GHU_ReportTime 
Property GHUReportTime As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = GHU_ReportTime ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEMGHU)</SqlIdExpression>
<SQLMap name="Master">
<Data name="GHU_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="GHU_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="GHU_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="GHU_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="GHU_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="GHU_DetailSpec">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="GHU_GeneralSpec">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="GHU_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="GHU_ReportFor">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="GHU_ReportTime">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="GHU_ReportUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="GHU_Site">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="GHU_Type">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^DHCEMGHU</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>GHU_Code</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{GHU_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexCode">
<Global>^DHCEMGHU</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>GHU_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{GHU_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{GHU_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEmGroupHurtS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
