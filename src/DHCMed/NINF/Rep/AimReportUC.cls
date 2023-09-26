/// 名称: DHCMed.NINF.Rep.AimReportUC
/// 描述: 目标性监测报告 导尿管
/// 编写者：zhufei
/// 编写日期: 2012-05-26
Class DHCMed.NINF.Rep.AimReportUC Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

Relationship ParRef As DHCMed.NINF.Rep.AimReport [ Cardinality = parent, Inverse = ChildUC ];

/// 置管日期
Property IntubateDate As %Date;

/// 置管时间
Property IntubateTime As %Time;

/// 拔管日期
Property ExtubateDate As %Date;

/// 拔管时间
Property ExtubateTime As %Time;

/// 尿袋类型("NINFAimUCUrineBagType")
Property UrineBagType As DHCMed.SS.Dictionary;

/// 置管人员类型("NINFAimUCIntubateUserType")
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

/// 置管日期索引
Index IndexIntubateDate On (IntubateDate As Exact, ParRef As Exact);

/// 拔管日期索引
Index IndexExtubateDate On (ExtubateDate As Exact, ParRef As Exact);

/// 报告日期索引
Index IndexRepDate On (RepDate As Exact, ParRef As Exact);

/// 报告科室+日期+时间索引
Index IndexRepLocDate On (RepLoc As Exact, RepDate As Exact, RepTime As Exact, ParRef As Exact);

/// 报告状态+日期+时间索引
Index IndexRepStatusDate On (RepStatus As Exact, RepDate As Exact, RepTime As Exact, ParRef As Exact);

/// Creator：     zhufei
/// CreatDate：   2012-05-26
/// Description:  取目标性监测报告 导尿管
/// Table：       DHCMed.NINF.Rep.AimReportUC
/// Input：       DHCMed.NINF.Rep.AimReportUC.ID
/// Return：      返回obj
/// w ##class(DHCMed.NINF.Rep.AimReportUC).GetObjById("1||3")
ClassMethod GetObjById(aId As %String) As DHCMed.NINF.Rep.AimReportUC
{
	New (aId)
	Set obj=##Class(DHCMed.NINF.Rep.AimReportUC).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2012-05-26
/// Description:  更新目标性监测报告 导尿管
/// Table：       DHCMed.NINF.Rep.AimReportUC
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.NINF.Rep.AimReportUC).Update()
ClassMethod Update(aInput As %String, aSeparate As %String = "") As %String
{
	 
	New (aInput,aSeparate)
	Set return=0
	Set:aSeparate="" aSeparate=..#SEPARATE
	
	Set ParRef=$p(aInput,aSeparate,1)
	Set ChildSub=$p(aInput,aSeparate,2)
	If (ChildSub="") {
		Set obj=##class(DHCMed.NINF.Rep.AimReportUC).%New()
		Set obj.ParRef=##class(DHCMed.NINF.Rep.AimReport).GetObjById(ParRef)
	} Else {
		Set obj=##class(DHCMed.NINF.Rep.AimReportUC).%OpenId(ParRef_"||"_ChildSub)
	}
	Quit:'$IsObject(obj) return
	Quit:'$IsObject(obj.ParRef) return
	
	//置管日期、置管时间、拔管日期、拔管时间、尿管类型、置管人员
	Set obj.IntubateDate=$p(aInput,aSeparate,3)
	Set obj.IntubateTime=$p(aInput,aSeparate,4)
	Set obj.ExtubateDate=$p(aInput,aSeparate,5)
	Set obj.ExtubateTime=$p(aInput,aSeparate,6)
	Set UrineBagTypeID=$p(aInput,aSeparate,7)
	Set obj.UrineBagType=##class(DHCMed.SS.Dictionary).GetObjById(UrineBagTypeID)
	Set IntubateUserType=$p(aInput,aSeparate,8)
	Set obj.IntubateUserType=##class(DHCMed.SS.Dictionary).GetObjById(IntubateUserType)
	Set obj.IntubateUser=$p(aInput,aSeparate,9)
	
	//感染日期、病原体
	Set obj.InfDate=$p(aInput,aSeparate,10)
	While (obj.InfPathogeny.Count()>0) {
		Do obj.InfPathogeny.RemoveAt(1)
	}
	Set InfPyList=$p(aInput,aSeparate,11)
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
	Set obj.RepLoc=$p(aInput,aSeparate,12)
	Set obj.RepUser=$p(aInput,aSeparate,13)
	Set obj.RepDate=$p(aInput,aSeparate,14)
	Set obj.RepTime=$p(aInput,aSeparate,15)
	Set RepStatusID=$p(aInput,aSeparate,16)
	Set obj.RepStatus=##class(DHCMed.SS.Dictionary).GetObjById(RepStatusID)
	
	Set UpdateLog=$p(aInput,aSeparate,17)
	
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
		
		//更新日志
		Set ParRef=+return
		Set UpdateLog=ParRef_","_"UC"_","_UpdateLog
		Set flg=##Class(DHCMed.NINF.Rep.AimReportLog).Update(UpdateLog,",")
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2012-05-26
/// Description:  删除目标性监测报告 导尿管
/// Table：       DHCMed.NINF.Rep.AimReportUC
/// Input：       DHCMed.NINF.Rep.AimReportUC.ID
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.NINF.Rep.AimReportUC).DeleteById("1||3")
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCMed.NINF.Rep.AimReportUC).%DeleteId(aId)
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
/// Description:  更新目标性监测报告 导尿管
/// Table：       DHCMed.NINF.Rep.AimReportUC
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.NINF.Rep.AimReportUC).UpdateStatus()
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
	
	Set obj=##class(DHCMed.NINF.Rep.AimReportUC).%OpenId(RowID)
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
		Set ReportLog=ParRef_","_"UC"_","_LocID_","_UserID_","_StatusID
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
<Value>UrineBagType</Value>
</Value>
<Value name="7">
<Value>IntubateUserType</Value>
</Value>
<Value name="8">
<Value>IntubateUser</Value>
</Value>
<Value name="9">
<Value>InfDate</Value>
</Value>
<Value name="10">
<Value>InfPathogeny</Value>
</Value>
<Value name="11">
<Value>RepLoc</Value>
</Value>
<Value name="12">
<Value>RepUser</Value>
</Value>
<Value name="13">
<Value>RepDate</Value>
</Value>
<Value name="14">
<Value>RepTime</Value>
</Value>
<Value name="15">
<Value>RepStatus</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("UC")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("UC")</IdLocation>
<IndexLocation>^DHCMed.NINFi("AimRep",0,"UC")</IndexLocation>
<StreamLocation>^DHCMed.NINF.Rep.AimReportUCS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
