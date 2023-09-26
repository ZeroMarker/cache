Import sqluser

/// Descript:价格信息相关的公共方法
/// Creater:	ZhangDongmei
/// CreateDate:	2012-05-03
Class web.DHCST.Common.PriceCommon Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

/// Descript:根据药品id和参数配置取进价
/// Creater:	ZhangDongmei
/// CreateDate:	2012-06-19
/// Table:
/// Input:库存项id,单位id,应用程序代码,安全组id^科室id^用户id^医院id
/// Output:		
/// Return：进价
ClassMethod GetConfigRp(IncId As %String, UomId As %String, AppCode As %String, Params As %String = "", StkType = "G") As %Library.String
{
	s HospId=$p(Params,"^",4)
	s RpProp=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppCode,"DefaRp",Params)
	i RpProp=1  d   ;取最后一次入库进价
	.s Rp=..GetInciLRp(IncId,UomId,HospId,StkType,+$h)     
	e  i RpProp=3 d   ;取招标进价
	.s Rp=..GetPbRp(IncId,UomId,HospId,StkType)
	e  d  ;取调价表进价
	.s Rp=##Class(web.DHCSTPRICE).GetRp(IncId,+$h,UomId,HospId,"") //zhouyg 20141203
	;
	q $fn(Rp,"N")
}

/// Descript:根据定价类型计算售价
/// Creater:	ZhangDongmei
/// CreateDate:	2012-09-18
/// Table:
/// Input:库存项id,单位id,进价
/// Output:		
/// Return：售价
/// w ##class(web.DHCST.Common.PriceCommon).GetMtSp("3181","18","5")
ClassMethod GetMtSp(IncId As %String, UomId As %String, Rp As %String) As %Library.String
{
	s Info=$o(^DHCITMINFO(0,"INCI",IncId,0))
	q:Info="" 0   ;没有维护定价类型 
	s MtDr=$p(^DHCITMINFO(Info),"^",15)
	q:MtDr="" 0
	q:+Rp=0 0
	s BUomId=$p(^INCI(IncId,1),"^",10)
	s PurUomId=$p(^INCI(IncId,3),"^",6)
	s Fac1=##class(web.DHCST.Common.UtilCommon).UOMFac(PurUomId,BUomId)
	s Fac2=##class(web.DHCST.Common.UtilCommon).UOMFac(UomId,BUomId)
	i UomId'=PurUomId  d   ;传入的单位不是入库单位
	.s PurRp=Rp/Fac2*Fac1
	e  d
	.s PurRp=Rp
	s MarkRuleId=..GetMarkRuleByMTRp(Rp,MtDr)
	q:MarkRuleId="" 0
	s purResultRp=..GetMTSpByMRRp(PurRp,MarkRuleId)
	q:(purResultRp=0)||(UomId=PurUomId) $fn(purResultRp,"N")
	s purResultRp=purResultRp*Fac2/Fac1  //如果传入的是基本单位，则必须先按照入库价格走定价规则取得加成后的价格，在换算为基本单位
	q purResultRp
}

/// Descript:根据定价规则子规则计算售价
/// Creater:	ZhangDongmei
/// CreateDate:	2012-09-18
/// Table:
/// Input:定价规则id,入库单位进价
/// Output:		
/// Return：售价
/// w ##class(web.DHCSTM.Common.PriceCommon).CalSpByMTAdd(9,50)
ClassMethod CalSpByMTAdd(Parref As %String, Rp As %String) As %Library.String
{
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
		s MaxRp=+result.Data("MRA_MaxRp")   ; 上限没有限制的话为0
		s Margin=result.Data("MRA_Margin")
		
		if (Rp>=MinRp)&((Rp<=MaxRp)!(MaxRp=0)){
			s NewSp=NewSp+((Rp-LastMax)*(1+Margin)) ; cache运算需要小括号控制优先级 
			q
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
 	.s NewSp=$FN(Sp,"",Len)
 	.
	q NewSp
}

/// Descript：	根据库存项ID取调价表的调整进价
/// Input:		inciid-科室库存项批次ID(按批次取价格)或者库存项ID(不按批次取价格)
/// Modify:		药品取进价统一只走一个函数,20140211,zhouyg(按批次取价格时inciid是科室库存批次ID)
ClassMethod GetInciBasicRp(inciid, stdate, uom, HospID = "", StkType = "G", timeh = "") As %Library.String
{
	s retrp=0
	s retrp=##Class(web.DHCSTPRICE).GetRp(inciid,stdate,uom,HospID,timeh)
	q retrp
}

/// Descript:	根据批次取批次表保存的进价
/// CreateDate：2011-04-21
/// Creater：	周永刚
/// Input：		inclb-批次rowid
/// Return：	单位入库时的进价
/// Modify:		zhangdongmei,2012-05-04,增加医院、制剂和格式化处理
/// Modify:		药品取进价统一只走一个函数,20140211,zhouyg
ClassMethod GetClbRp(inclb, UomID = "", HospID = "", StkType = "G", dateh = "", timeh = "") As %Library.String
{
	q:inclb="" 0
	s retrp=##Class(web.DHCSTPRICE).GetRp(inclb,dateh,UomID,HospID,timeh)
	q retrp
}

/// Descript:	根据库存项ID、日期、单位及医院取得当前售价
/// Creater:	Zhouyg
/// CreateDate:	20100302
/// Input:		inciid,stdate,uom,HospID
/// Output:		Return
/// Return：	传入单位对应的当前售价
/// Modify：	zhangdongmei,2012-05-04，增加价格四舍五入处理
/// Modify:		药品取售价统一只走一个函数(对药品来说如果是批次价格inciid可以为科室库存项批次ID),20140211,zhouyg,详细说明参见##Class(web.DHCSTPRICE).GetSp
ClassMethod GetPriceElse(inciid, stdate, uom, HospID = "", StkType = "G", timeh = "")
{
	Q:inciid="" 0
	s price=##Class(web.DHCSTPRICE).GetSp(inciid,stdate,uom,HospID,timeh)
	q price
}

/// Descript:	根据库存项ID、单位及院区取得最后一个批次进价
/// Creater:	Zhouyg
/// CreateDate:	20100302
/// Input:		InciDr-inci_rowid, uom, HospID
/// Output:		Return
/// Return：	入库单位进价
ClassMethod GetInciLRp(inci, uom, HospID = "", StkType = "G", dah = "")
{
	q:inci="" 0
	s rp=##Class(web.DHCSTPRICE).GetInciLRp(inci,uom,HospID,dah)
	q rp
}

/// 2013-08-05 添加StkType参数
ClassMethod BatSpUom(inclb, uom, HospID = "", StkType = "G") As %Library.String
{
	s ingri=##class(web.DHCST.Common.DrugStkCommon).GetClbDHCIngr(inclb) 
	q:ingri="" ""
	s DHCINGR=$p(ingri,"||",1) q:DHCINGR="" ""
	s DHCCH=$p(ingri,"||",2) q:DHCCH="" ""
	s newsp=+$p(^DHCINGR(DHCINGR,"GRI",DHCCH),"^",45)
	s RecUOM=$p(^DHCINGR(DHCINGR,"GRI",DHCCH),"^",10)
	s buom=$p(^INCI(+inclb,1),"^",10)
	s:uom="" uom=buom
	s fac1=##class(web.DHCST.Common.UtilCommon).UOMFac(uom,buom)
	s fac2=##class(web.DHCST.Common.UtilCommon).UOMFac(RecUOM,buom)
	s:RecUOM'=uom newsp=newsp/fac2*fac1
	q:inclb="" ""
	
	s herbFlag = ##class(web.DHCST.Common.DrugInfoCommon).IsHerb(+inclb)
	s dFlag = $s(uom=buom:2,1:1)	
	q ##class(web.DHCST.Common.AppCommon).FormatSp(newsp,HospID,dFlag,StkType,herbFlag)
}

// *****************************************************//

/// Descript:取药品批价
ClassMethod GetClbPp(inclb, UOM, HospID = "", StkType = "G") As %Library.String
{
	S Recflag=##class(web.DHCST.Common.DrugInfoCommon).ChkRIngr(+inclb) ;制剂取批价=进价
	I Recflag=1  S PP=..GetManPrice(inclb,UOM,HospID,StkType)
	Q:Recflag=1 PP
	s LASTINGRI=##class(web.DHCST.Common.DrugStkCommon).GetClbDHCIngr(inclb)
	q:LASTINGRI="" ""
	s DHCINGR=$P(LASTINGRI,"||",1)
	s DHCINGRCH=$P(LASTINGRI,"||",2)
	s PP=$p(^DHCINGR(DHCINGR,"GRI",DHCINGRCH),"^",35)    ; Purchase Price (in)
	s RECUOM=$p(^DHCINGR(DHCINGR,"GRI",DHCINGRCH),"^",10) ; UOM
	s BUOM=$p(^INCI(+inclb,1),"^",10)
	i UOM="" s UOM=BUOM
	s fac1=##class(web.DHCST.Common.UtilCommon).UOMFac(UOM,BUOM)
	s fac2=##class(web.DHCST.Common.UtilCommon).UOMFac(RECUOM,BUOM)
	s PP=PP/fac2*fac1
	i UOM=BUOM d
	.s PP=##class(web.DHCST.Common.AppCommon).FormatPp(PP,HospID,2,StkType)
	e  d
	.s PP=##class(web.DHCST.Common.AppCommon).FormatPp(PP,HospID,1,StkType)
	q PP
}

ClassMethod GetItmManPrice(inci, uomdr, HospID = "")
{
	q:inci="" ""
	s manid="",rp=0
	F  s manid=$o(^DHCINMAN(0,"INCI",inci,manid),-1) Q:(manid="")!(rp'=0)  D
	.q:manid=""
	.q:'$d(^DHCINMAN(manid))
	.S locdr=$P(^DHCINMAN(manid),"^",3)
	.S LocHospID=$P(^CTLOC(locdr),"^",22)
	.Q:(HospID'="")&(LocHospID'=HospID)
	.s rp=+$p(^DHCINMAN(manid),"^",11)
	.S muomdr=$p(^DHCINMAN(manid),"^",8)
	.S buomdr=$P(^INCI(inci,1),"^",10)
	.I uomdr="" S uomdr=buomdr
	.Q:muomdr=uomdr
	.s fac1=##class(web.DHCST.Common.UtilCommon).UOMFac(uomdr,buomdr)
	.s fac2=##class(web.DHCST.Common.UtilCommon).UOMFac(muomdr,buomdr)
	.s rp=rp/fac2*fac1
	.s herbFlag = ##class(web.DHCST.Common.DrugInfoCommon).IsHerb(+inci)
	.s dFlag = $s(uomdr=buomdr:2,1:1)	
	.s rp=##class(web.DHCST.Common.AppCommon).FormatRp(rp,HospID,dFlag,,herbFlag)
	q rp
}

/// Descript：根据inclb从制剂表取进价（只对制剂库存项）
ClassMethod GetManPrice(inclb, uomdr = "", HospID = "", StkType = "G")
{
	q:inclb="" ""
	s incib=$p(^INCI(+inclb,"IL",$p(inclb,"||",2),"LB",$p(inclb,"||",3)),"^",1) 
	q:incib="" ""
	s manid=""
	s manid=$o(^DHCINMAN(0,"INCIB",incib,""),-1)
	q:manid="" ""
	q:'$d(^DHCINMAN(manid)) ""
	s rp=+$p(^DHCINMAN(manid),"^",11)
	S muomdr=$p(^DHCINMAN(manid),"^",8)
	S buomdr=$P(^INCI(+inclb,1),"^",10)
	I uomdr="" S uomdr=buomdr
	Q:muomdr=uomdr rp
	s fac1=##class(web.DHCST.Common.UtilCommon).UOMFac(uomdr,buomdr)
	s fac2=##class(web.DHCST.Common.UtilCommon).UOMFac(muomdr,buomdr)
	s rp=rp/fac2*fac1
	
	s herbFlag = ##class(web.DHCST.Common.DrugInfoCommon).IsHerb(+inclb)
	s dFlag = $s(uomdr=buomdr:2,1:1)	
	q ##class(web.DHCST.Common.AppCommon).FormatRp(rp,HospID,dFlag,StkType,herbFlag)
}

/// Descript:取某药品招标进价
/// Creater:zhangdongmei
/// CreateDate:2012-06-19
/// Input:库存项id
/// Output:	
/// Return：进价
ClassMethod GetPbRp(Inci As %String, UomId As %String, HospID As %String = "", StkType = "G") As %Library.String
{
	q:Inci="" 0
	s Add=$o(^DHCITMINFO(0,"INCI",Inci,"")) 
	q:Add="" 0
	s Rp=$p($G(^DHCITMINFO(Add)),"^",22)
	s PurUomId=$p(^INCI(Inci,3),"^",6)
	s BUomId=$p(^INCI(Inci,1),"^",10)
	s Fac1=##class(web.DHCST.Common.UtilCommon).UOMFac(PurUomId,BUomId)
	s Fac2=##class(web.DHCST.Common.UtilCommon).UOMFac(UomId,BUomId)
	s Rp=Rp/Fac1*Fac2
	
	s herbFlag = ##class(web.DHCST.Common.DrugInfoCommon).IsHerb(Inci)
	s dFlag = $s(UomId=BUomId:2,1:1)	
	q ##class(web.DHCST.Common.AppCommon).FormatRp(Rp,HospID,dFlag,StkType,herbFlag)
}

/// Descript:	根据库存项ID、日期、单位及医院取得最近的生效的调价记录，如果没有，则找出最后的调价记录（未生效）
/// 				目前用于药品信息维护界面库存项的进价售价取值
/// Creator:	wangjiabin
/// CreateDate:	20130621
/// Input:		inciid,stdate,uom,HospID
/// Output:		Return
/// Return：	最近的生效的调价记录，如果没有，则找出最后的调价记录（未生效）
/// 			rp^sp^INASP_ExecuteDate(未生效时为INASP_PreExeDate)
ClassMethod GetINCPrice(inciid, stdate, uom, HospID = "", StkType = "G")
{
	q ""
}

/// Description: 定价规则是否存在可用明细规则
/// Return:		 Y(存在)
ClassMethod CheckRuleAdd(Mr)
{
	s Flag=0
	s Mra=0
	f  s Mra=$o(^DHCINMRA(Mr,"I",Mra))  q:(Mra="")!(Flag=1)  d
	.s UseFlagAdd=$p(^DHCINMRA(Mr,"I",Mra),"^",7)
	.q:UseFlagAdd'="Y"
	.s Flag=1
	q Flag
}

/// Description: 根据进价与定价类型获取有效定价规则
ClassMethod GetMarkRuleByMTRp(Rp, MarkType)
{
	s retMRId=""
	s mrId=0
	f  s mrId=$o(^DHCINMR(0,"MT",MarkType,mrId))  q:(mrId="")||(retMRId'="")  d
	.s DHCINMR=$g(^DHCINMR(mrId))
	.s useFlag=$p(DHCINMR,"^",8)
	.q:useFlag'="Y"
	.s minRp=$p(DHCINMR,"^",3)
	.s maxRp=$p(DHCINMR,"^",4)
	.q:minRp>Rp
	.q:maxRp<Rp
	.s retMRId=mrId
	q retMRId
}

/// Description: 根据价格与定价规则,计算售价
/// w ##class(web.DHCST.Common.PriceCommon).GetMTSpByMRRp(50,9)
ClassMethod GetMTSpByMRRp(Rp, MarkRuleId)
{
	s Margin=$p(^DHCINMR(MarkRuleId),"^",5)		// 加成率
	s MarPrice=$p(^DHCINMR(MarkRuleId),"^",10)	// 加成金额
	s SdId=$p(^DHCINMR(MarkRuleId),"^",12)		// 小数规则
	s RuleAdd=..CheckRuleAdd(MarkRuleId)
	i RuleAdd=1  d    ;根据累计定价规则算
	.s NewSp=..CalSpByMTAdd(MarkRuleId,Rp)
	e  d
	.s NewSp=Rp*(1+Margin)+MarPrice
	i SdId'=""  d
 	.s NewSp=..CalDecimal(NewSp,SdId)
	q NewSp
}

/// Description: 根据价格与定价类型,计算售价
/// w ##class(web.DHCST.Common.PriceCommon).GetMTSpByMTRp(100,"1")
ClassMethod GetMTSpByMTRp(Rp, MarkTypeId)
{
	q:Rp="" ""
	q:MarkTypeId="" ""
	s MarkRuleId=..GetMarkRuleByMTRp(Rp,MarkTypeId)
	q:MarkRuleId="" 0
	q ..GetMTSpByMRRp(Rp,MarkRuleId)
}

}
