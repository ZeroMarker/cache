/// 名称: DHCMed.InfAim.NICU
/// 描述: NICU报告表 
/// 编写者：liuyh
/// 编写日期: 2011-10-18
Class DHCMed.InfAim.NICU Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 报告表ID 指向 目标性监测报告表：DHCMed_InfAim.Report
Property InfAimRepDR As %Integer [ Required ];

/// 出生体重 指向字典表：DHCMed.SS.Dictionary   Code：AimBornWeight
Property BornWeight As %String;

/// 尿管开始日期
Property CatDateFrom As %Integer;

/// 尿管结束日期
Property CatDateTo As %Integer;

/// 导管开始日期
Property PipeDateFrom As %Integer;

/// 导管结束日期
Property PipeDateTo As %Integer;

/// 呼吸机开始日期
Property VenDateFrom As %Integer;

/// 呼吸机结束日期
Property VenDateTo As %Integer;

/// 尿管是否感染 指向字典表：DHCMed.SS.Dictionary   Code：YesNo
Property InfFlag As %Integer;

/// 报告人 指向SS_User
Property RepUser As %Integer;

/// 当前状态 指向字典表：DHCMed.SS.Dictionary   Code：RepStatus
Property RepStatus As %Integer;

/// 初次报告时间
Property FirstDate As %Integer;

/// 尿管感染时间
Property InfDate As %Integer;

/// 尿管病原菌
Property Pathogenic As %String;

/// 导管是否感染 指向字典表：DHCMed.SS.Dictionary   Code：YesNo
Property PipeInfFlag As %Integer;

/// 导管感染时间
Property PipeInfDate As %Integer;

/// 导管病原菌
Property PipePathogenic As %String;

/// 呼吸机是否感染 指向字典表：DHCMed.SS.Dictionary   Code：YesNo
Property VenInfFlag As %Integer;

/// 呼吸机感染时间
Property VenInfDate As %Integer;

/// 呼吸机病原菌
Property VenPathogenic As %String;

Index InfAimRepDR On InfAimRepDR;

/// Creator：     liuyh
/// CreatDate：   2011-10-18
/// Description:  将对象格式化为字符串
/// Table：       DHCMed.InfAim.NICU
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
/// 1:Rowid 2:InfAimRepDR 3:BornWeight 4:CatDateFrom 5:CatDateTo 6:PipeDateFrom 7:PipeDateTo 8:VenDateFrom
/// 9:VenDateTo 10:InfFlag 11:RepUser 12:RepStatus 13:FirstDate 14:InfDate 15:Pathogenic
Method ToString(separete As %String) As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
		} 
	set return=..%Id()_separete
	set return=return_..InfAimRepDR_separete
	set return=return_..BornWeight_separete
	set return=return_..CatDateFrom_separete
	set return=return_..CatDateTo_separete
	set return=return_..PipeDateFrom_separete
	set return=return_..PipeDateTo_separete
	set return=return_..VenDateFrom_separete
	set return=return_..VenDateTo_separete
	set return=return_..InfFlag_separete
	set return=return_..RepUser_separete
	set return=return_..RepStatus_separete
	set return=return_..FirstDate_separete
	set return=return_..InfDate_separete
	set return=return_..Pathogenic_separete
	
	
	set return=return_..PipeInfFlag_separete
	set return=return_..PipeInfDate_separete
	set return=return_..PipePathogenic_separete
	set return=return_..VenInfFlag_separete
	set return=return_..VenInfDate_separete
	set return=return_..VenPathogenic
	
	quit return
}

/// Creator：     liuyh
/// CreatDate：   2011-10-18
/// Description:  根据ID取NICU报告表 对象
/// Table：       DHCMed.InfAim.NICU
/// Input：       ID:    DHCMed.InfAim.NICU.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.InfAim.NICU).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.InfAim.NICU
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.InfAim.NICU).%ExistsId(+id) return
	set obj=##Class(DHCMed.InfAim.NICU).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     liuyh
/// CreatDate：   2011-10-18
/// Description:  根据ID取NICU报告表 信息
/// Table：       DHCMed.InfAim.NICU
/// Input：       id: DHCMed.InfAim.NICU.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.InfAim.NICU).GetStringById(1)
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
/// Description:  更新NICU报告表 
/// Table：       DHCMed.InfAim.NICU
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
ClassMethod Update(InStr As %String) As %String
{
	New (InStr)
	Set return=-1
	
	Set $ZT="UpdateErr"
	Set ID=$p(InStr,"^",1)
	If ID="" {
		Set obj=##class(DHCMed.InfAim.NICU).%New()
	}Else{
		Set obj=##class(DHCMed.InfAim.NICU).%OpenId(ID)
		Quit:'$IsObject(obj) return
	}
	Set obj.InfAimRepDR=$p(InStr,"^",2)
	Set obj.BornWeight=$p(InStr,"^",3)
	Set obj.CatDateFrom=$p(InStr,"^",4)
	Set obj.CatDateTo=$p(InStr,"^",5)
	Set obj.PipeDateFrom=$p(InStr,"^",6)
	Set obj.PipeDateTo=$p(InStr,"^",7)
	Set obj.VenDateFrom=$p(InStr,"^",8)
	Set obj.VenDateTo=$p(InStr,"^",9)
	Set obj.InfFlag=$p(InStr,"^",10)
	Set obj.RepUser=$p(InStr,"^",11)
	Set obj.RepStatus=$p(InStr,"^",12)
	Set obj.FirstDate=$p(InStr,"^",13)
	Set obj.InfDate=$p(InStr,"^",14)
	Set obj.Pathogenic=$p(InStr,"^",15)
	
	
	Set obj.PipeInfFlag=$p(InStr,"^",16)
	Set obj.PipeInfDate=$p(InStr,"^",17)
	Set obj.PipePathogenic=$p(InStr,"^",18)
	Set obj.VenInfFlag=$p(InStr,"^",19)
	Set obj.VenInfDate=$p(InStr,"^",20)
	Set obj.VenPathogenic=$p(InStr,"^",21)
	
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
/// Description:  删除NICU报告表 
/// Table：       DHCMed.InfAim.NICU
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id As %String) As %String
{
	new (Id)
	set sc = ##class(DHCMed.InfAim.NICU).%DeleteId(+Id)
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
<Data name="NICUDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BornWeight</Value>
</Value>
<Value name="3">
<Value>CatDateFrom</Value>
</Value>
<Value name="4">
<Value>CatDateTo</Value>
</Value>
<Value name="5">
<Value>FirstDate</Value>
</Value>
<Value name="6">
<Value>InfAimRepDR</Value>
</Value>
<Value name="7">
<Value>InfFlag</Value>
</Value>
<Value name="8">
<Value>PipeDateFrom</Value>
</Value>
<Value name="9">
<Value>PipeDateTo</Value>
</Value>
<Value name="10">
<Value>RepStatus</Value>
</Value>
<Value name="11">
<Value>RepUser</Value>
</Value>
<Value name="12">
<Value>VenDateFrom</Value>
</Value>
<Value name="13">
<Value>VenDateTo</Value>
</Value>
<Value name="14">
<Value>InfDate</Value>
</Value>
<Value name="15">
<Value>Pathogenic</Value>
</Value>
<Value name="16">
<Value>PipeInfFlag</Value>
</Value>
<Value name="17">
<Value>PipeInfDate</Value>
</Value>
<Value name="18">
<Value>PipePathogenic</Value>
</Value>
<Value name="19">
<Value>VenInfFlag</Value>
</Value>
<Value name="20">
<Value>VenInfDate</Value>
</Value>
<Value name="21">
<Value>VenPathogenic</Value>
</Value>
</Data>
<DataLocation>^DHCMed.InfAim.NICUD</DataLocation>
<DefaultData>NICUDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.InfAim.NICUD</IdLocation>
<IndexLocation>^DHCMed.InfAim.NICUI</IndexLocation>
<StreamLocation>^DHCMed.InfAim.NICUS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
