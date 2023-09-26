/// 名称: DHCMed.InfAim.Operation
/// 描述: 手术病人监测表
/// 编写者：liuyh
/// 编写日期: 2011-10-18
Class DHCMed.InfAim.Operation Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 报告表ID 指向 目标性监测报告表：DHCMed_InfAim.Report
Property InfAimRepDR As %Integer [ Required ];

/// 手术日期
Property OpeDate As %Integer;

/// 手术名称
Property OpeName As %String;

/// 手术时间(分钟)
Property OpeLastTime As %Integer;

/// 切口分类 指向字典表：DHCMed.SS.Dictionary   Code：OpeCutType
Property CutType As %Integer;

/// ASA评分
Property ASAScore As %Integer;

/// 急诊 指向字典表：DHCMed.SS.Dictionary   Code：YesNo
Property EmerOprFlag As %Integer;

/// 外伤 指向字典表：DHCMed.SS.Dictionary   Code：YesNo
Property Injury As %Integer;

/// 内镜 指向字典表：DHCMed.SS.Dictionary   Code：YesNo
Property Endoscopic As %Integer;

/// 第一术者 指向SS_User
Property FirstOpe As %Integer;

/// 一助 指向SS_User
Property AssistantDr1 As %Integer;

/// 麻醉诱导期用药1种类 
Property NarcosisDrug1 As %String;

/// 麻醉诱导期用药1数量
Property NarcosisNum1 As %String;

/// 麻醉诱导期用药2种类 
Property NarcosisDrug2 As %String;

/// 麻醉诱导期用药2数量
Property NarcosisNum2 As %String;

/// 术后预防性用药1种类
Property AftDrug1 As %String;

/// 术后预防性用药1数量
Property AftNum1 As %String;

/// 术后预防性用药1天数
Property AftDays1 As %String;

/// 术后预防性用药2种类
Property AftDrug2 As %String;

/// 术后预防性用药2数量
Property AftNum2 As %String;

/// 术后预防性用药2天数
Property AftDays2 As %String;

/// 是否感染 
Property InfFlag As %Integer;

/// 病原菌
Property Pathogenic As %String;

/// 报告人 指向SS_User
Property RepUser As %Integer;

/// 当前状态 指向字典表：DHCMed.SS.Dictionary   Code：RepStatus
Property RepStatus As %Integer;

/// 初次报告时间
Property FirstDate As %Integer;

/// 感染时间
Property InfDate As %Integer;

/// 麻醉诱导期用药
Property NarcosisDrug As %String;

/// 术后预防性用药
Property AftDrug As %String;

/// 麻醉方式 指向字典表：DHCMed.SS.Dictionary   Code：NarcosisType
Property NarcosisType As %String;

/// 感染类型 指向字典表：DHCMed.SS.Dictionary   Code：OpeInfType
Property OpeInfType As %String;

/// 备注
Property ResumeText As %String;

Index InfAimRepDR On InfAimRepDR;

/// Creator：     liuyh
/// CreatDate：   2011-10-18
/// Description:  将对象格式化为字符串
/// Table：       DHCMed.InfAim.Operation
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
/// 1:Rowid 2:InfAimRepDR 3:OpeDate 4:OpeName 5:OpeLastTime 6:CutType 7:ASAScore 8:EmerOprFlag
/// 9:Injury 10:Endoscopic 11:FirstOpe 12:AssistantDr1 13:NarcosisDrug1 14:NarcosisNum1 15:NarcosisDrug2 16:NarcosisNum2
/// 17:AftDrug1 18:AftNum1 19:AftDays1 20:AftDrug2 21:AftNum2 22:AftDays2 23:InfFlag 24:Object
/// 25:RepUser 26:RepStatus 27:FirstDate 28:InfDate 29:NarcosisDrug 30:AftDrug 31：NarcosisType 32：OpeInfType 33:ResumeText
Method ToString(separete As %String) As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
		} 
	set return=..%Id()_separete
	set return=return_..InfAimRepDR_separete
	set return=return_..OpeDate_separete
	set return=return_..OpeName_separete
	set return=return_..OpeLastTime_separete
	set return=return_..CutType_separete
	set return=return_..ASAScore_separete
	set return=return_..EmerOprFlag_separete
	set return=return_..Injury_separete
	set return=return_..Endoscopic_separete
	set return=return_..FirstOpe_separete
	set return=return_..AssistantDr1_separete
	set return=return_..NarcosisDrug1_separete
	set return=return_..NarcosisNum1_separete
	set return=return_..NarcosisDrug2_separete
	set return=return_..NarcosisNum2_separete	
	set return=return_..AftDrug1_separete
	set return=return_..AftNum1_separete
	set return=return_..AftDays1_separete
	set return=return_..AftDrug2_separete
	set return=return_..AftNum2_separete
	set return=return_..AftDays2_separete
	set return=return_..InfFlag_separete
	set return=return_..Pathogenic_separete
	set return=return_..RepUser_separete
	set return=return_..RepStatus_separete
	set return=return_..FirstDate_separete
	set return=return_..InfDate_separete
	set return=return_..NarcosisDrug_separete
	set return=return_..AftDrug_separete
	set return=return_..NarcosisType_separete
	set return=return_..OpeInfType_separete
	set return=return_..ResumeText
	
	quit return
}

/// Creator：     liuyh
/// CreatDate：   2011-10-18
/// Description:  根据ID取手术病人监测表对象
/// Table：       DHCMed.InfAim.Operation
/// Input：       ID:    DHCMed.InfAim.Operation.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.InfAim.Operation).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.InfAim.Operation
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.InfAim.Operation).%ExistsId(+id) return
	set obj=##Class(DHCMed.InfAim.Operation).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     liuyh
/// CreatDate：   2011-10-18
/// Description:  根据ID取手术病人监测表信息
/// Table：       DHCMed.InfAim.Operation
/// Input：       id: DHCMed.InfAim.Operation.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.InfAim.Operation).GetStringById(1)
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
/// Description:  更新手术病人监测表
/// Table：       DHCMed.InfAim.Operation
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
ClassMethod Update(InStr As %String) As %String
{
	New (InStr)
	Set return=-1
	
	Set $ZT="UpdateErr"
	Set ID=$p(InStr,"^",1)
	If ID="" {
		Set obj=##class(DHCMed.InfAim.Operation).%New()
	}Else{
		Set obj=##class(DHCMed.InfAim.Operation).%OpenId(ID)
		Quit:'$IsObject(obj) return
	}
	Set obj.InfAimRepDR=$p(InStr,"^",2)
	Set obj.OpeDate=$p(InStr,"^",3)
	Set obj.OpeName=$p(InStr,"^",4)
	Set obj.OpeLastTime=$p(InStr,"^",5)
	Set obj.CutType=$p(InStr,"^",6)
	Set obj.ASAScore=$p(InStr,"^",7)
	Set obj.EmerOprFlag=$p(InStr,"^",8)
	Set obj.Injury=$p(InStr,"^",9)
	Set obj.Endoscopic=$p(InStr,"^",10)
	Set obj.FirstOpe=$p(InStr,"^",11)
	Set obj.AssistantDr1=$p(InStr,"^",12)
	Set obj.NarcosisDrug1=$p(InStr,"^",13)
	Set obj.NarcosisNum1=$p(InStr,"^",14)
	Set obj.NarcosisDrug2=$p(InStr,"^",15)
	Set obj.NarcosisNum2=$p(InStr,"^",16)
	Set obj.AftDrug1=$p(InStr,"^",17)
	Set obj.AftNum1=$p(InStr,"^",18)
	Set obj.AftDays1=$p(InStr,"^",19)
	Set obj.AftDrug2=$p(InStr,"^",20)
	Set obj.AftNum2=$p(InStr,"^",21)
	Set obj.AftDays2=$p(InStr,"^",22)
	Set obj.InfFlag=$p(InStr,"^",23)
	Set obj.Pathogenic=$p(InStr,"^",24)
	Set obj.RepUser=$p(InStr,"^",25)
	Set obj.RepStatus=$p(InStr,"^",26)
	Set obj.FirstDate=$p(InStr,"^",27)
	Set obj.InfDate=$p(InStr,"^",28)
	Set obj.NarcosisDrug=$p(InStr,"^",29)
	Set obj.AftDrug=$p(InStr,"^",30)
	Set obj.NarcosisType=$p(InStr,"^",31)
	Set obj.OpeInfType=$p(InStr,"^",32)
	Set obj.ResumeText=$p(InStr,"^",33)
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
/// Description:  删除手术病人监测表
/// Table：       DHCMed.InfAim.Operation
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id As %String) As %String
{
	new (Id)
	set sc = ##class(DHCMed.InfAim.Operation).%DeleteId(+Id)
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
<Data name="OperationDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ASAScore</Value>
</Value>
<Value name="3">
<Value>AftDays1</Value>
</Value>
<Value name="4">
<Value>AftDays2</Value>
</Value>
<Value name="5">
<Value>AftDrug1</Value>
</Value>
<Value name="6">
<Value>AftDrug2</Value>
</Value>
<Value name="7">
<Value>AftNum1</Value>
</Value>
<Value name="8">
<Value>AftNum2</Value>
</Value>
<Value name="9">
<Value>AssistantDr1</Value>
</Value>
<Value name="10">
<Value>CutType</Value>
</Value>
<Value name="11">
<Value>EmerOprFlag</Value>
</Value>
<Value name="12">
<Value>Endoscopic</Value>
</Value>
<Value name="13">
<Value>FirstDate</Value>
</Value>
<Value name="14">
<Value>FirstOpe</Value>
</Value>
<Value name="15">
<Value>InfAimRepDR</Value>
</Value>
<Value name="16">
<Value>InfFlag</Value>
</Value>
<Value name="17">
<Value>Injury</Value>
</Value>
<Value name="18">
<Value>NarcosisDrug1</Value>
</Value>
<Value name="19">
<Value>NarcosisDrug2</Value>
</Value>
<Value name="20">
<Value>NarcosisNum1</Value>
</Value>
<Value name="21">
<Value>NarcosisNum2</Value>
</Value>
<Value name="22">
<Value>Object</Value>
</Value>
<Value name="23">
<Value>OpeDate</Value>
</Value>
<Value name="24">
<Value>OpeLastTime</Value>
</Value>
<Value name="25">
<Value>OpeName</Value>
</Value>
<Value name="26">
<Value>RepStatus</Value>
</Value>
<Value name="27">
<Value>RepUser</Value>
</Value>
<Value name="28">
<Value>AftDrug</Value>
</Value>
<Value name="29">
<Value>InfDate</Value>
</Value>
<Value name="30">
<Value>NarcosisDrug</Value>
</Value>
<Value name="31">
<Value>Pathogenic</Value>
</Value>
<Value name="32">
<Value>NarcosisType</Value>
</Value>
<Value name="33">
<Value>OpeInfType</Value>
</Value>
<Value name="34">
<Value>ResumeText</Value>
</Value>
</Data>
<DataLocation>^DHCMed.InfAim.OperationD</DataLocation>
<DefaultData>OperationDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.InfAim.OperationD</IdLocation>
<IndexLocation>^DHCMed.InfAim.OperationI</IndexLocation>
<StreamLocation>^DHCMed.InfAim.OperationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
