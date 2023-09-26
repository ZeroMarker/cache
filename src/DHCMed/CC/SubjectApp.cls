/// 名称: DHCMed.CC.SubjectApp
/// 描述: 监控主题应用
/// 编写者：zhufei
/// 编写日期: 2010-05-07
Class DHCMed.CC.SubjectApp Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 代码
Property SACode As %String [ Required ];

Index SACodeIndex On SACode [ Unique ];

/// 描述
Property SADesc As %String [ Required ];

/// 监控主题字典
Property SASubjectDr As %Integer;

/// 显示分值
Property SAShowScore As %Integer;

/// 主题展现字典
Property SAShowDr As %Integer;

/// 备注
Property SAResume As %String;

/// 监控主题应用列表属性
Relationship ChildAppCols As DHCMed.CC.SubjectAppCols [ Cardinality = children, Inverse = SACParref ];

/// 监控主题应用监控项目
Relationship ChildAppSub As DHCMed.CC.SubjectAppSub [ Cardinality = children, Inverse = SASParref ];

/// Creator：     zhufei
/// CreatDate：   2010-05-07
/// Description:  将对象格式化为字符串
/// Table：       DHCMed.CC.SubjectApp
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
/// 1:Rowid 2:SACode 3:SADesc 4:SASubjectDr 5:SAShowScore 6:SAShowDr 7:SAResume
Method ToString(separete As %String) As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
	} 
	set return=..%Id()_separete
	set return=return_..SACode_separete
	set return=return_..SADesc_separete
	set return=return_..SASubjectDr_separete
	set return=return_..SAShowScore_separete
	set return=return_..SAShowDr_separete
	set return=return_..SAResume
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2010-05-07
/// Description:  根据ID取监控主题展现字典信息
/// Table：       DHCMed.CC.SubjectApp
/// Input：       ID:    DHCMed.CC.SubjectApp.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.CC.SubjectApp).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.CC.SubjectApp
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.CC.SubjectApp).%ExistsId(+id) return
	set obj=##Class(DHCMed.CC.SubjectApp).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2010-05-07
/// Description:  根据ID取监控主题展现字典信息
/// Table：       DHCMed.CC.SubjectApp
/// Input：       ID:    DHCMed.CC.SubjectApp.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.CC.SubjectApp).GetStringById(1)
ClassMethod GetStringById(id As %String, separete As %String) As %String
{
	new (id,separete)
	set return=""
	set obj=..GetObjById(id)
	if $IsObject(obj){
		set return=obj.ToString($g(separete))
	}	
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2010-05-07
/// Description:  更新SubjectApp
/// Table：       DHCMed.CC.SubjectApp
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// 1:Rowid 2:SACode 3:SADesc 4:SASubjectDr 5:SAShowScore 6:SAShowDr 7:SAResume
/// w ##class(DHCMed.CC.SubjectApp).Update("^SACode^SADesc^1^1^1^SAResume")
ClassMethod Update(InStr As %String) As %String
{
	new (InStr)
	set id=-1
	set ID=$p(InStr,"^",1)
	if ID="" {
		set obj=##class(DHCMed.CC.SubjectApp).%New()
	} else {
		set obj=##class(DHCMed.CC.SubjectApp).%OpenId(ID)
	}
	set obj.SACode=$p(InStr,"^",2)
	set obj.SADesc=$p(InStr,"^",3)
	set obj.SASubjectDr=$p(InStr,"^",4)
	set obj.SAShowScore=$p(InStr,"^",5)
	set obj.SAShowDr=$p(InStr,"^",6)
	set obj.SAResume=$p(InStr,"^",7)
	set sc=obj.%Save()
	if $system.Status.IsError(sc) {                               //检查Save是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set id=-1
	} else {
		set id=obj.%Id()
	}
	do obj.%Close()
	quit id
}

/// Creator：     zhufei
/// CreatDate：   2010-05-07
/// Description:  删除SubjectApp
/// Table：       DHCMed.CC.SubjectApp
/// Input：       SubjectAppId
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMed.CC.SubjectApp).DeleteById(1)
ClassMethod DeleteById(Id As %String) As %Boolean
{
	new (Id)
	set sc = ##class(DHCMed.CC.SubjectApp).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set ret=-1
	} else {
		set ret=0
	}
	quit ret
}

/// d ##Class(%ResultSet).RunQuery("DHCMed.CC.SubjectApp","QueryAll")
Query QueryAll() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,SACode:%String,SADesc:%String,SASubjectDr:%String,SAShowScore:%String,SAShowDr:%String,SAResume:%String")
{
	SELECT %ID,SACode,SADesc,SASubjectDr,SAShowScore,SAShowDr,SAResume FROM DHCMed_CC.SubjectApp Order by %ID desc
}

/// Creator：     zhufei
/// CreatDate：   2010-05-07
/// Description:  根据Code取监控主题展现字典信息
/// Table：       DHCMed.CC.SubjectApp
/// Input：       Code:    DHCMed.CC.SubjectApp.SACode
/// Return：      
/// w ##class(DHCMed.CC.SubjectApp).GetObjByCode(1)
ClassMethod GetObjByCode(Code As %String) As DHCMed.CC.SubjectApp
{
	new (Code)
	set return=""
	quit:Code="" return
	set id=$o(^DHCMed.CC.SubjectAppI("SACodeIndex"," "_Code,""))
	set obj=..GetObjById(id)
	if $IsObject(obj)
	{
		set return=obj
	}
	quit return
}

Storage Default
{
<Data name="SubjectAppDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SACode</Value>
</Value>
<Value name="3">
<Value>SADesc</Value>
</Value>
<Value name="4">
<Value>SAResume</Value>
</Value>
<Value name="5">
<Value>SAShowDr</Value>
</Value>
<Value name="6">
<Value>SAShowScore</Value>
</Value>
<Value name="7">
<Value>SASubjectDr</Value>
</Value>
</Data>
<DataLocation>^DHCMed.CC.SubjectAppD</DataLocation>
<DefaultData>SubjectAppDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.CC.SubjectAppD</IdLocation>
<IndexLocation>^DHCMed.CC.SubjectAppI</IndexLocation>
<StreamLocation>^DHCMed.CC.SubjectAppS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
