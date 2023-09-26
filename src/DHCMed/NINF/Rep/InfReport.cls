/// 名称: DHCMed.NINF.Rep.InfReport
/// 描述: 医院感染报告
/// 编写者：zhufei
/// 编写日期: 2012-06-19
Class DHCMed.NINF.Rep.InfReport Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 更新日志
Relationship ChildLog As DHCMed.NINF.Rep.InfReportLog [ Cardinality = children, Inverse = ParRef ];

/// 摘要信息
Relationship ChildSumm As DHCMed.NINF.Rep.InfReportSumm [ Cardinality = children, Inverse = ParRef ];

/// 疾病诊断
Relationship ChildDiag As DHCMed.NINF.Rep.InfReportDiag [ Cardinality = children, Inverse = ParRef ];

/// 感染部位
Relationship ChildInfPos As DHCMed.NINF.Rep.InfReportInfPos [ Cardinality = children, Inverse = ParRef ];

/// 手术相关
Relationship ChildOpr As DHCMed.NINF.Rep.InfReportOpr [ Cardinality = children, Inverse = ParRef ];

/// 病原菌检验
Relationship ChildLab As DHCMed.NINF.Rep.InfReportLab [ Cardinality = children, Inverse = ParRef ];

/// 抗菌药物
Relationship ChildAnti As DHCMed.NINF.Rep.InfReportAnti [ Cardinality = children, Inverse = ParRef ];

/// 重症监护
Relationship ChildICU As DHCMed.NINF.Rep.InfReportICU [ Cardinality = children, Inverse = ParRef ];

/// 报告评价
Relationship ChildCheck As DHCMed.NINF.Rep.InfReportCheck [ Cardinality = children, Inverse = ParRef ];

/// EpisodeID 指向Pa_Adm
Property EpisodeID As %String(TRUNCATE = 1);

/// 报告类型("NINFInfReportType")   COMP/ICU/NICU
Property ReportType As DHCMed.SS.Dictionary;

/// 指针记录
Property ObjectID As %String(TRUNCATE = 1);

/// 报告科室 指向CT_Loc
Property ReportLoc As %String(TRUNCATE = 1);

/// 报告人员 指向SS_User
Property ReportUser As %String(TRUNCATE = 1);

/// 报告日期
Property ReportDate As %Date;

/// 报告时间
Property ReportTime As %Time;

/// 报告状态 ("NINFInfReportStatus")
Property ReportStatus As DHCMed.SS.Dictionary;

Index IndexTypeAdmTrans On (ReportType As Exact, EpisodeID As Exact, ObjectID As Exact);

Index IndexPaadm On EpisodeID As Exact;

Index IndexRepDateLoc On (ReportDate As Exact, ReportTime As Exact, ReportLoc As Exact);

/// 状态索引 Add By LiYang 2013-01-05 为了能够按照状态进行统计
Index IndexStatus On (ReportType As Exact, ReportStatus);

/// Creator：     zhufei
/// CreatDate：   2012-06-19
/// Description:  取医院感染报告
/// Table：       DHCMed.NINF.Rep.InfReport
/// Input：       DHCMed.NINF.Rep.InfReport.ID
/// Return：      返回obj
/// w ##class(DHCMed.NINF.Rep.InfReport).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMed.NINF.Rep.InfReport
{
	New (aId)
	Set obj=##Class(DHCMed.NINF.Rep.InfReport).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2012-06-19
/// Description:  更新医院感染报告
/// Table：       DHCMed.NINF.Rep.InfReport
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.NINF.Rep.InfReport).Update()
ClassMethod Update(aInput As %String, aSeparate As %String) As %String
{
	New (aInput,aSeparate)
	Set return=0
	
	Set CHR1=$p(aSeparate,",",1)
	Set CHR2=$p(aSeparate,",",2)
	Quit:(CHR1="")||(CHR2="") return
	
	Set ID=$p(aInput,CHR1,1)
	If (ID="") {
		Set obj=##class(DHCMed.NINF.Rep.InfReport).%New()
	} Else {
		Set obj=##class(DHCMed.NINF.Rep.InfReport).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.EpisodeID=$p(aInput,CHR1,2)
	Set RepTypeID=$p(aInput,CHR1,3)
	Set obj.ReportType=##class(DHCMed.SS.Dictionary).GetObjById(RepTypeID)
	Set obj.ObjectID=$p(aInput,CHR1,4)
	Set obj.ReportLoc=$p(aInput,CHR1,5)
	Set obj.ReportUser=$p(aInput,CHR1,6)
	Set obj.ReportDate=$p(aInput,CHR1,7)
	Set obj.ReportTime=$p(aInput,CHR1,8)
	Set ReportStatus=$p(aInput,CHR1,9)
	Set obj.ReportStatus=##class(DHCMed.SS.Dictionary).GetObjById(ReportStatus)
	
	Set UpdateLog=$p(aInput,CHR1,10)
	
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
		
		//更新日志
		Set ParRef=+return
		Set UpdateLog=ParRef_CHR2_UpdateLog
		Set flg=##Class(DHCMed.NINF.Rep.InfReportLog).Update(UpdateLog,CHR2)
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2012-06-19
/// Description:  删除医院感染报告
/// Table：       DHCMed.NINF.Rep.InfReport
/// Input：       DHCMed.NINF.Rep.InfReport.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCMed.NINF.Rep.InfReport).%DeleteId(aId)
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
<Value>ObjectID</Value>
</Value>
<Value name="5">
<Value>ReportLoc</Value>
</Value>
<Value name="6">
<Value>ReportUser</Value>
</Value>
<Value name="7">
<Value>ReportDate</Value>
</Value>
<Value name="8">
<Value>ReportTime</Value>
</Value>
<Value name="9">
<Value>ReportStatus</Value>
</Value>
</Data>
<DataLocation>^DHCMed.NINF("InfRep")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.NINF("InfRep")</IdLocation>
<IndexLocation>^DHCMed.NINFi("InfRep",0)</IndexLocation>
<StreamLocation>^DHCMed.NINF.Rep.InfReportS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
