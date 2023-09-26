/// 名称: DHCMed.EPD.CasesX
/// 描述: 传染病例筛查日志
/// 编写者：zhufei
/// 编写日期: 2014-06-19
Class DHCMed.EPD.CasesX Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 筛查明细
Relationship ChildDtl As DHCMed.EPD.CasesXDtl [ Cardinality = children, Inverse = Parref ];

/// 主题配置代码（固定代码：EPDCC）
Property CXSubjectCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = CX_SubjectCode ];

/// 就诊号
Property CXEpisodeID As %String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = CX_EpisodeID ];

/// 发生日期
Property CXActDate As %Date [ SqlColumnNumber = 4, SqlFieldName = CX_ActDate ];

/// 结果日期
Property CXRstDate As %Date [ SqlColumnNumber = 18, SqlFieldName = CX_RstDate ];

/// 触发科室
Property CXActLoc As %String [ SqlColumnNumber = 5, SqlFieldName = CX_ActLoc ];

/// 触发诊断
Property CXActDiagnos As %String(MAXLEN = 500) [ SqlColumnNumber = 6, SqlFieldName = CX_ActDiagnos ];

/// 初诊A、复诊R
Property CXIsReAdm As %String [ SqlColumnNumber = 7, SqlFieldName = CX_IsReAdm ];

/// 关联监控结果
Property CXLnkResults As %String(MAXLEN = 200) [ SqlColumnNumber = 8, SqlFieldName = CX_LnkResults ];

/// 传染病（-1未处置、1确诊、0排除）
Property CXEpdStatus As %String [ SqlColumnNumber = 9, SqlFieldName = CX_EpdStatus ];

/// 确诊诊断(指向DHCMed.EPD.Infection)
Property CXEpdDiagnos As %String(MAXLEN = 200) [ SqlColumnNumber = 10, SqlFieldName = CX_EpdDiagnos ];

/// 处置意见
Property CXOpinion As %String(MAXLEN = 500) [ SqlColumnNumber = 11, SqlFieldName = CX_Opinion ];

/// 评价日期
Property CXEvalDate As %Date [ SqlColumnNumber = 12, SqlFieldName = CX_EvalDate ];

/// 评价时间
Property CXEvalTime As %Time [ SqlColumnNumber = 13, SqlFieldName = CX_EvalTime ];

/// 评价科室
Property CXEvalLoc As %String [ SqlColumnNumber = 14, SqlFieldName = CX_EvalLoc ];

/// 评价人
Property CXEvalUser As %String [ SqlColumnNumber = 15, SqlFieldName = CX_EvalUser ];

/// 是否有效
Property CXIsActive As %Boolean [ SqlColumnNumber = 16, SqlFieldName = CX_IsActive ];

/// 备注
Property CXResume As %String(MAXLEN = 500) [ SqlColumnNumber = 17, SqlFieldName = CX_Resume ];

/// 复诊 初诊A、复诊R
Property CXIsReVis As %String [ SqlColumnNumber = 19, SqlFieldName = CX_IsReVis ];

/// 携带 1:携带 2：非携带
Property CXIsCarry As %String [ SqlColumnNumber = 20, SqlFieldName = CX_IsCarry ];

/// 网报 1:网报 2:未网报
Property CXIsDecla As %String [ SqlColumnNumber = 21, SqlFieldName = CX_IsDecla ];

/// 备注列
Property CXRemark As %String [ SqlColumnNumber = 22, SqlFieldName = CX_Remark ];

Index IndexSubjectActDate On (CXSubjectCode As Exact, CXActDate As Exact);

Index IndexSubjectEvalDate On (CXSubjectCode As Exact, CXEvalDate As Exact);

Index IndexSubjectPaadm On (CXSubjectCode As Exact, CXEpisodeID As Exact);

Index IndexEpdStatusDate On (CXSubjectCode As Exact, CXEpdStatus As Exact, CXActDate As Exact);

/// add by pylian 2016-03-03 新增索引每天只有一条数据
Index IndexSubjectDateAdm On (CXSubjectCode As Exact, CXActDate As Exact, CXEpisodeID As Exact);

/// add by zf 2019-01-24 一次就诊同一诊断只有一条传染病诊断
Index IndexEpisActDiagnos On (CXSubjectCode As Exact, CXEpisodeID As Exact, CXActDiagnos);

/// add by pylian 2019-02-12 
Index IndexSubjectRstDate On (CXSubjectCode As Exact, CXRstDate As Exact);

/// Creator：     zhufei
/// CreatDate：   2014-06-19
/// Description:  根据ID取传染病例筛查日志
/// Table：       DHCMed.EPD.CasesX
/// Input：       ID:    DHCMed.EPD.CasesX.ID
///               separete: 指定的分隔符
/// Return：      返回Object
/// w ##class(DHCMed.EPD.CasesX).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.EPD.CasesX
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.EPD.CasesX).%ExistsId(+id) return
	set obj=##Class(DHCMed.EPD.CasesX).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-06-19
/// Description:  更新传染病例筛查日志
/// Table：       DHCMed.EPD.CasesX
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMed.EPD.CasesX).Update("^EPDCC^27^","^")
ClassMethod Update(InStr As %String, separete As %String) As %String
{
	new (InStr,separete)
	set return=0
	quit:InStr="" return
	
	set:$g(separete)="" separete=..#SEPARATE
	set ID          = $p(InStr,separete,1)
	set SubjectCode = $p(InStr,separete,2)
	set EpisodeID   = $p(InStr,separete,3)
	set ActDate     = $p(InStr,separete,4)
	//set:ActDate["-" ActDate=$zdh(ActDate,3)
	Set ActDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(ActDate)
	set ActLoc      = $p(InStr,separete,5)
	set ActDiagnos  = $p(InStr,separete,6)
	set IsReAdm     = $p(InStr,separete,7)
	set LnkResults  = $p(InStr,separete,8)
	set EpdStatus   = $p(InStr,separete,9)
	set EpdDiagnos  = $p(InStr,separete,10)
	set Opinion     = $p(InStr,separete,11)
	set EvalDate    = $p(InStr,separete,12)
	set:EvalDate="" EvalDate=+$h
	set EvalTime    = $p(InStr,separete,13)
	set:EvalTime="" EvalTime=$p($h,",",2)
	set EvalLoc     = $p(InStr,separete,14)
	set EvalUser    = $p(InStr,separete,15)
	set IsActive    = +$p(InStr,separete,16)
	set Resume      = $p(InStr,separete,17)
	set RstDate     = $p(InStr,separete,18)
	Set RstDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(RstDate)
	set IsReVis     = $p(InStr,separete,19)
	set IsCarry     = $p(InStr,separete,20)
	set IsDecla     = $p(InStr,separete,21)
	set Remark      = $p(InStr,separete,22)
	quit:(SubjectCode="")||(EpisodeID="")||(ActDate="")||(RstDate="") return
	
	if ID="" {
		set obj=##class(DHCMed.EPD.CasesX).%New()
	}else{
		set obj=##class(DHCMed.EPD.CasesX).%OpenId(ID)
	}
	quit:'$IsObject(obj) return
	
	set obj.CXSubjectCode  = SubjectCode
	set obj.CXEpisodeID    = EpisodeID
	set obj.CXActDate      = ActDate
	set obj.CXActLoc       = ActLoc
	set obj.CXActDiagnos   = ActDiagnos
	set obj.CXIsReAdm      = IsReAdm
	set obj.CXLnkResults   = LnkResults
	set obj.CXEpdStatus    = EpdStatus
	set obj.CXEpdDiagnos   = EpdDiagnos
	set obj.CXOpinion      = Opinion
	set obj.CXEvalDate     = EvalDate
	set obj.CXEvalTime     = EvalTime
	set obj.CXEvalLoc      = EvalLoc
	set obj.CXEvalUser     = EvalUser
	set obj.CXIsActive     = IsActive
	set obj.CXResume       = Resume
	set obj.CXRstDate      = RstDate
	set obj.CXIsReVis	   = IsReVis
	set obj.CXIsCarry	   = IsCarry
	set obj.CXIsDecla	   = IsDecla
	set obj.CXRemark	   = Remark
	
	set sc=obj.%Save()
	if $system.Status.IsError(sc) {        //检查Save是否成功
   		do $system.OBJ.DisplayError(sc) 
   		set return=-1
	}else{
		set return=obj.%Id()
	}
	do obj.%Close()
	
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-06-19
/// Description:  删除传染病例筛查日志
/// Table：       DHCMed.EPD.CasesX
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	new (Id)
	set sc = ##class(DHCMed.EPD.CasesX).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc)
   		set ret=-1
	}else{
		set ret=0
	}
	quit ret
}

/// Creator：     zhufei
/// CreatDate：   2014-07-01
/// Description:  传染病筛查处置
/// Table：       DHCMed.EPD.CasesX
/// Input：       aInputStr   : 1记录ID，2处置状态(0排除/1确诊)，3传染病确诊诊断，4处置意见，5科室，6用户
/// Return：      return>0:成功  return<1:失败
/// w ##class(DHCMed.EPD.CasesX).UpdateCasesXHandle("")
ClassMethod UpdateCasesXHandle(aInputStr As %String) As %String
{
	new (aInputStr)
	set return=0
	quit:(aInputStr="") return
	
	set RecordID=$p(aInputStr,"^",1)
	set EpdStatus=+$p(aInputStr,"^",2)
	set EpdDiagnos=$p(aInputStr,"^",3)
	//update by pylian 20160229 参数位置与portal传入不一致
	set EvalLocID=$p(aInputStr,"^",4)
	set EvalUserID=$p(aInputStr,"^",5)
	set Opinion=$p(aInputStr,"^",6)
	quit:(EpdStatus'=0)&&(EpdStatus'=1) return
	quit:(RecordID="")||(EpdDiagnos="") return
	
	set obj=##class(DHCMed.EPD.CasesX).%OpenId(RecordID)
	quit:'$IsObject(obj) return
	
	set obj.CXEpdStatus    = EpdStatus
	set obj.CXEpdDiagnos   = EpdDiagnos
	set obj.CXOpinion      = Opinion
	set obj.CXEvalDate     = +$h
	set obj.CXEvalTime     = $p($h,",",2)
	set obj.CXEvalLoc      = EvalLocID
	set obj.CXEvalUser     = EvalUserID
	set sc=obj.%Save()
	if $system.Status.IsError(sc) {        //检查Save是否成功
   		do $system.OBJ.DisplayError(sc) 
   		set return=-1
	}else{
		set return=obj.%Id()
	}
	do obj.%Close()
	
	quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CXSubjectCode</Value>
</Value>
<Value name="3">
<Value>CXEpisodeID</Value>
</Value>
<Value name="4">
<Value>CXActDate</Value>
</Value>
<Value name="5">
<Value>CXActLoc</Value>
</Value>
<Value name="6">
<Value>CXActDiagnos</Value>
</Value>
<Value name="7">
<Value>CXIsReAdm</Value>
</Value>
<Value name="8">
<Value>CXLnkResults</Value>
</Value>
<Value name="9">
<Value>CXEpdStatus</Value>
</Value>
<Value name="10">
<Value>CXEpdDiagnos</Value>
</Value>
<Value name="11">
<Value>CXOpinion</Value>
</Value>
<Value name="12">
<Value>CXEvalDate</Value>
</Value>
<Value name="13">
<Value>CXEvalTime</Value>
</Value>
<Value name="14">
<Value>CXEvalLoc</Value>
</Value>
<Value name="15">
<Value>CXEvalUser</Value>
</Value>
<Value name="16">
<Value>CXIsActive</Value>
</Value>
<Value name="17">
<Value>CXResume</Value>
</Value>
<Value name="18">
<Value>CXRstDate</Value>
</Value>
<Value name="19">
<Value>CXIsReVis</Value>
</Value>
<Value name="20">
<Value>CXIsCarry</Value>
</Value>
<Value name="21">
<Value>CXIsDecla</Value>
</Value>
<Value name="22">
<Value>CXRemark</Value>
</Value>
</Data>
<DataLocation>^DHCMed.EPD("CasesX")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.EPD("CasesX")</IdLocation>
<IndexLocation>^DHCMed.EPDi("CasesX")</IndexLocation>
<StreamLocation>^DHCMed.EPD.CasesXS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
