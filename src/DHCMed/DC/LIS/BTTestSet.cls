/// 名称 : DHCMed.DC.LIS.BTTestSet
/// 说明 : 【基础字典】检测组套/检验医嘱
Class DHCMed.DC.LIS.BTTestSet Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 代码
Property Code As %String(MAXLEN = 100, TRUNCATE = 1);

/// 名称
Property CName As %String(MAXLEN = 100, TRUNCATE = 1);

/// 医院代码
Property HospCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 英文名称
Property EName As %String(MAXLEN = 100, TRUNCATE = 1);

/// 描述
Property Description As %String(MAXLEN = 100, TRUNCATE = 1);

/// 标本
Property SpecimenDR As DHCMed.DC.LIS.BTSpecimen;

/// 索引码
Property XCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否有效
Property Active As %Boolean;

Index IndexCode On (HospCode, Code);

Index IndexCName On (HospCode, CName);

Index IndexXCode On (HospCode, XCode);

/// Creator：     zhufei
/// CreatDate：   2016-03-07
/// Description:  根据CodeDesc取检验医嘱字典
/// Table：       DHCMed.DC.LIS.BTTestSet
/// Input：       Code:    DHCMed.DC.LIS.BTTestSet.Code
///               Desc:    DHCMed.DC.LIS.BTTestSet.CName
/// Return：      返回String
/// w ##class(DHCMed.DC.LIS.BTTestSet).GetIDByCodeDesc()
ClassMethod GetIDByCodeDesc(aCode As %String, aDesc As %String, aHospCode As %String) As %String
{
	new (aCode,aDesc,aHospCode)
	set return=""
	quit:((aCode="")&&(aDesc=""))||(aHospCode="") return
	
	if aCode'="" {
		set ID=$o(^DHCMed.DC.LIS.BTTestSetI("IndexCode"," "_$zcvt(aHospCode,"U")," "_$zcvt(aCode,"U"),0))
	} else {
		set ID=$o(^DHCMed.DC.LIS.BTTestSetI("IndexCName"," "_$zcvt(aHospCode,"U")," "_$zcvt(aDesc,"U"),0))
	}
	quit:ID="" return
	
	set obj=..GetObjById(ID)
	quit:'$IsObject(obj) return
	set return=obj.%Id()
	
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2016-03-07
/// Description:  根据ID取检验医嘱字典
/// Table：       DHCMed.DC.LIS.BTTestSet
/// Input：       ID:    DHCMed.DC.LIS.BTTestSet.ID
///               separete: 指定的分隔符
/// Return：      返回Object
/// w ##class(DHCMed.DC.LIS.BTTestSet).GetObjByXCode("876","LIS02")
ClassMethod GetObjByXCode(aXCode As %String, aHospCode As %String = "LIS02") As DHCMed.DC.LIS.BTTestSet
{
	new (aXCode,aHospCode)
	set return=""
	quit:(aXCode="")||(aHospCode="") return
	
	set ID=$o(^DHCMed.DC.LIS.BTTestSetI("IndexXCode"," "_$zcvt(aHospCode,"U")," "_$zcvt(aXCode,"U"),""),-1)
	Quit:ID="" return
	Set obj=..GetObjById(ID)
	set return=obj
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2016-03-07
/// Description:  根据ID取检验医嘱字典
/// Table：       DHCMed.DC.LIS.BTTestSet
/// Input：       ID:    DHCMed.DC.LIS.BTTestSet.ID
///               separete: 指定的分隔符
/// Return：      返回Object
/// w ##class(DHCMed.DC.LIS.BTTestSet).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.DC.LIS.BTTestSet
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.DC.LIS.BTTestSet).%ExistsId(+id) return
	set obj=##Class(DHCMed.DC.LIS.BTTestSet).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2016-03-07
/// Description:  更新检验医嘱字典
/// Table：       DHCMed.DC.LIS.BTTestSet
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMed.DC.LIS.BTTestSet).Update()
ClassMethod Update(InStr As %String, separete As %String = "^") As %String
{
	new (InStr,separete)
	set return=0
	quit:InStr="" return
	
	set Code         = $p(InStr,separete,1)
	set CName        = $p(InStr,separete,2)
	set HospCode     = $p(InStr,separete,3)
	set EName        = $p(InStr,separete,4)
	set Description  = $p(InStr,separete,5)
	set SpecimenDR   = $p(InStr,separete,6)
	set XCode        = $p(InStr,separete,7)
	set Active       = +$p(InStr,separete,8)
	quit:(Code="")||(CName="") return
	
	set objSpecimen=##Class(DHCMed.DC.LIS.BTSpecimen).GetObjById(SpecimenDR)
	
	//字典代码唯一性
	if XCode'="" {
		set ID=$o(^DHCMed.DC.LIS.BTTestSetI("IndexXCode"," "_$zcvt(HospCode,"U")," "_$zcvt(XCode,"U"),0))
	} else {
		set ID=$o(^DHCMed.DC.LIS.BTTestSetI("IndexCode"," "_$zcvt(HospCode,"U")," "_$zcvt(Code,"U"),0))
	}
	
	if ID="" {
		set obj=##class(DHCMed.DC.LIS.BTTestSet).%New()
	}else{
		set obj=##class(DHCMed.DC.LIS.BTTestSet).%OpenId(ID)
	}
	quit:'$IsObject(obj) return
	
	set obj.Code         = Code
	set obj.CName        = CName
	set obj.HospCode     = HospCode
	set obj.EName        = EName
	set obj.Description  = Description
	set obj.SpecimenDR   = objSpecimen
	set obj.XCode        = XCode
	set obj.Active       = Active
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
/// Description:  删除检验医嘱字典
/// Table：       DHCMed.DC.LIS.BTTestSet
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	new (Id)
	set sc = ##class(DHCMed.DC.LIS.BTTestSet).%DeleteId(+Id)
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
<Data name="BTTestSetDefaultData">
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
<Value>Description</Value>
</Value>
<Value name="7">
<Value>SpecimenDR</Value>
</Value>
<Value name="8">
<Value>XCode</Value>
</Value>
<Value name="9">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^DHCMed.DC.LIS.BTTestSetD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.DC.LIS.BTTestSetD</IdLocation>
<IndexLocation>^DHCMed.DC.LIS.BTTestSetI</IndexLocation>
<StreamLocation>^DHCMed.DC.LIS.BTTestSetS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
