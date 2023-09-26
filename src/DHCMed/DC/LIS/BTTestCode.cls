/// 名称 : DHCMed.DC.LIS.BTTestCode
/// 说明 : 【基础字典】检测项目
Class DHCMed.DC.LIS.BTTestCode Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 代码
Property Code As %String(MAXLEN = 100, TRUNCATE = 1);

/// 名称
Property CName As %String(MAXLEN = 100, TRUNCATE = 1);

/// 医院代码
Property HospCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 全称
Property LName As %String(MAXLEN = 100, TRUNCATE = 1);

/// 英文名称
Property EName As %String(MAXLEN = 100, TRUNCATE = 1);

/// 英文简称
Property Synonym As %String(MAXLEN = 100, TRUNCATE = 1);

/// 单位
Property Units As %String(MAXLEN = 100, TRUNCATE = 1);

/// 结果格式（N数值结果、S标准字典、M细菌培养、X文本结果）
Property ResultFormat As %String(MAXLEN = 100, TRUNCATE = 1);

/// 精确度（几位小数）
Property Precision As %String(MAXLEN = 100, TRUNCATE = 1);

/// 缩写码
Property SCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 检验组套(无效)
Property TestSetDR As DHCMed.DC.LIS.BTTestSet;

/// 索引码
Property XCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否有效
Property Active As %Boolean;

Index IndexCode On (HospCode, Code);

Index IndexCName On (HospCode, CName);

Index IndexXCode On (HospCode, XCode);

/// Creator：     zhufei
/// CreatDate：   2016-03-07
/// Description:  根据CodeDesc取检测项目字典
/// Table：       DHCMed.DC.LIS.BTTestCode
/// Input：       Code:    DHCMed.DC.LIS.BTTestCode.Code
///               Desc:    DHCMed.DC.LIS.BTTestCode.CName
/// Return：      返回String
/// w ##class(DHCMed.DC.LIS.BTTestCode).GetIDByCodeDesc()
ClassMethod GetIDByCodeDesc(aCode As %String, aDesc As %String, aHospCode As %String) As %String
{
	new (aCode,aDesc,aHospCode)
	set return=""
	quit:((aCode="")&&(aDesc=""))||(aHospCode="") return
	
	if aCode'="" {
		set ID=$o(^DHCMed.DC.LIS.BTTestCodeI("IndexCode"," "_$zcvt(aHospCode,"U")," "_$zcvt(aCode,"U"),0))
	} else {
		set ID=$o(^DHCMed.DC.LIS.BTTestCodeI("IndexCName"," "_$zcvt(aHospCode,"U")," "_$zcvt(aDesc,"U"),0))
	}
	quit:ID="" return
	
	set obj=..GetObjById(ID)
	quit:'$IsObject(obj) return
	set return=obj.%Id()
	
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2016-03-07
/// Description:  根据Code取检测项目字典
/// Table：       DHCMed.DC.LIS.BTTestCode
/// Input：       Code:    DHCMed.DC.LIS.BTTestCode.Code
/// Return：      返回String
/// w ##class(DHCMed.DC.LIS.BTTestCode).GetObjByCode()
ClassMethod GetObjByCode(aCode As %String, aHospCode As %String) As DHCMed.DC.LIS.BTTestCode
{
	new (aCode,aHospCode)
	set return=""
	quit:(aCode="")||(aHospCode="") return
	
	set ID=$o(^DHCMed.DC.LIS.BTTestCodeI("IndexCode"," "_$zcvt(aHospCode,"U")," "_$zcvt(aCode,"U"),0))
	quit:ID="" return
	
	set obj=..GetObjById(ID)
	quit:'$IsObject(obj) return
	set return=obj
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2016-03-07
/// Description:  根据ID取检测项目字典
/// Table：       DHCMed.DC.LIS.BTTestCode
/// Input：       ID:    DHCMed.DC.LIS.BTTestCode.ID
///               separete: 指定的分隔符
/// Return：      返回Object
/// w ##class(DHCMed.DC.LIS.BTTestCode).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.DC.LIS.BTTestCode
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.DC.LIS.BTTestCode).%ExistsId(+id) return
	set obj=##Class(DHCMed.DC.LIS.BTTestCode).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2016-03-07
/// Description:  更新检测项目字典
/// Table：       DHCMed.DC.LIS.BTTestCode
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMed.DC.LIS.BTTestCode).Update()
ClassMethod Update(InStr As %String, separete As %String = "^") As %String
{
	new (InStr,separete)
	set return=0
	quit:InStr="" return
	
	set Code         = $p(InStr,separete,1)
	set CName        = $p(InStr,separete,2)
	set HospCode     = $p(InStr,separete,3)
	set LName        = $p(InStr,separete,4)
	set EName        = $p(InStr,separete,5)
	set Synonym      = $p(InStr,separete,6)
	set Units        = $p(InStr,separete,7)
	set ResultFormat = $p(InStr,separete,8)
	set Precision    = $p(InStr,separete,9)
	set SCode        = $p(InStr,separete,10)
	set TestSetDR    = $p(InStr,separete,11)
	set XCode        = $p(InStr,separete,12)
	set Active       = +$p(InStr,separete,13)
	quit:(Code="")||(CName="") return
	
	set objTestSet=##Class(DHCMed.DC.LIS.BTTestSet).GetObjById(TestSetDR)
	
	//字典代码唯一性
	if XCode'="" {
		set ID=$o(^DHCMed.DC.LIS.BTTestCodeI("IndexXCode"," "_$zcvt(HospCode,"U")," "_$zcvt(XCode,"U"),0))
	} else {
		set ID=$o(^DHCMed.DC.LIS.BTTestCodeI("IndexCode"," "_$zcvt(HospCode,"U")," "_$zcvt(Code,"U"),0))
	}
	
	if ID="" {
		set obj=##class(DHCMed.DC.LIS.BTTestCode).%New()
	}else{
		set obj=##class(DHCMed.DC.LIS.BTTestCode).%OpenId(ID)
	}
	quit:'$IsObject(obj) return
	
	set obj.Code         = Code
	set obj.CName        = CName
	set obj.HospCode     = HospCode
	set obj.LName        = LName
	set obj.EName        = EName
	set obj.Synonym      = Synonym
	set obj.Units        = Units
	set obj.ResultFormat = ResultFormat
	set obj.Precision    = Precision
	set obj.SCode        = SCode
	set obj.TestSetDR    = objTestSet
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
/// Description:  删除检测项目字典
/// Table：       DHCMed.DC.LIS.BTTestCode
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	new (Id)
	set sc = ##class(DHCMed.DC.LIS.BTTestCode).%DeleteId(+Id)
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
<Value>LName</Value>
</Value>
<Value name="6">
<Value>EName</Value>
</Value>
<Value name="7">
<Value>Synonym</Value>
</Value>
<Value name="8">
<Value>Units</Value>
</Value>
<Value name="9">
<Value>ResultFormat</Value>
</Value>
<Value name="10">
<Value>Precision</Value>
</Value>
<Value name="11">
<Value>SCode</Value>
</Value>
<Value name="12">
<Value>TestSetDR</Value>
</Value>
<Value name="13">
<Value>XCode</Value>
</Value>
<Value name="14">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^DHCMed.DC.LIS.BTTestCodeD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.DC.LIS.BTTestCodeD</IdLocation>
<IndexLocation>^DHCMed.DC.LIS.BTTestCodeI</IndexLocation>
<StreamLocation>^DHCMed.DC.LIS.BTTestCodeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
