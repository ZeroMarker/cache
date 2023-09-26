Import sqluser

/// Descript:	针对垃圾数据的清理以及补数据的信息的类
/// Creater:	yunhaibao
/// CreateDate:	2016-02-16
/// Others:
Class web.DHCST.SystemTools Extends %RegisteredObject [ ProcedureBlock ]
{

/// creator:yunhaibao
/// createdate:2016-02-16
/// description:清科室货位垃圾数据
/// tables:DHC_IncItmLocBin
/// w ##class(web.DHCST.SystemTools).ClearDHCLocBinDirtyData()
ClassMethod ClearDHCLocBinDirtyData()
{
	s num=0,wnum=0
	s dhcstkbin=""
	f  s dhcstkbin=$o(^DHCINCILB(dhcstkbin)) q:dhcstkbin=""  d
	.q:+dhcstkbin=0
	.s incil=$p(^DHCINCILB(dhcstkbin),"^",1)
	.q:+$p(incil,"||",2)=0
	.s stkbin=$p(^DHCINCILB(dhcstkbin),"^",2)
	.q:'$d(^INC("SB",stkbin))
	.s stkbincode=$p(^INC("SB",stkbin),"^",1)
	.s stkbinloc=$p(stkbincode,"P",1)
	.s inci=+incil,incich=$p(incil,"||",2)
	.s inciloc=$p(^INCI(inci,"IL",incich),"^",1)
	.i stkbinloc'=inciloc d //这俩科室不等,说明货位和药品不在同一科室
	..&SQL(DELETE FROM DHC_IncItmLocBin WHERE INCILB_ROWID=:dhcstkbin)
	..i SQLCODE=0 s num=num+1
	..e  s wnum=wum+1
	q "删除成功记录数:"_num_",失败记录数:"_wnum
}

/// creator:yunhaibao
/// createdate:2016-03-08
/// description:科室批次库存附加表数据,因上线前清数据可能漏清,导致上线后入库审核失败
/// tables:DHC_INCItmLcBt
/// 注意:批次价模式,涉及批次在途数,上线前需第一时间处理,否则执行后在途会清0
/// w ##class(web.DHCST.SystemTools).RebuildDHCINCLB()
ClassMethod RebuildDHCINCLB()
{
	&SQL(delete from DHC_INCItmLcBt)
	k ^DHCINCLB(0,"A")
	k ^DHCINCLB(0,"LB")
	k ^DHCINCLB(0,"Y")
	k ^DHCINCLB(0,"N")
	s inci="0"
	f  s inci=$o(^INCI(inci)) q:inci=""  d
	.s incil=""
	.f  s incil=$o(^INCI(inci,"IL",incil)) q:incil=""  d
	..s inclb=""
	..f  s inclb=$o(^INCI(inci,"IL",incil,"LB",inclb)) q:inclb=""  d
	...q:inclb=0
	...s inclbstr=inci_"||"_incil_"||"_inclb
	...s incib=$p(^INCI(inci,"IL",incil,"LB",inclb),"^",1)
	...q:$p(incib,"||",2)=""
	...q:'$d(^INCI(+incib,"IB",$p(incib,"||",2)))
	...s expdate=$p(^INCI(+incib,"IB",$p(incib,"||",2)),"^",2)
	...s flag="Y"
	...i expdate<+$h s flag="N" //过期置不可用
	...d ##class(web.DHCST.Common.StockHandle).UpdateDhcIncItmLcBt(inclbstr,flag)
	q ""
}

/// creator:yunhaibao
/// createdate:2016-10-12
/// description:删除指定库存分类的等效单位
/// tables:User.PHCFormDoseEquiv
/// input:库存分类描述
/// w ##class(web.DHCST.SystemTools).DeleteDoseEquiv("中药饮片")
ClassMethod DeleteDoseEquiv(InputCatDesc)
{
	q:InputCatDesc="" "库存分类为空!"
	s num=0
	s InciDr="0"
	f  s InciDr=$o(^INCI(InciDr)) q:InciDr=""  d
	.q:+InciDr=0
	.s InciDesc=$P(^INCI(InciDr,1),"^",2)
	.s IncscDr=$P(^INCI(InciDr,2),"^",2)
	.q:IncscDr=""
	.s StkCatDesc=$p(^INC("SC",IncscDr),"^",2)
	.q:InputCatDesc'=StkCatDesc
	.S ArcimDr=$P(^INCI(InciDr,1),"^",3)
	.S Arcsub=$P(ArcimDr,"||",1)
	.S Arcver=$P(ArcimDr,"||",2)
	.q:Arcsub=""
	.q:Arcver=""
	.Q:'$D(^ARCIM(Arcsub,Arcver)) 
	.S Phcdf=$P(^ARCIM(Arcsub,Arcver,1),"^",12)
	.s Phcd=+Phcdf
	.s PhcdSub=$p(Phcdf,"||",2)
	.q:Phcd=0
	.q:PhcdSub=""
	.&SQL(DELETE FROM PHC_FormDoseEquiv WHERE EQ_ParRef=:Phcdf)
	.i SQLCODE=0 s ret="成功"
	.e  s ret="失败"
	.w InciDesc_":"_ret,!
	.s num=num+1
	w !
	q num_"条记录!"
}

/// creator:yunhaibao
/// createdate:2017-03-30
/// description:库存项医嘱项批量生成五笔码
/// input:库存分类描述
/// w ##class(web.DHCST.SystemTools).CreateInciWBCode()
ClassMethod CreateInciWBCode()
{
	s inci="",num=0
	f  s inci=$o(^INCI(inci)) q:inci=""  d
	.q:+inci=0
	.q:$p(##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(inci),"^",3)'="G"
	.s incidesc=$p(^INCI(inci,1),"^",2)
	.s arcimdr=$p(^INCI(inci,1),"^",3)
	.s wbcode=##class(web.DHCST.Common.AppCommon).GetCNWBCODE(incidesc)
	.s num=num+1
	.d ##class(web.DHCST.INCALIAS).Save(inci,"^"_wbcode)
	.q:+arcimdr=0
	.d ##class(web.DHCST.ARCALIAS).Save(arcimdr,"^"_wbcode)
	.w incidesc_"|@|"_wbcode,!
	q num
}

/// creator: yunhaibao
/// createdate:20170409
/// description:价格bug,更新业务数据表的进价以及金额
/// params: startdate-开始日期,enddate,截止日期,starttime-开始时间,endtime-结束时间
/// w ##class(web.DHCST.SystemTools).UpdateRpData("2017-03-08","2017-04-09","00:00:00","16:00:00")
ClassMethod UpdateRpData(startdate, enddate, starttime, endtime)
{
	s startdate=$zdh(startdate,3)
	s enddate=$zdh(enddate,3)
	s starttime=$zth(starttime,1)
	s endtime=$zth(endtime,1)
	s cacudate=""
	s typestr="F^H" //住院没上线,先处理门诊发药数据,其余待定
	f typei=1:1:$l(typestr,"^") d
	.s type=$p(typestr,"^",typei)
	.f cacudate=startdate:1:enddate d
	..s intr=""
	..f  s intr=$o(^DHCINTR(0,"TypeDate",type,cacudate,intr)) q:intr=""  d
	...q:+intr=0
	...s intrdata=^DHCINTR(intr)
	...s intrtime=$p(intrdata,"^",3)
	...q:(startdate=cacudate)&&(intrtime<starttime)
	...q:(enddate=cacudate)&&(intrtime>endtime)
	...s intrp=+$p(intrdata,"^",16)
	...s intrrpamt=$p(intrdata,"^",17)
	...s inci=+$p(intrdata,"^",7)
	...q:inci'=4
	...s buom=$p(^INCI(inci,1),"^",10)
	...s intrqty=$p(intrdata,"^",6)
	...s pointer=$p(intrdata,"^",9)
	...s pmain=+pointer
	...s pitm=$p(pointer,"||",2)
	...s psub=$p(pointer,"||",3)
	...s rp=+##Class(web.DHCSTPRICE).GetRp(inci,cacudate,buom,"","")
	...q:rp=intrp
	...s ^DHCSTTRANSHISTORY($this,"UpdateRpData","TRANS",intr)=intrdata
	...s rpamt=rp*intrqty
	...s rpamt=$fn(rpamt,"",2)
	...s $p(^DHCINTR(intr),"^",16)=rp
	...s $p(^DHCINTR(intr),"^",17)=rpamt
	.../// 门诊发药
	...i type="F" d 
	....s ^DHCSTTRANSHISTORY($this,"UpdateRpData","F",intr)=^DHCPHDI(pmain,"PHDI",pitm,"INCLB",psub)
	....s $p(^DHCPHDI(pmain,"PHDI",pitm,"INCLB",psub),"^",5)=rp
	....s $p(^DHCPHDI(pmain,"PHDI",pitm,"INCLB",psub),"^",6)=-rpamt
	.../// 门诊退药
	...i type="H" d
	....s ^DHCSTTRANSHISTORY($this,"UpdateRpData","H",intr)=^DHCPHRTI(pmain,"RTI",pitm)
	....s phdi=$p(^DHCPHRTI(pmain,"RTI",pitm),"^",7)
	....s phd=+phdi
	....s phditm=$p(phdi,"||",2)
	....s phdsub=$o(^DHCPHDI(phd,"PHDI",phditm,"INCLB",0))
	....s retqty=$p(^DHCPHRTI(pmain,"RTI",pitm),"^",3)
	....s retuom=$p(^DHCPHRTI(pmain,"RTI",pitm),"^",4)
	....s phdrp=+$p(^DHCPHDI(phd,"PHDI",phditm,"INCLB",phdsub),"^",5)
	....s phdrpamt=retqty*phdrp
	....s $p(^DHCPHRTI(pmain,"RTI",pitm),"^",8)=phdrp
	....s $p(^DHCPHRTI(pmain,"RTI",pitm),"^",9)=phdrpamt
	...w $p(^INCI(inci,1),"^",2)_"    错误进价:"_intrp_"  正确进价:"_rp,!
	q ""
}

}
