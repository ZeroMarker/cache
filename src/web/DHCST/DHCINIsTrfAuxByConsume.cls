Import sqluser

Class web.DHCST.DHCINIsTrfAuxByConsume Extends (%RegisteredObject, %XML.Adaptor, StkTypeG) [ Not ProcedureBlock ]
{

/// 取根据请求科室的消耗自动生成的出库数据串(json)
/// Author:zhangdongmei
/// Date:2012-07-26
/// Argu:
///   Start
///   Limit
///   Sort
///   Dir
///   sPar - 参数串
/// Return:
///  Json数据串
///  w ##class(web.DHCST.DHCINIsTrfAuxByConsume).jsRecLocItmForTransfer("0","999","","","320^308^2018-04-29^2018-06-25^111111^^^0^^",6423)
ClassMethod jsRecLocItmForTransfer(Start As %String, Limit As %String, Sort As %String, Dir As %String, sPar As %String, User As %String) As %String
{
 n (Start,Limit,Sort,Dir,sPar,User,%session)
 //s ^TMPDHCSTPARAMS("web.DHCST.DHCINIsTrfAuxByConsume","jsRecLocItmForTransfer")=$lb(Start,Limit,Sort,Dir,sPar,User)
 k jsRecLocItmForTransferData
 s FrLoc=$p(sPar,"^",1)
 s ToLoc=$p(sPar,"^",2)
 s StartDate=$p(sPar,"^",3)
 s EndDate=$p(sPar,"^",4)
 s UseDays=$p(sPar,"^",5)
 s StkGrpId=$p(sPar,"^",6)
 s IntFac=$p(sPar,"^",7)     ;取整系数
 s ManFlag=$p(sPar,"^",8)    ;是否管理药
 s PhWin=$p(sPar,"^",9)      ;发药窗口
 s DispUser=$p(sPar,"^",10)  ;发药人
 s EndTime=+$p(sPar,"^",11)   ;截止时间
 s:EndTime=0 EndTime="23:59:59"
 s:StkGrpId="" StkGrpId=##class(web.DHCST.Util.DrugUtil).GetUserCatGrpStrNew(User,..sssCode())  //若类组为空，则传递User类组串
 s result=##class(%Library.ResultSet).%New("web.DHCST.DHCINIsTrfAuxByConsume:RecLocItmForTransfer")
 s sc=result.Execute(ToLoc,StartDate,EndDate,UseDays,FrLoc,ManFlag,DispUser,IntFac,PhWin,EndTime,StkGrpId)    
 i $$$ISERR(sc) q ##class(web.DHCSTEXTCOMMON).GetNoJson()
 s colNum=result.GetColumnCount()
 s colNameStr=""
 f i=1:1:colNum d
 .i i=1 s colNameStr=result.GetColumnName(i)
 .e  s colNameStr=colNameStr_"^"_result.GetColumnName(i)
 s recordCnt = 0
 s resultString = ""
 s Start=Start+1
 s End = Start+Limit
 While(result.Next())
 { 
	s ret=""
	f i=1:1:colNum d
	.i i=1 s ret=result.%GetData(i)
	.e   s ret=ret_"^"_result.%GetData(i)
	s sordIndex=0
	s recordCnt = recordCnt+1
	s jsRecLocItmForTransferData(sordIndex,recordCnt)=ret
 }
 q:+recordCnt=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
 i End>recordCnt s End=recordCnt  
 s count=0
 s outputI=""
 f  s outputI=$o(jsRecLocItmForTransferData(outputI)) q:outputI=""  d
 .s outputJ=""
 .f  s outputJ=$o(jsRecLocItmForTransferData(outputI,outputJ)) q:outputJ=""  d
 ..s count = count+1
 ..q:count<Start
 ..q:count>End
 ..s outputdata=jsRecLocItmForTransferData(outputI,outputJ)
 ..i count=Start d
 ...w ##class(web.DHCSTEXTCOMMON).GetJsonStartString(recordCnt)
 ...s retstring=##class(web.DHCST.Common.UtilCommon).GetJsonStr(outputdata,colNameStr)
 ...w retstring
 ..e  d
 ...s retstring=##class(web.DHCST.Common.UtilCommon).GetJsonStr(outputdata,colNameStr)
 ...w ","_retstring
 w "]}"
 k jsRecLocItmForTransferData
 q ""
}

/// 检索需要库存转移的库存项列表
/// Author:zhwh
/// Date:2012-07-20
/// Argu:
///   Loc
///   StartDate
///   EndDate
///   useDays
///   FrLoc
///   ManFlag
///   pUser
///   tive
///   pWin
///   EndTime
/// 
Query RecLocItmForTransfer(Loc As %String, StartDate As %String, EndDate As %String, useDays As %String, FrLoc As %String, ManFlag As %String, pUser As %String, tive As %String, pWin As %String, EndTime As %String, StkGrpId As %String) As %Query(ROWSPEC = "INCI:%String,code:%String,desc:%String,pUom:%String,pUomDesc:%String,tranQty:%String,manf:%String,batNo:%String,expDate:%String,stkQty:%String,INCLB:%String,sp:%String,PackUOM:%String,stkbin:%String,purQty:%String,ResQty:%String,AvaQty:%String")
{
}

ClassMethod RecLocItmForTransferExecute(ByRef qHandle As %Binary, Loc As %String, StartDate As %String, EndDate As %String, useDays As %String, FrLoc As %String, ManFlag As %String, pUser As %String, tive As %String, pWin As %String, EndTime As %String, StkGrpId As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 s qHandle=$lb(0,repid,0)
 //
 i (Loc="") q $$$OK
 i (FrLoc="") q $$$OK
 ;q:pUser="" 0
 q:(StartDate="")!(EndDate="") $$$OK
 s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
 s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
 s et=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(EndTime)
 s dspDays=EndDate-StartDate+1   
 S HospID=$P(^CTLOC(Loc),"^",22)
 ;calculate the dispensing qty between StartDate and EndDate
 s INCI=0
 s i=0
 k tmpPLIST
 f  s INCI=$o(^INCI("IL_LOC",Loc,INCI)) q:INCI=""  d
  .s ifquit=0,PackUOM=""
  .s data="",batNo="",expDate="",stkQty="",INCLB="",datanum=0,tranQty=0 ;,ttranqty=0
  .s qty=0,ppQty=0,dispensQty=0,j=0,ResQty=0,AvaQty=0
  .s stkbin="",sp="",manf="",pUom="",pUomDesc="",purQty=0
  .;if PH_MANA
  .s pMana=##class(web.DHCST.Common.DrugStkCommon).UseFlag(INCI,Loc)
  .s StkGrpInfo=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(INCI)
  .s ScgType=$p(StkGrpInfo,"^",3)
  .s Scg=$p(StkGrpInfo,"^",5)
  .q:ScgType'=..sssCode()
  .q:(StkGrpId'="")&(("^"_StkGrpId_"^")'[("^"_Scg_"^"))
  .i ManFlag="1" q:pMana'=1
  .i ManFlag'="1"  q:pMana=1
  .;s qty=$$IL^DHCSTSTKQTY(INCI,Loc,+$h)  ;**************************Comment at 2006-01-24 tj*******
  .s dispensQty=..TotalItmDisp(INCI,StartDate,EndDate,Loc,ManFlag,pUser,pWin,et) q:dispensQty=0       ;the consumption of item
  .;Get the Qty to Supplied
  .i ManFlag="1" d
  ..i tive="+" d
  ...i dispensQty<0 d
  ....s ppQty=-dispensQty
  ...e  d
  ....s ifquit=1
  ....q
  ..e  i tive="-" d
  ...i dispensQty>0 d
  ....s ppQty=+dispensQty
  ...e  d
  ....s ifquit=1
  ....q
  .e  d                                  
  ..i dispensQty<0 d
  ...s permQty=(-1)*(dispensQty/dspDays)   ; average daily dispensing qty
  ...i $g(qty)'<permQty*$g(useDays) s ifquit=1 q
  ...s ppQty=permQty*$g(useDays)-$g(qty)
  ...s ppQty=+ppQty
  ..e  d
  ...s ifquit=1
  ...q
  .q:ifquit=1
  .s code=$p(^INCI(INCI,1),"^",1)
  .s desc=$p(^INCI(INCI,1),"^",2)
  .s ctuom=$p(^INCI(INCI,1),"^",10) q:ctuom=""
  .s pUom=$p(^INCI(INCI,3),"^",6)
  .i pUom="" s pUom=ctuom
  .
  .s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(pUom,ctuom)
  .
  .s purQty=$fn((ppQty/fac),"",2) q:$g(purQty)'>0        ; purch_Uom qty
  .s pUomDesc=$p(^CT("UOM",pUom),"^",2)  ;purch uom desc
  . 
  .s manf=$p(##class(web.DHCST.Common.DrugInfoCommon).GetManf(INCI),"^",3)
  .
  .i (ManFlag="1")&(tive="-") s FrLoc=Loc         ;mana_item and PHDISpen is negative
  .s CH=$o(^INCI("IL_LOC",FrLoc,INCI,""))  
  .q:CH=""
  .s stkbinRet=##class(web.DHCST.Common.DrugInfoCommon).GetInciBinStr(INCI_"||"_CH,",","","") 
  .s stkbin=$p(stkbinRet,":",2)  
  .//s sp=##class(web.DHCST.Common.PriceCommon).GetPriceElse(INCI,+$h,pUom,HospID)
  .s PackUOM=##class(web.DHCST.Common.DrugInfoCommon).GetPackUom(INCI)
  . 
  .s pid=##class(web.DHCST.DHCINIsTrfItm).GetInclbForTransfer(FrLoc,INCI,ppQty)
  .s sub=""
  .s:pid'="" sub=$o(^TMPGETINCLB(pid,""))
  .i sub'="" d
  ..s chl=""
  ..f  s chl=$o(^TMPGETINCLB(pid,chl))  q:chl=""  d
  ...s data=^TMPGETINCLB(pid,chl)
  ...;b ;1
  ...s batNo=$p(data,"^",1)
  ...s expDate=$p(data,"^",3)
  ...s stkQty=$p(data,"^",2)
  ...s INCLB=$p(data,"^",4)
  ...s ResQty=$p(data,"^",5)
  ...s AvaQty=$p(data,"^",6)
  ...s tranQty=$p(data,"^",7)
  ...s stkQty=stkQty/fac
  ...s ResQty=ResQty/fac
  ...s AvaQty=AvaQty/fac
  ...s tranQty=tranQty/fac
  ...s tranQty=$fn(tranQty,"",2)
  ...s sp=##class(web.DHCST.Common.PriceCommon).GetPriceElse(INCLB,+$h,pUom,HospID,"G","")
  ...s tranQty=##class(web.DHCST.Common.UtilCommon).GetFinalQty(tranQty,tive)
  ...d OutPutRow
  .e  d
  ..d OutPutRow
  ..
  Quit $$$OK    
OutPutRow
 s Data=$lb(INCI,code,desc,pUom,pUomDesc,tranQty,manf,batNo,expDate,stkQty,INCLB,sp,PackUOM,stkbin,purQty,ResQty,AvaQty)   
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

ClassMethod RecLocItmForTransferClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = RecLocItmForTransferExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod RecLocItmForTransferFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = RecLocItmForTransferExecute ]
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

ClassMethod TotalItmDisp(inci As %String, StartDate As %String, EndDate As %String, loc As %String, ManFlag As %String, pUser As %String, pWin As %String, EndTime As %String) As %String
{
 ;totalize the dispensing qty for the stock itm between start date and end date
 
 n (inci,StartDate,EndDate,loc,ManFlag,pUser,pWin,EndTime)
 s ch=$o(^INCI("IL_LOC",loc,inci,""))
 q:ch="" 0
 s incil=inci_"||"_ch
 
 s uom=$p(^INCI(inci,1),"^",10)       ; basic uom of the stock itm
 s usrdr=pUser
 s totalQty=0,dispQty=0
 s types="F^H^P^Y"
 //
 f i=1:1:$l(types,"^") d
 .s trType=$p(types,"^",i)
 .f dd=StartDate:1:EndDate  d
 . .s INTR=""
 . .f  s INTR=$o(^DHCINTR(0,"ILTYPEDATE",incil,trType,dd,INTR)) q:INTR=""  d        ; get INTR
 . ..s fuser=$p(^DHCINTR(INTR),"^",11)
 . ..
 . ..//管理药品的控制
 . ..i ManFlag="1" q:($f(usrdr,fuser)=0)   //管理药控制到人
 . ..
 . ..i ManFlag="1" q:$p(^DHCINTR(INTR),"^",5)="Y"           ; have been rep
 . .. // 发药时间的控制
 . ..q:($p(^DHCINTR(INTR),"^",3)>EndTime)&(EndDate=+$h)
 . ..
 . .. // 发药窗口的控制
 . ..s ifquit=0
 . ..i pWin'="" d
 . ...s point=$p(^DHCINTR(INTR),"^",9)
 . ...i point="" s ifquit=1 q
 . ...s fwin=..GetWin(point)
 . ...i fwin'=pWin s ifquit=1
 . ..q:ifquit=1
 . ..
 . ..s dispUom=$p(^DHCINTR(INTR),"^",10)                                          ; dispensing uom
 . ..s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(dispUom,uom)  ; factor 
 . ..                                        
 . ..s dispQty=$p(^DHCINTR(INTR),"^",6)                                                           ;dispensing qty
 . ..s dispQty=dispQty*fac
 . ..s totalQty=$g(totalQty)+$g(dispQty)                                                          ; total of qty in basic uom
 q $g(totalQty)
}

/// 返回发药记录的发药窗口
/// Author:zhwh
/// Date:2012-07-20
/// Argu:
///  phdi - 发药记录ｒｏｗｉｄ
/// Return:
///  窗口rowid
ClassMethod GetWin(phdi As %String) As %String
{
  q:phdi="" ""
  q $p($G(^PHDISP(+phdi,1)),"^",4)
}

/// 查找某科室某库存项目的库存批次，
/// 根据要求的转移数量按批次进行匹配，返回合适的批次，并保存到数组
/// Author:zhwh
/// Date: 2012-07-20
/// Argu:
///   inci -库存项rowid
///   loc -科室rowid
///   uom - 单位rowid
///   bqty - 数量
/// Return:
///  批次数目
///  
ClassMethod GetBatObExp(inci As %String, loc As %String, uom As %String, bqty As %String) As %String
{
 q:($g(inci)="")!($g(loc)="")!($g(bqty)="") 0
 s ch=$o(^INCI("IL_LOC",loc,inci,""))   
 q:ch="" 0
 s incil=inci_"||"_ch
 s basicUom=$p(^INCI(inci,1),"^",10)
 s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(uom,basicUom)
 i fac'>0 s fac=1
 s inclb="",batNo="",expDate="",tranQty=0,qty=0,tmpqty=0,num=0
 ;s totatranqty=0
 k BATPLIST
 &sql(declare curbat cursor for 
  select INCLB_RowId,INCLB_INCIB_DR->INCIB_No,INCLB_INCIB_DR->INCIB_ExpDate from inc_itmlcbt
  where INCLB_INCIL_ParRef=:incil
  order by INCLB_INCIB_DR->INCIB_ExpDate)
 &sql(open curbat)                               
 f  &sql(fetch curbat into :inclb,:batNo,:expdate) q:(SQLCODE)!(tmpqty'<bqty)  d
  .q:+expDate=0
  .s qty=##class(web.DHCST.Common.DrugStkCommon).CurQtyINCLB(inclb)
  .
  .q:qty'>0              ; no any qty
  .
  .s ResQty=##class(web.DHCST.Common.DrugStkCommon).CurInclbResQty(inclb,"")
  .s AvaQty= ##class(web.DHCST.Common.DrugStkCommon).CurInclbAvaQty(inclb,"")
  .q:AvaQty'>0
  .
  .s tmpqty=tmpqty+AvaQty
  .i tmpqty>bqty d
  ..s tranQty=AvaQty-(tmpqty-bqty)
  .e  d
  ..s tranQty=AvaQty
  .s ResQty=ResQty/fac
  .s AvaQty=AvaQty/fac
  .s qty=qty/fac
  .s tranQty=tranQty/fac
  .s expDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(expDate,"ST")
  .;s totatranqty=totatranqty+tranQty
  .s num=num+1
  .s BATPLIST(num)=$g(batNo)_"^"_$g(expDate)_"^"_$g(qty)_"^"_$g(inclb)_"^"_$g(tranQty)_"^"_$g(ResQty)_"^"_$g(AvaQty)
  .s inclb="",batNo="",expDate="",tranQty=0,qty=0
 s BATPLIST=$o(BATPLIST(""),-1)
 &sql(close curbat)
 q num
}

ClassMethod NewPid()
{
	q ##class(web.DHCSTKUTIL).NewPid($ClassName(),"ST")
}

}
