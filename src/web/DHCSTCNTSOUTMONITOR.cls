Import sqluser

/// 门诊医嘱
Class web.DHCSTCNTSOUTMONITOR Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// w ##class(web.DHCSTCNTSOUTMONITOR).GetAdmPrescList(1,30,"2021-05-30 - 2021-07-07^106^0000000645^false^^Y","jqGrid")
/// style 为空时走ext,为jq时走jqF
ClassMethod GetAdmPrescList(stpage, limit, input, style = "") As %String
{
	//s ^zzdt("GetAdmPrescList")=$lb(stpage, limit, input, style)
	q:(input="")&&(style'="") ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
	i style="" d
	.s endpage=stpage+limit  //结束行
	.s stpage=stpage+1 //开始行
	i style'="" d
	.s page=stpage
	.s stpage=((stpage-1)*limit)+1 //开始行
	.s endpage=page*limit  //结束行
	s pid=##class(web.DHCSTCNTSCOMMON).GetPHCNTSPID()
	i style="" d
	.s stdate=$p(input,"^",1)
	.s stdate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(stdate)
	.s enddate=$p(input,"^",2)
	.s enddate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(enddate)
    .s phalocdr=$p(input,"^",3)
    .s patID=$p(input,"^",4)
    .s onlyadt=$p(input,"^",5)
    .s adtwindesc=$p(input,"^",6)
    e  d 
    .s daterange=$p(input,"^",1)
	.s stdate=$p(daterange," - ",1)
	.s stdate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(stdate)
	.s enddate=$p(daterange," - ",2)
	.s enddate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(enddate)
    .s phalocdr=$p(input,"^",2)
    .s patID=$p(input,"^",3)
    .s onlyadt=$p(input,"^",4)
    .s adtwindesc=$p(input,"^",5)
    .s autoAudiFlag=$p(input,"^",6)
    s h=0
    f date=stdate:1:enddate  d
    .q:patID'=""
    .s ord=""
    .f  s ord=$o(^OEORDi(0,"ItemDate",date,ord)) q:ord=""  d
    ..s adm=$p(^OEORD(ord),"^",1)
    ..s type=$p(^PAADM(adm),"^",2)
    ..q:(type'="O")&&(type'="E")
    ..d getdata
   
    i patID'="" d
    .s papmidr=$o(^PAPERi("PAPMI_PatNo",patID,""))
    .q:papmidr=""
    .s admtype=""
	.f  s admtype=$o(^PAPERdr(papmidr,"ADM",admtype)) q:admtype=""  d 
	..q:admtype="I" ;过滤住院
	..s type=admtype
	..s adm="",exit=""
	..f  s adm=$o(^PAPERdr(papmidr,"ADM",admtype,adm),-1) q:(adm="")||(exit="1")  d 
	...s ord=$o(^OEORD(0,"Adm",adm,"")) 
	...q:ord=""	 ;对应就诊日期下该病人ord
	...f date=stdate:1:enddate  d
	....d getdata
	
	
	s reasonStr=""
	s passResult="Y"
	s (auditUserId,adviceTxt,facTxt,phNote,groupId,ordItmId)=""
	s appType="OA"
	s prescIndex=""
    f  s prescIndex=$o(^TMP("dhcpha","DHCSTCNTSOUTMONITOR","GetAdmPrescList",pid,"PreAdtPresc",prescIndex)) q:prescIndex=""  d
	.s indexData=$g(^TMP("dhcpha","DHCSTCNTSOUTMONITOR","GetAdmPrescList",pid,"PreAdtPresc",prescIndex))
	.s ordItmId=$p(indexData,"^",2)
	.s inputStr=passResult_"^"_auditUserId_"^"_adviceTxt_"^"_facTxt_"^"_phNote_"^"_groupId_"^"_ordItmId_"^"_appType
	.s retVal=##class(web.DHCSTCNTSOUTMONITOR).SaveOPAuditResult(reasonStr,inputStr,1) 
	
    q:(h=0)&&(style="") ##class(web.DHCSTEXTCOMMON).GetNoJson()
	q:(h=0) ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
	s maxrow=h
    i endpage>maxrow s endpage=maxrow
    s count=0
    s h="",startString=""
    f  s h=$o(^TMP("dhcpha","DHCSTCNTSOUTMONITOR","GetAdmPrescList",pid,"PrescAudit",h)) q:h=""  d
    .s data=^TMP("dhcpha","DHCSTCNTSOUTMONITOR","GetAdmPrescList",pid,"PrescAudit",h)
    .s patno=$p(data,"^",1)
    .s patloc=$p(data,"^",2)
    .s prescno=$p(data,"^",3)
    .s skintest=##class(PHA.COM.Order).PrescSkinTest(prescno)
    .s warningmsg=""
    .i skintest="-1" d
    ..s warningmsg="皮试()"
    .e  i skintest="-2" d
    ..s warningmsg="皮试(+)"
    .e  i skintest="-3" d
    ..s warningmsg="皮试()"
    .s warningmsg = ..Get(warningmsg)
    .s adm=$p(data,"^",4)
    .s orditem=$p(data,"^",5)
    .s papmi=$p(^PAADM(adm),"^",1)
    .s patInfo = ##class(PHA.COM.Order).GetPatInfo(adm)
	.s patname=$p(patInfo, "^", 3) ;患者姓名
	.s patsex=$p(patInfo, "^", 4 ) ;姓别
	.s patno=$p(patInfo, "^", 1)
	.s patage=$p(patInfo, "^", 5)  ;年龄
    .s patbilltype=$p(##class(PHA.COM.Order).OeoriAdmReason(orditem),"^",2)
    .;s patbilltypedr=+$p(^PAPER(papmi,"PER",1),"^",10)
	.;s:patbilltypedr'="" patbilltype=$p(^CT("SS",patbilltypedr),"^",2) //病人费别
    .s diag=$p(patInfo, "^", 9)
    .s patW=$p(patInfo, "^", 10)
    .s patH=$p(patInfo, "^", 11)
    .s result=##class(web.DHCSTCNTSCOMMON).CheckPrescNoStatus(prescno,"OA")
    .i result="1" s result="拒绝"
    .i result="2" s result="申诉"
    .i result="3" s result="通过"
    .i result="4" s result="拒绝(接受)"
    .i result="0" s result=""
    .s zcyflag=$p(data,"^",7)
    .s dspstatus=$p(data,"^",8)  //发药状态
    .i dspstatus="TC" s dspstatus="未发"
    .e  i dspstatus="C" s dspstatus="已发"
    .e  i dspstatus="R" s dspstatus="已退"
    .s result = ..Get(result)
    .s dspstatus = ..Get(dspstatus)
    .s preAdtResult=$p(data,"^",9)  //处方预审结果(前置审核)
    .s count=count+1
    .q:count<stpage
    .q:count>endpage
    .i style="" d
    ..s patno=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("patid",patno)
    ..s patname=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("patname",patname)
    ..s patsex=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("patsex",patsex)
    ..s patage=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("patage",patage)
    ..s path=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("path",patH)
    ..s patw=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("patw",patW)
    ..s billtype=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("billtype",patbilltype)
    ..s diag=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("diag",diag)
	..s patloc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("patloc",patloc)
	..s prescno=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("prescno",prescno)
	..s adm=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("adm",adm)
	..i (result="拒绝")||(result="申诉")||((result="拒绝发药")) s result="result:'<font color=red>"_result_"</font>',"
	..e  s result=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("result",result) 
	..s orditem=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("orditem",orditem)
	..s zcyflag=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("zcyflag",zcyflag)
	..s papmi=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("papmi",papmi)
	..s dspstatus=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("dspstatus",dspstatus)
	..s preAdtResult=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("preAdtResult",preAdtResult)
	.e  d
	..s patno=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("patid",patno)
    ..s patname=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("patname",patname)
    ..s patsex=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("patsex",patsex)
    ..s patage=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("patage",patage)
    ..s path=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("path",patH)
    ..s patw=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("patw",patW)
    ..s billtype=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("billtype",patbilltype)
    ..s diag=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("diag",diag)
	..s patloc=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("patloc",patloc)
	..s prescno=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("prescno",prescno)
	..s adm=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("adm",adm)
	..//i (result="拒绝")||(result="申诉") s result="result:'<font color=red>"_result_"</font>',"
	..s result=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("result",result) 
	..s orditem=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("orditem",orditem)
	..s zcyflag=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("zcyflag",zcyflag)
	..s papmi=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("papmi",papmi)
	..s warningmsg=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("warningmsg",warningmsg)
	..s dspstatus=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("dspstatus",dspstatus)
	..s preAdtResult=##class(web.DHCSTJQUERYCOMMON).GetJsonLastCell("preAdtResult",preAdtResult)
	.s tmpstr=patno_patname_patsex_patage_path_billtype_patw_diag_patloc_prescno_adm_result_orditem_zcyflag_papmi_warningmsg_dspstatus_preAdtResult
    .i style="" d
    ..s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    ..s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    ..s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
    .e  d
    ..s startString=##class(web.DHCSTJQUERYCOMMON).getJsonStartStringJqGrid(maxrow,limit)
    ..s firstrow=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstRow(tmpstr)
    ..s lastrow=##class(web.DHCSTJQUERYCOMMON).GetJsonLastRow(tmpstr)
    .i count=stpage w startString
    .i count<endpage w firstrow
    .i count=endpage w lastrow
    k ^TMP("dhcpha","DHCSTCNTSOUTMONITOR","GetAdmPrescList",pid)
    //k ^TMP("dhcpha","DHCSTCNTSOUTMONITOR","GetAdmPrescList","PrescNo",pid)
    //k ^TMP("dhcpha","DHCSTCNTSOUTMONITOR","GetAdmPrescList","QuitPrescNo",pid)
    q:startString="" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
    q ""

   
getdata    
    s admexit=0
    s chl="" 
    f  s chl=$o(^OEORDi(0,"ItemDate",date,ord,chl)) q:chl=""  d
	.q:+chl=0
	.s oeori=ord_"||"_chl
	.q:'$d(^OEORD(ord,"I",chl,3))
	.s reclocdr=$p(^OEORD(ord,"I",chl,3),"^",6)
	.q:reclocdr'=phalocdr
	.q:'$d(^DHCOEDISQTY(0,"OEORI",oeori))
	.s dsprowid=$o(^DHCOEDISQTY(0,"OEORI",oeori,""))
	.q:dsprowid=""
	.s prescno=$p(^OEORD(ord,"I",chl,1),"^",14) 
	.q:prescno=""
	.s adtwin=""
	.s quer=$o(^PAQUE1(0,"PrescNo",prescno,""))
	.i quer'="" d
	..s adtwin=$p($g(^PAQUE1(quer,"DHC")),"^",29)
	.q:(adtwin'=adtwindesc)&(adtwin'="")
	.q:$d(^TMP("dhcpha","DHCSTCNTSOUTMONITOR","GetAdmPrescList",pid,"PrescNo",prescno))
	.q:$d(^TMP("dhcpha","DHCSTCNTSOUTMONITOR","GetAdmPrescList",pid,"QuitPrescNo",prescno))
	.q:$d(^TMP("dhcpha","DHCSTCNTSOUTMONITOR","GetAdmPrescList",pid,"PreAdtPresc",prescno))
	.s DocLocDispFlag=##class(PHA.OP.COM.Method).GetDocLocDispFlag(prescno)
	.i DocLocDispFlag="1" s ^TMP("dhcpha","DHCSTCNTSOUTMONITOR","GetAdmPrescList",pid,"QuitPrescNo",prescno)=""  //过滤处方
	.q:(type="E")&&(DocLocDispFlag="1")
	.s dspstatus=$p(^DHCOEDISQTY(dsprowid),"^",7)
	.s result=##class(web.DHCSTCNTSCOMMON).CheckPrescNoStatus(prescno,"OA")
	.//1拒绝  2申诉  3通过  0未审
    .q:(onlyadt="true")&((result=0)||(result=2))
    .q:(onlyadt'="true")&((result=3)||(result=1)||(result=4))
    .s statdr=$p(^OEORD(ord,"I",chl,1),"^",13)
	.s oeflag=$p(^OEC("OSTAT",statdr),"^",1) 
	.s payflag=$p(^OEORD(ord,"I",chl,3),"^",5)
	.s payDispFlag=##class(PHA.OP.COM.Method).GetDispBeforePay(oeori) 
	.//yunhaibao20160303,未处方审核且停医嘱且未交费或先发模式的不显示
	.q:(onlyadt'="true")&&(oeflag'="V")&&(oeflag'="E")&&((payflag'="P")||(payDispFlag="Y")) 
	.s priordr=+$p(^OEORD(ord,"I",chl,1),"^",8) 
    .q:priordr=0 
    .s priority=$p(^OECPR(priordr),"^",1) 			;医嘱优先级代码              
    .q:priority["OM" ;自备药
	.s deplocdr=$p(^PAADM(adm),"^",4)
    .s deplocdesc= ##class(PHA.COM.Data.Base).LocDesc(deplocdr)
    .i deplocdesc["-" s deplocdesc=$p(deplocdesc,"-",2)
	.s papmi=$p(^PAADM(adm),"^",1)
	.s patid=$p(^PAPER(papmi,"PAT",1),"^",1)
	.s zcyflag=0 //草药标志
	.i quer'="" d
	..i $p($g(^PAQUE1(quer,"DHC")),"^",2)=3 s zcyflag=1
	.
	.s preAdtResult=""
	.i (autoAudiFlag="Y")&&(onlyadt'="true") d
	..s preAdtResult=..GetPreAdtResultByPrescNo(prescno)
	..i preAdtResult=0 d
	...s ^TMP("dhcpha","DHCSTCNTSOUTMONITOR","GetAdmPrescList",pid,"PreAdtPresc",prescno)=preAdtResult_"^"_oeori
	.q:(autoAudiFlag="Y")&&(onlyadt'="true")&&(preAdtResult=0)  // 预审 合理地结果不显示
 	.s h=h+1
	.s data=patid_"^"_deplocdesc_"^"_prescno_"^"_adm_"^"_oeori_"^"_result_"^"_zcyflag_"^"_dspstatus_"^"_preAdtResult
	.s ^TMP("dhcpha","DHCSTCNTSOUTMONITOR","GetAdmPrescList",pid,"PrescNo",prescno)=""
	.s ^TMP("dhcpha","DHCSTCNTSOUTMONITOR","GetAdmPrescList",pid,"PrescAudit",h)=data	
	q
}

/// Creator		zhaozhiduan
/// CreatDate	2021.07.06
/// Description	根据处方获取预审结果
/// Input		prescNo-处方号
/// Outputt		预审结果
ClassMethod GetPreAdtResultByPrescNo(prescNo)
{
	
	q:prescNo="" ""
	q:'$d(^BS.PHA.PRA.ORDAUDITi("PrescNo",prescNo)) ""
	q:$d(^DHCPHORDM(0,"PrescNo",prescNo)) ""   //审核过需人工审核
	s maxResVal=0
	s preAdtId=""
	for{
		s preAdtId=$o(^BS.PHA.PRA.ORDAUDITi("PrescNo",prescNo,preAdtId))
		q:preAdtId=""
		s preAdtResult=$p(^BS.PHA.PRA.ORDAUDIT(preAdtId),"^",7)
		//continue:preAdtResult="Y"
		s preAdtResVal=$p(^BS.PHA.PRA.ORDAUDIT(preAdtId),"^",8)
		i maxResVal<preAdtResVal s maxResVal=preAdtResVal
	}
	q maxResVal
}

/// Description:构造树形结构
/// Creator:LiangQiang
ClassMethod GetAdmPrescTreeData(level, id, input) As %String
{
	
	s pid=##class(web.DHCSTCNTSCOMMON).GetPHCNTSPID()
	s stdate=$p(input,"^",1)
	s stdate=$zdh(stdate,4)
	s enddate=$p(input,"^",2)
	s enddate=$zdh(enddate,4)
    s phalocdr=$p(input,"^",3)
    s patID=$p(input,"^",4)
    s onlyadt=$p(input,"^",5)
    s h=0
	w "["
	
	i level=0 s currlevel=1
    f date=stdate:1:enddate  d
    .q:level'=0
    .q:patID'=""
    .s typestr="O^E"
    .s typecnt=$l(typestr,"^")
    .f n=1:1:typecnt d
    ..s type=$p(typestr,"^",n)
    ..s adm=""
    ..f  s adm=$o(^PAADMi("NNType",type,date,adm)) q:adm=""  d
    ...d getdata
   
    
    s typestr="O^E"
    s exit=0
    s typecnt=$l(typestr,"^")
    f n=1:1:typecnt d
    .s type=$p(typestr,"^",n)
    .q:level'=0
    .q:patID=""
    .s papmidr=$o(^PAPERi("PAPMI_PatNo",patID,""))
    .s adm=""
    .f  s adm=$o(^PAPERdr(papmidr,"ADM",type,adm),-1) q:(adm="")||(exit="1")  d 
	..s date=$p(^PAADM(adm),"^",6) ;就诊日期
	..i date<stdate s exit="1" q   ;就诊日期小于查询起始日期,不在遍历
	..d getdata
	

	
	
	i level=1 d
	.s leafflag="true"
	.s currlevel=2
	.s papmi=$p(^PAADM(id),"^",1)
	.s sexDr=$p(^PAPER(papmi,"ALL"),"^",7) 
	.i sexDr'="" s sex=$p(^CT("SEX",sexDr),"^","2")
	.s iconPerson="../scripts/dhcpha/img/woman.gif"
	.i $g(sex)["男" s iconPerson="../scripts/dhcpha/img/man.gif"
	.s ord=$o(^OEORD(0,"Adm",id,"")) 
	.q:ord=""	 ;对应就诊日期下该病人ord
	.s orddate=$p(^OEORD(ord),"^",2)
	.f date=stdate:1:enddate  d	
	..s chl=""
	..f  s chl=$o(^OEORDi(0,"LocStDtArr",phalocdr,0,date,ord,chl)) q:(chl="")||(chl="0")  d
	...s oeori=ord_"||"_chl
	...;s $p(^OEORD(ord,"I",chl,7),"^",3)=""
	...q:'$d(^DHCOEDISQTY(0,"OEORI",oeori))
	...s dsprowid=$o(^DHCOEDISQTY(0,"OEORI",oeori,""))
	...q:dsprowid=""
	...s prescno=$p(^OEORD(ord,"I",chl,1),"^",14) 
	...q:prescno=""
	...q:$d(^TMP("dhcpha","DHCSTCNTSOUTMONITOR","GetAdmTreeData",pid,prescno))
	...s dspstatus=$p(^DHCOEDISQTY(dsprowid),"^",7)
	...s result=##class(web.DHCSTCNTSCOMMON).GetOrdAuditResult(oeori)
    ...q:(onlyadt="true")&(result="")
    ...q:(onlyadt'="true")&(result'="")
    ...//q:(onlyadt'="true")&(dspstatus'="TC")
    ...s statdr=$p(^OEORD(ord,"I",chl,1),"^",13)
	...s oeflag=$p(^OEC("OSTAT",statdr),"^",1) 
	...q:(oeflag'="V")&(oeflag'="E")
	...s priordr=+$p(^OEORD(ord,"I",chl,1),"^",8) 
    ...q:priordr=0 
    ...s priority=$p(^OECPR(priordr),"^",1) 			;医嘱优先级代码              
    ...q:priority["OM" ;自备药
    ...s tmpid=id_","_prescno
    ...s ^TMP("dhcpha","DHCSTCNTSOUTMONITOR","GetAdmTreeData",pid,prescno)=""
    ...s h=h+1
    ...i h=1 w "{"_"id:'"_tmpid_"',text:'"_prescno_"',leaf:"_leafflag_",level:'"_currlevel_"',icon:'"_iconPerson_"'}"
    ...i h'=1 w ",{"_"id:'"_tmpid_"',text:'"_prescno_"',leaf:"_leafflag_",level:'"_currlevel_"',icon:'"_iconPerson_"'}"
 
    
    k ^TMP("dhcpha","DHCSTCNTSOUTMONITOR","GetAdmTreeData",pid)
    
    q "]"
    
   
getdata    
    s ord=$o(^OEORD(0,"Adm",adm,"")) 
	q:ord=""	 ;对应就诊日期下该病人ord
    s admexit=0
    s chl=""
    f  s chl=$o(^OEORDi(0,"LocStDtArr",phalocdr,0,date,ord,chl)) q:(chl="")||(chl="0")||(admexit=1)  d
	.s oeori=ord_"||"_chl
	.;s $p(^OEORD(ord,"I",chl,7),"^",3)=""
	.q:'$d(^DHCOEDISQTY(0,"OEORI",oeori))
	.s dsprowid=$o(^DHCOEDISQTY(0,"OEORI",oeori,""))
	.q:dsprowid=""
	.s prescno=$p(^OEORD(ord,"I",chl,1),"^",14) 
	.q:prescno=""
	.s dspstatus=$p(^DHCOEDISQTY(dsprowid),"^",7)
	.s result=##class(web.DHCSTCNTSCOMMON).GetOrdAuditResult(oeori)
    .q:(onlyadt="true")&(result="")
    .q:(onlyadt'="true")&(result'="")
    .;q:(onlyadt'="true")&(dspstatus'="TC")
    .s statdr=$p(^OEORD(ord,"I",chl,1),"^",13)
	.s oeflag=$p(^OEC("OSTAT",statdr),"^",1) 
	.q:(oeflag'="V")&(oeflag'="E")
	.s priordr=+$p(^OEORD(ord,"I",chl,1),"^",8) 
    .q:priordr=0 
    .s priority=$p(^OECPR(priordr),"^",1) 			;医嘱优先级代码              
    .q:priority["OM" ;自备药
    .s admexit=1
    .s h=h+1
  	.s leafflag="false"
	.s deplocdr=$p(^PAADM(adm),"^",4)
    .s deplocdesc=$p(^CTLOC(deplocdr),"^",2)
    .i deplocdesc["-" s deplocdesc=$p(deplocdesc,"-",2)
	.s papmi=$p(^PAADM(adm),"^",1)
	.s patid=$p(^PAPER(papmi,"PAT",1),"^",1)
	.s deplocdesc=patid_","_deplocdesc
	.i h=1 w "{"_"id:'"_adm_"',text:'"_deplocdesc_"',leaf:"_leafflag_",level:'"_currlevel_"'}"
	.i h'=1 w ",{"_"id:'"_adm_"',text:'"_deplocdesc_"',leaf:"_leafflag_",level:'"_currlevel_"'}"
	q
}

/// 处方明细JSON数据
/// O12040700015
/// w ##class(web.DHCSTCNTSOUTMONITOR).GetOrdDetailData("O190621000023","","","false","jqGrid")
ClassMethod GetOrdDetailData(prescno, stpage, limit, input, style = "") As %String
{
	q:(prescno="")&&(style'="") ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
	s pid=##class(web.DHCSTCNTSCOMMON).GetPHCNTSPID()
	i style="" d
	.s endpage=stpage+limit  //结束行
	.s stpage=stpage+1 //开始行
	i style'="" d
	.s stpage=1
	.s page=1,limit=100
	.s stpage=((stpage-1)*limit)+1 //开始行
	.s endpage=page*limit  //结束行
	s onlyadt=$p(input,"^",1)
	s findflag=1
	s h=0
	s ord=""
	f  s ord=$o(^OEORD(0,"PrescNo",prescno,ord))  q:ord=""  d
	.s chl=""
	.f  s chl=$o(^OEORD(0,"PrescNo",prescno,ord,chl)) q:chl=""  d
	..s orditm=ord_"||"_chl
	..s presc=$p(^OEORD(ord,"I",chl,1),"^",14) ;处方号
	..s arcimid=$p(^OEORD(ord,"I",chl,1),"^",2)  ;医嘱 ARC_ItmMast ARCIM_RowId
	..s itmmastid=$p(arcimid,"||",1)
	..s itmmastver=$p(arcimid,"||",2)
	..s inci=$o(^INCI(0,"ARCIM_DR",$p(arcimid,"||",1),"") ) 
	..q:inci=""  //医嘱名称
	..s inciDesc=$p(^INCI(inci,1),"^",2) //药品名称
	..s inciDesc=##class(PHA.COM.Data.Base).ArcimDesc(arcimid)
	..s dsp=$o(^DHCOEDISQTY(0,"OEORI",orditm,""))
	..q:dsp=""
	..//过滤-未审核状态下停止或者作废的医嘱
	..s oeoriStatStr=##class(PHA.COM.Order).OeoriStat(orditm)		   
	..s oeFlag=$P(oeoriStatStr,"^",1)
	..;q:(onlyadt'="true")&&(oeFlag'="V")&&(oeFlag'="E")
	..s ordstat=$P(oeoriStatStr,"^",2)
	..s priordr=+$p(^OEORD(ord,"I",chl,1),"^",8) 
    ..q:priordr=0 
    ..s priority=$p(^OECPR(priordr),"^",1) 			;医嘱优先级代码              
    ..q:priority["OM" ;自备药
	..s result=##class(web.DHCSTCNTSCOMMON).GetOrdAuditResult(orditm)
	..s ChkResult=##class(web.DHCSTCNTSCOMMON).CheckPrescNoStatus(prescno,"OA") //yunhaibao20160325,统一以OA状态为审核标准
	..//1拒绝  2申诉  3通过  0未审
    ..//q:(onlyadt="true")&(result="")&(ChkResult'=2)
    ..//q:(onlyadt'="true")&(result'="")&(ChkResult'=2)
    ..q:(onlyadt="true")&((ChkResult=0))
    ..q:(onlyadt'="true")&((ChkResult=3)||(ChkResult=1)||(ChkResult=4))
    ..s qty=0
    ..s dspId=""
    ..f  s dspId=$o(^DHCOEDISQTY(0,"OEORI",orditm,dspId)) q:dspId=""  d
    ...s dspStatus=$p(^DHCOEDISQTY(dspId),"^",7)
    ...q:dspStatus="R"
    ...s qty=qty+$p(^DHCOEDISQTY(dspId),"^",5)
	..//s:findflag=1 puomdr=$p(^ARCIM(itmmastid,itmmastver,8),"^",14)
	..s phcdfID=##Class(web.DHCSTCOMMPHC).GetPhcdfByArcim(arcimid)
	..S phcdID=$P(phcdfID,"||",1)
	..Q:phcdID=""
	..S formSub=$P(phcdfID,"||",2)
	..Q:formSub=""
	..S buomdr=$P($g(^PHCD(phcdID,"DF",formSub,2)),"^",4)
	..s uomdr=buomdr
	..s uomdesc=##class(PHA.COM.Data.Base).UomDesc(uomdr) //单位
    ..s doseuom=""
	..s dosuomID=+$p($g(^OEORD(ord,"I",chl,2)),"^",3)
	..i dosuomID'=0 d
	...s doseuom=##class(PHA.COM.Data.Base).UomDesc(dosuomID) ;剂量单位
	..i doseuom'="" d
	...s dosage=##class(PHA.COM.Order).OeoriDosage(orditm) 
	..e  s dosage=""
    ..s freq=$p(##class(PHA.COM.Order).OeoriFreq(orditm),"^",3)
    ..s instru=""
    ..s instrudr=+$p($g(^OEORD(ord,"I",chl,2)),"^",7)
    ..s:instrudr'=0 instru=##class(PHA.COM.Data.Base).InstDesc(instrudr)       	;用法
    ..s duration=""
    ..s dur=+$p($g(^OEORD(ord,"I",chl,2)),"^",6)
	..s:dur'=0 duration=##class(PHA.COM.Data.Base).DuratDesc(dur)         	;用药疗程
	..s priorty=""
	..s pri=+$p($g(^OEORD(ord,"I",chl,1)),"^",8)
	..s:pri'=0 priorty=##class(PHA.COM.Data.Base).OrdPriDesc(pri)  		;医嘱优先级
	..s doctorId=$p($g(^OEORD(+ord,"I",chl,1)),"^",11)
	..s doctor = ##class(PHA.COM.Data.Base).CareProvDesc( doctorId)     ;医生
	..s skintest=$p(##class(PHA.COM.Order).OeoriSkinTest(orditm),"^",2)  ;皮试
	..s formId = $p(##class(web.DHCST.Common.DrugInfoCommon).GetForm(inci),"^",2)
	..s form = ##class(PHA.COM.Data.Base).FormDesc(formId)  ;剂型
	..i $F(form,$c(13)) s form=$p(form,$c(13))
	..s spec= ##class(PHA.COM.Drug).GetSpec(inci) ;规格
    ..s manf=$lg(##class(PHA.COM.Drug).GetManf(inci),3) 
	..s manf=$tr(manf,$c(13,10),"")
	..i $f(manf,"-") s manf=$p(manf,"-",2)
	..//s remark=##class(web.DHCSTCOMMONSRV).GetOrdItmRemark(orditm) ;备注
	..s Notes=$g(^OEORD(ord,"I",chl,"DEP",1)) ;医嘱备注
	..s remark=$p($g(^OEORD(ord,"I",chl,2)),"^",8) //草药备注
	..S Notes=$tr($tr($tr(Notes,$c(10)),$C(13))," ")
	..i Notes'="" d
	...i remark'="" d
	....s Notes=Notes_"("_remark_")"
    ..e  i remark'="" d
    ...s Notes=remark
    ...
	..s remark=Notes
	..s realdura=##class(web.DHCSTCNTSCOMMON).GetRealDuration(orditm) ;实际疗程
	..s basflag=$p($g(^PHCD(phcdID,"DF",formSub,"DHC")),"^",31)
	..i basflag="Y" s basflag=..Get("是")
	..e  s basflag=..Get("否")
    ..s orddate=$p(^DHCOEDISQTY(dsp),"^",15)
    ..i orddate'="" s orddate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(orddate)
    ..s ordtime=$p(^DHCOEDISQTY(dsp),"^",16)
    ..i ordtime'="" s ordtime=$zt(ordtime,1)
    ..s orddatetime=orddate_" "_ordtime  ;开单日期
    ..s h=h+1
    ..s data=skintest_" "_inciDesc_"^"_qty_"^"_uomdesc_"^"_dosage_"^"_freq_"^"_spec_"^"_instru_"^"_duration_"^"_form
    ..s data=data_"^"_priorty_"^"_doctor_"^"_orddatetime_"^"_remark_"^"_manf_"^"_basflag_"^"_realdura_"^"_orditm_"^"_ordstat
    ..s ^TMP("dhcpha","DHCSTCNTSOUTMONITOR","GetOrdDetailData",pid,h)=data
    q:(h=0)&&(style="") ##class(web.DHCSTEXTCOMMON).GetNoJson()
	q:(h=0) ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
    s maxrow=h
    i endpage>maxrow s endpage=maxrow
    s count=0
    s h=""
    f  s h=$o(^TMP("dhcpha","DHCSTCNTSOUTMONITOR","GetOrdDetailData",pid,h)) q:h=""  d
    .s data=^TMP("dhcpha","DHCSTCNTSOUTMONITOR","GetOrdDetailData",pid,h)
    .s incidesc=$p(data,"^",1)
    .s qty=$p(data,"^",2)
    .s uomdesc=$p(data,"^",3)
    .s dosage=$p(data,"^",4)
    .s freq=$p(data,"^",5)
    .s spec=$p(data,"^",6)
    .s instruc=$p(data,"^",7)
    .s dura=$p(data,"^",8)
    .s form=$p(data,"^",9)
    .s pri=$p(data,"^",10)
    .s doctor=$p(data,"^",11)
    .s orddate=$p(data,"^",12)
    .s remark=$p(data,"^",13)
    .s manf=$p(data,"^",14)
    .s basflag=$p(data,"^",15)
    .s realdura=$p(data,"^",16)
    .s orditm=$p(data,"^",17)
    .s ordstat=$p(data,"^",18)
    .s count=count+1
    .q:count<stpage
    .q:count>endpage
    .i style="" d
    ..s incidesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("incidesc",incidesc)
	..s qty=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("qty",qty)
	..s uomdesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("uomdesc",uomdesc)
	..s dosage=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("dosage",dosage)
	..s freq=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("freq",freq)
	..s spec=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("spec",spec)
	..s instruc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("instruc",instruc)
	..s dura=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("dura",dura)
	..s form=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("form",form)
	..s pri=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("pri",pri)
	..s doctor=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("doctor",doctor)
	..s orddate=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("orddate",orddate)
	..s remark=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("remark",remark)
	..s manf=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("manf",manf)
	..s basflag=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("basflag",basflag)
	..s realdura=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("realdura",realdura)
	..s orditm=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("orditm",orditm)
	..s ordstat=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("ordstat",ordstat)
	.e  d
	..s incidesc=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("incidesc",incidesc)
	..s qty=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("qty",qty)
	..s uomdesc=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("uomdesc",uomdesc)
	..s dosage=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("dosage",dosage)
	..s freq=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("freq",freq)
	..s spec=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("spec",spec)
	..s instruc=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("instruc",instruc)
	..s dura=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("dura",dura)
	..s form=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("form",form)
	..s pri=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("pri",pri)
	..s doctor=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("doctor",doctor)
	..s orddate=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("orddate",orddate)
	..s remark=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("remark",remark)
	..s manf=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("manf",manf)
	..s basflag=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("basflag",basflag)
	..s realdura=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("realdura",realdura)
	..s orditm=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("orditm",orditm)
	..s ordstat=##class(web.DHCSTJQUERYCOMMON).GetJsonLastCell("ordstat",ordstat)	
	.s tmpstr=incidesc_qty_uomdesc_dosage_freq_spec_instruc_dura_form_pri_doctor_orddate_remark_manf_basflag_realdura_orditm_ordstat
    .i style="" d
    ..s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    ..s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    ..s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
    .e  d
    ..s startString=##class(web.DHCSTJQUERYCOMMON).getJsonStartStringJqGrid(maxrow,limit)
    ..s firstrow=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstRow(tmpstr)
    ..s lastrow=##class(web.DHCSTJQUERYCOMMON).GetJsonLastRow(tmpstr)
	.
	.;i count=1 w startString
    .;i count<maxrow w firstrow
    .;i count=maxrow w lastrow
    .
    .i count=stpage w startString
    .i count<endpage w firstrow
    .i count=endpage w lastrow
    
    
    k ^TMP("dhcpha","DHCSTCNTSOUTMONITOR","GetOrdDetailData",pid)
    q ""
}

/// Description	保存医嘱发药前审核结果108$$$2||17,N^578^^^^34^2||17^OA
/// Input		reasonstr:组织字符串 ：原因ID1^原因ID2 $$$ 药品ID1 $$$ 药品ID2 ! 原因ID3^ ...
/// 			input:"Y^10213^^^^246^532||49^OA"
/// 			auditWay:审核途径(1-自动审核，2-人工审核)
/// w ##class(web.DHCSTCNTSOUTMONITOR).SaveOPAuditResult("","Y^10213^^^^246^532||49^OA") 
ClassMethod SaveOPAuditResult(reasonstr As %Text, input As %Text, auditWay As %String = "2") As %String
{
	//s ^tmyq($this,"SaveOPAuditResult",$h)=$lb(reasonstr,input)
	s result=$p(input,"^",1)
	i result="N" s status="SHJJ"
	i result="Y" s status="SHTG" 
	s user=$p(input,"^",2)
	s phanote=$p(input,"^",5)
	s oeori=$p(input,"^",7) 
	s apptype=$p(input,"^",8) 
	
	s currdate=+$h
	s currtime=$p($h,",",2)
	i oeori'["||" d
	.s ord=$o(^OEORD(0,"PrescNo",oeori,""))
	.s itm=$o(^OEORD(0,"PrescNo",oeori,ord,""))
	.s oeori=ord_"||"_itm
	e  d
	.s ord=$p(oeori,"||",1)
	.s itm=$p(oeori,"||",2)
	s phalocdr=$p(^OEORD(ord,"I",itm,3),"^",6)
	s hospid=$p(^CTLOC(phalocdr),"^",22)
	s Params="^"_phalocdr_"^^"_hospid
	s NeedSkinTest=##class(web.DHCST.Common.AppCommon).GetAppPropValue("DHCSTOUTPH","SKINTESTFLAG",Params) //皮试配置,为Y时需要判断,yunhaibao20160531
	
	s prescno=$p(^OEORD(ord,"I",itm,1),"^",14)
	s phlRowid=$o(^DHCPHLOCi("LOC",phalocdr,""))
	q:phlRowid="" "-1^"_..Get("处方")_"："_prescno_"接收科室没有维护成为门诊药房科室!"
	s NeedOrdAuditFlag=##class(PHA.OP.COM.Method).GetNeedOrdAuditFlag(phlRowid)
	s dispStat=""  //发药状态
	s pyStat=""  //配药状态

	i NeedOrdAuditFlag=1 d
	.i $d(^DHCPHDISPi("PRESCNO",prescno)) d
	..s phdrowid=$o(^DHCPHDISPi("PRESCNO",prescno,""),-1) 
	..s dispStat=$p(^DHCPHDISP(phdrowid),"^",4)
	..s pyStat=$p(^DHCPHDISP(phdrowid,1),"^",6) 
	q:(NeedOrdAuditFlag=1)&&(dispStat="1") "-1^"_..Get("处方")_"："_prescno_..Get("已发药，不能审核")
	q:(NeedOrdAuditFlag=1)&&(pyStat="1")&&(dispStat'="1")&&(apptype'="OR") "-1^"_..Get("处方")_"："_prescno_..Get("已配药，不能审核")
	q:(NeedOrdAuditFlag=1)&&(pyStat="")&&(dispStat="-1")&&(apptype'="OR") "-1^"_..Get("处方")_"："_prescno_..Get("已配药，不能审核")
	//q:$p(^OEORD(ord,"I",itm,7),"^",3)'="" 0  //已存在结果
	
	s mainorditm=##class(web.DHCSTCNTSCOMMON).GetMainOeori(ord_"||"_itm)
	s errInfo=""
	i (NeedSkinTest="Y")&&(status="SHTG") d
	.s skinTextFlag=##class(PHA.COM.Order).OrderSkinTest(mainorditm)
    .i skinTextFlag=-1 s errInfo="-1^"_..Get("处方")_"："_prescno_..Get("皮试未做，不能审核通过")
    .e  i skinTextFlag=-2 s errInfo="-1^"_..Get("处方")_"："_prescno_..Get("皮试阳性，不能审核通过")
    .e  i skinTextFlag=-3 s errInfo="-1^"_..Get("处方")_"："_prescno_..Get("皮试非阴性，不能审核通过")
    .e  i skinTextFlag<0 s errInfo="-1^"_..Get("处方")_"："_prescno_..Get("皮试非阴性，不能审核通过")
	q:errInfo'="" errInfo
 
    s adm=$p(^OEORD(ord),"^",1)
    s doctor=$p($g(^OEORD(ord,"I",itm,1)),"^",11)
	s pid=##class(web.DHCSTCNTSCOMMON).GetPHCNTSPID()
	//门诊按处方处理
	s m=0
	i (reasonstr'["$$$")&(reasonstr'="") s m=1
	s adm=$p(^OEORD(ord),"^",1)
	//s prescno=$p(^OEORD(ord,"I",itm,1),"^",14)
	s patInfo=##class(PHA.COM.Order).GetPatInfo(adm)
    s patName=$p(patInfo,"^",3)
	//判断皮试
	s errInfo=""
    i (NeedSkinTest="Y")&&(status="SHTG") d
    .s skinTextFlag=##class(PHA.COM.Order).PrescSkinTest(prescno)
    .i skinTextFlag=-1 s errInfo="-1^"_patName_..Get("处方")_"："_prescno_..Get("皮试未做，不能审核通过")
    .e  i skinTextFlag=-2 s errInfo="-1^"_patName_..Get("处方")_"："_prescno_..Get("皮试阳性，不能审核通过")
    .e  i skinTextFlag=-3 s errInfo="-1^"_patName_..Get("处方")_"："_prescno_..Get("皮试非阴性，不能审核通过")
    .e  i skinTextFlag<0 s errInfo="-1^"_patName_..Get("处方")_"："_prescno_..Get("皮试非阴性，不能审核通过")
	q:errInfo'="" errInfo
	s ord=""
	f  s ord=$o(^OEORD(0,"PrescNo",prescno,ord))  q:ord=""  d
	.s chl=""
    .f  s chl=$o(^OEORD(0,"PrescNo",prescno,ord,chl)) q:chl=""  d
    ..s orditem=ord_"||"_chl
    ..s auditflag=$p(^OEORD(ord,"I",chl,7),"^",3)
    ..//q:auditflag'=""
    ..s statdr=$p(^OEORD(ord,"I",chl,1),"^",13)
	..s oeflag=$p(^OEC("OSTAT",statdr),"^",1) 
	..q:(oeflag'="V")&(oeflag'="E")
	..s priordr=+$p(^OEORD(ord,"I",chl,1),"^",8) 
    ..q:priordr=0 
    ..s priority=$p(^OECPR(priordr),"^",1) 			;医嘱优先级代码              
    ..q:priority["OM" ;自备药
	..s ^TMP("dhcpha","DHCSTCNTSOUTMONITOR","SaveAuditResult","OrdItm",pid,orditem)="" //构造关联全部医嘱集合
	..i m=1 s reasonstr=reasonstr_"$$$"_orditem
	..
    //
	tstart
	s err=0
	k PLIST
	s PLIST(2)=user
	s PLIST(3)=result
	s PLIST(4)=currdate
	s PLIST(5)=currtime
	s PLIST(6)=phalocdr
	s PLIST(7)=phanote
	s PLIST(10)=apptype
	s PLIST(18)=auditWay
	&sql(INSERT INTO DHC_PHAORDMONITOR  VALUES :PLIST())
	i SQLCODE'=0  tro 
	i SQLCODE'=0 s err=1
	q:err'=0 -2
	s phaomr=+%ROWID
	//
	s tmpstr=reasonstr
	s cnt=$l(tmpstr,"!")
	i reasonstr="" s cnt=0
	f h=1:1:cnt q:err'=0  d
	.s splitstr=$p(tmpstr,"!",h)
	.s grpno=h
	.s tmpreasonstr=$p(splitstr,"$$$",1)
	.s reacnt=$l(tmpreasonstr,"^")
	.f n=1:1:reacnt q:err'=0  d
	..s reasondr=$p(tmpreasonstr,"^",n)  //原因ID
	..f m=2:1:$l(splitstr,"$$$") q:err'=0  d
	...s oeori=$p(splitstr,"$$$",m) //医嘱ID
	...s ord=$p(oeori,"||",1)
	...s chl=$p(oeori,"||",2)
	...k PLIST
	...s PLIST(0)=phaomr
	...s PLIST(2)=oeori
	...s PLIST(4)=reasondr
	...s PLIST(3)=grpno
	...s PLIST(5)=+$o(^DHCPHORDM(phaomr,"I",""),-1)+1
	...s PLIST(6)=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),1),"^",14)
	...s PLIST(7)=adm
	...&sql(INSERT INTO DHC_PHAORDMONITORLIST  VALUES :PLIST())
	...i SQLCODE'=0  tro 
	...i SQLCODE'=0 s err=1
	...q:SQLCODE'=0
	...s data=user_","_currdate_","_currtime_","_status
	...//s $p(^OEORD(ord,"I",chl,7),"^",3)=data
	...
	q:err'=0 -1
	//插入处方中其余医嘱拒绝
	s orditem=""
 	F  S orditem=$O(^TMP("dhcpha","DHCSTCNTSOUTMONITOR","SaveAuditResult","OrdItm",pid,orditem)) Q:orditem=""  d
 	.s ord=$p(orditem,"||",1)
	.s chl=$p(orditem,"||",2)
	.s adm=$p(^OEORD(ord),"^",1)
	.s data=user_","_currdate_","_currtime_","_status
	.//s $p(^OEORD(ord,"I",chl,7),"^",3)=data
	.i result="N" d
	..s sendportalflag=##class(web.DHCSTCOMMPARA).GetSendPortalFlag(hospid)  
	..i sendportalflag=1 d
	...s ret=##class(web.DHCENS.EnsHISService).DHCHisInterface("S00000024",orditem,"1",adm) //20151016把医嘱传给protal liangqiang
	
	//审核通过,只插一条记录
	i result="Y" d
	.k PLIST
	.s PLIST(0)=phaomr
	.s PLIST(3)=1
	.s PLIST(5)=+$o(^DHCPHORDM(phaomr,"I",""),-1)+1
	.s PLIST(6)=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),1),"^",14)
	.s PLIST(7)=adm
	.&sql(INSERT INTO DHC_PHAORDMONITORLIST  VALUES :PLIST())
	.i SQLCODE'=0  tro 
	.i SQLCODE'=0 s err=1
	.q:SQLCODE'=0
	k ^TMP("dhcpha","DHCSTCNTSOUTMONITOR","SaveAuditResult","OrdItm",pid)
	q:err'=0 -1
	
	//更新处方状态
	s OperUser=user
	s stateRemarks=""
	i apptype="OA" d
	.i result="Y" s stateRemarks="处方审核-通过"
	.i result="N" s stateRemarks="处方审核-拒绝"
	e  i apptype="OR" d
	.i result="Y" s stateRemarks="发药拒绝-通过"
	.i result="N" s stateRemarks="发药拒绝-拒绝"
	
	s ret=##class(PHA.OP.COM.Method).InsetPrescState(prescno,OperUser,"20",stateRemarks)  //更新处方状态
	i +ret<0 s err="-26^"_$p(ret,"^",2)
	i err'=0 tro  
	q:err'=0 err

	tcommit
	s ret1= ##class(web.DHCSTInterfaceMessage).SendAppealOrderMonitor(phaomr,"Exec")
	i result="N" s ret2= ##class(web.DHCSTInterfaceMessage).SendRefuseOrderMonitor(phaomr,"Send")
	
	s monitorid=$o(^DHCPHORDM(0,"PrescNo",prescno,phaomr),-1)
	i monitorid'="" d
	.s status=$p(^DHCPHORDM(monitorid),"^",2)
    .s DocNote=$p(^DHCPHORDM(monitorid),"^",7)
    .s agreeflag=$p(^DHCPHORDM(monitorid),"^",8)
    .s cancelFlag=$p(^DHCPHORDM(monitorid),"^",12)
    .i (status="N")&(DocNote="")&(cancelFlag="")  d  //之前是审核拒绝	
    ..&SQL(update DHC_PHAORDMONITOR set PHAOM_CancelUser_Dr=:user,PHAOM_CancelDate=:currdate,PHAOM_CancelTime=:currtime where PHAOM_RowId=:monitorid) 
    ..s execret=##class(web.DHCSTInterfaceMessage).SendRefuseOrderMonitor(monitorid,"Exec")

	q 0
}

/// 撤消审核结果
ClassMethod CancelOPOrdAudit(Input) As %String
{
	s pid=##class(web.DHCSTCNTSCOMMON).GetPHCNTSPID()
	s user=$p(Input,"^",1)
	s ordmr=$p(Input,"^",2)

	s currdate=+$h
	s currtime=$p($h,",",2)
	s result=$p(^DHCPHORDM(ordmr),"^",2)
	q:result="" -99
	s phdocnote=$p(^DHCPHORDM(ordmr),"^",7)
	q:(result="A")&&(phdocnote'="") -19 ; 申诉状态不允许撤消,继续拒绝或者通过
	s phalocdr=$p(^DHCPHORDM(ordmr),"^",5)
	s dispstat="1"  //发药状态
	s pystat="1"  //配药状态
	s sub=""
 	F  S sub=$O(^DHCPHORDM(ordmr,"I",sub)) Q:sub=""  d
	.s prescno=$p(^DHCPHORDM(ordmr,"I",sub),"^",4)
	.q:prescno=""
	.i $d(^DHCPHDISPi("PRESCNO",prescno)) d
	..s phdrowid=$o(^DHCPHDISPi("PRESCNO",prescno,""),-1) 
	..s dispstat=$p(^DHCPHDISP(phdrowid),"^",4)
	..s pystat=$p(^DHCPHDISP(phdrowid,1),"^",6) 
	.e  s dispstat="",pystat="" //不存在为未发
	.q:dispstat="1" 

	s phlRowid=$o(^DHCPHLOCi("LOC",phalocdr,""))
	s NeedOrdAuditFlag=##class(PHA.OP.COM.Method).GetNeedOrdAuditFlag(phlRowid)
	q:(dispstat="1") -18
	q:(NeedOrdAuditFlag=1)&&(pystat="")&&(dispstat="-1") -16
	q:(NeedOrdAuditFlag=1)&&(pystat="1")&&(dispstat'="1") -16	
	s chkflag=0
	s sub=""
 	F  S sub=$O(^DHCPHORDM(ordmr,"I",sub)) Q:sub=""  d
	.s prescno=$p(^DHCPHORDM(ordmr,"I",sub),"^",4)
	.s phordm=$o(^DHCPHORDM(0,"PrescNo",prescno,""),-1)
	.q:phordm'=ordmr  //不是最后一次日志,不能撤消
	.s ^TMP("dhcpha","DHCSTCNTSOUTMONITOR","CancelOrdAudit",pid,"PrescNo",prescno)=""  //有可能上次拒绝中,问题列表含多个处方药品,所以要以处方号整理撤消
	
	q:'$d(^TMP("dhcpha","DHCSTCNTSOUTMONITOR","CancelOrdAudit",pid,"PrescNo")) -98	
	s err=0
	tstart
	&SQL(update DHC_PHAORDMONITOR set PHAOM_CancelUser_Dr=:user,PHAOM_CancelDate=:currdate,PHAOM_CancelTime=:currtime where PHAOM_RowId=:ordmr) 
	i SQLCODE'=0 s err=-96
	q:err'=0 err
	s phaomr=+%ROWID
		
	s prescno=""
	f  s prescno=$o(^TMP("dhcpha","DHCSTCNTSOUTMONITOR","CancelOrdAudit",pid,"PrescNo",prescno)) q:(prescno="")||(err'=0)  d
	.s ord=""
	.s prescstatus=##class(web.DHCSTCNTSCOMMON).CheckPrescNoStatus(prescno,"OA")
	.i (prescstatus=1)||(prescstatus=2)||(prescstatus=4) s prescstatus=user_","_$h_",SHJJ"
	.e  i prescstatus=3 s prescstatus=user_","_$h_",SHTG"
	.e  s prescstatus=""
	.f  s ord=$o(^OEORD(0,"PrescNo",prescno,ord))  q:(ord="")||(err'=0)  d
	..s chl=""
    ..f  s chl=$o(^OEORD(0,"PrescNo",prescno,ord,chl)) q:(chl="")||(err'=0)  d
    ...s orditem=ord_"||"_chl
    ...s auditflag=$p(^OEORD(ord,"I",chl,7),"^",3)
    ...//q:auditflag'=""
    ...s statdr=$p(^OEORD(ord,"I",chl,1),"^",13)
	...s oeflag=$p(^OEC("OSTAT",statdr),"^",1) 
	...q:(oeflag'="V")&(oeflag'="E")
	...s priordr=+$p(^OEORD(ord,"I",chl,1),"^",8) 
    ...q:priordr=0 
    ...s priority=$p(^OECPR(priordr),"^",1) 			;医嘱优先级代码              
	...s $p(^OEORD(ord,"I",chl,7),"^",3)=prescstatus
	.//更新处方状态
	.s OperUser=user
	.s stateRemarks="处方审核-撤消"
	.s ret=##class(PHA.OP.COM.Method).InsetPrescState(prescno,OperUser,"20",stateRemarks)  //更新处方状态
	.i +ret<0 s err="-26^"_$p(ret,"^",2)
	.i err'=0 tro  
	.q:err'=0

	k ^TMP("dhcpha","DHCSTCNTSOUTMONITOR","CancelOrdAudit",pid)
	q:err'=0 err	
	tcommit	
	s execret=##class(web.DHCSTInterfaceMessage).SendRefuseOrderMonitor(ordmr,"Exec")
	q 0
}

/// 取某科室的审方窗口
ClassMethod GetAdtWinDs(ctlocdr) As %String
{
	 s pid=##class(web.DHCSTCNTSCOMMON).GetPHCNTSPID()
	 s n=0
	 s phauwr=0
	 f  s phauwr=$o(^DHCPHAUW(phauwr)) q:(phauwr="")||(phauwr="")  d
	 .s phl=$p(^DHCPHAUW(phauwr),"^",1)
     .s locdr=$p(^DHCPHLOC(phl),"^",1)
     .q:locdr'=ctlocdr
     .s windesc=$p(^DHCPHAUW(phauwr),"^",2)
	 .s n=n+1
	 .s data=$g(windesc)_"^"_$g(phauwr)
	 .s ^TMP("dhcpha","DHCSTCNTSOUTMONITOR","GetAdtWinDs",pid,n)=data
     
     q:n=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
     s maxrow=n
     s count=0
     s h=""
     f  s h=$o(^TMP("dhcpha","DHCSTCNTSOUTMONITOR","GetAdtWinDs",pid,h)) q:h=""  d
     .s data=^TMP("dhcpha","DHCSTCNTSOUTMONITOR","GetAdtWinDs",pid,h)
     .s windesc=$p(data,"^",1)
     .s rowId=$p(data,"^",2)
     .
     .s windesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("windesc",windesc)
	 .s rowId=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("rowId",rowId)
	 .
	 .s tmpstr=windesc_rowId
     .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
     .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
     .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	 .s count=count+1
	 .i count=1 w startString
     .i count<maxrow w firstrow
     .i count=maxrow w lastrow
	 .
	 k ^TMP("dhcpha","DHCSTCNTSOUTMONITOR","GetAdtWinDs",pid)
     q ""
}

/// Descript:	撤消审核拒绝
/// Creater：	bianshuai
/// CreateDate：2015-12-18
ClassMethod CancelRefuse(userid As %String, prescno As %String, type As %String) As %String
{
	//n (userid,prescno,type)
	q:(prescno="")||(type="") "-1"
	
    s quitflag=0
    s monitorid=""
    f  s monitorid=$o(^DHCPHORDM(0,"PrescNo",prescno,monitorid),-1) q:(monitorid="")||(quitflag=1)  d
    .s apptype=$p(^DHCPHORDM(monitorid),"^",9)
    .q:(apptype'=type)&(type'="")
    .s tmpmonitorid=monitorid
    .s quitflag=1
    .
    s monitorid=tmpmonitorid
    q:monitorid="" "-2"
    s result=$p(^DHCPHORDM(monitorid),"^",2) ///审核结果
    q:result="" "-3"
    s canceluser=$p(^DHCPHORDM(monitorid),"^",12)
	q:canceluser'="" -3
    s phalocdr=$p(^DHCPHORDM(monitorid),"^",5) ///科室
    tstart
    /// 1、医嘱审核字段置空
   	s prescstatus=##class(web.DHCSTCNTSCOMMON).CheckPrescNoStatus(prescno,"OR")
	i (prescstatus=1)||(prescstatus=2)||(prescstatus=4) s prescstatus=userid_","_$h_",SHJJ"
	e  i prescstatus=3 s prescstatus=userid_","_$h_",SHTG"
	e  s prescstatus=""
	s ord=""
	f  s ord=$o(^OEORD(0,"PrescNo",prescno,ord))  q:ord=""  d
	.s chl=""
    .f  s chl=$o(^OEORD(0,"PrescNo",prescno,ord,chl)) q:chl=""  d
    ..//s $p(^OEORD(ord,"I",chl,7),"^",3)=prescstatus

	///2、Insert DHC_PHAORDMONITOR
	s currdate=+$h,currtime=$p($h,",",2)
	&SQL(update DHC_PHAORDMONITOR set PHAOM_CancelUser_Dr=:userid,PHAOM_CancelDate=:currdate,PHAOM_CancelTime=:currtime where PHAOM_RowId=:monitorid) 
	i SQLCODE'=0 tro
	q:SQLCODE'=0 "-4"
	s monitorid=+%ROWID
	//更新处方状态
	s err=0
	s OperUser=userid
	s stateRemarks="发药拒绝-撤消"
	s ret=##class(PHA.OP.COM.Method).InsetPrescState(prescno,OperUser,"20",stateRemarks)  //更新处方状态
	i +ret<0 s err="-26^"_$p(ret,"^",2)
	i err'=0 tro  
	q:err'=0 err

	tcommit	
	s execret=##class(web.DHCSTInterfaceMessage).SendRefuseOrderMonitor(monitorid,"Exec")
	//d ##class(web.DHCSTInterfaceMessage).SendCancelOrderMonitor(monitorid,"Send") //yunhaibao20170407,撤消不发消息,改为撤消人读取处理拒绝时的消息
	q "0"
}

/// Descript:	检查发药人是否具有审核权限
/// Creater：	bianshuai
/// CreateDate：2015-12-18
ClassMethod CheckFyUserAuthority(phl As %String, fydr As %String) As %String
{
	q:(phl="")||(fydr="") "0"
	s tmpphl=$p(^DHCPHPER(fydr),"^",3)  	///科室 
	q:tmpphl'=phl "0"
  	s authflag=$p(^DHCPHPER(fydr),"^",8)
	q authflag
}

/// w ##class(web.DHCSTCNTSOUTMONITOR).GetCurPhoResultByPresc("O17021600003")
ClassMethod GetCurPhoResultByPresc(prescno As %String) As %String
{
	 s result=##class(web.DHCSTCNTSCOMMON).CheckPrescNoStatus(prescno,"")
     i result="1" s result="拒绝"
     e  i result="2" s result="申诉"
     e  i result="3" s result="通过"
     e  i result="4" s result="拒绝(接受)"
     e  i result="0" s result=""
     e  s result=""
     q result
}

/// w ##class(web.DHCSTCNTSOUTMONITOR).CheckRefReasonAndOrd("237$$$1075||3!237$$$1075||4$$$1075||3")
ClassMethod CheckRefReasonAndOrd(inputStr)
{
	s Len=$l(inputStr,"!")
	s err=""
	f i=1:1:Len q:err'=""  d
	.s splitstr=$p(inputStr,"!",i)
	.s reasonStr=$p(splitstr,"$$$",1)
	.s reaLen=$l(reasonStr,"^")
	.f n=1:1:reaLen q:err'=""  d
	..s reasonDr=$p(reasonStr,"^",n)  //原因ID
	..f m=2:1:$l(splitstr,"$$$") q:err'=""  d
	...s oeori=$p(splitstr,"$$$",m) //医嘱ID
	...i $d(Arr(reasonDr,oeori))  d
	....s errRows=Arr(reasonDr,oeori)
	....s err="第"_errRows_"与"_i_"组存在相同拒绝原因和医嘱"
	...e  d
	....s Arr(reasonDr,oeori)=i
	q err
}

ClassMethod Get(itm)
{
	q ##class(PHA.COM.Base).Get(itm)
}

}
