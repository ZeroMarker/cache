/// 抗菌素使用情况
Class DHCMed.NINFService.Sta.AntiInfDrugSta Extends DHCMed.Abstract [ Not ProcedureBlock ]
{

ClassMethod CalcOrderNumber(repid, ArcimID, Paadm)
{
	n (repid, ArcimID, Paadm)
	s ArcimID=ArcimID_"||1"
	s ret=0
	s orderID="" f  s orderID=$o(^OEORD(0,"Adm",Paadm,orderID)) q:orderID=""  d
	.s startDate="" f  s startDate=$o(^OEORDi(0,"ARCIM",orderID,ArcimID,startDate)) q:startDate=""  d
	..s childsub="" f  s childsub=$o(^OEORDi(0,"ARCIM",orderID,ArcimID,startDate,childsub)) q:childsub=""  d
	...s itemID=orderID_"||"_childsub
	...s orderItem=##class(DHCMed.Base.OrdItem).GetObjById(itemID)
	...q:orderItem=""
	...;b
	...d orderItem.%Close()
	...s tmpData=$g(^CacheTemp(repid,"CalcOrderNumber",orderItem.OEORIDoctorDR))
	...s $p(tmpData,"^",1)=$p(tmpData,"^",1)+orderItem.OEORIDoseQty
	...s ^CacheTemp(repid,"CalcOrderNumber",orderItem.OEORIDoctorDR)=tmpData
	...s orderItem=""
	...k orderItem
	
	s ret=""
	s userID="" f  s userID=$o(^CacheTemp(repid,"CalcOrderNumber",userID)) q:userID=""  d
	.s:ret'="" ret=ret_$c(1)
	.s tmpData=$g(^CacheTemp(repid,"CalcOrderNumber",userID))
	.s ret=ret_userID_"^"_$p(tmpData,"^",1)
	.k ^CacheTemp(repid,"CalcOrderNumber",userID)
	q ret
}

ClassMethod HasAntiDrugOrder(aPaadm As %String) As %String
{
	New (aPaadm)
	Set return=0
	Quit:aPaadm="" return
	
	Set AntiPhcDrugTypeList=""
	Set AntiPhcDrugType=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("NINFInfAntiPhcDrugType","")
	If AntiPhcDrugType'="" {
		For indConf=1:1:$l(AntiPhcDrugType,",") {
			Set tmp=$p(AntiPhcDrugType,",",indConf)
			Continue:tmp=""
			Set AntiPhcDrugTypeList=AntiPhcDrugTypeList_$lb(tmp)
		}
	}
	
	Set OrdID=$o(^OEORD(0,"Adm",aPaadm,0))
	Set OrdID=+OrdID
	Set ArcimID=0
	For {
		Set ArcimID=$o(^OEORDi(0,"ARCIM",OrdID,ArcimID))
		Quit:ArcimID=""
		Quit:return>0
		
		Set objArcim=##class(DHCMed.Base.Arcim).GetObjById(ArcimID)
		If objArcim'="" Do objArcim.%Close()
		Continue:'$IsObject(objArcim)
		Set ArcOrdTp=objArcim.ARCICOrderType
		Continue:ArcOrdTp'="R" //不是药品
		Set PHCDFDr=objArcim.ARCIMPHCDFDR
		
		//判断是否抗生素
		Set IsAnti="N"
		Set AntiCompareFlag=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("NINFAntiFlag","")
		Set:AntiCompareFlag="" AntiCompareFlag=1
		If AntiCompareFlag=2 {
			//使用新抗菌素标记判断是否抗生素
			//新增抗菌药标志保存在药学项子表的“DHC”扩展节点下，如下
			//$p(^PHCD({PHCDF_PHCD_ParRef},"DF",{PHCDF_ChildSub},"DHC"),"^",8)     值为“Y”为是抗菌药		
			//modify by mxp 2017-10-23		
			//Set ChildSub=$o(^PHCD(PHCDFDr,"DF",""),-1)
			//Set AntiFlag=$p($g(^PHCD(PHCDFDr,"DF",ChildSub,"DHC")),"^",8)
			Set AntiFlag=$p($g(^PHCD(+PHCDFDr,"DF",$p(PHCDFDr,"||",2),"DHC")),"^",8)
			Set:AntiFlag="Y" IsAnti="Y"
		} Else {
			//根据药学大类或药学子类判断是否抗生素
			/*Set objPhc=##class(DHCMed.Base.PHC).GetObjById(PHCDFDr)
			Continue:'$IsObject(objPhc)
			Set PHCCDesc=objPhc.PHCCDesc
			Set PHCSCDesc=objPhc.PHCSCDesc
			If (PHCCDesc'="") {
				If $listfind(AntiPhcDrugTypeList,PHCCDesc)>0 {
					Set IsAnti="Y"
				}
			}
			If (PHCSCDesc'="") {
				If $listfind(AntiPhcDrugTypeList,PHCSCDesc)>0 {
					Set IsAnti="Y"
				}
			}*/
			Set tmpPHCCat=##Class(DHCMed.DPCustom.Data.OEOrdItem).GetPHCCat(ArcimID)
			Continue:tmpPHCCat=""
			Set PHCCat=$p(tmpPHCCat,$c(1),1)
			Set PHCCatCode=$p(PHCCat,$c(2),2)
			Set PHCCatDesc=$p(PHCCat,$c(2),3)
			Set PHCSubCat=$p(tmpPHCCat,$c(1),2)
			Set PHCSubCatCode=$p(PHCSubCat,$c(2),2)
			Set PHCSubCatDesc=$p(PHCSubCat,$c(2),3)
			Set PHCPoison=$p(tmpPHCCat,$c(1),3)
			Set PHCPoisonCode=$p(PHCPoison,$c(2),2)
			Set PHCPoisonDesc=$p(PHCPoison,$c(2),3)
			Set PHCAntiFlag=$p(tmpPHCCat,$c(1),4)
			
			If ((PHCCatCode'="")&&($listfind(AntiPhcDrugTypeList,PHCCatCode)>0))
			||((PHCCatDesc'="")&&($listfind(AntiPhcDrugTypeList,PHCCatDesc)>0))
			||((PHCSubCatCode'="")&&($listfind(AntiPhcDrugTypeList,PHCSubCatCode)>0))
			||((PHCSubCatDesc'="")&&($listfind(AntiPhcDrugTypeList,PHCSubCatDesc)>0))
			||((PHCPoisonCode'="")&&($listfind(AntiPhcDrugTypeList,PHCPoisonCode)>0))
			||((PHCPoisonDesc'="")&&($listfind(AntiPhcDrugTypeList,PHCPoisonDesc)>0))
			||((PHCAntiFlag'="")&&($listfind(AntiPhcDrugTypeList,PHCAntiFlag)>0))
			{
				Set IsAnti="Y"
			}
		}
		Continue:IsAnti'="Y"
		
		Set StartDate=""
		For {
			Set StartDate=$o(^OEORDi(0,"ARCIM",OrdID,ArcimID,StartDate))
			Quit:StartDate=""
			Quit:return>0
			
			Set SubID=0
			For {
				Set SubID=$o(^OEORDi(0,"ARCIM",OrdID,ArcimID,StartDate,SubID))
				Quit:SubID=""
				Quit:return>0
				
				Set OEItemID=##class(DHCMed.Base.OrdItem).GetObjById(OrdID_"||"_SubID)
				If OEItemID'="" Do OEItemID.%Close()
				Continue:'$IsObject(OEItemID)
				Set return=1
			}
		}
	}
	
	Quit return
}

/// 检查是否送检
ClassMethod IsAntiTestSet(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=0
	Quit:aEpisodeID="" return
	
	Set LabOEItemType=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("NINFInfLabOEItemType","")
 	Set xOrdID=$o(^OEORD(0,"Adm",+aEpisodeID,""))
 	Set xArcimID=""
 	For {
	 	Set xArcimID=$o(^OEORDi(0,"ARCIM",+xOrdID,xArcimID))
	 	Quit:xArcimID=""
	 	Quit:return>0
		
	 	Set objArcim=##Class(DHCMed.Base.Arcim).GetObjById(xArcimID)
	 	Continue:'$IsObject(objArcim)
	 	Set ArcimType=objArcim.ARCICOrderType
	 	Continue:ArcimType'="L"
	 	Set ArcimSubCat=objArcim.ARCICDesc
	 	Continue:ArcimSubCat=""
	 	//微生物
	 	//w LabOEItemType_"///"_ArcimSubCat,!
	 	Continue:(LabOEItemType'="")&&(LabOEItemType'[ArcimSubCat)
	 	
	 	Set ArcimID=xArcimID
	 	Set ArcimDesc=objArcim.ARCIMDesc
	 	
	 	Set xOrdDate=0
	 	For {
		 	Set xOrdDate=$o(^OEORDi(0,"ARCIM",+xOrdID,xArcimID,xOrdDate))
		 	Quit:xOrdDate=""
		 	Quit:return>0
			
		 	Set xSubID=0
		 	For {
			 	Set xSubID=$o(^OEORDi(0,"ARCIM",+xOrdID,xArcimID,xOrdDate,xSubID))
			 	Quit:xSubID=""
			 	Quit:return>0
			 	
			 	Set OEItemID=xOrdID_"||"_xSubID
			 	Set objOEItem=##class(DHCMed.Base.OrdItem).GetObjById(OEItemID)
			 	Continue:'$IsObject(objOEItem)
			 	Set OEItemStatus=objOEItem.OSTATCode
			 	Continue:(OEItemStatus="D")||(OEItemStatus="S")  //检查医嘱状态
			 	
			 	Set return=1
		 	}
	 	}
 	}
	Quit return
}

/// 统计抗菌类药物使用率
/// d ##class(%Library.ResultSet).RunQuery("DHCMed.NINFService.Sta.AntiInfDrugSta","QryAntiInfDrugNumber","2013-03-28","2013-03-28")
Query QryAntiInfDrugNumber(FromDate As %String, ToDate As %String) As %Query(ROWSPEC = "Department:%String,Ward:%String,DisNumber:%Integer,HasOrderNum:%Integer,Percent:%Float,TestSetNum:%Integer,TestSetRatio:%String") [ SqlProc ]
{
}

ClassMethod QryAntiInfDrugNumberExecute(ByRef qHandle As %Binary, FromDate As %String, ToDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)	
	
	Set:FromDate["-" FromDate=$zdh(FromDate,3)
	Set:ToDate["-" ToDate=$zdh(ToDate,3)
	Set:FromDate["/" FromDate=$zdh(FromDate,4)
	Set:ToDate["/" ToDate=$zdh(ToDate,4)
	
	Kill ^TMP(repid,"QryAntiInfDrugNumber")
	Set DischDateIndex=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateIndex()  //update by pylian 2016-01-21取出院时间索引	
	For xDate=FromDate:1:ToDate {
		Set xPaadm=0
		For {
			Set xPaadm=$o(^PAADMi(DischDateIndex,xDate,xPaadm))
			Quit:xPaadm=""
			Set AdmInfo=$g(^PAADM(xPaadm))
			Continue:$p(AdmInfo,"^",2)'="I"           //就诊类型过滤
			Continue:$p(AdmInfo,"^",20)="C"           //就诊状态过滤
			Continue:$p(AdmInfo,"^",75)'=""  
			Set objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(xPaadm)
			If objAdm'="" Do objAdm.%Close()
			Set LocID=objAdm.DepartmentID
			Set WardID=objAdm.WardID
			
			//就诊人次
			Set flg=$i(^TMP(repid,"QryAntiInfDrugNumber",+LocID,+WardID,"就诊人次"))
			
			//使用抗生素人数
			Set IsHasAntiOrder=..HasAntiDrugOrder(xPaadm)
			If IsHasAntiOrder>0 {
				Set flg=$i(^TMP(repid,"QryAntiInfDrugNumber",+LocID,+WardID,"使用抗生素人数"))
				//是否送检
				Set IsAntiTestSet=..IsAntiTestSet(xPaadm)
				If IsAntiTestSet>0 {
					Set flg=$i(^TMP(repid,"QryAntiInfDrugNumber",+LocID,+WardID,"送检人数"))
				}
			}
		}
	}
	
	Set LocID=""
	For {
		Set LocID=$o(^TMP(repid,"QryAntiInfDrugNumber",LocID))
		Quit:LocID=""
		
		Set objLoc=##class(DHCMed.Base.Ctloc).GetObjById(LocID)
		If $IsObject(objLoc) {
			Set LocDesc=objLoc.Descs
			Set:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
		} Else {
			Set LocDesc="其他"
		}
		
		Set WardID=""
		For {
			Set WardID=$o(^TMP(repid,"QryAntiInfDrugNumber",LocID,WardID))
			Quit:WardID=""
			
			Set objWard=##class(DHCMed.Base.PacWard).GetObjById(WardID)
			If $IsObject(objWard) {
				Set WardDesc=objWard.Descs
				Set:WardDesc["-" WardDesc=$p(WardDesc,"-",2)
			} Else {
				Set WardDesc="其他"
			}
			
			Set AdmCount=+$g(^TMP(repid,"QryAntiInfDrugNumber",LocID,WardID,"就诊人次"))
			Set UseAntCount=+$g(^TMP(repid,"QryAntiInfDrugNumber",LocID,WardID,"使用抗生素人数"))
			Set TestSetCount=+$g(^TMP(repid,"QryAntiInfDrugNumber",LocID,WardID,"送检人数"))
			If AdmCount>0 {
				Set UseAntRatio=$fn((UseAntCount/AdmCount)*100,"",2)_"%"
				Set TestSetRatio=$fn((TestSetCount/AdmCount)*100,"",2)_"%"
			} Else {
				Set UseAntRatio="0.00%"
				Set TestSetRatio="0.00%"
			}
			Set Data=$lb(LocDesc,WardDesc,AdmCount,UseAntCount,UseAntRatio,TestSetCount,TestSetRatio)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Kill ^TMP(repid,"QryAntiInfDrugNumber")
	
	Quit $$$OK
}

ClassMethod QryAntiInfDrugNumberClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAntiInfDrugNumberExecute ]
{
	Set repid=$li(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryAntiInfDrugNumberFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAntiInfDrugNumberExecute ]
{
	Set AtEnd=$li(qHandle,1)
 	Set repid=$li(qHandle,2)
 	Set ind=$li(qHandle,3)
 	
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// d ##class(%Library.ResultSet).RunQuery("DHCMed.INFService.Sta.AntiInfDrugSta","QryArcimNumberByDoctor","2010-1-1","2011-12-31",10339)
Query QryArcimNumberByDoctor(FromDate As %String, ToDate As %String, ArcimID As %String) As %Query(ROWSPEC = "UserID:%String,UserCode:%String:工号,UserName:%String:用户名,HasOrderNum:%String:使用抗生素人数,OrderNumber:%String:数量") [ SqlProc ]
{
}

ClassMethod QryArcimNumberByDoctorExecute(ByRef qHandle As %Binary, FromDate As %String, ToDate As %String, ArcimID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)	
	
	s:FromDate["-" FromDate=$zdh(FromDate,3)
	s:ToDate["-" ToDate=$zdh(ToDate,3)
	s:FromDate["/" FromDate=$zdh(FromDate,4)
	s:ToDate["/" ToDate=$zdh(ToDate,4)	

	s indexName="DischDate" ;EstDisch
	s status=" "_"2" //索引有空格
	f tmpDate=FromDate:1:ToDate  d
	.s paadm="" f  s paadm=$o(^PAADMi(indexName,tmpDate,paadm)) q:paadm=""  d
	..q:$d(^PAADMi("PAADM_Type","I",paadm))=0 //检查是否是住院
	..s calcResult=..CalcOrderNumber(repid,ArcimID,paadm)
	..f cnt=1:1:$l(calcResult,$c(1))  d
	...s tmp=$p(calcResult,$c(1),cnt)
	...q:tmp=""	
	...s careProvider=$p(tmp,"^",1)
	...s num=$p(tmp,"^",2)
	...q:careProvider=""
	...s tmpData=$g(^CacheTemp("QryArcimNumberByDoctorExecute",repid,careProvider))
	...s $p(tmpData,"^",1)=$p(tmpData,"^",1)+1 //做过这个医嘱的病人数量
	...s $p(tmpData,"^",2)=$p(tmpData,"^",2)+num //医嘱总量
	...s ^CacheTemp("QryArcimNumberByDoctorExecute",repid,careProvider)=tmpData
	
	
	s careProvider="" f  s careProvider=$o(^CacheTemp("QryArcimNumberByDoctorExecute",repid,careProvider)) q:careProvider=""  d
	.s userId=$o(^SSU("SSUSR",0,"CTPCP",+careProvider,""))
	.q:userId=""
	.s objUser=##class(DHCMed.Base.SSUser).GetObjById(userId)
	.q:objUser=""
	.d objUser.%Close()
	.s tmpData=$g(^CacheTemp("QryArcimNumberByDoctorExecute",repid,careProvider))
	.s ^CacheTemp(repid,ind)=$$BuildData(1)
	.s ind=ind+1
	
	Quit $$$OK
BuildData(param)
	s data=$lb("")
	s $li(data,1)=objUser.Rowid
	s $li(data,2)=objUser.Code
	s $li(data,3)=objUser.Name
	s $li(data,4)=$p(tmpData,"^",1)
	s $li(data,5)=$p(tmpData,"^",2)
	q data
}

ClassMethod QryArcimNumberByDoctorClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryArcimNumberByDoctorExecute ]
{
	Set repid=$li(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryArcimNumberByDoctorFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryArcimNumberByDoctorExecute ]
{
	Set AtEnd=$li(qHandle,1)
 	Set repid=$li(qHandle,2)
 	Set ind=$li(qHandle,3)
 	
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
