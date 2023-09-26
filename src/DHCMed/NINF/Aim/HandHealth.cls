/// 说明：医院感染手卫生依从性录入表
Class DHCMed.NINF.Aim.HandHealth Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 科室
Property CTLocDR As %String(TRUNCATE = 1);

/// 观察日期
Property ObserveDate As %String(TRUNCATE = 1);

/// 观察时间
Property ObserveTime As %String(TRUNCATE = 1);

/// 观察者
Property ObserverDR As %String(TRUNCATE = 1);

/// 专业类
Property Identitys As %String(TRUNCATE = 1);

/// 手卫生指针
Property HandPoint As %String(TRUNCATE = 1);

/// 手卫生措施
Property HandAction As %String(TRUNCATE = 1);

/// 手术卫生是否正确
Property HandActionRit As %String(TRUNCATE = 1);

/// 病区
Property WardDR As %String(TRUNCATE = 1);

Index IndexOfDateLoc On (ObserveDate, CTLocDR);

Index IndexOfDate On ObserveDate;

Method ToString(separete As %String) As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
		} 
	set return=..%Id()_separete
	set return=return_..CTLocDR_separete
	set return=return_..ObserveDate _separete
	set return=return_..ObserveTime_separete
	set return=return_..ObserverDR_separete
	set return=return_..Identitys_separete
	set return=return_..HandPoint_separete
	set return=return_..HandAction_separete
	set return=return_..HandActionRit_separete
	set return=return_..WardDR
	quit return
}

/// w ##class(DHCMed.NINF.Aim.HandHealth).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.NINF.Aim.HandHealth
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.NINF.Aim.HandHealth).%ExistsId(+id) return
	set obj=##Class(DHCMed.NINF.Aim.HandHealth).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// w ##class(DHCMed.NINF.Aim.HandHealth).GetStringById(1)
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

/// w ##class(DHCMed.NINF.Aim.HandHealth).Update(^2^3^4^^^^^^)
ClassMethod Update(InStr As %String) As %String
{
	new (InStr)
	set id=0
	set ID=$p(InStr,"^",1)	
	if ID="" {
		set obj=##class(DHCMed.NINF.Aim.HandHealth).%New()
		} 
	else {
		set obj=##class(DHCMed.NINF.Aim.HandHealth).%OpenId(ID)
		}
	set obj.CTLocDR= $p(InStr,"^",2)
	set obj.ObserveDate  = $p(InStr,"^",3)
	set:obj.ObserveDate["-" obj.ObserveDate=$zdh(obj.ObserveDate,3)
	set obj.ObserveTime = $p(InStr,"^",4)
	set:obj.ObserveTime["-" obj.ObserveTime=$zth(obj.ObserveTime,2)
	set obj.ObserverDR = $p(InStr,"^",5)
	set obj.Identitys = $p(InStr,"^",6)
	set obj.HandPoint = $p(InStr,"^",7)
	set obj.HandAction =$p(InStr,"^",8)
	set obj.HandActionRit =$p(InStr,"^",9)
	set obj.WardDR=$p(InStr,"^",10)
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
	set sc = ##class(DHCMed.NINF.Aim.HandHealth).%DeleteId(+Id)
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
<Data name="HandHealthDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AfInAir</Value>
</Value>
<Value name="3">
<Value>AfTouchLiquid</Value>
</Value>
<Value name="4">
<Value>AfTouchPat</Value>
</Value>
<Value name="5">
<Value>BfAction</Value>
</Value>
<Value name="6">
<Value>BfTouchPat</Value>
</Value>
<Value name="7">
<Value>CTLocDR</Value>
</Value>
<Value name="8">
<Value>HandAction</Value>
</Value>
<Value name="9">
<Value>HandActionRit</Value>
</Value>
<Value name="10">
<Value>Identity</Value>
</Value>
<Value name="11">
<Value>ObserveDate</Value>
</Value>
<Value name="12">
<Value>ObserveTime</Value>
</Value>
<Value name="13">
<Value>Observer</Value>
</Value>
<Value name="14">
<Value>ObserverID</Value>
</Value>
<Value name="15">
<Value>HandPoint</Value>
</Value>
<Value name="16">
<Value>ObserverDR</Value>
</Value>
<Value name="17">
<Value>WardDR</Value>
</Value>
<Value name="18">
<Value>Identitys</Value>
</Value>
</Data>
<DataLocation>^DHCMed.NINF.Aim.HandHealthD</DataLocation>
<DefaultData>HandHealthDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.NINF.Aim.HandHealthD</IdLocation>
<IndexLocation>^DHCMed.NINF.Aim.HandHealthI</IndexLocation>
<StreamLocation>^DHCMed.NINF.Aim.HandHealthS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
