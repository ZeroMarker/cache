/// 名称: DHCMed.SS.Hospital
/// 描述: 医院列表
/// 编写者：zhufei
/// 编写日期: 2014-03-17
Class DHCMed.SS.Hospital Extends (%Persistent, DHCMed.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 医院代码
Property HospCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = HospCode ];

/// 医院名称
Property HospDesc As %String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = HospDesc ];

/// 医院指针(CT_Hospital)
Property HospitalDr As %String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = HospitalDr ];

/// 产品指针(DHCMed.SS.Products)
Property ProductDr As %String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = ProductDr ];

/// 是否有效
Property IsActive As %Boolean [ SqlColumnNumber = 6, SqlFieldName = IsActive ];

/// 备注
Property Resume As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = Resume ];

Index IndexProductHospital On (ProductDr, HospCode, HospitalDr) [ Unique ];

/// Creator：     zhufei
/// CreatDate：   2014-03-17
/// Description:  根据ID取医院列表记录
/// Table：       DHCMed.SS.Hospital
/// Input：       ID:    DHCMed.SS.Hospital.ID
///               separete: 指定的分隔符
/// Return：      返回Object
/// w ##class(DHCMed.SS.Hospital).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.SS.Hospital
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.SS.Hospital).%ExistsId(+id) return
	set obj=##Class(DHCMed.SS.Hospital).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-03-17
/// Description:  更新医院列表记录
/// Table：       DHCMed.SS.Hospital
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMed.SS.Hospital).Update("^BJYY^北京医院^3^3^0^22","")
ClassMethod Update(InStr As %String, separete As %String = "^") As %String
{
	new (InStr,separete)
	set return=0
	quit:InStr="" return
	
	set:$g(separete)="" separete=..#SEPARATE
	set ID          = $p(InStr,separete,1)
	set HospCode    = $p(InStr,separete,2)
	set HospDesc    = $p(InStr,separete,3)
	set HospitalDr  = $p(InStr,separete,4)
	set ProductDr   = +$p(InStr,separete,5)
	set IsActive    = $p(InStr,separete,6)
	set Resume      = $p(InStr,separete,7)
	quit:(HospitalDr="")||(HospCode="")||(HospDesc="") return
	
	set tID=$o(^DHCMed.SS.HospitalI("IndexProductHospital"," "_ProductDr," "_$zcvt(HospCode,"U")," "_HospitalDr,0))
	quit:(ID'="")&&(tID'="")&&(tID'=ID) -100  //数据重复
	
	if ID="" {
		set obj=##class(DHCMed.SS.Hospital).%New()
	}else{
		set obj=##class(DHCMed.SS.Hospital).%OpenId(ID)
	}
	quit:'$IsObject(obj) return
	
	set obj.HospCode   = HospCode
	set obj.HospDesc   = HospDesc
	set obj.HospitalDr = HospitalDr
	set obj.ProductDr  = +ProductDr
	set obj.IsActive   = IsActive
	set obj.Resume     = Resume
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
/// CreatDate：   2014-03-17
/// Description:  删除医院列表记录
/// Table：       DHCMed.SS.Hospital
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMed.SS.Hospital).DeleteById(3)
ClassMethod DeleteById(Id As %String)
{
	new (Id)
	set sc = ##class(DHCMed.SS.Hospital).%DeleteId(+Id)
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
<Value>HospCode</Value>
</Value>
<Value name="3">
<Value>HospDesc</Value>
</Value>
<Value name="4">
<Value>HospitalDr</Value>
</Value>
<Value name="5">
<Value>ProductDr</Value>
</Value>
<Value name="6">
<Value>IsActive</Value>
</Value>
<Value name="7">
<Value>Resume</Value>
</Value>
</Data>
<DataLocation>^DHCMed.SS.HospitalD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.SS.HospitalD</IdLocation>
<IndexLocation>^DHCMed.SS.HospitalI</IndexLocation>
<StreamLocation>^DHCMed.SS.HospitalS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
