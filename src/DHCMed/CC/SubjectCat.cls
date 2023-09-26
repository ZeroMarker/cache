/// 监控主题类别
Class DHCMed.CC.SubjectCat Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 代码
Property Code As %String;

Index CodeIndex On Code [ Unique ];

/// 名称
Property Title As %String;

/// 描述
Property Description As %String;

/// 生效
Property IsActive As %Boolean;

/// 备注
Property ResumeText As %String;

/// Creator：     liuyh
/// CreatDate：   2010-09-26
/// Description:  将对象格式化为字符串
/// Table：       DHCMed.CC.SubjectCat
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
/// 1:Rowid 2:Code 3:Title 4:Description 5:IsActive 6:ResumeText
Method ToString(separete As %String) As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
		} 
	set return=..%Id()_separete
	set return=return_..Code_separete
	set return=return_..Title_separete
	set return=return_..Description_separete
	set return=return_..IsActive_separete
	set return=return_..ResumeText
	quit return
}

/// Creator：     liuyh
/// CreatDate：   2010-09-26
/// Description:  根据ID取监控主题类别对象
/// Table：       DHCMed.CC.SubjectCat
/// Input：       ID:    DHCMed.CC.SubjectCat.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.CC.ItemCat).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.CC.SubjectCat
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.CC.SubjectCat).%ExistsId(+id) return
	set obj=##Class(DHCMed.CC.SubjectCat).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     liuyh
/// CreatDate：   2010-09-26
/// Description:  根据ID取监控主题类别信息
/// Table：       DHCMed.CC.SubjectCat
/// Input：       id: DHCMed.CC.SubjectCat.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.CC.SubjectCat).GetStringById(1)
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
/// CreatDate：   2010-09-26
/// Description:  更新监控主题类别
/// Table：       DHCMed.CC.SubjectCat
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// 1:Rowid 2:Code 3:Title 4:Description 5:IsActive 6:ResumeText
ClassMethod Update(InStr As %String) As %String
{
	new (InStr)
	set id=0
	set ID=$p(InStr,"^",1)	
	if ID="" {
		set obj=##class(DHCMed.CC.SubjectCat).%New()
		} 
	else {
		set obj=##class(DHCMed.CC.SubjectCat).%OpenId(ID)
		}
	set obj.Code=$p(InStr,"^",2)
	set obj.Title=$p(InStr,"^",3)
	set obj.Description=$p(InStr,"^",4)
	set obj.IsActive=$p(InStr,"^",5)
	set obj.ResumeText=$p(InStr,"^",6)
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

/// Creator：     liuyh
/// CreatDate：   2010-09-26
/// Description:  删除监控主题类别
/// Table：       DHCMed.CC.SubjectCat
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id As %String) As %String
{
	new (Id)
	set sc = ##class(DHCMed.CC.SubjectCat).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set ret=-1
	}
	else{
		set ret=0
		}
	quit ret
}

Storage Default
{
<Data name="SubjectCatDefaultData">
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
<Value>Title</Value>
</Value>
</Data>
<DataLocation>^DHCMed.CC.SubjectCatD</DataLocation>
<DefaultData>SubjectCatDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.CC.SubjectCatD</IdLocation>
<IndexLocation>^DHCMed.CC.SubjectCatI</IndexLocation>
<StreamLocation>^DHCMed.CC.SubjectCatS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
