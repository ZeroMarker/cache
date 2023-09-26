/// 名称: DHCMed.CC.ItemCat
/// 描述: 监控项目大类
/// 编写者：liuyh
/// 编写日期: 2010-04-26
Class DHCMed.CC.ItemCat Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 代码
Property ICCode As %String(MAXLEN = 20) [ Required ];

/// 描述
Property ICDesc As %String(MAXLEN = 100) [ Required ];

/// 主题ID DHCMed.CC.Subject
Property SubjectDr As %Integer [ Required ];

Index SubjectIndex On SubjectDr;

Index ICCodeIndex On (SubjectDr, ICCode) [ Unique ];

/// Add By LiYang 2011-09-13 为每个大类指定所属的科室、病房
/// 科室ID   DHCMed.Base.Ctloc
Property LocDr As %Integer;

/// 病房ID   DHCMed.Base.PacWard
Property WardDr As %Integer;

/// Creator：     liuyh
/// CreatDate：   2010-04-26
/// Description:  将对象格式化为字符串
/// Table：       DHCMed.CC.ItemCat
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
/// 1:Rowid 2:ICCode 3:ICDesc 4:SubjectDr
Method ToString(separete As %String) As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
		} 
	set return=..%Id()_separete
	set return=return_..ICCode_separete
	set return=return_..ICDesc_separete
	set return=return_..SubjectDr_separete
	///Add By LiYang 2011-09-13 为每个大类指定所属的科室、病房
	Set return=return_..LocDr_separete
	Set return=return_..WardDr_separete
	quit return
}

/// Creator：     liuyh
/// CreatDate：   2010-04-06
/// Description:  根据ID取监控项目大类对象
/// Table：       DHCMed.CC.ItemCat
/// Input：       ID:    DHCMed.CC.ItemCat.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.CC.ItemCat).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.CC.ItemCat
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.CC.ItemCat).%ExistsId(+id) return
	set obj=##Class(DHCMed.CC.ItemCat).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     liuyh
/// CreatDate：   2010-04-06
/// Description:  根据ID取监控项目大类信息
/// Table：       DHCMed.CC.ItemCat
/// Input：       id: DHCMed.CC.ItemCat.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.CC.ItemCat).GetStringById(1)
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
/// CreatDate：   2010-04-26
/// Description:  更新监控项目大类
/// Table：       DHCMed.CC.ItemCat
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// 1:Rowid 2:ICCode 3:ICDesc 4:SubjectDr
/// w ##Class(DHCMed.CC.ItemCat).Update("18^001^002^1")
ClassMethod Update(InStr As %String) As %String
{
	New (InStr)
	Set return=-1
	
	Set $ZT="UpdateErr"
	Set ID=$p(InStr,"^",1)
	If ID="" {
		Set obj=##class(DHCMed.CC.ItemCat).%New()
	}Else{
		Set obj=##class(DHCMed.CC.ItemCat).%OpenId(ID)
		Quit:'$IsObject(obj) return
	}
	Set obj.ICCode=$p(InStr,"^",2)
	Set obj.ICDesc=$p(InStr,"^",3)
	Set obj.SubjectDr=$p(InStr,"^",4)
	//Add By LiYang 2011-09-13 为每个大类指定所属的科室、病房
	Set obj.LocDr=$p(InStr,"^",5)
	Set obj.WardDr=$p(InStr,"^",6)
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {            //检查Save是否成功
		//Do $System.Status.DisplayError(sc)
   		Set return=-1
	}Else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	Quit return
	
UpdateErr
	Quit -1
}

/// Creator：     liuyh
/// CreatDate：   2010-04-26
/// Description:  删除监控项目大类
/// Table：       DHCMed.CC.ItemCat
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id As %String) As %String
{
	new (Id)
	set sc = ##class(DHCMed.CC.ItemCat).%DeleteId(+Id)
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
<Data name="ItemCatDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ICCode</Value>
</Value>
<Value name="3">
<Value>ICDesc</Value>
</Value>
<Value name="4">
<Value>SubjectDr</Value>
</Value>
<Value name="5">
<Value>LocDr</Value>
</Value>
<Value name="6">
<Value>WardDr</Value>
</Value>
</Data>
<DataLocation>^DHCMed.CC("ItemCat")</DataLocation>
<DefaultData>ItemCatDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.CC("ItemCat")</IdLocation>
<IndexLocation>^DHCMed.CCi("ItemCat",0)</IndexLocation>
<StreamLocation>^DHCMed.CC.ItemCatS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
