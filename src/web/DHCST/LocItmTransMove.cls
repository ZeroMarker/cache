Import sqluser

/// Descript:台帐查询
/// Creater:	ZhangDongmei
/// CreateDate:	2012-08-09
Class web.DHCST.LocItmTransMove Extends (%RegisteredObject, StkTypeG) [ Not ProcedureBlock ]
{

/// Descript:	查询药品库存
/// Creater:	ZhangDongmei
/// CreateDate:2012-08-09
/// Table:INC_ItmLoc,DHC_InTrans
/// Input:开始日期，截止日期,统计科室id,
/// 类组id^库存分类id^库存项id^药学大类id^管制分类^是否管理药
/// ^统计标志(0:全部;1:零消耗;2:非零消耗)^多级药学分类^业务类型(!!分隔)
/// Output:入库明细
/// Return：INCIL^库存项代码^库存项名称^库存分类^入库单位^基本单位^期初数量(基本单位)
/// ^期初数量(带单位)^期初金额(进价)^期初金额(售价)^期末数量(基本单位)^期末数量(带单位)
/// ^期末金额(进价)^期末金额(售价)
/// 
/// Others:目前台帐查询用
/// w ##class(web.DHCST.LocItmTransMove).LocItmStkMoveSum("0","30","14/11/2017","14/11/2017","102","1^^858^^^^0^^",590)	
ClassMethod LocItmStkMoveSum(Start, Limit, StartDate, EndDate, LocId, Others, User = "", Sort = "", Dir = "") As %Library.String
{

	n (Start,Limit,StartDate, EndDate, LocId, Others,User,Sort,Dir,%session)
	s User=$g(User)
	q:StartDate="" ##class(web.DHCSTEXTCOMMON).GetNoJson()
	q:EndDate="" ##class(web.DHCSTEXTCOMMON).GetNoJson()
	q:LocId="" ##class(web.DHCSTEXTCOMMON).GetNoJson()
	i StartDate'="" s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	i EndDate'="" s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	s pid=..NewPid()
	s $zt="ErrorLocItmStkMoveSum"
	s StkGrpId=$p(Others,"^",1)
 	s:StkGrpId="" StkGrpId=##class(web.DHCST.Util.DrugUtil).GetUserCatGrpStrNew(User,..sssCode())  //若类组为空，则传递User类组串
	s StkCatId=$p(Others,"^",2)
	s InciRowid=$p(Others,"^",3)
	s PhcCatId=$p(Others,"^",4)
	s PoisonCat=$p(Others,"^",5)
	s ManageFlag=$p(Others,"^",6)   // 是否管理药
	s StateFlag=$p(Others,"^",7)	// 统计标志
	s PhcCatAll=$p(Others,"^",8) 	// 多级药学分类
	s TransTypeStr=$p(Others,"^",8) // 业务类型
	s HospId=$p(^CTLOC(LocId),"^",22)
	s Title="INCIL^InciCode^InciDesc^StkCat^PurUom^BUom^BegQty^BegQtyUom^BegRpAmt^BegSpAmt^EndQty^EndQtyUom^EndRpAmt^EndSpAmt^PlusQty^MinusQty^InsuCode^InsuDesc"
	// 排序
	s sortNum=$lf($lfs(Title,"^"),Sort)
	s sortAsNum=""
	i (Sort["Qty")||(Sort["Amt") s sortAsNum="Y"
	s Num=0
	s ChlSub=0
	s Inci=""
	f  s Inci=$o(^INCI("IL_LOC",LocId,Inci)) q:Inci=""  d
	.s ChlSub=$o(^INCI("IL_LOC",LocId,Inci,0)) 
	.q:ChlSub=""  
	.q:(InciRowid'="")&(InciRowid'=Inci)
	.s GrpInfo=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(Inci)
	.s GrpId=$p(GrpInfo,"^",5)	
	.s GrpType=$p(GrpInfo,"^",3)
	.q:GrpType'=..sssCode()						
	.q:(StkGrpId'="")&(("^"_StkGrpId_"^")'[("^"_GrpId_"^"))  //按类组过滤
	.s IncscDr=$p(^INCI(Inci,2),"^",2)
	.q:(StkCatId'="")&(IncscDr'=StkCatId)				//库存分类
	.s PhaCatAllDesc=""
	.s PhaCatAllstr=##class(web.DHCST.Common.DrugInfoCommon).GetPhaCatAll(Inci)
	.s PhaCatAlls=$p(PhaCatAllstr,"^",1)
	.s PhaCatAllDesc=$p(PhaCatAllstr,"^",2)
	.s retflag=##class(web.DHCST.Common.DrugInfoCommon).CheckNewCatId(PhcCatAll,PhaCatAlls)
	.q:(PhcCatAll'="")&(retflag=0) //add wyx 2014-12-08 药学多级分类
	.s ManFlag=##class(web.DHCST.Common.DrugStkCommon).GetManageflag(LocId,Inci)
	.q:(ManageFlag'="")&(ManFlag'=ManageFlag)			//是否管理药
	.s PoisonCatStr=##class(web.DHCST.Common.DrugInfoCommon).GetMangerDrug(Inci)
	.s TmpPoisonCat=$p(PoisonCatStr,"^",2)
	.q:(PoisonCat'="")&(TmpPoisonCat'=PoisonCat)        //管制分类
	.s INCIL=Inci_"||"_ChlSub
	.s Flag=..CheckTrans(INCIL,StartDate,EndDate)   
	.q:(StateFlag=1)&(Flag=1)					//只统计零消耗
	.q:(StateFlag=2)&(Flag'=1)					//只统计非零消耗
	.s InciCode=$p(^INCI(Inci,1),"^",1)
 	.s InciDesc=$p(^INCI(Inci,1),"^",2) 
 	.s BUomId=$p(^INCI(Inci,1),"^",10)
    .s:BUomId'="" BUomDesc=$p(^CT("UOM",BUomId),"^",2)				;基本单位
 	.s PurUomId=$p(^INCI(Inci,3),"^",6)
 	.s:PurUomId'="" PurUomDesc=$p(^CT("UOM",PurUomId),"^",2)	     ;入库单位
 	.s:IncscDr'="" StkCatDesc=$p(^INC("SC",IncscDr),"^",2)
 	.s StartDateTmp=StartDate
 	.s StartDate=StartDate-1
 	.s BegQty=##class(web.DHCST.Common.DrugStkCommon).LocDayQtyUom(Inci,LocId,BUomId,StartDate)  ;期初库存(基本数量)
 	.s EndQty=##class(web.DHCST.Common.DrugStkCommon).LocDayQtyUom(Inci,LocId,BUomId,EndDate)	;期末库存(基本数量)
 	.s BegQtyUom=##class(web.DHCST.Common.DrugStkCommon).QtyWithUom(Inci,BegQty)
 	.s EndQtyUom=##class(web.DHCST.Common.DrugStkCommon).QtyWithUom(Inci,EndQty)
 	.s BegSpAmt=##class(web.DHCST.Common.DrugStkCommon).GetSpAmt(INCIL,StartDate)
 	.s EndSpAmt=##class(web.DHCST.Common.DrugStkCommon).GetSpAmt(INCIL,EndDate)
 	.s BegRpAmt=##class(web.DHCST.Common.DrugStkCommon).GetRpAmt(INCIL,StartDate)
 	.s EndRpAmt=##class(web.DHCST.Common.DrugStkCommon).GetRpAmt(INCIL,EndDate)
 	.s StartDate=StartDateTmp
 	.s PlusMinusInfo=..GetPlusMinusInfo(INCIL,StartDate,EndDate)  ///计算增加与减少数量与金额
 	.s PlusQty=+$p(PlusMinusInfo,"^",1)
 	.s MinusQty=+$p(PlusMinusInfo,"^",2)
 	.s InsuCode = ##class(PHA.COM.Drug).GetInsuCode(Inci, HospId)
 	.s InsuDesc = ##class(PHA.COM.Drug).GetInsuDesc(Inci, HospId)
 	.s Data1=INCIL_"^"_InciCode_"^"_InciDesc_"^"_$g(StkCatDesc)_"^"_$g(PurUomDesc)_"^"_$g(BUomDesc)
 	.s Data2=BegQty_"^"_BegQtyUom_"^"_BegRpAmt_"^"_BegSpAmt_"^"_EndQty_"^"_EndQtyUom_"^"_EndRpAmt_"^"_EndSpAmt_"^"_PlusQty_"^"_MinusQty_"^"_InsuCode_"^"_InsuDesc
 	.s Data=Data1_"^"_Data2
 	.i +sortNum=0 s index="1" 
 	.e  d
 	..s index=$p(Data,"^",sortNum)
 	..i sortAsNum="Y" s index=+index
 	.i index="" s index="ZZZZZZ"
 	.s Num=Num+1
 	.s ^TMP("DHCST","LocItmTransMove","LocItmStkMoveSum",pid,1,index,Num)=Data
 	q:Num=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
	s End=Start+Limit
	s Start=Start+1
	s count=0
	i $ZCVT(Dir,"U")="DESC" s orderflag=-1 //正序
	e  s orderflag=1 //倒序
	s retstring=""
	s outputi=""
	f  s outputi=$o(^TMP("DHCST","LocItmTransMove","LocItmStkMoveSum",pid,outputi)) q:outputi=""  d
	.s outputj=""
	.f  s outputj=$o(^TMP("DHCST","LocItmTransMove","LocItmStkMoveSum",pid,outputi,outputj),orderflag) q:outputj=""  d
	..s outputk=""
	..f  s outputk=$o(^TMP("DHCST","LocItmTransMove","LocItmStkMoveSum",pid,outputi,outputj,outputk),orderflag) q:outputk=""  d
	...s outputdata=^TMP("DHCST","LocItmTransMove","LocItmStkMoveSum",pid,outputi,outputj,outputk)
	...s count=count+1
	...q:count<Start
	...q:count>End
	...i count=Start d
	....w ##class(web.DHCSTEXTCOMMON).GetJsonStartString(Num)
	....s retstring=##class(web.DHCST.Common.UtilCommon).GetJsonStr(outputdata,Title)
	....w retstring
	...e  d
	....s retstring=##class(web.DHCST.Common.UtilCommon).GetJsonStr(outputdata,Title)
	....w ","_retstring
	i retstring'="" w "]}"  //如果不报错,至少有一条记录
	e  w ##class(web.DHCSTEXTCOMMON).GetNoJson()
	k ^TMP("DHCST","LocItmTransMove","LocItmStkMoveSum",pid)
 	q ""
ErrorLocItmStkMoveSum
 k ^TMP("DHCST","LocItmTransMove","LocItmStkMoveSum",pid)
 s Error=$$Error^DHCSTERROR()
 q "{Error:'"_Error_"'}"
}

/// Descript:检测某科室库存项在指定的日期范围内是否发生过业务
/// Creater:	ZhangDongmei
/// CreateDate:	2012-12-24
/// Table:DHC_InTrans
/// Input:科室库存项id,开始日期，截止日期
/// Output:
/// Return：0：未发生过业务；1:发生过业务
/// 
ClassMethod CheckTrans(Incil, SD, ED)
{
	n (Incil,SD,ED)
	s Flag=0   ;零消耗
	f DD=SD:1:ED q:Flag=1  d
	.s TmpType=""
	.f  s TmpType=$o(^DHCINTR(0,"ILTYPEDATE",Incil,TmpType)) q:(TmpType="")!(Flag=1)  d
	..s TrId=""
	..f  s TrId=$o(^DHCINTR(0,"ILTYPEDATE",Incil,TmpType,DD,TrId)) q:(TrId="")!(Flag=1)  d
	...s Flag=1
	..
	.
	q Flag
}

/// Descript:查询台帐明细
/// Creater:	ZhangDongmei
/// CreateDate:	2012-02-16
/// Table:DHC_InTrans
/// Input:开始行,每页记录数,开始日期，截止日期,INC_ItmLoc表id,业务类型(P!!Y!!F)
/// Output:
/// Return：业务日期^批号^单位^售价^进价^结余数量(基本单位)^结余数量(带单位)^增减数量(基本单位)
/// ^增减数量(带单位)^增减金额(进价)^增减金额(售价)^处理号^处理人^摘要
/// ^期末金额(进价)^期末金额(售价)^经营企业^生产企业^操作人
/// Others:目前台帐查询用,yunhaibao20151119,修改为不超长形式	
/// w ##class(web.DHCST.LocItmTransMove).LocItmStkMoveDetail("0","20","","","2018-11-21","2018-11-30","4588||2","","1")
ClassMethod LocItmStkMoveDetail(Start, Limit, Sort, Dir, StartDate, EndDate, INCIL, TransTypeStr, RetAspFlag) As %Library.String
{
	n (Start,Limit,Sort,Dir,StartDate, EndDate, INCIL,TransTypeStr,RetAspFlag)
	q:StartDate="" ##class(web.DHCSTEXTCOMMON).GetNoJson()
	q:EndDate="" ##class(web.DHCSTEXTCOMMON).GetNoJson()
	q:INCIL="" ##class(web.DHCSTEXTCOMMON).GetNoJson()
	s Dir=$$ALPHAUP^SSUTIL4(Dir)
    s:(Dir="")&(Dir'="ASC")&(Dir'="DESC") Dir="DESC"
	i StartDate'="" s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	i EndDate'="" s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	s pid=..NewPid()
	s $zt="ErrorLocItmStkMoveDetail"
	k ^||TMP("DHCST","LocItmTransMove","LocItmStkMoveDetail",pid)
	s Inci=+INCIL
	s IL=$p(INCIL,"||",2)
	s LocId=$p(^INCI(Inci,"IL",IL),"^",1)
	s HospId=$p(^CTLOC(LocId),"^",22)
	s BUomId=$p(^INCI(Inci,1),"^",10)
	s PurUomId=$p(^INCI(Inci,3),"^",6)
	s:PurUomId'="" PurUomDesc=$p(^CT("UOM",PurUomId),"^",2)
	s Factor=##class(web.DHCST.Common.UtilCommon).UOMFac(PurUomId,BUomId)
	;计算开始日期前一天的结余数量
	s TmpDate=StartDate-1
	s BegQty=##class(web.DHCST.Common.DrugStkCommon).LocDayQtyUom(Inci,LocId,BUomId,TmpDate)  ;期初库存(基本数量)
	s BegQtyUom=##class(web.DHCST.Common.DrugStkCommon).QtyWithUom(Inci,BegQty)
	s BegSpAmt=##class(web.DHCST.Common.DrugStkCommon).GetSpAmt(INCIL,TmpDate)
	s BegRpAmt=##class(web.DHCST.Common.DrugStkCommon).GetRpAmt(INCIL,TmpDate)
	s firstTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(1,"ST")
	s Data="QS^"_##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(StartDate,"ST")_"*"_firstTime_"^^^^^"_BegQty_"^"_BegQtyUom_"^^^^^^^^"_BegRpAmt_"^"_BegSpAmt_"^^^^"
	s Num=1
	s index="0"  
	s ^||TMP("DHCST","LocItmTransMove","LocItmStkMoveDetail",pid,0,index,Num)=Data
 	s EndQty=BegQty
 	s EndSpAmt=BegSpAmt
 	s EndRpAmt=BegRpAmt
	s BegQtyTmp=BegQty //由于INTR_StkQty（结余库存量）和INTR_LbQty（结余库存量(批次)）字段没有在门诊住院发药表里插入，修改此处已显示结余数量 add wyx 2013-09-25
	f Date=StartDate:1:EndDate d
 	.s TrId="" 
 	.f  s TrId=$o(^DHCINTR(0,"INCI",Inci,Date,TrId)) q:TrId=""  d
 	..q:'$d(^DHCINTR(TrId))
 	..s Inclb=$p(^DHCINTR(TrId),"^",7)
 	..q:Inclb=""
 	..s TmpIncil=$p(Inclb,"||",1,2)
 	..q:INCIL'=TmpIncil           ;非统计科室库存
 	..s Incib=$p(^INCI(Inci,"IL",$p(Inclb,"||",2),"LB",$p(Inclb,"||",3)),"^",1) ;批次指针
 	..s BatStr=""
 	..i Incib'=""  d
 	...s BatNo=$p(^INCI(+Incib,"IB",$p(Incib,"||",2)),"^",1)
 	...s ExpDate=$p(^INCI(+Incib,"IB",$p(Incib,"||",2)),"^",2)
 	...s:ExpDate'="" ExpDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(ExpDate,"ST")
 	...s BatStr=BatNo_"~"_ExpDate
 	..s TrType=$p(^DHCINTR(TrId),"^",1)                                         ;交易类型
 	..q:(TransTypeStr'="")&&((","_TransTypeStr_",")'[(","_TrType_","))
 	..s TrPointer=$p(^DHCINTR(TrId),"^",9)                                         ;交易指针
 	..s TrUom=$p(^DHCINTR(TrId),"^",10)                                        ;交易单位
 	..s TrQty=$p(^DHCINTR(TrId),"^",6)                                         ;交易数量
 	..s TrNo=$p(^DHCINTR(TrId),"^",13)                                        ;交易号
 	..s TrUser=$p(^DHCINTR(TrId),"^",11)                                     ;交易人
 	..s OperateUser=""
 	..s:TrUser'="" OperateUser=$p($g(^SSU("SSUSR",TrUser)),"^",2)  
 	..s TrTime=$p(^DHCINTR(TrId),"^",3)
 	..s TrSp=$p(^DHCINTR(TrId),"^",14)        ;业务发生的售价
 	..s TrRp=$p(^DHCINTR(TrId),"^",16)        ;业务发生的进价
 	..s TrSpAmt=$p(^DHCINTR(TrId),"^",8)        ;售价金额
 	..s TrRpAmt=$p(^DHCINTR(TrId),"^",17)        ;进价金额
 	..//wyx 2013-10-28
    ..//i TrRp="" s TrRp=##class(web.DHCST.Common.PriceCommon).GetClbRp(Inclb,TrUom) 
    ..i TrRp="" s TrRp=##class(web.DHCST.Common.PriceCommon).GetClbRp(Inclb,TrUom,HospId,"G",Date,"") 
    ..i TrRpAmt="" s TrRpAmt=TrRp*TrQty
    ..//wyx 2013-10-28
 	..s StkQty=$p(^DHCINTR(TrId),"^",18)        ;结余库存量
 	..s StkLbQty=$p(^DHCINTR(TrId),"^",19)        ;结余库存量(批次)
 	..s FacTr=##class(web.DHCST.Common.UtilCommon).UOMFac(TrUom,BUomId)
 	..s TrQtyB=TrQty*FacTr				;基本单位数量
 	..s BUomSp=TrSp/FacTr				;基本单位售价
 	..s PurUomSp=BUomSp*Factor			;包装单位售价
 	..//s SpAmt=BUomSp*TrQtyB			;售价金额
 	..s BUomRp=TrRp/FacTr    //##class(web.DHCST.Common.PriceCommon).GetClbRp(Inclb,BUomId) ;批次进价(基本单位)
 	..s PurUomRp=BUomRp*Factor            ;批次进价(包装单位)
 	..i TrUom=PurUomId d
 	...s PurUomRp=TrRp
 	...s PurUomSp=TrSp
    ..s PurUomRp=##class(web.DHCST.Common.AppCommon).FormatRp(PurUomRp,HospId,1,"G")
    ..s PurUomSp=##class(web.DHCST.Common.AppCommon).FormatSp(PurUomSp,HospId,1,"G")
 	..s Manf=##class(web.DHCST.Common.DrugStkCommon).GetManfInfoByInclb(Inclb)
 	..i Manf'=""  s Manf=$p(Manf,"^",2)
 	..s EndQty=StkQty  //EndQty+TrQtyB         ;本条记录的结余库存
	..s EndQty=BegQtyTmp-((-1)*TrQtyB) //由于INTR_StkQty（结余库存量）和INTR_LbQty（结余库存量(批次)）字段没有在门诊住院发药表里插入，修改此处已显示结余数量 add wyx 2013-09-25
 	..s BegQtyTmp=BegQtyTmp-((-1)*TrQtyB)
 	..s EndQtyUom=##class(web.DHCST.Common.DrugStkCommon).QtyWithUom(Inci,EndQty)
 	..s TrQtyUom=##class(web.DHCST.Common.DrugStkCommon).QtyWithUom(Inci,TrQtyB)
 	..s EndSpAmt=EndSpAmt+TrSpAmt       ;结余金额(售价)
 	..s EndRpAmt=EndRpAmt+TrRpAmt		  ;结余金额(进价)
 	..s VendorInfo=##class(web.DHCST.Common.DrugStkCommon).GetInclbVend(Inclb,Date)  ;该批次对应的最后一次入库的经营企业
 	..s Vendor=$p(VendorInfo,"^",2)
 	..s TrAdm="BX"
 	..i TrType="P" d
 	...s TrMsg="住院发药"        ;摘要
 	...s oeori=..GetPHPORI(TrPointer)
 	...s OrdInfo=..GetOrdInfo(oeori)
 	...s TrAdm=$p(OrdInfo,"^",1)
 	...s TrNo=$p(OrdInfo,"^",2)
 	..
 	..i TrType="Y" d
 	...s TrMsg="住院退药"       			;摘要
 	...s oeori=..GetPHYORI(TrPointer)
 	...s OrdInfo=..GetOrdInfo(oeori)
 	...s TrAdm=$p(OrdInfo,"^",1)
 	...s TrNo=$p(OrdInfo,"^",2)
 	...
 	..
 	..i TrType="F" d
 	...s TrMsg="门诊发药"       			;摘要
 	...s oeori=..GetORI(TrPointer)
 	...s OrdInfo=..GetOrdInfo(oeori)
 	...s TrAdm=$p(OrdInfo,"^",1)
 	...s TrNo=$p(OrdInfo,"^",2)
 	...
 	..
 	..i TrType="H" d
 	...s TrMsg="门诊退药"
	...s oeori=..GetRetORI(TrPointer)
	...s OrdInfo=..GetOrdInfo(oeori)
	...s TrAdm=$p(OrdInfo,"^",1)
 	...s TrNo=$p(OrdInfo,"^",2)
 	...
 	..i TrType="HC" d
 	...s TrMsg="门诊撤消退药"
	...s oeori=..GetRetORI(TrPointer)
	...s OrdInfo=..GetOrdInfo(oeori)
	...s TrAdm=$p(OrdInfo,"^",1)
 	...s TrNo=$p(OrdInfo,"^",2)
 	..
	..i TrType="S" d
 	...s TrMsg="门诊非正常发药"
 	...q:'$d(^DHCINAD($p(TrPointer,"||",1)))
 	...q:'$d(^SSU("SSUSR",$p(^DHCINAD($p(TrPointer,"||",1)),"^",3)))
 	...s TrAdm=$p(^SSU("SSUSR",$p(^DHCINAD($p(TrPointer,"||",1)),"^",3)),"^",2)
 	...
 	..
	..i TrType="Z" d
 	...s TrMsg="门诊非正常退药"
 	...q:'$d(^DHCINAD($p(TrPointer,"||",1)))
 	...q:'$d(^SSU("SSUSR",$p(^DHCINAD($p(TrPointer,"||",1)),"^",3)))
 	...s TrAdm=$p(^SSU("SSUSR",$p(^DHCINAD($p(TrPointer,"||",1)),"^",3)),"^",2)
 	...
 	..
 	..i TrType="K" d
 	...s TrMsg="转移入库" 
 	...q:'$d(^DHCINIT($p(TrPointer,"||",1)))
 	...q:$p(^DHCINIT($p(TrPointer,"||",1)),"^",5)=""
 	...s TrAdm=$p(^CTLOC($p(^DHCINIT($p(TrPointer,"||",1)),"^",5)),"^",2)   ;出库科室
 	...s status=$p(^DHCINIT($p(TrPointer,"||",1)),"^",14)
 	...i (status=30)||(status=40) s TrMsg="转移入库(拒绝接收)"
 	...
 	..
 	..i (TrType="T")!(TrType="I") d
 	...s TrMsg="转移出库"
 	...q:'$d(^DHCINIT($p(TrPointer,"||",1)))
 	...q:$p(^DHCINIT($p(TrPointer,"||",1)),"^",6)=""
 	...s TrAdm=$p(^CTLOC($p(^DHCINIT($p(TrPointer,"||",1)),"^",6)),"^",2)    ;转入科室
 	...
 	..
 	..i TrType="G" d
 	...s TrMsg="入库"
 	...q:'$d(^DHCINGR($p(TrPointer,"||",1)))
 	...q:$p(^DHCINGR($p(TrPointer,"||",1)),"^",8)=""
 	...;q:'$d(^DHCINGR("APCVM",$p(^DHCINGR($p(TrPointer,"||",1)),"^",8)))
 	...s TrAdm=$p(^SSU("SSUSR",$p(^DHCINGR($p(TrPointer,"||",1)),"^",8)),"^",2) 
 	...
 	..
 	..i (TrType="D")!(TrType="C") d
 	...s TrMsg="库存报损"
 	...s INSPId=$p(TrPointer,"||",1)
 	...q:'$d(^DHCINSP(INSPId))
 	...q:$p(^DHCINSP(INSPId),"^",6)=""
 	...s TrAdm=$p(^SSU("SSUSR",$p(^DHCINSP(INSPId),"^",6)),"^",2)
 	...
 	..
 	..i TrType="A" d
 	...s TrMsg="库存调整"
 	...q:'$d(^DHCINAD($p(TrPointer,"||",1)))
 	...q:$p(^DHCINAD($p(TrPointer,"||",1)),"^",3)=""
 	...i $p(^DHCINAD($p(TrPointer,"||",1)),"^",6)="" s TrMsg="盘点调整" 
 	...s TrAdm=$p(^SSU("SSUSR",$p(^DHCINAD($p(TrPointer,"||",1)),"^",3)),"^",2)
 	...
 	..
 	..i TrType="R" d
 	...s TrMsg="退货"
 	...s INGRT=$p(TrPointer,"||",1)
 	...q:INGRT=""
 	...q:'$d(^INGRT(INGRT))
 	...q:$p(^INGRT(INGRT),"^",5)=""
 	...s TrAdm=$p($g(^SSU("SSUSR",$p(^INGRT(INGRT),"^",5))),"^",2)
 	...
 	..
 	..i TrType="M" d
 	...s TrMsg="制剂生成"
 	...q:'$d(^DHCINMAN(TrPointer))
 	...s Manuser=$p(^DHCINMAN(TrPointer),"^",23)
 	...q:Manuser=""
 	...s TrAdm=$p(^SSU("SSUSR",Manuser),"^",2)
 	...
 	..
 	..i TrType="X" d
 	...s TrMsg="制剂消耗"
 	...q:'$d(^DHCINMAN(+TrPointer)) 
 	...s Manuser=$p(^DHCINMAN(+TrPointer),"^",23)
 	...q:Manuser=""
 	...s TrAdm=$p(^SSU("SSUSR",Manuser),"^",2)
 	..s TypeFlag=0
 	..s Data1=TrId_"^"_##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(Date,"ST")_"*"_##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(TrTime,"ST")_"^"_$g(BatStr)_"^"_$g(PurUomDesc)_"^"_PurUomSp_"^"_PurUomRp
 	..s Data2=EndQty_"^"_EndQtyUom_"^"_TrQtyB_"^"_TrQtyUom_"^"_TrRpAmt_"^"_TrSpAmt_"^"_TrNo
 	..s Data3=TrAdm_"^"_TrMsg_"^"_EndRpAmt_"^"_EndSpAmt_"^"_Vendor_"^"_Manf_"^"_$g(OperateUser)_"^"_TypeFlag
 	..s Data=Data1_"^"_Data2_"^"_Data3
 	..s Num=Num+1
 	..s index=1  //排序用
 	..i Sort="TrId" s index=TrId
 	..e  i Sort="TrDate" s index=$zd(Date,3)_"*"_$zt(TrTime) //排序不格式化
 	..e  i Sort="TrDate" s index=$zd(Date,3)_"*"_$zt(TrTime)
 	..e  i Sort="BatExp" s index=BatStr
 	..e  i Sort="Sp" s index=+PurUomSp
 	..e  i Sort="Rp" s index=+PurUomRp
 	..e  i Sort="EndQty" s index=+EndQty
 	..e  i Sort="TrQty" s index=+TrQtyB
 	..e  i Sort="SpAmt" s index=+TrSpAmt
 	..e  i Sort="RpAmt" s index=+TrRpAmt
 	..e  i Sort="TrNo" s index=TrNo
 	..e  i Sort="TrAdm" s index=TrAdm
 	..e  i Sort="TrMsgTrMsg" s index=TrMsg
 	..e  i Sort="OperateUser" s index=OperateUser
 	..i index="" s index=1
 	..s ^||TMP("DHCST","LocItmTransMove","LocItmStkMoveDetail",pid,1,index,Num)=Data
 	..q:RetAspFlag'=1
 	..s RetStr=..GetRetAspDetail(TrType,TrPointer)
 	..q:RetStr=""
 	..s RpAmt=$p(RetStr,"^",1)
 	..s SpAmt=$p(RetStr,"^",2)
 	..s EndRpAmt=EndRpAmt+RpAmt
 	..s EndSpAmt=EndSpAmt+SpAmt
 	..s PurUomRp=##class(web.DHCST.Common.PriceCommon).GetClbRp(Inclb,PurUomId,HospId,"G",Date,"") 
 	..s PurUomSp=##class(web.DHCST.Common.PriceCommon).GetPriceElse(Inclb,Date,PurUomId,HospId,"G","") 
 	..s $p(Data,"^",1)="RetAsp"_$p(Data,"^",1)
 	..s $p(Data,"^",5)=PurUomSp
 	..s $p(Data,"^",6)=PurUomRp
 	..s $p(Data,"^",10)=""
 	..s $p(Data,"^",11)=RpAmt
 	..s $p(Data,"^",12)=SpAmt
 	..s $p(Data,"^",15)=TrMsg_"损益"
 	..s $p(Data,"^",16)=EndRpAmt
 	..s $p(Data,"^",17)=EndSpAmt
 	..s $p(Data,"^",21)=1
 	..s Num=Num+1
 	..s ^||TMP("DHCST","LocItmTransMove","LocItmStkMoveDetail",pid,1,index,Num)=Data
 	q:Num=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
	s End=Start+Limit
	s Start=Start+1
	s count = 0
	s Title1="TrId^TrDate^BatExp^PurUom^Sp^Rp^EndQty^EndQtyUom^TrQty^TrQtyUom^RpAmt"
 	s Title2="SpAmt^TrNo^TrAdm^TrMsg^EndRpAmt^EndSpAmt^Vendor^Manf^OperateUser^TypeFlag"
 	s Title=Title1_"^"_Title2
	i Dir="DESC" s orderflag=-1 
	e  s orderflag=1 
	s retstring=""
	s outputi=""
	f  s outputi=$o(^||TMP("DHCST","LocItmTransMove","LocItmStkMoveDetail",pid,outputi)) q:outputi=""  d
	.s outputj=""
	.f  s outputj=$o(^||TMP("DHCST","LocItmTransMove","LocItmStkMoveDetail",pid,outputi,outputj),orderflag) q:outputj=""  d
	..s outputk=""
	..f  s outputk=$o(^||TMP("DHCST","LocItmTransMove","LocItmStkMoveDetail",pid,outputi,outputj,outputk),orderflag) q:outputk=""  d
	...s outputdata=^||TMP("DHCST","LocItmTransMove","LocItmStkMoveDetail",pid,outputi,outputj,outputk)
	...s count=count+1
	...q:count<Start
	...q:count>End
	...i count=Start d
	....w ##class(web.DHCSTEXTCOMMON).GetJsonStartString(Num)
	....s retstring=##class(web.DHCST.Common.UtilCommon).GetJsonStr(outputdata,Title)
	....w retstring
	...e  d
	....s retstring=##class(web.DHCST.Common.UtilCommon).GetJsonStr(outputdata,Title)
	....w ","_retstring
	i retstring'="" w "]}"  //如果不报错,至少有一条记录
	e  w ##class(web.DHCSTEXTCOMMON).GetNoJson()
	k ^||TMP("DHCST","LocItmTransMove","LocItmStkMoveDetail",pid)
	q ""
 	
ErrorLocItmStkMoveDetail  //write形式弊端,错误报不出去,但临时global一定在报错时k掉
 k ^||TMP("DHCST","LocItmTransMove","LocItmStkMoveDetail",pid)
 s Error=$$Error^DHCSTERROR()
 q "{Error:'"_Error_"'}"
}

/// Descript:取医嘱信息
/// Creater:	ZhangDongmei
/// CreateDate:	2012-02-17
/// Table:
/// Input:OE_OrdItem表id
/// Output:
/// Return：病人就诊号^处方号
/// Others:
ClassMethod GetOrdInfo(Oeori) As %Library.String
{
	n (Oeori)
	q:Oeori="" ""
 	s Ord=$p(Oeori,"||",1)
 	s Chl=$p(Oeori,"||",2)
 	s Adm=$p(^OEORD(Ord),"^",1)
 	s PatNo=""
	s PrescNo=""
 	i $g(Adm)'="" d
 	.s PaPmi=$p(^PAADM(Adm),"^",1)
 	.s PatNo=$p(^PAPER(PaPmi,"PAT",1),"^",1)   ;病人就诊号（处理人）
 	i $d(^OEORD(Ord,"I",Chl,1)) d
 	.s PrescNo=$p(^OEORD(Ord,"I",Chl,1),"^",14)   ;处理号
 	.
 	q PatNo_"^"_PrescNo
}

/// Descript:取台帐查询需要的住院发药业务信息
/// Creater:	ZhangDongmei
/// CreateDate:	2012-02-17
/// Table:
/// Input:发药子表id
/// Output:
/// Return：病人就诊号^处方号
/// Others:
ClassMethod GetIPDispInfo(Phaci) As %Library.String
{
	n (Phaci)
	q:Phaci="" ""
	s Phac=+Phaci
	s Chl=$P(Phaci,"||",2)
 	q:'$d(^DHCPHAC(Phac,"I",Chl)) ""
 	s Oeori=$p(^DHCPHAC(Phac,"I",Chl),"^",7)
 	s OrdInfo=..GetOrdInfo(Oeori)
 	q PatNo_"^"_PrescNo
}

/// Descript:取台帐查询需要的住院退药业务信息
/// Creater:	ZhangDongmei
/// CreateDate:	2012-02-17
/// Table:
/// Input:DHC_PhaReturn表id
/// Output:
/// Return：病人就诊号^处方号
/// Others:
ClassMethod GetIPRetInfo(Pharet) As %Library.String
{
	n (Pharet)
	q:Pharet="" ""
 	q:'$d(^PHARET(Pharet)) ""
 	s oeori=$p(^PHARET(Pharet),"^",5)
 	...s Ord=$p(oeori,"||",1)
 	...s Chl=$p(oeori,"||",2)
 	...s Adm=$p(^OEORD(Ord),"^",1)
 	...i $g(Adm)'="" d
 	....s PaPmi=$p(^PAADM(Adm),"^",1)
 	....s TrAdm=$p(^PAPER(PaPmi,"PAT",1),"^",1)
 	...i $d(^OEORD(Ord,"I",Chl,1)) d
 	....s TrNo=$p(^OEORD(Ord,"I",Chl,1),"^",14)
 	...
 	..
}

/// Descript:计算库存进价金额
/// Creater:	ZhangDongmei
/// CreateDate:	2012-02-16
/// Table:
/// Input:INC_ItmLoc表id，库存日期
/// Output:
/// Return：进价金额
/// Others:
ClassMethod GetRpAmtOfStockQty(Incil, Date, HospID) As %Library.String
{
	n (Incil,Date)
	s RpAmt=##class(web.DHCST.Common.DrugStkCommon).GetRpAmt(Incil,Date)
	q RpAmt
	//
	q:Incil="" 0
	q:Date="" 0
	s Inci=+Incil
	s BUomId=$p(^INCI(Inci,1),"^",10)
	s RpAmt=0
	s IL=$p(Incil,"||",2)
	s LB=0
	f  s LB=$o(^INCI(Inci,"IL",IL,"LB",LB))  q:LB=""  d
	.s Inclb=Incil_"||"_LB
	.s Qty=##class(web.DHCST.Common.DrugStkCommon).QtyINCLB(Inclb,Date)
	.//s Rp=##class(web.DHCST.Common.PriceCommon).GetClbRp(Inclb,BUomId)
	.s Rp=##class(web.DHCST.Common.PriceCommon).GetClbRp(Inclb,BUomId,HospID,"G",Date,"")
	.s RpAmt=RpAmt+(Qty*Rp)
	
	q RpAmt
}

ClassMethod NewPid() As %String
{
  q $I(^DHCSTPID("LocStkTrans"))
}

/// Creator:bianshuai
/// CreateDate;2014-04-28
/// Descript:台账查询明细
/// w ##Class(web.DHCST.LocItmTransMove).QueryBusDetail("15739")
ClassMethod QueryBusDetail(TrId As %String) As %String
{
	s ^YSJTMP("QueryBusDetail")=TrId
	n (TrId)
	q:TrId="" "^"
	q:'$d(^DHCINTR(TrId)) "^"
	s pid=..NewPid()
	s TrType=$p(^DHCINTR(TrId),"^",1)
	s TrPointer=$p(^DHCINTR(TrId),"^",9)
	s num=1
	
 	///转移
 	i (TrType="T")!(TrType="I")!(TrType="K") d
 	.q:'$d(^DHCINIT($p(TrPointer,"||",1)))
 	.q:$p(^DHCINIT($p(TrPointer,"||",1)),"^",6)=""
 	.d InIsTrf(TrPointer)
 	.
 	///入库
 	i TrType="G" d
 	.q:'$d(^DHCINGR($p(TrPointer,"||",1)))
 	.q:$p(^DHCINGR($p(TrPointer,"||",1)),"^",8)=""
 	.d Ingdrec(TrPointer)
 	
 	///调整
 	i TrType="A" d
 	.q:'$d(^DHCINAD($p(TrPointer,"||",1)))
 	.q:$p(^DHCINAD($p(TrPointer,"||",1)),"^",3)=""
 	.d InAdj(TrPointer)
 	
 	///退货
 	i TrType="R" d
 	.q:'$d(^INGRT($p(TrPointer,"||",1)))
 	.q:$p(^INGRT($p(TrPointer,"||",1)),"^",5)=""
 	.d Ingdret(TrPointer)
 	
 	///门诊发药
 	i TrType="F" d
 	.d OutDisp(TrPointer)
 	
 	///门诊退药
 	i TrType="H" d
 	.s TrMsg="门诊退药" 
 	.d OutReturn(TrPointer)
 	
 	///住院发药
 	i TrType="P" d
 	.d PhaCollect(TrPointer)
 	
 	///住院退药
 	i TrType="Y" d
 	.s TrMsg="住院退药" 
 	.d PhaReturn(TrPointer)

 	///报损
 	i TrType="D" d
 	.q:'$d(^DHCINSP($p(TrPointer,"||",1)))
 	.d InScrap(TrPointer)
 	
 	///制剂生产
 	i TrType="M" d
 	.q:'$d(^DHCINMAN($p(TrPointer,"||",1)))  
 	.d InManu(TrPointer)
 	
 	///制剂消耗
 	i TrType="X" d
 	.q:'$d(^DHCINMAN($p(TrPointer,"||",1)))  
 	.d InManui(TrPointer)
 	
 	
 	///门诊撤消退药
 	i TrType="HC" d
 	.s TrMsg="门诊撤消退药" 
 	.d OutReturnC(TrPointer)
 	
 	
 	q pid_"^"_num
 	
Ingdrec(ingri)
    s ingr=+ingri
	q:'$d(^DHCINGR(ingr))
	q:$p(^DHCINGR(ingr),"^",8)=""
	s ingrno=$p(^DHCINGR(ingr),"^",1)                   //单号
	s apc=$p(^DHCINGR(ingr),"^",3)
	s:apc'="" apcname=$p(^APC("APCVM",apc),"^",3)         //经营企业
	s aduitdate=..SetDateFmt($p(^DHCINGR(ingr),"^",4))   //审核日期
	s aduituser=..GetUserName($p(^DHCINGR(ingr),"^",8))  //审核人
	s creatdate=..SetDateFmt($p(^DHCINGR(ingr),"^",14))  //建单日期
	s creatuser=..GetUserName($p(^DHCINGR(ingr),"^",16)) //建单人
	s mainstr="单号:"_ingrno_"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;经营企业:"_$g(apcname)_" <br>日期:"_aduitdate_"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;审核:"_aduituser_"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;制单:"_creatuser
	s ^TMP("DHCST","web.DHCST.LocItmTransMove","QueryBusDetail",pid)=mainstr
	///表头
	s tmpstr="代码^名称^数量^单位^效期~批次^生产企业^售价^售价金额^进价^进价金额"
	s ^TMP("DHCST","web.DHCST.LocItmTransMove","QueryBusDetail",pid,1)=tmpstr
	s ch=""
	f  s ch=$o(^DHCINGR(ingr,"GRI",ch)) q:ch=""  d
	.s inclb=$p(^DHCINGR(ingr,"GRI",ch),"^",1)
	.s code=$p(^INCI(+inclb,1),"^",1)     //代码
	.s desc=$p(^INCI(+inclb,1),"^",2)     //描述
	.s recqty=$p(^DHCINGR(ingr,"GRI",ch),"^",4)
	.s expdate=$p(^DHCINGR(ingr,"GRI",ch),"^",9)    //效期
	.i expdate'="" s expdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(expdate,"ST")
	.s recuom=+$p(^DHCINGR(ingr,"GRI",ch),"^",10)
	.s:recuom'="" recuom=$p($g(^CT("UOM",recuom)),"^",2)
	.s batno=$p(^DHCINGR(ingr,"GRI",ch),"^",13)     //批号
	.s sp=$p(^DHCINGR(ingr,"GRI",ch),"^",32)
	.s invno=$p(^DHCINGR(ingr,"GRI",ch),"^",27)
	.s manf=+$p(^DHCINGR(ingr,"GRI",ch),"^",29)
	.s:$d(^PHMNF(+manf)) manf=$p(^PHMNF(manf),"^",2)  //生产企业
	.i manf["-" s manf=$p(manf,"-",2)
	.s manf=$E(manf,1,8)    //生产企业保留8个字符
	.s rp=$p(^DHCINGR(ingr,"GRI",ch),"^",30)
	.s rpamt=$p(^DHCINGR(ingr,"GRI",ch),"^",31)
	.s spamt=$p(^DHCINGR(ingr,"GRI",ch),"^",50)
	.s num=num+1
	.s tmpstr=code_"^"_desc_"^"_recqty_"^"_recuom_"^"_expdate_"~"_batno_"^"_manf_"^"_sp
	.s tmpstr=tmpstr_"^"_spamt_"^"_rp_"^"_rpamt
	.s ^TMP("DHCST","web.DHCST.LocItmTransMove","QueryBusDetail",pid,num)=tmpstr
	q ""

InIsTrf(initi)
    s init=+initi
 	q:'$d(^DHCINIT(init))
 	q:$p(^DHCINIT(init),"^",6)=""
	s initno=$p(^DHCINIT(init),"^",1)                    //单号
	s creatdate=..SetDateFmt($p(^DHCINIT(init),"^",2))   //建单日期 
	s creatuser=..GetUserName($p(^DHCINIT(init),"^",8))  //建单人
	s askdate=..SetDateFmt($p(^DHCINIT(init),"^",9))     //出库日期
	s askuser=..GetUserName($p(^DHCINIT(init),"^",11))   //出库人 
	s inaskdate=..SetDateFmt($p(^DHCINIT(init),"^",15))   //接收日期
	s inaskuser=..GetUserName($p(^DHCINIT(init),"^",17)) //接收人 
	s frlocdr=$p(^DHCINIT(init),"^",5)
	s:frlocdr'="" frloc=$p(^CTLOC(frlocdr),"^",2)        //供给科室
	s:$g(frloc)["-" frloc=$p(frloc,"-",2)
	s tolocdr=$p(^DHCINIT(init),"^",6)
	s:tolocdr'="" toloc=$p(^CTLOC(tolocdr),"^",2)        //转入科室
	s:$g(toloc)["-" toloc=$p(toloc,"-",2)
	s mainstr="单号:"_initno_"<br>供给科室:"_$g(frloc)_"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;出库日期:"_askdate_"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;出库人:"_askuser_"<br>接收科室:"_$g(toloc)
	s mainstr=mainstr_"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;接收日期:"_inaskdate_"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;接收人:"_inaskuser
	s ^TMP("DHCST","web.DHCST.LocItmTransMove","QueryBusDetail",pid)=mainstr
	
	///表头
	s tmpstr="代码^名称^数量^单位^效期~批次^生产企业^售价^售价金额^进价^进价金额"
	s ^TMP("DHCST","web.DHCST.LocItmTransMove","QueryBusDetail",pid,1)=tmpstr
	s ch=""
	f  s ch=$o(^DHCINIT(init,"ITI",ch)) q:ch=""  d
	.s initqty=$p(^DHCINIT(init,"ITI",ch),"^",1)
	.s inclb=$p(^DHCINIT(init,"ITI",ch),"^",3) q:inclb=""
	.s code=$p(^INCI(+inclb,1),"^",1)   //代码
	.s desc=$p(^INCI(+inclb,1),"^",2)   //描述
    .s inituom=$p(^DHCINIT(init,"ITI",ch),"^",7)  //单位
    .s:inituom'="" inituom=$p($g(^CT("UOM",inituom)),"^",2)
    .s rp=$p(^DHCINIT(init,"ITI",ch),"^",15)
    .s rpamt=$p(^DHCINIT(init,"ITI",ch),"^",16)
    .s sp=$p(^DHCINIT(init,"ITI",ch),"^",17)
    .s spamt=$p(^DHCINIT(init,"ITI",ch),"^",18)
    .s batno=..getBatNo(inclb)        //批号~效期
    .s Manf=##class(web.DHCST.Common.DrugStkCommon).GetManfInfoByInclb(inclb)
 	.i Manf'=""  s Manf=$p(Manf,"^",2)
 	.i Manf["-" s Manf=$p(Manf,"-",2)
 	.s Manf=$E(Manf,1,8)   //生产企业保留8个字符
	.s num=num+1
	.s tmpstr=code_"^"_desc_"^"_initqty_"^"_inituom_"^"_batno_"^"_Manf_"^"_sp
	.s tmpstr=tmpstr_"^"_spamt_"^"_rp_"^"_rpamt
	.s ^TMP("DHCST","web.DHCST.LocItmTransMove","QueryBusDetail",pid,num)=tmpstr
	q ""
	
InAdj(inadji)
    s inadj=+inadji
 	q:'$d(^DHCINAD(inadj))
 	q:$p(^DHCINAD(inadj),"^",3)=""
	s adjno=$p(^DHCINAD(inadj),"^",1)                    //单号
	s creatdate=..SetDateFmt($p(^DHCINAD(inadj),"^",2))   //建单日期 
	s creatuser=..GetUserName($p(^DHCINAD(inadj),"^",3))  //建单人
	s askdate=..SetDateFmt($p(^DHCINAD(inadj),"^",8))     //调整日期
	s askuser=..GetUserName($p(^DHCINAD(inadj),"^",10))   //调整人 
	s adjlocdr=$p(^DHCINAD(inadj),"^",16)
	s:adjlocdr'="" adjloc=$p(^CTLOC(adjlocdr),"^",2)        //供给科室
	s:$g(adjloc)["-" adjloc=$p(adjloc,"-",2)
	s mainstr="单号:"_adjno_"<br>调整科室:"_$g(adjloc)_"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;制单日期:"_creatdate_"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;制单人:"_creatuser
	s mainstr=mainstr_"<br>调整日期:"_askdate_"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;调整人:"_askuser
	s ^TMP("DHCST","web.DHCST.LocItmTransMove","QueryBusDetail",pid)=mainstr
	
	///表头
	s tmpstr="代码^名称^数量^单位^效期~批次^生产企业^售价^售价金额^进价^进价金额"
	s ^TMP("DHCST","web.DHCST.LocItmTransMove","QueryBusDetail",pid,1)=tmpstr
	s ch=""
	f  s ch=$o(^DHCINAD(inadj,"ADI",ch)) q:ch=""  d
	.s inclb=$p(^DHCINAD(inadj,"ADI",ch),"^",1)
	.s code=$p(^INCI(+inclb,1),"^",1)   //代码
	.s desc=$p(^INCI(+inclb,1),"^",2)   //描述
	.s qty=$p(^DHCINAD(inadj,"ADI",ch),"^",2)
	.s uom=$p(^DHCINAD(inadj,"ADI",ch),"^",5)  //单位
    .s:uom'="" uom=$p($g(^CT("UOM",uom)),"^",2)
	.s sp=$p(^DHCINAD(inadj,"ADI",ch),"^",4)
	.s spamt=$p(^DHCINAD(inadj,"ADI",ch),"^",8)
	.s rp=$p(^DHCINAD(inadj,"ADI",ch),"^",9)
	.s rpamt=$p(^DHCINAD(inadj,"ADI",ch),"^",10)
    .s batno=..getBatNo(inclb)        //批号~效期
    .s Manf=##class(web.DHCST.Common.DrugStkCommon).GetManfInfoByInclb(inclb)
 	.i Manf'=""  s Manf=$p(Manf,"^",2)
 	.i Manf["-" s Manf=$p(Manf,"-",2)
 	.s Manf=$E(Manf,1,8)   //生产企业保留8个字符
	.s num=num+1
	.s tmpstr=code_"^"_desc_"^"_qty_"^"_uom_"^"_batno_"^"_Manf_"^"_sp
	.s tmpstr=tmpstr_"^"_spamt_"^"_rp_"^"_rpamt
	.s ^TMP("DHCST","web.DHCST.LocItmTransMove","QueryBusDetail",pid,num)=tmpstr
	q ""
	
Ingdret(ingrti)
    s ingrt=+ingrti
 	q:'$d(^INGRT(ingrt))
 	q:$p(^INGRT(ingrt),"^",5)=""
	s ingrtno=$p(^INGRT(ingrt),"^",1)                    //单号
	s creatdate=..SetDateFmt($p(^INGRT(ingrt),"^",3))   //建单日期 
	s creatuser=..GetUserName($p(^INGRT(ingrt),"^",5))  //建单人
	s askdate=..SetDateFmt($p(^INGRT(ingrt),"^",9))     //调整日期
	s askuser=..GetUserName($p(^INGRT(ingrt),"^",8))   //调整人 
	s adjlocdr=$p(^INGRT(ingrt),"^",7)
	s:adjlocdr'="" adjloc=$p(^CTLOC(adjlocdr),"^",2)        //供给科室
	s:$g(adjloc)["-" adjloc=$p(adjloc,"-",2)
	s apc=$p(^INGRT(ingrt),"^",2)
	s:apc'="" apcname=$p(^APC("APCVM",apc),"^",3)         //经营企业
	s mainstr="单号:"_ingrtno_"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;退货科室:"_$g(adjloc)_"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;经营企业:"_apcname_"<br>制单日期:"_creatdate_"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;制单人:"_creatuser
	s mainstr=mainstr_"<br>退货日期:"_askdate_"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;退货人:"_askuser
	s ^TMP("DHCST","web.DHCST.LocItmTransMove","QueryBusDetail",pid)=mainstr
	
	///表头
	s tmpstr="代码^名称^数量^单位^效期~批次^生产企业^售价^售价金额^进价^进价金额"
	s ^TMP("DHCST","web.DHCST.LocItmTransMove","QueryBusDetail",pid,1)=tmpstr
	s ch=""
	f  s ch=$o(^INGRT(ingrt,"DHCGRR",ch)) q:ch=""  d
	.s ingri=$p(^INGRT(ingrt,"DHCGRR",ch),"^",1)
	.s inclb=$p(^DHCINGR(+ingri,"GRI",$p(ingri,"||",2)),"^",1)
	.s code=$p(^INCI(+inclb,1),"^",1)   //代码
	.s desc=$p(^INCI(+inclb,1),"^",2)   //描述
	.s qty=$p(^INGRT(ingrt,"DHCGRR",ch),"^",2)
	.s uom=$p(^INGRT(ingrt,"DHCGRR",ch),"^",3)  //单位
    .s:uom'="" uom=$p($g(^CT("UOM",uom)),"^",2)
	.s sp=$p(^INGRT(ingrt,"DHCGRR",ch),"^",8)
	.s spamt=$p(^INGRT(ingrt,"DHCGRR",ch),"^",9)
	.s rp=$p(^INGRT(ingrt,"DHCGRR",ch),"^",7)
	.s rpamt=$p(^INGRT(ingrt,"DHCGRR",ch),"^",4)
    .s batno=..getBatNo(inclb)        //批号~效期
    .s Manf=##class(web.DHCST.Common.DrugStkCommon).GetManfInfoByInclb(inclb)
 	.i Manf'=""  s Manf=$p(Manf,"^",2)
 	.i Manf["-" s Manf=$p(Manf,"-",2)
 	.s Manf=$E(Manf,1,8)   //生产企业保留8个字符
	.s num=num+1
	.s tmpstr=code_"^"_desc_"^"_qty_"^"_uom_"^"_batno_"^"_Manf_"^"_sp
	.s tmpstr=tmpstr_"^"_spamt_"^"_rp_"^"_rpamt
	.s ^TMP("DHCST","web.DHCST.LocItmTransMove","QueryBusDetail",pid,num)=tmpstr
	q ""

OutDisp(phaclb)
	//s ^ljq("OutDisp")=phaclb
	s phac=+phaclb
 	q:'$d(^DHCPHDISP(phac))
	//s phacno=$p(^DHCPHDISP(phac),"^",14)                  //发药单号
	s cdate=..SetDateFmt($p(^DHCPHDISP(phac),"^",3))      //发药日期 
	s userDr=$p(^DHCPHDISP(phac,1),"^",2)
	s fyuserdr=$p(^DHCPHPER(userDr),"^",5)
	s cuser=..GetUserName(fyuserdr)     //发药人
	s locdr=$p(^DHCPHDISP(phac,1),"^",1)
	s phalocDr=$p(^DHCPHLOC(locdr),"^",1)
	s:phalocDr'="" phaloc=$p(^CTLOC(phalocDr),"^",2)          //供给科室
	s:$g(phaloc)["-" phaloc=$p(phaloc,"-",2)
	s mainstr="发药科室:"_$g(phaloc)_"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
	s mainstr=mainstr_"<br>发药日期:"_cdate_"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;发药人:"_cuser
	s ^TMP("DHCST","web.DHCST.LocItmTransMove","QueryBusDetail",pid)=mainstr
	
	///表头
	s tmpstr="姓名^名称^数量^单位^科室^登记号^售价^处方"
	s ^TMP("DHCST","web.DHCST.LocItmTransMove","QueryBusDetail",pid,1)=tmpstr
	s ch="",num=1
	f  s ch=$o(^DHCPHDI(phac,"PHDI",ch)) q:ch=""  d
	.s PapmiId=$p(^DHCPHDISP(phac),"^",7)
	.s prescno=$p(^DHCPHDISP(phac,2),"^",1)
	.s qty=$p(^DHCPHDI(phac,"PHDI",ch),"^",4)
	.s sp=$p(^DHCPHDI(phac,"PHDI",ch),"^",11)
	.s PatName=$p(^PAPER(PapmiId,"ALL"),"^",1) 
	.s PatNo=$p(^PAPER(PapmiId,"PAT",1),"^",1)
	.s oeori=$p(^DHCPHDI(phac,"PHDI",ch),"^",5)
	.s AdmLoc=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),9),"^",2)
	.s AdmLocDesc=$p(^CTLOC(AdmLoc),"^",2)
	.s:AdmLocDesc["-" AdmLocDesc=$p(AdmLocDesc,"-",2)
	.s itmmast=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),1),"^",2)
	.s inci=$o(^INCI(0,"ARCIM_DR",$p(itmmast,"||",1),""))
	.s buomdr=$p(^INCI(inci,1),"^",10)
	.s:buomdr'="" buom=$p(^CT("UOM",buomdr),"^",2)
	.s code=$p(^INCI(+inci,1),"^",1)   //代码
	.s desc=$p(^INCI(+inci,1),"^",2)   //描述
	.s puomdr=$p($g(^OEORD(+oeori,"I",$p(oeori,"||",2),"DHC")),"^",13)
	.s:puomdr'="" buom=$p(^CT("UOM",puomdr),"^",2)
	.s lb=0
	.f  s lb=$o(^DHCPHDI(phac,"PHDI",ch,"INCLB",lb)) q:lb=""  d
	..s inclb=$p(^DHCPHDI(phac,"PHDI",ch,"INCLB",lb),"^",3)
	..s qty=$p(^DHCPHDI(phac,"PHDI",ch,"INCLB",lb),"^",1)
	..s sp=$p(^DHCPHDI(phac,"PHDI",ch,"INCLB",lb),"^",7)
	..s code=$p(^INCI(+inclb,1),"^",1)   //代码
	..s desc=$p(^INCI(+inclb,1),"^",2)   //描述
	..s buomdr=$p(^INCI(+inclb,1),"^",10)
	..s:buomdr'="" buom=$p(^CT("UOM",buomdr),"^",2)
	..s num=num+1
	..s tmpstr=PatName_"^"_desc_"^"_qty_"^"_buom_"^"_AdmLocDesc
	..s tmpstr=tmpstr_"^"_PatNo_"^"_sp_"^"_prescno
	..s ^TMP("DHCST","web.DHCST.LocItmTransMove","QueryBusDetail",pid,num)=tmpstr
	q ""

OutReturn(phaclb)
	s phac=+phaclb
 	q:'$d(^DHCPHRET(phac))
	s cdate=..SetDateFmt($p(^DHCPHRET(phac),"^",2))      //退药日期 
	s userDr=$p(^DHCPHRET(phac),"^",8)
	s retuserdr=$p(^DHCPHPER(userDr),"^",5)
	s cuser=..GetUserName(retuserdr)     //退药人
	s locdr=$p(^DHCPHRET(phac),"^",7)
	s phalocDr=$p(^DHCPHLOC(locdr),"^",1)
	s:phalocDr'="" phaloc=$p(^CTLOC(phalocDr),"^",2)          //供给科室
	s:$g(phaloc)["-" phaloc=$p(phaloc,"-",2)
	s mainstr="退药科室:"_$g(phaloc)_"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
	s mainstr=mainstr_"<br>退药日期:"_cdate_"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;退药人:"_cuser
	s ^TMP("DHCST","web.DHCST.LocItmTransMove","QueryBusDetail",pid)=mainstr
	
	///表头
	s tmpstr="姓名^名称^数量^单位^科室^登记号^售价^处方"
	s ^TMP("DHCST","web.DHCST.LocItmTransMove","QueryBusDetail",pid,1)=tmpstr
	s ch=""
	f  s ch=$o(^DHCPHRTI(phac,"RTI",ch)) q:ch=""  d
	.s dispphac=$p(^DHCPHRET(phac),"^",6)
	.s prescno=$p(^DHCPHDISP(dispphac,2),"^",1)
	.s buom=$p(^DHCPHRTI(phac,"RTI",ch),"^",4)
	.s:buom'="" buom=$p(^CT("UOM",buom),"^",2)
	.s qty=$p(^DHCPHRTI(phac,"RTI",ch),"^",3)
	.s sp=$p(^DHCPHRTI(phac,"RTI",ch),"^",6)
	.s PapmiId=$p(^DHCPHDISP(dispphac),"^",7) 
	.s PatName=$p(^PAPER(PapmiId,"ALL"),"^",1) 
	.s PatNo=$p(^PAPER(PapmiId,"PAT",1),"^",1)
	.s oeori=$p(^DHCPHRTI(phac,"RTI",ch),"^",2)
	.s AdmLoc=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),9),"^",2)
	.s AdmLocDesc=$p(^CTLOC(AdmLoc),"^",2)
	.s:AdmLocDesc["-" AdmLocDesc=$p(AdmLocDesc,"-",2)
	.s itmmast=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),1),"^",2)
	.s inci=$o(^INCI(0,"ARCIM_DR",$p(itmmast,"||",1),""))
	.s code=$p(^INCI(+inci,1),"^",1)   //代码
	.s desc=$p(^INCI(+inci,1),"^",2)   //描述
	.s num=num+1
	.s tmpstr=PatName_"^"_desc_"^"_qty_"^"_buom_"^"_AdmLocDesc
	.s tmpstr=tmpstr_"^"_PatNo_"^"_sp_"^"_prescno
	.s ^TMP("DHCST","web.DHCST.LocItmTransMove","QueryBusDetail",pid,num)=tmpstr
	q ""
	
PhaCollect(phaclb)
	s phac=+phaclb
 	q:'$d(^DHCPHAC(phac))
	s phacno=$p(^DHCPHAC(phac),"^",14)                  //发药单号
	s cdate=..SetDateFmt($p(^DHCPHAC(phac),"^",2))      //发药日期 
	i (cdate = "") s cdate=..SetDateFmt($p(^DHCPHAC(phac), "^", 7)) //如果发药日期为空，则取打印日期，静配不插发药日期
	s cuser=..GetUserName($p(^DHCPHAC(phac),"^",5))     //发药人
	s locdr=$p(^DHCPHAC(phac),"^",1)
	s:locdr'="" phaloc=$p(^CTLOC(locdr),"^",2)          //供给科室
	s:$g(phaloc)["-" phaloc=$p(phaloc,"-",2)
	s WardId=$p(^DHCPHAC(phac),"^",4) q:WardId=""
	s WardLoc=$p(^PAWARD(WardId),"^",5)   //病区
	s:WardLoc'="" WardLoc=$p(^CTLOC(WardLoc),"^",2)
	s mainstr="单号:"_phacno_"<br>发药科室:"_$g(phaloc)_"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;病区:"_WardLoc
	s mainstr=mainstr_"<br>发药日期:"_cdate_"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;发药人:"_cuser
	s ^TMP("DHCST","web.DHCST.LocItmTransMove","QueryBusDetail",pid)=mainstr
	
	///表头
	s tmpstr="姓名^名称^数量^单位^科室^医嘱优先级^床号^登记号^售价^处方"
	s ^TMP("DHCST","web.DHCST.LocItmTransMove","QueryBusDetail",pid,1)=tmpstr
	s ch=""
	f  s ch=$o(^DHCPHAC(phac,"I",ch)) q:ch=""  d
	.s AdmDr=$p(^DHCPHAC(phac,"I",ch),"^",3)
	.s inci=$p(^DHCPHAC(phac,"I",ch),"^",4)
	.;s code=$p(^INCI(+inci,1),"^",1)   //代码
	.;s desc=$p(^INCI(+inci,1),"^",2)   //描述
	.;s buom=$p(^INCI(+inci,1),"^",10)
	.;s:buom'="" buom=$p(^CT("UOM",buom),"^",2)
	.s prescno=$p(^DHCPHAC(phac,"I",ch),"^",5)
	.s qty=$p(^DHCPHAC(phac,"I",ch),"^",6)
	.s bedNo=$p(^DHCPHAC(phac,"I",ch),"^",8)
	.s sp=$p(^DHCPHAC(phac,"I",ch),"^",9)
	.s PapmiId=$p(^PAADM(AdmDr),"^",1) 
	.s PatName=$p(^PAPER(PapmiId,"ALL"),"^",1) 
	.s PatNo=$p(^PAPER(PapmiId,"PAT",1),"^",1)
	.s AdmLoc=$p(^PAADM(AdmDr),"^",4) 
	.s AdmLocDesc=$p(^CTLOC(AdmLoc),"^",2)
	.s:AdmLocDesc["-" AdmLocDesc=$p(AdmLocDesc,"-",2)
	.s oeori=$p(^DHCPHAC(phac,"I",ch),"^",7)
	.s Priorty=$p(^OECPR($p(^OEORD(+oeori,"I",$p(oeori,"||",2),1),"^",8)),"^",2)   		;医嘱优先级
	.s lb=0
	.f  s lb=$o(^DHCPHAC(phac,"I",ch,"B",lb)) q:lb=""  d
	..s inclb=$p(^DHCPHAC(phac,"I",ch,"B",lb),"^",1)
	..s qty=$p(^DHCPHAC(phac,"I",ch,"B",lb),"^",2)
	..s sp=$p(^DHCPHAC(phac,"I",ch,"B",lb),"^",5)
	..s code=$p(^INCI(+inclb,1),"^",1)   //代码
	..s desc=$p(^INCI(+inclb,1),"^",2)   //描述
	..s buom=$p(^INCI(+inclb,1),"^",10)
	..s:buom'="" buom=$p(^CT("UOM",buom),"^",2)
	..s num=num+1
	..s tmpstr=PatName_"^"_desc_"^"_qty_"^"_buom_"^"_AdmLocDesc_"^"_Priorty_"^"_bedNo
	..s tmpstr=tmpstr_"^"_PatNo_"^"_sp_"^"_prescno
	..s ^TMP("DHCST","web.DHCST.LocItmTransMove","QueryBusDetail",pid,num)=tmpstr
	q ""
	
PhaReturn(phaclb)
	s phac=+phaclb
 	q:'$d(^PHARET(phac))
	s phacno=$p(^PHARET(phac),"^",7)                  //退药单号
	s cdate=..SetDateFmt($p(^PHARET(phac),"^",1))      //退药日期 
	s cuser=..GetUserName($p(^PHARET(phac),"^",3))     //退药人
	s locdr=$p(^PHARET(phac),"^",5)
	s:locdr'="" phaloc=$p(^CTLOC(locdr),"^",2)          //退药科室
	s:$g(phaloc)["-" phaloc=$p(phaloc,"-",2)
	s WardId=$p(^PHARET(phac),"^",6) q:WardId=""
	s:WardId'="" WardLoc=$p(^CTLOC(WardId),"^",2) //病区
	s mainstr="单号:"_phacno_"<br>退药科室:"_$g(phaloc)_"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;病区:"_WardLoc
	s mainstr=mainstr_"<br>退药日期:"_cdate_"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;退药人:"_cuser
	s ^TMP("DHCST","web.DHCST.LocItmTransMove","QueryBusDetail",pid)=mainstr
	
	///表头
	s tmpstr="姓名^名称^数量^单位^科室^医嘱优先级^床号^登记号^售价^处方"
	s ^TMP("DHCST","web.DHCST.LocItmTransMove","QueryBusDetail",pid,1)=tmpstr
	s ch=""
	f  s ch=$o(^PHARET(phac,"I",ch)) q:ch=""  d
	.s AdmDr=$p(^PHARET(phac,"I",ch),"^",8)
	.s inci=$p(^PHARET(phac,"I",ch),"^",11)
	.s code=$p(^INCI(+inci,1),"^",1)   //代码
	.s desc=$p(^INCI(+inci,1),"^",2)   //描述
	.s buom=$p(^INCI(+inci,1),"^",10)
	.s:buom'="" buom=$p(^CT("UOM",buom),"^",2)
	.s qty=$p(^PHARET(phac,"I",ch),"^",2)
	.s bedDr=$p(^PHARET(phac,"I",ch),"^",10)
	.s bedNo=$p(^PAWARD(+bedDr,"BED",$p(bedDr,"||",2)),"^",1)
	.s sp=$p(^PHARET(phac,"I",ch),"^",4)
	.s PapmiId=$p(^PAADM(AdmDr),"^",1) 
	.s PatName=$p(^PAPER(PapmiId,"ALL"),"^",1) 
	.s PatNo=$p(^PAPER(PapmiId,"PAT",1),"^",1)
	.s AdmLoc=$p(^PAADM(AdmDr),"^",4) 
	.s AdmLocDesc=$p(^CTLOC(AdmLoc),"^",2)
	.s:AdmLocDesc["-" AdmLocDesc=$p(AdmLocDesc,"-",2)
	.s oeori=$p(^PHARET(phac,"I",ch),"^",1)
	.s Priorty=$p(^OECPR($p(^OEORD(+oeori,"I",$p(oeori,"||",2),1),"^",8)),"^",2)   		;医嘱优先级
	.s prescno=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),1),"^",14)
	.s num=num+1
	.s tmpstr=PatName_"^"_desc_"^"_qty_"^"_buom_"^"_AdmLocDesc_"^"_Priorty_"^"_bedNo
	.s tmpstr=tmpstr_"^"_PatNo_"^"_sp_"^"_prescno
	.s ^TMP("DHCST","web.DHCST.LocItmTransMove","QueryBusDetail",pid,num)=tmpstr
	q ""
	
InScrap(inscrapi)
    s inscrap=+inscrapi
 	q:'$d(^DHCINSP(inscrap))
 	q:$p(^DHCINSP(inscrap),"^",3)=""
	s scrapno=$p(^DHCINSP(inscrap),"^",1)                    //单号
	s creatdate=..SetDateFmt($p(^DHCINSP(inscrap),"^",2))   //建单日期 
	s creatuser=..GetUserName($p(^DHCINSP(inscrap),"^",6))  //建单人
	s askdate=..SetDateFmt($p(^DHCINSP(inscrap),"^",7))     //报损日期
	s askuser=..GetUserName($p(^DHCINSP(inscrap),"^",9))   //报损人 
	s scraplocdr=$p(^DHCINSP(inscrap),"^",5)
	s:scraplocdr'="" scraploc=$p(^CTLOC(scraplocdr),"^",2)        //供给科室
	s:$g(scraploc)["-" scraploc=$p(scraploc,"-",2)
	s mainstr="单号:"_scrapno_"<br>报损科室:"_$g(scraploc)_"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;制单日期:"_creatdate_"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;制单人:"_creatuser
	s mainstr=mainstr_"<br>报损日期:"_askdate_"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;报损人:"_askuser
	s ^TMP("DHCST","web.DHCST.LocItmTransMove","QueryBusDetail",pid)=mainstr
	///表头
	s tmpstr="代码^名称^数量^单位^效期~批次^生产企业^售价^售价金额^进价^进价金额"
	s ^TMP("DHCST","web.DHCST.LocItmTransMove","QueryBusDetail",pid,1)=tmpstr
	s ch=""
	f  s ch=$o(^DHCINSP(inscrap,"I",ch)) q:ch=""  d
	.s inclb=$p(^DHCINSP(inscrap,"I",ch),"^",1)
	.s code=$p(^INCI(+inclb,1),"^",1)   //代码
	.s desc=$p(^INCI(+inclb,1),"^",2)   //描述
	.s qty=$p(^DHCINSP(inscrap,"I",ch),"^",3)
	.s uom=$p(^DHCINSP(inscrap,"I",ch),"^",2)  //单位
    .s:uom'="" uom=$p($g(^CT("UOM",uom)),"^",2)
	.s sp=$p(^DHCINSP(inscrap,"I",ch),"^",8)
	.s spamt=$p(^DHCINSP(inscrap,"I",ch),"^",9)
	.s rp=$p(^DHCINSP(inscrap,"I",ch),"^",4)
	.s rpamt=$p(^DHCINSP(inscrap,"I",ch),"^",5)
    .s batno=..getBatNo(inclb)        //批号~效期
    .s Manf=##class(web.DHCST.Common.DrugStkCommon).GetManfInfoByInclb(inclb)
 	.i Manf'=""  s Manf=$p(Manf,"^",2)
 	.s Manf=$E(Manf,1,8)   //生产企业保留8个字符
	.s num=num+1
	.s tmpstr=code_"^"_desc_"^"_qty_"^"_uom_"^"_batno_"^"_Manf_"^"_sp
	.s tmpstr=tmpstr_"^"_spamt_"^"_rp_"^"_rpamt
	.s ^TMP("DHCST","web.DHCST.LocItmTransMove","QueryBusDetail",pid,num)=tmpstr
	q ""
	
InManu(InManu)
	//s tmpstr="制剂单号^制剂名称^理论数量^实际数量^单位^制剂日期^制剂人^状态^批号^效期^附加费^成本^总金额^建单人^审核人^审核日期^售价^售价金额"
	s Stat=$p(^DHCINMAN(InManu),"^",27)
	i Stat="10" s Stat="保存"
	i Stat="15" s Stat="完成"
	i Stat="21" s Stat="审核"
	s LocDr=$p(^DHCINMAN(InManu),"^",3)
	s ManuNo=$p(^DHCINMAN(InManu),"^",1)
	s InRec=$p(^DHCINMAN(InManu),"^",28)
	s InciDr=+InRec
	s InRecDesc=$p(^INCI(+InRec,"REC",$p(InRec,"||",2)),"^",12)
	s ManuDate=$p(^DHCINMAN(InManu),"^",2)
	i ManuDate'="" s ManuDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(ManuDate,"ST")
	s ManuUser=$p(^DHCINMAN(InManu),"^",23)
	s UserName=""
	i ManuUser'="" s UserName=$p(^SSU("SSUSR",ManuUser),"^",2)
	s Uomdr=$p(^DHCINMAN(InManu),"^",8)
	s UomDesc=$p(^CT("UOM",Uomdr),"^",2)
	s TheoryQty=$p(^DHCINMAN(InManu),"^",9)
	s TheoryQty=##class(web.DHCST.ManuOrder).ChangVal(TheoryQty,"Qty")
	s FactQty=$p(^DHCINMAN(InManu),"^",10)
	s FactQty=##class(web.DHCST.ManuOrder).ChangVal(FactQty,"Qty")
	s BatNo=$p(^DHCINMAN(InManu),"^",5)
	s ExpDate=$p(^DHCINMAN(InManu),"^",6)
	i ExpDate'="" s ExpDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(ExpDate,"ST")
	s CostPrice=$p(^DHCINMAN(InManu),"^",12)
	s InManuRp=$p(^DHCINMAN(InManu),"^",11)   		//进价
	s InManuRpAmt=$p(^DHCINMAN(InManu),"^",15)		//进价金额
	s CreatorUser=$p(^DHCINMAN(InManu),"^",25)		//建单人
	i CreatorUser'="" s CreatorUser=$p(^SSU("SSUSR",CreatorUser),"^",2)
	s AuditUser=$p(^DHCINMAN(InManu),"^",24)			//审核人
	i AuditUser'="" s AuditUser=$p(^SSU("SSUSR",AuditUser),"^",2)
	s AuditDate=$p(^DHCINMAN(InManu),"^",30)			//审核日期
	i AuditDate'="" s AuditDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(AuditDate,"ST")
	s InManuSp=$p(^DHCINMAN(InManu),"^",31)			//售价
	s InManuSpAmt=$p(^DHCINMAN(InManu),"^",32)		//售价金额	
	s Data1=InRecDesc_"^"_TheoryQty_"^"_FactQty
	s Data2=UomDesc_"^"_BatNo
	s Data3=ExpDate_"^"_CostPrice_"^"_InManuRp_"^"_InManuRpAmt
	s Data4=InManuSp_"^"_InManuSpAmt
	s Data=Data1_"^"_Data2_"^"_Data3_"^"_Data4
	
	s mainstr="制剂单号:"_ManuNo_"<br>制剂日期:"_$g(ManuDate)_"&nbsp;&nbsp;&nbsp;审核日期:"_$g(AuditDate)_"<br>制剂人:"_UserName_"&nbsp;&nbsp;&nbsp;建单人:"_CreatorUser_"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;审核人:"_AuditUser
	s ^TMP("DHCST","web.DHCST.LocItmTransMove","QueryBusDetail",pid)=mainstr
	s tmpstr="制剂名称^理论数量^实际数量^单位^批号^效期^附加费^成本^总金额^售价^售价金额"
	s ^TMP("DHCST","web.DHCST.LocItmTransMove","QueryBusDetail",pid,1)=tmpstr
	s ^TMP("DHCST","web.DHCST.LocItmTransMove","QueryBusDetail",pid,2)=Data
	s num=2
	q ""
	
InManui(InManui)

	
	s InManu=+InManui
	s ManuNo=$p(^DHCINMAN(InManu),"^",1)
	s InRec=$p(^DHCINMAN(InManu),"^",28)
	s InciDr=+InRec
	s InRecDesc=$p(^INCI(+InRec,"REC",$p(InRec,"||",2)),"^",12)
	s ManuDate=$p(^DHCINMAN(InManu),"^",2)
	i ManuDate'="" s ManuDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(ManuDate,"ST")
	s ManuUser=$p(^DHCINMAN(InManu),"^",23)
	s UserName=""
	i ManuUser'="" s UserName=$p(^SSU("SSUSR",ManuUser),"^",2)
	
	s mainstr="制剂单号:"_ManuNo_"<br>制剂名称:"_$g(InRecDesc)_"&nbsp;&nbsp;&nbsp;制剂日期:"_ManuDate_"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;制剂人:"_UserName

	s ^TMP("DHCST","web.DHCST.LocItmTransMove","QueryBusDetail",pid)=mainstr
	
	s chl=""
	f  s chl=$O(^DHCINMAN(InManu,"BAT",chl)) q:chl=""  d
	.s Data=^DHCINMAN(InManu,"BAT",chl)
	.s Inclb=$p(Data,"^",1)
	.s UomDr=$p(Data,"^",2)
	.s Qty=$p(Data,"^",3)
	.s Inci=+Inclb
	.s IL=$p(Inclb,"||",2)
	.s LB=$p(Inclb,"||",3)
	.s Incidesc=$P(^INCI(Inci,1),"^",2)
	.s Incicode=$P(^INCI(Inci,1),"^",1)
	.s UomDesc=$p(^CT("UOM",UomDr),"^",2)
	.s PurUom=$P(^INCI(Inci,3),"^",6)
	.s BaseUom=$P(^INCI(Inci,1),"^",10)
	.s confac=##class(web.DHCST.Common.UtilCommon).UOMFac(PurUom,BaseUom)
	.s PQty=""
	.i BaseUom=UomDr d
	..s PQty=Qty/confac
	.e  d
	..s confac1=##class(web.DHCST.Common.UtilCommon).UOMFac(UomDr,BaseUom)
	..s PQty=Qty*confac1/confac
	.s PUomDesc=$p(^CT("UOM",PurUom),"^",2)
	.s Incib=$P(^INCI(Inci,"IL",IL,"LB",LB),"^",1)
    .s Chl=$p(Incib,"||",2)
    .s IncQty=##CLASS(web.DHCST.Common.DrugStkCommon).QtyINCLBU(Inclb,+$h,PurUom)
    .s BatNo=$p(^INCI(Inci,"IB",Chl),"^",1)
 	.s ExpDate=+$p(^INCI(Inci,"IB",Chl),"^",2)
 	.i ExpDate'=0  d
 	..s ExpDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(ExpDate,"ST")
 	.e  d
 	..s ExpDate=""
 	.s Qty=##class(web.DHCST.ManuOrder).ChangVal(Qty,"Qty")
 	.s PQty=##class(web.DHCST.ManuOrder).ChangVal(PQty,"Qty")
	.s ManfStr=##CLASS(web.DHCST.Common.DrugStkCommon).GetManfInfoByInclb(Inclb)
 	.s Manf=$p(ManfStr,"^",2)
 	.i Manf["-" s Manf=$p(Manf,"-",2)
	.s outputData=Incicode_"^"_Incidesc_"^"_ExpDate_"^"_BatNo_"^"_UomDesc_"^"_Qty_"^"_PQty_"^"_PUomDesc
	.s num=num+1
	.s ^TMP("DHCST","web.DHCST.LocItmTransMove","QueryBusDetail",pid,num)=outputData
	.
	
	s tmpstr="原料代码^原料名称^效期^批号^单位^数量^库存数量^入库单位"
	s ^TMP("DHCST","web.DHCST.LocItmTransMove","QueryBusDetail",pid,1)=tmpstr
	q ""
	
OutReturnC(phaclb)
	s phac=+phaclb
 	q:'$d(^DHCPHRET(phac))
	s cdate=..SetDateFmt($p(^DHCPHRET(phac),"^",20))      //撤消退药日期 
	s userDr=$p(^DHCPHRET(phac),"^",22)
	s retuserdr=$p(^DHCPHPER(userDr),"^",5)
	s cuser=..GetUserName(retuserdr)     //撤消退药人
	s locdr=$p(^DHCPHRET(phac),"^",7)
	s phalocDr=$p(^DHCPHLOC(locdr),"^",1)
	s:phalocDr'="" phaloc=$p(^CTLOC(phalocDr),"^",2)          //供给科室
	s:$g(phaloc)["-" phaloc=$p(phaloc,"-",2)
	s mainstr="撤消退药科室:"_$g(phaloc)_"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
	s mainstr=mainstr_"<br>撤消退药日期:"_cdate_"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;撤消退药人:"_cuser
	s ^TMP("DHCST","web.DHCST.LocItmTransMove","QueryBusDetail",pid)=mainstr
	
	///表头
	s tmpstr="姓名^名称^数量^单位^科室^登记号^售价^处方"
	s ^TMP("DHCST","web.DHCST.LocItmTransMove","QueryBusDetail",pid,1)=tmpstr
	s ch=""
	f  s ch=$o(^DHCPHRTI(phac,"RTI",ch)) q:ch=""  d
	.s dispphac=$p(^DHCPHRET(phac),"^",6)
	.s prescno=$p(^DHCPHDISP(dispphac,2),"^",1)
	.s buom=$p(^DHCPHRTI(phac,"RTI",ch),"^",4)
	.s:buom'="" buom=$p(^CT("UOM",buom),"^",2)
	.s qty=$p(^DHCPHRTI(phac,"RTI",ch),"^",3)
	.s sp=$p(^DHCPHRTI(phac,"RTI",ch),"^",6)
	.s PapmiId=$p(^DHCPHDISP(dispphac),"^",7) 
	.s PatName=$p(^PAPER(PapmiId,"ALL"),"^",1) 
	.s PatNo=$p(^PAPER(PapmiId,"PAT",1),"^",1)
	.s oeori=$p(^DHCPHRTI(phac,"RTI",ch),"^",2)
	.s AdmLoc=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),9),"^",2)
	.s AdmLocDesc=$p(^CTLOC(AdmLoc),"^",2)
	.s:AdmLocDesc["-" AdmLocDesc=$p(AdmLocDesc,"-",2)
	.s itmmast=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),1),"^",2)
	.s inci=$o(^INCI(0,"ARCIM_DR",$p(itmmast,"||",1),""))
	.s code=$p(^INCI(+inci,1),"^",1)   //代码
	.s desc=$p(^INCI(+inci,1),"^",2)   //描述
	.s num=num+1
	.s tmpstr=PatName_"^"_desc_"^"_qty_"^"_buom_"^"_AdmLocDesc
	.s tmpstr=tmpstr_"^"_PatNo_"^"_sp_"^"_prescno
	.s ^TMP("DHCST","web.DHCST.LocItmTransMove","QueryBusDetail",pid,num)=tmpstr
	q ""
}

/// Creator:bianshuai
/// CreateDate;2014-04-28
/// Descript:返回主信息
/// w ##Class(web.DHCST.LocItmTransMove).getTempPrintData("5290")
ClassMethod getTempPrintData(pid, num) As %String
{
	n (pid, num)
	s temp=""
	i num="" d
	.s temp=$g(^TMP("DHCST","web.DHCST.LocItmTransMove","QueryBusDetail",pid)) 
	e  d
	.s temp=$g(^TMP("DHCST","web.DHCST.LocItmTransMove","QueryBusDetail",pid,num))
	q temp
}

/// Creator:bianshuai
/// CreateDate;2014-04-28
/// Descript:取批次有效期
ClassMethod getBatNo(inclb) As %String
{
	n (inclb)
	s incib=$p(^INCI(+inclb,"IL",$p(inclb,"||",2),"LB",$p(inclb,"||",3)),"^",1) ;批次指针
	s batstr=""
	i incib'=""  d
	.s batno=$p(^INCI(+incib,"IB",$p(incib,"||",2)),"^",1)
	.s expdate=$p(^INCI(+incib,"IB",$p(incib,"||",2)),"^",2)
	.s:expdate'="" expdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(expdate,"ST")
	.s batstr=batno_"~"_expdate
	q $g(batstr)
}

/// Creator:bianshuai
/// CreateDate;2014-04-28
/// Descript:清除临时global
ClassMethod killTempGlobal(pid) As %String
{
	n (pid)
	k ^TMP("DHCST","web.DHCST.LocItmTransMove","QueryBusDetail",pid)
	q ""
}

/// Creator:bianshuai
/// CreateDate;2014-04-28
/// Descript:取用户名称
ClassMethod GetUserName(UserDr As %String) As %String
{
	N (UserDr)
	Q:UserDr="" ""
	s UserName=$P($G(^SSU("SSUSR",UserDr)),"^",2)
	Q UserName
}

/// Creator:bianshuai
/// CreateDate;2014-04-28
/// Descript:定义日期格式
ClassMethod SetDateFmt(DateH As %String) As %String
{
	N (DateH)
	Q:DateH="" ""
	q ##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(DateH,"ST")
}

/// Descript: 查询全院库存
/// Creator: hulihua
/// CreateDate: 2013-12-31
/// Table:
/// Input:开始行,每页记录数,INC_ItmLoc表id
/// Output:
/// Return：科室^单位^数量 
/// w ##class(web.DHCST.LocItmTransMove).LocItmDayTotalDetail(0,30,"1273||8")
ClassMethod LocItmDayTotalDetail(Start, Limit, INCIL) As %Library.String
{
    n (Start,Limit,INCIL)
	q:INCIL="" ""
	s pid=..NewPid()
	s End=Start+Limit
	s Inci=+INCIL
	s inci=$p(INCIL,"||",1)
	Q:inci="" 0
    s ctuom=$p(^INCI(inci,1),"^",10) //
    s pctuom=$p(^INCI(inci,3),"^",6)
    s loc=$p(^INCI(inci,"IL",$p(INCIL,"||",2)),"^",1)
    s hospid=""
    i loc'="" s hospid=$p(^CTLOC(loc),"^",22)
    s factor=##class(web.DHCST.Common.UtilCommon).UOMFac(pctuom,ctuom)
    s pctuom=$p(^CT("UOM",pctuom),"^",2)
    //s dispensing="D"
    &sql(declare locitm cursor for select INCIL_CTLOC_DR->ctloc_desc,incil_maxqty,incil_minqty,incil_repqty,INCIL_CTLOC_DR from inc_itmloc
    where INCIL_INCI_ParRef=:inci )
    s DetailInfo = ""
    Set json = ##class(Code.JsonObj).%New()
    s Data="^"_pctuom_"^^^"
	s Num=1,Tqty=0
    &sql(open locitm)
    f  &sql(fetch locitm into :loc,:maxqty,:minqty,:repqty,:locid)  q:SQLCODE  d
    .q:hospid'=$p(^CTLOC(locid),"^",22)
	.s Num=Num+1
    .s qty=$$CurQtyU(inci,loc,pctuom)
    .s maxqty=maxqty/factor
    .s minqty=minqty/factor
    .s repqty=repqty/factor
    .//库存量数量格式输出
    .s qty=##class(web.DHCST.Common.AppCommon).FormatSq(qty,hospid,1,"G")
    .s Tqty=+qty+Tqty
    .s Data=loc_"^"_pctuom_"^"_+qty_"^"_maxqty_"^"_minqty_"^"_repqty
    .
 	.q:Num<=Start
 	.q:Num>End
    .d json.InsertRowData(Data)
    s Data="总计:^^"_+Tqty_"^^^"
    d json.InsertRowData(Data)
    
    s Title="loc^pctuom^qty^maxqty^minqty^repqty"
 	s DetailInfo=json.getJsonData(Title,Num)
    &sql(close locitm)
    k json 
 	q DetailInfo
    
CurQtyU(inci,locdesc,UOMDesc) ; Get the current qty according to item code and loc description
 n (inci,locdesc,UOMDesc)
 q:inci="" 0
 q:locdesc="" 0
 q:UOMDesc="" 0
 s loc=$$LocToRowID(locdesc)
 s UOM=$$CTUOMToID(UOMDesc) q:UOM="" 0 
 s BUOM=$p(^INCI(inci,1),"^",10) q:BUOM="" 0
 s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(UOM,BUOM)
 s dd=+$h
 s qty=$$IL(inci,loc,dd)
 s qty=qty/fac
 q qty
IL(inci,loc,dd) 
 ;ret value :
 ; <0 - error occurs
 n (inci,loc,dd)
 q:inci="" 0
 q:loc="" 0
 q:dd="" 0
 s nextdate=dd+1
 s rr=$o(^DHCLOCTOT(0,"LOCITMDATE",loc,inci,nextdate),-1)
 i rr="" q 0
 s rr=$o(^DHCLOCTOT(0,"LOCITMDATE",loc,inci,rr,""),-1)
 i rr="" q 0
 s qty=+$p(^DHCLOCTOT(rr),"^",4)
 q qty   
 
LocToRowID(TmpLoc) 
 s PP=""
 &sql( SELECT CTLOC_ROWID INTO :PP FROM CT_LOC WHERE CTLOC_DESC=:TmpLoc)
 q $g(PP)
CTUOMToID(MP) 
 n LL
 &sql(select ctuom_rowid into :LL From ct_uom where ctuom_desc=:MP)
 q $p($g(LL),$c(1))
}

/// creator:yunhaibao
/// createdate:2015-11-19
/// description:根据incil,date计算本期增加与减少的数量以及金额
/// w ##class(web.DHCST.LocItmTransMove).GetPlusMinusInfo("28322||11",63669,63682)
ClassMethod GetPlusMinusInfo(incilrowid, transsdate, transedate)
{
	n (incilrowid,transsdate,transedate)
	q:incilrowid="" ""
	s plusqty=0,minusqty=0,plusamt=0,minusamt=0
	s transinci=+incilrowid
	s transsdate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(transsdate)
	s transedate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(transedate)
	s baseuom=$p(^INCI(+incilrowid,1),"^",10)
	s purchuom=$p(^INCI(+incilrowid,3),"^",6)
	s bpfac=##class(web.DHCST.Common.UtilCommon).UOMFac(purchuom,baseuom)
	s zeroflag="true",cacudate=""
	f cacudate=transsdate:1:transedate d
	.s intr="" f  s intr=$o(^DHCINTR(0,"INCI",transinci,cacudate,intr)) q:intr=""  d
	..s transinclb=$p(^DHCINTR(intr),"^",7)
	..q:$g(transinclb)=""
	..s transincil=$p(transinclb,"||",1,2)
	..q:incilrowid'=transincil  //科室库存过滤 
	..s transincib=$p(^INCI(transinci,"IL",$p(transinclb,"||",2),"LB",$p(transinclb,"||",3)),"^",1) ;批次指针
	..s intrtype=$p(^DHCINTR(intr),"^",1)                                         ;交易类型
	..s intrpointer=$p(^DHCINTR(intr),"^",9) q:intrpointer=""                     ;交易指针
	..s intruom=$p(^DHCINTR(intr),"^",10)                                        ;交易单位
	..s intrqty=$p(^DHCINTR(intr),"^",6)                                         ;交易数量      
	..s intrfac=##class(web.DHCST.Common.UtilCommon).UOMFac(intruom,baseuom)
	..s intrqty=(intrqty*intrfac)/bpfac   ; qty of purchase uom
	..i intrqty'=0 s zeroflag="false"
	..s cacutype=""  //PLUS(增加),MINUS(减少)
	..i (intrtype="P")||(intrtype="F")||(intrtype="S")||(intrtype="T")||(intrtype="R")||(intrtype="D")||(intrtype="C")||((intrtype="A")&(intrqty<0))||(intrtype="X") d //s cacutype="MINUS"
	...s minusqty=minusqty+intrqty
	..e  i (intrtype="Y")||(intrtype="H")||(intrtype="Z")||(intrtype="K")||(intrtype="G")||((intrtype="A")&(intrqty>0))||(intrtype="M") d //s cacutype="PLUS"
	...s plusqty=plusqty+intrqty
	..q:intrtype="" 
	q plusqty_"^"_minusqty
}

/// Description:查询某药批次台帐信息用于库存查询的批次追踪界面（写于东营二院）
/// Creator:	hulihua
/// CreateDate:	2016-01-08
/// Table:      DHC_InTrans
/// Input:      开始行,每页记录数,排序字段,排序方式,开始日期,截至日期,批次ID,医院ID
/// Output:     业务ID,业务日期,摘要,增减数量,结余数量,进价(库存单位),售价(库存单位),增减金额(进价),增减金额(售价),处理号,处理人,操作人,备注
/// Return：    
/// w ##class(web.DHCST.LocItmTransMove).BatTransDetail("0","30","","","2020-02-06","2020-02-06","153||7||1","2")
ClassMethod BatTransDetail(Start, Limit, Sort, Dir, StartDate, EndDate, Inclb, HospId = "") As %Library.String
{
	n (Start,Limit,Sort,Dir,StartDate,EndDate,Inclb,HospId)
	//s ^YSJTMP("BatTransDetail")=$LB(Start,Limit,Sort,Dir,StartDate,EndDate,Inclb,HospId)
	i StartDate="" w ##class(web.DHCSTEXTCOMMON).GetNoJson()
	q:StartDate="" ""
	i EndDate="" w ##class(web.DHCSTEXTCOMMON).GetNoJson()
	q:EndDate="" ""
	i Inclb="" w ##class(web.DHCSTEXTCOMMON).GetNoJson()
	q:Inclb="" ""
	s Dir=$$ALPHAUP^SSUTIL4(Dir)
    s:(Dir="")&(Dir'="ASC")&(Dir'="DESC") Dir="DESC"
 	s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
 	s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
 	s pid=..NewPid()
 	s $zt="ErrorBatTransDetail"
	k ^TMP("DHCST","LocItmTransMove","BatTransDetail",pid)
	s BegQty=0
	s Inci=$p(Inclb,"||",1)
	s Incil=$p(Inclb,"||",1,2)
	s BUomId=$p(^INCI(Inci,1),"^",10)
	s PurUomId=$p(^INCI(Inci,3),"^",6)
	s Factor=##class(web.DHCST.Common.UtilCommon).UOMFac(PurUomId,BUomId)
	;计算开始日期前一天的结余数量
	s TmpDate=StartDate-1
	s PurUomRp=##class(web.DHCST.Common.PriceCommon).GetClbRp(Inclb,PurUomId,HospId,"G",StartDate,"")
	s PurUomSp=##class(web.DHCST.Common.PriceCommon).GetPriceElse(Inclb,StartDate,PurUomId,HospId,"G","")
	s BUomRp=##class(web.DHCST.Common.PriceCommon).GetClbRp(Inclb,BUomId,HospId,"G",StartDate,"")
	s BUomSp=##class(web.DHCST.Common.PriceCommon).GetPriceElse(Inclb,StartDate,BUomId,HospId,"G","")
	s BegQty=##class(web.DHCST.Common.DrugStkCommon).QtyINCLBUom(Inclb,BUomId,TmpDate)       ;期初库存（基本单位）
	s BegQtyUom=##class(web.DHCST.Common.DrugStkCommon).QtyWithUom(Inci,BegQty)              ;期初库存（带单位）
	//s BegRpAmt=##class(web.DHCST.Common.DrugStkCommon).GetRpAmt(Incil,TmpDate)
	//s BegSpAmt=##class(web.DHCST.Common.DrugStkCommon).GetSpAmt(Incil,TmpDate)
	s EndRpAmt=BegQty*BUomRp
	s EndSpAmt=BegQty*BUomSp
	s firsttime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(0,"ST")
	s Data1="^开始^^^"
	s Data2=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(StartDate,"ST")_"*"_firsttime_"^"_PurUomRp_"^"_PurUomSp_"^"_BegQty_"^"_BegQtyUom
	s Data3="^^"_""_"^"_""_"^"_"^"_EndRpAmt_"^"_EndSpAmt
	s Num=1
	s index="0"  
	s ^TMP("DHCST","LocItmTransMove","BatTransDetail",pid,0,index,Num)=Data1_"^"_Data2_"^"_Data3
	s EndQty=BegQty
	s BegQtyTmp=BegQty 
	f Date=StartDate:1:EndDate d
	.s TrId=""
	.f  s TrId=$o(^DHCINTR(0,"INCLB",Inclb,Date,TrId)) q:TrId=""  d
	..s TrType=$p(^DHCINTR(TrId),"^",1)
	..s TrDate=$p(^DHCINTR(TrId),"^",2)
	..s TrTime=$p(^DHCINTR(TrId),"^",3)
	..s:TrDate'="" TrDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(TrDate,"ST")
	..s:TrTime'="" TrTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(TrTime,"ST")
	..s TrUom=$p(^DHCINTR(TrId),"^",10)
	..s TrQty=$p(^DHCINTR(TrId),"^",6)
	..s TrPointer=$p(^DHCINTR(TrId),"^",9)  
 	..s TrUser=$p(^DHCINTR(TrId),"^",11)      ;交易人
 	..s OperateUser=""
 	..s:TrUser'="" OperateUser=$p($g(^SSU("SSUSR",TrUser)),"^",2) 
 	..s TrNo=$p(^DHCINTR(TrId),"^",13)          ;业务号
	..s TrSp=$p(^DHCINTR(TrId),"^",14)          ;业务发生的售价
 	..s TrRp=$p(^DHCINTR(TrId),"^",16)          ;业务发生的进价
 	..s TrRpAmt=$p(^DHCINTR(TrId),"^",17)       ;进价金额
 	..i TrRp="" s TrRp=##class(web.DHCST.Common.PriceCommon).GetClbRp(Inclb,TrUom,HospId,"G",Date,"") 
    ..i TrRpAmt="" s TrRpAmt=TrRp*TrQty
 	..s TrSpAmt=$p(^DHCINTR(TrId),"^",8)        ;售价金额
 	..s StkQty=$p(^DHCINTR(TrId),"^",18)        ;结余库存量
 	..s StkLbQty=$p(^DHCINTR(TrId),"^",19)      ;结余库存量(批次)
 	..s FacTr=##class(web.DHCST.Common.UtilCommon).UOMFac(TrUom,BUomId)
 	..s TrQtyB=TrQty*FacTr				        ;基本单位数量
 	..s BUomSp=TrSp/FacTr				        ;基本单位售价
 	..s PurUomSp=BUomSp*Factor			        ;包装单位售价
 	..s BUomRp=TrRp/FacTr                       ;批次进价(基本单位)
 	..s PurUomRp=BUomRp*Factor                  ;批次进价(包装单位)
 	..i TrUom=PurUomId d
 	...s PurUomRp=TrRp
 	...s PurUomSp=TrSp
 	..s PurUomRp=##class(web.DHCST.Common.AppCommon).FormatRp(PurUomRp,HospId,1,"G")
    ..s PurUomSp=##class(web.DHCST.Common.AppCommon).FormatSp(PurUomSp,HospId,1,"G")
 	..s EndQty=StkQty                           ;本条记录的结余库存
	..s EndQty=BegQtyTmp-((-1)*TrQtyB)          ;由于INTR_StkQty（结余库存量）和INTR_LbQty（结余库存量(批次)）字段没有在门诊住院发药表里插入，修改此处已显示结余数量 add wyx 2013-09-25
 	..s BegQtyTmp=BegQtyTmp-((-1)*TrQtyB)
 	..s EndQtyUom=##class(web.DHCST.Common.DrugStkCommon).QtyWithUom(+Inclb,EndQty)
 	..s TrQtyUom=##class(web.DHCST.Common.DrugStkCommon).QtyWithUom(+Inclb,TrQtyB)
 	..s EndRpAmt=EndRpAmt+TrRpAmt
 	..s EndSpAmt=EndSpAmt+TrSpAmt
 	..//获取业务数据
    ..s TrInfo=..GetTrInfo(TrPointer, TrType)
    ..s TrMsg=$p(TrInfo,"^",1)
    ..s TrAdm=$p(TrInfo,"^",2)
    ..s TrMark=$p(TrInfo,"^",3)
    ..s TrInfoNo=$p(TrInfo,"^",4)
    ..s:TrInfoNo'="" TrNo=TrInfoNo
 	..s Data1=TrId_"^"_TrMsg_"^"_TrNo_"^"_TrAdm_"^"_TrMark
 	..s Data2=TrDate_"*"_TrTime_"^"_PurUomRp_"^"_PurUomSp_"^"_EndQty_"^"_EndQtyUom
 	..s Data3=TrQtyB_"^"_TrQtyUom_"^"_TrRpAmt_"^"_TrSpAmt_"^"_$g(OperateUser)_"^"_EndRpAmt_"^"_EndSpAmt
 	..s Data=Data1_"^"_Data2_"^"_Data3
 	..s Num=Num+1
 	..s index=1  //排序用
 	..i Sort="TrId" s index=TrId
 	..e  i Sort="TrDate" s index=TrDate_"*"_TrTime
 	..e  i Sort="PurUomSp" s index=PurUomSp
 	..e  i Sort="PurUomRp" s index=PurUomRp
 	..e  i Sort="EndQty" s index=EndQty
 	..e  i Sort="TrQtyB" s index=TrQtyB
 	..e  i Sort="TrSpAm" s index=TrSpAmt
 	..e  i Sort="TrRpAmt" s index=TrRpAmt
 	..e  i Sort="TrNo" s index=TrNo
 	..e  i Sort="TrAdm" s index=TrAdm
 	..e  i Sort="TrMsg" s index=TrMsg
 	..e  i Sort="OperateUser" s index=OperateUser
 	..i index="" s index=1
 	..s ^TMP("DHCST","LocItmTransMove","BatTransDetail",pid,1,index,Num)=Data
 	s End=Start+Limit
	s Start=Start+1
	s count = 0
	s Title1="TrId^TrMsg^TrNo^TrAdm^TrMark"
 	s Title2="TrDate^PurUomRp^PurUomSp^EndQty^EndQtyUom"
 	s Title3="TrQtyB^TrQtyUom^TrRpAmt^TrSpAmt^OperateUser^EndRpAmt^EndSpAmt"
 	s Title=Title1_"^"_Title2_"^"_Title3
	i Dir="DESC" s orderflag="1" //正序
	e  s orderflag="-1" //倒序
	s outputi=""
	f  s outputi=$o(^TMP("DHCST","LocItmTransMove","BatTransDetail",pid,outputi)) q:outputi=""  d
	.s outputj=""
	.f  s outputj=$o(^TMP("DHCST","LocItmTransMove","BatTransDetail",pid,outputi,outputj),orderflag) q:outputj=""  d
	..s outputk=""
	..f  s outputk=$o(^TMP("DHCST","LocItmTransMove","BatTransDetail",pid,outputi,outputj,outputk),orderflag) q:outputk=""  d
	...s outputdata=^TMP("DHCST","LocItmTransMove","BatTransDetail",pid,outputi,outputj,outputk)
	...s count=count+1
	...q:count<Start
	...q:count>End
	...i count=Start d
	....w ##class(web.DHCSTEXTCOMMON).GetJsonStartString(Num)
	....s retstring=##class(web.DHCST.Common.UtilCommon).GetJsonStr(outputdata,Title)
	....w retstring
	...e  d
	....s retstring=##class(web.DHCST.Common.UtilCommon).GetJsonStr(outputdata,Title)
	....w ","_retstring
	w "]}"  //如果不报错,至少有一条记录
	k ^TMP("DHCST","LocItmTransMove","BatTransDetail",pid)
	q ""
 	
ErrorBatTransDetail  //write形式弊端,错误报不出去,但临时global一定在报错时k掉
 k ^TMP("DHCST","LocItmTransMove","BatTransDetail",pid)
 q $ze
}

/// Description:获取某台帐业务的相关数据（写于东营二院）
/// Creator:	hulihua
/// CreateDate:	2016-01-08
/// Table:      DHC_InTrans
/// Input:      业务指针-TrPointer,TrType-业务类型
/// Output:     
/// Return：    业务描述，处理相关部门（人），备注    
/// w ##class(web.DHCST.LocItmTransMove).GetTrInfo("361||1","G")
ClassMethod GetTrInfo(TrPointer, TrType) As %String
{
	n (TrPointer, TrType)
	s ^tmpdhy("GetTrInfo")=TrPointer_","_TrType
 	s TrAdm="BX",TrMark=""
 	;
 	i TrType="P" d
 	.s TrMsg="住院发药"        ;摘要
 	.s oeori=..GetPHPORI(TrPointer)
 	.s OrdInfo=..GetOrdInfo(oeori)
 	.s TrAdm=$p(OrdInfo,"^",1)
 	.s TrNo=$p(OrdInfo,"^",2)
 	;
 	i TrType="Y" d
 	.s TrMsg="住院退药"       			
 	.s oeori=..GetPHYORI(TrPointer)
 	.s OrdInfo=..GetOrdInfo(oeori)
 	.s TrAdm=$p(OrdInfo,"^",1)
 	.s TrNo=$p(OrdInfo,"^",2)
 	;
 	i TrType="F" d
 	.s TrMsg="门诊发药"       			
 	.s oeori=..GetORI(TrPointer)
 	.s OrdInfo=..GetOrdInfo(oeori)
 	.s TrAdm=$p(OrdInfo,"^",1)
 	.s TrNo=$p(OrdInfo,"^",2)
    ;
 	i TrType="H" d
 	.s TrMsg="门诊退药"
	.s oeori=..GetRetORI(TrPointer)
	.s OrdInfo=..GetOrdInfo(oeori)
	.s TrAdm=$p(OrdInfo,"^",1)
 	.s TrNo=$p(OrdInfo,"^",2)
 	
 	i TrType="HC" d
 	.s TrMsg="门诊撤消退药"
	.s oeori=..GetRetORI(TrPointer)
	.s OrdInfo=..GetOrdInfo(oeori)
	.s TrAdm=$p(OrdInfo,"^",1)
 	.s TrNo=$p(OrdInfo,"^",2)
 	;
	i TrType="S" d
 	.s TrMsg="门诊非正常发药"
 	.q:'$d(^DHCINAD($p(TrPointer,"||",1)))
 	.q:'$d(^SSU("SSUSR",$p(^DHCINAD($p(TrPointer,"||",1)),"^",3)))
 	.s TrAdm=$p(^SSU("SSUSR",$p(^DHCINAD($p(TrPointer,"||",1)),"^",3)),"^",2)
	;
	i TrType="Z" d
 	.s TrMsg="门诊非正常退药"
 	.q:'$d(^DHCINAD($p(TrPointer,"||",1)))
 	.q:'$d(^SSU("SSUSR",$p(^DHCINAD($p(TrPointer,"||",1)),"^",3)))
 	.s TrAdm=$p(^SSU("SSUSR",$p(^DHCINAD($p(TrPointer,"||",1)),"^",3)),"^",2)
	;
 	i TrType="K" d
 	.s TrMsg="转移入库" 
 	.q:'$d(^DHCINIT($p(TrPointer,"||",1)))
 	.q:$p(^DHCINIT($p(TrPointer,"||",1)),"^",5)=""
 	.s TrAdm=$p(^CTLOC($p(^DHCINIT($p(TrPointer,"||",1)),"^",5)),"^",2)   ;出库科室
 	.s status=$p(^DHCINIT($p(TrPointer,"||",1)),"^",14)
	.i (status=30)||(status=40) s TrMsg="转移入库(拒绝接收)"

	;
 	i (TrType="T")!(TrType="I") d
 	.s TrMsg="转移出库"
 	.q:'$d(^DHCINIT($p(TrPointer,"||",1)))
 	.q:$p(^DHCINIT($p(TrPointer,"||",1)),"^",6)=""
 	.s TrAdm=$p(^CTLOC($p(^DHCINIT($p(TrPointer,"||",1)),"^",6)),"^",2)    ;转入科室
 	.s TrMark=$P(^DHCINIT(+TrPointer,"ITI",$P(TrPointer,"||",2)),"^",24)
	;
 	i TrType="G" d
 	.s TrMsg="入库"
 	.q:'$d(^DHCINGR($p(TrPointer,"||",1)))
 	.q:$p(^DHCINGR($p(TrPointer,"||",1)),"^",8)=""
 	.s TrAdm=$p(^SSU("SSUSR",$p(^DHCINGR($p(TrPointer,"||",1)),"^",8)),"^",2) 
 	.s TrMark=$G(^DHCINGR($p(TrPointer,"||",1),"GRI",$p(TrPointer,"||",2),"REM",1))
	;
 	i (TrType="D")!(TrType="C") d
 	.s TrMsg="库存报损"
 	.s INSPId=$p(TrPointer,"||",1)
 	.q:'$d(^DHCINSP(INSPId))
 	.q:$p(^DHCINSP(INSPId),"^",6)=""
 	.s TrAdm=$p(^SSU("SSUSR",$p(^DHCINSP(INSPId),"^",6)),"^",2)
	;
 	i TrType="A" d
 	.s TrMsg="库存调整"
 	.q:'$d(^DHCINAD($p(TrPointer,"||",1)))
 	.q:$p(^DHCINAD($p(TrPointer,"||",1)),"^",3)=""
 	.s TrAdm=$p(^SSU("SSUSR",$p(^DHCINAD($p(TrPointer,"||",1)),"^",3)),"^",2)
	;
 	i TrType="R" d
 	.s TrMsg="退货"
 	.s INGRT=$p(TrPointer,"||",1)
 	.q:INGRT=""
 	.q:'$d(^INGRT(INGRT))
 	.q:$p(^INGRT(INGRT),"^",5)=""
 	.s TrAdm=$p($g(^SSU("SSUSR",$p(^INGRT(INGRT),"^",5))),"^",2)
	;
 	i TrType="M" d
 	.s TrMsg="制剂生成"
 	.q:'$d(^DHCINMAN(TrPointer))
 	.s Manuser=$p(^DHCINMAN(TrPointer),"^",23)
 	.q:Manuser=""
 	.s TrAdm=$p(^SSU("SSUSR",Manuser),"^",2)
	;
 	i TrType="X" d
 	.s TrMsg="制剂消耗"
 	.q:'$d(^DHCINMAN(+TrPointer)) 
 	.s Manuser=$p(^DHCINMAN(+TrPointer),"^",23)
 	.q:Manuser=""
 	.s TrAdm=$p(^SSU("SSUSR",Manuser),"^",2)
 	s TrInfo=TrMsg_"^"_TrAdm_"^"_TrMark_"^"_$g(TrNo)
 	q TrInfo
}

/// Description:获取某台帐业务（P）对应的住院发药医嘱ID（写于东营二院）
/// Creator:	hulihua
/// CreateDate:	2016-01-08
/// Table:      DHC_PHACollectItm,OE_OrdItem
/// Input:      业务指针-Pointer即住院发药孙表ID
/// Output:     
/// Return：    医嘱ID    
/// w ##class(web.DHCSTCOMMONSRV).GetPHPORI("122482||4||1")
ClassMethod GetPHPORI(PHDISPEN) As %String
{
	 n (PHDISPEN)
	 q:PHDISPEN="" ""
	 s mmm=$p(PHDISPEN,"||",1),ddd=$P(PHDISPEN,"||",2)
	 q:ddd="" ""
	 q:'$d(^DHCPHAC(mmm,"I",ddd)) ""
	 s oeori=$p(^DHCPHAC(mmm,"I",ddd),"^",7)
	 q oeori
}

/// Description:获取某台帐业务（Y）对应的住院退药医嘱ID（写于东营二院）
/// Creator:	hulihua
/// CreateDate:	2016-01-08
/// Table:      DHC_PhaReturnItmLB,OE_OrdItem
/// Input:      业务指针-Pointer即住院退药孙表ID
/// Output:     
/// Return：    医嘱ID    
/// w ##class(web.DHCSTCOMMONSRV).GetPHYORI("60389||22||1")
ClassMethod GetPHYORI(PHRetI) As %String
{
	 n (PHRetI)
	 q:PHRetI="" ""        
	 s mmm=$P(PHRetI,"||",1),ddd=$P(PHRetI,"||",2)
	 q:'$d(^PHARET(mmm,"I",ddd)) ""
	 s oeori=$p(^PHARET(mmm,"I",ddd),"^",1)
	 q oeori
}

/// Description:获取某台帐业务（F）对应的门诊发药医嘱ID（写于东营二院）
/// Creator:	hulihua
/// CreateDate:	2016-01-08
/// Table:      DHC_PHDISITMCLB,OE_OrdItem
/// Input:      业务指针-Pointer即门诊发药孙表ID
/// Output:     
/// Return：    医嘱ID    
/// w ##class(web.DHCSTCOMMONSRV).GetORI("1338554||1||1")
ClassMethod GetORI(PHDISPEN) As %String
{
	 n (PHDISPEN)
	 q:PHDISPEN="" ""        
	 s mmm=$P(PHDISPEN,"||",1),ddd=$P(PHDISPEN,"||",2)
	 q:'$d(^DHCPHDI(mmm,"PHDI",ddd)) ""
	 s oeori=$p(^DHCPHDI(mmm,"PHDI",ddd),"^",5)
	 q oeori
}

/// Description:获取某台帐业务（H）对应的门诊退药医嘱ID（写于东营二院）
/// Creator:	hulihua
/// CreateDate:	2016-01-08
/// Table:      DHC_PHRETITM,OE_OrdItem
/// Input:      业务指针-Pointer即门诊退药子表ID
/// Output:     
/// Return：    医嘱ID    
ClassMethod GetRetORI(PHRetI) As %String
{
       
	 n (PHRetI)
	 q:PHRetI="" ""        
	 s mmm=$P(PHRetI,"||",1),ddd=$P(PHRetI,"||",2)
	 q:'$d(^DHCPHRTI(mmm,"RTI",ddd)) ""
	 s oeori=$p(^DHCPHRTI(mmm,"RTI",ddd),"^",2)
	 q oeori
}

/// Description:获取某台帐业务（PH,FH）对应的草药住院/门诊发药医嘱ID
/// Creator:	zhaozhiduan
/// CreateDate:	2021-09-07
/// Table:      BS_PHA_HERB.DISITEM ,OE_OrdItem
/// Input:      业务指针-Pointer即草药住院/门诊发药子表ID
/// Output:     
/// Return：    医嘱ID  
ClassMethod GetCYDispOrdItm(phbdSubId)
{
	n (phbdSubId)
	q:phbdSubId="" ""        
	s phbdId=$P(phbdSubId,"||",1),phbdSub=$P(phbdSubId,"||",2)
	q:'$d(^BS.PHA.HERB.DISPEND(phbdId,"I",phbdSub)) ""
	s oeori = $lg(^BS.PHA.HERB.DISPEND(phbdId,"I",phbdSub), 3)
	q oeori
}

/// Description:获取某台帐业务（YH,HH）对应的草药住院/门诊退药医嘱ID
/// Creator:	zhaozhiduan
/// CreateDate:	2021-09-07
/// Table:      BS.PHA.HERB.RETURNITEM ,OE_OrdItem
/// Input:      业务指针-Pointer即草药住院/门诊退药子表ID
/// Output:     
/// Return：    医嘱ID  
ClassMethod GetCYRetOrdItm(phbrSubId)
{
	n (phbrSubId)
	q:phbrSubId="" ""        
	s phbrId=$P(phbrSubId,"||",1),phbrSub=$P(phbrSubId,"||",2)
	q:'$d(^BS.PHA.HERB.RETURND(phbrId,"I",phbrSub)) ""
	s oeori=$lg(^BS.PHA.HERB.RETURND(phbrId,"I",phbrSub), 2)
	q oeori
}

/// w ##class(web.DHCST.LocItmTransMove).Test("1||1||1")
ClassMethod Test(phaclb)
{
	s pid=1
	s ^ljq("OutDisp")=phaclb
	s phac=+phaclb
 	q:'$d(^DHCPHDISP(phac))
	//s phacno=$p(^DHCPHDISP(phac),"^",14)                  //发药单号
	s cdate=..SetDateFmt($p(^DHCPHDISP(phac),"^",3))      //发药日期 
	s userDr=$p(^DHCPHDISP(phac,1),"^",2)
	s fyuserdr=$p(^DHCPHPER(userDr),"^",5)
	s cuser=..GetUserName(fyuserdr)     //发药人
	s locdr=$p(^DHCPHDISP(phac,1),"^",1)
	s phalocDr=$p(^DHCPHLOC(locdr),"^",1)
	s:phalocDr'="" phaloc=$p(^CTLOC(phalocDr),"^",2)          //供给科室
	s:$g(phaloc)["-" phaloc=$p(phaloc,"-",2)
	s mainstr="发药科室:"_$g(phaloc)_"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
	s mainstr=mainstr_"<br>发药日期:"_cdate_"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;发药人:"_cuser
	s ^TMP("DHCST","web.DHCST.LocItmTransMove","QueryBusDetail",pid)=mainstr
	
	///表头
	s tmpstr="姓名^名称^数量^单位^科室^登记号^售价^处方"
	s ^TMP("DHCST","web.DHCST.LocItmTransMove","QueryBusDetail",pid,1)=tmpstr
	s ch="",num=1
	f  s ch=$o(^DHCPHDI(phac,"PHDI",ch)) q:ch=""  d
	.s PapmiId=$p(^DHCPHDISP(phac),"^",7)
	.s prescno=$p(^DHCPHDISP(phac,2),"^",1)
	.s qty=$p(^DHCPHDI(phac,"PHDI",ch),"^",4)
	.s sp=$p(^DHCPHDI(phac,"PHDI",ch),"^",11)
	.s PatName=$p(^PAPER(PapmiId,"ALL"),"^",1) 
	.s PatNo=$p(^PAPER(PapmiId,"PAT",1),"^",1)
	.s oeori=$p(^DHCPHDI(phac,"PHDI",ch),"^",5)
	.s AdmLoc=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),1),"^",8)
	.s AdmLocDesc=$p(^CTLOC(AdmLoc),"^",2)
	.s:AdmLocDesc["-" AdmLocDesc=$p(AdmLocDesc,"-",2)
	.s itmmast=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),1),"^",2)
	.s inci=$o(^INCI(0,"ARCIM_DR",$p(itmmast,"||",1),""))
	.s buomdr=$p(^INCI(inci,1),"^",10)
	.s:buomdr'="" buom=$p(^CT("UOM",buomdr),"^",2)
	.s code=$p(^INCI(+inci,1),"^",1)   //代码
	.s desc=$p(^INCI(+inci,1),"^",2)   //描述
	.s puomdr=$p($g(^OEORD(+oeori,"I",$p(oeori,"||",2),"DHC")),"^",13)
	.s:puomdr'="" buom=$p(^CT("UOM",puomdr),"^",2)
	.s lb=0
	.f  s lb=$o(^DHCPHDI(phac,"PHDI",ch,"INCLB",lb)) q:lb=""  d
	..s inclb=$p(^DHCPHDI(phac,"PHDI",ch,"INCLB",lb),"^",3)
	..s qty=$p(^DHCPHDI(phac,"PHDI",ch,"INCLB",lb),"^",1)
	..s sp=$p(^DHCPHDI(phac,"PHDI",ch,"INCLB",lb),"^",7)
	..s code=$p(^INCI(+inclb,1),"^",1)   //代码
	..s desc=$p(^INCI(+inclb,1),"^",2)   //描述
	..s buomdr=$p(^INCI(+inclb,1),"^",10)
	..s:buomdr'="" buom=$p(^CT("UOM",buomdr),"^",2)
	..s num=num+1
	..s tmpstr=PatName_"^"_desc_"^"_qty_"^"_buom_"^"_AdmLocDesc
	..s tmpstr=tmpstr_"^"_PatNo_"^"_sp_"^"_prescno
	..s ^TMP("DHCST","web.DHCST.LocItmTransMove","QueryBusDetail",pid,num)=tmpstr
	q ""
}

/// Description:获取某台帐业务对应的损益
/// Creator:	liangjiaquan
/// CreateDate:	2018-11-27
/// Table:      DHC_RetAspAmount
/// Input:      业务类型-Type,业务指针-Pointer
/// Output:     
/// Return：    进价损益金额^售价损益金额   
/// w ##class(web.DHCST.LocItmTransMove).GetRetAspDetail("F","276||1||1")
ClassMethod GetRetAspDetail(Type, Pointer) As %String
{
	 n (Type,Pointer)
	 s Ret=""
	 q:(Type="")!(Pointer="") Ret        
	 s RetID="",RpAmt="",SpAmt=""
	 f  s RetID=$o(^DHCRETA(0,"TypePointer",Type,Pointer,RetID)) q:RetID=""  d
	 .s RpAmt=$p(^DHCRETA(RetID),"^",12)
	 .s SpAmt=$p(^DHCRETA(RetID),"^",5)
	 q:(RpAmt="")&&(SpAmt="") Ret
	 s Ret=RpAmt_"^"_SpAmt
	 q Ret
}

}
