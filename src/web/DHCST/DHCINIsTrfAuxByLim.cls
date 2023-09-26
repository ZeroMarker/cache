Import sqluser

/// 辅助库存转移(根据请求科室的库存上下限)
/// Author :zhwh
/// Date:2012-07-20
/// 
Class web.DHCST.DHCINIsTrfAuxByLim Extends (%RegisteredObject, %XML.Adaptor, StkTypeG) [ Not ProcedureBlock ]
{

/// 取根据请求科室的库存上下限自动生成的出库数据串(json)
/// Author:zhangdongmei
/// Date:2012-07-25
/// Argu:
///   Start
///   Limit
///   Sort
///   Dir
///   sPar - 参数串
/// Return:
///  Json数据串
///  
ClassMethod jsRecLocItmForTransfer(Start As %String, Limit As %String, Sort As %String, Dir As %String, sPar As %String, User As %String) As %String
{
 k jsRecLocItmForTransferData
 s FrLoc=$p(sPar,"^",1)
 s ToLoc=$p(sPar,"^",2)
 s RepLevFac=$p(sPar,"^",3)
 s StkGrpId=$p(sPar,"^",4)
 s:StkGrpId="" StkGrpId=##class(web.DHCST.Util.DrugUtil).GetUserCatGrpStrNew(User,..sssCode())  //若类组为空，则传递User类组串
 s result=##class(%Library.ResultSet).%New("web.DHCST.DHCINIsTrfAuxByLim:RecLocItmForTransfer")
 s sc=result.Execute(ToLoc,FrLoc,RepLevFac,StkGrpId)   
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

Query RecLocItmForTransfer(ToLoc As %String, FrLoc As %String, intfac As %String, StkGrpId As %String) As %Query(ROWSPEC = "inci:%String,code:%String,desc:%String,pUom:%String,pUomDesc:%String,batTraQty:%String,manf:%String,batNo:%String,expDate:%String,stkQty:%String,INCLB:%String,sp:%String,PackUOM:%String,sbDesc:%String,oritrqty:%String,ResQty:%String,AvaQty:%String,curqty:%String,repqty:%String,levelQty:%String,maxQty:%String,minQty:%String,BUomId:%String,Fac:%String")
{
}

ClassMethod RecLocItmForTransferExecute(ByRef qHandle As %Binary, ToLoc As %String, FrLoc As %String, intfac As %String, StkGrpId As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 s qHandle=$lb(0,repid,0)
 S HospID=$P(^CTLOC(ToLoc),"^",22)
 
 s inci=""
 s i=0
 k tmpPLIST
 f  s inci=$O(^INCI("IL_LOC",ToLoc,inci)) q:inci=""  d
  . s data="",batNo="",expDate="",stkQty=0,INCLB="",manf="",sp="",sbDesc="",oritrqty=""
  . s chfrloc="",btrqty=0,btransqty=0,datanum=0,batTraQty=0,ResQty=0,AvaQty=0
  . 
  . //s useFlag=##class(web.DHCST.Common.DrugStkCommon).UseFlag(inci,ToLoc)  //管理药标志
  . //q:usFlag=1  
  . s obj=##class(User.INCItm).%OpenId(inci,0)
  . s notUseFlag=obj.INCINotUseFlag
  . q:notUseFlag="Y"
  .s StkGrpInfo=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(inci)
  .s ScgType=$p(StkGrpInfo,"^",3)
  .s Scg=$p(StkGrpInfo,"^",5)
  .q:ScgType'=..sssCode()
  .q:(StkGrpId'="")&(("^"_StkGrpId_"^")'[("^"_Scg_"^"))
  . s ch=$O(^INCI("IL_LOC",ToLoc,inci,"")) q:ch=""
  . 
  . s maxQty=$p(^INCI(inci,"IL",ch),"^",7) 
  . s minQty=$p(^INCI(inci,"IL",ch),"^",4) 
  . ;b ;2
  . q:maxQty=""
  . q:minQty=""
  . s repqty=$p(^INCI(inci,"IL",ch),"^",6) 
  . q:+repqty<0   ; if the repqty is less than zero then  quit
  . s levelQty=repqty
  . s levelQty=minQty+((maxQty-minQty)/2)  //参照标准数(上限和下限的中间值)
  .  
  . s curqty=##class(web.DHCST.Common.DrugStkCommon).IL(inci,ToLoc,+$h)  ; present qty 
  .// q:curqty>levelQty   //没必要补货
  . i repqty="" s repqty=levelQty
  . s btrqty=+repqty-curqty
  . q:btrqty'>0    ; no need to repire the stock qty
  . ;b ;3
  . s code=obj.INCICode
  . s desc=obj.INCIDesc
  . s uom=obj.INCICTUOMDR.%Id()
  . 
  . s uomdesc=obj.INCICTUOMDR.CTUOMDesc
  . 
  . s pUom=obj.INCICTUOMPurchDR.%Id()
  . s pUomDesc=obj.INCICTUOMPurchDR.CTUOMDesc
  . s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(pUom,uom)
  . 
  . s trqty=+btrqty/fac  ; puruom qty
  . s frInciCh=$O(^INCI("IL_LOC",FrLoc,inci,"")) 
  . q:frInciCh=""
  . s stkbinRet=##class(web.DHCST.Common.DrugInfoCommon).GetInciBinStr(inci_"||"_frInciCh,",","","") 
  . s sbDesc=$p(stkbinRet,":",2)  
  . 
  . s manf=$p(##class(web.DHCST.Common.DrugInfoCommon).GetManf(inci),"^",3)
  . //s sp=##class(web.DHCST.Common.PriceCommon).GetPriceElse(inci,+$h,pUom,HospID)
  . s oritrqty=trqty
  . i intfac'=""  d
  . . s trqty=..GetFinalQty(inci,ToLoc,trqty,intfac)
  . . s btrqty=trqty*fac
  . q:(intfac'="")&(+trqty<1)
  . q:(intfac="")&(+trqty'>0)
  . s spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",inci)
  . s curqty=curqty/fac    ;请求方库存
  . s repqty=repqty/fac
  . s levelQty=levelQty/fac
  . s maxQty=maxQty/fac
  . s minQty=minQty/fac
  . ;b ;11
  . s pid=##class(web.DHCST.DHCINIsTrfItm).GetInclbForTransfer(FrLoc,inci,btrqty)
  . ;b ;12
  . s sub=""
  . s:pid'="" sub=$o(^TMPGETINCLB(pid,""))
  . i sub'="" d
  .. s chl=""
  .. f  s chl=$o(^TMPGETINCLB(pid,chl))  q:chl=""  d
  ... s data=^TMPGETINCLB(pid,chl)
  ... ;b ;1
  ... s batNo=$p(data,"^",1)
  ... s expDate=$p(data,"^",3)
  ... s stkQty=$p(data,"^",2)
  ... s INCLB=$p(data,"^",4)
  ... s ResQty=$p(data,"^",5)
  ... s AvaQty=$p(data,"^",6)
  ... s batTraQty=$p(data,"^",7)
  ... s stkQty=stkQty/fac
  ... s ResQty=ResQty/fac
  ... s AvaQty=AvaQty/fac
  ... s batTraQty=batTraQty/fac
  ... s batTraQty=$fn(batTraQty,"",2)
  ... s manf=$p(##class(web.DHCST.Common.DrugStkCommon).GetManfInfoByInclb(INCLB),"^",2)
  ... s sp=##class(web.DHCST.Common.PriceCommon).GetPriceElse(INCLB,+$h,pUom,HospID,"G","")
  ... d OutPutRow
  ..k ^TMPGETINCLB(pid)
  .e  d
  .. s manf=$p(##class(web.DHCST.Common.DrugInfoCommon).GetManf(+INCLB),"^",3)
  .. d OutPutRow
  . 
  
 Quit $$$OK
OutPutRow
 s Data=$lb(inci,code,desc,pUom,pUomDesc,batTraQty,manf,batNo,expDate,stkQty,INCLB,sp,PackUOM,sbDesc,oritrqty,ResQty,AvaQty,curqty,repqty,levelQty,maxQty,minQty,uom,fac)   
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

ClassMethod GetFinalQty(inci As %String, ToLoc As %String, trqty As %String, intfac As %String) As %String
{
    n (inci,ToLoc,trqty,intfac)
 ; the uom of trqty is "purch" uom
 s repfac=+intfac
 ;
 s replev=..RepLev(inci,ToLoc)  ; purch uom
 q:+replev<1 trqty      
 s int=trqty\replev
 s mod=trqty#replev
 i (mod/replev)<repfac s modint=0
 i (mod/replev)'<repfac s modint=1
 q (int+modint)*replev
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

/// 取补货标准
/// Date:2012-07-19
/// Argu:
///  inci - 库存项rowid
///  locdr - 科室rowid
/// Return:
///  补货标准数 
ClassMethod RepLev(inci, locdr)
{
 n (inci,locdr)
 q:inci="" ""
 q:locdr="" ""
 b ;000
 s ch=$o(^INCI("IL_LOC",locdr,inci,""))  q:ch="" ""
 s replev=$p(^INCI(inci,"IL",ch),"^",5)
 b ;999
 q $g(replev)
}

}
