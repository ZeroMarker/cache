Class web.DHCDocInPatPortalCommon Extends (DHCDoc.Util.RegisteredObject, %Library.DynamicAbstractObject)
{

/// @param: papmi 	 	病人rowid
/// @param: adm   		病人就诊表rowid
/// @param: doctor 		开医嘱医生
/// @param: scopeId 	1 全部   非作废, 
/// 					2 作废   为不打印的医嘱U 
/// 					3 当前   为所有未停医嘱和停止时间迟于当前系统时间的医嘱 
/// 					4 待审核 I未激活 
///                     5 已停止 6 今日有效 7 三日有效 8 待处理 9已处理
/// @param: stloc 		开出科室 1:当前登录科室与病区;2:其它科室;3：全部科室;S^SpecifyLocId:指定登录科室与病区
/// @param: nursebill  	医嘱单类型  "ALL" 全部 		"N" 医嘱单
/// @param:inputOrderDesc 医嘱模糊查询条件
/// @param:PriorType 医嘱类型 
/// @param:CatType 医嘱分类
/// @param:SortType 时间排序方式 默认时间正序排列
/// @param:OrderPriorType 全部 临时医嘱 长期医嘱
/// d ##class(%ResultSet).RunQuery("web.DHCDocInPatPortalCommon","FindInPatOrder","267","552","0","3","1","ALL","","ALL","S","DT","","","","","2022-07-20^2022-07-20","^","","")
Query FindInPatOrder(papmi, adm, doctor, scope, stloc, nursebill, inputOrderDesc = "", PriorType = "", CatType = "", SortType = "", OrderPriorType = "", InstrID = "", FreqID = "", focusOrdList = "", OrderStartDate = "", OrderEndDate = "", OrderInsertStartDateStr = "", OrderInsertEndDateStr = "") As websys.Query(ROWSPEC = "OrderId:%String,TItemStatCode:%String:,TOeoriOeori:%String,TStDate:%String,TOrderDesc:%String:医嘱,TDoctor:%String:开医嘱人,TStopDate:%String:停止时间,TStopDoctor:%String:停止医生,TStopNurse:%String:停止处理护士,TdeptDesc:%String:开单科室,TRecDepDesc:%String:接收科室,TOeoriRowid:%String:医嘱id,GroupSign:%String:组符号,OrderType:%String:医嘱子类类型,Priority:%String:医嘱类型,TItemStatDesc:%String:状态,ColorFlag:%String,TBillUom:%String:计价单位,TStDateHide:%String,StopPermission:%String,CancelPermission:%String,UnusePermission:%String,TPriorityCode:%String,TPHFreqCode:%String,TOEORIAddDate:%String:开医嘱日期,TOEORISeeInfo:%String:护士处理状态,AddNotePermission:%String,TOrderName:%String,DoseQtyInfo:%String,InstrDesc:%String,FreqDesc:%String,TDuratDesc:%String,SumQty:%String,OrderViewFlag:%String,PopoverHtml:%String,ZSQUrl:%String,NurseLinkOrderRowId:%String,IsCNMedItem:%String,CoverMainIns:%String:医保,SignFlag:%String:CA签名,InsuNationCode:%String:国家医保编码,InsuNationName:%String:国家医保名称,OriginaName:%String:医嘱项名称,ItmMastDR:%String,OrdSerialNum:%String:医嘱流水号,OrdSpecDiagnosForm:%String:专科表单,OrdSpecLocDiagCatCode:%String:专科表单代码,BindSourceDesc:%String:绑定来源")
{
}

ClassMethod FindInPatOrderExecute(ByRef qHandle As %Binary, papmi, adm, doctor = 0, scope = 1, stloc = 1, nursebill = "ALL", inputOrderDesc = "", PriorType = "ALL", CatType = "", SortType = "", OrderPriorType = "", InstrID = "", FreqID = "", focusOrdList = "", OrderStartDate = "", OrderEndDate = "", OrderInsertStartDateStr = "", OrderInsertEndDateStr = "") As %Status
{
	/*s papmi="194"
	s adm="239"
	s doctor="全部"
	s scope="3"
	s stloc="1"
	s nursebill="ALL"
	s inputOrderDesc=""
	s PriorType="ALL"
	s CatType="ALL"
	s SortType="AT"
	s OrderPriorType=""*/
	//s ^tempscl("inputOrderDesc",inputOrderDesc)=inputOrderDesc
	s ^tmptan("FindInPatOrder")=$LB(papmi,adm,doctor,scope,stloc,nursebill,inputOrderDesc,PriorType,CatType,SortType,OrderPriorType,InstrID,FreqID,focusOrdList,OrderStartDate,OrderEndDate,OrderInsertStartDateStr,OrderInsertEndDateStr)
	set repid = $I(^CacheTemp)
	if $g(ind) = "" set ind = 0
	s SessionStr=..%SessionStr()
	//s SessionStr="18885^23^8^2^3^20^19959"
	s UserRowId=$P(SessionStr,"^",1)
	s GROUPID=$P(SessionStr,"^",2)
	s sessionLocId=$P(SessionStr,"^",3)
	s currLocId=","_sessionLocId_","
	s sessionHospId=$P(SessionStr,"^",4)
	s CTCPTInternalType=##class(web.DHCDocMain).GetCarePrvTpByUserID(UserRowId)
	s isNurse=(CTCPTInternalType="NURSE")
	if SortType="DT"{
		Set SortByTime=1
	}else{
		Set SortByTime=0	
	}
	s UserIDGrp=UserRowId_"Z"_GROUPID
	//隐藏自动绑定医嘱(仅住院有效)
	s IPHiddenAutoOrd=##class(web.DHCDocConfig).GetUserPageSetting("InPatOrderView","obj",UserRowId,GROUPID).IPHiddenAutoOrd
	//表示当前是产房
	s deliveryRommID=##class(Nur.IP.Delivery).getDeliveryRoomID(adm)
	s ifDeliveryRoom=0
	s:deliveryRommID=sessionLocId ifDeliveryRoom=1
	//s ^tan("FindInPatOrder",1)=..%ZT(..%SysTime())
	s id=0 f  s id= $o(^CTLOC(sessionLocId,"LINK",0,"Loc",id)) q:id=""  d
	.s currLocId=currLocId_id_","
	s SpecifyLocId=$P(stloc,"^",2)
	if (SpecifyLocId'=""){
		s id=0 f  s id= $o(^CTLOC(SpecifyLocId,"LINK",0,"Loc",id)) q:id=""  d
		.s SpecifyLocId=SpecifyLocId_","_id
		s SpecifyLocId=","_SpecifyLocId_","
	}
	
	k plist
	s subOeoriIndex=0
	i +adm'>0 set qHandle = $lb(0,repid,0) Q $$$OK
	s space = "&nbsp&nbsp",tab = space_space_space_space
	s orderParref=$o(^OEORD(0,"Adm",adm,0))
	i orderParref=""  set qHandle = $lb(0,repid,0) Q $$$OK
		
	s OrdSubCateGoryStr=""
	i CatType["||" s OrdSubCateGoryStr=##class(DHCDoc.DHCDocConfig.SubCatContral).GetOrdSubCateGoryStr(CatType)
	///通过OrderStartDate、OrderEndDate传递日期减速参数
	s (OrdStartSDate,OrdStartEDate,OrdStopSDate,OrdStopEDate)=""
	if OrderStartDate["^"  d
	.s OrdStartSDate=$P(OrderStartDate,"^",1)
	.s OrdStartEDate=$P(OrderStartDate,"^",2)
	.s OrdStartSDate = ..%ZDH(OrdStartSDate), OrdStartEDate=..%ZDH(OrdStartEDate)
	.s OrderStartDate=""
	if OrderEndDate["^" d
	.s OrdStopSDate=$P(OrderEndDate,"^",1)
	.s OrdStopEDate=$P(OrderEndDate,"^",2)
	.s OrdStopSDate = ..%ZDH(OrdStopSDate), OrdStopEDate=..%ZDH(OrdStopEDate)
	.s OrderEndDate=""
	
	s OrderStartDate = ..%ZDH(OrderStartDate), OrderEndDate=..%ZDH(OrderEndDate)
	s (OrderInsertStartDate,OrderInsertStartTime,OrderInsertEndDate,OrderInsertEndTime)=""
	if (OrderInsertStartDateStr'=""){
		s OrderInsertStartDate = $P(OrderInsertStartDateStr," ",1)
		s OrderInsertStartDate = ..%ZDH(OrderInsertStartDate)
		s OrderInsertStartTime = $P(OrderInsertStartDateStr," ",2)
		i OrderInsertStartTime="" s OrderInsertStartTime=0
		s OrderInsertStartTime = ..%ZTH(OrderInsertStartTime)
	}
	if (OrderInsertEndDateStr'=""){
		s OrderInsertEndDate = $P(OrderInsertEndDateStr," ",1)
		s OrderInsertEndDate = ..%ZDH(OrderInsertEndDate)
		s OrderInsertEndTime = $P(OrderInsertEndDateStr," ",2)
		i OrderInsertEndTime="" s OrderInsertEndTime=$ZTH("23:59:59")
		s OrderInsertEndTime = ..%ZTH(OrderInsertEndTime)
	}
	
	if (focusOrdList=""){
		s orderId = 0 f  s orderId = $o(^OEORD(orderParref,"I",orderId)) q:orderId=""  d
		.s (TStDate,TStTime,TOrderDesc,TDoctor,TStopDate,TStopDoctor,str1,TItemStatCode,oeorioeoridr,addUserDR,TStopNurse) = ""
		.q:'$d(^OEORD(orderParref,"I",orderId,1))
		.s str1 = ^OEORD(orderParref,"I",orderId,1)
		.s str3 = ^OEORD(orderParref,"I",orderId,3)
		
		.s OEORIDate=$p(str3,"^",7)
		.q:(OrdStartSDate'="")&&(OrdStartSDate>OEORIDate)
		.q:(OrdStartEDate'="")&&(OrdStartEDate<OEORIDate)
		.s TStopDate = $p(str3,"^",34)
		.q:(OrdStopSDate'="")&&(OrdStopSDate>TStopDate)
		.q:(OrdStopEDate'="")&&(OrdStopEDate<TStopDate)
		.s ordDept = $p($g(^OEORD(orderParref,"I",orderId,7)),"^",2)
		.q:(currLocId'[(","_ordDept_","))&&((stloc=1))		;当前科室或病区
		.q:(currLocId[(","_ordDept_","))&&((stloc=2))		;其它科室
		.//	stloc=3  时										;全部科室
		.q:(SpecifyLocId'="")&&(SpecifyLocId'[(","_ordDept_","))&&(($P(stloc,"^")="S"))		;指定科室或病区
		.s DoctorDr=$p(str1,"^",11)
		.s itemStatDr = $p(str1,"^",13) 		;OEORI_ItemStat_DR ;OEC_OrderStatus
		.q:(+doctor'=0)&&(doctor'=DoctorDr)
		.s PriorityDR = $p(str1,"^",8)
		.s StartDate = $p(str1,"^",9)
		.q:(OrderStartDate'="")&&(OrderStartDate>StartDate)
		.q:(OrderEndDate'="")&&(OrderEndDate<StartDate)
		.s InsertDate = $p(str1,"^",19)
		.s InsertTime = $p(str1,"^",20)
		.q:(OrderInsertStartDate'="")&&((OrderInsertStartDate=InsertDate)&&(OrderInsertStartTime>InsertTime)||(OrderInsertStartDate>InsertDate))
		
		.q:(OrderInsertEndDate'="")&&((OrderInsertEndDate=InsertDate)&&(OrderInsertEndTime<InsertTime)||(OrderInsertEndDate<InsertDate))
		
		
		.s ItmMastDR = $p(str1,"^",2)
		.Q:ItmMastDR=""
		.q:'$d(^ARCIM(+ItmMastDR,$p(ItmMastDR,"||",2)))		
		.q:PriorityDR=""
		.;q:'##class(appcom.OEOrdItem).ISShortOrderPrior(PriorityDR,OrderPriorType)&&(PriorType="OM")
		.q:+ItmMastDR'>0
		.s ItemCatRowid=$p($g(^ARCIM(+ItmMastDR,$p(ItmMastDR,"||",2),1)),"^",10)
		.s OrderCatType=$P(^ARC("IC",ItemCatRowid),"^",7)
		.q:'(..MatchAliasOrd(orderParref_"||"_orderId,inputOrderDesc))
		.s:+itemStatDr>0 TItemStatCode = $p(^OEC("OSTAT",itemStatDr),"^",1)
		.q:'##class(web.DHCDocMainOrderInterface).LongOrderScope(scope,TItemStatCode,orderParref,orderId,ifDeliveryRoom)
		.q:(PriorType="S")&&('##class(appcom.OEOrdItem).ISLongOrderPrior(PriorityDR))
		.q:(PriorType="OM")&&('##class(appcom.OEOrdItem).ISShortOrderPrior(PriorityDR,"ShortOrderPrior"))
		.q:(PriorType="OUT")&&('##class(appcom.OEOrdItem).ISShortOrderPrior(PriorityDR,"OutOrderPrior"))
		.Q:(("^"_OrdSubCateGoryStr_"^")'[("^"_ItemCatRowid_"^"))&&(CatType["||")
		.s ItemCatDR=$p(^ARCIM(+ItmMastDR,$p(ItmMastDR,"||",2),1),"^",10)
		.s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)
		.Q:(CatType="ALLNotDurg")&&(OrderType="R") //全部非药品
		.Q:(CatType="ALLLabAndService")&&(OrderType'="L")&&(##class(web.DHCDocOrderCommon).GetItemServiceFlag(ItmMastDR)'="1") //全部检验检查
		.q:(nursebill="N")&&('##class(web.DHCDocMainOrderInterface).IsOrdBillOE(orderParref,orderId))
		.q:(nursebill="Nurse")&&('##class(web.DHCDocMainOrderInterface).IsNurseAdd(orderParref,orderId))  //护嘱单
		.s InstrRowid=$P($G(^OEORD(orderParref,"I",orderId,2)),"^",7)
		.q:(InstrID'="")&&(InstrID'=InstrRowid)
		.s FreqRowid=$P($G(^OEORD(orderParref,"I",orderId,2)),"^",4)
		.Q:(FreqID'="")&&(FreqID'=FreqRowid)
		.d FindInPatOrderSort
	}else{
		//仅查询传入的医嘱id列表
		for i=1:1:$Length(focusOrdList,"@"){
			s OnefocusOrdList=$P(focusOrdList,"@",i)
			continue:(orderParref'=$P(OnefocusOrdList,"||",1))
			s LinOrdRowid = $p(^OEORD(orderParref,"I",$P(OnefocusOrdList,"||",2),11),"^",39)
			if (LinOrdRowid'=""){
				s orderId=$P(LinOrdRowid,"||",2)
				d FindInPatOrderSort
				s orderId=""
				for {
					s orderId=$O(^OEORDi(0,"OEORI",orderParref,LinOrdRowid,orderId))
					q:(orderId="")
					d FindInPatOrderSort
				}
			}else{
				s orderId=$P(OnefocusOrdList,"||",2)
				d FindInPatOrderSort
			}
		}
	}
	d ..OutputGroupOrderTime(repid,ind,.plist,SortByTime,sessionHospId)
	set qHandle = $lb(0,repid,0)
	Q $$$OK
FindInPatOrderSort
	s str1=^OEORD(orderParref,"I",orderId,1)
	s PrescNo=$p($g(^OEORD(+orderParref,"I",orderId,1)),"^",14)
	s groupdr = $p(^OEORD(orderParref,"I",orderId,11),"^",39)
	if (PrescNo'="")&&(##Class(web.DHCDocPrescript).IsPrescType(PrescNo)="1")&&(groupdr'=""){
		//草药处方控制只显示一条主医嘱信息,处方明细在泡芙提示里面显示
		q
	}
	s BindSource=$P($g(^OEORD(orderParref,"I",orderId,"DHC")),"^",41)
	q:(IPHiddenAutoOrd="Y")&&((BindSource'="")&&(groupdr'=""))
	i (isNurse=1) {
		;护士登录 判断治疗分类权限设置
		s ArcimRowid= $p($g(^OEORD(orderParref,"I",orderId,1)),"^",2)
		s OrderId=orderParref_"||"_orderId
		s DCARowID=##class(DHCDoc.DHCDocCure.OutInterface).GetCureApplyByOrd(OrderId)
		if DCARowID'=""{
			s CureCfgLimit=##class(DHCDoc.DHCDocCure.Config).CheckCureCfgLimit(OrderId,ArcimRowid,UserRowId,sessionHospId)
			Q:CureCfgLimit="0"
		}
	}
	s rslist = ..OrderInfo(orderParref_"||"_orderId)
	i isNurse=1 d
	.s TOrderDesc=$list(rslist,5)
	.s TOrderName=$list(rslist,28)
	.s NurColor=..GetOrderColor(orderParref_"||"_orderId)
	.if NurColor'="" s TOrderDesc="<font color="_NurColor_">"_TOrderDesc_"</font>"
	.if NurColor'="" s TOrderName="<font color="_NurColor_">"_TOrderName_"</font>"
	.s $list(rslist,5)=TOrderDesc
	.s $list(rslist,28)=TOrderName
	s groupdr = $p(^OEORD(orderParref,"I",orderId,11),"^",39)
	i +groupdr>0 d //处理护士补录今天以前的长期医嘱
	.s StartDate=$p(^OEORD(+groupdr,"I",$p(groupdr,"||",2),1),"^",9)
	.s StartTime=$p(^OEORD(+groupdr,"I",$p(groupdr,"||",2),1),"^",10)
	e  d
	.s StartDate=$p(str1,"^",9)
	.s StartTime=$p(str1,"^",10)
	s times=StartDate*24*3600+StartTime
	//i (PriorType="ALL") d 
	i groupdr="" d
	.s groupdr=$p($g(^OEORD(orderParref,"I",orderId,"DHC")),"^",54)
	.if (+groupdr'="0")&&('$d(plist(+orderParref,times,$p(groupdr,"||",2)))) s groupdr=""
	i groupdr s $list(rslist,4)=""

	i +groupdr>0 d
	.i '$d(plist(+orderParref,times,$p(groupdr,"||",2))),((CatType["||")||(CatType="ALLNotDurg")||(CatType="ALLLabAndService")) s OrderInfo=..OrderInfo(groupdr) s $list(OrderInfo,17)=1 s plist(+groupdr,times,$p(groupdr,"||",2))=OrderInfo
	.s plist(+orderParref,times,$p(groupdr,"||",2),"Sub", orderId) = rslist
	e  d
	.s plist(orderParref,times,orderId) = rslist
	q
}

/// Description:护士诊疗界面颜色：
/// 			黑色：护士未审核;
/// 			绿色：护士已审核长期;
/// 			蓝色：护士已审核临时;
/// 			红色：已停止长期、已作废长期、已作废临时、已撤销临时(暂不处理)
/// w ##class(web.DHCDocInPatPortalCommon).GetOrderDescColor("4||49")
ClassMethod GetOrderColor(oeori As %String)
{
	k OrderColorList
	d ..GetOrderColorList(.OrderColorList)
	s color=""
	s orderParref=$P(oeori,"||",1)
	s orderId=$P(oeori,"||",2)
	s OEORIPriorityDR=$p($g(^OEORD(orderParref,"I",orderId,1)),"^",8)
	s OEORISeeDate=$p($g(^OEORD(orderParref,"I",orderId,"NUR")),"^",5) //获取处理日期
	s OEORIDisconDate=$p($g(^OEORD(orderParref,"I",orderId,"NUR")),"^",2) //获取停止待处理医嘱的处理日期
	s OEORIStatDr = $p($g(^OEORD(orderParref,"I",orderId,1)),"^",13)
	s ItemStatCode=""
	s:+OEORIStatDr>0 ItemStatCode = $p(^OEC("OSTAT",OEORIStatDr),"^",1)
	if (ItemStatCode="C")||(ItemStatCode="D") {
		s OrdDisposeStatCode=##class(Nur.NIS.Service.Base.Order).GetOrderDisposeStatCode(+orderParref,orderId)
		if (OrdDisposeStatCode="NeedToStop") s OEORISeeDate=""
	}
	if OEORISeeDate'=""{
		if ##class(appcom.OEOrdItem).ISLongOrderPrior(OEORIPriorityDR){
			s color=$P(OrderColorList(2),"^")
		}
		if ##class(appcom.OEOrdItem).ISShortOrderPrior(OEORIPriorityDR){
			s color=$P(OrderColorList(3),"^")
		}
	}
	/*s CheckItemStatCode="^C^U^D^I^"
	s ItemStatCode="^"_ItemStatCode_"^"
	if (CheckItemStatCode[ItemStatCode){
		s color=$P(OrderColorList(4),"^")	
	}*/
	Q color
}

/// 获取护士诊疗界面的颜色列表，用于展示颜色和说明色块
ClassMethod GetOrderColorList(ByRef OrderColorList) As %String
{
	s OrderColorList(1)="black^护士未处理"
	s OrderColorList(2)="green^护士已处理长期医嘱"
	s OrderColorList(3)="#026cb4^护士已处理临时医嘱"
	//s OrderColorList(4)="red^已停止长期、已作废长期、已作废临时、已撤销临时"
	q
}

/// w ##class(web.DHCDocInPatPortalCommon).GetOrderColorHTML()
ClassMethod GetOrderColorHTML() As %String
{
	k OrderColorList
	d ##class(web.DHCDocInPatPortalCommon).GetOrderColorList(.OrderColorList)
	s OrderColorHTML=""
	s i=""
	for {
		s i=$O(OrderColorList(i))
		q:i=""
		s backgroundcolor=$P(OrderColorList(i),"^")
		s title=$P(OrderColorList(i),"^",2)
		///id="tt1" href="#" title="这是提示信息" class="hisui-tooltip" data-options="position:'right'"
		s ColorHTML=""
		s ColorHTML=ColorHTML_"<span style=""margin-left:5px;"">"
		s ColorHTML=ColorHTML_"<a href=""#"" title="""_title_""" Class=""hisui-tooltip"" "
		s ColorHTML=ColorHTML_"data-options=""position:'bottom'"" "
		s ColorHTML=ColorHTML_"style=""background-color:"_backgroundcolor_";border-radius: 4px;color:rgba(250, 250, 250, 0);"" "
		s ColorHTML=ColorHTML_"id=""OrderColorListz"_i_""">1"
		s ColorHTML=ColorHTML_"</a>"
		s ColorHTML=ColorHTML_"</span>"
		if (OrderColorHTML=""){
			s OrderColorHTML=ColorHTML
		}else{
			s OrderColorHTML=OrderColorHTML_ColorHTML
		}
	}
	q OrderColorHTML
}

ClassMethod MatchAliasOrd(oeori As %String, Alias As %String) As %String
{
	s orderParref=$P(oeori,"||",1)
	s orderId=$P(oeori,"||",2)
	
	s MainOrdRowID=$p($G(^OEORD(orderParref,"I",orderId,11)),"^",39)
	if (MainOrdRowID'=""){
		s orderId=$P(MainOrdRowID,"||",2)
	}
	s ItmMastDR=$p($G(^OEORD(orderParref,"I",orderId,1)),"^",2)	
	s MatchFlag=##class(web.DHCDocMain).MatchAlias(ItmMastDR,Alias)
	
	q:MatchFlag="1" MatchFlag
	s Sub=0
	for {
		s Sub=$O(^OEORDi(0,"OEORI",orderParref,orderParref_"||"_orderId,Sub))
		q:Sub=""
		s ItmMastDR=$p($G(^OEORD(orderParref,"I",Sub,1)),"^",2)
		s MatchFlag=##class(web.DHCDocMain).MatchAlias(ItmMastDR,Alias)
		q:MatchFlag="1"
	}
	q MatchFlag
}

/// w ##Class(web.DHCDocInPatPortalCommon).OrderInfo("413||43")
ClassMethod OrderInfo(oeori)
{
	if $d(%request){
		Set qLimit = $g(%request.Data("limit",1))
		Set qStart = $g(%request.Data("start",1))
		Set ^||qCount = $g(^||qCount) + 1
	}
	Set langid=20
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
		s sessionHospId=%session.Get("LOGON.HOSPID")
	}
	s (TStDate,TStTime,TOrderDesc,TDoctor,TStopDate,TStopTime,TStopDoctor,str1,str2,str3,TItemStatCode,oeorioeoridr,DoctorUserDr,TStopNurse,TdeptDesc,TRecDepDesc,TPermission,TDuratDesc1,TBillUom) = ""
	s sessionUserId=%session.Data("LOGON.USERID")
	s sessionLocId=%session.Data("LOGON.CTLOCID")
	s sessionGroupId=%session.Data("LOGON.GROUPID")
	s sessionHospId=%session.Data("LOGON.HOSPID")
	s space = "&nbsp&nbsp",tab = "" //space_space_space_space
	s orderParref=+oeori,orderId=$p(oeori,"||",2)
	s EpisodeID=$P(^OEORD(orderParref),"^",1)
	s PatientID=$P(^PAADM(EpisodeID),"^",1)
	s instrDesc1="",PHFreqDesc1="",depProcNotes="",doseQty=""
	s str2 = $g(^OEORD(orderParref,"I",orderId,2))
	s doseQty = ##class(DHCDoc.Interface.Inside.Service).GetOrdDoseQty(oeori) //$p(str2,"^",1)	;用量 OEORI_DoseQty
	if (doseQty["-") s doseQty="("_doseQty_")"		
	s doseUnitDr= $p(str2,"^",3)	;剂量单位 OEORI_Unit_DR
	s doseUOM=##class(web.DHCDocOrderCommon).GetUOMDesc(doseUnitDr)
	s doseUOM=##class(User.CTUOM).GetTranByDesc("CTUOMDesc",doseUOM,langid)
	s DoseQtyInfo=doseQty_"<font style='font-style:italic;text-decoration:underline'>"_doseUOM_"</font>"
	s instrDr = $p(str2,"^",7)	;用法 OEORI_Instr_DR
	if (+instrDr'=0){
		s instrDesc1=$p(^PHCIN(instrDr),"^",2)
		s instrDesc1=##class(User.PHCInstruc).GetTranByDesc("PHCINDesc1",instrDesc1,langid)
	}
	
	s OrdFreqInfo=##class(DHCDoc.Interface.Inside.ServiceOrd).GetOrdFreqInfo(oeori,"^",langid)
	s PHFreqDr=$List(OrdFreqInfo,1)
	s PHFreqDesc1=$List(OrdFreqInfo,2)
	s PHFreqCode=$List(OrdFreqInfo,5)
	S PHFreqDesc1=$REPLACE(PHFreqDesc1,"^","-")
	S PHFreqCode=$REPLACE(PHFreqDesc1,"^"," ")
	
	s depProcNotes = ""  ;备注 OEORI_DepProcNotes
	s depProcNotesIndex = 0
	f  s depProcNotesIndex=$o(^OEORD(orderParref,"I",orderId,"DEP",depProcNotesIndex)) q:depProcNotesIndex=""  d
	.q:(^OEORD(orderParref,"I",orderId,"DEP",depProcNotesIndex)="")
	.s depProcNotes = depProcNotes_space_^OEORD(orderParref,"I",orderId,"DEP",depProcNotesIndex)
	
	s str1=^OEORD(orderParref,"I",orderId,1)
	s:$d(^OEORD(orderParref,"I",orderId,2)) str2=^OEORD(orderParref,"I",orderId,2)
	s:$d(^OEORD(orderParref,"I",orderId,3)) str3=^OEORD(orderParref,"I",orderId,3)
	;s ordDept = $p(str1,"^",3)
	s ordDept = $p($g(^OEORD(orderParref,"I",orderId,7)),"^",2)
	s:+ordDept>0 TdeptDesc = ##class(web.DHCDocOrderCommon).GetLocDesc(ordDept)
	s:str3'="" TRecDepDR = $p(str3,"^",6)
	s:+TRecDepDR>0 TRecDepDesc = ##class(web.DHCDocOrderCommon).GetLocDesc(TRecDepDR)
	s ItmMastDR = $p(str1,"^",2)
	s OrderName=$p(^ARCIM(+ItmMastDR,$p(ItmMastDR,"||",2),1),"^",2)	;医嘱名称
	s OrderName=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",OrderName,langid)
	s OriginaName=OrderName
	s PrescTitle=##class(web.DHCDocSosOrder).GetOrdItemPrescTitle(ItmMastDR,sessionHospId)
	s PrescTitle=..%Translate("ipdoc.patinfoview.csp",PrescTitle)
	if (PrescTitle'="") s OrderName="<font color=red>【"_PrescTitle_"】</font>"_OrderName
	s OrderAdmReason=$p($g(^OEORD(orderParref,"I",orderId,11)),"^",18)
	s CFPilotPatAdmReason=##class(web.PilotProject.DHCDocPPGroupSeting).GetConfigNode("PilotPatAdmReason")
 	s CFIPPilotPatAdmReason=##class(web.PilotProject.DHCDocPPGroupSeting).GetConfigNode("IPPilotPatAdmReason")
 	if (((CFPilotPatAdmReason'="")&&(OrderAdmReason=CFPilotPatAdmReason))||((CFIPPilotPatAdmReason'="")&&(OrderAdmReason=CFIPPilotPatAdmReason))) {
	 	s OrderName="<font color=red>(药理)</font>"_OrderName
	}
	s PhSpecInstr=$p($g(^OEORD(orderParref,"I",orderId,2)),"^",8) //草药备注
	if (PhSpecInstr'="") s OrderName=OrderName_"【"_PhSpecInstr_"】"
	s ItemCatDR=$p(^ARCIM(+ItmMastDR,$p(ItmMastDR,"||",2),1),"^",10)
	s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)
	
	s PriorityDR = $p(str1,"^",8)
	s PriorityCode = $p(^OECPR(PriorityDR),"^",1)
	s priorityTip =  $case(PriorityCode,"OMST":$p(^OECPR(PriorityDR),"^",2),"OMCQZT":$p(^OECPR(PriorityDR),"^",2),:"")
	s priorityTip=##class(User.OECPriority).GetTranByDesc("OECPRDesc",priorityTip,langid)
	s TDuratDR="" 
	s:str2'="" TDuratDR = $p(str2,"^",6) 
	s:TDuratDR'="" TDuratDesc1 = $p(^PHCDU(TDuratDR),"^",3)	
	s TDuratDesc1=##class(User.PHCDuration).GetTranByDesc("PHCDUDesc1",$g(TDuratDesc1),langid) 
	s OrdItemCallback=##class(web.DHCDocMainOrderInterface).IsCallbackOrder(orderParref,orderId)
	s BackText=..%Translate("ipdoc.patinfoview.csp","退回")
	s NurseBackText=..%Translate("ipdoc.patinfoview.csp","护士退回")
	s OrdItemCallback=$case(OrdItemCallback,1:"<font color=red>("_BackText_")</font>",:"")
	s OrdNurseCallbackret = ##class(web.DHCDocMainOrderInterface).IsNurseCallbackOrder(orderParref,orderId)
	//s OrdNurseCallback = $case(+OrdNurseCallback,1:"<font color=red>("_NurseBackText_":"_$P(OrdNurseCallback,"^",2)_")</font>",:"")
	if (+OrdNurseCallbackret=1){
		s OrdNurseCallback="<font color=red>("_$P(OrdNurseCallbackret,"^",3)_BackText
		if $P(OrdNurseCallbackret,"^",2)'=""{
			s OrdNurseCallback=OrdNurseCallback_":"_$P(OrdNurseCallbackret,"^",2)
		}
		s OrdNurseCallback=OrdNurseCallback_")</font>"
	}else{
		s OrdNurseCallback=""
	}
	
	s ReqPartDesc=##Class(web.DHCAPPInterface).GetExaReqItemDescNoOrder(orderParref_"||"_orderId)
	;if ReqPartDesc'="" s ReqPartDesc=$P(ReqPartDesc," + ",2)
	s oeorioeoridr = $p(^OEORD(orderParref,"I",orderId,11),"^",39)
	s TStDate=$p(str1,"^",9)
	s FirstDayTimes=$P(str1,"^",18)
	s FirstDayTimesDesc=""
	if (TStDate>=..%SysDate())&&(FirstDayTimes'="")&&(oeorioeoridr=""){
		s FirstDayTimesDesc=..%Translate("ipdoc.patinfoview.csp","首日")_":"_FirstDayTimes
	}
	s ItemCatDR=$p(^ARCIM(+ItmMastDR,$p(ItmMastDR,"||",2),1),"^",10)
	s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)
	s PrescNotes=""
	s PrescCookMode=""
	s ARCOSName=""
	i (oeorioeoridr="") d
	.s PrescNo=$p(^OEORD(+orderParref,"I",orderId,1),"^",14)
	.s PrescRowid=""
	.i PrescNo'="" s PrescRowid=$O(^PAQUE1(0,"PrescNo",PrescNo,""))
	.i PrescRowid'="" d
	..s PrescCookMode=$P($g(^PAQUE1(PrescRowid,"DHC")),"^",15)
	..if (PrescCookMode'="") s PrescCookMode=$P($g(^DHCDocConfig("HospDr_"_sessionHospId,"CookMode",PrescCookMode)),"^",2)
	..s PrescCookMode=..%Translate("ipdoc.patinfoview.csp",PrescCookMode)
	..s PrescNotes=$P($g(^PAQUE1(PrescRowid,"DHC")),"^",21)
	
	..s ARCOSRowId=$p($g(^PAQUE1(PrescRowid,"DHC")),"^",24)
	..i ARCOSRowId'="" s ARCOSName=$P($g(^ARCOS(ARCOSRowId)),"^",2)
	
    i depProcNotes="" s depProcNotes=PrescNotes
    s TBillUom = ##class(web.DHCDocMainOrderInterface).GetBillUom(+ItmMastDR,$p(ItmMastDR,"||",2))
    //药品临时医嘱显示总数量
    s SumQty=""
    i ##class(appcom.OEOrdItem).ISShortOrderPrior(PriorityDR,"") { //,OrderType="R"
	    s BillUOMRowid=$p($g(^ARCIM(+ItmMastDR,$p(ItmMastDR,"||",2),8)),"^",14),BillUOMDesc=##class(web.DHCDocOrderCommon).GetUOMDesc(BillUOMRowid)
	    s CheckCHNFlag=##class(web.DHCSTINTERFACE).GetStruModeFlag(ItmMastDR)
		if (CheckCHNFlag="Y") {
		    s Phcdf=$P($g(^ARCIM(+ItmMastDR,$P(ItmMastDR,"||",2),1)),"^",12)
		    if Phcdf'="" s BillUOMRowid=$p(^PHCD(+Phcdf,"DF",$p(Phcdf,"||",2),2),"^",4),BillUOMDesc=##class(web.DHCDocOrderCommon).GetUOMDesc(BillUOMRowid),TBillUom=BillUOMDesc
		}
	    s phqtyord=$p($g(^OEORD(+orderParref,"I",orderId,1)),"^",12)
	    s phqtyord=##class(web.DHCDocOrderView).formateNum(phqtyord)
	    s PackQty=$p($g(^OEORD(+orderParref,"I",orderId,9)),"^",4)
		s PackQty=##class(web.DHCDocOrderView).formateNum(PackQty)
		;协议单位
		s ProtocolPackUOMDR=$p($g(^OEORD(+orderParref,"I",orderId,"DHC")),"^",13)
		s:ProtocolPackUOMDR'="" ProtocolPackUOM=##class(web.DHCDocOrderCommon).GetUOMDesc(ProtocolPackUOMDR)
		i OrderType="R" {
			/*if PackQty'=""{
				i ProtocolPackUOMDR'="" s PackQty=PackQty_"<font style='font-style:italic;text-decoration:underline'>"_ProtocolPackUOM_"</font>",SumQty=PackQty
				e  s PackQty=PackQty_"<font style='font-style:italic;text-decoration:underline'>"_BillUOMDesc_"</font>",SumQty=PackQty
			}else {
				i phqtyord'="" {
					s SumQty=phqtyord_"<font style='font-style:italic;text-decoration:underline'>"_doseUOM_"</font>"
				}
			}*/
			s OrdPackQtyInfo=##Class(web.DHCDocQryOEOrder).GetOrdPackQtyInfo(oeori)
			if PackQty'=""{
				s SumQty=##class(DHCDoc.Util.Base).FormateNumber(+$p(OrdPackQtyInfo,"^",1))_"<font style='font-style:italic;text-decoration:underline'>"_$p(OrdPackQtyInfo,"^",2)_"</font>"
			}else{
				s SumQty=##class(DHCDoc.Util.Base).FormateNumber(+$p(OrdPackQtyInfo,"^",4))_"<font style='font-style:italic;text-decoration:underline'>"_$p(OrdPackQtyInfo,"^",5)_"</font>"
			}
		}else {
			i +phqtyord'=0 s SumQty=phqtyord_"<font style='font-style:italic;text-decoration:underline'>"_BillUOMDesc_"</font>"
		}
    }
	;输液滴速
	s SpeedFlowRate=$p($g(^OEORD(orderParref,"I",orderId,3)),"^",17)
	;输液滴速单位
	s FlowRateUnit=""
	s FlowRateUnitDR=$p($g(^OEORD(orderParref,"I",orderId,6)),"^",8)
	if (FlowRateUnitDR'=""){
		s FlowRateUnit=$P($G(^OEC("SFR",FlowRateUnitDR)),"^",2)
		s FlowRateUnit=##class(User.OECSpeedFlowRate).GetTranByDesc("SFRDesc",FlowRateUnit,langid)
	}
	s SpeedFlowStr=""
	s:SpeedFlowRate'="" SpeedFlowStr=..%Translate("ipdoc.patinfoview.csp","滴速")_":"_SpeedFlowRate_FlowRateUnit
	s DARCIMRowid=$o(^DHCItmMast("0","ARCIM",ItmMastDR,""))
	if (DARCIMRowid'=""){
		//自定义描述医嘱
		s CustomDescOrd=$P(^DHCItmMast(DARCIMRowid),"^",24)
		if (depProcNotes'="")&&(CustomDescOrd="Y"){
			s OrderName=""
		}
	}
	s TOrderDesc=OrdNurseCallback_space_OrderName_space_DoseQtyInfo_space_instrDesc1_space_PHFreqDesc1 //_space_TDuratDesc1
	if '##class(appcom.OEOrdItem).ISLongOrderPrior(PriorityDR) {
		s TOrderDesc=TOrderDesc_space_TDuratDesc1
	}
	i PrescCookMode'="" s TOrderDesc=TOrderDesc_space_PrescCookMode
	i SumQty'="" {
		s BloodReqFormNo=##CLASS(DHCLIS.DHCBloodInterface).GetReqFormNo(orderParref_"||"_orderId)
		i $p(BloodReqFormNo,"^")="-1" s TOrderDesc=TOrderDesc_space_..%Translate("ipdoc.patinfoview.csp","共")_"："_SumQty
	}
	if (ARCOSName'="")&&(oeorioeoridr=""){
		s TOrderDesc=TOrderDesc_space_ARCOSName
	}
	//d ##class(Nur.NIS.Service.Base.OrderHandle).setSkinTestResult()
	s TestBatch=##Class(Nur.OrderStaticInfo).skinTestBatch(orderParref,orderId)
	if TestBatch'="" s TestBatch=..%Translate("ipdoc.patinfoview.csp","批号")_":"_TestBatch
	s TOrderDesc=TOrderDesc_space_FirstDayTimesDesc_space_depProcNotes_space_priorityTip_space_OrdItemCallback_space_ReqPartDesc_space_SpeedFlowStr_space_TestBatch   //_space_OrdItemCallback
	s TOrderName=OrdNurseCallback_space_OrderName_space_PrescCookMode_space_FirstDayTimesDesc_space_depProcNotes_space_OrdItemCallback_space_ReqPartDesc_space_SpeedFlowStr_space_TestBatch
	s TOrderDesc=$$ChekcNUll(TOrderDesc,space)
	s TOrderName=$$ChekcNUll(TOrderName,space)
	i $d(^OEORD(orderParref,"I",orderId,1))=1 s DoctorDr=$p(^OEORD(orderParref,"I",orderId,1),"^",11)
	s:+$g(DoctorDr)>0 TDoctor = $p($g(^CTPCP(DoctorDr,1)),"^",2),DoctorUserDr = $o(^SSU("SSUSR",0,"CTPCP",DoctorDr,""))
	Set TDoctor= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",TDoctor,langid)
	s TStDate = ..%ZD($p(str1,"^",9)) //$zd($p(str1,"^",9),3)
	s TStTime = ..%ZT($p(str1,"^",10),1)
	
	s TStopDate = $p(^OEORD(orderParref,"I",orderId,3),"^",34)		;XDate
	s:$d(^OEORD(orderParref,"I",orderId,2)) TStopTime = $p(^OEORD(orderParref,"I",orderId,2),"^",15)		;XTime
	s TExEndDate = $p(^OEORD(orderParref,"I",orderId,9),"^",9)		;OEORI_EndDate	
	s TExEndTime = $p(^OEORD(orderParref,"I",orderId,9),"^",10) 	;OEORI_EndTime
	s TStopDate = $s(TStopDate="":TExEndDate, 1:TStopDate)			;没停止日期时,取预停日期	
	s TStopTime = $s(TStopTime="":TExEndTime, 1:TStopTime)
	
	s:TStopDate'="" TStopDate=..%ZD(TStopDate) //$zd(TStopDate,3)
	s:TStopTime'="" TStopTime=..%ZT(TStopTime,2) 
	s itemStatDr = $p(str1,"^",13) 		;OEORI_ItemStat_DR ;OEC_OrderStatus
	s:+itemStatDr>0 TItemStatCode = $p(^OEC("OSTAT",itemStatDr),"^",1)
	
	s userUpdateDr=$p($g(^OEORD(orderParref,"I",orderId,8)),"^",12)
	s:(+userUpdateDr>0)&&(TExEndDate'="") TStopDoctor = $p(^SSU("SSUSR",userUpdateDr),"^",2)	;预停医生
	s StopDoctorDR = $p(^OEORD(orderParref,"I",orderId,3),"^",29)
	s:+StopDoctorDR>0 TStopDoctor = $p(^CTPCP(StopDoctorDR,1),"^",2)	;重新覆盖停医嘱医生
	Set TStopDoctor= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",TStopDoctor,langid)
	s TStDateHide=TStDate,TStTimeHide=TStTime
	if (+oeorioeoridr>0){
		s TOrderDesc = tab_TOrderDesc,TOrderName = tab_TOrderName,TStDate="",TStTime=""
	}
	s TStopNurse = ##class(web.DHCDocMainOrderInterface).GetXOrderNurseName(orderParref,orderId)
	Set TStopNurse= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",TStopNurse,langid)
	s PriorityId=$p(^OEORD(orderParref,"I",orderId,1),"^",8)
	s TPriorityCode=$p(^OECPR(PriorityId),"^",1) //医嘱类型Code
	s PriorityDesc=$p(^OECPR(PriorityId),"^",2)
	s PriorityDesc=##class(User.OECPriority).GetTranByDesc("OECPRDesc",PriorityDesc,langid)
	s OEORINotifyClinician = $p($G(^OEORD(orderParref,"I",orderId,11)),"^",55)
	s prescNo=$p(^OEORD(+orderParref,"I",orderId,1),"^",14)
	if (prescNo'="")&&(##Class(web.DHCDocPrescript).IsPrescType(prescNo)=1){
		s OEORINotifyClinician=##class(web.DHCSTPCHCOLLS).GetEmy(prescNo)
	}
	s OEORINotifyClinician=$case(OEORINotifyClinician,"Y":"<font color=red>"_..%Translate("ipdoc.patinfoview.csp","急")_"</font>",:"")
	if (+itemStatDr>0){
		s TItemStatDesc = $p(^OEC("OSTAT",itemStatDr),"^",2)
		s TItemStatDesc=##class(User.OECOrderStatus).GetTranByDesc("OSTATDesc",TItemStatDesc,langid)
	}
	s TOrderDesc = OEORINotifyClinician_"&nbsp"_TOrderDesc
	s TOrderName = OEORINotifyClinician_"&nbsp"_TOrderName
	;验证是当日存在异常执行记录未生成情况
	s Rtn=##class(web.DHCDocMain).CheckExecHave(oeori,+$H)
	if +Rtn=1 {
		s Mesag=$P(Rtn,"^",2)
		s TOrderDesc="<font color=red>("_..%Translate("ipdoc.patinfoview.csp","当日执行记录缺失")_")"_..%Translate("ipdoc.patinfoview.csp",Mesag)_"</font>"_"&nbsp"_TOrderDesc
		s TOrderName="<font color=red>("_..%Translate("ipdoc.patinfoview.csp","当日执行记录缺失")_")"_..%Translate("ipdoc.patinfoview.csp",Mesag)_"</font>"_"&nbsp"_TOrderName
	}
	s SkinInfo=..GetSkinInfo(oeori,sessionHospId,langid)
	if (SkinInfo'=""){
		s TOrderDesc = SkinInfo_"&nbsp"_TOrderDesc
		s TOrderName = SkinInfo_"&nbsp"_TOrderName
	}
	
	;需要展示的医嘱状态 停止 撤销 作废 未审核
	s STReasonComtent=""
	if ((TItemStatCode="C")||(TItemStatCode="U")||(TItemStatCode="D")||(TItemStatCode="I"))   {
		//s TOrderDesc="<font color=red>"_TItemStatDesc_"</font>"_"&nbsp"_TOrderDesc
		s STChildSub=$o(^OEORD(+oeori,"I",$p(oeori,"||",2),"ST",""),-1)
		if (STChildSub'="") {
			s STReasonDR=$p($g(^OEORD(+oeori,"I",$p(oeori,"||",2),"ST",STChildSub)),"^",7)
			i STReasonDR'="" {
				s STReasonComtent=$p($g(^OEC("ASCR",STReasonDR)),"^",2)
				s STReasonComtent=##class(User.OECAdminStatusChReason).GetTranByDesc("ASCRDesc",STReasonComtent,langid)
			}else {
				s STReasonComtent=$p($g(^OEORD(+oeori,"I",$p(oeori,"||",2),"ST",STChildSub)),"^",8)
			}
			i STReasonComtent'="" s TItemStatDesc=TItemStatDesc_"("_STReasonComtent_")"
		}
		s TOrderDesc = "<font color=red>"_TItemStatDesc_"</font>"_"&nbsp"_TOrderDesc
		s TOrderName = "<font color=red>"_TItemStatDesc_"</font>"_"&nbsp"_TOrderName
	}
	s DCARowId=$o(^DHCDocCure(0,"OEORI",oeori,""))
	if (+DCARowId>0){
		s Status=$p($g(^DHCDocCure(DCARowId)),"^",3)
		if Status="C",STReasonComtent=""{
			s TOrderDesc="<font color=red>("_..%Translate("ipdoc.patinfoview.csp","治疗已取消")_")"_"</font>"_"&nbsp"_TOrderDesc
			s TOrderName="<font color=red>("_..%Translate("ipdoc.patinfoview.csp","治疗已取消")_")"_"</font>"_"&nbsp"_TOrderName
		}
	}
	s ValARCItem=##Class(web.DHCDocOrderEntry).ValARCItem(ItmMastDR)
	if (ValARCItem=1){
		s TOrderDesc = "<font color=red>("_..%Translate("ipdoc.patinfoview.csp","医嘱项已停用")_")</font>"_TOrderDesc
		s TOrderName = "<font color=red>("_..%Translate("ipdoc.patinfoview.csp","医嘱项已停用")_")</font>"_TOrderName
	}
	
	
	s OrderStage=$p($G(^OEORD(+oeori,"I",$p(oeori,"||",2),"DHC")),"^",8)
	s OrderStage=$CASE(OrderStage,"SZ":"术中","SQ":"术前","SH":"术后","CZ":"产中","":"")
	i OrderStage'=""{
		s OrderStage=..%Translate("ipdoc.patinfoview.csp",OrderStage)
		s TOrderDesc = TOrderDesc_"&nbsp"_OrderStage	
		s TOrderName = TOrderName_"&nbsp"_OrderStage	
	}
	s DischargeOrdFlag=##class(web.DHCDocOrderEntry).IsDischargeOrd(ItmMastDR,sessionHospId)
	if (DischargeOrdFlag=2){
		s DeceasedDate=$p(^PAPER(PatientID,"ALL"),"^",13)
		s DeceasedTime=$p(^PAPER(PatientID,"ALL"),"^",8)
	    i DeceasedDate'="" {
		    s DeceasedDate=..%ZD(DeceasedDate)
		    i DeceasedTime'="" s DeceasedTime=..%ZT(DeceasedTime,2)
			s TOrderDesc = TOrderDesc_"&nbsp"_..%Translate("ipdoc.patinfoview.csp","死亡时间")_":"_DeceasedDate_" "_DeceasedTime	
			s TOrderName = TOrderName_"&nbsp"_..%Translate("ipdoc.patinfoview.csp","死亡时间")_":"_DeceasedDate_" "_DeceasedTime
	    }
	}
		
	s OEORIDate=..%ZD($p(str3,"^",7))
	s OEORITime=..%ZT($p(str1,"^",17),1)
	s OEORIAddDate=OEORIDate_" "_OEORITime
	s StopPermission=##class(web.DHCDocMain).CheckStopOrder(oeori,sessionUserId,sessionLocId,sessionGroupId)
	s CancelPermission=##class(web.DHCDocMain).CheckCancelOrder(oeori,sessionUserId,sessionLocId,sessionGroupId)
	s UnusePermission =##class(web.DHCDocMain).CheckUnuseOrder(oeori,sessionUserId,sessionLocId,sessionGroupId)
	s TOrderDesc=##class(web.DHCDocUtil).EvalJSON(TOrderDesc)
	s OEORISeeDate=$p($g(^OEORD(orderParref,"I",orderId,"NUR")),"^",5) //获取处理日期
	s OEORISeeInfo=""
	if (OEORISeeDate'=""){
		s OEORISeeUser=""
		s OEORISeeType=$p($g(^OEORD(orderParref,"I",orderId,"NUR")),"^",7)
		s OEORISeeRemark=$p($g(^OEORD(orderParref,"I",orderId,"NUR")),"^",8)
		s OEORISeeUserDR=$p($g(^OEORD(orderParref,"I",orderId,"NUR")),"^",4)
		i OEORISeeUserDR'="" s OEORISeeUser=$p(^SSU("SSUSR",OEORISeeUserDR),"^",2)
		 s OEORISeeUser =##class(User.SSUser).GetTranByDesc("SSUSRName",OEORISeeUser,langid)
		//s OEORIDisconUserDR=$p($g(^OEORD(orderParref,"I",orderId,"NUR")),"^",1)
		//i OEORIDisconUserDR'="" s OEORISeeUser=$p(^SSU("SSUSR",OEORISeeUserDR),"^",2)
		s OEORISeeType=$case(OEORISeeType,"F":..%Translate("ipdoc.patinfoview.csp","完成"),"A":..%Translate("ipdoc.patinfoview.csp","接受"),"R":..%Translate("ipdoc.patinfoview.csp","拒绝"),:"")
		s OEORISeeInfo=OEORISeeUser_":"_OEORISeeType
		if (OEORISeeRemark'=""){
			s OEORISeeInfo=OEORISeeInfo_","_OEORISeeRemark
		}
		if (TItemStatCode="C")||(TItemStatCode="D") {
			s OrdDisposeStatCode=##class(Nur.NIS.Service.Base.Order).GetOrderDisposeStatCode(+orderParref,orderId)
			if (OrdDisposeStatCode="NeedToStop") s OEORISeeInfo=""
		}
	}
	s TAddNotePermission =##class(web.DHCDocMain).CheckAddNoteOrder(oeori,sessionUserId,sessionLocId,sessionGroupId)
	s OrderViewFlag=##Class(web.DHCDocInPatPortalCommon).GetOrderViewFlag(ItmMastDR,oeori)
	//获取医嘱泡芙提示信息
	s PopoverHtml=##class(web.DHCOEOrdItem).GetOrderPopoverInfo(oeori,TOrderDesc,langid)
	s ZSQUrl=##class(web.DHCDocService).GetLinkMesageZSQ(ItmMastDR,oeori_"^^^")
	s ZSQUrl=$P(ZSQUrl,"^",3)
	;s YDTSUrl=##class(web.DHCDocService).GetLinkMesageYDTS(ItmMastDR,oeori_"^^^")
	;s YDTSUrl=$P(YDTSUrl,"^",3)
	////临时护嘱绑定的长期医嘱id/所辅助的治疗医嘱 
	s NurseLinkOrderRowId=$p($g(^OEORD(orderParref,"I",orderId,"DHC")),"^",54)
	s IsCNMedItem=##class(DHCDoc.Order.Common).IsCNOrdItem(oeori,sessionHospId)
	s CoverMainIns=$P(str3,"^",3)
	s SignFlag=..CheckOrdSign(oeori)
	//国家医保编码
	s InsuNationCode=""
	s InsuNationName=""
	s NowDate=..%ZD(+$H)
	
	s InsuNationCode=..GetArcimLinkInsuInfo(ItmMastDR,OrderAdmReason,sessionHospId,NowDate,13)
	s InsuNationName=..GetArcimLinkInsuInfo(ItmMastDR,OrderAdmReason,sessionHospId,NowDate,14)

	s OrdSerialNum=$p($g(^OEORD(+oeori,"I",$p(oeori,"||",2),"DHC")),"^",75)
	s OrdLinkSpecLocDiagStr=##class(DHCDoc.Diagnos.SpecLoc).GetOrdLinkSpecLocDiag(oeori,sessionHospId,langid)
	s OrdSpecDiagnosForm=$P(OrdLinkSpecLocDiagStr,"^",3)
	s OrdSpecLocDiagCatCode=$P(OrdLinkSpecLocDiagStr,"^",2)
	s BindSourceDesc=##Class(web.DHCDocQryOEOrder).GetBindSourceDesc(oeori)
	q $lb(orderParref_"||"_orderId,TItemStatCode,oeorioeoridr,TStDate_" "_TStTime,TOrderDesc,TDoctor,TStopDate_" "_TStopTime,TStopDoctor,TStopNurse,TdeptDesc,TRecDepDesc,orderParref_"||"_orderId,"",OrderType,PriorityDesc,TItemStatDesc,0,TBillUom,TStDateHide_" "_TStTimeHide,StopPermission,CancelPermission,UnusePermission,TPriorityCode,PHFreqCode,OEORIAddDate,OEORISeeInfo,TAddNotePermission,TOrderName,DoseQtyInfo,instrDesc1,PHFreqDesc1,TDuratDesc1,SumQty,OrderViewFlag,PopoverHtml,ZSQUrl,NurseLinkOrderRowId,IsCNMedItem,CoverMainIns,SignFlag,InsuNationCode,InsuNationName,OriginaName,ItmMastDR,OrdSerialNum,OrdSpecDiagnosForm,OrdSpecLocDiagCatCode,BindSourceDesc)
ChekcNUll(indesc,inspace)
	s artnstr=""
	for icnull=1:1:$L(indesc,inspace)
	{
		s subdesc=$P(indesc,inspace,icnull)
		continue:subdesc=""
		if artnstr="" s artnstr=subdesc
		else  s artnstr=artnstr_inspace_subdesc
	}
	Q:artnstr="" indesc
	q artnstr
}

ClassMethod OutputGroupOrder(repid, ind, ByRef plist, sessionHospId As %String = "")
{
	i ($g(sessionHospId)="")&&($d(%session)) s sessionHospId=%session.Get("LOGON.HOSPID")
	s HospCodeNode="HospDr_"_sessionHospId
	s orderParref = $o(plist(""))
	q:+orderParref=0
	s parref=0 f  s parref=$o(plist(orderParref,parref)) q:parref=""  d
	.s plist(orderParref,parref,"ChildNum")=0	;记录当前医嘱子嘱条数
	.s sub=0 f  s sub = $o(plist(orderParref,parref,"Sub",sub)) q:sub=""  d
	..if $o(plist(orderParref,parref,"Sub",sub))="" d
	...s $list(plist(orderParref,parref,"Sub",sub),13)="┛" //"<p style=""display:inline;color:red;"">┛</p>"
	..else  d  
	...s $list(plist(orderParref,parref,"Sub",sub),13)="┃" //"<p style=""display:inline;color:red;"">┃</p>" 
	..s plist(orderParref,parref,"ChildNum")=plist(orderParref,parref,"ChildNum")+1
	.i plist(orderParref,parref,"ChildNum")>0 Set $list(plist(orderParref,parref),13)="┓" //"<p style=""display:inline;color:red;"">┓</p>"
	
	//成组医嘱只显示在同一页
	If $g(^DHCDocOrderBillConfig(HospCodeNode,"Main","GroupOrderOnePage"))="Y"{
		Set Limit=14
		if $d(%request){
			Set Limit = $G(%request.Data("Pagerows",1))
		}
		s parrefIndex=0, parref=0 f  s parref=$o(plist(orderParref,parref)) q:parref=""  d
		.if (Limit-(ind#Limit))<(plist(orderParref,parref,"ChildNum")+1) d		;剩余行数<将显示的成组行数
		..for i=1:1:(Limit-(ind#Limit)) Set ind=ind+1,^CacheTemp(repid,ind)=$lb("","","-1","")
		.s ind = ind+1,parrefIndex=parrefIndex+1		
		.s ^CacheTemp(repid,ind) = $g(plist(orderParref,parref))
		.s subIndex=0, sub=0 f  s sub = $o(plist(orderParref,parref,"Sub", sub)) q:sub=""  d
		..s ind = ind+1,subIndex=subIndex+1
		..s ^CacheTemp(repid,ind) = plist(orderParref,parref,"Sub",sub)
		..//s $list(^CacheTemp(repid,ind),6)=parrefIndex_"."_subIndex
		.//s $list(^CacheTemp(repid,ind-subIndex),6)=parrefIndex_"-"_subIndex ;父数据行中6列中,4-3表示他有3条子嘱
	}else{
		s parrefIndex=0, parref=0 f  s parref=$o(plist(orderParref,parref)) q:parref=""  d
		.s ind = ind+1,parrefIndex=parrefIndex+1		
		.s ^CacheTemp(repid,ind) = $g(plist(orderParref,parref))
		.s subIndex=0, sub=0 f  s sub = $o(plist(orderParref,parref,"Sub", sub)) q:sub=""  d
		..s ind = ind+1,subIndex=subIndex+1
		..s ^CacheTemp(repid,ind) = plist(orderParref,parref,"Sub",sub)
		..//s $list(^CacheTemp(repid,ind),6)=parrefIndex_"."_subIndex
		.//s $list(^CacheTemp(repid,ind-subIndex),6)=parrefIndex_"-"_subIndex				;父数据行中6列中,4-3表示他有3条子嘱
	}
	q
}

ClassMethod SelectGroupOrder(nursebill, ByRef plist)
{
	s orderParref = $o(plist(""))
	q:+orderParref=0  
	s sub=0 f  s sub=$o(plist(orderParref,sub)) q:sub=""  d
	.i $d(^OEORDi(0,"OEORI",orderParref,orderParref_"||"_sub))=10 d 				;orderParref||sub有子嘱
	..k plist(orderParref,sub)
	..s IsOrdBillOE=##class(web.DHCDocMainOrderInterface).IsOrdBillOE(orderParref,sub)
	..i ((nursebill="N")&&IsOrdBillOE)||(nursebill'="N") d
	...s plist(orderParref,sub) = ..OrderInfo(orderParref_"||"_sub) 
	..s oeori=0  f  s oeori=$o(^OEORDi(0,"OEORI",orderParref,orderParref_"||"_sub,oeori)) q:oeori=""  d
	...s IsOrdBillOE=##class(web.DHCDocMainOrderInterface).IsOrdBillOE(orderParref,oeori)
	...i ((nursebill="N")&&IsOrdBillOE)||(nursebill'="N") d
	....s plist(orderParref,sub,"Sub",oeori) = ##class(web.DHCDocMain).OrderInfo(orderParref_"||"_oeori)
}

// 按成组输出医嘱

ClassMethod OutputGroupOrderTime(repid, ind, ByRef plist, SortByTime, sessionHospId As %String = "")
{
	i ($g(sessionHospId)="")&&($d(%session)) s sessionHospId=%session.Get("LOGON.HOSPID")
	s HospCodeNode="HospDr_"_sessionHospId
	Set ScrollView = $S($D(%request):$G(%request.Data("ScrollView",1)),1:0)
	if (SortByTime=1){
		s orderParref = $o(plist(""))
		q:+orderParref=0
		s time=""
		for  Set time=$o(plist(orderParref,time),-1) Quit:time=""  do
		.s parref=0 f  s parref=$o(plist(orderParref,time,parref)) q:parref=""  d
		..s plist(orderParref,time,parref,"ChildNum")=0	;记录当前医嘱子嘱条数
		..s sub=0 f  s sub = $o(plist(orderParref,time,parref,"Sub",sub)) q:sub=""  d
		...if $o(plist(orderParref,time,parref,"Sub",sub))="" d
		....s $list(plist(orderParref,time,parref,"Sub",sub),13)="┛" //"<p style=""display:inline;color:red;"">┛</p>"
		...else  d  
		....s $list(plist(orderParref,time,parref,"Sub",sub),13)="┃" //"<p style=""display:inline;color:red;"">┃</p>" 
		...s plist(orderParref,time,parref,"ChildNum")=plist(orderParref,time,parref,"ChildNum")+1
		..i plist(orderParref,time,parref,"ChildNum")>0 Set $list(plist(orderParref,time,parref),13)="┓" //"<p style=""display:inline;color:red;"">┓</p>"
		
		//成组医嘱只显示在同一页
		If ($g(^DHCDocOrderBillConfig(HospCodeNode,"Main","GroupOrderOnePage"))="Y")&&(ScrollView'="1"){
			Set Limit=14
			if $d(%request){
				Set Limit = $G(%request.Data("Pagerows",1))
			}
			s parrefIndex=0 
			s time=""
			for  Set time=$o(plist(orderParref,time),-1) Quit:time=""  do
			.Set parref=0 f  s parref=$o(plist(orderParref,time,parref)) q:parref=""  d
			..if (Limit-(ind#Limit))<(plist(orderParref,time,parref,"ChildNum")+1) d		;剩余行数<将显示的成组行数
			...for i=1:1:(Limit-(ind#Limit)) Set ind=ind+1,^CacheTemp(repid,ind)=$lb("","","-1","")
			..s ind = ind+1,parrefIndex=parrefIndex+1		
			..s ^CacheTemp(repid,ind) = $g(plist(orderParref,time,parref))
			..s subIndex=0, sub=0 f  s sub = $o(plist(orderParref,time,parref,"Sub", sub)) q:sub=""  d
			...s ind = ind+1,subIndex=subIndex+1
			...s ^CacheTemp(repid,ind) = plist(orderParref,time,parref,"Sub",sub)
			...;s $list(^CacheTemp(repid,ind),6)=parrefIndex_"."_subIndex
			..;s $list(^CacheTemp(repid,ind-subIndex),6)=parrefIndex_"-"_subIndex ;父数据行中6列中,4-3表示他有3条子嘱
		}else{
			s parrefIndex=0
			s time=""
			for  Set time=$o(plist(orderParref,time),-1) Quit:time=""  do
			.Set parref=0 f  s parref=$o(plist(orderParref,time,parref)) q:parref=""  d
			..s ind = ind+1,parrefIndex=parrefIndex+1		
			..s ^CacheTemp(repid,ind) = $g(plist(orderParref,time,parref))
			..s subIndex=0, sub=0 f  s sub = $o(plist(orderParref,time,parref,"Sub", sub)) q:sub=""  d
			...s ind = ind+1,subIndex=subIndex+1
			...s ^CacheTemp(repid,ind) = plist(orderParref,time,parref,"Sub",sub)
			...;s $list(^CacheTemp(repid,ind),6)=parrefIndex_"."_subIndex
			..;s $list(^CacheTemp(repid,ind-subIndex),6)=parrefIndex_"-"_subIndex				;父数据行中6列中,4-3表示他有3条子嘱
		}
	}else{
		s orderParref = $o(plist(""))
		q:+orderParref=0
		s time=""
		for  Set time=$o(plist(orderParref,time)) Quit:time=""  do
		.s parref=0 f  s parref=$o(plist(orderParref,time,parref)) q:parref=""  d
		..s plist(orderParref,time,parref,"ChildNum")=0	;记录当前医嘱子嘱条数
		..s sub=0 f  s sub = $o(plist(orderParref,time,parref,"Sub",sub)) q:sub=""  d
		...if $o(plist(orderParref,time,parref,"Sub",sub))="" d
		....s $list(plist(orderParref,time,parref,"Sub",sub),13)="┛" //"<p style=""display:inline;color:red;"">┛</p>"
		...else  d  
		....s $list(plist(orderParref,time,parref,"Sub",sub),13)="┃" //"<p style=""display:inline;color:red;"">┃</p>" 
		...s plist(orderParref,time,parref,"ChildNum")=plist(orderParref,time,parref,"ChildNum")+1
		..i plist(orderParref,time,parref,"ChildNum")>0 Set $list(plist(orderParref,time,parref),13)="┓" //"<p style=""display:inline;color:red;"">┓</p>"

		//成组医嘱只显示在同一页
		If ($g(^DHCDocOrderBillConfig(HospCodeNode,"Main","GroupOrderOnePage"))="Y")&&(ScrollView'="1"){
			Set Limit=14
			if $d(%request){
				Set Limit = $G(%request.Data("Pagerows",1))
			}
			s parrefIndex=0 
			s time=""
			for  Set time=$o(plist(orderParref,time)) Quit:time=""  do
			.Set parref=0 f  s parref=$o(plist(orderParref,time,parref)) q:parref=""  d
			..if (Limit-(ind#Limit))<(plist(orderParref,time,parref,"ChildNum")+1) d		;剩余行数<将显示的成组行数
			...for i=1:1:(Limit-(ind#Limit)) Set ind=ind+1,^CacheTemp(repid,ind)=$lb("","","-1","")
			..s ind = ind+1,parrefIndex=parrefIndex+1		
			..s ^CacheTemp(repid,ind) = $g(plist(orderParref,time,parref))
			..s subIndex=0, sub=0 f  s sub = $o(plist(orderParref,time,parref,"Sub", sub)) q:sub=""  d
			...s ind = ind+1,subIndex=subIndex+1
			...s ^CacheTemp(repid,ind) = plist(orderParref,time,parref,"Sub",sub)
			...;s $list(^CacheTemp(repid,ind),6)=parrefIndex_"."_subIndex
			..;s $list(^CacheTemp(repid,ind-subIndex),6)=parrefIndex_"-"_subIndex ;父数据行中6列中,4-3表示他有3条子嘱
		}else{
			s parrefIndex=0
			s time=""
			for  Set time=$o(plist(orderParref,time)) Quit:time=""  do
			.Set parref=0 f  s parref=$o(plist(orderParref,time,parref)) q:parref=""  d
			..s ind = ind+1,parrefIndex=parrefIndex+1		
			..s ^CacheTemp(repid,ind) = $g(plist(orderParref,time,parref))
			..s subIndex=0, sub=0 f  s sub = $o(plist(orderParref,time,parref,"Sub", sub)) q:sub=""  d
			...s ind = ind+1,subIndex=subIndex+1
			...s ^CacheTemp(repid,ind) = plist(orderParref,time,parref,"Sub",sub)
			...;s $list(^CacheTemp(repid,ind),6)=parrefIndex_"."_subIndex
			..;s $list(^CacheTemp(repid,ind-subIndex),6)=parrefIndex_"-"_subIndex				;父数据行中6列中,4-3表示他有3条子嘱
		}
	}
	q
}

ClassMethod SelectGroupOrderTime(nursebill, ByRef plist)
{
	s orderParref = $o(plist(""))
	q:+orderParref=0  
	s time=""
	for  Set time=$o(plist(orderParref,time),-1) Quit:time=""  do
	.s sub=0 f  s sub=$o(plist(orderParref,time,sub)) q:sub=""  d
	..i $d(^OEORDi(0,"OEORI",orderParref,orderParref_"||"_sub))=10 d 				;orderParref||sub有子嘱
	...k plist(orderParref,time,sub)
	...s IsOrdBillOE=##class(web.DHCDocMainOrderInterface).IsOrdBillOE(orderParref,sub)
	...i ((nursebill="N")&&IsOrdBillOE)||(nursebill'="N") d
	....s plist(orderParref,time,sub) = ..OrderInfo(orderParref_"||"_sub) 
	...s oeori=0  f  s oeori=$o(^OEORDi(0,"OEORI",orderParref,orderParref_"||"_sub,oeori)) q:oeori=""  d
	....s IsOrdBillOE=##class(web.DHCDocMainOrderInterface).IsOrdBillOE(orderParref,oeori)
	....i ((nursebill="N")&&IsOrdBillOE)||(nursebill'="N") d
	.....s plist(orderParref,time,sub,"Sub",oeori) = ##class(web.DHCDocMain).OrderInfo(orderParref_"||"_oeori)
}

/// 根据医嘱ID获取对应频次的分发时间
Query GetPHFreqInfoList(oeori As %String, date As %String = "") As websys.Query(ROWSPEC = "id:%String,text:%String,seltext:%String")
{
}

ClassMethod GetPHFreqInfoListExecute(ByRef qHandle As %Binary, oeori As %String, date As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCDocInPatPortalCommon","GetPHFreqInfoList","447||22","16/05/2023")
	s ^TMP("GetPHFreqInfoListExecute")=oeori_","_date
	i date="" s date=..%SysDate()
	s date=..%ZDH(date)
	s week=$ZD(date,10)
	i week=0 s week=7
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s str2 = $g(^OEORD(+oeori,"I",$p(oeori,"||",2),2))
	s PHFreqDr = $p(str2,"^",4)
	s StartDate=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),1),"^",9)
	s StartTime=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),1),"^",10)
	if (date>StartDate) {
		s IPLongOrderRollStartTime=##class(web.DHCDocConfig).GetConfigNodeNew2("IPLongOrderRollStartTime")
		i IPLongOrderRollStartTime="" s IPLongOrderRollStartTime="08:00"
		if (PHFreqDr="") {
			
			s FreqDispTime=IPLongOrderRollStartTime
			if (..%ZTH(FreqDispTime)=1) set qHandle = $lb(0,repid,0) Q $$$OK
		}else{
			s FreqDispTimes = ##class(web.DHCDocMainOrderInterface).GetIPFreqDispTimeStr(PHFreqDr)
			
			s PutFreqDispTimes=$List(##class(DHCDoc.Interface.Inside.ServiceOrd).GetOrdFreqInfo(oeori,"","",..%ZD(date)),4)
			s NewFreqDispTime=""
			if (PutFreqDispTimes'=""){
				for i=1:1:$L(PutFreqDispTimes,$C(1)){
					s OneFreqTime=$P(PutFreqDispTimes,$C(1),i)
					s OneFreqWeek=$P(OneFreqTime,$C(2),2)
					s OneFreqTime=$P(OneFreqTime,$C(2),1)
					continue:OneFreqTime=""
					
					continue:(OneFreqWeek'="")&&(week'=OneFreqWeek)
					
					if NewFreqDispTime=""  s NewFreqDispTime=OneFreqTime
					else  s NewFreqDispTime=NewFreqDispTime_","_OneFreqTime
				}
				s FreqDispTimes=NewFreqDispTime
			}
			//if NewFreqDispTime'="" s FreqDispTimes=NewFreqDispTime
			if (FreqDispTimes'=""){
				s FreqDispTime=$p(FreqDispTimes,",",1)
				s FreqDispTime=..%ZTH(FreqDispTime)-60
				s:FreqDispTime<0 FreqDispTime=0
			}else{
				s FreqDispTime=..%ZTH(IPLongOrderRollStartTime)
			}
		}
		
		d DoZeroTime(FreqDispTime)
		d DoFreqDispTimes(FreqDispTimes)
	}elseif(date=StartDate){
		k RepeatFreqDispTimeList
		d DoZeroTime(StartTime)
		s FreqDispTimes=""
		s OEOREChildsub=0
		for {
			s OEOREChildsub=$o(^OEORDi(0,"OrdItem",+oeori,$p(oeori,"||",2),StartDate,OEOREChildsub)) Q:OEOREChildsub=""
			s OEOREExStTime=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),"X",OEOREChildsub),"^",2)
			s OEOREExStTime=..%ZT(OEOREExStTime,1)
			if FreqDispTimes=""{
				s FreqDispTimes=OEOREExStTime
			}else {
				if ((","_FreqDispTimes_",")[(","_OEOREExStTime_","))  {
					if ($d(RepeatFreqDispTimeList(OEOREExStTime))) {
						s RepeatFreqDispTimeList(OEOREExStTime)=+$g(RepeatFreqDispTimeList(OEOREExStTime))+1
					}else{
						s RepeatFreqDispTimeList(OEOREExStTime)=2
					}
					continue
				}
				s FreqDispTimes=FreqDispTimes_","_OEOREExStTime
			}
		}
		d DoFreqDispTimes(FreqDispTimes)
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(id,text,seltext)  
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
DoZeroTime(FreqDispTime)
	s id=FreqDispTime //..%ZTH(FreqDispTime)-60
	if id=0 s id=1
	s id=..%ZT(id,1)
	s text=..%Translate("ipdoc.patinfoview.csp","0次 ")_id
	s seltext=..%ZT(..%ZTH(id),1)
	Do OutputRow1
	Q
DoFreqDispTimes(FreqDispTimes)
	q:(FreqDispTimes="")
	s MaxCount=0
	s len = $l(FreqDispTimes,",")
	for i=1:1:len {
		s id=$p(FreqDispTimes,",",i)
		s id=..%ZT(..%ZTH(id),1)
		if ($d(RepeatFreqDispTimeList(id))) {
			s MaxCount=MaxCount+RepeatFreqDispTimeList(id)
		}else{
			s MaxCount=MaxCount+1
		}
		s seltext=..%ZT(..%ZTH(id)+10,1)
		s text=MaxCount_..%Translate("ipdoc.patinfoview.csp","次 ")_seltext
		s id=id_","_i
		Do OutputRow1
	}
	Q
}

/// 获取病人诊疗信息JSON串
/// w ##Class(web.DHCDocInPatPortalCommon).GetAdmInfoJson(268,"ys01")
ClassMethod GetAdmInfoJson(EpisodeID As %String, UserCode As %String) As %String
{
	s ^tan("GetAdmInfoJson")=EpisodeID_","_UserCode
	s UserID=$O(^SSU("SSUSR",0,"SSUSR_Initials",$ZCVT(UserCode,"U"),""),-1)
	
	s JsonObj=[]
	/*
	医生站
	*/
	//饮食
	s Diet=##Class(DHCDoc.DHCDocConfig.OrderClassify).GetAdmOrdClassify(EpisodeID,"Diet")
	d SetJsonValue("Diet",Diet)
	//引流
	s Drainage=##Class(DHCDoc.DHCDocConfig.OrderClassify).GetAdmOrdClassify(EpisodeID,"Drainage")
	d SetJsonValue("Drainage",Drainage)
	//护理
	s TendOrd=##Class(DHCDoc.DHCDocConfig.OrderClassify).GetAdmOrdClassify(EpisodeID,"TendOrd")
	d SetJsonValue("TendOrd",TendOrd)
	//特殊护理
	s OrderKind=##Class(DHCDoc.DHCDocConfig.OrderClassify).GetAdmOrderKind(EpisodeID)
	d SetJsonValue("OrderKind",OrderKind)
	/*
	护理
	*/
	s NurCurLastVal=##class(Nur.OverViewInterface).GetCurLastVal(EpisodeID)
	//体温
	s Temperature=$P(NurCurLastVal,"^",1)
	s TempRule=##class(Nur.OverViewInterface).GetObsRule("temperature")
	if (Temperature'=""){
		if (TempRule'="")&&(($P(TempRule,"^",1)>Temperature)||($P(TempRule,"^",2)<Temperature)){
			s Temperature=$$SetPerilStyle(Temperature)
		}
	}else{
		s Temperature=..%Translate("ipdoc.patinfoview.csp","无")
	}
	d SetJsonValue("Temperature",Temperature)
	//收缩压\舒张压
	s SysPressure=$P(NurCurLastVal,"^",2)
	s DiaPressure=$P(NurCurLastVal,"^",3)
	s BloodPressure=""
	if (SysPressure'="")||(DiaPressure'=""){
		s BloodPressure=SysPressure_"/"_DiaPressure
	}
	//s BPRule=##class(Nur.OverViewInterface).GetObsRule("bloodPressure")
	s SPRule=##class(Nur.OverViewInterface).GetObsRule("sysPressure") //收缩压
	s DPRule=##class(Nur.OverViewInterface).GetObsRule("diaPressure") //舒张压
	if (BloodPressure'=""){
		if ((SPRule'="")&&(($P(SPRule,"^",1)>SysPressure)||($P(SPRule,"^",2)<SysPressure)))
			||((DPRule'="")&&(($P(DPRule,"^",1)>DiaPressure)||($P(DPRule,"^",2)<DiaPressure))){
			s BloodPressure=$$SetPerilStyle(BloodPressure)
		}
	}else{
		s BloodPressure=..%Translate("ipdoc.patinfoview.csp","无")
	}
	
	d SetJsonValue("BloodPressure",BloodPressure)
	//脉搏
	s Pulse=$P(NurCurLastVal,"^",4)
	s PulseRule=##class(Nur.OverViewInterface).GetObsRule("pulse")
	if (Pulse'=""){
		if (PulseRule'="")&&(($P(PulseRule,"^",1)>Pulse)||($P(PulseRule,"^",2)<Pulse)){
			s Pulse=$$SetPerilStyle(Pulse)
		}
	}else{
		s Pulse=..%Translate("ipdoc.patinfoview.csp","无")
	}
	d SetJsonValue("Pulse",Pulse)
	//T.P.R
	d SetJsonValue("TPRData",Temperature_"|"_BloodPressure_"|"_Pulse)
	
	/*
	临床路径
	*/
	//临床路径信息
	/*
	///路径名称_$c(1)_入径天数_$c(1)_当前阶段_$c(1)_状态
	//##class(web.DHCCPW.IO.Service).GetCPWInfoByPaadm(EpisodeID) 
	s CPWInfo=##class(DHCMA.CPW.IO.ToDoc).GetCPWInfoByAdm(EpisodeID) 
	///$s(CPWStatus="I":"入径",CPWStatus="O":"出径",CPWStatus="C":"完成",1:"")
	if ($P(CPWInfo,$C(1))'=""){
		s CPWStatus=$p(CPWInfo,$C(1),4)
		if (CPWStatus="入径"){
			s ClinicalInfo=$p(CPWInfo,$C(1))_"-第"_$P(CPWInfo,$C(1),2)_"天-"_$P(CPWInfo,$C(1),3)
		}else{
			s ClinicalInfo=$p(CPWInfo,$C(1))_"-"_CPWStatus
		}
		d SetJsonValue("ClinicalInfo",ClinicalInfo)
	}else{
		d SetJsonValue("ClinicalInfo",..%Translate("ipdoc.patinfoview.csp","未入径"))
	}*/
	s CPWInfo=##class(DHCMA.CPW.IO.ToDoc).GetCPWInfoByAdmNew(EpisodeID)
	if ((CPWInfo'="")&&(CPWInfo'="-999")){
		s Arr=##Class(DHCDoc.Util.ArrayData).%New()
		s json=Arr.%FromJSON(CPWInfo)
		s CPWName=json.Data("CPWName")				// 路径名称
		s Status=json.Data("Status")				// 路径状态
		s CurEpis=json.Data("CurEpis")				// 当前阶段	
		s CIIcon=json.Data("CIIcon")				// 已入径天数
		s CPWDays=json.Data("CPWDays")				// 路径图标ur1 (点击打开临床路径页面) 
		s CITip=json.Data("CITip")					// 路径图标提示信息
		s COIcon=json.Data("COIcon")				// 路径医嘱图标url(点击打开医嘱页面并弹出临床路径医嘱界面)
		s COTip=json.Data("COTip")					// 路径医嘱图标提示信息
		s OrdPageType=json.Data("OrdPageType")		// 打开医嘱图标打开页面参数：W：打开医嘱录入页面；C：打开草药医嘱录入页面
		s ClinicalInfo=CPWName_"-"_Status_"-"_..%Translate("ipdoc.patinfoview.csp","第")_CPWDays_..%Translate("ipdoc.patinfoview.csp","天")_"-"_CurEpis
		//s ClinicalInfo=ClinicalInfo_"<img src='"_CIIcon_"'>"
		s ClinicalInfoIcon="<a href='#' title='"_..%Translate("ipdoc.patinfoview.csp",CITip)_"' class='hisui-tooltip' data-options=""position:'left';"" onclick='ipdoc.pattreatinfo.view.ClinicalIconClick(1);'>"
		s ClinicalInfoIcon=ClinicalInfoIcon_"<img src='"_CIIcon_"'></a>"
		s ClinicalInfoIcon=ClinicalInfoIcon_"<a href='#' title='"_..%Translate("ipdoc.patinfoview.csp",COTip)_"' class='hisui-tooltip' data-options='position:'top';'>"
		if (OrdPageType="W"){
			s ClinicalInfoIcon=ClinicalInfoIcon_"<img src='"_COIcon_"' onclick='ipdoc.pattreatinfo.view.ClinicalIconClick(2);'>"
		}elseif (OrdPageType="C"){
			s ClinicalInfoIcon=ClinicalInfoIcon_"<img src='"_COIcon_"' onclick='ipdoc.pattreatinfo.view.ClinicalIconClick(3);'>"
		}
		s ClinicalInfoIcon=ClinicalInfoIcon_"</a>"
		d SetJsonValue("ClinicalInfo",ClinicalInfo)
		d SetJsonValue("ClinicalInfoIcon",ClinicalInfoIcon)
	}else{
		d SetJsonValue("ClinicalInfo",..%Translate("ipdoc.patinfoview.csp","未入径"))
		d SetJsonValue("ClinicalInfoIcon","<img>")
	}
	/*
	检查数量
	*/
	s (Exam1,Exam2,Exam3)=0
	s rset=##Class(%ResultSet).%New("web.DHCAPPPisInterface.QryPatExaList")
	If rset.QueryIsValid() {
		Set Status=rset.Execute(EpisodeID,UserCode)
		If 'Status Quit
		Set columns = rset.GetColumnCount()
		if (columns=0) Quit
		While (rset.Next()) {
			s ItmStatus=rset.GetData(1)
			if (ItmStatus="申请"){
				s Exam1=Exam1+1
			}elseif (ItmStatus="报告"){
				s Exam3=Exam3+1
			}else{
				s Exam2=Exam2+1
			}
		}
	}
	d SetJsonValue("Exam_1",Exam1)
	d SetJsonValue("Exam_2",Exam2)
	d SetJsonValue("Exam_3",Exam3)
	d SetJsonValue("ExamCount",(Exam1+Exam2+Exam3))
	
	/*
	检验数量
	*/
	//s labrset=##Class(LabService.TSResult).GetSomeQtyInfoByAdmNo(EpisodeID)
	s labrset=..GetSomeQtyInfoByAdmNo(EpisodeID,UserID)
	d SetJsonValue("Lab_1",$P(labrset,"^",1))
	d SetJsonValue("Lab_2",$P(labrset,"^",2))
	d SetJsonValue("Lab_3",$P(labrset,"^",3))
	d SetJsonValue("LabCount",$P(labrset,"^",1)+$P(labrset,"^",2)+$P(labrset,"^",3))
	
	/*
	心电监测
	*/
	s EkgOrdList=##class(web.DHCDocInPatPortalCommon).GetEkgOrdList($g(EpisodeID),UserID)
	d SetJsonValue("EkgOrd",EkgOrdList)
	/*
	危急值报告
	*/
	s CVReportNum=##Class(web.DHCAntService).GetReportWarnNum(EpisodeID)
	d SetJsonValue("CVReport",CVReportNum)
	/*
	病程记录
	select * from EMRmeta.EMRTemplateCategory where CategoryType="CategoryChapter" and CategoryName like '%病程%'
	select * from EMRmeta.EMRTemplateCategory 
where  CategoryType="TempCate" and CategoryName like "%%"
	*/
	s EMRRecordInfo=##Class(EMRservice.BIEMRService).GetEMRRecordInfo(EpisodeID)
	//s EMRRecordInfo=##Class(EPRservice.Quality.DataAccess.BOQualityMessage).GetEMRRecordInfo(EpisodeID,"66")
	d SetJsonValue("EMRRecord",EMRRecordInfo)
	//当天出入总量 liquidln 总入量 liquidOut 总出量
	s (liquidln,liquidOut)=0
    s rset=##Class(%ResultSet).%New("Nur.OverViewInterface.GetTempData")
	If rset.QueryIsValid() {
		Set Status=rset.Execute(+$h,+$h,EpisodeID,"liquidln")
		If 'Status Quit
		Set columns = rset.GetColumnCount()
		if (columns=0) Quit
		While (rset.Next()) {
			s liquidln=rset.GetDataByName("OBSValue")
		}
	}
	s rset=##Class(%ResultSet).%New("Nur.OverViewInterface.GetTempData")
	If rset.QueryIsValid() {
		Set Status=rset.Execute(+$h,+$h,EpisodeID,"liquidOut")
		If 'Status Quit
		Set columns = rset.GetColumnCount()
		if (columns=0) Quit
		While (rset.Next()) {
			s liquidOut=rset.GetDataByName("OBSValue")
		}
	}
    s AmountOfInputAndOutPut=liquidln_"/"_liquidOut_" ml"
    d SetJsonValue("AmountOfInputAndOutPut",AmountOfInputAndOutPut)
    s mradm=$p(^PAADM(EpisodeID),"^",61)
    //体重
    s Weight=$p($g(^MR(mradm,"PRO",1)),"^",27)
    if (Weight=""){
		s Weight=##Class(Nur.CommonInterface.Temperature).getLastItemValue(EpisodeID,"weight") 
	}
	if (Weight'="") s Weight=Weight_"Kg"
	else  s Weight=..%Translate("ipdoc.patinfoview.csp","无")
	d SetJsonValue("Weight",Weight)
	 //身高
    s Height=$p($g(^MR(mradm,"PRO",1)),"^",20)
    if (Height=""){
		s Height=##Class(Nur.CommonInterface.Temperature).getLastItemValue(EpisodeID,"height") 
    }
    if (Height'="") s Height=Height_"CM"
	else  s Height=..%Translate("ipdoc.patinfoview.csp","无")
    d SetJsonValue("Height",Height)
    
    ;治疗申请数量
    s CureAppNum=##Class(DHCDoc.DHCDocCure.Service).GetCureAppListNum(EpisodeID)
	d SetJsonValue("DocCureApp",CureAppNum)
	Q JsonObj.%ToJSON()
SetJsonValue(IDName,Value)
	s SubJsonData={}
	do SubJsonData.%Set("id",IDName)
	s Value=$CASE(Value,"":..%Translate("ipdoc.patinfoview.csp","无"),:Value)
	do SubJsonData.%Set("Value",Value)
	do JsonObj.%Push(SubJsonData,"")
	q
SetPerilStyle(Value)
	s Value="<span style=""color:red"">"_Value_"</span>"
	q Value
}

/// 获取患者诊疗明细部分信息
/// w ##Class(web.DHCDocInPatPortalCommon).GetAdmOrdClassifyDetailJson(66,"TendOrd")
ClassMethod GetAdmOrdClassifyDetailJson(EpisodeID As %String, ClassifyCode As %String) As %String
{
	s ArcimList=##Class(DHCDoc.DHCDocConfig.OrderClassify).GetAdmOrdClassify(EpisodeID,ClassifyCode,.DataList)
	Set langid=..%LanguageID()
	s JsonObj=[]
	for i=1:1:$L(DataList,"^") {
		s oneDataList=$P(DataList,"^",i)
		s ARCIMDR=$P(oneDataList,$C(1),2)
		continue:(+ARCIMDR=0)
		if (1=##Class(web.DHCDocOrderEntry).ValARCItem(ARCIMDR)){
			continue
		}
		s GROUPID=%session.Get("LOGON.GROUPID")
		s AdmDepId=$P($G(^PAADM(EpisodeID)),"^",4)
		s UserRowId=%session.Get("LOGON.USERID")
		s CurLogonDep=%session.Get("LOGON.CTLOCID")
		s PatientID=$P($G(^PAADM(EpisodeID)),"^",1)
		s OrderAuthInValid=##class(web.DHCDocOrderEntry).ValOrd("ARCIM",GROUPID,ARCIMDR,"I",AdmDepId,UserRowId,CurLogonDep,"","",PatientID,EpisodeID)
		if (OrderAuthInValid=0) continue
		s JsonData={}
		s Desc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",$P(oneDataList,$C(1),1),langid)
		do JsonData.%Set("Desc",Desc)
		do JsonData.%Set("Value",ARCIMDR)
		do JsonData.%Set("Checked",$P(oneDataList,$C(1),3))
		do JsonData.%Set("OrdItem",$P(oneDataList,$C(1),4))
		do JsonObj.%Push(JsonData,"")
	}
	
	s JsonInfo=""
	s obj=##class(%Stream.GlobalCharacter).%New()
	do JsonObj.%ToJSON(obj)
	While 'obj.AtEnd { 
		s JsonInfo=JsonInfo_obj.ReadLine(,.sc,.eol)
	}
	s JsonInfo=$replace(JsonInfo,"""","'")
	q JsonInfo
}

/// 切换医嘱
/// 就诊号，需替换医嘱ID，新医嘱项目ID
/// Params:UserID^LocRowID^
/// w ##Class(web.DHCDocInPatPortalCommon).SwitchAdmOrd(94,"91||210","10057||1","4634^110^TendOrd")
ClassMethod SwitchAdmOrd(EpisodeID As %String, CurrOrd As %String, NewArcimDr As %String, Params As %String, PPRowId = "") As %String
{
	//需替换医嘱应该要走互斥的程序，不需要在单独进行停止操作，直接进行下医嘱操作即可
	//w ##class(web.DHCOEOrdItem).InsertOrderItem(4,"1038||1^R^5^26/04/2012^10:01^^0.92^98^1^1038||1^^10^149^10^4^63^2^1^^1^N^^Y^^^^^^^N^^^^^^^^^^N^^^^^^^^N^^1038||1^R^5^26/04/2012^10:02^^0.92^98^1^1038||1^^10^149^10^4^63^2^1^^2^N^^Y^^^^^^^N^^^^^^^^^^N^^^^^^^^N^^1038||1^R^5^26/04/2012^10:26^^0.92^98^1^1038||1^^10^149^10^4^63^2^1^^3^N^^Y^^^^^^^N^^^^^^^^^^N^^^^^^^^N^^",102,7,174,"")
	s ^tantmp("SwitchAdmOrd")=EpisodeID_","_CurrOrd_","_NewArcimDr_","_Params_","_PPRowId
	s UserID=$P(Params,"^",1)
	s Loc=$P(Params,"^",2)
	s ClassifyCode=$P(Params,"^",3)
	s Doc=##class(web.SSUser).GetDefaultCareProvider(UserID)
	s HospDr=$P(^CTLOC(Loc),"^",22)
	s ItemCatDR=$p(^ARCIM(+NewArcimDr,$p(NewArcimDr,"||",2),1),"^",10)
	s ItemOrderType=$P(^ARC("IC",ItemCatDR),"^",7)
	s startdate=$ZD(+$H,3)
	s starttime=..%ZT(..%SysTime())
	s oeprice=""
	s PHPrescType=##Class(web.DHCDocOrderCommon).GetPHPrescType(ItemCatDR,HospDr,NewArcimDr)
	s DrgformRowid=##class(web.DHCDocOrderEntry).GetDrgForm(NewArcimDr)
	s MasterSeqNo=""
	s OrderSeqNo="1"
	s ARCOSRowid=""
	if (CurrOrd'=""){
		s CurrOrd=$p(CurrOrd,"^",1)
		s OrderID=+CurrOrd
		s SubID=$P(CurrOrd,"||",2)
		s PriorRowid=$O(^OECPR(0,"Code","S",0)) //$P($G(^OEORD(OrderID,"I",SubID,1)),"^",8)
		s PackQty=$P($G(^OEORD(OrderID,"I",SubID,9)),"^",4)
		s RecDepRowid=$P($G(^OEORD(OrderID,"I",SubID,3)),"^",6)
		s AdmReason=$P($G(^OEORD(OrderID,"I",SubID,11)),"^",18)
		s DepProcNotes=""	//$g(^OEORD(OrderID,"I",SubID,"DEP",1))
		s DoseQty=$P($G(^OEORD(OrderID,"I",SubID,2)),"^",1)
		s DoseUOMRowid=$P($G(^OEORD(OrderID,"I",SubID,2)),"^",3)
		s DoseqtySum=$p($g(^OEORD(OrderID,"I",SubID,1)),"^",12)
		s FreqRowid=$P($G(^OEORD(OrderID,"I",SubID,2)),"^",4) ; OEORI_PHFreq_DR
		s OrderFreqWeek=""
		if (FreqRowid'="") {
			s WeekFlag=$P(^PHCFR(FreqRowid),"^",9)
			i WeekFlag="Y" s OrderFreqWeek=$p($g(^OEORD(+OrderID,"I",SubID,"DHC")),"^",55)
		}
		s DurRowid=$P($G(^OEORD(OrderID,"I",SubID,2)),"^",6)
		s InstrRowid=$P($G(^OEORD(OrderID,"I",SubID,2)),"^",7)
		s SkinTest=$P($G(^OEORD(OrderID,"I",SubID,5)),"^",2)
		s PhSpecInstr=$P($G(^OEORD(OrderID,"I",SubID,2)),"^",8)
		s CoverMainIns=$p($g(^OEORD(OrderID,"I",SubID,3)),"^",3)
		s ActionRowid=$p($g(^OEORD(OrderID,"I",SubID,11)),"^",21)
		s FirstDayTimes=1
	}else{
		s PriorRowid=$O(^OECPR(0,"Code","S",0))
		s PackQty=1,DoseqtySum=1
		Set CFRecLocByLogonLoc=$$GetDHCCTLOCFieldValue^DHCDocConfig(Loc,1)
		if CFRecLocByLogonLoc=1 Set RecDepRowid=$$GetLocRecLoc^DHCDocOrderCommonNew(Loc,NewArcimDr)
		else  Set RecDepRowid=$$GetRecloc^DHCDocOrderCommonNew(EpisodeID,NewArcimDr)
		q:RecDepRowid="" "100"_$C(2)_"没有维护接收科室!"
		Set AdmReason=$P(^PAADM(EpisodeID,1),"^",7)
		s DepProcNotes=""
		s (DoseQty,DoseUOMRowid,FreqRowid,DurRowid,InstrRowid)=""
		s SkinTest="N"
		s PhSpecInstr=""
		s CoverMainIns=""
		
		s ActionRowid=""
		s FirstDayTimes=1
		s EndDate=""
		s EndTime=""
		s ExecuteDateStr=""
		s NotifyClinician=""
		s DIACatRowId=""
		s InsurCatRowId=""
		s SpeedFlowRate=""
		s OrderFreqWeek=""
	}
	s sep="^"
	s CFIPPilotPatAdmReason=##Class(web.PilotProject.DHCDocPPGroupSeting).GetCFGValue(HospDr,"IPPilotPatAdmReason")
	if (PPRowId'=""){
		s:CFIPPilotPatAdmReason'="" AdmReason=CFIPPilotPatAdmReason	
	}
	s OrdItem=NewArcimDr_sep_ItemOrderType_sep_PriorRowid_sep_startdate_sep_starttime
	s OrdItem=OrdItem_sep_PackQty_sep_oeprice_sep_RecDepRowid_sep_AdmReason_sep_DrgformRowid
	s OrdItem=OrdItem_sep_DepProcNotes_sep_DoseQty_sep_DoseUOMRowid_sep_DoseqtySum_sep_FreqRowid
	s OrdItem=OrdItem_sep_DurRowid_sep_InstrRowid_sep_PHPrescType_sep_MasterSeqNo_sep_OrderSeqNo
	s OrdItem=OrdItem_sep_SkinTest_sep_PhSpecInstr_sep_CoverMainIns_sep_ActionRowid_sep_ARCOSRowid
	Set $p(OrdItem,sep,33)=FirstDayTimes
	Set $p(OrdItem,sep,56)=PPRowId
	Set $p(OrdItem,sep,67)=OrderFreqWeek
	s ExpStr="1^^^^"
	s ret=##class(DHCDoc.Interface.Inside.ServiceOrd).SaveOrderItems(EpisodeID,OrdItem,UserID,Loc,Doc,"",ExpStr)
	if (ret=100)||(ret=0) {
		q ret
	}
	s DataList=""
	d ##Class(DHCDoc.DHCDocConfig.OrderClassify).GetAdmOrdClassify(EpisodeID,ClassifyCode,.DataList)
	s OrdList=""
	s ArcimDrList=""
	s ArcimDescList=""
	for i=1:1:$L(DataList,"^") {
		s val=$P(DataList,"^",i)
		s Selection=$P(val,$C(1),3)
		continue:(Selection'="1")
		s ARCIMDesc=$P(val,$C(1),1)
		s ARCIMDR=$P(val,$C(1),2)
		s myOrdList=$P(val,$C(1),4)
		b ;-
		if (OrdList=""){
			s OrdList=myOrdList
		}else{
			s OrdList=OrdList_"^"_myOrdList
		}
		if (ArcimDrList=""){
			s ArcimDrList=ARCIMDR
		}else{
			s ArcimDrList=ArcimDrList_"^"_ARCIMDR
		}
		if (ArcimDescList=""){
			s ArcimDescList=ARCIMDesc
		}else{
			s ArcimDescList=ArcimDescList_","_ARCIMDesc
		}
	}
	
	q OrdList_$C(2)_ArcimDrList_$C(2)_ArcimDescList
}

ClassMethod CheckBeforeSwitchAdmOrd(EpisodeID As %String, CurrOrd As %String, NewArcimDr As %String, PPRowId = "") As %String
{
	s warning=""
	s PAADMBedDR=$p($g(^PAADM(EpisodeID)),"^",73)
	s PAADMDocDR=$p($g(^PAADM(EpisodeID)),"^",9)
	s VisitStatus=$p($g(^PAADM(EpisodeID)),"^",20)
	s FinFlag=$p($g(^PAADM(EpisodeID)),"^",45)
	s GroupID=%session.Get("LOGON.GROUPID")
	s HospId=%session.Get("LOGON.HOSPID")
	s DocID=$P(^SSU("SSUSR",%session.Data("LOGON.USERID")),"^",14)
	s CareProvType=##class(web.DHCDocOrderCommon).GetCareProvType(%session.Get("LOGON.USERID"))
	s HaveMidDischarged=##class(web.DHCDocOrderCommon).GetIsMidDischarged(EpisodeID)
	if (HaveMidDischarged=1)||(HaveMidDischarged=2) {
		s warning="医生开立出院医嘱后,不允许录入长期医嘱!"
		q warning
	}
	s CurrentDischargeStatus=##class(web.DHCDischargeHistory).GetCurrentDischargeStatus(EpisodeID)
	s CFIPNeedDoctor=..%GetConfig("IPNeedDoctor")
	
	if (##class(web.DHCDocMain).isDischg(EpisodeID)) && (CurrentDischargeStatus="B") {
		s warning="费用调整状态的患者不允许开出长期医嘱！"
		q warning
	}
	s DiagnoseCount=##Class(web.DHCAPPExaReport).GetMRDCount(EpisodeID,GroupID,NewArcimDr)
	if (DiagnoseCount=0) {
		s OrdNeedMMDiag=0
		;医嘱录入必须有西医诊断子类
	 	s OrdNeedMMDiagCat=..%GetConfig("OrdNeedMMDiagCat",HospId)
	 	if (NewArcimDr'="") {
		 	s ItemCatRowid=##class(web.DHCDocOrderCommon).GetOrderSubCat(NewArcimDr)
		 	if ("^"_OrdNeedMMDiagCat_"^")[("^"_ItemCatRowid_"^") s OrdNeedMMDiag=1
		}
		if (OrdNeedMMDiag=0) s warning="没有诊断,请先录入!"
		else  s warning="没有西医诊断,请先录入!"
		Q warning
	}
	/*s mradm=$p($g(^PAADM(EpisodeID)),"^",61)
	s PAADMMotherAdmId=$p($g(^PAADM(EpisodeID)),"^",75)
	s DiagnoseCount = ##class(web.DHCDocOrderEntry).GetMRDiagnoseCount(mradm)
	if (DiagnoseCount=0)&&(PAADMMotherAdmId=""){
		s warning="没有诊断,请先录入!"
		Q warning
	}*/
	s warning=##Class(web.DHCDocViewDataInit).GetOrdEntryWarning(EpisodeID)
	Q:warning'="" warning
	if (PPRowId'="") {
		s res=##Class(web.PilotProject.DHCDocPilotProject).CheckIsFreeOrd(EpisodeID,PPRowId,NewArcimDr)
	 	i (+res=-1) {
		 	s ErrCode=$p(res,"^",1) s ErrMsg=$p(res,"^",2)
		 	Q ErrMsg
		}
	}
	if (CurrOrd="") {
		Set CFRecLocByLogonLoc=$$GetDHCCTLOCFieldValue^DHCDocConfig(%session.Data("LOGON.CTLOCID"),1)
		if CFRecLocByLogonLoc=1 Set RecDepRowid=$$GetLocRecLoc^DHCDocOrderCommonNew(%session.Data("LOGON.CTLOCID"),NewArcimDr)
		else  Set RecDepRowid=$$GetRecloc^DHCDocOrderCommonNew(EpisodeID,NewArcimDr)
		Q:RecDepRowid="" "没有维护接收科室!"
		s PackQty=1
	}else{
		s PackQty=$P($G(^OEORD(+CurrOrd,"I",$p(CurrOrd,"||",2),9)),"^",4)
		s RecDepRowid=$P($G(^OEORD(+CurrOrd,"I",$p(CurrOrd,"||",2),3)),"^",6)
	}
	s PatType=$P(^PAADM(EpisodeID,1),"^",6)
	s PatType=##class(web.UDHCJFBILL).GetPatTypeByRecLoc(PatType,RecDepRowid)
	s PAADMRegConDisDR=$P($G(^PAADM(EpisodeID,"DHC")),"^",25)
	s ExpStrin=PAADMRegConDisDR_"^^^"_EpisodeID_"^"_RecDepRowid_"^"_""_"^"_""
	s retPrice=##class(web.UDHCJFPRICE).GetOrderPrice(PatType, PatType, NewArcimDr, +$h, "", "", "", "","",ExpStrin)
	s Price=$P(retPrice,"^",1)
	s amount=PackQty*Price
	s ret=##Class(web.DHCAPPExaReport).GetArrearsManage(EpisodeID,%session.Data("LOGON.GROUPID"),%session.Data("LOGON.CTLOCID"), amount)
    Q ret
}

Query FindOrderExecDet(orderId, execStDate, execEndDate, execStatus = "") As websys.Query(ROWSPEC = "OrderExecId:%String,TItemStatCode:%String,CustomSelected:%String:选择^40,TExStDate:%String:要求执行时间^110,TExecState:%String:状态,TExecStateCode:%String:状态代码,TRealExecDate:%String:执行时间,THourExEnTime:%String:小时医嘱结束时间,TExecRes:%String:执行原因,TExecFreeRes:%String:免费原因,TExecUser:%String:处理人,TExecLoc:%String:处理Loc,TBillState:%String:帐单状态,TExecFreeChargeFlag:%String:免费状态,TgiveDrugQty:%String:发药数量,TcancelDrugQty:%String:退药数量,TPBOID:%String:帐单号,TApplyCancelStatus:%String:申请撤销状态,TApplyCancelStatusCode:%String:申请撤销状态,IsCanExecOrdArrear:%String:欠费执行标志,TExDateTimes:%String:要求执行次数,IsCancelArrivedOrd:%String,Notes:%String:备注^100,ExecPart:%String:检查部位^100,TPriorityCode:%String,TBillUom:%String,OrdExecBillQty:%String,IsCancelDispenOrd:%String,CoverMainIns:%String")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCDocInPatPortalCommon","FindOrderExecDet","443||379","2018-02-02","2018-02-03")
ClassMethod FindOrderExecDetExecute(ByRef qHandle As %Binary, orderId, execStDate = "", execEndDate = "", execStatus = "") As %Status
{
	s ^tempscl("FindOrderExecDet")=orderId_","_execStDate_","_execEndDate
	set repid = $I(^CacheTemp)
	if $g(ind) = "" set ind = 0
	
	s ^||RepidTemp("web.DHCDocInPatPortalCommon","FindOrderExecDet","CacheTemp")=repid
	i orderId="" set qHandle = $lb(0,repid,0)  Q $$$OK
	K ^||TMP
	s ^Temp("wanghc","orderId")=orderId_","_execStDate_","_execEndDate
	s:execStDate'="" execStDate=..%ZDH(execStDate) //$zdh(execStDate,3)
	s:execEndDate'="" execEndDate=..%ZDH(execEndDate) //$zdh(execEndDate,3)
	s order = +orderId
	s ordItem = $p(orderId,"||",2)
	s pb=""
	s pb=$o(^DHCPBi(0,"OEORI",orderId,""),-1)
	S SessionLocId = %session.Data("LOGON.CTLOCID")
	S EpisodeID = $p(^OEORD(order),"^",1)
	s deptDesc=""
	Set langid=..%LanguageID()
	i (order>0) &&(ordItem>0) d
	.s ordDept = $p(^OEORD(order,"I",ordItem,1),"^",3)
	.s:+ordDept>0 deptDesc = $p(^CTLOC(ordDept),"^",2)
	.s deptDesc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",deptDesc,langid)
	.s TOrderStatusDR=$p(^OEORD(order,"I",ordItem,1),"^",13)
	.s:+TOrderStatusDR>0 TItemStatCode = $p(^OEC("OSTAT",TOrderStatusDR),"^",1)
	
	s orderExecId=0
	f  s orderExecId=$O(^OEORD(order,"I",ordItem,"X",orderExecId)) q:orderExecId=""  d
	.s (TExecDate,TExecState,TExecStateCode,TExecRes,TExecFreeRes,TRealExecDate,TExecUser,TExecLoc,TBillState,TExecFreeChargeFlag,TgiveDrugQty,TcancelDrugQty,pbo,TPBOID,TExStTimeDesc)=""
	.S (TApplyCancelStatus,TApplyCancelStatusCode,ExecResDr)=""
	.s str = ^OEORD(order,"I",ordItem,"X",orderExecId)
	.s CtpcpDR = $p(str,"^",15)
	.s:(+CtpcpDR>0)&&($d(^CTPCP(CtpcpDR,1))=1) TExecUser = $p(^CTPCP(CtpcpDR,1),"^",2)
	.Set TExecUser= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",TExecUser,langid)
	.s TExStDate = $p(str,"^",1)			// OEORE_ExStDate
	.q:(execStDate'="")&&(TExStDate<execStDate)
	.q:(execEndDate'="")&&(TExStDate>execEndDate)
	.;s TOrderStatusDR=$p(^OEORD(order,"I",ordItem,"X",orderExecId,"BILL"),"^",1) ;OEORE_OrderStatus_DR
	.s TExecFreeChargeFlag=""
	.s:$d(^OEORD(order,"I",ordItem,"X",orderExecId,"BILL")) TExecFreeChargeFlag=$p(^OEORD(order,"I",ordItem,"X",orderExecId,"BILL"),"^",18)	;OEORE_FreeChargeFlag
	.s TExecFreeChargeFlag=$s(TExecFreeChargeFlag="Y":"免费",1:"")
	.s TExecFreeChargeFlag=..%Translate("ipdoc.patinfoview.csp",TExecFreeChargeFlag)
	.s TExStTime = $p(str,"^",2)			// OEORE_ExStTime
	.i TExStDate'="" d
	..s TExStDate1=..%ZD(TExStDate)
	..i TExStDate1["-" s TExStDateDesc=$p(TExStDate1,"-",2,3)
	..i TExStDate1["/" s TExStDateDesc=$p(TExStDate1,"/",1,2)
	..//s TExStDateDesc = $p($zd(TExStDate,3),"-",2,3)
	.s:TExStTime'="" TExStTimeDesc =..%ZT(TExStTime,1) //..%ZT(TExStTime,2)
	.s TExecDate = $p(str,"^",19)		// OEORE_DateExecuted
	.i TExecDate'=""  d
	..s TExecDate=..%ZD(TExecDate)
	..i TExecDate["-" s TExecDate=$p(TExecDate,"-",2,3)
	..i TExecDate["/" s TExecDate=$p(TExecDate,"/",1,2)
	..//s TExecDate = $p($zd(TExecDate,3),"-",2,3)
	.s TExecTime = $p(str,"^",20)		// OEORE_TimeExecuted
	.s:TExecTime'="" TExecTime = ..%ZT(TExecTime,1) //..%ZT(TExecTime,2)
	.s THourExEnTime=$p(str,"^",36)
	.i THourExEnTime'="" d
	..s THourExEnTime=..%ZT(THourExEnTime,1)
	..s:TExStTime'="" TExStTimeDesc = ..%ZT(TExStTime,1)
	.s ExecStateDR= $p(str,"^",16)
	.i +ExecStateDR>0 s TExecState = $p(^OEC("STAT",ExecStateDR),"^",2),TExecStateCode=$p(^OEC("STAT",ExecStateDR),"^",1)	;OEC_Order_AdminStatus
	.e  s TExecState = "未执行",TExecStateCode="未执行"
	.q:(execStatus="V")&&(" 未执行 C "'[(" "_TExecStateCode_" "))
	.q:(execStatus'="")&&(execStatus'="V")&&(TExecStateCode'=execStatus)
	.s TExecState=..%Translate("ipdoc.patinfoview.csp",TExecState)
	.s TExecStateCode=..%Translate("ipdoc.patinfoview.csp",TExecStateCode)
	.;找申请撤销表中的状态
	.Set appId = $o(^User.DHCAPPI("IndexTypeItem"," E"," "_order_"||"_ordItem_"||"_orderExecId,""))
	.If +appId'=0 d
	..Set CurrentStatus = $lg(^User.DHCAPPD(appId),4)		
	..Set CurrentStatusDesc = $p(^OEC("APPSTAT",CurrentStatus),"^",2) 
	..Set CurrentStatusCode = $p(^OEC("APPSTAT",CurrentStatus),"^",1)
	..Set TApplyCancelStatus=CurrentStatusDesc,TApplyCancelStatusCode=CurrentStatusCode
	.;执行的原因
	.i $d(^OEORD(order,"I",ordItem,"X",orderExecId,"STCH"))=10 d
	..s STCHSub = $o(^OEORD(order,"I",ordItem,"X",orderExecId,"STCH",""),-1)		;OE_OrdExecStatus
	..s:STCHSub>0 ExecResDr = $p(^OEORD(order,"I",ordItem,"X",orderExecId,"STCH",STCHSub),"^",2) ;STCH_Reason_DR
	..s:ExecResDr>0 TExecRes= $p(^OEC("ASCR",ExecResDr),"^",2)	;OEC_AdminStatusChReason->ASCR_Desc
	..s TExecRes=##class(User.OECAdminStatusChReason).GetTranByDesc("ASCRDesc",TExecRes,langid)
	..i TExecRes="" s TExecRes=$p(^OEORD(order,"I",ordItem,"X",orderExecId,"STCH",STCHSub),"^",6)
	.;免费原因
	.i $d(^OEORD(order,"I",ordItem,"X",orderExecId,"FCCH"))=10 d
	..s FCCHSub = $o(^OEORD(order,"I",ordItem,"X",orderExecId,"FCCH",""),-1)		;OE_OrdExecFreeCharge
	..s:FCCHSub>0 ExecResDr = $p(^OEORD(order,"I",ordItem,"X",orderExecId,"FCCH",FCCHSub),"^",2) ;FCCH_Reason_DR
	..s:ExecResDr>0 TExecFreeRes= $p(^OEC("ASCR",ExecResDr),"^",2)	;OEC_AdminStatusChReason->ASCR_Desc
	.;取执行记录上的执行科室
	.i $d(^OEORD(order,"I",ordItem,"X",orderExecId,"NUR")) d
	..s TExecLocDr=$p(^OEORD(order,"I",ordItem,"X",orderExecId,"NUR"),"^",30) 
	..s TExecLoc=$s(TExecLocDr="":"",1:$P($g(^CTLOC(TExecLocDr)),"^",2))
	..s TExecLoc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",TExecLoc,langid)
	.;s TExecLoc = deptDesc
	.s TBillState = $p(str,"^",6)
	.s TBillState=$s(TBillState="B":"计费", TBillState="P":"结算", TBillState="I":"停止后未做账单", TBillState="R":"已退费",1:"需要计费") ;TBillState="TB":"需要计费", 
	.s TBillState=..%Translate("ipdoc.patinfoview.csp",TBillState)
	.s drugRtnInfo=##class(PHA.FACE.OUT.Com).GetOeoreQtyData(orderId_"||"_orderExecId) ;返回：总数量^已发数量^已退数量^单位ID^单位名称
	.s TgiveDrugQty = $p(drugRtnInfo,"^",2)
	.s TcancelDrugQty = $p(drugRtnInfo,"^",3)
	.s TGiveDrugUom = $p(drugRtnInfo,"^",5)
	.s TGiveDrugUom=##class(User.CTUOM).GetTranByDesc("CTUOMDesc",TGiveDrugUom,langid)
	.s TgiveDrugQty=TgiveDrugQty_TGiveDrugUom,TcancelDrugQty=TcancelDrugQty_TGiveDrugUom
	.s:+pb>0 pbo= $o(^DHCPB(0,"OEEXC",orderId_"||"_orderExecId,pb,0))
	.s:+pbo>0 TPBOID=pb_"||"_pbo
	.s IsCanExecOrdArrear = ##class(web.DHCDocMainOrderInterface).IsCanExecOrdArrear(EpisodeID,orderId_"||"_orderExecId,SessionLocId)
	.//判断是否已经治疗,已经治疗的执行记录不能撤销执行
	.s IsCancelArrivedOrd=1
	.i $d(^DHCDocCure(0,"OEORE",orderId_"||"_orderExecId)) d
	..s DCARowId=$o(^DHCDocCure(0,"OEORE",orderId_"||"_orderExecId,""))
	..i DCARowId'="" d 
	...s DCAAChildSub=$O(^DHCDocCure(0,"OEORE",orderId_"||"_orderExecId,DCARowId,""))
	...s DCAAStatus=$p(^DHCDocCure(DCARowId,"Arrive",DCAAChildSub),"^",7)
	...i DCAAStatus="A" s IsCancelArrivedOrd=0
	.;执行备注
	.s Notes=$P(^OEORD(order,"I",ordItem,"X",orderExecId),"^",44)
	.s ExecPart=##Class(web.DHCAPPInterface).GetOrdExecDesc(orderId_"||"_orderExecId) 
	.s PriorityId=$p(^OEORD(order,"I",ordItem,1),"^",8)
	.s TPriorityCode=$p(^OECPR(PriorityId),"^",1) //医嘱类型Code
	.s ItmMastDR = $p(^OEORD(order,"I",ordItem,1),"^",2)
	.s ItemCatDR=$p(^ARCIM(+ItmMastDR,$p(ItmMastDR,"||",2),1),"^",10)
	.s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)
	.s IsCancelDispenOrd=1
	.//是否已配液
	.//if (OrderType="R")&&(##class(PHA.FACE.OUT.Com).IfOeoreHas60(orderId_"||"_orderExecId)="Y") s IsCancelDispenOrd=0
	.s TBillUom = ##class(web.DHCDocMainOrderInterface).GetBillUom(+ItmMastDR,$p(ItmMastDR,"||",2)) //医嘱项计价单位
	.s OrdExecBillInfo=##class(web.DHCBillInterface).IGetOrdEexcBillPrice(orderId_"||"_orderExecId)
	.s OrdExecBillQty=$j($p(OrdExecBillInfo,"^",2),"",2)_##class(User.CTUOM).GetTranByDesc("CTUOMDesc",$p(OrdExecBillInfo,"^",3),langid)
	.s CoverMainIns=$P(^OEORD(order,"I",ordItem,"X",orderExecId),"^",49)
	.s ^||TMP(TExStDate,+TExStTime,orderExecId)=$lb(orderId_"||"_orderExecId,TItemStatCode,0,TExStDateDesc_" "_TExStTimeDesc,TExecState,TExecStateCode,TExecDate_" "_TExecTime,THourExEnTime,TExecRes,TExecFreeRes,TExecUser,TExecLoc,TBillState,TExecFreeChargeFlag,TgiveDrugQty,TcancelDrugQty,TPBOID,TApplyCancelStatus,TApplyCancelStatusCode,IsCanExecOrdArrear,"",IsCancelArrivedOrd,Notes,ExecPart,TPriorityCode,TBillUom,OrdExecBillQty,IsCancelDispenOrd,CoverMainIns)
	
	
	
			
	s sd="" f  s sd = $o(^||TMP(sd),-1) q:sd=""  d
	.;extime -> times
	.s times=1
	.s stflag = "" f  s stflag = $o(^||TMP(sd,stflag)) q:stflag=""  d
	..s execId = "" f  s execId = $o(^||TMP(sd,stflag,execId)) q:execId=""  d
	...s ^||TMP(sd,stflag,execId)=^||TMP(sd,stflag,execId)_$lb($p($listget(^||TMP(sd,stflag,execId),3)," ")_" 第"_times_"次"),times = times+1
	.;out put row
	.s st = "" f  s st = $o(^||TMP(sd,st),-1) q:st=""  d
	..s exec =""  f  s exec = $o(^||TMP(sd,st,exec),-1) q:exec=""  d
	...s ind = ind+1
	...s ^CacheTemp(repid,ind) = ^||TMP(sd,st,exec)
	set qHandle = $lb(0,repid,0)
	Q $$$OK
}

/// 医嘱处理 停止 作废 撤销
/// @param OrderItemStr 医嘱串 以^ 分割
/// @param date
/// @param time 
/// @param type 类型  S 停止 C 撤销 U作废
/// @param pinNum 密码
/// @param ExpStr 扩展串 user^locid^groupid
/// w ##class(web.DHCDocInPatPortalCommon).MulOrdDealWithCom("447||23"_$c(1)_"15/05/2023 17:34:00^447||24"_$c(1)_"15/05/2023 17:34:00","15/05/2023","17:34:16","S","1","18881^191^29^^","","Y")
ClassMethod MulOrdDealWithCom(OrderItemStr As %String, date As %String, time As %String, type As %String, pinNum As %String, ExpStr As %String, ByRef ErrMsg As %String = "", PWFlag As %String = "Y") As %String
{
	;s ^tempscl("MulOrdDealWithCom")=$lb(OrderItemStr,date,time,type,pinNum,ExpStr,"",PWFlag)
	if (date="") s date=..%ZD(..%SysDate())
	if (time="") s time=..%ZT(..%SysTime())
	s Logicaldate=..%ZDH(date)
	s Logicaltime=..%ZTH(time)
	s user=$p(ExpStr,"^",1)
	s locid=$p(ExpStr,"^",2)
	s groupid=$p(ExpStr,"^",3)
	s ReasonId=$p(ExpStr,"^",4)
	s Reasoncomment=$p(ExpStr,"^",5)
	s IncludeStopDateOrd=$p(ExpStr,"^",6)
	s FocesFlag=$P(ExpStr,"^",7)
	if ($LISTFIND($LB("S","C","U","Addexec","SInEM"),type)>0){
		s warning=##class(web.DHCDocOrderCommon).OrderLock(+OrderItemStr,..%SessionStr(),"CheckStop","")
		if (warning'=""){
			q warning
		}
	}
	
	if (type="S"){
		s StopGroupOrder=..%GetConfig("StopGroupOrder")
		s len = $l(OrderItemStr,"^")
		s stopMsg="0"	;默认有权限停医嘱
		s i=1,orderItemStr=""
		while (i<=$l(OrderItemStr,"^"))&&(stopMsg="0") {
			s oneitem=$p(OrderItemStr,"^",i)
			s oeorirowid=$p(oneitem,$C(1),1)
			s ordStDateStr=$p(oneitem,$C(1),2)
			s ARCIMDesc=$$GetArcimDesc(oeorirowid)
			s adm = $p(^OEORD(+oeorirowid),"^",1)
			s AdmType=$p(^PAADM(adm),"^",2)
			if ((StopGroupOrder=1)&&(AdmType'="I")) {
				s OrdLinkRowId=$p($g(^OEORD(+oeorirowid,"I",$p(oeorirowid,"||",2),11)),"^",39)
				s SingleStopFlag=##class(appcom.OEOrdItem).CheckSingleStop(oeorirowid,user,"S")
				if (OrdLinkRowId'="")&&(SingleStopFlag'=1) {
					if ("^"_OrderItemStr_"^")'[("^"_OrdLinkRowId_$C(1)_ordStDateStr_"^") s OrderItemStr=OrderItemStr_"^"_OrdLinkRowId_$C(1)_ordStDateStr
				}
			}
			s OEORIDate=$p($g(^OEORD(+oeorirowid,"I",$p(oeorirowid,"||",2),3)),"^",7)
			s OEORITime=$p($g(^OEORD(+oeorirowid,"I",$p(oeorirowid,"||",2),1)),"^",17)
			//s ordStDate=..%ZDH($p(ordStDateStr," ",1))
			//s ordStTime=..%ZTH($p(ordStDateStr," ",2))
			if (Logicaldate=OEORIDate)&&(Logicaltime<OEORITime){
				s stopMsg=ARCIMDesc_..%Translate("ipdoc.patinfoview.csp"," 停止时间不能小于开医嘱时间！"),ErrMsg=stopMsg
				Q
			}
			if (Logicaldate<OEORIDate){
				s stopMsg=ARCIMDesc_..%Translate("ipdoc.patinfoview.csp"," 停止日期不能小于开医嘱日期！"),ErrMsg=stopMsg
				Q
			}
			; 0 没有权限 1 有权限
			s flag = ##class(web.DHCDocMain).CheckStopOrder(oeorirowid,user,locid,groupid,date,time,.ErrMsg)
			if (+flag=1){
				s item = oeorirowid_"!"_date_"!"_time
				i orderItemStr="" s orderItemStr=item
				e  s orderItemStr=orderItemStr_"^"_item	
			}else{
				s stopMsg=..%Translate("ipdoc.patinfoview.csp","停止失败 ")_ARCIMDesc_..%Translate("ipdoc.patinfoview.csp"," 医嘱！")_..%Translate("ipdoc.patinfoview.csp",ErrMsg),ErrMsg=stopMsg
				Q
			}
			s i=i+1
		}
		if (stopMsg="0")&&(orderItemStr'=""){
			s ExpStrsub="^^^"_locid
			s rtn=##class(appcom.OEOrdItem).StopMulti(orderItemStr,user, pinNum,PWFlag,ExpStrsub,.ErrMsg)
			s:rtn'=0 stopMsg=ErrMsg
		}
		Q stopMsg
	}elseif (type="C"){
		s len = $l(OrderItemStr,"^")
		s cancelMsg="0"	;默认有权限
		s i=1,orderItemStr=""
		while (i<=len)&&(cancelMsg="0") {
			s oneitem=$p(OrderItemStr,"^",i)
			s oeorirowid=$p(oneitem,$C(1),1)
			s adm = $p(^OEORD(+oeorirowid),"^",1)
			s AdmType=$p(^PAADM(adm),"^",2)
			s flag = ##class(web.DHCDocMain).CheckCancelOrder(oeorirowid,user,locid,groupid,.ErrMsg)
			if (+flag=1){
				i orderItemStr="" s orderItemStr=oeorirowid
				e  s orderItemStr=orderItemStr_"^"_oeorirowid	
			}else{
				s ARCIMDesc=$$GetArcimDesc(oeorirowid)
				s cancelMsg=..%Translate("ipdoc.patinfoview.csp","撤销失败 ")_ARCIMDesc_..%Translate("ipdoc.patinfoview.csp"," 医嘱！")_..%Translate("ipdoc.patinfoview.csp",ErrMsg),ErrMsg=cancelMsg
				Q
			}
			s i=i+1
		}
		if (cancelMsg="0")&&(orderItemStr'=""){
			if (AdmType="I"){
				s rtn=##class(appcom.OEOrdItem).CancelMulti(orderItemStr,user,pinNum,PWFlag,ReasonId,Reasoncomment,"",.ErrMsg)
				s:rtn'=0 cancelMsg=ErrMsg
				s cancelMsg=..%Translate("ipdoc.patinfoview.csp",cancelMsg)
			}else{
				s orderItemStr=$tr(orderItemStr,$C(1),"&")
				s ExpStrsub="^^^"_locid
				s rtn = ##class(web.UDHCStopOrderLook).StopOrder("","",orderItemStr,user,pinNum,PWFlag,ExpStrsub,.ErrMsg)
				if (rtn=-5) {
					s rtn="-100045" //-2091
					s ErrMsg=..%GetErrCodeMsg("-100045")
				}
				s:rtn'=0 cancelMsg=ErrMsg
				s cancelMsg=..%Translate("ipdoc.patinfoview.csp",cancelMsg)
			}
		}
		s DischargeOEORI=..GetDisChargeOEORI(OrderItemStr)
		Q cancelMsg_"^"_DischargeOEORI
	}elseif (type="U"){
		s len = $l(OrderItemStr,"^")
		s unUseMsg="0"	;默认有权限
		s i=1,orderItemStr=""
		while (i<=len)&&(unUseMsg="0") {
			s oneitem=$p(OrderItemStr,"^",i)
			s oeorirowid=$p(oneitem,$C(1),1)
			s adm = $p(^OEORD(+oeorirowid),"^",1)
			s AdmType=$p(^PAADM(adm),"^",2)
			s flag = ##class(web.DHCDocMain).CheckUnuseOrder(oeorirowid,user,locid,groupid,.ErrMsg)
			if (+flag=1){
				i orderItemStr="" s orderItemStr=oeorirowid
				e  s orderItemStr=orderItemStr_"^"_oeorirowid	
			}else{
				s ARCIMDesc=$$GetArcimDesc(oeorirowid)
				s unUseMsg=..%Translate("ipdoc.patinfoview.csp","作废失败 ")_ARCIMDesc_..%Translate("ipdoc.patinfoview.csp"," 医嘱！")_..%Translate("ipdoc.patinfoview.csp",ErrMsg),ErrMsg=unUseMsg
				Q
			}
			s i=i+1
		}
		if (unUseMsg="0")&&(orderItemStr'=""){
			s $P(ExpStr,"^",4)=locid
			s $P(ExpStr,"^",1)=FocesFlag
			s $P(ExpStr,"^",2)=""
			s $P(ExpStr,"^",3)=""
			if (AdmType="I"){
				s rtn=##class(appcom.OEOrdItem).UnUseMulti(orderItemStr,user,pinNum,PWFlag,ReasonId,Reasoncomment,ExpStr,.ErrMsg)
				s:rtn'=0 unUseMsg=ErrMsg
				s unUseMsg=..%Translate("ipdoc.patinfoview.csp",unUseMsg)
			}else{
				s orderItemStr=$tr(orderItemStr,$C(1),"&")
				s rtn = ##class(web.UDHCStopOrderLook).StopOrder("","",orderItemStr,user,pinNum)
				if (rtn=-5) {
					s rtn="-100045" //-209
					s ErrMsg=..%GetErrCodeMsg("-100045")
					s unUseMsg=ErrMsg
					s unUseMsg=..%Translate("ipdoc.patinfoview.csp",unUseMsg)
				}
			}
			if (unUseMsg="0"){
				for i=1:1:$l(orderItemStr,"^") {
					s oeordItemId=$p(orderItemStr,"^",i)
					s pageNo = ##class(Nur.DHCORDPRINTSUB).getPrintInfo(oeordItemId)
					if +pageNo>0 s unUseMsg="-100050"_"^"_..%GetErrCodeMsg("-100050") //-901
				}
			}
		}
		s DischargeOEORI=..GetDisChargeOEORI(OrderItemStr)
		Q unUseMsg_"^"_DischargeOEORI
	}elseif(type="Addexec"){
		s NeedUpdateHourOrdExecId=$p(ExpStr,"^",10)
		//prn增加执行医嘱
		s AddExecMsg="0"
		s oeordItemId=$p(OrderItemStr,"^",1)
		s oeorirowid=$p(oeordItemId,$C(1),1)
		if (##class(appcom.OEOrdItem).ISPRNOrder(oeorirowid)){
			if (NeedUpdateHourOrdExecId) {
				s err=##class(appcom.OEOrdExec).SetBillFlag(NeedUpdateHourOrdExecId,Logicaltime-1)
			}
			s rtn=##class(appcom.OEOrdExec).InsExecOEORE(oeorirowid,date,time)
			s AddExecMsg=..GetMsg(rtn)
			s Adm=$p(^OEORD(+oeorirowid),"^",1)
			d ##Class(web.UDHCJFBILL).BILLN(Adm,user,"")
		}else{
			s AddExecMsg="非PRN医嘱不能增加执行医嘱!"
		}
		s:AddExecMsg'=0 ErrMsg=AddExecMsg
		Q AddExecMsg
	}elseif(type="NurSeeOrd"){//护士处理医嘱
		s SeeOrdType=$p(ExpStr,"^",6)
		s SeeOrdDate=$p(ExpStr,"^",7)
		s SeeOrdTime=$p(ExpStr,"^",8)
		s SeeOrdNotes=$p(ExpStr,"^",9)
		s len = $l(OrderItemStr,"^")
		s errMsg="0",i=1
		s NewOrderItemStr=""
		for i=1:1:len{
			s oneitem=$p(OrderItemStr,"^",i)
			s oeorirowid=$p(oneitem,$C(1),1)
			continue:oeorirowid=""
			s OrdLinkRowId=$p($g(^OEORD(+oeorirowid,"I",$p(oeorirowid,"||",2),11)),"^",39)
			s OEORIServiceOrdDR=$p($g(^OEORD(+oeorirowid,"I",$p(oeorirowid,"||",2),"DHC")),"^",54)
			if (OrdLinkRowId'="") s oeorirowid=OrdLinkRowId
			continue:(OEORIServiceOrdDR'="")&&(NewOrderItemStr'="")&&(("^"_NewOrderItemStr_"^")[("^"_OEORIServiceOrdDR_"^"))
			continue:(NewOrderItemStr'="")&&(("^"_NewOrderItemStr_"^")[("^"_oeorirowid_"^"))
			i NewOrderItemStr="" s NewOrderItemStr=oeorirowid
			else  s NewOrderItemStr=NewOrderItemStr_"^"_oeorirowid
			//治疗医嘱的绑定医嘱，子医嘱也要对应的处理
			if (OEORIServiceOrdDR'="") {
				s CureOEORIServiceOrd=OEORIServiceOrdDR
			}else{
				s CureOEORIServiceOrd=oeorirowid
			}
			s Sub=$o(^OEORDi(0,"SERORD",CureOEORIServiceOrd,+CureOEORIServiceOrd,0))
			While (Sub'="") {
				s SubRowId=+CureOEORIServiceOrd_"||"_Sub
				s Sub=$o(^OEORDi(0,"SERORD",CureOEORIServiceOrd,+CureOEORIServiceOrd,Sub))
				s NewOrderItemStr=NewOrderItemStr_"^"_SubRowId
			}
			/*if ($d(^DHCDocCure(0,"OEORI",CureOEORIServiceOrd))) {
				if (("^"_NewOrderItemStr_"^")'[("^"_CureOEORIServiceOrd_"^")) {
					s NewOrderItemStr=NewOrderItemStr_"^"_CureOEORIServiceOrd
				}
				s Sub=$o(^OEORDi(0,"SERORD",CureOEORIServiceOrd,+CureOEORIServiceOrd,0))
				While (Sub'="") {
					s SubRowId=+CureOEORIServiceOrd_"||"_Sub
					s Sub=$o(^OEORDi(0,"SERORD",CureOEORIServiceOrd,+CureOEORIServiceOrd,Sub))
					if (("^"_NewOrderItemStr_"^")[("^"_SubRowId_"^")){
						continue
					}
					continue:'$d(^DHCDocCure(0,"OEORI",SubRowId))
					s NewOrderItemStr=NewOrderItemStr_"^"_SubRowId
				}
			}*/
		}
		s rtn=##class(Nur.NIS.Service.Base.OrderHandle).SeeOrderChunks(NewOrderItemStr,user,SeeOrdType,SeeOrdNotes,SeeOrdDate,SeeOrdTime,locid)
		if (rtn.GetAt("success")'=0){
			for errIndex=1:1:rtn.GetAt("errList").Count(){
				s errInfo = rtn.GetAt("errList").GetAt(errIndex).GetAt("errInfo")
				if (errMsg=0) s errMsg=errInfo
				else  s errMsg=errMsg_errInfo
			}
		}
		s:errMsg'=0 ErrMsg=errMsg
		Q errMsg
	}elseif(type="NurCancelSeeOrd"){//护士撤销处理医嘱
		s errMsg="0"
		s NewOrderItemStr=""
		s len = $l(OrderItemStr,"^")
		for i=1:1:len{
			s oneitem=$p(OrderItemStr,"^",i)
			s oeorirowid=$p(oneitem,$C(1),1)
			continue:oeorirowid=""
			s OrdLinkRowId=$p($g(^OEORD(+oeorirowid,"I",$p(oeorirowid,"||",2),11)),"^",39)
			s OEORIServiceOrdDR=$p($g(^OEORD(+oeorirowid,"I",$p(oeorirowid,"||",2),"DHC")),"^",54)
			continue:(OEORIServiceOrdDR'="")&&(NewOrderItemStr'="")&&(("^"_NewOrderItemStr_"^")[("^"_OEORIServiceOrdDR_"^"))
			if (OrdLinkRowId'="") s oeorirowid=OrdLinkRowId
			continue:(NewOrderItemStr'="")&&(("^"_NewOrderItemStr_"^")[("^"_oeorirowid_"^"))
			i NewOrderItemStr="" s NewOrderItemStr=oeorirowid
			else  s NewOrderItemStr=NewOrderItemStr_"^"_oeorirowid
			//治疗医嘱的绑定医嘱，子医嘱也要对应的处理
			if (OEORIServiceOrdDR'="") {
				s CureOEORIServiceOrd=OEORIServiceOrdDR
			}else{
				s CureOEORIServiceOrd=oeorirowid
			}
			if ($d(^DHCDocCure(0,"OEORI",CureOEORIServiceOrd))) {
				if (("^"_NewOrderItemStr_"^")'[("^"_CureOEORIServiceOrd_"^")) {
					s NewOrderItemStr=NewOrderItemStr_"^"_CureOEORIServiceOrd
				}
			}
			s Sub=$o(^OEORDi(0,"SERORD",oeorirowid,+oeorirowid,0))
			While (Sub'="") {
				s SubRowId=+oeorirowid_"||"_Sub
				s Sub=$o(^OEORDi(0,"SERORD",oeorirowid,+oeorirowid,Sub))
				/*if (("^"_NewOrderItemStr_"^")[("^"_SubRowId_"^")){
					continue
				}*/
				//continue:'$d(^DHCDocCure(0,"OEORI",SubRowId))
				s NewOrderItemStr=NewOrderItemStr_"^"_SubRowId
			}
			
		}
		Q:NewOrderItemStr="" errMsg
		s rtn=##class(Nur.NIS.Service.Base.OrderHandle).CancelSeeOrderChunks(NewOrderItemStr,user,locid)
		if (rtn.GetAt("success")'=0){
			for errIndex=1:1:rtn.GetAt("errList").Count(){
				s errInfo = rtn.GetAt("errList").GetAt(errIndex).GetAt("errInfo")
				if (errMsg=0) s errMsg=errInfo
				else  s errMsg=errMsg_errInfo
			}
		}
		s:errMsg'=0 ErrMsg=errMsg
		Q errMsg
	}elseif(type="CancelPreStopOrd"){ //取消预停
		s stopMsg=0
		s len = $l(OrderItemStr,"^")
		s i=1,orderItemStr=""
		while (i<=len) {
			s oneitem=$p(OrderItemStr,"^",i)
			s oeorirowid=$p(oneitem,$C(1),1)
			i orderItemStr="" s orderItemStr=oeorirowid
			e  s orderItemStr=orderItemStr_"^"_oeorirowid	
			s i=i+1
		}
		if (orderItemStr'=""){
			s rtn=##class(appcom.OEOrdItem).CancelPreStopMulti(orderItemStr,user, pinNum,ExpStr,"Y",.ErrMsg)
			s:ErrMsg'="" stopMsg=ErrMsg
		}
		Q stopMsg
	}elseif(type="SInEM"){
		//急诊停医嘱,可能涉及虚拟长期，单独独立写
		s stopMsg="0"	;默认有权限停医嘱
		s orderItemStr="",StopExecStr=""
		s len = $l(OrderItemStr,"^")
		s i=1,orderItemStr=""
		while (i<=len) {
			s oneitem=$p(OrderItemStr,"^",i)
			s i=i+1
			s oeorirowid=$p(oneitem,$C(1),1)
			s ordStDateStr=$p(oneitem,$C(1),2)
			// 0 没有权限 1 有权限
			s flag = ##class(web.DHCDocOrderVirtualLong).CheckStopOrder(oeorirowid,user,locid,groupid,date,time,.ErrMsg,.StopExecStr,IncludeStopDateOrd)
			if (+flag=1){
				s item = oeorirowid_"&"_date_"&"_time
				i orderItemStr="" s orderItemStr=item
				e  s orderItemStr=orderItemStr_"^"_item	
			}else{
				s ARCIMDesc=$$GetArcimDesc(oeorirowid)
				s stopMsg="您无权停止 "_ARCIMDesc_" 医嘱！"_ErrMsg,ErrMsg=stopMsg
				Q
			}
		}
		s (StopDate,StopTime)=""
		s:date'="" StopDate=..%ZDH(date)
		s:time'="" StopTime=..%ZTH(time)
		TS
		if (stopMsg="0")&&(orderItemStr'=""){
			s rtn=##class(web.DHCDocOrderVirtualLong).StopOrder(orderItemStr,user, pinNum,"Y",IncludeStopDateOrd,"",.ErrMsg)
			s:rtn<0 stopMsg=ErrMsg
		}
		if (stopMsg="0")&&(StopExecStr'=""){
			for i=1:1:$L(StopExecStr,"^"){
				s OEORERowId=$p(StopExecStr,"^",i)
				continue:(OEORERowId="")
				s myStatusCode=""
				s myStatusRowId=$P(^OEORD(+OEORERowId,"I",$P(OEORERowId,"||",2),"X",$P(OEORERowId,"||",3)),"^",16)
				if myStatusRowId'="" s myStatusCode=$P($G(^OEC("STAT",myStatusRowId)),"^",1)
				continue:(myStatusCode="D")
				s rtn=##class(appcom.OEOrdExec).UpdateStatus(OEORERowId,"D",user,StopDate,StopTime,"","","","","Y","",.ErrMsg)
				s:+rtn<0 stopMsg=ErrMsg
				if (ErrMsg'=""){
					Q
				}
			}
		}
		if (stopMsg'="0"){
			TRO
		}else{
			TC
		}
		Q stopMsg
	}
GetArcimDesc(oeorirowid)
	Set langid=..%LanguageID()
	s str1 = ^OEORD(+oeorirowid,"I",$p(oeorirowid,"||",2),1)
	s ItmMastDR=$p(str1,"^",2)
	s ARCIMDesc=$p(^ARCIM(+ItmMastDR,$p(ItmMastDR,"||",2),1),"^",2)	
	s ARCIMDesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",ARCIMDesc,langid)
	Q ARCIMDesc
}

/// 执行记录处理 执行 作废 停止
/// @param OrderExecStr 医嘱执行记录Id串 以^ 分割
/// @parma date 日期(可为空)
/// @param time 时间(可为空)
/// @param type 类型  R 执行 C 撤销 D停止 CD撤销并停止 U 修改小时医嘱结束时间 ExecAppend 手工绑定医嘱
/// @param ReasonId 撤销或停止原因id(可为空)
/// @param ExpStr 扩展串，*表示必填 user(*执行者ID)^locid(*登录科室ID)^groupid(*登录安全组ID)^ReasonDesc(原因描述)^ExecAppendOrdList(需添加的手工绑定医嘱信息串)^PassWord(执行者密码)
/// @param PinNumStr  双签执行用户信息，可空，执行者工号_$c(1)_密码_$c(2)_核对者工号_$c(1)_密码
/// 返回值 0成功 其他失败并返回失败原因
/// w ##class(web.DHCDocInPatPortalCommon).MulOrdExecDealWithCom("93||740||18","02/12/2020","16:25:19","R","","12177^114^23")
ClassMethod MulOrdExecDealWithCom(OrderExecStr As %String, date As %String, time As %String, type As %String, ReasonId As %String, ExpStr As %String, ByRef ErrMsg As %String = "", PinNumStr As %String = "") As %String
{
	s ^tempscl("MulOrdExecDealWithCom")=$lb(OrderExecStr,date,time,type,ReasonId,ExpStr,"",PinNumStr)
	if (date'="") s Logicaldate=..%ZDH(date)
	else  s Logicaldate=..%SysDate()
	if (time'="") s Logicaltime=..%ZTH(time)
	else  s Logicaltime=..%SysTime()
	s user=$p(ExpStr,"^",1)
	s locid=$p(ExpStr,"^",2)
	s groupid=$p(ExpStr,"^",3)
	s Reasoncomment=$p(ExpStr,"^",4)
	s SelExecAppendOrdListStr=$p(ExpStr,"^",5)
	s PinNum=$p(ExpStr,"^",6)
	if (PinNum'="") {
		s err=##Class(web.DHCOEOrdItem).PinNumberValid(user,PinNum)
		if (err'=0) {
			s ErrMsg=..%GetErrCodeMsg("-100029")
			Q ErrMsg
		}
	}
	s err=..CheckUserCodeAndPinNum(PinNumStr)
	if (err'=0) {
		s stopMsg=..GetMsg(err)
		q stopMsg
	}
	s warning=##class(web.DHCDocOrderCommon).OrderLock(+OrderExecStr,..%SessionStr(),"CheckStop","")
	if (warning'=""){
		q warning
	}
	
	if (type="R"){
		s (FirstUserID,SecondUserID,SecondCTCarproveId)=""
		s FirstUserCode=$ZCVT($p($p(PinNumStr,$c(2),1),$c(1),1),"U")
		s SecondUserCode=$ZCVT($p($p(PinNumStr,$c(2),2),$c(1),1),"U")
		i (FirstUserCode'="")&&(SecondUserCode'=""){
			s FirstUserID=$o(^SSU("SSUSR",0,"SSUSR_Initials",FirstUserCode,0))
			s SecondUserID=$o(^SSU("SSUSR",0,"SSUSR_Initials",SecondUserCode,0))
			s user=FirstUserID
			s SecondCTCarproveId=$p($g(^SSU("SSUSR",SecondUserID)),"^",14)
		}
		s RunExecMsg=0
		TS
		for i=1:1:$l(OrderExecStr,"^") {
			s orderExecId=$p(OrderExecStr,"^",i)
			;1.验证执行记录是否可执行
			s rtnCode=##class(web.DHCDocMainOrderInterface).IsCanExecOrdArrear("",orderExecId,locid,date,time,.ErrMsg)
			if (rtnCode="PlacerNo")||(rtnCode="1") s rtnCode=0
			if rtnCode'="0" {
				s RunExecMsg=ErrMsg
				Q
			}
			;2.更新执行记录状态
			s rtn=##class(appcom.OEOrdExec).UpdateStatus(orderExecId,"F",user,Logicaldate,Logicaltime,"","","",locid,"Y","",.ErrMsg)
			if (rtn=0) {
				;3.调用护士站执行插入医嘱
				d ##class(Nur.DHCInstrAttOrd).ExcuteInstrAttOrd(orderExecId, "F", locid, user)
				;4.调用护士站保存双签数据
				i SecondUserID'="" d
				.d ##class(Nur.NIS.Service.Base.OrderHandle).UpdateExecAuditUser(orderExecId,Logicaldate,Logicaltime,SecondUserID)
			}else{
				s RunExecMsg=ErrMsg
				Q
			}
		}
		if (RunExecMsg'=0) {
			Tro
		}else {
			TC
		}
		Q RunExecMsg
	}elseif (type="C"){
		s CancelExecMsg="0"
		TS
		for i=1:1:$l(OrderExecStr,"^") {
			s orderExecId=$p(OrderExecStr,"^",i)
			;1.验证是否可撤销执行
			s rtnCode=..IsCanCancelExecOrdArrear(orderExecId,locid,"",.ErrMsg)
			if rtnCode'="0" {
				s CancelExecMsg=ErrMsg
				Q
			}
			;2.更新执行记录状态
			s rtn=##class(appcom.OEOrdExec).UpdateStatus(orderExecId,"C",user,+$h,..%SysTime(),ReasonId,"",Reasoncomment,locid,"Y","",.ErrMsg)
			if (rtn=0) {
				;3.调用护士站接口撤销执行插入的医嘱
				d ##class(Nur.DHCInstrAttOrd).ExcuteInstrAttOrd(orderExecId, "C", locid, user)
			}else{
				s CancelExecMsg=ErrMsg
			}
		}
		if (CancelExecMsg'=0) {
			Tro
		}else {
			TC
		}
		Q CancelExecMsg
	}elseif(type="D"){
		s DisExecMsg="0"
		TS
		for i=1:1:$l(OrderExecStr,"^") {
			s orderExecId=$p(OrderExecStr,"^",i)
			;1.验证是否可停止执行
			s rtnCode=..IsCanDisExecOrdArrear(orderExecId,locid,"",.ErrMsg)
			if rtnCode'="0" {
				s DisExecMsg=ErrMsg
				Q
			}
			;2.更新执行记录状态
			s rtn=##class(appcom.OEOrdExec).UpdateStatus(orderExecId,"D",user,+$h,..%SysTime(),ReasonId,"",Reasoncomment,locid,"Y","",.ErrMsg)
			if (rtn=0) {
				;3.调用护士站接口撤销执行插入的医嘱
				d ##class(Nur.DHCInstrAttOrd).ExcuteInstrAttOrd(orderExecId, "D", locid, user)
			}else{
				s DisExecMsg=ErrMsg
			}
		}
		if (DisExecMsg'=0) {
			Tro
		}else {
			TC
		}
		Q DisExecMsg
	}elseif(type="CD"){
		///撤销并停止
		s CancelDisExecMsg="0"
		TS
		for i=1:1:$l(OrderExecStr,"^") {
			s orderExecId=$p(OrderExecStr,"^",i)
			s str = ^OEORD(+orderExecId,"I",$p(orderExecId,"||",2),"X",$p(orderExecId,"||",3))
			s ExecStateDR= $p(str,"^",16)
			s execStatus=""
			i +ExecStateDR>0 s execStatus = $p(^OEC("STAT",ExecStateDR),"^",1)
			if ($g(execStatus)="F"){
				;1.验证是否可撤销执行
				s rtnCode=..IsCanCancelExecOrdArrear(orderExecId,locid,"",.ErrMsg)
				if rtnCode'="0" {
					s CancelDisExecMsg=ErrMsg
					Q
				}
				;2.更改执行记录状态为撤销
				s rtn=##class(appcom.OEOrdExec).UpdateStatus(orderExecId,"C",user,+$h,..%SysTime(),ReasonId,"",Reasoncomment,locid,"Y","",.ErrMsg)
				if (rtn=0) {
					d ##class(Nur.DHCInstrAttOrd).ExcuteInstrAttOrd(orderExecId, "C", locid, user)
					;3.验证是否可停止执行
					s rtnCode=..IsCanDisExecOrdArrear(orderExecId,locid,"",.ErrMsg)
					if rtnCode'="0" {
						s CancelDisExecMsg=ErrMsg
						Q
					}
					;4.更改执行记录状态为停止
					s rtn=##class(appcom.OEOrdExec).UpdateStatus(orderExecId,"D",user,+$h,..%SysTime(),ReasonId,"",Reasoncomment,locid,"Y","",.ErrMsg)
					if (rtn=0) {
						d ##class(Nur.DHCInstrAttOrd).ExcuteInstrAttOrd(orderExecId, "D", locid, user)
					}else{
						s CancelDisExecMsg=ErrMsg
						Q
					}
				}else{
					s CancelDisExecMsg=ErrMsg
					Q
				}
			}else{
				;1.已执行状态验证是否可停止执行
				s rtnCode=..IsCanDisExecOrdArrear(orderExecId,locid,"",.ErrMsg)
				if rtnCode'="0" {
					s CancelDisExecMsg=ErrMsg
					Q
				}
				;2.更改执行记录状态为停止
				s rtn=##class(appcom.OEOrdExec).UpdateStatus(orderExecId,"D",user,+$h,..%SysTime(),ReasonId,"",Reasoncomment,locid,"Y","",.ErrMsg)
				if (rtn=0) {
					d ##class(Nur.DHCInstrAttOrd).ExcuteInstrAttOrd(orderExecId, "D", locid, user)
				}else{
					s CancelDisExecMsg=ErrMsg
					Q
				}
			}
		}
		if (CancelDisExecMsg'=0) {
			Tro
		}else {
			TC
		}
		Q CancelDisExecMsg
	}elseif(type="U"){ //修改小时医嘱结束时间
		s UpdateHourExecMsg="0"
		s orderExecId=$p(OrderExecStr,"^",1)
		s rtn = ##class(web.DHCDocMain).CheckUpdateHour(orderExecId,Logicaltime)
		if (rtn'=1){
			s UpdateHourExecMsg=rtn,ErrMsg=UpdateHourExecMsg
		}else{
			s rtn=##class(appcom.OEOrdExec).ResetBillFlag(orderExecId,Logicaltime,user)
			if (rtn'=0) s UpdateHourExecMsg="更新失败!"_rtn,ErrMsg=UpdateHourExecMsg
			else  s UpdateHourExecMsg=rtn
		}
		Q UpdateHourExecMsg
	}elseif(type="ExecAppend"){ //手工绑定医嘱
		s user=$p(ExpStr,"^",1)
		s locid=$p(ExpStr,"^",2)
		s groupid=$p(ExpStr,"^",3)
		s Reasoncomment=$p(ExpStr,"^",4)
		s SelExecAppendOrdListStr=$p(ExpStr,"^",5)
		s OereIDs=$TR(OrderExecStr,"^","$")
		s ArcimIDs="",Qtys=""
		for i=1:1:$L(SelExecAppendOrdListStr,"$"){
			s ExecAppendOrdStr=$P(SelExecAppendOrdListStr,"$",i)
			if (ArcimIDs=""){
				s ArcimIDs=$P(ExecAppendOrdStr,"_",1)
			}else{
				s ArcimIDs=ArcimIDs_"$"_$P(ExecAppendOrdStr,"_",1)
			}
			if (Qtys=""){
				s Qtys=$P(ExecAppendOrdStr,"_",2)
			}else{
				s Qtys=Qtys_"$"_$P(ExecAppendOrdStr,"_",2)
			}
		}
		s ByHand="2"
		s ExecType="10"
		s NotLinkPriorStr=""
		s SingleNotFee="0"
		s StartNum=""
		s EndNum=""
		s AppendOrdType="2"
		s errMsg=##class(Nur.CommonInterface.OrderHandle).execAttachAricm(user,locid,OereIDs,ArcimIDs,Qtys,ByHand, ExecType, NotLinkPriorStr, SingleNotFee, StartNum, EndNum, AppendOrdType)
		if (errMsg'=0) s ErrMsg=errMsg
		Q errMsg
	}elseif(type="DInEM"){	//虚拟长期医嘱模式下的停止执行
		s errMsg=##Class(web.DHCDocOrderVirtualLong).CancelOrdExec(OrderExecStr,user, locid, groupid, PinNum,"",.ErrMsg)
		if (errMsg'=0) s ErrMsg=errMsg
		Q errMsg
	}
GetArcimDesc(oeorirowid)
	Set langid=..%LanguageID()
	s str1 = ^OEORD(+oeorirowid,"I",$p(oeorirowid,"||",2),1)
	s ItmMastDR=$p(str1,"^",2)
	s ARCIMDesc=$p(^ARCIM(+ItmMastDR,$p(ItmMastDR,"||",2),1),"^",2)	
	s ARCIMDesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",ARCIMDesc,langid)
	Q ARCIMDesc
}

/// 判断执行记录是否能否停止
ClassMethod IsCanDisExecOrdArrear(oeorerowid As %String, locid As %String = "", ExpStr As %String = "", ByRef ErrMsg As %String = "") As %String
{
	s str = ^OEORD(+oeorerowid,"I",$p(oeorerowid,"||",2),"X",$p(oeorerowid,"||",3))
	s ExecStateDR= $p(str,"^",16)
	i +ExecStateDR>0 s execStatus = $p(^OEC("STAT",ExecStateDR),"^",1)
	e  s execStatus = "未执行"
	s ExStDate=$p(str,"^",1)
	s ExStTime = $p(str,"^",2)
	Set langid=..%LanguageID()
	s PreErrMsg=..%Translate("ipdoc.patinfoview.csp","执行记录",langid)_"："_..%ZD(ExStDate)_" "_..%ZT(ExStTime,1)_" "
	s CureAppRowId=##class(DHCDoc.DHCDocCure.OutInterface).GetCureApplyByOrd($p(oeorerowid,"||",1,2))
	if CureAppRowId'=""{
		s ErrMsg=PreErrMsg_..%GetErrCodeMsg("-100078")
		Quit "-100078"
	}
	
	if (execStatus'="C")&&(execStatus'="未执行") {
		s ErrMsg=PreErrMsg_..%GetErrCodeMsg("-100052")
		Q "-100052" //NotC
	}
	s TOrderStatusDR=$p(^OEORD(+oeorerowid,"I",$p(oeorerowid,"||",2),1),"^",13)
	s:+TOrderStatusDR>0 orderStatCode = $p(^OEC("OSTAT",TOrderStatusDR),"^",1)
	if (orderStatCode="U")||(orderStatCode="P")||(orderStatCode="I")||(orderStatCode="C") {
		s ErrMsg=PreErrMsg_..%GetErrCodeMsg(orderStatCode)
		Q orderStatCode
	}
	//Q:##class(PHA.FACE.OUT.Com).IfOeoreHas60(oeorerowid)="Y" "HaveDispen"
	s rtn = ##class(web.DHCDocMain).CheckOperationPermission(oeorerowid)
	if (rtn=1){
		s ErrMsg=PreErrMsg_..%GetErrCodeMsg("-100049")
		Q "-100049" //-900
	}
	
	;停止执行时护士不能撤销执行非本科室/病区的执行记录
	s OrdPriorityDR=$p(^OEORD(+oeorerowid,"I",$p(oeorerowid,"||",2),1),"^",8)
	if (##class(appcom.OEOrdItem).ISLongOrderPrior(OrdPriorityDR)) {
		s OrdDeptId = $p($g(^OEORD(+oeorerowid,"I",$p(oeorerowid,"||",2),7)),"^",2)	;开单科室
		s AdmLocDR = $p($g(^OEORD(+oeorerowid,"I",$p(oeorerowid,"||",2),9)),"^",2)	;病人所在病区
		if (+OrdDeptId >0)&&(AdmLocDR>0) {
			s LinkLoc=##class(web.DHCDocOrderCommon).GetLocLinkLocation(locid)
			if ((locid'=OrdDeptId)&&(("^"_LinkLoc_"^")'[("^"_OrdDeptId_"^")))
				&&(locid'=AdmLocDR)&&(("^"_LinkLoc_"^")'[("^"_AdmLocDR_"^")) {
				s ErrMsg=PreErrMsg_..%GetErrCodeMsg("-100077")
				Q "-100077" //-901
			}
		}
	}
	Q 0
}

/// 判断执行记录是否能否撤消执行
ClassMethod IsCanCancelExecOrdArrear(oeorerowid As %String, locid As %String, ExpStr As %String = "", ByRef ErrMsg As %String = "") As %String
{
	s str = ^OEORD(+oeorerowid,"I",$p(oeorerowid,"||",2),"X",$p(oeorerowid,"||",3))
	s ExecStateDR= $p(str,"^",16)
	i +ExecStateDR>0 s execStatus = $p(^OEC("STAT",ExecStateDR),"^",1)
	e  s execStatus = "未执行"
	s ExStDate=$p(str,"^",1)
	s ExStTime = $p(str,"^",2)
	Set langid=..%LanguageID()
	s PreErrMsg=..%Translate("ipdoc.patinfoview.csp","执行记录",langid)_"："_..%ZD(ExStDate)_" "_..%ZT(ExStTime,1)_" "
	if (execStatus'="F") {
		s ErrMsg=PreErrMsg_..%GetErrCodeMsg("-100054")
		Q "-100054" //"NotR"
	}
	s TOrderStatusDR=$p(^OEORD(+oeorerowid,"I",$p(oeorerowid,"||",2),1),"^",13)
	s:+TOrderStatusDR>0 orderStatCode = $p(^OEC("OSTAT",TOrderStatusDR),"^",1)
	if (orderStatCode="E")||(orderStatCode="A") {
		s ErrMsg=PreErrMsg_..%GetErrCodeMsg(orderStatCode)
		Q orderStatCode
	}
	
	s EpisodeID=$p(^OEORD(+oeorerowid),"^",1)
	//撤销执行没必要调IsCanExecOrdArrear吧
	/*s IsCanExecOrdArrear = ##class(web.DHCDocMainOrderInterface).IsCanExecOrdArrear(EpisodeID,oeorerowid,locid,"","",.ErrMsg)
	if (IsCanExecOrdArrear="PlacerNo") s IsCanExecOrdArrear=1
	if (IsCanExecOrdArrear="-100056") s IsCanExecOrdArrear=1
	Q:IsCanExecOrdArrear'=1 IsCanExecOrdArrear*/
	s IsCancelArrivedOrd=1
	i $d(^DHCDocCure(0,"OEORE",oeorerowid)) d
	.s DCARowId=$o(^DHCDocCure(0,"OEORE",oeorerowid,""))
	.i DCARowId'="" d 
	..s DCAAChildSub=$O(^DHCDocCure(0,"OEORE",oeorerowid,DCARowId,""))
	..s DCAAStatus=$p(^DHCDocCure(DCARowId,"Arrive",DCAAChildSub),"^",7)
	..i DCAAStatus="A" s IsCancelArrivedOrd=0
	if IsCancelArrivedOrd=0 {
		s ErrMsg=PreErrMsg_..%GetErrCodeMsg("-100055")
		Q "-100055" //HaveCure
	}
	//Q:##class(PHA.FACE.OUT.Com).IfOeoreHas60(oeorerowid)="Y" "HaveDispen"
	s rtn = ##class(web.DHCDocMain).CheckOperationPermission(oeorerowid)
	if (rtn=1){
		s ErrMsg=PreErrMsg_..%GetErrCodeMsg("-100049")
		Q "-100049" //-900
	}
	Q 0
}

/// w ##Class(web.DHCDocInPatPortalCommon).GetMsg(-1000000)
ClassMethod GetMsg(rtn) As %String
{
	s msgmap("PS")="实习医师审核成功,请上级医师审核完成该操作."	
	s msgmap("104")="已分配的治疗申请不允许撤销/作废"	
	s msgmap("102")="存在已执行的执行记录的治疗申请单不允许撤销/作废"	
	s msgmap("101")="已完成的治疗申请单不允许撤销/作废"	
	s msgmap("100")="已经存在预约记录或治疗记录,不允许撤销/作废"	
	s msgmap("-4")="签名密码错误!"	
	s msgmap("-100")="医嘱不存在"	
	s msgmap("-200")="护士已执行或已收费,不能进行该操作!"	
	s msgmap("-201")="已经停止的医嘱不用再停"	
	s msgmap("-202")="已收费医嘱不允许撤销，请直接做退费审核或退药!"	
	s msgmap("-205")="更新医嘱状态及变化表"	
	s msgmap("-207")="护士已经扫过条码,请撤销条码后再处理医嘱"	
	s msgmap("-208")="作废医嘱要和下医嘱人一致"	
	s msgmap("-209")="非核实状态的医嘱不能作废"	
	s msgmap("-210")="实库库管已进行医嘱提取,需要经过高值材料库管员退货确认,才能继续操作"	
	s msgmap("-211")="执行状态的医嘱才能变为核实"	//原209
	s msgmap("-212")="填写了整包装数量的医嘱无法拆包装退药"
	
	s msgmap("-301")="停止医嘱执行记录失败"	
	s msgmap("-302")="执行记录已结算或完成,不能执行该操作" //该医嘱已发药，请护士撤销执行后进行停止操作	
	s msgmap("-303")="执行记录状态没有变化, 不用改变"	
	s msgmap("-304")="执行记录已经执行,不能停止"	
	s msgmap("-305")="执行记录没有执行,不需要撤销"	
	s msgmap("-306")="执行记录保存失败"	
	s msgmap("-307")="执行记录变化表保存失败"	
	s msgmap("-308")="执行记录计费变化表保存失败"	
	s msgmap("-310")="计费状态相同,不用改变"	
	s msgmap("-311")="已经退费,不需要再免费"
	s msgmap("-312")="执行记录扩展表保存失败"	//原310	
	s msgmap("-313")="已经待计费,不需要取消免费"	
	s msgmap("-314")="临时医嘱不能停止执行记录，只能撤销医嘱!" //临时医嘱未停止,不能停止执行	
	s msgmap("-315")="修改执行记录医嘱状态失败"	
	s msgmap("-316")="医嘱已停止不能再执行 "	
	s msgmap("-317")="执行记录在医嘱停止日期之后,不能执行!"	
	s msgmap("-318")="已经治疗的治疗记录不允许停止!"	
	s msgmap("-319")="已结算的执行记录不允许再停止执行,请先撤销结算!"
		
	s msgmap("-400")="实习医师审核操作失败!"	
	s msgmap("-401")="实习医师无法进行预停操作!"
		
	s msgmap("-900")="子嘱为药品的执行记录不能操作"	
	s msgmap("-901")="医嘱单顺序已经发生变化,请重新打印!"	
	s msgmap("-902")="请补打作废标识!"	
	s msgmap("-903")="皮试阴性才能执行!"	
	s msgmap("-904")="申请状态在OEC_ApplyStatus表中不存在"	
	s msgmap("-905")="保存申请失败!"	
	s msgmap("-906")="保存申请撤销状态失败"	
	s msgmap("-907")="已申请,请等待审核"	
	s msgmap("-908")="执行时间不能小于要求执行时间"	
	s msgmap("-909")="执行日期不能小于要求执行日期"	
	s msgmap("-910")="要求执行日期时间不能大于预停日期时间"	
	s msgmap("-911")="申请单当前状态，不允许进行取消操作！"	
	s msgmap("-2091")="非核实状态的医嘱不能撤销"	
	s msgmap("-15304")="拆账单的产生的自定价医嘱,不能进行该操作!"	
	s msgmap("-15305")="停止时间之后的执行记录已被执行! 请先撤销执行记录"	
	s msgmap("-15306")="存在已治疗的执行记录,无法进行撤销和作废操作!"	
	s msgmap("-15307")="主医嘱跟关联医嘱被拆分到不同账单,不能进行该操作!"	
	s msgmap("-15308")="停止时间之后的执行记录静配中心是否已经配液!"	
	s msgmap("-15310")="要求执行日期不能小于医嘱开始日期!"	
	s msgmap("-15500")="增加备注失败"	
	s msgmap("-15501")="保存虚拟长期医嘱数据失败"	
	s msgmap("-2000")=$p(rtn,"^",2)_" 已登记或出报告,不能撤销或作废"
	s msgmap("-2001")="工号"_$p(rtn,"^",2)_"不存在"
	s msgmap("-2002")="工号"_$p(rtn,"^",2)_"的密码不对"
	s rtn=$p(rtn,"^",1)
	if (+rtn=0) s msg="0"
	e  s msg=$g(msgmap(rtn),rtn),msg=..%Translate("ipdoc.patinfoview.csp",msg)
	Q msg
}

/// 判断医嘱处理的权限
/// 0 有权限 其他 无权限
/// w ##class(web.DHCDocInPatPortalCommon).CheckMulOrdDealPermission("82||47"_$c(1)_"2020-06-17 16:02:07^82||49"_$c(1)_"2020-06-17 16:04:05^82||50"_$c(1)_"2020-06-17 16:04:05^82||51"_$c(1)_"2020-06-17 16:04:05^82||52"_$c(1)_"2020-06-17 16:04:05","","","C","11841^203^104^^")
ClassMethod CheckMulOrdDealPermission(OrderItemStr As %String, date As %String, time As %String, type As %String, ExpStr As %String, ByRef ErrMsg As %String = "") As %String
{
	s ^tempscl("CheckMulOrdDealPermission")=OrderItemStr_","_date_","_time_","_type_","_ExpStr
	s user=$p(ExpStr,"^",1)
	s locid=$p(ExpStr,"^",2)
	s groupid=$p(ExpStr,"^",3)
	s ReasonId=$p(ExpStr,"^",4)
	s Reasoncomment=$p(ExpStr,"^",5)
	s StopDealType=$p(ExpStr,"^",6) //ReturnVirLongOrdExec 虚拟长期执行记录退费
	s CurLogonHosp=$p($g(^CTLOC(locid)),"^",22)
	if (type="S"){
		s stopMsg="0"	;默认有权限停医嘱
		for i=1:1:$l(OrderItemStr,"^"){
			s oneitem=$p(OrderItemStr,"^",i)
			s oeorirowid=$p(oneitem,$C(1),1)
			;0 没有权限 1 有权限
			s ErrCode = ##class(web.DHCDocMain).CheckStopOrder(oeorirowid,user,locid,groupid,date,time,.ErrMsg)
			if (+ErrCode'=1) {
				s ErrMsg=..%Translate("ipdoc.patinfoview.csp","您无权停止 ")_$$GetArcimDesc(oeorirowid)_..%Translate("ipdoc.patinfoview.csp"," 医嘱！")_..%Translate("ipdoc.patinfoview.csp",ErrMsg)
				s stopMsg=ErrMsg
				Q
			}
		}
		Q stopMsg
	}elseif (type="C"){
		s oeorirowid=$p($p(OrderItemStr,"^",1),$C(1),1)
		s adm = $p(^OEORD(+oeorirowid),"^",1)
		s AdmType=$p(^PAADM(adm),"^",2)
		s StopGroupOrder=..%GetConfig("StopGroupOrder",CurLogonHosp)
		s cancelMsg="0"	;默认有权限
		for i=1:1:$l(OrderItemStr,"^"){
			s oneitem=$p(OrderItemStr,"^",i)
			s oeorirowid=$p(oneitem,$C(1),1)
			s OrderName=$$GetArcimDesc(oeorirowid)
			;判断是否为输血医嘱,如果是则跳过并在界面给出提示
			s BloodOrdFlag=##CLASS(DHCLIS.DHCBloodInterface).GetReqFormNo(oeorirowid)
			if (BloodOrdFlag'="")&&($p(BloodOrdFlag,"^",1)'="-1"){
				s ErrMsg=OrderName_" 是输血申请单医嘱，请在输血申请单页面进行撤销！"
				s cancelMsg=ErrMsg
				Q
			}
			if (AdmType'="I"){
				s stat=$p($g(^OEORD(+oeorirowid,"I",+$p(oeorirowid,"||",2),1)),"^",13)
				i stat s stat=$p($g(^OEC("OSTAT",stat)),"^")
				if stat="D" {
					s ErrMsg=OrderName_..%Translate("ipdoc.patinfoview.csp","已停止!")
					s cancelMsg=ErrMsg
					Q
				}
				;仅允许撤销本人所开医嘱(门急诊)
				s OPOrdStopLimit=..%GetConfig("OPOrdStopLimit",CurLogonHosp)
				if (OPOrdStopLimit=1){
				  s DoctorDR=$p($g(^OEORD(+oeorirowid,"I",$p(oeorirowid,"||",2),1)),"^",11)
				  i (##class(web.DHCDocOrderCommon).IsEntryOEORIUser(oeorirowid,user)="N")&&(DoctorDR'="") {
					  s OrdInternalType=##class(web.DHCDocMain).GetCarePrvTp(DoctorDR)
					  if ($g(OrdInternalType)'="Pharmacist") {
						  s cancelMsg=OrderName_..%Translate("ipdoc.patinfoview.csp","非本人医嘱不能撤销！")
						  s ErrMsg=cancelMsg
						  Q
					  }
				  }
				}
				if ##class(web.UDHCStopOrderLook).IsPayCanStopOrder(oeorirowid)=1 {
					s cancelMsg=..%Translate("ipdoc.patinfoview.csp","您无权撤销 ")_OrderName_..%Translate("ipdoc.patinfoview.csp"," 医嘱！")_..%Translate("ipdoc.patinfoview.csp",..%GetErrCodeMsg("-100071"))
					s ErrMsg=cancelMsg
					Q
				}
				s IsOrdExecFlag=+##class(web.UDHCStopOrderLook).IsOrdExec(oeorirowid)
				if (IsOrdExecFlag>0) {
					if (StopDealType="") {
						s cancelMsg=..%Translate("ipdoc.patinfoview.csp","您无权撤销 ")_OrderName_..%Translate("ipdoc.patinfoview.csp"," 医嘱！")_..%Translate("ipdoc.patinfoview.csp",..%GetErrCodeMsg("-100071"))
					}elseif (IsOrdExecFlag=2){
						s cancelMsg=..%Translate("ipdoc.patinfoview.csp","您无权撤销 ")_OrderName_..%Translate("ipdoc.patinfoview.csp"," 医嘱！执行记录已全部执行！")
					}					
					s ErrMsg=cancelMsg
					Q
				}
				s PrescUndoRtn=##class(DHCDoc.Interface.Inside.InsuPresc.Order).CheckPrescUndoByOrder(oeorirowid,ExpStr)
				if (+PrescUndoRtn'="0") {
					s cancelMsg=OrderName_..%Translate("ipdoc.patinfoview.csp",$p(PrescUndoRtn,"^",2))
					s ErrMsg=cancelMsg
					Q
				}
				if (StopGroupOrder=1){
					s OrdLinkRowId=$p($g(^OEORD(+oeorirowid,"I",$p(oeorirowid,"||",2),11)),"^",39)
					if (OrdLinkRowId'=""){
						s flag = ##class(web.DHCDocMain).CheckCancelOrder(OrdLinkRowId,user,locid,groupid,.ErrMsg)
						if (+flag'=1){
							s cancelMsg=..%Translate("ipdoc.patinfoview.csp","您无权撤销 ")_OrderName_..%Translate("ipdoc.patinfoview.csp"," 医嘱！对应主医嘱：")_$$GetArcimDesc(OrdLinkRowId)_..%Translate("ipdoc.patinfoview.csp",ErrMsg)
							s ErrMsg=cancelMsg
							Q
						}
						if ##class(web.UDHCStopOrderLook).IsPayCanStopOrder(OrdLinkRowId)=1 {
							s cancelMsg=..%Translate("ipdoc.patinfoview.csp","您无权撤销 ")_OrderName_..%Translate("ipdoc.patinfoview.csp"," 医嘱！对应主医嘱：")_$$GetArcimDesc(OrdLinkRowId)_..%Translate("ipdoc.patinfoview.csp",..%GetErrCodeMsg("-100071"))
							s ErrMsg=cancelMsg
							Q
						}
						s IsOrdExecFlag=+##class(web.UDHCStopOrderLook).IsOrdExec(OrdLinkRowId)
						if (IsOrdExecFlag>0) {
							if (StopDealType="") {
								s cancelMsg=..%Translate("ipdoc.patinfoview.csp","您无权撤销 ")_OrderName_..%Translate("ipdoc.patinfoview.csp"," 医嘱！对应主医嘱：")_$$GetArcimDesc(OrdLinkRowId)_..%Translate("ipdoc.patinfoview.csp",..%GetErrCodeMsg("-100071"))
							}elseif (IsOrdExecFlag=2){
								s cancelMsg=..%Translate("ipdoc.patinfoview.csp","您无权撤销 ")_OrderName_..%Translate("ipdoc.patinfoview.csp"," 医嘱！对应主医嘱：")_$$GetArcimDesc(OrdLinkRowId)_..%Translate("ipdoc.patinfoview.csp","执行记录已全部执行！")
							}					
							s ErrMsg=cancelMsg
							Q
						}
					}else{
						s Sub=$O(^OEORDi(0,"OEORI",+oeorirowid,oeorirowid,0))
						While (Sub'="")&&(cancelMsg="0") {
							s SubRowId=+oeorirowid_"||"_Sub
							s SubOrdStateCode=##class(appcom.OEOrdItem).GetStatusCode(SubRowId) 
							if SubOrdStateCode="V" {
								s flag = ##class(web.DHCDocMain).CheckCancelOrder(SubRowId,user,locid,groupid,.ErrMsg)
								if (+flag'=1){
									s cancelMsg=..%Translate("ipdoc.patinfoview.csp","您无权撤销 ")_OrderName_..%Translate("ipdoc.patinfoview.csp"," 医嘱！对应子医嘱：")_$$GetArcimDesc(SubRowId)_..%Translate("ipdoc.patinfoview.csp",ErrMsg)
									s ErrMsg=cancelMsg
									Q
								}
								if (##class(web.UDHCStopOrderLook).IsPayCanStopOrder(SubRowId)=1)||((StopDealType="")&&(+##class(web.UDHCStopOrderLook).IsOrdExec(SubRowId)>0)) {
									s cancelMsg=..%Translate("ipdoc.patinfoview.csp","您无权撤销 ")_OrderName_..%Translate("ipdoc.patinfoview.csp"," 医嘱！对应子医嘱：")_$$GetArcimDesc(SubRowId)_..%Translate("ipdoc.patinfoview.csp",..%GetErrCodeMsg("-100071"))
									s ErrMsg=cancelMsg //..GetMsg("-200")
									Q
								}
							}
							s Sub=$O(^OEORDi(0,"OEORI",+oeorirowid,oeorirowid,Sub))
						}
					}
				}
			}
			s ErrCode = ##class(web.DHCDocMain).CheckCancelOrder(oeorirowid,user,locid,groupid,.ErrMsg)
			;0 没有权限 1 有权限
			if (+ErrCode'=1){
				s ErrMsg=..%Translate("ipdoc.patinfoview.csp","您无权撤销 ")_OrderName_..%Translate("ipdoc.patinfoview.csp"," 医嘱！")_..%Translate("ipdoc.patinfoview.csp",ErrMsg)
				s cancelMsg=ErrMsg
				Q
			}
		}
		Q cancelMsg
	}elseif (type="U"){
		s oeorirowid=$p($p(OrderItemStr,"^",1),$C(1),1)
		s adm = $p(^OEORD(+oeorirowid),"^",1)
		s AdmType=$p(^PAADM(adm),"^",2)
		s len = $l(OrderItemStr,"^")
		s unUseMsg="0"	;默认有权限
		for i=1:1:$l(OrderItemStr,"^"){
			s oneitem=$p(OrderItemStr,"^",i)
			s oeorirowid=$p(oneitem,$C(1),1)
			s ARCIMDesc=$$GetArcimDesc(oeorirowid)
			;判断是否为输血医嘱,如果是则跳过并在界面给出提示
			s BloodOrdFlag=##CLASS(DHCLIS.DHCBloodInterface).GetReqFormNo(oeorirowid)
			if (BloodOrdFlag'="")&&($p(BloodOrdFlag,"^",1)'="-1"){
				s unUseMsg=ARCIMDesc_..%Translate("ipdoc.patinfoview.csp"," 是输血申请单医嘱，请在输血申请单页面进行作废！"),ErrMsg=unUseMsg
				Q
			}
			if (AdmType'="I"){
				if ##class(web.UDHCStopOrderLook).IsPayCanStopOrder(oeorirowid)=1 {
					s unUseMsg=..%Translate("ipdoc.patinfoview.csp","您无权作废 ")_ARCIMDesc_..%Translate("ipdoc.patinfoview.csp"," 医嘱！")_ARCIMDesc_..%Translate("ipdoc.patinfoview.csp",..%GetErrCodeMsg("-100071"))
					s ErrMsg=unUseMsg //..GetMsg("-200")
					Q
				}
			}
			s ErrCode = ##class(web.DHCDocMain).CheckUnuseOrder(oeorirowid,user,locid,groupid,.ErrMsg)
			if (+ErrCode'=1){
				s unUseMsg=..%Translate("ipdoc.patinfoview.csp","您无权作废 ")_ARCIMDesc_..%Translate("ipdoc.patinfoview.csp"," 医嘱！")_..%Translate("ipdoc.patinfoview.csp",ErrMsg),ErrMsg=unUseMsg
				Q
			}
		}
		Q unUseMsg
	}elseif(type="SInEM"){
		//急诊停医嘱,可能涉及虚拟长期，单独独立写
		s stopMsg="0"	;默认有权限停医嘱
		for i=1:1:$l(OrderItemStr,"^"){
			s oneitem=$p(OrderItemStr,"^",i)
			s oeorirowid=$p(oneitem,$C(1),1)
			s ordStDateStr=$p(oneitem,$C(1),2)
			;0 没有权限 1 有权限
			s ErrCode = ##class(web.DHCDocOrderVirtualLong).CheckStopOrder(oeorirowid,user,locid,groupid,date,time,.ErrMsg,.StopExecStr)
			if (+ErrCode'=1){
				s ARCIMDesc=$$GetArcimDesc(oeorirowid)
				s stopMsg=..%Translate("ipdoc.patinfoview.csp","您无权停止 ")_ARCIMDesc_..%Translate("ipdoc.patinfoview.csp"," 医嘱！")_..%Translate("ipdoc.patinfoview.csp",ErrMsg),ErrMsg=stopMsg
				Q
			}
		}
		Q stopMsg
	}
	Q 0
GetArcimDesc(oeorirowid)
	Set langid=..%LanguageID()
	s str1 = ^OEORD(+oeorirowid,"I",$p(oeorirowid,"||",2),1)
	s ItmMastDR=$p(str1,"^",2)
	s ARCIMDesc=$p(^ARCIM(+ItmMastDR,$p(ItmMastDR,"||",2),1),"^",2)	
	s ARCIMDesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",ARCIMDesc,langid)
	Q ARCIMDesc
}

/// 判断执行记录处理权限
/// 0 有  其他 无  
/// w ##class(web.DHCDocInPatPortalCommon).CheckMulOrdExecDealPermission("146||11||144^146||11||145","","","CD","12177^114^23^^")
ClassMethod CheckMulOrdExecDealPermission(OrderExecStr As %String, date As %String, time As %String, type As %String, ExpStr As %String, ByRef ErrMsg As %String = "") As %String
{
	s ^tempscl("CheckMulOrdExecDealPermission")=OrderExecStr_","_date_","_time_","_type_","_ExpStr
	s user=$p(ExpStr,"^",1)
	s locid=$p(ExpStr,"^",2)
	s groupid=$p(ExpStr,"^",3)
	if (type="R"){
		s RunExecMsg="0"
		for i=1:1:$l(OrderExecStr,"^") {
			s orderExecId=$p(OrderExecStr,"^",i)
			s rtnCode=##class(web.DHCDocMainOrderInterface).IsCanExecOrdArrear("",orderExecId,locid,date,time,.ErrMsg)
			if (rtnCode="PlacerNo")||(rtnCode="1") s rtnCode=0
			if rtnCode'="0" {
				s RunExecMsg=ErrMsg
				Q
			}
		}
		Q RunExecMsg
	}elseif (type="C"){
		s CancelExecMsg="0"
		for i=1:1:$l(OrderExecStr,"^") {
			s orderExecId=$p(OrderExecStr,"^",i)
			s rtnCode=..IsCanCancelExecOrdArrear(orderExecId,locid,"",.ErrMsg)
			if rtnCode'="0" {
				s CancelExecMsg=ErrMsg
				Q
			}
		}
		Q CancelExecMsg
	}elseif(type="D"){
		s DisExecMsg="0"
		for i=1:1:$l(OrderExecStr,"^") {
			s orderExecId=$p(OrderExecStr,"^",i)
			s rtnCode=..IsCanDisExecOrdArrear(orderExecId,locid,"",.ErrMsg)
			if rtnCode'="0" {
				s DisExecMsg=ErrMsg
				Q
			}
		}
		Q DisExecMsg
	}elseif(type="CD"){
		//撤销并停止
		s CancelDisExecMsg="0"
		for i=1:1:$l(OrderExecStr,"^") {
			s orderExecId=$p(OrderExecStr,"^",i)
			s str = ^OEORD(+orderExecId,"I",$p(orderExecId,"||",2),"X",$p(orderExecId,"||",3))
			s ExecStateDR= $p(str,"^",16)
			s execStatus=""
			i +ExecStateDR>0 s execStatus = $p(^OEC("STAT",ExecStateDR),"^",1)
			if ($g(execStatus)="F"){
				s rtnCode=..IsCanCancelExecOrdArrear(orderExecId,locid,"",.ErrMsg)
			}else{
				s rtnCode=..IsCanDisExecOrdArrear(orderExecId,locid,"",.ErrMsg)
			}
			if rtnCode'="0" {
				if (rtnCode="-100052") s rtnCode="-100053"
				s ErrMsg=..%GetErrCodeMsg(rtnCode)
				s CancelDisExecMsg=ErrMsg
				Q
			}
		}
		Q CancelDisExecMsg
	}elseif (type="ExecAppend"){
		//执行医嘱时手工绑定医嘱
		s orderExecId=$p(OrderExecStr,"^",1)
		Set SeeOrdRtn = ##class(web.DHCLCNUREXCUTE).GetSeeOrdInfo(+orderExecId,$P(orderExecId,"||",2))
		If (SeeOrdRtn="^^"){
			s ErrMsg=..%Translate("ipdoc.patinfoview.csp","医嘱未处理不能绑定！")
			Quit ErrMsg
		}
		s CancelDisExecMsg="0"
		s len = $l(OrderExecStr,"^")
		s i=1
		while (i<=len)&&(CancelDisExecMsg="0") {
			s orderExecId=$p(OrderExecStr,"^",i)
			s str = ^OEORD(+orderExecId,"I",$p(orderExecId,"||",2),"X",$p(orderExecId,"||",3))
			s ExStDate=$p(str,"^",1)
			s ExStTime = $p(str,"^",2)
			s ExStDateStr=..%ZD(ExStDate)_" "_..%ZT(ExStTime,1)
			s ExecStateDR= $p(str,"^",16)
			s execStatus=""
			i +ExecStateDR>0 s execStatus = $p(^OEC("STAT",ExecStateDR),"^",1)
			if (execStatus="D"){
				s CancelDisExecMsg=..%Translate("ipdoc.patinfoview.csp","执行记录已停止,不能进行绑定!")
				s CancelDisExecMsg=ExStDateStr_CancelDisExecMsg,ErrMsg=CancelDisExecMsg
				Q
			}
			s i=i+1
		}
		Q:CancelDisExecMsg'=0 CancelDisExecMsg
		s EpisodeID=$P(^OEORD(+orderExecId),"^",1)
		s ItmMastDR = $p($G(^OEORD(+orderExecId,"I",$P(orderExecId,"||",2),1)),"^",2)
		s instrDr = $p($G(^OEORD(+orderExecId,"I",$P(orderExecId,"||",2),2)),"^",7)
		s PriorityDR = $p($G(^OEORD(+orderExecId,"I",$P(orderExecId,"||",2),1)),"^",8)
		s ArcimWardInfo=##Class(DHCDoc.DHCDocConfig.InstrArcim).GetArcimWardInfo(EpisodeID,ItmMastDR,instrDr,"2")
		s FindExecAppendFlag="N"
		for i=1:1:$L(ArcimWardInfo,$C(2)) {
			s ArcimWard=$P(ArcimWardInfo,$C(2),i)
			s ByHand=$P(ArcimWard,"^",8)
			continue:(ByHand'=2)
			s NotLinkPriorStr=$P(ArcimWard,"^",9)
			continue:(("_"_NotLinkPriorStr_"_")[("_"_PriorityDR_"_"))
			s FindExecAppendFlag="Y"
		}
		if (FindExecAppendFlag="N"){
			s ErrMsg=..%Translate("ipdoc.patinfoview.csp","未关联可以进行手动绑定的医嘱项！")
			Q ErrMsg
		}else{
			Q "0"
		}
	}
GetArcimDesc(oeorirowid)
	Set langid=..%LanguageID()
	s str1 = ^OEORD(+oeorirowid,"I",$p(oeorirowid,"||",2),1)
	s ItmMastDR=$p(str1,"^",2)
	s ARCIMDesc=$p(^ARCIM(+ItmMastDR,$p(ItmMastDR,"||",2),1),"^",2)	
	s ARCIMDesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",ARCIMDesc,langid)
	Q ARCIMDesc
}

ClassMethod GetExecMsg(rtn)
{
	s msgmap("NotCF")="只有未执行与撤销执行的执行记录才能执行!"
	s msgmap("NotC")="只有未执行/撤销执行的执行记录才能停止!"
	s msgmap("NotCD")="只有未执行/撤销执行/已执行的执行记录才能撤销并停止!"
	s msgmap("NotR")="已执行的才能撤销!"
	s msgmap("HaveCure")="治疗记录已经治疗,不能撤销执行!"
	s msgmap("U")="医嘱已作废!"
	s msgmap("P")="医嘱Pre-Order"
	s msgmap("I")="医嘱未核实!"
	s msgmap("E")="医嘱已执行!"
	s msgmap("FeeNotEnough")="费用不足,不能执行!"
	s msgmap("SkinAbnorm")="皮试医嘱结果为阳性,不能执行!"
	s msgmap("DrugSubOrder")="药品子医嘱,不能执行!"
	s msgmap("NotSeeOrd")="医嘱未处理,不能执行! "
	s msgmap("NotIPMonitorRtn")="药品审核不通过,不能执行!"
	s msgmap("NurReject")="护士已拒绝,不能执行!"
	s msgmap("LabOrdNotPrintBar")="检验医嘱请先打印条码再执行!"
	s msgmap("HaveDispen")="静配中心已配液!"
	s msgmap("-900")="子嘱为药品的执行记录不能操作!"
	s msgmap("-901")="没有权限,请核实,[当前用户]不是医嘱[开单科室]的[医护人员]!"
	s msgmap("ExceedDischargeDate")="执行时间不能晚于患者出院时间"
	s msgmap("ExceedOEORIDate")="执行时间不能早于医嘱开立时间"
	if (rtn=0) s msg="0"
	e  s msg=$g(msgmap(rtn),rtn)
	s:msg'="0" msg=..%Translate("ipdoc.patinfoview.csp",msg)
	Q msg
}

Query FindOrderFee(orderId) As websys.Query(ROWSPEC = "FeeId:%String,TCancelStatu:%String,TTarDesc:%String:收费项名称^150,TTarCode:%String:代码^80,TQty:%String:数量^50,TPrice:%String:单价^50,TAmount:%String:金额^50,TDate:%String:记账时间,TExtralComment:%String:原因")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCDocMain","FindOrderFee","77071||59||2")
ClassMethod FindOrderFeeExecute(ByRef qHandle As %Binary, orderId) As %Status
{
		set repid = $I(^CacheTemp)
		if $g(ind) = "" set ind = 0
		Set langid=..%LanguageID()
		i orderId="" set qHandle = $lb(0,repid,0) Q $$$OK
		;s ^Temp("wanghc","orderfee")=orderId
		s flag = $l(orderId,"||")
		i flag'=3 set qHandle = $lb(0,repid,0) Q $$$OK
		
		s (pb,pbo,pbd)=0
		//医嘱表 写法有问题
		i flag=2 d	//医嘱orditemrowid
		.s pb = $o(^DHCPBi(0,"OEORI",orderId,""),-1)
		.q:+pb'>0
		.s pbo = $o(^DHCPBi(0,"OEORI",orderId,pb,""),-1)
		.q:+pbo'>0
		e  i flag=3 d	//执行医嘱ordexecrowid
		.s pb = $O(^DHCPB(0,"OEEXC",orderId,""),-1)
		.q:+pb'>0
		.s pbo = $O(^DHCPB(0,"OEEXC",orderId,pb,""),-1)
		.q:+pbo'>0
		
		i pbo'>0 set qHandle = $lb(0,repid,0) Q $$$OK
		s TPBOrderBillStatus = $p(^DHCPB(pb,"O",pbo),"^",16)
		f  s pbd = $o(^DHCPB(pb,"O",pbo,"D",pbd)) q:pbd=""  d
		.s (TTarDesc,TTarCode,TQty,TPrice,TAmount,TDate)=""
		.s str = ^DHCPB(pb,"O",pbo,"D",pbd)
		.s tar = $p(str,"^",3)
		.q:+tar'>0
		.s TTarDesc = $p(^DHCTARI(tar),"^",2)
		.s TTarDesc=##class(User.DHCTarItem).GetTranByDesc("TARIDesc",TTarDesc,langid)
		.s TTarCode = $p(^DHCTARI(tar),"^",1)
		.s TQty = $fn($p(str,"^",5),"",2)
		.s TPBDBillStatus="B"
		.i TPBOrderBillStatus="R" s TPBDBillStatus="R"
		.i TPBOrderBillStatus="P" s TPBDBillStatus="R"
		.s TPBDOriginalDR = $p(str,"^",23)
		.i +TPBDOriginalDR>0 s TPBDBillStatus="R"
		.e  i $d(^DHCPB(0,"OriginalDR",pb_"||"_pbo_"||"_pbd))=10 s TPBDBillStatus="R"
		.;e  s TPBDBillStatus="B"
		.s TExtralComment=$p(str,"^",24)
		.;s TPrice = $p(str,"^",4)
		.;s TAmount = $p(str,"^",7)
		.s TPrice = $fn($p(str,"^",4),"-")
		.s TAmount = $fn($p(str,"^",7),"-")
		.if (TQty<0) s TAmount="-"_TAmount
		.s TDate = $p(str,"^",11)
		.s:TDate'="" TDate=..%ZD(TDate)
		.s ind = ind+1
		.s ^CacheTemp(repid,ind) = $lb(pb_"||"_pbo_"||"_pbd,TPBDBillStatus,TTarDesc,TTarCode,TQty,TPrice,TAmount,TDate,TExtralComment)
		set qHandle = $lb(0,repid,0)
		Q $$$OK
}

/// w ##Class(web.DHCDocInPatPortalCommon).LoadNursingData(195)
ClassMethod LoadNursingData(EpisodeID As %String) As %String
{
	s StartDate=..%SysDate()-6
	s EndDate=..%SysDate()
	s JsonObj=[]
	s DailyStartTime=..%ZTH("02:00:00")
	K DateListArr
	for i=1:1:(EndDate-StartDate+1){
		for j=0:1:5 {
			s DateListArr((StartDate+i-1),DailyStartTime+(..%ZTH("04:00:00")*j))=""
		}
	}
	s JsonData={}
	Set rset=##Class(%ResultSet).%New("Nur.OverViewInterface.GetTempData")
	If rset.QueryIsValid() {
		Set Status=rset.Execute($ZD(StartDate,3),$ZD(EndDate,3),EpisodeID)
		If 'Status Quit
		Set columns = rset.GetColumnCount()
		While (rset.Next()) {
			///OBSDate:%Date,OBSTime:%Time,OBSValue:%Float,OBSUser:%String
			s OBSDate=rset.GetData(1)
			s OBSTime=rset.GetData(2)
			s OBSValue=rset.GetData(3)
			s OBSUser=rset.GetData(4)
			s DateListArr($ZDH(OBSDate,3),..%ZTH(OBSTime),"Temperature")=OBSValue
		}
	}
	d rset.Close()
	Set rset=##Class(%ResultSet).%New("Nur.OverViewInterface.GetBloodPreData")
	If rset.QueryIsValid() {
		Set Status=rset.Execute($ZD(StartDate,3),$ZD(EndDate,3),EpisodeID)
		If 'Status Quit
		Set columns = rset.GetColumnCount()
		While (rset.Next()) {
			///OBSDate:%Date,OBSTime:%Time,OBSValue:%Float,OBSUser:%String
			s OBSDate=rset.GetData(1)
			s OBSTime=rset.GetData(2)
			s SysValue=rset.GetData(3)
			s DiaValue=rset.GetData(4)
			s OBSUser=rset.GetData(4)
			//w OBSDate_","_OBSTime_","_SysValue_","_DiaValue,!
			s DateListArr($ZDH(OBSDate,3),..%ZTH(OBSTime),"BloodPressure")=SysValue_"/"_DiaValue
		}
	}
	d rset.Close()
	Set rset=##Class(%ResultSet).%New("Nur.OverViewInterface.GetPulseData")
	If rset.QueryIsValid() {
		Set Status=rset.Execute($ZD(StartDate,3),$ZD(EndDate,3),EpisodeID)
		If 'Status Quit
		Set columns = rset.GetColumnCount()
		While (rset.Next()) {
			///OBSDate:%Date,OBSTime:%Time,OBSValue:%Float,OBSUser:%String
			s OBSDate=rset.GetData(1)
			s OBSTime=rset.GetData(2)
			s OBSValue=rset.GetData(3)
			s OBSUser=rset.GetData(4)
			//w OBSDate_","_OBSTime_","_OBSValue,!
			s DateListArr($ZDH(OBSDate,3),..%ZTH(OBSTime),"Pulse")=OBSValue
		}
	}
	d rset.Close()
	//每个天数的测量个数
	s MaxNumTime=0
	s Date=0
	for {
		s Date=$O(DateListArr(Date))
		q:(Date="")
		s TMaxNumTime=0
		s Time=0
		for {
			s Time=$O(DateListArr(Date,Time))
			q:(Time="")
			s TMaxNumTime=TMaxNumTime+1
			if (TMaxNumTime>MaxNumTime){
				s MaxNumTime=TMaxNumTime
			}
		}
	}
	s Date=0
	for {
		s Date=$O(DateListArr(Date))
		q:(Date="")
		s TMaxNumTime=0
		s Time=0
		for {
			s Time=$O(DateListArr(Date,Time))
			q:(Time="")
			s TMaxNumTime=TMaxNumTime+1
		}
		if (MaxNumTime>TMaxNumTime){
			for i=1:1:(MaxNumTime-TMaxNumTime) {
				s DateListArr(Date,1800*i)=""
			}
			s DailyStartTime=..%ZTH("00:30:00")
		}
	}
	//详细体温数据"Temperature"
	/////详细血压数据"BloodPressure"
	///详细脉搏数据"Pulse"
	/*
	
	var dataAxis1 = ['10/10','4:00','8:00','12:00','16:00','20:00','10/11','4:00','8:00','12:00','16:00','20:00','10/12','4:00','8:00','12:00','16:00','20:00','10/13','4:00','8:00','12:00','16:00','20:00'];
    var dataAxis2 = ['10/10','10/10','10/11','10/11','10/12','10/12','10/13','10/13'];
	*/
	
	//日期个数
	s CountDate=0
	//每日测量时间个数
	s CountTime=0
	s dataAxis1Str=""
	s dataAxis2Str=""
	s TempStr=""
	s BloodPreStr=""
	s PulseStr=""
	s Date=0
	for {
		s Date=$O(DateListArr(Date))
		q:(Date="")
		s CountDate=CountDate+1
		s FirtTime=1
		s Time=0
		for {
			s Time=$O(DateListArr(Date,Time))
			q:(Time="")
			s CountTime=CountTime+1
			s JsonData={}
			
			if (FirtTime=1){
				s dataAxis1=$P($ZD(Date,3),"-",2,3)
			}else{
				s dataAxis1=..%ZT(Time,2)
			}
			s FirtTime=0
			if (CountTime=1){
				s dataAxis1Str=dataAxis1
			}else{
				s dataAxis1Str=dataAxis1Str_","_dataAxis1
			}
			if (CountTime=1){
				s TempStr=$G(DateListArr(Date,Time,"Temperature"))
			}else{
				s TempStr=TempStr_","_$G(DateListArr(Date,Time,"Temperature"))
			}
			
			if (CountTime=1){
				s PulseStr=$G(DateListArr(Date,Time,"Pulse"))
			}else{
				s PulseStr=PulseStr_","_$G(DateListArr(Date,Time,"Pulse"))
			}
			
		}
		if (CountDate=1){
			s dataAxis2Str=$P($ZD(Date,3),"-",2,3)_","_$P($ZD(Date,3),"-",2,3)
		}else{
			s dataAxis2Str=dataAxis2Str_","_$P($ZD(Date,3),"-",2,3)_","_$P($ZD(Date,3),"-",2,3)
		}
		//上午的血压
		s BloodPre=""
		s TSTime=..%ZTH("12:00:01")
		for {
			s TSTime=$O(DateListArr(Date,TSTime),-1)
			q:TSTime=""
			if ('$D(DateListArr(Date,TSTime,"BloodPressure"))){
				continue
			}
			s BloodPre=$G(DateListArr(Date,TSTime,"BloodPressure"))
			q
		}		
		if (BloodPre'=""){
			s SystolicPre=$P(BloodPre,"/",1)
			if (SystolicPre[".") {
				s SystolicDecimal=$L(SystolicPre)-$L($p(SystolicPre,".",2)) //收缩压小数点位数
			}else{
				s SystolicDecimal=0
			}
			s SystolicPre=$tr(SystolicPre,".","")
			s SystolicPreLen=$L(SystolicPre)
			
			s DiastolicPre=$P(BloodPre,"/",2)
			if (DiastolicPre[".") {
				s DiastolicDecimal=$L(DiastolicPre)-$L($p(DiastolicPre,".",2)) //舒张压小数点位数
			}else{
				s DiastolicDecimal=0
			}
			s DiastolicPre=$tr(DiastolicPre,".","")
			s DiastolicPreLen=$L(DiastolicPre)
			
			///用于前台拆分，前台要求是纯数字，无限趋近于1，保证柱状图样式
			///s BloodPre="0.999"_$L($P(BloodPre,"/",1))_$P(BloodPre,"/",1)_$L($P(BloodPre,"/",2))_$P(BloodPre,"/",2)
			s BloodPre="0.999"_(SystolicPreLen+1)_SystolicPre_SystolicDecimal_(DiastolicPreLen+1)_DiastolicPre_DiastolicDecimal
		}
		if (CountDate=1){
			s BloodPreStr=BloodPre
		}else{
			s BloodPreStr=BloodPreStr_","_BloodPre
		}
		//下午的血压
		s BloodPre=""
		s TETime=..%ZTH("12:00:00")
		for {
			s TETime=$O(DateListArr(Date,TETime))
			q:TETime=""
			if ('$D(DateListArr(Date,TETime,"BloodPressure"))){
				continue
			}
			s BloodPre=$G(DateListArr(Date,TETime,"BloodPressure"))
			q
		}
		s BloodPre=$tr(BloodPre,".","")
		if (BloodPre'=""){
			s SystolicPre=$P(BloodPre,"/",1)
			if (SystolicPre[".") {
				s SystolicDecimal=$L(SystolicPre)-$L($p(SystolicPre,".",2)) //收缩压小数点位数
			}else{
				s SystolicDecimal=0
			}
			s SystolicPre=$tr(SystolicPre,".","")
			s SystolicPreLen=$L(SystolicPre)
			
			s DiastolicPre=$P(BloodPre,"/",2)
			if (DiastolicPre[".") {
				s DiastolicDecimal=$L(DiastolicPre)-$L($p(DiastolicPre,".",2)) //舒张压小数点位数
			}else{
				s DiastolicDecimal=0
			}
			s DiastolicPre=$tr(DiastolicPre,".","")
			s DiastolicPreLen=$L(DiastolicPre)
			///用于前台拆分，前台要求是纯数字，无限趋近于1，保证柱状图样式
			///s BloodPre="0.999"_$L($P(BloodPre,"/",1))_$P(BloodPre,"/",1)_$L($P(BloodPre,"/",2))_$P(BloodPre,"/",2)
			s BloodPre="0.999"_(SystolicPreLen+1)_SystolicPre_SystolicDecimal_(DiastolicPreLen+1)_DiastolicPre_DiastolicDecimal
		}
		s BloodPreStr=BloodPreStr_","_BloodPre
		//w BloodPreStr,!
	}
	s MainJsonObj=[]
	s OneKindJson={}
	d OneKindJson.%Set("dataAxis1",dataAxis1Str)
	d OneKindJson.%Set("dataAxis2",dataAxis2Str)
	d OneKindJson.%Set("TempStr",TempStr)
	d OneKindJson.%Set("PulseStr",PulseStr)
	d OneKindJson.%Set("BloodPreStr",BloodPreStr)
	d OneKindJson.%Set("MaxNumTime",MaxNumTime)
	do MainJsonObj.%Push(OneKindJson,"")
	s obj=##class(%Stream.GlobalCharacter).%New()
	do MainJsonObj.%ToJSON(obj)
	s JsonStr=""
	While 'obj.AtEnd { 
		s JsonStr=JsonStr_obj.ReadLine(,.sc,.eol)
	}
	q JsonStr
}

/// w ##Class(web.DHCDocInPatPortalCommon).GetExamGridData(319,2526)
ClassMethod GetExamGridData(EpisodeID As %String, UserCode As %String) As %String
{
	s $ZT="ExamGridDataErr"
	s ^tan("GetExamGridData")=EpisodeID_","_UserCode
	//s UserID=$O(^SSU("SSUSR",0,"SSUSR_Initials",$ZCVT(UserCode,"U"),""),-1)
	Set langid=..%LanguageID()
	s rset=##Class(%ResultSet).%New("web.DHCAPPPisInterface.QryPatExaList")
	If rset.QueryIsValid() {
		Set Status=rset.Execute(EpisodeID,UserCode)
		If 'Status Quit
		Set columns = rset.GetColumnCount()
		if (columns=0) Quit
		While (rset.Next()) {
			s ItmStatus=rset.GetData(1)
			
			s StatusCode=$CASE(ItmStatus,"申请":"A","报告":"C",:"B")
			s Oeori=rset.GetData(2)
			s Info=""
			for i=1:1:columns{
				if (i=1){
					s Info=rset.GetData(i)
				}else{
					s Info=Info_$C(2)_rset.GetData(i)
				}
			}
			s ExamInfo(StatusCode,$P(Oeori,"||",2))=Info
		}
	}
	s JsonObj=[]
	s Index=1
	s StatusCode=""
	for {
		s StatusCode=$O(ExamInfo(StatusCode))
		q:StatusCode=""
		s StatusDesc=""
		s SubJsonObj=[]
		s Sub=""
		for {
			s Sub=$O(ExamInfo(StatusCode,Sub))
			q:Sub=""
			s Val=ExamInfo(StatusCode,Sub)
			//ItmStatus,Oeori,ItmDesc,PartDesc,BusTime,ItmType,ItmReqID,ItmReqDate,ItmReqTime,ItmStudyNo
			//申请单状态:医嘱ID:医嘱描述:标本/部位:业务时间(申请时间\登记时间\报告时间):申请类型:报告ID:申请日期:申请时间:申请单号:检查号: 
			s StatusDesc=$P(Val,$C(2),1)
			s StatusDesc=..%Translate("ipdoc.patinfoview.csp",StatusDesc)
			s OEORowid=$P(Val,$C(2),2)
			s ItmDesc=$P(Val,$C(2),3)
			s ItmDesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",ItmDesc,langid)
			s PartDesc=$P(Val,$C(2),4)
			s DateTime=$P(Val,$C(2),5)
			s StudyNo=$P(Val,$C(2),10)
			s UserAdd=$p($g(^OEORD(+OEORowid,"I",$P(OEORowid,"||",2),7)),"^",1) ;下医嘱人
			if UserAdd'="" Set UserAdd=$P($G(^SSU("SSUSR",UserAdd)),"^",2)
			s RecLocRowId=$P($G(^OEORD(+OEORowid,"I",$P(OEORowid,"||",2),3)),"^",6)
			s LocDesc=$P($g(^CTLOC(RecLocRowId)),"^",2)
			s LocDesc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",LocDesc,langid)
			s:LocDesc["-" LocDesc=$P(LocDesc,"-",2)
			
			s DateTime=##class(ext.util.String).EvalJSON(DateTime)
			s ItmDesc=##class(ext.util.String).EvalJSON(ItmDesc)
			s LocDesc=##class(ext.util.String).EvalJSON(LocDesc)
			s Index=Index+1
			d InitJsonData
			do JsonData.%Set("Index",Index),JsonData.%Set("ItemDesc",ItmDesc)
			do JsonData.%Set("BodyPart",PartDesc),JsonData.%Set("OEORowid",OEORowid)
			do JsonData.%Set("DateTime",DateTime),JsonData.%Set("AppDoc",UserAdd)
			do JsonData.%Set("ReportStatus",StatusCode),JsonData.%Set("StudyNo",StudyNo)
			do JsonData.%Set("ExecuteLoc",LocDesc)
			do SubJsonObj.%Push(JsonData,"")
		}
		s Index=Index+1
		d InitJsonData
		do JsonData.%Set("Index",Index),JsonData.%Set("Title",StatusDesc)
		s QueryJsonData=JsonData
		
		d QueryJsonData.%Set("children",SubJsonObj)
		do JsonObj.%Push(QueryJsonData,"")
	}
	s obj=##class(%Stream.GlobalCharacter).%New()
	do JsonObj.%ToJSON(obj)
	s JsonStr=""
	While 'obj.AtEnd { 
		s JsonStr=JsonStr_obj.ReadLine(,.sc,.eol)
	}
	//s JsonStr=$replace(JsonStr,"""","'")
	q JsonStr
InitJsonData
	s JsonData={}
	do JsonData.%Set("Index",""),JsonData.%Set("Title","")
	do JsonData.%Set("OEORowid",""),JsonData.%Set("ItemDesc","")
	do JsonData.%Set("BodyPart",""),JsonData.%Set("StudyNo","")
	do JsonData.%Set("ExecuteLoc",""),JsonData.%Set("ReportStatus","")
	do JsonData.%Set("DateTime","")
	q
ExamGridDataErr
	q "[{'err':'"_$ZE_"'}]"
}

/***
  **Description      :
  **Author           :tanjishan
  **Time             :2022/02/24
  **debugger         :w ##Class(web.DHCDocInPatPortalCommon).GetSomeQtyInfoByAdmNo("758","18881")
  **Parameter        :
  **Returns          :
***/
ClassMethod GetSomeQtyInfoByAdmNo(EpisodeID As %String, UserId As %String) As %String
{
	s (APSequence,SCSequence,PRSequence)=0
	s fReadFlag="N"
	Set rset=##Class(%ResultSet).%New("web.DHCAPPSeePatLis.QueryOrderList")	
	If rset.QueryIsValid() {
		Set Status=rset.Execute(EpisodeID, "", "", "", "", 0, "", "", UserId, fReadFlag, "", "", "", "","","")
		
		If 'Status Quit ""
		Set columns = rset.GetColumnCount()
		if (columns=0) Quit ""
		while(rset.Next()){
			s OrderId=rset.GetData(2)
			for i=1:1:$length(OrderId,","){
				s TMPOrdRowId=$P(OrderId,",",i)
				continue:(TMPOrdRowId="")
				s ExecStatusInfo=##Class(web.DHCAPPSeePatLis).GetExecStatusInfo(TMPOrdRowId)
				s StatusCat=$LG(ExecStatusInfo,8)
				if (StatusCat["报告"){
					s PRSequence=PRSequence+1
				}elseif (StatusCat="登记"){
					s SCSequence=SCSequence+1
				}else{
					s APSequence=APSequence+1
				}
			}
		}
	}
	q APSequence_"^"_SCSequence_"^"_PRSequence
}

/// w ##Class(web.DHCDocInPatPortalCommon).GetLabGridData(285,18881)
ClassMethod GetLabGridData(EpisodeID As %String, UserId As %String) As %String
{
	///检验号,状态，his医嘱id，报告id，检验号，医嘱名称，申请时间，接收时间，报告时间
	k LabOrdList
	s fReadFlag="N"
	Set langid=..%LanguageID()
	Set rset=##Class(%ResultSet).%New("web.DHCAPPSeePatLis.QueryOrderList")	
	If rset.QueryIsValid() {
		Set Status=rset.Execute(EpisodeID, "", "", "", "", 0, "", "", UserId, fReadFlag, "", "", "", "","","")
		
		If 'Status Quit "-1"
		Set columns = rset.GetColumnCount()
		if (columns=0) Quit "-1"
		while(rset.Next()){
			s ReportId=rset.GetData(1)
			s OrderId=rset.GetData(2)
			//s VisitNumber=rset.GetData(5)
			s TestSetName=rset.GetData(3)
			s VisitNumbe=rset.GetData(6)	//LabEpisode
			s RequestTime=rset.GetData(4)
			s SpecCollDate=rset.GetData(9)
			s ReceiveTime=rset.GetData(10)
			s ReportTime=rset.GetData(11)
			s Status=rset.Data("ForwardExecStatus")
			s StatusSequence=rset.Data("ForwardExecSequence")
			continue:(OrderId="")
			s OrderId=$P(OrderId,",",1)
			s OrdStatus=""
			s OrdStatusDR=$p($G(^OEORD(+OrderId,"I",$P(OrderId,"||",2),1)),"^",13)
			s:$g(OrdStatusDR)'="" OrdStatus=$p(^OEC("OSTAT",OrdStatusDR),"^",1)
			continue:("VE"'[OrdStatus)
			s ARCIMRowId=$p($G(^OEORD(+OrderId,"I",$P(OrderId,"||",2),1)),"^",2)
			
			s ArcimDescS=rset.Data("OrdItemName")
			
			
			s ExecStatusInfo=##Class(web.DHCAPPSeePatLis).GetExecStatusInfo(OrderId)
			s StatusCat=$LG(ExecStatusInfo,8)
			s StatusCat=$CASE(StatusCat,"报告":3,"登记":2,:1)
			s StatusCat=..%Translate("ipdoc.patinfoview.csp",StatusCat)
			s Str=VisitNumbe_"^"_OrderId_"^"_ReportId_"^"_VisitNumbe_"^"_TestSetName
			s Str=Str_"^"_RequestTime_"^"_ReceiveTime_"^"_ReportTime_"^"_ArcimDescS_"^"_SpecCollDate_"^"_StatusCat

			
			if (StatusSequence="") s StatusSequence="0"
			if (Status="") s Status="申请"
			s Status=..%Translate("ipdoc.patinfoview.csp",Status)
			if Status'="" s LabOrdList(StatusSequence)=Status
			//w StatusSequence_","_Status,!
			s Number=$I(LabOrdList(StatusSequence,OrderId))
			s LabOrdList(StatusSequence,OrderId,Number)=Str
		}
	}
	
	d rset.Close()
	s Index=0
	s JsonObj=[]
	s Status=""
	for {
		s Status=$O(LabOrdList(Status))
		q:Status=""
		s Index=Index+1
		s Title=LabOrdList(Status)
		s Title=..%Translate("ipdoc.patinfoview.csp",Title)
		d InitLabJsonData
		do JsonData.%Set("Index",Index),JsonData.%Set("Title",Title)
		s QueryJsonData=JsonData
		s GroupJsonObj=[]
		s Node=""
		for {
			s Node=$O(LabOrdList(Status,Node))
			q:Node=""
			s Index=Index+1
			d InitLabJsonData
			s Val=$G(LabOrdList(Status,Node,1))
			d SetValue
			do JsonData.%Set("Index",Index),JsonData.%Set("Title",VisitNumber)
			s GroupJsonData=JsonData
			s SubJsonObj=[]
			s Number=1
			for {
				s Number=$O(LabOrdList(Status,Node,Number))
				q:Number=""
				s Val=$G(LabOrdList(Status,Node,Number))
				
				s Index=Index+1
				d InitLabJsonData
				do JsonData.%Set("Index",Index)
				d SetValue
				do SubJsonObj.%Push(JsonData,"")
				//w JsonData,!
			}
			//w 2,!
			d GroupJsonData.%Set("children",SubJsonObj)
			do GroupJsonObj.%Push(GroupJsonData,"")
			
		}
		//w 3,!
		d QueryJsonData.%Set("children",GroupJsonObj)
		do JsonObj.%Push(QueryJsonData,"")
	}
	
	s obj=##class(%Stream.GlobalCharacter).%New()
	do JsonObj.%ToJSON(obj)
	s JsonStr=""
	While 'obj.AtEnd { 
		s JsonStr=JsonStr_obj.ReadLine(,.sc,.eol)
	}
	//s JsonStr=$replace(JsonStr,"""","'")
	q JsonStr
InitLabJsonData
	s JsonData={}
	do JsonData.%Set("Index",""),JsonData.%Set("Title","")
	do JsonData.%Set("VisitNumber",""),JsonData.%Set("Status","")
	do JsonData.%Set("OrderId",""),JsonData.%Set("ReportId","")
	do JsonData.%Set("VisitNumber",""),JsonData.%Set("TestSetName","")
	do JsonData.%Set("RequestTime",""),JsonData.%Set("ReceiveTime","")
	do JsonData.%Set("ReportTime",""),JsonData.%Set("Status","")
	do JsonData.%Set("SpecCollDate",""),JsonData.%Set("ARCIMDesc","")
	
	q
SetValue
	s VisitNumber=$P(Val,"^",1)
	s OrderId=$P(Val,"^",2)
	s ReportId=$P(Val,"^",3)
	s VisitNumber=$P(Val,"^",4)
	s TestSetName=$P(Val,"^",5)
	s RequestTime=$P(Val,"^",6)
	s ReceiveTime=$P(Val,"^",7)
	s ReportTime=$P(Val,"^",8)
	s ArcimDesc=$P(Val,"^",9)
	s SpecCollDate=$P(Val,"^",10)
	s StatusCat=$P(Val,"^",11)
	//s StatusText =..%Translate("ipdoc.patinfoview.csp",Status)
	do JsonData.%Set("OrderId",OrderId)
	do JsonData.%Set("ReportId",ReportId),JsonData.%Set("VisitNumber",VisitNumber)
	do JsonData.%Set("TestSetName",TestSetName),JsonData.%Set("ExecuteLoc",RequestTime)
	do JsonData.%Set("ReceiveTime",ReceiveTime),JsonData.%Set("ReportTime",ReportTime)
	do JsonData.%Set("Status",StatusCat),JsonData.%Set("SpecCollDate",SpecCollDate)
	do JsonData.%Set("ARCIMDesc",ArcimDesc)
	q
}

/// 取界面上的心电医嘱列表
/// w ##Class(web.DHCDocInPatPortalCommon).GetEkgOrdList(79)
ClassMethod GetEkgOrdList(EpisodeID As %String, UserID As %String) As %String
{
	s EkgOrdList=""
	s DataList=""
	Set langid=..%LanguageID()
	d ##Class(DHCDoc.DHCDocConfig.OrderClassify).GetAdmOrdClassify(EpisodeID,"EkgOrd",.DataList)
	for i=1:1:$L(DataList,"^"){
		s OneData=$P(DataList,"^",i)
		s Selection=$P(OneData,$C(1),3)
		continue:(Selection'=1)
		s ARCIMDesc=$P(OneData,$C(1),1)
		s ARCIMDesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",ARCIMDesc,langid)
		s ARCIMDR=$P(OneData,$C(1),2)
		s OrdList=$P(OneData,$C(1),4)
		s NeedOutData=$P(OneData,$C(1),5)
		for j=1:1:$L(OrdList,","){
			s OeordId=$P(OrdList,",",j)
			if (NeedOutData="Y"){
				s EKGRptInfo=##class(web.DHCEkg.GetEkgReportState).GetEKGRptInfo(OeordId,UserID)
				s ReadFlag=$P(EKGRptInfo,"^",8)
				continue:(ReadFlag="Y")
				s Negative=$P(EKGRptInfo,"^",2)
				if (Negative="阳性"){
					s OrdInfo="<span style=\'color:red\'>"_ARCIMDesc_"</span>"
				}else{
					s OrdInfo="<span style=\'color:green\'>"_ARCIMDesc_"</span>"
				}
				
			}else{
				s OrdInfo=ARCIMDesc
			}
			if (EkgOrdList=""){
				s EkgOrdList=OrdInfo
			}else{
				s EkgOrdList=EkgOrdList_","_OrdInfo
			}
		}
		
	}
	if (EkgOrdList'=""){
		s EkgOrdList="<span>"_EkgOrdList_"</span>"
	}
	q EkgOrdList
}

Query QueryEkgOrdList(EpisodeID As %String, UserID As %String) As %Query(ROWSPEC = "Index:%String,OeordId:%String,ArcimDesc:%String,ReportState:%String,Negative:%String,DoctorName:%String,DoctorId:%String,ReportTime:%String,RequestTime:%String,Diagnose:%String,URL:%String")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCDocInPatPortalCommon","QueryEkgOrdList","192","4634")
ClassMethod QueryEkgOrdListExecute(ByRef qHandle As %Binary, EpisodeID As %String, UserID As %String) As %Status
{
	set EkgOrdrepid = $I(^CacheTemp)
	if $g(index) = "" set index = 0
	i EpisodeID="" set qHandle = $lb(0,EkgOrdrepid,0) Q $$$OK
	s DataList=""
	d ##Class(DHCDoc.DHCDocConfig.OrderClassify).GetAdmOrdClassify(EpisodeID,"EkgOrd",.DataList)
	for i=1:1:$L(DataList,"^"){
		s OneData=$P(DataList,"^",i)
		s Selection=$P(OneData,$C(1),3)
		continue:(Selection'=1)
		s ArcimDesc=$P(OneData,$C(1),1)
		s ARCIMDR=$P(OneData,$C(1),2)
		s OrdList=$P(OneData,$C(1),4)
		s NeedOutData=$P(OneData,$C(1),5)
		for j=1:1:$L(OrdList,","){
			s OeordId=$P(OrdList,",",j)
			s (ReportState,Negative,DoctorName,DoctorId,ReportTime,RequestTime,Diagnose,URL)=""
			if (NeedOutData="Y"){
				s EKGRptInfo=##class(web.DHCEkg.GetEkgReportState).GetEKGRptInfo(OeordId,UserID)
				s ReadFlag=$P(EKGRptInfo,"^",8)
				continue:(ReadFlag="Y")
				s ReportState=$P(EKGRptInfo,"^",1)
				i (ReportState="1")||(ReportState="Y") {
					s ReportState="已出"
				}else{
					s ReportState=""
				}
				s Negative=$P(EKGRptInfo,"^",2)
				s DoctorName=$P(EKGRptInfo,"^",3)
				s DoctorId=$P(EKGRptInfo,"^",4)
				s ReportTime=$P(EKGRptInfo,"^",5)
				if (ReportTime'=""){
					s ReportTime=..DateLogicalStrToHtml(ReportTime)
				}
				
				s Diagnose=$P(EKGRptInfo,"^",6)
				s URL=$P(EKGRptInfo,"^",7)
				d OutPutEkgOrdList
			}else{
				d OutPutEkgOrdList
			}
		}
	}
	
	set qHandle = $lb(0,EkgOrdrepid,0)
	Q $$$OK	
		
OutPutEkgOrdList
	s index=index+1
	s ^CacheTemp(EkgOrdrepid,index) = $lb(index,OeordId,ArcimDesc,ReportState,Negative,DoctorName,DoctorId,ReportTime,RequestTime,Diagnose,URL)
	q
}

ClassMethod QueryEkgOrdListFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryEkgOrdListExecute ]
{
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryEkgOrdListClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = QueryEkgOrdListExecute ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindEmrQuality(EpisodeID As %String, EMRType As %String, Param As %String) As websys.Query(ROWSPEC = "Index:%String,QCMessageBody:%String,QCCreateDate:%String,QCCreateUserDesc:%String,QCRowID:%String,LinkQCBtn:%String,ChronergyeName:%String,ChronergyeScore:%String")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCDocInPatPortalCommon","FindEmrQuality",66,"Chronergye","2_29_110")
ClassMethod FindEmrQualityExecute(ByRef qHandle As %Binary, EpisodeID As %String, EMRType As %String, Param As %String) As %Status
{
	set EQrepid = $I(^CacheTemp)
	if $g(EQind) = "" set EQind = 0
	i EpisodeID="" set qHandle = $lb(0,EQrepid,0) Q $$$OK
	s Index=0
	if (EMRType="QC"){
		///环节质控数据
		Set rset=##Class(%ResultSet).%New("EPRservice.Quality.DataAccess.BOQualityMessage.GetMessagesByEpisodeID")
		If rset.QueryIsValid() {
			Set Status=rset.Execute(EpisodeID)
			If 'Status Quit
			Set columns = rset.GetColumnCount()
			if (columns=0) Quit
			while(rset.Next()){
				///RowID,CreateDate,CreateTime,CreateUserDesc,MessageBody,
				///ReadDate,ReadTime,ReadUserDesc,ReadStatus,ExecuteDate,
				///ExecuteTime,ExecuteUserDesc,ExecuteStatus
				d ReSetEmrQuality
				s QCMessageBody=rset.GetData(5)
				s QCCreateDate=rset.GetData(2)_" "_$P(rset.GetData(3),":",1,2)
				s QCCreateUserDesc=rset.GetData(4)
				s QCRowID=rset.GetData(1)
				d SetEmrQuality
			}
		}
		d rset.Close()
	}elseif (EMRType="Chronergye"){
		///时效性缺陷
		Set rset=##Class(%ResultSet).%New("EPRservice.Quality.BORunTimeQuality.GetPromptList")
		If rset.QueryIsValid() {
			Set Status=rset.Execute(EpisodeID,Param)
			If 'Status Quit
			Set columns = rset.GetColumnCount()
			if (columns=0) Quit
			while(rset.Next()){
				///ExamEntry,EntryDesc,ResultRowid,DocName,DocRowid,
				///EntryScore,PhaseName,PhaseColor
				d ReSetEmrQuality
				s ChronergyeName=rset.GetData(2)
				s ChronergyeScore=rset.GetData(6)
				d SetEmrQuality
				
			}
		}
		d rset.Close()
	}
	
	set qHandle = $lb(0,EQrepid,0)
	Q $$$OK

ReSetEmrQuality
	s (QCMessageBody,QCCreateDate,QCCreateUserDesc,QCRowID,LinkQCBtn,ChronergyeName,ChronergyeScore)=""
	q
SetEmrQuality
	s EQind = EQind+1
	s ^CacheTemp(EQrepid,EQind) = $lb(EQind,QCMessageBody,QCCreateDate,QCCreateUserDesc,QCRowID,LinkQCBtn,ChronergyeName,ChronergyeScore)
	q
}

/// w ##class(web.DHCDocInPatPortalCommon).GetEmrQualityQty(3159,"2_29_110")
ClassMethod GetEmrQualityQty(EpisodeID As %String, Param As %String) As %String
{
	s JsonObj=[]
	s JsonData={}
	s QCCount=0
	s ChronergyeCount=0
	
	Set rset=##Class(%ResultSet).%New("EPRservice.Quality.DataAccess.BOQualityMessage.GetMessagesByEpisodeID")
	If rset.QueryIsValid() {
		Set Status=rset.Execute(EpisodeID)
		If 'Status Quit
		//s QCCount=rset.%ROWCOUNT
		while(rset.Next()){
			s RowID=rset.GetDataByName("RowID")
			continue:RowID=""
			s QCCount=QCCount+1
		}
	}
	d rset.Close()
	// EPRservice.Quality.BORunTimeQuality.GetPromptList
	Set rset=##Class(%ResultSet).%New("EPRservice.Quality.BORunTimeQuality.GetQualityResultList")
	If rset.QueryIsValid() {
		Set Status=rset.Execute(EpisodeID,Param)
		If 'Status Quit
		while(rset.Next()){
			s ChronergyeCount=ChronergyeCount+1
		}
	}
	d rset.Close()
	
	do JsonData.%Set("QCCount",QCCount_"")
	do JsonData.%Set("ChronergyeCount",ChronergyeCount_"")
	do JsonObj.%Push(JsonData,"")
	
	s obj=##class(%Stream.GlobalCharacter).%New()
	do JsonObj.%ToJSON(obj)
	s JsonStr=""
	While 'obj.AtEnd { 
		s JsonStr=JsonStr_obj.ReadLine(,.sc,.eol)
	}
	s JsonStr=$replace(JsonStr,"""","'")
	q JsonStr
}

ClassMethod GetLinkOrderStr(OeordId As %String) As %String
{
	///MasterOrderItemRowId+"^"+OrderPriorRowid+"^"+OrderStartDate+"^"+OrderFreqRowid+"^"+OrderFreq
	///+"^"+MasterOrderSeqNo+"^"+OrderStartTime+"^"+OrderInstrRowid+"^"+OrderInstr+"^"+OrderName;
	s OrderID=+OeordId,SubID=$P(OeordId,"||",2)
	s PriorRowid=$P($G(^OEORD(OrderID,"I",SubID,1)),"^",8)
	
	s StartDate=$p(^OEORD(OrderID,"I",SubID,1),"^",9)
	s StartTime=$p(^OEORD(OrderID,"I",SubID,1),"^",10)
	s FreqRowid=$P($G(^OEORD(OrderID,"I",SubID,2)),"^",4)
	s PHFreqDesc="",OrderFreqDispTimeStr=""
	
	s OrderFreqDispTimeStr=##Class(web.DHCOEOrdItem).GetOrdItemFreqDispTimeStr(OeordId)
	s instrRowid = $p($G(^OEORD(OrderID,"I",SubID,2)),"^",7)	;用法 OEORI_Instr_DR
	s instrDesc=""
	s:+instrRowid'=0 instrDesc=$p(^PHCIN(instrRowid),"^",2)
	s ArcimDr=$p(^OEORD(OrderID,"I",SubID,1),"^",2)
	s OrderName=$p($g(^ARCIM(+ArcimDr,$p(ArcimDr,"||",2),1)),"^",2)
	s OrderSeqNo=$p(^OEORD(OrderID,"I",SubID,3),"^",4)
	
	
	s OrderStr=OeordId_"^"_PriorRowid_"^"_StartDate_"^"_FreqRowid_"^"_PHFreqDesc
	s OrderStr=OrderStr_"^"_OrderSeqNo_"^"_StartTime_"^"_instrRowid_"^"_instrDesc_"^"_OrderName
	s OrderStr=OrderStr_"^"_OrderFreqDispTimeStr
	q OrderStr
}

/// d ##class(%ResultSet).RunQuery("web.DHCDocInPatPortalCommon","FindOrdDetailInfo","51||20")
Query FindOrdDetailInfo(OrdRowID As %String) As websys.Query(ROWSPEC = "PropertyCode:%String,PropertyName:%String,PropertyValue:%String,Group:%String")
{
}

ClassMethod FindOrdDetailInfoExecute(ByRef qHandle As %Binary, OrdRowID As %String) As %Status
{
	set repid = $I(^CacheTemp)
	if $g(ind) = "" set ind = 0
	Set langid=..%LanguageID()
	s tmprepid = $I(^CacheTemp)
	s OrdId1=+OrdRowID
	s OrdId2=$P(OrdRowID,"||",2)
	s EpisodeID=$P(^OEORD(OrdId1),"^",1)
	s AdmLoc=$P(^PAADM(EpisodeID),"^",4)
	s HospitalDR=$P(^CTLOC(AdmLoc),"^",22)
	i HospitalDR="" s HospitalDR=$O(^CT("HOSP",0))
	s HospitalCode=$P(^CT("HOSP",HospitalDR),"^",1)
	s ordstr1=$g(^OEORD(OrdId1,"I",OrdId2,1))
	s ordstr2=$g(^OEORD(OrdId1,"I",OrdId2,2))
	s ordstr3=$g(^OEORD(OrdId1,"I",OrdId2,3))
	s ordstr5=$g(^OEORD(OrdId1,"I",OrdId2,5))
	s ordstr6=$g(^OEORD(OrdId1,"I",OrdId2,6))
	s ordstr9=$g(^OEORD(OrdId1,"I",OrdId2,9))
	s ordstr11=$g(^OEORD(OrdId1,"I",OrdId2,11))
	s ordstr12=$g(^OEORD(OrdId1,"I",OrdId2,12))
	s del="^"
	s (Priority,ArcimDesc,DoseUnit,PHFreq,Instr,Dura,ReLoc,OrdSkinTestResult,Doctor)=""
	s (UserAdd,UserDep,OrdStatus,OrdLabSpec,OrdLabCont,OrderFlowRateUnitdesc)=""
	/////////////-----------------------------------基本信息
	s Group=..%Translate("dhc.orderdetailview.csp","基本信息")
	
	s ARCIMRowId=$p(ordstr1,del,2)
	if (ARCIMRowId=""){
		set qHandle = $lb(0,repid,0)
		Q $$$OK
	}
	d OutPutOrdDetail("ARCIMRowId",..%Translate("dhc.orderdetailview.csp","医嘱项目索引"),ARCIMRowId,Group)
	s ItemCatRowid=$p(^ARCIM($p(ARCIMRowId,"||",1),$p(ARCIMRowId,"||",2),1),"^",10)
	s OrderType=$P(^ARC("IC",ItemCatRowid),"^",7)
	s ArcimDesc=$p(^ARCIM(+ARCIMRowId,$P(ARCIMRowId,"||",2),1),del,2)
	s ArcimDesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",ArcimDesc,langid)
	s ArcimDesc=$replace(ArcimDesc,"/","")
	d OutPutOrdDetail("ArcimDesc",..%Translate("dhc.orderdetailview.csp","医嘱名称"),ArcimDesc,Group)
	s GenericName=##class(web.UDHCJFCOMMON).GetDrugCommonNameByArcimId(ARCIMRowId)
	s GenericName=$replace(GenericName,"/","")
	d OutPutOrdDetail("GenericName",..%Translate("dhc.orderdetailview.csp","通用名"),GenericName,Group)
	s PriorityDR=$p(ordstr1,del,8)
	s:(PriorityDR'="") Priority=$p(^OECPR(PriorityDR),del,2)
	s Priority=##class(User.OECPriority).GetTranByDesc("OECPRDesc",Priority,langid)
	d OutPutOrdDetail("Priority",..%Translate("dhc.orderdetailview.csp","医嘱类型"),Priority,Group)
	s DoseQty=##class(DHCDoc.Interface.Inside.Service).GetOrdDoseQty(OrdRowID) //$p(ordstr2,del,1)
	d OutPutOrdDetail("DoseQty",..%Translate("dhc.orderdetailview.csp","单次剂量"),DoseQty,Group)
	s DoseUnitID=$p(ordstr2,del,3)
	s:DoseUnitID'="" DoseUnit=$p(^CT("UOM",DoseUnitID),del,2)
	s DoseUnit=##class(User.CTUOM).GetTranByDesc("CTUOMDesc",DoseUnit,langid)
	d OutPutOrdDetail("DoseUnit",..%Translate("dhc.orderdetailview.csp","单次剂量单位"),DoseUnit,Group)
	s IsCNMedItem=0
	s PHFreqDR=$p(ordstr2,del,4)
	i (PHFreqDR'="") {
		s IsCNMedItem=##class(DHCDoc.Order.Common).IsCNOrdItem(OrdRowID,"")
		if (IsCNMedItem=1){
			s PHFreq=$p(^PHCFR(PHFreqDR),del,3)
		}else{
			s OrdFreqInfo=##class(DHCDoc.Interface.Inside.ServiceOrd).GetOrdFreqInfo(OrdRowID,"^")
			s PHFreq=$List(OrdFreqInfo,2)
			s PHFreq=$REPLACE(PHFreq,"^","-")
			//s PHFreq=$p(^PHCFR(PHFreqDR),del,4)
			if (PHFreq="饮片"){
				s PHFreq=$p(^PHCFR(PHFreqDR),del,3)
			}
		}
		
	}
	s PHFreq=##class(User.PHCFreq).GetTranByDesc("PHCFRDesc1",PHFreq,langid)
	d OutPutOrdDetail("PHFreq",..%Translate("dhc.orderdetailview.csp","频次"),PHFreq,Group)
	s InstrDr=$p(ordstr2,del,7)
	s:$g(InstrDr)'="" Instr=$p($g(^PHCIN(InstrDr)),del,2)
	s Instr=##class(User.PHCInstruc).GetTranByDesc("PHCINDesc1",Instr,langid)
	d OutPutOrdDetail("Instr",..%Translate("dhc.orderdetailview.csp","用法"),Instr,Group)
	s DuraDR=$p(ordstr2,del,6)
	s:$g(DuraDR)'="" Dura=$p(^PHCDU(DuraDR),del,3)
	s Dura=##class(User.PHCDuration).GetTranByDesc("PHCDUDesc1",Dura,langid)
	d OutPutOrdDetail("Dura",..%Translate("dhc.orderdetailview.csp","疗程"),Dura,Group)
	s DoseqtySum=$p(ordstr1,del,12)
	s PackUOMDesc=""
	//s BillingUOMDR=$p(^ARCIM(+ARCIMRowId,$p(ARCIMRowId,"||",2),8),"^",14)
	s BillingUOMDR=##Class(web.DHCDocOrderCommon).GetOrdPackUOMDR(OrdRowID)
	if BillingUOMDR'="" s PackUOMDesc=$p(^CT("UOM",BillingUOMDR),"^",2)
	s CheckCHNFlag=##class(web.DHCSTINTERFACE).GetStruModeFlag(ARCIMRowId)
	if (CheckCHNFlag="Y") {
		s Phcdf=$P($g(^ARCIM(+ARCIMRowId,$P(ARCIMRowId,"||",2),1)),"^",12)
		if Phcdf'="" s BillUOMRowid=$p(^PHCD(+Phcdf,"DF",$p(Phcdf,"||",2),2),"^",4),PackUOMDesc=##class(web.DHCDocOrderCommon).GetUOMDesc(BillUOMRowid)
	}
	
	s OrderPackQty=$p(ordstr9,del,4)
	i OrderType'="R" {
		if (OrderPackQty="") {
			s ISLongOrderPrior=##class(appcom.OEOrdItem).ISLongOrderPrior(PriorityDR)
			if ('ISLongOrderPrior)||(PHFreqDR="") {
				s OrderPackQty=DoseqtySum
			}
		}
	}else{
		s OrdPackQtyInfo=##Class(web.DHCDocQryOEOrder).GetOrdPackQtyInfo(OrdRowID)
		s OrderPackQty=$p(OrdPackQtyInfo,"^",4)
		if (OrderPackQty'="") s OrderPackQty=+OrderPackQty
		s PackUOMDesc=$p(OrdPackQtyInfo,"^",5)
	}
	s OrderPackQty=##class(DHCDoc.Util.Base).FormateNumber(OrderPackQty)
	d OutPutOrdDetail("OrderPackQty",..%Translate("dhc.orderdetailview.csp","数量"),OrderPackQty,Group)
	s PackUOMDesc=##class(User.CTUOM).GetTranByDesc("CTUOMDesc",PackUOMDesc,langid)
	d OutPutOrdDetail("PackUOMDesc",..%Translate("dhc.orderdetailview.csp","数量单位"),PackUOMDesc,Group)
	s ReLocID=$p(ordstr3,"^",6)
	If ReLocID'="" Set ReLoc=$P($G(^CTLOC(ReLocID)),"^",2)
	s ReLoc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",ReLoc,langid)
	d OutPutOrdDetail("ReLoc",..%Translate("dhc.orderdetailview.csp","接收科室"),ReLoc,Group)
	/////////////-----------------------------------附加信息
	s Group=..%Translate("dhc.orderdetailview.csp","附加信息")
	s OrdSkinTest=$p(ordstr5,del,2)
	d OutPutOrdDetail("OrdSkinTest",..%Translate("dhc.orderdetailview.csp","皮试"),OrdSkinTest,Group)
	s OrdAction=$p(ordstr11,del,21)
	i OrdAction'="" s OrdAction=$P($G(^OEC("ACT",OrdAction)),"^",2) 
	s OrdAction =##class(User.OECAction).GetTranByDesc("ACTDesc",OrdAction,langid)
	d OutPutOrdDetail("OrdAction",..%Translate("dhc.orderdetailview.csp","皮试备注"),OrdAction,Group)
	s abnorm=$p(ordstr11,"^",3)
	//i OrdSkinTest="Y" {
		i abnorm="Y" s OrdSkinTestResult="阳性"
		i abnorm="N" s OrdSkinTestResult="阴性"
	//}
	s OrdSkinTestResult=..%Translate("dhc.orderdetailview.csp",OrdSkinTestResult)
	d OutPutOrdDetail("OrdSkinTestResult",..%Translate("dhc.orderdetailview.csp","皮试结果"),OrdSkinTestResult,Group)
	s OrdDepProcNotes=$g(^OEORD(OrdId1,"I",OrdId2,"DEP",1))
	s PhSpecInstr=$p($g(^OEORD(OrdId1,"I",OrdId2,2)),"^",8) //草药备注
	if (PhSpecInstr'=""){
		d OutPutOrdDetail("OrdDepProcNotes",..%Translate("dhc.orderdetailview.csp","医嘱备注"),PhSpecInstr,Group)
	}else{
		d OutPutOrdDetail("OrdDepProcNotes",..%Translate("dhc.orderdetailview.csp","医嘱备注"),OrdDepProcNotes,Group)
	}
	s DoctorID=$p(ordstr1,del,11)
	s:$g(DoctorID)'="" Doctor=$p(^CTPCP(DoctorID,1),del,2)
	Set Doctor= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",Doctor,langid)
	d OutPutOrdDetail("Doctor",..%Translate("dhc.orderdetailview.csp","下医嘱医生"),Doctor,Group)
	s UserAddID=$p($g(^OEORD(OrdId1,"I",OrdId2,7)),"^",1)
	If UserAddID'="" Set UserAdd=$P($G(^SSU("SSUSR",UserAddID)),"^",2)
	 s UserAdd =##class(User.SSUser).GetTranByDesc("SSUSRName",UserAdd,langid)
	d OutPutOrdDetail("UserAdd",..%Translate("dhc.orderdetailview.csp","录入医嘱人"),UserAdd,Group)
	s UserDepID=$p($g(^OEORD(OrdId1,"I",OrdId2,7)),"^",2)
	i UserDepID'="" Set UserDep=$P($G(^CTLOC(UserDepID)),"^",2)
	s UserDep=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",UserDep,langid)
	d OutPutOrdDetail("UserDep",..%Translate("dhc.orderdetailview.csp","开单科室"),UserDep,Group)
	
	s OrdXDate=$p(ordstr3,del,34)
	if OrdXDate'="" s OrdXDate=..%ZD(OrdXDate) //$zd(OrdXDate,3)
	s OrdXTime=$p(ordstr2,del,15)
	if OrdXTime'="" s OrdXTime=..%ZT(OrdXTime,2)
	s OrdXDate=OrdXDate_" "_OrdXTime
	d OutPutOrdDetail("OrdXDate",..%Translate("dhc.orderdetailview.csp","停止时间"),OrdXDate,Group)
	s OrdStatusDR=$p(ordstr1,del,13)
	s:$g(OrdStatusDR)'="" OrdStatus=$p(^OEC("OSTAT",OrdStatusDR),del,2)
	s OrdStatus=##class(User.OECOrderStatus).GetTranByDesc("OSTATDesc",OrdStatus,langid)
	d OutPutOrdDetail("OrdStatus",..%Translate("dhc.orderdetailview.csp","医嘱状态"),OrdStatus,Group)
	s OrderCoverMainIns=$p(ordstr3,"^",3)
	d OutPutOrdDetail("OrderCoverMainIns",..%Translate("dhc.orderdetailview.csp","医保标志"),OrderCoverMainIns,Group)
	s EMStayFlag=$p($G(^OEORD(OrdId1,"I",OrdId2,"DHC")),"^",17)
	s EMStayFlag=$case(EMStayFlag,1:"Y",0:"N",:"")
	d OutPutOrdDetail("OrdStatus",..%Translate("dhc.orderdetailview.csp","留观标志"),EMStayFlag,Group)
	s ReadyToBill=$p($G(ordstr12),"^",26)
	d OutPutOrdDetail("OrdStatus",..%Translate("dhc.orderdetailview.csp","先诊疗后付费标志"),ReadyToBill,Group)
	/////////////-----------------------------------扩展信息
	s Group=..%Translate("dhc.orderdetailview.csp","扩展信息")
	s PrescNo=$p(ordstr1,del,14)
	d OutPutOrdDetail("PrescNo",..%Translate("dhc.orderdetailview.csp","处方号"),PrescNo,Group)
	if (PrescNo'=""){
		s PrescRowid=$O(^PAQUE1(0,"PrescNo",PrescNo,""))
		if (PrescRowid'=""){
			s PrescNotes=$P($g(^PAQUE1(PrescRowid,"DHC")),"^",21)
			d OutPutOrdDetail("PrescNotes",..%Translate("dhc.orderdetailview.csp","草药处方备注"),PrescNotes,Group)
		}
	}
	s MaterialBarCode=$p($G(^OEORD(OrdId1,"I",OrdId2,"DHC")),"^",14)
	d OutPutOrdDetail("MaterialBarCode",..%Translate("dhc.orderdetailview.csp","材料条码"),MaterialBarCode,Group)
	//s LabEpisodeNo=$p(ordstr3,"^",20)
	s LabEpisodeNo=##class(Nur.OrderStaticInfo).getValueByVarCode("labNo",OrdRowID)
	//病理
 	//s blLabNo=##class(web.DHCPisApplicationSheet).GetRowIdByOrderDr(OrdRowID)
 	//if (blLabNo'="") s LabEpisodeNo=blLabNo
	d OutPutOrdDetail("LabEpisodeNo",..%Translate("dhc.orderdetailview.csp","标本号"),LabEpisodeNo,Group)
	/*
	s SpecCode=$$GetOELabSpecimen^DHCDocOrderCommonNew(OrdRowID)
	s ContainerCode=$$GetOELabContainer^DHCDocOrderCommonNew(OrdRowID)
	s:SpecCode'="" OrdLabSpec=##Class(DHCLIS.DHCCommon).GetSpecimen(SpecCode,HospitalCode)
	//s:ContainerCode'="" OrdLabCont=##Class(DHCLIS.DHCCommon).GetTestSetContainer(ContainerCode,HospitalCode)
	s:ContainerCode'="" OrdLabCont=##Class(DHCLIS.DHCCommon).GetContainer(ContainerCode,HospitalCode)
	s OrdLabSpec=$P(OrdLabSpec,$C(2),2)
	s OrdLabCont=$P(OrdLabCont,$C(2),3)
	*/
	s OrdLabSpec=##class(web.DHCOEOrdItem).GetLabSpec(OrdRowID)
	s OrdLabCont=##Class(web.DHCOEOrdItem).GetLabContainer(OrdRowID)
	//b
	d OutPutOrdDetail("OrdLabSpec",..%Translate("dhc.orderdetailview.csp","标本"),OrdLabSpec,Group)
	d OutPutOrdDetail("OrdLabCont",..%Translate("dhc.orderdetailview.csp","容器"),OrdLabCont,Group)
	s OrdSpeedFlowRate=$p(ordstr3,"^",17) 
	d OutPutOrdDetail("OrdSpeedFlowRate",..%Translate("dhc.orderdetailview.csp","输液流速"),OrdSpeedFlowRate,Group)
	s OrderFlowRateUnit=$p(ordstr6,"^",8) //流速单位
	i OrderFlowRateUnit'="" s OrderFlowRateUnitdesc=$p($g(^OEC("SFR",OrderFlowRateUnit)),"^",2)
	s OrderFlowRateUnitdesc=##class(User.OECSpeedFlowRate).GetTranByDesc("SFRDesc",OrderFlowRateUnitdesc,langid)
	d OutPutOrdDetail("OrderFlowRateUnitdesc",..%Translate("dhc.orderdetailview.csp","流速单位"),OrderFlowRateUnitdesc,Group)
	s OrderNeedPIVAFlag=$p($G(^OEORD(OrdId1,"I",OrdId2,"DHC")),"^",16)
	d OutPutOrdDetail("OrderNeedPIVAFlag",..%Translate("dhc.orderdetailview.csp","需要配液"),OrderNeedPIVAFlag,Group)
	s OrderNotifyClinician=$p(ordstr11,"^",55)
	if (IsCNMedItem) {
		s DHCQueLinkOrdDR=OrdRowID
		s DHCQUE1RowID=$o(^PAQUE1(0,"DHCPAQue","LinkOrderItem",DHCQueLinkOrdDR,""))
		if (DHCQUE1RowID'="") {
			s OrderNotifyClinician=$p(^PAQUE1(DHCQUE1RowID,"DHC"),"^",22)
		}
	}
	d OutPutOrdDetail("OrderNotifyClinician",..%Translate("dhc.orderdetailview.csp","加急"),OrderNotifyClinician,Group)
	s OrderStage=$p($G(^OEORD(+OrdId1,"I",OrdId2,"DHC")),"^",8)
	s OrderStage=$CASE(OrderStage,"SZ":"术中","SQ":"术前","SH":"术后","CZ":"产中","":"")
	s OrderStage=..%Translate("dhc.orderdetailview.csp",OrderStage)
	d OutPutOrdDetail("OrderStage",..%Translate("dhc.orderdetailview.csp","医嘱阶段"),OrderStage,Group)
	s OrderPilotPro=""
	s OrderPilotProRowId=+$p($g(^OEORD(+OrdId1,"I",OrdId2,"DHC")),"^",10)
	s:OrderPilotProRowId=0 OrderPilotProRowId=""
	if OrderPilotProRowId'="" s OrderPilotPro=$p($G(^DHCDocPP(OrderPilotProRowId)),"^",2) //药理项目

	d OutPutOrdDetail("OrderPilotPro",..%Translate("dhc.orderdetailview.csp","药理项目"),OrderPilotPro,Group)
	s OrderOperation=""
	s OrderOperationCode=$p($g(^OEORD(+OrdId1,"I",OrdId2,4)),"^",10)
	if (OrderOperationCode'="") {
        s curOperId=$P(^OR(EpisodeID,"ANA",$p(OrderOperationCode,"||",2),"OP",$p(OrderOperationCode,"||",3)),"^",6)       ;ANAOP_Type_DR；手术名称
        if $D(^ORC("OPER",curOperId)) s OrderOperation=$P(^ORC("OPER",curOperId),"^",2) //手术
		Set OrderOperation= ##class(User.ORCOperation).GetTranByDesc("OPERDesc",OrderOperation,langid)
	}
	d OutPutOrdDetail("OrderOperation",..%Translate("dhc.orderdetailview.csp","手术列表"),OrderOperation,Group)
	s SerialNum=$p($g(^OEORD(+OrdId1,"I",OrdId2,"DHC")),"^",75)
	d OutPutOrdDetail("OrderOperation",..%Translate("dhc.orderdetailview.csp","医嘱流水号"),SerialNum,Group)
	//s doseQty = ##class(DHCDoc.Interface.Inside.Service).GetOrdDoseQty(OrdRowID) //$p(str2,"^",1)	;用量 OEORI_DoseQty
	s FreqDispTimeDoseQtyStr=$P($G(^OEORD(+OrdId1,"I",OrdId2,"DHC")),"^",59)
	d OutPutOrdDetail("FreqDispTimeDoseQtyStr",..%Translate("dhc.orderdetailview.csp","单次剂量扩展信息"),FreqDispTimeDoseQtyStr,Group)
	s OrderFreqWeek=$p($g(^OEORD(+OrdId1,"I",OrdId2,"DHC")),"^",55)
	d OutPutOrdDetail("OrderFreqWeek",..%Translate("dhc.orderdetailview.csp","周频次扩展信息"),OrderFreqWeek,Group)
	s OrderVirtualtLong=##Class(web.DHCDocOrderVirtualLong).GetVirtualtLongFlag(OrdRowID)
	d OutPutOrdDetail("OrderVirtualtLong",..%Translate("dhc.orderdetailview.csp","虚拟长期"),OrderVirtualtLong,Group)
	
	
	s BindSourceDesc=##Class(web.DHCDocQryOEOrder).GetBindSourceDesc(OrdRowID)
	s BindSourceDesc=..%Translate("dhc.orderdetailview.csp",BindSourceDesc)
	d OutPutOrdDetail("OrderCoverMainIns",..%Translate("dhc.orderdetailview.csp","绑定来源"),BindSourceDesc,Group)
	s LabEpisodeNoStr=$P($G(^OEORD(OrdId1,"I",OrdId2,"DHC")),"^",22)
	d OutPutOrdDetail("OrderCoverMainIns",..%Translate("dhc.orderdetailview.csp","检验绑定来源详情"),LabEpisodeNoStr,Group)
	s BindSourceStr=$P($G(^OEORD(OrdId1,"I",OrdId2,"DHC")),"^",76)
	d OutPutOrdDetail("OrderCoverMainIns",..%Translate("dhc.orderdetailview.csp","绑定来源详情"),BindSourceStr,Group)

	
	
	set qHandle = $lb(0,repid,0)
	Q $$$OK
OutPutOrdDetail(Code,Desc,Value,Group)
	Set ^CacheTemp(repid,ind)=$LB(Code,Desc,Value,Group)
	Set ind=ind+1
	quit
}

/// w ##Class(web.DHCDocInPatPortalCommon).DateLogicalStrToHtml("2018-03-01 10:30")
ClassMethod DateLogicalStrToHtml(DateInfoStr As %String) As %String
{
	q:(DateInfoStr="") DateInfoStr
	s DateStr=$P(DateInfoStr," ",1)
	s TimeStr=$P(DateInfoStr," ",2)
	q:(DateStr="") DateInfoStr
	
	s DateStr=..%ZDH(DateStr)
	s DateStr=##class(web.DHCAPPCommonUtil).DateLogicalToHtml(DateStr)
	q DateStr_" "_TimeStr
}

/// 判断是否需要展示医嘱闭环信息
ClassMethod GetOrderViewFlag(ARCIMRowId As %String, OrderItemRowid As %String = "") As %String
{
	s OrderViewFlag="N"
	s ItemCatRowid=$p(^ARCIM($p(ARCIMRowId,"||",1),$p(ARCIMRowId,"||",2),1),"^",10)
	s OrderType=$P(^ARC("IC",ItemCatRowid),"^",7)
	if (OrderType="R")||(OrderType="L"){
		s OrderViewFlag="Y"
		q OrderViewFlag
	}
	s ServiceFlag=##Class(web.DHCDocOrderCommon).GetItemServiceFlag(ARCIMRowId)
	if (ServiceFlag="1"){
		s OrderViewFlag="Y"
		q OrderViewFlag
	}
	//手术申请对应的医嘱项配置
	if $D(^oddCOM("web.DHCANAdaptor","m","CheckARCIMIsOper")){
		s ret=##Class(web.DHCANAdaptor).CheckARCIMIsOper(ARCIMRowId)
		if (+ret=0){
			s OrderViewFlag="Y"
			q OrderViewFlag
		}
	}
	//会诊
	s EmConsultItm=$p($G(^OEORD(+OrderItemRowid,"I",$p(OrderItemRowid,"||",2),"DHC")),"^",65)
	if (EmConsultItm'=""){
		s OrderViewFlag="Y"
		q OrderViewFlag
		}
	//高值
	s MaterialBarCode=$p($G(^OEORD(+OrderItemRowid,"I",$p(OrderItemRowid,"||",2),"DHC")),"^",14)
	if (MaterialBarCode'=""){
		s OrderViewFlag="Y"
		q OrderViewFlag
		}
	q OrderViewFlag
}

ClassMethod GetDisChargeOEORI(OrdItemStr As %String) As %String
{
	s adm=$p(^OEORD(+OrdItemStr),"^",1)
	s HospID=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(adm)
	s DischargeOEORI=""
	f k=1:1:$l(OrdItemStr,"^") {
		s oneitem=$p(OrdItemStr,"^",k)
		s newOrdIdDR=$p(oneitem,$C(1),1)
		Q:newOrdIdDR=""
		s newArcimIdDR=$p(^OEORD(+newOrdIdDR,"I",$p(newOrdIdDR,"||",2),1),"^",2)
		Q:(newArcimIdDR="")
		s OrderDischargeOrdFlag=##class(web.DHCDocOrderEntry).IsDischargeOrd(newArcimIdDR,HospID)
		i (OrderDischargeOrdFlag'=0) {
			s DischargeOEORI=newOrdIdDR
			Q
		}
	}
	Q DischargeOEORI
}

// w ##class(web.DHCDocInPatPortalCommon).GetOrdDealPermissionTitle("19||43","S^C^U","10209^95^29")

/// 获取医嘱右键按钮权限提示信息
/// w ##class(web.DHCDocInPatPortalCommon).GetOrdDealPermissionTitle("19||43","S^C^U","10209^95^29")
ClassMethod GetOrdDealPermissionTitle(OrderId As %String, OperTypeStr As %String, ExpStr As %String) As %String
{
	s JsonObj=[]
	for i=1:1:$l(OperTypeStr,"^") {
		s title=""
		s type=$p(OperTypeStr,"^",i)
		s ErrMsg=..CheckMulOrdDealPermission(OrderId,"","",type,ExpStr)
		if (ErrMsg'=0) s title=ErrMsg
		s OneJson={}
		d OneJson.%Set("type",type)
		d OneJson.%Set("title",title)
		do JsonObj.%Push(OneJson,"")
	}
	s obj=##class(%Stream.GlobalCharacter).%New()
	do JsonObj.%ToJSON(obj)
	s JsonStr=""
	While 'obj.AtEnd { 
		s JsonStr=JsonStr_obj.ReadLine(,.sc,.eol)
	}
	Q JsonStr
}

/// 获取执行记录右键按钮权限提示信息
/// w ##class(web.DHCDocInPatPortalCommon).GetOrdExecDealPermissionTitle("19||42||25","R^C^D","10209^95^29")
ClassMethod GetOrdExecDealPermissionTitle(OrderExecId As %String, OperTypeStr As %String, ExpStr As %String) As %String
{
	s EpisodeID=$p(^OEORD(+OrderExecId),"^",1)
	s PatDataJson = ##Class(web.DHCDocViewDataInit).GetPatMenuFlag(EpisodeID,"JSON")
	k PatDataArr
	d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(PatDataJson,.PatDataArr)
	s JsonObj=[]
	for i=1:1:$l(OperTypeStr,"^") {
		s type=$p(OperTypeStr,"^",i)
		s title=""
		if (type="U")&&((PatDataArr(1,"patFlag")<3)&&(PatDataArr(1,"patFlag")'=1)){
			s ErrMsg=##class(web.DHCDocMain).CheckUpdateHour(OrderExecId,"")
			if (ErrMsg=1) s ErrMsg=0
			if (ErrMsg'=0) s title=..%Translate("ipdoc.patinfoview.csp",ErrMsg)
		}elseif (PatDataArr(1,"patFlag")>0){
			s title=..%Translate("ipdoc.patinfoview.csp","患者已")_PatDataArr(1,"flagDesc")_"!"
		}else{
			
			
			if ("^R^C^D^"[("^"_type_"^")) {
				s ErrMsg=..CheckMulOrdExecDealPermission(OrderExecId,"","",type,ExpStr)
			}
			if (ErrMsg'=0) s title=ErrMsg
		}
		s OneJson={}
		d OneJson.%Set("type",type)
		d OneJson.%Set("title",title)
		do JsonObj.%Push(OneJson,"")
	}
	s obj=##class(%Stream.GlobalCharacter).%New()
	do JsonObj.%ToJSON(obj)
	s JsonStr=""
	While 'obj.AtEnd { 
		s JsonStr=JsonStr_obj.ReadLine(,.sc,.eol)
	}
	Q JsonStr
}

ClassMethod CheckSeedOrdAuth(OrderIdStr As %String, OrdSeeType As %String) As %String
{
	Set langid=..%LanguageID()
	s JsonObj=[]
	for i=1:1:$l(OrderIdStr,"^") {
		s OrderId=$p(OrderIdStr,"^",i)
		s SeedOrdAuth=1
		;获取医嘱处置状态(同护士执行-需处理-处置状态调用)
		s OrdDisposeStatCode=##class(Nur.NIS.Service.Base.Order).GetOrderDisposeStatCode(+OrderId,$p(OrderId,"||",2))
		if (OrdSeeType="NurSeeOrd") {
			s OEORIStatDr = $p($g(^OEORD(+OrderId,"I",$p(OrderId,"||",2),1)),"^",13)
			s ItemStatCode=""
			s:+OEORIStatDr>0 ItemStatCode = $p(^OEC("OSTAT",OEORIStatDr),"^",1)
			if (ItemStatCode="U") {
				s SeedOrdAuth="-2"
			}else{
				if (OrdDisposeStatCode="AlreadyDeal")||(OrdDisposeStatCode="AlreadyStop") {
					 s SeedOrdAuth="-1"
				 }
			}
		}
		if (OrdSeeType="NurCancelSeeOrd"){
			;NeedToDeal:需处理医嘱 NeedToStop:需处理停止  AlreadyDeal:已处理 AlreadyStop:已处理停止
			if (OrdDisposeStatCode'="AlreadyDeal")&&(OrdDisposeStatCode'="AlreadyStop") {
				s SeedOrdAuth="-1"
			}
		}
		if (SeedOrdAuth'=1) {
			s str1 = ^OEORD(+OrderId,"I",$p(OrderId,"||",2),1)
			s ItmMastDR=$p(str1,"^",2)
			s ARCIMDesc=$p(^ARCIM(+ItmMastDR,$p(ItmMastDR,"||",2),1),"^",2)	
			s ARCIMDesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",ARCIMDesc,langid)
			s OneJson={}
			d OneJson.%Set("OrderId",OrderId)
			d OneJson.%Set("SeedOrdAuth",SeedOrdAuth)
			d OneJson.%Set("ARCIMDesc",ARCIMDesc)
			do JsonObj.%Push(OneJson,"")
		}
	}
	s obj=##class(%Stream.GlobalCharacter).%New()
	do JsonObj.%ToJSON(obj)
	s JsonStr=""
	While 'obj.AtEnd { 
		s JsonStr=JsonStr_obj.ReadLine(,.sc,.eol)
	}
	Q JsonStr
}

ClassMethod GetSkinInfo(oeori As %String, HospID As %String, LangID As %String = "") As %String
{
	
	s OEORIActionDesc="",SkinInfo=""
	s OEORIActionDR=$p($g(^OEORD(+oeori,"I",$p(oeori,"||",2),11)),"^",21)
	if (OEORIActionDR'=""){
		s OEORIActionDesc=$p($g(^OEC("ACT",OEORIActionDR)),"^",2)
		s OEORIActionDesc=##class(User.OECAction).GetTranByDesc("ACTDesc",OEORIActionDesc,LangID)_"&nbsp"
	}
	
	s instrDr = $p($g(^OEORD(+oeori,"I",$p(oeori,"||",2),2)),"^",7)
	s SkinAbnorm=##class(web.DHCDocMainOrderInterface).GetSkinAbnorm(+oeori,$p(oeori,"||",2))
	s isSkinTestInstrFlag=0
	;皮试用法
	s SkinTestInstr=..%GetConfig("SkinTestInstr",HospID)
	if SkinTestInstr'="" s SkinTestInstr="^"_SkinTestInstr_"^"
    if (instrDr'="")&&(SkinTestInstr[("^"_instrDr_"^")) s isSkinTestInstrFlag=1
	s skintest=$p($g(^OEORD(+oeori,"I",$p(oeori,"||",2),5)),"^",2)
	if (skintest="Y")&&(isSkinTestInstrFlag="1"){
		if (SkinAbnorm=""){
			s SkinInfo="<font color=red>"_OEORIActionDesc_..%Translate("ipdoc.patinfoview.csp","未皮试")_"</font>"
		}
	}else{
		if (OEORIActionDesc'=""){
			if (OEORIActionDesc["阴性") {
				s SkinInfo="<font color=green>"_OEORIActionDesc_"</font>"
			}else{
				s SkinInfo="<font color=red>"_OEORIActionDesc_"</font>"
			}
		}
	}
	if (SkinAbnorm="Y"){
		s SkinInfo="<font color=red>"_OEORIActionDesc_..%Translate("ipdoc.patinfoview.csp","阳性")_"</font>"
	}elseif (SkinAbnorm="N"){
		s SkinInfo="<font color=green>"_OEORIActionDesc_..%Translate("ipdoc.patinfoview.csp","阴性")_"</font>"
	}
	q SkinInfo
}

// 判断小时医嘱在增加执行日期当天是否存在未置结束时间的执行记录

// 返回值 空 无需处理 

/// w ##class(web.DHCDocInPatPortalCommon).CheckHourExecBeforeAddExec("146||512","2021-02-08","17:34:23")
ClassMethod CheckHourExecBeforeAddExec(OrderItemStr As %String, date As %String, time As %String) As %String
{
	s date=..%ZDH(date)
	s:time[":" time=..%ZTH(time)
	s OEORIrow=$p(OrderItemStr,"^",1)
	s OEORIrow=$p(OEORIrow,$C(1),1)
	s HourFlag=##class(appcom.OEOrdItem).IsHourOrderItem(OEORIrow)
	Q:'HourFlag ""
	s OEOREChildsub=$O(^OEORDi(0,"OrdItem",+OEORIrow,$p(OEORIrow,"||",2),date,""),-1)
	Q:OEOREChildsub="" ""
	s str = ^OEORD(+OEORIrow,"I",$p(OEORIrow,"||",2),"X",OEOREChildsub)
	s TExStDate = $p(str,"^",1)			// OEORE_ExStDate
	s TExStTime = $p(str,"^",2)
	s ExecStateDR= $p(str,"^",16)
	s THourExEnTime=$p(str,"^",36) //小时医嘱结束时间
	if THourExEnTime {
		//若新增加的执行医嘱的要求执行时间小于最后一次执行记录小时医嘱结束时间,则退出并在前端给出提示
		if (THourExEnTime>=time) {
			Q "-1^"_..%Translate("ipdoc.patinfoview.csp","要求执行时间应大于最后一次执行记录小时医嘱结束时间：")_..%ZT(time,1)
		}
	}else{
		//新增执行记录要求执行时间应大于最后一条执行记录的要求执行时间
		if (TExStDate=date)&&(TExStTime>=time) {
			Q "-1^"_..%Translate("ipdoc.patinfoview.csp","要求执行时间应大于最后一次执行记录小时医嘱要求执行时间：")_..%ZT(TExStTime,1)
		}else{
			Q "0^"_OEORIrow_"||"_OEOREChildsub
		}
	}
	Q ""
}

/// 批量修改医嘱或执行记录中的医保标志
ClassMethod ChangeOrdCovMainInsuFlag(TableName As %String, IDs As %String, CoverMainInsFlag As %String) As %String
{
	if (TableName'="OE_OrdItem")&&(TableName'="OE_OrdExec"){
		q "-1^表名称不正确"
	}
	if (IDs=""){
		q "-2^ID串为空"
	}
	s AppendIDs=""
	for i=1:1:$Length(IDs,"^"){
		s ID=$P(IDs,"^",i)
		continue:(ID="")
		s orderParref=+ID
		s PrescNo=$p($g(^OEORD(orderParref,"I",$P(ID,"||",2),1)),"^",14)
		if (PrescNo'="")&&(##Class(web.DHCDocPrescript).IsPrescType(PrescNo)="1"){
			//草药一整张处方共用同一个医保标识
			s orderId=""
			for {
				s orderId=$O(^OEORDi(0,"OEORI",orderParref,$P(ID,"||",1,2),orderId))
				q:(orderId="")
				//草药绑出来的非草药医嘱不做处理
				s PrescNoSub=$p($g(^OEORD(orderParref,"I",orderId,1)),"^",14)
				continue:PrescNoSub=""
				if ("^"_IDs_"^")[("^"_orderParref_"||"_orderId_"^"){
					continue
				}
				if (AppendIDs=""){
					s AppendIDs=orderParref_"||"_orderId
				}else{
					s AppendIDs=AppendIDs_"^"_orderParref_"||"_orderId
				}
			}
		}
	}
	if (AppendIDs'=""){
		s IDs=IDs_"^"_AppendIDs
	}
	s ret=0
	s Count=0
	s Ret=""
	TS
	for i=1:1:$Length(IDs,"^"){
		s ID=$P(IDs,"^",i)
		continue:Ret="Y"
		continue:(ID="")
		if (TableName="OE_OrdItem"){
			s CoverMainIns=$P($G(^OEORD(+ID,"I",$P(ID,"||",2),3)),"^",3)
			&SQL(Update SQLUser.OE_OrdItem set OEORI_CoverMainIns=:CoverMainInsFlag where OEORI_RowId=:ID)
			d ##class(web.DHCDocDataChangeLog).SaveLog("OE_OrdItem","User.OEOrdItem","医保标识",ID,"医嘱医保标识","U",CoverMainInsFlag,CoverMainIns)
			s Count=Count+1
		}elseif (TableName="OE_OrdExec"){
			if ($LENGTH(ID,"||")=3){
				s OrderCoverMainIns=$P($G(^OEORD(+ID,"I",$P(ID,"||",2),3)),"^",3)
				s CoverMainIns=$P($G(^OEORD(+ID,"I",$P(ID,"||",2),"X",$P(ID,"||",3))),"^",49)
				s:OrderCoverMainIns="" Ret="Y"
				
				i ((OrderCoverMainIns="N")&&(CoverMainInsFlag="Y")){
					s OrderID=+ID_"||"_$P(ID,"||",2)
					&SQL(Update SQLUser.OE_OrdItem set OEORI_CoverMainIns=:CoverMainInsFlag where OEORI_RowId=:OrderID)
					d ##class(web.DHCDocDataChangeLog).SaveLog("OE_OrdItem","User.OEOrdItem","医保标识",ID,"医嘱医保标识","U",CoverMainInsFlag,OrderCoverMainIns)
				}
				&SQL(Update SQLUser.OE_OrdExec set OEORE_CoverMainIns=:CoverMainInsFlag where OEORE_RowId=:ID)
				d ##class(web.DHCDocDataChangeLog).SaveLog("OE_OrdExec","User.OEOrdExec","医保标识",ID,"医嘱执行记录医保标识","U",CoverMainInsFlag,CoverMainIns)
				s Count=Count+1
			}elseif ($LENGTH(ID,"||")=2){
				s OrderCoverMainIns=$P($G(^OEORD(+ID,"I",$P(ID,"||",2),3)),"^",3)
				i ((OrderCoverMainIns="N")&&(CoverMainInsFlag="Y")){
					s OrderID=+ID_"||"_$P(ID,"||",2)
					&SQL(Update SQLUser.OE_OrdItem set OEORI_CoverMainIns=:CoverMainInsFlag where OEORI_RowId=:OrderID)
					d ##class(web.DHCDocDataChangeLog).SaveLog("OE_OrdItem","User.OEOrdItem","医保标识",OrderID,"医嘱医保标识","U",CoverMainInsFlag,OrderCoverMainIns)
				}
				s ExecSubRowID=0
				for{
					s ExecSubRowID=$O(^OEORD(+ID,"I",$P(ID,"||",2),"X",ExecSubRowID))
					q:(ExecSubRowID="")
					s ExecRowID=ID_"||"_ExecSubRowID
					s CoverMainIns=$P($G(^OEORD(+ID,"I",$P(ID,"||",2),"X",ExecSubRowID)),"^",49)
					&SQL(Update SQLUser.OE_OrdExec set OEORE_CoverMainIns=:CoverMainInsFlag where OEORE_RowId=:ExecRowID)
					d ##class(web.DHCDocDataChangeLog).SaveLog("OE_OrdExec","User.OEOrdExec","医保标识",ExecRowID,"医嘱执行记录医保标识","U",CoverMainInsFlag,CoverMainIns)
					s ret=ret+SQLCODE
					s Count=Count+1
				}
			}
		}
		s ret=ret+$G(SQLCODE)
		if (ret'=0){
			quit
		}
	}
	if (Ret="Y"){
		//TRO
		q "请先修改执行记录对应医嘱医保标志！"
		}
	if (ret'=0){
		TRO
		s ret=ret_"^更新数据失败：ID="_$G(ID)
	}else{
		TC
	}
	if (Count=0){
		s ret="-100^未检索到有效的记录。"
	}
	q ret
}

/// @param: papmi 	 	病人rowid
/// @param: adm   		病人就诊表rowid
/// @param: doctor 		开医嘱医生
/// @param: scopeId 	1 全部   非作废, 
/// 					2 作废   为不打印的医嘱U 
/// 					3 当前   为所有未停医嘱和停止时间迟于当前系统时间的医嘱 
/// 					4 待审核 I未激活 
///                     5 已停止 6 今日有效 7 三日有效 8 待处理 9已处理
/// @param: stloc 		开出科室 1表示当前科室与病区 2表示其它科室
/// @param: nursebill  	医嘱单类型  "ALL" 全部 		"N" 医嘱单
/// @param:inputOrderDesc 医嘱模糊查询条件
/// @param:PriorType 医嘱类型 
/// @param:CatType 医嘱分类
/// @param:SortType 时间排序方式 默认时间正序排列
/// @param:OrderPriorType 全部 临时医嘱 长期医嘱
/// d ##class(%ResultSet).RunQuery("web.DHCDocInPatPortalCommon","FindInPatOrder",194,239,"全部",3,1,"ALL","","true","ALL","AT")
Query FindInPatOrderForInsuView(papmi, adm, doctor, scope, stloc, nursebill, inputOrderDesc = "", PriorType = "", CatType = "", SortType = "", OrderPriorType = "", InstrID = "", FreqID = "", focusOrdList = "", CoverMainInsFlag = "", OrdLimitDrugFlag = "", StDate = "", EdDate = "") As websys.Query(ROWSPEC = "OrderId:%String,TItemStatCode:%String,TOeoriOeori:%String,TStDate:%String,TOrderDesc:%String,TDoctor:%String,TStopDate:%String,TStopDoctor:%String,TStopNurse:%String,TdeptDesc:%String:开单科室,TRecDepDesc:%String:接收科室,TOeoriRowid:%String:医嘱id,GroupSign:%String:组符号,OrderType:%String,Priority:%String:医嘱类型,TItemStatDesc:%String:状态,ColorFlag:%String,TBillUom:%String,TStDateHide:%String,StopPermission:%String,CancelPermission:%String,UnusePermission:%String,TPriorityCode:%String,TPHFreqCode:%String,TOEORIAddDate:%String,TOEORISeeInfo:%String,AddNotePermission:%String,TOrderName:%String,DoseQtyInfo:%String,InstrDesc:%String,FreqDesc:%String,TDuratDesc:%String,SumQty:%String,OrderViewFlag:%String,PopoverHtml:%String,ZSQUrl:%String,NurseLinkOrderRowId:%String,IsCNMedItem:%String,CoverMainIns:%String:医保,LimitOrdInfo:%String:限制用药信息")
{
}

ClassMethod FindInPatOrderForInsuViewExecute(ByRef qHandle As %Binary, papmi, adm, doctor = 0, scope = 1, stloc = 1, nursebill = "ALL", inputOrderDesc = "", PriorType = "ALL", CatType = "", SortType = "", OrderPriorType = "", InstrID = "", FreqID = "", focusOrdList = "", CoverMainInsFlag = "", OrdLimitDrugFlag = "", StDate = "", EdDate = "") As %Status
{
	/*s papmi="194"
	s adm="239"
	s doctor="全部"
	s scope="3"
	s stloc="1"
	s nursebill="ALL"
	s inputOrderDesc=""
	s PriorType="ALL"
	s CatType="ALL"
	s SortType="AT"
	s OrderPriorType=""*/
	set repid = $I(^CacheTemp)
	if $g(ind) = "" set ind = 0
	s sessionLocId=%session.Get("LOGON.CTLOCID")
	s currLocId=","_sessionLocId_","
	s UserRowId=%session.Get("LOGON.USERID")
	s GROUPID=%session.Get("LOGON.GROUPID") 
	s sessionHospId=%session.Get("LOGON.HOSPID")
	s sessionDocDr=$P(^SSU("SSUSR",UserRowId),"^",14)
	s CTCPTInternalType=##class(web.DHCDocMain).GetCarePrvTpByUserID(UserRowId)
	s isNurse=(CTCPTInternalType="NURSE")
	if SortType="DT"{
		Set SortByTime=1
	}else{
		Set SortByTime=0	
	}
	s IPGroupInsuMod =..%GetConfig1("IPGroupInsuMod",GROUPID,sessionHospId)
	s UserIDGrp=UserRowId_"Z"_GROUPID
	//隐藏自动绑定医嘱(仅住院有效)
	s IPHiddenAutoOrd="false"
	//表示当前是产房
	s deliveryRommID=##class(Nur.IP.Delivery).getDeliveryRoomID(adm)
	s ifDeliveryRoom=0
	s:deliveryRommID=sessionLocId ifDeliveryRoom=1
	s id=0 f  s id= $o(^CTLOC(sessionLocId,"LINK",0,"Loc",id)) q:id=""  d
	.s currLocId=currLocId_id_","
	k plist
	s subOeoriIndex=0
	i +adm'>0 set qHandle = $lb(0,repid,0) Q $$$OK
	s space = "&nbsp&nbsp",tab = space_space_space_space
	s orderParref=$o(^OEORD(0,"Adm",adm,0))
	i orderParref=""  set qHandle = $lb(0,repid,0) Q $$$OK
		
	s AdmDate=$P(^PAADM(adm),"^",6)
	Set AdmReason=$P(^PAADM(adm,1),"^",7)
	i StDate["-" s StDate=$ZDH(StDate,3) 
	i EdDate["-" s EdDate=$ZDH(EdDate,3) 
	i AdmDate>+StDate s StDate=AdmDate
	i EdDate="" s EdDate=+$H
	s OrdSubCateGoryStr=""
	i CatType["||" s OrdSubCateGoryStr=##class(DHCDoc.DHCDocConfig.SubCatContral).GetOrdSubCateGoryStr(CatType)
	if (focusOrdList=""){
		f Date=StDate:1:EdDate d 
		.s orderId = 0 f  s orderId = $o(^OEORDi(0,"StDt",Date,orderParref,orderId)) q:orderId=""  d
		..s (TStDate,TStTime,TOrderDesc,TDoctor,TStopDate,TStopDoctor,str1,TItemStatCode,oeorioeoridr,addUserDR,TStopNurse) = ""
		..q:'$d(^OEORD(orderParref,"I",orderId,1))
		..s str1 = ^OEORD(orderParref,"I",orderId,1)
		..//s:$d(^OEORD(orderParref,"I",orderId,3)) str3=^OEORD(orderParref,"I",orderId,3)
		..s CoverMainIns=$P($G(^OEORD(orderParref,"I",orderId,3)),"^",3)
		..//s ^tmp("CoverMainInsFlag")=$LB(CoverMainInsFlag,CoverMainIns)
		..q:(CoverMainInsFlag="Y")&&(CoverMainInsFlag'=CoverMainIns)
		..q:(CoverMainInsFlag="N")&&(CoverMainInsFlag'=CoverMainIns)
		..q:(CoverMainInsFlag="Null")&&(CoverMainIns'="")
		
		..s ordDept = $p($g(^OEORD(orderParref,"I",orderId,7)),"^",2)
		..q:(currLocId'[(","_ordDept_","))&&((stloc=1))		;当前科室或病区
		..q:(currLocId[(","_ordDept_","))&&((stloc=2))		;其它科室
		..//	stloc=3  时										;全部科室
		..s DoctorDr=$p(str1,"^",11)
		..s itemStatDr = $p(str1,"^",13) 		;OEORI_ItemStat_DR ;OEC_OrderStatus
		..q:(+doctor'=0)&&(doctor'=DoctorDr)
		..s PriorityDR = $p(str1,"^",8)
		..s ItmMastDR = $p(str1,"^",2)
		..Q:ItmMastDR=""
		..q:'$d(^ARCIM(+ItmMastDR,$p(ItmMastDR,"||",2)))
		..
		..s LimitOrdInfo=..GetInsuLimitInfo(ItmMastDR,AdmReason,sessionHospId)
		..q:((OrdLimitDrugFlag="Y")&&(LimitOrdInfo=""))
		..q:((OrdLimitDrugFlag="N")&&(LimitOrdInfo'=""))
		..q:(IPGroupInsuMod="1")&&(DoctorDr'=sessionDocDr)	
		..q:PriorityDR=""
		..;q:'##class(appcom.OEOrdItem).ISShortOrderPrior(PriorityDR,OrderPriorType)&&(PriorType="OM")
		..q:+ItmMastDR'>0
		..s ItemCatRowid=$p($g(^ARCIM(+ItmMastDR,$p(ItmMastDR,"||",2),1)),"^",10)
		..s OrderCatType=$P(^ARC("IC",ItemCatRowid),"^",7)
		..q:'(..MatchAliasOrd(orderParref_"||"_orderId,inputOrderDesc))
		..s:+itemStatDr>0 TItemStatCode = $p(^OEC("OSTAT",itemStatDr),"^",1)
		..q:'##class(web.DHCDocMainOrderInterface).LongOrderScope(scope,TItemStatCode,orderParref,orderId,ifDeliveryRoom)
		..q:(PriorType="S")&&('##class(appcom.OEOrdItem).ISLongOrderPrior(PriorityDR))
		..q:(PriorType="OM")&&('##class(appcom.OEOrdItem).ISShortOrderPrior(PriorityDR,"ShortOrderPrior"))
		..q:(PriorType="OUT")&&('##class(appcom.OEOrdItem).ISShortOrderPrior(PriorityDR,"OutOrderPrior"))
		..Q:(("^"_OrdSubCateGoryStr_"^")'[("^"_ItemCatRowid_"^"))&&(CatType["||")
		..s ItemCatDR=$p(^ARCIM(+ItmMastDR,$p(ItmMastDR,"||",2),1),"^",10)
		..s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)
		..Q:(CatType="ALLNotDurg")&&(OrderType="R") //全部非药品
		..Q:(CatType="ALLLabAndService")&&(OrderType'="L")&&(##class(web.DHCDocOrderCommon).GetItemServiceFlag(ItmMastDR)'="1") //全部检验检查
		..q:(nursebill="N")&&('##class(web.DHCDocMainOrderInterface).IsOrdBillOE(orderParref,orderId))
		..q:(nursebill="Nurse")&&('##class(web.DHCDocMainOrderInterface).IsNurseAdd(orderParref,orderId))  //护嘱单
		..s InstrRowid=$P($G(^OEORD(orderParref,"I",orderId,2)),"^",7)
		..q:(InstrID'="")&&(InstrID'=InstrRowid)
		..s FreqRowid=$P($G(^OEORD(orderParref,"I",orderId,2)),"^",4)
		..Q:(FreqID'="")&&(FreqID'=FreqRowid)
		..d FindInPatOrderForInsuViewSort
	}else{
		//仅查询传入的医嘱id列表
		for i=1:1:$Length(focusOrdList,"@"){
			s OnefocusOrdList=$P(focusOrdList,"@",i)
			continue:(orderParref'=$P(OnefocusOrdList,"||",1))
			s LinOrdRowid = $p(^OEORD(orderParref,"I",$P(OnefocusOrdList,"||",2),11),"^",39)
			if (LinOrdRowid'=""){
				s orderId=$P(LinOrdRowid,"||",2)
				d FindInPatOrderForInsuViewSort
				s orderId=""
				for {
					s orderId=$O(^OEORDi(0,"OEORI",orderParref,LinOrdRowid,orderId))
					q:(orderId="")
					d FindInPatOrderForInsuViewSort
				}
			}else{
				s orderId=$P(OnefocusOrdList,"||",2)
				d FindInPatOrderForInsuViewSort
			}
		}
	}
	d ..OutputGroupOrderTime(repid,ind,.plist,SortByTime,sessionHospId)
	set qHandle = $lb(0,repid,0)
	Q $$$OK
FindInPatOrderForInsuViewSort
	s str1=^OEORD(orderParref,"I",orderId,1)
	s PrescNo=$p($g(^OEORD(+orderParref,"I",orderId,1)),"^",14)
	s groupdr = $p(^OEORD(orderParref,"I",orderId,11),"^",39)
	if (PrescNo'="")&&(##Class(web.DHCDocPrescript).IsPrescType(PrescNo)="1")&&(groupdr'=""){
		//草药处方控制只显示一条主医嘱信息,处方明细在泡芙提示里面显示
		q
	}
	s BindSource=$P($g(^OEORD(orderParref,"I",orderId,"DHC")),"^",41)
	//q:(IPHiddenAutoOrd="true")&&((BindSource'="")||(groupdr'=""))
	s rslist = ..OrderInfoForInsuView(orderParref_"||"_orderId,LimitOrdInfo)
	i isNurse=1 d
	.s TOrderDesc=$list(rslist,5)
	.s TOrderName=$list(rslist,28)
	.s NurColor=..GetOrderColor(orderParref_"||"_orderId)
	.if NurColor'="" s TOrderDesc="<font color="_NurColor_">"_TOrderDesc_"</font>"
	.if NurColor'="" s TOrderName="<font color="_NurColor_">"_TOrderName_"</font>"
	.s $list(rslist,5)=TOrderDesc
	.s $list(rslist,28)=TOrderName
	s groupdr = $p(^OEORD(orderParref,"I",orderId,11),"^",39)
	i +groupdr>0 d //处理护士补录今天以前的长期医嘱
	.s StartDate=$p(^OEORD(+groupdr,"I",$p(groupdr,"||",2),1),"^",9)
	.s StartTime=$p(^OEORD(+groupdr,"I",$p(groupdr,"||",2),1),"^",10)
	e  d
	.s StartDate=$p(str1,"^",9)
	.s StartTime=$p(str1,"^",10)
	s times=StartDate*24*3600+StartTime
	//i (PriorType="ALL") d 
	i groupdr="" d
	.s groupdr=$p($g(^OEORD(orderParref,"I",orderId,"DHC")),"^",54)
	.if (+groupdr'="0")&&('$d(plist(+groupdr,times,$p(groupdr,"||",2)))) s groupdr=""
	i groupdr s $list(rslist,4)=""

	i +groupdr>0 d
	.i '$d(plist(+groupdr,times,$p(groupdr,"||",2))),((CatType["||")||(CatType="ALLNotDurg")||(CatType="ALLLabAndService")) s OrderInfo=..OrderInfoForInsuView(groupdr,LimitOrdInfo) s $list(OrderInfo,17)=1 s plist(+groupdr,times,$p(groupdr,"||",2))=OrderInfo
	.s plist(+groupdr,times,$p(groupdr,"||",2),"Sub", orderId) = rslist
	e  d
	.s plist(orderParref,times,orderId) = rslist
	q
}

/// w ##Class(web.DHCDocInPatPortalCommon).OrderInfo("413||43")
ClassMethod OrderInfoForInsuView(oeori, LimitOrdInfo = "")
{
	if $d(%request){
		Set qLimit = $g(%request.Data("limit",1))
		Set qStart = $g(%request.Data("start",1))
		Set ^||qCount = $g(^||qCount) + 1
	}
	Set langid=20
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
		s sessionHospId=%session.Get("LOGON.HOSPID")
	}
	s (TStDate,TStTime,TOrderDesc,TDoctor,TStopDate,TStopTime,TStopDoctor,str1,str2,str3,TItemStatCode,oeorioeoridr,DoctorUserDr,TStopNurse,TdeptDesc,TRecDepDesc,TPermission,TDuratDesc1,TBillUom) = ""
	s sessionUserId=%session.Data("LOGON.USERID")
	s sessionLocId=%session.Data("LOGON.CTLOCID")
	s sessionGroupId=%session.Data("LOGON.GROUPID")
	s sessionHospId=%session.Data("LOGON.HOSPID")
	s space = "&nbsp&nbsp",tab = "" //space_space_space_space
	s orderParref=+oeori,orderId=$p(oeori,"||",2)
	s EpisodeID=$P(^OEORD(orderParref),"^",1)
	s PatientID=$P(^PAADM(EpisodeID),"^",1)
	s instrDesc1="",PHFreqDesc1="",depProcNotes="",doseQty=""
	s str2 = $g(^OEORD(orderParref,"I",orderId,2))
	s doseQty = ##class(DHCDoc.Interface.Inside.Service).GetOrdDoseQty(oeori) //$p(str2,"^",1)	;用量 OEORI_DoseQty
	if (doseQty["-") s doseQty="("_doseQty_")"		
	s doseUnitDr= $p(str2,"^",3)	;剂量单位 OEORI_Unit_DR
	s doseUOM=##class(web.DHCDocOrderCommon).GetUOMDesc(doseUnitDr)
	s doseUOM=##class(User.CTUOM).GetTranByDesc("CTUOMDesc",doseUOM,langid)
	s DoseQtyInfo=doseQty_"<font style='font-style:italic;text-decoration:underline'>"_doseUOM_"</font>"
	s instrDr = $p(str2,"^",7)	;用法 OEORI_Instr_DR
	if (+instrDr'=0){
		s instrDesc1=$p(^PHCIN(instrDr),"^",2)
		s instrDesc1=##class(User.PHCInstruc).GetTranByDesc("PHCINDesc1",instrDesc1,langid)
	}
	
	s OrdFreqInfo=##class(DHCDoc.Interface.Inside.ServiceOrd).GetOrdFreqInfo(oeori,"^",langid)
	s PHFreqDr=$List(OrdFreqInfo,1)
	s PHFreqDesc1=$List(OrdFreqInfo,2)
	s PHFreqCode=$List(OrdFreqInfo,5)
	S PHFreqDesc1=$REPLACE(PHFreqDesc1,"^","-")
	S PHFreqCode=$REPLACE(PHFreqDesc1,"^"," ")
	
	s depProcNotes = ""  ;备注 OEORI_DepProcNotes
	s depProcNotesIndex = 0
	f  s depProcNotesIndex=$o(^OEORD(orderParref,"I",orderId,"DEP",depProcNotesIndex)) q:depProcNotesIndex=""  d
	.q:(^OEORD(orderParref,"I",orderId,"DEP",depProcNotesIndex)="")
	.s depProcNotes = depProcNotes_space_^OEORD(orderParref,"I",orderId,"DEP",depProcNotesIndex)
	
	s str1=^OEORD(orderParref,"I",orderId,1)
	s:$d(^OEORD(orderParref,"I",orderId,2)) str2=^OEORD(orderParref,"I",orderId,2)
	s:$d(^OEORD(orderParref,"I",orderId,3)) str3=^OEORD(orderParref,"I",orderId,3)
	;s ordDept = $p(str1,"^",3)
	s ordDept = $p($g(^OEORD(orderParref,"I",orderId,7)),"^",2)
	s:+ordDept>0 TdeptDesc = ##class(web.DHCDocOrderCommon).GetLocDesc(ordDept)
	s:str3'="" TRecDepDR = $p(str3,"^",6)
	s:+TRecDepDR>0 TRecDepDesc = ##class(web.DHCDocOrderCommon).GetLocDesc(TRecDepDR)
	s ItmMastDR = $p(str1,"^",2)
	s OrderName=$p(^ARCIM(+ItmMastDR,$p(ItmMastDR,"||",2),1),"^",2)	;医嘱名称
	s OrderName=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",OrderName,langid)
	s PrescTitle=##class(web.DHCDocSosOrder).GetOrdItemPrescTitle(ItmMastDR,sessionHospId)
	if (PrescTitle'="") s OrderName="<font color=red>【"_PrescTitle_"】</font>"_OrderName
	s OrderAdmReason=$p($g(^OEORD(orderParref,"I",orderId,11)),"^",18)
	s CFPilotPatAdmReason=##class(web.PilotProject.DHCDocPPGroupSeting).GetConfigNode("PilotPatAdmReason")
 	s CFIPPilotPatAdmReason=##class(web.PilotProject.DHCDocPPGroupSeting).GetConfigNode("IPPilotPatAdmReason")
 	if (OrderAdmReason=CFPilotPatAdmReason)||(OrderAdmReason=CFIPPilotPatAdmReason) {
	 	s OrderName="<font color=red>(药理)</font>"_OrderName
	}
	s PhSpecInstr=$p($g(^OEORD(orderParref,"I",orderId,2)),"^",8) //草药备注
	if (PhSpecInstr'="") s OrderName=OrderName_"【"_PhSpecInstr_"】"
	s ItemCatDR=$p(^ARCIM(+ItmMastDR,$p(ItmMastDR,"||",2),1),"^",10)
	s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)
	
	s PriorityDR = $p(str1,"^",8)
	s PriorityCode = $p(^OECPR(PriorityDR),"^",1)
	s priorityTip =  $case(PriorityCode,"OMST":$p(^OECPR(PriorityDR),"^",2),"OMCQZT":$p(^OECPR(PriorityDR),"^",2),:"")
	s TDuratDR="" 
	s:str2'="" TDuratDR = $p(str2,"^",6) 
	s:TDuratDR'="" TDuratDesc1 = $p(^PHCDU(TDuratDR),"^",3)	
	s TDuratDesc1=##class(User.PHCDuration).GetTranByDesc("PHCDUDesc1",$g(TDuratDesc1),langid) 
	s OrdItemCallback=##class(web.DHCDocMainOrderInterface).IsCallbackOrder(orderParref,orderId)
	s BackText=..%Translate("ipdoc.patinfoview.csp","退回")
	s NurseBackText=..%Translate("ipdoc.patinfoview.csp","护士退回")
	s OrdItemCallback=$case(OrdItemCallback,1:"<font color=red>("_BackText_")</font>",:"")
	s OrdNurseCallbackret = ##class(web.DHCDocMainOrderInterface).IsNurseCallbackOrder(orderParref,orderId)
	//s OrdNurseCallback = $case(+OrdNurseCallback,1:"<font color=red>("_NurseBackText_":"_$P(OrdNurseCallback,"^",2)_")</font>",:"")
	if (+OrdNurseCallbackret=1){
		s OrdNurseCallback="<font color=red>("_$P(OrdNurseCallbackret,"^",3)_BackText
		if $P(OrdNurseCallbackret,"^",2)'=""{
			s OrdNurseCallback=OrdNurseCallback_":"_$P(OrdNurseCallbackret,"^",2)
		}
		s OrdNurseCallback=OrdNurseCallback_")</font>"
	}else{
		s OrdNurseCallback=""
	}
	
	s ReqPartDesc=##Class(web.DHCAPPInterface).GetExaReqPartDesc(orderParref_"||"_orderId)
	s oeorioeoridr = $p(^OEORD(orderParref,"I",orderId,11),"^",39)
	s TStDate=$p(str1,"^",9)
	s FirstDayTimes=$P(str1,"^",18)
	s FirstDayTimesDesc=""
	if (TStDate>=..%SysDate())&&(FirstDayTimes'="")&&(oeorioeoridr=""){
		s FirstDayTimesDesc=..%Translate("ipdoc.patinfoview.csp","首日")_":"_FirstDayTimes
	}
	s ItemCatDR=$p(^ARCIM(+ItmMastDR,$p(ItmMastDR,"||",2),1),"^",10)
	s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)
	s PrescNotes=""
	s PrescCookMode=""
	s ARCOSName=""
	i (oeorioeoridr="") d
	.s PrescNo=$p(^OEORD(+orderParref,"I",orderId,1),"^",14)
	.s PrescRowid=""
	.i PrescNo'="" s PrescRowid=$O(^PAQUE1(0,"PrescNo",PrescNo,""))
	.i PrescRowid'="" d
	..s PrescCookMode=$P($g(^PAQUE1(PrescRowid,"DHC")),"^",15)
	..if (PrescCookMode'="") s PrescCookMode=$P($g(^DHCDocConfig("HospDr_"_sessionHospId,"CookMode",PrescCookMode)),"^",2)
	..s PrescCookMode=..%Translate("ipdoc.patinfoview.csp",PrescCookMode)
	..s PrescNotes=$P($g(^PAQUE1(PrescRowid,"DHC")),"^",21)
	
	..s ARCOSRowId=$p($g(^PAQUE1(PrescRowid,"DHC")),"^",24)
	..i ARCOSRowId'="" s ARCOSName=$P($g(^ARCOS(ARCOSRowId)),"^",2)
	
    i depProcNotes="" s depProcNotes=PrescNotes
    s TBillUom = ##class(web.DHCDocMainOrderInterface).GetBillUom(+ItmMastDR,$p(ItmMastDR,"||",2))
    //药品临时医嘱显示总数量
    s SumQty=""
    i ##class(appcom.OEOrdItem).ISShortOrderPrior(PriorityDR,"") { //,OrderType="R"
	    s BillUOMRowid=$p($g(^ARCIM(+ItmMastDR,$p(ItmMastDR,"||",2),8)),"^",14),BillUOMDesc=##class(web.DHCDocOrderCommon).GetUOMDesc(BillUOMRowid)
	    s CheckCHNFlag=##class(web.DHCSTINTERFACE).GetStruModeFlag(ItmMastDR)
		if (CheckCHNFlag="Y") {
		    s Phcdf=$P($g(^ARCIM(+ItmMastDR,$P(ItmMastDR,"||",2),1)),"^",12)
		    if Phcdf'="" s BillUOMRowid=$p(^PHCD(+Phcdf,"DF",$p(Phcdf,"||",2),2),"^",4),BillUOMDesc=##class(web.DHCDocOrderCommon).GetUOMDesc(BillUOMRowid),TBillUom=BillUOMDesc
		}
		s BillUOMDesc=##class(User.CTUOM).GetTranByDesc("CTUOMDesc",BillUOMDesc,langid)
	    s phqtyord=$p($g(^OEORD(+orderParref,"I",orderId,1)),"^",12)
	    s phqtyord=##class(web.DHCDocOrderView).formateNum(phqtyord)
	    s PackQty=$p($g(^OEORD(+orderParref,"I",orderId,9)),"^",4)
		s PackQty=##class(web.DHCDocOrderView).formateNum(PackQty)
		;协议单位
		s ProtocolPackUOMDR=$p($g(^OEORD(+orderParref,"I",orderId,"DHC")),"^",13)
		s:ProtocolPackUOMDR'="" ProtocolPackUOM=##class(web.DHCDocOrderCommon).GetUOMDesc(ProtocolPackUOMDR)
		i OrderType="R" {
			/*if PackQty'=""{
				i ProtocolPackUOMDR'="" s PackQty=PackQty_"<font style='font-style:italic;text-decoration:underline'>"_ProtocolPackUOM_"</font>",SumQty=PackQty
				e  s PackQty=PackQty_"<font style='font-style:italic;text-decoration:underline'>"_BillUOMDesc_"</font>",SumQty=PackQty
			}else {
				i phqtyord'="" {
					s SumQty=phqtyord_"<font style='font-style:italic;text-decoration:underline'>"_doseUOM_"</font>"
				}
			}*/
			s OrdPackQtyInfo=##Class(web.DHCDocQryOEOrder).GetOrdPackQtyInfo(oeori)
			if PackQty'=""{
				s SumQty=##class(DHCDoc.Util.Base).FormateNumber(+$p(OrdPackQtyInfo,"^",1))_"<font style='font-style:italic;text-decoration:underline'>"_##class(User.CTUOM).GetTranByDesc("CTUOMDesc",$p(OrdPackQtyInfo,"^",2),langid)_"</font>"
			}else{
				s SumQty=##class(DHCDoc.Util.Base).FormateNumber(+$p(OrdPackQtyInfo,"^",4))_"<font style='font-style:italic;text-decoration:underline'>"_##class(User.CTUOM).GetTranByDesc("CTUOMDesc",$p(OrdPackQtyInfo,"^",5),langid)_"</font>"
			}
		}else {
			i +phqtyord'=0 s SumQty=phqtyord_"<font style='font-style:italic;text-decoration:underline'>"_BillUOMDesc_"</font>"
		}
    }
    s TBillUom=##class(User.CTUOM).GetTranByDesc("CTUOMDesc",TBillUom,langid)
	;输液滴速
	s SpeedFlowRate=$p($g(^OEORD(orderParref,"I",orderId,3)),"^",17)
	;输液滴速单位
	s FlowRateUnit=""
	s FlowRateUnitDR=$p($g(^OEORD(orderParref,"I",orderId,6)),"^",8)
	if (FlowRateUnitDR'=""){
		s FlowRateUnit=$P($G(^OEC("SFR",FlowRateUnitDR)),"^",2)
		s FlowRateUnit=##class(User.OECSpeedFlowRate).GetTranByDesc("SFRDesc",FlowRateUnit,langid)
	}
	s SpeedFlowStr=""
	s:SpeedFlowRate'="" SpeedFlowStr=..%Translate("ipdoc.patinfoview.csp","滴速")_":"_SpeedFlowRate_FlowRateUnit
	s DARCIMRowid=$o(^DHCItmMast("0","ARCIM",ItmMastDR,""))
	if (DARCIMRowid'=""){
		//自定义描述医嘱
		s CustomDescOrd=$P(^DHCItmMast(DARCIMRowid),"^",24)
		if (depProcNotes'="")&&(CustomDescOrd="Y"){
			s OrderName=""
		}
	}
	s TOrderDesc=OrdNurseCallback_space_OrderName_space_DoseQtyInfo_space_instrDesc1_space_PHFreqDesc1 //_space_TDuratDesc1
	if '##class(appcom.OEOrdItem).ISLongOrderPrior(PriorityDR) {
		s TOrderDesc=TOrderDesc_space_TDuratDesc1
	}
	i PrescCookMode'="" s TOrderDesc=TOrderDesc_space_PrescCookMode
	i SumQty'="" {
		s BloodReqFormNo=##CLASS(DHCLIS.DHCBloodInterface).GetReqFormNo(orderParref_"||"_orderId)
		i $p(BloodReqFormNo,"^")="-1" s TOrderDesc=TOrderDesc_space_..%Translate("ipdoc.patinfoview.csp","共")_"："_SumQty
	}
	if (ARCOSName'="")&&(oeorioeoridr=""){
		s TOrderDesc=TOrderDesc_space_ARCOSName
	}
	s TOrderDesc=TOrderDesc_space_FirstDayTimesDesc_space_depProcNotes_space_priorityTip_space_OrdItemCallback_space_ReqPartDesc_space_SpeedFlowStr   //_space_OrdItemCallback
	s TOrderName=OrdNurseCallback_space_OrderName_space_PrescCookMode_space_FirstDayTimesDesc_space_depProcNotes_space_OrdItemCallback_space_ReqPartDesc_space_SpeedFlowStr
	s TOrderDesc=$$CheckNUll(TOrderDesc,space)
	s TOrderName=$$CheckNUll(TOrderName,space)
	i $d(^OEORD(orderParref,"I",orderId,1))=1 s DoctorDr=$p(^OEORD(orderParref,"I",orderId,1),"^",11)
	s:+$g(DoctorDr)>0 TDoctor = $p($g(^CTPCP(DoctorDr,1)),"^",2),DoctorUserDr = $o(^SSU("SSUSR",0,"CTPCP",DoctorDr,""))
	Set TDoctor= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",TDoctor,langid)
	s TStDate = ..%ZD($p(str1,"^",9)) //$zd($p(str1,"^",9),3)
	s TStTime = ..%ZT($p(str1,"^",10),1)
	
	s TStopDate = $p(^OEORD(orderParref,"I",orderId,3),"^",34)		;XDate
	s:$d(^OEORD(orderParref,"I",orderId,2)) TStopTime = $p(^OEORD(orderParref,"I",orderId,2),"^",15)		;XTime
	s TExEndDate = $p(^OEORD(orderParref,"I",orderId,9),"^",9)		;OEORI_EndDate	
	s TExEndTime = $p(^OEORD(orderParref,"I",orderId,9),"^",10) 	;OEORI_EndTime
	s TStopDate = $s(TStopDate="":TExEndDate, 1:TStopDate)			;没停止日期时,取预停日期	
	s TStopTime = $s(TStopTime="":TExEndTime, 1:TStopTime)
	
	s:TStopDate'="" TStopDate=..%ZD(TStopDate) //$zd(TStopDate,3)
	s:TStopTime'="" TStopTime=..%ZT(TStopTime,2) 
	s itemStatDr = $p(str1,"^",13) 		;OEORI_ItemStat_DR ;OEC_OrderStatus
	s:+itemStatDr>0 TItemStatCode = $p(^OEC("OSTAT",itemStatDr),"^",1)
	
	s userUpdateDr=$p($g(^OEORD(orderParref,"I",orderId,8)),"^",12)
	s:(+userUpdateDr>0)&&(TExEndDate'="") TStopDoctor = $p(^SSU("SSUSR",userUpdateDr),"^",2)	;预停医生
	s StopDoctorDR = $p(^OEORD(orderParref,"I",orderId,3),"^",29)
	s:+StopDoctorDR>0 TStopDoctor = $p(^CTPCP(StopDoctorDR,1),"^",2)	;重新覆盖停医嘱医生
	Set TStopDoctor= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",TStopDoctor,langid)
	s TStDateHide=TStDate,TStTimeHide=TStTime
	if (+oeorioeoridr>0){
		s TOrderDesc = tab_TOrderDesc,TOrderName = tab_TOrderName,TStDate="",TStTime=""
	}
	s TStopNurse = ##class(web.DHCDocMainOrderInterface).GetXOrderNurseName(orderParref,orderId)
	s PriorityId=$p(^OEORD(orderParref,"I",orderId,1),"^",8)
	s TPriorityCode=$p(^OECPR(PriorityId),"^",1) //医嘱类型Code
	s PriorityDesc=$p(^OECPR(PriorityId),"^",2)
	s PriorityDesc=##class(User.OECPriority).GetTranByDesc("OECPRDesc",PriorityDesc,langid)
	s OEORINotifyClinician = $p($G(^OEORD(orderParref,"I",orderId,11)),"^",55)
	s prescNo=$p(^OEORD(+orderParref,"I",orderId,1),"^",14)
	if (prescNo'="")&&(##Class(web.DHCDocPrescript).IsPrescType(prescNo)=1){
		s OEORINotifyClinician=##class(web.DHCSTPCHCOLLS).GetEmy(prescNo)
	}
	s OEORINotifyClinician=$case(OEORINotifyClinician,"Y":"<font color=red>"_..%Translate("ipdoc.patinfoview.csp","急")_"</font>",:"")
	if (+itemStatDr>0){
		s TItemStatDesc = $p(^OEC("OSTAT",itemStatDr),"^",2)
		s TItemStatDesc=##class(User.OECOrderStatus).GetTranByDesc("OSTATDesc",TItemStatDesc,langid)
	}
	s TOrderDesc = OEORINotifyClinician_"&nbsp"_TOrderDesc
	s TOrderName = OEORINotifyClinician_"&nbsp"_TOrderName
	;验证是当日存在异常执行记录未生成情况
	s Rtn=##class(web.DHCDocMain).CheckExecHave(oeori,+$H)
	if +Rtn=1 {
		s Mesag=$P(Rtn,"^",2)
		s TOrderDesc="<font color=red>("_..%Translate("ipdoc.patinfoview.csp","当日执行记录缺失")_")"_..%Translate("ipdoc.patinfoview.csp",Mesag)_"</font>"_"&nbsp"_TOrderDesc
		s TOrderName="<font color=red>("_..%Translate("ipdoc.patinfoview.csp","当日执行记录缺失")_")"_..%Translate("ipdoc.patinfoview.csp",Mesag)_"</font>"_"&nbsp"_TOrderName
	}
	s SkinInfo=..GetSkinInfo(oeori,sessionHospId,langid)
	if (SkinInfo'=""){
		s TOrderDesc = SkinInfo_"&nbsp"_TOrderDesc
		s TOrderName = SkinInfo_"&nbsp"_TOrderName
	}
	
	;需要展示的医嘱状态 停止 撤销 作废 未审核
	s STReasonComtent=""
	if ((TItemStatCode="C")||(TItemStatCode="U")||(TItemStatCode="D")||(TItemStatCode="I"))   {
		//s TOrderDesc="<font color=red>"_TItemStatDesc_"</font>"_"&nbsp"_TOrderDesc
		s STChildSub=$o(^OEORD(+oeori,"I",$p(oeori,"||",2),"ST",""),-1)
		if (STChildSub'="") {
			s STReasonDR=$p($g(^OEORD(+oeori,"I",$p(oeori,"||",2),"ST",STChildSub)),"^",7)
			i STReasonDR'="" {
				s STReasonComtent=$p($g(^OEC("ASCR",STReasonDR)),"^",2)
				s STReasonComtent=##class(User.OECAdminStatusChReason).GetTranByDesc("ASCRDesc",STReasonComtent,langid)
			}else {
				s STReasonComtent=$p($g(^OEORD(+oeori,"I",$p(oeori,"||",2),"ST",STChildSub)),"^",8)
			}
			i STReasonComtent'="" s TItemStatDesc=TItemStatDesc_"("_STReasonComtent_")"
		}
		s TOrderDesc = "<font color=red>"_TItemStatDesc_"</font>"_"&nbsp"_TOrderDesc
		s TOrderName = "<font color=red>"_TItemStatDesc_"</font>"_"&nbsp"_TOrderName
	}
	s DCARowId=$o(^DHCDocCure(0,"OEORI",oeori,""))
	if (+DCARowId>0){
		s Status=$p($g(^DHCDocCure(DCARowId)),"^",3)
		if Status="C",STReasonComtent=""{
			s TOrderDesc="<font color=red>("_..%Translate("ipdoc.patinfoview.csp","治疗已取消")_")"_"</font>"_"&nbsp"_TOrderDesc
			s TOrderName="<font color=red>("_..%Translate("ipdoc.patinfoview.csp","治疗已取消")_")"_"</font>"_"&nbsp"_TOrderName
		}
	}
	s ValARCItem=##Class(web.DHCDocOrderEntry).ValARCItem(ItmMastDR)
	if (ValARCItem=1){
		s TOrderDesc = "<font color=red>("_..%Translate("ipdoc.patinfoview.csp","医嘱项已停用")_")</font>"_TOrderDesc
		s TOrderName = "<font color=red>("_..%Translate("ipdoc.patinfoview.csp","医嘱项已停用")_")</font>"_TOrderName
	}
	
	
	s OrderStage=$p($G(^OEORD(+oeori,"I",$p(oeori,"||",2),"DHC")),"^",8)
	s OrderStage=$CASE(OrderStage,"SZ":"术中","SQ":"术前","SH":"术后","CZ":"产中","":"")
	i OrderStage'=""{
		s OrderStage=..%Translate("ipdoc.patinfoview.csp",OrderStage)
		s TOrderDesc = TOrderDesc_"&nbsp"_OrderStage	
		s TOrderName = TOrderName_"&nbsp"_OrderStage	
	}
	s DischargeOrdFlag=##class(web.DHCDocOrderEntry).IsDischargeOrd(ItmMastDR,sessionHospId)
	if (DischargeOrdFlag=2){
		s DeceasedDate=$p(^PAPER(PatientID,"ALL"),"^",13)
		s DeceasedTime=$p(^PAPER(PatientID,"ALL"),"^",8)
	    i DeceasedDate'="" {
		    s DeceasedDate=..%ZD(DeceasedDate)
		    i DeceasedTime'="" s DeceasedTime=..%ZT(DeceasedTime,2)
			s TOrderDesc = TOrderDesc_"&nbsp"_..%Translate("ipdoc.patinfoview.csp","死亡时间")_":"_DeceasedDate_" "_DeceasedTime	
			s TOrderName = TOrderName_"&nbsp"_..%Translate("ipdoc.patinfoview.csp","死亡时间")_":"_DeceasedDate_" "_DeceasedTime
	    }
	}
		
	s OEORIDate=..%ZD($p(str3,"^",7))
	s OEORITime=..%ZT($p(str1,"^",17),1)
	s OEORIAddDate=OEORIDate_" "_OEORITime
	s StopPermission=##class(web.DHCDocMain).CheckStopOrder(oeori,sessionUserId,sessionLocId,sessionGroupId)
	s CancelPermission=##class(web.DHCDocMain).CheckCancelOrder(oeori,sessionUserId,sessionLocId,sessionGroupId)
	s UnusePermission =##class(web.DHCDocMain).CheckUnuseOrder(oeori,sessionUserId,sessionLocId,sessionGroupId)
	s TOrderDesc=##class(web.DHCDocUtil).EvalJSON(TOrderDesc)
	s OEORISeeDate=$p($g(^OEORD(orderParref,"I",orderId,"NUR")),"^",5) //获取处理日期
	s OEORISeeInfo=""
	if (OEORISeeDate'=""){
		s OEORISeeUser=""
		s OEORISeeType=$p($g(^OEORD(orderParref,"I",orderId,"NUR")),"^",7)
		s OEORISeeRemark=$p($g(^OEORD(orderParref,"I",orderId,"NUR")),"^",8)
		s OEORISeeUserDR=$p($g(^OEORD(orderParref,"I",orderId,"NUR")),"^",4)
		i OEORISeeUserDR'="" s OEORISeeUser=$p(^SSU("SSUSR",OEORISeeUserDR),"^",2)
		//s OEORIDisconUserDR=$p($g(^OEORD(orderParref,"I",orderId,"NUR")),"^",1)
		//i OEORIDisconUserDR'="" s OEORISeeUser=$p(^SSU("SSUSR",OEORISeeUserDR),"^",2)
		s OEORISeeType=$case(OEORISeeType,"F":..%Translate("ipdoc.patinfoview.csp","完成"),"A":..%Translate("ipdoc.patinfoview.csp","接受"),"R":..%Translate("ipdoc.patinfoview.csp","拒绝"),:"")
		s OEORISeeInfo=OEORISeeUser_":"_OEORISeeType
		if (OEORISeeRemark'=""){
			s OEORISeeInfo=OEORISeeInfo_","_OEORISeeRemark
		}
		if (TItemStatCode="C")||(TItemStatCode="D") {
			s OrdDisposeStatCode=##class(Nur.NIS.Service.Base.Order).GetOrderDisposeStatCode(+orderParref,orderId)
			if (OrdDisposeStatCode="NeedToStop") s OEORISeeInfo=""
		}
	}
	s TAddNotePermission =##class(web.DHCDocMain).CheckAddNoteOrder(oeori,sessionUserId,sessionLocId,sessionGroupId)
	s OrderViewFlag=##Class(web.DHCDocInPatPortalCommon).GetOrderViewFlag(ItmMastDR,oeori)
	//获取医嘱泡芙提示信息
	s PopoverHtml=##class(web.DHCOEOrdItem).GetOrderPopoverInfo(oeori,TOrderDesc,langid)
	s ZSQUrl=##class(web.DHCDocService).GetLinkMesageZSQ(ItmMastDR,oeori_"^^^")
	s ZSQUrl=$P(ZSQUrl,"^",3)
	////临时护嘱绑定的长期医嘱id/所辅助的治疗医嘱 
	s NurseLinkOrderRowId=$p($g(^OEORD(orderParref,"I",orderId,"DHC")),"^",54)
	s IsCNMedItem=##class(DHCDoc.Order.Common).IsCNOrdItem(oeori,sessionGroupId)
	s LimitOrdInfo=$G(LimitOrdInfo)
	s LimitOrdInfo=..%Translate("ipdoc.patinfoview.csp",LimitOrdInfo)
	s CoverMainIns=$P(str3,"^",3)
	q $lb(orderParref_"||"_orderId,TItemStatCode,oeorioeoridr,TStDate_" "_TStTime,TOrderDesc,TDoctor,TStopDate_" "_TStopTime,TStopDoctor,TStopNurse,TdeptDesc,TRecDepDesc,orderParref_"||"_orderId,"",OrderType,PriorityDesc,TItemStatDesc,0,TBillUom,TStDateHide_" "_TStTimeHide,StopPermission,CancelPermission,UnusePermission,TPriorityCode,PHFreqCode,OEORIAddDate,OEORISeeInfo,TAddNotePermission,TOrderName,DoseQtyInfo,instrDesc1,PHFreqDesc1,TDuratDesc1,SumQty,OrderViewFlag,PopoverHtml,ZSQUrl,NurseLinkOrderRowId,IsCNMedItem,CoverMainIns,LimitOrdInfo)
CheckNUll(indesc,inspace)
	s artnstr=""
	for icnull=1:1:$L(indesc,inspace)
	{
		s subdesc=$P(indesc,inspace,icnull)
		continue:subdesc=""
		if artnstr="" s artnstr=subdesc
		else  s artnstr=artnstr_inspace_subdesc
	}
	Q:artnstr="" indesc
	q artnstr
}

/// d ##class(%ResultSet).RunQuery("web.DHCDocInPatPortalCommon","MRDiagnosQuery","20")
Query MRDiagnosQuery(PAAdmRowid As %String) As websys.Query(ROWSPEC = "Rowid:%String,MRDiagDesc:%String,DocName:%String")
{
}

ClassMethod MRDiagnosQueryExecute(ByRef qHandle As %Binary, PAAdmRowid As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	Set langid=..%LanguageID()
	k MRDiagnosArr
	if (PAAdmRowid="") quit $$$OK
	s MRAdmRowid=$p(^PAADM(PAAdmRowid),"^",61)
	if (MRAdmRowid="") quit $$$OK
	Set obj=##class(%ResultSet).%New("web.DHCDocDiagLinkToPrse:GetDiaQuery")
	d obj.Execute(MRAdmRowid,"")
	For  Quit:'obj.Next()  Do
	.s Desc=obj.Data("desc")
	.s Desc =##class(User.MRCICDDx).GetTranByDesc("MRCIDDesc",Desc,langid)
	.s Rowid=obj.Data("diaid")
	.s Rowid=$P(Rowid,"$",1)
 	.s UserName=$p($g(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),1)),"^",18)
	.s:UserName'="" UserName=$P(^SSU("SSUSR",UserName),"^",2)
	.s UserName =##class(User.SSUser).GetTranByDesc("SSUSRName",UserName,langid)
	.do OutputAdmList
	d obj.Close()
	quit $$$OK
	
OutputAdmList
	set Data=$lb(Rowid,Desc,UserName)
	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

/// desc：校验(医嘱)执行记录是否需要双签执行
/// input：OrdExecIdStr：执行记录串，ExpStr：session串
/// output：N/Y ：不需要/需要
/// w ##class(web.DHCDocInPatPortalCommon).CheckDoubleSign("98||277","^^^2")
ClassMethod CheckDoubleSign(OrdExecIdStr As %String, ExpStr As %String) As %String
{
	s Flag="N"
	q:OrdExecIdStr="" Flag
	s HospId=$p(ExpStr,"^",4)
	
	f len=1:1:$l(OrdExecIdStr,"^") d
	.s OrdExecId=$p(OrdExecIdStr,"^",len)	;医嘱执行串
	.s OrdExecId=$p(OrdExecId,$c(1),1)		;医嘱串
	.q:(OrdExecId'["||")||(Flag'="N")
	.s OrdId=+OrdExecId
	.s SubId=$p(OrdExecId,"||",2)
	.q:$d(^OEORD(OrdId,"I",SubId,1))=0
	.;护士执行配置->护士执行设置->医嘱执行双签维护
	.s NeedSign=##class(Nur.NIS.Service.OrderExcute.QueryOrder).IsDoubleSignOrderGroup(OrdId,SubId,HospId)
	.s:NeedSign="Y" Flag="Y"
	
	q Flag
}

/// desc：校验用户工号和密码是否匹配
/// input：UserCodeAndPinNumStr : 工号_$c(1)_密码_$c(2)_工号...
/// output：0:匹配，其他:..GetMsg(err)
/// w ##class(web.DHCDocInPatPortalCommon).CheckUserCodeAndPinNum("1"_$c(1)_"2"_$c(2)_"3"_$c(1)_"4")
ClassMethod CheckUserCodeAndPinNum(UserCodeAndPinNumStr As %String) As %String
{
	s ^templx("CheckUserCodeAndPinNum")=UserCodeAndPinNumStr
	q:UserCodeAndPinNumStr="" 0
	s err=0
	f len=1:1:$l(UserCodeAndPinNumStr,$c(2)) d
	.s UserCodeAndPinNum=$p(UserCodeAndPinNumStr,$c(2),len)
	.s UserCode=$p(UserCodeAndPinNum,$c(1),1)
	.q:(UserCode="")||(err'=0)
	.s PinNum=$p(UserCodeAndPinNum,$c(1),2)
	.s UserCode=$ZCVT(UserCode,"U")
	.s UserID=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,0))
	.i UserID="" d
	..s err="-2001^"_UserCode
	.q:err'=0
	.s valid=##Class(web.DHCOEOrdItem).PinNumberValid(UserID,PinNum)
	.i valid'=0 d
	..s err="-2002^"_UserCode
	i err'=0 s err=..GetMsg(err)
	q err
}

ClassMethod CheckOrdSign(OEORIRowid)
{
	s Find=0
	s StatusID = $p(^OEORD(+OEORIRowid,"I",$P(OEORIRowid,"||",2),1),"^",13) 
	Q:StatusID="" Find
	s StatusCode=$p(^OEC("OSTAT",StatusID),"^",1)
	s Code=$CASE(StatusCode,"V":"A","D":"S","C":"I","U":"I",:StatusCode)
	;取最后一次签名
	s SignID=$O(^DHCDocSignVerify(0,"OEORI",OEORIRowid,""),-1)
	Q:SignID="" Find
	s OperationType=$P(^DHCDocSignVerify(SignID),"^",9)
	;门急诊与预住院患者可能是撤销医嘱状态 签名是停止
	if (OperationType=Code)||(("CDU"[StatusCode)&&("SI"[OperationType)){
		s Find=1
	}
	Q Find
}

ClassMethod OrdItemIDStrToList(OrdItemIDStr, LogonHospID = "", ByRef OrdList)
{
	k OrdList
	s OrdItemIDArr=[].%FromJSON(OrdItemIDStr)
	s len=OrdItemIDArr.%Size()
	for i=1:1:len{
		s OrdItemID=OrdItemIDArr.%Get(i-1)
		continue:OrdItemID=""
		s PAQue1RowID=$O(^PAQUE1(0,"DHCPAQue","AddLongOrderID",OrdItemID,0))
		if (PAQue1RowID'=""){
			s CMOrderRowId=$P($G(^PAQUE1(PAQue1RowID,"DHC")),"^",34)
			if CMOrderRowId'=""{
				s OrdItemID=CMOrderRowId
			}
		}
		s MainOrdItemID=$P($G(^OEORD(+OrdItemID,"I",$P(OrdItemID,"||",2),11)),"^",39)
		if MainOrdItemID'=""{
			s OrdList(MainOrdItemID,$P(OrdItemID,"||",2))=1
		}else{
			s OrdList(OrdItemID)=1
		}
	}
	;如果医嘱是草药医嘱 且没有子医嘱,那么追加其子医嘱(医嘱浏览界面草药医嘱只汇总成了一条)
	s OrdItemID="" for{
		s OrdItemID=$O(OrdList(OrdItemID)) Q:OrdItemID=""
		continue:$O(OrdList(OrdItemID,0))>0	;有子医嘱就不再追加
		s OrderType=##class(DHCDoc.Order.Common).GetOrdItemType(OrdItemID)
		continue:OrderType'="R"
		s Ord=+OrdItemID,Sub=$P(OrdItemID,"||",2)
		s ARCIMRowid=$P(^OEORD(Ord,"I",Sub,1),"^",2)
		s PHPrescType=##class(web.DHCDocOrderCommon).GetPHPrescTypeByItem(ARCIMRowid,LogonHospID)
		continue:PHPrescType'=3	;非草药
		s Sub=0 for{
			s Sub=$O(^OEORDi(0,"OEORI",Ord,OrdItemID,Sub)) Q:Sub=""
			s ARCIMRowid=$P(^OEORD(Ord,"I",Sub,1),"^",2)
			s PHPrescType=##class(web.DHCDocOrderCommon).GetPHPrescTypeByItem(ARCIMRowid,LogonHospID)
			continue:PHPrescType'=3	;非草药
			s OrdList(OrdItemID,Sub)=1
		}
	}
	Q 0
}

/// 获取医嘱医保限制用药信息
/// ##class(web.DHCDocInPatPortalCommon).GetInsuLimitInfo("6||1",4,2)
ClassMethod GetInsuLimitInfo(ArcimId, AdmReasonDr, HospId, ExpStr = "")
{
	s ArcimLinkInsuStr=##class(web.DHCINSUPort).ArcimLinkInsuList(ArcimId,AdmReasonDr,HospId,ExpStr)	
	s len=$L(ArcimLinkInsuStr,"!")
	s LimitOrdInfoStr=""
	f i=1:1:len d
	.s ArcimLinkInsu=$P(ArcimLinkInsuStr,"!",i)
	.q:ArcimLinkInsu="" 
	.s limitFlag=$P(ArcimLinkInsu,"^",9)
	.q:limitFlag'=1
	.s LimitOrdInfo=$P(ArcimLinkInsu,"^",8)
	.s LimitOrdInfoStr=$case(LimitOrdInfoStr,"":LimitOrdInfo,:LimitOrdInfoStr_","_LimitOrdInfo)
	q LimitOrdInfoStr
}

/// 获取医保组##class(web.DHCINSUPort).ArcimLinkInsuList医嘱对应医保相关信息
/// Input： ArcimId:医嘱项ID 、AdmReasonDr 医嘱费别（或病人就诊费别）ID 、HospId 院区ID 、ExpStr 生效日期(yyyy-mm-dd)^
/// 	No对应提示： 1、收费项目Rowid；2、收费项目代码；3、收费项目名称；4、价格；5、项目等级/结算属类(甲乙类等)；6、对照标识
/// 	7、自付比例；8、备注(限制信息)；9、特殊标志；10、预留(分类指标1)；11、医保目录编码；12、医保目录名称；13、国家目录编码
/// 	14、国家目录名称
///  w ##class(web.DHCDocInPatPortalCommon).GetArcimLinkInsuInfo("6||1",4,2,"",7)
ClassMethod GetArcimLinkInsuInfo(ArcimId, AdmReasonDr, HospId, ExpStr = "", No)
{
	s ArcimLinkInsuStr=##class(web.DHCINSUPort).ArcimLinkInsuList(ArcimId,AdmReasonDr,HospId,ExpStr)	
	q:+ArcimLinkInsuStr<0 ""
	s len=$L(ArcimLinkInsuStr,"!")
	s ArcimInsuStr=""
	f i=1:1:len d
	.s ArcimInsu=$P(ArcimLinkInsuStr,"!",i)
	.q:ArcimInsu="" 
	.s arciminsu=$P(ArcimInsu,"^",No)
	.q:arciminsu=""
	.s ArcimInsuStr=$case(ArcimInsuStr,"":arciminsu,:ArcimInsuStr_","_arciminsu)
	q ArcimInsuStr
}

/// 获取医嘱医保自付比例和结算属类(甲乙类等)
/// ##class(web.DHCDocInPatPortalCommon).GetInsuClassInfo("6||1",
ClassMethod GetInsuClassInfo(ArcimId, AdmReasonDr, HospId, ExpStr = "")
{
	s ArcimLinkInsuStr=##class(web.DHCINSUPort).ArcimLinkInsuList(ArcimId,AdmReasonDr,HospId,ExpStr)	
	s len=$L(ArcimLinkInsuStr,"!")
	s InsuClassInfoStr=""
	f i=1:1:len d
	.s ArcimLinkInsu=$P(ArcimLinkInsuStr,"!",i)
	.q:ArcimLinkInsu="" 
	.s InsuClass=$P(ArcimLinkInsu,"^",6)
	.s ZFBL=$P(ArcimLinkInsu,"^",7) //自付比例
	.q:(InsuClass="")&&(ZFBL="")
	.s InsuClassInfo=InsuClass_ZFBL
	.s InsuClassInfoStr=$case(InsuClassInfoStr,"":InsuClassInfo,:InsuClassInfoStr_","_InsuClassInfo)
	q InsuClassInfoStr
}

/// 获取多个医嘱项的知识库url
/// OrderItemStr:医嘱id串 "^"分割
/// ##class(web.DHCDocInPatPortalCommon).GetOrdsLinkMesageZSQ("6||1")
ClassMethod GetOrdsLinkMesageZSQ(OrderItemStr)
{
    s ZSKJson=##class(%DynamicArray).%New()
    q:$l(OrderItemStr,"^")>10 ZSKJson.%ToJSON()

    s langid=20
	if ($d(%session)){
		S langid=+$g(%session.Data("LOGON.LANGID"))
	}

    for index=1:1:$l(OrderItemStr,"^"){
        s OrdRowId=$p(OrderItemStr,"^",index)
        s OrdRowId=$p(OrdRowId,$c(1),1)
        continue:OrdRowId=""
        s orderParref=+OrdRowId
        s orderId=$p(OrdRowId,"||",2)
		s ArcimRowid= $p($g(^OEORD(orderParref,"I",orderId,1)),"^",2)
        s OrdName=$p(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1),"^",2) 
        s LinkMesageZSQ=##class(web.DHCDocService).GetLinkMesageZSQ(ArcimRowid,OrdRowId)
        s ZSKItem=##class(%DynamicObject).%New()
        s ZSKItem.OrdRowid=OrdRowId
        s ZSKItem.OrdDesc=OrdName
        s ZSKItem.Url=$p(LinkMesageZSQ,"^",3)
        d ZSKJson.%Push(ZSKItem) 
    }
    q ZSKJson.%ToJSON()
}

/// 获取执行记录状态列表
ClassMethod GetExecStatusJson()
{
	s rows=[]
	d rows.%Push({"id":"","text":(..%Translate("ipdoc.patorderviewnurse.csp","全部状态"))})
	d rows.%Push({"id":"V","text":(..%Translate("ipdoc.patorderviewnurse.csp","未执行"))})
	d rows.%Push({"id":"F","text":(..%Translate("ipdoc.patorderviewnurse.csp","已执行"))})
	d rows.%Push({"id":"D","text":(..%Translate("ipdoc.patorderviewnurse.csp","停止执行"))})
	Q rows.%ToJSON()
}

}
