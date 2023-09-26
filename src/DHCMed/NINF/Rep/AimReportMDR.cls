/// 名称: DHCMed.NINF.Rep.AimReportMDR
/// 描述: 目标性监测报告 多重耐药
/// 编写者：zhufei
/// 编写日期: 2012-06-10
Class DHCMed.NINF.Rep.AimReportMDR Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

Relationship ParRef As DHCMed.NINF.Rep.AimReport [ Cardinality = parent, Inverse = ChildMDR ];

/// 数据来源 格式:"CTLOBJ:DHCMed.CC.CtlResult.ObjectID"
Property DataSource As %String(TRUNCATE = 1);

/// 送检日期
Property PathDate As %Date;

/// 标本类型("NINFAimMDRSampleType")
Property SampleType As DHCMed.SS.Dictionary;

/// 细菌名称("NIFNAimMDRPathogeny")
Property Pathogeny As DHCMed.SS.Dictionary;

/// 隔离方式("NINFAimMDRIsolateType")
Property IsolateType As DHCMed.SS.Dictionary;

/// 加强手卫生 是/否 ("NINFAimMDRHandHygiene")
Property HandHygiene As DHCMed.SS.Dictionary;

/// 续发病历 有/无 ("NINFAimMDRSecondaryCases")
Property SecondaryCases As DHCMed.SS.Dictionary;

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

/// 感染情况("NINFStation")
Property NINFStation As DHCMed.SS.Dictionary;

/// 送检日期索引
Index IndexPathDate On (PathDate As Exact, ParRef As Exact);

/// 报告日期索引
Index IndexRepDate On (RepDate As Exact, ParRef As Exact);

/// 报告科室+日期+时间索引
Index IndexRepLocDate On (RepLoc As Exact, RepDate As Exact, RepTime As Exact, ParRef As Exact);

/// 报告状态+日期+时间索引
Index IndexRepStatusDate On (RepStatus As Exact, RepDate As Exact, RepTime As Exact, ParRef As Exact);

/// Creator：     zhufei
/// CreatDate：   2012-06-10
/// Description:  取目标性监测报告 多重耐药
/// Table：       DHCMed.NINF.Rep.AimReportMDR
/// Input：       DHCMed.NINF.Rep.AimReportMDR.ID
/// Return：      返回obj
/// w ##class(DHCMed.NINF.Rep.AimReportMDR).GetObjById("1||3")
ClassMethod GetObjById(aId As %String) As DHCMed.NINF.Rep.AimReportMDR
{
	New (aId)
	Set obj=##Class(DHCMed.NINF.Rep.AimReportMDR).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2012-06-10
/// Description:  更新目标性监测报告 多重耐药
/// Table：       DHCMed.NINF.Rep.AimReportMDR
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.NINF.Rep.AimReportMDR).Update()
ClassMethod Update(aInput As %String, aSeparate As %String = "") As %String
{
	 
	New (aInput,aSeparate)
	Set return=0
	Set:aSeparate="" aSeparate=..#SEPARATE
	
	Set ParRef=$p(aInput,aSeparate,1)
	Set ChildSub=$p(aInput,aSeparate,2)
	If (ChildSub="") {
		Set obj=##class(DHCMed.NINF.Rep.AimReportMDR).%New()
		Set obj.ParRef=##class(DHCMed.NINF.Rep.AimReport).GetObjById(ParRef)
	} Else {
		Set obj=##class(DHCMed.NINF.Rep.AimReportMDR).%OpenId(ParRef_"||"_ChildSub)
	}
	Quit:'$IsObject(obj) return
	Quit:'$IsObject(obj.ParRef) return
	
	//送检日期、标本类型、细菌名称、隔离方式、加强手卫生、续发病历
	Set obj.PathDate=$p(aInput,aSeparate,3)
	Set SampleTypeID=$p(aInput,aSeparate,4)
	Set obj.SampleType=##class(DHCMed.SS.Dictionary).GetObjById(SampleTypeID)
	Set PathogenyID=$p(aInput,aSeparate,5)
	Set obj.Pathogeny=##class(DHCMed.SS.Dictionary).GetObjById(PathogenyID)
	Set IsolateTypeID=$p(aInput,aSeparate,6)
	Set obj.IsolateType=##class(DHCMed.SS.Dictionary).GetObjById(IsolateTypeID)
	Set HandHygieneID=$p(aInput,aSeparate,7)
	Set obj.HandHygiene=##class(DHCMed.SS.Dictionary).GetObjById(HandHygieneID)
	Set SecondaryCasesID=$p(aInput,aSeparate,8)
	Set obj.SecondaryCases=##class(DHCMed.SS.Dictionary).GetObjById(SecondaryCasesID)
	
	//报告科室、报告人、报告日期、报告时间
	Set obj.RepLoc=$p(aInput,aSeparate,9)
	Set obj.RepUser=$p(aInput,aSeparate,10)
	Set obj.RepDate=$p(aInput,aSeparate,11)
	Set obj.RepTime=$p(aInput,aSeparate,12)
	Set RepStatusID=$p(aInput,aSeparate,13)
	Set obj.RepStatus=##class(DHCMed.SS.Dictionary).GetObjById(RepStatusID)
	
	Set UpdateLog=$p(aInput,aSeparate,14)
	
	Set NINFStationID=$p(aInput,aSeparate,15)
	Set obj.NINFStation=##class(DHCMed.SS.Dictionary).GetObjById(NINFStationID)
	
	If obj.DataSource="" {
		Set obj.DataSource=$p(aInput,aSeparate,16)
	}
	
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
		
		//更新日志
		Set ParRef=+return
		Set UpdateLog=ParRef_","_"MDR"_","_UpdateLog
		Set flg=##Class(DHCMed.NINF.Rep.AimReportLog).Update(UpdateLog,",")
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2012-06-10
/// Description:  删除目标性监测报告 多重耐药
/// Table：       DHCMed.NINF.Rep.AimReportMDR
/// Input：       DHCMed.NINF.Rep.AimReportMDR.ID
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.NINF.Rep.AimReportMDR).DeleteById("1||3")
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCMed.NINF.Rep.AimReportMDR).%DeleteId(aId)
	If $System.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2012-06-10
/// Description:  更新目标性监测报告 多重耐药
/// Table：       DHCMed.NINF.Rep.AimReportMDR
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.NINF.Rep.AimReportMDR).UpdateStatus()
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
	
	Set obj=##class(DHCMed.NINF.Rep.AimReportMDR).%OpenId(RowID)
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
		Set ReportLog=ParRef_","_"MDR"_","_LocID_","_UserID_","_StatusID
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
<Value>PathDate</Value>
</Value>
<Value name="3">
<Value>SampleType</Value>
</Value>
<Value name="4">
<Value>Pathogeny</Value>
</Value>
<Value name="5">
<Value>IsolateType</Value>
</Value>
<Value name="6">
<Value>HandHygiene</Value>
</Value>
<Value name="7">
<Value>SecondaryCases</Value>
</Value>
<Value name="8">
<Value>RepLoc</Value>
</Value>
<Value name="9">
<Value>RepUser</Value>
</Value>
<Value name="10">
<Value>RepDate</Value>
</Value>
<Value name="11">
<Value>RepTime</Value>
</Value>
<Value name="12">
<Value>RepStatus</Value>
</Value>
<Value name="13">
<Value>NINFStation</Value>
</Value>
<Value name="14">
<Value>DataSource</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("MDR")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("MDR")</IdLocation>
<IndexLocation>^DHCMed.NINFi("AimRep",0,"MDR")</IndexLocation>
<StreamLocation>^DHCMed.NINF.Rep.AimReportMDRS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
