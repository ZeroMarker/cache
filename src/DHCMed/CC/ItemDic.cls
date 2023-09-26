/// 名称: DHCMed.CC.ItemDic
/// 描述: 监控项目字典
/// 编写者：liuyh
/// 编写日期: 2010-04-26
Class DHCMed.CC.ItemDic Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 监控项目代码
Property IDCode As %String(MAXLEN = 20) [ Required ];

/// 监控项目描述
Property IDDesc As %String(MAXLEN = 100) [ Required ];

/// 子分类 DHCMed.CC.ItemSubCat
Property IDSubCatDr As %Integer [ Required ];

/// 监控表达式
Property IDExpression As %String(MAXLEN = 500) [ Required ];

/// 监控范围
Property IDRange As %String;

/// 描述
Property IDResume As %String(MAXLEN = 100);

Index IDSubCatDrIndex On IDSubCatDr;

Index IndexSubCatCode On (IDSubCatDr, IDCode) [ Unique ];

/// Creator：     liuyh
/// CreatDate：   2010-04-26
/// Description:  将对象格式化为字符串
/// Table：       DHCMed.CC.ItemDic
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
/// 1:Rowid 2:IDCode 3:IDDesc 4:IDSubCatDr 5:IDExpression 6:IDRange 7:IDResume
Method ToString(separete As %String) As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
		} 
	set return=..%Id()_separete
	set return=return_..IDCode_separete
	set return=return_..IDDesc_separete
	set return=return_..IDSubCatDr_separete
	set return=return_..IDExpression_separete
	set return=return_..IDRange_separete
	set return=return_..IDResume
	quit return
}

/// Creator：     liuyh
/// CreatDate：   2010-04-06
/// Description:  根据ID取监控项目字典信息
/// Table：       DHCMed.CC.ItemDic
/// Input：       ID:    DHCMed.CC.ItemDic.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.CC.ItemDic).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.CC.ItemDic
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.CC.ItemDic).%ExistsId(+id) return
	set obj=##Class(DHCMed.CC.ItemDic).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     liuyh
/// CreatDate：   2010-04-06
/// Description:  根据ID取监控项目字典信息
/// Table：       DHCMed.CC.ItemDic
/// Input：       ID:    DHCMed.CC.ItemDic.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.CC.ItemDic).GetStringById(1)
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
/// Description:  更新监控项目字典
/// Table：       DHCMed.CC.ItemDic
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// 1:Rowid 2:IDCode 3:IDDesc 4:IDSubCatDr 5:IDExpression 6:IDRange 7:IDResume
ClassMethod Update(InStr As %String) As %String
{
	new (InStr)
	set id=0
	set ID=$p(InStr,"^",1)
	if ID="" {
		set obj=##class(DHCMed.CC.ItemDic).%New()
	}else{
		set obj=##class(DHCMed.CC.ItemDic).%OpenId(ID)
	}
	set obj.IDCode=$p(InStr,"^",2)
	set obj.IDDesc=$p(InStr,"^",3)
	set obj.IDSubCatDr=$p(InStr,"^",4)
	set obj.IDExpression=$p(InStr,"^",5)
	set obj.IDRange=+$p(InStr,"^",6)
	set obj.IDResume=$p(InStr,"^",7)
	set sc=obj.%Save()
	if $system.Status.IsError(sc) {                               //检查Save是否成功
   		//d $system.OBJ.DisplayError(sc) 
   		set id=-1
	}else{
		set id=obj.%Id()
	}
	do obj.%Close()
	quit id
}

/// Creator：     liuyh
/// CreatDate：   2010-04-26
/// Description:  删除监控项目
/// Table：       DHCMed.CC.ItemDic
/// Input：       ItemDicId
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id As %String) As %String
{
	new (Id)
	set sc = ##class(DHCMed.CC.ItemDic).%DeleteId(+Id)
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
<Data name="ItemDicDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IDCode</Value>
</Value>
<Value name="3">
<Value>IDDesc</Value>
</Value>
<Value name="4">
<Value>IDExpression</Value>
</Value>
<Value name="5">
<Value>IDRange</Value>
</Value>
<Value name="6">
<Value>IDResume</Value>
</Value>
<Value name="7">
<Value>IDSubCatDr</Value>
</Value>
</Data>
<DataLocation>^DHCMed.CC("ItemDic")</DataLocation>
<DefaultData>ItemDicDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.CC("ItemDic")</IdLocation>
<IndexLocation>^DHCMed.CCi("ItemDic",0)</IndexLocation>
<StreamLocation>^DHCMed.CC.ItemDicS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
