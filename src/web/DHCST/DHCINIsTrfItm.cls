Import sqluser

Class web.DHCST.DHCINIsTrfItm Extends (%RegisteredObject, %XML.Adaptor, StkTypeG) [ Not ProcedureBlock ]
{

Parameter AppName [ Final ] = "DHCSTTRANSFER";

/// Descript:   保存/更新库存转移明细信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-07-20
/// Table:DHC_InIsTrfItm
/// Input:主表id；
/// 明细id^批次id^数量^单位^请求明细id^备注，明细id^批次id^数量^单位^请求明细id^备注
/// Output:     
/// Return：0：成功，
/// ErrCode:ErrInfo
ClassMethod Save(InitId As %String, ListData As %String) As %Library.String
{
    n (InitId,ListData)
    q:InitId="" -5
    q:ListData="" 0
    s rowDelim=##class(web.DHCST.Common.UtilCommon).RowDataDelim()
    s Len=$l(ListData,rowDelim)
    s Count=0
    s Err=0
    s ErrDetail=""
    s LocId=$p(^DHCINIT(InitId),"^",5)
    s HospId=$p(^CTLOC(LocId),"^",22)
   
    tstart
    s $ZT="Error^DHCSTERROR"
    f i=1:1:Len  q:Err'=0  d
    .s Data=$p(ListData,rowDelim,i)
    .s Rowid=$p(Data,"^",1)
    .s Inclb=$p(Data,"^",2)
    .Q:+Inclb=0
    .b
    .s IncId=+Inclb
    .s notUseFlag=$P(^INCI(IncId,2),"^",9)
    .i notUseFlag="Y" s ErrDetail=ErrDetail_","_$p(^INCI(IncId,1),"^",2)
    .q:notUseFlag="Y"
    .s Qty=$p(Data,"^",3)
    .s UomId=$p(Data,"^",4)
    .s Sp=##class(web.DHCST.Common.PriceCommon).GetPriceElse(Inclb,+$h,UomId,HospId,"G","")
    .s TmpData=Inclb_"^"_Qty_"^"_UomId_"^"_Sp
    .s ErrId=..CheckTransferDetail(Rowid,TmpData)  //该验证不在验证价格,进售价审核时更新为最新
    .i ErrId'=0  d
    ..s Err=-7
    ..s ErrDetail=##class(web.DHCST.ErrorRecord).GetErrorInfo(ErrId)
    .q:Err'=0
    .s ReqItmId=$p(Data,"^",5)
    .s Remark=$p(Data,"^",6)
    .s IncDesc=$p(^INCI(IncId,1),"^",2)
    .s Sp=##class(web.DHCST.Common.PriceCommon).GetPriceElse(Inclb,+$h,UomId,HospId,"G","")
    .s Rp=##class(web.DHCST.Common.PriceCommon).GetClbRp(Inclb,UomId,HospId,"G",+$h,"")
    .s NewSp=##class(web.DHCST.Common.PriceCommon).BatSpUom(Inclb,UomId,HospId)
    .s SpAmt=Sp*Qty
    .s RpAmt=Rp*Qty
    .s NewSpAmt=NewSp*Qty
    .s SpAmt=##class(web.DHCST.Common.AppCommon).FormatSpAmt(SpAmt,HospId)
    .s NewSpAmt=##class(web.DHCST.Common.AppCommon).FormatSpAmt(NewSpAmt,HospId)
    .s RpAmt=##class(web.DHCST.Common.AppCommon).FormatRpAmt(RpAmt,HospId)
    .s Data1=Inclb_"^"_Qty_"^"_UomId_"^"_ReqItmId_"^"_Rp_"^"_RpAmt_"^"_Sp_"^"_SpAmt
    .s Data2=Rp_"^"_RpAmt_"^"_NewSp_"^"_NewSpAmt_"^"_Remark
    .s Detail=Data1_"^"_Data2
    .b ;1
    .s Ret=0
    .;处理占用库存
    .i Rowid'=""  d
    ..s Ret=##class(web.DHCST.DHCINIsTrf).HandleTransItmDirtyQty(Rowid,0)  ;减去原占用库存
    .i Ret'=0  d
    ..s ErrDetail=..Trans("移除药品")_IncDesc_..Trans("占用库存失败")
    ..s Err=-1  
    .q:Ret'=0
    .
    .;处理明细
    .s Ret=..Update(Rowid,InitId,Detail)
    .i +Ret<0  d
    ..s Err=-2
    ..s ErrDetail=..Trans("保存药品")_IncDesc_..Trans("明细失败"  )
    .b ;2
    .q:+Ret<0
    .;增加新占用库存
    .s Rowid=Ret
    .s Ret=##class(web.DHCST.DHCINIsTrf).HandleTransItmDirtyQty(Rowid,1)  ;增加新占用库存
    .i Ret'=0 d
    ..s Err=-3
    ..s ErrDetail=..Trans("增加药品")_IncDesc_..Trans("占用库存失败" )
    .q:Ret'=0
    .s Count=Count+1
    i Err'=0  trollback
    i (Err'=0)&(Err'=-7)  d
    .s ErrId=$$ErrorRecord^DHCSTERROR(##class(web.DHCST.DHCINIsTrf).%GetParameter("AppName"),IncDesc,ErrDetail)
    .
    i Count=0 s Err=-10
    q:Err'=0 Err_":"_ErrDetail
    tcommit
    q 0
}

/// 插入或更新库存转移单明细记录
/// Author:zhwh 
/// Date:2012-07-16
/// Argu:
///   initi - rowid
///   init - 主表rowid
///   data - 明细数据串("^"分隔)
/// Return:
///  <0 - failure
///  串 - 子表rowid
///    
ClassMethod Update(initi As %String, init As %String, data As %String) As %String
{
 s inclb=$P(data,"^",1)
 s qty=$P(data,"^",2)
 s uom  =$P(data,"^",3)
 s inrqi=$P(data,"^",4)
 s rp=$P(data,"^",5)
 s rpAmt=$P(data,"^",6)
 s sp=$P(data,"^",7)
 s spAmt=$P(data,"^",8)
 s pp=$P(data,"^",9)
 s ppAmt=$P(data,"^",10)
 s newSp=$P(data,"^",11)
 s newSpAmt=$P(data,"^",12)
 s remark=$P(data,"^",13)
 s State="10"  //保存状态
 
 q:init="" -101
 q:##class(web.DHCST.Common.AppCommon).Lock(##class(web.DHCST.DHCINIsTrf).%GetParameter("AppName")_init)<0 -1
 
 i initi="" d
 .;b ;12
 .s obj=##class(User.DHCInIsTrfItm).%New(init) //ERROR-UNDEFINED%%Construct+1-User.DHCInIsTrfItm.1 *%d(0)
 .;b ;13
 .d obj.INITIINITParRefSetObjectId(init)
 .;b ;11
 .;s obj.INITIINITParRef=##class(User.DHCInIsTrf).%OpenId(init)
 .;s ch=$o(^DHCINIT(init,"ITI",""),-1)+1
 .;s obj.INITIChildSub=ch
 e  d
 .s obj=##class(User.DHCInIsTrfItm).%OpenId(initi)
 .d obj.%Reload()
 .
 ;b ;1
 s obj.INITIINCLBDR=##class(User.INCItmLcBt).%OpenId(inclb,0)
 s obj.INITIQty=+qty
 s obj.INITICTUOMDR=##class(User.CTUOM).%OpenId(uom,0)
 s obj.INITIUCost=+sp
 s obj.DHCITIPurPrice=+pp
 s obj.DHCITIPPAmount=+ppAmt
 s obj.DHCITIRealPrice=+rp
 s obj.DHCITIRPAmount=+rpAmt
 s obj.DHCITISalePrice=+sp
 s obj.DHCITISPAmount=+spAmt
 s obj.DHCITINewSp=+newSp
 s obj.DHCITINewSpAmt=+newSpAmt
 s obj.INITIINRQIDR=##class(User.INReqItm).%OpenId(inrqi,0)
 s obj.DHCITIRemark=remark
 s obj.INITIType="T"
 s obj.DHCITIState=State
 ;b ;2   
 s sc=obj.%Save()
 d ##class(web.DHCST.Common.AppCommon).UnLock(##class(web.DHCST.DHCINIsTrf).%GetParameter("AppName")_init)
 ;b ;3
 i $$$ISERR(sc) q -2
 q obj.%Id()
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
 n ( initi)
 ;s ^zdm("Delete")=initi
 s init=+initi
 s ret=##class(web.DHCST.DHCINIsTrf).AllowDel(init)
 q:ret<0 ret
 q:##class(web.DHCST.Common.AppCommon).Lock(##class(web.DHCST.DHCINIsTrf).%GetParameter("AppName")_init)<0 -99
 ts
 s $ZT="Error^DHCSTERROR" 
 s ret=##class(web.DHCST.DHCINIsTrf).HandleTransItmDirtyQty(initi,0)  //占用数
 i ret<0 tro  d ##class(web.DHCST.DHCINIsTrf).uLock(init)  q -12
 &sql(delete from dhc_inistrfitm where %ID=:initi)
 i SQLCODE'=0 tro  d ##class(web.DHCST.DHCINIsTrf).uLock(init) q -11
 d ##class(web.DHCST.DHCINIsTrf).uLock(init)
 tc
 q 0
}

/// 检索并返回库存转移单明细记录数据
/// Author:zhwh
/// Date:2012-07-16
/// Argu:并返回
///   initi - 库存转移单明细记录rowid
/// Return：
///   0 -Success
///   <0 - failure
ClassMethod Select(initi As %String) As %String
{
 k PLIST
 s result=""
 
 &sql(select * into :PLIST() from DHC_INIsTrfItm where %ID=:initi )
 q:SQLCODE'=0 result
 s cnt=$o(PLIST(""),-1)
 f i=1:1:cnt d
 .i result=""  s result=$g(PLIST(i))
 .e  s result=result_"^"_$g(PLIST(i))
 .
 q result
}

/// 取库存转移单明细记录的数据串(json)
/// Author:zhwh
/// Date:2012-07-16
/// Argu: 
///     init- -库存转移单主表rowid
/// Return:
///    数据串(json格式)
///    w ##class(web.DHCST.DHCINIsTrfItm).jsDHCINIsTrfD(0,30,8213)
ClassMethod jsDHCINIsTrfD(Start As %String, Limit As %String, param As %String) As %String
{
 s init=$p(param,"^",1)
 s qstatus=$p(param,"^",2)
 s result=##class(%Library.ResultSet).%New("web.DHCST.DHCINIsTrfItm:DHCINIsTrfD")
 s sc=result.Execute(init,qstatus)
 i $$$ISERR(sc) q ""
 
 s colNum=result.GetColumnCount()
 s colNameStr=""
 f i=1:1:colNum d
 .i colNameStr="" s colNameStr=result.GetColumnName(i)
 .e  s colNameStr=colNameStr_"^"_result.GetColumnName(i)

 s count = 0
 s resultString = ""
 s end = Start+Limit
 s json = ##class(Code.JsonObj).%New()
 While(result.Next())
 { 
 s ret=""
  f i=1:1:colNum d
  .i ret="" s ret=result.%GetData(i)
  .e   s ret=ret_"^"_result.%GetData(i)
  
  s tmp=$tr(ret,$c(13,10))
  s count = count+1

  CONTINUE:count<(Start+1)
  CONTINUE:count>end            
    
  d json.InsertRowData(tmp)
 }
 d result.Close()
 s resultString = json.getJsonData(colNameStr,count)
 k json
 Q resultString
}

/// 取库存转移单明细记录的数据串(json)--直接write
/// Author:wangjiabin
/// Date:2013-07-02
/// Argu: init- -库存转移单主表rowid
/// Return: 数据串(json格式)
/// w ##class(web.DHCST.DHCINIsTrfItm).jsDHCINIsTrfDetail(1,2,"100000030^21")
ClassMethod jsDHCINIsTrfDetail(Start As %String, Limit As %String, initparmas As %String) As %String
{
 s init=$p(initparmas,"^",1)
 s qstatus=$p(initparmas,"^",2)
 s result=##class(%Library.ResultSet).%New("web.DHCST.DHCINIsTrfItm:DHCINIsTrfD")
 s sc=result.Execute(init,qstatus)
 i $$$ISERR(sc) q ""
 
 s colNum=result.GetColumnCount()
 s colNameStr=""
 f i=1:1:colNum d
 .i colNameStr="" s colNameStr=result.GetColumnName(i)
 .e  s colNameStr=colNameStr_"^"_result.GetColumnName(i)

 s count = 0
 s resultString = ""
 s end = Start+Limit
 s Start=Start+1
 w "{rows:["
 While(result.Next())
 { 
	s colValueStr=""
	f i=1:1:colNum d
	.i colValueStr="" s colValueStr=result.%GetData(i)
	.e   s colValueStr=colValueStr_"^"_result.%GetData(i)  
	s count = count+1  //计算总记录数
	CONTINUE:count<Start
	CONTINUE:count>end  
	i count=Start d
	.w ##class(web.DHCST.Common.UtilCommon).GetJsonStr(colValueStr,colNameStr)
	e  d
	.w ","_##class(web.DHCST.Common.UtilCommon).GetJsonStr(colValueStr,colNameStr)
 }
 w "],results:"_count_"}"
 d result.Close()
 q ""
}

/// 检索库存转移单的明细数据
/// Author:zhwh
/// Date:2012-07-16
/// Argu:
/// init -库存转移单主表rowid
/// LastUpdate:yunhaibao20151210,修改获取数据为循环global,处理个别老项目升级此界面很慢的问题
/// d ##class(%ResultSet).RunQuery("web.DHCST.DHCINIsTrfItm","DHCINIsTrfD",5,"",)
Query DHCINIsTrfD(init As %String, qstatus As %String, InitFrLocDescIO As %String = "", InitToLocDescIO As %String = "", InitUserIO As %String = "", HospDescIO As %String = "") As %Query(ROWSPEC = "initi:%String,inclb:%String,inci:%String,inciCode:%String,inciDesc:%String,spec:%String,manf:%String,manfName:%String,uom:%String,qty:%Float,inrqi:%String,rp:%Float,rpAmt:%Float,pp:%Float,ppAmt:%Float,sp:%Float,spAmt:%Float,newSp:%Float,newSpAmt:%Float,status:%String,remark:%String,formDesc:%String,gene:%String,stkbin:%String,inclbQty:%String,inclbDirtyQty:%String,inclbAvaQty:%String,reqLocStkQty:%String,BUomId:%String,ConFac:%String,reqQty:%Float,batexp:%String,TrUomDesc:%String,dirtyQty:%String,goodName:%String,proLocStkQty:%String,reqstkbin:%String,InitFrLocDescIO,InitToLocDescIO,InitUserIO,HospDescIO,InsuCode,InsuDesc") [ SqlProc ]
{
}

ClassMethod DHCINIsTrfDExecute(ByRef qHandle As %Binary, init As %String, qstatus As %String = "", InitFrLocDescIO As %String = "", InitToLocDescIO As %String = "", InitUserIO As %String = "", HospDescIO As %String = "") As %Status
{
	n (qHandle,init,qstatus,InitFrLocDescIO,InitToLocDescIO,InitUserIO,HospDescIO)
	//s ^YSJTMP("DHCINIsTrfD")=$LB(qHandle,init,qstatus,InitFrLocDescIO,InitToLocDescIO,InitUserIO,HospDescIO)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:init="" $$$OK
	s frLoc = $P(^DHCINIT(init), "^", 5)
	s hospId = $P(^CTLOC(frLoc), "^", 22)
	
	s:InitFrLocDescIO'="" InitFrLocDescIO=$p(^CTLOC(InitFrLocDescIO),"^",2)
	s:InitToLocDescIO'="" InitToLocDescIO=$p(^CTLOC(InitToLocDescIO),"^",2)
    s:InitUserIO'="" InitUserIO=$p(^SSU("SSUSR",InitUserIO),"^",2)
    s:HospDescIO'="" HospDescIO=$P(^CT("HOSP",HospDescIO),"^",2)
	
	s initchl=""
	f  s initchl=$o(^DHCINIT(init,"ITI",initchl)) q:initchl=""  d
	.q:+initchl=0
	.s initi=init_"||"_initchl
	.s inclb=$p(^DHCINIT(init,"ITI",initchl),"^",3)
	.s incib=$p(^INCI(+inclb,"IL",$p(inclb,"||",2),"LB",$p(inclb,"||",3)),"^",1)
	.s batNo=$p(^INCI(+incib,"IB",$p(incib,"||",2)),"^",1)
	.s expDate=$p(^INCI(+incib,"IB",$p(incib,"||",2)),"^",2)
	.s uom=$p(^DHCINIT(init,"ITI",initchl),"^",7)
	.s qty=$p(^DHCINIT(init,"ITI",initchl),"^",1)
	.s inrqi=$p(^DHCINIT(init,"ITI",initchl),"^",2)
	.s rp=$p(^DHCINIT(init,"ITI",initchl),"^",15)
	.s rpAmt=$p(^DHCINIT(init,"ITI",initchl),"^",16)
	.s pp=$p(^DHCINIT(init,"ITI",initchl),"^",13)
	.s ppAmt=$p(^DHCINIT(init,"ITI",initchl),"^",14)
	.s sp=$p(^DHCINIT(init,"ITI",initchl),"^",17)
	.s spAmt=$p(^DHCINIT(init,"ITI",initchl),"^",18)
	.s newSp=$p(^DHCINIT(init,"ITI",initchl),"^",21)
	.s newSpAmt=$p(^DHCINIT(init,"ITI",initchl),"^",22)
	.s substatus=$p(^DHCINIT(init,"ITI",initchl),"^",23)
	.s remark=$p(^DHCINIT(init,"ITI",initchl),"^",24)
	.s:uom'="" uomDesc=$p(^CT("UOM",uom),"^",2)
	.q:(substatus'=31)&(qstatus=32)
	.q:(substatus'=21)&(qstatus=21)
	.i expDate'="" d	;防止润乾报表在sql中将日期转换为Y-m-d格式造成的错误
	..s expDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(expDate,"ST")
	.s batexp=batNo_"~"_expDate 
	.s inci=+inclb
	.s inciCode=$P(^INCI(inci,1),"^",1)
	.s inciDesc=$P(^INCI(inci,1),"^",2)
	.s spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",inci)
	.s manfInfo=##class(web.DHCST.Common.DrugStkCommon).GetManfInfoByInclb(inclb)
	.s manf=$P(manfInfo,"^",1)
	.s manfName=$P(manfInfo,"^",2)
	.;zdm,2012-07-19,增加下述信息
	.s formInfo=##class(web.DHCST.Common.DrugInfoCommon).GetForm(inci)
	.s formDesc=$p(formInfo,"^",2)
	.s geneInfo=##class(web.DHCST.Common.DrugInfoCommon).GetGene(inci)
	.s geneDesc=$p(geneInfo,"^",2)
	.s goodName=##class(web.DHCST.Common.DrugInfoCommon).GetGoodName(inci)	;商品名
	.s proLocId=$p(^DHCINIT(+initi),"^",5)
	.s reqLocId=$p(^DHCINIT(+initi),"^",6)
	.s initDate=$p(^DHCINIT(+initi),"^",2)
	.s stkbinstr=""
	.s incilsub=""
	.//取新科室货位表过滤货位 add wyx 2013-11-21 //改为取新的科室货位表DHCIncItmLocBin（可多货位）
	.s stkbinstr=""
	.s incilsub=$o(^INCI("IL_LOC",proLocId,inci,""))
	.i incilsub'="" d 
	..s incil=inci_"||"_incilsub
	..s stkbinret=##class(web.DHCST.Common.DrugInfoCommon).GetInciBinStr(incil,",","","") 
	..s stkbinstr=$p(stkbinret,":",2)  
	.s stkbin=stkbinstr  //供给方货位
	.s incilsub=$o(^INCI("IL_LOC",reqLocId,inci,""))
	.s reqstkbinstr=""
	.i incilsub'="" d 
	..s incil=inci_"||"_incilsub
	..s stkbinret=##class(web.DHCST.Common.DrugInfoCommon).GetInciBinStr(incil,",","","") 
	..s reqstkbinstr=$p(stkbinret,":",2)  
	.s reqstkbin=reqstkbinstr  //请求方货位
	.s inclbQty=##class(web.DHCST.Common.DrugStkCommon).QtyINCLBUom(inclb,uom,+$h)  ;当前库存
	.s inclbDirtyQty=##class(web.DHCST.Common.DrugStkCommon).CurInclbResQty(inclb,uom)  ;当前占用库存
	.s inclbAvaQty=inclbQty-inclbDirtyQty   ;当前可用库存
	.s dirtyQty=0
	.s status=$p(^DHCINIT(init),"^",14)
	.i (status'=21)!(status'=31) s dirtyQty=qty   ;本次占用数量
	.s reqLocStkQty=##class(web.DHCST.Common.DrugStkCommon).LocDayQtyUom(inci, reqLocId, uom, +$h) //请求方库存
	.s proLocStkQty=##class(web.DHCST.Common.DrugStkCommon).LocDayQtyUom(inci, proLocId, uom, +$h) //供应方库存
	.s BUomId=$p(^INCI(inci,1),"^",10)
	.s PurUomId=$p(^INCI(inci,3),"^",6)
	.s proLocStkQty=$fn(proLocStkQty,"",2)
	.s ConFac=##class(web.DHCST.Common.UtilCommon).UOMFac(PurUomId,BUomId)
	.s reqQty=""
	.i inrqi'=""  d
	..s reqQty=$p(^INRQ(+inrqi,"RQI",$p(inrqi,"||",2)),"^",3)
	..s reqUom=$p(^INRQ(+inrqi,"RQI",$p(inrqi,"||",2)),"^",5)
	..s fac1=##class(web.DHCST.Common.UtilCommon).UOMFac(reqUom,BUomId)
	..s fac2=##class(web.DHCST.Common.UtilCommon).UOMFac(uom,BUomId)
	..s reqQty=reqQty*fac1/fac2
	.s InsuCode = ##class(PHA.COM.Drug).GetInsuCode(inci, hospId)
	.s InsuDesc = ##class(PHA.COM.Drug).GetInsuDesc(inci, hospId)
	
	.d OutPurRow
	Quit $$$OK
OutPurRow
 
 s Data=$lb(initi,inclb,inci,inciCode,inciDesc,spec,manf,manfName,uom,$fn(qty,"N"),inrqi,$fn(rp,"N"),$fn(rpAmt,"N"),$fn(pp,"N"),$fn(ppAmt,"N"),$fn(sp,"N"),$fn(spAmt,"N"),$fn(newSp,"N"),$fn(newSpAmt,"N"),status,remark,formDesc,geneDesc,stkbin,$fn(inclbQty,"N"),$fn(inclbDirtyQty,"N"),$fn(inclbAvaQty,"N"),$fn(reqLocStkQty,"N"),BUomId,ConFac,reqQty,batexp,uomDesc,dirtyQty,goodName,$fn(proLocStkQty,"N"),reqstkbin,InitFrLocDescIO,InitToLocDescIO,InitUserIO,HospDescIO,InsuCode, InsuDesc)
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

ClassMethod DHCINIsTrfDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DHCINIsTrfDExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod DHCINIsTrfDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DHCINIsTrfDExecute ]
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

/// Creator:zhangdongmei
/// CreatDate:2012-07-24
/// Description:构造请求单出库明细(依据请求单出库调用)
/// Table:in_reqitm,
/// Input:请求主表id
/// Return:w ##class(web.DHCST.DHCINIsTrfItm).GetDetailForTransByReq("0","9999","req","Desc","41")
ClassMethod GetDetailForTransByReq(Start As %Integer, Limit As %Integer, Sort As %String, Dir As %String, rrid As %String) As %Library.String
{
    n (Start,Limit,Sort,Dir,rrid)
    s ^YSJTMP("GetDetailForTransByReq") = $LB(Start,Limit,Sort,Dir,rrid)
    q:Limit=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    q:rrid="" ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s resultString = ""
    s json = ##class(Code.JsonObj).%New()
    s reqLocId =$P(^INRQ(rrid),"^",6)  
    s proLocId =$P(^INRQ(rrid),"^",5)  
    S HospID=$P(^CTLOC(reqLocId),"^",22)
    s Params=""_"^"_proLocId_"^"_""_"^"_HospID
    s ExpLimitFlag=##class(web.DHCST.Common.AppCommon).GetAppPropValue(..%GetParameter("AppName"),"ExpLimitFlag",Params)   //过期药品是否限制出库
    s count=0
    s endpage=Start+Limit  //结束行
    s stpage=Start+1 //开始行
    s newpid=..NewPid() //modify wyx 2014-01-21 更改组织数据的方式
    Set $ZT="ERRORGetDetailForTransByReq"
    ;
    s rchsub=0
    f  s rchsub=$o(^INRQ(rrid,"RQI",rchsub)) q:rchsub=""  d
    .s inrqi=rrid_"||"_rchsub
    .s rstr=^INRQ(rrid,"RQI",rchsub)
    .s rem=$g(^INRQ(rrid,"RQI",rchsub,"REM",0))
    .s incidr=$p(rstr,"^",4) 
    .q:incidr="" 
    .s refuseflag=$p(^INRQ(rrid,"RQI",rchsub),"^",6)
    .//q:refuseflag="Y" //过滤作废的明细
    .s incicode=$p(^INCI(incidr,1),"^",1)
    .s incidesc=$p(^INCI(incidr,1),"^",2)
    .s rqty=+$p(rstr,"^",3)
    .s uomdr=+$p(rstr,"^",5)
    .i uomdr'=0 s uomdesc=$p(^CT("UOM",uomdr),"^",2)
    .s rdate=+$p(rstr,"^",1)
    .S reqstkqty = ##class(web.DHCST.Common.DrugStkCommon).LocDayQtyUom(incidr,reqLocId,uomdr,+$h)  ;请求方库存
    .i ExpLimitFlag'="Y" s prostkqty=##class(web.DHCST.Common.DrugStkCommon).LocDayQtyUom(incidr,proLocId,uomdr,+$h) ;供给方库存
    .e  s prostkqty=##class(web.DHCST.Common.DrugStkCommon).LocNotOutOfDateQtyUom(incidr,proLocId,uomdr,+$h) ;当过期药品限制出库时过滤掉过期库存
    .s spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",incidr)
    .s formInfo=##class(web.DHCST.Common.DrugInfoCommon).GetForm(incidr)
    .s formDesc=$p(formInfo,"^",2)
    .s geneInfo=##class(web.DHCST.Common.DrugInfoCommon).GetGene(incidr)
    .s geneDesc=$p(geneInfo,"^",2)
    .s inciCh=$o(^INCI("IL_LOC",proLocId,incidr,""))
	.s stkbinRet=##class(web.DHCST.Common.DrugInfoCommon).GetInciBinStr(incidr_"||"_inciCh,",","","") 
	.s stkbin=$p(stkbinRet,":",2)  
    .s transqty=##class(web.DHCST.DHCINIsTrf).TransQty(inrqi)   ;已转移数量
    .s buomdr=$p(^INCI(incidr,1),"^",10)
    .s puruomdr=$p(^INCI(incidr,3),"^",6)
    .s confac=##class(web.DHCST.Common.UtilCommon).UOMFac(+puruomdr,+buomdr)
    .s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(uomdr,buomdr)
    .s trqty=rqty*fac-transqty    ;未转移数量(基本单位)
    .//q:trqty'>0     ;全部转移的明细过滤掉
    .s pid=..GetInclbForTransfer(proLocId,incidr,trqty)
    .//增加对没有可用库存的数据的显示，避免与空请求单等导致明细界面为空的清空的混淆 wyx 2014-02-27
    .i pid="" d
    ..s pid=##Class(web.DHCSTCOMMO).NewPidOEInclb()
    ..s retdata=..GetAvaQtyIncLb(pid,proLocId,incidr)
    .s inclb=""
    .f  s inclb=$o(^TMPGETINCLB(pid,inclb)) q:inclb=""  d
    ..s incinfo=^TMPGETINCLB(pid,inclb)    ;批次信息
    ..s batno=$p(incinfo,"^",1)
    ..s inclbqty=$p(incinfo,"^",2)
    ..s expdate=$p(incinfo,"^",3)
    ..s dirtyqty=$p(incinfo,"^",5)
    ..s avaqty=$p(incinfo,"^",6)
    ..s qty=$p(incinfo,"^",7)     ;批次转移数量
    ..s inclbid=$p(incinfo,"^",4)
    ..//批次数量能够整除才能转换为入库单位，否则使用基本单位2020-02-18 yangsj
    ..i qty#fac'=0  d
    ...s uomdr=buomdr
    ...s uomdesc=$p(^CT("UOM",uomdr),"^",2)
    ...s rqty=rqty*fac
    ...s prostkqty=prostkqty*fac
    ..e  d
    ...s qty=qty/fac
    ...s inclbqty=inclbqty/fac
    ...s dirtyqty=dirtyqty/fac
    ...s avaqty=avaqty/fac
    ...s transqty=transqty/fac   ;已转移数量
    ..s manfInfo=##class(web.DHCST.Common.DrugStkCommon).GetManfInfoByInclb(inclbid)
    ..s manf=$P(manfInfo,"^",1)
    ..s manfName=$P(manfInfo,"^",2)
    ..s incib =$p(^INCI(+inclbid,"IL",$p(inclbid,"||",2),"LB",$p(inclbid,"||",3)),"^",1)
    ..s batexp = batno_"~"_expdate
    ..s rp = ##class(web.DHCST.Common.PriceCommon).GetClbRp(inclbid,uomdr,HospID,"G",+$h,"")
    ..s sp= ##class(web.DHCST.Common.PriceCommon).GetPriceElse(inclbid,+$h,uomdr,HospID,"G","")
    ..s newsp=##class(web.DHCST.Common.PriceCommon).BatSpUom(inclbid,uomdr,HospID)
    ..s spamt=sp*qty
    ..s rpamt=rp*qty
    ..s initi=""
    ..//s transqty=transqty/fac   ;已转移数量
    ..i refuseflag="Y" s refuseflag=1
    ..e  s refuseflag=0
    ..s colorlevel=""
    ..i refuseflag'="1" d
    ...i rqty>prostkqty s colorlevel="-1" //库存不足
    ...i prostkqty<=0 s colorlevel="0" 
    ..s data1=initi_"^"_inrqi_"^"_incidr_"^"_incicode_"^"_incidesc_"^"_inclbid_"^"_batexp
    ..s data2=manfName_"^"_inclbqty_"^"_qty_"^"_uomdr_"^"_$g(uomdesc)_"^"_sp_"^"_rqty
    ..s data3=reqstkqty_"^"_stkbin_"^"_rp_"^"_spec_"^"_geneDesc_"^"_formDesc_"^"_spamt
    ..s data4=buomdr_"^"_confac_"^"_dirtyqty_"^"_avaqty_"^"_transqty_"^"_rpamt_"^"_newsp
    ..s data5=refuseflag_"^"_colorlevel_"^"_prostkqty
    ..s data=data1_"^"_data2_"^"_data3_"^"_data4_"^"_data5
    ..s count=count+1
    ..//add wyx 2013-01-21
    ..s index="Sort^"_initi_"^"_count  //排序
    ..i Sort="req" s index="Sort^"_initi_"^"_count
    ..s ^TMP("web","DHCST","DHCINIsTrfItm","GetDetailForTransByReq",newpid,index)=data
    q:count=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    q:Limit=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s maxrow=count
    i endpage>maxrow s endpage=maxrow
    i Dir="DESC"  d
    .d OutRowDesc(newpid,stpage,endpage,maxrow,Dir)
    e  d
    .d OutRowAsc(newpid,stpage,endpage,maxrow)
    
    
    i $g(pid)'="" k ^TMPGETINCLB(pid)
    
    k ^TMP("web","DHCST","DHCINIsTrfItm","GetDetailForTransByReq",newpid)

    q ""
   
    
OutRowAsc(newpid,stpage,endpage,maxrow)
	n (newpid,stpage,endpage,maxrow)
	s subflag=""
	s count=0
	f  s subflag=$o(^TMP("web","DHCST","DHCINIsTrfItm","GetDetailForTransByReq",newpid,subflag))  q:subflag=""  d
       .s RowData=^TMP("web","DHCST","DHCINIsTrfItm","GetDetailForTransByReq",newpid,subflag)
	.s count=count+1
	.d ..OutRowDetail(RowData,stpage,endpage,maxrow,count)
	.
	
OutRowDesc(newpid,stpage,endpage,maxrow,Dir)
	n (newpid,stpage,endpage,maxrow,Dir)
	q:Dir'="DESC"
	s count=0
	s subflag=""
	f  s subflag=$o(^TMP("web","DHCST","DHCINIsTrfItm","GetDetailForTransByReq",newpid,subflag),-1)  q:subflag=""  d
       .s RowData=^TMP("web","DHCST","DHCINIsTrfItm","GetDetailForTransByReq",newpid,subflag)
       .s count=count+1
	.d ..OutRowDetail(RowData,stpage,endpage,maxrow,count)
	.   

ERRORGetDetailForTransByReq
    //遇报错,则先kill TMP
    Set Method= "##class(web.DHCST.DHCINIsTrfItm).GetDetailForTransByReq"
	Set ErrorMsg=Method_"("_Start_","_Limit_","_rrid_")"_","_$ZE
	k ^TMP("web","DHCST","DHCINIsTrfItm","GetDetailForTransByReq",newpid)
    q $ze
}

ClassMethod OutRowDetail(RowData, stpage, endpage, maxrow, count)
{
	n (RowData,stpage,endpage,maxrow,count)
	s initi=$p(RowData,"^",1)
	s inrqi=$p(RowData,"^",2)
	s incidr=$p(RowData,"^",3)
	s incicode=$p(RowData,"^",4)
	s incidesc=$p(RowData,"^",5)
	s inclb=$p(RowData,"^",6)
	s batexp=$p(RowData,"^",7)
	s manfName=$p(RowData,"^",8)
	s inclbqty=$p(RowData,"^",9)
	s qty=$fn($p(RowData,"^",10),"n")
	s uomdr=$p(RowData,"^",11)
	s uomdesc=$p(RowData,"^",12)
	s sp=$fn($p(RowData,"^",13),"n")
	s rqty=$fn($p(RowData,"^",14),"n")
	s reqstkqty=$fn($p(RowData,"^",15),"n")
	s stkbin=$p(RowData,"^",16)
	s rp=$fn($p(RowData,"^",17),"n")
	s spec=$p(RowData,"^",18)
	s geneDesc=$p(RowData,"^",19)
	s formDesc=$p(RowData,"^",20)
	s spamt=$p(RowData,"^",21)
	s buomdr=$p(RowData,"^",22)
	s confac=$p(RowData,"^",23)
	s dirtyqty=$fn($p(RowData,"^",24),"n")
	s avaqty=$fn($p(RowData,"^",25),"n")
	s transqty=$fn($p(RowData,"^",26),"n")
	s rpamt=$fn($p(RowData,"^",27),"n")
	s newsp=$fn($p(RowData,"^",28),"n")
	s cancel=$p(RowData,"^",29)
	s colorlevel=$p(RowData,"^",30)
	s prostkqty=$fn($p(RowData,"^",31),"n")
	q:count<stpage
	q:count>endpage
	s cancel=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("cancel",cancel)
	s initi=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("initi",initi)
	s inrqi=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("inrqi",inrqi)
	s incidr=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("incidr",incidr)
	s incicode=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("incicode",incicode)
	s incidesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("incidesc",incidesc)
	s inclb=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("inclb",inclb)
	s batexp=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("batexp",batexp)
	s manfName=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("manfName",manfName)
	s inclbqty=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("inclbqty",inclbqty)
	s qty=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("qty",qty)
	s uomdr=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("uomdr",uomdr)
	s uomdesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("uomdesc",uomdesc)
	s sp=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("sp",sp)
	s rqty=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("rqty",rqty)
	s reqstkqty=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("reqstkqty",reqstkqty)
	s stkbin=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("stkbin",stkbin)
	s rp=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("rp",rp)
	s spec=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("spec",spec)
	s geneDesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("geneDesc",geneDesc)
	s formDesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("formDesc",formDesc)
	s spamt=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("spamt",spamt)
	s buomdr=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("buomdr",buomdr)
	s confac=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("confac",confac)
	s dirtyqty=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("dirtyqty",dirtyqty)
	s avaqty=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("avaqty",avaqty)
	s transqty=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("transqty",transqty)
	s rpamt=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("rpamt",rpamt)
	s prostkqty=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("prostkqty",prostkqty)
	s colorlevel=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("colorlevel",colorlevel)
	s newsp=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("newsp",newsp)
	s tmpstr=cancel_initi_inrqi_incidr_incicode_incidesc_inclb_batexp_manfName_inclbqty_qty_uomdr_uomdesc_sp_rqty_reqstkqty_stkbin_rp_spec_geneDesc_formDesc_spamt_buomdr_confac_dirtyqty_avaqty_transqty_rpamt_colorlevel_prostkqty_newsp
	s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
	s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
	s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	i count=stpage w startString
	i count<endpage w firstrow
	i count=endpage w lastrow
}

/// Creator:zhangdongmei
/// CreatDate:2012-07-24
/// Description:按效期优先的规则匹配本次出库批次
/// Table:inc_itmlcbt
/// Input:科室id,库存项id,数量
/// Return:
/// Modify:	2015-12-02,添加ExpLimitFlag,为Y时不分配过期药品,yunhaibao
/// 		2019-08-29,修改排序同##class(web.DHCST01).GetInclbQty,yunhaibao
/// w ##class(web.DHCST.DHCINIsTrfItm).GetInclbForTransfer(257,250,20)
ClassMethod GetInclbForTransfer(LocId As %String, IncId As %String, Qty As %String) As %Library.String
{
    n (LocId,IncId,Qty)
    k GetInclbForTransferDATA
    q:'$d(^INCI("IL_LOC",LocId,IncId)) ""
    s SeekBatMethod=0,ExpLimitFlag=""
    s UserId=""
    s GroupId=""
    s HospId=$p($g(^CTLOC(LocId)),"^",22)
    s Params=GroupId_"^"_LocId_"^"_UserId_"^"_HospId
    s SeekBatMethod=##class(web.DHCST.Common.AppCommon).GetAppPropValue(..%GetParameter("AppName"),"SeekBatMethod",Params) //参数配置确定按效期还是先进先出
    s ExpLimitFlag=##class(web.DHCST.Common.AppCommon).GetAppPropValue(..%GetParameter("AppName"),"ExpLimitFlag",Params)   //过期药品是否限制出库
    s Pid=##Class(web.DHCSTCOMMO).NewPidOEInclb()
    s NewQty=Qty
	s Inclb=0
	f  s Inclb=$o(^DHCINCLBi("ACISTKBT","Y",LocId,IncId,Inclb)) q:Inclb=""  d
	.s IL=$p(Inclb,"||",2),LB=$p(Inclb,"||",3)
    .q:'$d(^INCI(IncId,"IL",IL,"LB",LB))
    .s Incib=$P(^INCI(IncId,"IL",IL,"LB",LB),"^",1)
    .s Chl=$p(Incib,"||",2)
    .s ExpDays=0      ;失效天数
    .s ExpDate=+$p(^INCI(IncId,"IB",Chl),"^",2)
    .q:(ExpLimitFlag="Y")&&(ExpDate'=0)&&(ExpDate<=+$h)
    .s IncQty=##CLASS(web.DHCST.Common.DrugStkCommon).CurQtyINCLB(Inclb)
    .s ResQty=##class(web.DHCST.Common.DrugStkCommon).CurInclbResQty(Inclb,"")
    .s AvaQty= ##class(web.DHCST.Common.DrugStkCommon).CurInclbAvaQty(Inclb,"")
    .q:AvaQty'>0 
    .s BatNo=$p(^INCI(IncId,"IB",Chl),"^",1)
    .s ExpDateHtml=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(ExpDate,"ST")  ; 排序用,无需转换
    .s Data=BatNo_"^"_IncQty_"^"_ExpDateHtml_"^"_Inclb_"^"_ResQty_"^"_AvaQty
	.s (DateAdd,TimeAdd,ManfID)="0"
	.s dhcincib=$o(^DHCINCIB(0,"INCIB",Incib,""))
	.i dhcincib'="" d
	..s DHCINCIB=$g(^DHCINCIB(dhcincib))
	..s DateAdd=+$p(DHCINCIB,"^",10)
	..s TimeAdd=+$p(DHCINCIB,"^",11)
	.i SeekBatMethod=0 d
	..s index1=+ExpDate	//有效期优先
	..s index2=DateAdd
	..s index3=TimeAdd
	.e  d
	..s index1=+DateAdd	//先进先出
	..s index2=TimeAdd
	..s index3=ExpDate  
	.s inclbIndex=+$replace(Inclb,"||","")
	.s GetInclbForTransferDATA(Pid,index1,index2,index3,inclbIndex)=Data
    q:'$d(GetInclbForTransferDATA) ""
    s inclbCnt=0
    s index1=""
    f  s index1=$o(GetInclbForTransferDATA(Pid,index1)) q:(index1="")!(NewQty=0)  d
   	.s index2=""
    .f  s index2=$o(GetInclbForTransferDATA(Pid,index1,index2)) q:(index2="")!(NewQty=0)  d
    ..s index3=""
    ..f  s index3=$o(GetInclbForTransferDATA(Pid,index1,index2,index3)) q:(index3="")!(NewQty=0)  d
    ...s inclbIndex=""
    ...f  s inclbIndex=$o(GetInclbForTransferDATA(Pid,index1,index2,index3,inclbIndex)) q:(inclbIndex="")!(NewQty=0)  d
	....s inclbCnt=inclbCnt+1
	....s Data=GetInclbForTransferDATA(Pid,index1,index2,index3,inclbIndex)
	....s ^TMPGETINCLB(Pid,inclbCnt)=Data
    ....s AvaQty=$p(Data,"^",6)
    ....q:AvaQty<=0  
    ....i AvaQty'<NewQty  d
    .....s $p(^TMPGETINCLB(Pid,inclbCnt),"^",7)=NewQty    ;批次转移数量
    .....s NewQty=0  
    ....e  d
    .....s $p(^TMPGETINCLB(Pid,inclbCnt),"^",7)=AvaQty    ;批次转移数量                                       
    .....s NewQty=NewQty-AvaQty
    k GetInclbForTransferDATA
    q Pid
}

/// Descript:验证库存转移明细数据是否正确
/// Creater:ZhangDongmei
/// CreateDate: 2012-10-19
/// Table:DHC_InIsTrfItm
/// Input:明细id,批次id^数量^单位(供保存验证调用)
/// Output:     
/// Return：数据验证通过:0
/// 数据验证不通过:DHC_StkSysErrorRecord rowid
ClassMethod CheckTransferDetail(Initi As %String, ListData As %String = "") As %Library.String
{
    n (Initi,ListData)
    
    q:(Initi="")&(ListData="") 0
    s DirtyQty=0,OldUomId=""
    ;原保存数据
    i Initi'=""  d
    .s Init=+Initi
    .s Chl=$p(Initi,"||",2)
    .s Inclb=$p(^DHCINIT(Init,"ITI",Chl),"^",3)
    .s Qty=$p(^DHCINIT(Init,"ITI",Chl),"^",1)
    .s OldUomId=$p(^DHCINIT(Init,"ITI",Chl),"^",7)
    .s Status=$p(^DHCINIT(Init,"ITI",Chl),"^",23)
    .s Sp=$p(^DHCINIT(Init,"ITI",Chl),"^",17)
    .i (Status'=21)&(Status'=31)  d    ;本张单据的占用数量
    ..s DirtyQty=Qty
    .
    ;新数据
    i ListData'=""  d
    .s Inclb=$p(ListData,"^",1)
    .s Qty=$p(ListData,"^",2)
    .s UomId=$p(ListData,"^",3)
    .s Sp=$p(ListData,"^",4)
    s AppCode=##class(web.DHCST.DHCINIsTrf).%GetParameter("AppName")
    s KeyValue=Initi
    s Inci=+Inclb
    s:Inci'="" KeyValue=$p(^INCI(Inci,1),"^",2)
    s ret=0
    i +Inclb'>0  d
    .s ErrInfo=..Trans("库存转移批次为空")
    .s ret=$$ErrorRecord^DHCSTERROR(AppCode,KeyValue,ErrInfo)
    q:ret'=0 ret    ;批次验证不通过
    i +Qty'>0  d
    .s ErrInfo=..Trans("库存转移数量小于等于0")
    .s ret=$$ErrorRecord^DHCSTERROR(AppCode,KeyValue,ErrInfo)
    q:ret'=0 ret    ;数量验证不通过
    i ListData = "" s UomId=OldUomId
    i UomId = ""  d
    .s ErrInfo=..Trans("库存转移单位为空")
    .s ret=$$ErrorRecord^DHCSTERROR(AppCode,KeyValue,ErrInfo)
    q:ret'=0 ret    ;单位验证不通过
    s BUomId=$p(^INCI(Inci,1),"^",10)
    i +BUomId'>0  d
    .s ErrInfo=..Trans("转移项目基本单位为空")
    .s ret=$$ErrorRecord^DHCSTERROR(AppCode,KeyValue,ErrInfo)
    q:ret'=0 ret    ;基本单位验证不通过
    
    s Fac=##class(web.DHCST.Common.UtilCommon).UOMFac(UomId,BUomId)
    i +Fac=0  d
    .s ErrInfo=..Trans("转移项目出库单位和基本单位不存在转换关系")
    .s ret=$$ErrorRecord^DHCSTERROR(AppCode,KeyValue,ErrInfo)
    q:ret'=0 ret    ;单位转换验证不通过
    s AvaQty=##class(web.DHCST.Common.DrugStkCommon).CurInclbAvaQty(Inclb,UomId)
    i OldUomId'="" d
    .s OldFac=##class(web.DHCST.Common.UtilCommon).UOMFac(OldUomId,BUomId)
    .s DirtyQty=DirtyQty*OldFac/Fac
    s LeftQty=AvaQty+DirtyQty-Qty
    i LeftQty<0  d
    .s ErrInfo=..Trans("可用库存不足")
    .s ret=$$ErrorRecord^DHCSTERROR(AppCode,KeyValue,ErrInfo)
    q:ret'=0 ret    ;库存验证不通过
    q 0    ;验证通过
}

ClassMethod NewPid() As %String
{
  q $I(^DHCSTPID("TransInclb"))
}

ClassMethod GetAvaQtyIncLb(pid, proLocId, incidr)
{
    s inclbout=$o(^TMPGETINCLB(pid,"")) 
    i inclbout="" d
    .//没有可用库存
    .s IL=$o(^INCI("IL_LOC",proLocId,incidr,""),-1)
    .s LB=$o(^INCI(incidr,"IL",IL,"LB",""),-1)
    .q:LB=""
    .s Inclb=incidr_"||"_IL_"||"_LB
    .s Incib=""
    .q:'$d(^INCI(incidr,"IL",IL,"LB",LB))
    .s Incib=$P(^INCI(incidr,"IL",IL,"LB",LB),"^",1)
    .s Chl=$p(Incib,"||",2)
    .s ExpDays=0      ;失效天数
    .s ExpDate=+$p(^INCI(incidr,"IB",Chl),"^",2)
    .i ExpDate=0  d
    ..s ExpDate=+$h+500
    .i ExpDate=+$h  s ExpDays=1
    .e  s ExpDays=ExpDate-(+$h)
    .s IncQty=##CLASS(web.DHCST.Common.DrugStkCommon).CurQtyINCLB(Inclb)
    .s ResQty=##class(web.DHCST.Common.DrugStkCommon).CurInclbResQty(Inclb,"")
    .s AvaQty= ##class(web.DHCST.Common.DrugStkCommon).CurInclbAvaQty(Inclb,"")
    .s BatNo=$p(^INCI(incidr,"IB",Chl),"^",1)
    .s ExpDate=$p(^INCI(incidr,"IB",Chl),"^",2)
    .s:ExpDate'="" ExpDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(ExpDate,"ST")
    .s Data=BatNo_"^"_IncQty_"^"_ExpDate_"^"_Inclb_"^"_ResQty_"^"_AvaQty
    .s ^TMPGETINCLB(pid,$replace(Inclb,"||",""))=Data
    q 0
}

/// Author : MYQ
/// CreateDate : 20150309
/// Description : 查询申领单明细
/// Input : StartDate-开始日期,EndDate-结束日期,FrLoc-供给科室,ToLoc-请求科室,Inci-库存项ID
/// others-仅显示完全未转移药品^
///  d ##class(%ResultSet).RunQuery("web.DHCST.DHCINIsTrfItm","QueryINReqDetail","2018-04-04","2018-05-04","320","","","0^3")
Query QueryINReqDetail(StartDate As %String = "", EndDate As %String = "", FrLoc As %String = "", ToLoc As %String = "", Inci As %String = "", Others As %String = "") As websys.Query(ROWSPEC = "inrqi:%String,reqloc:%String,reqlocdesc:%String,recloc:%String,reclocdesc:%String,requser:%String,username:%String,inrqdate:%String,reqno:%String,incicode:%String,incidesc:%String,reqiqty:%Float,reqiuomdesc:%String,transqty:%Float,sp:%Float,manf:%String,nottransqty:%Float") [ SqlProc ]
{
}

ClassMethod QueryINReqDetailExecute(ByRef qHandle As %Binary, StartDate As %String = "", EndDate As %String = "", FrLoc As %String = "", ToLoc As %String = "", Inci As %String = "", Others As %String = "") As %Status
{
 n (qHandle,StartDate,EndDate,FrLoc,ToLoc,Inci,Others)
 s ^tmpdhy("QueryINReqDetailExecute")=StartDate_","_EndDate_","_FrLoc_","_ToLoc_","_Inci_","_Others
 s repid=$I(^CacheTemp)
 s ind=1
 s qHandle=$lb(0,repid,0)
    
 q:StartDate="" $$$OK
 q:EndDate="" $$$OK
 q:FrLoc="" $$$OK
 s hospId=$p($g(^CTLOC(FrLoc)),"^",22)
 s untranser=$p(Others,"^",1)       ;仅显示完全未转移标志
 s stkgrpid=$p(Others,"^",2)
 i StartDate'="" s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
 i EndDate'="" s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
 f date=StartDate:1:EndDate d
 .s inrq=""
 .f  s inrq=$o(^INRQ(0,"Date",date,inrq)) q:inrq=""  d
 ..q:'$d(^INRQ(inrq))
 ..s compflag=$p(^INRQ(inrq),"^",8) ;完成标志
 ..q:compflag'="Y" ;过滤未完成的申领单
 ..s dhcinreq=$o(^DHCINRQ(0,"INRQ",inrq,""),-1)
 ..i dhcinreq'="" s dhcinreqtype=$p($g(^DHCINRQ(dhcinreq)),"^",1)
 ..e  s dhcinreqtype=""
 ..q:(dhcinreqtype'="O")&&(dhcinreqtype'="C")&&(dhcinreqtype'="1")&&(dhcinreqtype'="2")&&(dhcinreqtype'="3")
 ..s reqloc=$p(^INRQ(inrq),"^",5) ;供给科室
 ..q:(FrLoc'="")&(FrLoc'=reqloc)
 ..s reqlocdesc=$p(^CTLOC(reqloc),"^",2)
 ..s:reqlocdesc["-" reqlocdesc=$p(reqlocdesc,"-",2)
 ..s recloc=$p(^INRQ(inrq),"^",6) ;申领科室
 ..q:(ToLoc'="")&(ToLoc'=recloc)
 ..s reclocdesc=$p(^CTLOC(recloc),"^",2)
 ..s:reclocdesc["-" reclocdesc=$p(reclocdesc,"-",2)
 ..s reqno=$p(^INRQ(inrq),"^",1) ;申领单号
 ..s requser=$p(^INRQ(inrq),"^",4) ;申请人
 ..s username=$p(^SSU("SSUSR",requser),"^",2)
 ..s inrqisub="" 
 ..f  s inrqisub=$o(^INRQ(inrq,"RQI",inrqisub)) q:inrqisub=""  d
 ...s inrqi=inrq_"||"_inrqisub
 ...s inrqidata=$g(^INRQ(inrq,"RQI",inrqisub))
 ...s inrqiinci=$p(inrqidata,"^",4) ;申领药品的库存项ID
 ...q:(Inci'="")&(Inci'=inrqiinci)
 ...s StkGrpInfo=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(inrqiinci)
 ...s StkGrpId=$p(StkGrpInfo,"^",5)
 ...q:(stkgrpid'="")&&(stkgrpid'=StkGrpId)
 ...s reqiqty=$p(inrqidata,"^",3) ;申请数量
 ...s reqiuom=$p(inrqidata,"^",5) ;申请单位
 ...s reqiuomdesc=$p(^CT("UOM",reqiuom),"^",2)
 ...s buom=$P(^INCI(inrqiinci,1),"^",10)
 ...s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(reqiuom,buom)
 ...s transqty=##class(web.DHCST.DHCINIsTrf).TransQty(inrqi)   ;已转移数量
 ...s nottransqty=reqiqty*fac-transqty
 ...s transqty=transqty/fac
 ...s nottransqty=nottransqty/fac
 ...q:(transqty'=0)&(untranser=1)        ;仅显示完全未转移
 ...;q:(nottransqty<0)&(partlytranser=1)    ;包含部分转移
 ...s incicode=$p(^INCI(inrqiinci,1),"^",1)
 ...s incidesc=$p(^INCI(inrqiinci,1),"^",2)
 ...s date=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(date)
 ...s sp=##class(web.DHCST.Common.PriceCommon).GetPriceElse(inrqiinci,date,reqiuom,hospId,"G","")
 ...s manf=$p(##class(web.DHCST.Common.DrugInfoCommon).GetManf(inrqiinci),"^",3)
 ...i date'="" d
 ....s inrqdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(date,"ST")
 ...e  d
 ....s inrqdate=date
 ...d OutPutINRDetail
 
 Quit $$$OK
 
OutPutINRDetail
 s Data=$lb(inrqi,reqloc,reqlocdesc,recloc,reclocdesc,requser,username,inrqdate,reqno,incicode,incidesc,reqiqty,reqiuomdesc,transqty,sp,manf,nottransqty)
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

/// creator:    yunhaibao 
/// createdate: 2017-06-08
/// description:库存转移直接录入药品,分配批次加载界面
/// input:      inciRowId(库存项Id),proLocRowId(供给科室ID),transQty(入库单位转移数量)
/// return:     json格式数据
/// others:     w ##class(web.DHCST.DHCINIsTrfItm).GetDetailForTransByInci(886,102,100)
ClassMethod GetDetailForTransByInci(inciRowId, proLocRowId, transQty)
{
	n (inciRowId,proLocRowId,transQty) 
	q:(inciRowId="")||(proLocRowId="")||(+transQty'>0) ##class(web.DHCSTEXTCOMMON).GetNoJson()
	s HospID=$p($g(^CTLOC(proLocRowId)),"^",2)
	s pid=..GetInclbForTransfer(proLocRowId,inciRowId,transQty)
	i '$d(^TMPGETINCLB(pid)) q ##class(web.DHCSTEXTCOMMON).GetNoJson()
	s title1="inci^inciCode^inciDesc^inclb^batexp"
	s title2="manfId^manfName^inclbQty^uom^uomDesc"
	s title3="rp^sp^stkbin^reqLocStkQty^newSp"
	s title4="spec^gene^form^ConFac^BUomId"
	s title5="inclbDirtyQty^inclbAvaQty^rpAmt^spAmt^qty"
	s title=title1_"^"_title2_"^"_title3_"^"_title4_"^"_title5
	s spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",inciRowId)
	s inciDesc=$p(^INCI(inciRowId,1),"^",2)
	s inciCode=$p(^INCI(inciRowId,1),"^",1)
	s bUomDr=$p(^INCI(inciRowId,1),"^",10)
	s pUomDr=$p(^INCI(inciRowId,3),"^",6)
	s pUomDesc=$p(^CT("UOM",pUomDr),"^",2)
	s bpFac=##class(web.DHCST.Common.UtilCommon).UOMFac(pUomDr,bUomDr)
	s count=0
	s inclbCnt=""
    f  s inclbCnt=$o(^TMPGETINCLB(pid,inclbCnt)) q:inclbCnt=""  d
    .s incInfo=^TMPGETINCLB(pid,inclb)   
    .s batNo=$p(incInfo,"^",1)
    .s inclbQty=$p(incInfo,"^",2)
    .s expDate=$p(incInfo,"^",3)
    .s inclb=$p(incInfo,"^",4)
    .s batexp=batNo_"~"_expDate
    .s data1=inciRowId_"^"_inciCode_"^"_inciDesc_"^"_inclb_"^"_batexp
    .//
    .s manfInfo=##class(web.DHCST.Common.DrugStkCommon).GetManfInfoByInclb(inclb)
    .s manf=$P(manfInfo,"^",1)
    .s manfName=$P(manfInfo,"^",2)
    .s inclbQty=inclbQty/bpFac
    .s data2=manf_"^"_manfName_"^"_inclbQty_"^"_pUomDr_"^"_pUomDesc
    .//
    .s rp = ##class(web.DHCST.Common.PriceCommon).GetClbRp(inclb,pUomDr,HospID,"G",+$h,"")
    .s sp= ##class(web.DHCST.Common.PriceCommon).GetPriceElse(inclb,+$h,pUomDr,HospID,"G","")
    .s newSp=##class(web.DHCST.Common.PriceCommon).BatSpUom(inclb,pUomDr,HospID)
    .s stkBin="",reqLocStkQty=""
    .s data3=rp_"^"_sp_"^"_stkBin_"^"_reqLocStkQty_"^"_newSp
    .//
    .s gene=##class(web.DHCST.Common.DrugInfoCommon).GetGene(inciRowId)
    .s gene=$p(gene,"^",2)
    .s form=""
    .s data4=spec_"^"_gene_"^"_form_"^"_bpFac_"^"_bUomDr
    .//inclbDirtyQty^inclbAvaQty^rpAmt^spAmt
    .s dirtyQty=$p(incInfo,"^",5)
    .s avaQty=$p(incInfo,"^",6)
    .s trQty=$p(incInfo,"^",7)     ;批次转移数量
    .s trQty=trQty/bpFac
    .s dirtyQty=dirtyQty/bpFac
    .s avaQty=avaQty/bpFac
    .s spAmt=sp*trQty
    .s rpAmt=rp*trQty
    .s data5=dirtyQty_"^"_avaQty_"^"_rpAmt_"^"_spAmt_"^"_trQty
    .s data=data1_"^"_data2_"^"_data3_"^"_data4_"^"_data5
    .s count=count+1
    .i count=1 d
    ..s retstring=##class(web.DHCST.Common.UtilCommon).GetJsonStr(data,title)
	..w "{rows:["_retstring
    .e  d
    ..s retstring=##class(web.DHCST.Common.UtilCommon).GetJsonStr(data,title)
	..w ","_retstring
	q:count'>0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
	w "],results:"_count_"}"
	q ""
}

/// Decription:通过转移入库子表和单位获取占用数量
/// Creator:yangsj
/// CreateDate:2021-04-16
/// Input:initi,uom
/// Output:dirtyQty
/// Table:
/// Debugger: w ##class(web.DHCST.DHCINIsTrfItm).GetDirtyQtyBuUom("36||1",2)
ClassMethod GetDirtyQtyBuUom(initi, uom, hosp = "")
{
	n (initi,uom,hosp)
	q:initi="" ""
	s Init	= +initi
	i hosp="" d
	.s loc  =$P(^DHCINIT(Init),"^",5)
	.s hosp =$P(^CTLOC(loc),"^",22)
	s chl	= $P(initi,"||",2)
	s Data	= ^DHCINIT(Init,"ITI",chl)
	s qty	= $P(Data,"^",1)
	s tmpUom= $P(Data,"^",7)
	s inilb	= $P(Data,"^",3)
	s inci	= +inilb
	s Buom	= $P(^INCI(inci,1),"^",10)
	q:uom=tmpUom qty
	s conf1	= ##class(web.DHCST.Common.UtilCommon).UOMFac(uom,Buom)
	s conf2	= ##class(web.DHCST.Common.UtilCommon).UOMFac(tmpUom,Buom)
	s dirty = qty*conf2/conf1
	s dirty = ##Class(web.DHCST.Common.AppCommon).FormatSq(dirty,hosp,1)
	q dirty
}

/// 翻译 
/// yangsj 2020-11-05
ClassMethod Trans(Text)
{
	q ##class(websys.Translation).Get("dhcst.dhcinistrf.csp",Text)
}

}
