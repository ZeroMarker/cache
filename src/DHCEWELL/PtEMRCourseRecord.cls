Class DHCEWELL.PtEMRCourseRecord Extends (%RegisteredObject, %XML.Adaptor)
{

ClassMethod GetDatasByGlossaryTemplateID(AEpisodeID As %String, ATemplateID As %String)
{
	
	s InstanceIDS =##Class(EMRservice.BL.BLGlossary).GetInstancesByEpisodeTemID(AEpisodeID,ATemplateID)
	s intInsCount = $ll(InstanceIDS)
	for i = 1:1:intInsCount
	{
		s AInstanceID = $lg(InstanceIDS,i)
		continue:(AInstanceID="")
		s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(strInstanceID)
		continue:((objInstance = "")||(objInstance.Status '= "Save"))
		S PatientNO = ""
		S RECORDDATE =$zd(objInstance.HappenDate,3)_" "_$zt(objInstance.HappenTime)  
		S TYPE = objInstance.Title
		s CODE  =""
		s NAME = objInstance.Title
		s COURSECONTENT = ""
		s ContentText = ##class(EMRservice.BL.BLScatterData).GetDataByGlossary(AEpisodeID,"HDSD00.11.050",AInstanceID)
		s CREATEDATE = $zd(objInstance.CreateDate,3)_" "_$zt(objInstance.CreateTime)
		s UPDATEDATE =  $zd(objInstance.ModifyDate,3)_" "_$zt(objInstance.ModifyTime)
		
		s DeptName = ""
		s DoctorName = ""
		s SXYS = objInstance.CreateUser
		s SSUSRRowId = $o(^SSU("SSUSR",0,"SSUSR_Initials",SXYS,""))
		if (SSUSRRowId'="") 
		{
			s DoctorName = $p($g(^SSU("SSUSR",SSUSRRowId)),"^",2) //书写医生姓名
		}
	}
}

/// Creator:	yejian
/// CreatDate:  2017-9-11
/// Desc:		电子病历信息
/// Input：		DateFrom：开始时间，DateTo：结束时间
/// Debug:		d ##Class(%ResultSet).RunQuery("DHCEWELL.PtEMRView","PtEMRView","2017-6-18","2017-6-30")
Query PtEMRView(DateFrom As %String, DateTo As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "JLXH,JGDM,PHRID,JZLSH,MZBZ,BLLB,BLMC,BLRQ,WCSJ,ASWC,SXYS,SXYSXM,SXKS,SXKSMC,SHYS,SHYSXM,BLLSH,BLNRLB,BLWJMC,BLWJNR,BLWJLJ,SZQMSJ,SZQMZY,ZYH,BAH,YLFKFS,RYRQ,CYRQ,BLH,XGBZ") [ SqlProc ]
{
}

ClassMethod PtEMRViewExecute(ByRef qHandle As %Binary, DateFrom As %String, DateTo As %String) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	q:(($g(DateFrom) = "")||($g(DateTo)= "")) $$$OK
	
	s AGlossaryCategoryID = "HDSD00.16"
	s StartDate	= $g(DateFrom)
	s EndDate	= $g(DateTo)
	s StartDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(StartDate)," ",1)
	s EndDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(EndDate)," ",1)
	i EndDate<StartDate Set qHandle=$lb(0,repid,0)	Quit $$$OK
	s strPath = "http://10.195.236.80/dthealth/web/csp/epr.newfw.episodelistbrowser.csp?EpisodeID={0}&USERNAME=admin&PASSWORD=123"
	s AEpisodeID=""
	
	f tmpdate=+StartDate:1:+EndDate
	{
		s strInstanceID = ""
		s strInsID = ""
		for {
			s strInsID = $o(^DHCEPRI.InstanceDataI("IdxModifyDate",tmpdate,strInsID))
			q:(strInsID = "")
			s strNub = ""
			for {
				s strNub = $o(^DHCEPRI.InstanceDataI("IdxModifyDate",tmpdate,strInsID,strNub))
				q:(strNub = "")
				s strInstanceID = strInsID _"||"_strNub
				s objInstance = ##Class(EPRinstance.InstanceData).%OpenId(strInstanceID)
				continue:((objInstance = "")||(objInstance.Status '= "Save"))
				s objEcRecord = ##Class(EPRinstance.ECRecord).%OpenId(strInsID)
				s AEpisodeID=objEcRecord.EpisodeID.%Id()
				//s AEpisodeID= $o(^PAADMi("DischDate",tmpdate,AEpisodeID))
				//s StandDataArry = ..GetDataByGlossaryCategory(AEpisodeID,AGlossaryCategoryID)
				s (JLXH,JGDM,PHRID,JZLSH,MZBZ,BLLB,BLMC,BLRQ,WCSJ,ASWC,SXYS,SXYSXM,SXKS,SXKSMC,SHYS,SHYSXM,BLLSH,BLNRLB,BLWJMC,BLWJNR,BLWJLJ,SZQMSJ,SZQMZY,ZYH,BAH,YLFKFS,RYRQ,CYRQ,BLH,XGBZ)=""
	
				s JLXH= AEpisodeID //记录序号
				s JGDM= "" //机构代码
				s PHRID= "" //档案编号
				s strJZLSH = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiDR(AEpisodeID)
				s JZLSH= strJZLSH //就诊流水号
				s strMZBZ = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetEpisodeType(AEpisodeID)
				s MZBZ= $case(strMZBZ,"I":"2",:"1") //门诊住院标志
				s BLLB= objInstance.Title //病历类别
				s BLMC= objInstance.Title //病历名称
				s strBLRQ = $zd(objInstance.CreateDate,3)_" "_$zt(objInstance.CreateTime)
				s BLRQ= strBLRQ //病历时间
				s strWCSJ =  $zd(objInstance.ModifyDate,3)_" "_$zt(objInstance.ModifyTime)
				s WCSJ= strWCSJ //完成时间
				s ASWC= "1" //按时完成
				s SXYS= objInstance.CreateUser //书写医生
				s SSUSRRowId = $o(^SSU("SSUSR",0,"SSUSR_Initials",SXYS,""))
				if (SSUSRRowId'="") 
				{
					s SXYSXM = $p($g(^SSU("SSUSR",SSUSRRowId)),"^",2) //书写医生姓名
				}
				s SXKS= "" //书写科室
				s SXKSMC= "" //书写科室名称
				s SHYS= "" //审核医生
				s SHYSXM= "" //审核医生姓名
				s BLLSH= strInstanceID //病历流水号
				s BLNRLB= "xml" //病历内容类别
				s BLWJMC= objInstance.Title //病历文件名称
				s BLWJNR= "" //病历文件内容
				s BLWJLJ= $REPLACE(strPath,"{0}",AEpisodeID) //病历文件路径
				s SZQMSJ= "" //病历文件数字签名时间戳
				s SZQMZY= "" // 病历文件数字签名摘要
				s ZYH= AEpisodeID //住院号
				s strBAH = ##class(EPRservice.HISInterface.PatientInfoAssist).IPRecordNoByMRNew(AEpisodeID,"")
				s BAH= strBAH //病案号
				s YLFKFS= "" //医疗付款方式
				s strRYRQ=##class(EPRservice.HISInterface.PatientInfoAssist).AdmDateTimeInBed(AEpisodeID,"")
				if (strRYRQ'="")
				{
					s strRYRQ=$p(strRYRQ,",",1)
					s RYRQ= $zd(strRYRQ,3) //入院日期
				}
				s strCYRQ=##class(EPRservice.HISInterface.PatientInfoAssist).DisDateTime(AEpisodeID)
				if (strCYRQ'="")
				{
					s strCYRQ=$p(strCYRQ,",",1)
					s CYRQ= $zd(strCYRQ,3) //出院日期
				}
				s BLH= strInstanceID //病历号
				s XGBZ= "1" //修改标志






				s Data = $lb(JLXH,JGDM,PHRID,JZLSH,MZBZ,BLLB,BLMC,BLRQ,WCSJ,ASWC,SXYS,SXYSXM,SXKS,SXKSMC,SHYS,SHYSXM,BLLSH,BLNRLB,BLWJMC,BLWJNR,BLWJLJ,SZQMSJ,SZQMZY,ZYH,BAH,YLFKFS,RYRQ,CYRQ,BLH,XGBZ)
				s ^CacheTemp(repid,ind) = Data
				s ind = ind + 1
			}
		}
	}
	q $$$OK
}

ClassMethod PtEMRViewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PtEMRViewExecute ]
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

ClassMethod PtEMRViewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PtEMRViewExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

}
