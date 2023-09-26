/// 名称: DHCMed.InfAim.RepStatusDtls
/// 描述: 目标性监测日志表
/// 编写者：liuyh
/// 编写日期: 2011-10-18
Class DHCMed.InfAim.RepStatusDtls Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 报告表ID 指向 目标性监测报告表：DHCMed_InfAim.Report
Property InfAimRepDR As %Integer [ Required ];

/// 监测子表ID 指向 表：DHCMed_InfAim.Catheter/Ventilator/Pipe/NICU/Operation
Property AimSubRepDR As %Integer [ Required ];

/// 报告状态 指向字典表：DHCMed.SS.Dictionary   Code：AimStatus
Property StatusDR As %Integer [ Required ];

/// 指向用户表 SS_User
Property UpdateUser As %Integer [ Required ];

/// 更新日期
Property UpdateDate As %Integer [ Required ];

/// 更新时间
Property UpdateTime As %Integer [ Required ];

/// Creator：     liuyh
/// CreatDate：   2011-10-18
/// Description:  将对象格式化为字符串
/// Table：       DHCMed.InfAim.RepStatusDtls
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
/// 1:Rowid 2:InfAimRepDR 3:AimSubRepDR 4:StatusDR 5:UpdateUser 6:UpdateDate 7:UpdateTime
Method ToString(separete As %String) As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
		} 
	set return=..%Id()_separete
	set return=return_..InfAimRepDR_separete
	set return=return_..AimSubRepDR_separete
	set return=return_..StatusDR_separete
	set return=return_..UpdateUser_separete
	set return=return_..UpdateDate_separete
	set return=return_..UpdateTime
	quit return
}

/// Creator：     liuyh
/// CreatDate：   2011-10-18
/// Description:  根据ID取目标性监测日志表对象
/// Table：       DHCMed.InfAim.RepStatusDtls
/// Input：       ID:    DHCMed.InfAim.RepStatusDtls.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.InfAim.RepStatusDtls).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.InfAim.RepStatusDtls
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.InfAim.RepStatusDtls).%ExistsId(+id) return
	set obj=##Class(DHCMed.InfAim.RepStatusDtls).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     liuyh
/// CreatDate：   2011-10-18
/// Description:  根据ID取目标性监测日志表信息
/// Table：       DHCMed.InfAim.RepStatusDtls
/// Input：       id: DHCMed.InfAim.RepStatusDtls.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.InfAim.RepStatusDtls).GetStringById(1)
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
/// Description:  更新目标性监测日志表
/// Table：       DHCMed.InfAim.RepStatusDtls
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// 1:Rowid 2:PaadmDR 3:CtLoc 4:InLocDate
ClassMethod Update(InStr As %String) As %String
{
	New (InStr)
	Set return=-1
	
	Set $ZT="UpdateErr"
	Set ID=$p(InStr,"^",1)
	If ID="" {
		Set obj=##class(DHCMed.InfAim.RepStatusDtls).%New()
	}Else{
		Set obj=##class(DHCMed.InfAim.RepStatusDtls).%OpenId(ID)
		Quit:'$IsObject(obj) return
	}
	Set obj.InfAimRepDR=$p(InStr,"^",2)
	Set obj.AimSubRepDR=$p(InStr,"^",3)
	Set obj.StatusDR=$p(InStr,"^",4)
	Set obj.UpdateUser=$p(InStr,"^",5)
	Set obj.UpdateDate=$p(InStr,"^",6)
	Set obj.UpdateTime=$p(InStr,"^",7)
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
/// Description:  删除目标性监测日志表
/// Table：       DHCMed.InfAim.RepStatusDtls
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id As %String) As %String
{
	new (Id)
	set sc = ##class(DHCMed.InfAim.RepStatusDtls).%DeleteId(+Id)
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
<Data name="RepStatusDtlsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CtLoc</Value>
</Value>
<Value name="3">
<Value>InLocDate</Value>
</Value>
<Value name="4">
<Value>PaadmDR</Value>
</Value>
<Value name="5">
<Value>AimSubRepDR</Value>
</Value>
<Value name="6">
<Value>InfAimRepDR</Value>
</Value>
<Value name="7">
<Value>StatusDr</Value>
</Value>
<Value name="8">
<Value>UpdateDate</Value>
</Value>
<Value name="9">
<Value>UpdateTime</Value>
</Value>
<Value name="10">
<Value>UpdateUser</Value>
</Value>
<Value name="11">
<Value>StatusDR</Value>
</Value>
</Data>
<DataLocation>^DHCMed.InfAim.RepStatusDtlsD</DataLocation>
<DefaultData>RepStatusDtlsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.InfAim.RepStatusDtlsD</IdLocation>
<IndexLocation>^DHCMed.InfAim.RepStatusDtlsI</IndexLocation>
<StreamLocation>^DHCMed.InfAim.RepStatusDtlsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
