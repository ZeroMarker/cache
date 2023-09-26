Class EPRservice.tool.ReportTemplateQuery Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// wangwentao 20130607 add bjdtyy
/// ##Class(EPRservice.tool.ReportTemplateQuery).GetOutPatMZBLSY("2013-06-01","2013-06-01","213")
ClassMethod GetOutPatMZBLSY(argBeginDisDate As %String, argEndDisDate As %String, TemplateId As %String) As %String
{
	q:($d(argBeginDisDate)=0)||(argBeginDisDate="")||($d(argEndDisDate)=0)||(argEndDisDate="")||($d(TemplateId)=0)||(TemplateId="") ""
	
	s patType="",patStatus=""
	
	s argBeginDisDate=$zdh(argBeginDisDate,3)
	s argEndDisDate=$zdh(argEndDisDate,3)
	q:(argBeginDisDate>argEndDisDate) ""
	
	s AdmString = "",AdmCount=0
	for date=argBeginDisDate:1:argEndDisDate {
		s adm=""
		for {
			s adm=$o(^PAADMi("PAADM_AdmDate",date,adm))
			q:(adm="")
			s PAADMType = $P($g(^PAADM(adm)),"^",2)
			Continue:(PAADMType="I")||(PAADMType="H")
			
			s papmidr = $P($g(^PAADM(adm)),"^",1)
			s Name=##Class(EPRservice.HISInterface.PatientInfoAssist).Name(papmidr)
			s RegisterNo = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiNo(papmidr)

			s aPatient=0
			s aPatient=..GetInstanceDataStatus(adm,TemplateId)
			
			Continue:(aPatient'=1)
			
			s AdmCount = AdmCount +1
			
			w !,AdmCount_"   "_$zd(date,3)_"   "_adm_"   "_RegisterNo_"   "_Name
		}
	}
	
	s AdmString = "AdmCount:"_AdmCount_" finished successfully !"
	q AdmString
}

/// Desc：取EPRinstance.InstanceData保存状态Save 1/UnSave 0 
ClassMethod GetInstanceDataStatus(EpisodeID As %String, TemplateID As %String) As %String
{
	///TemplateID->Template.CategoryID
	///Index IdxEpisodeIDCategoryID On (EpisodeID, CategoryID);
	///Index IdxECRecord On TheECRecord;
    s Status=0
    s objTemplate=##Class(EPRmeta.Template).%OpenId(TemplateID)
    s CategoryID=objTemplate.TemplateCategoryID
    s objTemplateCategory=##Class(EPRmeta.TemplateCategory).%OpenId(CategoryID)
    i objTemplateCategory.CategoryType="Normal"
    {
		s CategoryID=objTemplate.TemplateCategoryID
	}
    i objTemplateCategory.CategoryType="GroupItem"
    {
		s CategoryID=objTemplateCategory.ParentID
	}
    s BlankEpisodeID=" "_EpisodeID
	s BlankCategoryID=" "_CategoryID
	s TheEcrecordIndex="0"
	s TheEcrecordIndex= $O(^DHCEPRI.ECRecordI("IdxEpisodeIDCategoryID",BlankEpisodeID,BlankCategoryID,""))
	q:TheEcrecordIndex="" Status 
	s objInstanceData=##Class(EPRinstance.ECRecord).%OpenId(TheEcrecordIndex)
	s InstanceCount=objInstanceData.InstanceCount
	f i=1:1:InstanceCount
	{
		s InstanceDataID=TheEcrecordIndex_"||"_i
		s objInstanceData=##Class(EPRinstance.InstanceData).%OpenId(InstanceDataID)
		if objInstanceData.TemplateID=TemplateID 
		{
			i ((objInstanceData.Status="Save")||(objInstanceData.Status="Commit" )) 
			{
				s Status=1
			}
		}
	}
    q Status
}

/// 查询门诊首页质控日志表数据
/// ##Class(EPRservice.tool.ReportTemplateQuery).GetQualityList(368)
ClassMethod GetQualityList(ADocID As %String) As %String
{

	s (DrugList,DrugString,DrugItem,RPCtLocDr,RPEmployeeDr,REpisodeID,REpisodeIDCC,RDchildsub,RDEntryDR,RActualDeScore) =""
	s (RPCtLocDesc,RPEmployeeCode,RPEmployeeDesc,AdmDateTime,RegisterNo,RecordNo,Name,RDEntryDRPoolDR,RDEntryDRPoolDesc,logs,createUser,createUserCode,createUserDesc)=""
	s (Num,Num1) =0
	
	&sql(declare DrugList cursor for 
			SELECT RP.CtLocDr,RP.EmployeeDr,R.EpisodeID,RD.childsub,RD.EntryDR,R.ActualDeScore INTO :RPCtLocDr,:RPEmployeeDr,:REpisodeID,:RDchildsub,:RDEntryDR,:RActualDeScore
			FROM EPRinstance_Quality.QualityResult R , EPRinstance_Quality.QualityResultDetail RD, EPRinstance_Quality.QualityResultPeople RP
			WHERE R.ID = RD.TheResult AND RD.People = RP.ID  )
	&sql(open DrugList)
	for  &sql(fetch DrugList) Quit:SQLCODE  Do
	.//b "s"
	.s GetPapmiDR = $P($g(^PAADM(REpisodeID)),"^",1)
	.//科室名称
	.s RPCtLocDr = ##Class(EPRservice.HISInterface.PatientInfoAssist).DisDept(REpisodeID) 
	.s:(RPCtLocDr'="") RPCtLocDesc = $p($g(RPCtLocDr),"^",2)
	.//医生工号、医生名称
	.s RPEmployeeDr =  ##Class(EPRservice.HISInterface.PatientInfoAssist).MainDoc(REpisodeID) 
	.s:(RPEmployeeDr'="") RPEmployeeCode = $p($g(RPEmployeeDr),"^",2)
	.s:(RPEmployeeDr'="") RPEmployeeDesc = $p($g(RPEmployeeDr),"^",3)
	.s logs=##class(EPRinstance.EPRLogs).GetCurrLog(REpisodeID,ADocID,1)
	.s:(logs'="") createUser = logs.CreateUserID
	.s:(logs'="") createUserCode = $P($g(^SSU("SSUSR",createUser)),"^",1)
	.s:(logs'="") createUserDesc = $P($g(^SSU("SSUSR",createUser)),"^",2)
	.//就诊日期
	.s AdmDateTime=##class(EPRservice.HISInterface.PatientInfoAssist).AdmDateTime(REpisodeID)
	.i AdmDateTime'=""  d 
	..s AdmDate = $ZD($P($G(AdmDateTime),",",1),3)
	..s AdmTime = $ZT($P($G(AdmDateTime),",",2),1)
	..s AdmDateTime=AdmDate_" "_AdmTime
	.//就诊号、登记号、病案号
	.s RegisterNo = $P($g(^PAPER(GetPapmiDR,"PAT",1)),"^",1)
	.s RecordNo = ##Class(web.DHCWMRService).IGetMrTypeInfo(REpisodeID)
	.s:(RecordNo'="") RecordNo =$p($g(RecordNo),"^",1)
	.//病人姓名
	.s Name=##Class(EPRservice.HISInterface.PatientInfoAssist).Name(GetPapmiDR)
	.//质控信息
	.s RDEntryDRPoolDR = $lg(^DHCEPRM.QualityEntryD(RDEntryDR),1)
	.s RDEntryDRPoolDesc = $lg(^DHCEPRM.QualityPoolD(RDEntryDRPoolDR),2)
	.//Debug
	.s Num = Num + 1 
	.//b:(Num=10)
	.//输出
	.//w !,Num_"^"_RPCtLocDesc_"^"_RPEmployeeCode_"^"_RPEmployeeDesc_"^"_AdmDateTime_"^"_RegisterNo_"^"_RecordNo_"^"_Name_"^"_RDchildsub_"^"_RDEntryDRPoolDesc_"^"_RActualDeScore_"^"_createUserCode_"^"_createUserDesc_"^"_REpisodeID
	.q:(REpisodeIDCC=REpisodeID)
	.s Num1 = Num1 + 1  
	.s REpisodeIDCC = REpisodeID
	.w !,Num_"^"_Num1_"^"_RPCtLocDesc_"^"_RPEmployeeCode_"^"_RPEmployeeDesc_"^"_AdmDateTime_"^"_RegisterNo_"^"_RecordNo_"^"_Name_"^"_RActualDeScore_"^"_createUserCode_"^"_createUserDesc_"^"_REpisodeID

	
	&sql(close DrugList)

	
	q 1
}

}
