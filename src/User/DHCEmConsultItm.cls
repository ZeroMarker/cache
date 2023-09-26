Class User.DHCEmConsultItm Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = EC_RowID, SqlTableName = DHC_EmConsultItm, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On ECChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_EmConsult Parent Reference EC_ParRef_Dr
Relationship ECParRefDr As User.DHCEmConsult [ Cardinality = parent, Inverse = ChildDHCEMCONSULTITM, Required, SqlFieldName = EC_ParRef_Dr ];

/// EC_ChildSub
Property ECChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = EC_ChildSub ];

/// 会诊科室  EC_CLoc_Dr
Property ECCLocDr As User.CTLoc [ SqlColumnNumber = 3, SqlFieldName = EC_CLoc_Dr ];

/// 要求会诊医生  EC_NDoc_Dr
Property ECNDocDr As User.CTCareProv [ SqlColumnNumber = 4, SqlFieldName = EC_NDoc_Dr ];

/// 实际会诊医生  EC_CDoc_Dr
Property ECCDocDr As User.CTCareProv [ SqlColumnNumber = 5, SqlFieldName = EC_CDoc_Dr ];

/// 会诊意见  EC_Opinion
Property ECOpinion As %Library.String(COLLATION = "Exact", MAXLEN = 9999, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = EC_Opinion ];

/// 单位名称  EC_Unit
Property ECUnit As %Library.String(COLLATION = "Exact", MAXLEN = 99, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = EC_Unit ];

/// 执行状态  EC_ExeStatus
Property ECExeStatus As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = EC_ExeStatus ];

/// 会诊日期  EC_CDate
Property ECCDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = EC_CDate ];

/// 会诊时间  EC_CTime
Property ECCTime As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = EC_CTime ];

/// 申请医嘱  EC_ROeori_Dr 
Property ECROeoriDr As User.OEOrdItem [ SqlColumnNumber = 11, SqlFieldName = EC_ROeori_Dr ];

/// 会诊医嘱  EC_COeori_Dr 
Property ECCOeoriDr As User.OEOrdItem [ SqlColumnNumber = 12, SqlFieldName = EC_COeori_Dr ];

/// 会诊医生职称  EC_PrvTp_Dr 
Property ECPrvTpDr As User.CTCarPrvTp [ SqlColumnNumber = 13, SqlFieldName = EC_PrvTp_Dr ];

/// 会诊小组  EC_Grp_Dr 
Property ECGrpDr As User.DHCEmConsultGroup [ SqlColumnNumber = 14, SqlFieldName = EC_Grp_Dr ];

/// 亚专业  EC_SubMar_Dr 
Property ECSubMarDr As User.DHCEmConsultGroup [ SqlColumnNumber = 15, SqlFieldName = EC_SubMar_Dr ];

/// 评价标志  EC_EvaFlag
Property ECEvaFlag As %Library.String [ SqlColumnNumber = 16, SqlFieldName = EC_EvaFlag ];

/// 评价内容 EC_EvaDesc
Property ECEvaDesc As %Library.String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = EC_EvaDesc ];

/// 会诊完成日期  EC_CDate
Property ECCompDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 18, SqlFieldName = EC_CompDate ];

/// 会诊完成时间  EC_CTime
Property ECCompTime As %Library.Time [ SqlColumnNumber = 19, SqlFieldName = EC_CompTime ];

/// 会诊到达日期  EC_ArrDate
Property ECArrDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 20, SqlFieldName = EC_ArrDate ];

/// 会诊到达时间  EC_ArrTime
Property ECArrTime As %Library.Time [ SqlColumnNumber = 21, SqlFieldName = EC_ArrTime ];

/// 会诊诊查简介  EC_Indagation     //yp 2021/7/20 天津一中心添加
Property ECIndagation As %String [ SqlColumnNumber = 22, SqlFieldName = EC_Indagation ];

Storage SQLStorage
{
<SQLMap name="DataMaster">
<Data name="EC_ArrDate">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="EC_ArrTime">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="EC_CDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="EC_CDoc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="EC_CLoc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="EC_COeori_Dr">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="EC_CTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="EC_CompDate">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="EC_CompTime">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="EC_EvaDesc">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="EC_EvaFlag">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="EC_ExeStatus">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="EC_Grp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="EC_Indagation">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="EC_NDoc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="EC_Opinion">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="EC_PrvTp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="EC_ROeori_Dr">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="EC_SubMar_Dr">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="EC_Unit">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCEMCON</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_EmConsult.EC_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>EC_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_EmConsult.EC_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EC_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCOeori">
<Global>^DHCEMCON</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_EmConsult.EC_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>EC_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"COeori"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EC_COeori_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_EmConsult.EC_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{EC_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOrditem">
<Global>^DHCEMCON</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_EmConsult.EC_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>EC_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OrdItem"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EC_ROeori_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_EmConsult.EC_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{EC_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEmConsultItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
