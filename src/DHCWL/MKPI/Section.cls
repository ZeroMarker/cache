/// 区间定义表 DHCWL_MKPI.DHCWLSection
Class DHCWL.MKPI.Section Extends %Persistent [ ClassType = persistent, SqlTableName = DHCWLSection ]
{

/// 代码
Property SecCode As %String [ SqlColumnNumber = 2, SqlFieldName = Sec_Code ];

/// 名称
Property SecName As %String [ SqlColumnNumber = 3, SqlFieldName = Sec_Name ];

/// 描述
Property SecDesc As %String [ SqlColumnNumber = 4, SqlFieldName = Sec_Desc ];

/// 用户
Property SecUser As %String [ SqlColumnNumber = 5, SqlFieldName = Sec_User ];

/// 创建日期
Property SecUpdateDate As %Date [ SqlColumnNumber = 6, SqlFieldName = Sec_UpdateDate ];

/// 备注
Property SecRemark As %String [ SqlColumnNumber = 7, SqlFieldName = Sec_Remark ];

/// 直接父区间add by lhh@20130223
Property SecDirectParent As DHCWL.MKPI.Section [ SqlColumnNumber = 8, SqlFieldName = Sec_DirectParent ];

Index SecCode On SecCode As AlphaUp;

Index SecName On SecName As AlphaUp;

ClassMethod GetIdByCode(code) As %String
{
	q:code="" ""
	if ($d(^DHCWL.MKPI.SectionD(code))) q code
	q $o(^DHCWL.MKPI.SectionI("SecCode",$SYSTEM.SQL.ALPHAUP(code),""))
}

ClassMethod GetCodeById(id) As %String
{
	if ('$d(^DHCWL.MKPI.SectionD(code))){
		s id=..GetIdByCode(id)
	}
	i $d(^DHCWL.MKPI.SectionD(id)) q $lg(^DHCWL.MKPI.SectionD(id),2)
	q ""
}

Storage Default
{
<Data name="SectionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SecCode</Value>
</Value>
<Value name="3">
<Value>SecDesc</Value>
</Value>
<Value name="4">
<Value>SecName</Value>
</Value>
<Value name="5">
<Value>SecRemark</Value>
</Value>
<Value name="6">
<Value>SecUpdateDate</Value>
</Value>
<Value name="7">
<Value>SecUser</Value>
</Value>
<Value name="8">
<Value>SecDirectParent</Value>
</Value>
</Data>
<DataLocation>^DHCWL.MKPI.SectionD</DataLocation>
<DefaultData>SectionDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWL.MKPI.SectionD</IdLocation>
<IndexLocation>^DHCWL.MKPI.SectionI</IndexLocation>
<StreamLocation>^DHCWL.MKPI.SectionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
