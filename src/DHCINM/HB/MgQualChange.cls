/// Creater:wangpf
/// Descriptions:质控整改分析记录
/// Date:2020-07-17
Class DHCINM.HB.MgQualChange Extends %Persistent
{

/// 记录病区
Property ChangeWard As CF.DHCINM.DB.MgWard [ SqlColumnNumber = 2, SqlFieldName = Change_Ward ];

/// 数据来源 A:数据带入 M:手工录入
Property ChangeSource As %String(DISPLAYLIST = ",数据带入,手工录入", MAXLEN = 1, TRUNCATE = 1, VALUELIST = ",A,M") [ SqlColumnNumber = 3, SqlFieldName = Change_Source ];

/// 质控项目
Property ChangeQual As CT.DHCINM.DB.MgQualItem [ SqlColumnNumber = 4, SqlFieldName = Change_Qual ];

/// 质控问题
Property ChangeQues As %String(MAXLEN = 1000) [ SqlColumnNumber = 5, SqlFieldName = Change_Ques ];

/// 原因分析
Property ChangeReason As list Of %String [ SqlColumnNumber = 6, SqlFieldName = Change_Reason ];

/// 护理人员原因
Property ChangeNurRea As %String(MAXLEN = 1000) [ SqlColumnNumber = 7, SqlFieldName = Change_NurRea ];

/// 病人情况原因
Property ChangePatRea As %String(MAXLEN = 1000) [ SqlColumnNumber = 8, SqlFieldName = Change_PatRea ];

/// 设备原因
Property ChangeDeviceRea As %String(MAXLEN = 1000) [ SqlColumnNumber = 9, SqlFieldName = Change_DeviceRea ];

/// 工作环境原因
Property ChangeWorkRea As %String(MAXLEN = 1000) [ SqlColumnNumber = 10, SqlFieldName = Change_WorkRea ];

/// 物品原因
Property ChangeGoodsRea As %String(MAXLEN = 1000) [ SqlColumnNumber = 11, SqlFieldName = Change_GoodsRea ];

/// 其他原因
Property ChangeOtherRea As %String(MAXLEN = 1000) [ SqlColumnNumber = 12, SqlFieldName = Change_OtherRea ];

/// 整改措施
Property ChangeStep As %String(MAXLEN = 1000) [ SqlColumnNumber = 13, SqlFieldName = Change_Step ];

/// 预期目标
Property ChangeGoal As %String(MAXLEN = 1000) [ SqlColumnNumber = 14, SqlFieldName = Change_Goal ];

/// 护理部意见(效果评价)
Property ChangeHLBView As %String(MAXLEN = 1000) [ SqlColumnNumber = 15, SqlFieldName = Change_HLBView ];

/// 状态 N:保存 Y:提交
Property ChangeStatus As %String(DISPLAYLIST = ",保存,提交", MAXLEN = 1, TRUNCATE = 1, VALUELIST = ",N,Y") [ SqlColumnNumber = 16, SqlFieldName = Change_Status ];

/// 创建人
Property Creator As %String [ SqlColumnNumber = 17, SqlFieldName = Creator ];

/// 创建日期
Property CreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 18, SqlFieldName = Create_Date ];

/// 创建时间
Property CreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 19, SqlFieldName = Create_Time ];

/// 自动带入数据时指向的质控结果
Property ChangeResult As DHCINM.CHK.MgCheckResult [ SqlColumnNumber = 20, SqlFieldName = Change_Result ];

Index ToolIndex On (CreateDate, ChangeWard, ChangeQual, ChangeSource);

Index Result On ChangeResult;

Storage Default
{
<Data name="MgQualChangeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ChangeWard</Value>
</Value>
<Value name="3">
<Value>ChangeSource</Value>
</Value>
<Value name="4">
<Value>ChangeQual</Value>
</Value>
<Value name="5">
<Value>ChangeQues</Value>
</Value>
<Value name="6">
<Value>ChangeReason</Value>
</Value>
<Value name="7">
<Value>ChangeNurRea</Value>
</Value>
<Value name="8">
<Value>ChangePatRea</Value>
</Value>
<Value name="9">
<Value>ChangeDeviceRea</Value>
</Value>
<Value name="10">
<Value>ChangeWorkRea</Value>
</Value>
<Value name="11">
<Value>ChangeGoodsRea</Value>
</Value>
<Value name="12">
<Value>ChangeOtherRea</Value>
</Value>
<Value name="13">
<Value>ChangeStep</Value>
</Value>
<Value name="14">
<Value>ChangeGoal</Value>
</Value>
<Value name="15">
<Value>ChangeHLBView</Value>
</Value>
<Value name="16">
<Value>ChangeStatus</Value>
</Value>
<Value name="17">
<Value>Creator</Value>
</Value>
<Value name="18">
<Value>CreateDate</Value>
</Value>
<Value name="19">
<Value>CreateTime</Value>
</Value>
<Value name="20">
<Value>ChangeResult</Value>
</Value>
</Data>
<DataLocation>^DHCINM.HB.MgQualChangeD</DataLocation>
<DefaultData>MgQualChangeDefaultData</DefaultData>
<IdLocation>^DHCINM.HB.MgQualChangeD</IdLocation>
<IndexLocation>^DHCINM.HB.MgQualChangeI</IndexLocation>
<StreamLocation>^DHCINM.HB.MgQualChangeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
