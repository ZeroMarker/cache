/// 名称: DHCHAI.IR.OutLabReportResult
/// 描述: 外院携带多耐检验结果
/// 编写者：zhoubo
/// 编写日期: 2022-08-11
Class DHCHAI.IR.OutLabReport Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 就诊记录
Property LabEpisodeDr As DHCHAI.DP.PAAdm [ Required ];

/// 检验医嘱
Property TestSetDr As DHCHAI.DP.LabTestSetMap [ Required ];

/// 送检标本
Property SpecimenDr As DHCHAI.DP.LabSpecimen [ Required ];

/// 病原体1
Property BacteriaDr As DHCHAI.DP.LabBacteria;

/// 多耐分类1
Property RuleMRBDr As DHCHAI.IR.CRuleMRB;

/// 病原体2
Property BacteriaDr2 As DHCHAI.DP.LabBacteria;

/// 多耐分类2
Property RuleMRBDr2 As DHCHAI.IR.CRuleMRB;

/// 送检日期
Property SubmissDate As %Date;

/// 送检病区
Property LabWardDr As DHCHAI.BT.Location;

/// 报告日期
Property LabAuthDate As %Date;

/// 是否有效
Property LabIsActive As %Boolean;

/// 更新日期
Property LabUpdateDate As %Date;

/// 更新时间
Property LabUpdateTime As %Time;

/// 送检科室
Property LabLocDr As DHCHAI.BT.Location;

/// 细菌感染类型
Property LabMakeInfType As %String(MAXLEN = 100, TRUNCATE = 1);

/// 就诊记录索引
Index IndexEpisodeDr On LabEpisodeDr;

/// 送检日期索引
Index IndexSubmissDate On SubmissDate;

/// 报告日期索引
Index IndexLabAuthDate On LabAuthDate;

/// 接收日期时间索引 唯一索引
Index IndexEpiTestSpecDr On (LabEpisodeDr, TestSetDr, SpecimenDr, SubmissDate);

/// Creator：     zhoubo
/// CreatDate：   2022-08-11
/// Description:  获取
/// Table：       DHCHAI.IR.OutLabReport
/// Input：       aId : DHCHAI.IR.OutLabReport.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IR.OutLabReport).GetObjById(795)
ClassMethod GetObjById(aId As %String) As DHCHAI.IR.OutLabReport
{
	New (aId)
	Quit:'##class(DHCHAI.IR.OutLabReport).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.IR.OutLabReport).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhoubo
/// CreatDate：   2022-08-17
/// Description:  更新检验结果感染类型
/// Table：       DHCHAI.IR.OutLabReport
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.OutLabReport).Update("")
ClassMethod UpdateInfType(aID As %String, aMakeInfType As %String) As %String
{
	New (aID,aMakeInfType)
	Quit:aID="" return
	Set obj=##class(DHCHAI.IR.OutLabReport).%OpenId(aID)
	Quit:'$IsObject(obj) return

	Set obj.LabMakeInfType=aMakeInfType

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

/// Creator：     zhoubo
/// CreatDate：   2022-08-11
/// Description:  更新
/// Table：       DHCHAI.IR.OutLabReport
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.OutLabReport).Update("","^")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID		      = $p(aInputStr,aSeparete,1)
	Set LabEpisodeDr  = $p(aInputStr,aSeparete,2)
	Set TestSetDr     = $p(aInputStr,aSeparete,3)
	Set SpecimenDr    = $p(aInputStr,aSeparete,4)
	Set BacteriaDr    = $p(aInputStr,aSeparete,5)
	Set RuleMRBDr     = $p(aInputStr,aSeparete,6)
	Set BacteriaDr2   = $p(aInputStr,aSeparete,7)
	Set RuleMRBDr2    = $p(aInputStr,aSeparete,8)
	Set SubmissDate   = $p(aInputStr,aSeparete,9)
	Set LabWardDr     = $p(aInputStr,aSeparete,10)
	Set LabAuthDate   = $p(aInputStr,aSeparete,11)
	Set LabIsActive   = +$p(aInputStr,aSeparete,12)
	Set LabLocDr      = $p(aInputStr,aSeparete,13)
	Set LabMakeInfType= $p(aInputStr,aSeparete,14)
	Set:SubmissDate="" SubmissDate=+$h
	Quit:(LabEpisodeDr="")||(TestSetDr="")||(SpecimenDr="") return
	
	Set:SubmissDate'="" SubmissDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(SubmissDate)
	Set:LabAuthDate'="" LabAuthDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(LabAuthDate)
	Set LabUpdateDate=+$h
	Set LabUpdateTime=$p($h,",",2)
	Set objAdm=##class(DHCHAI.DP.PAAdm).GetObjById(LabEpisodeDr)
	Quit:objAdm="" return
	Quit:'$IsObject(objAdm.PAAdmWardDr) return
	Set objWard   = objAdm.PAAdmWardDr
	Set objLoc    = objAdm.PAAdmLocDr
	Set objTest   = ##class(DHCHAI.DP.LabTestSetMap).GetObjById(TestSetDr)
	Quit:objTest="" return
	Set objSpecimen = ##class(DHCHAI.DP.LabSpecimen).GetObjById(SpecimenDr)
	Quit:objSpecimen="" return
	Set objBact   = ##class(DHCHAI.DP.LabBacteria).GetObjById(BacteriaDr)
	Set objMRB    = ##class(DHCHAI.IR.CRuleMRB).GetObjById(RuleMRBDr)
	Set objBact2  = ##class(DHCHAI.DP.LabBacteria).GetObjById(BacteriaDr2)
	Set objMRB2   = ##class(DHCHAI.IR.CRuleMRB).GetObjById(RuleMRBDr2)
	
	Set:ID="" ID=$o(^DHCHAI.IR.OutLabReportI("IndexEpiTestSpecDr",LabEpisodeDr,TestSetDr,SpecimenDr,SubmissDate,0))
	If ID="" {
		Set obj=##class(DHCHAI.IR.OutLabReport).%New()
	}Else{
		Set obj=##class(DHCHAI.IR.OutLabReport).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.LabEpisodeDr  = objAdm
	Set obj.TestSetDr     = objTest
	Set obj.SpecimenDr    = objSpecimen
	Set obj.BacteriaDr    = objBact
	Set obj.RuleMRBDr     = objMRB
	Set obj.BacteriaDr2   = objBact2
	Set obj.RuleMRBDr2    = objMRB2
	Set obj.SubmissDate   = SubmissDate
	Set obj.LabWardDr     = objWard
	Set obj.LabAuthDate   = LabAuthDate
	Set obj.LabIsActive   = LabIsActive
	Set obj.LabUpdateDate = LabUpdateDate
	Set obj.LabUpdateTime = LabUpdateTime
	Set obj.LabLocDr      = objLoc
	Set:obj.LabMakeInfType="" obj.LabMakeInfType= LabMakeInfType
	
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

/// Creator：     zhoubo
/// CreatDate：   2022-08-11
/// Description:  删除
/// Table：       DHCHAI.IR.OutLabReport
/// Input：       aId : DHCHAI.IR.OutLabReport.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.IR.OutLabReport).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.IR.OutLabReport).%DeleteId(aId)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=0
	}
	Quit return
}

Storage Default
{
<Data name="OutLabReportDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LabEpisodeDr</Value>
</Value>
<Value name="3">
<Value>TestSetDr</Value>
</Value>
<Value name="4">
<Value>SpecimenDr</Value>
</Value>
<Value name="5">
<Value>BacteriaDr</Value>
</Value>
<Value name="6">
<Value>RuleMRBDr</Value>
</Value>
<Value name="7">
<Value>BacteriaDr2</Value>
</Value>
<Value name="8">
<Value>RuleMRBDr2</Value>
</Value>
<Value name="9">
<Value>SubmissDate</Value>
</Value>
<Value name="10">
<Value>LabWardDr</Value>
</Value>
<Value name="11">
<Value>LabAuthDate</Value>
</Value>
<Value name="12">
<Value>LabIsActive</Value>
</Value>
<Value name="13">
<Value>LabUpdateDate</Value>
</Value>
<Value name="14">
<Value>LabUpdateTime</Value>
</Value>
<Value name="15">
<Value>LabLocDr</Value>
</Value>
<Value name="16">
<Value>LabMakeInfType</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.IR.OutLabReportD</DataLocation>
<DefaultData>OutLabReportDefaultData</DefaultData>
<IdLocation>^DHCHAI.IR.OutLabReportD</IdLocation>
<IndexLocation>^DHCHAI.IR.OutLabReportI</IndexLocation>
<StreamLocation>^DHCHAI.IR.OutLabReportS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
