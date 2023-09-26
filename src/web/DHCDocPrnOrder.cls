Class web.DHCDocPrnOrder Extends %RegisteredObject
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
/// d ##class(%ResultSet).RunQuery("web.DHCDocPrnOrder","FindPrnOrder",20,77351,0,1,1)
Query FindPrnOrder(papmi, adm, doctor, scope, stloc, nursebill, inputOrderDesc = "") As websys.Query(ROWSPEC = "HIDDEN:%String:OrderId,HIDDEN:%String:TItemStatCode,HIDDEN:%String:TOeoriOeori,HIDDEN:%String:PHFreqDesc1,HIDDEN:%String:TPermission,CustomSelected:%String:选择^40,TStDate:%String:开始日期^80,TStTime:%String:时间^55,TOrderDesc:%String:医嘱^400,TDoctor:%String:开医嘱人^80,TStopDate:%String:日期^80,TStopTime:%String:时间^55,TStopDoctor:%String:医生^70,TStopNurse:%String:护士^70,TdeptDesc:%String:开单科室,TRecDepDesc:%String:接收科室,TOeoriRowid:%String:医嘱id,StopPermission,CancelPermission,UnusePermission,TBillUom:%String:计价单位,GroupSign:%String:组符号,OrderType:%String,TStDateHide:%String,TStTimeHide:%String")
{
}

ClassMethod FindPrnOrderExecute(ByRef qHandle As %Binary, papmi, adm, doctor = 0, scope = 1, stloc = 1, nursebill = "ALL", inputOrderDesc = "") As %Status
{
	set repid = $I(^CacheTemp)
	if $g(ind) = "" set ind = 0
	s sessionLocId= %session.Get("LOGON.CTLOCID")
	s currLocId=","_sessionLocId_","
	s id=0 f  s id= $o(^CTLOC(sessionLocId,"LINK",0,"Loc",id)) q:id=""  d
	.s currLocId=currLocId_id_","
	s ^Temp("wanghc","prnq")=papmi_","_adm_","_doctor_","_scope_","_stloc_",nursebill="_nursebill_",sessionLocId="_sessionLocId
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
	.s DoctorDr=$p(str1,"^",11)
	.s itemStatDr = $p(str1,"^",13) 		;OEORI_ItemStat_DR ;OEC_OrderStatus
	.q:(+doctor'=0)&&(doctor'=DoctorDr)
	.s PriorityDR = $p(str1,"^",8)
	.s ItmMastDR = $p(str1,"^",2)	
	.q:PriorityDR=""
	.q:+ItmMastDR'>0
	.q:'##class(appcom.OEOrdItem).ISLongOrderPrior(PriorityDR)
	.q:'##class(web.DHCDocMain).MatchAlias(ItmMastDR,inputOrderDesc)
	.s:+itemStatDr>0 TItemStatCode = $p(^OEC("OSTAT",itemStatDr),"^",1)
	.q:'##class(web.DHCDocMainOrderInterface).LongOrderScope(scope,TItemStatCode,orderParref,orderId)
	.q:(nursebill="N")&&('##class(web.DHCDocMainOrderInterface).IsOrdBillOE(orderParref,orderId))
	.s rslist = ##class(web.DHCDocMain).OrderInfo(orderParref_"||"_orderId)
	.s groupdr = $p(^OEORD(orderParref,"I",orderId,11),"^",39)
	.i +groupdr>0 d
	..s plist(+groupdr,$p(groupdr,"||",2),"Sub", orderId) = rslist 
	.e  d
	..s plist(orderParref,orderId) = rslist 
	if inputOrderDesc'="" d
	.d ..SelectGroupOrder(nursebill,.plist)
	d ..OutputGroupOrder(repid,ind,.plist)
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
Query FindPrnOrderNurse(papmi, adm, doctor, scope, stloc, nursebill = "ALL", inputOrderDesc = "") As websys.Query(ROWSPEC = "HIDDEN:%String:OrderId,HIDDEN:%String:TItemStatCode,HIDDEN:%String:TOeoriOeori,HIDDEN:%String:PHFreqDesc1,HIDDEN:%String:TPermission,CustomSelected:%String:选择^40,TStDate:%String:开始日期,TStTime:%String:时间^50,TOrderDesc:%String:医嘱^400,TDoctor:%String:开医嘱人^80,TStopDate:%String:日期,TStopTime:%String:时间^50,TStopDoctor:%String:医生^70,TStopNurse:%String:护士^70,TdeptDesc:%String:开单科室,TRecDepDesc:%String:接收科室,TOeoriRowid:%String:医嘱id,StopPermission,CancelPermission,UnusePermission,TBillUom:%String:计价单位,GroupSign:%String:组符号,OrderType:%String,TStDateHide:%String,TStTimeHide:%String")
{
}

ClassMethod FindPrnOrderNurseExecute(ByRef qHandle As %Binary, papmi, adm, doctor, scope, stloc = 1, nursebill = "ALL", inputOrderDesc = "") As %Status
{
		set repid = $I(^CacheTemp)
		if $g(ind) = "" set ind = 0
		k plist
		i +adm'>0 set qHandle = $lb(0,repid,0) Q $$$OK
		s ^Temp("wanghc","prnnurse")=papmi_","_adm_","_doctor_","_scope_","_stloc
		s sessionLocId= %session.Get("LOGON.CTLOCID")
		s currLocId=","_sessionLocId_","
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
		.s CTCPTInternalType=""
		.i (DoctorDr>0)&&($d(^CTPCP(DoctorDr,1))) d		
		..s CTPCPCarPrvTpDR = $p(^CTPCP(DoctorDr,1),"^",4)
		..s CTCPTInternalType = $p(^CT("CPT",CTPCPCarPrvTpDR),"^",4)
		.q:(nursebill="Y")&&(CTCPTInternalType'="NURSE")
		.q:(nursebill="N")&&('##class(web.DHCDocMainOrderInterface).IsOrdBillOE(orderParref,orderId))
		.s PriorityDR = $p(str1,"^",8)
		.q:PriorityDR=""
		.q:'##class(appcom.OEOrdItem).ISLongOrderPrior(PriorityDR)
		.q:'##class(web.DHCDocMain).MatchAlias(ItmMastDR,inputOrderDesc)
		.s itemStatDr = $p(str1,"^",13) ;OEORI_ItemStat_DR ;OEC_OrderStatus
		.s:+itemStatDr>0 TItemStatCode = $p(^OEC("OSTAT",itemStatDr),"^",1)
		.q:'##class(web.DHCDocMainOrderInterface).LongOrderScope(scope,TItemStatCode,orderParref,orderId)
		.s rslist = ##class(web.DHCDocMain).OrderInfo(orderParref_"||"_orderId)
		.s groupdr = $p(^OEORD(orderParref,"I",orderId,11),"^",39)
		.i +groupdr>0 d
		..s plist(+groupdr,$p(groupdr,"||",2),"Sub", orderId) = rslist 
		.e  d
		..s plist(orderParref,orderId) = rslist 
		if inputOrderDesc'="" d
		.d ..SelectGroupOrder(nursebill,.plist)
		d ..OutputGroupOrder(repid,ind,.plist)
		set qHandle = $lb(0,repid,0)
		Q $$$OK
}

// 按成组输出医嘱

ClassMethod OutputGroupOrder(repid, ind, ByRef plist)
{
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
	If $g(^DHCDocOrderBillConfig("Main","GroupOrderOnePage"))="Y"{
		Set Limit=14
		if $d(%request){
			Set Limit = %request.Get("limit")
			if ($G(%request.Data("Pagerows",1))'="") s Limit=$G(%request.Data("Pagerows",1))
		}
		s parrefIndex=0, parref=0 f  s parref=$o(plist(orderParref,parref)) q:parref=""  d
		.if (Limit-(ind#Limit))<(plist(orderParref,parref,"ChildNum")+1) d		;剩余行数<将显示的成组行数
		..for i=1:1:(Limit-(ind#Limit)) Set ind=ind+1,^CacheTemp(repid,ind)=$lb("","","-1","")
		.s ind = ind+1,parrefIndex=parrefIndex+1		
		.s ^CacheTemp(repid,ind) = $g(plist(orderParref,parref))
		.s subIndex=0, sub=0 f  s sub = $o(plist(orderParref,parref,"Sub", sub)) q:sub=""  d
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

}
