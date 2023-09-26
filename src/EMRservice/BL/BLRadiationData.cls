/// 名称：		EMRservice.BL.BLRadiationData
/// 描述：		从数据平台取放疗结果BL层
/// 编写者：	yejian
/// 编写时间：	2021-10-29
Class EMRservice.BL.BLRadiationData Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:      从数据平台取放疗结果
/// Creator:   yejian
/// CreateDate:2021-10-29
/// Input:     AEpiosdeID 就诊号
///            AStartDate 开始日期
///            AEndDate   结束日期
/// Output:
/// Debug:     d ##class(%ResultSet).RunQuery("EMRservice.BL.BLRadiationData","GetRadiationDatas",12175,"","")
Query GetRadiationDatas(AEpiosdeID As %String, AStartDate As %String = "", AEndDate As %String = "") As %Query(ROWSPEC = "ID,CommitDate,Diagnos,Course,Position,Radiotherapyed,TotalNum,FractionalDose,RadiationDose,PrescriptionDose,StartDate,EndDate,EpisodeID")
{
}

ClassMethod GetRadiationDatasExecute(ByRef qHandle As %Binary, AEpiosdeID As %String, AStartDate As %String = "", AEndDate As %String = "") As %Status
{
	s repid = $I(^CacheTemp)
	s qHandle = $lb(0,repid,0)
 	s ind = 1
    q:(AEpiosdeID = "") $$$OK
    s (ID,CommitDate,Diagnos,Course,Position,Radiotherapyed,TotalNum,FractionalDose,RadiationDose,PrescriptionDose,StartDate,EndDate,EpisodeID)=""
    s patientId = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(AEpiosdeID)
    
	s rowID = ""
	for
	{
		s rowID = $o(^SaveMedicalRecord("SaveMedicalRecord",AEpiosdeID,rowID))
		q:(rowID="")
        s strRes = ^SaveMedicalRecord("SaveMedicalRecord",AEpiosdeID,rowID)
       	continue:(strRes="")
		//获取医嘱状态
		//唯一id^放疗医嘱提交时间^诊断^疗程^部位^已放疗测试^总次数^分次计量^累计放疗剂量^处方剂量^开始日期^最后日期^就诊号
		//ID,CommitDate,Diagnos,Course,Position,Radiotherapyed,TotalNum,FractionalDose,RadiationDose,PrescriptionDose,StartDate,EndDate,EpisodeID
		//放疗医嘱提交时间
		s CommitDate = $P(strRes,"^",1)
		//诊断
		s Diagnos = $P(strRes,"^",2)
		//疗程
		s Course = $P(strRes,"^",3)
		//部位
		s Position = $P(strRes,"^",4)
		//已放疗测试
		s Radiotherapyed = $P(strRes,"^",5)
		//总次数
		s TotalNum = $P(strRes,"^",6)
		//分次计量
		s FractionalDose = $P(strRes,"^",7)
		//累计放疗剂量
		s RadiationDose = $P(strRes,"^",8)
		//处方剂量
		s PrescriptionDose = $P(strRes,"^",9)
		//开始日期
		s StartDate = $P(strRes,"^",10)
		//最后日期
		s EndDate = $P(strRes,"^",11)
		//就诊号
		s EpisodeID = $P(strRes,"^",12)
		//id
		s ID = 	$P(strRes,"^",13)	
		s data = $lb(ID,CommitDate,Diagnos,Course,Position,Radiotherapyed,TotalNum,FractionalDose,RadiationDose,PrescriptionDose,StartDate,EndDate,EpisodeID)
		s ^CacheTemp(repid,ind) = data
		s ind=ind + 1 
	}
	Quit $$$OK
}

ClassMethod GetRadiationDatasClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRadiationDatasExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetRadiationDatasFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRadiationDatasExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
