/// 名称 : DHCMed.DC.LIS.BTTestCodeSC
/// 说明 : 【基础字典】检测项目标准意见
Class DHCMed.DC.LIS.BTTestCodeSC Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 检验组套
Property TestCodeDR As DHCMed.DC.LIS.BTTestCode;

/// 代码
Property Code As %String(MAXLEN = 100, TRUNCATE = 1);

/// 名称
Property CName As %String(MAXLEN = 100, TRUNCATE = 1);

/// 异常标记
Property AbFlag As %String(MAXLEN = 100, TRUNCATE = 1);

/// 索引码
Property XCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否有效
Property Active As %Boolean;

Index IndexCode On (TestCodeDR, Code);

Index IndexCName On (TestCodeDR, CName);

Index IndexXCode On (TestCodeDR, XCode);

/// Creator：     zhufei
/// CreatDate：   2016-03-07
/// Description:  根据CodeDesc取检测项目标准意见
/// Table：       DHCMed.DC.LIS.BTTestCodeSC
/// Input：       Code:    DHCMed.DC.LIS.BTTestCodeSC.Code
///               Desc:    DHCMed.DC.LIS.BTTestCodeSC.CName
/// Return：      返回String
/// w ##class(DHCMed.DC.LIS.BTTestCodeSC).GetIDByCodeDesc()
ClassMethod GetIDByCodeDesc(aCode As %String, aDesc As %String) As %String
{
	new (aCode,aDesc)
	set return=""
	quit:(aCode="")&&(aDesc="") return
	
	if aCode'="" {
		set ID=$o(^DHCMed.DC.LIS.BTTestCodeSCI("IndexCode"," "_$zcvt(aCode,"U"),0))
	} else {
		set ID=$o(^DHCMed.DC.LIS.BTTestCodeSCI("IndexCName"," "_$zcvt(aDesc,"U"),0))
	}
	quit:ID="" return
	
	set obj=..GetObjById(ID)
	quit:'$IsObject(obj) return
	set return=obj.%Id()
	
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2016-03-07
/// Description:  根据Code取检测项目标准意见
/// Table：       DHCMed.DC.LIS.BTTestCodeSC
/// Input：       Code:    DHCMed.DC.LIS.BTTestCodeSC.Code
/// Return：      返回String
/// w ##class(DHCMed.DC.LIS.BTTestCodeSC).GetObjByCode()
ClassMethod GetObjByCode(aCode As %String) As DHCMed.DC.LIS.BTTestCodeSC
{
	new (aCode)
	set return=""
	quit:(aCode="") return
	
	set ID=$o(^DHCMed.DC.LIS.BTTestCodeSCI("IndexCode"," "_$zcvt(aCode,"U"),0))
	quit:ID="" return
	
	set obj=..GetObjById(ID)
	quit:'$IsObject(obj) return
	set return=obj
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2016-03-07
/// Description:  根据ID取检测项目标准意见
/// Table：       DHCMed.DC.LIS.BTTestCodeSC
/// Input：       ID:    DHCMed.DC.LIS.BTTestCodeSC.ID
///               separete: 指定的分隔符
/// Return：      返回Object
/// w ##class(DHCMed.DC.LIS.BTTestCodeSC).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.DC.LIS.BTTestCodeSC
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.DC.LIS.BTTestCodeSC).%ExistsId(+id) return
	set obj=##Class(DHCMed.DC.LIS.BTTestCodeSC).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2016-03-07
/// Description:  更新检测项目标准意见
/// Table：       DHCMed.DC.LIS.BTTestCodeSC
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMed.DC.LIS.BTTestCodeSC).Update()
ClassMethod Update(InStr As %String, separete As %String = "^") As %String
{
	new (InStr,separete)
	set return=0
	quit:InStr="" return
	
	set TestCodeDR = $p(InStr,separete,1)
	set Code       = $p(InStr,separete,2)
	set CName      = $p(InStr,separete,3)
	set AbFlag     = $p(InStr,separete,4)
	set XCode      = $p(InStr,separete,5)
	set Active     = +$p(InStr,separete,6)
	quit:(Code="")||(CName="") return
	
	set objTestCode=##class(DHCMed.DC.LIS.BTTestCode).GetObjById(TestCodeDR)
	quit:'$IsObject(objTestCode) return
	
	//字典代码唯一性
	if XCode'="" {
		set ID=$o(^DHCMed.DC.LIS.BTTestCodeSCI("IndexXCode"," "_$zcvt(XCode,"U"),0))
	} else {
		set ID=$o(^DHCMed.DC.LIS.BTTestCodeSCI("IndexCode"," "_$zcvt(Code,"U"),0))
	}
	
	if ID="" {
		set obj=##class(DHCMed.DC.LIS.BTTestCodeSC).%New()
	}else{
		set obj=##class(DHCMed.DC.LIS.BTTestCodeSC).%OpenId(ID)
	}
	quit:'$IsObject(obj) return
	
	set obj.TestCodeDR = objTestCode
	set obj.Code       = Code
	set obj.CName      = CName
	set obj.AbFlag     = AbFlag
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
/// Description:  删除检测项目标准意见
/// Table：       DHCMed.DC.LIS.BTTestCodeSC
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	new (Id)
	set sc = ##class(DHCMed.DC.LIS.BTTestCodeSC).%DeleteId(+Id)
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
<Value>TestCodeDR</Value>
</Value>
<Value name="3">
<Value>Code</Value>
</Value>
<Value name="4">
<Value>CName</Value>
</Value>
<Value name="5">
<Value>AbFlag</Value>
</Value>
<Value name="6">
<Value>XCode</Value>
</Value>
<Value name="7">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^DHCMed.DC.LIS.BTTestCodeSCD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.DC.LIS.BTTestCodeSCD</IdLocation>
<IndexLocation>^DHCMed.DC.LIS.BTTestCodeSCI</IndexLocation>
<StreamLocation>^DHCMed.DC.LIS.BTTestCodeSCS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
