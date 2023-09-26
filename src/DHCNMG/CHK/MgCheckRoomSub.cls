/// Creater:guozj
/// Descriptions:质控查房子表
/// Date:2017-09-22
Class DHCNMG.CHK.MgCheckRoomSub Extends %Persistent
{

Relationship Parref As DHCNMG.CHK.MgCheckRoom [ Cardinality = parent, Inverse = ChildSub ];

/// 检查条目
Property CheckItem As %String(MAXLEN = 1000) [ SqlColumnNumber = 2, SqlFieldName = Check_Item ];

/// 条目得分
Property CheckItemScore As %String [ SqlColumnNumber = 3, SqlFieldName = CheckItem_Score ];

/// 条目标准
Property CheckItemStand As %String(MAXLEN = 1000) [ SqlColumnNumber = 4, SqlFieldName = CheckItem_Stand ];

/// 条目标准分值
Property StandardScore As %String [ SqlColumnNumber = 5, SqlFieldName = Standard_Score ];

/// 备注
Property CheckItemRemark As %String(MAXLEN = 1000) [ SqlColumnNumber = 6, SqlFieldName = CheckItem_Remark ];

/// 对应标版、重组模板ID
Property CheckModelDR As %String [ SqlColumnNumber = 7, SqlFieldName = Check_ModelDR ];

/// 条目级别位
Property ItemFlag As %String [ SqlColumnNumber = 8, SqlFieldName = Item_Flag ];

/// 合并数量
Property CheckColSpan As %String [ SqlColumnNumber = 9, SqlFieldName = Check_ColSpan ];

/// 父节点id
Property CheckItemParentDR As %String [ SqlColumnNumber = 10, SqlFieldName = CheckItem_ParentDR ];

/// 二级指标分数
Property CheckTwoScore As %String [ SqlColumnNumber = 11, SqlFieldName = Check_TwoScore ];

/// 排序
Property CheckSort As %String [ SqlColumnNumber = 12, SqlFieldName = Check_Sort ];

/// 来源
Property CheckType As %Integer [ SqlColumnNumber = 13, SqlFieldName = Check_Type ];

/// 条目扣分
Property CheckItemNegScore As %String [ SqlColumnNumber = 14, SqlFieldName = CheckItemNeg_Score ];

Index par On CheckItemParentDR;

Index model On (CheckType, CheckModelDR);

Index Sort On (Parref, CheckSort);

Storage Default
{
<Data name="MgCheckRoomSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ScoreWard</Value>
</Value>
<Value name="3">
<Value>CheckUser</Value>
</Value>
<Value name="4">
<Value>CheckMonth</Value>
</Value>
<Value name="5">
<Value>CheckScore</Value>
</Value>
<Value name="6">
<Value>CreateDate</Value>
</Value>
<Value name="7">
<Value>CheckItem</Value>
</Value>
<Value name="8">
<Value>CheckItemScore</Value>
</Value>
<Value name="9">
<Value>CheckItemStand</Value>
</Value>
<Value name="10">
<Value>StandardScore</Value>
</Value>
<Value name="11">
<Value>CheckItemRemark</Value>
</Value>
<Value name="12">
<Value>CheckModelDR</Value>
</Value>
<Value name="13">
<Value>ItemFlag</Value>
</Value>
<Value name="14">
<Value>CheckItemSort</Value>
</Value>
<Value name="15">
<Value>CheckColSpan</Value>
</Value>
<Value name="16">
<Value>CheckItemParentDR</Value>
</Value>
<Value name="17">
<Value>CheckTwoScore</Value>
</Value>
<Value name="18">
<Value>CheckSort</Value>
</Value>
<Value name="19">
<Value>CheckType</Value>
</Value>
<Value name="20">
<Value>CheckItemNegScore</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.CHK.MgCheckRoomSubD</DataLocation>
<DefaultData>MgCheckRoomSubDefaultData</DefaultData>
<IdLocation>{%%PARENT}("ChildSub")</IdLocation>
<IndexLocation>^DHCNMG.CHK.MgCheckRoomSubI</IndexLocation>
<StreamLocation>^DHCNMG.CHK.MgCheckRoomSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
