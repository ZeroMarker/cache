Import sqluser

/// Descript:价格信息相关的公共方法
/// Creater:	ZhangDongmei
/// CreateDate:	2012-05-03
Class web.DHCSTMHUI.Common.PriceCommon Extends (%RegisteredObject, %XML.Adaptor, web.DHCSTMHUI.StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:根据药品id和参数配置取进价
/// Creater:	ZhangDongmei
/// CreateDate:	2012-06-19
/// Table:
/// Input:库存项id,单位id,应用程序代码,安全组id^科室id^用户id^医院id
/// Output:		
/// Return：进价
/// (web.DHCSTMHUI.Common.PriceCommon).GetConfigRp
ClassMethod GetConfigRp(IncId As %String, UomId As %String, AppCode As %String, Params As %String = "") As %Library.String
{
	n (IncId,UomId,AppCode,Params)
	s HospId=$p(Params,"^",4)
	s RpProp=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppCode,"DefaRp",Params)
	i RpProp=1  d   ;取最后一次入库进价
	.s Rp=..GetInciLRp(IncId,UomId,HospId)
	.i +Rp=0 s Rp=..GetInciBasicRp(IncId,+$h,UomId,HospId)	;2016-05-18 add
	e  i RpProp=3 d   ;取招标进价
	.s Rp=..GetPbRp(IncId,UomId,HospId)
	e  d  ;取调价表进价
	.s Rp=..GetInciBasicRp(IncId,+$h,UomId,HospId)
	;
	q Rp
}

/// Descript:根据定价类型计算售价
/// Creater:	ZhangDongmei
/// CreateDate:	2012-09-18
/// Table:
/// Input:库存项id,单位id,进价
/// Output:		
/// Return：售价
/// 2015-02-09 UomId参数不再使用
/// w ##class(web.DHCSTMHUI.Common.PriceCommon).GetMtSp(9050,"",10)
ClassMethod GetMtSp(IncId As %String, UomId As %String, Rp As %String, Hosp As %String = "") As %Library.String
{
	n (IncId,UomId,Rp,Hosp)
	q:+Rp=0 0
	s Info=$o(^DHCITMINFO(0,"INCI",IncId,0))
	q:Info="" Rp   ;没有维护定价类型 
	s MtDr=$p(^DHCITMINFO(Info),"^",15)
	
	i MtDr="" d
	.;若仅有一个可用的物资定价类型,则默认该值
	.s MTId=0,MTValidNum=0
	.f  s MTId=$o(^DHCINMT(MTId)) q:(MTId="")||(MTValidNum>1)  d
	..s MTUsed=$p(^DHCINMT(MTId),"^",4)
	..s MTType=$p(^DHCINMT(MTId),"^",5)
	..q:MTType'=..sssCode()
	..q:MTUsed'="Y"
	..s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("DHC_MarkType",MTId,Hosp)
	..q:ShowDataFlag="N"
	..s MTValidNum=MTValidNum+1
	..s UniqueValidMT=MTId
	.
	.i MTValidNum=1 s MtDr=UniqueValidMT
	
	q:MtDr="" Rp
	
	s NewSp=..GetMarkTypeSp(MtDr,Rp)
	q NewSp
}

/// Description:根据定价规则计算售价
/// Creator:	wangjiabin
/// CreateDate:	2014-09-01
/// Table:
/// Input:		定价规则, 进价
/// Return：	售价
/// w ##class(web.DHCSTMHUI.Common.PriceCommon).GetMarkTypeSp(22,1000)
ClassMethod GetMarkTypeSp(MtDr As %String, Rp As %String) As %Library.String
{
	n (MtDr,Rp)
	
	s NewSp=0
	s SdId="" ;小数规则
	s Rowid=0,Exit=0
	f  s Rowid=$o(^DHCINMR(0,"MT",MtDr,Rowid))  q:(Rowid="")!(Exit=1)  d
	.s UseFlag=$p(^DHCINMR(Rowid),"^",8)
	.q:UseFlag'="Y"
	.s MinRp=$p(^DHCINMR(Rowid),"^",3)
	.s MaxRp=$p(^DHCINMR(Rowid),"^",4)
	.;当前规则: 下限<Rp<=上限 (不包含下限,包含上限)
	.q:(Rp<=MinRp)||((+MaxRp'=0)&&(Rp>MaxRp))	;进价不在该规则范围内
	.;q:(Rp<MinRp)||((+MaxRp'=0)&&(Rp>=MaxRp))	;下限<=Rp<上限
	.s Margin=$p(^DHCINMR(Rowid),"^",5)
	.s MarPrice=$p(^DHCINMR(Rowid),"^",10)
	.s SdId=$p(^DHCINMR(Rowid),"^",12)
	.s MaxMPrice=$p(^DHCINMR(Rowid),"^",9)		;最高加成额
	.s MaxMargin=$p(^DHCINMR(Rowid),"^",11)		;最高加成率
	.s Exit=1   ;找到了相应的价格段
	.s RuleAdd=$$IsRuleAdd(Rowid)
	.s PriceGap=0		;通过定价规则计算加成额
	.i RuleAdd=1  d    ;根据累计定价规则算
	..s SpByAdd=..CalSpByMTAdd(Rowid,Rp)
	..s PriceGap=SpByAdd-Rp
	.e  d
	..s PriceGap=Rp*Margin+MarPrice
	.
	.;若最高加成额更小,改该值
	.i (+MaxMPrice'=0)&&(MaxMPrice<PriceGap) d
	..s PriceGap=MaxMPrice
	.
	.;若最高加成率计算的加成额更小,取该值
	.i +MaxMargin'=0 d
	..s GapByMaxMargin=Rp*MaxMargin
	..s:GapByMaxMargin<PriceGap PriceGap=GapByMaxMargin
	.
	.s NewSp=Rp+PriceGap
	
	i SdId'=""  d
	.s NewSp=..CalDecimal(NewSp,SdId)
	
	q NewSp
	
IsRuleAdd(Mr)
	n (Mr)
	s Flag=0
	s Mra=0
	f  s Mra=$o(^DHCINMRA(Mr,"I",Mra))  q:(Mra="")!(Flag=1)  d
	.s UseFlagAdd=$p(^DHCINMRA(Mr,"I",Mra),"^",7)
	.q:UseFlagAdd'="Y"
	.s Flag=1
	q Flag
}

/// Descript:根据定价规则子规则计算售价
/// Creater:	ZhangDongmei
/// CreateDate:	2012-09-18
/// Table:
/// Input:定价规则id,入库单位进价
/// Output:		
/// Return：售价
ClassMethod CalSpByMTAdd(Parref As %String, Rp As %String) As %Library.String
{
	n (Parref,Rp)
	q:Parref="" 0
	q:+Rp=0 0
	;
	s sqlStr="select MRA_MinRp,MRA_MaxRp,MRA_Margin from DHC_MarkRuleAdd where MRA_MR_Parref="
	_Parref_" and MRA_UseFlag='Y' order by mra_minrp"
	
	s result = ##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	s sc=result.Execute()
	s err=$$$ISERR(sc)
	;
	If err  q 0
	s NewSp=0
	s LastMax=0
	While(result.Next())
	{
		s MinRp=result.Data("MRA_MinRp")
		s MaxRp=+result.Data("MRA_MaxRp")   ;上限没有限制的话为0
		s Margin=result.Data("MRA_Margin")
		
		if (Rp>=MinRp)&((Rp<=MaxRp)!(MaxRp=0)){
			s NewSp=NewSp+((Rp-LastMax)*(1+Margin))
			q		;完成求值,退出
		} elseif (Rp>MaxRp){
			s NewSp=NewSp+((MaxRp-LastMax)*(1+Margin))
			s LastMax=MaxRp
		}
	}

	q NewSp
}

/// Descript:根据小数规则格式化计算出的售价
/// Creater:	ZhangDongmei
/// CreateDate:	2012-09-18
/// Table:
/// Input:售价,小数规则id
/// Output:		
/// Return：售价
ClassMethod CalDecimal(Sp As %String, SdId As %String) As %Library.String
{
	n (Sp,SdId)
	s NewSp=Sp
	q:SdId="" NewSp
	q:'$d(^DHCSD(SdId)) NewSp
	s UseFlag=$P(^DHCSD(SdId),"^",3)
	q:UseFlag'="Y" NewSp
	s sub=0
	s Flag=0
	f  s sub=$O(^DHCSD(SdId,"I",sub)) q:(sub="")!(sub=0)!(Flag=1)  d
	.s sData=^(sub)
	.s Min=+$P(sData,"^",1)
	.s Max=+$P(sData,"^",2)
	.s Len=+$P(sData,"^",3)
	.q:Sp<Min      ;价格不在规则范围内
	.q:Sp>Max      ;价格不再规则范围内
	.s Flag=1
	.i Len>=0 d
	..s NewSp=$FN(Sp,"",Len)
	.e   d
	..s NewSp=NewSp/($zpower(10,$zabs(Len)))
	..s NewSp=$FN(NewSp,"",0)
	..s NewSp=NewSp*($zpower(10,$zabs(Len)))
	.
	q NewSp
}

/// Descript：根据库存项ID取调价表的调整进价
ClassMethod GetInciBasicRpOld(inciid, stdate, uom, HospID = "") As %Library.String
{
	n (inciid,stdate,uom,HospID)
	s buom=$p(^INCI(inciid,1),"^",10)
	i uom="" s uom=buom
	s retrp=0,adjrow=""
	s excudate=stdate+1
	I HospID="" D
	.s excudate=$o(^INASP(0,"INCI",inciid,excudate),-1)
	.Q:excudate=""
	.s adjrow=$o(^INASP(0,"INCI",inciid,excudate,""),-1)
	E  D
	.s excudate=$o(^INASP(0,"HOSPI",HospID,inciid,excudate),-1)
	.Q:excudate=""
	.s adjrow=$o(^INASP(0,"HOSPI",HospID,inciid,excudate,""),-1)
	Q:adjrow="" 0
	s price=$p(^INASP(adjrow),"^",16)
	s adjuom=$p(^INASP(adjrow),"^",10)
	s ctuomprice=$p(^INASP(adjrow),"^",14)
	i uom=adjuom  d
	.s retrp=ctuomprice
	e  d
	.s factor=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(uom,buom)
	.s retrp=price*factor
	i uom=buom d
	.s retrp=##class(web.DHCSTMHUI.Common.AppCommon).FormatRp(retrp,HospID,2)
	e  d
	.s retrp=##class(web.DHCSTMHUI.Common.AppCommon).FormatRp(retrp,HospID,1)
	q retrp
}

/// Descript：根据库存项ID取调价表的调整进价
ClassMethod GetInciBasicRp(inclb, stdate, uom, HospID = "", timeh = "") As %Library.String
{
	n (inclb,stdate,uom,HospID,timeh)
	q:inclb="" 0
	q:stdate="" 0
	s RetRp=0
	s BatSpFlag=..sssBatSpFlag(HospID,inclb)
	if BatSpFlag=1 d 
	.i $p(inclb,"||",3)'="" d
	..s RetStr=..GetPriceByInclb(inclb,stdate,uom,HospID,timeh) //批次进价,按批次调价表
	..s RetRp=+$p(RetStr,"^",1)
	.e  d
	..s inciID=$p(inclb,"||",1)
	..//s ibSub=$o(^INCI(inciID,"IB",""),-1)
	..//q:ibSub=""
	..//s incib=inciID_"||"_ibSub
	..s incib=##Class(web.DHCSTMHUI.Common.DrugStkCommon).GetLastIncib(inciID,HospID,stdate)
	..s RetStr=..GetPriceByIncib(incib,stdate,uom,HospID,timeh)		//最后一个批次的批次进价
	..s RetRp=+$p(RetStr,"^",1)
	e  d 
	.s RetRp=..GetInciBasicRpOld(+inclb, stdate, uom, HospID)
	q RetRp
}

/// Descript:	根据批次取批次表保存的进价
/// CreateDate：2011-04-21
/// Creater：	周永刚
/// Input：		inclb-批次rowid
/// Return：	单位入库时的进价
/// Modify:zhangdongmei,2012-05-04,增加医院、制剂和格式化处理
/// 2015-03-10 入库单位取值需经过计算(修改单位后从dhc_incitmbat取值不合理)
ClassMethod GetClbRpOld(inclb, UomID = "", HospID = "") As %Library.String
{
	N (inclb,UomID,HospID)
	Q:inclb="" 0
	S BUomID=$P(^INCI(+inclb,1),"^",10)
	s:UomID="" UomID=BUomID
	S RecRp=0
	S incib=$p(^INCI(+inclb,"IL",$p(inclb,"||",2),"LB",$p(inclb,"||",3)),"^",1) 
	I incib'="" D
	.S dhcincib=$O(^DHCINCIB(0,"INCIB",incib,""))
	.I dhcincib'="" D
	..S inci=$P(inclb,"||",1)
	..Q:inci=""
	..S PUomID=$P(^INCI(inci,3),"^",6)
	..I UomID="" S UomID=BUomID
	..S bRecRp=+$P(^DHCINCIB(dhcincib),"^",3)
	..I UomID=BUomID D
	...S RecRp=bRecRp
	..Else  d
	...S Fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(UomID,BUomID)
	...S RecRp=bRecRp*Fac
	..i UomID=BUomID d
	...s RecRp=##class(web.DHCSTMHUI.Common.AppCommon).FormatRp(RecRp,HospID,2)
	..e  d
	...s RecRp=##class(web.DHCSTMHUI.Common.AppCommon).FormatRp(RecRp,HospID,1)
	..
	.
	Q RecRp
}

/// Descript:	根据批次取批次表保存的进价
/// CreateDate：2011-04-21
/// Creater：	周永刚
/// Input：		inclb-批次rowid
/// Return：	单位入库时的进价
/// Modify:zhangdongmei,2012-05-04,增加医院、制剂和格式化处理
ClassMethod GetClbRp(inclb, UomID = "", HospID = "", timeh = "", dateh = "") As %Library.String
{
	N (inclb,UomID,HospID,timeh,dateh)
	Q:inclb="" 0
	S RecRp=0
	s BatSpFlag=..sssBatSpFlag(HospID,inclb)
	if BatSpFlag=1 d
	.s:dateh="" dateh=+$h
	.s RetStr=..GetPriceByInclb(inclb,dateh,UomID,HospID,timeh) //批次进价,按批次调价表
	.s RecRp=+$p(RetStr,"^",1)
	e  d
	.s RecRp=..GetClbRpOld(inclb,UomID,HospID)
	Q RecRp
}

ClassMethod GetClbRpbydate(inclb, date, UomID = "", HospID = "", timeh = "") As %Library.String
{
	N (inclb,date,UomID,HospID,timeh)
	Q:inclb="" 0
	S RecRp=0
	s BatSpFlag=..sssBatSpFlag(HospID,inclb)
	if BatSpFlag=1 d
	.s RetStr=..GetPriceByInclb(inclb,date,UomID,HospID,timeh) //批次进价,按批次调价表
	.s RecRp=+$p(RetStr,"^",1)
	e  d
	.s RecRp=..GetClbRpOld(inclb,UomID,HospID)
	Q RecRp
}

/// Descript:	根据库存项ID、日期、单位及医院取得当前售价
/// Creater:	Zhouyg
/// CreateDate:	20100302
/// Input:		inciid,stdate,uom,HospID
/// Output:		Return
/// Return：	传入单位对应的当前售价
/// Modify：zhangdongmei,2012-05-04，增加价格四舍五入处理
ClassMethod GetPriceElseOld(inciid, stdate, uom, HospID = "")
{
	n (inciid,stdate,uom,HospID)
	Q:inciid="" 0
	Q:'$D(^INCI(inciid)) 0
	
	S adjrow=""
	s excudate=stdate+1

	I HospID'="" D
	.s excudate=$o(^INASP(0,"HOSPI",HospID,inciid,excudate),-1)
	.Q:excudate=""
	.s adjrow=$o(^INASP(0,"HOSPI",HospID,inciid,excudate,""),-1)
	.
	//无法按医院取出记录的时候,再执行一下按品种取记录(这个是随便按品种取，可能取到其他医院的)
	I adjrow="" d
	.s excudate=$o(^INASP(0,"INCI",inciid,excudate),-1)
	.Q:excudate=""
	.s adjrow=$o(^INASP(0,"INCI",inciid,excudate,""),-1)
	.
	Q:adjrow="" 0
	
	s price=+$p(^INASP(adjrow),"^",7)
	s adjuom=$p(^INASP(adjrow),"^",10)
	s ctuomprice=+$p(^INASP(adjrow),"^",11)
	s buom=$p(^INCI(inciid,1),"^",10) ;base uom
	i uom="" s uom=buom ;base uom
	i uom=adjuom  d
	.s price=ctuomprice
	e  d
	.s factor=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(uom,buom)
	.s price=price*factor
	.
	i uom=buom d
	.s price=##class(web.DHCSTMHUI.Common.AppCommon).FormatSp(price,HospID,2)
	e  d
	.s price=##class(web.DHCSTMHUI.Common.AppCommon).FormatSp(price,HospID,1)
	q price
}

/// Descript:	根据库存项ID、日期、单位及医院取得当前售价
/// Creater:	Zhouyg
/// CreateDate:	20100302
/// Input:		inciid,stdate,uom,HospID,time,rp
/// Output:		Return
/// Return：	传入单位对应的当前售价
/// Modify：	zhangdongmei,2012-05-04，增加价格四舍五入处理
/// Modify:		药品取售价统一只走一个函数(对药品来说如果是批次价格inciid可以为科室库存项批次ID),20140211,zhouyg,详细说明参见##Class(web.DHCSTPRICE).GetSp
ClassMethod GetPriceElse(inciid, stdate, uom, HospID = "", timeh = "", rp = "")
{
	n (inciid,stdate,uom,HospID,timeh,rp)
	Q:inciid="" 0
	s price=..GetSp(inciid,stdate,uom,HospID,timeh,rp)
	q price
}

/// Descript:	根据库存项ID、单位及院区取得最后一个批次进价
/// Creater:	Zhouyg
/// CreateDate:	20100302
/// Input:		InciDr-inci_rowid, uom, HospID
/// Output:		Return
/// Return：	入库单位进价
ClassMethod GetInciLRp(inci, uom, HospID = "", dah = "")
{
	n (inci,uom,HospID,dah)
	q:inci="" 0
	s buom=$p(^INCI(inci,1),"^",10)
	i dah="" s dah=+$h
	
	s ingr="",rp=0
	f  s ingr=$o(^DHCINGR(0,"INCI",inci,ingr),-1) q:(ingr="")!(rp'=0)  d
	.q:($d(^DHCINGR(ingr))=0)!(($d(^DHCINGR(ingr))=10))
	.q:$p(^DHCINGR(ingr),"^",8)=""	//未审核
	.s locdr=$P(^DHCINGR(ingr),"^",13)
	.s LocHospID=..sssHospId(locdr)
	.Q:(HospID'="")&(HospID'=LocHospID)
	.s ingrsub=$o(^DHCINGR(0,"INCI",inci,ingr,""),-1) q:ingrsub=""
	.q:($d(^DHCINGR(ingr,"GRI",ingrsub))=0)!(($d(^DHCINGR(ingr,"GRI",ingrsub))=10))
	.s auditdah=$p(^DHCINGR(ingr),"^",4)
	.q:auditdah>dah
	.s inclb=$p(^DHCINGR(ingr,"GRI",ingrsub),"^",1)
	.q:inclb=""
	.s Inci=$p(inclb,"||",1)
	.s incilch=$p(inclb,"||",2)
	.s lbch=$p(inclb,"||",3)
	.s incib=$p(^INCI(Inci,"IL",incilch,"LB",lbch),"^",1)
	.s dhcincib=$o(^DHCINCIB(0,"INCIB",incib,""))
	.s rp=$p(^DHCINCIB(dhcincib),"^",3)
	.i uom="" s uom=buom
	.
	i uom=buom d
	.s rp=##class(web.DHCSTMHUI.Common.AppCommon).FormatRp(rp,HospID,2)
	e  d
	.s rp=##class(web.DHCSTMHUI.Common.AppCommon).FormatRp(rp,HospID,1)
 
	i +rp=0 d
	.s rp=..GetInciBasicRp(inci,+$h,uom,HospID)
	q rp
}

/// Descript:取某药品招标进价
/// Creater:zhangdongmei
/// CreateDate:2012-06-19
/// Input:库存项id
/// Output:	
/// Return：进价
ClassMethod GetPbRp(Inci As %String, UomId As %String, HospID As %String = "") As %Library.String
{
	n (Inci,UomId,HospID)
	q:Inci="" 0
	s Add=$o(^DHCITMINFO(0,"INCI",Inci,"")) 
	q:Add="" 0
	s Rp=$p($G(^DHCITMINFO(Add)),"^",22)
	s PurUomId=$p(^INCI(Inci,3),"^",6)
	s BUomId=$p(^INCI(Inci,1),"^",10)
	s Fac1=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PurUomId,BUomId)
	s Fac2=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(UomId,BUomId)
	s Rp=Rp/Fac1*Fac2
	i UomId=BUomId d
	.s Rp=##class(web.DHCSTMHUI.Common.AppCommon).FormatRp(Rp,HospID,2)
	e  d
	.s Rp=##class(web.DHCSTMHUI.Common.AppCommon).FormatRp(Rp,HospID,1)
	q Rp
}

/// Descript:	根据库存项ID、日期、单位及医院取得最近的生效的调价记录，如果没有，则找出最后的调价记录（未生效）
/// 				目前用于药品信息维护界面库存项的进价售价取值
/// Creator:	wangjiabin
/// CreateDate:	20130621
/// Input:		inciid,stdate,uom,HospID
/// Output:		Return
/// Return：	最近的生效的调价记录，如果没有，则找出最后的调价记录（未生效）
/// 			rp^sp^INASP_ExecuteDate(未生效时为INASP_PreExeDate)
ClassMethod GetINCPrice(inciid, stdate, uom, HospID = "")
{
	n (inciid,stdate,uom,HospID)
	Q:inciid="" ""
	Q:'$D(^INCI(inciid)) ""
	s rp=0,rp=0,exeDate=""
	S adjrow=""
	s excudate=stdate+1
	I HospID="" D
	.s excudate=$o(^INASP(0,"INCI",inciid,excudate),-1)
	.Q:excudate=""
	.s adjrow=$o(^INASP(0,"INCI",inciid,excudate,""),-1)
	E  D
	.s excudate=$o(^INASP(0,"HOSPI",HospID,inciid,excudate),-1)
	.Q:excudate=""
	.s adjrow=$o(^INASP(0,"HOSPI",HospID,inciid,excudate,""),-1)
	
	s:adjrow'="" exeDate=excudate
	
	i adjrow="" d
	.s excudate=$o(^INASP(0,"INCI",inciid,""),-1)
	.q:excudate=""
	.s adjrow=$o(^INASP(0,"INCI",inciid,excudate,""),-1)
	.q:adjrow=""
	.s exeDate=$p(^INASP(adjrow),"^",17)	;INASP_PreExeDate 计划执行日期
	
	Q:adjrow="" ""
	s sp=+$p(^INASP(adjrow),"^",7)
	s rp=+$p(^INASP(adjrow),"^",16)
	s adjuom=$p(^INASP(adjrow),"^",10)
	s ctuomSp=+$p(^INASP(adjrow),"^",11)
	s ctuomRp=+$p(^INASP(adjrow),"^",14)
	s status=$p(^INASP(adjrow),"^",9)
	
	s buom=$p(^INCI(inciid,1),"^",10) ;base uom
	i uom="" s uom=buom ;base uom
	i uom=adjuom  d
	.s sp=ctuomSp
	.s rp=ctuomRp
	e  d
	.s factor=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(uom,buom)
	.s sp=sp*factor
	.s rp=rp*factor
	i uom=buom d
	.s sp=##class(web.DHCSTMHUI.Common.AppCommon).FormatSp(sp,HospID,2)
	.s rp=##class(web.DHCSTMHUI.Common.AppCommon).FormatRp(rp,HospID,2)
	e  d
	.s sp=##class(web.DHCSTMHUI.Common.AppCommon).FormatSp(sp,HospID,1)
	.s rp=##class(web.DHCSTMHUI.Common.AppCommon).FormatRp(rp,HospID,1)
	s:exeDate'="" exeDate=..DL2H(exeDate)
	q rp_"^"_sp_"^"_exeDate_"^"_status_"^"_adjrow
}

/// Descript：	根据库存项批次取批次调价表的进价和售价
/// CreatDate：	2013-07-16
/// Creater：	zhouyg
/// Table：		IN_AdjPriceBatch
/// Input：		inc_itmbat的ID,日期(数值格式),单位ID,CT_Hospital的ID,时间(数值格式)
/// Return:		进价^售价^INASP_ExecuteDate(未生效时为INASP_PreExeDate)^状态^调价记录id
ClassMethod GetPriceByIncib(incib, dateh, uomID, HospID = "", timeh = "") As %String
{
	n (incib,dateh,uomID,HospID,timeh)
	q:incib="" "0^0^^^"
	i dateh="" s dateh=+$h
	i timeh="" s timeh=86399 //23:59:59
	s (retrp,retsp)=0
	s (apbID,execDate)=""
	s nTime=timeh+1
	I HospID'="" D
	.s execTime=nTime
	.f  s execTime=$o(^DHCSTINAPB(0,"HOSPINCIB",HospID,incib,dateh,execTime),-1) q:(execTime="")!(apbID'="")  d
	..s apbID=$o(^DHCSTINAPB(0,"HOSPINCIB",HospID,incib,dateh,execTime,""),-1)
	..s:apbID'="" execDate=$p(^DHCSTINAPB(apbID),"^",16)
	.i apbID="" d
	..s execDate=dateh
	..f  s execDate=$o(^DHCSTINAPB(0,"HOSPINCIB",HospID,incib,execDate),-1) q:(execDate="")!(apbID'="")  d
	...s execTime=$o(^DHCSTINAPB(0,"HOSPINCIB",HospID,incib,execDate,""),-1)
	...s apbID=$o(^DHCSTINAPB(0,"HOSPINCIB",HospID,incib,execDate,execTime,""),-1)
	i apbID="" d
	.s execTime=nTime
	.f  s execTime=$o(^DHCSTINAPB(0,"INCIB",incib,dateh,execTime),-1) q:(execTime="")!(apbID'="")  d
	..s apbID=$o(^DHCSTINAPB(0,"INCIB",incib,dateh,execTime,""),-1)
	..s:apbID'="" execDate=$p(^DHCSTINAPB(apbID),"^",16)
	.i apbID="" d
	..s execDate=dateh
	..f  s execDate=$o(^DHCSTINAPB(0,"INCIB",incib,execDate),-1) q:(execDate="")!(apbID'="")  d
	...s execTime=$o(^DHCSTINAPB(0,"INCIB",incib,execDate,""),-1)
	...s apbID=$o(^DHCSTINAPB(0,"INCIB",incib,execDate,execTime,""),-1)
	Q:apbID="" "0^0^^^"
	s inciID=$p(incib,"||",1)
	s buomID=$p(^INCI(inciID,1),"^",10)
	i uomID="" s uomID=buomID
	s adjuomID=$p(^DHCSTINAPB(apbID),"^",5)
	s adjuomRp=$p(^DHCSTINAPB(apbID),"^",7)
	s adjuomSp=$p(^DHCSTINAPB(apbID),"^",9)
	s buomRp=$p(^DHCSTINAPB(apbID),"^",11)
	s buomSp=$p(^DHCSTINAPB(apbID),"^",13)
	s status=$p(^DHCSTINAPB(apbID),"^",3)  ;状态
	i uomID=adjuomID  d
	.s retrp=adjuomRp
	.s retsp=adjuomSp
	e  d
	.s factor=##Class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(uomID,buomID)
	.s retrp=buomRp*factor
	.s retsp=buomSp*factor
	i uomID=buomID d
	.s retrp=##Class(web.DHCSTMHUI.Common.AppCommon).FormatRp(retrp,HospID,2)
	.s retsp=##Class(web.DHCSTMHUI.Common.AppCommon).FormatSp(retsp,HospID,2)
	e  d
	.s retrp=##Class(web.DHCSTMHUI.Common.AppCommon).FormatRp(retrp,HospID,1)
	.s retsp=##Class(web.DHCSTMHUI.Common.AppCommon).FormatSp(retsp,HospID,1)
	s:execDate'="" execDate=..DL2H(execDate)
	s RetStr=retrp_"^"_retsp_"^"_execDate_"^"_status_"^"_apbID
	q RetStr
}

/// Descript:	取售价,支持各种进价规则的取法(规则不同,参数不同)
/// Creater：	zhouyg
/// CreateDate：2013-07-16
/// Input：		inclb-科室库存项批次ID,不按批次取的此值可以为inciID(不能为空),uomID-单位ID(为空则按基本单位取)
/// 			dah-日期($h格式),HospID-医院ID(如果为空则不进行医院判断取最后一个符合条件的记录),timeh(数值格式，为空则认为是23:59:59，只有按批次价格有意义),
/// 			rp
/// Return：	返回售价(不带千分位)
ClassMethod GetSp(inclb, dah, uomID, HospID, timeh = "", rp = "") As %String
{
	n (inclb,dah,uomID,HospID,timeh,rp)
	q:inclb="" 0
	q:dah="" 0
	s BatSpFlag=..sssBatSpFlag(HospID,inclb)
	s RetSp=0
	if BatSpFlag=1 d
	.i $p(inclb,"||",3)'="" d
	..s RetStr=..GetPriceByInclb(inclb,dah,uomID,HospID,timeh) //批次售价,按批次调价表
	..s RetSp=+$p(RetStr,"^",2)
	.e  i +rp'=0 d
	..;若没有inclb,且传入了进价,按定价规则计算
	..s inciID=$p(inclb,"||",1)
	..s RetSp=##class(web.DHCSTMHUI.Common.PriceCommon).GetMtSp(inciID,uomID,rp,HospID)
	.e  d
	..s inciID=$p(inclb,"||",1)
	..//s ibSub=$o(^INCI(inciID,"IB",""),-1)
	..//q:ibSub=""
	..//s incib=inciID_"||"_ibSub
	..s incib=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetLastIncib(inciID,HospID,dah)
	..s RetStr=..GetPriceByIncib(incib,dah,uomID,HospID,timeh)		//最后一个批次的批次售价
	..s RetSp=+$p(RetStr,"^",2)
	else  d
	.s inciID=$p(inclb,"||",1)
	.s RetSp=..GetPriceElseOld(inciID,dah,uomID,HospID)	//统一售价
	q RetSp
}

/// Descript：	根据科室库存项批次取批次调价表的进价和售价
/// CreatDate：	2013-07-16
/// Creater：	zhouyg
/// Table：		IN_AdjPriceBatch
/// Input：		inc_itmlcbt的ID,日期(数值格式),单位ID,CT_Hospital的ID,时间(数值格式)
/// Return:		进价^售价
ClassMethod GetPriceByInclb(inclb, dateh, uomID, HospID = "", timeh = "") As %String
{
	n (inclb,dateh,uomID,HospID,timeh)
	q:inclb="" "0^0"
	s incib=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetIncib(inclb)
	q:incib="" "0^0"
	s RetStr=..GetPriceByIncib(incib,dateh,uomID,HospID,timeh)
	q RetStr
}

/// Descript:	根据批次取批次表保存的售价
/// CreateDate：2018-12-14
/// Input：		inclb-批次rowid
/// Return：	单位入库时的售价
ClassMethod GetClbSp(inclb, dateh, uomID, HospID = "", timeh = "") As %Library.String
{
	n (inclb,dateh,uomID,HospID,timeh)
	q:inclb="" 0
	S RecSp=0
	s BatSpFlag=..sssBatSpFlag(HospID,inclb)
	if BatSpFlag=1 d
	.s RetStr=..GetPriceByInclb(inclb,dateh,uomID,HospID,timeh) //批次进价,按批次调价表
	.s RecSp=+$p(RetStr,"^",2)
	else  d
	.s inciID=$p(inclb,"||",1)
	.s RecSp=..GetPriceElseOld(inciID,dateh,uomID,HospID)	//统一售价
	Q RecSp
}

/// Descript:	获取计费项价格(传入单位对应的计费项售价)
/// CreateDate:	2021-09-27
/// Input:		inciid,stdate,uom(为空时按基本单位),HospID
/// Output:	
/// w ##class(web.DHCSTMHUI.Common.PriceCommon).GetTarPrice(2072,+$h)
ClassMethod GetTarPrice(Inci, StDate, UomId = "", HospID = "")
{
	n (Inci,StDate,UomId,HospID)
	q:Inci="" 0
	q:'$d(^INCI(Inci,1)) 0
	s TarId=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetTARI(Inci)
	q:(TarId="")||'$d(^DHCTARIi("TARI",TarId)) 0
	
	s Conf=$o(^DHCTarC("CF","")) q:Conf="" 0
	s InsType=$p(^DHCTarC("CF",Conf),"^",3)
	q:'$d(^DHCTARIi("TARI",TarId,InsType)) 0
	
	s:StDate="" StDate=+$H
	s StDate0=StDate+1
	s (ExeDate,TPCh)=""
	i HospID="" d
	.s ExeDate=$o(^DHCTARIi("TARI",TarId,InsType,StDate0),-1)
	.q:ExeDate=""
	.s TPCh=$o(^DHCTARIi("TARI",TarId,InsType,ExeDate,""),-1)
	e  d
	.s ExeDate=$o(^DHCTARIi("HospInsType",TarId,InsType,HospID,StDate0),-1)
	.q:ExeDate=""
	.s TPCh=$o(^DHCTARIi("HospInsType",TarId,InsType,HospID,ExeDate,""),-1)
	
	i TPCh="" d
	.s ExeDate=$o(^DHCTARIi("TARI",TarId,InsType,StDate0),-1)
	.q:ExeDate=""
	.s TPCh=$o(^DHCTARIi("TARI",TarId,InsType,ExeDate,""),-1)
	
	q:TPCh="" 0
	
	s PriceBUom=+$p(^DHCTARI(TarId,"P",TPCh),"^",5)
	s BUomId=$p(^INCI(Inci,1),"^",10)
	i UomId="" s UomId=BUomId
	s UomFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(UomId,BUomId)
	s Price=PriceBUom*UomFac
	i UomId=BUomId d
	.s Price=##class(web.DHCSTMHUI.Common.AppCommon).FormatSp(Price,HospID,2)
	e  d
	.s Price=##class(web.DHCSTMHUI.Common.AppCommon).FormatSp(Price,HospID,1)
	
	q Price
}

/// Descript:	根据incil获取进价金额(整理自库存查询)
/// Creator:	wangjiabin
/// CreateDate:	2015-10-14
/// Input:		incil,date,hosp
/// Output:		
/// Return：	进价金额
ClassMethod GetRpAmt(incil, dtend, hospid) As %String
{
	n (incil, dtend,hospid)
	s inci=$p(incil,"||",1)
	s incich=$p(incil,"||",2)
	s ch=0
	s sumamt=0
	f  s ch=$o(^INCI(inci,"IL",incich,"LB",ch)) q:ch=""  d
	.s inclb=incil_"||"_ch
	.s qty=+##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyINCLB(inclb,dtend)
	.q:qty=0
	.s buom=$p(^INCI(inci,1),"^",10)
	.s rp=+##class(web.DHCSTMHUI.Common.PriceCommon).GetClbRp(inclb,buom,hospid)
	.s rpamt=rp*qty
	.s sumamt=sumamt+rpamt
	.
	s sumamt=##class(web.DHCSTMHUI.Common.AppCommon).FormatRpAmt(sumamt,hospid)
	q sumamt
}

/// Descript:	根据incil获取售价金额
/// Creator:	wangjiabin
/// CreateDate:	2015-10-14
/// Input:		incil,date,hosp
/// Output:		
/// Return：	售价金额
ClassMethod GetSpAmt(incil, dtend, hospid) As %String
{
	n (incil,dtend,hospid)
	s BatSpFlag=..sssBatSpFlag(hospid,incil)
	s SpAmt=0
	i BatSpFlag=1 d
	.s SpAmt=..GetSpAmtBat(incil,dtend,hospid)
	e  d
	.s SpBuom=+..GetPriceElseOld(+incil,dtend,"",hospid)
	.s loc=$p(^INCI(+incil,"IL",$p(incil,"||",2)),"^",1)
	.s qty=+##class(web.DHCSTMHUI.Common.DrugStkCommon).IL(+incil,loc,dtend)
	.s SpAmt=qty*SpBuom
	
	s SpAmt=##class(web.DHCSTMHUI.Common.AppCommon).FormatSpAmt(SpAmt,hospid)
	q SpAmt
}

/// (整理自库存查询)
/// 批次售价获取每个批次售价金额的之和
/// 2015-06-23
ClassMethod GetSpAmtBat(incil, dtend, hospid) As %String [ Private ]
{
	n (incil,dtend,hospid)
	s inci=$p(incil,"||",1)
	s incich=$p(incil,"||",2)
	s ch=0
	s sumamt=0
	f  s ch=$o(^INCI(inci,"IL",incich,"LB",ch)) q:ch=""  d
	.s inclb=incil_"||"_ch
	.s qty=+##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyINCLB(inclb,dtend)
	.q:qty=0
	.s buom=$p(^INCI(inci,1),"^",10)
	.s PriceStr=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceByInclb(inclb,dtend,buom,hospid)
	.s sp=$p(PriceStr,"^",2)
	.s spamt=sp*qty
	.s sumamt=sumamt+spamt
	s sumamt=##class(web.DHCSTMHUI.Common.AppCommon).FormatSpAmt(sumamt,hospid)
	q sumamt
}

/// 判读某个耗材是否存在批次调价信息,是否批次售价
/// 2017-04-25
/// Y:是;否则:不存在;1是批次售价,否则统一售价;库存项最新一个批次id
ClassMethod IfExitBatAdjprice(inci, hospid = "") As %String
{
	n (inci,hospid)
	s batflag=..sssBatSpFlag(hospid,inci)
	q:inci="" "N^"_batflag_"^"
	s flag="N",incibid="",inapbid=""
	s ibSub=$o(^INCI(inci,"IB",""),-1)
	q:ibSub="" "N^"_batflag_"^"
	s incib=inci_"||"_ibSub
	if (incib'="") d
	.s ExecuteDate=$o(^DHCSTINAPB(0,"INCIB",incib,""),-1)
	.q:ExecuteDate=""
	.s ExecuteTime=$o(^DHCSTINAPB(0,"INCIB",incib,ExecuteDate,0),-1)
	.s inapbid=$o(^DHCSTINAPB(0,"INCIB",incib,ExecuteDate,+ExecuteTime,""),-1)
	.if +inapbid>0 d
	..s flag="Y"
	.
	q flag_"^"_batflag_"^"_incib
}

ClassMethod GetPriceToAspAmount(inciid, stdate, uom, HospID = "")
{
	n (inciid,stdate,uom,HospID)
	Q:inciid="" 0
	Q:'$D(^INCI(inciid)) 0	
	S adjrow=""
	s excudate=stdate+1
	I HospID="" D
	.s excudate=$o(^INASP(0,"INCI",inciid,excudate),-1)
	.Q:excudate=""
	.s adjrow=$o(^INASP(0,"INCI",inciid,excudate,""),-1)
	E  D
	.s excudate=$o(^INASP(0,"HOSPI",HospID,inciid,excudate),-1)
	.Q:excudate=""
	.s adjrow=$o(^INASP(0,"HOSPI",HospID,inciid,excudate,""),-1)
	.
	//无法按医院取出记录的时候,再执行一下按品种取记录(这个是随便按品种取，可能取到其他医院的)
	i (HospID'="")&(adjrow="") d
	.s excudate=$o(^INASP(0,"INCI",inciid,excudate),-1)
	.Q:excudate=""
	.s adjrow=$o(^INASP(0,"INCI",inciid,excudate,""),-1)
	.
	Q:adjrow="" 0
	s price=+$p(^INASP(adjrow),"^",7)
	s adjuom=$p(^INASP(adjrow),"^",10)
	s ctuomprice=+$p(^INASP(adjrow),"^",11)
	s buom=$p(^INCI(inciid,1),"^",10) ;base uom
	i uom="" s uom=buom ;base uom
	i uom=adjuom  d
	.s price=ctuomprice
	e  d
	.s factor=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(uom,buom)
	.s price=price*factor
	.
	i uom=buom d
	.s price=##class(web.DHCSTMHUI.Common.AppCommon).FormatSp(price,HospID,2)
	e  d
	.s price=##class(web.DHCSTMHUI.Common.AppCommon).FormatSp(price,HospID,1)
	q price_"^"_adjrow
}

}
