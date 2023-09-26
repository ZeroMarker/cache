Import Sqluser

Class web.DHCSTPCHCOLLS2 Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 6;

ClassMethod DhcStkTab(phacil As %String) As %String
{
    ;Insert into DHC_Intrans accroding to rowid of Dhc_Phacollectitm
    n (phacil)
    s pha=$p(phacil,"||",1)
    s ch=$p(phacil,"||",2) 
    s il=$p(phacil,"||",3)   
    q:pha="" -20
    q:ch="" -21
    q:il="" -24
    q:'$d(^DHCPHAC(pha),phacData) -22
    q:'$d(^DHCPHAC(pha,"I",ch),phaciData) -23
    q:'$d(^DHCPHAC(pha,"I",ch,"B",il),phacilData) -25
    s phaci=pha_"||"_ch
    s user=+$p(phacData,"^",5)
    s locdr=+$p(phacData,"^",1)
    s LocDesc=$p(^CTLOC(locdr),"^",2)
    s inclb=$p(phacilData,"^",1)  ; 
    s inci=+inclb
    s ItmCode=$p(^INCI(inci,1),"^",1)
    s baseuomdr=$p(^INCI(inci,1),"^",10)
    s UomDesc=$p(^CT("UOM",baseuomdr),"^",2)
    s qty=+$p(phacilData,"^",2)  ;
    s qty=-qty           ;the qty must be negative
    s pointer=phacil
    s dispno=$p(phacData,"^",14)
    s intrtype="P"
    s rp=$p(phacilData,"^",3)
    s RpAmt=$p(phacilData,"^",4)
    s sp=$p(phacilData,"^",5)
    s SpAmt=$p(phacilData,"^",6)
    i sp="" d
    .s sp=+$p(phaciData,"^",9)
    .s SpAmt=+$p(phaciData,"^",15)
    s Data=intrtype_"^"_dispno_"^"_inclb_"^"_qty_"^"_UomDesc_"^"_ItmCode_"^"_sp_"^"_user_"^"_pointer_"^"_LocDesc_"^"_rp //_"^"_RpAmt_"^"_SpAmt
    s Err=##class(web.DHCST01).UPDINCI(Data)
    q:Err=0 -23
    q 1
}

ClassMethod InsTrans(inclb As %String, qty As %String, locdr As %String, sprice As %String, pointer As %String, user As %String, intrno As %String, intrtype = "") As %String
{
    ; This routine is used to handle the stock qty of Table Dhc_LocDailytotal and Dhc_LocBtDailytotal when dispensing .
    ;
    n (inclb,qty,locdr,sprice,pointer,user,intrno,intrtype)
    q:inclb="" -1
    q:locdr="" -2
    s inci=+inclb,locdr=+locdr
    q:inci<0 -11
    s qty=+qty
    s buom=$p(^INCI(inci,1),"^",10)  q:buom="" -3
    s mrowid=##class(web.DHCSTLOCDTOTAL).UpdateMainByID(inci,qty,locdr)
    q:mrowid="" -4
    s detrowid=##class(web.DHCSTLOCBTDTOTAL).UpdateDayBT(inclb,qty,mrowid)
    q:detrowid="" -5
    ; Insert transaction data 
    k PLIST
    f i=1:1:16 s PLIST(i)=""
    s PLIST(2)=+qty*sprice                                                   ;INTR_Amount
    s PLIST(3)=+sprice                                                       ;INTR_AveragePrice
    s PLIST(4)=buom ;                                                        ;INTR_CTUOM_DR
    s PLIST(5)=+$h                                                           ;INTR_Date
    s PLIST(6)=""                                                            ;INTR_GLBatch_DR
    s PLIST(7)=inci ;                                                        ;INTR_INCI_DR
    s PLIST(8)=inclb                                                                                                              ;INTR_INCLB_DR
    s PLIST(9)=intrno                                                        ;INTR_No
    s PLIST(10)=pointer                                                      ;INTR_Pointer
    s PLIST(11)=+qty                                                         ;INTR_Qty
    s PLIST(12)=+user                                                        ;INTR_SSUSR_DR
    s PLIST(13)=$p($h,",",2)                                                 ;INTR_Time
    s PLIST(14)=intrtype                                                     ;INTR_Type
    s PLIST(15)="N"                                                          ;INTR_UpdBalFlag       
    s PLIST(16)="N"                                                          ;INTR_UpdFlag
    &sql(insert into DHC_Intrans values :PLIST() )
    q:SQLCODE'=0 -6
    q +%ROWID
}

ClassMethod GetOrdItmRemark(ordi As %String) As %String
{
    n (ordi)
    s ord=$p(ordi,"||",1)
    s item=$p(ordi,"||",2)
    q:ord="" ""
    q:item="" ""
    q:'$d(^OEORD(ord,"I",item)) ""
    s (num,memo)=""
    s num="0" f  s num=$o(^OEORD(ord,"I",item,"DEP",num)) q:num=""  d
    .s memo=memo_$g(^OEORD(ord,"I",item,"DEP",num))
    q memo
}

ClassMethod GetOrdItmRemark2(itmjs As %Library.String = "", itmjsex As %Library.String = "", ordi As %String) As %String
{
    n (ordi)
    s ord=$p(ordi,"||",1)
    s item=$p(ordi,"||",2)
    q:ord="" ""
    q:item="" ""
    q:'$d(^OEORD(ord,"I",item)) ""
    s (num,memo)=""
    s num="0" f  s num=$o(^OEORD(ord,"I",item,"DEP",num)) q:num=""  d
    .s memo=memo_$g(^OEORD(ord,"I",item,"DEP",num))
    q memo
}

ClassMethod GetPhac(phac As %String) As %String
{
    s result=##class(%ResultSet).%New("DHCPHACollected:Phac")
    Do result.Execute(phac)
    s d1=result.Data("DD")
    s d2=result.Data("TT")
    s d3=result.Data("DF")
    s d4=result.Data("DT")
    s d5=result.Data("phaloc")
    s d6=result.Data("User")
    s d7=result.Data("ordtype")
    s d8=result.Data("Ward")
    q d1_"^"_d2_"^"_d3_"^"_d4_"^"_d5_"^"_d6_"^"_d7_"^"_d8
}

ClassMethod ReUpdateOedis(Phac As %String) As %String
{
   // when setting-flag fails this rountine will execute 
    n (Phac)
    s child=""
    s code="C"
    f  s child=$o(^DHCPHAC(Phac,"I",child)) q:child=""  d
    .s oedisdr=$p(^DHCPHAC(Phac,"I",child),"^",7)        
    .s a1=$p(oedisdr,"||",1)
    .s a2=$p(oedisdr,"||",2)
    .s a3=$p(oedisdr,"||",3)
    .s a4=$p(oedisdr,"||",4)
    .q:a1=""
    .q:a2=""
    .q:a3=""
    .q:a4=""
    .q:'$d(^OEORD(a1,"I",a2,"X",a3,"D",a4))
    .s flag=$p(^OEORD(a1,"I",a2,"X",a3,"D",a4),"^",6)
    .;w flag
    .i flag="P" d
    ..s dd=+$h
    ..s tt=$p($h,",",2)
    ..&sql(update oe_dispensing set dsp_status=:code,dsp_collecteddate=:dd,dsp_collectedtime=:tt where dsp_rowid=:oedisdr)
    ..
    ..
    q 0
}

// The following is for the control of payment.

ClassMethod IFGivePHC(adm As %String, ward As %String, SpecialPha As %String) As %String
{
    ;返回1，可以发药，返回-1，不可以发药
    ;admstat="D"   ---已经出院了，见怕PA_ADM表的 paadm_visitstatus字段
    ; adm ---adm号
    ; admward---当前患者所在病区
    ; ward------所查询的病区rowid
    ; admloc----当前患者科室rowid
    ; loc-------所查的病区对应的科室 rowid
    ; billedflag="Paid"  已经结帐否则，没有结帐 
    ; SpecialPha'=0  特殊药房，否则，普通药房  
    ; s admstat="D",admward=,ward,admloc,loc,billedflag,SpecialPha=
    q 1
    n (adm,ward,SpecialPha)
    ;
    q:SpecialPha'=0 1         ;特殊药方发药不控制费用和科室。                              
    s admstat=$p(^PAADM(adm),"^",20) 
    s admward=$p(^PAADM(adm),"^",70)  ;病人所在病房   
    s admloc=$p(^CTLOC($p(^PAADM(adm),"^",4)),"^",2)
    s wardlocdesc=..GetLocFromWard(ward) 
    ;
    s payedflag=""
    s amt=..GetAmt(adm)
    ;
    i $g(admstat)="D" d 
    .s billdr=$o(^DHCPB(0,"ADM",adm,""),-1)   ;ar_patientbill
    .i $g(billdr)'="" s payedflag=$p(^DHCPB(billdr),"^",16)  
    .e  s payedflag=""
    i $g(admstat)'="D" d
    . i ..SelfPayFac(adm)=0 s res=1 q    ;自付比率为0者不控制费用
    . i (admward=ward)&(amt'<0) s res=1   ;
    . e  s res=-1
    i $g(admstat)="D" d
    .i ..SelfPayFac(adm)=0 s res=1 q   ;自付比率为0者不控制费用
    .i $g(payedflag)="P" s res=1 q
    .i amt'<0 s res=1 q
    .i amt<0 s res=-1 q
    .s res=-1 
    q res
}

ClassMethod GetAmt(adm) As %String
{
    ; q 1
    n (adm)
    q:$g(adm)="" 0
    s fac=1.0
    k ybid,ybdesc
    s motheradm=$p(^PAADM(adm),"^",75)
    s motheradm=$g(motheradm)
    i motheradm'="" s adm=motheradm          ;如果是孩子，求妈妈的总费用（包括孩子的在内）
    s fac=..SelfPayFac(adm)                  ;自付比例
    s DepositAmt=0,TotalPatient=0
    s DepositAmt=..deposit(adm)  
    s WarrAmt=..GetWarrAmt(adm)  
    s atadr=""
    s atadr=$o(^DHCATA(0,"ADM",adm,""))                                 
    i atadr'="" s TotalPatient=$p(^DHCATA(atadr),"^",5)            ;本人的费用      
    q DepositAmt+WarrAmt-TotalPatient*fac-(..GetMinReceipt(adm,0))
}

ClassMethod GetLocFromWard(wardid As %String) As %String
{
      
    ;有病区rowid 得到对应的科室ROWID
    ;n subdr,locdesc
    s locdesc=""
    q:$g(wardid)="" ""
    q:'$d(^PAWARD(wardid,"WBALL")) ""
    s subdr=0  f  s subdr=$o(^PAWARD(wardid,"WBALL",subdr)) q:subdr=""  d
    .s locdr=$p(^PAWARD(wardid,"WBALL",subdr),"^",2)
    .q:'$d(^CTLOC(locdr))
    .s locdesc1=$p(^CTLOC(locdr),"^",2)
    .s locdesc=locdesc_" "_locdesc1
    q $g(locdesc)
}

ClassMethod GetMinReceipt(adm, default) As %String
{
    n amt,ctloc
    s ctloc=$p(^PAADM(adm),"^",70)
    q:$g(ctloc)="" +default
    s amt=+default 
    i '$d(^DHCMINRECEIPT(ctloc)) d
    .s amt=default 
    e  d
    .s amt=+^DHCMINRECEIPT(ctloc)
    q amt
}

ClassMethod SelfPayFac(PatID) As %String
{
    n (PatID)
    s fac=1
    ;s Papmi=$p(^PAADM(PatID),"^")
    ;s pattype=$p(^PAPER(Papmi,"PER",1),"^",10)
    ;i pattype'="" s typedesc=$p(^CT("SS",pattype),"^",2)
    ;i $g(typedesc)["医保"  s fac=0 
    s admReason=$p(^PAADM(PatID,1),"^",7)
    i admReason'="" s admReasonCode=$p(^PAC("ADMREA",+admReason),"^",1)
    i $g(admReasonCode)["市领导" s fac=0
    i $g(admReasonCode)["公费" s fac=0
    q fac
}

ClassMethod GetWarrAmt(adm As %String) As %String
{
    
    n (adm,user)
    s adm=$g(adm)
    q:adm="" 0
    s wdr=""
    s totamt=0
    f  s wdr=$o(^DHCWARRANT(0,"ADM",adm,wdr)) q:wdr=""  d
    . s ss=^DHCWARRANT(wdr)
    . s status=$p(ss,"^",8)
    . q:(status'="Y")
    . s ltd=$p(ss,"^",4)
    . q:(ltd<+$h)
    . s totamt=totamt+$p(ss,"^",2)
    q totamt
}

ClassMethod deposit(adm) As %String
{
    
    n (adm) 
    s x1="",depAmt=0                        ;table - AR_RcptAlloc
    f  s x1=$o(^ARRCP("Adm_DR",adm,x1)) q:x1=""  d
    . s x2="" 
    . f  s x2=$o(^ARRCP("Adm_DR",adm,x1,x2)) q:x2=""  d
    . . q:+$p(^ARRCP(x1,"RAL",x2),"^",18)'=0
    . . s deposit=$p(^ARRCP(x1,"RAL",x2),"^",2)
    . . s depAmt=depAmt+deposit
    q +$g(depAmt)
}

ClassMethod GetDispGroupPar(itmjs As %Library.String = "", itmjsex As %Library.String = "", group As %String) As %String
{
  
    q:group="" ""
    q:'$d(^DHCDISPPAR(group)) ""
    q ^DHCDISPPAR(group)
}

ClassMethod SetDispGroupPar(itmjs As %Library.String = "", itmjsex As %Library.String = "", group, sdata) As %String
{
    q:group="" ""
    s ^DHCDISPPAR(group)=sdata
    q 0
}

ClassMethod SetPrintFmt(itmjs As %Library.String = "", itmjsex As %Library.String = "", locdr As %String, flag As %String) As %String
{
    q:locdr="" ""
    s ^DHCDISPPRN(locdr)=flag
}

ClassMethod ClearPrintFmt(itmjs As %Library.String = "", itmjsex As %Library.String = "")
{
    k ^DHCDISPPRN
    q 0
}

ClassMethod GetPrintFmt(itmjs As %Library.String = "", itmjsex As %Library.String = "", locdr) As %String
{
    ;quit : "O" or "I"
    q:locdr="" ""
    q:'$d(^DHCDISPPRN(locdr)) ""
    q ^DHCDISPPRN(locdr)
}

ClassMethod GetPrtHz(itmjs As %Library.String = "", itmjsex As %Library.String = "", grp As %String, disptype As %String) As %String
{
    //get the print mode (is "hz" or not)
    //
    s result=..GetDispGroupPar("","",grp) 
    s result=$p(result,"^",4)
    
    s i=1
    s ret=""
    f   s DispCat=$p(result,"&",i) q:(DispCat="")!(ret'="")  d
    .i disptype=DispCat s ret=1 q
    .s i=i+1
    ;i disptype="WYY" s xx=$p(result,"&",1)
    ;i disptype="PJ" s xx=$p(result,"&",2)
    ;i disptype="ZCHY" s xx=$p(result,"&",3)
    ;i disptype="ZCY" s xx=$p(result,"&",4)
    ;i disptype="DMY" s xx=$p(result,"&",5)
    ;i disptype="ZJ" s xx=$p(result,"&",6)
    ;i disptype="DSY" s xx=$p(result,"&",7)
    ;q $g(xx)
    q ret
}

ClassMethod GetPrintFmt2(itmjs As %Library.String = "", itmjsex As %Library.String = "", phac As %String) As %String
{
    n (itmjs,itmjsex,phac)
    q:phac="" ""
    s locdr=..GetRecLocDr(phac) q:locdr="" ""
    q:'$d(^DHCDISPPRN(locdr)) ""
    q ^DHCDISPPRN(locdr)
}

ClassMethod GetPrintFmtAll(itmjs As %Library.String = "", itmjsex As %Library.String = "") As %String
{
    n (itmjs,itmjsex)
    s locdr=""
    s result=""
    f  s locdr=$o(^DHCDISPPRN(locdr)) q:locdr=""  d
    . s loc=$p(^CTLOC(locdr),"^",2)
    . i result="" s result=locdr_"&"_^DHCDISPPRN(locdr)_"&"_loc
    . e  s result=result_"^"_locdr_"&"_^DHCDISPPRN(locdr)_"&"_loc
    q result
}

ClassMethod GetRecLocDr(phac As %String) As %String
{
    n (phac)
    q:phac="" ""
    &sql(select dhc_phaloc_Dr into :ReclocDR
      From dhc_phacollected where dhc_phacollect_rowid=:phac)
    q:SQLCODE ""
    q $g(ReclocDR)
}

/// zdm,2012-03-05,参数由医嘱表id改为DHC_OeDispensing表id
/// 拒发药表存DHC_OeDispensing表id
ClassMethod InsertDrugRefuse(itmjs As %Library.String = "", itmjsex As %Library.String = "", StrDodis As %String, user As %String, refreason As %String)
{
    n (itmjs,itmjsex,StrDodis,user,refreason)
    s dd=+$h
    s tt=$p($h,",",2)
    tstart
    s $ZT="Error^DHCSTERROR"                        ;增加错误处理
    s err=0
    s len=$l(StrDodis,",")
    f i=1:1:len  q:err'=0  d
    .s dodis=$p(StrDodis,",",i)   ;配药表id
    .q:dodis=""
    .s oeori=$p(^DHCOEDISQTY(dodis),"^",1)
    .s ord=$p(oeori,"||",1)
    .s itm=$p(oeori,"||",2)
    .q:ord="" 
    .q:itm="" 
    .s stdf=$o(^STDF("DODIS",dodis,""))
    .q:stdf'=""
    .s recloc=$p(^DHCOEDISQTY(dodis),"^",24)  //$p(^OEORD(ord,"I",itm,3),"^",6)
    .s recloc=+recloc
    .s adm=$p(^OEORD(ord),"^",1)
    .&Sql(insert into dhc_stdrugrefuse (stdf_oedi_dr,stdf_date,stdf_time,stdf_user_dr,stdf_loc_dr,
        STDF_RefReason_DR,STDF_DODIS_DR)
        values (:oeori,:dd,:tt,:user,:recloc,:refreason,:dodis))
    .i SQLCODE'=0  d
    ..s ret=$$SqlErrorRecord^DHCSTERROR("InsertDrugRefuse:dhc_stdrugrefuse",dodis,SQLCODE_":"_%msg)
    ..s err=-1
    .q:err'=0
    .s hospid=$p(^CTLOC(recloc),"^",22)
    .s sendportalflag=##class(web.DHCSTCOMMPARA).GetSendPortalFlag(hospid)
    .i sendportalflag=1 d
    ..s ret=##class(web.DHCENS.EnsHISService).DHCHisInterface("S00000024",oeori,"1",adm) //20151016把医嘱传给protal liangqiang
    .s sendRet=##class(web.DHCSTInterfaceMessage).SendIPRefuseDisp(dodis,"Send",user)
    .s mInsertDrugRefuseD(dodis) = ""
    i err'=0 trollback
    q:err'=0 err
    tcommit
    d ##class(PHA.IP.COM.Face).UpdateSystemStatus4Dsp(.mInsertDrugRefuseD, "PHARCOL", user)
    q 0
}

/// Description:是否发药拒绝
/// Creator:    hulihua
/// CreateDate: 2017-11-27
/// Table:      DHC_STDRUGREFUSE
/// Input:      oedis-打包表ID、prescno-处方号（草药需要按照处方来判断）
/// Output:
/// Return：    ""-否，1-是
/// Others:
/// w ##class(web.DHCSTPCHCOLLS2).HaveBeenRefused("21","I17112700008")
ClassMethod HaveBeenRefused(oedis, prescno = "") As %String
{
    n (oedis,prescno)
    q:oedis="" ""
    q:(prescno'="")&&($d(^STDFi("PRESCNO",prescno))) 1 
    s stdf=$o(^STDF("DODIS",oedis,""))
    q:stdf="" ""
    q 1
}

ClassMethod inserttranstest() As %String
{
    k PLIST
    s PLIST(1)=""
    s PLIST(2)=1
    s PLIST(3)=1
    s PLIST(4)="608"
    s PLIST(5)=60141
    s PLIST(6)=""
    s PLIST(7)=1880
    s PLIST(8)="1880||1||1"
    s PLIST(9)=""
    s PLIST(10)="200||1"
    s PLIST(11)=1
    s PLIST(12)=1
    s PLIST(13)="56731"
    s PLIST(14)="F"
    s PLIST(15)="N"
    s PLIST(16)="N" 
    &sql(insert into dhc_intrans values :PLIST())
    q SQLCODE
}

ClassMethod OrdItmAudited(oeori As %String) As %String
{
 
  ; return value : 
  ;  < 0   : not audited
  ;  > 0   : audited  
  n (oeori)
  q:oeori="" -1
  s ord=$p(oeori,"||",1) q:ord="" -2
  s itm=$p(oeori,"||",2) q:itm="" -3
  q:'$d(^DHCCLNurseExec("Audit",ord,itm)) -4
  ;q:'$d(^OEORD(ord,"I",itm)) -4
  ;s auditflag=$p(^OEORD(ord,"I",itm,8),"^",9)
  ;q:auditflag="" -5
  q 1
}

ClassMethod SkinTestOld(oeori As %String) As %String
{
    ;检查要求皮试的医嘱 是否进行了皮试并且皮试为阴性？
    ; >=0  皮试正常
    ; < 0 皮试不正常 
    n (oeori)
    q:oeori="" -1
    s ord=$p(oeori,"||",1) q:ord="" -2
    s itm=$p(oeori,"||",2) q:itm="" -3
    q:'$d(^OEORD(ord,"I",itm)) -4
    ;s ^TMP("XXXXXXX")=oeori
    q:'$d(^OEORD(ord,"I",itm,5)) 0
    s SkinTestFlag=$p(^OEORD(ord,"I",itm,5),"^",2)
    i SkinTestFlag'="Y" d
    . s result=1
    e  d
    . s abnormal=$p(^OEORD(ord,"I",itm,11),"^",3)
    . s actiondr=$p(^OEORD(ord,"I",itm,11),"^",21)
    . i abnormal="N"  s result=1 
    . e  d
    . .i actiondr'="" s result=1
    . .e  s result=-5
    
    q $g(result)
}

/// Description:取皮试结果
/// Creator:Liang Qiang
/// CreatDate:2010-05-09
/// Input:医嘱Rowid
/// 检查要求皮试的医嘱,是否进行了皮试并且皮试为阴性  >=0  皮试正常 , -1 不正常，-6，未结果，-5 皮试(原液)
///     ; >=0  皮试正常
///     ; < 0 皮试不正常 
ClassMethod SkinTest(oeori As %String) As %String
{
    N (oeori)
    Q:oeori="" -1
    S ord=$p(oeori,"||",1) Q:ord="" ""
    S itm=$p(oeori,"||",2) Q:itm="" ""
    Q:'$D(^OEORD(ord,"I",itm,5)) ""
    S SkinTestFlag=$P(^OEORD(ord,"I",itm,5),"^",2)
    I SkinTestFlag'="Y" D
    .S result=""
    E  D
    .S abnormal=$P(^OEORD(ord,"I",itm,11),"^",3)
    .S actiondr=$P(^OEORD(ord,"I",itm,11),"^",21)
    .I abnormal="N"  S result=1 
    .E  D
    ..S result=-6 //未结果
    ..i abnormal="Y" S result=-1  
    ..I actiondr=1 S result=-5 //原液
    ..I actiondr=2 S result=1  //免试
    Q result
}

ClassMethod SkinTest2(oeori As %String) As %String
{
    ;要求皮试的医嘱 返回皮试备注（原液,免试）
    ;如果皮试备注为空(不要求皮试),则返回医嘱备注
    ;lq 2007-10-18 
    n (oeori)
    q:oeori="" "" 
    s ord=$p(oeori,"||",1) 
    q:ord="" ""
    s itm=$p(oeori,"||",2) 
    q:itm="" ""
    q:'$d(^OEORD(ord,"I",itm)) "" 
    s actiondr=$p(^OEORD(ord,"I",itm,11),"^",21) 
    i actiondr'="" s action=$p(^OEC("ACT",actiondr),"^",2) ;皮试备注
    s Notes=$g(^OEORD(ord,"I",itm,"DEP",1)) ;医嘱备注
    i $lv(Notes) s Notes=""
    s remark=$p($g(^OEORD(ord,"I",itm,2)),"^",8) //草药备注
    S Notes=$tr($tr($tr(Notes,$c(10)),$C(13))," ")
    i Notes'="" d
    .i remark'="" d
    ..s Notes=Notes_"("_remark_")"
    e  i remark'="" d
    .s Notes=remark
    .
    i actiondr="" s action=$g(Notes)
    e  s action=action_","_$g(Notes)
    q $g(action)
}

/// w ##class(web.DHCSTPCHCOLLS2).GetFeePoint()
ClassMethod GetFeePoint(orditmcat As %String) As %String [ ProcedureBlock = 1 ]
{
     ;returnvalue: "0" -  开医嘱计费
     ;             "1" -  发药计费
     //n (orditmcat)
     s ret=##Class(web.DHCSTCOMMONSRV).GetFeePoint(orditmcat)
     q ret
}

/// 是否允许发药,此处根据住院状态和计费点设置判断
/// returnvalue : 0  - 不允许，1 - 允许
ClassMethod IfCollectDrugAllowed(adm As %String, orditmcat As %String) As %String [ ProcedureBlock = 1 ]
{
    s ret=##Class(web.DHCSTCOMMONSRV).IfCollectDrugAllowed(adm,orditmcat)
    q ret
}

/// d ##Class(%ResultSet).RunQuery("web.DHCSTPCHCOLLS2","GetSkinTest","0000000067")
ClassMethod GetSkinTestExecute(ByRef qHandle As %Binary, RegNo) As %Status
{
    //s ^tmpdhy("GetSkinTestExecute")=RegNo
    //返回:登记号--医嘱名称--皮试结果
    s repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s ind=1
    
    ;s RegNo="00000029"
    q:RegNo="" $$$OK
    ;病人就诊号AdmNo
    s papmiId=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(RegNo),"")) ;病人信息表
    q:papmiId="" $$$OK
    s AdmNo="" f  s AdmNo=$o(^PAPERdr(papmiId,"ADM","I",AdmNo)) q:AdmNo=""  d 
    .q:$P(^PAADM(AdmNo),"^",17)'="" ;本次就诊号出院结算
    .s Oew="" f  s Oew=$O(^OEORD(0,"Adm",AdmNo,Oew)) q:Oew=""  d 
    ..s OrdSub=""  f  s OrdSub=$O(^OEORD(Oew,"I",OrdSub))  q:OrdSub=""  d
    ...s OrdStatDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",13)
    ...i OrdStatDR'="" s OrdStat=$P(^OEC("OSTAT",OrdStatDR),"^",1)   q:(OrdStat="U")||(OrdStat="C")
    ...s skintest="",abnorm=""
    ...s skintest=$p($g(^OEORD(Oew,"I",OrdSub,5)),"^",2)
    ...q:skintest=""
    ...s abnorm=""
    ...if (skintest="Y")&(OrdStat'="D") d
    ....s abnorm=$p($g(^OEORD(Oew,"I",OrdSub,11)),"^",3)
    ....s SkinTR="未做"
    ....if abnorm="Y"  s SkinTR="阳性"
    ....if abnorm="N"  s SkinTR="阴性"
    ....s ArcimdescDR=$p($g(^OEORD(Oew,"I",OrdSub,1)),"^",2)
    ....s Arcimdesc=$P(^ARCIM($P(ArcimdescDR,"||",1),$P(ArcimdescDR,"||",2),1),"^",2)
    ....d OutRowtyp
    Quit $$$OK
OutRowtyp
    set Data=$lb(RegNo,Arcimdesc,SkinTR)   //所对应传出的列名
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetSkinTestFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSkinTestExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             // if there are no more rows, finish 
fetching
        Set AtEnd=1
        Set Row=""
    }
    Else {          
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

Query GetSkinTest(RegNo As %String) As %Query(ROWSPEC = "TregNo:%String,Tarcimdesc:%String,TskinTR:%String")
{
}

ClassMethod GetSkinTestClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSkinTestExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod CheckArrears(adm As %String, loc As %String, date As %String, ord As %String) As %String
{
    ;判断某患者昨日已滚帐单费 + 当前预发药总费用 < 押金  返回:"Y" ,反之,返回:"N"
    n (adm,loc,date,ord)
    s str=""
    s chl="" f  s chl=$o(^OEORDi(0,"LocStDtArr",loc,0,date,ord,chl)) q:chl=""  d
    .s orditmrowid=ord_"||"_chl
    .s dodis=##class(web.DHCSTPCHCOLLS).GetDODIS(orditmrowid) q:dodis=""
    .s dspqty=##class(web.DHCSTPCHCOLLS).CalDspQty(dodis)
    .s str1=orditmrowid_$c(2)_dspqty
    .i str="" s str=str1
    .e  s str=str_"^"_str1
    s rtn=##Class(web.UDHCJFARREARSMANAGE).CheckArrears(adm, str,"")
    ;s ^tmplqxxx("CheckArrears")=adm_"^"_str_"^"_rtn
    s p5=$p(rtn,"^",5) ;控制等级类型 W/C (预警/控制) 
    s p9=$p(rtn,"^",9) ;是否允许发药 Y/N(允许/不允许)
    i p5="C" q p9
    q "Y"
}

ClassMethod CheckPhaName(pha As %String, userid As %String) As %String
{
    ;已发药审核界面填充发药人姓名
    n (pha,userid)
    q:'$d(^DHCPHAC(pha)) ""
    s $p(^DHCPHAC(pha),"^",13)=userid
    q:'$d(^SSU("SSUSR",userid)) ""
    s user=$p(^SSU("SSUSR",userid),"^",2)
    q $g(user)
}

ClassMethod GetInciByGenerExecute(ByRef qHandle As %Binary, str) As %Status
{
    ///Description:查找同一通用名且库存不为0的inci
    ///Input:OE_OrdItemrowid_"@"_DispCat(药品分类)_"@"_Pid_"@"_displocrowid_"@"_dispqty(发药数量)
    ///Return:inci
    ///Creator:lq 2008-11-08
    s repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s ind=1
    i str=""  w !,"提示: 取传参有误,请刷新发药界面"
    q:str="" $$$OK
    s oeori=$p(str,"@",1)
    s recloc=$p(str,"@",4)
    s dispqty=$p(str,"@",5)
    i dispqty=""  w !,"提示: 取发药数量有误,请核实"
    q:dispqty="" $$$OK
    s ord=$p(oeori,"||",1),chl=$p(oeori,"||",2)
    s arcimid=$p(^OEORD(ord,"I",chl,1),"^",2)
    s oldinci=$o(^INCI(0,"ARCIM_DR",$p(arcimid,"||",1),"") )
    i oldinci="" w !,"提示: 取预更换医嘱项有误,请核实" 
    q:oldinci="" $$$OK
    s chl=$o(^INCI("IL_LOC",recloc,oldinci,"")) 
    i chl="" w !,"提示: 取库存项批次信息有误,请核实"
    q:chl="" $$$OK
    s inciqty=##class(web.DHCSTKUTIL).SelClbQty(oldinci_"||"_chl,dispqty) 
    i inciqty=1 w !,"提示: 不能更换有库存的医嘱项"
    q:inciqty=1 $$$OK   ;库存足则退出
    s gener=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),8),"^",20)
    i gener=""  w !,"提示: 没有该通用名的医嘱项"
    q:gener="" $$$OK
    s arcsub=""
    f  s arcsub=$o(^ARCIM(0,"Gener",gener,arcsub)) q:arcsub=""  d
    .;s arcvi=""
    .;f  s arcvi=$o(^ARCIM(0,"Gener",gener,arcsub,arcvi)) q:arcvi=""  d
    .;s arcim=arcsub_"||"_arcvi
    .s arcim=+arcsub    
    .s inci=$o(^INCI(0,"ARCIM_DR",arcim,""))
    .s ch=$o(^INCI("IL_LOC",recloc,inci,"")) q:ch="" 
    .s incil=inci_"||"_ch
    .s qty=##class(web.DHCSTKUTIL).GetClbQtyObExp(incil) ;判断是否有库存
    .q:qty=0
    .s incicode=$p(^INCI(inci,1),"^", 1)
    .s incidesc=$p(^INCI(inci,1),"^", 2)
    .s arci=$p(^INCI(inci,1),"^", 3)
    .d OutRowInci
    Quit $$$OK
OutRowInci
    set Data=$lb(inci,incicode,incidesc,arci,str)   //所对应传出的列名
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetInciByGenerFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetInciByGenerExecute ]
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

Query GetInciByGener(oeori As %String) As %Query(ROWSPEC = "Tinci:%String,Tincicode:%String,Tincidesc:%String,Tarci:%String,Toeori:%String")
{
}

ClassMethod GetInciByGenerClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetInciByGenerExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetOrderTimeHXY() As %String
{
  ///Description:华西医院时间控制--14：00之后可以看到第二天生效的长嘱
  ///Creator:lq 08-11-11
  ///Input:OrderDate
  ///Return:0 --- 时间控制不生效, 1---时间控制生效   
  s tflag=$zth("14:00",1)
  s ret=0
  s ntime=$p($h,",",2)
  i ntime'<tflag d 
  .s ret=1
  q ret
}

ClassMethod GetOrderTime2HXY(priority, ordtime) As %String
{
  ///Description:华西医院时间控制--14：00之前可以看到当天14：00之后生效的长嘱
  ///Creator:lq 08-11-11
  ///Input:OrderDate
  ///Return:0 --- 时间控制不生效, 1---时间控制生效
  s ret=0
  s tflag=$zth("14:00",1)
  i (priority="S")&(ordtime'>tflag) d
  .s ret=1

  q ret
}

ClassMethod GetOrderTime3HXY() As %String
{
  ///Description:华西医院时间控制 上午8点后--下午14点前
  ///Creator:lq 08-11-11
  ///Input:OrderDate
  ///Return:0 --- 时间控制不生效, 1---时间控制生效   
  s startflag=$zth("8:00",1)
  s endflag=$zth("14:00",1)
  s ret=0
  s ntime=$p($h,",",2)
  i (ntime '< startflag) & (ntime '> endflag) d 
  .s ret=1
  q ret
}

ClassMethod GetAllOrderRowid(Str) As %String
{
  ///Description:华西医院构造预更改的医嘱项
  ///Creator:lq 08-11-11
  ///Input:OE_OrdItemrowid_"@"_DispCat(药品分类)_"@"_Pid_"@"_displocrowid_"@"_dispty(发药数量)
  ///Return:num--医嘱项 数量
   n (Str)
   q:Str="" 0 
   s oeori=$p(Str,"@",1)
   s arcimid=$p(^OEORD($p(oeori,"||",1),"I",$p(oeori,"||",2),1),"^",2)
   s InciRowid=$o(^INCI(0,"ARCIM_DR",$p(arcimid,"||",1),"") )
   q:InciRowid="" 0
   s DispCat=$p(Str,"@",2)
   s Pid=$p(Str,"@",3)
   s num=0
   s tmprowid=$o(^TMP("dhcpha",Pid,"ModifyARCIM","A",""))
   q:tmprowid="" -1
   ;
   i $d(^TMP("dhcpha",Pid,"ModifyARCIM","M")) d
   .k ^TMP("dhcpha",Pid,"ModifyARCIM","M")
   ;
   s OrdItmRowid=""
   f  s OrdItmRowid=$o(^TMP("dhcpha",Pid,"ModifyARCIM","A",OrdItmRowid)) q:OrdItmRowid=""  d
   .s tcflag=$$GetTCFLag(OrdItmRowid)
   .q:tcflag'=0 ;已发药的过滤
   .s ord=$p(OrdItmRowid,"||",1),chl=$p(OrdItmRowid,"||",2)
   .s arcimid=$p(^OEORD(ord,"I",chl,1),"^",2)             ;医嘱 ARC_ItmMast ARCIM_RowId
   .s inci=$o(^INCI(0,"ARCIM_DR",$p(arcimid,"||",1),"") )
   .q:inci=""
   .q:inci'=InciRowid
   .s oeflag=$p(^OEC("OSTAT",$p(^OEORD(ord,"I",chl,1),"^",13)),"^",1)   ;医嘱核实、未核实、停止状态
   .q:oeflag="D"  ; Stoped Item excluded 
   .q:(oeflag'="V")&(oeflag'="E")
   .q:##class(web.DHCSTPCHCOLLS2).HaveBeenRefused(OrdItmRowid) ;被拒绝发放
   .s adm=$p(^OEORD(ord),"^",1)
   .s arccatid=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",10)        ;医嘱子类RowId
   .s AmtFlag=##class(web.DHCSTPCHCOLLS2).IfCollectDrugAllowed(adm,arccatid)  
   .q:AmtFlag=0 ;最终结算,
   .s num=num+1
   .s ^TMP("dhcpha",Pid,"ModifyARCIM","M",OrdItmRowid)=OrdItmRowid
   .
   q num
GetTCFLag(OrdItmRowid)
   s n=0
   s Oedis=""
   f  s Oedis=$o(^DHCOEDISQTY(0,"OEORI",OrdItmRowid,Oedis))  q:(Oedis="")||(n>0)  d
   .i $p(^DHCOEDISQTY(Oedis),"^",7)'="TC" d
   ..s n=n+1
   q n
}

ClassMethod UpdateOrditm(NewOrdItmRowid, NewARCIM) As %String
{
    ///Description:华西医院更改医嘱项
    ///Creator:lq 08-11-11
    ///Input:NewOrdItmRowid ，NewARCIMRowid
    ///Return:err>0 失败, err=0 成功
    n (NewOrdItmRowid,NewARCIM)
    s err=0
    s err=##class(web.DHCOEOrdItem).ChangeOrdItm(NewOrdItmRowid,NewARCIM)
    q err
}

ClassMethod KillAfterModifyARCIM(pid) As %String
{
    n (pid)
    i $d(^TMP("dhcpha",pid,"ModifyARCIM")) d
    .k ^TMP("dhcpha",pid,"ModifyARCIM")
    q
}

ClassMethod ListOrditm(pid, OrdItmRowid) As %String
{
    n (pid,OrdItmRowid)
    q:'$d(^TMP("dhcpha",pid,"ModifyARCIM","M")) ""
    s tmp=""
    s tmp=$o(^TMP("dhcpha",pid,"ModifyARCIM","M",OrdItmRowid))
    q:tmp="" ""
    q ^TMP("dhcpha",pid,"ModifyARCIM","M",tmp)
}

ClassMethod CheckArrearsNew(pid As %String, adm As %String, str As %String, loclog) As %String
{
    n (pid,adm,str,loclog)
    //wyx 增加loclog取自登录科室session里的科室
    //判断科室是否要欠费控制，如配置了科室不欠费控制则不再判断其它配置，调用的接口：
    //0是控制，其它是不控制。
    s CheckIPLocDeposit=##Class(web.UDHCJFARREARSMANAGE).CheckLoc(loclog) 
    q:CheckIPLocDeposit'=0 "Y"
    //s rtn=##Class(web.UDHCJFARREARSMANAGE).CheckArrearsNew(pid,adm, str,"")
    s rtn=##Class(web.UDHCJFARREARSMANAGE).CheckArrears(adm, str,"CR")
    s p5=$p(rtn,"^",5) ;控制等级类型 W/C (预警/控制) 
    s p9=$p(rtn,"^",9) ;是否允许发药 Y/N(允许/不允许)
    //i p5="C" q p9     ///注释：此处只返回是否欠费，不做预警/控制判断 bianshuai 2015-12-11
    //q "Y"
    q p9
}

/// 更新配药人
ClassMethod UpdateOpUser(phac As %String, opUser As %String) As %String
{
    s dd=+$h
    s tt=$p($h,",",2)
    &sql(update dhc_phacollected set DHC_PHAOperator=:opUser,
            DHC_PHAOperateDate=:dd,DHC_PHAOperateTime=:tt where DHC_PHACollect_RowID=:phac)
    q SQLCODE
}

/// 更新发药人
ClassMethod UpdateDispenserInfo(phac As %String, CollectUser As %String) As %String
{
  s Col="Collect"
  s status=$p(^DHCPHAC(phac),"^",6)
  q:status'="Print" -1
  q:status=Col -2
  s phacdate=+$h
  s phactime=$p($h,",",2)
  &sql(UPDATE DHC_PHACollected SET  DHC_PHACollectStatus=:Col,
                                    DHC_PHACollectDate=:phacdate,
                                    DHC_PHACollectTime=:phactime,
                                    DHC_PHACollectUser=:CollectUser WHERE DHC_PHACollect_RowID=:phac)                                
  q:SQLCODE'=0 -3
  q 0
}

/// 检查是否已经配药
ClassMethod CheckOpUser(phac As %String) As %String
{
 
 n (phac)
 q:phac="" -1
 s opUser=$P(^DHCPHAC(phac),"^",5)
 s opDate=$P(^DHCPHAC(phac),"^",18)
 s opTime=$P(^DHCPHAC(phac),"^",19)
 if opUser'="",opDate'="",opTime'="" q 1
 q 0
}

/// 检查是否已经发药
ClassMethod CheckDispUser(phac As %String) As %String
{
 
 n (phac)
 q:phac="" -1
 s dispUser=$P(^DHCPHAC(phac),"^",13)
 s dispDate=$P(^DHCPHAC(phac),"^",2)
 s dispTime=$P(^DHCPHAC(phac),"^",3)
 if dispUser'="",dispDate'="",dispTime'="" q 1
 q 0
}

ClassMethod GetPhaCollUser(ip As %String)
{
  q:ip="" ""
  q $g(^TMP("ZSSY_PHACOLLUSER",+$h,ip))
}

ClassMethod SavePhaCollUser(str As %String, ip As %String)
{
 q:ip="" -1
 s d=+$h
 f  s d=$o(^TMP("ZSSY_PHACOLLUSER",d),-1) q:d=""  d
 .k ^TMP("ZSSY_PHACOLLUSER",d)
 s ^TMP("ZSSY_PHACOLLUSER",+$h,ip)=str
 q 0
}

ClassMethod GetPhaDispUser(ip As %String)
{
  q:ip="" ""
  q $g(^TMP("ZSSY_PHADISPUSER",+$h,ip))
}

ClassMethod SavePhaDispUser(str As %String, ip As %String)
{
 
 q:ip="" -1
 s d=+$h
 f  s d=$o(^TMP("ZSSY_PHADISPUSER",d),-1) q:d=""  d
 .k ^TMP("ZSSY_PHADISPUSER",d)
 s ^TMP("ZSSY_PHADISPUSER",+$h,ip)=str
 q 0
}

/// Creator:LiangQiang
/// CreatDate:2010-10-27
/// Description:判断医嘱是否有配液标记,
/// Input:医嘱rowid
/// Output: // 1:是 配液  0:否
ClassMethod IfPIVA(oeori As %String) As %String
{
    q 0 //zhouyg 20150624 不再使用此判断
    n (oeori)
    s ord=$p(oeori,"||",1)
    s chl=$p(oeori,"||",2)
    q:(ord="")!(chl="") 0
    Q:'$d(^OEORD(ord,"I",chl,"DHC")) 0
    s pivaflag=$p(^OEORD(ord,"I",chl,"DHC"),"^",16)
    i pivaflag="Y" s pivaflag=1
    i pivaflag="N" s pivaflag=0
    q pivaflag
}

ClassMethod GetFeePointTest(orditmcat As %String) As %String
{
     ;returnvalue: "0" -  开医嘱计费
     ;             "1" -  发药计费
     n (orditmcat)
     s %abc=1
     s ret=##Class(web.DHCSTCOMMONSRV).GetFeePointTest(orditmcat)
     q ret
}

}
