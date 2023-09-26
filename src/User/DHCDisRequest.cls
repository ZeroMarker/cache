Class User.DHCDisRequest Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = REQ_RowID, SqlTableName = DHC_DisRequest, StorageStrategy = NewStorage1 ]
{

/// 申请单号/ID  REQ_No
Property REQNo As %Text(MAXLEN = 30) [ SqlColumnNumber = 2, SqlFieldName = REQ_No ];

/// 申请病区  REQ_Ward_Dr
Property REQWardDr As User.PACWard [ SqlColumnNumber = 3, SqlFieldName = REQ_Ward_Dr ];

/// 病人床号  REQ_WardBed_Dr
Property REQWardBedDr As User.PACBed [ SqlColumnNumber = 4, SqlFieldName = REQ_WardBed_Dr ];

/// 病人就诊id  REQ_Adm
Property REQAdm As User.PAAdm [ SqlColumnNumber = 5, SqlFieldName = REQ_Adm ];

/// 病人id  REQ_Papmi_Dr
Property REQPapmiDr As User.PAPatMas [ SqlColumnNumber = 6, SqlFieldName = REQ_Papmi_Dr ];

/// 接收科室  REQ_RecLoc_Dr	
Property REQRecLocDr As User.CTLoc [ SqlColumnNumber = 7, SqlFieldName = REQ_RecLoc_Dr ];

/// 陪送日期  REQ_ExeDate	
Property REQExeDate As %Date [ SqlColumnNumber = 8, SqlFieldName = REQ_ExeDate ];

/// 陪送时间  REQ_ExeTime	
Property REQExeTime As %Time [ SqlColumnNumber = 9, SqlFieldName = REQ_ExeTime ];

/// 陪送类型  REQ_EscortType_Dr	
Property REQEscortTypeDr As User.DHCDisType [ SqlColumnNumber = 10, SqlFieldName = REQ_EscortType_Dr ];

/// 陪送工具  REQ_EscortTool_Dr	
Property REQEscortToolDr As User.DHCDisTool [ SqlColumnNumber = 11, SqlFieldName = REQ_EscortTool_Dr ];

/// 陪伴人数  REQ_Nums	
Property REQNums As %Text(MAXLEN = 30) [ SqlColumnNumber = 12, SqlFieldName = REQ_Nums ];

/// 备注 REQ_Remarks		
Property REQRemarks As %Text(MAXLEN = 300) [ SqlColumnNumber = 13, SqlFieldName = REQ_Remarks ];

/// 创建日期  REQ_CreateDate	
Property REQCreateDate As %Date [ SqlColumnNumber = 14, SqlFieldName = REQ_CreateDate ];

/// 创建时间  REQ_CreateTime	
Property REQCreateTime As %Time [ SqlColumnNumber = 15, SqlFieldName = REQ_CreateTime ];

/// 创建人  REQ_CreateUser	
Property REQCreateUser As User.SSUser [ SqlColumnNumber = 16, SqlFieldName = REQ_CreateUser ];

/// 当前状态  REQ_CurStatus	
Property REQCurStatus As User.DHCDisStatusAdd [ SqlColumnNumber = 17, SqlFieldName = REQ_CurStatus ];

/// 空趟标志 REQ_NullFlag  
Property REQNullFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 18, SqlFieldName = REQ_NullFlag ];

/// 陪送类型  REQ_TypeAdd_Dr	
Property REQTypeAddDr As User.DHCDisStatusAdd [ SqlColumnNumber = 19, SqlFieldName = REQ_TypeAdd_Dr ];

/// 陪送时间段 REQ_ExeTimePoint	
Property REQExeTimePoint As %Text(MAXLEN = 30) [ SqlColumnNumber = 20, SqlFieldName = REQ_ExeTimePoint ];

/// 集团化医院  REQ_Hosp_Dr
Property REQHospDr As User.CTHospital [ SqlColumnNumber = 21, SqlFieldName = REQ_Hosp_Dr ];

Relationship ChildDHCDISREQUEST As User.DHCDisRequestItm [ Cardinality = children, Inverse = REQParRefDr ];

// Relationship ChildDHCDisRequestSta As User.DHCDisRequestSta [ Cardinality = children, Inverse = RSParRefDr ];

Storage NewStorage1
{
<SqlIdExpression>$i(^DHCDISRE)</SqlIdExpression>
<SQLMap name="IndexAdm">
<Global>^DHCDISRE</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>REQ_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Adm"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{REQ_Adm}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{REQ_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^DHCDISRE</Global>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CreateDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{REQ_CreateDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{REQ_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexWardDate">
<Global>^DHCDISRE</Global>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"WardDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{REQ_Ward_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{REQ_CreateDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{REQ_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Master">
<Data name="REQ_Adm">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="REQ_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="REQ_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="REQ_CreateUser">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="REQ_CurStatus">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="REQ_EscortTool_Dr">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="REQ_EscortType_Dr">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="REQ_ExeDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="REQ_ExeTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="REQ_ExeTimePoint">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="REQ_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="REQ_No">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="REQ_NullFlag">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="REQ_Nums">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="REQ_Papmi_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="REQ_RecLoc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="REQ_Remarks">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="REQ_TypeAdd_Dr">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="REQ_WardBed_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="REQ_Ward_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCDISRE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>REQ_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{REQ_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCDisRequestS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
