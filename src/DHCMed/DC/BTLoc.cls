/// 名称 : DHCMed.DC.BTLoc
/// 说明 : 【系统字典】科室
Class DHCMed.DC.BTLoc Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 代码
Property Code As %String(MAXLEN = 100, TRUNCATE = 1);

/// 名称
Property CName As %String(MAXLEN = 100, TRUNCATE = 1);

/// 医院代码
Property HospCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 科室类型（科室E、病区W、...）
Property LocType As %String(MAXLEN = 100, TRUNCATE = 1);

/// 备注
Property Remark As %String(MAXLEN = 100, TRUNCATE = 1);

/// 索引码
Property XCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否有效
Property Active As %Boolean;

Index IndexCode On (HospCode, Code);

Index IndexCName On (HospCode, CName);

Index IndexXCode On (HospCode, XCode);

/// Creator：     zhufei
/// CreatDate：   2016-03-07
/// Description:  根据CodeDesc取科室字典
/// Table：       DHCMed.DC.BTLoc
/// Input：       Code:    DHCMed.DC.BTLoc.Code
///               Desc:    DHCMed.DC.BTLoc.CName
/// Return：      返回String
/// w ##class(DHCMed.DC.BTLoc).GetIDByCodeDesc()
ClassMethod GetIDByCodeDesc(aCode As %String, aDesc As %String, aHospCode As %String) As %String
{
	new (aCode,aDesc,aHospCode)
	set return=""
	quit:(aCode="")&&(aDesc="") return
	quit:aHospCode="" return
	
	if aCode'="" {
		set ID=$o(^DHCMed.DC.BTLocI("IndexCode"," "_$zcvt(aHospCode,"U")," "_$zcvt(aCode,"U"),0))
	} else {
		set ID=$o(^DHCMed.DC.BTLocI("IndexCName"," "_$zcvt(aHospCode,"U")," "_$zcvt(aDesc,"U"),0))
	}
	quit:ID="" return
	
	set obj=..GetObjById(ID)
	quit:'$IsObject(obj) return
	set return=obj.%Id()
	
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2016-03-07
/// Description:  根据ID取科室字典
/// Table：       DHCMed.DC.BTLoc
/// Input：       ID:    DHCMed.DC.BTLoc.ID
///               separete: 指定的分隔符
/// Return：      返回Object
/// w ##class(DHCMed.DC.BTLoc).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.DC.BTLoc
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.DC.BTLoc).%ExistsId(+id) return
	set obj=##Class(DHCMed.DC.BTLoc).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2016-03-07
/// Description:  更新科室字典
/// Table：       DHCMed.DC.BTLoc
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMed.DC.BTLoc).Update()
ClassMethod Update(InStr As %String, separete As %String = "^") As %String
{
	new (InStr,separete)
	set return=0
	quit:InStr="" return
	
	set Code     = $p(InStr,separete,1)
	set CName    = $p(InStr,separete,2)
	set HospCode = $p(InStr,separete,3)
	set LocType  = $p(InStr,separete,4)
	set Remark   = $p(InStr,separete,5)
	set XCode = $p(InStr,separete,6)
	set Active   = +$p(InStr,separete,7)
	quit:(Code="")||(CName="") return
	
	//字典代码唯一性
	set ID=##class(DHCMed.DC.BTLoc).GetIDByCodeDesc(Code,CName,HospCode)
	
	if ID="" {
		set obj=##class(DHCMed.DC.BTLoc).%New()
	}else{
		set obj=##class(DHCMed.DC.BTLoc).%OpenId(ID)
	}
	quit:'$IsObject(obj) return
	
	set obj.Code     = Code
	set obj.CName    = CName
	set obj.HospCode = HospCode
	set obj.LocType  = LocType
	set obj.Remark   = Remark
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
/// Description:  删除科室字典
/// Table：       DHCMed.DC.BTLoc
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	new (Id)
	set sc = ##class(DHCMed.DC.BTLoc).%DeleteId(+Id)
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
<Value>LocType</Value>
</Value>
<Value name="6">
<Value>Remark</Value>
</Value>
<Value name="7">
<Value>XCode</Value>
</Value>
<Value name="8">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^DHCMed.DC.BTLocD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.DC.BTLocD</IdLocation>
<IndexLocation>^DHCMed.DC.BTLocI</IndexLocation>
<StreamLocation>^DHCMed.DC.BTLocS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
