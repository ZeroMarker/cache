Import SQLUser

Class web.DHCTEMPOERPRINT Extends DHCDoc.Util.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 925;

/// 得到床位列表
ClassMethod FindLocDocCurrentAdmBroker(itmjs As %Library.String = "", LocID As %String, UserID As %String, IPAddress As %String, AllPatient As %String, PatientNo As %String, SurName As %String, StartDate As %Date, EndDate As %Date, ArrivedQue As %String, RegQue As %String, MedUnit As %String = "") As %String
{
	k ^tmp($j) // 20120709 liuj add
	
	s desc=""
	s n=0
	/*
	Set rset=##Class(%ResultSet).%New("web.DHCDocInPatientList:FindLocDocCurrentAdm")
	If rset.QueryIsValid() { 
		Set Status=rset.Execute(LocID, UserID, IPAddress, AllPatient, PatientNo, SurName,StartDate, EndDate,ArrivedQue,RegQue,MedUnit)
		If 'Status Quit
		Set columns = rset.GetColumnCount()
		While (rset.Next()) {
			set ret=""
		    For col = 1:1:columns {
			   i ret="" s ret=rset.GetData(col)
		       e  s ret= ret_"^"_rset.GetData(col)
		    }
		    s n=n+1 
	       i ret'="" {
		   		s retval=itmjs_"('"_$ZCVT(ret,"O","JS")_"');"
				&javascript<#(retval)#>
	       }
		}
		d rset.Close()
	}
	*/
	///Add by BeyondVision for nurse
	q:LocID=""
	s LocDesc=$p($g(^CTLOC(LocID)),"^",1)
	if (LocDesc["手术室") d
	.s ret=..GetSSSPatList(itmjs)
	i (n=0)&&(LocDesc'["手术室") d
	.q:LocID=""
	.s WardId=$O(^PAWARD(0,"WARD_LocationDR",LocID,""))
	.q:WardId=""
    .s RoomId=0 f  s RoomId=$o(^PAADMi("CurrWard",WardId,RoomId)) q:RoomId=""  d
    ..s EpisodeID=0 f  s EpisodeID=$o(^PAADMi("CurrWard",WardId,RoomId,EpisodeID)) q:EpisodeID=""  d
    ...s PatVisit=$p($g(^PAADM(EpisodeID)),"^",20)
    ...i PatVisit'="A" q
    ...s PatientID=$p($g(^PAADM(EpisodeID)),"^",1)
	...s BedId=$P($g(^PAADM(EpisodeID)),"^",73)
	...s Name=$p(^PAPER(PatientID,"ALL"),"^",1) //$P($g(^PAADM(EpisodeID,"ADM2")),"^",26)
	...q:BedId=""
	...s PAAdmBed=$P($g(^PAWARD(+BedId,"BED",$P(BedId,"||",2))),"^",1)
	...q:PAAdmBed=""
	...;s:PAAdmBed="" PAAdmBed="空"
	...i PAAdmBed["床" s $P(ret,"^",16)=PAAdmBed_"-"_Name
	...e  s $P(ret,"^",16)=PAAdmBed_"床-"_Name
	...s $P(ret,"^",1)=PatientID
	...s $P(ret,"^",2)=EpisodeID
	...s $P(ret,"^",2)=EpisodeID
	...; ;  ; 20120709***********************************start----------------------------->排序
	...s ^tmp($j," "_PAAdmBed)=ret
	.s Bed=0
	.f  s Bed=$O(^tmp($j,Bed)) q:Bed=""  d
	..s ret=^tmp($j,Bed)
	..;w Bed,!
	..s retval=itmjs_"('"_$ZCVT(ret,"O","JS")_"');"
	..&javascript<#(retval)#>
	;***********************************liuj end
	
	/*
	...s retval=itmjs_"('"_$ZCVT(ret,"O","JS")_"');"
	...&javascript<#(retval)#>
	*/
	
	Q n
}

/// 得到手术室床位列表
/// W ##Class(web.DHCTEMPOERPRINT).GetSSSPatList("123")
ClassMethod GetSSSPatList(itmjs As %String) As %String
{
	//"R" "安排""N" "非预约""I" "术中""P""恢复室""L" "术毕""F" "完成"
	//web.UDHCANOPArrange:GetAnOpList
	k ^tmp($j)
	s statusStr="R"_"^"_"I"_"^"_"L"_"^"_"F"
	
	s i=0
	s SubNode="SDate"
	f date=$h:1:($h+1) d
	.s opaId=""
	.f  s opaId=$O(^DHCANOPArrange(0,SubNode,date,opaId)) q:opaId=""  d
	..;f  s opaId=$o(^DHCANOPArrange(opaId)) q:opaId=""  d
	..s opaStatus=$P(^DHCANOPArrange(opaId),"^",27)
	..q:("^"_statusStr_"^")'[("^"_opaStatus_"^")
	..s adm=$P(^DHCANOPArrange(opaId),"^",1)
	..q:adm=""
	..s admId=adm
	..s papmiId=$p($g(^PAADM(admId)),"^",1)
	..s admLocId=$p($g(^PAADM(admId)),"^",4)
	..s PAADMVisitStatus=$p($g(^PAADM(admId)),"^",20)
	..q:PAADMVisitStatus'="A"  //出院
	..s LocDesc=$P($G(^CTLOC(admLocId)),"^",1)
	..s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	..s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	..s BedId=$P($g(^PAADM(admId)),"^",73)
	..q:BedId=""
	..s PAAdmBed=$P($g(^PAWARD(+BedId,"BED",$P(BedId,"||",2))),"^",1)
	..s $P(ret,"^",16)=patName_"-"_LocDesc
	..s $P(ret,"^",1)=papmiId
	..s $P(ret,"^",2)=admId
	..s i=i+1
	..s ^tmp($j,i)=ret
	f j=1:1:i{
		s ret=^tmp($j,j)
		s retval=itmjs_"('"_$ZCVT(ret,"O","JS")_"');"
		&javascript<#(retval)#>
	}
	.s ret=^tmp($j,Bed)
	.s retval=itmjs_"('"_$ZCVT(ret,"O","JS")_"');"
	.&javascript<#(retval)#>
	k ^tmp($j)
	q i
}

/// 是否有新医嘱
ClassMethod IfNewOrdItem(EpisodeID As %String) As %String
{
	s NewOrdItemFlag=0
	s img3=##class(web.DHCSETIMAGE).IfNewOrdItem($g(EpisodeID),"3")  //新长瞩
	s img1=##class(web.DHCSETIMAGE).IfNewOrdItem($g(EpisodeID),"1")  //即刻医嘱
	s img2=##class(web.DHCSETIMAGE).IfNewOrdItem($g(EpisodeID),"2") //有新开临时医嘱
	s img4=##class(web.DHCSETIMAGE).IfNewOrdItem($g(EpisodeID),"4")  //有新开药品医嘱
	if (img1="1")||(img2="1")||(img3="1")||(img4="1")  s NewOrdItemFlag=1
	q NewOrdItemFlag
}

/// 取得诊疗菜单的链接
/// ----------getMenuPara()
/// d ##Class(web.DHCTEMPOERPRINT).getMenuPara()
ClassMethod getMenuPara() As %String
{
   	;s Capation="诊疗"      //菜单管理中的分类
    s Name="DHC IPNurse Order"   //菜单管理中的名称
	i $D(%session)>0 d
	.s UserID=%session.Get("LOGON.USERID")
	.q:UserID=""
 	.s CareId=$p($g(^SSU("SSUSR",UserID)),"^",14)
 	.q:CareId=""
   	.s TypeId=$p(^CTPCP(CareId,1),"^",4)
   	.q:TypeId=""
  	.s TypeDesc=$p($g(^CT("CPT",TypeId)),"^",4)
  	.q:($g(TypeDesc)'="NURSE")
    .;s Capation="护士补录费用"
    .s Name="DHC.DOC.NURSE.ORDERENTRY"	//菜单中护士补录医嘱的名字
    ;s mySMRowID=$o(^websys.MenuI("CaptionName"," "_Capation," "_Name,""))
    s mySMRowID=$o(^websys.MenuI("UniqueNameIndex"," "_Name,""))
    ;b ;mySMRowID
    ;s ^tan("mySMRowID")=mySMRowID
    q:(mySMRowID="") ""
    q:'$d(^websys.MenuD(mySMRowID)) ""
	s myMenuObj=##Class(websys.Menu).%OpenId(mySMRowID)
	s myhref = ..getMenuLinkURL(myMenuObj,mySMRowID)
	q myhref
}

/// 获取菜单的LinkURL 
ClassMethod getMenuLinkURL(MenuObj As %String, SMRowID As %String) As %String
{
	s myhref=""
	s myhttpprefix = "http://"
	s myhttpprefix1 = "http:/"
	
	s myLinkUrl = MenuObj.LinkUrl
	s mySMRowID = SMRowID
	s myValueExpression = MenuObj.EvaluateValue()		;$p(myValueExpression,"""",2)
	
	i (myLinkUrl'=""){
		;s myhref=""
		;逻辑： 1 .csp  
		s mytmpurl = $zconvert(myLinkUrl,"L")
		if (mytmpurl[".csp"){
			s myChartID=""
			if ($IsObject(MenuObj.Chart)){
				s myChartID=MenuObj.Chart.%Id()
			}
			s myChartBookID=""
			if ($IsObject(MenuObj.ChartBook)){
				s myChartBookID=MenuObj.ChartBook.%Id()
			}
			s mychartstr=""
			if (myChartID'=""){
				s mychartstr="&ChartID="_myChartID
			}
			if (myChartBookID'=""){
				s mychartstr=mychartstr_"&ChartBookID="_myChartBookID
			}
			s myPAGID=$i(^websys.Counters("tpagid"))	
			s myhref="websys.csp?a=a"_myValueExpression_"&TMENU="_mySMRowID_"&TPAGID="_myPAGID_mychartstr
		}else{
			;逻辑： 2  http://
			if (mytmpurl[myhttpprefix){
				s myhref=myLinkUrl
			}elseif (mytmpurl[myhttpprefix1){
				s myhref = myhttpprefix_$p(mytmpurl,myhttpprefix1,2)
			}else{
				if ($l(mytmpurl,"/")>2){
					; 独立网站
					s myhref = myhttpprefix_""_myLinkUrl
				}else{
					s myhref = %request.URLPrefix_""_myLinkUrl
				}
			}
		}
		
	}
	
	;s ^tan("myhref")=myhref
	q myhref
}

ClassMethod GetTempOrdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTempOrdExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod getphbasnum(dosunit, dosqty, scrip, ver) As %String
{
 //求剂量基本单位   149, 1000                 //540,1
    s drgfrm=$P(^ARCIM(scrip,ver,1),"^",12)
    s drg=+drgfrm,frm=$P(drgfrm,"||",2)
    s basuom=$P(^PHCD(+drgfrm,"DF",frm,2),"^",4)
    ;b
    if basuom=dosunit q dosqty_$p($g(^CT("UOM",basuom)),"^",2)
    s eqrw=0 f  s eqrw=$O(^PHCD(drg,"DF",frm,"EQ",eqrw)) q:eqrw=""  d
    .s equnit=$P(^PHCD(drg,"DF",frm,"EQ",eqrw),"^",1)
    .if equnit=dosunit d
    ..s eqval=$P(^PHCD(drg,"DF",frm,"EQ",eqrw),"^",2)
    if $G(eqval)'="" d
    .s num=dosqty/eqval
    .s ret=$FN(num,"",0)_$p($g(^CT("UOM",basuom)),"^",2)
    q $G(ret)
}

ClassMethod skinnote(Ord, OrdSub)
{
	n (Ord,OrdSub)
	s notes=""
	s notesdr=$P($G(^OEORD(Ord,"I",OrdSub,11)),"^",21)
    if notesdr'="" s notes=$P(^OEC("ACT",notesdr),"^",2)
    q notes
}

ClassMethod getanloc() As %String
{
 //获取麻醉科室dr
	s num=$L(^DHCANOPSET("anloc"),"^")
 	f i=1:1:num
 	{   s detstr=$P(^DHCANOPSET("anloc"),"^",i)
	 	s rw=$P(prior,"|")
	 	s depdr=$G(depdr)_"^"_rw
	}
	q $G(depdr)_"^"
}

ClassMethod GetTempOrdExecute(ByRef qHandle As %Binary, Adm, StartDate As %String, EndDate As %String, ChangeDate As %String = "", stop As %String = "0", ssuser As %String = "", CurDep = "", NurOrd, DocOrd, SelDocDep As %String = "N", DocDepId = "", SelRecDep As %String = "N", RecDepId = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
    s nvar=""
    k ^mtemp($J,"temp",Adm)
    s adm=Adm
    s UsrTyp=##class(web.DHCLONGTIMEORD).ssusertyp(ssuser)
	if $G(adm)="" Set qHandle=$lb(0,repid,0) Quit $$$OK
    d ..GetPatLoc(Adm)
    s depnum=1
    if CurDep=""  s depno=1  
    e  s depno=CurDep
	s num=0
	s Oew="" f  s Oew=$O(^OEORD(0,"Adm",adm,Oew)) q:Oew=""  d 
	.s OrdSub=""  f  s OrdSub=$O(^OEORD(Oew,"I",OrdSub))  q:OrdSub=""  d
	..Q:$G(^EnsInfo("ordLink",Oew_"||"_OrdSub))
	..s OrdDep=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",3)
	..q:OrdDep=""
	..s odt=$P($G(^OEORD(Oew,"I",OrdSub,3)),"^",7),otim=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",17)
	..s ODTim=odt*86400+otim
	..s depnum=##class(web.DHCLONGTIMEORD).getdepno(adm,ODTim)
	..q:(depnum'=depno)&&(depnum'="")  
	..//+wxl090903 按医嘱开科室或接受科室查询
	..s SchLoc=$P($G(^OEORD(Oew,"I",OrdSub,7)),"^",2)
	..s SchLoc=$p(SchLoc,$c(1))
	..q:(SelDocDep="Y")&(DocDepId'="")&(DocDepId'=SchLoc)
	..s OrdRecDepId=$P($G(^OEORD(Oew,"I",OrdSub,3)),"^",6)
	..q:(SelRecDep="Y")&(RecDepId'="")&(RecDepId'=OrdRecDepId)
	..s OrdDate=$P($G(^OEORD(Oew,"I",OrdSub,3)),"^",7)  ;取得医嘱表医嘱日期?
	..s OrdTime=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",17)
	..s PriorDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",8)     ;OEC_Priority                OEORI_Priority_DR
	..i PriorDR="" q //ypz
	..s PriorDes=$P(^OECPR(PriorDR),"^",2)
	..s oecprCode=$P(^OECPR(PriorDR),"^",1)
	..s PriorDes="^"_PriorDes_"^"
	..q:(^DHCOEOrdPrintSet("OrdTyp")'[PriorDes)
	..s DoctorDr=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",11)
	..s user=$P($G(^OEORD(Oew,"I",OrdSub,7)),"^",1)
	..q:user=""
	..q:'$D(^SSU("SSUSR",user))
	..s DoctorDr=$P($g(^SSU("SSUSR",user)),"^",14)
	..q:DoctorDr=""  
	..s Notes=""
	..s truedoc=0
	..s DocLoc="" 
	..f  s DocLoc=$O(^RB("RES",0,"CTPCP",DoctorDr,DocLoc)) q:DocLoc=""  d
	...if $D(^TMP($J,"PatLoc",adm,DocLoc)) d
	....s truedoc=1
	..q:($G(truedoc)'=1)&(UsrTyp'="NURSE") 
	..f rnum=1:1:$G(^OEORD(Oew,"I",OrdSub,"DEP",0))  d
	...s Notes=Notes_$G(^OEORD(Oew,"I",OrdSub,"DEP",rnum))
	..i $G(Notes)="" s Notes=""
	..i DoctorDr'=""  s Doctor=$P($g(^CTPCP(DoctorDr,1)),"^",2) ;write doctor oeori_doctor_dr
	..e  s Doctor=""
    ..if DoctorDr'="" s CpTypDR=$P($g(^CTPCP(DoctorDr,1)),"^",4)  ;CTPCP_CarPrvTp_DR
	..q:$g(CpTypDR)=""
	..q:'$D(^CT("CPT",CpTypDR))
	..s CpTyp=""
	..i $G(CpTypDR)'="" s CpTyp=$P($g(^CT("CPT",CpTypDR)),"^",4)  ;CT_CarPrvTp
	..q:($G(CpTyp)'="DOCTOR")&($G(^DHCOEOrdPrintSet("ifnur"))'="true")  //&(UsrTyp'="NURSE")  //ypz 061102
	..s SchLoc=$P($G(^OEORD(Oew,"I",OrdSub,7)),"^",2) // + 屏蔽科室修改，取开医嘱科室 090310
	..s SchLoc=$p(SchLoc,$c(1))
	..s SchLoc="^"_$G(SchLoc)_"^"
	..s lsNotLoc=$G(^DHCOEOrdPrintSet("NotLoc"))
	..q:($G(^DHCOEOrdPrintSet("NotLoc"))[SchLoc)&((lsNotLoc'="^^")!(lsNotLoc'="")) // +
	..if (NurOrd'=0)&(DocOrd=0)&($G(CpTyp)="DOCTOR") q
	..if (DocOrd'=0)&(NurOrd=0)&($G(CpTyp)="NURSE") q
    ..s DateEx="",TimeEx="" ,CPTEx=""
	..s cl=0 s cl=$O(^OEORD(Oew,"I",OrdSub,"X",cl))
	..i cl=""  s cl=1
	..i $D(^OEORD(Oew,"I",OrdSub,"X",cl))  d
	...s DateEx=$P(^OEORD(Oew,"I",OrdSub,"X",cl),"^",19) i DateEx'="" s DateEx=$ZD(DateEx,3)  ;nursing execute
	...s TimeEx=$P(^OEORD(Oew,"I",OrdSub,"X",cl),"^",20)  i TimeEx'=""  s TimeEx=..%ZT(TimeEx,2)
	...s CPTExDR=$P(^OEORD(Oew,"I",OrdSub,"X",cl),"^",15)
	...i CPTExDR'="" s CPTEx=$P($G(^CTPCP(CPTExDR,1)),"^",2)  
	...e  d
	....s StopStr=##class(web.DHCLONGTIMEORD).SingNur(Oew,OrdSub)
	....if StopStr'="" d
	.....s DateEx=$P(StopStr,"|",1),TimeEx=$P(StopStr,"|",2),CPTEx=$P(StopStr,"|",3)
	.....;s CPTEx=""
	..s str=""
	..s str=..PRX(Oew,OrdSub)
	..if str'="" d
	...s ExDoctor=$P(str,"|",3)
	...s ExDate=$P(str,"|",1)
	...s ExTime=$P(str,"|",2)
	..e  d
	...s ExDoctor=""
	...s ExDate=""
	...s ExTime=""
	..s ArcimDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",2)
	..s ARCIMRowid=$P(ArcimDR,"||",1)
	..s ARCIMSub=$P(ArcimDR,"||",2) 
	..s pacunit=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,8)),"^",14)
	..if pacunit'="" s pacunit=$P(^CT("UOM",pacunit),"^",2) 
	..s ItemCatDR=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",10) ;oeori_itmmast_dr->arcim_itemcat_dr->arcic_ordcat_dr->orcat_code
	..q:(ItemCatDR="")
	..s OrdCatDR=$P(^ARC("IC",ItemCatDR),"^",8)    ;ARc_Itemcat
	..s CatDR="^"_OrdCatDR_"^"
	..s OrdCat=$P(^OEC("ORCAT",OrdCatDR),"^",1)    ;OEC_OrderCategory           ARCIC_OrdCat_DR 
	..s OrdCat="^"_OrdCat_"^"
	..s ARCIMD=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",2)  ;ord name   
	..s ARCIMDesc=$P(ARCIMD,"]",2)
	..if ARCIMDesc="" s ARCIMDesc=$P(ARCIMD,"]",1)
	..s OrdTyp=$P(^ARC("IC",ItemCatDR),"^",7)
	..if OrdTyp="R"  s ARCIMDesc=##class(web.DHCLONGTIMEORD).PhGener(ARCIMRowid,ARCIMSub)
    ..q:$G(^DHCOEOrdPrintSet("NotOrdCat"))[CatDR&($G(^DHCOEOrdPrintSet("NotOrdCat"))'="")
    ..s ItemCatDRStr="^"_ItemCatDR_"^" 
	..q:$G(^DHCOEOrdPrintSet("NotSordCat"))[ItemCatDRStr&($G(^DHCOEOrdPrintSet("NotSordCat"))'="")
    ..s flageCaiLiao=..getFlageCL(ARCIMRowid,ARCIMSub)   //DiTan
    ..q:(flageCaiLiao=1)&(stop=0)
	..s PHFreqDR=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",4)  ;eat medcine medicine frequency
	..i (PHFreqDR'="") d
	...if $D(^PHCFR(PHFreqDR)) s PHFreq=$P(^PHCFR(PHFreqDR),"^",3) 
	...e  s PHFreq=""
	..e  s PHFreq=""  ;table       PHC_Freq
	..s UOMDR=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",3  ) ;CT_UOM                      OEORI_Unit_DR
	..i UOMDR'="" s UOM=$P(^CT("UOM",UOMDR),"^",2)  
	..e  s UOM="" 
	..s DoseQty=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",1)   ;numeric  oeori_doseqty,ji Liang
	..if (DoseQty'="")&(($P(DoseQty,"."))="") s DoseQty="0"_DoseQty
	..s PhQtyOrd=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",12)  ;oeori_Phqtyord  shu liang
	..s MethDR=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",7)   ;PHC_Instruc                 OEORI_Instr_DR
	..i MethDR'="" s Meth=$P(^PHCIN(MethDR),"^",2)  
	..e   s Meth=""
	..S SpeedFlowRate=$P($G(^OEORD(Oew,"I",OrdSub,3)),"^",17)
	..s SpeedFlowUnitDr=$P($G(^OEORD(Oew,"I",OrdSub,6)),"^",8)
	..i SpeedFlowUnitDr'="" s SpeedFlowUnit=$p($g(^OEC("SFR",SpeedFlowUnitDr)),"^",2)
	..s SpeedFlow=$g(SpeedFlowRate)_" "_$g(SpeedFlowUnit)
	..s Meth=Meth_" "_SpeedFlow
	..s DurDR=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",6)   ;         OEORI_Durat_DR->phcdu_desc1, PHC_Duration
	..i DurDR'="" s During=$P(^PHCDU(DurDR),"^",3)   
	..e  s During=""  ;           period of treatment
	..s StDate=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",9)
	..s StTime=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",10) 
	..s OrdStatDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",13)  ; OEC_OrderStatus             OEORI_ItemStat_DR 
    ..q:OrdStatDR=2 
	..i OrdStatDR'="" s OrdStat=$P(^OEC("OSTAT",OrdStatDR),"^",1) 
	..e  s OrdStat=""  ;ord status
	..q:OrdStatDR=11
	..s Seq2=$P($G(^OEORD(Oew,"I",OrdSub,3)),"^",4)  ;relation No
	..s SeqNo=$p($g(^OEORD(Oew,"I",OrdSub,11)),"^",39) //qshe add 05-08-22
    ..if SeqNo'="" d
    ...s tmpSeqNo=$P(SeqNo,"||",2) ,ARCIMDesc="_____"_ARCIMDesc
    ..e  s tmpSeqNo=OrdSub
    ..s Seq1=tmpSeqNo
    ..s PackNum=""
	..s PadmTyp=$P(^PAADM(adm),"^",2)
	..s PackNum=$P($G(^OEORD(Oew,"I",OrdSub,9)),"^",4)  ;zheng baozhuang shu   OEORI_QtyPackUOM
	..s RefundQty=$P($G(^OEORD(Oew,"I",OrdSub,3)),"^",23)
	..s TZh=""
	..if (OrdStatDR=4)&(^DHCOEOrdPrintSet("OrdCat")[OrdCat) d
	...s Ret=..PHPACK(Oew,OrdSub)  //退药情况
	...i Ret=1 s TZh="Pass"  
	..s numstr="",QtyStr=""
	..if $G(PackNum)'="" s PackStr=$G(PackNum)_""_$G(pacunit)
	..if $G(PhQtyOrd)'="" s QtyStr=$G(PhQtyOrd)_" "_$G(UOM)
	..if $G(PackStr)'="" s numstr=$G(PackStr)
	..e  s numstr=$G(QtyStr)
	..if PackNum="" s numstr=""
	..q:(OrdStat="D")&($G(^DHCOEOrdPrintSet("ifstop"))'="true")
	..s xCtcpDesc="" //ypz 070802
	..s xCtcpId=$p($g(^OEORD(Oew,"I",OrdSub,3)),"^",29) //ypz 070802
	..i xCtcpId'="" s xCtcpDesc=" "_$p($g(^CTPCP(xCtcpId,1)),"^",2) //ypz 070802
	..i OrdStat="D" s Cancel="---DC"_xCtcpDesc ;Doctor //ypz 070802
	..e  s Cancel=""
	..q:(OrdStat="D")&(stop="0")   ///(UsrTyp="NURSE")&jst add qse 070416
    ..s i=i+1
    ..s skintest="",abnorm=""
    ..s skintest=$p($g(^OEORD(Oew,"I",OrdSub,5)),"^",2)
    ..if (skintest="Y")&(OrdStat'="D") d
    ...s skinnote=..skinnote(Oew,OrdSub) //w !,OrdSub
    ...s abnorm=$p($g(^OEORD(Oew,"I",OrdSub,11)),"^",3)
    ...if abnorm="Y" s ARCIMDesc=ARCIMDesc_"(+)"_skinnote  //070815
    ...if abnorm="N"  s ARCIMDesc=ARCIMDesc_"(-)"_skinnote
    ..if SeqNo'=""  s ARCIMDesc=""_ARCIMDesc
    ..s deeppurple=$p($g(^OEORD(Oew,"I",OrdSub,11)),"^",55)
    ..i deeppurple="Y"  s ARCIMDesc=ARCIMDesc_"-急查"
	..if PriorDes["自备"  s ARCIMDesc=ARCIMDesc_"(自备)"
	..if PriorDes["出院"  s ARCIMDesc=ARCIMDesc_"(带药)"
	..if PriorDes["取药"  s ARCIMDesc=ARCIMDesc_"(取药)"
	..s minDose=..getMinDose(ARCIMRowid,ARCIMSub)
	..if ^DHCOEOrdPrintSet("OrdCat")[OrdCat d
	...//.s ARCIMDesc=..GetArcim(ARCIMDesc)     ;w !, PriorDes_ARCIMDesc//
	...i oecprCode="OUT" d  // 药名+正包装数/剂量 用法，频次  d
	....//s ARCIMDesc=ARCIMDesc_" "_$G(numstr)_"/"_DoseQty_""_UOM_" "_Meth_" "_PHFreq_""_$G(Cancel)_" "_$G(Notes)
	....s ARCIMDesc=ARCIMDesc_" "_minDose_"*"_$G(numstr)_"/"_DoseQty_""_UOM_" "_Meth_" "_PHFreq
	...i oecprCode="ONE" d  //ypz 070802 //if PriorDes="^取药医嘱^" d
	....//s ARCIMDesc=ARCIMDesc_" "_$G(numstr)_"/"_DoseQty_""_UOM_" "_Meth_" "_PHFreq_""_$G(Cancel)_" "_$G(Notes)
	....if $G(numstr)="" d
	.....s DoseQty=..getsumdos(DurDR,PHFreqDR,DoseQty)
	.....//if OrdSub=1678 w !,DurDR,"--",PHFreqDR,"--",DoseQty,"--",UOMDR,"--",ARCIMRowid
	.....s ARCIMDesc=ARCIMDesc_" x"_..getphbasnum(UOMDR,DoseQty,ARCIMRowid,ARCIMSub)_" "_PHFreq
	....if $G(numstr)'="" s ARCIMDesc=ARCIMDesc_" "_minDose_"x "_$G(numstr)
	...//if (PriorDes="^即刻医嘱^")!(PriorDes="^临时医嘱^")!(PriorDes="^自备药即刻^")!(PriorDes="^自备药临时^") d
	...if oecprCode="NORM" d
	....s ARCIMDesc=ARCIMDesc_" "_DoseQty_""_UOM_" "_$G(Meth)_" "_PHFreq
	...if (oecprCode="STAT")!(oecprCode="^自备药即刻^")!(oecprCode="OM") d
	....s ARCIMDesc=ARCIMDesc_" "_DoseQty_""_UOM_" "_$G(Meth)_" "_PHFreq  //_" "_"st"
	....//s ARCIMDesc=ARCIMDesc_" "_DoseQty_" "_UOM_" "_$G(Meth)_" "_PHFreq_" "_""_$G(numstr)_""_" "_$G(Cancel)_" "_$G(Notes)
	...s ARCIMDesc=ARCIMDesc_" "_$g(Notes)
	..e  d
	...s flageX=..GetFlage(ARCIMRowid,ARCIMSub)
	...s ARCIMDesc=ARCIMDesc_" "_$G(Notes)_$G(UOM)_" "_PHFreq
	..if (oecprCode="STAT") s ARCIMDesc=ARCIMDesc_" st"  //" [紧急]"  
	..s ARCIMDesc=ARCIMDesc_"  "_$G(Cancel)
	..s ^OrdList($j,adm,OrdDate,OrdTime,Seq1,Seq2)=$E($ZD(OrdDate,3),3,10)_"|"_..%ZT(OrdTime,2)_"|"_$G(Doctor)_"|"_ARCIMDesc_"|"_$G(ExDoctor)_"|"_$G(TimeEx)_"|"_$G(CPTEx)_"|"_$TR($E($G(DateEx),6,10),"-","/")
	..s OrdDC(OrdDate,OrdTime,Seq1,Seq2)=$G(Cancel)
    ..s OrdSub(OrdDate,OrdTime,Seq1,Seq2)=Oew_"||"_OrdSub
	..s OrdStat(OrdDate,OrdTime,Seq1,Seq2)=OrdStat
	..s OrdDose(OrdDate,OrdTime,Seq1,Seq2)=$G(DoseQty)
	..if StTime="" s StTime=OrdTime
	s i=0
	s OrdDate=""  f  s OrdDate=$O(^OrdList($j,adm,OrdDate))  q:OrdDate=""  d
	.s tim="" f  s tim=$O(^OrdList($j,adm,OrdDate,tim))  q:tim=""  d
	..s Seq1=""  f  s Seq1=$O(^OrdList($j,adm,OrdDate,tim,Seq1)) q:Seq1=""  d
	...s Seq2=""  f  s Seq2=$O(^OrdList($j,adm,OrdDate,tim,Seq1,Seq2))  q:Seq2=""  d
	....s ORW="", DisposNurDr="",DisposNur="",DisposDate="",DisposTime="",TimeEx="",DateEx="",CPTEx=""
	....s OerdDate=$P(^OrdList($j,adm,OrdDate,tim,Seq1,Seq2),"|",1)
	....s OerdTime=$P(^OrdList($j,adm,OrdDate,tim,Seq1,Seq2),"|",2)
	....s Doctor=$P(^OrdList($j,adm,OrdDate,tim,Seq1,Seq2),"|",3)
	....s ARCIMDesc=$P(^OrdList($j,adm,OrdDate,tim,Seq1,Seq2),"|",4)
	....s ExDoctor=$P(^OrdList($j,adm,OrdDate,tim,Seq1,Seq2),"|",5)
	....s TimeEx=$P(^OrdList($j,adm,OrdDate,tim,Seq1,Seq2),"|",6)
	....s DateEx=$P(^OrdList($j,adm,OrdDate,tim,Seq1,Seq2),"|",8)
	....s CPTEx=$P(^OrdList($j,adm,OrdDate,tim,Seq1,Seq2),"|",7)
	....i CPTEx="" s DateEx="",TimeEx=""
	....i OrdStat(OrdDate,tim,Seq1,Seq2)["C"  d
	.....s ARCIMDesc=ARCIMDesc_" ----Cancel"
	.....s TimeEx=""
	.....s DateEx=""
	.....s CPTEx=""
	....i (OrdStat(OrdDate,tim,Seq1,Seq2)["U")  d
	.....s ARCIMDesc=ARCIMDesc_" ----DC"
	.....s TimeEx=""
	.....s DateEx=""
	.....s CPTEx=""
	....s ORW=OrdSub(OrdDate,tim,Seq1,Seq2),OrdStat=OrdStat(OrdDate,tim,Seq1,Seq2)
	....s rw=$P(ORW,"||"),chl=$P(ORW,"||",2)
	....if $D(^DHCLOGSHORTORD("lsord",ORW)) d
	.....s ExDC=$P(^DHCLOGSHORTORD("lsord",ORW),"^",1)
	.....s ExNur=$P(^DHCLOGSHORTORD("lsord",ORW),"^",3)
	.....s ExTime=$P(^DHCLOGSHORTORD("lsord",ORW),"^",2)
    ....if $D(^DHCCLNurseExec("oeorid",ORW)) d
	.....s DisposNurDr=$P(^DHCCLNurseExec("oeorid",ORW),"^",3) //处理人
	.....s DisposDate=$ZD($P(^DHCCLNurseExec("oeorid",ORW),"^",1),3) 
	.....s DisposTime=..%ZT($P(^DHCCLNurseExec("oeorid",ORW),"^",2),2)
	.....if DisposNurDr'=""  s DisposNur=$P(^SSU("SSUSR",DisposNurDr),"^",2)
	....if $G(DisposNurDr)="" d
	.....s DisposNur=$G(CPTEx),DisposTime=$G(TimeEx)
	....q:((OrdDate<StartDate)!(OrdDate>EndDate)&((StartDate'="")&(EndDate'="")))
    ....if $D(^DHCLONGSET("audittemp",Adm,ORW))  d  //核对
    .....s DisposNur=$G(DisposNur)_"_"_1
    ....s Status=OrdDC(OrdDate,tim,Seq1,Seq2)
    ....D OutPut
 	....s ArcimDR=$P($G(^OEORD(rw,"I",chl,1)),"^",2)  //DiTan S 某些材料医嘱只显示但医嘱单不打印
	....s ARCIMRowid=$P(ArcimDR,"||",1)
	....s ARCIMSub=$P(ArcimDR,"||",2)
	....s flageCaiLiao=..getFlageCL(ARCIMRowid,ARCIMSub)
    ....q:(flageCaiLiao=1)                           //DiTan E
    ....q:(OrdStat(OrdDate,tim,Seq1,Seq2)="D")      //DiTan 停止医嘱打印在医嘱单上
    ....s i=i+1
    ....s ^mtemp($J,"temp",Adm,i)=OerdDate_"^"_OerdTime_"^"_ARCIMDesc_"^"_Doctor_"^"_DateEx_"^"_TimeEx_"^"_CPTEx_"^"_ORW_"^"_OrdStat_"^"_$J_"^"_$G(DisposTime)_"^"_$G(DisposNur)
 k ^OrdList($j,adm)
    s ^mtemp($J,"temp",Adm)=i
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
 //"起始日期|<起始时间|<临时医嘱|<医生签字|<执行时间|<执行人"/
OutPut
	set Data=$lb(OerdDate,OerdTime,ARCIMDesc,Doctor,DateEx,TimeEx,CPTEx,ORW,$j,$G(DisposTime),$G(DisposNur),$G(ExDC),$G(ExNur),$G(ExTime),$g(Status))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
GetDocDep(Doc)
  {
  n 
  s Loc=""  s Loc=$O(^RB("RES",0,"CTPCP",Doc,Loc),-1)
  Q "^"_$G(Loc)_"^"
 }
}

ClassMethod getsumdos(dur, freqdr, dosqty) As %String
{
 //取药医嘱总剂量
	 s durfactor=1,freqfactor=1
	if dur'="" s durfactor=$P(^PHCDU(dur),"^",2)
	if freqdr'="" s freqfactor=$P(^PHCFR(freqdr),"^",2)
	q dosqty*durfactor*freqfactor
}

ClassMethod PHPACK(Ord, OrdSub)
{
   n (Ord,OrdSub)
     s i=0
	 s OrdEx=0  f  s OrdEx=$O(^OEORD(Ord,"I",OrdSub,"X",OrdEx))  q:(OrdEx="")  d
    .s OrdDsp=0  f  s OrdDsp=$O(^OEORD(Ord,"I",OrdSub,"X",OrdEx,"D",OrdDsp)) q:(OrdDsp="")!(i=1)  d
    ..s Dsp=^OEORD(Ord,"I",OrdSub,"X",OrdEx,"D",OrdDsp) 
    ..s Stat=$P(Dsp,"^",6)
    ..q:Stat'="C"
    ..s Qty=$G(Qty)+$P(Dsp,"^",1) 
    ..s ReQty=$G(ReQty)+$P(Dsp,"^",7)
    ..
    if $G(Qty)=$G(ReQty) s Re=1
    e  s Re=0 
    q Re
}

ClassMethod PHASTAT(Ord, OrdSub)
{
 
   n (Ord,OrdSub)
     s i=0
	
	 s OrdEx=0  f  s OrdEx=$O(^OEORD(Ord,"I",OrdSub,"X",OrdEx))  q:(OrdEx="")!(i=1)  d
    .s OrdDsp=0  f  s OrdDsp=$O(^OEORD(Ord,"I",OrdSub,"X",OrdEx,"D",OrdDsp)) q:(OrdDsp="")!(i=1)  d
    ..s Dsp=^OEORD(Ord,"I",OrdSub,"X",OrdEx,"D",OrdDsp) 
    ..s i=i+1
    ..s Stat=$P(Dsp,"^",6)  
    ..b
 q $G(Stat)
}

ClassMethod GetItem(i As %String, Adm As %String, strj As %String)
{
	q ^mtemp(strj,"temp",Adm,i)
}

ClassMethod GetItemNum(Adm As %String, strj As %String)
{
	q ^mtemp(strj,"temp",Adm)
}

ClassMethod getmother(adm) As %String
{
 //取母亲的登记号
	s motheradm=$P(^PAADM(adm),"^",75)
	if motheradm'="" {
	    s papmiId=+^PAADM(motheradm)
        s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)
        ;s MedNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)
	}
	q $G(regNo)
}

ClassMethod GetPatLoc11(Adm As %String)
{
  	n (Adm)
  	s i=1
  	s PreLoc=""
  	s stdate=$P(^PAADM(Adm),"^",6)
  	k ^TMP($J,"loc")
  	s chl="" f  s chl=$O(^PAADM(Adm,"TRANS",chl)) q:chl=""  d
  	.s loc=$P(^PAADM(Adm,"TRANS",chl),"^",6)
  	.s stdate=$P(^PAADM(Adm,"TRANS",chl),"^",1)
  	.s sttime=$P(^PAADM(Adm,"TRANS",chl),"^",2)
  	.s enddate=$P(^PAADM(Adm,"TRANS",chl),"^",3)
    .s endtime=$P(^PAADM(Adm,"TRANS",chl),"^",4)
    .q:loc=""
  	.//i (loc'=PreLoc) d
  	.s ^TMP1($J,"loc",Adm,chl,loc)=((stdate*86400)+sttime)_"^"_((enddate*86400)+endtime)
  	.s tmp(loc)=chl
  	.s i=i+1
  	.s PreLoc=loc
  	 //清除多余的，每个科室只保留一条记录
  	 s chl=""  f  s chl=$O(^TMP1($J,"loc",Adm,chl)) q:chl=""  d
  	 .s loc=""  f  s loc=$O(^TMP1($J,"loc",Adm,chl,loc)) q:loc=""  d
  	 ..if chl'=tmp(loc) k ^TMP1($J,"loc",Adm,chl,loc)
  	q
}

ClassMethod GetPatLoc(Adm As %String)
{
  	n (Adm)
  	s i=1
  	s PreLoc=""
  	s tmp=""
  	s stdate=$P(^PAADM(Adm),"^",6)
  	s tod=(+$H*86400)+..%SysTime()
  	k ^TMP($J,"loc"),^TMP($J,"PatLoc")
  	s chl="" f  s chl=$O(^PAADM(Adm,"TRANS",chl)) q:chl=""  d
  	.s loc=$P(^PAADM(Adm,"TRANS",chl),"^",6)
  	.s stdate=$P(^PAADM(Adm,"TRANS",chl),"^",1)
  	.s sttime=$P(^PAADM(Adm,"TRANS",chl),"^",2)
  	.s enddate=$P(^PAADM(Adm,"TRANS",chl),"^",3)
    .s endtime=$P(^PAADM(Adm,"TRANS",chl),"^",4)
    .q:loc=""
    .s temp(chl,loc)=(enddate*86400)+endtime
  	.i (loc'=PreLoc) d
  	..s ^TMP($J,"loc",Adm,chl,loc)=((stdate*86400)+sttime)_"^"_((enddate*86400)+endtime)
  	..s i=i+1
  	..s tmp=chl_"^"_loc
  	.s PreLoc=loc
  	// 指定每个科最后时间
  	 s chl=""  f  s chl=$O(^TMP($J,"loc",Adm,chl)) q:chl=""  d
  	 .s loc=""  f  s loc=$O(^TMP($J,"loc",Adm,chl,loc)) q:loc=""  d
  	 ..s $P(^TMP($J,"loc",Adm,chl,loc),"^",2)=temp(chl,loc) 
  	 ..s ^TMP($J,"PatLoc",Adm,loc)=""
  	//指定最后一个科室的结束时间^TMP($J,"loc",admId,DocLoc)
  	q:tmp=""
  	s chl=+$G(tmp)
  	s loc=$P($G(tmp),"^",2)
  	s $P(^TMP($J,"loc",Adm,chl,loc),"^",2)=tod
  	q
}

ClassMethod GetTempOrdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTempOrdExecute ]
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

Query GetTempOrd(Adm As %String, StartDate As %String, EndDate As %String, ChangeDate As %String, stop As %String = "0", ssuser As %String = "", Dep = "", NurOrd = 0, DocOrd = 0, SelDocDep As %String = "N", DocDepId = "", SelRecDep As %String = "N", RecDepId = "") As %Query(ROWSPEC = "OerdDate,OerdTime,ARCIMDesc,Doctor,DateEx,TimeEx,CPTEx,ORW,ProcessNo,DisposTime,DisposNur,ExDC,ExNur,ExTime,Status")
{
}

ClassMethod PRX(Oew, OrdSub)
{
	  n (Oew,OrdSub)
	  ; ^OEORD({OE_Order.OEORD_RowId},"I",{OE_OrdItem.OEORI_Childsub}, "ST",{ST_Childsub})
	   s STR=""
	   s chl=""  f  s chl=$O(^OEORD(Oew,"I",OrdSub, "ST",chl)) q:chl=""  d
	   .s statDR=$P(^OEORD(Oew,"I",OrdSub, "ST",chl),"^",3)
	   .s xdate=$P(^OEORD(Oew,"I",OrdSub, "ST",chl),"^",1)
	   .s xtime=$P(^OEORD(Oew,"I",OrdSub, "ST",chl),"^",2)
	   .s cdoc=$P(^OEORD(Oew,"I",OrdSub, "ST",chl),"^",4)
	   .if (statDR=4)&(cdoc="") s STR=$ZD(xdate,3)_"|"_..%ZT(xtime,2)_"|"_""
	   .i (statDR=4)&((cdoc'=""))  s STR=$ZD(xdate,3)_"|"_..%ZT(xtime,2)_"|"_$P(^SSU("SSUSR",cdoc),"^",2)
	   q $G(STR)
}

ClassMethod note(Oew, OrdSub)
{
	   n (Oew,OrdSub)
	   s Notes=""
	   f rnum=2:1:$G(^OEORD(Oew,"I",OrdSub,"DEP",0))  d
	.s Notes=Notes_$G(^OEORD(Oew,"I",OrdSub,"DEP",rnum))
	q $G(Notes)
}

ClassMethod startrow(typ As %String, adm As %String, page As %String, strow As %String, Dep As %String, depno As %String) As %String
{
 n (typ, adm, page, strow, Dep,depno) ////////*
  s ^DHCBLPRINTROW("D",typ,"xd",adm,"TranNo",depno,Dep)=page_"|"_strow
	  q 0
}

ClassMethod TmpStartrow(typ, adm, page, startrow, Dep) As %String
{
  //扑打设置
 s ^DHCBLPRINTROWTMP(typ,"xd",adm,Dep)=page_"|"_startrow
 q 0
}

ClassMethod KTmpSet(typ, adm, Dep) As %String
{
  //清除补打设置
  k ^DHCBLPRINTROWTMP(typ,"xd",adm,Dep)
  q 0
}

ClassMethod schtystrow(typ, adm, Dep, tranNo) As %String
{
  q:(typ="")!(adm="")!(Dep="") "" //////*
  n (typ, adm, Dep,tranNo)
  //if ($G(^DHCBLPRINTROW(typ,"xd",adm,Dep))="") {
	//   s str=$G(^DHCBLPRINTROW(typ,adm))
	//   s str1=$G(^DHCBLPRINTROW(typ,adm,Dep))
	//   if str1'=""  s ^DHCBLPRINTROW(typ,"xd",adm,Dep)=str1
	//   if str'=""  s ^DHCBLPRINTROW(typ,"xd",adm,Dep)=str
	//   k ^DHCBLPRINTROW(typ,adm)
	   //s ^DHCBLPRINTROW(typ,"xd",adm,Dep)=str
 // }
  q $G(^DHCBLPRINTROW("D",typ,"xd",adm,"TranNo",tranNo,Dep))
}

ClassMethod TmpSch(typ, adm, Dep, tranNo) As %String
{
	n (typ, adm, Dep,tranNo)  //////*
  //if ($G(^DHCBLPRINTROW(typ,"xd",adm,Dep))="") {
	//   s str=$G(^DHCBLPRINTROW(typ,adm))
	//   s str1=$G(^DHCBLPRINTROW(typ,adm,Dep))
	//   if str1'=""  s ^DHCBLPRINTROW(typ,"xd",adm,Dep)=str1
	//   if str'=""  s ^DHCBLPRINTROW(typ,"xd",adm,Dep)=str
	//   k ^DHCBLPRINTROW(typ,adm)
	   //s ^DHCBLPRINTROW(typ,"xd",adm,Dep)=str
  //}
  q $G(^DHCBLPRINTROW("D",typ,"xd",adm,"TranNo",tranNo,Dep))
}

ClassMethod SetStartPage(typ, adm, Dep, StPag, depNo)
{
 //设定转科后的起始页码
 	i Dep="" s Dep=..GetDep(adm,depNo)
	s ^DHCBLPRINTROW("D",typ,"StarPage",adm,"TranNo",depNo,Dep)=StPag
}

ClassMethod GetDep(Adm, depno) As %String
{
     // s ^TMP("q11",$J)=$LB(Adm,depno)
      s dep="" s dep=$O(^TMP($J,"loc",Adm,depno,dep))
      q dep
}

ClassMethod GetStartPage(typ, adm, Dep, depNo) As %String
{
   ///s a=##class(web.DHCTEMPOERPRINT).GetStartPage(typ, adm, Dep, depNo
    d ##CLASS(web.DHCTEMPOERPRINT).GetPatLoc(adm)
    i Dep="" s Dep=..GetDep(adm,depNo)
    q:Dep="" ""
	//s ^TMP("q")=$Lb(typ, adm, Dep, depNo)
	q $G(^DHCBLPRINTROW("D",typ,"StarPage",adm,"TranNo",depNo,Dep))
}

ClassMethod changedata(typ, head) As %String
{
  //longord,lsord
   n (typ,head)
   s adm=""  f  s adm=$O(^DHCBLPRINTROW(typ,head,adm)) q:adm=""  d
   .s locstr=##class(web.DHCLONGTIMEORD).GetTranLoc(adm)
   .s ret=..changeadmdata(typ,head,adm)
   q 1
}

ClassMethod changeadmdata(typ, head, adm) As %String
{
 
   n (typ,head,adm)
   s locstr=##class(web.DHCLONGTIMEORD).GetTranLoc(adm)
   s Dep=""  f  s Dep=$O(^DHCBLPRINTROW(typ,head,adm,Dep)) q:Dep=""  d
   .if $D(^DHCBLPRINTROW(typ,head,adm,Dep)) d
   ..s depno=..getdepno(locstr,Dep)
   ..q:depno=""
   ..s str=^DHCBLPRINTROW(typ,head,adm,Dep)
   ..s ^DHCBLPRINTROW("D",typ,head,adm,"TranNo",depno,Dep)=str
   q 1
}

ClassMethod getdepno(locstr, dep) As %String
{
  n (locstr,dep)
   s ln=$L(locstr,"|")
   for i=1:1:ln
   {
	   s tranStr=$P(locstr,"|",i)
	   s tranloc=$P(tranStr,"^")
	   s tranno=$P(tranStr,"^",4)
	   if tranloc=dep s depno=tranno 
   }
   q $G(depno)
}

ClassMethod saveordno(typ, ordno, flag) As %String
{
	    s ^DHCLOGSHORTORD(typ,ordno)=flag
	    q 0
}

ClassMethod fetchordno(typ, ordno) As %String
{
	    q $G(^DHCLOGSHORTORD(typ,ordno))
}

ClassMethod savestopord(ordno, typ) As %String
{
  
        ///停止医嘱

	    /// k (typ,ordno)stoporditem
	      s ^DHCSTOPORDITEM(ordno,typ)=""
	      q 0
}

ClassMethod stoporditem(ordno, typ) As %String
{
 //k (typ,ordno)
	      q $D(^DHCSTOPORDITEM(ordno,typ))
}

ClassMethod GetArcim(arc) As %String
{
 n (arc)
 //s arc="asdfasdfadf(asdf)(d*sdf)"
 s arc1=$P(arc,"(",1) 
 s arc2=$P(arc,"(",2)
 s arc3=$P(arc,"(",3)
 s arc4=$P(arc,"(",4)
 s arc5=$P(arc,"(",5)
 s arc6=$P(arc,"(",6)
 s a=arc1
 s f1=$F(arc2,"*")
 
 if (f1=0)&(arc2'="") s a=$G(a)_"("_arc2
 b
 s f1=$F(arc3,"*")
 if (f1=0)&(arc3'="") s a=$G(a)_"("_arc3
 b
 s f1=$F(arc4,"*")
 if (f1=0)&(arc4'="") s a=$G(a)_"("_arc4
 b
 s f1=$F(arc5,"*")
 if (f1=0)&(arc5'="") s a=$G(a)_"("_arc5
 s f1=$F(arc6,"*")
 if (f1=0)&(arc6'="") s a=$G(a)_"("_arc6
 
 q a
}

ClassMethod UpdateDate(par, exdate, extime) As %String
{
	n (par,exdate,extime)
	s exdate=$ZDH(exdate,3)
	s extime=..%ZTH(extime)
	&sql(update oe_ordexec set OEORE_DateExecuted=:exdate, OEORE_TimeExecuted=:extime where oeore_oeori_parref=:par)
	q SQLCODE
}

ClassMethod UpdateStDate(Row, StDate, StTime) As %String
{
	n (Row, StDate, StTime)
	S StDate=$ZDH(StDate,3)
	s StTime=..%ZTH(StTime)
	&sql(update oe_orditem set  OEORI_SttDat=:StDate,  OEORI_SttTim=:StTime where oeori_rowid=:Row)
	q SQLCODE
}

ClassMethod SaveHBord(oeoriIdStr) As %String
{
	//保存后补不打印医嘱
	s cl=$P(oeoriIdStr,"^",1)
	if cl="Clear"
	{
		s orw=$P($P(oeoriIdStr,"^",2),"||",1)
		k ^DHCTEMPHBORD(orw)
	}
	q:cl="Clear" 0
	s num=$l(oeoriIdStr,"^")
		s oeoriId=$p(oeoriIdStr,"^",1)
	    s oew=$P(oeoriId,"||")
        k ^DHCTEMPHBORD(oew)
		f i=1:1:num d
	    .s oeoriId=$p(oeoriIdStr,"^",i)
	    .s oew=$P(oeoriId,"||")
	    .s sub=$P(oeoriId,"||",2)
	    .s ^DHCTEMPHBORD(oew,sub)=""
	 q 0
}

ClassMethod GetOrdChecked(oeord) As %String
{
  n (oeord)
	s orw=$P(oeord,"||")
	s sub=$P(oeord,"||",2)
	if $D(^DHCTEMPHBORD(orw,sub)) s ret=1
	else  s ret=0
	q ret
}

ClassMethod getloc(oeord, ordsub) As %String
{
	 n (oeord,ordsub)
    s admId=$p($g(^OEORD(oeord)),"^",1)
	s ctlocdr=$P(^PAADM(admId),"^",4)
	 s user=$P($G(^OEORD(oeord,"I",ordsub,7)),"^",1)
	 s userdep=$P($G(^OEORD(oeord,"I",ordsub,7)),"^",2)  //oeori_UserDepartment_DR
	 q:user="" ""
	 q:'$D(^SSU("SSUSR",user)) ""
	 s DoctorDr=$P(^SSU("SSUSR",user),"^",14)
	 q:DoctorDr="" "" ;s Notes=$G(^OEORD(Oew,"I", OrdSub,"DEP",1))

	 q:'$D(^CTPCP(DoctorDr,1)) ""
	 s typdr=$P(^CTPCP(DoctorDr,1),"^",4)
	 s typ=$P(^CT("CPT",typdr),"^",4)
	 s i=0
	 s loc="" f  s loc=$O(^RB("RES",0,"CTPCP",DoctorDr,loc)) q:(loc="")  d
	 .s i=i+1
	 s loc="" f  s loc=$O(^RB("RES",0,"CTPCP",DoctorDr,loc)) q:(loc="")!(loc=ctlocdr)  d
	 if (i>2)&(userdep'=ctlocdr)&(userdep'="")
	 {
		 q ""
	 }

	 q loc
}

// add by WKZ 071213

ClassMethod GetUserType(userId) As %String
{
	q:userId=""
	s userDr=$P($G(^SSU("SSUSR",userId)),"^",14)
	q:userDr="" "" 
    s CpTypDR=$P(^CTPCP(userDr,1),"^",4)         
	i $G(CpTypDR)'="" s CpTyp=$P($G(^CT("CPT",CpTypDR)),"^",4)  
	q CpTyp
}

ClassMethod GetFlage(ARCIMRowid, ARCIMSub) As %String
{
	s flage=0
	s billSubDr=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",9)
	q:billSubDr="" flage
	i (billSubDr="61||2")!(billSubDr="61||3") s flage=1
	//s bgRowId=$P(billSubDr,"||",1)
	//s bgChilSub=$P(billSubDr,"||",1)
	//s sgCode=$P($G(^ARCBG(bgRowId,"SG",bgChilSub)),"^",1)
	//i (sgCode["HHH")!(sgCode["HHH")  s flage=1
	q flage
}

ClassMethod getMinDose(ARCIMRowid, ARCIMSub) As %String
{
	s retStr=""
	s phcDFDr=$P($G(^ARCIM(ARCIMRowid, ARCIMSub,1)),"^",12)
	q:phcDFDr="" retStr
	s phcDFRowId=$P($G(phcDFDr),"||",1)
	q:phcDFRowId="" retStr
	s phcDFSubRowId=$P($G(phcDFDr),"||",2)
	q:phcDFSubRowId="" retStr
	s phcDFChildSub=$O(^PHCD(phcDFRowId,"DF",phcDFSubRowId,"EQ",""),-1)
	q:phcDFChildSub="" retStr
	s eqQty=$P($G(^PHCD(phcDFRowId,"DF",phcDFSubRowId,"EQ",phcDFChildSub)),"^",2)
	q:eqQty="" retStr
	s uomDr=$P($G(^PHCD(phcDFRowId,"DF",phcDFSubRowId,"EQ",phcDFChildSub)),"^",1)
	i uomDr'="" s uomDesc=$P(^CT("UOM",uomDr),"^",2)
	i (eqQty'="")&(eqQty<1) 	s eqQty="0"_eqQty
	s retStr=eqQty_$G(uomDesc)
	q retStr
}

ClassMethod getFlageCL(ARCIMRowid, ARCIMSub)
{
	s flage=0
	s billSubDr=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",9)
	q:billSubDr="" flage
	i billSubDr="61||1" s flage=1
	q flage
}

}
