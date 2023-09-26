/// 名称: DHCHAI.IR.ASPProgram
/// 描述: 抗菌用药导向计划（ASP）处置意见
/// 编写者：zhufei
/// 编写日期: 2017-11-28
Class DHCHAI.IR.ASPProgram Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 就诊记录
Property IREpisodeDr As DHCHAI.DP.PAAdm;

/// 审核类型（1药师审核Phar、2专家审核Exper）
Property IRCheckType As %Integer;

/// 审核结果（0不合理、1合理、2需关注）
Property IRCheckResult As %Integer;

/// 审核日期
Property IRCheckDate As %Date;

/// 审核时间
Property IRCheckTime As %Time;

/// 审核人
Property IRCheckUserDr As DHCHAI.BT.SysUser;

/// 就诊记录索引
Index IndexIREpisodeDr On IREpisodeDr;

/// 就诊+类型索引
Index IndexEpisodeDrType On (IREpisodeDr, IRCheckType As Exact);

/// Creator：     mayanpeng
/// CreatDate：   2017-11-30
/// Description:  根据ID取抗菌用药处置意见表
/// Table：       DHCHAI.IR.ASPProgram
/// Input：       ID:    DHCHAI.IR.ASPProgram.ID
/// Return：      返回Object
/// w ##class(DHCHAI.IR.ASPProgram).GetObjById(1)
ClassMethod GetObjById(ID As %String) As DHCHAI.IR.ASPProgram
{
	New (ID)
	Set return=""
	Quit:ID="" return
	Quit:'##class(DHCHAI.IR.ASPProgram).%ExistsId(+ID) return
	
	Set obj=##Class(DHCHAI.IR.ASPProgram).%OpenId(+ID)
	Set return=obj
	Do obj.%Close()
	Quit return
}

/// Creator：     mayanpeng
/// CreatDate：   2017-12-04
/// Description:  更新抗菌用药处置意见表
/// Table：       DHCHAI.IR.ASPProgram
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.ASPProgram).Update("^1^^3^2333^1^1^^1^^^7935")
ClassMethod Update(InStr As %String, aSeparete As %String = "^") As %String
{
	New (InStr,aSeparete)
	Set return=0
	Quit:InStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID		 	= $p(InStr,aSeparete,1)
	Set EpisodeDr	= $p(InStr,aSeparete,2)
	Set CheckType	= $p(InStr,aSeparete,3)
	Set CheckResult	= $p(InStr,aSeparete,4)
	Set CheckDate	= $p(InStr,aSeparete,5)
	Set CheckTime	= $p(InStr,aSeparete,6)
	Set CheckUserDr	= $p(InStr,aSeparete,7)
	Quit:(EpisodeDr="")||(CheckType="")||(CheckResult="") return
	
	Set:CheckDate["-" CheckDate = $zdh(CheckDate,3)
	Set:CheckTime[":" CheckTime = $zth(CheckTime,1)
	Set:CheckDate="" CheckDate = +$h
	Set:CheckTime="" CheckTime = +($p($h,",",2))
	
	Set objEpisode = ##class(DHCHAI.DP.PAAdm).GetObjById(EpisodeDr)
	Quit:'$IsObject(objEpisode) return
	Set objCheckUser=""
	if CheckUserDr'=""{
		Set objCheckUser = ##class(DHCHAI.BT.SysUser).GetObjById(CheckUserDr)
		Quit:'$IsObject(objCheckUser) return
	}
	
	if ID="" {
		Set obj=##class(DHCHAI.IR.ASPProgram).%New()
	}else{
		Set obj=##class(DHCHAI.IR.ASPProgram).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.IREpisodeDr	= objEpisode
	Set obj.IRCheckType = CheckType
	Set obj.IRCheckResult = CheckResult
	Set obj.IRCheckDate	= CheckDate
	Set obj.IRCheckTime	= CheckTime
	Set obj.IRCheckUserDr = objCheckUser
	
	Set sc=obj.%Save()
	if $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set return=-1
	}else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     mayanpeng
/// CreatDate：   2017-12-04
/// Description:  根据ID删除抗菌用药处置意见表
/// Table：       DHCHAI.IR.ASPProgram
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id As %String) As %String
{
	New (Id)
	Set sc = ##class(DHCHAI.IR.ASPProgram).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set return=-1
	}else{
		Set return=0
	}
	Quit return
}

Storage Default
{
<Data name="ASPProgramDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IREpisodeDr</Value>
</Value>
<Value name="3">
<Value>IRAntiMastDr</Value>
</Value>
<Value name="4">
<Value>IRCheckType</Value>
</Value>
<Value name="5">
<Value>IRCheckResult</Value>
</Value>
<Value name="6">
<Value>IRCheckDate</Value>
</Value>
<Value name="7">
<Value>IRCheckTime</Value>
</Value>
<Value name="8">
<Value>IRCheckUserDr</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.IR.ASPProgramD</DataLocation>
<DefaultData>ASPProgramDefaultData</DefaultData>
<IdLocation>^DHCHAI.IR.ASPProgramD</IdLocation>
<IndexLocation>^DHCHAI.IR.ASPProgramI</IndexLocation>
<StreamLocation>^DHCHAI.IR.ASPProgramS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
