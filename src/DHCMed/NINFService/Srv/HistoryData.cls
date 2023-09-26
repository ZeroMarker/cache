/// 名称: DHCMed.NINFService.Srv.HistoryData
/// 描述: 公用方法
/// 编写者：zhufei
/// 编写日期: 2012-07-01
Class DHCMed.NINFService.Srv.HistoryData Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// w ##Class(DHCMed.NINFService.Srv.HistoryData).ChangeUCData()
ClassMethod ChangeUCData()
{
	New
	
	Set RowID=0,Count=0
	For {
		Set RowID=$o(^DHCMed.InfAim.CatheterD(RowID))
		Quit:RowID=""
		
		Set Count=Count+1
		
		Set objTmp=##class(DHCMed.InfAim.Catheter).GetObjById(RowID)
		Continue:'$IsObject(objTmp)
		
		Set ParRef=objTmp.InfAimRepDR
		Set objParRef=##class(DHCMed.InfAim.Report).GetObjById(ParRef)
		Continue:'$IsObject(objParRef)
		Set EpisodeID=objParRef.PaadmDR
		Set TransID=objParRef.TransSubID
		
		Set xTmpTrans=$g(^PAADM(EpisodeID,"TRANS",TransID))
		Continue:xTmpTrans=""
		Set RepLoc=$p(xTmpTrans,"^",6)
		
		Set xTransID=TransID,TransLoc=""
		For {
			Set xTransID=$o(^PAADM(EpisodeID,"TRANS",xTransID))
			Quit:xTransID=""
			Quit:TransLoc'=""
			
			Set xTmpTrans=$g(^PAADM(EpisodeID,"TRANS",xTransID))
			Continue:xTmpTrans=""
			
			Set xTransLocID=$p(xTmpTrans,"^",8)
			Set:xTransLocID'="" xTransLocID=$p(xTransLocID,"||",1)
			Set:xTransLocID'="" xTransLocID=$p($g(^PAWARD(xTransLocID)),"^",5)
			Continue:xTransLocID=""
			
			Set TransID=xTransID
			Set TransLoc=xTransLocID
		}
		Continue:TransLoc=""
		
		Set IntubateDate=objTmp.CatDate
		Set ExtubateDate=objTmp.OutCatDate
		Set UrineBagType=..ChangeDicByCode("NINFAimUCUrineBagType",objTmp.CatType)
		Set IntubateUserTpye=..ChangeDicByCode("NINFAimUCIntubateUserType",objTmp.CatUserType)
		Set InfDate=objTmp.InfDate
		Set InfPyStr=""_$c(3)_objTmp.Pathogenic
		Set RepUser=objTmp.RepUser
		Set RepStatus=objTmp.RepStatus
		Set RepDate=objTmp.FirstDate
		
		//保存报告主表信息
		Set InputStr=""
		Set InputStr=InputStr_"^"_"UC"
		Set InputStr=InputStr_"^"_EpisodeID
		Set InputStr=InputStr_"^"_EpisodeID_"||"_TransID
		Set InputStr=InputStr_"^"_TransLoc
		Set InputStr=InputStr_"^"_""
		Set InputStr=InputStr_"^"_""
		Set InputStr=InputStr_"^"_""
		Set InputStr=InputStr_"^"_""
		Set InputStr=InputStr_"^"_""
		Set InputStr=InputStr_"^"_RepLoc
		Set InputStr=InputStr_"^"_RepUser
		Set InputStr=InputStr_"^"_RepStatus
		Set flg=##Class(DHCMed.NINFService.Rep.AimReport).SaveReport(InputStr,"^")
		If (+flg)<1 {
			Set num=$i(^ZF("UCError1"))
			Set ^ZF("UCError1",num)=InputStr
			Continue
		}
		Set RepID=+flg
		
		//保存子表信息
		Set InputStr=RepID
		Set InputStr=InputStr_"^"_""
		Set InputStr=InputStr_"^"_IntubateDate
		Set InputStr=InputStr_"^"_ExtubateDate
		Set InputStr=InputStr_"^"_UrineBagType
		Set InputStr=InputStr_"^"_IntubateUserTpye
		Set InputStr=InputStr_"^"_""
		Set InputStr=InputStr_"^"_InfDate
		Set InputStr=InputStr_"^"_InfPyStr
		Set InputStr=InputStr_"^"_RepLoc
		Set InputStr=InputStr_"^"_RepUser
		Set InputStr=InputStr_"^"_RepStatus
		Set flg=##Class(DHCMed.NINFService.Rep.AimReportUC).SaveReport(InputStr,"^")
		If (+flg)<1 {
			Set num=$i(^ZF("UCError2"))
			Set ^ZF("UCError2",num)=InputStr
		} Else {
			Set objSub=##Class(DHCMed.NINF.Rep.AimReportUC).%OpenId(flg)
			If (objSub) {
				Set objSub.RepDate=RepDate
				Set objSub.RepTime=0
				Set sc=objSub.%Save()
				If $System.Status.IsError(sc) {  //检查Save是否成功
			   		Do $System.OBJ.DisplayError(sc)
				}
				Do objSub.%Close()
			}
		}
	}
	
	Quit Count
}

/// w ##Class(DHCMed.NINFService.Srv.HistoryData).ChangePICCData()
ClassMethod ChangePICCData()
{
	New
	
	Set RowID=0,Count=0
	For {
		Set RowID=$o(^DHCMed.InfAim.PipeD(RowID))
		Quit:RowID=""
		
		Set Count=Count+1
		
		Set objTmp=##class(DHCMed.InfAim.Pipe).GetObjById(RowID)
		Continue:'$IsObject(objTmp)
		
		Set ParRef=objTmp.InfAimRepDR
		Set objParRef=##class(DHCMed.InfAim.Report).GetObjById(ParRef)
		Continue:'$IsObject(objParRef)
		Set EpisodeID=objParRef.PaadmDR
		Set TransID=objParRef.TransSubID
		
		Set xTmpTrans=$g(^PAADM(EpisodeID,"TRANS",TransID))
		Continue:xTmpTrans=""
		Set RepLoc=$p(xTmpTrans,"^",6)
		
		Set xTransID=TransID,TransLoc=""
		For {
			Set xTransID=$o(^PAADM(EpisodeID,"TRANS",xTransID))
			Quit:xTransID=""
			Quit:TransLoc'=""
			
			Set xTmpTrans=$g(^PAADM(EpisodeID,"TRANS",xTransID))
			Continue:xTmpTrans=""
			
			Set xTransLocID=$p(xTmpTrans,"^",8)
			Set:xTransLocID'="" xTransLocID=$p(xTransLocID,"||",1)
			Set:xTransLocID'="" xTransLocID=$p($g(^PAWARD(xTransLocID)),"^",5)
			Continue:xTransLocID=""
			
			Set TransID=xTransID
			Set TransLoc=xTransLocID
		}
		Continue:TransLoc=""
		
		Set IntubateDateTime=objTmp.PipeDate
		Set ExtubateDateTime=objTmp.OutPipeDate
		Set IntubatePos=..ChangeDicByCode("NINFAimPICCIntubatePos",objTmp.PipePos)
		Set IntubateSize=..ChangeDicByCode("NINFAimPICCIntubateSize",objTmp.PipeSize)
		Set IntubateType=..ChangeDicByCode("NINFAimPICCIntubateType",objTmp.PipeType)
		Set IntubateNum=..ChangeDicByCode("NINFAimPICCIntubateNum",objTmp.PipeNum)
		Set IntubateRegion=..ChangeDicByCode("NINFAimPICCIntubateRegion",objTmp.PipeRegion)
		Set IntubatePlace=..ChangeDicByCode("NINFAimPICCIntubatePlace",objTmp.PipePlace)
		Set ExtubateReason=..ChangeDicByCode("NINFAimPICCExtubateReason",objTmp.OutPipeReason)
		Set IntubateUserTpye=..ChangeDicByCode("NINFAimPICCIntubateUserType",objTmp.PipeUser)
		Set InfDate=objTmp.InfDate
		Set InfPyStr=""_$c(3)_objTmp.Pathogenic
		Set RepUser=objTmp.RepUser
		Set RepStatus=objTmp.RepStatus
		Set RepDate=objTmp.FirstDate
		
		//保存报告主表信息
		Set InputStr=""
		Set InputStr=InputStr_"^"_"PICC"
		Set InputStr=InputStr_"^"_EpisodeID
		Set InputStr=InputStr_"^"_EpisodeID_"||"_TransID
		Set InputStr=InputStr_"^"_TransLoc
		Set InputStr=InputStr_"^"_""
		Set InputStr=InputStr_"^"_""
		Set InputStr=InputStr_"^"_""
		Set InputStr=InputStr_"^"_""
		Set InputStr=InputStr_"^"_""
		Set InputStr=InputStr_"^"_RepLoc
		Set InputStr=InputStr_"^"_RepUser
		Set InputStr=InputStr_"^"_RepStatus
		Set flg=##Class(DHCMed.NINFService.Rep.AimReport).SaveReport(InputStr,"^")
		If (+flg)<1 {
			Set num=$i(^ZF("PICCError1"))
			Set ^ZF("PICCError1",num)=InputStr
			Continue
		}
		Set RepID=+flg
		
		//保存子表信息
		Set InputStr=RepID
		Set InputStr=InputStr_"^"_""
		Set InputStr=InputStr_"^"_IntubateDateTime
		Set InputStr=InputStr_"^"_ExtubateDateTime
		Set InputStr=InputStr_"^"_IntubatePos
		Set InputStr=InputStr_"^"_IntubateSize
		Set InputStr=InputStr_"^"_IntubateType
		Set InputStr=InputStr_"^"_IntubateNum
		Set InputStr=InputStr_"^"_IntubateRegion
		Set InputStr=InputStr_"^"_IntubatePlace
		Set InputStr=InputStr_"^"_ExtubateReason
		Set InputStr=InputStr_"^"_IntubateUserTpye
		Set InputStr=InputStr_"^"_""
		Set InputStr=InputStr_"^"_InfDate
		Set InputStr=InputStr_"^"_InfPyStr
		Set InputStr=InputStr_"^"_RepLoc
		Set InputStr=InputStr_"^"_RepUser
		Set InputStr=InputStr_"^"_RepStatus
		Set flg=##Class(DHCMed.NINFService.Rep.AimReportPICC).SaveReport(InputStr,"^")
		If (+flg)<1 {
			Set num=$i(^ZF("PICCError2"))
			Set ^ZF("PICCError2",num)=InputStr
		} Else {
			Set objSub=##Class(DHCMed.NINF.Rep.AimReportPICC).%OpenId(flg)
			If (objSub) {
				Set objSub.RepDate=RepDate
				Set objSub.RepTime=0
				Set sc=objSub.%Save()
				If $System.Status.IsError(sc) {  //检查Save是否成功
			   		Do $System.OBJ.DisplayError(sc)
				}
				Do objSub.%Close()
			}
		}
	}
	
	Quit Count
}

/// w ##Class(DHCMed.NINFService.Srv.HistoryData).ChangeVAPData()
ClassMethod ChangeVAPData()
{
	New
	
	Set RowID=0,Count=0
	For {
		Set RowID=$o(^DHCMed.InfAim.VentilatorD(RowID))
		Quit:RowID=""
		
		Set Count=Count+1
		
		Set objTmp=##class(DHCMed.InfAim.Ventilator).GetObjById(RowID)
		Continue:'$IsObject(objTmp)
		
		Set ParRef=objTmp.InfAimRepDR
		Set objParRef=##class(DHCMed.InfAim.Report).GetObjById(ParRef)
		Continue:'$IsObject(objParRef)
		Set EpisodeID=objParRef.PaadmDR
		Set TransID=objParRef.TransSubID
		
		Set xTmpTrans=$g(^PAADM(EpisodeID,"TRANS",TransID))
		Continue:xTmpTrans=""
		Set RepLoc=$p(xTmpTrans,"^",6)
		
		Set xTransID=TransID,TransLoc=""
		For {
			Set xTransID=$o(^PAADM(EpisodeID,"TRANS",xTransID))
			Quit:xTransID=""
			Quit:TransLoc'=""
			
			Set xTmpTrans=$g(^PAADM(EpisodeID,"TRANS",xTransID))
			Continue:xTmpTrans=""
			
			Set xTransLocID=$p(xTmpTrans,"^",8)
			Set:xTransLocID'="" xTransLocID=$p(xTransLocID,"||",1)
			Set:xTransLocID'="" xTransLocID=$p($g(^PAWARD(xTransLocID)),"^",5)
			Continue:xTransLocID=""
			
			Set TransID=xTransID
			Set TransLoc=xTransLocID
		}
		Continue:TransLoc=""
		
		Set IntubateDateTime=objTmp.VenDate
		Set ExtubateDateTime=objTmp.OutVenDate
		Set IntubatePlace=..ChangeDicByCode("NINFAimVAPIntubatePlace",objTmp.VenPlace)
		Set IntubateType=..ChangeDicByCode("NINFAimVAPIntubateType",objTmp.VenType)
		Set IntubateUserType=..ChangeDicByCode("NINFAimVAPIntubateUserType",objTmp.VenUserType)
		Set InfDate=objTmp.InfDate
		Set InfPyStr=""_$c(3)_objTmp.Pathogenic
		Set RepUser=objTmp.RepUser
		Set RepStatus=objTmp.RepStatus
		Set RepDate=objTmp.FirstDate
		
		//保存报告主表信息
		Set InputStr=""
		Set InputStr=InputStr_"^"_"VAP"
		Set InputStr=InputStr_"^"_EpisodeID
		Set InputStr=InputStr_"^"_EpisodeID_"||"_TransID
		Set InputStr=InputStr_"^"_TransLoc
		Set InputStr=InputStr_"^"_""
		Set InputStr=InputStr_"^"_""
		Set InputStr=InputStr_"^"_""
		Set InputStr=InputStr_"^"_""
		Set InputStr=InputStr_"^"_""
		Set InputStr=InputStr_"^"_RepLoc
		Set InputStr=InputStr_"^"_RepUser
		Set InputStr=InputStr_"^"_RepStatus
		Set flg=##Class(DHCMed.NINFService.Rep.AimReport).SaveReport(InputStr,"^")
		If (+flg)<1 {
			Set num=$i(^ZF("VAPError1"))
			Set ^ZF("VAPError1",num)=InputStr
			Continue
		}
		Set RepID=+flg
		
		//保存子表信息
		Set InputStr=RepID
		Set InputStr=InputStr_"^"_""
		Set InputStr=InputStr_"^"_IntubateDateTime
		Set InputStr=InputStr_"^"_ExtubateDateTime
		Set InputStr=InputStr_"^"_IntubatePlace
		Set InputStr=InputStr_"^"_IntubateUserType
		Set InputStr=InputStr_"^"_""
		Set InputStr=InputStr_"^"_IntubateType
		Set InputStr=InputStr_"^"_InfDate
		Set InputStr=InputStr_"^"_InfPyStr
		Set InputStr=InputStr_"^"_RepLoc
		Set InputStr=InputStr_"^"_RepUser
		Set InputStr=InputStr_"^"_RepStatus
		Set flg=##Class(DHCMed.NINFService.Rep.AimReportVAP).SaveReport(InputStr,"^")
		If (+flg)<1 {
			Set num=$i(^ZF("VAPError2"))
			Set ^ZF("VAPError2",num)=InputStr
		} Else {
			Set objSub=##Class(DHCMed.NINF.Rep.AimReportVAP).%OpenId(flg)
			If (objSub) {
				Set objSub.RepDate=RepDate
				Set objSub.RepTime=0
				Set sc=objSub.%Save()
				If $System.Status.IsError(sc) {  //检查Save是否成功
			   		Do $System.OBJ.DisplayError(sc)
				}
				Do objSub.%Close()
			}
		}
	}
	
	Quit Count
}

/// w ##Class(DHCMed.NINFService.Srv.HistoryData).ChangeNICUData()
ClassMethod ChangeNICUData()
{
	New
	
	Set RowID=0,Count=0
	For {
		Set RowID=$o(^DHCMed.InfAim.NICUD(RowID))
		Quit:RowID=""
		
		Set Count=Count+1
		
		Set objTmp=##class(DHCMed.InfAim.NICU).GetObjById(RowID)
		Continue:'$IsObject(objTmp)
		
		Set ParRef=objTmp.InfAimRepDR
		Set objParRef=##class(DHCMed.InfAim.Report).GetObjById(ParRef)
		Continue:'$IsObject(objParRef)
		Set EpisodeID=objParRef.PaadmDR
		Set TransID=objParRef.TransSubID
		
		Set xTmpTrans=$g(^PAADM(EpisodeID,"TRANS",TransID))
		Continue:xTmpTrans=""
		Set RepLoc=$p(xTmpTrans,"^",6)
		
		Set xTransID=TransID,TransLoc=""
		For {
			Set xTransID=$o(^PAADM(EpisodeID,"TRANS",xTransID))
			Quit:xTransID=""
			Quit:TransLoc'=""
			
			Set xTmpTrans=$g(^PAADM(EpisodeID,"TRANS",xTransID))
			Continue:xTmpTrans=""
			
			Set xTransLocID=$p(xTmpTrans,"^",8)
			Set:xTransLocID'="" xTransLocID=$p(xTransLocID,"||",1)
			Set:xTransLocID'="" xTransLocID=$p($g(^PAWARD(xTransLocID)),"^",5)
			Continue:xTransLocID=""
			
			Set TransID=xTransID
			Set TransLoc=xTransLocID
		}
		Continue:TransLoc=""
		
		Set BornWeight=objTmp.BornWeight
		Set NUCIntubateDate=objTmp.CatDateFrom
		Set NUCExtubateDate=objTmp.CatDateTo
		Set NUCInfDate=objTmp.InfDate
		Set NUCInfPyStr=""_$c(3)_objTmp.Pathogenic
		Set NPICCIntubateDate=objTmp.PipeDateFrom
		Set NPICCExtubateDate=objTmp.PipeDateTo
		Set NPICCInfDate=objTmp.PipeInfDate
		Set NPICCInfPyStr=""_$c(3)_objTmp.PipePathogenic
		Set NVNTIntubateDate=objTmp.VenDateFrom
		Set NVNTExtubateDate=objTmp.VenDateTo
		Set NVNTInfDate=objTmp.VenInfDate
		Set NVNTInfPyStr=""_$c(3)_objTmp.VenPathogenic
		Set RepUser=objTmp.RepUser
		Set RepStatus=objTmp.RepStatus
		Set RepDate=objTmp.FirstDate
		
		//保存报告主表信息
		Set InputStr=""
		Set InputStr=InputStr_"^"_"NICU"
		Set InputStr=InputStr_"^"_EpisodeID
		Set InputStr=InputStr_"^"_EpisodeID_"||"_TransID
		Set InputStr=InputStr_"^"_TransLoc
		Set InputStr=InputStr_"^"_""
		Set InputStr=InputStr_"^"_""
		Set InputStr=InputStr_"^"_""
		Set InputStr=InputStr_"^"_""
		Set InputStr=InputStr_"^"_BornWeight
		Set InputStr=InputStr_"^"_RepLoc
		Set InputStr=InputStr_"^"_RepUser
		Set InputStr=InputStr_"^"_RepStatus
		Set flg=##Class(DHCMed.NINFService.Rep.AimReport).SaveReport(InputStr,"^")
		If (+flg)<1 {
			Set num=$i(^ZF("NICUError1"))
			Set ^ZF("NICUError1",num)=InputStr
			Continue
		}
		Set RepID=+flg
		
		If NUCIntubateDate'="" {
			//保存子表信息
			Set InputStr=RepID
			Set InputStr=InputStr_"^"_""
			Set InputStr=InputStr_"^"_NUCIntubateDate
			Set InputStr=InputStr_"^"_NUCExtubateDate
			Set InputStr=InputStr_"^"_NUCInfDate
			Set InputStr=InputStr_"^"_NUCInfPyStr
			Set InputStr=InputStr_"^"_RepLoc
			Set InputStr=InputStr_"^"_RepUser
			Set InputStr=InputStr_"^"_RepStatus
			Set flg=##Class(DHCMed.NINFService.Rep.AimReportNUC).SaveReport(InputStr,"^")
			If (+flg)<1 {
				Set num=$i(^ZF("NIUCError2"))
				Set ^ZF("NIUCError2",num)=InputStr
			} Else {
				Set objSub=##Class(DHCMed.NINF.Rep.AimReportNUC).%OpenId(flg)
				If (objSub) {
					Set objSub.RepDate=RepDate
					Set objSub.RepTime=0
					Set sc=objSub.%Save()
					If $System.Status.IsError(sc) {  //检查Save是否成功
				   		Do $System.OBJ.DisplayError(sc)
					}
					Do objSub.%Close()
				}
			}
		}
		If NPICCIntubateDate'="" {
			//保存子表信息
			Set InputStr=RepID
			Set InputStr=InputStr_"^"_""
			Set InputStr=InputStr_"^"_NPICCIntubateDate
			Set InputStr=InputStr_"^"_NPICCExtubateDate
			Set InputStr=InputStr_"^"_NPICCInfDate
			Set InputStr=InputStr_"^"_NPICCInfPyStr
			Set InputStr=InputStr_"^"_RepLoc
			Set InputStr=InputStr_"^"_RepUser
			Set InputStr=InputStr_"^"_RepStatus
			Set flg=##Class(DHCMed.NINFService.Rep.AimReportNPICC).SaveReport(InputStr,"^")
			If (+flg)<1 {
				Set num=$i(^ZF("NIUCError2"))
				Set ^ZF("NIUCError2",num)=InputStr
			} Else {
				Set objSub=##Class(DHCMed.NINF.Rep.AimReportNPICC).%OpenId(flg)
				If (objSub) {
					Set objSub.RepDate=RepDate
					Set objSub.RepTime=0
					Set sc=objSub.%Save()
					If $System.Status.IsError(sc) {  //检查Save是否成功
				   		Do $System.OBJ.DisplayError(sc)
					}
					Do objSub.%Close()
				}
			}
		}
		If NVNTIntubateDate'="" {
			//保存子表信息
			Set InputStr=RepID
			Set InputStr=InputStr_"^"_""
			Set InputStr=InputStr_"^"_NVNTIntubateDate
			Set InputStr=InputStr_"^"_NVNTExtubateDate
			Set InputStr=InputStr_"^"_NVNTInfDate
			Set InputStr=InputStr_"^"_NVNTInfPyStr
			Set InputStr=InputStr_"^"_RepLoc
			Set InputStr=InputStr_"^"_RepUser
			Set InputStr=InputStr_"^"_RepStatus
			Set flg=##Class(DHCMed.NINFService.Rep.AimReportNVNT).SaveReport(InputStr,"^")
			If (+flg)<1 {
				Set num=$i(^ZF("NIUCError2"))
				Set ^ZF("NIUCError2",num)=InputStr
			} Else {
				Set objSub=##Class(DHCMed.NINF.Rep.AimReportNVNT).%OpenId(flg)
				If (objSub) {
					Set objSub.RepDate=RepDate
					Set objSub.RepTime=0
					Set sc=objSub.%Save()
					If $System.Status.IsError(sc) {  //检查Save是否成功
				   		Do $System.OBJ.DisplayError(sc)
					}
					Do objSub.%Close()
				}
			}
		}
	}
	
	Quit Count
}

/// w ##Class(DHCMed.NINFService.Srv.HistoryData).ChangeOPRData()
ClassMethod ChangeOPRData()
{
	New
	
	Set RowID=0,Count=0
	For {
		Set RowID=$o(^DHCMed.InfAim.OperationD(RowID))
		Quit:RowID=""
		
		Set Count=Count+1
		
		Set objTmp=##class(DHCMed.InfAim.Operation).GetObjById(RowID)
		Continue:'$IsObject(objTmp)
		
		Set ParRef=objTmp.InfAimRepDR
		Set objParRef=##class(DHCMed.InfAim.Report).GetObjById(ParRef)
		Continue:'$IsObject(objParRef)
		Set EpisodeID=objParRef.PaadmDR
		Set TransID=objParRef.TransSubID
		
		Set xTmpTrans=$g(^PAADM(EpisodeID,"TRANS",TransID))
		Continue:xTmpTrans=""
		Set RepLoc=$p(xTmpTrans,"^",6)
		
		Set xTransID=TransID,TransLoc=""
		For {
			Set xTransID=$o(^PAADM(EpisodeID,"TRANS",xTransID))
			Quit:xTransID=""
			Quit:TransLoc'=""
			
			Set xTmpTrans=$g(^PAADM(EpisodeID,"TRANS",xTransID))
			Continue:xTmpTrans=""
			
			Set xTransLocID=$p(xTmpTrans,"^",8)
			Set:xTransLocID'="" xTransLocID=$p(xTransLocID,"||",1)
			Set:xTransLocID'="" xTransLocID=$p($g(^PAWARD(xTransLocID)),"^",5)
			Continue:xTransLocID=""
			
			Set TransID=xTransID
			Set TransLoc=xTransLocID
		}
		Continue:TransLoc=""
		
		Set OperationID=""
		Set OperationDesc=objTmp.OpeName
		
		Set OperStartDateTime=objTmp.OpeDate
		Set OperEndDateTime=""
		Set OperTimes=objTmp.OpeLastTime
		
		Set OperCutType=..ChangeDicByCode("NINFAimOPRCutType",objTmp.CutType)
		Set OperASAScore=objTmp.ASAScore
		Set OperNarcosisType=..ChangeDicByCode("NINFAimOPRNarcosisType",objTmp.NarcosisType)
		
		Set (OperationType,OperationType1,OperationType2)=""
		If objTmp.EmerOprFlag=1 {
			Set OperationType=..ChangeDicByCode("NINFAimOPROperType","Y")
		} Else {
			Set OperationType=..ChangeDicByCode("NINFAimOPROperType","N")
		}
		If objTmp.Injury=1 {
			Set OperationType1=..ChangeDicByCode("NINFAimOPROperType1","Y")
		} Else {
			Set OperationType1=..ChangeDicByCode("NINFAimOPROperType1","N")
		}
		If objTmp.Endoscopic=1 {
			Set OperationType2=..ChangeDicByCode("NINFAimOPROperType2","Y")
		} Else {
			Set OperationType2=..ChangeDicByCode("NINFAimOPROperType2","N")
		}
		
		Set OperDoctor=objTmp.FirstOpe
		Set Assistant1=objTmp.AssistantDr1
		Set Assistant2=""
		//麻醉诱导期用药
		Set NarcosisAntiList=objTmp.NarcosisDrug
		Set NarcosisAnti=""
		Set OEOrdItemList=""
		For ind=1:1:$l(NarcosisAntiList,",") {
			Set OEOrdID=$p(NarcosisAntiList,",",ind)
			Continue:OEOrdID=""
			Continue:OEOrdID'["||"
			Continue:$listfind(OEOrdItemList,OEOrdID)>0
			Set OEOrdItemList=OEOrdItemList_$lb(OEOrdID)
			
			Set objOEOrd=##class(DHCMed.Base.OrdItem).GetObjById(OEOrdID)
			Continue:'$IsObject(objOEOrd)
			Set OEORIItmMastDR=objOEOrd.OEORIItmMastDR
			Set OEORIItmMast=$p($g(^ARCIM(+OEORIItmMastDR,+$p(OEORIItmMastDR,"||",2),1)),"^",2)
			Continue:OEORIItmMast=""
			
			Set (OEORIQty,OEORIPackUom,OEORIDoseQty,OEORIUnit)=""
			Set OEORIQty=$p($g(^OEORD(+OEOrdID,"I",+$p(OEOrdID,"||",2),1)),"^",18)     //数量
			Set ItmPackUomID=$p($g(^ARCIM(+OEORIItmMastDR,+$p(OEORIItmMastDR,"||",2),8)),"^",14)
			Set:ItmPackUomID'="" OEORIPackUom=$p($g(^CT("UOM",ItmPackUomID)),"^",2)    //基本单位
			Set OEORIDoseQty=$p($g(^OEORD(+OEOrdID,"I",+$p(OEOrdID,"||",2),2)),"^",1)  //剂量
			Set ItmUnitID=$p($g(^OEORD(+OEOrdID,"I",+$p(OEOrdID,"||",2),2)),"^",3)   //剂量单位
			Set:ItmUnitID'="" OEORIUnit=$p($g(^CT("UOM",ItmUnitID)),"^",2)
			
			Set NarcosisAnti=NarcosisAnti_$c(1)_OEOrdID_$c(2)_OEORIItmMastDR_$c(2)_OEORIDoseQty_$c(2)_OEORIUnit_$c(2)_""
		}
		Set:NarcosisAnti'="" NarcosisAnti=$e(NarcosisAnti,2,$l(NarcosisAnti))
		Set NarcosisAnti=$tr(NarcosisAnti,",","")
		Set NarcosisAnti=$tr(NarcosisAnti,"`","")
		Set NarcosisAnti=$tr(NarcosisAnti,$c(1),",")
		Set NarcosisAnti=$tr(NarcosisAnti,$c(2),"`")
		
		//术后预防性用药
		Set PostoperAntiList=objTmp.AftDrug
		Set PostoperAnti=""
		Set OEOrdItemList=""
		For ind=1:1:$l(PostoperAntiList,",") {
			Set OEOrdID=$p(PostoperAntiList,",",ind)
			Continue:OEOrdID=""
			Continue:OEOrdID'["||"
			Continue:$listfind(OEOrdItemList,OEOrdID)>0
			Set OEOrdItemList=OEOrdItemList_$lb(OEOrdID)
			
			Set objOEOrd=##class(DHCMed.Base.OrdItem).GetObjById(OEOrdID)
			Continue:'$IsObject(objOEOrd)
			Set OEORIItmMastDR=objOEOrd.OEORIItmMastDR
			Set OEORIItmMast=$p($g(^ARCIM(+OEORIItmMastDR,+$p(OEORIItmMastDR,"||",2),1)),"^",2)
			Continue:OEORIItmMast=""
			
			Set (OEORIQty,OEORIPackUom,OEORIDoseQty,OEORIUnit)=""
			Set OEORIQty=$p($g(^OEORD(+OEOrdID,"I",+$p(OEOrdID,"||",2),1)),"^",18)     //数量
			Set ItmPackUomID=$p($g(^ARCIM(+OEORIItmMastDR,+$p(OEORIItmMastDR,"||",2),8)),"^",14)
			Set:ItmPackUomID'="" OEORIPackUom=$p($g(^CT("UOM",ItmPackUomID)),"^",2)    //基本单位
			Set OEORIDoseQty=$p($g(^OEORD(+OEOrdID,"I",+$p(OEOrdID,"||",2),2)),"^",1)  //剂量
			Set ItmUnitID=$p($g(^OEORD(+OEOrdID,"I",+$p(OEOrdID,"||",2),2)),"^",3)   //剂量单位
			Set:ItmUnitID'="" OEORIUnit=$p($g(^CT("UOM",ItmUnitID)),"^",2)
			
			Set PostoperAnti=PostoperAnti_$c(1)_OEOrdID_$c(2)_OEORIItmMastDR_$c(2)_OEORIDoseQty_$c(2)_OEORIUnit_$c(2)_""
		}
		Set:PostoperAnti'="" PostoperAnti=$e(PostoperAnti,2,$l(PostoperAnti))
		Set PostoperAnti=$tr(PostoperAnti,",","")
		Set PostoperAnti=$tr(PostoperAnti,"`","")
		Set PostoperAnti=$tr(PostoperAnti,$c(1),",")
		Set PostoperAnti=$tr(PostoperAnti,$c(2),"`")
		
		Set InfDate=objTmp.InfDate
		Set InfPyStr=""_$c(3)_objTmp.Pathogenic
		Set RepUser=objTmp.RepUser
		Set RepStatus=objTmp.RepStatus
		Set RepDate=objTmp.FirstDate
		Set OperInfType=..ChangeDicByCode("NINFAimOPRInfType",objTmp.OpeInfType)
		Set ResumeText=objTmp.ResumeText
		
		//保存报告主表信息
		Set InputStr=""
		Set InputStr=InputStr_"^"_"OPR"
		Set InputStr=InputStr_"^"_EpisodeID
		Set InputStr=InputStr_"^"_EpisodeID_"||"_TransID
		Set InputStr=InputStr_"^"_TransLoc
		Set InputStr=InputStr_"^"_""
		Set InputStr=InputStr_"^"_""
		Set InputStr=InputStr_"^"_""
		Set InputStr=InputStr_"^"_""
		Set InputStr=InputStr_"^"_""
		Set InputStr=InputStr_"^"_RepLoc
		Set InputStr=InputStr_"^"_RepUser
		Set InputStr=InputStr_"^"_RepStatus
		Set flg=##Class(DHCMed.NINFService.Rep.AimReport).SaveReport(InputStr,"^")
		If (+flg)<1 {
			Set num=$i(^ZF("OPRError1"))
			Set ^ZF("OPRError1",num)=InputStr
			Continue
		}
		Set RepID=+flg
		
		
		//保存子表信息
		Set InputStr=RepID
		Set InputStr=InputStr_"^"_""
		Set InputStr=InputStr_"^"_OperationID
		Set InputStr=InputStr_"^"_OperationDesc
		Set InputStr=InputStr_"^"_OperStartDateTime
		Set InputStr=InputStr_"^"_OperEndDateTime
		Set InputStr=InputStr_"^"_OperTimes
		Set InputStr=InputStr_"^"_OperCutType
		Set InputStr=InputStr_"^"_OperASAScore
		Set InputStr=InputStr_"^"_OperNarcosisType
		Set InputStr=InputStr_"^"_OperationType
		Set InputStr=InputStr_"^"_OperationType1
		Set InputStr=InputStr_"^"_OperationType2
		Set InputStr=InputStr_"^"_OperDoctor
		Set InputStr=InputStr_"^"_Assistant1
		Set InputStr=InputStr_"^"_Assistant2
		Set InputStr=InputStr_"^"_NarcosisAnti
		Set InputStr=InputStr_"^"_PostoperAnti
		Set InputStr=InputStr_"^"_InfDate
		Set InputStr=InputStr_"^"_InfPyStr
		Set InputStr=InputStr_"^"_OperInfType
		Set InputStr=InputStr_"^"_ResumeText
		Set InputStr=InputStr_"^"_RepLoc
		Set InputStr=InputStr_"^"_RepUser
		Set InputStr=InputStr_"^"_RepStatus
		Set flg=##Class(DHCMed.NINFService.Rep.AimReportOPR).SaveReport(InputStr,"^")
		If (+flg)<1 {
			Set num=$i(^ZF("OPRError2"))
			Set ^ZF("OPRError2",num)=InputStr
		} Else {
			Set objSub=##Class(DHCMed.NINF.Rep.AimReportOPR).%OpenId(flg)
			If (objSub) {
				Set objSub.RepDate=RepDate
				Set objSub.RepTime=0
				Set sc=objSub.%Save()
				If $System.Status.IsError(sc) {  //检查Save是否成功
			   		Do $System.OBJ.DisplayError(sc)
				}
				Do objSub.%Close()
			}
		}
	}
	
	Quit Count
}

ClassMethod ChangeDicByCode(DicType As %String, DicCode As %String) As %String
{
	New (DicType,DicCode)
	Set return=""
	Quit:DicCode="" return
	
	Set DicID=""
	Set objDic=##Class(DHCMed.SS.Dictionary).GetByTypeCode(DicType,DicCode,"")
	If $IsObject(objDic) {
		Set return=objDic.%Id()
	}
	
	Quit return
}

/// w ##Class(DHCMed.NINFService.Srv.HistoryData).ChangeICUSurveryData()
ClassMethod ChangeICUSurveryData()
{
	New
	
	Set RowID=0,Count=0
	For {
		Set RowID=$o(^DHCMed.INF("ICUSL",RowID))
		Quit:RowID=""
		
		Set Count=Count+1
		
		Set objTmp=##class(DHCMed.INF.ICUSurveryLog).GetObjById(RowID)
		Continue:'$IsObject(objTmp)
		
		Set InputStr=""
		Set InputStr=InputStr_"^"_objTmp.ISLLocDr
		Set InputStr=InputStr_"^"_objTmp.ISLDate
		Set InputStr=InputStr_"^"_objTmp.ISLItem1
		Set InputStr=InputStr_"^"_objTmp.ISLItem2
		Set InputStr=InputStr_"^"_objTmp.ISLItem3
		Set InputStr=InputStr_"^"_objTmp.ISLItem4
		Set InputStr=InputStr_"^"_objTmp.ISLItem5
		Set InputStr=InputStr_"^"_objTmp.ISLItem6
		Set InputStr=InputStr_"^"_objTmp.ISLItem7
		Set InputStr=InputStr_"^"_objTmp.ISLItem8
		Set InputStr=InputStr_"^"_objTmp.ISLItem9
		Set InputStr=InputStr_"^"_objTmp.ISLItem10
		Set InputStr=InputStr_"^"_objTmp.UpdateDate
		Set InputStr=InputStr_"^"_objTmp.UpdateTime
		Set InputStr=InputStr_"^"_objTmp.UpdateUser
		Set flg=##Class(DHCMed.NINF.Rep.AimICUSurvery).Update(InputStr,"^")
		If (+flg)<1 {
			Set num=$i(^ZF("ICUSurveryError2"))
			Set ^ZF("ICUSurveryError2",num)=InputStr
		}
	}
	
	Quit Count
}

}
