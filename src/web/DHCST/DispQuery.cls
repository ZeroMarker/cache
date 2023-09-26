Import sqluser

/// Descript:综合查询统计
/// Creater:	ZhangDongmei
/// CreateDate:	2012-08-06
Class web.DHCST.DispQuery Extends (%RegisteredObject, StkTypeG) [ Not ProcedureBlock ]
{

Parameter AppName [ Final ] = "DHCSTDISPQUERY";

/// Descript:取库存查询界面参数配置属性
/// Creater:    ZhangDongmei
/// CreateDate: 2012-09-19
/// Table:
/// Input:安全组id,科室id,用户id
/// Output:     
/// Return：台帐信息^全院在途数清除^科室在途数清除^科室单品在途数清除^科室库存同步^科室单品库存同步
ClassMethod GetParamProp(GroupId As %String, LocId As %String, UserId As %String) As %Library.String
{
    n (GroupId,LocId,UserId)
    ;s ^zdm("GetParamProp")=GroupId_"^"_LocId_"^"_UserId
    s:LocId'="" HospId=$p(^CTLOC(LocId),"^",22)
    s Param=GroupId_"^"_LocId_"^"_UserId_"^"_$g(HospId)
    s AppName=##class(web.DHCST.DispQuery).%GetParameter("AppName")
    s TransShow=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"TransShow",Param)
    s ClrResQtyAllShow=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"ClrResQtyAllShow",Param)
    s ClrResQtyLocShow=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"ClrResQtyLocShow",Param)
    s ClrResQtyLocInciShow=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"ClrResQtyLocInciShow",Param)
    s SynInciLocShow=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"SynInciLocShow",Param)
    s SynInciLocInciShow=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"SynInciLocInciShow",Param)
    
    s Data1=TransShow_"^"_ClrResQtyAllShow_"^"_ClrResQtyLocShow_"^"_ClrResQtyLocInciShow_"^"_SynInciLocShow_"^"_SynInciLocInciShow
    //s Data2=MarginWarning_"^"_AllowInputRpAmt_"^"_PurchaserNotNull_"^"_ImpTypeNotNull_"^"_ValidateMaxSp_"^"_DefaStartDate_"^"_DefaEndDate
    q Data1
}

/// 发药统计查询
/// Author:wyx
/// Date:2014-06-04
/// Argu:
/// Input:StrParam=开始日期^结束日期^发药科室^病区^发药人^发药类别^药学分类^药品名称^就诊科室^
///       出院带药标记^仅医生科室标记^开始时间^结束时间^医生科室^包含退药标记
///  
/// D ##class(%ResultSet).RunQuery("web.DHCST.DispQuery","DispQuerySave","") 
Query DispQuerySave(StrParam As %String) As %Query(ROWSPEC = "pid,incicode,incidesc,uomdesc,qty:%Float,money:%Float") [ SqlProc ]
{
}

ClassMethod DispQuerySaveExecute(ByRef qHandle As %Binary, StrParam As %String) As %Status
{
  n (qHandle,StrParam)
  //datef,datet,pha,ward,user,type,phacat,desc,admloc,str
  s repid=$I(^CacheTemp)
  s ind=1
  s qHandle=$lb(0,repid,0)
  s pid=..NewPid()
 k ^TMP("DHCST","DISPQUERY","INCI",pid)
 k ^TMP("DHCST","DISPQUERY","INCITOTAL",pid)
 s m=0 
 //sDate+"^"+eDate+"^"+dispLoc+"^"+locWard+"^"+locDispUser+"^"+dispType+"^"+phcCat+"^"+inci+"^"+exeLoc+"^"+outflag+"^"+docFlag+"^"+sTime+"^"+eTime+"^"+docLoc+"^"+retFlag
 s datef=$p(StrParam,"^",1) //开始日期
 s datet=$p(StrParam,"^",2) //结束日期
 s pha=$p(StrParam,"^",3)  //发药科室
 s ward=$p(StrParam,"^",4) //病区
 s user=$p(StrParam,"^",5) //发药人
 s type=$p(StrParam,"^",6) //发药类别
 s phacatid=$p(StrParam,"^",7) //药学分类
 s specinci=$p(StrParam,"^",8) //药品id
 s admloc=$p(StrParam,"^",9) //就诊科室
 s catflag=$p(StrParam,"^",10) //出院带药标记
 s docflag=$p(StrParam,"^",11) //仅医生科室标记
 s tfrom=$p(StrParam,"^",12) //开始时间
 s tend=$p(StrParam,"^",13)  //结束时间
 s dlocdesc=$p(StrParam,"^",14) //医生科室
 s retflag=$p(StrParam,"^",15) //包含退药标记
 s PhcCatAll=$p(StrParam,"^",16) //多级药学分类
 
 i $g(tfrom)="" s tfrom=$zth("00:00:00",3) 
 ;e  s tfrom=$zth($p(tfrom," ",2),3)
 e  s tfrom=$zth(tfrom,3)
 i $g(tend)="" s tend=$zth("23:59:59",3)
 ;e  s tend=$zth($p(tend," ",2),3)
 e  s tend=$zth(tend,3)
 s datef=$ZDH(datef,3)
 s datet=$ZDH(datet,3)
 s pha=$g(pha),ward=$g(ward),user=$g(user),type=$g(type)
 //i pha'="" s pha=$o(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(pha),"")) q:pha="" -1
 //i ward'="" s ward=$o(^PAWARD(0,"WARD_Desc",$$ALPHAUP^SSUTIL4(ward),"")) q:ward="" -2
 //i user'="" s user=$o(^SSU("SSUSR",0,"SSUSR_Name",$$ALPHAUP^SSUTIL4(user),"")) q:user="" -3 
 //i admloc'="" s admloc=$o(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(admloc),"")) q:admloc="" -4    
 ;
 //s specinci="",phacatid=""
 //i desc'="" s specinci=$$ItemDescToID^DHCSTCOMMONSRV(desc) 直接传id
 //i phacat'="" s phacatid=$$PhaCatID(phacat) 直接传id
 ;  
 f date=datef:1:datet d
 .s phacid="" f  s phacid=$o(^DHCPHAC(0,"PHP",pha,"DATE",date,phacid)) q:phacid=""  d
 ..s collward=$p(^DHCPHAC(phacid),"^",4) 
 ..s colluser=$p(^DHCPHAC(phacid),"^",5)
 ..s colltype=$p(^DHCPHAC(phacid),"^",12)
 ..s colltime=$p(^DHCPHAC(phacid),"^",3)
 ..i ward'="" q:collward'=ward
 ..i type'="" q:colltype'=type
 ..i user'="" q:colluser'=user
 ..i docflag=1 q:collward'=""  ;仅医生科室  lq 2008-02-09
 ..q:(date=datef)&(colltime<tfrom) ;过滤掉时间  lq 2008-02-09
 ..q:(date=datet)&(colltime>tend)
 ..d GetData(phacid,phacatid,specinci,admloc,.m,catflag,dlocdesc,pid)
 i retflag=1 d GetRetData(datef,datet,phacatid,specinci,admloc,catflag,dlocdesc,pha,tfrom,tend,ward,pid)
 s incicode=0
 f  s incicode=$o(^TMP("DHCST","DISPQUERY","INCITOTAL",pid,incicode)) q:incicode=""  d
 .s incidesc=$p(^TMP("DHCST","DISPQUERY","INCITOTAL",pid,incicode),"^",1)
 .s uomdesc=$p(^TMP("DHCST","DISPQUERY","INCITOTAL",pid,incicode),"^",2)
 .s qty=$p(^TMP("DHCST","DISPQUERY","INCITOTAL",pid,incicode),"^",3)
 .s money=$p(^TMP("DHCST","DISPQUERY","INCITOTAL",pid,incicode),"^",4)
 .d OutPurRow
 .
 k ^TMP("DHCST","DISPQUERY","INCITOTAL",pid)
 Quit $$$OK 


GetData(phacdr,phacatid,specinci,admloc,num,catflag,dlocdesc,pid)
 i '$d(^DHCPHAC(phacdr)) q 0
 s inci=""
 s Perv=""
 s phaci="" f  s phaci=$o(^DHCPHAC(phacdr,"I",phaci)) q:phaci=""  d
 .s adm=$p(^DHCPHAC(phacdr,"I",phaci),"^",3)
 .s lbch=$o(^DHCPHAC(phacdr,"I",phaci,"B",""))
 .s inclbdr=$p(^DHCPHAC(phacdr,"I",phaci,"B",lbch),"^",1) 
 .s oedis=$p(^DHCPHAC(phacdr,"I",phaci),"^",7)   
 .s phcistatus=$p(^DHCPHAC(phacdr,"I",phaci),"^",10)
 .;q:phcistatus="D" 
 .
 .s disdate=$P(^DHCPHAC(phacdr),"^",2)    ; Dispensing Date  
 .i disdate'="" s disdate=$zd(disdate,3)
 .s distime=$P(^DHCPHAC(phacdr),"^",3) ; dispensing time
 .i distime'="" s distime=$zt(distime)
 .s disdatetime=disdate_" "_distime
 .;
 .s tmpadmloc=$p(^DHCPHAC(phacdr,"I",phaci),"^",11)   
 .q:(admloc'="")&(admloc'=tmpadmloc)                     ; not for the adm loc
 .s inci=$p(inclbdr,"||",1)                                                    ;INCI_RowId
 .q:(specinci'="")&(inci'=specinci)
 .;
 .s doclocid=..DocLoc(phacdr)
 .s docloc=$P(^CTLOC(+doclocid),"^",2)
 .i dlocdesc'="" q:dlocdesc'=docloc ;过滤医生科室
 .s incicode=$p(^INCI(inci,1),"^",1) s incidesc=$p(^INCI(inci,1),"^",2)
 .s incil=$p(inclbdr,"||",2)                                                   ;INCIL_ChildSub
 .s inclb=$p(inclbdr,"||",3)                                                   ;INCLB_ChildSub
 .s incibdr=$p(^INCI(inci,"IL",incil,"LB",inclb),"^",1)                        ;INCIB_RowId
 .s incib=$p(incibdr,"||",2)                                                   ;INCIB_ChildSub   
 .s batchno=$p(^INCI(inci,"IB",incib),"^",1)
 .s ord=$p(oedis,"||",1)                                                       ;OEORD_RowId                                                                      
 .s chl=$p(oedis,"||",2)                                                       ;OEORI_ChildSub
 .i '$d(^OEORD(ord,"I",chl)) q  
 .;
 .s orddate=$p(^OEORD(ord,"I",chl,3),"^",7)
 .i orddate'="" s orddate=$zd(orddate,3)
 .s ordtime=$p(^OEORD(ord,"I",chl,1),"^",17)
 .i ordtime'="" s ordtime=$zt(ordtime)
 .s orditmdatetime=orddate_" "_ordtime     ;orditmdatetime
 .s priority=..GetOrdPriority(ord,chl)                                         ;医嘱优先级类型
 .;q:(catflag="N")&(priority="出院带药")
 .;q:(catflag="Y")&(priority'="出院带药")
 .s arcimid=$p(^OEORD(ord,"I",chl,1),"^",2)                                    ;ARCIM_RowId 
 .s arcimdesc=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)            ;医嘱名称
 .q:(phacatid'="")&(phacatid'=..PhaCatByArcim(arcimid))
 .
 .s PhaCatAllDesc=""
 .s PhaCatAllstr=##class(web.DHCST.Common.DrugInfoCommon).GetPhaCatAll(inci)
 .s PhaCatAlls=$p(PhaCatAllstr,"^",1)
 .s PhaCatAllDesc=$p(PhaCatAllstr,"^",2)
 .s retflag=##class(web.DHCST.Common.DrugInfoCommon).CheckNewCatId(PhcCatAll,PhaCatAlls)
 .q:(PhcCatAll'="")&(retflag=0) //add wyx 2014-12-08 药学多级分类
 .//q:(PhcCatAll'="")&(PhaCatAlls'=PhcCatAll) //add wyx 2014-12-08 药学多级分类
 .
 .s patnameid=$p(^PAADM(adm),"^",1)                                            ;PA_PatMas PAPMI_RowId
 .s patname=$p(^PAPER(patnameid,"ALL"),"^",1)
 .s bed=$p(^DHCPHAC(phacdr,"I",phaci),"^",8)
 .s patno=$p(^PAPER(patnameid,"PAT",1),"^",1)
 .s deplocid=$p(^DHCPHAC(phacdr,"I",phaci),"^",11) s deploc=$p(^CTLOC(deplocid),"^",2)
 .i $f(deploc,"-")  s deploc=$p(deploc,"-",2)
 .s prescno=$p(^DHCPHAC(phacdr,"I",phaci),"^",5)
 .s pakuom=$p(^CT("UOM",$p(^INCI(inci,1),"^",10)),"^",2)
 .s qty=$p(^DHCPHAC(phacdr,"I",phaci),"^",6)           ;qty数量
 .s price=$p(^DHCPHAC(phacdr,"I",phaci),"^",9)         ;price价格
 .//s money=$fn(qty*price,"",4)							;money金额
 .s money=qty*price
 .s lbchdr=""
 .s intramtsum=0
 .f  s lbchdr=$o(^DHCPHAC(phacdr,"I",phaci,"B",lbchdr)) q:lbchdr=""  d //取业务表金额 wyx 2013-09-18
 ..s pointer=phacdr_"||"_phaci_"||"_lbchdr
 ..s intr=$o(^DHCINTR(0,"TypePointer","P",pointer,"")) 
 ..q:intr=""
 ..s intramt=$p(^DHCINTR(intr),"^",8)
 ..s intramtsum=intramtsum+intramt
 .i intramtsum'=0 s money=(-1)*intramtsum
 .
 .i Perv="" d
 ..s locID=..LOC(inclbdr)
 ..s CustStr=##Class(web.DHCSTCOMMO).GetLocCust(locID)
 ..s CustID=$p(CustStr,"^",1)
 ..S CatGrpStr=##Class(web.DHCSTCOMINC).GetIncStkCatGrp(+inclb)
 ..S StkTypeDesc=$P(CatGrpStr,"^",4)
 ..S Perv="^^^"_StkTypeDesc_"^"_$G(CustID)_"^DHC"
 .;s money=$$GetNumbDec^DHCSTCOMMPARA(money,Perv,"FmtSA",1)     ;BIANSHUAI  不用
 .i $p(^OEORD(ord,"I",chl,2),"^",4)'="" s freq=$p(^PHCFR($p(^OEORD(ord,"I",chl,2),"^",4)),"^",1)       ;freq用药频率
 .i $p(^OEORD(ord,"I",chl,2),"^",6)'="" s dura=$p(^PHCDU($p(^OEORD(ord,"I",chl,2),"^",6)),"^",1)   ;dura用药疗程
 .i $p(^OEORD(ord,"I",chl,2),"^",3)'="" s dosageuom=$p(^CT("UOM",$p(^OEORD(ord,"I",chl,2),"^",3)),"^",2)   ;dosageuom剂量单位
 .s dosage=$p(^OEORD(ord,"I",chl,2),"^",1)            ;dosage用药剂量
 .;2007-03-27 add data detecting - following ...
 .s phcdfid=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",12) ;PHC_DrgForm Rowid
 .s phcfid="" 
 .i phcdfid'="" s phcfid=$p($g(^PHCD($p(phcdfid,"||",1),"DF",$p(phcdfid,"||",2),1)),"^",1) ;PHC_Form Rowid
 .s form=""
 .i phcfid'="" s form=$p($g(^PHCF(phcfid)),"^",2)                                 ;form剂型
 .;2007-03-27 add data detecting - above ...
 .s num=num+1
 .;s ^DHCSTDISPSAVE(pid,num)=patno_"!"_patname_"!"_bed_"!"_deploc_"!"_prescno_"!"_incicode_"!"_incidesc_"!"_dosage_dosageuom_"!"_form_"!"_pakuom_"!"_price_"!"_qty_"!"_money
 .s ^TMP("DHCST","DISPQUERY","INCI",pid,incicode,num)=patno_"^"_patname_"^"_bed_"^"_deploc_"^"_prescno_"^"_incicode_"^"_incidesc_"^"_dosage_dosageuom_"^"_form_"^"_pakuom_"^"_price_"^"_qty_"^"_money_"^"_disdatetime_"^"_orditmdatetime_"^"_$p(docloc,"-",2)
 .
 .i '$d(^TMP("DHCST","DISPQUERY","INCITOTAL",pid,incicode)) d
 .. s ^TMP("DHCST","DISPQUERY","INCITOTAL",pid,incicode)=incidesc_"^"_pakuom_"^"_qty_"^"_money
 .e  d
 .. s $p(^TMP("DHCST","DISPQUERY","INCITOTAL",pid,incicode),"^",3)=$p(^TMP("DHCST","DISPQUERY","INCITOTAL",pid,incicode),"^",3)+qty
 .. s $p(^TMP("DHCST","DISPQUERY","INCITOTAL",pid,incicode),"^",4)=$p(^TMP("DHCST","DISPQUERY","INCITOTAL",pid,incicode),"^",4)+money

GetRetData(datef,datet,phacatid,specinci,admloc,catflag,dlocdesc,pha,tfrom,tend,ward,pid)
    N (datef,datet,phacatid,specinci,admloc,catflag,dlocdesc,pha,tfrom,tend,ward,pid)
	//S ItmID=""
 	//I ItmDesc'="" S ItmID=$$ItemDescToID^DHCSTCOMMONSRV(ItmDesc)
    ;统计退药
    
    s phciqty=0
    s cost=0
    s Perv=""
    s num=0
    f date=datef:1:datet d
    .;s retdr=0 f  s retdr=$o(^PHARET(0,"DATE",date,retdr)) q:retdr=""  d
    .s intr=""
    .F  S intr=$O(^DHCINTR(0,"TypeDate","Y",date,intr)) Q:intr=""  D
    ..S ret=$P(^DHCINTR(intr),"^",9)	//pointer -退药批次表RowID
    ..S retDate=$P(^DHCINTR(intr),"^",2)
    ..S retTime=$P(^DHCINTR(intr),"^",3)
    ..q:(date=datef)&&(retTime<tfrom)
    ..q:(date=datet)&&(retTime>tend)
    ..s retinclb=$P(^DHCINTR(intr),"^",7)
    ..i retDate'="" s retDate=$zd(retDate,3)
    ..i retTime'="" s retTime=$zt(retTime)
    ..s retDaTime=retDate_" "_retTime
    ..Q:ret=""
    ..s retchl=$p(ret,"||",2)
    ..s retil=$p(ret,"||",3)
    ..s retdr=+ret
    ..Q:'$D(^PHARET(retdr))
    ..s retrecloc=$p(^PHARET(retdr),"^",5)
    ..s retward=$p(^PHARET(retdr),"^",6)
    ..s wordlocdr=""
    ..i ward'="" s wordlocdr=$p(^PAWARD(ward),"^",5)
    ..q:(retward'="")&(wordlocdr'="")&(wordlocdr'=retward)
    ..q:(pha'="")&(pha'=retrecloc)                     ; not for the adm loc      
    ..s oedis=$p(^PHARET(retdr,"I",retchl),"^",1)                             ;药房   
    ..s adm=$p(^PHARET(retdr,"I",retchl),"^",8)  
    ..s patnameid=$p(^PAADM(adm),"^",1)                                            ;PA_PatMas PAPMI_RowId
    ..s patname=$p(^PAPER(patnameid,"ALL"),"^",1)
    ..s bed=$p($p(^PHARET(retdr,"I",retchl),"^",10),"||",2)
    ..s patno=$p(^PAPER(patnameid,"PAT",1),"^",1) 
    ..s deplocid=$p(^PHARET(retdr,"I",retchl),"^",9) s deploc=$p(^CTLOC(deplocid),"^",2)
    ..i $f(deploc,"-")  s deploc=$p(deploc,"-",2)
    ..q:(admloc'="")&&(deplocid'=admloc)
    ..//s retward=$p(^PHARET(retdr),"^",9)
    ..;s retpt=$p(^PHARET(retdr),"^",5) ;oe_dispensingdr
    ..s rord=$p(oedis,"||",1),rchl=$p(oedis,"||",2)
    ..//s retinclb=$p(^PHARET(retdr),"^",6)
    ..s rinci=$p(^PHARET(retdr,"I",retchl),"^",11) 
	..q:rinci=""
    ..;S rincil=$p(retinclb,"||",2)
    ..;S rinclb=$p(retinclb,"||",3)
    ..Q:(specinci'="")&(specinci'=rinci)
    ..s incicode=$p(^INCI(rinci,1),"^",1) s incidesc=$p(^INCI(rinci,1),"^",2)
    ..S tmpcatstr=""
    ..s tmpcatstr=##class(web.DHCST.Common.DrugInfoCommon).GetDrugPhcCat(rinci)
    ..s tmpcat=$p($g(tmpcatstr),"^",1)
    ..s tmpsubcat=$p($g(tmpcatstr),"^",2)
    ..s tmpmincat=$p($g(tmpcatstr),"^",3)
    ..;--------
    ..s retstkcat=$p(^INCI(rinci,2),"^",2) q:retstkcat=""
    ..s retgrp=$o(^DHCSCG("STKCAT",retstkcat,"")) q:retgrp=""
    ..s retgrpdesc=$p(^DHCSCG(retgrp),"^",2)
    ..//q:(grptype'="")&(retgrpdesc'=grptype)
    ..s retstkcatdesc=$p(^INC("SC",retstkcat),"^",2)
    ..s pakuom=$p(^CT("UOM",$p(^INCI(rinci,1),"^",10)),"^",2)
    ..;s retqty=$p(^PHARET(retdr),"^",12)
    ..s retarcim=$p(^OEORD(rord,"I",rchl,1),"^",2)
    ..s retsttdate=$p(^OEORD(rord,"I",rchl,1),"^",9)
    ..s dosage=$p(^OEORD(rord,"I",rchl,2),"^",1)            ;dosage用药剂量
    ..i $p(^OEORD(rord,"I",rchl,2),"^",3)'="" s dosageuom=$p(^CT("UOM",$p(^OEORD(rord,"I",rchl,2),"^",3)),"^",2)   ;dosageuom剂量单位
    ..s arcimid=$p(^OEORD(rord,"I",rchl,1),"^",2)                                    ;ARCIM_RowId 
    ..q:(phacatid'="")&(phacatid'=..PhaCatByArcim(arcimid))
    ..s arcimdesc=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)            ;医嘱名称
    ..s phcdfid=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",12) ;PHC_DrgForm Rowid
    ..s phcfid="" 
    ..i phcdfid'="" s phcfid=$p($g(^PHCD($p(phcdfid,"||",1),"DF",$p(phcdfid,"||",2),1)),"^",1) ;PHC_Form Rowid
    ..s form=""
    ..i phcfid'="" s form=$p($g(^PHCF(phcfid)),"^",2)                                 ;form剂型
    ..
    ..s orddate=$p(^OEORD(rord,"I",rchl,3),"^",7)
    ..i orddate'="" s orddate=$zd(orddate,3)
    ..s ordtime=$p(^OEORD(rord,"I",rchl,1),"^",17)
    ..i ordtime'="" s ordtime=$zt(ordtime)
    ..s orditmdatetime=orddate_" "_ordtime     ;orditmdatetime
    ..s useradddept=$p($g(^OEORD(rord,"I",rchl,7)),"^",2)   ;060725
    ..s docloc=""
    ..i useradddept'="" s docloc=$P(^CTLOC(+useradddept),"^",2)
    ..i dlocdesc'="" q:dlocdesc'=docloc ;过滤医生科室
    ..
    ..s prescno=$p(^OEORD(rord,"I",rchl,1),"^",14)
    ..s rettype=$p(^ARCIM($p(retarcim,"||",1),$p(retarcim,"||",2),1),"^",10)
    ..s rettypecode=$p(^ARC("IC",rettype),"^",1)
    ..s retdrugstye=##Class(web.DHCSTPCHCOLLS).GetCat(rettype)
    ..//i (drugstye'="")&(retdrugstye'=drugstye) q                                             ;药品类别
    ..s priority=..GetOrdPriority(+oedis,$p(oedis,"||",2))
    ..;q:(catflag="N")&(priority="出院带药")
    ..;q:(catflag="Y")&(priority'="出院带药")
    ..;s retcost=$p(^PHARET(retdr),"^",14)
    ..s sprice=$p(^PHARET(retdr,"I",retchl),"^",4)  ;price价格
	..s sprice=$fn(sprice,"",4)
	..s retqty=+$p(^PHARET(retdr,"I",retchl,"B",retil),"^",2)     ;qty数量
	..s retqty=(-1)*retqty
	..s retcost=retqty*sprice //总金额
	..s intramt=""
	..s intramt=$P(^DHCINTR(intr),"^",8)
    ..s retcost=(-1)*intramt
    ..
    ..//s retcost=$fn(retcost,"",4)
    ..//S rp=$$LastInPrice^DHCSTPRICE(retinclb,"")
    ..//S rp=##class(web.DHCSTPRICE).LastInPrice(retinclb,"")
    ..//zhouyg 20141208
 	..s rp=$P(^DHCINTR(intr),"^",16)
 	..s rpamt=$P(^DHCINTR(intr),"^",17)
 	..i +rp=0 d
 	...s HospID=$p(^CTLOC(retrecloc),"^",22)
 	...s rp=##Class(web.DHCSTPRICE).GetRp(retinclb,date,"",HospID,"")	
 	...S rpamt=-retqty*rp
    ..s retward=$p(^PHARET(retdr),"^",6 ) ;按病区
    ..;各种药的退药总数量和退药总金额             
    ..s num=$o(^TMP("DHCST","DISPQUERY","INCI",pid,incicode,""),-1)
    ..i num'="" s num=num+1
    ..e  s num=1
    ..s ^TMP("DHCST","DISPQUERY","INCI",pid,incicode,num)=patno_"^"_patname_"^"_bed_"^"_deploc_"^"_prescno_"^"_incicode_"^"_incidesc_"^"_dosage_dosageuom_"^"_form_"^"_pakuom_"^"_sprice_"^"_retqty_"^"_retcost_"^"_retDaTime_"^"_orditmdatetime_"^"_$p(docloc,"-",2)
    ..i '$d(^TMP("DHCST","DISPQUERY","INCITOTAL",pid,incicode)) d
    ... s ^TMP("DHCST","DISPQUERY","INCITOTAL",pid,incicode)=incidesc_"^"_pakuom_"^"_retqty_"^"_retcost
    ..e  d
    ... s $p(^TMP("DHCST","DISPQUERY","INCITOTAL",pid,incicode),"^",3)=$p(^TMP("DHCST","DISPQUERY","INCITOTAL",pid,incicode),"^",3)+retqty
    ... s $p(^TMP("DHCST","DISPQUERY","INCITOTAL",pid,incicode),"^",4)=$p(^TMP("DHCST","DISPQUERY","INCITOTAL",pid,incicode),"^",4)+retcost

OutPurRow
 
 s Data=$lb(pid,incicode,incidesc,uomdesc,qty,money)
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

ClassMethod DispQuerySaveClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DispQuerySaveExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod DispQuerySaveFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DispQuerySaveExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {                // if there are no more rows, finish fetching
    Set AtEnd=1
    Set Row=""
 }
 Else {         
        Set Row=^CacheTemp(repid,ind)
 }
 
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod GetOrdPriority(ord, chl)
{
 
  n (ord,chl)
  s priordr=$p(^OEORD(ord,"I",chl,1),"^",8)
  q:priordr="" ""
  q:'$d(^OECPR(priordr)) ""
  s priordesc=$p(^OECPR(priordr),"^",2)
  q priordesc
}

ClassMethod DocLoc(phac)
{
 n (phac)
 s ch=$o(^DHCPHAC(phac,"I",0))
 q:ch="" ""
 s oedis=$p(^DHCPHAC(phac,"I",ch),"^",7)
 q:oedis="" ""
 s ord=$p(oedis,"||",1)
 s itm=$p(oedis,"||",2)
 q:ord="" ""
 q:itm="" ""
 s useradddept=$p($g(^OEORD(ord,"I",itm,7)),"^",2)   ;060725	
 q $g(useradddept)
}

ClassMethod PhaCatByArcim(arcim)
{
 n (arcim)
 s sub=$p(arcim,"||",1)
 s ver=$p(arcim,"||",2)
 s phcdf=$P(^ARCIM(sub,ver,1),"^",12) q:phcdf="" ""
 s phcd=+phcdf
 s phasubcat=$p(^PHCD(phcd,1),"^",3) q:phasubcat="" ""
 s phacat=+phasubcat
 q phacat
}

ClassMethod LOC(INCLB)
{
 q:$g(INCLB)="" ""
 q $p($g(^INCI($p(INCLB,"||"),"IL",$p(INCLB,"||",2))),"^")
}

ClassMethod NewPid() As %String
{
	  	q $I(^DHCSTPID("DispQuery"))
}

/// 检索发药统计明细
/// Author:wyx
/// Date:2014-06-05
/// Argu:
/// Return:
/// D ##class(%ResultSet).RunQuery("web.DHCST.DispQuery","DispQuerySaveItm","")  
Query DispQuerySaveItm(pid As %String, incicode As %String) As %Query(ROWSPEC = "num,patno,patname,bed,deploc,prescno,Code,Desc,dosageuom,Form,pakuom,price:%Float,qty:%Float,money:%Float ,disdatetime,orditmdatetime,DoclocDesc") [ SqlProc ]
{
}

ClassMethod DispQuerySaveItmExecute(ByRef qHandle As %Binary, pid As %String, incicode As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 s qHandle=$lb(0,repid,0)
 ;
 q:pid="" $$$OK
 q:incicode="" $$$OK
 s num=0
 f  s num=$o(^TMP("DHCST","DISPQUERY","INCI",pid,incicode,num)) q:num=""  d
 .s Data=^TMP("DHCST","DISPQUERY","INCI",pid,incicode,num)
 .s patno = $p(Data,"^",1)
 .s patname = $p(Data,"^",2)
 .s bed = $p(Data,"^",3)
 .s deploc = $p(Data,"^",4)
 .s prescno = $p(Data,"^",5)
 .s Code = $p(Data,"^",6)
 .s Desc = $p(Data,"^",7)
 .s dosageuom = $p(Data,"^",8)
 .s Form = $p(Data,"^",9)
 .s pakuom = $p(Data,"^",10)
 .s price = $p(Data,"^",11)
 .s qty = $p(Data,"^",12)
 .s money = $p(Data,"^",13)
 .s disdatetime = $p(Data,"^",14)
 .s orditmdatetime = $p(Data,"^",15)
 .s DoclocDesc = $p(Data,"^",16) 
 .d OutPutRow
 .
  
 Quit $$$OK
OutPutRow
 s Data=$lb(num,patno,patname,bed,deploc,prescno,Code,Desc,dosageuom,Form,pakuom,price,qty,money,disdatetime,orditmdatetime,DoclocDesc)   
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

ClassMethod DispQuerySaveItmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DispQuerySaveItmExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod DispQuerySaveItmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DispQuerySaveItmExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {                // if there are no more rows, finish fetching
    Set AtEnd=1
    Set Row=""
 }
 Else {         
        Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

}
