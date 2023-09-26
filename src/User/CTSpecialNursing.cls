/// 项目：重庆人民医院，添加专项护理字典维护界面
/// 描述: 专项护理字典表
/// 表名：CTSpecialNursing
/// 编写者：基础数据平台组 李可凡
/// 编写日期: 2019年8月22日
Class User.CTSpecialNursing Extends (%Persistent, User.Abstract) [ ClassType = persistent, ProcedureBlock, SqlTableName = CT_SpecialNursing ]
{

/// 代码
Property SpecialNursingCode As %String;

/// 描述
Property SpecialNursingDesc As %String;

/// 备注
Property SpecialNursingRemark As %String;

/// 代码索引
Index SpNurCodeIndex On SpecialNursingCode [ Unique ];

/// 描述索引
Index SpNurDescIndex On SpecialNursingDesc [ Unique ];

Storage Default
{
<Data name="CTSpecialNursingDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SpecialNursingCode</Value>
</Value>
<Value name="3">
<Value>SpecialNursingDesc</Value>
</Value>
<Value name="4">
<Value>SpecialNursingRemark</Value>
</Value>
</Data>
<DataLocation>^User.CTSpecialNursingD</DataLocation>
<DefaultData>CTSpecialNursingDefaultData</DefaultData>
<IdLocation>^User.CTSpecialNursingD</IdLocation>
<IndexLocation>^User.CTSpecialNursingI</IndexLocation>
<StreamLocation>^User.CTSpecialNursingS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
