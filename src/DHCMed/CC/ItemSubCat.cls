/// 名称: DHCMed.CC.ItemSubCat
/// 描述: 监控项目子类
/// 编写者：liuyh
/// 编写日期: 2010-04-26
Class DHCMed.CC.ItemSubCat Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 代码
Property ISCCode As %String(MAXLEN = 20) [ Required ];

/// 描述
Property ISCDesc As %String(MAXLEN = 100) [ Required ];

/// 大类 DHCMed.CC.ItemCat 
Property ISCCatDr As %Integer [ Required ];

/// 关键字 DHCMed.CC.KeyWord
Property ISCKeywordID As %Integer;

Index ISCCodeIndex On (ISCCatDr, ISCCode) [ Unique ];

/// Creator：     liuyh
/// CreatDate：   2010-04-26
/// Description:  将对象格式化为字符串
/// Table：       DHCMed.CC.ItemSubCat
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
/// 1:Rowid 2:ISCCode 3:ISCDesc 4:ISCCatDr
Method ToString(separete As %String) As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
		} 
	set return=..%Id()_separete
	set return=return_..ISCCode_separete
	set return=return_..ISCDesc_separete
	set return=return_..ISCCatDr_separete
	set return=return_..ISCKeywordID_separete
	quit return
}

/// Creator：     liuyh
/// CreatDate：   2010-04-06
/// Description:  根据ID取监控项目子类信息
/// Table：       DHCMed.CC.ItemSubCat
/// Input：       ID:    DHCMed.CC.ItemSubCat.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.CC.ItemSubCat).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.CC.ItemSubCat
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.CC.ItemSubCat).%ExistsId(+id) return
	set obj=##Class(DHCMed.CC.ItemSubCat).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     liuyh
/// CreatDate：   2010-04-06
/// Description:  根据ID取监控项目子类信息
/// Table：       DHCMed.CC.ItemSubCat
/// Input：       ID:    DHCMed.CC.ItemSubCat.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.CC.ItemSubCat).GetStringById(1)
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
/// Description:  更新监控项目子类
/// Table：       DHCMed.CC.ItemSubCat
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// 1:Rowid 2:ISCCode 3:ISCDesc 4:ISCCatDr
ClassMethod Update(InStr As %String) As %String
{
	new (InStr)
	set $ZT="UpdateErr"
	set id=0
	set ID=$p(InStr,"^",1)	
	if ID="" {
		set obj=##class(DHCMed.CC.ItemSubCat).%New()
		} 
	else {
		set obj=##class(DHCMed.CC.ItemSubCat).%OpenId(ID)
		}
	set obj.ISCCode=$p(InStr,"^",2)
	set obj.ISCDesc=$p(InStr,"^",3)
	set obj.ISCCatDr=$p(InStr,"^",4)
	set obj.ISCKeywordID=$p(InStr,"^",5)
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
/// CreatDate：   2010-04-26
/// Description:  删除监控项目子类
/// Table：       DHCMed.CC.ItemSubCat
/// Input：       ContentDicId
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id As %String) As %String
{
	new (Id)
	set ret=0
	//set $ZT="DeleteByIdErr"
	set sc = ##class(DHCMed.CC.ItemSubCat).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		//d $system.OBJ.DisplayError(sc) 
   		set ret=-1
	}else{
		set ret=0
	}
	quit ret
DeleteByIdErr
	quit -1
}

Storage Default
{
<Data name="ItemSubCatDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ISCCatDr</Value>
</Value>
<Value name="3">
<Value>ISCCode</Value>
</Value>
<Value name="4">
<Value>ISCDesc</Value>
</Value>
<Value name="5">
<Value>ISCKeywordID</Value>
</Value>
</Data>
<DataLocation>^DHCMed.CC("ISubCat")</DataLocation>
<DefaultData>ItemSubCatDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.CC("ISubCat")</IdLocation>
<IndexLocation>^DHCMed.CCi("ISubCat",0)</IndexLocation>
<StreamLocation>^DHCMed.CC.ItemSubCatS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
