Import SQLUser

Class web.DHCSTDISPSTAT Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod Query(datef, datet, pha, ward, user, type, phccat, inci, admloc, stime, etime, docloc, phcform, regno, mangroup, str) As %String
{
 n (%session,datef, datet, pha, ward, user, type, phccat, inci, admloc,stime,etime,docloc,phcform,regno,mangroup,str) //add lq
 s tmpEncryptCode=0
 s pid=..NewPid()
 k ^TMP("DHCSTDISPSTAT","Query","INCITOTAL",pid)
 k ^TMP("DHCSTDISPSTAT","Query","INCI",pid)
 s m=0 
 q:datef="" ""
 q:datet="" ""
 q:pha="" ""
 s loc=pha  ;
 i (stime="") s stime=$zth("00:00:00",3)
 i (etime="") s etime=$zth("23:59:59",3)
 s pha=$g(pha),ward=$g(ward),user=$g(user),type=$g(type)
 s specinci="",phacatid="",phacid="",phcsubcat="",phcminorsubcat=""
 i inci'="" s specinci=inci      ; ##class(web.DHCSTCOMMONSRV).ItemDescToID(desc)
 i phccat'=""  s phacatid=$p(phccat,"^",1) ;s phacatid=..PhaCatID(phccat)
 i phccat'=""  s phcsubcat=$p(phccat,"^",2)
 i phccat'=""  s phcminorsubcat=$p(phccat,"^",3) 
 s EncryptFlag=##Class(web.DHCSTCOMMPARA).GetEncryptLevelFlag("")
 f date=datef:1:datet d
 .s phacid="" f  s phacid=$o(^DHCPHAC(0,"PHA",pha,"DATE",date,phacid)) q:phacid=""  d
 ..q:'$d(^DHCPHAC(phacid))
 ..s collward=$p(^DHCPHAC(phacid),"^",4) 
 ..s colluser=$p(^DHCPHAC(phacid),"^",5)
 ..s colltype=$p(^DHCPHAC(phacid),"^",12)
 ..s tt=$p(^DHCPHAC(phacid),"^",3)
 ..q:(type'="")&(colltype'=type)
 ..s user1="" //2007-10-26
 ..i user'="" s user1=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(user),user1)) //2007-10-26 根据科室与人员对应表找人员userid
 ..i user1'="" q:colluser'=user1 //2007-10-26
 ..q:(date=datef)&(tt<stime)
 ..q:(date=datet)&(etime<tt)
 ..s ret=$$SetData(phacid,phacatid,specinci,admloc,docloc,.m,phcsubcat,phcminorsubcat,phcform,regno,loc,mangroup,str,ward,pid,EncryptFlag)

 ;检索符合条件的退药记录
 f date=datef:1:datet d
 .s pharetid="" 
 .f  s pharetid=$o(^PHARET(0,"RECLOC",pha,date,pharetid)) q:pharetid=""  d
 ..s retward=$p(^PHARET(pharetid),"^",6)
 ..s retuser=$p(^PHARET(pharetid),"^",3)
 ..s user1="" //2007-10-26
 ..i user'="" s user1=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(user),user1)) //2007-10-26 根据科室与人员对应表找人员userid
 ..q:(user1'="" )&(retuser'=user1)
 ..s tt=$p(^PHARET(pharetid),"^",2)
 ..i ward'="" s retloc=$p(^PAWARD(ward),"^",5)
 ..e  s retloc=""
 ..q:(retloc'="")&(retward'=retloc)
 ..q:(date=datef)&(tt<stime)
 ..q:(date=datet)&(etime<tt)
 ..s retchl=""
 ..f  s retchl=$o(^PHARET(pharetid,"I",retchl)) q:retchl=""  d
 ...s oedis=$p(^PHARET(pharetid,"I",retchl),"^",1)
 ...s disptype=..DispCatByOEDIS(oedis)
 ...
 ...q:(type'="")&(disptype'=type)
 ...s retitmid=pharetid_"||"_retchl
 ...d SetRetData(retitmid,specinci,admloc,docloc,regno,phacatid,phcsubcat,phcminorsubcat,phcform,mangroup,str,pid,EncryptFlag) //add lq
 
 ///zhouyg 20120620 数量格式化成带单位的不能放在发药统计之后
 s incicode=""
 f  s incicode=$o(^TMP("DHCSTDISPSTAT","Query","INCITOTAL",pid,incicode)) q:incicode=""  d
 .s inci=##class(web.DHCSTCOMMONSRV).ItemCodeToID(incicode)
 .q:inci=""
 .s outputincidata=$g(^TMP("DHCSTDISPSTAT","Query","INCITOTAL",pid,incicode))
 .//合计数量
 .s qty=$p(outputincidata,"^",3)
 .//发药数量
 .s qty=$p(outputincidata,"^",10)
 .S tqty=qty //##class(web.DHCSTPCHCOLLPRN).getPackQty(inci,qty)
 .s $p(^TMP("DHCSTDISPSTAT","Query","INCITOTAL",pid,incicode),"^",10)=tqty
 .//退药数量
 .s qty=$p(outputincidata,"^",12)
 .S tqty=##class(web.DHCSTPCHCOLLPRN).getPackQty(inci,qty)
 .s $p(^TMP("DHCSTDISPSTAT","Query","INCITOTAL",pid,incicode),"^",12)=tqty
 i (EncryptFlag=1) d
 .i $d(^TMP("DHCSTDISPSTAT","Query","PatNo",pid)) d
 ..s condition=##class(web.DHCSTCOMMONSRV).ChangeToJson("stdate^enddate^phacid^ward^user^type^phccat^inci^admloc^stime^etime^docloc^phcform^regno^mangroup",datef_"^"_datet_"^"_pha_"^"_ward_"^"_user_"^"_type_"^"_phccat_"^"_inci_"^"_admloc_"^"_stime_"^"_etime_"^"_docloc_"^"_phcform_"^"_regno_"^"_mangroup)
 ..s EncryptCode=$tr($o(^User.DHCSecretLevelI("Code",""))," ","")
 ..s eventnum=##class(web.DHCSTCOMMONSRV).EventLogNum() //这是多少条记录传一次
 ..s tmpeventcount=0
 ..s patno="",patnostr=""
 ..f  s patno=$o(^TMP("DHCSTDISPSTAT","Query","PatNo",pid,patno)) q:patno=""  d
 ...s tmpeventcount=tmpeventcount+1
 ...i patnostr="" s patnostr=patno
 ...e  s patnostr=patnostr_","_patno
 ...i tmpeventcount#eventnum=0 d 
 ....s content=##class(web.DHCSTCOMMONSRV).ChangeToJson("登记号",patnostr)
 ....s eventlogret=##class(web.DHCSTCOMMONSRV).CreateEventLog("DHCDISPGENERALQUERY",condition,content,EncryptCode)   //记录日志
 ....s patnostr=""
 ..i (tmpeventcount#eventnum'=0)&&(patnostr'="") d 
 ...s content=##class(web.DHCSTCOMMONSRV).ChangeToJson("登记号",patnostr)
 ...s eventlogret=##class(web.DHCSTCOMMONSRV).CreateEventLog("DHCDISPGENERALQUERY",condition,content,EncryptCode)   //记录日志
 k ^TMP("DHCSTDISPSTAT","Query","PatNo",pid)
 q pid
 
SetData(phacdr, phacatid, specinci, admloc, docloc, num, phcsubcat, phcminorsubcat, phcform, regno, loc, mangroup,str,ward,pid,EncryptFlag)  //add lq
	n (phacdr, phacatid, specinci, admloc,docloc, num,phcsubcat,phcminorsubcat,phcform,regno,loc,mangroup,str,ward,pid,EncryptFlag)  //add lq
	;-----------------------
	s Poisonid=$p(str,"^",1)   				//管制分类
	s incstkcatid=$p(str,"^",2)  			//库存分类
	s onlydoc=$p(str,"^",3)  				;仅医生科室
	s onlyout=$p(str,"^",4)  				;仅出院带药
	s excludedoc=$p(str,"^",5)  			;不包含医生科室发药
	s excludeout=$p(str,"^",6)  			;不包含出院带药发药
	s PhcCatAll=$p(str,"^",7)    			;多级药学分类  add by wyx
 	s hospid=$p($g(^CTLOC(+loc)),"^",22)
	q:'$d(^DHCPHAC(phacdr)) 0
	s tmploc=$p(^DHCPHAC(phacdr),"^",4)
	q:(ward'="")&&(tmploc'=ward) 0
	s colldate=$p(^DHCPHAC(phacdr),"^",2)
	s disdate=colldate
	i disdate'="" s disdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(disdate)	;Dispensing Date  
	s phatime=disdate_" "_##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml($p(^DHCPHAC(phacdr),"^",3))
	s colluser=$p(^DHCPHAC(phacdr),"^",5)   
	s colluser=$S(colluser'="":$p(^SSU("SSUSR",colluser),"^",2),1:"")
	s phaci="" 
	f  s phaci=$o(^DHCPHAC(phacdr,"I",phaci)) q:phaci=""  d
	.s adm=$p(^DHCPHAC(phacdr,"I",phaci),"^",3) 
	.q:adm=""
	.s oedis=$p(^DHCPHAC(phacdr,"I",phaci),"^",7)
	.s ord=$p(oedis,"||",1)      								;OEORD_RowId
	.s chl=$p(oedis,"||",2)      								;OEORI_ChildSub
	.q:'$d(^OEORD(ord,"I",chl))
	.s tmpadmloc=$p(^DHCPHAC(phacdr,"I",phaci),"^",11)   
	.q:(admloc'="")&&(admloc'=tmpadmloc)  												;not for the adm loc
	.s deploc=$p(^CTLOC(tmpadmloc),"^",2)
	.i $f(deploc,"-")  s deploc=$p(deploc,"-",2)
	.s doctorloc=..UserDept(oedis)  													//医生科室
	.q:(docloc'="")&&(doctorloc'=docloc)  
	.
	.s PRCODE=..PriortyCode(oedis)  													//优先级
	.s ISDOCLOC=..Linked(oedis)  														//医生科室医嘱
	.
	.i onlyout>0 q:PRCODE'="OUT"  														//仅出院带药
	.i onlydoc>0 q:ISDOCLOC=0   														// 仅医生科室医嘱
	.
	.i excludedoc>0 q:ISDOCLOC=1  														// 不包含医生科室医嘱
	.i excludeout>0 q:PRCODE="OUT"  													// 不包含出院带药 
	.
	.s collward=$p(^PAADM(adm),"^",70)
	.;q:(ward'="")&(collward'=ward) ;放开此代码,则按病区查时，把医生科室回归各病区 20121211按病区查时不能把按医生科室发药的也统计进来
	.//患者信息
	.s papmi=$p(^PAADM(adm),"^",1)												;PA_PatMas PAPMI_RowId 
	.q:papmi="" 												
	.s patno=$p(^PAPER(papmi,"PAT",1),"^",1)
	.q:(regno'="")&(patno'=regno)
	.s patname=$p(^PAPER(papmi,"ALL"),"^",1)
	.s sexdr=$p(^PAPER(papmi,"ALL"),"^",7)
	.s sex=""
	.i sexdr'="" s sex=$P(^CT("SEX",sexdr),"^",2) //性别
	.s padob=$p(^PAPER(papmi,"ALL"),"^",6)
	.s paold=##class(web.DHCSTKUTIL).GetAge(papmi) //年龄      2007-9-19,zdm
	.s diagnose="" //##class(web.DHCSTKUTIL).GetMRDiagnosDesc(adm,",") //诊断,yunhaibao20160119注释,此处严重影响速度
	.s bed=$p(^DHCPHAC(phacdr,"I",phaci),"^",8)
	.s prescno=$p(^DHCPHAC(phacdr,"I",phaci),"^",5)
	.//医嘱信息
	.s action=##class(web.DHCSTPCHCOLLS2).SkinTest2(oedis) 							;lq 2007-10-19 备注(皮试结果) 
	.s doctor=##class(web.DHCSTCOMMONSRV).getOrdDoctor(oedis) 							;开方医生
	.s oeoridate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml($p(^OEORD(ord,"I",chl,3),"^",7))_" "_##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml($p(^OEORD(ord,"I",chl,1),"^",17)) //开方时间  2007-10-13
	.s freq=$p(##class(web.DHCSTCOMMONORDER).OeoriFreq(oedis),"^",3)
	.s dura=$p(##class(web.DHCSTCOMMONORDER).OeoriDuration(oedis),"^",2)
	.i $p($G(^OEORD(ord,"I",chl,2)),"^",6)'="" s dura=$p($g(^PHCDU($p($g(^OEORD(ord,"I",chl,2)),"^",6))),"^",1)   ;dura用药疗程
	.//s dosage=$p($G(^OEORD(ord,"I",chl,2)),"^",1)     							;用药剂量
	.s dosage=##class(web.DHCSTCOMMONORDER).OeoriDosage(oedis)
	.//i +dosage>0 d
	..//s dosageuomdr=$p($g(^OEORD(ord,"I",chl,2)),"^",3)
	..//s dosageuom=$s(dosageuomdr'="":$p($g(^CT("UOM",dosageuomdr)),"^",2),1:"")    		;剂量单位
	.//e  s dosageuom=""
	.//医嘱项和药学项信息
	.s arcimid=$p(^OEORD(ord,"I",chl,1),"^",2) 										;ARCIM_RowId 
	.s arcimdesc=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)     		;医嘱名称
	.s PhcdfDr=##class(web.DHCST.Common.DrugInfoCommon).GetPhcdfByArcim(arcimid) 		;指向PHC_DrgForm
	.s rphcdphcpodr=$p(##class(web.DHCST.Common.DrugInfoCommon).GetPhcPoisonByPhcd(PhcdfDr),"^")
	.q:(Poisonid'="")&&(rphcdphcpodr'=Poisonid)
	.q:(phacatid'="")&(phacatid'=..PhaCatByArcim(arcimid))
	.q:(phcsubcat'="")&(phcsubcat'=..PhaSubCatByArcim(arcimid))
	.s include=..CheckMinorCat(phcminorsubcat,arcimid)
	.q:(phcminorsubcat'="")&&(include'=1)  											;2007-9-19,zdm
	.q:(phcform'="")&(phcform'=..PhaFormByArcim(arcimid))
	.s PhaCatAllstr=##class(web.DHCST.Common.DrugInfoCommon).GetPhaCatAllByPhcdf(PhcdfDr)
	.s PhaCatAlls=$p(PhaCatAllstr,"^",1)
	.s PhaCatAllDesc=$p(PhaCatAllstr,"^",2)
	.s retflag=##class(web.DHCST.Common.DrugInfoCommon).CheckNewCatId(PhcCatAll,PhaCatAlls)
	.q:(PhcCatAll'="")&&(retflag=0) 									//add wyx 2014-12-08 药学多级分类
	.s form=$p(##class(web.DHCST.Common.DrugInfoCommon).GetFormByPhcdf(PhcdfDr),"^",2)
	.
	.s EncryptLevelInfo=""
	.s EncryptLevel=""
	.s PatLevel=""
	.i EncryptFlag=1 d
	..s EncryptLevelInfo=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(papmi,"")  ;病人密级
	..s EncryptLevel=$p(EncryptLevelInfo,"^",1)
	..s PatLevel=$p(EncryptLevelInfo,"^",2)
	..s EncryptCode=$p(EncryptLevelInfo,"^",3)
	..s ^TMP("DHCSTDISPSTAT","Query","PatNo",pid,patno)=""
	.
	.s phaclb=""
	.f  s phaclb=$o(^DHCPHAC(phacdr,"I",phaci,"B",phaclb)) q:phaclb=""  d
	..s inclb=$p(^DHCPHAC(phacdr,"I",phaci,"B",phaclb),"^",1)
	..s inci=+inclb
	..q:inci=0
	..q:(specinci'="")&&(inci'=specinci)
	..s incscdr=$p(^INCI(inci,2),"^",2)  //库存分类rowid
	..q:(incstkcatid'="")&(incscdr'=incstkcatid)
	..s incmangroup=$$GetManGrp(loc,inci)
	..q:(incmangroup'=mangroup)&(mangroup'="")  
	..s incicode=$p($g(^INCI(inci,1)),"^",1) 
	..s incidesc=$p($g(^INCI(inci,1)),"^",2)
	..s pakuom=$p(^CT("UOM",$p(^INCI(inci,1),"^",10)),"^",2)
	..s puomprice=..Getpuomprice(inci,colldate,hospid)
	..s qty=$p(^DHCPHAC(phacdr,"I",phaci,"B",phaclb),"^",2)    		;qty数量
	..s price=$p(^DHCPHAC(phacdr,"I",phaci,"B",phaclb),"^",5)  		;price价格
	..s money=$p(^DHCPHAC(phacdr,"I",phaci,"B",phaclb),"^",6)
	..s num=num+1
	..s ^TMP("DHCSTDISPSTAT","Query","INCI",pid,incicode,num)=patno_"^"_patname_"^"_bed_"^"_deploc_"^"_prescno_"^"_incicode_"^"_incidesc_"^"_dosage_"^"_form_"^"_pakuom_"^"_price_"^"_qty_"^"_money_"^"_disdate_"^"_sex_"^"_paold_"^"_diagnose_"^"_phatime_"^"_doctor_"^"_oeoridate_"^"_freq_"^"_action_"^"_puomprice_"^"_EncryptLevel_"^"_PatLevel_"^"_colluser
	..i '$d(^TMP("DHCSTDISPSTAT","Query","INCITOTAL",pid,incicode)) d
	...;获取药品属性信息
	...s Genername=##class(web.DHCSTCOMMONSRV).getGeneric(inci) 		//通用名
	...s Specifaction=##class(web.DHCSTKUTIL).GetSpec(inci)  			//规格
	...s Formname=##class(web.DHCSTCOMMONSRV).GetForm(inci) 			//剂型
	...s ManfName=$p(##class(web.DHCST.Common.DrugInfoCommon).GetManf(inci),"^",3) 	//厂家
	...s ^TMP("DHCSTDISPSTAT","Query","INCITOTAL",pid,incicode)=incidesc_"^"_pakuom_"^"_qty_"^"_money_"^"_Genername_"^"_Specifaction_"^"_Formname_"^"_ManfName_"^"_price_"^"_qty_"^"_money_"^"_0_"^"_0_"^"_puomprice  //add lq,2007-8-15,zdm,发药数量，发药金额，退药数量,退药金额
	..e  d
	...s $p(^TMP("DHCSTDISPSTAT","Query","INCITOTAL",pid,incicode),"^",3)=$p(^TMP("DHCSTDISPSTAT","Query","INCITOTAL",pid,incicode),"^",3)+qty
	...s $p(^TMP("DHCSTDISPSTAT","Query","INCITOTAL",pid,incicode),"^",4)=$p(^TMP("DHCSTDISPSTAT","Query","INCITOTAL",pid,incicode),"^",4)+money
	...s $p(^TMP("DHCSTDISPSTAT","Query","INCITOTAL",pid,incicode),"^",10)=$p(^TMP("DHCSTDISPSTAT","Query","INCITOTAL",pid,incicode),"^",10)+qty
	...s $p(^TMP("DHCSTDISPSTAT","Query","INCITOTAL",pid,incicode),"^",11)=$p(^TMP("DHCSTDISPSTAT","Query","INCITOTAL",pid,incicode),"^",11)+money
	..
	.
	q ""    
SetRetData(pharetdr,specinci, admloc, docloc, regno,phacatid,phcsubcat,phcminorsubcat,phcform,mangroup,str,pid,EncryptFlag) //add lq
 n (pharetdr,specinci, admloc, docloc, regno,phacatid,phcsubcat,phcminorsubcat,phcform,mangroup,str,pid,EncryptFlag) //add lq
 ;-----------------------
 s Poisonid=$p(str,"^",1)   //管制分类
 s incstkcatid=$p(str,"^",2)  //库存分类
 s onlydoc=$p(str,"^",3)  ;仅医生科室
 s onlyout=$p(str,"^",4)  ;仅出院带药
 s excludedoc=$p(str,"^",5)  ;不包含医生科室发药
 s excludeout=$p(str,"^",6)  ;不包含出院带药发药
 s PhcCatAll=$p(str,"^",7)    ;多级药学分类  add by wyx
 ;
 s retchl=$p(pharetdr,"||",2)
 s pharetdr=+pharetdr
 q:'$d(^PHARET(pharetdr))
 s phalocid=$p(^PHARET(pharetdr),"^",5) 
 s hospid=$p($g(^CTLOC(+phalocid)),"^",22)
 s retuser=$p(^PHARET(pharetdr),"^",3) 
 s retuser=$S(retuser'="":$p(^SSU("SSUSR",retuser),"^",2),1:"")
 s incidr=$p(^PHARET(pharetdr,"I",retchl),"^",11) 
 q:incidr=""
 ;----------------------  add  by lq -----------------
 s incscdr=$p(^INCI(incidr,2),"^",2)  //库存分类rowid
 i incstkcatid'="" q:incscdr'=incstkcatid
 ;
 s rArcimRowId=$p(^INCI(incidr,1),"^",3) 
 s rSubscript=$p(rArcimRowId,"||",1) 
 s rVersion=$p(rArcimRowId,"||",2) 
 s rArcimPhcdfDr=$p(^ARCIM(rSubscript,rVersion,1),"^",12) ; 指向PHC_DrgForm
 s rPhcDrgForm1=$p(rArcimPhcdfDr,"||",1)
 s rPhcDrgForm2=$p(rArcimPhcdfDr,"||",2)
 
 s rPhcDrgMastRowId=rPhcDrgForm1
 
 s rphcdphcpodr=""
 i rPhcDrgMastRowId'="" s rphcdphcpodr=$p($G(^PHCD(rPhcDrgMastRowId,1)),"^",4) ;取管制分类
 i Poisonid'="" q:rphcdphcpodr'=Poisonid
 ;
 ;s oedis=$P(^PHARET(pharetdr),"^",5)
 s oedis=$p(^PHARET(pharetdr,"I",retchl),"^",1) q:oedis=""  //bianshuai
 s userdept=..UserDept(oedis)   //取医生科室
 i docloc'="" q:userdept'=docloc
 s PRCODE=..PriortyCode(oedis)  //优先级
 s ISDOCLOC=..Linked(oedis)  //医生科室医嘱
 i onlyout>0 q:PRCODE'="OUT"  //仅出院带药
 i onlydoc>0 q:ISDOCLOC=0   // 仅医生科室医嘱
 i excludedoc>0 q:ISDOCLOC=1  // 不包含医生科室医嘱
 i excludeout>0 q:PRCODE="OUT"  // 不包含出院带药
 
 s Genername=##class(web.DHCSTCOMMONSRV).getGeneric(incidr) //通用名
 s Specifaction=##class(web.DHCSTKUTIL).GetSpec(incidr)  //规格
 s Formname=##class(web.DHCSTCOMMONSRV).GetForm(incidr) //剂型
 s ManfName=$p(##class(web.DHCST.Common.DrugInfoCommon).GetManf(incidr),"^",3) //厂家
    ;-------------------------------
 q:(specinci'="")&(incidr'=specinci) ; INCI_RowId
 s loc=$p(^PHARET(pharetdr),"^",8)  ; 药房
 s incmangroup=$$GetManGrp(loc,incidr)  ;管理组
 q:(incmangroup'=mangroup)&(mangroup'="")  
 
 s incicode=$p(^INCI(incidr,1),"^",1)
 
 s admlocid=$p(^PHARET(pharetdr,"I",retchl),"^",9) 
 q:(admloc'="")&(admlocid'=admloc)     ;就诊科室
 s deploc=$p($g(^CTLOC(admlocid)),"^",2)
 i deploc["-" s deploc=$p(deploc,"-",2,$l(deploc,"-"))	// 此节点显示当时对应的就诊科室
 s adm=$p(^PHARET(pharetdr,"I",retchl),"^",8)  q:adm=""
 s papmi=$p(^PAADM(adm),"^",1)
 s tmpregno="" 
 i papmi'="" s tmpregno=$p(^PAPER(papmi,"PAT",1),"^",1)
 q:(regno'="")&(tmpregno'=regno) 
 
 s oedis=$p(^PHARET(pharetdr,"I",retchl),"^",1) q:oedis=""
 s ord=$p(oedis,"||",1)
 s chl=$p(oedis,"||",2)
 s action=##class(web.DHCSTPCHCOLLS2).SkinTest2(ord_"||"_chl) ;lq 2007-10-19 备注(皮试结果)
 //s doctor=$p(^OEORD(ord,"I",chl,7),"^",1)
 s patname=""
 i papmi'="" s patname=$p(^PAPER(papmi,"ALL"),"^",1)
 //s deplocdr=$p(^PHARET(pharetdr),"^",6)
 //s deploc=""
 //i deplocdr'="" s deploc=$p(^CTLOC(deplocdr),"^",2)
 //i $f(deploc,"-")  s deploc=$p(deploc,"-",2)
 s beddr=$p(^PHARET(pharetdr,"I",retchl),"^",10)
 s bed=""
 i beddr'="" s bed=$p(^PAWARD($p(beddr,"||",1),"BED",$p(beddr,"||",2)),"^",1)
 s prescno=$p(^OEORD(ord,"I",chl,1),"^",14)
 s incidesc=$p(^INCI(incidr,1),"^",2)
 s dosage=$p(^OEORD(ord,"I",chl,2),"^",1)    ;dosage用药剂量
 i +dosage>0 d
 .s dosageuom=$p($g(^OEORD(ord,"I",chl,2)),"^",3)
 .i dosageuom'="" s dosageuom=$p($g(^CT("UOM",dosageuom)),"^",2)    ;剂量单位
 e  s dosageuom=""
 s arcimid=$p(^OEORD(ord,"I",chl,1),"^",2)
 q:(phacatid'="")&(phacatid'=..PhaCatByArcim(arcimid))   ;药学项大类
 q:(phcsubcat'="")&(phcsubcat'=..PhaSubCatByArcim(arcimid))   ;药学项子类
 ;q:(phcminorsubcat'="")&(phcminorsubcat'=..PhaMinorSubCatByArcim(arcimid)) ;药学项小类
 s PhaCatAllstr=##class(web.DHCST.Common.DrugInfoCommon).GetPhaCatAll(incidr)
 s PhaCatAlls=$p(PhaCatAllstr,"^",1)
 s PhaCatAllDesc=$p(PhaCatAllstr,"^",2)
 s retflag=##class(web.DHCST.Common.DrugInfoCommon).CheckNewCatId(PhcCatAll,PhaCatAlls)
 q:(PhcCatAll'="")&(retflag=0) //add wyx 2014-12-08 药学多级分类
 s include=..CheckMinorCat(phcminorsubcat,arcimid)
 q:(phcminorsubcat'="")&(include'=1) ;药学项小类    ;2007-9-19,zdm
 q:(phcform'="")&(phcform'=..PhaFormByArcim(arcimid))  ;剂型
 ;-------------add by lq--------------------------
 s sexdr=$p(^PAPER(papmi,"ALL"),"^",7)
 s sex=""
 i sexdr'="" s sex=$P(^CT("SEX",sexdr),"^",2) //性别
 s padob=$p(^PAPER(papmi,"ALL"),"^",6)
 s paold=##class(web.DHCSTKUTIL).GetAge(papmi) //年龄   2007-9-19,zdm
 s diagnose="" //##class(web.DHCSTKUTIL).GetMRDiagnosDesc(adm,",") //诊断
 s rettime=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml($p(^PHARET(pharetdr),"^",1))_" "_##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml($p(^PHARET(pharetdr),"^",2)) //退药时间 2007-10-13
 s doctor=##class(web.DHCSTCOMMONSRV).getOrdDoctor(ord_"||"_chl) //开方医生
 s oeoridate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml($p(^OEORD(ord,"I",chl,3),"^",7))_" "_##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml($p(^OEORD(ord,"I",chl,1),"^",17)) //开方时间2007-10-13
 s freqdr=$p(^OEORD(ord,"I",chl,2),"^",4)
 s freq=""
 i freqdr'="" s freq=$p(^PHCFR(freqdr),"^",3) //频次
 ;--------------------------------
 s phcdfid=##class(web.DHCST.Common.DrugInfoCommon).GetPhcdfByArcim(arcimid) 	 ;PHC_DrgForm Rowid
 s form=$p(##class(web.DHCST.Common.DrugInfoCommon).GetFormByPhcdf(phcdfid),"^",2)
 s pakuom=$p(^CT("UOM",$p(^INCI(incidr,1),"^",10)),"^",2)
 s qty=$p(^PHARET(pharetdr,"I",retchl),"^",2)     ;qty数量
 s price=$p(^PHARET(pharetdr,"I",retchl),"^",4)  ;price价格
 s retdate=$p(^PHARET(pharetdr),"^",1)     ; return Date 
 s puomprice=..Getpuomprice(incidr,retdate,hospid)
 ;s price=price
 ;s money=qty*price
 s money=$p(^PHARET(pharetdr,"I",retchl),"^",5)  ;money金额
 s EncryptLevelInfo=""
 s EncryptLevel=""
 s PatLevel=""
 i EncryptFlag=1 d
 .s EncryptLevelInfo=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(papmi,"")  ;病人密级
 .s EncryptLevel=$p(EncryptLevelInfo,"^",1)
 .s PatLevel=$p(EncryptLevelInfo,"^",2)
 .s EncryptCode=$p(EncryptLevelInfo,"^",3)
 .s ^TMP("DHCSTDISPSTAT","Query","PatNo",pid,tmpregno)=""
 s num=$o(^TMP("DHCSTDISPSTAT","Query","INCI",pid,incicode,""),-1)
 s num=$i(num)
 s ^TMP("DHCSTDISPSTAT","Query","INCI",pid,incicode,num)=tmpregno_"^"_patname_"^"_bed_"^"_deploc_"^"_prescno_"^"_incicode_"^"_incidesc_"^"_dosage_dosageuom_"^"_form_"^"_pakuom_"^"_price_"^"_-qty_"^"_-money_"^"_retdate_"^"_sex_"^"_paold_"^"_diagnose_"^"_rettime_"^"_doctor_"^"_oeoridate_"^"_freq_"^"_action_"^"_puomprice_"^"_EncryptLevel_"^"_PatLevel_"^"_$G(retuser)
 i '$d(^TMP("DHCSTDISPSTAT","Query","INCITOTAL",pid,incicode)) d
 .s ^TMP("DHCSTDISPSTAT","Query","INCITOTAL",pid,incicode)=incidesc_"^"_pakuom_"^"_-qty_"^"_-money_"^"_Genername_"^"_Specifaction_"^"_Formname_"^"_ManfName_"^"_price_"^"_0_"^"_0_"^"_qty_"^"_money_"^"_puomprice //add lq ,2007-8-15,zdm,发药数量，发药金额，退药数量，退药金额
 e  d
 .s $p(^TMP("DHCSTDISPSTAT","Query","INCITOTAL",pid,incicode),"^",3)=$p(^TMP("DHCSTDISPSTAT","Query","INCITOTAL",pid,incicode),"^",3)-qty
 .s $p(^TMP("DHCSTDISPSTAT","Query","INCITOTAL",pid,incicode),"^",4)=$p(^TMP("DHCSTDISPSTAT","Query","INCITOTAL",pid,incicode),"^",4)-money
 .s $p(^TMP("DHCSTDISPSTAT","Query","INCITOTAL",pid,incicode),"^",12)=$p(^TMP("DHCSTDISPSTAT","Query","INCITOTAL",pid,incicode),"^",12)+qty
 .s $p(^TMP("DHCSTDISPSTAT","Query","INCITOTAL",pid,incicode),"^",13)=$p(^TMP("DHCSTDISPSTAT","Query","INCITOTAL",pid,incicode),"^",13)+money
 q

 ///yunhaibao20160303,修正为新管理组
GetManGrp(loc,inci)     
 n (loc,inci)
 s incilch=$o(^INCI("IL_LOC",loc,inci,""))
 s incilrowid=inci_"||"_incilch
 q:'$d(^DHCINCIL(0,"INCIL",incilrowid)) ""
 s dhcincil=$o(^DHCINCIL(0,"INCIL",incilrowid,""))
 s incmangroup=$p($g(^DHCINCIL(dhcincil)),"^",7)
 q incmangroup
}

ClassMethod LData(pno, incicode)
{
 n (pno, incicode)
 q:pno="" 0
 s new=$o(^TMP("DHCSTDISPSTAT","Query","INCITOTAL",pno,incicode))
 q:new="" ""
 q new_"^"_$p(^(new),"^",1)_"^"_$p(^(new),"^",2)_"^"_$p(^(new),"^",3)_"^"_$fn($p(^(new),"^",4),"",4)_"^"_$p(^(new),"^",5)_"^"_$p(^(new),"^",6)_"^"_$p(^(new),"^",7)_"^"_$p(^(new),"^",8)_"^"_$p(^(new),"^",9)_"^"_$p(^(new),"^",10)_"^"_$p(^(new),"^",11)_"^"_$p(^(new),"^",12)_"^"_$p(^(new),"^",13)_"^"_$p(^(new),"^",14)
}

ClassMethod LPrnData(itmjs As %Library.String = "", itmjsex As %Library.String = "", pno As %String, incicode As %String)
{
 n (pno, incicode)
 ;k ^TMP($j,"PLIST")
 q:pno="" 0
 s new=$o(^TMP("DHCSTDISPSTAT","Query","INCITOTAL",pno,incicode))
 q:new="" ""
 q new_"^"_^(new)
 q new_"^"_$p(^(new),"^",1)_"^"_$p(^(new),"^",2)_"^"_$p(^(new),"^",3)_"^"_$fn($p(^(new),"^",4),"",2)_"^"_$p(^(new),"^",9)
}

ClassMethod LDataDet(pno As %String, incicode As %String, num As %Integer) As %String
{
 n (pno, incicode,num)
 q:pno="" ""
 q:incicode="" ""
 s num=$o(^TMP("DHCSTDISPSTAT","Query","INCI",pno,incicode,num)) 
 q:num="" ""
 k ^TMP($j,"PLIST")
 s ^TMP($j,"PLIST",1)=^TMP("DHCSTDISPSTAT","Query","INCI",pno,incicode,num)
 q num
}

ClassMethod GetLocUser(loc)
{
 n (loc)
 k ^TMP($j,"PLIST")
 s i=0 
 s locid=loc
 i locid'=""  d
 .s user="" f  s user=$o(^SSU("SSUSR",user)) q:user=""  d
 ..q:$p(^SSU("SSUSR",user),"^",4)'=locid
 ..s i=i+1
 ..s ^TMP($j,"PLIST",i)=user_"^"_$p(^SSU("SSUSR",user),"^",2)
 q i
}

ClassMethod GetWard()
{
 k ^TMP($j,"PLIST")
 s i=0 
 s ward="" f  s ward=$o(^PAWARD(0,"WARD_Desc",ward)) q:ward=""  d
 .s i=i+1
 .s ward1=$o(^PAWARD(0,"WARD_Desc",ward,""))
 .s ^TMP($j,"PLIST",i)=$p(^PAWARD(ward1),"^",2)
 s ^TMP($j,"PLIST")=i
 q i
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

ClassMethod PhaSubCatByArcim(arcim)
{
 n (arcim)
 s sub=$p(arcim,"||",1)
 s ver=$p(arcim,"||",2)
 s phcdf=$P(^ARCIM(sub,ver,1),"^",12) q:phcdf="" ""
 s phcd=+phcdf
 s phasubcat=$p(^PHCD(phcd,1),"^",3)     
 q phasubcat
}

ClassMethod PhaMinorSubCatByArcim(arcim)
{
 n (arcim)
 s sub=$p(arcim,"||",1)
 s ver=$p(arcim,"||",2)
 s phcdf=$P(^ARCIM(sub,ver,1),"^",12) q:phcdf="" ""
 s phcd=+phcdf
 s phaminorsubcat=$p(^PHCD(phcd,1),"^",6) 
 q phaminorsubcat
}

ClassMethod PhaFormByArcim(arcim)
{
 n (arcim)
 s sub=$p(arcim,"||",1)
 s ver=$p(arcim,"||",2)
 s phcdf=$P(^ARCIM(sub,ver,1),"^",12) q:phcdf="" ""
 s phcd=+phcdf
 s phcdfsub=$p(phcdf,"||",2)
 q $p(##class(web.DHCST.Common.DrugInfoCommon).GetFormByPhcdf(phcdf),"^",3)
}

ClassMethod PhaCatID(phacatdesc)
{
 n (phacatdesc)
 &sql(select phcc_rowid into :qq from phc_cat where phcc_desc=:phacatdesc)
 q $g(qq)
}

ClassMethod KG(pno)
{
 k ^TMP(pno)
 q
}

ClassMethod GetPhaCats()
{
 s phcc=0
 k ^TMP($j,"PLIST")
 s i=0
 f  s phcc=$o(^PHCC(phcc)) q:+phcc<1  d
 .s phacatdesc=$p(^PHCC(phcc),"^",2)
 .s i=i+1
 .s ^TMP($j,"PLIST",i)=phacatdesc
 q i
}

ClassMethod QueryWork(datef, datet, pha, stattype, checkuser)
{
	n (datef, datet, pha, stattype, checkuser)
	s pid=..NewPid()
	q:pha="" pid_"^"_0
	q:stattype="" pid_"^"_0
	s counts="",amt=""
	;---发药
	f date=datef:1:datet d
	. s phacid=""
	. f  s phacid=$o(^DHCPHAC(0,"PHA",pha,"DATE",date,phacid)) q:phacid=""  d
	. . s str=..GetZYYPFac(phacid)
	. . s num1=$p(str,"^",1) ;代煎剂数
	. . s num2=$p(str,"^",2) ;代煎处方张数
	. . s num3=$p(str,"^",3) ; 处方张数
	. . s num4=$p(str,"^",4)  ;处方剂数
	. . s num5=$p(str,"^",5)  ;味数
	. . s num6=$p(str,"^",6)  ;出院带药张数
	. . s num7=$p(str,"^",7)  ;出院带药张数
	. . s num8=..QueOutAmt(phacid) ;出院带药金额
	. . s num3=..SumRegnoFromDispNO(phacid)
	. . 
	. . s warddr=$p(^DHCPHAC(phacid),"^",4)
	. . s oper=$p(^DHCPHAC(phacid),"^",5) ;按发药人
	. . s cuserdr=$p(^DHCPHAC(phacid),"^",13)
	. . s counts=$p(^DHCPHAC(phacid),"^",9)
	. . s counts=..CalcuPhacCount(phacid)	// 完全按品种
	. . s dispno=$p(^DHCPHAC(phacid),"^",14)
	. . s amt=..DispAmt(phacid)
	. . ;
	. . s ch=$o(^DHCPHAC(phacid,"I","")) 
	. . i warddr="" s warddr=##class(web.DHCSTPCHCOLLS).DocLoc(phacid)
	. . e   s warddr=$p($g(^PAWARD(warddr)),"^",5) 
	. . ;
	. .i stattype="2" d
	. ..i warddr="" d
	. ...s oper="其他"
	. ..e  d
	. ...s oper=$p($G(^CTLOC(warddr)),"^",2)
	. ...i oper="" s oper="其他"
	. ...e  d
	. ....i $f(oper,"-") s oper=$p(oper,"-",2)
	. . q:(checkuser=1)&(cuserdr="")
	. . i checkuser=1 s oper=cuserdr  ;按第二发药人
	. . i stattype=1 s oper=+oper
	. . i $d(^TMP("DHCST",$ClassName(),"QueryWork",pid,oper))  d
	. . . s $p(^TMP("DHCST",$ClassName(),"QueryWork",pid,oper),"^",1)=$p(^TMP("DHCST",$ClassName(),"QueryWork",pid,oper),"^",1)+counts
	. . . s $p(^TMP("DHCST",$ClassName(),"QueryWork",pid,oper),"^",2)=$p(^TMP("DHCST",$ClassName(),"QueryWork",pid,oper),"^",2)+amt
	. . . s $p(^TMP("DHCST",$ClassName(),"QueryWork",pid,oper),"^",3)=$p(^TMP("DHCST",$ClassName(),"QueryWork",pid,oper),"^",3)+num1
	. . . s $p(^TMP("DHCST",$ClassName(),"QueryWork",pid,oper),"^",4)=$p(^TMP("DHCST",$ClassName(),"QueryWork",pid,oper),"^",4)+num2
	. . . s $p(^TMP("DHCST",$ClassName(),"QueryWork",pid,oper),"^",5)=$p(^TMP("DHCST",$ClassName(),"QueryWork",pid,oper),"^",5)+num3
	. . . s $p(^TMP("DHCST",$ClassName(),"QueryWork",pid,oper),"^",6)=$p(^TMP("DHCST",$ClassName(),"QueryWork",pid,oper),"^",6)+num4
	. . . s $p(^TMP("DHCST",$ClassName(),"QueryWork",pid,oper),"^",7)=$p(^TMP("DHCST",$ClassName(),"QueryWork",pid,oper),"^",7)+num5
	. . . s $p(^TMP("DHCST",$ClassName(),"QueryWork",pid,oper),"^",12)=$p(^TMP("DHCST",$ClassName(),"QueryWork",pid,oper),"^",12)+num6
	. . . s $p(^TMP("DHCST",$ClassName(),"QueryWork",pid,oper),"^",13)=$p(^TMP("DHCST",$ClassName(),"QueryWork",pid,oper),"^",13)+num7
	. . . s $p(^TMP("DHCST",$ClassName(),"QueryWork",pid,oper),"^",14)=$p(^TMP("DHCST",$ClassName(),"QueryWork",pid,oper),"^",14)+num8
	. . e  d
	. . . s ^TMP("DHCST",$ClassName(),"QueryWork",pid,oper)=counts_"^"_amt_"^"_num1_"^"_num2_"^"_num3_"^"_num4_"^"_num5_"^"_0_"^"_0_"^"_0_"^"_0_"^"_num6_"^"_num7_"^"_num8
	. . i '$d(QueryWorkArr(oper,dispno)) s QueryWorkArr(oper,dispno)=""
	.
	;---退药 LQ
	s QueNum=1 ;处方张数
	s FacNum=0 ;处方剂数
	f date=datef:1:datet d
	.s phret=""
	.f  s phret=$o(^PHARET(0,"RECLOC",pha,date,phret))  q:phret=""  d
	..s oper=$p(^PHARET(phret),"^",3)
	..s retno=$p(^PHARET(phret),"^",7)
	..s retchl=""
 	..f  s retchl=$o(^PHARET(phret,"I",retchl)) q:retchl=""  d
	...s retamt=$p(^PHARET(phret,"I",retchl),"^",5)
	...s dodis=$p(^PHARET(phret,"I",retchl),"^",13)
	...s wardlocID=$p(^PHARET(phret),"^",6)
	...s phacid=$p(^DHCOEDISQTY(dodis),"^",14)
	...s cuserdr=$p(^DHCPHAC(+phacid),"^",13)
	...s oedis=$p(^PHARET(phret,"I",retchl),"^",1) 
	...q:oedis=""
 	...s ord=$p(oedis,"||",1)
 	...s chl=$p(oedis,"||",2)
	...;--草药部分
	...s prescno=$p(^OEORD(ord,"I",chl,1),"^",14)
	...
	...s queid=$o(^PAQUE1(0,"PrescNo",prescno,""))
	...i (queid'="")&&($d(^PAQUE1(queid,"DHC"))) d 
    ....s durdr=$p(^PAQUE1(queid,"DHC"),"^",10)
    ....s facotor=$p(^PHCDU(durdr),"^",2) ;剂数
    ....s FacNum=facotor
    ...; 
	...
	...i wardlocID="" 
    ...
	...i stattype="2" d
	....i wardlocID="" d
	.....s adm=$p(^DHCPHAC(+phacid,"I", $p(phacid,"||",2)),"^",3)
    .....s collward=$p(^PAADM(adm),"^",70)
    .....s oper=$p($g(^PAWARD(collward)),"^",2)  ;特殊科室转病区
	....e  d
	.....s oper=$p(^CTLOC(wardlocID),"^",2)
	....i oper="" s oper="其他"
	....e  d
	.....i $f(oper,"-") s oper=$p(oper,"-",2)
	...
	...q:(checkuser=1)&(cuserdr="")
	...i checkuser=1 s oper=cuserdr  ;按第二发药人
	...q:oper=""
	...i '$d(^TMP("DHCST",$ClassName(),"QueryWork",pid,oper)) d
	....s ^TMP("DHCST",$ClassName(),"QueryWork",pid,oper)=0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_1_"^"_retamt_"^"_QueNum_"^"_FacNum_"^"_0_"^"_0_"^"_0
	...e  d
	....s $p(^TMP("DHCST",$ClassName(),"QueryWork",pid,oper),"^",8)=$p(^TMP("DHCST",$ClassName(),"QueryWork",pid,oper),"^",8)+1  ;退药品种数
    ....s $p(^TMP("DHCST",$ClassName(),"QueryWork",pid,oper),"^",9)=$p(^TMP("DHCST",$ClassName(),"QueryWork",pid,oper),"^",9)+retamt ;退药金额
    ....i '$d(QueryWorkArr("Y",prescno)) d
    .....s $p(^TMP("DHCST",$ClassName(),"QueryWork",pid,oper),"^",10)=$p(^TMP("DHCST",$ClassName(),"QueryWork",pid,oper),"^",10)+1 ;退药处方张数
    .....s $p(^TMP("DHCST",$ClassName(),"QueryWork",pid,oper),"^",11)=$p(^TMP("DHCST",$ClassName(),"QueryWork",pid,oper),"^",11)+FacNum ;退药处方剂数
    ...
    ...i (queid'="")&&($d(^PAQUE1(queid,"DHC"))) d 
    ....s QueryWorkArr("Y",prescno)=""
    ...
    ...i '$d(QueryWorkArr(oper,retno)) s QueryWorkArr(oper,retno)=""
    .
    ;---合计	
	s oper="" 
	s i=0
	f  s oper=$o(^TMP("DHCST",$ClassName(),"QueryWork",pid,oper)) q:oper=""  d
	.s dispno=""
	.s num=0
	.f  s dispno=$o(^TMP($j,"WORK",oper,dispno)) q:dispno=""  d
	..s num=num+1
	.i stattype="1" d
	..s operno=$p(^SSU("SSUSR",oper),"^",1)
	..s opername=$p(^SSU("SSUSR",oper),"^",2)
	.i stattype="2" d
	..s operno=""
	..s opername=oper
	.s i=i+1
	.s info1=$g(operno)_"^"_$g(opername)_"^"_$p(^TMP("DHCST",$ClassName(),"QueryWork",pid,oper),"^",1)_"^"_$p(^TMP("DHCST",$ClassName(),"QueryWork",pid,oper),"^",2)_"^"_num_"^"_$p(^TMP("DHCST",$ClassName(),"QueryWork",pid,oper),"^",3)_"^"_$p(^TMP("DHCST",$ClassName(),"QueryWork",pid,oper),"^",4)_"^"_$p(^TMP("DHCST",$ClassName(),"QueryWork",pid,oper),"^",5)_"^"_$p(^TMP("DHCST",$ClassName(),"QueryWork",pid,oper),"^",6)_"^"_$p(^TMP("DHCST",$ClassName(),"QueryWork",pid,oper),"^",7)_"^"_$p(^TMP("DHCST",$ClassName(),"QueryWork",pid,oper),"^",8)_"^"_$p(^TMP("DHCST",$ClassName(),"QueryWork",pid,oper),"^",9)
	.s info2=$p(^TMP("DHCST",$ClassName(),"QueryWork",pid,oper),"^",10)_"^"_$p(^TMP("DHCST",$ClassName(),"QueryWork",pid,oper),"^",11)_"^"_$p(^TMP("DHCST",$ClassName(),"QueryWork",pid,oper),"^",12)_"^"_$p(^TMP("DHCST",$ClassName(),"QueryWork",pid,oper),"^",13)_"^"_$p(^TMP("DHCST",$ClassName(),"QueryWork",pid,oper),"^",14)
	.s info=info1_"^"_info2
	.s ^TMP("DHCST",$ClassName(),"QueryWorkData",pid,i)=info
	k ^TMP("DHCST",$ClassName(),"QueryWork",pid)
	q pid_"^"_i
}

/// description: 中草药代煎总剂数(某人熬了多少锅) lq 2008-04-24
ClassMethod GetZYYPFac(phac)
{
	n (phac)
	q:(phac="") ""
	s ch=""
	s num=0    ;代煎处方张数
	s num1=0   ;处方张数
	s num2=0   ;处方剂数
	s facsum=0 ;代煎剂数
    s ws=0     ;统计味数
    s numoutque=0 ;出院带药张数
    s numoutfac=0 ;出院带药剂数
    ;s sumoutamt=0    ;出院带药金额
	f  s ch=$o(^DHCPHAC(phac,"I",ch)) q:ch=""  d
	.s prescno=$p(^DHCPHAC(phac,"I",ch),"^",5)  ;处方号
	.s queid=$o(^PAQUE1(0,"PrescNo",prescno,""))
	.q:queid=""     
	.q:'$d(^PAQUE1(queid,"DHC")) ;过滤非中草药
	.s oedis=$p(^DHCPHAC(phac,"I",ch),"^",7)
    .s ws=ws+1
    .q:$d(GetZYYPFac(prescno))
    .s num1=num1+1
    .s durdr=$p(^PAQUE1(queid,"DHC"),"^",10)
    .s facotor=$p(^PHCDU(durdr),"^",2) ;剂数
    .s num2=facotor+num2
    .
    .s priority=$p(^OECPR($p(^OEORD(+oedis,"I",$p(oedis,"||",2),1),"^",8)),"^",1)
    .i priority="OUT" d
    ..s numoutfac=numoutfac+facotor
    ..s numoutque=numoutque+1
    ..s qty=$p(^DHCPHAC(phac,"I",ch),"^",6)
    ..s price=$p(^DHCPHAC(phac,"I",ch),"^",9)
    ..s amtout=qty*price
    ..;s sumoutamt=$g(sumoutamt)+amtout ;出院带药金额
    .s cookmode=""
    .s cookmodeDr=$p(^PAQUE1(queid,"DHC"),"^",15)
    .s:cookmodeDr'="" cookmode=$p($g(^DHCDocConfig("CookMode",cookmodeDr)),"^",2)
    .s prescStr=##class(PHA.COM.Order).GetPaQueInfo(prescno)
    .s cookmode=$p(prescStr,"^",7)
    .i cookmode["代煎" d
    ..s num=num+1
    ..s facsum=facsum+facotor
    .s GetZYYPFac(prescno)=""
	q facsum_"^"_num_"^"_num1_"^"_num2_"^"_ws_"^"_numoutque_"^"_numoutfac
}

/// w ##class(web.DHCSTDISPSTAT).QueOutAmt(158)
ClassMethod QueOutAmt(phac)
{
 ;获取出院带药(草药)金额
 n (phac)
 q:phac="" ""
 s ch=""
 s sumamt=0
 f  s ch=$o(^DHCPHAC(phac,"I",ch)) q:ch=""  d
 .s prescno=$p(^DHCPHAC(phac,"I",ch),"^",5)  ;处方号
 .s queid=$o(^PAQUE1(0,"PrescNo",prescno,""))
 .q:queid=""     
 .q:'$d(^PAQUE1(queid,"DHC")) ;过滤非中草药
 .s oedis=$p(^DHCPHAC(phac,"I",ch),"^",7)
 .s priority=$p(^OECPR($p(^OEORD(+oedis,"I",$p(oedis,"||",2),1),"^",8)),"^",1)
 .s phcistatus=$p(^DHCPHAC(phac,"I",ch),"^",10)
 .q:phcistatus="D"
 .i priority="OUT" d
 ..//s qty=$p(^DHCPHAC(phac,"I",ch),"^",6)
 ..s phaclb=0
 ..f  s phaclb=$o(^DHCPHAC(phac,"I",ch,"B",phaclb)) q:(phaclb="")  d
 ...s amt=$p(^DHCPHAC(phac,"I",ch,"B",phaclb),"^",6)
 ...s sumamt=$g(sumamt)+amt
 ...
 ..;s sumamt=$fn($g(sumamt),"",4)
 q sumamt
}

ClassMethod SumRegnoFromDispNO(phac)
{
 ;获取某张发药单上不同登记号数
 n (phac)
 q:phac="" ""
 s num=0
 s tmpadm=""
 s ch=""
 f  s ch=$o(^DHCPHAC(phac,"I",ch)) q:ch=""  d
 .s adm=$p(^DHCPHAC(phac,"I",ch),"^",3)
 .i tmpadm'=adm d
 ..s num=num+1
 .s tmpadm=adm
 q num
}

ClassMethod DispAmt(phac)
{
 n (phac)
 q:phac="" ""
 s sumamt=0
 s ch=""
 f  s ch=$o(^DHCPHAC(phac,"I",ch)) q:ch=""  d
 .s phcistatus=$p(^DHCPHAC(phac,"I",ch),"^",10)
 .s phaclb=""
 .f  s phaclb=$o(^DHCPHAC(phac,"I",ch,"B",phaclb)) q:phaclb=""  d
 ..s phaclbdata=^(phaclb)
 ..s sumamt=$g(sumamt)+$p(phaclbdata,"^",6) 
 s sumamt=$fn($g(sumamt),"",4)
 q sumamt
}

ClassMethod ListWork(i, pid)
{
 n (i, pid)
 i $d(^TMP("DHCST",$ClassName(),"QueryWorkData",pid,i)) q ^TMP("DHCST",$ClassName(),"QueryWorkData",pid,i)
 q ""
}

ClassMethod PhaRetTotal(sdate, edate, phaloc, reasondr) As %String
{
 q:phaloc="" ""
 ;
 k ^TMP($j,"RETTOTAL")
 k ^TMP($j,"RETINCI")
 ;
 s retsum=1 ;退药人次
 s retadm=""
 s retcs=1 ;退药次数
 f dd=sdate:1:edate d
 . s phret=""
 . f  s phret=$o(^PHARET(0,"DATE",dd,phret)) q:phret=""  d
 . . s recloc=$p(^PHARET(phret),"^",5)
 . . q:recloc'=phaloc
 . . s retchl=""
 . . f  s retchl=$o(^PHARET(phret,"I",retchl)) q:retchl=""  d
 . . .s adm=$p(^PHARET(phret,"I",retchl),"^",8) 
 . . .q:adm="" 
 . . .s reasonid=$p(^PHARET(phret,"I",retchl),"^",6) 
 . . .
 . . .;q:(reasondr'=reasonid)&(reasondr'="")
 . . .s ward=$p(^PHARET(phret),"^",6)
 . . .i ward="" s ward="0"
 . . .s qty=-$p(^PHARET(phret,"I",retchl),"^",2)     ;qty数量
 . . .s price=$p(^PHARET(phret,"I",retchl),"^",4)  ;price价格
 . . .s amt=$p(^PHARET(phret,"I",retchl),"^",5)
 . . .s oedis=$p(^PHARET(phret,"I",retchl),"^",1)
 . . .q:oedis=""
 . . .s ord=$p(oedis,"||",1)
 . . .s chl=$p(oedis,"||",2)
 . . .s prescno=$p(^OEORD(ord,"I",chl,1),"^",14)
 . . .s inclb=""
 . . .
 . . .s retdate=$p(^PHARET(phret),"^",1)
 . . .s rettime=$p(^PHARET(phret),"^",2)
 . . .s bed=$p(^PHARET(phret,"I",retchl),"^",10)
 . . .s inci=$p(^PHARET(phret,"I",retchl),"^",11) 
 . . .s incicode="",incidesc=""
 . . .i inci'="" s incicode=$p($g(^INCI(inci,1)),"^",1),incidesc=$p($g(^INCI(inci,1)),"^",2)
 . . . 
 . . .s uom=$p(^INCI(inci,1),"^",10) i uom'="" s uomdesc=$p(^CT("UOM",uom),"^",2)
 . . .s warddesc="不详"
 . . .i ward>0  s warddesc=$p(^CTLOC(ward),"^",2)
 . . .
 . . .i $d(^TMP($j,"RETTOTAL",ward))  d
 . . . .s $p(^TMP($j,"RETTOTAL",ward),"^",2)=$p(^TMP($j,"RETTOTAL",ward),"^",2)+amt
 . . . .i adm'=retadm s $p(^TMP($j,"RETTOTAL",ward),"^",4)=$p(^TMP($j,"RETTOTAL",ward),"^",4)+retsum
 . . . .s $p(^TMP($j,"RETTOTAL",ward),"^",6)=$p(^TMP($j,"RETTOTAL",ward),"^",6)+1
 . . .e  d
 . . . .s ^TMP($j,"RETTOTAL",ward)=warddesc_"^"_amt_"^"_"0"_"^"_retsum_"^"_"0"_"^"_retcs   ;2007-01-09
 . . .s retadm=adm
 . . .s i=$o(^TMP($j,"RETINCI",ward,inci,""),-1)
 . . .s i=i+1
 . . .i retdate'="" s retdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(retdate,"IP")
 . . .i rettime'="" s rettime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(rettime,"IP")
 . . .s ^TMP($j,"RETINCI",ward,inci,i)=incicode_"^"_incidesc_"^"_uomdesc_"^"_qty_"^"_price_"^"_-amt_"^"_prescno_"^"_retdate_"^"_rettime_"^"_"退"
 . . 
 //以下统计发药  - 2007-01-09
 s phasum=1 ;发药人次
 s phaadm=""
 f dd=sdate:1:edate d
 . s phac=""
 . f  s phac=$o(^DHCPHAC(0,"PHA",phaloc,"DATE",dd,phac)) q:phac=""  d
 . . s ward=$p(^DHCPHAC(phac),"^",4)
 . . s warddesc=""
 . . i ward'="" d
 . . . &sql(select ward_locationDR into :ward from pac_ward where ward_rowid=:ward)
 . . . s warddesc=""
 . . . s ward=+ward
 . . . i $d(^CTLOC(ward)) d
 . . . . s warddesc=$p(^CTLOC(ward),"^",2)
 . . . e   d
 . . . . s warddesc="不详" 
 . . s ch=0
 . . f  s ch=$o(^DHCPHAC(phac,"I",ch)) q:ch=""  d
 . . . s adm=$p(^DHCPHAC(phac,"I",ch),"^",3)
 . . . s prescno=$p(^DHCPHAC(phac,"I",ch),"^",5)
 . . . s inclb=""
 . . . s inci=$p(^DHCPHAC(phac,"I",ch),"^",4)
 . . . s incicode=$p(^INCI(inci,1),"^",1)
 . . . s incidesc=$p(^INCI(inci,1),"^",2)
 . . . s uom=$p(^INCI(inci,1),"^",10) i uom'="" s uomdesc=$p(^CT("UOM",uom),"^",2)
 . . . s oedis=$p(^DHCPHAC(phac,"I",ch),"^",7)
 . . . s qty=$p(^DHCPHAC(phac,"I",ch),"^",6)
 . . . s dispamt="",price=""
 . . . s phaclb=""
 . . . f  s phaclb=$o(^DHCPHAC(phac,"I",ch,"B",phaclb)) q:phaclb=""  d
 . . . . s phaclbdata=^(phaclb)
 . . . . s dispamt=dispamt+$p(phaclbdata,"^",6) 
 . . . . i price="" s price=$p(phaclbdata,"^",5) 
 . . . ;<---如果把医生科室发药回归各病区则放开以下代码
 . . . ;i ward="" d 
 . . . ;.s phadmdr=$p(^DHCPHAC(phac,"I",ch),"^",3) ;admdr
 . . . ;.s warddr=$p(^PAADM(phadmdr),"^",70)
 . . . ;.s ward=$p($g(^PAWARD(warddr)),"^",5)
 . . . ;----------------------------------->
 . . . i ward="" s ward=..GetDocLoc(oedis) ;使用doctor loc,如果把医生科室发药单独作为病区统计则放开此行代码
 . . . q:ward=""
 . . . i (warddesc="") d
 . . . . i '$d(^CTLOC(ward)) d
 . . . . . s warddesc="不详" 
 . . . . e  d
 . . . . . s warddesc=$p(^CTLOC(ward),"^",2)
 . . . i $d(^TMP($j,"RETTOTAL",ward))  d
 . . . . s $p(^TMP($j,"RETTOTAL",ward),"^",3)=$p(^TMP($j,"RETTOTAL",ward),"^",3)+dispamt
 . . . . i adm'=phaadm s $p(^TMP($j,"RETTOTAL",ward),"^",5)=$p(^TMP($j,"RETTOTAL",ward),"^",5)+phasum
 . . . e  d
 . . . . s ^TMP($j,"RETTOTAL",ward)=warddesc_"^"_"0"_"^"_dispamt_"^"_"0"_"^"_phasum_"^"_"0"  ;2007-01-09
 . . . s phaadm=adm
 . . . s i=$o(^TMP($j,"RETINCI",ward,inci,""),-1)
 . . . s i=i+1
 . . . 
 . . . s dispdate=$p(^DHCPHAC(phac),"^",2)
 . . . s disptime=$p(^DHCPHAC(phac),"^",3)
 . . . i dispdate'="" s dispdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(dispdate,"IP")
 . . . i disptime'="" s disptime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(disptime,"IP")
 . . . s ^TMP($j,"RETINCI",ward,inci,i)=incicode_"^"_incidesc_"^"_uomdesc_"^"_qty_"^"_price_"^"_dispamt_"^"_prescno_"^"_dispdate_"^"_disptime_"^"_"发"
 //----------------- ^ 2007-01-09
 q:$o(^TMP($j,"RETTOTAL",""))="" ""
 q $j
}

ClassMethod ListWardRet(pno, ward)
{
 n (pno, ward)
 q:pno="" ""
 s newward=$o(^TMP(pno,"RETTOTAL",ward))   
 q:newward="" ""
 q newward_"^"_$p(^(newward),"^",1)_"^"_$p(^(newward),"^",2)_"^"_$p(^(newward),"^",3)  ;2007-01-09 modified
}

ClassMethod SetWardInci(pno, ward)
{
 n (pno, ward)
 q:ward="" ""
 s inci=""
 k ^TMP(pno,"mPLIST")
 s i=0
 f  s inci=$o(^TMP(pno,"RETINCI",ward,inci)) q:inci=""  d
 . s num=""
 . f  s num=$o(^TMP(pno,"RETINCI",ward,inci,num)) q:num=""  d
 . . s i=i+1
 . . s ^TMP(pno,"mPLIST",i)=^TMP(pno,"RETINCI",ward,inci,num)
 q i
}

ClassMethod ListWardInci(pno, i)
{
 q ^TMP(pno,"mPLIST",i)
}

ClassMethod KillWardRetGlbal(pno)
{
 q:pno=""
 k ^TMP(pno,"RETTOTAL")
 k ^TMP(pno,"RETINCI")  
 k ^TMP(pno,"mPLIST")  
 q
}

ClassMethod GetPLIST(i As %Integer) As %String
{
 q:i="" ""
 q:'$d(^TMP($j,"PLIST",i)) ""
 q ^TMP($j,"PLIST",i)
}

ClassMethod ClearAllTmp(pno)
{
 q:pno=""
 k ^TMP(pno,"RETTOTAL")
 k ^TMP(pno,"RETINCI")    
 k ^TMP(pno,"INCITOTAL")
 k ^TMP(pno,"INCI")
}

/// w ##class(%ResultSet).RunQuery("web.DHCSTDISPSTAT","WorkStat","07/11/2018","07/11/2018","317","1","0")
ClassMethod WorkStatExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, displocrowid As %String, StatType As %String, CheckUser As %String) As %Status
{
	n (qHandle,StartDate,EndDate,displocrowid,StatType,CheckUser)
	s ^TMPDHCSTPARAMS("web.DHCSTDISPSTAT","WorkStat")=$lb(StartDate,EndDate,displocrowid,StatType,CheckUser)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	q:StartDate="" $$$OK
 	q:EndDate="" $$$OK
	s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
 	i CheckUser="on" s CheckUser=1 
    e  s CheckUser=0
 	s queryRet=..QueryWork(StartDate,EndDate,displocrowid,StatType,CheckUser)
 	s pid=$p(queryRet,"^",1)
 	s cnt=$p(queryRet,"^",2)
 	q:(cnt=0)||(pid="") $$$OK
 	s sumamt=0
 	s sumnum=0
 	s sumtype=0
 	s sumnum1=0
 	s sumnum2=0
 	s sumnum3=0
 	s sumnum4=0
 	s sumnum5=0 ;味数
 	s sumretnum=0
 	s sumretamt=0
 	s sumretque=0
 	s sumretfac=0
 	s sumoutque=0
 	s sumoutfac=0
 	s sumoutqueamt=0

 	f i=1:1:cnt  d
 	. s tmps=..ListWork(i,pid)
 	. q:tmps=""
  	. s sumtype=$g(sumtype)+$p(tmps,"^",3)
 	. s sumamt=$g(sumamt)+$p(tmps,"^",4)
 	. s sumnum=$g(sumnum)+$p(tmps,"^",5)
 	. s sumnum1=$g(sumnum1)+$p(tmps,"^",6)
 	. s sumnum2=$g(sumnum2)+$p(tmps,"^",7)
 	. s sumnum3=$g(sumnum3)+$p(tmps,"^",8)
 	. s sumnum4=$g(sumnum4)+$p(tmps,"^",9)
 	. s sumnum5=$g(sumnum5)+$p(tmps,"^",10)
 	. s sumretnum=$g(sumretnum)+$p(tmps,"^",11)
 	. s sumretamt=$g(sumretamt)+$p(tmps,"^",12)
 	. s sumretque=$g(sumretque)+$p(tmps,"^",13)
 	. s sumretfac=$g(sumretfac)+$p(tmps,"^",14)
 	. s sumoutque=$g(sumoutque)+$p(tmps,"^",15)
 	. s sumoutfac=$g(sumoutfac)+$p(tmps,"^",16)
 	. s sumoutqueamt=$g(sumoutqueamt)+$p(tmps,"^",17)
 	. d OutputRow
 	k ^TMP("DHCST",$ClassName(),"QueryWorkData",pid)
 	;输出合计
 	d OutputRowWorkSum
 	q $$$OK
OutputRow
	s UserCode=$p(tmps,"^",1)
	s UserName=$p(tmps,"^",2)
	s Work=$p(tmps,"^",3)
	s DispAmt=$p(tmps,"^",4)
	s DispNoNum=$p(tmps,"^",5)
	s FacSum=$p(tmps,"^",6) ;代煎剂数
	s FacSum1=$p(tmps,"^",7) ;代煎处方张数
	s Quenum=$p(tmps,"^",8) ; 处方张数
	s Quefacnum=$p(tmps,"^",9)  ;处方剂数
	s Ws=$p(tmps,"^",10)  ;味数
	s RetNum=$p(tmps,"^",11)
	s RetAmt=$p(tmps,"^",12)
	s RetQue=$p(tmps,"^",13)
	s RetFac=$p(tmps,"^",14)
	s OutQue=$p(tmps,"^",15)
	s OutFac=$p(tmps,"^",16)
	s OutQueAmt=$p(tmps,"^",17)
	s OutQueAmt=$fn(OutQueAmt,"",2)
	s AmtTotal=DispAmt-RetAmt
	;
 	s Data=$lb(UserCode,UserName,Work,DispAmt,DispNoNum,FacSum,FacSum1,Quenum,Quefacnum,Ws,RetNum,RetAmt,AmtTotal,RetQue,RetFac,OutQue,OutFac,OutQueAmt)
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
OutputRowWorkSum
 	s UserCode="合计"
 	s UserName=""
 	s DispAmt=sumamt
 	s DispNoNum=sumnum
 	s Work=sumtype
 	s FacSum=sumnum1
 	s FacSum1=sumnum2
 	s Quenum=sumnum3
 	s Quefacnum=sumnum4
 	s Ws=sumnum5
 	s RetNum=sumretnum
 	s RetAmt=sumretamt
 	s AmtTotal=DispAmt-RetAmt
 	s RetQue=sumretque
 	s RetFac=sumretfac
 	s OutQue=sumoutque
 	s OutFac=sumoutfac
 	s OutQueAmt=sumoutqueamt
 	s OutQueAmt=$fn(OutQueAmt,"",2)
	;
 	s Data=$lb(UserCode,UserName,Work,DispAmt,DispNoNum,FacSum,FacSum1,Quenum,Quefacnum,Ws,RetNum,RetAmt,AmtTotal,RetQue,RetFac,OutQue,OutFac,OutQueAmt)
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod WorkStatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = WorkStatExecute ]
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

ClassMethod WorkStatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = WorkStatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query WorkStat(StartDate As %String, EndDate As %String, displocrowid As %String, StatType As %String, CheckUser As %String) As %Query(ROWSPEC = "UserCode:%String,UserName:%String,Work:%String,DispAmt:%Double,DispNoNum:%String,FacSum:%String,FacSum1:%String,Quenum:%String,Quefacnum:%String,Ws:%String,RetNum:%String,RetAmt:%Double,AmtTotal:%Double,RetQue:%String,RetFac:%String,OutQue:%String,OutFac:%String,OutQueAmt:%Double")
{
}

ClassMethod WardRetClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = WardRetExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod WardRetExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, displocrowid As %String) As %Status
{
 Set repid=$I(^CacheTemp)
 Set qHandle=$lb(0,repid,0)
 Set ind=1
 Do ResetVariables1
 q:StartDate="" $$$OK
 q:EndDate="" $$$OK
 q:displocrowid="" $$$OK
 s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
 s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate) 
 s retamttotal=0
 s dispamttotal=0
 s dispamtall=0
 
 s processno=..PhaRetTotal(StartDate,EndDate,displocrowid)
 q:processno="" $$$OK
 s wdrowid="" 
 f   s data=..ListWardRet(processno,wdrowid) q:data=""  d
 . d OutputRow1
 d OutPutWardDispSum
 Quit $$$OK

OutputRow1
 s WardRowid=$p(data,"^",1)      
 s Ward=$p(data,"^",2)
 s PhaRetAmt=$p(data,"^",3)
 s PhaDispAmt=$p(data,"^",4)    ;2007-01-09 add
 s PhaDispSum=PhaDispAmt-PhaRetAmt ;2007-01-09 add
 ;
 s wdrowid=WardRowid  ; Pass the current ward rowid !!!!!!!!!
 ;
 s retamttotal=retamttotal+PhaRetAmt
 s dispamttotal=dispamttotal+PhaDispAmt
 s dispamtall=dispamtall+PhaDispSum
 ;
 s Data=$lb(processno,WardRowid,Ward,-$fn(PhaRetAmt,"",2),$fn(PhaDispAmt,"",2),$fn(PhaDispSum,"",2))  ;2007-01-09 modified
 s ^CacheTemp(repid,ind)=Data    
 s ind=ind+1
 q
ResetVariables1
 s (processno,WardRowid,Ward,PhaRetAmt,PhaDispAmt,PhaDispSum)=""
 q
OutPutWardDispSum
 s WardRowid=""
 s Ward="合计"
 s PhaRetAmt=retamttotal
 s PhaDispAmt=dispamttotal  
 
 s PhaDispSum=dispamtall  ;2007-01-09 add
 ;s PhaDispSum=$fn(PhaDispSum,"",2)
 s Data=$lb(processno,WardRowid,Ward,-$fn(PhaRetAmt,"",2),$fn(PhaDispAmt,"",2),$fn(PhaDispSum,"",2))  ;2007-01-09 modified
 s ^CacheTemp(repid,ind)=Data    
 s ind=ind+1
 q
}

ClassMethod WardRetFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = WardRetExecute ]
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

Query WardRet(StartDate As %String, EndDate As %String, displocrowid As %String) As %Query(ROWSPEC = "ProcessID:%String,WardRowid:%String,Ward:%String,PhaRetAmt:%String,PhaDispAmt:%String,PhaDispSum:%String")
{
}

ClassMethod DispStatGenerallyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DispStatGenerallyExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCSTDISPSTAT","DispStatGenerally","2019-06-14","2019-06-24","246","","^id","","^^","","","00:00","23:59","","","","","^^0^0^0^0^")
ClassMethod DispStatGenerallyExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, displocrowid As %String, wardrowid As %String, dispoperrowid As %String, dispcatval As %String, PhcCatRowidStr As %String, incirowid As %String, admlocrowid As %String, StartTime As %String, EndTime As %String, DoctorLocRowid As %String, PhcFormRowID As %String, RegNo As %String, CManGroupID As %String, Str As %String) As %Status
{
 Set repid=$I(^CacheTemp)
 Set qHandle=$lb(0,repid,0)
 Set ind=1
 set totalmoney=0
 set totaldisp=0
 set totalret=0
 s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
 s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
 s StartTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(StartTime)
 s EndTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(EndTime)
 i dispoperrowid["^" d
 .i ($p(dispoperrowid,"^",2)="id")&&($p(dispoperrowid,"^",1)'="") s dispoperrowid=$p($g(^SSU("SSUSR",+dispoperrowid)),"^",1)
 s processno=..Query(StartDate,EndDate,displocrowid,wardrowid,dispoperrowid,dispcatval,PhcCatRowidStr,incirowid,admlocrowid,StartTime,EndTime,DoctorLocRowid,PhcFormRowID,RegNo,CManGroupID,Str) 
 q:processno="" $$$OK
 s incicode=""
 f  s dd=..LData(processno,incicode)  q:(dd="")  d
 . d OutputRow2
 . 
 d OutPutTotal
 Quit $$$OK

OutputRow2      
 s incicode=$p(dd,"^",1)
 s incidesc=$p(dd,"^",2)
 s pakuom=$p(dd,"^",3)
 s qty=$fn($p(dd,"^",4),"N")
 s money=$p(dd,"^",5)
 ;--------add by lq------------
 s gname=$p(dd,"^",6)
 s Specifaction=$p(dd,"^",7)
 s fname=$p(dd,"^",8)
 s mname=$p(dd,"^",9)
 s price=$p(dd,"^",10)
 ;-----------------------
 s dispqty=$p(dd,"^",11)
 s dispqty=..PackUomQtyDesc(incicode,dispqty)  //按整包装数显示发药
 s dispamt=$p(dd,"^",12)
 s retqty=$p(dd,"^",13)
 s retamt=$p(dd,"^",14)
 s packprice=$p(dd,"^",15)
 s packuomqtydesc=..PackUomQtyDesc(incicode,qty)  //按整包装数显示发药
 s totalmoney=totalmoney+money
 s totaldisp=totaldisp+dispamt
 s totalret=totalret+retamt
 i totalmoney["." s totalmoney=$fn(totalmoney,"",$l($p(totalmoney,".",2)))
 i totaldisp["." s totaldisp=$fn(totaldisp,"",$l($p(totaldisp,".",2)))
 i price["." s price=$fn(price,"",$l($p(price,".",2)))
 i packprice["." s packprice=$fn(packprice,"",$l($p(packprice,".",2)))
 i dispamt["." s dispamt=$fn(dispamt,"",$l($p(dispamt,".",2)))
 i retamt["." s retamt=$fn(retamt,"",$l($p(retamt,".",2)))

 s Data=$lb(processno,incicode,incidesc,qty,pakuom,money,gname,Specifaction,fname,mname,price,dispqty,dispamt,retqty,retamt,packuomqtydesc,packprice)
 s ^CacheTemp(repid,ind)=Data    
 s ind=ind+1
 q
OutPutTotal
 i totalmoney["." s totalmoney=$fn(totalmoney,"",$l($p(totalmoney,".",2)))
 i totaldisp["." s totaldisp=$fn(totaldisp,"",$l($p(totaldisp,".",2)))
 i totalret["." s totalret=$fn(totalret,"",$l($p(totalret,".",2)))
 s Data=$lb("","合计","","","",totalmoney,"","","","","","",totaldisp,"",totalret) 
 s ^CacheTemp(repid,ind)=Data    
 s ind=ind+1
 q 
ResetVariables2 
 q
}

ClassMethod DispStatGenerallyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DispStatGenerallyExecute ]
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

Query DispStatGenerally(StartDate As %String, EndDate As %String, displocrowid As %String, wardrowid As %String, dispoperrowid As %String, dispcatval As %String, PhcCatRowidStr As %String, incirowid As %String, admlocrowid As %String, StartTime As %String, EndTime As %String, DoctorLocRowid As %String, PhcFormRowID As %String, RegNo As %String, CManGroupID As %String, Str As %String) As %Query(ROWSPEC = "TPID:%String,TCode:%String,TDesc:%String,TDispQty:%String,TUom:%String,TDispAmt:%String,Tgname:%String,Tbcode:%String,Tfname:%String,Tmname:%String,Tprice:%String,TQty:%String,TAmt:%String,TRetQty:%String,TRetAmt:%String,TPackUomQty:%String,TPackPrice:%String")
{
}

ClassMethod DispStatGenarallyDetailExecute(ByRef qHandle As %Binary, ProcessID As %String, Code As %String) As %Status
{
 n (qHandle,ProcessID,Code)
 Set repid=$I(^CacheTemp) 
 Set qHandle=$lb(0,repid,0)
 Set ind=1
 q:(ProcessID="")||(Code="") $$$OK
 s n=""
 f  s n=$o(^TMP("DHCSTDISPSTAT","Query","INCI",ProcessID,Code,n)) q:n=""  d   
 .s tmpdata=$g(^TMP("DHCSTDISPSTAT","Query","INCI",ProcessID,Code,n))
 .d OutputRow3
 Quit $$$OK
  
OutputRow3      
 ;
 s TRegNo=$p(tmpdata,"^",1)
 s TName=$p(tmpdata,"^",2)
 s TBedNo=$p(tmpdata,"^",3)
 s TAdmLoc=$p(tmpdata,"^",4)
 s TPrescNo=$p(tmpdata,"^",5)
 s TCode=$p(tmpdata,"^",6)
 s TDesc=$p(tmpdata,"^",7)
 s TDoseQty=$p(tmpdata,"^",8)
 s TDrugForm=$p(tmpdata,"^",9)
 s TUomDesc=$p(tmpdata,"^",10)
 s TSalePrice=$p(tmpdata,"^",11)
 s TSalePrice=$fn(TSalePrice,"N")
 s TQty=$fn($p(tmpdata,"^",12),"N")
 s TAmt=$fn($p(tmpdata,"^",13),"N")
 ;--------------add by lq ------------
 s TSex=$p(tmpdata,"^",15) 
 s Tpaold=$p(tmpdata,"^",16)
 s Tdiag=$p(tmpdata,"^",17)
 S Tptime=$p(tmpdata,"^",18)
 s Tdoctor=$p(tmpdata,"^",19)
 s Toedate=$p(tmpdata,"^",20)
 s Tfreq=$p(tmpdata,"^",21)
 s Taction=$p(tmpdata,"^",22)
 s Tpackprice=$p(tmpdata,"^",23)
 s TEncryptLevel=$p(tmpdata,"^",24)
 s TPatLevel=$p(tmpdata,"^",25)
 s Data=$lb(TRegNo,TName,TBedNo,TAdmLoc,TPrescNo,TCode,TDesc,TDoseQty,TDrugForm,TUomDesc,TSalePrice,TQty,TAmt,TSex,Tpaold,Tdiag,Tptime,Tdoctor,Toedate,Tfreq,Taction,Tpackprice,TEncryptLevel,TPatLevel)
 s ^CacheTemp(repid,ind)=Data    
 s ind=ind+1
 q

ResetVariables3
 s (TRegNo,TName,TBedNo,TAdmLoc,TPrescNo,TCode,TDesc,TDoseQty,TDrugForm,TUomDesc,TSalePrice,TQty,TAmt,TSex,Tpaold,Tdiag,Tptime,Tdoctor,Toedate,Tfreq,Taction,Tpackprice,TEncryptLevel,TPatLevel)=""
 q
}

ClassMethod DispStatGenarallyDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DispStatGenarallyDetailExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod DispStatGenarallyDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DispStatGenarallyDetailExecute ]
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

Query DispStatGenarallyDetail(ProcessID As %String, Code As %String) As %Query(ROWSPEC = "TRegNo:%String,TName:%String,TBedNo:%String,TAdmLoc:%String,TPrescNo:%String,TCode:%String,TDesc:%String,TDoseQty:%String,TDrugForm:%String,TUomDesc:%String,TSalePrice:%String,TQty:%String,TAmt:%String,TSex:%String,Tpaold:%String,Tdiag:%String,Tptime:%String,Tdoctor:%String,Toedate:%String,Tfreq:%String,Taction:%String,TPackPrice:%String,TEncryptLevel:%String,TPatLevel:%String")
{
}

ClassMethod WardRetItmExecute(ByRef qHandle As %Binary, ProcessID As %String, WardRowid As %String) As %Status
{
 Set repid=$I(^CacheTemp)
 Set qHandle=$lb(0,repid,0)
 Set ind=1
 d ResetVariables4
 q:ProcessID="" $$$OK
 q:WardRowid="" $$$OK
 s cnt=..SetWardInci(ProcessID,WardRowid)
 f i=1:1:cnt d
 . s tmpdata=..ListWardInci(ProcessID,i)
 . ;
 . d OutputRow4
 k ^TMP(ProcessID,"mPLIST")
 Quit $$$OK
  
OutputRow4      
 s RetDate=$p(tmpdata,"^",8)
 s RetTime=$p(tmpdata,"^",9)
 s PrescNo=$p(tmpdata,"^",7)
 s Code=$p(tmpdata,"^",1)
 s Desc=$p(tmpdata,"^",2)
 s Uom=$p(tmpdata,"^",3)
 s RetQty=$p(tmpdata,"^",4)
 s RetAmt=$p(tmpdata,"^",6)
 s IssueType=$p(tmpdata,"^",10)
 ;
 s Data=$lb(RetDate,RetTime,PrescNo,Code,Desc,Uom,RetQty,$fn(RetAmt,"",2),IssueType)
 s ^CacheTemp(repid,ind)=Data    
 s ind=ind+1
 q

ResetVariables4
 s (RetDate,RetTime,PrescNo,Code,Desc,Uom,RetQty,RetAmt,IssueType)=""
 q
}

ClassMethod WardRetItmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = WardRetItmExecute ]
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

ClassMethod WardRetItmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = WardRetItmExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

Query WardRetItm(ProcessID As %String, WardRowid As %String) As %Query(ROWSPEC = "RetDate:%String,RetTime:%String,PrescNo:%String,Code:%String,Desc:%String,Uom:%String,RetQty:%String,RetAmt:%String,IssueType:%String")
{
}

ClassMethod DocLocRowid(user As %String) As %String
{
 n (user)
 q:user="" ""
 s defaultloc=$p(^SSU("SSUSR",+user),"^",4)
 q defaultloc
}

ClassMethod GetDocLoc(oedis As %String) As %String
{
  //2007-01-09
 q:oedis="" ""
 s ord=$p(oedis,"||",1)
 s itm=$p(oedis,"||",2)
 s useradddept=$p(^OEORD(ord,"I",itm,7),"^",2)   ;060725 
 q $g(useradddept)
}

ClassMethod DispCatByOEDIS(oedis)
{
 n (oedis)
 q:oedis="" ""
 s reclocdr=$p($g(^OEORD(+oedis,"I",$p(oedis,"||",2),3)),"^",6)
 s dispcat=##Class(web.DHCSTCOMMONSRV).GetDspCatId(oedis,"",reclocdr)
 q dispcat
}

ClassMethod CheckMinorCat(minorcat, arcimid)
{
 n (minorcat, arcimid)
 q:minorcat="" 1
 s minorcatdr=..PhaMinorSubCatByArcim(arcimid) 
 s catdr=+minorcatdr
 s subcat=$p(minorcatdr,"||",2)
 s minor=$p(minorcatdr,"||",3)
 s minordesc=$p(^PHCC(catdr,"SC",subcat,"MIN",minor),"^",2)
 i $f(minordesc,minorcat) s ret=1
 e  s ret=0
 q ret
}

ClassMethod PackUomQtyDesc(incicode As %String, qty As %String) As %String
{
 ;取整单位数量描述串
 ;根据qty(基本单位)得出整包装单位数量
 n (incicode,qty)
 s nega=0
 i qty<0 s nega=1
 s result=""
 &sql(select inci_ctuom_dr,inci_ctuom_purch_dr into :buom,:puom from inc_itm where inci_code=:incicode)
 q:SQLCODE ""
 s buom=+$g(buom) q:buom'>0 ""
 s puom=+$g(puom) q:puom'>0 ""
 s buomdesc=$p(^CT("UOM",buom),"^",2)
 s puomdesc=$p(^CT("UOM",puom),"^",2)
 i buom=puom q $fn(qty,"N")_buomdesc
 s fac=##class(web.DHCSTCOMMONSRV).UOMFac(puom,buom)
 s packqty=qty\fac
 s restqty=qty-(packqty*fac)
 s packqty=$fn(packqty,"N")
 s restqty=$fn(restqty,"N")
 i $zabs(packqty)>0 d
 . s result=packqty_puomdesc
 i $zabs(restqty)>0 d
 . i result'="" d
 . . s result=result_"  "_restqty_buomdesc
 . e  d
 . . s result=restqty_buomdesc
 i result="" s result=0_puomdesc
 q result
}

ClassMethod PriortyCode(oeori As %String) As %String
{
 //取得医嘱优先级
 n (oeori)
 s ord=$p(oeori,"||",1),chl=$p(oeori,"||",2)
 q:ord="" ""
 q:chl="" ""
 s priority=$p($g(^OEORD(ord,"I",chl,1)),"^",8)
 i priority'="" s prioritycode=$p(^OECPR(priority),"^",1)
 q $G(prioritycode)
}

ClassMethod UserDept(oeori As %String) As %String
{
 //取得userDepartmentLoc - 医生科室
 n (oeori)
 s ord=$p(oeori,"||",1),chl=$p(oeori,"||",2)
 q:ord="" ""
 q:chl="" ""
 s userdept=$p($g(^OEORD(ord,"I",chl,7)),"^",2)
 q $g(userdept)
}

ClassMethod Linked(oeori As %String) As %String
{
 //判断医嘱是否是医生科室医嘱
 // 1- 是 0 - 不是
 // 
 n (oeori)
 s ord=$p(oeori,"||",1),chl=$p(oeori,"||",2)
 q:ord="" 0
 q:chl="" 0
 s userdept=$p($g(^OEORD(ord,"I",chl,7)),"^",2)  //医嘱科室
 q:userdept="" 0
 s recloc=$p($g(^OEORD(ord,"I",chl,3)),"^",6)  //医嘱接收科室
 q:recloc="" 0
 s childsub=$O(^CTLOC(recloc,"LINK",0,"Loc",userdept,""))
 q:+childsub=0 0
 q 1
}

/// Creator:LiangQiang
/// CreatDate:2009-05-12
/// Description:保存发药综合查询打印信息：发药科室_"^"_病区_"^"_时间
/// Table:^DHCDispGenerally
/// Input:displocrowid,sdate,stime,edate,etime,warddr
/// Output:0 -成功 ,-1 -失败
/// Return:0 -成功 ,-1 -失败
/// Others:
ClassMethod SaveRecord(displocrowid, sdate, stime, edate, etime, warddr, userid) As %String
{
  n (displocrowid,sdate,stime,edate,etime,warddr,userid)
  
  q:displocrowid="" -1
  q:sdate="" -2
  q:warddr="" -3
  i sdate'="" s sdate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(sdate)
  i stime'="" s stime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(stime)
  i edate'="" s edate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(edate)
  i etime'="" s etime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(etime)
  i stime=""  s stime=$zth("00:00:00",1)
  i etime=""  s etime=$p($h,",",2)
  s prtdate=$h
  ;Save
  s ^DHCDispGenerally("sDate",displocrowid,warddr,sdate)=displocrowid_"^"_warddr_"^"_sdate_"^"_edate_"^"_stime_"^"_etime_"^"_userid_"^"_prtdate
  s ^DHCDispGenerally("eDate",displocrowid,warddr,edate)=displocrowid_"^"_warddr_"^"_sdate_"^"_edate_"^"_stime_"^"_etime_"^"_userid_"^"_prtdate
  s ret=1
  q +$g(ret)
}

/// Creator:Liang Qiang
/// CreatDate:2009-05-13
/// Description:获取供给记录
/// Table:^DHCDispGenerally
/// Input:Str - 开始日期_"^"_结束日期_"^"_开始时间_"^"_结束时间_"^"_病区ID_"^"_发药科室ID
/// Ouput:供给记录
/// Return:供给记录
/// Others:
ClassMethod ShowSupplyRecordExecute(ByRef qHandle As %Binary, Str As %String) As %Status
{
    s repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s ind=1
     
    s sdate=$p(Str,"^",1)
    s edate=$p(Str,"^",2)
    s stime=$p(Str,"^",3)
    s etime=$p(Str,"^",4)
    s warddr=$p(Str,"^",5)
    s displocrowid=$p(Str,"^",6)
    
    i sdate'="" s sdate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(sdate)
    i stime'="" s stime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(stime)
    i edate'="" s edate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(edate)
    i etime'="" s etime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(etime)
    
    i sdate="" w !,"请选择开始日期后再试..."
    q:sdate="" $$$OK
    i displocrowid="" w !,"请选择发药科室后再试..."
    q:displocrowid="" $$$OK
    i warddr="" w !,"请选择病区后再试..."
    q:warddr="" $$$OK

    s date=""
    f  s date=$o(^DHCDispGenerally("sDate",displocrowid,warddr,date)) q:date=""  d
    .q:date<sdate
    .s info=^DHCDispGenerally("sDate",displocrowid,warddr,date)
    .s tmpstime=$p(info,"^",5)
    .i (stime'="")&&(date=sdate) q:stime>tmpstime
    .s tmpedate=$p(info,"^",4)
    .i edate'="" q:tmpedate>edate
    .s tmpetime=$p(info,"^",6)
    .i (etime'="")&&(date=edate) q:etime<tmpetime
    .s stime=$p(info,"^",5)
    .s etime=$p(info,"^",6)
    .s userid=$p(info,"^",7)
    .s prtdatestr=$p(info,"^",8)
    .s prtdate=+prtdatestr
    .s prttime=$p(prtdatestr,",",2)
    .s prtdatetime=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(prtdate,"IP")_","_##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(prttime,"IP")
    .s user=$p(^SSU("SSUSR",userid),"^",2)
    .s disploc=$p(^CTLOC(displocrowid),"^",2)
    .s ward=$p(^PAWARD(warddr),"^",2)
    .d OutRowRecord
	Quit $$$OK
	
OutRowRecord
	set Data=$lb(disploc,##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(date,"IP"),ward,##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(tmpedate,"IP"),##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(tmpstime,"IP"),##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(tmpetime,"IP"),user,warddr,displocrowid,prtdatetime)   //所对应传出的列名
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod ShowSupplyRecordFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ShowSupplyRecordExecute ]
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

Query ShowSupplyRecord(Str As %String) As %Query(ROWSPEC = "Tloc:%String,Tsdate:%String,Tward:%String,Tedate:%String,Tstime:%String,Tetime:%String,Tuser:%String,Twarddr:%String,Tdisplocrowid:%String,Tprtdatetime:%String")
{
}

ClassMethod ShowSupplyRecordClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ShowSupplyRecordExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Creator:Liang Qiang
/// CreatDate:2009-05-13
/// Description:获取供给时间:上次供给时间+1
/// Table:^DHCDispGenerally
/// Input:发药科室Rowid,病区Rowid
/// Ouput:flag(0,首次补给,1非首次补给 )_"^"_供给日期_"^"_时间
/// Return:
/// Others:
ClassMethod CreateLastSupply(displocrowid, warddr) As %String
{
  n (displocrowid, warddr)
  i '$d(^DHCDispGenerally("eDate",displocrowid,warddr)) d
  .s sdate=+$h
  .s sdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(sdate,"IP")
  .s stime=$p($h,",",2)
  .s stime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(stime,"IP")
  .s flag=0
  e  d
  .s sdate=$o(^DHCDispGenerally("eDate",displocrowid,warddr,""),-1)
  .s info=^DHCDispGenerally("eDate",displocrowid,warddr,sdate)
  .s stime=$p(info,"^",6)
  .i stime=$zth("23:59:59",1) d
  ..s sdate=sdate+1
  ..s stime=0
  .e  d
  ..s stime=stime+1
  .s flag=1
  .s sdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(sdate,"IP")
  .s stime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(stime,"IP")
  q flag_"^"_sdate_"^"_stime
}

/// Description:获取发药时整包装单价
/// Creator:Liang Qiang 
/// CreatDate:2009-10-30
/// Input:库存项Rowid,发药日期
/// Output:入库单位售价
ClassMethod Getpuomprice(inci, date, hospid = "") As %String
{
	n (inci,date,hospid)
	s fac=1
	s buom=+$p(^INCI(inci,1),"^",10)  ; basic uom
	s puom=+$p(^INCI(inci,3),"^",6)  ; 
	i puom="" s puom=buom
	s buomdesc=$p(^CT("UOM",buom),"^",2)
	s puomdesc=$p(^CT("UOM",puom),"^",2)
	s fac=##class(web.DHCSTCOMMONSRV).UOMFac(puom,buom)
	s price=##class(web.DHCSTPRICE).GetSp(+inci,date,puom,hospid,"")
	q price
}

/// Description:每次刷新前kill
/// Creator:zdm
ClassMethod KillBeforeLoad(pid) As %String
{
	n (pid)
	q:pid=""
	k ^TMP("DHCSTDISPSTAT","Query","INCITOTAL",pid)
    k ^TMP("DHCSTDISPSTAT","Query","INCI",pid)
	q
}

/// Description:医嘱项对应药学分类是否在选定药学分类下
/// Creator:caoting
ClassMethod NewPhCatByArcim(newcatid, arcim) As %String
{
 n (newcatid,arcim)
 s sub=$p(arcim,"||",1)
 s ver=$p(arcim,"||",2)
 s phcdf=$P(^ARCIM(sub,ver,1),"^",12) q:phcdf="" ""
 s phcd=+phcdf
 s DF=$p(phcdf,"||",2)
 s newcatdr=$p(^PHCD(phcd,"DF",DF,"DHC"),"^",20)
 s ret=0
 s ret=..IncludeCat(newcatdr,newcatid,ret)
 q ret
}

ClassMethod IncludeCat(catdr, newcatid, ret) As %String
{
	n (catdr,newcatid,ret)
	s parcatdr=$p(^DHCPHCC(catdr),"^",3)
	q:parcatdr=0 ret
	i parcatdr=newcatid s ret=1
	e  s ret=..IncludeCat(parcatdr,newcatid,ret)
	q ret
}

/// description: 统计发药品种数
/// w ##class(web.DHCSTDISPSTAT).CalcuPhacCount(81)
ClassMethod CalcuPhacCount(PhacId)
{
	n (PhacId)
	k CalcuPhacCountData
	s count=0
	q:+PhacId=0 0
	s phacItm=0
	f  s phacItm=$o(^DHCPHAC(PhacId,"I",phacItm)) q:phacItm=""  d
	.s phacLb=0
	.f  s phacLb=$o(^DHCPHAC(PhacId,"I",phacItm,"B",phacLb)) q:phacLb=""  d
	..s inclb=$p(^DHCPHAC(PhacId,"I",phacItm,"B",phacLb),"^",1)
	..s incId=+inclb
	..q:$d(CalcuPhacCountData(incId))
	..s CalcuPhacCountData(incId)=""
	..s count=count+1
	q count
}

ClassMethod NewPid()
{
  q ##class(web.DHCSTKUTIL).NewPid($ClassName(),"IP")
}

}
