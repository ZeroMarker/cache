/// 名称: DHCMed.InfAim.Pipe
/// 描述: 导管相关性报告表
/// 编写者：liuyh
/// 编写日期: 2011-10-18
Class DHCMed.InfAim.Pipe Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 报告表ID 指向 目标性监测报告表：DHCMed_InfAim.Report
Property InfAimRepDR As %Integer [ Required ];

/// 入ICU诊断
Property InICUDiag As %String;

/// 置管日期
Property PipeDate As %Integer;

/// 拔管日期
Property OutPipeDate As %Integer;

/// 置管方位 指向字典表：DHCMed.SS.Dictionary   Code：PipePos
Property PipePos As %Integer;

/// 置管类型 指向字典表：DHCMed.SS.Dictionary   Code：PipeType
Property PipeType As %Integer;

/// 置管部位 指向字典表：DHCMed.SS.Dictionary   Code：PipeRegion
Property PipeRegion As %Integer;

/// 置管大小 指向字典表：DHCMed.SS.Dictionary   Code：PipeSize
Property PipeSize As %Integer;

/// 置管腔数 指向字典表：DHCMed.SS.Dictionary   Code：PipeNum
Property PipeNum As %Integer;

/// 置管地点 指向字典表：DHCMed.SS.Dictionary   Code：PipePlace
Property PipePlace As %Integer;

/// 拔管原因
Property OutPipeReason As %Integer;

/// 是否感染 指向字典表：DHCMed.SS.Dictionary   Code：YesNo
Property InfFlag As %Integer;

/// 报告人 指向SS_User
Property RepUser As %Integer;

/// 当前状态 指向字典表：DHCMed.SS.Dictionary   Code：RepStatus
Property RepStatus As %Integer;

/// 初次报告时间
Property FirstDate As %Integer;

/// 感染时间
Property InfDate As %Integer;

/// 置管人员
Property PipeUser As %Integer;

/// 病原菌
Property Pathogenic As %String;

Index InfAimRepDR On InfAimRepDR;

/// Creator：     liuyh
/// CreatDate：   2011-10-18
/// Description:  将对象格式化为字符串
/// Table：       DHCMed.InfAim.Pipe
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
/// 1:Rowid 2:InfAimRepDR 3:InICUDiag 4:PipeDate 5:OutPipeDate 6:PipePos 7:PipeType 8:PipeRegion
/// 9:PipeSize 10:PipeNum 11:PipePlace 12:OutPipeReason 13:InfFlag 14:RepUser 15:RepStatus 16:FirstDate
/// 17:InfDate 18:PipeUser 19:Pathogenic
Method ToString(separete As %String) As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
		} 
	set return=..%Id()_separete
	set return=return_..InfAimRepDR_separete
	set return=return_..InICUDiag_separete
	set return=return_..PipeDate_separete
	set return=return_..OutPipeDate_separete
	set return=return_..PipePos_separete
	set return=return_..PipeType_separete
	set return=return_..PipeRegion_separete
	set return=return_..PipeSize_separete
	set return=return_..PipeNum_separete
	set return=return_..PipePlace_separete
	set return=return_..OutPipeReason_separete
	set return=return_..InfFlag_separete
	set return=return_..RepUser_separete
	set return=return_..RepStatus_separete
	set return=return_..FirstDate_separete
	set return=return_..InfDate_separete
	set return=return_..PipeUser_separete
	set return=return_..Pathogenic
	quit return
}

/// Creator：     liuyh
/// CreatDate：   2011-10-18
/// Description:  根据ID取导管相关性报告表对象
/// Table：       DHCMed.InfAim.Pipe
/// Input：       ID:    DHCMed.InfAim.Pipe.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.InfAim.Pipe).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.InfAim.Pipe
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.InfAim.Pipe).%ExistsId(+id) return
	set obj=##Class(DHCMed.InfAim.Pipe).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     liuyh
/// CreatDate：   2011-10-18
/// Description:  根据ID取导管相关性报告表信息
/// Table：       DHCMed.InfAim.Pipe
/// Input：       id: DHCMed.InfAim.Pipe.ID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.InfAim.Pipe).GetStringById(1)
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
/// Description:  更新导管相关性报告表
/// Table：       DHCMed.InfAim.Pipe
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
ClassMethod Update(InStr As %String) As %String
{
	New (InStr)
	Set return=-1
	
	Set $ZT="UpdateErr"
	Set ID=$p(InStr,"^",1)
	If ID="" {
		Set obj=##class(DHCMed.InfAim.Pipe).%New()
	}Else{
		Set obj=##class(DHCMed.InfAim.Pipe).%OpenId(ID)
		Quit:'$IsObject(obj) return
	}
	Set obj.InfAimRepDR=$p(InStr,"^",2)
	Set obj.InICUDiag=$p(InStr,"^",3)
	Set obj.PipeDate=$p(InStr,"^",4)
	Set obj.OutPipeDate=$p(InStr,"^",5)
	Set obj.PipePos=$p(InStr,"^",6)
	Set obj.PipeType=$p(InStr,"^",7)
	Set obj.PipeRegion=$p(InStr,"^",8)
	Set obj.PipeSize=$p(InStr,"^",9)
	Set obj.PipeNum=$p(InStr,"^",10)
	Set obj.PipePlace=$p(InStr,"^",11)
	Set obj.OutPipeReason=$p(InStr,"^",12)
	Set obj.InfFlag=$p(InStr,"^",13)
	Set obj.RepUser=$p(InStr,"^",14)
	Set obj.RepStatus=$p(InStr,"^",15)
	Set obj.FirstDate=$p(InStr,"^",16)
	Set obj.InfDate=$p(InStr,"^",17)
	Set obj.PipeUser=$p(InStr,"^",18)
	Set obj.Pathogenic=$p(InStr,"^",19)
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
/// Description:  删除导管相关性报告表
/// Table：       DHCMed.InfAim.Pipe
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id As %String) As %String
{
	new (Id)
	set sc = ##class(DHCMed.InfAim.Pipe).%DeleteId(+Id)
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
<Data name="PipeDefaultData">
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
<Value>InICUDiag</Value>
</Value>
<Value name="16">
<Value>OutPipeDate</Value>
</Value>
<Value name="17">
<Value>OutPipeReason</Value>
</Value>
<Value name="18">
<Value>PipeDate</Value>
</Value>
<Value name="19">
<Value>PipeNum</Value>
</Value>
<Value name="20">
<Value>PipePlace</Value>
</Value>
<Value name="21">
<Value>PipePos</Value>
</Value>
<Value name="22">
<Value>PipeRegion</Value>
</Value>
<Value name="23">
<Value>PipeSize</Value>
</Value>
<Value name="24">
<Value>PipeType</Value>
</Value>
<Value name="25">
<Value>InfDate</Value>
</Value>
<Value name="26">
<Value>PipeUser</Value>
</Value>
<Value name="27">
<Value>Pathogenic</Value>
</Value>
</Data>
<DataLocation>^DHCMed.InfAim.PipeD</DataLocation>
<DefaultData>PipeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.InfAim.PipeD</IdLocation>
<IndexLocation>^DHCMed.InfAim.PipeI</IndexLocation>
<StreamLocation>^DHCMed.InfAim.PipeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
