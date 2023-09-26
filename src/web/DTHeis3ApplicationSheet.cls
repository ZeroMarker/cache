Import SQLUser

Class web.DTHeis3ApplicationSheet Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Not ProcedureBlock ]
{

// w ##class(web.DTHeis3ApplicationSheet).SetHEISNameSpace()

ClassMethod SetHEISNameSpace()
{
	zn "DHC-HEIS"
}

ClassMethod SetMedDataNameSpace()
{
	zn "DHC-DATA"
	//ZN "MEDDATA"
}

ClassMethod SetWebSourceNameSpace()
{
	ZN "DHC-APP"
	//ZN "WEBSRC"
}

// w ##class(web.DTHeis3ApplicationSheet).GetPaadmInfo("87")

ClassMethod GetPaadmInfo(paadmdr As %String) As %String
{
     s paadmdr=$g(paadmdr)
     s Info=""
     s data=""
     d ##class(web.DTHeis3ApplicationSheet).SetHEISNameSpace()
     d ##class(Src.DTHEISInterface).GetPaadmInfo(.data,paadmdr)
     s Info=data
     d ##class(Src.DTHEISInterface).SetWebSourceNameSpace()
     q Info
}

// w ##class(web.DTHeis3ApplicationSheet).GetPatInfoByPaadm("87","")

ClassMethod GetPatInfoByPaadm(paadmdr As %String, tmid As %String) As %String
{
	s paadmdr=$g(paadmdr)
	s tmid=$g(tmid)	
	s ^test("zcl")=paadmdr_"^"_tmid
	s Info=""
	
	i tmid=""{		
		s Info="GetFromHIS"_"^"_##class(web.DTHeis3ApplicationSheet).GetPaadmInfo(paadmdr)		
	}elseif(tmid'=""){
		i '$d(^DTHEIS3MTestMaster(tmid)) s Info=-915 q
		s Info=^DTHEIS3MTestMaster(tmid)
		
		s Docdr=$p(Info,"^",24)
		s Locdr=$p(Info,"^",22)
		s otherInfo=##class(web.DTHeis3ApplicationSheet).GetPaadmInfo(paadmdr)		
		s Info=##class(web.DTHeis3ApplicationSheet).GetPatInfoByTmRowId(tmid)_"^"_$p(otherInfo,"^",7)_"^"
		_$p(otherInfo,"^",5)_"^"_$p(otherInfo,"^",4)_"^"_Locdr_"^"_Docdr_"^"_$p(otherInfo,"^",16)
		;住院类型desc_"^"_性别Desc_"^"_年龄_"^"_申请科室Dr_"^"_申请医生Dr_"^"_费别Name	
		
	}
	q Info
}

// w ##class(web.DTHeis3ApplicationSheet).GetLocName(27)

ClassMethod GetLocName(LocDR As %String) As %String
{
	s Info=""
	s data=""
	d ##class(web.DTHeis3ApplicationSheet).SetHEISNameSpace()
	//s Info=##class(Src.DTHEISInterface).GetLocName(LocDR)
	d ##class(Src.DTHEISInterface).GetLocName(.data,LocDR)
	s Info=data
	d ##class(Src.DTHEISInterface).SetWebSourceNameSpace()
	q Info
}

// w ##class(web.DTHeis3ApplicationSheet).GetOeorditminfo("240814")

ClassMethod GetOeorditminfo(oeorditemrowid As %String) As %String
{
	 s oeorditemrowid=$g(oeorditemrowid)
	 s Info=""
     d ##class(web.DTHeis3ApplicationSheet).SetHEISNameSpace()
     //s Info=##class(Src.DTHEISInterface).GetOeorditminfo(oeorditemrowid)
     d ##class(Src.DTHEISInterface).GetOeorditminfo(.data,oeorditemrowid)
     s Info=data
     d ##class(Src.DTHEISInterface).SetWebSourceNameSpace()
     q Info
}

// w ##class(web.DTHeis3ApplicationSheet).GetMainDiaginfo("76")

ClassMethod GetMainDiaginfo(ADMdr As %String) As %String
{
     s ADMdr=$g(ADMdr)
     s Info=""
     d ##class(web.DTHeis3ApplicationSheet).SetHEISNameSpace()
     d ##class(Src.DTHEISInterface).GetMainZD(.data,ADMdr)
     s Info=data
     d ##class(Src.DTHEISInterface).SetWebSourceNameSpace()
     q Info
}

// w ##class(web.DTHeis3ApplicationSheet).GenTmrowid("2","69","20")

ClassMethod GenTmrowid(tclscode As %String, Paadmdr As %String, Loc As %String) As %String
{
    s Paadmdr=$g(Paadmdr)
    s tclscode=$g(tclscode)
    s Loc=$g(Loc)
    s Info="",usingTMrowid=""
    

    s labcode=""
	i Loc '="" d
	.d ##class(web.DTHeis3ApplicationSheet).SetHEISNameSpace()
	.d ##class(Src.DTHEISBasicDict).GetCode(.data,Loc)
	.s labcode=$p(data,"^",1)
	.d ##class(Src.DTHEISInterface).SetWebSourceNameSpace()
	 
    i $o(^DTHEIS3MTestMasteri("PAADM",labcode,Paadmdr,""))=""  d   
    .d ##class(web.DTHeis3ApplicationSheet).SetHEISNameSpace()
	.d ##class(Src.DTHEISDiagnosis).MTestMasterAdd(.data,tclscode,labcode)
	
	.s Info=data
    .d ##class(Src.DTHEISInterface).SetWebSourceNameSpace()
    e  d
    .s tmid="" f  s tmid=$o(^DTHEIS3MTestMasteri("PAADM",labcode,Paadmdr,tmid),-1)  q:tmid=""  d   
    ..i (($p(^DTHEIS3MTestMaster(tmid),"^",2)=tclscode)&&(tclscode'=""))  d
    ..i ($p(^DTHEIS3MTestMaster(tmid),"^",43)="")&&($p(^DTHEIS3MTestMaster(tmid),"^",11)'="")  d   
    ...s usingTMrowid=tmid
    ..else  d
    ...if (($p(^DTHEIS3MTestMaster(tmid),"^",43)'="")&&$p($g(^DTHEIS3MTestMaster(tmid)),"^",43)>=1) d   
    .i usingTMrowid'="" d
    ..s Info=usingTMrowid 
    .else  d   
    ..d ##class(web.DTHeis3ApplicationSheet).SetHEISNameSpace()
    ..d ##class(Src.DTHEISDiagnosis).MTestMasterAdd(.data,tclscode,labcode)
    ..s Info=data
    ..d ##class(Src.DTHEISInterface).SetWebSourceNameSpace()
    
    q Info
}

// w ##class(web.DTHeis3ApplicationSheet).ShowTmrowid("2","69","")

ClassMethod ShowTmrowid(tclscode As %String, Paadmdr As %String, Loc As %String) As %String
{
	s Paadmdr=$g(Paadmdr)
    s tclscode=$g(tclscode)
    s Loc=$g(Loc)
    s Info=""
    s labcode="" f  s labcode=$o(^DTHEIS3ClassDicti("CODE",labcode)) q:labcode=""  d
    .s classDr=0 f  s classDr=$o(^DTHEIS3ClassDicti("CODE",labcode,tclscode,classDr)) q:classDr=""  d   
    .. i $o(^DTHEIS3MTestMasteri("PAADM",labcode,Paadmdr,""))="" s Info="" 
    ..e  d
    ...s tmid="" f  s tmid=$o(^DTHEIS3MTestMasteri("PAADM",labcode,Paadmdr,tmid),-1)  q:tmid=""  d   
    ....i (($p(^DTHEIS3MTestMaster(tmid),"^",2)=tclscode)&&(tclscode'=""))  d    
    ....i ($p(^DTHEIS3MTestMaster(tmid),"^",43)="")&&($p(^DTHEIS3MTestMaster(tmid),"^",11)'="")  d
    .....s Info=tmid
    q Info
}

// w ##class(web.DTHeis3ApplicationSheet).GetUserNameBySSUserRowId("20870")

ClassMethod GetUserNameBySSUserRowId(rowId As %String) As %String
{
	i rowId="" q -901 
	i $d(^SSU("SSUSR",rowId)) d
	.s userName=$p(^SSU("SSUSR",rowId),"^",2)
	q $g(userName)
}

// w ##class(web.DTHeis3ApplicationSheet).GetPatInfoByTmRowId("107")

ClassMethod GetPatInfoByTmRowId(rowId As %String) As %String
{
     s rowId=$g(rowId)
     s Info=""
     s data=""
     d ##class(web.DTHeis3ApplicationSheet).SetHEISNameSpace()    
     d ##class(Src.DTHEISDiagnosis).GetMTestMasterPatInfoByRowId(.data,rowId)
     s Info=data
     d ##class(Src.DTHEISInterface).SetWebSourceNameSpace()    
     q Info
}

ClassMethod UpdatePatInfo(Info As %String, rowId As %String) As %String
{
     s rowId=$g(rowId)
     s Info=$g(Info)
     s data=""
     d ##class(web.DTHeis3ApplicationSheet).SetHEISNameSpace()    
     d ##class(Src.DTHEISDiagnosis).MTestMasterPatInfoUpdate(.sqlcode,Info,rowId)
     s data=sqlcode
     s labCode="002"
     d ##class(Src.DTHEISCompile).UpdateLabCodeByRowid(.sqlcode,rowId,labCode)
     d ##class(Src.DTHEISInterface).SetWebSourceNameSpace()
     q data
}

// w ##class(web.DTHeis3ApplicationSheet).UpdateAppInfo("","1")

ClassMethod UpdateAppInfo(Info As %String, rowId As %String) As %String
{
     s rowId=$g(rowId)
     s Info=$g(Info)
     s data=""
     d ##class(web.DTHeis3ApplicationSheet).SetHEISNameSpace()    
     d ##class(Src.DTHEISDiagnosis).MTestMasterAppInfoUpdate(.sqlcode,Info,rowId)
     s data=sqlcode
     d ##class(Src.DTHEISInterface).SetWebSourceNameSpace()
     q data
}

// w ##class(web.DTHeis3ApplicationSheet).GetAppInfoByTmRowId("30")

ClassMethod GetAppInfoByTmRowId(rowId As %String) As %String
{
     s rowId=$g(rowId)
     s Info=""
     d ##class(web.DTHeis3ApplicationSheet).SetHEISNameSpace()    
     d ##class(Src.DTHEISDiagnosis).GetMTestMasterAppInfoByRowId(.data,rowId)
     s Info=data
     d ##class(Src.DTHEISInterface).SetWebSourceNameSpace()
     q Info
}

ClassMethod UpdateStatus(Info As %String, rowId As %String) As %String
{
     s rowId=$g(rowId)
     s data=""
     d ##class(web.DTHeis3ApplicationSheet).SetHEISNameSpace()
     d ##class(Src.DTHEISDiagnosis).MTestMasterStatusUpdate(.sqlcode,Info,rowId)
     s data=sqlcode
     d ##class(Src.DTHEISInterface).SetWebSourceNameSpace()
     q data
}

// w ##class(web.DTHeis3ApplicationSheet).GetStatusByTmRowId("113")

ClassMethod GetStatusByTmRowId(rowId As %String) As %String
{
     s rowId=$g(rowId)
     s Info=""
     s data=""
     d ##class(web.DTHeis3ApplicationSheet).SetHEISNameSpace()
     d ##class(Src.DTHEISDiagnosis).GetMTestMasterStatusByRowId(.data,rowId)
     s Info=data
     d ##class(Src.DTHEISInterface).SetWebSourceNameSpace()
     q Info
}

// w ##class(web.DTHeis3ApplicationSheet).TestMasterAdd("1")

ClassMethod TestMasterAdd(classDr As %String) As %String
{
     s classDr=$g(classDr)
     s Info=""
     s data=""
     d ##class(web.DTHeis3ApplicationSheet).SetHEISNameSpace()
     d ##class(Src.DTHEISDiagnosis).MTestMasterAdd(.data,classDr)
     s Info=data
     d ##class(Src.DTHEISInterface).SetWebSourceNameSpace()
     q Info
}

// w ##class(web.DTHeis3ApplicationSheet).TestMasterDel("4")

ClassMethod TestMasterDel(rowId As %String) As %String
{
     s rowId=$g(rowId)
     s Info=""
     s data=""
     d ##class(web.DTHeis3ApplicationSheet).SetHEISNameSpace()
     d ##class(Src.DTHEISDiagnosis).MTestMasterDel(.data,rowId)
     s Info=data
     d ##class(Src.DTHEISInterface).SetWebSourceNameSpace()
     q Info
}

// w ##class(web.DTHeis3ApplicationSheet).ChangeAppStatusByOrderDoc("1","87")

ClassMethod ChangeAppStatusByOrderDoc(orderDr As %String, docDr As %String) As %String
{
	s orderDr=$g(orderDr)
	s docDr=$g(docDr)
	i (orderDr="")||(docDr="") q -901
	
	s xdate=$zd(+$h,4)
	s SQLCODE=##class(web.DHCRisApplicationBill).SaveAppBill("", orderDr, xdate, docDr, "", "") 
	q SQLCODE
}

// w ##class(web.DTHeis3ApplicationSheet).GetAllInfoByTmRowId("1")

ClassMethod GetAllInfoByTmRowId(rowId As %String) As %String
{
     s rowId=$g(rowId)
     s Info=""
     s data=""
     d ##class(web.DTHeis3ApplicationSheet).SetHEISNameSpace()
     d ##class(Src.DTHEISDiagnosis).GetMTestMasterByRowId(.data,rowId)
     s Info=data
     d ##class(Src.DTHEISInterface).SetWebSourceNameSpace()
     q Info
}

ClassMethod ChangeDate3to4(strDate As %String) As %String
{
	// 格式2006-12-1 to 1/12/2006
	s strDate=$zdh(strDate,3)
	q $zd(strDate,4)
}

ClassMethod ChangeDate4to3(strDate As %String) As %String
{
	// 格式1/12/2006 to 2006-12-1
	s strDate=$zdh(strDate,4)
	q $zd(strDate,3)
}

Query QueryTime() As %Query(ROWSPEC = "Name:%String")
{
}

ClassMethod QueryTimeExecute(ByRef qHandle As %Binary) As %Status
{
 Set repid=$I(^CacheTemp) 
 s ind=1
 
 f i=0:1:23 d
 .f j=0:1:59 d
 ..Do OutQueryTime
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutQueryTime
 set Data=$lb(i_":"_j)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod QueryTimeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryTimeExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
	 
 // if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod QueryTimeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryTimeExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

// w ##class(web.DTHeis3ApplicationSheet).GetCurrentStatus("76")

ClassMethod GetCurrentStatus(paadmdr)
{
   s paadmdr=$g(paadmdr)
   s Info=""
   d ##class(web.DTHeis3ApplicationSheet).SetHEISNameSpace()    
   s Info=##class(Src.DTHEISInterface).GetCurrentStatus(paadmdr)
   d ##class(Src.DTHEISInterface).SetWebSourceNameSpace()
   q Info
}

// d ##class(%ResultSet).RunQuery("web.DTHeis3ApplicationSheet","QueryCareProv",922)

Query QueryCareProv(Locrowid As %String) As %Query(ROWSPEC = "desc:%String,CareDR:%String,DocDR:%String,userCode:%String")
{
}

ClassMethod QueryCareProvExecute(ByRef qHandle As %Binary, Locrowid As %String) As %Status
{
	s ^TempLocid=Locrowid
	Set repid=$I(^CacheTemp)
	i $g(^DHCPisGetNameSet)="" s ^DHCPisGetNameSet="Desc"
	s ind=1
	s resrowid=0 f  s resrowid=$o(^RB("RES",0,"CTLOC",Locrowid,resrowid)) q:(resrowid="")  d
	.s ResInfo=^RB("RES",resrowid)
	.s CareProvrowid=$p(ResInfo,"^",2)
	.s ssusercode=""
	.i CareProvrowid'=""  d
	..s ssuserrowid=$o(^SSU("SSUSR",0,"CTPCP",CareProvrowid,0)) //SS_User:^SSU("SSUSR",0,"CTPCP",{SSUSR_CareProv_DR},{SSUSR_RowId}) 
	..i ssuserrowid'="" s ssusercode=$p(^SSU("SSUSR",ssuserrowid),"^",1)
	..i ^DHCPisGetNameSet="ID" d
	...s CareProvDesc=$p(^CTPCP(CareProvrowid,1),"^",3) //CT_CareProv
	..else  d
	...s CareProvDesc=$p(^CTPCP(CareProvrowid,1),"^",2) //CT_CareProv
	..s DocDR = 0
	..s DocDR = $o(^SSU("SSUSR",0,"CTPCP",CareProvrowid,DocDR)) q:(DocDR="") //SS_User:^SSU("SSUSR",0,"CTPCP",{SSUSR_CareProv_DR},{SSUSR_RowId}) 
 	..Do OutCareProv 
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutCareProv
	set Data=$lb(CareProvDesc,CareProvrowid,DocDR,ssusercode)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryCareProvFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryCareProvExecute ]
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

ClassMethod QueryCareProvClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryCareProvExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

// w ##class(web.DTHeis3ApplicationSheet).GetBiaobenByTmRowId(6)

ClassMethod GetBiaobenByTmRowId(tmRowid As %String) As %String
{
	s tmRowid=$g(tmRowid)
	i tmRowid="" q

	s Info1=1_$C(1)_"髂后"_"~"_2_$C(1)_"髂前"_"~"_3_$C(1)_"额后"_"~"_4_$C(1)_"脊突"_"~"_5_$C(1)_"胸骨"
	q Info1
}

// w ##class(web.DTHeis3ApplicationSheet).GetJianyan("0000000081")

ClassMethod GetJianyan(Regnum As %String) As %String
{
   s Regnum=$g(Regnum)
   s Info=""
   d ##class(web.DTHeis3ApplicationSheet).SetHEISNameSpace()    
   s Info=##class(Src.DTHEISInterface).GetJianyan(Regnum)
   d ##class(Src.DTHEISInterface).SetWebSourceNameSpace()
   q Info
}

// d ##class(%ResultSet).RunQuery("web.DTHeis3ApplicationSheet","QueryStudyByPaadmDR","107","87","","")

Query QueryStudyByPaadmDR(paadmdr As %String, LocDr As %String, StDate As %String, EndDate As %String) As %Query(ROWSPEC = "TRegNo:%String,Tpathid:%String,TItemName:%String,TItemDate:%String,TItemStatus:%String,TOEOrderDr:%String,TLocName:%String,TreplocDr:%String,TOpenRpt:%String,TOpenAllRpt:%String,TRptRowid:%String")
{
}

ClassMethod QueryStudyByPaadmDRExecute(ByRef qHandle As %Binary, paadmdr As %String, LocDr As %String, StDate As %String, EndDate As %String) As %Status
{

   Set repid=$I(^CacheTemp) 
	Set qHandle=$lb(0,repid,0)
	s ind=1
	
	s paadmdr=$g(paadmdr)
	i (paadmdr="") s paadmdr=%request.Get("EpisodeID")
	s StDate=$p(StDate,$c(0))
	s EndDate=$p(EndDate,$c(0))
	d ##class(web.DTHeis3ApplicationSheet).SetHEISNameSpace()
    s sysid="" f  s sysid=$o(^User.DTHEISSYSTEMSETD(sysid))  q:sysid=""  d
    .i '$d(^User.DTHEISSYSTEMSETD(sysid)) q
	.s sysInfo=##class(User.DTHEISSYSTEMSET).%OpenId(sysid)
	.s labCode=sysInfo.SYSLABCODE
	.s replocdr=sysInfo.SYSDEPTCODE
	.d ##class(Src.DTHEISInterface).SetWebSourceNameSpace()
	.q:labCode=""
	.s papatmasmdr=$p(^PAADM(paadmdr),"^",1)      
    .s RegNo=$p(^PAPER(papatmasmdr,"PAT",1),"^",1)  
	.s pathid="",strOrderName="",strDate = "",ItemStatus="",oeorditemdr="",LocName=""
	.s RptNum = 0,OrderRowid="",RptRowid=""
	.d ##class(web.DTHeis3ApplicationSheet).SetHEISNameSpace()
	.s TmRowid="" f  s TmRowid=$o(^DTHEIS3MTestMasteri("REGNO",labCode,RegNo,TmRowid),-1) q:(TmRowid="")  d 
	..i '$d(^DTHEIS3MTestMaster(TmRowid)) q
    ..d ##class(Src.DTHEISDiagnosis).GetMTestMasterByRowId(.data,TmRowid)
    ..s tmInfo=data
 	..d ##class(Src.DTHEISInterface).SetWebSourceNameSpace()
    ..s oeorditemdr=$p(tmInfo,"^",22)
  	..q:oeorditemdr=""
    ..s OrderRowid=$p(oeorditemdr,"||",1),itemsub=$p(oeorditemdr,"||",2)
    ..s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2) 
	..s strOrderName=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)
    ..s ItemStatus=$P(tmInfo,"^",15)
    ..i ItemStatus="" q
    ..i ItemStatus="1"  d
	...s Sname = "已申请"
    ..e  i ItemStatus="3"  d
	...s Sname = "已登记"
	..e  i ItemStatus="5"  d
	...s Sname = "已采图"
	..e  i ItemStatus="6" d
	...s Sname = "已录入诊断"
	..e  i ItemStatus="7" d
	...s Sname = "已确认报告"
	..e  i ItemStatus="8" d
	...s Sname = "已打印报告"
	..e  i ItemStatus="9" d
	...s Sname = "报告已归档"
	..//e  d
	...//s sname = "申请"
    ..s pathid=$P(tmInfo,"^",1)
   
	..//s RegNo=$p(tmInfo,"^",25)
	..//s admno=$p(tmInfo,"^",14)
	..s LocName=$p(tmInfo,"^",7)
	..s strDate=$p(tmInfo,"^",2)
	..i strDate'="" s strDate=$zdh(strDate,3)
	..s strDate=$zd(strDate,3)
	..s yizhuhao=$p(tmInfo,"^",22)
	..i (yizhuhao'=oeorditemdr) q
	..i pathid="" d
	...//s RptClsDesc="报告未发布"
	...s pathid="尚未登记"
	...Do OutStudy1
	..e  d
	...d ##class(web.DTHeis3ApplicationSheet).SetHEISNameSpace()
	...i $d(^DTHEIS3MReporti("HEMEID",labCode,pathid)) d
	....s RptRowid=0 f  s RptRowid=$o(^DTHEIS3MReporti("HEMEID",labCode,pathid,RptRowid)) q:RptRowid=""  d
	.....s ItemStatus=$P(tmInfo,"^",15)
	.....i ItemStatus>=7 Do OutStudy
	.....i ItemStatus<7 d
	......Do OutStudy1
	...e  d
	....Do OutStudy1
	
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutStudy
	d ##class(Src.DTHEISInterface).SetWebSourceNameSpace()
	set Data=$lb(RegNo,pathid,strOrderName,strDate,Sname,oeorditemdr,LocName,replocdr,"Report","AllReport",RptRowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
OutStudy1
	d ##class(Src.DTHEISInterface).SetWebSourceNameSpace()
	set Data=$lb(RegNo,pathid,strOrderName,strDate,Sname,oeorditemdr,LocName,replocdr,"","AllReport",RptRowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryStudyByPaadmDRFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryStudyByPaadmDRExecute ]
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

ClassMethod QueryStudyByPaadmDRClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryStudyByPaadmDRExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

// w ##Class(web.DTHeis3ApplicationSheet).GetAppItems("2","107")

// function:获取病人做过的此类申请信息，包括已发送和正在填写的

// other：拼成json串

ClassMethod GetAppItems(tclscode As %String, Paadmdr As %String) As %String
{
		 
	 
	s Paadmdr=$g(Paadmdr)
    s tclscode=$g(tclscode)
    s Info="{AppItems:[" ,Pname="",status="",statusDesc="",appDate="",appTime="",appLocDR=""
  
    s labcode="" f  s labcode=$o(^DTHEIS3MTestMasteri("PAADM",labcode)) q:(labcode="")  d 
  	.s tmrowid=0 f  s tmrowid=$o(^DTHEIS3MTestMasteri("PAADM",labcode,Paadmdr,tmrowid)) q:tmrowid=""  d  
  	..i '$d(^DTHEIS3MTestMaster(tmrowid)) q        
    ..i ((tclscode'="")&&($p(^DTHEIS3MTestMaster(tmrowid),"^",2)=tclscode))  d    
    ...i (($p(^DTHEIS3MTestMaster(tmrowid),"^",11)'=""))  d
    ....s Pname=$p($g(^DTHEIS3MTestMaster(tmrowid)),"^",11)
    ....s appDate=$zd($p(^DTHEIS3MTestMaster(tmrowid),"^",19),3)
    ....s appTime=$zt($p(^DTHEIS3MTestMaster(tmrowid),"^",20),2)
    ....s appLocDR=$p($g(^DTHEIS3MTestMaster(tmrowid)),"^",21)   
    ....;i appLocDR'="" s appLocDR=##class(web.DHCPisApplicationSheet).GetLocName(appLocDR)
    ....s status=$p($g(^DTHEIS3MTestMaster(tmrowid)),"^",43)   
    ....i status="" s statusDesc="正在填写"    
    ....e  s statusDesc="已发送"    
    ....i ($e(Info,$l(Info))="[") d
    .....s Info=Info_"{Pname:'"_Pname_"',tmrowid:'"_tmrowid_"',statusDesc:'"_statusDesc_"',appDate:'"_appDate_"',appTime:'"_appTime_"',appLocDR:'"_appLocDR_"'}"
    ....else  d
    .....s Info=Info_",{Pname:'"_Pname_"',tmrowid:'"_tmrowid_"',statusDesc:'"_statusDesc_"',appDate:'"_appDate_"',appTime:'"_appTime_"',appLocDR:'"_appLocDR_"'}"  
    
    s Info=Info_"]}"
    i Info="{AppItems:[" s Info="{AppItems:[]}"
    q Info
}

ClassMethod EvalJSON(instr As %String) As %String
{
	;w ##class(ext.util.String).EvalJSON("a\")
	s mystr = instr
	
	q:(mystr="") mystr
	
	s mystr = ..Replace(mystr,"\", "\\")
	
	s mystr = ..Replace(mystr,"'", "\'")
	
	s mystr = ..Replace(mystr,$c(13), "")
	
	s mystr = ..Replace(mystr,$c(10), "")
	
	q mystr
}

/// 要求被替换的内容不能=""
ClassMethod Replace(instr As %String, substr As %String, replacement As %String) As %String
{
	;
	q:(substr="") instr
	;q:(replacement="") instr
	q:'($l(instr,substr)>1) instr
	
	s mylen=$l(instr,substr)
	for myIdx=1:1:mylen {
		s myary(myIdx)=$p(instr,substr, myIdx)
	}
	
	s mystr=""
	s myIdx=""
	s myIdx=$o(myary(myIdx))
	while (myIdx'=""){
		s myrepstr=""
		i ($o(myary(myIdx))=""){
			s myrepstr=myary(myIdx)
		}else{
			s myrepstr=myary(myIdx)_replacement
		}
		
		i (mystr=""){
			s mystr=myrepstr
		}else{
			s mystr=mystr_myrepstr
		}
		
		s myIdx=$o(myary(myIdx))
		q:(myIdx="")
	}
	
	q mystr
}

// w ##Class(web.DTHeis3ApplicationSheet).GetOrder("2","","","I")

ClassMethod GetOrder(clscode As %String, dept As %String, scode As %String, Ptype As %String) As %String
{
	s clscode=$g(clscode)
	s dept=$g(dept)
	s scode=$g(scode)
	s Ptype=$g(Ptype)
	s resultString="{rows:["
	
	s IniId="" f  s IniId=$o(^DTHEIS3IniDict(IniId))  q:IniId=""  d
	.i '$d(^DTHEIS3IniDict(IniId))  q
	.s IniName=$p(^DTHEIS3IniDict(IniId),"^",3)
	.s code=$p(IniName,";",1)
	.s PatientType=$p(IniName,";",2)
	.i (code=clscode)&(PatientType[Ptype) d
	..s NAME=$p(IniName,";",3)
	..s VALUE=$p(^DTHEIS3IniDict(IniId),"^",4)
	..s tmp="{NAME"_":"_"'"_..EvalJSON(NAME)_"'"_","_"VALUE"_":"_"'"_VALUE_"'"_"}" 
	..i resultString = "{rows:[" d
	...s resultString = resultString_tmp
	..e  d
   	...s resultString = resultString_","_tmp
	
	s resultString = resultString_"]}"
	q resultString
}

ClassMethod InsertOrderItem(adm As %String, OrdItemStr As %String, User As %String, Loc As %String, TMrowid As %String, INIid As %String, Locdr As %String) As %String
{
	
	s adm=$g(adm)
	s OrdItemStr=$g(OrdItemStr)
	s User=$g(User)
	s Loc=$g(Loc)
	s TMrowid=$g(TMrowid)
	s INIid=$g(INIid)
	s ^test("11-24")=adm_";"_OrdItemStr_";"_User_";"_Loc_";"_TMrowid_";"_INIid_";"_Locdr
	s Doc="" ,rtnValue="",pattype="",orderitemDr="",rscodedr="",tclscode="",tclscode2="",iniRowid="",iniInfo="",codeValue="",frostyn=0 ,iflag=0 , eflag=0,billInfo=""
	s Doc=$P($g(^SSU("SSUSR",User)),"^",14)
	;s OrdItemStr=OrdItemStr1_$zd($p($h,",",1),4)_"^"_$zt($p($h,",",2),2)_OrdItemStr2
	s pattype=$p(^PAADM(adm,1),"^",7) //PAC_AdmReason ,之前的取得6，貌似都错了
	s orderitemDr=INIid
	s priceinfo=$$GetOrderPrice^DHCPRICE(pattype,"",orderitemDr,+$h,"","","","")
	s Price=$p(priceinfo,"^",1)
    s total=Price*1
    
	
	s $p(OrdItemStr,"^",1)=INIid	
	s $p(OrdItemStr,"^",3)=$O(^OECPR(0,"Code","NORM",0))
	s $p(OrdItemStr,"^",4)=$zd($p($h,",",1),4)
	s $p(OrdItemStr,"^",5)=$zt($p($h,",",2),2)
	s $p(OrdItemStr,"^",7)=total		
	//s $p(OrdItemStr,"^",8)=$$GetRecloc^DHCDocOrderCommonNew(adm,INIid)
	s $p(OrdItemStr,"^",8)=Locdr
	s $p(OrdItemStr,"^",9)=pattype
	s $p(OrdItemStr,"^",20)=1
	s ^test("123015")=OrdItemStr
	ts
	d ##class(web.DTHeis3ApplicationSheet).SetHEISNameSpace()
	s rtn=##class(Src.DTHEISInterface).SaveOrderItems(adm,OrdItemStr,User,Loc,Doc) 	//调用公司接口，插入医嘱
	
	i (rtn="0" || rtn="-999") TRollback  q rtn
	tc
	s rtnValue=$p(rtn,"*",2)
	s ^test("1230")=rtnValue	
	s billInfo=TMrowid_"^"_rtnValue_"^1^"_Price_"^"_total_"^"_Loc_"^^^^^1^^"_INIid
		
	d ##class(Src.DTHEISDiagnosis).MTestMasterOrderUpdate(.sqlcode,rtnValue,TMrowid)	
	//zcl add 2015/10/13
	s LabCode=""
	d ##class(Src.DTHEISInterface).GetLabCode(.data,rtnValue)
	s LabCode=data
	i (LabCode'="") d
	.d ##class(Src.DTHEISCompile).UpdateLabCodeByOrderdr(.sqlcode,rtnValue,LabCode)
	d ##class(Src.DTHEISDiagnosis).MTestMasterStatusUpdate(.sqlcode,1,TMrowid)
	d ##class(Src.HEISRegister).UpdateStatus(.sqlcode,1,TMrowid)
	d ##class(Src.HEISRegister).BillItemAdd(.rowid,billInfo)
	
	d ##class(Src.DTHEISInterface).SetWebSourceNameSpace() 

	q rtnValue
}

// 得到信息是否保存标志,adm

// w ##class(web.DTHeis3ApplicationSheet).Getflag("61")

ClassMethod Getflag(TMrowid As %String) As %String
{
  s rowid=TMrowid
  s flag="N"
  s ret=$p($g(^DTHEIS3MTestMaster(rowid)),"^",9)
  i (ret'="") d
  .s flag="Y"  
 
  q flag
}

// w ##class(web.DTHeis3ApplicationSheet).GetStatusByRowId("61")

ClassMethod GetStatusByRowId(tmrowId As %String) As %String
{
	 s tmrowId=$g(tmrowId)
     s Info=""   
     d ##class(web.DTHeis3ApplicationSheet).SetHEISNameSpace()
     d ##class(Src.DTHEISDiagnosis).GetMTestMasterStatusByRowId(.data,tmrowId)
     s Info=data
     d ##class(Src.DTHEISInterface).SetWebSourceNameSpace() 
     q Info
}

// w ##Class(web.DTHeis3ApplicationSheet).getloc("76","10332||1")

ClassMethod getloc(adm As %String, IniId As %String) As %String
{
	s LOcdr="",locString=""
	s adm=$g(adm)
	s IniId=$g(IniId)
	s Loc=$$GetRecloc^DHCDocOrderCommonNew(adm,IniId)
	q Loc
}

// w ##class(web.DTHeis3ApplicationSheet).GetInPatStatus(69)

// 返回不是A的话，代表住院病人出院

ClassMethod GetInPatStatus(paadmdr As %String) As %String
{
	s paadmdr=$g(paadmdr)
	i paadmdr="" q -901
	i '$d(^PAADM(paadmdr)) q -911
	
	s status=$p(^PAADM(paadmdr),"^",20)  
	s admType=$p(^PAADM(paadmdr),"^",2)	
	i (admType="I") q status
	e  q ""
}

// w ##class(web.DTHeis3ApplicationSheet).GetRecDept()

ClassMethod GetRecDept(tclscode As %String) As %String
{
	
	s hospitalID=%session.Get("LOGON.HOSPID")
	//s hospitalID=""	
   	d ##class(web.DTHeis3ApplicationSheet).SetHEISNameSpace()
	Set result = ##class(%ResultSet).%New()
    Set result.ClassName = "Src.HEIS3SystemInit"
    Set result.QueryName = "QueryGetSystem"
    s count=""     
    Do result.Execute(.count,-1,-1,"ASC","^") 
         
    s count = 0	
 	//构造json数据
 	s resultString="{rows:["
 	while(result.Next())
 	{
	
	 s hsID=result.Data("SYS_AUTHORIZED_KEY")
	 //zw hsID	
	 continue:((hospitalID'="")&&(hospitalID'=hsID))
	 continue:(hospitalID'=hsID)  
	 s VALUE=result.Data("SYS_DEPT_CODE"),NAME=""	
	 d ##class(Src.HEIS3SystemInit).GetLocNameByCode(.NAME,VALUE)
	 s NAME=$p(NAME,"*",1)	 
	
	 s tmp="{NAME"_":"_"'"_..EvalJSON(NAME)_"'"_","_"VALUE"_":"_"'"_VALUE_"'"_"}" 
	 i resultString = "{rows:[" d
	 .s resultString = resultString_tmp
	 e  d
	 .s resultString = resultString_","_tmp
					
	 s count=count+1	
	}	
	 d result.Close()
	s resultString = resultString_"]}"
	d ##class(Src.DTHEISInterface).SetWebSourceNameSpace()   
	q resultString  	//返回数据
}

// w ##class(web.DTHeis3ApplicationSheet).GetTmLocdr(12)

// 取test_master表接收科室

ClassMethod GetTmLocdr(tmid As %String) As %String
{
	s data=""
	q:tmid="" data
	q:'$d(^DTHEIS3MTestMaster(tmid)) data
	s data=$p(^DTHEIS3MTestMaster(tmid),"^",32)
	q data
}

ClassMethod UpdateTmLocDr(Info As %String, rowId As %String) As %String
{
	 s rowId=$g(rowId)
     s Info=$g(Info)
     s data=""   
     d ##class(web.DTHeis3ApplicationSheet).SetHEISNameSpace()
     d ##class(Src.HEISRegister).UpdateTmLocDr(data,Info,rowId)
     d ##class(Src.DTHEISInterface).SetWebSourceNameSpace()
     q data
}

// w ##class(web.DTHeis3ApplicationSheet).GetHosptialDesc(87)

ClassMethod GetHosptialDesc(locdr As %String) As %String
{
	 s locdr=$g(locdr)
     s data=""
     d ##class(web.DTHeis3ApplicationSheet).SetHEISNameSpace()
     s data=##class(Src.DTHEISInterface).GetHosptialDesc(locdr)
     d ##class(Src.DTHEISInterface).SetWebSourceNameSpace()
     q data
}

}
