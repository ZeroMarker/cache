/// creator:宋春莉
/// date:2020-08-04
/// desc:和东华医为内部系统的接口类【主要是提供给其他产品组的接口】，仅医嘱系统相关，本类不收录医生站其他产生线与内部的接口
Class DHCDoc.Interface.Inside.ServiceOrd Extends DHCDoc.Util.RegisteredObject
{

/// Creator:宋春莉
/// CreatDate:2020.08.04
/// Description:插入医嘱(非草药),适应于门诊、住院保存所有类型医嘱项目，可以一次性插入多条医嘱
/// Input:	Adm:就诊表ID(PA_Adm) 
/// 		OrdItemStr:需要保存的医嘱串 
/// 		User:下医嘱用户 
/// 		Loc:下医嘱科室 
/// 		Doc:下医嘱医生 
/// 		LABDATA:LAB的namespce 
/// 		ExpStr:扩展参数(以^分割) 
/// 		ErrMsg:错误信息
/// 		SessionStr：参考BSP.SYS.SRV.Session.GetSessionStr
/// Return：返回值(100 失败 , 其他 成功)
/// Others: w ##class(DHCDoc.Interface.Inside.ServiceOrd).SaveOrderItems()
ClassMethod SaveOrderItems(Adm As %String, OrdItemStr As %String, User As %String, Loc As %String, Doc As %String, LABDATA As %String = "", ExpStr As %String = "", ByRef ErrMsg As %String = "", SessionStr As %String = "") As %Status
{
	if (SessionStr=""){
		s SessionStr=..%SessionStr()
	}
	if (SessionStr=""){
		s SessionStr=User_"^^"_Loc_"^"_##class(DHCDoc.Common.Hospital).GetLocHospitalId(Loc)
	}
	//先生成检验号，防止出现采血费存储的检验号与医嘱不一致的问题
	s OrdItemStr=##Class(web.DHCDocPrescript).CreatOrdNo(Adm,OrdItemStr,SessionStr)
	s NotBindLabFee=$P(ExpStr,"^",10)
	s BaseParamJson="{}"
	if (NotBindLabFee="Y"){
		s BaseParamObj=##class(DHCDoc.Util.ArrayData).%New()
		d BaseParamObj.SetAt(",BF,CT,SP,","DisBindTypeList")
		s BaseParamJson=BaseParamObj.%ToJSON().Read()
	}
	k OrdAddCongeriesArr
	s ret=##class(web.DHCOEOrdAppendItem).GetAppendOrdItemArr(Adm,OrdItemStr,Loc,.OrdAddCongeriesArr,SessionStr,BaseParamJson)
	s i=0
	for{
		s i=$O(OrdAddCongeriesArr(i))
		q:(i="")
		s Item=$G(OrdAddCongeriesArr(i,"OrdListInfo"))
		continue:(Item="")
		s ARCIMRowid=$P(Item,"^",1)
		continue:(ARCIMRowid="")
		s OrdItemStr=OrdItemStr_$C(1)_Item
	}

	Q ##class(web.DHCOEOrdItem).SaveOrderItems(Adm,OrdItemStr,User,Loc,Doc,LABDATA,ExpStr,.ErrMsg,SessionStr)
}

/// Creator:宋春莉
/// CreatDate:2020.08.04
/// Description:插入医嘱(草药),适应于门诊、住院保存所有类型医嘱项目，可以一次性插入多条医嘱
/// Input:Adm:就诊表ID(PA_Adm) OrdItemStr:需要保存的医嘱串 User:下医嘱用户 Loc:下医嘱科室 Doc:下医嘱医生 LABDATA:LAB的namespce ExpStr:扩展参数(以^分割) ErrMsg:错误信息 SessionStr
/// Return：返回值(100 失败 , 其他 成功)
/// Others: w ##class(DHCDoc.Interface.Inside.ServiceOrd).SaveOrderItemsCM()
ClassMethod SaveOrderItemsCM(Adm As %String, OrdItemStr As %String, User As %String, Loc As %String, Doc As %String, LABDATA As %String = "", ExpStr As %String = "", ByRef ErrMsg As %String = "", SessionStr As %String = "") As %Status
{
	if (SessionStr=""){
		s SessionStr=..%SessionStr()
	}
	if (SessionStr=""){
		s SessionStr=User_"^^"_Loc_"^"_##class(DHCDoc.Common.Hospital).GetLocHospitalId(Loc)
	}

	s OrdItemStr=##class(web.DHCOEOrdAppendItem).GetAppendOrdItemCMArr(Adm, OrdItemStr, "", SessionStr)
	Q ##class(web.DHCOEOrdItem).SaveOrderItemsCM(Adm,OrdItemStr,User,Loc,Doc,LABDATA,ExpStr,.ErrMsg,SessionStr)
}

/// Creator:宋春莉
/// CreatDate:2020.08.04
/// Description:执行医嘱(用于检查科室执行)
/// Input: OrdItmRowId:医嘱ID UserRowId:操作用户
/// Return：0:成功 其他:失败
/// Others: w ##class(DHCDoc.Interface.Inside.ServiceOrd).Execute()
ClassMethod Execute(OrdItmRowId As %String, UserRowId As %String) As %Status
{
	Q ##class(appcom.OEOrdItem).Execute(OrdItmRowId,UserRowId)
}

/// Creator:宋春莉
/// CreatDate:2020.08.04
/// Description:撤销执行医嘱
/// Input: OrdItmRowId:医嘱ID UserRowId:操作用户 ErrMsg：错误信息
/// Return：0:成功 其他:失败
/// Others: w ##class(DHCDoc.Interface.Inside.ServiceOrd).Verify()
ClassMethod Verify(OrdItmRowId As %String, UserRowId As %String, ByRef ErrMsg As %String = "") As %Status
{
	Q ##class(appcom.OEOrdItem).Verify(OrdItmRowId,UserRowId,.ErrMsg)
}

/// Creator: 宋春莉
/// CreatDate: 2020.08.04
/// Description: 处理医嘱(停止/作废/撤销)等
/// Input: OrderItemStr:医嘱串,以^ 分割,type:类型 S 停止 C 撤销 U作废,ExpStr:扩展串 user^locid^groupid
/// Return：0:成功 其他:失败
/// Others: w ##class(DHCDoc.Interface.Inside.ServiceOrd).MulOrdDealWithCom()
ClassMethod MulOrdDealWithCom(OrderItemStr As %String, date As %String, time As %String, type As %String, pinNum As %String, ExpStr As %String) As %Status
{
	Q ##class(web.DHCDocInPatPortalCommon).MulOrdDealWithCom(OrderItemStr,date,time,type,pinNum,ExpStr)
}

/// Creator: 谭吉善
/// CreatDate: 2022.01.11
/// Description: 处理执行记录(执行\撤销执行\停止执行)等
/// Input: 
/// 	OrderExecStr 医嘱执行记录Id串 以^ 分割
/// 	date 日期(可为空)
/// 	time 时间(可为空)
/// 	type 类型 R 执行 C 撤销 D 停止执行 CD 撤销执行并停止执行 U 修改小时医嘱结束时间 ExecAppend 添加手工绑定医嘱 DInEM 虚拟长期模式下的停止执行
/// 	ReasonId 撤销或停止原因ID(可为空)
/// 	ExpStr 扩展串，*表示必填 user(*执行者ID)^locid(*登录科室ID)^groupid(*登录安全组ID)^ReasonDesc(原因描述)^ExecAppendOrdList(需添加的手工绑定医嘱信息串)^PassWord(执行者密码)
/// 	PinNumStr  双签执行用户信息，可空，执行者工号_$c(1)_密码_$c(2)_核对者工号_$c(1)_密码
/// Return：0:成功 其他:失败
/// Others: w ##class(DHCDoc.Interface.Inside.ServiceOrd).MulOrdExecDealWithCom()
ClassMethod MulOrdExecDealWithCom(OrderExecStr As %String, date As %String, time As %String, type As %String, ReasonId As %String, ExpStr As %String, ByRef ErrMsg As %String = "", PinNumStr As %String = "") As %Status
{
	Q ##class(web.DHCDocInPatPortalCommon).MulOrdExecDealWithCom(OrderExecStr,date,time,type,ReasonId,ExpStr,.ErrMsg,PinNumStr)
}

/// Creator:      宋春莉
/// CreatDate:    2020.08.04
/// Description:  产生检验条码和处方号
/// Table:        
/// Input:        AdmId:就诊RowId   UserID:用户ID	ExpStr：就诊科室Rowid(CT_Loc)^
/// Return:      
/// Others:       w ##class(DHCDoc.Interface.Inside.ServiceOrd).GenPresno() 
ClassMethod GenPresno(AdmId As %String, UserId As %String, ExpStr As %String = "")
{
	
	Set AdmLocId=$p(^PAADM(AdmId),"^",4)
	Set CurLogonHosp=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(AdmId)
	d ##Class(web.DHCDocPrescript).CreatOrdNo(AdmId,"",UserId_"^"_"^"_AdmLocId_"^"_CurLogonHosp,"")
	Q
}

/// Creator:      谭吉善
/// CreatDate:    2022.09.16
/// Description:  更新条码号及其关联采血费、采血管费，不再重新关联新的费用，只对已有费用做关联修改
/// Table:        
/// Input:        OrdList:医嘱ID^分割   NewLabEpisodeNo:第三方检验号
/// Return:       0:成功，其他:失败
/// Others:       w ##class(DHCDoc.Interface.Inside.ServiceOrd).UpdateLabEpisodeNo("2585||2^2585||3","1231231") 
ClassMethod UpdateLabEpisodeNo(OrdList As %String, NewLabEpisodeNo As %String)
{
	s Ordlist=##class(%ListOfDataTypes).%New()
	for i=1:1:$L(OrdList,"^"){
		s OrdRowID=$P(OrdList,"^",i)
		continue:(OrdRowID="")
		if $$$ISERR(Ordlist.Find(+OrdRowID)){
			d Ordlist.Insert(+OrdRowID)
		}
	}
	if (Ordlist.Count()>1){
		q "-1^不同就诊的检验号无法合并"
	}
	s rtn=0
	TS
	for i=1:1:$L(OrdList,"^"){
		s OrdRowID=$P(OrdList,"^",i)
		continue:(OrdRowID="")
		s LabEpisodeNo=$P($G(^OEORD(+OrdRowID,"I",$P(OrdRowID,"||",2),3)),"^",20)
		if (LabEpisodeNo'=""){
			s LabEpisodeArr(LabEpisodeNo)=""
		}
		set OldDataJson=##class(web.DHCDocDataChangeLog).GetLogJsonData("User.OEOrdItem"_$c(2)_OrdRowID)
		&SQL(UPDATE SQLUser.OE_OrdItem SET OEORI_LabEpisodeNo = :NewLabEpisodeNo WHERE OEORI_RowId=:OrdRowID)
		s rtn=rtn+SQLCODE
		if (SQLCODE=0){
			set NewDataJson=##class(web.DHCDocDataChangeLog).GetLogJsonData("User.OEOrdItem"_$c(2)_OrdRowID)
			d ##class(web.DHCDocDataChangeLog).SaveLog("OE_OrdItem","User.OEOrdItem","医嘱信息","OEOrdItem_"_OrdRowID,"修改检验号","U",NewDataJson,OldDataJson,$O(^SSU("SSUSR",0)))
		}
	}
	if (rtn'=0){
		Trollback
		q "-1^更新医嘱表失败"
	}
	s Ord=Ordlist.GetAt(1)
	s Sub=0
	for {
		s Sub=$O(^OEORD(Ord,"I",Sub))
		q:Sub=""
		s ArcimDr=$P($G(^OEORD(Ord,"I",Sub,1)),"^",2)
		continue:ArcimDr=""
		s StatCode=""
		s OrdStat=$P($G(^OEORD(Ord,"I",Sub,1)),"^",13) 
		i OrdStat'="" s StatCode=$p($g(^OEC("OSTAT",OrdStat)),"^",1)
		Continue:(StatCode'="V")&&(StatCode'="E")
		s ItemCatRowid=$p($g(^ARCIM(+ArcimDr,$p(ArcimDr,"||",2),1)),"^",10)
		s OrderType=$P(^ARC("IC",ItemCatRowid),"^",7)
		continue:(OrderType="L")
		s LabEpisodeNoStr=$P($G(^OEORD(Ord,"I",Sub,"DHC")),"^",22)
		continue:(LabEpisodeNoStr="")
		s FindSameLabNo=0
		for i=1:1:$length(LabEpisodeNoStr,$C(1)){
			s LLabEpisodeNo=$P(LabEpisodeNoStr,$C(1),i)
			if $D(LabEpisodeArr(LLabEpisodeNo)){
				s FindSameLabNo=1
			}
		}
		if (FindSameLabNo=1){
			s LabEpisodeNoStr=LabEpisodeNoStr_$C(1)_NewLabEpisodeNo
		}
		s $P(^OEORD(Ord,"I",Sub,"DHC"),"^",22)=LabEpisodeNoStr
	}
	TC
	Q 0
}

/// Creator:      郭荣勇
/// CreatDate:    2017.03.09
/// Description:  【私有接口,未经产品组允许不得使用】更新医嘱信息【接收科室,】
/// Table:        
/// Input:        oeitm:医嘱RowId   UserID:用户ID
/// Return:       0 成功; 非0 不成功
/// Others:       w ##class(DHCDoc.Interface.Inside.Service).UpdateOEORI("747886||227") 
ClassMethod UpdateOEORI(OEORIRowId As %String, UserId As %String, NewInfo As %String) As %String
{
	Q:NewInfo="" 0
	Q:OEORIRowId="" "-1"
	Q:$l(OEORIRowId,"||")'=2 "-2"
	;接收科室ID
	s RecDepId=$p(NewInfo,"^",1)
    &sql(Update SQLUser.OE_OrdItem set OEORI_RecDep_DR=:RecDepId Where OEORI_RowId=:OEORIRowId)
    if SQLCODE {
	    d ##class(DHCDoc.Log.Common).General("Update","DHCDoc.Interface.Inside.Service","UpdateOEORI","更新医嘱信息失败",OEORIRowId,"SQL错误信息:"_$g(%mdiag(1)))
    }
    Q SQLCODE
}

/// Creator:      宋春莉
/// CreatDate:    2019.01.14
/// Description:  判断是否为皮试用法医嘱
/// Table:        
/// Input:       医嘱id
/// Return:      0：非皮试用法医嘱 1：皮试用法医嘱
/// Others:      w ##class(DHCDoc.Interface.Inside.ServiceOrd).CheckOrdIsSkinInstr()
ClassMethod CheckOrdIsSkinInstr(OEORIRowId As %String)
{
	Q:OEORIRowId="" 0
	s OrderInstrRowid=$p($g(^OEORD(+OEORIRowId,"I",$p(OEORIRowId,"||",2),2)),"^",7)
	Q:OrderInstrRowid="" 0
	;皮试用法
	s SkinTestInstr=..%GetConfig("SkinTestInstr")
	if SkinTestInstr'="" s SkinTestInstr="^"_SkinTestInstr_"^"
	if (SkinTestInstr'="")&&(SkinTestInstr[("^"_OrderInstrRowid_"^")){
		Q 1
	}
	Q 0
}

/// Creator:      谭吉善
/// CreatDate:    2020.03.16
/// Description:  写入待审核列表并将该医嘱列表加载至医嘱录入界面
/// Table:        
/// Input:       EpisodeID:就诊ID,必填项;LocDr:使用科室ID(CT_Loc),非必填，指定使用科室时传入;UserDr:使用用户ID(SS_User),非必填，指定使用用户时传入;
/// 	         CopyItemList:以$c(1)分割的医嘱信息串，例：OneItemStr_$C(1)_OneItemStr_$C(1)_OneItemStr
/// 	             OneItemStr说明:以^分割的数据串,*为必填标识
/// 	             *序号^*医嘱项ID^单次剂量^单次剂量单位ID^频次ID
/// 	             ^用法ID^疗程ID^整包装数量^整包装数量单位ID^医嘱优先级ID
/// 	             ^医嘱套ID^医嘱备注^*是否加急(N|Y)^医嘱套项目ID^检验标本代码
/// 	             ^接受科室ID(未实现)^费别
/// 	 	             序号:非关联医嘱为自增,关联医嘱的子医嘱为[主医嘱序号.子医嘱序号]。例如序号1有两条子医嘱，第一条子医嘱为1.1，第二条子医嘱为1.2；第二组医嘱的序号分别为2，2.1，2.2		
/// Return:      0：成功 其他：失败
/// Others:      w ##class(DHCDoc.Interface.Inside.ServiceOrd).InsertCopyItem(62,"","","1^311||1"_$C(1)_"2^312||1")
/// 应用方法为   d ##Class(User.DHCDocOrderCopyData).GetCopyItem()
ClassMethod InsertCopyItem(EpisodeID As %String, LocDr As %String, UserDr As %String, CopyItemList As %String) As %String
{
	s ch1 = $char(1)
	s PAAdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
	s AdmLocDr=$P(^PAADM(EpisodeID),"^",4)
	s ForbidDosing=$P($G(^CTLOC(AdmLocDr,"DHC")),"^",18)
	s ForbidDosingInstr=""
	i (ForbidDosing="1"){
		if (EpisodeType="I"){
			s ForbidDosingInstr=..%GetConfig("IPDosingInstr")
		}elseif (EpisodeType="O"){
			s ForbidDosingInstr=..%GetConfig("OPInfusionInstr")
		}
		i ForbidDosingInstr'="" s ForbidDosingInstr="^"_ForbidDosingInstr_"^"
	}
	
	
	s OrdCDRowID=""
	s ID=0
	for {
		s ID=$O(^DHCDocOrderCopyData(0,"IndexAdmDr",EpisodeID,ID))
		q:(ID="")
		s Active=$P(^DHCDocOrderCopyData(ID),"^",4)
		continue:(Active'="Y")
		s OrdCDUserDr=$P(^DHCDocOrderCopyData(ID),"^",2)
		continue:(UserDr'=OrdCDUserDr)
		s OrdCDLocDr=$P(^DHCDocOrderCopyData(ID),"^",3)
		continue:(LocDr'=OrdCDLocDr)
		s OrdCDRowID=ID
		Quit
	}
	if (OrdCDRowID'=""){
		s Obj=##Class(User.DHCDocOrderCopyData).%OpenId(OrdCDRowID)
	}else{
		s Obj=##Class(User.DHCDocOrderCopyData).%New()
		d Obj.OrdCDAdmDrSetObjectId(EpisodeID)
		d Obj.OrdCDUserDrSetObjectId(UserDr)
		d Obj.OrdCDLocDrSetObjectId(LocDr)
		s Obj.OrdCDActive="Y"
	}
	s OrdDataCount=Obj.OrdCDOrdData.Count()
	Set CopyItemCount=$L(CopyItemList,$c(1))
	For i=1:1:CopyItemCount{
		s OneItemStr=$P(CopyItemList,$c(1),i)
		continue:(OneItemStr="")
		s OrderSeqNo=$P(OneItemStr,"^",1)
		if (OrderSeqNo["."){
			s OrderSeqNo=($P(OrderSeqNo,".",1)+OrdDataCount)_"."_$P(OrderSeqNo,".",2)
		}else{
			s OrderSeqNo=OrderSeqNo+OrdDataCount
		}
		
		s ARCIMRowid=$P(OneItemStr,"^",2)
		s OrderDoseQty=$P(OneItemStr,"^",3)
		s OrderDoseUOMRowid=$P(OneItemStr,"^",4)
		s OrderDoseUOM=""
		s:OrderDoseUOMRowid'="" OrderDoseUOM=$P($G(^CT("UOM",OrderDoseUOMRowid)),"^",2)
		s OrderFreqRowid=$P(OneItemStr,"^",5)
		s (OrderFreq,OrderFreqInterval)="",OrderFreqFactor=1
		i OrderFreqRowid'="" {
			s OrderFreq=$P($g(^PHCFR(FormFreqRowid)),"^",3)
			s OrderFreqFactor=$P($g(^PHCFR(FormFreqRowid)),"^",2)
			s OrderFreqInterval=$P($g(^PHCFR(FormFreqRowid)),"^",5)
		}
		s OrderInstrRowid=$P(OneItemStr,"^",6)
		s OrderInstr=""
		if (OrderInstrRowid'=""){
			s Active=$P($g(^PHCIN(OrderInstrRowid)),"^",4)
			s AvailableType=$P($g(^PHCIN(OrderInstrRowid)),"^",5)
			if ((AvailableType'="")&&(AvailableType'[PAAdmType))||(Active="N"){
				s OrderInstrRowid=""
			}
			if (ForbidDosingInstr[("^"_OrderInstrRowid_"^")){
				s OrderInstrRowid=""
			}
		}
		s:OrderInstrRowid'="" OrderInstr=$P($g(^PHCIN(OrderInstrRowid)),"^",2)
		;疗程
		s OrderDurRowid=$P(OneItemStr,"^",7)
		s OrderDur="",OrderDurFactor=1
		i OrderDurRowid'="" {
			s OrderDur=$P($g(^PHCDU(FormDurRowid)),"^",3)
			s OrderDurFactor=$P($g(^PHCDU(FormDurRowid)),"^",2)
		}
		
		s OrderPackQty=$P(OneItemStr,"^",8)
		s OrderPackUOMRowid=$P(OneItemStr,"^",9)
		s OrderPackUOM=""
		s:OrderPackUOMRowid'="" OrderPackUOM=$P($G(^CT("UOM",OrderPackUOMRowid)),"^",2)
		s OrderPriorRowid=$P(OneItemStr,"^",10)
		s OrderPrior=""
		s:OrderPriorRowid'="" OrderPrior=$p($g(^OECPR(OrderPriorRowid)),"^",2) 
		s ARCOSRowId=$P(OneItemStr,"^",11)
		s OrderResume=$P(OneItemStr,"^",12)
		s OrderNotifyClinician=$P(OneItemStr,"^",13)
		s ArcimARCOSRowId=$P(OneItemStr,"^",14)
		s ItemSpecCode=$P(OneItemStr,"^",15)
		s OrderRecDepRowid=$P(OneItemStr,"^",16)
		s OrderBillTypeRowId=$P(OneItemStr,"^",17)
		s OrderType=""
		
		s ItemCatDR=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",10)
		i ItemCatDR'="" s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)
		s (OrderStage,OrderStageDesc,SpeedFlowRate,FlowRateUnit,FlowRateUnitRowid)=""
		s (ReqPartId,OrderActionRowid,OrderAction,OrderSkinTest)=""
		s (OrderFreqTimeDoseQtyStr,OrderFreqWeekStr,ExceedReasonID,ExceedReason)=""
		s ItemData = ARCIMRowid_"!"_OrderSeqNo_"!"_OrderDoseQty_ch1_OrderDoseUOM_ch1_OrderDoseUOMRowid
		s ItemData = ItemData_"^"_OrderFreq_ch1_OrderFreqRowid_ch1_OrderFreqFactor_ch1_OrderFreqInterval
		s ItemData = ItemData_"^"_OrderInstr_ch1_OrderInstrRowid
		s ItemData = ItemData_"^"_OrderDur_ch1_OrderDurRowid_ch1_OrderDurFactor
		s ItemData = ItemData_"^"_OrderPackQty_ch1_OrderPackUOM_ch1_OrderPackUOMRowid
		s ItemData = ItemData_"^"_OrderPrior_ch1_OrderPriorRowid
		s ItemData = ItemData_"^"_ARCOSRowId_"^^"	//医嘱套ID、空、医嘱子类ID
		s ItemData = ItemData_"^"_OrderResume	//备注
		
		s ItemData=ItemData_"^"	//附加说明
		s ItemData=ItemData_"^"	//抗生素
		s ItemData=ItemData_"^"_OrderNotifyClinician	//紧急标志
		s ItemData=ItemData_"^"_ArcimARCOSRowId //医嘱套项目id
		s ItemData=ItemData_"^"_ItemSpecCode	//标本	
		s ItemData=ItemData_"^"_OrderStage_ch1_OrderStageDesc	//医嘱阶段
		s ItemData=ItemData_"^"_SpeedFlowRate_ch1_FlowRateUnit_ch1_FlowRateUnitRowid //输液流速、流速单位
		s ItemData=ItemData_"^"_ReqPartId
		s ItemData=ItemData_"^"_OrderActionRowid_"^"_OrderAction_"^"_OrderSkinTest
		s ItemData=ItemData_"^" //计费组套餐明细编号
		s ItemData=ItemData_"^"_OrderFreqTimeDoseQtyStr_"^"_OrderFreqWeekStr //同频次不同剂量、周频次
		s ItemData=ItemData_"^"_ExceedReasonID_ch1_ExceedReason
		s ItemData = ItemData_"!"_OrderType_"!"_OrderBillTypeRowId_"!"_"Order"
		d Obj.OrdCDOrdData.Insert(ItemData)
	}
	Set sc=Obj.%Save()
	d Obj.%Close()
	If $$$ISERR(sc) {
		Quit -100
	}
	q 0
}

/// Creator:      郭荣勇
/// CreatDate:    2018.03.14
/// Description:  【私有接口,定向,电子病历组调用】提供医嘱数据数据给门诊电子病历【仅限门诊】
/// Table:        
/// Input:        入参：就诊号，是否草药标识(CHMED 为草药,空 为非草药)，业务代码(SaveOrder/Finish)
/// Return:       出参：医嘱名称，医嘱状态，医嘱优先级，开始日期，开始时间，剂量，剂量单位，频次，用法，疗程，单价，数量，数量单位，皮试，接收科室，用户登录科室，开医嘱科室，总金额，处方号，备注，开医嘱医生，医嘱添加人，开医嘱日期，序号，主序号，关联序号，标本号，医嘱ID，医嘱项ID，剂量单位ID，频次ID，医嘱优先级ID，用法ID，疗程ID，数量单位ID，接收科室ID，用户登录科室ID，开医嘱科室ID，医嘱状态ID，医嘱基本单位ID，开医嘱医生ID，医嘱添加人ID，医嘱套ID，药学项ID，最大疗程ID，医嘱类型，医嘱费别ID，医嘱费别，频次系数，频次间隔时间，疗程系数，关联医嘱ID,就诊Rowid,费别Rowid,是否有权限开此医嘱,医嘱项目备注,皮试备注,医嘱项目分类,草药处方附属信息
/// Others:       d ##class(%ResultSet).RunQuery("DHCDoc.Interface.Inside.ServiceOrd","FindEMROPItems","166","","")
Query FindEMROPItems(EpisodeID As %String, CHMEDFlag As %String = "", Business As %String = "SaveOrder") As %Library.Query(CONTAINID = "", ROWSPEC = "OrderName:%String,OrderStatus:%String,OrderPrior:%String,OrderStartDate:%String,OrderStartTime:%String,OrderDoseQty:%String,OrderDoseUOM:%String,OrderFreq:%String,OrderInstr:%String,OrderDur:%String,OrderPrice:%String,OrderPackQty:%String,OrderPackUOM:%String,OrderSkinTest:%String,OrderRecDep:%String,OrderUserDep:%String,OrderOrdDep:%String,OrderSum:%String,OrderPrescNo:%String,OrderDepProcNote:%String,OrderDoc:%String,OrderUserAdd:%String,OrderDate:%String,OrderSeqNo:%String,OrderMasterSeqNo:%String,OrderLinkTo:%String,OrderLabEpisodeNo:%String,OrderItemRowid:%String,OrderARCIMRowid:%String,OrderDoseUOMRowid:%String,OrderFreqRowid:%String,OrderPriorRowid:%String,OrderInstrRowid:%String,OrderDurRowid:%String,OrderPackUOMRowid:%String,OrderRecDepRowid:%String,OrderUserDepRowid:%String,OrderOrdDepRowid:%String,OrderStatusRowid:%String,OrderBaseUOMRowid:%String,OrderDocRowid:%String,OrderUserAddRowid:%String,OrderARCOSRowid:%String,OrderDrugFormRowid:%String,OrderMaxDurRowid:%String,OrderType:%String,OrderBillTypeRowid:%String,OrderBillType:%String,OrderFreqFactor:%String,OrderFreqInterval:%String,OrderDurFactor:%String,LinkOrderItem:%String,EpisodeID:%String,OrderBillTypeRowId:%String,OrderItemInValid:%String,ordremark:%String,skintestremark:%String,TypeClass:%String,CHMEDNotes:%String")
{
}

/// 入参：就诊号，草药标识:CHMED 为草药,"" 为西药,Business：业务代码(SaveOrder/Finish)
/// 出参：医嘱名称，医嘱状态，医嘱优先级，开始日期，开始时间，剂量，剂量单位，频次，用法，疗程，单价，数量，数量单位，皮试，接收科室，用户登录科室，开医嘱科室，总金额，处方号，备注，开医嘱医生，医嘱添加人，开医嘱日期，序号，主序号，关联序号，标本号，医嘱ID，医嘱项ID，剂量单位ID，频次ID，医嘱优先级ID，用法ID，疗程ID，数量单位ID，接收科室ID，用户登录科室ID，开医嘱科室ID，医嘱状态ID，医嘱基本单位ID，开医嘱医生ID，医嘱添加人ID，医嘱套ID，药学项ID，最大疗程ID，医嘱类型，医嘱费别ID，医嘱费别，频次系数，频次间隔时间，疗程系数，关联医嘱ID,就诊Rowid,费别Rowid,是否有权限开此医嘱,医嘱项目备注,皮试备注,医嘱项目分类,草药处方附属信息
ClassMethod FindEMROPItemsExecute(ByRef qHandle As %Binary, EpisodeID As %String, CHMEDFlag As %String = "", Business As %String = "SaveOrder") As %Status
{
 	;d ##class(%ResultSet).RunQuery("DHCDoc.Interface.Inside.Service","FindEMROPItems",11150695,"")
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	if EpisodeID="" Set qHandle=$lb(0,repid,0) Quit $$$OK
 	s AdmHospitalId=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(EpisodeID)
 	if CHMEDFlag="CHMED" {
	 	;得到草药数据
	 	d getCHMEDEMRData()
 	}else{
	 	;得到非草药数据
	 	d getEMRData()
 	}
	
	s SeqNo=0
	s adm=0 for  s adm=$O(^CacheTemp("DHCAdmOrdItem",$j,"adm",adm)) q:adm=""  d
	.s mas=0 for  s mas=$O(^CacheTemp("DHCAdmOrdItem",$j,"adm",adm,"master",mas)) q:mas=""  d
	.. s s1=^CacheTemp("DHCAdmOrdItem",$j,"adm",adm,"master",mas)
	.. q:s1=""
	.. i s1'="" d 
	.. .s SeqNo=SeqNo+1
	.. .s $List(s1,24)=SeqNo
	.. .s Data=s1
	.. .d OutputRow4
	.. s SubSeqCount=0
	.. s sub=0  for  s sub=$O(^CacheTemp("DHCAdmOrdItem",$j,"adm",adm,"master",mas,"sub",sub)) q:sub=""  d
	.. . s s2=^CacheTemp("DHCAdmOrdItem",$j,"adm",adm,"master",mas,"sub",sub)
	.. . i s1="" d
	.. . . s SeqNo= SeqNo+1
	.. . . s $List(s2,24)=SeqNo
	.. . . s Data=s2
	.. . . d OutputRow4
	.. . e  d
	.. . . s SubSeqCount=SubSeqCount+1
	.. . . s SubSeqNo=SeqNo_"."_SubSeqCount
	.. . . s $List(s2,24)=SubSeqNo
	.. . . s Data=s2
	.. . . d OutputRow4
	 K ^CacheTemp("DHCAdmOrdItem",$j,"adm")
 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
getEMRData()
	s ret=""
	Set OrderId=$o(^OEORD(0,"Adm",EpisodeID,0))
	if OrderId="" Quit ""
	Set sub=0
	for  Set sub=$o(^OEORD(OrderId,"I",sub)) Quit:sub=""  do
	.d GetOrdItemInfo(OrderId,sub)
 	
 	q
GetOrdItemInfo(OrderId,sub)
	s OrdItemInfo=""
	s OrderItemRowid=OrderId_"||"_sub
 	s OrderStatusRowid=$p($G(^OEORD(OrderId,"I",sub,1)),"^",13)
	Quit:OrderStatusRowid="" ""
 	s ItemStatCode=$p(^OEC("OSTAT",OrderStatusRowid),"^",1)
 	s OrderStatus=$p(^OEC("OSTAT",OrderStatusRowid),"^",2)
 	;协和保存医嘱时为未核实医嘱,完成接诊病历做比较,提示医生确认
 	Quit:((Business="Finish")&&(ItemStatCode'="V")&&(ItemStatCode'="E")) ""
 	Quit:((Business="SaveOrder")&&(ItemStatCode'="V")&&(ItemStatCode'="E")&&(ItemStatCode'="I")) ""
 	s ARCIMRowid=$p(^OEORD(OrderId,"I",sub,1),"^",2)
 	s checkrtn=##class(web.DHCOPAdmReg).GetRegArcimBillSubType(ARCIMRowid)
 	Quit:(checkrtn="Reg")||(checkrtn="Check") ""
 	s DoctorDR=$p(^OEORD(OrderId,"I",sub,1),"^",11)
 	Quit:DoctorDR="" ""
 	
	;非医生录入的医嘱退出
	s CarPrvTpDR=$p($g(^CTPCP(+$g(DoctorDR),1)),"^",4)
	s DoctorType=$p($g(^CT("CPT",+$g(CarPrvTpDR))),"^",4)
	Q:(DoctorType'="DOCTOR") ""
	;检验自动绑定上的医嘱不显示
	s LinkLabNo=$p($g(^OEORD(OrderId,"I",sub,"DHC")),"^",22)
	Q:LinkLabNo'="" ""
	;留观医生下的医嘱不同步到病历
	s EMStayFlag=$p($g(^OEORD(OrderId,"I",sub,"DHC")),"^",17)
	//Q:EMStayFlag="1"
	Q:'$$IsMedicalRecords(OrderId_"||"_sub) ""
	 
 	s Subscript=$p(ARCIMRowid,"||",1)
 	s Version=$p(ARCIMRowid,"||",2)
 	s OrderName=$p(^ARCIM(Subscript,Version,1),"^",2)
 	s ReqPartDesc=##Class(web.DHCAPPInterface).GetExaReqPartDesc(OrderId_"||"_sub)
 	if (ReqPartDesc'="") s OrderName=OrderName_ReqPartDesc
 	s OrderPrior=""
 	s OrderPriorRowid=$p($g(^OEORD(OrderId,"I",sub,1)),"^",8)
 	i OrderPriorRowid'="" s OrderPrior=$p(^OECPR(OrderPriorRowid),"^",2)
 	s OrderSttDate=$p($g(^OEORD(OrderId,"I",sub,1)),"^",9)
 	i OrderSttDate'="" s OrderSttDate=$zd(OrderSttDate,3)
 	s OrderSttTime=$p($g(^OEORD(OrderId,"I",sub,1)),"^",10)
 	i OrderSttTime'="" s OrderSttTime=..%ZT(OrderSttTime,1)
 	
 	s OrderDoseQty=##class(DHCDoc.Interface.Inside.Service).GetOrdDoseQty(OrderItemRowid) //$p($g(^OEORD(OrderId,"I",sub,2)),"^",1)
 	S OrderDoseUOM=""
 	S OrderFreq="",OrderFreqFactor="",OrderFreqInterval=""
 	S OrderDur="",OrderDurFactor=""
 	s OrderDoseUOMRowid=$p($g(^OEORD(OrderId,"I",sub,2)),"^",3)
 	i OrderDoseUOMRowid'="" D
 	.s OrderDoseUOM=$p(^CT("UOM",OrderDoseUOMRowid),"^",2)
 	s OrderFreqRowid=$p($g(^OEORD(OrderId,"I",sub,2)),"^",4)
 	i OrderFreqRowid'="" d
 	.s OrderFreq=$p($g(^PHCFR(OrderFreqRowid)),"^",4)
 	.s OrderFreqFactor=$p($g(^PHCFR(OrderFreqRowid)),"^",2)
 	.s OrderFreqInterval=$p($g(^PHCFR(OrderFreqRowid)),"^",9)
 	s OrderInstr=""
 	s OrderInstrRowid=$p($g(^OEORD(OrderId,"I",sub,2)),"^",7)
 	i OrderInstrRowid'="" s OrderInstr=$p(^PHCIN(OrderInstrRowid),"^",2)
 	s OrderDurRowid=$p($g(^OEORD(OrderId,"I",sub,2)),"^",6)
 	i OrderDurRowid'="" D
 	.s OrderDur=$p(^PHCDU(OrderDurRowid),"^",3)
 	.s OrderDurFactor=$p(^PHCDU(OrderDurRowid),"^",2)
 	s OrderPackQty=$p($g(^OEORD(OrderId,"I",sub,9)),"^",4)
	s OrderPackUOM=""
    s OrderPackUOMRowid=$p(^ARCIM(Subscript,Version,8),"^",14)
    i OrderPackUOMRowid'="" s OrderPackUOM=$p(^CT("UOM",OrderPackUOMRowid),"^",2)
 	s OrderBillTypeRowid=$p($g(^OEORD(OrderId,"I",sub,11)),"^",18)
 	s OrderRecDepRowid=$p($g(^OEORD(OrderId,"I",sub,3)),"^",6)
 	s retPrice=##class(web.DHCDocOrderCommon).GetOrderPrice("", OrderBillTypeRowid, ARCIMRowid, OrderSttDate, OrderPriorRowid, OrderInstrRowid, "", "",OrderRecDepRowid)
	s OrderPrice=$P(retPrice,"^",1)
	s OrderSum=OrderPackQty*OrderPrice
	i OrderBillTypeRowid="" s OrderBillType="自费"
	e  s OrderBillType=$P(^PAC("ADMREA",OrderBillTypeRowid),"^",2)
	s OrderDoseQty=$TR(OrderDoseQty," ","")
	s OrderType=""
	s ItemCatDR=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",10)
	i ItemCatDR'="" s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)
	i OrderType'="R" d
	. s DoseqtySum=$p($g(^OEORD(OrderId,"I",sub,1)),"^",12)
	. s OrderPackQty=DoseqtySum
	s OrderPackUOM=$p(OrderPackUOM,"(",1)
	s OrderSum=OrderPackQty*OrderPrice
	
 	s ItemCatDR=$p(^ARCIM(Subscript,Version,1),"^",10)
	s PHPrescType=##class(web.DHCDocOrderCommon).GetPHPrescType(ItemCatDR,AdmHospitalId,ARCIMRowid)
	Q:(PHPrescType=3) ""
	s OrderSkinTest=$p($g(^OEORD(OrderId,"I",sub,5)),"^",2)
	s OrderRecDep=""
	i OrderRecDepRowid'="" s OrderRecDep=$p(^CTLOC(OrderRecDepRowid),"^",2)
	s OrderUserDep=""
	s OrderUserDepRowid=$p($g(^OEORD(OrderId,"I",sub,7)),"^",2)
	i OrderUserDepRowid'="" s OrderUserDep=$p(^CTLOC(OrderUserDepRowid),"^",2)
	s OrderPrescNo=$p($g(^OEORD(OrderId,"I",sub,1)),"^",14)
	s OrderDepProcNote=$g(^OEORD(OrderId,"I",sub,"DEP",1))
	s OrderDoc=""
	s OrderDocRowid=$p($g(^OEORD(OrderId,"I",sub,1)),"^",11)
	i OrderDocRowid'="" s OrderDoc=$p($g(^CTPCP(OrderDocRowid,1)),"^",2)
	s OrderUserAdd=""
	s OrderUserAddRowid=$p($g(^OEORD(OrderId,"I",sub,7)),"^",1)
	i OrderUserAddRowid'="" s OrderUserAdd=$p($g(^SSU("SSUSR",OrderUserAddRowid)),"^",2)
	s OrderDate=$p($g(^OEORD(OrderId,"I",sub,3)),"^",7)
	i OrderDate'="" s OrderDate=$zd(OrderDate,3)
	s OrderSeqNo=$p($g(^OEORD(OrderId,"I",sub,3)),"^",4)
	s OrderMasterSeqNo=$p($g(^OEORD(OrderId,"I",sub,2)),"^",2)
	s OrderLabEpisodeNo=$p($g(^OEORD(OrderId,"I",sub,3)),"^",20)
	s OrderOrdDepRowid=$p($g(^OEORD(OrderId,"I",sub,1)),"^",3)
	s OrderBaseUOMRowid=""
	s OrderARCOSRowid=$p($g(^OEORD(OrderId,"I",sub,3)),"^",10)
	s OrderDrugFormRowid=##class(web.DHCDocOrderEntry).GetDrgForm(ARCIMRowid)
	;,,OrderItemInValid,TypeClass
	s OrderMaxDurRowid=""
	s LinkOrderItem=$p($g(^OEORD(OrderId,"I",sub,11)),"^",39)
	s OrderItemInValid=##Class(web.DHCDocOrderEntry).ValARCItem(ARCIMRowid)
	s ArcService=""
	s ArcService=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),7)),"^",6)
	s TypeClass=""
	i OrderType="R" d
	.i PHPrescType="3" s TypeClass="草药"
	.e  s TypeClass="西药"
	
	e  i OrderType="L" s TypeClass="检验"
	e  i $g(ArcService)="S" s TypeClass="检查"
	e  s TypeClass="其他"
	
	s ordremark=##class(web.DHCOutPhCommon).GetOrdRemark(OrderId_"||"_sub)
	s skintestremark=##class(web.DHCSTPCHCOLLS2).SkinTest2(OrderId_"||"_sub)
    s:skintestremark'="" ordremark=skintestremark_" "_ordremark
	
 	/*i OrderType="R" d
 	.s GenericName=##class(web.UDHCPrescript).GetDrugCommonNameByArcimId(ARCIMRowid)
	.s InciRowid=##class(web.DHCDocOrderEntry).GetINCI(Subscript)
	.s qty=""
	.s dsp=$o(^DHCOEDISQTY(0,"OEORI",OrderId_"||"_sub,"")) 
    .s:dsp'="" qty=$p(^DHCOEDISQTY(dsp),"^",2)
	.s qtyinfo=##class(web.DHCOutPhCommon).getPackQty(InciRowid,qty)
    .s OrderPackQty=$p(qtyinfo,"^",1)
	.s Spec=##class(web.DHCOutPhDisp).GetPhgg(InciRowid)
	.s inciDesc=$p(^INCI(InciRowid,1),"^",2)
	.s OrderName=inciDesc*/
	
	s Data1=$lb(OrderName,OrderStatus,OrderPrior,OrderSttDate,OrderSttTime,OrderDoseQty,OrderDoseUOM,OrderFreq,OrderInstr,OrderDur,OrderPrice,OrderPackQty,OrderPackUOM,OrderSkinTest,OrderRecDep,OrderUserDep,OrderOrdDep,OrderSum,OrderPrescNo,OrderDepProcNote,OrderDoc,OrderUserAdd,OrderDate,OrderSeqNo,OrderMasterSeqNo,OrderLinkTo,OrderLabEpisodeNo,OrderItemRowid,ARCIMRowid,OrderDoseUOMRowid,OrderFreqRowid,OrderPriorRowid,OrderInstrRowid,OrderDurRowid,OrderPackUOMRowid,OrderRecDepRowid,OrderUserDepRowid,OrderOrdDepRowid,OrderStatusRowid,OrderBaseUOMRowid,OrderDocRowid,OrderUserAddRowid,OrderARCOSRowid,OrderDrugFormRowid,OrderMaxDurRowid,OrderType,OrderBillTypeRowid,OrderBillType,OrderFreqFactor,OrderFreqInterval,OrderDurFactor,LinkOrderItem,EpisodeID,OrderBillTypeRowid,OrderItemInValid,ordremark,skintestremark,TypeClass,CHMEDNotes)
 	;
	s OrderChl=$P(OrderItemRowid,"||",2)
	s LinkOrderItemChl=$P(LinkOrderItem,"||",2)
	i LinkOrderItem="" s ^CacheTemp("DHCAdmOrdItem",$j,"adm",EpisodeID,"master",OrderChl)=Data1
	e  d
	.if '$D(^CacheTemp("DHCAdmOrdItem",$j,"adm",EpisodeID,"master",LinkOrderItemChl)) d
	..s ^CacheTemp("DHCAdmOrdItem",$j,"adm",EpisodeID,"master",LinkOrderItemChl)=""
	.s ^CacheTemp("DHCAdmOrdItem",$j,"adm",EpisodeID,"master",LinkOrderItemChl,"sub",OrderChl)=Data1
	
 	q 1
IsMedicalRecords(OEORI)
	s ARCIM=$p(^OEORD(+OEORI,"I",$p(OEORI,"||",2),1),"^",2)
	;是否上医嘱单,统一调用护理组方法判断
	;s rtn=##class(web.DHCNurseInterface).IfInOrderSheet(OEORI)
	;i rtn'="Y" q 0
	s OrderCategory=""
	s ItemCatDR=$p($g(^ARCIM(+ARCIM,$p(ARCIM,"||",2),1)),"^",10)
	i ItemCatDR'="" {
		s OrderCategoryDR=$P(^ARC("IC",ItemCatDR),"^",8)
		i OrderCategoryDR'="" s OrderCategory=$p(^OEC("ORCAT",OrderCategoryDR),"^",2)
	}
	s OEORIBindSource=$p($g(^OEORD(+OEORI,"I",$p(OEORI,"||",2),"DHC")),"^",41)
	Q:OEORIBindSource'="" 0
	;材料不上医嘱单
	;i OrderCategory["材料" q 0
	
	;特殊的一些项目不上医嘱单,特殊处理
	i $g(^DHCDocLocalSysP("OPDoc.MedicalRecords.SpecARCIM"))[("^"_ARCIM_"^") q 0
	
	q 1
getCHMEDEMRData()
	s QUE1RowID=""
	f  s QUE1RowID=$o(^PAQUE1(0,"QUE1_PAADM_DR",EpisodeID,QUE1RowID)) q:QUE1RowID=""  d
	.q:'$d(^PAQUE1(QUE1RowID))
	.q:'$d(^PAQUE1(QUE1RowID,"DHC"))
	.s prestype=$p(^PAQUE1(QUE1RowID,"DHC"),"^",2)
    .q:prestype'=3
    .//非医护人员录入不显示
	.s AddUser=$P(^PAQUE1(QUE1RowID,"DHC"),"^",3)
	.s CareProvType=##class(web.DHCDocOrderCommon).GetCareProvType(AddUser)
	.s CareProvType=$zcvt(CareProvType,"U")
	.q:CareProvType'="DOCTOR"
	.s prescno=$p(^PAQUE1(QUE1RowID),"^",14)
	.s insdr=$p(^PAQUE1(QUE1RowID,"DHC"),"^",11)
    .s Instruc=""
    .i insdr'="" s Instruc=$p(^PHCIN(insdr),"^",1) ;用法
    .s durdr=$p(^PAQUE1(QUE1RowID,"DHC"),"^",10)
    .s facotor=""
    .i durdr'="" s facotor=$p(^PHCDU(durdr),"^",2) ;剂数
    .s orderqty=$p(^PAQUE1(QUE1RowID,"DHC"),"^",13) ;用量
    .s CHMEDNotes="共"_facotor_"剂"_"  用法:"_Instruc_"   一次用量:"_orderqty
	.s OEORDRowId="",prescOrdNum=0, Ordret="",stopflag=0
	.f  s OEORDRowId=$o(^OEORD(0,"PrescNo",prescno,OEORDRowId)) q:OEORDRowId=""  d
	..s OEORIChildsub="" 
	..f  s OEORIChildsub=$o(^OEORD(0,"PrescNo",prescno,OEORDRowId,OEORIChildsub)) q:OEORIChildsub=""  d
	...q:'$d(^OEORD(OEORDRowId,"I",OEORIChildsub))
	...s ItemStat=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",13)
    ...q:ItemStat="4"
	...d getCHOrderItemInfo(OEORDRowId,OEORIChildsub)
	
	q
getCHOrderItemInfo(OrderId,sub)
	s OrdItemInfo=""
	s OrderItemRowid=OrderId_"||"_sub
 	s OrderStatusRowid=$p($G(^OEORD(OrderId,"I",sub,1)),"^",13)
	Quit:OrderStatusRowid="" ""
 	s ItemStatCode=$p(^OEC("OSTAT",OrderStatusRowid),"^",1)
 	s OrderStatus=$p(^OEC("OSTAT",OrderStatusRowid),"^",2)
 	;协和保存医嘱时为未核实医嘱,完成接诊病历做比较,提示医生确认
 	Quit:((Business="Finish")&&(ItemStatCode'="V")&&(ItemStatCode'="E")) ""
 	Quit:((Business="SaveOrder")&&(ItemStatCode'="V")&&(ItemStatCode'="E")&&(ItemStatCode'="I")) ""
 	s ARCIMRowid=$p(^OEORD(OrderId,"I",sub,1),"^",2)
 	s checkrtn=##class(web.DHCOPAdmReg).GetRegArcimBillSubType(ARCIMRowid)
 	Quit:(checkrtn="Reg")||(checkrtn="Check") ""
 	s DoctorDR=$p(^OEORD(OrderId,"I",sub,1),"^",11)
 	Quit:DoctorDR="" ""
 	
	;非医生录入的医嘱退出
	s CarPrvTpDR=$p($g(^CTPCP(+$g(DoctorDR),1)),"^",4)
	s DoctorType=$p($g(^CT("CPT",+$g(CarPrvTpDR))),"^",4)
	Q:(DoctorType'="DOCTOR") ""

	Q:'$$IsMedicalRecords(OrderId_"||"_sub) ""
	
	s Subscript=$p(ARCIMRowid,"||",1)
 	s Version=$p(ARCIMRowid,"||",2)
 	s OrderName=$p(^ARCIM(Subscript,Version,1),"^",2)
 	s OrderPrior=""
 	s OrderPriorRowid=$p($g(^OEORD(OrderId,"I",sub,1)),"^",8)
 	i OrderPriorRowid'="" s OrderPrior=$p(^OECPR(OrderPriorRowid),"^",2)
 	s OrderSttDate=$p($g(^OEORD(OrderId,"I",sub,1)),"^",9)
 	i OrderSttDate'="" s OrderSttDate=$zd(OrderSttDate,3)
 	s OrderSttTime=$p($g(^OEORD(OrderId,"I",sub,1)),"^",10)
 	i OrderSttTime'="" s OrderSttTime=..%ZT(OrderSttTime,1)
 	
 	s OrderDoseQty=$p($g(^OEORD(OrderId,"I",sub,2)),"^",1)
 	S OrderDoseUOM=""
 	S OrderFreq="",OrderFreqFactor="",OrderFreqInterval=""
 	S OrderDur="",OrderDurFactor=""
 	;s OrderDoseUOMRowid=$p($g(^OEORD(OrderId,"I",sub,2)),"^",3)
 	;i OrderDoseUOMRowid'="" D
 	;.s OrderDoseUOM=$p(^CT("UOM",OrderDoseUOMRowid),"^",2)
 	s Phcdf=$P($g(^ARCIM(+ARCIMRowid,$P(ARCIMRowid,"||",2),1)),"^",12)
    if Phcdf'="" s OrderDoseUOMRowid=$p(^PHCD(+Phcdf,"DF",$p(Phcdf,"||",2),2),"^",4),OrderDoseUOM=##class(web.DHCDocOrderCommon).GetUOMDesc(OrderDoseUOMRowid)
 	s OrderFreqRowid=$p($g(^OEORD(OrderId,"I",sub,2)),"^",4)
 	i OrderFreqRowid'="" d
 	.s OrderFreq=$p($g(^PHCFR(OrderFreqRowid)),"^",4)
 	.s OrderFreqFactor=$p($g(^PHCFR(OrderFreqRowid)),"^",2)
 	.s OrderFreqInterval=$p($g(^PHCFR(OrderFreqRowid)),"^",9)
 	s OrderInstr=""
 	s OrderInstrRowid=$p($g(^OEORD(OrderId,"I",sub,2)),"^",7)
 	i OrderInstrRowid'="" s OrderInstr=$p(^PHCIN(OrderInstrRowid),"^",2)
 	s OrderDurRowid=$p($g(^OEORD(OrderId,"I",sub,2)),"^",6)
 	i OrderDurRowid'="" D
 	.s OrderDur=$p(^PHCDU(OrderDurRowid),"^",3)
 	.s OrderDurFactor=$p(^PHCDU(OrderDurRowid),"^",2)
 	s OrderPackQty=$p($g(^OEORD(OrderId,"I",sub,9)),"^",4)
	s OrderPackUOM=""
    s OrderPackUOMRowid=$p(^ARCIM(Subscript,Version,8),"^",14)
    i OrderPackUOMRowid'="" s OrderPackUOM=$p(^CT("UOM",OrderPackUOMRowid),"^",2)
 	s OrderBillTypeRowid=$p($g(^OEORD(OrderId,"I",sub,11)),"^",18)
 	s OrderRecDepRowid=$p($g(^OEORD(OrderId,"I",sub,3)),"^",6)
 	s retPrice=##class(web.DHCDocOrderCommon).GetOrderPrice("", OrderBillTypeRowid, ARCIMRowid, OrderSttDate, OrderPriorRowid, OrderInstrRowid, "", "",OrderRecDepRowid)
	s OrderPrice=$P(retPrice,"^",1)
	s OrderSum=OrderPackQty*OrderPrice
	i OrderBillTypeRowid="" s OrderBillType="自费"
	e  s OrderBillType=$P(^PAC("ADMREA",OrderBillTypeRowid),"^",2)
	s OrderDoseQty=$TR(OrderDoseQty," ","")
	s OrderType=""
	s ItemCatDR=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",10)
	i ItemCatDR'="" s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)
	i OrderType'="R" d
	. s DoseqtySum=$p($g(^OEORD(OrderId,"I",sub,1)),"^",12)
	. s OrderPackQty=DoseqtySum
	s OrderPackUOM=$p(OrderPackUOM,"(",1)
	s OrderSum=OrderPackQty*OrderPrice
	
 	s ItemCatDR=$p(^ARCIM(Subscript,Version,1),"^",10)
	s PHPrescType=##class(web.DHCDocOrderCommon).GetPHPrescType(ItemCatDR,AdmHospitalId,ARCIMRowid)
	Q:(PHPrescType'=3) ""
	s OrderSkinTest=$p($g(^OEORD(OrderId,"I",sub,5)),"^",2)
	s OrderRecDep=""
	i OrderRecDepRowid'="" s OrderRecDep=$p(^CTLOC(OrderRecDepRowid),"^",2)
	s OrderUserDep=""
	s OrderUserDepRowid=$p($g(^OEORD(OrderId,"I",sub,7)),"^",2)
	i OrderUserDepRowid'="" s OrderUserDep=$p(^CTLOC(OrderUserDepRowid),"^",2)
	s OrderPrescNo=$p($g(^OEORD(OrderId,"I",sub,1)),"^",14)
	s OrderDepProcNote=$g(^OEORD(OrderId,"I",sub,"DEP",1))
	s OrderDoc=""
	s OrderDocRowid=$p($g(^OEORD(OrderId,"I",sub,1)),"^",11)
	i OrderDocRowid'="" s OrderDoc=$p($g(^CTPCP(OrderDocRowid,1)),"^",2)
	s OrderUserAdd=""
	s OrderUserAddRowid=$p($g(^OEORD(OrderId,"I",sub,7)),"^",1)
	i OrderUserAddRowid'="" s OrderUserAdd=$p($g(^SSU("SSUSR",OrderUserAddRowid)),"^",2)
	s OrderDate=$p($g(^OEORD(OrderId,"I",sub,3)),"^",7)
	i OrderDate'="" s OrderDate=$zd(OrderDate,3)
	s OrderSeqNo=$p($g(^OEORD(OrderId,"I",sub,3)),"^",4)
	s OrderMasterSeqNo=$p($g(^OEORD(OrderId,"I",sub,2)),"^",2)
	s OrderLabEpisodeNo=$p($g(^OEORD(OrderId,"I",sub,3)),"^",20)
	s OrderOrdDepRowid=$p($g(^OEORD(OrderId,"I",sub,1)),"^",3)
	s OrderBaseUOMRowid=""
	s OrderARCOSRowid=$p($g(^OEORD(OrderId,"I",sub,3)),"^",10)
	s OrderDrugFormRowid=##class(web.DHCDocOrderEntry).GetDrgForm(ARCIMRowid)
	;,,OrderItemInValid,TypeClass
	s OrderMaxDurRowid=""
	s LinkOrderItem=$p($g(^OEORD(OrderId,"I",sub,11)),"^",39)
	s OrderItemInValid=##Class(web.DHCDocOrderEntry).ValARCItem(ARCIMRowid)
	s ArcService=""
	s ArcService=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),7)),"^",6)
	s TypeClass=""
	i OrderType="R" d
	.i PHPrescType="3" s TypeClass="草药"
	.e  s TypeClass="西药"
	e  i OrderType="L" s TypeClass="检验"
	e  i $g(ArcService)="S" s TypeClass="检查"	s ArcService=""	
	e  s TypeClass="其他"
	///e  i (" Service S ")[(" "_ServerMaterial_" ") s TypeClass="检查"
	s ordremark=OrderDepProcNote
	s skintestremark=""
	s actiondr=$p(^OEORD(OrderId,"I",sub,11),"^",21) 
	i actiondr'="" s skintestremark=$p(^OEC("ACT",actiondr),"^",2)
	
 	/*i OrderType="R" d
 	.s GenericName=##class(web.UDHCPrescript).GetDrugCommonNameByArcimId(ARCIMRowid)
	.s InciRowid=##class(web.DHCDocOrderEntry).GetINCI(Subscript)
	.s dsp=$o(^DHCOEDISQTY(0,"OEORI",OrderId_"||"_sub,"")) 
    .s qty=$p(^DHCOEDISQTY(dsp),"^",2)
	.s qtyinfo=##class(web.DHCOutPhCommon).getPackQty(InciRowid,qty)
    .s OrderPackQty=$p(qtyinfo,"^",1)
	.s Spec=##class(web.DHCOutPhDisp).GetPhgg(InciRowid)
	.s inciDesc=$p(^INCI(InciRowid,1),"^",2)
	.s OrderName=inciDesc_" "_Spec*/
	s Data1=$lb(OrderName,OrderStatus,OrderPrior,OrderSttDate,OrderSttTime,OrderDoseQty,OrderDoseUOM,OrderFreq,OrderInstr,OrderDur,OrderPrice,OrderPackQty,OrderPackUOM,OrderSkinTest,OrderRecDep,OrderUserDep,OrderOrdDep,OrderSum,OrderPrescNo,OrderDepProcNote,OrderDoc,OrderUserAdd,OrderDate,OrderSeqNo,OrderMasterSeqNo,OrderLinkTo,OrderLabEpisodeNo,OrderItemRowid,ARCIMRowid,OrderDoseUOMRowid,OrderFreqRowid,OrderPriorRowid,OrderInstrRowid,OrderDurRowid,OrderPackUOMRowid,OrderRecDepRowid,OrderUserDepRowid,OrderOrdDepRowid,OrderStatusRowid,OrderBaseUOMRowid,OrderDocRowid,OrderUserAddRowid,OrderARCOSRowid,OrderDrugFormRowid,OrderMaxDurRowid,OrderType,OrderBillTypeRowid,OrderBillType,OrderFreqFactor,OrderFreqInterval,OrderDurFactor,LinkOrderItem,EpisodeID,OrderBillTypeRowid,OrderItemInValid,ordremark,skintestremark,TypeClass,CHMEDNotes)
 	;
	s OrderChl=$P(OrderItemRowid,"||",2)
	s LinkOrderItemChl=$P(LinkOrderItem,"||",2)
	i LinkOrderItem="" s ^CacheTemp("DHCAdmOrdItem",$j,"adm",EpisodeID,"master",OrderChl)=Data1
	e  d
	.if '$D(^CacheTemp("DHCAdmOrdItem",$j,"adm",EpisodeID,"master",LinkOrderItemChl)) d
	..s ^CacheTemp("DHCAdmOrdItem",$j,"adm",EpisodeID,"master",LinkOrderItemChl)=""
	.s ^CacheTemp("DHCAdmOrdItem",$j,"adm",EpisodeID,"master",LinkOrderItemChl,"sub",OrderChl)=Data1
	
	q	
	 
OutputRow4
	;set Data=$lb(OrderName,OrderStatus,OrderPrior,OrderSttDate,OrderSttTime,OrderDoseQty,OrderDoseUOM,OrderFreq,OrderInstr,OrderDur,OrderPrice,OrderPackQty,OrderPackQtyUOM,OrderSkinTest,OrderRecDep,OrderUserDep,OrderOrdDep,OrderSum,OrderPrescNo,OrderDepProcNote,OrderDoc,OrderUserAdd,OrderDate,OrderSeqNo,OrderMasterSeqNo,OrderLinkTo,OrderLabEpisodeNo,OrderItemRowid,ARCIMRowid,OrderSttDate,OrderDoseUOMRowid,OrderFreqRowid,OrderPriorRowid,OrderInstrRowid,OrderDurRowid,OrderPackUOMRowid,OrderRecDepRowid,OrderUserDepRowid,OrderOrdDepRowid,OrderStatusRowid,OrderBaseUOMRowid,OrderDocRowid,OrderUserAddRowid,OrderLinkto,OrderARCOSRowid,OrderDrugFormRowid,OrderMaxDurRowid,OrderType,OrderBillTypeRowid,OrderMaxDurRowid,OrderBillType,DepProcNotes)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod FindEMROPItemsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindEMROPItemsExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
	Set AtEnd=1
	Set Row=""
	}
	Else      {				// fetch row
	Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindEMROPItemsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindEMROPItemsExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// CTOR: QP
/// DATE: 2019-10-14
/// DESC: 【公共接口】获取医嘱数据数据
/// IN  :  {EpisodeID:109,OEORIItmMastDR:1074||1}
/// JsonInput:目前支持的属性有 
/// =====================================================================================
/// EpisodeID、OEORI_PrescNo、OEORI_Anaest_DR、OEORI_AnaOper_DR、OEORI_AnaestAgent_DR、OEORI_APPT_DR
/// OEORI_WaitList_DR、OEORI_ClinPathways_DR、OEORI_ManufacturerOrder_DR、OEORI_ItemGroup
/// OEORI_HICClaimNo、OEORI_LabEpisodeNo、OEORI_Consult_DR、OEORI_Date、OEORI_XDate、OEORI_BilledDate
/// OEORI_ItmMast_DR、OEORI_BBExtCode、OEORI_Priority_DR、OEORI_LabTestSetRow
/// 
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.Interface.Inside.ServiceOrd","QryOeoriCommon","")
Query QryOeoriCommon(JsonInput As %String) As %Query(ROWSPEC = "seqno:%String,OrderName:%String,OrderStatus:%String,OrderPrior:%String,OrderStartDate:%String,OrderStartTime:%String,OrderDoseQty:%String,OrderDoseUOM:%String,OrderFreq:%String,OrderInstr:%String,OrderDur:%String,OrderPrice:%String,OrderPackQty:%String,OrderPackUOM:%String,OrderSkinTest:%String,OrderRecDep:%String,OrderUserDep:%String,OrderOrdDep:%String,OrderSum:%String,OrderPrescNo:%String,OrderDepProcNote:%String,OrderDoc:%String,OrderUserAdd:%String,OrderDate:%String,OrderSeqNo:%String,OrderMasterSeqNo:%String,OrderLinkTo:%String,OrderLabEpisodeNo:%String,OrderItemRowid:%String,OrderARCIMRowid:%String,OrderDoseUOMRowid:%String,OrderFreqRowid:%String,OrderPriorRowid:%String,OrderInstrRowid:%String,OrderDurRowid:%String,OrderPackUOMRowid:%String,OrderRecDepRowid:%String,OrderUserDepRowid:%String,OrderOrdDepRowid:%String,OrderStatusRowid:%String,OrderBaseUOMRowid:%String,OrderDocRowid:%String,OrderUserAddRowid:%String,OrderARCOSRowid:%String,OrderDrugFormRowid:%String,OrderMaxDurRowid:%String,OrderType:%String,OrderBillTypeRowid:%String,OrderBillType:%String,OrderFreqFactor:%String,OrderFreqInterval:%String,OrderDurFactor:%String,LinkOrderItem:%String,EpisodeID:%String,OrderBillTypeRowId:%String,OrderItemInValid:%String,ordremark:%String,skintestremark:%String,TypeClass:%String,CHMEDNotes:%String")
{
}

ClassMethod QryOeoriCommonExecute(ByRef qHandle As %Binary, JsonInput As %Library.String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	//s JsonInput = "{EpisodeID:""109"",""OEORIOEORDParRef"":""103"",OEORIItmMastDR:""1074||1"",""OEORIPrescNo"":""E190202000029""}"
	if (JsonInput="") {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK		
	}
	s sqlStr = "SELECT * FROM SQLUser.OE_OrdItem WHERE "
	s sqlPre = "",OrderParref="",sqlAdm=""
	s JsonObj = ##class(ext.util.JsonObject).FromJSON(JsonInput)
	i ($$GetOrderParref=1) {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK	
	}
	d BuildPreIndex
	d BuildAfterIndex
	
	s sqlStr = sqlStr_sqlPre_sqlAfter
	w sqlStr,!
	s tStatement = ##class(%SQL.Statement).%New()
	s qStatus = tStatement.%Prepare(sqlStr)
	if (qStatus'=1) {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK	
	}
	s x=tStatement.%Metadata.columns.Count()
	set rset = tStatement.%Execute()
	s totalRecord=0,seqno=0
	s totalColumn=rset.%ResultColumnCount
	WHILE rset.%Next() {
    	//s seqno=rset.%ROWCOUNT
    	//s name=rset.%StatementTypeName
     	//DO rset.%Print("^|^")
     	s record=""
     	s totalRecord=totalRecord+1
     	s (OrderName,OrderStatus,OrderPrior,OrderStartDate,OrderStartTime)=""
     	s (OrderARCIMRowid,OrderStatusRowid,OrderPriorRowid,oeori)=""
     	for j=1:1:totalColumn {
	  		s column=tStatement.%Metadata.columns.GetAt(j)
	  		s colName=column.colName
	  		s colValue=rset.%GetData(j)
	  		i colName="OEORI_RowId" s oeori=colValue
	  		Q:oeori'=""
		}
		continue:oeori=""
		s OrderId=$p(oeori,"||",1)
		s sub=$p(oeori,"||",2)
		d GeOeoriInfo(OrderId,sub)
    } 
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
BuildDateIndex
	s DateIndex(1)="OEORIDate:OEORI_Date"
	s dateLen=$o(DateIndex(""),-1)
	s sqlDate=""
	f i=1:1:dateLen {
		s cItem=DateIndex(i)
		s cKey=$p(cItem,":",1)
		s cSqlName=$p(cItem,":",2)
		s cValue=JsonObj.GetValue(cKey)
		if (cValue="") {
			continue:JsonInput'[cKey
		}
		//
		i sqlDate="" s sqlDate=sqlDate_" BETWEEN '"_cValue_"' AND '"_cValue_"'"
		e  s sqlDate=sqlDate_sqlDate_" BETWEEN '"_cValue_"' AND '"_cValue_"'"
		
	}
	Q 0
	
GetOrderParref()
	s admid=JsonObj.GetValue("EpisodeID")
	s InParref=JsonObj.GetValue("OEORIOEORDParRef")
	i admid'="" {
		//f  s ord=$o(^OEORD(0,"Adm",admid,ord)) q:ord=""  d
		s OrderParref=$o(^OEORD(0,"Adm",admid,0))
	}
	i OrderParref'="" {
		s sqlAdm="OEORI_OEORD_ParRef="_OrderParref
	}
	i (OrderParref'="")&&(InParref'="")&&(InParref'=OrderParref) {
		Q 1	
	}
	i OrderParref="" s OrderParref=InParref
	
	Q 0
BuildPreIndex
	s PreIndex(1)="OEORIPrescNo:OEORI_PrescNo"
	s PreIndex(2)="OEORIAnaestDR:OEORI_Anaest_DR"
	s PreIndex(3)="OEORIAnaestAgentDR:OEORI_AnaestAgent_DR"
	s PreIndex(4)="OEORIAnaOperDR:OEORI_AnaOper_DR"
	s PreIndex(5)="OEORIAPPTDR:OEORI_APPT_DR"
	s PreIndex(6)="OEORIWaitListDR:OEORI_WaitList_DR"				//User.PAWaitingList
	s PreIndex(7)="OEORIClinPathwaysDR:OEORI_ClinPathways_DR"		//	User.MRClinicalPathWays
	s PreIndex(8)="OEORIManufacturerOrderDR:OEORI_ManufacturerOrder_DR"	//	User.INManufactureOrder
	s PreIndex(9)="OEORIItemGroup:OEORI_ItemGroup"
	s PreIndex(10)="OEORIHICClaimNo:OEORI_HICClaimNo"
	s PreIndex(11)="OEORILabEpisodeNo:OEORI_LabEpisodeNo"
	s PreIndex(12)="OEORIConsultDR:OEORI_Consult_DR"		//User.PAPersonConsultSetCons
	s PreIndex(13)="OEORIDate:OEORI_Date"
	s PreIndex(14)="OEORIXDate:OEORI_XDate"
	s PreIndex(15)="OEORIBilledDate:OEORI_BilledDate"
	s preLen=$o(PreIndex(""),-1)
	f i=1:1:preLen {
		s cItem=PreIndex(i)
		s cKey=$p(cItem,":",1)
		s cSqlName=$p(cItem,":",2)
		s cValue=JsonObj.GetValue(cKey)
		if (cValue="") {
			continue:JsonInput'[cKey
		}
		i sqlPre="" s sqlPre=cSqlName_"='"_cValue_"'"
		e  s sqlPre=sqlPre_" AND "_cSqlName_"='"_cValue_"'"
		
	}
	Q 0
	
BuildAfterIndex
	s AfterIndex(1)="OEORIItmMastDR:OEORI_ItmMast_DR"
	s AfterIndex(2)="OEORIBBExtCode:OEORI_BBExtCode"
	s AfterIndex(3)="OEORIPriorityDR:OEORI_Priority_DR"
	s AfterIndex(4)="OEORILabTestSetRow:OEORI_LabTestSetRow"
	
	s aftLen=$o(AfterIndex(""),-1)
	s sqlAfter=""
	i (OrderParref'="") {
		if sqlPre="" {
			s sqlAfter="OEORI_OEORD_ParRef='"_OrderParref_"'"
		}else {
			s sqlAfter=" AND OEORI_OEORD_ParRef='"_OrderParref_"'"
		}
		f i=1:1:aftLen {
			s cItem=AfterIndex(i)
			s cKey=$p(cItem,":",1)
			s cSqlName=$p(cItem,":",2)
			s cValue=JsonObj.GetValue(cKey)
			if (cValue="") {
				continue:JsonInput'[cKey
			}
			i sqlAfter="" s sqlAfter=cSqlName_"='"_cValue_"'"
			e  s sqlAfter=sqlAfter_" AND "_cSqlName_"='"_cValue_"'"
		}
	}
	Q 0
	
GeOeoriInfo(OrderId,sub)
	s OrdItemInfo=""
	s OrderItemRowid=OrderId_"||"_sub
 	s OrderStatusRowid=$p($G(^OEORD(OrderId,"I",sub,1)),"^",13)
	Q:OrderStatusRowid=""
 	s ItemStatCode=$p(^OEC("OSTAT",OrderStatusRowid),"^",1)
 	s OrderStatus=$p(^OEC("OSTAT",OrderStatusRowid),"^",2)
 	s ARCIMRowid=$p(^OEORD(OrderId,"I",sub,1),"^",2)
 	s checkrtn=##class(web.DHCOPAdmReg).GetRegArcimBillSubType(ARCIMRowid)
 	Quit:(checkrtn="Reg")||(checkrtn="Check") ""
 	s DoctorDR=$p(^OEORD(OrderId,"I",sub,1),"^",11)
 	Quit:DoctorDR="" ""
 	
	;非医生录入的医嘱退出
	s CarPrvTpDR=$p($g(^CTPCP(+$g(DoctorDR),1)),"^",4)
	s DoctorType=$p($g(^CT("CPT",+$g(CarPrvTpDR))),"^",4)
	Q:(DoctorType'="DOCTOR") ""
	;检验自动绑定上的医嘱不显示
	s LinkLabNo=$p($g(^OEORD(OrderId,"I",sub,"DHC")),"^",22)
	Q:LinkLabNo'="" ""
	;留观医生下的医嘱不同步到病历
	s EMStayFlag=$p($g(^OEORD(OrderId,"I",sub,"DHC")),"^",17)
	;Q:EMStayFlag="1"
	;Q:'$$IsMedicalRecords(OrderId_"||"_sub) ""
	 
 	s Subscript=$p(ARCIMRowid,"||",1)
 	s Version=$p(ARCIMRowid,"||",2)
 	s OrderName=$p(^ARCIM(Subscript,Version,1),"^",2)
 	s ReqPartDesc=##Class(web.DHCAPPInterface).GetExaReqPartDesc(OrderId_"||"_sub)
 	if (ReqPartDesc'="") s OrderName=OrderName_ReqPartDesc
 	s OrderPrior=""
 	s OrderPriorRowid=$p($g(^OEORD(OrderId,"I",sub,1)),"^",8)
 	i OrderPriorRowid'="" s OrderPrior=$p(^OECPR(OrderPriorRowid),"^",2)
 	s OrderSttDate=$p($g(^OEORD(OrderId,"I",sub,1)),"^",9)
 	i OrderSttDate'="" s OrderSttDate=$zd(OrderSttDate,3)
 	s OrderSttTime=$p($g(^OEORD(OrderId,"I",sub,1)),"^",10)
 	i OrderSttTime'="" s OrderSttTime=..%ZT(OrderSttTime,1)
 	
 	s OrderDoseQty=$p($g(^OEORD(OrderId,"I",sub,2)),"^",1)
 	S OrderDoseUOM=""
 	S OrderFreq="",OrderFreqFactor="",OrderFreqInterval=""
 	S OrderDur="",OrderDurFactor=""
 	s OrderDoseUOMRowid=$p($g(^OEORD(OrderId,"I",sub,2)),"^",3)
 	i OrderDoseUOMRowid'="" D
 	.s OrderDoseUOM=$p(^CT("UOM",OrderDoseUOMRowid),"^",2)
 	s OrderFreqRowid=$p($g(^OEORD(OrderId,"I",sub,2)),"^",4)
 	i OrderFreqRowid'="" d
 	.s OrderFreq=$p($g(^PHCFR(OrderFreqRowid)),"^",4)
 	.s OrderFreqFactor=$p($g(^PHCFR(OrderFreqRowid)),"^",2)
 	.s OrderFreqInterval=$p($g(^PHCFR(OrderFreqRowid)),"^",9)
 	s OrderInstr=""
 	s OrderInstrRowid=$p($g(^OEORD(OrderId,"I",sub,2)),"^",7)
 	i OrderInstrRowid'="" s OrderInstr=$p(^PHCIN(OrderInstrRowid),"^",2)
 	s OrderDurRowid=$p($g(^OEORD(OrderId,"I",sub,2)),"^",6)
 	i OrderDurRowid'="" D
 	.s OrderDur=$p(^PHCDU(OrderDurRowid),"^",3)
 	.s OrderDurFactor=$p(^PHCDU(OrderDurRowid),"^",2)
 	s OrderPackQty=$p($g(^OEORD(OrderId,"I",sub,9)),"^",4)
	s OrderPackUOM=""
    s OrderPackUOMRowid=$p(^ARCIM(Subscript,Version,8),"^",14)
    i OrderPackUOMRowid'="" s OrderPackUOM=$p(^CT("UOM",OrderPackUOMRowid),"^",2)
 	s OrderBillTypeRowid=$p($g(^OEORD(OrderId,"I",sub,11)),"^",18)
 	s OrderRecDepRowid=$p($g(^OEORD(OrderId,"I",sub,3)),"^",6)
 	s retPrice=##class(web.DHCDocOrderCommon).GetOrderPrice("", OrderBillTypeRowid, ARCIMRowid, OrderSttDate, OrderPriorRowid, OrderInstrRowid, "", "",OrderRecDepRowid)
	s OrderPrice=$P(retPrice,"^",1)
	s OrderSum=OrderPackQty*OrderPrice
	i OrderBillTypeRowid="" s OrderBillType="自费"
	e  s OrderBillType=$P(^PAC("ADMREA",OrderBillTypeRowid),"^",2)
	s OrderDoseQty=$TR(OrderDoseQty," ","")
	s OrderType=""
	s ItemCatDR=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",10)
	i ItemCatDR'="" s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)
	i OrderType'="R" d
	. s DoseqtySum=$p($g(^OEORD(OrderId,"I",sub,1)),"^",12)
	. s OrderPackQty=DoseqtySum
	s OrderPackUOM=$p(OrderPackUOM,"(",1)
	s OrderSum=OrderPackQty*OrderPrice
	
 	s ItemCatDR=$p(^ARCIM(Subscript,Version,1),"^",10)
 	s RecHospDr=$p($G(^CTLOC(+OrderRecDepRowid)),"^",22)
	s PHPrescType=##class(web.DHCDocOrderCommon).GetPHPrescType(ItemCatDR,RecHospDr,ARCIMRowid)
	;Q:(PHPrescType=3) ""
	s OrderSkinTest=$p($g(^OEORD(OrderId,"I",sub,5)),"^",2)
	s OrderRecDep=""
	i OrderRecDepRowid'="" s OrderRecDep=$p(^CTLOC(OrderRecDepRowid),"^",2)
	s OrderUserDep=""
	s OrderUserDepRowid=$p($g(^OEORD(OrderId,"I",sub,7)),"^",2)
	i OrderUserDepRowid'="" s OrderUserDep=$p(^CTLOC(OrderUserDepRowid),"^",2)
	s OrderPrescNo=$p($g(^OEORD(OrderId,"I",sub,1)),"^",14)
	s OrderDepProcNote=$g(^OEORD(OrderId,"I",sub,"DEP",1))
	s OrderDoc=""
	s OrderDocRowid=$p($g(^OEORD(OrderId,"I",sub,1)),"^",11)
	i OrderDocRowid'="" s OrderDoc=$p($g(^CTPCP(OrderDocRowid,1)),"^",2)
	s OrderUserAdd=""
	s OrderUserAddRowid=$p($g(^OEORD(OrderId,"I",sub,7)),"^",1)
	i OrderUserAddRowid'="" s OrderUserAdd=$p($g(^SSU("SSUSR",OrderUserAddRowid)),"^",2)
	s OrderDate=$p($g(^OEORD(OrderId,"I",sub,3)),"^",7)
	i OrderDate'="" s OrderDate=$zd(OrderDate,3)
	s OrderSeqNo=$p($g(^OEORD(OrderId,"I",sub,3)),"^",4)
	s OrderMasterSeqNo=$p($g(^OEORD(OrderId,"I",sub,2)),"^",2)
	s OrderLabEpisodeNo=$p($g(^OEORD(OrderId,"I",sub,3)),"^",20)
	s OrderOrdDepRowid=$p($g(^OEORD(OrderId,"I",sub,1)),"^",3)
	s OrderBaseUOMRowid=""
	s OrderARCOSRowid=$p($g(^OEORD(OrderId,"I",sub,3)),"^",10)
	s OrderDrugFormRowid=##class(web.DHCDocOrderEntry).GetDrgForm(ARCIMRowid)
	;,,OrderItemInValid,TypeClass
	s OrderMaxDurRowid=""
	s LinkOrderItem=$p($g(^OEORD(OrderId,"I",sub,11)),"^",39)
	s OrderItemInValid=##Class(web.DHCDocOrderEntry).ValARCItem(ARCIMRowid)
	s ArcService=""
	s ArcService=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),7)),"^",6)
	s TypeClass=""
	i OrderType="R" d
	.i PHPrescType="3" s TypeClass="草药"
	.e  s TypeClass="西药"
	e  i OrderType="L" s TypeClass="检验"
	e  i $g(ArcService)="S" s TypeClass="检查"
	e  s TypeClass="其他"
	
	s ordremark=##class(web.DHCOutPhCommon).GetOrdRemark(OrderId_"||"_sub)
	s skintestremark=##class(web.DHCSTPCHCOLLS2).SkinTest2(OrderId_"||"_sub)
    s:skintestremark'="" ordremark=skintestremark_" "_ordremark
    s seqno=seqno+1
	d QryOeoriCommonOutput
	Q 
QryOeoriCommonOutput
	set Data=$lb(seqno,OrderName,OrderStatus,OrderPrior,OrderSttDate,OrderSttTime,OrderDoseQty,OrderDoseUOM,OrderFreq,OrderInstr,OrderDur,OrderPrice,OrderPackQty,OrderPackUOM,OrderSkinTest,OrderRecDep,OrderUserDep,OrderOrdDep,OrderSum,OrderPrescNo,OrderDepProcNote,OrderDoc,OrderUserAdd,OrderDate,OrderSeqNo,OrderMasterSeqNo,OrderLinkTo,OrderLabEpisodeNo,OrderItemRowid,ARCIMRowid,OrderDoseUOMRowid,OrderFreqRowid,OrderPriorRowid,OrderInstrRowid,OrderDurRowid,OrderPackUOMRowid,OrderRecDepRowid,OrderUserDepRowid,OrderOrdDepRowid,OrderStatusRowid,OrderBaseUOMRowid,OrderDocRowid,OrderUserAddRowid,OrderARCOSRowid,OrderDrugFormRowid,OrderMaxDurRowid,OrderType,OrderBillTypeRowid,OrderBillType,OrderFreqFactor,OrderFreqInterval,OrderDurFactor,LinkOrderItem,EpisodeID,OrderBillTypeRowid,OrderItemInValid,ordremark,skintestremark,TypeClass,CHMEDNotes)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod QryOeoriCommonFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOeoriCommonExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QryOeoriCommonClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOeoriCommonExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:      宋春莉
/// CreatDate:    2019.12.31
/// Description:  获取本次就诊"穿刺"医嘱信息
/// Table:        
/// Input:        PAADMRowid:就诊表RowId
/// Return:       RetOrderStr:医嘱名称^医嘱ID*医嘱名称^医嘱ID
/// Others:       w ##class(DHCDoc.Interface.Inside.ServiceOrd).GetPunctureOrdStr(1)
ClassMethod GetPunctureOrdStr(PAADMRowid)
{
	s OrderStr="",RetOrderStr=""
	s OrderRowid=##Class(web.DHCDocOrderEntry).GetPAADMOrderRowid(PAADMRowid)
	Q:OrderRowid="" 0
	;循环取出医嘱
	s itemsub=0 
	f  {
		s itemsub=$o(^OEORD(OrderRowid,"I",itemsub)) 
		q:(itemsub="")  
		;如果医嘱未核实则为退出
		s itemstat=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",13)
		i itemstat'="" s statcode=$p($g(^OEC("OSTAT",itemstat)),"^",1)
		;trakcare先开的医嘱是inactive
		continue:($g(statcode)'="V")&&($g(statcode)'="E")
	    s ItmMastrowid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)  //获取医嘱项ID
	    s ARCIMDesc=$p($g(^ARCIM(+ItmMastrowid,$p(ItmMastrowid,"||",2),1)),"^",2)
	    i ARCIMDesc["穿刺" s OrderStr=ARCIMDesc_"^"_OrderRowid_"||"_itemsub
	    i RetOrderStr="" {
		    s RetOrderStr=OrderStr
	    }else{
		    s RetOrderStr=RetOrderStr_"*"_OrderStr
	    }
	}
    q RetOrderStr
}

/// Creator:      宋春莉
/// CreatDate:    2020.03.23
/// Description:  根据处方号返回煎药费对应的医嘱id串接口(供煎药管理中会统计草药处方的煎药费用信息)
/// Input:PrescNo 处方号
/// OutPut: 医嘱ID串，多个医嘱ID以^分割
ClassMethod GetCMCookModeLinkOrdStr(PrescNo As %String) As %String
{
	s rtn=""
	Q:PrescNo="" ""
	s QUERowID=$o(^PAQUE1(0,"PrescNo",PrescNo,""))
	Q:QUERowID="" ""
	s AdmId=$p(^PAQUE1(QUERowID),"^",3)
	s OEOrdRowID=+$o(^OEORD(0,"Adm",+AdmId,0))
	Q:OEOrdRowID="" ""
	s LinkOrderItemDR=$p($g(^PAQUE1(QUERowID,"DHC")),"^",34)
	Q:LinkOrderItemDR="" ""
	s Childsub=0
	for {
		s Childsub=$o(^OEORDi(0,"OEORI",OEOrdRowID,LinkOrderItemDR,Childsub)) Q:Childsub=""
		s statcode=""
		s Stat=$P($G(^OEORD(+OEOrdRowID,"I",Childsub,1)),"^",13)
		s:Stat'="" statcode=$p($g(^OEC("OSTAT",Stat)),"^",1)
		continue:(statcode'="V")&&(statcode'="E")&&(statcode'="")
		s OEORIBindSource=$p($g(^OEORD(OEOrdRowID,"I",Childsub,"DHC")),"^",41)
		if (OEORIBindSource="CMCMAO")||(OEORIBindSource="CMPTCMA") {
			if rtn="" s rtn=OEOrdRowID_"||"_Childsub
			else  s rtn=rtn_"^"_OEOrdRowID_"||"_Childsub
		}
	}
	Q rtn
}

/// Creator:      宋春莉
/// CreatDate:    2020.03.23
/// Description:  更新医嘱状态,并插入医嘱状态变化表
/// Input:        OrdItmRowId:医嘱Rowid,UserRowId:用户指针
/// OutPut:		  Err:程序执行返回值代码,标识成功与否
ClassMethod UpdateStatus(OrdItmRowId As %String, UserRowId As %String, StatusRowId As %String, ReasonDr As %String = "", ReasonDesc As %String = "") As %String
{
	Q ##class(appcom.OEOrdItem).UpdateStatus(OrdItmRowId,UserRowId,StatusRowId,ReasonDr,ReasonDesc)
}

/// Creator:      谭吉善
/// CreatDate:    2020.09.14
/// Description:  判断皮试阳性时是否自动插入过敏记录
/// Input:        OrdItmRowId:医嘱Rowid
/// OutPut:		  Y:阳性时需要插入过敏记录,N:不需要插入过敏记录
ClassMethod GetAutoInsertAllergiesFlag(OrdItmRowId As %String) As %String
{
	Q ##class(web.DHCOEOrderGuideAllergy).GetAutoInsertAllergiesFlag(OrdItmRowId)
}

/// Creator:      宋春莉
/// CreatDate:    2019.06.19
/// 2020.11.12 迁移至该位置，之前在DHCDoc.Interface.Inside.ServiceOrd.cls文件下
/// Description:  根据医嘱ID获取同频次不同剂量串
/// Table:        
/// Input:       
/// Return:      OEORIRowId 医嘱ID;SearchDate 需要展示的日期,系统日期
/// Others:      w ##class(DHCDoc.Interface.Inside.ServiceOrd).GetOrdDoseQty("3||33")
ClassMethod GetOrdDoseQty(OEORIRowId As %String, SearchDate As %String = "") As %String
{
	s DoseQty=$p($g(^OEORD(+OEORIRowId,"I",$P(OEORIRowId,"||",2),2)),"^",1)
	s FreqDispTimeDoseQtyStr=$P($G(^OEORD(+OEORIRowId,"I",$P(OEORIRowId,"||",2),"DHC")),"^",59)
	if (FreqDispTimeDoseQtyStr=""){
		q DoseQty
	}
	s OutPriorRowId=$O(^OECPR(0,"Code","OUT",0))
	s OnePriorRowId=$O(^OECPR(0,"Code","ONE",0))
	s PriorityDR=$p($g(^OEORD(+OEORIRowId,"I",$P(OEORIRowId,"||",2),1)),"^",8)
	i PriorityDR="" q DoseQty
	s PAADMRowid=$p(^OEORD(+OEORIRowId),"^",1)
	s PAAdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(PAADMRowid)
	if (PriorityDR'=OutPriorRowId)&&(PriorityDR'=OnePriorRowId)&&(PAAdmType="I") {
		i SearchDate="" s SearchDate=..%SysDate()
		s DoseQty = $p($g(^OEORD(+OEORIRowId,"I",$p(OEORIRowId,"||",2),2)),"^",1)
		if (##Class(web.DHCOEOrdItemDoseQty).HasDoseQtyRecord(OEORIRowId)=""){
			q DoseQty
		}
	  	if ('##class(appcom.OEOrdItem).ISLongOrderPrior(PriorityDR)){
			q DoseQty 
		}
		s OrderFreqTimeDoseStr=##Class(web.DHCOEOrdItemDoseQty).GetFreqTimeDoseStr(OEORIRowId,SearchDate)
		if (OrderFreqTimeDoseStr=""){
			q DoseQty
		}
	}else{
		s OrderFreqTimeDoseStr=FreqDispTimeDoseQtyStr
	}

	s DoseQtyStr=""
	s DoseQtyStrLen=$l(OrderFreqTimeDoseStr,"@")
	for i=1:1:DoseQtyStrLen{
		s OneFreqTimeDoseStr=$P(OrderFreqTimeDoseStr,"@",i)
		continue:OneFreqTimeDoseStr=""
		s DoseQty=""
		for j=1:1:$L(OneFreqTimeDoseStr,"!"){
			s OrderDoseQtyStr=$p(OneFreqTimeDoseStr,"!",j)
			s OrderDoseQty=$p(OrderDoseQtyStr,"$",2)
			continue:OrderDoseQty=""
			if (DoseQty="") s DoseQty=OrderDoseQty
			else  s DoseQty=DoseQty_"-"_OrderDoseQty
		} 
		continue:DoseQty=""
		i DoseQtyStr="" s DoseQtyStr=DoseQty
		e  s DoseQtyStr=DoseQtyStr_"|"_DoseQty
	}
	Q DoseQtyStr
}

/// Creator:      谭吉善
/// CreatDate:    2020.11.06
/// Description:  获取频次的描述信息,因周频次、不规则分发时间频次的描述需要根据医嘱信息拼接，故按此方法批量获取
/// Input:        OrdItmRowId:医嘱Rowid,
/// 				Spec:频次描述的默认分隔符,
/// 				LangId:翻译ID，若有值则进行描述翻译,
/// 				ExecDate:隔小时\分钟医嘱，需要按具体的日期计算执行记录分发时间，与描述信息无关
/// OutPut:		  $LB(频次ID,频次描述,频次系数,分发时间结构信息,频次代码,中文频次描述)
/// Others:       w $LISTTOSTRING(##class(DHCDoc.Interface.Inside.ServiceOrd).GetOrdFreqInfo("93||586"),"^")
/// Others:       
ClassMethod GetOrdFreqInfo(OrdItmRowId As %String, Spec As %String = " ", LangId As %String = "", ExecDate As %String = "") As %String
{
	if LangId="" s LangId=..%LanguageID()
	s OrderID=$P(OrdItmRowId,"||",1)
	s SubID=$P(OrdItmRowId,"||",2)
	s OrderFreqRowid="",OrderFreq="",OrderFreqFactory=1,OrderFreqDispTimeStr="",OrderFreqCode="",OrderFreqDesc="",IntervalTimeFlag="N"
	s OrderFreqRowid=$P($G(^OEORD(OrderID,"I",SubID,2)),"^",4) ; OEORI_PHFreq_DR
	if (OrderFreqRowid=""){
		q $LB(OrderFreqRowid,OrderFreq,OrderFreqFactory,OrderFreqDispTimeStr,OrderFreqCode,OrderFreqDesc,IntervalTimeFlag)
	}
	s SttDate=$P($G(^OEORD(OrderID,"I",SubID,1)),"^",9)
	s SttTime=$P($G(^OEORD(OrderID,"I",SubID,1)),"^",10)
	s ExecDate=..%ZDH(ExecDate)
	i ExecDate<=SttDate s ExecDate=SttDate
	s OrderFreqCode=$P(^PHCFR(OrderFreqRowid),"^",1)
	s OrderFreq=$P(^PHCFR(OrderFreqRowid),"^",3)
	s OrderFreqDesc=$P(^PHCFR(OrderFreqRowid),"^",4)
	s:(LangId'="") OrderFreqCode=##class(User.PHCFreq).GetTranByDesc("PHCFRCode",OrderFreqCode,LangId)
	s:(LangId'="") OrderFreq=##class(User.PHCFreq).GetTranByDesc("PHCFRDesc1",OrderFreq,LangId)
	s:(LangId'="") OrderFreqDesc=##class(User.PHCFreq).GetTranByDesc("PHCFRDesc2",OrderFreqDesc,LangId)
	s FreeTimeFreqFlag=$P(^PHCFR(OrderFreqRowid),"^",13)
	s WeekFlag=$P(^PHCFR(OrderFreqRowid),"^",9)
	i (WeekFlag="Y")||(FreeTimeFreqFlag="Y") {
		s OrderFreqWeek=$p($g(^OEORD(OrderID,"I",SubID,"DHC")),"^",55)
		s OrderFreqFreeTimeStr=$p($g(^OEORD(OrderID,"I",SubID,"DHC")),"^",68)
		s OrderFreqDispTimeStr=##Class(web.DHCOEOrdItem).GetOrderFreqDispTimeStr(OrderFreqRowid,OrderFreqWeek,OrderFreqFreeTimeStr)
		//理论上不允许出现为空的情况
		if (OrderFreqDispTimeStr'=""){
			s OrderFreqOtherInfo=##Class(web.DHCOEOrdItem).GetOrderFreqOtherInfo(OrderFreqRowid,OrderFreqDispTimeStr)
			s OrderFreqCode=OrderFreqCode_Spec_OrderFreqOtherInfo
			s OrderFreq=OrderFreq_Spec_OrderFreqOtherInfo
			s OrderFreqDesc=OrderFreqDesc_Spec_OrderFreqOtherInfo
		}
	}
	s IntervalTime=$p(^PHCFR(OrderFreqRowid),"^",5) ;频次间隔时间
	s IntervalUnit=$P(^PHCFR(OrderFreqRowid),"^",14)	;间隔单位
	s:IntervalUnit="" IntervalUnit="D"
	if (IntervalTime>0)&&((IntervalUnit'="D")||((IntervalUnit="D")&&'$O(^PHCFR(OrderFreqRowid,"DT",0)))){
		s IntervalTimeFlag="Y"
		s DuratFactor=+ExecDate-SttDate+1
		i DuratFactor<=0 s DuratFactor=1
		;长期医嘱固定间隔按0开始
		s ExSttTime=$CASE(##class(DHCDoc.Order.Common).IsLongOrdItem(OrdItmRowId),1:0,:SttTime)
		d ##class(DHCDoc.Order.Exec).GetIntervalDTList(SttDate,ExSttTime,IntervalTime,IntervalUnit,DuratFactor,.ExecList)
		s OrderFreqFactory=+$G(ExecList)
		//获取分发时间信息
		k FreqDispTimeArr
		s LoopDate=ExecDate-1
		for {
			s LoopDate=$O(ExecList(LoopDate))
			q:(LoopDate="")||(LoopDate>ExecDate)
			s LoopTime=""
			for {
				s LoopTime=$O(ExecList(LoopDate,LoopTime))
				q:(LoopTime="")
				s FreqDispTimeArr(LoopTime)=""
			}
		}
		s LoopTime=""
		for {
			s LoopTime=$O(FreqDispTimeArr(LoopTime))
			q:(LoopTime="")
			if (OrderFreqDispTimeStr=""){
				s OrderFreqDispTimeStr=$ZT(LoopTime)
			}else{
				s OrderFreqDispTimeStr=OrderFreqDispTimeStr_$C(1)_$ZT(LoopTime)
			}
		}
	}elseif (FreeTimeFreqFlag="Y"){
		s OrderFreqFactory=$length(OrderFreqDispTimeStr,$C(1))
	}else{
		s OrderFreqFactory=$P(^PHCFR(OrderFreqRowid),"^",2)
	}
	q $LB(OrderFreqRowid,OrderFreq,OrderFreqFactory,OrderFreqDispTimeStr,OrderFreqCode,OrderFreqDesc,IntervalTimeFlag)
}

/// Creator:      彭军
/// CreatDate:    2021.05.4
/// Description:  通过处方号判断处方模板
/// Input:        OrdItmRowId:医嘱Rowid
/// OutPut:		  处方信息满足处方打印格式与科室对照返回处方格式ID 不满足返回空默认处方格式 
/// Others:       w ##class(DHCDoc.Interface.Inside.ServiceOrd).GetPrescriptPrintConfig("E210301000019")
ClassMethod GetPrescriptPrintConfig(prescno As %String) As %String
{
	q:prescno="" ""
	s OEORDRowId=$o(^OEORD(0,"PrescNo",prescno,"")) 
	q:OEORDRowId="" ""
	s OEORIChildsub=$o(^OEORD(0,"PrescNo",prescno,OEORDRowId,""))
	q:OEORIChildsub="" ""
	q:'$d(^OEORD(OEORDRowId,"I",OEORIChildsub)) ""
	s OEORIOrdDeptDR=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",3)
	q:OEORIOrdDeptDR="" ""
	s PrintConfigInfo=$G(^UDHCPrescriptPrintConfig("PrintConfig",OEORIOrdDeptDR))
	b 
	q:PrintConfigInfo="" ""
	s PrintTypeID=$P(PrintConfigInfo,"^",1)
	s PrintAgeForm=$P(PrintConfigInfo,"^",2)
	s PrintAgeTo=$P(PrintConfigInfo,"^",3)
	b //年龄为空则不判断年龄
	q:((PrintAgeForm="")||(PrintAgeTo="")) PrintTypeID
	s EpisodeID=+^OEORD(OEORDRowId)
	q:EpisodeID=0 ""
	s PatientID=$P($G(^PAADM(EpisodeID)),"^",1)
	q:PatientID="" ""
	s AgeY=+##class(web.DHCBillInterface).GetPapmiAge(PatientID,EpisodeID,"","")
	b ;
	q:((PrintAgeForm<=AgeY)&&(PrintAgeTo>=AgeY)) PrintTypeID
	q ""
}

/// Creator:      李旭
/// CreatDate:    2022.01.11
/// Description:  为电子病例组提供本次呼吸机使用天数接口
/// Input:        AdmID:就诊表RowId、ArcimID:医嘱项ID、IsLong:是否只计算长嘱
/// Return:       -1/0^失败原因/医嘱使用天数
/// Others:       w ##class(DHCDoc.Interface.Inside.ServiceOrd).GetVentilatorOrdInfo(195,"5502||1")
ClassMethod GetVentilatorOrdInfo(AdmID, ArcimID, IsLong = "Y")
{
	q:(AdmID="")||(ArcimID="") "-1^缺少必填参数"
	s OrdID=$o(^OEORD(0,"Adm",AdmID,""))
	q:OrdID="" "-1^就诊无对应医嘱记录"
	
	s (DiffDateSum,StDate)=0
	for {
		s StDate=$o(^OEORDi(0,"ARCIM",OrdID,ArcimID,StDate)) 
		q:StDate="" 
		s Sub=0
		for {
			s Sub=$o(^OEORDi(0,"ARCIM",OrdID,ArcimID,StDate,Sub)) 
			q:(Sub="")  
			s OrdInfo1=$g(^OEORD(OrdID,"I",Sub,1))
			s StatCode=""
			s ItemStatID=$p(OrdInfo1,"^",13)
			i ItemStatID'="" s StatCode=$p($g(^OEC("OSTAT",ItemStatID)),"^",1)
			continue:(StatCode'="V")&&(StatCode'="E")&&(StatCode'="D")
			s PriorityID=$p(OrdInfo1,"^",8)
			s ISLongOrderPrior=##class(appcom.OEOrdItem).ISLongOrderPrior(PriorityID)
			q:(IsLong="Y")&&(ISLongOrderPrior'=1)
			s SttDate=$p(OrdInfo1,"^",9)							;医嘱开始日期
			s SttTime=$p(OrdInfo1,"^",10)							;医嘱开始时间
			s XDate=$p($g(^OEORD(OrdID,"I",Sub,3)),"^",34)			;停止日期
			s XTime=$p($g(^OEORD(OrdID,"I",Sub,2)),"^",15)			;停止时间
			i (ISLongOrderPrior=1)&&(XDate="") d
			.s XDate=+$h
			.s XTime=$p($h,",",2)
			
			s DiffDate=+$SYSTEM.SQL.DATEDIFF("dd", SttDate, XDate)	;相隔天数
			s DiffDate=DiffDate+1		;天数向上取值
			s DiffDateSum=DiffDateSum+DiffDate
		}
	}
	q "0^"_DiffDateSum
}

/// 
/// description:根据病人ID、处方号获取医嘱录入填写的代办人信息
/// OutPut:   患者身份证号、代办人姓名、代办人身份证号、代办人联系电话
/// w ##class(DHCDoc.Interface.Inside.ServiceOrd).GetSupplyMethod("")
ClassMethod GetSupplyMethod(EpisodeID As %String, OrderPrescNo As %String = "") As %String
{
	s ret=""
	q:EpisodeID="" ret
	s PatientID=$p(^PAADM(EpisodeID),"^",1)
	//s PAPMIDVAnumber=##class(web.DHCDocOrderEntry).FindPAPMIID(PatientID)
	s PAPMIDVAnumber=$p($g(^PAPER(PatientID,"PAT",3)),"^",6)
	s PAPMIDCredTypeDr=$P($G(^PAPER(PatientID,"PAT",3)),"^",7)
	s CredType=""
	if (PAPMIDCredTypeDr'=""){
		s CredType=$p(^PAC("CARD",PAPMIDCredTypeDr),"^",2)
	}
	Set AgencyName=$P($G(^PAADM(EpisodeID,"DHC")),"^",36)
	Set AgencyCredNo=$P($G(^PAADM(EpisodeID,"DHC")),"^",35)
	Set AgencyTel=$P($G(^PAADM(EpisodeID,"DHC")),"^",37)
	Set AgencyCredDr=$P($G(^PAADM(EpisodeID,"DHC")),"^",55)
	//处方号不为空 取处方上的毒麻代办人信息
	s DMFlag=##Class(DHCDoc.OPDoc.TreatPrint).CheckPrescIsDMFlag(OrderPrescNo)
	if (DMFlag=1){
		s QUE1RowID=$O(^PAQUE1(0,"PrescNo",OrderPrescNo,""))
		if (QUE1RowID'=""){
			s AgencyName=$P($G(^PAQUE1(QUE1RowID)),"^",35)
			s AgencyCredNo=$P($G(^PAQUE1(QUE1RowID)),"^",33)
			s AgencyTel=$P($G(^PAQUE1(QUE1RowID)),"^",36)
			s AgencyCredDr=$P($G(^PAQUE1(QUE1RowID)),"^",34)
		}
	}
	s AgencyCredType=""
	if (AgencyCredDr'=""){
		s AgencyCredType=$p(^PAC("CARD",AgencyCredDr),"^",2)
	}
	
	Set ret=PAPMIDVAnumber_"^"_AgencyName_"^"_AgencyCredNo_"^"_AgencyTel_"^"_CredType_"^"_AgencyCredType
	Quit ret
}

/// description:根据医嘱ID获取医嘱是否CA签名
/// OutPut:   1已签名 0未签名
ClassMethod GetCASignFlag(OEORIRowid)
{
	Q ##class(web.DHCDocInPatPortalCommon).CheckOrdSign(OEORIRowid)
}

/// description:病案首页获取护理等级
Query QueryCareLevel(AdmId As %String, CatID As %String = "") As %Query(ROWSPEC = "ArcimID:%String,ArcimDesc:%String,BillQty:%String")
{
}

ClassMethod QueryCareLevelClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryCareLevelExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryCareLevelExecute(ByRef qHandle As %Binary, AdmId As %String, CatID As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.Interface.Inside.Service","QueryCareLevel","87812")
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	if AdmId="" {  
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s Ord=$o(^OEORD(0,"Adm",AdmId,0))
	
	s Sub=0 f {
		s Sub=$o(^OEORD(Ord,"I",Sub))
		q:Sub=""
		s ArcimID=$p(^OEORD(Ord,"I",Sub,1),"^",2)
		continue:ArcimID=""
		s ArcCatID=$p(^ARCIM(+ArcimID,1,1),"^",10)
		continue:((CatID'="")&&(ArcCatID'=CatID))
		s ARCICOrdCatDR=$P(^ARC("IC",ArcCatID),"^",8)
		s OrdCatDesc=$P(^OEC("ORCAT",ARCICOrdCatDR),"^",2)
		s Status=$p(^OEORD(Ord,"I",Sub,1),"^",13)
		s:Status'="" Status=$p(^OEC("OSTAT",Status),"^",1)
		s BillQty=0
		s ExecSub=0 f {
			s ExecSub=$o(^OEORD(Ord,"I",Sub,"X",ExecSub))
			q:ExecSub=""
			s OrdExecBillInfo=##class(web.DHCBillInterface).IGetOrdEexcBillPrice(Ord_"||"_Sub_"||"_ExecSub)
			s ExecBillQty=$j($p(OrdExecBillInfo,"^",2),"",2)
			s BillQty=BillQty+ExecBillQty
		}
		s PackUOM=$p(^OEORD(Ord,"I",Sub,"DHC"),"^",13)
		
		i $d(QueryCareLevel(ArcimID,PackUOM)) {
			s QueryCareLevel(ArcimID,PackUOM)=+$g(QueryCareLevel(ArcimID,PackUOM))+BillQty
		}else {
			s QueryCareLevel(ArcimID,PackUOM)=BillQty
		}
	}
	
	s ItemDr="" f {
		s ItemDr=$o(QueryCareLevel(ItemDr))
		q:ItemDr=""
		s UomDr="" f {
			s UomDr=$o(QueryCareLevel(ItemDr,UomDr))
			q:UomDr=""
			s ItemDesc=$p(^ARCIM(+ItemDr,1,1),"^",2)
			s BillQty=$g(QueryCareLevel(ItemDr,UomDr))
			s BillUom=$p(^CT("UOM",UomDr),"^",2)
			s BillQty=$j(BillQty,"",2)_"*"_BillUom
			s Data=$lb(ItemDr,ItemDesc,BillQty)
			s ^CacheTemp(repid,ind)=Data
			s ind=ind+1
		}
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QueryCareLevelFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryCareLevelExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {				// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 // Save QHandle
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:      王清雍
/// CreatDate:    2023.02.06
/// Description:  获取未使用的转科医嘱ID
/// Input:        EpisodeID:就诊表RowId
/// Return:       医嘱ID
/// Others:       w ##class(DHCDoc.Interface.Inside.ServiceOrd).GetValidTransOrd(3438).%ToJSON()
ClassMethod GetValidTransOrd(EpisodeID) As %DynamicArray
{
	s OrdItemArr=[]
	s Ord=##class(web.DHCDocOrderEntry).GetPAADMOrderRowid(EpisodeID)
	Q:Ord="" OrdItemArr
	s TransType="" for{
		s TransType=$O(^OEORDi(0,"TransType",Ord,TransType)) Q:TransType=""
		s Sub=0 for{
			s Sub=$O(^OEORDi(0,"TransType",Ord,TransType,Sub)) Q:Sub=""
			s OrderStatus=##class(appcom.OEOrdItem).GetStatusCode(Ord_"||"_Sub)
			continue:(OrderStatus'="V")&&(OrderStatus'="E")
			s TransUseFlag=$P($G(^OEORD(Ord,"I",Sub,"NUR")),"^",18)
			continue:TransUseFlag="Y"	;已使用
			s row={"Type":(TransType),"OrdItemID":(Ord_"||"_Sub)}
			d OrdItemArr.%Push(row)
		}
	}
	Q OrdItemArr
}

/// Creator:      王清雍
/// CreatDate:    2023.04.24
/// Description:  获取医嘱执行数量(根据执行记录)(OEORE_QtyAdmin字段)
/// Input:        医嘱ID
/// Return:       数量
/// Others:       w ##class(DHCDoc.Interface.Inside.ServiceOrd).GetOrdExecQty("1586||682")
ClassMethod GetOrdExecQty(OEORIRowid) As %String
{
	s Ord=+OEORIRowid,Sub=$P(OEORIRowid,"||",2)
	s ArcimID=$P($G(^OEORD(Ord,"I",Sub,1)),"^",2)
	s ReLocId=$p($g(^OEORD(Ord,"I",Sub,3)),"^",6)
	s EpisodeID=$P($G(^OEORD(Ord)),"^",1)
	s HospID=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(EpisodeID)
	if ##class(DHCDoc.DHCDocCure.Apply).CheckItem(ArcimID,ReLocId,HospID){
		Q ##class(DHCDoc.DHCDocCure.OutInterface).GetCureExecQty(OEORIRowid)
	}
	s AdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
	s GenOneExecFlag=##class(DHCDoc.Order.Exec).IsGenOneExecOrdItem(OEORIRowid)
	s ArcimRowid=$P($G(^OEORD(Ord,"I",Sub,1)),"^",2)
	s DoseUomID=$p($g(^OEORD(Ord,"I",Sub,2)),"^",3)
	s drgform=$p($g(^ARCIM(+ArcimRowid,+$p(ArcimRowid,"||",2),1)),"^",12)
	s INCIrow=##class(appcom.OEDispensing).GetINCI(+ArcimRowid)
	s OrderType=##class(web.DHCDocOrderCommon).GetOrderType(ArcimRowid)
	s ExecCount=0
	&SQL(SELECT COUNT(OEORE_RowId) INTO :ExecCount FROM SQLUser.OE_OrdExec WHERE OEORE_OEORI_ParRef=:OEORIRowid)
	s TotalQty=0
	s XSub=0 for{
		s XSub=$O(^OEORD(Ord,"I",Sub,"X",XSub)) Q:XSub=""
		s StatusID=$P(^OEORD(Ord,"I",Sub,"X",XSub),"^",16)
		continue:StatusID=""
		s StatusCode=$P(^OEC("STAT",StatusID),"^",1)
		continue:StatusCode'="F"
		if 'GenOneExecFlag&&(ExecCount'=1){
			s PhQtyOrd=$P(^OEORD(Ord,"I",Sub,"X",XSub),"^",4)
			if (OrderType="R"){
				s QtyAdmin=$$calcqty^DHCOEOrdItem(drgform,DoseUomID,PhQtyOrd,AdmType)
			}elseif INCIrow'="" {
				s convFac=##class(appcom.OEDispensing).convFac(ArcimRowid,DoseUomID)
				s QtyAdmin=PhQtyOrd*convFac
			}else{
				s QtyAdmin=PhQtyOrd
			}
		}else{
			s QtyAdmin=$P(^OEORD(Ord,"I",Sub,"X",XSub),"^",5)
		}
		s TotalQty=TotalQty+QtyAdmin
	}
	Q TotalQty
}

/// Creator:      屈坚
/// CreatDate:    2023.04.24
/// Description:  简易判断录入数量是否正确
/// Input:        入参: Adm:患者ID OrdItem:"医嘱项id^医嘱项类型(药品"R")^医嘱类型id(长期临时)^开始日期^开始时间^数量^价格^接收科室ID^数量单位^虚拟长期标志"
/// Return:       数量
/// Others:       w ##class(DHCDoc.Interface.Inside.ServiceOrd).CheckPackQtyUpdate()
ClassMethod CheckPackQtyUpdate(Adm As %String, OrdItem As %String, NoAdmInfo As %String) As %String
{
	s CurLogonDep=$P(CheckExpStr,"^",1)
	s CurLogonHosp =$p(^CTLOC(CurLogonDep),"^",22)
	s PAADMType=$p($g(^PAADM(Adm)),"^",2)
	s PAADMInsType=$P(^PAADM(Adm,1),"^",7)
	s VisitStatus=$p($g(^PAADM(Adm)),"^",20)
	s ARCIMRowid=$P(OrdItem,"^",1)
	s OrderType=$P(OrdItem,"^",2)
	s PriorRowid=$p(OrdItem,"^",3)
	Set startdate=$p(OrdItem,"^",4)
    Set starttime=$p(OrdItem,"^",5)
	Set PackQty=$p(OrdItem,"^",6)
	Set oeprice=$p(OrdItem,"^",7)
	Set RecDepRowid=$p(OrdItem,"^",8)
	Set OrderPackUOMRowid=$p(OrdItem,"^",9)
	s OrderPackUOM=##Class(web.DHCDocOrderCommon).GetUOMDesc(OrderPackUOMRowid)
	if (OrderType'="R"){
		s PackQty=DoseQtySum
	}
	s AdmDepDr=$p($g(^PAADM(Adm)),"^",4)
	s AdmDepHospId=$p(^CTLOC(AdmDepDr),"^",22)

	s INCIRowid=##class(web.DHCDocOrderEntry).GetINCI(+ARCIMRowid)
	///住院发整包装
    s IPNeedBillQtyFlag=##Class(PHA.FACE.OUT.Com).GetIncilInPhUom(RecDepRowid, INCIRowid).inPhPack
    s IPNeedBillQtyFlag=$CASE(IPNeedBillQtyFlag,"Y":1,:"0")
	;取药和出院带药默认按整包装开
	s CFOutAndOneDefaultPackQty=##Class(PHA.FACE.OUT.Com).GetIncilInPhUom(RecDepRowid, INCIRowid).outPhPack	//取药、出院带药可以发基本单位
    s CFOutAndOneDefaultPackQty=$CASE(CFOutAndOneDefaultPackQty,"":..%GetConfig("OutAndOneDefaultPackQty",AdmDepHospId),"N":1,"Y":0,:1)
	
	s OrderVirtualtLong=$p(OrdItem,"^",11)
	s ItemCatRowid=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",10)
	s OrderName=$p(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1),"^",2)
	s PriorCode=$p($g(^OECPR(PriorRowid)),"^",1)
	s OutInfo="0^^^"
	;出院带药必须录入整包装---该配置已删除
 	//s OutOrderNeedPackQty=..%GetConfig("OutOrderNeedPackQty",CurLogonHosp)
 	;住院是否需要录入整包装数量 
	s IPNeedBillQty=##Class(web.DHCDocOrderCommon).GetARCIMIPNeedBillQty(ARCIMRowid)
	if (OrderNeedPIVAFlag="Y"){
		q "0"
	}
	 ;医生站设置-药房设置-临时医嘱拆分整包装发药(仅在急诊留观押金的虚拟长期模式下有效)
    s NormSplitPackQty=##Class(web.DHCDocOrderVirtualLong).GetNormSplitPackQtyFlag(Adm,RecDepRowid,ItemCatRowid)
	s CheckValue = "^(?!(0[0-9]{0,}$))[0-9]{1,}[.]{0,}[0-9]{0,}$"
	//('$MATCH(OrderDoseQty,CheckValue)
	;可以录入小数的子类
	s AllowEntryDecimalItemCat=##Class(web.DHCDocOrderCommon).GetAllowEntryDecimalItemCat(Adm,CurLogonHosp)
	if ("^"_AllowEntryDecimalItemCat_"^")'[("^"_ItemCatRowid_"^"){
		if (PackQty'="")&&((PackQty=0)||((PackQty#1)>0)){
			q "-1^" _OrderName _"的数量不是有效数字,请检查"

		}
		if (OrderType'="R"){
			//医嘱项扩展设定->检查检验不控制数量
			s NotLimitQty=##class(web.DHCOEOrdItem).GetItemNotLimitQtyFlag(ARCIMRowid)
			if ((OrderType = "L") && (PackQty'= 1)&&(NotLimitQty'="Y")) {
				q "-1^" _OrderName _" 检验医嘱数量只能为1,请确认."
			}
			; 得到是否是或者有检查医嘱标识
 			s ItemServiceFlag=##Class(web.DHCDocOrderCommon).GetItemServiceFlag(ARCIMRowid)
 			if (ItemServiceFlag=1)&&(PackQty'=1)&&(NotLimitQty'="Y"){
	 			q "-1^" _OrderName _" 检查医嘱数量只能为1,请确认."
	 		}
		}
	}
	if (PackQty'="")&&((+PackQty<=0)||('$MATCH(PackQty,CheckValue))){
		q "-1^" _OrderName _"的数量不是有效数字,请检查"

	}
	if (PAADMType="I"){
		if (+PackQty=0){
			if ((PriorCode="OUT")||(PriorCode="ONE")){
				if (CFOutAndOneDefaultPackQty="1"){
					q "-1^" _OrderName _"没有录入整数量"
				}
			}elseif (PriorCode'["OM"){
					if ((IPNeedBillQty="Y")||(IPNeedBillQtyFlag = "1"))
						&&('##class(appcom.OEOrdItem).ISLongOrderPrior(PriorRowid)){
					q "-1^" _OrderName _"没有录入整数量"	
				}	
			}

			if (VisitStatus="P"){
				q "-1^" _OrderName _"没有录入整数量"
			}
		}
	}else{
		 if (+PackQty = 0)&&(NormSplitPackQty'=1)&&(PriorCode'["OM")&&(OrderVirtualtLong'="Y") {
            q "-1^" _OrderName _"没有录入整数量"

        }
	}
	//控制医嘱数量不能超过1000,避免录入错误导致不能账单的问题
	s NotLimitQty=##class(web.DHCOEOrdItem).GetItemNotLimitQtyFlag(ARCIMRowid)
    if (PackQty > 9999)&&(NotLimitQty'="Y") {
        q "-1^" _OrderName _"医嘱数量不能超过9999。请修改！"
		s $P(OutInfo,"^",4)="OrderPackQty"
		q OutInfo
    }
	q OutInfo
}

}
