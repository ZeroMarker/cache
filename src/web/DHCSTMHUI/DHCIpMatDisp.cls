Import sqluser

/// Creator: lihui
/// CreatDate: 20180629
/// Description: 住院材料批次售价实库存处理
Class web.DHCSTMHUI.DHCIpMatDisp Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Creator: lihui
/// CreatDate: 20180629
/// Description: 根据登记号查询住院材料执行记录
/// Table: DHC_OEDispensing,INC_Itm
/// Input: 当前科室,查询条件(开始日期^截止日期^登记号)
/// Output: 物资代码,物资名称,规格,单位,单价,金额,数量,医嘱状态,医师,货位,厂家,库存量
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCIpMatDisp","QueryIpMatDispDetail",193,"2017-01-01^2018-06-06^")
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCIpMatDisp","QueryIpMatDispDetailByPatNo","43^2018-07-31^2018-07-31^0000830401")
Query QueryIpMatDispDetailByPatNo(Params As %String) As Query(ROWSPEC = "DSPRowId,orditm,regno,patname,inci,incicode,incidesc,qty:%Float,dispUomdr,dispUomDesc,Sp:%Float,SpAmt:%Float,orditm,oeflag,orduserName,stkbin,avaQty:%Float,manf,hvFlag,barCode,dspstatus,reservedQty:%Float,logQty:%Float,exestdatetime,ADMNo")
{
}

ClassMethod QueryIpMatDispDetailByPatNoExecute(ByRef QHandle As %Binary, Params As %Library.String) As %Status
{
	n (QHandle,Params)
	s repid=$I(^CacheTemp)
	s QHandle=$lb(0,repid,0)
	s ind=1
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0  q $$$OK
	s LocId=PJObj.%Get("WardLoc")
	s PatNo=PJObj.%Get("PatNo")
	q:LocId="" $$$OK
	s PAPMIId=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(PatNo),""))
	q:PAPMIId="" $$$OK
	s admDr=""
	f  s admDr=$o(^PAPERdr(PAPMIId,"ADM","I",admDr)) q:admDr=""  d
	.s visitstatus=$p(^PAADM(admDr),"^",20)
	.q:(visitstatus'="A")
	.s ord =""
 	.f  s ord=$O(^OEORD(0,"Adm",admDr,ord)) q:ord=""  d 
 	..q:'$d(^OEORD(ord))
 	..s PAPMIId = $p($G(^PAADM(admDr)),"^",1)
 	..s ADMNo = $p($G(^PAADM(admDr)),"^",81)
 	..s patname = $p($G(^PAPER(PAPMIId,"ALL")),"^",1)
 	..s itm = ""
 	..f   s itm=$O(^OEORDi(0,"RecDepOrd",ord,LocId,itm)) q:itm=""  d
 	...q:'$d(^OEORD(ord,"I",itm))
 	...s arcitm=$p(^OEORD(ord,"I",itm,1),"^",2)		//医嘱项
 	...s inci=$o(^INCI(0,"ARCIM_DR",$p(arcitm,"||",1),""))
 	...q:inci=""
 	...s stkCatGrpType=##class(web.DHCSTMHUI.Common.DHCSTPCHCOLLSM).GetItmStkGrpType(inci)
 	...q:stkCatGrpType'="M"	//非材料医嘱退出
 	...s oeflag=$p(^OEC("OSTAT",$p(^OEORD(ord,"I",itm,1),"^",13)),"^",1) 	//医嘱状态
 	...q:(oeflag'="V")&&(oeflag'="E")&&(oeflag'="D")&&(oeflag'="C")	//未发放时判断医嘱是否是执行或核实状态  ????
 	...s payflag=$p(^OEORD(ord,"I",itm,3),"^",5)		//结算状态  ????
 	...s oeflag=$p(^OEC("OSTAT",$p(^OEORD(ord,"I",itm,1),"^",13)),"^",2)
 	...s priority=$p(^OEORD(ord,"I",itm,1),"^",8)	//医嘱类型 
 	...i priority'="" s priordesc=$p(^OECPR(priority),"^",2)
 	...q:priordesc["自备"
 	...i priority'="" s priorcode=$p(^OECPR(priority),"^",1)
 	...q:priorcode["OM" 
 	...s orditm=ord_"||"_itm
 	...s DSPRowId=""
 	...f  s DSPRowId=$o(^DHCOEDISQTY(0,"OEORI",orditm,DSPRowId)) q:DSPRowId=""  d
 	....q:'$d(^DHCOEDISQTY(DSPRowId))
 	....s DHCOEDISQTYinfo=^DHCOEDISQTY(DSPRowId)
 	....s dspstatus=$p(^DHCOEDISQTY(DSPRowId),"^",7) ;未发放状态
 	....q:(dspstatus'="TC")
 	....;判断打包表插入时间和切换时间
 	....s tDate=$P(DHCOEDISQTYinfo,"^",15)
	....s tTime=$P(DHCOEDISQTYinfo,"^",16)
	....s tDateTime=tDate*100000+tTime
	....q:(tDateTime<6486448205)
 	....s ordexec=$p(DHCOEDISQTYinfo,"^",3)
 	....s ord=+ordexec
	....s itm=$p(ordexec,"||",2)
	....q:'$d(^OEORD(ord,"I",itm))
	....s exesub=$p(ordexec,"||",3)
 	....s execstatus=$p($g(^OEORD(ord,"I",itm,"X",exesub)),"^",16)
    ....i execstatus'="" s execStat=$p($g(^OEC("STAT",execstatus)),"^",1)
    ....e  s execStat=""
    ....q:execStat="D"  ;添加判断执行记录状态
    ....s exestdatetime=""
	....s exestdate=$p($g(^OEORD(ord,"I",itm,"X",exesub)),"^",1)
	....i exestdate'="" s exestdate=$zd(exestdate,3)
	....s exesttime=$p($g(^OEORD(ord,"I",itm,"X",exesub)),"^",2)
	....i exesttime'="" s exesttime=$zt(exesttime)
	....s exestdatetime=exestdate_" "_exesttime
 	....;判断打包表插入时间和切换时间
 	....s orduser=+$p(^OEORD(ord,"I",itm,7),"^",1)	//录医嘱人
 	....s orduserName=$p(^SSU("SSUSR",orduser),"^",2)
 	....s incicode=$p(^INCI(inci,1),"^",1)
 	....s incidesc=$p(^INCI(inci,1),"^",2)
 	....s qty=$p(DHCOEDISQTYinfo,"^",2)
 	....s dispUomdr=$p(DHCOEDISQTYinfo,"^",6)	;发放单位
 	....s dispUomDesc=$p($g(^CT("UOM",dispUomdr)),"^",2)
 	....s dspdate=$p(DHCOEDISQTYinfo,"^",8)
 	....i dspdate="" s dspdate=+$h
 	....s HospId=$p(^CTLOC(LocId),"^",22)
 	....s Sp=##Class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(inci,+dspdate,dispUomdr,HospId,"")
 	....s SpAmt=Sp*qty
 	....s SpAmt=##class(web.DHCSTMHUI.Common.AppCommon).FormatSp(SpAmt,HospId,2)
 	....s stkbin=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetInciBinStr(inci)	;货位
 	....s manf=$p(##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetManf(inci),"^",3) ;厂商
 	....s avaQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetAvaQty(LocId,inci,dispUomdr)
 	....s hvFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(inci)
 	....s reservedQty=0
 	....&sql(select INCIL_ReservedQty into :reservedQty from inc_itmloc where incil_ctloc_dr=:LocId and incil_inci_parref=:inci)
 	....s reservedQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyWithUom(inci,reservedQty)
 	....s barCode=$p($g(^OEORD(ord,"I",itm,"DHC")),"^",14)
 	....s logQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).LocDayQtyUom(inci,LocId,dispUomdr,+$h)
 	....s Data=$lb(DSPRowId,orditm,PatNo,patname,inci,incicode,incidesc,qty,dispUomdr,dispUomDesc,Sp,SpAmt,orditm,oeflag,orduserName,stkbin,avaQty,manf,hvFlag,barCode,dspstatus,reservedQty,logQty,exestdatetime,ADMNo)
 	....s ^CacheTemp(repid,ind)=Data
 	....s ind=ind+1
	Quit $$$OK
}

/// Creator: lihui
/// CreatDate: 20180629
/// Description: 根据日期查询住院材料执行记录
/// Table: DHC_OEDispensing,INC_Itm
/// Input: 当前科室,查询条件(开始日期^截止日期^登记号)
/// Output: 物资代码,物资名称,规格,单位,单价,金额,数量,医嘱状态,医师,货位,厂家,库存量
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCIpMatDisp","QueryIpMatDispDetailByDate","38^2018-03-02^2018-07-02^")
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCIpMatDisp","QueryIpMatDispDetailByDate","43^2018-07-01^2018-07-31^")
Query QueryIpMatDispDetailByDate(Params As %String) As Query(ROWSPEC = "DSPRowId,orditm,regno,patname,inci,incicode,incidesc,qty:%Float,dispUomdr,dispUomDesc,Sp:%Float,SpAmt:%Float,orditm,oeflag,orduserName,stkbin,avaQty:%Float,manf,hvFlag,barCode,dspstatus,reservedQty:%Float,logQty:%Float,exestdatetime,ADMNo")
{
}

ClassMethod QueryIpMatDispDetailByDateExecute(ByRef QHandle As %Binary, Params As %String) As %Status
{
	n (QHandle,Params)
	s repid=$I(^CacheTemp)
	s QHandle=$lb(0,repid,0)
	s ind=1
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0  q $$$OK
	s StartDate=PJObj.%Get("StartDate")
	s EndDate=PJObj.%Get("EndDate")
	s LocId=PJObj.%Get("WardLoc")
	s PatNo=PJObj.%Get("PatNo")
	q:LocId="" $$$OK
	s:StartDate["-" StartDate=$zdh(StartDate,3)
	;添加判断切换日期
	;i StartDate<64864 s StartDate=64864
	s:EndDate["-" EndDate=$zdh(EndDate,3)
	f date=StartDate:1:EndDate  d
	.s admDr=""
	.f  s admDr=$o(^DHCOEDISQTY(0,"ADM",LocId,date,"TC",admDr)) q:admDr=""  d
	..s PAPMIId = $p($G(^PAADM(admDr)),"^",1)
	..s ADMType = $p($G(^PAADM(admDr)),"^",2)
	..q:ADMType'="I"
	..s ADMNo = $p($G(^PAADM(admDr)),"^",81)
	..s patname = $p($G(^PAPER(PAPMIId,"ALL")),"^",1)
 	..s regno = $p($G(^PAPER(PAPMIId,"PAT",1)),"^",2)
	..s DSPRowId=""
	..f  s DSPRowId=$O(^DHCOEDISQTY(0,"ADM",LocId,date,"TC",admDr,DSPRowId)) q:DSPRowId=""  d
	...q:'$d(^DHCOEDISQTY(DSPRowId))
	...s DHCOEDISQTYinfo=^DHCOEDISQTY(DSPRowId)
	...s tDate=$P(DHCOEDISQTYinfo,"^",15)
	...s tTime=$P(DHCOEDISQTYinfo,"^",16)
	...s tDateTime=tDate*100000+tTime
	...q:(tDateTime<6486448205)
	...s orditm=$p(DHCOEDISQTYinfo,"^",1)
	...s ordexec=$p(DHCOEDISQTYinfo,"^",3)
	...q:orditm=""
	...s ord=+ordexec
	...s itm=$p(ordexec,"||",2)
	...q:itm=""
	...q:'$d(^OEORD(ord,"I",itm))
	...s exesub=$p(ordexec,"||",3)
	...s arcitm=$p(^OEORD(ord,"I",itm,1),"^",2)		//医嘱项
	...s inci=$o(^INCI(0,"ARCIM_DR",$p(arcitm,"||",1),""))
	...q:inci=""
	...q:'$d(^INCI(inci,1))
	...s stkCatGrpType=##class(web.DHCSTMHUI.Common.DHCSTPCHCOLLSM).GetItmStkGrpType(inci)
	...q:stkCatGrpType'="M"	//非材料医嘱退出
	...s oeflag=$p(^OEC("OSTAT",$p(^OEORD(ord,"I",itm,1),"^",13)),"^",1) 	//医嘱状态
	...q:(oeflag'="V")&&(oeflag'="E")&&(oeflag'="D")	//未发放时判断医嘱是否是执行或核实状态  ????
	...;添加判断执行记录状态
	...s execstatus=$p($g(^OEORD(ord,"I",itm,"X",exesub)),"^",16)
    ...i execstatus'="" s execStat=$p($g(^OEC("STAT",execstatus)),"^",1)
    ...e  s execStat=""
    ...q:execStat="D"
    ...s exestdatetime=""
	...s exestdate=$p($g(^OEORD(ord,"I",itm,"X",exesub)),"^",1)
	...i exestdate'="" s exestdate=$zd(exestdate,3)
	...s exesttime=$p($g(^OEORD(ord,"I",itm,"X",exesub)),"^",2)
	...i exesttime'="" s exesttime=$zt(exesttime)
	...s exestdatetime=exestdate_" "_exesttime
	...;添加判断执行记录状态
	...s payflag=$p(^OEORD(ord,"I",itm,3),"^",5)		//结算状态  ????
	...;q:(payflag="P")
	...s oeflag=$p(^OEC("OSTAT",$p(^OEORD(ord,"I",itm,1),"^",13)),"^",2)
	...s priority=$p(^OEORD(ord,"I",itm,1),"^",8)	//医嘱类型 
	...i priority'="" s priordesc=$p(^OECPR(priority),"^",2)
	...q:priordesc["自备"
	...i priority'="" s priorcode=$p(^OECPR(priority),"^",1)
	...q:priorcode["OM" ;????
	...s orduser=+$p(^OEORD(ord,"I",itm,7),"^",1)	//录医嘱人
	...s orduserName=$p(^SSU("SSUSR",orduser),"^",2)
	...s incicode=$p(^INCI(inci,1),"^",1)
	...s incidesc=$p(^INCI(inci,1),"^",2)
	...s qty=$p(DHCOEDISQTYinfo,"^",2)
	...s dispUomdr=$p(DHCOEDISQTYinfo,"^",6)	;发放单位
	...s dispUomDesc=$p($g(^CT("UOM",dispUomdr)),"^",2)
	...s dspdate=$p(DHCOEDISQTYinfo,"^",8)
	...i dspdate="" s dspdate=+$h
	...s HospId=$p(^CTLOC(LocId),"^",22)
	...s Sp=##Class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(inci,+dspdate,dispUomdr,HospId,"")
	...s SpAmt=Sp*qty
	...s SpAmt=##class(web.DHCSTMHUI.Common.AppCommon).FormatSp(SpAmt,HospId,2)
	...s stkbin=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetInciBinStr(inci)	;货位
	...s manf=$p(##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetManf(inci),"^",3) ;厂商
	...s avaQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetAvaQty(LocId,inci,dispUomdr)
	...s hvFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(inci)
	...s reservedQty=0
	...&sql(select INCIL_ReservedQty into :reservedQty from inc_itmloc where incil_ctloc_dr=:LocId and incil_inci_parref=:inci)
	...s reservedQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyWithUom(inci,reservedQty)
	...s barCode=$p($g(^OEORD(ord,"I",itm,"DHC")),"^",14)
	...s logQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).LocDayQtyUom(inci,LocId,dispUomdr,+$h)
	...s Data=$lb(DSPRowId,orditm,regno,patname,inci,incicode,incidesc,qty,dispUomdr,dispUomDesc,Sp,SpAmt,orditm,oeflag,orduserName,stkbin,avaQty,manf,hvFlag,barCode,dspstatus,reservedQty,logQty,exestdatetime,ADMNo)
	...s ^CacheTemp(repid,ind)=Data
	...s ind=ind+1
	Quit $$$OK
}

/// Descript: 材料扣库存处理(处理住院医嘱)
/// Creater: Lihui
/// CreateDate: 20220816
/// w ##class(web.DHCSTMHUI.DHCIpMatDisp).IPMatDisp("197","79882","6444")
ClassMethod jsIPMatDisp(Params As %Library.String)
{
	n (Params)
	s RtnObj=##class(RtnObj).%New()
	s $ZT=..sssError()
	s RtnObj=..IPMatDisp(Params)
	q RtnObj.Json()
}

/// Descript: 材料扣库存处理(处理住院医嘱)
/// Creater: Lihui
/// CreateDate: 20180630
/// w ##class(web.DHCSTMHUI.DHCIpMatDisp).IPMatDisp("197","79882","6444")
ClassMethod IPMatDisp(Params As %Library.String)
{
	n (Params)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0  q RtnObj.Err(-1,"","入参解析失败!")
	s CTLocid=PJObj.%Get("WardLoc")
	s userId=PJObj.%Get("gUserId")
	s DSPRowIdStr=PJObj.%Get("dispStr")
	i ((CTLocid="")||(userId="")||(DSPRowIdStr="")) q RtnObj.Err(-2,"","科室用户记录入参为空!","",0)
	
	s HospitalId=$p($G(^CTLOC(CTLocid)),"^",22) ;如果传入的为空取就诊科室
	s BatSpFlag=##class(web.DHCSTMHUI.DHCSTMSERVICE).GetBatSpFlag(HospitalId)
	s del="^"
	s len=$l(DSPRowIdStr,del)
	f i=1:1:len q:(RtnObj.success'=0)  d
	.s DSPRowId=$p(DSPRowIdStr,del,i)
	.q:'$d(^DHCOEDISQTY(DSPRowId))
	.s DHCOEDISQTYinfo=^DHCOEDISQTY(DSPRowId)
	.s OEOREDR=$p(DHCOEDISQTYinfo,"^",3)
	.q:OEOREDR=""
	.s orditm=$p(DHCOEDISQTYinfo,"^",1)
	.q:orditm=""
	.s ord=+orditm
	.s itm=$p(orditm,"||",2)
	.q:itm=""
	.q:'$d(^OEORD(ord,"I",itm))
	.s arcitm=$p(^OEORD(ord,"I",itm,1),"^",2)		//医嘱项
	.s inci=$o(^INCI(0,"ARCIM_DR",$p(arcitm,"||",1),""))
	.s incidesc=$p(^INCI(inci,1),"^",2)
	.i BatSpFlag=1 d
	..s IfExitDSPBat=..CheckDispBat(DSPRowId)
	..i IfExitDSPBat'=1 d
	...s RetInDSPBat=##class(web.DHCSTMHUI.DHCSTMSERVICE).InsDspBatch(DSPRowId,0,"")
	...i RetInDSPBat'=1 d RtnObj.Err(-1,"",incidesc_"插入批次在途失败")
	.q:RtnObj.success'=0
	.s RetDisp=##class(web.DHCSTMHUI.PCHCOLLSM).Disp(OEOREDR,"","ORDER")
	.i RetDisp'=0 d RtnObj.Err(-1,"",incidesc_"扣库存失败")
	.q:RtnObj.success'=0
   q RtnObj
}

/// Description: 检查发药打包表批次表明细是否存在
/// Creator: Lihui
/// CreatDate: 20180630
/// return: 0:不存在;1 存在;
/// w ##class(web.DHCSTMHUI.DHCIpMatDisp).CheckDispBat("5326||92")
ClassMethod CheckDispBat(DSPRowId As %Library.String) As %String
{
	n (DSPRowId)
	q:DSPRowId="" 0
	s Exitflag=0
   	s DSPBat="",count=0
   	f  s DSPBat=$o(^DHCOEDISQTY(DSPRowId,"I",DSPBat)) q:DSPBat=""  d
   	.s count=count+1
   	i count>0 s Exitflag=1
   	q Exitflag
}

}
