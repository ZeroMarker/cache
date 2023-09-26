Include webimport

Class web.DHCExamPatList Extends DHCDoc.Util.RegisteredObject [ ProcedureBlock ]
{

Query RegFind(UserID As %String, PatNo As %String, OutStatus As %String, InStatus As %String, DisInStatus As %String, Startdate As %String, Enddate As %String, WardID As %String, FindbyDoc As %String, CTLoc As %String, WardDesc As %String, PAAdmRowId As %String = "", luloc As %String = "", AdmDocId As %String = "", RequestName As %String = "", RequestPatMed As %String = "") As %Query(ROWSPEC = "AdmDate:%String,AdmTime:%String,AdmDoc:%String,AdmReason:%String,AdmType:%String,PAAdmWard:%String,PAAdmBed:%String,AdmDept:%String,PatientID:%String,EpisodeID:%String,AdmDischgDate:%String,MRDiagnoseDesc:%String,SeeDoctor:%String,TimeRange:%String,VisitStatus:%String,PAADMDischgTime:%String,SerialNumber:%String,PatName1:%String,PatSex1:%String,PatientMedicare:%String,PatPoliticalLevel:%String,PatSecretLevel:%String,baseinfo:%String,AddPilotProPat:%String,RegNo:%String,TelPhone:%String,PatAge:%String,PatCredNo:%String,WardId:%String")
{
}

ClassMethod RegFindClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = RegFindExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// modify：郭荣勇
/// date:2017-06-29
/// desc：根据页面查询条件获取患者信息，具体说明如下(优先级从高到底排序)：
/// 		1. 查询门诊患者：患者登记号+日期 或者 科室+姓名+日期  或者 姓名+日期
/// 		2. 查询在院患者：科室 或者 病区  或者 病人登记号 或者 姓名
/// 		3. 查询出院患者：科室 或者 病区  或者 病人登记号 或者 日期
/// d ##class(%ResultSet).RunQuery("web.DHCExamPatList","RegFind",10209,"0000000078","","on","","","","","","","","","","","住院2","100035^^^")
ClassMethod RegFindExecute(ByRef qHandle As %Binary, UserID As %String, PatNo As %String, OutStatus As %String, InStatus As %String, DisInStatus As %String, Startdate As %String, Enddate As %String, WardID As %String = "", FindbyDoc As %String = "", CTLoc As %String = "", WardDesc As %String = "", PAAdmRowId As %String = "", luloc As %String = "", AdmDocId As %String = "", RequestName As %String = "", RequestPatMed As %String = "") As %Status
{
	s ^temp("RegFindExecute")=UserID_","_PatNo_","_OutStatus_","_InStatus_","_DisInStatus_","_Startdate_","_Enddate_","_WardID_","_FindbyDoc_","_CTLoc_","_WardDesc_","_PAAdmRowId_","_luloc_","_AdmDocId_","_RequestName_","_RequestPatMed
	s ^TEMP("QP",111)=$LB(UserID,PatNo,OutStatus,InStatus,DisInStatus,Startdate,Enddate,WardID,FindbyDoc,CTLoc,WardDesc,PAAdmRowId,luloc,AdmDocId,RequestName,RequestPatMed)
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	k ^Temp("PersonSort")
  	k ^TempPAADMRowIDStr(repid)
  	Set langid=..%LanguageID()
	set (AdmDate,AdmTime,AdmDoc,AdmReason,AdmType,PAAdmWard,PAAdmBed,AdmDept,PatientID,EpisodeID,AdmDischgDate,VisitStatus,PAADMDischgTime,Admdepdesc,Admdepcode)=""
   	s counter=0,temp="",MasterDoc="",MRDiagnoseDesc="",MRDiagnoseID="",quitFlag="",RegFeeID="",TimeRange=""
   	
  	s Diagnosis=$p(RequestPatMed,"^",2)
  	s SAge=$p(RequestPatMed,"^",3)
  	s EAge=$p(RequestPatMed,"^",4)
  	s HospID=$p(RequestPatMed,"^",5)
  	s PreFlag=$p(RequestPatMed,"^",6)
	s PatType=$p(RequestPatMed,"^",7)
  	s RequestPatMed=$p(RequestPatMed,"^",1)
  	i $d(%request) {
	  	i RequestName="" s RequestName=%request.Get("Name")
	  	i RequestPatMed="" s RequestPatMed=%request.Get("PatMed")
  	}
  	
  	i $d(%session) {
	  	i UserID="" s UserID=%session.Data("LOGON.USERID")
	  	if HospID ="" s HospID=%session.Get("LOGON.HOSPID")
  	}
    i UserID'="" {
    	s Sub=1 
    	k ^TEMPDHCExamPatList("DHCExamPatList",UserID)
    }
    i Startdate'="" s Startdate=..%ZDH(Startdate)
    i Enddate'="" s Enddate=..%ZDH(Enddate)
    
    if ((WardID'="")&&($g(PatNo)="")) {
	   s EpisodeID=0,roomID=0
	   if (DisInStatus="on") {
		  d DisInPatListByDisDate
	   }
	   if (InStatus="on") {
		  d InPatListByWard("I")
	   }
	   if (OutStatus="on"){
		   d InPatListByWard("E")
	   }
	   d SortPatListNew
	   k ^TempPAADMRowIDStr(repid)
	   Set qHandle=$lb(0,repid,0)
	   Quit $$$OK
	}elseif ($g(PatNo)'=""){
	   s FindPatPapmi=$o(^PAPERi("PAPMI_PatNo",$ZCVT(PatNo,"U"),0))
	   if FindPatPapmi'=""{
			if (OutStatus="on") do OutPatListByPat
			if (InStatus="on") do InPatListByPat
			if (DisInStatus="on") do DisInPatListByPat
			if (PreFlag="on") do PrePatListByPat
	    }
		d SortPatListNew
	    k ^TempPAADMRowIDStr(repid)
	    Set qHandle=$lb(0,repid,0)
	    Quit $$$OK
	}
	
	if ((PatNo="")&&(WardID="")&&(RequestName'="")&&(luloc="")){  //&&(OutStatus="on")
 	    set FindPatPapmi=""
 	    if (OutStatus="on"){
	 	    For FindDate = Startdate:1:Enddate {
			   do OutPatListByDate
            }
	 	}
	 	s NameStandard=$ZConvert(RequestName,"U") 
		if (InStatus="on"){
			Set PAPERName1 = $o(^PAPERi("PAPER_PatName",NameStandard)) //模糊查询
			while(PAPERName1'="")
		    {
			    if (($ZConvert(PAPERName1,"U") )[NameStandard)
			    {
				    s FindPatPapmi=""
					s FindPatPapmi=$o(^PAPERi("PAPER_PatName",PAPERName1,FindPatPapmi))
					while(FindPatPapmi'="")
					{
						do InPatListByPat
						s FindPatPapmi=$o(^PAPERi("PAPER_PatName",PAPERName1,FindPatPapmi))
					}
				}
				Set PAPERName1 = $o(^PAPERi("PAPER_PatName",PAPERName1)) 
			}
			d SortPatListNew
			k ^TempPAADMRowIDStr(repid)
			Set qHandle=$lb(0,repid,0)
	        Quit $$$OK
	 	}
        	
	}
	//根据科室ID取科室病区ID串,门诊则为就诊科室查询
	if ((PatNo="")&&(WardID="")&&(PAAdmRowId="")&&(luloc'="")&&(RequestName="")){
		s WardIdStr=""
	    //s WardIdStr=..GetWardIdByLocId(luloc)
	    Set rset=##Class(%ResultSet).%New("web.DHCExamPatList:GetWardMessage")
		If rset.QueryIsValid() { 
			Set Status=rset.Execute("",luloc,HospID)
			If 'Status Quit
			Set columns = rset.GetColumnCount()
			While (rset.Next()) {
				i WardIdStr="" s WardIdStr=rset.Data("HIDDEN")
				e  s WardIdStr=WardIdStr_"^"_rset.Data("HIDDEN")
			}
		}
	    s locType=$o(^PAC("ADMLOC",0,"AdmType","O",luloc,""))
	    i locType="" s locType=$o(^PAC("ADMLOC",0,"AdmType","E",luloc,""))
	    b ;WardIdStr
	    /*
	    d ##class(%ResultSet).RunQuery("web.DHCExamPatList","RegFind","600","0000000001","","on","","62954","62956","","","ZXYJHYK-中西医结合一科")
	    */
	    s len=$l(WardIdStr,"^")
	    f i=1:1:len {
		    s WardID=$p(WardIdStr,"^",i)
		    s WardID=$g(WardID)
			continue:WardID=""
			
		    if (DisInStatus="on") {
	            d DisInPatListByDisDate
	        }
	        if (InStatus="on") {
		        d InPatListByWard("I")
	        }
		}
		if (((len=1)||(locType'=""))&&(OutStatus="on")) {
			set FindPatPapmi="",WardID=""
            For FindDate = Startdate:1:Enddate {
		        do OutPatListByDate
	        }	
		}
		d SortPatListNew
		k ^TempPAADMRowIDStr(repid)
		Set qHandle=$lb(0,repid,0)
	    Quit $$$OK
	}
	b ;002
	//查询门诊患者，直接按开始与结束日期查询这段时间门诊的患者
	if (OutStatus="on") {
		b ;0022
		set FindPatPapmi=""
		For FindDate = Startdate:1:Enddate {
			   do OutPatListByDate
        }
	}
	
	//查询出院患者，直接按开始与结束日期查询这段时间出院的患者
	b ;003
	if (DisInStatus="on") { //&&(CTLoc'="")&&(WardID="")
		i $g(^DHCDishChargeSet("Disch","ifGetDischgDateTimeByDoc",HospID))="Y" d
		.s PAADMDischgDate="" 
		.f  s PAADMDischgDate=$o(^PAADMi("DischargeDateExt",PAADMDischgDate)) q:PAADMDischgDate=""  d
		..q:((PAADMDischgDate>Enddate)||(PAADMDischgDate<Startdate))
		..s tmpEpisodeID="" f  s tmpEpisodeID=$o(^PAADMi("DischargeDateExt",PAADMDischgDate,tmpEpisodeID)) q:tmpEpisodeID=""  d
		...q:((tmpEpisodeID=0)||(tmpEpisodeID=""))	   
	    ...s FindPatPapmi=$p(^PAADM(tmpEpisodeID),"^",1)
	    ...q:($p(^PAADM(tmpEpisodeID),"^",70)'=WardID)&&(WardID'="")
	    ...q:$d(^TempPAADMRowIDStr(repid,tmpEpisodeID))
		...d DisInPatListByPat
		e  d
		.s PAADMDischgDate="" 
		.f  s PAADMDischgDate=$o(^PAADMi("DischDate",PAADMDischgDate)) q:PAADMDischgDate=""  d
		..q:((PAADMDischgDate>Enddate)||(PAADMDischgDate<Startdate))
		..s tmpEpisodeID=""
		..f  s tmpEpisodeID=$o(^PAADMi("DischDate",PAADMDischgDate,tmpEpisodeID)) q:tmpEpisodeID=""  d
		...q:((tmpEpisodeID=0)||(tmpEpisodeID=""))	   
	    ...s FindPatPapmi=$p(^PAADM(tmpEpisodeID),"^",1)
	    ...q:($p(^PAADM(tmpEpisodeID),"^",70)'=WardID)&&(WardID'="")
	    ...q:$d(^TempPAADMRowIDStr(repid,tmpEpisodeID))
		...do DisInPatListByPat
	}
	
	//新增-查询住院患者，直接按开始与结束日期查询这段时间住院的患者
	b ;004
	if (InStatus="on") { 
		b ;0044
		s PAADMAdmDate="" 
		f  s PAADMAdmDate=$o(^PAADMi("PAADM_AdmDate",PAADMAdmDate)) q:PAADMAdmDate=""  d
		.q:((PAADMAdmDate>Enddate)||(PAADMAdmDate<Startdate))
		.s tmpEpisodeID=""
		.f  s tmpEpisodeID=$o(^PAADMi("PAADM_AdmDate",PAADMAdmDate,tmpEpisodeID)) q:tmpEpisodeID=""  d
		..q:((tmpEpisodeID=0)||(tmpEpisodeID=""))	   
	    ..s FindPatPapmi=$p(^PAADM(tmpEpisodeID),"^",1)
	    ..q:(WardID'="")&&($p(^PAADM(tmpEpisodeID),"^",70)'=WardID)
		..do InPatListByPat
	}
	if (PreFlag="on") { 
		b ;0044
		s PAADMAdmDate="" 
		f  s PAADMAdmDate=$o(^PAADMi("PAADM_AdmDate",PAADMAdmDate)) q:PAADMAdmDate=""  d
		.q:((PAADMAdmDate>Enddate)||(PAADMAdmDate<Startdate))
		.s tmpEpisodeID=""
		.f  s tmpEpisodeID=$o(^PAADMi("PAADM_AdmDate",PAADMAdmDate,tmpEpisodeID)) q:tmpEpisodeID=""  d
		..q:((tmpEpisodeID=0)||(tmpEpisodeID=""))	   
	    ..s FindPatPapmi=$p(^PAADM(tmpEpisodeID),"^",1)
	    ..//q:(WardID'="")&&($p(^PAADM(tmpEpisodeID),"^",70)'=WardID)
		..do PrePatListByPat
	}
	d SortPatListNew
	k ^TempPAADMRowIDStr(repid)
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
 //在院
InPatListByPat
    s PaadmRowid=0 f  s PaadmRowid=$o(^PAPERdr(FindPatPapmi,"ADM","I",PaadmRowid)) q:PaadmRowid=""  d
    .q:$d(^TempPAADMRowIDStr(repid,PaadmRowid))
	.q:(PAAdmRowId'="")&&(PAAdmRowId'=PaadmRowid)
    .s VisitStatus=$p($g(^PAADM(PaadmRowid)),"^",20)
    .q:(VisitStatus'="A")
    .s PAPMI=$p($g(^PAADM(PaadmRowid)),"^",1)
    .q:FindPatPapmi'=PAPMI
    .s patientName=$p($g(^PAPER(PAPMI,"ALL")),"^",1)
    .q:(RequestName'="")&&(($ZConvert(patientName,"U"))'[($ZConvert(RequestName,"U")))
    .s EpisodeID=PaadmRowid
    .s Admdepcode=$p($g(^PAADM(PaadmRowid)),"^",4)
    .s LocHospId=$p(^CTLOC(Admdepcode),"^",22)
	.q:(HospID'="")&&(LocHospId'=HospID)
	.s Admdepdesc=$p(^CTLOC(Admdepcode),"^",2)
	.s Admdepdesc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",Admdepdesc,langid)
 	.q:(CTLoc'="")&&(Admdepdesc'=CTLoc)
 	.s AdmDate=$p($g(^PAADM(PaadmRowid)),"^",6)
 	.q:(Startdate'="")&&(AdmDate<Startdate)
	.q:(Enddate'="")&&(AdmDate>Enddate)
	.q:($p(^PAADM(PaadmRowid),"^",70)'=WardID)&&(WardID'="")
	.s PatientID=PAPMI
    .s EpisodeID=PaadmRowid
    .do PatAdmInfo
    .do OutputRow
    .s ^TempPAADMRowIDStr(repid,PaadmRowid)=1
    .b ;ins
    quit
 //预住院
PrePatListByPat
    s PaadmRowid=0 f  s PaadmRowid=$o(^PAPERdr(FindPatPapmi,"ADM","I",PaadmRowid)) q:PaadmRowid=""  d
    .q:$d(^TempPAADMRowIDStr(repid,PaadmRowid))
	.q:(PAAdmRowId'="")&&(PAAdmRowId'=PaadmRowid)
    .s VisitStatus=$p($g(^PAADM(PaadmRowid)),"^",20)
    .q:(VisitStatus'="P")
    .s PAPMI=$p($g(^PAADM(PaadmRowid)),"^",1)
    .q:FindPatPapmi'=PAPMI
    .s patientName=$p($g(^PAPER(PAPMI,"ALL")),"^",1)
    .q:(RequestName'="")&&(($ZConvert(patientName,"U"))'[($ZConvert(RequestName,"U")))
    .s EpisodeID=PaadmRowid
    .s Admdepcode=$p($g(^PAADM(PaadmRowid)),"^",4)
    .s LocHospId=$p(^CTLOC(Admdepcode),"^",22)
	.q:(HospID'="")&&(LocHospId'=HospID)
	.s Admdepdesc=$p(^CTLOC(Admdepcode),"^",2)
	.s Admdepdesc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",Admdepdesc,langid)
 	.q:(CTLoc'="")&&(Admdepdesc'=CTLoc)
 	.s AdmDate=$p($g(^PAADM(PaadmRowid)),"^",6)
 	.q:(Startdate'="")&&(AdmDate<Startdate)
	.q:(Enddate'="")&&(AdmDate>Enddate)
	.s PatientID=PAPMI
    .s EpisodeID=PaadmRowid
    .do PatAdmInfo
    .do OutputRow
    .s ^TempPAADMRowIDStr(repid,PaadmRowid)=1
    .b ;ins
    quit
InPatListByWard(Type)
    set roomID=""
	f  s roomID=$o(^PAADMi("CurrWard",WardID,roomID)) q:roomID=""  d
	.f  s EpisodeID=$o(^PAADMi("CurrWard",WardID,roomID,EpisodeID)) q:EpisodeID=""  d  
	..q:(PAAdmRowId'="")&&(PAAdmRowId'=EpisodeID)
    ..s VisitStatus=$p($g(^PAADM(EpisodeID)),"^",20)
	..s PatientID=$p(^PAADM(EpisodeID),"^",1)
	..s admglobalstr=$g(^PAADM(EpisodeID))
	..s AdmDate=$p(admglobalstr,"^",6)
	..Q:(AdmDate<Startdate)&&(Startdate'="")
	..Q:(AdmDate>Enddate)&&(Enddate'="")
	..s AdmType=$p(admglobalstr,"^",2)
	..q:AdmType'=Type
	..q:(VisitStatus'="A")&&(VisitStatus'="P")
	..s patientName=$p($g(^PAPER(PatientID,"ALL")),"^",1)
	..q:((RequestName'="")&&(($ZConvert(patientName,"U"))'[($ZConvert(RequestName,"U"))))
	..s Admdepcode=$p($g(^PAADM(EpisodeID)),"^",4)
	..s LocHospId=$p(^CTLOC(Admdepcode),"^",22)
	..q:(HospID'="")&&(LocHospId'=HospID)
	..s Admdepdesc=$p(^CTLOC(Admdepcode),"^",2)
	..s Admdepdesc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",Admdepdesc,langid)
 	..q:(CTLoc'="")&&(Admdepdesc'=CTLoc)
	..s admdocdr=$p(admglobalstr,"^",9)
	..q:(AdmDocId'="")&&(admdocdr'=AdmDocId)
	..do PatAdmInfo
	..do OutputRow
	
	quit
	
DisInPatListByDisDate
	if Startdate="" s PAADMDischgDate=..%SysDate()
	e  s PAADMDischgDate=Startdate
    ;s PAADMDischgDate="" ;..%SysDate()
    i $g(^DHCDishChargeSet("Disch","ifGetDischgDateTimeByDoc",HospID))="Y" {
		f  s PAADMDischgDate=$o(^PAADMi("DischargeDateExt",PAADMDischgDate)) q:PAADMDischgDate=""  d
		.q:((PAADMDischgDate>Enddate)||(PAADMDischgDate<Startdate))
		.s tmpEpisodeID="" 
		.f  s tmpEpisodeID=$o(^PAADMi("DischargeDateExt",PAADMDischgDate,tmpEpisodeID)) q:tmpEpisodeID=""  d
		..d DisInPatListByDisDateSort
    }else{
		s PAADMDischgDate="" f  s PAADMDischgDate=$o(^PAADMi("DischDate",PAADMDischgDate)) q:PAADMDischgDate=""  d
		.q:((PAADMDischgDate>Enddate)||(PAADMDischgDate<Startdate))
		.s tmpEpisodeID=""
		.f  s tmpEpisodeID=$o(^PAADMi("DischDate",PAADMDischgDate,tmpEpisodeID)) q:tmpEpisodeID=""  d
		..d DisInPatListByDisDateSort
	}
	q
DisInPatListByDisDateSort
	q:((tmpEpisodeID=0)||(tmpEpisodeID=""))
    s quitFlag=""
    s PAPMIDR=$p(^PAADM(tmpEpisodeID),"^",1)
    s papmidob=$p(^PAPER(PAPMIDR,"ALL"),"^",6)    //取出生日期
	s PatAge=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.reg.GetPapmiAge",PAPMIDR,"",HospID)
	//($Horolog-papmidob)\365.25
	if (PatAge'["岁") s PatAge1=0
	else  s PatAge1=+PatAge
	q:(SAge'="")&&(PatAge1<SAge)
	q:(EAge'="")&&(PatAge1>EAge)
    //只取最新的就诊记录
    s LastEpisodeID=$o(^PAPERdr(PAPMIDR,"ADM","I",""),-1)
    q:(LastEpisodeID="")
	q:(PAAdmRowId'="")&&(PAAdmRowId'=EpisodeID)
	s EpisodeID=tmpEpisodeID
	s admWardID=$p(^PAADM(EpisodeID),"^",70)
    q:(admWardID'=WardID)
    q:$d(^TempPAADMRowIDStr(repid,EpisodeID))
    s VisitStatus=$p($g(^PAADM(EpisodeID)),"^",20)
	s PatientID=$p(^PAADM(EpisodeID),"^",1)
	s admglobalstr=$g(^PAADM(EpisodeID))
	s AdmType=$p(admglobalstr,"^",2)
	q:AdmType'="I"
	q:(VisitStatus'="D")	
	s patientName=$p($g(^PAPER(PatientID,"ALL")),"^",1)
	q:((RequestName'="")&&(($ZConvert(patientName,"U"))'[($ZConvert(RequestName,"U"))))
	s Admdepcode=$p($g(^PAADM(EpisodeID)),"^",4)
	s LocHospId=$p(^CTLOC(Admdepcode),"^",22)
	q:(HospID'="")&&(LocHospId'=HospID)
	s Admdepdesc=$p(^CTLOC(Admdepcode),"^",2)
	s Admdepdesc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",Admdepdesc,langid)
 	q:(CTLoc'="")&&(Admdepdesc'=CTLoc)
 	s AdmDischgDate=$p($g(^PAADM(EpisodeID)),"^",17) //出院日期
 	s TempDischgDate=$p($g(^PAADM(EpisodeID)),"^",17)
 	;取医生出院时间设置
 	i $g(^DHCDishChargeSet("Disch","ifGetDischgDateTimeByDoc",HospID))="Y" d
 	.s AdmDischgDate=$p($g(^PAADM(EpisodeID,"DHC")),"^",29)
	q:((AdmDischgDate>Enddate)||(AdmDischgDate<Startdate))
	s admdocdr=$p(admglobalstr,"^",9)
	q:(AdmDocId'="")&&(admdocdr'=AdmDocId)
	i (FindbyDoc="on") d
	.s careprovID=$p(^SSU("SSUSR",%session.Data("LOGON.USERID")),"^",14)
    .s:careprovID'=admdocdr quitFlag=1
	q:(quitFlag=1)
	;------------排序global记录,用于输出排序处理---------------------
	// 统一做排序
    // s counter=counter+1
    // s ^Temp("PersonSort",TempDischgDate,counter)=PatientID_"^"_EpisodeID
    s ^TempPAADMRowIDStr(repid,EpisodeID)=1
    do PatAdmInfo
    do OutputRow
	quit
DisInPatListByPat
	//s ^DHCA("DisInStatus")=FindDate
	//s PaadmRowid=0 f  s PaadmRowid=$o(^PAADMi("PAADM_AdmDate",FindDate,PaadmRowid)) q:PaadmRowid=""  d
    //有登记号查出院患者不按日期查询
	s PaadmRowid=0 f  s PaadmRowid=$o(^PAPERdr(FindPatPapmi,"ADM","I",PaadmRowid)) q:PaadmRowid=""  d
	.q:(PAAdmRowId'="")&&(PAAdmRowId'=PaadmRowid)
	.q:$d(^TempPAADMRowIDStr(repid,PaadmRowid))
	.s AdmType=$p($g(^PAADM(PaadmRowid)),"^",2)
    .q:(AdmType'="I")
    .s VisitStatus=$p($g(^PAADM(PaadmRowid)),"^",20)
    .q:(VisitStatus'="D")
    .s PAPMI=$p($g(^PAADM(PaadmRowid)),"^",1)
	.Q:(PatNo'="")&&(PAPMI'=$o(^PAPERi("PAPMI_PatNo",$ZCVT(PatNo,"U"),0)))
    .q:FindPatPapmi'=PAPMI
    .s patientName=$p($g(^PAPER(PAPMI,"ALL")),"^",1)
    .q:(RequestName'="")&&(($ZConvert(patientName,"U"))'[($ZConvert(RequestName,"U")))
    .s Admdepcode=$p($g(^PAADM(PaadmRowid)),"^",4)
	.s LocHospId=$p(^CTLOC(Admdepcode),"^",22)
    .q:(HospID'="")&&(LocHospId'=HospID)
    .s Admdepdesc=$p(^CTLOC(Admdepcode),"^",2)
	.s Admdepdesc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",Admdepdesc,langid)
 	.q:(CTLoc'="")&&(Admdepdesc'=CTLoc)
	.s AdmDischgDate1=$p($g(^PAADM(PaadmRowid)),"^",17) //出院日期
	.i $g(^DHCDishChargeSet("Disch","ifGetDischgDateTimeByDoc",HospID))="Y" d
	..s AdmDischgDate1=$p($g(^PAADM(PaadmRowid,"DHC")),"^",29)
	.q:(Startdate'="")&&(AdmDischgDate1<Startdate)
	.q:(Enddate'="")&&(AdmDischgDate1>Enddate)
    .s ^TempPAADMRowIDStr(repid,PaadmRowid)=1
    .;-------------输出内容------------------
    .s PatientID=PAPMI
    .s EpisodeID=PaadmRowid
    .do PatAdmInfo
    .do OutputRow
    
    quit
 //门急诊,体检
OutPatListByDate
	s OutPatName=RequestName
	s PaadmRowid=0 f  s PaadmRowid=$o(^PAADMi("PAADM_AdmDate",FindDate,PaadmRowid)) q:PaadmRowid=""  d
	.q:(PAAdmRowId'="")&&(PAAdmRowId'=PaadmRowid)
	.q:$d(^TempPAADMRowIDStr(repid,PaadmRowid))
    .s VisitStatus=$p($g(^PAADM(PaadmRowid)),"^",20)
    .//q:(VisitStatus'="A")
    .s PAPMI=$p($g(^PAADM(PaadmRowid)),"^",1)
    .s patientName=$p($g(^PAPER(PAPMI,"ALL")),"^",1)
    .q:(($g(PatNo)="")&&(OutPatName'="")&&(patientName'[OutPatName))
    .if ((FindPatPapmi'="")&&(FindPatPapmi'=PAPMI)) q
    .s AdmType=$p($g(^PAADM(PaadmRowid)),"^",2)
    .q:AdmType="I"
    .s Admdepcode=$p($g(^PAADM(PaadmRowid)),"^",4)
    .s LocHospId=$p(^CTLOC(Admdepcode),"^",22)
	.q:(HospID'="")&&(LocHospId'=HospID)
	.s Admdepdesc=$p(^CTLOC(Admdepcode),"^",2)
	.s Admdepdesc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",Admdepdesc,langid)
 	.q:(CTLoc'="")&&(Admdepdesc'=CTLoc)
 	.s PAADMCurrentWardDR=$p($g(^PAADM(PaadmRowid)),"^",70)
 	.q:(WardID'="")&&(PAADMCurrentWardDR'=WardID)
 	.;-------------输出内容------------------
    .s PatientID=PAPMI
    .s EpisodeID=PaadmRowid
    .s ^TempPAADMRowIDStr(repid,EpisodeID)=1
    .do PatAdmInfo
    .do OutputRow
    quit
 //门急诊,体检
OutPatListByPat
	s OutPatName=RequestName
	s admType="" f  s admType=$o(^PAPERdr(FindPatPapmi,"ADM",admType)) q:admType=""  d
	.q:admType="I"
	.s PaadmRowid=0 f  s PaadmRowid=$o(^PAPERdr(FindPatPapmi,"ADM",admType,PaadmRowid)) q:PaadmRowid=""  d
    ..s VisitStatus=$p($g(^PAADM(PaadmRowid)),"^",20)
    ..//q:(VisitStatus'="A")
    ..s PAPMI=$p($g(^PAADM(PaadmRowid)),"^",1)
    ..s Admdepcode=$p($g(^PAADM(PaadmRowid)),"^",4)
    ..s LocHospId=$p(^CTLOC(Admdepcode),"^",22)
	..q:(HospID'="")&&(LocHospId'=HospID)
	..s Admdepdesc=$p(^CTLOC(Admdepcode),"^",2)
	..s Admdepdesc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",Admdepdesc,langid)
 	..q:(CTLoc'="")&&(Admdepdesc'=CTLoc)
 	..s PAADMCurrentWardDR=$p($g(^PAADM(PaadmRowid)),"^",70)
 	..q:(WardID'="")&&(PAADMCurrentWardDR'=WardID)
 	..s AdmDate=$p($g(^PAADM(PaadmRowid)),"^",6)
 	..q:(Startdate'="")&&(AdmDate<Startdate)
	..q:(Enddate'="")&&(AdmDate>Enddate)
 	..;-------------输出内容------------------
    ..s PatientID=PAPMI
    ..s EpisodeID=PaadmRowid
    ..do PatAdmInfo
    ..do OutputRow
    quit

SortPatList
   s counter=$o(^Temp("PersonSort",""))
   while (counter'=""){
	    s temp=$o(^Temp("PersonSort",counter,""))
	    while (temp'=""){
			s Data=^Temp("PersonSort",counter,temp)
			s PatientID=$p(Data,"^",1)
			s EpisodeID=$p(Data,"^",2)
			do PatAdmInfo
    		do OutputRow
	 	 	s temp=$o(^Temp("PersonSort",counter,temp))
	    }
	    s counter=$o(^Temp("PersonSort",counter))
   }

   quit   
PatAdmInfo
	s AdmType=$p($g(^PAADM(EpisodeID)),"^",2)
	s AdmType=$case(AdmType,"I":"住院","O":"门诊","E":"急诊","H":"体检","N":"新生儿",:"")
	s AdmType=##class(websys.Translation).Get("doc.patlistquery.hui.csp",AdmType)
 	s AdmDate=$p($g(^PAADM(EpisodeID)),"^",6)
    s AdmDate=..%ZD(AdmDate) //$zd(AdmDate,3)
    s AdmTime=$p($g(^PAADM(EpisodeID)),"^",7)
    s AdmTime=..%ZT(AdmTime,2)
    s AdmReason=$p($g(^PAADM(EpisodeID,1)),"^",7)
    s:AdmReason'="" AdmReason=$p(^PAC("ADMREA",AdmReason),"^",2)
    s AdmReason=##class(User.PACAdmReason).GetTranByDesc("READesc",AdmReason,langid)
	s Admdepcode=$p($g(^PAADM(EpisodeID)),"^",4)
	s LocHospId=$p(^CTLOC(Admdepcode),"^",22)
    q:(HospID'="")&&(LocHospId'=HospID)
	s Admdepdesc=$p(^CTLOC(Admdepcode),"^",2)
	s Admdepdesc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",Admdepdesc,langid)
 	s AdmDept=$p(Admdepdesc,"-",$l(Admdepdesc,"-"))
 	q:(CTLoc'="")&&(Admdepdesc'=CTLoc)
 	s admdocdr=$p($g(^PAADM(EpisodeID)),"^",9)
	s QueueDr=$o(^User.DHCQueueI("QuePaadmDrIndex",EpisodeID,""))
	if (QueueDr'=""){
		s QueDocDr=$list(^User.DHCQueueD(QueueDr),5)
		if QueDocDr'="" s admdocdr=QueDocDr
	}
 	q:(AdmDocId'="")&&(admdocdr'=AdmDocId) 
 	s CreateUserDr=$p($g(^PAADM(EpisodeID)),"^",43)
    s AdmDischgDate=$p($g(^PAADM(EpisodeID)),"^",17) //出院日期
 	//i AdmDischgDate'="" s AdmDischgDate=$zd(AdmDischgDate,3)
 	s PAADMDischgTime=$p($g(^PAADM(EpisodeID)),"^",18) //出院时间
	//i PAADMDischgTime'="" s PAADMDischgTime=..%ZT(PAADMDischgTime)
	;取医生出院时间设置
	s PAAdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
	i $g(^DHCDishChargeSet("Disch","ifGetDischgDateTimeByDoc",HospID))="Y" d
	.s AdmDischgDate=$p($g(^PAADM(EpisodeID,"DHC")),"^",29)
	.s PAADMDischgTime=$p($g(^PAADM(EpisodeID,"DHC")),"^",30)
	i PAADMDischgTime'="" s PAADMDischgTime=..%ZT(PAADMDischgTime)
	i AdmDischgDate'="" s AdmDischgDate=..%ZD(AdmDischgDate) //$zd(AdmDischgDate,3)
 	s Comm=$p($g(^SSU("SSUSR",CreateUserDr)),"^",2)
 	Set Ward=$P($g(^PAADM(EpisodeID)),"^",70)
	if Ward'="" Set PAAdmWard=$P($g(^PAWARD(Ward)),"^",2)
	else  Set PAAdmWard=""
	
	Set Bed=$P($g(^PAADM(EpisodeID)),"^",73)
	if Bed'="" Set PAAdmBed=$P($g(^PAWARD(+Bed,"BED",$P(Bed,"||",2))),"^",1)
	else  Set PAAdmBed="" 
	s VisitStatus=$p($g(^PAADM(EpisodeID)),"^",20)
	if (VisitStatus="D"){
		s PAAdmBed=##class(web.DHCBillCommon).GetPatBedCode(EpisodeID) 
		i (PAAdmBed'="") {
			i PAAdmBed'["床" s PAAdmBed=PAAdmBed_##class(websys.Translation).Get("doc.patlistquery.hui.csp","床")
		}else{
			s PAAdmBed="" 
		}
	}
	s AdmDoc=""
 	i admdocdr'="" s AdmDoc=$p($g(^CTPCP(admdocdr,1)),"^",2)
 	Set AdmDoc= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",AdmDoc,langid)
 	s MRAdmRowid=$p($g(^PAADM(EpisodeID)),"^",61)
 
 	s MRDiagnoseDesc=##class(web.DHCMRDiagnos).GetMRDiagnosDesc(MRAdmRowid,"^")
	
 	s MRDiagnoseDesc=$tr(MRDiagnoseDesc,"^","")
 	//s MRDLength=$Length(MRDiagnoseDesc,"^")
 	//s MRDiagnoseDesc=$P(MRDiagnoseDesc,"^",MRDLength)
 	
 	s IfHadMR=##class(web.DHCOPRegReports).HadMR(EpisodeID)
    i IfHadMR="1" d
    .s IfSeeDoctor="已就诊"
    e  d
    .s IfSeeDoctor="未就诊"
    s IfSeeDoctor=##class(websys.Translation).Get("doc.patlistquery.hui.csp",IfSeeDoctor)
    i $d(^User.DHCRegistrationFeeI("ADM",EpisodeID)) d
    .set RegFeeID=$O(^User.DHCRegistrationFeeI("ADM"," "_EpisodeID,""))
    .s TimeRange=""
    .i RegFeeID'="" set TimeRange=$ListGet(^User.DHCRegistrationFeeD(RegFeeID),21)
    .if TimeRange'="" s TimeRange=$P($g(^DHCTimeRange(TimeRange)),"^",2)
	quit
	
OutputRow
	i (FindbyDoc="on") {
		s careprovID=$p(^SSU("SSUSR",%session.Data("LOGON.USERID")),"^",14)	
		quit:(($g(admdocdr)'="")&&(careprovID'=admdocdr))
	}
	q:(AdmDocId'="")&&(admdocdr'=AdmDocId)
    s sortDoc = 1
    if (FindbyDoc = "on")||(AdmDocId '= "") {
        s sortDoc = 1
    } else {
        s logonUserCareProvId = $p($g(^SSU("SSUSR",$p(..%SessionStr(), "^", 1))), "^", 14)
        if (logonUserCareProvId '= "")&&(logonUserCareProvId = admdocdr) {
            s sortDoc = 0
        }
    }
	s AdmReasonID=$p($g(^PAADM(EpisodeID,1)),"^",7)
    q:(PatType'="")&&(PatType'=AdmReasonID)
	;处理条件多选情况下，病案号过滤问题QP
	s outPatientMedicare="",inPatientMedicare="",PatientMedicare="",exitPatmed=0
	s MedType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
	s ErrMsg=""
	s PatientMedicare=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID,MedType,.ErrMsg)
	if (RequestPatMed'="")&&(RequestPatMed'=PatientMedicare) s exitPatmed=1
	q:exitPatmed=1
	s papmidob=$p(^PAPER(PatientID,"ALL"),"^",6)    //取出生日期
	s PatAge=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.reg.GetPapmiAge",PatientID,EpisodeID)
	if (PatAge'["岁") s PatAge1=0
	else  s PatAge1=+PatAge
	q:(SAge'="")&&(PatAge1<SAge)
	q:(EAge'="")&&(PatAge1>EAge)
	if (VisitStatus="A") s VisitStatus="正常"
	if (VisitStatus="C") s VisitStatus="退号"
	if (VisitStatus="D") s VisitStatus="出院"
	if (VisitStatus="P") s VisitStatus="预住院"
	s VisitStatus=##class(websys.Translation).Get("doc.patlistquery.hui.csp",VisitStatus)
    q:(Diagnosis'="")&&(MRDiagnoseDesc'[Diagnosis)
	s TelPhone=$p($g(^PAPER(PatientID,"PER",1)),"^",11)
	
    set SerialNumber=ind ;序号
    s PAAdmWard=##class(web.DHCOPAdmReg).LocDescFormate(PAAdmWard)
    s PAAdmWard=##class(User.PACWard).GetTranByDesc("WARDDesc",PAAdmWard,langid)
    s PatName1=$p($g(^PAPER(PatientID,"ALL")),"^",1)
    s PatSex1=##class(web.PAPerson).GetSex(PatientID)
    s PatSex1=##class(User.CTSex).GetTranByDesc("CTSEXDesc",PatSex1,langid)
    //s PatientMedicare=##Class(web.DHCWMRService).IGetMrNoByPatientID(PatientID) 
    s Strval=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(PatientID,"") 
    s PatPoliticalLevel=$p(Strval,"^",2)
    s PatSecretLevel=$p(Strval,"^",4)
    s baseinfo="",AddPilotProPat=""
    s RegNo1=$p(^PAPER(PatientID,"PAT",1),"^",1)
    s PatCredNo=$p($g(^PAPER(PatientID,"PAT",3)),"^",6)
    s CredTypeDr=$p($g(^PAPER(PatientID,"PAT",3)),"^",7)
    if PatCredNo'="",CredTypeDr'="" {
	    s CredCardType=$p(^PAC("CARD",CredTypeDr),"^",2)
	     s CredCardType=##class(User.DHCCredType).GetTranByDesc("CRTDesc",CredCardType,langid)
		s PatCredNo=CredCardType_":"_PatCredNo
    }
    s Deceased = $p($G(^PAPER(+PatientID,"ALL")),"^",12)
    s:Deceased="Y" PatName1=PatName1_"(患者死亡)"
    
    i UserID'=""  d
	.s ^TEMPDHCExamPatList("DHCExamPatList",UserID,Sub)=AdmDate_"^"_AdmTime_"^"_AdmDoc_"^"_AdmReason_"^"_AdmType_"^"_PAAdmWard_"^"_PAAdmBed_"^"_AdmDept_"^"_PatientID_"^"_EpisodeID_"^"_AdmDischgDate_"^"_MRDiagnoseDesc_"^"_RegNo1_"^"_PatientMedicare_"^"_PatName1_"^"_PatSex1
    .s Sub=Sub+1
    b ;OUTP
	set Data=$lb(AdmDate,AdmTime,AdmDoc,AdmReason,AdmType,PAAdmWard,PAAdmBed,AdmDept,PatientID,EpisodeID,AdmDischgDate,MRDiagnoseDesc,IfSeeDoctor,TimeRange,VisitStatus,PAADMDischgTime,SerialNumber,PatName1,PatSex1,PatientMedicare,PatPoliticalLevel,PatSecretLevel,baseinfo,AddPilotProPat,RegNo1,TelPhone,PatAge,PatCredNo,Ward)
	s sortInd = $i(SortPatListArr("doc.patlistquery"))
	// 单独查出院按出院日期排，其他情况按就诊日期
	if (DisInStatus="on")&&(InStatus = "")&&(OutStatus = "")&&((PreFlag = "")) {
		s SortPatListArr("doc.patlistquery", sortDoc, ..%ZDH(AdmDischgDate), sortInd) = Data
	} else {
		s SortPatListArr("doc.patlistquery", sortDoc, ..%ZDH(AdmDate), sortInd) = Data
	}
	quit
	
SortPatListNew
	s sortFlag = -1		// 预留时间正序、逆序标志
	// 默认先查登录医生的患者, 按就诊日期倒叙
	s mSortDoc = ""
	for {
		s mSortDoc = $o(SortPatListArr("doc.patlistquery", mSortDoc))
		q:mSortDoc=""
		s mSortDate = ""
		for {
			s mSortDate = $o(SortPatListArr("doc.patlistquery", mSortDoc, mSortDate), sortFlag)
			q:mSortDate=""
			s mSortInd = ""
			for {
				s mSortInd = $o(SortPatListArr("doc.patlistquery", mSortDoc, mSortDate, mSortInd))
				q:mSortInd=""
				s mSortData = SortPatListArr("doc.patlistquery", mSortDoc, mSortDate, mSortInd)
				d OutPutRowAfterSort
			}
		}
	}
	q

OutPutRowAfterSort
	s ^CacheTemp(repid,ind) = mSortData
	s ind=ind+1
	q
}

ClassMethod RegFindFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = RegFindExecute ]
{
	// Restore QHandle
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

ClassMethod PatListBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "")
{
 s (id,code,desc)=""
 s ^Tempscl("PatListBroker")=itmjs_","_itmjsex_","_val
 ; Try and find a matching code
 ;&sql(SELECT	CTLOC_Desc,CTLOC_RowID,CTLOC_Code 
 ;INTO	:desc, :id, :code
 ;FROM	SQLUser.CT_Loc
 ;WHERE	((%UPPER CTLOC_Desc = %UPPER :val) OR (%UPPER CTLOC_Code = %UPPER :val)))
 ;
 Set langid=..%LanguageID()
 s RName=""
 s FID=val
 s AccMRowId=0
 s PapmiRowid=0  f  s PapmiRowid=$o(^PAPERi("PAPMI_PatNo",$ZCVT(FID,"U"),PapmiRowid)) q:PapmiRowid=""  d
	.s PapmiDr=PapmiRowid
	.s RName=$p($g(^PAPER(PapmiRowid,"ALL")),"^",1)
	.s RBirth=..%ZD($p($g(^PAPER(PapmiRowid,"ALL")),"^",6)) //$ZD($p($g(^PAPER(PapmiRowid,"ALL")),"^",6),3)
	.s RIDCardNo=$p($g(^PAPER(PapmiRowid,"ALL")),"^",9)
	.s sexid=$p($g(^PAPER(PapmiRowid,"ALL")),"^",7)
	.s RSex=$p($g(^CT("SEX",sexid)),"^",2)
	.s RSex=##class(User.CTSex).GetTranByDesc("CTSEXDesc",RSex,langid)
	.s RId=$p($g(^PAPER(PapmiRowid,"PAT",1)),"^",2) ;IP_No
	.s ^DHCA=RId
	.s RTelNo=$p($g(^PAPER(PapmiRowid,"PER",1)),"^",11) ;pa_person.paper_telh
	.s RInMedicare=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(PapmiRowid,"",$g(%session.Data("LOGON.HOSPID")))
	.if RInMedicare["-" s RInMedicare=""
	.s ROpMedicare=$p($g(^PAPER(PapmiRowid,"PER",4)),"^",4) ;paper_governcardno
	.;add by gwj *****
	.s CountryDR="",Countdesc=""
    .s provincedr="",provincedesc=""
    .s Rzipid="",Rzipcode=""
    .s citydr="",citydesc=""
    .s cityarea="",cityareaid=""
    .s CountryDR=$p(^PAPER(PapmiRowid,"PER",1),"^",8)
    .i CountryDR'=""  d
    ..i $d(^CT("COU",CountryDR))=0  d
    ...s CountryDR="",Countdesc=""
    ..e  d
    ...s Countdesc=$p(^CT("COU",CountryDR),"^",2)
    ...i $f(Countdesc,"-")'=0  d 
	....s Countdesc=$p(Countdesc,"-",2)
    .s provincedr=$p($G(^PAPER(PapmiRowid,"PER",4)),"^",2)
    .i provincedr'=""  d
    ..i $d(^CT("PROV",provincedr))=0  d
	...s provincedr="",provincedesc=""
	..e  d
	...s provincedesc=$p(^CT("PROV",provincedr),"^",2)
	...i $f(provincedesc,"-")'=0  d 
	....s provincedesc=$p(provincedesc,"-",2)
	.s citydr=$p(^PAPER(PapmiRowid,"PER",1),"^",5)
	.i citydr'=""  d
	..i $d(^CT("CIT",citydr))=0  d
	...s citydr=""
	...s citydesc=""
	..e  d
	...s citydesc=$p(^CT("CIT",citydr),"^",2)
	...i $f(citydesc,"-")'=0  d
	....s citydesc=$p(citydesc,"-",2) 
    .s Rzipid=$p($g(^PAPER(PapmiRowid,"PER",1)),"^",7)  ;PAPER_Zip_DR 
    .i Rzipid'=""  d
    ..i $d(^CT("ZIP",Rzipid))=0  d
	...s Rzipid=""
	...s Rzipcode=""
	..e  s Rzipcode=$p($g(^CT("ZIP",Rzipid)),"^",1) 
	.s cityareaid=$p($g(^PAPER(PapmiRowid,"PER",4)),"^",9)
	.i cityareaid'=""  d
	..i ('$d(^CT("CITAREA",cityareaid)))  d
	...s cityareaid="",cityarea=""
	..e  d
	...s cityarea=$p($g(^CT("CITAREA",cityareaid)),"^",2)
	...i $f(cityarea,"-")'=0  d
	....s cityarea=$p(cityarea,"-",2) 
	.s INSUNO=$P($G(^PAPER(PapmiRowid,"PAT",2)),"^",6)  ;PAPMI_Medicarecode 
    .;*****
	.s soc=""
	.s RPatType=""
	.s socialstatus=$p($g(^PAPER(PapmiRowid,"PER",1)),"^",10) 
	.i socialstatus'="" d
	..s RPatType=$p($g(^CT("SS",socialstatus)),"^",2)      ;paper_socialstatus_dr->ss_desc
    .s RCompany=$p($g(^PAPER(PapmiRowid,"PER",4)),"^",18) 
    .s RAddress=$p($g(^PAPER(PapmiRowid,"PER","ADD",1)),"^",1) 
    .s AccMRowId=$o(^DHCACDi("AccM",0,"PAPMI",PapmiRowid,AccMRowId))  ;DHC_Accmanager
    .i AccMRowId'=""  s RCredType=$p(^DHCACD("AccM",AccMRowId),"^",17)
    .i AccMRowId'=""  s RCredNo=$p(^DHCACD("AccM",AccMRowId),"^",18)    
	 S desc=$g(RName)_"^"_$g(RBirth)_"^"_$g(RSex)_"^"_$g(RId)_"^"_$g(RTelNo)_"^"_$g(RInMedicare)_"^"_$g(RPatType)_"^"_$g(RAddress)_"^"_$g(ROpMedicare)_"^"_$g(RCompany)_"^"_$g(RCredNo)_"^"_$g(RCredType)
	 s desc=desc_"^"_$G(CountryDR)_"^"_$g(Countdesc)_"^"_$g(Rzipid)_"^"_$g(Rzipcode)_"^"_$g(provincedr)_"^"_$g(provincedesc)_"^"_$g(citydr)_"^"_$g(citydesc)_"^"_$g(cityarea)_"^"_$g(cityareaid)_"^"_$g(INSUNO)_"^"_$g(PapmiDr)
	 s ^DHCApp=desc
	 if (itmjs'=""){ 
	 	q desc	
	 }else{
		 s retval=itmjs_"('"_$ZCVT(desc,"O","JS")_"');"
		 i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(desc,"O","JS")_"^"_id_"^"_$ZCVT(code,"O","JS")_"');"
		 &javascript<#(retval)#>
		 q desc
	 }
}

/// update by shp,20130516 
/// Description： 统一调用病案接口“ ##Class(web.DHCWMRService).IGetPatientIDByMrNo(MrNo)”
///               -10:"入参 MrNo 为空 ",   -1:"程序报错",   -11:"病案号无效 "
/// input      :InMedNO
/// output     :对于没有找到正确patid的按“空”输出。
ClassMethod GetPatInfoByInMedNo(InMedNO As %String)
{
	set PatNo=""
	s InMedNO=$ZConvert(InMedNO,"U")
	s PersonRowId=##class(MA.IPMR.IO.OutService).GetPatientIDByMrNo(InMedNO,"")
	i PersonRowId["-" s PersonRowId=""
	;set PersonRowId =$o(^PAPERi("Medicare1",InMedNO,0))
	if PersonRowId'="" d
	.set PatNo=$p(^PAPER(PersonRowId,"PAT",1),"^",1)
	q PatNo
}

/// Creator?      李相宗
/// CreatDate?    2012.02
/// Description:? 新加方法根据并按号得到就诊号,不修改GetPatInfoByInMedNo，因为不知道又没有别的程序调用    
/// Input?        InMedNO
ClassMethod GetPatInfoByInMedNo1(InMedNO As %String)
{
    q:InMedNO="" ""  
	s PatNo=""
	s NO1=1
	s ret=""
	s InMedNO=$ZConvert(InMedNO,"U")
	s PersonRowId=""	
	s RowId=0 f  s RowId=$o(^PAPERi("Medicare1",InMedNO,RowId)) q:RowId=""  d
	.if PersonRowId=""  s PersonRowId=RowId
	.else  s PersonRowId=PersonRowId_"^"_RowId
	q:PersonRowId="" ret
	s Len=$L(PersonRowId,"^")
	f NO=NO1:1:Len
	{
		s Id=$P(PersonRowId,"^",NO)
		set PatNo=$p(^PAPER(Id,"PAT",1),"^",1)
		i ret=""  s ret=PatNo
		else  s ret=ret_"^"_PatNo
	}
	q ret
}

/// Creator?     赵忠原
/// CreatDate?    2012.09
/// Description:? 根据病案号得到病人的RowID跟就诊号   
/// Input?        InMedNO
ClassMethod GetPatIDByInMedNo(InMedNO As %String)
{
  
    q:InMedNO="" ""
    set PatNo=""
	s InMedNO=$ZConvert(InMedNO,"U")	
	set PersonRowId =$o(^PAPERi("Medicare1",InMedNO,0))
	if PersonRowId'="" d
	.set PatNo=$p(^PAPER(PersonRowId,"PAT",1),"^",1)
	else  q ""
	q PersonRowId_"^"_PatNo
}

/*Query GetWardMessage(desc As %String) As %Library.SQLQuery(CONTAINID = 2, ROWSPEC = "Ward:%String,Code:%String,HIDDEN:%String")
{
SELECT  $EXTRACT(WARD_Desc,$FIND(WARD_Desc,"-"),$LENGTH(WARD_Desc)) ,WARD_Code,WARD_RowID from PAC_Ward 
WHERE	%ALPHAUP WARD_Desc %STARTSWITH %ALPHAUP :desc 
 ORDER	BY WARD_Desc
}*/

/*Query GetWardMessage(desc As %String,luloc As %String) As %Library.SQLQuery(CONTAINID = 2, ROWSPEC = "Ward:%String,Code:%String,HIDDEN:%String")
{
SELECT  WARD_Desc ,WARD_Code,WARD_RowID from PAC_Ward 
WHERE	((%ALPHAUP WARD_Desc [ %ALPHAUP :desc) OR (:desc is null))
AND  ((:luloc is null) OR (WARD_LocationDR=:luloc))
}*/
Query GetWardMessage(desc As %String, luloc As %String, HospID As %String = "") As %Query(ROWSPEC = "Ward:%String,Code:%String,HIDDEN:%String,Alias:%String")
{
}

ClassMethod GetWardMessageClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetWardMessageExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCExamPatList","RegFind","600","0000000001","","on","","62954","62956","","","ZXYJHYK-中西医结合一科")
ClassMethod GetWardMessageExecute(ByRef qHandle As %Binary, desc As %String, luloc As %String, HospID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s desc=$$ALPHAUP^SSUTIL4(desc)
	s limitfalg=##class(web.DHCDocIPBookNew).GetLocCureLimit(luloc)
	if (limitfalg="Y") s luloc=""
	Set langid=..%LanguageID()
	s WARDRowID=0
	f  s WARDRowID=$o(^PAWARD(WARDRowID)) q:WARDRowID=""  d
	.q:'$d(^PAWARD(WARDRowID))
	.s WARDDesc=$p($g(^PAWARD(WARDRowID)),"^",2)
	.s WARDDesc=##class(User.PACWard).GetTranByDesc("WARDDesc",WARDDesc,langid)
	.s Active=$p($g(^PAWARD(WARDRowID)),"^",6)
	.q:(WARDDesc="")||(Active'="Y")
	.s WARDCode=$p($g(^PAWARD(WARDRowID)),"^",1)
	.s WARDLocationDR=$p($g(^PAWARD(WARDRowID)),"^",5)
	.Q:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("CT_Loc",WARDLocationDR,HospID)="N"
	.Q:##class(web.DHCOPAdmReg).CheckLocDesc(WARDLocationDR,desc)'=1
	.s Datefrom=$p($g(^PAWARD(WARDRowID)),"^",7)
	.s DateTo=$p($g(^PAWARD(WARDRowID)),"^",9)
	.q:(Datefrom'="")&&(Datefrom>+$H)
	.q:(DateTo'="")&&(DateTo<+$H)
	.q:($p($g(^PAWARD(WARDRowID)),"^",6)="N")
	.s Alias=$P(^CTLOC(WARDLocationDR),"^",43)
	.s Find=0
	.i luloc'="" d
	..s LINKChildsub=0
	..f  s LINKChildsub=$o(^CTLOC(WARDLocationDR,"LINK",LINKChildsub)) q:(LINKChildsub="")||(Find=1)  d
	...s LinkLoc=$p(^CTLOC(WARDLocationDR,"LINK",LINKChildsub),"^",1) 
	...i LinkLoc=luloc d
	....s Find=1
	.e  s Find=1 
	.q:(Find=0)&&(luloc'="")&&('$d(^CTLOC(luloc,"LINKWARD",0,"Ward",WARDRowID)))
	.d OutputRow
	Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
	s WARDDesc=##class(web.DHCOPAdmReg).LocDescFormate(WARDDesc)
	set Data=$lb(WARDDesc,WARDCode,WARDRowID,Alias)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetWardMessageFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetWardMessageExecute ]
{
	// Restore QHandle
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

/// w ##class(web.DHCExamPatList).WardDescBroker()
ClassMethod WardDescBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %String = "", CTLoc As %String = "")
{
	;w ##class(web.DHCExamPatList).WardDescBroker("","","","2")
	s ^Temp("WardDescBroker")=itmjs_"#"_itmjsex_"#"_val_"#"_CTLoc
	s desc=""
	Set rs=##Class(%ResultSet).%New("web.DHCExamPatList:GetWardMessage")
	If rs.QueryIsValid() { 
		 Set WardInfo=rs.Execute(val,CTLoc)
		 If 'WardInfo Quit
		 While rs.Next() {
			 Set Ward=rs.GetData(1)
			 Set Code=rs.GetData(2)
			 Set WardRowid=rs.GetData(3)
			 If desc="" Set desc=WardRowid_$c(1)_Ward
			 Else  Set desc=desc_"^"_WardRowid_$c(1)_Ward
		 }
	}
	Q:desc="" 1
	s retval=itmjs_"('"_$ZCVT(desc,"O","JS")_"');"
	&javascript<#(retval)#>
	Q desc
}

/// Creator?      李相宗
/// CreatDate?    2012.02
/// Description:? 根据病人^PAPERi("PAPMI_PatNo",$ZCVT(FID,"U"),登记号得到病人基本信息        
/// Input?        PAPMI_PatNo串
/// Return?       病人基本信息
Query FindPatInfo(PatNoStr As %String) As %Query(ROWSPEC = "PatName:%String,PatSex:%String,PatBirth:%String,PatNo:%String,RIDCardNo:%String,PapmiRowid:%String")
{
}

ClassMethod FindPatInfoExecute(ByRef qHandle As %Binary, PatNoStr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1

	 	
	 	s NO1=1
	 	s Len=$L(PatNoStr,"^")
		f NO=NO1:1:Len
		{
		 s FID=$P(PatNoStr,"^",NO)
		 q:FID=""
	 	 s PapmiRowid=0  f  s PapmiRowid=$o(^PAPERi("PAPMI_PatNo",$ZCVT(FID,"U"),PapmiRowid)) q:PapmiRowid=""  d
		.s PapmiDr=PapmiRowid
		.s PatName=$p($g(^PAPER(PapmiRowid,"ALL")),"^",1)
		.s PatBirth=..%ZD($p($g(^PAPER(PapmiRowid,"ALL")),"^",6)) //$ZD($p($g(^PAPER(PapmiRowid,"ALL")),"^",6),3)
		.s RIDCardNo=$p($g(^PAPER(PapmiRowid,"ALL")),"^",9)
		.s sexid=$p($g(^PAPER(PapmiRowid,"ALL")),"^",7)
		.s PatSex=$p($g(^CT("SEX",sexid)),"^",2)
		.s PatNo=FID
		.s RId=$p($g(^PAPER(PapmiRowid,"PAT",1)),"^",2) ;IP_No
		.s ^DHCA=RId
		.s RTelNo=$p($g(^PAPER(PapmiRowid,"PER",1)),"^",11) ;pa_person.paper_telh
		.s RInMedicare=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(PapmiRowid,"",$g(%session.Data("LOGON.HOSPID")))
		.i RInMedicare["-"  s RInMedicare=""
		.s ROpMedicare=$p($g(^PAPER(PapmiRowid,"PER",4)),"^",4) ;paper_governcardno   
	    .Do OutputRow
	}
 	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(PatName,PatSex,PatBirth,PatNo,RIDCardNo,PapmiRowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindPatInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPatInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindPatInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPatInfoExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDefaultWard(PatNo As %String, WardID As %String, Name As %String, EpisodeID As %String = "")
{
	 s (currentWard,currentWardID,Desc,PACWardID)=""
	// if (($g(PatNo)="")&&($g(WardID)="")&&($g(Name))) {	
     s currentWardID=%session.Get("LOGON.WARDID")
		 s:EpisodeID'="" currentWardID=$p($g(^PAADM(EpisodeID)),"^",70)
     if currentWardID'="" {
	     s currentWard=$P($g(^PAWARD(currentWardID)),"^",2)
	     s %request.Data("WardDesc",1)=currentWard  
	     s %request.Data("WardID",1)=currentWardID 
	     q currentWard_"^"_currentWardID
     }elseif(%session.Get("LOGON.CTLOCID")'="") {
		   s CTLOCID=%session.Get("LOGON.CTLOCID")	 
	       s childsub=0    s childsub=$O(^CTLOC(CTLOCID,"LINK",childsub))
	       q:childsub="" ""
		   s LinkLocID=$P(^CTLOC(CTLOCID,"LINK",childsub),"^",1)
		   s PACWardID=0  
		   s PACWardID=$O(^PAWARD(0,"WARD_LocationDR",LinkLocID,PACWardID))
		   q:PACWardID="" ""
		   s Desc=$P(^PAWARD(PACWardID),"^",2)
		   //if $P(Desc,"-",2)'="" s Desc=$P(Desc,"-",2)
		   //s %request.Data("WardID",1)=PACWardID
		   //s %request.Data("WardDesc",1)=Desc	   
		   q Desc_"^"_PACWardID 
     }
	//}
	q ""
}

/// Creator?      李相宗
/// CreatDate?    2012.03.26
/// Description:? 找到病人列表查询后的存储信息。用于打印。       
/// Input?        UserID 用户ID  功能标志 Flag  
/// Return?       信息条数NO 查询出的患者信息Str
/// ^TEMPDHCExamPatList("DHCExamPatList",UserID) 相关QueryRegFindExecute
/// d ##class(web.DHCExamPatList).GetDHCExamPatListMessage("3879","","3")
/// Strs=^TEMPDHCExamPatList("DHCExamPatList",UserID,Sub)=AdmDate_"^"_AdmTime_"^"_AdmDoc_"^"_AdmReason_"^"_AdmType_"^"_PAAdmWard_"^"_PAAdmBed_"^"_AdmDept_"^"_PatientID_"^"_EpisodeID_"^"_AdmDischgDate
ClassMethod GetDHCExamPatListMessage(UserID As %String, Flag As %String, Row As %String)
{
  
  s NO="" s Str=""
  q:UserID="" NO
  i Flag="1" {
  s Sub=0 f  s Sub=$O(^TEMPDHCExamPatList("DHCExamPatList",UserID,Sub)) q:Sub=""  d
  .s NO=Sub
  q NO
  }
  i Flag="2"
  {
   s AdmDate=$P($G(^TEMPDHCExamPatList("DHCExamPatList",UserID,Row)),"^",1)
   i (AdmDate[("-"))=1 d 
   .s AdmDate=$ZDH(AdmDate,3)
   .s $P(^TEMPDHCExamPatList("DHCExamPatList",UserID,Row),"^",1)=$ZD(AdmDate,4)
   
   s DischgDate=$P($G(^TEMPDHCExamPatList("DHCExamPatList",UserID,Row)),"^",11)
   i (DischgDate[("-"))=1 d 
   .s DischgDate=$ZDH(DischgDate,3)
   .s $P(^TEMPDHCExamPatList("DHCExamPatList",UserID,Row),"^",11)=$ZD(DischgDate,4)
   s Str=$G(^TEMPDHCExamPatList("DHCExamPatList",UserID,Row)) 
   
   s PAAdmWard=$P($G(^TEMPDHCExamPatList("DHCExamPatList",UserID,Row)),"^",6)
   i (PAAdmWard[("-"))=1 d 
   .s PAAdmWard=$P(PAAdmWard,"-",2)
   .s $P(^TEMPDHCExamPatList("DHCExamPatList",UserID,Row),"^",6)=PAAdmWard
   s Str=$G(^TEMPDHCExamPatList("DHCExamPatList",UserID,Row)) 
   q Str
 }
 q ""
}

/// Creator?      李相宗
/// CreatDate?    2012.03.26
/// Description:? 找到病人列表查询后的存储信息。用于打印。        
/// Return?       病案号 病人姓名
ClassMethod GetPatientMes(PatientID)
{
	s Str=""
 	i PatientID="" q Str
 	s PatientMedicare=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(PatientID,"",$g(%session.Data("LOGON.HOSPID")))
 	i PatientMedicare["-"  s PatientMedicare=""
 	s PatientName=$p($g(^PAPER(PatientID,"ALL")),"^",1)
 	s Str=PatientMedicare_"^"_PatientName
	q Str
}

/// Creator      yl
/// CreatDate    2012.05
/// Description: 根据姓名得到就诊号
/// Input        Name 病人姓名
/// w ##class(web.DHCExamPatList).GetPatInfoByName
ClassMethod GetPatInfoByName(PatName As %String)
{
  
	s PatNo=""
	s Start=1
	s ret=""

	s PersonRowId=""	

 	if (PatName'=""){
	 		
		s PatName=$$ALPHAUP^SSUTIL4(PatName)
		s patientName=0
		s PatientID=0
		f  s patientName=$o(^PAPERi("PAPER_PatName",patientName)) q:patientName=""  d
		.q:(patientName'=PatName)
		.f  s PatientID=$o(^PAPERi("PAPER_PatName",patientName,PatientID)) q:PatientID=""  d
		..s EpisodeID=$o(^PAPERdr(PatientID,"ADM","I",""),-1)
		..q:EpisodeID=""
		..s:PersonRowId'="" PersonRowId=PersonRowId_"^"_PatientID
		..s:PersonRowId="" PersonRowId=PatientID 
	 	
 	}
 	
	s Len=$L(PersonRowId,"^")
	f NO=Start:1:Len
	{
		s Id=$P(PersonRowId,"^",NO)
		continue:PersonRowId=""
		set PatNo=$p(^PAPER(Id,"PAT",1),"^",1)
		i ret=""  s ret=PatNo
		else  s ret=ret_"^"_PatNo
	}
	q ret
}

ClassMethod patnamelookupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = patnamelookupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod patnamelookupExecute(ByRef qHandle As %Binary, PatName As %String, HospDr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	i PatName="" {
      Set qHandle=$lb(0,repid,0)
      Quit $$$OK
    }
    s HospDr=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospDr)
	i $g(PatName)'="" s PatName=$$ALPHAUP^SSUTIL4(PatName)
	Set langid=..%LanguageID()
	
	s patIds = ..GetPatIdsByName(PatName, HospDr)
	s PAPMIDr=""
	s ptr = 0
	while $LISTNEXT(patIds, ptr, value) {
		s PAPMIDr=value
		continue:PAPMIDr=""
		s PatNo=$p($g(^PAPER(PAPMIDr,"PAT",1)),"^",1)
		s Name=$p($g(^PAPER(PAPMIDr,"ALL")),"^",1)
		s PatSexDR=$p($g(^PAPER(PAPMIDr,"ALL")),"^",7)
		s PatSex=""
		i PatSexDR'="" s PatSex=$p(^CT("SEX",PatSexDR),"^",2)
		s PatSex=##class(User.CTSex).GetTranByDesc("CTSEXDesc",PatSex,langid)
		s Birth=+$p(^PAPER(PAPMIDr,"ALL"),"^",6) 
		s Birth=..%ZD(Birth)
		s InPatFlag="否",InPatLoc=""
		s PaadmRowid=0
		for {
			s PaadmRowid=$o(^PAPERdr(PAPMIDr,"ADM","I",PaadmRowid)) 
			q:PaadmRowid=""
			s AdmHospitalId=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(PaadmRowid)
			continue:AdmHospitalId'=HospDr
			s VisitStatus=$p($g(^PAADM(PaadmRowid)),"^",20)
			continue:VisitStatus'="A"
			s InPatFlag="是"
			s AdmDepCodeDR=$p($g(^PAADM(PaadmRowid)),"^",4)
			if (AdmDepCodeDR'="") {
				s InPatLoc=$p($g(^CTLOC(AdmDepCodeDR)),"^",2)
				s InPatLoc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",InPatLoc,langid)
				} 
			q:InPatFlag="是"
		}
		s InPatFlag=##class(websys.Translation).Get("doc.patlistquery.hui.csp",InPatFlag)
		Do OutputRow
	}
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow
	set Data=$lb(PatNo,Name,Birth,PatSex,InPatFlag,InPatLoc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod patnamelookupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = patnamelookupExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

Query patnamelookup(PatName As %String, HospDr As %String = "") As %Query(ROWSPEC = "PatNo:%String:登记号,PatName:%String:患者姓名^80,Birth:%String:出生日期^80,PatSex:%String:性别^60,InPatFlag:%String:是否在院^80,InPatLoc:%String:在院科室^120")
{
}

/// desc:	根据患者姓名获取 Id 串
/// debug:	w ##class(web.DHCExamPatList).GetPatIdsByName("hm")
ClassMethod GetPatIdsByName(qName As %String = "", qHospId As %String = "", fuzzyFlag As %Integer = 1)
{
	s patIds = ""
	s qName = $$ALPHAUP^SSUTIL4(qName)
	q:$l(qName)<2 patIds
	s qHospId=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(qHospId)
	// 1.准确查询
	s patIdList = ""
	s patId = $o(^PAPERi("PAPER_PatName",qName,0))
	while (patId '= "") {
		s isActive = $p($g(^PAPER(patId,"PAT",1)), "^", 6)
		s hospId = $p($g(^PAPER(patId,"PER",5)), "^", 41)
		// if (isActive '= "N") && ((qHospId '= "") && (qHospId = hospId)) {
		if (isActive '= "N") {
			s patIdList = patIdList_$lb(patId)
		}
		s patId = $o(^PAPERi("PAPER_PatName",qName,patId))
	}
	// 2.模糊查询
	s fPatIdList = ""
	if (fuzzyFlag) {
		s fName = $o(^PAPERi("PAPER_PatName",""))
		while (fName '= "") {
			if (fName [ qName) {
				s patId = ""
				s patId = $o(^PAPERi("PAPER_PatName",fName,0))
				while (patId '= "") {
					if (patIdList '= "")&&($lf(patIdList, patId)) {
					} else {
						s isActive = $p($g(^PAPER(patId,"PAT",1)),"^",6)
						s hospId = $p($g(^PAPER(patId,"PER",5)), "^", 41)
						// if (isActive '= "N") && ((qHospId '= "") && (qHospId = hospId)) {
						if (isActive '= "N") {
							s fPatIdList = fPatIdList_$lb(patId)
						}
					}
					s patId = $o(^PAPERi("PAPER_PatName",fName,patId))
				}
			}
			s fName = $o(^PAPERi("PAPER_PatName",fName))
		}
	}
	s patIds = patIdList_fPatIdList
	q patIds
}

/// w ##class(web.DHCExamPatList).GetWardIdByLocId(9)
ClassMethod GetWardIdByLocId(CTLocId As %String)
{
	s WardIdStr=""
	q:CTLocId="" WardIdStr
	s WARDRowID=0
	f  s WARDRowID=$o(^PAWARD(WARDRowID)) q:WARDRowID=""  d
	.q:'$d(^PAWARD(WARDRowID))
	.s WARDDesc=$p($g(^PAWARD(WARDRowID)),"^",2)
	.q:WARDDesc=""
	.s WARDLocationDR=$p($g(^PAWARD(WARDRowID)),"^",5)	
	.s Find=0
	.s LINKChildsub=0
	.f  s LINKChildsub=$o(^CTLOC(WARDLocationDR,"LINK",LINKChildsub)) q:(LINKChildsub="")||(Find=1)  d
	..s LinkLoc=$p(^CTLOC(WARDLocationDR,"LINK",LINKChildsub),"^",1) 
	..i LinkLoc=CTLocId  s Find=1
	.i Find=1 d
	..i WardIdStr="" s WardIdStr=WARDRowID
	..e  s WardIdStr=WardIdStr_"^"_WARDRowID
	
	q WardIdStr
}

// 

Query FindDoc(LocId As %String, DocDesc As %String, HospID As %String = "") As %Query(ROWSPEC = "DocDesc:%String,DocId:%String,Alias:%String")
{
}

ClassMethod FindDocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindDocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

// d ##class(%ResultSet).RunQuery("web.DHCExamPatList","FindDoc","","")

ClassMethod FindDocExecute(ByRef qHandle As %Binary, LocId As %String, DocDesc As %String, HospID As %String = "") As %Status
{
	s HospID=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	if (LocId'=""){
		s RESRowId=0
		for {
			s RESRowId=$o(^RB("RES",0,"CTLOC",LocId,RESRowId))
			Q:RESRowId=""
			s DocId=$p($g(^RB("RES",RESRowId)),"^",2)
			continue:DocId=""
			d OutputRow(DocId)
		}  
	}else{
		s DocId=0
		for {
			s DocId=$o(^CTPCP(DocId))
			Q:DocId=""
			d OutputRow(DocId)
		}
		
	}
	Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow(DocId)
	Set langid=..%LanguageID()
	s Docdesc=$p($g(^CTPCP(DocId,1)),"^",2)
	q:Docdesc=""
	Set Docdesc= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",Docdesc,langid)
	Q:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("CT_CareProv",DocId,HospID)="N"
	q:##class(DHCDoc.Util.Base).CheckCTCareName("CT_CareProv",DocId,DocDesc)'=1
	s CTPCPDateActiveFrom=$p($g(^CTPCP(DocId,2)),"^",14)
	q:(CTPCPDateActiveFrom'="")&&(CTPCPDateActiveFrom>+$h)
	s CTPCPDateActiveTo=$p($g(^CTPCP(DocId,2)),"^",15)
	q:(CTPCPDateActiveTo'="")&&(CTPCPDateActiveTo<=..%SysDate())
	s CTPCPActiveFlag=$p($g(^CTPCP(DocId,1)),"^",9)
	q:CTPCPActiveFlag="N"
	s Alias=$p($g(^CTPCP(DocId,3)),"^",28) 
	set Data=$lb(Docdesc,DocId,Alias)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindDocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindDocExecute ]
{
	// Restore QHandle
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

ClassMethod ctloclookupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ctloclookupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod ctloclookupExecute(ByRef qHandle As %Binary, desc As %String, hospid As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	;s rowid=0
	i $g(desc)'="" s desc=$$ALPHAUP^SSUTIL4(desc)
	if hospid="" s hospid=%session.Data("LOGON.HOSPID")	;当前登陆的医院Id
	s len=$l(desc)
	s TypeStr="O^E^I^H"
	Set langid=..%LanguageID()
	for i=1:1:$l(TypeStr){
		s Type=$p(TypeStr,"^",i)
		q:Type=""
		s ctlocrowid=""
		for  {
			set ctlocrowid=$o(^PAC("ADMLOC",0,"AdmType",Type,ctlocrowid))  
			quit:(ctlocrowid="") 
			continue:'$d(^CTLOC(ctlocrowid))
			s locHospId=$p(^CTLOC(ctlocrowid),"^",22)
			continue:(locHospId'=hospid)
			s LocActiveFrom=+$p($g(^CTLOC(ctlocrowid)),"^",24)
			s LocActiveTo=+$p($g(^CTLOC(ctlocrowid)),"^",25)
			continue:((LocActiveFrom'=0)&&(LocActiveFrom>+$h))||((LocActiveTo<+$h)&&(LocActiveTo'=0))
			continue:($P(^CTLOC(ctlocrowid),"^",14)'="Y")
			s ctlocdesc=$p(^CTLOC(ctlocrowid),"^",2)
			s ctlocdesc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",ctlocdesc,langid)
			s desc1=$$ALPHAUP^SSUTIL4(ctlocdesc)
			s desc1=$e(desc1,1,len)
			continue:##class(web.DHCOPAdmReg).CheckLocDesc(ctlocrowid,desc)'=1
			Do OutputRow4
		}
	}
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow4
	s ctlocdesc=##class(web.DHCOPAdmReg).LocDescFormate(ctlocdesc)
	s Alias=$P(^CTLOC(ctlocrowid),"^",43)
	set Data=$lb(ctlocrowid,ctlocdesc,Alias)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod ctloclookupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ctloclookupExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

Query ctloclookup(desc As %String, hospid As %String = "") As %Query(ROWSPEC = "ctlocid:%String,ctloc:%String,Alias:%String")
{
}

/// CTOR: QP
/// DATE: 2016-08-19
/// DESC: 判断日期是否在7天之内
/// IN  : 
/// OUT : 1/0
/// TABL: 
/// EXEC: w ##class(web.DHCExamPatList).IfSelectDate("2018-10-12","2018-10-12")
ClassMethod IfSelectDate(SDate As %Library.String = "", EDate As %Library.String = "", HospDr As %String = "")
{
	/*s mRtn=0
	Q:(EDate="")||(SDate="") mRtn
	s SDate=..%ZDH(SDate)
	S EDate=..%ZDH(EDate)
	s subValue=(EDate-SDate)
	q:(subValue>=7)||(subValue<0) mRtn
	s mRtn=1
	*/
	s mRtn=""
	s HospDr=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospDr)
	s LimitDateSearch=..%GetConfig("LimitDateSearch",HospDr)
	Q:(EDate="")||(SDate="") mRtn
	q:LimitDateSearch="" mRtn
	s NowDate=+$H
	s SDate=..%ZDH(SDate)
	S EDate=..%ZDH(EDate)
	s subValue=(EDate-SDate)
	q:+LimitDateSearch="0" "请去医生站设置维护合理查询范围"
	q:(subValue>=LimitDateSearch)||(subValue<0) ..%Translate("doc.patlistquery.hui.csp","请选择合适的日期范围,日期范围为:")_LimitDateSearch_..%Translate("doc.patlistquery.hui.csp","天")
 	q mRtn
}

Query RegFindExport(UserID As %String, PatNo As %String, OutStatus As %String, InStatus As %String, DisInStatus As %String, Startdate As %String, Enddate As %String, WardID As %String, FindbyDoc As %String, CTLoc As %String, WardDesc As %String, PAAdmRowId As %String = "", luloc As %String = "", AdmDocId As %String = "", RequestName As %String = "", RequestPatMed As %String = "") As %Library.Query(ROWSPEC = "RegNo:%String:登记号,PatName1:%String:姓名,PatSex1:%String:性别,TelPhone:%String:联系电话,AdmDate:%String:就诊日期,AdmTime:%String:就诊时间,AdmDoc:%String:就诊医生,AdmReason:%String:费别,AdmType:%String:就诊类型,AdmDept:%String:科室,PAAdmWard:%String:病区,PAAdmBed:%String:床位,PatientMedicare:%String:病案号,AdmDischgDate:%String:出院日期,PAADMDischgTime:%String:出院时间")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCExamPatList","RegFindExportExecute","2019-12-30","2020-01-20","","","","",10209,2,"")
ClassMethod RegFindExportExecute(ByRef qHandle As %Library.Binary, UserID As %String, PatNo As %String, OutStatus As %String, InStatus As %String, DisInStatus As %String, Startdate As %String, Enddate As %String, WardID As %String, FindbyDoc As %String, CTLoc As %String, WardDesc As %String, PAAdmRowId As %String = "", luloc As %String = "", AdmDocId As %String = "", RequestName As %String = "", RequestPatMed As %String = "") As %Library.Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s rset=##class(%ResultSet).%New("web.DHCExamPatList:RegFind")
	d rset.Execute(UserID, PatNo, OutStatus, InStatus, DisInStatus, Startdate, Enddate, WardID, FindbyDoc, CTLoc, WardDesc, PAAdmRowId, luloc, AdmDocId, RequestName,RequestPatMed)
	While (rset.Next()) {
		s RegNo=rset.Data("RegNo")
		s PatName1=rset.Data("PatName1")
		s PatSex1=rset.Data("PatSex1")
		s TelPhone=rset.Data("TelPhone")
		s AdmDate=rset.Data("AdmDate")
		s AdmTime=rset.Data("AdmTime")
		s AdmDoc=rset.Data("AdmDoc")
		s AdmReason=rset.Data("AdmReason")
		s AdmType=rset.Data("AdmType")
		s AdmDept=rset.Data("AdmDept")
		s PAAdmWard=rset.Data("PAAdmWard")
		s PAAdmBed=rset.Data("PAAdmBed")
		s PatientMedicare=rset.Data("PatientMedicare")
		s AdmDischgDate=rset.Data("AdmDischgDate")
		s PAADMDischgTime=rset.Data("PAADMDischgTime")
		s OutputList=$lb(RegNo,PatName1,PatSex1,TelPhone,AdmDate,AdmTime,AdmDoc,AdmReason,AdmType,AdmDept,PAAdmWard,PAAdmBed,PatientMedicare,AdmDischgDate,PAADMDischgTime)
		d OutputRow14
	}
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRow14
	set Data=OutputList
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod RegFindExportFetch(ByRef qHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = RegFindExportExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
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

ClassMethod RegFindExportClose(qHandle As %Library.Binary) As %Library.Status [ PlaceAfter = RegFindExportFetch ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod patcrednolookupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = patcrednolookupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query patcrednolookup(PatCredNo As %String, HospDr As %String = "") As %Query(ROWSPEC = "PatNo:%String:登记号,PatName:%String:患者姓名^80,Birth:%String:出生日期^80,PatSex:%String:性别^60,InPatFlag:%String:是否在院^80,InPatLoc:%String:在院科室^120,CredNo:%String:证件号码^120")
{
}

ClassMethod patcrednolookupExecute(ByRef qHandle As %Binary, PatCredNo As %String, HospDr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	i PatCredNo="" {
      Set qHandle=$lb(0,repid,0)
      Quit $$$OK
    }
    s ^yl("patcrednolookup")=$lb(PatCredNo, HospDr)
    s HospDr=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospDr)
	i $g(PatCredNo)'="" s PatCredNo=$$ALPHAUP^SSUTIL4(PatCredNo)
	Set langid=..%LanguageID()
	s PAPMIDr=0
	for{
		s PAPMIDr=$o(^PAPERi("DVA",PatCredNo,PAPMIDr))
		q:PAPMIDr=""
		s PatNo=$p($g(^PAPER(PAPMIDr,"PAT",1)),"^",1)
		s Name=$p($g(^PAPER(PAPMIDr,"ALL")),"^",1)
		s PatSexDR=$p($g(^PAPER(PAPMIDr,"ALL")),"^",7)
		s PatSex=""
		i PatSexDR'="" s PatSex=$p(^CT("SEX",PatSexDR),"^",2)
		s PatSex=##class(User.CTSex).GetTranByDesc("CTSEXDesc",PatSex,langid)
		s Birth=+$p(^PAPER(PAPMIDr,"ALL"),"^",6) 
		s Birth=..%ZD(Birth)
		s InPatFlag="否",InPatLoc=""
		s CredNo=$p($g(^PAPER(PAPMIDr,"PAT",3)),"^",6)
		s PaadmRowid=0
		for {
			s PaadmRowid=$o(^PAPERdr(PAPMIDr,"ADM","I",PaadmRowid)) 
			q:PaadmRowid=""
			s AdmHospitalId=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(PaadmRowid)
			continue:AdmHospitalId'=HospDr
			s VisitStatus=$p($g(^PAADM(PaadmRowid)),"^",20)
			continue:VisitStatus'="A"
			s InPatFlag="是"
			s AdmDepCodeDR=$p($g(^PAADM(PaadmRowid)),"^",4)
			if (AdmDepCodeDR'="") {
				s InPatLoc=$p($g(^CTLOC(AdmDepCodeDR)),"^",2)
				s InPatLoc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",InPatLoc,langid)
				} 
			q:InPatFlag="是"
		}
		s InPatFlag=##class(websys.Translation).Get("doc.patlistquery.hui.csp",InPatFlag)
		d OutputRow	
		}
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow
	set Data=$lb(PatNo,Name,Birth,PatSex,InPatFlag,InPatLoc,CredNo)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod patcrednolookupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = patcrednolookupExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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
