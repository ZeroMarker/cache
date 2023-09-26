/// creator: xbl
/// createdate: 20180117
/// description: 护士长夜查房排班表
Class DHCNMG.Set.MgNHChkArrange Extends %Persistent
{

/// 排班时间
Property ArgDate As %Date [ SqlColumnNumber = 2, SqlFieldName = Arg_Date ];

/// 组别 C:检查表 T:追踪表
Property ArgType As %String [ SqlColumnNumber = 3, SqlFieldName = Arg_Type ];

/// 类型 L:小夜 B:大夜
Property ArgPost As %String [ SqlColumnNumber = 4, SqlFieldName = Arg_Post ];

/// 备注
Property ArgRemark As %String(MAXLEN = 10000) [ SqlColumnNumber = 5, SqlFieldName = Arg_Remark ];

/// 查房人
Property ArgCheckUser As list Of %String [ SqlColumnNumber = 6, SqlFieldName = Arg_User ];

/// 创建者
Property ArgCrtUser As DHCNMG.HR.MgPersons [ SqlColumnNumber = 7, SqlFieldName = Arg_CrtUser ];

/// 创建日期
Property ArgCrtDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 8, SqlFieldName = Arg_CrtDate ];

/// 创建时间
Property ArgCrtTime As %Time [ InitialExpression = {$P($h,",",2)}, SqlColumnNumber = 9, SqlFieldName = Arg_CrtTime ];

Index Date On ArgDate;

Index Type On ArgType;

Index Post On ArgPost;

Index TypeDate On (ArgType, ArgDate);

Storage Default
{
<Data name="MgNHChkArrangeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ArgDate</Value>
</Value>
<Value name="3">
<Value>ArgType</Value>
</Value>
<Value name="4">
<Value>ArgPost</Value>
</Value>
<Value name="5">
<Value>ArgRemark</Value>
</Value>
<Value name="6">
<Value>ArgCheckUser</Value>
</Value>
<Value name="7">
<Value>ArgCrtUser</Value>
</Value>
<Value name="8">
<Value>ArgCrtDate</Value>
</Value>
<Value name="9">
<Value>ArgCrtTime</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.Set.MgNHChkArrangeD</DataLocation>
<DefaultData>MgNHChkArrangeDefaultData</DefaultData>
<IdLocation>^DHCNMG.Set.MgNHChkArrangeD</IdLocation>
<IndexLocation>^DHCNMG.Set.MgNHChkArrangeI</IndexLocation>
<StreamLocation>^DHCNMG.Set.MgNHChkArrangeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
