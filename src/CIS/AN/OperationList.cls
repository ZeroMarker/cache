/// 实施手术
Class CIS.AN.OperationList Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = OperationList ]
{

/// 手术计划ID
Property OperCatalogue As CIS.AN.OperCatalogue [ Required, SqlColumnNumber = 2 ];

/// 手术名称
Property Operation As %String [ SqlColumnNumber = 3 ];

/// 手术等级
Property OperClass As %String [ SqlColumnNumber = 4 ];

/// 切口类型
Property BladeType As %String [ SqlColumnNumber = 5 ];

/// 手术部位
Property BodySite As %String [ SqlColumnNumber = 6 ];

/// 手术体位
Property OperPos As %String [ SqlColumnNumber = 7 ];

/// 手术医生
Property Surgeon As %String [ SqlColumnNumber = 8 ];

/// 手术助手
Property Assistant As %String [ SqlColumnNumber = 9 ];

/// 手术医生科室
Property SurgeonDeptID As %String [ SqlColumnNumber = 10 ];

/// 手术进修和实习医护人员
Property AddtionalStaff As %String [ SqlColumnNumber = 11 ];

/// 手术名称备注(用于存储用户输入的手术名称字符串)
Property OperNote As %String(MAXLEN = 200) [ SqlColumnNumber = 12 ];

/// 术后诊断
Property PostDiagnosis As %String(MAXLEN = 200) [ SqlColumnNumber = 13 ];

/// 外部系统申请的手术ID
Property ExternalID As %String [ SqlColumnNumber = 14 ];

/// 外院专家主刀
Property SurgeonExpert As %String [ SqlColumnNumber = 15 ];

/// 手术助手科室ID
Property AssisDeptID As %String [ SqlColumnNumber = 16 ];

/// 结构化手术字典ID
Property SKDOperID As %String [ SqlColumnNumber = 17 ];

/// 手术部位说明
Property SiteNote As %String(MAXLEN = 200) [ SqlColumnNumber = 18 ];

/// 紧急手术
Property EmergencyOperation As %Library.String(DISPLAYLIST = ",是,否", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 19 ];

/// 手术申请索引
Index IOPS On OperCatalogue;

/// 外部系统ID索引
Index IExt On ExternalID;

/// 手术申请外键约束
ForeignKey FKOperSchedule(OperCatalogue) References CIS.AN.OperCatalogue() [ OnDelete = cascade ];

Storage Default
{
<Data name="OperationListDefaultData">
<Value name="1">
<Value>OperCatalogue</Value>
</Value>
<Value name="2">
<Value>Operation</Value>
</Value>
<Value name="3">
<Value>OperClass</Value>
</Value>
<Value name="4">
<Value>BladeType</Value>
</Value>
<Value name="5">
<Value>BodySite</Value>
</Value>
<Value name="6">
<Value>OperPos</Value>
</Value>
<Value name="7">
<Value>Surgeon</Value>
</Value>
<Value name="8">
<Value>Assistant</Value>
</Value>
<Value name="9">
<Value>SurgeonDeptID</Value>
</Value>
<Value name="10">
<Value>AddtionalStaff</Value>
</Value>
<Value name="11">
<Value>OperNote</Value>
</Value>
<Value name="12">
<Value>PostDiagnosis</Value>
</Value>
<Value name="13">
<Value>ExternalID</Value>
</Value>
<Value name="14">
<Value>SurgeonExpert</Value>
</Value>
<Value name="15">
<Value>AssisDeptID</Value>
</Value>
<Value name="16">
<Value>SKDOperID</Value>
</Value>
<Value name="17">
<Value>SiteNote</Value>
</Value>
<Value name="18">
<Value>EmergencyOperation</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.OperationListD</DataLocation>
<DefaultData>OperationListDefaultData</DefaultData>
<IdLocation>^CIS.AN.OperationListD</IdLocation>
<IndexLocation>^CIS.AN.OperationListI</IndexLocation>
<StreamLocation>^CIS.AN.OperationListS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
