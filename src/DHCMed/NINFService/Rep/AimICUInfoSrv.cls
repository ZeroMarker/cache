/// 名称: DHCMed.NINFService.Rep.AimICUInfoSrv
/// 描述: ICU信息查询汇总
/// 编写者：zhufei
/// 编写日期: 2012-06-16
Class DHCMed.NINFService.Rep.AimICUInfoSrv Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// w ##class(DHCMed.NINFService.Rep.AimICUInfoSrv).GetInPatNums("2013-01","2013-01",79)
ClassMethod GetInPatNums(sMonthFrom As %String, sMonthTo As %String, sLocID As %String) As %String
{
	New (sMonthFrom,sMonthTo,sLocID)
	
	Set xStartDate=sMonthFrom_"-01"
 	Set xStartDate=$zdh(xStartDate,3)
 	Set xEndDate=$p(sMonthTo,"-",1)_"-"_(+$p(sMonthTo,"-",2)+1)_"-01"
 	Set:+$p(sMonthTo,"-",2)=12 xEndDate=($p(sMonthTo,"-",1)+1)_"-01-01"
 	Set xEndDate=$zdh(xEndDate,3)-1
	
	Set LocID=sLocID
	
	Set (AISItem2Sum,AISItem3Sum,AISItem4Sum,AISItem5Sum,AISItem6Sum)=0
	
	Set LogIndex=0
	For xDate=xStartDate:1:xEndDate {
		Continue:xDate>(+$h)
		Set AISItem2=""
		Set xLogID=$o(^DHCMed.NINFi("Aim","ICUS","IndexLocDate",LocID,xDate,0))
		Set objLog=##class(DHCMed.NINF.Rep.AimICUSurvery).GetObjById(xLogID)
		If $IsObject(objLog)
		{
			Set AISItem2=objLog.AISItem2	//住院病人总数
			Set AISItem3=objLog.AISItem3	//带尿管病人数
			Set AISItem4=objLog.AISItem4	//带中心静脉导管病人数
			Set AISItem5=objLog.AISItem5	//带呼吸机病人数
			Set AISItem6=objLog.AISItem6	//手术台数
			Set AISItem2Sum=AISItem2Sum+(+AISItem2)
			Set AISItem3Sum=AISItem3Sum+(+AISItem3)
			Set AISItem4Sum=AISItem4Sum+(+AISItem4)
			Set AISItem5Sum=AISItem5Sum+(+AISItem5)
			Set AISItem6Sum=AISItem6Sum+(+AISItem6)
		}
	}
	
	Quit AISItem2Sum_"^"_AISItem3Sum_"^"_AISItem4Sum_"^"_AISItem5Sum_"^"_AISItem6Sum
}

ClassMethod GetNNISByEpisodeID(EpisodeID As %String, LocID As %String, xStartDate As %String, xEndDate As %String) As %String
{
	New (EpisodeID,LocID,xStartDate,xEndDate)
	
	Set return="",InfFlag=0
	Quit:EpisodeID="" return
	
	Set RepTypeID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode("OPR","NINFAimReportType")
	
	Quit:'$d(^DHCMed.NINFi("AimRep",0,"IndexTypeAdmTrans",RepTypeID,EpisodeID)) return
	
	Set TranID=""
	For {
		Set TranID=$o(^DHCMed.NINFi("AimRep",0,"IndexTypeAdmTrans",RepTypeID,EpisodeID,TranID))
		Quit:TranID=""
		
		Set RepID=""
		For {
			Set RepID=$o(^DHCMed.NINFi("AimRep",0,"IndexTypeAdmTrans",RepTypeID,EpisodeID,TranID,RepID))
			Quit:RepID=""
				
			Set objRep=##class(DHCMed.NINF.Rep.AimReport).GetObjById(RepID)
			Continue:'$IsObject(objRep)
			Set TransLoc=objRep.TransLoc
			Continue:(LocID'="")&&(LocID'=TransLoc)
			
			Set SubID=""
			For {
				Set SubID=$o(^DHCMed.NINF("AimRep",RepID,"OPR",SubID))
				Quit:SubID=""	
				
				
				Set ReportID=RepID_"||"_SubID
				Set objRepSub=##class(DHCMed.NINF.Rep.AimReportOPR).GetObjById(ReportID)
				Continue:'$IsObject(objRepSub)
				
				Set objRepStatus=objRepSub.RepStatus
				If $IsObject(objRepStatus) {
					Set RepStatusCode=objRepStatus.Code
					Continue:RepStatusCode="0"  //删除的报告不再显示
					//Continue:(RepStatusCode'="2")  //未提交的报告不显示
				}
				Set OperStartDate=objRepSub.OperStartDate
				Continue:(OperStartDate="")||(OperStartDate<xStartDate)||(OperStartDate>xEndDate)
				Set OperTimes=objRepSub.OperTimes
				Set score=0
				Set:OperTimes>120 score=score+1
				
				Set objOperCutType=objRepSub.OperCutType
				Set OperCutTypeDesc=""
				If $IsObject(objOperCutType) {
					Set OperCutTypeDesc=objOperCutType.Description
				}
				Set:(OperCutTypeDesc="III") score=score+1
				Set:(OperCutTypeDesc="IV") score=score+1
				Set:(OperCutTypeDesc="V") score=score+1
				
				Set OperASAScore=objRepSub.OperASAScore
				
				Set:OperASAScore>2 score=score+1
				
				
				if ((return="")||(score>return))
				{
					Set return=score	
				
					Set InfDate=+objRepSub.InfDate
					Set:InfDate>0 InfFlag=1
				}
	
			}	
		}
	}
	
	Quit return_"^"_InfFlag
}

/// Creator：     zhufei
/// CreatDate：   2012-06-16
/// Description:  ICU信息调查汇总表
/// D ##class(%ResultSet).RunQuery("DHCMed.NINFService.Rep.AimICUInfoSrv","QryByMonthLoc","2013-11","2013-11","","W")
Query QryByMonthLoc(aMonthFrom As %String, aMonthTo As %String, aLocID As %String, aTransType As %String = "") As %Query(ROWSPEC = "AimIndex:%String,AimLocDesc:%String,AimMonth:%String,IPDays:%String,IPNum:%String,UCDays:%String,UCRatio:%String,UCInfNum:%String,UCInfRatio:%String,UCInfPats:%String,PICCDays:%String,PICCRatio:%String,PICCInfNum:%String,PICCInfRatio:%String,PICCInfPats:%String,VAPDays:%String,VAPRatio:%String,VAPInfNum:%String,VAPInfRatio:%String,VAPInfPats:%String,OPRNum:%String,OPRInfNum:%String,OPRInfRatio:%String,OPRInfPats:%String,InfNums:%String,InfRatio:%String,xLocID:%String,Score0:%String,Score1:%String,Score2:%String,Score3:%String,Inf0Rate:%String,Inf1Rate:%String,Inf2Rate:%String,Inf3Rate:%String")
{
}

ClassMethod QryByMonthLocExecute(ByRef qHandle As %Binary, aMonthFrom As %String, aMonthTo As %String, aLocID As %String, aTransType As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:(aMonthFrom="")||(aMonthTo="") $$$OK
 	Set ZIndex=$zn,JIndex=$j,NIndex="QryByMonthLoc"
 	Kill ^TMP(ZIndex,JIndex,NIndex)
 	
 	//取月住院天数
 	Set xStartDate=aMonthFrom_"-01"
 	Set xStartDate=$zdh(xStartDate,3)
 	Set xEndDate=aMonthTo_"-01"
 	Set xEndDate=$zd($zdh(xEndDate,3)+32,3)
 	Set xEndDate=$zdh($p(xEndDate,"-",1)_"-"_$p(xEndDate,"-",2)_"-01",3)-1
 	
 	Set ZIndex=$zn,JIndex=$j,NIndex="QryByMonthLoc"
 	Kill ^TMP(ZIndex,JIndex,NIndex)
 	
 	//计算科室在院人数
	For xDate=xStartDate:1:(xEndDate+10) {
		Set xLocID=0
		For {
			Set xLocID=$o(^DHCMed.CC.CtlResultI("AdmTrans",0,"IndexOutDateLoc",xDate,xLocID))
			Quit:xLocID=""
			Continue:(aLocID'="")&&(aLocID'=xLocID)
			
			Set xPaadm=0
			For {
				Set xPaadm=$o(^DHCMed.CC.CtlResultI("AdmTrans",0,"IndexOutDateLoc",xDate,xLocID,xPaadm))
				Quit:xPaadm=""
				
			 	//Set xMonth=aMonthFrom_"至"_aMonthTo
			 	Set yDate=$zd(xDate,3)
			 	Set xMonth=$p(yDate,"-",1)_"年"_$p(yDate,"-",2)_"月"
		 		
				Set xAdmTransID=0
				For {
					Set xAdmTransID=$o(^DHCMed.CC.CtlResultI("AdmTrans",0,"IndexOutDateLoc",xDate,xLocID,xPaadm,xAdmTransID))
					Quit:xAdmTransID=""
					
					Set objAdmTrans=##class(DHCMed.CC.CtlAdmTrans).GetObjById(xAdmTransID)
					Continue:'$IsObject(objAdmTrans)
					Continue:objAdmTrans.TransType'=aTransType
					
					If objAdmTrans.LinkID'="" {
						Set tmpAimTransID=objAdmTrans.LinkID
						Set objAdmTrans=##class(DHCMed.CC.CtlAdmTrans).GetObjById(tmpAimTransID)
						Continue:'$IsObject(objAdmTrans)
					} Else {
						Set tmpAimTransID=objAdmTrans.%Id()
					}
					Continue:$d(^TMP(ZIndex,JIndex,NIndex,"AdmTrans",tmpAimTransID))
					Set ^TMP(ZIndex,JIndex,NIndex,"AdmTrans",tmpAimTransID)=""
					Set TransInDate=objAdmTrans.TransInDate
					Set TransOutDate=objAdmTrans.TransOutDate
					Continue:TransInDate>xEndDate
					Continue:TransOutDate<xStartDate
					
					Set TransID=objAdmTrans.TransID
					Set EpisodeID=objAdmTrans.EpisodeID
					Continue:EpisodeID=""
					
					//Set DischDate=$p($g(^PAADM(EpisodeID)),"^",17)
					//Update by pylian 2016-01-21 修改出院时间取值方式
					Set DischDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateTime(EpisodeID)
					Set DischDate=$p(DischDateTime,"^",1)
					Set VisitStatus=$p($g(^PAADM(EpisodeID)),"^",20)
					Continue:(VisitStatus'="A")&&(VisitStatus'="D")
					Set:VisitStatus'="D" DischDate=""
					
					//NNIS评分
					Set NNISScore=..GetNNISByEpisodeID(EpisodeID,xLocID,xStartDate,xEndDate)
					if (($p(NNISScore,"^",1)=0)&&('$d(^TMP(ZIndex,JIndex,NIndex,xLocID,xMonth,"Score0",EpisodeID)))) 
					{
						Set num=$i(^TMP(ZIndex,JIndex,NIndex,xLocID,xMonth,"Score0"))
						Set:$p(NNISScore,"^",2)=1 num=$i(^TMP(ZIndex,JIndex,NIndex,xLocID,xMonth,"Inf0"))
						Set ^TMP(ZIndex,JIndex,NIndex,xLocID,xMonth,"Score0",EpisodeID)=""
					}
					if (($p(NNISScore,"^",1)=1)&&('$d(^TMP(ZIndex,JIndex,NIndex,xLocID,xMonth,"Score1",EpisodeID))))  
					{
						Set num=$i(^TMP(ZIndex,JIndex,NIndex,xLocID,xMonth,"Score1"))
						Set:$p(NNISScore,"^",2)=1 num=$i(^TMP(ZIndex,JIndex,NIndex,xLocID,xMonth,"Inf1"))
						Set ^TMP(ZIndex,JIndex,NIndex,xLocID,xMonth,"Score1",EpisodeID)=""
					}
					if (($p(NNISScore,"^",1)=2)&&('$d(^TMP(ZIndex,JIndex,NIndex,xLocID,xMonth,"Score2",EpisodeID))))  
					{
						Set num=$i(^TMP(ZIndex,JIndex,NIndex,xLocID,xMonth,"Score2"))
						Set:$p(NNISScore,"^",2)=1 num=$i(^TMP(ZIndex,JIndex,NIndex,xLocID,xMonth,"Inf2"))
						Set ^TMP(ZIndex,JIndex,NIndex,xLocID,xMonth,"Score2",EpisodeID)=""
					}
					if (($p(NNISScore,"^",1)=3)&&('$d(^TMP(ZIndex,JIndex,NIndex,xLocID,xMonth,"Score3",EpisodeID))))  
					{
						Set num=$i(^TMP(ZIndex,JIndex,NIndex,xLocID,xMonth,"Score3"))
						Set:$p(NNISScore,"^",2)=1 num=$i(^TMP(ZIndex,JIndex,NIndex,xLocID,xMonth,"Inf3"))
						Set ^TMP(ZIndex,JIndex,NIndex,xLocID,xMonth,"Score3",EpisodeID)=""
					}
					
					//住院日数
					//Set EstimDischDate=$p($g(^PAADM(EpisodeID)),"^",59)
					//Set DischDate=$p($g(^PAADM(EpisodeID)),"^",17)
					//Update by pylian 2016-01-21 修改出院时间取值方式
					Set DischDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateTime(EpisodeID)
					Set DischDate=$p(DischDateTime,"^",1)
					For indDate=(TransInDate+1):1:TransOutDate {
						Continue:indDate<xStartDate
						Quit:indDate>xEndDate
						If DischDate'="" {
							Continue:indDate>DischDate
						}
						If '$d(^TMP(ZIndex,JIndex,NIndex,xLocID,xMonth,"IPDaysDtl",EpisodeID,indDate)) {
							Set num=$i(^TMP(ZIndex,JIndex,NIndex,xLocID,xMonth,"IPDays"))  //住院日数
							Set ^TMP(ZIndex,JIndex,NIndex,xLocID,xMonth,"IPDaysDtl",EpisodeID,indDate)=""
						}
					}
					
					//住院例数
					Set TransID=EpisodeID_"||"_TransID
					If '$d(^TMP(ZIndex,JIndex,NIndex,xLocID,xMonth,"IPNum",EpisodeID))
					{
						Set num=$i(^TMP(ZIndex,JIndex,NIndex,xLocID,xMonth,"IPNum"))  //住院例数
						Set ^TMP(ZIndex,JIndex,NIndex,xLocID,xMonth,"IPNum",EpisodeID)=""
					}
					
					//感染人数
					Set xReportID=0
					For {
						Set xReportID=$o(^DHCMed.NINFi("InfRep",0,"IndexPaadm",EpisodeID,xReportID))
						Quit:xReportID=""
						
						Set xSubID=0
						For {
							Set xSubID=$o(^DHCMed.NINF("InfRep",xReportID,"InfPos",xSubID))
							Quit:xSubID=""
							
							Set objInfPos=##class(DHCMed.NINF.Rep.InfReportInfPos).GetObjById(xReportID_"||"_xSubID)
							Continue:'$IsObject(objInfPos)
							Continue:'$IsObject(objInfPos.InfPos)
							Set InfPosID=objInfPos.InfPos.%Id()
							Set InfDate=objInfPos.InfDate
							Continue:InfDate<TransInDate
							Continue:InfDate>TransOutDate
							
							If '$d(^TMP(ZIndex,JIndex,NIndex,xLocID,xMonth,"InfPatNum",EpisodeID)) {
								Set num=$i(^TMP(ZIndex,JIndex,NIndex,xLocID,xMonth,"InfPatNum"))  //感染人数
								Set ^TMP(ZIndex,JIndex,NIndex,xLocID,xMonth,"InfPatNum",EpisodeID)=""
							}
							
							If '$d(^TMP(ZIndex,JIndex,NIndex,xLocID,xMonth,"InfNum",EpisodeID,InfPosID,InfDate)) {
								Set num=$i(^TMP(ZIndex,JIndex,NIndex,xLocID,xMonth,"InfNum"))  //感染例数
								Set ^TMP(ZIndex,JIndex,NIndex,xLocID,xMonth,"InfNum",EpisodeID,InfPosID,InfDate)=""
							}
						}
					}
					
					//三管信息
					If '$d(^TMP(ZIndex,JIndex,NIndex,xLocID,xMonth,"IPDays",TransID))
					{
						Set ^TMP(ZIndex,JIndex,NIndex,xLocID,xMonth,"IPDays",TransID)=""
						Set ReportType=0
						For {
							Set ReportType=$o(^DHCMed.NINFi("AimRep",0,"IndexTypeAdmTrans",ReportType))
							Quit:ReportType=""
							Set AimRepID=0
							For {
								Set AimRepID=$o(^DHCMed.NINFi("AimRep",0,"IndexTypeAdmTrans",ReportType,EpisodeID,TransID,AimRepID))
								Quit:AimRepID=""
							
								Set objAimRep=##class(DHCMed.NINF.Rep.AimReport).GetObjById(AimRepID)
								Continue:'$IsObject(objAimRep)
								
								//导尿管
								Set SubID=0
								For {
									Set SubID=$o(^DHCMed.NINF("AimRep",AimRepID,"UC",SubID))
									Quit:SubID=""
									Set AimRepSubID=AimRepID_"||"_SubID
									Set objAimRepSub=##class(DHCMed.NINF.Rep.AimReportUC).GetObjById(AimRepSubID)
									Continue:'$IsObject(objAimRepSub)
									Set objRepStatus=objAimRepSub.RepStatus
									If $IsObject(objRepStatus) {
										Set RepStatusCode=objRepStatus.Code
										Continue:RepStatusCode="0"  //删除的报告不再显示
									}
									Set IntubateDate=objAimRepSub.IntubateDate
									Set ExtubateDate=objAimRepSub.ExtubateDate
									If ExtubateDate="" {
										If DischDate'="" {
											Set ExtubateDate=DischDate
										} Else {
											Set ExtubateDate=+$h
										}
									}
									For xIntuDate=IntubateDate:1:ExtubateDate
									{
										If (xIntuDate>=xStartDate)&&(xIntuDate<=xEndDate)
										{
											If '$d(^TMP(ZIndex,JIndex,NIndex,xLocID,xMonth,"UCDays",AimRepID,xIntuDate))
											{
												Set num=$i(^TMP(ZIndex,JIndex,NIndex,xLocID,xMonth,"UCDays"))   //插管日数
												Set ^TMP(ZIndex,JIndex,NIndex,xLocID,xMonth,"UCDays",EpisodeID,xIntuDate)=""
											}
										}
									}
									Set InfDate=objAimRepSub.InfDate
									If InfDate'=""
									{
										If (InfDate>=xStartDate)&&(InfDate<=xEndDate)
										{
											Set sRepDate=objAimRepSub.RepDate
											//Continue:($p($zd(sRepDate,3),"-",1)_"年"_$p($zd(sRepDate,3),"-",2)_"月")'=xMonth
											Continue:($p($zd(InfDate,3),"-",1)_"年"_$p($zd(InfDate,3),"-",2)_"月")'=xMonth
											If '$d(^TMP(ZIndex,JIndex,NIndex,xLocID,xMonth,"UCInfNum",EpisodeID))
											{
												Set num=$i(^TMP(ZIndex,JIndex,NIndex,xLocID,xMonth,"UCInfNum"))  //感染例数
												Set ^TMP(ZIndex,JIndex,NIndex,xLocID,xMonth,"UCInfNum",EpisodeID)=""
											}
										}
									}
								}
							
								//中央导管
								Set SubID=0
								For {
									Set SubID=$o(^DHCMed.NINF("AimRep",AimRepID,"PICC",SubID))
									Quit:SubID=""
									Set AimRepSubID=AimRepID_"||"_SubID
									Set objAimRepSub=##class(DHCMed.NINF.Rep.AimReportPICC).GetObjById(AimRepSubID)
									Continue:'$IsObject(objAimRepSub)
									Set objRepStatus=objAimRepSub.RepStatus
									If $IsObject(objRepStatus) {
										Set RepStatusCode=objRepStatus.Code
										Continue:RepStatusCode="0"  //删除的报告不再显示
									}
									Set IntubateDate=objAimRepSub.IntubateDate
									Set ExtubateDate=objAimRepSub.ExtubateDate
									If ExtubateDate="" {
										If DischDate'="" {
											Set ExtubateDate=DischDate
										} Else {
											Set ExtubateDate=+$h
										}
									}
									For xIntuDate=IntubateDate:1:ExtubateDate
									{
										If (xIntuDate>=xStartDate)&&(xIntuDate<=xEndDate)
										{
											If '$d(^TMP(ZIndex,JIndex,NIndex,xLocID,xMonth,"PICCDays",AimRepID,xIntuDate))
											{
												Set num=$i(^TMP(ZIndex,JIndex,NIndex,xLocID,xMonth,"PICCDays"))   //插管日数
												Set ^TMP(ZIndex,JIndex,NIndex,xLocID,xMonth,"PICCDays",EpisodeID,xIntuDate)=""
											}
										}
									}
									Set InfDate=objAimRepSub.InfDate
									If InfDate'=""
									{
										If (InfDate>=xStartDate)&&(InfDate<=xEndDate)
										{
											Set sRepDate=objAimRepSub.RepDate
											//Continue:($p($zd(sRepDate,3),"-",1)_"年"_$p($zd(sRepDate,3),"-",2)_"月")'=xMonth
											Continue:($p($zd(InfDate,3),"-",1)_"年"_$p($zd(InfDate,3),"-",2)_"月")'=xMonth
											If '$d(^TMP(ZIndex,JIndex,NIndex,xLocID,xMonth,"PICCInfNum",EpisodeID))
											{
												Set num=$i(^TMP(ZIndex,JIndex,NIndex,xLocID,xMonth,"PICCInfNum"))  //感染例数
												Set ^TMP(ZIndex,JIndex,NIndex,xLocID,xMonth,"PICCInfNum",EpisodeID)=""
											}
										}
									}
								}
							
								//呼吸机
								Set SubID=0
								For {
									Set SubID=$o(^DHCMed.NINF("AimRep",AimRepID,"VAP",SubID))
									Quit:SubID=""
									Set AimRepSubID=AimRepID_"||"_SubID
									Set objAimRepSub=##class(DHCMed.NINF.Rep.AimReportVAP).GetObjById(AimRepSubID)
									Continue:'$IsObject(objAimRepSub)
									Set objRepStatus=objAimRepSub.RepStatus
									If $IsObject(objRepStatus) {
										Set RepStatusCode=objRepStatus.Code
										Continue:RepStatusCode="0"  //删除的报告不再显示
									}
									Set IntubateDate=objAimRepSub.IntubateDate
									Set ExtubateDate=objAimRepSub.ExtubateDate
									If ExtubateDate="" {
										If DischDate'="" {
											Set ExtubateDate=DischDate
										} Else {
											Set ExtubateDate=+$h
										}
									}
									For xIntuDate=IntubateDate:1:ExtubateDate
									{
										If (xIntuDate>=xStartDate)&&(xIntuDate<=xEndDate)
										{
											If '$d(^TMP(ZIndex,JIndex,NIndex,xLocID,xMonth,"VAPDays",AimRepID,xIntuDate))
											{
												Set num=$i(^TMP(ZIndex,JIndex,NIndex,xLocID,xMonth,"VAPDays"))   //插管日数
												Set ^TMP(ZIndex,JIndex,NIndex,xLocID,xMonth,"VAPDays",EpisodeID,xIntuDate)=""
											}
										}
									}
									Set InfDate=objAimRepSub.InfDate
									If InfDate'=""
									{
										If (InfDate>=xStartDate)&&(InfDate<=xEndDate)
										{
											Set sRepDate=objAimRepSub.RepDate
											//Continue:($p($zd(sRepDate,3),"-",1)_"年"_$p($zd(sRepDate,3),"-",2)_"月")'=xMonth
										
											Continue:($p($zd(InfDate,3),"-",1)_"年"_$p($zd(InfDate,3),"-",2)_"月")'=xMonth
										
											If '$d(^TMP(ZIndex,JIndex,NIndex,xLocID,xMonth,"VAPInfNum",EpisodeID))
											{
												Set num=$i(^TMP(ZIndex,JIndex,NIndex,xLocID,xMonth,"VAPInfNum"))  //感染例数
												Set ^TMP(ZIndex,JIndex,NIndex,xLocID,xMonth,"VAPInfNum",EpisodeID)=""
											}
										}
									}
								}
							
								//手术部位
								Set SubID=0
								For {
									Set SubID=$o(^DHCMed.NINF("AimRep",AimRepID,"OPR",SubID))
									Quit:SubID=""
									Set AimRepSubID=AimRepID_"||"_SubID
									Set objAimRepSub=##class(DHCMed.NINF.Rep.AimReportOPR).GetObjById(AimRepSubID)
									Continue:'$IsObject(objAimRepSub)
									Set objRepStatus=objAimRepSub.RepStatus
									If $IsObject(objRepStatus) {
										Set RepStatusCode=objRepStatus.Code
										Continue:RepStatusCode="0"  //删除的报告不再显示
									}
								
									Set OperDate=objAimRepSub.OperStartDate
									Continue:OperDate=""
									If (OperDate>=xStartDate)&&(OperDate<=xEndDate)
									{
										Set num=$i(^TMP(ZIndex,JIndex,NIndex,xLocID,xMonth,"OPRNum"))  //手术例数
										Set ^TMP(ZIndex,JIndex,NIndex,xLocID,xMonth,"OPRNum",EpisodeID)=""
									}
									Set InfDate=objAimRepSub.InfDate
									If InfDate'=""
									{
										If (InfDate>=xStartDate)&&(InfDate<=xEndDate)
										{
											Set sRepDate=objAimRepSub.RepDate
										
											//Continue:($p($zd(sRepDate,3),"-",1)_"年"_$p($zd(sRepDate,3),"-",2)_"月")'=xMonth
											Continue:($p($zd(InfDate,3),"-",1)_"年"_$p($zd(InfDate,3),"-",2)_"月")'=xMonth
											Set num=$i(^TMP(ZIndex,JIndex,NIndex,xLocID,xMonth,"OPRInfNum"))  //感染例数
										
											Set ^TMP(ZIndex,JIndex,NIndex,xLocID,xMonth,"OPRInfNum",EpisodeID)=""
										}
									}
								}
							}
						}
					}
				}
			}
		}
	}
	
	Set xLocID=0
	For {
		Set xLocID=$o(^TMP(ZIndex,JIndex,NIndex,xLocID))
		Quit:xLocID=""
		
		Set LocDesc=$p($g(^CTLOC(+xLocID)),"^",2)
		Set:$p(LocDesc,"-",2)'="" LocDesc=$p(LocDesc,"-",2)
		Continue:LocDesc=""
		
		Set xMonth=""
		For {
			Set xMonth=$o(^TMP(ZIndex,JIndex,NIndex,xLocID,xMonth))
			Quit:xMonth=""
			
			Set (UCRatio,PICCRatio,VAPRatio,UCInfRatio,PICCInfRatio,VAPInfRatio)="0.00‰"
			Set (OPRInfRatio)="0.00%"
			
			//插管日数+使用率 VAPDays-插管日数 PICCDays-中央导管日数 UCDays-导尿管日数 IPNum-住院例数 VAP-呼吸机
			Set IPDays=+$g(^TMP(ZIndex,JIndex,NIndex,xLocID,xMonth,"IPDays"))
			Set UCDays=+$g(^TMP(ZIndex,JIndex,NIndex,xLocID,xMonth,"UCDays"))
			Set PICCDays=+$g(^TMP(ZIndex,JIndex,NIndex,xLocID,xMonth,"PICCDays"))
			Set VAPDays=+$g(^TMP(ZIndex,JIndex,NIndex,xLocID,xMonth,"VAPDays"))
			Set OPRNum=+$g(^TMP(ZIndex,JIndex,NIndex,xLocID,xMonth,"OPRNum"))
			//update by lyh 2013-03-08 协和感染科要求
			//院感监测统计表中尿管日数、导管日数、呼吸机日数、
			//手术台数、住院日数从各科上报的院感监测月报表中取数据，不用再去计算了
			
			Set Score0=+$g(^TMP(ZIndex,JIndex,NIndex,xLocID,xMonth,"Score0"))
			Set Score1=+$g(^TMP(ZIndex,JIndex,NIndex,xLocID,xMonth,"Score1"))
			Set Score2=+$g(^TMP(ZIndex,JIndex,NIndex,xLocID,xMonth,"Score2"))
			Set Score3=+$g(^TMP(ZIndex,JIndex,NIndex,xLocID,xMonth,"Score3"))
			
			Set Inf0=+$g(^TMP(ZIndex,JIndex,NIndex,xLocID,xMonth,"Inf0"))
			Set Inf1=+$g(^TMP(ZIndex,JIndex,NIndex,xLocID,xMonth,"Inf1"))
			Set Inf2=+$g(^TMP(ZIndex,JIndex,NIndex,xLocID,xMonth,"Inf2"))
			Set Inf3=+$g(^TMP(ZIndex,JIndex,NIndex,xLocID,xMonth,"Inf3"))
			
			Set (Inf0Rate,Inf1Rate,Inf2Rate,Inf3Rate)=""
			Set:(Score0>0)&&(Inf0>0) Inf0Rate=$fn((Inf0/Score0)*100,"",2)_"%"
			Set:(Score1>0)&&(Inf1>0) Inf1Rate=$fn((Inf1/Score1)*100,"",2)_"%"
			Set:(Score2>0)&&(Inf2>0) Inf2Rate=$fn((Inf2/Score2)*100,"",2)_"%"
			Set:(Score3>0)&&(Inf3>0) Inf3Rate=$fn((Inf3/Score3)*100,"",2)_"%"
			
			Set aMonthFrom=$tr($tr(xMonth,"年","-"),"月","")
			Set ret=..GetInPatNums(aMonthFrom,aMonthFrom,xLocID)
			
			Set:$p(ret,"^",1)'=0 IPDays=$p(ret,"^",1)
			Set:$p(ret,"^",2)'=0 UCDays=$p(ret,"^",2)
			Set:$p(ret,"^",3)'=0 PICCDays=$p(ret,"^",3)
			Set:$p(ret,"^",4)'=0 VAPDays=$p(ret,"^",4)
			Set:$p(ret,"^",5)'=0 OPRNum=$p(ret,"^",5)
			
			If IPDays'=0 {
				Set UCRatio=$fn((UCDays/IPDays),"",2)
			 	Set PICCRatio=$fn((PICCDays/IPDays),"",2)
			 	Set VAPRatio=$fn((VAPDays/IPDays),"",2)
			}
			
			//感染例次数+感染率
			Set IPNum=+$g(^TMP(ZIndex,JIndex,NIndex,xLocID,xMonth,"IPNum"))
			Set UCInfNum=+$g(^TMP(ZIndex,JIndex,NIndex,xLocID,xMonth,"UCInfNum"))
			Set PICCInfNum=+$g(^TMP(ZIndex,JIndex,NIndex,xLocID,xMonth,"PICCInfNum"))
			Set VAPInfNum=+$g(^TMP(ZIndex,JIndex,NIndex,xLocID,xMonth,"VAPInfNum"))
			If UCDays'=0 {
				Set UCInfRatio=$fn((UCInfNum/UCDays)*1000,"",2)_"‰"
			}
			If PICCDays'=0 {
			 	Set PICCInfRatio=$fn((PICCInfNum/PICCDays)*1000,"",2)_"‰"
			}
			If VAPDays'=0 {
			 	Set VAPInfRatio=$fn((VAPInfNum/VAPDays)*1000,"",2)_"‰"
			}
			
			//手术例次,感染例次,感染率
			//Set OPRNum=+$g(^TMP(ZIndex,JIndex,NIndex,xLocID,xMonth,"OPRNum"))
			Set OPRInfNum=+$g(^TMP(ZIndex,JIndex,NIndex,xLocID,xMonth,"OPRInfNum"))
			If OPRNum'=0 {
				Set OPRInfRatio=$fn((OPRInfNum/OPRNum)*100,"",2)_"%"
			}
			
		 	Set (UCInfPats,PICCInfPats,VAPInfPats,OPRInfPats)=""
		 	//导尿管 感染患者信息
		 	Set xPaadm=0
		 	For {
				Set xPaadm=$o(^TMP(ZIndex,JIndex,NIndex,xLocID,xMonth,"UCInfNum",xPaadm))
				Quit:xPaadm=""
				Set UCInfPat=..GetPatInfoByPaadm(xPaadm)
				Set UCInfPats=UCInfPats_UCInfPat_";<Br>"
			}
			//中央导管 感染患者信息
			Set xPaadm=0
		 	For {
				Set xPaadm=$o(^TMP(ZIndex,JIndex,NIndex,xLocID,xMonth,"PICCInfNum",xPaadm))
				Quit:xPaadm=""
				Set PICCInfPat=..GetPatInfoByPaadm(xPaadm)
				Set PICCInfPats=PICCInfPats_PICCInfPat_";<Br>"
			}
			//呼吸机 感染患者信息
			Set xPaadm=0
		 	For {
				Set xPaadm=$o(^TMP(ZIndex,JIndex,NIndex,xLocID,xMonth,"VAPInfNum",xPaadm))
				Quit:xPaadm=""
				Set VAPInfPat=..GetPatInfoByPaadm(xPaadm)
				Set VAPInfPats=VAPInfPats_VAPInfPat_";"
			}
			//手术部位 感染患者信息
			Set xPaadm=0
		 	For {
				Set xPaadm=$o(^TMP(ZIndex,JIndex,NIndex,xLocID,xMonth,"OPRInfNum",xPaadm))
				Quit:xPaadm=""
				Set OPRInfPat=..GetPatInfoByPaadm(xPaadm)
				Set OPRInfPats=OPRInfPats_OPRInfPat_";<Br>"
			}
			
			Set aMonthFrom=$tr($tr(xMonth,"年","-"),"月","")
			
			//感染人数
			//Set InfNums=+$g(^TMP(ZIndex,JIndex,NIndex,xLocID,xMonth,"InfPatNum"))
			//感染例数
			Set InfNums=+$g(^TMP(ZIndex,JIndex,NIndex,xLocID,xMonth,"InfNum"))
			
			Set InfRatio="0.00‰"
			Set:(IPNum>0)&&(InfNums>0) InfRatio=$fn((InfNums/IPNum)*100,"",2)_"%"
			Set Data=$lb(ind,LocDesc,xMonth,IPDays,IPNum)
			Set Data=Data_$lb(UCDays,UCRatio,UCInfNum,UCInfRatio,UCInfPats)
			Set Data=Data_$lb(PICCDays,PICCRatio,PICCInfNum,PICCInfRatio,PICCInfPats)
			Set Data=Data_$lb(VAPDays,VAPRatio,VAPInfNum,VAPInfRatio,VAPInfPats)
			Set Data=Data_$lb(OPRNum,OPRInfNum,OPRInfRatio,OPRInfPats,InfNums,InfRatio,xLocID)
			Set Data=Data_$lb(Score0,Score1,Score2,Score3,Inf0Rate,Inf1Rate,Inf2Rate,Inf3Rate)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Kill ^TMP(ZIndex,JIndex,NIndex)
 	
	Quit $$$OK
}

ClassMethod QryByMonthLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryByMonthLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryByMonthLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryByMonthLocExecute ]
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

/// w ##class(DHCMed.InfAimService.BaseSrv).GetPatInfoByPaadm(1)
ClassMethod GetPatInfoByPaadm(aPaadm As %String) As %String
{
	n (aPaadm)
	
	s ret=""
	q:aPaadm="" ret
	
	s AdmObj=##class(DHCMed.Base.PatientAdm).GetObjById(aPaadm)
	q:'$IsObject(AdmObj) ret
	s AdmDate=AdmObj.AdmitDate	
	s Ward=AdmObj.Ward
	s:Ward["-" Ward=$p(Ward,"-",2)
	s Bed=AdmObj.Bed
	s PatientID=AdmObj.PatientID
	
	q:PatientID="" ret
	s PatObj=##class(DHCMed.Base.Patient).GetObjById(PatientID)
	q:'$IsObject(PatObj)
	s PatientName=PatObj.PatientName
	s Sex=PatObj.Sex
	s Age=PatObj.Age
	s PapmiNo=PatObj.PapmiNo
	s InPatientMrNo=PatObj.InPatientMrNo
	
	s ret="姓名:"_PatientName_" 病历号："_InPatientMrNo			//" 登记号:"_PapmiNo_" 就诊日期:"_AdmDate_" 病区:"_Ward_" 床号:"_Bed
	
	q ret
}

}
