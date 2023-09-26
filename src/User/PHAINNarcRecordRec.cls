/// Description: 毒麻药品登记/回收表 (记录执行记录的回收信息,考虑科室和药房多次回收,)
/// Creator: 	 Huxt 2020-09-27
Class User.PHAINNarcRecordRec Extends %Persistent [ SqlRowIdName = PINRR_RowId, SqlTableName = PHAIN_NarcRecordRec ]
{

/// 索引
Index RecLoc On (PINRRParRef As Exact, PINRRLocDR As Exact);

Index RecDateLoc On (PINRRDate As Exact, PINRRLocDR As Exact, PINRRParRef As Exact);

/// ===============
/// 指向父表
Relationship PINRRParRef As User.PHAINNarcRecord [ Cardinality = parent, Inverse = ChildPHAINNarcRecordRec, SqlFieldName = PINRR_ParRef ];

/// ===============
/// 回收来源类型(患者/本院)
Property PINRROriType As %String [ SqlColumnNumber = 2, SqlFieldName = PINRR_OriType ];

/// 回收来源科室(药房回收时)
Property PINRROriLocDR As User.CTLoc [ SqlColumnNumber = 3, SqlFieldName = PINRR_OriLoc_DR ];

/// 回收科室
Property PINRRLocDR As User.CTLoc [ SqlColumnNumber = 4, SqlFieldName = PINRR_Loc_DR ];

/// 回收空安瓿/废贴数量 (基本单位)
Property PINRRQty As %Float [ SqlColumnNumber = 5, SqlFieldName = PINRR_Qty ];

/// 回收残余液体量 (剂量单位)
Property PINRRFluidQty As %Float [ SqlColumnNumber = 6, SqlFieldName = PINRR_FluidQty ];

/// 回收人
Property PINRRUserDR As User.SSUser [ SqlColumnNumber = 7, SqlFieldName = PINRR_User_DR ];

/// 回收日期
Property PINRRDate As %Date [ SqlColumnNumber = 8, SqlFieldName = PINRR_Date ];

/// 回收时间
Property PINRRTime As %Time [ SqlColumnNumber = 9, SqlFieldName = PINRR_Time ];

/// 回收核对人员
Property PINRRCheckUserDR As User.SSUser [ SqlColumnNumber = 10, SqlFieldName = PINRR_CheckUser_DR ];

/// 回收交回人员
Property PINRRFromUserName As %String [ SqlColumnNumber = 11, SqlFieldName = PINRR_FromUserName ];

/// 交回人员电话
Property PINRRFromUserTel As %String [ SqlColumnNumber = 12, SqlFieldName = PINRR_FromUserTel ];

/// 回收批号
Property PINRRBatchNo As %String [ SqlColumnNumber = 13, SqlFieldName = PINRR_BatchNo ];

/// 残量处理意见
Property PINRRDSCDDR As User.DHCStkComDictionary [ SqlColumnNumber = 14, SqlFieldName = PINRR_DSCD_DR ];

/// 残量处理执行人
Property PINRRDSCDExeUserDR As User.SSUser [ SqlColumnNumber = 15, SqlFieldName = PINRR_DSCDExeUser_DR ];

/// 残量处理监督人
Property PINRRDSCDSuperUserDR As User.SSUser [ SqlColumnNumber = 16, SqlFieldName = PINRR_DSCDSuperUser_DR ];

/// 备注
Property PINRRRemarks As %String [ SqlColumnNumber = 17, SqlFieldName = PINRR_Remarks ];

/// 回收状态 (空或N-未回收/Y-已回收/C-撤销回收)
Property PINRRStatus As %String(COLLATION = "EXACT", DISPLAYLIST = ",Yes,No,Cancel", MAXLEN = 6, SELECTIVITY = "25%", TRUNCATE = 1, VALUELIST = ",Y,N,C") [ InitialExpression = "N", SqlColumnNumber = 18, SqlFieldName = PINRR_Status ];

/// 撤销回收人
Property PINRRCancelUserDR As User.SSUser [ SqlColumnNumber = 19, SqlFieldName = PINRR_CancelUser_DR ];

/// 撤销回收日期
Property PINRRCancelDate As %Date [ SqlColumnNumber = 20, SqlFieldName = PINRR_CancelDate ];

/// 撤销回收时间
Property PINRRCancelTime As %Time [ SqlColumnNumber = 21, SqlFieldName = PINRR_CancelTime ];

/// 多科室回收顺序 (控制撤销顺序)
Property PINRRSortNum As %Integer [ SqlColumnNumber = 22, SqlFieldName = PINRR_SortNum ];

Storage Default
{
<Data name="PHAINNarcRecordRecDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PINRROriType</Value>
</Value>
<Value name="3">
<Value>PINRROriLocDR</Value>
</Value>
<Value name="4">
<Value>PINRRLocDR</Value>
</Value>
<Value name="5">
<Value>PINRRQty</Value>
</Value>
<Value name="6">
<Value>PINRRFluidQty</Value>
</Value>
<Value name="7">
<Value>PINRRUserDR</Value>
</Value>
<Value name="8">
<Value>PINRRDate</Value>
</Value>
<Value name="9">
<Value>PINRRTime</Value>
</Value>
<Value name="10">
<Value>PINRRCheckUserDR</Value>
</Value>
<Value name="11">
<Value>PINRRFromUserName</Value>
</Value>
<Value name="12">
<Value>PINRRFromUserTel</Value>
</Value>
<Value name="13">
<Value>PINRRBatchNo</Value>
</Value>
<Value name="14">
<Value>PINRRDSCDDR</Value>
</Value>
<Value name="15">
<Value>PINRRDSCDExeUserDR</Value>
</Value>
<Value name="16">
<Value>PINRRDSCDSuperUserDR</Value>
</Value>
<Value name="17">
<Value>PINRRRemarks</Value>
</Value>
<Value name="18">
<Value>PINRRStatus</Value>
</Value>
<Value name="19">
<Value>PINRRCancelUserDR</Value>
</Value>
<Value name="20">
<Value>PINRRCancelDate</Value>
</Value>
<Value name="21">
<Value>PINRRCancelTime</Value>
</Value>
<Value name="22">
<Value>PINRRSortNum</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("R")</DataLocation>
<DefaultData>PHAINNarcRecordRecDefaultData</DefaultData>
<IdLocation>{%%PARENT}("R")</IdLocation>
<IndexLocation>^BS.PHA.IN.NarcRecordI</IndexLocation>
<StreamLocation>^User.PHAINNarcRecordRecS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
