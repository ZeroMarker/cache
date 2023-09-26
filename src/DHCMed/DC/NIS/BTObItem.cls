/// 名称 : DHCMed.DC.NIS.BTObItem
/// 说明 : 【基础字典】护理项目
Class DHCMed.DC.NIS.BTObItem Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 代码
Property Code As %String(MAXLEN = 100, TRUNCATE = 1);

/// 名称
Property CName As %String(MAXLEN = 100, TRUNCATE = 1);

/// 医院代码
Property HospCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 索引码
Property XCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否有效
Property Active As %Boolean;

Index IndexCode On (HospCode, Code);

Index IndexCName On (HospCode, CName);

Index IndexXCode On (HospCode, XCode);

/// Creator：     zhufei
/// CreatDate：   2016-04-14
/// Description:  根据CodeDesc取护理项目字典
/// Table：       DHCMed.DC.NIS.BTObItem
/// Input：       Code:    DHCMed.DC.NIS.BTObItem.Code
///               Desc:    DHCMed.DC.NIS.BTObItem.CName
/// Return：      返回String
/// w ##class(DHCMed.DC.NIS.BTObItem).GetIDByCodeDesc()
ClassMethod GetIDByCodeDesc(aCode As %String, aDesc As %String, aHospCode As %String) As %String
{
	new (aCode,aDesc,aHospCode)
	set return=""
	quit:((aCode="")&&(aDesc=""))||(aHospCode="") return
	
	if aCode'="" {
		set ID=$o(^DHCMed.DC.NIS.BTObItemI("IndexCode"," "_$zcvt(aHospCode,"U")," "_$zcvt(aCode,"U"),0))
	} else {
		set ID=$o(^DHCMed.DC.NIS.BTObItemI("IndexCName"," "_$zcvt(aHospCode,"U")," "_$zcvt(aDesc,"U"),0))
	}
	quit:ID="" return
	
	set obj=..GetObjById(ID)
	quit:'$IsObject(obj) return
	set return=obj.%Id()
	
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2016-04-14
/// Description:  根据Code取护理项目字典
/// Table：       DHCMed.DC.NIS.BTObItem
/// Input：       Code:    DHCMed.DC.NIS.BTObItem.Code
/// Return：      返回String
/// w ##class(DHCMed.DC.NIS.BTObItem).GetObjByCode()
ClassMethod GetObjByCode(aCode As %String, aHospCode As %String) As DHCMed.DC.NIS.BTObItem
{
	new (aCode,aHospCode)
	set return=""
	quit:(aCode="")||(aHospCode="") return
	
	set ID=$o(^DHCMed.DC.NIS.BTObItemI("IndexCode"," "_$zcvt(aHospCode,"U")," "_$zcvt(aCode,"U"),0))
	quit:ID="" return
	
	set obj=..GetObjById(ID)
	quit:'$IsObject(obj) return
	set return=obj
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2016-04-14
/// Description:  根据ID取护理项目字典
/// Table：       DHCMed.DC.NIS.BTObItem
/// Input：       ID:    DHCMed.DC.NIS.BTObItem.ID
///               separete: 指定的分隔符
/// Return：      返回Object
/// w ##class(DHCMed.DC.NIS.BTObItem).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.DC.NIS.BTObItem
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.DC.NIS.BTObItem).%ExistsId(+id) return
	set obj=##Class(DHCMed.DC.NIS.BTObItem).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2016-04-14
/// Description:  更新护理项目字典
/// Table：       DHCMed.DC.NIS.BTObItem
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMed.DC.NIS.BTObItem).Update()
ClassMethod Update(InStr As %String, separete As %String = "^") As %String
{
	new (InStr,separete)
	set return=0
	quit:InStr="" return
	
	set Code     = $p(InStr,separete,1)
	set CName    = $p(InStr,separete,2)
	set HospCode = $p(InStr,separete,3)
	set XCode    = $p(InStr,separete,4)
	set Active   = +$p(InStr,separete,5)
	quit:(Code="")||(CName="") return
	
	//字典代码唯一性
	if XCode'="" {
		set ID=$o(^DHCMed.DC.NIS.BTObItemI("IndexXCode"," "_$zcvt(HospCode,"U")," "_$zcvt(XCode,"U"),0))
	} else {
		set ID=$o(^DHCMed.DC.NIS.BTObItemI("IndexCode"," "_$zcvt(HospCode,"U")," "_$zcvt(Code,"U"),0))
	}
	
	if ID="" {
		set obj=##class(DHCMed.DC.NIS.BTObItem).%New()
	}else{
		set obj=##class(DHCMed.DC.NIS.BTObItem).%OpenId(ID)
	}
	quit:'$IsObject(obj) return
	
	set obj.Code     = Code
	set obj.CName    = CName
	set obj.HospCode = HospCode
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
/// CreatDate：   2016-04-14
/// Description:  删除护理项目字典
/// Table：       DHCMed.DC.NIS.BTObItem
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	new (Id)
	set sc = ##class(DHCMed.DC.NIS.BTObItem).%DeleteId(+Id)
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
<Value>HospCode</Value>
</Value>
<Value name="5">
<Value>XCode</Value>
</Value>
<Value name="6">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^DHCMed.DC.NIS.BTObItemD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.DC.NIS.BTObItemD</IdLocation>
<IndexLocation>^DHCMed.DC.NIS.BTObItemI</IndexLocation>
<StreamLocation>^DHCMed.DC.NIS.BTObItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
