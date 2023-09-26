/// Description:护士药房取药审核查询相关
/// Creator:    hulihua
/// CreateDate: 2016-10-21
/// Table:      DHC_PHDraw、DHC_PHDrawInc、DHC_PHDrawOrder、DHC_PHACollected
Class web.DHCINPHA.MTNurseCheck.NurseCheckQuery Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// Description:查询发药单主表信息
/// Creator:	hulihua
/// CreateDate:	2017-04-19
/// Table:      DHC_PHACollected
/// Input:		每页行数、页数、药房科室ID
/// Output:		发药单ID、发药单号、发药日期、发药时间、发药人、取药人
/// Return：    
/// w ##class(web.DHCINPHA.MTNurseCheck.NurseCheckQuery).GetInPhacList("50","1","03/12/2017^06/12/2017^102^3135^N")
ClassMethod GetInPhacList(rows, page, params) As %String
{
	n (rows, page,params)
	//s ^hlh($h)=$lb(rows, page,params)
	q:params="" ##class(web.DHCINPHA.MTCommon.JQueryCommon).GetNoJson()
	i $g(page)="" s page=1
	i $g(rows)="" s rows=50
	s End = page*rows
	s Start=(page-1)*rows+1
	s DataDelim=##class(web.DHCINPHA.MTCommon.PublicCallMethod).RowDataDelim()
	s StartDate=$p(params,DataDelim,1)
	s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	s EndDate=$p(params,DataDelim,2)
	s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	s PhLoc=$p(params,DataDelim,3)
	s AuditorDr=$p(params,DataDelim,4)
	Q:'$D(^SSU("SSUSR",AuditorDr)) ##class(web.DHCINPHA.MTCommon.JQueryCommon).GetNoJson()
	s ChkAuitFlag=$p(params,DataDelim,5)
	s CheckFlag=$p(params,DataDelim,6)
	s LogLocId=$p(params,DataDelim,7)
	s LogWardID=$p(params,DataDelim,8)
	S pid=##class(web.DHCINPHA.MTCommon.CommonUtil).NewPid("web.DHCINPHA.MTNurseCheck.NurseCheckQuery")
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp("web.DHCINPHA.MTNurseCheck.NurseCheckQuery","GetInPhacList",pid)
	s n=0
	f Date=StartDate:1:EndDate d
	.s phacid="" 
	.f  s phacid=$o(^DHCPHAC(0,"PHA",PhLoc,"DATE",Date,phacid)) q:phacid=""  d
	..s phcaudittor=$p(^DHCPHAC(phacid),"^",24)
	..q:(CheckFlag=0)&&(AuditorDr'=phcaudittor)					//取药类型的不是该用户领药的不显示
	..s wardid=$p(^DHCPHAC(phacid),"^",4)
	..q:(CheckFlag=1)&&(LogWardID'=wardid)						//送药类型的不是该病区的需要过滤
	..s wardLoc=$p(^PAWARD(wardid),"^",5)
	..s takenuseruser=$p(^DHCPHAC(phacid),"^",17)
	..q:(CheckFlag=1)&&(takenuseruser'="")&&(wardLoc'=LogLocId)	//送药类型的要去掉取药的
	..s takenuseruser=$p(##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetUserInfoById(takenuseruser),"^",2)
	..s auditflag=$p(^DHCPHAC(phacid),"^",25)
	..q:ChkAuitFlag'=auditflag									
	..s phacno=$p(^DHCPHAC(phacid),"^",14)
	..s phadate=$p(^DHCPHAC(phacid),"^",2)
	..s phadate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(phadate)
	..s phatime=$p(^DHCPHAC(phacid),"^",3) 
	..s phatime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(phatime)
	..s phadate=phadate_" "_phatime
	..s phadispuser=$p(^DHCPHAC(phacid),"^",5)
	..s phadispuser=$p(##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetUserInfoById(phadispuser),"^",2)
	..s warddesc=$p(^PAWARD(wardid),"^",2)
	..s n=n+1
	..s data1=$g(phacid)_"^"_$g(phacno)_"^"_$g(phadate)_"^"_$g(phadispuser)_"^"_$g(takenuseruser)
	..s data2=$g(warddesc)
	..s ^TMP("DHCINPHA","web.DHCINPHA.MTNurseCheck.NurseCheckQuery","GetInPhacList",pid,n)=data1_"^"_data2
	q:n=0 ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEmptySign(n) //输出空的json串
	w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonStartSign(n) //输出json前缀串
	s maxrow=n
	s count=0
	s h=""
	f  s h=$o(^TMP("DHCINPHA","web.DHCINPHA.MTNurseCheck.NurseCheckQuery","GetInPhacList",pid,h),-1) q:h=""  d
	.s mdata=^TMP("DHCINPHA","web.DHCINPHA.MTNurseCheck.NurseCheckQuery","GetInPhacList",pid,h)
	.s count = count+1
	.s Title1="TPhacID^TPhacNo^TPhaDate^TPhaDispUser^TTakeNuserUser"
	.s Title2="TWardDesc"
	.s Title=Title1_"^"_Title2
	.q:(count<Start)||(count>End)
	.I count=Start d
	..w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,mdata)
	.e  d
	..w ","_##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,mdata)

	w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEndSign() //输出json结尾符
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp("web.DHCINPHA.MTNurseCheck.NurseCheckQuery","GetInPhacList",pid)
	q ""
}

/// Description:查询发药单药品汇总信息
/// Creator:	hulihua
/// CreateDate:	2017-04-19
/// Table:      DHC_PHDraw、DHC_PHDrawInc
/// Input:		每页行数、页数、发药主表ID
/// Output:		发药孙表ID、药品名称、规格、应发数、实发数、基本单位
/// Return：    
/// w ##class(web.DHCINPHA.MTNurseCheck.NurseCheckQuery).GetInPhacIncList("50","1","33")
ClassMethod GetInPhacIncList(rows, page, params) As %String
{
	n (rows, page,params)
	//s ^hlh($h)=$lb(rows, page,params)
	q:params="" ##class(web.DHCINPHA.MTCommon.JQueryCommon).GetNoJson()
	i $g(page)="" s page=1
	i $g(rows)="" s rows=50
	s End = page*rows
	s Start=(page-1)*rows+1
	s phac=params
	S pid=##class(web.DHCINPHA.MTCommon.CommonUtil).NewPid("web.DHCINPHA.MTNurseCheck.NurseCheckQuery")
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp("web.DHCINPHA.MTNurseCheck.NurseCheckQuery","GetInPhacIncList",pid,"PHACINCI")
	s ch=0,n=0 
	f  s ch=$o(^DHCPHAC(phac,"I",ch)) q:ch=""  s data=^(ch) d
	.q:'$d(^DHCPHAC(phac,"I",ch))
	.s sub=""
	.f  s sub=$o(^DHCPHAC(phac,"I",ch,"B",sub)) q:sub=""  d
	..s phacsub=phac_"||"_ch_"||"_sub
	..s inclb=$p(^DHCPHAC(phac,"I",ch,"B",sub),"^",1)
	..s inci=+inclb
	..q:inci=""
	..s qtyactual=$p(^DHCPHAC(phac,"I",ch,"B",sub),"^",2)							//实发数量
	..s dspbatch=$p(^DHCPHAC(phac,"I",ch,"B",sub),"^",7)													
	..s qtytotal=$p(^DHCOEDISQTY(+dspbatch,"I",$p(dspbatch,"||",2)),"^",2)			//应发数量
	..s index=inci
	..i $d(^TMP("DHCINPHA","web.DHCINPHA.MTNurseCheck.NurseCheckQuery","GetInPhacIncList",pid,"PHACINCI",index))  d
	...s $p(^TMP("DHCINPHA","web.DHCINPHA.MTNurseCheck.NurseCheckQuery","GetInPhacIncList",pid,"PHACINCI",index),"^",1)=$p(^TMP("DHCINPHA","web.DHCINPHA.MTNurseCheck.NurseCheckQuery","GetInPhacIncList",pid,"PHACINCI",index),"^",1)_"#"_phacsub
	...s $p(^TMP("DHCINPHA","web.DHCINPHA.MTNurseCheck.NurseCheckQuery","GetInPhacIncList",pid,"PHACINCI",index),"^",4)=$p(^TMP("DHCINPHA","web.DHCINPHA.MTNurseCheck.NurseCheckQuery","GetInPhacIncList",pid,"PHACINCI",index),"^",4)+qtytotal
	...s $p(^TMP("DHCINPHA","web.DHCINPHA.MTNurseCheck.NurseCheckQuery","GetInPhacIncList",pid,"PHACINCI",index),"^",5)=$p(^TMP("DHCINPHA","web.DHCINPHA.MTNurseCheck.NurseCheckQuery","GetInPhacIncList",pid,"PHACINCI",index),"^",5)+qtyactual
	..e  d
	...s incicode = $p(^INCI(inci,1),"^",1)											//药品代码								
	...s incidesc = $p(^INCI(inci,1),"^",2)											//药品名称
	...s spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",inci)				//规格
	...s phacuom=##class(web.DHCSTPCHCOLLDSPPRN).getUom(inci) 
	...s n=n+1
	...s data=$g(phacsub)_"^"_$g(incidesc)_"^"_$g(spec)_"^"_$g(qtytotal)_"^"_$g(qtyactual)_"^"_$g(phacuom)
	...s ^TMP("DHCINPHA","web.DHCINPHA.MTNurseCheck.NurseCheckQuery","GetInPhacIncList",pid,"PHACINCI",index)=data
	..
	.
	q:n=0 ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEmptySign(n) //输出空的json串
	w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonStartSign(n) //输出json前缀串
	s maxrow=n
	s count=0
	s h=""
	f  s h=$o(^TMP("DHCINPHA","web.DHCINPHA.MTNurseCheck.NurseCheckQuery","GetInPhacIncList",pid,"PHACINCI",h)) q:h=""  d
	.s mdata=^TMP("DHCINPHA","web.DHCINPHA.MTNurseCheck.NurseCheckQuery","GetInPhacIncList",pid,"PHACINCI",h)
	.s qtyactual=$fn($p(mdata,"^",5),"N")
	.s $p(mdata, "^", 4) = $fn($p(mdata,"^",4),"N")
	.s $p(mdata, "^", 5) = $fn($p(mdata,"^",5),"N")
	.s packqtyactual=##Class(web.DHCSTPCHCOLLPRN).getPackQty(h,qtyactual)
	.s mdata=mdata_"^"_packqtyactual  //添加整包装单位数量 by psc
	.s count = count+1
	.s Title="TPhacSub^TInciDesc^TSpec^TQtyTotal^TQtyActual^TPhacUom^TPackQtyActual"
	.q:(count<Start)||(count>End)
	.I count=Start d
	..w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,mdata)
	.e  d
	..w ","_##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,mdata)

	w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEndSign() //输出json结尾符
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp("web.DHCINPHA.MTNurseCheck.NurseCheckQuery","GetInPhacIncList",pid,"PHACINCI")
	q ""
}

/// Description:查询发药单明细信息
/// Creator:	hulihua
/// CreateDate:	2017-04-19
/// Table:      DHC_PHACollectItm、DHC_OEDispensing
/// Input:		每页行数、页数、发药子表ID串
/// Output:		登记号、患者姓名、床号、发药单位、发药数量、应发数量
/// Return：    
/// w ##class(web.DHCINPHA.MTNurseCheck.NurseCheckQuery).GetInPhacOrderList("50","1","1||1")
ClassMethod GetInPhacOrderList(rows, page, params) As %String
{
	n (rows, page,params)
	//s ^hlh($h)=$lb(rows, page,params)
	q:params="" ##class(web.DHCINPHA.MTCommon.JQueryCommon).GetNoJson()
	i $g(page)="" s page=1
	i $g(rows)="" s rows=50
	s End = page*rows
	s Start=(page-1)*rows+1
	s phacsubstr=params
	s pid=##class(web.DHCINPHA.MTCommon.CommonUtil).NewPid("web.DHCINPHA.MTNurseCheck.NurseCheckQuery")
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp("web.DHCINPHA.MTNurseCheck.NurseCheckQuery","GetInPhacOrderList",pid,"PHACORDER")
	s n=0
	s cnt=$l(phacsubstr,"#")
	f i=1:1:cnt d
	.s phacsub=$p(phacsubstr,"#",i)
	.s dspbatch=$p(^DHCPHAC(+phacsub,"I",$p(phacsub,"||",2),"B",$p(phacsub,"||",3)),"^",7)
	.s DspId=+dspbatch
	.q:DspId=0
	.s inclb=$p(^DHCPHAC(+phacsub,"I",$p(phacsub,"||",2),"B",$p(phacsub,"||",3)),"^",1)
	.s Qty=$p(^DHCPHAC(+phacsub,"I",$p(phacsub,"||",2),"B",$p(phacsub,"||",3)),"^",2)
	.s oeori=$p(^DHCOEDISQTY(DspId),"^",1)
	.s admDr=$p(^OEORD(+oeori),"^",1)
	.s patInfo=##class(web.DHCPHACOM.ComPubClass.OrderAndPatInfo).GetPatInfo(admDr)
	.s PatName=$p(patInfo,"^",3)											//姓名 
	.s PatNo=$p(patInfo,"^",1)												//登记号
	.s OldWardStr=##class(web.DHCSTPCHCOLLS).getOrdWard(oeori)    		
	.s BedId=$p(OldWardStr,"^",2)
	.s Bed=$s(BedId'="":$p(^PAWARD($p(BedId,"||",1),"BED",$p(BedId,"||",2)),"^",1),1:"")	//病人床号 
	.s DspQty=$p(^DHCOEDISQTY(DspId,"I",$p(dspbatch,"||",2)),"^",2)							//应发数量
	.s dspuomid=$p(^INCI(+inclb,1),"^",10)													//单位ID
	.s DspUom=$p(^CT("UOM",dspuomid),"^",2)
	.s DspDate=$p(^DHCOEDISQTY(DspId),"^",21)												//单位ID
	.s index=admDr_"^"_oeori_"^"_DspDate
	.i $d(^TMP("DHCINPHA","web.DHCINPHA.MTNurseCheck.NurseCheckQuery","GetInPhacOrderList",pid,"PHACORDER",index)) d
	..s $p(^TMP("DHCINPHA","web.DHCINPHA.MTNurseCheck.NurseCheckQuery","GetInPhacOrderList",pid,"PHACORDER",index),"^",5)=$p(^TMP("DHCINPHA","web.DHCINPHA.MTNurseCheck.NurseCheckQuery","GetInPhacOrderList",pid,"PHACORDER",index),"^",5)+DspQty
	..s $p(^TMP("DHCINPHA","web.DHCINPHA.MTNurseCheck.NurseCheckQuery","GetInPhacOrderList",pid,"PHACORDER",index),"^",6)=$p(^TMP("DHCINPHA","web.DHCINPHA.MTNurseCheck.NurseCheckQuery","GetInPhacOrderList",pid,"PHACORDER",index),"^",6)+Qty
	.e  d
	..s n=n+1
	..s data=$g(PatNo)_"^"_$g(PatName)_"^"_$g(Bed)_"^"_$g(DspUom)_"^"_$g(DspQty)_"^"_$g(Qty)
	..s ^TMP("DHCINPHA","web.DHCINPHA.MTNurseCheck.NurseCheckQuery","GetInPhacOrderList",pid,"PHACORDER",index)=data
	.
	q:n=0 ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEmptySign(n) //输出空的json串
	w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonStartSign(n) //输出json前缀串
	s maxrow=n
	s count=0
	s h=""
	f  s h=$o(^TMP("DHCINPHA","web.DHCINPHA.MTNurseCheck.NurseCheckQuery","GetInPhacOrderList",pid,"PHACORDER",h)) q:h=""  d
	.s DspDate=$p(h,"^",3)
	.s DspDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(DspDate)
	.s mdata=^TMP("DHCINPHA","web.DHCINPHA.MTNurseCheck.NurseCheckQuery","GetInPhacOrderList",pid,"PHACORDER",h)_"^"_DspDate
	.s $p(mdata, "^", 5) = $fn($p(mdata, "^", 5), "N")
	.s $p(mdata, "^", 6) = $fn($p(mdata, "^", 6), "N")
	.s count = count+1
	.s Title="TPatNo^TPatName^TBed^TDspUom^TDspQty^TQty^TDspDate"
	.q:(count<Start)||(count>End)
	.I count=Start d
	..w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,mdata)
	.e  d
	..w ","_##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,mdata)

	w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEndSign() //输出json结尾符
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp("web.DHCINPHA.MTNurseCheck.NurseCheckQuery","GetInPhacOrderList",pid,"PHACORDER")
	q ""
}

/// Description:护士审核通过表结构处理
/// Creator:	hulihua
/// CreateDate:	2017-04-20
/// Table:      DHC_PHACollected
/// Input:		发药主表ID
/// Output:
/// Return：    0-成功，非0-失败
/// Others:    
/// w ##class(web.DHCINPHA.MTNurseCheck.NurseCheckQuery).SaveAuditPass("")
ClassMethod SaveAuditPass(params) As %String
{
	n (params)
	s phac=$p(params,"^",1)
	q:phac="" -1
	s auditflag=$p(^DHCPHAC(phac),"^",25)
	q:auditflag="Y" -2
	s phacauditdate=+$h
	s phacaudittime=$p($h,",",2)
	s phacauditflag="Y"
	s listdata=phac_"^"_phacauditflag_"^"_phacauditdate_"^"_phacaudittime
	s err=##class(web.DHCINPHA.MTNurseCheck.SqlDbPhacAuitCheck).UpdateAuditInfo(listdata)
	q:err'=0 -3
	q err
}

}
