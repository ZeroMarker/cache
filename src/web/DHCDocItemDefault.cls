Class web.DHCDocItemDefault Extends DHCDoc.Util.RegisteredObject [ ProcedureBlock ]
{

ClassMethod FindClose(qHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindFetch ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetLocDesc(LocRowId As %String) As %String
{
	q $p($g(^CTLOC(LocRowId)),"^",2)
}

/// d ##class(%ResultSet).RunQuery("web.DHCDocItemDefault","Find",18881,"","","","","","","","","","","","",191)
ClassMethod FindExecute(ByRef qHandle As %Library.Binary, UserID, ItemDescRowid, ItemContralTypeID, ItemDose, ItemDoseUomRowid, ItemInstrRowid, ItemPHFreqRowid, ItemDuratRowid, ItemPackQty, ItemSkinTest, ItemSkinActionRowid, ItemRelevanceNo, PAAdmType, LogonLocDr As %String = "") As %Library.Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	Set langid=..%LanguageID()
	i LogonLocDr'="" s LogonLocHospDr=$p(^CTLOC(LogonLocDr),"^",22)
	s LogonLocHospDr=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId($g(LogonLocHospDr))
	if (ItemDescRowid'=""){
		s ItemDesc=$p($g(^ARCIM(+ItemDescRowid,$P(ItemDescRowid,"||",2),1)),"^",2)
		s ItemDesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",ItemDesc,langid)
	}
	if UserID'="" {
		s Rowid=0
		for {
			s Rowid=$O(^DHCDID(0,"Contral","User",UserID,Rowid))
			q:Rowid=""
			//s Rowid=$O(^DHCDID(0,"LastUser",UserID,Rowid)) q:Rowid=""
			s Data=$g(^DHCDID(Rowid))
			d GetDate
		}
	}
	if LogonLocDr'="" {
		s Rowid=0
		for {
			s Rowid=$O(^DHCDID(0,"Contral","Location",LogonLocDr,Rowid))
			q:Rowid=""
			s Data=$g(^DHCDID(Rowid))
			d GetDate
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
GetDate
	s DIDUserHospDR=$p(Data,"^",31)
	Q:DIDUserHospDR'=LogonLocHospDr
	s ARCIMDR=$p(Data,"^",1)
	if ARCIMDR="" q
	s ArcimDesc=$p($g(^ARCIM(+ARCIMDR,$P(ARCIMDR,"||",2),1)),"^",2)
	s ArcimDesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",ArcimDesc,langid)
	q:(($g(ItemDesc)'="")&&(ArcimDesc'[ItemDesc))
	s DataPAAdmType=$p($g(Data),"^",23)
	q:(PAAdmType'="")&&(PAAdmType'=DataPAAdmType)
	s ContralTypeCode=$p(Data,"^",2)
	s ContralKey=$p(Data,"^",3)
	s ContralType="",ContralDesc=""
	if ContralTypeCode="User" {
		s ContralType="用户"
		s ContralDesc=$p($g(^SSU("SSUSR",+ContralKey)),"^",2)
		s ContralDesc =##class(User.SSUser).GetTranByDesc("SSUSRName",ContralDesc,langid)
	}
	if ContralTypeCode="Location" {
		s ContralType="科室"
		s ContralDesc=$p($g(^CTLOC(+ContralKey)),"^",2)
		s ContralDesc=##class(User.CTSex).GetTranByDesc("CTSEXDesc",ContralDesc,langid)
		s ContralDesc=##class(web.DHCOPAdmReg).LocDescFormate(ContralDesc)
	}
	s ContralType=##class(websys.Translation).Get("udhcdocitemdefault.csp",ContralType)
	s ActiveFlag=$p(Data,"^",4)
	s Priority=""
	s PriorityDR=$p(Data,"^",5)
	if PriorityDR'="" s Priority=$p(^OECPR(PriorityDR),"^",2)
	s Priority=##class(User.OECPriority).GetTranByDesc("OECPRDesc",Priority,langid)
	s Dose=$p(Data,"^",6)
	s DoseUom=""
	s DoseUomDR=$p(Data,"^",7)
	if DoseUomDR'="" s DoseUom=$P(^CT("UOM",DoseUomDR),"^",2)
	s DoseUom=##class(User.CTUOM).GetTranByDesc("CTUOMDesc",DoseUom,langid)
	s Instr=""
	s InstrDR=$p(Data,"^",8)
	if InstrDR'="" s Instr=$p($g(^PHCIN(InstrDR)),"^",2)
	s Instr=##class(User.PHCInstruc).GetTranByDesc("PHCINDesc1",Instr,langid)
	s PHFreq=""
	s PHFreqDR=$p(Data,"^",9)
	if PHFreqDR'="" s PHFreq=$p($g(^PHCFR(PHFreqDR)),"^",3)
	s PHFreq=##class(User.PHCFreq).GetTranByDesc("PHCFRDesc1",PHFreq,langid)
	s Durat=""
	s DuratDR=$p(Data,"^",10)
	if DuratDR'="" s Durat=$p($g(^PHCDU(DuratDR)),"^",3)
	s Durat=##class(User.PHCDuration).GetTranByDesc("PHCDUDesc1",Durat,langid)
	s PackQty=$p(Data,"^",11)
	i ((PackQty<1)&&($p(PackQty,".",1)="")&&(PackQty'="")) s PackQty=0_PackQty
	s SkinTest=$p(Data,"^",12)
	s SkinTest=$p(Data,"^",12)
	//if SkinTest="Y" s SkinTest="on"
	//else  s SkinTest=""
	//i SkinTest="" s SkinTest="N"
	s SkinAction=""
	s SkinActionDR=$p(Data,"^",13)
	if SkinActionDR'="" s SkinAction=$p(^OEC("ACT",SkinActionDR),"^",2)
	s SkinAction =##class(User.OECAction).GetTranByDesc("ACTDesc",SkinAction,langid)
	s RelevanceNo=$p(Data,"^",14)
	s UserAdd=""
	s UserAddDR=$p(Data,"^",15)
	if UserAddDR'="" s UserAdd=$p($g(^SSU("SSUSR",UserAddDR)),"^",2)
	s UserAdd =##class(User.SSUser).GetTranByDesc("SSUSRName",UserAdd,langid)
	s DateAdd=$p(Data,"^",16)
	if DateAdd'="" s DateAdd=..%ZD(DateAdd) //$zd(DateAdd,3)
	s TimeAdd=$p(Data,"^",17)
	if TimeAdd'="" s TimeAdd=..%ZT(TimeAdd,1)
	s LastUpdateUser=""
	s LastUpdateUserDR=$p(Data,"^",18)
	if LastUpdateUserDR'="" s LastUpdateUser=$p($g(^SSU("SSUSR",LastUpdateUserDR)),"^",2)
	s LastUpdateUser =##class(User.SSUser).GetTranByDesc("SSUSRName",LastUpdateUser,langid)
	s LastUpdateDate=$p(Data,"^",19)
	if LastUpdateDate'="" s LastUpdateDate=..%ZD(LastUpdateDate) //$zd(LastUpdateDate,3)
	s LastUpdateTime=$p(Data,"^",20)
	if LastUpdateTime'="" s LastUpdateTime=..%ZT(LastUpdateTime,1)
	s Notes=$p(Data,"^",21)
	
	s TPAAdmType=""
	if DataPAAdmType="I" s TPAAdmType="住院"
	if DataPAAdmType="O" s TPAAdmType="门诊"
	if DataPAAdmType="E" s TPAAdmType="急诊"
	s TPAAdmType=##class(websys.Translation).Get("udhcdocitemdefault.csp",TPAAdmType)
	s SpeedFlowRate=$p($g(Data),"^",24)
	s FlowRateUnitDr=$p($g(Data),"^",25)
	s FlowRateUnit=""
	if (FlowRateUnitDr'=""){
		s FlowRateUnit=$P(^OEC("SFR",FlowRateUnitDr),"^",2)
		s FlowRateUnit=##class(User.OECSpeedFlowRate).GetTranByDesc("SFRDesc",FlowRateUnit,langid)
	}
	s ExceedReasonDR=$p($g(Data),"^",26)
	s ExceedReason=""
	i ExceedReasonDR'="" s ExceedReason=$p($g(^DHCDocExceedReason(ExceedReasonDR)),"^",2)
	s ExceedReason =##class(User.DHCDocExceedReason).GetTranByDesc("DHCExceedDesc",ExceedReason,langid)
	s RecLocDr=$p($g(Data),"^",27)
	s RecLoc=""
	i RecLocDr'="" s RecLoc=$p($g(^CTLOC(RecLocDr)),"^",2)
	s RecLoc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",RecLoc,langid)
	s OrderFreqTimeDoseStr=$p($g(Data),"^",28)
	if (OrderFreqTimeDoseStr'="") {
		s Dose=##class(web.DHCARCOrdSets).CalFreqTimeDoseQtyStr(OrderFreqTimeDoseStr)
	}
	s OrderFreqDispTimeStr=$p($g(Data),"^",29)
	i PHFreqDR="" s OrderFreqDispTimeStr=""
	if (OrderFreqDispTimeStr'="") {
		s CalOrderFreqWeekStr=##class(web.DHCOEOrdItem).GetOrderFreqOtherInfo(PHFreqDR,OrderFreqDispTimeStr)
		//##class(web.DHCARCOrdSets).CalFreqWeekStr(OrderFreqWeekStr),PHFreq=PHFreq_"-"_CalOrderFreqWeekStr
		//s OrderFreqWeekStr=##class(web.DHCDocUtil).EvalJSON(OrderFreqWeekStr)
		//08:00:00_$c(2)_2_$c(1)_08:00:00_$c(2)_5
		//"08:00"_$c(2,2)_"29_1"_$c(1)_"16:00"_$c(2,2)_"29_3"
		s PHFreq=PHFreq_"-"_CalOrderFreqWeekStr
		s OrderFreqDispTimeStr=$replace(OrderFreqDispTimeStr,$C(2),"#")
		s OrderFreqDispTimeStr=$replace(OrderFreqDispTimeStr,$C(1),"!")
	}
	;医嘱只允许开一次标志/同频次不同剂量医嘱标志
	s SameFreqDifferentDosesFlag="N"
	s DARCIMRowid=$o(^DHCItmMast("0","ARCIM",ARCIMDR,""))
	if (DARCIMRowid'=""){
		s SameFreqDifferentDosesFlag=$P(^DHCItmMast(DARCIMRowid),"^",22)
	}
	s PackUom=""
	s PackUomDr=$p($g(Data),"^",30)
	if (PackUomDr'="") {
		s PackUom=$P($g(^CT("UOM",PackUomDr)),"^",2)
		s PackUom=##class(User.CTUOM).GetTranByDesc("CTUOMDesc",PackUom,langid)
	}
	do OuputRow1
	q
 	
OuputRow1
	set Data=$lb(Rowid,ARCIMDR,ArcimDesc,ContralTypeCode,ContralType,ContralKey,ContralDesc,ActiveFlag,PriorityDR,Priority,Dose,DoseUomDR,DoseUom,InstrDR,Instr,PHFreqDR,PHFreq,DuratDR,Durat,PackQty,SkinTest,SkinActionDR,SkinAction,RelevanceNo,UserAddDR,UserAdd,DateAdd,TimeAdd,LastUpdateUserDR,LastUpdateUser,LastUpdateDate,LastUpdateTime,Notes,TPAAdmType,SpeedFlowRate,FlowRateUnitDr,FlowRateUnit,ExceedReasonDR,ExceedReason,RecLocDr,RecLoc,OrderFreqTimeDoseStr,OrderFreqDispTimeStr,SameFreqDifferentDosesFlag,PackUom,PackUomDr)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod FindFetch(ByRef qHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindExecute ]
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

Query Find(UserID, ItemDescRowid, ItemContralTypeID, ItemDose, ItemDoseUomRowid, ItemInstrRowid, ItemPHFreqRowid, ItemDuratRowid, ItemPackQty, ItemSkinTest, ItemSkinActionRowid, ItemRelevanceNo, PAAdmType, LogonLocDr As %String = "") As %Library.Query(CONTAINID = 3, ROWSPEC = "Rowid,ARCIMDR,ArcimDesc,ContralTypeCode,ContralType,ContralKey,ContralDesc,ActiveFlag,PriorityDR,Priority,Dose,DoseUomDR,DoseUom,InstrDR,Instr,PHFreqDR,PHFreq,DuratDR,Durat,PackQty,SkinTest,SkinActionDR,SkinAction,RelevanceNo,UserAddDR,UserAdd,DateAdd,TimeAdd,LastUpdateUserDR,LastUpdateUser,LastUpdateDate,LastUpdateTime,Notes,TPAAdmType,SpeedFlowRate,FlowRateUnitDr,FlowRateUnit,ExceedReasonDR,ExceedReason,RecLocDr,RecLoc,OrderFreqTimeDoseStr,OrderFreqDispTimeStr,SameFreqDifferentDosesFlag,PackUom,PackUomDR")
{
}

ClassMethod ReadItemContralTypeBroker(JSFunName As %String = "", ListName As %String = "") As %String
{
	;
	;w ##class(web.DHCDocItemDefault).ReadBankListBroker("","")
	
	s mydes=""
	s myval=""
	s mySelFlag=0
	s myIdx=1
	
	&SQL(DECLARE OtherMenu CURSOR FOR
    SELECT ID,Name INTO :ID,:Name
    From websys.Menu
    WHERE Name like '%System.OEOrder.OrgFav.Save%')
    &SQL(OPEN OtherMenu)
    For  &SQL(FETCH OtherMenu) QUIT:SQLCODE  do
    .q:$g(ID)=""
	.s MenuSecFlag=##class(ext.websys.Menu).GetMenuSecurity($g(ID))
	.;s MenuSecFlag=1
	.q:MenuSecFlag'=1
	.q:Name["SetSaveForSite"
	.s FunDesc="",FunCode=""
	.;i Name["SetSaveForGroup" s FunDesc="保存到安全组常用"
	.i Name["SetSaveForUser"  s FunDesc="保存到用户常用",FunCode="User"
	.i Name["SetSaveForLocation" s FunDesc="保存到科室常用",FunCode="Location"
	.;i Name["SetSaveForHospital" s FunDesc="保存到医院常用"
	.q:FunDesc=""
	.s mydes=FunDesc
	.s myval=FunCode
	.;s myval=myval_"^"_FunCode
	.i myIdx=1 d 
	..;s mySelFlag=1
	.e  d
	..s mySelFlag=0
	.s rtnval=JSFunName_"('"_ListName_"','"_$ZCVT($g(mydes),"O","JS")_"','"_$ZCVT($g(myval),"O","JS")_"','"_$ZCVT($g(myIdx),"O","JS")
	.s rtnval=rtnval_"','"_$ZCVT(mySelFlag,"O","JS")_"');"
	.&javascript<#(rtnval)#>
	.s myIdx=myIdx+1
	
	q 0
}

/// 医嘱类型
ClassMethod ReadItemPriorityBroker(JSFunName As %String = "", ListName As %String = "") As %String
{
	;^OECPR(rowid)
	;w ##class(web.DHCDocItemDefault).ReadItemPriorityBroker("","")
	s myrowid=0
	s mydes=""
	s myval=""
	s mySelFlag=0
	s myIdx=1
	f  s myrowid=$o(^OECPR(myrowid)) q:(myrowid="")  d
	.s priority=$p($g(^OECPR(myrowid)),"^",3)
	.Q:priority=0
	.s mydes=$p(^OECPR(myrowid),"^",2)
	.s myval=myrowid
	.;s myval=myval_"^"_$p(^OECPR(myrowid),"^",1)
	.i myIdx=1 d 
	..;s mySelFlag=1
	.e  d
	..s mySelFlag=0
	.s rtnval=JSFunName_"('"_ListName_"','"_$ZCVT($g(mydes),"O","JS")_"','"_$ZCVT($g(myval),"O","JS")_"','"_$ZCVT($g(myIdx),"O","JS")
	.s rtnval=rtnval_"','"_$ZCVT(mySelFlag,"O","JS")_"');"
	.&javascript<#(rtnval)#>
	.s myIdx=myIdx+1
	q 0
}

/// 剂量单位
ClassMethod ReadItemDoseUomBroker(JSFunName As %String = "", ListName As %String = "") As %String
{
	;^CT("UOM",{CTUOM_RowId})
	;w ##class(web.DHCDocItemDefault).ReadItemDoseUomBroker("","")
	s myRowid=0
	s mydes=""
	s myval=""
	s mySelFlag=0
	s myIdx=1
	f  s myRowid=$o(^CT("UOM",myRowid)) q:(myRowid="")  d
	.s mydes=$p(^CT("UOM",myRowid),"^",2)
	.s myval=myRowid
	.;s myval=myval_"^"_$p(^CT("UOM",myRowid),"^",1)
	.i myIdx=1 d 
	..;s mySelFlag=1
	.e  d
	..s mySelFlag=0
	.s rtnval=JSFunName_"('"_ListName_"','"_$ZCVT($g(mydes),"O","JS")_"','"_$ZCVT($g(myval),"O","JS")_"','"_$ZCVT($g(myIdx),"O","JS")
	.s rtnval=rtnval_"','"_$ZCVT(mySelFlag,"O","JS")_"');"
	.&javascript<#(rtnval)#>
	.s myIdx=myIdx+1
	q 0
}

/// 医嘱用法
ClassMethod ReadItemInstrBroker(JSFunName As %String = "", ListName As %String = "") As %String
{
	;^PHCIN({PHCIN_RowId})
	;w ##class(web.DHCDocItemDefault).ReadItemInstrBroker("","")
	s myRowid=0
	s mydes=""
	s myval=""
	s mySelFlag=0
	s myIdx=1
	f  s myRowid=$o(^PHCIN(myRowid)) q:(myRowid="")  d
	.s mydes=$p(^PHCIN(myRowid),"^",2)
	.s myval=myRowid
	.;s myval=myval_"^"_$p(^PHCIN(myRowid),"^",1)
	.i myIdx=1 d 
	..;s mySelFlag=1
	.e  d
	..s mySelFlag=0
	.s rtnval=JSFunName_"('"_ListName_"','"_$ZCVT($g(mydes),"O","JS")_"','"_$ZCVT($g(myval),"O","JS")_"','"_$ZCVT($g(myIdx),"O","JS")
	.s rtnval=rtnval_"','"_$ZCVT(mySelFlag,"O","JS")_"');"
	.&javascript<#(rtnval)#>
	.s myIdx=myIdx+1
	q 0
}

/// Creator dhcc 
/// CreateDate 2012.1.10
/// Description: 输出dhtmlcombox数据源（医嘱用法）
/// Table DHCDocItemDefault
/// Input desc 
/// Return mydata 医嘱用法
ClassMethod ReadItemInstr(desc As %String) As %String
{
	;^PHCIN({PHCIN_RowId})
	;w ##class(web.DHCDocItemDefault).ReadItemInstrBroker("","")
	s myRowid=0
	s mydes=""
	s myval=""
	s mySelFlag=0
	s myIdx=1
	s ret=""_$C(1)_"-"
	f  s myRowid=$o(^PHCIN(myRowid)) q:(myRowid="")  d
	.s mydes=$p(^PHCIN(myRowid),"^",2)
	.s myval=myRowid
	.s desc=$Replace(mydes,"-","***")
	.s TRData=myRowid_$C(1)_desc  ;_"-"_$p(mydes,"-",1)
	.i ret="" s ret=TRData
	.e  s ret=ret_"^"_TRData
	q ret
}

ClassMethod ReadItemPHFreqBroker(JSFunName As %String = "", ListName As %String = "") As %String
{
	;^PHCFR({PHCFR_RowId})
	;w ##class(web.DHCDocItemDefault).ReadItemPHFreqBroker("","")
	s myRowid=0
	s mydes=""
	s myval=""
	s mySelFlag=0
	s myIdx=1
	f  s myRowid=$o(^PHCFR(myRowid)) q:(myRowid="")  d
	.s mydes=$p(^PHCFR(myRowid),"^",3)
	.s myval=myRowid
	.;s myval=myval_"^"_$p(^PHCFR(myRowid),"^",1)
	.i myIdx=1 d 
	..;s mySelFlag=1
	.e  d
	..s mySelFlag=0
	.s rtnval=JSFunName_"('"_ListName_"','"_$ZCVT($g(mydes),"O","JS")_"','"_$ZCVT($g(myval),"O","JS")_"','"_$ZCVT($g(myIdx),"O","JS")
	.s rtnval=rtnval_"','"_$ZCVT(mySelFlag,"O","JS")_"');"
	.&javascript<#(rtnval)#>
	.s myIdx=myIdx+1
	q 0
}

ClassMethod ReadItemDuratBroker(JSFunName As %String = "", ListName As %String = "") As %String
{
	;^PHCDU({PHCDU_RowId})
	;w ##class(web.DHCDocItemDefault).ReadItemDuratBroker("","")
	s myRowid=0
	s mydes=""
	s myval=""
	s mySelFlag=0
	s myIdx=1
	f  s myRowid=$o(^PHCDU(myRowid)) q:(myRowid="")  d
	.s mydes=$p(^PHCDU(myRowid),"^",3)
	.s myval=myRowid
	.;s myval=myval_"^"_$p(^PHCDU(myRowid),"^",1)
	.i myIdx=1 d 
	..;s mySelFlag=1
	.e  d
	..s mySelFlag=0
	.s rtnval=JSFunName_"('"_ListName_"','"_$ZCVT($g(mydes),"O","JS")_"','"_$ZCVT($g(myval),"O","JS")_"','"_$ZCVT($g(myIdx),"O","JS")
	.s rtnval=rtnval_"','"_$ZCVT(mySelFlag,"O","JS")_"');"
	.&javascript<#(rtnval)#>
	.s myIdx=myIdx+1
	q 0
}

ClassMethod ReadItemDurat(JSFunName As %String = "", ListName As %String = "") As %String
{
	;^PHCDU({PHCDU_RowId})
	;w ##class(web.DHCDocItemDefault).ReadItemDuratBroker("","")
	s myRowid=0
	s mydes=""
	s myval=""
	s mySelFlag=0
	s myIdx=1
	s ret=""_$C(1)_"-"
	f  s myRowid=$o(^PHCDU(myRowid)) q:(myRowid="")  d
	.s mydes=$p(^PHCDU(myRowid),"^",3)
	.s myval=myRowid
	.s TRData=myRowid_$C(1)_mydes_"-"_+(mydes)
	.i ret="" s ret=TRData
	.e  s ret=ret_"^"_TRData	
	
	q ret
}

ClassMethod ReadItemSkinActionBroker(JSFunName As %String = "", ListName As %String = "") As %String
{
	;^OEC("ACT",{ACT_RowId})
	;w ##class(web.DHCDocItemDefault).ReadItemSkinActionBroker("","")
	s myRowid=0
	s mydes=""
	s myval=""
	s mySelFlag=0
	s myIdx=1
	f  s myRowid=$o(^OEC("ACT",myRowid)) q:(myRowid="")  d
	.s mydes=$p(^OEC("ACT",myRowid),"^",2)
	.s myval=myRowid
	.;s myval=myval_"^"_$p(^OEC("ACT",myRowid),"^",1)
	.i myIdx=1 d 
	..;s mySelFlag=1
	.e  d
	..s mySelFlag=0
	.s rtnval=JSFunName_"('"_ListName_"','"_$ZCVT($g(mydes),"O","JS")_"','"_$ZCVT($g(myval),"O","JS")_"','"_$ZCVT($g(myIdx),"O","JS")
	.s rtnval=rtnval_"','"_$ZCVT(mySelFlag,"O","JS")_"');"
	.&javascript<#(rtnval)#>
	.s myIdx=myIdx+1
	q 0
}

ClassMethod Insert(ItemStr, UserID, LogonHospID = "")
{
	//n (ItemStr,UserID)
	s LogonHospID=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(LogonHospID)
	set Rowid="",ret=0
	set ARCIMDR=$p(ItemStr,"^",1)
	set ContralType=$p(ItemStr,"^",2)
	set ContralKey=$p(ItemStr,"^",3)
	set ActiveFlag="Y"
	set PriorityDR=$p(ItemStr,"^",4)
	set Dose=$p(ItemStr,"^",5)
	set DoseUomDR=$p(ItemStr,"^",6)
	set InstrDR=$p(ItemStr,"^",7)
	set PHFreqDR=$p(ItemStr,"^",8)
	set DuratDR=$p(ItemStr,"^",9)
	set PackQty=$p(ItemStr,"^",10)
	set SkinTest=$p(ItemStr,"^",11)
	set SkinAction=$p(ItemStr,"^",12)
	set RelevanceNo=$p(ItemStr,"^",13)
	set UserAddDR=UserID
	set DateAdd=..%SysDate()
	set TimeAdd=..%SysTime()
	set OrderSeqNo=$p(ItemStr,"^",14)
	set Notes=$p(ItemStr,"^",15)
	set PAAdmType=$p(ItemStr,"^",16)
	set ExceedReasonDR=$p(ItemStr,"^",17)
	set OrderSpeedFlowRate = $p(ItemStr,"^",18)
    set OrderFlowRateUnit =$p(ItemStr,"^",19)
    set RecLocDr=$p(ItemStr,"^",20)
    set OrderFreqTimeDoseStr=$P($p(ItemStr,"^",21),"@")
    set OrderFreqWeekStr=$p(ItemStr,"^",22)
    set PackUomDR=$p(ItemStr,"^",23)
	q:ARCIMDR="" "-100"
	
	s SameFlag=##Class(web.DHCDocItemDefault).CheckSameData($P(ItemStr,"^",1,16)_"^"_$P(ItemStr,"^",18,$L(ItemStr,"^")),UserID,"",LogonHospID)
	if (SameFlag=1) quit "-101"
	
	set Obj=##class(User.DHCDocItemDefault).%New()
	if $ISOBJECT(Obj) {
		if ARCIMDR'="" do Obj.DIDARCIMDRSetObjectId(ARCIMDR)
		set Obj.DIDContralType=ContralType
		set Obj.DIDContralKey=ContralKey
		set Obj.DIDActiveFlag=ActiveFlag
		if PriorityDR'="" do Obj.DIDPriorityDRSetObjectId(PriorityDR)
		set Obj.DIDDose=Dose
		if DoseUomDR'="" do Obj.DIDDoseUomDRSetObjectId(DoseUomDR)
		if InstrDR'="" do Obj.DIDInstrDRSetObjectId(InstrDR)
		if PHFreqDR'="" do Obj.DIDPHFreqDRSetObjectId(PHFreqDR)
		if DuratDR'="" do Obj.DIDDuratDRSetObjectId(DuratDR)
		set Obj.DIDPackQty=PackQty
		if PackUomDR'="" do Obj.DIDPackUomDRSetObjectId(PackUomDR)
		set Obj.DIDSkinTest=SkinTest
		if SkinAction'="" do Obj.DIDSkinActionSetObjectId(SkinAction)
		set Obj.DIDRelevanceNo=RelevanceNo
		do Obj.DIDUserAddDRSetObjectId(UserAddDR)
		set Obj.DIDDateAdd=DateAdd
		set Obj.DIDTimeAdd=TimeAdd
		do Obj.DIDLastUpdateUserSetObjectId(UserAddDR)
		set Obj.DIDLastUpdateDate=DateAdd
		set Obj.DIDLastUpdateTime=TimeAdd
		set Obj.DIDNotes=Notes
		set Obj.DIDAdmType=PAAdmType
		set Obj.DIDSpeedFlowRate=OrderSpeedFlowRate
		do Obj.DIDExceedReasonDRSetObjectId(ExceedReasonDR)
		if OrderFlowRateUnit'="" do Obj.DIDFlowRateUnitSetObjectId(OrderFlowRateUnit)
		if RecLocDr'="" do Obj.DIDRecLocDrSetObjectId(RecLocDr)
		set Obj.DIDOrderFreqTimeDoseStr=OrderFreqTimeDoseStr
		set Obj.DIDOrderFreqWeekStr=OrderFreqWeekStr
		do Obj.DIDUserHospDRSetObjectId(LogonHospID)
		set sc=Obj.%Save()
		if $$$ISERR(sc) {
			s Rowid=""
			s ret="-102"
			QUIT
		}
		do Obj.%Close()
		set Rowid=Obj.%Id()
	}
	
	QUIT ret_"^"_Rowid
}

ClassMethod Update(ItemStr, UserID, Rowid)
{
	//n (ItemStr,UserID,Rowid)
	s ret=0
	q:Rowid="" "-100"
	set ARCIMDR=$p(ItemStr,"^",1)
	set ContralType=$p(ItemStr,"^",2)
	set ContralKey=$p(ItemStr,"^",3)
	set ActiveFlag="Y"
	set PriorityDR=$p(ItemStr,"^",4)
	set Dose=$p(ItemStr,"^",5)
	set DoseUomDR=$p(ItemStr,"^",6)
	set InstrDR=$p(ItemStr,"^",7)
	set PHFreqDR=$p(ItemStr,"^",8)
	set DuratDR=$p(ItemStr,"^",9)
	set PackQty=$p(ItemStr,"^",10)
	set SkinTest=$p(ItemStr,"^",11)
	set SkinAction=$p(ItemStr,"^",12)
	set RelevanceNo=$p(ItemStr,"^",13)
	set UserAddDR=UserID
	set DateAdd=..%SysDate()
	set TimeAdd=..%SysTime()
	set OrderSeqNo=$p(ItemStr,"^",14)
	set Notes=$p(ItemStr,"^",15)
	set PAAdmType=$p(ItemStr,"^",16)
	set ExceedReasonDR=$p(ItemStr,"^",17)
	set OrderSpeedFlowRate = $p(ItemStr,"^",18)
    set OrderFlowRateUnit =$p(ItemStr,"^",19)
    set RecLocDr =$p(ItemStr,"^",20)
    set OrderFreqTimeDoseStr=$p(ItemStr,"^",21)
    set OrderFreqWeekStr=$p(ItemStr,"^",22)
    //08:00:00_$c(2)_2_$c(1)_08:00:00_$c(2)_5
	s OrderFreqWeekStr=$replace(OrderFreqWeekStr,"#",$C(2))
	s OrderFreqWeekStr=$replace(OrderFreqWeekStr,"!",$C(1))
	s PackUomDR=$p(ItemStr,"^",23)
	s ItemUserHospDr=$p($g(^DHCDID(Rowid)),"^",31)
    ;判断重复
	s SameFlag=##Class(web.DHCDocItemDefault).CheckSameData($P(ItemStr,"^",1,16)_"^"_$P(ItemStr,"^",18,$L(ItemStr,"^")),UserID,Rowid,ItemUserHospDr)
	if (SameFlag=1) quit "-101"
	set Obj=##class(User.DHCDocItemDefault).%OpenId(Rowid)
	if $ISOBJECT(Obj) {
		if ARCIMDR'="" do Obj.DIDARCIMDRSetObjectId(ARCIMDR)
		set Obj.DIDContralType=ContralType
		set Obj.DIDContralKey=ContralKey
		set Obj.DIDActiveFlag=ActiveFlag
		do Obj.DIDPriorityDRSetObjectId(PriorityDR) //if PriorityDR'="" 
		set Obj.DIDDose=Dose
		do Obj.DIDDoseUomDRSetObjectId(DoseUomDR)
		do Obj.DIDInstrDRSetObjectId(InstrDR)
		do Obj.DIDPHFreqDRSetObjectId(PHFreqDR)
		do Obj.DIDDuratDRSetObjectId(DuratDR)
		set Obj.DIDPackQty=PackQty
		do Obj.DIDPackUomDRSetObjectId(PackUomDR)
		set Obj.DIDSkinTest=SkinTest
		do Obj.DIDSkinActionSetObjectId(SkinAction)
		set Obj.DIDRelevanceNo=RelevanceNo
		//do Obj.DIDUserAddDRSetObjectId(UserAddDR)
		//set Obj.DIDDateAdd=DateAdd
		//set Obj.DIDTimeAdd=TimeAdd
		do Obj.DIDLastUpdateUserSetObjectId(UserAddDR)
		set Obj.DIDLastUpdateDate=DateAdd
		set Obj.DIDLastUpdateTime=TimeAdd
		set Obj.DIDNotes=Notes
	    set Obj.DIDAdmType=PAAdmType
	    set Obj.DIDSpeedFlowRate=OrderSpeedFlowRate
	    do Obj.DIDExceedReasonDRSetObjectId(ExceedReasonDR)
		do Obj.DIDFlowRateUnitSetObjectId(OrderFlowRateUnit) //if OrderFlowRateUnit'="" 
		do Obj.DIDRecLocDrSetObjectId(RecLocDr)
		set Obj.DIDOrderFreqTimeDoseStr=OrderFreqTimeDoseStr
		set Obj.DIDOrderFreqWeekStr=OrderFreqWeekStr
		set sc=Obj.%Save()
		if $$$ISERR(sc) {
			s ret="-102"
			QUIT ret
		}
		do Obj.%Close()
	}
	
	QUIT ret
}

ClassMethod Delete(Rowid)
{
	q:Rowid="" "-100"
	&sql(Delete from SQLUser.DHC_Doc_ItemDefault where DID_Rowid=:Rowid)
	q SQLCODE
}

/// Creator:      李相宗
/// CreatDate:    2011.11.24
/// Description:: 如果只有一条自定义,则返回RowId
/// Input:        Icode医嘱code UserId用户ID
/// Return:       ItemStr  医嘱常用信息
/// Other:		  绑定组件：DHCDoc.ItemDefault.Order
/// d ##class(web.DHCDocItemDefault).GetUserItemDefaultSingle("681||1","10209","I","",95) 
ClassMethod GetUserItemDefaultSingle(Icode As %String, UserID As %String, PAAdmType As %String, OrderPriorRowid As %String = "", LogonLocDr As %String = "", LognHospID As %String = "") As %String
{
	s ret=""
	s ret1=""
	s LognHospID=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(LognHospID)
	if (PAAdmType="") q ret1
	if (OrderPriorRowid'=""){
		s DefPriorCode=$p($g(^OECPR(OrderPriorRowid)),"^",1)
		if (DefPriorCode="ONE")||(DefPriorCode="OM")||(DefPriorCode="OMLSZT") s OrderPriorRowid=$O(^OECPR(0,"Code","NORM",0))
		if (DefPriorCode="OMST")||(DefPriorCode="OMCQZT") s OrderPriorRowid=$O(^OECPR(0,"Code","S",0))
	}
	
	if UserID'="" {
		s Rowid=0
		for {
			s Rowid=$O(^DHCDID(0,"Contral","User",UserID,Rowid))
			q:Rowid=""
			s Data=$g(^DHCDID(Rowid))
			s DIDUserHospDR=$p(Data,"^",31)
			continue:DIDUserHospDR'=LognHospID
			s DataAdmType=$p(Data,"^",23)
			s ARCIMDR=$p(Data,"^",1)
			s PriorityDR=$p(Data,"^",5)
			if (PriorityDR'=""){
				s PriorityCode=$p($g(^OECPR(PriorityDR)),"^",1)
				if (PriorityCode="ONE")||(PriorityCode="OM")||(PriorityCode="OMLSZT") s PriorityDR=$O(^OECPR(0,"Code","NORM",0))
				if (PriorityCode="OMST")||(PriorityCode="OMCQZT") s PriorityDR=$O(^OECPR(0,"Code","S",0))
			}
			if ARCIMDR'=Icode continue
			if ARCIMDR="" continue
			if (DataAdmType'=PAAdmType)&&(DataAdmType'="") continue
			/*if (OrderPriorRowid'="")&&(OrderPriorRowid=PriorityDR){
				if ret="" s ret=Rowid
				else  s ret=ret_"^"_Rowid
			}else{
				if ret1="" s ret1=Rowid
				else  s ret1=ret1_"^"_Rowid
			}*/
			if (OrderPriorRowid'="")&&(PriorityDR'=OrderPriorRowid)&&(PriorityDR'="") continue
			//if ((PriorityDR'="")&&(OrderPriorRowid=PriorityDR))||(PriorityDR=""){
			
				if ret="" s ret=Rowid
				else  s ret=ret_"^"_Rowid
			//}
		}
	}
	if (ret'=""){
		Quit ret
	}
	if (ret1'=""){
		Quit ret1
	}
	if LogonLocDr'="" {
		s Rowid=0
		for {
			s Rowid=$O(^DHCDID(0,"Contral","Location",LogonLocDr,Rowid))
			q:Rowid=""
			s Data=$g(^DHCDID(Rowid))
			s DIDUserHospDR=$p(Data,"^",31)
			continue:DIDUserHospDR'=LognHospID
			s DataAdmType=$p(Data,"^",23)
			s ARCIMDR=$p(Data,"^",1)
			s PriorityDR=$p(Data,"^",5)
			if (PriorityDR'=""){
				s PriorityCode=$p($g(^OECPR(PriorityDR)),"^",1)
				if (PriorityCode="ONE")||(PriorityCode="OM")||(PriorityCode="OMLSZT") s PriorityDR=$O(^OECPR(0,"Code","NORM",0))
				if (PriorityCode="OMST")||(PriorityCode="OMCQZT") s PriorityDR=$O(^OECPR(0,"Code","S",0))
			}
			if ARCIMDR'=Icode continue
			if ARCIMDR="" continue
			if (DataAdmType'=PAAdmType)&&(DataAdmType'="") continue
			/*if (OrderPriorRowid'="")&&(OrderPriorRowid=PriorityDR){
				if ret="" s ret=Rowid
				else  s ret=ret_"^"_Rowid
			}else{
				if ret1="" s ret1=Rowid
				else  s ret1=ret1_"^"_Rowid
			}*/
			if ((PriorityDR'="")&&(OrderPriorRowid=PriorityDR))||(PriorityDR=""){
				if ret="" s ret=Rowid
				else  s ret=ret_"^"_Rowid
			}
		}
	}
	if (ret'=""){
		Quit ret
	}
	Quit ret1
}

/// Creator:      李相宗
/// CreatDate:    2011.11.24
/// Description:: 判断所开医嘱是否在医嘱套常用维护中有重复项
/// Input:        Icode医嘱code UserId用户ID
/// Return:       ItemStr  医嘱常用信息
/// Other:		  绑定组件：DHCDoc.ItemDefault.Order
/// d ##class(%ResultSet).RunQuery("web.DHCDocItemDefault","FindByARCIIM","309||1","10209",95) 
Query FindByARCIIM(OrderRowid As %String, UserID As %String, LogonLocDr As %String = "", LognHospID As %String = "", OrderPriorRowid As %String = "") As %Query(ROWSPEC = "Rowid:%String,ARCIMDR:%String,ArcimDesc:%String,ContralTypeCode:%String,ContralType:%String,ContralKey:%String,ContralDesc:%String,ActiveFlag:%String,PriorityDR:%String,Priority:%String,Dose:%String,DoseUomDR:%String,DoseUom:%String,InstrDR:%String,Instr:%String,PHFreqDR:%String,PHFreq:%String,DuratDR:%String,Durat:%String,PackQty:%String,SkinTest:%String,SkinActionDR:%String,SkinAction:%String,RelevanceNo:%String,UserAddDR:%String,UserAdd:%String,DateAdd:%String,TimeAdd:%String,LastUpdateUserDR:%String,LastUpdateUser:%String,LastUpdateDate:%String,LastUpdateTime:%String,Notes:%String,PackUom:%String")
{
}

ClassMethod FindByARCIIMExecute(ByRef qHandle As %Binary, OrderRowid As %String, UserID As %String, LogonLocDr As %String = "", LognHospID As %String = "", OrderPriorRowid As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	Set langid=..%LanguageID()
	s LognHospID=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(LognHospID)
	if UserID'="" {
		s Rowid=0
		for {
			s Rowid=$O(^DHCDID(0,"Contral","User",UserID,Rowid))
			q:Rowid=""
			//s Rowid=$O(^DHCDID(0,"LastUser",UserID,Rowid)) q:Rowid=""
			d GetDate9
		}
	}
	if LogonLocDr'="" {
		s Rowid=0
		for {
			s Rowid=$O(^DHCDID(0,"Contral","Location",LogonLocDr,Rowid))
			q:Rowid=""
			d GetDate9
		}
	}
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
GetDate9
	s OrderPriorContrlConfig=..%GetConfig("OrderPriorContrlConfig")
	s Data=$g(^DHCDID(Rowid))
	s DIDUserHospDR=$p(Data,"^",31)
	q:DIDUserHospDR'=LognHospID
	s ARCIMDR=$p(Data,"^",1)
	if ARCIMDR'=OrderRowid q
	if ARCIMDR="" q
	s ArcimDesc=$p($g(^ARCIM(+ARCIMDR,$P(ARCIMDR,"||",2),1)),"^",2)
	s ArcimDesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",ArcimDesc,langid)
	s ContralTypeCode=$p(Data,"^",2)
	s ContralKey=$p(Data,"^",3)
	s ContralType="",ContralDesc=""
	if ContralTypeCode="User" {
		s ContralType="用户"
		s ContralDesc=$p($g(^SSU("SSUSR",+ContralKey)),"^",2)
		s ContralDesc =##class(User.SSUser).GetTranByDesc("SSUSRName",ContralDesc,langid)
	}
	if ContralTypeCode="Location" {
		s ContralType="科室"
		s ContralDesc=$p($g(^CTLOC(+ContralKey)),"^",2)
		s ContralDesc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",ContralDesc,langid)
	}
	s ContralType=##class(websys.Translation).Get("udhcdocitemdefault.csp",ContralType)
	s ActiveFlag=$p(Data,"^",4)
	s Priority=""
	s PriorityDR=$p(Data,"^",5)
	if PriorityDR'="" s Priority=$p(^OECPR(PriorityDR),"^",2)
	s Priority=##class(User.OECPriority).GetTranByDesc("OECPRDesc",Priority,langid)
	s SplitOrderPriorRowid=""
	if PriorityDR'=""{
		s SplitOrderPriorRowid=$P(##class(web.DHCOEOrdItemView).SplitOrderPriorRowid(PriorityDR),"^",1)
	}
	q:((OrderPriorContrlConfig=1)&&(OrderPriorRowid'="")&&(SplitOrderPriorRowid'="")&&(OrderPriorRowid'=SplitOrderPriorRowid))
	s Dose=$p(Data,"^",6)
	s OrderFreqTimeDoseStr=$p($g(Data),"^",28)
	if (OrderFreqTimeDoseStr'="") {
		s Dose=##class(web.DHCARCOrdSets).CalFreqTimeDoseQtyStr(OrderFreqTimeDoseStr)
	}
	s DoseUom=""
	s DoseUomDR=$p(Data,"^",7)
	if DoseUomDR'="" s DoseUom=$P(^CT("UOM",DoseUomDR),"^",2)
	s DoseUom=##class(User.CTUOM).GetTranByDesc("CTUOMDesc",DoseUom,langid)
	s Instr=""
	s InstrDR=$p(Data,"^",8)
	if InstrDR'="" s Instr=$p(^PHCIN(InstrDR),"^",2)
	s Instr=##class(User.PHCInstruc).GetTranByDesc("PHCINDesc1",Instr,langid)
	s PHFreq=""
	s PHFreqDR=$p(Data,"^",9)
	if PHFreqDR'="" s PHFreq=$p(^PHCFR(PHFreqDR),"^",3)
	s PHFreq=##class(User.PHCFreq).GetTranByDesc("PHCFRDesc1",PHFreq,langid)
	s OrderFreqWeekStr=$p($g(Data),"^",29)
	if (OrderFreqWeekStr'="") {
		//s CalOrderFreqWeekStr=##class(web.DHCARCOrdSets).CalFreqWeekStr(OrderFreqWeekStr),PHFreq=PHFreq_"-"_CalOrderFreqWeekStr
		s CalOrderFreqWeekStr=##class(web.DHCOEOrdItem).GetOrderFreqOtherInfo(PHFreqDR,OrderFreqWeekStr)
		s PHFreq=PHFreq_"-"_CalOrderFreqWeekStr
	}
	s Durat=""
	s DuratDR=$p(Data,"^",10)
	if DuratDR'="" s Durat=$p($g(^PHCDU(DuratDR)),"^",3)
	s Durat=##class(User.PHCDuration).GetTranByDesc("PHCDUDesc1",Durat,langid)
	s PackQty=$p(Data,"^",11)
	s SkinTest=$p(Data,"^",12)
	if SkinTest="Y" s SkinTest="on"
	else  s SkinTest=""
	s SkinAction=""
	s SkinActionDR=$p(Data,"^",13)
	if SkinActionDR'="" s SkinAction=$p(^OEC("ACT",SkinActionDR),"^",2)
	s SkinAction =##class(User.OECAction).GetTranByDesc("ACTDesc",SkinAction,langid)
	s RelevanceNo=$p(Data,"^",14)
	s UserAdd=""
	s UserAddDR=$p(Data,"^",15)
	if UserAddDR'="" s UserAdd=$p($g(^SSU("SSUSR",UserAddDR)),"^",2)
	 s UserAdd =##class(User.SSUser).GetTranByDesc("SSUSRName",UserAdd,langid)
	s DateAdd=$p(Data,"^",16)
	if DateAdd'="" s DateAdd=..%ZD(DateAdd) //$zd(DateAdd,3)
	s TimeAdd=$p(Data,"^",17)
	if TimeAdd'="" s TimeAdd=..%ZT(TimeAdd,1)
	s LastUpdateUser=""
	s LastUpdateUserDR=$p(Data,"^",18)
	if LastUpdateUserDR'="" s LastUpdateUser=$p($g(^SSU("SSUSR",LastUpdateUserDR)),"^",2)
	 s LastUpdateUser =##class(User.SSUser).GetTranByDesc("SSUSRName",LastUpdateUser,langid)
	s LastUpdateDate=$p(Data,"^",19)
	if LastUpdateDate'="" s LastUpdateDate=..%ZD(LastUpdateDate) //$zd(LastUpdateDate,3)
	s LastUpdateTime=$p(Data,"^",20)
	if LastUpdateTime'="" s LastUpdateTime=..%ZT(LastUpdateTime,1)
	s Notes=$p(Data,"^",21)
	s PackUom=""
	s PackUomDr=$p($g(Data),"^",30)
	if (PackUomDr'="") {
		s PackUom=$P($g(^CT("UOM",PackUomDr)),"^",2)
		s PackUom=##class(User.CTUOM).GetTranByDesc("CTUOMDesc",PackUom,langid)
	}
	do OuputRow9
	q
OuputRow9
	set Data=$lb(Rowid,ARCIMDR,ArcimDesc,ContralTypeCode,ContralType,ContralKey,ContralDesc,ActiveFlag,PriorityDR,Priority,Dose,DoseUomDR,DoseUom,InstrDR,Instr,PHFreqDR,PHFreq,DuratDR,Durat,PackQty,SkinTest,SkinActionDR,SkinAction,RelevanceNo,UserAddDR,UserAdd,DateAdd,TimeAdd,LastUpdateUserDR,LastUpdateUser,LastUpdateDate,LastUpdateTime,Notes,PackUom)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod FindByARCIIMFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindByARCIIMExecute ]
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

ClassMethod FindByARCIIMClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindByARCIIMExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:      郭荣勇
/// CreatDate:    2011.11.08
/// Description:: 得到医嘱常用信息
/// Table;        DHC_Doc_ItemDefault
/// Input:        默认变量指针
/// Return:       
/// Others:	      ##class(web.DHCDocItemDefault).GetItemDefault(47)	  
ClassMethod GetItemDefault(Rowid, ByRef DefPriorRowid As %String, ByRef DefPriorDesc As %String, ByRef OrderDoseStr As %String, ByRef FormInstrRowid As %String, ByRef FormInstrDesc As %String, ByRef FormFreqRowid As %String, ByRef FormFreqDesc As %String, ByRef FormFreqFactor As %String, ByRef FormFreqInterval As %String, ByRef FormDurRowid As %String, ByRef FormDurDesc As %String, ByRef FormDurFactor As %String, ByRef ExpStr As %String = "", langid As %String = "")
{
	if langid="" Set langid=..%LanguageID()
	s DIDPriorityDR=$P(^DHCDID(Rowid),"^",5)
	i DIDPriorityDR'="" {
		s DefPriorRowid=DIDPriorityDR
		i DefPriorRowid'="" s DefPriorDesc=$p($g(^OECPR(DefPriorRowid)),"^",2)
	} 
	s DIDDose=$P(^DHCDID(Rowid),"^",6)
	s DIDDoseUomDR=$P(^DHCDID(Rowid),"^",7)
	if DIDDoseUomDR'="" {
		s DIDDoseUomDesc=##class(web.DHCDocOrderCommon).GetUOMDesc(DIDDoseUomDR,langid)
		s RepOrderDoseStr=""
		for i=1:1:$l(OrderDoseStr,$C(2)) {
			s TempOrderDoseStr=$p(OrderDoseStr,$C(2),i)
			s TempOrderDoseUomRowid=$p(TempOrderDoseStr,$C(1),3)
			i (DIDDoseUomDR'="")&&(TempOrderDoseUomRowid=DIDDoseUomDR) {
				s $P(TempOrderDoseStr,$C(1),1)=DIDDose
				s $P(TempOrderDoseStr,$C(1),4)="Y"
			}else{
				s $P(TempOrderDoseStr,$C(1),4)="N"
			}
			i RepOrderDoseStr="" s RepOrderDoseStr=TempOrderDoseStr
			e  s RepOrderDoseStr=RepOrderDoseStr_$C(2)_TempOrderDoseStr
		}
		s OrderDoseStr=RepOrderDoseStr
	}
	s DIDInstrDR=$P(^DHCDID(Rowid),"^",8)
	if DIDInstrDR'="" {
		s FormInstrRowid=DIDInstrDR
		i (FormInstrRowid'=""){
			 s FormInstrDesc=$P($g(^PHCIN(FormInstrRowid)),"^",2)
			 s FormInstrDesc=##class(User.PHCInstruc).GetTranByDesc("PHCINDesc1",FormInstrDesc,langid)
		}
	}
	
	s DIDPHFreqDR=$P(^DHCDID(Rowid),"^",9)
	if DIDPHFreqDR'="" {
		s FormFreqRowid=DIDPHFreqDR
		i FormFreqRowid'="" {
		    s FormFreqDesc=$P($g(^PHCFR(FormFreqRowid)),"^",3)
		    s FormFreqDesc=##class(User.PHCFreq).GetTranByDesc("PHCFRDesc1",FormFreqDesc,langid)
		    s FormFreqFactor=$P($g(^PHCFR(FormFreqRowid)),"^",2)
		    s FormFreqInterval=$P($g(^PHCFR(FormFreqRowid)),"^",5)
	    }
	}
	s DIDDuratDR=$P(^DHCDID(Rowid),"^",10)
	if DIDDuratDR'="" {
		s FormDurRowid=DIDDuratDR
		s LongOrderPriorRowid=$O(^OECPR(0,"Code","S",0))
		s OneDayDurRowid=$o(^PHCDU(0,"Code","1天",""))
		if (DefPriorRowid=LongOrderPriorRowid)&&(DefPriorRowid'="")&&(FormDurRowid'=OneDayDurRowid) {
			s FormDurRowid=OneDayDurRowid
		}
		i FormDurRowid'="" {
		    s FormDurDesc=$P($g(^PHCDU(FormDurRowid)),"^",3)
		    s FormDurDesc=##class(User.PHCDuration).GetTranByDesc("PHCDUDesc1",FormDurDesc,langid)
		    s FormDurFactor=$P($g(^PHCDU(FormDurRowid)),"^",2)
	    }
	}
	s PackQty=$P(^DHCDID(Rowid),"^",11)	;协和处理为计算
	s SkinTest=$P(^DHCDID(Rowid),"^",12)	;协和处理为药房设置
	s SkinAction=$P(^DHCDID(Rowid),"^",13)	;协和处理为药学项扩展设定
	;判断皮试备注是否截止
	if SkinAction'=""  {
		s SkinStr=$g(^OEC("ACT",SkinAction))
		s Dateto=$P(SkinStr,"^",4)
		i (Dateto'=..%SysDate())&&(Dateto'="") s SkinAction=""
		if (SkinAction'="")&&($P(SkinStr,"^",1)="YY") s SkinTest="Y"
	}
	s RelevanceNo=$P(^DHCDID(Rowid),"^",14)
	s Notes=$P(^DHCDID(Rowid),"^",21)
	s OrderSpeedFlowRate=$P(^DHCDID(Rowid),"^",24)
	s OrderFlowRateUnit=$P(^DHCDID(Rowid),"^",25)
	s DIDExceedReasonDR=$P(^DHCDID(Rowid),"^",26)
	if (DIDExceedReasonDR'=""){
		s ExceedStr=$G(^DHCDocExceedReason(DIDExceedReasonDR))
		s ExceedFromDate=$P(ExceedStr,"^",4)
		i (ExceedFromDate'="")&(ExceedFromDate>+$H) s DIDExceedReasonDR=""
		s ExceedEndDate=$P(ExceedStr,"^",5)
 	    i (ExceedEndDate'="")&(ExceedEndDate<+$H) s DIDExceedReasonDR=""
	}
	s DIDLocDr=$P(^DHCDID(Rowid),"^",27)
	s OrderFreqTimeDoseStr=$P(^DHCDID(Rowid),"^",28)
	s OrderFreqWeekStr=$P(^DHCDID(Rowid),"^",29)
	s OrderPackUomRowid=$P(^DHCDID(Rowid),"^",30)
	s ExpStr=PackQty_"^"_SkinTest_"^"_SkinAction_"^"_Notes_"^"_OrderSpeedFlowRate_"^"_OrderFlowRateUnit_"^"_DIDExceedReasonDR_"^"_DIDLocDr_"^"_OrderFreqTimeDoseStr_"^"_OrderFreqWeekStr_"^"_OrderPackUomRowid
	Quit
}

/// lxz---------------------------------------------------------------------医嘱套界面使用
/// Creator lxz 
/// Description: 输出dhtmlcombox数据源（医嘱频次）
/// Table DHCDocItemDefault
/// Input desc 
/// Return mydata 医嘱频次
/// w ##class(web.DHCDocItemDefault).ReadItemFrequence("^Y")
ClassMethod ReadItemFrequenceNew(desc As %String) As %String
{
	;^PHCFR({PHCIN_RowId})
	s CMFlag=$P(desc,"^",2) //取草药标志lxz
	s desc=$P(desc,"^",1)
	s myRowid=0
	s mydes=""
	s myval=""
	s mySelFlag=0
	s myIdx=1
	s ret=""_$C(1)_""
	f  s myRowid=$o(^PHCFR(myRowid)) q:(myRowid="")  d
	.s mydes=$p(^PHCFR(myRowid),"^",3)
	.s mydes2=$p(^PHCFR(myRowid),"^",4)
	.s Code=$p(^PHCFR(myRowid),"^",1)
	.Q:(CMFlag="Y")&&(mydes2'="饮片")  
	.Q:(CMFlag="N")&&(mydes2="饮片") 
	.Q:(CMFlag="Clear")
	.s myval=myRowid
	.s desc=$Replace(mydes,"-","***")
	.s TRData=myRowid_$C(1)_desc_"-"_##class(ext.util.String).ToChineseSpell(desc)
	.i ret="" s ret=TRData
	.e  s ret=ret_"^"_TRData
	q ret
}

/// Creator lxz 
/// Description: 输出dhtmlcombox数据源（医嘱疗程）
/// Table DHCDocItemDefault
/// Input desc 
/// Return mydata 医嘱疗程
/// w ##class(web.DHCDocItemDefault).ReadItemDurationNew("^Y")
ClassMethod ReadItemDurationNew(itmjs As %Library.String = "", desc As %String = "") As %String
{
	 s CMFlag=$P(desc,"^",2) //取草药标志lxz
	 s desc=$P(desc,"^",1)
	 Set rset=##class(%ResultSet).%New("web.DHCDocOrderEntry:LookUpDuration")
	 do rset.Execute(desc)
	 While (rset.Next()) {
		s Desc=rset.GetData(2)
		s value=rset.GetData(1)
		s mydes2=""
		if value'="" s mydes2=$p(^PHCDU(value),"^",4)
		Continue:(CMFlag="Y")&&(mydes2'="饮片")  //lxz
		Continue:(CMFlag="N")&&(mydes2="饮片")  //lxz
		Continue:(CMFlag="Clear")
		s retval=itmjs_"('"_$ZCVT(Desc,"O","JS")_"','"_$ZCVT(value,"O","JS")_"');"
		&javascript<#(retval)#>
	 }
	 d rset.Close()
	 q 0
}

/// Creator dhcc 
/// CreateDate 2012.1.10
/// Description: 输出dhtmlcombox数据源（医嘱用法）
/// Table DHCDocItemDefault
/// Input desc 
/// Return mydata 医嘱用法
/// w ##class(web.DHCDocItemDefault).ReadItemInstrNew("^Y")
ClassMethod ReadItemInstrNew(desc As %String) As %String
{
	;^PHCIN({PHCIN_RowId})
	s CMFlag=$P(desc,"^",2) //取草药标志lxz
	s desc=$P(desc,"^",1)
	s myRowid=0
	s mydes=""
	s myval=""
	s mySelFlag=0
	s myIdx=1
	s ret=""_$C(1)_""
	f  s myRowid=$o(^PHCIN(myRowid)) q:(myRowid="")  d
	.s mydes=$p(^PHCIN(myRowid),"^",2)
	.s mydes2=$p(^PHCIN(myRowid),"^",3)
	.s Code=$p(^PHCIN(myRowid),"^",1)
	.Q:(CMFlag="Y")&&(mydes2'="饮片")  //lxz
	.Q:(CMFlag="N")&&(mydes2="饮片")  //lxz
	.Q:(CMFlag="Clear")
	.s myval=myRowid
	.s desc=$Replace(mydes,"-","***")
	.;s TRData=myRowid_$C(1)_desc_"-"_##class(web.DHCINSUPort).GetCNCODE(desc,4,"") 
	.s TRData=myRowid_$C(1)_desc_"-"_##class(ext.util.String).ToChineseSpell(desc)
	.i ret="" s ret=TRData
	.e  s ret=ret_"^"_TRData
	q ret
}

/// lxz 医嘱套界面中的中草药默认设置
/// desc 
ClassMethod SetCMTypeCheck(UserID As %String, InputValue As %String, Flag As %String) As %String
{
	s Return=0
	if Flag="1" d
	.s ^SetCMTypeCheck(UserID)=InputValue
	if Flag="2" d
	.s Return=$G(^SetCMTypeCheck(UserID))
	q Return
}

/// lxz 取出草药备注
/// w ##class(web.DHCDocItemDefault).PhSpecInstrList("")
ClassMethod PhSpecInstrList(itmjs As %Library.String) As %Status
{
	s PhSpecInstrList=..%GetConfig("CNMedItemPhSpecInstr")
	s Len1=$L(PhSpecInstrList,"^")
	s ret=""_$C(1)_""
	for NO=1:1:Len1{
		s Str=$P(PhSpecInstrList,"^",NO)
		s BZDesc=$P(Str,$C(1),2)
		s BZID=$P(Str,$C(1),1)
		s TRData=BZDesc_$C(1)_BZDesc_"-"_##class(ext.util.String).ToChineseSpell(BZDesc) 
		i ret="" s ret=TRData
		e  s ret=ret_"^"_TRData
	}
	q ret
}

/// Creator dhcc 
/// CreateDate 2013.11.12
/// Description: 输出dhtmlcombox数据源（医嘱附加说明）
/// Table 
/// Input desc 
/// Return mydata 附加说明
ClassMethod GetPriorRemarks(desc As %String) As %String
{
	s CMFlag=$P(desc,"^",2) //取草药标志lxz
	s desc=$P(desc,"^",1)
	Q:(CMFlag="Y")||(CMFlag="Clear") ""_$C(1)_""
	s PRNRemarks="PRN"_$C(1)_"PRN"
	s ONERemarks="ONE"_$C(1)_"取药医嘱"
	s OMRemarks="OM"_$C(1)_"自备药"
	s OUTRemarks="OUT"_$C(1)_"出院带药"
	s OUTRemarks="ZT"_$C(1)_"嘱托"
	s OrderPriorRemarks=$C(1)_"^"_ONERemarks_"^"_OMRemarks_"^"_OUTRemarks
	q OrderPriorRemarks
}

ClassMethod GetLastUpdateInfo(Rowid As %String) As %String
{
	s Data=$g(^DHCDID(Rowid))
	s LastUpdateDate=$p(Data,"^",19)
	if LastUpdateDate'="" s LastUpdateDate=..%ZD(LastUpdateDate) //$zd(LastUpdateDate,3)
	s LastUpdateTime=$p(Data,"^",20)
	if LastUpdateTime'="" s LastUpdateTime=..%ZT(LastUpdateTime,1)
	Q LastUpdateDate_"^"_LastUpdateTime
}

// 通过医嘱项判断常用用法表中的是否存在相同用法

// W ##Class(web.DHCTestzhang).CheckARCSame(ItemStr, UserID)

ClassMethod CheckARCSame(ItemStr, UserID)
{
	S ren=0
	//n (ItemStr,UserID,ren)
	set Rowid="",ret=0
	set ARCIMDR=$p(ItemStr,"^",1)
	set ContralType=$p(ItemStr,"^",2)
	set ContralKey=$p(ItemStr,"^",3)
	set ActiveFlag="Y"
	set PriorityDR=$p(ItemStr,"^",4)
	set Dose=$p(ItemStr,"^",5)
	set DoseUomDR=$p(ItemStr,"^",6)
	set InstrDR=$p(ItemStr,"^",7)
	set PHFreqDR=$p(ItemStr,"^",8)
	set DuratDR=$p(ItemStr,"^",9)
	set PackQty=$p(ItemStr,"^",10)
	set SkinTest=$p(ItemStr,"^",11)
	set SkinAction=$p(ItemStr,"^",12)
	set RelevanceNo=$p(ItemStr,"^",13)
	set OrderSeqNo=$p(ItemStr,"^",14)
	set Notes=$p(ItemStr,"^",15)
	set PAAdmType=$p(ItemStr,"^",16)
	q:ARCIMDR="" "-100"
	;判断是否重复Exist
    s DIDRowid="" f  s DIDRowid=$o(^DHCDID(0,"ARCIM",ARCIMDR,DIDRowid)) q:DIDRowid=""  d
	.s ExistContralType=$p(^DHCDID(DIDRowid),"^",2)
	.q:ExistContralType'=ContralType
	.s ExistContralKey=$p(^DHCDID(DIDRowid),"^",3)
	.q:ExistContralKey'=ContralKey
	.s ExistActiveFlag=$p(^DHCDID(DIDRowid),"^",4) 
	.q:ExistActiveFlag'=ActiveFlag
	.s ExistPriorityDR=$p(^DHCDID(DIDRowid),"^",5)
	.q:ExistPriorityDR'=PriorityDR
	.s ExistDose=$p(^DHCDID(DIDRowid),"^",6)
	.q:ExistDose'=Dose
	.s ExistDoseUomDR=$p(^DHCDID(DIDRowid),"^",7) 
	.q:ExistDoseUomDR'=DoseUomDR
	.s ExistInstrDR=$p(^DHCDID(DIDRowid),"^",8) 
	.q:ExistInstrDR'=InstrDR
	.s ExistDuratDR=$p(^DHCDID(DIDRowid),"^",10)
	.q:ExistDuratDR'=DuratDR
	.s ExistPackQty=$p(^DHCDID(DIDRowid),"^",11)
	.q:ExistPackQty'=PackQty
	.s ExistSkinTest=$p(^DHCDID(DIDRowid),"^",12)
	.q:ExistSkinTest'=SkinTest
	.s ExistSkinAction=$p(^DHCDID(DIDRowid),"^",13)
	.q:ExistSkinAction'=SkinAction
	.s ExistRelevanceNo=$p(^DHCDID(DIDRowid),"^",14)
	.q:ExistRelevanceNo'=RelevanceNo
	.s ExistPHFreqDR=$p(^DHCDID(DIDRowid),"^",9)
	.q:ExistPHFreqDR'=PHFreqDR
	.s ExistPAAdmType=$p(^DHCDID(DIDRowid),"^",23) 
	.q:ExistPAAdmType'=PAAdmType
	.s ren=-100
	Q ren
}

// ,selected:%Boolean

Query FindItemContralType(LocID As %String, value As %String) As %Query(ROWSPEC = "ContralTypeRowId:%String,ContralTypeDesc:%String")
{
}

ClassMethod FindItemContralTypeExecute(ByRef qHandle As %Binary, LocID As %String, value As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCDocItemDefault","FindItemContralType","","",29)
	Set repid=$I(^CacheTemp)
    Set ind=1
    s mydes=""
	s myval=""
	s mySelFlag=0
	s myIdx=1
    &SQL(DECLARE OtherMenu1 CURSOR FOR
	    SELECT ID,Name INTO :ID,:Name
	    From websys.Menu
	    WHERE Name like '%System.OEOrder.OrgFav.Save%')
    &SQL(OPEN OtherMenu1)
    For  &SQL(FETCH OtherMenu1) QUIT:SQLCODE  do
    .q:$g(ID)=""
	.;s MenuSecFlag=$$GetMenuSecFlag()
	.;q:MenuSecFlag'=1
	.q:Name["SetSaveForSite"
	.s FunDesc="",FunCode=""
	.;i Name["SetSaveForGroup" s FunDesc="保存到安全组常用"
	.i Name["SetSaveForUser"  s FunDesc="保存到用户常用",FunCode="User"
	.i Name["SetSaveForLocation" s FunDesc="保存到科室常用",FunCode="Location"
	.;i Name["SetSaveForHospital" s FunDesc="保存到医院常用"
	.q:FunDesc=""
	.s FunDesc=##class(websys.Translation).Get("udhcdocitemdefault.csp",FunDesc)
	.s mydes=FunDesc
	.s myval=FunCode
	.;s myval=myval_"^"_FunCode
	.i myIdx=1 d 
	..;s mySelFlag=1
	.e  d
	..s mySelFlag=0
    .Do OutputRowFindItemContralType
     &SQL(close OtherMenu1)
   
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindItemContralType
	set Data=$lb($g(myval),$g(mydes)) //,$g(mySelFlag)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
GetMenuSecFlag
	s enabled=0
	s myMenuSecurity=$g(Group)
	i myMenuSecurity="" s enabled=0 i 1
	e  i $zbitlen(myMenuSecurity)<Id s enabled=0 i 1
	e  s enabled=$s($zbitget(myMenuSecurity,Id):1,1:0)
	q enabled
}

ClassMethod FindItemContralTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindItemContralTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindItemContralTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindItemContralTypeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		Set AtEnd=1
		Set Row=""
	}
	Else      {				
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

// ,selected:%Boolean

/// ----------------------
Query FindGlobal(GlobalName As %String, DescNum As %String = "2", Type As %String = "", Alias As %String = "", HospID = "") As %Query(ROWSPEC = "RowId:%String,Desc:%String,Code:%String")
{
}

ClassMethod FindGlobalExecute(ByRef qHandle As %Binary, GlobalName As %String, DescNum As %String = "2", Type As %String = "", Alias As %String = "", HospID = "") As %Status [ ProcedureBlock = 0 ]
{
	;d ##class(%ResultSet).RunQuery("web.DHCDocItemDefault","FindGlobal","^OEC("SFR",","2")
	Set repid=$I(^CacheTemp)
    Set ind=1
    s HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
    s Alias=$$ALPHAUP^SSUTIL4(Alias)
  	s myRowid=0
	Set langid=..%LanguageID()
	s myval="",mycode=""
	s mySelFlag=0
	s myIdx=1
	for {
		s QueryName="myRowid=$O("_GlobalName_myRowid_"))"
		s @QueryName
		q:(myRowid="")
		if (GlobalName="^DHCDocExceedReason("){
			continue:"N"=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("DHCDoc_ExceedReason",myRowid,HospID)
			s DatFrom=$p(^DHCDocExceedReason(myRowid),"^",4)
			continue:(DatFrom>+$h)&&(DatFrom'="")
			s DateTo=$p(^DHCDocExceedReason(myRowid),"^",5)
			continue:(DateTo<=..%SysDate())&&(DateTo'="")
		}
		if (GlobalName="^PHCIN("){
			s AdmTypeStr=$p(^PHCIN(myRowid),"^",5)
			continue:(","_AdmTypeStr_",")'[(","_Type_",")&&(AdmTypeStr'="")&&(Type'="")
			s PHCINActiveFlag=$p(^PHCIN(myRowid),"^",4)
			continue:PHCINActiveFlag="N"
			s PHCINDesc2=$p(^PHCIN(myRowid),"^",3)
			s PHCINDesc=$p(^PHCIN(myRowid),"^",2)
			continue:PHCINDesc2="饮片"
			continue:(Alias'="")&&($$ALPHAUP^SSUTIL4(PHCINDesc2)'[Alias)&&($$ALPHAUP^SSUTIL4(PHCINDesc)'[Alias)
		}
		if (GlobalName="^PHCFR("){
			s AdmTypeStr=$p(^PHCFR(myRowid),"^",7)
			continue:(","_AdmTypeStr_",")'[(","_Type_",")&&(AdmTypeStr'="")&&(Type'="")
			s PHCFRActiveFlag=$p(^PHCFR(myRowid),"^",6)
			continue:PHCFRActiveFlag="N"
			s PHCFRDesc2=$P(^PHCFR(myRowid),"^",4)
			continue:(PHCFRDesc2="饮片")||(PHCFRDesc2="UNUSE")
		}
		if (GlobalName["^OEC(""ACT"""){
			s DateFrom=$p($g(^OEC("ACT",myRowid)),"^",3)
			continue:(DateFrom'="")&&(DateFrom>+$h)
			s DateTo=$p($g(^OEC("ACT",myRowid)),"^",4)
			continue:(DateTo'="")&&(DateTo<=..%SysDate())
		}
		if (GlobalName="^PHCDU(") {
			s PHCDUDesc2=$P(^PHCDU(myRowid),"^",4)
			s DateFrom=$P(^PHCDU(myRowid),"^",5)
			continue:(DateFrom'="")&&(DateFrom>+$h)
			s DateTo=$P(^PHCDU(myRowid),"^",6)
			continue:(DateTo'="")&&(DateTo<=..%SysDate())
 			continue:PHCDUDesc2="饮片"
		}
		s mydes=""
		s desc=""
		for i=1:1:$length(DescNum,"^") {
			s Num=$P(DescNum,"^",i)
			s GetValue="desc=$P("_GlobalName_myRowid_"),""^"","_Num_")"
			s @GetValue
			if (mydes=""){
				s mydes=desc
			}else{
				s mydes=mydes_"-"_desc
			}
		}
		///医嘱类型
		if (GlobalName="^OECPR("){
			s mydes=##class(User.OECPriority).GetTranByDesc("OECPRDesc",mydes,langid)
			}
		///用法
		if (GlobalName="^PHCIN("){
			s $P(mydes,"-",1)=##class(User.PHCInstruc).GetTranByDesc("PHCINDesc1",$P(mydes,"-",1),langid)
			}
		///频次
		if (GlobalName="^PHCFR("){
			s mydes=##class(User.PHCFreq).GetTranByDesc("PHCFRDesc1",mydes,langid)
			}
		///疗程
		if (GlobalName="^PHCDU("){
			s mydes=##class(User.PHCDuration).GetTranByDesc("PHCDUDesc1",mydes,langid)
			}
		///皮试备注
		if (GlobalName["^OEC(""ACT"""){
			s mydes =##class(User.OECAction).GetTranByDesc("ACTDesc",mydes,langid)
			}
		///疗程超量原因
		if (GlobalName="^DHCDocExceedReason("){
			s mydes =##class(User.DHCDocExceedReason).GetTranByDesc("DHCExceedDesc",mydes,langid)
			}
		///流速单位
		if (GlobalName["^OEC(""SFR"""){
			s mydes=##class(User.OECSpeedFlowRate).GetTranByDesc("SFRDesc",mydes,langid)
			}
		if (GlobalName="^PHCFR("){
			s mycode=$g(^PHCFR(myRowid))
		}
		
		s myval=myRowid
		//w $g(myval),$g(mydes),!
		d OutputRowFindGlobal
		s myIdx=myIdx+1
	}

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindGlobal
	set Data=$lb($g(myval),$g(mydes),$g(mycode)) //,$g(mySelFlag)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindGlobalClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindGlobalExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindGlobalFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindGlobalExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		Set AtEnd=1
		Set Row=""
	}
	Else      {				
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// /------
/// ----------------------
/// ,selected:%Boolean
Query FindDoseUOM(ARCIMRowid As %String, DescNum As %String = "2", HOSPID As %String = "") As %Query(ROWSPEC = "RowId:%String,Desc:%String")
{
}

ClassMethod FindDoseUOMExecute(ByRef qHandle As %Binary, ARCIMRowid As %String, DescNum As %String = "2", HOSPID As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCDocItemDefault","FindDoseUOM","9925","2")
	Set repid=$I(^CacheTemp)
    Set ind=1
    Set langid=..%LanguageID()
	s mySelFlag=0
    s ARCIMRowid=ARCIMRowid_"||1"


	s OrderPHPrescType=##Class(web.DHCDocOrderCommon).GetPHPrescTypeByItem(ARCIMRowid,HOSPID)

	s DrgFormRowid=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",12)
	s drgform1=+DrgFormRowid,drgform2=$p(DrgFormRowid,"||",2)
	i ((DrgFormRowid="")||(drgform1="")||(drgform2=""))&&(OrderPHPrescType'="4") {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	k UOMArr
	s INCIRowid=##class(web.DHCDocOrderEntry).GetINCI(+ARCIMRowid)
	if (OrderPHPrescType="4"){
		s myval=##Class(web.DHCDocOrderCommon).GetBillUOMRowID(ARCIMRowid,"O")
		s mydes=##Class(web.DHCDocOrderCommon).GetUOMDesc(myval)
		d OutputRowFindDoseUOM
		if (myval'=##Class(web.DHCDocOrderCommon).GetBillUOMRowID(ARCIMRowid,"I")){
			s myval=##Class(web.DHCDocOrderCommon).GetBillUOMRowID(ARCIMRowid,"I")
			s mydes=##Class(web.DHCDocOrderCommon).GetUOMDesc(myval)
			d OutputRowFindDoseUOM
		}
	}elseif (DrgFormRowid'=""){
		s myval=$p(^PHCD(drgform1,"DF",drgform2,2),"^",4)    ;Pharmacy base UOM
		s mydes=$p($g(^CT("UOM",myval)),"^",2)
		d OutputRowFindDoseUOM
		s leq=0
		for {
			s leq=$o(^PHCD(drgform1,"DF",drgform2,"EQ",leq))
			q:leq=""
			s eqrec=^PHCD(drgform1,"DF",drgform2,"EQ",leq)
			s myval=$p(eqrec,"^"),eqqty=$p(eqrec,"^",2)
			s mydes=$p($g(^CT("UOM",myval)),"^",2)
			d OutputRowFindDoseUOM
		}
	}
	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindDoseUOM
	if ($D(UOMArr($g(myval)))){
		q
	}
	s UOMArr($g(myval))=1
	s mydes=##class(User.CTUOM).GetTranByDesc("CTUOMDesc",mydes,langid)
	set Data=$lb($g(myval),$g(mydes)) //,$g(mySelFlag)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindDoseUOMClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindDoseUOMExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindDoseUOMFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindDoseUOMExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		Set AtEnd=1
		Set Row=""
	}
	Else      {				
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query GetPAAdmTypeList() As %Query(ROWSPEC = "RowId:%String,Desc:%String")
{
}

ClassMethod GetPAAdmTypeListExecute(ByRef qHandle As %Binary) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.PALocAmount","GetPAAdmTypeList")
	Set repid=$I(^CacheTemp)
    Set ind=1
    s PAAdmTypeStr="O^E^I"
    For i=1:1:$l(PAAdmTypeStr,"^") d
    .s PAADMType=$p(PAAdmTypeStr,"^",i)
    .i PAADMType="O" s PAAdmTypeDesc="门诊"
    .i PAADMType="E" s PAAdmTypeDesc="急诊"
    .i PAADMType="I" s PAAdmTypeDesc="住院"
	.Do OutputRowGetPAAdmTypeList
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowGetPAAdmTypeList
	s PAAdmTypeDesc=..%Translate("udhcdocitemdefault.csp",PAAdmTypeDesc)
	set Data=$lb($g(PAADMType),$g(PAAdmTypeDesc))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetPAAdmTypeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPAAdmTypeListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetPAAdmTypeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPAAdmTypeListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		Set AtEnd=1
		Set Row=""
	}
	Else      {				
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// /检查是否存在相同的用法数据
/// /w ##Class(web.DHCDocItemDefault).CheckSameData()
ClassMethod CheckSameData(Data As %String, UserID As %String, RowId As %String = "", LogonHospID As %String = "") As %String
{
	//n (Data,UserID,RowId)
	s ^tempqujian("CheckSameData")=$lb(Data , UserID , RowId , LogonHospID)
	s LogonHospID=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(LogonHospID)
	set ARCIMDR=$p(Data,"^",1)
	set ContralType=$p(Data,"^",2)
	set ContralKey=$p(Data,"^",3)
	set ActiveFlag="Y"
	set PriorityDR=$p(Data,"^",4)
	set Dose=$p(Data,"^",5)
	set DoseUomDR=$p(Data,"^",6)
	set InstrDR=$p(Data,"^",7)
	set PHFreqDR=$p(Data,"^",8)
	set DuratDR=$p(Data,"^",9)
	set PackQty=$p(Data,"^",10)
	set SkinTest=$p(Data,"^",11)
	set SkinAction=$p(Data,"^",12)
	set RelevanceNo=$p(Data,"^",13)	
	
	set Notes=$p(Data,"^",15)
	set AdmType=$p(Data,"^",16)
	set OrderSpeedFlowRate = $p(Data,"^",17)
    set OrderFlowRateUnit =$p(Data,"^",18)
    set RecLocDr =$p(Data,"^",19)
	s SameData=0
	s Rowid=0
	for {
		s Rowid=$O(^DHCDID(0,"LastUser",UserID,Rowid)) q:Rowid=""
		continue:(RowId'="")&&(Rowid=RowId)
		s List=$g(^DHCDID(Rowid))
		if Rowid=213 b ;33
		if ($P(List,"^",31)'=LogonHospID) continue
		if ($P(List,"^",1)'=ARCIMDR) continue
		if ($P(List,"^",2)'=ContralType) continue
		if ($P(List,"^",3)'=ContralKey) continue
		if Rowid=213 b ;44
		if ($P(List,"^",5)'=PriorityDR) continue
		if ($P(List,"^",6)'=Dose) continue
		if ($P(List,"^",7)'=DoseUomDR) continue
		if ($P(List,"^",8)'=InstrDR) continue
		if ($P(List,"^",9)'=PHFreqDR) continue
		if ($P(List,"^",10)'=DuratDR) continue
		if ($P(List,"^",11)'=PackQty) continue
		if ($P(List,"^",12)'=SkinTest) continue
		if ($P(List,"^",13)'=SkinAction) continue
		if Rowid=213 b ;55
		//if ($P(List,"^",14)'=RelevanceNo) continue
		if ($P(List,"^",15)'=UserID) continue
		if ($P(List,"^",21)'=Notes) continue
		if ($P(List,"^",23)'=AdmType) continue
		if ($P(List,"^",24)'=OrderSpeedFlowRate) continue
		if ($P(List,"^",25)'=OrderFlowRateUnit) continue
		if Rowid=213 b ;66
		if ($P(List,"^",27)'=RecLocDr) continue
		s SameData=1
		
	}
	q SameData
}

ClassMethod InsertByOrdItems(OrdItemIDStr, UserID, PAAdmType, LogonHospID = "")
{
	;s ^Wqy("InsertByOrdItems")=$LB(OrdItemIDStr,UserID,PAAdmType,LogonHospID)
	d ##class(web.DHCDocInPatPortalCommon).OrdItemIDStrToList(OrdItemIDStr,LogonHospID,.OrdList)
	Q:'$D(OrdList) "医嘱不能为空"
	s SuccessCount=0,FailCount=0
	s ret=""
	s OrdItemID="" for{
		s OrdItemID=$O(OrdList(OrdItemID)) Q:OrdItemID=""
		s Ord=+OrdItemID,Sub=$P(OrdItemID,"||",2)
		d OneOrdItem
		s Sub=0 for{
			s Sub=$O(OrdList(OrdItemID,Sub)) Q:Sub=""
			d OneOrdItem
		}
	}
	Q:'SuccessCount ret
	Q 0
OneOrdItem
	s OrderType=##class(DHCDoc.Order.Common).GetOrdItemType(Ord_"||"_Sub)
	Q:OrderType'="R"
	s ItemStr=""
	s $p(ItemStr,"^",1)=$P(^OEORD(Ord,"I",Sub,1),"^",2)
	s $p(ItemStr,"^",2)="User"
	S $p(ItemStr,"^",3)=UserID
	s $p(ItemStr,"^",4)=$P($G(^OEORD(Ord,"I",Sub,1)),"^",8)
	s $p(ItemStr,"^",5)=$P($G(^OEORD(Ord,"I",Sub,2)),"^",1)
	s $p(ItemStr,"^",6)=$P($G(^OEORD(Ord,"I",Sub,2)),"^",3)
	s $p(ItemStr,"^",7)=$P($G(^OEORD(Ord,"I",Sub,2)),"^",7)
	s $p(ItemStr,"^",8)=$P($G(^OEORD(Ord,"I",Sub,2)),"^",4)
	s $p(ItemStr,"^",9)=$P($G(^OEORD(Ord,"I",Sub,2)),"^",6)
	s $p(ItemStr,"^",10)=$P($G(^OEORD(Ord,"I",Sub,9)),"^",4)
	s $p(ItemStr,"^",11)=$P($G(^OEORD(Ord,"I",Sub,5)),"^",2)
	s $p(ItemStr,"^",12)=$P($G(^OEORD(Ord,"I",Sub,11)),"^",21)
	s $p(ItemStr,"^",13)=""	;OrderMasterSeqNo 用户常用是否不需要?
	s $p(ItemStr,"^",14)=""
	s $p(ItemStr,"^",15)=$g(^OEORD(Ord,"I",Sub,"DEP",1))
	s $p(ItemStr,"^",16)=PAAdmType
	s $p(ItemStr,"^",17)=$P($G(^OEORD(Ord,"I",Sub,"DHC")),"^",33)
	s $p(ItemStr,"^",18)=$P($G(^OEORD(Ord,"I",Sub,3)),"^",17)
	s $p(ItemStr,"^",19)=$P($G(^OEORD(Ord,"I",Sub,6)),"^",8)
	s $p(ItemStr,"^",20)=$P($G(^OEORD(Ord,"I",Sub,3)),"^",6)
	s $p(ItemStr,"^",21)=$P($G(^OEORD(Ord,"I",Sub,"DHC")),"^",59)
	s $p(ItemStr,"^",22)=##class(web.DHCOEOrdItem).GetOrdFrqTimeInfoForEntry(Ord_"||"_Sub)
	s $p(ItemStr,"^",23)=$P($G(^OEORD(Ord,"I",Sub,"DHC")),"^",13)
	s SameFlag=##Class(web.DHCDocItemDefault).CheckSameData($P(ItemStr,"^",1,16)_"^"_$P(ItemStr,"^",18,$L(ItemStr,"^")),UserID,"",LogonHospID)
	if SameFlag=1{
		s ret="相同用法信息已保存"
		Q
	}
	s ret=..Insert(ItemStr, UserID, LogonHospID)
	if $P(ret,"^")=0{
		s SuccessCount=SuccessCount+1
	}else{
		s FailCount=FailCount+1
	}
	Q
}

}
