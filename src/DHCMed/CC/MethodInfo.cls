/// 监控类库暴露的函数
/// 
/// 创建者：李阳
/// 创建日期：2010-09-19
Class DHCMed.CC.MethodInfo Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 所属包的ID	
Property PackageID As %Integer [ Required ];

Index PackageIDIndex On PackageID;

/// 暴露的函数名称
Property Name As %String [ Required ];

Index NameIndex On (Name, PackageID) [ Unique ];

/// 书写格式
/// ##class(类名).ClassName
Property ClassMethod As %String(MAXLEN = 100);

Property IsActive As %Boolean;

/// 备注
Property ResumeText As %String(MAXLEN = 500);

/// 当该方法出错时应该返回的值
Property DefaultReturnValue As %String(MAXLEN = 500);

/// Creator：     LiYang
/// CreatDate：   2010-09-19
/// Description:  将对象格式化为字符串
/// Table：       DHCMed.CC.MethodInfo
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
/// 1:PackageID 2:Name 3:ClassMethod 4:IsActive 5:DefaultReturnValue 6:ResumeText
Method ToString(separete As %String) As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
	} 
	set return=..%Id()_separete
	set return=return_..PackageID_separete
	set return=return_..Name_separete
	set return=return_..ClassMethod_separete
	set return=return_..IsActive_separete
	set return=return_..DefaultReturnValue_separete
	set return=return_..ResumeText_separete
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2010-05-07
/// Description:  根据ID取监控函数信息
/// 
/// Table：       DHCMed.CC.MethodInfo
/// Input：       ID:   DHCMed.CC.MethodInfo.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.CC.MethodInfo).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.CC.MethodInfo
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.CC.MethodInfo).%ExistsId(+id) return
	set obj=##Class(DHCMed.CC.MethodInfo).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     LiYang
/// CreatDate：   2010-09-19
/// Description:  根据ID取监控函数信息
/// 
/// Table：       DHCMed.CC.MethodInfo
/// Input：       ID:    DHCMed.CC.MethodInfo.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.CC.MethodInfo).GetStringById(1)
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
/// Description:  根据ID取监控主题信息
/// 
/// Table：       DHCMed.CC.MethodInfo
/// 输入格式:  rowid^PackageID^Name^ClassMethod^IsActive^DefaultReturnValue^ResumeText
/// w ##class(DHCMed.CC.MethodInfo).Update("^1^Fn01^##class(DHCMed.CCService.Sys.Lab.TestClass).Fn01([Number],[Number])^1^ResumeText^-1^^^^")
ClassMethod Update(InStr As %String) As %Integer
{
	new (InStr)
	set id=0
	set ID=$p(InStr,"^",1)	
	set PackageID=$p(InStr,"^",2)
	set Name=$p(InStr,"^",3)
	if ID="" {
		set ID=$o(^DHCMed.CCFi("PMethod",0,"NameIndex"," "_$zcvt(Name,"U"),PackageID,0))
	}
	
	if ID="" {
		set obj=##class(DHCMed.CC.MethodInfo).%New()
	} else {
		set obj=##class(DHCMed.CC.MethodInfo).%OpenId(ID)
	}
	set obj.PackageID=PackageID
	set obj.Name=Name
	set obj.ClassMethod=$p(InStr,"^",4)
	set obj.IsActive=$s($p(InStr,"^",5)="Y":1,1:0)
	set obj.ResumeText=$p(InStr,"^",6)
	set obj.DefaultReturnValue=$p(InStr,"^",7)
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

/// 通过方法名称查询类库方法
ClassMethod GetMethodInfoByName(PackageID, MethodName) As DHCMed.CC.MethodInfo
{
	n (PackageID,MethodName)
	q:(PackageID="")!(MethodName="") ""
	s MethodName=" "_MethodName
	s rowid=$o(^DHCMed.CCFi("PMethod",0,"NameIndex",MethodName,PackageID,""))
	i rowid'=""  d
	.s obj=##class(DHCMed.CC.MethodInfo).%OpenId(rowid)
	.d obj.%Close()
	e  d
	.s obj=""
	q obj
}

/// 查询包函数
Query QueryMethod(PackageID As %String, MethodName As %String, IsActive As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT %ID,ClassMethod,DefaultReturnValue,IsActive,Name,PackageID,ResumeText FROM MethodInfo
 WHERE (PackageID = :PackageID AND Name %STARTSWITH :MethodName AND IsActive = :IsActive)
 ORDER BY Name
}

Storage Default
{
<Data name="MethodInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ClassMethod</Value>
</Value>
<Value name="3">
<Value>IsActive</Value>
</Value>
<Value name="4">
<Value>Name</Value>
</Value>
<Value name="5">
<Value>ParamList</Value>
</Value>
<Value name="6">
<Value>ResumeText</Value>
</Value>
<Value name="7">
<Value>DefaultReturnValue</Value>
</Value>
<Value name="8">
<Value>PackageID</Value>
</Value>
</Data>
<DataLocation>^DHCMed.CCF("PMethod")</DataLocation>
<DefaultData>MethodInfoDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.CCF("PMethod")</IdLocation>
<IndexLocation>^DHCMed.CCFi("PMethod",0)</IndexLocation>
<StreamLocation>^DHCMed.CC.MethodInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
