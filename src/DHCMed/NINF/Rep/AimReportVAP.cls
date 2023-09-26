/// 名称: DHCMed.NINF.Rep.AimReportVAP
/// 描述: 目标性监测报告 呼吸机
/// 编写者：zhufei
/// 编写日期: 2012-06-05
Class DHCMed.NINF.Rep.AimReportVAP Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

Relationship ParRef As DHCMed.NINF.Rep.AimReport [ Cardinality = parent, Inverse = ChildVAP ];

/// 上机日期
Property IntubateDate As %Date;

/// 上机时间
Property IntubateTime As %Time;

/// 脱机日期
Property ExtubateDate As %Date;

/// 脱机时间
Property ExtubateTime As %Time;

/// 置管地点("NINFAimVAPIntubatePlace")
Property IntubatePlace As DHCMed.SS.Dictionary;

/// 置管类型("NINFAimVAPIntubateType")
Property IntubateType As DHCMed.SS.Dictionary;

/// 置管人员类型("NINFAimVAPIntubateUserType")
Property IntubateUserType As DHCMed.SS.Dictionary;

/// 置管人员 指向SS_User
Property IntubateUser As %String(TRUNCATE = 1);

/// 感染日期
Property InfDate As %Date;

/// 病原菌
Property InfPathogeny As list Of DHCMed.NINF.Rep.AimReportPy;

/// 报告科室 指向CT_Loc
Property RepLoc As %String(TRUNCATE = 1);

/// 报告人员 指向SS_User
Property RepUser As %String(TRUNCATE = 1);

/// 报告日期
Property RepDate As %Date;

/// 报告时间
Property RepTime As %Time;

/// 报告状态("NINFAimReportStatus")
Property RepStatus As DHCMed.SS.Dictionary;

/// 上机日期索引
Index IndexIntubateDate On (IntubateDate As Exact, ParRef As Exact);

/// 脱机日期索引
Index IndexExtubateDate On (ExtubateDate As Exact, ParRef As Exact);

/// 报告日期索引
Index IndexRepDate On (RepDate As Exact, ParRef As Exact);

/// 报告科室+日期+时间索引
Index IndexRepLocDate On (RepLoc As Exact, RepDate As Exact, RepTime As Exact, ParRef As Exact);

/// 报告状态+日期+时间索引
Index IndexRepStatusDate On (RepStatus As Exact, RepDate As Exact, RepTime As Exact, ParRef As Exact);

/// Creator：     zhufei
/// CreatDate：   2012-06-05
/// Description:  取目标性监测报告 呼吸机
/// Table：       DHCMed.NINF.Rep.AimReportVAP
/// Input：       DHCMed.NINF.Rep.AimReportVAP.ID
/// Return：      返回obj
/// w ##class(DHCMed.NINF.Rep.AimReportVAP).GetObjById("1||3")
ClassMethod GetObjById(aId As %String) As DHCMed.NINF.Rep.AimReportVAP
{
	New (aId)
	Set obj=##Class(DHCMed.NINF.Rep.AimReportVAP).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2012-06-05
/// Description:  更新目标性监测报告 呼吸机
/// Table：       DHCMed.NINF.Rep.AimReportVAP
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.NINF.Rep.AimReportVAP).Update()
ClassMethod Update(aInput As %String, aSeparate As %String = "") As %String
{
	 
	New (aInput,aSeparate)
	Set return=0
	Set:aSeparate="" aSeparate=..#SEPARATE
	
	Set ParRef=$p(aInput,aSeparate,1)
	Set ChildSub=$p(aInput,aSeparate,2)
	If (ChildSub="") {
		Set obj=##class(DHCMed.NINF.Rep.AimReportVAP).%New()
		Set obj.ParRef=##class(DHCMed.NINF.Rep.AimReport).GetObjById(ParRef)
	} Else {
		Set obj=##class(DHCMed.NINF.Rep.AimReportVAP).%OpenId(ParRef_"||"_ChildSub)
	}
	Quit:'$IsObject(obj) return
	Quit:'$IsObject(obj.ParRef) return
	
	//上机日期、上机时间、脱机日期、脱机时间、置管地点、置管人员、置管类型
	Set obj.IntubateDate=$p(aInput,aSeparate,3)
	Set obj.IntubateTime=$p(aInput,aSeparate,4)
	Set obj.ExtubateDate=$p(aInput,aSeparate,5)
	Set obj.ExtubateTime=$p(aInput,aSeparate,6)
	Set IntubatePlaceID=$p(aInput,aSeparate,7)
	Set obj.IntubatePlace=##class(DHCMed.SS.Dictionary).GetObjById(IntubatePlaceID)
	Set IntubateUserType=$p(aInput,aSeparate,8)
	Set obj.IntubateUserType=##class(DHCMed.SS.Dictionary).GetObjById(IntubateUserType)
	Set obj.IntubateUser=$p(aInput,aSeparate,9)
	Set IntubateTypeID=$p(aInput,aSeparate,10)
	Set obj.IntubateType=##class(DHCMed.SS.Dictionary).GetObjById(IntubateTypeID)
	
	//感染日期、病原体
	Set obj.InfDate=$p(aInput,aSeparate,11)
	While (obj.InfPathogeny.Count()>0) {
		Do obj.InfPathogeny.RemoveAt(1)
	}
	Set InfPyList=$p(aInput,aSeparate,12)
	Set InfPyLB=""
	For indPy=1:1:$length(InfPyList,$c(2)) {
		Set InfPy=$p(InfPyList,$c(2),indPy)
		Continue:($listfind(InfPyLB,InfPy)>0)
		Set InfPyLB=InfPyLB_$lb(InfPy)
		Set objInfPy=##class(DHCMed.NINF.Rep.AimReportPy).GetObj(InfPy,$c(3))
		Continue:'$IsObject(objInfPy)
		Do obj.InfPathogeny.Insert(objInfPy)
	}
	
	//报告科室、报告人、报告日期、报告时间
	Set obj.RepLoc=$p(aInput,aSeparate,13)
	Set obj.RepUser=$p(aInput,aSeparate,14)
	Set obj.RepDate=$p(aInput,aSeparate,15)
	Set obj.RepTime=$p(aInput,aSeparate,16)
	Set RepStatusID=$p(aInput,aSeparate,17)
	Set obj.RepStatus=##class(DHCMed.SS.Dictionary).GetObjById(RepStatusID)
	
	Set UpdateLog=$p(aInput,aSeparate,18)
	
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
		
		//更新日志
		Set ParRef=+return
		Set UpdateLog=ParRef_","_"VAP"_","_UpdateLog
		Set flg=##Class(DHCMed.NINF.Rep.AimReportLog).Update(UpdateLog,",")
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2012-06-05
/// Description:  删除目标性监测报告 呼吸机
/// Table：       DHCMed.NINF.Rep.AimReportVAP
/// Input：       DHCMed.NINF.Rep.AimReportVAP.ID
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.NINF.Rep.AimReportVAP).DeleteById("1||3")
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCMed.NINF.Rep.AimReportVAP).%DeleteId(aId)
	If $System.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2012-05-26
/// Description:  更新目标性监测报告 呼吸机
/// Table：       DHCMed.NINF.Rep.AimReportVAP
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.NINF.Rep.AimReportVAP).UpdateStatus()
ClassMethod UpdateStatus(aInput As %String, aSeparate As %String) As %String
{
	New (aInput,aSeparate)
	Set return=0
	Set:aSeparate="" aSeparate=..#SEPARATE
	
	Set RowID=$p(aInput,aSeparate,1)
	Set LocID=$p(aInput,aSeparate,2)
	Set UserID=$p(aInput,aSeparate,3)
	Set StatusID=$p(aInput,aSeparate,4)
	Set objStatus=##class(DHCMed.SS.Dictionary).GetObjById(StatusID)
	Quit:'$IsObject(objStatus) return
	
	Set obj=##class(DHCMed.NINF.Rep.AimReportVAP).%OpenId(RowID)
	Quit:'$IsObject(obj) return
	Set obj.RepStatus=objStatus
	
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=1
		
		//更新日志
		Set ParRef=+RowID
		Set ReportLog=ParRef_","_"VAP"_","_LocID_","_UserID_","_StatusID
		Set flg=##Class(DHCMed.NINF.Rep.AimReportLog).Update(ReportLog,",")
	}
	Do obj.%Close()
	
	Quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IntubateDate</Value>
</Value>
<Value name="3">
<Value>IntubateTime</Value>
</Value>
<Value name="4">
<Value>ExtubateDate</Value>
</Value>
<Value name="5">
<Value>ExtubateTime</Value>
</Value>
<Value name="6">
<Value>IntubatePlace</Value>
</Value>
<Value name="7">
<Value>IntubateType</Value>
</Value>
<Value name="8">
<Value>IntubateUserType</Value>
</Value>
<Value name="9">
<Value>IntubateUser</Value>
</Value>
<Value name="10">
<Value>InfDate</Value>
</Value>
<Value name="11">
<Value>InfPathogeny</Value>
</Value>
<Value name="12">
<Value>RepLoc</Value>
</Value>
<Value name="13">
<Value>RepUser</Value>
</Value>
<Value name="14">
<Value>RepDate</Value>
</Value>
<Value name="15">
<Value>RepTime</Value>
</Value>
<Value name="16">
<Value>RepStatus</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("VAP")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("VAP")</IdLocation>
<IndexLocation>^DHCMed.NINFi("AimRep",0,"VAP")</IndexLocation>
<StreamLocation>^DHCMed.NINF.Rep.AimReportVAPS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
