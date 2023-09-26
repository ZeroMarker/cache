Import SQLUser

Class web.DHCDocOrderCommonExpand Extends DHCDoc.Util.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 医嘱录入调用,医保控费限制
/// w ##Class(web.DHCDocOrderCommonExpand).CheckInsuCostControl(135,"858||1^1^30/03/2015^11:26^1102^^^^^Y^^^^5^2^5^63^0.5^1^1^156^69^^^14^0.875^6^98")
/// w ##Class(web.DHCDocOrderCommonExpand).CheckInsuCostControl(137,"858||1^1^31/03/2015^14:01^1102^^^^^Y^^^^5^2^5^63^0.5^1^1^156^69^^^14^0.875^6^98")
ClassMethod CheckInsuCostControl(EpisodeID As %String, OrdStr As %String) As %String
{
	n (EpisodeID,OrdStr)
	s ^tan("CheckInsuCostControl")=EpisodeID_","_OrdStr
	q:(+EpisodeID=0)!(OrdStr="") ""
	s InOrdStr=""
	s Length=$length(OrdStr,$C(2))
	s i=0
	for {
		s i=i+1
		q:i>Length
		s OneOrder=$p(OrdStr,$C(2),i)
		s OrderARCIMRowid=$p(OneOrder,"^",1)
		s CTLocRowid=$p(OneOrder,"^",2)
		s OrderStartDate=$p(OneOrder,"^",3)
		s OrderStartTime=$p(OneOrder,"^",4)
		s OrderDocCode=$p(OneOrder,"^",5)
		s OrderCarPrvTp=$p(OneOrder,"^",6)
		s BabyBrithDay=$p(OneOrder,"^",7)
		s BabyBrithTime=$p(OneOrder,"^",8)
		s BabyFeeFlag=$p(OneOrder,"^",9)
		s OrderType=$p(OneOrder,"^",10)
		s OrderPriorRowid=$p(OneOrder,"^",14)
		s OrderInstrRowid=$p(OneOrder,"^",15)
		s OrderFreqRowid=$p(OneOrder,"^",16)
		s OrderDurRowid=$p(OneOrder,"^",17)
		s OrderDoseQty=$p(OneOrder,"^",18)
		s OrderPDQty=$p(OneOrder,"^",19)
		s OrderFirstDayTimes=$p(OneOrder,"^",20)
		s OrderDoseUOMRowid=$p(OneOrder,"^",21)
		s OrderPackUOMRowid=$p(OneOrder,"^",22)
		s CalDose=$p(OneOrder,"^",23)
		s OrderPackQty=$p(OneOrder,"^",24)
		s OrderPrice=$p(OneOrder,"^",25)
		s OrderSum=$p(OneOrder,"^",26)
		s UserID=$p(OneOrder,"^",27)
		s RecLocRowid=$p(OneOrder,"^",28)
		
		if (OrderStartDate["-"){
		 	s OrderStartDate=$ZDH(OrderStartDate,3)
	 	}elseif (OrderStartDate["/"){
		 	s OrderStartDate=$ZDH(OrderStartDate,4)
	 	}elseif (OrderStartDate=""){
		 	s OrderStartDate=..%SysDate()
		 }
		
		s ItemCatRowid=$p($g(^ARCIM(+OrderARCIMRowid,$p(OrderARCIMRowid,"||",2),1)),"^",10)
		s OrderType=$P(^ARC("IC",ItemCatRowid),"^",7)
		s OrdCatDR=$P(^ARC("IC",ItemCatRowid),"^",8)
		s $p(OneOrder,"^",1)=OrdCatDR
		if (OrderType="R"){
			s DrugFlag="Y"
		}else{
			s DrugFlag="N"
		}
		s $p(OneOrder,"^",2)=DrugFlag
		s OrderARCIMCode=$p(^ARCIM(+OrderARCIMRowid,$p(OrderARCIMRowid,"||",2),1),"^",1)
		s $p(OneOrder,"^",3)=OrderARCIMCode
		s OrderARCIMDesc=$p(^ARCIM(+OrderARCIMRowid,$p(OrderARCIMRowid,"||",2),1),"^",2)
		s $p(OneOrder,"^",4)=OrderARCIMDesc
		s $p(OneOrder,"^",5)=OrderPackQty
		s $p(OneOrder,"^",6)=OrderPrice
		s $p(OneOrder,"^",7)=OrderSum
		s $p(OneOrder,"^",8)=""	///处方号
		s $p(OneOrder,"^",9)=CTLocRowid
		s $p(OneOrder,"^",10)=$P(^CTLOC(CTLocRowid),"^",2)
		s DoctorID=##class(web.SSUser).GetDefaultCareProvider(UserID)
		s $p(OneOrder,"^",11)=$P(^CTPCP(DoctorID,1),"^",1)
		s $p(OneOrder,"^",12)=$P(^CTPCP(DoctorID,1),"^",2)
		s CarPrvTpDR=$P(^CTPCP(DoctorID,1),"^",4)
		////出诊级别
		s $p(OneOrder,"^",13)=$P(^CT("CPT",CarPrvTpDR),"^",2)
		s $p(OneOrder,"^",13)=CarPrvTpDR
		s OrderPriorCode=$P(^OECPR(OrderPriorRowid),"^",1)
		s $p(OneOrder,"^",14)="N"
		if (OrderPriorCode["OUT"){
			s $p(OneOrder,"^",14)="Y"
		}
		if (OrderInstrRowid'=""){
			s OrderInstrCode=$P($G(^PHCIN(OrderInstrRowid)),"^",1)
			s $p(OneOrder,"^",15)=OrderInstrCode
		}
		if (OrderFreqRowid'=""){
			s OrderFreqCode=$P($g(^PHCFR(OrderFreqRowid)),"^",1)
			s $p(OneOrder,"^",16)=OrderFreqCode
		}
		if (OrderDurRowid'=""){
			s OrderDurCode=$P(^PHCDU(OrderDurRowid),"^",2)
			s $p(OneOrder,"^",17)=OrderDurCode
		}
		s $p(OneOrder,"^",18)=OrderDoseQty
		s $p(OneOrder,"^",19)=OrderPDQty	///每日用量
		s $p(OneOrder,"^",20)=OrderFirstDayTimes
		if (OrderDoseUOMRowid'=""){
			s OrderDoseUOMCode=$P($G(^CT("UOM",OrderDoseUOMRowid)),"^",1)
			s $p(OneOrder,"^",21)=OrderDoseUOMCode
		}
		///22.中药单复方标志^23.数量单位除以单次单位^24.处方用量（null）^25.药品规格^
		/// 26.执行科室编码^27.执行科室描述^28.开医嘱日期^29.开医嘱时间^30.婴儿费标志
		s SDFlag=0
		if ((Length=1)&&(ItemCatRowid'=123)&&(##Class(web.DHCDocOrderCommon).IsCNMedItem(OrderARCIMRowid)=1)){
			///123协定处方子类
			s SDFlag=1
		}
		s ARCIMPHCDFDR=$P(^ARCIM(+OrderARCIMRowid,$P(OrderARCIMRowid,"||",2),1),"^",12)
		s INCIRowid=##class(web.DHCDocOrderEntry).GetINCI(+OrderARCIMRowid)
		s $p(OneOrder,"^",22)=SDFlag		///中药单复方标志
		
		s DrgformRowid=##class(web.DHCDocOrderEntry).GetDrgForm(OrderARCIMRowid)
		i DrgformRowid'="" {
			s PHCDRowid=$P(DrgformRowid,"||",1)
			s ChildSub=$P(DrgformRowid,"||",2)
			if (OrderPackUOMRowid=""){
				//s FormDoseQty=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,2)),"^",5) ;Pharmacy base UOM
				s OrderPackUOMRowid=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,2)),"^",4)
			}
		}
		
		s ConFac=""
		if (OrderPackUOMRowid'="")&&(OrderDoseUOMRowid'="") {
			s ConFacID=$O(^CT("CTCF",0,"UOM",OrderPackUOMRowid,OrderDoseUOMRowid,""))
			i ConFacID="" s ConFac=0
			e  s ConFac=$p(^CT("CTCF",ConFacID),"^",3)
		}
		i +ConFac=0  s ConFac=1
		
		
		///数量单位除以单次单位
		s $p(OneOrder,"^",23)=ConFac
				
		s $p(OneOrder,"^",24)=""		///处方用量（null）
		s $p(OneOrder,"^",25)=##Class(web.DHCDocOrderCommon).Getspec(OrderARCIMRowid)		///25.药品规格
		s $p(OneOrder,"^",26)=RecLocRowid
		s $p(OneOrder,"^",27)=$P(^CTLOC(RecLocRowid),"^",2)
		s $p(OneOrder,"^",28)=$ZD(OrderStartDate,3)
		s $p(OneOrder,"^",29)=OrderStartTime
		s BabyInfo=..GetBabyInfo(EpisodeID)
		s $p(OneOrder,"^",30)=$P(BabyInfo,"^",1)
		if (OrderPackUOMRowid'=""){
			s OrderPackUOMCode=$P($G(^CT("UOM",OrderPackUOMRowid)),"^",1)
			s $p(OneOrder,"^",31)=OrderPackUOMCode
		}
		
		s $p(InOrdStr,"|",i)=OneOrder
		
	}
	//s InOrdStr=$tr(InOrdStr,"$","|")
	//s MRDiagnoseList=..GetMRDiagnoseList(EpisodeID)
	//s OPSStr=..GetOPS(EpisodeID)
	/// 1.医嘱分类^2.药品标志^3.医嘱项编码^4.医嘱项描述^5.数量^
	/// 6.单价^7.费用^8.处方号^9.开医嘱科室编码^10.开医嘱科室描述^
	/// 11.开医嘱医生编码^12.开医嘱医生名称^13.医生级别^14.出院带药标志YN^15.用药途径^
	/// 16.频次^17.疗程^18.单次用量^19.每日用量^20.首次用量^
	/// 21.用量单位^22.中药单复方标志^23.数量单位除以单次单位^24.处方用量（null）^25.药品规格^
	/// 26.执行科室编码^27.执行科室描述^28.开医嘱日期^29.开医嘱时间^30.婴儿费标志
	s Rtn=##class(insuqc.service.dic.ServicePort).CheckDictionaryRules(EpisodeID,InOrdStr,"","","")
	/*
		医嘱是否合规标志!违规信息展示方式!各个医嘱的验证结果
	///           合规标志           --> 1 符合规定 0：不合规定
	///           违规信息展示方式   --> 0 提醒类消息 1 警告类消息(需要医生来确定是否可以开) 2 完全控制类消息(只要违规就不能开医嘱)      
	///           各个医嘱的验证结果 --> 第一条医嘱的验证结果|第二条医嘱的验证结果|....	
	///				医嘱的验证结果:合规标志^信息展示方式^违规信息内容
	*/
	if (+Rtn=1){
		q ""
	}
	s ErrType=$P(Rtn,"!",2)
	s ErrInfo=$P(Rtn,"!",3)
	s ErrMsg=""
	
	s length=$length(Rtn,"|")
	for i=1:1:length {
		s Msg=$P(ErrInfo,"|",i)
		s Type=$P(Msg,"^",1)
		continue:Type=1
		s OneMsg=$P(Msg,"^",3)
		if (ErrMsg="") {
			s ErrMsg=OneMsg
		}else{
			s ErrMsg=ErrMsg_";\n"_OneMsg
		}
	}
	q ErrType_"^"_ErrMsg
}

ClassMethod CheckInsuCostControlbak(EpisodeID As %String, OrdStr As %String) As %String
{
	n (EpisodeID,OrdStr)
	s ^tan("CheckInsuCostControl")=EpisodeID_","_OrdStr
	q:(+EpisodeID=0)!(OrdStr="") ""
	s InOrdStr=""
	s Length=$length(OrdStr,"$")
	s i=0
	for {
		s i=i+1
		q:i>Length
		s OneOrder=$p(OrdStr,"$",i)
		s OrderARCIMRowid=$p(OneOrder,"^",1)
		s CTLocRowid=$p(OneOrder,"^",2)
		s OrderStartDate=$p(OneOrder,"^",3)
		s OrderStartTime=$p(OneOrder,"^",4)
		s OrderDocCode=$p(OneOrder,"^",5)
		s OrderCarPrvTp=$p(OneOrder,"^",6)
		s BabyBrithDay=$p(OneOrder,"^",7)
		s BabyBrithTime=$p(OneOrder,"^",8)
		s BabyFeeFlag=$p(OneOrder,"^",9)
		s OrderPriorRowid=$p(OneOrder,"^",14)
		s OrderInstrRowid=$p(OneOrder,"^",15)
		s OrderFreqRowid=$p(OneOrder,"^",16)
		s OrderDurRowid=$p(OneOrder,"^",17)
		s OrderDoseUOM=$p(OneOrder,"^",21)
		s OrderPackUOMRowid=$p(OneOrder,"^",22)
		s CalDose=$p(OneOrder,"^",23)
		s RecLocRowid=$p(OneOrder,"^",28)
		
		
		s OrderARCIMCode=$p(^ARCIM(+OrderARCIMRowid,$p(OrderARCIMRowid,"||",2),1),"^",1)
		s $p(OneOrder,"^",1)=OrderARCIMCode
		s CTLocCode=$p(^CTLOC(CTLocRowid),"^",1)
		s $p(OneOrder,"^",2)=CTLocCode
		
		i OrderStartDate'="" s OrderStartDate=$ZD($ZDH(OrderStartDate,4),3)
		e  s OrderStartDate=$ZD(+$h,3)
		i OrderStartTime'="" s OrderStartTime=..%ZT(..%ZTH(OrderStartTime))
		e  s OrderStartTime=..%ZT(..%SysTime())
		s $p(OneOrder,"^",3)=OrderStartDate
		s $p(OneOrder,"^",4)=OrderStartTime
		
		if (OrderDocCode'="")&&(OrderCarPrvTp=""){
			s OrderCarPrvTpDr=$p(^CTPCP(OrderDocCode,1),"^",4)
			if (OrderCarPrvTpDr'=""){
				s OrderCarPrvTp=$p(^CT("CPT",OrderCarPrvTpDr),"^",1)
				s $p(OneOrder,"^",6)=OrderCarPrvTp
			}
		}
		s BabyInfo=..GetBabyInfo(EpisodeID)
		s BabyFeeFlag=$p(BabyInfo,"^",1)
		s BabyBrithDay=$p(BabyInfo,"^",2)
		s BabyBrithTime=$p(BabyInfo,"^",3)
		s $p(OneOrder,"^",7)=BabyBrithDay
		s $p(OneOrder,"^",8)=BabyBrithTime
		s $p(OneOrder,"^",9)=BabyFeeFlag
		
		if (OrderPriorRowid'=""){
			s OrderPriorCode=$p($g(^OECPR(OrderPriorRowid)),"^",1)
			s $p(OneOrder,"^",14)=OrderPriorCode
		}
		if (OrderInstrRowid'=""){
			s OrderInstrCode=$P($G(^PHCIN(OrderInstrRowid)),"^",1)
			s $p(OneOrder,"^",15)=OrderInstrCode
		}
		if (OrderFreqRowid'=""){
			s OrderFreqCode=$P($g(^PHCFR(OrderFreqRowid)),"^",1)
			s $p(OneOrder,"^",16)=OrderFreqCode
		}
		if (OrderDurRowid'=""){
			s OrderDurCode=$P(^PHCDU(OrderDurRowid),"^",2)
			s $p(OneOrder,"^",17)=OrderDurCode
		}
		if (OrderDoseUOM'=""){
			s OrderDoseUOMCode=$P($G(^CT("UOM",OrderDoseUOM)),"^",1)
			s $p(OneOrder,"^",21)=OrderDoseUOMCode
		}
		if (OrderPackUOMRowid'=""){
			s OrderPackUOMCode=$P($G(^CT("UOM",OrderPackUOMRowid)),"^",1)
			s $p(OneOrder,"^",22)=OrderPackUOMCode
		}
		
		
		s DrgformRowid=##class(web.DHCDocOrderEntry).GetDrgForm(OrderARCIMRowid)
		if (DrgformRowid'="")&&(OrderDoseUOM'="")&&(CalDose=""){
			s CalDose=..CalDose(OrderDoseUOM,DrgformRowid)
			s $p(OneOrder,"^",23)=CalDose
		}
		s RecLocCode=$p(^CTLOC(RecLocRowid),"^",1)
		s $p(OneOrder,"^",28)=RecLocCode
		
		s $p(InOrdStr,"$",i)=OneOrder
		
	}
	s InOrdStr=$tr(InOrdStr,"$","|")
	s MRDiagnoseList=..GetMRDiagnoseList(EpisodeID)
	s OPSStr=..GetOPS(EpisodeID)
	//w EpisodeID,!
	//w MRDiagnoseList,!
	//w OPSStr,!
	//w InOrdStr,!
	s Rtn=##class(insuqc.service.INSUQCPort).CheckDicItmInfoForDoctor(EpisodeID,MRDiagnoseList,OPSStr,InOrdStr)
	//w Rtn,!
	/*
	-1 ->参数有错误		
	正常情况下：		
	医嘱项目1返回值!医嘱项目2返回值!医嘱项目3返回值!医嘱项目4返回值…		
	医嘱项目返回值->是否有知识库标志|能否开医嘱的标志|项目库级别|项目库ID|项目政策说明|违规信息|规则描述拼串|规则详细信息拼串		
               是否有知识库标志 -> 1 有 0 无		
               能否开医嘱的标志 -> 1 能开 0 不能开		
               规则详细信息拼串->策略明细1^策略明细2^策略明细3…		
               策略明细  ->策略rowid:策略编码:策略描述:策略子分类：策略大分类:…		
	*/
	s length=$length(Rtn,"!")
	s errInfo=""
	s i=0
	for {
		s i=i+1
		q:i>length
		s OneRtn=$p(Rtn,"!",i)
		continue:$p(OneRtn,"|",2)'=0
		s ARCIMRowid=$p($P(OrdStr,"$",i),"^",1)
		s ARCName=$P(^ARCIM(+ARCIMRowid,$P(ARCIMRowid,"||",2),1),"^",2)
		//s err=$p(OneRtn,"|",3,$length(OneRtn,"|"))
		s err=$p(OneRtn,"|",6)
		i errInfo="" s errInfo=ARCName_":"_err
		else  s errInfo=errInfo_"-"_ARCName_":"_err
	}
	
	if (errInfo'=""){
		s errInfo="根据医保控费政策："_errInfo
	}
	
	q errInfo
}

/// creator:郭荣勇
/// date:2015-04-24
/// desc:医保调用,获取医保控费需要的信息
/// input:诊断信息|手术信息|医嘱项信息
/// output:EpisodeID-> 就诊表的指针,OrdRowId -> 医嘱执行记录或者医嘱Dr
/// w ##Class(web.DHCDocOrderCommonExpand).GetInsuCostControlInfo("118||294||1")
ClassMethod GetInsuCostControlInfo(EpisodeID As %String, OrdRowId As %String) As %String
{
	n (EpisodeID,OrdRowId)
	s OEORIRowId=""
	if $l(OrdRowId,"||")=3 {
		s OEORIRowId=$p(OrdRowId,"||",1,2)
	}elseif $l(OrdRowId,"||")=2 {
		s OEORIRowId=OrdRowId
	}
	
	Q:OEORIRowId="" ""
	s EpisodeID=$P(^OEORD(+OEORIRowId),"^",1)
	s OEORIInfo=..GetOEORIInfo(+OEORIRowId,$p(OEORIRowId,"||",2))
	Q:OEORIInfo="" ""
	s OEORIInfo=$tr(OEORIInfo,"|","^")
	
	s MRDiagnoseInfo=..GetMRDiagnoseList(EpisodeID)
	
	s OPSInfo=..GetOPS(EpisodeID)
	
	s myrtnStr=MRDiagnoseInfo_"|"_OPSInfo_"|"_OEORIInfo
	
	Q myrtnStr
}

/// 根据医嘱记录ID获取医嘱信息
/// w ##Class(web.DHCDocOrderCommonExpand).GetOEORIInfo("118||294")
ClassMethod GetOEORIInfo(OEORIRowId As %String, Child As %String) As %String
{
	n (OEORIRowId,Child)
	s EpisodeID=$P(^OEORD(OEORIRowId),"^",1)
	/*
	1	医嘱项编码2	医嘱科室3	医嘱日期4	医嘱时间5	医嘱医生编码
	6	医嘱医生职称7	婴儿出生日期8	婴儿出生时间9	婴儿费标志10	是否药品
	11	单方复方标志12	中药贴数13	中药用量14	医嘱优先级编码15	用药途径
	16	用法(频次)17	疗程18	单次用量19	每日用量20	首次服药量
	21	用量对应的单位22	数量单位23	数量单位与用量单位关系24	数量25	单价
	26	金额27	用户ID28	接受科室
	*/
	s OrderARCIMRowID=$p(^OEORD(OEORIRowId,"I",Child,1),"^",2)
	s OrderARCIMCode=$p(^ARCIM(+OrderARCIMRowID,$p(OrderARCIMRowID,"||",2),1),"^",1)
	s OrdDeptDr=$p(^OEORD(OEORIRowId,"I",Child,1),"^",3)
	s CTLocCode=$p(^CTLOC(OrdDeptDr),"^",1)
	s OrderSttDat=$p(^OEORD(OEORIRowId,"I",Child,1),"^",9)
	s OrderSttDat=$zd(OrderSttDat,3)
	s OrderSttTime=$p(^OEORD(OEORIRowId,"I",Child,1),"^",10)
	s OrderSttTime=..%ZT(OrderSttTime)
	s DoctorDR=$p(^OEORD(OEORIRowId,"I",Child,1),"^",11)
	s OrderCarPrvTp=""
	s OrderCarPrvTpDr=$p(^CTPCP(DoctorDR,1),"^",4)
	if (OrderCarPrvTpDr'=""){
		s OrderCarPrvTp=$p(^CT("CPT",OrderCarPrvTpDr),"^",1)
	}
	s BabyInfo=..GetBabyInfo(EpisodeID)
	s BabyFeeFlag=$p(BabyInfo,"^",1)
	s BabyBrithDay=$p(BabyInfo,"^",2)
	s BabyBrithTime=$p(BabyInfo,"^",3)
	s $p(OneOrder,"^",7)=BabyBrithDay
	s $p(OneOrder,"^",8)=BabyBrithTime
	s $p(OneOrder,"^",9)=BabyFeeFlag
	s ItemCatDR=$p(^ARCIM(+OrderARCIMRowID,$p(OrderARCIMRowID,"||",2),1),"^",10)
	s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)
	s DurgFlag="Y"
	if (OrderType'="R") s DurgFlag="N"
	s CMSubCategory=##Class(web.DHCDocOrderCommon).GetCNMedItemCatStr()
	s CMSubCategory="^"_CMSubCategory_"^"
	s SDFlag=""
	s CMQty=""
	s CMDoseQty=""
	if (CMSubCategory[("^"_ItemCatDR_"^")){
		//中药
		s PrescNo=$p(^OEORD(OEORIRowId,"I",Child,1),"^",14)
		s SDFlag=1
		if ($o(^OEORD(0,"PrescNo",PrescNo,OEORIRowId,Child))="")&&($o(^OEORD(0,"PrescNo",PrescNo,OEORIRowId,Child),-1)=""){
			s SDFlag=0
		}
		s DurationRowid=$p($g(^OEORD(OEORIRowId,"I",Child,2)),"^",6)
		s CMQty=$p(^PHCDU(DurationRowid),"^",2)
		s CMDoseQty=$p($g(^OEORD(OEORIRowId,"I",Child,1)),"^",12) //数量
		
	}
	s OrderPriorRowid=$P($G(^OEORD(OEORIRowId,"I",Child,1)),"^",8)
	s OrderPriorCode=$p($g(^OECPR(OrderPriorRowid)),"^",1)
	s InstructionRowid=$p($g(^OEORD(OEORIRowId,"I",Child,2)),"^",7)
	s InstructionCode=""
	s:InstructionRowid'="" InstructionCode=$p(^PHCIN(InstructionRowid),"^",1)
	s FrequenceRowid=$p($G(^OEORD(OEORIRowId,"I",Child,2)),"^",4)
	s FrequenceCode=""
	s:FrequenceRowid'="" FrequenceCode=$P($g(^PHCFR(FrequenceRowid)),"^",1)
	s OrderFreqFactor=""
	s:FrequenceRowid'="" OrderFreqFactor=$P($g(^PHCFR(FrequenceRowid)),"^",2)
	s OrderDurRowid=$p($g(^OEORD(OEORIRowId,"I",Child,2)),"^",6)
	s OrderDurCode=""
	s:OrderDurRowid'="" OrderDurCode=$P(^PHCDU(OrderDurRowid),"^",2)
	s DoseQty=$p($g(^OEORD(OEORIRowId,"I",Child,1)),"^",12)
	s OrderPDQty=DoseQty*OrderFreqFactor
	
	s DoseUOM=$p($g(^OEORD(OEORIRowId,"I",Child,2)),"^",3) 
	s OrderDoseUOMCode=""
	s:DoseUOM'="" OrderDoseUOMCode=$P($G(^CT("UOM",DoseUOM)),"^",1)
	
	s OrderPackUOMRowid=$p($g(^ARCIM(+OrderARCIMRowID,$p(OrderARCIMRowID,"||",2),8)),"^",14)
	s OrderPackUOMCode=""
	s:OrderPackUOMRowid'="" OrderPackUOMCode=$P($G(^CT("UOM",OrderPackUOMRowid)),"^",1)
	
	s DrgformRowid=##class(web.DHCDocOrderEntry).GetDrgForm(OrderARCIMRowID)
	s CalDose=""
	if (DrgformRowid'="")&&(DoseUOM'=""){
		s CalDose=..CalDose(DoseUOM,DrgformRowid)
	}
	s QtyPackUOM=$P($G(^OEORD(OEORIRowId,"I",Child,9)),"^",4)
	
	s EpissubtypeId=$P($g(^PAADM(EpisodeID,1)),"^",6)
	s AdmReasonId=$P($g(^PAADM(EpisodeID,1)),"^",7)
	s PAADMRegConDisDR=$P($G(^PAADM(EpisodeID,"DHC")),"^",25)
	i QtyPackUOM'=""{
		i QtyPackUOM<1 s QtyPackUOM="0"_$number(QtyPackUOM)
		;包含基础单位和整包装代为的价格转换
		s ArcPrice=##class(web.DHCDocOrderCommon).GetOrderPrice(EpissubtypeId,AdmReasonId,OrderARCIMRowID , $H, "", "","", "","",PAADMRegConDisDR)
	}else{
		;只是基本单位的价格
		s ArcPrice=##class(web.UDHCJFPRICE).GetOrderPrice(EpissubtypeId,AdmReasonId,OrderARCIMRowID , $H, "", "","", "",PAADMRegConDisDR)  //李洪磊
		
	}
	s Price=$j($p(ArcPrice,"^",1),3,4)
	s OrderSum=QtyPackUOM*Price
	i ((+QtyPackUOM=0)&&(OrderType="R"))  d
	..s Qty=##Class(web.DHCDocOrderEntry).CalDose(DoseUOM,DrgformRowid,DoseQty)
	..s OrderPackQty=+Qty*$P(^PHCFR(FrequenceRowid),"^",2)*$P(^PHCDU(OrderDurRowid),"^",2)
	..s OrderSum=OrderPackQty*ArcPrice
	
	s UserID=$o(^SSU("SSUSR",0,"CTPCP",DoctorDR,0))
	s RecDepDR=$p(^OEORD(OEORIRowId,"I",Child,3),"^",6)
	s RecLocCode=$p(^CTLOC(RecDepDR),"^",1)
	//1
	s OrdStr=OrderARCIMCode_"|"_CTLocCode_"|"_OrderSttDat_"|"_OrderSttTime_"|"_DoctorDR
	//6
	s OrdStr=OrdStr_"|"_OrderCarPrvTp_"|"_BabyBrithDay_"|"_BabyBrithTime_"|"_BabyFeeFlag_"|"_DurgFlag
	//11
	s OrdStr=OrdStr_"|"_SDFlag_"|"_CMQty_"|"_CMDoseQty_"|"_OrderPriorCode_"|"_InstructionCode
	//16
	s OrdStr=OrdStr_"|"_FrequenceCode_"|"_OrderDurCode_"|"_DoseQty_"|"_OrderPDQty_"|"_DoseQty
	//21
	s OrdStr=OrdStr_"|"_OrderDoseUOMCode_"|"_OrderPackUOMCode_"|"_CalDose_"|"_QtyPackUOM_"|"_Price
	s OrdStr=OrdStr_"|"_OrderSum_"|"_UserID_"|"_RecLocCode
	q OrdStr
}

/// /根据执行记录ID获取医保所需信息
/// w ##Class(web.DHCDocOrderCommonExpand).GetOrdExecInfo("118||294||1")
ClassMethod GetOrdExecInfo(OEORERowId As %String) As %String
{
	
	n (OEORERowId)
	q:OEORERowId="" ""
	
	s OEORIRowId=+OEORERowId
	s Child=$P(OEORERowId,"||",2)
	s Sub=$P(OEORERowId,"||",3)
	q:((OEORIRowId="")||(Child="")||(Sub="")) ""
	q:'$D(^OEORD(OEORIRowId,"I",Child,"X",Sub)) ""
	Q ..GetOEORIInfo(OEORIRowId,Child)
}

/// /获取单病种信息
/// w ##Class(web.DHCDocOrderCommonExpand).GetInsuSingleDisInfo(137)
ClassMethod GetInsuSingleDisInfo(EpisodeID As %String) As %String
{
	n (EpisodeID)
	q:EpisodeID="" ""
	s PAAdmType=$p($g(^PAADM(EpisodeID)),"^",2)
	q:PAAdmType'="I" ""
	s Rtn=##class(insuqc.service.INSUQCPort).GetInsuSingleDisInfo(EpisodeID)
	q:+Rtn<=0 ""
	s SingleDisInfo=""
	s length=$length(Rtn,"!")
	s i=1
	for {
		s i=i+1
		q:i>length
		s OneDisInfo=$p(Rtn,"!",i)
		i SingleDisInfo="" s SingleDisInfo=$P(OneDisInfo,"^",1)_$C(1)_$P(OneDisInfo,"^",2)
		e  s SingleDisInfo=SingleDisInfo_"^"_$P(OneDisInfo,"^",1)_$C(1)_$P(OneDisInfo,"^",2)
	}
	if (SingleDisInfo'=""){
		s SingleDisInfo=$C(1)_"^"_SingleDisInfo
	}
	q SingleDisInfo
}

/// w ##Class(web.DHCDocOrderCommonExpand).SetPAADMSingleDis(138,10048)
/// ///设置病人的单病种信息
ClassMethod SetPAADMSingleDis(EpisodeID As %String, SingleDis As %String) As %String
{
	s ^tan("SetPAADMSingleDis")=EpisodeID_","_SingleDis
	///PA_ADM2->PAADM_PatientLetterNotes
	s obj=##Class(User.PAAdm).%OpenId(EpisodeID)
	if (obj.PAADMPatientLetterNotes.Count()=0)
	{
		do obj.PAADMPatientLetterNotes.Insert(SingleDis)
	}
	else
	{
		do obj.PAADMPatientLetterNotes.SetAt(SingleDis,1)
	}
	s sc=obj.%Save()
	q sc
}

/// 向消息表中插入医保控费信息
/// w ##Class(web.DHCDocOrderCommonExpand).InsertInsuCostControlMessage()
ClassMethod InsertInsuCostControlMessage() As %String
{
	n
	s rowid=""
	f  s rowid=$o(^PAC("ADMLOC",0,"AdmType","I",rowid))  q:rowid=""  d
	.q:($d(^CTLOC(rowid))=0)
	.//1：基金总额使用情况 0：人次基金金额使用情况
	.s ret=##class(insuqc.service.INSUQCPort).GetLocCurrtnInsuFeeInfo(rowid,"1")
	.s Total=##class(web.DHCOPAdmReg).RMBDXXZH("","",+$p(ret,"|",2))
	.s Sum=##class(web.DHCOPAdmReg).RMBDXXZH("","",+$p(ret,"|",3))
	.s Info="医保控费额度提醒->基金总额使用情况->医保限额："_Total_",已使用:"_Sum
	.s Info="^"_Info_"^3^^^"_rowid
	.s ret=##Class(web.DHCMessage).SendMessage(Info)
	.s ret=##class(insuqc.service.INSUQCPort).GetLocCurrtnInsuFeeInfo(rowid,0)
	.s Total=##class(web.DHCOPAdmReg).RMBDXXZH("","",+$p(ret,"|",2))
	.s Sum=##class(web.DHCOPAdmReg).RMBDXXZH("","",+$p(ret,"|",3))
	.s Info="人次基金金额使用情况->医保限额："_Total_",已使用:"_Sum
	.s Info="^"_Info_"^3^^^"_rowid
	.s ret=##Class(web.DHCMessage).SendMessage(Info)
	//w ##class(insuqc.service.INSUQCPort).GetLocCurrtnInsuFeeInfo("1","1")
	//w ##Class(web.DHCMessage).SendMessage("^医保指控提醒：费用余额^3^^^1")
	q 1
}

/// w ##Class(web.DHCDocOrderCommonExpand).PAADMSingleDisInfo(4)
/// 获取病人的单病种信息
ClassMethod PAADMSingleDisInfo(EpisodeID As %String) As %String
{
	///PA_ADM2->PAADM_PatientLetterNotes
	q:EpisodeID="" ""
	s SingleDisSub=$o(^PAADM(EpisodeID,"PLN",""),-1)
	q:+SingleDisSub=0 ""
	q $g(^PAADM(EpisodeID,"PLN",SingleDisSub))
}

/// Description: 计算医嘱的基本数量
/// Table        
/// Input        uom:剂量单位      drgform：药学项
/// Return       返回基本数量
/// w ##Class(web.DHCDocOrderCommonExpand).CalDose(329,"499||1")
ClassMethod CalDose(DoseUOM As %String, DrgformRowid As %String) As %String
{
	
 n (DoseUOM,DrgformRowid)
 q:(+DoseUOM=0)!(+DrgformRowid=0) ""
 s eqUom=""
 s Drgform1=+DrgformRowid,Drgform2=$p(DrgformRowid,"||",2)
 q:(Drgform1="")!(Drgform2="") ""
 s BSUOMph=$p(^PHCD(Drgform1,"DF",Drgform2,2),"^",4)    ;Pharmacy base UOM
 i DoseUOM'=BSUOMph{                                    ;Table - PHC_FormDoseEquiv
 	s leq=0
 	f {
	 	s leq=$o(^PHCD(Drgform1,"DF",Drgform2,"EQ",leq))
	 	q:leq=""
	 	q:eqUom=DoseUOM
	 	s eqrec=^PHCD(Drgform1,"DF",Drgform2,"EQ",leq)
	 	s eqUom=$p(eqrec,"^")
	 	s eqqty=$p(eqrec,"^",2)
 	}
 }
 else{
 	s eqqty=1
 }
 q eqqty
}

/// w ##Class(web.DHCDocOrderCommonExpand).GetMRDiagnoseList(30719)
/// 获取诊断串
ClassMethod GetMRDiagnoseList(EpisodeID As %String) As %String
{
	n (EpisodeID)
	q:+EpisodeID=0 ""
	s MRDiagnoseList=""
	s MRADMID=$P($g(^PAADM(EpisodeID)),"^",61)
	q:MRADMID="" MRDiagnoseList
	s rs=##class(%ResultSet).%New("web.DHCDocDiagnosNew:Find")
	i rs.QueryIsValid() { 
		Set Status=rs.Execute(MRADMID)
		Set columns = rs.GetColumnCount()
		If 'Status Quit
		While rs.Next() {
			s ICDCode=rs.Data("MRDIAICDCodeDRCode")
			s ICDDesc=rs.Data("MRDIAICDCodeDRDesc")
			if (ICDDesc=""){
				s ICDDesc=rs.Data("MRDIADesc")
				if (ICDDesc'="")&&($$$ISOK($LV(ICDDesc))) s ICDDesc=$ListToString(ICDDesc,"、")
			}
			i MRDiagnoseList="" s MRDiagnoseList=ICDCode_"-"_ICDDesc
			e  s MRDiagnoseList=MRDiagnoseList_"^"_ICDCode_"-"_ICDDesc
		}	
	}
	q MRDiagnoseList
}

/// 获取手术列表
/// w ##Class(web.DHCDocOrderCommonExpand).GetOPS(29489)
ClassMethod GetOPS(EpisodeID As %String) As %String
{
	n (EpisodeID)
	q:+EpisodeID=0 ""
	s OPSList=""
	s OPARowid=0
	f {
		s OPARowid=$o(^DHCANOPArrange(0,"Adm",EpisodeID,OPARowid))
		q:OPARowid=""
		
		s chl=$P($P(^DHCANOPArrange(OPARowid),"^",2),"||",2)
		s prediag="",diamen=""
		s subchl=0 
		f {
			s subchl=$O(^OR(EpisodeID,"ANA",chl,"OP",subchl)) 
			q:(subchl="")
			s opdr=$P(^OR(EpisodeID,"ANA",chl,"OP",subchl),"^",6)       		;ANAOP_Type_DR     ；手术名称
			i opdr'=""{
				i $P($g(^ORC("OPER",+opdr)),"^",2)'=""{
					s OPDes=$P($g(^ORC("OPER",+opdr)),"^",2)
					s OPCode=$P($g(^ORC("OPER",+opdr)),"^",14)
					if OPSList="" s OPSList=OPCode_"-"_OPDes
					e  s OPSList=OPSList_"^"_OPCode_"-"_OPDes
					
				}
			}else{
				i $g(^OR(EpisodeID,"ANA",chl,"OP",subchl,"REM",2))'="" {
					s OPDes=$G(^OR(EpisodeID,"ANA",chl,"OP",subchl,"REM",2))
					s OPCode=""
					if OPSList="" s OPSList=OPCode_"-"_OPDes
					e  s OPSList=OPSList_"^"_OPCode_"-"_OPDes
				}
			}
		}
	}
	
	q OPSList
}

ClassMethod GetBabyInfo(EpisodeID) As %String
{
	n (EpisodeID)
	s MotherAdmDR=$p(^PAADM(EpisodeID),"^",75)
	s BabyBrithDay=""
	s BabyBrithTime=""
	s BabyFeeFlag="N"
	if (MotherAdmDR=""){
		q BabyFeeFlag_"^"_BabyBrithDay_"^"_BabyBrithTime
	}
	
	s PatientID=$P(^PAADM(EpisodeID),"^",1)
	s MotherPatientID=$P(^PAADM(MotherAdmDR),"^",1)
	s PregnancyRowID=$o(^PAPRGi("PREG_Person",MotherPatientID,0))
	s BabyBrithTime=""
	if (PregnancyRowID'=""){
		s DeliverID=0
		for {
			s DeliverID=$o(^PAPRG(PregnancyRowID,"DEL",DeliverID))
			q:DeliverID=""
			q:BabyBrithTime'=""
			s BabyRowID=0
			for {
				s BabyRowID=$o(^PAPRG(PregnancyRowID,"DEL",DeliverID,"BABY",BabyRowID))
				q:BabyRowID=""
				q:BabyBrithTime'=""
				s BabyPatientID=$p(^PAPRG(PregnancyRowID,"DEL",DeliverID,"BABY",BabyRowID),"^",73)
				if (BabyPatientID=PatientID){
					s BabyBrithTime=$p(^PAPRG(PregnancyRowID,"DEL",DeliverID,"BABY",BabyRowID),"^",49)
					s BabyBrithDay=$p(^PAPRG(PregnancyRowID,"DEL",DeliverID,"BABY",BabyRowID),"^",13)
				}
			}
		}
	}
	s:BabyBrithDay'="" BabyBrithDay=$ZD(BabyBrithDay,3)
	s:BabyBrithTime'="" BabyBrithTime=..%ZT(BabyBrithTime)
	s BabyFeeFlag="Y"
	
	q BabyFeeFlag_"^"_BabyBrithDay_"^"_BabyBrithTime
}

}
