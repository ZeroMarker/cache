/// 名称:     web.DHCOEOrdItemCMView
/// 描述:     中草药录入界面视图交互及控制
/// 编写者:  scl
/// 编写日期: 2019.09.16
Class web.DHCOEOrdItemCMView Extends DHCDoc.Util.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// creator:	宋春莉
/// date:		2019-09-17
/// desc:		批量获取医嘱录入新增行对象的默认值
/// input:		OrdCongeriesJson:需要添加的医嘱项及附加信息（医嘱套或复制医嘱）的集合
/// 			BaseParamJson:基本参数键值对
/// 			ItemOrdsJson:已新增到行上的医嘱
/// 			RowDataJson:行默认数据
/// 
/// output:		JSON:
/// {
/// 	ErrCode:非0-停止新增,
/// 	ErrMsg:错误描述,
/// 	CallBakFunS:[{
/// 		CallBakFunCode:回调代码
/// 		CallBakFunParams:回调方法参数
/// 	},...,...}],
/// 	ParamData:[{
/// 		OrderType:"",
/// 		....
/// 	}]
/// }
/// w ##Class(web.DHCOEOrdItemCMView).GetItemCongeriesToList($list(^tempscl("GetItemCongeriesToList"),1),$list(^tempscl("GetItemCongeriesToList"),2),$list(^tempscl("GetItemCongeriesToList"),3),$list(^tempscl("GetItemCongeriesToList"),4))
ClassMethod GetItemCongeriesToList(OrdCongeriesJson As %String, BaseParamJson As %String, ItemOrdsJson As %String, UserOptionsJson As %String) As %String [ ProcedureBlock = 0 ]
{
	;s ^tan("GetItemCongeriesToList")="##class(web.DHCOEOrdItemView).GetItemCongeriesToList("""_$REPLACE(OrdCongeriesJson,"""","""""")_""","""_$REPLACE(BaseParamJson,"""","""""")_""","""_$REPLACE(ItemOrdsJson,"""","""""")_""","""_$REPLACE(RowDataJson,"""","""""")_""","""_$REPLACE(UserOptionsJson,"""","""""")_""")"
	//初始化需要添加到行上的医嘱明细信息
	s ^tempscl("GetItemCongeriesToList")=$lb(OrdCongeriesJson,BaseParamJson,ItemOrdsJson,UserOptionsJson)
	k OrdCongeriesArr
	d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(OrdCongeriesJson,.OrdCongeriesArr)
	k BaseParamArr
	d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(BaseParamJson,.BaseParamArr)
	k ItemOrdsArr
	d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(ItemOrdsJson,.ItemOrdsArr)
	k UserOptionsJsonArr
	d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(UserOptionsJson,.UserOptionsJsonArr)
	k UserOptionsArr
	d SetUserOptionsArr(.UserOptionsJsonArr,.UserOptionsArr)
	s EpisodeID=BaseParamArr("Adm")
	s SessionStr=BaseParamArr("SessionStr")
	s AddNo=0
	///需要增加到行上的医嘱列表
	k ItemCongeriesArr
	s OrdCounter=""
	for {
		s OrdCounter=$O(OrdCongeriesArr(OrdCounter))
		q:(OrdCounter="")
		s OrderARCIMRowid=OrdCongeriesArr(OrdCounter,"OrderARCIMRowid")
		s ParamS=$G(OrdCongeriesArr(OrdCounter,"ParamS"))
		s ITMRowId=$G(OrdCongeriesArr(OrdCounter,"ITMRowId"))	;医嘱套明细ID
		s OrderPhSpecInstr=$G(OrdCongeriesArr(OrdCounter,"OrderPhSpecInstr"))
		//初始化前台传入的医嘱明细
		k ARCOSArr
		d ..InitARCOSArr(.ARCOSArr,ParamS,EpisodeID,SessionStr,OrderARCIMRowid)
		//初始化医嘱特殊信息
		k SubBaseParamArr
		m SubBaseParamArr=BaseParamArr
		s SubBaseParamArr("OrderARCIMRowid")=OrderARCIMRowid
		s SubBaseParamArr("ITMRowId")=ITMRowId
		s SubBaseParamArr("OrderPhSpecInstr")=OrderPhSpecInstr
		k UserOptionArr
		m UserOptionArr=UserOptionsArr(SubBaseParamArr("rowid"))
		d ##Class(web.DHCOEOrdItemCMView).GetItemToList(
			.SubBaseParamArr, .ItemOrdsArr, .ARCOSArr,
			.OneItemInfoArr,.UserOptionArr,.ItemCongeriesArr)
		
		///将新增的行信息添加到ItemOrdsArr数组中，用于后续添加行的逻辑判断
		s Index=$I(ItemCongeriesArr)
		m ItemCongeriesArr(Index)=OneItemInfoArr
		//d AddItemToRowArr(.AddNo,.ItemOrdsArr,.OneItemInfoArr,.BaseParamArr)
	}
	s ItemCongeriesJson=##Class(DHCDoc.Util.FromJSON).GetArrJson(.ItemCongeriesArr)
	q ItemCongeriesJson
	///将新获取的行数据添加到行数组记录里面
AddItemToRowArr(AddNo,ItemOrdsArr,OneItemInfoArr,BaseParamArr)
	n (AddNo,ItemOrdsArr,OneItemInfoArr,BaseParamArr)
	q:+$G(OneItemInfoArr("ErrCode"))<0
	s AddNo=AddNo+1
	s i=1+$O(ItemOrdsArr("ItemOrds",""),-1)
	m ItemOrdsArr("ItemOrds",i)=OneItemInfoArr("OrdListInfo")
	s ItemOrdsArr("ItemOrds",i,"OrderItemRowid")=""
	s ItemOrdsArr("ItemOrds",i,"OrderARCIMRowid")=ItemOrdsArr("ItemOrds",i,"OrderARCIMRowid")
	//后台不计算关联，这部分数据不用保证正确   --
	s ItemOrdsArr("ItemOrds",i,"rowid")=BaseParamArr("rowid")+AddNo
	s ItemOrdsArr("ItemOrds",i,"OrderSeqNo")=1+$G(ItemOrdsArr("ItemOrds",i-1,"OrderSeqNo"))
	s ItemOrdsArr("ItemOrds",i,"OrderMasterSeqNo")=""
	q
SetUserOptionsArr(UserOptionsJsonArr,UserOptionsArr)
	n (UserOptionsJsonArr,UserOptionsArr)
	s i=""
	for {
		s i=$o(UserOptionsJsonArr(i))
		q:(i="")
		s rowid=$G(UserOptionsJsonArr(i,"rowid"))
		continue:(rowid="")
		s j=""
		for {
			s j=$o(UserOptionsJsonArr(i,"UserOption",j))
			q:(j="")
			s Type=$G(UserOptionsJsonArr(i,"UserOption",j,"Type"))
			continue:(Type="")
			s Index=$o(UserOptionsArr(rowid,Type,""),-1)+1
			m UserOptionsArr(rowid,Type,Index)=UserOptionsJsonArr(i,"UserOption",j)
		}
	}
	q
}

/// creator:	scl
/// date:		2019-09-17
/// desc:		获取医嘱录入新增行单个对象的默认值
/// input:		BaseParamArr:基本参数键值对 Json结构
/// 			ItemOrdsArr:已新增到行上的医嘱
/// 			ArcosArr:复制或医嘱套带出的医嘱默认信息
/// 			RowDataArr:行默认数据
/// 			UserOptionArr:用户选项信息，一般用于confirm前台的递归调用后台方法，一定要处理,否则会导致死循环
/// 
/// output:		JSON:
/// {
/// 	ErrCode:非0-停止新增,
/// 	ErrMsg:错误描述,
/// 	CallBakFunS:[{
/// 		CallBakFunCode:回调代码
/// 		CallBakFunParams:回调方法参数
/// 	},...,...}],
/// 	ParamData:{
/// 		OrderType:"",
/// 		....
/// 	}
/// }
/// w ##Class(web.DHCOEOrdItemView).GetItemToList("")
ClassMethod GetItemToList(ByRef BaseParamArr, ByRef ItemOrdsArr, ByRef ArcosArr, ByRef ItemRowDataArr, ByRef UserOptionArr, ByRef ItemCongeriesArr) As %String [ ProcedureBlock = 0 ]
{
	n (BaseParamArr,ItemOrdsArr,ArcosArr,ItemRowDataArr,UserOptionArr,ItemCongeriesArr,%session)
	s CallBackFunStr=""
	s OutInfo="0^^^^"
	s Adm=$G(BaseParamArr("Adm"))
	s OrderBillTypeRowid=$G(BaseParamArr("OrderBillTypeRowid"))
	s LogonDep=$G(BaseParamArr("LogonDep"))
	s OrderARCIMRowid=$G(BaseParamArr("OrderARCIMRowid"))
	s OrderOpenForAllHosp=$G(BaseParamArr("OrderOpenForAllHosp"))
	s SessionStr=$G(BaseParamArr("SessionStr"))
	s RelocRowID=$G(BaseParamArr("RelocRowID"))
	s ITMRowId=$G(BaseParamArr("ITMRowId"))
	s PAAdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(Adm)
	s ItemDefaultRowId=""
	s ExpStr = "^^^CNMEDEntry"
	///医嘱项明细信息
	s EPARCIMDetail=##Class(web.DHCDocOrderCommon).GetEPARCIMDetail(
	Adm, OrderBillTypeRowid, LogonDep, OrderARCIMRowid, OrderOpenForAllHosp, 
	SessionStr, ItemDefaultRowId, RelocRowID, ExpStr)
	//--初始化默认数据
	k ParamArr
	d InitParamArr(.ParamArr,.ItemOrdsArr,.BaseParamArr,.ArcosArr,EPARCIMDetail)
	//--录入限制或提示
	s OutInfo=$$BaseValidCheck(.ParamArr,.ItemOrdsArr,.BaseParamArr,.CallBackFunStr)
	q:(+OutInfo)<0 $$GetItemRowDataJsonObj(OutInfo,CallBackFunStr,.ParamArr,.ItemRowDataArr)
	//-- 草药药品重复性判断
	s OutInfo=$$CheckPrescItemAndCount(.ParamArr,.ItemOrdsArr,.BaseParamArr,.ItemCongeriesArr,.CallBackFunStr)
	q:(+OutInfo)<0 $$GetItemRowDataJsonObj(OutInfo,CallBackFunStr,.ParamArr,.ItemRowDataArr)
	//-- 判断子类与所选的处方类型是否相符
	s OutInfo=$$AutoSelectPrescTypeList(.ParamArr,.BaseParamArr,.ItemOrdsArr,.CallBackFunStr)
	q:(+OutInfo)<0 $$GetItemRowDataJsonObj(OutInfo,CallBackFunStr,.ParamArr,.ItemRowDataArr)
	//--互斥医嘱提示
	s OutInfo=$$CheckConflict(.ParamArr,.ItemOrdsArr,.BaseParamArr,.ItemCongeriesArr,.CallBackFunStr)
	q:(+OutInfo)<0 $$GetItemRowDataJsonObj(OutInfo,CallBackFunStr,.ParamArr,.ItemRowDataArr)
	//--草药组合数
	s OutInfo=$$INSCPackSumInt(.ParamArr,.BaseParamArr,.UserOptionArr,.CallBackFunStr)
	q:(+OutInfo)<0 $$GetItemRowDataJsonObj(OutInfo,CallBackFunStr,.ParamArr,.ItemRowDataArr)
	//--库存判断
	s OutInfo=$$CheckStock(.ParamArr,.BaseParamArr,.CallBackFunStr)
	q:(+OutInfo)<0 $$GetItemRowDataJsonObj(OutInfo,CallBackFunStr,.ParamArr,.ItemRowDataArr)
	//--草药毒麻处方
	s OutInfo=$$CheckItemPoison(.ParamArr,.BaseParamArr,.CallBackFunStr)
	q:(+OutInfo)<0 $$GetItemRowDataJsonObj(OutInfo,CallBackFunStr,.ParamArr,.ItemRowDataArr)	
    q $$GetItemRowDataJsonObj(OutInfo,CallBackFunStr,.ParamArr,.ItemRowDataArr)
InitParamArr(ParamArr,ItemOrdsArr,BaseParamArr,ArcosArr,EPARCIMDetail)
	n (ParamArr,ItemOrdsArr,BaseParamArr,ArcosArr,EPARCIMDetail,%session)
	s SessionStr=$G(BaseParamArr("SessionStr"))
	s CurLogonHosp=$p(SessionStr,"^",4)
	s ParamArr("OrderARCIMRowid")=$G(BaseParamArr("OrderARCIMRowid"))
	s ParamArr("OrderPhSpecInstr")=$G(BaseParamArr("OrderPhSpecInstr"))
	s ParamArr("PrescDurFactor")=$G(BaseParamArr("PrescDurFactor"))
	s ParamArr("RowIndex")=$G(BaseParamArr("RowIndex"))
	s ParamArr("GroupIndex")=$G(BaseParamArr("GroupIndex"))
	s ParamArr("OrderName")=$P(EPARCIMDetail,"^",1)
	s ParamArr("OrderType")=$P(EPARCIMDetail,"^",2)
	s ParamArr("OrderItemCatRowid")=$P(EPARCIMDetail,"^",3)
	s ParamArr("ItemRowid")=$P(EPARCIMDetail,"^",4)
	s ParamArr("InciRowid")=$P(EPARCIMDetail,"^",5)
	s ParamArr("OrderPHPrescType")=$P(EPARCIMDetail,"^",6)
	s ParamArr("ireclocstr")=$P(EPARCIMDetail,"^",10)
	s ParamArr("idoseqtystr")=$P(EPARCIMDetail,"^",12)
	s ParamArr("realstockqty")=$P(EPARCIMDetail,"^",18)
	s ParamArr("ilimitstr")=$P(EPARCIMDetail,"^",22)
	//iretPrice医嘱价格
	s iretPrice = $P(EPARCIMDetail,"^",8)
	s ParamArr("OrderPrice")=$P(iretPrice,$C(1),1)
	s ParamArr("DiscPrice")=$P(iretPrice,$C(1),2)
	s ParamArr("InsPrice")=$P(iretPrice,$C(1),3)
	s ParamArr("PatPrice")=$P(iretPrice,$C(1),4)
	//ipackqtystr医嘱数量
	s DefaultDoseQty=1,DefaultDoseUOMRowid="",DefaultDoseInfo=""
	if (ParamArr("idoseqtystr")'="") {
		s DefaultDoseInfo=$P(ParamArr("idoseqtystr"),$C(2),1)
		s DefaultDoseQty=$P(DefaultDoseInfo,$C(1),1)
		s DefaultDoseUOMRowid=$P(DefaultDoseInfo,$C(1),3)
	}
	s ParamArr("OrderDoseQty")=DefaultDoseQty
	s ParamArr("OrderDoseUOM")=""
    s ParamArr("OrderDoseUOMRowid")=DefaultDoseUOMRowid
    
    
	//iformstr剂型
	s iformstr = $P(EPARCIMDetail,"^",11)
	s ParamArr("OrderPHForm")=$P(iformstr,$C(1),1)
	s ParamArr("OrderDrugFormRowid")=$P(iformstr,$C(1),2)
	s ParamArr("OrderPoisonRowid")=$P(iformstr,$C(1),4)
	s ParamArr("OrderPoisonCode")=$P(iformstr,$C(1),5)
	//iordermsg提示信息
	s iordermsg = $P(EPARCIMDetail, "^", 17)
	s ParamArr("OrderMsg")=$P(iordermsg,$C(1),1)
	s ParamArr("OrderFile1")=$P(iordermsg,$C(1),2)
	s ParamArr("OrderFile2")=$P(iordermsg,$C(1),3)
	s ParamArr("OrderFile3")=$P(iordermsg,$C(1),4)
	//医保勾选
	s iinsurinfo=$P(EPARCIMDetail,"^",21)
	s ParamArr("OrderCoverMainIns")="N"
    //因为医保串里新增了$C(2)的分割符,所以取值要先处理一下
    s iinsurinfo1 = $P(iinsurinfo, $C(2), 1)
    s limitFlag = $P(iinsurinfo1, $C(1), 5)
    s InsurAdmAllowFlag = $P(iinsurinfo1, $C(1), 6)
    s InsurFlag = $P(iinsurinfo1, $C(1), 7)
    
    ;非医保提示适应症.,决定是否所有类型的病人都判断
 	s CFAllConfirmInsurSYMM=..%GetConfig("AllConfirmInsurSYMM",CurLogonHosp)
    if ((InsurFlag '= "0") || (CFAllConfirmInsurSYMM = 1)) {
        s ParamArr("OrderCoverMainIns")="Y"
    } else {
	    s ParamArr("OrderCoverMainIns")="N"
    }
	//ilimitstr医嘱控制相关
	s ilimitstr = $P(EPARCIMDetail, "^", 22)
	s ParamArr("OrderMaxDurFactor")=$P(ilimitstr,$C(1),1)
	s ParamArr("OrderMaxQty")=$P(ilimitstr,$C(1),5)
	s ParamArr("OrderAlertStockQty")=$P(ilimitstr,$C(1),3)
	s ParamArr("OrderMaxDoseQty")=$P(ilimitstr,$C(1),4)
	s ParamArr("OrderMaxDoseQtyPerDay")=$P(ilimitstr,$C(1),6)
	s ParamArr("OrderLimitDays")=$P(ilimitstr,$C(1),7)
	s ParamArr("WarningUseQty")= $P(ilimitstr,$C(1),12)
	//iother分割
	s iother=$P(EPARCIMDetail,"^",27)
	//医嘱项无效验证
	s ParamArr("OrderItemInValid")=$P(iother,$C(1),1)
	s ParamArr("OrderGenericName")=$P(iother,$C(1),2)
	s ParamArr("iSpecCheckCode")=$P(iother,$C(1),3)
	s ParamArr("AlertAuditSpecialItem")=$P(iother,$C(1),4)
	s ParamArr("ArcimCode")=$P(iother,$C(1),5)
	s ParamArr("OrderAuthInValid")=$P(iother,$C(1),6)
	s ASCheckStr = $P(iother, $C(1), 7)
	
	s PHCDoseStr=$P(EPARCIMDetail,"^",28)
	s ParamArr("PHCDoseQty")=$p(PHCDoseStr,$C(1),1)
	s ParamArr("PHCDoseUOMDesc")=$p(PHCDoseStr,$C(1),2)
	s ParamArr("PHCDoseUOMRowid")=$p(PHCDoseStr,$C(1),3)
	
	s ParamArr("MidDischargedFlag")=$P(iother,$C(1),18)
	//医嘱性别年龄验证
	s ParamArr("ASCheckFlag")=$P(ASCheckStr,$C(2),1)
	s ParamArr("ASCheckSex")=$P(ASCheckStr,$C(2),2)
	s ParamArr("ASCheckAgeRange")=$P(ASCheckStr,$C(2),3)
	s ParamArr("PilotCatFlag")=$P(iother,$C(1),8)
	s ParamArr("CheckArcimTypeStr")=$P(iother,$C(1),10)
	m ParamArr=ArcosArr
	if (ParamArr("OrderPhSpecInstr")="") {
		//取药品信息维护-药学信息-草药备注
		s phcdfId=ParamArr("OrderDrugFormRowid")
		s:phcdfId'="" ParamArr("OrderPhSpecInstr")=$p($g(^PHCD(+phcdfId,"DF",$p(phcdfId,"||",2),"DHC")),"^",7)
		s OrderPhSpecInstr=ParamArr("OrderPhSpecInstr")
		if (OrderPhSpecInstr'="") {
			s OrderPhSpecInstrRowid=""
		    s CNMedItemPhSpecInstr=..%GetConfig("CNMedItemPhSpecInstr",CurLogonHosp)
		    if (CNMedItemPhSpecInstr'="") {
				for i=1:1:$l(CNMedItemPhSpecInstr,"^") {
					s OneCNMedItemPhSpecInstr=$p(CNMedItemPhSpecInstr,"^",i)
					s SpecInstrRowid=$p(OneCNMedItemPhSpecInstr,$c(1),1)
					if (OrderPhSpecInstr=SpecInstrRowid) {
						s OrderPhSpecInstrRowid=SpecInstrRowid
						Q
					}
				}
			}
			s ^temscp("ff")=OrderPhSpecInstrRowid
			s ParamArr("OrderPhSpecInstr")=OrderPhSpecInstrRowid
		}
	}
	s IsARCOSFormula=0
	s OrderARCOSRowid=$G(ParamArr("OrderARCOSRowid"))
	if (OrderARCOSRowid'="") {
		s IsARCOSFormula=##class(web.UDHCPrescript).IsARCOSFormula($p(OrderARCOSRowid,"||",1),CurLogonHosp)
	}
	s ParamArr("IsARCOSFormula")=IsARCOSFormula
	s OrderSum=0
	if ($G(ParamArr("OrderDoseQty"))'="") {
		s OrderSum=ParamArr("OrderDoseQty")*ParamArr("PrescDurFactor")*ParamArr("OrderPrice")
		s OrderSum=$FN(OrderSum,"",2)
	}
	s ParamArr("OrderSum")=OrderSum
	s INCIPackCombStr=""
	s OrderInciPrice="" //根据库存项ID和各个库存项对应数量计算所得价格
	s AllowEntryDecimalItemCat="N"
	s ITCRowID=$o(^DHCItmMast("0","ARCIM",ParamArr("OrderARCIMRowid"),""),-1)
	if (ITCRowID'=""){
		s AllowEntryDecimalItemCat=$p($G(^DHCItmMast(ITCRowID)),"^",29)
	}
	s AllowEntryDecimalItemCat=$CASE(AllowEntryDecimalItemCat,"Y":"Y",:"N")
	s OrderSerialNum=##class(web.DHCDocPrescript).GetOrderSerialNum(BaseParamArr("Adm"))
    s OrderHiddenPara =ParamArr("OrderMaxDurFactor")_$C(3)_ParamArr("OrderMaxQty")
    _$C(3)_ParamArr("OrderDrugFormRowid")_$C(3)_ParamArr("OrderItemCatRowid")
    _$C(3)_DefaultDoseQty_$C(3)_ParamArr("OrderLimitDays")
    _$C(3)_OrderARCOSRowid_$C(3)_INCIPackCombStr
    _$C(3)_ParamArr("WarningUseQty")_$C(3)_ParamArr("PHCDoseUOMDesc")
    _$C(3)_ParamArr("PHCDoseUOMRowid")_$C(3)_ParamArr("OrderGenericName")
    _$C(3)_OrderInciPrice_$C(3)_AllowEntryDecimalItemCat_$C(3)_OrderSerialNum
    s ParamArr("OrderHiddenPara")=OrderHiddenPara
	q
GetItemRowDataJsonObj(OutPutInfo,CallBackFunStr,ParamArr,ItemRowDataArr)
	n (OutPutInfo,CallBackFunStr,ParamArr,ItemRowDataArr)
	k ItemRowDataArr
	s ErrCode=$P(OutPutInfo,"^",1)
	s ErrMsg=$P(OutPutInfo,"^",2)
	s ItemRowDataArr("ErrCode")=ErrCode
	s ItemRowDataArr("ErrMsg")=ErrMsg
	
	s SubNodeNum=0
	for i=1:1:$Length(CallBackFunStr,$C(2)){
		s SingleCallBackFun=$P(CallBackFunStr,$C(2),i)
		if (SingleCallBackFun=""){continue}
		s CallBakFunCode=$P(SingleCallBackFun,"^",1)
		s CallBakFunParams=$P(SingleCallBackFun,"^",2)
		s SubNodeNum=SubNodeNum+1
		s ItemRowDataArr("CallBakFunS",SubNodeNum,"CallBakFunCode")=CallBakFunCode
		s ItemRowDataArr("CallBakFunS",SubNodeNum,"CallBakFunParams")=CallBakFunParams
	}
	m ItemRowDataArr("OrdListInfo")=ParamArr
	q 0
BaseValidCheck(ParamArr,ItemOrdsArr,BaseParamArr,CallBackFunStr)
	n (ParamArr,ItemOrdsArr,BaseParamArr,CallBackFunStr,%session)
	s OutInfo="0^^^^^^"
	s SessionStr=$G(BaseParamArr("SessionStr"))
	s CurLogonDep=$p(SessionStr,"^",3)
	s OrderARCIMRowid=ParamArr("OrderARCIMRowid")
	s ArcimDesc=ParamArr("OrderName")
	s SessionStr=$G(BaseParamArr("SessionStr"))
	s USERID=$P(SessionStr,"^",1)
	s CareProvType=##class(web.DHCDocOrderCommon).GetCareProvType(USERID)
	s OrderPriorRowid=$G(BaseParamArr("OrderPriorRowid"))
	s EpisodeID=BaseParamArr("Adm")
	s PAAdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
	s CurrentDischargeStatus=##class(web.DHCDischargeHistory).GetCurrentDischargeStatus(EpisodeID)
	if ((CareProvType="DOCTOR") && (PAAdmType="I")&&(ParamArr("MidDischargedFlag")="1")&&(CurrentDischargeStatus'="B")) {
         s OutInfo="-1^此病人已做医疗结算,不允许医生再开医嘱.^^^^"
         Q OutInfo
    }
	if (ParamArr("OrderItemInValid") = 1) {
        s OutInfo="-1^"_ArcimDesc_##class(websys.Translation).Get("opdoc.oeorder.cmlistcustom.csp"," 医嘱项目无效!")_"^^^^"
		Q OutInfo
    }
    if (ParamArr("OrderAuthInValid") = 0) {
        s OutInfo="-1^"_ArcimDesc_##class(websys.Translation).Get("opdoc.oeorder.cmlistcustom.csp"," 没有权限录入该医嘱!")_"^^^^"
		Q OutInfo
    }
    if (ParamArr("ireclocstr") = "") {
        s OutInfo="-1^"_ArcimDesc_##class(websys.Translation).Get("opdoc.oeorder.cmlistcustom.csp"," 该医嘱没有接收科室,请与信息中心联系!")_"^^^^"
		Q OutInfo
    }
    if (ParamArr("AlertAuditSpecialItem") '= 0) {
        s CallBackFunParams=ArcimDesc_##class(websys.Translation).Get("opdoc.oeorder.cmlistcustom.csp"," 需要医保办审批，否则按自费结算处理!")
		s CallBackFunStr=##class(web.DHCOEOrdItemView).GetCallBackFunStr(CallBackFunStr,"Confirm",CallBackFunParams)
    }
    if (ParamArr("ASCheckFlag") = 1) {
        s OutInfo="-1^"_"项目"_ArcimDesc_"被限制使用：性别限制为:"_ParamArr("ASCheckSex")_"年龄限制为："_ParamArr("ASCheckAgeRange")
    	Q OutInfo
    }
    //判断医嘱项中的门急诊限制
    if (ParamArr("CheckArcimTypeStr")'=""){
        s OutInfo="-1^"_ArcimDesc_##class(websys.Translation).Get("opdoc.oeorder.cmlistcustom.csp",ParamArr("CheckArcimTypeStr"))
		Q OutInfo
    }
    if (ParamArr("OrderPrice")="")||(ParamArr("OrderPrice")<0){
	    s OutInfo="-1^"_ArcimDesc_##class(websys.Translation).Get("opdoc.oeorder.cmlistcustom.csp","价格无效!")
		Q OutInfo
	}
    if (ParamArr("OrderPrice")=0) {
		s CallBackFunParams=ArcimDesc_##class(websys.Translation).Get("opdoc.oeorder.cmlistcustom.csp","此医嘱单价为0?您确定要开吗?")
		s CallBackFunStr=##class(web.DHCOEOrdItemView).GetCallBackFunStr(CallBackFunStr,"Confirm",CallBackFunParams)
	}
	;出院带药不能下的子类和管制分类控制
    s ret=##Class(web.DHCOEOrdItem).CheckPriorAllow(EpisodeID,OrderPriorRowid,OrderARCIMRowid,CurLogonDep)
    if (+ret<0) {
        s OutInfo="-1^" _$P(ret,"^",2)
    	Q OutInfo
    }
    ;判断是否有医嘱分类管控权限
	s DoctorID=##class(web.SSUser).GetDefaultCareProvider(USERID)
	s HOSPID=$P(SessionStr,"^",4)
	s AllowArcItemValue=##class(DHCDoc.DHCDocConfig.PrescriptSet).CheckForAllowArcItem(DoctorID,OrderARCIMRowid,HOSPID,"CM")
	if (AllowArcItemValue=0){
		 s OutInfo="-1^"_##class(websys.Translation).Get("opdoc.oeorder.cmlistcustom.csp","该医生没有开")_ArcimDesc_##class(websys.Translation).Get("opdoc.oeorder.cmlistcustom.csp","的权限,请联系信息科确认!")
		 q OutInfo
		}
	;判断用药限制
	s AdmDepId=$p($g(^PAADM(EpisodeID)),"^",4)
	s AdmReason=$p($G(^PAADM(EpisodeID,1)),"^",7)
	s EpisodeType=$P($G(^PAADM(EpisodeID)),"^",2)
	s PAADMRegConDisDR=$P($G(^PAADM(EpisodeID,"DHC")),"^",25)
	s PatientID=$P(^PAADM(EpisodeID),"^",1)
	s PatientNo=$P($g(^PAPER(PatientID,"PAT",1)),"^",1)
	s PACWardID=$P($g(^PAADM(EpisodeID)),"^",70)
	s:(PACWardID'="") PACWardLocId=$P($g(^PAWARD(PACWardID)),"^",5)
	s CareProvTP=$P($G(^CTPCP(+DoctorID,1)),"^",4)
	S ^tempqujian("GetCombCtrlLevel")=$lb(OrderARCIMRowid,HOSPID,"",LogonDep,$g(AdmDepId),$G(PACWardLocId),$g(CareProvTP),USERID,EpisodeType,$g(AdmReason),PatientNo,"")
	s ItemAuth=##Class(PHA.FACE.OUT.Com).GetCombCtrlLevel(OrderARCIMRowid,HOSPID,"",CurLogonDep,$g(AdmDepId),$G(PACWardLocId),$g(CareProvTP),USERID,EpisodeType,$g(AdmReason),PatientNo,"")
	if (ItemAuth.CtrlLevel="BAN"){
		s OutInfo="-1^该"_ArcimDesc_##class(websys.Translation).Get("opdoc.oeorder.cmlistcustom.csp","已做用药限制，没有权限开立！")_"^^^^"
		q OutInfo
	}elseif (ItemAuth.CtrlLevel="PROMPT"){
		s CallBackFunParams=ArcimDesc_"已做用药限制,"_ItemAuth.Remarks
		s CallBackFunStr=##class(web.DHCOEOrdItemView).GetCallBackFunStr(CallBackFunStr,"Alert",CallBackFunParams)	
	}
    Q OutInfo
CheckPrescItemAndCount(ParamArr,ItemOrdsArr,BaseParamArr,ItemCongeriesArr,CallBackFunStr)
	n (ParamArr,ItemOrdsArr,BaseParamArr,ItemCongeriesArr,CallBackFunStr,%session)
	s OutInfo="0^^^^^^"
	s OrderType=ParamArr("OrderType")
	Q:OrderType'="R" OutInfo
	s OrderARCIMRowid=ParamArr("OrderARCIMRowid")
	s ArcimDesc=ParamArr("OrderName")
	s OrderGenericName=ParamArr("OrderGenericName") 
	s CurrCellPos=ParamArr("RowIndex")_"^"_ParamArr("GroupIndex")
	s SessionStr=$G(BaseParamArr("SessionStr"))
	s HOSPID=$P(SessionStr,"^",4)
	s i="",PrescCheck=""
	for {
		s i=$O(ItemOrdsArr("ItemOrds",i))
		Q:(i="")
		s iOrderARCIMRowid=ItemOrdsArr("ItemOrds",i,"OrderARCIMRowid")
		s iOrderHiddenPara=ItemOrdsArr("ItemOrds",i,"OrderHiddenPara")
		s iOrderGenericName=$p(iOrderHiddenPara,$C(3),12)
		s iOrderRow=ItemOrdsArr("ItemOrds",i,"Row")
		s iOrderGroup=ItemOrdsArr("ItemOrds",i,"Group")
		s iCellPos=iOrderRow_"^"_iOrderGroup
		if ((iOrderARCIMRowid=OrderARCIMRowid)&&(iCellPos'=CurrCellPos)){
			s PrescCheck=1 
			Q
		}
		if ((iOrderGenericName=OrderGenericName)&&(iCellPos'=CurrCellPos)){
			s PrescCheck=2
			Q
		}
	}
	if (PrescCheck="") {
		s i=""
		for {
			s i=$O(ItemCongeriesArr(i))
			Q:(i="")
			s iOrderARCIMRowid=ItemCongeriesArr(i,"OrdListInfo","OrderARCIMRowid")
			s iOrderGenericName=ItemCongeriesArr(i,"OrdListInfo","OrderGenericName")
			if (iOrderARCIMRowid=OrderARCIMRowid){
				s PrescCheck=1 
				Q
			}
			if (iOrderGenericName=OrderGenericName){
				s PrescCheck=2
				Q
			}
		}
	}
	s CMOrdSameArcName=..%GetConfig("CMOrdSameArcName",HOSPID)
	if (PrescCheck="1"){
		s OutInfo="-1^"_ArcimDesc_##class(websys.Translation).Get("opdoc.oeorder.cmlistcustom.csp","存在相同的医嘱,一张处方不允许重复")
		Q OutInfo
	}elseif((PrescCheck="2")&&(CMOrdSameArcName=1)){
		s OutInfo="-1^"_ArcimDesc_##class(websys.Translation).Get("opdoc.oeorder.cmlistcustom.csp","已存在相同通用名【")_OrderGenericName_##class(websys.Translation).Get("opdoc.oeorder.cmlistcustom.csp","】的医嘱,一张处方不允许重复!")
		Q OutInfo
	}
	Q OutInfo
CheckItemPoison(ParamArr,BaseParamArr,CallBackFunStr)
	n (ParamArr,BaseParamArr,CallBackFunStr,%session)
	s OutInfo="0^^^^^^"
	s SessionStr=$G(BaseParamArr("SessionStr"))
	s USERID=$P(SessionStr,"^",1)
	s HOSPID=$P(SessionStr,"^",4)
	;开医嘱人的身份证号
	s UserIDCardNo=$p(^SSU("SSUSR",USERID),"^",122) 
	;常规设置-允许开医嘱人给自己开毒麻药品
	s AllowUserEnrtyOwnDMDrug=..%GetConfig("AllowUserEnrtyOwnDMDrug",HOSPID)
	;精麻毒性必须录入身份证号
	s ItemDesc =ParamArr("OrderName")
	s PHPoisonCode=ParamArr("OrderPoisonCode")
	s EpisodeID=BaseParamArr("Adm")
	s PatientID = $P(^PAADM(EpisodeID),"^",1)	
	;获取身份证信息
 	s IDCardNo=##Class(web.DHCDocOrderEntry).FindPAPMIID(PatientID)
	if ((PHPoisonCode="J1")||(PHPoisonCode="DX")||(PHPoisonCode="MZ")||(PHPoisonCode="DM")){
		if (UserIDCardNo=IDCardNo)&&(IDCardNo'="")&&(AllowUserEnrtyOwnDMDrug'=1) {
		 	 s OutInfo="-1^"_ItemDesc_"是"_$case(PHPoisonCode,"J1":"精一",:"毒麻")_"类处方,不能自己为自己开立!"_"^^^^^^^"
	         q OutInfo
		}
		if (IDCardNo=""){
			s CallBackFunParams=ItemDesc
			s CallBackFunStr=##class(web.DHCOEOrdItemView).GetCallBackFunStr(CallBackFunStr,"CheckPoison",CallBackFunParams)
		}
	}
    if ((PHPoisonCode = "DBTHZJ") || (PHPoisonCode = "TLJS")) {
	    s CallBackFunParams=ItemDesc_"POISON_SPORT_ALERT"
		s CallBackFunStr=##class(web.DHCOEOrdItemView).GetCallBackFunStr(CallBackFunStr,"Alert",CallBackFunParams)
    }
	Q OutInfo
AutoSelectPrescTypeList(ParamArr,BaseParamArr,ItemOrdsArr,CallBackFunStr)
	n (ParamArr,BaseParamArr,ItemOrdsArr,CallBackFunStr,%session)
	s OutInfo="0^^^^^^"
	s SessionStr=$G(BaseParamArr("SessionStr"))
	s CurLogonHosp=$P(SessionStr,"^",4)
	s ArcimDesc=ParamArr("OrderName")
	s PrescTypeCode=BaseParamArr("PrescTypeCode")
	s PrescType=..%GetConfig1("CMPrescTypeList",PrescTypeCode,CurLogonHosp) //$G(^DHCDocConfig("CMPrescTypeList",PrescTypeCode))
	s CNItemCatStr=..%GetConfig(PrescTypeCode,CurLogonHosp) //$G(^DHCDocConfig(PrescTypeCode))
	s OrderItemCatRowid=$G(ParamArr("OrderItemCatRowid"))
	if (("^"_CNItemCatStr_"^")'[("^"_OrderItemCatRowid_"^")){
		s ItemPrescTypeCode=..GetPrescTypeCodeByItemCat(OrderItemCatRowid,CurLogonHosp)
		if (ItemPrescTypeCode="") {
			s CMSubCategory=##Class(web.DHCDocOrderCommon).GetCNMedItemCatStr(CurLogonHosp)
			s CMSubCategory="^"_CMSubCategory_"^"
			if (CMSubCategory'[("^"_OrderItemCatRowid_"^")) {
				s OutInfo="-1^"_ArcimDesc_##class(websys.Translation).Get("opdoc.oeorder.cmlistcustom.csp","为非草药医嘱,不允许录入!")
			}else{
				s OutInfo="-1^"_##class(websys.Translation).Get("opdoc.oeorder.cmlistcustom.csp","未维护医嘱项")_ArcimDesc_##class(websys.Translation).Get("opdoc.oeorder.cmlistcustom.csp","对应子类所属处方类型,不允许录入!")
			}
			Q OutInfo
		}
		s ItemPrescTypeDesc=$p(^DHCDocConfig("HospDr_"_CurLogonHosp,"CMPrescTypeList",ItemPrescTypeCode),"^",1)
		s ItemPrescTypeDesc=##class(websys.Translation).Get("opdoc.oeorder.cmlistcustom.csp",ItemPrescTypeDesc)
		if ($G(ItemOrdsArr("Length"))>0) {
			s OutInfo="-1^"_ArcimDesc_##class(websys.Translation).Get("opdoc.oeorder.cmlistcustom.csp","为")_ItemPrescTypeDesc_##class(websys.Translation).Get("opdoc.oeorder.cmlistcustom.csp","药品,不允许录入!")
			Q OutInfo
		}else{
			s CallBackFunParams=ArcimDesc_##class(websys.Translation).Get("opdoc.oeorder.cmlistcustom.csp","为")_ItemPrescTypeDesc_##class(websys.Translation).Get("opdoc.oeorder.cmlistcustom.csp","药品,是否确认录入")_ItemPrescTypeDesc_##class(websys.Translation).Get("opdoc.oeorder.cmlistcustom.csp","处方?")_";"_ItemPrescTypeCode
			s CallBackFunStr=##class(web.DHCOEOrdItemView).GetCallBackFunStr(CallBackFunStr,"SwitchCMPrescTypeKW",CallBackFunParams)
		}
	}
	s EpisodeID=BaseParamArr("Adm")
	s PAAdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
	s OrderBillTypeRowid=$G(BaseParamArr("OrderBillTypeRowid"))
	if (PAAdmType'="I"){
		s OrderARCIMRowid=ParamArr("OrderARCIMRowid")
		s OrderItemCatRowid=$p($g(^ARCIM(+OrderARCIMRowid,$p(OrderARCIMRowid,"||",2),1)),"^",10)
		s PrescriptTypes=##Class(web.DHCPAADMPrescType).GetPrescTypeByPAADM(PAAdmType,OrderBillTypeRowid,CurLogonHosp)
		for i=1:1:$L(PrescriptTypes,"||") {
			s PrescriptType=$P(PrescriptTypes,"||",i)
			continue:PrescriptType=""
			s BillTypeID2=$P(PrescriptType,"!",5)
			s SubCatIDs=$P(PrescriptType,"!",4)
			if (SubCatIDs=""){
				s BillTypeArr(BillTypeID2) = ""
			}else{
				s BillTypeArr(BillTypeID2) = "^"_SubCatIDs_"^"
			}
		}
		s PrescCheck=""
		s SubCatIDs=$G(BillTypeArr(OrderBillTypeRowid))
		if (SubCatIDs'[("^"_OrderItemCatRowid_"^"))&&(SubCatIDs'=""){
			/*s BillTypeID2=""
			for {
				s BillTypeID2=$O(BillTypeArr(BillTypeID2))
				q:(BillTypeID2="")
				s SubCatIDs=$G(BillTypeArr(BillTypeID2))
				if (SubCatIDs[("^"_OrderItemCatRowid_"^"))||(SubCatIDs=""){
					s PrescCheck=BillTypeID2
				}
			}*/
		}else{
			s PrescCheck=OrderBillTypeRowid
		}
		if (PrescCheck=""){
			s OutInfo="-1^"_ArcimDesc_##class(websys.Translation).Get("opdoc.oeorder.cmlistcustom.csp","此医嘱不符合处方类型!")
			Q OutInfo
		}
	}
	Q OutInfo
CheckConflict(ParamArr,ItemOrdsArr,BaseParamArr,ItemCongeriesArr,CallBackFunStr)
	n (ParamArr,ItemOrdsArr,BaseParamArr,ItemCongeriesArr,CallBackFunStr,%session)
	s OutInfo="0^^^^^^"
	s ARCIMRowid=$G(ParamArr("OrderARCIMRowid"))
	s ArcimDesc=$G(ParamArr("OrderName"))
	s EpisodeID=BaseParamArr("Adm")
	s SessionStr=$G(BaseParamArr("SessionStr"))
    s CurLogonHosp=$p(SessionStr,"^",4)
    s i="",ARCIMRowidNextAll=""
	for {
		s i=$O(ItemOrdsArr("ItemOrds",i))
		Q:(i="")
		s OrderARCIMRowid=ItemOrdsArr("ItemOrds",i,"OrderARCIMRowid")
		continue:OrderARCIMRowid=""
		if (ARCIMRowidNextAll="") s ARCIMRowidNextAll=OrderARCIMRowid
		else  s ARCIMRowidNextAll=ARCIMRowidNextAll_"^"_OrderARCIMRowid
	}
	s CheckCMLimitFlag=##class(web.DHCDocOrderEntryCM).GetCMLimitInfo(ARCIMRowid,ARCIMRowidNextAll)
	if (CheckCMLimitFlag '= "") {
		s CallBackFunParams=ArcimDesc _ " " _ CheckCMLimitFlag _ ##class(websys.Translation).Get("opdoc.oeorder.cmlistcustom.csp",",是否确定录入?")
		s CallBackFunStr=##class(web.DHCOEOrdItemView).GetCallBackFunStr(CallBackFunStr,"Confirm",CallBackFunParams)
	}else{
		s rtn=##class(web.DHCDocOrderEntryCM).CheckConflict(EpisodeID,ARCIMRowid,CurLogonHosp)
        s CheckConflict=$p(rtn,"^",1)
        s ConflictInfo=$p(rtn,"^",2)
        if (CheckConflict="Y")  {
			s CallBackFunParams=ArcimDesc_ConflictInfo_##class(websys.Translation).Get("opdoc.oeorder.cmlistcustom.csp","互斥!")
			s CallBackFunStr=##class(web.DHCOEOrdItemView).GetCallBackFunStr(CallBackFunStr,"Alert",CallBackFunParams)
        }
	}
	;判断医嘱套内医嘱是否互斥
	s i="",ARCIMRowidPreAll=""
	for {
		s i=$O(ItemCongeriesArr(i))
		Q:(i="")
		s iOrderARCIMRowid=ItemCongeriesArr(i,"OrdListInfo","OrderARCIMRowid")
		continue:iOrderARCIMRowid=""
		if (ARCIMRowidPreAll="") s ARCIMRowidPreAll=iOrderARCIMRowid
		else  s ARCIMRowidPreAll=ARCIMRowidPreAll_"^"_iOrderARCIMRowid
	}
	if (ARCIMRowidPreAll'="") {
		s CheckCMLimitFlag=##class(web.DHCDocOrderEntryCM).GetCMLimitInfo(ARCIMRowid,ARCIMRowidPreAll)
		if (CheckCMLimitFlag '= "") {
			s CallBackFunParams=ArcimDesc _ " " _ CheckCMLimitFlag _ ##class(websys.Translation).Get("opdoc.oeorder.cmlistcustom.csp",",是否确定录入?")
			s CallBackFunStr=##class(web.DHCOEOrdItemView).GetCallBackFunStr(CallBackFunStr,"Confirm",CallBackFunParams)
		}/*else{
			s rtn=##class(web.DHCDocOrderEntryCM).CheckConflict(EpisodeID,ARCIMRowid)
	        s CheckConflict=$p(rtn,"^",1)
	        s ConflictInfo=$p(rtn,"^",2)
	        if (CheckConflict="Y")  {
				s CallBackFunParams=ArcimDesc_ConflictInfo_"互斥!"
				s CallBackFunStr=##class(web.DHCOEOrdItemView).GetCallBackFunStr(CallBackFunStr,"Alert",CallBackFunParams)
	        }
		}*/
	}
	Q OutInfo
INSCPackSumInt(ParamArr,BaseParamArr,UserOptionArr,CallBackFunStr)
	n (ParamArr,BaseParamArr,UserOptionArr,CallBackFunStr,%session)
	s OutInfo="0^^^^^^"
	s SessionStr=$G(BaseParamArr("SessionStr"))
	s HOSPID=$P(SessionStr,"^",4)
	s OrderARCIMRowid=ParamArr("OrderARCIMRowid")
	s ArcimDesc=$G(ParamArr("OrderName"))
	s EpisodeID=BaseParamArr("Adm")
	s RecLoc=BaseParamArr("RelocRowID")
	s OrderDoseQty=ParamArr("OrderDoseQty")
	s TakingMedicineMethod=$G(BaseParamArr("TakingMedicineMethod"))
	s TakingMedicine="Y" //取药方式可以不判断库存
	if (TakingMedicineMethod'=""){
		s ToStock=$P(^DHCDocConfig("TakingMedicineMethod",TakingMedicineMethod),$c(1),4)
		if ((ToStock="N")||(ToStock=""))  s TakingMedicine="N"
	}
	;q:TakingMedicine="N" OutInfo
	i OrderDoseQty="" s OrderDoseQty=1
	if (OrderDoseQty>1000000) {
		s OutInfo="-1^"_ArcimDesc_##class(websys.Translation).Get("opdoc.oeorder.cmlistcustom.csp","没有找到可用的包装数或您没有选择数值!")
		Q OutInfo
	}
	s INICrowInfo=""
    s numStr =##class(web.DHCDocOrderEntryCM).CheckINCIPackSum(EpisodeID,OrderARCIMRowid, RecLoc,OrderDoseQty,HOSPID,TakingMedicineMethod)
    if (numStr '= "") {
	    s INICConFacStr=$p(numStr,$C(2),1)
    	s INICrowInfo=$p(numStr,$C(2),2)
    	s minNear=$p(numStr,$C(2),3)
    	s maxNear=$p(numStr,$C(2),4)
    	if (INICrowInfo="") {
	    	if (OrderDoseQty=1) {
		    	s numStr=##class(web.DHCDocOrderEntryCM).CheckINCIPackSum(EpisodeID,OrderARCIMRowid, RecLoc,maxNear,HOSPID,TakingMedicineMethod)
		    	if (numStr'="") {
			    	s INICrowInfo=$p(numStr,$C(2),2)
			    	s OrderDoseQty=maxNear
			    }
		    }else{
			    s i=$O(UserOptionArr("SelectCMDoseQty",0))
				if (i=""){
				    s CallBackFunParams=";"_OrderARCIMRowid_";"_RecLoc_";"_minNear_";"_maxNear
				    s CallBackFunStr=##class(web.DHCOEOrdItemView).GetCallBackFunStr(CallBackFunStr,"SelectCMDoseQty",CallBackFunParams)
				}
			}
	    }
	}
	s UserOptionIndex=0
	for {
		s UserOptionIndex=$O(UserOptionArr("SelectCMDoseQty",UserOptionIndex)) Q:UserOptionIndex=""
		s SelectCMQty=$G(UserOptionArr("SelectCMDoseQty",UserOptionIndex,"Value"))
		s SelARCIMRowId=$G(UserOptionArr("SelectCMDoseQty",UserOptionIndex,"ARCIMRowId"))
		if (SelectCMQty'="")&&(SelARCIMRowId=OrderARCIMRowid){
			s numStr=##class(web.DHCDocOrderEntryCM).CheckINCIPackSum(EpisodeID,OrderARCIMRowid, RecLoc,SelectCMQty,HOSPID,TakingMedicineMethod)
			if (numStr'="") {
		    	s INICrowInfo=$p(numStr,$C(2),2)
		    	s OrderDoseQty=SelectCMQty
		    }
		    Q
		}
	}
	/*s i=$O(UserOptionArr("SelectCMDoseQty",0))
	if (i'="") {
		s SelectCMQty=$G(UserOptionArr("SelectCMDoseQty",i,"Value"))
		s SelARCIMRowId=$G(UserOptionArr("SelectCMDoseQty",i,"ARCIMRowId"))
		if (SelectCMQty'=""){
			s numStr=##class(web.DHCDocOrderEntryCM).CheckINCIPackSum(EpisodeID,OrderARCIMRowid, RecLoc,SelectCMQty)
			if (numStr'="") {
		    	s INICrowInfo=$p(numStr,$C(2),2)
		    	s OrderDoseQty=SelectCMQty
		    }
		}
	}*/
	if (INICrowInfo'=""){
   		s ParamArr("INCIPackCombInt")=INICrowInfo_"^"_OrderDoseQty
   		s ParamArr("OrderDoseQty")=OrderDoseQty
   		s $p(ParamArr("OrderHiddenPara"),$C(3),8)=INICrowInfo
		s OrderItemSum=##class(web.DHCSTINTERFACE).GetInciListPrice(INICrowInfo,HOSPID)	
		s $p(ParamArr("OrderHiddenPara"),$C(3),13)=OrderItemSum	
		s OrderItemSum=OrderItemSum*ParamArr("PrescDurFactor")
		s OrderItemSum=$FN(OrderItemSum,"",2)
		s ParamArr("OrderSum")=OrderItemSum
    }else{
	    s ParamArr("INCIPackCombInt")=""
	    s OutInfo="-1^"_ArcimDesc_##class(websys.Translation).Get("opdoc.oeorder.cmlistcustom.csp","没有找到可用的包装数或您没有选择数值!")
		Q OutInfo
	}
	Q OutInfo
CheckStock(ParamArr,BaseParamArr,CallBackFunStr)
	n (ParamArr,BaseParamArr,CallBackFunStr,%session)
	s OutInfo="0^^^^^^"
	s ArcimDesc=$G(ParamArr("OrderName"))
	s INCIPackCombInt=$G(ParamArr("INCIPackCombInt"))
	if (INCIPackCombInt="") {
		Q OutInfo
	}
	s INCIPackCombStr=$p(INCIPackCombInt,"^",1)
	if (INCIPackCombStr="") {
		Q OutInfo
	}
	s PrescDurFactor=BaseParamArr("PrescDurFactor")
	s RecLoc=BaseParamArr("RelocRowID")
	s SessionStr=$G(BaseParamArr("SessionStr"))
	s CurLogonHosp=$p(SessionStr,"^",4)
	s ExpStr=CurLogonHosp
	s TakingMedicineMethod=$G(BaseParamArr("TakingMedicineMethod"))
	s Adm=$G(BaseParamArr("Adm"))
	s PAAdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(Adm)
	s CheckStock=##class(web.DHCDocOrderCommon).CheckStockEnoughByInc(INCIPackCombStr,RecLoc,PAAdmType,ExpStr,PrescDurFactor,TakingMedicineMethod)
	if (CheckStock=0){
		s OutInfo="-1^"_ArcimDesc_##class(websys.Translation).Get("opdoc.oeorder.cmlistcustom.csp","库存不足!")
		Q OutInfo
	}elseif (CheckStock ="-1") {
		s OrderRecDep=$p(^CTLOC(RecLoc),"^",2)
		s OutInfo="-1^"_ArcimDesc_OrderRecDep_##class(websys.Translation).Get("opdoc.oeorder.cmlistcustom.csp","被锁定,如需要请联系药房工作人员")
		Q OutInfo
	}
	Q OutInfo
}

/// 初始化医嘱套或复制医嘱对象，注意不能随便初始化ARCOSArr，后面计算会判断$D(ARCOSArr)
ClassMethod InitARCOSArr(ByRef ARCOSArr, ParamS As %String, EpisodeID As %String, SessionStr As %String, OrderARCIMRowid As %String) As %String
{
    //从医嘱套里传入的参数,取医嘱套信息
    s ^tempscl("InitARCOSArr")=ParamS
    s CurLogonHosp=$p(SessionStr,"^",4)
    if (ParamS '= "") {
	    s ispecdoseqtystr=$P(ParamS, "^", 1)
	    s SpecOrderDoseQty = $P(ispecdoseqtystr, $C(1), 1) //单次剂量
        s SpecOrderDoseUOM = $P(ispecdoseqtystr, $C(1), 2)
        s SpecOrderDoseUOMRowid = $P(ispecdoseqtystr, $C(1), 3)
	    s ARCOSArr("OrderDoseQty")=SpecOrderDoseQty
	    s OrderARCOSRowid=$P(ParamS, "^", 7)
		s ARCOSArr("OrderARCOSRowid")=OrderARCOSRowid
	    s OrderPhSpecInstr=$P(ParamS, "^", 10)
	    s ARCOSArr("OrderPhSpecInstr")=OrderPhSpecInstr
	    if (OrderPhSpecInstr'="") {
		    s CNMedItemPhSpecInstr=..%GetConfig("CNMedItemPhSpecInstr",CurLogonHosp)
		    if (CNMedItemPhSpecInstr'="") {
				for i=1:1:$l(CNMedItemPhSpecInstr,"^") {
					s OneCNMedItemPhSpecInstr=$p(CNMedItemPhSpecInstr,"^",i)
					s SpecInstrRowid=$p(OneCNMedItemPhSpecInstr,$c(1),1)
					s SpecInstrDesc=$p(OneCNMedItemPhSpecInstr,$c(1),2)
					if (OrderPhSpecInstr=##class(websys.Translation).Get("opdoc.oeorder.cmlistcustom.csp",SpecInstrDesc)) {
						s ARCOSArr("OrderPhSpecInstr")=SpecInstrRowid
						Q
					}
				}
			}
		}
    }
    Q
}

/// 根据草药医嘱子类获取对应的处方类型
ClassMethod GetPrescTypeCodeByItemCat(OrderItemCatRowid As %String, CurLogonHosp As %String = "") As %String
{
	i ($g(CurLogonHosp)="")&&($d(%session)) s CurLogonHosp=%session.Get("LOGON.HOSPID")
	s CMPrescTypeCode=""
	for {
		s CMPrescTypeCode=$o(^DHCDocConfig("HospDr_"_CurLogonHosp,"CMPrescTypeList",CMPrescTypeCode)) Q:CMPrescTypeCode=""
		s ActiveFlag=$p(^DHCDocConfig("HospDr_"_CurLogonHosp,"CMPrescTypeList",CMPrescTypeCode),"^",2)
		continue:ActiveFlag'="Y"
		s CMSubCategory=..%GetConfig(CMPrescTypeCode,CurLogonHosp)
		s CMSubCategory="^"_CMSubCategory_"^"
		if (CMSubCategory[("^"_OrderItemCatRowid_"^")){
			//s CMPrescTypeDesc=$p(^DHCDocConfig("CMPrescTypeList",CMPrescTypeCode),"^",1)
			Q
		}
	}
	Q CMPrescTypeCode
}

/// 草药判断是否能录入小数
/// Y是可以 N是不行
ClassMethod CheckAllowEntryDecimalItem(OrderARCIMRowid)
{
	s AllowEntryDecimalItemCat="N"
	s ITCRowID=$o(^DHCItmMast("0","ARCIM",OrderARCIMRowid,""),-1)
	if (ITCRowID'=""){
		s AllowEntryDecimalItemCat=$p($G(^DHCItmMast(ITCRowID)),"^",29)
	}
	s AllowEntryDecimalItemCat=$CASE(AllowEntryDecimalItemCat,"Y":"Y",:"N")
	q AllowEntryDecimalItemCat
}

}
