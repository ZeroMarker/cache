Class DHCEPRFS.BL.HISInfo.BLNurseInfo Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Desc:	是否有会诊单需要打印 6365840
/// Debug:	w ##Class(DHCEPRFS.BL.HISInfo.BLNurseInfo).HasConsultToPrint("5366809")
ClassMethod HasConsultToPrint(AEpisodeID) As %String
{
	s adm=AEpisodeID
	 q:adm="" ""
            s ret=0
			s id="" f  s id=$O(^User.DHCConsultationI("Adm"," "_adm,id)) q:(id="")||(ret=1)  d
			.s a=^User.DHCConsultationD(id)
			.s status=$listget(a,16)
			.s:status="E" ret=1
	
	;s printInfo = ##Class(User.DHCNURMoudelLink).GetAdmConsult(AEpisodeID)
	;q:(printInfo '= "") "1"
	;q "0"
  q ret
}

/// Desc:	是否有产程图需要打印
/// Debug:	w ##Class(DHCEPRFS.BL.HISInfo.BLNurseInfo).HasBirthGraph("5366809")
ClassMethod HasBirthGraph(AEpisodeID) As %String
{
	q ##class(Nur.NIS.Service.Labor.Handler).ifNeedPrintLabor(AEpisodeID)
	/**s printInfo = ##class(web.DHCCurveOperation).HasBirthGraph(AEpisodeID)
	
	s hospitalFlag = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("HospitalFlag")	
	if (hospitalFlag = "NYFY")
    {
		s isNormalBirth=##Class(web.DHCCurveOperation).IsNormalBirth(AEpisodeID)
		q:(isNormalBirth = "0") "0"
    }
    
	q:(printInfo '= "0") "1"
	q "0"*/
}

/// Desc: 是否有产时记录
/// Debug: w ##class(DHCEPRFS.BL.HISInfo.BLNurseInfo).ifHaveRecord("")
ClassMethod ifHaveRecord(AEpisodeID As %String) As %String
{
	q ##class(Nur.NIS.Service.Labor.Handler).ifHaveRecord(AEpisodeID)
}

/// Desc:	是否有体温单需要打印
/// w ##class(web.DHCNurseInterface).HasTemperature(6253695)
/// Debug:	w ##Class(DHCEPRFS.BL.HISInfo.BLNurseInfo).HasTemperatureToPrint("5366809")
ClassMethod HasTemperatureToPrint(AEpisodeID) As %String
{
	//s printInfo = ##class(web.DHCNurseInterface).HasTemperature(AEpisodeID)
	s printInfo = ##class(Nur.NIS.Service.Chart.DAO.Chart).HasTemperature(AEpisodeID)
	q:(printInfo '= "0") "1"
	q "0"
}

/// Desc:	是否有护理记录单需要打印
/// w ##class(web.DHCNurseInterface).HasNurseCare(6253695)
/// Debug:	w ##Class(DHCEPRFS.BL.HISInfo.BLNurseInfo).HasNurseCareToPrint("5366809")
ClassMethod HasNurseCareToPrint(AEpisodeID) As %String
{
	s printInfo = ##class(web.DHCNurseInterface).HasNurseCare(AEpisodeID)
	q:(printInfo '= "0") "1"
	q "0"
}

/// Desc:	是否有日常生活能力评分需要打印
/// w ##class(web.DHCNurseInterface).HasNurseCare(6253695)
/// Debug:	w ##Class(DHCEPRFS.BL.HISInfo.BLNurseInfo).HasNurseSHPFToPrint("5366809")
ClassMethod HasNurseSHPFToPrint(AEpisodeID) As %String
{
	s printInfo = ##class(web.DHCNurseInterface).HasNurseSHPF(AEpisodeID)
	q:(printInfo '= "0") "1"
	q "0"
}

/// Desc:	是否有疼痛评分需要打印
/// Debug:	w ##Class(DHCEPRFS.BL.HISInfo.BLNurseInfo).HasTouchGraph("5366809")
ClassMethod HasTouchGraph(AEpisodeID) As %String
{
	//s printInfo = ##class(web.DHCCurveOperation).HasBirthGraph(AEpisodeID)
	s printInfo = ##class(web.DHCNUREMRNE2OnPage).GetNRS4EPRQueue(AEpisodeID)

	q:(printInfo '= "") "1"
	q "0"
}

/// Desc:	是否有静脉血栓栓塞需要打印
/// w ##class(web.DHCNurseInterface).HasNurseXSMult(18859938)
/// Debug:	w ##Class(DHCEPRFS.BL.HISInfo.BLNurseInfo).HasNurseXSMultToPrint("5366809")
ClassMethod HasNurseXSMultToPrint(AEpisodeID) As %String
{
	s printInfo = ##class(web.DHCNurseInterface).HasNurseXSMult(AEpisodeID)
	q:(printInfo '= "0") "1"
	q "0"
}

/// Creator: LMM
/// CreatDate: 208-03-13
/// Description: 判断病人是否有血糖数据
/// Input：就诊号
/// Return：1 有 0 无
/// Debug:	w ##Class(DHCEPRFS.BL.HISInfo.BLNurseInfo).HasNurseSHPFToPrint("4469246")
ClassMethod HasBloodGlucoseToPrint(EpisodeID As %String)
{
	s flag=0
    s BGRRstlDate=0	
	
	f  s BGRRstlDate=$O(^DHCNurBGR(0,"PatDate",EpisodeID,BGRRstlDate)) q:BGRRstlDate=""||(flag=1)  d
	.s BGRRowId=0
	.f  s BGRRowId=$O(^DHCNurBGR(0,"PatDate",EpisodeID,BGRRstlDate,BGRRowId)) q:BGRRowId=""||(flag=1)  d
	..s RsltManualInput=$p($g(^DHCNurBGR(BGRRowId)),"^",35)		
	..q:RsltManualInput'="Y" 	
	..s flag=1
	q flag
}

/// Debug:	w ##Class(DHCEPRFS.BL.HISInfo.BLNurseInfo).GetNurInfoByCode("DHCNURPGD_FMJLDNew")	
ClassMethod GetNurInfoByCode(ATypeCode As %String)
{
	q:(ATypeCode = "") ""
	s ATypeCode = $tr(ATypeCode,"")

	
	s ret = ""
	
	s rowID = ""
	for {
		s rowID = $o(^User.DHCNURMoudelLinkI("CodeIndex"," "_$ZCVT(ATypeCode,"U"),rowID))	
		q:(rowID = "") 
	

		s obj = ##class(User.DHCNURMoudelLink).%OpenId(rowID)
		s printCode = obj.PrintCode
		s type = obj.typ
		
		continue:(printCode = "DHCNurPrnMouldZH42")
	
		if (ret = "")
		{
			s ret = ATypeCode_"^"_printCode_"^"_type
		}
		else
		{
			s ret = ret_"|"_ATypeCode_"^"_printCode_"^"_type
		}
	}
	q ret
}

/// Debug:	w ##Class(DHCEPRFS.BL.HISInfo.BLNurseInfo).HasNurseRecordByTypeCode("12569109","DHCNURZHF25")	
ClassMethod HasNurseRecordByTypeCode(AEpisodeID As %String, ATypeCode As %String = "")
{
	s ret = 0
	//DHCNURZH14^DHCNurPrnMouldZH14^表格记录单|DHCNURZH17^DHCNURMouldPrn_SJWKHLJLDDY^表格记录单
	s retNurStr = ##class(User.DHCNURMoudelLink).GetPerModel(AEpisodeID)
	for index=1:1:$l(retNurStr,"|")
	{
		s oneNur = $p(retNurStr,"|",index)
		if (oneNur '= "")
		{
			s oneCode = $p(oneNur,"^",1)
			if (oneCode = ATypeCode)	
			{
				s ret = 1	
			}
		}	
	}
	q ret
}

ClassMethod GetNewSet() As %String
{
   //s a=##class(Nur.DHCMGNurseSet).getSet()
	s id=$O(^Nur.DHCMGNurseNewSetD(""))
	if id="" q ""
	s db=$ListGet(^Nur.DHCMGNurseNewSetD(id),2)
	s websv=$ListGet(^Nur.DHCMGNurseNewSetD(id),3)
	s genpath=$ListGet(^Nur.DHCMGNurseNewSetD(id),4)
	q db_"^"_websv_"^"_genpath
}

ClassMethod GetPatInfo(AEpisodeID As %String) As %String
{
	s patInfo = ##class(web.DHCMGNurComm).PatInfo(AEpisodeID)
	q patInfo
}

ClassMethod GetId(AEmrCode As %String, AEpisodeID As %String) As %String
{
	s patInfo = ##class(Nur.DHCMoudDataSub).GetId(AEmrCode,AEpisodeID)
	q patInfo
}

ClassMethod GetPerModel(AEpisodeID As %String) As %String
{
	s ret = ##class(User.DHCNURMoudelLink).GetPerModel(AEpisodeID)
	q ret
}

/// Create: 2023-2-12 yangshun
/// Desc:  根据Type判断是否需要打印对应的护理病历,Type为空表示合并打印护理病历时判断是否需要打印
/// Desc: XT 为护理的血糖类型，使用06B的csp路径，但判断方法不一样，这里做特殊处理
/// Debug: w ##class(DHCEPRFS.BL.HISInfo.BLNurseInfo).HasNURToPrint("","")
ClassMethod HasNURToPrint(AEpisodeID As %String, AType As %String) As %String
{
	if (AType="XT")
	{
		q ##Class(Nur.Interface.OutSide.Temperature).HasBGData(AEpisodeID) 
	}
	q ##Class(NurMp.Print.FileMedRec).HasNurseCareNew(AEpisodeID,AType)
}

}
