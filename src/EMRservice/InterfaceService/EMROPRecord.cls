/// Creator:	yejian
/// CreatDate:  2019-4-17
/// Desc:		江苏南京高淳人民提供门诊病历接口
Class EMRservice.InterfaceService.EMROPRecord Extends %RegisteredObject
{

/// Creator:	yejian
/// CreatDate:  2019-4-17
/// Desc:		门急诊病历
/// Input：		DateFrom：出院日期始，DateTo：出院日期结束
/// Return：	EPRservice.dataset.EDataElementDataset: 术语集dataset
/// Debug:		d ##Class(%ResultSet).RunQuery("EMRservice.InterfaceService.EMROPRecord","GetDCOutpHealthRecord","","2018-4-4")
Query GetDCOutpHealthRecord(strTransType As %String, strDate As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,PATIENTID:%String,NAME:%String,VISITDATE:%String,VISITNO:%String,DEPTCODE:%String,DOCTORCODE:%String,CHIEFCOMPLAINT:%String,PRESENTILLNESSHISTORY:%String,PASTHISTORY:%String,PERSONALHISTORY:%String,PHYSICALEXAM:%String,AUXILIARYEXAM:%String,DIAGNOSIS:%String,SUGGESTION:%String") [ SqlName = DC_OUTP_HEALTH_RECOR, SqlProc ]
{
}

ClassMethod GetDCOutpHealthRecordExecute(ByRef qHandle As %Binary, strTransType As %String, strDate As %String) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	s AGlossaryCategoryID = "HDSD00.03.01"
	s StartDate	= $g(strDate)

	s StartDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(StartDate)," ",1)
	
	s strRowID = ""
	for
	{
		s strRowID = $o(^DHCEMRI.InstanceDataI("IdxModifyDate",StartDate,strRowID))
		q:(strRowID = "")
		s strRowNum = ""
		for
		{
			s strRowNum = $o(^DHCEMRI.InstanceDataI("IdxModifyDate",StartDate,strRowID,strRowNum))
			q:(strRowNum = "")
			s strInstanID = strRowID_"||"_strRowNum
		    s objInstance = ##class(EMRinstance.InstanceData).%OpenId(strInstanID)
		    continue:(objInstance.Status'="Save")
		    s strInID = objInstance.%Id()
		    s AEpisodeID=objInstance.RealEpisodeID
			q:(AEpisodeID = "")
			//s StandDataArry = ..GetDataByGlossaryCategory(AEpisodeID,AGlossaryCategoryID)
			s StandDataArry=##class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossary(AEpisodeID,AGlossaryCategoryID,strInID)
			s (ID,PATIENTID,NAME,VISITDATE,VISITNO,DEPTCODE,DOCTORCODE,CHIEFCOMPLAINT,PRESENTILLNESSHISTORY,PASTHISTORY,
			   PERSONALHISTORY,PHYSICALEXAM,AUXILIARYEXAM,DIAGNOSIS,SUGGESTION)=""
		
			s ID= strInID //记录 ID
			s PATIENTID= objInstance.TheECRecord.PatientID //病人标识
			s NAME= StandDataArry.GetAt("HDSD00.03.017") //病人姓名
			s VISITDATE= "" //挂号日期
			s VISITNO= AEpisodeID //病人就诊号
			s DEPTCODE= "" //挂号科室代码
			s DOCTORCODE= objInstance.CreateUser //医生代码 
			s CHIEFCOMPLAINT= StandDataArry.GetAt("HDSD00.03.057") //主诉
			s PRESENTILLNESSHISTORY= StandDataArry.GetAt("HDSD00.03.038") //现病史
			s PASTHISTORY= StandDataArry.GetAt("HDSD00.03.021") //既往史
			s PERSONALHISTORY= StandDataArry.GetAt("HDSD00.03.014") //个人史
			s PHYSICALEXAM= StandDataArry.GetAt("HDSD00.03.037") //体格检查
			s AUXILIARYEXAM= StandDataArry.GetAt("HDSD00.03.013") //辅助检查 
			s DIAGNOSIS= StandDataArry.GetAt("HDSD00.03.005") //诊断 
			s SUGGESTION= StandDataArry.GetAt("HDSD00.03.503") //处理意见 
		
			s Data = $lb(ID,PATIENTID,NAME,VISITDATE,VISITNO,
					DEPTCODE,DOCTORCODE,CHIEFCOMPLAINT,PRESENTILLNESSHISTORY,PASTHISTORY,
				    PERSONALHISTORY,PHYSICALEXAM,AUXILIARYEXAM,DIAGNOSIS,
				    SUGGESTION)
			s ^CacheTemp(repid,ind) = Data
			s ind = ind + 1
		}
	}
	q $$$OK
}

ClassMethod GetDCOutpHealthRecordFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDCOutpHealthRecordExecute ]
{
	s AtEnd=$list(qHandle,1)
 	s repid=$list(qHandle,2)
 	s ind=$list(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	if ind="" {	
 		s AtEnd=1
 		s Row=""
 		k ^CacheTemp(repid)
 	} else {
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetDCOutpHealthRecordClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDCOutpHealthRecordExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// CreateUser： sunjinbo
/// CreatDate:	 2023-01-31
/// Desc:	  	 判断门诊病历状态
/// Input：   	 adm：就诊号
/// Output:   	 0:未保存，1：已保存未签名，2:已签名
/// Debugger：	 w ##class(EMRservice.InterfaceService.EMROPRecord).GetMZRecordStatus(4678)
ClassMethod GetMZRecordStatus(argAdm As %String)
{
	s ret="0"
	q:($d(argAdm)=0)||(argAdm="") ret
	//判断病历版本 返回值2,3,4
	s verID =##class(EMRservice.BL.BLScatterData).GetDataVersion(argAdm)
	//4版病历
	if (verID = 4)
	{
		s instanceidList=##Class(EMRservice.BL.Interface.RecordInfoToINSU).GetValidInstanceIDListByGlossaryF(argAdm,"HDSD00.03.01")
		
		q:(instanceidList="") ret
		s ret=1
		for i=1:1:$l(instanceidList,"^")
		{
			s signStatus=##Class(EMR.DOC.BL.PrivAssist).HasValidSign($p(instanceidList,"^",i))
			
			s:(signStatus="1") ret=2
			q:(ret=2)
		}
	}
	else 
	{
		s instanceidList=##Class(EMRservice.BL.Interface.RecordInfoToINSU).GetValidInstanceIDListByGlossary(argAdm,"HDSD00.03.01")
		
		q:(instanceidList="") ret
		s ret=1
		for i=1:1:$l(instanceidList,"^")
		{
			s signStatus=##Class(EMRservice.BOPrivAssist).HasValidSign($p(instanceidList,"^",i))
			
			s:(signStatus="1") ret=2
			q:(ret=2)
		}
	}
	q ret
}

}
