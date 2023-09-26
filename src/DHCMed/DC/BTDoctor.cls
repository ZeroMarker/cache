/// 名称 : DHCMed.DC.BTDoctor
/// 说明 : 【系统字典】医护人员
Class DHCMed.DC.BTDoctor Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 代码
Property Code As %String(MAXLEN = 100, TRUNCATE = 1);

/// 名称
Property CName As %String(MAXLEN = 100, TRUNCATE = 1);

/// 医院代码
Property HospCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 医护人员类型（D医生、N护士）
Property CarPrvTp As %String(MAXLEN = 100, TRUNCATE = 1);

/// 备注
Property Remark As %String(MAXLEN = 100, TRUNCATE = 1);

/// 索引码
Property XCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否有效
Property Active As %Boolean;

Index IndexCode On (HospCode, Code);

Index IndexCName On (HospCode, CName);

/// Creator：     zhufei
/// CreatDate：   2016-03-07
/// Description:  根据CodeDesc取医护人员字典
/// Table：       DHCMed.DC.BTDoctor
/// Input：       Code:    DHCMed.DC.BTDoctor.Code
///               Desc:    DHCMed.DC.BTDoctor.CName
/// Return：      返回String
/// w ##class(DHCMed.DC.BTDoctor).GetIDByCodeDesc()
ClassMethod GetIDByCodeDesc(aCode As %String, aDesc As %String, aHospCode As %String) As %String
{
	new (aCode,aDesc,aHospCode)
	set return=""
	quit:(aCode="")&&(aDesc="") return
	quit:aHospCode="" return
	
	if aCode'="" {
		set ID=$o(^DHCMed.DC.BTDoctorI("IndexCode"," "_$zcvt(aHospCode,"U")," "_$zcvt(aCode,"U"),0))
	} else {
		set ID=$o(^DHCMed.DC.BTDoctorI("IndexCName"," "_$zcvt(aHospCode,"U")," "_$zcvt(aDesc,"U"),0))
	}
	quit:ID="" return
	
	set obj=..GetObjById(ID)
	quit:'$IsObject(obj) return
	set return=obj.%Id()
	
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2016-03-07
/// Description:  根据ID取医护人员字典
/// Table：       DHCMed.DC.BTDoctor
/// Input：       ID:    DHCMed.DC.BTDoctor.ID
///               separete: 指定的分隔符
/// Return：      返回Object
/// w ##class(DHCMed.DC.BTDoctor).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.DC.BTDoctor
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.DC.BTDoctor).%ExistsId(+id) return
	set obj=##Class(DHCMed.DC.BTDoctor).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2016-03-07
/// Description:  更新医护人员字典
/// Table：       DHCMed.DC.BTDoctor
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMed.DC.BTDoctor).Update()
ClassMethod Update(InStr As %String, separete As %String = "^") As %String
{
	new (InStr,separete)
	set return=0
	quit:InStr="" return
	
	set Code     = $p(InStr,separete,1)
	set CName    = $p(InStr,separete,2)
	set HospCode = $p(InStr,separete,3)
	set CarPrvTp = $p(InStr,separete,4)
	set Remark   = $p(InStr,separete,5)
	set XCode    = $p(InStr,separete,6)
	set Active   = +$p(InStr,separete,7)
	quit:(Code="")||(CName="")||(HospCode="") return
	
	//字典代码唯一性
	set ID=..GetIDByCodeDesc(Code,CName,HospCode)
	
	if ID="" {
		set obj=##class(DHCMed.DC.BTDoctor).%New()
	}else{
		set obj=##class(DHCMed.DC.BTDoctor).%OpenId(ID)
	}
	quit:'$IsObject(obj) return
	
	set obj.Code     = Code
	set obj.CName    = CName
	set obj.HospCode = HospCode
	set obj.CarPrvTp = CarPrvTp
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
/// Description:  删除医护人员字典
/// Table：       DHCMed.DC.BTDoctor
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	new (Id)
	set sc = ##class(DHCMed.DC.BTDoctor).%DeleteId(+Id)
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
<Value>CarPrvTp</Value>
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
<DataLocation>^DHCMed.DC.BTDoctorD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.DC.BTDoctorD</IdLocation>
<IndexLocation>^DHCMed.DC.BTDoctorI</IndexLocation>
<StreamLocation>^DHCMed.DC.BTDoctorS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
