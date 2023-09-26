/// 费用分析
Class web.DHCCPW.MRIR.CostAnalysis Extends web.DHCCPW.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Description:获得费用明细对象
/// Debug:
ClassMethod GetCostDetail(ID As %String)
{
	New (ID)
	If (##Class(User.DHCMRCClinPathWayCostDetail).%ExistsId(ID)){
		Quit ##Class(User.DHCMRCClinPathWayCostDetail).%OpenId(ID)
	}Else{
			
	}
}

/// Description:取计费组接口数据存入临床路径计费明细表
ClassMethod InsertCostDetail(Paadm As %String)
{
	New (Paadm)
	Set Count=0
	Set DS=##class(%Library.ResultSet).%New("web.UDHCJFBillDetailInterface:FindBillDetail")
	Do DS.Execute(Paadm)
	While(DS.Next()){
		Set CPWCDPaAdm=Paadm
		Set CPWCDCateName=DS.Data("Ttaridesc")
		Continue:CPWCDCateName="合计"
		Set CPWCDItemName=DS.Data("Torder")
		Set CPWCDQty=DS.Data("Tqty")
		Set CPWCDUnitPrice=DS.Data("Tunitprice")
		Set CPWCDAmount=DS.Data("Tprice")
		Set CPWCDHappenDate=DS.Data("TBillDate")
		Set CPWCDUOM=DS.Data("Tuom")
		Set CostDetailStr="^"_CPWCDPaAdm_"^^"_CPWCDCateName_"^"_CPWCDItemName_"^"_CPWCDQty_"^"_CPWCDUnitPrice_"^"_CPWCDAmount_"^"_CPWCDHappenDate_"^"_CPWCDUOM
		Set Ret=..UpDateCostDetail(CostDetailStr)
		If (Ret>0){
			Set Count=Count+1	
		}
	}	
	Quit Count
}

/// CreateDate:2012-09-10	
/// Description:插入、更新费用明细
/// Debug:w ##Class(web.DHCCPW.MRIR.CostAnalysis).UpdateCostDetail()
ClassMethod UpDateCostDetail(CostDetailStr As %String)
{
	New (CostDetailStr)
	Set ^Test=CostDetailStr
	Set Return=-1
	Set ID=""
	Set CPWCDPaAdm=$p($g(CostDetailStr),"^",2)
	Set CPWCDCateCode=$p($g(CostDetailStr),"^",3)
	Set CPWCDCateName=$p($g(CostDetailStr),"^",4)
	Set CPWCDItemName=$p($g(CostDetailStr),"^",5)
	Set CPWCDQty=$p($g(CostDetailStr),"^",6)
	Set CPWCDUnitPrice=$p($g(CostDetailStr),"^",7)
	Set CPWCDAmount=$p($g(CostDetailStr),"^",8)
	Set CPWCDHappenDate=$p($g(CostDetailStr),"^",9)
	Set CPWCDUOM=$p($g(CostDetailStr),"^",10)
	Set:CPWCDHappenDate["-" CPWCDHappenDate=$zdh(CPWCDHappenDate,3)
	Set:CPWCDHappenDate["/" CPWCDHappenDate=$zdh(CPWCDHappenDate,4)
	Set Obj=##Class(User.DHCMRCClinPathWayCostDetail).%New()
	Set Obj.CPWCDPaAdm=CPWCDPaAdm
	Set Obj.CPWCDCateCode=CPWCDCateCode
	Set Obj.CPWCDCateName=CPWCDCateName
	Set Obj.CPWCDItemName=CPWCDItemName
	Set Obj.CPWCDQty=CPWCDQty
	Set Obj.CPWCDUnitPrice=CPWCDUnitPrice
	Set Obj.CPWCDAmount=CPWCDAmount
	Set Obj.CPWCDHappenDate=CPWCDHappenDate
	Set Obj.CPWCDUOM=CPWCDUOM
	
	Set SC=Obj.%Save()
	If ($System.Status.IsError(SC)){
		Do $System.OBJ.DisplayError(SC)
		Set Return=-1
	}Else{
		Set Return=Obj.%Id()	
	}
	Do Obj.%Close()
	
	Quit Return
}

/// CreateDate:2012-09-10
/// Return:-1 不存在 1 存在
/// Description:判断是否已经存在费用明细
/// Debug:
ClassMethod IsExistCostDetail(Paadm As %String)
{
	New (Paadm)
	Set Return=-1
	;^DHCMRi("CPWCD",0,"IndexPaAdm",-100000000000000,729)
	If ('$d(^DHCMRi("CPWCD",0,"IndexPaAdm",Paadm))){
		Do ..InsertCostDetail(Paadm)
	}Else{
		Set Return=1
	}
	Quit Return
}

/// Creator:wangcs
/// CreateDate:2012-09-10
/// Description:查询一段时间内病人信息明细
/// Debug:w ##Class(%ResultSet).RunQuery("web.DHCCPW.MRIR.CostAnalysis","QryCostDetailByDischDate","2011-01-01","2012-09-01","")
Query QryCostDetailByDischDate(DischStaDate As %String, DischEndDate As %String, CPWDID As %String) As %Query(ROWSPEC = "MrNo:%String,PapmiName:%String,HappenDate:%String,CateName:%String,ItemName:%String,Qty:%String,UnitPrice:%String,Total:%Numeric,CPWD:%String,HappDays:%String,PapmiNo:%String") [ SqlProc ]
{
}

ClassMethod QryCostDetailByDischDateExecute(ByRef qHandle As %Binary, DischStaDate As %String, DischEndDate As %String, CPWDID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set:DischStaDate["-" DischStaDate=$zdh(DischStaDate,3)
	Set:DischStaDate["/" DischStaDate=$zdh(DischStaDate,4)
	Set:DischEndDate["-" DischEndDate=$zdh(DischEndDate,3)
	Set:DischEndDate["/" DischEndDate=$zdh(DischEndDate,4)
	
	Set DischDateIndex=##Class(web.DHCCPW.IO.FromAdmSrv).GetDischDateIndex()  //update by pylian 2016-01-21取出院时间索引
	Set Paadm=0
	For DischgDate=DischStaDate:1:DischEndDate {
	   ;^PAADMi("DischDate",{PAADM_DischgDate},{PAADM_RowID})
	   For {
		  Set Paadm=$o(^PAADMi(DischDateIndex,DischgDate,Paadm))	
		  Quit:Paadm=""
		  
		  //Set AdmDate=$p($g(^PAADM(Paadm)),"^",6)         ;就诊日期
		  //upadte by pylian 2016-02-18 修改入院时间取值方式
    	  Set AdmDateTime=##Class(web.DHCCPW.IO.FromAdmSrv).GetAdmDateTime(Paadm)
		  Set AdmDate=$p(AdmDateTime,"^",1)
		  Set ClinicalPathWayObj=..GetCPWByPaadm(Paadm)
		  Continue:'$IsObject(ClinicalPathWayObj)
		  ;Continue:ClinicalPathWayObj.CPWStatus'="C"
		  Continue:'$IsObject(ClinicalPathWayObj.CPWPathwayDR)
		  Continue:'$IsObject(ClinicalPathWayObj.CPWPathwayDR.CPWCPWDicDR)
		  Continue:(CPWDID'="")&&(ClinicalPathWayObj.CPWPathwayDR.CPWCPWDicDR.%Id()'=CPWDID)
		  Set CPWDDesc=ClinicalPathWayObj.CPWPathwayDR.CPWCPWDicDR.CPWDDesc
		  /*判断费用明细表是否已经存在病人明细，
	        不存在从计费组接口取出来插入费用明细表
	      */
	      Set IsExist=..IsExistCostDetail(Paadm) 
		  Set PatientID=$p($g(^PAADM(Paadm)),"^",1)   
		  Set PatName=$p(^PAPER(PatientID,"ALL"),"^",1)    ;病人姓名
		  Set MrNo=$p(^PAPER(PatientID,"PAT",1),"^",22)  ;MrNo
		  Set PapmiNo=$P(^PAPER(PatientID,"PAT",1),"^",1) ;papmiNo
		  Set CPWCDID=0
		  For {
			 ;^DHCMRi("CPWCD",0,"IndexPaAdm",66406,1454)
		     Set CPWCDID=$o(^DHCMRi("CPWCD",0,"IndexPaAdm",Paadm,CPWCDID))	
		     Quit:CPWCDID=""	  
		     
		     Set CPWCDObj=..GetCostDetail(CPWCDID)
		     Continue:'$IsObject(CPWCDObj)
		     Set HappenDate=CPWCDObj.CPWCDHappenDate
		     Set CateName=CPWCDObj.CPWCDCateName
		     Set ItemName=CPWCDObj.CPWCDItemName
		     Set Qty=CPWCDObj.CPWCDQty
		     Set UnitPrice=CPWCDObj.CPWCDUnitPrice
		     Set Total=CPWCDObj.CPWCDAmount
		     Set HappDays=HappenDate-AdmDate+1
		     Set HappDays=HappDays+""
		     Set HappDays=$e(HappDays,$l(HappDays),$l(HappDays))
		     
		     Set:HappDays<=0 HappDays=1
		     Set HappDays="第"_HappDays_"天"
		     Set Data=$lb(MrNo,PatName,HappenDate,CateName,ItemName,Qty,UnitPrice,Total,CPWDDesc,HappDays,PapmiNo)
		     Set ^CacheTemp(repid,ind)=Data
		     Set ind=ind+1
		  }
		  
	   }
	}
	Quit $$$OK
}

ClassMethod QryCostDetailByDischDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCostDetailByDischDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCostDetailByDischDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCostDetailByDischDateExecute ]
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

/// Creator:zhaoyu
/// CreateDate:2013-03-27
/// Description:查询一段时间内病人信息明细(根据月报表)
/// Debug:w ##Class(%ResultSet).RunQuery("web.DHCCPW.MRIR.CostAnalysis","QryCPWCostDtlByDisDate","2011-01-01","2012-09-01","","")
/// 																																					Paadm,CPWDID,CPWDicDesc,MrNo,PatName,HappenDate,CateName,ItemName,Qty,UnitPrice,Total,HappDays,PapmiNo
Query QryCPWCostDtlByDisDate(DischStaDate As %String, DischEndDate As %String, argCPWDID As %String, argCPWStatus As %String) As %Query(ROWSPEC = "Paadm:%String,CPWDID:%String,CPWDicDesc:%String,MrNo:%String,PatName:%String,HappenDate:%String,CateName:%String,ItemName:%String,Qty:%String,UnitPrice:%String,Total:%Numeric,HappDays:%String,PapmiNo:%String") [ SqlProc ]
{
}

ClassMethod QryCPWCostDtlByDisDateExecute(ByRef qHandle As %Binary, DischStaDate As %String, DischEndDate As %String, argCPWDID As %String, argCPWStatus As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set:DischStaDate["-" DischStaDate=$zdh(DischStaDate,3)
	Set:DischStaDate["/" DischStaDate=$zdh(DischStaDate,4)
	Set:DischEndDate["-" DischEndDate=$zdh(DischEndDate,3)
	Set:DischEndDate["/" DischEndDate=$zdh(DischEndDate,4)
	
	Set DischDateIndex=##Class(web.DHCCPW.IO.FromAdmSrv).GetDischDateIndex()  //update by pylian 2016-01-21取出院时间索引	
	Set Paadm=0
	For DischgDate=DischStaDate:1:DischEndDate {
		//^PAADMi("DischDate",{PAADM_DischgDate},{PAADM_RowID})
		For {
			Set Paadm=$o(^PAADMi(DischDateIndex,DischgDate,Paadm))	
			Quit:Paadm=""
			
			//Set AdmDate=$p($g(^PAADM(Paadm)),"^",6)         ;就诊日期
			//upadte by pylian 2016-02-18 修改入院时间取值方式
    		Set AdmDateTime=##Class(web.DHCCPW.IO.FromAdmSrv).GetAdmDateTime(Paadm)
			Set AdmDate=$p(AdmDateTime,"^",1)
			Set AnalysisID=$o(^DHCMRi("CPWA",0,"IndexPaadm",Paadm,""),-1)
			Set objAnalysis=##class(web.DHCCPW.MR.ClinPathWayAnalysisSrv).GetObjById(AnalysisID)
			Continue:'$IsObject(objAnalysis)
			Set CPWDID=objAnalysis.CPWACPWDID
			Continue:CPWDID=""
			Continue:(argCPWDID'="")&&(argCPWDID'=CPWDID)
			Set objCPWDic=##class(web.DHCCPW.MRC.ClinPathWaysDicSrv).GetObjById(CPWDID)
			Continue:'$IsObject(objCPWDic)
			Set CPWDicDesc=objCPWDic.CPWDDesc
			Set PathWayID=objAnalysis.CPWAPathWayID
			Set objPathWay=##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(PathWayID)
			Set CPWStatus=$s($IsObject(objPathWay):objPathWay.CPWStatus,1:"")
			Continue:(argCPWStatus="入径")&&(CPWStatus="")	//按入径统计
			Continue:(argCPWStatus="完成")&&(CPWStatus'="C")	//按完成统计
			//判断费用明细表是否已经存在病人明细，不存在从计费组接口取出来插入费用明细表
			Set IsExist=..IsExistCostDetail(Paadm) 
			Set PatientID=$p($g(^PAADM(Paadm)),"^",1)   
			Set PatName=$p(^PAPER(PatientID,"ALL"),"^",1)    ;病人姓名
			Set MrNo=$p(^PAPER(PatientID,"PAT",1),"^",22)  ;MrNo
			Set PapmiNo=$P(^PAPER(PatientID,"PAT",1),"^",1) ;papmiNo
			Set CPWCDID=0
			For {
				//^DHCMRi("CPWCD",0,"IndexPaAdm",66406,1454)
				Set CPWCDID=$o(^DHCMRi("CPWCD",0,"IndexPaAdm",Paadm,CPWCDID))	
				Quit:CPWCDID=""	  
				//
				Set CPWCDObj=..GetCostDetail(CPWCDID)
				Continue:'$IsObject(CPWCDObj)
				Set HappenDate=CPWCDObj.CPWCDHappenDate
				Set CateName=CPWCDObj.CPWCDCateName
				Set ItemName=CPWCDObj.CPWCDItemName
				Set Qty=CPWCDObj.CPWCDQty
				Set UnitPrice=CPWCDObj.CPWCDUnitPrice
				Set Total=CPWCDObj.CPWCDAmount
				Set HappDays=HappenDate-AdmDate+1
				Set HappDays=HappDays+""
				Set HappDays=$e(HappDays,$l(HappDays),$l(HappDays))
				
				Set:HappDays<=0 HappDays=1
				Set HappDays="第"_HappDays_"天"
				Set Data=$lb(Paadm,CPWDID,CPWDicDesc,MrNo,PatName,HappenDate,CateName,ItemName,Qty,UnitPrice,Total,HappDays,PapmiNo)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	Quit $$$OK
}

ClassMethod QryCPWCostDtlByDisDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCPWCostDtlByDisDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCPWCostDtlByDisDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCPWCostDtlByDisDateExecute ]
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

/// Description:获取入径记录对象根据Paadm
/// Debug:w ##Class(web.DHCCPW.MRIR.CostAnalysis).GetCPWByPaadm(Paadm)
ClassMethod GetCPWByPaadm(Paadm As %String)
{
	New (Paadm)
	Set Return=""
	Set MrAdm=$p(^PAADM(Paadm),"^",61)
	Quit:'$d(^DHCMRi("CPW",0,"IndexMRAdm"," "_MrAdm)) Return
	
	Set CPWID=0
	For {
		Set CPWID=$o(^DHCMRi("CPW",0,"IndexMRAdm"," "_MrAdm,CPWID))
		Quit:(CPWID="")||(Return'="")
		Set obj=##Class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(CPWID)
		Set Return=obj
	}
	Quit Return
}

/// CreateDate:2012-09-11
/// Description:获取收费明细根据病人就诊ID
/// Debug:w ##Class(%ResultSet).RunQuery("web.DHCCPW.MRIR.CostAnalysis","QryCostDetailByPaadm","66406")
Query QryCostDetailByPaadm(Paadm As %String) As %Query(ROWSPEC = "MrNo:%String,PapmiName:%String,ItemName:%String,InHospDays:%String,Amount:%String,CPWDDesc:%String") [ SqlProc ]
{
}

ClassMethod QryCostDetailByPaadmExecute(ByRef qHandle As %Binary, Paadm As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	
	Set PatientID=$p($g(^PAADM(Paadm)),"^",1)   
	Set PatName=$p(^PAPER(PatientID,"ALL"),"^",1)  ;病人姓名
	Set MrNo=$p(^PAPER(PatientID,"PAT",1),"^",22)  ;MrNo
	Set CPWObj=..GetCPWByPaadm(Paadm)
	/*判断费用明细表是否已经存在病人明细，
	  不存在从计费组接口取出来插入费用明细表
	*/
	Set IsExist=..IsExistCostDetail(Paadm) 
	Set InPathWayDate=CPWObj.CPWInDate
	Quit:'$IsObject(CPWObj) $$$OK
	;Continue:ClinicalPathWayObj.CPWStatus'="C"
	Quit:'$IsObject(CPWObj.CPWPathwayDR) $$$OK
	Quit:'$IsObject(CPWObj.CPWPathwayDR.CPWCPWDicDR) $$$OK
	Set CPWDDesc=CPWObj.CPWPathwayDR.CPWCPWDicDR.CPWDDesc
	
	Set (ItemName,InHospDays,Amount)=""
	Set CPWCDID=0
	For {
	    ;^DHCMRi("CPWCD",0,"IndexPaAdm",66406,1454)
		Set CPWCDID=$o(^DHCMRi("CPWCD",0,"IndexPaAdm",Paadm,CPWCDID))	
		Quit:CPWCDID=""	  
		
		Set CPWCDObj=..GetCostDetail(CPWCDID)
		Continue:'$IsObject(CPWCDObj)
		Set HappenDate=CPWCDObj.CPWCDHappenDate
		;Set CateName=CPWCDObj.CPWCDCateName
		Set ItemName=CPWCDObj.CPWCDItemName
		;Set Qty=CPWCDObj.CPWCDQty
		;Set UnitPrice=CPWCDObj.CPWCDUnitPrice
		Set Amount=CPWCDObj.CPWCDAmount
		Set InHospDays=HappenDate-InPathWayDate
		Set InHospDays="第"_InHospDays_"天"
		Set Data=$lb(MrNo,PatName,ItemName,InHospDays,Total,CPWDDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryCostDetailByPaadmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCostDetailByPaadmExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCostDetailByPaadmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCostDetailByPaadmExecute ]
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

/// Creator:wangcs
/// CreateDate:2012-09-11
/// Description:根据登记号获取病人的费用明细
/// Debug:w ##Class(%ResultSet).RunQuery("web.DHCCPW.MRIR.CostAnalysis","QryCostDeatilByPapmiNo","0000097882")
Query QryCostDeatilByPapmiNo(PapmiNo As %String) As %Query(ROWSPEC = "MrNo:%String,PapmiName:%String,HappenDate:%String,CateName:%String,ItemName:%String,Qty:%String,UnitPrice:%String,Total:%String,CPWD:%String") [ SqlProc ]
{
}

ClassMethod QryCostDeatilByPapmiNoExecute(ByRef qHandle As %Binary, PapmiNo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	Set ^Test="111"
	Quit:PapmiNo="" $$$OK
	Set PapmiNo=$ZCVT(PapmiNo,"U")
	
	;^PAPERi("PAPMI_PatNo",$$ALPHAUP({PAPMI_No}),{PAPMI_RowId})
	Set PapmiDr=0
	For {
		Set PapmiDr=$o(^PAPERi("PAPMI_PatNo",PapmiNo,PapmiDr))	
		Quit:PapmiDr=""
		
		;^PAPERdr({PAADM_PAPMI_DR},"ADM",{PAADM_Type},{PAADM_RowID})
		Set Paadm=0
		For {
			Set Paadm=$o(^PAPERdr(PapmiDr,"ADM","I",Paadm))	
			Quit:Paadm=""
			
			Set ClinicalPathWayObj=..GetCPWByPaadm(Paadm)
		    Continue:'$IsObject(ClinicalPathWayObj)
		    ;Continue:ClinicalPathWayObj.CPWStatus'="C"
		    Continue:'$IsObject(ClinicalPathWayObj.CPWPathwayDR)
		    Continue:'$IsObject(ClinicalPathWayObj.CPWPathwayDR.CPWCPWDicDR)
		    ;Continue:(CPWDID'="")&&(ClinicalPathWayObj.CPWPathwayDR.CPWCPWDicDR.%Id()'=CPWDID)
		    Set CPWDDesc=ClinicalPathWayObj.CPWPathwayDR.CPWCPWDicDR.CPWDDesc
		   /*判断费用明细表是否已经存在病人明细，
	          不存在从计费组接口取出来插入费用明细表
	        */
	        Set IsExist=..IsExistCostDetail(Paadm) 
		    Set PatientID=$p($g(^PAADM(Paadm)),"^",1)   
		    Set PatName=$p(^PAPER(PatientID,"ALL"),"^",1)    ;病人姓名
		    Set MrNo=$p(^PAPER(PatientID,"PAT",1),"^",22)  ;MrNo
		    Set CPWCDID=0
		    For {
			  ;^DHCMRi("CPWCD",0,"IndexPaAdm",66406,1454)
		      Set CPWCDID=$o(^DHCMRi("CPWCD",0,"IndexPaAdm",Paadm,CPWCDID))	
		      Quit:CPWCDID=""	
		      Set CPWCDObj=..GetCostDetail(CPWCDID)
		      Continue:'$IsObject(CPWCDObj)
		      Set HappenDate=$zd(CPWCDObj.CPWCDHappenDate,3)
		      Set CateName=CPWCDObj.CPWCDCateName
		      Set ItemName=CPWCDObj.CPWCDItemName
		      Set Qty=CPWCDObj.CPWCDQty
		      Set UnitPrice=CPWCDObj.CPWCDUnitPrice
		      Set Total=CPWCDObj.CPWCDAmount
		      Set Data=$lb(MrNo,PatName,HappenDate,CateName,ItemName,Qty,UnitPrice,Total,CPWDDesc)
		      Set ^CacheTemp(repid,ind)=Data
		      Set ind=ind+1
		    }
		}
		
	}
	
	Quit $$$OK
}

ClassMethod QryCostDeatilByPapmiNoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCostDeatilByPapmiNoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCostDeatilByPapmiNoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCostDeatilByPapmiNoExecute ]
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

ClassMethod GetListBuilderByPaadm(Paadm As %String)
{
	New (Paadm)
}

/// Creator:wangcs
/// Description:获取费用分析根据病人的登记号
/// CreateDate：2012-09-11
/// Debug:w ##Class(%ResultSet).RunQuery("web.DHCCPW.MRIR.CostAnalysis","QryCostAnalysisByPapmiNo","0000097882")
Query QryCostAnalysisByPapmiNo(PapmiNo As %String) As %Query(ROWSPEC = "MrNo:%String,PapmiName:%String,ItemName:%String,InHospDays:%String,Amount:%Numeric,CPWDDesc:%String") [ SqlProc ]
{
}

ClassMethod QryCostAnalysisByPapmiNoExecute(ByRef qHandle As %Binary, PapmiNo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	Set PapmiNo=$ZCVT(PapmiNo,"U")
	Quit:PapmiNo="" $$$OK
	;^PAPERi("PAPMI_PatNo",$$ALPHAUP({PAPMI_No}),{PAPMI_RowId})
	Set PapmiDr=0
	For {
		Set PapmiDr=$o(^PAPERi("PAPMI_PatNo",PapmiNo,PapmiDr))	
		Quit:PapmiDr=""
		
		;^PAPERdr({PAADM_PAPMI_DR},"ADM",{PAADM_Type},{PAADM_RowID})
		Set Paadm=0
		For {
			Set Paadm=$o(^PAPERdr(PapmiDr,"ADM","I",Paadm))	
			Quit:Paadm=""
	
	        Set PatientID=$p($g(^PAADM(Paadm)),"^",1)   
	        Set PatName=$p(^PAPER(PatientID,"ALL"),"^",1)  ;病人姓名
	        Set MrNo=$p(^PAPER(PatientID,"PAT",1),"^",22)  ;MrNo
	        Set CPWObj=..GetCPWByPaadm(Paadm)
	        //Set AdmDate=$p($g(^PAADM(Paadm)),"^",6)         ;就诊日期
	        //upadte by pylian 2016-02-18 修改入院时间取值方式
    		Set AdmDateTime=##Class(web.DHCCPW.IO.FromAdmSrv).GetAdmDateTime(Paadm)
			Set AdmDate=$p(AdmDateTime,"^",1)
	        /*判断费用明细表是否已经存在病人明细，
	          不存在从计费组接口取出来插入费用明细表
	        */
	        Set IsExist=..IsExistCostDetail(Paadm)          
	       
	        Continue:'$IsObject(CPWObj)
	        ;Continue:ClinicalPathWayObj.CPWStatus'="C"
	        Continue:'$IsObject(CPWObj.CPWPathwayDR)
	        Continue:'$IsObject(CPWObj.CPWPathwayDR.CPWCPWDicDR) 
	        Set CPWDDesc=CPWObj.CPWPathwayDR.CPWCPWDicDR.CPWDDesc
	        Set InPathWayDate=+CPWObj.CPWInDate
	        Set IsExist=..IsExistCostDetail(Paadm)
	        
	        Set CPWCDID=0
	        For {
	            ;^DHCMRi("CPWCD",0,"IndexPaAdm",66406,1454)
		        Set CPWCDID=$o(^DHCMRi("CPWCD",0,"IndexPaAdm",Paadm,CPWCDID))	
		        Quit:CPWCDID=""	  
		        Set (ItemName,InHospDays,Amount)=""
		        
		        Set CPWCDObj=..GetCostDetail(CPWCDID)
		        Continue:'$IsObject(CPWCDObj)
		        Set HappenDate=CPWCDObj.CPWCDHappenDate
		        Set CateName=CPWCDObj.CPWCDCateName
		        Set ItemName=CPWCDObj.CPWCDItemName
		        Set Amount=CPWCDObj.CPWCDAmount+0
		        Set InHospDays=HappenDate-AdmDate+1
		        Set InHospDays="第"_InHospDays_"天"
		        Set Data=$lb(MrNo,PatName,CateName,InHospDays,Amount,CPWDDesc)
		        Set ^CacheTemp(repid,ind)=Data
		        Set ind=ind+1
	        }
		}
	}
	Quit $$$OK
}

ClassMethod QryCostAnalysisByPapmiNoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCostAnalysisByPapmiNoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCostAnalysisByPapmiNoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCostAnalysisByPapmiNoExecute ]
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
