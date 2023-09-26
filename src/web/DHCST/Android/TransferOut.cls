Import sqluser

Class web.DHCST.Android.TransferOut Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

Parameter AppName [ Final ] = "DHCSTTRANSFER";

/// Descript:   保存/更新出库单信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-07-20
/// Table:DHC_InIsTrf,DHC_InIsTrfItm
/// Input:出库主表id;
/// 供应科室RowId^请求科室RowId^库存转移请求单RowId^出库类型RowId^完成标志^单据状态^制单人RowId^类组RowId^库存类型^备注^入库单id,
/// 明细id^批次id^数量^单位^请求明细id^备注，明细id^批次id^数量^单位^请求明细id^备注
/// Output:     
/// Return：成功：出库主表id；
/// 失败：ErrCode:ErrInfo
/// w ##class(web.DHCST.Android.TransferOut).Save("","50^15^^^Y^11^2^^^看看")
ClassMethod Save(InitId As %String, MainInfo As %String) As %Library.String
{
    n (InitId,MainInfo,ListData)
    tstart
    s $ZT="Error^DHCSTERROR"                        ;增加错误处理
    s MainId=""
    s Ret=..Update(InitId,MainInfo)
    i +Ret>0  d
    .s MainId=Ret
    e  i Ret=-99  d
    .s ErrInfo="加锁失败"
    e  i Ret=-2   d
    .s ErrInfo="生成单号失败"
    e  d
    .s ErrInfo="保存转移单主表失败"
    i MainId<0 trollback
    q:MainId="" Ret_":"_ErrInfo_"error"
    tcommit    ;全部保存成功，则提交事务
    ;
    
    q $p(^DHCINIT(MainId),"^",1)_","_MainId
}

/// 插入或更新转移主表记录
/// Author:zhwh
/// Date:2012-07-13
/// Argu:
///    init - 主表rowid
///    data - 数据串
///    
/// Return:
///   > 0  - 库存转移主表rowid
///   <0 - 插入或更新错误
ClassMethod Update(init As %String, data As %String) As %String
{
 n (init,data)
 s frLoc=$p(data,"^",1) //供应科室RowId
 s toLoc=$p(data,"^",2) //请求科室RowId
 s req=$p(data,"^",3) //库存转移请求单RowId
 s opType=$p(data,"^",4) //出库类型RowId
 i +opType=0 s opType=..GetFirstOperateType() //正常出库rowid //之前为空的时候默认为6了
 s comp=$p(data,"^",5) //“完成”标志
 s status=$p(data,"^",6) //单据状态
 s user=$p(data,"^",7) //制单人RowId
 s scg=$p(data,"^",8) //类组RowId
 s stkType=$p(data,"^",9) //库存类型
 s remark=$p(data,"^",10) //备注
 s remark=$lfs(remark,$c(3))
 s ingrid=$p(data,"^",11) //入库单id,zdm,2012-10-22	;依入库单转移时用到
 
 i (scg="") && (ingrid'="") d
 .s scg=$p(^DHCINGR(ingrid),"^",28)		;依入库单转移时用到
 b //2
 i (scg="") && (req'="") d
 .&sql(select INRQ_RowId into :inrq from DHC_INRequest where INRQ_INRQ_DR=:req)
 .q:inrq=""
 .s scg=$p(^DHCINRQ(inrq),"^",10)
 s d=+$h
 s t=$p($h,",",2)
 s AppName=..%GetParameter("AppName")
 ;
 s result=0
 i init="" d
 . 
 .;生成单号需加锁
 .s ret=##class(web.DHCST.Common.AppCommon).Lock("TRANSFERNO")  
 .s:ret'=0 result=-99  ;加锁失败
 .q:ret'=0
 .;
 .s TrNo=##class(web.DHCST.Common.AppCommon).GetAppNo(AppName,scg,frLoc)
 .;b ;222
 .s:TrNo="" result=-2   ;生成单号失败
 .i TrNo="" d ##class(web.DHCST.Common.AppCommon).UnLock("TRANSFERNO")
 .q:TrNo=""
 .&sql(insert into dhc_inistrf (INIT_No, init_frloc_dr,
  init_toloc_dr,init_inrq_dr,init_date,init_time,init_ssusr_dr,
  init_state,init_usercompleted,init_scg_dr,init_stktype,
  INIT_OperateType,INIT_INGR_Dr,INIT_Remarks)
  values (:TrNo,:frLoc,:toLoc,:req,:d,:t,:user,:status,:comp,:scg,:stkType,:opType,:ingrid,:remark) )
 .//b ;3
 .i SQLCODE'=0  d
 ..s ret=$$ErrorRecord^DHCSTERROR(..%GetParameter("AppName"),TrNo,SQLCODE_":"_%msg)
 ..s result=-1
 .e  d
 ..s result=%ROWID
 .d ##class(web.DHCST.Common.AppCommon).UnLock("TRANSFERNO")
 e  d
 .s obj=##class(User.DHCInIsTrf).%OpenId(init)
 .d obj.%Reload()
 .
 .s obj.INITFrLocDR=##class(User.CTLoc).%OpenId(frLoc,0)
 .s result=obj.%Id()
 .
 .s obj.INITToLocDR=##class(User.CTLoc).%OpenId(toLoc,0)
 .s obj.INITINRQDR=##class(User.INRequest).%OpenId(req,0)
 .//s obj.INITDate=d
 .//s obj.INITTime=t
 .s obj.INITOperateType=##class(User.DHCOperateType).%OpenId(opType,0)
 .s obj.INITState= status
 .s obj.INITSCGDR =##class(User.DHCStkCatGroup).%OpenId(scg,0)
 .s obj.INITStkType=stkType
 .s obj.INITSSUSRDR=##class(User.SSUser).%OpenId(user,0)
 .s obj.INITUserCompleted=comp
 .d obj.INITRemarks.Clear()
 .d obj.INITRemarks.InsertList(remark)
 .;b ;123
 .s sc=obj.%Save()
 .i $$$ISERR(sc) s result=-1
 .;b ;124
 q +result
}

/// pda出库完成
/// w ##class(web.DHCST.Android.TransferOut).SetCompleted(10001,"Y","","")
ClassMethod SetCompleted(init As %String, comp As %String, status As %String, type As %String) As %String
{
	s ^yunhaibao("SetCompleted")=init_","_comp_","_status_","_type
	s status=11
	s type=..GetFirstOperateType()
	s retval=##class(web.DHCST.DHCINIsTrf).SetCompleted(init,comp,status,type)
	q:retval'=0 retval
	i $p(^DHCINIT(init),"^",14)=11 d
	.s UserId=$p(^DHCINIT(init),"^",8)
	.s retval=##class(web.DHCST.DHCINIsTrf).TransOutAuditYes(init,UserId)
	q retval
}

/// 获取出库默认的第一个出库类型
/// w ##class(web.DHCST.Android.TransferOut).GetFirstOperateType()
ClassMethod GetFirstOperateType()
{
	s optype=0,n=0,returnType=""
	f  s optype=$O(^DHCOPTYPE(optype)) q:(optype="")!(n=1)  d
	.s type=$P(^DHCOPTYPE(optype),"^",3)
	.q:type'="O"
	.s n=n+1
	.s returnType=optype
	q returnType
}

/// 删除库存转移单明细记录
/// Author:zhwh
/// Date:2012-07-16
/// Argu:
///   initi - 库存转移单明细记录rowid
/// Return：
///   0 -Success
///   <0 - failure
///   
ClassMethod Delete(initi As %String) As %String
{
 n (initi)
 ;s ^zdm("Delete")=initi
 s init=+initi
 q:##class(web.DHCST.DHCINIsTrf).AllowDel(init)<0 -100
 q:##class(web.DHCST.Common.AppCommon).Lock(##class(web.DHCST.DHCINIsTrf).%GetParameter("AppName")_init)<0 -99
 ts
 s inbp=$o(^DHCINBP(0,"INTI",initi,"")) d
 i inbp'="" d
 .&sql(update DHC_IncBatPack set INBP_INITI_Dr=:null where INBP_RowID=:inbp)
 s $ZT="Error^DHCSTERROR" 
 s ret=##class(web.DHCST.DHCINIsTrf).HandleTransItmDirtyQty(initi,0)  //占用数
 i ret<0 tro  d ##class(web.DHCST.DHCINIsTrf).uLock(init)  q -2
 &sql(delete from dhc_inistrfitm where %ID=:initi)
 i SQLCODE'=0 tro  d ##class(web.DHCST.DHCINIsTrf).uLock(init) q -1
 d ##class(web.DHCST.DHCINIsTrf).uLock(init)
 tc
 q 0
}

/// Descript:查询待转移接收单据列表
/// w ##class(web.DHCST.Android.TransferOut).jsQueryTransferOut("2016-09-26","2016-09-26",102,"")
ClassMethod jsQueryTransferOut(startDate As %String, endDate As %String, fromLocID As %String, toLocID As %String) As %GlobalCharacterStream
{
 	n (startDate, endDate, fromLocID, toLocID)
 	s ^yunhaibao("jsQueryTransferOut")=startDate_","_ endDate_","_ fromLocID_","_ toLocID
 	s:startDate'="" startDate=$zdh(startDate,3)
 	s:endDate'="" endDate=$zdh(endDate,3)
 	s ListStream=##class(%GlobalCharacterStream).%New()
 	s count = 0
 	s ListTitle="Init^TrDate^TrNo^LocDesc^User^StkGrpID^StkGrpDesc"
 	f dd=startDate:1:endDate d
 	.s init = ""
 	.f  s init=$o(^DHCINIT(0,"TrfDate",dd,init)) q:init=""  d
 	..s state=$p(^DHCINIT(init),"^",14)
 	..q:state'="10"
 	..s trNo=$p(^DHCINIT(init),"^",1)
 	..s trDate=$p(^DHCINIT(init),"^",2)
 	..s:trDate'="" trDate=$zd(trDate,3)
 	..s fLocID=$p(^DHCINIT(init),"^",5)
 	..q:fLocID=""
 	..q:(fromLocID'=fLocID)
 	..s fLocDesc=$p($p(^CTLOC(fLocID),"^",2),"-",2)
 	..s tLocID=$p(^DHCINIT(init),"^",6)
 	..q:tLocID=""
 	..q:(toLocID'="")&(toLocID'=tLocID)
 	..s tLocDesc=$p($p(^CTLOC(tLocID),"^",2),"-",2)
 	..s userID=$p(^DHCINIT(init),"^",8)
 	..q:userID=""
 	..s userName=$p(^SSU("SSUSR",userID),"^",2)
 	..s stkcatgrpdesc=""
 	..s inrqscg=$p(^DHCINIT(init),"^",23)
 	..i inrqscg'="" s stkcatgrpdesc=$p(^DHCSCG(inrqscg),"^",2)
 	..
 	..s ListData=init_"^"_trDate_"^"_trNo_"^"_tLocDesc_"^"_userName_"^"_inrqscg_"^"_stkcatgrpdesc
 	..s outputjson=##class(web.DHCSTPHCMCOMMON).getJsonData(ListTitle,ListData)
	..s count = count+1       
	..I count=1 d
	...S tmpdel=""""
	...s tmpTitle="{"_tmpdel_"ErrCode"_tmpdel_":"_0_","_tmpdel_"rows"_tmpdel_":["
	...d ListStream.Write(tmpTitle)
	...d ListStream.Write(outputjson)
	..e  d
	...d ListStream.Write(",")
	...d ListStream.Write(outputjson)
	s EmptyJson=##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0)
 	i count>0 d ListStream.Write(##class(web.DHCSTPHCMCOMMON).getJsonEndSign())
 	e  d ListStream.Write(EmptyJson)
 	q ListStream
}

/// Descript:查询待转移单明细列表
/// w ##class(web.DHCST.Android.TransferOut).jsQueryTransferOutDet(5)
ClassMethod jsQueryTransferOutDet(init As %String) As %GlobalCharacterStream
{
	n (init)
 	s count = 0
 	s ListStream=##class(%GlobalCharacterStream).%New()
 	s ListTitle="initi^inciDesc^qty^batNo^expDate^uomDesc^inci^uom^barcode^parbarcode^inclb"
	s initchl=""
	f  s initchl=$o(^DHCINIT(init,"ITI",initchl)) q:initchl=""  d
	.q:+initchl=0
	.s initi=init_"||"_initchl
	.s inclb=$p(^DHCINIT(init,"ITI",initchl),"^",3)
	.s incib=$p(^INCI(+inclb,"IL",$p(inclb,"||",2),"LB",$p(inclb,"||",3)),"^",1)
	.s batNo=$p(^INCI(+incib,"IB",$p(incib,"||",2)),"^",1)
	.s expDate=$p(^INCI(+incib,"IB",$p(incib,"||",2)),"^",2)
	.i expDate'="" s expDate=$zd(expDate,3)
	.s uom=$p(^DHCINIT(init,"ITI",initchl),"^",7)
	.s qty=$p(^DHCINIT(init,"ITI",initchl),"^",1)
	.s substatus=$p(^DHCINIT(init,"ITI",initchl),"^",23)
	.s remark=$p(^DHCINIT(init,"ITI",initchl),"^",24)
	.s fromloc=$p(^DHCINIT(init),"^",5)
	.s fromlocdesc=$p(^CTLOC(fromloc),"^",2)
	.s inci=+inclb
	.s inciCode=$P(^INCI(inci,1),"^",1)
	.s inciDesc=$P(^INCI(inci,1),"^",2)
	.s uomDesc=$p(^CT("UOM",uom),"^",2)
	.s barcode="",parbarcode=""
	.s InbpID=$o(^DHCINBP(0,"INTI",initi,""))
	.i InbpID'="" d
	..s barcode=$p(^DHCINBP(InbpID),"^",2)
	..s parbarcode=$p(^DHCINBP(InbpID),"^",5)
	.s ListData=initi_"^"_inciDesc_"^"_qty_"^"_batNo_"^"_expDate_"^"_uomDesc_"^"_inci_"^"_uom_"^"_barcode_"^"_parbarcode_"^"_inclb
	.s outputjson=##class(web.DHCSTPHCMCOMMON).getJsonData(ListTitle,ListData)
	.s count = count+1       
	.I count=1 d
	..S tmpdel=""""
	..s tmpTitle="{"_tmpdel_"ErrCode"_tmpdel_":"_0_","_tmpdel_"rows"_tmpdel_":["
	..d ListStream.Write(tmpTitle)
	..d ListStream.Write(outputjson)
	.e  d
	..d ListStream.Write(",")
	..d ListStream.Write(outputjson)
	s EmptyJson=##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0)
 	i count>0 d ListStream.Write(##class(web.DHCSTPHCMCOMMON).getJsonEndSign())
 	e  d ListStream.Write(EmptyJson)
 	q ListStream
}

/// Descript:删除DHC_IncBatPack
ClassMethod HandleIncBatPack(initi As %String) As %String
{
	n (initi)
	s inbpid=$o(^DHCINBP(0,"INTI",initi,""))
	q:inbpid="" ""
	s qty=$p(^DHCINBP(inbpid),"^",4)  //数量
	s barcode=$p(^DHCINBP(inbpid),"^",2)  //条码
	s parbarcode=$p(^DHCINBP(inbpid),"^",5) //父条码

	s ret=0
	/// 1、条码相同清空转移子表
	i barcode = parbarcode d
	.&sql(update DHC_IncBatPack set INBP_INITI_Dr=:Null where INBP_ROWID =:inbpid)
	.i SQLCODE'=0 s err = "-1"

	/// 2、条码不相同
	i barcode '= parbarcode d
	.&sql(delete DHC_IncBatPack where INBP_ROWID =:inbpid)
	.i SQLCODE'=0 s err = "-2"
	.q:SQLCODE'=0
	.s inbpid=$o(^DHCINBP(0,"BarCode",parbarcode,""))  //父条码对应的记录
	.q:inbpid=""
	.&sql(update DHC_IncBatPack set INBP_Qty=INBP_Qty+:qty where INBP_ROWID =:inbpid)
	..i SQLCODE'=0 s err = "-3"
	b  /////bbb
	q err
}

}
