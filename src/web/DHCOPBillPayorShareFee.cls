Class web.DHCOPBillPayorShareFee Extends %Library.RegisteredObject
{

/// 门诊收费大类
ClassMethod getTarOCCat(HospId) As %String
{
 	set rtn=""
 	set OcId=0
 	for  set OcId=$o(^DHCTarC("TOC",OcId)) quit:(OcId="")  do
 	.set ShowFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_TarOC", OcId, HospId)
	.quit:(ShowFlag="N")
 	.set catdesc=$p($g(^DHCTarC("TOC",OcId)),"^",2)
 	.set rtn=$s((rtn=""):catdesc,1:rtn_"^"_catdesc)
	
	quit rtn
}

/// 会计子类
ClassMethod getTarACsub(HospId) As %String
{
 	set rtn=""
 	set OcId=0
 	for  set OcId=$o(^DHCTarC("AC",OcId)) quit:(OcId="")  do
 	.set ShowFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_TarAcctCate", OcId, HospId)
	.quit:(ShowFlag="N")
 	.set catdesc=$p($g(^DHCTarC("AC",OcId)),"^",2)
 	.set rtn=$s((rtn=""):catdesc,1:rtn_"^"_catdesc)
	
	quit rtn
}

/// 会计大类
ClassMethod getTarACCat(HospId) As %String
{
 	set rtn=""
 	set OcId=0
 	for  set OcId=$o(^DHCTarC("TAC",OcId)) quit:(OcId="")  do
 	.set ShowFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_TarAC", OcId, HospId)
	.quit:(ShowFlag="N")
 	.set catdesc=$p($g(^DHCTarC("TAC",OcId)),"^",2)
 	.set rtn=$s((rtn=""):catdesc,1:rtn_"^"_catdesc)
	
	quit rtn
}

/// do ##class(%ResultSet).RunQuery("web.DHCOPBillPayorShareFee","QueryPatCatFee","2022-12-01","2022-12-21","TOC","","2")
Query QueryPatCatFee(StDate As %String, EndDate As %String, StatFlag As %String, PatTypeStat As %String, HospId As %String, langId As %String = "") As websys.Query(ROWSPEC = "TPatNo:%String,TPatName:%String,TInsTypeDesc:%String,TCAT1:%String,TCAT2:%String,TCAT3:%String,TCAT4:%String,TCAT5:%String,TCAT6:%String,TCAT7:%String, TCAT8:%String,TCAT9:%String,TCAT10:%String,TCAT11:%String,TCAT12:%String,TCAT13:%String,TCAT14:%String,TCAT15:%String,TCAT16:%String,TCAT17:%String,TCAT18:%String,TCAT19:%String,TCAT20:%String,TCAT21:%String,TCAT22:%String,TCAT23:%String,TCAT24:%String,TCAT25:%String,TCAT26:%String,TCAT27:%String,TSum:%String,TTMPJID:%String") [ SqlProc ]
{
}

ClassMethod QueryPatCatFeeExecute(ByRef qHandle As %Binary, StDate As %String, EndDate As %String, StatFlag As %String, PatTypeStat As %String, HospId As %String, langId As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	
	set ^TMP("QueryPatCatFee")=$lb(StDate, EndDate, StatFlag, PatTypeStat, HospId)
	set Pid=$i(^TMPOPPrintOut)
	
	set StDate=##class(websys.Conversions).DateHtmlToLogical(StDate)
	set EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	
	kill ^||TMP($j)
	for date=StDate:1:EndDate do
	.do ..GetCatFeeStat(date, StDate, EndDate, StatFlag, PatTypeStat, HospId)
	
	//统计分类修正
	set CATENUM=27
	set CatId=0
	set i=0
	if (StatFlag="TAC") do
	.for  set CatId=$o(^DHCTarC("TAC",CatId)) quit:(CatId="")  do
	..set CatFeeDr($i(i))=CatId
	else  do
	.for  set CatId=$o(^DHCTarC("TOC",CatId)) quit:(CatId="")  do
	..set CatFeeDr($i(i))=CatId
	
	//初始化
	kill CatFeeHJ, CatFee
	for i=1:1:CATENUM  do
	.set CatFeeHJ(i)=0
	.set CatFee(i)=0
	
	set (SumHJ, PatShareSumHJ, PayorShareSumHJ)=0
	set InsType=0
	for  set InsType=$o(^||TMP($j,InsType)) quit:(InsType="")  do
	.set InsTypeDesc=$p($g(^PAC("ADMREA",InsType)),"^",2)
	.set InsTypeDesc=##class(User.PACAdmReason).GetTranByDesc("READesc", InsTypeDesc, langId)
	.set Papmi=0
	.for  set Papmi=$o(^||TMP($j,InsType,Papmi)) quit:(Papmi="")  do
	..set (Sum, PatShareSum, PayorShareSum)=0
	..set i=""
	..for  set i=$o(CatFeeDr(i)) quit:(i="")  do
	...set CatDr=$g(CatFeeDr(i))
	...set CatFee(i)=+$g(^||TMP($j,InsType,Papmi,"CatFee",CatDr,"Amount"))
	...set Sum=$i(Sum, CatFee(i))
	..set PatNo=$p($g(^PAPER(Papmi,"PAT",1)),"^",2)
	..set PatName=$p($g(^PAPER(Papmi,"ALL")),"^",1)
	..set PatShareSum=+$g(^||TMP($j,InsType,Papmi,"PatShare"))
	..set PayorShareSum=+$g(^||TMP($j,InsType,Papmi,"PayorShare"))  
	..//累加
	..for i=1:1:CATENUM  do
	...set CatFee(i)=$fn($g(CatFee(i)),"",2)
	...set CatFeeHJ(i)=$i(CatFeeHJ(i),CatFee(i))
	..
	..set Sum=$fn(Sum,"",2)
	..set PatShareSum=$fn(PatShareSum,"",2)
	..set PayorShareSum=$fn(PayorShareSum,"",2)
	..set SumHJ=$i(SumHJ,Sum)
	..set PatShareSumHJ=$i(PatShareSumHJ,PatShareSum)
	..set PayorShareSumHJ=$i(PayorShareSumHJ,PayorShareSum)
	..set Data=$lb(PatNo,PatName,InsTypeDesc,CatFee(1),CatFee(2),CatFee(3),CatFee(4),CatFee(5),CatFee(6),CatFee(7),CatFee(8),CatFee(9),CatFee(10),CatFee(11),CatFee(12),CatFee(13),CatFee(14),CatFee(15),CatFee(16),CatFee(17),CatFee(18),CatFee(19),CatFee(20),CatFee(21),CatFee(22),CatFee(23),CatFee(24),CatFee(25),CatFee(26),CatFee(27),Sum,Pid)
	..set ^CacheTemp(repid,ind)=Data
	..set ^TMPOPPrintOut(Pid,ind)=Data
	..set ind=$i(ind)
	
	set (PatName, InsTypeDesc)=""
	if (ind>1) {
		set PatNo=##class(websys.Translation).Get("", "合计")
		set Sum=$fn(SumHJ,"",2)
		set PatShareSum=$fn(PatShareSumHJ,"",2)
		set PayorShareSum=$fn(PayorShareSumHJ,"",2)
		for i=1:1:CATENUM {
			set CatFee(i)=$fn(CatFeeHJ(i),"",2)
		}
		set Data=$lb(PatNo,PatName,InsTypeDesc,CatFee(1),CatFee(2),CatFee(3),CatFee(4),CatFee(5),CatFee(6),CatFee(7),CatFee(8),CatFee(9),CatFee(10),CatFee(11),CatFee(12),CatFee(13),CatFee(14),CatFee(15),CatFee(16),CatFee(17),CatFee(18),CatFee(19),CatFee(20),CatFee(21),CatFee(22),CatFee(23),CatFee(24),CatFee(25),CatFee(26),CatFee(27),Sum,Pid)
		set ^CacheTemp(repid,ind)=Data
		set ind=$i(ind)
	}
	kill ^||TMP($j)
	
	quit $$$OK
}

/// 获取统计的临时Global
/// w ##class(web.UDHCJFOPRepCommon).GetCatFeeStat("",60821,60821,60821,"","")
ClassMethod GetCatFeeStat(pdate, StDate, EndDate, StatFlag, PatTypeStat, HospId)
{
	set PrtRowId=0
	//for  set PrtRowId=$o(^DHCINVPRT(0,"HandDate",pdate,PrtRowId))  quit:(PrtRowId="")  do
	for  set PrtRowId=$o(^DHCINVPRT(0,"Date",pdate,PrtRowId))  quit:(PrtRowId="")  do
	.set PrtData=$g(^DHCINVPRT(PrtRowId))
	.set FairType=$p(PrtData,"^",34)
	.quit:(FairType'="F")
	.set PrtHospDR=$p(PrtData,"^",39)
	.quit:(HospId'=PrtHospDR)
	.set PrtUsr=$p(PrtData,"^",21)	            ;PRT_Usr
	.//set HandinDate=$p(PrtData,"^",11)	    ;PRT_HandinDate
	.//set HandinTime=$p(PrtData,"^",12)	    ;PRT_HandinTime
	.set PrtDate=$p(PrtData,"^",5)	            ;PRT_Date
	.set PrtTime=$p(PrtData,"^",20)	            ;PRT_Time
	.quit:((PrtDate<StDate)||(PrtDate>EndDate))
	.set myInsTypeDR=$p(PrtData,"^",9)	        ;PRT_InsType_DR
	.quit:((PatTypeStat'="")&&(PatTypeStat'=myInsTypeDR))
	.do ..SplitInvCatFee(PrtRowId, StatFlag)
    
	quit
}

/// 按照门诊大类分解发票
ClassMethod SplitInvCatFee(PrtRowId, StatFlag)
{
	set InvPayorShare=+$p($g(^DHCINVPRT(PrtRowId)),"^",18)
	quit:(+InvPayorShare=0)			//只查询记账的费用
	
	set InsTypeDR=$p($g(^DHCINVPRT(PrtRowId)),"^",9)	
	set Papmi=$p($g(^DHCINVPRT(PrtRowId)),"^",15)
	
	//DHC_BillConINV
	set BCIId=0
	for  set BCIId=$o(^DHCBCI(0,"INV",PrtRowId,BCIId)) quit:(BCIId="")  do
	.set PBId=$p($g(^DHCBCI(BCIId)),"^",2)
	.quit:(+PBId=0)
	.set PBOSub=0
	.for  set PBOSub=$o(^DHCPB(PBId,"O",PBOSub)) quit:(PBOSub="")  do
	..set PBDSub=0
	..for  set PBDSub=$o(^DHCPB(PBId,"O",PBOSub,"D",PBDSub)) quit:(PBDSub="")  do
	...set PBDData=$g(^DHCPB(PBId,"O",PBOSub,"D",PBDSub))
	...set TotalAmt=+$p(PBDData,"^",7)	     ;PBD_TotalAmount
	...//set DiscAmt=+$p(PBDData,"^",8)	     ;PBD_DiscAmount
	...set PayorShare=+$p(PBDData,"^",9)	 ;PBD_PayorShare
	...set PatShare=+$p(PBDData,"^",10)	     ;PBD_PatientShare
	...set ItmDr=$p(PBDData,"^",3)	         ;DHC_TarItem
	...if (StatFlag="TAC") do
	....set SubCatDr=$p($g(^DHCTARI(ItmDr)),"^",5)	;->TARI_AcctCate
	...else  do
	....set SubCatDr=$p($g(^DHCTARI(ItmDr)),"^",15)	;->DHC_TarOutpatCate
	...quit:(SubCatDr="")
	...if (StatFlag="TAC") do
	....set CatDr=$p($g(^DHCTarC("AC",SubCatDr)),"^",3)	;DHC_TarAC
	...else  do
	....set CatDr=$p($g(^DHCTarC("OC",SubCatDr)),"^",3)	;DHC_TarOC
	...
	...set ^||TMP($j,InsTypeDR,Papmi,"CatFee",CatDr,"Amount")=$i(^||TMP($j,InsTypeDR,Papmi,"CatFee",CatDr,"Amount"), PayorShare)
	...set ^||TMP($j,InsTypeDR,Papmi,"PatShare")=$i(^||TMP($j,InsTypeDR,Papmi,"PatShare"), PatShare)
	...set ^||TMP($j,InsTypeDR,Papmi,"PayorShare")=$i(^||TMP($j,InsTypeDR,Papmi,"PayorShare"), PayorShare)

	quit
}

/// do ##class(%ResultSet).RunQuery("web.DHCOPBillPayorShareFee","GetPatCatFee","287", "TOC", 2)
Query GetPatCatFee(TMPGID As %String, CatType As %String, HospId As %String) As websys.Query(ROWSPEC = "regno:%String,patname:%String,insType:%String,desc:%String,amt:%Float") [ SqlProc ]
{
}

ClassMethod GetPatCatFeeExecute(ByRef QHandle As %Library.Binary, TMPGID As %String, CatType As %String, HospId As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set QHandle=$lb(0,repid,0)
	set ind=1
	set ^TMP("GetPatCatFee")=$lb(TMPGID, CatType, HospId)

	if (CatType="TAC") {
		set CatDesc=..getTarACCat(HospId)
	}else {
		set CatDesc=..getTarOCCat(HospId)
	}
	
	for i=1:1:$l(CatDesc,"^") {
		set desc=$p(CatDesc,"^",i)
		set idx=0
		while($o(^TMPOPPrintOut(TMPGID,idx))) {
			set idx=$o(^TMPOPPrintOut(TMPGID,idx))
			set data=$g(^TMPOPPrintOut(TMPGID,idx))
			set regno=$lg(data,1)
			set patname=$lg(data,2)
			set insType=$lg(data,3)
			set amt=$lg(data,(i+3))
			set amt=$fn(amt,"",2)
			do GetPatCatFee
		}
	}
	quit $$$OK	
GetPatCatFee
	set Data=$lb(regno,patname,insType,desc,amt)
	set ^CacheTemp(repid,ind)=Data
	set ind=ind+1
	quit
}

/// do ##class(%ResultSet).RunQuery("web.DHCOPBillPayorShareFee","QueryPatCatFeeNew","2022-12-01","2022-12-21","TOC","","2")
Query QueryPatCatFeeNew(StDate As %String, EndDate As %String, StatFlag As %String, PatTypeStat As %String, HospId As %String, langId As %String = "") As websys.Query(ROWSPEC = "PatNo,PatName,InsTypeDesc,CatFeeDesc,CatFee:%Float") [ SqlProc ]
{
}

ClassMethod QueryPatCatFeeNewExecute(ByRef qHandle As %Binary, StDate As %String, EndDate As %String, StatFlag As %String, PatTypeStat As %String, HospId As %String, langId As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set ind=1
	
	set ^TMP("QueryPatCatFeeNew")=$lb(StDate, EndDate, StatFlag, PatTypeStat, HospId)
	set Pid=$i(^TMPOPPrintOut)
	
	set StDate=##class(websys.Conversions).DateHtmlToLogical(StDate)
	set EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	
	kill ^||TMP($j)
	for date=StDate:1:EndDate do
	.do ..GetCatFeeStat(date, StDate, EndDate, StatFlag, PatTypeStat, HospId)
	
	//统计分类修正
	set CATENUM=27
	set CatId=0
	set i=0
	if (StatFlag="TAC") do
	.for  set CatId=$o(^DHCTarC("TAC",CatId)) quit:(CatId="")  do
	..set CatFeeDr($i(i))=CatId
	else  do
	.for  set CatId=$o(^DHCTarC("TOC",CatId)) quit:(CatId="")  do
	..set CatFeeDr($i(i))=CatId
	
	//初始化
	kill CatFeeHJ, CatFee
	for i=1:1:CATENUM  do
	.set CatFeeHJ(i)=0
	.set CatFee(i)=0
	
	set (SumHJ, PatShareSumHJ, PayorShareSumHJ)=0
	set InsType=0
	for  set InsType=$o(^||TMP($j,InsType)) quit:(InsType="")  do
	.set InsTypeDesc=$p($g(^PAC("ADMREA",InsType)),"^",2)
	.set InsTypeDesc=##class(User.PACAdmReason).GetTranByDesc("READesc", InsTypeDesc, langId)
	.set Papmi=0
	.for  set Papmi=$o(^||TMP($j,InsType,Papmi)) quit:(Papmi="")  do
	..set PatNo=$p($g(^PAPER(Papmi,"PAT",1)),"^",2)
	..set PatName=$p($g(^PAPER(Papmi,"ALL")),"^",1)
	..set CatDr=""
	..for  Set CatDr=$o(^||TMP($j,InsType,Papmi,"CatFee",CatDr))  Quit:(CatDr="")  Do
	...
	...If (StatFlag="TAC")  Do
	....Set CatFeeDesc=$p(^DHCTarC("TOC",CatDr),"^",2)
	...Else  Do
	....Set CatFeeDesc=$p(^DHCTarC("TAC",CatDr),"^",2)
	...set CatFee=+$g(^||TMP($j,InsType,Papmi,"CatFee",CatDr,"Amount"))
	...Do QueryPatCatFeeNew	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
QueryPatCatFeeNew
	set Data=$lb(PatNo,PatName,InsTypeDesc,CatFeeDesc,CatFee)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

}
