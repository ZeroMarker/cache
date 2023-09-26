/// 名称: DHCMed.CC.SubjectColor
/// 描述: 监控主题颜色
/// 编写者：liuyh
/// 编写日期: 2010-11-04
Class DHCMed.CC.SubjectColor Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 颜色值
Property ColorRGB As %String [ Required ];

/// 主题ID DHCMed.CC.Subject
Property SubjectDr As %Integer [ Required ];

/// 分数
Property Score As %Integer [ Required ];

Index ColorIndex On (SubjectDr, Score, ColorRGB) [ Unique ];

Index SubjectIndex On SubjectDr;

/// Creator：     liuyh
/// CreatDate：   2010-11-04
/// Description:  将对象格式化为字符串
/// Table：       DHCMed.CC.SubjectColor
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
/// 1:Rowid 2:ColorRGB 3:SubjectDr 4:Score
Method ToString(separete As %String) As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
		} 
	set return=..%Id()_separete
	set return=return_..ColorRGB_separete
	set return=return_..SubjectDr_separete
	set return=return_..Score
	quit return
}

/// Creator：     liuyh
/// CreatDate：   2010-11-04
/// Description:  根据ID取监控主题颜色信息
/// Table：       DHCMed.CC.SubjectColor
/// Input：       ID:    DHCMed.CC.SubjectColor.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.CC.SubjectColor).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.CC.SubjectColor
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.CC.SubjectColor).%ExistsId(+id) return
	set obj=##Class(DHCMed.CC.SubjectColor).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     liuyh
/// CreatDate：   2010-11-04
/// Description:  根据ID取监控主题颜色信息
/// Table：       DHCMed.CC.SubjectColor
/// Input：       ID:    DHCMed.CC.SubjectColor.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.CC.SubjectColor).GetStringById(1)
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
/// CreatDate：   2010-11-04
/// Description:  更新监控内容字典
/// Table：       DHCMed.CC.SubjectColor
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// 1:Rowid 2:ColorRGB 3:SubjectDr 4:Score
ClassMethod Update(InStr As %String) As %String
{
	new (InStr)
	set id=0
	set ID=$p(InStr,"^",1)	
	if ID="" {
		set obj=##class(DHCMed.CC.SubjectColor).%New()
		} 
	else {
		set obj=##class(DHCMed.CC.SubjectColor).%OpenId(ID)
		}
	set obj.ColorRGB=$p(InStr,"^",2)
	set obj.SubjectDr=$p(InStr,"^",3)
	set obj.Score=$p(InStr,"^",4)
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
/// CreatDate：   2010-11-04
/// Description:  删除监控主题颜色
/// Table：       DHCMed.CC.SubjectColor
/// Input：       ContentDicId
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id As %String) As %String
{
	new (Id)
	set sc = ##class(DHCMed.CC.SubjectColor).%DeleteId(+Id)
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
<Data name="SubjectColorDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ColorRGB</Value>
</Value>
<Value name="3">
<Value>Score</Value>
</Value>
<Value name="4">
<Value>SubjectDr</Value>
</Value>
</Data>
<DataLocation>^DHCMed.CC("SColor")</DataLocation>
<DefaultData>SubjectColorDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.CC("SColor")</IdLocation>
<IndexLocation>^DHCMed.CCi("SColor",0)</IndexLocation>
<StreamLocation>^DHCMed.CC.SubjectColorS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
