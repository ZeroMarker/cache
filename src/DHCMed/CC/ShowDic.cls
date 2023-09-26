/// 名称: DHCMed.CC.ShowDic
/// 描述: 监控主题展现字典维护
/// 编写者：zhufei
/// 编写日期: 2010-05-07
Class DHCMed.CC.ShowDic Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 代码
Property SDCode As %String [ Required ];

Index SDCodeIndex On SDCode [ Unique ];

/// 描述
Property SDDesc As %String [ Required ];

/// 监控主题字典
Property SDInPut As %String;

/// 显示分值
Property SDQueryName As %String;

/// 备注
Property SDResume As %String;

/// Creator：     zhufei
/// CreatDate：   2010-05-07
/// Description:  将对象格式化为字符串
/// Table：       DHCMed.CC.ShowDic
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
/// 1:Rowid 2:SDCode 3:SDDesc 4:SDInPut 5:SDQueryName 6:SDResume
Method ToString(separete As %String) As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
	} 
	set return=..%Id()_separete
	set return=return_..SDCode_separete
	set return=return_..SDDesc_separete
	set return=return_..SDInPut_separete
	set return=return_..SDQueryName_separete
	set return=return_..SDResume
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2010-05-07
/// Description:  根据ID取监控主题展现字典信息
/// Table：       DHCMed.CC.ShowDic
/// Input：       ID:    DHCMed.CC.ShowDic.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.CC.ShowDic).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.CC.ShowDic
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.CC.ShowDic).%ExistsId(+id) return
	set obj=##Class(DHCMed.CC.ShowDic).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2010-05-07
/// Description:  根据ID取监控主题展现字典信息
/// Table：       DHCMed.CC.ShowDic
/// Input：       ID:    DHCMed.CC.ShowDic.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.CC.ShowDic).GetStringById(1)
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
/// Description:  更新ShowDic
/// Table：       DHCMed.CC.ShowDic
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// 1:Rowid 2:SDCode 3:SDDesc 4:SDInPut 5:SDQueryName 6:SDResume
/// w ##class(DHCMed.CC.ShowDic).Update("^SDCode^SDDesc^SDInPut^SDQueryName^SDResume")
ClassMethod Update(InStr As %String) As %String
{
	new (InStr)
	set id=0
	set ID=$p(InStr,"^",1)
	if ID="" {
		set obj=##class(DHCMed.CC.ShowDic).%New()
	} else {
		set obj=##class(DHCMed.CC.ShowDic).%OpenId(ID)
	}
	set obj.SDCode=$p(InStr,"^",2)
	set obj.SDDesc=$p(InStr,"^",3)
	set obj.SDInPut=$p(InStr,"^",4)
	set obj.SDQueryName=$p(InStr,"^",5)
	set obj.SDResume=$p(InStr,"^",6)
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
/// Description:  删除ShowDic
/// Table：       DHCMed.CC.ShowDic
/// Input：       ShowDicId
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMed.CC.ShowDic).DeleteById(1)
ClassMethod DeleteById(Id As %String) As %Boolean
{
	new (Id)
	set sc = ##class(DHCMed.CC.ShowDic).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set ret=-1
	} else {
		set ret=0
	}
	quit ret
}

/// d ##Class(%ResultSet).RunQuery("DHCMed.CC.ShowDic","QueryAll")
Query QueryAll() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,SDCode:%String,SDDesc:%String,SDInPut:%String,SDQueryName:%String,SDResume:%String")
{
	SELECT %ID,SDCode,SDDesc,SDInPut,SDQueryName,SDResume FROM DHCMed_CC.ShowDic Order by %ID desc
}

Storage Default
{
<Data name="ShowDicDefaultData">
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
<Value>SDQueryName</Value>
</Value>
<Value name="6">
<Value>SDResume</Value>
</Value>
</Data>
<DataLocation>^DHCMed.CC.ShowDicD</DataLocation>
<DefaultData>ShowDicDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.CC.ShowDicD</IdLocation>
<IndexLocation>^DHCMed.CC.ShowDicI</IndexLocation>
<StreamLocation>^DHCMed.CC.ShowDicS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
