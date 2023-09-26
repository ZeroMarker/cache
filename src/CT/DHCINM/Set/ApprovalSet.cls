/// Creator:lulin
/// Descriptions:审批/代办配置
/// Date:2021-06-04
Class CT.DHCINM.Set.ApprovalSet Extends %Persistent
{

Relationship ChildSub As CT.DHCINM.Set.ApprovalSetKey [ Cardinality = children, Inverse = Parref ];

Relationship Show As CT.DHCINM.Set.ApprovalSetShow [ Cardinality = children, Inverse = Parref ];

/// 名称
Property ApprovalName As %String [ SqlColumnNumber = 2, SqlFieldName = Approval_Name ];

/// 类型A:审批，B:代办,C:跳转审批
Property ApprovalType As %String [ SqlColumnNumber = 3, SqlFieldName = Approval_Type ];

/// 重要等级
Property ApprovalLevel As %String [ SqlColumnNumber = 4, SqlFieldName = Approval_Level ];

/// 状态：N:停用，Y:启用
Property ApprovalStatus As %String [ SqlColumnNumber = 5, SqlFieldName = Approval_Status ];

/// 代办调用类
Property ApprovalClass As %String [ SqlColumnNumber = 6, SqlFieldName = ApprovalClass ];

/// 代办调用方法
Property ApprovalMethod As %String [ SqlColumnNumber = 7, SqlFieldName = ApprovalMethod ];

/// 代办跳转关联菜单
Property ApprovalRouter As %String [ SqlColumnNumber = 8, SqlFieldName = ApprovalRouter ];

/// 审批实体类
Property ApprovalCls As %String [ SqlColumnNumber = 9, SqlFieldName = ApprovalCls ];

/// 审批权限类型：W：病区，U:用户，P:人员档案
Property LimitType As %String [ SqlColumnNumber = 10, SqlFieldName = LimitType ];

/// 审批权限Global位置
Property LimitNum As %String [ SqlColumnNumber = 11, SqlFieldName = LimitNum ];

/// 用户/人员档案，日期类型：N:当前，W:表数据
Property LimitDateType As %String [ SqlColumnNumber = 12, SqlFieldName = LimitDateType ];

/// 用户/人员档案，日期类型-表数据，位置
Property LimitDateNum As %String [ SqlColumnNumber = 13, SqlFieldName = LimitDateNum ];

/// 通知：被通知人所在GLOBAL位置【若为空则不进行通知】
Property NoticeNum As %String [ SqlColumnNumber = 14, SqlFieldName = NoticeNum ];

/// 通知人员类型：U:用户/P:人员档案
Property NoticeType As %String [ SqlColumnNumber = 15, SqlFieldName = NoticeType ];

/// 通知标题【模块/菜单】
Property NoticeTitle As %String(MAXLEN = 200) [ SqlColumnNumber = 16, SqlFieldName = NoticeTitle ];

/// 待办调用方法类型
Property ApprovalMethodType As %String [ SqlColumnNumber = 17, SqlFieldName = ApprovalMethodType ];

/// 待办调用方法参数
Property ApprovalParameter As list Of %String [ SqlColumnNumber = 18, SqlFieldName = ApprovalParameter ];

/// 图标
Property ApprovalIcon As %String [ SqlColumnNumber = 19, SqlFieldName = Approval_Icon ];

/// 图标字体颜色
Property FtColor As %String [ SqlColumnNumber = 20, SqlFieldName = Ft_Color ];

/// 图标背景色
Property BgColor As %String [ SqlColumnNumber = 21, SqlFieldName = Bg_Color ];

Index StatusType On (ApprovalStatus, ApprovalType);

Index LevelType On (ApprovalLevel, ApprovalStatus, ApprovalType);

Index ClassName On ApprovalCls;

Storage Default
{
<Data name="ApprovalSetDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ApprovalName</Value>
</Value>
<Value name="3">
<Value>ApprovalType</Value>
</Value>
<Value name="4">
<Value>ApprovalLevel</Value>
</Value>
<Value name="5">
<Value>ApprovalStatus</Value>
</Value>
<Value name="6">
<Value>ApprovalClass</Value>
</Value>
<Value name="7">
<Value>ApprovalMethod</Value>
</Value>
<Value name="8">
<Value>ApprovalRouter</Value>
</Value>
<Value name="9">
<Value>ApprovalCls</Value>
</Value>
<Value name="10">
<Value>LimitType</Value>
</Value>
<Value name="11">
<Value>LimitNum</Value>
</Value>
<Value name="12">
<Value>LimitDateType</Value>
</Value>
<Value name="13">
<Value>LimitDateNum</Value>
</Value>
<Value name="14">
<Value>NoticeNum</Value>
</Value>
<Value name="15">
<Value>NoticeType</Value>
</Value>
<Value name="16">
<Value>NoticeTitle</Value>
</Value>
<Value name="17">
<Value>ApprovalMethodType</Value>
</Value>
<Value name="18">
<Value>ApprovalParameter</Value>
</Value>
<Value name="19">
<Value>ApprovalIcon</Value>
</Value>
<Value name="20">
<Value>FtColor</Value>
</Value>
<Value name="21">
<Value>BgColor</Value>
</Value>
</Data>
<DataLocation>^CT.DHCINM.Set.ApprovalSetD</DataLocation>
<DefaultData>ApprovalSetDefaultData</DefaultData>
<IdLocation>^CT.DHCINM.Set.ApprovalSetD</IdLocation>
<IndexLocation>^CT.DHCINM.Set.ApprovalSetI</IndexLocation>
<StreamLocation>^CT.DHCINM.Set.ApprovalSetS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
