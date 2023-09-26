/// 名称: DHCHAI.DP.RBReport
/// 描述: 检查报告
/// 编写者：liyi
/// 编写日期: 2017-01-16
Class DHCHAI.DP.RBReport Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 就诊记录
Property RBEpisodeDr As DHCHAI.DP.PAAdm [ Required ];

/// 检查号
Property RBStudyNo As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 状态（N未写报告、I已有图像、R已录入、V已审核、S已发布、D全科会诊）
Property RBChkStatus As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 检查项目
Property RBCheckItem As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 检查所见
Property RBExamDesc As %String(MAXLEN = 100000, TRUNCATE = 1);

/// 诊断意见
Property RBResultDesc As %String(MAXLEN = 100000, TRUNCATE = 1);

/// 登记日期
Property RBRegDate As %Date;

/// 登记时间
Property RBRegTime As %Time;

/// 登记人（ID|Code|Desc）
Property RBRegUser As %String(MAXLEN = 100, TRUNCATE = 1);

/// 报告日期
Property RBRepDate As %Date;

/// 报告时间
Property RBRepTime As %Time;

/// 报告医生（ID|Code|Desc）
Property RBRepUser As %String(MAXLEN = 100, TRUNCATE = 1);

/// 子系统代码
Property RBSCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 记录索引码
Property RBXCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 是否有效
Property RBIsActive As %Boolean [ Required ];

/// 更新日期
Property RBUpdateDate As %Date;

/// 更新时间
Property RBUpdateTime As %Time;

/// 子系统代码+记录索引码 索引
Index IndexSCodeXCode On (RBSCode As Exact, RBXCode As Exact);

/// 检验医嘱+审核日期索引
Index IndexChkItemRepDate On (RBSCode As Exact, RBCheckItem As Exact, RBRepDate);

/// 就诊+检验医嘱+审核日期索引
Index IndexEpisodeChkItemRepDate On (RBEpisodeDr, RBSCode As Exact, RBCheckItem As Exact, RBRepDate);

/// 就诊记录索引
Index IndexEpisodeDr On RBEpisodeDr;

/// 就诊记录+报告日期 索引
Index IndexEpisodeDrRepDate On (RBEpisodeDr, RBRepDate);

/// 更新日期 索引
Index IndexEpisUpdateDate On (RBEpisodeDr, RBUpdateDate);

/// Creator：     zhufei
/// CreatDate：   2018-03-10
/// Description:  根据ID作废检查报告
/// Table：       DHCHAI.DP.RBReport
/// Input：       id:    DHCHAI.DP.RBReport.ID
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DP.RBReport).CancelById(1)
ClassMethod CancelById(id As %String) As %String
{
	New (id)
	Set return=""
	Quit:id="" return
	
	Set obj=##class(DHCHAI.DP.RBReport).%OpenId(id)
	Quit:'$IsObject(obj) return
	Set obj.RBIsActive		= 0
	Set obj.RBUpdateDate    = +$h
	Set obj.RBUpdateTime    = $p($h,",",2)
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

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  根据ID取检查报告
/// Table：       DHCHAI.DP.RBReport
/// Input：       ID:    DHCHAI.DP.RBReport.ID
/// Return：      返回Object
/// w ##class(DHCHAI.DP.RBReport).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCHAI.DP.RBReport
{
	New (id)
	Set return=""
	Quit:id="" return
	Quit:'##class(DHCHAI.DP.RBReport).%ExistsId(+id) return
	
	Set obj=##Class(DHCHAI.DP.RBReport).%OpenId(+id)
	Set return=obj
	Do obj.%Close()
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-04-19
/// Description:  根据索引码取检查报告
/// Table：       DHCHAI.DP.RBReport
/// Input：       aSCode:DHCHAI.DP.RBReport.RBSCode
/// 				  aXCode:DHCHAI.DP.RBReport.RBXCode
/// Return：      返回Object
/// w ##class(DHCHAI.DP.RBReport).GetObjByXCode("EMR02","9225||1")
ClassMethod GetObjByXCode(aSCode As %String, aXCode As %String) As DHCHAI.DP.RBReport
{
	New (aSCode,aXCode)
	Set return=""
	Quit:(aSCode="")||(aXCode="") return
	
	Set id = $o(^DHCHAI.DP.RBReportI("IndexSCodeXCode",aSCode,aXCode,""))
	Quit:id="" return
	Set return=..GetObjById(id)
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  更新检查报告
/// Table：       DHCHAI.DP.RBReport
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DP.RBReport).Update("^93^87^S^常规心电图检查(18导联)^qwrr^qwrr^^^^64092^53867^郭江^RIS01^13984^64504^72452")
ClassMethod Update(InStr As %String, aSeparete As %String = "^") As %String
{
	New (InStr,aSeparete)
	Set return=0
	Quit:InStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID			= $p(InStr,aSeparete,1)
	Set EpisodeDr	= $p(InStr,aSeparete,2)
	Set StudyNo		= $p(InStr,aSeparete,3)
	Set ChkStatus	= $p(InStr,aSeparete,4)
	Set CheckItem	= $p(InStr,aSeparete,5)
	Set ExamDesc	= $p(InStr,aSeparete,6)
	Set ResultDesc	= $p(InStr,aSeparete,7)
	Set RegDate		= $p(InStr,aSeparete,8)
	Set RegTime		= $p(InStr,aSeparete,9)
	Set RegUser		= $p(InStr,aSeparete,10)
	Set RepDate		= $p(InStr,aSeparete,11)
	Set RepTime		= $p(InStr,aSeparete,12)
	Set RepUser		= $p(InStr,aSeparete,13)
	Set SCode		= $p(InStr,aSeparete,14)
	Set XCode		= $p(InStr,aSeparete,15)
	Set IsActive	= +$p(InStr,aSeparete,16)
	Set UpdateDate	= $p(InStr,aSeparete,17)
	Set UpdateTime	= $p(InStr,aSeparete,18)
	Set:RegDate["-" RegDate = $zdh(RegDate,3)
	Set:RegTime[":" RegTime = $zth(RegTime,1)
	Set:RepDate["-" RepDate = $zdh(RepDate,3)
	Set:RepTime[":" RepTime = $zth(RepTime,1)
	Quit:(EpisodeDr="")||(StudyNo="")||(ChkStatus="")||(CheckItem="") return
	Quit:(SCode="")||(XCode="") return
	
	Set objAdm = ##class(DHCHAI.DP.PAAdm).GetObjById(EpisodeDr)
	Quit:objAdm="" return
	
	//子系统代码+记录索引码 唯一性
	Set tID =$o(^DHCHAI.DP.RBReportI("IndexSCodeXCode",SCode,XCode,0)) 
	Quit:(tID'="")&(ID'=tID) -100 
	
	if ID="" {
		Set obj=##class(DHCHAI.DP.RBReport).%New()
	}else{
		Set obj=##class(DHCHAI.DP.RBReport).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.RBEpisodeDr	= objAdm
	Set obj.RBStudyNo	= StudyNo
	Set obj.RBChkStatus	= ChkStatus
	Set obj.RBCheckItem	= CheckItem
	Set obj.RBExamDesc	= ExamDesc
	Set obj.RBResultDesc= ResultDesc
	Set obj.RBRegDate	= RegDate
	Set obj.RBRegTime	= RegTime
	Set obj.RBRegUser	= RegUser
	Set obj.RBRepDate	= RepDate
	Set obj.RBRepTime	= RepTime
	Set obj.RBRepUser	= RepUser
	Set obj.RBSCode		= SCode
	Set obj.RBXCode		= XCode
	Set obj.RBIsActive  = IsActive
	Set obj.RBUpdateDate= +$h
	Set obj.RBUpdateTime= $p($h,",",2)
	
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

/// Creator：     liyi
/// CreatDate：   2017-01-17
/// Description:  删除检查报告
/// Table：       DHCHAI.DP.RBReport
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	New (Id)
	Set sc = ##class(DHCHAI.DP.RBReport).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set ret=-1
	}else{
		Set ret=0
	}
	Quit ret
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RBEpisodeDr</Value>
</Value>
<Value name="3">
<Value>RBStudyNo</Value>
</Value>
<Value name="4">
<Value>RBChkStatus</Value>
</Value>
<Value name="5">
<Value>RBCheckItem</Value>
</Value>
<Value name="6">
<Value>RBExamDesc</Value>
</Value>
<Value name="7">
<Value>RBResultDesc</Value>
</Value>
<Value name="8">
<Value>RBRegDate</Value>
</Value>
<Value name="9">
<Value>RBRegTime</Value>
</Value>
<Value name="10">
<Value>RBRegUser</Value>
</Value>
<Value name="11">
<Value>RBRepDate</Value>
</Value>
<Value name="12">
<Value>RBRepTime</Value>
</Value>
<Value name="13">
<Value>RBRepUser</Value>
</Value>
<Value name="14">
<Value>RBSCode</Value>
</Value>
<Value name="15">
<Value>RBXCode</Value>
</Value>
<Value name="16">
<Value>RBUpdateDate</Value>
</Value>
<Value name="17">
<Value>RBUpdateTime</Value>
</Value>
<Value name="18">
<Value>RBIsActive</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.DP.RBReportD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^DHCHAI.DP.RBReportD</IdLocation>
<IndexLocation>^DHCHAI.DP.RBReportI</IndexLocation>
<StreamLocation>^DHCHAI.DP.RBReportS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
