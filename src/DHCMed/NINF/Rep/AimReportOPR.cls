/// 名称: DHCMed.NINF.Rep.AimReportOPR
/// 描述: 目标性监测报告 手术部位
/// 编写者：zhufei
/// 编写日期: 2012-06-05
Class DHCMed.NINF.Rep.AimReportOPR Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

Relationship ParRef As DHCMed.NINF.Rep.AimReport [ Cardinality = parent, Inverse = ChildOPR ];

/// 手术 指向 ORC_Operation
Property OperationID As %String(TRUNCATE = 1);

/// 手术名称
Property OperationDesc As %String(TRUNCATE = 1);

/// 手术开始日期
Property OperStartDate As %Date;

/// 手术开始时间
Property OperStartTime As %Time;

/// 手术结束日期
Property OperEndDate As %Date;

/// 手术结束时间
Property OperEndTime As %Time;

/// 手术时间(分)
Property OperTimes As %Integer;

/// 切口分类("NINFAimOPRCutType")
Property OperCutType As DHCMed.SS.Dictionary;

/// ASA评分
Property OperASAScore As %Integer;

/// 麻醉方式("NINFAimOPRNarcosisType")
Property OperNarcosisType As DHCMed.SS.Dictionary;

/// 手术类型("NINFAimOPROperType")  急诊[是/否]
Property OperationType As DHCMed.SS.Dictionary;

/// 手术类型("NINFAimOPROperType1") 外伤[是/否]
Property OperationType1 As DHCMed.SS.Dictionary;

/// 手术类型("NINFAimOPROperType2") 内镜[是/否]
Property OperationType2 As DHCMed.SS.Dictionary;

/// 术者 指向SS_User
Property OperDoctor As %String(TRUNCATE = 1);

/// 一助 指向SS_User
Property Assistant1 As %String(TRUNCATE = 1);

/// 二助 指向SS_User
Property Assistant2 As %String(TRUNCATE = 1);

/// 麻醉诱导期用药
Property NarcosisAnti As list Of DHCMed.NINF.Rep.AimReportOPRAnti;

/// 术后预防性用药
Property PostoperAnti As list Of DHCMed.NINF.Rep.AimReportOPRAnti;

/// 感染日期
Property InfDate As %Date;

/// 病原菌
Property InfPathogeny As list Of DHCMed.NINF.Dic.Pathogeny;

/// 感染类型("NINFAimOPRInfType")
Property OperInfType As DHCMed.SS.Dictionary;

/// 备注
Property ResumeText As %String(TRUNCATE = 1);

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

/// 手术日期索引
Index IndexOperationDate On (OperStartDate As Exact, ParRef As Exact);

/// 报告日期索引
Index IndexRepDate On (RepDate As Exact, ParRef As Exact);

/// 报告科室+日期+时间索引
Index IndexRepLocDate On (RepLoc As Exact, RepDate As Exact, RepTime As Exact, ParRef As Exact);

/// 报告状态+日期+时间索引
Index IndexRepStatusDate On (RepStatus As Exact, RepDate As Exact, RepTime As Exact, ParRef As Exact);

/// Creator：     zhufei
/// CreatDate：   2012-06-05
/// Description:  取目标性监测报告 手术部位
/// Table：       DHCMed.NINF.Rep.AimReportOPR
/// Input：       DHCMed.NINF.Rep.AimReportOPR.ID
/// Return：      返回obj
/// w ##class(DHCMed.NINF.Rep.AimReportOPR).GetObjById("1||3")
ClassMethod GetObjById(aId As %String) As DHCMed.NINF.Rep.AimReportOPR
{
	New (aId)
	Set obj=##Class(DHCMed.NINF.Rep.AimReportOPR).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2012-06-05
/// Description:  更新目标性监测报告 手术部位
/// Table：       DHCMed.NINF.Rep.AimReportOPR
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.NINF.Rep.AimReportOPR).Update()
ClassMethod Update(aInput As %String, aSeparate) As %String
{
	 
	New (aInput,aSeparate)
	Set return=0
	Set:aSeparate="" aSeparate=..#SEPARATE
	
	Set ParRef=$p(aInput,aSeparate,1)
	Set ChildSub=$p(aInput,aSeparate,2)
	If (ChildSub="") {
		Set obj=##class(DHCMed.NINF.Rep.AimReportOPR).%New()
		Set obj.ParRef=##class(DHCMed.NINF.Rep.AimReport).GetObjById(ParRef)
	} Else {
		Set obj=##class(DHCMed.NINF.Rep.AimReportOPR).%OpenId(ParRef_"||"_ChildSub)
	}
	Quit:'$IsObject(obj) return
	Quit:'$IsObject(obj.ParRef) return
	
	//手术、手术名称、手术开始日期、手术开始时间、手术结束日期、手术结束时间、手术时间(分)
	Set obj.OperationID=$p(aInput,aSeparate,3)
	Set obj.OperationDesc=$p(aInput,aSeparate,4)
	Set obj.OperStartDate=$p(aInput,aSeparate,5)
	Set obj.OperStartTime=$p(aInput,aSeparate,6)
	Set obj.OperEndDate=$p(aInput,aSeparate,7)
	Set obj.OperEndTime=$p(aInput,aSeparate,8)
	Set obj.OperTimes=$p(aInput,aSeparate,9)
	//切口分类、ASA评分、麻醉方式、手术类型、术者、一助、二助
	Set OperCutTypeID=$p(aInput,aSeparate,10)
	Set obj.OperCutType=##class(DHCMed.SS.Dictionary).GetObjById(OperCutTypeID)
	Set obj.OperASAScore=$p(aInput,aSeparate,11)
	Set OperNarcosisTypeID=$p(aInput,aSeparate,12)
	Set obj.OperNarcosisType=##class(DHCMed.SS.Dictionary).GetObjById(OperNarcosisTypeID)
	Set OperationTypeID=$p(aInput,aSeparate,13)
	Set obj.OperationType=##class(DHCMed.SS.Dictionary).GetObjById(OperationTypeID)
	Set OperationType1ID=$p(aInput,aSeparate,14)
	Set obj.OperationType1=##class(DHCMed.SS.Dictionary).GetObjById(OperationType1ID)
	Set OperationType2ID=$p(aInput,aSeparate,15)
	Set obj.OperationType2=##class(DHCMed.SS.Dictionary).GetObjById(OperationType2ID)
	Set obj.OperDoctor=$p(aInput,aSeparate,16)
	Set obj.Assistant1=$p(aInput,aSeparate,17)
	Set obj.Assistant2=$p(aInput,aSeparate,18)
	//麻醉诱导期用药
	While (obj.NarcosisAnti.Count()>0) {
		Do obj.NarcosisAnti.RemoveAt(1)
	}
	Set NarcosisAntiList=$p(aInput,aSeparate,19)
	Set NarcosisAntiLB=""
	For indAnti=1:1:$length(NarcosisAntiList,",") {
		Set NarcosisAnti=$p(NarcosisAntiList,",",indAnti)
		Set objNarcosisAnti=##class(DHCMed.NINF.Rep.AimReportOPRAnti).GetObj(NarcosisAnti,"`")
		Continue:'$IsObject(objNarcosisAnti)
		Do obj.NarcosisAnti.Insert(objNarcosisAnti)
	}
	//术后预防性用药
	While (obj.PostoperAnti.Count()>0) {
		Do obj.PostoperAnti.RemoveAt(1)
	}
	Set PostoperAntiList=$p(aInput,aSeparate,20)
	Set PostoperAntiLB=""
	For indAnti=1:1:$length(PostoperAntiList,",") {
		Set PostoperAnti=$p(PostoperAntiList,",",indAnti)
		Set objPostoperAnti=##class(DHCMed.NINF.Rep.AimReportOPRAnti).GetObj(PostoperAnti,"`")
		Continue:'$IsObject(objPostoperAnti)
		Do obj.PostoperAnti.Insert(objPostoperAnti)
	}
	
	//感染日期、病原体、感染类型、备注
	Set obj.InfDate=$p(aInput,aSeparate,21)
	While (obj.InfPathogeny.Count()>0) {
		Do obj.InfPathogeny.RemoveAt(1)
	}
	Set InfPyList=$p(aInput,aSeparate,22)
	Set InfPyLB=""
	For indPy=1:1:$length(InfPyList,",") {
		Set InfPy=$p(InfPyList,",",indPy)
		Continue:($listfind(InfPyLB,InfPy)>0)
		Set InfPyLB=InfPyLB_$lb(InfPy)
		Set objInfPy=##class(DHCMed.NINF.Dic.Pathogeny).GetObjById(InfPy)
		Continue:'$IsObject(objInfPy)
		Do obj.InfPathogeny.Insert(objInfPy)
	}
	Set OperInfTypeID=$p(aInput,aSeparate,23)
	Set obj.OperInfType=##class(DHCMed.SS.Dictionary).GetObjById(OperInfTypeID)
	Set obj.ResumeText=$p(aInput,aSeparate,24)
	
	//报告科室、报告人、报告日期、报告时间
	Set obj.RepLoc=$p(aInput,aSeparate,25)
	Set obj.RepUser=$p(aInput,aSeparate,26)
	Set obj.RepDate=$p(aInput,aSeparate,27)
	Set obj.RepTime=$p(aInput,aSeparate,28)
	Set RepStatusID=$p(aInput,aSeparate,29)
	Set obj.RepStatus=##class(DHCMed.SS.Dictionary).GetObjById(RepStatusID)
	
	Set UpdateLog=$p(aInput,aSeparate,30)
	
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
		
		//更新日志
		Set ParRef=+return
		Set UpdateLog=ParRef_","_"OPR"_","_UpdateLog
		Set flg=##Class(DHCMed.NINF.Rep.AimReportLog).Update(UpdateLog,",")
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2012-06-05
/// Description:  删除目标性监测报告 手术部位
/// Table：       DHCMed.NINF.Rep.AimReportOPR
/// Input：       DHCMed.NINF.Rep.AimReportOPR.ID
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.NINF.Rep.AimReportOPR).DeleteById("1||3")
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCMed.NINF.Rep.AimReportOPR).%DeleteId(aId)
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
/// Description:  更新目标性监测报告 手术部位
/// Table：       DHCMed.NINF.Rep.AimReportOPR
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.NINF.Rep.AimReportOPR).UpdateStatus()
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
	
	Set obj=##class(DHCMed.NINF.Rep.AimReportOPR).%OpenId(RowID)
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
		Set ReportLog=ParRef_","_"OPR"_","_LocID_","_UserID_","_StatusID
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
<Value>OperationID</Value>
</Value>
<Value name="3">
<Value>OperationDesc</Value>
</Value>
<Value name="4">
<Value>OperationType</Value>
</Value>
<Value name="5">
<Value>OperStartDate</Value>
</Value>
<Value name="6">
<Value>OperStartTime</Value>
</Value>
<Value name="7">
<Value>OperEndDate</Value>
</Value>
<Value name="8">
<Value>OperEndTime</Value>
</Value>
<Value name="9">
<Value>OperTimes</Value>
</Value>
<Value name="10">
<Value>OperNarcosisType</Value>
</Value>
<Value name="11">
<Value>OperCutType</Value>
</Value>
<Value name="12">
<Value>OperDoctor</Value>
</Value>
<Value name="13">
<Value>Assistant1</Value>
</Value>
<Value name="14">
<Value>Assistant2</Value>
</Value>
<Value name="15">
<Value>OperASAScore</Value>
</Value>
<Value name="16">
<Value>NarcosisAnti</Value>
</Value>
<Value name="17">
<Value>PostoperAnti</Value>
</Value>
<Value name="18">
<Value>InfDate</Value>
</Value>
<Value name="19">
<Value>InfPathogeny</Value>
</Value>
<Value name="20">
<Value>OperInfType</Value>
</Value>
<Value name="21">
<Value>ResumeText</Value>
</Value>
<Value name="22">
<Value>RepDate</Value>
</Value>
<Value name="23">
<Value>RepLoc</Value>
</Value>
<Value name="24">
<Value>RepTime</Value>
</Value>
<Value name="25">
<Value>RepUser</Value>
</Value>
<Value name="26">
<Value>RepStatus</Value>
</Value>
<Value name="27">
<Value>OperationType1</Value>
</Value>
<Value name="28">
<Value>OperationType2</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("OPR")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("OPR")</IdLocation>
<IndexLocation>^DHCMed.NINFi("AimRep",0,"OPR")</IndexLocation>
<StreamLocation>^DHCMed.NINF.Rep.AimReportOPRS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
