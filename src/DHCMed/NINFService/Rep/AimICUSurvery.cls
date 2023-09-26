/// 名称: DHCMed.NINFService.Rep.AimICUSurvery
/// 描述: ICU日常监测记录
/// 编写者：zhufei
/// 编写日期: 2012-05-10
Class DHCMed.NINFService.Rep.AimICUSurvery Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// 生成ICU调查日志数据任务
/// w ##Class(DHCMed.NINFService.Rep.AimICUSurvery).LogDataProcess("2013-11","20")
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
	
	Set LogDataProcType=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("NINFICUSurveryDataType","")
	If LogDataProcType="ByOE" {
		Set flg=..LogDataProcessByOE(xDateFrom,xDateTo,LocID)
		Set:flg'="OK" return="生成数据错误："_flg
	} ElseIf LogDataProcType="ByRep" {
		Set flg=..LogDataProcessByRep(xDateFrom,xDateTo,LocID)
		Set:flg'="OK" return="生成数据错误："_flg
	} Else {
		Set return="初始化数据方式未设置,无法初始化数据!"
	}
	
	Set:return="" return="OK"
	Quit return
}

/// 生成ICU调查日志任务
/// aLocID=""，生成所有科室ICU患者日志
/// w ##Class(DHCMed.NINFService.Rep.AimICUSurvery).LogDataProcessByOE($zdh("2014-03-01",3),$zdh("2014-03-01",3),289)
ClassMethod LogDataProcessByOE(aFromDate As %String, aToDate As %String, aLocID As %String = "", aCheckcLog = "0") As %String
{
	New (aFromDate,aToDate,aLocID,aCheckcLog)
	Set return=""
	Quit:(aFromDate="")||(aToDate="")||(aLocID="") return
	Quit:(aToDate<aFromDate) return
	Quit:(aToDate-aFromDate)>60 return
	
	Set $ZT="LogDataProcessByOEErr"
	
	Set:(aToDate>=(+$h)) aToDate=(+$h)-1
	
	Set NIndex="LogDataProcessByOE"
	Kill ^TMP($zn,$j,NIndex)
	
	//计算新入科人数
	Do xGetNewInHospPatient
	
	//计算科室在院人数
	Do xGetInHospPatient
	
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
				Continue:$d(^TMP($zn,$j,NIndex,"PaadmList",xPaadm))
				Set ^TMP($zn,$j,NIndex,"PaadmList",xPaadm)=""
				
				Set listPICC=##class(DHCMed.NINF.Srv.ICUIntubate).GetICUResults(xPaadm,"PICC")
				Set listUC=##class(DHCMed.NINF.Srv.ICUIntubate).GetICUResults(xPaadm,"UC")
				Set listVAP=##class(DHCMed.NINF.Srv.ICUIntubate).GetICUResults(xPaadm,"VAP")
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
						
						//Set DischDate=$p($g(^PAADM(xPaadm)),"^",17)
        				//Update by pylian 2016-01-21 修改出院时间取值方式
						Set DischDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateTime(xPaadm)
						Set DischDate=$p(DischDateTime,"^",1)
	
						For indDate=IntubateDate:1:ExtubateDate {
							If DischDate'="" {
								Continue:indDate>DischDate
							}
							Continue:$d(^TMP($zn,$j,NIndex,"Data",TransLocID,indDate,"PICC",xPaadm))
							Set ^TMP($zn,$j,NIndex,"Data",TransLocID,indDate,"PICC",xPaadm)=""
							Set num=$i(^TMP($zn,$j,NIndex,"Data",TransLocID,indDate,"PICC"))
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
						
						//Set DischDate=$p($g(^PAADM(xPaadm)),"^",17)
        				//Update by pylian 2016-01-21 修改出院时间取值方式
						Set DischDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateTime(xPaadm)
						Set DischDate=$p(DischDateTime,"^",1)
	
						For indDate=IntubateDate:1:ExtubateDate {
							If DischDate'="" {
								Continue:indDate>DischDate
							}
							Continue:$d(^TMP($zn,$j,NIndex,"Data",TransLocID,indDate,"UC",xPaadm))
							Set ^TMP($zn,$j,NIndex,"Data",TransLocID,indDate,"UC",xPaadm)=""
							Set num=$i(^TMP($zn,$j,NIndex,"Data",TransLocID,indDate,"UC"))
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
						
						//Set DischDate=$p($g(^PAADM(xPaadm)),"^",17)
        				//Update by pylian 2016-01-21 修改出院时间取值方式
						Set DischDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateTime(xPaadm)
						Set DischDate=$p(DischDateTime,"^",1)
	
						For indDate=IntubateDate:1:ExtubateDate {
							If DischDate'="" {
								Continue:indDate>DischDate
							}
							Continue:$d(^TMP($zn,$j,NIndex,"Data",TransLocID,indDate,"VAP",xPaadm))
							Set ^TMP($zn,$j,NIndex,"Data",TransLocID,indDate,"VAP",xPaadm)=""
							Set num=$i(^TMP($zn,$j,NIndex,"Data",TransLocID,indDate,"VAP"))
						}
					}
					
					//手术台数（手麻系统取值）
					Set arrRec=##Class(DHCMed.DPCustom.Data.Operation).GetDataByAdm(xPaadm,"","")
					Set Num=arrRec.Count()
					For indRec=1:1:Num {
						Set objRec=arrRec.GetAt(indRec)
						Continue:'$IsObject(objRec)
						Set OperDate=objRec.SttDate
						Continue:OperDate=""
						Set OperLocID=objRec.DeptCode
						Continue:OperLocID=""
						Set ^TMP($zn,$j,NIndex,"Data",OperLocID,OperDate,"OPER",xPaadm)=""
						Set num=$i(^TMP($zn,$j,NIndex,"Data",OperLocID,OperDate,"OPER"))
					}
				}
			}
		}
	}
	
	
	
	//感染患者（目标性监测报告取值）
	Do xGetLocInfPatient
	
	Set xLocID=0
	For {
		Set xLocID=$o(^TMP($zn,$j,NIndex,"Data",xLocID))
		Quit:xLocID=""
		Set xDate=aFromDate-1
		For {
			Set xDate=$o(^TMP($zn,$j,NIndex,"Data",xLocID,xDate))
			Quit:xDate=""
			Quit:xDate>aToDate
			
			Set (AISItem1,AISItem2,AISItem3,AISItem4,AISItem5,AISItem6,AISItem7,AISItem8,AISItem9,AISItem10)=""
			Set (AISItem11,AISItem12,AISItem13,AISItem14,AISItem15,AISItem16,AISItem17,AISItem18,AISItem19,AISItem20)=""
			
			Set xLogID=$o(^DHCMed.NINFi("Aim","ICUS","IndexLocDate",xLocID,xDate,0))
			Set objLog=##class(DHCMed.NINF.Rep.AimICUSurvery).GetObjById(xLogID)
			If $IsObject(objLog)
			{
				Set AISItem1=objLog.AISItem1
				Set AISItem2=objLog.AISItem2
				Set AISItem3=objLog.AISItem3
				Set AISItem4=objLog.AISItem4
				Set AISItem5=objLog.AISItem5
				Set AISItem6=objLog.AISItem6
				Set AISItem7=objLog.AISItem7
				Set AISItem8=objLog.AISItem8
				Set AISItem9=objLog.AISItem9
				Set AISItem10=objLog.AISItem10
				Set AISItem11=objLog.AISItem11
				Set AISItem12=objLog.AISItem12
				Set AISItem13=objLog.AISItem13
				Set AISItem14=objLog.AISItem14
				Set AISItem15=objLog.AISItem15
				Set AISItem16=objLog.AISItem16
				Set AISItem17=objLog.AISItem17
				Set AISItem18=objLog.AISItem18
				Set AISItem19=objLog.AISItem19
				Set AISItem20=objLog.AISItem20
			}
			
			Set AISItem1=+$g(^TMP($zn,$j,NIndex,"Data",xLocID,xDate,"NewInHosp"))
			Set AISItem2=+$g(^TMP($zn,$j,NIndex,"Data",xLocID,xDate,"InHosp"))
			Set AISItem3=+$g(^TMP($zn,$j,NIndex,"Data",xLocID,xDate,"UC"))
			Set AISItem4=+$g(^TMP($zn,$j,NIndex,"Data",xLocID,xDate,"PICC"))
			Set AISItem5=+$g(^TMP($zn,$j,NIndex,"Data",xLocID,xDate,"VAP"))
			Set AISItem6=+$g(^TMP($zn,$j,NIndex,"Data",xLocID,xDate,"OPER"))
			Set AISItem12=+$g(^TMP($zn,$j,NIndex,"Data",xLocID,xDate,"PatInf"))
			Set AISItem13=+$g(^TMP($zn,$j,NIndex,"Data",xLocID,xDate,"UCInf"))
			Set AISItem14=+$g(^TMP($zn,$j,NIndex,"Data",xLocID,xDate,"PICCInf"))
			Set AISItem15=+$g(^TMP($zn,$j,NIndex,"Data",xLocID,xDate,"VAPInf"))
			
			Set InputStr=xLogID_"^"_xLocID_"^"_xDate
			Set InputStr=InputStr_"^"_AISItem1_"^"_AISItem2_"^"_AISItem3_"^"_AISItem4_"^"_AISItem5
			Set InputStr=InputStr_"^"_AISItem6_"^"_AISItem7_"^"_AISItem8_"^"_AISItem9_"^"_AISItem10
			Set InputStr=InputStr_"^"_""
			Set InputStr=InputStr_"^"_AISItem11_"^"_AISItem12_"^"_AISItem13_"^"_AISItem14_"^"_AISItem15
			Set InputStr=InputStr_"^"_AISItem16_"^"_AISItem17_"^"_AISItem18_"^"_AISItem19_"^"_AISItem20
			Set flg=##Class(DHCMed.NINF.Rep.AimICUSurvery).Update(InputStr,"^")
			
			//ICU调查日志就诊字符串
			Set (AISItem1,AISItem2,AISItem3,AISItem4,AISItem5,AISItem6,AISItem7,AISItem8,AISItem9,AISItem10)=""
			Set (AISItem11,AISItem12,AISItem13,AISItem14,AISItem15,AISItem16,AISItem17,AISItem18,AISItem19,AISItem20)=""
			
			Set xLogID=$o(^DHCMed.NINFi("Aim","ICUSAdm","IndexLocDate",xLocID,xDate,0))
			If (xLogID=""){
				Set objLog=##class(DHCMed.NINF.Rep.AimICUSurveryAdm).%New()
			}Else{
				Set objLog=##class(DHCMed.NINF.Rep.AimICUSurveryAdm).GetObjById(xLogID)
			}
			
			If $IsObject(objLog)
			{
				Set AISItem1=objLog.AISItem1
				Set AISItem2=objLog.AISItem2
				Set AISItem3=objLog.AISItem3
				Set AISItem4=objLog.AISItem4
				Set AISItem5=objLog.AISItem5
				Set AISItem6=objLog.AISItem6
				Set AISItem7=objLog.AISItem7
				Set AISItem8=objLog.AISItem8
				Set AISItem9=objLog.AISItem9
				Set AISItem10=objLog.AISItem10
				Set AISItem11=objLog.AISItem11
				Set AISItem12=objLog.AISItem12
				Set AISItem13=objLog.AISItem13
				Set AISItem14=objLog.AISItem14
				Set AISItem15=objLog.AISItem15
				Set AISItem16=objLog.AISItem16
				Set AISItem17=objLog.AISItem17
				Set AISItem18=objLog.AISItem18
				Set AISItem19=objLog.AISItem19
				Set AISItem20=objLog.AISItem20
				
				Kill arrICUSurvAdm
				
				Set KeyWord=""
				For {
					Set KeyWord=$o(^TMP($zn,$j,NIndex,"Data",xLocID,xDate,KeyWord))
					Quit:KeyWord=""
					
					Set arrICUSurvAdm(KeyWord)=""
					Set xPaadm=""
					For {
						Set xPaadm=$o(^TMP($zn,$j,NIndex,"Data",xLocID,xDate,KeyWord,xPaadm))
						Quit:xPaadm=""
						Set arrICUSurvAdm(KeyWord)=arrICUSurvAdm(KeyWord)_","_xPaadm
					}
					Set:arrICUSurvAdm(KeyWord)'="" arrICUSurvAdm(KeyWord)=$e(arrICUSurvAdm(KeyWord),2,$l(arrICUSurvAdm(KeyWord)))
				}
				
				Set AISItem1=$g(arrICUSurvAdm("NewInHosp"))
				Set AISItem2=$g(arrICUSurvAdm("InHosp"))
				Set AISItem3=$g(arrICUSurvAdm("UC"))
				Set AISItem4=$g(arrICUSurvAdm("PICC"))
				Set AISItem5=$g(arrICUSurvAdm("VAP"))
				Set AISItem6=$g(arrICUSurvAdm("OPER"))
				Set AISItem12=$g(arrICUSurvAdm("PatInf"))
				Set AISItem13=$g(arrICUSurvAdm("UCInf"))
				Set AISItem14=$g(arrICUSurvAdm("PICCInf"))
				Set AISItem15=$g(arrICUSurvAdm("VAPInf"))
				
				Set InputStr=xLogID_"^"_xLocID_"^"_xDate
				Set InputStr=InputStr_"^"_AISItem1_"^"_AISItem2_"^"_AISItem3_"^"_AISItem4_"^"_AISItem5
				Set InputStr=InputStr_"^"_AISItem6_"^"_AISItem7_"^"_AISItem8_"^"_AISItem9_"^"_AISItem10
				Set InputStr=InputStr_"^"_""
				Set InputStr=InputStr_"^"_AISItem11_"^"_AISItem12_"^"_AISItem13_"^"_AISItem14_"^"_AISItem15
				Set InputStr=InputStr_"^"_AISItem16_"^"_AISItem17_"^"_AISItem18_"^"_AISItem19_"^"_AISItem20
				Set flg=##Class(DHCMed.NINF.Rep.AimICUSurveryAdm).Update(InputStr,"^")
				
				Kill arrICUSurvAdm
			}
		}
	}
	Kill ^TMP($zn,$j,NIndex)
	
	Quit "OK"
	
xGetPatientByOE(DataNote)
	Set PatientID=$p($g(^PAADM(+xPaadm)),"^",1)
	Set PatName=$p($g(^PAPER(+PatientID,"ALL")),"^",1)
	Set RegNo=$p(^PAPER(+PatientID,"PAT",1),"^",1)
	Set ARCItemID=$p($g(^OEORD(+OEItemID,"I",+$p(OEItemID,"||",2),1)),"^",2)
	Set ARCItemName=$p($g(^ARCIM(+ARCItemID,1,1)),"^",2)
	Set TransLocDesc=$p($g(^CTLOC(+TransLocID)),"^",2)
	Set:$p(TransLocDesc,"-",2)'="" TransLocDesc=$p(TransLocDesc,"-",2)
	Set ^DHCMed.NINFTMP("三管明细",TransLocDesc,$zd(+indDate,3),DataNote,xPaadm,OEItemID)="病人："_RegNo_" "_PatName_"、医嘱："_OEItemID_" "_ARCItemName_"、插拔管时间："_$zd(+IntubateDate,3)_" "_$zt(+IntubateTime,2)_","_$zd(+ExtubateDate,3)_" "_$zt(+ExtubateTime,2)
	Quit
	
xGetNewInHospPatient
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
					
					Continue:$d(^TMP($zn,$j,NIndex,"Data",xLocID,xDate,"NewInHosp",xPaadm))
					Set ^TMP($zn,$j,NIndex,"Data",xLocID,xDate,"NewInHosp",xPaadm)=""
					Set num=$i(^TMP($zn,$j,NIndex,"Data",xLocID,xDate,"NewInHosp"))
				}
			}
		}
	}
	Quit
	
xGetInHospPatient
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
					Continue:$d(^TMP($zn,$j,NIndex,"AdmTrans",tmpAimTransID))
					Set ^TMP($zn,$j,NIndex,"AdmTrans",tmpAimTransID)=""
					Set TransInDate=objAimTrans.TransInDate
					Set TransOutDate=objAimTrans.TransOutDate
					Continue:TransInDate>aToDate
					Continue:TransOutDate<aFromDate
					
					//在院患者，出院、死亡算当天在院，当天入院不算
					//Set EstimDischDate=$p($g(^PAADM(xPaadm)),"^",59)
					//Set DischDate=$p($g(^PAADM(xPaadm)),"^",17)
        			//Update by pylian 2016-01-21 修改出院时间取值方式
					Set DischDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateTime(xPaadm)
					Set DischDate=$p(DischDateTime,"^",1)
	
					For indDate=(TransInDate+1):1:TransOutDate {
						Continue:indDate<aFromDate
						Quit:indDate>aToDate
						If DischDate'="" {
							Continue:indDate>DischDate
						}
						
						Continue:$d(^TMP($zn,$j,NIndex,"Data",xLocID,indDate,"InHosp",xPaadm))
						Set ^TMP($zn,$j,NIndex,"Data",xLocID,indDate,"InHosp",xPaadm)=""
						Set num=$i(^TMP($zn,$j,NIndex,"Data",xLocID,indDate,"InHosp"))
					}
				}
			}
		}
	}
	Quit
	
xGetLocInfPatient
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
						Continue:'$d(^TMP($zn,$j,NIndex,"Data",xLocID,InfDate,"InHosp",xPaadm))
						
						Set InfDiagDesc=objInfPos.InfDiag.IDDesc
						Set InfDiagICD10=objInfPos.InfDiag.IDICD10
						//血管导管相关血流感染
						If InfDiagICD10["T82.703" {  //导管相关性感染
							If '$d(^TMP($zn,$j,NIndex,"Data",xLocID,InfDate,"PICCInf",xPaadm))
							{
								Set ^TMP($zn,$j,NIndex,"Data",xLocID,InfDate,"PICCInf",xPaadm)=""
								Set num=$i(^TMP($zn,$j,NIndex,"Data",xLocID,InfDate,"PICCInf"))
							}
							If '$d(^TMP($zn,$j,NIndex,"Data",xLocID,InfDate,"PatInf",xPaadm))
							{
								Set num=$i(^TMP($zn,$j,NIndex,"Data",xLocID,InfDate,"PatInf"))
								Set ^TMP($zn,$j,NIndex,"Data",xLocID,InfDate,"PatInf",xPaadm)=""
							}
						}
						//呼吸机相关肺炎感染
						If InfDiagICD10["J18.901" {  //肺炎
							If '$d(^TMP($zn,$j,NIndex,"Data",xLocID,InfDate,"VAPInf",xPaadm))
							{
								Set ^TMP($zn,$j,NIndex,"Data",xLocID,InfDate,"VAPInf",xPaadm)=""
								Set num=$i(^TMP($zn,$j,NIndex,"Data",xLocID,InfDate,"VAPInf"))
							}
							If '$d(^TMP($zn,$j,NIndex,"Data",xLocID,InfDate,"PatInf",xPaadm))
							{
								Set num=$i(^TMP($zn,$j,NIndex,"Data",xLocID,InfDate,"PatInf"))
								Set ^TMP($zn,$j,NIndex,"Data",xLocID,InfDate,"PatInf",xPaadm)=""
							}
						}
						//泌尿道插管相关泌尿道感染
						If InfDiagICD10["N39.001" {  //泌尿道感染
							If '$d(^TMP($zn,$j,NIndex,"Data",xLocID,InfDate,"UCInf",xPaadm))
							{
								Set ^TMP($zn,$j,NIndex,"Data",xLocID,InfDate,"UCInf",xPaadm)=""
								Set num=$i(^TMP($zn,$j,NIndex,"Data",xLocID,InfDate,"UCInf"))
							}
							If '$d(^TMP($zn,$j,NIndex,"Data",xLocID,InfDate,"PatInf",xPaadm))
							{
								Set num=$i(^TMP($zn,$j,NIndex,"Data",xLocID,InfDate,"PatInf"))
								Set ^TMP($zn,$j,NIndex,"Data",xLocID,InfDate,"PatInf",xPaadm)=""
							}
						}
					}
				}
			}
		}
	}
	Quit
	
LogDataProcessByOEErr
	Write $ZError,!
	Quit "Error"
}

/// 生成ICU调查日志任务
/// aLocID=""，生成所有科室ICU患者日志
/// w ##Class(DHCMed.NINFService.Rep.AimICUSurvery).LogDataProcessByRep($zdh("2013-03-14",3),$zdh("2013-03-14",3),"",1)
ClassMethod LogDataProcessByRep(aFromDate As %String, aToDate As %String, aLocID As %String = "") As %String
{
	New (aFromDate,aToDate,aLocID)
	Set return=""
	Quit:(aFromDate="")||(aToDate="")||(aLocID="") return
	Quit:(aToDate<aFromDate) return
	Quit:(aToDate-aFromDate)>60 return
	
	Set $ZT="LogDataProcessByRepErr"
	
	Set:(aToDate>=(+$h)) aToDate=(+$h)-1
	Set NIndex="LogDataProcessByRep"
	Kill ^TMP($zn,$j,NIndex)
	
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
					
					Continue:$d(^TMP($zn,$j,NIndex,"Data",xLocID,xDate,"NewInHosp",xPaadm))
					Set ^TMP($zn,$j,NIndex,"Data",xLocID,xDate,"NewInHosp",xPaadm)=""
					Set num=$i(^TMP($zn,$j,NIndex,"Data",xLocID,xDate,"NewInHosp"))
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
					Continue:$d(^TMP($zn,$j,NIndex,"AdmTrans",tmpAimTransID))
					Set ^TMP($zn,$j,NIndex,"AdmTrans",tmpAimTransID)=""
					Set TransInDate=objAimTrans.TransInDate
					Set TransOutDate=objAimTrans.TransOutDate
					Continue:TransInDate>aToDate
					Continue:TransOutDate<aFromDate
					
					//在院患者，出院、死亡算当天在院，当天入院不算
					For indDate=(TransInDate+1):1:TransOutDate {
						Continue:indDate<aFromDate
						Quit:indDate>aToDate
						
						Continue:$d(^TMP($zn,$j,NIndex,"Data",xLocID,indDate,"InHosp",xPaadm))
						Set ^TMP($zn,$j,NIndex,"Data",xLocID,indDate,"InHosp",xPaadm)=""
						Set num=$i(^TMP($zn,$j,NIndex,"Data",xLocID,indDate,"InHosp"))
					}
				}
			}
		}
	}
	
	//系统直接从ICU调查报告提取插管人数和感染人数
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
				Continue:$d(^TMP($zn,$j,NIndex,"PaadmList",xPaadm))
				Set ^TMP($zn,$j,NIndex,"PaadmList",xPaadm)=""
				
				Set xRepID=0
				For {
					Set xRepID=$o(^DHCMed.NINFi("InfRep",0,"IndexPaadm",xPaadm,xRepID))
					Quit:xRepID=""
					
					//过滤无插管报告
					Continue:'$d(^DHCMed.NINF("InfRep",xRepID,"ICU"))
					
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
					Continue:(aLocID'="")&&(TransLoc'=aLocID)
					Set TransID=objSumm.TransID
					Continue:TransID=""
					//Set TransOutDate=##Class(DHCMed.NINFService.Srv.CommonCls).getWardTransOutDate(TransID)
					Set tmpTrans=##class(DHCMed.NINFService.Srv.CommonCls).GetTransLocByID(TransID)
					Set TransInDateTime=$p(tmpTrans,"^",4)
					Set TransOutDateTime=$p(tmpTrans,"^",5)
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
					
					Set xSubID=0
					For {
						Set xSubID=$o(^DHCMed.NINF("InfRep",xRepID,"ICU",xSubID))
						Quit:xSubID=""
						
						Set objSub=##class(DHCMed.NINF.Rep.InfReportICU).GetObjById(xRepID_"||"_xSubID)
						Continue:'$IsObject(objSub)
						Continue:'$IsObject(objSub.IntubateType)
						Set xTypeCode=objSub.IntubateType.Code
						Continue:$listfind(IntubateTypeList,xTypeCode)<1
						
						Set IntubateDate=objPICC.IntubateDate
						Set IntubateTime=objPICC.IntubateTime
						Set ExtubateDate=objPICC.ExtubateDate
						Set ExtubateTime=objPICC.ExtubateTime
						
						//筛选符合条件插管信息
						Continue:IntubateDate>TransOutDate
						Continue:(IntubateDate=TransOutDate)&&(IntubateTime>TransOutTime)
						If ExtubateDate'="" {
							Continue:ExtubateDate<TransInDate
							Continue:(ExtubateDate=TransInDate)&&(ExtubateTime<TransInTime)
						} Else {
							Set ExtubateDate=TransOutDate
							Set ExtubateTime=TransOutTime
						}
						Continue:IntubateDate>ExtubateDate
						Set:IntubateDate<aFromDate IntubateDate=aFromDate
						Set:ExtubateDate>aToDate ExtubateDate=aToDate
						
						For indDate=IntubateDate:1:ExtubateDate {
							Continue:$d(^TMP($zn,$j,NIndex,"Data",TransLoc,indDate,xTypeCode,xPaadm))
							Set ^TMP($zn,$j,NIndex,"Data",TransLoc,indDate,xTypeCode,xPaadm)=""
							Set num=$i(^TMP($zn,$j,NIndex,"Data",TransLoc,indDate,xTypeCode))
						}
						Set InfDate=objSub.InfDate
						If InfDate'="" {
							If '$d(^TMP($zn,$j,NIndex,"Data",TransLoc,InfDate,xTypeCode_"Inf",xPaadm))
							{
								Set ^TMP($zn,$j,NIndex,"Data",TransLoc,InfDate,xTypeCode_"Inf",xPaadm)=""
								Set num=$i(^TMP($zn,$j,NIndex,"Data",TransLoc,InfDate,xTypeCode_"Inf"))
							}
							If '$d(^TMP($zn,$j,NIndex,"Data",TransLoc,InfDate,"PatInf",xPaadm))
							{
								Set ^TMP($zn,$j,NIndex,"Data",TransLoc,InfDate,"PatInf",xPaadm)=""
								Set num=$i(^TMP($zn,$j,NIndex,"Data",TransLoc,InfDate,"PatInf"))
							}
						}
					}
				}
			}
		}
	}
	
	Set xLocID=0
	For {
		Set xLocID=$o(^TMP($zn,$j,NIndex,"Data",xLocID))
		Quit:xLocID=""
		Set xDate=aFromDate-1
		For {
			Set xDate=$o(^TMP($zn,$j,NIndex,"Data",xLocID,xDate))
			Quit:xDate=""
			Quit:xDate>aToDate
			
			Set (AISItem1,AISItem2,AISItem3,AISItem4,AISItem5,AISItem6,AISItem7,AISItem8,AISItem9,AISItem10)=""
			Set (AISItem11,AISItem12,AISItem13,AISItem14,AISItem15,AISItem16,AISItem17,AISItem18,AISItem19,AISItem20)=""
			
			Set xLogID=$o(^DHCMed.NINFi("Aim","ICUS","IndexLocDate",xLocID,xDate,0))
			Set objLog=##class(DHCMed.NINF.Rep.AimICUSurvery).GetObjById(xLogID)
			If $IsObject(objLog)
			{
				Set AISItem1=objLog.AISItem1
				Set AISItem2=objLog.AISItem2
				Set AISItem3=objLog.AISItem3
				Set AISItem4=objLog.AISItem4
				Set AISItem5=objLog.AISItem5
				Set AISItem6=objLog.AISItem6
				Set AISItem7=objLog.AISItem7
				Set AISItem8=objLog.AISItem8
				Set AISItem9=objLog.AISItem9
				Set AISItem10=objLog.AISItem10
				Set AISItem11=objLog.AISItem11
				Set AISItem12=objLog.AISItem12
				Set AISItem13=objLog.AISItem13
				Set AISItem14=objLog.AISItem14
				Set AISItem15=objLog.AISItem15
				Set AISItem16=objLog.AISItem16
				Set AISItem17=objLog.AISItem17
				Set AISItem18=objLog.AISItem18
				Set AISItem19=objLog.AISItem19
				Set AISItem20=objLog.AISItem20
			}
			
			Set AISItem1=+$g(^TMP($zn,$j,NIndex,"Data",xLocID,xDate,"NewInHosp"))
			Set AISItem2=+$g(^TMP($zn,$j,NIndex,"Data",xLocID,xDate,"InHosp"))
			Set AISItem3=+$g(^TMP($zn,$j,NIndex,"Data",xLocID,xDate,"UC"))
			Set AISItem4=+$g(^TMP($zn,$j,NIndex,"Data",xLocID,xDate,"PICC"))
			Set AISItem5=+$g(^TMP($zn,$j,NIndex,"Data",xLocID,xDate,"VAP"))
			Set AISItem12=+$g(^TMP($zn,$j,NIndex,"Data",xLocID,xDate,"PatInf"))
			Set AISItem13=+$g(^TMP($zn,$j,NIndex,"Data",xLocID,xDate,"UCInf"))
			Set AISItem14=+$g(^TMP($zn,$j,NIndex,"Data",xLocID,xDate,"PICCInf"))
			Set AISItem15=+$g(^TMP($zn,$j,NIndex,"Data",xLocID,xDate,"VAPInf"))
			
			Set InputStr=xLogID_"^"_xLocID_"^"_xDate
			Set InputStr=InputStr_"^"_AISItem1_"^"_AISItem2_"^"_AISItem3_"^"_AISItem4_"^"_AISItem5
			Set InputStr=InputStr_"^"_AISItem6_"^"_AISItem7_"^"_AISItem8_"^"_AISItem9_"^"_AISItem10
			Set InputStr=InputStr_"^"_""
			Set InputStr=InputStr_"^"_AISItem11_"^"_AISItem12_"^"_AISItem13_"^"_AISItem14_"^"_AISItem15
			Set InputStr=InputStr_"^"_AISItem16_"^"_AISItem17_"^"_AISItem18_"^"_AISItem19_"^"_AISItem20
			
			Set flg=##Class(DHCMed.NINF.Rep.AimICUSurvery).Update(InputStr,"^")
		}
	}
	Kill ^TMP($zn,$j,NIndex)
	
	Quit "OK"
	
LogDataProcessByRepErr
	Write $ZError,!
	Quit "Error"
}

/// Creator：     zhufei
/// CreatDate：   2012-05-10
/// Description:  查询ICU调查日志记录
/// Table：       DHCMed.NINF.Rep.AimICUSurvery
/// Input:        argYYMM,argLoc
/// do ##class(%ResultSet).RunQuery("DHCMed.NINFService.Rep.AimICUSurvery","QryAISByMonth","2013-03","22")
Query QryAISByMonth(argYYMM As %String, argLoc As %String) As %Query(ROWSPEC = "LogIndex:%String,AISID:%String,LocID:%String,LocDesc:%String,SurveryDate:%String,SurveryDay:%String,AISItem1:%String,AISItem2:%String,AISItem3:%String,AISItem4:%String,AISItem5:%String,AISItem6:%String,AISItem7:%String,AISItem8:%String,AISItem9:%String,AISItem10:%String,AISItem11:%String,AISItem12:%String,AISItem13:%String,AISItem14:%String,AISItem15:%String,AISItem16:%String,AISItem17:%String,AISItem18:%String,AISItem19:%String,AISItem20:%String") [ SqlProc ]
{
}

ClassMethod QryAISByMonthExecute(ByRef qHandle As %Binary, argYYMM As %String, argLoc As %String) As %Status
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
	
	Set (Sum1,Sum2,Sum3,Sum4,Sum5,Sum6)=0
	Set LogIndex=0
	For xDate=xDateFrom:1:xDateTo
	{
		Quit:xDate>(+$h)
		Set (AISItem1,AISItem2,AISItem3,AISItem4,AISItem5,AISItem6,AISItem7,AISItem8,AISItem9,AISItem10)=""
		Set (AISItem11,AISItem12,AISItem13,AISItem14,AISItem15,AISItem16,AISItem17,AISItem18,AISItem19,AISItem20)=""
		Set xLogID=$o(^DHCMed.NINFi("Aim","ICUS","IndexLocDate",LocID,xDate,0))
		Set objLog=##class(DHCMed.NINF.Rep.AimICUSurvery).GetObjById(xLogID)
		If $IsObject(objLog)
		{
			Set AISItem1=objLog.AISItem1
			Set AISItem2=objLog.AISItem2
			
			Set AISItem2=AISItem1+AISItem2  
			
			Set AISItem3=objLog.AISItem3
			Set AISItem4=objLog.AISItem4
			Set AISItem5=objLog.AISItem5
			Set AISItem6=objLog.AISItem6
			Set AISItem7=objLog.AISItem7
			Set AISItem8=objLog.AISItem8
			Set AISItem9=objLog.AISItem9
			Set AISItem10=objLog.AISItem10
			Set AISItem11=objLog.AISItem11
			Set AISItem12=objLog.AISItem12
			Set AISItem13=objLog.AISItem13
			Set AISItem14=objLog.AISItem14
			Set AISItem15=objLog.AISItem15
			Set AISItem16=objLog.AISItem16
			Set AISItem17=objLog.AISItem17
			Set AISItem18=objLog.AISItem18
			Set AISItem19=objLog.AISItem19
			Set AISItem20=objLog.AISItem20
			
			Set Sum1=Sum1+AISItem1
			Set Sum2=Sum2+AISItem2
			Set Sum3=Sum3+AISItem3
			Set Sum4=Sum4+AISItem4
			Set Sum5=Sum5+AISItem5
			
		}
		
		Set SurveryDay=$p($zd(xDate,3),"-",3)
		Set LogIndex=LogIndex+1
		Set Data=$lb(LogIndex,xLogID,LocID,LocDesc,$zd(xDate,3),SurveryDay)
		Set Data=Data_$lb(AISItem1,AISItem2,AISItem3,AISItem4,AISItem5,AISItem6,AISItem7,AISItem8,AISItem9,AISItem10)
		Set Data=Data_$lb(AISItem11,AISItem12,AISItem13,AISItem14,AISItem15,AISItem16,AISItem17,AISItem18,AISItem19,AISItem20)
		Set ^CacheTemp(repid,ind)=Data
    	Set ind=ind+1
	}
	Set LogIndex=LogIndex+1
	Set Data=$lb(LogIndex,xLogID,LocID,LocDesc,$zd(xDate,3),"合计")
	Set Data=Data_$lb(Sum1,Sum2,Sum3,Sum4,Sum5,Sum6,AISItem7,AISItem8,AISItem9,AISItem10)
	Set Data=Data_$lb(AISItem11,AISItem12,AISItem13,AISItem14,AISItem15,AISItem16,AISItem17,AISItem18,AISItem19,AISItem20)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	
	Quit $$$OK
}

ClassMethod QryAISByMonthClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAISByMonthExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryAISByMonthFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAISByMonthExecute ]
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
/// Description:  ICU调查日志统计
/// Table：       DHCMed.NINF.Rep.AimICUSurvery
/// Input:        aFromDate 开始日期,aToDAte 结束日期
/// do ##class(%ResultSet).RunQuery("DHCMed.NINFService.Rep.AimICUSurvery","StaICUSurvery","2014-04-01","2014-04-29")
Query StaICUSurvery(aFromDate As %String, aToDate As %String) As %Query(ROWSPEC = "LocID:%String,LocDesc:%String,NewInHospSum:%Integer,InHospSum:%Integer,PICCSum:%Integer,VAPSum:%Integer,UCSum:%Integer,Item1:%Integer,Item2:%Integer,Item3:%Integer,Item4:%Integer,Item5:%Integer,Item6:%Integer,Item7:%Integer,Item8:%Integer,Item9:%Integer,Item10:%Integer,Item11:%Integer,Item12:%Integer,Item13:%Integer,Item14:%Integer,Item15:%Integer,Item16:%Integer,Item17:%Integer,Item18:%Integer,Item19:%Integer,Item20:%Integer,PatNum:%Integer") [ SqlProc ]
{
}

ClassMethod StaICUSurveryExecute(ByRef qHandle As %Binary, aFromDate As %String, aToDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set:aFromDate["/" aFromDate=$zdh(aFromDate,4)
	Set:aToDate["/" aToDate=$zdh(aToDate,4)
	Set:aFromDate["-" aFromDate=$zdh(aFromDate,3)
	Set:aToDate["-" aToDate=$zdh(aToDate,3)
	Quit:(aFromDate="")||(aToDate="") $$$OK
	
	Kill ^TMP($zn,$j,"StaICUSurvery")
	
	Set xLocID=0
	For {
		Set xLocID=$o(^DHCMed.NINFi("Aim","ICUS","IndexLocDate",xLocID))
		Quit:xLocID=""
		
		For xDate=aFromDate:1:aToDate {
			
			Set (Item1,Item2,Item3,Item4,Item5,Item6,Item7,Item8,Item9,Item10,Item11,Item12,Item13,Item14,Item15,Item16,Item17,Item18,Item19,Item20)=0
			Set xLogID=$o(^DHCMed.NINFi("Aim","ICUS","IndexLocDate",xLocID,xDate,0))
			Set objLog=##class(DHCMed.NINF.Rep.AimICUSurvery).GetObjById(xLogID)
			Continue:'$IsObject(objLog)
			
			Set Item1=+objLog.AISItem1
			Set Item2=+objLog.AISItem2
			Set Item3=+objLog.AISItem3
			Set Item4=+objLog.AISItem4
			Set Item5=+objLog.AISItem5
			Set Item6=+objLog.AISItem6
			Set Item7=+objLog.AISItem7
			Set Item8=+objLog.AISItem8
			Set Item9=+objLog.AISItem9
			Set Item10=+objLog.AISItem10
			
			Set Item11=+objLog.AISItem11
			Set Item12=+objLog.AISItem12
			Set Item13=+objLog.AISItem13
			Set Item14=+objLog.AISItem14
			Set Item15=+objLog.AISItem15
			Set Item16=+objLog.AISItem16
			Set Item17=+objLog.AISItem17
			Set Item18=+objLog.AISItem18
			Set Item19=+objLog.AISItem19
			Set Item20=+objLog.AISItem20
			
			Set num=+$g(^TMP($zn,$j,"StaICUSurvery",xLocID,"NewInHospSum"))
			Set ^TMP($zn,$j,"StaICUSurvery",xLocID,"NewInHospSum")=num+Item1
			
			Set num=+$g(^TMP($zn,$j,"StaICUSurvery",xLocID,"InHospSum"))
			Set ^TMP($zn,$j,"StaICUSurvery",xLocID,"InHospSum")=num+Item2
			
			Set num=+$g(^TMP($zn,$j,"StaICUSurvery",xLocID,"UCSum"))
			Set ^TMP($zn,$j,"StaICUSurvery",xLocID,"UCSum")=num+Item3
			
			Set num=+$g(^TMP($zn,$j,"StaICUSurvery",xLocID,"PICCSum"))
			Set ^TMP($zn,$j,"StaICUSurvery",xLocID,"PICCSum")=num+Item4
			
			Set num=+$g(^TMP($zn,$j,"StaICUSurvery",xLocID,"VAPSum"))
			Set ^TMP($zn,$j,"StaICUSurvery",xLocID,"VAPSum")=num+Item5
			
			Set num=+$g(^TMP($zn,$j,"StaICUSurvery",xLocID,"InfPatSum"))
			Set ^TMP($zn,$j,"StaICUSurvery",xLocID,"InfPatSum")=num+Item12
			
			Set num=+$g(^TMP($zn,$j,"StaICUSurvery",xLocID,"InfUCSum"))
			Set ^TMP($zn,$j,"StaICUSurvery",xLocID,"InfUCSum")=num+Item13
			
			Set num=+$g(^TMP($zn,$j,"StaICUSurvery",xLocID,"InfPICCSum"))
			Set ^TMP($zn,$j,"StaICUSurvery",xLocID,"InfPICCSum")=num+Item14
			
			Set num=+$g(^TMP($zn,$j,"StaICUSurvery",xLocID,"InfVAPSum"))
			Set ^TMP($zn,$j,"StaICUSurvery",xLocID,"InfVAPSum")=num+Item15
			
			Set num=+$g(^TMP($zn,$j,"StaICUSurvery",xLocID,"InfVenCut"))
			Set ^TMP($zn,$j,"StaICUSurvery",xLocID,"InfVenCut")=num+Item17
			
			Set num=+$g(^TMP($zn,$j,"StaICUSurvery",xLocID,"InfVenPipe"))
			Set ^TMP($zn,$j,"StaICUSurvery",xLocID,"InfVenPipe")=num+Item18
			
			Set xRowID=$o(^DHCMed.NINFi("Aim","ICUSAdm","IndexLocDate",xLocID,xDate,0))
			Set objadm=##class(DHCMed.NINF.Rep.AimICUSurveryAdm).GetObjById(xRowID)
			If $IsObject(objLog)
			{
				Set NewAdm=objLog.AISItem1
				Set InAdm=objLog.AISItem2
				
				For i=1:1:$l(NewAdm,",")	//新住进患者
				{
					set xPaadm=$p(NewAdm,",",i)
					Continue:xPaadm=""
					If '$d(^TMP($zn,$j,"StaICUSurvery",xLocID,"PatAdm",xPaadm))
					{
						Set ^TMP($zn,$j,"StaICUSurvery",xLocID,"PatAdm",xPaadm)=""
						Set num=+$g(^TMP($zn,$j,"StaICUSurvery",xLocID,"PatAdm"))
						Set ^TMP($zn,$j,"StaICUSurvery",xLocID,"PatAdm")=num+1
					}
				}
				For i=1:1:$l(InAdm,",")	//住在患者
				{
					set xPaadm=$p(InAdm,",",i)
					Continue:xPaadm=""
					If '$d(^TMP($zn,$j,"StaICUSurvery",xLocID,"PatAdm",xPaadm))
					{
						Set ^TMP($zn,$j,"StaICUSurvery",xLocID,"PatAdm",xPaadm)=""
						Set num=+$g(^TMP($zn,$j,"StaICUSurvery",xLocID,"PatAdm"))
						Set ^TMP($zn,$j,"StaICUSurvery",xLocID,"PatAdm")=num+1
					}
				}
			}
			
		}
	}
	
	Set xLocID=""
	For {
		Set xLocID=$o(^TMP($zn,$j,"StaICUSurvery",xLocID))
		Quit:xLocID=""
		
		Set LocDesc=$p($g(^CTLOC(xLocID)),"^",2)
		Set:$p(LocDesc,"-",2)'="" LocDesc=$p(LocDesc,"-",2)
		Continue:LocDesc=""
		
		Set NewInHospSum=+$g(^TMP($zn,$j,"StaICUSurvery",xLocID,"NewInHospSum"))
		Set xLogID=$o(^DHCMed.NINFi("Aim","ICUS","IndexLocDate",xLocID,aFromDate,0))
		Set objLog=##class(DHCMed.NINF.Rep.AimICUSurvery).GetObjById(xLogID)
		If $IsObject(objLog) {
			Set xPrevInHospSum=+objLog.AISItem2
			Set NewInHospSum=NewInHospSum+xPrevInHospSum
		}
		Set InHospSum=+$g(^TMP($zn,$j,"StaICUSurvery",xLocID,"InHospSum"))+NewInHospSum
		Set PICCSum=+$g(^TMP($zn,$j,"StaICUSurvery",xLocID,"PICCSum"))
		Set VAPSum=+$g(^TMP($zn,$j,"StaICUSurvery",xLocID,"VAPSum"))
		Set UCSum=+$g(^TMP($zn,$j,"StaICUSurvery",xLocID,"UCSum"))
		
		Set Item12=+$g(^TMP($zn,$j,"StaICUSurvery",xLocID,"InfPatSum"))
		Set Item13=+$g(^TMP($zn,$j,"StaICUSurvery",xLocID,"InfUCSum"))
		Set Item14=+$g(^TMP($zn,$j,"StaICUSurvery",xLocID,"InfPICCSum"))
		Set Item15=+$g(^TMP($zn,$j,"StaICUSurvery",xLocID,"InfVAPSum"))
		
		Set Item17=+$g(^TMP($zn,$j,"StaICUSurvery",xLocID,"InfVenCut"))
		Set Item18=+$g(^TMP($zn,$j,"StaICUSurvery",xLocID,"InfVenPipe"))
		
		Set PatNum=+$g(^TMP($zn,$j,"StaICUSurvery",xLocID,"PatAdm"))
		
		Set Data=$lb(xLocID,LocDesc,NewInHospSum,InHospSum,PICCSum,VAPSum,UCSum,Item1,Item2,Item3,Item4,Item5,Item6,Item7,Item8,Item9,Item10,Item11,Item12,Item13,Item14,Item15,Item16,Item17,Item18,Item19,Item20,PatNum)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Kill ^TMP($zn,$j,"StaICUSurvery")
	
	Quit $$$OK
}

ClassMethod StaICUSurveryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = StaICUSurveryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod StaICUSurveryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = StaICUSurveryExecute ]
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
/// Description:  ICU调查感染统计
/// Table：       DHCMed.NINF.Rep.InfReportICU
/// Input:        aFromDate 开始日期,aToDAte 结束日期
/// do ##class(%ResultSet).RunQuery("DHCMed.NINFService.Rep.AimICUSurvery","StaICUInfection","2013-07-01","2013-07-30","1")
Query StaICUInfection(aFromDate As %String, aToDate As %String, aStatType As %String = "1") As %Query(ROWSPEC = "LocID:%String,LocDesc:%String,InfPatSum:%Integer,InfAdmSum:%Integer,InfPICCSum:%Integer,InfVAPSum:%Integer,InfUCSum:%Integer") [ SqlProc ]
{
}

ClassMethod StaICUInfectionExecute(ByRef qHandle As %Binary, aFromDate As %String, aToDate As %String, aStatType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set:aFromDate["/" aFromDate=$zdh(aFromDate,4)
	Set:aToDate["/" aToDate=$zdh(aToDate,4)
	Set:aFromDate["-" aFromDate=$zdh(aFromDate,3)
	Set:aToDate["-" aToDate=$zdh(aToDate,3)
	Quit:(aFromDate="")||(aToDate="") $$$OK
	
	Kill ^TMP($zn,$j,"StaICUInfection")
	
	//ByOE：通过感染报告取插管相关感染信息
	//ByICU：通过感染报告取插管相关感染信息
	//ByRep：通过ICU调查报告取插管相关感染信息
	Set LogDataProcType=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("NINFICUSurveryDataType","")
	If LogDataProcType="ByRep" {
		Set IntubateTypeList=$lb("PICC","VAP","UC")
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
					
					Set xSubID=0
					For {
						Set xSubID=$o(^DHCMed.NINFi("InfRep",0,"ICU","IndexIntubateDate",xTypeID,xDate,xRepID,xSubID))
						Quit:xSubID=""
						
						Set objSub=##class(DHCMed.NINF.Rep.InfReportICU).GetObjById(xRepID_"||"_xSubID)
						Continue:'$IsObject(objSub)
						
						Set InfDate=objSub.InfDate
						Continue:((InfDate<aFromDate)||(InfDate>aToDate))
						
						//感染人次
						If '$d(^TMP($zn,$j,"StaICUInfection",TransLoc,"InfAdmList",EpisodeID)) {
							Set num=+$g(^TMP($zn,$j,"StaICUInfection",TransLoc,"InfPatSum"))
							Set ^TMP($zn,$j,"StaICUInfection",TransLoc,"InfPatSum")=num+1
							Set ^TMP($zn,$j,"StaICUInfection",TransLoc,"InfAdmList",EpisodeID)=""
						}
						//感染例次
						Set num=+$g(^TMP($zn,$j,"StaICUInfection",TransLoc,"InfAdmSum"))
						Set ^TMP($zn,$j,"StaICUInfection",TransLoc,"InfAdmSum")=num+1
						//各类插管感染例次
						Set num=+$g(^TMP($zn,$j,"StaICUInfection",TransLoc,"Inf"_xTypeCode_"Sum"))
						Set ^TMP($zn,$j,"StaICUInfection",TransLoc,"Inf"_xTypeCode_"Sum")=num+1

					}
				}
			}
		}
	} Else {
		Set xLocID=0
		For {
			Set xLocID=$o(^DHCMed.NINFi("Aim","ICUS","IndexLocDate",xLocID))
			Quit:xLocID=""
			
			For xDate=aFromDate:1:aToDate {
				
				Set (Item1,Item2,Item3,Item4,Item5,Item6,Item7,Item8,Item9,Item10)=0
				Set xLogID=$o(^DHCMed.NINFi("Aim","ICUS","IndexLocDate",xLocID,xDate,0))
				Set objLog=##class(DHCMed.NINF.Rep.AimICUSurvery).GetObjById(xLogID)
				Continue:'$IsObject(objLog)
				
				Set Item1=+objLog.AISItem12
				Set Item2=+objLog.AISItem12
				Set Item3=+objLog.AISItem13
				Set Item4=+objLog.AISItem14
				Set Item5=+objLog.AISItem15
				
				Set num=+$g(^TMP($zn,$j,"StaICUInfection",xLocID,"InfPatSum"))
				Set ^TMP($zn,$j,"StaICUInfection",xLocID,"InfPatSum")=num+Item1
				
				Set num=+$g(^TMP($zn,$j,"StaICUInfection",xLocID,"InfAdmSum"))
				Set ^TMP($zn,$j,"StaICUInfection",xLocID,"InfAdmSum")=num+Item2
				
				Set num=+$g(^TMP($zn,$j,"StaICUInfection",xLocID,"InfUCSum"))
				Set ^TMP($zn,$j,"StaICUInfection",xLocID,"InfUCSum")=num+Item3
				
				Set num=+$g(^TMP($zn,$j,"StaICUInfection",xLocID,"InfPICCSum"))
				Set ^TMP($zn,$j,"StaICUInfection",xLocID,"InfPICCSum")=num+Item4
				
				Set num=+$g(^TMP($zn,$j,"StaICUInfection",xLocID,"InfVAPSum"))
				Set ^TMP($zn,$j,"StaICUInfection",xLocID,"InfVAPSum")=num+Item5
			}
		}
	}
	
	Set xLocID=""
	For {
		Set xLocID=$o(^TMP($zn,$j,"StaICUInfection",xLocID))
		Quit:xLocID=""
		
		Set LocDesc=$p($g(^CTLOC(xLocID)),"^",2)
		Set:$p(LocDesc,"-",2)'="" LocDesc=$p(LocDesc,"-",2)
		Continue:LocDesc=""
		
		Set InfPatSum=+$g(^TMP($zn,$j,"StaICUInfection",xLocID,"InfPatSum"))
		Set InfAdmSum=+$g(^TMP($zn,$j,"StaICUInfection",xLocID,"InfAdmSum"))
		Set InfPICCSum=+$g(^TMP($zn,$j,"StaICUInfection",xLocID,"InfPICCSum"))
		Set InfVAPSum=+$g(^TMP($zn,$j,"StaICUInfection",xLocID,"InfVAPSum"))
		Set InfUCSum=+$g(^TMP($zn,$j,"StaICUInfection",xLocID,"InfUCSum"))
		Set Data=$lb(xLocID,LocDesc,InfPatSum,InfAdmSum,InfPICCSum,InfVAPSum,InfUCSum)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Kill ^TMP($zn,$j,"StaICUInfection")
	
	Quit $$$OK
}

ClassMethod StaICUInfectionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = StaICUInfectionExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod StaICUInfectionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = StaICUInfectionExecute ]
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

/// Creator：     LiuYH
/// CreatDate：   2013-03-13
/// Description:  查询ICU三管操作信息
/// Input:        
/// do ##class(%ResultSet).RunQuery("DHCMed.NINFService.Rep.AimICUSurvery","QryICUReport","2013-3-10","2013-03-31","","W")
Query QryICUReport(argDateFrom As %String, argDateTo As %String, argLocID As %String, aTransType As %String = "W") As %Query(ROWSPEC = "ind:%String,Paadm:%String,PapmiNo:%String,PatName:%String,AdmDate:%String,DisDate:%String,TransLocDesc:%String,TransInDate:%String,TransInTime:%String,TransOutDate:%String,TransOutTime:%String,OutLocDesc:%String,VenPipeInfo:%String,VenCutInfo:%String,NoninVenInfo:%String,DeepPipeInfo:%String,PICCInfo:%String,UreterPipeInfo:%String,DataDetail:%String")
{
}

ClassMethod QryICUReportExecute(ByRef qHandle As %Binary, argDateFrom As %String, argDateTo As %String, argLocID As %String, aTransType As %String = "W") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(argDateFrom="")||(argDateTo="") $$$OK
	
	Set ZIndex=$zn,JIndex=$j,NIndex="BuildAdmTransJson"
	Kill ^TMP(ZIndex,JIndex,NIndex)
	
	Set:argDateFrom["/" argDateFrom=$zdh(argDateFrom,4)
	Set:argDateTo["/" argDateTo=$zdh(argDateTo,4)
	Set:argDateFrom["-" argDateFrom=$zdh(argDateFrom,3)
	Set:argDateTo["-" argDateTo=$zdh(argDateTo,3)
	
	//取配置项目中维护的气管插管^气管切开^无创呼吸机^深静脉^PICC^留置导尿对应的监控项目ID
	Set ItemDicIDStr=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("NINFAimVenPipeItemDicID","")
	Quit:ItemDicIDStr="" $$$OK						
							
	Set DischDateIndex=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateIndex()  //update by pylian 2016-01-21取出院时间索引							
	Set xDate=argDateFrom-1
	For {
			Set xDate=xDate+1
			Quit:xDate>argDateTo
			Continue:'$d(^PAADMi(DischDateIndex,xDate))
			Set Paadm=""
			For {
					Set Paadm=$o(^PAADMi(DischDateIndex,xDate,Paadm))
					Quit:Paadm=""
					Do BuildPaadmListTMP
					
					Set AdmObj=##class(DHCMed.Base.PatientAdm).GetObjById(Paadm)
					Continue:'$IsObject(AdmObj)
							
					Set PatientID=AdmObj.PatientID
					Set PatObj=##class(DHCMed.Base.Patient).GetObjById(PatientID)
					Continue:'$IsObject(PatObj)
							
					Set AdmDate=AdmObj.AdmitDate_" "_AdmObj.AdmitTime
					Set DisDate=AdmObj.DisDate
					Set DisTime=AdmObj.DisTime
					Set PatName=PatObj.PatientName
					Set PapmiNo=PatObj.PapmiNo
								
					Set TransNum=+$g(^TMP(ZIndex,JIndex,NIndex,Paadm))
					
					Set TransID=0
					For {
							Set TransID=$o(^TMP(ZIndex,JIndex,NIndex,Paadm,TransID))
							Quit:TransID=""
					
							Set TransLoc=$o(^TMP(ZIndex,JIndex,NIndex,Paadm,TransID,0))
							Continue:TransLoc=""
							Continue:(argLocID'="")&&(argLocID'=TransLoc)
							Set TransLocDesc=$p($g(^CTLOC(+TransLoc)),"^",2)
							Set:$p(TransLocDesc,"-",2)'="" TransLocDesc=$p(TransLocDesc,"-",2)
							Continue:TransLocDesc=""
							Set TransInDate=$p($g(^PAADM(Paadm,"TRANS",TransID)),"^",1)
							Set:TransInDate'="" TransInDate=$zd(TransInDate,3)
							Set TransInTime=$p($g(^PAADM(Paadm,"TRANS",TransID)),"^",2)
							Set:TransInTime'="" TransInTime=$zt(TransInTime,2)
							
							Set OutTransID=$o(^TMP(ZIndex,JIndex,NIndex,Paadm,TransID))
							
							Set OutLocID="",OutLocDesc=""
							If OutTransID=""	//出院
							{
								Set TransOutDate=DisDate
								Set TransOutTime=DisTime
								Set OutLocDesc="出院"
									
							}Else{		b ;2		//转科
								Set TransOutDate=$p($g(^PAADM(Paadm,"TRANS",OutTransID)),"^",1)
								Set:TransOutDate'="" TransOutDate=$zd(TransOutDate,3)
								Set TransOutTime=$p($g(^PAADM(Paadm,"TRANS",OutTransID)),"^",2)
								Set:TransOutTime'="" TransOutTime=$zt(TransOutTime,2)
								Set OutLocID=$p($g(^PAADM(Paadm,"TRANS",TransID)),"^",6)
								Set:OutLocID'="" OutLocDesc=$p($g(^CTLOC(+OutLocID)),"^",2)	
							}
								
							Set DataDetail=""
									
							Set ItemDicID=$p(ItemDicIDStr,"/",1)
							//取气管插管信息
							
							Set VenPipeInfo=..GetPipeInfo(Paadm,ItemDicID,TransInDate,TransOutDate)
							b:Paadm=6
							Set:VenPipeInfo'="" DataDetail=DataDetail_"<b style=margin:40px'>"_"气管插管"_"</b><br>"_"<b style=margin:40px'>"_VenPipeInfo_"</b><br>"
							b:VenPipeInfo'="" 333
							Set ItemDicID=$p(ItemDicIDStr,"/",2)
							//取气管切开信息
							Set VenCutInfo=..GetPipeInfo(Paadm,ItemDicID,TransInDate,TransOutDate)
							Set:VenCutInfo'="" DataDetail=DataDetail_"<b style=margin:40px'>"_"气管切开"_"</b><br>"_"<b style=margin:40px'>"_VenCutInfo_"</b><br>"
								
							Set ItemDicID=$p(ItemDicIDStr,"/",3)
							//取无创呼吸机信息
							Set NoninVenInfo=..GetPipeInfo(Paadm,ItemDicID,TransInDate,TransOutDate)
							Set:NoninVenInfo'="" DataDetail=DataDetail_"<b style=margin:40px'>"_"无创呼吸机"_"</b><br>"_"<b style=margin:40px'>"_NoninVenInfo_"</b><br>"
								
							Set ItemDicID=$p(ItemDicIDStr,"/",4)
							//取深静脉信息
							Set DeepPipeInfo=..GetPipeInfo(Paadm,ItemDicID,TransInDate,TransOutDate)
							Set:DeepPipeInfo'="" DataDetail=DataDetail_"<b style=margin:40px'>"_"深静脉"_"</b><br>"_"<b style=margin:40px'>"_DeepPipeInfo_"</b><br>"
								
							Set ItemDicID=$p(ItemDicIDStr,"/",5)
							//取PICC信息
							Set PICCInfo=..GetPipeInfo(Paadm,ItemDicID,TransInDate,TransOutDate)
							Set:PICCInfo'="" DataDetail=DataDetail_"<b style=margin:40px'>"_"PICC:"_"</b><br>"_"<b style=margin:40px'>"_PICCInfo_"</b><br>"
								
							Set ItemDicID=$p(ItemDicIDStr,"/",6)
							//取留置导尿信息
							Set UreterPipeInfo=..GetPipeInfo(Paadm,ItemDicID,TransInDate,TransOutDate)
							Set:UreterPipeInfo'="" DataDetail=DataDetail_"<b style=margin:40px'>"_"留置导尿"_"</b><br>"_"<b style=margin:40px'>"_UreterPipeInfo_"</b><br>"
								
							Set Data=$lb(ind,Paadm,PapmiNo,PatName,AdmDate,DisDate,TransLocDesc,TransInDate,TransInTime,TransOutDate,TransOutTime,OutLocDesc,VenPipeInfo,VenCutInfo,NoninVenInfo,DeepPipeInfo,PICCInfo,UreterPipeInfo,DataDetail)
							Set ^CacheTemp(repid,ind)=Data
							Set ind=ind+1
						}
					  
				}
		}
		
	Quit $$$OK

BuildPaadmListTMP
	//就诊类型
	Set AdmType=$p($g(^PAADM(+Paadm)),"^",2)
	Quit:AdmType'="I"
	
	//在院状态
	Set VisitStatus=$p($g(^PAADM(+Paadm)),"^",20)
	Quit:VisitStatus="C"
	
	//科室,病区
	Set AdmLocID=$p($g(^PAADM(+Paadm)),"^",4)
	Set AdmWardID=$p($g(^PAADM(+Paadm)),"^",70)
	Set:AdmWardID'="" AdmWardID=$p($g(^PAWARD(AdmWardID)),"^",5)
	
	Set TransID=0,PreTransLoc=""
	For {
		Set TransID=$o(^PAADM(Paadm,"TRANS",TransID))
		Quit:TransID=""
		
		//科室/病区  由"科室类型"决定
		If aTransType="E" {
			Set RepLocID=AdmLocID
			Set TransLoc=$p($g(^PAADM(Paadm,"TRANS",TransID)),"^",6)
		} Else {
			Set RepLocID=AdmWardID
			Set TransLoc=$p($g(^PAADM(Paadm,"TRANS",TransID)),"^",8)
			Set:TransLoc'="" TransLoc=$p(TransLoc,"||",1)
			Set:TransLoc'="" TransLoc=$p($g(^PAWARD(TransLoc)),"^",5)
		}
		Continue:TransLoc=""
		Continue:TransLoc=PreTransLoc

		Set PreTransLoc=TransLoc
		
		Set num=$i(^TMP(ZIndex,JIndex,NIndex,Paadm))
		Set ^TMP(ZIndex,JIndex,NIndex,Paadm,TransID,TransLoc)=""
	}
	Quit
}

ClassMethod QryICUReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryICUReportExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryICUReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryICUReportExecute ]
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

/// w ##Class(DHCMed.NINFService.Srv.CommonCls).GetAdmTrans("3||56")
ClassMethod GetAdmTrans(aTransID As %String, aTransLoc As %String) As %String
{
	New (aTransID,aTransLoc)
	Set return=""
	
	Set (TransLocID,TransLocDesc,TransType)=""
	Set (TransFromLocID,TransFromLocDesc,TransToLocID,TransToLocDesc)=""
	Set (TransStartDate,TransStartTime,TransEndDate,TransEndTime)=""
	
	Set Paadm=+aTransID,TransSubID=+$p(aTransID,"||",2)
	Set tmpTrans=$g(^PAADM(Paadm,"TRANS",TransSubID))
	Quit:tmpTrans="" return
	
	Set TransLocID=aTransLoc
	Set TransLocDesc=$p($g(^CTLOC(+TransLocID)),"^",2)
	Set:$p(TransLocDesc,"-",2)'="" TransLocDesc=$p(TransLocDesc,"-",2)
	Set TransType=$p($g(^CTLOC(+aTransLoc)),"^",13)
	
	Set TransStartDate=$p(tmpTrans,"^",1)
	Set:TransStartDate'="" TransStartDate=$zd(+TransStartDate,3)
	Set TransStartTime=$p(tmpTrans,"^",2)
	Set:TransStartTime'="" TransStartTime=$zt(+TransStartTime,1)
	
	//入科来源
	Set xTransID=TransSubID
	For {
		Set xTransID=$o(^PAADM(Paadm,"TRANS",xTransID),-1)
		Quit:xTransID=""
		
		Set xTmpTrans=$g(^PAADM(Paadm,"TRANS",xTransID))
		Continue:xTmpTrans=""
		If TransType="E" {
			Set xTransLocID=$p(xTmpTrans,"^",6)
		} Else {
			Set xTransLocID=$p(xTmpTrans,"^",8)
			Set:xTransLocID'="" xTransLocID=$p(xTransLocID,"||",1)
			Set:xTransLocID'="" xTransLocID=$p($g(^PAWARD(xTransLocID)),"^",5)
		}
		Continue:xTransLocID=""
		Continue:xTransLocID=TransLocID

		Set TransFormLocID=xTransLocID
		Set TransFormLocDesc=$p($g(^CTLOC(+TransFormLocID)),"^",2)
		Set:$p(TransFormLocDesc,"-",2)'="" TransFormLocDesc=$p(TransFormLocDesc,"-",2)

		Quit
	}
	
	//转出时间、出科去向
	Set TransEndDate="",TransEndTime=""
	Set xTransID=TransSubID
	For {
		Set xTransID=$o(^PAADM(Paadm,"TRANS",xTransID))
		Quit:xTransID=""
		
		Set xTmpTrans=$g(^PAADM(Paadm,"TRANS",xTransID))
		Continue:xTmpTrans=""
		If TransType="E" {
			Set xTransLocID=$p(xTmpTrans,"^",6)
		} Else {
			Set xTransLocID=$p(xTmpTrans,"^",8)
			Set:xTransLocID'="" xTransLocID=$p(xTransLocID,"||",1)
			Set:xTransLocID'="" xTransLocID=$p($g(^PAWARD(xTransLocID)),"^",5)
		}
		Continue:xTransLocID=""
		Continue:xTransLocID=TransLocID
		
		Set TransToLocID=xTransLocID
		Set TransToLocDesc=$p($g(^CTLOC(+TransToLocID)),"^",2)
		Set:$p(TransToLocDesc,"-",2)'="" TransToLocDesc=$p(TransToLocDesc,"-",2)
		Set TransEndDate=$p(xTmpTrans,"^",1)
		Set:TransEndDate'="" TransEndDate=$zd(+TransEndDate,3)
		Set TransEndTime=$p(xTmpTrans,"^",2)
		Set:TransEndTime'="" TransEndTime=$zt(+TransEndTime,1)
		Quit
	}
	If TransEndDate="" {  //最终结算时间
		Set TransEndDate=$p($g(^PAADM(Paadm)),"^",17)
		Set:TransEndDate'="" TransEndDate=$zd(+TransEndDate,3)
		Set TransEndTime=$p($g(^PAADM(Paadm)),"^",18)
		Set:TransEndTime'="" TransEndTime=$zt(+TransEndTime,1)
	}
	If (TransEndDate'="")
	{
		Set TransLocDays=$zdh(TransEndDate,3)-$zdh(TransStartDate,3)+1
	} Else {
		Set TransLocDays=(+$h)-$zdh(TransStartDate,3)+1
	}
	Set TransLocDiagnos=""
	
	Set return=TransLocID_$c(1)_TransLocDesc
	Set return=return_$c(1)_TransFromLocID_$c(1)_TransFromLocDesc
	Set return=return_$c(1)_TransToLocID_$c(1)_TransToLocDesc
	Set return=return_$c(1)_TransStartDate_$c(1)_TransStartTime
	Set return=return_$c(1)_TransEndDate_$c(1)_TransEndTime
	Set return=return_$c(1)_TransLocDays_$c(1)_TransLocDiagnos
	
	Quit return
}

/// w ##Class(DHCMed.NINFService.Srv.CommonCls)GetPipeInfo(6,127,"","")
ClassMethod GetPipeInfo(argPaadm As %String, argItemDicID As %String, argTransInDate As %String, argTransOutDate As %String) As %String
{
	New (argPaadm,argItemDicID,argTransInDate,argTransOutDate)
	
	Set return=""
	Quit:(argPaadm="")||(argItemDicID="")||(argTransInDate="")||(argTransOutDate="") return
	
	Set:argTransInDate["-" argTransInDate=$zdh(argTransInDate,3)
	Set:argTransOutDate["-" argTransOutDate=$zdh(argTransOutDate,3)
	Quit:'$d(^DHCMed.CC.CtlResultI("Detail","IndexSubjectItemID",argPaadm,argItemDicID)) return
	Set CtlResultID=""
	For {
		Set CtlResultID=$o(^DHCMed.CC.CtlResultI("Detail","IndexSubjectItemID",argPaadm,argItemDicID,CtlResultID))
		Quit:CtlResultID=""
		
		Set CtlObj=##class(DHCMed.CC.CtlResult).GetObjById(CtlResultID)
		Continue:'$IsObject(CtlObj)
		
		Set ObjectID=CtlObj.ObjectID
		Set ObjectID=$tr(ObjectID," ","")
		
		Set OEObj=##class(DHCMed.Base.OrdItem).GetObjById(ObjectID)
		Continue:'$IsObject(OEObj) 
		Continue:(..IsValidOEItem(ObjectID)=0)
		
		Set sDate=OEObj.OEORISttDat
		Set sTime=OEObj.OEORISttTim
		
		Set eDate=OEObj.OEORIXDate
		Set eTime=OEObj.OEORIXTime
		
		Set PipeTime=(sDate-eDate)*24*60*60-(eTime-sTime)
		Continue:PipeTime<900
		Continue:(sDate>argTransOutDate)||(eDate>argTransInDate)
		
		Set:eDate="" eDate=argTransOutDate
		
		If (sDate'>argTransInDate)&&(argTransOutDate'<eDate)	//医嘱开始日期 小于 等于 转入日期 结束日期 小于等于 转出日期
		{
			Set return=return_$c(1)_$zd(argTransInDate,3)_"^"_$zd(eDate,3)
		
		}ElseIf (sDate'<argTransInDate)&&(argTransOutDate'>eDate){	//医嘱开始日期大于等于转入日期 结束日期小于等于转出日期
			Set return=return_$c(1)_$zd(sDate,3)_"^"_$zd(eDate,3)
		
		}Else{
			Set return=return_$c(1)_$zd(sDate,3)_"^"_$zd(argTransOutDate,3)
		}
	}
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2012-08-31
/// Description:  判断医嘱是否有效
/// Table：       OE_OrdItem
/// Input：       
/// Return：      return=0：无效   return=1：有效
/// w ##class(DHCMed.CCService.Lib.OEOrdItem).IsValidOEItem("")
ClassMethod IsValidOEItem(argOEItemID As %String, argIsAll As %String = "N") As %String
{
	New (argOEItemID,argIsAll)
	Set return=0
	Quit:argOEItemID="" return
	
	Set $ZT="IsValidOEItemErr"
	
	Set StatusID=$p($g(^OEORD(+argOEItemID,"I",+$p(argOEItemID,"||",2),1)),"^",13)
	Set StatusCode=$p($g(^OEC("OSTAT",+StatusID)),1)
	Set StatusDesc=$p($g(^OEC("OSTAT",+StatusID)),2)
	Quit:(StatusCode="")||(StatusDesc="") return
	
	//作废,未审核,预开医嘱
	Set StatusList=$lb("U","I","P")
	Quit:($listfind(StatusList,StatusCode)>0) return
	
	//停止医嘱
	If (StatusCode="D")&&(argIsAll'="Y") {
		Quit return
	}
	
	Set return=1
	Quit return
	
IsValidOEItemErr
	Quit 0
}

/// w ##Class(DHCMed.NINFService.Rep.AimICUSurvery).GetOldData()
ClassMethod GetOldData()
{
	
	/* update by zf 2013-04-28
	//系统自动提取在院人数
	//DHCMRIPDay  工作量基础数据表
	Set xWardID=""
	For {
		Set xWardID=$o(^PAWARD(xWardID))
		Quit:xWardID=""
		Set IsActive=$p($g(^PAWARD(xWardID)),"^",6)
		Continue:IsActive'="Y"
		Set LocID=$p($g(^PAWARD(xWardID)),"^",5)
		Continue:(aLocID'="")&&(aLocID'=LocID)
		
		For xDate=aFromDate:1:aToDate {
			Set xIPDailyID=0
			For {
				Set xIPDailyID=$o(^MRIPdaily("MRIPWARD",xWardID,"MRIPDATE",xDate,xIPDailyID))
				Quit:xIPDailyID=""
				Set tmpIPDaily=$g(^MRIPdaily(xIPDailyID))
				Continue:tmpIPDaily=""
				Set ryrs=+$p(tmpIPDaily,"^",8)     //入院人数
				Set tkzrrs=+$p(tmpIPDaily,"^",9)   //他科转入人数
				Set tyrs=+$p(tmpIPDaily,"^",10)    //退院人数
				Set xyrs=+$p(tmpIPDaily,"^",18)    //现有人数
				Set NewInHosp=ryrs+tkzrrs-tyrs
				Set:NewInHosp<0 NewInHosp=0
				Set num=+$g(^TMP($zn,$j,NIndex,"Data",LocID,xDate,"NewInHosp"))
				Set ^TMP($zn,$j,NIndex,"Data",LocID,xDate,"NewInHosp")=num+NewInHosp
				Set num=+$g(^TMP($zn,$j,NIndex,"Data",LocID,xDate,"InHosp"))
				Set ^TMP($zn,$j,NIndex,"Data",LocID,xDate,"InHosp")=num+xyrs
			}
		}
	}
	*/
	
	Quit "Over!"
}

}
