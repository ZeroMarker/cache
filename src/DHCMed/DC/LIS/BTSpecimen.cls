/// 名称 : DHCMed.DC.LIS.BTSpecimen
/// 说明 : 【基础字典】标本
Class DHCMed.DC.LIS.BTSpecimen Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 代码
Property Code As %String(MAXLEN = 100, TRUNCATE = 1);

/// 名称
Property CName As %String(MAXLEN = 100, TRUNCATE = 1);

/// 医院代码
Property HospCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 英文名称
Property EName As %String(MAXLEN = 100, TRUNCATE = 1);

/// Whonet码
Property WCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 索引码
Property XCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否有效
Property Active As %Boolean;

Index IndexCode On (HospCode, Code);

Index IndexCName On (HospCode, CName);

Index IndexXCode On (HospCode, XCode);

/// Creator：     zhufei
/// CreatDate：   2016-03-07
/// Description:  根据CodeDesc取标本字典
/// Table：       DHCMed.DC.LIS.BTSpecimen
/// Input：       Code:    DHCMed.DC.LIS.BTSpecimen.Code
///               Desc:    DHCMed.DC.LIS.BTSpecimen.CName
/// Return：      返回String
/// w ##class(DHCMed.DC.LIS.BTSpecimen).GetIDByCodeDesc()
ClassMethod GetIDByCodeDesc(aCode As %String, aDesc As %String, aHospCode As %String) As %String
{
	new (aCode,aDesc,aHospCode)
	set return=""
	quit:((aCode="")&&(aDesc=""))||(aHospCode="") return
	
	if aCode'="" {
		set ID=$o(^DHCMed.DC.LIS.BTSpecimenI("IndexCode"," "_$zcvt(aHospCode,"U")," "_$zcvt(aCode,"U"),0))
	} else {
		set ID=$o(^DHCMed.DC.LIS.BTSpecimenI("IndexCName"," "_$zcvt(aHospCode,"U")," "_$zcvt(aDesc,"U"),0))
	}
	quit:ID="" return
	
	set obj=..GetObjById(ID)
	quit:'$IsObject(obj) return
	set return=obj.%Id()
	
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2016-03-07
/// Description:  根据Code取标本字典
/// Table：       DHCMed.DC.LIS.BTSpecimen
/// Input：       Code:    DHCMed.DC.LIS.BTSpecimen.Code
/// Return：      返回String
/// w ##class(DHCMed.DC.LIS.BTSpecimen).GetObjByCode()
ClassMethod GetObjByCode(aCode As %String, aHospCode As %String) As DHCMed.DC.LIS.BTSpecimen
{
	new (aCode,aHospCode)
	set return=""
	quit:(aCode="")||(aHospCode="") return
	
	set ID=$o(^DHCMed.DC.LIS.BTSpecimenI("IndexCode"," "_$zcvt(aHospCode,"U")," "_$zcvt(aCode,"U"),0))
	quit:ID="" return
	
	set obj=..GetObjById(ID)
	quit:'$IsObject(obj) return
	set return=obj
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2016-03-07
/// Description:  根据ID取标本字典
/// Table：       DHCMed.DC.LIS.BTSpecimen
/// Input：       ID:    DHCMed.DC.LIS.BTSpecimen.ID
///               separete: 指定的分隔符
/// Return：      返回Object
/// w ##class(DHCMed.DC.LIS.BTSpecimen).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.DC.LIS.BTSpecimen
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.DC.LIS.BTSpecimen).%ExistsId(+id) return
	set obj=##Class(DHCMed.DC.LIS.BTSpecimen).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2016-03-07
/// Description:  更新标本字典
/// Table：       DHCMed.DC.LIS.BTSpecimen
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMed.DC.LIS.BTSpecimen).Update()
ClassMethod Update(InStr As %String, separete As %String = "^") As %String
{
	new (InStr,separete)
	set return=0
	quit:InStr="" return
	
	set Code     = $p(InStr,separete,1)
	set CName    = $p(InStr,separete,2)
	set HospCode = $p(InStr,separete,3)
	set EName    = $p(InStr,separete,4)
	set WCode    = $p(InStr,separete,5)
	set XCode    = $p(InStr,separete,6)
	set Active   = +$p(InStr,separete,7)
	quit:(Code="")||(CName="") return
	
	//字典代码唯一性
	if XCode'="" {
		set ID=$o(^DHCMed.DC.LIS.BTSpecimenI("IndexXCode"," "_$zcvt(HospCode,"U")," "_$zcvt(XCode,"U"),0))
	} else {
		set ID=$o(^DHCMed.DC.LIS.BTSpecimenI("IndexCode"," "_$zcvt(HospCode,"U")," "_$zcvt(Code,"U"),0))
	}
	
	if ID="" {
		set obj=##class(DHCMed.DC.LIS.BTSpecimen).%New()
	}else{
		set obj=##class(DHCMed.DC.LIS.BTSpecimen).%OpenId(ID)
	}
	quit:'$IsObject(obj) return
	
	set obj.Code     = Code
	set obj.CName    = CName
	set obj.HospCode = HospCode
	set obj.EName    = EName
	set obj.WCode    = WCode
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
/// CreatDate：   2016-03-07
/// Description:  删除标本字典
/// Table：       DHCMed.DC.LIS.BTSpecimen
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	new (Id)
	set sc = ##class(DHCMed.DC.LIS.BTSpecimen).%DeleteId(+Id)
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
<Value>EName</Value>
</Value>
<Value name="6">
<Value>WCode</Value>
</Value>
<Value name="7">
<Value>XCode</Value>
</Value>
<Value name="8">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^DHCMed.DC.LIS.BTSpecimenD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.DC.LIS.BTSpecimenD</IdLocation>
<IndexLocation>^DHCMed.DC.LIS.BTSpecimenI</IndexLocation>
<StreamLocation>^DHCMed.DC.LIS.BTSpecimenS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
