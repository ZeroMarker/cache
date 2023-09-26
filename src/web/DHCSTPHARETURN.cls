Import Sqluser

Class web.DHCSTPHARETURN Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 437;

/// zdm,2012-03-15,长期医嘱改造
/// w ##class(web.DHCSTPHARETURN).GetPaDsp(63949,64337,"0000000900",98)
ClassMethod GetPaDsp(sd, ed, pano, reclocdr As %String) As %String
{
  n (sd, ed, pano, reclocdr)
  q:sd="" ""
  q:ed="" ""
  q:pano="" ""
  q:reclocdr="" ""
  s pid=..NewPid()
  k ^TMP("DHCST",$this,"GetPaDsp",pid)
  s nnn=0
  s pano=$$ALPHAUP^SSUTIL4(pano)
  s papmidr=$o(^PAPERi("PAPMI_PatNo",pano,""))
  q:papmidr="" ""
  s HospID=$p($g(^CTLOC(reclocdr)),"^",22)
  f dd=sd:1:ed  d
  .s adm=""
  .f  s adm=$o(^PAPERdr(papmidr,"ADM","I",adm)) q:adm=""  d
  ..s visitstatus=##Class(web.DHCSTCOMMONSRV).GetCurrentAdmStatus(adm)  //20160310 标准版开发
  ..q:visitstatus=0
  ..s admdr=$g(adm)
  ..s dspid=""
  ..f  s dspid=$o(^DHCOEDISQTY(0,"ADM",reclocdr,dd,"C",admdr,dspid))  q:dspid=""  d
  ...s oeori=$p(^DHCOEDISQTY(dspid),"^",1)
  ...s ord=+oeori
  ...s itm=$p(oeori,"||",2)
  ...s paname=$p(^PAPER(papmidr,"ALL"),"^",1)
  ...s admno=$p(^PAADM(admdr),"^",81)
  ...s admlocdr=$p(^PAADM(admdr),"^",4)
  ...i admlocdr'="" s admloc=$p(^CTLOC(admlocdr),"^",2)
  ...e  s admloc=""
  ...s prescno=$p(^OEORD(ord,"I",itm,1),"^",14)
  ...q:prescno=""
  ...q:$p(^OEORD(ord,"I",itm,1),"^",13)=""
  ...s queid=+$o(^PAQUE1(0,"PrescNo",prescno,""))
  ...s cyflag=$s($d(^PAQUE1(queid,"DHC")):"Y",1:"")
  ...s orditemstatus=$p(^OEC("OSTAT",$p(^OEORD(ord,"I",itm,1),"^",13)),"^",1)
  ...s ordexerowid=$p(^DHCOEDISQTY(dspid),"^",3) 
  ...s ore=$p(ordexerowid,"||",3)
  ...s OreStatusDr=$p(^OEORD(ord,"I",itm,"X",ore),"^",16)  ;护士执行状态
  ...q:OreStatusDr=""                           ;停止执行的记录可申请退药
  ...s AdminStatus=$p(^OEC("STAT",OreStatusDr),"^",1) 
  ...q:(AdminStatus'="D")               ;停止执行的记录可申请退药 &(AdminStatus'="C") 
  ...s orddeptdr=$p(^OEORD(ord,"I",itm,1),"^",3)
  ...s orddept=""
  ...s wardlocdr=$p(^DHCOEDISQTY(dspid),"^",22)
  ...s doctorloc=$p($g(^OEORD(ord,"I",itm,7)),"^",2)  ;医生科室
  ...s (beddr,bedcode)=""
  ...s specialflag=##class(web.DHCSTPCHCOLLS).DoctorLocRefuse(reclocdr,doctorloc)
  ...i specialflag=1  d
  ....;如果是特殊科室，申请退药科室为医生科室
  ....s wardlocdr=doctorloc
  ....s bedStr=##class(web.DHCSTCOMMONORDER).GetAdmBedCode(admdr)
  ...e  d
  ....;如果不是特殊科室，申请科室为病区科室
  ....s bedStr=##class(web.DHCSTCOMMONORDER).GetAdmBedCode(admdr,wardlocdr)
  ...s beddr=$p(bedStr,"^",1)
  ...s bedcode=$p(bedStr,"^",2)
  ...s ward=$p(^CTLOC(wardlocdr),"^",2)    ;
  ...s doctor=$p(^OEORD(ord,"I",itm,1),"^",11)
  ...i (doctor'="") d
  ....i $d(^CTPCP(doctor,1)) s Drcode=$p(^CTPCP(doctor,1),"^",1),Drname=$p(^CTPCP(doctor,1),"^",2)
  ...
  ...s phaci=$p(^DHCOEDISQTY(dspid),"^",14)         ;发药子表id
  ...q:phaci="" 
  ...s phadr=+phaci
  ...s phach=$p(phaci,"||",2)
  ...q:'$d(^DHCPHAC(phadr))
  ...s dspdate=$p(^DHCPHAC(phadr),"^",7)    ; 发药日期(打印日期)
  ...s phacsub=""
  ...f  s phacsub=$o(^DHCPHAC(phadr,"I",phach,"B",phacsub))  q:phacsub=""  d
  ....s dodisBatch=$P(^DHCPHAC(phadr,"I",phach,"B",phacsub),"^",7)
  ....s inclb=$p(^DHCPHAC(phadr,"I",phach,"B",phacsub),"^",1)
  ....s inci=+inclb
  ....s dspqty1=$p(^DHCPHAC(phadr,"I",phach,"B",phacsub),"^",2)
  ....s phacLbRowId=phadr_"||"_phach_"||"_phacsub
  ....s returnedqty=..ReturnedQtyByPhacLb(phacLbRowId) ;已退药数量
  ....s reqedqty=##class(web.DHCSTRETREQUEST).GetReqQtyByPhacLb(phacLbRowId)  ;已经申请数量
  ....q:reqedqty'=0                         //存在未退的申请单不允许直接退药 zhouyg 20121008
  ....q:(dspqty1-returnedqty-reqedqty)'>0   //发药已全退
  ....s dspqty=dspqty1-returnedqty
  ....s incicode=$P(^INCI(inci,1),"^",1)
  ....s incidesc=$P(^INCI(inci,1),"^",2)
  ....i inci'="" s buom=$p(^INCI(inci,1),"^",10)
  ....s uom=##class(web.DHCSTITMDESC).GetBaseUoDescByCode(incicode)
  ....s incib=$P(^INCI(inci,"IL",$p(inclb,"||",2),"LB",$p(inclb,"||",3)),"^",1)
  ....s Chl=$p(incib,"||",2)
  ....s batno=$p(^INCI(inci,"IB",Chl),"^",1)
  ....s sp=$P(^DHCPHAC(phadr,"I",phach,"B",phacsub),"^",5)
  ....s dspamt=dspqty*sp
  ....s nowsp=##class(web.DHCSTPRICE).GetSp(inclb,+$h,buom,HospID,"","")
  ....s generic=##class(web.DHCSTCOMMONSRV).getGeneric(inci)
  ....s form=##class(web.DHCSTCOMMONSRV).GetForm(inci)
  ....s Specifaction=##class(web.DHCSTCOMMONSRV).getBarcode(inci)
  ....s manf=$p(##class(web.DHCST.Common.DrugInfoCommon).GetManf(inci),"^",3)
  ....s retreq=""
  ....s retreqqty=""
  ....s a1=pano_"^"_paname_"^"_wardlocdr_"^"_ward_"^"_beddr   ;取患者病区 
  ....s a2=bedcode_"^"_admdr_"^"_admno_"^"_admlocdr_"^"_admloc
  ....s a3=doctor_"^"_prescno_"^"_$g(inclb)_"^"_oeori_"^"_""
  ....s a4=$p(dspqty,$c(1))_"^"_reclocdr_"^"_incicode_"^"_incidesc_"^"_uom
  ....s a5=batno_"^"_+$g(sp)_"^"_retreq_"^"_retreqqty_"^"_dspamt
  ....s a6=generic_"^"_Specifaction_"^"_form_"^"_manf_"^"_dspid
  ....s a7=nowsp_"^"_dodisBatch_"^"_phacLbRowId_"^"_cyflag_"^"_dspqty1
  ....s nnn=nnn+1
  ....s ^TMP("DHCST",$this,"GetPaDsp",pid,nnn)=a1_"^"_a2_"^"_a3_"^"_a4_"^"_a5_"^"_a6_"^"_a7
  ...
  ..
  . 
  q nnn_"^"_pid
}

ClassMethod ListPaDsp(pid As %String, i As %Integer) As %String
{
 i $d( ^TMP("DHCST",$this,"GetPaDsp",pid,i)) q ^TMP("DHCST",$this,"GetPaDsp",pid,i)
 q ""
}

ClassMethod GetPaInfo(itmjs As %Library.String = "", itmjsex As %Library.String = "", pano As %String) As %String
{
    n (pano,itmjs,itmjsex)
    
    &sql(select papmi_name,papmi_sex_dr->ctsex_desc,nvl(papmi_dob,""),papmi_no 
    into :paname,:sex,:dob,:tpatno from pa_patmas
    where papmi_no=:pano)
    q:SQLCODE SQLCODE
    q:tpatno'=pano -1   //例输入 0000143685##$  后，原先还能查询出数据，不知是什么原因，故加此判断，liangqiang
    i $g(dob)'="" d
    .//s age=$fn((+$h-dob)/365,"",0)
    .s pmi=$o(^PAPERi("PAPMI_PatNo",pano,""))
    .s age=##class(web.DHCSTKUTIL).GetAge(pmi) //年龄统一调用接口wyx 2015-01-29
    .s dob=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(dob,"IP")
    .s dob=dob_"( "_age_" )" 
    ;s dob=$zd(dob,3)
    ;q $g(paname)_"^"_$g(sex)_"^"_ $g(dob)
    s result=$g(paname)_"^"_$g(sex)_"^"_ $g(dob)
    ;
    s retval=itmjs_"('"_$ZCVT(result,"O","JS")_"');"
    i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(result,"O","JS")_"');"
    &javascript<#(retval)#>
    q SQLCODE
}

ClassMethod GetRetInfoByDate(sd As %String, ed As %String, recloc As %String) As %Integer
{
    n (sd,ed,recloc)
    s reclocdr=##class(web.DHCSTCOMMONSRV).LocToRowID(recloc)
    s sd=$zdh(sd,3),ed=$zdh(ed,3)
    &sql(declare reted cursor for
    select distinct phar_retno,phar_date,phar_ssusr_dr,    
    PHAR_DeptLoc_DR from DHC_PhaReturn
    where phar_date between :sd and :ed
    and  phar_recloc_dr =:reclocdr)
    &sql(open reted)
    s pid=..NewPid()
    k ^TMP("DHCST",$this,"RET",pid)
    s n=0
    f  &sql(fetch reted into :retno,:dd,:user,:deptdr) q:SQLCODE  d
    .s n=n+1
    .s dept=$p(^CTLOC(deptdr),"^",2)
    .i user'="" s username=$p(^SSU("SSUSR",user),"^",1)
    .s ^TMP("DHCST",$this,"RET",pid,n)=retno_"^"_$zd(dd,3)_"^"_$g(username)_"^"_$g(dept)
    &sql(close reted)
    q pid_"^"_n
}

ClassMethod GetRetInfoByDateDept(sd As %String, ed As %String, dept As %String, recloc As %String) As %Integer
{
 n (sd,ed,dept,recloc)
 s reclocdr=##class(web.DHCSTCOMMONSRV).LocToRowID(recloc)
 s deptdr=##class(web.DHCSTCOMMONSRV).LocToRowID(dept)
 s sd=$zdh(sd,3),ed=$zdh(ed,3)
 &sql(declare curreted cursor for
  select distinct phar_retno,phar_date,phar_ssusr_dr from DHC_PhaReturn
      where phar_deptloc_dr=:deptdr and phar_date between :sd and :ed and  phar_recloc_dr=:reclocdr)
 &sql(open curreted)
 s pid=..NewPid()
 k ^TMP("DHCST",$this,"RET",pid)
 s n=0
 f  &sql(fetch curreted into :retno,:dd,:user) q:SQLCODE  d
 .s n=n+1
 .i user'="" s username=$p(^SSU("SSUSR",user),"^",2) 
 .s ^TMP("DHCST",$this,"RET",pid,n)=retno_"^"_$zd(dd,3)_"^"_$g(username)_"^"_dept
 &sql(close curreted)
 q pid_"^"_n
}

ClassMethod GetPaAdmInfo(pano As %String, sd As %String, ed As %String)
{
 n (sd,ed,pano)
 q:sd="" ""
 q:ed="" ""
 s sd=$zdh(sd,3),ed=$zdh(ed,3)
 &sql(declare curx cursor for select distinct
   dsp_oeore_parref->oeore_oeori_parref->OEORI_OEORD_PARREF->oeord_adm_dr->paadm_admno,    
    dsp_oeore_parref->oeore_oeori_parref->oeori_oeord_parref->oeord_adm_dr->paadm_depcode_dr->ctloc_desc,
   dsp_oeore_parref->oeore_oeori_parref->oeori_oeord_parref->oeord_adm_dr->paadm_currentward_dr->ward_desc,
   dsp_oeore_parref->oeore_oeori_parref->oeori_oeord_parref->oeord_adm_dr->PAADM_CurrentBed_DR->Bed_Code
  from OE_Dispensing
   where dsp_oeore_parref->oeore_oeori_parref->oeori_oeord_parref->oeord_adm_dr->paadm_papmi_dr->papmi_no=:pano
   and dsp_date between :sd and :ed )
 s n=0
 s pid=..NewPid()
 k ^TMP("DHCST",$this,"ADM",pid)
 &sql(open curx)
 f  &sql(fetch curx into :admno,:admloc,:dept,:bed) q:SQLCODE  d 
 .s n=n+1
 .;s PLIST=n
 .;s PLIST(n)=$g(admon)_"*"_$g(admloc)_"*"_$g(dept)_"*"_$g(bed)
 .s ^TMP("DHCST",$this,"ADM",pid,n)=$g(admno)_"*"_$g(admloc)_"*"_$g(dept)_"*"_$g(bed)
 &sql(close curx)
 q pid_"^"_n
}

ClassMethod ListPaAdm(pid, n)
{
 i $d(^TMP("DHCST",$this,"ADM",pid,n)) q ^TMP("DHCST",$this,"ADM",pid,n)
 q ""
}

/// w ##class(web.DHCSTPHARETURN).GetRetByNo("","","RTDHSZHYYZY20180622001")
ClassMethod GetRetByNo(itmjs As %Library.String = "", itmjsex As %Library.String = "", RetNo As %String) As %Integer
{
 n (itmjs,itmjsex,RetNo,%session)
 s ^tmpdhy("GetRetByNo")=itmjs_","_itmjsex_","_RetNo
 s pid=..NewPid()
 s tmpEncryptCode=0
 s admstr=""
 q:RetNo="" ""
 s RetId=$o(^PHARET(0,"NO",RetNo,""))
 q:RetId="" ""
 s DD=$p(^PHARET(RetId),"^",1)
 s TT=$p(^PHARET(RetId),"^",2)
 s UserDR=$p(^PHARET(RetId),"^",3)
 s RecLocDR=$p(^PHARET(RetId),"^",5)
 s DeptDR=$p(^PHARET(RetId),"^",6)
 s AckStatus=$p(^PHARET(RetId),"^",8)
 s AckDate=$p(^PHARET(RetId),"^",9)
 s AckTime=$p(^PHARET(RetId),"^",10)
 s AckUser=$p(^PHARET(RetId),"^",11)
 i AckDate'="" s AckDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(AckDate,"IP")
 i AckTime'="" s AckTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(AckTime,"IP")
 s n=0
 s RetChl=""
 f  s RetChl=$o(^PHARET(RetId,"I",RetChl)) q:RetChl=""  d
 .s OEDISDR=$p(^PHARET(RetId,"I",RetChl),"^",1)
 .s Qty=$p(^PHARET(RetId,"I",RetChl),"^",2)
 .s Price="",Amount=0
 .s RetLb=""
 .f  s RetLb=$o(^PHARET(RetId,"I",RetChl,"B",RetLb)) q:RetLb=""  d
 ..i Price="" s Price=$p(^PHARET(RetId,"I",RetChl,"B",RetLb),"^",5)
 ..s Amount=Amount+$p(^PHARET(RetId,"I",RetChl,"B",RetLb),"^",6)
 .s ReasonDR=$p(^PHARET(RetId,"I",RetChl),"^",6)
 .s RetRqDR=$p(^PHARET(RetId,"I",RetChl),"^",7)
 .s Inci=$p(^PHARET(RetId,"I",RetChl),"^",11)
 .s Dodis=$p(^PHARET(RetId,"I",RetChl),"^",13)
 .s AdmDR=$p(^PHARET(RetId,"I",RetChl),"^",8)
 .s BedDR=$p(^PHARET(RetId,"I",RetChl),"^",10)
 .s AdmLocDR=$p(^PHARET(RetId,"I",RetChl),"^",9)
 .s OrdItemId=$p(^DHCOEDISQTY(Dodis),"^",1)
 .s Prescno=$p(^OEORD(+OrdItemId,"I",$p(OrdItemId,"||",2),1),"^",14)
 .s n=n+1
 .s Price=$fn(Price,"",4) ;位数为小数点后4位
 .s a1=$g(Retno)_"^"_$g(DD)_"^"_$g(TT)_"^"_$g(UserDR)_"^"_$g(RetRqDR)
 .s a2=$g(OEDISDR)_"^"_$g(Inci)_"^"_$g(AdmLocDR)_"^"_$g(RecLocDR)_"^"_$g(DeptDR)
 .s a3=$g(AdmDR)_"^"_$g(Prescno)_"^"_+$g(Qty)_"^"_+$g(Price)_"^"_+$g(Amount)_"^"_$g(BedDR)
 .i $g(AckUser)'="" s AckUserName=$p(^SSU("SSUSR",AckUser),"^",2)
 .s AckUser=$g(AckUser)
 .i $g(ReasonDR)'="" s reason=$p(^BLC("RFR",ReasonDR),"^",2)
 .s reason=$g(reason)
 .i UserDR'="" s OperUserName=$p(^SSU("SSUSR",UserDR),"^",2),OperUserName=$g(OperUserName)
 .s OperUserName=$g(OperUserName)
 .s a4=$g(AckDate)_"^"_$g(AckTime)_"^"_$g(AckUserName)_"^"_$g(AckStatus)_"^"_$g(reason)_"^"_$g(OperUserName)
 .s a5=$g(Dodis)
 .s ^TMP("DHCST",$this,"GetRetByNo",pid,n)=a1_"^"_a2_"^"_a3_"^"_a4_"^"_a5
 .//d ..ListRet("","",pid,n) ;如果打印退药单单品汇总则放开，如打印明细则注释
 .
 .s EncryptLevelInfo=""
 .s EncryptLevel=""
 .s PatLevel="" 
 .s EncryptFlag=##Class(web.DHCSTCOMMPARA).GetEncryptLevelFlag("")
 .i EncryptFlag=1 d
 ..s papmi=$p(^PAADM(AdmDR),"^",1)
 ..s EncryptLevelInfo=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(papmi,"")
 ..s EncryptCode=$p(EncryptLevelInfo,"^",3)
 ..i tmpEncryptCode<EncryptCode s tmpEncryptCode=EncryptCode
 ..i admstr="" d
 ...s admstr=AdmDR
 ..e  d
 ...s admstr=admstr_"&"_AdmDR
 i $d(^TMP("DHCST",$this,"GetRetByNo","RetTotal",pid)) d
 .//s n=$$getRowCountRet()  ;如果打印退药单单品汇总则放开，如打印明细则注释
 
 s EncryptFlag=##Class(web.DHCSTCOMMPARA).GetEncryptLevelFlag("")
 i EncryptFlag=1 d
 .s condition=RetNo
 .s content=DD_"^"_RecLocDR_"^"_admstr
 .s condition=##class(web.DHCSTCOMMONSRV).ChangeToJson("退药单号",RetNo)
 .s content=##class(web.DHCSTCOMMONSRV).ChangeToJson("日期^接收科室ID^就诊ID",content)
 .s eventlogret=##class(web.DHCSTCOMMONSRV).CreateEventLog("DHCDISPPHARET",condition,content,tmpEncryptCode)   //存打印日志
 q pid_"^"_n
 
getRowCountRet()
   s inci=""
   s rowCnt=0
   f  s inci=$o(^TMP("DHCST",$this,"GetRetByNo","RetTotal",pid,inci)) q:inci=""  d
   .s rowCnt=rowCnt+1
   .s ^TMP("DHCST",$this,"GetRetByNo","RetTotalItm",pid,rowCnt)=^TMP("DHCST",$this,"GetRetByNo","RetTotal",pid,inci)
   k ^TMP("DHCST",$this,"GetRetByNo","RetTotal",pid)
   q rowCnt
}

/// w ##class(web.DHCSTPHARETURN).ListRet("","","3183929",4)
ClassMethod ListRet(itmjs As %Library.String = "", itmjsex As %Library.String = "", pid As %String, i As %Integer) As %String
{
 n (itmjs,itmjsex,pid,i)
 s ^tmpdhy("ListRet")=itmjs_","_itmjsex_","_pid_","_i
 s data=^TMP("DHCST",$this,"GetRetByNo",pid,i)
 s Retno=$p(data,"^",1)
 s DD=$zd($p(data,"^",2),3)
 s TT=$zt($p(data,"^",3))
 s UserDR=$p(data,"^",4)
 s UserName=$p($g(^SSU("SSUSR",+UserDR)),"^",2)  ;user name
 s RetRqDR=$p(data,"^",5)
 s RetRqNo=""
 i $g(RetRqDR)'="" s RetRqNo=$p($g(^RETRQ($g(RetRqDR))),"^",1) 
 s OEDISDR=$p(data,"^",6)
 s INCLBDR=$p(data,"^",7)
 s AdmLocDR=$p(data,"^",8)
 s AdmLoc=""
 i AdmLocDR'="" s AdmLoc=$p($g(^CTLOC(AdmLocDR)),"^",2) ;adm loc desc
 s RecLocDR=$p(data,"^",9)
 s RecLoc=""
 i RecLocDR'="" s RecLoc=$p($g(^CTLOC(RecLocDR)),"^",2) ;rec loc desc
 s DeptDR=$p(data,"^",10)
 s Dept=""
 i DeptDR'="" s Dept=$p($g(^CTLOC(DeptDR)),"^",2)  ;dept desc
 s AdmDR=$p(data,"^",11)
 s Prescno=$p(data,"^",12)
 s Qty=+$p(data,"^",13)
 s Price=+$p(data,"^",14)
 s Amount=+$p(data,"^",15)
 s BedDR=$p(data,"^",16)
 s Bed=""
 i $g(BedDR)'="" s Bed=$p($g(^PAWARD(+BedDR,"BED",$p(BedDR,"||",2))),"^")
 s Inci=+INCLBDR
 s InciCode=$p(^INCI(Inci,1),"^",1)
 s InciDesc=$p(^INCI(Inci,1),"^",2)
 s dodis=$p(data,"^",23)   ;  DR:->dhc_phacollectitm
 ;2007-7-30,zdm,规格，厂家,批号
 s Specifaction=##class(web.DHCSTCOMMONSRV).getBarcode(+INCLBDR)
 s manufacture=$p(##class(web.DHCST.Common.DrugInfoCommon).GetManf(+INCLBDR),"^",3)
 s batno=$g(batno)
 s Uom=##class(web.DHCSTITMDESC).GetBaseUoDescByCode(InciCode)
 s Pa=..GetPaByAdm(AdmDR)
 s Pano=$p(Pa,"^",1),Paname=$p(Pa,"^",2)
 s RetReqQty=""
 i $g(RetRqDR)'="" s RetReqQty=$p($g(^RETRQ($g(RetRqDR),"I",$p($g(RetRqDR),"||",2))),"^",3)  ;request Qty
 e  s RetReqQty=..DispedQty(dodis)
 //e  s RetReqQty=..GetDispQty(OEDISDR)  ;dispensing Qty  07-09-30 rem by zhwh 
 s AckDate=$p(data,"^",17)
 s AckTime=$p(data,"^",18)
 s AckUser=$p(data,"^",19)
 s AckStatus=$p(data,"^",20)
 s reason=$p(data,"^",21)
 s OperUserName=$p(data,"^",22)
 s OrdLocDR=##Class(web.DHCSTKUTIL).UserDept(OEDISDR)
 s OrdLoc=$p(^CTLOC(OrdLocDR),"^",2)
 i $f(OrdLoc,"-") s OrdLoc=$p(OrdLoc,"-",2)
 
 s a1=Retno_"^"_DD_"^"_TT_"^"_UserDR_"^"_UserName
 s a2=RetRqDR_"^"_RetRqNo_"^"_OEDISDR_"^"_INCLBDR_"^"_AdmLocDR
 s a3=AdmLoc_"^"_RecLocDR_"^"_RecLoc_"^"_DeptDR_"^"_Dept
 s a4=AdmDR_"^"_Prescno_"^"_Qty_"^"_Price_"^"_Amount
 s a5=BedDR_"^"_Bed_"^"_InciCode_"^"_InciDesc_"^"_Pano
 s a6=Paname_"^"_RetReqQty_"^"_Uom_"^"_AckDate_"^"_AckTime
 s a7=AckUser_"^"_AckStatus_"^"_reason_"^"_OperUserName
 s a8=Specifaction_"^"_manufacture_"^"_batno_"^"_OrdLoc
 ;---------;如果打印退药单单品汇总则放开，如打印明细则注释 以下这段代码
 //i '$d(^TMP("DHCST",$this,"GetRetByNo","RetTotal",pid,+Inci)) d
 .//s ^TMP("DHCST",$this,"GetRetByNo","RetTotal",pid,+Inci)=a1_"^"_a2_"^"_a3_"^"_a4_"^"_a5_"^"_a6_"^"_a7_"^"_a8
 //e  d
 .//s $p(^TMP("DHCST",$this,"GetRetByNo","RetTotal",pid,+Inci),"^",18)=$p(^TMP("DHCST",$this,"GetRetByNo","RetTotal",pid,+Inci),"^",18)+Qty
 .//s $p(^TMP("DHCST",$this,"GetRetByNo","RetTotal",pid,+Inci),"^",20)=$p(^TMP("DHCST",$this,"GetRetByNo","RetTotal",pid,+Inci),"^",20)+Amount
 ;---------
 q a1_"^"_a2_"^"_a3_"^"_a4_"^"_a5_"^"_a6_"^"_a7_"^"_a8  ;;如果打印退药单单品明细则放开，如打印汇总则注释
 //q ""
GetDesc(desc)
 s desc=$tr(desc,"$","")
 s desc=$tr(desc,"#","")
 s desc=$tr(desc,"*","")
 s desc=$tr(desc,"@","")
 q desc
}

/// w ##class(web.DHCSTPHARETURN).ListRetTotal("","","3183929",4)
ClassMethod ListRetTotal(itmjs As %Library.String = "", itmjsex As %Library.String = "", pid As %String, i As %Integer) As %String
{
    //Description:打印退药单,规则:单品汇总
    //在组件dhcpha.printphareturn 中的item 的 mListRet 
    //如打印单品汇总挂的方法为   ListRetTotal
    //如打印单品明细挂的方法为   ListRet
    n (pid,i)
    s tmpstr=^TMP("DHCST",$this,"GetRetByNo","RetTotalItm",pid,i)
    ;i tmpstr'="" k ^TMP(pid,"RETTOTALITM",i)
    ;退药数量转换成整包装单位
    s incicode=$p(tmpstr,"^",23)
    s qty=$p(tmpstr,"^",18)
    s inci=##class(web.DHCSTCOMMONSRV).ItemCodeToID(incicode)
    s packQty=##class(web.DHCSTKUTIL).getPackQty(inci,qty)
    s $p(tmpstr,"^",18)=packQty
    ;
    q tmpstr
}

ClassMethod GetPaByAdm(admdr As %String) As %String
{
 //从pa_adm取出病人信息
 &sql(select paadm_papmi_dr->papmi_no,paadm_papmi_dr->papmi_name,paadm_papmi_dr->papmi_dob
  into :pano,:paname,:pdob from PA_Adm where paadm_rowid=:admdr)
 q $g(pano)_"^"_$g(paname)_"^"_$g(pdob)
}

/// 
/// w ##class(web.DHCSTPHARETURN).GetNewRetNo("","","AUTO")
ClassMethod GetNewRetNo(itmjs As %Library.String = "", itmjsex As %Library.String = "", prefix As %String) As %String
{
 n (itmjs,itmjsex,prefix,%session)
 i $d(%session) s LocID=$g(%session.Data("LOGON.CTLOCID"))
 e  s LocID=$o(^CTLOC(0))
 s retNo=##class(web.DHCST.Common.AppCommon).GetAppNo("DHCSTPHARETURN","",LocID)
 q:retNo="" ""
 i prefix'="" s retNo=prefix_retNo
 q retNo
}

/// Description:检验生成的退药单号是否符合规则:长度 14 ,是否含有 "RT"
/// return;0 -- 正确   -1 --错误
/// 
ClassMethod CheckNewRetNo(retno) As %String
{
 n (retno)
 s ret=-1
 i ( $l(retno)=14 ) && ( $f(retno,"RT")>0 ) s ret=0
 q ret
}

/// Creator:zhangdongmei
/// CreatDate:2012-03-12
/// Descriprtion:执行退药(直接退药时调用)
/// Table:
/// Input:退药药房id,退药人id;退药单号前缀,配药表id^退药数量^退药原因,配药表id^退药数量^退药原因
/// Output:
/// Others:save the data into temporary global
/// w ##class(web.DHCSTPHARETURN).ExecReturn("317","4638","RT","1173^1^3^1173||2^115||1||1")
ClassMethod ExecReturn(phaloc As %String, userid As %String, pre As %String, data As %String) As %String
{
 n (phaloc,userid,pre,data)
 q:$g(data)="" "failure^-1"
 q:phaloc="" "failure^-1"
 s hospId=$P(^CTLOC(phaloc),"^",22)
 s pid=..NewPid()
 d CollectData2
 s err=0
 s retid="",retno="",retidstr=""
 s reqloc=""
 f  s reqloc=$o(^||TMPPHARETURN(pid,phaloc,reqloc)) q:(reqloc="")!(err'=0)  d
 .s listdata=phaloc_"^"_userid_"^"_""_"^"_reqloc_"^"_pre
 .
 .TSTART
 .s $ZT="Error^DHCSTERROR"
 .s retid=..InsertRetMain(listdata)       ;保存退药主表
 .i retid="" trollback  s err=-1
 .
 .q:retid=""
 .s i=0
 .f  s i=$o(^||TMPPHARETURN(pid,phaloc,reqloc,i)) q:(i="")!(err'=0)  d 
 ..s reqitm=^||TMPPHARETURN(pid,phaloc,reqloc,i)
 ..s dodis=$p(reqitm,"^",1)
 ..q:dodis=""
 ..s dspSubId=$p(reqitm,"^",4)
 ..s phacItmLbId=$p(reqitm,"^",5)
 ..s reqedqty=##class(web.DHCSTRETREQUEST).GetReqQtyByDodis(dodis) 
 ..i reqedqty'=0 s err=-9   //存在未退申请单不允许直接退药 LiangQiang
 ..q:err'=0
 ..s retqty=$p(reqitm,"^",2)
 ..s reason=$p(reqitm,"^",3)
 ..s PartFlag=##Class(web.DHCSTPHARETURN2).GetRetParted(dodis,retqty)   //部分退药的控制 zhouyg 20120928
 ..i PartFlag=0 s err=-10
 ..q:err'=0
 ..s ordexeid=$p(^DHCOEDISQTY(dodis),"^",3)
 ..s IfDspPaid=##Class(web.DHCSTKUTIL).IfRetForPaidNew(ordexeid) //liangqiang 2014-01-06
 ..s:IfDspPaid=0 err=-11 
 ..q:err'=0 
 ..s admid=$p(^DHCOEDISQTY(dodis),"^",26)
 ..s oeori=$p(^DHCOEDISQTY(dodis),"^",1)
 ..s ordexeid=$p(^DHCOEDISQTY(dodis),"^",3)
 ..s ord=+oeori
 ..s itm=$p(oeori,"||",2)
 ..s ore=$p(ordexeid,"||",3)
 ..s wardloc=$p(^DHCOEDISQTY(dodis),"^",22)
 ..s wardId=$o(^PAWARD(0,"WARD_LocationDR",wardloc,""))
 ..s CurWardId=$p(^PAADM(admid),"^",70)
 ..s bedid=""
 ..i wardId=CurWardId d
 ...s bedid=$p(^PAADM(admid),"^",73)    //zhouyg 20160510 取床号修改
 ..s datedosing=$p(^DHCOEDISQTY(dodis),"^",21)
 ..s phacId=+phacItmLbId
 ..s phacItm=+$p(phacItmLbId,"||",2)
 ..s phacLb=+$p(phacItmLbId,"||",3)
 ..s phacItmData=$g(^DHCPHAC(phacId,"I",phacItm))
 ..s phacItmLbData=$g(^DHCPHAC(phacId,"I",phacItm,"B",phacLb))
 ..s prescNo=$P($g(^DHCPHAC(phacId,1)),"^",1)       ;处方号
 ..s sp=$p(phacItmLbData,"^",5)
 ..s admloc=+$p(phacItmData,"^",11)  
 ..s inci=+$p(phacItmLbData,"^",1)
 ..s ret=..AllowReturnByPhacLb(phacItmLbId,retqty)
 ..s:ret'=1 err=-3
 ..q:ret'=1                     ;不允许退药:退药数量超过发药数量,或未发药
 ..
 ..s OreStatusDr=$p(^OEORD(ord,"I",itm,"X",ore),"^",16)  ;护士执行状态
 ..s:OreStatusDr'="" AdminStatus=$p(^OEC("STAT",OreStatusDr),"^",1)  
 ..s:($g(AdminStatus)'="D") err=-12         ;停止执行的记录可退药&($g(AdminStatus)'="C")
 ..q:($g(AdminStatus)'="D")
 ..s ret=##class(web.DHCSTCOMMONSRV).GetCurrentAdmStatus(admid) //20160310 标准版开发
 ..s:ret=0 err=-4
 ..q:ret=0  ;检验该患者是否最终结算
 ..
 ..s listdata=retid_"^"_oeori_"^"_sp_"^"_retqty_"^"_reason_"^"_admid_"^"_bedid_"^"_""_"^"_inci_"^"_datedosing_"^"_dodis_"^"_admloc
 ..s retitmid=..InsertRetDetail(listdata)   ;保存退药明细表
 ..s:retitmid="" err=-5
 ..q:retitmid="" 
 ..
 ..s ret=..InsertItmLBDetail(retitmid,phacItmLbId)   ;保存退药批次表
 ..s:ret'=0 err=ret
 ..q:ret'=0
 ../* 处理临购药品限制使用数量 */  // 2021-03-12 yangsj
 ..s TmpIfEoughFlag=0
 ..i (##class(%Dictionary.MethodDefinition).%ExistsId("PHA.IN.TmpDrugPurAuth.Save||UpdateUseQtyByDisp")) d
 ...s TmpIfEoughFlag = ##Class(PHA.IN.TmpDrugPurAuth.Save).UpdateUseQtyByDisp(retitmid,"Y",hospId)
 ..i TmpIfEoughFlag'=0 s err = TmpIfEoughFlag q
 ../* 毒麻药品增加减去基数库存 */ // 2021-12-26 Huxt
 ..i (##class(%Dictionary.MethodDefinition).%ExistsId("PHA.IN.Narc.Com||SaveNarcRet"))  d
 ...s saveRet = ##Class(PHA.IN.Narc.Com).SaveNarcRet("Y", retitmid, userid)
 ..
 .
 .i err'=0  trollback
 .q:err'=0
 .;以下是审核过程
 .;若无单独的审核过程，则放开此
 .s ret=..AuditPhaRetItm(retid,userid,"") 
 .i ret<0 trollback  s err=-7  ;若无单独的审核过程，则放开此
 .q:ret<0   ;若无单独的审核过程，则放开此
 .
 .s ret=..UpdateBillStatus(retid)     ;更新执行记录计费状态
 .i ret'=0  trollback  s err=-8
 .q:ret'=0
 .; 停配液中心绑定的配置费医嘱
 .s ret=##class(web.DHCSTPIVAS.DataHandler).StopOrderByRet(retid,userid)
 .i $p(ret,"^",1)<0 trollback  s ret=-9,err=-13
 .e  s ret=0
 .q:ret'=0
 .tcommit

 .s ret=..MakeBillRet(retid)  ;若无单独的审核过程，则放开此
 .d ##class(PHA.IP.COM.Face).UpdateSystemStatus4PhaReturn(retid, , userid)
 .i retno="" s retno=$p($g(^PHARET(retid)),"^",7)
 .e  s retno=retno_","_$p($g(^PHARET(retid)),"^",7)
 .s retidstr=$s(retidstr="":retid,1:retidstr_","_retid)
 k ^||TMPPHARETURN(pid)
 q:err'=0 "failure^"_err
 ;草药处方需要插入处方追踪信息！
 s queid=##class(web.DHCPHACOM.ComPubClass.HMPrescMethod).PrescCYQueId(prescNo)
 i queid'=""  d
 .s SqlStr="^^"_prescNo_"^C15^"_phaloc_"^"_userid
 .job ##class(web.DHCINPHA.HMPresTrack.SqlDbPresTrack).HandlePresTrackDB(SqlStr)
 q "success^"_retidstr

CollectData2
 s num=0
 s len=$l(data,",")
 f i=1:1:len  d
 .s retitm=$p(data,",",i)
 .s dspid=$p(retitm,"^",1)
 .q:dspid=""
 .s retqty=$p(retitm,"^",2)
 .s retreason=$p(retitm,"^",3)
 .s dspsubid=$p(retitm,"^",4)
 .s phacitmlbid=$p(retitm,"^",5)
 .s wardloc=$p(^DHCOEDISQTY(dspid),"^",22)
 .s oeori=$p(^DHCOEDISQTY(dspid),"^",1)
 .s ord=+oeori
 .s itm=$p(oeori,"||",2)
 .s doctorloc=$p($g(^OEORD(ord,"I",itm,7)),"^",2)  ;医生科室
 .s specialflag=##class(web.DHCSTPCHCOLLS).DoctorLocRefuse(phaloc,doctorloc)
 .i specialflag=1  d
 ..s reqloc=doctorloc    ;如果是特殊科室，申请退药科室为医生科室
 .e  d
 ..s reqloc=wardloc    ;如果不是特殊科室，申请科室为病区科室
 .
 .s num=num+1
 .s ^||TMPPHARETURN(pid,phaloc,reqloc,num)=dspid_"^"_retqty_"^"_retreason_"^"_dspsubid_"^"_phacitmlbid
 q
}

/// Creator:zhangdongmei
/// CreatDate:2012-03-12
/// Descriprtion:执行退药(按申请单退药时调用)
/// Table:
/// Input:退药药房id,退药人id;退药单号前缀,申请子表id^退药数量,申请子表id^退药数量,处理保留药标志(""是不处理,1-处理)
/// Output:
/// Others:save the data into temporary global
/// w ##class(web.DHCSTPHARETURN).ExecReturnByReq("","","224","12179","RT","7||1^3","")
ClassMethod ExecReturnByReq(itmjs As %Library.String = "", itmjsex As %Library.String = "", phaloc As %String, userid As %String, pre As %String, data As %String, ResFlag As %String = "") As %String
{
 n (itmjs,itmjsex,phaloc,userid,pre,data,ResFlag)
 q:$g(data)="" "failure,-1"
 q:phaloc="" "failure,-1"
 s hospId=$P(^CTLOC(phaloc),"^",22)
 s retnostr=""
 s retidstr=""
 ;
 s pid=..NewPid()
 ;
 d CollectData
 q:('$d(^||TMPPHARETURN(pid))) "failure,-100"
 s err=0
 ;
 s reqloc=""
 f  s reqloc=$o(^||TMPPHARETURN(pid,phaloc,reqloc)) q:(reqloc="")!(err'=0)  d
 .s reqidstr=^||TMPPHARETURN(pid,phaloc,reqloc)
 .s listdata=phaloc_"^"_userid_"^"_reqidstr_"^"_reqloc_"^"_pre
 .s lkerr=$$LK()
 .i lkerr'=0 d UL  s err=lkerr
 .q:lkerr'=0      ;加锁失败
 .TSTART
 .s $ZT="Error^DHCSTERROR"
 .s retid=..InsertRetMain(listdata)       ;保存退药主表
 .i retid="" trollback  s err=-11
 .q:retid=""
 .s retidstr=$s(retidstr="":retid,1:retidstr_"^"_retid)
 .i retnostr=""  d
 ..s retnostr=$p(^PHARET(retid),"^",7)
 .e  d
 ..s retnostr=retnostr_"^"_$p(^PHARET(retid),"^",7)
 .s i=0
 .f  s i=$o(^||TMPPHARETURN(pid,phaloc,reqloc,i)) q:(i="")!(err'=0)  d 
 ..s reqitm=^||TMPPHARETURN(pid,phaloc,reqloc,i)
 ..s reqitmid=$p(reqitm,"^",1)
 ..q:reqitmid=""
 ..s retqty=$p(reqitm,"^",2)
 ..s reqid=+reqitmid
 ..s reqchl=$p(reqitmid,"||",2)
 ..s dodis=$p(^RETRQ(reqid,"I",reqchl),"^",11)
 ..s dodisBatch=$p(^RETRQ(reqid,"I",reqchl),"^",14)
 ..s phacLbRowId=$p(^RETRQ(reqid,"I",reqchl),"^",15)
 ..s phacId=+phacLbRowId
 ..s phacSubId=$p(phacLbRowId,"||",2)
 ..s inclb=$p(^RETRQ(reqid,"I",reqchl),"^",16)
 ..s PartFlag=##Class(web.DHCSTPHARETURN2).GetRetParted(dodis,retqty)   //部分退药的控制 zhouyg 20120928
 ..i PartFlag=0 s err=-10
 ..q:err'=0
 ..s admid=$p(^RETRQ(reqid),"^",5)
 ..s admtype=$p(^PAADM(admid),"^",2)
 ..s bedid=$p(^RETRQ(reqid),"^",8)
 ..s oeori=$p(^RETRQ(reqid,"I",reqchl),"^",1)
 ..s ord=+oeori
 ..s itm=$p(oeori,"||",2)
 ..s prescno=$p(^OEORD(ord,"I",itm,1),"^",14)       ;处方号
 ..s datedosing=$p(^RETRQ(reqid,"I",reqchl),"^",2)
 ..s sp=$p(^RETRQ(reqid,"I",reqchl),"^",4)
 ..s reason=$p(^RETRQ(reqid,"I",reqchl),"^",6)
 ..s arcimid=$p(^OEORD(ord,"I",itm,1),"^",2) 
 ..s inci=+inclb
 ..s admloc=+$p(^DHCPHAC(phacId,"I",phacSubId),"^",11)   ;adm loc
 ..s ordexeid=$p(^DHCOEDISQTY(dodis),"^",3)
 ..s ore=$p(ordexeid,"||",3)
 ..s reqstatus=$p(^RETRQ(reqid,"I",reqchl),"^",10)   ;
 ..s:reqstatus'="Prove" err=-2
 ..q:reqstatus'="Prove"     ;该申请记录已经退药或拒绝退药
 ..s ret=..AllowReturnByPhacLb(phacLbRowId,retqty) //..AllowReturn("","",dodis,retqty,reqid_"||"_reqchl)
 ..s:ret'=1 err=-3
 ..q:ret'=1                     ;不允许退药:退药数量超过发药数量,或未发药
 ..s OreStatusDr=$p($g(^OEORD(ord,"I",itm,"X",ore)),"^",16)  ;护士执行状态
 ..s AdminStatus=$s(OreStatusDr'="":$p($g(^OEC("STAT",OreStatusDr)),"^",1) ,1:"") 
 ..i (AdminStatus'="D") s err=-12   q   ;停止执行的记录可退药&($g(AdminStatus)'="C")
 ..s refundstatus=$p(^RETRQ(reqid,"I",reqchl),"^",12)
 ..s ret=##class(web.DHCSTCOMMONSRV).GetCurrentAdmStatus(admid) //20160310 标准版开发
 ..s:(ret=0)&(refundstatus'=1) err=-4
 ..q:err'=0  ;检验该患者是否最终结算
 ..//s IfDspPaid=##Class(web.DHCSTKUTIL).IfRetForPaid(oeori)
 ..s IfDspPaid=##Class(web.DHCSTKUTIL).IfRetForPaidNew(ordexeid) //liangqiang 2014-01-06
 ..s:(refundstatus'=1)&&(IfDspPaid=0) err=-11 
 ..q:err'=0
 ..s listdata=retid_"^"_oeori_"^"_sp_"^"_retqty_"^"_reason_"^"_admid_"^"_bedid_"^"_reqitmid_"^"_inci_"^"_datedosing_"^"_dodis_"^"_admloc
 ..s retitmid=..InsertRetDetail(listdata)   ;保存退药明细表
 ..s:+retitmid'>0 err=-5
 ..q:retitmid="" 
 ..q:err=-5
 ..s ret=..InsertItmLBDetail(retitmid,phacLbRowId)   ;保存退药批次表
 ..s:ret'=0 err=-13
 ..q:ret'=0
 ..
 ..;如果该申请记录已经退药完成，需更新申请状态
 ..s ret=0
 ..i ..GetReqItmSurplus(reqitmid)=0 d
 ...s ret=..UpdateRetReqStatus(reqitmid)
 ..s:ret'=0 err=-6
 ../*处理临购药品限制使用数量 */  //2021-03-12 yangsj
 ..s TmpIfEoughFlag=0
 ..i (##class(%Dictionary.MethodDefinition).%ExistsId("PHA.IN.TmpDrugPurAuth.Save||UpdateUseQtyByDisp"))  d
 ...s TmpIfEoughFlag = ##Class(PHA.IN.TmpDrugPurAuth.Save).UpdateUseQtyByDisp(retitmid,"Y",hospId)
 ..//w TmpIfEoughFlag_"^"_retitmid_"^"_hospId,!
 ..i TmpIfEoughFlag'=0 s err = TmpIfEoughFlag q
 .
 .i err'=0  trollback
 .q:err'=0
 .;以下是审核过程
 .;若无单独的审核过程，则放开此
 .s ret=..AuditPhaRetItm(retid,userid,ResFlag) 
 .i ret<0 trollback  s err=-7  ;若无单独的审核过程，则放开此
 .q:ret<0   ;若无单独的审核过程，则放开此
 .
 .s ret=..UpdateBillStatus(retid)     ;更新执行记录计费状态
 .i ret'=0  trollback  s err=-8
 .q:ret'=0
 .; 停配液中心绑定的配置费医嘱
 .s ret=##class(web.DHCSTPIVAS.DataHandler).StopOrderByRet(retid,userid)
 .i $p(ret,"^",1)<0 trollback  s ret=-9,err=-13
 .e  s ret=0
 .q:ret'=0
 .tcommit
 .s ret=..MakeBillRet(retid)  ;若无单独的审核过程，则放开此
 .d ##class(PHA.IP.COM.Face).UpdateSystemStatus4PhaReturn(retid, , userid)
 k ^||TMPPHARETURN(pid)
 d UL
 q:err'=0 "failure,"_err
 ;草药处方需要插入处方追踪信息！
 s queid=##class(web.DHCPHACOM.ComPubClass.HMPrescMethod).PrescCYQueId(prescno)
 i queid'=""  d
 .s SqlStr="^^"_prescno_"^C15^"_phaloc_"^"_userid
 .job ##class(web.DHCINPHA.HMPresTrack.SqlDbPresTrack).HandlePresTrackDB(SqlStr)
 ;
 q "success,"_retidstr 

CollectData
 s num=0
 s len=$l(data,",")
 f i=1:1:len  d
 .s reqitm=$p(data,",",i)
 .s reqitmid=$p(reqitm,"^",1)
 .q:reqitmid=""
 .s retqty=$p(reqitm,"^",2)
 .s reqid=+reqitmid
 .s reqchl=$p(reqitmid,"||",2)
 .q:'$d(^RETRQ(reqid,"I",reqchl))
 .s reqloc=$p(^RETRQ(reqid),"^",7)
 .s recloc=$p(^RETRQ(reqid),"^",2)
 .s num=num+1
 .i $d(^||TMPPHARETURN(pid,recloc,reqloc))  d
 ..s tmpstr=^||TMPPHARETURN(pid,recloc,reqloc)
 ..i '$f(tmpstr,reqid) d
 ...s ^||TMPPHARETURN(pid,recloc,reqloc)=^||TMPPHARETURN(pid,recloc,reqloc)_","_reqid
 ...
 .e  d
 ..s ^||TMPPHARETURN(pid,recloc,reqloc)=reqid
 .s ^||TMPPHARETURN(pid,recloc,reqloc,num)=reqitmid_"^"_retqty
 .
 q
 
LK()
  s lkerr=0
  s len=$l(reqidstr,",")
  f k=1:1:len  q:lkerr'=0  d
  .s tmpreqid=$p(reqidstr,",",k)
  .l +^RETRQ(tmpreqid):5  e  s lkerr=-100   ;加锁 失败
  .
  q lkerr
UL
  s len=$l(reqidstr,",")
  f k=1:1:len d
  .s tmpreqid=$p(reqidstr,",",k)
  .l -^RETRQ(tmpreqid) ;解锁
  .
  q
}

/// Description：保存退药批次记录
/// Creator:zdm
/// CreateDate:2012-03-12
/// Input:退药明细表id
/// Return: 0：成功 ；其它：失败
/// 医嘱改造,一条记录,无需事务
ClassMethod InsertItmLBDetail(RetItmId As %String, PhacLbRowId As %String) As %String
{
    n (RetItmId,PhacLbRowId)
    s err=0
    q:RetItmId="" ""
    q:PhacLbRowId="" ""
    s RetId=+RetItmId 
    s RetChl=$p(RetItmId,"||",2)
    s RetQty=$p(^PHARET(RetId,"I",RetChl),"^",2)
    s DspId=$p(^PHARET(RetId,"I",RetChl),"^",13)
    s locID=$p(^PHARET(RetId),"^",5)
    s CustStr=##Class(web.DHCSTCOMMO).GetLocCust(locID)
    s HospID=$p(CustStr,"^",5)
    s CustID=$p(CustStr,"^",1)
    s PhaciRetQty=0
    s phacId=+PhacLbRowId
    s phacSubId=$p(PhacLbRowId,"||",2)
    s phacLbId=$p(PhacLbRowId,"||",3)
    s RetInclb=$p(^DHCPHAC(phacId,"I",phacSubId,"B",phacLbId),"^",1) 
    s DodisBatch=$p(^DHCPHAC(phacId,"I",phacSubId,"B",phacLbId),"^",7)
    s BUom=$p(^INCI(+RetInclb,1),"^",10)
    s Rp=$p(^DHCPHAC(phacId,"I",phacSubId,"B",phacLbId),"^",3)
    s Sp=$p(^DHCPHAC(phacId,"I",phacSubId,"B",phacLbId),"^",5)
    s RpAmt=Rp*RetQty
    s SpAmt=Sp*RetQty
    s CatGrpStr=##Class(web.DHCSTCOMINC).GetIncStkCatGrp(+RetInclb)
    s StkTypeDesc=$P(CatGrpStr,"^",4)
    s Perv="^^^"_StkTypeDesc_"^"_CustID_"^DHC"
    s SpAmt=##Class(web.DHCSTCOMMPARA).GetNumbDec(SpAmt,Perv,"FmtSA",1)
    s RpAmt=##Class(web.DHCSTCOMMPARA).GetNumbDec(RpAmt,Perv,"FmtRA",1)
    s ChildSub=$o(^PHARET(RetId,"I",RetChl,"B",""),-1)+1
    &sql(insert into DHC_PhaReturnItmLB(PHARIL_PHARI_Parref,PHARIL_ChildSub,
        PHARIL_INCLB_DR,PHARIL_Qty,PHARIL_Rp,PHARIL_RpAmt,PHARIL_Sp,PHARIL_SpAmt,
        PHARIL_DSPB_DR,PHARIL_PHDIC_DR
        ) 
        values(:RetItmId,:ChildSub,:RetInclb,:RetQty,:Rp,:RpAmt,:Sp,:SpAmt,:DodisBatch,:PhacLbRowId))
    i SQLCODE'=0  d
    .s ret=$$SqlErrorRecord^DHCSTERROR("InsertItmLBDetail:DHC_PhaReturnItmLB",RetItmId,SQLCODE_":"_$g(%msg))
    .s err=SQLCODE
    q:SQLCODE'=0 SQLCODE
    q:err'=0 err
    q 0
}

/// Description：保存退药明细记录
/// Creator:zdm
/// CreateDate:2012-03-07
/// Input:主表id^医嘱id^价格^退药数量^退药原因^pa_adm id^病床id
/// ^申请明细id^库存项id^分发日期^配药表id_"^"_admloc
/// Return: 明细id ,"" 失败
/// 
ClassMethod InsertRetDetail(ListData As %String) As %String
{
    n (ListData)
    s Parref=$p(ListData,"^",1)
    s OrdItem=$p(ListData,"^",2)
    s Sp=$p(ListData,"^",3)
    s RetQty=$p(ListData,"^",4)
    s ReasonDr=$p(ListData,"^",5)
    s AdmId=$p(ListData,"^",6)
    s BedId=$p(ListData,"^",7)
    s ReqItmId=$p(ListData,"^",8)
    s SpAmt=RetQty*Sp
    s InciId=$p(ListData,"^",9)
    s DateDosing=$p(ListData,"^",10)
    s DoDisDr=$p(ListData,"^",11)
    s AdmLocDr=$p(ListData,"^",12)
    s RecLocDr=$p(^PHARET(Parref),"^",8)
    s CustStr=##Class(web.DHCSTCOMMO).GetLocCust(RecLocDr)
    s HospID=$p(CustStr,"^",5)
    s CustID=$p(CustStr,"^",1)
    S CatGrpStr=##Class(web.DHCSTCOMINC).GetIncStkCatGrp(InciId)
    S StkTypeDesc=$P(CatGrpStr,"^",4)
    S Perv="^^^"_StkTypeDesc_"^"_CustID_"^DHC"
    s SpAmt=+##Class(web.DHCSTCOMMPARA).GetNumbDec(SpAmt,Perv,"FmtSA",1)
    ;
    s ChildSub=$o(^PHARET(Parref,"I",""),-1)+1
    q:Parref="" ""
    q:OrdItem="" ""
    &sql(insert into DHC_PhaReturnItm(PHARI_PHAR_Parref,PHARI_ChildSub,PHARI_OEDIS_DR,
    PHARI_Price,PHARI_Qty,PHARI_REASON_DR,PHARI_Amount,PHARI_PAADM_DR,PHARI_Bed_DR,
    PHARI_RETRQI_DR,PHARI_INCI_DR,PHARI_DateDosing,PHARI_DoDis_Dr,PHARI_AdmLoc_DR) 
    values(:Parref,:ChildSub,:OrdItem,:Sp,:RetQty,:ReasonDr,:SpAmt,:AdmId,
    :BedId,:ReqItmId,:InciId,:DateDosing,:DoDisDr,:AdmLocDr))
    i SQLCODE'=0  d
    .s ret=$$SqlErrorRecord^DHCSTERROR("InsertRetDetail:DHC_PhaReturnItm",Parref_";"_ReqItmId,SQLCODE_":"_%msg)
    q:SQLCODE'=0 ""
    q $p(%ROWID,$c(1))
}

/// Description：保存退药主记录
/// Creator:zdm
/// CreateDate:2012-03-12
/// Input:药房id^退药人id^申请主表id^申请退药科室id^退药单前缀
/// Return: 主表id ,"" 失败
/// 
ClassMethod InsertRetMain(onerec As %String) As %String
{
    n (onerec,%session)
    s phaloc=$p(onerec,"^",1)
    s phauserid=$p(onerec,"^",2)
    s reqid=$p(onerec,"^",3)
    s reqlocid=$p(onerec,"^",4)
    s pre=$p(onerec,"^",5) 
    s date=+$h
    s time=$p($h,",",2)
    s ret=$$LK3()
    q:ret'=0 ""
    s retno=..GetNewRetNo("","",pre)
    q:retno="" ""
    &sql(insert into DHC_PhaReturn(PHAR_Date,PHAR_Time,PHAR_SSUSR_DR,
    PHAR_RETRQ_DR,PHAR_RecLoc_DR,PHAR_DeptLoc_DR,PHAR_RetNo) 
    values(:date,:time,:phauserid,:reqid,:phaloc,:reqlocid,:retno))
    i SQLCODE'=0  d
    .s ret=$$SqlErrorRecord^DHCSTERROR("InsertRetMain:DHC_PhaReturn",retno,SQLCODE_":"_%msg)
    d UL3
    q:SQLCODE'=0 ""
    q $p(%ROWID,$c(1))
    
LK3()
    l +^DHCSTLOCK("RetNo"):5  e  q -100
    q 0
UL3
    l -^DHCSTLOCK("RetNo")
    q
}

/// Description：更新退药申请状态为完成
/// Creator:zdm
/// CreateDate:2012-03-13
/// Input:申请明细id
/// Return: 0：成功;"" 失败
/// 
ClassMethod UpdateRetReqStatus(ReqItmRowid As %String) As %String
{
    n (ReqItmRowid)
    s ret=0
    s status="Execute"
    s ret=##class(web.DHCSTRETREQUEST).UpdateReqItmStatus(ReqItmRowid,status)
    q:ret'=0 ret
    s flag=..CheckReqItmStatus(+ReqItmRowid)
    ;申请明细若都退药完成，需要更新申请主记录状态
    i flag=1  d
    .s ret=##class(web.DHCSTRETREQUEST).UpdateReqStatus(+ReqItmRowid,status)
    q ret
}

ClassMethod AuditPhaRet(RetNo As %String, User As %String) As %String
{
 s retRowid=""
 s ret=0
 ;
 ;TSTART
 f  s retRowid=$o(^PHARET(0,"NO",RetNo,retRowid)) q:(retRowid="")!(ret<0)  d
 .s ret=..AuditPhaRetItm(retRowid,User)
 ;i ret<0 TROLLBACK
 ;s ^TMP("xy")=ret
 q:ret<0 ret
 ;TCOMMIT
 ;
 s ret=..MakeBillByRetNo(RetNo) 
 q 0
}

/// Description：审核退药单
/// Creator:zdm
/// CreateDate:2012-03-13
/// Input:退药单id，退药人，退药标志(是否冲抵标志,为空时不冲抵)
/// Return: 0：成功;"" 失败
/// 
ClassMethod AuditPhaRetItm(RetRowid As %String, User As %String, RetFlag As %String = "") As %String
{
 ;set ack flag etc.
 n (RetRowid,User,RetFlag)
 q:RetRowid="" ""
 s HospName=##class(web.DHCSTKUTIL).HospName()
 s ret=$$LK2()
 q:ret'=0 ret           ;加锁失败
 tstart
 s $ZT="Error^DHCSTERROR"
 s AckDate=+$h
 s AckTime=$p($h,",",2)
 s AckStatus="Y"
 &sql(update dhc_phareturn set phar_ackuser=:User,phar_ackdate=:AckDate,phar_acktime=:AckTime,phar_ackstatus=:AckStatus where phar_rowid=:RetRowid)
 i SQLCODE'=0  d
 .s ret=$$SqlErrorRecord^DHCSTERROR("AuditPhaRetItm:DHC_PhaReturn",RetRowid,SQLCODE_":"_%msg)
 .
 i SQLCODE'=0 trollback  d UL2
 q:SQLCODE'=0 -3
 ;
 s Err=0
 s RetChl=""
 f  s RetChl=$o(^PHARET(RetRowid,"I",RetChl)) q:(RetChl="")!(Err'=0)  d
 .s RetLB=""
 .f  s RetLB=$o(^PHARET(RetRowid,"I",RetChl,"B",RetLB)) q:(RetLB="")!(Err'=0)  d
 ..s RetLbId=RetRowid_"||"_RetChl_"||"_RetLB
 ..s ret=$$HandleDhcStkTables(RetLbId)
 ..s:ret'=0 Err=-5
 ..q:ret'=0
 .q:Err'=0
 .s RetItmId=RetRowid_"||"_RetChl
 .//s ret=..AddResQty(RetItmId,RetFlag)    ;退药保留
 .//s:ret'=0 Err=-6
 .//q:ret'=0
 .
 .;插入dhc_oedispensing                    
 .s ret=..InsertDODIS(RetItmId)
 .s:ret<0 Err=-7
 .q:ret<0
 .
 i Err'=0 trollback  d UL2
 q:Err'=0 Err 
 tcommit
 d UL2
 q 0

HandleDhcStkTables(PHARIL) 
 n (PHARIL)
 s retStk=##class(PHA.IP.COM.Save).HandleTransY(PHARIL)
 q:(+retStk<0) -6
 q 0
    
LK2()
  s lkerr=0
  l +^PHARET(RetRowid):5  e  s lkerr=-100   ;加锁 失败
  q lkerr
  
UL2
  l -^PHARET(RetRowid) ;解锁
  q
}

/// Description：处理退药保留业务
/// Creator:zdm
/// CreateDate:2012-03-13
/// Input:退药单id，退药人，退药标志(是否冲抵(做保留药处理),为空时不处理)
/// Return: 0：成功;"" 失败
/// 
ClassMethod AddResQtyOld(PHARI As %String, RetFlag As %String = "") As %String
{

    n (PHARI,RetFlag)
    q:PHARI="" -1
    s PhaRet=+PHARI
    s PhaRetChl=$p(PHARI,"||",2)
    q:'$d(^PHARET(PhaRet)) -2
    q:RetFlag="" 0       ;不需要处理退药保留,
    s oeori=$p(^PHARET(PhaRet,"I",PhaRetChl),"^",1)
    s ord=+oeori
    s chl=$p(oeori,"||",2)
    s arcimid=$p(^OEORD(ord,"I",chl,1),"^",2)                                    ;医嘱 ARC_ItmMast ARCIM_RowId
    s arccatid=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",10)        ;医嘱子类RowId
    ;q:(retflag="")&(arccatid'="444") 0   /// 444 胰岛素      zdm,2012-03-31,加上该判断相当于只能处理胰岛素的退药保留?
    ;
    s Loc=$p(^PHARET(PhaRet),"^",5)
    q:##class(web.DHCSTCOMMONSRV).ReserveRetFlag(Loc)'="Y" 0   ;不需要处理退药保留
    s Inci=+$p(^PHARET(PhaRet,"I",PhaRetChl),"^",11)
    q:##class(web.DHCSTCOMMONSRV).GetCatReserve(Inci)'>0 0     ;不需要处理退药保留
    s ReqLoc=$p(^PHARET(PhaRet),"^",6)        ;申请退药科室
    s SpecialFlag=##class(web.DHCSTPCHCOLLS).DoctorLocRefuse(Loc,ReqLoc)
    q:SpecialFlag=1 0  ;特殊科室不进行退药保留
    s WardLoc=ReqLoc
    s Ward=$o(^PAWARD(0,"WARD_LocationDR",WardLoc,""))
    s Qty=$p(^PHARET(PhaRet,"I",PhaRetChl),"^",2)    ;退药数量
    tstart
    s $ZT="Error^DHCSTERROR"
    s $p(^PHARET(PhaRet,"I",PhaRetChl),"^",3)=Qty      ;退药保留数量更新为退药数量  
    ;检查DHC_PhaReserve中是否存在
    s Pres=$o(^DHCPRES(0,"LOCINCIWARD",Loc,Inci,Ward,"")  )
    s ret=0
    i Pres="" d
    .&sql(insert into DHC_PhaReserve(PRES_CTLOC_DR,PRES_INCI_DR,PRES_ResQty,PRES_Ward_DR) 
        values (:Loc,:Inci,:Qty,:Ward))   ;总表插入
    .i SQLCODE'=0  d
    ..s rett=$$SqlErrorRecord^DHCSTERROR("AddResQty:DHC_PhaReserve",PHARI,SQLCODE_":"_%msg)
    ..s ret=-3
    .e  d
    ..s Pres=$p(%ROWID,$c(1))
    .
    e  d
    .//i (arccatid="444") d //胰岛素类别的处理
    .i (arccatid="AAAA") d
    ..s NewQty=$p(^DHCPRES(pres),"^",4)-Qty
    .e  d
    ..s NewQty=Qty+$p(^DHCPRES(Pres),"^",4)
    .&sql(update DHC_PhaReserve set pres_resqty=:NewQty where pres_rowid=:Pres)  ;总表resqty更新
    .i SQLCODE'=0  d
    ..s rett=$$SqlErrorRecord^DHCSTERROR("AddResQty-Update:DHC_PhaReserve",Pres,SQLCODE_":"_%msg)
    ..s ret=-4
    .
    i ret'=0 trollback
    q:ret'=0 ret
    i Pres="" trollback
    q:Pres="" -6  
    ;保留数据台帐---Liang Qiang
    s Chl=$o(^DHCPRES(Pres,"DET",""),-1)+1
    s Type="Y"
    s AvQty=$p(^DHCPRES(Pres),"^",4)
    s Date=+$h
    s Time=$p($h,",",2)
    s User=$p(^PHARET(PhaRet),"^",3)
    ;
    &sql(insert into DHC_PhaReserveDetail(PRDET_PRES_Parref,PRDET_Childsub,PRDET_Type,PRDET_Qty,
    PRDET_Pointer,PRDET_AvailQty,PRDET_Date,PRDET_OperUser_Dr,PRDET_Time) 
    values (:Pres,:Chl,:Type,:Qty,:PHARI,:AvQty,:Date,:User,:Time))
    i SQLCODE'=0  d
    .s rett=$$SqlErrorRecord^DHCSTERROR("AddResQty:DHC_PhaReserveDetail",PHARI,SQLCODE_":"_%msg)
    .s ret=-5
    .
    i ret'=0 trollback
    q:ret'=0 ret
    tcommit
    q 0
}

/// w ##class(web.DHCSTPHARETURN).AddResQty("15||1","")
ClassMethod AddResQty(PHARI, RetFlag = "") As %String
{
  n (PHARI,RetFlag)
  q:PHARI="" -1
  s PhaRet=+PHARI
  s PhaRetChl=$p(PHARI,"||",2)
  q:'$d(^PHARET(PhaRet)) -2
  s oeori=$p(^PHARET(PhaRet,"I",PhaRetChl),"^",1)
  s ord=+oeori
  s chl=$p(oeori,"||",2)
  s arcimid=$p(^OEORD(ord,"I",chl,1),"^",2)                                ;医嘱 ARC_ItmMast ARCIM_RowId
  s arccatid=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",10)        ;医嘱子类RowId
  q:(RetFlag="")&(##class(web.DHCSTCOMMONSRV).GetWholeDispFlag(oeori)'=1) 0   /// 胰岛素
 
  s loc=$p(^PHARET(PhaRet),"^",5)
  q:##class(web.DHCSTCOMMONSRV).ReserveRetFlag(loc)'="Y" 0
  s inci=+$p(^PHARET(PhaRet,"I",PhaRetChl),"^",11)
  q:##class(web.DHCSTCOMMONSRV).GetCatReserve(inci)'>0 0
  
  s ReqLoc=$p(^PHARET(PhaRet),"^",6)        ;申请退药科室
  s wardloc=ReqLoc
  s doclocdr=$p(^OEORD(ord,"I",chl,7),"^",2)
  s reclocdr=$p(^OEORD(ord,"I",chl,3),"^",6)
  i ##class(web.DHCSTPCHCOLLS).DoctorLocRefuse(reclocdr,doclocdr)=1 d
  .s ward=""
  .s pres=$o(^DHCPRES(0,"LOCINCIDEPT",loc,inci,wardloc,""))
  .s deptdr=wardloc
  e  d
  .s ward=$o(^PAWARD(0,"WARD_LocationDR",wardloc,""))
  .s pres=$o(^DHCPRES(0,"LOCINCIWARD",loc,inci,ward,""))
  q:ward="" 0  ;特殊科室不进行退药保留
  tstart
  s $ZT="Error^DHCSTERROR"
  s qty=$p(^PHARET(PhaRet,"I",PhaRetChl),"^",2)    ;退药数量
  // MYQ 20160720 退药时只加退药数量的零头
  s ret=0
  s insuflag=##class(web.DHCSTCOMMONSRV).GetWholeDispFlag(oeori)
  s puom=$p(^INCI(inci,3),"^",6)
  s buom=$p(^INCI(inci,1),"^",10) 
  s fac=##class(web.DHCSTCOMMONSRV).UOMFac(puom,buom)
  i insuflag=1 d
  .s pqty=qty\fac
  .s qty=qty-(pqty*fac)
  .i qty=0 tcommit
  .s:qty=0 ret=-1       //整支退药的话不在DHC_PhaReserve中插数据(仅限胰岛素)
  q:ret'=0 0
  s $p(^PHARET(PhaRet,"I",PhaRetChl),"^",3)=qty 
  ;检查DHC_PhaReserve中是否存在
  s ret=0
  i pres="" d
  .k PLIST
  .s PLIST(2)=loc
  .s PLIST(3)=inci
  .s PLIST(4)=qty
  .s PLIST(5)=ward
  .s PLIST(6)=$g(deptdr)
  .&sql(insert into DHC_PhaReserve values PLIST())   ;总表插入
  .i SQLCODE'=0  d
  ..s rett=$$SqlErrorRecord^DHCSTERROR("AddResQty:DHC_PhaReserve",PhaRet,SQLCODE_":"_%msg)
  ..s ret=-3
  .e  d
  ..s pres=$g(%ROWID)  //$o(^DHCPRES(0,"LOCINCIWARD",loc,inci,ward,""),-1) ;wyx add test
  e  d
  .i ##class(web.DHCSTCOMMONSRV).GetWholeDispFlag(oeori)=1 d
  ..s newqty=$p(^DHCPRES(pres),"^",4)-qty
  .e  d
  ..s newqty=qty+$p(^DHCPRES(pres),"^",4)
  .&sql(update DHC_PhaReserve set pres_resqty=:newqty where pres_rowid=:pres)  ;总表resqty更新
  .i SQLCODE'=0 d
  ..s rett=$$SqlErrorRecord^DHCSTERROR("AddResQty-Update:DHC_PhaReserve",pres,SQLCODE_":"_%msg)
  ..s ret=-4
  i ret<0 trollback
  q:ret<0 ret
  i pres="" trollback
  q:pres="" -6  ;wyx add test 
  ;保留数据台帐---Liang Qiang
  s avqty=$p(^DHCPRES(pres),"^",4)
  k PLIST
  s PLIST(0)=pres
  s PLIST(2)=$o(^DHCPRES(pres,"DET",""),-1)+1
  s PLIST(3)="Y"
  s PLIST(4)=qty
  //s PLIST(5)=PhaRet
  s PLIST(5)=PHARI //wyx 修改为存子表id
  s PLIST(6)=avqty
  s PLIST(7)=+$h
  s PLIST(8)=$p(^PHARET(PhaRet),"^",3)
  s PLIST(9)=$p($h,",",2)
  &sql(insert into DHC_PhaReserveDetail values PLIST())
  i SQLCODE'=0 d
  .s rett=$$SqlErrorRecord^DHCSTERROR("AddResQty:DHC_PhaReserveDetail",PhaRet,SQLCODE_":"_%msg)
  .s ret=-5 
  i ret'=0 trollback
  q:ret'=0 ret
  tcommit
    
  q ret
}

/// Description：退药成功后修改执行记录计费状态
/// Creator:zdm,
/// CreateDate:2012-03-15
/// Input:退药单id
/// Return: 0：成功;"" 失败
/// 不用了，zdm,2012-03-20
ClassMethod UpdateBillStatus(RetRowid As %String) As %String
{
 ;set ack flag etc.
 n (RetRowid)
 q:RetRowid="" ""
 ;
 tstart
 s $ZT="Error^DHCSTERROR"
 ;
 s Err=0
 s RetChl=""
 f  s RetChl=$o(^PHARET(RetRowid,"I",RetChl)) q:(RetChl="")!(Err'=0)  d
 .s RetItmId=RetRowid_"||"_RetChl
 .s dodis=$p(^PHARET(RetRowid,"I",RetChl),"^",13)  ;配药表id
 .q:dodis=""
 .s refundstatus=""
 .s reqitm=$p(^PHARET(RetRowid,"I",RetChl),"^",7) 
 .s:reqitm'="" refundstatus=$p(^RETRQ(+reqitm,"I",$p(reqitm,"||",2)),"^",12)
 .q:refundstatus=1 ;如果申请单中已退费则退出
 .s Err=..UpdBillStatus(dodis)
 .
 i Err'=0 trollback  
 q:Err'=0 Err 
 tcommit
 q 0
}

/// Description：退药成功后修改执行记录计费状态
/// Creator:liangqiang,
/// Input:配药表ID
/// Return: 0：成功; 非0 , 失败
ClassMethod UpdBillStatus(dodis As %String) As %String
{
  n (dodis) 
  s ordexeid=$p(^DHCOEDISQTY(dodis),"^",3)   
  s ord=+ordexeid
  s itm=$p(ordexeid,"||",2)
  s ore=$p(ordexeid,"||",3)
  //s count=..CountRet(dodis)         ;多次退药才变状态,因为首次退药是先停执行记录,在停的时候已更新成了I,LiangQiang 2014-01-06
  s billstatus=$p(^OEORD(ord,"I",itm,"X",ore),"^",6)
  //q:(count'>1)&(billstatus'="B") 0   //wwl 更新重新生成账单导致的B状态 20170113
  q:(billstatus'="B")&(billstatus'="R") 0   ;计费状态是B和R的需要更新,不管计费状态，&(billstatus'="R")
  s newstatus="I"
  &sql(update OE_OrdExec set OEORE_Billed=:newstatus where OEORE_Rowid=:ordexeid)
  i SQLCODE'=0  d
  .s ret=$$SqlErrorRecord^DHCSTERROR("UpdateBillStatus:OE_OrdExec",RetItmId,SQLCODE_":"_%msg)
  q:SQLCODE'=0 SQLCODE
  
  q 0
}

/// Description：取某执行记录的退药记录条数
/// Creator:zdm,
/// CreateDate:2012-03-20
/// Input:配药表id
/// Return: 记录条数
/// 
ClassMethod CountRet(Dodis As %String) As %String
{
    n (Dodis)
    q:Dodis="" 0
    s OrdExeRowid=$p(^DHCOEDISQTY(Dodis),"^",3)     ;OE_OrdExec表指针 ..
    q:OrdExeRowid="" 0
    s count=0
    s newdsp=""
    f  s newdsp=$o(^DHCOEDISQTY(0,"OEORE",OrdExeRowid,newdsp)) q:newdsp=""  d
    .s status=$p(^DHCOEDISQTY(newdsp),"^",7)
    .q:status'="R"
    .s count=count+1
    .
    q count
}

ClassMethod MakeBillByRetNo(RetNo As %String) As %String
{
 
 ;根据退货单号做账单
 n (RetNo)
 s retRowid=""
 s ret=0
 f  s retRowid=$o(^PHARET(0,"NO",RetNo,retRowid)) q:(retRowid="")  d
 . s ret=..MakeBillRet(retRowid)   ;2007-01-08   退药后立即做账单
 q ret'=0 -7
 q ret
}

ClassMethod RetUser(retno As %String) As %String
{
 ;取第一条中的制单人
 s pharetrowid=$o(^PHARET(0,"NO",retno,""))
 q:pharetrowid="" -1
 s opuser=$p(^PHARET(pharetrowid),"^",3)
 q $g(opuser)
}

ClassMethod GetRetReason() As %String
{
 k PLIST
 s n=0
 &sql(declare creason cursor for select Rfr_rowid,Rfr_desc From BLC_ReasonForRefund)
 &sql(open creason)
 f  &sql(fetch creason into :reasondr,:reasondesc) q:SQLCODE  d
 .s n=n+1
 .s PLIST=n
 .s PLIST(n)=+reasondr_"^"_reasondesc
 &sql(close creason)
 q 0
}

ClassMethod CheckValidation(retreqno As %String) As %String
{
 n (retreqno)
 s id=""
 s id=$o(^RETRQ(0,"RETRQNO",retreqno,id))
 i $g(id)'="" s status=$p(^RETRQ(id),"^",14)
 q:($g(id)'="")&(status="Prove") 1
 q 0
}

ClassMethod RetQuery(dfr, dto, phaloc, inci, catid, wardid As %String) As %Integer
{
 ;s dfr="2005-05-1",dto="2005-05-19",phaloc="Auslab GCH",inci="",catid="",wardid=""
 n (dfr, dto, phaloc, inci, catid, wardid)
 q:phaloc="" ""    ; you must input the pharmcy location 
 s pid=..NewPid()
 k ^TMP("DHCST",$this,"RET",pid)
 s i=0
 ;s dfr=$zdh(dfr,3),dto=$zdh(dto,3)
 s wardlocid=wardid
 i wardlocid'="" s wardlocid=$p(^PAWARD(wardlocid),"^",5)   ; get the location rowid of ward
 ;s wardid
 s phalocid=phaloc q:phalocid="" ""
 s phalocid=+phalocid
 s (retdate,retno,incicode,incidesc,buomdesc,retprice,retqty,retcosts,requestloc,requser,ruser)=""
 s bed=$g(bed),prescNo=$g(prescNo),admloc=$g(admloc)
 ;i wardid'="" s wardlocid=$p(^PAWARD(wardid),"^",5) ;
 f date=dfr:1:dto d
 .s pharetid="" f  s pharetid=$o(^PHARET(0,"RECLOC",phalocid,date,pharetid)) q:pharetid=""  d
 ..s retdate=$p(^PHARET(pharetid),"^",1)
 ..s rettime=$p(^PHARET(pharetid),"^",2)
 ..s ruserid=$p(^PHARET(pharetid),"^",3) 
 ..i ruserid'="" s ruser=$p(^SSU("SSUSR",+ruserid),"^",2)
 ..s retrequestid=$p(^PHARET(pharetid),"^",4) 
 ..s (requserid,requser,reqqty)=""
 ..i retrequestid'="" s requserid=$p(^RETRQ(retrequestid),"^",18),reqqty=$p(^RETRQ(retrequestid),"^",11) 
 ..i requserid'="" s requser=$p(^SSU("SSUSR",requserid),"^",2)
 ..
 ..s retno=$p(^PHARET(pharetid),"^",16)
 ..s retprice=$p(^PHARET(pharetid),"^",13) 
 ..s retqty=$p(^PHARET(pharetid),"^",12)
 ..s retcosts=$p(^PHARET(pharetid),"^",14) 
 ..s deptid=$p(^PHARET(pharetid),"^",9)
 ..i wardlocid'="" q:(wardlocid'=deptid)
 ..i deptid'="" s deptloc=$p(^CTLOC(+deptid),"^",2)
 ..s retinclbid=$p(^PHARET(pharetid),"^",6) 
 ..s beddr=$p(^PHARET(pharetid),"^",15)  ; beddr
 ..s admlocdr=$p(^PHARET(pharetid),"^",7) ; admin loc 
 ..s prescNo=$p(^PHARET(pharetid),"^",11)  ; prescript no 
 ..s admdr= $p(^PHARET(pharetid),"^",10) ; adm dr
 ..s oedis=$p(^PHARET(pharetid),"^",5)
 ..i beddr'="" s bed=$p(^PAWARD(+beddr,"BED",$p(beddr,"||",2)),"^",1)  
 ..i admlocdr'="" s admloc=$p(^CTLOC(+admlocdr),"^",2) ;
 ..s doctor=..Doctor(oedis) ; doctor name 
 ..s pname=..PaName(admdr)   ; patient name
 ..s pano=..PaNo(admdr)  ; patient No.
 ..
 ..
 ..//s dispqty=..GetDispQty(oedis) ; dispensed qty 
 ..s phaci=$p(^PHARET(pharetid),"^",23)
 ..s dispqty=   ..DispedQty(phaci)   //2007-09-30
 .. 
 ..s inciid=$p(retinclbid,"||",1)
 ..s incicat=$p(^INCI(inciid,2),"^",2) 
 ..q:(inci'="")&(inciid'=inci)
 ..q:(catid'="")&(catid'=incicat)
 ..s incicode=$p(^INCI(inciid,1),"^",1)
 ..s incidesc=$p(^INCI(inciid,1),"^",2)
 ..s buomdesc=$p(^CT("UOM",$p(^INCI(inciid,1),"^",10)),"^",2) ;s puruomdesc=$p(^CT("UOM",$p(^INCI(inciid,3),"^",6)),"^",2)
 ..s a1=$g(pharetid)_"^"_$zd(retdate,3)_"^"_$zt(rettime,1)_"^"_$g(retno)_"^"_$g(incicode)
 ..s a2=$g(incidesc)_"^"_$g(buomdesc)_"^"_$g(retprice)_"^"_$g(retqty)_"^"_$g(retcosts)
 ..s a3=$g(deptloc)_"^"_$g(requser)_"^"_$g(ruser)_"^"_$g(phaloc)_"^"_$g(bed)
 ..s a4=$g(admloc)_"^"_$g(prescNo)_"^"_$g(doctor)_"^"_$g(pname)_"^"_$g(dispqty)
 ..s a5=$g(pano)_"^"_$g(deptid)_"^"_$g(deptloc)_"^"_$g(reqqty)
 ..s i=i+1
 ..s ^TMP("DHCST",$this,"RET",pid,i)=a1_"^"_a2_"^"_a3_"^"_a4_"^"_a5
 q pid_"^"_i
}

ClassMethod ListRetResult(pid As %String, index As %String) As %String
{
 i $d(^TMP("DHCST",$this,"RET",pid,index)) q ^TMP("DHCST",$this,"RET",pid,index)
 q ""
}

ClassMethod PaName(adm As %String) As %String
{
 n (adm) ;
 s papmi=$p(^PAADM(adm),"^",1) ; 
 i papmi'=""  s paname=$p(^PAPER(+papmi,"ALL"),"^",1)      ;
 q $g(paname)
}

ClassMethod PaNo(adm As %String) As %String
{
 n (adm) ;
 s papmi=$p(^PAADM(adm),"^",1) ; 
 i papmi'="" 
 &Sql(select papmi_no into :PANO from pa_patmas where papmi_rowid=:papmi)
 q $g(PANO)
}

ClassMethod Doctor(OrdItem)
{
 //取医嘱医生
    n (OrdItem)
    &sql(select oeori_doctor_dr->ctpcp_desc
    into :doctor from OE_OrdItem where OEORI_Rowid=:OrdItem)
    q $g(doctor)
}

// DSP_OEORE_DR :  lq 071011测试没值

ClassMethod killRetTmp()
{
 k ^TMP($j,"RET")
}

ClassMethod GetInci(orditem As %String) As %String
{
 n (orditem)
 s inci=##class(web.DHCSTKUTIL).OrdItmInci(orditem)  //07-10-06
 i inci'="" d
 . s incicode=$p($g(^INCI(inci,1)),"^",1),incidesc=$p($g(^INCI(inci,1)),"^",2)
 q $g(incicode)_"^"_$g(incidesc)
}

ClassMethod GetIncib(inclb As %String) As %String
{
 //取批次rowid ( INC_ItmBat)
 n (inclb)
 s inci=+inclb
 s il=$p(inclb,"||",2)
 s lb=$p(inclb,"||",3)
 s incib=$p(^INCI(inci,"IL",il,"LB",lb),"^",1)
 q $g(incib)
}

ClassMethod RetReqExists(reqno As %String) As %Integer
{
 n (reqno)
 q:reqno="" ""
 s retrq=$o(^RETRQ(0,"RETRQNO",reqno,"")) 
 q +retrq
}

/// Description:判断是否允许退药
/// Input:DHC_PHACollectItm(PHACI_Rowid),retreqqty -申请数量
/// Output:0 - Not allowed  ,   1 - Allowed
/// Others:组件元素: dhcpha.pharetrequest.mValidateReqQty ; dhcpha.phareturn.mValidateReqQty
/// Creator:Liang Qiang
/// CreatDate:2009-03-25
/// zdm,2012-03-13,参数改为dodis，更改判断方式
/// w ##class(web.DHCSTPHARETURN).AllowReturn("","",869,28)
ClassMethod AllowReturn(itmjs As %Library.String = "", itmjsex As %Library.String = "", dspid As %String, retreqqty As %String, reqitm = "") As %String
{
     n (itmjs,itmjsex,dspid,retreqqty,reqitm)
     q:dspid="" 0
     q:retreqqty=0 0
     ;//判断申请单的可退数量
     s RetValue=1
     i $g(reqitm)'="" d 
     .s reqRetedQty=..GetReqReturnedQtyByPhaRet(reqitm) // s ReturnQty=..GetReqReturnedQtyByPhaRet(reqitm)  //LiangQiang
     .s reqID=$p(reqitm,"||",1)
     .s reqSub=$p(reqitm,"||",2)
     .q:(reqID="")!(reqSub="")
     .s reqRetQty=$p($g(^RETRQ(reqID,"I",reqSub)),"^",3)
     .i (reqRetQty-reqRetedQty-retreqqty)<0 s RetValue=0
     .q:RetValue=0
     q:RetValue=0 0
    
     s ordexerowid=$p($g(^DHCOEDISQTY(dspid)),"^",3)
     s orditem=$p(ordexerowid,"||",1,2)
     q:orditem="" 0
     s status=$p(^DHCOEDISQTY(dspid),"^",7)         ;配药记录状态
     q:status'="C" 0                                ;未发药不需要退药
     s stdate=$p(^DHCOEDISQTY(dspid),"^",21)        ;分发日期
     s returnqty=..ReturnedQty(orditem,stdate)
     //s returnqty=..ReturnedQtyByDodis(dspid)
     s dspqty=..DispedQtyByOe(orditem,stdate) //..DispedQty(dspid)
     s AvailRetQty=dspqty-returnqty ;计算该医嘱当天还可退药数量，可退数量=发药数量-已退数量
     ;
     q:(AvailRetQty-retreqqty)<0 0    ;欲退数量大于可退数量，
     q 1
}

/// Description:判断某配药记录是否允许退药
/// Input:配药表id
/// Output:0 - Not allowed  ,   1 - Allowed
/// Others:组件元素: dhcpha.pharetrequest.mValidateReqQty ; 
/// dhcpha.phareturn.mValidateReqQty
/// Creator:zhangdongmei
/// CreatDate:2012-03-15
ClassMethod AllowReturnByDodis(itmjs As %Library.String = "", itmjsex As %Library.String = "", dspid As %String, retreqqty As %String) As %String
{
     n (itmjs,itmjsex,dspid,retreqqty)
     ;
     q:dspid="" 0
     s qty=$p(^DHCOEDISQTY(dspid),"^",11)    ;发药数量
     s status=$p(^DHCOEDISQTY(dspid),"^",7)         ;配药记录状态
     q:status'="C" 0                                ;未发药不需要退药
     s returnedqty=..ReturnedQtyByDodis(dspid)      ;计算该配药记录的已退数量
     s availretqty=qty-returnedqty        ;可退数量
     ;
     q:(availretqty-retreqqty)<0 0    ;欲退数量大于可退数量，
     q 1
}

ClassMethod GetDispQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDispQueryExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetDispQueryExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, RegNo As %String, returnlocrowid As %String) As %Status
{
 //组件:dhcpha.phareturn
 
 Set repid=$I(^CacheTemp)
 ;
 Set qHandle=$lb(0,repid,0)
 Set ind=1
 //实现；
 d ResetVariables 
 q:StartDate="" $$$OK
 q:EndDate="" $$$OK
 q:returnlocrowid="" $$$OK
 s ss=..GetPaDsp(StartDate,EndDate,RegNo,returnlocrowid) 
 s cnt=$p(ss,"^",1)
 s pid=$p(ss,"^",2)
 q:cnt<=0 $$$OK
 s i=1
 f i=1:1:cnt  d
 . s dispitm=..ListPaDsp(pid,i)
 . d OutputRow
 . 
 k ^TMP("DHCST",$this,"GetPaDsp",pid)
 Quit $$$OK
 
OutputRow
 s TPaNo=$p(dispitm,"^",1)
 s TPaName=$p(dispitm,"^",2)
 s TDEPTDR=$p(dispitm,"^",3)
 s TWard=$p(dispitm,"^",4)
 i TWard["-" s TWard=$p(TWard,"-",2)
 s TBEDDR=$p(dispitm,"^",5)
 s TBedNo=$p(dispitm,"^",6)
 s TADMDR=$p(dispitm,"^",7)
 s TAdmNo=$p(dispitm,"^",8)
 s TADMLOCDR=$p(dispitm,"^",9)
 s TAdmLoc=$p(dispitm,"^",10)
 s TDoctor=$p(dispitm,"^",11)
 s TPrescNo=$p(dispitm,"^",12)
 s TINCLBDR=$p(dispitm,"^",13)
 s TOEDISDR=$p(dispitm,"^",14) 
 s TDispQty=$p(dispitm,"^",16)
 s TRECLOCDR=$p(dispitm,"^",17)
 s TCode=$p(dispitm,"^",18)
 s TDesc=$p(dispitm,"^",19)
 s TUom=$p(dispitm,"^",20)
 s TBatchNo=$p(dispitm,"^",21)
 s TReturnPrice=$p(dispitm,"^",22)
 s TReturnPrice=$fn(TReturnPrice,"N")
 s TRETRQDR=$p(dispitm,"^",23)
 s TRetReqQty=$p(dispitm,"^",24)
 s TReturnAmt=$p(dispitm,"^",25)
 //s TReturnAmt=$fn(TReturnAmt,"-",2)
 s TGeneric=$p(dispitm,"^",26)
 s TBarcode=$p(dispitm,"^",27)
 s TForm=$p(dispitm,"^",28)
 s TManf=$p(dispitm,"^",29)
 i TManf["-" s TManf=$p(TManf,"-",2)
 s TDspid=$p(dispitm,"^",30)  //07-09-30
 s Tnowprice=$p(dispitm,"^",31)
 //s Tnowprice=$fn(Tnowprice,"",4)
 s TCyFlag=$p(dispitm,"^",34)
 s TReturnQty=$s(TCyFlag="Y":TDispQty,1:"")
 s TPhaDispQty=$p(dispitm,"^",35)
 s TReturnDate="" 
 s TReturnTime=""
 s TReturnOper=""
 s EncryptLevelInfo=""
 s EncryptLevel=""
 s PatLevel=""
 s EncryptFlag=##Class(web.DHCSTCOMMPARA).GetEncryptLevelFlag("")
 i EncryptFlag=1 d
 .s papmidr=$p(^PAADM(TADMDR),"^",1)
 .s EncryptLevelInfo=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(papmidr,"")
 .s EncryptLevel=$p(EncryptLevelInfo,"^",1)
 .s PatLevel=$p(EncryptLevelInfo,"^",2)
 s TDspSubId=$p(dispitm,"^",32)
 s TPhacItmLbId=$p(dispitm,"^",33)
 i TReturnQty["." s TReturnQty=$fn(TReturnQty,"",$l($p(TReturnQty,".",2)))
 i TDispQty["." s TDispQty=$fn(TDispQty,"",$l($p(TDispQty,".",2)))
 i TRetReqQty["." s TRetReqQty=$fn(TRetReqQty,"",$l($p(TRetReqQty,".",2)))
 i TPhaDispQty["." s TPhaDispQty=$fn(TPhaDispQty,"",$l($p(TPhaDispQty,".",2)))
 
 set Data=$lb(TPaNo,TPaName,TDEPTDR,TWard,TBEDDR,TBedNo,TADMDR,TAdmNo,TADMLOCDR,TAdmLoc,TDoctor,TPrescNo,TINCLBDR,TOEDISDR,TReturnQty,TDispQty,TRECLOCDR,TCode,TDesc,TUom,TBatchNo,TReturnPrice,TRETRQDR,TRetReqQty,TReturnAmt,TReturnDate,TReturnTime,TReturnOper,TGeneric,TBarcode,TForm,TManf,TDspid,Tnowprice,EncryptLevel,PatLevel,TDspSubId,TPhacItmLbId,TCyFlag,TPhaDispQty)
 Set ^CacheTemp(repid,ind)=Data  
 Set ind=ind+1
 q 
ResetVariables  
 s (TPaNo,TPaName,TDEPTDR,TWard,TBEDDR,TBedNo,TADMDR,TAdmNo,TADMLOCDR,TAdmLoc,TDoctor,TPrescNo,TINCLBDR,TOEDISDR,TReturnQty,TDispQty,TRECLOCDR,TCode,TDesc,TUom,TBatchNo,TReturnPrice,TRETRQDR,TRetReqQty,TReturnAmt,TReturnDate,TReturnTime,TReturnOper,TGeneric,TBarcode,TForm,TManf,TDspid,Tnowprice,EncryptLevel,PatLevel,TDspSubId,TPhacItmLbId,TCyFlag,TPhaDispQty)=""
 q
}

ClassMethod GetDispQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDispQueryExecute ]
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

Query GetDispQuery(StartDate As %String, EndDate As %String, RegNo As %String, returnlocrowid As %String) As %Query(ROWSPEC = "TPaNo:%String,TPaName:%String,TDEPTDR:%String,TWard:%String,TBEDDR:%String,TBedNo:%String,TADMDR:%String,TAdmNo:%String,TADMLOCDR:%String,TAdmLoc:%String,TDoctor:%String,TPrescNo:%String,TINCLBDR:%String,TOEDISDR:%String,TReturnQty:%String,TDispQty:%String,TRECLOCDR:%String,TCode:%String,TDesc:%String,TUom:%String,TBatchNo:%String,TReturnPrice:%String,TRETRQDR:%String,TRetReqQty:%String,TReturnAmt:%String,TReturnDate:%String,TReturnTime:%String,TReturnOper:%String,TGeneric:%String,TBarcode:%String,TForm:%String,TManf:%String,TDspid:%String,Tnowprice:%String,TEncryptLevel:%String,TPatLevel:%String,TDspSubId:%String,TPhacItmLbId:%String,TCyFlag:%String,TPhaDispQty:%String")
{
}

ClassMethod PhaRetClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PhaRetExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod PhaRetExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, returnlocrowid As %String, incirowid As %String, incstkcatrowid As %String, wardrowid As %String, rettype = "") As %Status
{
 n (qHandle , StartDate , EndDate , returnlocrowid, incirowid , incstkcatrowid, wardrowid ,rettype)
 Set repid=$I(^CacheTemp)
 Set qHandle=$lb(0,repid,0)
 Set ind=1
 q:StartDate="" $$$OK
 q:EndDate="" $$$OK
 d ResetVariables1 
 s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
 s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
 s reclocid=""
 f  s reclocid=$o(^PHARET(0,"RECLOC",reclocid)) q:reclocid=""  d
 .q:(returnlocrowid'="")&&(returnlocrowid'=reclocid)
 .s CacuDate=""
 .f CacuDate=StartDate:1:EndDate d
 ..s pharid=""
 ..f  s pharid=$o(^PHARET(0,"RECLOC",reclocid,CacuDate,pharid)) q:pharid=""  d
 ...s pharobj=##class(User.DHCPhaReturn).%OpenId(pharid)
 ...s no=pharobj.PHARRetNo
 ...s ward=$s(pharobj.PHARDeptLocDR'="":pharobj.PHARDeptLocDR.%Id(),1:"")
 ...s dd=pharobj.PHARDate
 ...s rettime=pharobj.PHARTime
 ...s user=$s(pharobj.PHARSSUSRDR'="":pharobj.PHARSSUSRDR.%Id(),1:"")
 ...s ackdate=pharobj.PHARAckDate
 ...s acktime=pharobj.PHARAckTime
 ...s ackuser=$s(pharobj.PHARAckUser'="":pharobj.PHARAckUser.%Id(),1:"")
 ...d pharobj.%Close()
 ...i ward'="" s ward=$p(^CTLOC(+ward),"^",2)
 ...i wardrowid'="" s wardrow=$p(^PAWARD(wardrowid),"^",2) 
 ...i $g(wardrow)'="" q:wardrow'=ward
 ...i dd'="" s dd=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(dd)
 ...i rettime'="" s rettime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(rettime)
 ...i user'="" s user=$p(^SSU("SSUSR",+user),"^",2)
 ...i ackdate'="" s ackdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(ackdate)
 ...i acktime'="" s acktime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(acktime)
 ...i +ackuser>0 s ackuser=$p(^SSU("SSUSR",+ackuser),"^",2)
 ...e  s ackuser=""
 ...s rqData=$$FindReqData(pharid)
 ...s rquser=$p(rqData,"^",1)
 ...s reqno=$p(rqData,"^",2)
 ...s reqdate=$p(rqData,"^",3)
 ...s reqtime=$p(rqData,"^",4)
 ...s ret=0
 ...i incirowid'="" d
 ....s ret=$$FindRet(pharid,incirowid)
 ...q:ret=1
 ...s reclocdesc=$p(^CTLOC(reclocid),"^",2)
 ...s retway="直接退药"
 ...i rquser'="" s retway="申请单退药"
 ...s pharsub=$o(^PHARET(pharid,"I",""))
 ...i pharsub'="" d
 ....s pharsublb=$o(^PHARET(pharid,"I",pharsub,"B",""))
 ....i (pharsublb'="")&&($d(^DHCPRES(0,"TypePointer","Y",pharid_"||"_pharsub_"||"_pharsublb))) s retway="冲减退药"
 ...q:(rettype=1)&&(retway'="直接退药")
 ...q:(rettype=2)&&(retway'="申请单退药")
 ...q:(rettype=3)&&(retway'="冲减退药")
 ...d OutputRow1
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow1
 s tPhaRetNo=no
 s tWard=ward    
 s tReturnDate=dd  
 s tReturnOper=user 
 s trquser=rquser
 set Data=$lb(tPhaRetNo,tWard,tReturnDate,tReturnOper,ackdate,ackuser,trquser,reclocdesc,retway,reqno,reqdate,reqtime,rettime,acktime,pharid)
 Set ^CacheTemp(repid,ind)=Data  
 Set ind=ind+1
 q
ResetVariables1
 s (tPhaRetNo,tWard,tReturnDate,tReturnOper,ackdate,ackuser,trquser,reclocdesc,retway,reqno,reqdate,reqtime,rettime,acktime)=""
FindRet(pharrowid,incirowid)
 ; 0 -符合条件 1 - 不符条件
 q:incirowid="" 0
 s flag=1
 s phar=""
 f  s phar=$o(^PHARET(pharrowid,"I",phar)) q:(phar="")!(flag=0)  d
 .s inci=$p(^PHARET(pharrowid,"I",phar),"^",11)
 .i (incirowid'="")&&(inci=incirowid) d
 ..s flag=0
 .q:flag=0
 q flag
FindReqData(pharrowid)
    n (pharrowid)
    k FindReqDataDATA
    q:pharrowid="" ""
    s reqstr=""
    s reqidstr=$p(^PHARET(pharrowid),"^",4) 
    s len=$l(reqidstr,",")
    f i=1:1:len  d
    .s rquserdr=""
    .s reqid=$p(reqidstr,",",i)
    .q:reqid=""
    .q:'$d(^RETRQ(reqid))
    .s rquserdr=$p(^RETRQ(reqid),"^",15) 
    .s rquser=$p($g(^SSU("SSUSR",+rquserdr)),"^",2)
    .s rqno=$p(^RETRQ(reqid),"^",1) 
    .s rqdate=$p(^RETRQ(reqid),"^",16) 
    .s rqtime=$p(^RETRQ(reqid),"^",17) 
    .s rqdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(rqdate)
    .s rqtime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(rqtime)
    .s FindReqDataDATA("RQUSER")=$s($g(FindReqDataDATA("RQUSER"))="":rquser,1:FindReqDataDATA("RQUSER")_"</br>"_rquser)
    .s FindReqDataDATA("RQNO")=$s($g(FindReqDataDATA("RQNO"))="":rqno,1:FindReqDataDATA("RQNO")_"</br>"_rqno)
    .s FindReqDataDATA("RQDATE")=$s($g(FindReqDataDATA("RQDATE"))="":rqdate,1:FindReqDataDATA("RQDATE")_"</br>"_rqdate)
    .s FindReqDataDATA("RQTIME")=$s($g(FindReqDataDATA("RQTIME"))="":rqtime,1:FindReqDataDATA("RQTIME")_"</br>"_rqtime)
    q:'$d(FindReqDataDATA) ""
    q FindReqDataDATA("RQUSER")_"^"_FindReqDataDATA("RQNO")_"^"_FindReqDataDATA("RQDATE")_"^"_FindReqDataDATA("RQTIME")
}

ClassMethod PhaRetFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PhaRetExecute ]
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

Query PhaRet(StartDate As %String, EndDate As %String, returnlocrowid As %String, incirowid As %String, incstkcatrowid As %String, wardrowid As %String, rettype = "") As %Query(ROWSPEC = "tPhaRetNo:%String,tWard:%String,tReturnDate:%String,tReturnOper:%String,tAckDate:%String,tAckUser:%String,trquser:%String,tRecLocDesc:%String,tRetWay:%String,tReqNo,tReqDate,tReqTime,tReturnTime,tAckTime,tPhaRet")
{
}

/// Description: 此段用来处理退药后即刻作帐单
ClassMethod MakeBillRet(pharet) As %String
{
    n (pharet)
    k MakeBillRetDATA
    q:pharet="" -1
    s pharet=+pharet
    q:'$d(^PHARET(pharet)) -2
    s retuser=$p(^PHARET(pharet),"^",3 )  
    s retitm=""
    f  s retitm=$o(^PHARET(pharet,"I",retitm)) q:retitm=""  d
    .s adm=$p(^PHARET(pharet,"I",retitm),"^",8)
    .s dodis=$p(^PHARET(pharet,"I",retitm),"^",13)
    .s ordexeid=$p(^DHCOEDISQTY(dodis),"^",3)
    .i '$d(MakeBillRetDATA(adm)) d
    .. s MakeBillRetDATA(adm)=ordexeid
    .e  d
    .. s MakeBillRetDATA(adm)=MakeBillRetDATA(adm)_"^"_ordexeid
    s ret=""
    s adm=""
    f  s adm=$o(MakeBillRetDATA(adm)) q:adm=""  d
    .s str=MakeBillRetDATA(adm)
    .q:str=""
    .s ret=##Class(web.UDHCJFBILL).BILLN(adm,retuser,str)
    k MakeBillRetDATA
    q $g(ret)
}

/// w ##class(%ResultSet).RunQuery("web.DHCSTPHARETURN","RetItm","RTDHSZHYYZY20190709009")
Query RetItm(RetNo As %String, IncId As %String = "", RetID = "") As %Query(ROWSPEC = "tPhaRetNo:%String,tRegNo:%String,tName:%String,tWard:%String,tBedNo:%String,tAdmLoc:%String,tDoctor:%String,tPrescNo:%String,tDesc:%String,tUom:%String,tReturnPrice:%String,tReturnQty:%String,tReturnAmt:%String,tDispQty:%String,tRetReqQty:%String,tReturnDate:%String,tReturnTime:%String,tReturnOper:%String,TGeneric:%String,TBarcode:%String,TForm:%String,TManf:%String,TEncryptLevel:%String,TPatLevel:%String,TResPatName,TResPatNo,TResBedNo,TResPatQty")
{
}

ClassMethod RetItmExecute(ByRef qHandle As %Binary, RetNo As %String, IncId As %String = "", RetID = "") As %Status
{
 n (qHandle,RetNo,IncId,RetID,%session)
 Set repid=$I(^CacheTemp)
 Set qHandle=$lb(0,repid,0)
 Set ind=1
 q:RetID="" $$$OK
 s pharetid=RetID
 q:pharetid="" $$$OK
 s retno=RetNo
 s retdate=$p(^PHARET(pharetid),"^",1)
 s rettime=$p(^PHARET(pharetid),"^",2)
 s ruserid=$p(^PHARET(pharetid),"^",3) 
 i ruserid'="" s ruser=$p(^SSU("SSUSR",+ruserid),"^",2)
 s deptid=$p(^PHARET(pharetid),"^",6)
 i deptid'="" s deptloc=$p(^CTLOC(+deptid),"^",2)
 s retchl=""
 s amttotal=0
 f  s retchl=$o(^PHARET(pharetid,"I",retchl)) q:retchl=""  d
 .s retrequestid=$p(^PHARET(pharetid,"I",retchl),"^",7) 
 .s (requserid,requser,reqqty)=""
 .s reqchl=$p(retrequestid,"||",2)
 .i retrequestid'="" d
 ..i $D(^RETRQ(+retrequestid,"I",reqchl)) d
 ...s requserid=$p(^RETRQ(+retrequestid,"I",reqchl),"^",9)
 ...s reqqty=$p(^RETRQ(+retrequestid,"I",reqchl),"^",3) 
 .i requserid'="" s requser=$p(^SSU("SSUSR",requserid),"^",2)
 .s retprice="",retcosts=0,dispqty=0,inclb=""
 .s retlb=""
 .f  s retlb=$o(^PHARET(pharetid,"I",retchl,"B",retlb)) q:retlb=""  d
 ..s retlbData=^PHARET(pharetid,"I",retchl,"B",retlb)
 ..i retprice="" s retprice=$p(retlbData,"^",5)
 ..s retcosts=retcosts+$p(retlbData,"^",6)
 ..s phacItmLbId=$p(retlbData,"^",8)
 ..s phacItmLbQty=$p($g(^DHCPHAC(+phacItmLbId,"I",+$p(phacItmLbId,"||",2),"B",+$p(phacItmLbId,"||",3))),"^",2)
 ..s dispqty=dispqty+phacItmLbQty
 ..s inclb=$p(retlbData,"^",1)
 .s retqty=$p(^PHARET(pharetid,"I",retchl),"^",2)
 .s inciid=$p(^PHARET(pharetid,"I",retchl),"^",11)
 .//q:(IncId'="")&&(IncId'=inciid)
 .s beddr=$p(^PHARET(pharetid,"I",retchl),"^",10) ; beddr
 .s admlocdr=$p(^PHARET(pharetid,"I",retchl),"^",9) ; admin loc 
 .s Dodis=$p(^PHARET(pharetid,"I",retchl),"^",13)
 .s OrdItemId=$p(^DHCOEDISQTY(Dodis),"^",1)
 .s prescNo=$p(^OEORD(+OrdItemId,"I",$p(OrdItemId,"||",2),1),"^",14) ; prescript no 
 .s admdr=$p(^PHARET(pharetid,"I",retchl),"^",8) ; adm dr
 .s oedis=$p(^PHARET(pharetid,"I",retchl),"^",1)
 .s bed=""
 .i beddr'="" d
 ..s montherAdmId=$p(^PAADM(admdr),"^",75)
 ..i montherAdmId="" s bed=$p($g(^PAWARD(+beddr,"BED",+$p(beddr,"||",2))),"^",1)
 ..e  s bed=##class(web.DHCSTCOMMONORDER).GetAdmTransBed(admdr,beddr)
 .i admlocdr'="" s admloc=$p(^CTLOC(+admlocdr),"^",2) ;
 .s doctor=..Doctor(oedis) ; doctor name 
 .s pname=..PaName(admdr)   ; patient name
 .s pano=..PaNo(admdr)  ; patient No.
 .s incicat=$p(^INCI(inciid,2),"^",2) 
 .s incicode=$p(^INCI(inciid,1),"^",1)
 .s incidesc=$p(^INCI(inciid,1),"^",2)
 .s buomdesc=$p(^CT("UOM",$p(^INCI(inciid,1),"^",10)),"^",2) ;s puruomdesc=$p(^CT("UOM",$p(^INCI(inciid,3),"^",6)),"^",2)
 ..;2007-8-6,zdm,增加通用名,剂型,规格,厂家及总金额
 .s generic=##class(web.DHCSTCOMMONSRV).getGeneric(inciid)
 .s form=##class(web.DHCSTCOMMONSRV).GetForm(inciid)
 .s Specifaction=##class(web.DHCSTCOMMONSRV).getBarcode(inciid)
 .//s manf=$p(##class(web.DHCST.Common.DrugInfoCommon).GetManf(inciid),"^",3)
 .s manf=""     //如果有多个批次退药记录，仅取最后一个批次的厂家
 .i inclb'="" d
 ..s incib=..GetIncib(inclb)
 ..s VendManf=##class(web.DHCST.Common.DrugStkCommon).VendManfByIncIb(incib) //查找批次供应商及厂家
 ..s manf=$p(VendManf,"^",4)
 .s amttotal=amttotal+retcosts
 .s EncryptLevelInfo=""
 .s EncryptLevel=""
 .s PatLevel=""
 .s EncryptFlag=##Class(web.DHCSTCOMMPARA).GetEncryptLevelFlag("")
 .i EncryptFlag=1 d
 ..s papmidr=$p(^PAADM(admdr),"^",1)
 ..s EncryptLevelInfo=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(papmidr,"")
 ..s EncryptLevel=$p(EncryptLevelInfo,"^",1)
 ..s PatLevel=$p(EncryptLevelInfo,"^",2)
 .s retlb=""
 .f  s retlb=$o(^PHARET(pharetid,"I",retchl,"B",retlb)) q:retlb=""  d
 ..q:+retlb=0
 ..s resFlag=0
 ..s resPatName="",resPatNo="",resBedNo="",resPatQty=""
 ..s resv="0"
 ..f  s resv=$o(^DHCPRES(0,"PhaRet",pharetid_"||"_retchl_"||"_retlb,resv))  q:resv=""  d
 ...s resFlag=1
 ...s resvChl="0"
 ...f  s resvChl=$o(^DHCPRES(0,"PhaRet",pharetid_"||"_retchl_"||"_retlb,resv,resvChl))  q:resvChl=""  d
 ....s resvSub="0"
 ....f  s resvSub =$o(^DHCPRES(0,"PhaRet",pharetid_"||"_retchl_"||"_retlb,resv,resvChl,resvSub)) q:resvSub=""  d
 .....s phaitm =$p(^DHCPRES(resv,"DET",resvChl),"^",2)
 .....s resAdmId = $p(^DHCPHAC(+phaitm,"I",$p(phaitm,"||",2)),"^",3)
 .....s resPatId =$p(^PAADM(resAdmId),"^",1)
 .....s resPatName=$p(^PAPER(resPatId,"ALL"),"^",1)       //发药姓名
 .....s resPatNo = $p(^PAPER(resPatId,"PAT",1),"^",2)  //发药登记号
 .....s resBedNo=""
 .....s resBedId=$p(^PAADM(resAdmId),"^",73)    //20160510 zhouyg 取床号修改，未转病区则取当前床位，转病区则床号为空
 .....i resBedId'="" s resBedNo=$p($g(^PAWARD(+$p(resBedId,"||",1),"BED",+$p(resBedId,"||",2))),"^",1)        ;病人床号
 .....s resPatQty =$p(^DHCPRES(resv,"DET",resvChl,"SUB",resvSub),"^",2)
 .....s retqty=resPatQty
 .....s retcosts=retprice*retqty
 .....d outputRetItm
 .i resFlag=0 d outputRetItm
 d outputtotal
 q $$$OK
outputRetItm
 s tPhaRetNo=$g(retno)
 s tRegNo=$g(pano)
 s tName=$g(pname)
 s tWard=$g(deptloc)
 s tBedNo=$g(bed)
 s tAdmLoc=$g(admloc)
 s tDoctor=$g(doctor)
 s tPrescNo=$g(prescNo)
 s tDesc=$g(incidesc)
 s tUom=$g(buomdesc)
 s tReturnPrice=$g(retprice)
 s tReturnQty=$g(retqty)
 s tReturnAmt=$g(retcosts)
 s tDispQty=$g(dispqty)
 s tRetReqQty=$g(reqqty)
 s tReturnDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(retdate)
 s tReturnTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(rettime)
 s tReturnOper=$g(ruser)
 s tGeneric=$g(generic)
 s tBarcode=$g(Specifaction)
 s tForm=$g(form)
 s tManf=$g(manf) 
 s tEncryptLevel=$g(EncryptLevel)
 s tPatLevel=$g(PatLevel)
 s tReturnPrice=$fn(tReturnPrice,"N")
 s tReturnAmt=$fn(tReturnAmt,"N")
 s tReturnQty=$fn(tReturnQty,"N")
 s tDispQty=$fn(tDispQty,"N")
 s tRetReqQty=$fn(tRetReqQty,"N")
 s tResPatName=$g(resPatName)
 s tResPatNo=$g(resPatNo)
 s tResBedNo=$g(resBedNo)
 s tResPatQty=$g(resPatQty)
 set Data=$lb(tPhaRetNo,tRegNo,tName,tWard,tBedNo,tAdmLoc,tDoctor,tPrescNo,tDesc,tUom,tReturnPrice,tReturnQty,tReturnAmt,tDispQty,tRetReqQty,tReturnDate,tReturnTime,tReturnOper,tGeneric,tBarcode,tForm,tManf,tEncryptLevel,tPatLevel,tResPatName,tResPatNo,tResBedNo,tResPatQty)
 Set ^CacheTemp(repid,ind)=Data  
 Set ind=ind+1
 q
outputtotal
 ;2007-8-6,zdm
 i $g(amttotal)["." s amttotal=$fn(amttotal,"",$l($p(amttotal,".",2)))
 set Data=$lb("","总计","","","","","","","","","","",$g(amttotal),"","","","","","","","","","","","","")
 Set ^CacheTemp(repid,ind)=Data  
 Set ind=ind+1
 q
}

ClassMethod RetItmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = RetItmExecute ]
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

ClassMethod RetItmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = RetItmExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetReturnByNo(itmjs As %Library.String = "", itmjsex As %Library.String = "", retno As %String) As %Integer
{
 //根据退药单号取出退药数据(为退药单打印准备数据)
 n (itmjs,itmjsex,retno)
 s pid=..NewPid()
 k ^TMP("DHCST",$this,"GetReturnByNo",pid)
 s n=0
 s pharid=""     
 f  s pharid=$o(^PHARET(0,"NO",retno,pharid)) q:pharid=""  d
 .s deptdr=$p(^PHARET(pharid),"^",9)
 .i deptdr'="" s dept=$p($g(^CTLOC(deptdr)),"^",2)
 .s admdr=$p(^PHARET(pharid),"^",10)
 .s pa=..GetPaByAdm(admdr)
 .s pano=$p(pa,"^",1),paname=$p(pa,"^",2),padob=$p(pa,"^",3)
 .q:pano=""
 .s pmi=$o(^PAPERi("PAPMI_PatNo",pano,""))
 .i padob'="" s age=##class(PHA.FACE.IN.Com).GetAge(pmi,admdr) //年龄统一调用接口wyx 2015-01-29
 .s beddr=$p(^PHARET(pharid),"^",15)
 .i beddr'="" s bed=$p(^PAWARD(+beddr,"BED",$p(beddr,"||",2)),"^",1)
 .s diagnose=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(admdr,",")
 .s inclbdr=$p(^PHARET(pharid),"^",6)
 .s inci=+inclbdr
 .;s alias=$o(^INCALIAS(0,"INCI",inci,""))
 .;i alias'="" s alias=$p(^INCALIAS(alias),"^",3)
 .s alias=##class(web.DHCSTCOMMONSRV).getGeneric(inci)  ;别名-通用名
 .s incicode=$p(^INCI(inci,1),"^",1)
 .s incidesc=$p(^INCI(inci,1),"^",2)
 .s uom=##class(web.DHCSTITMDESC).GetBaseUoDescByCode(incicode)
 .s qty=$p(^PHARET(pharid),"^",12)
 .s price=$p(^PHARET(pharid),"^",13)
 .s amt=$p(^PHARET(pharid),"^",14)
 .s retreason=$p(^PHARET(pharid),"^",22)
 .i retreason'="" s retreason=$p(^BLC("RFR",retreason),"^",2)
 .s manf=$p(##class(web.DHCST.Common.DrugInfoCommon).GetManf(inci),"^",3)  ;产地 070523
 .s a1=$g(retno)_"^"_$g(dept)_"^"_$g(bed)_"^"_$g(diagnose)
 .s a2=$g(pano)_"^"_$g(paname)_"^"_$g(age)
 .s a3=$g(incidesc)_"^"_$g(alias)_"^"_$g(uom)_"^"_+$g(qty)_"^"_+$g(price)_"^"_+$g(amt)_"^"_$g(retreason)_"^"_$g(manf) 
 .i '$d(^TMP("DHCST",$this,"GetReturnByNo",pid,pano)) d
 ..s ^TMP("DHCST",$this,"GetReturnByNo",pid,pano)=a1_"^"_a2
 .s n=n+1
 .s ^TMP("DHCST",$this,"GetReturnByNo",pid,pano,n)=a3
 q pid_"^"_n
}

ClassMethod ListRetPaNo(itmjs As %Library.String = "", itmjsex As %Library.String = "", pid As %String, pano As %String) As %String
{
 
    ;取出退药单中的病人信息
    n (itmjs,itmjsex,pid,pano)
    s nextpano=$o(^TMP("DHCST",$this,"GetReturnByNo",pid,pano)) q:nextpano="" "end"
    s data=^TMP("DHCST",$this,"GetReturnByNo",pid,nextpano)
    q data
}

ClassMethod ListRetDetail(itmjs As %Library.String = "", itmjsex As %Library.String = "", pid As %String, pano As %String, i As %Integer) As %String
{
  
    ; 取出退药单中的药品明细信息
    n (itmjs,itmjsex,pid,pano,i)
    s n=$o(^TMP("DHCST",$this,"GetReturnByNo",pid,pano,i)) q:n="" -1
    s data=^TMP("DHCST",$this,"GetReturnByNo",pid,pano,n) 
    q data_"^"_n
}

ClassMethod AuditPhaRetByUser(retno As %String, usercode As %String, userpass As %String) As %String
{
 n (retno,usercode,userpass)
 s userid=##class(web.DHCSTKUTIL).ValidateUser(usercode,userpass)
 q:userid<0 -10
 s pharet=$o(^PHARET(0,"NO",retno,0))
 q:pharet="" 0  ;退出确认或审核
 s retuser=$p(^PHARET(pharet),"^",3)
 i retuser=userid q -30
 
 ;执行审核
 s ret=..AuditPhaRet(retno,userid)
 q ret
}

ClassMethod GetRetNumByOrditem(orditemrowid) As %String
{
  ;据医嘱项取退药表中的退药总数量
  ;2007/09/28 ;add by lq
  n (orditemrowid)
  s retnumtotal=0
  s retrowid=""
  f  s retrowid=$o(^PHARET(0,"PHARET",orditemrowid,retrowid)) q:retrowid=""  d 
  . s retnum=$p( ^PHARET(retrowid),"^",12) //退药申请数量
  . s retnumtotal=retnumtotal+retnum
  q retnumtotal
}

// zdm,2012-03-08,取某医嘱某天的可退数量

ClassMethod AvailQtyToRet(OrdItmRowid As %String, DateDosing As %String) As %String
{
  n (OrdItmRowid,DateDosing)
  q:OrdItmRowid="" ""
  q:DateDosing="" ""
  s SumDspQty=0
  s pha=""
  f  s pha=$o(^DHCPHAC(0,"PHADSP",OrdItmRowid,DateDosing,pha)) q:pha=""  d
  .s chl=""
  .f  s chl=$o(^DHCPHAC(0,"PHADSP",OrdItmRowid,DateDosing,pha,chl)) q:chl=""  d
  ..s DspQty=$p(^DHCPHAC(pha,"I",chl),"^",6)   //发药数
  ..s SumDspQty=SumDspQty+DspQty
  .
  s ReturnedQty=..ReturnedQty(OrdItmRowid,DateDosing)
  s AvailQty=SumDspQty-ReturnedQty
  q AvailQty         //可退数
}

/// zdm,2012-03-08,取某医嘱某天退药数量
ClassMethod ReturnedQty(OrdItmRowid As %String, DateDosing As %String) As %String
{
  n (OrdItmRowid,DateDosing)
  q:OrdItmRowid="" ""
  q:DateDosing="" ""
  s SumQty=0
  s phar=""
  f  s phar=$o(^PHARET(0,"OEDIS",OrdItmRowid,DateDosing,phar)) q:phar=""  d
  .s chl=""
  .f  s chl=$o(^PHARET(0,"OEDIS",OrdItmRowid,DateDosing,phar,chl)) q:chl=""  d
  ..s Qty=$p(^PHARET(phar,"I",chl),"^",2)
  ..s SumQty=SumQty+Qty
  .
  q SumQty
}

/// zdm,2012-03-14,取某配药记录的已退数量
ClassMethod ReturnedQtyByDodis(Dodis As %String) As %String
{
  n (Dodis)
  q:Dodis="" 0
  s retqty=0
  s OrdExeRowid=$p(^DHCOEDISQTY(Dodis),"^",3) 
  s RetDodis=""
  f  s RetDodis=$o(^DHCOEDISQTY(0,"OEORE",OrdExeRowid,RetDodis))  q:RetDodis=""  d
  .s type=$p(^DHCOEDISQTY(RetDodis),"^",13)
  .q:type'="Y"   ;住院退药
  .s status=$p(^DHCOEDISQTY(RetDodis),"^",7) 
  .q:status'="R"   ;退药
  .s retqty=retqty+$p(^DHCOEDISQTY(RetDodis),"^",11) 
  ;.
  ;--今后所有已退数量从退药表中累计 LiangQiang 2012-04-14
  ;函数ReturnedQty已经达到了下面的功能 zhouyg 20120601
  /*s retqty=0
  s oeori=$p(^DHCOEDISQTY(Dodis),"^",1)
  s dosdate=$p(^DHCOEDISQTY(Dodis),"^",21)
  s phar=""
  f  s phar=$o(^PHARET(0,"OEDIS",oeori,dosdate,phar)) q:phar=""  d
  .s sub=""
  .f  s sub=$o(^PHARET(0,"OEDIS",oeori,dosdate,phar,sub)) q:sub=""  d
  ..s retqty=retqty+$p(^PHARET(phar,"I",sub),"^",2)
  */
  q retqty
}

/// 取某配药记录的已发药数量
ClassMethod DispedQty(dodis As %String) As %String
{
 //发药数量(DHC_PhaCollectitm)
 n (dodis)
 q:dodis="" 0
 s status=$p(^DHCOEDISQTY(dodis),"^",7) //zhouyg 2012=06-01
 q:status'="C" 0
 s qty=$p(^DHCOEDISQTY(dodis),"^",11)
 /*
 s phaci=$p(^DHCOEDISQTY(dodis),"^",14)
 s phac=$p(phaci,"||",1),ch=$p(phaci,"||",2)
 q:phac="" ""
 q:ch="" ""
 s qty=$p($G(^DHCPHAC(phac,"I",ch)),"^",6)
 */
 q $g(qty)
}

/// Descript:   取某医嘱某天的已发药数量
/// Creater:    zhouyg
/// CreateDate: 2012-06-01
/// Input:      OrdItmRowid-医嘱子表ID,DateDosing-医嘱日期(H格式)
/// Return:     医嘱总的已发药数量
ClassMethod DispedQtyByOe(OrdItmRowid As %String, DateDosing As %String) As %String
{
 n (OrdItmRowid,DateDosing)
 q:OrdItmRowid="" 0
 q:DateDosing="" 0
 s seqno="",tQty=0
 f  s seqno=$o(^DHCOEDISQTY(0,"SEQNO",OrdItmRowid,DateDosing,seqno)) q:seqno=""  d
 .s dspID=""
 .f  s dspID=$o(^DHCOEDISQTY(0,"SEQNO",OrdItmRowid,DateDosing,seqno,dspID)) q:dspID=""  d
 ..s status=$p(^DHCOEDISQTY(dspID),"^",7)   //zhouyg 2012-06-01
 ..q:status'="C" 
 ..s qty=$p(^DHCOEDISQTY(dspID),"^",11)
 ..s tQty=tQty+qty
 q $g(tQty)
}

/// zdm,2012-03-13,退药表结构变化更新
ClassMethod InsertDODIS(retitm As %String) As %String
{
    //插入dhc_oedispensing表（根据退药数据）
    n (retitm) 
    q:retitm="" 0
    s retid=+retitm
    s retchl=$p(retitm,"||",2)
    s retrq=$p(^PHARET(retid,"I",retchl),"^",7)
    i retrq'="" d
    .s RefundStatus=$p(^RETRQ(+retrq,"I",$p(retrq,"||",2)),"^",12)
    .i RefundStatus=1 d
    ..s upd=..UpdatePharDspb(retrq, retitm) 
    ..i upd'=$$$OK s ret = "-1^更新退药关联打包子表失败"
    ..s ret=..UpdDspPointer(retitm)
    q:($g(RefundStatus)=1)&($g(ret)'=0) -10
    q:$g(RefundStatus)=1 0
    //
    s oeori=$p(^PHARET(retid,"I",retchl),"^",1)  //
    s inci=$p(^PHARET(retid,"I",retchl),"^",11)
    s adm=$p(^PHARET(retid,"I",retchl),"^",8)
    s datedosing=$p(^PHARET(retid,"I",retchl),"^",12)
    s dodis=$p(^PHARET(retid,"I",retchl),"^",13)  ;配药表id
    s ordexeid=$p(^DHCOEDISQTY(dodis),"^",3)
    s recloc=$p(^PHARET(retid),"^",5)
    s dept=$p(^PHARET(retid),"^",6)    ;申请退药科室
    s dd=$p(^PHARET(retid),"^",1)
    s tt=$p(^PHARET(retid),"^",2)
    s user=$p(^PHARET(retid),"^",3)
    s retlb=$o(^PHARET(retid,"I",retchl,"B",""))
    q:retlb="" 0
    s dspid=$o(^DHCOEDISQTY(0,"OEORE",ordexeid,""),-1) 
    s dspstatus=$p($g(^DHCOEDISQTY(dspid)),"^",7)
    s dspType=$p($g(^DHCOEDISQTY(dspid)),"^",13)
    s dspPoiner=$p($g(^DHCOEDISQTY(dspid)),"^",14)
    s rdspid=""
    i (dspstatus="R")&&(dspType="Y")&&(+dspPoiner'=0) d
    .i +retid=+dspPoiner s rdspid=dspid
    s Phcdf=##class(web.DHCST.Common.DrugInfoCommon).GetPhcdf(inci)
    s phcUomId=$p(^PHCD(+Phcdf,"DF",+$p(Phcdf,"||",2),2),"^",4)
    i phcUomId="" trollback
    q:phcUomId="" -1
    s type="Y",status="R",pointer=+retitm
    
    //1、处理打包主表
    s err=0
    s $ZT="Error^DHCSTERROR"            ;增加错误处理                                     
    tstart
    i rdspid'=""  d
    .s DspID=rdspid
    e  d
    .&sql(insert into dhc_oedispensing(DSP_OEORI_DR,DSP_QtyUOM,DSP_Status,DSP_Date,DSP_Time,
    DSP_User,DSP_ConfirmUser,DSP_Type,DSP_Pointer,DSP_DateAdd,DSP_TimeAdd,DSP_AdmLoc_DR,
    DSP_RecDep_DR,DSP_Adm_DR,DSP_OEORE_DR,DSP_DateDosing) values (:oeori,:phcUomId,:status,
    :dd,:tt,:user,:user,:type,:pointer,:dd,:tt,:dept,:recloc,:adm,:ordexeid,:datedosing))
    .i SQLCODE'=0  d
    ..s ret=$$SqlErrorRecord^DHCSTERROR("InsertDODIS:dhc_oedispensing",retitm,SQLCODE_":"_%msg)
    ..s err=-2
    .e  d
    ..s DspID=$p(%ROWID,$c(1))
    .
    i err'=0 trollback
    q:err'=0 err
    //2、处理打包子表
    s inclb=$p(^PHARET(retid,"I",retchl,"B",retlb),"^",1)
    s qty=$p(^PHARET(retid,"I",retchl),"^",2)
    s rp=$p(^PHARET(retid,"I",retchl,"B",retlb),"^",3)
    s sp=$p(^PHARET(retid,"I",retchl,"B",retlb),"^",5)
    s DspbStr=DspID_"^"_inclb_"^"_qty_"^"_sp_"^"_rp_"^"_inci_"^"_status
    s RetIns=##Class(web.DHCSTOEDispBatch).InsDspBatch(DspbStr)
    s InsSQLCODE=$p(RetIns,"^",1)
    i InsSQLCODE'=0 trollback
    q:InsSQLCODE'=0 -3
    //3、回写退药孙表
    s retdspbatch=$p(RetIns,"^",2)
    s pharetsid=retid_"||"_retchl_"||"_retlb
    &sql(UPDATE DHC_PhaReturnItmLB SET PHARIL_DSPB_DR=:retdspbatch WHERE PHARIL_Rowid=:pharetsid)
    i SQLCODE'=0 trollback
    q:SQLCODE'=0 -4
    //4、应计费组要求按照药学项基本单位回写打包主表数量(协定方只写付数)
    s prescno=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),1),"^",14)  ;处方号
    s CheckXDPresc=##class(web.DHCINPHA.MTCommon.PublicCallMethod).CheckCMXDPTCom(prescno)
    i CheckXDPresc=3  d                                         ;协定方
    .s rdspqty=+$p(^DHCOEDISQTY(dodis),"^",5)
    .s $p(^DHCOEDISQTY(DspID),"^",2)=rdspqty
    .s $p(^DHCOEDISQTY(DspID),"^",5)=rdspqty
    .s $p(^DHCOEDISQTY(DspID),"^",11)=rdspqty
    e  d
    .s uom=$p(^INCI(inci,1),"^",10)
    .s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(uom,phcUomId)
    .s:fac="" err=-5
    .q:fac="" 
    .s rdspqty=qty*fac
    .s $p(^DHCOEDISQTY(DspID),"^",2)=+$p($G(^DHCOEDISQTY(DspID)),"^",2)+rdspqty
    .s $p(^DHCOEDISQTY(DspID),"^",5)=+$p($G(^DHCOEDISQTY(DspID)),"^",5)+rdspqty
    .s $p(^DHCOEDISQTY(DspID),"^",11)=+$p($G(^DHCOEDISQTY(DspID)),"^",11)+rdspqty
    i err'=0 trollback
    q:err'=0 err
    tcommit
    q 0
}

/// zdm,2012-03-13,退药表结构变化
ClassMethod InsertRetA(rowid As %String) As %String
{
 ;退药时因之前调价产生损益 ,信息插入退药损益表 DHC_RetAspAmount
 ;lq 2008-02-15
 n (rowid)
 q:$g(rowid)="" -1
 s retid=+rowid
 s retchl=$p(rowid,"||",2)
 s pharlbSub=$p(rowid,"||",3)
 s inclb=$p(^PHARET(retid,"I",retchl,"B",pharlbSub),"^",1)
 s inci=$p(^PHARET(retid,"I",retchl),"^",11)
 s buom=$p(^INCI(inci,1),"^",10)
 s locdr=$p(^PHARET(retid),"^",5)
 //s retprice=$p(^PHARET(retid,"I",retchl),"^",4) ;退药价格
 s CustStr=##Class(web.DHCSTCOMMO).GetLocCust(locdr)
 s HospID=$p(CustStr,"^",5)
 s CustID=$p(CustStr,"^",1)
 s qty=$p(^PHARET(retid,"I",retchl,"B",pharlbSub),"^",2)
 s retRp=$p(^PHARET(retid,"I",retchl,"B",pharlbSub),"^",3)
 s retRpAmt=$p(^PHARET(retid,"I",retchl,"B",pharlbSub),"^",4)
 s retSp=$p(^PHARET(retid,"I",retchl,"B",pharlbSub),"^",5)
 s retSpAmt=$p(^PHARET(retid,"I",retchl,"B",pharlbSub),"^",6)
 
 //s sp=##class(web.DHCSTCOMMONSRV).GetPriceElse(+inci,+$h,"",hospdr)
 s CurSp=##Class(web.DHCSTPRICE).GetCurSp(inclb,buom,HospID)
 s CurRp=##Class(web.DHCSTPRICE).GetCurRp(inclb,buom,HospID)
 q:(retSp=CurSp)&(retRp=CurRp) 0
 s adjSp=CurSp-retSp    ;损益价格
 s adjRp=CurRp-retRp
 s CurSpAmt=CurSp*qty
 s CurRpAmt=CurRp*qty
 s CatGrpStr=##Class(web.DHCSTCOMINC).GetIncStkCatGrp(+inclb)
 s StkTypeDesc=$P(CatGrpStr,"^",4)
 s Perv="^^^"_StkTypeDesc_"^"_CustID_"^DHC"
 s CurSpAmt=##Class(web.DHCSTCOMMPARA).GetNumbDec(CurSpAmt,Perv,"FmtSA",1)
 s CurRpAmt=##Class(web.DHCSTCOMMPARA).GetNumbDec(CurRpAmt,Perv,"FmtRA",1)
 s AdjSpAmt=CurSpAmt-retSpAmt
 s AdjRpAmt=CurRpAmt-retRpAmt
 s userdr=$p(^PHARET(retid),"^",3)
 s date=+$h               ;date is the current date
 s time=$p($h,",",2)      ;time is the current time
 s rettype="Y"
 ;
 &sql(insert into  DHC_RetAspAmount(RETA_INCI_DR,RETA_CTLOC_DR,RETA_AdjPrice,RETA_Qty,
 RETA_Amount,RETA_SSUSR_DR,RETA_Date,RETA_Time,RETA_Pointer,RETA_Type,RETA_RpDiff,RETA_RpAmt,RETA_Uom_Dr) 
  values (:inci,:locdr,:adjSp,:qty,:AdjSpAmt,:userdr,:date,:time,:rowid,:rettype,:adjRp,:AdjRpAmt,:buom))
 i SQLCODE'=0  d
 .s ret=$$SqlErrorRecord^DHCSTERROR("InsertRetA:DHC_RetAspAmount",rowid,SQLCODE_":"_$g(%msg))
 q:SQLCODE'=0 -2
 q 0
}

/// Creator:Liang Qiang
/// CreatDate:2009-05-04
/// Descrition:检查该申请是否已执行退药
/// Table:DHC_PhaRetRequest
/// Input:申请单rowid
/// Output:0 - 未执行 , -1 - 已执行
/// Return:0 - 未执行 , -1 - 已执行
/// Others:
ClassMethod AuditReqNO(retrqrowid) As %String
{
    n (retrqrowid)
    q:retrqrowid="" 1
    s h=0
    s code="Execute" 
    s states=$p(^RETRQ(retrqrowid),"^",14)
    i states=code d
    .s h=h+1
    q h
}

/// Creator:Liang Qiang
/// CreatDate:2009-08-04
/// Description:根据申请单号查找该单剩余未退数量：
/// Input:申请单Rowid
/// Return:剩余未退数量
ClassMethod GetReqSurplus(reqrowid) As %String
{
    n (reqrowid)
    s reqqty=$p(^RETRQ(reqrowid),"^",11)
    q:'$d(^PHARET(0,"REQUEST",reqrowid)) reqqty
    s phaci=$p(^RETRQ(reqrowid),"^",24)
    s sumretqty=0
    s pharrowid=""
    f  s pharrowid=$o(^PHARET(0,"REQUEST",reqrowid,pharrowid)) q:pharrowid=""  d
    .s retqty=$p(^PHARET(pharrowid),"^",12)
    .s sumretqty=sumretqty+retqty
    s surqty=reqqty-sumretqty
    q surqty
}

/// Creator:zhangdongmei
/// CreatDate:2012-03-13
/// Description:根据申请明细id查找该记录剩余未退数量：
/// Input:申请明细Rowid
/// Return:剩余未退数量
ClassMethod GetReqItmSurplus(ReqItmRowid) As %String
{
    n (ReqItmRowid)
    s ReqId=+ReqItmRowid
    s ReqChl=$p(ReqItmRowid,"||",2)
    s ReqQty=$p(^RETRQ(ReqId,"I",ReqChl),"^",3)
    q:'$d(^PHARET(0,"REQUEST",ReqItmRowid)) ReqQty
    ;
    s SumRetQty=0
    s RetId=""
    f  s RetId=$o(^PHARET(0,"REQUEST",ReqItmRowid,RetId)) q:RetId=""  d
    .s RetChl=""
    .f  s RetChl=$o(^PHARET(0,"REQUEST",ReqItmRowid,RetId,RetChl)) q:RetChl=""  d
    ..s RetQty=$p(^PHARET(RetId,"I",RetChl),"^",2)
    ..s SumRetQty=SumRetQty+RetQty
    ..
    .
    s SurQty=ReqQty-SumRetQty
    q SurQty
}

/// Creator:zhangdongmei
/// CreatDate:2012-03-13
/// Description:检测某申请单下是否所有的明细都完成了退药
/// Input:申请主表Rowid
/// Return:1：完成；0：有未完成
ClassMethod CheckReqItmStatus(ReqRowid) As %String
{
    n (ReqRowid)
    s ret=1
    s ReqChl=""
    f  s ReqChl=$o(^RETRQ(ReqRowid,"I",ReqChl)) q:(ReqChl="")!(ret=0)  d
    .s status=$p(^RETRQ(ReqRowid,"I",ReqChl),"^",10)
    .i status="Prove"  d
    ..s ret=0
    .
    q ret
}

/// Creator:Liang Qiang
/// CreatDate:2009-08-04
/// Description:根据打包表id取已退数量
/// Input:打包表Rowid
/// Return:已退数量
/// zdm,2012-03-09,通过配药表计算已退数量
ClassMethod GetReqReturnedQty(Dodis) As %String
{
    n (Dodis)
    s SumQty=0
    q:Dodis="" 0
    q:'$d(^DHCOEDISQTY(Dodis)) 0
    s OrdExeId=$p(^DHCOEDISQTY(Dodis),"^",3)
    s DspId=""
    f  s DspId=$o(^DHCOEDISQTY(0,"OEORE",OrdExeId,DspId)) q:DspId=""  d
    .s Status=$p(^DHCOEDISQTY(DspId),"^",7)
    .q:Status'="R"
    .
    .s RetQty=$p(^DHCOEDISQTY(DspId),"^",11)
    .s SumQty=SumQty+RetQty
    .
    q SumQty
}

/// Creator:Liang Qiang
/// CreatDate:2012-04-14
/// Description:根据申请单子表ID查找该单已退数量
/// Input:申请单子表Rowid
/// Return:已退数量
ClassMethod GetReqReturnedQtyByPhaRet(reqrowid) As %String
{
    n (reqrowid)
    q:'$d(^PHARET(0,"REQUEST",reqrowid)) 0
    //s phaci=$p(^RETRQ(reqrowid),"^",24) zhouyg注释 2012-06-01
    s sumretqty=0
    s pharrowid=""
    f  s pharrowid=$o(^PHARET(0,"REQUEST",reqrowid,pharrowid)) q:pharrowid=""  d
    .s RetChl=""
    .f  s RetChl=$o(^PHARET(0,"REQUEST",reqrowid,pharrowid,RetChl)) q:RetChl=""  d
    ..s retqty=$p(^PHARET(pharrowid,"I",RetChl),"^",2)
    ..s sumretqty=sumretqty+retqty
    q sumretqty
}

/// creator:yunahaibao
/// createdate:20160423
/// description:住院退药汇总查询
/// w ##class(web.DHCSTPHARETURN).jsQueryInPhaRetTotal("2016-02-01^2016-04-25^98^^")
ClassMethod jsQueryInPhaRetTotal(page, rows, params)
{
    s endpage=page*rows  //结束行
    s stpage=((page-1)*rows)+1 //开始行
    s startDate=$p(params,"^",1)
    s endDate=$p(params,"^",2)
    s phaLoc=$p(params,"^",3)
    s ward=$p(params,"^",4) //pac_wardid
    s inci=$p(params,"^",5)
    s pid=..NewPid()    
    s $zt="ErrorjsQueryInPhaRetTotal"
    s result=##class(%Library.ResultSet).%New("web.DHCSTPHARETURN:QueryPhaReturnTotal")
    s sc=result.Execute(startDate,endDate,phaLoc,ward,inci)
    i $$$ISERR(sc) q ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
    s colNum=result.GetColumnCount()
    s colNameStr=""
    f i=1:1:colNum d
    .i colNameStr="" s colNameStr=result.GetColumnName(i)
    .e  s colNameStr=colNameStr_"^"_result.GetColumnName(i)
    s countrecords=0
    While(result.Next())
    { 
        s ret=""
        f i=1:1:colNum d
        .i ret="" s ret=result.%GetData(i)
        .e   s ret=ret_"^"_result.%GetData(i)
        s countrecords=countrecords+1  //可做索引用
        s ^TMP("DHCST","DHCSTPHARETURN","jsQueryInPhaRetTotal",pid,countrecords)=ret
    }
    q:countrecords="0" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
    i endpage>countrecords s endpage=countrecords
    s count=0
    s outputi=""
    f  s outputi=$o(^TMP("DHCST","DHCSTPHARETURN","jsQueryInPhaRetTotal",pid,outputi)) q:outputi=""  d
    .s outputdata=^TMP("DHCST","DHCSTPHARETURN","jsQueryInPhaRetTotal",pid,outputi)
    .s count=count+1
    .q:count<stpage
    .q:count>endpage
    .I count=stpage d
    ..w ##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(countrecords)
    ..W ##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,outputdata)
    .e  d
    ..W ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,outputdata)
    .i count=endpage w ##class(web.DHCSTJQUERYCOMMON).getJsonEndSign()
    k ^TMP("DHCST","DHCSTPHARETURN","jsQueryInPhaRetTotal",pid)
    q ""
ErrorjsQueryInPhaRetTotal
    k ^TMP("DHCST","DHCSTPHARETURN","jsQueryInPhaRetTotal",pid)
    s Error=$$Error^DHCSTERROR()
    q Error
}

/// creator:yunahaibao
/// createdate:20160423
/// description:住院退药汇总查询Query
Query QueryPhaReturnTotal(startDate As %String, endDate As %String, phaLoc As %String, ward As %String, inci As %String) As websys.Query(ROWSPEC = "Inci:%String,inciCode:%String,inciDesc:%String,retQty:%Double,retUomDesc:%String,sp:%Double,spAmt:%Double,rp:%Double,rpAmt:%Double") [ SqlProc ]
{
}

ClassMethod QueryPhaReturnTotalExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, phaLoc As %String, ward As %String, inci As %String) As %Status
{
    n (qHandle, startDate, endDate, phaLoc, ward, inci)
    s repid=$I(^CacheTemp)
    s ind=1
    s qHandle=$lb(0,repid,0)
    q:startDate="" $$$OK
    q:endDate="" $$$OK
    s startDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(startDate)
    s endDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(endDate)
    q:phaLoc="" $$$OK
    s hospId=$p(^CTLOC(phaLoc),"^",22)
    s wardloc=""
    i ward'="" s wardloc=$p(^PAWARD(ward),"^",5)
    s newpid=..NewPid()
    s pharetdate=""
    f pharetdate=startDate:1:endDate d
    .s pharet=""
    .f  s pharet=$o(^PHARET(0,"RECLOC",phaLoc,pharetdate,pharet)) q:pharet=""  d
    ..q:+pharet=0
    ..s deptloc=$p(^PHARET(pharet),"^",6)
    ..q:(wardloc'="")&&(wardloc'=deptloc)
    ..s pharetitm=""
    ..f  s pharetitm=$o(^PHARET(pharet,"I",pharetitm)) q:pharetitm=""  d
    ...q:+pharetitm=0
    ...s pharetlb="0"
    ...f  s pharetlb=$o(^PHARET(pharet,"I",pharetitm,"B",pharetlb)) q:pharetlb=""  d
    ....q:+pharetlb=0
    ....s pharetlbdata=^PHARET(pharet,"I",pharetitm,"B",pharetlb)
    ....s inclb=$p(pharetlbdata,"^",1)
    ....s tmpinci=+inclb
    ....q:(inci'="")&&(inci'=+tmpinci)
    ....s qty=$p(pharetlbdata,"^",2)
    ....s rp=+$p(pharetlbdata,"^",5)
    ....s sp=+$p(pharetlbdata,"^",3)
    ....s spamt=+$p(pharetlbdata,"^",6)
    ....s rpamt=+$p(pharetlbdata,"^",4)
    ....i (spamt<1)&&($p(spamt,".",1)="")  s spamt=0_spamt
    ....i (rpamt<1)&&($p(rpamt,".",1)="")  s rpamt=0_rpamt
    ....//统一基本单位累加
    ....i '$d(^TMP("DHCST","DHCSTPHARETURN","QueryPhaReturnTotal",newpid,tmpinci)) d
    .....s ^TMP("DHCST","DHCSTPHARETURN","QueryPhaReturnTotal",newpid,tmpinci)=qty_"^"_spamt_"^"_rpamt_"^"_sp_"^"_rp
    ....e  d
    .....s $p(^TMP("DHCST","DHCSTPHARETURN","QueryPhaReturnTotal",newpid,tmpinci),"^",1)=$p(^TMP("DHCST","DHCSTPHARETURN","QueryPhaReturnTotal",newpid,tmpinci),"^",1)+qty
    .....s $p(^TMP("DHCST","DHCSTPHARETURN","QueryPhaReturnTotal",newpid,tmpinci),"^",2)=$p(^TMP("DHCST","DHCSTPHARETURN","QueryPhaReturnTotal",newpid,tmpinci),"^",2)+spamt
    .....s $p(^TMP("DHCST","DHCSTPHARETURN","QueryPhaReturnTotal",newpid,tmpinci),"^",3)=$p(^TMP("DHCST","DHCSTPHARETURN","QueryPhaReturnTotal",newpid,tmpinci),"^",3)+rpamt
    .....s $p(^TMP("DHCST","DHCSTPHARETURN","QueryPhaReturnTotal",newpid,tmpinci),"^",4)=sp
    .....s $p(^TMP("DHCST","DHCSTPHARETURN","QueryPhaReturnTotal",newpid,tmpinci),"^",5)=rp
    s inci=""
    f  s inci=$o(^TMP("DHCST","DHCSTPHARETURN","QueryPhaReturnTotal",newpid,inci)) q:inci=""  d
    .s outputdata=^TMP("DHCST","DHCSTPHARETURN","QueryPhaReturnTotal",newpid,inci)
    .s incidesc=$p(^INCI(inci,1),"^",2)
    .s incicode=$p(^INCI(inci,1),"^",1)
    .s retqty=$p(outputdata,"^",1)
    .s buom=$p(^INCI(inci,1),"^",10)
    .s puom=$p(^INCI(inci,3),"^",6)
    .s fac=##class(web.DHCSTCOMMONSRV).UOMFac(puom,buom)
    .s retqty=retqty/fac
    .s retqty=##class(web.DHCST.Common.AppCommon).FormatSq(retqty,hospId,1,"G")
    .i (retqty<1)&&($p(retqty,".",1)="")  s retqty=0_retqty
    .s puomdesc=$p(^CT("UOM",puom),"^",2)
    .s sp=$p(outputdata,"^",4)
    .s spamt=$p(outputdata,"^",2)
    .s rp=$p(outputdata,"^",5)
    .s rpamt=$p(outputdata,"^",3)
    .d OutPutRow
    k ^TMP("DHCST","DHCSTPHARETURN","QueryPhaReturnTotal",newpid)
    q $$$OK
OutPutRow
    s Data=$lb(inci,incicode,incidesc,retqty,puomdesc,sp,spamt,rp,rpamt)   
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
    q
}

/// creator:    yunhaibao
/// createdate: 2017-01-10
/// description:获取发药子表记录的dodis串的已发药数量,用于计算退药退哪些批次
/// others:     w ##class(web.DHCSTPHARETURN).GetReturnedQtyByPhaci("100000099||1")
ClassMethod GetReturnedQtyByPhaci(phacirowid As %String)
{
    n (phacirowid)
    s phacrowid=+phacirowid
    s phacitm=+$p(phacirowid,"||",2)
    q:(phacrowid=0)||(phacitm=0) 0
    s phaciretqty=0
    s dodisstr=$p(^DHCPHAC(phacrowid,"I",phacitm),"^",13)
    s dodisi=0
    s dodisl=$l(dodisstr,",")
    f dodisi=1:1:dodisl d
    .s dodis=$p(dodisstr,",",dodisi)
    .s dodisretqty=..GetReqReturnedQty(dodis)
    .s phaciretqty=phaciretqty+dodisretqty
    q phaciretqty
}

/// description: 提前退费退药后更新打包指针
/// return:      0:成功
/// w ##class(web.DHCSTPHARETURN).UpdDspPointer("39||1")
ClassMethod UpdDspPointer(retitm)
{
    n (retitm)
    s retid=+retitm,retchl=$P(retitm,"||",2)
    q:'$d(^PHARET(retid,"I",retchl)) -1
    s retlb=$o(^PHARET(retid,"I",retchl,"B",""))
    s pharil = retitm_ "||"_retlb
    s dodis=$p(^PHARET(retid,"I",retchl),"^",13)  //发药的dodis
    s oeore=$P(^DHCOEDISQTY(dodis),"^",3) //执行记录
    s dspId=""
    f  s dspId=$O(^DHCOEDISQTY(0,"OEORE",oeore,dspId)) q:dspId=""  d
    .s type=$P(^DHCOEDISQTY(dspId),"^",13) //类型
    .q:type'="Y" //退药记录
    .s pointer=$P(^DHCOEDISQTY(dspId),"^",14)
    .s $P(^DHCOEDISQTY(dspId),"^",14)=retitm
    q 0
}

/// Description: 提前退费的退药, 更新退药孙表的打包子表指向, 一定在UpdDspPointer前调用
ClassMethod UpdatePharDspb(reqi, reti)
{
    q:(reti = "") $$$OK
    s ret = $p(reti, "||", 1), retItm = $p(reti, "||", 2)
    s req = $p(reqi, "||", 1), reqItm = $p(reqi, "||", 2)
    s rPointer = "R" _ reqi
    s retLb=$o(^PHARET(ret, "I", retItm, "B", 0))
    q:(retLb = "") $$$OK
    s retib = reti _ "||" _ retLb
    s pharDsp = $p(^PHARET(ret, "I", retItm), "^", 13) 
    s oeore = $p(^DHCOEDISQTY(pharDsp), "^", 3)
    s dsp = 0
    for {
        s dsp = $o(^DHCOEDISQTY(0, "OEORE", oeore, dsp)) q:(dsp = "")
        s dspData = $g(^DHCOEDISQTY(dsp))
        continue:($p(dspData, "^", 13) '= "Y")
        s pointer = $p(dspData, "^", 14)
        if (pointer = rPointer){
            // 此时打包子表必定是一条记录, 因为退药申请依据发药孙表而产生
            s dspSub = $o(^DHCOEDISQTY(dsp, "I", 0))
            continue:(dspSub = "")
            s dspb = dsp _ "||" _ dspSub
            d UpdatePharDspbSQL
        }
    }
    q $$$OK
UpdatePharDspbSQL
    &SQL(
        UPDATE SQLUser.DHC_PhaReturnItmLB
           SET PHARIL_DSPB_DR = :dspb
         WHERE PHARIL_Rowid = :retib        
    )   
    q $$$OK
}

/// creator:    yunhaibao
/// createdate: 2017-09-07
/// description:根据发药孙表ID获取对应记录已退数量 
/// others: 
/// Debug:      w ##class(web.DHCSTPHARETURN).ReturnedQtyByPhacLb("271||1||1")  
ClassMethod ReturnedQtyByPhacLb(phacLbRowId As %String) As %String
{
    n (phacLbRowId)
    q:+phacLbRowId=0 0
    s retQty=0
    s pharId=""
    f  s pharId=$o(^PHARETi("PHDICDR",phacLbRowId,pharId))  q:pharId=""  d
    .s pharSubId=""
    .f  s pharSubId=$o(^PHARETi("PHDICDR",phacLbRowId,pharId,pharSubId))  q:pharSubId=""  d
    ..s pharLbId=""
    ..f  s pharLbId=$o(^PHARETi("PHDICDR",phacLbRowId,pharId,pharSubId,pharLbId))  q:pharLbId=""  d
    ...q:+pharLbId=0
    ...s pharLbData=^PHARET(pharId,"I",pharSubId,"B",pharLbId)
    ...s retQty=retQty+$p(pharLbData,"^",2)
    ..
    .
    q retQty
}

/// description: 判断录入retReqQty数量是否小于等于欲退
/// return:      1(小于,可退)
ClassMethod AllowReturnByPhacLb(phacLbRowId As %String, retReqQty As %String) As %String
{
     n (phacLbRowId,retReqQty)
     //s ^TMPDHCSTPARAMS("web.DHCSTPHARETURN","AllowReturnByPhacLb")=$lb(phacLbRowId,retReqQty)
     q:phacLbRowId="" 0
     s phacId=+phacLbRowId
     s phacSubId=+$p(phacLbRowId,"||",2)
     s phacLbId=+$p(phacLbRowId,"||",3)
     q:(phacId=0)||(phacSubId=0)||(phacLbId=0) 0
     s dodisBatch=$p(^DHCPHAC(phacId,"I",phacSubId,"B",phacLbId),"^",7)
     s dispQty=$p(^DHCPHAC(phacId,"I",phacSubId,"B",phacLbId),"^",2) ;发药数量
     s status=$p(^DHCOEDISQTY(+dodisBatch),"^",7)                   ;配药记录状态
     q:status'="C" 0                                                ;未发药不需要退药
     s retedQty=..ReturnedQtyByPhacLb(phacLbRowId)              ;计算该配药记录的已退数量
     s avaQty=dispQty-retedQty          ;可退数量
     q:(avaQty-retReqQty)<0 0           ;欲退数量大于可退数量，
     q 1
}

/// Creator: Huxt 2019-12-25
/// Desc: 获取退药单打印数据
/// Input: RetNo-退药单号
/// Output: json
/// w ##class(web.DHCSTPHARETURN).GetRetPrintDataByNo("RTZMDSZXYY20200225001")
ClassMethod GetRetPrintDataByNo(RetNo As %String, PhaRet As %String) As %Integer
{
    n (RetNo, PhaRet, %session)
    //q:RetNo="" "-1^入参RetNo不能为空"
    q:PhaRet="" "-1^入参RetID不能为空"
    i PhaRet'="" s retId=PhaRet
    q:'$d(^PHARET(retId)) "-1^不存在ID数据"
    //s retId = $o(^PHARET(0,"NO",RetNo,""))
    //q:retId="" ""
    s retDate = $p(^PHARET(retId),"^",1)
    s retTime = $p(^PHARET(retId),"^",2)
    s:retDate'="" retDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(retDate,"IP")
    s:retTime'="" retTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(retTime,"IP")
    s userID = $p(^PHARET(retId),"^",3)
    s userCode = $p(^SSU("SSUSR",userID),"^",1)
    s userName = $p(^SSU("SSUSR",userID),"^",2)
    s recLocID = $p(^PHARET(retId),"^",5)
    s recLocDesc = $s(recLocID'="":$p(^CTLOC(recLocID),"^",2), 1:"")
    s hospID=$p($g(^CTLOC(+recLocID)),"^",22)
    s hospDesc=$p($g(^CT("HOSP",+hospID)),"^",2)
    s deptID = $p(^PHARET(retId),"^",6)
    s deptDesc = $s(deptID'="":$p(^CTLOC(deptID),"^",2), 1:"")
    s:deptDesc["-" deptDesc=$p(deptDesc,"-",2)
    s ackStatus = $p(^PHARET(retId),"^",8)
    s ackDate = $p(^PHARET(retId),"^",9)
    s ackTime = $p(^PHARET(retId),"^",10)
    s ackUser = $p(^PHARET(retId),"^",11)
    s:ackDate'="" ackDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(ackDate,"IP")
    s:ackTime'="" ackTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(ackTime,"IP")
    s sysDate = ##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(+$h)
    s sysTime = ##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml($p($h,",",2))
    s sysDT = sysDate_" "_sysTime
    s ordLocDesc = ""
    //List
    s List = []
    s spAmtSum = 0
    s retChl = ""
    f  s retChl = $o(^PHARET(retId,"I",retChl)) q:retChl=""  d
    .s tempChl = ^PHARET(retId,"I",retChl)
    .s retQty = $p(tempChl,"^",2)
    .//价格&金额
    .s sp="", spAmt=0
    .s retLb = ""
    .f  s retLb = $o(^PHARET(retId,"I",retChl,"B",retLb)) q:retLb=""  d
    ..s:sp="" sp = $p(^PHARET(retId,"I",retChl,"B",retLb),"^",5)
    ..s spAmt = spAmt + $p(^PHARET(retId,"I",retChl,"B",retLb),"^",6)
    .s sp = ##class(PHA.COM.Print).MathDecimal(sp,4)
    .s spAmt = ##class(PHA.COM.Print).MathDecimal(spAmt,4)
    .s spAmtSum = spAmtSum + spAmt
    .//退药原因
    .s reasonID = $p(tempChl,"^",6)
    .s reasonDesc = $s(reasonID'="":$p(^BLC("RFR",reasonID),"^",2), 1:"")
    .s retReqID = $p(tempChl,"^",7)
    .s inci = $p(tempChl,"^",11)
    .s inciCode = $p(^INCI(inci,1),"^",1)
    .s inciDesc = $p(^INCI(inci,1),"^",2)
    .s manfStr = ##class(web.DHCST.Common.DrugStkCommon).GetLastManf(inci)
    .s manfDesc = $p(manfStr,"^",2)
    .s dspID = $p(tempChl,"^",13)
    .s uomID = $p(^INCI(inci,1),"^",10)     //$p(^DHCOEDISQTY(dspID),"^",6)
    .s uomDesc = $p($g(^CT("UOM",+uomID)),"^",2)        //$p(^CT("UOM",uomID),"^",2)
    .//患者信息
    .s adm = $p(tempChl,"^",8)
    .s papmi = $p(^PAADM(adm),"^",1)
    .s patName = $p(^PAPER(papmi,"ALL"),"^",1)                      //患者姓名
    .s patNo = $p(^PAPER(papmi,"PAT",1),"^",1)                      //登记号
    .s sex = $p(^PAPER(papmi,"ALL"),"^",7 )         
    .s patSex = $p(^CT("SEX",sex),"^",2)                            //性别
    .s patAge = ##class(PHA.FACE.IN.Com).GetAge(papmi,adm)               //年龄
    .s patWeight = ##class(web.DHCOutPhCommon).GetPatWeight(adm)    //患者体重
    .s patHeight = ##class(web.DHCOutPhCommon).GetPatHeight(adm)    //患者身高
    .s homeTel = $p($g(^PAPER(papmi,"PER",1)),"^",11)               //家庭电话(常用)
    .s workTel = $p($g(^PAPER(papmi,"PER",1)),"^",9)                //工作电话
    .s handtel = $p($g(^PAPER(papmi,"PER",4)),"^",21)               //手机
    .s bedID = $p(tempChl,"^",10)
    .s bedCode = $p($g(^PAWARD(+bedID,"BED",+$p(bedID,"||",2))),"^",1)  //床位
    .s admLocID = $p(tempChl,"^",9)
    .s admLocDesc = $s(admLocID'="":$p(^CTLOC(admLocID),"^",2), 1:"")
    .//医嘱信息
    .s oeori = $p(tempChl,"^",1)
    .s prescNo = $p(^OEORD(+oeori,"I",$p(oeori,"||",2),1),"^",14)   //处方号
    .i ordLocDesc="" d
    ..s ordLocID = ##Class(web.DHCSTKUTIL).UserDept(oeori)
    ..s ordLocDesc = $p(^CTLOC(ordLocID),"^",2)
    .s oneRow = {}
    .s oneRow.patName = patName
    .s oneRow.patNo = patNo
    .s oneRow.patSex = patSex
    .s oneRow.bedCode = bedCode
    .s oneRow.admLocDesc = admLocDesc
    .s oneRow.inciCode = inciCode
    .s oneRow.inciDesc =##class(PHA.COM.Print).Cut(inciDesc,40)
    .s oneRow.manfDesc = ##class(PHA.COM.Print).Cut(manfDesc,26)
    .s oneRow.retQty = $fn(retQty, "N")
    .s oneRow.uomDesc = uomDesc
    .s oneRow.sp = $fn(sp, "N")
    .s oneRow.spAmt = $fn(spAmt, "N")
    .d List.%Push(oneRow)
    //合计行
    s oneRow = {}
    s oneRow.patName = "合计"
    s oneRow.spAmt = spAmtSum
    d List.%Push(oneRow)
    //Para
    s Para = {}
    s Para.title = hospDesc_recLocDesc_"退药单"
    s Para.recLocDesc = recLocDesc
    s Para.deptDesc = deptDesc
    s Para.wardDesc = deptDesc
    s Para.ordLocDesc = ordLocDesc
    s Para.retNo = $p(^PHARET(retId),"^",7)
    s Para.sysDT = sysDT
    s Para.userName = userName
    s Para.spAmtSum = $fn(spAmtSum, "N")
    //json
    s retJosn = {}
    s retJosn.Para = Para
    s retJosn.List = List
    q retJosn.%ToJSON()
}

ClassMethod killRetTmpAfterPrint(pid)
{
    k ^TMP("DHCST","web.DHCSTPHARETURN","GetRetByNo",pid)
    k ^TMP("DHCST","web.DHCSTPHARETURN","GetRetByNo","RetTotalItm",pid)
    q 0
}

ClassMethod NewPid() As %String
{
    q ##class(web.DHCSTKUTIL).NewPid($ClassName(),"IP")
}

ClassMethod RefuseRequest(dataStr)
{
    s $zt = "ErrorRefuseRequest"
    ts
    s len = $l(dataStr, ",")
    for i = 1 : 1 : len {
        s rowData = $p(dataStr, ",", i)
        s refRet = ..Refuse(rowData)
        if (+refRet < 0){
            tro
            return refRet
        }
    }
    tc
    q 0
ErrorRefuseRequest
    tro
    l
    q "-1^"_$tr($ze,"^","~")
}

ClassMethod Refuse(rowData)
{
    s reqi = $p(rowData, "^", 1)
    s reason = $p(rowData, "^", 2)
    s user = $p(rowData, "^", 3)
    s reqiData = $g(^RETRQ(+reqi, "I", +$p(reqi, "||", 2)))
    q:($p(reqiData, "^", 10) = "Execute") "-1^已退药"
    q:($p(reqiData, "^", 10) = "Refuse") "-1^已拒绝退药"
    s retedQty = +##class(web.DHCSTPHARETURN).GetReqReturnedQtyByPhaRet(reqi)
    q:(retedQty > 0) "-1^已退过药，无法拒绝"
    &SQL(
        UPDATE SQLUSER.DHC_PhaRetRequestItm
        SET RETRQI_Status = 'Refuse', RETRQI_RefuseRetReason_DR = :reason
        WHERE RETRQI_Rowid = :reqi
    )
    if (SQLCODE '= 0){
        return "-1^更新退药申请明细拒绝状态失败," _ $g(%msg)
    }
    s pInputData("Type") = "User.DHCPhaRetRequestItm"
    s pInputData("Pointer") = reqi
    s pInputData("OperateUserDR") = user
    s pInputData("Status") = "Refuse"   
    s pInputData("Remark") = "拒绝退药申请"   
    s statusRet = ##class(BS.PHA.IN.Status).Insert(.pInputData)
    d ##class(web.DHCINPHA.Request).UpdatePhaReqForItm(+reqi) // todo 
    q statusRet
}

ClassMethod CancelRefuseRequest(dataStr)
{
    s $zt = "ErrorCancelRefuseRequest"
    ts
    s len = $l(dataStr, ",")
    for i = 1 : 1 : len {
        s rowData = $p(dataStr, ",", i)
        s refRet = ..CancelRefuse(rowData)
        if (+refRet < 0){
            tro
            return refRet
        }
    }
    tc
    q 0
ErrorCancelRefuseRequest
    tro
    l
    q "-1^"_$tr($ze,"^","~")
}

ClassMethod CancelRefuse(rowData)
{
    s reqi = $p(rowData, "^", 1)
    s reason = $p(rowData, "^", 2)
    s user = $p(rowData, "^", 3)
    s reqiData = $g(^RETRQ(+reqi, "I", +$p(reqi, "||", 2)))
    q:($p(reqiData, "^", 10) '= "Refuse") "-1^不为拒绝退药状态，无法取消拒绝"
    &SQL(
        UPDATE SQLUSER.DHC_PhaRetRequestItm
        SET RETRQI_Status = 'Prove', RETRQI_RefuseRetReason_DR = NULL
        WHERE RETRQI_Rowid = :reqi
    )
    if (SQLCODE '= 0){
        return "-1^更新退药申请明细拒绝状态失败," _ $g(%msg)
    }
    s pInputData("Type") = "User.DHCPhaRetRequestItm"
    s pInputData("Pointer") = reqi
    s pInputData("OperateUserDR") = user
    s pInputData("Status") = "CancelRefuse" 
    s pInputData("Remark") = "取消拒绝退药申请" 
    s statusRet = ##class(BS.PHA.IN.Status).Insert(.pInputData)
    d ##class(web.DHCINPHA.Request).UpdatePhaReqForItm(+reqi) // todo 
    q statusRet
}

}
