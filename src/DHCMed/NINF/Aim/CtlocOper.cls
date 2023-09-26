/// 名称: DHCMed.NINF.Aim.CtlocOper
/// 描述: 目标性监测主题关联科室
/// 编写者：liuyh
/// 编写日期: 2012-08-17
Class DHCMed.NINF.Aim.CtlocOper Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 监测主题
Property AimType As %String [ Required ];

/// 科室ID
Property CtlocID As %String [ Required ];

/// 是否有效
Property IsActive As %String [ Required ];

Index TypeLoc On (AimType, CtlocID) [ Unique ];

Index AimType On (AimType, CtlocID, IsActive);

Method ToString(separete As %String = "") As %String
{
	if separete=""{
		set separete=..#SEPARATE}
		set return=..%Id()_separete
		set return=return_..AimType_separete
		set return=return_..CtlocID_separete
		set return=return_..IsActive
		quit return
}

ClassMethod GetObjById(id As %String) As DHCMed.NINF.Aim.CtlocOper
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.NINF.Aim.CtlocOper).%ExistsId(+id) return
	set obj=##Class(DHCMed.NINF.Aim.CtlocOper).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

ClassMethod GetStringById(id As %String, separete As %String) As %String
{
	
	new (id,separete)
	set return=""
	set obj=..GetObjById(id)
	if $IsObject(obj){
		set return=obj.ToString($g(separete))
	}	
	quit return
}

/// w ##class(DHCMed.NINF.Aim.CtlocOper).Update("^ICU^1^Y","")
ClassMethod Update(InStr As %String, separete As %String) As %String
{
	new (InStr,separete)
	if $g(separete)=""{
		set separete=..#SEPARATE
		}
	set id=0
	set ID=$p(InStr,separete,1)
	if ID="" {
		set obj=##class(DHCMed.NINF.Aim.CtlocOper).%New()
		} 
	else {
			set obj=##class(DHCMed.NINF.Aim.CtlocOper).%OpenId(ID)
		}
	set obj.AimType=$p(InStr,separete,2)
	set obj.CtlocID=$p(InStr,separete,3)
	set obj.IsActive=$p(InStr,separete,4)
	set sc=obj.%Save()
	if $system.Status.IsError(sc) {                               //检查Save是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set id=-1
	}
	else{
		set id=obj.%Id()
		}
	do obj.%Close()
	quit id
}

ClassMethod DeleteById(Id As %String) As %String
{
	new (Id)
	set sc = ##class(DHCMed.NINF.Aim.CtlocOper).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set ret=-1
	}
	else{
		set ret=0
		}
	quit ret
}

Storage Default
{
<Data name="CtlocOperDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AimType</Value>
</Value>
<Value name="3">
<Value>CtlocID</Value>
</Value>
<Value name="4">
<Value>是否有效</Value>
</Value>
<Value name="5">
<Value>IsActive</Value>
</Value>
</Data>
<DataLocation>^DHCMed.NINF.Aim.CtlocOperD</DataLocation>
<DefaultData>CtlocOperDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.NINF.Aim.CtlocOperD</IdLocation>
<IndexLocation>^DHCMed.NINF.Aim.CtlocOperI</IndexLocation>
<StreamLocation>^DHCMed.NINF.Aim.CtlocOperS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
