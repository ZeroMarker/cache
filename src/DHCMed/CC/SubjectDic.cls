/// 名称: DHCMed.CC.SubjectDic
/// 描述: 监控主题字典维护
/// 编写者：wuwj
/// 编写日期: 2010-04-19
Class DHCMed.CC.SubjectDic Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 代码
Property SDCode As %String [ Required ];

Index IndexSDCode On SDCode [ Unique ];

/// 描述
Property SDDesc As %String [ Required ];

/// 入参
Property SDInPut As %String [ Required ];

/// 出参  EpisodeID\OeordItem\...
Property SDOutPut As %String [ Required ];

/// Method名称
Property SDMethodName As %String [ Required ];

/// 备注
Property SDResume As %String;

/// Creator：     wuwj
/// CreatDate：   2010-04-19
/// Description:  将对象格式化为字符串
/// Table：       DHCMed.CC.SubjectDic
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
/// 1:Rowid 2:SDCode 3:SDDesc 4:SDInPut 5:SDOutPut 6:SDResume
Method ToString(separete As %String) As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
		} 
	set return=..%Id()_separete
	set return=return_..SDCode_separete
	set return=return_..SDDesc_separete
	set return=return_..SDInPut_separete
	set return=return_..SDOutPut_separete
	set return=return_..SDMethodName_separete
	set return=return_..SDResume
	quit return
}

/// Creator：     wuwj
/// CreatDate：   2010-04-19
/// Description:  根据ID取配置信息
/// Table：       DHCMed.CC.SubjectDic
/// Input：       ID:    DHCMed.CC.SubjectDic.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.CC.SubjectDic).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.CC.SubjectDic
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.CC.SubjectDic).%ExistsId(+id) return
	set obj=##Class(DHCMed.CC.SubjectDic).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     wuwj
/// CreatDate：   2010-04-19
/// Description:  根据ID取配置信息
/// Table：       DHCMed.CC.SubjectDic
/// Input：       ID:    DHCMed.CC.SubjectDic.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.CC.SubjectDic).GetStringById(1)
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

/// Creator：     wuwj
/// CreatDate：   2010-04-19
/// Description:  更新Menu
/// Table：       DHCMed.CC.SubjectDic
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// 1:Rowid 2:SDCode 3:SDDesc 4:SDInPut 5:SDOutPut 6:SDResume
/// w ##class(DHCMed.CC.SubjectDic).Update("^2^住院病人^病人2^入院2^大夫",)
ClassMethod Update(InStr As %String, separete As %String) As %String
{
	 
	new (InStr,separete)
	if $g(separete)=""{
		set separete=..#SEPARATE
		}
	set id=0
	set ID=$p(InStr,separete,1)
	if ID="" {
		set obj=##class(DHCMed.CC.SubjectDic).%New()
		} 
	else {
		set obj=##class(DHCMed.CC.SubjectDic).%OpenId(ID)
		}
	set obj.SDCode=$p(InStr,separete,2)
	set obj.SDDesc=$p(InStr,separete,3)
	set obj.SDInPut=$p(InStr,separete,4)
	set obj.SDOutPut=$p(InStr,separete,5)
	set obj.SDMethodName=$p(InStr,separete,6)
	set obj.SDResume=$p(InStr,separete,7)
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

/// Creator：     wuwj
/// CreatDate：   2010-04-19
/// Description:  删除配置
/// Table：       DHCMed.CC.SubjectDic
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	new (Id)
	set sc = ##class(DHCMed.CC.SubjectDic).%DeleteId(+Id)
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
<Data name="SubjectDicDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SDCode</Value>
</Value>
<Value name="3">
<Value>SDDesc</Value>
</Value>
<Value name="4">
<Value>SDInPut</Value>
</Value>
<Value name="5">
<Value>SDOutPut</Value>
</Value>
<Value name="6">
<Value>SDMethodName</Value>
</Value>
<Value name="7">
<Value>SDResume</Value>
</Value>
</Data>
<DataLocation>^DHCMed.CC.SubjectDicD</DataLocation>
<DefaultData>SubjectDicDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.CC.SubjectDicD</IdLocation>
<IndexLocation>^DHCMed.CC.SubjectDicI</IndexLocation>
<StreamLocation>^DHCMed.CC.SubjectDicS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
