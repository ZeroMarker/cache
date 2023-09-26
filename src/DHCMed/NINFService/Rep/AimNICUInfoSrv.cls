/// 名称: DHCMed.NINFService.Rep.AimNICUInfoSrv
/// 描述: NICU信息查询汇总
/// 编写者：zhufei
/// 编写日期: 2012-06-16
Class DHCMed.NINFService.Rep.AimNICUInfoSrv Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liuyh
/// CreatDate：   2011-11-10
/// Description:  查询NICU相关报告表信息
/// Modify by wuqk 2012-1-18
///  1、修改各感染率算法
///  2、修改Pts数值的取法
/// Do ##class(%ResultSet).RunQuery("DHCMed.NINFService.Rep.AimNICUInfoSrv","QryByMonthLoc","2012-06","","W")
Query QryByMonthLoc(aMonth As %String, aLocID As %String, aTransType As %String) As %Query(ROWSPEC = "ind:%String,i:%String,BW1Num:%String,BW2Num:%String,BW3Num:%String,BW4Num:%String,BWU1:%String,BWP1:%String,BWV1:%String,BWU2:%String,BWP2:%String,BWV2:%String,BWU3:%String,BWP3:%String,BWV3:%String,BWU4:%String,BWP4:%String,BWV4:%String,TotalNum:%String")
{
}

ClassMethod QryByMonthLocExecute(ByRef qHandle As %Binary, aMonth As %String, aLocID As %String, aTransType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:aMonth="" $$$OK
	Set xStartDate=$zdh(aMonth_"-01",3)
	Set xEndDate=$zd(xStartDate+32,3)
	Set xEndDate=$p(xEndDate,"-",1)_"-"_$p(xEndDate,"-",2)_"-01"
	Set xEndDate=$zdh(xEndDate,3)-1
	
	Set RepTypeID=""
	Set objRepType=##Class(DHCMed.SS.Dictionary).GetByTypeCode("NINFAimReportType","NICU","")
	If $IsObject(objRepType) {
		Set RepTypeID=objRepType.%Id()
	}
	Quit:RepTypeID="" $$$OK
	
	Set ZIndex=$zn,JIndex=$j,NIndex="QryByMonthLoc"
 	Kill ^TMP(ZIndex,JIndex,NIndex)
 	
 	Set xLocID=0
 	For {
	 	Set xLocID=$o(^DHCMed.CC.CtlResultI("AdmTrans",0,"Day","IndexLocDate",xLocID))
	 	Quit:xLocID=""
	 	Continue:(aLocID'="")&&(aLocID'=xLocID)
	 	Set xDate=xStartDate-1
	 	For {
		 	Set xDate=$o(^DHCMed.CC.CtlResultI("AdmTrans",0,"Day","IndexLocDate",xLocID,xDate))
		 	Quit:xDate=""
		 	Quit:xDate>xEndDate
		 	
		 	Set xAdmTransID=0
		 	For {
				Set xAdmTransID=$o(^DHCMed.CC.CtlResultI("AdmTrans",0,"Day","IndexLocDate",xLocID,xDate,xAdmTransID))
				Quit:xAdmTransID=""
				
				Set objAdmTrans=##class(DHCMed.CC.CtlAdmTrans).GetObjById(xAdmTransID)
				Continue:'$IsObject(objAdmTrans)
				Continue:objAdmTrans.TransType'=aTransType
				Set EpisodeID=objAdmTrans.EpisodeID
				Set TransID=objAdmTrans.TransID
				
				Set xRepID=0
				For {
					Set xRepID=$o(^DHCMed.NINFi("AimRep",0,"IndexTypeAdmTrans",RepTypeID,EpisodeID,EpisodeID_"||"_TransID,xRepID))
					Quit:xRepID=""
					
					Set objRep=##class(DHCMed.NINF.Rep.AimReport).GetObjById(xRepID)
					Continue:objRep=""
					Set TransLoc=objRep.TransLoc
					Continue:(aLocID'="")&&(aLocID'=TransLoc)
					
					Set BornWeight=objRep.BornWeight
					Set BornWeight=+BornWeight
					
					//Pts取NICU目标监测报告总数
					If BornWeight>2500 {
						Set num=$i(^TMP(ZIndex,JIndex,NIndex,xDate,"BW4Num"))
					} ElseIf (BornWeight>1500) {
						Set num=$i(^TMP(ZIndex,JIndex,NIndex,xDate,"BW3Num"))
					} ElseIf (BornWeight>1000) {
						Set num=$i(^TMP(ZIndex,JIndex,NIndex,xDate,"BW2Num"))
					} Else {
						Set num=$i(^TMP(ZIndex,JIndex,NIndex,xDate,"BW1Num"))
					}
					
					Continue:$d(^TMP(ZIndex,JIndex,NIndex,0,"BWAdm",xRepID))
					Set ^TMP(ZIndex,JIndex,NIndex,0,"BWAdm",xRepID)=""
					
					//脐静脉
					Set xSubID=0
					For {
						Set xSubID=$o(^DHCMed.NINF("AimRep",xRepID,"NUC",xSubID))
						Quit:xSubID=""
						Set objAimRepSub=##class(DHCMed.NINF.Rep.AimReportNUC).GetObjById(xRepID_"||"_xSubID)
						Continue:'$IsObject(objAimRepSub)
						Set objRepStatus=objAimRepSub.RepStatus
						If $IsObject(objRepStatus) {
							Set RepStatusCode=objRepStatus.Code
							Continue:RepStatusCode="0"  //删除的报告不再显示
						}
						Set IntubateDate=objAimRepSub.IntubateDate
						Set ExtubateDate=objAimRepSub.ExtubateDate
						Set:ExtubateDate="" ExtubateDate=+$h
						For xIntuDate=IntubateDate:1:ExtubateDate
						{
							Continue:(xIntuDate<xStartDate)||(xIntuDate>xEndDate)
							If BornWeight>2500 {
								Set num=$i(^TMP(ZIndex,JIndex,NIndex,xIntuDate,"BWU4"))
							} ElseIf (BornWeight>1500) {
								Set num=$i(^TMP(ZIndex,JIndex,NIndex,xIntuDate,"BWU3"))
							} ElseIf (BornWeight>1000) {
								Set num=$i(^TMP(ZIndex,JIndex,NIndex,xIntuDate,"BWU2"))
							} Else {
								Set num=$i(^TMP(ZIndex,JIndex,NIndex,xIntuDate,"BWU1"))
							}
						}
					}
					//中央导管
					Set xSubID=0
					For {
						Set xSubID=$o(^DHCMed.NINF("AimRep",xRepID,"NPICC",xSubID))
						Quit:xSubID=""
						Set objAimRepSub=##class(DHCMed.NINF.Rep.AimReportNPICC).GetObjById(xRepID_"||"_xSubID)
						Continue:'$IsObject(objAimRepSub)
						Set objRepStatus=objAimRepSub.RepStatus
						If $IsObject(objRepStatus) {
							Set RepStatusCode=objRepStatus.Code
							Continue:RepStatusCode="0"  //删除的报告不再显示
						}
						Set IntubateDate=objAimRepSub.IntubateDate
						Set ExtubateDate=objAimRepSub.ExtubateDate
						Set:ExtubateDate="" ExtubateDate=+$h
						For xIntuDate=IntubateDate:1:ExtubateDate
						{
							Continue:(xIntuDate<xStartDate)||(xIntuDate>xEndDate)
							If BornWeight>2500 {
								Set num=$i(^TMP(ZIndex,JIndex,NIndex,xIntuDate,"BWP4"))
							} ElseIf (BornWeight>1500) {
								Set num=$i(^TMP(ZIndex,JIndex,NIndex,xIntuDate,"BWP3"))
							} ElseIf (BornWeight>1000) {
								Set num=$i(^TMP(ZIndex,JIndex,NIndex,xIntuDate,"BWP2"))
							} Else {
								Set num=$i(^TMP(ZIndex,JIndex,NIndex,xIntuDate,"BWP1"))
							}
						}
					}
					//气管插管
					Set xSubID=0
					For {
						Set xSubID=$o(^DHCMed.NINF("AimRep",xRepID,"NVNT",xSubID))
						Quit:xSubID=""
						Set objAimRepSub=##class(DHCMed.NINF.Rep.AimReportNVNT).GetObjById(xRepID_"||"_xSubID)
						Continue:'$IsObject(objAimRepSub)
						Set objRepStatus=objAimRepSub.RepStatus
						If $IsObject(objRepStatus) {
							Set RepStatusCode=objRepStatus.Code
							Continue:RepStatusCode="0"  //删除的报告不再显示
						}
						Set IntubateDate=objAimRepSub.IntubateDate
						Set ExtubateDate=objAimRepSub.ExtubateDate
						Set:ExtubateDate="" ExtubateDate=+$h
						For xIntuDate=IntubateDate:1:ExtubateDate
						{
							Continue:(xIntuDate<xStartDate)||(xIntuDate>xEndDate)
							If BornWeight>2500 {
								Set num=$i(^TMP(ZIndex,JIndex,NIndex,xIntuDate,"BWV4"))
							} ElseIf (BornWeight>1500) {
								Set num=$i(^TMP(ZIndex,JIndex,NIndex,xIntuDate,"BWV3"))
							} ElseIf (BornWeight>1000) {
								Set num=$i(^TMP(ZIndex,JIndex,NIndex,xIntuDate,"BWV2"))
							} Else {
								Set num=$i(^TMP(ZIndex,JIndex,NIndex,xIntuDate,"BWV1"))
							}
						}
					}
				}
		 	}
	 	}
 	}
 	
	//日志
	For xDate=xStartDate:1:xEndDate
	{
		Set (BW1Num,BW2Num,BW3Num,BW4Num,BWU1,BWP1,BWV1,BWU2,BWP2,BWV2,BWU3,BWP3,BWV3,BWU4,BWP4,BWV4,TotalNum)=0
		
		Set BW1Num=+$g(^TMP(ZIndex,JIndex,NIndex,xDate,"BW1Num"))
		Set BWU1=+$g(^TMP(ZIndex,JIndex,NIndex,xDate,"BWU1"))
		Set BWP1=+$g(^TMP(ZIndex,JIndex,NIndex,xDate,"BWP1"))
		Set BWV1=+$g(^TMP(ZIndex,JIndex,NIndex,xDate,"BWV1"))
		
		Set BW2Num=+$g(^TMP(ZIndex,JIndex,NIndex,xDate,"BW2Num"))
		Set BWU2=+$g(^TMP(ZIndex,JIndex,NIndex,xDate,"BWU2"))
		Set BWP2=+$g(^TMP(ZIndex,JIndex,NIndex,xDate,"BWP2"))
		Set BWV2=+$g(^TMP(ZIndex,JIndex,NIndex,xDate,"BWV2"))
		
		Set BW3Num=+$g(^TMP(ZIndex,JIndex,NIndex,xDate,"BW3Num"))
		Set BWU3=+$g(^TMP(ZIndex,JIndex,NIndex,xDate,"BWU3"))
		Set BWP3=+$g(^TMP(ZIndex,JIndex,NIndex,xDate,"BWP3"))
		Set BWV3=+$g(^TMP(ZIndex,JIndex,NIndex,xDate,"BWV3"))
		
		Set BW4Num=+$g(^TMP(ZIndex,JIndex,NIndex,xDate,"BW4Num"))
		Set BWU4=+$g(^TMP(ZIndex,JIndex,NIndex,xDate,"BWU4"))
		Set BWP4=+$g(^TMP(ZIndex,JIndex,NIndex,xDate,"BWP4"))
		Set BWV4=+$g(^TMP(ZIndex,JIndex,NIndex,xDate,"BWV4"))
		
		Set TotalNum=BW1Num+BW2Num+BW3Num+BW4Num
		Set Data=$lb(ind,$p($zd(xDate,3),"-",3),BW1Num,BW2Num,BW3Num,BW4Num,BWU1,BWP1,BWV1,BWU2,BWP2,BWV2,BWU3,BWP3,BWV3,BWU4,BWP4,BWV4,TotalNum)
	 	Set flg=$$OutputRow()
	}
	
	Set RowTitle="总"
	Set ret=$$GetTotalNum()
	
	//Set RowTitle="UC使用率"
	//Set ret=$$GetUCTotalNum()
	
	//Set RowTitle="picc使用率"
	//Set ret=$$GetPipeTotalNum()
	
	//Set RowTitle="呼吸机使用率"
	//Set ret=$$GetVenTotalNum()
	
	Set TotalBWNum=TotalBW1+TotalBW2+TotalBW3+TotalBW4  //脐静脉日数
 	Set TotalBWUNum=TotalBWU1+TotalBWU2+TotalBWU3+TotalBWU4  //脐静脉日数
	Set TotalBWPNum=TotalBWP1+TotalBWP2+TotalBWP3+TotalBWP4  //PICC日数
	Set TotalBWVNum=TotalBWV1+TotalBWV2+TotalBWV3+TotalBWV4  //有创通气日数
	
	Set Year=+aMonth
	Set Month=+$p(aMonth,"-",2)
	
	Set RowTitle="实验室确证血流感染<br>(非导管相关)"
	Set lb4=..GetNICURepDiagInfo(Year,Month,4)
	
 	Set RowTitle="临床脓毒症"
	Set lb1=..GetNICURepDiagInfo(Year,Month,1)
	
 	Set RowTitle="脐静脉置管相关性<br>血流感染"
	Set lb2=..GetNICURepDiagInfo(Year,Month,2)
	
 	Set RowTitle="CRBSI感染率-UC"
 	Set (TotalUC1,TotalUC2,TotalUC3,TotalUC4,TotalUC)=""
	Set:TotalBWU1>0 TotalUC1=$fn(TotalLab1/TotalBWU1,"",3)*1000_"‰"
	Set:TotalBWU2>0 TotalUC2=$fn(TotalLab2/TotalBWU2,"",3)*1000_"‰"
	Set:TotalBWU3>0 TotalUC3=$fn(TotalLab3/TotalBWU3,"",3)*1000_"‰"
	Set:TotalBWU4>0 TotalUC4=$fn(TotalLab4/TotalBWU4,"",3)*1000_"‰"
	Set:TotalBWUNum>0 TotalUC=$fn(TotalLabNum/TotalBWUNum,"",3)*1000_"‰"
	Set Data=$lb(ind,RowTitle,TotalUC1,TotalUC2,TotalUC3,TotalUC4,"","","","","","","","","","","","",TotalUC)
 	Set ret=$$OutputRow()
 	
 	Set RowTitle="PICC置管相关性<br>血流感染"
	Set lb3=..GetNICURepDiagInfo(Year,Month,3)
	
 	Set RowTitle="CRBSI感染率-PICC"
 	Set (TotalUC1,TotalUC2,TotalUC3,TotalUC4,TotalUC)=""
	Set:TotalBWP1>0 TotalUC1=$fn(TotalLab1/TotalBWP1,"",3)*1000_"‰"
	Set:TotalBWP2>0 TotalUC2=$fn(TotalLab2/TotalBWP2,"",3)*1000_"‰"
	Set:TotalBWP3>0 TotalUC3=$fn(TotalLab3/TotalBWP3,"",3)*1000_"‰"
	Set:TotalBWP4>0 TotalUC4=$fn(TotalLab4/TotalBWP4,"",3)*1000_"‰"
	Set:TotalBWPNum>0 TotalUC=$fn(TotalLabNum/TotalBWPNum,"",3)*1000_"‰"
	Set Data=$lb(ind,RowTitle,TotalUC1,TotalUC2,TotalUC3,TotalUC4,"","","","","","","","","","","","",TotalUC)
 	Set ret=$$OutputRow()
 	
 	Set RowTitle="新生儿感染"
	Set lb8=..GetNICURepDiagInfo(Year,Month,8)
	
 	Set RowTitle="新生儿肺炎"
	Set lb5=..GetNICURepDiagInfo(Year,Month,5)
	
	Set RowTitle="呼吸机相关性感染"
	Set lb6=..GetNICURepDiagInfo(Year,Month,6)
	
 	Set RowTitle="VAP感染率"
 	Set (TotalUC1,TotalUC2,TotalUC3,TotalUC4,TotalUC)=""
	Set:TotalBWV1>0 TotalUC1=$fn(TotalLab1/TotalBWV1,"",3)*1000_"‰"
	Set:TotalBWV2>0 TotalUC2=$fn(TotalLab2/TotalBWV2,"",3)*1000_"‰"
	Set:TotalBWV3>0 TotalUC3=$fn(TotalLab3/TotalBWV3,"",3)*1000_"‰"
	Set:TotalBWV4>0 TotalUC4=$fn(TotalLab4/TotalBWV4,"",3)*1000_"‰"
	Set:TotalBWVNum>0 TotalUC=$fn(TotalLabNum/TotalBWVNum,"",3)*1000_"‰"
	Set Data=$lb(ind,RowTitle,TotalUC1,TotalUC2,TotalUC3,TotalUC4,"","","","","","","","","","","","",TotalUC)
 	Set ret=$$OutputRow()
 	
	Set RowTitle="每千个住院日感染率<br>(例次感染率)"
	Set ret=$$GetInHospInfTotalNum()
	
	Set RowTitle="每千个住院日血流感染率<br>(例次感染率，包括临床脓毒症)"
	Set ret=$$GetInHospBloodInfTotalNum()
	
	Set RowTitle="每千个住院日LCBI感染率<br>(例次感染率)"
	Set ret=$$GetInHospLCBIInfTotalNum()
	
	Set RowTitle="每千个住院日肺炎发生率<br>(例次感染率)"
	Set ret=$$GetInHospFYInfTotalNum()
	
	Kill ^TMP(ZIndex,JIndex,NIndex)
	
	Quit $$$OK
	
GetTotalNum()
	Set (TotalBW1,TotalBW2,TotalBW3,TotalBW4,TotalBWU1,TotalBWP1,TotalBWV1,TotalBWU2,TotalBWP2,TotalBWV2,TotalBWU3,TotalBWP3,TotalBWV3,TotalBWU4,TotalBWP4,TotalBWV4)=0
	For xDate=xStartDate:1:xEndDate  {
		Set TotalBW1=TotalBW1+$g(^TMP(ZIndex,JIndex,NIndex,xDate,"BW1Num"))
		Set TotalBWU1=TotalBWU1+$g(^TMP(ZIndex,JIndex,NIndex,xDate,"BWU1"))
		Set TotalBWP1=TotalBWP1+$g(^TMP(ZIndex,JIndex,NIndex,xDate,"BWP1"))
		Set TotalBWV1=TotalBWV1+$g(^TMP(ZIndex,JIndex,NIndex,xDate,"BWV1"))
		
		Set TotalBW2=TotalBW2+$g(^TMP(ZIndex,JIndex,NIndex,xDate,"BW2Num"))
		Set TotalBWU2=TotalBWU2+$g(^TMP(ZIndex,JIndex,NIndex,xDate,"BWU2"))
		Set TotalBWP2=TotalBWP2+$g(^TMP(ZIndex,JIndex,NIndex,xDate,"BWP2"))
		Set TotalBWV2=TotalBWV2+$g(^TMP(ZIndex,JIndex,NIndex,xDate,"BWV2"))
		
		Set TotalBW3=TotalBW3+$g(^TMP(ZIndex,JIndex,NIndex,xDate,"BW3Num"))
		Set TotalBWU3=TotalBWU3+$g(^TMP(ZIndex,JIndex,NIndex,xDate,"BWU3"))
		Set TotalBWP3=TotalBWP3+$g(^TMP(ZIndex,JIndex,NIndex,xDate,"BWP3"))
		Set TotalBWV3=TotalBWV3+$g(^TMP(ZIndex,JIndex,NIndex,xDate,"BWV3"))
		
		Set TotalBW4=TotalBW4+$g(^TMP(ZIndex,JIndex,NIndex,xDate,"BW4Num"))
		Set TotalBWU4=TotalBWU4+$g(^TMP(ZIndex,JIndex,NIndex,xDate,"BWU4"))
		Set TotalBWP4=TotalBWP4+$g(^TMP(ZIndex,JIndex,NIndex,xDate,"BWP4"))
		Set TotalBWV4=TotalBWV4+$g(^TMP(ZIndex,JIndex,NIndex,xDate,"BWV4"))
		
		Set TotalBWNum=TotalBW1+TotalBW2+TotalBW3+TotalBW4
	}
	Set Data=$lb(ind,RowTitle,TotalBW1,TotalBW2,TotalBW3,TotalBW4,TotalBWU1,TotalBWP1,TotalBWV1,TotalBWU2,TotalBWP2,TotalBWV2,TotalBWU3,TotalBWP3,TotalBWV3,TotalBWU4,TotalBWP4,TotalBWV4,TotalBWNum)
	Set ret=$$OutputRow()
	
	Set Data=$lb(ind,"","","","","","","","","","","","","","","","","","")
	Set flg=$$OutputRow()
	
	Set Data=$lb(ind,"床日数",TotalBW1,TotalBW2,TotalBW3,TotalBW4,"","","","","","","","","","","","","")
	Set flg=$$OutputRow()
	
	Set Data=$lb(ind,"脐静脉日数",TotalBWU1,TotalBWU2,TotalBWU3,TotalBWU4,"","","","","","","","","","","","","")
	Set flg=$$OutputRow()
	
	Set Data=$lb(ind,"PICC日数",TotalBWP1,TotalBWP2,TotalBWP3,TotalBWP4,"","","","","","","","","","","","","")
	Set flg=$$OutputRow()
	
	Set Data=$lb(ind,"有创通气日数",TotalBWV1,TotalBWV2,TotalBWV3,TotalBWV4,"","","","","","","","","","","","","")
	Set flg=$$OutputRow()
	
 	Quit 1

GetInHospInfTotalNum()
	//lb4 1 2 3 8 5 6
	//实验室确证血流感染（非导管相关）
	//临床脓毒症
	//脐静脉置管相关性血流感染
	//PICC置管相关性血流感染
	//新生儿感染
	//新生儿肺炎
	//呼吸机相关性感染
	
	Set TotalLab1=$li(lb4,1)+$li(lb1,1)+$li(lb2,1)+$li(lb3,1)+$li(lb8,1)+$li(lb5,1)+$li(lb6,1)
	Set TotalLab2=$li(lb4,2)+$li(lb1,2)+$li(lb2,2)+$li(lb3,2)+$li(lb8,2)+$li(lb5,2)+$li(lb6,2)
	Set TotalLab3=$li(lb4,3)+$li(lb1,3)+$li(lb2,3)+$li(lb3,3)+$li(lb8,3)+$li(lb5,3)+$li(lb6,3)
	Set TotalLab4=$li(lb4,4)+$li(lb1,4)+$li(lb2,4)+$li(lb3,4)+$li(lb8,4)+$li(lb5,4)+$li(lb6,4)
	Set TotalLabNum=TotalLab1+TotalLab2+TotalLab3+TotalLab4
	
	Set (TotalUC1,TotalUC2,TotalUC3,TotalUC4,TotalUC)=""
	Set:TotalBW1>0 TotalUC1=$fn(TotalLab1/TotalBW1,"",3)*1000_"‰"
	Set:TotalBW2>0 TotalUC2=$fn(TotalLab2/TotalBW2,"",3)*1000_"‰"
	Set:TotalBW3>0 TotalUC3=$fn(TotalLab3/TotalBW3,"",3)*1000_"‰"
	Set:TotalBW4>0 TotalUC4=$fn(TotalLab4/TotalBW4,"",3)*1000_"‰"
	Set:TotalBWNum>0 TotalUC=$fn(TotalLabNum/TotalBWNum,"",3)*1000_"‰"
	
	Set Data=$lb(ind,RowTitle,TotalUC1,TotalUC2,TotalUC3,TotalUC4,"","","","","","","","","","","","",TotalUC)
 	Set ret=$$OutputRow()
 	Quit 1
 	
GetInHospBloodInfTotalNum()
	//lb4 1 2 3 8 5 6
	//实验室确证血流感染（非导管相关）
	//临床脓毒症
	//脐静脉置管相关性血流感染
	//PICC置管相关性血流感染
	
	Set TotalLab1=$li(lb4,1)+$li(lb1,1)+$li(lb2,1)+$li(lb3,1)
	Set TotalLab2=$li(lb4,2)+$li(lb1,2)+$li(lb2,2)+$li(lb3,2)
	Set TotalLab3=$li(lb4,3)+$li(lb1,3)+$li(lb2,3)+$li(lb3,3)
	Set TotalLab4=$li(lb4,4)+$li(lb1,4)+$li(lb2,4)+$li(lb3,4)
	Set TotalLabNum=TotalLab1+TotalLab2+TotalLab3+TotalLab4
	
	Set (TotalUC1,TotalUC2,TotalUC3,TotalUC4,TotalUC)=""
	Set:TotalBW1>0 TotalUC1=$fn(TotalLab1/TotalBW1,"",3)*1000_"‰"
	Set:TotalBW2>0 TotalUC2=$fn(TotalLab2/TotalBW2,"",3)*1000_"‰"
	Set:TotalBW3>0 TotalUC3=$fn(TotalLab3/TotalBW3,"",3)*1000_"‰"
	Set:TotalBW4>0 TotalUC4=$fn(TotalLab4/TotalBW4,"",3)*1000_"‰"
	Set:TotalBWNum>0 TotalUC=$fn(TotalLabNum/TotalBWNum,"",3)*1000_"‰"
	
	Set Data=$lb(ind,RowTitle,TotalUC1,TotalUC2,TotalUC3,TotalUC4,"","","","","","","","","","","","",TotalUC)
 	Set ret=$$OutputRow()
 	Quit 1
 	
GetInHospLCBIInfTotalNum()
	//lb4 1 2 3 8 5 6
	//实验室确证血流感染（非导管相关）
	//脐静脉置管相关性血流感染
	//PICC置管相关性血流感染
	
	Set TotalLab1=$li(lb4,1)+$li(lb2,1)+$li(lb3,1)
	Set TotalLab2=$li(lb4,2)+$li(lb2,2)+$li(lb3,2)
	Set TotalLab3=$li(lb4,3)+$li(lb2,3)+$li(lb3,3)
	Set TotalLab4=$li(lb4,4)+$li(lb2,4)+$li(lb3,4)
	Set TotalLabNum=TotalLab1+TotalLab2+TotalLab3+TotalLab4
	
	Set (TotalUC1,TotalUC2,TotalUC3,TotalUC4,TotalUC)=""
	Set:TotalBW1>0 TotalUC1=$fn(TotalLab1/TotalBW1,"",3)*1000_"‰"
	Set:TotalBW2>0 TotalUC2=$fn(TotalLab2/TotalBW2,"",3)*1000_"‰"
	Set:TotalBW3>0 TotalUC3=$fn(TotalLab3/TotalBW3,"",3)*1000_"‰"
	Set:TotalBW4>0 TotalUC4=$fn(TotalLab4/TotalBW4,"",3)*1000_"‰"
	Set:TotalBWNum>0 TotalUC=$fn(TotalLabNum/TotalBWNum,"",3)*1000_"‰"
	
	Set Data=$lb(ind,RowTitle,TotalUC1,TotalUC2,TotalUC3,TotalUC4,"","","","","","","","","","","","",TotalUC)
 	Set ret=$$OutputRow()
 	Quit 1
 	
GetInHospFYInfTotalNum()
	//lb4 1 2 3 8 5 6
	//新生儿肺炎
	//呼吸机相关性感染
	Set TotalLab1=$li(lb5,1)+$li(lb6,1)
	Set TotalLab2=$li(lb5,2)+$li(lb6,2)
	Set TotalLab3=$li(lb5,3)+$li(lb6,3)
	Set TotalLab4=$li(lb5,4)+$li(lb6,4)
	Set TotalLabNum=TotalLab1+TotalLab2+TotalLab3+TotalLab4
	
	Set (TotalUC1,TotalUC2,TotalUC3,TotalUC4,TotalUC)=""
	Set:TotalBW1>0 TotalUC1=$fn(TotalLab1/TotalBW1,"",3)*1000_"‰"
	Set:TotalBW2>0 TotalUC2=$fn(TotalLab2/TotalBW2,"",3)*1000_"‰"
	Set:TotalBW3>0 TotalUC3=$fn(TotalLab3/TotalBW3,"",3)*1000_"‰"
	Set:TotalBW4>0 TotalUC4=$fn(TotalLab4/TotalBW4,"",3)*1000_"‰"
	Set:TotalBWNum>0 TotalUC=$fn(TotalLabNum/TotalBWNum,"",3)*1000_"‰"
	
	Set Data=$lb(ind,RowTitle,TotalUC1,TotalUC2,TotalUC3,TotalUC4,"","","","","","","","","","","","",TotalUC)
 	Set ret=$$OutputRow()
 	Quit 1	
 	
GetUCTotalNum()
	Set (TotalUC1,TotalUC2,TotalUC3,TotalUC4,TotalUC)=""
	Set TotalBWU=TotalBWU1+TotalBWU2+TotalBWU3+TotalBWU4
	Set:TotalBW1>0 TotalUC1=$fn(TotalBWU1/TotalBW1,"",3)*100_"%"
	Set:TotalBW2>0 TotalUC2=$fn(TotalBWU2/TotalBW2,"",3)*100_"%"
	Set:TotalBW3>0 TotalUC3=$fn(TotalBWU3/TotalBW3,"",3)*100_"%"
	Set:TotalBW4>0 TotalUC4=$fn(TotalBWU4/TotalBW4,"",3)*100_"%"
	Set:TotalBWNum>0 TotalUC=$fn(TotalBWU/TotalBWNum,"",3)*100_"%"
	
	Set Data=$lb(ind,RowTitle,TotalUC1,TotalUC2,TotalUC3,TotalUC4,"","","","","","","","","","","","",TotalUC)
 	Set ret=$$OutputRow()
 	Quit 1
 	
GetPipeTotalNum()
	Set (TotalUC1,TotalUC2,TotalUC3,TotalUC4,TotalUC)=""
	Set TotalBWP=TotalBWP1+TotalBWP2+TotalBWP3+TotalBWP4
	Set:TotalBW1>0 TotalUC1=$fn(TotalBWP1/TotalBW1,"",3)*100_"%"
	Set:TotalBW2>0 TotalUC2=$fn(TotalBWP2/TotalBW2,"",3)*100_"%"
	Set:TotalBW3>0 TotalUC3=$fn(TotalBWP3/TotalBW3,"",3)*100_"%"
	Set:TotalBW4>0 TotalUC4=$fn(TotalBWP4/TotalBW4,"",3)*100_"%"
	Set:TotalBWNum>0 TotalUC=$fn(TotalBWP/TotalBWNum,"",3)*100_"%"
	
	Set Data=$lb(ind,RowTitle,TotalUC1,TotalUC2,TotalUC3,TotalUC4,"","","","","","","","","","","","",TotalUC)
 	Set ret=$$OutputRow()
 	Quit 1
 	
GetVenTotalNum()
	Set (TotalUC1,TotalUC2,TotalUC3,TotalUC4,TotalUC)=""
	Set TotalBWV=TotalBWV1+TotalBWV2+TotalBWV3+TotalBWV4
	Set:TotalBW1>0 TotalUC1=$fn(TotalBWV1/TotalBW1,"",3)*100_"%"
	Set:TotalBW2>0 TotalUC2=$fn(TotalBWV2/TotalBW2,"",3)*100_"%"
	Set:TotalBW3>0 TotalUC3=$fn(TotalBWV3/TotalBW3,"",3)*100_"%"
	Set:TotalBW4>0 TotalUC4=$fn(TotalBWV4/TotalBW4,"",3)*100_"%"
	Set:TotalBWNum>0 TotalUC=$fn(TotalBWV/TotalBWNum,"",3)*100_"%"
	
	Set Data=$lb(ind,RowTitle,TotalUC1,TotalUC2,TotalUC3,TotalUC4,"","","","","","","","","","","","",TotalUC)
 	Set ret=$$OutputRow()
 	Quit 1
	
OutputRow()
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit 1
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
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	
	Quit $$$OK
}

/// 构造NICU感染报告诊断数据
ClassMethod GetNICURepDiagInfo(Year, Month, DiagCode)
{
	Set ret=..GetNICUInfRepDiagNum(Year,Month,DiagCode)
	Set TotalLabNum=TotalLab1+TotalLab2+TotalLab3+TotalLab4
	Set Data=$lb(ind,RowTitle,TotalLab1,TotalLab2,TotalLab3,TotalLab4,"","","","","","","","","","","","",TotalLabNum)
 	Set ^CacheTemp(repid,ind)=Data
   	Set ind=ind+1
 	Quit $lb(TotalLab1,TotalLab2,TotalLab3,TotalLab4)
}

/// 通过报告年、月、诊断Code、体重Code获取NICU院感报告相应诊断的数量
/// Modify by wuqk 2012-1-18
///  BorthWeightCode不需要输入
///  一次调用返回指定月份NICU报告中各个体重范围的该诊断数量
/// w ##class(DHCMed.InfAimService.NICUSrv).GetNICUInfRepDiagNum(2011,12,1,1)
ClassMethod GetNICUInfRepDiagNum(Year As %String, Month As %String, DiagCode As %String, BorthWeightCode As %String) As %String
{
	Set (TotalLab1,TotalLab2,TotalLab3,TotalLab4)=0
	Set ret=0
	Quit:(Year="")||(Month="") ret
	
	s rowid=""
	f  s rowid=$o(^DHCMed.INF.ReportI("Type"," 8",rowid)) q:rowid=""  d
	.s obj=##class(DHCMed.INF.Report).GetObjById(rowid)
	.q:'$IsObject(obj)
	.s StatusDr=obj.StatusDr
	.q:StatusDr=0 	//删除报告
	.s RepDate=obj.RepDate
	.q:RepDate=""
	.s RepDate=$zd(RepDate,3)
	.q:(+$p(RepDate,"-",1)'=+Year)||(+$p(RepDate,"-",2)'=+Month)   //modify by wuqk 2012-1-18
	.q:'$d(^DHCMed.INF.SummaryI("InfRepDr",rowid))
	.s SumID=$o(^DHCMed.INF.SummaryI("InfRepDr",rowid,""),-1)
	.q:SumID=""
	.s SumObj=##Class(DHCMed.INF.Summary).GetObjById(SumID)
	.q:'$IsObject(SumObj)
	.s BorthWeight=SumObj.BorthWeight
	.s PosID=""
	.f  s PosID=$o(^DHCMed.INF.RepPosI("InfRepDr",rowid,PosID)) q:PosID=""  d
	..s PosObj=##class(DHCMed.INF.RepPos).GetObjById(PosID)
	..q:'$IsObject(PosObj)
	..s InfDiagDR=PosObj.InfDiagDR
	..q:(DiagCode'="")&(DiagCode'=InfDiagDR)
	..s:BorthWeight=1 TotalLab1=TotalLab1+1
	..s:BorthWeight=2 TotalLab2=TotalLab1+1
	..s:BorthWeight=3 TotalLab3=TotalLab1+1
	..s:BorthWeight=4 TotalLab4=TotalLab1+1
	
	Quit ret
}

}
