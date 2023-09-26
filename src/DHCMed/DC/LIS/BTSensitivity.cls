/// 名称 : DHCMed.DC.LIS.BTSensitivity
/// 说明 : 【基础字典】药敏结果（敏感、耐药、中介、SDD）
Class DHCMed.DC.LIS.BTSensitivity Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 代码
Property Code As %String(MAXLEN = 100, TRUNCATE = 1);

/// 名称
Property CName As %String(MAXLEN = 100, TRUNCATE = 1);

/// 结果类型
Property ResultType As %String(MAXLEN = 100, TRUNCATE = 1);

/// 索引码
Property XCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否有效
Property Active As %Boolean;

Index IndexCode On Code;

Index IndexCName On CName;

Index IndexXCode On XCode;

/// Creator：     zhufei
/// CreatDate：   2016-03-07
/// Description:  根据CodeDesc取药敏结果字典
/// Table：       DHCMed.DC.LIS.BTSensitivity
/// Input：       Code:    DHCMed.DC.LIS.BTSensitivity.Code
///               Desc:    DHCMed.DC.LIS.BTSensitivity.CName
/// Return：      返回String
/// w ##class(DHCMed.DC.LIS.BTSensitivity).GetIDByCodeDesc()
ClassMethod GetIDByCodeDesc(aCode As %String, aDesc As %String) As %String
{
	new (aCode,aDesc)
	set return=""
	quit:(aCode="")&&(aDesc="") return
	
	if aCode'="" {
		set ID=$o(^DHCMed.DC.LIS.BTSensitivityI("IndexCode"," "_$zcvt(aCode,"U"),0))
	} else {
		set ID=$o(^DHCMed.DC.LIS.BTSensitivityI("IndexCName"," "_$zcvt(aDesc,"U"),0))
	}
	quit:ID="" return
	
	set obj=..GetObjById(ID)
	quit:'$IsObject(obj) return
	set return=obj.%Id()
	
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2016-03-07
/// Description:  根据Code取药敏结果字典
/// Table：       DHCMed.DC.LIS.BTSensitivity
/// Input：       Code:    DHCMed.DC.LIS.BTSensitivity.Code
/// Return：      返回String
/// w ##class(DHCMed.DC.LIS.BTSensitivity).GetObjByCode()
ClassMethod GetObjByCode(aCode As %String) As DHCMed.DC.LIS.BTSensitivity
{
	new (aCode)
	set return=""
	quit:(aCode="") return
	
	set ID=$o(^DHCMed.DC.LIS.BTSensitivityI("IndexCode"," "_$zcvt(aCode,"U"),0))
	quit:ID="" return
	
	set obj=..GetObjById(ID)
	quit:'$IsObject(obj) return
	set return=obj
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2016-03-07
/// Description:  根据ID取药敏结果字典
/// Table：       DHCMed.DC.LIS.BTSensitivity
/// Input：       ID:    DHCMed.DC.LIS.BTSensitivity.ID
///               separete: 指定的分隔符
/// Return：      返回Object
/// w ##class(DHCMed.DC.LIS.BTSensitivity).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.DC.LIS.BTSensitivity
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.DC.LIS.BTSensitivity).%ExistsId(+id) return
	set obj=##Class(DHCMed.DC.LIS.BTSensitivity).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2016-03-07
/// Description:  更新药敏结果字典
/// Table：       DHCMed.DC.LIS.BTSensitivity
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMed.DC.LIS.BTSensitivity).Update()
ClassMethod Update(InStr As %String, separete As %String = "^") As %String
{
	new (InStr,separete)
	set return=0
	quit:InStr="" return
	
	set Code       = $p(InStr,separete,1)
	set CName      = $p(InStr,separete,2)
	set ResultType = $p(InStr,separete,3)
	set XCode      = $p(InStr,separete,4)
	set Active     = +$p(InStr,separete,5)
	quit:(Code="")||(CName="") return
	
	//字典代码唯一性
	if XCode'="" {
		set ID=$o(^DHCMed.DC.LIS.BTSensitivityI("IndexXCode"," "_$zcvt(XCode,"U"),0))
	} else {
		set ID=$o(^DHCMed.DC.LIS.BTSensitivityI("IndexCode"," "_$zcvt(Code,"U"),0))
	}
	
	if ID="" {
		set obj=##class(DHCMed.DC.LIS.BTSensitivity).%New()
	}else{
		set obj=##class(DHCMed.DC.LIS.BTSensitivity).%OpenId(ID)
	}
	quit:'$IsObject(obj) return
	
	set obj.Code       = Code
	set obj.CName      = CName
	set obj.ResultType = ResultType
	set obj.XCode      = XCode
	set obj.Active     = Active
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
/// Description:  删除药敏结果字典
/// Table：       DHCMed.DC.LIS.BTSensitivity
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	new (Id)
	set sc = ##class(DHCMed.DC.LIS.BTSensitivity).%DeleteId(+Id)
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
<Value>ResultType</Value>
</Value>
<Value name="5">
<Value>XCode</Value>
</Value>
<Value name="6">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^DHCMed.DC.LIS.BTSensitivityD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.DC.LIS.BTSensitivityD</IdLocation>
<IndexLocation>^DHCMed.DC.LIS.BTSensitivityI</IndexLocation>
<StreamLocation>^DHCMed.DC.LIS.BTSensitivityS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
