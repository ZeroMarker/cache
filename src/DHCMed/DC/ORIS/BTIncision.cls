/// 名称 : DHCMed.DC.ORIS.BTIncision
/// 说明 : 【基础字典】切口等级
Class DHCMed.DC.ORIS.BTIncision Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 代码
Property Code As %String(MAXLEN = 100, TRUNCATE = 1);

/// 名称
Property CName As %String(MAXLEN = 100, TRUNCATE = 1);

/// 索引码
Property XCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否有效
Property Active As %Boolean;

Index IndexCode On Code;

Index IndexCName On CName;

Index IndexXCode On XCode;

/// Creator：     zhufei
/// CreatDate：   2016-04-19
/// Description:  根据CodeDesc取切口等级字典
/// Table：       DHCMed.DC.ORIS.BTIncision
/// Input：       Code:    DHCMed.DC.ORIS.BTIncision.Code
///               Desc:    DHCMed.DC.ORIS.BTIncision.CName
/// Return：      返回String
/// w ##class(DHCMed.DC.ORIS.BTIncision).GetIDByCodeDesc()
ClassMethod GetIDByCodeDesc(aCode As %String, aDesc As %String) As %String
{
	new (aCode,aDesc)
	set return=""
	quit:(aCode="")&&(aDesc="") return
	
	if aCode'="" {
		set ID=$o(^DHCMed.DC.ORIS.BTIncisionI("IndexCode"," "_$zcvt(aCode,"U"),0))
	} else {
		set ID=$o(^DHCMed.DC.ORIS.BTIncisionI("IndexCName"," "_$zcvt(aDesc,"U"),0))
	}
	quit:ID="" return
	
	set obj=..GetObjById(ID)
	quit:'$IsObject(obj) return
	set return=obj.%Id()
	
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2016-04-19
/// Description:  根据Code取切口等级字典
/// Table：       DHCMed.DC.ORIS.BTIncision
/// Input：       Code:    DHCMed.DC.ORIS.BTIncision.Code
/// Return：      返回String
/// w ##class(DHCMed.DC.ORIS.BTIncision).GetObjByCode()
ClassMethod GetObjByCode(aCode As %String) As DHCMed.DC.ORIS.BTIncision
{
	new (aCode)
	set return=""
	quit:(aCode="") return
	
	set ID=$o(^DHCMed.DC.ORIS.BTIncisionI("IndexCode"," "_$zcvt(aCode,"U"),0))
	quit:ID="" return
	
	set obj=..GetObjById(ID)
	quit:'$IsObject(obj) return
	set return=obj
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2016-04-19
/// Description:  根据ID取切口等级字典
/// Table：       DHCMed.DC.ORIS.BTIncision
/// Input：       ID:    DHCMed.DC.ORIS.BTIncision.ID
///               separete: 指定的分隔符
/// Return：      返回Object
/// w ##class(DHCMed.DC.ORIS.BTIncision).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.DC.ORIS.BTIncision
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.DC.ORIS.BTIncision).%ExistsId(+id) return
	set obj=##Class(DHCMed.DC.ORIS.BTIncision).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2016-04-19
/// Description:  更新切口等级字典
/// Table：       DHCMed.DC.ORIS.BTIncision
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMed.DC.ORIS.BTIncision).Update()
ClassMethod Update(InStr As %String, separete As %String = "^") As %String
{
	new (InStr,separete)
	set return=0
	quit:InStr="" return
	
	set Code     = $p(InStr,separete,1)
	set CName    = $p(InStr,separete,2)
	set XCode    = $p(InStr,separete,3)
	set Active   = +$p(InStr,separete,4)
	quit:(Code="")||(CName="") return
	
	//字典代码唯一性
	if XCode'="" {
		set ID=$o(^DHCMed.DC.ORIS.BTIncisionI("IndexXCode"," "_$zcvt(XCode,"U"),0))
	} else {
		set ID=$o(^DHCMed.DC.ORIS.BTIncisionI("IndexCode"," "_$zcvt(Code,"U"),0))
	}
	
	if ID="" {
		set obj=##class(DHCMed.DC.ORIS.BTIncision).%New()
	}else{
		set obj=##class(DHCMed.DC.ORIS.BTIncision).%OpenId(ID)
	}
	quit:'$IsObject(obj) return
	
	set obj.Code     = Code
	set obj.CName    = CName
	set obj.XCode    = XCode
	set obj.Active   = Active
	set sc=obj.%Save()
	if $system.Status.IsError(sc) {        //检查Save是否成功
   		do $system.OBJ.DisplayError(sc) 
   		set return=-1
	}else{
		set return=obj.%Id()
	}
	do obj.%Close()
	
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2016-04-19
/// Description:  删除切口等级字典
/// Table：       DHCMed.DC.ORIS.BTIncision
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	new (Id)
	set sc = ##class(DHCMed.DC.ORIS.BTIncision).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc)
   		set ret=-1
	}else{
		set ret=0
	}
	quit ret
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>CName</Value>
</Value>
<Value name="4">
<Value>XCode</Value>
</Value>
<Value name="5">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^DHCMed.DC.ORIS.BTIncisionD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.DC.ORIS.BTIncisionD</IdLocation>
<IndexLocation>^DHCMed.DC.ORIS.BTIncisionI</IndexLocation>
<StreamLocation>^DHCMed.DC.ORIS.BTIncisionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
