Import SQLUser

Include Nur.DateFormat

/// 住院临床公共程序
Class web.DHCCLCom Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 408;

/// 根据admType为I,O,E找科室
Query LookUpCtloc(admType As %String = "I", desc As %String = "") As %Query(ROWSPEC = "ctlocDesc:%String,ctlocId:%String")
{
}

ClassMethod LookUpCtlocExecute(ByRef qHandle As %Binary, admType As %String = "", desc As %String = "") As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
	s rowid=0
	s desc=$$ALPHAUP^SSUTIL4(desc)
	i (admType="")!("OE"[admType) d
		.s curDesc=desc
		.i curDesc'="" s curDesc=$o(^CTLOC(0,"Desc",curDesc),-1)
		.f  s curDesc=$o(^CTLOC(0,"Desc",curDesc)) q:curDesc=""  d
			..;q:(desc'="")&&($p(curDesc,desc)'="")
			..s ctlocId=$o(^CTLOC(0,"Desc",curDesc,""))
			..q:'$d(^CTLOC(ctlocId))
			..s ctlocDesc=$p(^CTLOC(ctlocId),"^",2)
			..s CTLocCode= $p($g(^CTLOC(ctlocId)),"^",43)
			..q:(CTLocCode'[desc)&&(ctlocDesc'[desc)
			..d OutputRow4
 	e  d
		.s admlocId=0
		.f  s admlocId=$o(^PAC("ADMLOC",admlocId)) q:admlocId=""  d
	    	..i admType'[$p(^PAC("ADMLOC",admlocId),"^") q  //jst
	    	..s ctlocId=$p(^PAC("ADMLOC",admlocId),"^",2)
	    	..q:'$D(^CTLOC(ctlocId))
	    	..s ctlocDesc=$$ALPHAUP^SSUTIL4($p(^CTLOC(ctlocId),"^",2))
	    	..s CTLocCode= $p($g(^CTLOC(ctlocId)),"^",43)
	    	..q:(desc'="")&&(CTLocCode'[desc)&&(ctlocDesc'[desc)
	    	..;i (desc'="")&($p(ctlocDesc,desc,1)'="") q
	    	..d OutputRow4
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
OutputRow4
	s Data=$lb(ctlocDesc,ctlocId)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod LookUpCtlocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpCtlocExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
	//
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {				// fetch row
 		s Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod LookUpCtlocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpCtlocExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

Query LookUpWard(code As %String, locType As %String = "W", hospId As %String = "") As %Query(ROWSPEC = "wardDesc:%String,wardId:%String")
{
}

ClassMethod LookUpWardExecute(ByRef qHandle As %Binary, code As %String, locType As %String = "W", hospId As %String = "") As %Status
{
	s repid=$i(^CacheTemp)
 	s ind=1
 	s sub=0 f  s sub=$o(^PAWARD(sub)) q:(+sub=0)  d
    	.q:$p(^PAWARD(sub),"^",6)'="Y"
    	.s desc=$p($g(^PAWARD(sub)),"^",2) ;$$ALPHAUP^SSUTIL4()
    	.s CTLocDr= $p($g(^PAWARD(sub)),"^",5)
  		.s CTLocCode= $p($g(^CTLOC(CTLocDr)),"^",43)
  		.s comparWarddesc=$$ALPHAUP^SSUTIL4(CTLocCode)
    	.q:((comparWarddesc'[$$ALPHAUP^SSUTIL4(code))&&($$ALPHAUP^SSUTIL4(desc)'[$$ALPHAUP^SSUTIL4(code))&(code'=""))
    	.s locId=$p(^PAWARD(sub),"^",5)
    	.q:locId=""
    	.q:$p($g(^CTLOC(locId)),"^",13)'=locType
    	.q:(locType'="")&(("^"_locType_"^")'[("^"_$p($g(^CTLOC(locId)),"^",13)_"^"))
    	.s isCurHosp=0
    	.i hospId'="" d
    	..s CTLocHosp = $p($g(^CTLOC(locId)),"^",22)
    	..i hospId'=CTLocHosp s isCurHosp=1
    	.q:isCurHosp=1
    	.s dateFrom=$P(^PAWARD(sub),"^",7)
 		.s dateTo=$P(^PAWARD(sub),"^",9)
 		.s h=+$h
 		.q:(((h<dateFrom)&&(dateFrom'=""))!((h>dateTo)&&(dateTo'="")))
   		.d OutwardRow
    s qHandle=$lb(0,repid,0)
	q $$$OK
OutwardRow
	s Data=$lb(desc,sub)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod LookUpWardFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpWardExecute ]
{
	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {			
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod LookUpWardClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpWardExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
    q $$$OK
}

Query FindArcic() As %Query(ROWSPEC = "desc:%String,rowId:%String")
{
}

ClassMethod FindArcicExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$i(^CacheTemp)
 	s ind=1
 	s rowId=0  f  s rowId=$o(^ARC("IC",rowId))  q:rowId=""  d
 		.s desc=$p(^ARC("IC",rowId),"^",2)
 		.d Outputcat
    s qHandle=$lb(0,repid,0)
	q $$$OK
Outputcat
	s Data=$lb(desc,rowId)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindArcicFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindArcicExecute ]
{
	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {			
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindArcicClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindArcicExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
    q $$$OK
}

/// 根据设置选择医嘱分类(大类或子类)
Query FindOrdCatExt() As %Query(ROWSPEC = "desc:%String,rowId:%String")
{
}

ClassMethod FindOrdCatExtExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$i(^CacheTemp)
 	s ind=1
 	i $g(^DHCCLSet("Exec","OrderSubCat"))="Y" d
 		.k arcicList
 		.s arcicDesc=""
 		.f  s arcicDesc=$o(^ARC("IC",0,"Desc",$$ALPHAUP^SSUTIL4(arcicDesc))) q:arcicDesc=""  d
 			..s arcicId=$o(^ARC("IC",0,"Desc",$$ALPHAUP^SSUTIL4(arcicDesc),""))
 			..q:arcicId=""
 			..s orcatDesc=$p(^OEC("ORCAT",+$p(^ARC("IC",arcicId),"^",8)),"^",2)
 			..q:orcatDesc=""
 			..s arcicList(orcatDesc_"-"_arcicDesc)=arcicId
 		.s desc=""
 		.f  s desc=$o(arcicList(desc)) q:desc=""  d
 			..s rowId=arcicList(desc)
 			..d OutputCatExt
 		.k arcicList
 	e  d
 		.s rowId=0  f  s rowId=$o(^OEC("ORCAT",rowId))  q:rowId=""  d
 			..s desc=$p(^OEC("ORCAT",rowId),"^",2)
 			..d OutputCatExt
    s qHandle=$lb(0,repid,0)
	q $$$OK
OutputCatExt
	s Data=$lb(rowId,desc)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindOrdCatExtFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOrdCatExtExecute ]
{
	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" { // if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else {			
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindOrdCatExtClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOrdCatExtExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
    q $$$OK
}

/// 取医嘱大类
Query GetOrcat() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ORCAT_Rowid:%Integer,ORCAT_Desc:%String")
{
    select ORCAT_RowId,ORCAT_Desc from OEC_OrderCategory
}

/// 取医嘱子类
Query GetArcic() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ARCIC_RowId:%Integer,ARCIC_Desc:%String")
{
	select ARCIC_RowId,ARCIC_Desc from ARC_ItemCat
}

/// 取医嘱优先级
Query GetOecpr() As %SQLQuery(CONTAINID = 1, ROWSPEC = "oecpr_rowid:%Integer,oecpr_Desc:%String")
{
	select oecpr_rowId,oecpr_desc from OEC_Priority
}

/// 取医嘱状态
Query GetOrdStat() As %SQLQuery(CONTAINID = 1, ROWSPEC = "OStat_rowid:%Integer,OStat_Desc:%String")
{
	select OStat_rowId,OStat_desc from OEC_OrderStatus WHERE OSTAT_Activate ='Y'
}

/// 取医嘱执行状态
Query GetExecStat() As %SQLQuery(CONTAINID = 1, ROWSPEC = "Stat_rowid:%Integer,Stat_Desc:%String")
{
	select Stat_rowId,Stat_desc from OEC_Order_AdminStatus
}

/// 取用药途径状态
Query GetPhcin() As %SQLQuery(CONTAINID = 1, ROWSPEC = "phcin_rowid:%Integer,phcin_Desc1:%String")
{
	select Phcin_rowId,Phcin_desc1 from PHC_Instruc
}

/// 根据出生日计算年龄
ClassMethod CalAge(IBirth As %String, IToday As %String)
{
    s IBirth=$g(IBirth),IToday=$g(IToday)
    i IBirth>2980000 s IBirth=""
    i IBirth<0 s IBirth=""
    q:'$g(IBirth) ""
    s XBirth=$$$zd(IBirth,1)
    s XToday=$$$zd(IToday,1)
    s AgeMth=XToday-XBirth
    s AgeDay=$p(XToday,"/",2)-$p(XBirth,"/",2)
    s CurrYear=$p(XToday,"/",3) s:CurrYear<100 CurrYear=CurrYear+1900
    s BirthYear=$p(XBirth,"/",3) s:BirthYear<100 BirthYear=BirthYear+1900
    s AgeYear=CurrYear-BirthYear
    i AgeDay<0 d
        . s AgeMth=AgeMth-1
	    . s AgeDay=AgeDay+$p("31,31,28,31,30,31,30,31,31,30,31,30,31",",",+XToday)
	    . q:XToday'=2
	    . s:((CurrYear#4)=0)&(((CurrYear#100)'=0)!((CurrYear#400)=0)) AgeDay=AgeDay+1
	i AgeMth<0 s AgeMth=AgeMth+12,AgeYear=AgeYear-1
	s $p(AgeYr,"|",12)=AgeYear
	s reage=$p(AgeYr,"|",12)_"Y "_AgeMth_"M "_AgeDay_"D"
	q reage
}

ClassMethod FormatDate(dateVal As %String)
{
	q:dateVal="" ""
	q $$$zd(dateVal,3)
}

ClassMethod FormatTime(timeVal As %String)
{
	q:timeVal="" ""
	q $zt(timeVal)
}

ClassMethod PatInfo(curId, transLocNum = "") As %String
{
	//取病人第transLocNum次转科的基本信息;
	//入参:1. "^"分隔第二部分为admId，第一个分隔部分为登记号或OEORI_ROWID
	//2. 如果admId为空,按登记号或OEORI_ROWID取
	//3. 登记号根据最后一个ADM取信息；
    n (curId,transLocNum)
    q:curId="" ""
    s admId=$p(curId,"^",2)
    s curId=$p(curId,"^")
    q:(curId="")&(admId="")
    i admId="" d
    	.s oriSub=$p(curId,"||",2)
    	.i oriSub'="" d //医嘱项
	    	..s oeordId=$p(curId,"||",1)
	    	..s admId=$p($g(^OEORD(oeordId)),"^",1)
    	.e  d  ;登记号
        	..s papmiId=""
	    	..s papmiId=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(curId),"")) 
	    	..i papmiId="" s admId="" q
	    	..
	    	..s admType="",preAdm=""
        	..f  s admType=$o(^PAPERdr(papmiId,"ADM",admType),-1) q:admType=""  d
            	...s admId="" f  s admId=$o(^PAPERdr(papmiId,"ADM",admType,admId),-1) q:(admId="")  d
                	....s pavisit=$p($g(^PAADM(admId)),"^",20)
                	....q:(pavisit'="A")&(pavisit'="D")
                	....s preAdm=admId
                	....s admId=0,admType=0
        	..s admId=preAdm  //重置admId
    q:admId="" ""  //ypz 060516
   
    s papmiId=+$g(^PAADM(+admId))
    q:papmiId=0 ""
    s ctlocId=$p(^PAADM(admId),"^",4)
    s curWardId=$p($g(^PAADM(admId)),"^",70)  
    s bedId=$p($g(^PAADM(admId)),"^",73)
    s roomId=$p(^PAADM(admId),"^",69)
    s transInfo=$$GetTransInfo(admId,transLocNum) //ypz 080709
    i +transLocNum'=0 d
        .s ctlocId=$p(transInfo,"^") //ypz 080709
        .s curWardId=$p(transInfo,"^",2) //ypz 080709
        .s bedId=$p(transInfo,"^",4) //ypz 080709
        .s roomId=$p(transInfo,"^",3) //ypz 080709
    s ctlocDesc=$p(^CTLOC(+ctlocId),"^",2)	
    i $p(ctlocDesc,"-",2)'="" s ctlocDesc=$p(ctlocDesc,"-",2)
    s wardDesc=$p($g(^PAWARD(+curWardId)),"^",2)
    i $p(wardDesc,"-",2)'="" s wardDesc=$P(wardDesc,"-",2)
    s bedSub=$p(bedId,"||",2)
    s bedCode=##class(Nur.CommonInterface.Patient).getBedCode(admId)
    ;i bedSub'="" s bedCode=$p($g(^PAWARD(curWardId,"BED",bedSub)),"^",1)
    s room=$p($g(^PAROOM(+roomId)),"^",2)	
	s doc=$p(^PAADM(admId),"^",9)
	i doc'="" s DocDes=$P($g(^CTPCP(doc,1)),"^",2)
	s medicareNo=##class(Nur.CommonInterface.Patient).getMedicareNo(admId) 
    s regNo=..GetRegNobyEpisodeID(admId)
    ;s medicareNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)
    s admType=$p(^PAADM(admId),"^",2)
    s hospital=$p($g(^CTLOC(+ctlocId)),"^",22)
    s errmsg=""
    
    //i medicareNo="-2" q "病案卷不存在"
    //i medicareNo="-1" q "获取病案号失败"
    s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
    i $d(^PAPER(papmiId,"PAT",3)) s safetyNetCardNo=$p(^PAPER(papmiId,"PAT",3),"^",4) ;病案号
    e  s safetyNetCardNo=""
    s sex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
    S homeAddres=$g(^PAPER(papmiId,"PER","ADD",1))     // 住址
    s homeTel=$p($g(^PAPER(papmiId,"PER",1)),"^",11)   //家庭电话
    s workTel=$p($g(^PAPER(papmiId,"PER",1)),"^",9)    //工作电话
    s handtel=$p($g(^PAPER(papmiId,"PER",4)),"^",21)   //手机
    s NationDr=$p($g(^PAPER(papmiId,"PER",2)),"^",1)
    i NationDr'="" d
    .s Nation=$P(^CT("NAT",NationDr),"^",2)
    e  d
    .s Nation=""                                       //民族
    s paersonLX=$p($g(^PAPER(papmiId,"PER",2)),"^",13) //联系人
    s birth=$p($g(^PAPER(papmiId,"ALL")),"^",6)
    
    s babyDate="",babyTime=""
    &sql(select BABY_BirthDate  ,BABY_TimeOfBirth into :babyDate,:babyTime from PA_PregDelBaby where BABY_Person_DR=:papmiId)
    s age=##class(web.DHCBillInterface).GetPapmiAge(papmiId,admId)
    i $p(ctlocDesc,"-",2)'="" s ctlocDesc=$p(ctlocDesc,"-",2)
    s MRDiagnos=""
  	s mradmId=$P(^PAADM(admId),"^",61)
  	s mrdiaSub=0
  	f  s mrdiaSub=$O(^MR(mradmId,"DIA",mrdiaSub)) q:(mrdiaSub="")  d
  	.s typSub=0  f  s typSub=$O(^MR(mradmId,"DIA",mrdiaSub,"TYP",typSub)) q:(typSub="")   d
  	..s dtypId=$P(^MR(mradmId,"DIA",mrdiaSub,"TYP",typSub),"^",1)
  	..q:dtypId=""
  	..s TypCode=$p($G(^MRC("DTYP",dtypId)),"^",1)
  	..q:TypCode'="OUT"
  	..s MRDIAICDCodeDR=$p($G(^MR(mradmId,"DIA",mrdiaSub)),"^",1)
  	..q:MRDIAICDCodeDR=""
  	..i MRDiagnos="" d
  	...s MRDiagnos=$p($G(^MRC("ID",MRDIAICDCodeDR)),"^",2)
  	..e  d
  	...s MRDiagnos=MRDiagnos_","_$p($G(^MRC("ID",MRDIAICDCodeDR)),"^",2)
    s DrugCell=""
    s DrugCell=$p($G(^PAPER(papmiId,"DHC")),"^",5)  //药柜号
    s birthDate=$p($g(^PAPER(papmiId,"ALL")),"^",6) //出生日期
    i birthDate'="" s birthDate=$$$zd(birthDate,3)
    s patWordUnit=$p($G(^PAPER(papmiId,"PER",4)),"^",18)  //工作单位
    s PersonID=$p($G(^PAPER(papmiId,"ALL")),"^",9)  //身份证
    s BloodType=..GetBloodType(regNo) //取血型
    s AdmReason=$P($g(^PAADM(admId,1)),"^",7)
	i AdmReason'="" s PAAdmReasonDesc=$P($g(^PAC("ADMREA",AdmReason)),"^",2)
	e  s PAAdmReasonDesc=""                     //病人身份
	s AdmDocID=$P($g(^PAADM(admId)),"^",79)
	i AdmDocID'="" s AdmDoc=$P($g(^CTPCP(AdmDocID,1)),"^",2)
	e  s AdmDoc=""                              //办理出院医生
	s DHCAdmId=$o(^DHCPAAdm(0,"PAAdm",admId,"")) 			//主管护士
    i DHCAdmId'="" d
    .s MainNurseDr=$p(^DHCPAAdm(DHCAdmId),"^",2)
    .i MainNurseDr'="" d
    ..s MainNurse=$P($g(^CTPCP(MainNurseDr,1)),"^",2)
    .e  d
    ..s MainNurse=""
    e  s MainNurse="" 
    s AdmDate=$P(^PAADM(admId),"^",6) 						//入院日期
    i AdmDate'="" d
  	 .s admStayDay=$P($h,"^",1)-AdmDate+1
  	 .s admStayDay=admStayDay_"天"
  	 e  d
  	 .s admStayDay=""
  	Set PatEncryptLevel=##class(web.DHCCLCom).GetPatEncryptLevel("",admId)  ///病人密级、级别
    Set EncryptLevel=$p(PatEncryptLevel,"^",1)  
    Set PatLevel=$p(PatEncryptLevel,"^",2) 
    s retStr=regNo_"^"_ctlocDesc_"^"_$g(room)_"^"_$g(sex)_"^"_$g(patName)_"^"_$g(safetyNetCardNo)_"^"_$g(bedCode)_"^"_$g(age)_"^"_$g(wardDesc)_"^"_homeAddres_"^"_homeTel_"  "_workTel_"  "_handtel_"^"_$G(DocDes)_"^"_medicareNo_"^"_MRDiagnos_"^"_Nation_"^"_paersonLX_"^"_DrugCell_"^"_$G(birthDate)_"^"_$G(patWordUnit)_"^"_$G(PersonID)_"^"_BloodType_"^"_PAAdmReasonDesc_"^"_AdmDoc_"^"_MainNurse_"^"_admStayDay
    s retStr=retStr_"^"_EncryptLevel_"^"_PatLevel
    q retStr
GetTransInfo(EpisodeID,transLocNum)  //返回病人第transLocNum次转科的科室、病区、房间、床位
  	n (EpisodeID,transLocNum)
  	s curCtlocId=$p(^PAADM(EpisodeID),"^",4)
  	s curRoomId=$p(^PAADM(EpisodeID),"^",69)
  	s curWardId=$p($g(^PAADM(EpisodeID)),"^",70)
  	s curBedId=$p($g(^PAADM(EpisodeID)),"^",73)
  	s retStr=curCtlocId_"^"_curWardId_"^"_curRoomId_"^"_curBedId
  	i +transLocNum=0 q retStr
  	s i=0
  	s preLocId=""
  	s stdate=$P(^PAADM(EpisodeID),"^",6)
  	s transSub=0 f  s transSub=$O(^PAADM(EpisodeID,"TRANS",transSub)) q:transSub=""  d
  	    .s transLocId=$P(^PAADM(EpisodeID,"TRANS",transSub),"^",6)
  	    .i (transLocId'="")&(transLocId'=preLocId) d
  	        ..s i=i+1
  	        ..s preLocId=transLocId
  	        ..i i=transLocNum s curCtlocId=transLocId
  	s i=0,preLocId=""
  	s transSub=0 f  s transSub=$O(^PAADM(EpisodeID,"TRANS",transSub)) q:transSub=""  d
  	    .s transLocId=$P(^PAADM(EpisodeID,"TRANS",transSub),"^",6)
  	    .i (transLocId'="")&(transLocId'=preLocId) d
  	        ..s i=i+1
  	        ..s preLocId=transLocId
        .//w "transSub="_transSub_"/i="_i_"/num="_transLocNum_"/ctlocId="_curCtlocId,!
        .i i'>transLocNum d
            ..s transWardId=$P(^PAADM(EpisodeID,"TRANS",transSub),"^",9)
            ..i transWardId'="" d
                ...s transWardLocId=$p($g(^PAWARD(transWardId)),"^",5)
                ...i (+curCtlocId'=0)&('$d(^CTLOC(transWardLocId,"LINK",0,"Loc",+curCtlocId))) s transWardId="" q
                ...s curWardId=transWardId
            ..//w "transSub="_transSub_"/i="_i_"/num="_transLocNum_"/ctlocId="_curCtlocId_" curWardId="_curWardId,"/"_transWardId,!
            ..q:transWardId=""
            ..s transBedId=$P(^PAADM(EpisodeID,"TRANS",transSub),"^",8)
            ..i transWardId'=+transBedId q
            ..i transBedId'="" s curBedId=transBedId
            ..s transRoomId=$P(^PAADM(EpisodeID,"TRANS",transSub),"^",7)
            ..i transRoomId'="" s curRoomId=transRoomId
            ..//w "transSub="_transSub_"/warid="_curWardId_"/curRoomId="_curRoomId,!
  	s retStr=curCtlocId_"^"_curWardId_"^"_curRoomId_"^"_curBedId
  	q retStr
}

ClassMethod PatInfo1(curId) As %String
{
	//病人基本信息;入参:登记号或OEORI_ROWID,根据最后一个ADM取信息
    n (curId)
    s admId=curId
    s papmiId=+^PAADM(admId)
    s ctlocId=$p(^PAADM(admId),"^",4)
	s ctlocDesc=$p(^CTLOC(+ctlocId),"^",2)	
	s doc=$p(^PAADM(admId),"^",9)
	if doc'="" s DocDes=$P(^CTPCP(doc,1),"^",2)
    s roomId=$p(^PAADM(admId),"^",69)
    i (roomId'="") s room=$p(^PAROOM(roomId),"^",2)
    s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
    s medicareNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)
    s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
    i $d(^PAPER(papmiId,"PAT",3)) s safetyNetCardNo=$p(^PAPER(papmiId,"PAT",3),"^",4) ;病案号
    e  s safetyNetCardNo=""
    s sex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
    S homeAddres=$g(^PAPER(papmiId,"PER","ADD")) // 住址
    s homeTel=$p($g(^PAPER(papmiId,"PER",1)),"^",11)  //家庭电话
    s workTel=$p($g(^PAPER(papmiId,"PER",1)),"^",9)   //工作电话
    s handtel=$p($g(^PAPER(papmiId,"PER",4)),"^",21)  //手机
    s bedSub=$p($p($g(^PAADM(admId)),"^",73),"||",2)
    s curWardId=$p($g(^PAADM(admId)),"^",70)  
    i curWardId'="" s wardDesc=$p(^PAWARD(curWardId),"^",1)
    i bedSub'="" s bedCode=$p($g(^PAWARD(curWardId,"BED",bedSub)),"^",1)
    e  s bedCode=""
    s birth=$p($g(^PAPER(papmiId,"ALL")),"^",6)
    s age=..CalAge(birth,+$h)
    //s age=$p(age,"Y",1)
    //ctlocDesc未取后半部分 ypz 060522
    Set PatEncryptLevel=##class(web.DHCCLCom).GetPatEncryptLevel("",admId)  ///病人密级、级别
    Set EncryptLevel=$p(PatEncryptLevel,"^",1)  
    Set PatLevel=$p(PatEncryptLevel,"^",2)
    s retStr=regNo_"^"_ctlocDesc_"^"_$g(room)_"^"_$g(sex)_"^"_$g(patName)_"^"_$g(safetyNetCardNo)_"^"_$g(bedCode)_"^"_$g(age)_"^"_$g(wardDesc)_"^"_homeAddres_"^"_homeTel_"  "_workTel_"  "_handtel_"^"_$G(DocDes)_"^"_medicareNo
    q retStr
}

ClassMethod GetUserWardId(userId)
{
 ///获得用户病区
  	n (userId)
  	s loc=$p(^SSU("SSUSR",userId),"^",4)
  	s warddes=$p(^CTLOC(loc),"^",2)
  	s wardid=$O(^PAWARD(0,"WARD_LocationDR",loc,""),-1)
  	s ctcpt=$p(^SSU("SSUSR",userId),"^",14)
  	i $g(ctcpt)'="" s typid=$p(^CTPCP(ctcpt,1),"^",4)
  	i $g(typid)'="" s typdes=$p($g(^CT("CPT",typid)),"^",4)
  	i ($g(typdes)="NURSE") q warddes_"^"_wardid
  	q ""
}

ClassMethod GetHospital()
{
	&sql(select hosp_desc into :hospitalName from ct_hospital)
	q $g(hospitalName)
}

ClassMethod GetPath()
{
	&sql(select pathtoreports into :reportPath from websys.configuration)
	q reportPath
}

ClassMethod GetDate() As %String
{
  	//取系统时间
	q $$$zd($h,4)_"^"_$$$zd(($h),4)
}

ClassMethod GetToday() As %String
{
	q $$$zd($h,4)
}

ClassMethod GetPrtId(oeoriId) As %String
{
 	//取医嘱的门诊发票指针 w ##Class(web.DHCCLCom).GetPrtId("71||1")
    s retPrtId=""
	q:oeoriId="" ""
	s oeordId=$p(oeoriId,"||",1)
	s oeoriSub=$p(oeoriId,"||",2)
	
	s sttDate=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",9) // + 0计费医嘱不取发票指针 wxl 090301
	s arcimId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)    
	s oeoriPrice=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",25)
    s ordPrice=+##CLASS(UDHCJFPRICE).GetOrderPrice("","",arcimId,sttDate,"","","",oeoriPrice)
    q:ordPrice=0 0
	s pbId=0
	f  s pbId=$o(^DHCPBi(0,"OEORI",oeoriId,pbId)) q:pbId=""  d
	    .q:$p(^DHCPB(pbId),"^",16)'="P"
	    .s dhcbciId=$o(^DHCBCI(0,"Bill",pbId,""))
	    .q:dhcbciId=""
	    .s prtId=+^DHCBCI(dhcbciId)
	    .s prtFlag=$p(^DHCINVPRT(prtId),"^",8)  //Prt_Flag
	    .q:prtFlag'="N"
	    .;s $p(prtIdStr,"^",1+(prtFlag'="N"))=prtId
	    .s retPrtId=prtId
	;s papmiId=+^PAADM(+^OEORD(oeordId))
	q retPrtId
}

ClassMethod GetAdmIdPapmiId(oeordIdExt)
{
   	//根据医嘱oeordId或其子表Id取adm和papmiId
	s oeordId=+oeordIdExt
	q:oeordId=0 ""
	s admId=+^OEORD(oeordId)
	s papmiId=+^PAADM(admId)
	q admId_"^"_papmiId
}

ClassMethod GetAdmType(admId = "") As %String
{
	i admId="" q ""
	q $p(^PAADM(admId),"^",2)
}

ClassMethod GetAdmFromNo(admNo) As %String
{
	q:admNo="" ""
	s admId=$o(^PAADMi("No",$$ALPHAUP^SSUTIL4(admNo),""))
	q admId
}

ClassMethod GetRegNoFromAdm(EpisodeID = "") As %String
{
	i EpisodeID="" q ""
	s PaitentID=+^PAADM(EpisodeID)
	//q $p($g(^PAPER(PaitentID,"PAT",1)),"^",1)
	q ..GetRegNo(PaitentID)
}

ClassMethod GetRegNobyEpisodeID(EpisodeID)
{
 	n (EpisodeID)
 	q:$g(EpisodeID)="" ""
 	q:'$d(^PAADM(EpisodeID)) ""
 	s PaitentID=$p(^PAADM(EpisodeID),"^",1)
 	s admType=$p(^PAADM(EpisodeID),"^",2)
 	
 	q:$g(PaitentID)="" ""
 	q:'$D(^PAPER(PaitentID,"PAT",1)) ""
 	q:admType="I" $p(^PAPER(PaitentID,"PAT",1),"^",1)
 	q $p(^PAPER(PaitentID,"PAT",1),"^",2)
}

ClassMethod GetRegNo(PaitentID)
{
 	n (PaitentID)
 	q:$g(PaitentID)="" ""
 	q:'$D(^PAPER(PaitentID,"PAT",1)) ""
 	s IP=$p(^PAPER(PaitentID,"PAT",1),"^",1)
 	s OP=$p(^PAPER(PaitentID,"PAT",1),"^",2)
 	s PAPMINo=$S($G(XFUNC("CLASS"))="OP":OP,1:IP)
 	q PAPMINo
}

ClassMethod GetNamebyEpisodeID(EpisodeID)
{
 	n (EpisodeID)
 	q:$g(EpisodeID)="" ""
 	q:'$d(^PAADM(EpisodeID)) ""
 	s PaitentID=$p(^PAADM(EpisodeID),"^",1)
 	q ..GetName(PaitentID)
}

ClassMethod GetName(PaitentID)
{
 	n (PaitentID)
 	q:$g(PaitentID)="" ""
 	q:'$D(^PAPER(PaitentID,"ALL")) ""
 	q $p(^PAPER(PaitentID,"ALL"),"^",1)
}

ClassMethod UpdatePatAllergy(oeoriId, userId, allergyFlag) As %String
{
   //无当前药品则插入
    n (oeoriId,userId,allergyFlag)
    q:(allergyFlag'="Y")&(allergyFlag'="N") 0
    
    s oeordId=$p(oeoriId,"||",1),oeoriSub=$p(oeoriId,"||",2)
    s dhcoriId=$o(^DHCORDItem(0,oeoriId,""))
    q:dhcoriId="" "置皮试信息失败!"
    s curDate=+$h,curTime=$p($h,",",2)
    
    s algId=$p(^DHCORDItem(dhcoriId),"^",5)
    s papmiId=+algId,algSub=+$p(algId,"||",2)
    i allergyFlag="N" d
        .i (algId'="") d
            ..s $p(^PAPER(papmiId,"ALG",algSub),"^",19)="Y"
            ..s $p(^PAPER(papmiId,"ALG",algSub),"^",8)="I"
            ..s $p(^PAPER(papmiId,"ALG",algSub),"^",16)=userId
            ..s $p(^PAPER(papmiId,"ALG",algSub),"^",23)=curDate
            ..s $p(^PAPER(papmiId,"ALG",algSub),"^",24)=curTime
            ..s $p(^DHCORDItem(dhcoriId),"^",5)=""
    i allergyFlag="N" q 0
    i (allergyFlag="Y")&(algId'="")&($p($g(^PAPER(papmiId,"ALG",algSub)),"^",19)="N") q 0
    
    s arcimId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)
    s phcdfId=$p(^ARCIM(+arcimId,$p(arcimId,"||",2),1),"^",12) //ARCIM_PHCDF_DR
    q:phcdfId="" "无药品指针!"
    k PLIST
    s PLIST(0)=+^PAADM(+^OEORD(oeordId)) //ALG_PAPMI_ParRef
    s PLIST(3)=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",11) //ALG_CTPCP_DR暂用下医嘱医生
    s PLIST(8)="" //ALG_Type_DR 取不到
    s PLIST(11)="A" //ALG_Status
    s PLIST(12)=curDate //ALG_Date
    s PLIST(13)=curDate //ALG_OnsetDate
    s PLIST(18)=curTime //ALG_Time
    s PLIST(19)=userId //ALG_UpdateUser_DR
    s PLIST(22)="N" //ALG_InActive
    s PLIST(23)=1 //ALG_LastUpdateHospital_DR
    s PLIST(24)="" //ALG_Severity_DR
    s PLIST(26)=curDate //ALG_LastUpdateDate
    s PLIST(27)=curTime //ALG_LastUpdateTime
    s PLIST(31)=+phcdfId //ALG_PHCDM_DR
    s PLIST(33)="" ;$o(^MRC("AT",0,"MRCAA_Desc","药物","")) //ALG_MRCAllType_DR
    s PLIST(34)=arcimId
    //w !,PLIST(0)_","_PLIST(3)_","_PLIST(8)_","_PLIST(11)_","_PLIST(12)_","_PLIST(13)_","_PLIST(18)_","_PLIST(19)_","_PLIST(22)_","_PLIST(23)_","_PLIST(26)_","_PLIST(27)_","_PLIST(31)_","_PLIST(33)
    &sql(Insert into PA_Allergy Values PLIST())
    i SQLCODE q "过敏记录插入有误!"
    ;s $p(^PAPER(PLIST(0),"ALG",$p(%ROWID,"||",2)),"^",30)=PLIST(0)_"ALG"_$p(%ROWID,"||",2)
    s $p(^DHCORDItem(dhcoriId),"^",5)=%ROWID
    s $P(^PAPER(PLIST(0),"ALG",$p(%ROWID,"||",2),"DHC"),"^",3)=allergyFlag
    q 0
}

ClassMethod DeletePatAllergy(oeoriId, userId, skinTestDate, skinTestTime)
{
    //按药品和皮试走
    n (oeoriId, userId, skinTestDate, skinTestTime)
	s arcimId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)
    s phcdfId=$p(^ARCIM(+arcimId,$p(arcimId,"||",2),1),"^",12) //ARCIM_PHCDF_DR
    q:phcdfId="" "未找到药物!"
    s papmiId=+^PAADM(+^OEORD(oeordId))
	//////s skinTestDate=PLIST(46)
	//////s skinTestTime=PLIST(47)
	s algSub=0
	f  s algSub=$o(^PAPER(papmiId,"ALG",algSub)) q:algSub=""  d
	    .s algStr=^PAPER(papmiId,"ALG",algSub) //注意,过敏按类别走时要更新
	    .i ($p(algStr,"^",10)=skinTestDate)&($p(algStr,"^",15)=skinTestTime)&($p(algStr,"^",27)=+phcdfId) d
	        ..s algId=papmiId_"||"_algSub
	        ..&sql(delete from PA_Allergy where ALG_RowId=:algId)
	        ..////s setRet=..SetSkinTestResult(oeordId_"||"_oeoriSub,"")
	q 0
}

/// 取病人社会地位(医保)
ClassMethod GetPatMedicare(admId As %String)
{
    s papersonId=$p($g(^PAADM($g(admId))),"^",1)
	q:$g(papersonId)="" ""
	s SocialStatus=$p($g(^PAPER($g(papersonId),"PER",1)),"^",10)
	q:$g(SocialStatus)="" ""
	s SocialDESC=$p($g(^CT("SS",SocialStatus)),"^",2)
	q $g(SocialDESC)
}

/// 取用户代码
ClassMethod GetUserCode(userId As %String)
{
    i userId="" q ""
    s usrStr=^SSU("SSUSR",userId)
    s userCode=$p(usrStr,"^",1)
    q userCode
}

ClassMethod GetOrdSet(ord)
{
 	//^ARCOS({ARCOS_RowId})  --x ARC_OrdSets_
 	//^ARCOS({ARC_OrdSets.ARCOS_RowId},"DATE",{DATE_Childsub})--ARC_OrdSetDate_
 	//^ARCOS({ARC_OrdSets.ARCOS_RowId},"DATE", {ARC_OrdSetDate.DATE_Childsub},"ITM",{ITM_Childsub}) --ARC_OrdSetDateItem__
 	s ordId=$p(ord,"||",1),oriSub=$p(ord,"||",2)
 	q:(ordId="")||(oriSub="")
 	s ordset=$p(^OEORD(ordId,"I",oriSub,3),"^",10)
 	q:ordset="" ""
 	s arcosDesc=$p(^ARCOS(ordset),"^",2)  
 	q:$g(arcosDesc)
  	//  s dcl=0 f  s dcl=$o(^ARCOS(ordset,"DATE",dcl)) q:dcl=""  d
  	//.s itcl=0 f  s itcl=$o(^ARCOS(ordset,"DATE",dcl,"ITM",itcl)) q:itcl=""  d  // --ARC_OrdSetDateItem__)
  	//..s ArcimDr=$p(^ARCOS(ordset,"DATE",dcl,"ITM",itcl),"^",1)
  	//..w !, ArcimDr
  	//..b
  	//..s arcimSub=$p(ArcimDr,"||",1),arcimVer=$p(ArcimDr,"||",2)
  	//..s ItemCatDR=$p($g(^ARCIM(arcimSub,arcimVer,1)),"^",10)
  	//..s OrdCatDR=$p(^ARC("IC",ItemCatDR),"^",8)
  	//..q:OrdCatDR=27
  	//..s ArcimDes=$p(^ARCIM(arcimSub,arcimVer,1),"^",2)
  	//..s ArcStr=$g(ArcStr)_ArcimDes_" "
  	//..
  	//q $g(ArcStr)
}

ClassMethod SpecName(oeoriId)
{
 	//取标本类型
   	s paorder=$p(oeoriId,"||",1)
   	s itemsub=$p(oeoriId,"||",2)
   	s SPECChildsub=0
   	s SPECDesc="",tempSPECCode="",tempSPECDesc=""
   	i $d(^OEORD(paorder,"I",itemsub,"SPEC",SPECChildsub))'=0 d
   	s SPECChildsub=0 f  s SPECChildsub=$o(^OEORD(paorder,"I",itemsub,"SPEC",SPECChildsub)) q:SPECChildsub=""  d
   		.s tempSPECCode=$g(^OEORD(paorder,"I",itemsub,"SPEC",SPECChildsub))
   		.s tempSPECCode=$p(tempSPECCode,"^",1)
   		.s tempSPECDesc=$p(^["LabData"]TTAB("SPEC",tempSPECCode),"\",1)
   		.i SPECDesc="" s SPECDesc=tempSPECDesc
   		.e  s SPECDesc=SPECDesc_","_tempSPECDesc
  	q $g(SPECDesc)
}

ClassMethod GetDocLoc(adm, oeoriId)
{
    n (admId,oeoriId)
    s oeordId=+oeoriId
    s oeoriSub=$p(oeoriId,"||",2)
    s res="Y"
    s ctpcpId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",11)
    i ctpcpId'="" s ctcptId=$p(^CTPCP(ctpcpId,1),"^",4)  ;CTPCP_CarPrvTp_DR
	i $g(ctcptId)'="" s ctcptIType=$p($g(^CT("CPT",ctcptId)),"^",4)  ;CT_CarPrvTp
	q:($g(ctcptIType)'="DOCTOR") "N"  //////////////2005-12-3 qse add
	s DocLoc=$o(^RB("RES",0,"CTPCP",ctpcpId,""))
	q:DocLoc="" "N"
    i '$d(^TMP($j,"loc",admId,DocLoc)) s res="N" 
    q res
}

ClassMethod OrdNote(oeoriId, oriNote)
{
	n (oeoriId,oriNote)
	s oeordId=$p(oeoriId,"||",1)
	s oeoriSub=$p(oeoriId,"||",2)
	s ln=^OEORD(oeordId,"I",oeoriSub,"REM",0)
	s ^OEORD(oeordId,"I",oeoriSub,"REM",0)=ln+1
	s ^OEORD(oeordId,"I",oeoriSub,"REM",ln+1)=oriNote
	s rnum=$g(^OEORD(oeordId,"I",oeoriSub,"DEP",0))
	s ^OEORD(oeordId,"I",oeoriSub,"DEP",0)=rnum+1 
	s ^OEORD(oeordId,"I",oeoriSub,"DEP",rnum+1)=oriNote
	q 0
}

ClassMethod GetServerNameSpace() As %String
{
 	&sql(select LayoutManager into :layoutManager from websys.configuration)
 	q $G(layoutManager)
}

ClassMethod GetWardLinkLocId(wardId, wardCtlocId = "")
{
	n (wardId,wardCtlocId)
	q:(wardId="")&(wardCtlocId="") ""
    i wardCtlocId="" s wardCtlocId=$p($g(^PAWARD(wardId)),"^",5)
    q:wardCtlocId="" ""
    q ..GetLinkLocId(wardCtlocId)
}

ClassMethod GetLinkLocId(locId)
{
    q:locId="" ""
    s linkSub=0,ctlocIdStr=""
    f  s linkSub=$o(^CTLOC(locId,"LINK",linkSub)) q:linkSub=""  d
    	.i ctlocIdStr'="" s ctlocIdStr=ctlocIdStr_"^"
    	.s ctlocIdStr=ctlocIdStr_^CTLOC(locId,"LINK",linkSub)
	q ctlocIdStr
}

ClassMethod GetDocLocType(oeoriId, docLocIdStr)
{
	 n (oeoriId,docLocIdStr)
	 q:oeoriId=""
	 s oeordId=+oeoriId,oeoriSub=$p(oeoriId,"||",2)

	 s addUserId=$P($G(^OEORD(oeordId,"I",oeoriSub,7)),"^",1)
	 s userdep=$P($G(^OEORD(oeord,"I",ordsub,7)),"^",2)  //oeori_UserDepartment_DR
	 q:addUserId="" ""
	 q:'$D(^SSU("SSUSR",addUserId)) ""
	 s ctcpId=$P(^SSU("SSUSR",addUserId),"^",14)
	 q:ctcpId="" ""

	 q:'$D(^CTPCP(ctcpId,1)) ""
	 s ctcptId=$P(^CTPCP(ctcpId,1),"^",4)
	 s ctcptDesc=$P(^CT("CPT",ctcptId),"^",4)
	 s locId="",retLocId=""
	 f  s locId=$O(^RB("RES",0,"CTPCP",ctcpId,locId)) q:(locId="")  d
	 	.i ("^"_docLocIdStr_"^")[("^"_locId_"^") s retLocId=locId
	 i retLocId="" q ""
	 q retLocId_"^"_ctcptDesc
}

/// ///////------------------/////////////
/// //改为GETORDDOCLOC!!
ClassMethod getloc(oeord, ordsub)
{
	n (oeord,ordsub)
	s ctcpId=$p($g(^OEORD(oeord,"I",ordsub,1)),"^",11)
	q:ctcpId="" ""
	s loc=""  s loc=$o(^RB("RES",0,"CTPCP",ctcpId,loc))
	q loc
}

ClassMethod BillStatus(regNo, recLoc, admDate) As %String
{
	n (regNo,recLoc,admDate)
	s admDate=$p($h,",")  //查询当天有无需计费
	i regNo'="" d
        .s papmiId=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(regNo),"")) 
        .q:papmiId=""
        .s admId=0 f  s admId=$o(^PAPERdr(papmiId,"ADM","O",admId)) q:admId=""  d
            ..s pavisit=$p($g(^PAADM(admId)),"^",20)
            ..s aDate=$p($g(^PAADM(admId)),"^",6)
            ..q:admDate'=aDate 
            ..i pavisit'="A" q   ;
            ..s oeordId=0 f  s oeordId=$o(^OEORD(0,"Adm",admId,oeordId)) q:(oeordId="")!($g(billed)="TB")  d
            ...s oeoriSub=0 f  s oeoriSub=$o(^OEORD(oeordId,"I",oeoriSub)) q:(oeoriSub="")!($g(billed)="TB")  d
                ....s billed=$p(^OEORD(oeordId,"I",oeoriSub,3),"^",5)
                ....//w !,billed,"c",admId
	q $g(billed)
}

Query FindArcim(catid As %String, subcat As %String) As %Query(ROWSPEC = "code:%String,desc:%String,arccat:%String")
{
}

ClassMethod FindArcimExecute(ByRef qHandle As %Binary, catid As %String, subcat As %String) As %Status
{
	s repid=$i(^CacheTemp)
	i catid="" s qHandle=$lb(0,repid,0) q $$$OK
 	s ind=1
 	s arcimSub="" f  s arcimSub=$o(^ARCIM(0,"ARCIC_DR",catid,arcimSub))  q:arcimSub=""  d
    	.s arcimVer=""  f  s arcimVer=$o(^ARCIM(0,"ARCIC_DR",catid,arcimSub,arcimVer)) q:arcimVer=""  d
    		..s arcimCode=$p(^ARCIM(arcimSub,arcimVer,1),"^",1)
    		..s arcimDesc=$p(^ARCIM(arcimSub,arcimVer,1),"^",2)
    		..s arcicId=$p(^ARCIM(arcimSub,arcimVer,1),"^",10)
    		..s arcicDesc=$p(^ARC("IC",arcicId),"^",2) 
 			..d OutputRow
    s qHandle=$lb(0,repid,0)
	q $$$OK
OutputRow
	s Data=$lb(arcimCode,arcimDesc,arcicDesc)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindArcimFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindArcimExecute ]
{
	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {			
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindArcimClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindArcimExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
    q $$$OK
}

ClassMethod FindLongestArcim()
{
	s arcimSub=0,maxLen=0,maxLenDesc="",maxLenSub=0
	f  s arcimSub=$o(^ARCIM(arcimSub)) q:arcimSub=""  d
	    .s arcimDesc=$p(^ARCIM(arcimSub,1,1),"^",2)
	    .s arcicId=$p(^ARCIM(arcimSub,1,1),"^",10)
	    .q:arcicId=""
	    .s orcatId=$p(^ARC("IC",arcicId),"^",8)
	    .q:orcatId'=22
	    .s arcimDescShort=$p(arcimDesc,"(")
	    .i $l(arcimDescShort)>maxLen d
	        ..s maxLen=$l(arcimDescShort)
	        ..s maxLenSub=arcimSub,maxLenDesc=arcimDescShort
	    .//i $l(arcimDescShort)'>15,$l(arcimDescShort)>10 w arcimSub_"^"_arcicId_"^"_orcatId_"^"_arcimDescShort,!
	    .i $l(arcimDescShort)>10 w arcimSub_"^"_arcicId_"^"_orcatId_"^"_arcimDescShort,!
	q maxLen_"^"_maxLenSub_"^"_maxLenDesc
}

ClassMethod InsertOrdItem(userId, oeordId, arcimId, oecprId, qty, userDeptId, anaId, anaOpId, billDesc, notes, ConDepID, ifRetRowID = "N") As %String
{
	q:(userId="")!(oeordId="")!(arcimId="")!(oecprId="")!(userDeptId="") -1
	s oldNameSpace=$ZNSPACE
	s dataNameSpace=$LIST(^websys.ConfigurationD(1),12)
	//zn dataNameSpace
    //w $zn,!
    //w userId_","_oeordId_","_arcimId_","_userDeptId_","_notes
	k PLIST
	s PLIST(4)=arcimId
	s PLIST(6)=userDeptId  ;OEORI_OrdDept_DR
	s PLIST(10)=1   ;OEC_OrderStatus：1核4停6执
	s ctcpId=$p(^SSU("SSUSR",+userId),"^",14)
	s PLIST(14)=ctcpId  //careProvId ;OEORI_Doctor_DR:
	s PLIST(17)=+$h ;  OEORI_SttDat
	s PLIST(18)=$p($h,",",2)  ;OEORI_SttTim
	s PLIST(23)=oecprId   ;OEORI_Priority_DR:OEC_Priority：3临时，5长期
	s PLIST(29)=qty ;OEORI_PhQtyOrd
	s PLIST(45)=billDesc //OEORI_BillDesc
	s PLIST(55)="Y"  ;OEORI_CoverMainIns  Y
	s PLIST(56)="N"  ;OEORI_PortEquipReq  N
	s PLIST(57)="N"  ;OEORI_AdministerSkinTest N
	s PLIST(75)=ConDepID  //OEORI_RecDep_DR
	s PLIST(76)="TB" //OEORI_Billed

	s PLIST(77)=$$GetSeqNo(oeordId,+$h)  ;OEORI_SeqNo，每天排序//
	  
	s PLIST(81)=+$h    ;OEORI_Date
	s PLIST(90)=$p($h,",",2)    ;OEORI_TimeOrd
	s PLIST(106)=anaId
	s PLIST(107)=anaOpId
	s PLIST(111)="A" ;OEORI_ResultFlag A
	s PLIST(120)=userId ;OEORI_UserAdd
	s PLIST(121)=userDeptId  ;OEORI_UserDepartment_DR
	s PLIST(141)=userId ;OEORI_UserUpdate！
	s ordsub=$p($g(oeordId),"||",1)
	s admId=+^OEORD(ordsub)
	s PLIST(161)=$p(^PAADM(admId),"^",4) //OEORI_AdmLoc_DR：病人科室
	s PLIST(53)=notes //OEORI_DepProcNotes
	//s res=$$insert^MVBOEIT0(oeordId,"Y")
	s res1=##class(appcom.OEOrdItem).Insert(oeordId,"Y",.PLIST)
	s res=$P(res1,"^") 
	
	s oeitm=""
	i res=0 s oeitm=$P(res1,"^",2)  //%ROWID
	//zn oldNameSpace  ; Restore the namespace
	//s ^ypzTmp("app","in")=res_"/"_oeordId_"/"_%ROWID
	i ifRetRowID="Y" q res_"^"_$G(oeitm)
	q res
GetSeqNo(oeordId,sttdate)
	;生成序列号,原来的程序有点累最
	;Set err=$$lastseq^MVBOEORD(ord,sttdate)
	;Set LastSeqNo=PLIST(1)
	Set LastSeqNo=$o(^OEORDi(0,"StDtSeqNo",oeordId,sttdate,""),-1)
    i LastSeqNo["." s LastSeqNo=$p(LastSeqNo,".")
	Set SeqNo=+LastSeqNo+1
	Q SeqNo
}

ClassMethod AddOrder(arcimId, admId, qty, seqNo, sttDate, sttTime, reclocId, userId)
{
	//(arcim,row,mode,qty,oeent,arcos,seqno,date,time,loc,prior,stat,group,appt,consdoc,consdep,price,cost,dateexec,billflag,unitcost,refhosp,billdesc,user,labepis) ;mode Anaest,AnaestAgent,oper
	i sttDate="" s sttDate=+$h,sttTime=$p($h,",",2)
	d addorder^aOET13(arcimId,admId,"",qty,"","",seqNo,date,"",reclocId,prior,stat,"","","","","","","","","","","",userId,"")
}

Query FindEpisodeFromRegNo(regNo As %String, admType As %String, fromDate As %String, toDate As %String) As %Query(ROWSPEC = "admDate:%String,admTime:%String,admNo:%String,admTypeDesc:%String,admDept:%String,admDoc:%String,admId:%String")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCCLCom","FindEpisodeFromRegNo","0000000529","E","23/08/2017","24/08/2017")
ClassMethod FindEpisodeFromRegNoExecute(ByRef qHandle As %Binary, regNo As %String = "", admType As %String = "", fromDate As %String = "", toDate As %String = "") As %Status
{
	s repid=$i(^CacheTemp)
 	s ind=1
 	i (toDate="")!(fromDate="") s qHandle=$lb(0,repid,0) q $$$OK
	s fDate=$$$zdh(fromDate,4),tDate=$$$zdh(toDate,4)
    i regNo'="" d
        .s papmiId=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(regNo),"")) 
        .q:papmiId=""
        .s admTypes(1)="O",admTypes(2)="E"
        .f i=1:1:2 d
        	..i admType[admTypes(i) d  //ypz 060721
            	...s admId="" //,adjusted=0 //倒序找
            	...f  s admId=$o(^PAPERdr(papmiId,"ADM",admTypes(i),admId),-1) q:admId=""  d  
                	....s admVisitStat=$p($g(^PAADM(admId)),"^",20)
                	....i (admVisitStat'="A")&(admVisitStat'="D") q
                	....s admDate=$p($g(^PAADM(admId)),"^",6)
                	....q:admDate<fDate
                	....q:admDate>tDate
                	....s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
                	....s admDate=$$$zd($p($g(^PAADM(admId)),"^",6),3)
                	....s admTime=$zt($p($g(^PAADM(admId)),"^",7),2)
                	....s admNo=$p($g(^PAADM(admId)),"^",81)
                	....i admTypes(i)="O" s admTypeDesc="门诊"
                	....i admTypes(i)="E" s admTypeDesc="急诊"
                	....i admTypes(i)="I" s admTypeDesc="住院"
                	....s ctlocId=$p($g(^PAADM(admId)),"^",4)
                	....s admDept=$p($g(^CTLOC(ctlocId)),"^",2)
                	....s ctcpId=$p($g(^PAADM(admId)),"^",9)
                	....s admDoc=$p(^CTPCP(ctcpId,1),"^",2)
                	....d OutRowEpisode
                	....//s avsId="-1"
                	....//f  s avsId=$o(^DHCADMVisitStatus(0,"PAADM",admId,avsId)) q:avsId=""  d
	
    s qHandle=$lb(0,repid,0)
	q $$$OK
  
OutRowEpisode
	s Data=$lb(admDate,admTime,admNo,admTypeDesc,admDept,admDoc,admId)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindEpisodeFromRegNoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindEpisodeFromRegNoExecute ]
{
	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {			
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindEpisodeFromRegNoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindEpisodeFromRegNoExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
    q $$$OK
}

ClassMethod GetPhcfrFactor(phcfrCode) As %String
{
 	//取频次次数
  	n (phcfrCode)
  	s phcfrFactor=1
  	q:phcfrCode="" phcfrFactor
  	//s phcfrId=$O(^PHCFR(0,"Code",$$ALPHAUP^SSUTIL4(phcfrCode),""),-1)
  	s phcfrId=$O(^PHCFR(0,"Desc1",$$ALPHAUP^SSUTIL4(phcfrCode),""),-1) //ypz 070418 统一
  	//s phcfrId=$O(^PHCFR(0,"Code",$ZCVT(phcfrCode,"U"),""),-1)
  	i phcfrId'=""  s phcfrFactor=$p(^PHCFR(phcfrId),"^",2)
  	q phcfrFactor
}

ClassMethod GetOrdCatId(oeoriId) As %String
{
 	n (oeoriId)
	q:oeoriId="" ""
	s oeordId=+oeoriId
    s oeoriSub=$p(oeoriId,"||",2)
	q:'$d(^OEORD(oeordId,"I",oeoriSub,1)) ""
 	s arcimId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)
 	q:arcimId="" ""
 	s arcimVersion=$p(arcimId,"||",2)
 	q:'$d(^ARCIM(+arcimId,arcimVersion,1)) ""
 	s arcicId=$p(^ARCIM(+arcimId,arcimVersion,1),"^",10)
 	q:arcicId="" ""
 	q:'$d(^ARC("IC",arcicId)) ""
 	s orcatId=$p(^ARC("IC",arcicId),"^",8)
 	q:orcatId="" ""
 	q:'$d(^OEC("ORCAT",orcatId)) ""
	q orcatId
}

ClassMethod GetOrdSubCatId(oeoriId) As %String
{
 	n (oeoriId)
	q:oeoriId="" ""
	s oeordId=+oeoriId
    s oeoriSub=$p(oeoriId,"||",2)
	q:'$d(^OEORD(oeordId,"I",oeoriSub,1)) ""
 	s arcimId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)
 	q:arcimId="" ""
 	s arcimVersion=$p(arcimId,"||",2)
 	q:'$d(^ARCIM(+arcimId,arcimVersion,1)) ""
 	s arcicId=$p(^ARCIM(+arcimId,arcimVersion,1),"^",10)
 	q:arcicId="" ""
	q $g(arcicId)
}

ClassMethod ExtractString(sStr, tStr, delimiter, include) As %String
{
	n (sStr,tStr,delimiter,include)
	s retStr=""
    i tStr'="" d
        .s num=$l(tStr,delimiter)
        .f i=1:1:num d
            ..s subStr=$p(tStr,delimiter,i)
            ..i (include'="Y"),(delimiter_sStr_delimiter)[(delimiter_subStr_delimiter) q
            ..i (include="Y"),(delimiter_sStr_delimiter)'[(delimiter_subStr_delimiter) q
            ..i retStr'="" s retStr=retStr_delimiter
            ..s retStr=retStr_subStr
	q retStr
}

ClassMethod GetOrdStatCode(oeoreId)
{
	n (oeoreId)
	q:oeoreId="" ""
	s oeordId=+oeoreId,oeoriSub=$p(oeoreId,"||",2),oeoreSub=$p(oeoreId,"||",3)
	i oeoreSub="" d
	.s xDate=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",34)
	.s xTime=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",15)
	.s ordStatId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",13)
	e  d
	.s xDate=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)),"^",12)
	.s xTime=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)),"^",14)
	.s ordStatId=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub,"BILL")),"^",1)

	s ordStatCode=$p($g(^OEC("OSTAT",+ordStatId)),"^")
	;s curDateTimeVal=($h*100000)+$p($h,",",2)
	;s xDateTimeVal=(xDate*100000)+xTime
	;i ordStatCode["D",curDateTimeVal<xDateTimeVal s ordStatCode="PD" //已停止预停
	;s oeoriEndDate=$p($g(^OEORD(oeordId,"I",oeoriSub,9)),"^",9)
	;s oeoriEndTime=$p($g(^OEORD(oeordId,"I",oeoriSub,9)),"^",10)
	;s endDateTimeVal=(oeoriEndDate*100000)+oeoriEndTime
	;i ordStatCode["V",curDateTimeVal<endDateTimeVal s ordStatCode="TPD" //未停止预停	
	q ordStatCode
}

ClassMethod GetCtcpId(oeoriId, userId)
{
	q:(oeoriId="")&(userId="") ""
	i userId="" d //优先取
		.s oeordId=+oeoriId,oeoriSub=$p(oeoriId,"||",2)
   		.s userId=$P($G(^OEORD(oeordId,"I",oeoriSub,7)),"^",1)
    q:userId="" ""
	s ctctId=$P(^SSU("SSUSR",user),"^",14)
	q ctctId
}

ClassMethod GetCtcptType(oeoriId, userId, ctctId)
{
	q:(oeoriId="")&(userId="")&(ctctId="") ""
	i ctcpId="" d //优先取
		.i userId="" d //次优先取
			..s oeordId=+oeoriId,oeoriSub=$p(oeoriId,"||",2)
   			..s userId=$P($G(^OEORD(oeoriId,"I",oeoriSub,7)),"^",1)
    	.q:userId=""
		.s ctctId=$P(^SSU("SSUSR",user),"^",14)
	q:ctctId="" ""
	s ctcptId=$P(^CTPCP(ctctId,1),"^",4)  ;CTPCP_CarPrvTp_DR
	q:ctcptId="" ""
    s ctcptType=$P(^CT("CPT",ctcptId),"^",4)  ;CT_CarPrvTp
	q ctcptType
}

ClassMethod GetCtcpType(oeoriId, userId, ctcpId)
{
	q:(oeoriId="")&(userId="")&(ctcpId="") ""
	i ctcpId="" d //优先取
		.i userId="" d //次优先取
			..s oeordId=+oeoriId,oeoriSub=$p(oeoriId,"||",2)
   			..s userId=$P($G(^OEORD(oeoriId,"I",oeoriSub,7)),"^",1)
    	.q:userId=""
		.s ctcpId=$P(^SSU("SSUSR",userId),"^",14)
	q:ctcpId="" ""
	s ctcptId=$P(^CTPCP(ctcpId,1),"^",4)  ;CTPCP_CarPrvTp_DR
	q:ctcptId="" ""
    s ctcptType=$P(^CT("CPT",ctcptId),"^",4)  ;CT_CarPrvTp
	q ctcptType
}

ClassMethod GetComponentIdByName(componentName)
{
	s componentId=""
	s componentId = $o(^websys.ComponentI("UniqueNameIndex",componentName,componentId))
	//&sql(select ID into :componentId from websys.component where name=:componentName)
	q componentId
}

ClassMethod GetDispensingStat(oeoreId, omitOM = "Y")
{
    n (oeoreId,omitOM)
    q:oeoreId="" ""
    s oeordId=+oeoreId,oeoriSub=$p(oeoreId,"||",2),oeoreSub=$p(oeoreId,"||",3)
    q:oeoreSub="" ""
    s oecprId=$p(^OEORD(oeordId,"I",oeoriSub,1),"^",8)
    q:oecprId="" ""
    s oecprCode=$p($g(^OECPR(oecprId)),"^",1)
    q:(omitOM="Y")&((oecprCode="OMST")!(oecprCode="OM")) "C" //自备药视为已发         //WKZ071019 S
    q:(omitOM'="Y")&((oecprCode="OMST")!(oecprCode="OM")) "TC" //自备药视为未发
    //q:(omitOM'="Y")&((oecprCode="OMST")!(oecprCode="OM")) "P" //自备药视为未发

    /*s DSPRowId="",allC=1,allTC=1,returnFlag=0 //ypz 081225 增加"PC"部分发
    f  s DSPRowId=$O(^DHCOEDISQTY(0,"OEORE",oeoreId,DSPRowId)) q:DSPRowId=""  d
        .q:$P($G(^DHCOEDISQTY(DSPRowId)),"^",7)=""
        .i $P($G(^DHCOEDISQTY(DSPRowId)),"^",7)="R" s returnFlag=1
        .i $P($G(^DHCOEDISQTY(DSPRowId)),"^",7)'="C" s allC=0
        .i $P($G(^DHCOEDISQTY(DSPRowId)),"^",7)'="TC" s allTC=0  */
    s DSPRowId="" s DSPRowId=$O(^DHCOEDISQTY(0,"OEORE",oeoreId,DSPRowId))
    q:DSPRowId="" ""
    s dspStat=$P($G(^DHCOEDISQTY(DSPRowId)),"^",7)
    /*i allC=1,allTC=0 s dspStat="C"   //已发
    i allC=0,allTC=1 s dspStat="TC"  //未发
    i allC=0,allTC=0 s dspStat="PC"  //部分发
    i returnFlag=1 s dspStat="C"     //视为已发 */
 	q dspStat                                                                            //WKZ071019 E
}

ClassMethod GetDispensingStatOP(oeoriId, omitOM = "Y")
{
    n (oeoriId,omitOM)
    q:oeoriId="" ""
    s oeordId=+oeoriId,oeoriSub=$p(oeoriId,"||",2)
    q:oeoriSub="" ""
    s oeoriId=oeordId_"||"_oeoriSub
    s oecprId=$p(^OEORD(oeordId,"I",oeoriSub,1),"^",8)
    q:oecprId="" ""
    s oecprCode=$p($g(^OECPR(oecprId)),"^",1)
    q:(omitOM="Y")&((oecprCode="OMST")!(oecprCode="OM")) "C" //自备药视为已发         //WKZ071019 S
    q:(omitOM'="Y")&((oecprCode="OMST")!(oecprCode="OM")) "TC" //自备药视为未发
    //q:(omitOM'="Y")&((oecprCode="OMST")!(oecprCode="OM")) "P" //自备药视为未发
   /* s dspStat=""
	s oeoreSub=0
	f  s oeoreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub))  q:(oeoreSub="")!(dspStat="C")  d
    	.s dspSub=0  
    	.f  s dspSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub,"D",dspSub)) q:(dspSub="")!(dspStat="C")  d
    		..s dspStat=$P(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub,"D",dspSub),"^",6) */
    s DSPRowId="",allC=1,allTC=1,returnFlag=0 //ypz 081225 增加"PC"部分发
    f  s DSPRowId=$O(^DHCOEDISQTY(0,"OEORI",oeoriId,DSPRowId)) q:DSPRowId=""  d
        .q:$P($G(^DHCOEDISQTY(DSPRowId)),"^",7)=""
        .i $P($G(^DHCOEDISQTY(DSPRowId)),"^",7)="R" s returnFlag=1
        .i $P($G(^DHCOEDISQTY(DSPRowId)),"^",7)'="C" s allC=0
        .i $P($G(^DHCOEDISQTY(DSPRowId)),"^",7)'="TC" s allTC=0
    s dspStat=""
  
    i allC=1,allTC=0 s dspStat="C"   //已发
    i allC=0,allTC=1 s dspStat="TC"  //未发
    i allC=0,allTC=0 s dspStat="PC"  //部分发
    i returnFlag=1 s dspStat="C"     //视为已发
 	q dspStat                                                                            //WKZ071019 E
}

ClassMethod GetOecprCode(oeoriId)
{
	q:(oeoriId="") ""
	s oeordId=+oeoriId,oeoriSub=$p(oeoriId,"||",2)
   	q:oeoriSub="" ""

	s oecprId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",8)
    q:oecprId="" ""
    s oecprCode=$p($g(^OECPR(oecprId)),"^")
	q:oecprCode="" ""
	q oecprCode
}

ClassMethod CanExecSkinTestOrd(oeoriId)
{
	q:(oeoriId="") ""
	s oeordId=+oeoriId,oeoriSub=$p(oeoriId,"||",2)
   	q:oeoriSub="" ""

    s resStr=0
    s curOriSub="" f  s curOriSub=$o(^OEORDi(0,"OEORI",oeordId,oeoriId,curOriSub)) q:(curOriSub="")  d
		.s skinTestFlag=$p($g(^OEORD(oeordId,"I",curOriSub,5)),"^",2)
		.s abnorm=$p($g(^OEORD(oeordId,"I",curOriSub,11)),"^",3)
		.i (skinTestFlag="Y")&(abnorm="Y") s resStr="皮试阳性!"
		.i (skinTestFlag="Y")&(abnorm="") s resStr="请先置皮试结果!"
	q resStr
}

ClassMethod GetOrdSubCatType(oeoriId) As %String
{
 	n (oeoriId)
	q:oeoriId="" ""
	s oeordId=+oeoriId
    s oeoriSub=$p(oeoriId,"||",2)
	q:'$d(^OEORD(oeordId,"I",oeoriSub,1)) ""
 	s arcimId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)
 	q:arcimId="" ""
 	s arcimVersion=$p(arcimId,"||",2)
 	q:'$d(^ARCIM(+arcimId,arcimVersion,1)) ""
 	s arcicId=$p(^ARCIM(+arcimId,arcimVersion,1),"^",10)
 	q:arcicId="" ""
 	q:'$d(^ARC("IC",arcicId)) ""
 	s arcicOrderType=$p(^ARC("IC",arcicId),"^",7)
	q arcicOrderType
}

ClassMethod GetPAAllergyDesc(PatientID, EpisodeID, oeoriId, descMaxLength = 0) As %String
{
	//取过敏记录,descMaxLength大于0起作用,每条过敏描述的最大长度
	q:(PatientID="")&(EpisodeID="")&(oeoriId="") ""
	i PatientID="" d
    .i EpisodeID="" d
	..s EpisodeID=+^OEORD(+oeoriId)
	.i EpisodeID=0 q
	.s PatientID=+^PAADM(EpisodeID)
	q:PatientID=0 ""
	s ret=""
	S obj=##class(%ResultSet).%New("web.PAAllergy:Find")
	d obj.Execute(PatientID,"Y")
	f  q:'obj.Next()  d
	.s desc1=obj.Data("PACALGDesc")
	.i desc1'="" s desc=desc1
	.e  s desc=obj.Data("PHCGEName")
	.q:desc=""
	.i descMaxLength>0 s desc=$e(desc,1,descMaxLength)
	.i ret="" s ret=desc
	.e  s ret=ret_","_desc
	q ret
}

/// w ##class(web.DHCCLCom).GetOrderBaseQty("1057||22")
ClassMethod GetOrderBaseQty(oeoriId) As %String
{
	//取医嘱计价数量
	q:oeoriId="" 0
	s oeordId=$p(oeoriId,"||",1),oeoriSub=$p(oeoriId,"||",2)
    s arcimId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)
    q:arcimId="" 0
    
	s phOrdQty=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",12)
	s arcicOrderType=##Class(web.DHCCLCom).GetOrdSubCatType(oeoriId)
	b ;-1
	q:arcicOrderType'="R" phOrdQty
	
	s doseQty=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",1)
    i doseQty="" q phOrdQty
    s phcfrFactor=1
    s phcfrId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",4)
    i phcfrId="" q phOrdQty
    s phcfrFactor=$p(^PHCFR(phcfrId),"^",2)
	s phcfrFactorDays=+$p(^PHCFR(phcfrId),"^",5)
	i (phcfrFactorDays=0) s phcfrFactorDays=1
	//s unitUomId=934
    s phcdfId=$p($g(^ARCIM(+arcimId,$p(arcimId,"||",2),1)),"^",12)
    b ;0
    q:phcdfId="" phOrdQty
    s phcdId=+phcdfId,phcdfSub=$p(phcdfId,"||",2)
    s baseUomId=$p($g(^PHCD(phcdId,"DF",phcdfSub,2)),"^",4)
    
    s qtyPackUom=$p($g(^OEORD(oeordId,"I",oeoriSub,9)),"^",4)
    s packUomId=$p($g(^ARCIM(+arcimId,$p(arcimId,"||",2),8)),"^",14)
    i $g(^OEORD(oeordId,"I",oeoriSub,"DHC"))'="" s packUomId=$p($g(^OEORD(oeordId,"I",oeoriSub,"DHC")),"^",13)
    //w packUomId_","_qtyPackUom_"/",!
    s packDoseQty=0
    i +qtyPackUom'=0,packUomId'="" d
        .s factor=1
        .i baseUomId'=packUomId d
            ..s ctcfId=$o(^CT("CTCF",0,"UOM",packUomId,baseUomId,""))
		    ..i ctcfId'="" s factor=$p(^CT("CTCF",ctcfId),"^",3)
		.//w "factor="_factor,!
	    .q:+factor=0
		.s packDoseQty=qtyPackUom*factor ;;dQty/factor  ;包装单位转换
		.i $p(packDoseQty,".",2)>0 s packDoseQty=$p(packDoseQty,".",1)+1
		b ;1
	i packDoseQty'=0 q packDoseQty
    
	s phcduId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",6)
	s phcduFactor=1
	i phcduId'="" s phcduFactor=$p(^PHCDU(phcduId),"^",2)
	b ;2
	i +phcduFactor=0 q phOrdQty
    s unitUomId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",3)
    //w oeoriSub_"||"_unitUomId_"/"_baseUomId_"/"_packUomId_"/"
    b ;3
    q:unitUomId="" phOrdQty
    s eqQty=1
    i baseUomId'=unitUomId d
        .s eqId=0,eqQty=0
        .f  s eqId=$o(^PHCD(phcdId,"DF",phcdfSub,"EQ",eqId)) q:eqId=""  d
            ..s eqUomId=+^PHCD(phcdId,"DF",phcdfSub,"EQ",eqId)
            ..i eqUomId=unitUomId s eqQty=$p(^PHCD(phcdId,"DF",phcdfSub,"EQ",eqId),"^",2)
            b ;4
    i eqQty=0 q phOrdQty
    s dQty=doseQty/eqQty
    i $p(dQty,".",2)>0 s dQty=$p(dQty,".",1)+1
    //w "eqQty="_eqQty_"/"_dQty_"/"_phcfrFactor,!
    s qty=dQty*phcfrFactor*(phcduFactor/phcfrFactorDays)
    b ;5
   	q qty
}

Query GetCtloc() As %SQLQuery(CONTAINID = 1, ROWSPEC = "CTLOC_RowId:%Integer,CTLOC_Desc:%String")
{
    select CTLOC_RowId,CTLOC_Desc from CT_LOC where CTLOC_Type<>'OR' and CTLOC_Type<>'O' order by CTLOC_Type
}

Query GetCTCP(locDesc As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ctcpDesc:%String,ctcpId:%Integer")
{
	select RES_CTPCP_DR->CTPCP_Desc,RES_CTPCP_DR from RB_Resource where RES_CTLOC_DR->CTLOC_Desc=:locDesc and RES_ScheduleRequired<>'Y'
}

ClassMethod IfActualDoc(EpisodeID) As %String
{
	n (EpisodeID)
	q:EpisodeID="" "N"
	s ctcpId=$p(^PAADM(EpisodeID),"^",9)
	s ctlocId=$p(^PAADM(EpisodeID),"^",4)
	s resId=$o(^RB("RES",0,"CTPCP",ctcpId,ctlocId,""))
	q:resId="" "N"
	i $p($g(^RB("RES",resId)),"^",6)="Y" q "N"
	q "Y"
}

ClassMethod GetArcimShortDesc(arcimId, oeoriId) As %String
{
   //取医嘱短名称
    n (arcimId,oeoriId)
    i arcimId="" d
        .s oeordId=+oeoriId
        .s oeoriSub=$p(oeoriId,"||",2)
        .q:oeoriSub=""
        .s arcimId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)
        .s deeppurple=$p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",55)
    q:arcimId="" ""
    s arcimVer=$p(arcimId,"||",2)
    q:arcimVer="" ""
    s arcimshortDesc=$p($g(^ARCIM(+arcimId,arcimVer,1)),"^",3)
    i deeppurple="Y" s arcimshortDesc="急"_"-"_arcimshortDesc
    e  s arcimshortDesc=arcimshortDesc
    q arcimshortDesc
}

ClassMethod GetPatConfig() As %String
{
    s patcfId=$o(^CF("PATCF",""))
    i patcfId="" q "8^"
    s patcfIpNoLength=$p($g(^CF("PATCF",patcfId,3)),"^",5)
    i patcfIpNoLength<8 s patcfIpNoLength=8
	q patcfIpNoLength_"^"
}

Query GetAdmSource() As %SQLQuery(CONTAINID = 1, ROWSPEC = "adsouDesc:%String,adsouId:%Integer")
{
	select ADSOU_Desc,ADSOU_RowId from PAC_AdmSource
}

ClassMethod GetConnectStr()
{
	&sql(select LayoutManager into :ConnectStr from websys.configuration)
	q ConnectStr
}

/// 转科主管医生信息
Query GetPaAdmTranInfo(EpisodeID As %String) As %SQLQuery
{
SELECT TRANS_RowId,TRANS_StartDate,TRANS_StartTime,TRANS_UpdateUser_DR->SSUSR_Name,TRANS_CTCP_DR->CTPCP_Unit,TRANS_CTCP_DR->CTPCP_Desc,TRANS_CTLOC_DR->CTLOC_Desc,TRANS_EndDate,TRANS_EndTime,TRANS_Main,TRANS_Reason_DR->BTR_Desc,TRANS_UpdateDate,TRANS_UpdateTime,TRANS_TransType_DR->TRANSTYP_Desc
FROM SQLUser.PA_AdmTransaction
WHERE TRANS_ParRef=:EpisodeID AND ((TRANS_CTLOC_DR IS NOT NULL) OR (TRANS_CTCP_DR  IS NOT NULL)) AND (TRANS_Status_DR->REQST_Code <> 'J')
ORDER BY TRANS_StartDate DESC, TRANS_StartTime DESC, TRANS_EndDate ASC
}

/// 病区床位状态改变
Query PACBedStatusChange(PARREF As %String = "") As %SQLQuery
{
SELECT STAT_RowID, STAT_Date, STAT_Time, 
     STAT_DateTo, STAT_TimeTo, 
     STAT_ReasonNotAvail_DR->RNAV_Desc, 
     STAT_User_DR->SSUSR_Name
FROM 
     SQLUser.PAC_BedStatusChange
WHERE 
     STAT_ParRef = :PARREF
ORDER BY STAT_Date DESC, STAT_Time DESC
}

/// Creator: wangxinlei
/// CreatDate: 2009-08-18
/// Description: 取血型
/// Table：CTBB_BloodGroup
/// Input：regNo: 病人登记号
/// Return：返回血型与Rh阴阳性
ClassMethod GetBloodType(regNo As %String) As %String
{
  ;w ##class(web.DHCCLCom).GetBloodType("01539993")
  ;n (regNo)
  q:regNo="" ""
  s bldGpId=""
  i $d(^TDEB(regNo)) d
  .s bldGpId=$p($G(^TDEB(regNo)),"\",4)
  .i '$l(bldGpId) d
  ..s bldGpId=$p($g(^TDEB(regNo)),"\",10)
  s BG="",Rh=""
  i $l(bldGpId) d
  .s BG=$p(^TTAB("BB-BG",bldGpId),"\",2)_"型"
  .;i $p(^TTAB("BB-BG",bldGpId),"\",3)="P" s Rh="阳性(+)"
  .;i $p(^TTAB("BB-BG",bldGpId),"\",3)="N" s Rh="阴性(-)"
  s BGRh=BG_Rh
  q BGRh
}

/// Creator: wangxinlei
/// CreatDate: 2009-07-28
/// Description: 根据就诊ID找病人的病区
/// Table：PA_Adm,PAC_Ward
/// Input：EpisodeID: 病人就诊ID
/// Return：返回病人病区ID^病区描述 curWardId_"^"_curWardDesc
ClassMethod GetPatWard(EpisodeID) As %String
{
    n (EpisodeID)
    q:EpisodeID="" "^"
    s curWardId=""
    s curWardDesc=""				
    s curWardId=$p($g(^PAADM(EpisodeID)),"^",70)  
    i curWardId'="" s curWardDesc=$p($g(^PAWARD(+curWardId)),"^",2)
    q curWardId_"^"_curWardDesc
}

/// Creator: wangxinlei
/// CreatDate: 2009-09-03
/// Description: 取科室
/// Table：CT_Loc,CT_Hospital
/// Input：LocDesc: 查询条件
/// Return：CTLocDesc:医院名称^科室描述, CTLocId:科室的ID
Query FindCTLoc(LocDesc As %String, HospID = "", IfHsop = "N") As %Query(ROWSPEC = "CTLocId:%String,CTLocDesc:%String")
{
}

ClassMethod FindCTLocExecute(ByRef qHandle As %Binary, LocDesc As %String, HospID = "", IfHsop = "N") As %Status
{
	s ^tempsc("FindCTLoc")=$lb(LocDesc, HospID, IfHsop)
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	;s rowid=0
 	if $d(%session)&&(HospID=""){
	 	;w "yiyuan:"_%session.Get("LOGON.HOSPID")
 		set HospID=%session.Get("LOGON.HOSPID")
	}
 	s HospMaxStrNum=..GetHospMaxStrNum()
	i $g(LocDesc)'="" s LocDesc=$$ALPHAUP^SSUTIL4(LocDesc)
	s len=$l(LocDesc)
    s CTLocId=0 f  s CTLocId=$o(^CTLOC(CTLocId)) q:CTLocId=""  d
    .q:'$d(^CTLOC(CTLocId))
    .i IfHsop="Y" s ifShow=##class(Nur.Interface.Other.BDPInterface).GetHospShowDataFlagSpecial("CT_Loc",CTLocId,HospID,"Nur_IP_DHCOEOrdPrintSet")
    .q:(IfHsop="Y")&&($g(ifShow)'="Y")
    .s dateFrom=$P(^CTLOC(CTLocId),"^",24)
 	.s dateTo=$P(^CTLOC(CTLocId),"^",25)
 	.s h=+$h
 	.q:(((h<dateFrom)&&(dateFrom'=""))!((h>dateTo)&&(dateTo'="")))
    .s CTLocDesc=$p(^CTLOC(CTLocId),"^",2)
    .s tmpLocDesc=$$ALPHAUP^SSUTIL4(CTLocDesc)
    .s tmpLocDesc=$e(tmpLocDesc,1,len)
    .q:tmpLocDesc'=LocDesc
    .s CTLocType=$p($G(^CTLOC(CTLocId)),"^",13)
    .q:(CTLocType="OR")!(CTLocType="O")
    .s HospitalRowId=$p($G(^CTLOC(CTLocId)),"^",22)
    .i HospitalRowId'="" s HospitalName=$p($G(^CT("HOSP",HospitalRowId)),"^",2)
	.e  s HospitalName=""
	.s HospNamelen=$L(HospitalName)
	.s le=HospMaxStrNum-HospNamelen
	.f i=1:1:le d 
	..s HospitalName=HospitalName_"---"
	.s CTLocDesc=HospitalName_"——"_CTLocDesc
 	.Do Output
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
Output
	set Data=$lb(CTLocId,CTLocDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindCTLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCTLocExecute ]
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

ClassMethod FindCTLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCTLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator: wangxinlei
/// CreatDate: 2009-09-07
/// Description: 取最长的医院名称的字符数
/// Table：CT_Hospital
/// Input：无
/// Return：返最长的医院名称的字符数
ClassMethod GetHospMaxStrNum() As %String
{
  s StrNum=0
  s HospRowId=""
  f  s HospRowId=$O(^CT("HOSP",HospRowId)) q:HospRowId=""  d
  .s HospName=$p($G(^CT("HOSP",HospRowId)),"^",2)
  .s tmpStrNum=$L(HospName)
  .i tmpStrNum>StrNum s StrNum=tmpStrNum 
  q StrNum
}

Query LookUpLocCtcp(locDesc As %String) As %Query(ROWSPEC = "ctcpDesc:%String,ctcpId:%String")
{
}

ClassMethod LookUpLocCtcpExecute(ByRef qHandle As %Binary, locDesc As %String = "") As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 	//w " desc="_desc," admType="_admType,!
	s locId=""
	i locDesc'="" s locId=$o(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(locDesc),""))
	i locId="" s qHandle=$lb(0,repid,0) q $$$OK

	s resId=0
	f  s resId=$o(^RB("RES",0,"CTLOC",locId,resId)) q:resId=""  d
	    .s ctcpId=$p(^RB("RES",resId),"^",2)
	    .q:$d(^CTPCP(ctcpId))=0
	    .s ctcpDesc=$p($g(^CTPCP(ctcpId,1)),"^",2)
	    .d OutputRow5
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
OutputRow5
	s Data=$lb(ctcpDesc,ctcpId)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod LookUpLocCtcpFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpLocCtcpExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
	//
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {				// fetch row
 		s Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod LookUpLocCtcpClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpLocCtcpExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

ClassMethod GetCtlocIdByCodeOrDesc(codeOrDesc As %String, node As %String) As %String
{
	q:node="" ""
	q:codeOrDesc="" ""
	s codeOrDesc=$$ALPHAUP^SSUTIL4(codeOrDesc)
	q $o(^CTLOC(0,node,codeOrDesc,""))
}

ClassMethod GetUserIdByInitials(ssusrInitials As %String) As %String
{
	q:ssusrInitials="" ""
	s ssusrInitials=$$ALPHAUP^SSUTIL4(ssusrInitials)
	q $o(^SSU("SSUSR",0,"SSUSR_Initials",ssusrInitials,""))
}

ClassMethod GetCtcpIdByInitials(ssusrInitials As %String) As %String
{
	q:ssusrInitials="" ""
	s ssusrInitials=$$ALPHAUP^SSUTIL4(ssusrInitials)
	s userId=$o(^SSU("SSUSR",0,"SSUSR_Initials",ssusrInitials,""))
	q:userId="" ""
	q $P(^SSU("SSUSR",userId),"^",14)
}

ClassMethod ConvertToDateH(dateStr As %String, defaultVal As %String = "$H") As %String
{
    q:((dateStr="")!(dateStr<0))&(defaultVal="") ""
    q:(dateStr="")!(dateStr<0) +$h
	s $zt="ERROR"
	i $l(dateStr,"-")>2 q $$$zdh(dateStr,3)
	i $l(dateStr,"/")>2 q $$$zdh(dateStr,4)
    q +dateStr
ERROR	; 
    q:(defaultVal="") ""
    q +$h
}

ClassMethod ConvertToTimeH(timeStr As %String, defaultVal As %String = "$H") As %String
{
    //q:timeStr="" $p($h,",",2)
	//i $l(timeStr,":")>1 q $zth(timeStr,3)
    //q +timeStr
	q:((timeStr="")!(timeStr<0)!(timeStr>86399))&(defaultVal="") ""
	q:((timeStr="")!(timeStr<0)!(timeStr>86399))&(defaultVal="0") 0
	q:((timeStr="")!(timeStr<0)!(timeStr>86399)) $p($h,",",2)
	i $l(timeStr,":")>1 d
        .s tmpHour=+$p(timeStr,":")
        .//w tmpHour,!
        .s tmpHour=$p(tmpHour,".")
        .q:(tmpHour<0)!(tmpHour>23)
        .s $p(timeStr,":")=tmpHour
        .s tmpMinute=+$p(timeStr,":",2)
        .s tmpMinute=$p(tmpMinute,".")
        .//w tmpMinute,!
        .q:(tmpMinute<0)!(tmpMinute>59)
        .s $p(timeStr,":",2)=tmpMinute
        .s tmpSecond=+$p(timeStr,":",3)
        .s tmpSecond=$p(tmpSecond,".")
        .//w tmpSecond,!
        .q:(tmpSecond<0)!(tmpSecond>59)
        .
		.s timeStr=$ZTH(tmpHour_":"_tmpMinute_":"_tmpSecond,3)
	q +timeStr
}

ClassMethod GetDiag(EpisodeID)
{
    s mrDiaDesc=""
    s mrAdmId=$P(^PAADM(EpisodeID),"^",61)
    s mrDiaChild=0
    f  s mrDiaChild=$O(^MR(mrAdmId,"DIA",mrDiaChild)) q:(mrDiaChild="")  d
        .s curDiaDesc=""
        .s mrDiaId=$p($G(^MR(mrAdmId,"DIA",mrDiaChild)),"^",1)
        .i mrDiaId'="" s curDiaDesc=$p($G(^MRC("ID",mrDiaId)),"^",2)
        .i mrDiaDesc'="",curDiaDesc'="" s mrDiaDesc=mrDiaDesc_","
        .s mrDiaDesc=mrDiaDesc_curDiaDesc
        .s curDiaDesc=$g(^MR(mrAdmId,"DIA",mrDiaChild,"DES",1))
        .q:curDiaDesc=""
        .i mrDiaDesc'="" s mrDiaDesc=mrDiaDesc_","
        .s mrDiaDesc=mrDiaDesc_curDiaDesc
    q mrDiaDesc
}

// 常用码表查找

Query LookUpComCode(type) As %Query(ROWSPEC = "tCode:%String,tDesc:%String")
{
}

ClassMethod LookUpComCodeExecute(ByRef qHandle As %Binary, type) As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 	i type="" s type="Default"
 	s codeId=0
 	f  s codeId=$o(^DHCCLComCode(type,codeId)) q:codeId=""  d
 		.s ifActive=$p(^DHCCLComCode(type,codeId),"^",3)
 		.q:(ifActive'="Y")&(ifActive'="")
 		.s tCode=$p(^DHCCLComCode(type,codeId),"^",1)
 		.s tDesc=$p(^DHCCLComCode(type,codeId),"^",2)
 		.d OutputRow2
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
OutputRow2
	s Data=$lb(tCode,tDesc)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod LookUpComCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpComCodeExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
	//
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {				// fetch row
 		s Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod LookUpComCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpComCodeExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

ClassMethod GetComDescByCode(type, code)
{
	q:(type="")!(code="") ""
 	s codeId=0,desc=""
 	f  s codeId=$o(^DHCCLComCode(type,codeId)) q:codeId=""  d
 		.s ifActive=$p(^DHCCLComCode(type,codeId),"^",3)
 		.q:(ifActive'="Y")&(ifActive'="")
 		.q:code'=$p(^DHCCLComCode(type,codeId),"^",1)
 		.s desc=$p(^DHCCLComCode(type,codeId),"^",2)
	q desc
}

/// Creator: yupeizhi
/// CreatDate: 2010-04-20
/// Description: 根据科室列表取科室  
/// 代码:"INOPDEPT"住院手术科室,"OUTOPDEPT"门诊手术科室,"EMOPDEPT"急诊手术科室,"AN"麻醉科,"OP"手术室,
/// "OUTAN"门诊麻醉科,"OUTOP"手术室,"EMAN"门诊麻醉科,"EMOP"手术室,"ICU"重症科室
/// Table：CT_Loc
/// Input：desc:手术科室描述
/// Return：返回所查询科室ID:ctlocId,科室名:ctlocDesc,科室代码:ctlocCode,
Query FindLocList(desc As %String, locListCodeStr As %String = "", EpisodeID As %String = "") As %Query(ROWSPEC = "ctlocId:%String,ctlocDesc:%String,ctlocCode:%String")
{
}

ClassMethod FindLocListExecute(ByRef qHandle As %Binary, desc As %String, locListCodeStr As %String = "INOPDEPT", EpisodeID As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	s desc=$$ALPHAUP^SSUTIL4(desc)
	s locListCodeStr=..AdjustLocListCode(locListCodeStr,EpisodeID)
	s ctlocIdList=..GetLocIdByLocListCode(locListCodeStr)
	f i=1:1:$l(ctlocIdList,"^") d
		.s ctlocId=$p(ctlocIdList,"^",i)
		.q:ctlocId=""
		.q:'$d(^CTLOC(ctlocId))
	    .s ctlocDesc=$p(^CTLOC(ctlocId),"^",2)
	    .q:(desc'="")&($p($$ALPHAUP^SSUTIL4(ctlocDesc),desc)'="")
	    .s ctlocCode=$p(^CTLOC(ctlocId),"^",1)
	    .Do OutputRow6
	i ctlocIdList="" d
	    .s rowid=0
	    .i $g(desc)=""  d
	        ..s desc="%"
	    .e  d
	        ..s desc=desc_"%"
	   	.&sql(declare ctloc cursor  for select distinct CTLOC_RowId,CTLOC_Desc,CTLOC_Code
	              from SQLUser.CT_LOC WHERE (UPPER(CTLOC_Desc) like :desc))
	    .&sql(open ctloc)
		.f  &sql(fetch ctloc into :ctlocId,:ctlocDesc,ctlocCode) q:SQLCODE  d
 			..Do OutputRow6	 	
 		.&sql(close ctloc)
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow6
	set Data=$lb(ctlocId,ctlocDesc,ctlocCode)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindLocListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindLocListExecute ]
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

ClassMethod FindLocListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindLocListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod AdjustLocListCode(locListCodeStr As %String, EpisodeID As %String) As %String
{
	q:EpisodeID="" locListCodeStr
	s admType=$p($g(^PAADM(EpisodeID)),"^",2)
	q:admType="" locListCodeStr
	s admTypeStr=""
	i admType="O" s admTypeStr="OUT"
	i admType="E" s admTypeStr="EM"
	f i=1:1:$l(locListCodeStr,"^") d
		.s locListCode=$p(locListCodeStr,"^",i)
		.i admTypeStr'="",$p(locListCode,admTypeStr)'="" s $p(locListCodeStr,"^",i)=""
		.i (admTypeStr="")&($p(locListCode,"OUT")=""!($p(locListCode,"EM")="")) s $p(locListCodeStr,"^",i)=""
	q locListCodeStr
}

ClassMethod GetLocIdByLocListCode(locListCodeStr As %String) As %String
{
	q:locListCodeStr="" ""
	s ctlocIdList=""
	f i=1:1:$l(locListCodeStr,"^") d
		.s locListCode=$p(locListCodeStr,"^",i)
		.q:locListCode=""
		.s locListId=$o(^CT("LL",0,"Code",locListCode,""))
		.q:locListId=""
	    .s locListLocId=0
	    .f  s locListLocId=$o(^CT("LL",locListId,"LOC",locListLocId)) q:locListLocId=""  d
	        ..s ctlocId=$p(^CT("LL",locListId,"LOC",locListLocId),"^")
	        ..q:ctlocId=""
	        ..q:'$d(^CTLOC(ctlocId))
	        ..i ctlocIdList'="" s ctlocIdList=ctlocIdList_"^"
	        ..s ctlocIdList=ctlocIdList_ctlocId
	q ctlocIdList
}

ClassMethod GetOrdInfo(oeoreId, OrdInfo) As %String
{
}

ClassMethod GetSeqNo(oeordId, oeoriSub)
{
	s seqNo=$p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",39)
	q seqNo
}

Query FindOrditem(wardId As %String, regNo As %String, userId As %String, startDate As %String, endDate As %String, queryTypeCode As %String, gap As %String, locId As %String, admType As %String, exeFlag As %String, HospitalRowId As %String, DocSearch As %String = "") As %Query(ROWSPEC = "prtFlag,regNo,bedCode,patName,patIdentity,age,orcatDesc,seqNo,arcimDesc,oecprDesc,ordStatDesc,labNo,doseQtyUnit,phcfrCode,phOrdQtyUnit,phcinDesc,notes,execStat,execDateTime,execCtcpDesc,ctcpDesc,disposeStatDesc,reclocDesc,sttDateTime,xDateTime,execXUserDesc,prescNo,price,totalAmount,execXDateTime,xCtcpDesc,createDateTime,oeoriId,placerCode,disposeStatCode,tmpPrtFlag,Durat,placerNo,skinTestDateTime,EpisodeID,specDesc,DspStat,specCollDateTime,LocalInfusionQty,stayStauts,OrderDep,EncryptLevel,PatLevel,disposeStatDesc")
{
}

ClassMethod FindOrditemExecute(ByRef qHandle As %Binary, wardId As %String, regNo As %String, userId As %String, startDate As %String, endDate As %String, queryTypeCode As %String, gap As %String, locId As %String, admType As %String, exeFlag As %String, HospitalRowId As %String, DocSearch As %String = "") As %Status
{
    s repid=$i(^CacheTemp)
 	s ind=1
 	
 	//s wardId=$p(wardId,"|",1)
 	//s locId=$p(wardId,"|",2)
 	//s queryTypeCode="Default"
 	//s ^HHH=wardId
 	//w wardId,"/",regNo,"/",userId,"/",startDate,"/",endDate,"/",queryTypeCode,"/",gap,"/",locId,"/",admType,"/",exeFlag,!
 	i userId=""  s qHandle=$lb(0,repid,0) q $$$OK
 	//ypz 060302 begin
 	i queryTypeCode="",HospitalRowId="" s qHandle=$lb(0,repid,0) q $$$OK // s queryTypeCode="Default"
 	s curRegNo=$p(regNo,"^",1) //ypz 060728
 	i $g(^TMPNurOPDebug)="Y" s ^TMPNurOPDebug("date")=startDate_"/"_endDate
 	s EpisodeID=$p(regNo,"^",2)
 	i EpisodeID'="" s startDate=$p($g(^PAADM(EpisodeID)),"^",6)
 	i (admType'="I")&(regNo'="")&(EpisodeID="") d   //ypz 060702
 	    .s papmiId=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(regNo),"")) 
        .q:papmiId=""
        .s minDate=startDate
        .i admType["O" d
        	..s EpisodeID=""  //ypz 060718
        	..f  s EpisodeID=$o(^PAPERdr(papmiId,"ADM","O",EpisodeID),-1) q:EpisodeID=""  d
        		...i EpisodeID'="" d 
        			....s pavisit=$p($g(^PAADM(EpisodeID)),"^",20)
        			....i pavisit'="A" q   ;
        			....s admDate=$p($g(^PAADM(EpisodeID)),"^",6)
        			....s EpisodeID=0
        			....i minDate>admDate s minDate=admDate
        .i admType["E" d
        	..s EpisodeID=""
        	..f  s EpisodeID=$o(^PAPERdr(papmiId,"ADM","E",EpisodeID),-1) q:EpisodeID=""  d
        		...i EpisodeID'="" d 
        			....s pavisit=$p($g(^PAADM(EpisodeID)),"^",20)
        			....i pavisit'="A" q   ;
        			....s admDate=$p($g(^PAADM(EpisodeID)),"^",6)
        			....s EpisodeID=0
        			....i minDate>admDate s minDate=admDate
        .i minDate<startDate s startDate=minDate
	i $g(^TMPNurOPDebug)="Y" s ^TMPNurOPDebug("date")=^TMPNurOPDebug("date")_" afterAdm: "_startDate_"/"_endDate
     /*	i (admType'="I")&(regNo'="") d   //ypz 060702
 	    .s papmiId=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(regNo),"")) 
        .q:papmiId=""
        .s EpisodeID=$o(^PAPERdr(papmiId,"ADM",admType,""),-1)
        .q:EpisodeID=""  
        .s pavisit=$p($g(^PAADM(EpisodeID)),"^",20)
        .i pavisit'="A" q   ;
        .s admDate=$p($g(^PAADM(EpisodeID)),"^",6)
        .i (admDate<startDate) s startDate=admDate	*/

    i admType'="I" s retStr=##Class(web.DHCNurCom).FindPatient(locId,regNo,userId,admType,startDate,endDate) 
 	i admType="I" s retStr=##Class(web.DHCNurCom).FindPatient(wardId,regNo,userId,admType,startDate,endDate) 
    //ypz 060302 end
    ////s a=##CLASS(web.udhcclnurseexec).FindPatient(wardId,regNo,userId) //ypz 060302
    ///////s patstr=##CLASS(web.udhcclnurseexec).GetAllPatient(userId)//ypz 060302
    s patstr=##Class(web.DHCNurCom).GetAllPatient(userId)
    //w "patstr="_patstr,!
    s num=$l(patstr,"^")
    i patstr="" s num=0 //ypz 070108
    s varStr=$G(^DHCCLNurseExec("VarDef",HospitalRowId,queryTypeCode,"VarId"))
    q:varStr=""
    s varCount=$l(varStr,"^") ;对应项
    //s ^mtemp("query")=1
    s varId=0 ;初始化全部变量值  //不可与上面的部分合并:看是否在^varStr^中!!
    f  s varId=$o(^DHCCLNurseExec("Var",varId)) q:varId=""  d
        .s varName=$p(^DHCCLNurseExec("Var",varId),"^",2)
        .s data(varName)=""
    f i=1:1:num
    {
     	s pat=$p(patstr,"^",i)
     	s EpisodeID=$p(pat,"!",1)
     	q:EpisodeID=""
		//执行医嘱界面关联收费子医嘱Global
     	k ^TMP("NurExecOrderAttach",userId,EpisodeID)
     	i $g(^TMPNurOPDebug)="Y" k ^TMPNurOPDebug(EpisodeID)
     	s lisnum=##Class(web.DHCNurCom).GetOrderItem("","",EpisodeID,startDate,endDate,userId,wardId,queryTypeCode,gap,locId,exeFlag,HospitalRowId)
     	i $g(^TMPNurOPDebug)="Y" s ^TMPNurOPDebug(EpisodeID)=lisnum
     
     	//w EpisodeID," ",startDate," ",endDate," ",userId," ",wardId," ",queryTypeCode," gap=",gap," ",locId," num=",lisnum," ",exeFlag,"/",!
     	f j=1:1:lisnum
     	{
	        s ordstr=##Class(web.DHCNurCom).GetData("","",j)
	        ;s ^gyongao= ordstr
	        f ivar=1:1:varCount 
	        {
		        s varName=$p(^DHCCLNurseExec("Var",$p(varStr,"^",ivar)),"^",2)
                s data(varName)=$p(ordstr,"!",ivar)
            } 
            
            s oeoriId=$p(ordstr,"!",ivar+1)
            
            //s arcicId=$p(ordstr,"!",ivar+2) // 
            s placerCode=$p(ordstr,"!",ivar+2) // 
            s disposeStatCode=$p(ordstr,"!",ivar+3)
            s tmpPrtFlag=$p(ordstr,"!",ivar+4)
            s stayStauts=$p(ordstr,"!",ivar+5)
			s oeordId=$P(oeoriId,"||",1),oeoriSub=$P(oeoriId,"||",2),oeoreSub=$P(oeoriId,"||",3)
			
			i oeoreSub="" s oeoreSub=0
			s ordLoc=$p($g(^OEORD(oeordId,"I",oeoriSub,7)),"^",2)
			s OrderDep=""
			i ordLoc'="" s OrderDep=$p(^CTLOC(ordLoc),"^",2)
			//s ^Temp("wanghc",oeoriSub)=oeordId_"||"_oeoriSub
			s abnInfo=##class(ABN.dao.DHCDocAllergyInterface).GetSkinInfo(oeordId_"||"_oeoriSub)
			i +abnInfo'=0 d
			.s abnId=$p(abnInfo,"^",1)
			.s abnType=$p(abnInfo,"^",3)
			.q:$g(abn(abnId,abnType))'=""
			.s abn(abnId,abnType)=abnInfo
			.s data("arcimDesc")=$p(abnInfo,"^",2)
			.s oeoriId=abnId_"^"_abnType
			.d OutRow
			continue:+abnInfo'=0
			i oeordId'="",oeoriSub'="" d
			.s subflag=$p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",39)
    		.i subflag="" d
    		..i oeoreSub="" s oeoreSub=0
    		..s ^TMP("NurExecOrderAttach",userId,EpisodeID,oeordId,oeoriSub,oeoreSub)=""
           s patInfo = ..PatInfo("^"_EpisodeID)
    	   s data("patName")=$p(patInfo,"^",5)
    	   s data("age")=$p(patInfo,"^",8)
           d OutRow
	    }
	}
    s qHandle=$lb(0,repid,0)
	q $$$OK
OutRow 

	s Data=$lb(data("prtFlag"),data("regNo"),data("bedCode"),data("patName"),data("patIdentity"),data("age"),data("orcatDesc"),data("seqNo"),data("arcimDesc"),data("oecprDesc"),data("ordStatDesc"),data("labNo"),data("doseQtyUnit"),data("phcfrCode"),data("phOrdQtyUnit"),data("phcinDesc"),data("notes"),data("execStat"),data("execDateTime"),data("execCtcpDesc"),data("ctcpDesc"),data("disposeStatDesc"),data("reclocDesc"),data("sttDateTime"),data("xDateTime"),data("execXUserDesc"),data("prescNo"),data("price"),data("totalAmount"),data("execXDateTime"),data("xCtcpDesc"),data("createDateTime"),oeoriId,placerCode,disposeStatCode,tmpPrtFlag,data("Durat"),data("placerNo"),data("skinTestDateTime"),EpisodeID,data("specDesc"),data("DspStat"),data("specCollDateTime"),data("LocalInfusionQty"),stayStauts,OrderDep,data("EncryptLevel"),data("PatLevel"),data("disposeStatDesc"))
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindOrditemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOrditemExecute ]
{
	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {			
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindOrditemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOrditemExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
    q $$$OK
}

/// /获取病人密级与级别
ClassMethod GetPatEncryptLevel(PatientID, EpisodeID)
{
	New (PatientID,EpisodeID,%session)
	If (+PatientID=0)&&(+EpisodeID'=0) Do
	.Set PatientID=$p(^PAADM(EpisodeID),"^",1)
	Quit:(+PatientID=0)&&(+EpisodeID=0) "^"
	Set ErrMsg=""
	Set EncryptLevelStr=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(PatientID,.ErrMsg)
	;Set EncryptLevelStr="*****^测试^S^6"
	Quit EncryptLevelStr
}

/// w ##class(web.DHCCLCom).SaveRecord()
ClassMethod SaveRecord(ModelName, ConditionStr, printType, queryTypeCode, SecretCode = "", UserId = "")
{
	s ModelId=##class(web.DHCEventModel).ValidModelCode(ModelName)
	q:ModelId=0 "未激活"
	s len=$l(ConditionStr,"^")
	i (UserId="")&&($d(%session)) s UserId=%session.Data("LOGON.USERID")
	f i=1:1:len
	{
		s oeoreId=$p(ConditionStr,"^",i)  //执行记录id
		s Condition=..GenToJoson("UserId^printType^queryTypeCode^oeoreId",UserId_"^"_printType_"^"_queryTypeCode_"^"_oeoreId) //操作条件
		Set EpisodeID=$p(^OEORD(+oeoreId),"^",1)
		s PatientId=$P(^PAADM(EpisodeID),"^",1)
		s arcimID =$p($g(^OEORD(+oeoreId,"I",$p(oeoreId,"||",2),1)),"^",2)
	    i arcimID'="" s arcimDesc= $P($G(^ARCIM(+arcimID,$p(arcimID,"||",2),1)),"^",2)
	    e  s arcimDesc=" "
		//s Content=..GenToJoson("EpisodeID^PatientId^oeoreId",EpisodeID_"^"_PatientId_"^"_oeoreId) //操作内容
		s Content=..GenToJoson("arcimDesc",arcimDesc) //操作内容
		b ;123
		Set PatEncryptLevel=##class(web.DHCCLCom).GetPatEncryptLevel("",EpisodeID)
        Set SecretCode=$p(PatEncryptLevel,"^",3)  //密级代码
		s ret=##class(web.DHCEventLog).EventLog(ModelName, Condition, Content,SecretCode)
		}
		q ret
}

/// 转换为json结构
/// w ##class(web.DHCCLCom).GenToJoson("test1^test2","a^b")
ClassMethod GenToJoson(ItemNameArr, ItemValueArr)
{
	n (ItemNameArr,ItemValueArr)
	s len=$l(ItemNameArr,"^")
	s obj=##class(%ArrayOfDataTypes).%New()
	for i=1:1:len
	{
	s ItemName=$p(ItemNameArr,"^",i)
	s ItemValue=$p(ItemValueArr,"^",i)
	d obj.SetAt(ItemValue,ItemName)
	}
	s ret=##class(Nur.JSON).Encode(obj)
	q ret
}

ClassMethod GenToJoson20150206(ItemNameArr, ItemValueArr)
{
	n (ItemNameArr,ItemValueArr)
	s len=$l(ItemNameArr,"^")
	s obj=##class(ext.util.JsonObject).%New()
	for i=1:1:len
	{
	s ItemName=$p(ItemNameArr,"^",i)
	s ItemValue=$p(ItemValueArr,"^",i)
	s ItemName=""_ItemName_""
	d obj.Put(ItemName,ItemValue)
	}
	s ret=obj.Json()
	d obj.Clear()
	q ret
}

ClassMethod IfValidDateTime(date, time)
{
	n (date, time)
	q:date="" 3
	q:time="" 4
	s date=$$$zdh(date,4)
	s ret=0
	i date>+$h s ret=1
	i date=+$h d
	.s time=$zth(time)
	.i time>$p($h,",",2) s ret=2
	q ret
}

/// 根据就诊号获取科室id
ClassMethod getLocIdByAdm(Adm As %String)
{
    q:Adm="" ""
    s LocId=$p(^PAADM(Adm),"^",4)
    q LocId
}

/// Creator:      songchao
/// CreateDate:   2018.12.11
/// Description:  获取医嘱大类
/// Input:       
/// Return:       
/// Other:       
/// Test:  ##class(%ResultSet).RunQuery("web.DHCCLCom","getOrdCat","")
Query getOrdCat(HospID) As websys.Query(ROWSPEC = "ORCAT_Rowid:%Integer,ORCAT_Desc:%String")
{
}

ClassMethod getOrdCatExecute(ByRef qHandle As %Binary, HospID) As %Status
{
	s ^tempsc("getOrdCat1")=$lb(HospID)	
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	if $d(%session)&&(HospID=""){
	 	;w "yiyuan:"_%session.Get("LOGON.HOSPID")
 		set HospID=%session.Get("LOGON.HOSPID")
	}
	s ordCatId="" f  s ordCatId=$o(^OEC("ORCAT",ordCatId)) q:ordCatId=""  d
	.s showFlag=##class(Nur.Interface.Other.BDPInterface).GetHospShowDataFlag("OEC_OrderCategory",ordCatId,HospID)
 	.q:showFlag'="Y"
	.s ordCatDesc = $p(^OEC("ORCAT",ordCatId),"^",2)
	.q:ordCatDesc=""
	.;q:(q'="")&&(ordCatDesc'[q)
	.d outOrdCat	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK	
outOrdCat
	set Data=$lb(ordCatId,ordCatDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

Query GetMedCat(HospID) As %Query(ROWSPEC = "rw,desc")
{
}

ClassMethod GetMedCatExecute(ByRef qHandle As %Binary, HospID) As %Status
{
	s ^tempsc("GetMedCat1")=$lb(HospID)
	Set repid=$I(^CacheTemp)
	if $d(%session)&&(HospID=""){
	 	;w "yiyuan:"_%session.Get("LOGON.HOSPID")
 		set HospID=%session.Get("LOGON.HOSPID")
	}
	i HospID=""  Set qHandle=$lb(0,repid,0)	Quit $$$OK
 	s ind=1
    if '$D(^DHCLONGSET("medcat",HospID))   Set qHandle=$lb(0,repid,0)	Quit $$$OK
 	s num=$L(^DHCLONGSET("medcat",HospID),"^")
 	f i=1:1:num
 	{   s prior=$P(^DHCLONGSET("medcat",HospID),"^",i)
	 	s rw=$P(prior,"|")
	 	s desc=$P(prior,"|",2)
	 	Do Outputcat2
	}
 	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Outputcat2
	set Data=$lb(rw,desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetMedCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMedCatExecute ]
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

ClassMethod GetMedCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMedCatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

}
