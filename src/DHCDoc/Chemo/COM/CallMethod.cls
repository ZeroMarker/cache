/// CTOR: QP
/// DATE: 2020-06-25
/// DESC: 调用接口类
Class DHCDoc.Chemo.COM.CallMethod Extends DHCDoc.Util.RegisteredObject [ ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2020-06-25
/// DESC: 获取最近一次生命体征信息接口
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.COM.CallMethod).GetLastVSInfo("647")
ClassMethod GetLastVSInfo(EpisodeID As %String, PAAdmType As %String = "")
{
	//舒张压^收缩压^体重^身高^体温^脉搏^呼吸^体重指数^体表面积
	s ^QP("GetLastVSInfo")=$lb(EpisodeID,PAAdmType)
	s mRtn=""
	Q mRtn
	//s OResult=##class(web.DHCAlloc).GetUpdateByAdm(EpisodeID)
	s VSOBJ=##class(DHCDoc.Chemo.Model.VSInfo).GetOBJ(EpisodeID,PAAdmType)
	s ScoreStr=##class(NurMp.Sources.RecordInterface).GetRecordsValue(EpisodeID)	//@100^@100
	s ECOGStr=$p(ScoreStr,"^",1)
	s KQScoreStr=$p(ScoreStr,"^",2)
	s Height=VSOBJ.Height
	s Weight=VSOBJ.Weight
	s Temperature=VSOBJ.Temprature
	s Blood=VSOBJ.BloodPressure
	s Pulse=VSOBJ.Pulse
	s Oxygen=VSOBJ.SPO2
	s ECOG=$p(ECOGStr,"@",2)
	s KQScore=$p(KQScoreStr,"@",2)
	s DataSR=VSOBJ.CareDate_" "_VSOBJ.CareTime_" "_VSOBJ.LocDesc
	s mRtn=Height_$c(1)_Weight_$c(1)_Temperature_$c(1)_Blood_$c(1)_Pulse_$c(1)_Oxygen
	s mRtn=mRtn_$c(1)_ECOG_$c(1)_KQScore_$c(1)_DataSR
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-06-25
/// DESC: 获取血清肌酸酐值
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.COM.CallMethod).GetSCValue("398")
ClassMethod GetSCValue(EpisodeID As %String)
{
	S mRtn=""
	s mRtn=##class(LabService.TCResult).GetTCReesultByAdmNo(EpisodeID,"CR")
	i mRtn'="" s mRtn=$p(mRtn,$Char(2),3)_""_$p(mRtn,$Char(2),4)
	Q mRtn
}

/// CTOR: QP
/// DATE: 2021-01-20
/// DESC: 就诊号Adm、病历展现结构的DocIDList（以“^”作为分隔符）
/// IN  : 
/// OUT : 有效的病例实例ID列表，以“^”作为分割符
/// EXEC: w ##class(DHCDoc.Chemo.COM.CallMethod).GetValidInstanceIDList("1504")
ClassMethod GetValidInstanceIDList(EpisodeID As %String)
{
	S mRtn=""
	s mRtn=##Class(EMRservice.BL.opInterfaceBase).GetValidInstanceIDList(EpisodeID,"84")
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2021-01-20
/// DESC: 获取页面静态属性值
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.COM.CallMethod).GetPageGloabl("12175^30^15^2^^20","2021")
ClassMethod GetPageGloabl(SessionStr = "", EpisodeID = "")
{
	/*
	s BLChemoAuth=..GetBLChemoAuth(UserID)
	s IsDiffcultBL=..GetValidInstanceIDList(EpisodeID)
	s ChemoAuth=..GetChemoAuth(UserID)
	
	Q BLChemoAuth_"^"_IsDiffcultBL_"^"_ChemoAuth
	*/
	s dynObj={
		"OrderLimit":"",	;未下诊断可以开医嘱【安全组功能授权】
		"DischConfirmed":"",		;是否医疗结算
		"LimitTime":""
	}
	s InUser=$p(SessionStr,"^",1)
	s InGroup=$p(SessionStr,"^",2)
	s InLoc=$p(SessionStr,"^",3)
	s InHosp=$p(SessionStr,"^",4)
	
	s OrderLimit = $g(^DHCDocConfig("HospDr_"_InHosp,"OrderLimit",InGroup))
	do dynObj.%Set("OrderLimit",OrderLimit)
	i EpisodeID'="" {
		s DischConfirmed=##class(DHCDoc.Chemo.COM.Func).GetEstDischInfo(EpisodeID,.EstJson)
		s AdmType=$p(^PAADM(EpisodeID),"^",2)
		i AdmType'="I" {
			s LimitTimeStr=##class(web.DHCDocOrderCommon).GetVisitTimeToDay(EpisodeID)
			do dynObj.%Set("LimitTime",+LimitTimeStr)	
		}
		do dynObj.%Set("DischConfirmed",DischConfirmed)	
		
	}
	
	Q dynObj.%ToJSON()
}

/// CTOR: QP
/// DATE: 2021-01-20
/// DESC: 获取疑难病例化疗权限
/// IN  : 
/// OUT : Y/N
/// EXEC: w ##class(DHCDoc.Chemo.COM.CallMethod).GetBLChemoAuth("398")
ClassMethod GetBLChemoAuth(UserID As %String)
{
	S mRtn="N"
	s docid=##class(DHCAnt.KSS.Common.Method).TransSSUserToCTCare(UserID)
	q:docid="" mRtn
	s mRtn=$p(^CTPCP(docid,3),"^",34) 
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2021-03-19
/// DESC: 获取化疗方案权限
/// IN  : 
/// OUT : Y/N
/// EXEC: w ##class(DHCDoc.Chemo.COM.CallMethod).GetChemoAuth("12213")
ClassMethod GetChemoAuth(UserID As %String)
{
	S mRtn="N"
	s docid=##class(DHCAnt.KSS.Common.Method).TransSSUserToCTCare(UserID)
	q:docid="" mRtn
	s mRtn=$p(^CTPCP(docid,3),"^",35) 
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-06-25
/// DESC: 获取接受科室
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.COM.CallMethod).GetDefaultRecLoc(4,"176||1")
ClassMethod GetDefaultRecLoc(EpisodeID As %String, InArcim As %String)
{
	s RecLocStr=##class(web.DHCDocOrderCommon).GetRecloc(EpisodeID, InArcim)
	s DefaultRecLoc=$$GetDefalocID(RecLocStr)
	q DefaultRecLoc

GetDefalocID(RecLocStr)
	s DeLocID=""
	s RecLocCount=$L(RecLocStr,$C(2))
	F iLoc=1:1:RecLocCount {
		S LoopRecLocStr=$P(RecLocStr,$C(2),iLoc)
		s ReclocRowId=$P(LoopRecLocStr,$C(1),1)
		if iLoc=1 s DeLocID=ReclocRowId
		s Defaut=$P(LoopRecLocStr,$C(1),3)
		if (Defaut="Y") s DeLocID=ReclocRowId
		
	}
	Q DeLocID
}

/// CTOR: QP
/// DATE: 2020-06-25
/// DESC: 判断库存是否充足
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.COM.CallMethod).CheckStockEnough("161||1","","68","1256","1256^102^0")
ClassMethod CheckStockEnough(arcim, Qty, RecLoc, EpisodeID = "", ExpStr = "", Remark = "")
{
	Q:Remark="OM" "1^"
	s EpisodeType=$p(^PAADM(EpisodeID),"^",2)
	s RecLoc=..GetDefaultRecLoc(EpisodeID,arcim)
	s mRtn=##class(web.DHCDocOrderCommon).CheckStockEnough(arcim, Qty, RecLoc , EpisodeType, ExpStr)
	//s ^QP("temp")=$lb(arcim, Qty, RecLoc, EpisodeID, ExpStr,EpisodeType,mRtn)
	q mRtn
}

/// CTOR: QP
/// DATE: 2020-06-25
/// DESC: 获取药品厂家
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.COM.CallMethod).GetManuFactor("288||1")
ClassMethod GetManuFactor(arcim As %String)
{
	s mRtn=""
	Q mRtn
	s PHCDF=..GetPhcdf(arcim)
	s Manf=##class(web.DHCST.Common.DrugInfoCommon).GetManfByPhcd(+PHCDF)
	s mRtn=$p(Manf,"^",3)
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-06-25
/// DESC: phcdf
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.COM.CallMethod).GetPhcdf("288||1")
ClassMethod GetPhcdf(arcim As %String)
{
	q:arcim="" ""
	s phcdf=$p($g(^ARCIM(+arcim,1,1)),"^",12)
	q phcdf
}

/// CTOR: QP
/// DATE: 2020-07-03
/// DESC: 获取诊断
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.COM.CallMethod).GetAllDiagnosis("122")
ClassMethod GetAllDiagnosis(admid As %String)
{
	s mradm=$P(^PAADM(admid),"^",61)
	s mRtn=##class(web.DHCMRDiagnos).GetMRDiagnosDesc(mradm,",")
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-07-13
/// DESC: 获取主治医生
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.COM.CallMethod).GetAdmDoc("23")
ClassMethod GetAdmDoc(admid As %String)
{
	s mRtn=""
	s langid=..%LanguageID()
	Q:admid="" mRtn
	s docid=$p(^PAADM(admid),"^",9)
	i +docid>0 {
		s mRtn=$p(^CTPCP(docid,1),"^",2)
		s mRtn= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",mRtn,langid)
	}
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-10-20
/// DESC: 判断库存是否充足
/// IN  : 
/// OUT : 0不足
/// EXEC: w ##class(DHCDoc.Chemo.COM.CallMethod).GetAdmDoc("23")
ClassMethod CheckStockEnoughOld(arcim As %String, Qty As %String, RecLoc As %String, EpisodeType As %String = "", ExpStr As %String = "")
{
	s mRtn=""
	s mRtn=##class(web.DHCDocOrderCommon).CheckStockEnough("1894||1",1,36,"","88^15^0")
	
	Q mRtn
}

/// Others: w ##class(DHCDoc.Chemo.COM.CallMethod).QueryAllergyInfoStr("1")
ClassMethod QueryAllergyInfoStr(PatientID)
{
    Q:PatientID="" ""
    s langid=..%LanguageID()
    s InfoStr=""
	s objpat=##class(User.PAPatMas).%OpenId(PatientID)
	i $ISOBject(objpat) d
	.s h=objpat.ChildPAAllergy.Count()
	.//b ;w h
	.F i=1:1:h d
	..s (RowID,Category,Allergen,NatureOfReaction,Severity,SeverityColour,OnsetDate,OnsetDateFreeText,CareProvider,InActive,OnsetDateText,RowHexColour,LastUpdateDate,LastUpdateTime,LastUpdateUser,LastUpdateHospital,Status,ExternalID,LastUpdateUserRole,LastUpdateUserId,Comments,ALGFreeTextAllergy,DrugSpecific,tag,ALGDSReportFlag,HiddenFields,ALGItem)=""
	..s objAllergy=objpat.ChildPAAllergy.GetAt(i)
	..s RowID=objAllergy.%Id()
	..;自定义过敏分类
	..if objAllergy.ALGTypeDRGetObjectId()'="" d
	...s Allergen=objAllergy.ALGTypeDR.ALGDesc
	...s Allergen= ##class(User.PACAllergy).GetTranByDesc("ALGDesc",Allergen,langid)
	..;分类
	..s Status=objAllergy.ALGStatus
	..q:Status'="A"
	..s Category=objAllergy.ALGMRCAllTypeDR.MRCATDesc
	..s InfoStr = InfoStr_" "_Allergen
	Q InfoStr
}

/// ========================================================================================
/// =========================================第三方接口=====================================
/// ========================================================================================
/// Function:根据医嘱项id   出参返回厂家和  接受科室 ，并返回接受科室的库存信息
/// 如果空 返回空。如果多条 就返回多条
/// Function:根据医嘱项id取厂家和库存信息和接收科室名称
/// date:2020-06-29
/// create:ShangXuehao
/// w ##class(web.test.TestShang).FindDurgInfoByArc("1000||1,1001||1")
ClassMethod FindDurgInfoByArc(ArcIMId As %String, split = ",") As %String
{
	s (i,j,ArcIMIdi,PHCDF,Manf,BUomId,AvaQty,num,UomDesc,LocDesc)=""
	q:ArcIMId="" ""
	s DurgLists=##class(%ListOfDataTypes).%New()
	s ArcIMLen=$l(ArcIMId,split)
	f i=1:1:ArcIMLen  d
	.s ArcIMIdi=$P($G(ArcIMId),split,i)
	.s INCIRowId="" f  s INCIRowId=$o(^INCI(0,"ARCIM_DR",$p(ArcIMIdi,"||",1),INCIRowId)) q:INCIRowId=""  d
	..s PHCDF=##class(web.DHCST.Common.DrugInfoCommon).GetPhcdf(INCIRowId)
	..s Manf=##class(web.DHCST.Common.DrugInfoCommon).GetManfByPhcd(+PHCDF)
	..s Manf=$p(Manf,"^",3)
	..s Sub="" f  s Sub=$o(^INCI(INCIRowId,"IL",Sub)) q:Sub=""  d
	...s Incil=INCIRowId_"||"_Sub
	...s PhaLoc=$p($g(^INCI(INCIRowId,"IL",Sub)),"^",1)
	...s LocDesc=$p($g(^CTLOC(PhaLoc)),"^",2)
	...s BUomId=$p(^INCI(INCIRowId,1),"^",10)
	...s AvaQty=##class(web.DHCST.Common.DrugStkCommon).CurItmAvaQtyB(Incil,BUomId)
	...i BUomId'="" s UomDesc=$p($g(^CT("UOM",BUomId)),"^",2)
	...s num =AvaQty_""_UomDesc
	...s DurgList=##class(%ArrayOfDataTypes).%New()
	...d DurgList.SetAt(LocDesc,"LocDesc")
	...d DurgList.SetAt(Manf,"Manf")
	...d DurgList.SetAt(num,"num")
	...d DurgLists.Insert(DurgList)
	;q ##class(Nur.JSON).Encode(DurgLists)
	q DurgLists
}

/// Function:根据医嘱项id和接收科室id取厂家和库存信息
/// date:2020-06-28
/// create:ShangXuehao
/// w ##class(DHCDoc.Chemo.COM.CallMethod).FindDurgByArc("288||1","100")
ClassMethod FindDurgByArc(ArcIMId As %String, PhaLoc As %String) As %String
{
	q:ArcIMId=""
	s (PHCDF,Manf,BUomId,AvaQty,num,UomDesc)=""
	s INCIRowId="" f  s INCIRowId=$o(^INCI(0,"ARCIM_DR",$p(ArcIMId,"||",1),INCIRowId)) q:INCIRowId=""  d
	.s PHCDF=##class(web.DHCST.Common.DrugInfoCommon).GetPhcdf(INCIRowId)
	.q:+PHCDF=0
	.s Manf=##class(web.DHCST.Common.DrugInfoCommon).GetManfByPhcd(+PHCDF)
	.s Manf=$p(Manf,"^",3)
	.q:PhaLoc=""
	.i INCIRowId'="" s Chl=$o(^INCI("IL_LOC",PhaLoc,INCIRowId,0))
	.s Incil=INCIRowId_"||"_Chl
	.s BUomId=$p(^INCI(INCIRowId,1),"^",10)
	.s AvaQty=##class(web.DHCST.Common.DrugStkCommon).CurItmAvaQtyB(Incil,BUomId)
	.i BUomId'="" s UomDesc=$p($g(^CT("UOM",BUomId)),"^",2)
	.s num =AvaQty_""_UomDesc
	q Manf_"^"_num
}

/**
接口说明：

w ##Class(web.DHCEMInterfaceCom).OrsIsAllExec("98||2")
--这个我刚测试了一条临时医嘱TID类型   OK 。  护士站提供接口判断化疗主药是否被执行完成；
如果医嘱是TID,则需要判断3条执行记录都为Y ，最终医嘱执行情况才能返回Y 。
若3条执行记录其中有一条执行记录为N ，则医嘱执行状态为N .


**/
/// w ##Class(web.DHCOEOrdItemView).CalPackQty(^tan("web.DHCOEOrdItemView","CalPackQty"))
ClassMethod CalPackQty(OrdParamJson As %String) As %String
{
	//s ^tan("web.DHCOEOrdItemView","CalPackQty")=OrdParamJson
	k CalPackArr
	s CallBackFunStr=""
	s ^QP("DDD",11,1)=OrdParamJson
	k OrdParamArr
	d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(OrdParamJson,.OrdParamArr)
	
	s EpisodeID=OrdParamArr("EpisodeID")
	s OrderPriorRowid=OrdParamArr("OrderPriorRowid")
	s OrderARCIMRowid=OrdParamArr("OrderARCIMRowid")
	s OrderDoseQty = OrdParamArr("OrderDoseQty")
    s OrderDoseUOMRowid = OrdParamArr("OrderDoseUOMRowid")
	s OrderFreqRowid=OrdParamArr("OrderFreqRowid")
	s OrderDurRowid = OrdParamArr("OrderDurRowid")
	s OldOrderPackQty = OrdParamArr("OrderPackQty")
	s OrderPackUOMRowid=OrdParamArr("OrderPackUOMRowid")
	s OrderStartDateStr=OrdParamArr("OrderStartDate")
	s OrderMultiDate=OrdParamArr("OrderMultiDate")
	s OrderPrice=OrdParamArr("OrderPrice")
	s LinkedMasterOrderPriorRowid=OrdParamArr("LinkedMasterOrderPriorRowid")
	s OrderFreqDispTimeStr=OrdParamArr("OrderFreqDispTimeStr")
	s OrderFirstDayTimes=OrdParamArr("OrderFirstDayTimes")
	s IsNotChangeFirstDayTimeFlag=OrdParamArr("IsNotChangeFirstDayTimeFlag")
	s IsNotNeedChangeFlag=OrdParamArr("IsNotNeedChangeFlag")
	s OrderFreqTimeDoseStr=OrdParamArr("OrderFreqTimeDoseStr")
	s OrderMasterARCIMRowid=$G(OrdParamArr("OrderMasterARCIMRowid"))
	s OrderRecDepRowid=OrdParamArr("OrderRecDepRowid")
	s OrderVirtualtLong=$G(OrdParamArr("OrderVirtualtLong"))
	s SessionStr=OrdParamArr("SessionStr")
	s CTLOCID=$P(SessionStr,"^",3)
	s HOSPID=$P(SessionStr,"^",4)
	s OrderName=$P(^ARCIM(+OrderARCIMRowid,$P(OrderARCIMRowid,"||",2),1),"^",2)
	s PAAdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
	s DrgformRowid=##class(web.DHCDocOrderEntry).GetDrgForm(OrderARCIMRowid)
	s DateFormat=##Class(websys.Conversions).DateFormat()
	s INCIRowid=##class(web.DHCDocOrderEntry).GetINCI(+OrderARCIMRowid)
	s ConFac=1
	if (INCIRowid'=""){
		s ConFac=##class(web.DHCDocOrderEntry).GetConFac(OrderARCIMRowid,INCIRowid,OrderPackUOMRowid)
	}
	if (OrderStartDateStr = "") {
        s CurrDateTime = ##Class(web.DHCDocOrderCommon).GetCurrentDateTime(DateFormat, "1")
        s OrderStartDate = $P(CurrDateTime,"^",1)
        s OrderStartTime=$P(CurrDateTime,"^",2)
    }else{
		s OrderStartDate=$P(OrderStartDateStr," ",1)
		s OrderStartTime=$P(OrderStartDateStr," ",2)
	}
	s OrderPriorCode=$P(^OECPR(OrderPriorRowid),"^",1)
	s isLongPrior=##class(appcom.OEOrdItem).ISLongOrderPrior(OrderPriorRowid)
	
	s OrderItemCatDr=$P(^ARCIM(+OrderARCIMRowid,$P(OrderARCIMRowid,"||",2),1),"^",10) 
	s:OrderItemCatDr'="" OrderType=$P(^ARC("IC",OrderItemCatDr),"^",7)
	s OrderPHPrescType=##Class(web.DHCDocOrderCommon).GetPHPrescType(OrderItemCatDr,HOSPID)
	
	//计算首日执行次数
	/*
	tanjishan pb,外层已经重新计算了首日次数，这里没必要再从新算一遍
	目前没有发现从新算一遍有什么问题，先屏蔽
	s CalPackArr("OrderFirstDayTimes")=OrderFirstDayTimes
	if (IsNotChangeFirstDayTimeFlag'="Y"){
		s OrderFirstDayTimes=..GetOrderFirstDayTimes(EpisodeID, OrderARCIMRowid, OrderFreqRowid, OrderPriorRowid, OrderStartDateStr, LinkedMasterOrderPriorRowid,OrderFreqDispTimeStr)
		s CalPackArr("OrderFirstDayTimes")=OrderFirstDayTimes
	}
	s OrderFirstDayTimes=+CalPackArr("OrderFirstDayTimes")
	*/
	s ItemCatRowid=$p($g(^ARCIM(+OrderARCIMRowid,$p(OrderARCIMRowid,"||",2),1)),"^",10)
	s OrderType=$P(^ARC("IC",ItemCatRowid),"^",7)
	s WeekFlag="N"
	s (OrderFreqFactor,OrderFreqInterval)=1
	if (OrderFreqRowid'=""){
		s OrderFreqFactor=$P($g(^PHCFR(OrderFreqRowid)),"^",2)
		i (+OrderFreqFactor=0) s OrderFreqFactor=1
		s OrderFreqInterval=$P($g(^PHCFR(OrderFreqRowid)),"^",5)
		i (+OrderFreqInterval=0) s OrderFreqInterval=1
		s WeekFlag=$P($g(^PHCFR(OrderFreqRowid)),"^",9)
	}
	s (OrderDurFactor)=1
	if (OrderDurRowid'=""){
		s OrderDurFactor=$P($g(^PHCDU(OrderDurRowid)),"^",2)
		i (+OrderDurFactor=0) s OrderDurFactor=1
	}
	//s FreqDispTimeStr=##Class(web.DHCDocOrderCommon).GetFreqDispTimeStr(OrderFreqRowid)
	///计算使用次数和整包装数;整包装数=（使用次数*每次用量）向上取整
	if ((OrderFreqInterval '= "") && (+OrderFreqInterval >0)&&(OrderFreqDispTimeStr="")) {
        s convert = OrderDurFactor \ OrderFreqInterval
        s fact = OrderDurFactor#OrderFreqInterval
        if (fact > 0) { s fact = 1 } else { s fact = 0 }
        s OrderDurFactor = convert + fact
    }
	if (OrderType="R"){
		s PackQty = 1
        s BaseDoseQty = 1
        s BaseDoseQtySum=0
        //if (OrderDoseQty'=""){
	        /*s BaseDoseQty = ##Class(web.DHCDocOrderEntry).CalDose(OrderDoseUOMRowid, DrgformRowid, OrderDoseQty)
	    	if (BaseDoseQty = "") s BaseDoseQty = 1*/
	    	k OrderFreqTimeDoseArr
	    	if (OrderFreqTimeDoseStr'=""){
	            s BaseDoseQty=0
		        s Len=$l(OrderFreqTimeDoseStr,"!")
		        for i=1:1:Len{
			        s OneFreqDispTimeDose=$p(OrderFreqTimeDoseStr,"!",i)
			        s OneDoseQty=$p(OneFreqDispTimeDose,"$",2)
			        s OneBaseDoseQty = +##Class(web.DHCDocOrderEntry).CalDose(OrderDoseUOMRowid, DrgformRowid, OneDoseQty)
			        s BaseDoseQty=BaseDoseQty+OneBaseDoseQty
			        s OrderFreqTimeDoseArr(i)=OneBaseDoseQty
			    }
		    }else{
			    s BaseDoseQty = ##Class(web.DHCDocOrderEntry).CalDose(OrderDoseUOMRowid, DrgformRowid, OrderDoseQty)
			}
	    	if (BaseDoseQty = "") s BaseDoseQty = 1
	    	if ($d(OrderFreqTimeDoseArr)) {
	            if (OrderFirstDayTimes>0) {
	                s:OrderDurFactor>=1 BaseDoseQtySum=BaseDoseQty*(OrderDurFactor-1)
	                for i=1:1:OrderFirstDayTimes {
		                s index=$o(OrderFreqTimeDoseArr(""),-1)-OrderFirstDayTimes+i
		                s BaseDoseQtySum=BaseDoseQtySum+$g(OrderFreqTimeDoseArr(index))
		            }
	            }else{
		            s BaseDoseQtySum=BaseDoseQty
		        }
            }
            s NumTimes = 1
            if ((PAAdmType'= "I") || ((PAAdmType= "I") && ((OrderPriorCode="OUT")||(OrderPriorCode="ONE")))) {
                if (OrderFreqDispTimeStr '= "") { //周频次
                    s NumTimes = ##Class(web.DHCOEOrdItemView).GetCountByFreqDispTime(OrderFreqDispTimeStr, OrderStartDate, OrderDurFactor,OrderFirstDayTimes)
                } else {
					if (OrderFirstDayTimes>0){
						s NumTimes=OrderFreqFactor * (OrderDurFactor-1)+OrderFirstDayTimes
					}else{
						s NumTimes=OrderFreqFactor * OrderDurFactor
					}
				}
            } else {
                if (OrderFirstDayTimes>0){
					s NumTimes=OrderFreqFactor * (OrderDurFactor-1)+OrderFirstDayTimes
				}else{
					s NumTimes=OrderFreqFactor * OrderDurFactor
				}
            }
            if (BaseDoseQtySum=0) {
            	s BaseDoseQtySum = BaseDoseQty * NumTimes
            }
            if (OrderFreqTimeDoseStr'=""){
	            s CalPackArr("Qty") = BaseDoseQtySum
	            //pb by tanjishan 20200225
            	//s PackQty = BaseDoseQtySum / ConFac / OrderFreqFactor
            	s PackQty = BaseDoseQtySum / ConFac
            }else{
	            s PackQty = BaseDoseQtySum / ConFac
	        }
            s PackQty = $FN(PackQty,"",4)
            s convert = PackQty \ 1
            s fact = PackQty#1
            if (fact > 0) { s fact = 1 } else { s fact = 0 }
            s PackQty = convert+fact
	    //}
	}else{
		s NumTimes=""
		s PackQty=OldOrderPackQty
        if (PackQty = "") s PackQty = 1
        s BaseDoseQtySum = PackQty
        if (OrderDoseQty = "") s OrderDoseQty = 1
        if (WeekFlag'="Y"){
	        /*if ((OrderFreqInterval '= "") && (+OrderFreqInterval >0)) {
	            s convert = OrderDurFactor \ OrderFreqInterval
	            s fact = OrderDurFactor#OrderFreqInterval
	            if (fact > 0) { s fact = 1 } else { s fact = 0 }
	            s OrderDurFactor = convert + fact
	        }*/
        }
        if (PAAdmType = "I") {
            //如果是住院有隔几日的频次,就要把数量置为1
            if (OrderFreqDispTimeStr '= "") s OrderFreqFactor = 1
        }else{
            if (OrderFreqDispTimeStr '= "") {
                 s NumTimes = ##Class(web.DHCOEOrdItemView).GetCountByFreqDispTime(OrderFreqDispTimeStr, OrderStartDate, OrderDurFactor,OrderFirstDayTimes)
            }
        }
        if (NumTimes=""){
            if (OrderFirstDayTimes>0){
				s PackQty=(OrderFreqFactor*(OrderDurFactor-1)+OrderFirstDayTimes)*OrderDoseQty
			}else{
				s PackQty=OrderFreqFactor*OrderDurFactor*OrderDoseQty
			}
        }else{
            s PackQty=NumTimes * OrderDoseQty
        }
        s BaseDoseQtySum=PackQty
		s BaseDoseQty=""
	}
	s OrderPackQtyStr=##Class(web.DHCOEOrdItemView).ContrlOrderPackQty(EpisodeID, OrderPriorRowid, CTLOCID, OrderARCIMRowid, OrderMasterARCIMRowid, OrderRecDepRowid,OrderVirtualtLong)
	s SetOrderPackQtyValue=$P(OrderPackQtyStr,"^",3)
    if (SetOrderPackQtyValue=""){
		s PackQty=""
	}
	;取药和出院带药默认按整包装开
 	s CFOutAndOneDefaultPackQty=##Class(web.DHCDocConfig).GetConfigNode("OutAndOneDefaultPackQty",HOSPID)
	if (PAAdmType = "I") {
        if (((OrderPriorCode="OUT") || (OrderPriorCode="ONE")) && (CFOutAndOneDefaultPackQty=1)) {
			if ((OldOrderPackQty'="")&&(OrderPriorCode="OUT")){
			}else{
				s OrderSum = OrderPrice * PackQty
				s NeedChange=1
				if (IsNotNeedChangeFlag= "Y"){
					s NeedChange=0
					if (OldOrderPackQty<PackQty)&&(OldOrderPackQty'=""){
						//s NeedChange=1
						//放到前台去做赋值操作
						s CallBackFunParams=OrderName_" 当前医嘱用量"_OldOrderPackQty_"小于实际计算用量"_PackQty_",是否自动修正？"
		    			s CallBackFunParams=CallBackFunParams_";"_PackQty_";"_OrderSum
		    			s CallBackFunStr=##Class(web.DHCOEOrdItemView).GetCallBackFunStr(CallBackFunStr,"ReSetPackQty1",CallBackFunParams)
					}
				}
				if (NeedChange=1){
					s CalPackArr("OrderPackQty")=PackQty
					s CalPackArr("OrderSum")=OrderSum
				}
			}
        } elseif (((OldOrderPackQty'=""))||(OrderPriorCode="OM")||(OrderPriorCode="OMST")) { //&&(OrderType="R")
            //如果已经有整包装或者是自备药医嘱则不用去计算金额
            s CureItemFlag = ##Class(DHCDoc.DHCDocCure.Apply).CheckItem(OrderARCIMRowid, OrderRecDepRowid)
            ;住院临时也允许录入单次剂量，所以这里需要计算数量
            if (CureItemFlag=1)&&(OrderPriorCode="NORM"){
	            s OrderSum = OrderPrice * PackQty
	            s CalPackArr("OrderPackQty")=PackQty
				s CalPackArr("OrderBaseQty")=BaseDoseQty
				s CalPackArr("OrderBaseQtySum")=BaseDoseQtySum
				s CalPackArr("OrderSum")=OrderSum
	        }
        } else {
			if ($G(BaseDoseQtySum)="") s BaseDoseQtySum=1
            s OrderSum = (OrderPrice/ConFac) * BaseDoseQtySum
            s OrderSum = $FN(OrderSum,"",4)
            s CalPackArr("OrderBaseQty")=BaseDoseQty
            s CalPackArr("OrderBaseQtySum")=BaseDoseQtySum
            //非药品长期医嘱且非长嘱才改变数量
            if (OrderType '= "R"){
	        	s CalPackArr("OrderPackQty")=PackQty
	        }
	        s CalPackArr("OrderSum")=OrderSum
        }
    } else {
        if (PackQty <= 0)&&(SetOrderPackQtyValue'="") { s PackQty = 1 }
        s OrderSum = OrderPrice * PackQty
        s OrderSum = $FN(OrderSum,"",4)
        s NeedChange=1
		if (IsNotNeedChangeFlag = "Y"){
			s NeedChange=0
			if (OldOrderPackQty<PackQty)&&(OldOrderPackQty'=""){
				//s NeedChange=1
				//
				s CallBackFunParams=OrderName_" 当前医嘱用量"_OldOrderPackQty_"小于实际计算用量"_PackQty_",是否自动修正？"
				s CallBackFunParams=CallBackFunParams_";"_PackQty_";"_OrderSum_";"_BaseDoseQty_";"_BaseDoseQtySum
				s CallBackFunStr=##Class(web.DHCOEOrdItemView).GetCallBackFunStr(CallBackFunStr,"ReSetPackQty2",CallBackFunParams)
			}
		}
		if (NeedChange=1){
			s CalPackArr("OrderPackQty")=PackQty
			s CalPackArr("OrderBaseQty")=BaseDoseQty
			s CalPackArr("OrderBaseQtySum")=BaseDoseQtySum
			s CalPackArr("OrderSum")=OrderSum
		}
    }
    s CalPackArr("CallBackFunStr")=CallBackFunStr
    //s CalPackJson=##Class(DHCDoc.Util.FromJSON).GetArrJson(.CalPackArr)
    
    S mRtn=$g(CalPackArr("OrderPackQty"))
    q mRtn
}

/// CTOR: QP
/// DATE: 2021-12-24
/// DESC: 获取标本描述
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.COM.CallMethod).GetSampleDesc("SP004",2)
ClassMethod GetSampleDesc(SampleID, InHosp)
{
	S SampleDesc=""
	Q:(SampleID="") SampleDesc
	
	i $d(^DHCLISBSVersion(1)) {
		s HospitalCode=InHosp
		s HospitalDR=$o(^dbo.BTHospitalI("IndexCode",##Class(LIS.Util.Common).IndexData(HospitalCode),""))
		i '$l(HospitalDR) s HospitalDR = $o(^dbo.BTHospitalD(""))
		i $l(HospitalDR) d
		.s SpecimenDR=$o(^dbo.BTSpecimenI("IndexCode",HospitalDR,##Class(LIS.Util.Common).IndexData(SampleID),""))
		.s:SpecimenDR'="" SampleDesc=$lg($g(^dbo.BTSpecimenD(SpecimenDR)),3)
		
	} else {
		s:SampleID'="" SampleDesc=$p($G(^TTAB("SPEC",SampleID)),"\",1)
		s:SampleID="" SampleDesc=""
	}
	
	Q SampleDesc
}

}
