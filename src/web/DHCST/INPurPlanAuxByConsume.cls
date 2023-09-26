Import sqluser

/// Descript:依据消耗生成采购计划单
/// Creater:	ZhangDongmei
/// CreateDate:	2012-08-01
Class web.DHCST.INPurPlanAuxByConsume Extends (%RegisteredObject, StkTypeG) [ Not ProcedureBlock ]
{

/// Descript:根据科室消耗生成采购计划单
/// Creater:	ZhangDongmei
/// CreateDate:	2012-08-01
/// Table:INC_ItmLoc
/// Input:消耗科室id,开始日期,截止日期,用药天数,类组id,业务类型串,采购科室id,采购人员id
/// Output:		
/// Return:Inci^InciCode^InciDesc^PurUomId^PurUomDesc^PurQty^VenId^VenDesc^ManfId^ManfDesc^StkQty^Rp^CarrierId^CarrierDesc^DispensQty
/// w ##class(web.DHCST.INPurPlanAuxByConsume).QueryLocItmForPurch("102^2016-10-12^2016-10-12^111^1^T,K^102^590^1^^N^Y")
ClassMethod QueryLocItmForPurch(StrParam As %String) As %Library.String
{
	n (StrParam)
	// s ^zhxl("QueryLocItmForPurch")=StrParam
	s LocId=+$p(StrParam,"^",1)
	s StartDate=$p(StrParam,"^",2)
	s EndDate=$p(StrParam,"^",3)
	s PurLocId=+$p(StrParam,"^",7)
	s StkGrpId=$p(StrParam,"^",5)
	s TypeStr=$p(StrParam,"^",6)
	s UseDays=$p(StrParam,"^",4)
	s userId=+$p(StrParam,"^",8)
	s zbflag=+$p(StrParam,"^",9)
	s StkCatId=$p(StrParam,"^",10)
	s AllLocQtyFlag=$p(StrParam,"^",11) //根据全院库存计算需求量
	s IncludeZeroFlag=$p(StrParam,"^",12) //包含预计采购数为0
	s gGroupId=$p(StrParam,"^",13)
 	q:LocId=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()  
    q:StartDate="" ##class(web.DHCSTEXTCOMMON).GetNoJson()  
    q:EndDate="" ##class(web.DHCSTEXTCOMMON).GetNoJson()   
    s HospId=""
	i LocId'="" s HospId=$p($g(^CTLOC(LocId)),"^",22)
    s:StkGrpId="" StkGrpId=##class(web.DHCST.Util.DrugUtil).GetUserCatGrpStr(userId,..sssCode())  //若类组为空，则传递User类组串
    s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
    s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
    s appName=##class(web.DHCST.INPurPlan).%GetParameter("AppName")
    s params=gGroupId_"^"_PurLocId_"^"_userId_"^"_HospId
	s getQtyWay = ##class(web.DHCST.Common.AppCommon).GetAppPropValue(appName, "GetQtyWay", params)
    s ReqLocId=LocId
    s DspDays=EndDate-StartDate+1 			;days for dispensing
    s count=0
	s Start=0
	s Limit=9999
	s endpage=Start+Limit  //结束行
	s stpage=Start+1 //开始行
	s index=""
	s Pid=..NewPid()
	Set $ZT="ERRORQueryLocItmForPurch"
    ;calculate the dispensing qty between sd and ed
    s Pid=..CalcDispQty(LocId,StartDate,EndDate,StkGrpId,TypeStr,IncludeZeroFlag,"",Pid)  ; calculate the data
    s count=0
    s Inci=0
    s index=0
    f  s Inci=$o(^TMPINPURPLAN(Pid,"DISP",Inci))  q:Inci=""  d
    .s StkQty=##class(web.DHCST.Common.DrugStkCommon).IL(Inci,LocId,+$h)
    .s ProvideLocQty=##class(web.DHCST.Common.DrugStkCommon).IL(Inci,PurLocId,+$h)
    .s TmpStkQty=StkQty
    .s HospStkQty=##class(web.DHCST.Common.DrugStkCommon).QtyHospInc(Inci,HospId,+$h)
    .i AllLocQtyFlag="Y" s TmpStkQty=HospStkQty
    .s DispensQty=^TMPINPURPLAN(Pid,"DISP",Inci)
    .s PermQty=(DispensQty/DspDays)   ; average daily dispensing qty 
    .q:(IncludeZeroFlag'="Y")&&(TmpStkQty'<(PermQty*UseDays))  ; 当前库存不小于平均消耗*天数ㄛ表示够用
 	.s incZBFlag=##Class(web.DHCST.INPurPlanAuxByLim).GetItmPbFlag(Inci)
    .q:(zbflag="2")&&(incZBFlag'=1) //招标
    .q:(zbflag="3")&&(incZBFlag=1)  //非招标
 	.s StkCatDesc="" //库存分类
    .s StkCatIditm=$p(^INCI(Inci,2),"^",2)
    .s:StkCatIditm'="" StkCatDesc=$p(^INC("SC",StkCatIditm),"^",2)
 	.q:(StkCatId'="")&(StkCatIditm'=StkCatId)
 	.s PpQty=PermQty*UseDays-TmpStkQty    ;需采购数量
    .s PpQty=+PpQty
    .s InciCode=$p(^INCI(Inci,1),"^",1)
    .s InciDesc=$p(^INCI(Inci,1),"^",2)
    .s BUomId=$p(^INCI(Inci,1),"^",10)
    .q:BUomId="" 
    .s PurUomId=$p(^INCI(Inci,3),"^",6)
    .i PurUomId="" s PurUomId=BUomId
    .s Fac=##class(web.DHCST.Common.UtilCommon).UOMFac(PurUomId,BUomId)
    .s DispensQty=DispensQty/Fac			;大包装的消耗数
    .s StkQty=$fn((StkQty/Fac),"",0)			; stk log qty in PURCH UOM
    .s PurQty=$fn((PpQty/Fac),"",0)        ; purch qty 取整计算
    .s ProvideLocQty=$fn(ProvideLocQty/Fac,"",0)
    .s HospStkQty=$fn((HospStkQty/Fac),"",0)  ;全院库存数量
 	.q:(IncludeZeroFlag'="Y")&&(PurQty'>0)
 	.i PurQty'>0 s PurQty=0
    .s PurUomDesc=$p(^CT("UOM",PurUomId),"^",2)  ;purch uom desc
    .s PackQty=""
    .s PackUomDesc=""
    .s PackPurFac=""
    .s ProLocQty=PurQty  //建议采购量
    .i $d(^DHCITMINFO(0,"INCI",Inci)) d
    ..s ItmInfoId=$o(^DHCITMINFO(0,"INCI",Inci,0))
    ..s PackPurFac=$p(^DHCITMINFO(ItmInfoId),"^",52)
    ..s PackUomDr=$p(^DHCITMINFO(ItmInfoId),"^",51)
    ..i +PackPurFac>0 d
    ...s PackQty=PurQty/PackPurFac
    ...i (getQtyWay = "2") d
    ....s PurQty = $SYSTEM.SQL.FLOOR(PackQty) * PackPurFac  //向下取整后转换  
    ...i (getQtyWay = "3") d
    ....s PurQty = ##class(%SYSTEM.SQL).CEILING(PackQty) * PackPurFac  //向上取整后转换  by zhaoxinlong  2022.04.01
    ..i PackUomDr'="" s PackUomDesc=$p($g(^CT("UOM",PackUomDr)),"^",2)
    .i PackUomDesc'="" s PackUomDesc=PackPurFac_$p(PurUomDesc,"[",1)_"/"_PackUomDesc
    .s ItmInfo=##class(web.DHCST.INPurPlan).GetItmInfo(Inci,gGroupId_"^"_PurLocId_"^"_userId)
    .s VenId=$p(ItmInfo,"^",1)
    .s VenDesc=$p(ItmInfo,"^",2)
    .s ManfId=$p(ItmInfo,"^",3)
    .s ManfDesc=$p(ItmInfo,"^",4)
    .s CarrierId=$p(ItmInfo,"^",5)
    .s CarrierDesc=$p(ItmInfo,"^",6)
    .s LastExpDate=##class(web.DHCST.Common.DrugStkCommon).GetLastExpDate(Inci,"")
    .s ret=0
    .s ApcWarn = ##class(PHA.IN.Cert.Query).CheckExpDate(VenId,ManfId)
    .s Rp=$p(ItmInfo,"^",9)
    .s DispensQty=$fn(DispensQty,"",2) 
    .s count=count+1
    .s index=count  //排序
    .s Data1=Inci_"^"_InciCode_"^"_InciDesc_"^"_PurUomId_"^"_PurUomDesc_"^"_PurQty_"^"_VenId_"^"_VenDesc_"^"_ManfId
    .s Data2=ManfDesc_"^"_ProvideLocQty_"^"_Rp_"^"_CarrierId_"^"_CarrierDesc_"^"_DispensQty_"^"_BUomId_"^"_Fac_"^"_ApcWarn_"^"_StkCatDesc
    .s Data3=PackQty_"^"_PackUomDesc_"^"_HospStkQty_"^"_PackPurFac_"^"_LastExpDate_"^"_ReqLocId _"^"_ ProLocQty
    .s Data=Data1_"^"_Data2_"^"_Data3
    .s ^TMP("DHCST","INPurPlanAuxByConsume","QueryLocItmForPurch",Pid,"index",index)=Data
    q:count=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()  
    s maxrow=index
	i endpage>maxrow s endpage=maxrow    
    s count=0
    s h=""
    f  s h=$o(^TMP("DHCST","INPurPlanAuxByConsume","QueryLocItmForPurch",Pid,"index",h)) q:h=""  d
    .s data=^TMP("DHCST","INPurPlanAuxByConsume","QueryLocItmForPurch",Pid,"index",h)
	.s Inci=$p(data,"^",1)
    .s InciCode=$p(data,"^",2)
    .s InciDesc=$p(data,"^",3)
    .s PurUomId=$p(data,"^",4)
    .s PurUomDesc=$p(data,"^",5)
    .s PurQty=$p(data,"^",6)
    .s VenId=$p(data,"^",7)
    .s VenDesc=$p(data,"^",8)
    .s ManfId=$p(data,"^",9)
    .s ManfDesc=$p(data,"^",10)
    .s StkQty=$p(data,"^",11)
    .s Rp=$p(data,"^",12)
    .s CarrierId=$p(data,"^",13)
    .s CarrierDesc=$p(data,"^",14)
    .s DispensQty=$p(data,"^",15)
    .s BUomId=$p(data,"^",16)
    .s ConFac=$p(data,"^",17)
    .s ApcWarn=$p(data,"^",18)
    .s StkCatDesc=$p(data,"^",19)
    .s PackQty=$p(data,"^",20)
    .s PackUomDesc=$p(data,"^",21)
    .s HospStkQty=$p(data,"^",22)
    .s PackPurFac=$p(data,"^",23)
    .s LastExpDate=$p(data,"^",24)
    .s ReqLocId=$p(data,"^",25)
    .s ProLocQty=$p(data,"^",26)
    .s count=count+1
    .s Inci=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("Inci",Inci)
    .s InciCode=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("InciCode",InciCode)
    .s InciDesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("InciDesc",InciDesc)
    .s PurUomId=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("PurUomId",PurUomId)
    .s PurUomDesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("PurUomDesc",PurUomDesc)
    .s PurQty=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("PurQty",PurQty)
    .s VenId=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("VenId",VenId)
    .s VenDesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("VenDesc",VenDesc)
    .s ManfId=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("ManfId",ManfId)
    .s ManfDesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("ManfDesc",ManfDesc)
    .s StkQty=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("StkQty",StkQty)
    .s Rp=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("Rp",Rp)
    .s CarrierId=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("CarrierId",CarrierId)
    .s CarrierDesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("CarrierDesc",CarrierDesc)
    .s DispensQty=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("DispensQty",DispensQty)
    .s BUomId=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("BUomId",BUomId)
    .s ConFac=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("ConFac",ConFac)
    .s ApcWarn=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("ApcWarn",ApcWarn)
    .s StkCatDesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("StkCatDesc",StkCatDesc)
    .s PackQty=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("PackQty",PackQty)
    .s PackUomDesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("PackUomDesc",PackUomDesc)
    .s HospStkQty=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("HospStkQty",HospStkQty)
    .s PackPurFac=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("PackPurFac",PackPurFac)
    .s LastExpDate=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("LastExpDate",LastExpDate)
    .s ReqLocId=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("ReqLocId",ReqLocId)
    .s ProLocQty=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("ProLocQty",ProLocQty)
	.s tmpstr=Inci_InciCode_InciDesc_PurUomId_PurUomDesc_PurQty_VenId_VenDesc_ManfId_ManfDesc_StkQty_Rp_CarrierId_CarrierDesc_DispensQty_BUomId_ConFac_ApcWarn_StkCatDesc_PackQty_PackUomDesc_HospStkQty_PackPurFac_LastExpDate_ReqLocId_ProLocQty
	.s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
    .i count=stpage w startString
    .i count<endpage w firstrow
    .i count=endpage w lastrow
	k ^TMPINPURPLAN(Pid,"DISP")
	k ^TMP("DHCST","INPurPlanAuxByConsume","QueryLocItmForPurch",Pid)
    i count=0 q "{results:0,rows:[]}"
	e  q ""
ERRORQueryLocItmForPurch
	k ^TMP("DHCST","INPurPlanAuxByConsume","QueryAllItmForPurch",Pid)    
	s Error=$$Error^DHCSTERROR()
	q "{Error:'"_Error_"'}"
}

/// Descript:calculate the qty for purchase and store the data 
/// into  ^TMPINPURPLAN(Pid,"DISP")
/// Creater:	ZhangDongmei
/// CreateDate:	2012-08-01
/// Table:INC_ItmLoc
/// Input:消耗科室id,开始日期,截止日期,类组id,业务类型串
/// Output:	^TMPINPURPLAN(Pid,"DISP")	
/// Return：pid
ClassMethod CalcDispQty(LocId As %String, StartDate As %String, EndDate As %String, StkGrpId As %String, TypeStr As %String, IfShowAllStk As %String = "", stkcatid As %String = "", Pid As %String) As %Library.String
{
	n (LocId,EndDate,StartDate,StkGrpId,TypeStr,IfShowAllStk,stkcatid,Pid)
    s Inci=0
    s i=0
	f  s Inci=$o(^INCI("IL_LOC",LocId,Inci)) q:Inci=""  d
	.s Ch=$o(^INCI("IL_LOC",LocId,Inci,""))
	.q:Ch=""     ; not find the item in this loc
	.s StkGrpInfo=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(Inci)
	.s TmpStkGrpId=$p(StkGrpInfo,"^",5)
	.s StkType=$p(StkGrpInfo,"^",3)
	.;q:(StkGrpId'="")&(TmpStkGrpId'=StkGrpId)
	.q:(StkGrpId'="")&(("^"_StkGrpId_"^")'[("^"_TmpStkGrpId_"^"))
	.q:StkType'=..sssCode()
	.s StkCatIditm=$p(^INCI(Inci,2),"^",2)     //库存分类
	.q:(StkCatIditm'=stkcatid)&(stkcatid'="")
	.s i=i+1
	.//dhc_intrans升级过的可以使用如下的方法(更快)
	.s Incil=Inci_"||"_Ch
	.s Qty=..CalcLocItmDispQty(Incil,StartDate,EndDate,TypeStr)
	.s IfHappened=..IfHappendByIncilTypes(Incil,StartDate,EndDate,TypeStr)
	.q:(Qty=0)&(IfShowAllStk'="Y")  
	.q:(IfHappened'="Y")&(IfShowAllStk="Y") //过滤掉未发生业务的
	.s ^TMPINPURPLAN(Pid,"DISP",Inci)=Qty
	.
	q Pid
}

/// Descript:计算某一科室库存项的消耗量
/// Creater:	ZhangDongmei
/// CreateDate:	2012-08-01
/// Table:DHC_InTrans
/// Input:科室库存id,开始日期,截止日期,业务类型串
/// Output:		
/// Return：消耗量
ClassMethod CalcLocItmDispQty(Incil As %String, StartDate As %String, EndDate As %String, TypeStr As %String) As %Library.String
{
	n (Incil,StartDate,EndDate,TypeStr)
	s TotalQty=0
	s DispQty=0
	q:TypeStr="" 0
	s TypeCnt=$l(TypeStr,",")
	f i=1:1:TypeCnt d
	.s Type=$P(TypeStr,",",i)
	.f DD=StartDate:1:EndDate d
	..s INTR=0
	..f  s INTR=$o(^DHCINTR(0,"ILTYPEDATE",Incil,Type,DD,INTR)) q:INTR=""  d
	...s Uom=$p(^INCI(+Incil,1),"^",10)       ; basic uom of the stock itm
	...s Inclb=$p(^DHCINTR(INTR),"^",7) 
	...s DispUom=$p(^DHCINTR(INTR),"^",10)  ; dispensing uom
	...s Fac=##class(web.DHCST.Common.UtilCommon).UOMFac(DispUom,Uom)      ; factor 
	...s Dispqty=$p(^DHCINTR(INTR),"^",6)      ;dispensing qty
	...s Dispqty=Dispqty*Fac
	...s TotalQty=TotalQty+Dispqty  ; total of qty in basic uom
	..
	.
	q (-1)*TotalQty    ;r
}

/// Descript:计算某一库存项的全院消耗量(实际发药数)
/// Creater:	ZhangDongmei
/// CreateDate:	2012-08-01
/// Table:DHC_InTrans
/// Input:库存项id,开始日期,截止日期,业务类型串
/// Output:		
/// Return：消耗量
ClassMethod CalcItmDispQty(Inci As %String, StartDate As %String, EndDate As %String, TypeStr As %String) As %Library.String
{
     n (Inci,StartDate,EndDate,TypeStr)
     s TotalQty=0
     s DispQty=0
     q:TypeStr="" 0
     s TypeCnt=$l(TypeStr,",")
     //f i=1:1:TypeCnt d
     //.s Type=$P(TypeStr,",",i)
     f DD=StartDate:1:EndDate d
     .s INTR=0
     .f  s INTR=$o(^DHCINTR(0,"INCI",Inci,DD,INTR)) q:INTR=""  d
     ..s type=$p(^DHCINTR(INTR),"^",1)
     ..q:$g(TypeStr)'[type ;非要求的业务类型时  Type
     ..s Uom=$p(^INCI(+Inci,1),"^",10)       ; basic uom of the stock itm
     ..s Inclb=$p(^DHCINTR(INTR),"^",7)
     ..s DispUom=$p(^DHCINTR(INTR),"^",10)  ; dispensing uom
     ..s Fac=##class(web.DHCST.Common.UtilCommon).UOMFac(DispUom,Uom)      ; factor
     ..s Dispqty=$p(^DHCINTR(INTR),"^",6)      ;dispensing qty
     ..;b ;1
     ..s Dispqty=Dispqty*Fac
     ..s TotalQty=TotalQty+Dispqty  ; total of qty in basic uom
     .
     q (-1)*TotalQty    ;r
}

/// Descript:统计全院消耗项目(根据全院消耗生成采购计划单)
/// Creater:	ZhangDongmei
/// CreateDate:	2012-08-01
/// Table:INC_ItmLoc,DHC_InTrans
/// Input:开始日期,截止日期,用药天数,类组id,业务类型串,采购科室id,人员id
/// Output:		
/// Return：w ##class(web.DHCST.INPurPlanAuxByConsume).QueryAllItmForPurch("2016-10-10^2016-10-10^111^1^P,F^102^590^1^^N^Y")
ClassMethod QueryAllItmForPurch(StrParam As %String) As %Library.String
{
	n (StrParam)
	s StartDate=$p(StrParam,"^",1)
	s EndDate=$p(StrParam,"^",2)
	s UseDays=$p(StrParam,"^",3)
	s StkGrpId=$p(StrParam,"^",4)
	s TypeStr=$p(StrParam,"^",5)
	s PurLocId=$p(StrParam,"^",6)
	s userId=$p(StrParam,"^",7)
	s zbflag=$p(StrParam,"^",8)
	s StkCatId=$p(StrParam,"^",9)
	s AllLocQtyFlag=$p(StrParam,"^",10)
	s IncludeZeroFlag=$p(StrParam,"^",11) //包含预计采购数为0
	s gGroupId=$p(StrParam,"^",12)
    q:StartDate="" ##class(web.DHCSTEXTCOMMON).GetNoJson()  
    q:EndDate="" ##class(web.DHCSTEXTCOMMON).GetNoJson()   
    q:+PurLocId=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()  
    s ReqLocId=""
    s HospId=""
	i PurLocId'="" s HospId=$p($g(^CTLOC(PurLocId)),"^",22)
    s:StkGrpId="" StkGrpId=##class(web.DHCST.Util.DrugUtil).GetUserCatGrpStr(userId,..sssCode())  //若类组为空，则传递User类组串
    s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
    s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
    s DspDays=EndDate-StartDate+1 			;days for dispensing
    s appName=##class(web.DHCST.INPurPlan).%GetParameter("AppName")
    s params=gGroupId_"^"_PurLocId_"^"_userId_"^"_HospId
	s getQtyWay = ##class(web.DHCST.Common.AppCommon).GetAppPropValue(appName, "GetQtyWay", params)
	s count=0
	s Start=0
	s Limit=9999
	s endpage=Start+Limit  //结束行
	s stpage=Start+1 //开始行
	s index=""
	s Pid=..NewPid()
	Set $ZT="ERRORQueryAllItmForPurch"
	s Inci=0
	f  s Inci=$o(^INCI(Inci)) q:(+Inci=0)  d
	.s StkGrpInfo=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(Inci)
	.s TmpStkGrpId=$p(StkGrpInfo,"^",5)
	.s StkType=$p(StkGrpInfo,"^",3)
	.q:(StkGrpId'="")&(("^"_StkGrpId_"^")'[("^"_TmpStkGrpId_"^"))
	.q:StkType'=..sssCode()
	.
	.s StkCatDesc=""
	.//库存分类
	.s StkCatIditm=$p(^INCI(Inci,2),"^",2)
    .s:StkCatIditm'="" StkCatDesc=$p(^INC("SC",StkCatIditm),"^",2)
	.q:(StkCatIditm'=StkCatId)&(StkCatId'="")
    .s incZBFlag=##Class(web.DHCST.INPurPlanAuxByLim).GetItmPbFlag(Inci)
    .q:(zbflag="2")&&(incZBFlag'=1) //招标
    .q:(zbflag="3")&&(incZBFlag=1)  //非招标
	.s BUomId=$p(^INCI(Inci,1),"^",10)
	.q:BUomId=""
	.s DispensQty=..CalcItmDispQty(Inci,StartDate,EndDate,TypeStr)
	.s StkQty=##class(web.DHCST.Common.DrugStkCommon).IL(Inci,PurLocId,+$h)
	.s TmpStkQty=StkQty
    .s HospStkQty=##class(web.DHCST.Common.DrugStkCommon).QtyHospInc(Inci,HospId,+$h)
    .i AllLocQtyFlag="Y" s TmpStkQty=HospStkQty
	.s PermQty=(DispensQty/DspDays)   ; average daily dispensing qty 
    .q:TmpStkQty'<(PermQty*UseDays)  ; 当前库存不小于平均消耗*天数ㄛ表示够用
 	.s PpQty=PermQty*UseDays-TmpStkQty    ;需采购数量
    .s PpQty=+PpQty
    .q:(IncludeZeroFlag'="Y")&&(PpQty'>0)
    .s InciCode=$p(^INCI(Inci,1),"^",1)
    .s InciDesc=$p(^INCI(Inci,1),"^",2)
    .s BUomId=$p(^INCI(Inci,1),"^",10)
    .q:BUomId="" 
    .s PurUomId=$p(^INCI(Inci,3),"^",6)
    .i PurUomId="" s PurUomId=BUomId
    .s Fac=##class(web.DHCST.Common.UtilCommon).UOMFac(PurUomId,BUomId)
    .s DispensQty=DispensQty/Fac			;大包装的消耗数
    .s StkQty=$fn((StkQty/Fac),"",0)			; stk log qty in PURCH UOM
    .s PurQty=$fn((PpQty/Fac),"",0)        ; purch qty 取整计算
    .s HospStkQty=$fn((HospStkQty/Fac),"",0)  //全院库存
 	.q:(IncludeZeroFlag'="Y")&&(PurQty'>0)
 	.i PurQty'>0 s PurQty=0
    .s PurUomDesc=$p(^CT("UOM",PurUomId),"^",2)  ;purch uom desc
    .s PackQty=""
    .s PackUomDesc=""
    .s PackPurFac=""
    .s ProLocQty=PurQty
    .i $d(^DHCITMINFO(0,"INCI",Inci)) d
    ..s ItmInfoId=$o(^DHCITMINFO(0,"INCI",Inci,0))
    ..s PackPurFac=$p(^DHCITMINFO(ItmInfoId),"^",52)
    ..s PackUomDr=$p(^DHCITMINFO(ItmInfoId),"^",51)
    ..i +PackPurFac>0 d
    ...s PackQty=PurQty/PackPurFac
    ...i (getQtyWay = "2") d
    ....s PurQty = $SYSTEM.SQL.FLOOR(PackQty) * PackPurFac  //向下取整后转换  
    ...i (getQtyWay = "3") d
    ....s PurQty = ##class(%SYSTEM.SQL).CEILING(PackQty) * PackPurFac  //向上取整后转换  by zhaoxinlong  2022.04.01
    ..i PackUomDr'="" s PackUomDesc=$p($g(^CT("UOM",PackUomDr)),"^",2)
    .i PackUomDesc'="" s PackUomDesc=PackPurFac_$p(PurUomDesc,"[",1)_"/"_PackUomDesc
    .s LastExpDate=##class(web.DHCST.Common.DrugStkCommon).GetLastExpDate(Inci,"")
    .s ItmInfo=##class(web.DHCST.INPurPlan).GetItmInfo(Inci,gGroupId_"^"_PurLocId_"^"_userId)
    .s VenId=$p(ItmInfo,"^",1)
    .s VenDesc=$p(ItmInfo,"^",2)
    .s ManfId=$p(ItmInfo,"^",3)
    .s ManfDesc=$p(ItmInfo,"^",4)
    .s CarrierId=$p(ItmInfo,"^",5)
    .s CarrierDesc=$p(ItmInfo,"^",6)
    .s ret=0
    .s ApcWarn = ##class(PHA.IN.Cert.Query).CheckExpDate(VenId,ManfId)
    .s Rp=$p(ItmInfo,"^",9)
    .s DispensQty=$fn(DispensQty,"",2) 
    .s count=count+1
    .;b ;1
    .s index=count  //排序
    .s Data1=Inci_"^"_InciCode_"^"_InciDesc_"^"_PurUomId_"^"_PurUomDesc_"^"_PurQty_"^"_VenId_"^"_VenDesc
    .s Data2=ManfId_"^"_ManfDesc_"^"_StkQty_"^"_Rp_"^"_CarrierId_"^"_CarrierDesc_"^"_DispensQty_"^"_BUomId_"^"_Fac_"^"_ApcWarn_"^"_StkCatDesc
    .s Data3=PackQty_"^"_PackUomDesc_"^"_HospStkQty_"^"_PackPurFac_"^"_LastExpDate_"^"_ReqLocId_"^"_ ProLocQty
    .s Data=Data1_"^"_Data2_"^"_Data3
    .s ^TMP("DHCST","INPurPlanAuxByConsume","QueryAllItmForPurch",Pid,"index",index)=Data
    s maxrow=index
	i endpage>maxrow s endpage=maxrow
    q:'$d(^TMP("DHCST","INPurPlanAuxByConsume","QueryAllItmForPurch",Pid)) ##class(web.DHCSTEXTCOMMON).GetNoJson()  
    s count=0
    s h=""
    f  s h=$o(^TMP("DHCST","INPurPlanAuxByConsume","QueryAllItmForPurch",Pid,"index",h)) q:h=""  d
    .s data=^TMP("DHCST","INPurPlanAuxByConsume","QueryAllItmForPurch",Pid,"index",h)
    .s Inci=$p(data,"^",1)
    .s InciCode=$p(data,"^",2)
    .s InciDesc=$p(data,"^",3)
    .s PurUomId=$p(data,"^",4)
    .s PurUomDesc=$p(data,"^",5)
    .s PurQty=$p(data,"^",6)
    .s VenId=$p(data,"^",7)
    .s VenDesc=$p(data,"^",8)
    .s ManfId=$p(data,"^",9)
    .s ManfDesc=$p(data,"^",10)
    .s StkQty=$p(data,"^",11)
    .s Rp=$p(data,"^",12)
    .s CarrierId=$p(data,"^",13)
    .s CarrierDesc=$p(data,"^",14)
    .s DispensQty=$p(data,"^",15)
    .s BUomId=$p(data,"^",16)
    .s ConFac=$p(data,"^",17)
    .s ApcWarn=$p(data,"^",18)
    .s StkCatDesc=$p(data,"^",19)
    .s PackQty=$p(data,"^",20)
    .s PackUomDesc=$p(data,"^",21)
    .s HospStkQty=$p(data,"^",22)
    .s PackPurFac=$p(data,"^",23)
    .s LastExpDate=$p(data,"^",24)
    .s ReqLocId=$p(data,"^",25)
    .s ProLocQty=$p(data,"^",26)
    .s count=count+1
    .s Inci=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("Inci",Inci)
    .s InciCode=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("InciCode",InciCode)
    .s InciDesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("InciDesc",InciDesc)
    .s PurUomId=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("PurUomId",PurUomId)
    .s PurUomDesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("PurUomDesc",PurUomDesc)
    .s PurQty=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("PurQty",PurQty)
    .s VenId=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("VenId",VenId)
    .s VenDesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("VenDesc",VenDesc)
    .s ManfId=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("ManfId",ManfId)
    .s ManfDesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("ManfDesc",ManfDesc)
    .s StkQty=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("StkQty",StkQty)
    .s Rp=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("Rp",Rp)
    .s CarrierId=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("CarrierId",CarrierId)
    .s CarrierDesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("CarrierDesc",CarrierDesc)
    .s DispensQty=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("DispensQty",DispensQty)
    .s BUomId=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("BUomId",BUomId)
    .s ConFac=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("ConFac",ConFac)
    .s ApcWarn=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("ApcWarn",ApcWarn)
    .s StkCatDesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("StkCatDesc",StkCatDesc)
    .s PackQty=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("PackQty",PackQty)
    .s PackUomDesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("PackUomDesc",PackUomDesc)
    .s HospStkQty=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("HospStkQty",HospStkQty)
    .s PackPurFac=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("PackPurFac",PackPurFac)
    .s LastExpDate=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("LastExpDate",LastExpDate)
    .s ReqLocId=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("ReqLocId",ReqLocId)
    .s ProLocQty=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("ProLocQty",ProLocQty)
	.s tmpstr=Inci_InciCode_InciDesc_PurUomId_PurUomDesc_PurQty_VenId_VenDesc_ManfId_ManfDesc_StkQty_Rp_CarrierId_CarrierDesc_DispensQty_BUomId_ConFac_ApcWarn_StkCatDesc_PackQty_PackUomDesc_HospStkQty_PackPurFac_LastExpDate_ReqLocId_ProLocQty
	.s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
    .i count=stpage w startString
    .i count<endpage w firstrow
    .i count=endpage w lastrow
	k ^TMP("DHCST","INPurPlanAuxByConsume","QueryAllItmForPurch",Pid)
	i count=0 q ##class(web.DHCSTEXTCOMMON).GetNoJson()  
	e  q ""
ERRORQueryAllItmForPurch
	k ^TMP("DHCST","INPurPlanAuxByConsume","QueryAllItmForPurch",Pid)    
	s Error=$$Error^DHCSTERROR()
	q "{Error:'"_Error_"'}"
}

ClassMethod NewPid() As %String
{
  q ##class(web.DHCSTKUTIL).NewPid($ClassName(),"ST")
}

/// Creator:bianshuai
/// CreateDate:2014-05-09
/// Descript:生成整个科室库存的采购计划单
/// w ##class(web.DHCST.INPurPlanAuxByConsume).INPurPlanAuxByLocStk("485^2014-04-23^2014-05-23^1^61^T,K^485^879^142^")
ClassMethod INPurPlanAuxByLocStk(StrParam) As %String
{
	n (StrParam)
	s LocId=+$p(StrParam,"^",1)
	s StartDate=$p(StrParam,"^",2)
	s EndDate=$p(StrParam,"^",3)
	s PurLocId=+$p(StrParam,"^",7)
	s StkGrpId=$p(StrParam,"^",5)
	s TypeStr=$p(StrParam,"^",6)
	s UseDays=$p(StrParam,"^",4)
	s userId=+$p(StrParam,"^",8)
	s GroupId=$p(StrParam,"^",9)
	s stkcat=$p(StrParam,"^",10)
	s PurParam=GroupId_"^"_LocId_"^"_userId_"^"_PurLocId
    ///准备采购计划数据
 	q:LocId=0 ""
    q:StartDate="" ""
    q:EndDate="" "" 
    s:StkGrpId="" StkGrpId=##class(web.DHCST.Util.DrugUtil).GetUserCatGrpStr(userId,..sssCode())  //若类组为空，则传递User类组串
    s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
    s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
    s DspDays=EndDate-StartDate+1 			;days for dispensing
    s pid=..NewPid()
    s $zt="ErrorINPurPlanAuxByLocStk"
    s pid=..CalcDispQty(LocId,StartDate,EndDate,StkGrpId,TypeStr,"N",stkcat,pid)  ; calculate the data
    s num=0
    s Inci=0
    f  s Inci=$o(^TMPINPURPLAN(pid,"DISP",Inci))  q:Inci=""  d
    .s DispensQty=^TMPINPURPLAN(pid,"DISP",Inci)
    .s PermQty=(DispensQty/DspDays)   ; 平均消耗量
    .i UseDays'="" s PpQty=PermQty*UseDays //总消耗量
    .s BUomId=$p(^INCI(Inci,1),"^",10)
    .q:BUomId="" 
    .s PurUomId=$p(^INCI(Inci,3),"^",6)
    .i PurUomId="" s PurUomId=BUomId
    .s Fac=##class(web.DHCST.Common.UtilCommon).UOMFac(PurUomId,BUomId)
    .s DispensQty=DispensQty/Fac			;大包装的消耗数
    .s PpQty=PpQty/Fac			;大包装的消耗数
    .s PurUomDesc=$p(^CT("UOM",PurUomId),"^",2)  ;purch uom desc
    .s ch=$o(^INCI("IL_LOC",LocId,Inci,""))
 	.s incil=Inci_"||"_ch
 	.s dhcincil=$o(^DHCINCIL(0,"INCIL",incil,""))
	.s planflag=""
	.s:dhcincil'="" planflag=$p(^DHCINCIL(dhcincil),"^",8)
	.q:planflag="Y"    //非招标退出  bianshuai 2014-04-24
 	.s StkQty=##class(web.DHCST.Common.DrugStkCommon).LocDayQtyUom(Inci,LocId,PurUomId,+$h) //科室库存
    .s ItmInfo=##class(web.DHCST.INPurPlan).GetItmInfo(Inci,PurParam)
    .s VenId=$p(ItmInfo,"^",1)
    .s ManfId=$p(ItmInfo,"^",3)
    .s CarrierId=$p(ItmInfo,"^",5)
    .s Rp=$p(ItmInfo,"^",9)
    .s DispensQty=$fn(DispensQty,"",2)
    .s PpQty=$fn((PpQty-StkQty),"",2)  //建议采购量=消耗总量-当前库存
    .i PpQty["." s PpQty=+$p(PpQty,".",1)+1 //向上取整
    .q:PpQty<=0
    .s num=num+1
    .s TempStr=Inci_"^"_PpQty_"^"_PurUomId_"^"_VenId_"^"_Rp_"^"_ManfId_"^"_CarrierId_"^"_LocId_"^"_PpQty
    .s ^TMP("DHCST","web.DHCST.INPurPlanAuxByConsume","INPurPlanAuxByLocStk",pid,num)=TempStr
    q:num=0 "-1"
    ///生成计划单
    tstart
    s $ZT="Error^DHCSTERROR"    //增加错误处理
    s Err=0
    s PurId=##Class(web.DHCST.INPurPlan).Insert(PurLocId,userId,StkGrpId)     //保存采购计划主表
    q:PurId<0 PurId
    s index=""
    f  s index=$o(^TMP("DHCST","web.DHCST.INPurPlanAuxByConsume","INPurPlanAuxByLocStk",pid,index)) q:(index="")||(Err=1)  d
    .s detail=$g(^TMP("DHCST","web.DHCST.INPurPlanAuxByConsume","INPurPlanAuxByLocStk",pid,index))
    .s ret=##Class(web.DHCST.INPurPlanItm).Insert(PurId,detail)   //插入采购计划子表
    .//w !,"ret"_PurId
    .i +ret'>0  s Err=1
    tcommit    //提交事务
    k ^TMP("DHCST","web.DHCST.INPurPlanAuxByConsume","INPurPlanAuxByLocStk",pid)
    q:Err'=0 "-2"
	q PurId
ErrorINPurPlanAuxByLocStk
	 k ^TMP("DHCST","web.DHCST.INPurPlanAuxByConsume","INPurPlanAuxByLocStk",pid)
    q "{results:0,rows:[]}"
}

/// creator:yunhaibao
/// createdate:20161012
/// description:科室库存项日期范围内是否发生过指定类型业务
/// output:Y-发生过
/// w ##class(web.DHCST.INPurPlanAuxByConsume).IfHappendByIncilTypes("9243||1",64203,64203,"T,K")
ClassMethod IfHappendByIncilTypes(incil, startdate, enddate, intrtypes)
{
	n (incil,intrtypes,startdate,enddate)
	s happened=""
	s typei=""
	f typei=1:1:$l(intrtypes,",") q:happened="Y"  d
	.s intrtype=$p(intrtypes,",",typei)
	.q:intrtype=""
	.i $d(^DHCINTR(0,"ILTYPEDATE",incil,intrtype,startdate)) s happened="Y"
	.s middate=$o(^DHCINTR(0,"ILTYPEDATE",incil,intrtype,startdate))
	.q:middate=""
	.i middate<=enddate s happened="Y"
	.q:happened'=""
	q happened
}

}
