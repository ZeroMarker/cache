Class web.DHCDocSosOrder Extends DHCDoc.Util.RegisteredObject
{

/// @param: papmi  病人rowid  
/// @param: adm    病人就诊表rowid
/// @param: doctor 开医嘱医生
/// @param: scopeId 1 全部   非作废, 
/// 					2 作废   为不打印的医嘱U 
/// 					3 当前   为所有未停医嘱和停止时间迟于当前系统时间的医嘱 
/// 					4 待审核 I未激活 
/// @param: stloc 开出科室 1表示当前科室与病区 2表示其它科室
/// @param: nursebill  	医嘱单类型  "ALL" 全部 		"N" 医嘱单 
/// d ##class(%ResultSet).RunQuery("web.DHCDocSosOrder","FindSosOrder",199,306,"全部",2,1,"N",1022)   169  649
Query FindSosOrder(papmi, adm, doctor, scope, stloc, nursebill, inputOrderDesc = "", OrderPriorType = "") As websys.Query(ROWSPEC = "HIDDEN:%String:OrderId,HIDDEN:%String:TItemStatCode,HIDDEN:%String:TOeoriOeori,HIDDEN:%String:PHFreqDesc1,HIDDEN:%String:TPermission,CustomSelected:%String:选择^40,TStDate:%String:日期,TStTime:%String:时间^50,TOrderDesc:%String:医嘱^400,TDoctor:%String:开医嘱人^80,TNurse:%String:处理护士^70,TStopDate:%String:撤销日期^100,TStopTime:%String:撤销时间^70,TItemStatDesc:%String:状态,TdeptDesc:%String:开单科室,TRecDepDesc:%String:接收科室,TOeoriRowid:%String:医嘱id,StopPermission:%String:是否可停止,CancelPermission:%String:是否可撤销,UnusePermission:%String:是否可作废,TBillUom:%String:计价单位,GroupSign:%String:组符号,OrderType:%String:医嘱子类类型,TStDateHide:%String:开始日期,TStTimeHide:%String:开始时间")
{
}

ClassMethod FindSosOrderExecute(ByRef qHandle As %Binary, papmi, adm, doctor, scope, stloc, nursebill = "ALL", inputOrderDesc = "", OrderPriorType = "") As %Status
{
	set repid = $I(^CacheTemp)
	if $g(ind) = "" set ind = 0
	k plist
	i +adm'>0 set qHandle = $lb(0,repid,0) Q $$$OK
	s sessionLocId= %session.Get("LOGON.CTLOCID")
	s LogonUserID= %session.Get("LOGON.USERID")
	s LogonGroupID= %session.Data("LOGON.GROUPID")
	s currLocId=","_sessionLocId_","
	s id=0 f  s id= $o(^CTLOC(sessionLocId,"LINK",0,"Loc",id)) q:id=""  d
	.s currLocId=currLocId_id_","
	;s ^Temp("wanghc","sosrnq")=papmi_","_adm_","_doctor_","_scope_","_stloc
	s orderParref=$o(^OEORD(0,"Adm",adm,0))
	I orderParref="" set qHandle = $lb(0,repid,0) Q $$$OK
	s orderId = 0 f  s orderId = $o(^OEORD(orderParref,"I",orderId)) q:orderId=""  d
	.q:'$d(^OEORD(orderParref,"I",orderId,1))
	.s (str1,str2,str3,TItemStatCode,DoctorUserDr,TOrderDesc,TDoctor,TNurse,TStDate,TStTime,TdeptDesc,TRecDepDesc,TDuratDesc1,TStopDate,TStopTime,TPermission) = ""
	.s str1 = ^OEORD(orderParref,"I",orderId,1)
	.i $d(^OEORD(orderParref,"I",orderId,1))=1 d
	..s DoctorDr=$p(^OEORD(orderParref,"I",orderId,1),"^",11)
	.q:(+doctor'=0)&&(doctor'=DoctorDr)
	.s ordDept = $p($g(^OEORD(orderParref,"I",orderId,7)),"^",2)	;OEORI_UserDepartment_DR
	.q:(stloc=1)&&(currLocId'[(","_ordDept_","))
	.q:(stloc=2)&&(currLocId[(","_ordDept_","))
	.s PriorityDR = $p(str1,"^",8)
	.q:PriorityDR=""
	.q:'##class(appcom.OEOrdItem).ISShortOrderPrior(PriorityDR,OrderPriorType)
	.s ItmMastDR = $p(str1,"^",2)
	.q:+ItmMastDR'>0
	.q:(nursebill="N")&&('##class(web.DHCDocMainOrderInterface).IsOrdBillOE(orderParref,orderId))
	.q:'##class(web.DHCDocMain).MatchAlias(ItmMastDR,inputOrderDesc)
	.s itemStatDr = $p(str1,"^",13) ;OEORI_ItemStat_DR ;OEC_OrderStatus
	.s:+itemStatDr>0 TItemStatCode = $p(^OEC("OSTAT",itemStatDr),"^",1)
	.q:'##class(web.DHCDocMainOrderInterface).ShortOrderScope(scope,TItemStatCode)
	.s outitem=..OrderInfo(orderParref_"||"_orderId,LogonUserID,sessionLocId,LogonGroupID)
	.s oeorioeoridr = $p($g(^OEORD(orderParref,"I",orderId,11)),"^",39)	
	.i +oeorioeoridr>0 d	
	..s plist(+oeorioeoridr,$p(oeorioeoridr,"||",2),"Sub", orderId) = outitem 
	.e  d
	..s plist(orderParref,orderId) = outitem 
	if inputOrderDesc'="" d
	.//d ##class(web.DHCDocPrnOrder).SelectGroupOrder(nursebill,.plist)
	.d ..SelectGroupOrder(nursebill,.plist,LogonUserID,sessionLocId,LogonGroupID)
	b //
	d ##class(web.DHCDocPrnOrder).OutputGroupOrder(repid,ind,.plist)
	set qHandle = $lb(0,repid,0)
	Q $$$OK
}

ClassMethod SelectGroupOrder(nursebill, ByRef plist, LogonUserID, sessionLocId, LogonGroupID)
{
	s orderParref = $o(plist(""))
	q:+orderParref=0  
	s sub=0 f  s sub=$o(plist(orderParref,sub)) q:sub=""  d
	.i $d(^OEORDi(0,"OEORI",orderParref,orderParref_"||"_sub))=10 d 				;orderParref||sub有子嘱
	..k plist(orderParref,sub)
	..s IsOrdBillOE=##class(web.DHCDocMainOrderInterface).IsOrdBillOE(orderParref,sub)
	..i ((nursebill="N")&&IsOrdBillOE)||(nursebill'="N") d
	...s plist(orderParref,sub) = ..OrderInfo(orderParref_"||"_sub,LogonUserID,sessionLocId,LogonGroupID) 
	..s oeori=0  f  s oeori=$o(^OEORDi(0,"OEORI",orderParref,orderParref_"||"_sub,oeori)) q:oeori=""  d
	...s IsOrdBillOE=##class(web.DHCDocMainOrderInterface).IsOrdBillOE(orderParref,oeori)
	...i ((nursebill="N")&&IsOrdBillOE)||(nursebill'="N") d
	....s plist(orderParref,sub,"Sub",oeori) = ..OrderInfo(orderParref_"||"_oeori,LogonUserID,sessionLocId,LogonGroupID)
}

/// @param: papmi  病人rowid
/// @param: adm    病人就诊表rowid
/// @param: doctor 开医嘱医生
/// @param: scopeId  2 作废--为不打印的医嘱 /3 当前 为所有未停医嘱和停止时间迟于当前系统时间的医嘱 /1 全部 
/// @param: stloc 开出科室 1表示当前科室与病区 2表示其它科室
/// @param: nursebill 是不是护嘱单 Y是护嘱单,N是医嘱单,ALL是全部
/// d ##class(%ResultSet).RunQuery("web.DHCDocSosOrder","FindSosOrderNurse",16,77346,"",1,1,ALL)
Query FindSosOrderNurse(papmi, adm, doctor, scope, stloc, nursebill = "ALL", inputOrderDesc = "", OrderPriorType = "") As websys.Query(ROWSPEC = "HIDDEN:%String:OrderId,HIDDEN:%String:TItemStatCode,HIDDEN:%String:TOeoriOeori,HIDDEN:%String:PHFreqDesc1,HIDDEN:%String:TPermission,CustomSelected:%String:选择^40,TStDate:%String:日期,TStTime:%String:时间^50,TOrderDesc:%String:医嘱^400,TDoctor:%String:开医嘱人^80,TNurse:%String:停止护士^70,TStopDate:%String:撤销日期^100,TStopTime:%String:撤销时间^70,TItemStatDesc:%String:状态,TdeptDesc:%String:开单科室,TRecDepDesc:%String:接收科室,TOeoriRowid:%String:医嘱id,StopPermission,CancelPermission,UnusePermission,TBillUom:%String:计价单位,GroupSign:%String:组符号,OrderType:%String,TStDateHide:%String,TStTimeHide:%String")
{
}

/// 25,3,103
ClassMethod FindSosOrderNurseExecute(ByRef qHandle As %Binary, papmi, adm, doctor, scope, stloc = 1, nursebill = "ALL", inputOrderDesc = "", OrderPriorType = "") As %Status
{
	set repid = $I(^CacheTemp)
	if $g(ind) = "" set ind = 0
	i +adm'>0 set qHandle = $lb(0,repid,0) Q $$$OK
	;s ^Temp("wanghc","sosrnq")=papmi_","_adm_","_doctor_","_scope_","_stloc_","_nursebill
	k plist
	s sessionLocId= %session.Get("LOGON.CTLOCID")
	s sessionUserId =  %session.Data("LOGON.USERID")
	s sessionGroupId =  %session.Data("LOGON.GROUPID")
 	s currLocId=","_sessionLocId_","
	;当前病区的科室
	s id=0 f  s id=$o(^CTLOC(id)) q:id=""  d
 	.i $d(^CTLOC(id,"LINK",0,"Loc",sessionLocId))=10 s currLocId=currLocId_id_"," 
	s orderParref=$o(^OEORD(0,"Adm",adm,0))
	I orderParref="" set qHandle = $lb(0,repid,0) Q $$$OK
	s orderId = 0 f  s orderId = $o(^OEORD(orderParref,"I",orderId)) q:orderId=""  d
	.q:'$d(^OEORD(orderParref,"I",orderId,1))
	.s (str1,str2,str3,TItemStatCode,TOrderDesc,TDoctor,TNurse,TStDate,TStTime,DoctorUserDr,TdeptDesc,TRecDepDesc,TStopDate,TStopTime,TPermission,TDuratDesc1) = ""
	.s str1 = ^OEORD(orderParref,"I",orderId,1)
	.s ordDept = $p($g(^OEORD(orderParref,"I",orderId,7)),"^",2)	;OEORI_UserDepartment_DR
	.q:(stloc=1)&&(currLocId'[(","_ordDept_","))	;本病区或科室
	.q:(stloc=2)&&(currLocId[(","_ordDept_","))
	.i $d(^OEORD(orderParref,"I",orderId,1))=1 d
	..s DoctorDr=$p(^OEORD(orderParref,"I",orderId,1),"^",11)
	.q:(+doctor'=0)&&(doctor'=DoctorDr)
	.s CTCPTInternalType=""
	.i +DoctorDr>0 d		
	..s CTPCPCarPrvTpDR = $p(^CTPCP(DoctorDr,1),"^",4)
	..s CTCPTInternalType = $p(^CT("CPT",CTPCPCarPrvTpDR),"^",4)
	.q:(nursebill="Y")&&(CTCPTInternalType'="NURSE")
	.s PriorityDR = $p(str1,"^",8)
	.q:PriorityDR=""
	.q:'##class(appcom.OEOrdItem).ISShortOrderPrior(PriorityDR,OrderPriorType)
	.s ItmMastDR = $p(str1,"^",2)
	.q:+ItmMastDR'>0
	.q:(nursebill="N")&&('##class(web.DHCDocMainOrderInterface).IsOrdBillOE(orderParref,orderId))
	.q:'##class(web.DHCDocMain).MatchAlias(ItmMastDR,inputOrderDesc)
	.s itemStatDr = $p(str1,"^",13) ;OEORI_ItemStat_DR ;OEC_OrderStatus
	.s:+itemStatDr>0 TItemStatCode = $p(^OEC("OSTAT",itemStatDr),"^",1)
	.q:'##class(web.DHCDocMainOrderInterface).ShortOrderScope(scope,TItemStatCode)
	.s outitem=..OrderInfo(orderParref_"||"_orderId,sessionUserId,sessionLocId,sessionGroupId)
	.s oeorioeoridr = $p($g(^OEORD(orderParref,"I",orderId,11)),"^",39)	
	.i +oeorioeoridr>0 d	
	..s plist(+oeorioeoridr,$p(oeorioeoridr,"||",2),"Sub", orderId) = outitem 
	.e  d
	..s plist(orderParref,orderId) = outitem 
	if inputOrderDesc'="" d
	.d ##class(web.DHCDocPrnOrder).SelectGroupOrder(nursebill,.plist)
	d ##class(web.DHCDocPrnOrder).OutputGroupOrder(repid,ind,.plist)
	set qHandle = $lb(0,repid,0)
	Q $$$OK
}

ClassMethod GetSosOrderAllFee(papmi, adm, doctor, scope, stloc = 1, nursebill = "ALL", inputOrderDesc = "")
{
	s ^tmp("GetSosOrderAllFee")=$LB(papmi, adm, doctor, scope, stloc, nursebill, inputOrderDesc)
	s AllFee=0
	Set rset=##Class(%ResultSet).%New("web.DHCDocSosOrder:FindSosOrderFSNurse")
	If rset.QueryIsValid() { 
		Set Status=rset.Execute(papmi, adm, doctor, scope, stloc, nursebill, inputOrderDesc)
		b ;
		If 'Status Quit AllFee
		Set columns = rset.GetColumnCount()
		While (rset.Next()) {
			s OrdState=rset.Data("TItemStatDesc")
			if (OrdState="作废")||(OrdState="停止")||(OrdState="撤销") continue
			s OrderSum=rset.Data("OrderSum")
			s AllFee=AllFee+OrderSum
		}
	}
	i (AllFee[".")&&($P(AllFee,".",1)="")	s AllFee=0_AllFee
	q AllFee
}

/// @param: papmi  病人rowid
/// @param: adm    病人就诊表rowid
/// @param: doctor 开医嘱医生
/// @param: scopeId  2 作废--为不打印的医嘱 /3 当前 为所有未停医嘱和停止时间迟于当前系统时间的医嘱 /1 全部 
/// @param: stloc 开出科室 1表示当前科室与病区 2表示其它科室
/// @param: nursebill 是不是护嘱单 Y是护嘱单,N是医嘱单,ALL是全部
/// d ##class(%ResultSet).RunQuery("web.DHCDocSosOrder","FindSosOrderNurse",16,77346,"",1,1,ALL)
/// 护师
Query FindSosOrderFSNurse(papmi, adm, doctor, scope, stloc, nursebill = "ALL", inputOrderDesc = "") As websys.Query(ROWSPEC = "HIDDEN:%String:OrderId,HIDDEN:%String:TItemStatCode,HIDDEN:%String:TOeoriOeori,HIDDEN:%String:PHFreqDesc1,HIDDEN:%String:TPermission,CustomSelected:%String:选择^40,TStDate:%String:日期,TStTime:%String:时间^50,TOrderDesc:%String:医嘱^400,TDoctor:%String:开医嘱人^80,TNurse:%String:停止护士^70,TStopDate:%String:撤销日期^100,TStopTime:%String:撤销时间^70,TItemStatDesc:%String:状态,TdeptDesc:%String:开单科室,TRecDepDesc:%String:接收科室,TOeoriRowid:%String:医嘱id,StopPermission,CancelPermission,UnusePermission,TBillUom:%String:计价单位,GroupSign:%String:组符号,OrderType:%String,TStDateHide:%String,TStTimeHide:%String,billqty:%String,ArcPrice:%String,PopoverHtml:%String,OrderSum:%String:总金额,MaterialBarCode:%String")
{
}

/// 25,3,103
ClassMethod FindSosOrderFSNurseExecute(ByRef qHandle As %Binary, papmi, adm, doctor, scope, stloc = 1, nursebill = "ALL", inputOrderDesc = "") As %Status
{
	set repid = $I(^CacheTemp)
	if $g(ind) = "" set ind = 0
	i +adm'>0 set qHandle = $lb(0,repid,0) Q $$$OK
	s RegLinkOrdStr=##class(web.DHCOPAdmReg).GetRegLinkOrdListByAdm(adm)
	s MRFeeArcimId=##class(web.DHCOPAdmReg).GetMRFeeArcimId()
	if (RegLinkOrdStr="") s RegLinkOrdStr=MRFeeArcimId
	else  s RegLinkOrdStr=RegLinkOrdStr_"^"_MRFeeArcimId
	k plist
	s space = "&nbsp"
	s tab = space_space_space_space
	s sessionLocId= %session.Get("LOGON.CTLOCID")
	s sessionUserId =  %session.Data("LOGON.USERID")
	s sessionGroupId =  %session.Data("LOGON.GROUPID")
	;s ^Temp("wanghc","sosrnq")=papmi_","_adm_","_doctor_","_scope_","_stloc_","_nursebill_","_sessionLocId_","_sessionUserId_","_sessionGroupId
 	s currLocId=","_sessionLocId_"," 	
	s orderParref=$o(^OEORD(0,"Adm",adm,0))
	I orderParref="" set qHandle = $lb(0,repid,0) Q $$$OK
	s orderId = 0 f  s orderId = $o(^OEORD(orderParref,"I",orderId)) q:orderId=""  d
	.q:'$d(^OEORD(orderParref,"I",orderId,1))
	.s (str1,str2,str3,TItemStatCode,TOrderDesc,TDoctor,TNurse,TStDate,TStTime,DoctorUserDr,TdeptDesc,TRecDepDesc,TStopDate,TStopTime,TPermission,TDuratDesc1) = ""
	.s str1 = ^OEORD(orderParref,"I",orderId,1)
	.s ordDept = $p($g(^OEORD(orderParref,"I",orderId,7)),"^",2)	;OEORI_UserDepartment_DR
	.q:(stloc=1)&&(currLocId'[(","_ordDept_","))	;本病区或科室
	.q:(stloc=2)&&(currLocId[(","_ordDept_","))
	.s DoctorDr=$p(str1,"^",11)
	.s ARCIMRowId=$p($g(^OEORD(orderParref,"I",orderId,1)),"^",2)
	.Q:(DoctorDr="")&&(("^"_RegLinkOrdStr_"^")[("^"_ARCIMRowId_"^"))
	.q:(+doctor'=0)&&(doctor'=DoctorDr)
	.s CTCPTInternalType=""
	.i DoctorDr>0 d		
	..s CTPCPCarPrvTpDR = $p(^CTPCP(DoctorDr,1),"^",4)
	..s CTCPTInternalType = $p(^CT("CPT",CTPCPCarPrvTpDR),"^",4)
	.q:(nursebill="Y")&&(CTCPTInternalType'="NURSE")
	.s PriorityDR = $p(str1,"^",8)
	.q:PriorityDR=""
	.q:'##class(appcom.OEOrdItem).ISShortOrderPrior(PriorityDR)	
	.s ItmMastDR = $p(str1,"^",2)
	.q:+ItmMastDR'>0
	.q:(nursebill="N")&&('##class(web.DHCDocMainOrderInterface).IsOrdBillOE(orderParref,orderId))
	.q:'##class(web.DHCDocMain).MatchAlias(ItmMastDR,inputOrderDesc)
	.s itemStatDr = $p(str1,"^",13) ;OEORI_ItemStat_DR ;OEC_OrderStatus
	.s:+itemStatDr>0 TItemStatCode = $p(^OEC("OSTAT",itemStatDr),"^",1)
	.q:'##class(web.DHCDocMainOrderInterface).ShortOrderScope(scope,TItemStatCode)
	.s PrescNo=$p($g(^OEORD(+orderParref,"I",orderId,1)),"^",14)
	.s groupdr = $p(^OEORD(orderParref,"I",orderId,11),"^",39)
	.Q:(PrescNo'="")&&(##Class(web.DHCDocPrescript).IsPrescType(PrescNo)="1")&&(groupdr'="") //草药处方控制只显示一条主医嘱信息,处方明细在泡芙提示里面显示
	.s outitem=..OrderInfo(orderParref_"||"_orderId,sessionUserId,sessionLocId,sessionGroupId)
	.s oeorioeoridr = $p($g(^OEORD(orderParref,"I",orderId,11)),"^",39)	
	.i +oeorioeoridr>0 d	
	..s plist(+oeorioeoridr,$p(oeorioeoridr,"||",2),"Sub", orderId) = outitem 
	.e  d
	..s plist(orderParref,orderId) = outitem 
	if inputOrderDesc'="" d
	.d ##class(web.DHCDocPrnOrder).SelectGroupOrder(nursebill,.plist)
	d ##class(web.DHCDocPrnOrder).OutputGroupOrder(repid,ind,.plist)
	set qHandle = $lb(0,repid,0)
	Q $$$OK
}

ClassMethod OrderInfo(oeorditem, LogonUserID, sessionLocId, LogonGroupID)
{
	if $d(%request){
		Set qLimit = $g(%request.Data("limit",1))
		Set qStart = $g(%request.Data("start",1))
		//Set ^||qCount = $g(^||qCount) + 1
		//Q:(^||qCount<=qStart) $lb()
		//Q:(^||qCount>(qStart+qLimit)) $lb()
	}
	s sessionHospId=%session.Data("LOGON.HOSPID")
	Set langid=..%LanguageID()
	s AdmType=##class(web.DHCDocOrderEntry).GetPAAdmType($p(^OEORD(+oeorditem),"^",1))
	s orderParref=+oeorditem,orderId=$p(oeorditem,"||",2)
	s (str1,str2,str3,TItemStatCode,DoctorUserDr,TOrderDesc,TDoctor,TNurse,TStDate,TStTime,TdeptDesc,TRecDepDesc,TDuratDesc1,TStopDate,TStopTime,TPermission,OrderType) = ""
	s space = "&nbsp",tab = "" //space_space_space_space
	s str1 = ^OEORD(orderParref,"I",orderId,1)
	i $d(^OEORD(orderParref,"I",orderId,1))=1 d
	.s DoctorDr=$p(^OEORD(orderParref,"I",orderId,1),"^",11)
	s ordDept = $p($g(^OEORD(orderParref,"I",orderId,7)),"^",2)	;OEORI_UserDepartment_DR
	s PriorityDR = $p(str1,"^",8)
	s PriorityCode = $p(^OECPR(PriorityDR),"^",1)
	s PriorityDesc = $p(^OECPR(PriorityDR),"^",2)
	s PriorityDesc=##class(User.OECPriority).GetTranByDesc("OECPRDesc",PriorityDesc,langid)
	s ItmMastDR = $p(str1,"^",2)
	s mastItemCat = $p(^ARCIM(+ItmMastDR,$p(ItmMastDR,"||",2),1),"^",10)	;子类
	s TBillUom = ##class(web.DHCDocMainOrderInterface).GetBillUom(+ItmMastDR,$p(ItmMastDR,"||",2))
	s TBillUom=##class(User.CTUOM).GetTranByDesc("CTUOMDesc",TBillUom,langid)
	s mastItemCatCode= $p(^ARC("IC",mastItemCat),"^",1)
	s arcicOrdCatDR = $p(^ARC("IC",mastItemCat),"^",8)	; 大类 OEC_OrderCategory
	s itemStatDr = $p(str1,"^",13) ;OEORI_ItemStat_DR ;OEC_OrderStatus
	s:+itemStatDr>0 TItemStatCode = $p(^OEC("OSTAT",itemStatDr),"^",1)
	s TItemStatCode=##class(User.OECOrderStatus).GetTranByDesc("OSTATDesc",TItemStatCode,langid)
	s:$d(^OEORD(orderParref,"I",orderId,3)) str3=^OEORD(orderParref,"I",orderId,3)
	i +ItmMastDR>0 d
	.s instrDesc1="",PHFreqDesc1="",depProcNotes="",doseQty="",PhSpecInstr=""
	.s str2 = $g(^OEORD(orderParref,"I",orderId,2))
	.s doseQty =##class(DHCDoc.Interface.Inside.Service).GetOrdDoseQty(oeorditem) //$p(str2,"^",1)	;用量 OEORI_DoseQty		
	.s doseUnitDr= $p(str2,"^",3)	;剂量单位 OEORI_Unit_DR
	.s doseUOM=##class(web.DHCDocOrderCommon).GetUOMDesc(doseUnitDr)
	.s doseUOM=##class(User.CTUOM).GetTranByDesc("CTUOMDesc",doseUOM,langid)
	.s instrDr = $p(str2,"^",7)	;用法 OEORI_Instr_DR
	.s:+instrDr'=0 instrDesc1=$p(^PHCIN(instrDr),"^",2)
	.s instrDesc1=##class(User.PHCInstruc).GetTranByDesc("PHCINDesc1",instrDesc1,langid)
	.s OrdFreqInfo=##class(DHCDoc.Interface.Inside.ServiceOrd).GetOrdFreqInfo(oeorditem,"^")
	.s PHFreqDr=$List(OrdFreqInfo,1)
	.s PHFreqDesc1=$List(OrdFreqInfo,2)
	.s PHFreqCode=$List(OrdFreqInfo,5)
	.s PHFreqDesc1=$REPLACE(PHFreqDesc1,"^","-")
	.s PHFreqCode=$REPLACE(PHFreqDesc1,"^"," ")
	
	.//s PHFreqDr = $p(str2,"^",4)	;频次 OEORI_PHFreq_DR
	.//i PHFreqDr'="" d
	.//.s PHFreqDesc1 = $p(^PHCFR(PHFreqDr),"^",3)
	.//.s PHFreqCode = $p(^PHCFR(PHFreqDr),"^",1)
	.//.s:PHFreqDesc1="ONCE" PHFreqDesc1=""
	.//.s WeekFlag=$P(^PHCFR(PHFreqDr),"^",9)
	.//.i WeekFlag="Y" d
	.//..s OrderFreqWeek=$p($g(^OEORD(orderParref,"I",orderId,"DHC")),"^",55)
	.//..s PHFreqDesc1=PHFreqDesc1_"-"_$TR(OrderFreqWeek,"|","")
	.//..s PHFreqCode=PHFreqCode_" "_$TR(OrderFreqWeek,"|","")
	
	.s PhSpecInstr = $p(str2,"^",8)
	.;s depProcNotes = ""  ;备注 OEORI_DepProcNotes
	.s depProcNotes = PhSpecInstr
	.s depProcNotesIndex = 0
	.f  s depProcNotesIndex=$o(^OEORD(orderParref,"I",orderId,"DEP",depProcNotesIndex)) q:depProcNotesIndex=""  d
	..s depProcNotes = depProcNotes_" "_^OEORD(orderParref,"I",orderId,"DEP",depProcNotesIndex)
	.s TOrderDesc=$p(^ARCIM(+ItmMastDR,$p(ItmMastDR,"||",2),1),"^",2)	;医嘱名称
	.s TOrderDesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",TOrderDesc,langid)
	.s PrescTitle=..GetOrdItemPrescTitle(ItmMastDR,sessionHospId)
	.if (PrescTitle'="") s TOrderDesc="<font color=red>【"_PrescTitle_"】</font>"_TOrderDesc
	
	
	.s ItemCatDR=$p(^ARCIM(+ItmMastDR,$p(ItmMastDR,"||",2),1),"^",10)
	.s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)
	
	.s priorityTip = $case(PriorityCode,"ONE":"取药","OUT":"带药","OM":"自备","OMLSZT":"嘱托",:"")
	.s priorityTip=##class(websys.Translation).Get("doc.surgeryord.hui.csp",priorityTip)
	.s TDuratDR="" 
	.s:str2'="" TDuratDR = $p(str2,"^",6) 
	.s:TDuratDR'="" TDuratDesc1 = $p(^PHCDU(TDuratDR),"^",3)
	.s TDuratDesc1=##class(User.PHCDuration).GetTranByDesc("PHCDUDesc1",TDuratDesc1,langid) 
	.s abnorm=##class(web.DHCDocMainOrderInterface).GetSkinAbnorm(orderParref,orderId)
	.s abnorm = $Case(abnorm,"Y":"(+)","N":"(-)",:"")
    .s TOrderDesc=TOrderDesc_abnorm
    .if ((PriorityCode="ONE")||(PriorityCode="OUT"))&&(OrderType="R") D
	..s orderPackQty=$p($g(^OEORD(orderParref,"I",orderId,9)),"^",4)		;整包装数量 OEORI_QtyPackUOM
	..s ProtocolPackUOMDR=$p($g(^OEORD(orderParref,"I",orderId,"DHC")),"^",13)
	..If ProtocolPackUOMDR>0 D
	...s OrderPackUOM=$p($g(^CT("UOM",ProtocolPackUOMDR)),"^",2)
	...s OrderPackUOM=##class(User.CTUOM).GetTranByDesc("CTUOMDesc",OrderPackUOM,langid)
	...s orderPackQty=##class(DHCDoc.Util.Base).FormateNumber(orderPackQty)
	...s priorityTip = priorityTip_"("_orderPackQty_OrderPackUOM_")"
	..else  if orderPackQty'="" d
	...s ARCIMBillingUOMDr=$P($G(^ARCIM(+ItmMastDR,$p(ItmMastDR,"||",2),8)),"^",14)
	...i ARCIMBillingUOMDr'="" s OrderPackUOM=$P(^CT("UOM",ARCIMBillingUOMDr),"^",2),OrderPackUOM=##class(User.CTUOM).GetTranByDesc("CTUOMDesc",OrderPackUOM,langid),priorityTip = priorityTip_"("_orderPackQty_OrderPackUOM_")"
	..else  d	
	...s DrgformRowid = $p(^ARCIM(+ItmMastDR,$p(ItmMastDR,"||",2),1),"^",12) ;PHC_DrgForm
	...s order2PackQty = ##class(web.DHCDocOrderEntry).CalDose(doseUnitDr,DrgformRowid,doseQty)
	...s bsUOMph = $p(^PHCD(+DrgformRowid,"DF",$p(DrgformRowid,"||",2),2),"^",4)
	...s bsUOMphDesc = ##class(web.DHCDocOrderCommon).GetUOMDesc(bsUOMph)
	...s bsUOMphDesc=##class(User.CTUOM).GetTranByDesc("CTUOMDesc",bsUOMphDesc,langid)
    ...s priorityTip = priorityTip_"("_order2PackQty_bsUOMphDesc_")"
	
	.s OrdPackQtyInfo=##class(web.DHCDocQryOEOrder).GetOrdPackQtyInfo(orderParref_"||"_orderId)
	.s Pqty=$p(OrdPackQtyInfo,"^",1)
	.s PackUOMDesc=$p(OrdPackQtyInfo,"^",2)
	.s PackUOMDesc=##class(User.CTUOM).GetTranByDesc("CTUOMDesc",PackUOMDesc,langid)
	.s billqty=""
	.s:(Pqty'="") billqty=Pqty_PackUOMDesc
	.s ArcPrice=##class(web.DHCDocOrderCommon).GetOEORIPrice(orderParref_"||"_orderId)
	.s ArcPrice=$fn($p(ArcPrice,"^",1),"",4)_##class(websys.Translation).Get("doc.surgeryord.hui.csp","元")
	.s OrderSum=$fn(ArcPrice*Pqty,"",4)_##class(websys.Translation).Get("doc.surgeryord.hui.csp","元")
	.s OEORINotifyClinician = $p($G(^OEORD(orderParref,"I",orderId,11)),"^",55)
	.s OEORINotifyClinician=$case(OEORINotifyClinician,"Y":"<font color=red>"_##class(websys.Translation).Get("doc.surgeryord.hui.csp","急")_"</font>",:"")
	.s TOrderDesc=TOrderDesc_space_doseQty_doseUOM_space_instrDesc1_space_PHFreqDesc1_space_depProcNotes_space_priorityTip_space_TDuratDesc1_space_OEORINotifyClinician
	s OrdItemCallback=##class(web.DHCDocMainOrderInterface).IsCallbackOrder(orderParref,orderId)
	s OrdItemCallback=$case(OrdItemCallback,1:"<font color=red>"_##class(websys.Translation).Get("doc.surgeryord.hui.csp","(退回)")_"</font>",:"")
	s OrdNurseCallback = ##class(web.DHCDocMainOrderInterface).IsNurseCallbackOrder(orderParref,orderId)
	s OrdNurseCallback = $case(+OrdNurseCallback,1:"<font color=red>"_##class(websys.Translation).Get("doc.surgeryord.hui.csp","(护士退回)")_"</font>",:"")
	s ReqPartDesc=##Class(web.DHCAPPInterface).GetExaReqPartDesc(orderParref_"||"_orderId)
	s TOrderDesc=TOrderDesc_space_OrdItemCallback_space_OrdNurseCallback_ReqPartDesc
	s (TDoctor,DoctorUserDr)=""
	if DoctorDr'="" d
	.s TDoctor = $p($g(^CTPCP(DoctorDr,1)),"^",2)
	.Set TDoctor= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",TDoctor,langid)
	.s:TDoctor'="" DoctorUserDr = $o(^SSU("SSUSR",0,"CTPCP",DoctorDr,""))
	s TStDate = ..%ZD($p(str1,"^",9)) //$zd($p(str1,"^",9),3)
	s TStTime = ..%ZT($p(str1,"^",10),2)
	s TNurse = ##class(web.DHCDocMainOrderInterface).GetXOrderNurseName(orderParref,orderId)
	s TStopDate = $p(^OEORD(orderParref,"I",orderId,3),"^",34)
	s:TStopDate'="" TStopDate=..%ZD(TStopDate) //$zd(TStopDate,3)		;XDate
	s:$d(^OEORD(orderParref,"I",orderId,2)) TStopTime = $p(^OEORD(orderParref,"I",orderId,2),"^",15)
	s:TStopTime'="" TStopTime=..%ZT(TStopTime,2) 	;XTime
	s TStopDoctor=""
	s StopDoctorDR = $p(^OEORD(orderParref,"I",orderId,3),"^",29)
	s:+StopDoctorDR>0 TStopDoctor = $p(^CTPCP(StopDoctorDR,1),"^",2)
	Set TStopDoctor= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",TStopDoctor,langid)
	s:+itemStatDr>0 TItemStatDesc = $p(^OEC("OSTAT",itemStatDr),"^",2)
	s TItemStatDesc=##class(User.OECOrderStatus).GetTranByDesc("OSTATDesc",TItemStatDesc,langid)
	;s ordDept = $p(str1,"^",3)
	s ordDept = $p($g(^OEORD(orderParref,"I",orderId,7)),"^",2)
	s TdeptDesc=$S(+ordDept>0:$p(^CTLOC(ordDept),"^",2),1:"")
	s TdeptDesc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",TdeptDesc,langid)
	s TdeptDesc=##class(web.DHCDocOrderCommon).GetLocDesc(ordDept)
	s:str3'="" TRecDepDR = $p(str3,"^",6)
	s:+TRecDepDR>0 TRecDepDesc = $p(^CTLOC(TRecDepDR),"^",2)
	s TRecDepDesc=##class(web.DHCDocOrderCommon).GetLocDesc(TRecDepDR)
	s StopPermission=##class(web.DHCDocMain).CheckStopOrder(orderParref_"||"_orderId,LogonUserID,sessionLocId,LogonGroupID)
	s CancelPermission=##class(web.DHCDocMain).CheckCancelOrder(orderParref_"||"_orderId,LogonUserID,sessionLocId,LogonGroupID)
	s UnusePermission =##class(web.DHCDocMain).CheckUnuseOrder(orderParref_"||"_orderId,LogonUserID,sessionLocId,LogonGroupID)
	s oeorioeoridr = $p($g(^OEORD(orderParref,"I",orderId,11)),"^",39)
	s TStDateHide=TStDate,TStTimeHide=TStTime
	s:+oeorioeoridr>0 TOrderDesc = tab_TOrderDesc,TStDate="",TStTime=""
	//获取医嘱泡芙提示信息
	s PopoverHtml=##class(web.DHCOEOrdItem).GetOrderPopoverInfo(orderParref_"||"_orderId,TOrderDesc,langid)
	s MaterialBarCode=$p($G(^OEORD(orderParref,"I",orderId,"DHC")),"^",14)
	s outitem=$lb(orderParref_"||"_orderId,TItemStatCode,oeorioeoridr,PHFreqCode,TPermission,0,TStDate,TStTime,TOrderDesc,TDoctor,TNurse,TStopDate,TStopTime,TItemStatDesc,TdeptDesc,TRecDepDesc,orderParref_"||"_orderId,StopPermission,CancelPermission,UnusePermission,TBillUom,"",OrderType,TStDateHide,TStTimeHide,billqty,ArcPrice,PopoverHtml,OrderSum,MaterialBarCode) 
	q outitem
}

ClassMethod GetOrdItemPrescTitle(OrderARCIMRowid, sessionHospId As %String) As %String
{
	s OrderViewPoison=##class(web.DHCDocConfig).GetConfigNodeNew2("OrderViewPoison",sessionHospId)
	Q:OrderViewPoison'=1 ""
	s PoisonRowid=##class(web.DHCDocOrderEntry).GetDrgFormPoison(OrderARCIMRowid)
	s poisondesc=$s(PoisonRowid'="":$p($g(^PHCPO(PoisonRowid)),"^",2),1:"")
	if poisondesc["麻" q "毒麻" //"麻醉"
	if poisondesc["毒" q "毒麻" //"毒性"
	if (poisondesc["精")&&(poisondesc["一") q "精一"
	if (poisondesc["精")&&(poisondesc["二") q "精二"
	Q ""
}

}
