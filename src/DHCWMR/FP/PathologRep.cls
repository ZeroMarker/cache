/// 病理报告列表
Class DHCWMR.FP.PathologRep Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 就诊号
Property PREpisodeID As %String(MAXLEN = 100, TRUNCATE = 1);

/// 病理号
Property PRNumber As %String(MAXLEN = 100, TRUNCATE = 1);

/// 报告ID
Property PRReportID As %String(MAXLEN = 100, TRUNCATE = 1);

/// 报告日期
Property PRRepDate As %Date;

/// 报告时间
Property PRRepTime As %Time;

/// 报告人(SS_User.ID)
Property PRRepUser As %Time;

/// 病理诊断
Property PRDiagnos As %String(MAXLEN = 500, TRUNCATE = 1);

/// 是否编码
Property PRIsCoding As %Boolean;

/// 编码日期
Property PRCodDate As %Date;

/// 编码时间
Property PRCodTime As %Time;

/// 编码人(SS_User.ID)
Property PRCodUser As %String(MAXLEN = 100, TRUNCATE = 1);

/// 报告日期 + 是否编目 索引
Index IndexOnIsCodeRepDate On (PRIsCoding, PRRepDate);

/// 编码日期 索引
Index IndexOnCodDate On PRCodDate;

/// 就诊号 + 报告ID 索引
Index IndexOnEpisodeReportID On (PREpisodeID, PRReportID);

/// Creator：     liyi
/// CreatDate：   2015-11-26
/// Description:  取病理报告表
/// Table：       DHCWMR.FP.PathologRep
/// Input：       Id : DHCWMR.FP.PathologRep.ID
/// Return：      返回Object
/// w ##class(DHCWMR.FP.PathologRep).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCWMR.FP.PathologRep
{
	new (aId)
	quit:'##class(DHCWMR.FP.PathologRep).%ExistsId(aId) ""
	set obj=##Class(DHCWMR.FP.PathologRep).%OpenId(aId)
	do:obj'="" obj.%Close()
	quit obj
}

/// Creator：     liyi
/// CreatDate：   2015-11-26
/// Description:  更新病理报告
/// Table：       DHCWMR.FP.PathologRep
/// Input：       InputStr ：ID^编目类型,诊断/手术标记,首页诊断/手术ICD10^首页诊断/手术名称^编目诊断/手术ICD10^编目诊断/手术名称^生成日期^生成时间^编码员^审核日期^审核时间^审核人^是否有效^备注
///               Separate : 分隔符
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCWMR.FP.PathologRep).Update("","^")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	Set ID			= $p(aInputStr,aSeparate,1)
	Set EpisodeID 	= $p(aInputStr,aSeparate,2)
	Set Number 		= $p(aInputStr,aSeparate,3)
	Set ReportID 	= $p(aInputStr,aSeparate,4)
	Set RepDate 	= $p(aInputStr,aSeparate,5)
	set:RepDate["-" RepDate=$zdh(RepDate,3)
	set:RepDate["/" RepDate=$zdh(RepDate,4)
	Set RepTime 	= $p(aInputStr,aSeparate,6)
	set:RepTime[":" RepTime=$zth(RepTime,1)
	Set RepUser 	= $p(aInputStr,aSeparate,7)
	Set Diagnos 	= $p(aInputStr,aSeparate,8)
	Set IsCoding 	= $p(aInputStr,aSeparate,9)
	Set CodDate 	= $p(aInputStr,aSeparate,10)
	set:CodDate["-" CodDate=$zdh(CodDate,3)
	set:CodDate["/" CodDate=$zdh(CodDate,4)
	Set CodTime 	= $p(aInputStr,aSeparate,11)
	set:CodTime[":" CodTime=$zth(CodTime,1)
	Set CodUser 	= $p(aInputStr,aSeparate,12)

	Quit:(EpisodeID="")||(Number="")||(ReportID="")||(RepDate="")||(RepTime="")||(RepUser="")||(Diagnos="") return
	
	If ID="" {
		Set obj=##class(DHCWMR.FP.PathologRep).%New()
	} Else {
		Set obj=##class(DHCWMR.FP.PathologRep).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.PREpisodeID = EpisodeID
	Set obj.PRNumber 	= Number
	Set obj.PRReportID 	= ReportID
	Set obj.PRRepDate 	= RepDate
	Set obj.PRRepTime 	= RepTime
	Set obj.PRRepUser 	= RepUser
	Set obj.PRDiagnos 	= Diagnos
	Set obj.PRIsCoding 	= IsCoding
	Set obj.PRCodDate 	= CodDate
	Set obj.PRCodTime 	= CodTime
	Set obj.PRCodUser 	= CodUser
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2015-11-26
/// Description:  删除病理报告
/// Table：       DHCWMR.FP.PathologRep
/// Input：       Id : DHCWMR.FP.PathologRep.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId As %String) As %String
{
	new (aId)
	set return=0
	quit:aId="" return
	set sc = ##class(DHCWMR.FP.PathologRep).%DeleteId(aId)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc)
   		set return=-1
	}else{
		set return=1
	}
	quit return
}

/// Creator：     liyi
/// CreatDate：   2015-11-26
/// Description:  病理编目
/// Table：       DHCWMR.FP.PathologRep
/// Input：       Id : DHCWMR.FP.PathologRep.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod Coding(aPathRepInfo As %String) As %String
{
	New (aPathRepInfo)
	Set return = 0
	Quit:aPathRepInfo="" return
	
	Set PathRepID = $p(aPathRepInfo,$c(1),1)
	Set CodUser = $p(aPathRepInfo,$c(1),2)
	Quit:(PathRepID="")||(CodUser="") return
	
	Set obj=##class(DHCWMR.FP.PathologRep).%OpenId(PathRepID)
	Quit:'$IsObject(obj) return
	
	Set obj.PRIsCoding  = 1
	Set obj.PRCodDate 	= +$h
	Set obj.PRCodTime 	= +($p($h,",",2))
	Set obj.PRCodUser 	= CodUser
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

Storage Default
{
<Data name="PathologRepDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PREpisodeID</Value>
</Value>
<Value name="3">
<Value>PRNumber</Value>
</Value>
<Value name="4">
<Value>PRReportID</Value>
</Value>
<Value name="5">
<Value>PRRepDate</Value>
</Value>
<Value name="6">
<Value>PRRepTime</Value>
</Value>
<Value name="7">
<Value>PRRepUser</Value>
</Value>
<Value name="8">
<Value>PRDiagnos</Value>
</Value>
<Value name="9">
<Value>PRIsCoding</Value>
</Value>
<Value name="10">
<Value>PRCodDate</Value>
</Value>
<Value name="11">
<Value>PRCodTime</Value>
</Value>
<Value name="12">
<Value>PRCodUser</Value>
</Value>
</Data>
<DataLocation>^DHCWMR.FP.PathologRepD</DataLocation>
<DefaultData>PathologRepDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWMR.FP.PathologRepD</IdLocation>
<IndexLocation>^DHCWMR.FP.PathologRepI</IndexLocation>
<StreamLocation>^DHCWMR.FP.PathologRepS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
