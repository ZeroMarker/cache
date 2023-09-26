/// 名称: DHCMed.NINF.Rep.AimReport
/// 描述: 目标性监测报告
/// 编写者：zhufei
/// 编写日期: 2012-05-26
Class DHCMed.NINF.Rep.AimReport Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

/// 更新日志
Relationship ChildLog As DHCMed.NINF.Rep.AimReportLog [ Cardinality = children, Inverse = ParRef ];

/// 导尿管
Relationship ChildUC As DHCMed.NINF.Rep.AimReportUC [ Cardinality = children, Inverse = ParRef ];

/// 呼吸机
Relationship ChildVAP As DHCMed.NINF.Rep.AimReportVAP [ Cardinality = children, Inverse = ParRef ];

/// 中央导管
Relationship ChildPICC As DHCMed.NINF.Rep.AimReportPICC [ Cardinality = children, Inverse = ParRef ];

/// 手术
Relationship ChildOPR As DHCMed.NINF.Rep.AimReportOPR [ Cardinality = children, Inverse = ParRef ];

/// 多重耐药
Relationship ChildMDR As DHCMed.NINF.Rep.AimReportMDR [ Cardinality = children, Inverse = ParRef ];

/// NICU 脐静脉
Relationship ChildNUC As DHCMed.NINF.Rep.AimReportNUC [ Cardinality = children, Inverse = ParRef ];

/// NICU 气管插管
Relationship ChildNVNT As DHCMed.NINF.Rep.AimReportNVNT [ Cardinality = children, Inverse = ParRef ];

/// NICU 中央导管
Relationship ChildNPICC As DHCMed.NINF.Rep.AimReportNPICC [ Cardinality = children, Inverse = ParRef ];

/// EpisodeID 指向Pa_Adm
Property EpisodeID As %String(TRUNCATE = 1) [ Required ];

/// 报告类型("NINFAimReportType")   UC/PICC/VAP/OPR/MDR/NICU
Property ReportType As DHCMed.SS.Dictionary;

/// 转科记录 指向PA_AdmTransaction
Property TransID As %String(TRUNCATE = 1);

/// 转入科室 指向CT_Loc
Property TransLoc As %String(TRUNCATE = 1);

/// 入科来源 指向CT_Loc
Property TransFromLoc As %String(TRUNCATE = 1);

/// 出科去向 指向CT_Loc
Property TransToLoc As %String(TRUNCATE = 1);

/// 转入日期
Property TransInDate As %Date;

/// 转出日期
Property TransOutDate As %Date;

/// 出生体重(gm)
Property BornWeight As %String(TRUNCATE = 1);

Index IndexTypeAdmTrans On (ReportType As Exact, EpisodeID As Exact, TransID As Exact);

/// Creator：     zhufei
/// CreatDate：   2012-05-26
/// Description:  取目标性监测报告
/// Table：       DHCMed.NINF.Rep.AimReport
/// Input：       DHCMed.NINF.Rep.AimReport.ID
/// Return：      返回obj
/// w ##class(DHCMed.NINF.Rep.AimReport).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMed.NINF.Rep.AimReport
{
	New (aId)
	Set obj=##Class(DHCMed.NINF.Rep.AimReport).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2012-05-26
/// Description:  更新目标性监测报告
/// Table：       DHCMed.NINF.Rep.AimReport
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.NINF.Rep.AimReport).Update()
ClassMethod Update(aInput As %String, aSeparate As %String = "") As %String
{
	 
	New (aInput,aSeparate)
	Set return=0
	Set:aSeparate="" aSeparate=..#SEPARATE
	
	Set ID=$p(aInput,aSeparate,1)
	If (ID="") {
		Set obj=##class(DHCMed.NINF.Rep.AimReport).%New()
	} Else {
		Set obj=##class(DHCMed.NINF.Rep.AimReport).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.EpisodeID=$p(aInput,aSeparate,2)
	Set RepTypeID=$p(aInput,aSeparate,3)
	Set obj.ReportType=##class(DHCMed.SS.Dictionary).GetObjById(RepTypeID)
	Set obj.TransID=$p(aInput,aSeparate,4)
	Set obj.TransLoc=$p(aInput,aSeparate,5)
	Set obj.TransFromLoc=$p(aInput,aSeparate,6)
	Set obj.TransToLoc=$p(aInput,aSeparate,7)
	Set obj.TransInDate=$p(aInput,aSeparate,8)
	Set obj.TransOutDate=$p(aInput,aSeparate,9)
	Set obj.BornWeight=$p(aInput,aSeparate,10)
	
	Set UpdateLog=$p(aInput,aSeparate,11)
	
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
		
		//更新日志
		Set ParRef=+return
		Set UpdateLog=ParRef_","_"Main"_","_UpdateLog
		Set flg=##Class(DHCMed.NINF.Rep.AimReportLog).Update(UpdateLog,",")
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2012-05-26
/// Description:  删除目标性监测报告
/// Table：       DHCMed.NINF.Rep.AimReport
/// Input：       DHCMed.NINF.Rep.AimReport.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCMed.NINF.Rep.AimReport).%DeleteId(aId)
	If $System.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpisodeID</Value>
</Value>
<Value name="3">
<Value>ReportType</Value>
</Value>
<Value name="4">
<Value>TransID</Value>
</Value>
<Value name="5">
<Value>TransLoc</Value>
</Value>
<Value name="6">
<Value>TransFromLoc</Value>
</Value>
<Value name="7">
<Value>TransToLoc</Value>
</Value>
<Value name="8">
<Value>TransInDate</Value>
</Value>
<Value name="9">
<Value>TransOutDate</Value>
</Value>
<Value name="10">
<Value>BornWeight</Value>
</Value>
</Data>
<DataLocation>^DHCMed.NINF("AimRep")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.NINF("AimRep")</IdLocation>
<IndexLocation>^DHCMed.NINFi("AimRep",0)</IndexLocation>
<StreamLocation>^DHCMed.NINF.Rep.AimReportS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
