/// 护理档案操作记录
/// Creator     ChenPeng
/// CreateDate  2022-01-14
Class DHCINM.HR.MgPerOperate Extends (%Persistent, %Populate)
{

/// 父表护理档案
Relationship Person As CF.DHCINM.HR.Persons [ Cardinality = parent, Inverse = PerOperate ];

Relationship PerPropItem As DHCINM.HR.MgPerPropItem [ Cardinality = children, Inverse = PerOperate ];

/// 档案状态
Property Status As %String(DISPLAYLIST = ",初始化,编辑中,已审核,'已撤销'", VALUELIST = ",I,U,A,R") [ SqlColumnNumber = 2, SqlFieldName = Per_OpStatus ];

/// 操作类型
Property Type As %String(DISPLAYLIST = ",新增,修改,审核同意,审核驳回,撤销审核", VALUELIST = ",N,U,P,B,R") [ SqlColumnNumber = 3, SqlFieldName = Per_OpType ];

/// 审核意见
Property Comment As %String [ SqlColumnNumber = 4, SqlFieldName = Per_OpComment ];

/// 操作人--操作人是有问题的
Property Operator As %String [ SqlColumnNumber = 5, SqlFieldName = Per_Operator ];

/// 操作日期
Property OpDate As %Date [ SqlColumnNumber = 6, SqlFieldName = Per_OpDate ];

/// 操作时刻
Property OpTime As %Time [ SqlColumnNumber = 7, SqlFieldName = Per_OpTime ];

Storage Default
{
<Data name="PerOperateDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Status</Value>
</Value>
<Value name="3">
<Value>Type</Value>
</Value>
<Value name="4">
<Value>Comment</Value>
</Value>
<Value name="5">
<Value>Operator</Value>
</Value>
<Value name="6">
<Value>OpDate</Value>
</Value>
<Value name="7">
<Value>OpTime</Value>
</Value>
</Data>
<DataLocation>^DHCINM.HR.MgPerOperateD</DataLocation>
<DefaultData>MgPerOperateDefaultData</DefaultData>
<IdLocation>^DHCINM.HR.MgPerOperateD</IdLocation>
<IndexLocation>^DHCINM.HR.MgPerOperateI</IndexLocation>
<StreamLocation>^DHCINM.HR.MgPerOperateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
