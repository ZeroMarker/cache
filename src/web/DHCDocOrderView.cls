Class web.DHCDocOrderView Extends DHCDoc.Util.RegisteredObject
{

/// @param: papmi 	 	病人rowid
/// @param: adm   		病人就诊表rowid
/// @param: doctor 		开医嘱医生
/// @param: scopeId 	1 全部   非作废, 
/// 					2 作废   为不打印的医嘱U 
/// 					3 当前   为所有未停医嘱和停止时间迟于当前系统时间的医嘱 
/// 					4 待审核 I未激活 
/// @param: stloc 		开出科室 1表示当前科室与病区 2表示其它科室
/// @param: nursebill  	医嘱单类型  "ALL" 全部 		"N" 医嘱单 
/// d ##class(%ResultSet).RunQuery("web.DHCDocOrderView","FindOrder",63,74,"全部",3,1,"ALL","","true","ALL","AT")
Query FindOrder(papmi, adm, doctor, scope, stloc, nursebill, inputOrderDesc = "", PriorType = "", CatType = "", SortType = "", OrderPriorType = "") As websys.Query(ROWSPEC = "HIDDEN:%String:OrderId,HIDDEN:%String:TItemStatCode,HIDDEN:%String:TOeoriOeori,HIDDEN:%String:PHFreqDesc1,HIDDEN:%String:TPermission,CustomSelected:%String:选择^40,TStDate:%String:开始日期^100,TStTime:%String:时间^55,TOrderDesc:%String:医嘱^400,TDoctor:%String:开医嘱人^80,TStopDate:%String:停止日期^80,TStopTime:%String:停止时间^80,TStopDoctor:%String:停止医生^70,TStopNurse:%String:处理护士^70,TdeptDesc:%String:开单科室,TRecDepDesc:%String:接收科室,TOeoriRowid:%String:医嘱id,StopPermission,CancelPermission,UnusePermission,TBillUom:%String:计价单位,GroupSign:%String:组符号,OrderType:%String,TStDateHide:%String,TStTimeHide:%String,Priority:%String:医嘱类型,TItemStatDesc:%String:状态,ColorFlag:%String")
{
}

ClassMethod FindOrderExecute(ByRef qHandle As %Binary, papmi, adm, doctor = 0, scope = 1, stloc = 1, nursebill = "ALL", inputOrderDesc = "", PriorType = "ALL", CatType = "", SortType = "", OrderPriorType = "") As %Status
{
	s ^tempFindOrderExecute=PriorType_","_OrderPriorType_","_CatType
	set repid = $I(^CacheTemp)
	if $g(ind) = "" set ind = 0
	s sessionLocId=%session.Get("LOGON.CTLOCID")
	s sessionHospId=%session.Get("LOGON.HOSPID")
	s currLocId=","_sessionLocId_","
	if SortType="DT"{
		Set SortByTime=1
	}else{
		Set SortByTime=0	
	}
	//Set SortByTime=1
	s id=0 f  s id= $o(^CTLOC(sessionLocId,"LINK",0,"Loc",id)) q:id=""  d
	.s currLocId=currLocId_id_","
	s ^Temp("wanghc","web.DHCDocOrderView")=papmi_","_adm_","_doctor_","_scope_","_stloc_",nursebill="_nursebill_",sessionLocId="_sessionLocId
	k plist
	s subOeoriIndex=0
	i +adm'>0 set qHandle = $lb(0,repid,0) Q $$$OK
	s space = "&nbsp&nbsp",tab = space_space_space_space
	s orderParref=$o(^OEORD(0,"Adm",adm,0))
	i orderParref=""  set qHandle = $lb(0,repid,0) Q $$$OK	
	s orderId = 0 f  s orderId = $o(^OEORD(orderParref,"I",orderId)) q:orderId=""  d
	.s (TStDate,TStTime,TOrderDesc,TDoctor,TStopDate,TStopDoctor,str1,TItemStatCode,oeorioeoridr,addUserDR,TStopNurse) = ""
	.q:'$d(^OEORD(orderParref,"I",orderId,1))
	.s str1 = ^OEORD(orderParref,"I",orderId,1)
	.s ordDept = $p($g(^OEORD(orderParref,"I",orderId,7)),"^",2)
	.q:(currLocId'[(","_ordDept_","))&&((stloc=1))		;当前科室或病区
	.q:(currLocId[(","_ordDept_","))&&((stloc=2))		;其它科室
	.//	stloc=3  时										;全部科室
	.s DoctorDr=$p(str1,"^",11)
	.s itemStatDr = $p(str1,"^",13) 		;OEORI_ItemStat_DR ;OEC_OrderStatus
	.q:(+doctor'=0)&&(doctor'=DoctorDr)
	.s PriorityDR = $p(str1,"^",8)
	.s ItmMastDR = $p(str1,"^",2)	
	.q:PriorityDR=""
	.q:'##class(appcom.OEOrdItem).ISShortOrderPrior(PriorityDR,OrderPriorType)&&(PriorType="OM")
	.q:+ItmMastDR'>0
	.s ItemCatRowid=$p($g(^ARCIM(+ItmMastDR,$p(ItmMastDR,"||",2),1)),"^",10)
	.s OrderCatType=$P(^ARC("IC",ItemCatRowid),"^",7)
	.//q:'##class(appcom.OEOrdItem).ISLongOrderPrior(PriorityDR)
	.q:'##class(web.DHCDocMain).MatchAlias(ItmMastDR,inputOrderDesc)
	.s:+itemStatDr>0 TItemStatCode = $p(^OEC("OSTAT",itemStatDr),"^",1)
	.q:'##class(web.DHCDocMainOrderInterface).LongOrderScope(scope,TItemStatCode,orderParref,orderId)
	.//q:(OrderType="N")&&('##class(web.DHCDocMainOrderInterface).IsOrdBillOE(orderParref,orderId))
	.q:(PriorType="S")&&('##class(appcom.OEOrdItem).ISLongOrderPrior(PriorityDR))
	.q:(PriorType="OM")&&('##class(appcom.OEOrdItem).ISShortOrderPrior(PriorityDR))
	.s OrdSubCateGoryStr=""
	.i CatType["||" s OrdSubCateGoryStr=##class(DHCDoc.DHCDocConfig.SubCatContral).GetOrdSubCateGoryStr(CatType)
	.Q:(("^"_OrdSubCateGoryStr_"^")'[("^"_ItemCatRowid_"^"))&&(CatType["||")
	.//q:(CatType="L")&&(OrderCatType'="L")
	.//q:(CatType="R")&&(OrderCatType'="R")
	.//q:(CatType="C")&&(##class(web.DHCDocOrderCommon).GetItemServiceFlag(ItmMastDR)'=1)
	.//q:(CatType="N")&&((OrderCatType="L")||(OrderCatType="R")||(##class(web.DHCDocOrderCommon).GetItemServiceFlag(ItmMastDR)=1))
	.q:(nursebill="N")&&('##class(web.DHCDocMainOrderInterface).IsOrdBillOE(orderParref,orderId))
	.s rslist = ..OrderInfo(orderParref_"||"_orderId)
	.s groupdr = $p(^OEORD(orderParref,"I",orderId,11),"^",39)
	.Set StartDate=$p(str1,"^",9)
	.Set StartTime=$p(str1,"^",10)
	.s times=StartDate*24*3600+StartTime
	.i +groupdr>0 d
	..if SortByTime=1 do
	...i '$d(plist(+groupdr,times,$p(groupdr,"||",2))),CatType["||" s OrderInfo=..OrderInfo(groupdr) s $list(OrderInfo,28)=1 s plist(+groupdr,times,$p(groupdr,"||",2))=OrderInfo
	...s plist(+groupdr,times,$p(groupdr,"||",2),"Sub", orderId) = rslist
	..else  do
	...i '$d(plist(+groupdr,$p(groupdr,"||",2))),CatType["||" s OrderInfo=..OrderInfo(groupdr) s $list(OrderInfo,28)=1 s plist(+groupdr,$p(groupdr,"||",2))=OrderInfo
	...s plist(+groupdr,$p(groupdr,"||",2),"Sub", orderId) = rslist 
	.e  d 
	..if SortByTime=1 do
	...s plist(orderParref,times,orderId) = rslist 
	..else  do
	...s plist(orderParref,orderId) = rslist 
	if inputOrderDesc'="" d
	.if SortByTime=1 do
	..d ..SelectGroupOrderTime(nursebill,.plist)
	.else  do
	..d ..SelectGroupOrder(nursebill,.plist)
	if SortByTime=1 do
	.d ..OutputGroupOrderTime(repid,ind,.plist,sessionHospId)
	else  do
	.d ..OutputGroupOrder(repid,ind,.plist,sessionHospId)
	set qHandle = $lb(0,repid,0)
	Q $$$OK
}

/// @param: papmi  病人rowid
/// @param: adm    病人就诊表rowid
/// @param: doctor 开医嘱医生
/// @param: scopeId 1 全部   非作废, 
/// 					2 作废   为不打印的医嘱U 
/// 					3 当前   为所有未停医嘱和停止时间迟于当前系统时间的医嘱 
/// 					4 待审核 I未激活 
/// @param: stloc 开出科室 1表示当前科室与病区 2表示其它科室
/// @param: nursebill 是不是护嘱单 Y是护嘱单,N是医嘱单,ALL是全部
/// d ##class(%ResultSet).RunQuery("web.DHCDocPrnOrder","FindPrnOrder",16,77346,0,1,1)
Query FindOrderNurse(papmi, adm, doctor, scope, stloc, nursebill = "ALL", inputOrderDesc = "", PriorType = "", CatType = "", SortType = "", OrderPriorType = "") As websys.Query(ROWSPEC = "HIDDEN:%String:OrderId,HIDDEN:%String:TItemStatCode,HIDDEN:%String:TOeoriOeori,HIDDEN:%String:PHFreqDesc1,HIDDEN:%String:TPermission,CustomSelected:%String:选择^40,TStDate:%String:开始日期,TStTime:%String:时间^50,TOrderDesc:%String:医嘱^400,TDoctor:%String:开医嘱人^80,TStopDate:%String:停止日期,TStopTime:%String:停止时间^50,TStopDoctor:%String:停止医生^70,TStopNurse:%String:处理护士^70,TdeptDesc:%String:开单科室,TRecDepDesc:%String:接收科室,TOeoriRowid:%String:医嘱id,StopPermission,CancelPermission,UnusePermission,TBillUom:%String:计价单位,GroupSign:%String:组符号,OrderType:%String,TStDateHide:%String,TStTimeHide:%String,Priority:%String:医嘱类型,TItemStatDesc:%String:状态,ColorFlag:%String")
{
}

ClassMethod FindOrderNurseExecute(ByRef qHandle As %Binary, papmi, adm, doctor, scope, stloc = 1, nursebill = "ALL", inputOrderDesc = "", PriorType = "", CatType = "", SortType = "", OrderPriorType = "") As %Status
{
		set repid = $I(^CacheTemp)
		if $g(ind) = "" set ind = 0
		k plist
		i +adm'>0 set qHandle = $lb(0,repid,0) Q $$$OK
		s ^Temp("wanghc","prnnurse")=papmi_","_adm_","_doctor_","_scope_","_stloc
		s sessionLocId= %session.Get("LOGON.CTLOCID")
		s currLocId=","_sessionLocId_","
		s sessionHospId= %session.Get("LOGON.HOSPID")
		if SortType="DT"{
		Set SortByTime=1
		}else{
			Set SortByTime=0	
		}
		;当前病区的科室
		s id=0 f  s id=$o(^CTLOC(id)) q:id=""  d
	 	.i $d(^CTLOC(id,"LINK",0,"Loc",sessionLocId))=10 s currLocId=currLocId_id_"," 
		s space = "&nbsp",tab = space_space_space_space
		s orderParref=$o(^OEORD(0,"Adm",adm,0))
		I orderParref="" set qHandle = $lb(0,repid,0) Q $$$OK
		s orderId = 0 
		f  s orderId = $o(^OEORD(orderParref,"I",orderId)) q:orderId=""  d
		.s (TStDate,TStTime,TOrderDesc,TDoctor,TStopDate,TStopDoctor,str1,TItemStatCode,oeorioeoridr,addUserDR) = ""
		.q:'$d(^OEORD(orderParref,"I",orderId,1))
		.s str1 = ^OEORD(orderParref,"I",orderId,1)
		.s ordDept = $p($g(^OEORD(orderParref,"I",orderId,7)),"^",2)	;OEORI_UserDepartment_DR
		.q:(stloc=1)&&(currLocId'[(","_ordDept_","))	;本病区或科室
		.q:(stloc=2)&&(currLocId[(","_ordDept_","))
		.s DoctorDr=$p(str1,"^",11)
		.q:(+doctor'=0)&&(doctor'=DoctorDr)
		.s ItmMastDR = $p(str1,"^",2)
		.q:+ItmMastDR'>0
		.s ItemCatRowid=$p($g(^ARCIM(+ItmMastDR,$p(ItmMastDR,"||",2),1)),"^",10)
		.s CTCPTInternalType=""
		.i (DoctorDr>0)&&($d(^CTPCP(DoctorDr,1))) d		
		..s CTPCPCarPrvTpDR = $p(^CTPCP(DoctorDr,1),"^",4)
		..s CTCPTInternalType = $p(^CT("CPT",CTPCPCarPrvTpDR),"^",4)
		.s PriorityDR = $p(str1,"^",8)
		.q:PriorityDR=""
		.q:'##class(appcom.OEOrdItem).ISShortOrderPrior(PriorityDR,OrderPriorType)&&(PriorType="OM")
		.q:(nursebill="Y")&&(CTCPTInternalType'="NURSE")
		.q:(nursebill="N")&&('##class(web.DHCDocMainOrderInterface).IsOrdBillOE(orderParref,orderId))
		.q:(PriorType="S")&&('##class(appcom.OEOrdItem).ISLongOrderPrior(PriorityDR))
		.q:(PriorType="OM")&&('##class(appcom.OEOrdItem).ISShortOrderPrior(PriorityDR))
	    .s OrdSubCateGoryStr=""
		.i CatType["||" s OrdSubCateGoryStr=##class(DHCDoc.DHCDocConfig.SubCatContral).GetOrdSubCateGoryStr(CatType)
		.Q:(("^"_OrdSubCateGoryStr_"^")'[("^"_ItemCatRowid_"^"))&&(CatType["||")
		.//q:(CatType="L")&&(OrderCatType'="L")
		.//q:(CatType="R")&&(OrderCatType'="R")
		.//q:(CatType="C")&&(##class(web.DHCDocOrderCommon).GetItemServiceFlag(ItmMastDR)'=1)
		.//q:(CatType="N")&&((OrderCatType="L")||(OrderCatType="R")||(##class(web.DHCDocOrderCommon).GetItemServiceFlag(ItmMastDR)=1))
	
		.//q:'##class(appcom.OEOrdItem).ISLongOrderPrior(PriorityDR)
		.q:'##class(web.DHCDocMain).MatchAlias(ItmMastDR,inputOrderDesc)
		.s itemStatDr = $p(str1,"^",13) ;OEORI_ItemStat_DR ;OEC_OrderStatus
		.s:+itemStatDr>0 TItemStatCode = $p(^OEC("OSTAT",itemStatDr),"^",1)
		.q:'##class(web.DHCDocMainOrderInterface).LongOrderScope(scope,TItemStatCode,orderParref,orderId)
		.s rslist =..OrderInfo(orderParref_"||"_orderId)
		.s groupdr = $p(^OEORD(orderParref,"I",orderId,11),"^",39)
		.Set StartDate=$p(str1,"^",9)
	.Set StartTime=$p(str1,"^",10)
	.s times=StartDate*24*3600+StartTime
	.i +groupdr>0 d
	..if SortByTime=1 do
	...i '$d(plist(+groupdr,times,$p(groupdr,"||",2))),CatType["||" s OrderInfo=..OrderInfo(groupdr) s $list(OrderInfo,28)=1 s plist(+groupdr,times,$p(groupdr,"||",2))=OrderInfo
	...s plist(+groupdr,times,$p(groupdr,"||",2),"Sub", orderId) = rslist
	..else  do
	...i '$d(plist(+groupdr,$p(groupdr,"||",2))),CatType["||" s OrderInfo=..OrderInfo(groupdr) s $list(OrderInfo,28)=1 s plist(+groupdr,$p(groupdr,"||",2))=OrderInfo
	...s plist(+groupdr,$p(groupdr,"||",2),"Sub", orderId) = rslist 
	.e  d 
	..if SortByTime=1 do
	...s plist(orderParref,times,orderId) = rslist 
	..else  do
	...s plist(orderParref,orderId) = rslist 
	if inputOrderDesc'="" d
	.if SortByTime=1 do
	..d ..SelectGroupOrderTime(nursebill,.plist)
	.else  do
	..d ..SelectGroupOrder(nursebill,.plist)
	if SortByTime=1 do
	.d ..OutputGroupOrderTime(repid,ind,.plist,sessionHospId)
	else  do
	.d ..OutputGroupOrder(repid,ind,.plist,sessionHospId)
		set qHandle = $lb(0,repid,0)
		Q $$$OK
}

// 按成组输出医嘱

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
	...s $list(plist(orderParref,parref,"Sub",sub),22)="<p style=""display:inline;color:red;"">┛</p>"
	..else  d  
	...s $list(plist(orderParref,parref,"Sub",sub),22)="<p style=""display:inline;color:red;"">┃</p>" 
	..s plist(orderParref,parref,"ChildNum")=plist(orderParref,parref,"ChildNum")+1
	.i plist(orderParref,parref,"ChildNum")>0 Set $list(plist(orderParref,parref),22)="<p style=""display:inline;color:red;"">┓</p>"

	//成组医嘱只显示在同一页
	If $g(^DHCDocOrderBillConfig(HospCodeNode,"Main","GroupOrderOnePage"))="Y"{
		Set Limit=14
		if $d(%request){
			Set Limit = %request.Get("limit")
		}
		s parrefIndex=0, parref=0 f  s parref=$o(plist(orderParref,parref)) q:parref=""  d
		.if (Limit-(ind#Limit))<(plist(orderParref,parref,"ChildNum")+1) d		;剩余行数<将显示的成组行数
		..for i=1:1:(Limit-(ind#Limit)) Set ind=ind+1,^CacheTemp(repid,ind)=$lb("","","-1","")
		.s ind = ind+1,parrefIndex=parrefIndex+1		
		.s ^CacheTemp(repid,ind) = $g(plist(orderParref,parref))
		.s subIndex=0, sub=0 f  s sub = $o(plist(orderParref,parref,"Sub", sub)) q:sub=""  d
		..b ;9090
		..s ind = ind+1,subIndex=subIndex+1
		..s ^CacheTemp(repid,ind) = plist(orderParref,parref,"Sub",sub)
		..s $list(^CacheTemp(repid,ind),6)=parrefIndex_"."_subIndex
		.s $list(^CacheTemp(repid,ind-subIndex),6)=parrefIndex_"-"_subIndex ;父数据行中6列中,4-3表示他有3条子嘱
	}else{
		s parrefIndex=0, parref=0 f  s parref=$o(plist(orderParref,parref)) q:parref=""  d
		.s ind = ind+1,parrefIndex=parrefIndex+1		
		.s ^CacheTemp(repid,ind) = $g(plist(orderParref,parref))
		.s subIndex=0, sub=0 f  s sub = $o(plist(orderParref,parref,"Sub", sub)) q:sub=""  d
		..s ind = ind+1,subIndex=subIndex+1
		..s ^CacheTemp(repid,ind) = plist(orderParref,parref,"Sub",sub)
		..s $list(^CacheTemp(repid,ind),6)=parrefIndex_"."_subIndex
		.s $list(^CacheTemp(repid,ind-subIndex),6)=parrefIndex_"-"_subIndex				;父数据行中6列中,4-3表示他有3条子嘱
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
	...s plist(orderParref,sub) = ##class(web.DHCDocMain).OrderInfo(orderParref_"||"_sub) 
	..s oeori=0  f  s oeori=$o(^OEORDi(0,"OEORI",orderParref,orderParref_"||"_sub,oeori)) q:oeori=""  d
	...s IsOrdBillOE=##class(web.DHCDocMainOrderInterface).IsOrdBillOE(orderParref,oeori)
	...i ((nursebill="N")&&IsOrdBillOE)||(nursebill'="N") d
	....s plist(orderParref,sub,"Sub",oeori) = ##class(web.DHCDocMain).OrderInfo(orderParref_"||"_oeori)
}

// 按成组输出医嘱

ClassMethod OutputGroupOrderTime(repid, ind, ByRef plist, sessionHospId As %String = "")
{
	i ($g(sessionHospId)="")&&($d(%session)) s sessionHospId=%session.Get("LOGON.HOSPID")
	s HospCodeNode="HospDr_"_sessionHospId
	s orderParref = $o(plist(""))
	q:+orderParref=0
	s time=""
	for  Set time=$o(plist(orderParref,time),-1) Quit:time=""  do
	.s parref=0 f  s parref=$o(plist(orderParref,time,parref)) q:parref=""  d
	..s plist(orderParref,time,parref,"ChildNum")=0	;记录当前医嘱子嘱条数
	..s sub=0 f  s sub = $o(plist(orderParref,time,parref,"Sub",sub)) q:sub=""  d
	...if $o(plist(orderParref,time,parref,"Sub",sub))="" d
	....s $list(plist(orderParref,time,parref,"Sub",sub),22)="<p style=""display:inline;color:red;"">┛</p>"
	...else  d  
	....s $list(plist(orderParref,time,parref,"Sub",sub),22)="<p style=""display:inline;color:red;"">┃</p>" 
	...s plist(orderParref,time,parref,"ChildNum")=plist(orderParref,time,parref,"ChildNum")+1
	..i plist(orderParref,time,parref,"ChildNum")>0 Set $list(plist(orderParref,time,parref),22)="<p style=""display:inline;color:red;"">┓</p>"

	//成组医嘱只显示在同一页
	If $g(^DHCDocOrderBillConfig(HospCodeNode,"Main","GroupOrderOnePage"))="Y"{
		Set Limit=14
		if $d(%request){
			Set Limit = %request.Get("limit")
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
		...s $list(^CacheTemp(repid,ind),6)=parrefIndex_"."_subIndex
		..s $list(^CacheTemp(repid,ind-subIndex),6)=parrefIndex_"-"_subIndex ;父数据行中6列中,4-3表示他有3条子嘱
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
		...s $list(^CacheTemp(repid,ind),6)=parrefIndex_"."_subIndex
		..s $list(^CacheTemp(repid,ind-subIndex),6)=parrefIndex_"-"_subIndex				;父数据行中6列中,4-3表示他有3条子嘱
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
	....s plist(orderParref,time,sub) = ##class(web.DHCDocMain).OrderInfo(orderParref_"||"_sub) 
	...s oeori=0  f  s oeori=$o(^OEORDi(0,"OEORI",orderParref,orderParref_"||"_sub,oeori)) q:oeori=""  d
	....s IsOrdBillOE=##class(web.DHCDocMainOrderInterface).IsOrdBillOE(orderParref,oeori)
	....i ((nursebill="N")&&IsOrdBillOE)||(nursebill'="N") d
	.....s plist(orderParref,time,sub,"Sub",oeori) = ##class(web.DHCDocMain).OrderInfo(orderParref_"||"_oeori)
}

ClassMethod OrderInfo(oeori)
{
	if $d(%request){
		Set qLimit = $g(%request.Data("limit",1))
		Set qStart = $g(%request.Data("start",1))
		Set ^||qCount = $g(^||qCount) + 1
		//Q:(^||qCount<=qStart) $lb()   //注释掉，会影响排序
		//Q:(^||qCount>(qStart+qLimit)) $lb()
	}
	s (TStDate,TStTime,TOrderDesc,TDoctor,TStopDate,TStopTime,TStopDoctor,str1,str2,str3,TItemStatCode,oeorioeoridr,DoctorUserDr,TStopNurse,TdeptDesc,TRecDepDesc,TPermission,TDuratDesc1,TBillUom) = ""
	s sessionUserId=%session.Data("LOGON.USERID")
	s sessionLocId=%session.Data("LOGON.CTLOCID")
	s sessionGroupId=%session.Data("LOGON.GROUPID")
	s space = "&nbsp&nbsp",tab = "" //space_space_space_space
	s orderParref=+oeori,orderId=$p(oeori,"||",2)
	s instrDesc1="",PHFreqDesc1="",depProcNotes="",doseQty=""
	s str2 = $g(^OEORD(orderParref,"I",orderId,2))
	s doseQty = $p(str2,"^",1)	;用量 OEORI_DoseQty		
	s doseUnitDr= $p(str2,"^",3)	;剂量单位 OEORI_Unit_DR
	s doseUOM=##class(web.DHCDocOrderCommon).GetUOMDesc(doseUnitDr)
	s instrDr = $p(str2,"^",7)	;用法 OEORI_Instr_DR
	s:+instrDr'=0 instrDesc1=$p(^PHCIN(instrDr),"^",2)
	s PHFreqDr = $p(str2,"^",4)	;频次 OEORI_PHFreq_DR
	s:PHFreqDr PHFreqDesc1 = $p($g(^PHCFR(PHFreqDr)),"^",3)
	s:PHFreqDr PHFreqCode = $p($g(^PHCFR(PHFreqDr)),"^",1)
	s depProcNotes = ""  ;备注 OEORI_DepProcNotes
	s depProcNotesIndex = 0
	f  s depProcNotesIndex=$o(^OEORD(orderParref,"I",orderId,"DEP",depProcNotesIndex)) q:depProcNotesIndex=""  d
	.s depProcNotes = depProcNotes_" "_^OEORD(orderParref,"I",orderId,"DEP",depProcNotesIndex)
	s str1=^OEORD(orderParref,"I",orderId,1)
	s:$d(^OEORD(orderParref,"I",orderId,2)) str2=^OEORD(orderParref,"I",orderId,2)
	s:$d(^OEORD(orderParref,"I",orderId,3)) str3=^OEORD(orderParref,"I",orderId,3)
	;s ordDept = $p(str1,"^",3)
	s ordDept = $p($g(^OEORD(orderParref,"I",orderId,7)),"^",2)
	s:+ordDept>0 TdeptDesc = ##class(web.DHCDocOrderCommon).GetLocDesc(ordDept)
	s:str3'="" TRecDepDR = $p(str3,"^",6)
	s:+TRecDepDR>0 TRecDepDesc = ##class(web.DHCDocOrderCommon).GetLocDesc(TRecDepDR)
	s ItmMastDR = $p(str1,"^",2)
	s TOrderDesc=$p(^ARCIM(+ItmMastDR,$p(ItmMastDR,"||",2),1),"^",2)	;医嘱名称
	
	s ItemCatDR=$p(^ARCIM(+ItmMastDR,$p(ItmMastDR,"||",2),1),"^",10)
	s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)
	
	s PriorityDR = $p(str1,"^",8)
	s PriorityCode = $p(^OECPR(PriorityDR),"^",1)
	s priorityTip =  $case(PriorityCode,"OMST":$p(^OECPR(PriorityDR),"^",2),"OMCQZT":$p(^OECPR(PriorityDR),"^",2),:"")
	s TDuratDR="" 
	s:str2'="" TDuratDR = $p(str2,"^",6) 
	s:TDuratDR'="" TDuratDesc1 = $p(^PHCDU(TDuratDR),"^",3)	
	if ##class(appcom.OEOrdItem).ISLongOrderPrior(PriorityDR) s TDuratDesc1=""  
	s OrdItemCallback=##class(web.DHCDocMainOrderInterface).IsCallbackOrder(orderParref,orderId)
	s OrdItemCallback=$case(OrdItemCallback,1:"<font color=red>(退回)</font>",:"")
	s OrdNurseCallback = ##class(web.DHCDocMainOrderInterface).IsNurseCallbackOrder(orderParref,orderId)
	s OrdNurseCallback = $case(+OrdNurseCallback,1:"<font color=red>(护士退回)</font>",:"")
	s ReqPartDesc=##Class(web.DHCAPPInterface).GetExaReqPartDesc(orderParref_"||"_orderId)
	s oeorioeoridr = $p(^OEORD(orderParref,"I",orderId,11),"^",39)
	s TStDate=$p(str1,"^",9)
	s FirstDayTimes=$P(str1,"^",18)
	s FirstDayTimesDesc=""
	if (TStDate>=..%SysDate())&&(FirstDayTimes'="")&&(oeorioeoridr=""){
		s FirstDayTimesDesc="首日:"_FirstDayTimes
	}
	i oeorioeoridr="" d
	.s PrescNo=$p(^OEORD(+orderParref,"I",orderId,1),"^",14)
	.s PrescRowid=""
	.i PrescNo'="" s PrescRowid=$O(^PAQUE1(0,"PrescNo",PrescNo,""))
	.i PrescRowid'="" d
	..s PrescCookMode=$P($g(^PAQUE1(PrescRowid,"DHC")),"^",15)
    ..s TDuratDesc1=TDuratDesc1_space_PrescCookMode
    s ItemCatDR=$p(^ARCIM(+ItmMastDR,$p(ItmMastDR,"||",2),1),"^",10)
	s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)
    //药品临时医嘱显示总数量
    i ##class(appcom.OEOrdItem).ISShortOrderPrior(PriorityDR,""),OrderType="R" d
    .s phqtyord=$p($g(^OEORD(+orderParref,"I",orderId,1)),"^",12)
    .s phqtyord=..formateNum(phqtyord)
    .s PackQty=$p($g(^OEORD(+orderParref,"I",orderId,9)),"^",4)
	.s PackQty=..formateNum(PackQty)
	.s SumQty=""
	.i PackQty'="" d
	..;协议单位
	..s ProtocolPackUOMDR=$p($g(^OEORD(+orderParref,"I",orderId,"DHC")),"^",13)
	..i ProtocolPackUOMDR'="" s ProtocolPackUOM=##class(web.DHCDocOrderCommon).GetUOMDesc(ProtocolPackUOMDR),PackQty=PackQty_ProtocolPackUOM,SumQty="共:"_PackQty
	..e  s BillUOMRowid=$p($g(^ARCIM(+ItmMastDR,$p(ItmMastDR,"||",2),8)),"^",14),BillUOMDesc=##class(web.DHCDocOrderCommon).GetUOMDesc(BillUOMRowid),PackQty=PackQty_BillUOMDesc,SumQty="共:"_PackQty
	.e  d
	..i phqtyord'="" s SumQty="共:"_phqtyord_doseUOM
	.i SumQty'="" s TDuratDesc1=TDuratDesc1_space_SumQty
	;输液滴速
	s SpeedFlowRate=$p($g(^OEORD(orderParref,"I",orderId,3)),"^",17)
	if (SpeedFlowRate'="")&&($p(SpeedFlowRate,".",1)="") s SpeedFlowRate=0_SpeedFlowRate
	;输液滴速单位
	s FlowRateUnit=""
	s FlowRateUnitDR=$p($g(^OEORD(orderParref,"I",orderId,6)),"^",8)
	s:FlowRateUnitDR'="" FlowRateUnit=$P($G(^OEC("SFR",FlowRateUnitDR)),"^",2)
	s SpeedFlowStr=""
	s:SpeedFlowRate'="" SpeedFlowStr="滴速:"_SpeedFlowRate_FlowRateUnit
	
	s TOrderDesc=OrdNurseCallback_space_TOrderDesc_space_doseQty_doseUOM_space_instrDesc1_space_PHFreqDesc1_space_TDuratDesc1_space_FirstDayTimesDesc_space_depProcNotes_space_priorityTip_space_OrdItemCallback_space_ReqPartDesc_space_SpeedFlowStr   //_space_OrdItemCallback
	s TOrderDesc=$$ChekcNUll(TOrderDesc,space)
	i $d(^OEORD(orderParref,"I",orderId,1))=1 s DoctorDr=$p(^OEORD(orderParref,"I",orderId,1),"^",11)
	s:+$g(DoctorDr)>0 TDoctor = $p(^CTPCP(DoctorDr,1),"^",2),DoctorUserDr = $o(^SSU("SSUSR",0,"CTPCP",DoctorDr,""))
	
	s TStDate = ..%ZD($p(str1,"^",9)) //$zd($p(str1,"^",9),3)
	s TStTime = ..%ZT($p(str1,"^",10),2)
	
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
	s TStDateHide=TStDate,TStTimeHide=TStTime
	s:+oeorioeoridr>0 TOrderDesc = tab_TOrderDesc,TStDate="",TStTime=""
	s TBillUom = ##class(web.DHCDocMainOrderInterface).GetBillUom(+ItmMastDR,$p(ItmMastDR,"||",2))
	s TStopNurse = ##class(web.DHCDocMainOrderInterface).GetXOrderNurseName(orderParref,orderId)
	s PriorityId=$p(^OEORD(orderParref,"I",orderId,1),"^",8)
	s PriorityDesc=$p(^OECPR(PriorityId),"^",2)
	s OEORINotifyClinician = $p($G(^OEORD(orderParref,"I",orderId,11)),"^",55)
	s OEORINotifyClinician=$case(OEORINotifyClinician,"Y":"<font color=red>急</font>",:"")
	s:+itemStatDr>0 TItemStatDesc = $p(^OEC("OSTAT",itemStatDr),"^",2)
	s TOrderDesc = OEORINotifyClinician_"&nbsp"_TOrderDesc
	
	;验证是当日存在异常执行记录未生成情况
	s Rtn=##class(web.DHCDocMain).CheckExecHave(oeori,+$H)
	if +Rtn=1 d
	.s Mesag=$P(Rtn,"^",2)
	.s TOrderDesc="<font color=red>(当日执行记录缺失)"_Mesag_"</font>"_"&nbsp"_TOrderDesc
	
	;需要展示的医嘱状态 停止 撤销 作废 未审核
	if ((TItemStatCode="C")||(TItemStatCode="U")||(TItemStatCode="D")||(TItemStatCode="I"))   d
	.s STChildSub=$o(^OEORD(orderParref,"I",orderId,"ST",""),-1)
	.if (STChildSub'="") d
	..s STReasonDR=$p($g(^OEORD(orderParref,"I",orderId,"ST",STChildSub)),"^",7)
	..i STReasonDR'="" s STReasonComtent=$p($g(^OEC("ASCR",STReasonDR)),"^",2)
	..e  s STReasonComtent=$p($g(^OEORD(orderParref,"I",orderId,"ST",STChildSub)),"^",8)
	..i STReasonComtent'="" s TItemStatDesc=TItemStatDesc_"("_STReasonComtent_")"
	.s TOrderDesc="<font color=red>"_TItemStatDesc_"</font>"_"&nbsp"_TOrderDesc
	
	s StopPermission=##class(web.DHCDocMain).CheckStopOrder(oeori,sessionUserId,sessionLocId,sessionGroupId)
	s CancelPermission=##class(web.DHCDocMain).CheckCancelOrder(oeori,sessionUserId,sessionLocId,sessionGroupId)
	s UnusePermission =##class(web.DHCDocMain).CheckUnuseOrder(oeori,sessionUserId,sessionLocId,sessionGroupId)
	q $lb(orderParref_"||"_orderId,TItemStatCode,oeorioeoridr,PHFreqCode,TPermission,0,TStDate,TStTime,TOrderDesc,TDoctor,TStopDate,TStopTime,TStopDoctor,TStopNurse,TdeptDesc,TRecDepDesc,orderParref_"||"_orderId,StopPermission,CancelPermission,UnusePermission,TBillUom,"",OrderType,TStDateHide,TStTimeHide,PriorityDesc,TItemStatDesc,0)
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

ClassMethod formateNum(Num)
{
	Q:Num="" Num
	Q:Num'["." Num
	Q:Num>1 Num
	Q:$P(Num,".")'="" Num
	Q "0"_Num
}

}
