/// 名称: DHCWMR.IO.ToHistorySrv
/// 描述: 兼容历史版本接口服务
/// 编写者：zhufei
/// 编写日期: 2014-12-30
Class DHCWMR.IO.ToHistorySrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2014-12-30
/// Description:  病案号或就诊号取病案号方法
/// Input：       EpisodeID:就诊号
///               PatientID:病人ID
///               MrTypeID:病案类型
/// Return：      返回String
/// 原有方法：w ##class(web.DHCWMRInterface.ReceiptSrv).GetMrNo("394","","7")
/// 替换方法：w ##class(DHCWMR.IO.ToHistorySrv).GetMrNo("394","","7")
ClassMethod GetMrNo(aEpisodeID As %String, aPatientID As %String, aMrTypeID As %String) As %String
{
	New (aEpisodeID,aPatientID,aMrTypeID)
	Set return=""
	Quit:(aEpisodeID="")&&(aPatientID="") return
	Quit:(aPatientID'="")&&(aMrTypeID="") return
	// 版本判断
	set MRSVersion=##Class(DHCWMR.IO.OutService).GetMRSVersion()
	if MRSVersion=3 {
		If aEpisodeID'="" {
			Set return=##class(DHCWMR.SSService.MrNoSrv).GetMrNoByEpisodeID(aEpisodeID,aMrTypeID)
		} Else {
			Set return=##class(DHCWMR.SSService.MrNoSrv).GetMrNoByPatientID(aPatientID,aMrTypeID)
		}
	}elseif ($e(MRSVersion,0,1)="4"){
		If aEpisodeID'="" {
			Set return=##Class(MA.IPMR.IO.OutService).GetMrNoByEpisodeID(aEpisodeID)
		} Else {
			Set return=##class(MA.IPMR.IO.OutService).GetMrNoByPatientID(aPatientID,"I")
		}
	}
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-12-30
/// Description:  格式化病案号
/// Input：       MrType:病案类型
///               MrNo:病案号
/// Return：      返回String
/// 原有方法：w ##class(web.DHCWMRMedBaseCtl).FormatMrNo(7,"a123")
/// 替换方法：w ##class(DHCWMR.IO.ToHistorySrv).FormatMrNo(7,"a123")
ClassMethod FormatMrNo(aMrTypeID As %String, aMrNo As %String) As %String
{
	New (aMrTypeID,aMrNo)
	Set return=""
	Quit:(aMrTypeID="")||(aMrNo="") return
	// 版本判断
	set MRSVersion=##Class(DHCWMR.IO.OutService).GetMRSVersion()
	if MRSVersion=3 {
		Set return=##class(DHCWMR.SSService.MrNoSrv).FormatMrNo(aMrNo,aMrTypeID)
	}elseif ($e(MRSVersion,0,1)="4"){
		set return = aMrNo
	}
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-12-30
/// Description:  根据就诊号取编目状态
/// Input：       EpisodeID : 就诊号
/// Return：      返回String
/// 原有方法：w ##class(web.DHCWMRService).IGetFPStatus(1701654)
/// 替换方法：w ##class(DHCWMR.IO.ToHistorySrv).IGetFPStatus(394)
ClassMethod IGetFPStatus(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return="N"
	Quit:aEpisodeID="" return
	// 版本判断
	set MRSVersion=##Class(DHCWMR.IO.OutService).GetMRSVersion()
	if MRSVersion=3 {
		Set objFrontPage=##class(DHCWMR.FPService.FrontPageSrv).GetFPObjByAdm(aEpisodeID)
		Quit:'$IsObject(objFrontPage) return
		Quit:objFrontPage.FPIsFinish'=1 return
		Set return="Y"
	}elseif ($e(MRSVersion,0,1)="4"){
		set FrontpageInfo = ##class(MA.IPMR.IO.OutService).GetFrontpageInfo(aEpisodeID)
		If $p(FrontpageInfo,"^",1)=1 {
			Set return="Y"
		}
	}
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-12-30
/// Description:  根据PatientID取急诊病案号
/// Input：       PatientID : 病人ID
/// Return：      返回String
/// 原有方法：w ##class(web.DHCWMRService).GetMrNoByPapmiServiceE(argPaperDR)
/// 替换方法：w ##class(DHCWMR.IO.ToHistorySrv).GetMrNoByPapmiServiceE(76539)
ClassMethod GetMrNoByPapmiServiceE(aPatientID As %String) As %String
{
	New (aPatientID)
	Set return=""
	Quit:aPatientID="" return
	// 版本判断
	set MRSVersion=##Class(DHCWMR.IO.OutService).GetMRSVersion()
	if MRSVersion=3 {
		Set aMrTypeID=101  //地坛急诊病案
		Set return=##class(DHCWMR.SSService.MrNoSrv).GetMrNoByPatientID(aPatientID,aMrTypeID)
	}elseif ($e(MRSVersion,0,1)="4"){
		set return = ##class(MA.IPMR.IO.OutService).GetMrNoByPatientID(aPatientID,"EP","","",.ErrMsg)
	}
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-12-30
/// Description:  根据PatientID取抢救病案号（急诊）
/// Input：       PatientID : 病人ID
/// Return：      返回String
/// 原有方法：w ##class(web.DHCWMRService).GetMrNoByPapmiServiceQ(argPaperDR)
/// 替换方法：w ##class(DHCWMR.IO.ToHistorySrv).GetMrNoByPapmiServiceQ(76539)
ClassMethod GetMrNoByPapmiServiceQ(aPatientID As %String) As %String
{
	New (aPatientID)
	Set return=""
	Quit:aPatientID="" return
	// 版本判断
	set MRSVersion=##Class(DHCWMR.IO.OutService).GetMRSVersion()
	if MRSVersion=3 {
		Set aMrTypeID=311  //地坛抢救病案
		Set return=##class(DHCWMR.SSService.MrNoSrv).GetMrNoByPatientID(aPatientID,aMrTypeID)
	}elseif ($e(MRSVersion,0,1)="4"){
		set return = ##class(MA.IPMR.IO.OutService).GetMrNoByPatientID(aPatientID,"EP","","",.ErrMsg)
	}
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-12-30
/// Description:  根据EpisodeID取病案状态信息
/// Input：       EpisodeID : 就诊号
/// Return：      返回String
/// 原有方法：w ##Class(web.DHCWMRService).GetMrStatusString(Paadm)
/// 替换方法：w ##class(DHCWMR.IO.ToHistorySrv).GetMrStatusString(76539)
ClassMethod GetMrStatusString(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Quit:aEpisodeID="" return
	// 版本判断
	set MRSVersion=##Class(DHCWMR.IO.OutService).GetMRSVersion()
	if MRSVersion=3 {
		Set StatusInfo=##class(DHCWMR.SSService.VolumeSrv).GetStatusByEpisodeID(aEpisodeID)
		Quit:StatusInfo="" return
		
		For indStatus=1:1:$l(StatusInfo,$c(1)) {
			Set tmpStatus=$p(StatusInfo,$c(1),indStatus)
			Continue:tmpStatus=""
			
			Set:return'="" return=return_$c(1)
			Set return=return_"^"_$p(tmpStatus,$c(2),2)  //操作项目
			Set return=return_"^"_$p(tmpStatus,$c(2),3)  //操作日期
			Set return=return_"^"_$p(tmpStatus,$c(2),4)  //操作时间
			Set return=return_"^"_$p(tmpStatus,$c(2),5)  //操作人
		}
	}elseif ($e(MRSVersion,0,1)="4"){
		
	}
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-12-30
/// Description:  根据病案号取就诊列表
/// Input：       MrNo : 病案号
///               MrTypeID : 病案类型
///               ErrMsg : 错误返回值
/// Return：      返回String
/// 原有方法：w ##class(web.DHCWMRService).IGetEpisodeIDsByMrNo(aMrNo,aMrType,"")
/// 替换方法：w ##class(DHCWMR.IO.ToHistorySrv).IGetEpisodeIDsByMrNo("900022",7,"")
ClassMethod IGetEpisodeIDsByMrNo(aMrNo As %String, aMrTypeID As %String, ByRef ErrMsg As %String) As %String
{
	New (aMrNo,aMrTypeID,ErrMsg)
	Set return="",ErrMsg="-1:入参为空"
	Quit:(aMrNo="")||(aMrTypeID="") return
	
	Set $ZT="IGetEpisodeIDsByMrNoError3"
	// 版本判断
	set MRSVersion=##Class(DHCWMR.IO.OutService).GetMRSVersion()
	if MRSVersion=3 {
		Set return=##class(DHCWMR.SSService.MainSrv).GetEpisodeIDsByMrNo(aMrTypeID,aMrNo)
		If return="" {
			Set ErrMsg="-2:病案号码不存在"
		} Else {
			Set ErrMsg=""
		}
	}elseif ($e(MRSVersion,0,1)="4"){
		
	}
	Quit return
IGetEpisodeIDsByMrNoError3
	Set ErrMsg="-999:"_$ZError
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-12-30
/// Description:  就诊对应第几次住院
/// Input：       EpisodeID : 就诊号
/// Return：      返回String
/// 原有方法：w ##Class(web.DHCWMRService).IGetIPCountByEpisodeID(EpisodeID)
/// 替换方法：w ##class(DHCWMR.IO.ToHistorySrv).IGetIPCountByEpisodeID(960366)
ClassMethod IGetIPCountByEpisodeID(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=-1
	Quit:aEpisodeID="" return
	// 版本判断
	set MRSVersion=##Class(DHCWMR.IO.OutService).GetMRSVersion()
	if MRSVersion=3 {
		Set return=##class(DHCWMR.SSService.VolumeSrv).GetIPTimes(aEpisodeID)
	}elseif ($e(MRSVersion,0,1)="4"){
		Set return=##class(MA.IPMR.IO.OutService).GetIPTimes(aEpisodeID)
	}
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-12-30
/// Description:  根据病案号查询住院次数
/// Input：       MrTypeID : 病案类型
///               MrNo : 病案号
/// Return：      返回String
/// 原有方法：w ##Class(web.DHCWMRService).IGetIPCount(MrTypeDr,MrNo)
/// 替换方法：w ##class(DHCWMR.IO.ToHistorySrv).IGetIPCount(MrTypeDr,MrNo)
ClassMethod IGetIPCount(aMrTypeID As %String, aMrNo As %String) As %String
{
	New (aMrTypeID,aMrNo)
	Set return=-1
	Quit:(aMrTypeID="")||(aMrNo="") return
	// 版本判断
	set MRSVersion=##Class(DHCWMR.IO.OutService).GetMRSVersion()
	if MRSVersion=3 {
		Set return=##class(DHCWMR.SSService.VolumeSrv).GetIPCount(aMrTypeID,aMrNo)
	}elseif ($e(MRSVersion,0,1)="4"){
		set return = ##class(MA.IPMR.IO.OutService).GetIPCount(aMrNo)
	}
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-12-30
/// Description:  取患者住院次数
/// Input：       EpisodeID : 就诊号
///               PatientID : 病人ID
/// Return：      返回String
/// 原有方法：w ##Class(web.DHCWMRCodingInterface).getIPCount(Paadm, Papmi)
/// 替换方法：w ##class(DHCWMR.IO.ToHistorySrv).getIPCount(Paadm, Papmi)
ClassMethod getIPCount(aEpisodeID As %String, aPatientID As %String) As %String
{
	New (aEpisodeID,aPatientID)
	Set return=0
	Quit:(aEpisodeID="")&&(aPatientID="") return
	
	// 版本判断
	set MRSVersion=##Class(DHCWMR.IO.OutService).GetMRSVersion()
	if MRSVersion=3 {
		If aEpisodeID'="" {
			Set aPatientID=+$p($g(^PAADM(aEpisodeID)),"^",1)
		}
		
		Set aMrClass="I"
		Set objMrType = ##class(DHCWMR.SS.MrType).GetMrType(aMrClass,"")
		Quit:'$IsObject(objMrType) return
		Set MrTypeID=objMrType.%Id()
		Set MrNo=##class(DHCWMR.SSService.MrNoSrv).GetMrNoByPatientID(aPatientID,MrTypeID)
		Quit:MrNo="" return
		
		Set return=##class(DHCWMR.SSService.VolumeSrv).GetIPCount(MrTypeID,MrNo)
	}elseif ($e(MRSVersion,0,1)="4"){
		
	}
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-12-30
/// Description:  根据就诊号取病案回收状态
/// Input：       EpisodeID : 就诊号
/// Return：      病历回收状态:已回收返回1;未回收返回0;其他返回负值
/// 原有方法：w ##Class(web.DHCWMRService).IGetMrRetrieveStatus(argEpisodeID)
/// 替换方法：w ##class(DHCWMR.IO.ToHistorySrv).IGetMrRetrieveStatus(960366)
ClassMethod IGetMrRetrieveStatus(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=-1
	Quit:aEpisodeID="" return
	// 版本判断
	set MRSVersion=##Class(DHCWMR.IO.OutService).GetMRSVersion()
	if MRSVersion=3 {
		Set return=##class(DHCWMR.SSService.VolumeSrv).GetFinishStatus(aEpisodeID,"RC")
	}elseif ($e(MRSVersion,0,1)="4"){
		set return = ##class(MA.IPMR.IO.OutService).GetFinishStatus(aEpisodeID,"RC")
	}
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-12-30
/// Description:  根据EpisodeID取病案号
/// Input：       EpisodeID : 就诊号
/// Return：      返回String
/// 原有方法：w ##Class(web.DHCWMRService).IGetMrNoByEpisodeID(argAdmID)
/// 替换方法：w ##class(DHCWMR.IO.ToHistorySrv).IGetMrNoByEpisodeID(960366)
ClassMethod IGetMrNoByEpisodeID(aEpisodeID As %String, ByRef ErrMsg As %String) As %String
{
	New (aEpisodeID,ErrMsg)
	Set return="",ErrMsg="-10:入参为空"
	Quit:aEpisodeID="" return
	
	Set $ZT="IGetMrNoByEpisodeIDError3"
	// 版本判断
	set MRSVersion=##Class(DHCWMR.IO.OutService).GetMRSVersion()
	if MRSVersion=3 {
		Set return=##class(DHCWMR.SSService.MrNoSrv).GetMrNoByEpisodeID(aEpisodeID)
		If return="" {
			Set ErrMsg="-8:病案号为空"
		} Else {
			Set ErrMsg=""
		}
	}elseif ($e(MRSVersion,0,1)="4"){
		set return = ##Class(MA.IPMR.IO.OutService).GetMrNoByEpisodeID(aEpisodeID)
	}
	
	Quit return
	
IGetMrNoByEpisodeIDError3
    Set ErrMsg="-999:"_$ZError
    Quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-12-30
/// Description:  根据EpisodeID取病案号
/// Input：       EpisodeID : 就诊号
/// Return：      返回String
/// 原有方法：w ##Class(web.DHCWMRService).GetIPMrNoByAdm(AdmID)
/// 替换方法：w ##class(DHCWMR.IO.ToHistorySrv).GetIPMrNoByAdm(960366)
ClassMethod GetIPMrNoByAdm(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Quit:aEpisodeID="" return
	
	Set $ZT="GetIPMrNoByAdmError3"
	// 版本判断
	set MRSVersion=##Class(DHCWMR.IO.OutService).GetMRSVersion()
	if MRSVersion=3 {
		Set return=##class(DHCWMR.SSService.MrNoSrv).GetMrNoByEpisodeID(aEpisodeID)
	}elseif ($e(MRSVersion,0,1)="4"){
		set return = ##Class(MA.IPMR.IO.OutService).GetMrNoByEpisodeID(aEpisodeID)
	}
	Quit return
	
GetIPMrNoByAdmError3
    Quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-12-30
/// Description:  根据PatientID取病案号
/// Input：       PatientID : 病人ID
/// Return：      返回String
/// 原有方法：w ##Class(web.DHCWMRService).IGetMrNoByPatientID()
/// 替换方法：w ##class(DHCWMR.IO.ToHistorySrv).IGetMrNoByPatientID()
ClassMethod IGetMrNoByPatientID(aPatientID As %String, ByRef ErrMsg As %String)
{
	New (aPatientID,ErrMsg)
	Set return="",ErrMsg="-10:入参为空"
	Quit:aPatientID="" return
	
	Set aPatientID=+$g(aPatientID)
	Quit:aPatientID<1 return
	
	Set $ZT="IGetMrNoByPatientIDError3"
	
	// 版本判断
	set MRSVersion=##Class(DHCWMR.IO.OutService).GetMRSVersion()
	if MRSVersion=3 {
		Set ErrMsg="-1:无对应病案类型"
		Set objMrType=##class(DHCWMR.SS.MrType).GetMrType("I","")
		Quit:'$IsObject(objMrType) return
		Set MrTypeID=objMrType.%Id()
		
		Set return=##class(DHCWMR.SSService.MrNoSrv).GetMrNoByPatientID(aPatientID,MrTypeID)
		If return="" {
			Set ErrMsg="-100:未找到病案号"
		} Else {
			Set ErrMsg=""
		}
	}elseif ($e(MRSVersion,0,1)="4"){
		set return = ##class(MA.IPMR.IO.OutService).GetMrNoByPatientID(aPatientID,"IP","","",.ErrMsg)
	}
	
	Quit return
	
IGetMrNoByPatientIDError3
     Set ErrMsg="-1:"_$ZError
     Quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-12-30
/// Description:  根据EpisodeID取病案类型信息
/// Input：       EpisodeID : 就诊号
/// Return：      返回String
/// 原有方法：w ##Class(web.DHCWMRService).IGetMrTypeInfo(argAdmID)
/// 替换方法：w ##class(DHCWMR.IO.ToHistorySrv).IGetMrTypeInfo(5920325)
ClassMethod IGetMrTypeInfo(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=-1
	Quit:aEpisodeID="" return
	
	// 版本判断
	set MRSVersion=##Class(DHCWMR.IO.OutService).GetMRSVersion()
	if MRSVersion=3 {
		Set return=-2
		Set objVol=##Class(DHCWMR.SS.Volume).GetObjByPaadm(aEpisodeID)
		Quit:'$IsObject(objVol) return
		Quit:'$IsObject(objVol.SVMainDr) return
		Quit:'$IsObject(objVol.SVMainDr.SMMrType) return
		Set MrNo=objVol.SVMainDr.SMMrNo
		Set MrTypeID=objVol.SVMainDr.SMMrType.%Id()
		Set MrTypeDesc=objVol.SVMainDr.SMMrType.MTDesc
		Set return=MrNo_"^"_MrTypeID_"^"_MrTypeDesc
	}elseif ($e(MRSVersion,0,1)="4"){
		set MrNo = ##Class(MA.IPMR.IO.OutService).GetMrNoByEpisodeID(aEpisodeID)
		set return = MrNo
	}
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-01-09
/// Description:  取就诊对应第几次住院
/// Input：       EpisodeID : 就诊号
/// Return：      返回String
/// 原有方法：w ##Class(web.DHCWMRCodingInterface).getPaadmIP(argAdmId)
/// 替换方法：w ##class(DHCWMR.IO.ToHistorySrv).getPaadmIP(5920325)
ClassMethod getPaadmIP(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=-1
	Quit:aEpisodeID="" return
	// 版本判断
	set MRSVersion=##Class(DHCWMR.IO.OutService).GetMRSVersion()
	if MRSVersion=3 {
		Set return=##class(DHCWMR.SSService.VolumeSrv).GetIPTimes(aEpisodeID)
	}elseif ($e(MRSVersion,0,1)="4"){
		set return = ##class(MA.IPMR.IO.OutService).GetIPTimes(aEpisodeID)
	}
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-12-08
/// Description:  取病案编目(诊断、手术)接口方法
/// Table：       DHCWMR.FP.FrontPage
/// Input：       EpisodeID:就诊号
///               GetType:类型
///               -------:诊断(D/1:主要诊断、D/2:次要诊断、D/3:医院感染诊断、D/4:病理诊断、D/5:损伤中毒的外部因素、D/6:门急诊诊断、D/7:入院诊断)
///               -------:手术(O/1:手术、O/2:操作)
///               RowIndex:顺序号
///               FPCode:编目代码(主要是处理多次编目情况,指向工作流项目系统操作代码)
/// Return：      返回String
///               -------:诊断(ICD10 $c(2) 诊断描述 $c(2) 出院情况)
///               -------:手术(ICD10_$c(2)_手术名称)_$c(2)_手术操作日期_$c(2)_切口编号_$c(2)_切口_$c(2)_愈合编目_$c(2)_愈合_$c(2)_手术医生编号_$c(2)_手术医师_$c(2)_麻醉方式编号_$c(2)_麻醉方式_$c(2)_是否附加手术_$c(2)_1助编号_$c(2)_1助姓名_$c(2)_2助编号_$c(2)_2助姓名_$c(2)_麻醉医生编号_$c(2)_麻醉医生)
/// 原有方法：w ##Class(web.DHCWMRCodingInterface).getFrontPageICD(AEpisodeID,"D/2",1)
/// 替换方法：w ##class(DHCWMR.IO.ToHistorySrv).getFrontPageICD(5920325,"D/1",1)
ClassMethod getFrontPageICD(aEpisodeID As %String, aGetType As %String, aRowIndex As %String = "1") As %String
{
	New (aEpisodeID,aGetType,aRowIndex)
	Set return=##class(DHCWMR.FPService.OutputSrv).GetFrontPageICD(aEpisodeID,aGetType,aRowIndex)
	if return="" {
		Set ICDType=$p(aGetType,"/",1)
		Set ICDSubType=$p(aGetType,"/",2)
		Quit:(ICDType'="D")&&(ICDType'="O") return
		If (ICDType="D"){
			if ICDSubType=1 {
				set ICDSubType=3
			}elseif ICDSubType=2 {
				set ICDSubType=4
			}elseif ICDSubType=3 {
				set ICDSubType=6
			}elseif ICDSubType=4 {
				set ICDSubType=7
			}elseif ICDSubType=5 {
				set ICDSubType=5
			}elseif ICDSubType=6 {
				set ICDSubType=1
			}elseif ICDSubType=7 {
				set ICDSubType=2
			}
		}else{}
		set aGetType = ICDType_"/"_ICDSubType
		Set return = ##class(MA.IPMR.IO.OutService).GetICDByAdm(aEpisodeID,aGetType,aRowIndex)
		if (return'="") {
			If (ICDType="D"){
				Set TypeCode=$p(return,$c(2),9)
				if TypeCode=1 {
					set $p(return,$c(2),9)=6
				}elseif TypeCode=2 {
					set $p(return,$c(2),9)=7
				}elseif TypeCode=3 {
					set $p(return,$c(2),9)=1
				}elseif TypeCode=4 {
					set $p(return,$c(2),9)=2
				}elseif TypeCode=5 {
					set $p(return,$c(2),9)=5
				}elseif TypeCode=6 {
					set $p(return,$c(2),9)=3
				}elseif TypeCode=7 {
					set $p(return,$c(2),9)=4
				}
			}
		}
	}
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-12-08
/// Description:  取病案编目(诊断、手术)接口方法
/// Table：       DHCWMR.FP.FrontPage
/// Input：       EpisodeID:就诊号
///               GetType:类型
///               -------:诊断(D/1:主要诊断、D/2:次要诊断、D/3:医院感染诊断、D/4:病理诊断、D/5:损伤中毒的外部因素、D/6:门急诊诊断、D/7:入院诊断)
///               -------:手术(O/1:手术、O/2:操作)
///               RowIndex:顺序号
///               FPCode:编目代码(主要是处理多次编目情况,指向工作流项目系统操作代码)
/// Return：      返回String，多条记录$c(1)分隔
///               -------:诊断(ICD10 $c(2) 诊断描述 $c(2) 出院情况)
///               -------:手术(ICD10_$c(2)_手术名称)_$c(2)_手术操作日期_$c(2)_切口编号_$c(2)_切口_$c(2)_愈合编目_$c(2)_愈合_$c(2)_手术医生编号_$c(2)_手术医师_$c(2)_麻醉方式编号_$c(2)_麻醉方式_$c(2)_是否附加手术_$c(2)_1助编号_$c(2)_1助姓名_$c(2)_2助编号_$c(2)_2助姓名_$c(2)_麻醉医生编号_$c(2)_麻醉医生)
/// 原有方法：w ##Class(web.DHCWMRCodingInterfaceList).getFrontPageICDList(AEpisodeID,"D")
/// 替换方法：w ##class(DHCWMR.IO.ToHistorySrv).getFrontPageICDList(5920325,"D/1")
ClassMethod getFrontPageICDList(aEpisodeID As %String, aGetType As %String) As %String
{
	New (aEpisodeID,aGetType)
	Set return=##class(DHCWMR.FPService.OutputSrv).GetFrontPageICDAll(aEpisodeID,aGetType)
	if return="" {
		Set ICDType=$p(aGetType,"/",1)
		Set ICDSubType=$p(aGetType,"/",2)
		Quit:(ICDType'="D")&&(ICDType'="O") return
		If (ICDType="D"){
			if ICDSubType=1 {
				set ICDSubType=3
			}elseif ICDSubType=2 {
				set ICDSubType=4
			}elseif ICDSubType=3 {
				set ICDSubType=6
			}elseif ICDSubType=4 {
				set ICDSubType=7
			}elseif ICDSubType=5 {
				set ICDSubType=5
			}elseif ICDSubType=6 {
				set ICDSubType=1
			}elseif ICDSubType=7 {
				set ICDSubType=2
			}
		}else{}
		If ICDSubType'="" {
			set aGetType = ICDType_"/"_ICDSubType
		}
		Set return = ##class(MA.IPMR.IO.OutService).GetICDAllByAdm(aEpisodeID,aGetType)
		Set ret = ""
		if (return'="") {
			For xind = 1:1:$length(return,$c(1)) {
				Set ICDStr = $p(return,$c(1),xind)
				If (ICDType="D"){
					Set TypeCode=$p(ICDStr,$c(2),9)
					if TypeCode=1 {
						set $p(ICDStr,$c(2),9)=6
					}elseif TypeCode=2 {
						set $p(ICDStr,$c(2),9)=7
					}elseif TypeCode=3 {
						set $p(ICDStr,$c(2),9)=1
					}elseif TypeCode=4 {
						set $p(ICDStr,$c(2),9)=2
					}elseif TypeCode=5 {
						set $p(ICDStr,$c(2),9)=5
					}elseif TypeCode=6 {
						set $p(ICDStr,$c(2),9)=3
					}elseif TypeCode=7 {
						set $p(ICDStr,$c(2),9)=4
					}
				}
				Set ret = $s(ret="":ICDStr,1:ret_$c(1)_ICDStr)
			}
		}
		Set return = ret
	}
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-01-09
/// Description:  取病案编码员信息
/// Input：       EpisodeID : 就诊号
/// Return：      返回String(ID/工号/姓名)
/// 原有方法：w ##class(web.DHCWMRCodingInterface).getCodingUserName(AAdmID)
/// 替换方法：w ##class(DHCWMR.IO.ToHistorySrv).getCodingUserName(5920325)
ClassMethod getCodingUserName(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=-1
	Quit:aEpisodeID="" return
	// 版本判断
	set MRSVersion=##Class(DHCWMR.IO.OutService).GetMRSVersion()
	if MRSVersion=3 {
		Set return=##class(DHCWMR.FPService.OutputSrv).GetCodingUser(aEpisodeID)
		Set return=$tr(return,$c(1),"/")
	}elseif ($e(MRSVersion,0,1)="4"){
		set FrontpageInfo = ##class(MA.IPMR.IO.OutService).GetFrontpageInfo(aEpisodeID)
		Set return="//"_$p(FrontpageInfo,"^",4)
	}
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-01-09
/// Description:  根据病案号取病人ID接口
/// Table：       DHCWMR.SS.Main、DHCWMR.SS.Volume、DHCWMR.SS.VolPaadm
/// Input：       MrNo ：病案号
/// Return：      返回String
/// 原有方法：w ##Class(web.DHCWMRService).IGetPatientIDByMrNo(MrNo,.ErrMsg)
/// 替换方法：w ##class(DHCWMR.IO.ToHistorySrv).IGetPatientIDByMrNo(500001,"")
ClassMethod IGetPatientIDByMrNo(aMrNo As %String, ByRef ErrMsg As %String) As %String
{
	New (aMrNo,ErrMsg)
	Set return="",ErrMsg="-10:入参为空"
	Quit:aMrNo="" return
	
	Set aMrClass="I"  //住院病案
	
	Set $ZT="IGetPatientIDByMrNoError3"
	
	// 版本判断
	set MRSVersion=##Class(DHCWMR.IO.OutService).GetMRSVersion()
	if MRSVersion=3 {
		Set ErrMsg="-2:无有效病案类型"
		Set objMrType = ##class(DHCWMR.SS.MrType).GetMrType(aMrClass,"")
		Quit:'$IsObject(objMrType) return
		Set MrTypeID=objMrType.%Id()
		
		Set return=##class(DHCWMR.SSService.MrNoSrv).GetPatientIDByMrNo(aMrNo,MrTypeID)
		If return="" {
			Set ErrMsg="-11:病案号错误"
		} Else {
			Set ErrMsg=""
			Set return=$p(return,",",1)
		}
	}elseif ($e(MRSVersion,0,1)="4"){
		set return = ##class(MA.IPMR.IO.OutService).GetPatientIDByMrNo(aMrNo,"IP",.ErrMsg)
	}
	Quit return
	
IGetPatientIDByMrNoError3
    Set ErrMsg="-999:"_$ZE
    Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-01-09
/// Description:  根据病案号取病人ID接口
/// Table：       DHCWMR.SS.Main、DHCWMR.SS.Volume、DHCWMR.SS.VolPaadm
/// Input：       MrNo ：病案号
///               MrTypeID ：病案类型ID
/// Return：      返回String
/// 原有方法：w ##Class(web.DHCWMRService).IGetPatIDByMrNo(argMrNo, argMrType)
/// 替换方法：w ##class(DHCWMR.IO.ToHistorySrv).IGetPatIDByMrNo(500001,7)
ClassMethod IGetPatIDByMrNo(aMrNo As %String, aMrTypeID As %String) As %String
{
	New (aMrNo,aMrTypeID)
	Set return=""
	Quit:(aMrNo="")||(aMrTypeID="") return
	
	Set $ZT="IGetPatIDByMrNoError3"
	// 版本判断
	set MRSVersion=##Class(DHCWMR.IO.OutService).GetMRSVersion()
	if MRSVersion=3 {
		Set return=##class(DHCWMR.SSService.MrNoSrv).GetPatientIDByMrNo(aMrNo,aMrTypeID)
		Set return=$p(return,",",1)
	}elseif ($e(MRSVersion,0,1)="4"){
		set aMrClass=""
		set:aMrTypeID="7" aMrClass="I"
		set return = ##class(MA.IPMR.IO.OutService).GetPatientIDByMrNo(aMrNo,aMrClass,.ErrMsg)
	}
	Quit return
	
IGetPatIDByMrNoError3
    Set ErrMsg="-999:"_$ZE
    Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-01-09
/// Description:  根据病案类型取归档上架操作项目ID
/// Table：       DHCWMR.SS.WorkItem、DHCWMR.SS.WorkFlow、DHCWMR.SS.WorkFItem
/// Input：       MrTypeID ：病案类型ID
/// Return：      返回String
/// 原有方法：w ##class(web.DHCWMRService).GetArchiveItemID(MrType)
/// 替换方法：w ##class(DHCWMR.IO.ToHistorySrv).GetArchiveItemID(7)
ClassMethod GetArchiveItemID(aMrTypeID As %String) As %String
{
	New (aMrTypeID)
	Set return=""
	Quit:aMrTypeID="" return
	// 版本判断
	set MRSVersion=##Class(DHCWMR.IO.OutService).GetMRSVersion()
	if MRSVersion=3 {
		Set objWFItem=##class(DHCWMR.SS.WorkFItem).GetWFItemBySysOpera(aMrTypeID,"S")
		Quit:'$IsObject(objWFItem) return
		Quit:'$IsObject(objWFItem.WFIItem) return
		Set return=objWFItem.WFIItem.%Id()
	}elseif ($e(MRSVersion,0,1)="4"){
	}
    Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-01-09
/// Description:  根据EpisodeID取病案归档状态
/// Table：       DHCWMR.SS.Volume、DHCWMR.SS.VolStatus
/// Input：       EpisodeID ：就诊号
/// Return：      返回String
///               已归档(电子病历不能修改)返回1;
/// 			  未归档(电子病历可以修改)返回0;
/// 			  其他返回负值
/// 原有方法：w ##Class(web.DHCWMRService).IGetMrArchiveStatus(EpisodeID)
/// 替换方法：w ##class(DHCWMR.IO.ToHistorySrv).IGetMrArchiveStatus(5920325)
ClassMethod IGetMrArchiveStatus(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=-1
	Quit:aEpisodeID="" return
	// 版本判断
	set MRSVersion=##Class(DHCWMR.IO.OutService).GetMRSVersion()
	if MRSVersion=3 {
		Set return=##class(DHCWMR.SSService.VolumeSrv).GetFinishStatus(aEpisodeID,"S")
	}elseif ($e(MRSVersion,0,1)="4"){
		set return = ##class(MA.IPMR.IO.OutService).GetFinishStatus(aEpisodeID,"S")
	}
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-01-09
/// Description:  根据病案类型取归档上架操作项目ID
/// Table：       DHCWMR.SS.WorkItem、DHCWMR.SS.WorkFlow、DHCWMR.SS.WorkFItem
/// Input：       MrTypeID ：病案类型ID
/// Return：      返回String
/// 原有方法：w w ##Class(web.DHCWMRService).IGetMrTypeInfoByPatID(PatientID,argMrType)
/// 替换方法：w ##class(DHCWMR.IO.ToHistorySrv).IGetMrTypeInfoByPatID(1000,7)
ClassMethod IGetMrTypeInfoByPatID(aPatientID As %String, aMrTypeID As %String) As %String
{
	New (aPatientID,aMrTypeID)
	Set return=""
	Quit:(aPatientID="")||(aMrTypeID="") return
	// 版本判断
	set MRSVersion=##Class(DHCWMR.IO.OutService).GetMRSVersion()
	if MRSVersion=3 {
		Set objMrType=##class(DHCWMR.SS.MrType).GetObjById(aMrTypeID)
		Quit:'$IsObject(objMrType) return
		
		Set MrTypeID=objMrType.%Id()
		Set MrTypeDesc=objMrType.MTDesc
		Set MrNo=##class(DHCWMR.SSService.MrNoSrv).GetMrNoByPatientID(aPatientID,MrTypeID)
		Quit:MrNo="" return
		
		Set return=MrNo_"^"_MrTypeID_"^"_MrTypeDesc
	}elseif ($e(MRSVersion,0,1)="4"){
		set aMrClass = ""
		set:aMrTypeID="7" aMrClass="I"
		set MrNo = ##class(MA.IPMR.IO.OutService).GetMrNoByPatientID(aPatientID,aMrClass,"","",.ErrMsg)
		Set return=MrNo
	}
	
    Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-01-09
/// Description:  验证病案号是否有效
/// Table：       DHCWMR.SS.Main
/// Input：       MrTypeID ：病案类型ID
///               MrNo ：病案号
/// Return：      返回String -1:入参错误;0:病案号有效；1:病案号无效(此号不能再分配给其他人)
/// 原有方法：w ##Class(web.DHCWMRService).CheckMrNoActive(MrTypeDr,MrNo)
/// 替换方法：w ##class(DHCWMR.IO.ToHistorySrv).CheckMrNoActive(7,500001)
ClassMethod CheckMrNoActive(aMrTypeID As %String, aMrNo As %String) As %String
{
	New (aMrTypeID,aMrNo)
	Set return=-1
	Quit:(aMrTypeID="")||(aMrNo="") return
	// 版本判断
	set MRSVersion=##Class(DHCWMR.IO.OutService).GetMRSVersion()
	if MRSVersion=3 {
		Set PatientIDs=##class(DHCWMR.SSService.MrNoSrv).GetPatientIDByMrNo(aMrNo,aMrTypeID)
		If PatientIDs="" {
			Set return=1
		} Else {
			Set return=0
		}
	}elseif ($e(MRSVersion,0,1)="4"){
		set aMrClass = ""
		set:aMrTypeID="7" aMrClass="I"
		set PatientID = ##class(MA.IPMR.IO.OutService).GetPatientIDByMrNo(aMrNo,aMrClass,.ErrMsg)
		If PatientIDs="" {
			Set return=1
		} Else {
			Set return=0
		}
	}
    Quit return
}

/*************************************以下接口未兼容V4**************************************/
/// Creator：     zhufei
/// CreatDate：   2015-01-14
/// Description:  取完成病案归档操作的病案就诊列表，调用集成平台接口上传HQMS
/// Table：       DHCWMR.SS.Main、DHCWMR.SS.Volume、DHCWMR.SS.VolStatus
/// Input：       DateFrom ：开始日期
///               DateTo ：结束日期
/// Return：      返回String
/// 原有方法：w ##Class(web.DHCWMRInterface.ReceiptSrv).GetRecordAdmList("2012-12-21","2012-12-21")
/// 替换方法：w ##class(DHCWMR.IO.ToHistorySrv).GetRecordAdmList("2012-12-21","2012-12-21")
ClassMethod GetRecordAdmList(aDateFrom As %String, aDateTo As %String, aMrTypeID As %String, aSysOpera As %String) As %String
{
	New (aDateFrom,aDateTo,aMrTypeID,aSysOpera)
	Set return=0
	Quit:aSysOpera="" return
	
	Set:aDateFrom["/" aDateFrom=$zdh(aDateFrom,4)
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateFrom'="" aDateFrom=+aDateFrom
	Set:aDateTo["/" aDateTo=$zdh(aDateTo,4)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set:aDateTo'="" aDateTo=+aDateTo
	Set:aDateFrom="" aDateFrom=+$h
	Set:aDateTo="" aDateTo=aDateFrom
	
	Set xMrTypeID=0,Count=0
	For {
		Set xMrTypeID=$o(^DHCWMR.SS.OperationI("IndexItemDrDate",xMrTypeID))
		Quit:xMrTypeID=""
		Continue:(aMrTypeID'="")&&(xMrTypeID'=aMrTypeID)
		
		Set xWorkItemID=0
		For {
			Set xWorkItemID=$o(^DHCWMR.SS.OperationI("IndexItemDrDate",xMrTypeID,xWorkItemID))
			Quit:xWorkItemID=""
			
			Set objWorkItem=##class(DHCWMR.SS.WorkFItem).GetWFItem(xMrTypeID,xWorkItemID)
			Continue:'$IsObject(objWorkItem)
			Continue:objWorkItem.WFISysOpera'=aSysOpera
			
			Set xDate=aDateFrom-1
			For {
				Set xDate=$o(^DHCWMR.SS.OperationI("IndexItemDrDate",xMrTypeID,xWorkItemID,xDate))
				Quit:xDate=""
				Quit:xDate>aDateTo
				
				Set xTime=""
				For {
					Set xTime=$o(^DHCWMR.SS.OperationI("IndexItemDrDate",xMrTypeID,xWorkItemID,xDate,xTime))
					Quit:xTime=""
					
					Set xOperaID=0
					For {
						Set xOperaID=$o(^DHCWMR.SS.OperationI("IndexItemDrDate",xMrTypeID,xWorkItemID,xDate,xTime,xOperaID))
						Quit:xOperaID=""
						
						Set objOpera=##class(DHCWMR.SS.Operation).GetObjById(xOperaID)
						Continue:'$IsObject(objOpera)
						Set BatchNumber=objOpera.OPBatchNumber
						Continue:BatchNumber=""
						
						Set xVolID=0
						For {
							Set xVolID=$o(^DHCWMR.SS.VolumeI("VS","IndexBatchNumber"," "_BatchNumber,xVolID))
							Quit:xVolID=""
							
							Set objVol=##Class(DHCWMR.SS.Volume).GetObjById(xVolID)
							Continue:'$IsObject(objVol)
							Continue:objVol.SVIsActive'=1  //卷无效
							Set objMain=objVol.SVMainDr
							Continue:'$IsObject(objMain)
							Continue:objMain.SMIsActive'=1  //病案无效
							Continue:'$IsObject(objMain.SMMrType)
							Continue:objMain.SMMrType.%Id()'=xMrTypeID  //病案类型不一致
							
							Set EpisodeID=##Class(DHCWMR.SS.Volume).GetEpisodeID(xVolID)
							Continue:EpisodeID=""
							
							//调用集成平台组接口上传HQMS
							Do ##class(DHCWMR.IO.FromEnsSrv).DHCHisInterface(EpisodeID,"SENDADMFIRSTPAGE") 
							Set Count=Count+1
						}
					}
				}
			}
		}
	}
	
	Set return=Count
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-01-14
/// Description:  取完成病案归档操作的病案就诊列表，调用集成平台接口（上传联众）
///               青医附院自动任务，上传数据到联众病案系统
/// Table：       DHCWMR.SS.Main、DHCWMR.SS.Volume、DHCWMR.SS.VolStatus
/// Input：       DateFrom ：开始日期
///               DateTo ：结束日期
/// Return：      返回String
/// 原有方法：w ##Class(web.DHCWMRInterface.ReceiptSrv).SendToUNIBA("2012-12-21","2012-12-21")
/// 替换方法：w ##class(DHCWMR.IO.ToHistorySrv).SendToUNIBA("2015-04-02","2015-04-02","","S")
ClassMethod SendToUNIBA(aDateFrom As %String, aDateTo As %String, aMrTypeID As %String, aSysOpera As %String) As %String
{
	New (aDateFrom,aDateTo,aMrTypeID,aSysOpera)
	Set return=0
	Quit:aSysOpera="" return
	
	Set:aDateFrom["/" aDateFrom=$zdh(aDateFrom,4)
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateFrom'="" aDateFrom=+aDateFrom
	Set:aDateTo["/" aDateTo=$zdh(aDateTo,4)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set:aDateTo'="" aDateTo=+aDateTo
	Set:aDateFrom="" aDateFrom=+$h
	Set:aDateTo="" aDateTo=aDateFrom
	
	Set xMrTypeID=0,Count=0
	For {
		Set xMrTypeID=$o(^DHCWMR.SS.OperationI("IndexItemDrDate",xMrTypeID))
		Quit:xMrTypeID=""
		Continue:(aMrTypeID'="")&&(xMrTypeID'=aMrTypeID)
		
		Set xWorkItemID=0
		For {
			Set xWorkItemID=$o(^DHCWMR.SS.OperationI("IndexItemDrDate",xMrTypeID,xWorkItemID))
			Quit:xWorkItemID=""
			
			Set objWorkItem=##class(DHCWMR.SS.WorkFItem).GetWFItem(xMrTypeID,xWorkItemID)
			Continue:'$IsObject(objWorkItem)
			Continue:objWorkItem.WFISysOpera'=aSysOpera
			
			Set xDate=aDateFrom-1
			For {
				Set xDate=$o(^DHCWMR.SS.OperationI("IndexItemDrDate",xMrTypeID,xWorkItemID,xDate))
				Quit:xDate=""
				Quit:xDate>aDateTo
				
				Set xTime=""
				For {
					Set xTime=$o(^DHCWMR.SS.OperationI("IndexItemDrDate",xMrTypeID,xWorkItemID,xDate,xTime))
					Quit:xTime=""
					
					Set xOperaID=0
					For {
						Set xOperaID=$o(^DHCWMR.SS.OperationI("IndexItemDrDate",xMrTypeID,xWorkItemID,xDate,xTime,xOperaID))
						Quit:xOperaID=""
						
						Set objOpera=##class(DHCWMR.SS.Operation).GetObjById(xOperaID)
						Continue:'$IsObject(objOpera)
						Set BatchNumber=objOpera.OPBatchNumber
						Continue:BatchNumber=""
						
						Set xVolID=0
						For {
							Set xVolID=$o(^DHCWMR.SS.VolumeI("VS","IndexBatchNumber"," "_BatchNumber,xVolID))
							Quit:xVolID=""
							
							Set objVol=##Class(DHCWMR.SS.Volume).GetObjById(xVolID)
							Continue:'$IsObject(objVol)
							Continue:objVol.SVIsActive'=1  //卷无效
							Set objMain=objVol.SVMainDr
							Continue:'$IsObject(objMain)
							Continue:objMain.SMIsActive'=1  //病案无效
							Continue:'$IsObject(objMain.SMMrType)
							Continue:objMain.SMMrType.%Id()'=xMrTypeID  //病案类型不一致
							
							Set EpisodeID=##Class(DHCWMR.SS.Volume).GetEpisodeID(xVolID)
							Continue:EpisodeID=""
							
							//调用集成平台组接口上传联众病案系统
							Do ##class(DHCWMR.IO.FromEnsSrv).DHCHisInterface(EpisodeID,"SENDTOUNIBA")
							Set Count=Count+1
						}
					}
				}
			}
			
			//调用集成平台组接口上传联众病案系统？？？
			Do ##class(DHCWMR.IO.FromEnsSrv).SendToUNIBAIPDaily("")
			Do ##class(DHCWMR.IO.FromEnsSrv).SendToUNIBAIPDetail("")
		}
	}
	
	Set return=Count
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-01-14
/// Description:  取完成病案归档操作的病案就诊列表，调用集成平台接口(上传HQMS)
///               青医附院自动任务，上传HQMS
/// Table：       DHCWMR.SS.Main、DHCWMR.SS.Volume、DHCWMR.SS.VolStatus
/// Input：       DateFrom ：开始日期
///               DateTo ：结束日期
/// Return：      返回String
/// 原有方法：w ##Class(web.DHCWMRInterface.ReceiptSrv).GetRecordAdmListBM("2012-12-21","2012-12-21")
/// 替换方法：w ##class(DHCWMR.IO.ToHistorySrv).GetRecordAdmListBM("2012-12-21","2012-12-21")
ClassMethod GetRecordAdmListBM(aDateFrom As %String, aDateTo As %String, aMrTypeID As %String, aSysOpera As %String) As %String
{
	New (aDateFrom,aDateTo,aMrTypeID,aSysOpera)
	Set return=0
	Quit:aSysOpera="" return
	
	Set:aDateFrom["/" aDateFrom=$zdh(aDateFrom,4)
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateFrom'="" aDateFrom=+aDateFrom
	Set:aDateTo["/" aDateTo=$zdh(aDateTo,4)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set:aDateTo'="" aDateTo=+aDateTo
	Set:aDateFrom="" aDateFrom=+$h
	Set:aDateTo="" aDateTo=aDateFrom
	
    k ^tmpgsbbmlist
    s ^tmpgsbbmlist(0)="病案号^名称^住院次数^科室代码^科室描述"
	Set xMrTypeID=0,Count=0
	For {
		Set xMrTypeID=$o(^DHCWMR.SS.OperationI("IndexItemDrDate",xMrTypeID))
		Quit:xMrTypeID=""
		Continue:(aMrTypeID'="")&&(xMrTypeID'=aMrTypeID)
		
		Set xWorkItemID=0
		For {
			Set xWorkItemID=$o(^DHCWMR.SS.OperationI("IndexItemDrDate",xMrTypeID,xWorkItemID))
			Quit:xWorkItemID=""
			
			Set objWorkItem=##class(DHCWMR.SS.WorkFItem).GetWFItem(xMrTypeID,xWorkItemID)
			Continue:'$IsObject(objWorkItem)
			Continue:objWorkItem.WFISysOpera'=aSysOpera
			
			Set xDate=aDateFrom-1
			For {
				Set xDate=$o(^DHCWMR.SS.OperationI("IndexItemDrDate",xMrTypeID,xWorkItemID,xDate))
				Quit:xDate=""
				Quit:xDate>aDateTo
				
				Set xTime=""
				For {
					Set xTime=$o(^DHCWMR.SS.OperationI("IndexItemDrDate",xMrTypeID,xWorkItemID,xDate,xTime))
					Quit:xTime=""
					
					Set xOperaID=0
					For {
						Set xOperaID=$o(^DHCWMR.SS.OperationI("IndexItemDrDate",xMrTypeID,xWorkItemID,xDate,xTime,xOperaID))
						Quit:xOperaID=""
						
						Set objOpera=##class(DHCWMR.SS.Operation).GetObjById(xOperaID)
						Continue:'$IsObject(objOpera)
						Set BatchNumber=objOpera.OPBatchNumber
						Continue:BatchNumber=""
						
						Set xVolID=0
						For {
							Set xVolID=$o(^DHCWMR.SS.VolumeI("VS","IndexBatchNumber"," "_BatchNumber,xVolID))
							Quit:xVolID=""
							
							Set objVol=##Class(DHCWMR.SS.Volume).GetObjById(xVolID)
							Continue:'$IsObject(objVol)
							Continue:objVol.SVIsActive'=1  //卷无效
							Set objMain=objVol.SVMainDr
							Continue:'$IsObject(objMain)
							Continue:objMain.SMIsActive'=1  //病案无效
							Continue:'$IsObject(objMain.SMMrType)
							Continue:objMain.SMMrType.%Id()'=xMrTypeID  //病案类型不一致
							
							Set EpisodeID=##Class(DHCWMR.SS.Volume).GetEpisodeID(xVolID)
							Continue:EpisodeID=""
							
							Set inpatno=$p(^PAADM(EpisodeID),"^",29)
							Set papmi=$p(^PAADM(EpisodeID),"^",1)
							Set patmedno=$p(^PAPER(papmi,"PAT",1),"^",22)
							Set patname=$p(^PAPER(papmi,"ALL"),"^",1)
							Set depdr=$p(^PAADM(EpisodeID),"^",4)
							Set dep1=$p(^CTLOC(depdr),"^",1)
							Set dep2=$p(^CTLOC(depdr),"^",2)
							Set ^tmpgsbbmlist(EpisodeID)=patmedno_"^"_patname_"^"_inpatno_"^"_dep1_"^"_dep2
							
							//调用集成平台组接口上传HQMS
							Do ##class(DHCWMR.IO.FromEnsSrv).DHCHisInterface(EpisodeID,"BATCHSENDADMFIRSTPAGE")
							Set Count=Count+1
						}
					}
				}
			}
		}
	}
	
	Set return=Count
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-03-29
/// Description:  就诊号取编目归档日期
/// Table：       DHCWMR.SS.Main、DHCWMR.SS.Volume、DHCWMR.FP.FrontPage
/// Input：       Paadm ：就诊号
/// Return：      返回String
/// 原有方法：w ##class(web.DHCWMRCodingInterface).getBMSJDate(9890573)
/// 替换方法：w ##class(DHCWMR.IO.ToHistorySrv).getBMSJDate(9890573)
ClassMethod getBMSJDate(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Quit:aEpisodeID="" return
	
	Set objVol=##Class(DHCWMR.SS.Volume).GetObjByPaadm(aEpisodeID)
	Quit:'$IsObject(objVol) return
	Quit:'$IsObject(objVol.SVMainDr) return
	Quit:'$IsObject(objVol.SVMainDr.SMMrType) return
	Set VolID=objVol.%Id()
	Set MrTypeID=objVol.SVMainDr.SMMrType.%Id()
	Set objWFItem=##class(DHCWMR.SS.WorkFItem).GetWFItemBySysOpera(MrTypeID,"S") //取归档上架操作
	Quit:'$IsObject(objWFItem) return
	Quit:'$IsObject(objWFItem.WFIItem) return
	Set WorkItemID=objWFItem.WFIItem.%Id()
	
	Set objFrontPage=##class(DHCWMR.FP.FrontPage).GetObjByVolId(VolID)
	Quit:'$IsObject(objFrontPage) return
	Set FPDate=objFrontPage.FPBuildDate
	Set:FPDate'="" FPDate=$zd(FPDate,3)
	
	Set SJDate=##Class(DHCWMR.SS.Volume).GetOperaTimeByVol(VolID,WorkItemID)
	Set SJDate=$p(SJDate,",",1)
	Set:SJDate'="" SJDate=$zd(SJDate,3)
	
	Set return=FPDate_"^"_SJDate
	Quit return
}

}
