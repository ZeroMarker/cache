Import sqluser

Class web.DHCST.INReqItm Extends (%RegisteredObject, %XML.Adaptor, StkTypeG) [ Not ProcedureBlock ]
{

/// 插入或更新1条转移请求单明细记录    
/// Author:zhwh
/// Date:2011-07-11
/// 
/// Argu:
///   reqitm -请求单明细rowid
///    req - 请求单主表rowid
///    data - 明细数据串("^"分隔)
/// Return:
///   0 -success
///   <0 - failure
///   
ClassMethod Update(reqitm As %String, req As %String, data As %String) As %String
{
  q:req="" -99
  s inci=$p(data,"^",1)  //库存项rowid
  s uom=$p(data,"^",2)   //库存单位rowid
  s qty=$p(data,"^",3)    //数量
  s:qty'="" qty=+qty
  s colremark=$p(data,"^",4)  //备注
  s scg=$p(data,"^",5)
  s ppqty=$p(data,"^",6)  //建议数量
  s INRQIRowId=""
  s err=0
  q:##class(web.DHCST.Common.AppCommon).Lock(##class(web.DHCST.INRequest).%GetParameter("APPNAME")_req) //加锁(主表)
  i reqitm="" d
  .s exflag=..IncExist(req,inci)     //解决多次快速点击保存造成记录重复  add by ct
  .i exflag=1 s err=-1
  .q:exflag=1
  .s ch=$o(^INRQ(req,"RQI",""),-1)+1
  .s reqdate=$p(^INRQ(req),"^",2)
  .&sql(insert into in_reqitm (inrqi_inrq_parref,inrqi_inci_dr,inrqi_reqqty,inrqi_ctuom_dr,inrqi_date)
    values(:req,:inci,:qty,:uom,:reqdate) )
  .i SQLCODE'=0  s err=-1
  .s reqitmid=req_"||"_ch
  .&sql(insert into dhc_inreqitm (INRQI_INRQI_DR,INRQI_Remark,INRQI_ProReqQty) values (:reqitmid,:colremark,:ppqty))
  .i SQLCODE'=0 S err=-1
  
  e  d
  .s obj=##class(User.INReqItm).%OpenId(reqitm)
  .d obj.%Reload()
  .s obj.INRQIINCIDR=##class(User.INCItm).%OpenId(inci,0)  //不知道为什么这种方式就不行modify by wyx 2014-07-15
  .//s $p(^INRQ(+reqitm,"RQI",$p(reqitm,"||",2)),"^",4)=inci  //
  .s obj.INRQIDate=+$h
  .s obj.INRQICTUOMDR=##class(User.CTUOM).%OpenId(uom,0)
  .s obj.INRQIReqQty=+qty
  .s sc= obj.%Save()
  .i $$$ISERR(sc) s err=-2
  .s INRQIRowId=$o(^DHCINRQI(0,"INRQI",reqitm, INRQIRowId))
  .i INRQIRowId'="" d
  ..s obj=##class(User.DHCINReqItm).%OpenId(INRQIRowId,0)
  ..d obj.%Reload()
  ..s obj.INRQIRemark=colremark
  ..s sc= obj.%Save()
  ..i $$$ISERR(sc) s err=-3
  .e  d
  ..&sql(insert into dhc_inreqitm (INRQI_INRQI_DR,INRQI_Remark,INRQI_ProReqQty) values (:reqitm,:colremark,:ppqty))
  ..i SQLCODE'=0 s err=-4
  d ##class(web.DHCST.Common.AppCommon).UnLock(##class(web.DHCST.INRequest).%GetParameter("APPNAME")_req)
  q err
}

/// 取一条转移请求单明细记录
/// Author:zhwh
/// Date:2011-07-11
/// Argu:
///   reqItm - 请求单字表rowid
/// Return:
///   转移请求单明细记录数据串("^"分隔)
ClassMethod Select(reqItm) As %String
{
 n (reqItm)
 k PLIST
 s result=""
 &sql(select * into :PLIST() from IN_ReqItm where %ID=:reqItm)
 q:SQLCODE result
 s cnt=$o(PLIST(""),-1)
 f i=1:1:cnt d
 .i result="" s result=$g(PLIST(i))
 .e  s result=result_"^"_$g(PLIST(i))
 q result
}

/// 删除库存转移请求单明细
/// Author:zhwh
/// Date:2011-07-11
ClassMethod Delete(reqItm) As %String
{
 n (reqItm)
 q:reqItm="" -4
 s req=+reqItm
 s allowdel=##class(web.DHCST.INRequest).AllowDel(req)
 q:allowdel<0 allowdel   //不允许删除
 &sql(delete from in_reqitm where %ID=:reqItm)
 q:SQLCODE'=0 -5
 q 0
}

/// 检索库存转移请求单明细记录数据串(json)
/// Author:zhwh
/// Date:2011-07-11
/// w ##class(web.DHCST.INReqItm).jsINReqD(0,999,"","","5466","0")
ClassMethod jsINReqD(Start As %String, Limit As %String, Sort As %String, Dir As %String, req As %String, showFlag As %String = 1)
{
     s result=##class(%Library.ResultSet).%New("web.DHCST.INReqItm:INReqD") 
     s sc=result.Execute(req,showFlag)
     i $$$ISERR(sc) q ""
     s colNum=result.GetColumnCount()
     s end = Start+Limit
     i $$$ISERR(sc) q ""
     s endpage=Start+Limit  //结束行
     s stpage=Start+1 //开始行
     s pid=..NewPid()
     Set $ZT="ERRORjsDHCSTINReqItm"
     s h=0
	While(result.Next())
	{ 
	    s data=""
	    f i=1:1:colNum d
  		.i data="" s data=result.%GetData(i)
		.e   s data=data_"^"_result.%GetData(i)
        s rowid=$p(data,"^",1)
        s h=h+1
        s index=h
        s ^TMP("DHCST","INReqItm","jsINReqD",pid,"index",index)=data

	 }
	i '$d(^TMP("DHCST","INReqItm","jsINReqD",pid,"index")) w "{results:0,rows:[]}"
	q:'$d(^TMP("DHCST","INReqItm","jsINReqD",pid,"index")) ""
	s maxrow=h
	i endpage>maxrow s endpage=maxrow
    s count=0
    s h=""
    f  s h=$o(^TMP("DHCST","INReqItm","jsINReqD",pid,"index",h)) q:h=""  d
    .s data=^TMP("DHCST","INReqItm","jsINReqD",pid,"index",h)
    .s rowid=$p(data,"^",1)
    .s inci=$p(data,"^",2)
    .s code=$p(data,"^",3)
    .s desc=$p(data,"^",4)
    .s qty=$p(data,"^",5)
    .s uom=$p(data,"^",6)
    .s uomDesc=$p(data,"^",7)
    .s spec=$p(data,"^",8)
    .s manf=$p(data,"^",9)
    .s sp=$p(data,"^",10)
    .s spAmt=$p(data,"^",11)
    .s generic=$p(data,"^",12)
    .s drugForm=$p(data,"^",13)
    .s remark=$p(data,"^",14)
    .s reqqty=$p(data,"^",19)
    .s prvqty=$p(data,"^",20)
    .s rp=$p(data,"^",21)
    .s rpAmt=$p(data,"^",22)
    .s cancel=$p(data,"^",23)
    .s buom=$p(data,"^",17)
    .s confac=$p(data,"^",18)
    .s nottransqty=$p(data,"^",16)
    .s transqty=$p(data,"^",15) 
    .s consumqty=$p(data,"^",24)
    .s count=count+1
    .q:count<stpage
    .q:count>endpage
    .s cancel=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("cancel",cancel)
    .s rowid=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("rowid",rowid)
    .s inci=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("inci",inci)
    .s code=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("code",code)
    .s desc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("desc",desc)
    .s qty=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("qty",qty)
    .s uom=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("uom",uom)
    .s uomDesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("uomDesc",uomDesc)
    .s spec=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("spec",spec)
    .s manf=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("manf",manf)
    .s sp=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("sp",sp)
    .s spAmt=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("spAmt",spAmt)
    .s generic=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("generic",generic)
    .s drugForm=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("drugForm",drugForm)
    .s remark=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("remark",remark)
    .s reqqty=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("reqqty",reqqty)
    .s prvqty=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("prvqty",prvqty)
    .s rp=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("rp",rp)
    .s rpAmt=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("rpAmt",rpAmt)
    .s buom=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("buom",buom)
    .s transqty=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("transQty",transqty)
    .s nottransqty=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("NotTransQty",nottransqty)
    .s consumqty=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("consumqty",consumqty)
    .s confac=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("confac",confac)
    .s tmpstr=cancel_rowid_inci_code_desc_qty_uom_uomDesc_spec_manf_sp_spAmt_generic_drugForm_remark_reqqty_prvqty_rp_rpAmt_buom_nottransqty_consumqty_transqty_confac
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
    .i count=stpage w startString
    .i count<endpage w firstrow
    .i count=endpage w lastrow
    .
    k ^TMP("DHCST","INReqItm","jsINReqD",pid) 

    q ""
 
 
 
ERRORjsDHCSTINReqItm
    //遇报错,则先kill TMP
	k ^TMP("DHCST","INReqItm","jsINReqD",pid)     
    q $ze
}

/// 检索库存转移请求单明细记录
/// Author:zhwh
/// Date:2011-07-11
/// zdm,2012-10-19,增加参数：是否显示已转移完成的请求明细（1：显示；0：不显示）
/// 增加输出：已转移数量，未转移数量
/// d ##class(%ResultSet).RunQuery("web.DHCST.INReqItm","INReqD",11)
Query INReqD(req As %String, ShowTransferedFlag As %String = 1) As %Query(ROWSPEC = "rowid:%String,inci:%String,code:%String,desc:%String,qty:%Float,uom:%String,uomDesc:%String,spec:%String,manf:%String,sp:%Float,spAmt:%Float,generic:%String,drugForm:%String,remark:%String,transQty:%Float,NotTransQty:%Float,BUomId:%String,ConFac:%String,reqqty:%String,prvqty:%String,rp:%Float,rpAmt:%Float,RefuseFlag:%String,ProduceQty:%String,INRecLocIO,INReqLocIO,INReqScgIO,INReqUserIO,INReqRemarkIO,INReqTypeIO,HospDescIO") [ SqlProc ]
{
}

ClassMethod INReqDExecute(ByRef qHandle As %Binary, req As %String, ShowTransferedFlag As %String = 1) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 s qHandle=$lb(0,repid,0)
 q:req="" $$$OK
 
 /// 润乾中允许输入汉字，汉字出参从query中输出
 s (INRecLocIO,INReqLocIO,INReqScgIO,INReqUserIO,INReqRemarkIO,INReqTypeIO,HospDescIO)=""
 s mainInfoStr=##class(web.DHCST.INRequest).Select(req)
 s INRecLocIO=$P(mainInfoStr,"^",13)
 s INReqLocIO=$P(mainInfoStr,"^",14)
 s INReqScgIO=$P(mainInfoStr,"^",17)
 s INReqUserIO=$P(mainInfoStr,"^",15)
 s INReqRemarkIO=$P(mainInfoStr,"^",11)
 s INReqTypeIO=$P(mainInfoStr,"^",18)
 s ReqLocId=$p(^INRQ(req),"^",5)
 s HospDescIO=$P(^CTLOC(ReqLocId),"^",22)
 s:HospDescIO'="" HospDescIO=$P(^CT("HOSP",HospDescIO),"^",2)
 
 
 s reqDate=""
 &sql(select inrq_date,INRQ_ReqLoc_DR,INRQ_RecLoc_DR into :reqDate,:requestedLoc,:PrvLocId  from in_request where %ID=:req)
 
 q:PrvLocId="" ""
 s HospID=$p(^CTLOC(PrvLocId),"^",22)
 s Params=""_"^"_requestedLoc_"^"_""_"^"_HospID
 s ExpLimitFlag=##class(web.DHCST.Common.AppCommon).GetAppPropValue(##class(web.DHCST.DHCINIsTrfItm).%GetParameter("AppName"),"ExpLimitFlag",Params)   //过期药品是否限制出库
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
 i $$$ISERR(sc) q $$$OK
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
    i reqDate="" s reqDate=+$h
    s rp=##class(web.DHCST.Common.PriceCommon).GetClbRp(inci,uom,HospID,"G",+$h,$p($h,",",2)) //add wyx 增加进价
    s sp=##class(web.DHCST.Common.PriceCommon).GetPriceElse(inci,reqDate,uom,HospID,"G","")
    s spAmt=sp*qty
    s rpAmt=rp*qty
    s generic=$p(##class(web.DHCST.Common.DrugInfoCommon).GetGene(inci),"^",2)
    s drugForm=$p(##class(web.DHCST.Common.DrugInfoCommon).GetForm(inci),"^",2)    
    s transQty=##class(web.DHCST.DHCINIsTrf).TransQty(rowid)  ;已转移数量(基本单位)
    s buom=$p(^INCI(inci,1),"^",10)   ;基本单位
    s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(uom,buom)
    s puruom=$p(^INCI(inci,3),"^",6)
    s confac=##class(web.DHCST.Common.UtilCommon).UOMFac(puruom,buom)
    s transQty=transQty/fac
    s NotTransQty=qty-transQty
    i NotTransQty<0 s NotTransQty=0
    continue:(ShowTransferedFlag=0)&(NotTransQty<=0)  ;不显示已转移完成的明细
    s RefuseFlag=$p(^INRQ(+rowid,"RQI",$p(rowid,"||",2)),"^",6)
    i RefuseFlag="Y" s RefuseFlag=1
    e  s RefuseFlag=0
    //continue:RefuseFlag="Y" ///add wyx 过滤作废的明细
    s reqqty=##class(web.DHCST.Common.DrugStkCommon).LocDayQtyUom(inci,PrvLocId,uom,+$h) //请求科室库存
 	if ExpLimitFlag'="Y"  d
    .s prvqty=##class(web.DHCST.Common.DrugStkCommon).LocDayQtyUom(inci,requestedLoc,uom,+$h) //供应科室库存
    e  s prvqty=##class(web.DHCST.Common.DrugStkCommon).LocNotOutOfDateQtyUom(inci,requestedLoc,uom,+$h) //供给科室可用库存
    s produceqty="",remark=""
    i $d(^DHCINRQI(0,"INRQI",rowid)) d
    .s dhcinrqi=$o(^DHCINRQI(0,"INRQI",rowid,""),-1)
    .i dhcinrqi'="" d
    ..s produceqty=$p($g(^DHCINRQI(dhcinrqi)),"^",4)
    ..s remark=$p($g(^DHCINRQI(dhcinrqi)),"^",2)
    d OutPutRow 
 }
 
 Quit $$$OK
OutPutRow
 s Data=$lb(rowid,inci,code,desc,qty,uom,uomDesc,spec,manf,sp,spAmt,generic,drugForm,$g(remark),transQty,NotTransQty,buom,confac,reqqty,prvqty,rp,rpAmt,RefuseFlag,produceqty,INRecLocIO,INReqLocIO,INReqScgIO,INReqUserIO,INReqRemarkIO,INReqTypeIO,HospDescIO)   
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

ClassMethod INReqDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = INReqDExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod INReqDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = INReqDExecute ]
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

/// 保存请求单明细数据
/// Author:zhwh
/// Date:2012-07-12
/// Argu:
///       req - 请求单主表rowid
///       rows - 请求单明细记录数据串(记录之间用","分隔)
/// Return:
///    0 - success
///    <0 - failure
ClassMethod Save(req As %String, rows As %String) As %String
{
  q:req="" -1
  q:##class(web.DHCST.Common.AppCommon).Lock(##class(web.DHCST.INRequest).%GetParameter("APPNAME")_req)<0 -99
  s err=0
  
  s rowDelim=##class(web.DHCST.Common.UtilCommon).RowDataDelim()	//记录行分隔符设置
  i rows="" s rowcnt=0
  e  s rowcnt=$l(rows,rowDelim)   //
  q:rowcnt=0 0
  s count=0,NotUseExistFlag=""
  ts
  f i=1:1:rowcnt  q:err<0  d
  .s row=$P(rows,rowDelim,i)
  .s reqi=$P(row,"^",1)
  .s data=$P(row,"^",2,$L(row,"^"))
  .s inci=$P(data,"^",1)
  .s NotUseFlag=$P(^INCI(inci,2),"^",9)
  .i NotUseFlag="Y" s NotUseExistFlag=1
  .q:NotUseFlag="Y"  
  .q:data=""
  .s err=..Update(reqi,req,data)
  .i err<0 tro
  .q:err<0
  .s count=count+1
  q:(count=0)&&(NotUseExistFlag=1) -99_"无需要保存的明细，请检查是否有不可用药品!"
  
  
  d ##class(web.DHCST.Common.AppCommon).UnLock(##class(web.DHCST.INRequest).%GetParameter("APPNAME")_req)
  q:err<0 -2
  tc
  q err
}

ClassMethod NewPid() As %String
{
  q $I(^DHCSTPID("DHCSTINReqItm"))
}

// wyx

// 作废请求明细记录

ClassMethod CancelReqItm(ListId, CancelFlag = "") As %String
{
   q:ListId="" -1
   s cnt=$l(ListId,"^")
   s ifrefuse="Y"
   i CancelFlag="N" s ifrefuse=""
   s err=0
   ts
   f num=1:1:cnt d
   .s reqitm=$p(ListId,"^",num)
   .&sql(update IN_ReqItm set INRQI_RefuseFlag=:ifrefuse where INRQI_RowId=:reqitm)
   .i SQLCODE<0 d
   ..s err=SQLCODE
   ..tro
   .q:SQLCODE<0
   tc
   q:err<0 -2
   q 0
}

/// Descript:根据药品id取药品采购默认信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-06-19
/// Table:
/// Input:库存项id,安全组id^科室id^用户id
/// Output:     
/// Return：供应商id^供应商名称^产地id^产地名称^配送商id^配送商名称^入库单位id
/// ^入库单位^进价^售价^申购科室库存量^库存上限^库存下限^通用名^商品名^剂型^规格
/// w ##class(web.DHCST.INPurPlan).GetItmInfo(534,274)
ClassMethod GetItmInfo(IncId As %String, Params As %String) As %Library.String
{
    n (IncId,Params)
    s GroupId=$p(Params,"^",1)
    s LocId=$p(Params,"^",2)
    s UserId=$p(Params,"^",3)
    s PrvLocId=$p(Params,"^",3)
    s HospId=""
    s:LocId'="" HospId=$p(^CTLOC(LocId),"^",22)
    s ParamStr=GroupId_"^"_LocId_"^"_UserId_"^"_HospId
    s ParamStr1=GroupId_"^"_PrvLocId_"^"_UserId_"^"_HospId
 	s ExpLimitFlag=##class(web.DHCST.Common.AppCommon).GetAppPropValue(##class(web.DHCST.DHCINIsTrfItm).%GetParameter("AppName"),"ExpLimitFlag",ParamStr1)   //过期药品是否限制出库
    s VenInfo=##class(web.DHCST.Common.DrugInfoCommon).GetConfigVendor(IncId,##class(web.DHCST.INPurPlan).%GetParameter("AppName"),ParamStr)
    s VenId=$p(VenInfo,"^",1)
    s VenDesc=$p(VenInfo,"^",2)
    ;
    s ManfInfo=##class(web.DHCST.Common.DrugInfoCommon).GetConfigManf(IncId,##class(web.DHCST.INPurPlan).%GetParameter("AppName"),ParamStr)
    s ManfId=$p(ManfInfo,"^",1)
    s ManfDesc=$p(ManfInfo,"^",2)
    ;
    s CarrierInfo=##class(web.DHCST.Common.DrugInfoCommon).GetConfigCarrier(IncId,##class(web.DHCST.INPurPlan).%GetParameter("AppName"),ParamStr)
    s CarrierId=$p(CarrierInfo,"^",1)
    s CarrierDesc=$p(CarrierInfo,"^",2)
    s BUomId=$p(^INCI(IncId,1),"^",10)
    s PurUomId=$p(^INCI(IncId,3),"^",6)
    s:PurUomId'="" PurUomDesc=$p(^CT("UOM",PurUomId),"^",2)
    s Confac=##class(web.DHCST.Common.UtilCommon).UOMFac(PurUomId,BUomId)
    s Rp=##class(web.DHCST.Common.PriceCommon).GetClbRp(IncId,PurUomId,HospId,"G",+$h,$p($h,",",2)) //add wyx 增加进价
    s Sp=##class(web.DHCST.Common.PriceCommon).GetPriceElse(IncId,+$h,PurUomId,HospId,"G","")
    s StkQty=##class(web.DHCST.Common.DrugStkCommon).LocDayQtyUom(IncId,LocId,PurUomId,+$h)
    s StkQty=$fn(StkQty,"",3)
    i ExpLimitFlag'="Y" d
    .s PrvStkQty=##class(web.DHCST.Common.DrugStkCommon).LocDayQtyUom(IncId,PrvLocId,PurUomId,+$h)     
    e  s PrvStkQty=##class(web.DHCST.Common.DrugStkCommon).LocNotOutOfDateQtyUom(IncId,PrvLocId,PurUomId,+$h) //供给科室可用库存 
    s QtyInfo=##class(web.DHCST.Common.DrugStkCommon).GetItmLocMNRQtyUO(IncId,LocId,PurUomId)
    s MinQty=$p(QtyInfo,"^",1)
    s MaxQty=$p(QtyInfo,"^",2)
    s Spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",IncId)
    s GeneInfo=##class(web.DHCST.Common.DrugInfoCommon).GetGene(IncId)
    s Gene=$p(GeneInfo,"^",2)
    s GoodName=##class(web.DHCST.Common.DrugInfoCommon).GetGoodName(IncId)
    s FormInfo=##class(web.DHCST.Common.DrugInfoCommon).GetForm(IncId)
    s Form=$p(FormInfo,"^",1)
    s Data1=VenId_"^"_VenDesc_"^"_ManfId_"^"_ManfDesc_"^"_CarrierId_"^"_CarrierDesc_"^"_PurUomId_"^"_$g(PurUomDesc)
    s Data2=Rp_"^"_Sp_"^"_StkQty_"^"_MaxQty_"^"_MinQty_"^"_Gene_"^"_GoodName_"^"_Form_"^"_Spec_"^"_BUomId_"^"_Confac
    s Data3=PrvStkQty
    q Data1_"^"_Data2_"^"_Data3
}

ClassMethod IncExist(req, inci) As %String
{
	s existflag=0
	s reqi=""
	f  s reqi=$o(^INRQ(req,"RQI",reqi)) q:reqi=""  d
	.s incidr=$p(^INRQ(req,"RQI",reqi),"^",4)
	.i incidr=inci s existflag=1
	q existflag
}

/// creator:yunhaibao
/// createdate:20151130
/// description:库存请求单未转移项新建请求单,供出库单查询-右键查询未转移项生成请求单调用
/// input:原请求单id,用户id
/// w ##class(web.DHCST.INReqItm).InsertReqByNotMove("61368||17","25377")
ClassMethod InsertReqByNotMove(inreqitmstr, userid)
{
	n (inreqitmstr,userid)
	s rowDelim=##class(web.DHCST.Common.UtilCommon).RowDataDelim()	//记录行分隔符设置
	s inreq=+$p(inreqitmstr,rowDelim,1)
	q:inreq="" "请求单主信息获取失败!"
	s fromloc=$p(^INRQ(inreq),"^",5)
	s toloc=$p(^INRQ(inreq),"^",6)
	i userid="" s userid=1
	q:'$d(^DHCINRQ(0,"INRQ",inreq)) "请求单附加信息获取失败!"
	s dhcinreq=$o(^DHCINRQ(0,"INRQ",inreq,""))
	s scg=$p(^DHCINRQ(dhcinreq),"^",10)
	s status="O"
	s remark=""
	s maininfo=fromloc_"^"_toloc_"^"_userid_"^"_scg_"^"_status_"^"_remark
	s detailstr=""
	s inreqi=""
	f inreqi=1:1:$l(inreqitmstr,rowDelim) d
	.s inreqitminfo=$p(inreqitmstr,rowDelim,inreqi)
	.s qty=$p(inreqitminfo,"^",2)
	.s inreqitm=$p(inreqitminfo,"^",1)
	.q:+qty<=0
	.//明细信息
	.s rowid=""
	.s inc=$p(^INRQ(+inreqitm,"RQI",$p(inreqitm,"||",2)),"^",4)
	.s uomid=$p(^INRQ(+inreqitm,"RQI",$p(inreqitm,"||",2)),"^",5)
	.s colRemark=""
	.s ppqty=qty
	.s detail=""_"^"_inc_"^"_uomid_"^"_qty_"^"_colRemark_"^"_scg_"^"_ppqty
	.i detailstr="" s detailstr=detail
	.e  s detailstr=detailstr_$c(1)_detail
	q:detailstr="" "明细数据为空!"
	s reqret=##class(web.DHCST.INRequest).Save("",maininfo,detailstr)
	q:reqret<0 "生成请求单失败!"_reqret	
	s completeret=##class(web.DHCST.INRequest).SetCompleteStatus(reqret,"Y") //置完成
	q:completeret'=0 "置请求单完成状态失败!"_completeret
	s reqno=$p(^INRQ(reqret),"^",1)
	q "success"_"^"_reqno
}

}
