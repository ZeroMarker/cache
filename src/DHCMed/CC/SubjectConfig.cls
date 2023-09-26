/// 名称: DHCMed.CC.SubjectConfig
/// 描述: 监控主题项目配置
/// 编写者：liuyh
/// 编写日期: 2013-02-25
Class DHCMed.CC.SubjectConfig Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 监控主题代码
Property SubjectCode As %String [ Required ];

/// 代码
Property Code As %String [ Required ];

/// 描述
Property Description As %String;

/// 生效
Property IsActive As %Boolean;

/// 备注
Property ResumeText As %String;

Index CodeIndex On (SubjectCode, Code);

Index IndexCode On Code [ Unique ];

/// Creator：     liuyh
/// CreatDate：   2013-02-25
/// Description:  将对象格式化为字符串
/// Table：       DHCMed.CC.SubjectConfig
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
Method ToString(separete As %String) As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
		} 
	set return=..%Id()_separete
	set return=return_..SubjectCode_separete
	set return=return_..Code_separete
	set return=return_..Description_separete
	set return=return_..IsActive_separete
	set return=return_..ResumeText_separete
	quit return
}

/// Creator：     liuyh
/// CreatDate：   2013-02-25
/// Description:  根据ID取监控主题项目配置
/// Table：       DHCMed.CC.SubjectConfig
/// Input：       ID:    DHCMed.CC.SubjectConfig.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.CC.SubjectConfig).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.CC.SubjectConfig
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.CC.SubjectConfig).%ExistsId(+id) return
	set obj=##Class(DHCMed.CC.SubjectConfig).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// 通过代码查询监控主题
/// w ##class(DHCMed.CC.SubjectConfig).GetObjByCode("INTCCS")
ClassMethod GetObjByCode(Code As %String) As DHCMed.CC.Subject
{
	New (Code)
	Set return=""
	Set ID=$o(^DHCMed.CC.SubjectConfigI("IndexCode"," "_$zcvt(Code,"U"),""))
	Quit:ID="" return
	Set return=..GetObjById(ID)
	Quit return
}

/// Creator：     liuyh
/// CreatDate：   2013-02-25
/// Description:  根据ID取监控主题项目配置
/// Table：       DHCMed.CC.SubjectConfig
/// Input：       ID:    DHCMed.CC.SubjectConfig.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.CC.SubjectConfig).GetStringById(1)
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

/// Creator：     liuyh
/// CreatDate：   2013-02-25
/// Description:  更新监控主题项目配置
/// Table：       DHCMed.CC.SubjectConfig
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
ClassMethod Update(InStr As %String) As %String
{
	new (InStr)
	set $ZT="UpdateErr"
	set id=0
	set ID=$p(InStr,"^",1)	
	if ID="" {
		set obj=##class(DHCMed.CC.SubjectConfig).%New()
		} 
	else {
		set obj=##class(DHCMed.CC.SubjectConfig).%OpenId(ID)
		}
	set obj.SubjectCode=$p(InStr,"^",2)
	set obj.Code=$p(InStr,"^",3)
	set obj.Description=$p(InStr,"^",4)
	set obj.IsActive=$p(InStr,"^",5)
	set obj.ResumeText=$p(InStr,"^",6)
	set sc=obj.%Save()
	if $system.Status.IsError(sc) {                               //检查Save是否成功
   		//d $system.OBJ.DisplayError(sc) 
   		set id=-1
	}
	else{
		set id=obj.%Id()
		}
	do obj.%Close()
	quit id
UpdateErr
	quit -1
}

/// Creator：     liuyh
/// CreatDate：   2013-02-25
/// Description:  删除监控项目子类
/// Table：       DHCMed.CC.SubjectConfig
/// Input：       ContentDicId
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id As %String) As %String
{
	new (Id)
	Set return=0
	Set sc = ##class(DHCMed.CC.SubjectConfig).%DeleteId(+Id)
	If $System.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

Storage Default
{
<Data name="SubjectConfigDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>Description</Value>
</Value>
<Value name="4">
<Value>IsActive</Value>
</Value>
<Value name="5">
<Value>ResumeText</Value>
</Value>
<Value name="6">
<Value>SubjectCode</Value>
</Value>
</Data>
<DataLocation>^DHCMed.CC.SubjectConfigD</DataLocation>
<DefaultData>SubjectConfigDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.CC.SubjectConfigD</IdLocation>
<IndexLocation>^DHCMed.CC.SubjectConfigI</IndexLocation>
<StreamLocation>^DHCMed.CC.SubjectConfigS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
