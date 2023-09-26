/// 名称: DHCMed.InfAim.Ventilator
/// 描述: 呼吸机相关报告表
/// 编写者：liuyh
/// 编写日期: 2011-10-18
Class DHCMed.InfAim.Ventilator Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 报告表ID 指向 目标性监测报告表：DHCMed_InfAim.Report
Property InfAimRepDR As %Integer [ Required ];

/// 上呼吸机日期
Property VenDate As %String;

/// 置管类型 指向字典表：DHCMed.SS.Dictionary   Code：VenType
Property VenType As %Integer;

/// 置管地点 指向字典表：DHCMed.SS.Dictionary   Code：VenPlace
Property VenPlace As %Integer;

/// 置管人员 指向SS_User
Property VenUserType As %Integer;

/// 脱机日期
Property OutVenDate As %String;

/// 是否死亡 指向字典表：DHCMed.SS.Dictionary   Code：YesNo
Property DeathFlag As %Integer;

/// 去向
Property OutLocPlace As %String;

/// 是否感染 指向字典表：DHCMed.SS.Dictionary   Code：YesNo
Property InfFlag As %Integer;

/// 报告人 指向SS_User
Property RepUser As %Integer;

/// 当前状态 指向字典表：DHCMed.SS.Dictionary   Code：RepStatus
Property RepStatus As %Integer;

/// 初次报告时间
Property FirstDate As %String;

/// 置管小时
Property VenHour As %Integer;

/// 感染时间
Property InfDate As %String;

/// 病原菌
Property Pathogenic As %String;

Index InfAimRepDR On InfAimRepDR;

/// Creator：     liuyh
/// CreatDate：   2011-10-18
/// Description:  将对象格式化为字符串
/// Table：       DHCMed.InfAim.Ventilator
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
/// 1:Rowid 2:InfAimRepDR 3:VenDate 4:VenType 5:VenPlace 6:VenUserType 7:OutVenDate 8:DeathFlag
/// 9:OutLocPlace 10:InfFlag 11:RepUser 12:RepStatus 13:FirstDate 14:VenHour 15:InfDate 16:Pathogenic
Method ToString(separete As %String) As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
		} 
	set return=..%Id()_separete
	set return=return_..InfAimRepDR_separete
	set return=return_..VenDate_separete
	set return=return_..VenType_separete
	set return=return_..VenPlace_separete
	set return=return_..VenUserType_separete
	set return=return_..OutVenDate_separete
	set return=return_..DeathFlag_separete
	set return=return_..OutLocPlace_separete
	set return=return_..InfFlag_separete
	set return=return_..RepUser_separete
	set return=return_..RepStatus_separete
	set return=return_..FirstDate_separete
	set return=return_..VenHour_separete
	set return=return_..InfDate_separete
	set return=return_..Pathogenic
	quit return
}

/// Creator：     liuyh
/// CreatDate：   2011-10-18
/// Description:  根据ID取呼吸机相关报告表对象
/// Table：       DHCMed.InfAim.Ventilator
/// Input：       ID:    DHCMed.InfAim.Ventilator.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.InfAim.Ventilator).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.InfAim.Ventilator
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.InfAim.Ventilator).%ExistsId(+id) return
	set obj=##Class(DHCMed.InfAim.Ventilator).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     liuyh
/// CreatDate：   2011-10-18
/// Description:  根据ID取呼吸机相关报告表信息
/// Table：       DHCMed.InfAim.Ventilator
/// Input：       id: DHCMed.InfAim.Ventilator.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.InfAim.Ventilator).GetStringById(1)
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

/// Creator：     liuyh
/// CreatDate：   2011-10-18
/// Description:  更新呼吸机相关报告表
/// Table：       DHCMed.InfAim.Ventilator
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
ClassMethod Update(InStr As %String) As %String
{
	New (InStr)
	Set return=-1
	
	Set $ZT="UpdateErr"
	Set ID=$p(InStr,"^",1)
	If ID="" {
		Set obj=##class(DHCMed.InfAim.Ventilator).%New()
	}Else{
		Set obj=##class(DHCMed.InfAim.Ventilator).%OpenId(ID)
		Quit:'$IsObject(obj) return
	}
	Set obj.InfAimRepDR=$p(InStr,"^",2)
	Set obj.VenDate=$p(InStr,"^",3)
	Set obj.VenType=$p(InStr,"^",4)
	Set obj.VenPlace=$p(InStr,"^",5)
	Set obj.VenUserType=$p(InStr,"^",6)
	Set obj.OutVenDate=$p(InStr,"^",7)
	Set obj.DeathFlag=$p(InStr,"^",8)
	Set obj.OutLocPlace=$p(InStr,"^",9)
	Set obj.InfFlag=$p(InStr,"^",10)
	Set obj.RepUser=$p(InStr,"^",11)
	Set obj.RepStatus=$p(InStr,"^",12)
	Set obj.FirstDate=$p(InStr,"^",13)
	Set obj.VenHour=$p(InStr,"^",14)
	Set obj.InfDate=$p(InStr,"^",15)
	Set obj.Pathogenic=$p(InStr,"^",16)
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {            //检查Save是否成功
		//Do $System.Status.DisplayError(sc)
   		Set return=-1
	}Else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	Quit return
	
UpdateErr
	Quit -1
}

/// Creator：     liuyh
/// CreatDate：   2011-10-18
/// Description:  删除呼吸机相关报告表
/// Table：       DHCMed.InfAim.Ventilator
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id As %String) As %String
{
	new (Id)
	set sc = ##class(DHCMed.InfAim.Ventilator).%DeleteId(+Id)
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
<Data name="VentilatorDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DeathFlag</Value>
</Value>
<Value name="3">
<Value>FirstDate</Value>
</Value>
<Value name="4">
<Value>InfAimRepDR</Value>
</Value>
<Value name="5">
<Value>InfFlag</Value>
</Value>
<Value name="6">
<Value>OutLocPlace</Value>
</Value>
<Value name="7">
<Value>OutVenDate</Value>
</Value>
<Value name="8">
<Value>RepStatus</Value>
</Value>
<Value name="9">
<Value>RepUser</Value>
</Value>
<Value name="10">
<Value>VenDate</Value>
</Value>
<Value name="11">
<Value>VenHour</Value>
</Value>
<Value name="12">
<Value>VenPlace</Value>
</Value>
<Value name="13">
<Value>VenType</Value>
</Value>
<Value name="14">
<Value>VenUserType</Value>
</Value>
<Value name="15">
<Value>InfDate</Value>
</Value>
<Value name="16">
<Value>Pathogenic</Value>
</Value>
</Data>
<DataLocation>^DHCMed.InfAim.VentilatorD</DataLocation>
<DefaultData>VentilatorDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.InfAim.VentilatorD</IdLocation>
<IndexLocation>^DHCMed.InfAim.VentilatorI</IndexLocation>
<StreamLocation>^DHCMed.InfAim.VentilatorS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
