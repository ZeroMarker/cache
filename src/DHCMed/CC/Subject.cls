/// 监控主题
/// 创建者：李阳
/// 创建日期：2010-09-17
Class DHCMed.CC.Subject Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 代码
Property Code As %String;

Index CodeIndex On Code [ Unique ];

/// 主题名称
Property Title As %String [ Required ];

/// 描述
Property Description As %String;

/// 监控主题类别
Property Categroy As %Integer;

// [ Required ];

Index CategroyIndex On Categroy;

/// 汇总表达式
Property Expression As %String(MAXLEN = 5000);

//[ Required ];

/// 是否有效
Property IsActive As %Boolean;

/// 是否自动作业处理
Property IsAutoRun As %Boolean;

/// 是否生成时间线数据
Property IsTimeLine As %Boolean;

/// 备注
Property ResumeText As %String;

/// Creator：     LiYang
/// CreatDate：   2010-09-19
/// Description:  将对象格式化为字符串
/// Table：       DHCMed.CC.Subject
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
/// 1:Rowid 2:Code 3:Title 4:Description 5:Category 6:IsActive 7:Resume
Method ToString(separete As %String) As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
	} 
	set return=..%Id()_separete
	set return=return_..Code_separete
	set return=return_..Title_separete
	set return=return_..Description_separete
	set return=return_..Categroy_separete
	set return=return_..Expression_separete
	set return=return_..IsActive_separete
	set return=return_..ResumeText_separete
	set return=return_..IsAutoRun_separete
	set return=return_..IsTimeLine
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2010-05-07
/// Description:  根据ID取监控主题信息
/// Table：       DHCMed.CC.Subject
/// Input：       ID:    DHCMed.CC.Subject.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.CC.Subject).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.CC.Subject
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.CC.Subject).%ExistsId(+id) return
	set obj=##Class(DHCMed.CC.Subject).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     LiYang
/// CreatDate：   2010-09-19
/// Description:  根据ID取监控主题信息
/// Table：       DHCMed.CC.Subject
/// Input：       ID:    DHCMed.CC.Subject.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.CC.Subject).GetStringById(1)
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

/// Add By LiYang 2011-06-27
/// 通过代码查询监控主题
/// w ##class(DHCMed.CC.Subject).GetObjByCode("INTCCS")
ClassMethod GetObjByCode(Code As %String) As DHCMed.CC.Subject
{
	New (Code)
	Set return=""
	Set ID=$o(^DHCMed.CCi("Subject",0,"CodeIndex"," "_$zcvt(Code,"U"),""))
	Quit:ID="" return
	Set return=..GetObjById(ID)
	Quit return
}

/// Creator：     LiYang
/// CreatDate：   2010-09-19
/// Description:  更新监控主题信息
/// Table：       DHCMed.CC.Subject
/// 输入格式：Code^Title^Description^Categroy^Expression^IsActive^ResumeText
/// w ##class(DHCMed.CC.Subject).Update("^INFCC^感染综合监测^感染综合监测^0^^1^^1")
ClassMethod Update(InStr As %String, sperator As %String = "^") As %String
{
	new (InStr, sperator)
	set $zt="UpdateErr"
	set id=-1
	set ID=$p(InStr,sperator,1)
	if ID="" {
		set obj=##class(DHCMed.CC.Subject).%New()
	} else {
		set obj=##class(DHCMed.CC.Subject).%OpenId(ID)
	}
	set obj.Code=$p(InStr,"^",2)
	set obj.Title=$p(InStr,"^",3)
	set obj.Description=$p(InStr,"^",4)
	set obj.Categroy=$p(InStr,"^",5)
	set obj.Expression=$p(InStr,"^",6)
	set obj.IsActive=$p(InStr,"^",7)
	set obj.ResumeText=$p(InStr,"^",8)
	set obj.IsAutoRun=+$p(InStr,"^",9)
	set obj.IsTimeLine=+$p(InStr,"^",10)
	set sc=obj.%Save()
	if $system.Status.IsError(sc) {                               //检查Save是否成功
   		//d $system.OBJ.DisplayError(sc) 
   		set id=-1
	} else {
		set id=obj.%Id()
	}
	do obj.%Close()
	quit id
UpdateErr
	quit -1
}

/// Creator：     zhufei
/// CreatDate：   2012-09-03
/// Description:  删除监控主题信息
/// Table：       DHCMed.CC.Subject
/// Input：       ItemId
/// Return：      ret>0:成功  ret<0:失败
ClassMethod DeleteById(Id As %String) As %String
{
	new (Id)
	set sc = ##class(DHCMed.CC.Subject).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		//d $system.OBJ.DisplayError(sc) 
   		set ret=-1
	}else{
		set ret=0
	}
	quit ret
}

Storage Default
{
<Data name="SubjectDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Categroy</Value>
</Value>
<Value name="3">
<Value>Code</Value>
</Value>
<Value name="4">
<Value>Description</Value>
</Value>
<Value name="5">
<Value>Expression</Value>
</Value>
<Value name="6">
<Value>IsActive</Value>
</Value>
<Value name="7">
<Value>ResumeText</Value>
</Value>
<Value name="8">
<Value>Title</Value>
</Value>
<Value name="9">
<Value>IsAutoRun</Value>
</Value>
<Value name="10">
<Value>IsTimeLine</Value>
</Value>
</Data>
<DataLocation>^DHCMed.CC("Subject")</DataLocation>
<DefaultData>SubjectDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.CC("Subject")</IdLocation>
<IndexLocation>^DHCMed.CCi("Subject",0)</IndexLocation>
<StreamLocation>^DHCMed.CC.SubjectS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
