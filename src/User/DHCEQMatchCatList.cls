Class User.DHCEQMatchCatList Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MCL_RowID, SqlTableName = DHC_EQMatchCatList, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Property MCLDesc As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = MCL_Desc ];

Property MCLMatchType As %Library.String(DISPLAYLIST = ",未匹配,全匹配,全字模糊匹配,首尾去一字,首尾去两字", MAXLEN = 3, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2,3,4") [ SqlColumnNumber = 3, SqlFieldName = MCL_MatchType ];

Property MCLMatchName As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = MCL_MatchName ];

Property MCLFstFinanceTypeDR As User.DHCEQCFinanceType [ SqlColumnNumber = 5, SqlFieldName = MCL_FstFinanceTypeDR ];

Property MCLFstStatCatDR As User.DHCEQCStatCat [ SqlColumnNumber = 6, SqlFieldName = MCL_FstStatCatDR ];

Property MCLFstCatDR As User.DHCEQCEquipeCat [ SqlColumnNumber = 7, SqlFieldName = MCL_FstCatDR ];

Property MCLSndFinanceTypeDR As User.DHCEQCFinanceType [ SqlColumnNumber = 8, SqlFieldName = MCL_SndFinanceTypeDR ];

Property MCLSndStatCatDR As User.DHCEQCStatCat [ SqlColumnNumber = 9, SqlFieldName = MCL_SndStatCatDR ];

Property MCLSndCatDR As User.DHCEQCEquipeCat [ SqlColumnNumber = 10, SqlFieldName = MCL_SndCatDR ];

Property MCLTrdFinanceTypeDR As User.DHCEQCFinanceType [ SqlColumnNumber = 11, SqlFieldName = MCL_TrdFinanceTypeDR ];

Property MCLTrdStatCatDR As User.DHCEQCStatCat [ SqlColumnNumber = 12, SqlFieldName = MCL_TrdStatCatDR ];

Property MCLTrdCatDR As User.DHCEQCEquipeCat [ SqlColumnNumber = 13, SqlFieldName = MCL_TrdCatDR ];

/// 导入类组
Property MCLImpFTDR As User.DHCEQCFinanceType [ SqlColumnNumber = 14, SqlFieldName = MCL_ImpFTDR ];

/// 导入类型
Property MCLImpSCDR As User.DHCEQCStatCat [ SqlColumnNumber = 15, SqlFieldName = MCL_ImpSCDR ];

/// 导入分类
Property MCLImpCatDR As User.DHCEQCEquipeCat [ SqlColumnNumber = 16, SqlFieldName = MCL_ImpCatDR ];

/// 导入单位
Property MCLImpUnitDR As User.DHCEQCUOM [ SqlColumnNumber = 17, SqlFieldName = MCL_ImpUnitDR ];

/// 导入医院
Property MCLImpHospDR As User.DHCEQKBHospital [ SqlColumnNumber = 18, SqlFieldName = MCL_ImpHospDR ];

/// 匹配标准设备项1
Property MCLFstKBSItmDR As User.DHCEQKBSMstItem [ SqlColumnNumber = 19, SqlFieldName = MCL_FstKBSItmDR ];

/// 匹配标准设备项2
Property MCLSndKBSItmDR As User.DHCEQKBSMstItem [ SqlColumnNumber = 20, SqlFieldName = MCL_SndKBSItmDR ];

/// 匹配标准设备项3
Property MCLTrdKBSItmDR As User.DHCEQKBSMstItem [ SqlColumnNumber = 21, SqlFieldName = MCL_TrdKBSItmDR ];

/// 新医院设备项标志
Property MCLHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = MCL_Hold1 ];

Property MCLHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = MCL_Hold2 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQMatchCatList("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MCL_Desc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MCL_FstCatDR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MCL_FstFinanceTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MCL_FstKBSItmDR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="MCL_FstStatCatDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MCL_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="MCL_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="MCL_ImpCatDR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="MCL_ImpFTDR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="MCL_ImpHospDR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="MCL_ImpSCDR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="MCL_ImpUnitDR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="MCL_MatchName">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MCL_MatchType">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MCL_SndCatDR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="MCL_SndFinanceTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MCL_SndKBSItmDR">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="MCL_SndStatCatDR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="MCL_TrdCatDR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="MCL_TrdFinanceTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="MCL_TrdKBSItmDR">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="MCL_TrdStatCatDR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Global>^DHCEQMatchCatList</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MCL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{MCL_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEQMatchCatListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
