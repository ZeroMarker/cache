Import sqluser

Class web.DHCST.INRequestAuxByConsume Extends (%RegisteredObject, %XML.Adaptor, StkTypeG) [ Not ProcedureBlock ]
{

/// 检索需补货库存项目(json)
/// Author:zhwh
/// Date:2012-08-03
/// Argu:
/// Start - 起始行号
/// Limit　-截止行号
/// StrPar - 参数串("^"分隔)
/// Return:
///  需补货库存项目数据串(json)
/// d ##class(web.DHCST.INRequestAuxByConsume).jsLocItmForReq(0,999,"257^2020-06-28^2020-06-28^10^29^245^^true^true",1)
ClassMethod jsLocItmForReq(Start As %String, Limit As %String, StrPar As %String, User As %String) As %String
{
 n (Start,Limit,StrPar,User,%session)
 s ToLoc=$p(StrPar,"^",1)
 s StartDate=$p(StrPar,"^",2)
 s EndDate=$p(StrPar,"^",3)
 s Days=$p(StrPar,"^",4)
 s SCG=$p(StrPar,"^",5)
 s FrLoc=$p(StrPar,"^",6)
 s StkCatId=$p(StrPar,"^",7) //库存分类
 s RoundFlag=$p(StrPar,"^",8)  //建议申请量取整,true为取整
 s ReqEnough=$p(StrPar,"^",9)  //库存小于消耗 true 
 q:ToLoc="" ""
 q:StartDate="" ""
 q:EndDate="" ""
 q:Days="" ""
 s:SCG="" SCG=##class(web.DHCST.Util.DrugUtil).GetUserCatGrpStrNew(User,..sssCode())  //若类组为空，则传递User类组串
 s result=##class(%Library.ResultSet).%New("web.DHCST.INRequestAuxByConsume:LocItmForReq")
 s sc=result.Execute(ToLoc,StartDate,EndDate,Days,SCG,FrLoc,StkCatId,RoundFlag,ReqEnough)
 i $$$ISERR(sc) q "" 
 s colNum=result.GetColumnCount()
 s count = 0
 s resultString = ""
 s end = Start+Limit
 s tmp=""
 w "{results:0,rows:["
 While(result.Next())
 { 
	i tmp'=""  d
	.w "{"_tmp_"},"
	s ret=""
	f i=1:1:colNum d
	.i ret="" s ret=result.GetColumnName(i)_":'"_result.%GetData(i)_"'"
	.e   s ret=ret_","_result.GetColumnName(i)_":'"_result.%GetData(i)_"'"
	.
	s tmp=ret
	s count = count+1
 }
 i tmp="" w "]}"
 e  w "{"_tmp_"}]}"
 d result.Close()
 q
}

/// 根据消耗检索需要请求的药品
/// Author:zhwh
/// Date:2012-07-19
/// Argu:
///  ToLoc - 请求科室rowid
///  StartDate - 起始日期
///  EndDate - 截止日期
///  Days - 参考天数
///  SCG - 类组rowid
///  FrLoc - 供应科室rowid
///  
Query LocItmForReq(ToLoc As %String, StartDate As %String, EndDate As %String, Days As %String, SCG As %String, FrLoc As %String, StkCatId As %String, RoundFlag As %String = "", ReqEnough As %String = "") As %Query(ROWSPEC = "inci:%String,code:%String,desc:%String,spec:%String,manf:%String,uom:%String,uomDesc:%String,StkQty:%String,avaQty:%String,dailyDispQty:%String,reqQtyAll:%String,applyQty:%String,dispQtyAll:%String,stkCatDesc:%String,prvoqty:%String,proReqQty")
{
}

ClassMethod LocItmForReqExecute(ByRef qHandle As %Binary, ToLoc As %String, StartDate As %String, EndDate As %String, Days As %String, SCG As %String, FrLoc As %String, StkCatId As %String, RoundFlag As %String = "", ReqEnough As %String = "") As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 s qHandle=$lb(0,repid,0)
 q:StartDate="" $$$OK
 q:EndDate="" $$$OK
 q:ToLoc="" $$$OK
 q:Days="" $$$OK
 k ^DHCSTLGSTR($j,"ADDISP")
 s type="P",num=0,inci="",pknum=0
 s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
 s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
 s dispdays=EndDate-StartDate+1
 f  s inci=$o(^INCI("IL_LOC",ToLoc,inci)) q:inci=""  d
 .s StkQty="",dispQtyAll="",avaQty="",applyQty="",reqQtyAll="",dailyDispQty=""
 .s code="",desc="",buom="",uom="",fac="",stkcatgpdr="",scgcode="",ifquit="",scgtype=""
 .s ch=$o(^INCI("IL_LOC",ToLoc,inci,""))
 .s incil=inci_"||"_ch
 .
 .q:$p($g(^INCI(inci,2)),"^",9)="Y"   //过滤"不可用"项 zhwh, 2011-06-22
 .i FrLoc'="" q:$o(^INCI("IL_LOC",FrLoc,inci,""))=""  //若供应科室无此库存项则不予请求  zhwh, 2011-06-22
 .s StkGrpInfo=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(inci)
 .s ScgType=$p(StkGrpInfo,"^",3)
 .s Scg=$p(StkGrpInfo,"^",5)
 .q:ScgType'=..sssCode()
 .q:(SCG'="")&(("^"_SCG_"^")'[("^"_Scg_"^"))
 .s dispQtyAll=..TotalItmDisp(incil,StartDate,EndDate) 
 .q:dispQtyAll'<0  ;disp qty
 .s StkCatIdItm=$p(^INCI(inci,2),"^",2) //库存分类
 .s stkCatDesc=""
 .s:StkCatIdItm'="" stkCatDesc=$p(^INC("SC",StkCatIdItm),"^",2)
 .q:(StkCatId'="")&(StkCatIdItm'=StkCatId)
 .s StkQty=##class(web.DHCST.Common.DrugStkCommon).IL(inci,ToLoc,+$h)
 .s avaQty=StkQty
 .s avaQty=##class(web.DHCST.Common.DrugStkCommon).CurItmAvaQtyB(incil,"")
 .s dailyDispQty=(-dispQtyAll)/dispdays
 .s reqQtyAll=dailyDispQty*Days
 .q:(avaQty>reqQtyAll)&&(ReqEnough="true")      ;2006-06-29 update
 .s code=$p(^INCI(inci,1),"^",1)
 .s desc=$p(^INCI(inci,1),"^",2)
 .s buom=$p(^INCI(inci,1),"^",10)
 .s uom=$p(^INCI(inci,3),"^",6)
 .s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(uom,buom)
 .s applyQty=avaQty-reqQtyAll
 .i applyQty<0 s applyQty=-applyQty
 .e  s applyQty=0
 .s prvoqty=##class(web.DHCST.Common.DrugStkCommon).LocDayQtyUom(inci,FrLoc,uom,+$h)  //供方库存
 .//按换算单位换算数量
 .s dailyDispQty=$fn(dailyDispQty/fac,"",4)  ;日发药量
 .s reqQtyAll=$fn(reqQtyAll/fac,"",2)  ;days天需求量
 .s StkQty=$fn(StkQty/fac,"",2)  ;dhc 库存
 .s avaQty=$fn(avaQty/fac,"",2)  ;可用开医嘱量
 .s applyQty=$fn(applyQty/fac,"",2)     ;建议申请量
 .q:(applyQty=0)&(ReqEnough="true")  //需求量为0过滤,库存小于消耗,yunhaibao20151119
 .s uomDesc=$p(^CT("UOM",uom),"^",2)
 .s dispQtyAll=$fn((-dispQtyAll)/fac,"",2)  ;日期范围内发药总量 2007-01-05
 .s prvoqty=prvoqty //wyx 
 .s spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",inci)
 .s manf=$p(##class(web.DHCST.Common.DrugInfoCommon).GetManf(inci),"^",3)
 .i RoundFlag="true" d  //申请量取整,yunhaibao20151119
 ..s tmpapplyQty=$p(applyQty,".",2)
 ..i +tmpapplyQty>0 s applyQty=$p(applyQty,".",1)+1
 .s proReqQty=applyQty
 .s num=num+1
 .d OutPutRow	
 Quit $$$OK
OutPutRow
 s Data=$lb(inci,code,desc,spec,manf,uom,uomDesc,StkQty,avaQty,dailyDispQty,reqQtyAll,applyQty,$g(dispQtyAll),stkCatDesc,prvoqty,proReqQty)   
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

ClassMethod LocItmForReqClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LocItmForReqExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod LocItmForReqFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LocItmForReqExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
	Set AtEnd=1
	Set Row=""
 }
 Else {			
 		Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

/// 统计销售
/// Author:zhwh
/// Date:2012-07-19
/// Argu:
///  incil - 科室库存项rowid
///  StartDate - 起始日期
///  EndDate - 截止日期
/// Return:
///   销售数量  
ClassMethod TotalItmDisp(incil As %String, StartDate As %String, EndDate As %String)
{
 n ( incil,StartDate,EndDate)
 s types="P^Y^F^H"
 s uom=$p(^INCI(+incil,1),"^",10) q:uom="" 0
 s totalQty=0,dispQty=0
 f i=1:1:$l(types,"^") d
 .s trType=$P(types,"^",i)
 .f dd=StartDate:1:EndDate  d
 ..s intr=""
 ..;b ;12
 ..f  s intr=$o(^DHCINTR(0,"ILTYPEDATE",incil,trType,dd,intr)) q:intr=""  d
 ...;b ; get INTR
 ...q:$d(^DHCINTR(intr))'=1   //Glboal节点不存在 
 ...;b ;111
 ...s dispuom=$p(^DHCINTR(intr),"^",10)   ; dispensing uom
 ...s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(dispuom,uom) 
 ...s dispQty=$p(^DHCINTR(intr),"^",6) ;dispensing qty
 ...s dispQty=dispQty*fac
 ...s totalQty=$g(totalQty)+$g(dispQty)  ; total of qty in basic uom
 q totalQty
}

ClassMethod INRequestAuxByLocStk(StrParam) As %String
{
	n (StrParam,%session)
	s ProLocId=+$p(StrParam,"^",1)
	s StartDate=$p(StrParam,"^",2)
	s EndDate=$p(StrParam,"^",3)
	s InqLocId=+$p(StrParam,"^",7)
	s StkGrpId=$p(StrParam,"^",5)
	s TypeStr=$p(StrParam,"^",6)
	s UseDays=$p(StrParam,"^",4)
	s userId=+$p(StrParam,"^",8)
	s GroupId=$p(StrParam,"^",9)
	s status=$p(StrParam,"^",10)
	s InqParam=ProLocId_"^"_InqLocId_"^"_userId_"^"_StkGrpId_"^"_status_"^"_""
	///准备申领数据
 	q:InqLocId=0 ""
 	q:ProLocId=0 ""
    q:StartDate="" ""
    q:EndDate="" "" 
    s:StkGrpId="" StkGrpId=##class(web.DHCST.Util.DrugUtil).GetUserCatGrpStrNew(userId,..sssCode())  //若类组为空，则传递User类组串
    s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
    s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
    s DspDays=EndDate-StartDate+1 			;days for dispensing
    s pid=..CalcDispQty(InqLocId,StartDate,EndDate,StkGrpId,TypeStr,"N")  ; calculate the data
    s num=0
    s Inci=0
    f  s Inci=$o(^TMPINREQUEST(pid,"DISP",Inci))  q:Inci=""  d
    .s ch=$o(^INCI("IL_LOC",InqLocId,Inci,""))
 	.s incil=Inci_"||"_ch
 	.s dhcincil=$o(^DHCINCIL(0,"INCIL",incil,""))
    .s DispensQty=^TMPINREQUEST(pid,"DISP",Inci)
    .q:DispensQty=0
    .s PermQty=(DispensQty/DspDays)   ; average daily dispensing qty
    .i UseDays'="" s PpQty=PermQty*UseDays //建议采购量
    .e  s PpQty=DispensQty
    .s avaQty=##class(web.DHCST.Common.DrugStkCommon).CurItmAvaQtyB(incil,"")  //可用数量基本单位
    .q:avaQty>PpQty
    .s applyQty=avaQty-PpQty
    .i applyQty<0 s applyQty=-applyQty
    .e  s applyQty=0
    .s BUomId=$p(^INCI(Inci,1),"^",10)
    .q:BUomId="" 
    .s PurUomId=$p(^INCI(Inci,3),"^",6)
    .i PurUomId="" s PurUomId=BUomId
    .s Fac=##class(web.DHCST.Common.UtilCommon).UOMFac(PurUomId,BUomId)
    .s DispensQty=DispensQty/Fac			;大包装的消耗数
    .s PpQty=PpQty/Fac			;大包装的消耗数
    .s applyQty=applyQty/Fac  
    .s PurUomDesc=$p(^CT("UOM",PurUomId),"^",2)  ;purch uom desc
 	.s StkQty=##class(web.DHCST.Common.DrugStkCommon).CurItmAvaQtyB(incil,PurUomId) //科室可用库存
    .s DispensQty=$fn(DispensQty,"",2)
    .i +applyQty>0 s applyQty=$p(applyQty,".",1)+1  //取整
    .s num=num+1
    .s TempStr=""_"^"_Inci_"^"_PurUomId_"^"_applyQty_"^"_""_"^"_StkGrpId_"^"_PpQty 
    .s ^TMP("DHCST","web.DHCST.INRequestAuxByConsume","INRequestAuxByLocStk",pid,num)=TempStr
    k ^TMPINREQUEST(pid)
    q:num=0 "-1"
    s rowDelim=##class(web.DHCST.Common.UtilCommon).RowDataDelim()	//记录行分隔符设置
    ///生成申领单
    s InqId=""
    tstart
    s $ZT="Error^DHCSTERROR"    //增加错误处理
    s Err=0
    s detailstr=""
    s index=""
    f  s index=$o(^TMP("DHCST","web.DHCST.INRequestAuxByConsume","INRequestAuxByLocStk",pid,index)) q:(index="")||(Err=1)  d
    .s detail=$g(^TMP("DHCST","web.DHCST.INRequestAuxByConsume","INRequestAuxByLocStk",pid,index))
    .i detailstr'="" s detailstr=detailstr_rowDelim_detail
    .e  s detailstr=detail
    s ret=##Class(web.DHCST.INRequest).Save("",InqParam,detailstr)   //插入申请表
    i +ret'>0  s Err=1
    e  s InqId=ret
    tcommit    //提交事务
    k ^TMP("DHCST","web.DHCST.INRequestAuxByConsume","INRequestAuxByLocStk",pid)
    q:Err'=0 ret
	q InqId
}

/// Descript:calculate the qty for purchase and store the data 
/// into  ^TMPINREQUEST(Pid,"DISP")
/// Creater:	caoting
/// CreateDate:	2014-05-16
/// Table:INC_ItmLoc
/// Input:消耗科室id,开始日期,截止日期,类组id,业务类型串
/// Output:	^TMPINREQUEST(Pid,"DISP")	
/// Return：pid
ClassMethod CalcDispQty(LocId As %String, StartDate As %String, EndDate As %String, StkGrpId As %String, TypeStr As %String, IfShowAllStk As %String = "") As %Library.String
{
	n (LocId,EndDate,StartDate,StkGrpId,TypeStr,IfShowAllStk)
	;
    s Pid=..NewPid()
    s Inci=0
    s i=0
    ;b ;10
	f  s Inci=$o(^INCI("IL_LOC",LocId,Inci)) q:Inci=""  d
	.s Ch=$o(^INCI("IL_LOC",LocId,Inci,""))
	.;b ;12 
	.q:Ch=""     ; not find the item in this loc
	.s StkGrpInfo=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(Inci)
	.s TmpStkGrpId=$p(StkGrpInfo,"^",5)
	.s StkType=$p(StkGrpInfo,"^",3)
	.;b ;11
	.;q:(StkGrpId'="")&(TmpStkGrpId'=StkGrpId)
	.q:(StkGrpId'="")&(("^"_StkGrpId_"^")'[("^"_TmpStkGrpId_"^"))
	.q:StkType'=..sssCode()
	.s i=i+1
	.;b ;13
	.//dhc_intrans升级过的ㄛ可以使用如下的方法(更快)
	.s Incil=Inci_"||"_Ch
	.s Qty=##class(web.DHCST.INPurPlanAuxByConsume).CalcLocItmDispQty(Incil,StartDate,EndDate,TypeStr)
	.q:(Qty=0)&(IfShowAllStk'="Y")  
	.s ^TMPINREQUEST(Pid,"DISP",Inci)=Qty
	.
	q Pid
}

ClassMethod NewPid() As %String
{
  q ##class(web.DHCSTKUTIL).NewPid($ClassName(),"ST")
}

}
