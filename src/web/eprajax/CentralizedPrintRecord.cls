Class web.eprajax.CentralizedPrintRecord Extends %CSP.Page [ ClassType = "", ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	s start = $g(%request.Data("start",1),1)
	s limit = $g(%request.Data("limit",1),20)
	s name  = $g(%request.Data("name",1),"")
	s registerno  = $g(%request.Data("registerno",1),"")
	
	if (registerno'=""){
		s totalCount = ##Class(EPRservice.BLL.BLCentralizedPrintRecord).GetRecordTotalCountByRegisterNo(registerno)
	}
	elseif(name'=""){
		s totalCount = ##Class(EPRservice.BLL.BLCentralizedPrintRecord).GetRecordTotalCountByName(name)
	}
	else{
		s totalCount = ##Class(EPRservice.BLL.BLCentralizedPrintRecord).GetRecordTotalCount()
	}
	w "{totalCount:"_totalCount_",data:["

	d ..GetPrintRecordJson(registerno,name,start,limit)	

	w "]}"
	
	Quit $$$OK
}

/// debug: d ##class(web.eprajax.CentralizedPrintRecord).GetPrintRecordJson("0000000004","张三","1","20")
ClassMethod GetPrintRecordJson(ARegisterNo As %String, AName As %String, AStart As %String, ALimit As %String) As %String
{
	if (ARegisterNo'=""){
		s ARegisterNo=..AddZero(ARegisterNo)
		s result = ##Class(%ResultSet).%New("EPRservice.BLL.BLCentralizedPrintRecord:SearchPrintRecordByRegNo")
		s sc = result.Execute(ARegisterNo,AStart,ALimit)
	}
	elseif(AName'=""){
		s result = ##Class(%ResultSet).%New("EPRservice.BLL.BLCentralizedPrintRecord:SearchPrintRecordByName")
		s sc = result.Execute(AName,AStart,ALimit)
	}
	else{
		s result = ##Class(%ResultSet).%New("EPRservice.BLL.BLCentralizedPrintRecord:GetPrintRecord")
		s sc = result.Execute(AStart,ALimit)
	}		
	
 	s count = 0

	While (result.Next())
 	{
	 	s count = count + 1
		s userID = result.Data("UserID")
		s episodeID = result.Data("EpisodeID")
		s patientID = result.Data("PatientID")
		s registerno=result.Data("RegisterNo")
		s printItemsID = result.Data("PrintItemsID")	
		s startDate = result.Data("StartDate")
		s startTime = result.Data("StartTime")
		s finishDate = result.Data("FinishDate")
		s finishTime = result.Data("FinishTime")
		
		s userName = ##class(EPRmeta.Privilege.PowerUser).GetUserName(userID)	
 		s patientName = ##class(EPRservice.HISInterface.PatientInfoAssist).Name(patientID)
 		s startDateTime = ##class(EMRservice.Tools.Tool).GetHISStandardDateTimeFormat("ChangeToFormat","DateTime",$ZD(startDate,3)_" "_$ZT(startTime))
 		s finishDateTime = ##class(EMRservice.Tools.Tool).GetHISStandardDateTimeFormat("ChangeToFormat","DateTime",$ZD(finishDate,3)_" "_$ZT(finishTime))
 		
 		s totalItemCount = $l(printItemsID,"^")
		s rowID = ""
		s descAll = ""
		for i=1:1:totalItemCount
		{	
			s category = $p(printItemsID,"^",i)
			s categoryIDNum = $e(category,3,4)
			if (categoryIDNum '= "07")
			{
				s rowID = ""
				s rowID = $O(^DHCEPRM.CentralizedPrintItemI("IdxCategoryID", " "_categoryIDNum, rowID))
				q:(rowID = "")
				s objItem = ##Class(EPRmeta.CentralizedPrint.CentralizedPrintItem).%OpenId(rowID)
				s desc = objItem.CategoryDesc_"."_objItem.CategoryDesc 	
			}
			else
			{
				s cgID = $p(category,"#",3)
				s ccID = $p(category,"#",4)
				s cgDesc = ..GetEPRTemplateCategoryDesc(cgID)
				s ccDesc = ..GetEPRTemplateCategoryDesc(ccID)
				s desc = cgDesc_"."_ccDesc
			}
			
			if (descAll = "")
			{
				s descAll = desc
			}
			else 
			{
				s descAll = descAll_" | "_desc
			}
		}
		
		if (count>1) w ","
		w "{"
		w "UserName:'"_userName_"'"
		w ",UserID:'"_userID_"'"
		w ",RegisterNo:'"_registerno_"'"
		w ",PatientName:'"_patientName_"'"
		w ",PatientID:'"_patientID_"'"
		w ",StartDateTime:'"_startDateTime_"'"
		w ",FinishDateTime:'"_finishDateTime_"'"
		w ",DescAll:'"_descAll_"'"
		w "}"	
 	}
}

/// 登记号补零
ClassMethod AddZero(ARegisterNo As %String) As %String
{
	s tmpRegNo=""
	s papmiDR=""
	s adm="0"
	s adm=$o(^PAADM(adm))
	s papmiDR = ##class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiDR(adm)
    s tmpRegNo=$P($g(^PAPER(papmiDR,"PAT",1)),"^",1)
	s length = $l(tmpRegNo)
	q:(length = $l(ARegisterNo)) ARegisterNo
	for index=1:1:(length - $l(ARegisterNo)) {
	s ARegisterNo = "0"_ARegisterNo
	}
	q ARegisterNo
}

/// Desc:	07病历文书下的模板目录的文字描述
/// Input：	ACategoryChapterDocID - 模板目录ID	
/// Output: ccDesc - 模板目录的文字描述
ClassMethod GetEPRTemplateCategoryDesc(ACategoryChapterDocID As %String) As %String
{
	s obj = ##Class(EPRmeta.EPRTemplateCategory).%OpenId(ACategoryChapterDocID)
	q:(obj = "") ""
	s ccDesc = obj.CategoryName
	s ccDesc = $tr(ccDesc, $c(10), "")
	s ccDesc = $tr(ccDesc, $c(13), "")
	s ccDesc = $tr(ccDesc, "'", "")
	
	q ccDesc
}

}
