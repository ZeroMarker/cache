Import sqluser

/// description: 住院医嘱审核
Class web.DHCSTCNTSIPMONITOR Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// description: 病区列表
/// w ##class(web.DHCSTCNTSIPMONITOR).GetAdmWardList("2016-08-25 - 2016-08-25^98^^false^^",1,50,"jqGrid")
ClassMethod GetAdmWardList(input, stpage, limit, style = "") As %String
{
    k GetAdmWardListDATA
    q:(input="")&&(style'="") ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
    i style="" d
    .s endpage=stpage+limit  //结束行
    .s stpage=stpage+1 //开始行
    i style'="" d
    .s page=stpage
    .s stpage=((stpage-1)*limit)+1 //开始行
    .s endpage=page*limit  //结束行
    s datefrom=$p(input,"^",1)
    i datefrom'="" s datefrom=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(datefrom)
    s dateto=$p(input,"^",2)
    i dateto'="" s dateto=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(dateto)
    s locdr=$p(input,"^",3)
    s warddr=$p(input,"^",4)
    s onlyout=$p(input,"^",5)
    s aduitFlag=$p(input,"^",6)
    s slgid=$p(input,"^",7)
    s pAppealFlag=$p(input,"^",8)
    s PhaLocation=$o(^DHCPL(0,"Loc",locdr,""))
    s DealOrdFlag=$p($g(^DHCPL(+PhaLocation)),"^",37)
    s h=0
    f date=datefrom:1:dateto d
    .s ord=""
    .f  s ord=$o(^OEORDi(0,"LocStDtArr",locdr,0,date,ord)) q:ord=""  d
    ..s exist=0
    ..s adm=$p(^OEORD(ord),"^",1)
    ..s admtype=$p($g(^PAADM(adm)),"^",2)
    ..q:(admtype'="I")&&(admtype'="E")      //过滤非住院病人
    ..q:(##class(web.DHCSTCOMMONSRV).GetCurrentAdmStatus(adm) = 0)  // 出院患者过滤
    ..s wardcode="未分配"
    ..s admwarddr=$p(^PAADM(adm),"^",70) 
    ..q:(warddr'=admwarddr)&(warddr'="")&(admwarddr'="")
    ..q:..CheckWard(slgid,admwarddr)=0
    ..i admwarddr'="" d
    ...s wardcode=##class(PHA.COM.Data.Base).WardCode(admwarddr)
    ...s warddesc=##class(PHA.COM.Data.Base).WardDesc(admwarddr)
    ...i $f(warddesc,"-") s warddesc=$p(warddesc,"-",2)
    ..s papmi=$p(^PAADM(adm),"^",1)
    ..s patname=$p(^PAPER(papmi,"ALL"),"^",1)
    ..s patno=$p(^PAPER(papmi,"PAT",1),"^",1)
    ..s bedStr=##class(web.DHCPHACOM.ComPubClass.OrderAndPatInfo).GetAdmBedCode(adm) 
    ..s bedno=$p(bedStr,"^",2)
    ..s chl=""  
    ..f  s chl=$o(^OEORDi(0,"LocStDtArr",locdr,0,date,ord,chl)) q:(chl="")||(exist=1)  d
    ...s orditm=ord_"||"_chl
    ...s presc=$p(^OEORD(ord,"I",chl,1),"^",14) ;处方号
    ...q:presc=""
    ...s dsp=$o(^DHCOEDISQTY(0,"OEORI",orditm,""))
    ...q:dsp="" 
    ...q:'$d(^DHCOEDISQTY(dsp,"I"))
    ...q:(admtype="E")&&(##class(web.DHCSTCOMMONSRV).GetPayStayStatus(orditm)'="Y")
    ...q:(admtype="E")&&(orditm'=##class(PHA.COM.Order).GetVirtualLongOeori(orditm))
    ...s priordr=+$p(^OEORD(ord,"I",chl,1),"^",8) 
    ...q:priordr=0 
    ...s priority=##class(PHA.COM.Data.Base).OrdPriCode(priordr)             ;医嘱优先级代码              
    ...//q:priority["OM" ;自备药
    ...s statdr=$p(^OEORD(ord,"I",chl,1),"^",13)
    ...s OeUsedepDr=+$p($g(^OEORD(ord,"I",chl,7)),"^",2) //开单科室,根据医嘱需审核科室维护过滤yunhiabao20160318
    ...q:##class(PHA.PRA.Com.Method).IsLocNeedAudit("I", locdr, OeUsedepDr)=$$$NO
    ...S OrdExeRowid=$p(^DHCOEDISQTY(dsp),"^",3)
    ...q:(aduitFlag="")&&(..CheckOEOREStatByOeori(orditm)'=1)   // 已审核不判断
    ...q:(priority'["OUT")&(onlyout="true")
    ...s phaOrdRet=..GetPhaOrdResult(orditm)
    ...s phaOrdFlag=$p(phaOrdRet,"^",1)
    ...s phaOrdDesc=$p(phaOrdRet,"^",2)
    ...Q:(aduitFlag'="")&(phaOrdFlag'="Y")
    ...Q:(aduitFlag="")&(phaOrdFlag="Y")
    ...Q:(aduitFlag="2")&(phaOrdDesc'["拒绝")
    ...q:(pAppealFlag="Y")&&(phaOrdRet'["申诉")
    ...// 过滤-医嘱处理,未审核但拒绝需要显示,其他按配置 
    ...s docLocDispFlag=##class(web.DHCSTPCHCOLLS).DoctorLocRefuse(locdr,OeUsedepDr)
    ...s nurSee=##class(web.DHCSTCOMMONSRV).IfOeoriNurSee(orditm)
    ...q:(DealOrdFlag="Y")&&(docLocDispFlag'="1")&&(admtype="I")&&(phaOrdFlag="")&&(nurSee'="Y")&&(nurSee'="R")
    ...s dodis=..GetDODIS(orditm)  
    ...q:(aduitFlag="")&&(dodis="")
    ...s exist=1
    ..q:exist=0
    ..s index="ward:"_","_admwarddr
    ..s index2=bedno_","_patno_","_patname
    ..s GetAdmWardListDATA("SORT",index,index2)=adm_"^"_warddesc
    s index=""
    f  s index=$o(GetAdmWardListDATA("SORT",index)) q:index=""  d
    .s leafflag="false"
    .s ward="未分配"
    .s warddr=$p(index,"ward:,",2)
    .i warddr'="" s ward=$p(^PAWARD(warddr),"^",2)
    .s index2=""
    .f  s index2=$o(GetAdmWardListDATA("SORT",index,index2)) q:index2=""  d
    ..s data=GetAdmWardListDATA("SORT",index,index2)
    ..s adm=$p(data,"^",1)
    ..;s chkflag=..CheckAdmDrugStauts(adm,input)
    ..;q:chkflag'=1
    ..s warddesc=$p(data,"^",2)
    ..s bedno=$p(index2,",",1)
    ..s patno=$p(index2,",",2)
    ..s patname=$p(index2,",",3)
    ..S PatientID=$P(^PAADM(adm),"^",1)
    ..s sexDr=$p(^PAPER(PatientID,"ALL"),"^",7) 
    ..i sexDr'="" s sex=$p(^CT("SEX",sexDr),"^","2")
    ..s h=h+1
    ..s data=patno_"^"_warddesc_"^"_bedno_"^"_adm_"^"_PatientID
    ..s GetAdmWardListDATA("OUTPUT",h)=data
    q:(h=0)&&(style="") ##class(web.DHCSTEXTCOMMON).GetNoJson()
    q:(h=0) ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
    
    s maxrow=h
    i endpage>maxrow s endpage=maxrow
    s count=0
    s h=""
    f  s h=$o(GetAdmWardListDATA("OUTPUT",h)) q:h=""  d
    .s data=GetAdmWardListDATA("OUTPUT",h)
    .s patno=$p(data,"^",1)
    .s patloc=$p(data,"^",2)
    .s bedno=$p(data,"^",3)
    .s adm=$p(data,"^",4)
    .s papmi=$p(data,"^",5)
    .s count=count+1
    .q:count<stpage
    .q:count>endpage
    .
    .s patno=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("patid",patno)
    .s patloc=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("patloc",patloc)
    .s bedno=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("bedno",bedno)
    .s papmi=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("papmi",papmi)
    .s adm=##class(web.DHCSTJQUERYCOMMON).GetJsonLastCell("adm",adm)
    .
    .s tmpstr=patno_patloc_bedno_papmi_adm
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
    q:startString="" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
    q ""
}

/// w ##class(web.DHCSTCNTSIPMONITOR).GetWardListData("2022-07-11^2022-07-12^184^^^^^","1","100","jqGrid")
ClassMethod GetWardListData(input, stpage, limit, style = "") As %String
{
    // s ^PHATMP("MYQ", $this, "GetWardListData") = $lb(input, stpage, limit, style)
    k GetWardListDataDATA
    q:(input="")&&(style'="") ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
    i style="" d
    .s endpage=stpage+limit
    .s stpage=stpage+1
    i style'="" d
    .s page=stpage
    .s stpage=((stpage-1)*limit)+1
    .s endpage=page*limit
    s datefrom=$p(input,"^",1)
    s datefrom=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(datefrom)
    s dateto=$p(input,"^",2)
    s dateto=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(dateto)
    s locdr=$p(input,"^",3)
    s warddr=$p(input,"^",4)
    s onlyout=$p(input,"^",5)
    s aduitFlag=$p(input,"^",6)
    s slgid=$p(input,"^",7)
    s pApplealFlag = $p(input,"^",8)
    s PhaLocation=$o(^DHCPL(0,"Loc",locdr,""))
    s DealOrdFlag=$p($g(^DHCPL(+PhaLocation)),"^",37)
    s HospID=$p(^CTLOC(locdr),"^",22)
    s lgStrParam = "^"_locdr_"^^"_HospID
    s h=0
    f date=datefrom:1:dateto d
    .s ord=""
    .f  s ord=$o(^OEORDi(0,"LocStDtArr",locdr,0,date,ord)) q:ord=""  d
    ..s exist=0
    ..s adm=$p(^OEORD(ord),"^",1)
    ..s admtype=$p($g(^PAADM(adm)),"^",2)
    ..q:(admtype'="I")&&(admtype'="E")      //过滤非住院病人
    ..q:(##class(web.DHCSTCOMMONSRV).GetCurrentAdmStatus(adm) = 0)  // 出院患者过滤
    ..s wardcode="未分配"
    ..s admwarddr=$p(^PAADM(adm),"^",70) 
    ..s index="ward:"_","_admwarddr
    ..q:..CheckWard(slgid,admwarddr)=0
    ..q:(warddr'=admwarddr)&(warddr'="")&(admwarddr'="")
    ..q:$d(GetWardListDataDATA("SORT",index))
    ..i admwarddr'="" d
    ...s wardcode=##class(PHA.COM.Data.Base).WardCode(admwarddr)
    ...s warddesc=##class(PHA.COM.Data.Base).WardDesc(admwarddr)
    ...i $f(warddesc,"-") s warddesc=$p(warddesc,"-",2)
    ..s papmi=$p(^PAADM(adm),"^",1)
    ..s patname=$p(^PAPER(papmi,"ALL"),"^",1)
    ..s patno=$p(^PAPER(papmi,"PAT",1),"^",1)
    ..s bedno=$p(##class(web.DHCPHACOM.ComPubClass.OrderAndPatInfo).GetAdmBedCode(adm),"^",2)
    ..s chl=""  
    ..f  s chl=$o(^OEORDi(0,"LocStDtArr",locdr,0,date,ord,chl)) q:chl=""  d
    ...s orditm=ord_"||"_chl
    ...s presc=$p(^OEORD(ord,"I",chl,1),"^",14) ;处方号
    ...q:presc=""
    ...s dsp=$o(^DHCOEDISQTY(0,"OEORI",orditm,""))
    ...q:dsp="" 
    ...q:'$d(^DHCOEDISQTY(dsp,"I"))
    ...q:(admtype="E")&&(##class(web.DHCSTCOMMONSRV).GetPayStayStatus(orditm)'="Y")
    ...q:(admtype="E")&&(orditm'=##class(PHA.COM.Order).GetVirtualLongOeori(orditm))
    ...s priordr=+$p(^OEORD(ord,"I",chl,1),"^",8) 
    ...q:priordr=0 
    ...s priority=##class(PHA.COM.Data.Base).OrdPriCode(priordr)           ;医嘱优先级代码              
    ...s statdr=$p(^OEORD(ord,"I",chl,1),"^",13)
    ...s OeUsedepDr=+$p($g(^OEORD(ord,"I",chl,7)),"^",2) //开单科室,根据医嘱需审核科室维护过滤yunhiabao20160318
    ...s basicFlag = "N"
    ...i (($lg(##class(PHA.IP.COM.Method).GetOrderDispWay(orditm),1)="BASEDISP")) d
    ....s basicFlag = "Y"
    ...q:(basicFlag = "N")&&(##class(PHA.PRA.Com.Method).IsLocNeedAudit("I", locdr, OeUsedepDr)=$$$NO)
    ...S OrdExeRowid=$p(^DHCOEDISQTY(dsp),"^",3)
    ...q:(aduitFlag="")&&(..CheckOEOREStatByOeori(orditm)'=1)
    ...q:(priority'["OUT")&(onlyout="true")
    ...s phaOrdRet=..GetPhaOrdResult(orditm)
    ...s phaOrdFlag=$p(phaOrdRet,"^",1)
    ...s phaOrdDesc=$p(phaOrdRet,"^",2)
    ...Q:(aduitFlag'="")&(phaOrdFlag'="Y")
    ...Q:(aduitFlag="")&(phaOrdFlag="Y")
    ...Q:(aduitFlag="2")&(phaOrdDesc'["拒绝")
    ...q:(pApplealFlag="Y")&&(phaOrdRet'["申诉")
    ...// 过滤-医嘱处理,未审核但拒绝需要显示,其他按配置
    ...s docLocDispFlag=##class(web.DHCSTPCHCOLLS).DoctorLocRefuse(locdr,OeUsedepDr)
    ...s nurSee=##class(web.DHCSTCOMMONSRV).IfOeoriNurSee(orditm)
    ...s visitStatus = $p($g(^PAADM(adm)), "^", 20)     // 在院状态
    ...s BaseMedNeedPhaAudit = ##class(web.DHCST.Common.AppCommon).GetAppPropValue("DHCSTCOMMON","BaseMedNeedPhaAudit",lgStrParam)
    ...q:(basicFlag = "Y")&&(BaseMedNeedPhaAudit '= "Y")
    ...q:(DealOrdFlag="Y")&&(docLocDispFlag'="1")&&(admtype="I")&&(phaOrdFlag="")&&(nurSee'="Y")&&(nurSee'="R")&&(basicFlag = "N")&&(visitStatus '= "P")
    ...s dodis=..GetDODIS(orditm)  
    ...q:(dodis="")&&(aduitFlag="")
    ...s GetWardListDataDATA("SORT",index)=""
    s index=""
    f  s index=$o(GetWardListDataDATA("SORT",index)) q:index=""  d
    .s warddesc="未分配"
    .s warddr=$p(index,"ward:,",2)
    .i warddr'="" s warddesc=##class(PHA.COM.Data.Base).WardDesc(warddr)
    .i $f(warddesc,"-") s warddesc=$p(warddesc,"-",2)
    .s h=h+1
    .s data=warddesc_"^"_warddr
    .s GetWardListDataDATA("OUTPUT",h)=data
    q:(h=0)&&(style="") ##class(web.DHCSTEXTCOMMON).GetNoJson()
    q:(h=0) ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
    
    s maxrow=h
    i endpage>maxrow s endpage=maxrow
    s count=0
    s h=""
    f  s h=$o(GetWardListDataDATA("OUTPUT",h)) q:h=""  d
    .s data=GetWardListDataDATA("OUTPUT",h)
    .s warddesc=$p(data,"^",1)
    .s wardid=$p(data,"^",2)
    .
    .s count=count+1
    .q:count<stpage
    .q:count>endpage
    .
    .s warddesc=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("warddesc",warddesc)
    .s wardid=##class(web.DHCSTJQUERYCOMMON).GetJsonLastCell("wardid",wardid)
    .
    .s tmpstr=warddesc_wardid
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
    q:startString="" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
    q ""
}

/// Description:构造树形结构
/// Creator:LiangQiang
ClassMethod GetAdmTreeData(level, id, input) As %String
{
    k GetAdmTreeDataDATA
    s warddr=$p(input,"^",4)
    i level="1" s warddr=id
    s adm=""
    //f  s adm=$o(^PAADMi("PAADM_VisitStatus","A",adm)) q:adm=""  d
    f  s adm=$o(^PAADMi("AdmTypeCurr","I",adm)) q:adm=""  d
    .//s admtype=$p(^PAADM(adm),"^",2)
    .//q:admtype'="I"
    .s wardcode="未分配"
    .s admwarddr=$p(^PAADM(adm),"^",70) 
    .q:(warddr'=admwarddr)&(warddr'="")
    .s index="ward:"_","_admwarddr
    .q:$d(GetAdmTreeDataDATA("SORT",index))&(level="0")
    .s chkflag=..CheckAdmDrugStauts(adm,input)
    .q:chkflag'=1
    .i admwarddr'="" d
    ..s wardcode=##class(PHA.COM.Data.Base).WardCode(admwarddr)
    ..s warddesc=##class(PHA.COM.Data.Base).WardDesc(admwarddr)
    ..i $f(warddesc,"-") s warddesc=$p(warddesc,"-",2)
    .s papmi=$p(^PAADM(adm),"^",1)
    .s patname=$p(^PAPER(papmi,"ALL"),"^",1)
    .s patno=$p(^PAPER(papmi,"PAT",1),"^",1)
    .s bedno=$p(##class(web.DHCPHACOM.ComPubClass.OrderAndPatInfo).GetAdmBedCode(adm),"^",2)
    .s index2=bedno_","_patno_","_patname
    .s GetAdmTreeDataDATA("SORT",index,index2)=adm_"^"_warddesc
    .
    .
    
    w "["
    i level=0 d
    .s currlevel=1
    .s index=""
    .f  s index=$o(GetAdmTreeDataDATA("SORT",index)) q:index=""  d
    ..s leafflag="false"
    ..s ward="未分配"
    ..s warddr=$p(index,"ward:,",2)
    ..i warddr'="" s ward=##class(PHA.COM.Data.Base).WardDesc(warddr)
    ..i $f(ward,"-") s ward=$p(ward,"-",2)
    ..w "{"_"id:'"_warddr_"',text:'"_ward_"',leaf:"_leafflag_",level:'"_currlevel_"'}"
    ..s next=$o(GetAdmTreeDataDATA("SORT",index))
    ..i next'="" w ","
    
    i level=1 d
    .s leafflag="true"
    .s currlevel=2
    .s index="ward:"_","_id
    .s index2=""
    .f  s index2=$o(GetAdmTreeDataDATA("SORT",index,index2)) q:index2=""  d
    ..s data=GetAdmTreeDataDATA("SORT",index,index2)
    ..s adm=$p(data,"^",1)
    ..s chkflag=..CheckAdmDrugStauts(adm,input)
    ..q:chkflag'=1
    ..s warddesc=$p(data,"^",2)
    ..s bedno=$p(index2,",",1)
    ..s patno=$p(index2,",",2)
    ..s patname=$p(index2,",",3)
    ..S PatientID=$P(^PAADM(adm),"^",1)
    ..s sexDr=$p(^PAPER(PatientID,"ALL"),"^",7) 
    ..i sexDr'="" s sex=##class(PHA.COM.Data.Base).SexDesc(sexDr)
    ..i (($g(sex)["男") || ($zcvt($g(sex), "U") = "MALE")) s iconPerson="../scripts/dhcpha/img/man.gif"
    ..e  s iconPerson="../scripts/dhcpha/img/woman.gif"
    ..s desc=bedno_" "_patno_" "_patname
    ..w "{"_"id:'"_adm_"',text:'"_desc_"',leaf:"_leafflag_",level:'"_currlevel_"',icon:'"_iconPerson_"'}"
    ..s next=$o(GetAdmTreeDataDATA("SORT",index,index2))
    ..i next'="" w ","    
    q "]"
}

/// description: 获取住院审核医嘱明细
/// w ##class(web.DHCSTCNTSIPMONITOR).FindIPAdmOrdData("0^2019-06-27^2019-06-27^246^3^^1^",1,50,"jqGrid") 
/// w ##class(web.DHCSTCNTSIPMONITOR).FindIPAdmOrdData("974^2017-05-08^2018-05-08^311^^^^",1,50,"jqGrid")
ClassMethod FindIPAdmOrdData(input, stpage, limit, style = "") As %String
{
    q:(style="jqGrid")&&(input="") ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
    i style="" d
    .s endpage=stpage+limit  //结束行
    .s stpage=stpage+1 //开始行
    i style'="" d
    .s page=stpage
    .s stpage=((stpage-1)*limit)+1 //开始行
    .s endpage=page*limit  //结束行
    s ret=..FindIPAdmOrdDataNum(input)
    s h=$p(ret,"^",1)
    s pid=$p(ret,"^",2)
    q:(h=0)&&(style="jqGrid") ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
    q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s phalocdr=$p(input,"^",4)
    s phahospdr=$p($g(^CTLOC(phalocdr)),"^",22)
    s maxrow=h
    i endpage>maxrow s endpage=maxrow
    s count=0
    s h=""
    f  s h=$o(^||TMP("DHCST",$ClassName(),"FindIPOrdDetailData",pid,h)) q:h=""  d
    .s count=count+1
    .q:count<stpage
    .q:count>endpage
    .s data=^||TMP("DHCST",$ClassName(),"FindIPOrdDetailData",pid,h)
    .s incidesc=$p(data,"^",1)
    .s spec=$p(data,"^",6)
    .s qty=$p(data,"^",2)
    .i $l($p(qty,".",2))>5 d
    ..s qty=##class(web.DHCST.Common.AppCommon).FormatSq(qty,phahospdr,1)
    .s qty=$fn(qty,"N")
    .s uomdesc=$p(data,"^",3)
    .s dosage=$p(data,"^",4)
    .s freq=$p(data,"^",5)
    .s instruc=$p(data,"^",7)
    .s remark=$p(data,"^",13)
    .s price=$p(data,"^",15)
    .s amt=$p(data,"^",16)
    .s skintest=$p(data,"^",18)
    .s:skintest'="" incidesc=skintest_" "_incidesc
    .s pri=$p(data,"^",10)
    .s doctor=$p(data,"^",11)
    .s orddatetime=$p(data,"^",12)
    .s manf=$p(data,"^",14)
    .s price=$p(data,"^",15)
    .s form=$p(data,"^",9)
    .s basflag=$p(data,"^",19)
    .s orditem=$p(data,"^",20)
    .s skintest=##class(web.DHCSTCOMMONORDER).OeoriSkinTestVal(+orditem,+$p(orditem,"||",2))
    .s warningmsg=""
    .i skintest="-1" d
    ..s warningmsg=##class(PHA.FACE.IN.Com).Translate("皮试")_"()"
    .e  i skintest="-2" d
    ..s warningmsg=##class(PHA.FACE.IN.Com).Translate("皮试")_"(+)"
    .e  i skintest="-3" d
    ..s warningmsg=##class(PHA.FACE.IN.Com).Translate("皮试")_"()"
    .s nurSeeStr=##class(web.DHCSTCOMMONSRV).GetNurseSeeType(orditem,phalocdr)
    .i $p(nurSeeStr,"^",2)="R" s warningmsg=$s(warningmsg'="":warningmsg_"<br>"_$p(nurSeeStr,"^",3),1:$p(nurSeeStr,"^",3))
    .s result=$p(data,"^",21)
    .s patid=$p(data,"^",22)
    .s patname=$p(data,"^",23)
    .s mainflag=$p(data,"^",24)
    .s moeori=$p(data,"^",25)
    .s adm=$p(data,"^",26)
    .s papmi=$p($g(^PAADM(adm)),"^",1)
    .s prescNo=$p($g(^OEORD(+moeori,"I",+$p(moeori,"||",2),1)),"^",14)
    .s diagDesc=##class(PHA.FACE.IN.Com).GetMRDiagnosDesc(prescNo,", ")
    .s incidesc=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("incidesc",incidesc)
    .s qty=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("qty",qty)
    .s uomdesc=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("uomdesc",uomdesc)
    .s dosage=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("dosage",dosage)
    .s freq=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("freq",freq)
    .s spec=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("spec",spec)
    .s instruc=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("instruc",instruc)
    .s form=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("form",form)
    .s ordpri=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("ordpri",pri)
    .s basflag=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("basflag",basflag)
    .s doctor=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("doctor",doctor)
    .s orddate=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("orddate",orddatetime)
    .s remark=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("remark",remark)
    .s manf=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("manf",manf)
    .s price=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("price",price)
    .s amt=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("amt",amt)
    .s orditem=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("orditem",orditem)
    .i style="" d
    ..i result="拒绝" s result="result:'<font color=red>"_result_"</font>',"
    ..e  s result=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("result",result)
    .e  s result=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("result",result)
    .s patid=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("patid",patid)
    .s patname=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("patname",patname)
    .s mainflag=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("mainflag",mainflag)
    .s moeori=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("moeori",moeori)
    .s papmi=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("papmi",papmi)
    .s warningmsg=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("warningmsg",warningmsg)
    .s adm=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("adm",adm)
    .s diagDesc=##class(web.DHCSTJQUERYCOMMON).GetJsonLastCell("diagDesc",diagDesc)
    .s tmpstr=incidesc_qty_uomdesc_dosage_freq_spec_instruc_form_ordpri_basflag_doctor_orddate_remark_manf_price_amt_orditem_result
    .s tmpstr=tmpstr_patid_patname_mainflag_moeori_warningmsg_papmi_adm_diagDesc
    .i style="" d
    ..s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    ..s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    ..s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
    .e  i style="jqGrid" d
    ..s startString=##class(web.DHCSTJQUERYCOMMON).getJsonStartStringJqGrid(maxrow,limit)
    ..s firstrow=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstRow(tmpstr)
    ..s lastrow=##class(web.DHCSTJQUERYCOMMON).GetJsonLastRow(tmpstr)
    .i count=stpage w startString
    .i count<endpage w firstrow
    .i count=endpage w lastrow
    k ^||TMP("DHCST",$ClassName(),"FindIPOrdDetailData",pid)
    q:startString="" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
    q ""
}

/// 获取住院审核医嘱明细数量
/// w ##class(web.DHCSTCNTSIPMONITOR).FindIPAdmOrdDataNum("0^2022-06-01^2022-06-10^184^3^^^^")
ClassMethod FindIPAdmOrdDataNum(input) As %String
{
    //s ^PHATMP("MYQ", $this, "FindIPAdmOrdDataNum") = input
    s adm=$p(input,"^",1)
    s phalocdr=$p(input,"^",4)
    s warddr=$p(input,"^",5)
    s onlyout=$p(input,"^",6)
    s aduitFlag=$p(input,"^",7)
    s datefrom=$p(input,"^",2)
    s datefrom=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(datefrom)
    s dateto=$p(input,"^",3)
    s dateto=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(dateto)
    s pAppealFlag=$p(input,"^",9)
    s allOrd="" //$p(input,"^",9)
    s PhaLocation=$o(^DHCPL(0,"Loc",phalocdr,""))
    s DealOrdFlag=$p($g(^DHCPL(+PhaLocation)),"^",37)
    i adm'=0 s ord=$o(^OEORD(0,"Adm",adm,""))
    s HospID=""
    s HospID=$p(^CTLOC(phalocdr),"^",22)
    s lgStrParam = "^"_phalocdr_"^^"_HospID
    s pid=..NewPid()
    s h=0
    s locstr=phalocdr  //..GetPhaLocStr()
    s cnt=$l(locstr,"^")
    f i=1:1:cnt d
    .q:adm=0
    .s admord=$o(^OEORD(0,"Adm",adm,""))
    .q:admord=""
    .s admtype=$p($g(^PAADM(adm)),"^",2)
    .q:(admtype'="I")&&(admtype'="E")       //过滤非住院病人
    .s admpapmi=$p(^PAADM(adm),"^",1)
    .q:(##class(web.DHCSTCOMMONSRV).GetCurrentAdmStatus(adm) = 0)   // 出院患者过滤
    .s locdr=$p(locstr,"^",i)
    .i (HospID="")&(locdr'="") s HospID=$p($g(^CTLOC(locdr)),"^",22)
    .f date=datefrom:1:dateto d
    ..s ord=""
    ..f  s ord=$o(^OEORDi(0,"LocStDtArr",locdr,0,date,ord)) q:ord=""  d
    ...q:(allOrd="0")&&(ord'=admord)
    ...s ordadm=$p(^OEORD(ord),"^",1)
    ...s papmi=$p(^PAADM(ordadm),"^",1)
    ...q:papmi'=admpapmi
    ...s chl=""  
    ...f  s chl=$o(^OEORDi(0,"LocStDtArr",locdr,0,date,ord,chl)) q:chl=""  d
    ....s orditm=ord_"||"_chl
    ....d getitmdata
    
    f i=1:1:cnt d
    .q:adm'=0
    .s locdr=$p(locstr,"^",i)
    .i (HospID="")&(locdr'="") s HospID=$p($g(^CTLOC(locdr)),"^",22)
    .f date=datefrom:1:dateto d
    ..s ord=""
    ..f  s ord=$o(^OEORDi(0,"LocStDtArr",locdr,0,date,ord)) q:ord=""  d
    ...s adm=$p(^OEORD(ord),"^",1)
    ...s admtype=$p($g(^PAADM(adm)),"^",2)
    ...q:(admtype'="I")&&(admtype'="E")     //过滤非住院病人
    ...s admwarddr=$p(^PAADM(adm),"^",70)
    ...q:admwarddr'=warddr
    ...q:(##class(web.DHCSTCOMMONSRV).GetCurrentAdmStatus(adm) = 0) // 出院患者过滤
    ...s chl=""  
    ...f  s chl=$o(^OEORDi(0,"LocStDtArr",locdr,0,date,ord,chl)) q:chl=""  d
    ....s orditm=ord_"||"_chl
    ....d getitmdata
    
    s h=0
    s index=""
    f  s index=$o(^||TMP("DHCST",$ClassName(),"OrdDetailData",pid,index)) q:index=""  d
    .s num=""
    .f  s num=$o(^||TMP("DHCST",$ClassName(),"OrdDetailData",pid,index,num)) q:num=""  d
    ..s data=^||TMP("DHCST",$ClassName(),"OrdDetailData",pid,index,num)
    ..s h=h+1
    ..s ^||TMP("DHCST",$ClassName(),"FindIPOrdDetailData",pid,h)=data
        
    k ^||TMP("DHCST",$ClassName(),"OrdDetailData",pid)
    q h_"^"_pid
    
getitmdata

    s presc=$p(^OEORD(ord,"I",chl,1),"^",14) ;处方号
    s dsp=$o(^DHCOEDISQTY(0,"OEORI",orditm,""))
    q:dsp="" 
    q:(admtype="E")&&(orditm'=##class(PHA.COM.Order).GetVirtualLongOeori(orditm)) // 产品部要求, 虚拟长期只处理原始医嘱, yunhaibao20211025
    //q:'$d(^DHCOEDISQTY(dsp,"I"))
    s papmi=$p(^PAADM(adm),"^",1)
    s patname=$p(^PAPER(papmi,"ALL"),"^",1)
    s patid=$p(^PAPER(papmi,"PAT",1),"^",1)
    s bedno=$p(##class(web.DHCPHACOM.ComPubClass.OrderAndPatInfo).GetAdmBedCode(adm),"^",2)
    q:(admtype="E")&&(##class(web.DHCSTCOMMONSRV).GetPayStayStatus(orditm)'="Y")
    s priordr=+$p(^OEORD(ord,"I",chl,1),"^",8) 
    q:priordr=0 
    s priority=$p(^OECPR(priordr),"^",1)            ;医嘱优先级代码              
    //q:priority["OM" ;自备药
    s statdr=$p(^OEORD(ord,"I",chl,1),"^",13)
    s OeUsedepDr=+$p($g(^OEORD(ord,"I",chl,7)),"^",2) //开单科室,根据医嘱需审核科室维护过滤yunhiabao20160318
    s basicFlag = "N"
    i ($lg(##class(PHA.IP.COM.Method).GetOrderDispWay(orditm),1)="BASEDISP") d
    .s basicFlag = "Y"
    q:(basicFlag = "N")&&(##class(PHA.PRA.Com.Method).IsLocNeedAudit("I", locdr, OeUsedepDr)=$$$NO)
    S OrdExeRowid=$p(^DHCOEDISQTY(dsp),"^",3)
    q:(aduitFlag="")&&(..CheckOEOREStatByOeori(orditm)'=1)
    q:(priority'["OUT")&(onlyout="true") 
    s phaOrdRet=..GetPhaOrdResult(orditm)
    s phaOrdFlag=$p(phaOrdRet,"^",1)
    s phaOrdDesc=$p(phaOrdRet,"^",2)
    Q:(aduitFlag'="")&(phaOrdFlag'="Y")
    Q:(aduitFlag="")&(phaOrdFlag="Y")
    Q:(aduitFlag="2")&(phaOrdDesc'["拒绝")
    q:(pAppealFlag="Y")&&(phaOrdRet'["申诉")
    // 过滤-医嘱处理,未审核但拒绝需要显示,其他按配置
    s docLocDispFlag=##class(web.DHCSTPCHCOLLS).DoctorLocRefuse(locdr,OeUsedepDr)
    s nurSee=##class(web.DHCSTCOMMONSRV).IfOeoriNurSee(orditm)
    s BaseMedNeedPhaAudit = ##class(web.DHCST.Common.AppCommon).GetAppPropValue("DHCSTCOMMON","BaseMedNeedPhaAudit",lgStrParam)
    q:(basicFlag = "Y")&&(BaseMedNeedPhaAudit '= "Y")
    s visitStatus = $p($g(^PAADM(adm)), "^", 20)        // 在院状态
    // 预住院患者不判断是否处理医嘱 MaYuqiang 20220728
    q:(DealOrdFlag="Y")&&(docLocDispFlag'="1")&&(admtype="I")&&(phaOrdFlag="")&&(nurSee'="Y")&&(nurSee'="R")&&(basicFlag = "N")&&(visitStatus '= "P")
    s dodis=..GetDODIS(orditm)  
    q:(aduitFlag="")&&(dodis="")
    s arcimid=$p(^OEORD(ord,"I",chl,1),"^",2)  ;医嘱 ARC_ItmMast ARCIM_RowId
    s itmmastid=$p(arcimid,"||",1)
    s itmmastver=$p(arcimid,"||",2)
    s phcdfId = $p(^ARCIM(itmmastid, 1, 1), "^", 12)
    s inciDesc=##class(PHA.COM.Data.Base).ArcimDesc(arcimid)
    s qtyData = ##class(PHA.COM.Order).GetOrderQtyUomByDsp(dsp)
    s qty = $lg(qtyData,1)
    s uomdesc = $lg(qtyData,3)
    s dosage=##class(web.DHCSTCOMMONORDER).OeoriDosage(orditm)
    s freq=$p(##class(web.DHCSTCOMMONORDER).OeoriFreq(orditm),"^",4)
    s instru=$p(##class(web.DHCSTCOMMONORDER).OeoriInstruc(orditm),"^",2)
    s duration=$p(##class(web.DHCSTCOMMONORDER).OeoriDuration(orditm),"^",2)
    s priorty=$p(##class(web.DHCSTCOMMONORDER).OeoriPriority(orditm),"^",3)
    s doctor=$p(##class(web.DHCSTCOMMONORDER).OeoriDoctor(orditm),"^",2)
    s skintest=$p(##class(web.DHCSTCOMMONORDER).OeoriSkinTest(orditm),"^",2)
    s form=$lg(##class(PHA.COM.Drug).GetForm("", arcimid),3)
    s spec="" //##class(web.DHCSTCOMMONSRV).getBarcode(inci) ;规格
    s manf="" //##class(web.DHCSTITMDESC).GetManfNameByInci(inci) ;厂家
    s Notes=$g(^OEORD(ord,"I",chl,"DEP",1)) ;医嘱备注
    s remark=$p($g(^OEORD(ord,"I",chl,2)),"^",8) //草药备注
    S Notes=$tr($tr($tr(Notes,$c(10)),$C(13))," ")
    i Notes'="" d
    .i remark'="" d
    ..s Notes=Notes_"("_remark_")"
    e  i remark'="" d
    .s Notes=remark
    .
    s remark=Notes
    s orddatetime=##class(web.DHCSTCOMMONORDER).OeoriDateTime(orditm)
    s status=$p(^DHCOEDISQTY(dsp),"^",7)
    s price=""
    s amt=""
    s dspdate=+$h
    i status="C" s dspdate=$p(^DHCOEDISQTY(dsp),"^",8)
    s specinstr=$p($g(^OEORD(ord,"I",chl,2)),"^",8)
    s basflag=$p(^PHCD(+phcdfId,"DF",$P(phcdfId,"||",2),"DHC"),"^",31) //基本药物标志
    s basflag=$s(basflag="Y":"是",1:"")
    s moeori=##class(web.DHCSTCNTSCOMMON).GetMainOeori(orditm)
    s result=phaOrdDesc 
    i moeori'=orditm d
    .s mainflag=0
    .s inciDesc="_____"_inciDesc
    e  d
    .s mainflag=1 
    s h=h+1
    s data=inciDesc_"^"_qty_"^"_uomdesc_"^"_dosage_"^"_freq_"^"_spec_"^"_instru_"^"_duration_"^"_form
    s data=data_"^"_priorty_"^"_doctor_"^"_orddatetime_"^"_remark_"^"_manf_"^"_price_"^"_amt_"^"_specinstr_"^"_skintest
    s data=data_"^"_basflag_"^"_orditm_"^"_result_"^"_patid_"^"_patname_"^"_mainflag_"^"_moeori_"^"_adm
    s index=bedno_"^"_adm_"^"_orddatetime_"^"_moeori_"^"_orditm
    s ^||TMP("DHCST",$ClassName(),"OrdDetailData",pid,index,h)=data
    q ""
}

/// 获取可发药的dsp序列
ClassMethod GetDODIS(oeori) As %String
{
     s dodis=##class(web.DHCSTPCHCOLLS).GetDODIS(oeori,"1")
     q dodis
}

/// 检查就诊是否有未发药医嘱
/// 1符合，0 不符
ClassMethod CheckAdmDrugStauts(adm, input) As %String
{
    s datefrom=$p(input,"^",1)
    s datefrom=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(datefrom)
    s dateto=$p(input,"^",2)
    s dateto=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(dateto) 
    s locstr=$p(input,"^",3)
    s warddr=$p(input,"^",4)
    s onlyout=$p(input,"^",5)
    s onlyadt=$p(input,"^",6)
    s ord=$o(^OEORD(0,"Adm",adm,""))
    q:ord="" 0
    s exist=0
    //s locstr=##class(web.DHCSTCNTSIPDATA).GetPhaLocStr()
    s cnt=$l(locstr,"^")
    f i=1:1:cnt d
    .s locdr=$p(locstr,"^",i)
    .f date=datefrom:1:dateto d
    ..s chl=""  
    ..f  s chl=$o(^OEORDi(0,"LocStDtArr",locdr,0,date,ord,chl)) q:(chl="")||(exist=1)  d
    ...s orditm=ord_"||"_chl
    ...s presc=$p(^OEORD(ord,"I",chl,1),"^",14) ;处方号
    ...q:presc=""
    ...s dsp=$o(^DHCOEDISQTY(0,"OEORI",orditm,""))
    ...q:dsp="" 
    ...s priordr=+$p(^OEORD(ord,"I",chl,1),"^",8) 
    ...q:priordr=0 
    ...s priority=$p(^OECPR(priordr),"^",1)             ;医嘱优先级代码              
    ...q:priority["OM" ;自备药
    ...s statdr=$p(^OEORD(ord,"I",chl,1),"^",13)
    ...s oeflag=$p(^OEC("OSTAT",statdr),"^",1) 
    ...q:(oeflag'="V")&(oeflag'="E")
    ...q:(priority'["OUT")&(onlyout="true")
    ...s result=##class(web.DHCSTCNTSCOMMON).GetOrdAuditResult(orditm)
    ...q:(onlyadt="true")&(result="")
    ...q:(onlyadt'="true")&(result'="")
    ...s dodis=..GetDODIS(orditm)  q:dodis="" 
    ...s exist=1
    q exist
}

/// 保存医嘱发药前审核结果
/// 2019-04-02,必然插入一条主医嘱记录,且为第一条
/// reasonstr组织字符串 ：原因ID1^原因ID2 $$$ 药品ID1 $$$ 药品ID2 ! 原因ID3^ ... 
/// w ##class(web.DHCSTCNTSIPMONITOR).SaveAuditResult("","Y^10213^^^^38^138||72^IA","")
ClassMethod SaveAuditResult(reasonstr, input, prescno = "") As %String
{
    k SaveAuditResultDATA
    s result=$p(input,"^",1) 
    i result="N" s status="SHJJ"
    i result="Y" s status="SHTG"
    s user=$p(input,"^",2)
    s phanote=$p(input,"^",5)
    s oeori=$p(input,"^",7) 
    s apptype=$p(input,"^",8) 
    s currdate=+$h
    s currtime=$p($h,",",2)
    s ord=$p(oeori,"||",1)
    s itm=$p(oeori,"||",2)
    s adm=$p(^OEORD(ord),"^",1)
    s doctor=$p($g(^OEORD(ord,"I",itm,1)),"^",11)
    s phalocdr=$p(^OEORD(ord,"I",itm,3),"^",6)
    s nurSeeStr=##class(web.DHCSTCOMMONSRV).GetNurseSeeType(oeori,phalocdr)
    s seeFlag=$p(nurSeeStr,"^",1)
    q:seeFlag="N" "-1^"_$p(nurSeeStr,"^",3)_",无法操作"
    s HospId=$p($g(^CTLOC(phalocdr)),"^",22)
    s Params="^"_phalocdr_"^^"_HospId
    s NeedSkinTest=##class(web.DHCST.Common.AppCommon).GetAppPropValue("DHCSTORDDISP","SKINTESTFLAG",Params) //皮试配置,为Y时需要判断,yunhaibao20160531
    s PositiveDrugCanDispFlag=##class(web.DHCST.Common.AppCommon).GetAppPropValue("DHCSTORDDISP","IfPositiveDrugAllowDisp",Params) //皮试阳性皮试用法是否允许发药配置 zouxiang 20220412
    s mainorditm=##class(web.DHCSTCNTSCOMMON).GetMainOeori(oeori)
    s arcimId=$p(^OEORD(ord,"I",itm,1),"^",2)
    s arcimDesc=$p($g(^ARCIM(+arcimId,1,1)),"^",2)
    s patInfo=##class(web.DHCPHACOM.ComPubClass.OrderAndPatInfo).GetPatInfo(adm)
    s patName=$p(patInfo,"^",3)
    s ord=$p(mainorditm,"||",1)
    s chl=$p(mainorditm,"||",2)
    s pid=##class(web.DHCSTCNTSCOMMON).GetPHCNTSPID()
    // 医嘱及其关联医嘱的皮试结果 Huxt 2020-04-20
    s instSkinTestFlag = ##class(PHA.COM.Order).IsInstForSkinTest(mainorditm)  //医嘱及其关联医嘱中是否存在用法为皮试的药品(有一个满足则允许发药/审核)
    s skinTestErr = ""
    s skinTestRet = ##class(PHA.COM.Order).OeoriSkinTest(mainorditm)
    i $p(skinTestRet,"^",1)<0 d
    .q:(PositiveDrugCanDispFlag="Y")&(instSkinTestFlag="Y")
    .s skinTestErr = "医嘱:"_arcimDesc_"皮试非阴性"
    s ordChl=""
    f  s ordChl=$O(^OEORDi(0,"OEORI",ord,mainorditm,ordChl)) Q:ordChl=""  d
    .s skinTestRet = ##class(PHA.COM.Order).OeoriSkinTest(ord_"||"_ordChl)
    .q:$p(skinTestRet,"^",1)>=0
    .q:(PositiveDrugCanDispFlag="Y")&(instSkinTestFlag="Y")
    .s arcimId = $p(^OEORD(ord,"I",ordChl,1),"^",2)
    .s arcimDesc = $p($g(^ARCIM(+arcimId,1,1)),"^",2)
    .i skinTestErr="" d
    ..s skinTestErr = "医嘱:"_arcimDesc_"皮试非阴性"
    .e  d
    ..s skinTestErr = skinTestErr_"<br/>"_"医嘱:"_arcimDesc_"皮试非阴性"
    q:(NeedSkinTest="Y")&&(status="SHTG")&&(skinTestErr'="") "-1^"_patName_":<br/>"_skinTestErr_"<br/>不能审核通过"
    s:(prescno'="")&&($F(reasonstr,"$$$")=0) reasonstr=reasonstr_"$$$"_mainorditm
    // 判断发药
    q:..IfOrderDisped(mainorditm)="Y" "-20^医嘱已发药"
    // 构造关联全部医嘱集合
    s subitmstr=""
    s tmpchl=""
    F  S tmpchl=$O(^OEORDi(0,"OEORI",ord,mainorditm,tmpchl)) Q:tmpchl=""  d
    .s orditem=ord_"||"_tmpchl
    .s tmpprescno=$p(^OEORD(ord,"I",tmpchl,1),"^",14)
    .q:(prescno'="")&&(prescno'=tmpprescno)     //草药过滤掉非药品医嘱
    .s SaveAuditResultDATA(orditem)=""
    tstart
    s err=0
    s maindsp=$o(^DHCOEDISQTY(0,"OEORI",mainorditm,""))
    k PLIST
    s PLIST(2)=user
    s PLIST(3)=result
    s PLIST(4)=currdate
    s PLIST(5)=currtime
    s PLIST(6)=phalocdr
    s PLIST(7)=phanote
    s PLIST(10)=apptype
    &sql(INSERT INTO DHC_PHAORDMONITOR  VALUES :PLIST())
    i SQLCODE'=0  tro 
    i SQLCODE'=0 s err=1
    q:err'=0 -2
    s phaomr=+%ROWID
    s data=user_","_currdate_","_currtime_","_status
    s $p(^OEORD(ord,"I",chl,7),"^",3)=data
    s tmpstr=reasonstr
    s cnt=$l(tmpstr,"!")
    i reasonstr="" s cnt=0
    i result="N" d
    .k PLIST
    .s PLIST(0)=phaomr
    .s PLIST(2)=mainorditm
    .s PLIST(5)=+$o(^DHCPHORDM(phaomr,"I",""),-1)+1
    .s PLIST(6)=$p(^OEORD(+mainorditm,"I",$p(mainorditm,"||",2),1),"^",14)
    .s PLIST(7)=adm
    .&sql(INSERT INTO DHC_PHAORDMONITORLIST  VALUES :PLIST())
    .i SQLCODE'=0  tro 
    .i SQLCODE'=0 s err=1
    q:err'=0 -1
    f h=1:1:cnt q:err'=0  d
    .s splitstr=$p(tmpstr,"!",h)
    .s grpno=h
    .s tmpreasonstr=$p(splitstr,"$$$",1)
    .q:tmpreasonstr=""
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
    ...s PLIST(6)=$p(^OEORD(ord,"I",chl,1),"^",14)
    ...s PLIST(7)=adm
    ...&sql(INSERT INTO DHC_PHAORDMONITORLIST  VALUES :PLIST())
    ...i SQLCODE'=0  tro 
    ...i SQLCODE'=0 s err=1
    ...q:SQLCODE'=0
    ...i result="N" s status="SHJJ"
    ...s data=user_","_currdate_","_currtime_","_status
    ...s $p(^OEORD(ord,"I",chl,7),"^",3)=data
    q:err'=0 -1
    //插入其余关联医嘱拒绝
    s orditem=""
    F  S orditem=$O(SaveAuditResultDATA(orditem)) Q:orditem=""  d
    .s data=user_","_currdate_","_currtime_","_status
    .s ord=$p(orditem,"||",1)   //zhouyg 20141215
    .s chl=$p(orditem,"||",2)
    .s $p(^OEORD(ord,"I",chl,7),"^",3)=data
    //审核通过,只插一条记录
    i result="Y" d
    .k PLIST
    .s PLIST(0)=phaomr
    .s PLIST(2)=mainorditm
    .s PLIST(3)=1
    .s PLIST(5)=+$o(^DHCPHORDM(phaomr,"I",""),-1)+1
    .s PLIST(6)=$p(^OEORD(+mainorditm,"I",$p(mainorditm,"||",2),1),"^",14)
    .s PLIST(7)=adm
    .&sql(INSERT INTO DHC_PHAORDMONITORLIST  VALUES :PLIST())
    .i SQLCODE'=0  tro 
    .i SQLCODE'=0 s err=1
    .q:SQLCODE'=0
    .s orditem=""
    .f  s orditem=$o(SaveAuditResultDATA(orditem)) q:orditem=""  d
    ..k PLIST
    ..s PLIST(0)=phaomr
    ..s PLIST(2)=orditem
    ..s PLIST(3)=1
    ..s PLIST(5)=+$o(^DHCPHORDM(phaomr,"I",""),-1)+1
    ..s PLIST(6)=$p(^OEORD(+orditem,"I",$p(orditem,"||",2),1),"^",14)
    ..s PLIST(7)=adm
    ..&sql(INSERT INTO DHC_PHAORDMONITORLIST  VALUES :PLIST())
    ..i SQLCODE'=0  tro 
    ..i SQLCODE'=0 s err=1
    ..q:SQLCODE'=0  
    q:err'=0 -1
    tcommit
    // 更新上一次记录为作废
    s lastMonitor=$o(^DHCPHORDM(0,"OrdItem",mainorditm,phaomr),-1)
    i lastMonitor'="" d
    .s lastMonitorData=$g(^DHCPHORDM(lastMonitor))
    .s status=$p(lastMonitorData,"^",2)
    .s DocNote=$p(lastMonitorData,"^",7)
    .s agreeflag=$p(lastMonitorData,"^",8)
    .i (status="N")&(DocNote="")  d  //之前是审核拒绝  
    ..&SQL(update DHC_PHAORDMONITOR set PHAOM_CancelUser_Dr=:user,PHAOM_CancelDate=:currdate,PHAOM_CancelTime=:currtime where PHAOM_RowId=:lastMonitor) 
    ..s execret=##class(web.DHCSTInterfaceMessage).SendRefuseOrderMonitor(lastMonitor,"Exec")
    //发送消息至基础平台,yunhaibao20160815
    s ret1=##class(web.DHCSTInterfaceMessage).SendAppealOrderMonitor(phaomr,"Exec")
    i result="N"  s ret2=##class(web.DHCSTInterfaceMessage).SendRefuseOrderMonitor(phaomr,"Send")
    ;草药处方需要插入处方追踪信息！
    i prescno'=""  d
    .i result="Y" d
    ..s SqlStr="^^"_prescno_"^C1^"_phalocdr_"^"_user
    .e  d
    ..s SqlStr="^^"_prescno_"^C2^"_phalocdr_"^"_user
    .job ##class(web.DHCINPHA.HMPresTrack.SqlDbPresTrack).HandlePresTrackDB(SqlStr)
    s mMainOeoriD(mainorditm) = ""
    s systemStatusCode = $s(result = "Y": "PR", 1 : "RPR")
    d ##class(PHA.IP.COM.Face).UpdateSystemStatus4LinkOrder(.mMainOeoriD, systemStatusCode, user, phalocdr)
    q 0
}

/// 取点评记录日志
/// w ##class(web.DHCSTCNTSIPMONITOR).GetIPOrdAuditLog("2000||9",0,200,"style")
ClassMethod GetIPOrdAuditLog(orditem, stpage, limit, style = "") As %String
{
    k GetIPOrdAuditLogDATA
    s endpage=stpage+limit  //结束行
    s stpage=stpage+1 //开始行
    q:(orditem="")&&(style'="") ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
    q:orditem="" ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s orditem=##class(web.DHCSTCNTSCOMMON).GetMainOeori(orditem)    
    s h=0
    s ord=+orditem
    s chl=$p(orditem,"||",2)
    s adm=$p(^OEORD(ord),"^",1)
    s admtype=$p(^PAADM(adm),"^",2)
    i admtype'="I" d
    .s prescno=$p(^OEORD(ord,"I",chl,1),"^",14) 
    .s phor=""
    .F  S phor=$O(^DHCPHORDM(0,"PrescNo",prescno,phor),-1) Q:phor=""  d
    ..d getData
    e  d
    .s mainorditm=##class(web.DHCSTCNTSCOMMON).GetMainOeori(orditem)
    .s tmpstr=mainorditm
    .s tmpchl=""
    .F  S tmpchl=$O(^OEORDi(0,"OEORI",ord,mainorditm,tmpchl)) Q:tmpchl=""  d
    ..s orditem=ord_"||"_tmpchl
    ..s tmpstr=tmpstr_"^"_orditem
    .s cnt=$l(tmpstr,"^")
    .f i=1:1:cnt d
    ..s orditem=$p(tmpstr,"^",i)
    ..s phor=""
    ..F  S phor=$O(^DHCPHORDM(0,"OrdItem",orditem,phor),-1) Q:phor=""  d
    ...s GetIPOrdAuditLogDATA("ROWID",phor)=""
    .s phor=""
    .f  s phor=$o(GetIPOrdAuditLogDATA("ROWID",phor),-1) q:phor=""  d
    ..d getData
    q:(h=0)&&(style="") ##class(web.DHCSTEXTCOMMON).GetNoJson()
    q:(h=0) ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
    
    s maxrow=h
    i endpage>maxrow s endpage=maxrow
 
    s count=0
    s h=""
    f  s h=$o(GetIPOrdAuditLogDATA("DATA",h)) q:h=""  d
    .s data=GetIPOrdAuditLogDATA("DATA",h)
    .s auditdate=$p(data,"^",2)
    .s audittime=$p(data,"^",3)
    .s audituser=$p(data,"^",1)
    .s result=$p(data,"^",4)
    .s factor=$p(data,"^",6)
    .s advice=$p(data,"^",5)
    .s docadvice=$p(data,"^",8)
    .s phnote=$p(data,"^",7)
    .s docnote=$p(data,"^",9)
    .s rowid=$p(data,"^",10)
    .s count=count+1
    .q:count<stpage
    .q:count>endpage
    .s auditdate=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("auditdate",auditdate)
    .s audittime=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("audittime",audittime)
    .s audituser=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("audituser",audituser)
    .s result=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("result",result)
    .s factor=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("factor",factor)
    .s advice=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("advice",advice)
    .s docadvice=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("docadvice",docadvice)
    .s phnote=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("phnote",phnote)
    .s docnote=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("docnote",docnote)
    .s rowid=##class(web.DHCSTJQUERYCOMMON).GetJsonLastCell("rowid",rowid)
    .
    .s tmpstr=auditdate_audittime_audituser_result_factor_advice_docadvice_phnote_docnote_rowid
    .
    .i style="" s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .e  s startString=##class(web.DHCSTJQUERYCOMMON).getJsonStartStringJqGrid(maxrow,endpage)
    .s firstrow=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTJQUERYCOMMON).GetJsonLastRow(tmpstr)
    .i count=stpage w startString
    .i count<endpage w firstrow
    .i count=endpage w lastrow
    q ""   
getData 
    s Audituser=""
    s userdr=$p(^DHCPHORDM(phor),"^",1)
    s:userdr'="" Audituser=$p(^SSU("SSUSR",userdr),"^",2)
    s canceluser=$p(^DHCPHORDM(phor),"^",12)
    s result=$p(^DHCPHORDM(phor),"^",2)
    s apptype=$p(^DHCPHORDM(phor),"^",9)
    s agreeflag=$p(^DHCPHORDM(phor),"^",8)
    q:apptype="OR"
    i apptype="OR" s result="拒绝发药"
    e  i (apptype="OA")||(apptype="IA") d
    .i result="Y" s result="通过"
    .e  i result="N" d
    ..i agreeflag="Y" s result="拒绝(接受)"
    ..e  s result="拒绝"
    .e  i result="A" s result="申诉"
    i canceluser'="" s result=result_"(已撤消)"
    i result=""  s result="撤消"
    s Auditdate=$p(^DHCPHORDM(phor),"^",3)
    i Auditdate'="" s Auditdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(Auditdate)
    s Audittime=$p(^DHCPHORDM(phor),"^",4)
    i Audittime'="" s Audittime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(Audittime,"IP")
    s advice="" //$p(^DHCPHORDM(phor),"^",6)
    s docadvice=$p(^DHCPHORDM(phor),"^",7)
    s factor="" //$p(^DHCPHORDM(phor),"^",7)
    s phnote=$p(^DHCPHORDM(phor),"^",6)
    s docnote="" //$p(^DHCPHORDM(phor),"^",10)
    s rowid=phor
    s data=Audituser_"^"_Auditdate_"^"_Audittime_"^"_result_"^"_advice_"^"_factor_"^"_phnote_"^"_docadvice_"^"_docnote_"^"_rowid
    s h=h+1
    s GetIPOrdAuditLogDATA("DATA",h)=data
    q
}

/// 取点评记录日志
/// w ##class(web.DHCSTCNTSIPMONITOR).GetIPOrdAuditItmLog("1993",0,200,"jqGrid")
ClassMethod GetIPOrdAuditItmLog(phomdr, stpage, limit, style = "") As %String
{
    k GetIPOrdAuditItmLogDATA
    s endpage=stpage+limit  //结束行
    s stpage=stpage+1 //开始行
    q:(phomdr="")&&(style'="") ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
    q:phomdr="" ##class(web.DHCSTEXTCOMMON).GetNoJson()
    q:($p(^DHCPHORDM(phomdr),"^",2)="Y")&&(style'="") ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
    q:$p(^DHCPHORDM(phomdr),"^",2)="Y" ##class(web.DHCSTEXTCOMMON).GetNoJson()    
    s h=0
    s sub=""
    F  S sub=$O(^DHCPHORDM(phomdr,"I",sub)) Q:sub=""  d
    .s grpno=$p(^DHCPHORDM(phomdr,"I",sub),"^",1)
    .i grpno="" s grpno="-"
    .s orditm=$p(^DHCPHORDM(phomdr,"I",sub),"^",2)
    .q:orditm=""
    .s reasondr=$p(^DHCPHORDM(phomdr,"I",sub),"^",3)
    .q:reasondr=""
    .s index=grpno_","_reasondr
    .s GetIPOrdAuditItmLogDATA("REA",grpno,index)=""
    .s GetIPOrdAuditItmLogDATA("ITM",grpno,orditm)=""   
    s grpno=""
    f  s grpno=$o(GetIPOrdAuditItmLogDATA("REA",grpno)) q:grpno=""  d
    .s index=""
    .f  s index=$o(GetIPOrdAuditItmLogDATA("REA",grpno,index)) q:index=""  d
    ..s reason=""
    ..s reasondr=$p(index,",",2)
    ..i reasondr'="" s reason=$p(^DHCPCREASON(reasondr),"^",2)
    ..s itmdesc=reason
    ..s data=grpno_"^"_itmdesc
    ..i itmdesc'="" d
    ...s h=h+1
    ...s GetIPOrdAuditItmLogDATA("DATA",h)=data
    .s orditm=""
    .f  s orditm=$o(GetIPOrdAuditItmLogDATA("ITM",grpno,orditm)) q:orditm=""  d
    ..s ord=$p(orditm,"||",1)
    ..s ordchl=$p(orditm,"||",2)
    ..s arcimid=$p(^OEORD(ord,"I",ordchl,1),"^",2)  ;医嘱 ARC_ItmMast ARCIM_RowId
    ..s itmmastid=$p(arcimid,"||",1)
    ..s itmmastver=$p(arcimid,"||",2)
    ..s inciDesc=$p(^ARCIM(itmmastid,itmmastver,1),"^",2)
    ..i grpno'="-" s itmdesc="└──"_inciDesc
    ..e  s itmdesc=inciDesc
    ..s h=h+1
    ..s data=grpno_"^"_itmdesc
    ..s GetIPOrdAuditItmLogDATA("DATA",h)=data
    
    q:(h=0)&&(style'="") ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
    q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    
    s maxrow=h
    i endpage>maxrow s endpage=maxrow
 
    s count=0
    s h=""
    f  s h=$o(GetIPOrdAuditItmLogDATA("DATA",h)) q:h=""  d
    .s data=GetIPOrdAuditItmLogDATA("DATA",h)
    .s grpno=$p(data,"^",1)
    .s itmdesc=$p(data,"^",2)
    .
    .s count=count+1
    .q:count<stpage
    .q:count>endpage
    .
    .s grpno=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("grpno",grpno)
    .s itmdesc=##class(web.DHCSTJQUERYCOMMON).GetJsonLastCell("itmdesc",itmdesc)
    .
    .s tmpstr=grpno_itmdesc
    .
    .i style="" s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .e  s startString=##class(web.DHCSTJQUERYCOMMON).getJsonStartStringJqGrid(maxrow,endpage)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
    .
    .i count=stpage w startString
    .i count<endpage w firstrow
    .i count=endpage w lastrow
    q ""
}

/// Description: 撤消审核结果
/// 修改规则:2019-04-02,yunhaibao,撤销更新记录,最终结果以最后一次不是撤消的为准
/// w ##class(web.DHCSTCNTSIPMONITOR).CancelPhOrdAudit("10213^407")
ClassMethod CancelPhOrdAudit(Input) As %String
{
    s user=$p(Input,"^",1)
    s ordmr=$p(Input,"^",2)
    s currdate=+$h
    s currtime=$p($h,",",2)   
    s canceluser=$p(^DHCPHORDM(ordmr),"^",12)
    q:canceluser'="" -99
    s result=$p(^DHCPHORDM(ordmr),"^",2)
    q:result="" -99   //不能重复撤消
    s phalocdr=$p(^DHCPHORDM(ordmr),"^",5)
    s phdocnote=$p(^DHCPHORDM(ordmr),"^",7)
    q:(result="A")&&(phdocnote'="") -19 ; 申诉状态不允许撤消,继续拒绝或者通过
    
    s agreeFlag=$p(^DHCPHORDM(ordmr),"^",8)
    q:(result="N")&&(agreeFlag="Y") -21 ; 拒绝(接受)状态不允许撤消
    //判断是否门诊数据
    s outflag=0
    s tmpSub=$o(^DHCPHORDM(ordmr,"I",""))
    s orditm=$p(^DHCPHORDM(ordmr,"I",tmpSub),"^",2)
    i orditm="" s outflag=1
    e  d
    .s adm=$p(^OEORD(+orditm),"^",1)
    .s admtype=$p(^PAADM(adm),"^",2)
    .i admtype'="I" s outflag=1
    q:outflag="1" ##class(web.DHCSTCNTSOUTMONITOR).CancelOPOrdAudit(Input) //门诊取消审核
    s pid=##class(web.DHCSTCNTSCOMMON).GetPHCNTSPID()
    //住院取消审核
    s lastsub=$O(^DHCPHORDM(ordmr,"I",""),-1)
    s lastorditm=$p(^DHCPHORDM(ordmr,"I",lastsub),"^",2)
    s mOeori=##class(web.DHCSTCNTSCOMMON).GetMainOeori(lastorditm)
    q:..IfOrderDisped(mOeori)="Y" -20   
    s dspID=$o(^DHCOEDISQTY(0,"OEORI",mOeori,""))
    s phordm=$o(^DHCPHORDM(0,"OrdItem",mOeori,""),-1)
    q:(phordm'="")&&(phordm'=ordmr) -98 // 不是最后一次日志,不能撤消
    s exitflag="",lastFlag=""
    q:lastFlag'="" -98 // 不是最后一次日志,不能撤消
    s err=0
    tstart
    &SQL(update DHC_PHAORDMONITOR set PHAOM_CancelUser_Dr=:user,PHAOM_CancelDate=:currdate,PHAOM_CancelTime=:currtime where PHAOM_RowId=:ordmr) 
    i SQLCODE'=0 tro  s err=-96
    q:err'=0 err
    s phaomr=+%ROWID
    s ordResultStr=##class(web.DHCSTCNTSIPMONITOR).GetPhaOrdResult(mOeori)
    s oeoriPassStr=""
    i (ordResultStr["拒绝")||(ordResultStr["申诉")||(ordResultStr["接受")  s oeoriPassStr=user_","_$h_",SHJJ"
    e  i ordResultStr["通过" s oeoriPassStr=user_","_$h_",SHTG"
    s $p(^OEORD(+mOeori,"I",+$p(mOeori,"||",2),7),"^",3)=oeoriPassStr
    s itm=""
    f  s itm=$o(^OEORDi(0,"OEORI",+mOeori,mOeori,itm)) q:(itm="")  d
    .q:+itm=0
    .s $p(^OEORD(+mOeori,"I",+itm,7),"^",3)=oeoriPassStr
    tcommit
    //取消审核
    s execret=##class(web.DHCSTInterfaceMessage).SendRefuseOrderMonitor(ordmr,"Exec")
    //插入草药处方追踪信息！
    s SqlStr=mOeori_"^^^C16^"_phalocdr_"^"_user
    job ##class(web.DHCINPHA.HMPresTrack.SqlDbPresTrack).HandlePresTrackDB(SqlStr)
    q 0
}

/// Creator:LiangQiang
/// CreatDate:2013-05-20
/// Input:医嘱ID,ReaMsg-返回不合格原因列表
/// Output:审核状态(0不通过,1通过,空未审)_","_审核日期_","_审核时间_","_审核人
/// Debug:Set MrNo = ##Class(web.DHCSTCNTSIPMONITOR)GetOrdAuditResult(oeori,.ReaMsg)
ClassMethod GetOrdAuditResult(oeori, ByRef ReaMsg As %String) As %String
{
    k GetOrdAuditResultDATA
    s ord=$p(oeori,"||",1)
    s chl=$p(oeori,"||",2)
    q:ord="" ""
    q:chl="" ""
    q:'$d(^OEORD(ord,"I",chl)) ""
    s oeori=##class(web.DHCSTCNTSCOMMON).GetMainOeori(oeori)
    s ord=$p(oeori,"||",1)
    s chl=$p(oeori,"||",2)
    s adm=$p(^OEORD(ord),"^",1)
    s admtype=$p(^PAADM(adm),"^",2)
    s prescno=$p(^OEORD(ord,"I",chl,1),"^",14)
    q:prescno="" 1
    s ret=""
    s result=$p(^OEORD(ord,"I",chl,7),"^",3)
    s status=$p(result,",",4)
    i status="SHTG"  s status=1  //通过
    i status="SHJJ"  s status=0  //不通过
    i admtype="I" s phor=$O(^DHCPHORDM(0,"OrdItem",oeori,""))
    i admtype'="I" s phor=$O(^DHCPHORDM(0,"PrescNo",prescno,""))
    q:$g(phor)="" ""
    s Audituser=""
    s userdr=$p(^DHCPHORDM(phor),"^",1)
    s:userdr'="" Audituser=$p(^SSU("SSUSR",userdr),"^",2)
    s Auditdate=$p(^DHCPHORDM(phor),"^",3)
    i Auditdate'="" s Auditdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(Auditdate)
    s Audittime=$p(^DHCPHORDM(phor),"^",4)
    i Audittime'="" s Audittime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(Audittime,"IP")
    s ret=status_","_Auditdate_","_Audittime_","_Audituser
    
    s sub=""
    F  S sub=$O(^DHCPHORDM(phor,"I",sub)) Q:sub=""  d
    .s grpno=$p(^DHCPHORDM(phor,"I",sub),"^",1)
    .i grpno="" s grpno="-"
    .s orditm=$p(^DHCPHORDM(phor,"I",sub),"^",2)
    .q:orditm=""
    .s reasondr=$p(^DHCPHORDM(phor,"I",sub),"^",3)
    .s index=grpno_","_reasondr
    .s GetOrdAuditResultDATA("REA",grpno,index)=""
    .s GetOrdAuditResultDATA("ITM",grpno,orditm)=""
    
    s ReaMsg=""
    s h=0
    s grpno=""
    f  s grpno=$o(GetOrdAuditResultDATA("REA",grpno)) q:grpno=""  d
    .s index=""
    .f  s index=$o(GetOrdAuditResultDATA("REA",grpno,index)) q:index=""  d
    ..s reason=""
    ..s reasondr=$p(index,",",2)
    ..i reasondr'="" s reason=$p(^DHCPCREASON(reasondr),"^",2)
    ..s itmdesc=reason
    ..s h=h+1
    ..s data=itmdesc
    ..i ReaMsg="" d 
    ...s ReaMsg=data
    ..e  d
    ...s ReaMsg=ReaMsg_","_data
    .s grpnum=0
    .s orditm=""
    .f  s orditm=$o(GetOrdAuditResultDATA("ITM",grpno,orditm)) q:orditm=""  d
    ..s grpnum=grpnum+1
    ..i grpnum=1 q:$o(GetOrdAuditResultDATA("ITM",grpno,orditm))=""
    ..s ord=$p(orditm,"||",1)
    ..s ordchl=$p(orditm,"||",2)
    ..s arcimid=$p(^OEORD(ord,"I",ordchl,1),"^",2)  
    ..s itmmastid=$p(arcimid,"||",1)
    ..s itmmastver=$p(arcimid,"||",2) 
    ..s inciDesc=$p(^ARCIM(itmmastid,itmmastver,1),"^",2) //医嘱名称
    ..i grpno'="-" s itmdesc="_____"_inciDesc
    ..e  s itmdesc=inciDesc
    ..s h=h+1
    ..s data=itmdesc
    ..i ReaMsg="" d 
    ...s ReaMsg=data
    ..e  d
    ...s ReaMsg=ReaMsg_","_data
    q ret
}

/// 病人入院前用药说明
ClassMethod GetAdmOthMedInfo(EpisodeId) As %String
{
    s ret=##class(web.DHCSTInterfaceFromElse).GetNewStdDataByGlossaryCategory(EpisodeId)
    q ret
}

/// Creator: hulihua
/// CreatDate: 2014-06-27
/// Description: 验证该病区是否属于该科室组
/// Input: 科室组Rowid, ward病区rowid
/// Output: 1-真,0-假
ClassMethod CheckWard(tWardID As %String, ward As %String) As %String
{
    s ret=0
    q:tWardID="" 1
    q:ward="" 1 
    s ret=0
    s slg=+tWardID
    s sub=""
    f  s sub=$o(^DHCSLG(slg,"I",sub)) q:sub=""  d
    .s tmplocdr=$p(^DHCSLG(slg,"I",sub),"^",1)
    .s tmpwardr=$o(^PAWARD(0,"WARD_LocationDR",tmplocdr,""))
    .i tmpwardr=ward d
    ..s ret=1
    q ret
}

/// creator:yunhaibao
/// createdate:20160520
/// description:判断医嘱审核是否需要显示该医嘱
/// 0 不需要
/// w ##class(web.DHCSTCNTSIPMONITOR).CheckOEOREStatByOeori("3||235")
ClassMethod CheckOEOREStatByOeori(oeori)
{
    Q:oeori="" ""
    s oedsp="",oeorestat=""
    f  s oedsp=$o(^DHCOEDISQTY(0,"OEORI",oeori,oedsp)) q:(oedsp="")||(oeorestat=1)  d
    .s oeore=$p(^DHCOEDISQTY(oedsp),"^",3)
    .q:oeore=""
    .s oeorestat=##class(web.DHCSTCOMMONSRV).GetOrdState(oeore)
    q oeorestat
}

/// w ##class(web.DHCSTCNTSIPMONITOR).GetCurPhoResultByOeori("dddddddddddd")
/// 获取当前医嘱审核状态
ClassMethod GetCurPhoResultByOeori(oeori As %String) As %String
{
    q ..GetPhaOrdResult(oeori)
}

/// description:医嘱审核相关尽量不予处方点评的类相互调用
/// w ##class(web.DHCSTCNTSIPMONITOR).GetAdmDs("0000001823")
ClassMethod GetAdmDs(RegNo As %String, style = "", Hosp = "") As %Integer
{
     k GetAdmDsDATA
     s n=0
     q:(RegNo="")&(style'="") ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
     q:RegNo="" ##class(web.DHCSTEXTCOMMON).GetNoJson()
     q:('$d(^PAPERi("PAPMI_PatNo",RegNo))&(style'="")) ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
     q:'$d(^PAPERi("PAPMI_PatNo",RegNo)) ##class(web.DHCSTEXTCOMMON).GetNoJson()
     s papmi=$o(^PAPERi("PAPMI_PatNo",RegNo,""))
     q:(style="jqGrid")&&(papmi="") ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
     q:papmi="" ##class(web.DHCSTEXTCOMMON).GetNoJson()
     s admTypeStr="I^E"
     f i=1:1:$l(admTypeStr,"^") d
     .s admType=$p(admTypeStr,"^",i)
     .q:admType=""
     .s adm="" 
     .f  s adm=$o(^PAPERdr(papmi,"ADM",admType,adm),-1) q:adm=""  d
     ..// yunhaibao20180719,医嘱审核不限制,明细限制即可
     ..//q:##class(web.DHCSTCOMMONSRV).GetCurrentAdmStatus(adm)=0
     ..//q:$p(^PAADM(adm),"^",20)'="A" 
     ..s depDesc=""    
     ..s depcodedr=$p(^PAADM(adm),"^",4) 
     ..q:(Hosp'="")&&(Hosp'=$p($g(^CTLOC(+depcodedr)),"^",22))
     ..i depcodedr'="" s depDesc=$p(^CTLOC(depcodedr),"^",2)
     ..s admdate=$p(^PAADM(adm),"^",6) 
     ..i +admdate>0 s admdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(admdate) 
     ..s admtime=$p(^PAADM(adm),"^",7) 
     ..i +admtime>0 s admtime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(admtime,"IP")
     ..s curWardDesc=""
     ..s curWard=$p(^PAADM(adm),"^",70) 
     ..i curWard'="" s curWardDesc=$p(^PAWARD(+curWard),"^",2)
     ..s curBedcode=$p(##class(web.DHCPHACOM.ComPubClass.OrderAndPatInfo).GetAdmBedCode(adm),"^",2)
     ..s doctor=$p(^PAADM(adm),"^",9)
     ..i doctor'=""  s doctor=$p($g(^CTPCP(doctor,1)),"^",2 )
     ..s n=n+1
     ..s data=$g(adm)_"^"_$g(depDesc)_"^"_$g(admdate)_" "_$g(admtime)_"^"_$g(curWardDesc)_"^"_$g(curBedcode)_"^"_$g(doctor)
     ..s GetAdmDsDATA("DATA",n)=data
     q:(style="jqGrid")&&(n=0) ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
     q:n=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
     s maxrow=n
     s count=0
     s h=""
     f  s h=$o(GetAdmDsDATA("DATA",h)) q:h=""  d
     .s data=GetAdmDsDATA("DATA",h)
     .s adm=$p(data,"^",1)
     .s admdate=$p(data,"^",3)
     .s admloc=$p(data,"^",2)
     .s currward=$p(data,"^",4)
     .s currbed=$p(data,"^",5)
     .s currdoc=$p(data,"^",6)
     .s papmi=$p($g(^PAADM(adm)),"^",1)
     .s adm=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("adm",adm)
     .s admdate=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("admdate",admdate)
     .s admloc=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("admloc",admloc)
     .s currward=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("currward",currward)
     .s currbed=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("currbed",currbed)
     .s papmi=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("papmi",papmi)
     .s currdoc=##class(web.DHCSTJQUERYCOMMON).GetJsonLastCell("currdoc",currdoc)
     .
     .s tmpstr=adm_admdate_admloc_currward_currbed_papmi_currdoc
     .s startString=##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(maxrow)
     .s firstrow=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstRow(tmpstr)
     .s lastrow=##class(web.DHCSTJQUERYCOMMON).GetJsonLastRow(tmpstr)
     .s count=count+1
     .i count=1 w startString
     .i count<maxrow w firstrow
     .i count=maxrow w lastrow
     q ""
}

/// Descript:   用于护士站床位图医嘱审核拒绝图标查看链接
/// Creator:    hulihua
/// CreateDate: 2014-08-27
/// Input:      开始时间Startdate, 结束时间Enddate, 病人的就诊ID EpisodeID
/// Output:     科室 登记号 病人姓名 床号 拒绝药品名称 频次 用法 不通过原因 
///             医嘱备注 医嘱日期 审核日期 审方药师 主管医生
/// d ##class(%ResultSet).RunQuery("web.DHCSTCNTSIPMONITOR","AuditRefOrdByNurse","2014-01-01","2014-08-27","")
Query AuditRefOrdByNurse(Startdate As %String, Enddate As %String, EpisodeID As %String) As websys.Query(ROWSPEC = "admDept:%String,patNo:%String,patName:%String,bed:%String,inciDesc:%String,freq:%String,instru:%String,auditReason:%String,note:%String,ordDate:%String,auditDate:%String,dept:%String,checkuser:%String,doctor:%String") [ SqlProc ]
{
}

ClassMethod AuditRefOrdByNurseExecute(ByRef qHandle As %Binary, Startdate As %String, Enddate As %String, EpisodeID As %String) As %Status
{
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    Set ind=1
    i Startdate=""  q $$$OK
    i Enddate=""   q $$$OK
    s Startdate=$zdh(Startdate,3)
        s Enddate=$p(Enddate," ",1)
    s Enddate=$zdh(Enddate,3)
    s deptId=""
    f  s deptId=$o(^CTLOC(0,"LocType","D",deptId)) q:deptId=""  d
    .s dept=$p(^CTLOC(deptId),"^",2)
    .f date=Startdate:1:Enddate d
    ..s rowId="" f  s rowId=$o(^DHCPHORDM(0,"DateLoc",date,deptId,rowId)) q:rowId=""  d
    ...s result=$p(^DHCPHORDM($g(rowId)),"^",2)
    ...s checkuser=$p(^DHCPHORDM($g(rowId)),"^",1)
    ...s checkuser=$p(^SSU("SSUSR",checkuser),"^",2) //审方医师 
    ...q:result'="N"
    ...s note=$p(^DHCPHORDM($g(rowId)),"^",6)       //备注
    ...s auditDate=$p(^DHCPHORDM($g(rowId)),"^",3)  //审核日期
    ...s auditTime=$p(^DHCPHORDM($g(rowId)),"^",4)  //审核时间
    ...s subRowId="" f  s subRowId=$o(^DHCPHORDM(rowId,"I",subRowId)) q:subRowId=""  d
    ....s auditReasonId=$p(^DHCPHORDM(rowId,"I",subRowId),"^",3)
    ....s auditReason=$p(^DHCPCREASON(auditReasonId),"^",2)     //审核不通过的原因
    ....s ordItemId=$p(^DHCPHORDM(rowId,"I",subRowId),"^",2)
    ....q:ordItemId=""
    ....s ordId=$p(ordItemId,"||",1)
    ....;q:(OEOrderRowID'="")&(OEOrderRowID'=ordId)
    ....s ordSubId=$p(ordItemId,"||",2)
    ....q:$g(^OEORD(ordId,"I",ordSubId,1))=""
    ....s ordDate=$p(^OEORD(ordId,"I",ordSubId,1),"^",9)    //医嘱日期
    ....s ordTime=$p(^OEORD(ordId,"I",ordSubId,1),"^",10)
    ....s docdr=$p(^OEORD(ordId,"I",ordSubId,1),"^",11)
    ....s doctor=##class(PHA.COM.Data.Base).CareProvDesc(docdr)                 //医生
    ....s itmMastId=$p(^OEORD(ordId,"I",ordSubId,1),"^",2)
    ....s inci=$o(^INCI(0,"ARCIM_DR",$p(itmMastId,"||",1),"") ) q:inci=""
    ....s inciDesc=##class(PHA.COM.Drug).GetInciDesc(inci)    //药品名
    ....s freq=""
    ....s freqdr=+$p($g(^OEORD(ordId,"I",ordSubId,2)),"^",4)
    ....i freqdr'=0 s freq=$p($g(^PHCFR(freqdr)),"^",3)  //频次
    ....s instru=""
    ....s instrudr=+$p(^OEORD(ordId,"I",ordSubId,2),"^",7)
    ....s:instrudr'=0 instru=$p(^PHCIN(instrudr),"^",2)         //用法
    ....s admdr=$p(^OEORD(ordId),"^",1)
    ....q:(EpisodeID'="")&(EpisodeID'=admdr)
    ....s admType=$p(^PAADM(admdr),"^",2)
    ....q:admType'="I"
    ....s bedId=$p(^PAADM(admdr),"^",73)
    ....s bed=""
    ....i bedId'="" d
    .....s bed=$p(^PAWARD($p($g(bedId),"||",1),"BED",$p($g(bedId),"||",2)),"^",1)   //床位
    ....s admDeptId=$p(^PAADM(admdr),"^",4) ;$p(^PAADM(admdr,"TRANS",transId),"^",6)
    ....s admDept=""
    ....i admDeptId'="" d 
    .....s admDept=##class(PHA.COM.Data.Base).LocDesc(admDeptId)  //就诊科室
    ....s papmi=$p(^PAADM(admdr),"^",1)
    ....s patName=$p(^PAPER(papmi,"ALL"),"^",1) //病人姓名
    ....s patNo=$p(^PAPER(papmi,"PAT",1),"^",1) //登记号
    ....d outputrows
    q $$$OK
outputrows
    s Data=$lb($p($g(admDept),"-",2),$g(patNo),patName,$g(bed),inciDesc,$g(freq),$g(instru),$g(auditReason),$g(note),$zd(ordDate,3)_" "_$zt(ordTime),$zd(auditDate,3)_" "_$zt(auditTime),$p(dept,"-",2),checkuser,doctor) 
    s ^CacheTemp(repid,ind)=Data    
    s ind=ind+1
    q
}

/// description: 获取住院医嘱审核结果,申诉视为未审核,以最后记录为准
/// output:      是否视为已审(Y:已申)^审核结果描述
/// w ##class(web.DHCSTCNTSIPMONITOR).GetPhaOrdResult("103||534")
ClassMethod GetPhaOrdResult(oeori)
{
    s mOeori=##class(web.DHCSTCNTSCOMMON).GetMainOeori(oeori)
    q:mOeori="" ""
    s phaOrdId=""
    s tmpPhaOrdId=""
    f  s tmpPhaOrdId=$o(^DHCPHORDM(0,"OrdItem",mOeori,tmpPhaOrdId),-1) q:(tmpPhaOrdId="")||(phaOrdId'="")  d
    .s cancelUser=$p(^DHCPHORDM(tmpPhaOrdId),"^",12)
    .q:(cancelUser'="")
    .s phaOrdId=tmpPhaOrdId
    q:phaOrdId="" ""
    s docNote=$p(^DHCPHORDM(phaOrdId),"^",7)
    s resultFlag=$p(^DHCPHORDM(phaOrdId),"^",2)
    s agreeFlag=$p(^DHCPHORDM(phaOrdId),"^",8)
    s retFlag="",retDesc=""
    q:resultFlag="" "^"
    q:resultFlag="Y" "Y^通过"
    q:(resultFlag="N")&&(agreeFlag="Y") "Y^拒绝(接受)"
    q:(resultFlag="N")&&(docNote'="") "N^申诉"
    q:(resultFlag="N")&&(docNote="") "Y^拒绝"
    q:resultFlag="A" "N^申诉"
    q ""
}

ClassMethod IfOeoriDisped(Oeori)
{
    s disped=""
    s dspId=""
    f  s dspId=$o(^DHCOEDISQTY(0,"OEORI",Oeori,dspId)) q:(dspId="")||(disped'="")  d
    .q:+dspId=0
    .s dspStatus=$p(^DHCOEDISQTY(dspId),"^",7)
    .i dspStatus="C" s disped="Y"
    q disped
}

/// Description: 判断医嘱是否发过药
/// w ##class(web.DHCSTCNTSIPMONITOR).IfOrderDisped("1549||56")
ClassMethod IfOrderDisped(MOeori)
{
    s oeoriStr=MOeori
    s ordId=+MOeori
    s oeoriStr=MOeori
    s ordItm=""
    f  s ordItm=$o(^OEORDi(0,"OEORI",ordId,MOeori,ordItm)) q:ordItm=""  d
    .q:+ordItm=0
    .s oeori=ordId_"||"_ordItm
    .s oeoriStr=$s(oeoriStr="":oeori,1:oeoriStr_"^"_oeori)
    s len=$l(oeoriStr,"^")
    s disped=""
    f i=1:1:len q:disped="Y"  d
    .s oeori=$p(oeoriStr,"^",i)
    .q:oeori=""
    .q:$lg(##class(PHA.COM.Order).OeoreStat(oeori),1)="D"
    .s disped=..IfOeoriDisped(oeori)
    q disped
}

ClassMethod NewPid()
{
    q ##class(web.DHCSTKUTIL).NewPid($ClassName(),"IP")
}

}
