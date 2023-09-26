Import SQLUser

Class web.DHCSTRETREQUEST Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// w ##class(web.DHCSTRETREQUEST).GetHospRecByMedNo("SetAdm","","0000000113")
ClassMethod GetHospRecByMedNo(itmjs As %Library.String = "", itmjsex As %Library.String = "", medno As %String) As %String
{
 n (medno,itmjs,itmjsex)
 s code="I"
 &sql(declare cur1 cursor for 
 select paadm_admno,paadm_depcode_dr->ctloc_desc,
 paadm_admdate,paadm_admtime ,
 paadm_currentward_dr->ward_Desc, 
 paadm_currentbed_dr->bed_code,
 paadm_admdoccodedr->ctpcp_desc,
 paadm_rowid,
 paadm_depcode_dr,
 paadm_currentward_dr, 
 paadm_currentbed_dr
 from pa_adm 
 where paadm_papmi_dr->papmi_no=:medno and paadm_type=:code 
 order by paadm_admdate desc  )
 &sql(open cur1)
 s i=0,T=" .. "
 k ^TMP("DHCST",$this,"GetHospRecByMedNo",$j)
 f  &sql(fetch cur1 into :admno,:loc,:admdate,:admtime,:admward,:admbed,:admdoctor,:admdr,:deptdr,:warddr,:beddr)   q:SQLCODE  d
 . s visitstatus=##class(web.DHCSTCOMMONSRV).GetCurrentAdmStatus(admdr) //20160310 标准版开发
 . q:visitstatus=0
 . s i=i+1
 . s info1=admno_T_loc_T_##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(admdate,"IP")_T_##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(admtime,"IP")_T_admward_T_admbed_T_admdoctor
 . s info2=admdr_T_deptdr_T_warddr_T_beddr
 . s ^TMP("DHCST",$this,"GetHospRecByMedNo",$j,i)=info1_T_info2
 . ;s PLIST(i)=info1_T_info2
 &sql(close cur1)
 s result=""
 f j=1:1:i   d
 . i result="" s result=^TMP("DHCST",$this,"GetHospRecByMedNo",$j,j) q
 . s result=result_"^"_^TMP("DHCST",$this,"GetHospRecByMedNo",$j,j)
 
 s retval=itmjs_"('"_$ZCVT(result,"O","JS")_"');"
 i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(result,"O","JS")_"');"
 &javascript<#(retval)#>
 k ^TMP("DHCST",$this,"GetHospRecByMedNo",$j)
 q i
}

ClassMethod ListAdmInfo(n As %String) As %String
{
 i $d(^TMP("DHCST",$this,"GetHospRecByMedNo",$j,n)) q ^TMP("DHCST",$this,"GetHospRecByMedNo",$j,n)
 q ""
}

ClassMethod GetPoisonCatByItem(itemcode As %String) As %String
{
 ;根据医嘱项代码取得其毒理分类
 n (itemcode)
 s cpcat=""
 &sql(select arcim_phcdf_dr->phcdf_phcd_parref->PHCD_PHCPO_DR->phcpo_code
 into :cpcat from ARC_ItmMast where arcim_code = :itemcode)
 q cpcat
}

ClassMethod GetDspQtyByOrdItmRowid(orditmrowid As %String) As %String
{
 n (orditmrowid) ;根据医嘱记录的rowid取出发药数量
 s qty=""
 &sql(select dsp_rowid,dsp_qty,dsp_status into :dsprowid,:qty,:status From oe_dispensing 
 where dsp_rowid=:orditmrowid)
 s dsprowid=$p(dsprowid,$c(1))
 s qty=$p(qty,$c(1))
 s status=$p(status,$c(1))
 q dsprowid_"^"_qty_"^"_status
}

ClassMethod GetOrdItmRemark(ordi As %String) As %String
{
 n (ordi)
 s ord=$p(ordi,"||",1)
 s item=$p(ordi,"||",2)
 s num=""
 s memo=""
 f  s num=$o(^OEORD(ord,"I",item,"REM",num)) q:num=""  d
 .s memo=memo_$g(^OEORD(ord,"I",item,"REM",num))
 q memo
}

ClassMethod GetMaxRetReqNo(itmjs As %Library.String = "", itmjsex As %Library.String = "") As %String
{
 n (%session)
 s ReqNo=""
 s LocID=$g(%session.Data("LOGON.CTLOCID"))
 q:LocID="" ""
 s LocCode=$p(^CTLOC(LocID),"^",1)
 s HospString=##class(web.DHCSTCOMMONSRV).GetLocHosp(LocID)
 i HospString'="" d
 .s prepara=$p(HospString,"^",2)_"^"_LocCode
 .q:prepara=""
 .s ReqNo=##class(web.DHCSTPHACREATENO).GetAppNoM("DHC_STPhaRetReq",prepara)
 q:HospString'="" ReqNo 
 s ReqNo=..GetRetReqNo1("TR")   
 q ReqNo
}

ClassMethod GetRetReqNo1(prefix As %String) As %String
{
 s no=$I(^DHCSTPHARMACY("RETREQUEST"))
 s P0=prefix_$tr($j(no,8)," ","0")
 q P0
}

/// Description：生成请求单号
/// Creator:zdm
/// CreateDate:2012-03-07
/// Input:科室id
/// Return: 单号；
/// w ##class(web.DHCSTRETREQUEST).GetRetReqNo(1)
ClassMethod GetRetReqNo(LocID As %String) As %String
{
    n (LocID)
    s no=##class(web.DHCST.Common.AppCommon).GetAppNo("DHCSTPHARETREQ","",LocID)
    q:no="" "-1^生成退药申请单号失败"
    q no
}

ClassMethod GetPaRowid(admno As %String) As %String
{
 ;get itself rowid by admno     
 n (admno)   
 &sql(select paadm_rowid into :xx From pa_adm where paadm_admno=:admno ) 
 s xx=$p(xx,$c(1),1)
 q xx
}

ClassMethod GetDocRowid(Doctcode As %String) As %String
{
 ;get itself rowid by doctor name 
 n (Doctcode)
 q:Doctcode="" ""
 s Doctcode=$$ALPHAUP^SSUTIL4(Doctcode) 
 s xx=$o(^CTPCP(0,"Code",Doctcode,""))
 q:xx="" ""
 s xx=+$g(xx)  
 q xx
}

ClassMethod GetBedRowid(warm, Bed As %String) As %String
{
 n (warm,Bed)
 &sql(select bed_rowid into :mm from pac_bed where bed_ward_parref->ward_desc=:warm and bed_code=:Bed)
 q $g(mm)
}

/// Description：保存退药申请明细记录
/// Creator:zdm
/// CreateDate:2012-03-07
/// Input:申请主表id^医嘱id^申请退药数量^单价^申请人id^医嘱分发日期^退药原因^配药表id
/// Return: 明细id ,"" 失败
/// 
ClassMethod InsertDetail(onerec As %String) As %String
{
    n (onerec)
    s parref=$p(onerec,"^",1)
    s orditem=$p(onerec,"^",2)
    s retqty=$p(onerec,"^",3)
    s saleprice=$p(onerec,"^",4)
    s amount=retqty*saleprice
    s opuser=$p(onerec,"^",5)
    s stdate=$p(onerec,"^",6)
    s reasondr=$p(onerec,"^",7)
    s dspid=$p(onerec,"^",8)
    s phacLbRowId=$p(onerec,"^",9)
    s dodisBatch=$p(onerec,"^",10)
    s inclb=$p(onerec,"^",11)
    s inci=+inclb
    s dodis=+dodisBatch
    s reqflag="Prove"
    s xdate=+$h
    s xtime=$p($h,",",2)
    s childsub=$o(^RETRQ(parref,"I",""),-1)+1
    q:parref="" ""
    q:orditem="" ""
    &sql(insert into dhc_pharetrequestitm(RETRQI_RETRQ_ParRef,RETRQI_ChildSub,retrqi_oedis_dr,retrqi_qty,retrqi_sprice,retrqi_samount,RETRQI_Status,
    retrqi_updateuser_dr,retrqi_updatedate,retrqi_updatetime,RETRQI_DateDosing,
    RETRQI_REASON_DR,RETRQI_DoDis_Dr,RETRQI_INCI_DR,RETRQI_PHACIL_Dr,RETRQI_DSPB_Dr,RETRQI_INCLB_DR) 
    values(:parref,:childsub,:orditem,:retqty,:saleprice,:amount,:reqflag,:opuser,
    :xdate,:xtime,:stdate,:reasondr,:dodis,:inci,:phacLbRowId,:dodisBatch,:inclb))
    i SQLCODE'=0  d
    .s ret=$$SqlErrorRecord^DHCSTERROR("InsertReqItm:dhc_pharetrequestitm",dspid,SQLCODE_":"_%msg)
    q:SQLCODE'=0 ""
    q $p(%ROWID,$c(1))
}

/// Description：更新退药申请明细记录状态
/// Creator:zdm
/// CreateDate:2012-03-13
/// Input:申请明细表id
/// Return: 0,成功;其它，失败
/// 
ClassMethod UpdateReqItmStatus(ReqItmRowid As %String, Status As %String) As %String
{
    n (ReqItmRowid,Status)
    q:ReqItmRowid="" ""
    &sql(update dhc_pharetrequestitm set retrqi_status=:Status where retrqi_rowid=:ReqItmRowid)
    i SQLCODE'=0  d
    .s ret=$$SqlErrorRecord^DHCSTERROR("UpdateReqStatus:dhc_pharetrequestitm",ReqItmRowid,SQLCODE_":"_%msg)
    q SQLCODE
}

/// Description：更新退药申请单状态
/// Creator:zdm
/// CreateDate:2012-03-13
/// Input:申请表id
/// Return: 0,成功;其它，失败
/// 
ClassMethod UpdateReqStatus(ReqRowid As %String, Status As %String) As %String
{
    n (ReqRowid,Status)
    q:ReqRowid="" ""
    &sql(update dhc_pharetrequest set retrq_status=:Status where retrq_rowid=:ReqRowid)
    i SQLCODE'=0  d
    .s ret=$$SqlErrorRecord^DHCSTERROR("UpdateReqStatus:dhc_pharetrequestitm",ReqRowid,SQLCODE_":"_%msg)
    q SQLCODE
}

/// Description：保存退药申请主记录
/// Creator:zdm
/// CreateDate:2012-03-07
/// Input:药房id^pa_patmas表id^pa_adm表id^病区科室id^床位id^申请人id^就诊科室id
/// Return: 主表id ,"" 失败
/// 
ClassMethod InsertReqMain(onerec As %String) As %String
{
    n (onerec)
    s phaloc=$p(onerec,"^",1)
    s papmidr=$p(onerec,"^",2)
    s adm=$p(onerec,"^",3)
    s reqlocdr=$p(onerec,"^",4)
    s beddr=$p(onerec,"^",5)
    s opuser=$p(onerec,"^",6)
    s wardlocdr=$p(onerec,"^",7)
    s reqflag="Prove"
    s xdate=+$h
    s xtime=$p($h,",",2)
    s ret=$$LK()
    q:ret'=0 ""  ;加锁失败
    s reqno=..GetRetReqNo(reqlocdr)
    q:reqno="" ""
    &sql(insert into dhc_pharetrequest(retrq_reqno,retrq_recloc_dr,retrq_papmi_dr,
    retrq_paadm_dr,retrq_dept_dr,retrq_bed_dr,retrq_status,retrq_operuser_dr,retrq_operdate,
    retrq_opertime,retrq_updateuser_dr,retrq_updatedate,retrq_updatetime,RETRQ_WardLoc_DR) 
    values(:reqno,:phaloc,:papmidr,:adm,:reqlocdr,:beddr,:reqflag,:opuser,
    :xdate,:xtime,:opuser,:xdate,:xtime,:wardlocdr))
    i SQLCODE'=0  d
    .s ret=$$SqlErrorRecord^DHCSTERROR("InsertReqMain:dhc_pharetrequest",patno,SQLCODE_":"_%msg)
    d UL
    q:SQLCODE'=0 ""
    q $p(%ROWID,$c(1))
    
LK()
    l +^DHCSTLOCK("ReqNo"):5  e  q -100
    q 0
UL
    l -^DHCSTLOCK("ReqNo")
    q
}

ClassMethod GetPaInfo(oeorirowid As %String) As %String
{
    &sql(select oeori_oeord_parref->oeord_adm_dr->paadm_admno,
    oeori_oeord_parref->oeord_adm_dr->paadm_depcode_dr->ctloc_desc, 
    oeori_oeord_parref->oeord_adm_dr->paadm_currentward_dr->ward_Desc,
    oeori_oeord_parref->oeord_adm_dr-> paadm_admdoccodedr->ctpcp_desc
    into :admno,:admloc,:ward,:admdoctor
    from oe_orditem
    where oeori_rowid =:oeorirowid)
    q $g(admno)_"^"_$g(admloc)_"^"_$g(ward)_"^"_$g(admdoctor)
}

/// Description：通过退药申请界面保存退药申请单
/// Creator:zdm
/// CreateDate:2012-03-15
/// Input:操作人员ID，申请科室，配药表id^申请退药数量^申请退药原因,配药表id^申请退药数量^申请退药原因
/// Return: 成功：success^退药申请单号；failure^错误码
/// w ##class(web.DHCSTRETREQUEST).CreateDrugReqByXtime("1765||3","1",1)
ClassMethod InsDetail2(opuser As %String, reqdept As %String, sdata As %String) As %String
{
    
     n (opuser,reqdept,sdata)
     //s ^hlh($this)=$lb(opuser,reqdept,sdata)
     q:reqdept="" "failure^-10"
     q:opuser="" "failure^-10"
     ;
     s xdate=$p($h,",",1)
     s xtime=$p($h,",",2)
     s reqid=""
     s err=0
     tstart
     s $ZT="Error^DHCSTERROR"
     s len=$l(sdata,",")
     f i=1:1:len  q:err'=0  d
     .s data=$p(sdata,",",i)
     .s phacLbRowId=$p(data,"^",1) //此记录发药孙表ID
     .q:phacLbRowId=""
     .s phacId=+phacLbRowId
     .s phacSubId=$p(phacLbRowId,"||",2)
     .s phacLbId=$p(phacLbRowId,"||",3)
     .s dodisBatch=$p(^DHCPHAC(phacId,"I",phacSubId,"B",phacLbId),"^",7)
     .s dspid=+dodisBatch
     .q:..GetRequestFlagbyDsp(dspid)=0  //根据药房和发药类别判断是否允许建退药申请单 MaYuqiang 20171222
     .s retqty=$p(data,"^",2)
     .s reasondr=$p(data,"^",3)
     .s ordexerowid=$p(^DHCOEDISQTY(dspid),"^",3)
     .s ord=+ordexerowid
     .s itm=$p(ordexerowid,"||",2)
     .s ore=$p(ordexerowid,"||",3)
     .q:ord=""
     .q:itm=""
     .q:ore="" 
     .s orditem=ord_"||"_itm
     .s cat=##class(web.DHCSTPCHCOLLS).OrdCatType(orditem)
     .s admdr=$p(^DHCOEDISQTY(dspid),"^",26)
     .s wardlocdr=$p(^DHCOEDISQTY(dspid),"^",22)    ;病区科室
     .//s wardstr=##class(web.DHCSTPCHCOLLS).getOrdWard(orditem)            ;取医嘱当时病人所在的床号，病区已记录在配药表
     .//s beddr=$p(wardstr,"^",2)
     .s wardId=$o(^PAWARD(0,"WARD_LocationDR",wardlocdr,""))
     .s CurWardId=$p(^PAADM(admdr),"^",70)
     .s beddr=""
     .i wardId=CurWardId d
     ..s beddr=$p(^PAADM(admdr),"^",73) //zhouyg 20160510 取床号修改
     .s orddept=$p(^OEORD(ord,"I",itm,1),"^",3)
     .s prescno=$p(^OEORD(ord,"I",itm,1),"^",14)
     .s doctorloc=$p($g(^OEORD(ord,"I",itm,7)),"^",2)  ;医生科室
     .s stdate=$p(^DHCOEDISQTY(dspid),"^",21)        ;分发日期
     .s status=$p(^DHCOEDISQTY(dspid),"^",7)        ;配药记录状态
     .s:status'="C" err=-1
     .q:status'="C"                                 ;未发药不需要退药
     .s OreStatusDr=$p(^OEORD(ord,"I",itm,"X",ore),"^",16)  ;护士执行状态
     .s:OreStatusDr="" err=-11
     .q:OreStatusDr=""                              ;停止执行和撤销执行的记录可申请退药&(AdminStatus'="C")
     .s AdminStatus=$p(^OEC("STAT",OreStatusDr),"^",1) 
     .s:(AdminStatus'="D") err=-11 
     .q:(AdminStatus'="D")      ;停止执行和撤销执行的记录可申请退药
     .s phaloc=$p(^DHCPHAC(phacId),"^",1)
     .s getpatnameid=$p(^PAADM(admdr),"^",1) 
     .s patno=$p(^PAPER(getpatnameid,"PAT",1),"^",1) 
     .s saleprice=$p(^DHCPHAC(phacId,"I",phacSubId,"B",phacLbId),"^",5)
     .s amount=saleprice*retqty
     .s reqflag="Prove"
     .s ReturnedQty=##class(web.DHCSTPHARETURN).ReturnedQtyByPhacLb(phacLbRowId) ;已退药数量
     .s ReqedQty=..GetReqQtyByPhacLb(phacLbRowId)  ;已经申请数量
     .s PhaQty=$p(^DHCPHAC(phacId,"I",phacSubId,"B",phacLbId),"^",2)    ;发药数量
     .s AvailRetQty=PhaQty-ReturnedQty-ReqedQty
     .s:(AvailRetQty-retqty)<0 err=-4
     .q:(AvailRetQty-retqty)<0     ;申请退药数量(已经申请数量+本次申请数量)大于可退数量，
     .
     .s admloc=$p(^DHCPHAC(phacId,"I",phacSubId),"^",11)
     .i reqid=""  d
     ..s listdata=phaloc_"^"_getpatnameid_"^"_admdr_"^"_reqdept_"^"_beddr_"^"_opuser_"^"_wardlocdr
     ..s reqid=..InsertReqMain(listdata)     ;新生成申请单
     .s:reqid="" err=-13
     .q:reqid=""            ;生成请求单失败
     .s inclb=$p(^DHCPHAC(phacId,"I",phacSubId,"B",phacLbId),"^",1) 
     .s listdetail1=reqid_"^"_orditem_"^"_retqty_"^"_saleprice_"^"_opuser
     .s listdetail2=stdate_"^"_reasondr_"^"_dspid_"^"_phacLbRowId_"^"_dodisBatch
     .s listdetail3=inclb
     .s listdetail=listdetail1_"^"_listdetail2_"^"_listdetail3
     .s ret=..InsertDetail(listdetail)   ;保存请求明细
     .s:ret="" err=-14
     .q:ret=""
     .
     i err'=0 trollback
     q:err'=0 "failure^"_err
     s reqno=$p(^RETRQ(reqid),"^",1)
     tcommit
     q "success^"_reqno
}

ClassMethod GetPhaRetReqRowidByNo(no As %String) As %String
{
 n (no)
 ; save the rowid of every request-record within one req NO .   
 s rowid="", n=0
 f  s rowid=$o(^RETRQ(0,"RETRQNO",no,rowid)) q:rowid=""  d
 .i retrowid="" d
 . . s retrowid=rowid
 .e  d
 . . s retrowid=retrowid_"^"_rowid
 q $g(retrowid)
}

ClassMethod GetBUomByArcItmDr(arcitmdr As %String) As %String
{
 n (arcitmdr)
 ;&sql(SELECT INCI_CTUOM_DR->ctuom_desc into :baseuomdesc FROM INC_ITM  WHERE INCI_ARCIM_DR=:arcitmdr)
 s inci=$o(^INCI(0,"ARCIM_DR",$p(arcitmdr,"||",1),""))   
 q:'inci ""
 s basicuom=+$p(^INCI(inci,1),"^",10)
 s baseuomdesc=$p(^CT("UOM",basicuom),"^",2)
 q basicuom_"^"_baseuomdesc
}

ClassMethod CancelRetReq(rowid, user As %String) As %String
{
 n (rowid,user) 
 s updatedate=+$h
 s updatetime=$p($h,",",2)
 s code="Ignore"
 &sql(update dhc_pharetrequest set retrq_status=:code,
 retrq_updateuser_dr=:user,retrq_updatedate=:updatedate,retrq_updatetime=:updatetime
 where retrq_rowid=:rowid)
 q 0
}

ClassMethod UpdateQty(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid, qty, user As %String) As %String
{
     n (itmjs,itmjsex,rowid, qty, user)
     q:rowid="" -1
     s updatedate=+$h,updatetime=$p($h,",",2)
     s dqty=..GetRetRedQty(rowid, qty)
     s newqty=0
     q:dqty=0
     s err=0
     tstart
     s strlen=$l(rowid,"#")
     f i=1:1:strlen d
     .s itmqty=0
     .q:dqty=0
     .s reqid=$p(rowid,"#",i) 
     .s chl=$p(reqid,"||",2)
     .q:chl=""
     .s retflag=$p(^RETRQ(+reqid,"I",chl),"^",10)
     .s itmqty=$p(^RETRQ(+reqid,"I",chl),"^",3)
     .s dodis=$p(^RETRQ(+reqid,"I",chl),"^",11)
     .s dispqty=+##class(web.DHCSTPHARETURN).DispedQty(dodis)
     .i dqty>0 d  //减少数量
     ..i (itmqty'=0)&(dqty<itmqty) d
     ...s newqty=itmqty-dqty
     ...s dqty=0
     ..i (itmqty'=0)&(dqty>=itmqty) d
     ...s newqty=0
     ...s dqty=dqty-itmqty
     ...s retflag="Ignore"
     .i dqty<0 d       ///增加数量
     ..;q:dispqty=itmqty
     ..s dqty=-dqty
     ..i itmqty=0 d
     ...i dispqty>dqty d
     ....s newqty=dqty
     ....s dqty=0
     ...e  d
     ....s newqty=dispqty
     ....s dqty=dqty-dispqty
     ...s retflag="Prove"
     ..e  d
     ...i (dispqty-itmqty)>dqty d
     ....s newqty=dqty+itmqty
     ....s dqty=0
     ...e  d
     ....s newqty=dispqty
     ....s dqty=dqty-dispqty+itmqty
     ..s dqty=-dqty
     .s SQLCODE=0
     .&sql(update dhc_pharetrequestitm set retrqi_qty=:newqty,retrqi_updateuser_dr=:user,retrqi_updatedate=:updatedate,retrqi_updatetime=:updatetime,RETRQI_Status=:retflag where retrqi_rowid=:reqid)
     .s:SQLCODE'=0 err=-1
     .s sp=$p(^RETRQ(+reqid,"I",chl),"^",4)
     .s amount=sp*qty
     .s $p(^RETRQ(+reqid,"I",$p(reqid,"||",2)),"^",5)=amount //Modify by LQ 20090206
     i err'=0 trollback
     q:err'=0 "failure^"_err
     tcommit
     q 0
}

ClassMethod GetRetReqByDateDept(d1, d2, dept, recloc, drugtype As %String) As %String
{
 n (d1,d2,dept,recloc,drugtype)
 s d1=$zdh(d1,3),d2=$zdh(d2,3)
 s code="Ignore"
 i drugtype=""   s drugtype="%"
 s reclocDR=##class(web.DHCSTCOMMONSRV).LocToRowID(recloc)
 s deptDR=##class(web.DHCSTCOMMONSRV).LocToRowID(dept)
 k ^TMP($j,"RETREQ")
 &sql(declare curb cursor for SELECT distinct retrq_reqno from dhc_pharetrequest
 where retrq_operdate between :d1 and :d2 and RETRQ_Dept_DR=:deptDR
 and  retrq_recloc_dr =:reclocDR and retrq_status<>:code
 order by retrq_reqno )
 &sql(open  curb)
 s n=0
 f  &sql(fetch curb into :retrqno) q:SQLCODE  d
 .s n=n+1
 .s ^TMP($j,"RETREQ",n)=retrqno
 &sql(close curb)
 q $g(n)
}

ClassMethod GetRetReqByDate(d1, d2, recloc, drugtype As %String) As %String
{
 n (d1,d2,recloc,drugtype)
 s d1=$zdh(d1,3),d2=$zdh(d2,3)
 i drugtype=""   s drugtype="%"
 s reclocDR=##class(web.DHCSTCOMMONSRV).LocToRowID(recloc)
 k ^TMP("DHCST",$this,"GetRetReqByDate",$j)
 &sql(declare cura cursor for SELECT distinct retrq_reqno from dhc_pharetrequest
 where retrq_operdate between :d1 and :d2 
 and   retrq_recloc_dr =:reclocDR
 order by retrq_reqno) 
 &sql(open  cura)
 s n=0
 f  &sql(fetch cura into :retrqno) q:SQLCODE  d
 .s n=n+1
 .s ^TMP("DHCST",$this,"GetRetReqByDate",$j,n)=retrqno
 &sql(close cura)
 q $g(n)
}

ClassMethod ListRetReqNo(i As %Integer) As %String
{
 i $d(^TMP("DHCST",$this,"GetRetReqByDate",$j,i)) q ^TMP("DHCST",$this,"GetRetReqByDate",$j,i)
 q ""
}

/// Description：;根据就诊号取已发药且执行记录停止执行或撤销执行的记录
/// Creator:zdm
/// CreateDate:2012-03-14
/// Input:就诊号 ,发药科室ID,申请科室id
/// Return: 0 成功 , <0 失败
ClassMethod GetIpOutRec(admno, locdr, userlocdr)
{
  
 n (admno,locdr,userlocdr,%session)
 //s ^hlh($this)=$lb(admno,locdr,userlocdr)
 s pid=..NewPid()
 k ^TMP("DHCST",$this,"GetIpOutRec",pid)
 k ^TMP("DHCST",$this,"GetIpOutRec","FreqQty",pid)
 s userid=$g(%session.Data("LOGON.USERID"))
 s i=0
 q:admno="" 0
 s admno=$$ALPHAUP^SSUTIL4(admno)
 s adm=$o(^PAADMi("No",admno,"")) q:adm="" 0
 s visitstatus=##class(web.DHCSTCOMMONSRV).GetCurrentAdmStatus(adm) //20160310 标准版开发
 q:visitstatus=0 0
 s ord=$o(^OEORD(0,"Adm",adm,"")) q:ord="" 0
 s itm=0 
 f  s itm=$o(^OEORD(ord,"I",itm)) q:itm=""  d 
 . q:'$d(^OEORD(ord,"I",itm,1)) //接收科室不存在
 . s recdepdr=$p(^OEORD(ord,"I",itm,3),"^",6)
 . s logonspecial=##class(web.DHCSTPCHCOLLS).DoctorLocRefuse(recdepdr,$g(%session.Data("LOGON.CTLOCID"))) ;登陆科室是否为特殊科室
 . s prescno=$p(^OEORD(ord,"I",itm,1),"^",14)
 . q:'$d(^OEORD(ord,"I",itm,2))
 . s doseqty=$p(^OEORD(ord,"I",itm,2),"^",1)
 . s doseunit=$p(^OEORD(ord,"I",itm,2),"^",3)
 . i doseunit'="" s doseunit=$p(^CT("UOM",doseunit),"^",2)
 . s doseqty=doseqty_doseunit   //剂量_剂量单位
 . s freq=$p(^OEORD(ord,"I",itm,2),"^",4)
 . s freq=$s((freq'="")&&($d(^PHCFR(freq))):$p(^PHCFR(freq),"^",1),1:"")
 . s arcim=$p(^OEORD(ord,"I",itm,1),"^",2)
 . s itemcode=$p(^ARCIM($p(arcim,"||",1),$p(arcim,"||",2),1),"^",1)
 . s itemdesc=$p(^ARCIM($p(arcim,"||",1),$p(arcim,"||",2),1),"^",2)
 . s Drcode="",Drname=""
 . s doctor=$p(^OEORD(ord,"I",itm,1),"^",11)
 . i (doctor'="") d
 . . i $d(^CTPCP(doctor,1)) s Drcode=$p(^CTPCP(doctor,1),"^",1),Drname=$p(^CTPCP(doctor,1),"^",2)
 . q:(locdr'="")&&(recdepdr'=locdr)   ; not the receieve loc
 . s orditemrowid=ord_"||"_itm
 . s orddate=$p(^OEORD(ord,"I",itm,3),"^",7)
 . s time=$p(^OEORD(ord,"I",itm,1),"^",17)
 . s sttdate=$p(^OEORD(ord,"I",itm,1),"^",9)
 . s xdate=$p(^OEORD(ord,"I",itm,3),"^",34)
 . s buom="",dispunit=""
 . s inci=$o(^INCI(0,"ARCIM_DR",$p(arcim,"||",1),"")) 
 . i inci'="" s buom=$p(^INCI(inci,1),"^",10) 
 . i buom'="" s dispunit=$p(^CT("UOM",buom),"^",2)  //发药单位(基本单位)
 . s UserDept=..UserDept(orditemrowid)
 . s orditmstatus=$p(^OEORD(ord,"I",itm,1),"^",13)
 . i orditmstatus'="" s orditmstatus=$p(^OEC("OSTAT",orditmstatus),"^",2)
 . 
 . s dspid=""
 . f  s dspid=$o(^DHCOEDISQTY(0,"OEORI",orditemrowid,dspid)) q:dspid=""  d
 . .s status=$p(^DHCOEDISQTY(dspid),"^",7)          ;配药记录状态
 . .q:status'="C"                               ;未发药不需要退药
 . .s phaci=$p(^DHCOEDISQTY(dspid),"^",14)          ;发药子表id
 . .q:phaci="" 
 . .s phacrowid=+phaci
 . .s phaitmid1=phaci
 . .s ordexerowid=$p(^DHCOEDISQTY(dspid),"^",3) 
 . .s ore=$p(ordexerowid,"||",3)
 . .q:ore=""
 . .//s orestate=$P(^OEORD(ord,"I",itm,"X",ore,"BILL"),"^",1) //执行记录状态,yunhaibao20160303
 . .//q:orestate=""
 . .//s orestatecode=$P($g(^OEC("OSTAT",orestate)),"^",1)
 . .//q:orestatecode="D"
 . .s OreStatusDr=$p(^OEORD(ord,"I",itm,"X",ore),"^",16)  ;护士执行状态
 . .q:OreStatusDr=""                            ;停止执行记录可申请退药
 . .s AdminStatus=$p(^OEC("STAT",OreStatusDr),"^",1)  
 . .q:(AdminStatus'="D")        ;停止执行的记录可申请退药,&(AdminStatus'="C")
 . .s dspqty1=$p(^DHCOEDISQTY(dspid),"^",11) 
 . .s returnedqty=##class(web.DHCSTPHARETURN).ReturnedQtyByDodis(dspid)   ;已退数量
 . .s reqedqty=..GetReqQtyByDodis(dspid)       ;已申请未退数量
 . .q:(dspqty1-returnedqty-reqedqty)'>0   //发药已全退
 . .s dspqty=dspqty1-returnedqty
 . .q:'$d(^DHCPHAC(phacrowid))
 . .s ward=$p(^DHCPHAC(phacrowid),"^",4)
 . .i ward'="" s locrowid=$p(^PAWARD(ward),"^",5)
 . .e  s locrowid=##Class(web.DHCSTKUTIL).UserDept(orditemrowid)
 . .s specialflag=##class(web.DHCSTPCHCOLLS).DoctorLocRefuse(recdepdr,locrowid) ;特殊科室
 . .q:(specialflag=1)&&(logonspecial'=1)
 . .s CpType=..GetSSUserType(userid)
 . .i CpType["DOC" s locrowid=##Class(web.DHCSTKUTIL).UserDept(orditemrowid)
 . .s config=##Class(web.DHCSTKUTIL).GetPhaConfig("Con_ReqWard") //获取设置
 . .q:($g(locrowid)'="")&(userlocdr'="")&($g(locrowid)'=userlocdr)&(config=1)   ;不是在当前病区领的药，不允许在此病区申请退药  
 . .s reqflag="未退的申请:"_reqedqty_",历次退药:"_returnedqty
 . .s i=i+1
 . .s info1=itemcode_"^"_itemdesc_"^"_freq_"^"_dspqty_"^"_dispunit
 . .s info2=doseqty_"^"_prescno_"^"_Drcode_"^"_Drname_"^"_orddate
 . .s info3=time_"^"_orditemrowid_"^"_orditemrowid_"^"_sttdate
 . .s info4=arcim_"^"_orditmstatus_"^"_dspid_"^"_UserDept_"^"_reqflag  //lq add 2007/09/29
 . .s info5=recdepdr_"^"_locrowid
 . .
 . .s ^TMP("DHCST",$this,"GetIpOutRec",pid,i)=info1_"^"_info2_"^"_info3_"^"_info4_"^"_info5
 k ^TMP("DHCST",$this,"GetIpOutRec","FreqQty",pid)
 q pid_"^"_i
}

ClassMethod GetRetNumByOrditem(orditemrowid) As %String
{
 ;据医嘱项取退药表中的退药总数量
 ;2007/09/28
 ;add by lq
 s retnumtotal=0
 s retrowid=""
 f  s retrowid=$o(^PHARET(0,"PHARET",orditemrowid,retrowid)) q:retrowid=""  d 
 . s retnum=$p( ^PHARET(retrowid),"^",12) //退药申请数量
 . s retnumtotal=retnumtotal+retnum
 q retnumtotal
}

ClassMethod ListDisp(pid, n As %Integer) As %String
{
 i $d(^TMP("DHCST",$this,"GetIpOutRec",pid,n)) q ^TMP("DHCST",$this,"GetIpOutRec",pid,n)
 q ""
}

ClassMethod ListDispByDrug(pid, n As %Integer) As %String
{
 i $d(^TMP("DHCST",$this,"GetIpOutRecByDrug",pid,n)) q ^TMP("DHCST",$this,"GetIpOutRecByDrug",pid,n)
 q ""
}

ClassMethod RetItmSp(phacLbRowId As %String) As %String
{
 ;Get the sale price of the drug when disp.
 n (phacLbRowId)
 q:phacLbRowId="" 0
 s phacId=+phacLbRowId
 s phacSubId=+$p(phacLbRowId,"||",2)
 s phacLbId=+$p(phacLbRowId,"||",3)
 q:(phacId=0)||(phacSubId=0)||(phacLbId=0) 0
 s sp=$p(^DHCPHAC(phacId,"I",phacSubId,"B",phacLbId),"^",5)
 q $g(sp)
}

ClassMethod GetAdmInfoByDisp(itmjs As %Library.String = "", itmjsex As %Library.String = "", oedis As %String) As %String
{
 ;Get the data of adm according to dispensing 
 n (oedis)
 s or=+oedis,ch=$p(oedis,"||",2)
 ;,ex=$p(oedis,"||",3),di=$p(oedis,"||",4)
 q:(or="")!(ch="")
 ;!(ex="")!(di="") ""
 s recdepdr=$P(^OEORD(or,"I",ch,3),"^",6)  ; receiving loc
 s admdr=+$P(^OEORD(or),"^",1)
 ;s warddr=$p(^PAADM(admdr),"^",70)
 ;i warddr'="" s wardlocdr=##class(web.DHCSTKUTIL).GetCtlocByWardDR(warddr)
 s OldWardStr=##class(web.DHCSTPCHCOLLS).getOrdWard(oedis)
 s warddr=$p(OldWardStr,"^",1)
 i warddr'="" s wardlocdr=##class(web.DHCSTKUTIL).GetCtlocByWardDR(warddr)
 s doctorloc=$p($g(^OEORD(or,"I",ch,7)),"^",2)  ;医生科室
 s specialflag=##class(web.DHCSTPCHCOLLS).DoctorLocRefuse(recdepdr,doctorloc)
 i specialflag=1  d
 .s reqdept=doctorloc    ;如果是特殊科室，申请科室为医生科室
 e  d
 .s reqdept=$g(wardlocdr)    ;如果不是特殊科室，申请科室为病区科室
 s beddr=$p(OldWardStr,"^",2) //$p(^PAADM(admdr),"^",73)
 ;s admlocdr=$p(^OEORD(or,"I",ch,1),"^",3)
 s admlocdr=$p(^PAADM(admdr),"^",4)
 s doctordr=$p(^OEORD(or,"I",ch,1),"^",11)   ;doctor of orditem 
 s doctor=$P(^CTPCP(doctordr,1),"^",2)
 q $g(recdepdr)_"^"_$g(admdr)_"^"_$g(admlocdr)_"^"_$g(reqdept)_"^"_$g(beddr)_"^"_$g(doctor)
}

ClassMethod CheckOedis(itmjs As %Library.String = "", itmjsex As %Library.String = "", oedis, phacidr) As %String
{
 //check if the retrequest for the oedis has already existed
 n (itmjs,itmjsex,oedis,phacidr) 
 q:oedis="" 0
 q:phacidr="" 0
 s retrq=""
 s retrqno=""
 s code="Prove"
 f  s retrq=$o(^RETRQ(0,"OEDIS",oedis,retrq))  q:(retrq="")!(retrqno'="")  d
 .s phaci=$p(^RETRQ(retrq),"^",24)
 .s status=$p(^RETRQ(retrq),"^",14)
 .i (status=code)&(phaci=phacidr) s retrqno=$p(^RETRQ(retrq),"^",1) q
 q retrqno
}

/// Description:判断某配药记录是否存在退药申请
/// Input:配药表id
/// Output:"":不存在  , 不为空：存在
/// Others:
/// Creator:zhangdongmei
/// CreatDate:2012-03-15
/// yunhaibao20170908,因医嘱改造修改
ClassMethod CheckReqExist(phacLbRowId) As %String
{
    n (phacLbRowId)
    q:phacLbRowId="" ""
    s phacId=+phacLbRowId
    s phacSubId=+$p(phacLbRowId,"||",2)
    s phacLbId=+$p(phacLbRowId,"||",3)
    q:(phacId=0)||(phacSubId=0)||(phacLbId=0) 0
    s dodisBatch=$p(^DHCPHAC(phacId,"I",phacSubId,"B",phacLbId),"^",7)
    s retstr=""
    q:dodisBatch="" ""
    s phareq=""
    f  s phareq=$o(^RETRQ(0,"DSPB",dodisBatch,phareq)) q:(phareq="")!(retstr'="")  d
    .s chl=""
    .f  s chl=$o(^RETRQ(0,"DSPB",dodisBatch,phareq,chl)) q:(chl="")!(retstr'="")  d
    ..s reqstatus=$p(^RETRQ(phareq,"I",chl),"^",10)
    ..q:reqstatus'="Prove"
    ..s reqPhacLb=$p(^RETRQ(phareq,"I",chl),"^",15)
    ..q:reqPhacLb'=phacLbRowId
    ..s reqno=$p(^RETRQ(phareq),"^",1)
    ..s retstr=reqno
    .
    q retstr
}

ClassMethod DelRetReq(reqno) As %String
{
 
 q:reqno="" ""
 &sql(delete from dhc_pharetrequest where retrq_reqno=:reqno)
 q SQLCODE
}

ClassMethod GetDispItmsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDispItmsExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetDispItmsExecute(ByRef qHandle As %Binary, RegNo As %String, Adm As %String, displocrowid As %String, userlocid As %String) As %Status
{
 //s ^hlh($this)=$lb(RegNo, Adm, displocrowid , userlocid)
 Set repid=$I(^CacheTemp)
 Set qHandle=$lb(0,repid,0)
 Set ind=1
 q:RegNo="" $$$OK
 q:Adm="" $$$OK
 d ResetVariables
 s paname=$g(paname)
 &sql(select papmi_name,PAPMI_RowId into :paname,:papmi from pa_patmas where papmi_no=:RegNo)
 ;
 s pano=RegNo
 ;
 s EncryptLevelInfo=""
 s EncryptLevel=""
 s PatLevel="" 
 s EncryptFlag=##Class(web.DHCSTCOMMPARA).GetEncryptLevelFlag("")
 i EncryptFlag=1 d
 .s EncryptLevelInfo=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(papmi,"")
 .s EncryptLevel=$p(EncryptLevelInfo,"^",1)
 .s PatLevel=$p(EncryptLevelInfo,"^",2)
 s pidcnt=..GetIpOutRec(Adm,displocrowid,userlocid) ;
 s pid=$p(pidcnt,"^",1)
 s cnt=$p(pidcnt,"^",2)
 q:cnt<1 $$$OK
 ;d ResetVariables
 s i=1
 f i=1:1:cnt  d
 . s dispitm=..ListDisp(pid,i)
 . d OutputRow
 k ^TMP("DHCST",$this,"GetIpOutRec",pid)
 Quit $$$OK
OutputRow
 s itmcode=$p(dispitm,"^",1)
 s itmdesc=$p(dispitm,"^",2)
 s ordqty=$p(dispitm,"^",4)
 s unit=$p(dispitm,"^",5)
 s prescno=$p(dispitm,"^",7)
 s Oirowid=$p(dispitm,"^",12)
 s Ordstatus=$p(dispitm,"^",16)
 s dispid=$p(dispitm,"^",17) 
 S UserDept=$p(dispitm,"^",18)   
 s reqqty=ordqty 
 s pano=RegNo
 s reqflag=$p(dispitm,"^",19)
 s reclocdr=$p(dispitm,"^",20)
 s wardlocdr=$p(dispitm,"^",21)
 s reclocdesc=$p(^CTLOC(reclocdr),"^",2)
 i reclocdesc["-" s reclocdesc=$p(reclocdesc,"-",2,$l(reclocdesc,"-"))
 set Data=$lb(pano,$g(paname),prescno,itmdesc,ordqty,reqqty,unit,Ordstatus,Oirowid,dispid,UserDept,reqflag,itmcode,EncryptLevel,PatLevel,reclocdr,wardlocdr,reclocdesc)
 Set ^CacheTemp(repid,ind)=Data  
 Set ind=ind+1
 q 
ResetVariables  
 set (pano,paname,prescno,itmdesc,ordqty,reqqty,unit,Ordstatus,Oirowid,pharowid,UserDept,reqflag,itmcode,EncryptLevelInfo,PatLevel,reclocdr,wardlocdr,reclocdesc)=""
 q
}

ClassMethod GetDispItmsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDispItmsExecute ]
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

Query GetDispItms(RegNo As %String, Adm As %String, displocrowid As %String, userlocid As %String) As %Query(ROWSPEC = "TRegNo:%String,TName:%String,TPrescNo:%String,TDesc:%String,TDispQty:%String,TReqQty:%String,TUom:%String,TStatus:%String,Toedis:%String,Tdspid:%String,TUserDept:%String,Treqflag:%String,Titmcode:%String,TEncryptLevel:%String,TPatLevel:%String,TRecLocDr:%String,TWardLocDr:%String,TRecLocDesc:%String")
{
}

ClassMethod EditTableExecute(ByRef qHandle As %Binary) As %Status
{
 Set repid=$I(^CacheTemp)
 Set qHandle=$lb(0,repid,0)
 Set ind=1
 //实现；
 d ResetVariables4
 //s (ta,tb,tc)="4"
 
 d OutputRow4
 Quit $$$OK
OutputRow4
 s Data=$lb(TRegNo,TPrescNo,TDesc,TUom,TDispQty,TReqQty,TSalePrice,TSalePriceAmt,TDoctor,TRecLocDr,TWardDr,TBedDr,TDspDr,TAdmLocDR,TAdmdr,TRetReason,TRetReasonDR,Tphacrowid)
 s ^CacheTemp(repid,ind)=Data    
 s ind=ind+1
 q
ResetVariables4
 s (TRegNo,TPrescNo,TDesc,TUom,TDispQty,TReqQty,TSalePrice,TSalePriceAmt,TDoctor,TRecLocDr,TWardDr,TBedDr,TDspDr,TAdmLocDR,TAdmdr,TRetReason,TRetReasonDR,Tphacrowid)=""
 q
}

ClassMethod EditTableClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = EditTableExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod EditTableFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = EditTableExecute ]
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

Query EditTable() As %Query(ROWSPEC = "TRegNo:%String,TPrescNo:%String,TDesc:%String,TUom:%String,TDispQty:%String,TReqQty:%String,TSalePrice:%String,TSalePriceAmt:%String,TDoctor:%String,TRecLocDr:%String,TWardDr:%String,TBedDr:%String,TDspDr:%String,TAdmLocDR:%String,TAdmdr:%String,TRetReason:%String,TRetReasonDR:%String,Tphacrowid:%String")
{
}

ClassMethod IfQtyAllowedReturn(itmjs As %Library.String = "", itmjsex As %Library.String = "", retrq As %String, retreqqty As %String) As %String
{
 ; returnvalue : 0 - Not allowed 
 ;   1 - Allowed
 n (itmjs,itmjsex,retrq,retreqqty,phaci)
 q:retrq="" 0
 q:retreqqty<=0 0                   //zdm,2010-11-26,申请退药数量不允许为负的
 s retflag=1
 s dispqty=0
 s returnedQty=0
 s strlen=$l(retrq,"#")
 f i=1:1:strlen d
 .s reqid=$p(retrq,"#",i) 
 .s chl=$p(reqid,"||",2)
 .q:chl=""
 .//s prtflag=$p(^RETRQ(+reqid),"^",22)  //2013-01-30 ws
 .//s:$g(prtflag)="P" retflag=99 //2013-01-30 ws  申请单打印拒绝状态为P的不允许修改单子
 .s retitmflag=$p(^RETRQ(+reqid,"I",chl),"^",10)
 .;q:retitmflag'="Prove"
 .s dodis=$p(^RETRQ(+reqid,"I",chl),"^",11)
 .s dispqty=dispqty+##class(web.DHCSTPHARETURN).DispedQty(dodis) //发药数量
 .s returnedQty=returnedQty+##class(web.DHCSTPHARETURN).ReturnedQtyByDodis(dodis)
 i (retreqqty+returnedQty)>dispqty q 0
 q retflag
}

ClassMethod DelRetrq(itmjs As %Library.String = "", itmjsex As %Library.String = "", retrq As %String)
{
    n (itmjs,itmjsex,retrq)
    s i=0,exit=0,RefundStatus=0,reqflag=0
    s sub=""
    f  s sub=$o(^RETRQ(+retrq,"I",sub)) q:(sub="")||(i>1)  d 
    .s i=i+1  
    
    tstart
    s tmpretrqstr=retrq
    s strlen=$l(tmpretrqstr,"#")
    f h=1:1:strlen q:exit=1  d
    .s retrq=$p(tmpretrqstr,"#",h) 
    .s RefundStatus=$p(^RETRQ(+retrq,"I",$p(retrq,"||",2)),"^",12)
    .q:RefundStatus=1
    .s reqstatus=$p(^RETRQ(+retrq,"I",$p(retrq,"||",2)),"^",10)
    .i reqstatus'="Prove" s reqflag=1
    .q:reqstatus'="Prove" 
    .i i=1 d
    ..s reqrowid=+retrq
    ..&sql(delete from dhc_pharetrequest where RETRQ_Rowid=:reqrowid)
    ..i SQLCODE'=0 s exit=1 
    ..i SQLCODE'=0 tro
    .e  d
    ..&sql(delete from dhc_pharetrequestitm where retrqi_rowid=:retrq)
    ..i SQLCODE'=0 s exit=1 
    ..i SQLCODE'=0 tro
    
    q:exit=1 -1
    tc
    q:reqflag=1 -3
    q:RefundStatus=1 -2
 
    q 0
}

ClassMethod AutoReturn(retrequestNo As %String, DispLocRowid As %String) As %String
{
  ;DispLocRowid - 此rowid为需要自动退药的发药科室的rowid, 可能需要写死
 n (retrequestNo,DispLocRowid)
 s n=0
 s RetNo=""
 s ReasonRowid=$o(^BLC("RFR",0))  ;退药原因rowid,取BLC_ReasonForRefund第一行,写死了
 s code="Prove"
 s RetReq=""
 f  s RetReq=$o(^RETRQ(0,"RETRQNO",retrequestNo,RetReq))  q:RetReq=""  d
 .s status=$p(^RETRQ(RetReq),"^",14) 
 .q:status'=code 
 .s Oedisdr=$p(^RETRQ(RetReq),"^",9)
 .;--------------lq add 2007/09/29 -------------
 .s phadr=$p(^RETRQ(RetReq),"^",24) //指向发药明细表
 .s Inclbdr=$p(^DHCPHAC($p(phadr,"||",1),"I",$p(phadr,"||",2)),"^",4)
 .;---------------------------
 .s Admdr=$p(^RETRQ(RetReq),"^",5)  
 .s Reclocdr=$p(^RETRQ(RetReq),"^",2)
 .q:Reclocdr'=DispLocRowid  
 .s Admlocdr=$p(^RETRQ(RetReq),"^",21) 
 .s DeptDr=$p(^RETRQ(RetReq),"^",7)  
 .s BedDr=$p(^RETRQ(RetReq),"^",8)  
 .s RetRqDR=RetReq
 .s UserDR=$p(^RETRQ(RetReq),"^",15) 
 .s DD=+$h
 .s TT=$p($h,",",2) 
 .s Prescno= $p(^RETRQ(RetReq),"^",10)  
 .s Qty=$p(^RETRQ(RetReq),"^",11) 
 .s Price=$p(^RETRQ(RetReq),"^",12)  
 .s Amount=$p(^RETRQ(RetReq),"^",13)  
 .s inci=+Inclbdr   ;;
 .s itmcode=$p(^INCI(inci,1),"^",1) 
 .s Uom=$p(^INCI(inci,1),"^",10)
 .
 .i RetNo="" s RetNo=##class(web.DHCSTPHARETURN).GetNewRetNo("","","RT") 
 .s datastr="" 
 .s datastr=Oedisdr_"^"_Inclbdr_"^"_Admdr_"^"_Reclocdr_"^"_Admlocdr
 .s datastr=datastr_"^"_DeptDr_"^"_BedDr_"^"_RetRqDR_"^"_UserDR_"^"_DD_"^"_TT_"^"_Prescno
 .s datastr=datastr_"^"_Qty_"^"_Price_"^"_Amount_"^"_RetNo_"^"_itmcode_"^"_Uom_"^"_phadr ;
 .;w datastr,!
 .s ret=##class(web.DHCSTPHARETURN).ExecReturn("","",datastr,ReasonRowid)
 .;w ret,!
 .s n=n+1
 q n
}

ClassMethod GetRetrqItmTotal(reqno As %String) As %String
{
 ///Description:退药之前打印申请单汇总(华西)
 ///Creator:LQ
 n (reqno)
 s h=0
 s pid=..NewPid()
 s cnt=$l(reqno,"^")
 s reqnostr=reqno
 f i=1:1:cnt d
 .s reqno=$p(reqnostr,"^",i) 
 .s retrq=""
 .f  s retrq=$o(^RETRQ(0,"RETRQNO",reqno,retrq)) q:retrq=""  d
 ..s recloc=$p(^RETRQ(retrq),"^",2)
 ..s dept=$p(^RETRQ(retrq),"^",7)
 ..i recloc'="" s recloc=$p(^CTLOC(recloc),"^",2)
 ..i dept'="" s dept=$p(^CTLOC(dept),"^",2)
 ..s retdate=$p(^RETRQ(retrq),"^",11)
 ..i retdate'="" s retdate=$zd(retdate,3)
 ..s qty=$p(^RETRQ(retrq),"^",11)
 ..s oedis=$p(^RETRQ(retrq),"^",9)
 ..s ord=$p(oedis,"||",1),itm=$p(oedis,"||",2) 
 ..s arcim=$p(^OEORD(ord,"I",itm,1),"^",2)
 ..s inci=$o(^INCI(0,"ARCIM_DR",$p(arcim,"||",1),""))
 ..s incicode=$p(^INCI(inci,1),"^",1)
 ..s incidesc=$p(^INCI(inci,1),"^",2)
 ..s uom=$p(^INCI(inci,1),"^",10)
 ..s uomdesc=$p(^CT("UOM",uom),"^",2)
 ..s adm=$p(^RETRQ(retrq),"^",5)
 ..s patid=$p(^PAADM(adm),"^",1) 
 ..s patno=$p(^PAPER(patid,"PAT",1),"^",1) 
 ..s paname=$p(^PAPER(patid,"ALL"),"^",1)
 ..s bed="" 
 ..s beddr=$p(^RETRQ(retrq),"^",8)
 ..i beddr'="" s bed=$p(^PAWARD(+beddr,"BED",$p(beddr,"||",2)),"^",1)
 ..s h=h+1
 ..s listdata=reqno_"^"_patno_"^"_paname_"^"_bed_"^"_inci_"^"_recloc_"^"_dept_"^"_retdate_"^"_incicode_"^"_incidesc_"^"_uomdesc_"^"_qty
 ..s ^TMP("DHCST",$this,"GetRetrqItmTotal","Itm",pid,h)=listdata
 ..i $d(^TMP("DHCST",$this,"GetRetrqItmTotal","Total",pid,inci)) d
 ...s $p(^TMP("DHCST",$this,"GetRetrqItmTotal","Total",pid,inci),"^",8)=$p(^TMP("DHCST",$this,"GetRetrqItmTotal","Total",pid,inci),"^",8)+qty
 ..e   d
 ...s ^TMP("DHCST",$this,"GetRetrqItmTotal","Total",pid,inci)=inci_"^"_recloc_"^"_dept_"^"_retdate_"^"_incicode_"^"_incidesc_"^"_uomdesc_"^"_qty
 q h_"^"_pid
}

ClassMethod ListRetrqItmTotal(pid As %String, inci As %String) As %String
{
 s newinci=$o(^TMP("DHCST",$this,"GetRetrqItmTotal","Total",pid,inci)) q:newinci="" ""
 q ^TMP("DHCST",$this,"GetRetrqItmTotal","Total",pid,newinci)
}

ClassMethod ListRetrqItm(pid As %String, i As %String) As %String
{
 
 q:'$d(^TMP("DHCST",$this,"GetRetrqItmTotal","Itm",pid,i)) ""
 q ^TMP("DHCST",$this,"GetRetrqItmTotal","Itm",pid,i)
}

Query SetRetReason() As %SQLQuery(ROWSPEC = "TReasonDesc:%String,TRowid:%String")
{
select Rfr_desc,Rfr_rowid From BLC_ReasonForRefund
}

ClassMethod UpdateRetReason(rowid As %String, code As %String, desc As %String) As %String
{
 i rowid="" d
 .&sql(insert into BLC_ReasonForRefund(RFR_Code,RFR_Desc) values (:code,:desc) )
 e  d
 .&sql(update BLC_ReasonForRefund set RFR_Code=:code,RFR_Desc=:desc where RFR_RowId=:rowid)
 q:SQLCODE -1
 q %ROWID
}

ClassMethod CheckRetReason(rowid As %String, code As %String, desc As %String) As %String
{
 s num=0
 i rowid="" d
 .&sql(select count(RFR_RowId) into :num from BLC_ReasonForRefund where RFR_Code=:code and RFR_Desc=:desc)
 e  d
 .&sql(select count(RFR_RowId) into :num from BLC_ReasonForRefund where RFR_Code=:code and RFR_Desc=:desc and RFR_RowId<>:rowid)
 q:SQLCODE -1
 q:num'=0 1
 q 0
}

ClassMethod DeleteRetReason(rowid As %String) As %String
{
 q:rowid="" 0
 &sql(delete from BLC_ReasonForRefund where RFR_RowId=:rowid)
 q:SQLCODE -1
 q 0
}

Query GetRetReasons() As %SQLQuery(ROWSPEC = "TReasonDesc:%String,TRowid:%String,TReasonCode:%String")
{
select Rfr_desc,Rfr_rowid,Rfr_code From BLC_ReasonForRefund
}

Query GetDispItmsByDrug(DispLocRowID As %String, WardRowID As %String, InciRowID As %String, StartDate As %String, EndDate As %String) As %Query(ROWSPEC = "TRegNo:%String,TName:%String,TPrescNo:%String,TDesc:%String,TDispQty:%String,TReqQty:%String,TUom:%String,TStatus:%String,Toedis:%String")
{
}

ClassMethod GetIpOutRecByDrug(locdr, wardrowid, incirowid, startdate, enddate)
{
 ;根据药品,发药日期和病区取已发药且医嘱已停的记录
 n (locdr, wardrowid, incirowid, startdate, enddate)
 s pid=..NewPid()
 k ^TMP("DHCST",$this,"GetIpOutRecByDrug",pid)
 s i=0 
 ;取得库存项对应的医嘱项
 s arcim=$p(^INCI(incirowid,1),"^",3)
 ;取得指定时间段内所有符合条件的发药记录
 f date=startdate:1:enddate d
 .s phac=""
 .f  s phac=$o(^DHCPHAC(0,"PHA",locdr,"DATE",date,phac)) q:phac=""  d   ;发药主表rowid
 ..s currward=$p(^DHCPHAC(phac),"^",4) q:currward=""
 ..q:currward'=wardrowid
 ..s phaci=0
 ..f  s phaci=$o(^DHCPHAC(phac,"I",phaci)) q:phaci=""  d
 ...s dhcphaci=phac_"||"_phaci  //07-10-06
 ...s adm=$p(^DHCPHAC(phac,"I",phaci),"^",3)
 ...s papmi=$p(^PAADM(adm),"^",1) q:papmi=""
 ...s patname=$p(^PAPER(papmi,"ALL"),"^",1)
 ...s patno=$p(^PAPER(papmi,"PAT",1),"^",1)
 ...//s visitstatus=$p(^PAADM(adm),"^",20)
 ...//q:visitstatus="D"    //已经出院结算
 ...s visitstatus=##class(web.DHCSTCOMMONSRV).GetCurrentAdmStatus(adm)  //20160310 标准版开发
 ...q:visitstatus=0 
 ...s dspid=$P(^DHCPHAC(phac,"I",phaci),"^",7) q:dspid=""     ;OE_Dispensing，RowID
 ...;dspid = The Rowid of OE_OrdItem
 ...s ord=$p(dspid,"||",1) //指向OE_Order
 ...s itm=$p(dspid,"||",2) //OEORI_Childsub
 ...//s exe=$p(dspid,"||",3)
 ...//s dsp=$p(dspid,"||",4)
 ...s arcimid=$p(^OEORD(ord,"I",itm,1),"^",2)     ;医嘱项
 ...q:arcimid'=arcim
 ...s unit=$p(^OEORD(ord,"I",itm,2),"^",3)
 ...i unit'="" s unit=$p(^CT("UOM",unit),"^",2)
 ...s itemdesc=$p(^ARCIM($p(arcim,"||",1),$p(arcim,"||",2),1),"^",2)
 ...s orditmstatus=$p(^OEORD(ord,"I",itm,1),"^",13)
 ...i orditmstatus'="" s orditmstatus=$p(^OEC("OSTAT",orditmstatus),"^",1)
 ...q:orditmstatus'="D"  ; stoped order item
 ...s prescno=$P(^DHCPHAC(phac,"I",phaci),"^",5)
 ...
 ...//s dspqty=+$p(^OEORD(ord,"I",itm,"X",exe,"D",dsp),"^",1)
 ...s dspqty=##class(web.DHSTPHARETURN).DispedQty(dhcphaci)   //07-10-06
 ...//s retqty=+$p(^OEORD(ord,"I",itm,"X",exe,"D",dsp),"^",7)
 ...s retqty=##class(web.DHSTPHARETURN).ReturnedQty(dhcphaci)  //07-10-06
 ...
 ...s dspqty=dspqty-retqty
 ...q:dspqty=0
 ...;---------------------------
 ...;s dhcoedis=""
 ...;f  s dhcoedis=$o(^DHCOEDISQTY(0,"OEORI",dspid,dhcoedis)) q:dhcoedis=""
 ...//.;s status=$p(^DHCOEDISQTY(dhcoedis),"^",7) //发药状态
 ...//.;-------------------------------
 ...//s status=$p(^OEORD(ord,"I",itm,"X",exe,"D",dsp),"^",6)
 ...//s status=
 ...//.q:status'="C"
 ...
 ...s i=i+1 
 ...s info1=patno_"^"_patname_"^"_itemdesc_"^"_dspqty_"^"_unit
 ...s info2=prescno_"^"_dspid_"^"_orditmstatus
 ...s ^TMP("DHCST",$this,"GetIpOutRecByDrug",pid,i)=info1_"^"_info2
 q pid_"^"_i
}

ClassMethod GetDispItmsByDrugClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDispItmsByDrugExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetDispItmsByDrugExecute(ByRef qHandle As %Binary, DispLocRowID As %String, WardRowID As %String, InciRowID As %String, StartDate As %String, EndDate As %String) As %Status
{
 //zhangdongmei 2007-3-14
 Set repid=$I(^CacheTemp)
 Set qHandle=$lb(0,repid,0)
 Set ind=1
 q:DispLocRowID="" $$$OK
 q:WardRowID="" $$$OK
 q:InciRowID="" $$$OK
 q:StartDate="" $$$OK
 q:EndDate="" $$$OK
 
 //初始化本地变量；
 d ResetVariables2
 
 //检索发药记录
 s pidcnt=..GetIpOutRecByDrug(DispLocRowID,WardRowID,InciRowID,StartDate,EndDate)   
 s pid=$p(pidcnt,"^",1)
 s cnt=$p(pidcnt,"^",2)
 q:cnt<1 $$$OK
 
 s i=1
 f i=1:1:cnt  d
 . s dispitm=..ListDispByDrug(pid,i)
 . d OutputRow2
 k ^TMP("DHCST",$this,"GetIpOutRecByDrug",pid)
 Quit $$$OK
OutputRow2
 s pano=$p(dispitm,"^",1)
 s paname=$P(dispitm,"^",2)
 s itmdesc=$p(dispitm,"^",3)
 s ordqty=$p(dispitm,"^",4)
 s unit=$p(dispitm,"^",5)
 s prescno=$p(dispitm,"^",6)
 s Oirowid=$p(dispitm,"^",7)
 s Ordstatus=$p(dispitm,"^",8)
 s reqqty="" 
 set Data=$lb(pano,$g(paname),prescno,itmdesc,ordqty,reqqty,unit,Ordstatus,Oirowid)
 Set ^CacheTemp(repid,ind)=Data  
 Set ind=ind+1
 q 
ResetVariables2 
 set (pano,paname,prescno,itmdesc,ordqty,reqqty,unit,Ordstatus,Oirowid)=""
 q
}

ClassMethod GetDispItmsByDrugFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDispItmsByDrugExecute ]
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

ClassMethod UserDept(oeori) As %String
{
 //开医嘱时所登录的科室名称
 //
 n (oeori,%session)
 s ord=$p(oeori,"||",1)
 s itm=$p(oeori,"||",2)
 q:'$d(^OEORD(ord,"I",itm,7)) ""
 s UserDeptdr=$p(^OEORD(ord,"I",itm,7),"^",2)     /// oeori_userdept_dr
 q ##class(PHA.COM.Data.Base).LocDesc(UserDeptdr)
}

/// Description:获取病区或特殊科室
/// Creator:LQ  09-02-27
ClassMethod GetReqLocExecute(ByRef qHandle As %Binary, input As %String, DocFlag As %String) As %Status
{
    s repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s ind=1
    s PhaLoc=%session.Data("LOGON.CTLOCID")
    i DocFlag'="1" d
    .&sql(DECLARE cur CURSOR FOR
    SELECT ward_desc,ward_rowid FROM  pac_ward where %ALPHAUP(ward_desc) %STARTSWITH %ALPHAUP(:input)
    or %ALPHAUP(WARD_LocationDR->CTLOC_ContactName) %STARTSWITH %ALPHAUP(:input)
    )
    .
    .&sql(OPEN cur)
    .n SQLCODE 
    .s num=1
    .f  &sql(fetch cur into :warddesc(num),:wardrowid(num) )  q:SQLCODE  d
    ..s desc=warddesc(num)
    ..s rowid=wardrowid(num) 
    ..s ctlocdr=$p(^PAWARD(rowid),"^",5)
    ..q:##class(web.DHCSTKUTIL).DoctorLocRefuse(PhaLoc,ctlocdr)=1
    ..s rowid=ctlocdr
    ..d OutReqLoc
    ..s num=num+1
    .&sql(close cur)
    e  d
    .;s PhaLoc="116"

    .&sql( 
           DECLARE curLoc CURSOR FOR
           select link_ctloc_dr from CT_LocLinkLocation 
           where link_parref=:PhaLoc 
           and  
           (%ALPHAUP(link_ctloc_dr->CTLOC_Desc) %STARTSWITH %ALPHAUP(:input) or
            %ALPHAUP(link_ctloc_dr->CTLOC_ContactName) %STARTSWITH %ALPHAUP(:input)    
           )
     )
    
    .&sql(OPEN curLoc)
    .n SQLCODE 
    .s num=1
    .f  &sql(fetch curLoc into :linkctlocdr(num) )  q:SQLCODE  d
    ..s lklocdr=linkctlocdr(num)
    ..s ch=""
    ..f  s ch=$o(^CTLOC(PhaLoc,"LINK",0,"Loc",lklocdr,ch)) q:ch=""  d
    ...s rowid=$p(^CTLOC(PhaLoc,"LINK",ch),"^",1)
    ...s desc=$p(^CTLOC(rowid),"^",2)
    ...d OutReqLoc
    ..s num=num+1
    .&sql(close curLoc)
  
    Quit $$$OK
OutReqLoc
    set Data=$lb(desc,rowid)   
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetReqLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetReqLocExecute ]
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

Query GetReqLoc(input As %String, DocFlag As %String) As %Query(ROWSPEC = "Tdesc:%String,Trowid:%String")
{
}

ClassMethod GetReqLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetReqLocExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Creator:Liang Qiang
/// CreatDate:2009-05-21
/// Description:获取退药申请单状态
/// Table:DHC_PhaRetRequest
/// Input:oeorditmRowid , 发药明细Rowid
/// OutPut:已申请:xxx , 历次退药:xxx
/// Return:已申请:xxx , 历次退药:xxx
/// Other:
ClassMethod GetReqStatus(oedis, phacidr) As %String
{
 n (oedis,phacidr) 
 q:oedis="" ""
 q:phacidr="" ""
 s retstr=""
 s code="Prove"
 s retcode="Execute"
 ;申请
 s retrq=""
 s reqflag=0
 f  s retrq=$o(^RETRQ(0,"OEDIS",oedis,retrq))  q:(retrq="")!(reqflag=1)  d
 .s phaci=$p(^RETRQ(retrq),"^",24)
 .s status=$p(^RETRQ(retrq),"^",14)
 .i (status=code)&(phaci=phacidr) d
 ..s reqestqty=$p(^RETRQ(retrq),"^",11)
 ..s reqflag=1
 ..s retstr="已申请:"_reqestqty
 ;退药
 s retflag=0
 s retrq=""
 f  s retrq=$o(^RETRQ(0,"OEDIS",oedis,retrq))  q:(retrq="")!(retflag=1)  d
 .s phaci=$p(^RETRQ(retrq),"^",24)
 .s status=$p(^RETRQ(retrq),"^",14)
 .i (status=retcode)&(phaci=phacidr) d
 ..s returnqty=##class(web.DHCSTPHARETURN).ReturnedQty(phaci)
 ..s retflag=1 
 ..i retstr="" d
 ...s retstr="历次退药:"_returnqty
 ..e  d
 ...s retstr=retstr_" , "_"历次退药:"_returnqty
 ..
 .
 q retstr
}

/// Creator:Liang Qiang
/// CreatDate:2009-08-10
/// Description:填退药申请时设置默认发药科室
/// Table:^DHCSTPHACONFIG
/// Input:发药科室Rowid
/// Other:
ClassMethod SetDefaultPhaLoc(displocid, grpid) As %String
{
    n (displocid,grpid)
    q:grpid="" ""
    s ^DHCSTPHACONFIG("DefaultPhaLoc","dhcpha",grpid)=displocid
    q 0
}

/// Description:如果停医嘱时间>分发时间,则把发药数量减掉该频次数量,计算出最终还可退数量
/// Creator:Liang Qiang
/// CreatDate:2009-12-10
/// Input:医嘱项Rowid , 可退药数量
/// Return:还可退药数量
ClassMethod GetDspqtyByXtime(orditem, Dspqty) As %String
{
    n (orditem,Dspqty)
    s ord=+orditem
    s itm=$p(orditem,"||",2)
    s qtypackuom=$p(^OEORD(ord,"I",itm,9),"^",4)
    q:qtypackuom'="" Dspqty
    s dspcnt=0   ;医嘱实发频次个数
    s tatolqty=0 ;医嘱实发药总数量
    s freqcnt=0
    s freqstr=""
    s colflag="C"
    s colflag2="T"
    s dsp="" 
    f  s dsp=$o(^DHCOEDISQTY(0,"OEORI",orditem,dsp)) q:dsp=""  d
    .s status=$p(^DHCOEDISQTY(dsp),"^",7)
    .i (status=colflag2)!(status=colflag) s freqcnt=freqcnt+1
    .q:status'=colflag
    .s dispqty=$p(^DHCOEDISQTY(dsp),"^",5)
    .s tatolqty=tatolqty+dispqty
    .s dspcnt=dspcnt+1
    .s freqstr=freqstr_","_freqcnt
    i freqstr'="" s freqstr=$p(freqstr,",",2,$l(freqstr,","))  //实际发药的频次
    q:tatolqty=0 Dspqty
    s freq=$p(^OEORD(ord,"I",itm,2),"^",4)
    s xtime=$p(^OEORD(ord,"I",itm,2),"^",15)
    s h=0
    s syqty=0
    s phcdtime=""
    s Plist=""
    s chl=0
    f  s chl=$o(^PHCFR(freq,"DT",chl)) q:chl=""  d
    .s TStr=$p(^PHCFR(freq,"DT",chl),"^",1)
    .s phcdtime=$p(TStr,"^",1)
    .s Plist=Plist_","_phcdtime
    q:Plist="" Dspqty
    i Plist'="" s Plist=$p(Plist,",",2,$l(Plist,","))
    s cnt=$l(Plist,",")
    f i=1:1:cnt d 
    .q:$$findfreq(freqstr,i)
    .s ptime=$p(Plist,",",i)
    .i xtime'<ptime d
    ..s h=h+1
    ;
    i $d(^TMP("dhcpha",$j,"freqqty",orditem)) d
    .i ^TMP("dhcpha",$j,"freqqty",orditem)=0 d
    ..s retflag=1
    q:$g(retflag)=1 Dspqty  ;上个批次减掉频次后还需减数量为0
    ;
    i h'=0 d    ;停医嘱时间>分发时间
    .s rqty=(tatolqty/dspcnt)*h   ;某orditem应减掉频次的数量=(发药总数/发药次数)*应扣频次个数
    .i $D(^TMP("dhcpha",$j,"freqqty",orditem))  d
    ..i ^TMP("dhcpha",$j,"freqqty",orditem)>0 d 
    ...s rqty=^TMP("dhcpha",$j,"freqqty",orditem) ;上个批次减掉频次后还需减数量
    .i Dspqty'>tatolqty d
    ..i Dspqty'>rqty d
    ...s syqty=rqty-Dspqty  
    ...s rqty=0
    ..e  d
    ...s rqty=Dspqty-rqty
    e  d
    .s rqty=Dspqty
    s ^TMP("dhcpha",$j,"freqqty",orditem)=syqty
    q rqty  ;还可退药数量
    
findfreq(freqstr,i)
    //查找有效的频次
    s findflag=1
    s strcnt=$l(freqstr,",")
    f z=1:1:strcnt d
    .s x=$p(freqstr,",",z)
    .i x=i s findflag=0 
    q findflag
}

/// Description:取用户身份 DOCTOR , NURSE  等
/// Creator:Liang Qiang
/// CreatDate:2010-03-30
ClassMethod GetSSUserType(userid) As %String
{
    
      s CareProvDR=$p(^SSU("SSUSR",userid),"^",14)
      q:CareProvDR="" ""
      q:'$d(^CTPCP(CareProvDR,1)) ""
      s CarPrvTpDR=$p(^CTPCP(CareProvDR,1),"^",4)
      s CpType=$p(^CT("CPT",CarPrvTpDR),"^",4)
      s CpType=$zcvt(CpType,"U")
      q CpType
}

/// Description：执行记录停止执行或撤销执行时自动生成退药申请单
/// Creator:zdm
/// CreateDate:2012-03-01
/// Input:执行表Rowid ,操作人员ID,操作人登录科室id
/// Return: 0 成功 , <0 失败
/// w ##class(web.DHCSTRETREQUEST).CreateDrugReqByXtime("615||21||1","10209","")
ClassMethod CreateDrugReqByXtime(ordexerowid, opuser, userloc = "") As %String
{
    n (ordexerowid,opuser,userloc)
    q:(##class(PHA.IP.COM.Method).IsReturnByExe(ordexerowid, userloc) = $$$YES) 0
    q:ordexerowid="" -100
    q:opuser="" -100

    s ord=+ordexerowid
    s itm=$p(ordexerowid,"||",2)
    s ore=$p(ordexerowid,"||",3)
    q:ord="" -1
    q:itm="" -1
    q:ore="" -1
    s orditem=ord_"||"_itm
    s dspid=$o(^DHCOEDISQTY(0,"OEORE",ordexerowid,""))
    q:dspid="" -2
    s dspcatcode=$p(^DHCOEDISQTY(dspid),"^",27)
    q:dspcatcode=0 0 //yunhaibao20161014
    s admdr=$p(^DHCOEDISQTY(dspid),"^",26)
    s AdmType=$p($g(^PAADM(admdr)),"^",2)
    q:AdmType'="I" 0                            ;过滤非住院病人 
    q:##class(web.DHCSTCOMMONSRV).GetOrdAutoReqFlag(dspid)'=1 0  //是否自动生成退药申请单配置
    s admdr=$p(^DHCOEDISQTY(dspid),"^",26)
    S visitstatus=##class(web.DHCSTCOMMONSRV).GetCurrentAdmStatus(admdr)    //20160310 标准版开发
    q:visitstatus=0 0
    s wardlocdr=$p(^DHCOEDISQTY(dspid),"^",22)    ;病区科室
    s wardId=$o(^PAWARD(0,"WARD_LocationDR",wardlocdr,""))
    s CurWardId=$p(^PAADM(admdr),"^",70)
    s beddr=""
    i wardId=CurWardId d
    .s beddr=$p(^PAADM(admdr),"^",73)   //zhouyg 20160510 取床号修改
    s orddept=$p(^OEORD(ord,"I",itm,1),"^",3)
    s prescno=$p(^OEORD(ord,"I",itm,1),"^",14)
    s doctorloc=$p($g(^OEORD(ord,"I",itm,7)),"^",2)  ;医生科室
    s stdate=$p(^DHCOEDISQTY(dspid),"^",21)        ;分发日期
    s status=$p(^DHCOEDISQTY(dspid),"^",7)          ;配药记录状态
    q:status'="C"  
    s OreStatusDr=$p(^OEORD(ord,"I",itm,"X",ore),"^",16)  ;护士执行状态
    q:OreStatusDr="" -11                            ;只有停止执行的记录可申请退药
    s AdminStatus=$p(^OEC("STAT",OreStatusDr),"^",1)  
    q:(AdminStatus'="D") -12        ;只有停止执行的记录可申请退药，&(AdminStatus'="C")
    s getpatnameid=$p(^PAADM(admdr),"^",1) 
    s tmpDspSubId=$o(^DHCOEDISQTY(dspid,"I",0))
    q:tmpDspSubId="" -13
    s tmpDodisBatch=dspid_"||"_tmpDspSubId
    s pha=$o(^DHCPHACi("DSPB",tmpDodisBatch,""))
    q:pha="" -14
    s chl=$o(^DHCPHACi("DSPB",tmpDodisBatch,pha,""))
    q:chl="" -15
    s phaloc=$p(^DHCPHAC(pha),"^",1)
    s patno=$p(^PAPER(getpatnameid,"PAT",1),"^",1) 
    s admloc=$p(^DHCPHAC(pha,"I",chl),"^",11)
    //s saleprice=$p(^DHCPHAC(pha,"I",chl),"^",9)
    s phaloc=$p(^DHCPHAC(pha),"^",1)   //发药科室
    s:phaloc'="" phalocDesc=$p(^CTLOC(phaloc),"^",2)
    s HospID=$p($g(^CTLOC(phaloc)),"^",22) 
    s reqflag="Prove"
    s config=##Class(web.DHCSTKUTIL).GetPhaConfig("Con_ReqWard") //是否只能填写本病区申请记录
    s specialflag=##class(web.DHCSTPCHCOLLS).DoctorLocRefuse(phaloc,doctorloc)
    i specialflag=1  d
    .s reqdept=doctorloc    ;如果是特殊科室，申请科室为医生科室
    e  d
    .s reqdept=wardlocdr    ;如果不是特殊科室，申请科室为病区科室
    .
    q:(config=1)&(userloc'="")&(userloc'=reqdept)     //只能填写本病区申请记录
    ;q:(reqdept'="")&(userlocdr'="")&($g(locrowid)'=userlocdr)&(config=1)   ;不是在当前病区领的药，不允许在此病区申请退药  
    s appParams=""_"^"_""_"^"_""_"^"_HospID
    // 合并规则  add by  zhaoxinlong 2022.04.13 
    s mergeRule=##class(web.DHCST.Common.AppCommon).GetAppPropValue("DHCSTPHARETREQ","MergeRule",appParams)
    s xdate=$p($h,",",1)
    s xtime=$p($h,",",2)
    s collstatus="C"   
    s reasondr=""
    s ret=0
    s reqstr=$$GetOldReqNo()   ;查找已经生成的请求单
    s reqno=$p(reqstr,"^",1)
    s reqid=$p(reqstr,"^",2)
    tstart
    s $ZT="Error^DHCSTERROR"                        ;增加错误处理
    i reqno="" d
    .s listdata=phaloc_"^"_getpatnameid_"^"_admdr_"^"_reqdept_"^"_beddr_"^"_opuser_"^"_wardlocdr
    .s reqid=..InsertReqMain(listdata)     ;新生成申请单
    i reqid="" trollback
    q:reqid="" -13          ;生成请求单失败
    /// 医嘱改造修改,按发药记录保存
    s errcode=0
    s dspSubId=""
    f  s dspSubId=$o(^DHCOEDISQTY(dspid,"I",dspSubId)) q:(dspSubId="")||(+errcode<0)  d
    .q:+dspSubId=0
    .s dspSubRowId= dspid_"||"_dspSubId
    .s phacId=""
    .f  s phacId=$o(^DHCPHACi("DSPB",dspSubRowId,phacId)) q:(phacId="")||(+errcode<0)  d
    ..s phacSubId=""
    ..f  s phacSubId=$o(^DHCPHACi("DSPB",dspSubRowId,phacId,phacSubId)) q:(phacSubId="")||(+errcode<0)  d
    ...s phacLbId=""
    ...f  s phacLbId=$o(^DHCPHACi("DSPB",dspSubRowId,phacId,phacSubId,phacLbId))  q:(phacLbId="")||(+errcode<0)  d
    ....q:+phacLbId=0
    ....s phacLbRowId=phacId_"||"_phacSubId_"||"_phacLbId
    ....s phacLbData=^DHCPHAC(phacId,"I",phacSubId,"B",phacLbId)
    ....s dspinclb=$p(phacLbData,"^",1)
    ....q:##class(web.DHCST.Common.DrugInfoCommon).GetCantRetReason(+dspinclb)'=""
    ....s retQty=$p(phacLbData,"^",2)           ;欲退药数量 
    ....s saleprice=$P(^DHCPHAC(phacId,"I",phacSubId,"B",phacLbId),"^",5)
    ....s amount=saleprice*retQty
    ....s retedQty=##class(web.DHCSTPHARETURN).ReturnedQtyByPhacLb(phacLbRowId) // 已退数量
    ....s avaQty=retQty-retedQty
    ....s reqedQty=..GetReqQtyByPhacLb(phacLbRowId)  // 已申请数量
    ....s canRetQty=avaQty-reqedQty-retQty
    ....i canRetQty<0 s errCode=-4 q     ;申请退药数量(已经申请数量+本次申请数量)大于可退数量，
    ....s listdetail=reqid_"^"_orditem_"^"_retQty_"^"_saleprice_"^"_opuser_"^"_stdate_"^"_reasondr_"^"_dspid_"^"_phacLbRowId_"^"_dspSubRowId_"^"_dspinclb
    ....s ret=..InsertDetail(listdetail)   ;保存请求明细
    ....i ret="" s errcode=-14 q
    i +errcode<0 trollback
    q:+errcode<0 +errCode
    // 如果申请单无明细,则删除
    d ##class(web.DHCINPHA.Request).UpdatePhaReqForItm(reqid)
    tcommit
    d ##class(PHA.IP.COM.Face).UpdateSystemStatus4PhaRequest(reqid, , opuser, userloc)
    q 0

GetOldReqNo()
     s reqno=""
     s phareq=""
     s reqid=""
     f  s phareq=$o(^RETRQ(0,"PAPMI",phaloc,getpatnameid,reqdept,phareq),-1) q:(phareq="")||(reqno'="")  d
     .s reqstatus=$p(^RETRQ(phareq),"^",14)
     .q:reqstatus'=reqflag
     .s priadmdr=$p(^RETRQ(phareq),"^",5)
     .q:admdr'=priadmdr                    //判断是否为同一次就诊
     .s reqdate=$p(^RETRQ(phareq),"^",16)
     .q:reqdate'=+$h                      //一天一张退药申请
     .s reqopuser=$p(^RETRQ(phareq),"^",15) // 申请人不同,区分退药申请
     .q:reqopuser'=opuser
     .s printFlag = $p(^RETRQ(phareq),"^",27) 
     .s no=$p(^RETRQ(phareq),"^",1)
     .s retstatus = ##class(web.DHCSTPHARETURN2).GetRetrqStatus(no) 
     .q:(mergeRule = "1")&&(printFlag = "Y") 
     .q:(mergeRule = "2")&&(retstatus = "1")
     .q:(mergeRule = "3")&&(retstatus = "1")&&(printFlag = "Y")
     .s reqno = no
     .s reqid=phareq
     q reqno_"^"_reqid
}

/// Description：查找某配药记录已经申请的退药数量
/// Creator:zdm
/// CreateDate:2012-03-14
/// Input:配药表Rowid
/// Return: 已申请的退药数量
ClassMethod GetReqQtyByDodis(dodis As %String) As %String
{
    n (dodis)
    ;计算已经申请尚未退的数量 
    q:dodis="" 0
    s reqtotalqty=0   
    s phareq=""
    f  s phareq=$o(^RETRQ(0,"DODIS",dodis,phareq)) q:phareq=""  d
    .s chl=""
    .f  s chl=$o(^RETRQ(0,"DODIS",dodis,phareq,chl)) q:chl=""  d
    ..s reqstatus=$p(^RETRQ(phareq,"I",chl),"^",10)
    ..q:reqstatus'="Prove"
    ..s reqitmqty=$p(^RETRQ(phareq,"I",chl),"^",3)
    ..s reqitmID=phareq_"||"_chl
    ..s reqRetedQty=##Class(web.DHCSTPHARETURN).GetReqReturnedQtyByPhaRet(reqitmID)
    ..s AvailQty=reqitmqty-reqRetedQty  //20120601 zhouyg
    ..q:AvailQty'>0
    ..s reqtotalqty=reqtotalqty+AvailQty
    q reqtotalqty
}

/// Description：判断某配药记录是否已经退药
/// Creator:zdm
/// CreateDate:2012-03-14
/// Input:配药表Rowid
/// Return: 1：已退；0：存在未退申请;
ClassMethod GetReturnFlag(ordexeid As %String) As %String
{
    n (ordexeid)
    ;计算已经申请尚未退的数量 
    q:ordexeid="" ""
    s dodis=$o(^DHCOEDISQTY(0,"OEORE",ordexeid,""))
    q:dodis="" ""
    s dspqty=$p(^DHCOEDISQTY(dodis),"^",11)
    s retflag=1  
    s phareq=""
    f  s phareq=$o(^RETRQ(0,"DODIS",dodis,phareq)) q:phareq=""  d
    .s chl=""
    .f  s chl=$o(^RETRQ(0,"DODIS",dodis,phareq,chl)) q:chl=""  d
    ..s reqstatus=$p(^RETRQ(phareq,"I",chl),"^",10)
    ..q:reqstatus'="Prove"     ;已退或拒绝退药
    ..
    ..
    ..s retflag=0
    .
    q retflag
}

ClassMethod GetRetRedQty(rowid As %String, qty As %String) As %String
{
 n (rowid, qty)
 q:rowid="" -1
 s retqty=0
 s delqty=0
 s strlen=$l(rowid,"#")
 f i=1:1:strlen d
 .s reqid=$p(rowid,"#",i) 
 .s chl=$p(reqid,"||",2)
 .q:chl=""
 .s retflag=$p(^RETRQ(+reqid,"I",chl),"^",10)
 .;q:retflag'="Prove"
 .s retqty=retqty+$p(^RETRQ(+reqid,"I",chl),"^",3)
 s delqty=retqty-qty
 q delqty
}

/// 更新数量前检查数据,只要有改变过状态的就不允许修改，只有出院带药、取药医嘱可以修改数量
/// Creator:LiangQiang
/// CreatDate:2014-01-18
/// Input:申请明细id串
/// Output: 0 - 允许  1、2、3 - 不允许
ClassMethod CheckBeforeUpdQty(retrqstr As %String)
{
    n (retrqstr)
    s ret=0
    s strlen=$l(retrqstr,"#")
    f i=1:1:strlen q:(ret'=0)  d
    .s reqid=$p(retrqstr,"#",i)
    .s oneflag=##class(web.DHCSTCOMMONSRV).ChkIfONEbyReq(reqid)
    .//i oneflag=1 d
    .//zhouyg 20141215
    .i oneflag'=1 d
    ..s ret=1   //出院带药或取药医嘱
    .q:ret'=0
    .s RefundStatus=$p(^RETRQ(+reqid,"I",$p(reqid,"||",2)),"^",12)
    .i RefundStatus=1 d
    ..s ret=2   //已申请退费
    .q:ret'=0
    .s reqstatus=$p(^RETRQ(+reqid,"I",$p(reqid,"||",2)),"^",10)
    .i reqstatus'="Prove" d
    ..s ret=3   //已申请退药
    .q:ret'=0
    .//
    .s dodis=$p(^RETRQ(+reqid,"I",$p(reqid,"||",2)),"^",11)
    .q:dodis=""
    .s PartFlag=##Class(web.DHCSTPHARETURN2).GetRetPartFlag(dodis)
    .i PartFlag'=1 d
    ..s ret=4
    q ret
}

/// creator:yunhaibao
/// createdate:20160531
/// description:判断两张申请单对应病区是否相同
/// return:1相同,其他不相同
/// w ##class(web.DHCSTRETREQUEST).CompareWardByReq("^")
ClassMethod CompareWardByReq(reqno, reqstr)
{
    s diffflag=1
    q:reqstr="" 1
    q:reqno="" 1
    q:'$d(^RETRQ(0,"RETRQNO",reqno)) ""
    s mainreqrowid=$o(^RETRQ(0,"RETRQNO",reqno,""))
    s mainreqward=$p(^RETRQ(mainreqrowid),"^",7)
    s reqlength=$l(reqstr,"^")
    f reqi=1:1:reqlength q:diffflag=0  d
    .s reqrowid=+$p(reqstr,"^",reqi)
    .q:reqrowid="0"
    .s reqward=$p(^RETRQ(reqrowid),"^",7)
    .i (reqward'=mainreqward) s diffflag=0
    q diffflag
}

/// Author : MaYuqiang
/// CreateDate : 20171222
/// Description : 根据打包表id获取该药品是否能建退药申请单
/// Input : dspid - 打包表id
/// Output : 1 - 允许退药 , 0 - 不允许
/// w ##class(web.DHCSTRETREQUEST).GetRequestFlagbyDsp(36157)
ClassMethod GetRequestFlagbyDsp(dspid) As %String
{
    n (dspid)
    q:+dspid=0 0
    q:'$d(^DHCOEDISQTY(dspid)) 0
    s dspData=^DHCOEDISQTY(dspid) 
    s adm=$p(dspData,"^",26)
    q:($p(^PAADM(adm),"^",2)'="I") 1
    s sdgcode=$p(dspData,"^",27)    //发药类别代码
    q:sdgcode="" 0
    s sdgcode=$$ALPHAUP^SSUTIL4(sdgcode)
    s reclocid=$p(dspData,"^",24)
    q:reclocid="" 0
    q:sdgcode=0 1   // 静配不区分发药类别
    s sdgr=$o(^DHCSTDRUGGRP(0,"Code",sdgcode,"")) 
    q:(sdgr="")&&(sdgcode="QT") "1"
    q:sdgr="" "0"
    s impermitreqflag=##class(web.DHCSTCOMMONSRV).ChkReqFlagbyPhaCat("",sdgr,reclocid)  //MaYuqiang 按照科室和发药类别判断禁止能建配药申请单标记
    q:impermitreqflag=0 0
    q 1
}

/// w ##class(web.DHCSTRETREQUEST).NewPid()
ClassMethod NewPid()
{
 q ##class(web.DHCSTKUTIL).NewPid($this,"IP")
}

/// Description：根据发药批次id获取对应批次已申请未退数量
/// Creator:     yunhaibao
/// CreateDate:  2017-09-07
/// Input:       打包批次表ID\发药孙表ID
/// Return:      已申请未退数量
/// w ##class(web.DHCSTRETREQUEST).GetReqQtyByPhacLb("7956||12||1")
ClassMethod GetReqQtyByPhacLb(phacLbRowId As %String) As %String
{
    n (phacLbRowId)
    q:+phacLbRowId=0 0
    s phacId=+phacLbRowId
    s phacSubId=+$p(phacLbRowId,"||",2)
    s phacLbId=+$p(phacLbRowId,"||",3)
    q:(phacId=0)||(phacSubId=0)||(phacLbId=0) 0
    s dodisBatch=$p(^DHCPHAC(phacId,"I",phacSubId,"B",phacLbId),"^",7)
    s reqTotalQty=0
    s phaReqId=""
    f  s phaReqId=$o(^RETRQ(0,"DSPB",dodisBatch,phaReqId)) q:phaReqId=""  d
    .s phaReqSubId=""
    .f  s phaReqSubId=$o(^RETRQ(0,"DSPB",dodisBatch,phaReqId,phaReqSubId)) q:phaReqSubId=""  d
    ..q:+phaReqSubId=0
    ..s phaReqStatus=$p(^RETRQ(phaReqId,"I",phaReqSubId),"^",10)
    ..q:phaReqStatus'="Prove"
    ..s phaReqPhacLb=$p(^RETRQ(phaReqId,"I",phaReqSubId),"^",15)
    ..q:phacLbRowId'=phaReqPhacLb
    ..s phaReqQty=$p(^RETRQ(phaReqId,"I",phaReqSubId),"^",3)
    ..s phaReqRetQty=##Class(web.DHCSTPHARETURN).GetReqReturnedQtyByPhaRet(phaReqId_"||"_phaReqSubId)
    ..s phaReqAvaQty=phaReqQty-phaReqRetQty
    ..q:phaReqAvaQty'>0
    ..s reqTotalQty=reqTotalQty+phaReqAvaQty
    q reqTotalQty
}

/// Description: 更新打包标记
/// Author:      zhaoxinlong 2022.04.11
/// Input:       reqIdStr -- 请求表ID串
/// Return：  0 -- 成功
/// w ##class(web.DHCSTRETREQUEST).updatePrintFlag("1,2")
ClassMethod updatePrintFlag(reqIdStr) As %String
{
    q:(reqIdStr = "") ""
    s ret = 0
    for i = 1 :1 :$l(reqIdStr,","){
        s reqId = $p(reqIdStr, ",", i)
        continue:(+reqId = 0)   
        continue:'$d(^RETRQ(reqId))
        &sql(
            update SQLUser.DHC_PhaRetRequest set RETRQ_PrintFlag = 'Y' 
            where  RETRQ_Rowid = :reqId
        )
        if (SQLCODE '= 0) {
            s ret = SQLCODE _ %msg  
        }
    }
    
    q ret
}

}
