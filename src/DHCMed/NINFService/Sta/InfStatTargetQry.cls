/// Creator:wangcs
/// CreateDate:2013-03-06
/// Description：智能报表提供查询
Class DHCMed.NINFService.Sta.InfStatTargetQry Extends DHCMed.Abstract [ Not ProcedureBlock ]
{

/// 描述：月报表调用的Query
/// Debug:w ##Class(%ResultSet).RunQuery("DHCMed.NINFService.Sta.InfStatTargetQry","MonthReportOfQuery","2013-03","2013-03")
Query MonthReportOfQuery(StaDate As %String, EndDate As %String) As %Query(ROWSPEC = "InfOfCount:%Integer:出院患者院感发生例数,DischOfCount:%Integer:出院人次,OperInfOfCount:%Integer:手术相关医院感染例数,OperDischOfCount:%Integer:手术患者出院人次,OperPulmInfOfCount:%Integer:手术相关肺部感染例数,NewBornInfOfCount:%Integer:新生儿医院感染发生例数,NewBornDischOfCount:%Integer:同期新生儿患者出院人次,OperPosiInfofCount:%Integer:手术患者手术部位感染发生例数,SelTimeOperOfCount:%Integer:择期手术患者医院感染发生例数,SelTimeOperDischOfCount:%Integer:同期择期手术患者出院人次,SelTimeOperPulmInfOfCount:%Integer:择期手术患者肺部感染发生例数,Lev0OperInfOfCount:%Integer:0级手术感染例数,Lev0OperDischOfCount:%Integer:0级手术出院人次,Lev1OperInfOfCount:%Integer:1级手术感染例数,Lev1OperDischOfCount:%Integer:1级手术出院人次,Lev2OperInfOfCount:%Integer:2级手术感染例数,Lev2OperDischOfCount:%Integer:2级手术出院人次,Lev3OperInfOfCount:%Integer:3级手术感染例数,Lev3OperDischOfCount:%Integer:3级手术出院人次,VenousBloodInfOfCount:%Integer:中心静脉相关血源性感染例数,VenousCatheterOfDays:%Integer:中心静脉置管病人日数,RespPlumInfOfCount:%Integer:呼吸机相关肺部感染例数,RespOfDays:%Integer:使用呼吸机病人日数,CathUrinaryTractInfoOfCount:%Integer:留置导尿管相关泌尿道感染例数,CathOfDays:%Integer:留置导尿管病人日数,BloodInfOfCount:%Integer:血液感染例数,HemodialysisOfCount:%Integer:血液透析例数") [ SqlProc ]
{
}

ClassMethod MonthReportOfQueryExecute(ByRef qHandle As %Binary, StaDate As %String = "", EndDate As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	Quit:(StaDate="")&&(EndDate="") $$$OK
	Set:StaDate="" StaDate=$p($zd($h,3),"-",1)_"-"_$p($zd($h,3),"-",2)
	Set:EndDate="" EndDate=$p($zd($h,3),"-",1)_"-"_$p($zd($h,3),"-",2)
	Set StaDateOfYear=+$p(StaDate,"-",1),
	      StaDateOfMonth=+$p(StaDate,"-",2),
	      EndDateOfYear=+$p(EndDate,"-",1),
	      EndDateOfMonth=+$p(EndDate,"-",2)
	Set StaDateOfDay=1,
	      EndDateOfDay=##Class(DHCMed.NINFService.Sta.InfStatTarget).GetMaxDays(EndDateOfYear,EndDateOfMonth),
	      StaDate=StaDate_"-"_StaDateOfDay,
	      EndDate=EndDate_"-"_EndDateOfDay
	      
	Set:StaDate["-" StaDate=+$zdh(StaDate,3)
	Set:StaDate["/" StaDate=+$zdh(StaDate,4)
	Set StaDate=+StaDate
	Set:EndDate["-" EndDate=+$zdh(EndDate,3)
	Set:EndDate["/" EndDate=+$zdh(EndDate,4)
	Set EndDate=+EndDate
	Set CurrDate=StaDate-1
	For {
		Set CurrDate=$O(^DHCMed.NINF.Srv.InfStatTargetI("IndexOfDischStaDate",CurrDate))
		Quit:(CurrDate="")||(CurrDate>EndDate)
		Set StaTarID=0,
		     (InfOfCount,DischOfCount,OperInfOfCount,OperDischOfCount,
		      OperPulmInfOfCount,NewBornInfOfCount,NewBornDischOfCount,OperPosiInfofCount,SelTimeOperOfCount,SelTimeOperDischOfCount,
		      SelTimeOperPulmInfOfCount,Lev0OperInfOfCount,Lev0OperDischOfCount,Lev1OperInfOfCount,Lev1OperDischOfCount,Lev2OperInfOfCount,
		      Lev2OperDischOfCount,Lev3OperInfOfCount,Lev3OperDischOfCount,VenousBloodInfOfCount,VenousCatheterOfDays,RespPlumInfOfCount,
		      RespOfDays,CathUrinaryTractInfoOfCount,CathOfDays,BloodInfOfCount,HemodialysisOfCount)=0
		For {
			Set StaTarID=$O(^DHCMed.NINF.Srv.InfStatTargetI("IndexOfDischStaDate",CurrDate,StaTarID))
			Quit:StaTarID=""
			
			Set StaTarObj=##Class(DHCMed.NINF.Srv.InfStatTarget).%OpenId(StaTarID)
			If ($IsObject(StaTarObj)){
				Set InfOfCount=InfOfCount+StaTarObj.InfOfCount,
				    DischOfCount=DischOfCount+StaTarObj.DischOfCount,
				    OperInfOfCount=OperInfOfCount+StaTarObj.OperInfOfCount,
				    OperDischOfCount=OperDischOfCount+StaTarObj.OperDischOfCount,
				    OperPulmInfOfCount=OperPulmInfOfCount+StaTarObj.OperPulmInfOfCount,
				    NewBornInfOfCount=NewBornInfOfCount+StaTarObj.NewBornInfOfCount,
				    NewBornDischOfCount=NewBornDischOfCount+StaTarObj.NewBornDischOfCount,
				    OperPosiInfofCount=OperPosiInfofCount+StaTarObj.OperPosiInfofCount,
				    SelTimeOperOfCount=SelTimeOperOfCount+StaTarObj.SelTimeOperOfCount,
				    SelTimeOperDischOfCount=SelTimeOperDischOfCount+StaTarObj.SelTimeOperDischOfCount,
				    SelTimeOperPulmInfOfCount=SelTimeOperPulmInfOfCount+StaTarObj.SelTimeOperPulmInfOfCount,
				    Lev0OperInfOfCount=Lev0OperInfOfCount+StaTarObj.Lev0OperInfOfCount,
				    Lev0OperDischOfCount=Lev0OperDischOfCount+StaTarObj.Lev0OperDischOfCount,
				    Lev1OperInfOfCount=Lev1OperInfOfCount+StaTarObj.Lev1OperInfOfCount,
				    Lev1OperDischOfCount=Lev1OperDischOfCount+StaTarObj.Lev1OperDischOfCount,
				    Lev2OperInfOfCount=Lev2OperInfOfCount+StaTarObj.Lev2OperInfOfCount,
				    Lev2OperDischOfCount=Lev2OperDischOfCount+StaTarObj.Lev2OperDischOfCount,
				    Lev3OperInfOfCount=Lev3OperInfOfCount+StaTarObj.Lev3OperInfOfCount,
				      Lev3OperDischOfCount=Lev3OperDischOfCount+StaTarObj.Lev3OperDischOfCount,
				      VenousBloodInfOfCount=VenousBloodInfOfCount+StaTarObj.VenousBloodInfOfCount,
				      VenousCatheterOfDays=VenousCatheterOfDays+StaTarObj.VenousCatheterOfDays,
				      RespPlumInfOfCount=RespPlumInfOfCount+StaTarObj.RespPlumInfOfCount,
				      RespOfDays=RespOfDays+StaTarObj.RespOfDays,
				      CathUrinaryTractInfoOfCount=CathUrinaryTractInfoOfCount+StaTarObj.CathUrinaryTractInfoOfCount,
				      CathOfDays=CathOfDays+StaTarObj.CathOfDays,
				      BloodInfOfCount=BloodInfOfCount+StaTarObj.BloodInfOfCount,
				      HemodialysisOfCount=HemodialysisOfCount+StaTarObj.HemodialysisOfCount
			}
			Do StaTarObj.%Close()
			Set Data=$lb(InfOfCount,DischOfCount,OperInfOfCount)
			Set Data=Data_$lb(OperDischOfCount,OperPulmInfOfCount,NewBornInfOfCount)
			Set Data=Data_$lb(NewBornDischOfCount,OperPosiInfofCount,SelTimeOperOfCount)
			Set Data=Data_$lb(SelTimeOperDischOfCount,SelTimeOperPulmInfOfCount,Lev0OperInfOfCount)
			Set Data=Data_$lb(Lev0OperDischOfCount,Lev1OperInfOfCount,Lev1OperDischOfCount)
			Set Data=Data_$lb(Lev2OperInfOfCount,Lev2OperDischOfCount,Lev3OperInfOfCount)
			Set Data=Data_$lb(Lev3OperDischOfCount,VenousBloodInfOfCount,VenousCatheterOfDays)
			Set Data=Data_$lb(RespPlumInfOfCount,RespOfDays,CathUrinaryTractInfoOfCount)
			Set Data=Data_$lb(CathOfDays,BloodInfOfCount,HemodialysisOfCount)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Quit $$$OK
}

ClassMethod MonthReportOfQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MonthReportOfQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod MonthReportOfQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MonthReportOfQueryExecute ]
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

/// 描述：根据出院日期查询院感报告
/// 输入：Type   0出院病人  1院感病人  2手术相关感染例数 3手术相关出院人次 4择期手术感染例数 5择期肺部感染例数 6择期手术 7 0级手术感染例数
/// 8 0级手术出院人次 9 1级手术感染例数 10 1级手术出院人次 11 2级手术感染例数12 2级手术出院人次 13 3级手术感染例数 14 3级手术出院人次
/// 15 手术患者肺部感染例数 16 手术部位感染例数 17新生儿感染例数 18 新生儿出院人次 19 血源性感染例数 20 置管病人日数 21呼吸机肺部感染例数 22呼吸机病人日数
/// 23泌尿道感染例数 24导尿管病人日数 25血液感染例数 26血液透析例数
/// Debug:w ##Class(%ResultSet).RunQuery("DHCMed.NINFService.Sta.InfStatTargetQry","QueryReportByDischDate","2012-03-01","2013-03-01","1")
Query QueryReportByDischDate(DischStaDate As %String, DischEndDate As %String, Type As %String) As %Query(ROWSPEC = "PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmDate:%String,DischDate:%String,AdmLoc:%String,AdmWard:%String,BedNo:%String,InfPosi:%String,InfDiagnose:%String,TestSpecimens:%String,InfPathogen:%String,RepCount:%String,Paadm:%String") [ SqlProc ]
{
}

ClassMethod QueryReportByDischDateExecute(ByRef qHandle As %Binary, DischStaDate As %String, DischEndDate As %String, Type As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	Quit:(DischStaDate="")&&(DischEndDate="") $$$OK
	Set:DischStaDate["-" DischStaDate=$zdh(DischStaDate,3)
	Set:DischStaDate["/" DischStaDate=$zdh(DischStaDate,4)
	If (DischEndDate["-"){
		Set CurrYear=+$p(DischEndDate,"-",1)
		Set CurrMonth=+$P(DischEndDate,"-",2)
		Set CurrMaxDays=##Class(DHCMed.NINFService.Sta.InfStatTarget).GetMaxDays(CurrYear,CurrMonth)
		Set DischEndDate=CurrYear_"-"_CurrMonth_"-"_CurrMaxDays
	}
	Set:DischEndDate["-" DischEndDate=$zdh(DischEndDate,3)
	Set:DischEndDate["/" DischEndDate=$zdh(DischEndDate,4)
	Set DischStaDate=+DischStaDate
	Set DischEndDate=+DischEndDate
	
	For CurrDate=DischStaDate:1:DischEndDate {
		Set StatBaseID=0
		For {
		     Set StatBaseID=$O(^DHCMed.NINF.Srv.InfStatBaseI("IndexOfDischDate",CurrDate,StatBaseID))
		     Quit:StatBaseID=""
		     Set StatBaseObj=##Class(DHCMed.NINF.Srv.InfStatBaseInfo).%OpenId(StatBaseID)
		     Continue:'$IsObject(StatBaseObj)
		     Set Paadm=StatBaseObj.Paadm
		     Continue:Paadm=""
		     Set (PapmiNo,MrNo,PatName,Sex,Age,AdmDate,DischDate,AdmLoc,AdmWard,BedNo,InfPosiDesc,InfDiagDesc,
				TestSpecimensDesc,InfPathogenDesc)=""
		    Set PatOfAdmInfo=..GetPatOfAdmInfo(Paadm)
		    Set OutData=$lb("")
		    Set OutData=PatOfAdmInfo
		    Continue:PatOfAdmInfo=""
		    Set RepCount=StatBaseObj.ReportTimes ;报告次数
		    Set OperRelaInfTimes=StatBaseObj.OperRelaInfTimes  ;手术相关感染次数
		    Set OperTimes=StatBaseObj.OperTimes  ;手术次数
		    Set IsNewBorn=StatBaseObj.IsNewBorn ;是否新生儿
		    Set OperPosiInfTimes=StatBaseObj.OperPosiInfTimes ;手术部位感染次数
		    Set OperBellInfTimes=StatBaseObj.OperBellInfTimes ;手术肺部感染次数
		    Set SeleOperInfTimes=StatBaseObj.SeleOperInfTimes ;择期手术感染次数
		    Set SeleOperTimes=StatBaseObj.SeleOperTimes      ;择期手术次数
		    Set SeleOperBellInfTimes=StatBaseObj.SeleOperBellInfTimes   ;择期肺部感染次数
		    Set Rank0OperInfTimes=StatBaseObj.Rank0OperInfTimes  ;0级手术感染次数
		    Set Rank0OperTimes=StatBaseObj.Rank0OperTimes   ;0级手术次数
		    Set Rank1OperInfTimes=StatBaseObj.Rank1OperInfTimes  ;1级手术感染次数
		    Set Rank1OperTimes=StatBaseObj.Rank1OperTimes   ;1级手术次数
		    Set Rank2OperInfTimes=StatBaseObj.Rank2OperInfTimes  ;2级手术感染次数
		    Set Rank2OperTimes=StatBaseObj.Rank2OperTimes  ;2级手术次数
		    Set Rank3OperInfTimes=StatBaseObj.Rank3OperInfTimes ;3级手术感染次数
		    Set Rank3OperTimes=StatBaseObj.Rank3OperTimes ;3级手术次数
		    Set VenousBloodInfTimes=StatBaseObj.VenousBloodInfTimes ;中心静脉相关血源性感染次数
		    Set VenousBloodDays=StatBaseObj.VenousBloodDays  ;中心静脉置管使用日数
		    Set RespPlumInfTimes=StatBaseObj.RespPlumInfTimes ;呼吸机相关肺部感染次数
		    Set RespPlumDays=StatBaseObj.RespPlumDays  ;呼吸机使用日数
		    Set CathUrinaryTractInfTimes=StatBaseObj.CathUrinaryTractInfTimes ;留置导尿管相关泌尿道感染次数
		    Set CathOfDays=StatBaseObj.CathOfDays ;留置导尿管病人日数
		    Set BloodInfTimes=StatBaseObj.BloodInfTimes ;与血液透析相关血液感染次数
		    Set HemodialysisTimes=StatBaseObj.HemodialysisTimes ;同期进行血液透析次数
		    Set InfRepID=""
		    For {
				Set InfRepID=$O(^DHCMed.NINFi("InfRep",0,"IndexPaadm",Paadm,InfRepID),-1)	     
				Quit:InfRepID=""
				Set InfRepObj=##Class(DHCMed.NINF.Rep.InfReport).GetObjById(InfRepID)
				Continue:'$IsObject(InfRepObj)
				Set RepStatusObj=InfRepObj.ReportStatus,RepStatus=""
				Continue:'$IsObject(RepStatusObj)
				Continue:(RepStatusObj.Code="5")||(RepStatusObj.Code="0") ;删除、退回的报告不统计
				;感染部位、感染诊断
				Set (InfPosiDesc,InfDiagDesc)=""
				Set PosiDescList=..GetReportOfInfPosiAndDiag(InfRepID)
				Set:InfPosiDesc'="" InfPosiDesc=InfPosiDesc_","_$list(PosiDescList,1)
				Set InfPosiDesc=$list(PosiDescList,1)
				Set:InfDiagDesc'="" InfDiagDesc=InfDiagDesc_","_$list(PosiDescList,2)
				Set InfDiagDesc=$list(PosiDescList,2)
				;检验标本、检验病原体
				Set (TestSpecimensDesc,InfPathogenDesc)=""
				Set SpecimensList=..GetReportOfTestSpeciAndPathogen(InfRepID)
				Set TestSpecimensDesc=$list(SpecimensList,1)
				Set InfPathogenDesc=$list(SpecimensList,2)
				
		    }
		    Continue:(Type=1)&&(RepCount<1)  ;不是院感病人过滤
		    Continue:(Type=2)&&(OperRelaInfTimes<1) ;不是手术相关的过滤
		    Continue:(Type=3)&&(OperTimes<1)  ;不是手术病人过滤
		    Continue:(Type=4)&&(SeleOperInfTimes<1) ;过滤非择期手术感染
		    Continue:(Type=5)&&(SeleOperBellInfTimes<1) ;过滤非择期肺部感染
		    Continue:(Type=6)&&(SeleOperTimes<1) ;过滤非择期手术
		    Continue:(Type=7)&&(Rank0OperInfTimes<1)
		    Continue:(Type=8)&&(Rank0OperTimes<1)
		    Continue:(Type=9)&&(Rank1OperInfTimes<1)
		    Continue:(Type=10)&&(Rank1OperTimes<1)
		    Continue:(Type=11)&&(Rank2OperInfTimes<1)
		    Continue:(Type=12)&&(Rank2OperTimes<1)
		    Continue:(Type=13)&&(Rank3OperInfTimes<1)
		    Continue:(Type=14)&&(Rank3OperTimes<1)      
		    Continue:(Type=15)&&(OperBellInfTimes<1)     ;手术肺部感染
		    Continue:(Type=16)&&(OperPosiInfTimes<1)     ;手术部位感染
		    Continue:(Type=17)&&((IsNewBorn="N")||(RepCount<1)) ;新生儿感染
		    Continue:(Type=18)&&(IsNewBorn="N")  ;新生儿出院
		    Continue:(Type=19)&&(VenousBloodInfTimes<1) ;血源性感染次数
		    Continue:(Type=20)&&(VenousBloodDays<1) ;置管病人日数
		    Continue:(Type=21)&&(RespPlumInfTimes<1) ;呼吸机肺部感染
		    Continue:(Type=22)&&(RespPlumDays<1)
		    Continue:(Type=23)&&(CathUrinaryTractInfTimes<1) 
		    Continue:(Type=24)&&(CathOfDays<1)
		    Continue:(Type=25)&&(BloodInfTimes<1)
		    Continue:(Type=26)&&(HemodialysisTimes<1)
		    
		    Set OutData=OutData_$lb(InfPosiDesc,InfDiagDesc,TestSpecimensDesc,InfPathogenDesc,RepCount,Paadm)
		    Set ^CacheTemp(repid,ind)=OutData
		    Set ind=ind+1	
		}
	}
	Quit $$$OK
}

ClassMethod QueryReportByDischDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryReportByDischDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryReportByDischDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryReportByDischDateExecute ]
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

/// 描述：根据就诊ID获取病人相关信息
ClassMethod GetPatOfAdmInfo(Paadm As %String)
{
	 New (Paadm)	
	 Set Rtn="",Data=""
	 Set PaadmObj=##Class(DHCMed.Base.PatientAdm).GetObjById(Paadm)
	 Quit:'$IsObject(PaadmObj) Rtn
	 Set Papmi=PaadmObj.PatientID
	 Set PatientInfoObj=##Class(DHCMed.Base.Patient).GetObjById(Papmi)
	 Quit:'$IsObject(PatientInfoObj) Rtn
       Set PapmiNo=PatientInfoObj.PapmiNo
       Set MrNo=PatientInfoObj.InPatMrNo
       Set PatName=PatientInfoObj.PatientName
       Set Sex=PatientInfoObj.Sex
       Set Age=PatientInfoObj.Age                        ;年
       Set AgeMonth=PatientInfoObj.AgeMonth     ;月
       Set AgeDay=PatientInfoObj.AgeDay            ;天
       Set AdmDate=PaadmObj.AdmitDate
       Set DischDate=PaadmObj.DisDate
       Set AdmLoc=PaadmObj.Department
       Set AdmWard=PaadmObj.Room
       Set BedNo=PaadmObj.Bed
       Set Data=$lb(PapmiNo,MrNo,PatName,Sex,Age,AdmDate,DischDate,AdmLoc,AdmWard,BedNo)
       Quit Data
}

/// 描述：获取感染部位和感染诊断
ClassMethod GetReportOfInfPosiAndDiag(InfRepID As %String)
{
	New (InfRepID)
	;感染部位
	Set SubPosiID=0,InfPosiDesc="",InfDiagDesc="",Data=""
	For {
		Set SubPosiID=$o(^DHCMed.NINF("InfRep",InfRepID,"InfPos",SubPosiID))
		Quit:SubPosiID=""
					
		Set PosiObj=##Class(DHCMed.NINF.Rep.InfReportInfPos).GetObjById(InfRepID_"||"_SubPosiID)
		Continue:'$IsObject(PosiObj)
		Set DescObj=PosiObj.InfPos
		If ($IsObject(DescObj)){
			Set Desc=DescObj.IPDesc
			If (InfPosiDesc=""){ 
			    Set InfPosiDesc=Desc
			}
			ElseIf(InfPosiDesc'=""){
			    Set InfPosiDesc=InfPosiDesc_","_Desc
			}
		}
		Set DiagObj=PosiObj.InfDiag
		If ($IsObject(DiagObj)){
	       	Set DiagDesc=DiagObj.IDDesc
			If (InfDiagDesc=""){
			    Set InfDiagDesc=DiagDesc
			}ElseIf(InfDiagDesc'=""){
		          Set InfDiagDesc=InfDiagDesc_","_DiagDesc
		     }
		}
	}	
	Set Data=$lb(InfPosiDesc,InfDiagDesc)
	Quit Data
}

/// 描述：获取院感报告中的检验标本、检验病原体
/// Debug:w ##Class(DHCMed.NINFService.Sta.InfStatTargetQry).GetReportOfTestSpeciAndPathogen(30)
ClassMethod GetReportOfTestSpeciAndPathogen(InfRepID As %String)
{
	New (InfRepID)
	;检验标本、检验病原体
	Set SubLabID=0,TestSpecimensDesc="",InfPathogenDesc="",Data=""
	For {
		Set SubLabID=$O(^DHCMed.NINF("InfRep",InfRepID,"Lab",SubLabID))
		Quit:SubLabID=""
					
		Set LabObj=##Class(DHCMed.NINF.Rep.InfReportLab).GetObjById(SubLabID)
		Continue:'$IsObject(LabObj)
		Set SpeciObj=LabObj.Specimen
		If ($IsObject(SpeciObj)){
			Set SpeciDesc=SpeciObj.Description
			If (TestSpecimensDesc=""){
				Set TestSpecimensDesc=SpeciDesc
			} ElseIf(TestSpecimensDesc=""){
				Set TestSpecimensDesc=TestSpecimensDesc_","_SpeciDesc
			}
		}
		Set TestResultList=LabObj.TestResults
		For TRIndex=1:1:TestResultList.Count() {
			Set TestResultObj=TestResultList.GetAt(TRIndex)
			Continue:'$IsObject(TestResultObj)
			Set TestResultDesc=TestResultObj.PathogenyDesc
		      If (InfPathogenDesc=""){
			     Set InfPathogenDesc=TestResultDesc
		      }ElseIf(InfPathogenDesc'=""){
			     Set InfPathogenDesc=InfPathogenDesc_","_TestResultDesc
		      }
		}
	}	
	Set Data=$lb(TestSpecimensDesc,InfPathogenDesc)
	Quit Data
}

/// 获取病人院感报告手术部分信息
/// 输出：手术名称、手术类型、手术开始时间、手术结束时间、手术医生、麻醉方法、切口类型、愈合情况、切口感染、感染类型、是否引起院内感染
ClassMethod GetOperOfReport(InfRepID, OutData, Ind, RepId)
{
	New (InfRepID,OutData,Ind,RepId)
      //从院感报告手术相关信息中获取上报手术信息
	Set ResultSet=##Class(%Library.ResultSet).%New("DHCMed.NINFService.Rep.InfReportOpr:QrySubRec"),IsOperPosiPat="N",IsSeleOper="N"
	Do ResultSet.Execute(InfRepID,"")	
	While(ResultSet.Next()){
		Set (OperName,OperType,OperStaDate,OperEndDate,Operator,AnaeType,CuteType,CloseUpType,CuteInf,InfType,IsHospInf)=""
		Set OperName=ResultSet.Data("OperationDesc")
		Set OperType=ResultSet.Data("OperationTypeDesc")
		Continue:ResultSet.Data("OperStartDate")=""
		Set OperStaDate=$s(ResultSet.Data("OperStartDate")'="":ResultSet.Data("OperStartDate")_" "_ResultSet.Data("OperStartTime"),1:ResultSet.Data("OperStartDate"))
		Set OperEndDate=$s(ResultSet.Data("OperEndDate")'="":ResultSet.Data("OperEndDate")_" "_ResultSet.Data("OperEndTime"),1:ResultSet.Data("OperEndDate"))
		Set Operator=ResultSet.Data("OperDocDesc")
		Set AnaeType=ResultSet.Data("AnesthesiaDesc")
		Set CuteType=ResultSet.Data("CuteTypeDesc")
		Set CloseUpType=ResultSet.Data("CuteHealingDesc")
		Set CuteInf=ResultSet.Data("CuteInfFlagDesc")
		Set InfType=ResultSet.Data("OperInfTypeDesc")
		Set IsHospInf=ResultSet.Data("InHospInfFlagDesc")
		Set OutPutData=OutData_$lb(OperName,OperType,OperStaDate,OperEndDate,Operator,AnaeType,CuteType,CloseUpType,CuteInf,InfType,IsHospInf)
		Set ^CacheTemp(RepId,Ind)=OutPutData
		Set Ind=Ind+1
     }
     Do ResultSet.Close()
}

/// 手术分级查询
/// Debug:w ##Class(%ResultSet).RunQuery("DHCMed.NINFService.Sta.InfStatTargetQry","OperationInfoQuery","277")
Query OperationInfoQuery(Paadm As %String) As %Query(ROWSPEC = "PatName:%String,AdmDate:%String,AdmLoc:%String,OperationName:%String,OperationType:%String,Operator:%String,OperDate:%String,Duration:%String,ASARank:%String,CutType:%String,OperRank:%String,NarcosisType:%String,OperPosition:%String,DataSource:%String,IsInf:%String") [ SqlProc ]
{
}

ClassMethod OperationInfoQueryExecute(ByRef qHandle As %Binary, Paadm As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
      Set ^Test=Paadm
	Set OprID=0,NPaadm=" "_Paadm
	For {
		Set OprID=$o(^DHCMed.NINF.Srv.InfStatOperI("IndexOfPaadm",NPaadm,OprID))
		Quit:OprID=""
		
		Set OprObj=##Class(DHCMed.NINF.Srv.InfStatOperInfo).%OpenId(OprID)
		Continue:'$IsObject(OprObj)
		Set OperationName=OprObj.OperationName
		Set OperationType=OprObj.OperationType
		Set Operator=OprObj.Operator
		Set OperDate=$zd(OprObj.OperDate,3)
		Set Duration=OprObj.Duration
		Set ASARank=OprObj.ASARank
		Set CutType=OprObj.CutType
		Set OperRank=OprObj.OperRank
		Set NarcosisType=OprObj.NarcosisType
		Set OperPosition=OprObj.OperPosition
		Set DataSource=OprObj.DataSource
		Set IsInf=OprObj.IsInf
		Set:IsInf="Y" IsInf="是"
		Set:IsInf="N" IsInf="否"
		Set PaadmObj=##Class(DHCMed.Base.PatientAdm).GetObjById(Paadm)
		Set (PatName,AdmDate,AdmLoc)=""
		If ($IsObject(PaadmObj)){
			Set Papmi=PaadmObj.PatientID
			Set PapmiObj=##Class(DHCMed.Base.Patient).GetObjById(Papmi)
			Set:$IsObject(PapmiObj) PatName=PapmiObj.PatientName
			Set AdmDate=PaadmObj.AdmitDate
			Set AdmLoc=PaadmObj.Department
		}
		Set Data=$lb(PatName,AdmDate,AdmLoc,OperationName,OperationType,Operator,OperDate,Duration,ASARank,CutType,OperRank,NarcosisType,OperPosition,DataSource,IsInf)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
   Quit $$$OK
}

ClassMethod OperationInfoQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = OperationInfoQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod OperationInfoQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = OperationInfoQueryExecute ]
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

/// 描述：根据Paadm取ICU相关信息
/// Debug:w ##Class(%ResultSet).RunQuery("DHCMed.NINFService.Sta.InfStatTargetQry","ICUInfoQuery","277")
Query ICUInfoQuery(Paadm As %String) As %Query(ROWSPEC = "PatName:%String,AdmDate:%String,AdmLoc:%String,InICUDate:%String,OutICUDate:%String,InDate:%String,OutDate:%String,InfDate:%String,Address:%String,Type:%String") [ SqlProc ]
{
}

ClassMethod ICUInfoQueryExecute(ByRef qHandle As %Binary, Paadm As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	Set NPaadm=" "_Paadm,ICUID=0
      For {
		Set ICUID=$O(^DHCMed.NINF.Srv.InfStatICUInfI("IndexOfPaadm",NPaadm,ICUID))   
		Quit:ICUID=""
		
		Set ICUObj=##Class(DHCMed.NINF.Srv.InfStatICUInfo).%OpenId(ICUID)
		Continue:'$IsObject(ICUObj)
		Set PaadmObj=##Class(DHCMed.Base.PatientAdm).GetObjById(Paadm)
		Set (PatName,AdmDate,AdmLoc)=""
		If ($IsObject(PaadmObj)){
			Set Papmi=PaadmObj.PatientID
			Set PapmiObj=##Class(DHCMed.Base.Patient).GetObjById(Papmi)
			Set:$IsObject(PapmiObj) PatName=PapmiObj.PatientName
			Set AdmDate=PaadmObj.AdmitDate
			Set AdmLoc=PaadmObj.Department
		}
		;PatName:%String,AdmDate:%String,AdmLoc:%String,InICUDate:%String,OutICUDate:%String,InDate:%String,OutDate:%String,InfDate:%String,Address:%String,Type:%String
		Set (InICUDate,OutICUDate,InDate,OutDate,InfDate,Address,Type)=""
		Set InICUDate=ICUObj.InICUDate,
		      OutICUDate=ICUObj.OutICUDate,
		      InDate=ICUObj.InDate,
		      OutDate=ICUObj.OutDate,
		      InfDate=ICUObj.InfDate,
		      Address=ICUObj.Address,
		      Type=ICUObj.Type
		Set:+InICUDate>0 InICUDate=$zd(InICUDate,3)
		Set:+OutICUDate>0 OutICUDate=$zd(OutICUDate,3)
		Set:+InDate>0 InDate=$zd(InDate,3)
		Set:+OutDate>0 OutDate=$zd(OutDate,3)
		Set:+InfDate>0 InfDate=$zd(InfDate,3)
		Set:Type="VC" Type="静脉插管"
		Set:Type="VT" Type="呼吸机"
		Set:Type="C" Type="导尿管"
	     Set Data=$lb(PatName,AdmDate,AdmLoc,InICUDate,OutICUDate,InDate,OutDate,InfDate,Address,Type)
	     Set ^CacheTemp(repid,ind)=Data
	     Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod ICUInfoQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ICUInfoQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod ICUInfoQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ICUInfoQueryExecute ]
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
