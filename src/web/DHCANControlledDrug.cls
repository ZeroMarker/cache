Import SQLUser

Include webimport

IncludeGenerator webimport

Class web.DHCANControlledDrug Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 1060;

/// Creator: YuanLin
/// CreatDate: 2017-12-19
/// Description: 获取病人毒麻药回收登记明细
/// Table：DHC_AN_OPArrange、DHC_AN_Order、DHC_AN_ControlledDrug
/// d ##class(%ResultSet).RunQuery("web.DHCANControlledDrug","GetToxicAnestList","01/01/2017","18/03/2017","","","","","","","")
Query GetToxicAnestList(stdate As %String, enddate As %String, stat As %String, OpRoom As %String, userLocId As %String = "", MedCareNo As %String = "", patWardId As %String = "", LogUserType As %String = "", RegNo As %String = "") As %Query(ROWSPEC = "opdate,comOpRoom,regNo,patName,gender,age,PDVAnumber,diag,DrugDesc,Specification,Unit,Quantity,BatchNo,orderdoctor,usecount,DisposalMeasures,Handler,Reviewer,Recipient,Note,opaId")
{
}

ClassMethod GetToxicAnestListExecute(ByRef qHandle As %Binary, stdate As %String, enddate As %String, stat As %String, OpRoom As %String, userLocId As %String = "", MedCareNo As %String = "", patWardId As %String = "", LogUserType As %String = "", RegNo As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
	i (stdate="")!(enddate="") s sdate=+$H,edate=+$H
	e  s sdate=##Class(web.DHCANOPCom).ConvertToDateH(stdate),edate=##Class(web.DHCANOPCom).ConvertToDateH(enddate)
    s linkLocId=##Class(web.DHCClinicCom).GetLinkLocId(userLocId)
    s userLocIdStr=linkLocId_"^"_userLocId
	s userLocTyp=""
    i userLocId'="" s userLocTyp=$P(^CTLOC(userLocId),"^",13)
    //s HOSPID=%session.Data("LOGON.HOSPID")
    s HOSPID=2
    f date=sdate:1:edate
    {
		s opaId=""
		f  s opaId=$O(^DHCANOPArrange(0,"SDate",date,opaId)) q:opaId=""  d
		.q:$d(^DHCANOPArrange(opaId))<1
		.s opdate="",comOpRoom="",regNo="",patName="",gender="",age="",PDVAnumber="",diag="",DrugDesc="",Specification="",Unit="",Quantity="",BatchNo="",orderdoctor="",usecount="",DisposalMeasures="",Handler="",Reviewer="",Recipient="",Note=""
		.s opdate=$ZD($P(^DHCANOPArrange(opaId),"^",14),4)
		.s oproomdr=$P(^DHCANOPArrange(opaId),"^",20)
		.i oproomdr'="" s comOpRoom=$p($g(^DHCANC("OPRoom",oproomdr)),"^",2)
		.q:(oproomdr'=OpRoom)&(OpRoom'="")
		.s adm=$P(^DHCANOPArrange(opaId),"^",1),admId=adm
		.q:adm=""
		.s chl=$P($P(^DHCANOPArrange(opaId),"^",2),"||",2)
		.s papmiId=$p($g(^PAADM(admId)),"^",1)
		.s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
		.q:(regNo'=RegNo)&(RegNo'="")
		.s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
		.s gender=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
		.s age=##class(web.DHCBillInterface).GetPapmiAge(papmiId,admId)
		.s PDVAnumber=$p($G(^PAPER(papmiId,"ALL")),"^",9)
		.s opaStatus=$P(^DHCANOPArrange(opaId),"^",27)
		.q:opaStatus="S"
		.q:opaStatus="N"
		.q:(opaStatus="")&(userLocTyp'="E")
		.s opaPatStatus=$P(^DHCANOPArrange(opaId),"^",23)
		.q:(stat'="")&(stat'=opaStatus)
		.;s medCareNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)
	    .s paadmtype=$p($g(^PAADM(admId)),"^",2)
	    .s medCareNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(admId,paadmtype,.ErrMsg)
		.q:(medCareNo'=MedCareNo)&(MedCareNo'="")
		.s admLocId=$p($g(^PAADM(adm)),"^",4)
		.q:admLocId=""
		.s appLocId=$p($g(^DHCANOPArrange(opaId)),"^",54)
		.i +appLocId=0 s appLocId=admLocId
		.s HospitalId=$p($G(^CTLOC(appLocId)),"^",22)
		.q:((HospitalId'=HOSPID)&(HospitalId'="")&(HOSPID'=""))
		.s patWardId1=$P($G(^DHCANOPArrange(opaId)),"^",32)
		.q:(patWardId'="")&(patWardId'=patWardId1)
		.s prediag="",diamen=""
		.s subchl=0 f  s subchl=$O(^OR(adm,"ANA",chl,"OP",subchl)) q:(subchl="")  d
		..s predigdrS=$P(^OR(adm,"ANA",chl,"OP",subchl),"^",4)
		..s num=$l(predigdrS,"|")
		..f pi=1:1:num d
			...s predigdr=$p(predigdrS,"|",pi)
			...i predigdr'=""  d
				....s prediag=$P(^MRC("ID",predigdr),"^",2)
			...s $p(diag,",",pi)=$G(prediag)
			...e  d
				....i $g(^OR(adm,"ANA",chl,"TXT",2))'="" d 
				.....s diamen=$p(^OR(adm,"ANA",chl,"TXT",2),"|",pi)
				.....s $p(diag,",",pi)=$G(diamen)
		.;以下为毒麻药业务数据
		.s ANCDRowId=""
		.s ANCDRowId=$O(^DHCANControlledDrug(0,"OPA",opaId,ANCDRowId))
		.i ANCDRowId'="" d
		..s drugId=$li(^DHCANControlledDrug(ANCDRowId),3)
		..f j=1:1:$l(drugId,"~") d
		    ...s SubID=$p($p(drugId,"~",j),"||",1)
	        ...s VerID=$p($p(drugId,"~",j),"||",2)
	        ...q:VerID=""
	        ...s DrugDesc=$p($g(^ARCIM(SubID,VerID,1)),"^",2)
	        ...s Specification=$p(^DHCITMINFO(SubID),"^",27)
	        ...s UnitId=$p($g(^ARCIM(SubID,VerID,8)),"^",14)
	        ...i UnitId'="" s Unit=$p($g(^CT("UOM",UnitId)),"^",2)
		..s BatchNo=$li(^DHCANControlledDrug(ANCDRowId),4)
		..s Handler=$li(^DHCANControlledDrug(ANCDRowId),5)
		..s DisposalMeasures=$li(^DHCANControlledDrug(ANCDRowId),9)
		..s Recipient=$li(^DHCANControlledDrug(ANCDRowId),10)
		..s Reviewer=$li(^DHCANControlledDrug(ANCDRowId),13)
		..s usecount=$li(^DHCANControlledDrug(ANCDRowId),16)
		..s Quantity=$li(^DHCANControlledDrug(ANCDRowId),17)
		..s Note=$li(^DHCANControlledDrug(ANCDRowId),18)
		..s orderdoctor=$li(^DHCANControlledDrug(ANCDRowId),19)
		.do OutRow
}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutRow
	set Data=$lb(opdate,comOpRoom,regNo,patName,gender,age,PDVAnumber,diag,DrugDesc,Specification,Unit,Quantity,BatchNo,orderdoctor,usecount,DisposalMeasures,Handler,Reviewer,Recipient,Note,opaId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetToxicAnestListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetToxicAnestListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetToxicAnestListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetToxicAnestListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCANControlledDrug","GetAnestHISUIList","01/01/2018","18/01/2018","","","42","","","","")
/// 21081026+dyl+改造后
Query GetAnestHISUIList(stdate As %String, enddate As %String, stat As %String, OpRoom As %String, userLocId As %String = "", MedCareNo As %String = "", patWardId As %String = "", LogUserType As %String = "", RegNo As %String = "", OpaId As %String = "") As %Query(ROWSPEC = "opdate,comOpRoom,regNo,patName,gender,age,PDVAnumber,diag,DrugDesc,Specification,Unit,Quantity,BatchNo,orderdoctor,usecount,DisposalMeasures,Handler,Reviewer,Recipient,Note,opaId,ANCDRowId")
{
}

ClassMethod GetAnestHISUIListExecute(ByRef qHandle As %Binary, stdate As %String, enddate As %String, stat As %String, OpRoom As %String, userLocId As %String = "", MedCareNo As %String = "", patWardId As %String = "", LogUserType As %String = "", RegNo As %String = "", OpaId As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
	i (stdate="")!(enddate="") s sdate=+$H,edate=+$H
	e  s sdate=##Class(web.DHCANOPCom).ConvertToDateH(stdate),edate=##Class(web.DHCANOPCom).ConvertToDateH(enddate)
    s linkLocId=##Class(web.DHCClinicCom).GetLinkLocId(userLocId)
    s userLocIdStr=linkLocId_"^"_userLocId
	s userLocTyp=""
    i userLocId'="" s userLocTyp=$P(^CTLOC(userLocId),"^",13)
    //s HOSPID=%session.Data("LOGON.HOSPID")
    s HOSPID=2
    f date=sdate:1:edate
    {
		s opaId=""
		f  s opaId=$O(^DHCANOPArrange(0,"SDate",date,opaId)) q:opaId=""  d
		.q:$d(^DHCANOPArrange(opaId))<1
		.q:(OpaId'="")&(OpaId'=opaId)
		.s opdate="",comOpRoom="",regNo="",patName="",gender="",age="",PDVAnumber="",diag="",DrugDesc="",Specification="",Unit="",Quantity="",BatchNo="",orderdoctor="",usecount="",DisposalMeasures="",Handler="",Reviewer="",Recipient="",Note=""
		.;s opdate=$ZD($P(^DHCANOPArrange(opaId),"^",14),4)
		.s opdate=##Class(web.DHCANOPCom).ConvertToDate($P(^DHCANOPArrange(opaId),"^",14))
		.s oproomdr=$P(^DHCANOPArrange(opaId),"^",20)
		.i oproomdr'="" s comOpRoom=$p($g(^DHCANC("OPRoom",oproomdr)),"^",2)
		.q:(oproomdr'=OpRoom)&(OpRoom'="")
		.s adm=$P(^DHCANOPArrange(opaId),"^",1),admId=adm
		.q:adm=""
		.s chl=$P($P(^DHCANOPArrange(opaId),"^",2),"||",2)
		.s papmiId=$p($g(^PAADM(admId)),"^",1)
		.s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
		.q:(regNo'=RegNo)&(RegNo'="")
		.s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
		.s gender=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
		.s age=##class(web.DHCBillInterface).GetPapmiAge(papmiId,admId)
		.s PDVAnumber=$p($G(^PAPER(papmiId,"ALL")),"^",9)
		.s opaStatus=$P(^DHCANOPArrange(opaId),"^",27)
		.q:opaStatus="S"
		.q:opaStatus="N"
		.q:(opaStatus="")&(userLocTyp'="E")
		.s opaPatStatus=$P(^DHCANOPArrange(opaId),"^",23)
		.q:(stat'="")&(stat'=opaStatus)
		.;s medCareNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)
	    .s paadmtype=$p($g(^PAADM(admId)),"^",2)
	    .s medCareNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(admId,paadmtype,.ErrMsg)
		.q:(medCareNo'=MedCareNo)&(MedCareNo'="")
		.s admLocId=$p($g(^PAADM(adm)),"^",4)
		.q:admLocId=""
		.s appLocId=$p($g(^DHCANOPArrange(opaId)),"^",54)
		.i +appLocId=0 s appLocId=admLocId
		.s HospitalId=$p($G(^CTLOC(appLocId)),"^",22)
		.q:((HospitalId'=HOSPID)&(HospitalId'="")&(HOSPID'=""))
		.s patWardId1=$P($G(^DHCANOPArrange(opaId)),"^",32)
		.q:(patWardId'="")&(patWardId'=patWardId1)
		.s prediag="",diamen=""
		.s subchl=0 f  s subchl=$O(^OR(adm,"ANA",chl,"OP",subchl)) q:(subchl="")  d
		..s predigdrS=$P(^OR(adm,"ANA",chl,"OP",subchl),"^",4)
		..s num=$l(predigdrS,"|")
		..f pi=1:1:num d
			...s predigdr=$p(predigdrS,"|",pi)
			...i predigdr'=""  d
				....s prediag=$P(^MRC("ID",predigdr),"^",2)
			...s $p(diag,",",pi)=$G(prediag)
			...e  d
				....i $g(^OR(adm,"ANA",chl,"TXT",2))'="" d 
				.....s diamen=$p(^OR(adm,"ANA",chl,"TXT",2),"|",pi)
				.....s $p(diag,",",pi)=$G(diamen)
		.;以下为毒麻药业务数据
		.s drugInfoStr="",flag=0
		.s ANCDRowId=""
		.f  s ANCDRowId=$O(^DHCANControlledDrug(0,"OPA",opaId,ANCDRowId)) q:ANCDRowId=""  d
			..;b	;in
			..q:$d(^DHCANControlledDrug(ANCDRowId))<1
			..s drugId=$li(^DHCANControlledDrug(ANCDRowId),3)
			..q:drugId=""
			..s SubID=$p(drugId,"||",1)
		    ..s VerID=$p(drugId,"||",2)
		    ..q:VerID=""
		    ..;s DrugDesc=$p($g(^ARCIM(SubID,VerID,1)),"^",2)
			..s DrugDesc=$li(^DHCANControlledDrug(ANCDRowId),22)
		    ..s Specification=$p($g(^DHCITMINFO(SubID)),"^",27)
		    ..;s UnitId=$p($g(^ARCIM(SubID,VerID,8)),"^",14)
		    ..;i UnitId'="" s Unit=$p($g(^CT("UOM",UnitId)),"^",2)
			..s BatchNo=$li(^DHCANControlledDrug(ANCDRowId),4)
			..s Handler=""
			..s HandlerId=$li($g(^DHCANControlledDrug(ANCDRowId)),5)
			..i HandlerId'="" s Handler=$p($g(^CTPCP(HandlerId,1)),"^",2)
			..s DisposalMeasures=$li(^DHCANControlledDrug(ANCDRowId),9)
			..s Recipient=""
			..s RecipientId=$li($g(^DHCANControlledDrug(ANCDRowId)),10)
			..i RecipientId'="" s Recipient=$p($g(^CTPCP(RecipientId,1)),"^",2)
			..s Reviewer=""
			..s ReviewerId=$li($g(^DHCANControlledDrug(ANCDRowId)),13)
			..i ReviewerId'="" s Reviewer=$p($g(^CTPCP(ReviewerId,1)),"^",2)
			..s usecount=$li(^DHCANControlledDrug(ANCDRowId),16)
			..s Quantity=$li(^DHCANControlledDrug(ANCDRowId),18)
			..s UnitId=$li(^DHCANControlledDrug(ANCDRowId),19)
			..i UnitId'="" s Unit=$p($g(^CT("UOM",+UnitId)),"^",2)
			..s Note=$li(^DHCANControlledDrug(ANCDRowId),20)
			..s orderdoctor=""
			..s orderdoctorId=$li($g(^DHCANControlledDrug(ANCDRowId)),21)
			..i orderdoctorId'="" s orderdoctor=$p($g(^SSU("SSUSR",orderdoctorId)),"^",2)
			..s flag=1
			..;b	;end
			..do OutRowHISUI
		.i flag=0 do OutRowHISUI
}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutRowHISUI
	set Data=$lb(opdate,comOpRoom,regNo,patName,gender,age,PDVAnumber,diag,DrugDesc,Specification,Unit,Quantity,BatchNo,orderdoctor,usecount,DisposalMeasures,Handler,Reviewer,Recipient,Note,opaId,ANCDRowId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetAnestHISUIListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAnestHISUIListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetAnestHISUIListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAnestHISUIListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Creator: YuanLin
/// CreatDate: 2017-12-19
/// Description: 获取病人麻醉单上所用药品的明细以及规格、单位、操作人信息
/// Table：DHC_AN_Order
/// Input：opaId
/// Output：药品Id、药品名称、规格、单位、操作人
/// d ##class(%ResultSet).RunQuery("web.DHCANControlledDrug","FindDrugList","140")
Query FindDrugList(opaId As %String) As %Query(ROWSPEC = "opaId,opsId,drugId,drugDesc,DoseQty,DoseUnit,CreatUserId")
{
}

ClassMethod FindDrugListExecute(ByRef qHandle As %Binary, opaId As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	s opsId="",ArcimId="",Description="",DoseQty="",DoseUnit="",CreatUserId=""
 	if (opaId="")
	{
		s qHandle=$lb(0,repid,0)
		q $$$OK	
	}
	s opsId=$o(^CIS.AN.OperScheduleI("Ext"," "_opaId,opsId))
	s RecordSheerId="" f  s RecordSheerId=$o(^CIS.AN.RecordSheetI("IOPS",opsId,RecordSheerId)) q:RecordSheerId=""  d
	.s DataModuleId=$li(^CIS.AN.RecordSheetD(RecordSheerId),2)
	.q:DataModuleId'=27  //只取麻醉单数据
	.s ParaItemId="" f  s ParaItemId=$o(^CIS.AN.ParaItemI("ISheet",RecordSheerId,ParaItemId)) q:ParaItemId=""  d
	..s AnaDataId="" f  s AnaDataId=$o(^CIS.AN.AnaDataI("IParaItem",ParaItemId,AnaDataId)) q:AnaDataId=""  d
	...s EditFlag=$li(^CIS.AN.AnaDataD(AnaDataId),7)
	...s CreatUserId=$li(^CIS.AN.AnaDataD(AnaDataId),9)
	...q:EditFlag="D"
	...s DrugDataId=""
	...s DrugDataId=$o(^CIS.AN.DrugDataI("IAnaData",AnaDataId,DrugDataId))
	...s DoseQty=$li(^CIS.AN.DrugDataD(DrugDataId),2)
	...s DoseUnit=$li(^CIS.AN.DrugDataD(DrugDataId),3)
	...s Description=$li(^CIS.AN.DrugDataD(DrugDataId),11)
	...s ArcimId=$li(^CIS.AN.DrugDataD(DrugDataId),14)
	...s ^TMPAN("App",$j,Description)=$lb(opaId,opsId,ArcimId,Description,DoseQty,DoseUnit,CreatUserId)
	s Description="" f  s Description=$o(^TMPAN("App",$j,Description)) q:Description=""  d
	.do OutRow1
	k ^TMPAN("App",$j)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutRow1
    Set ^CacheTemp(repid,ind)=^TMPAN("App",$j,Description)
 	Set ind=ind+1
	quit
}

ClassMethod FindDrugListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindDrugListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindDrugListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindDrugListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 20181026+dyl
/// d ##class(%ResultSet).RunQuery("web.DHCANControlledDrug","FindDrugInfoList",258)
Query FindDrugInfoList(opaId As %String) As %Query(ROWSPEC = "ANCDRowId,drugId,drugDesc,Specification,BatchNo,Handler,ReChecker,Recipient,DisposalMeasures,usecount,UomId,Uom,Quantity,UnitId,Unit,Note,OrderDoc,HandlerId,RecipientId,ReCheckId,orderDocId")
{
}

ClassMethod FindDrugInfoListExecute(ByRef qHandle As %Binary, opaId As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
	s ANCDRowId=""
	f  s ANCDRowId=$O(^DHCANControlledDrug(0,"OPA",opaId,ANCDRowId)) q:ANCDRowId=""  d
		.q:$d(^DHCANControlledDrug(ANCDRowId))<1
		.s drugId=$li(^DHCANControlledDrug(ANCDRowId),3)
		.i drugId'="" d
		    ..s SubID=$p(drugId,"||",1)
	        ..s VerID=$p(drugId,"||",2)
	        ..q:VerID=""
	        ..;s drugDesc=$p($g(^ARCIM(SubID,VerID,1)),"^",2)
			..s drugDesc=$li(^DHCANControlledDrug(ANCDRowId),22)
	        ..s Specification=$p($g(^DHCITMINFO(SubID)),"^",27)
	        ..//s Unit=""
	        ..//s UnitId=$p($g(^ARCIM(SubID,VerID,8)),"^",14)
	        ..//i UnitId'="" s Unit=$p($g(^CT("UOM",UnitId)),"^",2)
			..s BatchNo=$li(^DHCANControlledDrug(ANCDRowId),4)
			..s Handler="",Recipient="",ReChecker="",orderdoctor=""
			..s HandlerId=$li(^DHCANControlledDrug(ANCDRowId),5)
			..i HandlerId'="" s Handler=$p($g(^CTPCP(HandlerId,1)),"^",2)
			..s RecipientId=$li(^DHCANControlledDrug(ANCDRowId),10)
			..i RecipientId'="" s Recipient=$p($g(^CTPCP(RecipientId,1)),"^",2)
			..s ReCheckId=$li(^DHCANControlledDrug(ANCDRowId),13)
			..i ReCheckId'="" s ReChecker=$p($g(^CTPCP(ReCheckId,1)),"^",2)
			..s usecount=$li(^DHCANControlledDrug(ANCDRowId),16)
			..s UomId=$li(^DHCANControlledDrug(ANCDRowId),17)
			..s Uom=$p($g(^CT("UOM",+UomId)),"^",2)
			..s Quantity=$li(^DHCANControlledDrug(ANCDRowId),18)
			..s UnitId=$li(^DHCANControlledDrug(ANCDRowId),19)
			..s Unit=$p($g(^CT("UOM",+UnitId)),"^",2)
			..b ;01
			..s Note=$li(^DHCANControlledDrug(ANCDRowId),20)
			..s orderdocId=$li(^DHCANControlledDrug(ANCDRowId),21)
			..i orderdocId'="" s orderdoctor=$p($g(^SSU("SSUSR",orderdocId)),"^",2)
			..s DisposalMeasures=$li(^DHCANControlledDrug(ANCDRowId),9)
			..do OutRowInfo
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutRowInfo
	set Data=$lb(ANCDRowId,drugId,drugDesc,Specification,BatchNo,Handler,ReChecker,Recipient,DisposalMeasures,usecount,UomId,Uom,Quantity,UnitId,Unit,Note,orderdoctor,HandlerId,RecipientId,ReCheckId,orderdocId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindDrugInfoListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindDrugInfoListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindDrugInfoListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindDrugInfoListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Creator: YuanLin
/// CreatDate: 2017-12-20
/// Description: 更新病人残余药品信息、数量、批号、用药量、残余药液处置措施、备注信息
/// Table：DHC_AN_ControlledDrug
/// Input：opaId、药品医嘱Id、数量、批号、用药量、残余药液处置措施、备注信息
/// Output：0:成功 其余:失败
/// d ##class(web.DHCANControlledDrug).UpdateDrugList(399,"1064||1","","","233","","")
ClassMethod UpdateDrugList(opaId As %String, drugId As %String, Quantity As %String, BatchNo As %String, usecount As %String, DisposalMeasures As %String, Note As %String, OrderDoc As %String) As %String
{
	q:opaId="" "更新失败!"
	s adm=$p($g(^DHCANOPArrange(opaId)),"^",1)
	&sql(select * into :PLIST() from SQLUSER.DHC_AN_ControlledDrug where ANCD_OPA_Dr=:opaId)
	i SQLCODE=0 d
	.s PLIST(4)=drugId
    .s PLIST(5)=BatchNo
    .s PLIST(10)=DisposalMeasures
    .s PLIST(17)=usecount
    .s PLIST(18)=Quantity
    .s PLIST(19)=Note
    .s PLIST(20)=OrderDoc
    .&sql(update SQLUSER.DHC_AN_ControlledDrug Values :PLIST() where ANCD_OPA_Dr=:opaId)
    .s ret=SQLCODE
    e  d
	.s PLIST(2)=adm
    .s PLIST(3)=opaId
    .s PLIST(4)=drugId
    .s PLIST(5)=BatchNo
    .s PLIST(10)=DisposalMeasures
    .s PLIST(17)=usecount
    .s PLIST(18)=Quantity
    .s PLIST(19)=Note
    .s PLIST(20)=OrderDoc
    .&sql(INSERT INTO SQLUSER.DHC_AN_ControlledDrug Values :PLIST())
    .s ret=SQLCODE
    q ret
}

/// Creator: YuanLin
/// CreatDate: 2017-12-20
/// Description: 更新毒麻药回收管理操作人信息,包括执行人(E)、处置\接收人(D)、复核人(C)
/// Table：DHC_AN_ControlledDrug
/// Input：opaId、用户Id、用户类型
/// Output：0:成功 其余:失败
/// d ##class(web.DHCANControlledDrug).UpdateDrugList(399,"1064","E")
ClassMethod UpdateNurseList(opaId As %String, ctcpId As %String, nurseType As %String) As %String
{
	q:opaId="" "更新失败!"
	s adm=$p($g(^DHCANOPArrange(opaId)),"^",1)
	&sql(select * into :PLIST() from SQLUSER.DHC_AN_ControlledDrug where ANCD_OPA_Dr=:opaId)
	i SQLCODE=0 d
	.i nurseType="E" d
    ..s PLIST(6)=ctcpId
    ..s PLIST(7)=$p($h,",",1)
    ..s PLIST(8)=$p($h,",",2)
    .i nurseType="D" d
    ..s PLIST(11)=ctcpId
    ..s PLIST(12)=$p($h,",",1)
    ..s PLIST(13)=$p($h,",",2)
    .i nurseType="C" d
    ..s PLIST(14)=ctcpId
    ..s PLIST(15)=$p($h,",",1)
    ..s PLIST(16)=$p($h,",",2)
    .&sql(update SQLUSER.DHC_AN_ControlledDrug Values :PLIST() where ANCD_OPA_Dr=:opaId)
    .s ret=SQLCODE
	e  d
	.s PLIST(2)=adm
    .s PLIST(3)=opaId
    .i nurseType="E" d
    ..s PLIST(6)=ctcpId
    ..s PLIST(7)=$p($h,",",1)
    ..s PLIST(8)=$p($h,",",2)
    .i nurseType="D" d
    ..s PLIST(11)=ctcpId
    ..s PLIST(12)=$p($h,",",1)
    ..s PLIST(13)=$p($h,",",2)
    .i nurseType="C" d
    ..s PLIST(14)=ctcpId
    ..s PLIST(15)=$p($h,",",1)
    ..s PLIST(16)=$p($h,",",2)
    .&sql(INSERT INTO SQLUSER.DHC_AN_ControlledDrug Values :PLIST())
    .s ret=SQLCODE
    q ret
}

/// 20181026+dyl
/// w ##class(web.DHCANControlledDrug).UpdateDrugInfoList(37,"#1064||1#122561#1#10mg###3#4#3#4634")
ClassMethod UpdateDrugInfoList(opaId As %String, drugInfoStr As %String) As %String
{
	s ret=""
	q:opaId="" "更新失败!"
	s adm=$p($g(^DHCANOPArrange(opaId)),"^",1)
	i drugInfoStr="" d
	.&sql(select * into :PLIST() from SQLUSER.DHC_AN_ControlledDrug where ANCD_OPA_Dr=:opaId)
	.i SQLCODE=0 d
		..b ;00
		..&sql(delete from SQLUSER.DHC_AN_ControlledDrug where ANCD_OPA_Dr=:opaId)
		..s ret=SQLCODE
    b ;01
	//drugInfoStr=ANCDRowId+"|"+drugId+"|"+BatchNo+"|"+Quantity+"|"+usecount+"|"DisposalMeasures+"|"+Note+"|"+HandlerId+"|"+ReCheckId+"|"+RecipientId;
	s dlength=$l(drugInfoStr,"^")
	f dl=1:1:dlength d
		.s drugInfo=$p(drugInfoStr,"^",dl)
		.q:drugInfo=""
		.s ANCDRowId=$p(drugInfo,"#",1)
		.s drugId=$p(drugInfo,"#",2)
		.s BatchNo=$p(drugInfo,"#",3)
		.s Quantity=$p(drugInfo,"#",4)
		.s UnitId=$p(drugInfo,"#",5)
		.s usecount=$p(drugInfo,"#",6)
		.s UomId=$p(drugInfo,"#",7)
		.s DisposalMeasures=$p(drugInfo,"#",8)
		.s Note=$p(drugInfo,"#",9)
		.s HandlerId=$p(drugInfo,"#",10)
		.s ReCheckId=$p(drugInfo,"#",11)
		.s RecipientId=$p(drugInfo,"#",12)
		.s ordDocId=$p(drugInfo,"#",13)
		.s drugDesc=$p(drugInfo,"#",14)
		.i ANCDRowId'="" d
			..&sql(select * into :PLIST() from SQLUSER.DHC_AN_ControlledDrug where ANCD_OPA_Dr=:opaId and ID=:ANCDRowId)
			..i SQLCODE=0 d
				...k PLIST
				...s PLIST(4)=drugId
			    ...s PLIST(5)=BatchNo
			    ...s PLIST(10)=DisposalMeasures
			    ...s PLIST(17)=usecount
			    ...s PLIST(18)=UomId
			    ...s PLIST(19)=Quantity
			    ...s PLIST(20)=UnitId
			    ...s PLIST(21)=Note
			    ...s PLIST(22)=ordDocId
			    ...s PLIST(23)=drugDesc
			    ...i HandlerId'="" d 
				    ....s PLIST(6)=HandlerId
			    	....s PLIST(7)=$p($h,",",1)
			    	....s PLIST(8)=$p($h,",",2)
			    ...e  s PLIST(6)="",PLIST(7)="",PLIST(8)=""
		    	...i RecipientId'="" d
		    		....s PLIST(11)=RecipientId
		    		....s PLIST(12)=$p($h,",",1)
		    		....s PLIST(13)=$p($h,",",2)
		    	...e  s PLIST(11)="",PLIST(12)="",PLIST(13)=""
		    	...i ReCheckId'="" d
			    	....s PLIST(14)=ReCheckId
			    	....s PLIST(15)=$p($h,",",1)
			    	....s PLIST(16)=$p($h,",",2)
			    ...e  s PLIST(14)="",PLIST(15)="",PLIST(16)=""
			    ...&sql(update SQLUSER.DHC_AN_ControlledDrug Values :PLIST() where ANCD_OPA_Dr=:opaId and ID=:ANCDRowId)
			    ...s ret=SQLCODE
  	 .e  d
  	 ..k PLIST
		..s PLIST(2)=adm
	    ..s PLIST(3)=opaId
	    ..s PLIST(4)=drugId
	    ..s PLIST(5)=BatchNo
	    ..s PLIST(10)=DisposalMeasures
	    ..s PLIST(17)=usecount
	    ..s PLIST(18)=UomId
		..s PLIST(19)=Quantity
		..s PLIST(20)=UnitId
		..s PLIST(21)=Note
		..s PLIST(22)=ordDocId
		..s PLIST(23)=drugDesc
	    ..i HandlerId'="" d
		    ...s PLIST(6)=HandlerId
		    ...s PLIST(7)=$p($h,",",1)
		    ...s PLIST(8)=$p($h,",",2)
	    ..e  s PLIST(6)="",PLIST(7)="",PLIST(8)=""
	    ..i RecipientId'="" d
	    	...s PLIST(11)=RecipientId
		    ...s PLIST(12)=$p($h,",",1)
		    ...s PLIST(13)=$p($h,",",2)
	    ..e  s PLIST(11)="",PLIST(12)="",PLIST(13)=""
	    ..i ReCheckId'="" d
		    ...s PLIST(14)=ReCheckId
		    ...s PLIST(15)=$p($h,",",1)
		    ...s PLIST(16)=$p($h,",",2)
		..e  s PLIST(14)="",PLIST(15)="",PLIST(16)=""
	    ..&sql(INSERT INTO SQLUSER.DHC_AN_ControlledDrug Values :PLIST())
	    ..b
	    ..s ret=SQLCODE
    q ret
}

}
