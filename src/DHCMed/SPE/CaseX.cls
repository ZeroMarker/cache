/// 名称: DHCMed.EPD.CasesX
/// 描述: 重点病人筛查日志
/// 编写者：zhufei
/// 编写日期: 2019-01-21
Class DHCMed.SPE.CaseX Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 就诊号（PA_Adm.ID）
Property CXEpisodeID As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 筛查条件
Property CXScreeningDr As DHCMed.SPE.Screening [ Required ];

/// 病人类型
Property CXPatTypeDr As DHCMed.SPE.PatTypeSub;

/// 日期
Property CXActDate As %Date;

/// 科室（CT_Loc.ID）
Property CXActLoc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 病区（CT_Loc.ID）
Property CXActWard As %String(MAXLEN = 100, TRUNCATE = 1);

/// 医生（CT_CareProv.ID）
Property CXActDoc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 状态（-1未处置、1确认、0排除）
Property CXStatus As %Integer [ Required ];

/// 处置意见
Property CXOpinion As %String(MAXLEN = 500, TRUNCATE = 1);

/// 评估日期
Property CXEvalDate As %Date;

/// 评估时间
Property CXEvalTime As %Time;

/// 评估科室（CT_Loc.ID）
Property CXEvalLoc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 评估人（SS_User.ID）
Property CXEvalUser As %String(MAXLEN = 100, TRUNCATE = 1);

/// 索引记录ID
Property CXResultID As %String(MAXLEN = 100, TRUNCATE = 1);

/// 标记记录ID
Property CXLnkPatID As %String(MAXLEN = 100, TRUNCATE = 1);

Index IndexResultID On (CXEpisodeID, CXScreeningDr, CXResultID) [ Unique ];

Index IndexEpisScreen On (CXEpisodeID, CXScreeningDr);

Index IndexScreenDate On (CXScreeningDr, CXActDate);

Index IndexLnkPatID On CXLnkPatID;

/// Creator：     liuzhenhe
/// CreatDate：   2019-01-22
/// Description:  根据ID取重点病人筛查日志
/// Table：       DHCMed.SPE.CaseX
/// Input：       aId :  DHCMed.SPE.CaseXt.ID
/// Return：      返回obj
/// w ##class(DHCMed.SPE.CaseX).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMed.SPE.CaseX
{
	New (aId)
	Quit:'##class(DHCMed.SPE.CaseX).%ExistsId(aId) ""
	Set obj=##Class(DHCMed.SPE.CaseX).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     liuzhenhe
/// CreatDate：   2019-01-22
/// Description:  删除重点病人筛查日志
/// Table：       DHCMed.SPE.CaseX
/// Input：       aId :  DHCMed.SPE.CaseX.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMed.SPE.CaseX).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCMed.SPE.CaseX).%DeleteId(aId)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=0
	}
	Quit return
}

/// Creator：     liuzhenhe
/// CreatDate：   2019-01-22
/// Description:  更新重点病人筛查日志
/// Table：       DHCMed.SPE.CaseX
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMed.SPE.CaseX).Update("^11^5^^65058^104^1^0^-1")   
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	Set:$g(aSeparete)="" aSeparete="^"  
	
	Set ID          =  	$p(aInputStr,aSeparete,1)
	Set EpisodeID   = 	$p(aInputStr,aSeparete,2)
	Set ScreeningDr = 	$p(aInputStr,aSeparete,3)
	Set PatTypeDr   = 	$p(aInputStr,aSeparete,4)
	Set ActDate  	= 	$p(aInputStr,aSeparete,5)
	Set ActLoc 	    = 	$p(aInputStr,aSeparete,6)
	Set ActWard     = 	$p(aInputStr,aSeparete,7)
	Set ActDoc      =   $p(aInputStr,aSeparete,8)
	Set ResultID    = 	$p(aInputStr,aSeparete,9)
	Set Status      =   $p(aInputStr,aSeparete,10)
	Set Opinion	    =   $p(aInputStr,aSeparete,11)
	Set EvalDate    = 	$p(aInputStr,aSeparete,12)
	Set EvalTime    = 	$p(aInputStr,aSeparete,13)
	Set EvalLoc	    = 	$p(aInputStr,aSeparete,14)
	Set EvalUser    = 	$p(aInputStr,aSeparete,15)
	Quit:(EpisodeID="")||(ScreeningDr="")||(ResultID="") return
	
	Set:Status="" Status="-1"
	
	Set objScreening=##class(DHCMed.SPE.Screening).GetObjById(ScreeningDr)
	Quit:'$IsObject(objScreening) return
	Set objPatType=##class(DHCMed.SPE.PatTypeSub).GetObjById(PatTypeDr)
	
	Set tID=$o(^DHCMed.SPE.CaseXI("IndexResultID"," "_$zcvt(EpisodeID,"U"),ScreeningDr," "_$zcvt(ResultID,"U"),""))
	Set:ID="" ID=tID
	Quit:(ID'="")&&(ID'=tID) return
	
	If ID="" {                                  //根据ID判断是添加还是修改
		Set obj=##class(DHCMed.SPE.CaseX).%New()
	}Else{
		Set obj=##class(DHCMed.SPE.CaseX).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.CXEpisodeID  = EpisodeID      //写入数据
	Set obj.CXScreeningDr= objScreening
	Set obj.CXPatTypeDr	 = objPatType
	Set obj.CXActDate    = ActDate
	Set obj.CXActLoc     = ActLoc
	Set obj.CXActWard    = ActWard
	Set obj.CXActDoc     = ActDoc
	Set obj.CXResultID   = ResultID
	Set obj.CXStatus 	 = Status
	Set obj.CXOpinion    = Opinion
	Set obj.CXEvalDate   = EvalDate
	Set obj.CXEvalTime   = EvalTime
	Set obj.CXEvalLoc    = EvalLoc
	Set obj.CXEvalUser   = EvalUser
	
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

Storage Default
{
<Data name="CaseXDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CXEpisodeID</Value>
</Value>
<Value name="3">
<Value>CXScreeningDr</Value>
</Value>
<Value name="4">
<Value>CXPatTypeDr</Value>
</Value>
<Value name="5">
<Value>CXActDate</Value>
</Value>
<Value name="6">
<Value>CXActLoc</Value>
</Value>
<Value name="7">
<Value>CXActWard</Value>
</Value>
<Value name="8">
<Value>CXActDoc</Value>
</Value>
<Value name="9">
<Value>CXStatus</Value>
</Value>
<Value name="10">
<Value>CXOpinion</Value>
</Value>
<Value name="11">
<Value>CXEvalDate</Value>
</Value>
<Value name="12">
<Value>CXEvalTime</Value>
</Value>
<Value name="13">
<Value>CXEvalLoc</Value>
</Value>
<Value name="14">
<Value>CXEvalUser</Value>
</Value>
<Value name="15">
<Value>CXResultID</Value>
</Value>
<Value name="16">
<Value>CXLnkPatID</Value>
</Value>
</Data>
<DataLocation>^DHCMed.SPE.CaseXD</DataLocation>
<DefaultData>CaseXDefaultData</DefaultData>
<IdLocation>^DHCMed.SPE.CaseXD</IdLocation>
<IndexLocation>^DHCMed.SPE.CaseXI</IndexLocation>
<StreamLocation>^DHCMed.SPE.CaseXS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
