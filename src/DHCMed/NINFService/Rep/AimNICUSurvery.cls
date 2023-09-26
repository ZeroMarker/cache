/// 名称: DHCMed.NINFService.Rep.AimNICUSurvery
/// 描述: 新生儿日常监测记录
/// 编写者：zhufei
/// 编写日期: 2012-05-16
Class DHCMed.NINFService.Rep.AimNICUSurvery Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// w ##Class(DHCMed.NINFService.Rep.AimNICUSurvery).GetOldData()
ClassMethod GetOldData()
{
	Quit "Over!"
}

/// w ##Class(DHCMed.NINFService.Rep.AimNICUSurvery).GetBornWeight()
ClassMethod GetBornWeight()
{
	Quit 1
}

/// 生成ICU调查日志数据任务
/// w ##Class(DHCMed.NINFService.Rep.AimICUSurvery).LogDataProcess("2013-07",289)
ClassMethod LogDataProcess(argYYMM As %String, argLoc As %String) As %String
{
	New (argYYMM,argLoc)
	Set return=""
	
	Quit:(argYYMM="")||(argLoc="") "参数不足,不能初始化数据!"
	
	Set xDateFrom=argYYMM_"-01"
	Set xDateFrom=$zdh(xDateFrom,3)
	Set xDateTo=xDateFrom+32
	Set xDateTo=$zd(xDateTo,3)
	Set xDateTo=$p(xDateTo,"-",1)_"-"_$p(xDateTo,"-",2)_"-01"
	Set xDateTo=$zdh(xDateTo,3)-1
	
	Set LocID=argLoc
	Set LocDesc=$p($g(^CTLOC(LocID)),"^",2)
	Quit:LocDesc="" "参数错误,不能初始化数据!"
	Set:$p(LocDesc,"-",2)'="" LocDesc=$p(LocDesc,"-",2)
	
	Set LogDataProcType=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("NINFNICUSurveryDataType","")
	If LogDataProcType=1 {
		Set flg=..LogDataProcessByOE(xDateFrom,xDateTo,LocID)
		Set:flg'="OK" return="生成数据错误："_flg
	} ElseIf LogDataProcType="ByICU" {
		//Set flg=..LogDataProcessByOE(xDateFrom,xDateTo,LocID)
		//Set:flg'="OK" return="生成数据错误："_flg
	} ElseIf LogDataProcType="ByRep" {
		//Set flg=..LogDataProcessByRep(xDateFrom,xDateTo,LocID)
		//Set:flg'="OK" return="生成数据错误："_flg
	} Else {
		Set return="初始化数据方式未设置,无法初始化数据!"
	}
	
	Set:return="" return="OK"
	Quit return
}

/// 生成新生儿调查日志任务
/// w ##Class(DHCMed.NINFService.Rep.AimNICUSurvery).LogDataProcessByOE($zdh("2013-06-25",3),$zdh("2013-07-10",3),25)
ClassMethod LogDataProcessByOE(aFromDate As %String, aToDate As %String, aLocID As %String = "") As %String
{
	New (aFromDate,aToDate,aLocID,aFlag)
	Set return=""
	Quit:(aFromDate="")||(aToDate="") return
	Quit:(aToDate<aFromDate) return
	Quit:(aToDate-aFromDate)>60 return
	
	Set $ZT="LogDataProcessErr"
	Set:(aToDate>=(+$h)) aToDate=(+$h)-1
	
	Kill ^TMP($zn,$j,"LogDataProcess")
	//^TMP($zn,$j,"LogDataProcess",xLocID,xDate,1,"NPICC")
	//计算新入科人数
	For xDate=aFromDate:1:aToDate {
		Set xLocID=0
		For {
			Set xLocID=$o(^DHCMed.CC.CtlResultI("AdmTrans",0,"IndexInDateLoc",xDate,xLocID))
			Quit:xLocID=""
			Continue:(aLocID'="")&&(aLocID'=xLocID)
			
			Set xPaadm=0
			For {
				Set xPaadm=$o(^DHCMed.CC.CtlResultI("AdmTrans",0,"IndexInDateLoc",xDate,xLocID,xPaadm))
				Quit:xPaadm=""
				Set xAimTransID=0
				For {
					Set xAimTransID=$o(^DHCMed.CC.CtlResultI("AdmTrans",0,"IndexInDateLoc",xDate,xLocID,xPaadm,xAimTransID))
					Quit:xAimTransID=""
					
					Set objAimTrans=##class(DHCMed.CC.CtlAdmTrans).GetObjById(xAimTransID)
					Continue:'$IsObject(objAimTrans)
					Continue:objAimTrans.LinkID'=""  //LinkID非空表示临时记录
					
					Set BornWeight=##class(DHCMed.NINFService.Rep.AimNICUSurvery).GetBornWeight()
					Continue:$d(^TMP($zn,$j,"LogDataProcess",xLocID,xDate,BornWeight,"NewInHosp"))
					Set ^TMP($zn,$j,"LogDataProcess",xLocID,xDate,BornWeight,"NewInHosp",xPaadm)=""
					Set num=$i(^TMP($zn,$j,"LogDataProcess",xLocID,xDate,BornWeight,"NewInHosp"))
				}
			}
		}
	}
	//计算科室在院人数
	For xDate=aFromDate:1:(aToDate+10) {
		Set xLocID=0
		For {
			Set xLocID=$o(^DHCMed.CC.CtlResultI("AdmTrans",0,"IndexOutDateLoc",xDate,xLocID))
			Quit:xLocID=""
			Continue:(aLocID'="")&&(aLocID'=xLocID)
			
			Set xPaadm=0
			For {
				Set xPaadm=$o(^DHCMed.CC.CtlResultI("AdmTrans",0,"IndexOutDateLoc",xDate,xLocID,xPaadm))
				Quit:xPaadm=""
				
				Set xAimTransID=0
				For {
					Set xAimTransID=$o(^DHCMed.CC.CtlResultI("AdmTrans",0,"IndexOutDateLoc",xDate,xLocID,xPaadm,xAimTransID))
					Quit:xAimTransID=""
					
					Set objAimTrans=##class(DHCMed.CC.CtlAdmTrans).GetObjById(xAimTransID)
					Continue:'$IsObject(objAimTrans)
					If objAimTrans.LinkID'="" {
						Set tmpAimTransID=objAimTrans.LinkID
						Set objAimTrans=##class(DHCMed.CC.CtlAdmTrans).GetObjById(tmpAimTransID)
						Continue:'$IsObject(objAimTrans)
					} Else {
						Set tmpAimTransID=objAimTrans.%Id()
					}
					Continue:$d(^TMP($zn,$j,"LogDataProcess","AdmTrans",tmpAimTransID))
					Set ^TMP($zn,$j,"LogDataProcess","AdmTrans",tmpAimTransID)=""
					Set TransInDate=objAimTrans.TransInDate
					Set TransOutDate=objAimTrans.TransOutDate
					Continue:TransInDate>aToDate
					Continue:TransOutDate<aFromDate
					
					//在院患者，出院、死亡算当天在院，当天入院不算
					For indDate=(TransInDate+1):1:TransOutDate {
						Continue:indDate<aFromDate
						Quit:indDate>aToDate
				
						Set BornWeight=##class(DHCMed.NINFService.Rep.AimNICUSurvery).GetBornWeight()
						Continue:$d(^TMP($zn,$j,"LogDataProcess",xLocID,xDate,BornWeight,"InHosp"))
						Set ^TMP($zn,$j,"LogDataProcess",xLocID,xDate,BornWeight,"InHosp",xPaadm)=""
						Set num=$i(^TMP($zn,$j,"LogDataProcess",xLocID,xDate,BornWeight,"InHosp"))
						
					}
				}
			}
		}
	}
	
	//系统直接从医嘱提取插管人数
	Set IntubateTypeList=$lb("PICC","VAP","UC")
	For xDate=aFromDate:1:(aToDate+10) {
		Set xLocID=0
		For {
			Set xLocID=$o(^DHCMed.CC.CtlResultI("AdmTrans",0,"IndexOutDateLoc",xDate,xLocID))
			Quit:xLocID=""
			Continue:(aLocID'="")&&(aLocID'=xLocID)
			
			Set xPaadm=0
			For {
				Set xPaadm=$o(^DHCMed.CC.CtlResultI("AdmTrans",0,"IndexOutDateLoc",xDate,xLocID,xPaadm))
				Quit:xPaadm=""
				
				//已处理过，不再重复处理
				Continue:$d(^TMP($zn,$j,"LogDataProcess","PaadmList",xPaadm))
				Set ^TMP($zn,$j,"LogDataProcess","PaadmList",xPaadm)=""
				
				Set listPICC=##class(DHCMed.NINF.Srv.ICUIntubate).GetICUResults(xPaadm,"NPICC")
				Set listVAP=##class(DHCMed.NINF.Srv.ICUIntubate).GetICUResults(xPaadm,"NVNT")
				Set listUC=##class(DHCMed.NINF.Srv.ICUIntubate).GetICUResults(xPaadm,"NUC")
				
				Set listTrans=##class(DHCMed.NINFService.Srv.CommonCls).GetTransLocListNew(xPaadm,"W")
				For indTrans=1:1:$listlength(listTrans) {
					Set tmpTrans=$list(listTrans,indTrans)
					Continue:tmpTrans=""
					
					Set TransID=$list(tmpTrans,1)
					Set TransLocID=$list(tmpTrans,2)
					Continue:(aLocID'="")&&(aLocID'=TransLocID)
					
					Set TransLocDesc=$list(tmpTrans,3)
					Set TransInDateTime=$list(tmpTrans,4)
					Set TransOutDateTime=$list(tmpTrans,5)
					
					Set TransInDate=$p(TransInDateTime," ",1)
					Set:TransInDate'="" TransInDate=$zdh(TransInDate,3)
					Set TransInTime=$p(TransInDateTime," ",2)
					Set:TransInTime'="" TransInTime=$zth(TransInTime,1)
					Set TransOutDate=$p(TransOutDateTime," ",1)
					Set:TransOutDate'="" TransOutDate=$zdh(TransOutDate,3)
					Set:TransOutDate="" TransOutDate=$p($h,",",1)
					Set TransOutTime=$p(TransOutDateTime," ",2)
					Set:TransOutTime'="" TransOutTime=$zth(TransOutTime,1)
					Set:TransOutTime="" TransOutTime=$p($h,",",2)
					
					//PICC
					For indPICC=1:1:listPICC.Count() {
						Set objPICC=listPICC.GetAt(indPICC)
						Continue:'$IsObject(objPICC)
						Set IntubateDate=objPICC.IntubateDate
						Set IntubateTime=objPICC.IntubateTime
						Set ExtubateDate=objPICC.ExtubateDate
						Set ExtubateTime=objPICC.ExtubateTime
						Set DataSource=objPICC.DataSource
						Set OEItemID=$p(DataSource,":",2)
						
						//筛选符合条件插管信息
						Continue:IntubateDate>TransOutDate
						Continue:(IntubateDate=TransOutDate)&&(IntubateTime>TransOutTime)
						If ExtubateDate'="" {
							Continue:ExtubateDate<TransInDate
							//Continue:(ExtubateDate=TransInDate)&&(ExtubateTime<TransInTime)
						} Else {
							Set ExtubateDate=TransOutDate
							Set ExtubateTime=TransOutTime
						}
						Continue:IntubateDate>ExtubateDate
						Set:IntubateDate<aFromDate IntubateDate=aFromDate
						Set:ExtubateDate>aToDate ExtubateDate=aToDate
						Set:IntubateDate<TransInDate IntubateDate=TransInDate
						Set:ExtubateDate>TransOutDate ExtubateDate=TransOutDate
						
						For indDate=IntubateDate:1:ExtubateDate {
							Set BornWeight=##class(DHCMed.NINFService.Rep.AimNICUSurvery).GetBornWeight()
							Continue:$d(^TMP($zn,$j,"LogDataProcess",xLocID,xDate,BornWeight,"NPICC"))
							Set ^TMP($zn,$j,"LogDataProcess",xLocID,xDate,BornWeight,"NPICC",xPaadm)=""
							Set num=$i(^TMP($zn,$j,"LogDataProcess",xLocID,xDate,BornWeight,"NPICC"))
						}
					}
					
					
					//VAP
					For indVAP=1:1:listVAP.Count() {
						Set objVAP=listVAP.GetAt(indVAP)
						Continue:'$IsObject(objVAP)
						Set IntubateDate=objVAP.IntubateDate
						Set IntubateTime=objVAP.IntubateTime
						Set ExtubateDate=objVAP.ExtubateDate
						Set ExtubateTime=objVAP.ExtubateTime
						Set DataSource=objVAP.DataSource
						Set OEItemID=$p(DataSource,":",2)
						
						//筛选符合条件插管信息
						Continue:IntubateDate>TransOutDate
						Continue:(IntubateDate=TransOutDate)&&(IntubateTime>TransOutTime)
						If ExtubateDate'="" {
							Continue:ExtubateDate<TransInDate
							//Continue:(ExtubateDate=TransInDate)&&(ExtubateTime<TransInTime)
						} Else {
							Set ExtubateDate=TransOutDate
							Set ExtubateTime=TransOutTime
						}
						Continue:IntubateDate>ExtubateDate
						Set:IntubateDate<aFromDate IntubateDate=aFromDate
						Set:ExtubateDate>aToDate ExtubateDate=aToDate
						Set:IntubateDate<TransInDate IntubateDate=TransInDate
						Set:ExtubateDate>TransOutDate ExtubateDate=TransOutDate
						
						For indDate=IntubateDate:1:ExtubateDate {
							Set BornWeight=##class(DHCMed.NINFService.Rep.AimNICUSurvery).GetBornWeight()
							Continue:$d(^TMP($zn,$j,"LogDataProcess",xLocID,xDate,BornWeight,"NVNT"))
							Set ^TMP($zn,$j,"LogDataProcess",xLocID,xDate,BornWeight,"NVNT",xPaadm)=""
							Set num=$i(^TMP($zn,$j,"LogDataProcess",xLocID,xDate,BornWeight,"NVNT"))
						}
					}
					
					//UC
					For indUC=1:1:listUC.Count() {
						Set objUC=listUC.GetAt(indUC)
						Continue:'$IsObject(objUC)
						Set IntubateDate=objUC.IntubateDate
						Set IntubateTime=objUC.IntubateTime
						Set ExtubateDate=objUC.ExtubateDate
						Set ExtubateTime=objUC.ExtubateTime
						Set DataSource=objUC.DataSource
						Set OEItemID=$p(DataSource,":",2)
						
						//筛选符合条件插管信息
						Continue:IntubateDate>TransOutDate
						Continue:(IntubateDate=TransOutDate)&&(IntubateTime>TransOutTime)
						If ExtubateDate'="" {
							Continue:ExtubateDate<TransInDate
							//Continue:(ExtubateDate=TransInDate)&&(ExtubateTime<TransInTime)
						} Else {
							Set ExtubateDate=TransOutDate
							Set ExtubateTime=TransOutTime
						}
						Continue:IntubateDate>ExtubateDate
						Set:IntubateDate<aFromDate IntubateDate=aFromDate
						Set:ExtubateDate>aToDate ExtubateDate=aToDate
						Set:IntubateDate<TransInDate IntubateDate=TransInDate
						Set:ExtubateDate>TransOutDate ExtubateDate=TransOutDate
						
						For indDate=IntubateDate:1:ExtubateDate {
							Set BornWeight=##class(DHCMed.NINFService.Rep.AimNICUSurvery).GetBornWeight()
							Continue:$d(^TMP($zn,$j,"LogDataProcess",xLocID,xDate,BornWeight,"NUC"))
							Set ^TMP($zn,$j,"LogDataProcess",xLocID,xDate,BornWeight,"NUC",xPaadm)=""
							Set num=$i(^TMP($zn,$j,"LogDataProcess",xLocID,xDate,BornWeight,"NUC"))
						}
					}
				}
			}
		}
	}

	//计算科室感染人数
	For xDate=aFromDate:1:(aToDate+10) {
		Set xLocID=0
		For {
			Set xLocID=$o(^DHCMed.CC.CtlResultI("AdmTrans",0,"IndexOutDateLoc",xDate,xLocID))
			Quit:xLocID=""
			Continue:(aLocID'="")&&(aLocID'=xLocID)
			
			Set xPaadm=0
			For {
				Set xPaadm=$o(^DHCMed.CC.CtlResultI("AdmTrans",0,"IndexOutDateLoc",xDate,xLocID,xPaadm))
				Quit:xPaadm=""
				
				Set xRepID=0
				For {
					Set xRepID=$o(^DHCMed.NINFi("InfRep",0,"IndexPaadm",xPaadm,xRepID))
					Quit:xRepID=""
					
					Set objRep=##class(DHCMed.NINF.Rep.InfReport).GetObjById(xRepID)
					Continue:'$IsObject(objRep)
					Set StatusCode=objRep.ReportStatus.Code
					Set StatusDesc=objRep.ReportStatus.Description
					Continue:StatusCode["0"  //删除的报告
					
					Set xSubID=""
					For {
						Set xSubID=$o(^DHCMed.NINF("InfRep",xRepID,"InfPos",xSubID))
						Quit:xSubID=""
						Set objInfPos=##class(DHCMed.NINF.Rep.InfReportInfPos).GetObjById(xRepID_"||"_xSubID)
						Continue:'$IsObject(objInfPos)
						Continue:'$IsObject(objInfPos.InfDiag)
						Set InfDate=objInfPos.InfDate
						//检查感染当天是否在科室住院患者列表当中
						Continue:'$d(^TMP($zn,$j,"LogDataProcess","Data",xLocID,InfDate,"InHosp",xPaadm))
						
						Set InfDiagDesc=objInfPos.InfDiag.IDDesc
						Set InfDiagICD10=objInfPos.InfDiag.IDICD10
						
						Set BornWeight=##class(DHCMed.NINFService.Rep.AimNICUSurvery).GetBornWeight()
						//血管导管相关血流感染
						If InfDiagICD10["T82.703" {  //导管相关性感染
							If '$d(^TMP($zn,$j,"LogDataProcess",xLocID,xDate,BornWeight,"NPICCInf",xPaadm))
							{
								Set ^TMP($zn,$j,"LogDataProcess",xLocID,xDate,BornWeight,"NPICCInf",xPaadm)=""
								Set num=$i(^TMP($zn,$j,"LogDataProcess",xLocID,xDate,BornWeight,"NPICCInf"))
							}
							If '$d(^TMP($zn,$j,"LogDataProcess",xLocID,xDate,BornWeight,"PatInf",xPaadm))
							{
								Set num=$i(^TMP($zn,$j,"LogDataProcess",xLocID,xDate,BornWeight,"PatInf"))
								Set ^TMP($zn,$j,"LogDataProcess",xLocID,xDate,BornWeight,"PatInf",xPaadm)=""
							}
						}
						//呼吸机相关肺炎感染
						If InfDiagICD10["J18.901" {  //肺炎
							If '$d(^TMP($zn,$j,"LogDataProcess",xLocID,xDate,BornWeight,"NVNTInf",xPaadm))
							{
								Set ^TMP($zn,$j,"LogDataProcess",xLocID,xDate,BornWeight,"NVNTInf",xPaadm)=""
								Set num=$i(^TMP($zn,$j,"LogDataProcess",xLocID,xDate,BornWeight,"NVNTInf"))
							}
							If '$d(^TMP($zn,$j,"LogDataProcess",xLocID,xDate,BornWeight,"PatInf",xPaadm))
							{
								Set num=$i(^TMP($zn,$j,"LogDataProcess",xLocID,xDate,BornWeight,"PatInf"))
								Set ^TMP($zn,$j,"LogDataProcess",xLocID,xDate,BornWeight,"PatInf",xPaadm)=""
							}
						}
						//泌尿道插管相关泌尿道感染
						If InfDiagICD10["N39.001" {  //泌尿道股黯然
							If '$d(^TMP($zn,$j,"LogDataProcess",xLocID,xDate,BornWeight,"NUCInf",xPaadm))
							{
								Set ^TMP($zn,$j,"LogDataProcess",xLocID,xDate,BornWeight,"NUCInf",xPaadm)=""
								Set num=$i(^TMP($zn,$j,"LogDataProcess",xLocID,xDate,BornWeight,"NUCInf"))
							}
							If '$d(^TMP($zn,$j,"LogDataProcess",xLocID,xDate,BornWeight,"PatInf",xPaadm))
							{
								Set num=$i(^TMP($zn,$j,"LogDataProcess",xLocID,xDate,BornWeight,"PatInf"))
								Set ^TMP($zn,$j,"LogDataProcess",xLocID,xDate,BornWeight,"PatInf",xPaadm)=""
							}
						}
					}
				}
			}
		}
	}

	Set xLocID=0
	For {
		Set xLocID=$o(^TMP($zn,$j,"LogDataProcess",xLocID))
		Quit:xLocID=""
		Set xDate=aFromDate-1
		For {
			Set xDate=$o(^TMP($zn,$j,"LogDataProcess",xLocID,xDate))
			Quit:xDate=""
			Quit:xDate>aToDate
			
			Set (UpdateUser)=""
			Set (Item1,Item2,Item3,Item4,Item5,Item6,Item7,Item8)=""
			Set (Item9,Item10,Item11,Item12,Item13,Item14,Item15,Item16)=""
			Set (Item1A,Item2A,Item3A,Item4A,Item5A,Item6A,Item7A,Item8A)=""
			Set (Item9A,Item10A,Item11A,Item12A,Item13A,Item14A,Item15A,Item16A)=""
			
			Set xLogID=$o(^DHCMed.NINFi("Aim","NICUS","IndexLocDate",xLocID,xDate,0))
			Set objLog=##class(DHCMed.NINF.Rep.AimNICUSurvery).GetObjById(xLogID)
			If $IsObject(objLog)
			{
				Set UpdateUser=objLog.UpdateUser
				Set Item1=objLog.ANISItem1
				Set Item2=objLog.ANISItem2
				Set Item3=objLog.ANISItem3
				Set Item4=objLog.ANISItem4
				Set Item5=objLog.ANISItem5
				Set Item6=objLog.ANISItem6
				Set Item7=objLog.ANISItem7
				Set Item8=objLog.ANISItem8
				Set Item9=objLog.ANISItem9
				Set Item10=objLog.ANISItem10
				Set Item11=objLog.ANISItem11
				Set Item12=objLog.ANISItem12
				Set Item13=objLog.ANISItem13
				Set Item14=objLog.ANISItem14
				Set Item15=objLog.ANISItem15
				Set Item16=objLog.ANISItem16
				Set Item1A=objLog.ANISItem1A
				Set Item2A=objLog.ANISItem2A
				Set Item3A=objLog.ANISItem3A
				Set Item4A=objLog.ANISItem4A
				Set Item5A=objLog.ANISItem5A
				Set Item6A=objLog.ANISItem6A
				Set Item7A=objLog.ANISItem7A
				Set Item8A=objLog.ANISItem8A
				Set Item9A=objLog.ANISItem9A
				Set Item10A=objLog.ANISItem10A
				Set Item11A=objLog.ANISItem11A
				Set Item12A=objLog.ANISItem12A
				Set Item13A=objLog.ANISItem13A
				Set Item14A=objLog.ANISItem14A
				Set Item15A=objLog.ANISItem15A
				Set Item16A=objLog.ANISItem16A
			}
			
			
			Set Item1=+$g(^TMP($zn,$j,"LogDataProcess",xLocID,xDate,1,"NewInHosp"))
			Set Item2=+$g(^TMP($zn,$j,"LogDataProcess",xLocID,xDate,1,"InHosp"))
			Set Item3=+$g(^TMP($zn,$j,"LogDataProcess",xLocID,xDate,1,"NPICC"))
			Set Item3=+$g(^TMP($zn,$j,"LogDataProcess",xLocID,xDate,1,"NUC"))+Item3
			Set Item4=+$g(^TMP($zn,$j,"LogDataProcess",xLocID,xDate,1,"NVNT"))
			Set Item3A=+$g(^TMP($zn,$j,"LogDataProcess",xLocID,xDate,1,"NPICCInf"))
			Set Item3A=+$g(^TMP($zn,$j,"LogDataProcess",xLocID,xDate,1,"NUCInf"))+Item3A
			Set Item4A=+$g(^TMP($zn,$j,"LogDataProcess",xLocID,xDate,1,"NVNTInf"))
			
			Set Item5=+$g(^TMP($zn,$j,"LogDataProcess",xLocID,xDate,2,"NewInHosp"))
			Set Item6=+$g(^TMP($zn,$j,"LogDataProcess",xLocID,xDate,2,"InHosp"))
			Set Item7=+$g(^TMP($zn,$j,"LogDataProcess",xLocID,xDate,2,"NPICC"))
			Set Item7=+$g(^TMP($zn,$j,"LogDataProcess",xLocID,xDate,2,"NUC"))+Item7
			Set Item8=+$g(^TMP($zn,$j,"LogDataProcess",xLocID,xDate,2,"NVNT"))
			Set Item7A=+$g(^TMP($zn,$j,"LogDataProcess",xLocID,xDate,2,"NPICCInf"))
			Set Item7A=+$g(^TMP($zn,$j,"LogDataProcess",xLocID,xDate,2,"NUCInf"))+Item7A
			Set Item8A=+$g(^TMP($zn,$j,"LogDataProcess",xLocID,xDate,2,"NVNTInf"))
			
			Set Item9=+$g(^TMP($zn,$j,"LogDataProcess",xLocID,xDate,3,"NewInHosp"))
			Set Item10=+$g(^TMP($zn,$j,"LogDataProcess",xLocID,xDate,3,"InHosp"))
			Set Item11=+$g(^TMP($zn,$j,"LogDataProcess",xLocID,xDate,3,"NPICC"))
			Set Item11=+$g(^TMP($zn,$j,"LogDataProcess",xLocID,xDate,3,"NUC"))+Item11
			Set Item12=+$g(^TMP($zn,$j,"LogDataProcess",xLocID,xDate,3,"NVNT"))
			Set Item11A=+$g(^TMP($zn,$j,"LogDataProcess",xLocID,xDate,3,"NPICCInf"))
			Set Item11A=+$g(^TMP($zn,$j,"LogDataProcess",xLocID,xDate,3,"NUCInf"))+Item11A
			Set Item12A=+$g(^TMP($zn,$j,"LogDataProcess",xLocID,xDate,3,"NVNTInf"))
			
			Set Item13=+$g(^TMP($zn,$j,"LogDataProcess",xLocID,xDate,4,"NewInHosp"))
			Set Item14=+$g(^TMP($zn,$j,"LogDataProcess",xLocID,xDate,4,"InHosp"))
			Set Item15=+$g(^TMP($zn,$j,"LogDataProcess",xLocID,xDate,4,"NPICC"))
			Set Item15=+$g(^TMP($zn,$j,"LogDataProcess",xLocID,xDate,4,"NUC"))+Item15
			Set Item16=+$g(^TMP($zn,$j,"LogDataProcess",xLocID,xDate,4,"NVNT"))
			Set Item15A=+$g(^TMP($zn,$j,"LogDataProcess",xLocID,xDate,4,"NPICCInf"))
			Set Item15A=+$g(^TMP($zn,$j,"LogDataProcess",xLocID,xDate,4,"NUCInf"))+Item15A
			Set Item16A=+$g(^TMP($zn,$j,"LogDataProcess",xLocID,xDate,4,"NVNTInf"))
			
			Set InputStr=xLogID_"^"_xLocID_"^"_xDate
			Set InputStr=InputStr_"^"_Item1_"^"_Item2_"^"_Item3_"^"_Item4_"^"_Item5_"^"_Item6_"^"_Item7_"^"_Item8
			Set InputStr=InputStr_"^"_Item9_"^"_Item10_"^"_Item11_"^"_Item12_"^"_Item13_"^"_Item14_"^"_Item15_"^"_Item16
			Set InputStr=InputStr_"^"_UpdateUser
			Set InputStr=InputStr_"^"_Item1A_"^"_Item2A_"^"_Item3A_"^"_Item4A_"^"_Item5A_"^"_Item6A_"^"_Item7A_"^"_Item8A
			Set InputStr=InputStr_"^"_Item9A_"^"_Item10A_"^"_Item11A_"^"_Item12A_"^"_Item13A_"^"_Item14A_"^"_Item15A_"^"_Item16A
		
			Set flg=##Class(DHCMed.NINF.Rep.AimNICUSurvery).Update(InputStr,"^")
			
			//新生儿调查日志就诊字符串
			
			//Set (UpdateUser)=""
			Set (Item1,Item2,Item3,Item4,Item5,Item6,Item7,Item8)=""
			Set (Item9,Item10,Item11,Item12,Item13,Item14,Item15,Item16)=""
			Set (Item1A,Item2A,Item3A,Item4A,Item5A,Item6A,Item7A,Item8A)=""
			Set (Item9A,Item10A,Item11A,Item12A,Item13A,Item14A,Item15A,Item16A)=""
			
			Set xLogID=$o(^DHCMed.NINFi("Aim","NICUSAdm","IndexLocDate",xLocID,xDate,0))
			If (xLogID=""){
				Set objLog=##class(DHCMed.NINF.Rep.AimNICUSurveryAdm).%New()
			}Else{
				Set objLog=##class(DHCMed.NINF.Rep.AimNICUSurveryAdm).GetObjById(xLogID)
			}
			If $IsObject(objLog)
			{
				Set UpdateUser=objLog.UpdateUser
				Set Item1=objLog.ANISItem1
				Set Item2=objLog.ANISItem2
				Set Item3=objLog.ANISItem3
				Set Item4=objLog.ANISItem4
				Set Item5=objLog.ANISItem5
				Set Item6=objLog.ANISItem6
				Set Item7=objLog.ANISItem7
				Set Item8=objLog.ANISItem8
				Set Item9=objLog.ANISItem9
				Set Item10=objLog.ANISItem10
				Set Item11=objLog.ANISItem11
				Set Item12=objLog.ANISItem12
				Set Item13=objLog.ANISItem13
				Set Item14=objLog.ANISItem14
				Set Item15=objLog.ANISItem15
				Set Item16=objLog.ANISItem16
				Set Item1A=objLog.ANISItem1A
				Set Item2A=objLog.ANISItem2A
				Set Item3A=objLog.ANISItem3A
				Set Item4A=objLog.ANISItem4A
				Set Item5A=objLog.ANISItem5A
				Set Item6A=objLog.ANISItem6A
				Set Item7A=objLog.ANISItem7A
				Set Item8A=objLog.ANISItem8A
				Set Item9A=objLog.ANISItem9A
				Set Item10A=objLog.ANISItem10A
				Set Item11A=objLog.ANISItem11A
				Set Item12A=objLog.ANISItem12A
				Set Item13A=objLog.ANISItem13A
				Set Item14A=objLog.ANISItem14A
				Set Item15A=objLog.ANISItem15A
				Set Item16A=objLog.ANISItem16A
			
				Kill ^StrAdm

				Set KeyWord=""
				For BornWeight=1:1:4 {
					For {
						Set KeyWord=$o(^TMP($zn,$j,"LogDataProcess",xLocID,xDate,BornWeight,KeyWord))
						Quit:KeyWord=""
						Set ^StrAdm(BornWeight,KeyWord)=""
						Set xPaadm=""
						For {
							Set xPaadm=$o(^TMP($zn,$j,"LogDataProcess",xLocID,xDate,BornWeight,KeyWord,xPaadm))
							Quit:xPaadm=""
							Set ^StrAdm(BornWeight,KeyWord)=^StrAdm(BornWeight,KeyWord)_","_xPaadm
						
						}
						Set:^StrAdm(BornWeight,KeyWord)'="" ^StrAdm(BornWeight,KeyWord)=$e(^StrAdm(BornWeight,KeyWord),2,$l(^StrAdm(BornWeight,KeyWord)))
					}
				}
			
				Set Item1=$g(^StrAdm(1,"NewInHosp"))
				Set Item2=$g(^StrAdm(1,"InHosp"))
				Set Item3=$g(^StrAdm(1,"NPICC"))
				Set Item3=$g(^StrAdm(1,"NUC"))_","_Item3
				Set Item4=$g(^StrAdm(1,"NVNT"))
				Set Item3A=$g(^StrAdm(1,"NPICCInf"))
				Set Item3A=$g(^StrAdm(1,"NUCInf"))_","_Item3A
				Set Item4A=$g(^StrAdm(1,"NVNTInf"))
			
				Set Item5=$g(^StrAdm(2,"NewInHosp"))
				Set Item6=$g(^StrAdm(2,"InHosp"))
				Set Item7=$g(^StrAdm(2,"NPICC"))
				Set Item7=$g(^StrAdm(2,"NUC"))_","_Item7
				Set Item8=$g(^StrAdm(2,"NVNT"))
				Set Item7A=$g(^StrAdm(2,"NPICCInf"))
				Set Item7A=$g(^StrAdm(2,"NUCInf"))_","_Item7A
				Set Item8A=$g(^StrAdm(2,"NVNTInf"))
			
				Set Item9=$g(^StrAdm(3,"NewInHosp"))
				Set Item10=$g(^StrAdm(3,"InHosp"))
				Set Item11=$g(^StrAdm(3,"NPICC"))
				Set Item11=$g(^StrAdm(3,"NUC"))_","_Item11
				Set Item12=$g(^StrAdm(3,"NVNT"))
				Set Item11A=$g(^StrAdm(3,"NPICCInf"))
				Set Item11A=$g(^StrAdm(3,"NUCInf"))_","_Item11A
				Set Item12A=$g(^StrAdm(3,"NVNTInf"))
			
				Set Item13=$g(^StrAdm(4,"NewInHosp"))
				Set Item14=$g(^StrAdm(4,"InHosp"))
				Set Item15=$g(^StrAdm(4,"NPICC"))
				Set Item15=$g(^StrAdm(4,"NUC"))_","_Item15
				Set Item16=$g(^StrAdm(4,"NVNT"))
				Set Item15A=$g(^StrAdm(4,"NPICCInf"))
				Set Item15A=$g(^StrAdm(4,"NUCInf"))_","_Item15A
				Set Item16A=$g(^StrAdm(4,"NVNTInf"))
		
				
				Set InputStr=xLogID_"^"_xLocID_"^"_xDate
				Set InputStr=InputStr_"^"_Item1_"^"_Item2_"^"_Item3_"^"_Item4_"^"_Item5_"^"_Item6_"^"_Item7_"^"_Item8
				Set InputStr=InputStr_"^"_Item9_"^"_Item10_"^"_Item11_"^"_Item12_"^"_Item13_"^"_Item14_"^"_Item15_"^"_Item16
				Set InputStr=InputStr_"^"_UpdateUser
				Set InputStr=InputStr_"^"_Item1A_"^"_Item2A_"^"_Item3A_"^"_Item4A_"^"_Item5A_"^"_Item6A_"^"_Item7A_"^"_Item8A
				Set InputStr=InputStr_"^"_Item9A_"^"_Item10A_"^"_Item11A_"^"_Item12A_"^"_Item13A_"^"_Item14A_"^"_Item15A_"^"_Item16A
				//w InputStr,!
				Set flg=##Class(DHCMed.NINF.Rep.AimNICUSurveryAdm).Update(InputStr,"^")
			}
		}
	}
	Kill ^TMP($zn,$j,"LogDataProcess")
	
	Quit "OK"
	
LogDataProcessErr
	Quit "Error"
}

/// Creator：     zhufei
/// CreatDate：   2012-05-16
/// Description:  查询新生儿调查日志记录
/// Table：       DHCMed.NINF.Rep.AimNICUSurvery
/// Input:        argYYMM,argLoc
/// do ##class(%ResultSet).RunQuery("DHCMed.NINFService.Rep.AimNICUSurvery","QryANISByMonth","2013-07",22)
Query QryANISByMonth(argYYMM As %String, argLoc As %String) As %Query(ROWSPEC = "LogIndex:%String,ANISID:%String,LocID:%String,LocDesc:%String,SurveryDate:%String,SurveryDay:%String,ANISItem1:%String,ANISItem2:%String,ANISItem3:%String,ANISItem4:%String,ANISItem5:%String,ANISItem6:%String,ANISItem7:%String,ANISItem8:%String,ANISItem9:%String,ANISItem10:%String,ANISItem11:%String,ANISItem12:%String,ANISItem13:%String,ANISItem14:%String,ANISItem15:%String,ANISItem16:%String,ANISItem1A:%String,ANISItem2A:%String,ANISItem3A:%String,ANISItem4A:%String,ANISItem5A:%String,ANISItem6A:%String,ANISItem7A:%String,ANISItem8A:%String,ANISItem9A:%String,ANISItem10A:%String,ANISItem11A:%String,ANISItem12A:%String,ANISItem13A:%String,ANISItem14A:%String,ANISItem15A:%String,ANISItem16A:%String")
{
}

ClassMethod QryANISByMonthExecute(ByRef qHandle As %Binary, argYYMM As %String, argLoc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(argYYMM="")||(argLoc="") $$$OK
	Set xDateFrom=argYYMM_"-01"
	Set xDateFrom=$zdh(xDateFrom,3)
	Set xDateTo=xDateFrom+32
	Set xDateTo=$zd(xDateTo,3)
	Set xDateTo=$p(xDateTo,"-",1)_"-"_$p(xDateTo,"-",2)_"-01"
	Set xDateTo=$zdh(xDateTo,3)-1
	
	Set LocID=argLoc
	Set LocDesc=$p($g(^CTLOC(LocID)),"^",2)
	Quit:LocDesc="" $$$OK
	Set:$p(LocDesc,"-",2)'="" LocDesc=$p(LocDesc,"-",2)
	
	Set NINFNICUSurveryDataType=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("NINFNICUSurveryDataType","")
	If NINFNICUSurveryDataType=1 {
		Set xStDate=$o(^DHCMed.NINFi("Aim","NICUS","IndexLocDate",LocID,""),-1)
		If xStDate="" {
			Set xStDate=$zd((+$h)-1,3)
			Set $p(xStDate,"-",3)="01"
			Set xStDate=$zdh(xStDate,3)
		} Else {
			Set xStDate=xStDate+1
		}
		Set xEdDate=(+$h)-1
		Set flg=..LogDataProcessByOE(xStDate,xEdDate,LocID)
	}
	
	Set LogIndex=0
	For xDate=xDateFrom:1:xDateTo
	{
		Quit:xDate>(+$h)
		Set (Item1,Item2,Item3,Item4,Item5,Item6,Item7,Item8)=""
		Set (Item9,Item10,Item11,Item12,Item13,Item14,Item15,Item16)=""
		Set (Item1A,Item2A,Item3A,Item4A,Item5A,Item6A,Item7A,Item8A)=""
		Set (Item9A,Item10A,Item11A,Item12A,Item13A,Item14A,Item15A,Item16A)=""
		
		Set xLogID=$o(^DHCMed.NINFi("Aim","NICUS","IndexLocDate",LocID,xDate,0))
		Set objLog=##class(DHCMed.NINF.Rep.AimNICUSurvery).GetObjById(xLogID)
		If $IsObject(objLog)
		{
			Set Item1=objLog.ANISItem1
			Set Item2=objLog.ANISItem2
			Set Item3=objLog.ANISItem3
			Set Item4=objLog.ANISItem4
			Set Item5=objLog.ANISItem5
			Set Item6=objLog.ANISItem6
			Set Item7=objLog.ANISItem7
			Set Item8=objLog.ANISItem8
			Set Item9=objLog.ANISItem9
			Set Item10=objLog.ANISItem10
			Set Item11=objLog.ANISItem11
			Set Item12=objLog.ANISItem12
			Set Item13=objLog.ANISItem13
			Set Item14=objLog.ANISItem14
			Set Item15=objLog.ANISItem15
			Set Item16=objLog.ANISItem16
			Set Item1A=objLog.ANISItem1A
			Set Item2A=objLog.ANISItem2A
			Set Item3A=objLog.ANISItem3A
			Set Item4A=objLog.ANISItem4A
			Set Item5A=objLog.ANISItem5A
			Set Item6A=objLog.ANISItem6A
			Set Item7A=objLog.ANISItem7A
			Set Item8A=objLog.ANISItem8A
			Set Item9A=objLog.ANISItem9A
			Set Item10A=objLog.ANISItem10A
			Set Item11A=objLog.ANISItem11A
			Set Item12A=objLog.ANISItem12A
			Set Item13A=objLog.ANISItem13A
			Set Item14A=objLog.ANISItem14A
			Set Item15A=objLog.ANISItem15A
			Set Item16A=objLog.ANISItem16A
		}
		Set SurveryDay=$p($zd(xDate,3),"-",3)
		Set LogIndex=LogIndex+1
		Set Data=$lb(LogIndex,xLogID,LocID,LocDesc,$zd(xDate,3),SurveryDay)
		Set Data=Data_$lb(Item1,Item2,Item3,Item4,Item5,Item6,Item7,Item8)
		Set Data=Data_$lb(Item9,Item10,Item11,Item12,Item13,Item14,Item15,Item16)
		Set Data=Data_$lb(Item1A,Item2A,Item3A,Item4A,Item5A,Item6A,Item7A,Item8A)
		Set Data=Data_$lb(Item9A,Item10A,Item11A,Item12A,Item13A,Item14A,Item15A,Item16A)
		Set ^CacheTemp(repid,ind)=Data
    	Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryANISByMonthClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryANISByMonthExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryANISByMonthFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryANISByMonthExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// w ##class(DHCMed.NINFService.Rep.AimNICUSurvery).ExportANISByMonth("fillxlSheet","2013-05^11")
ClassMethod ExportANISByMonth(itmjs As %String, strArguments As %String) As %String
{
	n (itmjs,strArguments)
	s Count=0

	s argYYMM=$p(strArguments,"^",1)
	s argLoc=$p(strArguments,"^",2)
	
	s ds = ##class(%Library.ResultSet).%New("DHCMed.NINFService.Rep.AimNICUSurvery:QryANISByMonth")
	d ds.Execute(argYYMM,argLoc)
	
	s StartRow=5
	
	s (Item1,Item2,Item3,Item4,Item5,Item6,Item7,Item8)=0
	s (Item9,Item10,Item11,Item12,Item13,Item14,Item15,Item16)=0
	
	s (FirstDayPatNum1,LastDatePatNum1)=0
	s (FirstDayPatNum2,LastDatePatNum2)=0
	s (FirstDayPatNum3,LastDatePatNum3)=0
	s (FirstDayPatNum4,LastDatePatNum4)=0
	
	s ind=1	
	while(ds.Next())
	{
		s Item1=Item1+ds.Data("ANISItem1")
		s:ind=1 Item2=Item2+ds.Data("ANISItem2")
		s Item3=Item3+ds.Data("ANISItem3")
		s Item4=Item4+ds.Data("ANISItem4")
		s Item5=Item5+ds.Data("ANISItem5")
		s:ind=1 Item6=Item6+ds.Data("ANISItem6")
		s Item7=Item7+ds.Data("ANISItem7")
		s Item8=Item8+ds.Data("ANISItem8")
		s Item9=Item9+ds.Data("ANISItem9")
		s:ind=1 Item10=Item10+ds.Data("ANISItem10")
		s Item11=Item11+ds.Data("ANISItem11")
		s Item12=Item12+ds.Data("ANISItem12")
		s Item13=Item13+ds.Data("ANISItem13")
		s:ind=1 Item14=Item14+ds.Data("ANISItem14")
		s Item15=Item15+ds.Data("ANISItem15")
		s Item16=Item16+ds.Data("ANISItem16")
	
		s:ind=1 FirstDayPatNum1=ds.Data("ANISItem2")	//监测月第一天新生儿数
		s:ind=1 FirstDayPatNum2=ds.Data("ANISItem6")
		s:ind=1 FirstDayPatNum3=ds.Data("ANISItem10")
		s:ind=1 FirstDayPatNum4=ds.Data("ANISItem14")
		
		s LastDatePatNum1=ds.Data("ANISItem1")+ds.Data("ANISItem2")	//监测次月第一天新生儿数
		s LastDatePatNum2=ds.Data("ANISItem5")+ds.Data("ANISItem6")
		s LastDatePatNum3=ds.Data("ANISItem9")+ds.Data("ANISItem10")
		s LastDatePatNum4=ds.Data("ANISItem13")+ds.Data("ANISItem14")
		s ind=ind+1	
	}
	s Item2=Item2+Item1	//住在新生儿数=月初第一天人数+新住进人数
	s Item6=Item6+Item5
	s Item10=Item10+Item9
	s Item14=Item14+Item13
	s retval=itmjs_"(xlSheet,'"_$ZCVT(Item1,"O","JS")_"',"_4_",2);"
	&javascript<#(retval)#>
	s retval=itmjs_"(xlSheet,'"_$ZCVT(Item2,"O","JS")_"',"_4_",3);"
	&javascript<#(retval)#>
	s retval=itmjs_"(xlSheet,'"_$ZCVT(Item3,"O","JS")_"',"_4_",4);"
	&javascript<#(retval)#>
	s retval=itmjs_"(xlSheet,'"_$ZCVT(Item4,"O","JS")_"',"_4_",5);"
	&javascript<#(retval)#>
	s retval=itmjs_"(xlSheet,'"_$ZCVT(Item5,"O","JS")_"',"_5_",2);"
	&javascript<#(retval)#>
	s retval=itmjs_"(xlSheet,'"_$ZCVT(Item6,"O","JS")_"',"_5_",3);"
	&javascript<#(retval)#>
	s retval=itmjs_"(xlSheet,'"_$ZCVT(Item7,"O","JS")_"',"_5_",4);"
	&javascript<#(retval)#>
	s retval=itmjs_"(xlSheet,'"_$ZCVT(Item8,"O","JS")_"',"_5_",5);"
	&javascript<#(retval)#>
	s retval=itmjs_"(xlSheet,'"_$ZCVT(Item9,"O","JS")_"',"_6_",2);"
	&javascript<#(retval)#>
	s retval=itmjs_"(xlSheet,'"_$ZCVT(Item10,"O","JS")_"',"_6_",3);"
	&javascript<#(retval)#>
	s retval=itmjs_"(xlSheet,'"_$ZCVT(Item11,"O","JS")_"',"_6_",4);"
	&javascript<#(retval)#>
	s retval=itmjs_"(xlSheet,'"_$ZCVT(Item12,"O","JS")_"',"_6_",5);"
	&javascript<#(retval)#>
	s retval=itmjs_"(xlSheet,'"_$ZCVT(Item13,"O","JS")_"',"_7_",2);"
	&javascript<#(retval)#>
	s retval=itmjs_"(xlSheet,'"_$ZCVT(Item14,"O","JS")_"',"_7_",3);"
	&javascript<#(retval)#>
	s retval=itmjs_"(xlSheet,'"_$ZCVT(Item15,"O","JS")_"',"_7_",4);"
	&javascript<#(retval)#>
	s retval=itmjs_"(xlSheet,'"_$ZCVT(Item16,"O","JS")_"',"_7_",5);"
	&javascript<#(retval)#>
	s retval=itmjs_"(xlSheet,'"_$ZCVT(FirstDayPatNum1,"O","JS")_"',"_4_",6);"
	&javascript<#(retval)#>
	s retval=itmjs_"(xlSheet,'"_$ZCVT(LastDatePatNum1,"O","JS")_"',"_4_",7);"
	&javascript<#(retval)#>
	s retval=itmjs_"(xlSheet,'"_$ZCVT(FirstDayPatNum2,"O","JS")_"',"_5_",6);"
	&javascript<#(retval)#>
	s retval=itmjs_"(xlSheet,'"_$ZCVT(LastDatePatNum2,"O","JS")_"',"_5_",7);"
	&javascript<#(retval)#>
	s retval=itmjs_"(xlSheet,'"_$ZCVT(FirstDayPatNum3,"O","JS")_"',"_6_",6);"
	&javascript<#(retval)#>
	s retval=itmjs_"(xlSheet,'"_$ZCVT(LastDatePatNum3,"O","JS")_"',"_6_",7);"
	&javascript<#(retval)#>
	s retval=itmjs_"(xlSheet,'"_$ZCVT(FirstDayPatNum4,"O","JS")_"',"_7_",6);"
	&javascript<#(retval)#>
	s retval=itmjs_"(xlSheet,'"_$ZCVT(LastDatePatNum4,"O","JS")_"',"_7_",7);"
	&javascript<#(retval)#>
	
	
	s retval=itmjs_"(xlSheet,'"_$ZCVT(argYYMM,"O","JS")_"',"_2_",2);"
	&javascript<#(retval)#>
	
	d ds.Close()
	
	q ind
}

/// 获取Http服务器信息
/// Trakcare的服务器，不是Medtrak的
/// 	w ##Class(DHCMed.EPDService.Service).GetServerInfo()
ClassMethod GetServerInfo()
{
	n
    Set CurrentNS=$ZNSPACE
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    //Set Server=Config.WebServer
    Set Server=$p(Config.LayoutManager,":",2)
    Set Path=Config.PathToReports
    Set LayOutManager=Config.LayoutManager
    Set WebServerAppURL = "http://"_Config.WebServer_Config.PathToApp //Modified By LiYang 2008-10-08 获取CSP服务器的IP地址以及程序路径
   // Set WebServerAppURL = "http://127.0.0.1"_Config.PathToApp //Modified By LiYang 2008-10-08 获取CSP服务器的IP地址以及程序路径
    d Config.%Close()
    s s=CurrentNS_$c(1)_MEDDATA_$c(1)_LABDATA_$c(1)_Server_$c(1)_Path_$c(1)_LayOutManager_$C(1)_WebServerAppURL
	q s
}

/// Creator：     zhufei
/// CreatDate：   2013-03-14
/// Description:  新生儿调查日志统计
/// Table：       DHCMed.NINF.Rep.AimNICUSurvery
/// Input:        aFromDate 开始日期,aToDAte 结束日期
/// do ##class(%ResultSet).RunQuery("DHCMed.NINFService.Rep.AimNICUSurvery","StaNICUSurvery","2013-03-01","2013-03-18")
Query StaNICUSurvery(aFromDate As %String, aToDate As %String) As %Query(ROWSPEC = "LocID:%String,LocDesc:%String,NewInHospSum1:%Integer,InHospSum1:%Integer,PICCSum1:%Integer,VNTSum1:%Integer,NewInHospSum2:%Integer,InHospSum2:%Integer,PICCSum2:%Integer,VNTSum2:%Integer,NewInHospSum3:%Integer,InHospSum3:%Integer,PICCSum3:%Integer,VNTSum3:%Integer,NewInHospSum4:%Integer,InHospSum4:%Integer,PICCSum4:%Integer,VNTSum4:%Integer,TotalInHospSum1:%Integer,TotalInHospSum2:%Integer,TotalInHospSum3:%Integer,TotalInHospSum4:%Integer") [ SqlProc ]
{
}

ClassMethod StaNICUSurveryExecute(ByRef qHandle As %Binary, aFromDate As %String, aToDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set:aFromDate["/" aFromDate=$zdh(aFromDate,4)
	Set:aToDate["/" aToDate=$zdh(aToDate,4)
	Set:aFromDate["-" aFromDate=$zdh(aFromDate,3)
	Set:aToDate["-" aToDate=$zdh(aToDate,3)
	Quit:(aFromDate="")||(aToDate="") $$$OK
	
	Kill ^TMP($zn,$j,"StaNICUSurvery")
	
	Set xLocID=0
	For {
		Set xLocID=$o(^DHCMed.NINFi("Aim","NICUS","IndexLocDate",xLocID))
		Quit:xLocID=""
		
		For xDate=aFromDate:1:aToDate {
			
			Set (Item1,Item2,Item3,Item4,Item5,Item6,Item7,Item8,Item9,Item10)=0
			Set (Item11,Item12,Item13,Item14,Item15,Item16)=0
			Set xLogID=$o(^DHCMed.NINFi("Aim","NICUS","IndexLocDate",xLocID,xDate,0))
			Set objLog=##class(DHCMed.NINF.Rep.AimNICUSurvery).GetObjById(xLogID)
			If $IsObject(objLog) {
				Set Item1=+objLog.ANISItem1
				Set Item2=+objLog.ANISItem2
				Set Item3=+objLog.ANISItem3
				Set Item4=+objLog.ANISItem4
				Set Item5=+objLog.ANISItem5
				Set Item6=+objLog.ANISItem6
				Set Item7=+objLog.ANISItem7
				Set Item8=+objLog.ANISItem8
				Set Item9=+objLog.ANISItem9
				Set Item10=+objLog.ANISItem10
				Set Item11=+objLog.ANISItem11
				Set Item12=+objLog.ANISItem12
				Set Item13=+objLog.ANISItem13
				Set Item14=+objLog.ANISItem14
				Set Item15=+objLog.ANISItem15
				Set Item16=+objLog.ANISItem16
			}
			
			Set num=+$g(^TMP($zn,$j,"StaNICUSurvery",xLocID,"NewInHospSum1"))
			Set ^TMP($zn,$j,"StaNICUSurvery",xLocID,"NewInHospSum1")=num+Item1
			
			Set num=+$g(^TMP($zn,$j,"StaNICUSurvery",xLocID,"InHospSum1"))
			Set ^TMP($zn,$j,"StaNICUSurvery",xLocID,"InHospSum1")=num+Item2
			
			Set num=+$g(^TMP($zn,$j,"StaNICUSurvery",xLocID,"PICCSum1"))
			Set ^TMP($zn,$j,"StaNICUSurvery",xLocID,"PICCSum1")=num+Item3
			
			Set num=+$g(^TMP($zn,$j,"StaNICUSurvery",xLocID,"VNTSum1"))
			Set ^TMP($zn,$j,"StaNICUSurvery",xLocID,"VNTSum1")=num+Item4
			
			
			Set num=+$g(^TMP($zn,$j,"StaNICUSurvery",xLocID,"NewInHospSum2"))
			Set ^TMP($zn,$j,"StaNICUSurvery",xLocID,"NewInHospSum2")=num+Item5
			
			Set num=+$g(^TMP($zn,$j,"StaNICUSurvery",xLocID,"InHospSum2"))
			Set ^TMP($zn,$j,"StaNICUSurvery",xLocID,"InHospSum2")=num+Item6
			
			Set num=+$g(^TMP($zn,$j,"StaNICUSurvery",xLocID,"PICCSum2"))
			Set ^TMP($zn,$j,"StaNICUSurvery",xLocID,"PICCSum2")=num+Item7
			
			Set num=+$g(^TMP($zn,$j,"StaNICUSurvery",xLocID,"VNTSum2"))
			Set ^TMP($zn,$j,"StaNICUSurvery",xLocID,"VNTSum2")=num+Item8
			
			
			Set num=+$g(^TMP($zn,$j,"StaNICUSurvery",xLocID,"NewInHospSum3"))
			Set ^TMP($zn,$j,"StaNICUSurvery",xLocID,"NewInHospSum3")=num+Item9
			
			Set num=+$g(^TMP($zn,$j,"StaNICUSurvery",xLocID,"InHospSum3"))
			Set ^TMP($zn,$j,"StaNICUSurvery",xLocID,"InHospSum3")=num+Item10
			
			Set num=+$g(^TMP($zn,$j,"StaNICUSurvery",xLocID,"PICCSum3"))
			Set ^TMP($zn,$j,"StaNICUSurvery",xLocID,"PICCSum3")=num+Item11
			
			Set num=+$g(^TMP($zn,$j,"StaNICUSurvery",xLocID,"VNTSum3"))
			Set ^TMP($zn,$j,"StaNICUSurvery",xLocID,"VNTSum3")=num+Item12
			
			
			Set num=+$g(^TMP($zn,$j,"StaNICUSurvery",xLocID,"NewInHospSum4"))
			Set ^TMP($zn,$j,"StaNICUSurvery",xLocID,"NewInHospSum4")=num+Item13
			
			Set num=+$g(^TMP($zn,$j,"StaNICUSurvery",xLocID,"InHospSum4"))
			Set ^TMP($zn,$j,"StaNICUSurvery",xLocID,"InHospSum4")=num+Item14
			
			Set num=+$g(^TMP($zn,$j,"StaNICUSurvery",xLocID,"PICCSum4"))
			Set ^TMP($zn,$j,"StaNICUSurvery",xLocID,"PICCSum4")=num+Item15
			
			Set num=+$g(^TMP($zn,$j,"StaNICUSurvery",xLocID,"VNTSum4"))
			Set ^TMP($zn,$j,"StaNICUSurvery",xLocID,"VNTSum4")=num+Item16
		}
	}
	
	Set xLocID=""
	For {
		Set xLocID=$o(^TMP($zn,$j,"StaNICUSurvery",xLocID))
		Quit:xLocID=""
		
		Set LocDesc=$p($g(^CTLOC(xLocID)),"^",2)
		Set:$p(LocDesc,"-",2)'="" LocDesc=$p(LocDesc,"-",2)
		Continue:LocDesc=""
		
		Set NewInHospSum1=+$g(^TMP($zn,$j,"StaNICUSurvery",xLocID,"NewInHospSum1"))
		Set InHospSum1=+$g(^TMP($zn,$j,"StaNICUSurvery",xLocID,"InHospSum1"))
		Set PICCSum1=+$g(^TMP($zn,$j,"StaNICUSurvery",xLocID,"PICCSum1"))
		Set VNTSum1=+$g(^TMP($zn,$j,"StaNICUSurvery",xLocID,"VNTSum1"))
		
		Set NewInHospSum2=+$g(^TMP($zn,$j,"StaNICUSurvery",xLocID,"NewInHospSum2"))
		Set InHospSum2=+$g(^TMP($zn,$j,"StaNICUSurvery",xLocID,"InHospSum2"))
		Set PICCSum2=+$g(^TMP($zn,$j,"StaNICUSurvery",xLocID,"PICCSum2"))
		Set VNTSum2=+$g(^TMP($zn,$j,"StaNICUSurvery",xLocID,"VNTSum2"))
		
		Set NewInHospSum3=+$g(^TMP($zn,$j,"StaNICUSurvery",xLocID,"NewInHospSum3"))
		Set InHospSum3=+$g(^TMP($zn,$j,"StaNICUSurvery",xLocID,"InHospSum3"))
		Set PICCSum3=+$g(^TMP($zn,$j,"StaNICUSurvery",xLocID,"PICCSum3"))
		Set VNTSum3=+$g(^TMP($zn,$j,"StaNICUSurvery",xLocID,"VNTSum3"))
		
		Set NewInHospSum4=+$g(^TMP($zn,$j,"StaNICUSurvery",xLocID,"NewInHospSum4"))
		Set InHospSum4=+$g(^TMP($zn,$j,"StaNICUSurvery",xLocID,"InHospSum4"))
		Set PICCSum4=+$g(^TMP($zn,$j,"StaNICUSurvery",xLocID,"PICCSum4"))
		Set VNTSum4=+$g(^TMP($zn,$j,"StaNICUSurvery",xLocID,"VNTSum4"))
		
		Set TotalInHospSum1=NewInHospSum1+InHospSum1
		Set TotalInHospSum2=NewInHospSum2+InHospSum2
		Set TotalInHospSum3=NewInHospSum3+InHospSum3
		Set TotalInHospSum4=NewInHospSum4+InHospSum4

		Set Data=$lb(xLocID,LocDesc)
		Set Data=Data_$lb(NewInHospSum1,InHospSum1,PICCSum1,VNTSum1)
		Set Data=Data_$lb(NewInHospSum2,InHospSum2,PICCSum2,VNTSum2)
		Set Data=Data_$lb(NewInHospSum3,InHospSum3,PICCSum3,VNTSum3)
		Set Data=Data_$lb(NewInHospSum4,InHospSum4,PICCSum4,VNTSum4)
		Set Data=Data_$lb(TotalInHospSum1,TotalInHospSum2,TotalInHospSum3,TotalInHospSum4)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Kill ^TMP($zn,$j,"StaNICUSurvery")
	
	Quit $$$OK
}

ClassMethod StaNICUSurveryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = StaNICUSurveryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod StaNICUSurveryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = StaNICUSurveryExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     zhufei
/// CreatDate：   2013-03-14
/// Description:  新生儿调查感染统计
/// Table：       DHCMed.NINF.Rep.InfReportICU
/// Input:        aFromDate 开始日期,aToDAte 结束日期
/// do ##class(%ResultSet).RunQuery("DHCMed.NINFService.Rep.AimNICUSurvery","StaNICUInfection","2013-03-01","2013-03-18","1")
Query StaNICUInfection(aFromDate As %String, aToDate As %String, aStatType As %String = "1") As %Query(ROWSPEC = "LocID:%String,LocDesc:%String,InfPatSum1:%Integer,InfAdmSum1:%Integer,InfNPICCSum1:%Integer,InfNVNTSum1:%Integer,InfPatSum2:%Integer,InfAdmSum2:%Integer,InfNPICCSum2:%Integer,InfNVNTSum2:%Integer,InfPatSum3:%Integer,InfAdmSum3:%Integer,InfNPICCSum3:%Integer,InfNVNTSum3:%Integer,InfPatSum4:%Integer,InfAdmSum4:%Integer,InfNPICCSum4:%Integer,InfNVNTSum4:%Integer") [ SqlProc ]
{
}

ClassMethod StaNICUInfectionExecute(ByRef qHandle As %Binary, aFromDate As %String, aToDate As %String, aStatType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set:aFromDate["/" aFromDate=$zdh(aFromDate,4)
	Set:aToDate["/" aToDate=$zdh(aToDate,4)
	Set:aFromDate["-" aFromDate=$zdh(aFromDate,3)
	Set:aToDate["-" aToDate=$zdh(aToDate,3)
	Quit:(aFromDate="")||(aToDate="") $$$OK
	
	Kill ^TMP($zn,$j,"StaNICUInfection")
	
	//从新生儿调查报告获取获取新生儿感染信息
	If aStatType="1" {
		Set IntubateTypeList=$lb("NPICC","NVNT","NUC")
		Set xTypeID=0
		For {
			Set xTypeID=$o(^DHCMed.NINFi("InfRep",0,"ICU","IndexIntubateDate",xTypeID))
			Quit:xTypeID=""
			
			Set objType=##class(DHCMed.SS.Dictionary).GetObjById(xTypeID)
			Continue:'$IsObject(objType)
			Set xTypeCode=objType.Code
			Continue:$listfind(IntubateTypeList,xTypeCode)<1
			
			Set xDate=aFromDate-60
			For {
				Set xDate=$o(^DHCMed.NINFi("InfRep",0,"ICU","IndexIntubateDate",xTypeID,xDate))
				Quit:xDate=""
				Quit:xDate>aToDate
				Set xRepID=0
				For {
					Set xRepID=$o(^DHCMed.NINFi("InfRep",0,"ICU","IndexIntubateDate",xTypeID,xDate,xRepID))
					Quit:xRepID=""
					
					Set objRep=##class(DHCMed.NINF.Rep.InfReport).GetObjById(xRepID)
					Continue:'$IsObject(objRep)
					Continue:'$IsObject(objRep.ReportStatus)
					Set ReportStatus=objRep.ReportStatus.Code
					Continue:(ReportStatus="0")||(ReportStatus="1")  //删除和草稿状态报告不算
					Set EpisodeID=objRep.EpisodeID
					
					Set SummID=$o(^DHCMed.NINF("InfRep",xRepID,"Summ",""),-1)
					Set objSumm=##class(DHCMed.NINF.Rep.InfReportSumm).GetObjById(xRepID_"||"_SummID)
					Continue:'$IsObject(objSumm)
					Set TransLoc=objSumm.TransLoc
					Continue:TransLoc=""
					Set TransID=objSumm.TransID
					Continue:TransID=""
					
					Set BornWeight=objSumm.BornWeight
					Set BornWeight=+BornWeight
					Continue:BornWeight<1
					If BornWeight<=1000 {
						Set BornWeightGp=1
					} ElseIf (BornWeight>1000)&&(BornWeight<=1500) {
						Set BornWeightGp=2
					} ElseIf (BornWeight>1500)&&(BornWeight<=2500) {
						Set BornWeightGp=3
					} Else {  //BornWeight>2500
						Set BornWeightGp=4
					}
					
					Set xSubID=0
					For {
						Set xSubID=$o(^DHCMed.NINFi("InfRep",0,"ICU","IndexIntubateDate",xTypeID,xDate,xRepID,xSubID))
						Quit:xSubID=""
						
						Set objSub=##class(DHCMed.NINF.Rep.InfReportICU).GetObjById(xRepID_"||"_xSubID)
						Continue:'$IsObject(objSub)
						
						Set InfDate=objSub.InfDate
						Continue:((InfDate<aFromDate)||(InfDate>aToDate))
						
						//感染人次
						If '$d(^TMP($zn,$j,"StaNICUInfection",TransLoc,BornWeightGp,"InfAdmList",EpisodeID)) {
							Set num=+$g(^TMP($zn,$j,"StaNICUInfection",TransLoc,BornWeightGp,"InfPatSum"))
							Set ^TMP($zn,$j,"StaNICUInfection",TransLoc,BornWeightGp,"InfPatSum")=num+1
							Set ^TMP($zn,$j,"StaNICUInfection",TransLoc,BornWeightGp,"InfAdmList",EpisodeID)=""
						}
						//感染例次
						Set num=+$g(^TMP($zn,$j,"StaNICUInfection",TransLoc,BornWeightGp,"InfAdmSum"))
						Set ^TMP($zn,$j,"StaNICUInfection",TransLoc,BornWeightGp,"InfAdmSum")=num+1
						//各类插管感染例次
						Set num=+$g(^TMP($zn,$j,"StaNICUInfection",TransLoc,BornWeightGp,"Inf"_xTypeCode_"Sum"))
						Set ^TMP($zn,$j,"StaNICUInfection",TransLoc,BornWeightGp,"Inf"_xTypeCode_"Sum")=num+1
					}
				}
			}
		}
	}
	
	//从医院感染报告获取新生儿感染信息
	If aStatType="2" {
		//后期补充
	}
	
	//从ICU患者日志获取新生儿感染信息
	If aStatType="3" {
		//后期补充，聊城目前是这样处理的
	}
	
	Set xLocID=""
	For {
		Set xLocID=$o(^TMP($zn,$j,"StaNICUInfection",xLocID))
		Quit:xLocID=""
		
		Set LocDesc=$p($g(^CTLOC(xLocID)),"^",2)
		Set:$p(LocDesc,"-",2)'="" LocDesc=$p(LocDesc,"-",2)
		Continue:LocDesc=""
		
		Set InfPatSum1=+$g(^TMP($zn,$j,"StaNICUInfection",xLocID,1,"InfPatSum"))
		Set InfAdmSum1=+$g(^TMP($zn,$j,"StaNICUInfection",xLocID,1,"InfAdmSum"))
		Set InfNPICCSum1=+$g(^TMP($zn,$j,"StaNICUInfection",xLocID,1,"InfNPICCSum"))
		Set InfNPICCSum1=+$g(^TMP($zn,$j,"StaNICUInfection",xLocID,1,"InfNUCSum"))+InfNPICCSum1
		Set InfNVNTSum1=+$g(^TMP($zn,$j,"StaNICUInfection",xLocID,1,"InfNVNTSum"))
		
		Set InfPatSum2=+$g(^TMP($zn,$j,"StaNICUInfection",xLocID,2,"InfPatSum"))
		Set InfAdmSum2=+$g(^TMP($zn,$j,"StaNICUInfection",xLocID,2,"InfAdmSum"))
		Set InfNPICCSum2=+$g(^TMP($zn,$j,"StaNICUInfection",xLocID,2,"InfNPICCSum"))
		Set InfNPICCSum2=+$g(^TMP($zn,$j,"StaNICUInfection",xLocID,2,"InfNUCSum"))+InfNPICCSum2
		Set InfNVNTSum2=+$g(^TMP($zn,$j,"StaNICUInfection",xLocID,2,"InfNVNTSum"))
		
		Set InfPatSum3=+$g(^TMP($zn,$j,"StaNICUInfection",xLocID,3,"InfPatSum"))
		Set InfAdmSum3=+$g(^TMP($zn,$j,"StaNICUInfection",xLocID,3,"InfAdmSum"))
		Set InfNPICCSum3=+$g(^TMP($zn,$j,"StaNICUInfection",xLocID,3,"InfNPICCSum"))
		Set InfNPICCSum3=+$g(^TMP($zn,$j,"StaNICUInfection",xLocID,3,"InfNUCSum"))+InfNPICCSum3
		Set InfNVNTSum3=+$g(^TMP($zn,$j,"StaNICUInfection",xLocID,3,"InfNVNTSum"))
		
		Set InfPatSum4=+$g(^TMP($zn,$j,"StaNICUInfection",xLocID,4,"InfPatSum"))
		Set InfAdmSum4=+$g(^TMP($zn,$j,"StaNICUInfection",xLocID,4,"InfAdmSum"))
		Set InfNPICCSum4=+$g(^TMP($zn,$j,"StaNICUInfection",xLocID,4,"InfNPICCSum"))
		Set InfNPICCSum4=+$g(^TMP($zn,$j,"StaNICUInfection",xLocID,4,"InfNUCSum"))+InfNPICCSum4
		Set InfNVNTSum4=+$g(^TMP($zn,$j,"StaNICUInfection",xLocID,4,"InfNVNTSum"))
		
		Set Data=$lb(xLocID,LocDesc)
		Set Data=Data_$lb(InfPatSum1,InfAdmSum1,InfNPICCSum1,InfNVNTSum1)
		Set Data=Data_$lb(InfPatSum2,InfAdmSum2,InfNPICCSum2,InfNVNTSum2)
		Set Data=Data_$lb(InfPatSum3,InfAdmSum3,InfNPICCSum3,InfNVNTSum3)
		Set Data=Data_$lb(InfPatSum4,InfAdmSum4,InfNPICCSum4,InfNVNTSum4)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Kill ^TMP($zn,$j,"StaNICUInfection")
	
	Quit $$$OK
}

ClassMethod StaNICUInfectionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = StaNICUInfectionExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod StaNICUInfectionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = StaNICUInfectionExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
