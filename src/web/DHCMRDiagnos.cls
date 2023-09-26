Class web.DHCMRDiagnos Extends DHCDoc.Util.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod AddLocDiagones(ICDCode As %String, LogDepRowid As %String, UserRowid)
{
 ;s UserRowid=%session.Data("LOGON.USERID") 
 s AllowUserDiagnos=##Class(web.DHCDocConfig).GetConfigNode1("AllowUserDiagnos",UserRowid)
 Q:(LogDepRowid="")&(UserRowid="")!(ICDCode="") ""

 s MaxLocDia=""
 s LocDia=0
 s maxsortid=0

 if AllowUserDiagnos'="1" {
	  &SQL(select Count(*) into :find from SQLUser.DHC_LocDiagnose where LocDia_CTLoc_DR=:LogDepRowid and LocDia_MRCICD_DR=:ICDCode)
	  if find=0 {
	  	  //&SQL(select max(LocDia_Rowid) into :MaxLocDia from SQLUser.DHC_LocDiagnose)
		  f  s LocDia=$o(^DHCLocDiagnoseI("Location",LogDepRowid,LocDia)) q:LocDia=""  d
		  .s MRCICD=$p(^DHCLocDiagnose(LocDia),"^",2)
		  .s SortId=$p(^DHCLocDiagnose(LocDia),"^",3)
		  .i SortId>maxsortid  s maxsortid=SortId
		  if (maxsortid=0)||(maxsortid="") s maxsortid=""
		  e  s maxsortid=maxsortid+1 
		  &SQL(insert into SQLUser.DHC_LocDiagnose(LocDia_MRCICD_DR,LocDia_CTLoc_DR,LocDia_Sort) Values (:ICDCode,:LogDepRowid,:maxsortid))
	  }
 }else{
	  &SQL(select Count(*) into :find from SQLUser.DHC_LocDiagnose where LocDia_User_DR=:UserRowid and LocDia_MRCICD_DR=:ICDCode)
	  if find=0 {
		  &SQL(select max(LocDia_Sort) into :maxsortid from SQLUser.DHC_LocDiagnose where LocDia_User_DR=:UserRowid)
		  if (maxsortid=0)||(maxsortid="") s maxsortid=""
		  e  s maxsortid=maxsortid+1
		  &SQL(insert into SQLUser.DHC_LocDiagnose(LocDia_MRCICD_DR,LocDia_Sort,LocDia_User_DR) Values (:ICDCode,:maxsortid,:UserRowid))
	  }
 }
 Q:find>0 -1
 q SQLCODE
}

// w ##class(web.DHCMRDiagnos).CheckDelete("4070||2")

ClassMethod CheckDelete(MRDiagnosRowidStr As %String, UserRowid As %String = "", LocRowid As %String = "") As %String
{
	n (MRDiagnosRowidStr,UserRowid,LocRowid,%session)
	s MRDiagnosRowid=$p(MRDiagnosRowidStr,"^",1)
	s mradmrowid=$p(MRDiagnosRowid,"||",1)
	Q:mradmrowid="" "未选择任何诊断"
	s adm=$p($g(^MR(mradmrowid,"PRO",1)),"^",9)
	s DDCPrintFlag=##class(web.DHCDocDiagnosCertificate).CheckDiagnosCertificatePrint(adm,MRDiagnosRowidStr)
	Q:DDCPrintFlag="Y" "存在已打印的诊断证明书记录！"
	if $D(%session){
		s:UserRowid="" UserRowid=%session.Data("LOGON.USERID")
		s:LocRowid="" LocRowid=%session.Data("LOGON.CTLOCID")
	}
	s VisitStatus=$P($g(^PAADM(adm)),"^",20)
	s EpisodeType=$P($G(^PAADM(adm)),"^",2)
	s AdmHospitalId=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(adm)
	if (EpisodeType="I"){
		Q:(VisitStatus="D") "患者已出院"
		Q:(VisitStatus="C") "患者已退院"
		s HaveMidDischarged=##class(web.DHCDocOrderCommon).GetIsMidDischarged(adm)
		s CurrentDischargeStatus=##class(web.DHCDischargeHistory).GetCurrentDischargeStatus(adm)
		Q:(HaveMidDischarged="1")&&(CurrentDischargeStatus'="B") "患者已下出院医嘱"
	}else{
		if (EpisodeType="E"){
			;1:当前状态为留观,2:曾经留观但当前非留观,-1:非留观
			s GetStayStatusFlag=##class(web.DHCADMVisitStat).GetStayStatus(adm)
			i (" 1 2 "[(" "_GetStayStatusFlag_" "))&&(VisitStatus="D") {
				Q "患者已经出观"
			}
		}
	}
	;常规设置-允许删除入院登记诊断
	s AllowDelRegDiag=+..%GetConfig("AllowDelRegDiag",AdmHospitalId)
	;只允许删除本人所开诊断
	s DiagDelLimitFlag=$CASE(EpisodeType,"I":+..%GetConfig("IPDiagDelLimit",AdmHospitalId),:+..%GetConfig("OPDiagDelLimit",AdmHospitalId))
	s Ret=""
	;待删除诊断列表
	for i=1:1:$L(MRDiagnosRowidStr,"^"){
		s DiagRowid=$P(MRDiagnosRowidStr,"^",i)
		continue:DiagRowid=""
		if 'AllowDelRegDiag&&##class(DHCDoc.Diagnos.Common).IsInHospRegDiag(DiagRowid){
			s Ret="不允许删除入院登记诊断!"
			Q
		}
		s DocDr=$P($G(^MR(+DiagRowid,"DIA",$P(DiagRowid,"||",2))),"^",4)
		s DocUserId=$O(^SSU("SSUSR",0,"CTPCP",+DocDr,0))
		if DiagDelLimitFlag&&(DocUserId'=UserRowid){
			s Ret="只允许删除本人所开诊断!"
			Q
		}
		s MainDiagnosRowid=$P($G(^MR(mradmrowid,"DIA",$P(DiagRowid,"||",2))),"^",15)
		if MainDiagnosRowid'=""{
			s DelDiagList(MainDiagnosRowid,DiagRowid)=1
		}else{
			s DelDiagList(DiagRowid)=1
		}
	}
	Q:Ret'="" Ret
	;中医诊断必须伴随证型(不准删除后只留下中医诊断)
	s CNDiagWithSyndrome=..%GetConfig("CNDiagWithSyndrome",AdmHospitalId)
	if CNDiagWithSyndrome=1{
		s Find=0
		s MainDiagnosRowid="" for{
			s MainDiagnosRowid=$O(DelDiagList(MainDiagnosRowid)) Q:MainDiagnosRowid=""
			continue:$G(DelDiagList(MainDiagnosRowid))=1
			s ExistNotDelChild=0
			s DiagSub=0 for{
				s DiagSub=$O(^MR(mradmrowid,"DIA",0,"Link",MainDiagnosRowid,DiagSub)) Q:DiagSub=""
				if '$D(DelDiagList(MainDiagnosRowid,mradmrowid_"||"_DiagSub)){
					s ExistNotDelChild=1
					Q
				}
			}
			if 'ExistNotDelChild{
				s Find=1
				Q
			}
		}
		Q:Find "中医诊断必须伴随证型,不能删除所有证型"
	}
	;所有诊断列表与剩余诊断列表
	s MRDIAChildsub=0 for{
		s MRDIAChildsub=$O(^MR(mradmrowid,"DIA",MRDIAChildsub)) Q:MRDIAChildsub=""
		s DiagRowid=mradmrowid_"||"_MRDIAChildsub
		s MainDiagnosRowid=$P($G(^MR(mradmrowid,"DIA",MRDIAChildsub)),"^",15)
		if MainDiagnosRowid'=""{
			s AlllDiagList(MainDiagnosRowid,DiagRowid)=1
			if ($G(DelDiagList(MainDiagnosRowid,DiagRowid))'=1)&&($G(DelDiagList(MainDiagnosRowid))'=1){
				s LeftDiagList(MainDiagnosRowid,DiagRowid)=1
			}
		}else{
			s AlllDiagList(DiagRowid)=1
			if $G(DelDiagList(DiagRowid))'=1{
				s LeftDiagList(DiagRowid)=1
			}else{
				k LeftDiagList(DiagRowid)
			}
		}
	}
	Q:(EpisodeType'="I")&&'$D(LeftDiagList)&&(..CheckHaveOtherOrd(adm)'="") "最少须保留一条诊断，如需删除，请先停止医嘱！"

	//关联有效处方诊断不能删除
	s PrescQueID=0 for{
		s PrescQueID=$O(^PAQUE1(0,"QUE1_PAADM_DR",adm,PrescQueID)) Q:PrescQueID=""
		s PrescNo=$P(^PAQUE1(PrescQueID),"^",14)
		continue:'##class(web.UDHCPrescript).IsValidPrescNo(PrescNo)
		s PrescDiag=##class(web.DHCDocDiagLinkToPrse).getDia(PrescNo)
		s PrescDiag=$REPLACE(PrescDiag,"$","^")
		if $$ContainStr(MRDiagnosRowidStr,PrescDiag){
			s Ret="有处方关联删除诊断，如需删除，请先停止医嘱！"
			Q
		}
	}
	Q:Ret'="" Ret
	//关联检查申请单诊断
	s arRepID="" for  {
		s arRepID=$o(^DHCAPREP(0,"ADM",adm,arRepID)) Q:arRepID="" 
		s repStat=##Class(web.DHCAPPExaReportQuery).GetExaReqNoStat(arRepID)
		continue:repStat'=1
		s mPatDiags=$p(^DHCAPREP(arRepID),"^",25)
		if $$ContainStr(MRDiagnosRowidStr,mPatDiags){
			s Ret="有关联检查申请的一条诊断，如需删除，请先停止医嘱！"
			Q
		}
	}
	Q:Ret'="" Ret
	Q ""
ContainStr(str1,str2)
	n (str1,str2)
	s Find=0
	s str1="^"_str1_"^"
	for i=1:1:$L(str2,"^"){
		s val=$P(str2,"^",i)
		continue:val=""
		if str1[("^"_str2_"^"){
			s Find=1
			Q
		}
	}
	Q Find
}

ClassMethod CheckHaveOtherOrd(adm) As %String
{
	s OrderRowId=$o(^OEORD(0,"Adm",adm,""))
	s PatientID=$P(^PAADM(adm),"^",1)
	
	s CESFlag=##Class(DHCDoc.Interface.StandAlone.Service).IsCESAdm(adm)
	s RegFeeID=$O(^User.DHCRegistrationFeeI("ADM",adm,0))
 	s AdmReason=$P(^PAADM(adm,1),"^",7)
	s RegFeeRBASDr="",RegfeeTimeRangeDr="",INVOrderItems="",DepRefArcimStr=""
	if RegFeeID'="" {
		s RegFeeRBASDr=$List(^User.DHCRegistrationFeeD(RegFeeID),18)
		s RegfeeTimeRangeDr=$List(^User.DHCRegistrationFeeD(RegFeeID),21)
		s InvoiceId=$List(^User.DHCRegistrationFeeD(RegFeeID),11)
 		s INVOrderItems=##class(web.DHCOPAdmReg).GetRegINVOrderItem(InvoiceId,"",1)
		s SerIdStr=##class(web.DHCOPAdmReg).GetScheduleService(RegFeeRBASDr,AdmReason)
		s DepRefArcimStr=##class(web.DHCOPAdmReg).GetCustomScheduleService(PatientID,RegFeeRBASDr,SerIdStr)
	}elseif(CESFlag="1"){
		//应急系统患者判断最后的
		s INVOrderItems=##Class(DHCDoc.Interface.StandAlone.Service).GetAdmRegSerOrd(adm)
	}
	
	s find=""
	s rtn=""
	;判断是否有否除了挂号以外产生的医嘱  add by zhouzq 2010.09.09
	s FreeOrder=$p(##class(web.DHCOPRegConfig).GetSpecConfigNode("FreeOrder"),"@",1)
	
 	;w INVOrderItems
	s OrderChild=0
	f  s OrderChild=$O(^OEORD(OrderRowId,"I",OrderChild)) q:((OrderChild="")!(find="1"))  d
	.s oeflag=$p(^OEC("OSTAT",$p(^OEORD(OrderRowId,"I",OrderChild,1),"^",13)),"^",1)
	.Q:("^"_INVOrderItems_"^")[("^"_OrderRowId_"||"_OrderChild_"^")
	.s Arcimid=$p($g(^OEORD(OrderRowId,"I",OrderChild,1)),"^",2) 
	.s MRFeeArcimId=##class(web.DHCOPAdmReg).GetMRFeeArcimId()
	.q:("^"_MRFeeArcimId_"^")[("^"_Arcimid_"^")
	.q:("^"_DepRefArcimStr_"^")[("^"_Arcimid_"^")
	.q:("^"_FreeOrder_"^")[("^"_Arcimid_"^")
	.i (oeflag'="D")&&(oeflag'="U")&&(oeflag'="C")  d
	..s find=1
	..s rtn="不可删除诊断，需要停医嘱"
	Q:find="1" rtn
	
	Q ""
}

ClassMethod DeleteMRDiagnos(MRDiagnosRowid As %String, UserRowid As %String = "", LocRowid As %String = "") As %String
{
	;Set MRobject = ##class(User.MRDiagnos).%OpenId(MRDiagnosRowid)
	;Set sc = ##class(User.MRDiagnos).%Delete(MRobject)
 	;do MRobject.%Close()
 	s ^TempDeleteMRDiagnos("DeleteMRDiagnos")=MRDiagnosRowid_","_UserRowid_","_LocRowid
 	//q 0
 	q:+MRDiagnosRowid=0 ""
 	s Checkret=..CheckDelete(MRDiagnosRowid)
 	Q:Checkret'="" Checkret
	s:UserRowid="" UserRowid=%session.Data("LOGON.USERID")
	s StopRowidStr=""
	s EpisodeID=$P(^MR(+MRDiagnosRowid,"PRO",1),"^",9)
 	s admType=$P($g(^PAADM(EpisodeID)),"^",2)
	////判断是否有子诊断
	s StopRowidStr=##Class(web.DHCMRDiagnos).GetGroupMRDia(MRDiagnosRowid)
	for i=1:1:$Length(StopRowidStr,"^") {
		s oneRowid=$P(StopRowidStr,"^",i)
		continue:+oneRowid=0
		s ^MRDelLog(+oneRowid,"Sub",$p(oneRowid,"||",2))=UserRowid_"^"_$ZD(+$H,3)_"^"_$ZT($P($H,",",2))
		s ^MRDelLog(+oneRowid,"Sub",$p(oneRowid,"||",2),"Data")=$g(^MR(+oneRowid,"DIA",$P(oneRowid,"||",2)))
		s DiagPRowId=$o(^MRi("DIAGP",oneRowid,""))
		if (DiagPRowId'=""){
			&SQL(Delete From SQLUser.MR_DiagnosProperty_Log where DiagP_ParRef=:DiagPRowId)
			&SQL(Delete From SQLUser.MR_DiagnosProperty where MRDiagnosP_RowID=:DiagPRowId)
		}
		
		&SQL(Delete From SQLUser.MR_Diagnos Where MRDIA_Rowid=:oneRowid)
	}
 	Q SQLCODE
}

/// w ##Class(web.DHCMRDiagnos).GetGroupMRDia("1367||4")
ClassMethod GetGroupMRDia(MRDiagnosRowid As %String) As %String
{
	n (MRDiagnosRowid)
	s OutPutStr=MRDiagnosRowid
	s MRADMRowId=+MRDiagnosRowid
	s MainDiagnosRowid=""
	if $D(^MR(MRADMRowId,"DIA",0,"Link",MRDiagnosRowid)) {
		s MainDiagnosRowid=MRDiagnosRowid
	}else{
		s MainDiagnosRowid=$P($G(^MR(MRADMRowId,"DIA",$P(MRDiagnosRowid,"||",2))),"^",15)
	}
	q:MainDiagnosRowid="" OutPutStr
	s OutPutStr=MainDiagnosRowid
	s Sub=0
	for {
		s Sub=$O(^MR(MRADMRowId,"DIA",0,"Link",MainDiagnosRowid,Sub))
		q:Sub=""
		s SubRowID=MRADMRowId_"||"_Sub
		if ("^"_OutPutStr_"^")'[("^"_SubRowID_"^") {
			s OutPutStr=OutPutStr_"^"_SubRowID
		}
	}
	q OutPutStr
}

/// w ##Class(web.DHCMRDiagnos).GetGroupICDInfo("1367||4")
ClassMethod GetGroupICDInfo(MRDiagnosRowid As %String, isSaveToTemp As %String = "") As %String
{
	n (MRDiagnosRowid,isSaveToTemp)
	s OutPutStr=""
	s GroupMRDiaStr=##Class(web.DHCMRDiagnos).GetGroupMRDia(MRDiagnosRowid)
	for i=1:1:$Length(GroupMRDiaStr,"^") {
		s oneRowid=$P(GroupMRDiaStr,"^",i)
		continue:+oneRowid=0
		s ICDRowid=$p(^MR(+oneRowid,"DIA",$P(oneRowid,"||",2)),"^",1)
		
		s Desc=$G(^MR(+oneRowid,"DIA",$P(oneRowid,"||",2),"DES",1))
		if (ICDRowid'=""){
			s Info=ICDRowid
		}else{
			if (isSaveToTemp="1")&&(i=1){
				s Info="$"_Desc
			}else{
				s Info=Desc
			}
			
		}
		if (OutPutStr=""){
			s OutPutStr=Info
		}else{
			s OutPutStr=OutPutStr_"!"_Info
		}
	}
	q OutPutStr
}

/// w ##Class(web.DHCMRDiagnos).GetGroupICDRowIDStr("1367||4")
ClassMethod GetGroupICDRowIDStr(MRDiagnosRowid As %String) As %String
{
	n (MRDiagnosRowid)
	s OutPutStr=""
	s GroupMRDiaStr=##Class(web.DHCMRDiagnos).GetGroupMRDia(MRDiagnosRowid)
	for i=1:1:$Length(GroupMRDiaStr,"^") {
		s oneRowid=$P(GroupMRDiaStr,"^",i)
		continue:+oneRowid=0
		s ICDRowid=$p(^MR(+oneRowid,"DIA",$P(oneRowid,"||",2)),"^",1)
		continue:ICDRowid=""
		if (OutPutStr=""){
			s OutPutStr=ICDRowid
		}else{
			s OutPutStr=OutPutStr_"!"_ICDRowid
		}
	}
	q OutPutStr
}

/*bak
ClassMethod DeleteMRDiagnos(MRDiagnosRowid As %String) As %String
{
	;Set MRobject = ##class(User.MRDiagnos).%OpenId(MRDiagnosRowid)
	;Set sc = ##class(User.MRDiagnos).%Delete(MRobject)
 ;do MRobject.%Close()
 &SQL(Delete From SQLUser.MR_Diagnos Where MRDIA_Rowid=:MRDiagnosRowid)
 Q SQLCODE
}
*/
ClassMethod GetHistoryMRDiagnoseClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetHistoryMRDiagnoseExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetHistoryMRDiagnoseExecute(ByRef qHandle As %Binary, PatientID As %String, ICDType As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s desc="",rowid="",mrdesc=""
	k ^CacheTemp($J,"HistoryMRDiagnose")
	s Paadmtype=0  f  s Paadmtype=$o(^PAPERdr(PatientID,"ADM",Paadmtype)) q:Paadmtype=""  d
 .s PaadmRowid=0 f  s PaadmRowid=$o(^PAPERdr(PatientID,"ADM",Paadmtype,PaadmRowid)) q:PaadmRowid=""  d 
	..&SQL(DECLARE EmpCur4 CURSOR FOR 
	select MRDIA_ICDCode_DR,MRDIA_ICDCode_DR->MRCID_Desc,MRDIA_Desc,MRDIA_ICDCode_DR->MRCID_BillFlag3
	into :rowid,:desc,:mrdesc,:BillFlag3 
	from SQLUser.MR_Diagnos 
	where MRDIA_MRADM_ParRef->MRADM_ADM_DR=:PaadmRowid)
	..&sql(OPEN EmpCur4)
	..for  &SQL(FETCH EmpCur4) QUIT:SQLCODE  do
	...Q:rowid=""
	...Q:(ICDType="1")&&(BillFlag3'="Y")
	...Q:(ICDType'="1")&&(BillFlag3="Y")
	...i '$D(^CacheTemp($J,"HistoryMRDiagnose",rowid)) d
	....s ^CacheTemp($J,"HistoryMRDiagnose",rowid)=""
	....d OutputRow14	
	..&sql(CLOSE EmpCur4)
	k ^CacheTemp($J,"HistoryMRDiagnose")
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow14
	set Data=$lb(rowid,desc,mrdesc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod GetHistoryMRDiagnoseFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetHistoryMRDiagnoseExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {			// if there are no more rows, finish fetching
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

ClassMethod GetHistoryMRDiagnoseListBroker(itmjs As %Library.String = "", PatientID As %Library.String = "", ICDType As %String = "") As %String
{
	Set obj=##class(%ResultSet).%New("web.DHCMRDiagnos:GetHistoryMRDiagnose")
	d obj.Execute(PatientID,ICDType)
	For  Quit:'obj.Next()  Do
	.s Desc=obj.Data("Desc")
	.s Rowid=obj.Data("Rowid")
	.s MRDesc=obj.Data("MRDesc")
	.if MRDesc'="" s MRDesc=$LIST(MRDesc,1)
	.s retval=itmjs_"('"_$ZCVT(Desc,"O","JS")_"','"_$ZCVT(Rowid,"O","JS")_"','"_$ZCVT(MRDesc,"O","JS")_"');"
	.&javascript<#(retval)#>
	d obj.Close()
	q 0
}

ClassMethod GetLocICDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLocICDExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetLocICDExecute(ByRef qHandle As %Binary, LocRowid As %String, ICDType As %String = "") As %Status
{
 s UserRowid=%session.Data("LOGON.USERID")
 s AllowUserDiagnos=##Class(web.DHCDocConfig).GetConfigNode1("AllowUserDiagnos",UserRowid)
 Set repid=$I(^CacheTemp)
 If $g(ind)="" Set ind=1
 s Desc="",Rowid="",Code=""
 i AllowUserDiagnos'="1"{
	 &sql(DECLARE EmpCursor CURSOR FOR
	   Select  LocDia_MRCICD_Dr into :MRICDRowid From SQLUser.DHC_LocDiagnose Where LocDia_CTLoc_DR=:LocRowid order by LocDia_Sort)	
	 &sql(OPEN EmpCursor)
	 for  &SQL(FETCH EmpCursor) QUIT:SQLCODE  do
	 .i MRICDRowid'="" d
	 .. q:'$d(^MRC("ID",MRICDRowid))
	 .. &sql(Select MRCID_Desc,MRCID_Rowid,MRCID_Code,MRCID_BillFlag3 into :Desc,:Rowid,:Code,:BillFlag3 From SQLUser.MRC_ICDDx where MRCID_Rowid=:MRICDRowid)
	 .. i ICDType="1" d
	 ... i BillFlag3="Y" d OutputRow2
	 .. e  d
	 ... i BillFlag3'="Y" d OutputRow2 	
	 &sql(CLOSE EmpCursor)
 }else{
	 s UserRowid=%session.Get("LOGON.USERID") 
	 &sql(DECLARE EmpCursor1 CURSOR FOR
	   Select  LocDia_MRCICD_Dr into :MRICDRowid From SQLUser.DHC_LocDiagnose Where LocDia_User_DR=:UserRowid order by LocDia_Sort)	
	 &sql(OPEN EmpCursor1)
	 for  &SQL(FETCH EmpCursor1) QUIT:SQLCODE  do
	 .i MRICDRowid'="" d
	 .. q:'$d(^MRC("ID",MRICDRowid))
	 .. &sql(Select MRCID_Desc,MRCID_Rowid,MRCID_Code,MRCID_BillFlag3 into :Desc,:Rowid,:Code,:BillFlag3 From SQLUser.MRC_ICDDx where MRCID_Rowid=:MRICDRowid)
	 .. i ICDType="1" d
	 ... i BillFlag3="Y" d OutputRow2
	 .. e  d
	 ... i BillFlag3'="Y" d OutputRow2 	
	 &sql(CLOSE EmpCursor1)
 } 	
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow2
 set Data=$lb(Desc,Rowid,Code)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
	Quit
ResetVariables2
	set (Desc,Rowid,Code)=""
	quit
}

ClassMethod GetLocICDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLocICDExecute ]
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

ClassMethod GetLocICDListBroker(itmjs As %Library.String = "", LocRowid As %Library.String = "", ICDType As %String = "") As %String
{
	Set obj=##class(%ResultSet).%New("web.DHCMRDiagnos:GetLocICD")
	d obj.Execute(LocRowid,ICDType)
	For  Quit:'obj.Next()  Do
	.s Desc=obj.Data("Desc")
	.s Rowid=obj.Data("Rowid")
	.s Code=obj.Data("Code")
	.s retval=itmjs_"('"_$ZCVT(Desc,"O","JS")_"','"_$ZCVT(Rowid,"O","JS")_"','"_$ZCVT(Code,"O","JS")_"');"
	.&javascript<#(retval)#>
	d obj.Close()
	q 0
}

ClassMethod GetMRDiagnosCreateUser(MRDiagnosRowid As %String) As %String
{
	;Set MRobject = ##class(User.MRDiagnos).%OpenId(MRDiagnosRowid)
	;Set sc = ##class(User.MRDiagnos).%Delete(MRobject)
 ;do MRobject.%Close()
 &SQL(Select MRDIA_UserCreated_DR into :CreateUser From SQLUser.MR_Diagnos Where MRDIA_Rowid=:MRDiagnosRowid)
 Q:SQLCODE=0 CreateUser
 Q ""
}

ClassMethod GetMRDiagnosDesc(MRAdmRowid As %String, DelimStr As %String) As %String
{
	s EpisodeID=$p($G(^MR(MRAdmRowid,"PRO",1)),"^",9)
	Q ##class(DHCDoc.Diagnos.Common).GetAdmDiagDesc(EpisodeID,"","","","Y")
}

ClassMethod GetMRDiagnosNote(MRDiagnosRowid As %String) As %String
{
	;&SQL(select MRDIA_Desc From MR_Diagnos Where MRDIA_Rowid=:MRDiagnosRowid)
	Set MRobject = ##class(User.MRDiagnos).%OpenId(MRDiagnosRowid)
	if $IsObject(MRobject) {
		s MRDesc=MRobject.MRDIADesc.GetAt(1)
	}
	Q $ZCVT(MRDesc,"O","JS")
}

ClassMethod GetSeriousDiseaseByICD(MRCICDRowid As %String) As %String
{
	Q:MRCICDRowid="" ""
	s SeriousDisease=""
	Set ICDobject = ##class(User.MRCICDDx).%OpenId(MRCICDRowid)
	if $IsObject(ICDobject) {
		s SeriousDisease=ICDobject.MRCIDSeriousDis
	}
	Q SeriousDisease
}

ClassMethod GetMRDiagnoseListBroker(itmjs As %Library.String = "", MRADMID As %Library.String = "", ICDType As %String = "") As %String
{
	Set obj=##class(%ResultSet).%New("web.MRDiagnos:Find")
	d obj.Execute(MRADMID)
	For  Quit:'obj.Next()  Do
	.s Desc=obj.Data("MRDIAICDCodeDRDesc")
	.s Rowid=obj.Data("ID")
	.s CodeRowid=obj.Data("MRDIAICDCodeDR")
	.s BillFlag3=""
	.if CodeRowid'="" d
	..Q:'$D(^MRC("ID",CodeRowid))
	..s BillFlag3=$P(^MRC("ID",CodeRowid),"^",15)
	.Q:(ICDType="1")&&(BillFlag3'="Y")
	.Q:(ICDType'="1")&&(BillFlag3="Y")
	.s MRDesc=obj.Data("MRDIADesc")
	.if MRDesc'="" s MRDesc=$LIST(MRDesc,1)
	.s retval=itmjs_"('"_$ZCVT(Desc,"O","JS")_"','"_$ZCVT(Rowid,"O","JS")_"','"_$ZCVT(CodeRowid,"O","JS")_"','"_$ZCVT(MRDesc,"O","JS")_"');"
	.;s retval=itmjs_"('"_$ZCVT(Desc,"O","JS")_"','"_$ZCVT(Rowid,"O","JS")_"','"_$ZCVT(CodeRowid,"O","JS")_"','"_MRDesc_"');"
	.;s ^DHCApp(Rowid)=Desc_"^"_Rowid_"^"_CodeRowid_"^"_MRDesc
	.&javascript<#(retval)#>
	d obj.Close()
	q 0
}

ClassMethod InsertMRDiagnos(LogDepRowid As %String, MRAdmRowid As %String, ICDCodeRowid As %String, UserRowid As %String, MRDIADesc As %String, MRDiagTypeId As %String = "", MRDIADiagStatDesc As %String = "", MRDIASignSymDesc As %String = "", MRDIADurationNum As %String = "", MRDIADurationUnit As %String = "", DHCMRDIASignSymDesc As %String = "", DiagnosStatus As %String = "", DiagnosLeavel As %String = "", DocUserId As %String = "", MainDiaType As %String = "", SyndromeCICDStr As %String = "", SyndromeDescStr As %String = "", DiagnosPropertyInfo As %String = "", AddDiagnoseWay As %String = "D") As %String
{
	;w ##class(web.DHCMRDiagnos).InsertMRDiagnos(63,1358,24167,600,"",5,"","","","","",3,1,"","N",26312,"")
	;w ##class(web.DHCMRDiagnos).InsertMRDiagnos(15,9,"",153,"",4,"","","","","",3,1,"","N","","","14703^253^76^^")

	n (LogDepRowid, MRAdmRowid, ICDCodeRowid, UserRowid, MRDIADesc, MRDiagTypeId, MRDIADiagStatDesc, MRDIASignSymDesc, MRDIADurationNum, MRDIADurationUnit, DHCMRDIASignSymDesc, DiagnosStatus, DiagnosLeavel, DocUserId, MainDiaType,SyndromeCICDStr, SyndromeDescStr,DiagnosPropertyInfo,AddDiagnoseWay)
	 s ^zhou("InsertMRDiagnos")=LogDepRowid_","_MRAdmRowid_","_ICDCodeRowid_","_UserRowid_","_MRDIADesc_","_MRDiagTypeId_","_MRDIADiagStatDesc_","_MRDIASignSymDesc_","_MRDIADurationNum_","_MRDIADurationUnit_","_DHCMRDIASignSymDesc_","_DiagnosStatus_","_DiagnosLeavel_","_DocUserId_","_MainDiaType_","_SyndromeCICDStr_","_SyndromeDescStr_","_DiagnosPropertyInfo
	 s HosRowid=##Class(web.CTLoc).GetHospital(LogDepRowid) 
	 if (ICDCodeRowid="")&&(DiagnosPropertyInfo'=""){
		 s ICDCodeRowid=$p(DiagnosPropertyInfo,"^",8)
	 }
	 TS
	 Set object = ##class(User.MRDiagnos).%New(MRAdmRowid)
	 ;可以采取用对象引用赋值的方式?也可以用Object.ProPertyNameSetObjectID(Id)的方式?
	 ;Set MRobject = ##class(User.MRAdm).%OpenId(MRAdmRowid)
	 ;s object.MRDIAMRADMParRef=MRobject
	 Do object.MRDIAMRADMParRefSetObjectId(MRAdmRowid)
	 Do object.MRDIAICDCodeDRSetObjectId(ICDCodeRowid)
	//Do object.MRDIAAddLocDRSetObjectId(LogDepRowid)
	////非标准诊断类型1:西医，2：中医，3症性
	IF MRDIADesc'="" {
		s DescType=$P(MRDIADesc,"#",2)
		s MRDIADesc=$P(MRDIADesc,"#",1)
		
		Do object.MRDIADesc.Insert($replace(MRDIADesc,"\",""))
		if (DescType'=""){
			s object.MRDIAQuestionnaire=DescType
		}
	}
	 s object.MRDIADate=$p($h,",",1)
	 s object.MRDIATime=$p($h,",",2)
	 Do object.MRDIAUpdateUserDRSetObjectId(UserRowid)
	 Do object.MRDIAUpdateHospitalDRSetObjectId(HosRowid)
	 s object.MRDIAUpdateDate=$p($h,",",1)
	 s object.MRDIAUpdateTime=$p($h,",",2)
	 Do object.MRDIAUserCreatedDRSetObjectId(UserRowid)
	 i DocUserId'="" {
		 s CTPCPRowId=$P(^SSU("SSUSR",DocUserId),"^",14)
		 i CTPCPRowId'="" Do object.MRDIADocCodeDRSetObjectId(CTPCPRowId)
	 }elseif UserRowid'="" {
		 s CTPCPRowId=$P(^SSU("SSUSR",UserRowid),"^",14)
		 i CTPCPRowId'="" Do object.MRDIADocCodeDRSetObjectId(CTPCPRowId)
	 }
	 
	 s MRDIADiagStatDR=""
	 if MRDIADiagStatDesc'="" d
	.;s MRDIADiagStatDR=##Class(web.MRCDiagnosStatus).GetIdFromCodeOrDescription($g(MRDIADiagStatDesc))
	.;d object.MRDIADiagStatDRSetObjectId($g(MRDIADiagStatDR))
	 .
	 s MRDIASignSymDR=""
	 if MRDIASignSymDesc'="" d
	.;s MRDIASignSymDR=##Class(web.MRCDiagnosSignSymptom).GetIdFromCodeOrDescription($g(MRDIASignSymDesc))
	.;d object.MRDIASignSymDRSetObjectId($g(MRDIASignSymDR))
	 
	 if DiagnosStatus'="" d
	 .d object.MRDIADiagStatDRSetObjectId($g(DiagnosStatus)) 
	 b  ;
	 s object.MRDIADurationNum=MRDIADurationNum
	 s object.MRDIADurationUnit=MRDIADurationUnit
	 s object.MRDIAActive="Y"
	 s object.MRDIAAliasDiagText=DHCMRDIASignSymDesc
	 s object.MRDIAMainDiagFlag=MainDiaType
	 s object.MRDIAAddDiagnoseWay=AddDiagnoseWay
	 Set sc = object.%Save()
	 If $$$ISERR(sc) {
		 Do $System.Status.DisplayError()
		 TRO
		 Quit "-201^插入诊断表失败,错误信息:"_$ZE
	 }
	 
	 Set Rowid=object.%Id()
	 s ^Tempzong2=Rowid
	 s ChildSub=$P(Rowid,"||",2)
	 s $P(^MR($P(Rowid,"||",1),"DIA",ChildSub,"EPR"),"^",1)=DiagnosLeavel // 诊断级别
	 Do object.%Close()
	 Set object = ##class(User.DHCMRDiagnos).%OpenId(Rowid)
	 IF DHCMRDIASignSymDesc'="" Do object.MRDIASignSymDesc.Insert(DHCMRDIASignSymDesc)
	 Set sc = object.%Save()
	 If $$$ISERR(sc) {
		 Do $System.Status.DisplayError()
		 Quit "-202^插入诊断表MRDIASignSymDesc字段失败,错误信息:"_$ZE
	 }
	 if (DiagnosPropertyInfo'=""){
		 s rtn=..SaveDiagProperty(Rowid,DiagnosPropertyInfo,UserRowid)
		 if (rtn'=0){
			 TRO
		 	 Quit "-206^插入诊断属性表失败,错误信息:"_$ZE
		 }
	 }
	 s SQLCODE=0
	 if MRDiagTypeId'="" {
		 if ($D(^MRC("DTYP",MRDiagTypeId))){
			 s MRDiagTypeID=MRDiagTypeId
		 }else{
		 	s MRDiagTypeID=##Class(web.MRCDiagnosType).GetIdFromCodeOrDescription($g(MRDiagTypeId))
		 }
		 
		 ;s MRDiagTypeID=##Class(web.MRCDiagnosType).GetIdFromCodeOrDescription($g(MRDiagTypeDesc))
		 ;do ##Class(Web.MRDiagType).WebsysSaveDiagType(5,Rowid)  //lgl +默认统一诊断类型
		 i $d(^MRC("DTYP",MRDiagTypeID)) {
		 	&SQL(insert into SQLUser.MR_Diagtype (typ_parref,typ_mrcdiagtyp) values(:Rowid,:MRDiagTypeID))
		 }else{
			  s MRDiagTypeID=""
			  ;诊断类型为空则返回为失败
		 	s SQLCODE="-203^插入失败,诊断类型为空"
		 }
	 }else{
		 s MRDiagTypeID=""
		 s EpisodeID=$P($g(^MR(MRAdmRowid,"PRO",1)),"^",9)
		 s admType=""
		 i EpisodeID'="" s admType=$P($g(^PAADM(EpisodeID)),"^",2)
		 i admType'="I" s MRDiagTypeID=$O(^MRC("DTYP",0,"Code","OP",0))
		 i MRDiagTypeID'="" {
		 	&SQL(insert into SQLUser.MR_Diagtype (typ_parref,typ_mrcdiagtyp) values(:Rowid,:MRDiagTypeID))
		 }else{
			 ;诊断类型为空则返回为失败
			 s SQLCODE="-203^插入失败,诊断类型为空"
		 }
	 }
	 i SQLCODE'=0 {
		 TRO
		 Quit "-204^插入诊断子表诊断类型表失败,请重新选择诊断类型,错误信息SQLCODE:"_SQLCODE
	 }
	 ;插入主诊断记录子表
	 i MainDiaType="Y" {
		 s InsertDate=+$h
		 s InsertTime=$p($h,",",2)
		 &SQL(insert into SQLUser.DHCMR_DiagnosMainDiag (DMD_ParRef,DMD_Date,DMD_Time,DMD_User_DR) values(:Rowid,:InsertDate,:InsertTime,:UserRowid))
		 i SQLCODE'=0 {
			 TRO
			 Quit "-205^插入诊断子表主诊断记录表失败,错误信息:"_$ZE
		 }
	 }
	 

	 Do object.%Close()
	 i ICDCodeRowid'="" s ^MR("0","DateICD",+$h,ICDCodeRowid,MRAdmRowid,ChildSub)=""
	 s object=""
	 TC
	 
	 
	 ///tanjishan 中医诊断的症性是主子关系
	if ((SyndromeCICDStr'="")||(SyndromeDescStr'=""))&&(Rowid>0){
		for i=1:1:$L(SyndromeCICDStr,"^"){
			s SyndromeCICDRowid=$P(SyndromeCICDStr,"^",i)
			s SyndromeDesc=$P(SyndromeDescStr,"^",i)
			continue:(SyndromeCICDRowid="")&&((SyndromeDesc="#3")||(SyndromeDesc=""))
			s rtn=..InsertMRDiagnos(LogDepRowid,MRAdmRowid,SyndromeCICDRowid,UserRowid,SyndromeDesc,MRDiagTypeId,MRDIADiagStatDesc,MRDIASignSymDesc,MRDIADurationNum,MRDIADurationUnit,DHCMRDIASignSymDesc,DiagnosStatus,DiagnosLeavel,DocUserId,MainDiaType)	
			s SyndromeRowid=$P(rtn,"^",2)
			b ;put
			if ((+rtn=0)&&(SyndromeRowid'="")){
				s ret=##Class(web.DHCDocDiagnosNew).UpdateMRDiagnos(SyndromeRowid,"2")
				Set object = ##class(User.MRDiagnos).%OpenId(SyndromeRowid)
				d object.MRDIAMRDIADRSetObjectId($P(Rowid,"^",1))
				Set sc = object.%Save()
				Do object.%Close()
	
			}
			s Rowid=Rowid_"^"_SyndromeRowid
		}
	}
	 
	 Quit "0^"_Rowid
	 ;Do MRobject.%Close()
	 ;s MRobject=""
}

// w ##class(web.DHCMRDiagnos).SaveDiagProperty("364||3","9473^45^^^318^^肺癌^1824",4634,"3^N^3^TNM分期    待诊^^")

ClassMethod SaveDiagProperty(MRDiagRowId As %String, DiagnosPropertyInfo As %String, UserRowid As %String, DiagBaseInfo As %String = "") As %String
{
	s ^tempscl("SaveDiagProperty")=MRDiagRowId_","_DiagnosPropertyInfo_","_UserRowid_","_DiagBaseInfo
	//q 0
	s DKBBCRowId=$p(DiagnosPropertyInfo,"^",1) //缺省属性ID
	s TreeDataStr=$p(DiagnosPropertyInfo,"^",2)
	s ComboDataStr=$p(DiagnosPropertyInfo,"^",3)
	s RadioDataStr=$p(DiagnosPropertyInfo,"^",4)
	s CheckDataStr=$p(DiagnosPropertyInfo,"^",5)
	s DiagPNotes=$p(DiagnosPropertyInfo,"^",6)
	s DiagDisplayName=$p(DiagnosPropertyInfo,"^",7)
	s linkICDRowid=$p(DiagnosPropertyInfo,"^",8)
	s DiagnosPRowID=$o(^MRi("DIAGP",MRDiagRowId,""))
	s OldDiagPropertyData=..GetLogData(MRDiagRowId)
	TS
	if (DiagnosPRowID=""){
		 s object = ##class(User.MRDiagnosProperty).%New()
		 Do object.MRDiagnosDRSetObjectId(MRDiagRowId)
		 Do object.DiagnosBaseCatPDRSetObjectId(DKBBCRowId)
		 
	}else{
		 s object = ##class(User.MRDiagnosProperty).%OpenId(DiagnosPRowID)
		 if (DiagBaseInfo'=""){
			 s MRDIARowid=$p(^MR("DIAGP",DiagnosPRowID),"^",1)
			 s DiagnosStatusDr=$p(DiagBaseInfo,"^",1)
			 s MainDiaType=$p(DiagBaseInfo,"^",2)
			 s DiagnosTypeId=$p(DiagBaseInfo,"^",3)
			 s DiagNotes=$p(DiagBaseInfo,"^",4)
			 s BPSystolic=$p(DiagBaseInfo,"^",5)
			 s BPDiastolic=$p(DiagBaseInfo,"^",6)
			 s Mrobject = ##class(User.MRDiagnos).%OpenId(MRDIARowid)
			 Do Mrobject.MRDIADiagStatDRSetObjectId($g(DiagnosStatusDr)) 
			 s Mrobject.MRDIAMainDiagFlag=MainDiaType
			 //Do Mrobject.MRDIADesc.Insert($replace(DiagNotes,"\",""))
			 s Mrobject.MRDIAUpdateDate=$p($h,",",1)
	 		 s Mrobject.MRDIAUpdateTime=$p($h,",",2)
	 		 Do Mrobject.MRDIAUpdateUserDRSetObjectId(UserRowid)
	 		 Set sc = Mrobject.%Save()
			 If $$$ISERR(sc) {
				 Do $System.Status.DisplayError()
				 TRO
				 Quit "-201"
			 }
			 Do Mrobject.%Close()
			 s Mrobject=""
			 s MRAdmID=+MRDIARowid
			 &sql(Update SQLUser.MR_Adm(MRADM_BPSystolic,MRADM_BPDiastolic) Values(:BPSystolic,:BPDiastolic) Where MRADM_RowId=:MRAdmID)
			 if (SQLCODE'=0){
				 TRO
				 Quit SQLCODE
			 }
			 s DiagNotes=$LISTBUILD(DiagNotes)
			 &sql(Update SQLUser.MR_Diagnos set MRDIA_Desc=:DiagNotes,MRDIA_ICDCode_DR=:linkICDRowid where MRDIA_Rowid=:MRDIARowid)
			 if (SQLCODE'=0){
				 TRO
				 Quit SQLCODE
			 }
			 &SQL(update SQLUser.MR_Diagtype set typ_mrcdiagtyp=:DiagnosTypeId where typ_parref =:MRDIARowid)
			 if (SQLCODE'=0){
				 TRO
				 Quit SQLCODE
			 }
	     }
	}
	s object.DiagnosTreeP=TreeDataStr
	s object.DiagnosComboP=ComboDataStr
	s object.DiagnosRadioP=RadioDataStr
	s object.DiagnosCheckBoxP=CheckDataStr
	s object.DiagnosNotesP=DiagPNotes
	s object.DiagnosDisPlayName=DiagDisplayName
	Set sc = object.%Save()
	If $$$ISERR(sc) {
		 Do $System.Status.DisplayError()
		 TRO
		 Quit "-208"
	}
	b //45
	TC
	Set MRDiagnosPRowID=object.%Id()
	Do object.%Close()
	s NewDiagPropertyData=..GetLogData(MRDiagRowId) 
	d ..InsertDiagPropertyLog(MRDiagnosPRowID,OldDiagPropertyData,NewDiagPropertyData,UserRowid) //if (DiagnosPRowID'="") 
	Q 0
}

ClassMethod GetLogData(MRDiagRowId As %String)
{
	s MRDiagnosPRowID=$o(^MRi("DIAGP",MRDiagRowId,""))
	q:MRDiagnosPRowID="" ""
	s DiagnosTreeP=$p($g(^MR("DIAGP",MRDiagnosPRowID)),"^",3)
	s DiagnosComboP=$p($g(^MR("DIAGP",MRDiagnosPRowID)),"^",4)
	s DiagnosRadioP=$p($g(^MR("DIAGP",MRDiagnosPRowID)),"^",7)
	s DiagnosCheckBoxP=$p($g(^MR("DIAGP",MRDiagnosPRowID)),"^",8)
	s DiagnosNotesP=$p($g(^MR("DIAGP",MRDiagnosPRowID)),"^",9)
	s DiagnosDisPlayName=$p($g(^MR("DIAGP",MRDiagnosPRowID)),"^",10)
	Q DiagnosTreeP_"^"_DiagnosComboP_"^"_DiagnosRadioP_"^"_DiagnosCheckBoxP_"^"_DiagnosNotesP_"^"_DiagnosDisPlayName
}

// w ##class(web.DHCMRDiagnos).InsertDiagPropertyLog(132,"292$293$44$45$46^^^^^肺癌","279$291$44$45^^^^^肺癌",4634)

ClassMethod InsertDiagPropertyLog(MRDiagnosPRowID, OldDiagPropertyData, NewDiagPropertyData, UserRowid)
{
	s ^tempscl("InsertDiagPropertyLog")=MRDiagnosPRowID_","_OldDiagPropertyData_","_NewDiagPropertyData_","_UserRowid
	s DKBDiagRowId=..GetDKBDiagRowId(MRDiagnosPRowID)
	Q:DKBDiagRowId="" ""
	s Rtn=##class(web.DHCBL.MKB.TKBTremExtend).GetDoctorInfoStr(DKBDiagRowId)
	q:Rtn="" ""
	s modeJsonInfo=$p(Rtn,"^",3)
	Q:modeJsonInfo="" ""
	s DiagPropertyChangeCon=..GetDiagPropertyChangeCon(modeJsonInfo,OldDiagPropertyData,NewDiagPropertyData)
	Q:DiagPropertyChangeCon="" ""
	TS
	s object1 = ##class(User.MRDiagnosPropertyLog).%New(MRDiagnosPRowID)
	Do object1.DiagPParRefSetObjectId(MRDiagnosPRowID)
	Do object1.DiagPUpdateUserDRSetObjectId(UserRowid)
	s object1.DiagPUpdateContent=DiagPropertyChangeCon
	s object1.DiagPUpdateDate=+$h
	s object1.DiagPUpdateTime=$p($h,",",2)
	Set sc = object1.%Save()
	If $$$ISERR(sc) {
		 Do $System.Status.DisplayError(sc)
		 TRO
		 Quit "-208"
	}
	TC
	Do object1.%Close()
	Q 0
}

// 根据诊断属性表User.MRDiagnosPropertyID  得到属性对应的诊断术语ID

ClassMethod GetDKBDiagRowId(MRDiagnosPRowID As %String) As %String
{
	/*Q:MRDiagnosPRowID="" ""
	s DKBBaseCatDr=$p($g(^MR("DIAGP",MRDiagnosPRowID)),"^",2)
	Q:DKBBaseCatDr="" ""
	s DKBBCDiagDr=$p($g(^DKBBASCAT(DKBBaseCatDr)),"^",5) //诊断术语ID
	Q DKBBCDiagDr*/
	Q:MRDiagnosPRowID="" ""
	s DKBBaseCatDr=$p($g(^MR("DIAGP",MRDiagnosPRowID)),"^",2)
	Q:DKBBaseCatDr="" ""
	s TKBTETreDr=$p($g(^TKBTREEXT(DKBBaseCatDr)),"^",5)
	Q TKBTETreDr
	//s DKBBCDiagDr=$p($g(^DKBBASCAT(DKBBaseCatDr)),"^",5) //诊断术语ID
	//Q DKBBCDiagDr
}

// w ##class(web.DHCMRDiagnos).GetDiagPropertyChangeCon("17252"_$c(2)_"引用术语测试"_$c(2)_"S"_$c(2)_"CB","^^26430^^","^^26429^^"")

ClassMethod GetDiagPropertyChangeCon(modeJsonInfo As %String, OldDiagPropertyData As %String, NewDiagPropertyData As %String) As %String
{
	n (modeJsonInfo,OldDiagPropertyData,NewDiagPropertyData)
	s ^tempscl("gg")=modeJsonInfo_","_OldDiagPropertyData_","_NewDiagPropertyData
	s Content=""
	s OldTreeData=$p(OldDiagPropertyData,"^",1)
	s OldComboData=$p(OldDiagPropertyData,"^",2)
	s OldDiagnosRadioP=$p(OldDiagPropertyData,"^",3)
	s OldDiagnosCheckBoxP=$p(OldDiagPropertyData,"^",4)
	s OldDiagnosNotesP=$p(OldDiagPropertyData,"^",5)
	s OldDiagnosDisPlayName=$p(OldDiagPropertyData,"^",6)
	s NewTreeData=$p(NewDiagPropertyData,"^",1)
	s NewComboData=$p(NewDiagPropertyData,"^",2)
	s NewDiagnosRadioP=$p(NewDiagPropertyData,"^",3)
	s NewDiagnosCheckBoxP=$p(NewDiagPropertyData,"^",4)
	s NewDiagnosNotesP=$p(NewDiagPropertyData,"^",5)
	s NewDiagnosDisPlayName=$p(NewDiagPropertyData,"^",6)
	For i=1:1:$l(modeJsonInfo,$c(1)){
		//childId_$c(2)_childDesc_$c(2)_childType_$c(2)_showType
		s OneModeJsonInfo=$p(modeJsonInfo,$c(1),i)
		s childId=$p(OneModeJsonInfo,$c(2),1)
		s childDesc=$p(OneModeJsonInfo,$c(2),2)
		s childType=$p(OneModeJsonInfo,$c(2),3)
		s showType=$p(OneModeJsonInfo,$c(2),4)
		if (showType="T"){
			s OldTreeDetailInfo="",NewTreeDetailInfo=""
			if (childType="S"){
				s SourseTreeIds=##class(web.DHCBL.MKB.TKBTrem).GetSourseTreeIds("",childId) 
				s TKBTEDatSouDr=$p(^TKBTREEXT(childId),"^",4)
				s TKBTRBRowId=0
				for {
					s TKBTRBRowId=$o(^TKBTREMi(0,"Base",TKBTEDatSouDr,TKBTRBRowId))
					q:TKBTRBRowId=""
					continue:(SourseTreeIds'="")&&(("^"_SourseTreeIds_"^")'[("^"_TKBTRBRowId_"^"))
					s TKBTRBDesc=$p(^TKBTREM(TKBTRBRowId),"^",2)
					if ("$"_OldTreeData_"$")[("$"_TKBTRBRowId_"$") {
						i OldTreeDetailInfo="" s OldTreeDetailInfo=TKBTRBDesc
						e  s OldTreeDetailInfo=OldTreeDetailInfo_"、"_TKBTRBDesc
					}
					if ("$"_NewTreeData_"$")[("$"_TKBTRBRowId_"$") {
						i NewTreeDetailInfo="" s NewTreeDetailInfo=TKBTRBDesc
						e  s NewTreeDetailInfo=NewTreeDetailInfo_"、"_TKBTRBDesc
					}
				}
			}else{
				s TKBTDRowId=""
				for {
					s TKBTDRowId=$o(^TKBTREEXTDTLi(0,"Ext",childId,TKBTDRowId))
					Q:TKBTDRowId=""
					s TKBTDDesc=$p(^TKBTREEXTDTL(TKBTDRowId),"^",2)
					if ("$"_OldTreeData_"$")[("$"_TKBTDRowId_"$") {
						i OldTreeDetailInfo="" s OldTreeDetailInfo=TKBTDDesc
						e  s OldTreeDetailInfo=OldTreeDetailInfo_"、"_TKBTDDesc
					}
					if ("$"_NewTreeData_"$")[("$"_TKBTDRowId_"$") {
						i NewTreeDetailInfo="" s NewTreeDetailInfo=TKBTDDesc
						e  s NewTreeDetailInfo=NewTreeDetailInfo_"、"_TKBTDDesc
					}
					
				}
				
			}
			if (NewTreeDetailInfo'=OldTreeDetailInfo){
					i Content="" s Content=childDesc_"由:'"_OldTreeDetailInfo_"'修改为:'"_NewTreeDetailInfo_"'"
					e  s Content=Content_","_childDesc_"由:'"_OldTreeDetailInfo_"'修改为:"_NewTreeDetailInfo_"'"
			}
		}
		if (showType="C"){
			s TKBTDRowId="",OldListDetailInfo="",NewListDetailInfo=""
			if (childType="S"){
				s TKBTEDatSouDr=$p(^TKBTREEXT(childId),"^",4)
				s TKBTRBRowId=0
				for {
					s TKBTRBRowId=$o(^TKBTREMi(0,"Base",TKBTEDatSouDr,TKBTRBRowId))
					q:TKBTRBRowId=""
					s TKBTRBDesc=$p(^TKBTREM(TKBTRBRowId),"^",2)
					if ("$"_OldComboData_"$")[("$"_TKBTRBRowId_"$") {
						i OldListDetailInfo="" s OldListDetailInfo=TKBTRBDesc
						e  s OldListDetailInfo=OldListDetailInfo_"、"_TKBTRBDesc
					}
					if ("$"_NewComboData_"$")[("$"_TKBTRBRowId_"$") {
						i NewListDetailInfo="" s NewListDetailInfo=TKBTRBDesc
						e  s NewListDetailInfo=NewListDetailInfo_"、"_TKBTRBDesc
					}
				}
			}else{
				for {
					s TKBTDRowId=$o(^TKBTREEXTDTLi(0,"Ext",childId,TKBTDRowId))
					Q:TKBTDRowId=""
					s TKBTDDesc=$p(^TKBTREEXTDTL(TKBTDRowId),"^",2)
					if ("$"_OldComboData_"$")[("$"_TKBTDRowId_"$") {
						i OldListDetailInfo="" s OldListDetailInfo=TKBTDDesc
						e  s OldListDetailInfo=OldListDetailInfo_"、"_TKBTDDesc
					}
					if ("$"_NewComboData_"$")[("$"_TKBTDRowId_"$") {
						i NewListDetailInfo="" s NewListDetailInfo=TKBTDDesc
						e  s NewListDetailInfo=NewListDetailInfo_"、"_TKBTDDesc
					}
				}
			}
			
			if (NewListDetailInfo'=OldListDetailInfo){
				i Content="" s Content=childDesc_"由:'"_OldListDetailInfo_"'修改为:'"_NewListDetailInfo_"'"
				e  s Content=Content_","_childDesc_"由:'"_OldListDetailInfo_"'修改为:'"_NewListDetailInfo_"'"
			}
		}
		if (showType="CB"){
			s TKBTDRowId="",OldRadioDetailInfo="",NewRadioDetailInfo=""
			if (childType="S"){
				s TKBTEDatSouDr=$p(^TKBTREEXT(childId),"^",4)
				s TKBTRBRowId=0
				for {
					s TKBTRBRowId=$o(^TKBTREMi(0,"Base",TKBTEDatSouDr,TKBTRBRowId))
					q:TKBTRBRowId=""
					s TKBTRBDesc=$p(^TKBTREM(TKBTRBRowId),"^",2)
					if ("$"_OldDiagnosRadioP_"$")[("$"_TKBTRBRowId_"$") {
						i OldRadioDetailInfo="" s OldRadioDetailInfo=TKBTRBDesc
						e  s OldRadioDetailInfo=OldRadioDetailInfo_"、"_TKBTRBDesc
					}
					if ("$"_NewDiagnosRadioP_"$")[("$"_TKBTRBRowId_"$") {
						i NewRadioDetailInfo="" s NewRadioDetailInfo=TKBTRBDesc
						e  s NewRadioDetailInfo=NewRadioDetailInfo_"、"_TKBTRBDesc
					}
				}
			}else{
				for {
					s TKBTDRowId=$o(^TKBTREEXTDTLi(0,"Ext",childId,TKBTDRowId))
					Q:TKBTDRowId=""
					s TKBTDDesc=$p(^TKBTREEXTDTL(TKBTDRowId),"^",2)
					if ("$"_OldDiagnosRadioP_"$")[("$"_TKBTDRowId_"$") {
						i OldRadioDetailInfo="" s OldRadioDetailInfo=TKBTDDesc
						e  s OldRadioDetailInfo=OldRadioDetailInfo_"、"_TKBTDDesc
					}
					if ("$"_NewDiagnosRadioP_"$")[("$"_TKBTDRowId_"$") {
						i NewRadioDetailInfo="" s NewRadioDetailInfo=TKBTDDesc
						e  s NewRadioDetailInfo=NewRadioDetailInfo_"、"_TKBTDDesc
					}
				}
			}
			if (OldRadioDetailInfo'=NewRadioDetailInfo){
				i Content="" s Content=childDesc_"由:'"_OldRadioDetailInfo_"'修改为:'"_NewRadioDetailInfo_"'"
				e  s Content=Content_","_childDesc_"由:'"_OldRadioDetailInfo_"'修改为:'"_NewRadioDetailInfo_"'"
			}
		}
		if (showType="CG"){
			s TKBTDRowId="",OldCheckDetailInfo="",NewCheckDetailInfo=""
			if (childType="S"){
				s TKBTEDatSouDr=$p(^TKBTREEXT(childId),"^",4)
				s TKBTRBRowId=0
				for {
					s TKBTRBRowId=$o(^TKBTREMi(0,"Base",TKBTEDatSouDr,TKBTRBRowId))
					q:TKBTRBRowId=""
					s TKBTRBDesc=$p(^TKBTREM(TKBTRBRowId),"^",2)
					if ("$"_OldDiagnosCheckBoxP_"$")[("$"_TKBTRBRowId_"$") {
						i OldCheckDetailInfo="" s OldCheckDetailInfo=TKBTRBDesc
						e  s OldCheckDetailInfo=OldCheckDetailInfo_"、"_TKBTRBDesc
					}
					if ("$"_NewDiagnosCheckBoxP_"$")[("$"_TKBTRBRowId_"$") {
						i NewCheckDetailInfo="" s NewCheckDetailInfo=TKBTRBDesc
						e  s NewCheckDetailInfo=NewCheckDetailInfo_"、"_TKBTRBDesc
					}
				}
			}else{
				for {
					s TKBTDRowId=$o(^TKBTREEXTDTLi(0,"Ext",childId,TKBTDRowId))
					Q:TKBTDRowId=""
					s TKBTDDesc=$p(^TKBTREEXTDTL(TKBTDRowId),"^",2)
					if ("$"_OldDiagnosCheckBoxP_"$")[("$"_TKBTDRowId_"$") {
						i OldCheckDetailInfo="" s OldCheckDetailInfo=TKBTDDesc
						e  s OldCheckDetailInfo=OldCheckDetailInfo_"、"_TKBTDDesc
					}
					if ("$"_NewDiagnosCheckBoxP_"$")[("$"_TKBTDRowId_"$") {
						i NewCheckDetailInfo="" s NewCheckDetailInfo=TKBTDDesc
						e  s NewCheckDetailInfo=NewCheckDetailInfo_"、"_TKBTDDesc
					}
				}
			}
			if (OldCheckDetailInfo'=NewCheckDetailInfo){
				i Content="" s Content=childDesc_"由:'"_OldCheckDetailInfo_"'修改为:'"_NewCheckDetailInfo_"'"
				e  s Content=Content_","_childDesc_"由:'"_OldCheckDetailInfo_"'修改为:'"_NewCheckDetailInfo_"'"
			}
		}
	}
	if (NewDiagnosNotesP'=OldDiagnosNotesP){
		i Content="" s Content="属性备注 由:'"_OldDiagnosNotesP_"'修改为:'"_NewDiagnosNotesP_"'"
		e  s Content=Content_","_"属性备注 由:'"_OldDiagnosNotesP_"'修改为:'"_NewDiagnosNotesP_"'"
	}
	if (NewDiagnosDisPlayName'=OldDiagnosDisPlayName){
		i Content="" s Content="属性展示名 由:'"_OldDiagnosDisPlayName_"'修改为:'"_NewDiagnosDisPlayName_"'"
		e  s Content=Content_","_"属性展示名 由:'"_OldDiagnosDisPlayName_"'修改为:'"_NewDiagnosDisPlayName_"'"
	}
	b //90
	Q Content
}

/*ClassMethod GetDoctorInfo(dia) As %String
{
	s result=""
	s DKBBCRowId=0  //属性id
	for   //找到属性名为诊断模板的属性id
	{	
		s DKBBCRowId=$o(^DKBBASCAT(0,"Dia",dia,DKBBCRowId)) q:DKBBCRowId="" 
		s DKBBCDesc=$p($g(^DKBBASCAT(DKBBCRowId)),"^",2)  //描述
		q:(DKBBCDesc="诊断模板")
		 
	}
	;缺省展示效果
	s emptyInfo=""
	s modeJsonInfo=""
	if (DKBBCRowId'="")
	{
		s catInfo=""
		s ExtendId=$o(^DKBDGSEXT(0,"Cat",dia,DKBBCRowId,0))  //扩展表ID
		s ChildrenDr=""  //扩展表的DKBDIEChildrenDr字段存储的内容（属性id的串）
		s:ExtendId'="" ChildrenDr=$p($g(^DKBDGSEXT(ExtendId)),"^",2)
		s:ExtendId'="" emptyInfo=$p($g(^DKBDGSEXT(ExtendId)),"^",6)
		if (ChildrenDr'="")
		{
			  s argsLen=$Length(ChildrenDr,",")
			  for i=1:1:argsLen   
			  {     
			      s idAndShowType=$p(ChildrenDr,",",i)  //属性ID和展示格式
			      s childId=$p(idAndShowType,"&",1)
			      s showType=$p(idAndShowType,"&",2)
			      s childDesc=$p($g(^DKBBASCAT(childId)),"^",2) 
				  s childType=$p($g(^DKBBASCAT(childId)),"^",3)
				  s str=childId_$c(2)_childDesc_$c(2)_childType_$c(2)_showType
				  i modeJsonInfo="" s modeJsonInfo=str
				  e  s modeJsonInfo=modeJsonInfo_$c(1)_str
		  		  //s str="{""childId"": """_childId_""",""childDesc"": """_childDesc_""",""childType"": """_childType_""",""showType"": """_showType_"""}"
		 		  //s:modeJsonInfo'="" modeJsonInfo=modeJsonInfo_","_str
		  		  //s:modeJsonInfo="" modeJsonInfo=str			  	      
			  }
		}
	}
	//s modeJsonInfo="["_modeJsonInfo_"]"
	q DKBBCRowId_"^"_emptyInfo_"^"_modeJsonInfo
}*/

// w ##class(web.DHCMRDiagnos).GetDiagPropertyByRowId(1)

ClassMethod GetDiagPropertyByRowId(DiagRowid As %String) As %String
{
	
	s DiagnosPRowID=$o(^MRi("DIAGP",DiagRowid,""))
	Q:DiagnosPRowID="" ""
	s DiagBaseCatPRowId=$p($g(^MR("DIAGP",DiagnosPRowID)),"^",2)
	Q:DiagBaseCatPRowId="" ""
	//s DKBBCDiaDr=$p($g(^DKBBASCAT(DiagBaseCatPRowId)),"^",5)
	s DKBBCDiaDr=..GetDKBDiagRowId(DiagnosPRowID) //诊断术语ID
	Q:DKBBCDiaDr="" ""
	s TreeCheckedIdStr=$p($g(^MR("DIAGP",DiagnosPRowID)),"^",3)
	s ComboCheckedIdStr=$p($g(^MR("DIAGP",DiagnosPRowID)),"^",4)
	s RadioCheckedIdStr=$p($g(^MR("DIAGP",DiagnosPRowID)),"^",7)
	s CheckBoxCheckedIdStr=$p($g(^MR("DIAGP",DiagnosPRowID)),"^",8)
	s DiagPNotes=$p($g(^MR("DIAGP",DiagnosPRowID)),"^",9)
	s DiagnosDisPlayName=##class(web.DHCMRDiagnosNew).GetDiagFormateDesc(DiagnosPRowID) //$p($g(^MR("DIAGP",DiagnosPRowID)),"^",10)
	s MRDiagnosTypeDr=""
	s DiagStatDr=$p($g(^MR($P(DiagRowid,"||",1),"DIA",$P(DiagRowid,"||",2))),"^",9) //诊断状态
	s MainDiagFlag=$p($g(^MR($P(DiagRowid,"||",1),"DIA",$P(DiagRowid,"||",2),1)),"^",20) //主诊断标志
	s DiagNotes=$g(^MR($P(DiagRowid,"||",1),"DIA",$P(DiagRowid,"||",2),"DES",1)) //诊断注释
	s MRDiagnosTypeDr=""
	s SubRowid=$G(^MR($P(DiagRowid,"||",1),"DIA",$P(DiagRowid,"||",2),"TYP",0))
	if SubRowid'="" s MRDiagnosTypeDr=$G(^MR($P(DiagRowid,"||",1),"DIA",$P(DiagRowid,"||",2),"TYP",SubRowid)) //诊断类型
	s LinkICDRowid=$p($g(^MR($P(DiagRowid,"||",1),"DIA",$P(DiagRowid,"||",2))),"^",1) //关联ICD诊断
	s rtn=DKBBCDiaDr_"^"_TreeCheckedIdStr_"^"_ComboCheckedIdStr_"^"_RadioCheckedIdStr_"^"_CheckBoxCheckedIdStr_"^"_DiagPNotes_"^"_DiagnosDisPlayName_"^"_DiagStatDr
	s rtn=rtn_"^"_MainDiagFlag_"^"_DiagNotes_"^"_MRDiagnosTypeDr_"^"_LinkICDRowid
	Q rtn
}

ClassMethod LookUpBrokerWithAlias(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", val2 As %Library.String = "", val3 As %Library.String = "", DiagSaveLvl As %String = "") As %Library.Boolean
{
	Set rset=##class(%ResultSet).%New("web.DHCMRDiagnos:LookUpWithAlias")
	do rset.Execute(val)
	Set columns = rset.GetColumnCount()
	set row=0
	set ret=""
	While (rset.Next()) {
	    For col = 1:1:columns {
		   i ret="" s ret=rset.GetData(col)
	       e  s ret= ret_"^"_rset.GetData(col)
	    }
	    s row=row+1
	    If row=1 Quit
	}
	d rset.Close()
	if row>0 {
		s retval=itmjs_"('"_$ZCVT(ret,"O","JS")_"');"
		i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(ret,"O","JS")_"');"
		&javascript<#(retval)#>
	}
	Q row
}

ClassMethod LookUpWithAliasClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpWithAliasExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

// d ##class(%ResultSet).RunQuery("web.DHCMRDiagnos","LookUpWithAlias","gm","","","","")

/// 诊断录入的匹配度显示按长度匹配优先显示,即长度短的显示在前面
ClassMethod LookUpWithAliasExecute(ByRef qHandle As %Binary, desc As %String, loc As %String, ver1 As %String, EpisodeID As %String = "", ICDType As %String = "", UserId As %String = "", LimitRows As %String = "", UseDKBFlag As %String = "0") As %Status
{
	;如果是按诊断录入的匹配度显示顺序:按首字母全匹配->按首字母模糊匹配->模糊匹配,则放开下面两句话
	;s CFMRLookUpAlias="Level"
	;Q ..LookUpWithAliasByLevelExecute(qHandle,desc,loc,ver1,EpisodeID,ICDType)
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
    if (desc="") {
	    Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
    s len=$l(desc)
    s control=$e(desc,len)
    i (control="#"){s desc=$e(desc,1,len-1)}
    i UserId="" s UserId=%session.Get("LOGON.USERID")
    s LogHospDr=%session.Get("LOGON.HOSPID")
	s ^guo("LookUpWithAlias")=desc_"^"_loc_"^"_ver1_"^"_EpisodeID_"^"_ICDType_","_LimitRows
	;获取表是公有G ，私有S，管控C，绝对私有A标识
	s ICDDxDataType=##class(DHCDoc.Common.Hospital).GetDataType("MRC_ICDDx")
	Set langid=..%LanguageID()
	kill ^TMPAliasDiagnos($j)
	kill ^TMPAliasDiagnosNew($J)
	//s UseDKBFlag=##class(web.DHCDocConfig).GetConfigNode("UseDDiagnosKB")
	if (desc="")&&(LimitRows'=""){
		s num=0
		k ^||TMPDiagListArr
		if (UseDKBFlag="1") s TableName="User.TKBTrem"
		else  s TableName="User.MRCICDDx"
		s UCCodeTableID=0
		f  s UCCodeTableID=$o(^DHCDOCCTUCi("UserCT",UserId,TableName,UCCodeTableID)) q:UCCodeTableID=""  d
		.s UCRowId=0
		.f  s UCRowId=$o(^DHCDOCCTUCi("UserCT",UserId,TableName,UCCodeTableID,UCRowId)) q:UCRowId=""  d
		..s RecordCount=##class(DHCDoc.Log.DHCDocCTUseCount).GetCount(TableName,UCCodeTableID,UserId,"U")
		..s ^||TMPDiagListArr(RecordCount,UCCodeTableID)=""
		s RecordCount=""
		f  s RecordCount=$o(^||TMPDiagListArr(RecordCount),-1) q:(RecordCount="")||(num>LimitRows)  d
		.s rowid=0
		.f  s rowid=$o(^||TMPDiagListArr(RecordCount,rowid)) q:(rowid="")||(num>LimitRows)  d
		..i TableName="User.TKBTrem" d
		...s TKBTRBRowId=rowid
		...s TKBTRBCode=$p($g(^TKBTREM(TKBTRBRowId)),"^",1)
		...s TKBTRBDesc=$p($g(^TKBTREM(TKBTRBRowId)),"^",2)
		...s strAlias=##class(web.DHCBL.MKB.TKBTremCom).GetComOrAlias(TKBTRBRowId,"A")  
		...s strCom=##class(web.DHCBL.MKB.TKBTremCom).GetComOrAlias(TKBTRBRowId,"C")
		...s comDesc=$p(strCom,"||",1) //常用名
		...s DKBDiAliasStr=""
		...For k=1:1:$l(strAlias,",") d
		...s oneDKBDiAlias=$p(strAlias,",",k)
		....Q:oneDKBDiAlias=""
		....i DKBDiAliasStr="" s DKBDiAliasStr=oneDKBDiAlias
		....e  s DKBDiAliasStr=DKBDiAliasStr_","_oneDKBDiAlias
		...i DKBDiAliasStr'="" s TKBTRBDesc=TKBTRBDesc_","_DKBDiAliasStr
		...s desc1=comDesc_"("_TKBTRBDesc_")"
		...s code=TKBTRBCode
		...s num=num+1
		...Q:(num>LimitRows)
		...d OutputRowNormal
		..e  d
		...s MRCIDValid=$P($G(^MRC("ID",rowid)),"^",27)
		...Q:MRCIDValid="N"
		...s BillFlag3=$P($G(^MRC("ID",rowid)),"^",15)
		...s BillFlag1=$P($G(^MRC("ID",rowid)),"^",13)
		...Q:$d(^TMPAliasDiagnos($j,rowid))
		...Q:(ICDType="0")&&(BillFlag3="Y")
		...Q:(ICDType="1")&&((BillFlag3'="Y")||(BillFlag1="Y"))
		...Q:(ICDType="2")&&((BillFlag3'="Y")||(BillFlag1'="Y"))
		...s DateFrom=$P($G(^MRC("ID",rowid)),"^",6)
		...s DateTo=$P($G(^MRC("ID",rowid)),"^",7)
		...Q:(DateFrom'="")&&(DateFrom>+$H)
		...Q:(DateTo'="")&&(DateTo<+$H)
		...s desc1=$p(^MRC("ID",rowid),"^",2)
		...s desc1 =##class(User.MRCICDDx).GetTranByDesc("MRCIDDesc",desc1,langid)
		...s code=$p(^MRC("ID",rowid),"^",4)
		...s num=num+1
		...Q:(num>LimitRows)
		...d OutputRowNormal
		k ^||TMPDiagListArr
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	if (UseDKBFlag=1){
		s num=0
		//d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.TKBTrem","GetDataForDoc","",19,"tnb")
		s baseId=##class(web.DHCBL.MKB.TKBTrem).GetBaseID("Diagnose")
		Set rset=##class(%ResultSet).%New("web.DHCBL.MKB.TKBTrem:GetDataForDoc")
		If rset.QueryIsValid() { 
			Set Status=rset.Execute("",baseId,desc)
			If 'Status Quit
			Set columns = rset.GetColumnCount()
			While (rset.Next()) {
				Q:(num>10)&&(len=1)
				s DKBDiCom=rset.Data("comDesc") //常用名
				s DKBDiDesc=rset.Data("TKBTRBDesc") //诊断中心词
				s DKBDiAlias=rset.Data("aliasDesc") //别名
				s DKBDiRowId=rset.Data("TKBTRBRowId") //诊断ID
				s DKBDiCode=rset.Data("TKBTRBCode") //诊断Code
				s comKey=rset.Data("TKBTRBPYCode") //拼音码
				s DKBDiAliasStr=""
				For k=1:1:$l(DKBDiAlias,","){
					s oneDKBDiAlias=$p(DKBDiAlias,",",k)
					continue:oneDKBDiAlias=""
					//i DKBDiAliasStr="" s DKBDiAliasStr="别名"_k_":"_oneDKBDiAlias
					//e  s DKBDiAliasStr=DKBDiAliasStr_",别名"_k_":"_oneDKBDiAlias
					i DKBDiAliasStr="" s DKBDiAliasStr=oneDKBDiAlias
					e  s DKBDiAliasStr=DKBDiAliasStr_","_oneDKBDiAlias
				}
				//i DKBDiAliasStr'="" s DKBDiDesc=DKBDiDesc_","_DKBDiAliasStr
				//s desc1=comKey_" "_DKBDiCom_"(诊断中心词:"_DKBDiDesc_")"
				i DKBDiAliasStr'="" s DKBDiDesc=DKBDiDesc_","_DKBDiAliasStr
				s desc1=DKBDiCom_"("_DKBDiDesc_")"
				s rowid=DKBDiRowId
				s code=DKBDiCode
				s num=num+1
				d OutputRowNew2
			}
		}
		d rset.Close()
		Set repid=$I(^CacheTemp)
	    If $g(ind)="" Set ind=1
		s len=0
		f  s len=$o(^TMPAliasDiagnosNew($J,len)) q:len=""  d
		.s rowid=0
		.f  s rowid=$o(^TMPAliasDiagnosNew($J,len,rowid)) q:rowid=""  d
		..Q:$d(^TMPAliasDiagnos($j,rowid))
		..s data=$g(^TMPAliasDiagnosNew($J,len,rowid))
		..s desc1=$list(data,1)
		..s rowid=$list(data,2)
		..s code=$list(data,3)
		..d OutputRowNormal
	}else{
		s DefHospId=##class(DHCDoc.Common.Hospital).GetDefHospIdByTableName("MRC_ICDDx",LogHospDr)
		s Hospital=##Class(web.DHCDocConfig).GetConfigNode("CurrentHospital")
		s HospitalCode=$P(Hospital,"^",1)

		s desc1="",rowid="",code="",PAADMType=""
		i EpisodeID'="" d
		.s PAADMType=$p($g(^PAADM(EpisodeID)),"^",2)
		s Rowid=0
		if (ICDDxDataType="G"){
			for {
				s Rowid=$o(^MRC("ID",Rowid)) q:Rowid="" 
				do GetICDData
			} 
		}else{
			for {
				s Rowid=$o(^User.BDPMappingHospI("DataRef","MRC_ICDDx",DefHospId,Rowid)) q:Rowid=""
				do GetICDData
			} 
		}
		b //45
		s len=0
		f  s len=$o(^TMPAliasDiagnosNew($J,len)) q:len=""  d
		.s desc=0
		.f  s desc=$o(^TMPAliasDiagnosNew($J,len,desc)) q:desc=""  d
		..s rowid=0
		..f  s rowid=$o(^TMPAliasDiagnosNew($J,len,desc,rowid)) q:rowid=""  d
		...s data=$g(^TMPAliasDiagnosNew($J,len,desc,rowid))
		...s desc1=$list(data,1)
		...s rowid=$list(data,2)
		...s code=$list(data,3)
		...d OutputRowNormal
	}
	kill ^TMPAliasDiagnos($j)
	kill ^TMPAliasDiagnosNew($J)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
GetICDData
	Q:'$d(^MRC("ID",Rowid))
	s MRCIDValid=$P($G(^MRC("ID",Rowid)),"^",27)
	Q:MRCIDValid="N"
	s BillFlag3=$P($G(^MRC("ID",Rowid)),"^",15)
	s BillFlag1=$P($G(^MRC("ID",Rowid)),"^",13)
	Q:(ICDType="0")&&(BillFlag3="Y")
	Q:(ICDType="1")&&((BillFlag3'="Y")||(BillFlag1="Y"))
	Q:(ICDType="2")&&((BillFlag3'="Y")||(BillFlag1'="Y"))
	
	s DateFrom=$P($G(^MRC("ID",Rowid)),"^",6)
	s DateTo=$P($G(^MRC("ID",Rowid)),"^",7)
	Q:(DateFrom'="")&&(DateFrom>+$H)
	Q:(DateTo'="")&&(DateTo<+$H)
	s desc=$ZCONVERT(desc,"U")
	s desc1=$p(^MRC("ID",Rowid),"^",2)
	s desc1 =##class(User.MRCICDDx).GetTranByDesc("MRCIDDesc",desc1,langid)
	s desc1=$ZCONVERT(desc1,"U")
	s code=$p(^MRC("ID",Rowid),"^",4)
	s rowid=Rowid
	s MetastaticSite=$P($G(^MRC("ID",rowid)),"^",40) ;Y 肿瘤形态学编码 医生不使用
	s IPCode=$P($G(^MRC("ID",rowid)),"^",41)  ;Injury/Poisoning 损伤中毒外部原因 医生不使用
	Q:(MetastaticSite="Y")||(IPCode="Y")
	Q:$d(^TMPAliasDiagnos($j,rowid))
	i (control="#"){ s len1=$l(desc) s len2=$l(desc1) q:len1'=len2}
	i ((control="#")&&(desc1=desc)) Do OutputRow1
	s length=$l(desc," ")
	s boolean=1
	f index=1:1:length do
	.s indesc=$p(desc," ",index)
	.Q:indesc=""
	.Q:(desc1[(indesc))
	.s boolean=0 
	Q:$d(^TMPAliasDiagnos($j,rowid))
	i (boolean="1") DO OutputRow1
	i ((control'="#")&&(desc1[(desc)))  Do OutputRow1
	e  d
	.s AliasRowid=0 f  s AliasRowid=$o(^MRC("ID",Rowid,"ALIAS",AliasRowid)) q:AliasRowid=""  d
	..s Alias=^MRC("ID",Rowid,"ALIAS",AliasRowid)
	..s Alias=$ZCONVERT(Alias,"U")
	..i (control="#") s len1=$l(desc) s len2=$l(Alias) q:len1'=len2
	..i ((control="#")&&(Alias=desc)) Do OutputRow1
	..s length=$l(desc," ")
	..s boolean=1
	..f index=1:1:length do
	...s indesc=$p(desc," ",index)
	...Q:indesc=""
	...Q:(Alias[(indesc))
	...s boolean=0 
	..i (boolean="1") DO OutputRow1
	..i ((control'="#")&&(Alias[(desc))) Do OutputRow1
	q
OutputRowNormal
	s desc1=$p(^MRC("ID",rowid),"^",2)
	s desc1 =##class(User.MRCICDDx).GetTranByDesc("MRCIDDesc",desc1,langid)
	//Q:$d(^TMPAliasDiagnos($j,rowid))
    set desc1=##class(web.DHCDocUtil).EvalJSON(desc1)
    set Data=$lb(desc1,rowid,code)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	s ^TMPAliasDiagnos($j,rowid)=""
	Quit
OutputRow1
	s desc1=$p(^MRC("ID",rowid),"^",2)
	s desc1 =##class(User.MRCICDDx).GetTranByDesc("MRCIDDesc",desc1,langid)
    i (len=0) {
	    Q:$d(^TMPAliasDiagnos($j,rowid))
	    d OutputRowNormal
	}else {
		d OutputRowNew1
	}
    s ^TMPAliasDiagnos($j,rowid)=""
    Quit
	/*set Data=$lb(desc1,rowid,code)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	s ^TMPAliasDiagnos($j,rowid)=""
	Quit*/
OutputRowNew1
    s ^TMPAliasDiagnosNew($J,$L(desc1),desc1,rowid)=$lb(desc1,rowid,code)
    Quit
OutputRowNew2
	s ^TMPAliasDiagnosNew($J,num,rowid)=$lb(desc1,rowid,code)
	Quit
ResetVariables1
	Set Data=$lb(desc1,rowid,code)
	Quit
}

/// 诊断录入的匹配度显示顺序:按首字母全匹配->按首字母模糊匹配->模糊匹配
ClassMethod LookUpWithAliasByLevelExecute(ByRef qHandle As %Binary, desc As %String, loc As %String, ver1 As %String, EpisodeID As %String = "", ICDType As %String = "") As %Status
{
   
    s len=$l(desc)
    s control=$e(desc,len)
    i (control="#"){s desc=$e(desc,1,len-1)}
   
    
	s ^guo("LookUpWithAlias")=desc_"^"_loc_"^"_ver1_"^"_EpisodeID_"^"_ICDType
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	kill ^TMPAliasDiagnos($j)
	kill ^TMPAliasDiagnosNew($J)
	s Hospital=##Class(web.DHCDocConfig).GetConfigNode("CurrentHospital")
	s HospitalCode=$P(Hospital,"^",1)

	s desc1="",rowid="",code="",PAADMType=""
	i EpisodeID'="" d
	.s PAADMType=$p($g(^PAADM(EpisodeID)),"^",2)
	
	s Rowid=0 f  s Rowid=$o(^MRC("ID",Rowid)) q:Rowid=""  d
	.s BillFlag3=$P($G(^MRC("ID",Rowid)),"^",15)
	.s BillFlag1=$P($G(^MRC("ID",Rowid)),"^",13)
	.Q:(ICDType="0")&&(BillFlag3="Y")
	.Q:(ICDType="1")&&((BillFlag3'="Y")||(BillFlag1="Y"))
	.;w:Rowid=22748 BillFlag3_","_BillFlag1,!
	.Q:(ICDType="2")&&((BillFlag3'="Y")||(BillFlag1'="Y"))
	.
	.s DateFrom=$P($G(^MRC("ID",Rowid)),"^",6)
	.s DateTo=$P($G(^MRC("ID",Rowid)),"^",7)
	.Q:(DateFrom'="")&&(DateFrom>+$H)
	.Q:(DateTo'="")&&(DateTo<+$H)
	.s desc=$ZCONVERT(desc,"U")
	.s desc1=$p(^MRC("ID",Rowid),"^",2)
	.s desc1=$ZCONVERT(desc1,"U")
	.s code=$p(^MRC("ID",Rowid),"^",1)
	.s rowid=Rowid
	.s MetastaticSite=$P($G(^MRC("ID",rowid)),"^",40) ;Y 肿瘤形态学编码 医生不使用
	.s IPCode=$P($G(^MRC("ID",rowid)),"^",41)  ;Injury/Poisoning 损伤中毒外部原因 医生不使用
	.Q:(MetastaticSite="Y")||(IPCode="Y")
	.Q:$d(^TMPAliasDiagnos($j,rowid))
	.s MatchData=desc1
	.s Level=9
	.d OutputRowByLevel
	.s AliasRowid=0 f  s AliasRowid=$o(^MRC("ID",Rowid,"ALIAS",AliasRowid)) q:AliasRowid=""  d
	..s Alias=^MRC("ID",Rowid,"ALIAS",AliasRowid)
	..s Alias=$ZCONVERT(Alias,"U")
	..Q:$d(^TMPAliasDiagnos($j,rowid))
	..s MatchData=Alias
	..d OutputRowByLevel

	kill ^TMPAliasDiagnos($j)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowByLevel
	;如果最后一个字符是=,则走诊断描述或者别名全匹配
	;Level为显示级别,级别越小则越靠前显示
	i (control="=") {
		i (MatchData=desc) s Level=1
		e  q
	}
	i (control'="=") {
		i (MatchData=desc) s Level=1
		e  i ($e(MatchData,1,$l(desc))=desc) s Level=2
		e  i (MatchData[desc) s Level=3
		e  q
	}
	
	
	set Data=$lb(desc1,rowid,code)
	s ind2=ind+100000
	s ind1=Level_ind2
	Set ^CacheTemp(repid,ind1)=Data
	Set ind=ind+1
	s ^TMPAliasDiagnos($j,rowid)=""
	Quit
}

ClassMethod LookUpWithAliasFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpWithAliasExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {			// if there are no more rows, finish fetching
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

ClassMethod MRICDCase(ICDCode As %String, LogDepRowid As %String)
{
 i LogDepRowid="" q
 i ICDCode="" q
 s LocDia=0
 s MRR=""
 f  s LocDia=$o(^DHCLocDiagnoseI("Location",LogDepRowid,LocDia)) q:LocDia=""  d
 .s MRCICD=$p(^DHCLocDiagnose(LocDia),"^",2)
 .i ICDCode=MRCICD s MRR=MRCICD
 i MRR="" q 0
 q MRR
}

ClassMethod UpdateMRDiagnosNote(MRDiagnoseRowid As %String, MRDesc As %String) As %String
{
	SET desc=$LISTBUILD(MRDesc)
	&sql(Update SQLUser.MR_Diagnos set MRDIA_Desc=:desc where MRDIA_Rowid=:MRDiagnoseRowid)
	Q SQLCODE
}

ClassMethod UpdateMRDiagnosNoteBroker(MRDiagnosRowid As %String, MRDesc As %String) As %String
{
	s err=..UpdateMRDiagnosNote(MRDiagnosRowid,MRDesc)
	i ('err) {
		&SQL(Select MRDIA_ICDCode_DR->MRCID_Desc,$LIST(MRDIA_Desc,1) into :ICDDesc,:MRDesc From SQLUser.MR_Diagnos Where MRDIA_Rowid=:MRDiagnosRowid)
		if ('SQLCODE) {
			Q:MRDesc="" ICDDesc
			Q ICDDesc_"**"_MRDesc
		}
	}
	Q ""
}

ClassMethod UpdatePAADM(EpisodeID As %String, AdmPara As %String, PAPMIAddress As %String, PAPMICompany As %String, LogonLocDr As %String) As %String
{
	S ^tempshp("paadm")=AdmPara
	s ReAdmis=$P(AdmPara,"^",1)
	s Specialist=$P(AdmPara,"^",2) ;;特殊人群
	s Subject=$P(AdmPara,"^",3)
	s Weight=$P(AdmPara,"^",4)
	s FirstAdm=$P(AdmPara,"^",5)
	s OutReAdm=$P(AdmPara,"^",6)
	s TransAdm=$P(AdmPara,"^",7)
	s ILI=$P(AdmPara,"^",8)
	s DiagnosValue=$P(AdmPara,"^",9)
	S AdmWay=$P(AdmPara,"^",10)
	s BPSystolic=$P(AdmPara,"^",11)  ;收缩压
	s BPDiastolic=$P(AdmPara,"^",12) ;舒张压
	s PhysiologicalCycle=$P(AdmPara,"^",13) ;生理周期
	s Height=$P(AdmPara,"^",14) ;身高
	s PregnancyLMP=$P(AdmPara,"^",15) ;妇科信息_末次月经
	i PregnancyLMP'="" s PregnancyLMP=##class(websys.Conversions).DateHtmlToLogical(PregnancyLMP)
	s PregnancyG=$P(AdmPara,"^",16) ;妇科信息_孕次
	s PregnancyP=$P(AdmPara,"^",17) ;妇科信息_产次
	s PregnancyA=$P(AdmPara,"^",18) ;妇科信息_流次
	s PregnancyL=$P(AdmPara,"^",19) ;妇科信息_存活
	//孕、产、妇相关科室标志
	s IsGynaecology="0"
	s:$G(LogonLocDr)'="" IsGynaecology=##class(web.DHCDocConfig).GetDHCCTLOCFieldValue(LogonLocDr,27)
	
	if ReAdmis'="" s $p(^PAADM(EpisodeID),"^",56)=ReAdmis 
	e  s $p(^PAADM(EpisodeID),"^",56)=""
	if FirstAdm'="" s $p(^PAADM(EpisodeID),"^",72)="F"
	else  if OutReAdm'="" s $p(^PAADM(EpisodeID),"^",72)="R"
	else  s $p(^PAADM(EpisodeID),"^",72)=""
	
	if TransAdm'="" s $p(^PAADM(EpisodeID,"DHC"),"^",5)="Y" 
	e  s $p(^PAADM(EpisodeID,"DHC"),"^",5)=""
	if ILI'="" s $p(^PAADM(EpisodeID,"DHC"),"^",13)="Y" 
	e  s $p(^PAADM(EpisodeID,"DHC"),"^",13)=""
	
	s MRAdmID=$p($g(^PAADM(EpisodeID)),"^",61)
	if (MRAdmID'="") {
		//if Weight'="" s $p(^MR(MRAdmID,"PRO",1),"^",27)=Weight
		s $p(^MR(MRAdmID,"PRO",1),"^",27)=Weight
		s $p(^MR(MRAdmID,"DHC"),"^",8)=Specialist
		s $p(^MR(MRAdmID,"DHC"),"^",9)=PhysiologicalCycle
		if (IsGynaecology="1"){
			&sql(Update SQLUser.MR_Adm(MRADM_BPSystolic,MRADM_BPDiastolic,MRADM_Height,MRADM_Pregnancy_LMP) 
				Values(:BPSystolic,:BPDiastolic,:Height,:PregnancyLMP) Where MRADM_RowId=:MRAdmID)
		}else{
			&sql(Update SQLUser.MR_Adm(MRADM_BPSystolic,MRADM_BPDiastolic,MRADM_Height) 
				Values(:BPSystolic,:BPDiastolic,:Height) Where MRADM_RowId=:MRAdmID)
		}
	}
	
	S AdmWayID=..GetDPAWId(AdmWay)
	S $p(^PAADM(EpisodeID,2),"^",47)=AdmWayID
	
	s PatientID=$p($g(^PAADM(EpisodeID)),"^",1)
	Q:PatientID="" 0
	
	if (IsGynaecology="1"){
		&sql(Update SQLUser.PA_PatMas(PAPMI_Pregnancy_G,PAPMI_Pregnancy_P,PAPMI_Pregnancy_A,PAPMI_Pregnancy_L) 
			Values(:PregnancyG,:PregnancyP,:PregnancyA,:PregnancyL) Where PAPMI_RowId=:PatientID)
	}
	i PAPMIAddress'="Hidden" s ^PAPER(PatientID,"PER","ADD",1)=PAPMIAddress
	i PAPMICompany'="Hidden" s $p(^PAPER(PatientID,"PER",4),"^",18)=PAPMICompany
	Q 0
}

/// creator:gurongyong
/// date:2011-07-06
/// desc:得到诊断状态,
ClassMethod GetDiagnosStatus() As %String
{
	s retStr=""
	s DstatRowid=0
	for {
		s DstatRowid=$O(^MRC("DSTAT",DstatRowid))
		Q:DstatRowid=""
		s Code=$p($g(^MRC("DSTAT",DstatRowid)),"^",1)
		s Desc=$p($g(^MRC("DSTAT",DstatRowid)),"^",2)
		i retStr="" s retStr=DstatRowid_$C(1)_Desc
		e  s retStr=retStr_"^"_DstatRowid_$C(1)_Desc
	}
	Q retStr
}

/// creator:gurongyong
/// date:2010-08-02
/// desc:新诊断录入中存在此方法,但标准库没有,现预留此方法，根据医院，待使用
ClassMethod InsuPatTypeCheck(EpisodeID As %String)
{
	Q 0
}

/// creator:gurongyong
/// date:2011-09-20
/// desc:更新初诊,复诊方式	肿瘤
ClassMethod UpdateAdmWay(Val As %String, EpisodeID As %String)
{
	Q:EpisodeID=""
	s $P(^PAADM(EpisodeID,"DHC"),"^",15)=Val
}

/// creator:gurongyong
/// date:2011-09-20
/// desc:得到初诊,复诊方式	肿瘤
ClassMethod GetAdmWay(EpisodeID As %String) As %String
{
	Q:EpisodeID="" ""
	s Val=$P(^PAADM(EpisodeID,"DHC"),"^",15)
	
	Q Val
}

Query GetHistoryMRDiagnose(PatientID As %String, ICDType As %String = "") As %Library.Query(CONTAINID = 0, ROWSPEC = "Rowid:%String,Desc:%String,MRDesc:%String") [ SqlProc ]
{
}

Query GetLocICD(LocRowid As %String, ICDType As %String = "") As %Query(CONTAINID = 0, ROWSPEC = "Desc:%String,Rowid:%String,Code:%String") [ SqlProc ]
{
}

Query LookUpWithAlias(desc As %String, loc As %String, ver1 As %String, EpisodeID As %String, ICDType As %String, UserId As %String = "", LimitRows As %String = "", UseDKBFlag As %String = "0") As %Library.Query(CONTAINID = 0, ROWSPEC = "desc:%String:描述,HIDDEN:%String,code:%String") [ SqlProc ]
{
}

Query SearchSyndSign(Alais As %String) As %Query(ROWSPEC = "rowid:%String,SyDesc:%String")
{
}

ClassMethod SearchSyndSignFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchSyndSignExecute ]
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

ClassMethod SearchSyndSignExecute(ByRef qHandle As %Binary, Alais As %String) As %Status
{
 Set repid=$I(^CacheTemp)
 If $g(ind)="" Set ind=1
 ;if Alais=""  Set qHandle=$lb(0,repid,0) Quit $$$OK
 s rowid="0"
 f  s rowid=$o(^MRC("DSYM",rowid))  q:rowid=""  d
 .s TDSYMCode=$p(^MRC("DSYM",rowid),"^",1)
 .s TDSYMDesc =$p(^MRC("DSYM",rowid),"^",2)
 .;加入截止日期限制.有效标志是否表示可以维护还是是否可以使用？
 .s DSYMDateFrom=$p(^MRC("DSYM",rowid),"^",5)
 .s DSYMDateTo=$p(^MRC("DSYM",rowid),"^",6)
 .Q:(DSYMDateFrom'="")&&(DSYMDateFrom>+$H)
 .Q:(DSYMDateTo'="")&&(DSYMDateTo<+$H)
 .s DSYMActiveInActive=$p(^MRC("DSYM",rowid),"^",7)
 .Q:DSYMActiveInActive="N"
 .s alsdata=""
 .s cld="" f  s cld=$o(^MRC("DSYM",rowid,"ALIAS",cld)) q:cld=""  d
 ..q:cld=0
 ..s als=$p(^MRC("DSYM",rowid,"ALIAS",cld),"^",1)
 ..s alsdata=alsdata_"^"_als
 .s alsdata=alsdata_"^"_TDSYMDesc_"^"_TDSYMCode
 .q:(alsdata'[Alais)&&(Alais'="")
 .d OutputRow6
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow6
 set Data=$lb(rowid,TDSYMDesc)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 Quit
}

ClassMethod SearchSyndSignClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchSyndSignExecute ]
{
	 Set repid=$LIST(qHandle,2)
     Kill ^CacheTemp(repid)
 	 Quit $$$OK
}

/// creator:zhanglijun
/// date:2013-01-15
/// desc:更新发病日期  温岭
/// Private:Salute the boss upstairs
ClassMethod UpdateOnsetDate(MRDiagnosRowidStr As %String, OnsetDate As %String)
{
	Q:MRDiagnosRowidStr="" 0
	Q:OnsetDate="" 0
	s OnsetDate=##class(websys.Conversions).DateHtmlToLogical(OnsetDate) //$zdh(OnsetDate,3)
	for i=1:1:$length(MRDiagnosRowidStr,"^"){
		s MRDiagnosRowid=$p(MRDiagnosRowidStr,"^",i)
		s MRADMID=$P(MRDiagnosRowid,"||",1)
		s MRDIAChild=$P(MRDiagnosRowid,"||",2)
		;s $P(^MR(MRADMID,"PRO",1),"^",68)=OnsetDate	       //MR_Adm表中的发病日期
		s $P(^MR(MRADMID,"DIA",MRDIAChild),"^",35)=OnsetDate  //MR_Diagnos表中的发病日期
	}
	q 0
}

/// 描述：通过病人的就诊id来得到病人的住院状态
/// w ##class(web.DHCMRDiagnos).CheckAdd("76")
ClassMethod CheckAdd(EpisodeID As %String) As %String
{
	s VisitStatus="",EpisodeType="",PaadmDate="",HaveMidDischarged=0,CurrentDischargeStatus=""
	//s now=+$h
	i EpisodeID'="" {
		 s VisitStatus=$P($g(^PAADM(EpisodeID)),"^",20)
		 s EpisodeType=$P($G(^PAADM(EpisodeID)),"^",2)
		 s PaadmDate=$P($G(^PAADM(EpisodeID)),"^",6)
		 if (EpisodeType="I"){
			 s HaveMidDischarged=##class(web.DHCDocOrderCommon).GetIsMidDischarged(EpisodeID)
		     s CurrentDischargeStatus=##class(web.DHCDischargeHistory).GetCurrentDischargeStatus(EpisodeID)
		 }
		 if (EpisodeType="E"){
			;1:当前状态为留观,2:曾经留观但当前非留观,-1:非留观
	 		s GetStayStatusFlag=##class(web.DHCADMVisitStat).GetStayStatus(EpisodeID)
	 		s VisitStatus=$p($g(^PAADM(EpisodeID)),"^",20)
	 		i (" 1 2 "[(" "_GetStayStatusFlag_" "))&&(VisitStatus="D") {
		 		Q "Discharged"
		 	}
		}
		 
	}
	Q:(HaveMidDischarged="1")&&(CurrentDischargeStatus'="B")&&(EpisodeType="I") "Discharged"
	Q:((VisitStatus="D")&&(EpisodeType="I")) "Discharged"
	Q:((VisitStatus="C")&&(EpisodeType="I")) "Cancel"
	Q:((VisitStatus="C")&&(EpisodeType'="I")) "OPCancel"
	;Q:((PaadmDate<now)&&(EpisodeType'="I")) "Timeout"
	Q ""
}

/// Creator   : shp
/// date      : 2013-05-17
/// desc      : get rowid by code
/// table     : PAC_ReAdmissionToRehab
/// debugger  : w ##class(web.DHCMRDiagnos).GetDPAWId("ZZ")
ClassMethod GetDPAWId(code As %String) As %String
{
	q:$g(code)="" ""
	s code=$ZCONVERT(code,"U")
	s rowid=$o(^PAC("RTR",0,"Code",code,0))
	q rowid
}

/// 查询诊断类型
Query GetDiagnosTypeList(AdmType As %String = "") As %Query(ROWSPEC = "DTYPRowid:%String,DTYPDesc:%String,selected:%Boolean")
{
}

ClassMethod GetDiagnosTypeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDiagnosTypeListExecute ]
{
	Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetDiagnosTypeListExecute(ByRef qHandle As %Binary, AdmType As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCMRDiagnosNew","GetDiagnosTypeList","O")
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s IPDedfaultDiagnosTypeID=$O(^MRC("DTYP",0,"Code","M",0))
	s OPDedfaultDiagnosTypeID=$O(^MRC("DTYP",0,"Code","OP",0))
    s DiagnosTypeStr=##class(web.DHCDocDiagnosNew).GetDiagnosType(AdmType)
    For i=1:1:$l(DiagnosTypeStr,"^") d
    .s OneDiagnosTypeStr=$p(DiagnosTypeStr,"^",i)
    .s DTYPRowid=$p(OneDiagnosTypeStr,$c(1),1)
    .s DTYPDesc=$p(OneDiagnosTypeStr,$c(1),2)
    .s selected=0
    .if (AdmType="I")&&(DTYPRowid=IPDedfaultDiagnosTypeID) s selected=1
    .e  i (DTYPRowid=OPDedfaultDiagnosTypeID) s selected=1
	.Do OutputRow4
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow4
	set Data=$lb(DTYPRowid,DTYPDesc,selected)  
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
ResetVariables4
	set (DTYPRowid,DTYPDesc,selected)=""
	quit
}

ClassMethod GetDiagnosTypeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDiagnosTypeListExecute ]
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

// 导诊单里面的诊断取本科室诊断

ClassMethod GetMRDiagnosDescNew(MRAdmRowid As %String, DelimStr As %String, logonLoc As %String) As %String
{
	s retval=""
	s i=0
	Set obj=##class(%ResultSet).%New("web.MRDiagnos:Find")
	d obj.Execute(MRAdmRowid)
	For  Quit:'obj.Next()  Do
	.s Desc=obj.Data("MRDIAICDCodeDRDesc")
	.s Rowid=obj.Data("ID")
	.s MRDIAAddLocDR=$p($g(^MR(+Rowid,"DIA",$p(Rowid,"||",2)),1),"^",20)
	.Q:(MRDIAAddLocDR'=logonLoc)
	.s CodeRowid=obj.Data("MRDIAICDCodeDR")
	.s MRDesc=obj.Data("MRDIADesc")
	.s MRStatus=""
	.s MRStatusRowid=$p($g(^MR(+Rowid,"DIA",$p(Rowid,"||",2))),"^",9)
	.i MRStatusRowid'="" s MRStatus=$p($g(^MRC("DSTAT",MRStatusRowid)),"^",2)
 	.if MRDesc'="" s MRDesc=$LIST(MRDesc,1)
	.i Desc="" s Desc=MRDesc
	.e  d
	..i MRDesc'="" s Desc=Desc_"("_MRDesc_")"
	.i Desc'="" s Desc=Desc_"  "_MRStatus
	.s i=i+1
	.s Desc=i_"."_Desc
	.if retval="" s retval=Desc
	.e  s retval=retval_DelimStr_Desc
	d obj.Close()
	q $ZCVT(retval,"O","JS")
}

// 判断ICD诊断是否有效 可扩充

ClassMethod CheckICDIsEnabled(ICDRowid As %String, EpisodeID As %String, HospId As %String = "") As %String
{
	s ^tempscl("CheckICDIsEnabled")=ICDRowid_","_EpisodeID
	s HospId=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	if (EpisodeID'="") {
	    s AdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
	}else{
		s AdmType=""
	}
	Set langid=..%LanguageID()
	s ICDRowid=+ICDRowid
	q:ICDRowid="" ""
	q:'$D(^MRC("ID",ICDRowid)) ""
	s ICDDesc=$p(^MRC("ID",ICDRowid),"^",2)
	s ICDDesc =##class(User.MRCICDDx).GetTranByDesc("MRCIDDesc",ICDDesc,langid)
	Q:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("MRC_ICDDx",ICDRowid,HospId)="N" ICDDesc_..%Translate("diagnosentry.v8.csp"," 诊断在该登录院区没有权限!")
	s DateFrom=$P($G(^MRC("ID",ICDRowid)),"^",6)
	s DateTo=$P($G(^MRC("ID",ICDRowid)),"^",7)
	s ValidFlag=$p(^MRC("ID",ICDRowid),"^",27)
	Q:(DateFrom'="")&&(DateFrom>+$H) ICDDesc_..%Translate("diagnosentry.v8.csp"," 诊断未到有效开始日期!")
	Q:((DateTo'="")&&(DateTo<+$H))||(ValidFlag'="Y") ICDDesc_..%Translate("diagnosentry.v8.csp"," 诊断已停用!")
	s MetastaticSite=$P($G(^MRC("ID",ICDRowid)),"^",40) ;Y 肿瘤形态学编码 医生不使用
	Q:(MetastaticSite="Y") "肿瘤形态学编码,医生不可使用!"
	s IPCode=$P($G(^MRC("ID",ICDRowid)),"^",41)  ;Injury/Poisoning 损伤中毒外部原因 医生不使用
	Q:(IPCode="Y") "损伤中毒外部原因诊断,医生不可使用!"
	;ICD诊断限制就诊类型
	s AvailableType=$p($G(^MRC("ID",ICDRowid)),"^",47)
	Q:(AdmType'="")&&(AvailableType'="")&&((","_AvailableType_",")'[(","_AdmType_",")) ICDDesc_..%Translate("diagnosentry.v8.csp"," 诊断限制该就诊类型不可用！")
	if EpisodeID'=""{
		s CheckSexRtn=..CheckDiagRequireSex(EpisodeID,ICDRowid)
		q:CheckSexRtn'="" ICDDesc_":"_..%Translate("diagnosentry.v8.csp",CheckSexRtn)
		s CheckAgeRtn=..CheckDiagRequireAge(EpisodeID,ICDRowid)
		q:CheckAgeRtn'="" ICDDesc_":"_..%Translate("diagnosentry.v8.csp",CheckAgeRtn)
	}
	q ""
}

// 返回病人是否符合该诊断标识

ClassMethod CheckDiagRequireSex(EpisodeID, ICDRowid) As %String
{
	s PatSex="",DiagsexDesc=""
	Set langid=..%LanguageID()
    s PapmiDr=$p($g(^PAADM(EpisodeID)),"^",1)
    s PatSex=$p($g(^PAPER(PapmiDr,"ALL")),"^",7)
    s:PatSex'="" PatSexDesc=$p(^CT("SEX",PatSex),"^",2)
    s PatSexDesc=##class(User.CTSex).GetTranByDesc("CTSEXDesc",PatSexDesc,langid)
    s Diagsex=$p($g(^MRC("ID",ICDRowid)),"^",10)
    s:Diagsex'="" DiagsexDesc=$p(^CT("SEX",Diagsex),"^",2)
    s DiagsexDesc=##class(User.CTSex).GetTranByDesc("CTSEXDesc",DiagsexDesc,langid)
    q:(Diagsex'="")&&(PatSex'=Diagsex) ..%Translate("diagnosentry.v8.csp","该病人性别为：")_PatSexDesc_","_..%Translate("diagnosentry.v8.csp","诊断约束性别为：")_DiagsexDesc_","_..%Translate("diagnosentry.v8.csp","请重新选择诊断！")
    q ""
}

/// w ##class(web.DHCMRDiagnos).CheckDiagRequireAge(1,11)
ClassMethod CheckDiagRequireAge(EpisodeID, ICDRowid) As %String
{
	s AgeFrom=$p($g(^MRC("ID",ICDRowid)),"^",8)
	s AgeTo=$p($g(^MRC("ID",ICDRowid)),"^",9)
	Q:(AgeFrom="")&&(AgeTo="") ""
	s PatientID=$P(^PAADM(EpisodeID),"^",1)
	s PatDob=$P(^PAPER(PatientID,"ALL"),"^",6)
	if (PatDob=""){
		;三无病人不判断年龄限制允许开
		if ..%IsValidMethod("web.DHCEMInterfaceCom","IsThreeNotsPat"){
			Q:##class(web.DHCEMInterfaceCom).IsThreeNotsPat(EpisodeID) ""
		}
		Q ..%Translate("diagnosentry.v8.csp","该患者年龄为空,需先完善患者基本信息")
	}
	s HospID=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(EpisodeID)
	s PatAgeFrom="",PatAgeTo=""
	s LimitMsg=""
	if AgeFrom'=""{
		s AgeFromType=$ZCVT($p($g(^MRC("ID",ICDRowid)),"^",53),"U")
		s LimitMsg=LimitMsg_..%Translate("diagnosentry.v8.csp","最小年龄为:",langid)_AgeFrom_..%Translate("diagnosentry.v8.csp",$CASE(AgeFromType,"Y":"岁","M":"月","D":"天"))
		s PatAgeFrom=##class(web.DHCBillInterface).GetPapmiAge(PatientID,"",HospID,"","",AgeFromType)
	}
	if AgeTo'=""{
		s AgeToType=$ZCVT($p($g(^MRC("ID",ICDRowid)),"^",54),"U")
		s LimitMsg=LimitMsg_..%Translate("diagnosentry.v8.csp",",最大年龄为:",langid)_AgeTo_..%Translate("diagnosentry.v8.csp",$CASE(AgeToType,"Y":"岁","M":"月","D":"天"))
		s PatAgeTo=##class(web.DHCBillInterface).GetPapmiAge(PatientID,"",HospID,"","",AgeToType)
	}
	Q:((AgeFrom="")||(PatAgeFrom>=AgeFrom))&&((AgeTo="")||(PatAgeTo<=AgeTo)) ""
	Q ..%Translate("diagnosentry.v8.csp","该诊断限制")_LimitMsg
}

ClassMethod GetDiagProChangeLogListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDiagProChangeLogListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query GetDiagProChangeLogList(DiagPRowId As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "DiagPLRowID:%String,DiagPLContent:%String,DiagPLUser:%String,DiagPLUpdateDate:%String,DiagPLUpdateTime:%String") [ SqlProc ]
{
}

ClassMethod GetDiagProChangeLogListExecute(ByRef qHandle As %Binary, DiagPRowId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	if (DiagPRowId=""){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s DiagPChildSub=""
    f  s DiagPChildSub=$o(^MR(DiagPRowId,"DIAGPL",DiagPChildSub),-1) q:DiagPChildSub=""  d
    .s DiagPLRowID=DiagPRowId_"||"_DiagPChildSub
    .s DiagPLContent=$p(^MR(DiagPRowId,"DIAGPL",DiagPChildSub),"^",1)
    .s DiagPLContent=##class(web.DHCDocUtil).EvalJSON(DiagPLContent)
    .s DiagPLUserDr=$p(^MR(DiagPRowId,"DIAGPL",DiagPChildSub),"^",2)
    .q:DiagPLUserDr=""
    .s DiagPLUser=""
    .i DiagPLUserDr'="" s DiagPLUser=$p($g(^SSU("SSUSR",DiagPLUserDr)),"^",2)
    .s DiagPLUpdateDate=$p(^MR(DiagPRowId,"DIAGPL",DiagPChildSub),"^",3)
    .i DiagPLUpdateDate'="" s DiagPLUpdateDate=##class(websys.Conversions).DateLogicalToHtml(DiagPLUpdateDate)
    .s DiagPLUpdateTime=$p(^MR(DiagPRowId,"DIAGPL",DiagPChildSub),"^",4)
    .i DiagPLUpdateTime'="" s DiagPLUpdateTime=$zt(DiagPLUpdateTime,1)
    .d OutputRowLogList
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowLogList
    set Data=$lb(DiagPLRowID,DiagPLContent,DiagPLUser,DiagPLUpdateDate,DiagPLUpdateTime)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod GetDiagProChangeLogListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDiagProChangeLogListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {			// if there are no more rows, finish fetching
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

// TKBTRBRowid术语字典表id

// TKB_TremCom 术语常用名/别名字典表

// w ##class(web.DHCMRDiagnos).GetDiagDisPlayName(688,"鼻外")

ClassMethod GetDiagDisPlayName(TKBTRBRowid As %String, desc As %String) As %String
{
	q:(desc="")||(TKBTRBRowid="") ""
	s Find=0
	s Rtn1=""
	//常用名匹配
	s TKBTRCRowid=0
	for{
		s TKBTRCRowid=$o(^TKBTRECOMi(0,"Tre","C",TKBTRBRowid,TKBTRCRowid))
		q:TKBTRCRowid=""
		s TKBTRCDesc=$p(^TKBTRECOM(TKBTRCRowid),"^",3)
		if (TKBTRCDesc[desc){
			s Find=1
		}
		i Rtn1="" s Rtn1="{""TKBTDRowId"":"""_TKBTRCRowid_""",""TKBTDDesc"":"""_TKBTRCDesc_"""}"
		e  s Rtn1=Rtn1_","_"{""TKBTDRowId"":"""_TKBTRCRowid_""",""TKBTDDesc"":"""_TKBTRCDesc_"""}"
	}
	Q:Find=1 "["_Rtn1_"]"
	s Rtn2=""
	//中心词匹配
	s TKBTRBDesc=$p(^TKBTREM(TKBTRBRowid),"^",2)
	if (TKBTRBDesc[desc){
		s Find=1
	}
	s Rtn2="{""TKBTDRowId"":"""_TKBTRBRowid_""",""TKBTDDesc"":"""_TKBTRBDesc_"""}"
	Q:Find=1 "["_Rtn2_"]"
	s Rtn3=""
	//别名匹配
	s TKBTRCRowid=0
	for{
		s TKBTRCRowid=$o(^TKBTRECOMi(0,"Tre","A",TKBTRBRowid,TKBTRCRowid))
		q:TKBTRCRowid=""
		s TKBTRCDesc=$p(^TKBTRECOM(TKBTRCRowid),"^",3)
		if (TKBTRCDesc[desc){
			s Find=1
		}
		i Rtn3="" s Rtn3="{""TKBTDRowId"":"""_TKBTRCRowid_""",""TKBTDDesc"":"""_TKBTRCDesc_"""}"
		e  s Rtn3=Rtn3_","_"{""TKBTDRowId"":"""_TKBTRCRowid_""",""TKBTDDesc"":"""_TKBTRCDesc_"""}"
	}
	Q:Find=1 "["_Rtn3_"]"
	Q:Rtn1'="" "["_Rtn1_"]"
	Q:Rtn2'="" "["_Rtn2_"]"
	Q:Rtn3'="" "["_Rtn3_"]"
}

/// 判断是否是中医诊断
ClassMethod CheckIsCNICD(rowid As %String) As %String
{
	s BillFlag3=$P($G(^MRC("ID",rowid)),"^",15)
    s BillFlag1=$P($G(^MRC("ID",rowid)),"^",13)
	Q:((BillFlag3="Y")||(BillFlag1="Y")) "1"
	Q 0
}

}
