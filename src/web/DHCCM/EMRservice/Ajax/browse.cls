Class web.DHCCM.EMRservice.Ajax.browse Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s $zt = "ErrorHandler"
	s action = $Get(%request.Data("Action",1),"")
	s ctLocId = $Get(%request.Data("CTLocID",1),"")	
	s schemType = $Get(%request.Data("SchemType",1),"")
	s episodeId = $Get(%request.Data("EpisodeID",1),"")
	if (action = "GetCategory")
	{
		s result = ##Class(EMRservice.BL.BLClientCategory).GetBrowseCategory(ctLocId,schemType,episodeId)
		w "["_result_"]"
	}
	elseif (action = "GetBrowseStatus") //病历状态
	{
		 s IsEMR = ($d(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID"," "_episodeId))>0)
		 s IsPDF = 0
		 s disDateTime = ##class(EMRservice.HISInterface.PatientInfoAssist).DisDateTime(episodeId)
		 s schemType = $case(disDateTime,"":"Running",:"Archiving")
		 w "{'IsEMR':'"_IsEMR_"','IsPDF':'"_IsPDF_"','SchemeType':'"_schemType_"'}"
	}
	elseif (action = "GetHisData")
	{
		s json = ""
		s count = 0
		s num = ""
		for
		{
			s num = $o(^DHCEMRM.EPRPageURLI("IdxNum",num))
			q:(num = "")
			s rowId = ""
			for
			{
				s rowId = $o(^DHCEMRM.EPRPageURLI("IdxNum",num,rowId))
				q:(rowId = "")||(rowId>5)
				s objUrl = ##Class(EMRmeta.EPRPageURL).%OpenId(rowId)
				continue:(objUrl = "")
				s:(count '= 0) json = json_","
				s json = json_"{"
				s json = json_"'title':'"_objUrl.Title_"'"
				s json = json_",'url':'"_objUrl.URL_"?"_objUrl.Paras_"'"
				s json = json_"}"
				s count = count + 1
			}
		}
		w "["_json_"]"
	} 
	Quit $$$OK
ErrorHandler
	q "[]"
}

}
