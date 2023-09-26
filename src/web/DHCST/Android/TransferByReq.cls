Import SQLUser

/// Creator: yunhaibao
/// CreateDate: 2015-07-21
/// Descript:依据请求出库相关方法
Class web.DHCST.Android.TransferByReq Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 根据条件获取请求单数据
/// w ##class(web.DHCST.Android.TransferByReq).jsINReqForTransfer("2016-9-25^2016-09-27^102^^0^0")
ClassMethod jsINReqForTransfer(sPar As %String) As %GlobalCharacterStream
{
	s $ZT="Error^DHCSTERROR"  
	s ^yunhaibao("jsINReqForTransfer")=sPar
	s StartDate=$p(sPar,"^",1)
	s EndDate=$p(sPar,"^",2)
	s FrLoc=$p(sPar,"^",3)
	s ToLoc=$p(sPar,"^",4)
	s PartlyTransfer=$p(sPar,"^",5)
	s Transfered=$p(sPar,"^",6)
	s RestrictedFlag=$p(sPar,"^",7)
	s Sort="",Dir=""
	s qPar=Sort_"^"_Dir
	i ToLoc'="" s PartlyTransfer=1
	s result=##class(%Library.ResultSet).%New("web.DHCST.DHCINIsTrf:INReqForTransfer")
	s sc=result.Execute(qPar,StartDate,EndDate,FrLoc,ToLoc,PartlyTransfer,Transfered)  
	i $$$ISERR(sc) q ""
	s colNum=result.GetColumnCount()
	s colNameStr=""
	f i=1:1:colNum d
	.i colNameStr="" s colNameStr=result.GetColumnName(i)
	.e  s colNameStr=colNameStr_"^"_result.GetColumnName(i)
	s count = 0
 	s ListStream=##class(%GlobalCharacterStream).%New()
	While(result.Next())
	{ 
		s ret=""
		f i=1:1:colNum d 
		.s tmpresult=result.%GetData(i)
		.i i=3 d
		..i tmpresult["-" s tmpresult=$p(tmpresult,"-",2)
		.i ret="" s ret=tmpresult
		.e   s ret=ret_"^"_tmpresult

		s tmp=ret
		s outputjson=##class(web.DHCSTPHCMCOMMON).getJsonData(colNameStr,ret)
		s count = count+1       
		I count=1 d
		.d ListStream.Write(##class(web.DHCSTPHCMCOMMON).getJsonStartSign(1))
		.d ListStream.Write(outputjson)
		e  d
		.d ListStream.Write(",")
		.d ListStream.Write(outputjson)
	}
    i count>0 d ListStream.Write(##class(web.DHCSTPHCMCOMMON).getJsonEndSign())
    e  d
    .s EmptyJson=##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0)
    .d ListStream.Write(EmptyJson)
    q ListStream
}

/// 请求明细数据
/// w ##class(web.DHCST.Android.TransferByReq).jsINReqD("BJDTYYMZXYFREQ20160927001")
ClassMethod jsINReqD(reqno As %String) As %GlobalCharacterStream
{
	//s ^yunhaibao("jsINReqD")=reqno
	s $ZT="Error^DHCSTERROR"  
	s EmptyJson=##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0)
	s EmptyStream=##class(%GlobalCharacterStream).%New()
	d EmptyStream.Write(EmptyJson)
	q:'$d(^INRQ(0,"No",$$ALPHAUP^SSUTIL4(reqno))) EmptyStream
	s req=$o(^INRQ(0,"No",$$ALPHAUP^SSUTIL4(reqno),""))
	q:req="" EmptyStream
	s ShowTransferedFlag=0
	s reqDate=""
	s pid=..NewPid()
	&sql(select inrq_date,INRQ_ReqLoc_DR,INRQ_RecLoc_DR into :reqDate,:requestedLoc,:PrvLocId  from in_request where %ID=:req)
	q:PrvLocId="" EmptyStream
	s HospID=$p(^CTLOC(PrvLocId),"^",22)
	s sql="select %ID rowid,"
	s sql=sql_" inrqi_inci_dr inci,"
	s sql=sql_"inrqi_inci_dr->inci_code code,"
	s sql=sql_"inrqi_inci_dr->inci_desc incidesc,"
	s sql=sql_"inrqi_reqqty qty,"
	s sql=sql_"inrqi_ctuom_dr uom,"
	s sql=sql_"inrqi_ctuom_dr->ctuom_desc uomDesc"
	s sql=sql_" From in_reqitm"
	s sql=sql_" where inrqi_inrq_parref="_req
	s xrs=##class(%Library.ResultSet).%New()
	d xrs.Prepare(sql)
	s sc=xrs.Execute()
	i $$$ISERR(sc) q EmptyStream
	while(xrs.Next())
	{
		s rowid=xrs.Data("rowid")
		s inci=xrs.Data("inci")
		s code=xrs.Data("code")
		s desc=xrs.Data("incidesc")
		s qty=xrs.Data("qty")
		s uom=xrs.Data("uom")
		s uomDesc=xrs.Data("uomDesc")
		s spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",inci)
		s manf=$p(##class(web.DHCST.Common.DrugInfoCommon).GetManf(inci),"^",3)
		i manf["-" s manf=$p(manf,"-",2)
		i reqDate="" s reqDate=+$h
		s rp=##class(web.DHCST.Common.PriceCommon).GetClbRp(inci,uom,HospID,"G",+$h,$p($h,",",2)) //add wyx 增加进价
		s sp=##class(web.DHCST.Common.PriceCommon).GetPriceElse(inci,reqDate,uom,HospID,"G","")
		s spAmt=sp*qty
		s rpAmt=rp*qty
		s generic=$p(##class(web.DHCST.Common.DrugInfoCommon).GetGene(inci),"^",2)
		s drugForm=$p(##class(web.DHCST.Common.DrugInfoCommon).GetForm(inci),"^",2)
		//&sql(select INRQI_Remark into remark from  dhc_inreqitm where INRQI_INRQI_DR=:rowid )
		s transQty=##class(web.DHCST.DHCINIsTrf).TransQty(rowid)  ;已转移数量(基本单位)
		s buom=$p(^INCI(inci,1),"^",10)   ;基本单位
		s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(uom,buom)
		s puruom=$p(^INCI(inci,3),"^",6)
		s confac=##class(web.DHCST.Common.UtilCommon).UOMFac(puruom,buom)
		s transQty=transQty/fac
		s NotTransQty=qty-transQty
		continue:(ShowTransferedFlag=0)&(NotTransQty<=0)  ;不显示已转移完成的明细
		i NotTransQty<0  s NotTransQty=0
		s RefuseFlag=$p(^INRQ(+rowid,"RQI",$p(rowid,"||",2)),"^",6)
		i RefuseFlag="Y" s RefuseFlag=1
		e  s RefuseFlag=0
		s reqqty=##class(web.DHCST.Common.DrugStkCommon).LocDayQtyUom(inci,PrvLocId,puruom,+$h) //请求科室库存
		s prvqty=##class(web.DHCST.Common.DrugStkCommon).LocDayQtyUom(inci,requestedLoc,puruom,+$h) //供应科室库存
		s stkbindesc="",stkbinorder=""
		i $d(^INCI("IL_LOC",requestedLoc,inci)) d
		.s incich=$o(^INCI("IL_LOC",requestedLoc,inci,""))
		.s incil=inci_"||"_incich
		.s stkbindesc=$p(##Class(web.DHCST.INCStkBin).GetInciBinStr(incil),":",2)
		.s stkbinorder=stkbindesc
		i stkbindesc="" s stkbinorder="ZZZZZZZZZ1"
		//排序用
		s transedqty=transQty
		s data1=rowid_"^"_inci_"^"_code_"^"_desc_"^"_qty
		s data2=uom_"^"_uomDesc_"^"_spec_"^"_manf_"^"_sp
		s data3=spAmt_"^"_generic_"^"_drugForm_"^"_$g(remark)_"^"_transQty
		s data4=NotTransQty_"^"_buom_"^"_confac_"^"_reqqty_"^"_prvqty
		s data5=rp_"^"_rpAmt_"^"_RefuseFlag_"^"_stkbindesc_"^"_transedqty
		s sumdata=data1_"^"_data2_"^"_data3_"^"_data4_"^"_data5
		s ^TMP("DHCST","web.DHCST.Android.TransferByReq","jsINReqD",pid,stkbinorder,rowid)=sumdata	
	}
	q:'$d(^TMP("DHCST","web.DHCST.Android.TransferByReq","jsINReqD",pid)) EmptyStream
	s count=0
	s title1="rowid^inci^code^desc^qty"
	s title2="uom^uomDesc^spec^manf^sp"
	s title3="spAmt^generic^drugForm^remark^transQty"
	s title4="NotTransQty^BUomId^ConFac^reqqty^prvqty"
	s title5="rp^rpAmt^RefuseFlag^StkBinDesc^transedqty"
	s title=title1_"^"_title2_"^"_title3_"^"_title4_"^"_title5
	s ListStream=##class(%GlobalCharacterStream).%New()
	s count=0
	s stkbindesc=""
	f  s stkbindesc=$o(^TMP("DHCST","web.DHCST.Android.TransferByReq","jsINReqD",pid,stkbindesc)) q:stkbindesc=""  d
	.s rowid=""
	.f  s rowid=$o(^TMP("DHCST","web.DHCST.Android.TransferByReq","jsINReqD",pid,stkbindesc,rowid)) q:rowid=""  d
	..s detaildata=^TMP("DHCST","web.DHCST.Android.TransferByReq","jsINReqD",pid,stkbindesc,rowid)
	..s outputjson=##class(web.DHCSTPHCMCOMMON).getJsonData(title,detaildata)
	..s count=count+1
	..I count=1 d
	...d ListStream.Write(##class(web.DHCSTPHCMCOMMON).getJsonStartSign(1))
	...d ListStream.Write(outputjson)
	..e  d
	...d ListStream.Write(",")
	...d ListStream.Write(outputjson)
    i count>0 d ListStream.Write(##class(web.DHCSTPHCMCOMMON).getJsonEndSign())
    e  d ListStream.Write(EmptyJson)
	k ^TMP("DHCST","web.DHCST.Android.TransferByReq","jsINReqD",pid)
	Q ListStream
}

/// 根据请求单号,建立出库单
/// w ##class(web.DHCST.Android.TransferByReq).SaveTransferMaster("NREQ20150724001","1")
ClassMethod SaveTransferMaster(reqno, userid)
{
	 n (reqno,userid)
	 s $ZT="Error^DHCSTERROR"  
	 //s ^yunhaibao("SaveTransferMaster")=reqno_"^"_userid
	 q:reqno="" "-1,请求单ID获取不到!"
	 i +userid=0 s userid=1
	 q:'$d(^INRQ(0,"No",$$ALPHAUP^SSUTIL4(reqno))) "-2,请求单不存在!"
	 s req=$o(^INRQ(0,"No",$$ALPHAUP^SSUTIL4(reqno),""))
	 s reqloc=$p(^INRQ(req),"^",6)  //请求科室
	 s proloc=$p(^INRQ(req),"^",5)  //供给科室
	 s init=""
	 s opType="" //出库类型
	 s comp="Y"  //完成标志
	 s status="11"  //出库审核状态
	 s scg=""  //类组rowid,保存界面有处理
	 s maininfo1=proloc_"^"_reqloc_"^"_req_"^"_opType_"^"_comp
	 s maininfo2=status_"^"_userid_"^"_scg_"^"_"G"_"^"_"PDA请求单出库"_"^"_""
	 s maininfo=maininfo1_"^"_maininfo2
	 s transferret=##class(web.DHCST.DHCINIsTrf).Update(init,maininfo)  //保存主表返回记录
	 q:+transferret<0 "-3,创建出库单失败!"
	 q $p(^DHCINIT(transferret),"^",1)_","_transferret
}

/// 根据请求明细id获取相关数据
/// w ##class(web.DHCST.Android.TransferByReq).GetInReqDetailInciInfo("51874||1")
ClassMethod GetInReqDetailInciInfo(inreqitmrowid)
{
	n (inreqitmrowid)
	s $ZT="PDAError^DHCSTERROR"  
	s ^yunhaibao("GetInReqDetailInciInfo")=inreqitmrowid
	s inreq=+inreqitmrowid
	s inreqitm=$p(inreqitmrowid,"||",2)
	s inci=$p(^INRQ(inreq,"RQI",inreqitm),"^",4)
	s reqqty=$p(^INRQ(inreq,"RQI",inreqitm),"^",3)
	s uom=$p(^INRQ(inreq,"RQI",inreqitm),"^",5)  //请求什么单位就出什么单位
	s uomdesc=$p(^CT("UOM",uom),"^",2)
	s proloc=$p(^INRQ(inreq),"^",6)
	s prolocqty=##class(web.DHCST.Common.DrugStkCommon).LocDayQtyUom(inci,proloc,uom,+$h) //供应科室库存   //供给部门数量
	s transedqty=0 //##class(web.DHCST.DHCINIsTrf).TransQty(rowid)  //已转移数量
	s inreqitminfo=inci_","_reqqty_","_uom_","_uomdesc_","_prolocqty_","_transedqty
	q inreqitminfo
}

/// 根据条码获取相关信息,用于扫码出库,仅返回唯一有效数据
/// w ##class(web.DHCST.Android.TransferByReq).GetInclbInfoByLabel(1302,6921168509256,1113,52789)
ClassMethod GetInclbInfoByLabel(locid, packlabel, transuom, incirowid)
{
	n (locid,packlabel,transuom,incirowid)
	//s ^yunhaibao("GetInclbInfoByLabel")=locid_","_packlabel_","_transuom_","_incirowid
	s $zt="ErrorGetInclbInfoByLabel"
	s returninfo=""
	s inbpid=""
	f  s inbpid=$o(^DHCINBP(0,"BarCode",packlabel,inbpid)) q:inbpid=""  d
	.s incib=$p(^DHCINBP(inbpid),"^",1)
	.q:incib=""
	.s inci=+incib
	.q:incirowid'=inci
	.s IL=$o(^INCI("IL_LOC",locid,inci,""))
    .q:IL=""
    .s LB=$o(^INCI("LB_IB",incib,inci,IL,""))
    .q:LB=""
    .s inclb=inci_"||"_IL_"||"_LB
	.s batno=$p(^INCI(inci,"IB",$p(incib,"||",2)),"^",1)   //批号
	.s expdate=$p(^INCI(inci,"IB",$p(incib,"||",2)),"^",2) //效期
	.s:expdate'="" expdate=$zd(expdate,3)
	.s puomdr=$p(^DHCINBP(inbpid),"^",3)  //单位
	.s puomdesc=$p(^CT("UOM",puomdr),"^",2)
	.s qty=$p(^DHCINBP(inbpid),"^",4)     //对应条码剩余数量,最好存基本单位数量吧
	.s uomdr=$p(^INCI(inci,3),"^",6)
	.s uomdesc=$p(^CT("UOM",uomdr),"^",2)
	.s inclbqty=##class(web.DHCST.Common.DrugStkCommon).QtyINCLBUom(inclb,transuom,+$h)
	.s inclbqty=$fn(inclbqty,"",2)
	.//transuom为转移单位
	.s returninfo=inclb_","_batno_","_expdate_","_qty_","_inclbqty
	q:returninfo="" "-1"
	s firstinflag="0"  //是否是近效期
	q firstinflag_","_returninfo
ErrorGetInclbInfoByLabel
	q -1
}

/// creator:yunhaibao
/// createdate:20150728
/// description:验证药品效期,如果先进的还有库存,给予提示,倒序
/// w ##class(web.DHCST.Common.DrugStkCommon).CheckInciExpdate(39828,"2015-01-01",1302)
ClassMethod CheckInciExpdate(inci, expdate, locid)
{
	n (expdate,inci,locid)
	q:inci="" ""
	q:expdate="" ""
	q:locid="" ""
	s incich=""
	q:'$d(^INCI("IL_LOC",locid,inci)) ""
	s incich=$o(^INCI("IL_LOC",locid,inci,""),-1)
	q:incich="" ""
	s incilb=""
	f  s incilb=$o(^INCI(inci,"IL",incich,"LB",incilb),-1) q:incilb=""  d
	i expdate["-" s expdate=$zdh(expdate,3)
	s hisexpdate=""
	&SQL(SELECT TOP 1 INCIB_ExpDate into :hisexpdate FROM INC_ItmBat WHERE INCIB_INCI_ParRef=39828 ORDER BY INCIB_ExpDate DESC) 
	q:hisexpdate="" ""
	q:expdate<hisexpdate -1
	q 0
}

/// pda依据请求出库,明细确认出库,创建以及审核
/// 要成功全成功,一步到位,不涉及占用
/// w ##class(web.DHCST.Android.TransferByReq).DoTransOutDetail("101366",1,"51878||1^28322||14||96^2^1113^^")
ClassMethod DoTransOutDetail(init, userid, detailinfo)
{
	n (detailinfo,userid,init)
	s $ZT="PDAError^DHCSTERROR"  
	q:init="" "-1,出库单信息为空!"
	q:'$d(^DHCINIT(init)) "-2,无此出库单!"
	s initNo=$p(^DHCINIT(init),"^",1)
	s fromloc=$p(^DHCINIT(init),"^",5)
	s succ=0
	//S ^yunhaibao("DoTransOutDetail")=init_","_userid_","_detailinfo
	ts
	s detaili=0
	f detaili=1:1:$l(detailinfo,"!!") q:succ'=0  d
	.s ret=0
	.s detail=$p(detailinfo,"!!",detaili)
	.s reqitm=$p(detail,"^",1)
	.s inclb=$p(detail,"^",2)
	.s qty=$p(detail,"^",3)
	.q:+qty<=0
	.s uomid=$p(detail,"^",4)
	.s packlabel=$p(detail,"^",5)
	.s linklabel=$p(detail,"^",6)
	.s rp=##class(web.DHCST.Common.PriceCommon).GetClbRp(inclb,uomid,1,"G",+$h,"")
	.s rpamt=rp*qty
	.s sp=##class(web.DHCST.Common.PriceCommon).GetPriceElse(inclb,+$h,uomid,1,"G","")
	.s spamt=sp*qty
	.s transdetail1=inclb_"^"_qty_"^"_uomid_"^"_reqitm_"^"_rp
	.s transdetail2=rpamt_"^"_sp_"^"_spamt_"^"_rp_"^"_rpamt
	.s transdetail3=sp_"^"_spamt_"^"_"pda"
	.s transdetail=transdetail1_"^"_transdetail2_"^"_transdetail3
	.s initirowid=##class(web.DHCST.DHCINIsTrfItm).Update("",init,transdetail) //增加后直接审核
	.i initirowid<0 tro  s succ=initirowid_"保存失败!"   q
	.//审核操作
	.s newinit=+initirowid,newiniti=$p(initirowid,"||",2)
	.s initiStatus=$p(^DHCINIT(newinit,"ITI",newiniti),"^",23)
 	.q:initiStatus="21"
 	.s buom=$P(^INCI(+inclb,1),"^",10)
 	.s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(uomid,buom)
 	.s bqty=qty*fac
 	.s ret=##class(web.DHCST.Common.StockHandle).UpdateStock(inclb,-bqty)  //处理库存
 	.i ret<0 tro  s succ=ret_",处理库存失败!"   q
	.s trData="T"
	.s trData=trData_"^"_initNo
	.s trData=trData_"^"_inclb
	.s trData=trData_"^"_-qty
	.s trData=trData_"^"_uomid
	.s trData=trData_"^"_sp
	.s trData=trData_"^"_userid
	.s trData=trData_"^"_initirowid
	.s trData=trData_"^"_rp
	.s trData=trData_"^"_-rpamt
	.s trData=trData_"^"_-spamt
	.s ret=##class(web.DHCST.Common.StockHandle).IntoTrans(trData)  //插入台账
	.i ret<0 tro  s succ=ret_",处理台账失败!"  q 
 	.&sql(update dhc_inistrfitm set dhciti_state='21' where %ID=:initirowid) //更新子表记录状态
 	.i SQLCODE'=0 tro  s succ=SQLCODE_",更新子表状态失败!" q
    .i '$d(^DHCINBP(0,"BarCode",packlabel)) s ret=-124
	.i ret<0 tro  s succ=ret_",包装条码不存在!" q
	.s packinbp=$o(^DHCINBP(0,"BarCode",packlabel,""),-1)
 	.i linklabel'="" d  					//计算数量,存入条码信息,如果是大包装,接收后将条码科室修改为接收科室
	..//如果拆了,将原包装数量减少,插入新数据
	..i $d(^DHCINBP(0,"BarCode",linklabel)) s ret=-123
	..i ret<0 tro  s succ=ret_",关联条码已经存在!" q
	..s puomid=$P(^INCI(+inclb,3),"^",6)
	..s pfac=##class(web.DHCST.Common.UtilCommon).UOMFac(puomid,buom)
	..s pqty=bqty/pfac
	..s incib=$p(^INCI(+inclb,"IL",$p(inclb,"||",2),"LB",$p(inclb,"||",3)),"^",1)
	..&SQL(UPDATE DHC_IncBatPack SET INBP_Qty=INBP_Qty-:pqty WHERE INBP_ROWID=:packinbp)  //更新原包装数据
	..//插入新数据
	..&SQL(INSERT INTO DHC_IncBatPack(INBP_INCIB_Dr,INBP_Uom_Dr,INBP_ParBarCode,INBP_BarCode,INBP_Loc_Dr,INBP_PrintFlag,INBP_Qty,INBP_INITI_Dr)
	values(:incib,:puomid,:packlabel,:linklabel,:fromloc,'1',:pqty,:initirowid))
	.e  d
	..&SQL(UPDATE DHC_IncBatPack SET INBP_INITI_Dr=:initirowid WHERE INBP_ROWID=:packinbp)  //更新原包装数据
	i succ'=0 tro
	q:succ'=0 "保存失败:"_succ 
	tc
	s nowdate=+$h
	s nowtime=$p($h,",",2)
	&sql(UPDATE dhc_inistrf set init_state='21',init_ackdate=:nowdate,init_acktime=:nowtime,init_ackuser_dr=:userid 
   where %ID=:init)
	q 0
}

/// Descrpt:获取请求单对应最近一次的转移单据
/// W ##Class(web.DHCST.Android.TransferByReq).jsQueryReq("YKXYREQ20151123002")
ClassMethod jsQueryReq(reqno As %String) As %String
{
	n (reqno)
	s EmptyJson="{ErrCode:0,rows:[]}"
	s reqID=$o(^INRQ(0,"No",$$ALPHAUP^SSUTIL4(reqno),""))
	s reqLocId =$P(^INRQ(reqID),"^",6)
    s proLocId =$P(^INRQ(reqID),"^",5)
    s HospID=$P(^CTLOC(reqLocId),"^",22)  ///医院ID
 	s init=$o(^DHCINIT(0,"REQ",reqID,""))
 	q:init="" EmptyJson
	s status=+$p(^DHCINIT(init),"^",14)
 	q:status>"21" EmptyJson
	s trNo=$p(^DHCINIT(init),"^",1)   //单号
	s trDate=$p(^DHCINIT(init),"^",2) //转移日期
	s userID=$p(^DHCINIT(init),"^",8) //用户ID
 	q:userID="" EmptyJson
 	s userName=$p(^SSU("SSUSR",userID),"^",2)
 	s ListString="{ErrCode:0,rows:["
 	s ListTitle="Init^TrDate^TrNo^User"
 	s ListData=init_"^"_trDate_"^"_trNo_"^"_userName
	s JsonData=##class(web.DHCSTPHCMCOMMON).getJsonData(ListTitle,ListData)
	s ListString=ListString_JsonData_"]}"
 	q ListString
}

/// yunhaibao
ClassMethod FindReqItmByLabel(packlabel)
{
	//s ^yunhaibao("label")=packlabel
	q:packlabel="" "-1,"
	s labelinci=""	
	q:'$d(^DHCINBP(0,"BarCode",packlabel)) "-2,"
	s inbprowid=$o(^DHCINBP(0,"BarCode",packlabel,""))
	s labelinci=+$p(^DHCINBP(inbprowid),"^",1)
	q "0,"_labelinci
}

/// PDA扫码请求明细数据
/// w ##class(web.DHCST.Android.TransferByReq).jsINReqDSingel("NREQ20160303018","(00)090000015000049679")
ClassMethod jsINReqDSingle(reqno As %String, ID As %String) As %GlobalCharacterStream
{
	s $ZT="PDAError^DHCSTERROR"  
	//s ^yunhaibao("jsINReqD")=reqno_"!!"_ID
	s labelinci=$p(..FindReqItmByLabel(ID),",",2)
	s pid=..NewPid()
	s EmptyJson=##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0)
	s EmptyStream=##class(%GlobalCharacterStream).%New()
	d EmptyStream.Write(EmptyJson)
	q:reqno="" EmptyStream
	q:'$d(^INRQ(0,"No",$$ALPHAUP^SSUTIL4(reqno))) EmptyStream
	s req=$o(^INRQ(0,"No",$$ALPHAUP^SSUTIL4(reqno),""))
	q:req="" EmptyStream
	s ShowTransferedFlag=0
	s reqDate=""
	&sql(select inrq_date,INRQ_ReqLoc_DR,INRQ_RecLoc_DR into :reqDate,:requestedLoc,:PrvLocId  from in_request where %ID=:req)
	q:PrvLocId="" EmptyStream
	s HospID=$p(^CTLOC(PrvLocId),"^",22)
	s sql="select %ID rowid,"
	s sql=sql_" inrqi_inci_dr inci,"
	s sql=sql_"inrqi_inci_dr->inci_code code,"
	s sql=sql_"inrqi_inci_dr->inci_desc incidesc,"
	s sql=sql_"inrqi_reqqty qty,"
	s sql=sql_"inrqi_ctuom_dr uom,"
	s sql=sql_"inrqi_ctuom_dr->ctuom_desc uomDesc"
	s sql=sql_" From in_reqitm"
	s sql=sql_" where inrqi_inrq_parref="_req
	s xrs=##class(%Library.ResultSet).%New()
	d xrs.Prepare(sql)
	s sc=xrs.Execute()
	i $$$ISERR(sc) q EmptyStream
	while(xrs.Next())
	{
		s rowid=xrs.Data("rowid")
		s inci=xrs.Data("inci")
		continue:inci'=$g(labelinci)
		s code=xrs.Data("code")
		s desc=xrs.Data("incidesc")
		s qty=xrs.Data("qty")
		s uom=xrs.Data("uom")
		s uomDesc=xrs.Data("uomDesc")
		s spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",inci)
		s manf=$p(##class(web.DHCST.Common.DrugInfoCommon).GetManf(inci),"^",3)
		i manf["-" s manf=$p(manf,"-",2)
		i reqDate="" s reqDate=+$h
		s rp=##class(web.DHCST.Common.PriceCommon).GetClbRp(inci,uom,HospID,"G",+$h,$p($h,",",2)) //add wyx 增加进价
		s sp=##class(web.DHCST.Common.PriceCommon).GetPriceElse(inci,reqDate,uom,HospID,"G","")
		s spAmt=sp*qty
		s rpAmt=rp*qty
		s generic=$p(##class(web.DHCST.Common.DrugInfoCommon).GetGene(inci),"^",2)
		s drugForm=$p(##class(web.DHCST.Common.DrugInfoCommon).GetForm(inci),"^",2)
		//&sql(select INRQI_Remark into remark from  dhc_inreqitm where INRQI_INRQI_DR=:rowid )
		s transQty=##class(web.DHCST.DHCINIsTrf).TransQty(rowid)  ;已转移数量(基本单位)
		s buom=$p(^INCI(inci,1),"^",10)   ;基本单位
		s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(uom,buom)
		s puruom=$p(^INCI(inci,3),"^",6)
		s confac=##class(web.DHCST.Common.UtilCommon).UOMFac(puruom,buom)
		s transQty=transQty/fac
		s NotTransQty=qty-transQty
		continue:(ShowTransferedFlag=0)&(NotTransQty<=0)  ;不显示已转移完成的明细
		i NotTransQty<0 s NotTransQty=0
		s RefuseFlag=$p(^INRQ(+rowid,"RQI",$p(rowid,"||",2)),"^",6)
		i RefuseFlag="Y" s RefuseFlag=1
		e  s RefuseFlag=0
		s reqqty=##class(web.DHCST.Common.DrugStkCommon).LocDayQtyUom(inci,PrvLocId,puruom,+$h) //请求科室库存
		s prvqty=##class(web.DHCST.Common.DrugStkCommon).LocDayQtyUom(inci,requestedLoc,puruom,+$h) //供应科室库存
		s stkbindesc="",stkbinorder=""
		i $d(^INCI("IL_LOC",requestedLoc,inci)) d
		.s incich=$o(^INCI("IL_LOC",requestedLoc,inci,""))
		.s incil=inci_"||"_incich
		.s stkbindesc=$p(##Class(web.DHCST.INCStkBin).GetInciBinStr(incil),":",2)
		.s stkbinorder=stkbindesc
		i stkbindesc="" s stkbinorder="ZZZZZZZZZ1"
		//排序用
		s transedqty=transQty
		s data1=rowid_"^"_inci_"^"_code_"^"_desc_"^"_qty
		s data2=uom_"^"_uomDesc_"^"_spec_"^"_manf_"^"_sp
		s data3=spAmt_"^"_generic_"^"_drugForm_"^"_$g(remark)_"^"_transQty
		s data4=NotTransQty_"^"_buom_"^"_confac_"^"_reqqty_"^"_prvqty
		s data5=rp_"^"_rpAmt_"^"_RefuseFlag_"^"_stkbindesc_"^"_transedqty
		s sumdata=data1_"^"_data2_"^"_data3_"^"_data4_"^"_data5
		s ^TMP("DHCST","web.DHCST.Android.TransferByReq","jsINReqD",pid,stkbinorder,rowid)=sumdata	
	}
	q:'$d(^TMP("DHCST","web.DHCST.Android.TransferByReq","jsINReqD",pid)) EmptyStream
	s count=0
	s title1="rowid^inci^code^desc^qty"
	s title2="uom^uomDesc^spec^manf^sp"
	s title3="spAmt^generic^drugForm^remark^transQty"
	s title4="NotTransQty^BUomId^ConFac^reqqty^prvqty"
	s title5="rp^rpAmt^RefuseFlag^StkBinDesc^transedqty"
	s title=title1_"^"_title2_"^"_title3_"^"_title4_"^"_title5
	s ListStream=##class(%GlobalCharacterStream).%New()
	s count=0
	s stkbindesc=""
	f  s stkbindesc=$o(^TMP("DHCST","web.DHCST.Android.TransferByReq","jsINReqD",pid,stkbindesc)) q:stkbindesc=""  d
	.s rowid=""
	.f  s rowid=$o(^TMP("DHCST","web.DHCST.Android.TransferByReq","jsINReqD",pid,stkbindesc,rowid)) q:rowid=""  d
	..s detaildata=^TMP("DHCST","web.DHCST.Android.TransferByReq","jsINReqD",pid,stkbindesc,rowid)
	..s outputjson=##class(web.DHCSTPHCMCOMMON).getJsonData(title,detaildata)
	..s count=count+1
	..I count=1 d
	...d ListStream.Write(##class(web.DHCSTPHCMCOMMON).getJsonStartSign(1))
	...d ListStream.Write(outputjson)
	..e  d
	...d ListStream.Write(",")
	...d ListStream.Write(outputjson)
    i count>0 d ListStream.Write(##class(web.DHCSTPHCMCOMMON).getJsonEndSign())
    e  d ListStream.Write(EmptyJson)
	k ^TMP("DHCST","web.DHCST.Android.TransferByReq","jsINReqD",pid)
	Q ""
}

ClassMethod NewPid()
{
	q $i(^DHCSTPDA("web.DHCST.Android.TransferByReq"))
}

}
