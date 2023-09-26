/// 函数包
/// 
/// 创建者：李阳
/// 创建日期：2010-09-11
Class DHCMed.CC.MethodPackage Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 代码
Property Code As %String;

Index CodeIndex On Code [ Unique ];

/// 函数名称
Property Name As %String [ Required ];

Index NameIndex On Name [ Unique ];

Property IsActive As %Boolean;

Property ResumeText As %String;

/// Creator：     LiYang
/// CreatDate：   2010-09-19
/// Description:  将对象格式化为字符串
/// Table：       DHCMed.CC.MethodPackage
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
/// 1:PackageID 2:Name 3:ClassMethod 4:IsActive 5:DefaultReturnValue 6:ResumeText
Method ToString(separete As %String) As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
	} 
	set return=..%Id()_separete
	set return=return_..Code_separete
	set return=return_..Name_separete
	set return=return_..Name_separete
	set return=return_..IsActive_separete
	set return=return_..ResumeText_separete
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2010-05-07
/// Description:  根据ID获取函数包信息
/// 
/// Table：       DHCMed.CC.MethodPackage
/// Input：       ID:   DHCMed.CC.MethodPackage.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.CC.MethodPackage).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.CC.MethodPackage
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.CC.MethodPackage).%ExistsId(+id) return
	set obj=##Class(DHCMed.CC.MethodPackage).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     LiYang
/// CreatDate：   2010-09-19
/// Description:  根据ID取函数包信息
/// Table：       DHCMed.CC.MethodPackage
/// Input：       ID:    DHCMed.CC.MethodPackage.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.CC.MethodPackage).GetStringById(1)
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

/// Creator：     LiYang
/// CreatDate：   2010-09-19
/// Description:  更新函数包信息
/// 
/// Table：       DHCMed.CC.MethodPackage
/// 输入格式：rowid^Code^Name^IsActive^ResumeText
ClassMethod Update(InStr As %String) As %Integer
{
	new (InStr)
	set id=0
	set ID=$p(InStr,"^",1)
	set Code=$p(InStr,"^",2)
	set Name=$p(InStr,"^",3)
	if ID="" {
		set ID=$o(^DHCMed.CCFi("Package",0,"NameIndex"," "_$zcvt(Name,"U"),0))
	}
	
	if ID="" {
		set obj=##class(DHCMed.CC.MethodPackage).%New()
	} else {
		set obj=##class(DHCMed.CC.MethodPackage).%OpenId(ID)
	}
	set obj.Code=Code
	set obj.Name=Name
	set obj.IsActive=$s($p(InStr,"^",4)="Y":1,1:0)
	set obj.ResumeText=$p(InStr,"^",5)
	set sc=obj.%Save()
	if $system.Status.IsError(sc) {                               //检查Save是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set id=-1
	}
	else{
		set id=obj.%Id()
		}
	do obj.%Close()
	quit id
}

/// 通过类库包的名称查找包信息
ClassMethod GetPackageByName(PackageName) As DHCMed.CC.MethodPackage
{
	n (PackageName)
	q:PackageName="" ""
	s PackageName=" "_PackageName
	s rowid=$o(^DHCMed.CCFi("Package",0,"NameIndex",PackageName,""))
	q:rowid="" "" //没找到~~
	s objPackage=##class(DHCMed.CC.MethodPackage).%OpenId(rowid)
	d objPackage.%Close()
	q objPackage
}

ClassMethod Test()
{
	//w ##class(DHCMed.CC.MethodPackage).Test()
	s arg="^01^OrderLib^Y^ResumeText"
	w ..Update(arg)
	q ""
}

/// 查询包列表
Query QueryPackage(IsActive As %Boolean) As %SQLQuery(CONTAINID = 1)
{
SELECT %ID,Code,IsActive,Name,ResumeText FROM MethodPackage
 WHERE (IsActive = :IsActive)
 ORDER BY Name
}

//w ##class(DHCMed.CC.MethodPackage).CheckByCode("1")

ClassMethod CheckByCode(aCode As %String) As %String
{
	New (aCode)
	Set return=""
	Quit:aCode="" return
	
	Set return=0
	Set id=$o(^DHCMed.CCFi("Package",0,"CodeIndex"," "_aCode,""))
	Set:id>0 return=1  //重复
	Quit return
}

Storage Default
{
<Data name="MethodPackageDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ActualName</Value>
</Value>
<Value name="3">
<Value>IsActive</Value>
</Value>
<Value name="4">
<Value>Name</Value>
</Value>
<Value name="5">
<Value>ResumeText</Value>
</Value>
<Value name="6">
<Value>MethodList</Value>
</Value>
<Value name="7">
<Value>Code</Value>
</Value>
<Value name="8">
<Value>MethodName</Value>
</Value>
</Data>
<DataLocation>^DHCMed.CCF("Package")</DataLocation>
<DefaultData>MethodPackageDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.CCF("Package")</IdLocation>
<IndexLocation>^DHCMed.CCFi("Package",0)</IndexLocation>
<StreamLocation>^DHCMed.CC.MethodPackageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
