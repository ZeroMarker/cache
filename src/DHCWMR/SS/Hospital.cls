/// 医院配置列表
Class DHCWMR.SS.Hospital Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 医院代码
Property SHCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 医院名称
Property SHDesc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 医院指针(指向CT_Hospital)
Property SHHospID As %String(MAXLEN = 100, TRUNCATE = 1);

/// 备注
Property SHResume As %String(MAXLEN = 500, TRUNCATE = 1);

Index IndexCode On (SHCode, SHHospID) [ Unique ];

/// Creator：     zhufei
/// CreatDate：   2014-08-27
/// Description:  根据ID取医院列表记录
/// Table：       DHCWMR.SS.Hospital
/// Input：       Id : DHCWMR.SS.Hospital.ID
/// Return：      返回Object
/// w ##class(DHCWMR.SS.Hospital).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCWMR.SS.Hospital
{
	new (aId)
	quit:'##class(DHCWMR.SS.Hospital).%ExistsId(aId) ""
	set obj=##Class(DHCWMR.SS.Hospital).%OpenId(aId)
	do:obj'="" obj.%Close()
	quit obj
}

/// Creator：     zhufei
/// CreatDate：   2014-08-27
/// Description:  更新医院列表记录
/// Table：       DHCWMR.SS.Hospital
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCWMR.SS.Hospital).Update("^BJDT^北京地坛^2^","^")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	new (aInputStr,aSeparate)
	set return=0
	quit:aInputStr="" return
	
	set ID          = $p(aInputStr,aSeparate,1)
	set HospCode    = $p(aInputStr,aSeparate,2)
	set HospDesc    = $p(aInputStr,aSeparate,3)
	set HospitalDr  = $p(aInputStr,aSeparate,4)
	set Resume      = $p(aInputStr,aSeparate,5)
	quit:(HospitalDr="")||(HospCode="")||(HospDesc="") return
	
	if ID="" {
		set obj=##class(DHCWMR.SS.Hospital).%New()
	}else{
		set obj=##class(DHCWMR.SS.Hospital).%OpenId(ID)
	}
	quit:'$IsObject(obj) return
	
	set obj.SHCode   = HospCode
	set obj.SHDesc   = HospDesc
	set obj.SHHospID = HospitalDr
	set obj.SHResume = Resume
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
/// CreatDate：   2014-08-27
/// Description:  删除医院列表记录
/// Table：       DHCWMR.SS.Hospital
/// Input：       Id : DHCWMR.SS.Hospital.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId)
{
	new (aId)
	set return=0
	quit:aId="" return
	set sc = ##class(DHCWMR.SS.Hospital).%DeleteId(aId)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc)
   		set return=-1
	}else{
		set return=1
	}
	quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SHCode</Value>
</Value>
<Value name="3">
<Value>SHDesc</Value>
</Value>
<Value name="4">
<Value>SHHospID</Value>
</Value>
<Value name="5">
<Value>SHResume</Value>
</Value>
</Data>
<DataLocation>^DHCWMR.SS.HospitalD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWMR.SS.HospitalD</IdLocation>
<IndexLocation>^DHCWMR.SS.HospitalI</IndexLocation>
<StreamLocation>^DHCWMR.SS.HospitalS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
