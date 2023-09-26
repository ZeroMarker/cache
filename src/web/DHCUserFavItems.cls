Import SQLUser

Class web.DHCUserFavItems Extends DHCDoc.Util.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod Delete(ID As %String) As %String
{
	&SQL(Delete From SQLUSER.DHC_UserFavItems Where Fav_Rowid=:ID)
	Q:SQLCODE -1
	Q:SQLCODE
}

ClassMethod DeleteUserARCOS(FavRowid) As %String
{
	s ^RP("FavRowid")=FavRowid
	;w ##class(web.DHCUserFavItems).DeleteUserARCOS("15")
	;d TStart
	Q:FavRowid="" "-1"
	s err="-1"
	s ARCOSRowid=""
	s ARCOSRowid=$P($g(^DHCFavItems(FavRowid)),"^",3)
	i (ARCOSRowid="") {
		q err
	}
	s ARCOSName=$p($g(^ARCOS(+ARCOSRowid)),"^",2)
	set OldDataJson=##class(web.DHCDocDataChangeLog).GetLogJsonData("User.ARCOrdSets"_$c(2)_ARCOSRowid)
	set FavOldDataJson=##class(web.DHCDocDataChangeLog).GetLogJsonData("User.DHCUserFavItems"_$c(2)_FavRowid)
	TS
	&SQL(delete from SQLUSER.DHC_UserFavItems Where Fav_Rowid=:FavRowid)
	i SQLCODE {
		Trollback
		Q err
	}
	s err=##Class(web.DHCARCOrdSets).DeleteARCOS(ARCOSRowid)
	TC
	;医生站业务数据修改日志
	d ##class(web.DHCDocDataChangeLog).SaveLog("ARC_OrdSets","User.ARCOrdSets","医嘱套信息","User.ARCOrdSets_"_ARCOSRowid,ARCOSName,"D","",OldDataJson)
	d ##class(web.DHCDocDataChangeLog).SaveLog("DHC_UserFavItems","User.DHCUserFavItems","医嘱套信息","User.DHCUserFavItems_"_FavRowid,ARCOSName,"D","",FavOldDataJson)
	
	
	
	Q err
}

ClassMethod FindItemsInSetClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindItemsInSetFetch ]
{
}

ClassMethod FindItemsInSetExecute(ByRef qHandle As %Binary, ID As %String) As %Status
{
}

ClassMethod FindItemsInSetFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindItemsInSetExecute ]
{
}

ClassMethod FindUserOrderSetClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindUserOrderSetExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCUserFavItems","FindUserOrderSet","4634","","","","","","","","","","医嘱套","2")
ClassMethod FindUserOrderSetExecute(ByRef qHandle As %Binary, UserID As %String, QueryFlag As %String, ForQueryUserID As %String, ForQueryLocID As %String, status As %String, Conditiones As %String, DocMedUnit As %String, subCatID As %String, Code As %String, Desc As %String, Alias As %String, LogonHospID As %String, HospARCOSAuthority As %String = "", paraCelerType As %String = "", LogonHospDr As %String = "", CTLOCROWID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	;s Conditiones=1
	//s:Conditiones="" Conditiones=1
	if UserID="" s UserID=%session.Get("LOGON.USERID")
	if LogonHospDr="" s LogonHospDr=%session.Get("LOGON.HOSPID")
	s Code=$ZCVT(Code,"U")
	s Desc=$ZCVT(Desc,"U")
	s Alias=$ZCVT(Alias,"U")

	if CTLOCROWID="" S CTLOCROWID=%session.Get("LOGON.CTLOCID")
	s FavUserList=ForQueryUserID  s FavDepList=ForQueryLocID 
	s FavRowid="",FavRowidOut="",FavItemRowid="",FavUserDr="",FavUserDesc="",FavDepDesc=""
	s ARCOSRowid="",ARCOSCode="",ARCOSDesc="",ARCOSOrdCat=""
	s ARCOSOrdSubCat="",ARCOSEffDateFrom="",ARCOSOrdCatDR=""
	s ARCOSOrdSubCatDR="",FavRowid="",ARCOSAlias="",CelerType="N"
	s PrescTypeCode="",DuratId="",FreqId="",InstrId="",DosageId="",Notes=""
	s UserNumber=$p(^SSU("SSUSR",UserID),"^",1)
	set RowCount=0
	s NO=0
	
 &SQL(DECLARE EmpCursor CURSOR FOR
 Select A.ARCOS_Rowid,A.ARCOS_Code,A.ARCOS_Desc,A.ARCOS_OrdCat_DR->ORCAT_Desc,
 A.ARCOS_OrdSubCat_DR->ARCIC_Desc,A.ARCOS_EffDateFrom,A.ARCOS_OrdCat_DR,
 A.ARCOS_OrdSubCat_DR,B.Fav_Rowid ,B.Fav_User_Dr,B.Fav_ItemRowid,
 B.Fav_Dep_Dr,B.Fav_MedUnit_Dr,
 A.ARCOS_PrescTypeCode,A.ARCOS_DurationDR,A.ARCOS_FrequencyDR,A.ARCOS_Instr_DR,A.ARCOS_InstrLinkDosage_DR,
 A.ARCOS_Notes,B.Fav_CelerType,B.Fav_Hosp_Dr
 into :ARCOSRowid,:ARCOSCode,:ARCOSDesc,:ARCOSOrdCat,:ARCOSOrdSubCat,
	  :ARCOSEffDateFrom,:ARCOSOrdCatDR,:ARCOSOrdSubCatDR,:FavRowidOut,:FavUserDr,:FavItemRowid,
	  :FavDepDr,:FavMedUnitDr,
	  :PrescTypeCode,:DuratId,:FreqId,:InstrId,:DosageId,:Notes,:CelerType,:FavHospDr
 From SQLUser.DHC_UserFavItems B LEFT JOIN SQLUser.ARC_OrdSets A ON A.ARCOS_Rowid=B.Fav_ItemRowid
 and B.Fav_UseHosp_Dr=:LogonHospDr
 order by ARCOS_Rowid desc)
 &SQL(OPEN EmpCursor)
 for  &SQL(FETCH EmpCursor) QUIT:SQLCODE  do
 .q:(paraCelerType="Y")&&(CelerType'="Y")
 .q:(FavUserDr'="")&&(##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("SS_User",FavUserDr,LogonHospDr)="N")
 .q:(FavDepDr'="")&&($p(^CTLOC(FavDepDr),"^",22)'=LogonHospDr)
 .s HospArcosFlag=0
 .if (FavUserDr="")&&(FavDepDr="")&&(FavMedUnitDr="") s HospArcosFlag=1
 .if (HospARCOSAuthority="1")&&(Conditiones="") s HospArcosFlag=1
 .q:(Conditiones="")&&(FavUserDr'=UserID)&&(FavDepDr'=CTLOCROWID)&&(HospArcosFlag=0)
 .//if (Conditiones="") q
 .//s MedUnit=FavMedUnitDr  //组ID
 .//个人
 .if (Conditiones="1") q:(FavUserDr'=UserID)||(FavMedUnitDr'="")
 .//科室
 .//if (Conditiones="2") q:((FavDepDr'=CTLOCROWID)&&(ARCOSDesc'[UserNumber))||(FavDepDr="")||(FavDepDr=0)
 .if (Conditiones="2") q:(FavDepDr'=CTLOCROWID)||(FavDepDr="")||(FavDepDr=0)
 .if (Conditiones="3") q:FavUserDr'=""
 .if (Conditiones="3") q:FavDepDr'=""
 .if (Conditiones="3") q:FavMedUnitDr'=""
 .if (Conditiones="3") Q:FavHospDr'=LogonHospDr
 .if (Conditiones="4") q:(FavMedUnitDr'=DocMedUnit)
 .s MedUnitDesc=""
 .if (FavMedUnitDr'="")  s MedUnitDesc=..GetMedUnitDesc(FavMedUnitDr) //组描述
 .s ARCOSAliasRowid=$O(^ARC("ALIAS",0,"ARCOS",ARCOSRowid,0))
 .if ARCOSAliasRowid'="" d 
 ..s ARCOSAlias=$P(^ARC("ALIAS",ARCOSAliasRowid),"^",6)
 .s FavUserDesc="",FavDepDesc=""
 .IF FavUserDr'="" s FavUserDesc=$p($g(^SSU("SSUSR",FavUserDr)),"^",2)
 .if FavDepDr'="" s FavDepDesc=$p($g(^CTLOC(FavDepDr)),"^",2) s FavDepDesc=##class(web.DHCOPAdmReg).LocDescFormate(FavDepDesc)
 .q:(subCatID'="")&&((ARCOSOrdSubCat'=subCatID)&&(ARCOSOrdSubCatDR'=subCatID))
 .q:(Code'="")&&($ZCVT(ARCOSCode,"U")'[Code)
 .q:(Desc'="")&&($ZCVT(ARCOSDesc,"U")'[Desc)
 .q:(Alias'="")&&($ZCVT(ARCOSAlias,"U")'[Alias)
 .s OrdSetPrice="包装价格"
 .s ARCOSAddUserDr=$p(^ARCOS(ARCOSRowid),"^",29)
 .IF ARCOSAddUserDr'="" s ARCOSAddUser=$p($g(^SSU("SSUSR",ARCOSAddUserDr)),"^",2)
 .s ARCOSAddDate=$p(^ARCOS(ARCOSRowid),"^",30)
 .s ARCOSAddTime=$p(^ARCOS(ARCOSRowid),"^",31)
 .i ARCOSAddTime'=""  s ARCOSAddTime=..%ZT(ARCOSAddTime,1)
 .i ARCOSAddDate'="" s ARCOSAddDate=..%ZD(ARCOSAddDate)_" "_ARCOSAddTime
 .Do OutputRow2
 &SQL(Close EmpCursor)
 s Conditiones=""
 s ARCOSRowid=""
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow2
	set Data=$lb(ARCOSRowid,ARCOSCode,ARCOSDesc,ARCOSOrdCat,ARCOSOrdSubCat,ARCOSEffDateFrom,ARCOSOrdCatDR,ARCOSOrdSubCatDR,FavRowidOut,ARCOSAlias,FavUserDesc,FavDepDesc,FavUserDr,FavDepDr,MedUnit,MedUnitDesc,OrdSetPrice,PrescTypeCode,DuratId,FreqId,InstrId,DosageId,Notes,CelerType,$g(ARCOSAddUser),ARCOSAddDate)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod FindUserOrderSetFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindUserOrderSetExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
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

ClassMethod FindUserOrderSetsBroker(itmjs, UserRowid)
{
	;Rowid:OrderName:,StartDate:SeqNo:DoseQty:DoseUOM:Priority:Status:Frequence:Instruction:Duration:PackQty:RecDep:Billed")
	Set rset=##class(%ResultSet).%New("web.DHCUserFavItems:FindUserOrderSets")
	do rset.Execute(UserRowid)
	Set columns = rset.GetColumnCount()
	While (rset.Next()) {
		For col = 1:1:columns {
			;Write rset.GetColumnName(col),":"
			if col=1 set value=rset.GetData(col)
			e  s value=value_"^"_rset.GetData(col)
		}
		s retval=itmjs_"('"_$ZCVT(value,"O","JS")_"');"
		&javascript<#(retval)#>
	}
	d rset.Close()
	Q 1
}

ClassMethod Insert(UserRowid As %String, ARCOSRowid As %String, FavDepList As %String, DocMedUnit As %String, HospID As %String, CelerType As %String, LogonHospId As %String, FavDateFrom As %String = "", FavDateTo As %String = "") As %String
{
	&SQL(Insert Into DHC_UserFavItems (Fav_User_DR,Fav_Type,Fav_ItemRowid,Fav_Dep_Dr,Fav_MedUnit_Dr,Fav_Hosp_Dr,Fav_CelerType,Fav_UseHosp_Dr,Fav_DateFrom,Fav_DateTo) values (:UserRowid,'ARCOS',:ARCOSRowid,:FavDepList,:DocMedUnit,:HospID,:CelerType,:LogonHospId,:FavDateFrom,:FavDateTo))
	Q:'SQLCODE %ROWID
	Q -1
}

/// w ##class(web.DHCUserFavItems).InsertUserARCOS("18881","","YS01-测试日期1","12","82","66415","CSRQ1","18881","","","","N","2","","2022-11-02")
ClassMethod InsertUserARCOS(UserRowid As %String, ARCOSCode As %String, ARCOSDesc As %String, ARCOSCatID As %String, ARCOSSubCatID As %String, ARCOSEffectDate As %String, ARCOSAlias As %String, UserID As %String, FavDepList As %String, DocMedUnit As %String, HospID As %String = "", CelerType As %String = "N", LogonHospId As %String = "", AROSCNInfo As %String = "", ARCOSEffectDateTo As %String = "", Type As %String = "") As %String
{
	n (UserRowid,ARCOSCode,ARCOSDesc,ARCOSCatID,ARCOSSubCatID,ARCOSEffectDate,ARCOSAlias,UserID,FavDepList,DocMedUnit,HospID,CelerType,%session,LogonHospId,AROSCNInfo,ARCOSEffectDateTo,Type)
	s LogonHospId=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(LogonHospId)
	s ^tempRP("InsertUserARCOS")=$lb(UserRowid,ARCOSCode,ARCOSDesc,ARCOSCatID,ARCOSSubCatID,ARCOSEffectDate,ARCOSAlias,UserID,FavDepList,DocMedUnit,HospID,CelerType,LogonHospId,AROSCNInfo,ARCOSEffectDateTo,Type)
	;w ##class(web.DHCUserFavItems).InsertUserARCOS("6","1","doctor-1","15","90","61801","1")
	//为保证新增个人医嘱套或把科室医嘱套另存为个人医嘱套，医嘱套code统一调用自递归函数获取
	s:Type="" Type="User"
	i Type="User" s (FavDepList,HospID)=""
	e  i Type="Loc" s (UserRowid,HospID)=""
	e  i Type="Hosp" s (UserRowid,FavDepList)=""
    if UserRowid'="" {
    	s ARCOSCode=..GetARCOSCode(UserRowid,0)
    }else{
	    i '$d(^DHCFavItemsCount("ARCOSCode")) s ^DHCFavItemsCount("ARCOSCode")=+$o(^ARCOS(""),-1)+1
	    e  s ARCOSCode=$I(^DHCFavItemsCount("ARCOSCode"))
    }
    s err="-1"
    if ARCOSEffectDate="" s ARCOSEffectDate=..%SysDate()
    s ARCOSEffectDateTo=..%ZDH(ARCOSEffectDateTo)
	i (ARCOSEffectDateTo'="")&&('$num(ARCOSEffectDateTo)) {
		q err
	}
	s err=##Class(web.DHCARCOrdSets).InsertARCOS(ARCOSCode,ARCOSDesc,ARCOSCatID,ARCOSSubCatID,ARCOSEffectDate,UserID,ARCOSEffectDateTo)
	i (err'="-1") d
	.s ARCOSRowid=err
	.s err=..Insert(UserRowid,ARCOSRowid,FavDepList,DocMedUnit,HospID,CelerType,LogonHospId,ARCOSEffectDate,ARCOSEffectDateTo)
	.if (err'="-1") d
	..s FavRowid=err
	..s err=FavRowid_$C(1)_ARCOSRowid_$C(1)_ARCOSCode
	.i ARCOSRowid'="-1" d
	..f i=1:1:$L(ARCOSAlias,$C(2)) d
	...s oneAlias=$P(ARCOSAlias,$C(2),i)
	...q:oneAlias=""
	...&SQL(Insert Into SQLUser.ARC_Alias (ALIAS_ARCOS_DR,ALIAS_DateFrom,ALIAS_Text,ALIAS_OrderSubCat_dr,ALIAS_Desc) Values(:ARCOSRowid,:ARCOSEffectDate,:oneAlias,:ARCOSSubCatID,:ARCOSDesc))
	
	if (AROSCNInfo'="")&&($G(ARCOSRowid)'="") {
		s PrescTypeCode=$p(AROSCNInfo,"^",1)
		s DoseQtyId=$p(AROSCNInfo,"^",2)
		s DuratId=$p(AROSCNInfo,"^",3)
		s FreqId=$p(AROSCNInfo,"^",4)
		s InstrId=$p(AROSCNInfo,"^",5)
		s Notes=$p(AROSCNInfo,"^",6)
		s rtn=##class(DHCDoc.DHCDocConfig.OrdSets).SaveOSCNInfo(ARCOSRowid,PrescTypeCode, DoseQtyId, DuratId, FreqId, InstrId, Notes)
		Q:rtn<0 -1
	}
	if ($G(ARCOSRowid)'=""){
		;医生站业务数据修改日志
		set NewDataJson=##class(web.DHCDocDataChangeLog).GetLogJsonData("User.ARCOrdSets"_$c(2)_ARCOSRowid)
		d ##class(web.DHCDocDataChangeLog).SaveLog("ARC_OrdSets","User.ARCOrdSets","医嘱套信息","User.ARCOrdSets_"_ARCOSRowid,$p($g(^ARCOS(+ARCOSRowid)),"^",2),"A",NewDataJson,"")
	}
	if ($G(FavRowid)'=""){
		set NewDataJson=##class(web.DHCDocDataChangeLog).GetLogJsonData("User.DHCUserFavItems"_$c(2)_FavRowid)
		d ##class(web.DHCDocDataChangeLog).SaveLog("DHC_UserFavItems","User.DHCUserFavItems","医嘱套信息","User.DHCUserFavItems_"_FavRowid,$p($g(^ARCOS(+ARCOSRowid)),"^",2),"A",NewDataJson,"")
	}
	q err
}

ClassMethod GetARCOSCode(UserRowid As %String, Num As %String) As %String
{
	&SQL(Select Max(ARCOS_Rowid) into :MaxARCOSRowid
	 From SQLUser.ARC_OrdSets,SQLUser.DHC_UserFavItems
	 Where SQLUser.DHC_UserFavItems.Fav_User_Dr=:UserRowid And 
	 SQLUser.ARC_OrdSets.ARCOS_Rowid=SQLUser.DHC_UserFavItems.Fav_ItemRowid)
	if (MaxARCOSRowid="") {
		s MaxARCOSCodeNum=1+Num
	}else{
		s MaxARCOSCode=$P(^ARCOS(MaxARCOSRowid),"^",1)
		s MaxARCOSCodeNum=$P(MaxARCOSCode,"-",2)
		i MaxARCOSCodeNum="" s MaxARCOSCodeNum=1+Num
		e  s MaxARCOSCodeNum=MaxARCOSCodeNum+1+Num
	}
	s ARCOSCode=UserRowid_"-"_MaxARCOSCodeNum
	s FindARCOSCode=""
	&SQL(select ARCOS_Code into :FindARCOSCode From SQLUser.ARC_OrdSets where ARCOS_Code=:ARCOSCode)
	if (FindARCOSCode'=""){
		d ..GetARCOSCode(UserRowid,Num+1)
	}
	Q:FindARCOSCode="" ARCOSCode
}

/// w ##class(web.DHCUserFavItems).UpdateUserARCOS("186","18881-14","YS01-血糖检测","12","82","66415","XTJC","","","18881","","N","","2022-11-02")
ClassMethod UpdateUserARCOS(FavRowid As %String, ARCOSCode As %String, ARCOSDesc As %String, ARCOSCatID As %String, ARCOSSubCatID As %String, ARCOSEffectDate As %String, ARCOSAlias As %String, FavDepList As %String, DocMedUnit As %String, UserDr As %String, HospID As %String, CelerType As %String = "", AROSCNInfo As %String = "", ARCOSEffectDateTo As %String = "") As %String
{
	s ^templx("UpdateUserARCOS")=$lb(FavRowid,ARCOSCode,ARCOSDesc,ARCOSCatID,ARCOSSubCatID,ARCOSEffectDate,ARCOSAlias,FavDepList,DocMedUnit,UserDr,HospID,CelerType,AROSCNInfo,ARCOSEffectDateTo)
	s err="-1",Code=""
	s ARCOSRowid=$P(^DHCFavItems(FavRowid),"^",3)
	i (ARCOSRowid="") {
		q err
	}
	s ARCOSEffectDateTo=..%ZDH(ARCOSEffectDateTo)
	i (ARCOSEffectDateTo'="")&&('$num(ARCOSEffectDateTo)) {
		q err
	}
	s CNMedSubCat=##class(web.DHCDocOrderCommon).GetCNMedItemCatStr()
	s ARCOSPrescTypeCode=$p($g(^ARCOS(ARCOSRowid)),"^",26)
	s ARCOSOrdSubCatDR=$p($g(^ARCOS(ARCOSRowid)),"^",9)
	s OldCNMedItemFlag=0,NewCNMedItemFlag=0
	if (("^"_CNMedSubCat_"^")[("^"_ARCOSOrdSubCatDR_"^")) {
		s OldCNMedItemFlag=1
	}
	if (("^"_CNMedSubCat_"^")[("^"_ARCOSSubCatID_"^")) {
		s NewCNMedItemFlag=1
	}
	;医嘱套是否存在明细数据
	s HaveARCOSItemFlag=0
	s DATEChildsub=$o(^ARCOS(ARCOSRowid,"DATE",""),-1)
	if (DATEChildsub'="") {
		s ITMChildsub=$o(^ARCOS(ARCOSRowid,"DATE",DATEChildsub,"ITM",""),-1)
		if (ITMChildsub>0) s HaveARCOSItemFlag=1
		s OSChildsub=$o(^ARCOS(ARCOSRowid,"DATE",DATEChildsub,"OS",""),-1)
		if (OSChildsub>0) s HaveARCOSItemFlag=1
	}
	if ((HaveARCOSItemFlag=1)||(ARCOSPrescTypeCode'=""))&&(OldCNMedItemFlag=1)&&(NewCNMedItemFlag'=1) {
		Q "-3"
	}
	if (HaveARCOSItemFlag=1)&&(OldCNMedItemFlag'=1)&&(NewCNMedItemFlag=1) {
		Q "-4"
	}
	&sql(select ARCOS_Code,ARCOS_RowId1 into :Code,:rowid from sqluser.ARC_OrdSets where ARCOS_Code=:ARCOSCode)
	i (Code'="")&&(rowid'=ARCOSRowid) {
		s err="-2"
		q err
	}
	set OldDataJson=##class(web.DHCDocDataChangeLog).GetLogJsonData("User.ARCOrdSets"_$c(2)_ARCOSRowid)
	s err=##Class(web.DHCARCOrdSets).UpdateARCOS(ARCOSRowid,ARCOSCode,ARCOSDesc,ARCOSCatID,ARCOSSubCatID,ARCOSEffectDate,ARCOSEffectDateTo)
	if (err'=0){
		q err
	}
	
	set FavOldDataJson=##class(web.DHCDocDataChangeLog).GetLogJsonData("User.DHCUserFavItems"_$c(2)_FavRowid)
	s ARCOSAliasRowid=$O(^ARC("ALIAS",0,"ARCOS",ARCOSRowid,0))
	if ARCOSAliasRowid'="",ARCOSAlias'="" {
		&SQL(update SQLUser.ARC_Alias set ALIAS_Text =:ARCOSAlias,ALIAS_Desc=:ARCOSDesc,ALIAS_OrderSubCat_DR=:ARCOSSubCatID where ALIAS_Rowid=:ARCOSAliasRowid)
	}
	&SQL(update SQLUser.DHC_UserFavItems set Fav_Dep_Dr=:FavDepList where Fav_Rowid=:FavRowid)
	&SQL(update SQLUser.DHC_UserFavItems set Fav_MedUnit_Dr=:DocMedUnit where Fav_Rowid=:FavRowid)
	&SQL(update SQLUser.DHC_UserFavItems set Fav_User_Dr=:UserDr where Fav_Rowid=:FavRowid)
	&SQL(update SQLUser.DHC_UserFavItems set Fav_Hosp_Dr=:HospID where Fav_Rowid=:FavRowid)
	&SQL(update SQLUser.DHC_UserFavItems set Fav_CelerType=:CelerType where Fav_Rowid=:FavRowid)
	&SQL(update SQLUser.DHC_UserFavItems set Fav_DateFrom=:ARCOSEffectDate,Fav_DateTo=:ARCOSEffectDateTo where Fav_Rowid=:FavRowid)
	// 取消快速医嘱套标识时需同步修改明细例外标识
	i CelerType="N" d
	.s ARCOSDateRowid=##class(web.DHCARCOrdSets).GetOrderSetDate(ARCOSRowid)
	.Q:+ARCOSDateRowid=0
	.s ITMChildsub=0
	.f  s ITMChildsub=$o(^ARCOS(+ARCOSDateRowid,"DATE",$p(ARCOSDateRowid,"||",2),"ITM",ITMChildsub)) Q:ITMChildsub=""  d
	..;快速例外
	..s $p(^ARCOS(+ARCOSDateRowid,"DATE",$p(ARCOSDateRowid,"||",2),"ITM",ITMChildsub,"DHC"),"^",9)="N"
	if (AROSCNInfo'="") {
		s PrescTypeCode=$p(AROSCNInfo,"^",1)
		s DoseQtyId=$p(AROSCNInfo,"^",2)
		s DuratId=$p(AROSCNInfo,"^",3)
		s FreqId=$p(AROSCNInfo,"^",4)
		s InstrId=$p(AROSCNInfo,"^",5)
		s Notes=$p(AROSCNInfo,"^",6)
		s rtn=##class(DHCDoc.DHCDocConfig.OrdSets).SaveOSCNInfo(ARCOSRowid,PrescTypeCode, DoseQtyId, DuratId, FreqId, InstrId, Notes)
		Q:rtn'=0 -1
	}
	
	;医生站业务数据修改日志
	set NewDataJson=##class(web.DHCDocDataChangeLog).GetLogJsonData("User.ARCOrdSets"_$c(2)_ARCOSRowid)
	d ##class(web.DHCDocDataChangeLog).SaveLog("ARC_OrdSets","User.ARCOrdSets","医嘱套信息","User.ARCOrdSets_"_ARCOSRowid,$p($g(^ARCOS(+ARCOSRowid)),"^",2),"U",NewDataJson,OldDataJson)
	set NewDataJson=##class(web.DHCDocDataChangeLog).GetLogJsonData("User.DHCUserFavItems"_$c(2)_FavRowid)
	d ##class(web.DHCDocDataChangeLog).SaveLog("DHC_UserFavItems","User.DHCUserFavItems","医嘱套信息","User.DHCUserFavItems_"_FavRowid,$p($g(^ARCOS(+ARCOSRowid)),"^",2),"U",NewDataJson,FavOldDataJson)
	
	q err
}

Query FindItemsInSet(ID As %String) As %Library.Query(CONTAINID = "", ROWSPEC = "Rowid:%String,OrderName:%String,StartDate:%String,SeqNo:%String,DoseQty:%String,DoseUOM:%String,Priority:%String,Status:%String,Frequence:%String,Instruction:%String,Duration:%String,PackQty:%String,PackUOM:%String,Price:%String,Sum:%String,RecDep:%String,Billed:%String,BillType:%String")
{
}

Query FindUserOrderSet(UserID As %String, QueryFlag As %String, ForQueryUserID As %String, ForQueryLocID As %String, status As %String, Conditiones As %String, DocMedUnit As %String, subCatID As %String, Code As %String, Desc As %String, Alias As %String, LogonHospID As %String, HospARCOSAuthority As %String = "", paraCelerType As %String = "", LogonHospDr As %String = "", CTLOCROWID As %String = "") As %Library.Query(CONTAINID = "", ROWSPEC = "ARCOSRowid:%String,ARCOSCode:%String,ARCOSDesc:%String,ARCOSOrdCat:%String,ARCOSOrdSubCat:%String,ARCOSEffDateFrom:%String,ARCOSOrdCatDR:%String,ARCOSOrdSubCatDR:%String,FavRowid:%String,ARCOSAlias:%String,FavUserDesc:%String,FavDepDesc:%String,FavUserDr:%String,FavDepDr:%String,MedUnit:%String,MedUnitDesc:%String,OrdSetPrice:%String,PrescTypeCode:%String,DuratId:%String,FreqId:%String,InstrId:%String,DosageId:%String,Notes:%String,CelerType:%String,ARCOSAddUser:%String,ARCOSAddDate:%String")
{
}

Query FindUserOrderSets(UserID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ARCOSRowid:%String,ARCOSCode:%String,ARCOSDesc:%String,ARCOSOrdCat:%String,ARCOSOrdSubCat:%String,ARCOSEffDateFrom:%String,ARCOSOrdCatDR:%String,ARCOSOrdSubCatDR:%String,FavRowid:%String")
{
	Select ARCOS_Rowid,ARCOS_Code,ARCOS_Desc,ARCOS_OrdCat_DR->ORCAT_Desc,ARCOS_OrdSubCat_DR->ARCIC_Desc,ARCOS_EffDateFrom,ARCOS_OrdCat_DR,ARCOS_OrdSubCat_DR,Fav_Rowid 
	  From ARC_OrdSets,DHC_UserFavItems
	 Where DHC_UserFavItems.Fav_User_Dr=:UserID and ARC_OrdSets.ARCOS_Rowid=DHC_UserFavItems.Fav_ItemRowid
}

ClassMethod LookUpItemClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = LookUpItemExecute ]
{
	 // Clean up by purging the temporary node in ^CacheTemp global
	 New repid
	 Set repid=$li(QHandle,2)
	 Kill ^CacheTemp(repid)
	 Quit $$$OK
}

ClassMethod LookUpItemExecute(ByRef QHandle As %Binary, Item As %String = "", GroupID As %Library.String = "", Category As %Library.String = "", SubCategory As %Library.String = "", TYPE As %Library.String = "", OrderDepRowId As %Library.String = "", LUSubCategoryDesc As %Library.String = "", EpisodeID As %Library.String = "", BillingGrp As %Library.String = "", BillingSubGrp As %Library.String = "", DateRestriction As %Library.String = "", OrdCatGrp As %Library.String = "", NonFormulary As %Library.String = "", Form As %Library.String = "", Strength As %Library.String = "", Route As %Library.String = "", CurLogonHosp As %String = "") As %Status
{
	New repid, index
	///do ResetVariables
	Set repid=$I(^CacheTemp)
	s index=1
	s NotDisplayZeroStockItem=..%GetConfig("NotDisplayZeroStockItem",CurLogonHosp)
	;不判断库存
	s NotCheckStock=..%GetConfig("NotCheckStock",CurLogonHosp)
	s AdmReason="",EpisodeType=""
	i EpisodeID'="" {
		s AdmReason=$p($G(^PAADM(EpisodeID,1)),"^",7)
		s EpisodeType=$P($G(^PAADM(EpisodeID)),"^",2)
	}

	if Category'="" 
	.s CategoryID=$O(^OEC("ORCAT",0,"Desc",Category,0))
	.i CategoryID'="" s Category=CategoryID
	i SubCategory'="" d
	.s SubCategoryID=$O(^ARC("IC",0,"Desc",SubCategory,0))
	.i SubCategoryID'="" s SubCategory=SubCategoryID
	if (Category'="")&(SubCategory="") d
	.i $$valordcat(GroupID,Category) d
	..s SubCategory=0 f  s SubCategory=$o(^ARC("IC",0,"OrdCat",Category,SubCategory)) q:SubCategory=""  d
	...set retval=$$open(SubCategory,Item,GroupID)
	...for  s retval=$$fetch(SubCategory,Item,GroupID) q:retval="100"  d
	.... ;非药品和无库存医嘱的StockQty=""
	.... Q:(NotDisplayZeroStockItem="1")&(StockQty=0)
	.... Q:(subcatcode="R")&(Recloc="")&(EpisodeID'="")
 	.... Do OutputRow
	...set retval=$$close()
	e  d
	.set retval=$$open(SubCategory,Item,GroupID)
	.for  s retval=$$fetch(SubCategory,Item,GroupID) q:retval="100"  d
	.. Q:(NotDisplayZeroStockItem="1")&(StockQty=0)
	..; Q:(subcatcode="R")&(Recloc="")
	.. Q:(subcatcode="R")&(Recloc="")&(EpisodeID'="")
 	.. Do OutputRow
	.set retval=$$close()
	Set QHandle=$lb(0,repid,0)
 Quit $$$OK
open(CATEG,TEXT,user) 
	k ^TMP($zn,$j)
	;;s ^zleon($zn,"o")=CATEG_"^"_TEXT_"^"_user
	s TEXT=$g(TEXT),CATEG=$g(CATEG)
	s TEXT1=$ZCVT(TEXT,"U")
	s TEXT=$ZCVT(TEXT,"U")
	;
	s DESC=0,ROW=0,TEXT0=TEXT 
	i TEXT,TEXT=+TEXT s TEXT0=TEXT_$c(1)
	s:TEXT0="" TEXT0=0
	;build list of categories for user
	k UserCat
	s ord=0 f  s ord=$o(^SSU("SSGRP",+user,"SSORD",ord)) q:ord=""  d
	.s s=^(ord)
	.s sssubcat=$p(s,"^",5)
	.if '$d(UserCat(+s)) d
	..s UserCat(+s)=$p(s,"^",3,4)_"^"_sssubcat
	.e  d
	..s UserCat(+s)=UserCat(+s)_"!"_sssubcat
	;decide which index to use
	s SubScr=$$subscr(CATEG)
	q 0
fetch(CATEG,TEXT,user) 
	 s TEXT=$g(TEXT),CATEG=$g(CATEG)
	 s TEXT1=$ZCVT(TEXT,"U")
	 s TEXT=$ZCVT(TEXT,"U")
	 s SubScr=$g(SubScr),DESC=$g(DESC),ROW=$g(ROW),TEXT0=$g(TEXT0)
	 k PLIST 
	 i CATEG="" g it3
	 i CATEG'="" g it31
it1 ;
	 s TEXT0=$o(^ARC("ALIAS",0,SubScr,TEXT0)),DESC=""
it2 q:TEXT0="" 100
	 ;i TEXT=+TEXT,$l(TEXT),$e($$ALPHAUP^SSUTIL4(TEXT0),1,$l(TEXT))'[TEXT g it1 ;q 100
	 i $l(TEXT),$e($ZCVT(TEXT0,"U"),1,$l(TEXT))'[TEXT q 100
	 ;i $ZCVT(TEXT0,"U")'[TEXT q 100
	 ;i TEXT'=+TEXT,$l(TEXT),$e($$ALPHAUP^SSUTIL4(TEXT0),1,$l(TEXT))'[TEXT q 100
	 s DESC=$o(^ARC("ALIAS",0,SubScr,TEXT0,DESC)),ROW=""
	 g:DESC="" it1
it3 q:$g(TEXT0)="" 100
	 g:$g(DESC)="" it1
	 s ROW=$o(^ARC("ALIAS",0,SubScr,TEXT0,DESC,ROW))
	 g:ROW="" it2
	 s ind=$o(^ARC("ALIAS",0,SubScr,TEXT0,DESC,ROW,""))
	 g:ind="" it3
	 s str=$g(^ARC("ALIAS",0,SubScr,TEXT0,DESC,ROW,ind))
	 s ROW1=$p(str,"^"),type=$p(str,"^",2),genflag=$p(str,"^",3)
	 i type="ARCIM",$p($g(^ARCIM(+ROW1,1,7)),"^",13)'["Y" g it3
	 i $e($ZCVT(TEXT0,"U"),1,$l(TEXT1))'[TEXT1 g it3
	 i type="ARCOS" s subCATEG=$p($g(^ARCOS(+ROW1)),"^",9)
	 e  s subCATEG=$p($g(^ARCIM(+ROW1,1,1)),"^",10)
	 i ;CMSubCategory'[("^"_subCATEG_"^") g it3
	 i ;(CNMedKLItemCat'="")&(CNMedKLItemCat[("^"_subCATEG_"^"))  g it3
	 s OrderType=""
	 if subCATEG'="" s OrderType=$P(^ARC("IC",subCATEG),"^",7)
	 i (TYPE'="")&&(OrderType'=TYPE) g it3
	 i '$$valord(user,subCATEG,type,ROW1) g it3
	 i type="ARCIM",$$valrow(ROW1) g it3
	 i type="ARCOS",$$valarcos(ROW1) g it3
	 i $d(^TMP($zn,$j,type_"^"_ROW1)) g it3
	 s ^TMP($zn,$j,type_"^"_ROW1)=""
	 s flag=$s(TEXT0=DESC:"",ROW=ROW1:"",$g(^ARC("ALIAS",ROW))'="":$P($G(^ARC("ALIAS",ROW)),"^",6)_"-",type["ARCIM":$p($g(^ARCIM(+ROW1,1,8)),"^",21)_"-",1:"")
	 ;i type="ARCIM",flag="" d
	 i type="ARCIM" d
	 .s generdesc=$p($g(^ARCIM(+ROW,1,8)),"^",21)
	 .i $ZCVT(generdesc,"U")=TEXT0 s flag=generdesc_"-"
	 i type="ARCIM",genflag d
	 .s flag=$p($g(^ARCIM(+ROW1,1,"GEN",genflag)),"^",2)_"-"
	 i type["ARCIM" s err=$$selectarcim(ROW1) g:err it3 s desc=flag_desc q "ARCIM"
	 i type["ARCOS" s err=$$selectarcos(ROW1) g:err it3 s desc=flag_desc q "ARCOS"
	 q 0
 ;
it11 ;
	 s TEXT0=$o(^ARC("ALIAS",0,SubScr,+CATEG,TEXT0)),DESC=""
it21 q:TEXT0="" 100
	 ;i TEXT=+TEXT,$l(TEXT),$e($$ALPHAUP^SSUTIL4(TEXT0),1,$l(TEXT))'[TEXT g it11 ;q 100
	 i $l(TEXT),$e($ZCVT(TEXT0,"U"),1,$l(TEXT))'[TEXT q 100
	 s DESC=$o(^ARC("ALIAS",0,SubScr,+CATEG,TEXT0,DESC)),ROW=""
	 g:DESC="" it11
it31 q:$g(TEXT0)="" 100
	 g:$g(DESC)="" it11
	 s ROW=$o(^ARC("ALIAS",0,SubScr,+CATEG,TEXT0,DESC,ROW))
	 g:ROW="" it21
	 s ind=$o(^ARC("ALIAS",0,SubScr,+CATEG,TEXT0,DESC,ROW,""))
	 g:ind="" it21
	 s str=$g(^ARC("ALIAS",0,SubScr,+CATEG,TEXT0,DESC,ROW,ind))
	 s ROW1=$p(str,"^"),type=$p(str,"^",2)
	 ;i type="ARCIM",$p($g(^ARCIM(+ROW1,1,7)),"^",13)'["Y" g it31
	 i type="ARCOS" s subCATEG=$p($g(^ARCOS(+ROW1)),"^",9)
	 e  s subCATEG=$p($g(^ARCIM(+ROW1,1,1)),"^",10)
	 s OrderType=""
	 i subCATEG'="" s OrderType=$P(^ARC("IC",subCATEG),"^",7)
	 i (TYPE'="")&&(OrderType'=TYPE) g it31
	 i '$$valord(user,subCATEG,type,ROW1) g it31
	 i type="ARCIM",$$valrow(ROW1) g it31
	 i type="ARCOS",$$valarcos(ROW1) g it31
	 i $e($ZCVT(TEXT0,"U"),1,$l(TEXT1))'[TEXT1 g it31
	 s flag=$s(TEXT0=DESC:"",1:$P($G(^ARC("ALIAS",ROW)),"^",6)_"-")
	 i type="ARCIM",flag="" d
	 .s generdesc=$p($g(^ARCIM(+ROW,1,8)),"^",21)
	 .i $ZCVT(generdesc,"U")=TEXT0 s flag=generdesc_"-"
	 s err=0
	 i type["ARCIM" s err=$$selectarcim(ROW1) 
	 i type["ARCOS" s err=$$selectarcos(ROW1)
	 g:err it31 
	 ;s $p(PLIST(1),$c(2),2)=flag_$p(PLIST(1),$c(2),2) 
	 i $l(type),ROW1,$d(^TMP($zn,$j,type,ROW1_"^"_desc)) g it31
	 i $l(type),ROW1 s ^TMP($zn,$j,type,ROW1_"^"_desc)=""
	 i type="ARCIM" q "ARCIM"
	 i type="ARCOS" q "ARCOS"
	 q 0
close() k UserCat,TEXT,TEXT0
	 k ^TMP($zn,$j)
	 q 0
selectarcim(RowID)	k PLIST
	&SQL(SELECT ARCIM_RowId,ARCIM_Desc,ARCIM_PHCDF_DR->PHCDF_PHCD_ParRef,ARCIM_PHCDF_DR->PHCDF_PHCF_DR->PHCF_Desc,ARCIM_PHCDF_DR,
			ARCIM_RiceType_DR,ARCIM_RiceType_DR->RIC_Desc,ARCIM_ConsultDept,ARCIM_ConsultDept->CTLOC_Desc,
			ARCIM_ItemCat_DR,ARCIM_ItemCat_DR->ARCIC_OrdCat_DR,ARCIM_MealType_DR,ARCIM_MealType_DR->MEALT_Desc,
			ARCIM_PriceCostOnOrdering,ARCIM_InsSubCat_DR,ARCIM_DefPriority_DR,ARCIM_DefPriority_DR->OECPR_Desc,ARCIM_Code,
			ARCIM_PHCDF_DR->PHCDF_PHCFR_DR->PHCFR_Code,ARCIM_ItemCat_DR->ARCIC_OrderType,ARCIM_ItemCat_DR->ARCIC_OrdCat_DR,
			$LIST(ARCIM_OEMessage),ARCIM_RangeFrom,ARCIM_RangeTo,ARCIM_PHCDF_DR->PHCDF_CTUOM_DR->CTUOM_Desc,ARCIM_PHCDF_DR->PHCDF_PHCDU_DR,
			ARCIM_PHCDF_DR->PHCDF_GenRtForm_DR,ARCIM_ItemCat_DR->ARCIC_Desc,ARCIM_BillingUOM_DR->CTUOM_Desc,ARCIM_DerFeeRules_DR->DFR_Desc 
	   INTO :rowid,:desc,:code,:code1,:code2,:rice,:ricedes,:cons,:consdes,
	        :subcat,:categ,:mealt,:mealtdes,:cost,:inssubcat,:prior,:priordesc,
	        :arcimcode,:phfreqcode,:subcatcode,:ordcatid,:oemessage,:rangefrom,:rangeto,:phuomdesc,:phdurrowid,:generic,:subcatdesc,:billuom,
	        :DerFeeRules
	   FROM Sqluser.ARC_ItmMast  WHERE ARCIM_RowId=:RowID)
	i 'SQLCODE d adjust1
	q SQLCODE
	;
adjust1	;
	;s cost=$p($g(cost),$c(1)) s:cost="" cost="N"
	;s PLIST(1)=$p(rowid,$c(1))_$c(2)_desc_$c(2)_$p(code,$c(1))_$c(2)_$p(code1,$c(1))_$c(2)_$p(code2,$c(1))_$c(2)_$p(rice,$c(1))_$c(2)_ricedes_$c(2)_$p(cons,$c(1))_$c(2)_consdes_$c(2)_categ_$c(2)_subcat_$c(2)_$p(mealt,$c(1))_$c(2)_mealtdes_$c(2)_cost_$c(2)_inssubcat_$c(2)_prior_$c(2)_priordesc_$c(2)_$p($g(^ARC("IC",+subcat)),"^",15)_$c(2)_arcimcode
	;s PLIST=$o(PLIST(""),-1)
	s ItemPrice=0
	s StockQty=""
	s PackedQty=""
	s rowid=$p(rowid,$c(1))
	s SttDate=..%SysDate()
	s PatType="", InsType="", PriorRowid="", InstrRowid="", LinkTo="", OEPrice=""
	s retPrice=##class(web.DHCDocOrderEntry).GetOrderPrice(PatType, InsType, rowid, SttDate, PriorRowid, InstrRowid, LinkTo, OEPrice)
	s ItemPrice=$fn($P(retPrice,"^",1),"",4)
	s Recloc=""
	;无库存医嘱也不去查找库存
	s AllowOrderWOStockCheck=$p($G(^ARCIM(+rowid,$p(rowid,"||",2),8)),"^",11)
	i (subcatcode="R")&(EpisodeID'="")&(AllowOrderWOStockCheck'="Y") d
	.s Recloc=##class(web.DHCDocOrderCommon).GetReclocDescStr(EpisodeID,rowid,"/",OrderDepRowId)
	.s ret=##class(web.DHCDocOrderEntry).GetStockQty(EpisodeID,rowid,OrderDepRowId)
	.s StockQty=$P(ret,"^",1)
	.s PackedQty=$P(ret,"^",2)
	.s ResQty=$P(ret,"^",3)
	s generic=""
	;s desc=flag_desc
	s desc=desc_"-"_$p(flag,"-",1)
	s GenericName=##class(web.UDHCJFCOMMON).GetDrugCommonNameByArcimId(rowid)
	;医保组从2010.3.3号起统一到了web.DHCINSUPort里面了
	s ArcimLinkInsu=##class(web.DHCINSUPort).ArcimLinkInsu(rowid,AdmReason)
	//s ArcimInsu=##class(web.DHCDocInPatPortalCommon).GetArcimLinkInsuInfo(rowid,AdmReason, "","",6)
	;医保类别(甲,乙,丁等)
	s InsurClass=##class(web.DHCDocInPatPortalCommon).GetArcimLinkInsuInfo(rowid,AdmReason,"","",6)
	s drgform=code2
	s InsurClass=$P($g(^PHCD(+drgform,4)),"^",2)
	;自负比例
	s InsurSelfPay=##class(web.DHCDocInPatPortalCommon).GetArcimLinkInsuInfo(rowid,AdmReason,"","",7)
	s Data=$lb(desc,rowid,$p(phfreqcode,$c(1)),type,TEXT0,subcatcode,$p(ordcatid,$C(1)),"",oemessage,rangefrom,rangeto,phuomdesc,$p(phdurrowid,$C(1)),generic,"","","",subcatdesc,ItemPrice,billuom,StockQty,PackedQty,GenericName,ResQty,DerFeeRules,InsurClass,InsurSelfPay,Recloc,arcimcode)
	q
selectarcos(RowID)	k PLIST
	&SQL(SELECT ARCOS_RowId,ARCOS_Desc,ARCOS_Code,ARCOS_LabTrakTestSet,ARCOS_DefPriority_DR,ARCOS_DurationDR,ARCOS_FrequencyDR,ARCOS_OrdCat_DR,ARCOS_OrdSubCat_DR->ARCIC_Desc
	       INTO :rowid,:desc,:code,:labsetrowid,:prior,:durrowid,:freqcode,:ordcatid,:subcatdesc
	       FROM SQLUser.ARC_OrdSets WHERE ARCOS_RowId=:RowID)
	;&SQL(SELECT ARCOS_Desc FROM SQLUser.ARC_OrdSets)
	i 'SQLCODE d adjust2
	q SQLCODE
adjust2	;
	;s PLIST(1)=$p(rowid,$c(1))_$c(2)_desc_$c(2)_code_$c(2)_$p($g(prior),$c(1))_$c(1)_$p($g(^OECPR(+$g(prior))),"^",2)
	;s PLIST=$o(PLIST(""),-1)
	s StockQty=""
	s rowid=$p(rowid,$C(1),1)
	s retval=$$getOSItemIDs(rowid)
	s OSItemIDs=$p(retval,$C(4),1)
	s OSPrice=$fn($p(retval,$C(4),2),"",4)
	s desc=flag_desc
	s subcatcode=""
	s Recloc=""
	s Data=$lb(desc,rowid,"",type,TEXT0,"",$p(ordcatid,$C(1)),"","","","","","","",OSItemIDs,"","",subcatdesc,OSPrice,"","","","","","","","","",code)
	q
	;
valord(user,subCATEG,type,ROW1) ;validate usergroup and CATEGory
	 ;1-valid,0-invalid
	 n (UserCat,user,subCATEG,type,ROW1,EpisodeType)
	 s CATEG=$p($g(^ARC("IC",+subCATEG)),"^",8)
	 Q:'user 1
	 i '$d(UserCat(+CATEG)) q 0
	 s s=UserCat(+CATEG),vis=$p(s,"^"),os=$p(s,"^",2),subcat=$p(s,"^",3)
	 Q:(subcat'="")&&(("!"_subcat_"!")'[("!"_subCATEG_"!")) 0
	 s UseCNMedEntry=..%GetConfig("UseCNMedEntry")
	 s CNMedSubCat=##Class(web.DHCDocOrderCommon).GetCNMedItemCatStr()
	 ;Q:(UseCNMedEntry="1")&(CNMedSubCat'="")&&(("^"_CNMedSubCat_"^")[("^"_subCATEG_"^")) 0
	 i type="ARCOS",os'="Y" Q 0
	 ;i type="ARCIM",$p($g(^ARCIM(+ROW1,1,7)),"^",13)'["Y",vis'="Y" q 0
	 i type="ARCIM",$p($g(^ARCIM(+ROW1,1,7)),"^",13)'["Y" Q 0
	 s RestrictIP=$p($g(^ARCIM(+ROW1,1,10)),"^",13)
	 s RestrictOP=$p($g(^ARCIM(+ROW1,1,10)),"^",14)
	 if (RestrictIP'="Y")!(RestrictOP'="Y") {
	 	if (RestrictIP="Y")&&(EpisodeType'="I") Q 0
		if (RestrictOP="Y")&&(EpisodeType'="O") Q 0
	 }
	 Q 1
	 ;
	 s found=0,ord=0 f  s ord=$o(^SSU("SSGRP",+user,"SSORD",ord)) q:ord=""  q:found  s s=^(ord) d
	 .i '(s-CATEG) s found=1
	 q found
valordcat(user,CATEG)
	 ;1-valid,0-invalid
	 s found=0
	 s found=0,ord=0 f  s ord=$o(^SSU("SSGRP",+user,"SSORD",ord)) q:ord=""  q:found  s s=^(ord) d
	 .i '(s-CATEG) s found=1
	 q found
 ;        
ALPHAUP(val,remove)
 s %trans(1)="abcdefghijklmnopqrstuvwxyz !,""#$%&'()*+-./:;<=>@[\]^_`{|},~",%trans(2)="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
 q:'$d(remove) $tr(val,%trans(1),%trans(2)) q $tr(val,$tr(%trans(1),remove),%trans(2))
UP(val,remove) 
 s %trans(1)="abcdefghijklmnopqrstuvwxyz",%trans(2)="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
 q:'$d(remove) $tr(val,%trans(1),%trans(2)) q $tr(val,$tr(%trans(1),remove),%trans(2))
valrow(row) ;validate if arcim is active 0-active,1-not active
	 n (row)
	 s datefrom=$p($g(^ARCIM(+row,1,1)),"^",13)
	 s dateto=$p($g(^ARCIM(+row,1,7)),"^",1)
	 i datefrom>$h q 1
	 i dateto,dateto<$h q 1
	 q 0
valarcos(row) ;validate if arcos is active 0-active,1-not active
	n (row)
	s datefrom=$p($g(^ARCOS(+row)),"^",15)
	s dateto=$p($g(^ARCOS(+row)),"^",16)
	i datefrom>$h q 1
	i dateto,dateto<$h q 1
	q 0
checkos(arcos,user) ;check if user is allowed to order os
	 ;0-yes,61-no
	 n (arcos,user)
	 s grp=$p($g(^SSU("SSUSR",+user)),"^",5)
	 s ord=0 f  s ord=$o(^SSU("SSGRP",+grp,"SSORD",ord)) q:ord=""  s s=^(ord),UserCat(+s)=$p(s,"^",3,4)
	 s err=$$getall^MVBARCOI(arcos_"^ALL")
	 s found=0,ind=0
	 f  s ind=$o(PLIST(ind)) q:ind=""  q:found  d
	 .s arcim=$p(PLIST(ind),$c(2))
	 .s subcat=$p($g(^ARCIM(+arcim,1,1)),"^",10)
	 .s orcat=$p($g(^ARC("IC",+subcat)),"^",8)
	 .i '$d(UserCat(+orcat)) s found=61
	 q found
subscr(subCATEG) ;decide which index to use
	n (subCATEG,UserCat)
	;if order subcategory is blank, index can be :
	; Desc - all order items, order sets
	; DescI - all order items,no order sets
	; DescVI - visible order items, no order sets
	; DescVIOS - visible order items, order sets
	;if order subcategory is not blank, index can be :
	; OrderCat-Desc - all order items, order sets
	; OrderCat-DescI - all order items,no order sets
	; OrderCat-DescVI - visible order items, no order sets
	; OrderCat-DescVIOS - visible order items, order sets
	;
	;
	s CATEG=$p($g(^ARC("IC",+subCATEG)),"^",8)
	s subscr="NoItems"
	i CATEG,'$d(UserCat(+CATEG)) q subscr
	i CATEG d  q subscr
	.s s=UserCat(+CATEG),vis=$p(s,"^"),os=$p(s,"^",2)
	.i vis="Y",os="Y" s subscr="OrderCat-Desc"
	.i vis'="Y",os="Y" s subscr="OrderCat-DescVIOS"
	.i vis="Y",os'="Y" s subscr="OrderCat-DescI"
	.i vis'="Y",os'="Y" s subscr="OrderCat-DescVI"
	;
	;check what are settings of all order categories
	s vis="N",os="N"
	s cat="" f  s cat=$o(UserCat(cat)) q:cat=""  s s=UserCat(cat) d
	.i $p(s,"^")="Y" s vis="Y"
	.i $p(s,"^",2)="Y" s os="Y"
	i vis="Y",os="Y" s subscr="Desc"
	i vis'="Y",os="Y" s subscr="DescVIOS"
	i vis="Y",os'="Y" s subscr="DescI"
	i vis'="Y",os'="Y" s subscr="DescVI"
	q subscr
getOSItemIDs(ARCOSRowid)
	do ##class(web.DHCDocOrderEntry).OpenGetAllOrderSetItem(ARCOSRowid)
	s n=0,ARCOSPrice=0
	s OSItemIDs=""
	s SttDate=..%SysDate()
	s PatType="",InsType="",PriorRowid="",InstrRowid="",LinkTo="",OEPrice=""
	s count=0  f  s count=$o(^CacheTemp("ARCOI",$j,count)) q:count=""  d 
	.s item=0 f  s item=$o(^CacheTemp("ARCOI",$j,count,item)) q:item=""  s s=^(item) d
	..s ARCIMRowid=$p(s,"^",1)
 ..s ARCOSItemQty=$p(s,"^",2)
 ..s ARCIMDesc=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",2)
	..s retPrice=##class(web.DHCDocOrderEntry).GetOrderPrice(PatType, InsType, ARCIMRowid, SttDate, PriorRowid, InstrRowid, LinkTo, OEPrice)
	..;w retPrice,!
	..s Price=$P(retPrice,"^",1)
	..s ARCOSPrice=ARCOSPrice+$fn(Price*ARCOSItemQty,"",4)
 ..s n=n+1
 ..i n=1  s OSItemIDs=ARCIMRowid_$C(14)_ARCIMDesc
 ..e  s OSItemIDs=OSItemIDs_$C(12)_ARCIMRowid_$C(14)_ARCIMDesc
 i OSItemIDs'="" s OSItemIDs=OSItemIDs_$C(4)_ARCOSPrice
 q OSItemIDs
OutputRow
	;w Data,!
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariables
	///set (repid)=0
	quit
}

ClassMethod LookUpItemFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpItemExecute ]
{
	// This fetch method should never have to change. 
	
	// repid - Report ID
	// ind   - sequence index which represents each row
	
	New repid,ind
	
	// Restore QHandle
	Set AtEnd=$li(QHandle,1)
	Set repid=$li(QHandle,2)
	Set ind=$li(QHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {
		 // if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else      {
		 // fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	
	// Save QHandle
	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query LookUpItem(Item As %String, GroupID As %String, Category As %String, SubCategory As %String, TYPE As %String, OrderDepRowId As %Library.String, LUSubCategoryDesc As %Library.String, EpisodeID As %Library.String, BillingGrp As %Library.String, BillingSubGrp As %Library.String, DateRestriction As %Library.String, OrdCatGrp As %Library.String, NonFormulary As %Library.String, Form As %Library.String, Strength As %Library.String, Route As %Library.String) As %Query(CONTAINID = 0, ROWSPEC = "ARCIMDesc:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,SubCategoryDesc:%String,Price:%String,BillUOM:%String,StockQty:%String,PackedQty:%String,GenericName:%String,ResQty:%String,DerFeeRules:%String,InsurClass:%String,InsurSelfPay:%String")
{
}

/*
ClassMethod GetDeptStr(Type As %String) As %String
{
	;w ##class(web.DHCUserFavItems).GetDeptStr("E")
	s ret1=""
	Set rset=##class(%ResultSet).%New("web.CTLoc:LookUpLoc")
	do rset.Execute("","",Type)
	Set columns = rset.GetColumnCount()
	set row=0
	While (rset.Next()) {
		set RowId=rset.GetData(2)
		if $l(rset.GetData(1),"-")>1 {
			set Deptdesc=$p(rset.GetData(1),"-",2)
			set DeptPYM=$p(rset.GetData(1),"-",1)
		}else{
			set Deptdesc=rset.GetData(1)
		}
		set Alias=$p($g(^CTLOC(RowId)),"^",43)
		if Alias="" Set Alias=DeptPYM
		set ret=RowId_$C(1)_Deptdesc_"-"_Alias
	    i ret1="" s ret1=ret
	    e  s ret1=ret_"^"_ret1
	}
	
	d rset.Close()
	Q ret1
}*/

// 取得科室

ClassMethod GetDeptStr(JSFunName As %String = "", ListName As %String = "", CTLOCID As %String, ForPower As %String) As %String
{
	;^CMC("CMCBM",{CMCBM_RowId})
	;w ##class(web.UDHCOPOtherLB).ReadBankListBroker("","")
	;w ##class(web.DHCUserFavItems).GetDeptStr("","")
	
	s mySelFlag=""
	s SSUSRName=""
	s SSUSRInitials=""
	s mydes=""
	s myval=""
	s myIdx=0
		
	s rtnval=JSFunName_"('"_ListName_"','"_$ZCVT($g(mydes),"O","JS")_"','"_$ZCVT($g(myval),"O","JS")_"','"_$ZCVT($g(myIdx),"O","JS")
	s rtnval=rtnval_"','"_$ZCVT(mySelFlag,"O","JS")_"');"
	&javascript<#(rtnval)#>
	s myIdx=myIdx+1
	s CTLOCRowID=0 f  s CTLOCRowID=$O(^CTLOC(CTLOCRowID)) q:CTLOCRowID=""  d
	.q:((CTLOCID'=CTLOCRowID)&&(ForPower="Personal")) 
	.s CTLOCDesc=$P(^CTLOC(CTLOCRowID),"^",2)
	.s CTLOCCode=$P(^CTLOC(CTLOCRowID),"^",1)
	.s mydes=CTLOCDesc
	.s myval=CTLOCRowID

	.s rtnval=JSFunName_"('"_ListName_"','"_$ZCVT($g(mydes),"O","JS")_"','"_$ZCVT($g(myval),"O","JS")_"','"_$ZCVT($g(myIdx),"O","JS")
	.s rtnval=rtnval_"','"_$ZCVT(mySelFlag,"O","JS")_"');"
	.&javascript<#(rtnval)#>
	.s myIdx=myIdx+1
	q 0
}

/*
ClassMethod GetUserStr() As %String
{
	;w ##class(web.DHCUserFavItems).GetUserStr()
	 set ret1=""
	 Set rset=##class(%ResultSet).%New("web.DHCUserFavItems:LookUpWithInactive")
	do rset.Execute()
	 While (rset.Next()) {
		s Code=rset.GetData(1)
		s Desc=rset.GetData(2)
		s Rowid=rset.GetData(3)
		set ret=Rowid_$C(1)_Desc_"-"_Code
	    i ret1="" s ret1=ret
	    e  s ret1=ret1_"^"_ret
	 }
	 d rset.Close()
	 q ret1
}


Query LookUpWithInactive() As %Library.SQLQuery(CONTAINID = 3, ROWSPEC = "Code:%Library.String,Name:%Library.String,HIDDEN,IsActive:%Library.String")
{
SELECT SSUSR_Initials,SSUSR_Name,SSUSR_RowID,SSUSR_Active
FROM SQLUser.SS_User
WHERE (SSUSR_CareProv_DR IS NOT NULL) AND (SSUSR_Active = 'Y')
ORDER BY SSUSR_Initials
}
*/

// 取得用户

ClassMethod GetUserStr(JSFunName As %String = "", ListName As %String = "", Guser As %String, ForPower As %String) As %String
{
    
	;^CMC("CMCBM",{CMCBM_RowId})
	;w ##class(web.UDHCOPOtherLB).ReadBankListBroker("","")
	;w ##class(web.DHCUserFavItems).GetUserStr("","")
	s mySelFlag=""
	s SSUSRName=""
	s SSUSRInitials=""
	s mydes=""
	s myval=""
	s myIdx=0
	
	s rtnval=JSFunName_"('"_ListName_"','"_$ZCVT($g(mydes),"O","JS")_"','"_$ZCVT($g(myval),"O","JS")_"','"_$ZCVT($g(myIdx),"O","JS")
	s rtnval=rtnval_"','"_$ZCVT(mySelFlag,"O","JS")_"');"
	&javascript<#(rtnval)#>
	s myIdx=myIdx+1

	s SSUSRRowId=0
	f  s SSUSRRowId=$O(^SSU("SSUSR",SSUSRRowId)) q:SSUSRRowId=""  d
	.if (ForPower'="") q:Guser'=SSUSRRowId
	.s SSUSRCareProvDR=$P(^SSU("SSUSR",SSUSRRowId),"^",14)
	.q:SSUSRCareProvDR=""
	.s SSUSRActive=$P(^SSU("SSUSR",SSUSRRowId),"^",19)
	.q:SSUSRActive'="Y"
	.s SSUSRInitials=$P(^SSU("SSUSR",SSUSRRowId),"^",1)
	.s SSUSRName=$P(^SSU("SSUSR",SSUSRRowId),"^",2)
	.s mydes=SSUSRName
	.s myval=SSUSRRowId

	.s rtnval=JSFunName_"('"_ListName_"','"_$ZCVT($g(mydes),"O","JS")_"','"_$ZCVT($g(myval),"O","JS")_"','"_$ZCVT($g(myIdx),"O","JS")
	.s rtnval=rtnval_"','"_$ZCVT(mySelFlag,"O","JS")_"');"
	.&javascript<#(rtnval)#>
	.s myIdx=myIdx+1
	q 0
}

// 取用户姓名

ClassMethod GetUserName(UserID As %String) As %String
{
  ;w ##class(web.DHCUserFavItems).GetUserName("3879")
	s UserName=$P(^SSU("SSUSR",UserID),"^",2)
	q UserName
}

// 取用户科室描述

ClassMethod GetUserLocDesc(LocID As %String) As %String
{
  ;w ##class(web.DHCUserFavItems).GetUserLocDesc("167")
	s CTLOCDesc=$P(^CTLOC(LocID),"^",2)
	q CTLOCDesc
}

// 对user和科室的放大镜

Query ForGetUser(UserForQuery As %String = "", UserID As %String, status As %String) As %Query(ROWSPEC = "mydes:%String,myval:%String")
{
}

ClassMethod ForGetUserExecute(ByRef qHandle As %Binary, UserForQuery As %String = "", UserID As %String, status As %String) As %Status
{
	  ;d ##class(%ResultSet).RunQuery("web.DHCUserFavItems","ForGetUser","FavUserList","3879","")
	 
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//s ^Tempzong=UserForQuery_"^"_UserID_"^"_status
	s SSUSRName=""
	s SSUSRInitials=""
	s mydes=""
	s myval="" 
	i $g(UserForQuery)'="" s UserForQuery=$$ALPHAUP^SSUTIL4(UserForQuery)
	s SSUSRRowId=0
	f  s SSUSRRowId=$O(^SSU("SSUSR",SSUSRRowId)) q:SSUSRRowId=""  d
	.if (status'="") q:UserID'=SSUSRRowId
	.s SSUSRCareProvDR=$P(^SSU("SSUSR",SSUSRRowId),"^",14)
	.q:SSUSRCareProvDR=""
	.s SSUSRActive=$P(^SSU("SSUSR",SSUSRRowId),"^",19)
	.q:SSUSRActive'="Y"
	.s SSUSRInitials=$P(^SSU("SSUSR",SSUSRRowId),"^",1)
	.s SSUSRName=$P(^SSU("SSUSR",SSUSRRowId),"^",2)
	.s mydes=SSUSRName
	.s SSUSRName=$$ALPHAUP^SSUTIL4(SSUSRName)
	.if UserForQuery'="" Q:SSUSRName'[(UserForQuery)
	.s myval=SSUSRRowId 
	.Do OutputRow4
	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow4
	set Data=$lb(mydes,myval)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod ForGetUserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ForGetUserExecute ]
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

ClassMethod ForGetUserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ForGetUserExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query ForGetLoc(LocDesc As %String = "", CTLOCID As %String, status As %String) As %Query(ROWSPEC = "mydes:%String,myval:%String")
{
}

ClassMethod ForGetLocExecute(ByRef qHandle As %Binary, LocDesc As %String = "", CTLOCID As %String, status As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	;d ##class(%ResultSet).RunQuery("web.DHCUserFavItems","ForGetLoc","FavDepList","167","Personal")
 	;FavDepList^167^Personal"
	s SSUSRName=""
	s SSUSRInitials=""
	s mydes=""
	s myval=""
    ;s ^Tempzong=LocDesc_"^"_CTLOCID_"^"_status
    i $g(LocDesc)'="" s LocDesc=$$ALPHAUP^SSUTIL4(LocDesc)
    
	s CTLOCRowID=0 f  s CTLOCRowID=$O(^CTLOC(CTLOCRowID)) q:CTLOCRowID=""  d
	.q:((CTLOCID'=CTLOCRowID)&&(status="Personal")) 
	.s CTLOCDesc=$P(^CTLOC(CTLOCRowID),"^",2)
	.s CTLOCCode=$P(^CTLOC(CTLOCRowID),"^",1)
	.s mydes=CTLOCDesc
	.s myval=CTLOCRowID
	.s CTLOCDesc=$P(CTLOCDesc,"-",1)
    .s CTLOCDesc=$$ALPHAUP^SSUTIL4(CTLOCDesc)
	.if LocDesc'="" Q:CTLOCDesc'[(LocDesc)
	.Do OutputRow5
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow5
	set Data=$lb(mydes,myval)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod ForGetLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ForGetLocfoExecute ]
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

ClassMethod ForGetLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ForGetLocExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

// 加入条件list的下拉

ClassMethod GetConditiones(JSFunName As %String = "", ListName As %String = "", ForPower As %String, DocMedUnit As %String) As %String
{
	;w ##class(web.DHCUserFavItems).GetConditiones("");
	s mySelFlag=""
	s SSUSRName=""
	s SSUSRInitials=""
	s mydes=""
	s myval=""
	s myIdx=0
    s ^Tempzong=DocMedUnit
	s ^TempGetConditiones(1)="个人"
	s ^TempGetConditiones(2)="科室"
	s ^TempGetConditiones(3)="全院"
	if (DocMedUnit'=""){s ^TempGetConditiones(4)="组"} //
	//s ^TempGetConditiones(4)="组"  
	//为所用取数据格式
	s rtnval=JSFunName_"('"_ListName_"','"_$ZCVT($g(mydes),"O","JS")_"','"_$ZCVT($g(myval),"O","JS")_"','"_$ZCVT($g(myIdx),"O","JS")
	s rtnval=rtnval_"','"_$ZCVT(mySelFlag,"O","JS")_"');"
	&javascript<#(rtnval)#>
	s myIdx=myIdx+1
    s TempGetConditionesRowid=0
   f  s TempGetConditionesRowid=$O(^TempGetConditiones(TempGetConditionesRowid)) q:TempGetConditionesRowid=""  d
    .s Str=$G(^TempGetConditiones(TempGetConditionesRowid))
	.s mydes=Str
	.s myval=TempGetConditionesRowid

	.s rtnval=JSFunName_"('"_ListName_"','"_$ZCVT($g(mydes),"O","JS")_"','"_$ZCVT($g(myval),"O","JS")_"','"_$ZCVT($g(myIdx),"O","JS")
	.s rtnval=rtnval_"','"_$ZCVT(mySelFlag,"O","JS")_"');"
	.&javascript<#(rtnval)#>
	.s myIdx=myIdx+1
	k ^TempGetConditiones
	q 0
}

// 查找登陆医生所属医疗单元接口 w ##class(web.DHCUserFavItems).GetMedUnit("997","31")

ClassMethod GetMedUnit(Guser As %String, CTLOCID As %String) As %String
{
   	s UserID=Guser
    s date=+$P($H,",",1)
 	s MedUnit=""
 	q:((UserID="")||(CTLOCID="")) MedUnit 
	s SSUSRCareProvDR=$P($G(^SSU("SSUSR",UserID)),"^",14)
    s CTMUChildsub=0  f  s CTMUChildsub=$O(^CTLOC(CTLOCID,"MU",CTMUChildsub)) q:CTMUChildsub=""  d
    .s CTMUActiveFlag=$P(^CTLOC(CTLOCID,"MU",CTMUChildsub),"^",3)
    .q:CTMUActiveFlag'="Y"  //单元是激活状态
    .s DateFrom1=+$P(^CTLOC(CTLOCID,"MU",CTMUChildsub),"^",4) //单元没有过期，有效状态
    .q:((date<DateFrom1)&&(DateFrom1'=0))
    .s DateTo1=+$P(^CTLOC(CTLOCID,"MU",CTMUChildsub),"^",5)
    .q:((date>DateTo1)&&(DateTo1'=0))
 	.s MUCPChildsub=0 f  s MUCPChildsub=$O(^CTLOC(CTLOCID,"MU",CTMUChildsub,"CP",MUCPChildsub)) q:MUCPChildsub=""  d
 	..s MUCPDoctorDR=$p(^CTLOC(CTLOCID,"MU",CTMUChildsub,"CP",MUCPChildsub),"^",1) 
	..q:MUCPDoctorDR'=SSUSRCareProvDR  //存储的医护人员id与用户对应的医护人员id一致
	..s DateFrom2=+$p(^CTLOC(CTLOCID,"MU",CTMUChildsub,"CP",MUCPChildsub),"^",5)
	..q:((date<DateFrom2)&&(DateFrom2'=0))  //单元中的用户没有超出有效期
	..s DateTo2=+$p(^CTLOC(CTLOCID,"MU",CTMUChildsub,"CP",MUCPChildsub),"^",6)
	..q:((date>DateTo2)&&(DateTo2'=0))
	..s MedUnit=CTLOCID_"||"_CTMUChildsub  //_"^"_MUCPDoctorDR_"^"_SSUSRCareProvDR
	//s MedUnit="31||1"
	q MedUnit
}

// 取组的描述 w ##class(web.DHCUserFavItems).GetMedUnitDesc("31||1")

ClassMethod GetMedUnitDesc(FavMedUnitDr As %String) As %String
{
  	s CTMUDesc=""
  	if FavMedUnitDr="" q CTMUDesc
  	if $P(FavMedUnitDr,"||",1)="" q CTMUDesc
  	if $P(FavMedUnitDr,"||",2)="" q CTMUDesc
  	s CTMUDesc=$P(^CTLOC($P(FavMedUnitDr,"||",1),"MU",$P(FavMedUnitDr,"||",2)),"^",2)
	q CTMUDesc
}

ClassMethod InsertARCOSByLocation(ARCOSCode As %String, LocationID As %String) As %String
{
	n count,result
	q:(ARCOSCode=""||LocationID="")	
	set ARCOSRowid=$o(^ARCOS(0,"Code",$ZCVT(ARCOSCode,"U"),""))	
	&sql(select count(*) into :count from DHC_UserFavItems where Fav_ItemRowid=:ARCOSRowid and Fav_Dep_Dr=:LocationID)
	s:((ARCOSRowid'="")&&($g(count)=0)) result=..Insert("",ARCOSRowid,LocationID,"")
	
	q:$g(result)
}

/// 2012.12.12 复制科室模板到用户
/// w ##class(web.DHCUserFavItems).SaveAsUser(518,12176,466RS,测试新增,12,84,"饭后","CSXZ",12176,"","")
ClassMethod SaveAsUser(OldARCOSRowid As %String, UserRowid As %String, ARCOSCode As %String, ARCOSDesc As %String, ARCOSCatID As %String, ARCOSSubCatID As %String, ARCOSEffectDate As %String, ARCOSAlias As %String, UserID As %String, FavDepList As %String, DocMedUnit As %String, HospID As %String = "", CelerType As %String = "N", LogonHospId As %String = "", Type As %String = "") As %String
{
	s ^tmpgry("SaveAsUser")=OldARCOSRowid_","_UserRowid_","_ARCOSCode_","_ARCOSDesc_","_ARCOSCatID_","_ARCOSSubCatID_","_ARCOSEffectDate_","_ARCOSAlias_","_UserID_","_FavDepList_","_DocMedUnit
	n obj,FavRowid,ret,ARCOSRowid,ItemRowid,ARCOSDateRowid,ARCIMRowid,ItemQty,ItemDoseQty,ItemDoseUOMID,ItemFrequenceID,ItemDurationID,ItemInstructionID,ItmLinkDoctor,ARCOSItemNO
	s LogonHospId=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(LogonHospId)
	s ret=..InsertUserARCOS(UserRowid,ARCOSCode,ARCOSDesc,ARCOSCatID,ARCOSSubCatID,ARCOSEffectDate,ARCOSAlias,UserID,FavDepList,DocMedUnit,HospID,CelerType,LogonHospId,"","",Type)
	b ;1
	q:ret=-1 ret
	s ARCOSRowid=$p(ret,$C(1),2)
	s FavRowid=$p(ret,$C(1),1)
	s OldARCOSDateRowid=##class(web.DHCARCOrdSets).GetOrderSetDate(OldARCOSRowid)
    
    &SQL(select ARCOS_PrescTypeCode,ARCOS_DurationDR, 
		ARCOS_FrequencyDR, ARCOS_Instr_DR, ARCOS_InstrLinkDosage_DR,ARCOS_Notes
		into :PrescTypeCode,:DuratId,:FreqId,:InstrId,:DoseQtyId,:Notes
		from SQLUser.ARC_OrdSets
	   WHERE ARCOS_RowId1=:OldARCOSRowid)
    s ret=##class(DHCDoc.DHCDocConfig.OrdSets).SaveOSCNInfo(ARCOSRowid, PrescTypeCode, DoseQtyId, DuratId, FreqId, InstrId, Notes)
    q:ret'=0 ret
    kill ^TempArcosSerialNo
    if (+OldARCOSDateRowid'=0) {
	    s NO=1
		s item=0 
		for {
			s item=$o(^ARCOS(+OldARCOSDateRowid,"DATE",$p(OldARCOSDateRowid,"||",2),"ITM",item)) q:item=""  s s=^(item) d
		 	s ARCIMRowid=$p(s,"^",1)
		 	s ITMSerialNo=$p($G(^ARCOS(+OldARCOSDateRowid,"DATE",$p(OldARCOSDateRowid,"||",2),"ITM",item)),"^",20)
		 	s ^TempArcosSerialNo($J,NO)=ITMSerialNo_"^"_OldARCOSDateRowid_"||"_item_"^"_ARCIMRowid  s NO=NO+1
		}
		s item=0 
		for {
			s item=$o(^ARCOS(+OldARCOSDateRowid,"DATE",$p(OldARCOSDateRowid,"||",2),"OS",item)) q:item=""  s s=^(item) d
		 	s ARCIMRowid=$p(s,"^",1)
		 	s SerialNo=$p(s,"^",3)
		 	s ^TempArcosSerialNo($J,NO)=SerialNo_"^"_OldARCOSDateRowid_"||"_item_"^"_ARCIMRowid  s NO=NO+1
		}
		//排序
		s NO=0
		for {
			s NO=$O(^TempArcosSerialNo($J,NO)) q:NO=""
			s data=$g(^TempArcosSerialNo($J,NO))
			s SerialNo1=$p(data,"^",1)
			s NO1=NO
			f {
				s NO1=$O(^TempArcosSerialNo($J,NO1)) q:NO1=""
				s data1=$g(^TempArcosSerialNo($J,NO))
				s SerialNo2=$p(data1,"^",1)
				i (SerialNo1>SerialNo2) {
					s ^TempArcosSerialNo($J,NO)=data1
					s ^TempArcosSerialNo($J,NO1)=data
					s SerialNo1=SerialNo2
				}
			}
		}
		s NO=0
		for {
			s NO=$O(^TempArcosSerialNo($J,NO)) q:NO=""
			s data=$g(^TempArcosSerialNo($J,NO))
			s ARCIMRowID=$p(data,"^",3)
			s ItemRowid=$p(data,"^",2)
			if (ARCIMRowID["||"){
				&SQL(DECLARE DateItemCursor CURSOR FOR
					select ITM_ParRef,ITM_ARCIM_DR,ITM_Qty,ITM_DoseQty,ITM_UOM_DR,ITM_Freq_DR,ITM_Durat_DR,ITM_Instruc_DR,ITM_LinkDoctor,ITM_SerialNo,ITM_RecLoc_DR,ITM_Stage,ITM_PackQtyUom_DR,ITM_SkinTest,ITM_SkinTestAction,
					ITM_Priority_DR,ITM_SampleId,ITM_PriorRemarksDR,ITM_MustEnter,ITM_SpeedFlowRate,ITM_FlowRateUnit_DR,ITM_OrderBodyPartLabel,
					ITM_NotifyClinician,ITM_RemoveCeler,ITM_FreqTimeDoseQtyStr,ITM_FreqWeekStr
					into :ARCOSDateRowid,:ARCIMRowid,:ItemQty,:ItemDoseQty,:ItemDoseUOMID,:ItemFrequenceID,:ItemDurationID,:ItemInstructionID,:ItmLinkDoctor,:ARCOSItemNO,:DHCDocOrderRecLoc,:DHCDocOrderStageID,:ITMPackQtyUomRowId,:SkinTest,:SkinTestActiong,
					:DHCDocOrderTypeID,:SampleId,:OrderPriorRemarksDR,:MustEnter,:SpeedFlowRate,:FlowRateUnit,:OrderBodyPartLabel,
					:NotifyClinician,:RemoveCeler,:OrderFreqTimeDoseStr,:OrderFreqWeekStr
					from sqluser.ARC_OrdSetDateItem 
					where ITM_RowId=:ItemRowid)
				&SQL(OPEN DateItemCursor)
		    }else{
			    s (ItemQty,ItemDoseQty,ItemDoseUOMID,ItemFrequenceID,ItemDurationID,ItemInstructionID,ItmLinkDoctor,DHCDocOrderRecLoc,DHCDocOrderStageID,ITMPackQtyUomRowId,SkinTest,SkinTestActiong)=""
			    &SQL(DECLARE DateItemCursor1 CURSOR FOR
					select OS_ParRef,OS_OrderSet_DR,OS_SerialNo
					into :ARCOSDateRowid,:ARCIMRowid,:ARCOSItemNO
					from sqluser.ARC_OrdSetDateOS where OS_RowId=:ItemRowid)
					&SQL(OPEN DateItemCursor1)
			}
		    FOR {
			     if (ARCIMRowID["||"){
			     	&SQL(FETCH DateItemCursor)
			     }else{
				     &SQL(FETCH DateItemCursor1)
				 }
		         q:SQLCODE 
		         s remark=$g(^ARCOS($p(ItemRowid,"||",1),"DATE",$p(ItemRowid,"||",2),"ITM",$p(ItemRowid,"||",3),"NOTES",1))
			     /*s DHCDocOrderTypeID=$p($g(^ARCOS($p(ItemRowid,"||",1),"DATE",$p(ItemRowid,"||",2),"ITM",$p(ItemRowid,"||",3),"DHC")),"^",1)
			     s SampleId=$p($g(^ARCOS($p(ItemRowid,"||",1),"DATE",$p(ItemRowid,"||",2),"ITM",$p(ItemRowid,"||",3),"DHC")),"^",2)
			     ;插入附加说明
			     s OrderPriorRemarksDR=$p($g(^ARCOS($p(ItemRowid,"||",1),"DATE",$p(ItemRowid,"||",2),"ITM",$p(ItemRowid,"||",3),"DHC")),"^",3)
			     //;插入是否必开
			 	 s MustEnter=$p($g(^ARCOS($p(ItemRowid,"||",1),"DATE",$p(ItemRowid,"||",2),"ITM",$p(ItemRowid,"||",3),"DHC")),"^",4)
			 	 ;插入输液流速
			 	 s SpeedFlowRate=$p($g(^ARCOS($p(ItemRowid,"||",1),"DATE",$p(ItemRowid,"||",2),"ITM",$p(ItemRowid,"||",3),"DHC")),"^",5)
			 	 ;插入流速单位
			 	 s FlowRateUnit=$p($g(^ARCOS($p(ItemRowid,"||",1),"DATE",$p(ItemRowid,"||",2),"ITM",$p(ItemRowid,"||",3),"DHC")),"^",6)
			     ;插入检查申请单相关信息
			 	 s OrderBodyPartLabel=$p($g(^ARCOS($p(ItemRowid,"||",1),"DATE",$p(ItemRowid,"||",2),"ITM",$p(ItemRowid,"||",3),"DHC")),"^",7)
			 	 ;加急标志
			 	 s NotifyClinician=$p($g(^ARCOS($p(ItemRowid,"||",1),"DATE",$p(ItemRowid,"||",2),"ITM",$p(ItemRowid,"||",3),"DHC")),"^",8)
				 ;快速例外
				 s RemoveCeler=$p($g(^ARCOS($p(ItemRowid,"||",1),"DATE",$p(ItemRowid,"||",2),"ITM",$p(ItemRowid,"||",3),"DHC")),"^",9)*/
			     s ExpStr=$g(DHCDocOrderStageID)_"^"_$g(MustEnter)_"^"_$g(ITMPackQtyUomRowId)_"^"_$g(SpeedFlowRate)_"^"_$g(FlowRateUnit)_"^"_$g(OrderBodyPartLabel)_"^"_$g(SkinTest)_"^"_$g(SkinTestActiong)_"^"_$g(NotifyClinician)_"^"_$g(RemoveCeler)_"^"_$g(OrderFreqTimeDoseStr)_"^"_$g(OrderFreqWeekStr)
		         s InsertItem=##class(web.DHCARCOrdSets).InsertItem(ARCOSRowid,ARCIMRowid,ItemQty,ItemDoseQty,ItemDoseUOMID,ItemFrequenceID,ItemDurationID,ItemInstructionID,ItmLinkDoctor,remark,DHCDocOrderTypeID,SampleId,ARCOSItemNO,OrderPriorRemarksDR,DHCDocOrderRecLoc,ExpStr)
		         if (SQLCODE'=0){
				      set ^TEMP("DHCUserFavItems:SaveAsUser","Error",$J,+$h)=SQLCODE
			     }
		    }
		    if (ARCIMRowID["||"){
		   		&sql(CLOSE DateItemCursor)
		    }else{
			    &sql(CLOSE DateItemCursor1)
			}
		}
		//复制包装价格
		s PRICEChildsub=0
		for {
			s PRICEChildsub=$o(^ARCOS(OldARCOSRowid,"PRICE",PRICEChildsub)) Q:PRICEChildsub=""
			s str=$g(^ARCOS(OldARCOSRowid,"PRICE",PRICEChildsub))
			continue:str=""
			s Tariff=$p(str,"^",3)
			s DateFrom=$p(str,"^",1)
			s DateTo=$p(str,"^",2)
			s Price=$p(str,"^",4)
			s Hospital=$p(str,"^",7)
			d ##class(web.DHCUserFavItemPrice).insert(ARCOSRowid,DateFrom,DateTo,Tariff,Price,Hospital)
		}
	}
    /*
	&SQL(DECLARE DateItemCursor CURSOR FOR
		select ITM_RowId, ITM_ParRef,ITM_ARCIM_DR,ITM_Qty,ITM_DoseQty,ITM_UOM_DR,ITM_Freq_DR,ITM_Durat_DR,ITM_Instruc_DR,ITM_LinkDoctor,ITM_SerialNo,ITM_RecLoc_DR,ITM_Stage,ITM_PackQtyUom_DR,ITM_SkinTest,ITM_SkinTestAction
		into :ItemRowid,:ARCOSDateRowid,:ARCIMRowid,:ItemQty,:ItemDoseQty,:ItemDoseUOMID,:ItemFrequenceID,:ItemDurationID,:ItemInstructionID,:ItmLinkDoctor,:ARCOSItemNO,:DHCDocOrderRecLoc,:DHCDocOrderStageID,:ITMPackQtyUomRowId,:SkinTest,:SkinTestActiong
		from sqluser.ARC_OrdSetDateItem 
		where ITM_ParRef=:OldARCOSDateRowid)
    &SQL(OPEN DateItemCursor)
    FOR {
	     &SQL(FETCH DateItemCursor)
         q:SQLCODE 
         s remark=$g(^ARCOS($p(ItemRowid,"||",1),"DATE",$p(ItemRowid,"||",2),"ITM",$p(ItemRowid,"||",3),"NOTES",1))
	     s DHCDocOrderTypeID=$p($g(^ARCOS($p(ItemRowid,"||",1),"DATE",$p(ItemRowid,"||",2),"ITM",$p(ItemRowid,"||",3),"DHC")),"^",1)
	     s SampleId=$p($g(^ARCOS($p(ItemRowid,"||",1),"DATE",$p(ItemRowid,"||",2),"ITM",$p(ItemRowid,"||",3),"DHC")),"^",2)
	     ;插入附加说明
	     s OrderPriorRemarksDR=$p($g(^ARCOS($p(ItemRowid,"||",1),"DATE",$p(ItemRowid,"||",2),"ITM",$p(ItemRowid,"||",3),"DHC")),"^",3)
	     //;插入是否必开
	 	 s MustEnter=$p($g(^ARCOS($p(ItemRowid,"||",1),"DATE",$p(ItemRowid,"||",2),"ITM",$p(ItemRowid,"||",3),"DHC")),"^",4)
	 	 ;插入输液流速
	 	 s SpeedFlowRate=$p(^ARCOS($p(ItemRowid,"||",1),"DATE",$p(ItemRowid,"||",2),"ITM",$p(ItemRowid,"||",3),"DHC"),"^",5)
	 	 ;插入流速单位
	 	 s FlowRateUnit=$p(^ARCOS($p(ItemRowid,"||",1),"DATE",$p(ItemRowid,"||",2),"ITM",$p(ItemRowid,"||",3),"DHC"),"^",6)
	     ;插入检查申请单相关信息
	 	 s OrderBodyPartLabel=$p(^ARCOS($p(ItemRowid,"||",1),"DATE",$p(ItemRowid,"||",2),"ITM",$p(ItemRowid,"||",3),"DHC"),"^",7)
	 	 ;加急标志
	 	 s NotifyClinician=$p(^ARCOS($p(ItemRowid,"||",1),"DATE",$p(ItemRowid,"||",2),"ITM",$p(ItemRowid,"||",3),"DHC"),"^",8)
		 ;快速例外
		 s RemoveCeler=$p(^ARCOS($p(ItemRowid,"||",1),"DATE",$p(ItemRowid,"||",2),"ITM",$p(ItemRowid,"||",3),"DHC"),"^",9)
	     s ExpStr=DHCDocOrderStageID_"^"_MustEnter_"^"_ITMPackQtyUomRowId_"^"_SpeedFlowRate_"^"_FlowRateUnit_"^"_OrderBodyPartLabel_"^"_SkinTest_"^"_SkinTestActiong_"^"_NotifyClinician_"^"_RemoveCeler
         s InsertItem=##class(web.DHCARCOrdSets).InsertItem(ARCOSRowid,ARCIMRowid,ItemQty,ItemDoseQty,ItemDoseUOMID,ItemFrequenceID,ItemDurationID,ItemInstructionID,ItmLinkDoctor,remark,DHCDocOrderTypeID,SampleId,ARCOSItemNO,OrderPriorRemarksDR,DHCDocOrderRecLoc,ExpStr)
         if (SQLCODE'=0){
		      set ^TEMP("DHCUserFavItems:SaveAsUser","Error",$J,+$h)=SQLCODE
	     }
    }
   &sql(CLOSE DateItemCursor)*/
   q FavRowid
}

/// w ##class(web.DHCUserFavItems).test()
ClassMethod test()
{
	s OldARCOSDateRowid="3798||1"
	kill ^TempArcosSerialNo
    s NO=1
	s item=0 
	for {
		s item=$o(^ARCOS(+OldARCOSDateRowid,"DATE",$p(OldARCOSDateRowid,"||",2),"ITM",item)) q:item=""  s s=^(item) d
	 	s ARCIMRowid=$p(s,"^",1)
	 	s ITMSerialNo=$p($G(^ARCOS(+OldARCOSDateRowid,"DATE",$p(OldARCOSDateRowid,"||",2),"ITM",item)),"^",20)
	 	s ^TempArcosSerialNo($J,NO)=ITMSerialNo_"^"_OldARCOSDateRowid_"||"_item_"^"_ARCIMRowid  s NO=NO+1
	}
	s item=0 
	for {
		s item=$o(^ARCOS(+OldARCOSDateRowid,"DATE",$p(OldARCOSDateRowid,"||",2),"OS",item)) q:item=""  s s=^(item) d
	 	s ARCIMRowid=$p(s,"^",1)
	 	s SerialNo=$p(s,"^",3)
	 	s ^TempArcosSerialNo($J,NO)=SerialNo_"^"_OldARCOSDateRowid_"||"_item_"^"_ARCIMRowid  s NO=NO+1
	}
	//排序
	s NO=0
	for {
		s NO=$O(^TempArcosSerialNo($J,NO)) q:NO=""
		s data=$g(^TempArcosSerialNo($J,NO))
		s SerialNo1=$p(data,"^",1)
		s NO1=NO
		f {
			s NO1=$O(^TempArcosSerialNo($J,NO1)) q:NO1=""
			s data1=$g(^TempArcosSerialNo($J,NO))
			s SerialNo2=$p(data1,"^",1)
			i (SerialNo1>SerialNo2) {
				s ^TempArcosSerialNo($J,NO)=data1
				s ^TempArcosSerialNo($J,NO1)=data
				s SerialNo1=SerialNo2
			}
		}
	}
	b //45
}

/// 返回模板参数表的rowid
/// 没有保存参数时的模板id,西药保存参数时的模板id，中药保存参数时的模板id
/// w ##class(web.DHCUserFavItems).GetUserwebsysPreferencesID(12175,113,"WNewOrderEntry","User.CTLOC")
ClassMethod GetUserwebsysPreferencesID(UserID As %String = "", CTLoc As %String = "", XCONTEXT As %String = "", ObjectType As %String = "")
{
	//^websys.PreferencesI("Index", "User.SSUser", UserID, "WNewOrderEntry", "OEOrder.PrefTabs.EditList", 0)
	if (CTLoc="") s CTLoc=%session.Data("LOGON.CTLOCID")
	s LogonHospDr=$p(^CTLOC(CTLoc),"^",22)
	s LogonHospDr=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(LogonHospDr)
	s PrefType=##class(epr.PreferencesQuery).GetPrefTypeByLoc(CTLoc)
 	if (ObjectType="") s ObjectType="User.SSUser"
 	if (ObjectType="User.SSUser") {
	 	s ObjectReferance=UserID
	}else{
		s ObjectReferance=CTLoc
	}
	s CYid="",XYid=""
	s id=$o(^websys.PreferencesI("Index", ObjectType, ObjectReferance, "ORDERI", "OEOrder.PrefTabs.EditList", 0))
	if (ObjectType="User.SSUser") {
		s CYAppKey="ORDERW50007"_PrefType_"_HospDr"_LogonHospDr
		s CYid=$o(^websys.PreferencesI("Index", ObjectType, ObjectReferance, CYAppKey, "OEOrder.PrefTabs.EditList", 0))
	}
	if (CYid="") {
		s CYAppKey="ORDERW50007"
		if (ObjectType="User.SSUser") {
			s CYAppKey=CYAppKey_"_HospDr"_LogonHospDr
		}
		s CYid=$o(^websys.PreferencesI("Index", ObjectType, ObjectReferance, CYAppKey, "OEOrder.PrefTabs.EditList", 0))
	}
	
	if (ObjectType="User.SSUser") {
		s XYAppKey="ORDERWNewOrderEntry"_PrefType_"_HospDr"_LogonHospDr
		s XYid=$o(^websys.PreferencesI("Index", ObjectType, ObjectReferance, XYAppKey, "OEOrder.PrefTabs.EditList", 0))
	}
	if (XYid="") {
		s XYAppKey="ORDERWNewOrderEntry"
		if (ObjectType="User.SSUser") {
			s XYAppKey=XYAppKey_"_HospDr"_LogonHospDr
		}
		s XYid=$o(^websys.PreferencesI("Index", ObjectType, ObjectReferance, XYAppKey, "OEOrder.PrefTabs.EditList", 0))
	}
	Q id_","_XYid_","_CYid
}

/// w ##class(web.DHCUserFavItems).SaveToTemplate(5603,3,1,"2759||1","ARCIM")
ClassMethod SaveToTemplate(ID As %String = "", TabNameIndex As %String, groupnameIndex As %String, ARCOSRowid As %String, Type As %String = "ARCOS") As %String
{
	
	s ^tmpscl("SaveToTemplate")=ID_","_TabNameIndex_","_groupnameIndex_","_ARCOSRowid_","_Type
	q:ID="" "-1^保存失败"
	q:TabNameIndex="" "-1^保存失败"
	q:groupnameIndex="" "-1^保存失败"
	q:ARCOSRowid="" "-1^保存失败"
	s RepeatFlag=0
	s InsertItemString=Type_$c(4)_ARCOSRowid
	s String=$lg($lg(^websys.PreferencesD(ID),3),3)
	s selString=$list(String,TabNameIndex)
	s GroupString=$p(selString,$c(1),2,$l(selString,$c(1)))
	s selGroupData=$p(GroupString,$c(1),groupnameIndex)
	s selGroupName=$p(selGroupData,$c(28),1)
	s data=""
	for i=2:1:$l(selGroupData,$c(28)){
		if ($p($p(selGroupData,$c(28),i),$c(4),2)=ARCOSRowid){
			s RepeatFlag=1
			Q 
		}
		if ($p(selGroupData,$c(28),i)'=""){
			i data="" s data=selGroupName_$c(28)_$p(selGroupData,$c(28),i)
			e  s data=data_$c(28)_$p(selGroupData,$c(28),i)
		}
	}
	if (RepeatFlag=1){
		s ARCOSRowid=$p(ARCOSRowid,"*S*",1)
		if (Type="ARCOS"){
			s desc=$p(^ARCOS(ARCOSRowid),"^",2)
			Q "-1^医嘱套【"_desc_"】已存在!"
		}else{
			s desc=$p(^ARCIM(+ARCOSRowid,$p(ARCOSRowid,"||",2),1),"^",2)
			Q "-1^医嘱项【"_desc_"】已存在!"
		}
	}
	if (InsertItemString'=""){
		i data="" s data=selGroupName_$c(28)_InsertItemString
		else  s data=data_$c(28)_InsertItemString
	}
	s selGroupData=data
	
	s $p(GroupString,$c(1),groupnameIndex)=selGroupData
	s $p(selString,$c(1),2,$l(selString,$c(1)))=GroupString
	s $list(String,TabNameIndex)=selString
	s c=$lb("","",String,0,0)
	s ^tempsc("group1")=c
	b //
	s $list(^websys.PreferencesD(ID),3)=c
	q 0
	
	
	/*s Tablength=$ll(String)
	s NewString=""
	s i =0 f  s i=i+1 q:i>Tablength  d
	.s groupString=$lg(String,i)
	.s grouplength=$l(groupString,$c(1))
	.s NewgroupContextString=""
	.s j=0 f  s j=j+1 q:j>grouplength  d
	..s groupContextString=$p(groupString,$c(1),j)
	..if j=1 s OneTabName=groupContextString,NewgroupContextString=groupContextString q
	..s NewOneitemstring=""
	..s ItemLength=$l(groupContextString,$c(28))
	..s m=0 f  s m=m+1 q:m>ItemLength  d
	...s Oneitemstring=$p(groupContextString,$c(28),m)
	...if m=1 s Onegroupname=Oneitemstring
	...if (OneTabName=TabName)&&(Onegroupname=groupname)&&(m=ItemLength) s Oneitemstring=Oneitemstring_$c(28)_InsertItemString
	...if m=1 s Onegroupname=Oneitemstring,NewOneitemstring=Oneitemstring q
	...s NewOneitemstring=NewOneitemstring_$c(28)_Oneitemstring
	..s NewgroupContextString=NewgroupContextString_$c(1)_NewOneitemstring
	.if i=1 s lb=$lb(NewgroupContextString) q
	.s $list(lb,i)=NewgroupContextString
	s c=$lb("","",lb,0,0)
	s a=$lg(^websys.PreferencesD(ID),1)
	s b=$lg(^websys.PreferencesD(ID),2)
	s d=$lg(^websys.PreferencesD(ID),4)
	s e=$lg(^websys.PreferencesD(ID),5)
	s ret=$lb(a,b,c,d,e)
	s ^TEMPzhangkui("SaveToTemplate")=ret
	s ^websys.PreferencesD(ID)=ret
	q 0*/
}

/// w ##class(web.DHCUserFavItems).GetTabNameString(79)
ClassMethod GetTabNameString(UserID As %String, Type As %String = "西药", CTLOCID, XCONTEXT, ObjectType As %String = "User.SSUser") As %String
{
	s IDString=..GetUserwebsysPreferencesID(UserID,CTLOCID,XCONTEXT,ObjectType)
	if Type="西药" d
	.s ID=$p(IDString,",",2)
	else  s ID=$p(IDString,",",3)
	q:ID="" ""
	s String=$lg($lg(^websys.PreferencesD(ID),3),3)
	s Tablength=$ll(String)
	s ret="",Index=0
	s i =0 f  s i=i+1 q:i>Tablength  d
	.s groupString=$lg(String,i)
	.s grouplength=$l(groupString,$c(1))
	.s NewgroupContextString=""
	.s j=0 f  s j=j+1 q:j>grouplength  d
	..s groupContextString=$p(groupString,$c(1),j)
	..q:j'=1
	..s OneTabName=groupContextString
	..s Index=Index+1
	..s ret=..setret(ret,OneTabName,Index)
	q ret
}

/// w ##class(web.DHCUserFavItems).GetGroupDescString(4634,"西药",2,110,"WNewOrderEntry",User.SSUser)
ClassMethod GetGroupDescString(UserID As %String, Type As %String = "西药", TabNameIndex As %String, CTLOCID, XCONTEXT, ObjectType As %String = "User.SSUser") As %String
{
	s ^Tempscl("GetGroupDescString")=UserID_","_Type_","_TabNameIndex_","_CTLOCID_","_XCONTEXT_","_ObjectType
	q:TabNameIndex="" ""
	s IDString=..GetUserwebsysPreferencesID(UserID,CTLOCID,XCONTEXT,ObjectType)
	if Type="西药" d
	.s ID=$p(IDString,",",2)
	else  s ID=$p(IDString,",",3)
	q:ID="" ""
	s ret=""
	s String=$lg($lg(^websys.PreferencesD(ID),3),3)
	s Tablength=$ll(String)
	b //34
	s selString=$list(String,TabNameIndex)
	s GroupString=$p(selString,$c(1),2,$l(selString,$c(1)))
	for i=1:1:$l(GroupString,$c(1)){
		s oneGroupString=$p(GroupString,$c(1),i)
		s oneGroupName=$p(oneGroupString,$c(28),1)
		b //
		continue:oneGroupName=""
		s ret1=i_$C(1)_oneGroupName
	    if ret="" s ret=ret1
	    e  s ret=ret_"^"_ret1
	}
	q ret
	/*s ret=""
	s i =0 f  s i=i+1 q:i>Tablength  d
	.s groupString=$lg(String,i)
	.s grouplength=$l(groupString,$c(1))
	.s NewgroupContextString=""
	.s j=0 f  s j=j+1 q:j>grouplength  d
	..s groupContextString=$p(groupString,$c(1),j)
	..if j=1 s OnegTabName=groupContextString
	..q:OnegTabName'=TabName
	..q:j=1
	..s OnegroupName=$p(groupContextString,$c(28),1)
	..q:OnegroupName=""
	..s ret=..setret(ret,OnegroupName)
	q ret*/
}

ClassMethod setret(ret As %String, TableDesc As %String, Index As %String) As %String
{
	//s Alias=##class(ext.util.String).ToChineseSpell(TableDesc)
	set ret1=Index_$C(1)_TableDesc
	if ret="" s ret=ret1 q ret
	q ret_"^"_ret1
}

ClassMethod GetTabNameListBroker(JSFunName As %String = "", ListName As %String = "", UserID As %String, Type As %String = "西药", CTLOCID, XCONTEXT, ObjectType As %String = "User.SSUser") As %String
{
	s ^tempscl("GetTabNameListBroker")=JSFunName_","_ListName_","_UserID_","_Type_","_CTLOCID_","_XCONTEXT_","_ObjectType
	s IDString=..GetUserwebsysPreferencesID(UserID,CTLOCID,XCONTEXT,ObjectType)
	s json="["
	if Type="西药" d
	.s ID=$p(IDString,",",2)
	else  s ID=$p(IDString,",",3)
	if (ID=""){
		s mydes="",myval="",myIdx=0
		if JSFunName="GetTabNameToHUIJson"{
			s json=json_"]"
			q json
		}else{
			s rtnval=JSFunName_"('"_ListName_"','"_$ZCVT($g(mydes),"O","JS")_"','"_$ZCVT($g(myval),"O","JS")_"','"_$ZCVT($g(myIdx),"O","JS")_"');"
			&javascript<#(rtnval)#>
			q 0
		}
		
	} 
	s String=$lg($lg(^websys.PreferencesD(ID),3),3)
	s Tablength=$ll(String)
	s ret=""
	s myIdx=0
	s i =0 f  s i=i+1 q:i>Tablength  d
	.s groupString=$lg(String,i)
	.s grouplength=$l(groupString,$c(1))
	.s NewgroupContextString=""
	.s j=0 f  s j=j+1 q:j>grouplength  d
	..s groupContextString=$p(groupString,$c(1),j)
	..q:j'=1
	..s OneTabName=groupContextString
	..s Alias=##class(ext.util.String).ToChineseSpell(OneTabName)
	..s OneTabName=##class(web.DHCDocUtil).EvalJSON(OneTabName)
	..s mydes=OneTabName,myval=myIdx+1
	..if JSFunName="GetTabNameToHUIJson" d
	...s OneJsonData="{""text"":"""_$g(mydes)_""",""id"":"""_$g(myval)_""""
	...s OneJsonData=OneJsonData_"}"
	...i myIdx=0 d
	....s json=json_OneJsonData
	...e  d
	....s json=json_","_OneJsonData
	..e  d
	...s rtnval=JSFunName_"('"_ListName_"','"_$ZCVT($g(mydes),"O","JS")_"','"_$ZCVT($g(myval),"O","JS")_"','"_$ZCVT($g(myIdx),"O","JS")_"');"
	...&javascript<#(rtnval)#>
	..s myIdx=myIdx+1
	s json=json_"]"   
	i JSFunName="GetTabNameToHUIJson" {
		q json
	}
	q 0
}

ClassMethod GetGroupDescListBroker(JSFunName As %String = "", ListName As %String = "", UserID As %String, Type As %String = "西药", TabNameIndex As %String, CTLOCID, XCONTEXT, ObjectType As %String = "User.SSUser") As %String
{
	s ret=..GetGroupDescString(UserID,Type,TabNameIndex,CTLOCID,XCONTEXT,ObjectType)
	s myIdx=0,json="["
	for i=1:1:$l(ret,"^") d
	.s OnegroupName=$p($p(ret,"^",i),$c(1),2)
    .s mydes=OnegroupName,myval=i
    .s myIdx=myIdx+1
    .i JSFunName="GetGroupToHUIJson" d
    ..s OneJsonData="{""text"":"""_$g(mydes)_""",""id"":"""_$g(myval)_""""
    ..s OneJsonData=OneJsonData_"}"
    ..i myIdx=1 d
	...s json=json_OneJsonData
	..e  d
	...s json=json_","_OneJsonData
    .e  d
	..s rtnval=JSFunName_"('"_ListName_"','"_$ZCVT($g(mydes),"O","JS")_"','"_$ZCVT($g(myval),"O","JS")_"','"_$ZCVT($g(myIdx),"O","JS")_"');"
	..&javascript<#(rtnval)#>
	s json=json_"]"   
	i JSFunName="GetGroupToHUIJson" {
		q json
	}
	q 0
	/*q:TabName="" ""
	s IDString=..GetUserwebsysPreferencesID(UserID,CTLOCID,XCONTEXT)
	if Type="西药" d
	.s ID=$p(IDString,",",2)
	else  s ID=$p(IDString,",",3)
	q:ID="" ""
	s String=$lg($lg(^websys.PreferencesD(ID),3),3)
	s Tablength=$ll(String)
	s ret=""
	s myIdx=0
	s i =0 f  s i=i+1 q:i>Tablength  d
	.s groupString=$lg(String,i)
	.s grouplength=$l(groupString,$c(1))
	.s NewgroupContextString=""
	.s j=0 f  s j=j+1 q:j>grouplength  d
	..s groupContextString=$p(groupString,$c(1),j)
	..if j=1 s OnegTabName=groupContextString
	..q:OnegTabName'=TabName
	..q:j=1
	..s OnegroupName=$p(groupContextString,$c(28),1)
	..q:OnegroupName=""
	..;s Alias=##class(ext.util.String).ToChineseSpell(OnegroupName)
	..s mydes=OnegroupName,myval=OnegroupName
	..s rtnval=JSFunName_"('"_ListName_"','"_$ZCVT($g(mydes),"O","JS")_"','"_$ZCVT($g(myval),"O","JS")_"','"_$ZCVT($g(myIdx),"O","JS")_"');"
	..;s rtnval=rtnval_"','"_$ZCVT(mySelFlag,"O","JS")_"');"
	..&javascript<#(rtnval)#>
	..s myIdx=myIdx+1
	q 0*/
}

/// w ##class(web.DHCUserFavItems).AddTabName(10209,"西药","新增测试",95,"WNewOrderEntry","User.SSUser")
ClassMethod AddTabName(UserID As %String, Type As %String = "西药", TabName As %String, CTLOCID, XCONTEXT, ObjectType) As %String
{
	s ^Tempscl("AddTabName")=UserID_","_Type_","_TabName_","_CTLOCID_","_XCONTEXT_","_ObjectType
	//如果没有找到模板id，则新增
	if (CTLOCID="") s CTLOCID=%session.Data("LOGON.CTLOCID")
	s LogonHospDr=$p(^CTLOC(CTLOCID),"^",22)
	s LogonHospDr=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(LogonHospDr)
	s IDString=..GetUserwebsysPreferencesID(UserID,CTLOCID,XCONTEXT,ObjectType)
	if Type="西药" d
	.s ID=$p(IDString,",",2)
	else  s ID=$p(IDString,",",3)
	if (ID="") {
		s PrefType=##class(epr.PreferencesQuery).GetPrefTypeByLoc(CTLOCID)
	 	s key="ORDER"_XCONTEXT //_PrefType
	 	if (ObjectType="") s ObjectType="User.SSUser"
	 	if (ObjectType="User.SSUser") {
		 	s ObjectReferance=UserID
		 	s key="ORDER"_XCONTEXT_PrefType
		 	s key=key_"_HospDr"_LogonHospDr
		}else{
			s ObjectReferance=CTLOCID
		}
		s AppSubKey="OEOrder.PrefTabs.EditList"
		&sql(insert into SQLUser.websys.Preferences set AppKey=:key,AppSubKey=:AppSubKey,ObjectReference=:ObjectReferance,ObjectType=:ObjectType)
		q:SQLCODE'=0 SQLCODE
		s ID=$p(%ROWID,$c(1))
		q:ID="" ""
	}
	s InsertItemString=TabName_$c(1,1,1,1,1) //_$c(1,1,1,1,1,1,1)
	s String=$lg($lg(^websys.PreferencesD(ID),3),3)
	s Tablength=$ll(String)
	b //90
	s ret=""
	s $list(String,Tablength+1)=InsertItemString
	s c=$lb("","",String,0,0)
	s a=$lg(^websys.PreferencesD(ID),1)
	s b=$lg(^websys.PreferencesD(ID),2)
	s d=$lg(^websys.PreferencesD(ID),4)
	s e=$lg(^websys.PreferencesD(ID),5)
	s ret=$lb(a,b,c,d,e)
	//s ^zhangkui("ret")=ret
	s ^websys.PreferencesD(ID)=ret
	q 0
}

/// w ##class(web.DHCUserFavItems).AddGroupDesc(4634,"西药",2,"一次性2",110,"WNewOrderEntry","User.CTLoc")
ClassMethod AddGroupDesc(UserID As %String, Type As %String = "西药", TabNameIndex As %String, GroupDesc As %String, CTLOCID, XCONTEXT, ObjectType) As %String
{
	s ^tempscl("AddGroupDesc")=UserID_","_Type_","_TabNameIndex_","_GroupDesc_","_CTLOCID_","_XCONTEXT
	
	s IDString=..GetUserwebsysPreferencesID(UserID,CTLOCID,XCONTEXT,ObjectType)
	if Type="西药" d
	.s ID=$p(IDString,",",2)
	else  s ID=$p(IDString,",",3)
	b //451
	q:ID="" ""
	q:TabNameIndex="" "-^插入失败,表头名字不能为空"
	q:GroupDesc="" "-^插入失败,表名字不能为空"
	s TotalNum=..GetGroupDescNum(UserID,Type,TabNameIndex,CTLOCID, XCONTEXT,ObjectType)
	if (TotalNum>4) q "-2^插入失败，模板子表不能多于5个"
	s String=$lg($lg(^websys.PreferencesD(ID),3),3)
	s Tablength=$ll(String)
	s selString=$list(String,TabNameIndex)
	s selTableName=$p(selString,$c(1),1)
	s GroupString=$p(selString,$c(1),2,$l(selString,$c(1)))
	s FindFlag=0,TABLIST=""
	for i=1:1:$l(GroupString,$c(1)){
		s oneGroupString=$p(GroupString,$c(1),i)
		s oneGroupName=$p(oneGroupString,$c(28),1)
		s oneGroupData=$p(oneGroupString,$c(28),2,$l(oneGroupString,$c(28)))
		if (oneGroupName="")&&(FindFlag=0){
			s oneGroupName=GroupDesc
			s FindFlag=1
		}
		i TABLIST="" s TABLIST=oneGroupName_$c(28)_oneGroupData
		e  s TABLIST=TABLIST_$c(1)_oneGroupName_$c(28)_oneGroupData
	}
	if (FindFlag=0){
		i TABLIST="" s TABLIST=GroupDesc_$c(28)_""
		e  s TABLIST=TABLIST_$c(1)_GroupDesc_$c(28)_""
	}
	s TABLIST=selTableName_$c(1)_TABLIST
	s $list(String,TabNameIndex)=TABLIST
	s ^tempscl("group")=String
    s c=$lb("","",String,0,0)
	s ^tempsc("group1")=c
	b //89
	s $list(^websys.PreferencesD(ID),3)=c
	q 0
	/*s SuccessFlag=0
	s InsertItemString=GroupDesc
	s String=$lg($lg(^websys.PreferencesD(ID),3),3)
	s Tablength=$ll(String)
	s ret=""
	s NewString=$lb()
	s i =0 f  s i=i+1 q:i>Tablength  d
	.s NewgroupContextString=""
	.s groupString=$lg(String,i)
	.s grouplength=$l(groupString,$c(1))
	.s NewgroupContextString=""
	.s j=0 f  s j=j+1 q:(j>grouplength)||(NewgroupContextString'="")  d
	..s groupContextString=$p(groupString,$c(1),j)
	..if j=1 s OneTabDesc=groupContextString
	..q:OneTabDesc'=TabName
	..b //34
	..if (groupContextString="")&&(j'=1) s NewgroupContextString=$p(groupString,$c(1),1,(j-1))_$c(1)_InsertItemString_$p(groupString,$c(1),j,grouplength),SuccessFlag=1
	.if NewgroupContextString="" s NewgroupContextString=groupString
	.s $list(NewString,i)=NewgroupContextString
	.//s ^zhangkui("end")=NewString
	s ^zhangkui("111")=NewString
	b //45
	q:SuccessFlag'=1 "-^插入失败"
	s c=$lb("","",NewString,0,0)
	s a=$lg(^websys.PreferencesD(ID),1)
	s b=$lg(^websys.PreferencesD(ID),2)
	s d=$lg(^websys.PreferencesD(ID),4)
	s e=$lg(^websys.PreferencesD(ID),5)
	s ret=$lb(a,b,c,d,e)
	b //90
	//s ^zhangkui("ret")=ret
	s ^websys.PreferencesD(ID)=ret
	q 0*/
}

ClassMethod GetGroupDescNum(UserID As %String, Type As %String = "西药", TabNameIndex As %String, CTLOCID, XCONTEXT, ObjectType) As %String
{
	s Num=0
	q:TabNameIndex="" Num
	s IDString=..GetUserwebsysPreferencesID(UserID,CTLOCID,XCONTEXT,ObjectType)
	if Type="西药" d
	.s ID=$p(IDString,",",2)
	else  s ID=$p(IDString,",",3)
	q:ID="" Num
	s String=$lg($lg(^websys.PreferencesD(ID),3),3)
	s Tablength=$ll(String)
	s selString=$list(String,TabNameIndex)
	s GroupString=$p(selString,$c(1),2,$l(selString,$c(1)))
	for i=1:1:$l(GroupString,$c(1)){
		s oneGroupString=$p(GroupString,$c(1),i)
		s oneGroupName=$p(oneGroupString,$c(28),1)
		if (oneGroupName'=""){
			s Num=Num+1
		}
	}
	Q Num
	/*s String=$lg($lg(^websys.PreferencesD(ID),3),3)
	s Tablength=$ll(String)
	s ret=""
	s i =0 f  s i=i+1 q:i>Tablength  d
	.s groupString=$lg(String,i)
	.s grouplength=$l(groupString,$c(1))
	.s NewgroupContextString=""
	.s j=0 f  s j=j+1 q:j>grouplength  d
	..s groupContextString=$p(groupString,$c(1),j)
	..if j=1 s OnegTabName=groupContextString
	..q:OnegTabName'=TabName
	..q:j=1
	..s OnegroupName=$p(groupContextString,$c(28),1)
	..q:OnegroupName=""
	..s Num=Num+1
	q Num*/
}

ClassMethod GetARCOSInfo(OrderARCOSRowid As %String) As %String
{
	q:(OrderARCOSRowid="") ""
	Q:'$d(^ARCOS(OrderARCOSRowid)) ""
	s ARCOSName=$P(^ARCOS(OrderARCOSRowid),"^",2)
	s FavRowid=$O(^DHCFavItems(0,"ItemRowid",OrderARCOSRowid,""),-1)
	s CelerType=""
	if (FavRowid'=""){
		s CelerType=$P(^DHCFavItems(FavRowid),"^",10)
	}
	s OutPutInfo=ARCOSName_"^"_CelerType
	q OutPutInfo
}

/// lxz 根据医嘱套ID获取医嘱套别名
Query FindAlias(ArcosID As %String) As %Query(ROWSPEC = "ALiCode:%String,ALIASRowId:%String")
{
}

ClassMethod FindAliasExecute(ByRef qHandle As %Binary, ArcosID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	if ArcosID'=""  d
 	.s ALIASRowId=0
 	.f  s ALIASRowId=$O(^ARC("ALIAS",0,"ARCOS",ArcosID,ALIASRowId)) Q:ALIASRowId=""  d
 	..s ALiCode=$P($G(^ARC("ALIAS",ALIASRowId)),"^",6)
 	..Q:ALiCode=""
 	..Do OutFindAlias
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutFindAlias
	set Data=$lb(ALiCode,ALIASRowId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindAliasFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAliasExecute ]
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

ClassMethod FindAliasClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAliasExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 插入医嘱套别名 医嘱套ID,别名
ClassMethod InsertArcosAlias(ARCOSRowid As %String, Alias As %String) As %String
{
	s Alias=$ZCVT(Alias,"U")
	s NowDate=..%SysDate()
	&SQL(select ARCOS_Desc,ARCOS_OrdSubCat_DR into :ALIASDesc,:ARCOSOrdSubCatDR 
	FROM ARC_OrdSets WHERE ARCOS_RowId1=:ARCOSRowid)
	Q:SQLCODE'=0 "查询医嘱套数据错误!"

    s flag=..FormValidate(ARCOSRowid,Alias)
    Q:flag=1 "别名重复!"
	s ALIASType="ARCOS"
	
	&SQL(Insert Into SQLUser.ARC_Alias(ALIAS_ARCOS_DR,ALIAS_Text,ALIAS_Desc,ALIAS_OrderSubCat_DR,ALIAS_Type,
	ALIAS_Row_Calc,ALIAS_DateFrom)
		Values(:ARCOSRowid,:Alias,:ALIASDesc,:ARCOSOrdSubCatDR,:ALIASType,:ARCOSRowid,:NowDate
	))
	q SQLCODE
}

/// 删除医嘱套别名
ClassMethod DeleteArcosAlias(ALIASRowId As %String) As %String
{
	&SQL(delete SQLUser.ARC_Alias where ALIAS_RowId=:ALIASRowId)
	q SQLCODE
}

/// Description：数据重复校验
/// Table： ARCAlias
/// Input：Alias,ARCOSRowid
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(ARCOSRowid, Alias As %String) As %String
{
	n (ARCOSRowid,Alias)
	q:(ARCOSRowid="")||(Alias="") 0
	s flag=0
	s rowid=0
	for{
		s rowid=$o(^ARC("ALIAS",0,"ARCOS",ARCOSRowid,rowid)) q:(rowid="")||(flag=1)
		s Text=$p($g(^ARC("ALIAS",rowid)),"^",6)
		if (Alias=Text) s flag=1
	}
	q flag
}

/// Creater:宋春莉
/// Description：获取医嘱套json数据
/// Table： ARC_OrdSets
/// Input：SearchSubCatID:医嘱套子类,SearchDesc:医嘱套描述,SearchCelerType:快速标识,SearchConditiones:条件,HospARCOSAuthority:全院医嘱套权限,LogonHospID:登录院区ID
/// w ##class(web.DHCUserFavItems).GetDHCDocARCOSList("","","","","","1","12175","113","2","ARCOSOrdSubCat","asc")
ClassMethod GetDHCDocARCOSList(SearchSubCatID As %String, SearchDesc As %String, SearchAlias As %String, SearchCelerType As %String, SearchConditiones As %String, HospARCOSAuthority As %String, LogonUserID As %String, LogonCTLocId As %String, LogonHospID As %String, sort As %String = "", order As %String = "") As %String
{
	s ^tempscl("GetDHCDocARCOSList")=$lb(SearchSubCatID, SearchDesc, SearchAlias, SearchCelerType, SearchConditiones, HospARCOSAuthority, LogonUserID, LogonCTLocId, LogonHospID, sort , order)
	k DHCDocARCOSList($j)
	s SearchDesc=$ZCVT(SearchDesc,"U")
	s SearchAlias=$ZCVT(SearchAlias,"U")
	s FavRowId=0
	Set langid=..%LanguageID()
	for {
		s FavRowId=$o(^DHCFavItems(FavRowId)) Q:FavRowId=""
		s FavUseHospDr=$p(^DHCFavItems(FavRowId),"^",11)
		continue:FavUseHospDr'=LogonHospID
		s ARCOSEffDateTo=$p(^DHCFavItems(FavRowId),"^",16)
		continue:(ARCOSEffDateTo'="")&&(ARCOSEffDateTo<=..%SysDate())
		s FavUserDr=$p(^DHCFavItems(FavRowId),"^",2)
		continue:(SearchConditiones=1)&&(FavUserDr'=LogonUserID)
		s FavDepDr=$p(^DHCFavItems(FavRowId),"^",4)
		continue:(SearchConditiones=2)&&(FavDepDr'=LogonCTLocId)
		s FavHospDr=$p(^DHCFavItems(FavRowId),"^",9)
		continue:(SearchConditiones=3)&&(FavHospDr'=LogonHospID)
		continue:(SearchConditiones=3)&&((FavUserDr'="")||(FavDepDr'=""))
		s FavCelerType=$p(^DHCFavItems(FavRowId),"^",10)
		continue:(SearchCelerType="Y")&&(FavCelerType'="Y")
		s FavMedUnitDr=$p(^DHCFavItems(FavRowId),"^",8)
		if (SearchConditiones=""){
			if (FavUserDr="")&&(FavDepDr=""){
				continue:(FavHospDr'=LogonHospID)
			}else{
				continue:((FavUserDr'=LogonUserID)&&(FavDepDr'=LogonCTLocId)) 	
			}
		}
		;continue:(SearchConditiones="")&&((FavUserDr'=LogonUserID)&&(FavDepDr'=LogonCTLocId)) ;&&(FavHospDr'=LogonHospID)
		s ARCOSRowid=$p(^DHCFavItems(FavRowId),"^",3)
		continue:(ARCOSRowid="")||('$d(^ARCOS(ARCOSRowid)))
		s FavDateFrom=$p(^DHCFavItems(FavRowId),"^",12)
		s FavDateTo=$p(^DHCFavItems(FavRowId),"^",13)
		s ActiveFlag=1
		i (FavDateTo'="")&&(FavDateTo<+$h) s ActiveFlag=0
		s:FavDateFrom'="" FavDateFrom=..%ZD(FavDateFrom)
		s:FavDateTo'="" FavDateTo=..%ZD(FavDateTo)
		s ARCOSCode=$p(^ARCOS(ARCOSRowid),"^",1)
		s ARCOSDesc=$p(^ARCOS(ARCOSRowid),"^",2)
 		continue:(SearchDesc'="")&&($ZCVT(ARCOSDesc,"U")'[SearchDesc)
		s ARCOSOrdCatDR=$p(^ARCOS(ARCOSRowid),"^",8)
		s ARCOSOrdCat=$p(^OEC("ORCAT",ARCOSOrdCatDR),"^",2)
		Set ARCOSOrdCat= ##class(User.OECOrderCategory).GetTranByDesc("ORCATDesc",ARCOSOrdCat,langid)
		s ARCOSOrdSubCatDR=$p(^ARCOS(ARCOSRowid),"^",9)
		continue:(SearchSubCatID'="")&&(ARCOSOrdSubCatDR'=SearchSubCatID)
		s ARCOSOrdSubCat=$p(^ARC("IC",ARCOSOrdSubCatDR),"^",2)
		Set ARCOSOrdSubCat= ##class(User.ARCItemCat).GetTranByDesc("ARCICDesc",ARCOSOrdSubCat,langid)
		s FindAliasFlag="N",ARCOSAlias=""
 		if (SearchAlias'="") {
	 		s ARCOSAliasRowid=0
	 		for {
		 		s ARCOSAliasRowid=$o(^ARC("ALIAS",0,"ARCOS",ARCOSRowid,ARCOSAliasRowid)) Q:(ARCOSAliasRowid="")||((ARCOSAlias'="")&&(FindAliasFlag="Y"))
		 		s ALIASDateFrom=$P(^ARC("ALIAS",ARCOSAliasRowid),"^",12)
		 		continue:(ALIASDateFrom'="")&&(ALIASDateFrom>+$h)
		 		s ALIASDateTo=$P(^ARC("ALIAS",ARCOSAliasRowid),"^",13)
		 		continue:(ALIASDateTo'="")&&(ALIASDateTo<+$h)
		 		s ALIASText=$P(^ARC("ALIAS",ARCOSAliasRowid),"^",6)
		 		i ARCOSAlias="" s ARCOSAlias=ALIASText
		 		if (SearchAlias'="")&&($ZCVT(ALIASText,"U")[SearchAlias) s FindAliasFlag="Y"
		 	}
	 	}else{
		 	s ARCOSAliasRowid=$O(^ARC("ALIAS",0,"ARCOS",ARCOSRowid,0))
	 		if ARCOSAliasRowid'="" {
	 			s ARCOSAlias=$P(^ARC("ALIAS",ARCOSAliasRowid),"^",6)
	 		}
		}
 		continue:(SearchAlias'="")&&(FindAliasFlag="N")
 		s ARCOSAddUser=""
		s ARCOSAddUserDr=$p(^ARCOS(ARCOSRowid),"^",29)
		if ARCOSAddUserDr'="" s ARCOSAddUser=$p($g(^SSU("SSUSR",ARCOSAddUserDr)),"^",2)
		 s ARCOSAddUser =##class(User.SSUser).GetTranByDesc("SSUSRName",ARCOSAddUser,langid)
		s ARCOSAddDate=$p(^ARCOS(ARCOSRowid),"^",30)
		s ARCOSAddTime=$p(^ARCOS(ARCOSRowid),"^",31)
		i ARCOSAddTime'=""  s ARCOSAddTime=..%ZT(ARCOSAddTime,1)
		i ARCOSAddDate'="" s ARCOSAddDate=..%ZD(ARCOSAddDate)_" "_ARCOSAddTime
		s ARCOSEffDateFrom=$p(^ARCOS(ARCOSRowid),"^",15)
		s ARCOSEffDateTo=$p(^ARCOS(ARCOSRowid),"^",16)
		;开始日期和结束日期当天应该都算有效数据(和医嘱套明细保持一致)
	    s ActiveFlag=(ARCOSEffDateFrom<=+$H)&&(ARCOSEffDateFrom'="")&&((ARCOSEffDateTo="")||(ARCOSEffDateTo>=+$H))
		s PrescTypeCode=$p(^ARCOS(ARCOSRowid),"^",26)
		s DuratId=$p(^ARCOS(ARCOSRowid),"^",20)
		s FreqId=$p(^ARCOS(ARCOSRowid),"^",21)
		s InstrId=$p(^ARCOS(ARCOSRowid),"^",27)
		s DosageId=$p(^ARCOS(ARCOSRowid),"^",28)
		s Notes=$p(^ARCOS(ARCOSRowid),"^",25)
		s FavUserDesc="",FavDepDesc=""
		s:FavUserDr'="" FavUserDesc=$p(^SSU("SSUSR",FavUserDr),"^",2)
		s FavUserDesc =##class(User.SSUser).GetTranByDesc("SSUSRName",FavUserDesc,langid)
		s:FavDepDr'="" FavDepDesc=$p(^CTLOC(FavDepDr),"^",2)
		s FavDepDesc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",FavDepDesc,langid)
		d SetDataJson
		if (sort ="") {
			s ARCOSRowidSort=ARCOSRowid
		}else{
			k OneJsonCongeriesArr
			d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(OneJson.%ToJSON(),.OneJsonCongeriesArr)
			s ARCOSRowidSort=$g(OneJsonCongeriesArr(sort))_""_ARCOSRowid
		}
		if (FavUserDr'="") {
			s OneJson.Type="User"
			s DHCDocARCOSList($j,"User",ARCOSRowidSort)=OneJson
		}elseif(FavDepDr'=""){
			s OneJson.Type="Loc"
			s DHCDocARCOSList($j,"Loc",ARCOSRowidSort)=OneJson
		}else{
			s OneJson.Type="Hosp"
			s DHCDocARCOSList($j,"Hosp",ARCOSRowidSort)=OneJson
		}
	}
	s JsonObj=[]
	s TypeStr="User^Loc^Hosp"
	for i=1:1:$l(TypeStr,"^"){
		continue:(SearchConditiones>0)&&(i'=SearchConditiones)
		s Type=$p(TypeStr,"^",i)
		s OneJson={}
		do OneJson.%Set("Index",Type)
		do OneJson.%Set("Type",Type)
		s Name=$case(Type,"User":"个人组套","Loc":"科室组套","Hosp":"全院组套")
		s Name=##class(websys.Translation).Get("udhcfavitem.edit.hui.csp",Name)
		do OneJson.%Set("Name",Name)
		s childrenJson=[]
		if (order="")||(order="asc") {
			s ARCOSRowidSort=""
			for {
				s ARCOSRowidSort=$o(DHCDocARCOSList($j,Type,ARCOSRowidSort),-1) Q:ARCOSRowidSort=""
				do childrenJson.%Push($g(DHCDocARCOSList($j,Type,ARCOSRowidSort)),"")
			}
		}else{
			s ARCOSRowidSort=0
			for {
				s ARCOSRowidSort=$o(DHCDocARCOSList($j,Type,ARCOSRowidSort)) Q:ARCOSRowidSort=""
				do childrenJson.%Push($g(DHCDocARCOSList($j,Type,ARCOSRowidSort)),"")
			}
		}
		do OneJson.%Set("children",childrenJson)
		do JsonObj.%Push(OneJson,"")
	}
	s obj=##class(%Stream.GlobalCharacter).%New()
	do JsonObj.%ToJSON(obj)
	s JsonStr=""
	While 'obj.AtEnd { 
		s JsonStr=JsonStr_obj.ReadLine(,.sc,.eol)
	}
	Q JsonStr
SetDataJson
	s ARCOSName=ARCOSDesc
	s:ActiveFlag=0 ARCOSName=ARCOSName_##class(websys.Translation).Get("udhcfavitem.edit.hui.csp","(已失效)")
	s OneJson={}
	do OneJson.%Set("Index",ARCOSRowid)
	do OneJson.%Set("Type","")
	do OneJson.%Set("Name",ARCOSName)
	do OneJson.%Set("ARCOSRowid",ARCOSRowid)
	do OneJson.%Set("ARCOSCode",ARCOSCode)
	do OneJson.%Set("ARCOSDesc",ARCOSDesc)
	do OneJson.%Set("ARCOSOrdCat",ARCOSOrdCat)
	do OneJson.%Set("ARCOSOrdSubCat",ARCOSOrdSubCat)
	do OneJson.%Set("ARCOSEffDateFrom",ARCOSEffDateFrom)
	do OneJson.%Set("ARCOSOrdCatDR",ARCOSOrdCatDR)
	do OneJson.%Set("ARCOSOrdSubCatDR",ARCOSOrdSubCatDR)
	do OneJson.%Set("FavRowid",FavRowId)
	do OneJson.%Set("ARCOSAlias",$g(ARCOSAlias))
	do OneJson.%Set("FavUserDesc",$g(FavUserDesc))
	do OneJson.%Set("FavDepDesc",$g(FavDepDesc))
	do OneJson.%Set("FavUserDr",FavUserDr)
	do OneJson.%Set("FavDepDr",FavDepDr)
	do OneJson.%Set("MedUnit","")
	do OneJson.%Set("MedUnitDesc","")
	do OneJson.%Set("OrdSetPrice",##class(websys.Translation).Get("udhcfavitem.edit.hui.csp","包装价格"))
	do OneJson.%Set("PrescTypeCode",PrescTypeCode)
	do OneJson.%Set("DuratId",DuratId)
	do OneJson.%Set("FreqId",FreqId)
	do OneJson.%Set("InstrId",InstrId)
	do OneJson.%Set("DosageId",DosageId)
	do OneJson.%Set("Notes",Notes)
	do OneJson.%Set("CelerType",FavCelerType)
	do OneJson.%Set("ARCOSAddUser",$g(ARCOSAddUser))
	do OneJson.%Set("ARCOSAddDate",ARCOSAddDate)
	do OneJson.%Set("FavDateFrom",FavDateFrom)
	do OneJson.%Set("FavDateTo",FavDateTo)
	do OneJson.%Set("ActiveFlag",ActiveFlag)
	Q OneJson
}

/// Creater:宋春莉
/// Description：删除多条医嘱套
/// Table： ARC_OrdSets
/// w ##class(web.DHCUserFavItems).DeleteUserARCOSMulti
ClassMethod DeleteUserARCOSMulti(FavRowidStr) As %String
{
	Q:FavRowidStr="" 0
	s Rtn=0
	Ts
	for Counter=1:1:$l(FavRowidStr,"^") {
		s FavRowid=$p(FavRowidStr,"^",Counter)
		if (FavRowid="") continue
		s Rtn=..DeleteUserARCOS(FavRowid)
		Q:Rtn<0
	}
	if (Rtn<0) {
		Trollback
		Q Rtn
	}
	TC
	Q Rtn
}

/// Creater:宋春莉
/// Description：根据医嘱套权限ID获取医嘱套数据,供医嘱套treegrid追加/更新行数据
/// Table： ARC_OrdSets
/// w ##class(web.DHCUserFavItems).GetARCOSDataByFavRowid(138)
ClassMethod GetARCOSDataByFavRowid(FavRowId As %String) As %String
{
	s data=[],dataobj={}
	Set langid=..%LanguageID()
	s FavUseHospDr=$p(^DHCFavItems(FavRowId),"^",11)
	s ARCOSEffDateTo=$p(^DHCFavItems(FavRowId),"^",16)
	s FavUserDr=$p(^DHCFavItems(FavRowId),"^",2)
	s FavDepDr=$p(^DHCFavItems(FavRowId),"^",4)
	s FavHospDr=$p(^DHCFavItems(FavRowId),"^",9)
	s FavCelerType=$p(^DHCFavItems(FavRowId),"^",10)
	s FavMedUnitDr=$p(^DHCFavItems(FavRowId),"^",8)
	s ARCOSRowid=$p(^DHCFavItems(FavRowId),"^",3)
	s FavDateFrom=$p(^DHCFavItems(FavRowId),"^",12)
	s FavDateTo=$p(^DHCFavItems(FavRowId),"^",13)
	s ActiveFlag=1
	i (FavDateTo'="")&&(FavDateTo<+$h) s ActiveFlag=0
	s:FavDateFrom'="" FavDateFrom=..%ZD(FavDateFrom)
	s:FavDateTo'="" FavDateTo=..%ZD(FavDateTo)
	s ARCOSRowid=$p(^DHCFavItems(FavRowId),"^",3)
	s ARCOSCode=$p(^ARCOS(ARCOSRowid),"^",1)
	s ARCOSDesc=$p(^ARCOS(ARCOSRowid),"^",2)
	s ARCOSOrdCatDR=$p(^ARCOS(ARCOSRowid),"^",8)
	s ARCOSOrdCat=$p(^OEC("ORCAT",ARCOSOrdCatDR),"^",2)
	Set ARCOSOrdCat= ##class(User.OECOrderCategory).GetTranByDesc("ORCATDesc",ARCOSOrdCat,langid)
	s ARCOSOrdSubCatDR=$p(^ARCOS(ARCOSRowid),"^",9)
	s ARCOSOrdSubCat=$p(^ARC("IC",ARCOSOrdSubCatDR),"^",2)
	Set ARCOSOrdSubCat= ##class(User.ARCItemCat).GetTranByDesc("ARCICDesc",ARCOSOrdSubCat,langid)
	s ARCOSAliasRowid=$O(^ARC("ALIAS",0,"ARCOS",ARCOSRowid,0))
	if ARCOSAliasRowid'="" {
		s ARCOSAlias=$P(^ARC("ALIAS",ARCOSAliasRowid),"^",6)
	}else{
		s ARCOSAlias=""
	}
	s ARCOSAddUserDr=$p(^ARCOS(ARCOSRowid),"^",29)
	if ARCOSAddUserDr'="" s ARCOSAddUser=$p($g(^SSU("SSUSR",ARCOSAddUserDr)),"^",2)
	s ARCOSAddUser =##class(User.SSUser).GetTranByDesc("SSUSRName",ARCOSAddUser,langid)
	s ARCOSAddDate=$p(^ARCOS(ARCOSRowid),"^",30)
	s ARCOSAddTime=$p(^ARCOS(ARCOSRowid),"^",31)
	i ARCOSAddTime'=""  s ARCOSAddTime=..%ZT(ARCOSAddTime,1)
	i ARCOSAddDate'="" s ARCOSAddDate=..%ZD(ARCOSAddDate)_" "_ARCOSAddTime
	s ARCOSEffDateFrom=$p(^ARCOS(ARCOSRowid),"^",15)
	s PrescTypeCode=$p(^ARCOS(ARCOSRowid),"^",26)
	s DuratId=$p(^ARCOS(ARCOSRowid),"^",20)
	s FreqId=$p(^ARCOS(ARCOSRowid),"^",21)
	s InstrId=$p(^ARCOS(ARCOSRowid),"^",27)
	s DosageId=$p(^ARCOS(ARCOSRowid),"^",28)
	s Notes=$p(^ARCOS(ARCOSRowid),"^",25)
	s FavUserDesc="",FavDepDesc=""
	s:FavUserDr'="" FavUserDesc=$p(^SSU("SSUSR",FavUserDr),"^",2)
	s FavUserDesc =##class(User.SSUser).GetTranByDesc("SSUSRName",FavUserDesc,langid)
	s:FavDepDr'="" FavDepDesc=$p(^CTLOC(FavDepDr),"^",2)
	s FavDepDesc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",FavDepDesc,langid)
	s ARCOSName=ARCOSDesc
	s:ActiveFlag=0 ARCOSName=ARCOSName_##class(websys.Translation).Get("udhcfavitem.edit.hui.csp","(已失效)")

	do dataobj.%Set("Index",ARCOSRowid)
	do dataobj.%Set("Type",..GetARCOSType(ARCOSRowid))
	do dataobj.%Set("Name",ARCOSName)
	do dataobj.%Set("ARCOSRowid",ARCOSRowid)
	do dataobj.%Set("ARCOSCode",ARCOSCode)
	do dataobj.%Set("ARCOSDesc",ARCOSDesc)
	do dataobj.%Set("ARCOSOrdCat",ARCOSOrdCat)
	do dataobj.%Set("ARCOSOrdSubCat",ARCOSOrdSubCat)
	do dataobj.%Set("ARCOSEffDateFrom",ARCOSEffDateFrom)
	do dataobj.%Set("ARCOSOrdCatDR",ARCOSOrdCatDR)
	do dataobj.%Set("ARCOSOrdSubCatDR",ARCOSOrdSubCatDR)
	do dataobj.%Set("FavRowid",FavRowId)
	do dataobj.%Set("ARCOSAlias",$g(ARCOSAlias))
	do dataobj.%Set("FavUserDesc",$g(FavUserDesc))
	do dataobj.%Set("FavDepDesc",$g(FavDepDesc))
	do dataobj.%Set("FavUserDr",FavUserDr)
	do dataobj.%Set("FavDepDr",FavDepDr)
	do dataobj.%Set("MedUnit","")
	do dataobj.%Set("MedUnitDesc","")
	do dataobj.%Set("OrdSetPrice","包装价格")
	do dataobj.%Set("PrescTypeCode",PrescTypeCode)
	do dataobj.%Set("DuratId",DuratId)
	do dataobj.%Set("FreqId",FreqId)
	do dataobj.%Set("InstrId",InstrId)
	do dataobj.%Set("DosageId",DosageId)
	do dataobj.%Set("Notes",Notes)
	do dataobj.%Set("CelerType",FavCelerType)
	do dataobj.%Set("ARCOSAddUser",$g(ARCOSAddUser))
	do dataobj.%Set("ARCOSAddDate",ARCOSAddDate)
	do dataobj.%Set("FavDateFrom",FavDateFrom)
	do dataobj.%Set("FavDateTo",FavDateTo)
	do dataobj.%Set("ActiveFlag",ActiveFlag)
	do data.%Push(dataobj,"")
	s obj=##class(%Stream.GlobalCharacter).%New()
	do data.%ToJSON(obj)
	s JsonStr=""
	While 'obj.AtEnd { 
		s JsonStr=JsonStr_obj.ReadLine(,.sc,.eol)
	}
	Q JsonStr
}

/// 判断医嘱套是否为全院医嘱套
ClassMethod GetARCOSType(ARCOSRowid)
{
	s Type=""
	s FavRowId=$O(^DHCFavItems(0,"ItemRowid",ARCOSRowid,0))
	q:FavRowId="" ""
	s FavUserDr=$p(^DHCFavItems(FavRowId),"^",2)
	s FavDepDr=$p(^DHCFavItems(FavRowId),"^",4)
	s FavHospDr=$p(^DHCFavItems(FavRowId),"^",9)
	if (FavUserDr'="") {
			s Type="User"
		}elseif(FavDepDr'=""){
			s Type="Loc"
		}else{
			s Type="Hosp"
		}
	q Type
}

}
