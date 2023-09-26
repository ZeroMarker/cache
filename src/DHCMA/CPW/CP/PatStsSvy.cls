/// 名称: DHCMA.CPW.CP.PatStsSvy
/// 描述: 患者满意度调查
/// 编写者：yankai
/// 编写日期: 2021-12-14
Class DHCMA.CPW.CP.PatStsSvy Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 子表调查明细
Relationship ChildDtl As DHCMA.CPW.CP.PatStsSvyDtl [ Cardinality = children, Inverse = Parref ];

/// 就诊ID（DHCMA.Util.EP.Episode.OID）
Property SSEpisodeID As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

/// 出入径记录
Property SSPathwayDr As DHCMA.CPW.CP.Pathway [ Required ];

/// 就诊科室（指向DHCMA.Util.EP.Location.OID）
Property SSAdmLocID As %String [ Required ];

/// 调查总得分
Property SSTotalScore As %Integer;

/// 调查表指针
Property SSQuestionDr As DHCMA.CPW.BT.Survey;

/// 更新科室（指向DHCMA.Util.EP.Location.OID）
Property SSLocID As %String;

/// 更新用户（指向DHCMA.Util.EP.SSUser.OID）
Property SSUserID As %String;

/// 更新日期
Property SSActDate As %Date;

/// 更新时间
Property SSActTime As %Time;

Index IdxofCPWSurvey On (SSPathwayDr, SSQuestionDr) [ Unique ];

Index IdxofEpisodeID On SSEpisodeID;

Index IdxofEpSurvey On (SSEpisodeID, SSQuestionDr);

Index IdxofActDate On SSActDate;

/// w ##class(DHCMA.CPW.CP.PatStsSvy).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.CPW.CP.PatStsSvy
{
	New (aId)
	Quit:'##class(DHCMA.CPW.CP.PatStsSvy).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.CP.PatStsSvy).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.CPW.CP.PatStsSvy).Update("^899!!1^6!!1^70^SurQuestion^334!!1^9!!1")   
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	Set ^zqy77=aInputStr
	Set ID       	 = $p(aInputStr,aSeparete,1)       ///获取数据（表的字段）
	Set EpisodeID    = $p(aInputStr,aSeparete,2)		//
	Set AdmLocID     = $p(aInputStr,aSeparete,3)		//科室
	Set TotalScore   = $p(aInputStr,aSeparete,4)		//得分
	Set QuestionDr   = $p(aInputStr,aSeparete,5)		//调查表指针
	Set LocID   	 = $p(aInputStr,aSeparete,6)		//科室
	Set UserID   	 = $p(aInputStr,aSeparete,7)		//用户
	
	If ID="" {                                  				//根据ID判断是添加还是修改
		Set obj=##class(DHCMA.CPW.CP.PatStsSvy).%New()
	}Else{
		Set obj=##class(DHCMA.CPW.CP.PatStsSvy).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	Set Pathway=$o(^DHCMA.CPW.CP.PathwayI("IdxofEpisodeID",EpisodeID,""),-1)
	Quit:Pathway="" -1
	Set ObjPathway=##class(DHCMA.CPW.CP.Pathway).GetObjById(Pathway)
	Quit:'$IsObject(ObjPathway) -2
	Set Sur=##class(DHCMA.CPW.BT.Survey).CheckSQCode(QuestionDr)
	Quit:Sur=0 return
	Set ObjSur=##class(DHCMA.CPW.BT.Survey).GetObjById(Sur)
	b ;1
	Quit:'$IsObject(ObjSur) -3
	
	Set obj.SSEpisodeID			= EpisodeID      //写入数据
	Set obj.SSPathwayDr			= ObjPathway
	Set obj.SSAdmLocID			= AdmLocID
	Set obj.SSTotalScore		= TotalScore
	Set obj.SSQuestionDr		= ObjSur
	Set obj.SSLocID				= LocID
	Set obj.SSUserID			= UserID
	Set obj.SSActDate			= +$h
	Set obj.SSActTime			= $p($h,",",2)
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

/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.CPW.CP.PatStsSvy).DeleteById(3)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	
	Set sc = ##class(DHCMA.CPW.CP.PatStsSvy).%DeleteId(aId)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=0
	}
	Quit return
}

/// Return：      成功：返回>0，失败：0
/// w ##class(DHCMA.CPW.CP.PatStsSvy).GetPatSts("895!!1","SurQuestion")
ClassMethod GetPatSts(EpisodeID As %String, Code As %String) As %String
{
	New (EpisodeID,Code)
	Set return=0
	Quit:(EpisodeID="")||(Code="") return
	Set SurID=##class(DHCMA.CPW.BT.Survey).CheckSQCode(Code)
	If ($d(^DHCMA.CPW.CP.PatStsSvyI("IdxofEpSurvey"," "_EpisodeID,SurID)))
	{
		Set ID=$o(^DHCMA.CPW.CP.PatStsSvyI("IdxofEpSurvey"," "_EpisodeID,SurID,""),-1)
		Set:ID'=0 return=ID
	}else{
		set return=0
	}
	Quit return
}

/// w ##class(DHCMA.CPW.CP.PatStsSvy).GetScore("38")
ClassMethod GetScore(aId As %String) As %String
{
	New (aId)
	Set return=0
	Quit:aId="" return
	Set obj=..GetObjById(aId)
	Quit:'$IsObject(obj) return
	Set return=obj.SSTotalScore
	Set:return="" return=0
	Quit return
}

Storage Default
{
<Data name="PatStsSvyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SSEpisodeID</Value>
</Value>
<Value name="3">
<Value>SSPathwayDr</Value>
</Value>
<Value name="4">
<Value>SSAdmLocID</Value>
</Value>
<Value name="5">
<Value>SSTotalScore</Value>
</Value>
<Value name="6">
<Value>SSQuestionDr</Value>
</Value>
<Value name="7">
<Value>SSLocID</Value>
</Value>
<Value name="8">
<Value>SSUserID</Value>
</Value>
<Value name="9">
<Value>SSActDate</Value>
</Value>
<Value name="10">
<Value>SSActTime</Value>
</Value>
</Data>
<DataLocation>^DHCMA.CPW.CP.PatStsSvyD</DataLocation>
<DefaultData>PatStsSvyDefaultData</DefaultData>
<IdLocation>^DHCMA.CPW.CP.PatStsSvyD</IdLocation>
<IndexLocation>^DHCMA.CPW.CP.PatStsSvyI</IndexLocation>
<StreamLocation>^DHCMA.CPW.CP.PatStsSvyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
