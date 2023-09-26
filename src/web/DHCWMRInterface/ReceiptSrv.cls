Import SQLUser

Class web.DHCWMRInterface.ReceiptSrv Extends (%Library.RegisteredObject, websys.Abstract) [ Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 49;

/// Creator：     zhufei
/// CreatDate：   2011-07-01
/// Description:  接诊接口
/// Table：       PA_PatMas、PA_Adm、PA_Adm2、DHC_WMR_Main、DHC_WMR_MainVolume、DHC_WMR_NoType
/// Input：       aEpisodeID: 就诊号 PA_Adm.PAADM_RowID
///               aUserID:    接诊人员 SS_User.SSU_RowId
///               aLocID:     接诊科室 CT_Loc.CTLOC_Rowid
///               aTypeID:    病案类型 DHC_WMR_NoType.Rowid（6-门诊,7-住院）
///               aMrNo:      病案号
/// Return：      返回String  return<0：接诊失败  return>0：接诊成功
/// w ##class(web.DHCWMRInterface.ReceiptSrv).Receipt("2","1","1","7","009999")
ClassMethod Receipt(aEpisodeID As %String, aUserID As %String, aLocID As %String, aTypeID As %String, aMrNo As %String) As %String
{
	New (aEpisodeID,aUserID,aLocID,aTypeID,aMrNo)
	Set return=-1
	Quit:(aEpisodeID="")||(aUserID="")||(aLocID="")||(aTypeID="") return
	
	Set ReceiptTp=..GetReceiptType(aTypeID)
	If ReceiptTp=1 {
		//按就诊分配病案号、接诊
		Set return=..ReceiptToAdm(aEpisodeID,aUserID,aLocID,aTypeID,aMrNo)
	}
	If ReceiptTp=3 {
		//按病人分配病案号、接诊
		Set return=..ReceiptToPat(aEpisodeID,aUserID,aLocID,aTypeID,aMrNo)
	}
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2011-07-01
/// Description:  取消接诊接口
/// Table：       PA_PatMas、PA_Adm、PA_Adm2、DHC_WMR_Main、DHC_WMR_MainVolume、DHC_WMR_NoType
/// Input：       aEpisodeID: 就诊号 PA_Adm.PAADM_RowID
///               aUserID:    接诊人员 SS_User.SSU_RowId
///               aLocID:     接诊科室 CT_Loc.CTLOC_Rowid
///               aTypeID:    病案类型 DHC_WMR_NoType.Rowid（6-门诊,7-住院）
/// Return：      返回String  return<0：取消接诊失败  return>0：取消接诊成功
/// w ##class(web.DHCWMRInterface.ReceiptSrv).UpdoReceipt("2","1","1","7")
ClassMethod UpdoReceipt(aEpisodeID As %String, aUserID As %String, aLocID As %String, aTypeID As %String) As %String
{
	New (aEpisodeID,aUserID,aLocID,aTypeID)
	Set return=-1
	Quit:(aEpisodeID="")||(aUserID="")||(aLocID="")||(aTypeID="") return
	
	Set ReceiptTp=..GetReceiptType(aTypeID)
	If ReceiptTp=1 {
		//按就诊分配病案号、取消接诊
		Set return=..UpdoReceiptToAdm(aEpisodeID,aUserID,aLocID)
	}
	If ReceiptTp=3 {
		//按病人分配病案号、取消接诊
		Set return=..UpdoReceiptToPat(aEpisodeID,aUserID,aLocID,aTypeID)
	}
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2011-07-01
/// Description:  取病案号接口
/// Table：       PA_PatMas、PA_Adm2、DHC_WMR_NoType、PA_Adm
/// Input：       aEpisodeID: 就诊号 PA_Adm.PAADM_RowID
///               aPatientID: 病人信息 PA_PatMas.PAPMI_RowId
///               aTypeID: 病案类型 DHC_WMR_NoType.Rowid（6-门诊,7-住院）
/// Return：      返回String
/// w ##class(web.DHCWMRInterface.ReceiptSrv).GetMrNo("2","","7")
ClassMethod GetMrNo(aEpisodeID As %String, aPatientID As %String, aTypeID As %String) As %String
{
	New (aEpisodeID,aPatientID,aTypeID)
	
	//病案3.0版本升级，兼容原有接口
	set MRSVersion=##Class(DHCWMR.IO.OutService).GetMRSVersion()
	if MRSVersion=3 {
		set return=##class(DHCWMR.IO.ToHistorySrv).GetMrNo(aEpisodeID,aPatientID,aTypeID)
		quit return
	}
	
	Set return=""
	Quit:((aEpisodeID="")&&(aPatientID=""))||(aTypeID="") return
	
	Set ReceiptTp=..GetReceiptType(aTypeID)
	If ReceiptTp=1 {
		//按就诊分配病案号
		Set return=..GetMrNoToAdm(aEpisodeID)
	}
	If ReceiptTp=3 {
		If aEpisodeID'="" {
			Set aPatientID=$p($g(^Paadm(aEpisodeID)),"^",1)
		}
		//按病人分配病案号
		Set return=..GetMrNoToPat(aPatientID,aTypeID)
	}
	
	Quit return
}

/// ***************************************************************************
/// update by zf 20110701
/// 以下程序为：根据接诊方式来处理接诊、取消接诊、取病案号程序
/// ***************************************************************************
/// 
/// 
/// 取病案接诊方式(增加设置界面)
/// 1 按就诊分病案号(不分号、不生成病案)
/// 2 按就诊分病案号+分号+生成病案
/// 3 按病人分病案号(不分号、不生成病案)
/// 4 按病人分病案号+分号+生成病案
ClassMethod GetReceiptType(aTypeID As %String)
{
	New (aTypeID)
	Set return=""
	Set:aTypeID=7 return="1"
	Quit return
}

/// 接诊方法、按就诊保存病案号+不参与分号+不生成病案
/// w ##class(web.DHCWMRInterface.ReceiptSrv).ReceiptToAdm("","","","","")
ClassMethod ReceiptToAdm(aEpisodeID As %String, aUserID As %String, aLocID As %String, aTypeID As %String, aMrNo As %String) As %String
{
	New (aEpisodeID,aUserID,aLocID,aTypeID,aMrNo)
	Set return=-1
	Quit:(aEpisodeID="")||(aUserID="")||(aLocID="")||(aTypeID="") return
	
	//记录接诊日志
	//InputStr=接诊类型ID^病案类型^病案号^病案卷ID^PatientID^EpisodeID^接诊科室ID^接诊人员ID^备注
	Set PatientID=$p($g(^Paadm(+aEpisodeID)),"^",1)
	Set InputStr="1"_"^"_aTypeID_"^"_aMrNo_"^"_""_"^"_PatientID_"^"_aEpisodeID_"^"_aLocID_"^"_aUserID_"^"_""
	Set flg=##Class(web.DHCWMRReceiptLogCtl).SaveReceiptLog(InputStr)
	
	//Set aMrNo=$ZCVT(aMrNo,"U")
	Quit:aMrNo="" return
	
	Set objPaadm2=##Class(User.PAAdm2).%OpenId(aEpisodeID)
	If '$IsObject(objPaadm2) Quit return
	
	Set objPaadm2.PAADM2OnHoldReason=aMrNo
	Set sc=objPaadm2.%Save()
	If $System.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=1
	}
	Do objPaadm2.%Close()
	
	Quit return
}

/// 取消接诊方法、按就诊保存病案号+不参与分号+不生成病案
/// w ##class(web.DHCWMRInterface.ReceiptSrv).UpdoReceiptToAdm("","","")
ClassMethod UpdoReceiptToAdm(aEpisodeID As %String, aUserID As %String, aLocID As %String) As %String
{
	New (aEpisodeID,aUserID,aLocID)
	Set return=-1
	Quit:(aEpisodeID="")||(aUserID="")||(aLocID="") return
	
	//记录取消接诊日志
	//InputStr=取消接诊ID^病案类型^病案号^病案卷ID^PatientID^EpisodeID^接诊科室ID^接诊人员ID^备注
	Set PatientID=$p($g(^Paadm(+aEpisodeID)),"^",1)
	Set InputStr="2"_"^"_""_"^"_""_"^"_""_"^"_PatientID_"^"_aEpisodeID_"^"_aLocID_"^"_aUserID_"^"_""
	Set flg=##Class(web.DHCWMRReceiptLogCtl).SaveReceiptLog(InputStr)
	
	Set objPaadm2=##Class(User.PAAdm2).%OpenId(aEpisodeID)
	If '$IsObject(objPaadm2) Quit return
	
	Set objPaadm2.PAADM2OnHoldReason=""
	Set sc=objPaadm2.%Save()
	If $System.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=1
	}
	Do objPaadm2.%Close()
	
	Quit return
}

/// 取病案号方法、按就诊保存病案号+不参与分号+不生成病案
/// w ##class(web.DHCWMRInterface.ReceiptSrv).GetMrNoToAdm("")
ClassMethod GetMrNoToAdm(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=$p($g(^PAADM(+aEpisodeID,"ADM2")),"^",20)
	Quit return
}

/// 接诊方法、按病人保存病案号+不参与分号+不生成病案
/// w ##class(web.DHCWMRInterface.ReceiptSrv).ReceiptToPat("","","","","")
ClassMethod ReceiptToPat(aEpisodeID As %String, aUserID As %String, aLocID As %String, aTypeID As %String, aMrNo As %String) As %String
{
	New (aEpisodeID,aUserID,aLocID,aTypeID,aMrNo)
	Set return=-1
	Quit:(aEpisodeID="")||(aUserID="")||(aLocID="")||(aTypeID="") return
	
	//记录接诊日志
	//InputStr=接诊类型ID^病案类型^病案号^病案卷ID^PatientID^EpisodeID^接诊科室ID^接诊人员ID^备注
	Set PatientID=$p($g(^Paadm(+aEpisodeID)),"^",1)
	Set InputStr="1"_"^"_aTypeID_"^"_aMrNo_"^"_""_"^"_PatientID_"^"_aEpisodeID_"^"_aLocID_"^"_aUserID_"^"_""
	Set flg=##Class(web.DHCWMRReceiptLogCtl).SaveReceiptLog(InputStr)
	
	//Set aMrNo=$ZCVT(aMrNo,"U")
	Quit:aMrNo="" return
	
	//取病案类型设置
	Set strMrType=##class(web.DHCWMRNoCtl).GetMrNoFormat(aTypeID)
	Quit:strMrType="" return
	Set MrNoField=$p($p(strMrType,"^",5),"/",2)
	Quit:MrNoField="" return
	
	//更新病案号
	Set flag=-1
	//paperson.paper_governcardno
	Set:MrNoField="A" flag=##class(web.DHCWMRMedBaseCtl).UpdateMrNoA(aMrNo,PatientID)
	//PA_PatMas.PAPMI_Medicare
	Set:MrNoField="B" flag=##class(web.DHCWMRMedBaseCtl).UpdateMrNoB(aMrNo,PatientID)
	//User.DHCPerson.PAPERFCMedicareCode1
	Set:MrNoField="C" flag=##class(web.DHCWMRMedBaseCtl).UpdateMrNoC(aMrNo,PatientID)
	//User.DHCPerson.PAPERFCMedicareCode2
	Set:MrNoField="D" flag=##class(web.DHCWMRMedBaseCtl).UpdateMrNoD(aMrNo,PatientID)
	Set:flag=0 return=1
	
	Quit return
}

/// 取消接诊方法、按病人保存病案号+不参与分号+不生成病案
/// w ##class(web.DHCWMRInterface.ReceiptSrv).UpdoReceiptToPat("","","")
ClassMethod UpdoReceiptToPat(aEpisodeID As %String, aUserID As %String, aLocID As %String, aTypeID As %String) As %String
{
	New (aEpisodeID,aUserID,aLocID,aTypeID)
	Set return=-1
	Quit:(aEpisodeID="")||(aUserID="")||(aLocID="")||(aTypeID="") return
	
	//记录取消接诊日志
	Set PatientID=$p($g(^Paadm(+aEpisodeID)),"^",1)
	//InputStr=取消接诊ID^病案类型^病案号^病案卷ID^PatientID^EpisodeID^接诊科室ID^接诊人员ID^备注
	Set PatientID=$p($g(^Paadm(+aEpisdoeID)),"^",1)
	Set InputStr="2"_"^"_""_"^"_""_"^"_""_"^"_PatientID_"^"_aEpisodeID_"^"_aLocID_"^"_aUserID_"^"_""
	Set flg=##Class(web.DHCWMRReceiptLogCtl).SaveReceiptLog(InputStr)
	
	//取病案类型设置
	Set strMrType=##class(web.DHCWMRNoCtl).GetMrNoFormat(aTypeID)
	Quit:strMrType="" return
	Set MrNoField=$p($p(strMrType,"^",5),"/",2)
	Quit:MrNoField="" return
	
	//更新病案号
	Set flag=-1
	//paperson.paper_governcardno
	Set:MrNoField="A" flag=##class(web.DHCWMRMedBaseCtl).UpdateMrNoA("",PatientID)
	//PA_PatMas.PAPMI_Medicare
	Set:MrNoField="B" flag=##class(web.DHCWMRMedBaseCtl).UpdateMrNoB("",PatientID)
	//User.DHCPerson.PAPERFCMedicareCode1
	Set:MrNoField="C" flag=##class(web.DHCWMRMedBaseCtl).UpdateMrNoC("",PatientID)
	//User.DHCPerson.PAPERFCMedicareCode2
	Set:MrNoField="D" flag=##class(web.DHCWMRMedBaseCtl).UpdateMrNoD("",PatientID)
	Set:flag=0 return=1
	
	Quit return
}

/// 取病案号方法、按病人保存病案号+不参与分号+不生成病案
/// w ##class(web.DHCWMRInterface.ReceiptSrv).GetMrNoToAdm("")
ClassMethod GetMrNoToPat(aPatientID As %String, aTypeID As %String) As %String
{
	New (aPatientID,aTypeID)
	Set return=""
	Quit:(aPatientID="")||(aTypeID="") return
	
	//取病案类型设置
	Set strMrType=##class(web.DHCWMRNoCtl).GetMrNoFormat(aTypeID)
	Quit:strMrType="" return
	Set MrNoField=$p($p(strMrType,"^",5),"/",2)
	Quit:MrNoField="" return
	
	//更新病案号
	Set MrNo=""
	//paperson.paper_governcardno
	Set:MrNoField="A" MrNo=##class(web.DHCWMRMedBaseCtl).GetMrNoA(aPatientID)
	//PA_PatMas.PAPMI_Medicare
	Set:MrNoField="B" MrNo=##class(web.DHCWMRMedBaseCtl).GetMrNoB(aPatientID)
	//User.DHCPerson.PAPERFCMedicareCode1
	Set:MrNoField="C" MrNo=##class(web.DHCWMRMedBaseCtl).GetMrNoC(aPatientID)
	//User.DHCPerson.PAPERFCMedicareCode2
	Set:MrNoField="D" MrNo=##class(web.DHCWMRMedBaseCtl).GetMrNoD(aPatientID)
	Set return=MrNo
	
	Quit return
}

/// creator:liyi
/// creatdate:20121221
/// description:取当天完成病案归档操作的所有病案的adm,paamd_rowid
/// 按照病案归档时间取就诊信息，然后调用接口上传HQMS
/// input:argDateFrom argDateTo
/// output:
/// debug:w ##class(web.DHCWMRInterface.ReceiptSrv).GetRecordAdmList("2012-12-21","2012-12-21")
/// debug:w ##class(web.DHCWMRInterface.ReceiptSrv).GetRecordAdmList("","")
ClassMethod GetRecordAdmList(argDateFrom As %String, argDateTo As %String) As %String
{
	New (argDateFrom,argDateTo)
	
	//病案3.0版本升级，兼容原有接口
	set MRSVersion=##Class(DHCWMR.IO.OutService).GetMRSVersion()
	if MRSVersion=3 {
		//归档上架（S）完成触发数据上传
		set return=##class(DHCWMR.IO.ToHistorySrv).GetRecordAdmList(argDateFrom,argDateTo,"","S")
		quit return
	}
	
	//Set return=""
	Set:argDateFrom["/" argDateFrom=$zdh(argDateFrom,4)
	Set:argDateFrom["-" argDateFrom=$zdh(argDateFrom,3)
	Set:argDateFrom'="" argDateFrom=+argDateFrom
	Set:argDateTo["/" argDateTo=$zdh(argDateTo,4)
	Set:argDateTo["-" argDateTo=$zdh(argDateTo,3)
	Set:argDateTo'="" argDateTo=+argDateTo
	//取当前系统的病案编目操作ID   归档上架
	//s ^tmpgsbEnsHQMS=argDateFrom_"#"_argDateTo 
	Set WorkItemId="",ret="-1"
	For{
		Set WorkItemId=$o(^DHCWMRWITM(WorkItemId))
		Quit:WorkItemId=""
		Continue:$p($g(^DHCWMRWITM(WorkItemId)),"^",3)="N"
		s:$p($g(^DHCWMRWITM(WorkItemId)),"^",2)="归档上架" StatusDr=WorkItemId   //根据医院病案编目具体的描述来判断
		}

	//如果传入参数为空，前一天的归档操作的所有病案
	if (argDateTo="")&&(argDateFrom="")
		{
			Set QueryDate=+$h   ;modified by  liyan  20130128
			Set MainVolumeId=""
			For{
				Set MainVolumeId=$o(^DHCWMRVOL(0,"VSDateStatus",QueryDate,StatusDr,MainVolumeId))
				Quit:MainVolumeId=""
				Continue:$p($g(^DHCWMRVOL(MainVolumeId)),"^",7)="N"
				Set PaadmDr=$p($g(^DHCWMRVOL(MainVolumeId)),"^",2)
				//Set return=$lb(PaadmDr,return)
				//此处调用提供的接口
				do ##class(web.DHCENS.EnsHISService).DHCHisInterface(PaadmDr,"SENDADMFIRSTPAGE") 
				//b ;111
				}
			
		}
	//如果两个传入参数不为空
	if (argDateFrom'="")&&(argDateTo'="")
	{
		Set QueryDate=argDateFrom
		Set MainVolumeId=""
		for{
				Set MainVolumeId=$o(^DHCWMRVOL(0,"VSDateStatus",QueryDate,StatusDr,MainVolumeId))
				Quit:MainVolumeId=""
				Continue:QueryDate>argDateTo
				Continue:$p($g(^DHCWMRVOL(MainVolumeId)),"^",7)="N"
				Set PaadmDr=$p($g(^DHCWMRVOL(MainVolumeId)),"^",2)
				//Set return=$lb(PaadmDr,return)
				//此处调用提供的接口
				s ret=##class(web.DHCENS.EnsHISService).DHCHisInterface(PaadmDr,"SENDADMFIRSTPAGE")
			}
		
		}
	//如果开始日期为不为空，结束日期为空
	if (argDateFrom'="")&&(argDateTo="")
	{
		Set CurrDate=$p($h,",",1)
		if (argDateFrom<=CurrDate)
			{
				Set QueryDate=argDateFrom
				Set MainVolumeId=""
				for{
					Set MainVolumeId=$o(^DHCWMRVOL(0,"VSDateStatus",QueryDate,StatusDr,MainVolumeId))
					Quit:MainVolumeId=""
					Continue:QueryDate>argDateFrom
					Continue:$p($g(^DHCWMRVOL(MainVolumeId)),"^",7)="N"
					Set PaadmDr=$p($g(^DHCWMRVOL(MainVolumeId)),"^",2)
					//Set return=$lb(PaadmDr,return)
					//此处调用提供的接口
					s ret=##class(web.DHCENS.EnsHISService).DHCHisInterface(PaadmDr,"SENDADMFIRSTPAGE")
					}
			}
		}
		q +ret
}

/// w ##class(web.DHCWMRInterface.ReceiptSrv).SendToUNIBA("","")
ClassMethod SendToUNIBA(argDateFrom As %String, argDateTo As %String) As %String
{
	New (argDateFrom,argDateTo)
	
	//病案3.0版本升级，兼容原有接口
	set MRSVersion=##Class(DHCWMR.IO.OutService).GetMRSVersion()
	if MRSVersion=3 {
		//归档上架（S）完成触发数据上传
		set return=##class(DHCWMR.IO.ToHistorySrv).SendToUNIBA(argDateFrom,argDateTo,"","S")
		quit return
	}
	
	//Set return=""
	Set:argDateFrom["/" argDateFrom=$zdh(argDateFrom,4)
	Set:argDateFrom["-" argDateFrom=$zdh(argDateFrom,3)
	Set:argDateFrom'="" argDateFrom=+argDateFrom
	Set:argDateTo["/" argDateTo=$zdh(argDateTo,4)
	Set:argDateTo["-" argDateTo=$zdh(argDateTo,3)
	Set:argDateTo'="" argDateTo=+argDateTo
	//取当前系统的病案编目操作ID   归档上架
	//s ^tmpgsbEnsHQMS=argDateFrom_"#"_argDateTo 
	Set WorkItemId="",ret="-1"
	For{
		Set WorkItemId=$o(^DHCWMRWITM(WorkItemId))
		Quit:WorkItemId=""
		Continue:$p($g(^DHCWMRWITM(WorkItemId)),"^",3)="N"
		s:$p($g(^DHCWMRWITM(WorkItemId)),"^",2)="归档上架" StatusDr=WorkItemId   //根据医院病案编目具体的描述来判断
		}

	//如果传入参数为空，前一天的归档操作的所有病案
	if (argDateTo="")&&(argDateFrom="")
		{
			Set QueryDate=+$h   ;modified by  liyan  20130128
			Set MainVolumeId=""
			For{
				Set MainVolumeId=$o(^DHCWMRVOL(0,"VSDateStatus",QueryDate,StatusDr,MainVolumeId))
				Quit:MainVolumeId=""
				Continue:$p($g(^DHCWMRVOL(MainVolumeId)),"^",7)="N"
				Set PaadmDr=$p($g(^DHCWMRVOL(MainVolumeId)),"^",2)
				//Set return=$lb(PaadmDr,return)
				//此处调用提供的接口
				do ##class(web.DHCENS.EnsHISService).DHCHisInterface(PaadmDr,"SENDTOUNIBA") 
				}
			d ##class(web.DHCENS.BLL.Empi.Method.SendToUNIBA).SendToUNIBAIPDaily("")
			d ##class(web.DHCENS.BLL.Empi.Method.SendToUNIBA).SendToUNIBAIPDetail("")
			
		}
	//如果两个传入参数不为空
	if (argDateFrom'="")&&(argDateTo'="")
	{
		Set QueryDate=argDateFrom,count=0
		Set MainVolumeId=""
		for{
				Set MainVolumeId=$o(^DHCWMRVOL(0,"VSDateStatus",QueryDate,StatusDr,MainVolumeId))
				Quit:MainVolumeId=""
				Continue:QueryDate>argDateTo
				Continue:$p($g(^DHCWMRVOL(MainVolumeId)),"^",7)="N"
				Set PaadmDr=$p($g(^DHCWMRVOL(MainVolumeId)),"^",2)
				//Set return=$lb(PaadmDr,return)
				//此处调用提供的接口
				s count=count+1
				s ret=##class(web.DHCENS.EnsHISService).DHCHisInterface(PaadmDr,"SENDTOUNIBA")
			}
			s ^enswang("count")=count
		
		}
	//如果开始日期为不为空，结束日期为空
	if (argDateFrom'="")&&(argDateTo="")
	{
		Set CurrDate=$p($h,",",1)
		if (argDateFrom<=CurrDate)
			{
				Set QueryDate=argDateFrom
				Set MainVolumeId=""
				for{
					Set MainVolumeId=$o(^DHCWMRVOL(0,"VSDateStatus",QueryDate,StatusDr,MainVolumeId))
					Quit:MainVolumeId=""
					Continue:QueryDate>argDateFrom
					Continue:$p($g(^DHCWMRVOL(MainVolumeId)),"^",7)="N"
					Set PaadmDr=$p($g(^DHCWMRVOL(MainVolumeId)),"^",2)
					//Set return=$lb(PaadmDr,return)
					//此处调用提供的接口
					s ret=##class(web.DHCENS.EnsHISService).DHCHisInterface(PaadmDr,"SENDTOUNIBA")
					}
			}
		}
		q +ret
}

/// creator:liyi
/// creatdate:20140809
/// description:取当天完成【病案编目】操作的所有病案的adm,paamd_rowid
/// 按照病案归档时间取就诊信息，然后调用接口上传HQMS
/// input:argDateFrom argDateTo
/// output:
/// debug:w ##class(web.DHCWMRInterface.ReceiptSrv).GetRecordAdmListBM("2014-08-1","2014-08-31")
/// debug:w ##class(web.DHCWMRInterface.ReceiptSrv).GetRecordAdmListBM("","")
ClassMethod GetRecordAdmListBM(argDateFrom As %String, argDateTo As %String) As %String
{
	New (argDateFrom,argDateTo)
	
	//病案3.0版本升级，兼容原有接口
	set MRSVersion=##Class(DHCWMR.IO.OutService).GetMRSVersion()
	if MRSVersion=3 {
		//病案编目（FP）完成触发数据上传
		set return=##class(DHCWMR.IO.ToHistorySrv).GetRecordAdmListBM(argDateFrom,argDateTo,"","FP")
		quit return
	}
	
	//Set return=""
	Set:argDateFrom["/" argDateFrom=$zdh(argDateFrom,4)
	Set:argDateFrom["-" argDateFrom=$zdh(argDateFrom,3)
	Set:argDateFrom'="" argDateFrom=+argDateFrom
	Set:argDateTo["/" argDateTo=$zdh(argDateTo,4)
	Set:argDateTo["-" argDateTo=$zdh(argDateTo,3)
	Set:argDateTo'="" argDateTo=+argDateTo
	//取当前系统的病案编目操作ID   归档上架
	//s ^tmpgsbEnsHQMS=argDateFrom_"#"_argDateTo 
	Set WorkItemId="",ret="-1"
	For{
		Set WorkItemId=$o(^DHCWMRWITM(WorkItemId))
		Quit:WorkItemId=""
		Continue:$p($g(^DHCWMRWITM(WorkItemId)),"^",3)="N"
		s:$p($g(^DHCWMRWITM(WorkItemId)),"^",2)="病案编目" StatusDr=WorkItemId   //根据医院病案编目具体的描述来判断
		}

	//如果传入参数为空，前一天的归档操作的所有病案
	if (argDateTo="")&&(argDateFrom="")
		{
			Set QueryDate=+$h   ;modified by  liyan  20130128
			Set MainVolumeId=""
			For{
				Set MainVolumeId=$o(^DHCWMRVOL(0,"VSDateStatus",QueryDate,StatusDr,MainVolumeId))
				Quit:MainVolumeId=""
				Continue:$p($g(^DHCWMRVOL(MainVolumeId)),"^",7)="N"
				Set PaadmDr=$p($g(^DHCWMRVOL(MainVolumeId)),"^",2)
				//Set return=$lb(PaadmDr,return)
				//此处调用提供的接口
				do ##class(web.DHCENS.EnsHISService).DHCHisInterface(PaadmDr,"BATCHSENDADMFIRSTPAGE") 
				b ;111
				}
			
		}
	//如果两个传入参数不为空
	/*
	if (argDateFrom'="")&&(argDateTo'="")
	{
		Set QueryDate=argDateFrom
		Set MainVolumeId=""
		for{
				Set MainVolumeId=$o(^DHCWMRVOL(0,"VSDateStatus",QueryDate,StatusDr,MainVolumeId))
				Quit:MainVolumeId=""
				Continue:QueryDate>argDateTo
				Continue:$p($g(^DHCWMRVOL(MainVolumeId)),"^",7)="N"
				Set PaadmDr=$p($g(^DHCWMRVOL(MainVolumeId)),"^",2)
				//Set return=$lb(PaadmDr,return)
				//此处调用提供的接口
				s ret=##class(web.DHCENS.EnsHISService).DHCHisInterface(PaadmDr,"BATCHSENDADMFIRSTPAGE")
			}
		
		}
		*/
    k ^tmpgsbbmlist
    s ^tmpgsbbmlist(0)="病案号^名称^住院次数^科室代码^科室描述"
	if (argDateFrom'="")&&(argDateTo'="") d
	.q:argDateFrom>argDateTo
	.f QueryDate=argDateFrom:1:argDateTo d
	..s MainVolumeId=""
	..f  s MainVolumeId=$o(^DHCWMRVOL(0,"VSDateStatus",QueryDate,StatusDr,MainVolumeId))  q:MainVolumeId=""  d
	...q:$p($g(^DHCWMRVOL(MainVolumeId)),"^",7)="N"
	...Set PaadmDr=$p($g(^DHCWMRVOL(MainVolumeId)),"^",2)
	...//w $zd(QueryDate,3),!
	...s inpatno=$p(^PAADM(PaadmDr),"^",29)
	...s papmi=$p(^PAADM(PaadmDr),"^",1)
	...s patmedno=$p(^PAPER(papmi,"PAT",1),"^",22)
	...s patname=$p(^PAPER(papmi,"ALL"),"^",1)
	...s depdr=$p(^PAADM(PaadmDr),"^",4)
	...s dep1=$p(^CTLOC(depdr),"^",1)
	...s dep2=$p(^CTLOC(depdr),"^",2)
	...s ^tmpgsbbmlist(PaadmDr)=patmedno_"^"_patname_"^"_inpatno_"^"_dep1_"^"_dep2
	...s ret=##class(web.DHCENS.EnsHISService).DHCHisInterface(PaadmDr,"BATCHSENDADMFIRSTPAGE")
		
	//如果开始日期为不为空，结束日期为空
	if (argDateFrom'="")&&(argDateTo="")
	{
		Set CurrDate=$p($h,",",1)
		if (argDateFrom<=CurrDate)
			{
				Set QueryDate=argDateFrom
				Set MainVolumeId=""
				for{
					Set MainVolumeId=$o(^DHCWMRVOL(0,"VSDateStatus",QueryDate,StatusDr,MainVolumeId))
					Quit:MainVolumeId=""
					Continue:QueryDate>argDateFrom
					Continue:$p($g(^DHCWMRVOL(MainVolumeId)),"^",7)="N"
					Set PaadmDr=$p($g(^DHCWMRVOL(MainVolumeId)),"^",2)
					//Set return=$lb(PaadmDr,return)
					//此处调用提供的接口
					s ret=##class(web.DHCENS.EnsHISService).DHCHisInterface(PaadmDr,"BATCHSENDADMFIRSTPAGE")
					}
			}
		}
		q +ret
}

}
