/// 阳光用药标准值 考核方案表
/// DHCWL_CheckFun.DHCWLCheckSet d ##class(DHCWL.CheckFun.CheckSet).%BuildIndices()
Class DHCWL.CheckFun.CheckSet Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = DHCWLCheckSet ]
{

/// 	    考核方案代码
Property CheckSetCode As %String [ SqlColumnNumber = 2, SqlFieldName = CheckSet_Code ];

/// 		考核方案描述		 
Property CheckSetDesc As %String [ SqlColumnNumber = 3, SqlFieldName = CheckSet_Desc ];

/// 		考核区间类型
Property CheckSetSectionType As %String [ SqlColumnNumber = 4, SqlFieldName = CheckSet_SectionType ];

/// 		考核对象类型
Property CheckSetObjType As %String [ SqlColumnNumber = 5, SqlFieldName = CheckSet_ObjType ];

/// 		考核对象属性
Property CheckSetObjDim As %String [ SqlColumnNumber = 8, SqlFieldName = CheckSet_ObjDim ];

/// 		更新日期
Property CheckSetUpdateDate As %Date [ SqlColumnNumber = 6, SqlFieldName = CheckSet_UpdateDate ];

/// 		更新用户
Property CheckSetUpdateUser As %String [ SqlColumnNumber = 7, SqlFieldName = CheckSet_UpdateUser ];

Index Code On CheckSetCode As AlphaUp;

Index Desc On CheckSetDesc As AlphaUp;

Index UpdateDate On CheckSetUpdateDate;

Index UpdateUser On CheckSetUpdateUser As AlphaUp;

Storage Default
{
<Data name="CheckSetDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CheckSetCode</Value>
</Value>
<Value name="3">
<Value>CheckSetDesc</Value>
</Value>
<Value name="4">
<Value>CheckSetSectionType</Value>
</Value>
<Value name="5">
<Value>CheckSetObjType</Value>
</Value>
<Value name="6">
<Value>CheckSetUpdateDate</Value>
</Value>
<Value name="7">
<Value>CheckSetUpdateUser</Value>
</Value>
<Value name="8">
<Value>CheckSetObjDim</Value>
</Value>
</Data>
<DataLocation>^DHCWL.CheckFun.CheckSetD</DataLocation>
<DefaultData>CheckSetDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWL.CheckFun.CheckSetD</IdLocation>
<IndexLocation>^DHCWL.CheckFun.CheckSetI</IndexLocation>
<StreamLocation>^DHCWL.CheckFun.CheckSetS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
