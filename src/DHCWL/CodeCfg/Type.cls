/// 类型代码维护
Class DHCWL.CodeCfg.Type Extends (%Persistent, DHCWL.ABSCodeCFG) [ Inheritance = right, Not ProcedureBlock, SqlTableName = DHCWLCodeCfgType ]
{

/// 代码
Property TypeCode As %String [ SqlColumnNumber = 2, SqlFieldName = Type_Code ];

/// 名称
Property TypeDesc As %String [ SqlColumnNumber = 3, SqlFieldName = Type_Desc ];

/// 有效标志
Property TypeFlag As %String [ SqlColumnNumber = 4, SqlFieldName = Type_Flag ];

/// 执行代码
Property TypeExtCode As %String [ SqlColumnNumber = 5, SqlFieldName = Type_ExtCode ];

/// 值描述
Property TypeValueDes As %String [ SqlColumnNumber = 6, SqlFieldName = Type_ValueDes ];

/// 创建日期
Property TypeCreateDate As %Date [ SqlColumnNumber = 7, SqlFieldName = Type_CreateDate ];

/// 创建时间
Property TypeCreateTime As %Time [ SqlColumnNumber = 8, SqlFieldName = Type_CreateTime ];

/// 创建人
Property TypeCreateUse As %String [ SqlColumnNumber = 9, SqlFieldName = Type_CreateUse ];

Index Code On TypeCode;

Index Desc On TypeDesc;

Index Type On TypeFlag;

///  DHCWL_CodeCfg.DHCWLCodeCfgType   d ##class(DHCWL.CodeCfg.Type).%BuildIndices()
Method GetAllExecData() As %String
{
	q:..TypeExtCode="" 0
	s execCode="s num=$$"_..TypeExtCode_"()"
	x execCode
	q $g(num)
}

Method GetValueById(id) As %String
{
	q:..TypeValueDes="" ""
	s execCode=..TypeValueDes
	s execCode="s value=$$"_execCode_"("""_id_""")"
	x execCode 	
	q value
}

/// Creator：      yuanxu
/// CreatDate：    2014-05-05
/// Description:： 通过类型ID获取该类型下的内容
/// Table：       DHCWL_CodeCfg.DHCWLCodeCfgType
/// Input：       
/// Output：      
/// Return：      返回记录数
/// Others：w ##class(DHCWL.CodeCfg.Type).GetCfgTypeDataById("1")
ClassMethod GetCfgTypeDataById(id) As %String
{
	
	n (id)
	q:id="" 0
	s cfgType=##class(DHCWL.CodeCfg.Type).%OpenId(id)
	q cfgType.GetAllExecData()
}

/// Creator：      yuanxu
/// CreatDate：    2014-05-05
/// Description:： 通过类型Code获取该类型下的内容
/// Table：       DHCWL_CodeCfg.DHCWLCodeCfgType
/// Input：       
/// Output：      
/// Return：      返回记录数
/// Others：d ##class(DHCWL.CodeCfg.Type).GetCfgTypeDataByCode("CTLOC")
ClassMethod GetCfgTypeDataByCode(code) As %String
{
	
	n (code)
	q:code="" 0
	s id=$o(^DHCWL.CodeCfg.TypeI("Code"," "_code,"")) 
	q:id="" 0 
	q ##class(DHCWL.CodeCfg.Type).GetCfgTypeDataById(id)
}

/// Creator：      yuanxu
/// CreatDate：    2014-05-05
/// Description:： 通过类型ID和该类型下具体ID得到该类型下的值描述
/// Table：       DHCWL_CodeCfg.DHCWLCodeCfgType
/// Input：       
/// Output：      
/// Return：      返回值描述
/// Others：w ##class(DHCWL.CodeCfg.Type).GetValueDeseById("1","1")
ClassMethod GetValueDeseById(id, dtid) As %String
{
	
	n (id,dtid)
	q:(id="")!(dtid="") ""
	s cfgType=##class(DHCWL.CodeCfg.Type).%OpenId(id)
	q cfgType.GetValueById(dtid)
	;q:cfgtype.TypeValueDes="" 0
	;s execCode=cfgtype.TypeValueDes
	;s execCode="s value=$$"_execCode_"("_dtid_")"
	;x execCode
	;q $g(value)
}

Storage Default
{
<Data name="TypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TypeCode</Value>
</Value>
<Value name="3">
<Value>TypeCreateDate</Value>
</Value>
<Value name="4">
<Value>TypeCreateTime</Value>
</Value>
<Value name="5">
<Value>TypeCreateUse</Value>
</Value>
<Value name="6">
<Value>TypeDesc</Value>
</Value>
<Value name="7">
<Value>TypeExtCode</Value>
</Value>
<Value name="8">
<Value>TypeFlag</Value>
</Value>
<Value name="9">
<Value>TypeValueDes</Value>
</Value>
<Value name="10">
<Value>TypeExtCode1</Value>
</Value>
</Data>
<DataLocation>^DHCWL.CodeCfg.TypeD</DataLocation>
<DefaultData>TypeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWL.CodeCfg.TypeD</IdLocation>
<IndexLocation>^DHCWL.CodeCfg.TypeI</IndexLocation>
<StreamLocation>^DHCWL.CodeCfg.TypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
