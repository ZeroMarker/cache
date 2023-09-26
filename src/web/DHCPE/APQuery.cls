Class web.DHCPE.APQuery Extends %Persistent [ ClassType = "", Not ProcedureBlock ]
{

Query SearchAdvancePaymentNew(RegNo As %String = "", Name As %String = "", Status As %String = "", BeginDate As %String = "", EndDate As %String = "", CardType As %String = "R", HospID As %String = "") As %Query(ROWSPEC = "TRowID:%String,TRegNo:%String,TCardNo:%String,TType:%String,TAmount:%String,TStatus:%String,TDate:%String,TTime:%String,TUser:%String,TRemark:%String,TName:%String,TSex:%String,TAge:%String,TEndLineDate:%String,TRebate:%String,TTel:%String,TIDCard:%String")
{
}

ClassMethod SearchAdvancePaymentNewExecute(ByRef qHandle As %Binary, RegNo As %String = "", Name As %String = "", Status As %String = "", BeginDate As %String = "", EndDate As %String = "", CardType As %String = "R", HospID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s Name=##class(web.DHCPE.DHCPECommon).UnEscape(Name)
 	i ((RegNo="")&(Name="")&(Status="")&(BeginDate="")&(EndDate="")){
		Set qHandle=$lb(0,repid,0)
		q $$$OK
	}
	
	i BeginDate'="" s BeginDate=##class(websys.Conversions).DateHtmlToLogical(BeginDate) 
	i EndDate'="" s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate) 
	
	i BeginDate="" s BeginDate=1
	i EndDate="" s EndDate=+$H

	i RegNo'=""
	{
		i CardType'="C"
		{
			i RegNo'="" s RegNo=##class(web.DHCPE.DHCPECommon).RegNoMask(RegNo)
			s APID=0
			f  s APID=$O(^DHCPEAP(0,"RegNo",RegNo,APID)) q:APID=""  d
			.d GetOneInfoNew
		}
		else
		{
			s APID=0
			f  s APID=$O(^DHCPEAP(0,"CardNo",RegNo,APID)) q:APID=""  d
			.d GetOneInfoNew
		}
	}
	elseif (Name'="")&&(CardType'="C")
	{
		S Name=$$ALPHAUP^SSUTIL4(Name)
		s CName=$O(^PAPERi("PAPER_PatName",Name),-1)
		f  s CName=$O(^PAPERi("PAPER_PatName",CName)) q:(CName="")||(CName'[Name)  d
		.s PID=0
		.f  s PID=$O(^PAPERi("PAPER_PatName",CName,PID)) q:(PID="")  d
		..s CRegNo=$P(^PAPER(PID,"PAT",1),"^",1)
		..s APID=0
		..f  s APID=$O(^DHCPEAP(0,"RegNo",CRegNo,APID)) q:APID=""  d
		...d GetOneInfoNew
	}
	elseif Status'=""
	{
		s APID=0
		f  s APID=$O(^DHCPEAP(0,"Status",Status,APID)) q:APID=""  d
		.d GetOneInfoNew
	}
	else
	{
		s CDate=BeginDate-1
		f  s CDate=$O(^DHCPEAP(0,"UpdateDate",CDate)) q:(CDate="")||(CDate>EndDate)  d
		.s APID=0
		.f  s APID=$O(^DHCPEAP(0,"UpdateDate",CDate,APID)) q:(APID="")  d
		..d GetOneInfoNew
	}
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
GetOneInfoNew
 	s TRowID=APID
 	q:1=##class(web.DHCPE.AdvancePayment).IsCurLocCard(APID)
	s TRegNo=$p($g(^DHCPEAP(TRowID)),"^",1)

	q:(TRegNo="")&&(CardType'="C")
	s TCardNo=$p($g(^DHCPEAP(TRowID)),"^",2)
	s TType=$p($g(^DHCPEAP(TRowID)),"^",3)

	q:TType'=CardType
	s TAmount=$p($g(^DHCPEAP(TRowID)),"^",4)
	i TAmount'="" s TAmount=$fn(TAmount,"",2)
	s TStatus=$p($g(^DHCPEAP(TRowID)),"^",5)
	q:(Status'="")&&(TStatus'=Status)
	s TStatus=##class(web.DHCPE.AdvancePayment).GetStatusDesc(TStatus)
	s TDate=$p($g(^DHCPEAP(TRowID)),"^",6)
	q:(TDate<BeginDate)||(TDate>EndDate)
	s TTime=$p($g(^DHCPEAP(TRowID)),"^",7)
	i TTime'="" s TTime=$zt(TTime)
	I TDate'="" S TDate=##class(websys.Conversions).DateLogicalToHtml(TDate)
	s TUser=$p($g(^DHCPEAP(TRowID)),"^",8)
	i TUser'="" s TUser=$p($g(^SSU("SSUSR",TUser)),"^",2)
	s TRemark=$p($g(^DHCPEAP(TRowID)),"^",9)
	s EndLineDate=$p($g(^DHCPEAP(TRowID)),"^",14)
	s:EndLineDate'="" EndLineDate=##class(websys.Conversions).DateLogicalToHtml(EndLineDate)
	s Rebate=$p($g(^DHCPEAP(TRowID)),"^",15)
	s:((Rebate'="")&&(Rebate'="0")) Rebate=Rebate_"%"
	i CardType'="C"
	{
		s ID=$O(^PAPERi("PAPMI_PatNo",TRegNo,0))
		q:ID=""
		s TName=$P(^PAPER(ID,"ALL"),"^",1)
		S TUName=$$ALPHAUP^SSUTIL4(TName)
		q:(Name'="")&&(TUName'[Name)
		//q:(Name'="")&&(TName'[Name)
		s Sex=$p($g(^PAPER(ID,"ALL")),"^",7)
		s:Sex'="" Sex=$p($g(^CT("SEX",Sex)),"^",2)
		s Sex=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.CTSex",Sex,"CTSEXDesc","cls")  //翻译
		s Birth=$p($g(^PAPER(ID,"ALL")),"^",6)
		s Tel=$p($g(^PAPER(ID,"PER",1)),"^",11)
		s IDCard=$P($G(^PAPER(ID,"PAT",3)),"^",6)
		//s Age=##class(web.DHCLCNUREXCUTE).CalAge(Birth,+$h)
		//s Age=$P(Age,"Y",1)
		//s Age=##class(web.DHCBillInterface).GetPapmiAge(ID)
		s Age=##class(web.DHCPE.DHCPECommon).GetPapmiAge(ID,HospID)
		s flag=##class(web.DHCPE.PreIADM).JudgeIGByRegNo(TRegNo)
		if (flag="G") s Sex="",Age="",Birth="",IDCard=""

	}
	else
	{
		s ID=""
		s TName=$p($G(^DHCPEDataEx("DHCPEAD","Info",TRowID)),"^",1)
		s Sex=$p($G(^DHCPEDataEx("DHCPEAD","Info",TRowID)),"^",2)
		s Age=$p($G(^DHCPEDataEx("DHCPEAD","Info",TRowID)),"^",3)
		s Tel=$p($G(^DHCPEAP(TRowID)),"^",16)
		s IDCard=$p($G(^DHCPEAP(TRowID)),"^",17)
        q:TName'[Name
        s Sex=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpeadvancepayment.find.hisui.csp",Sex)  //翻译
	}
	d FindBuildNew
	q 	
FindBuildNew 
 	s TStatus=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpeadvancepayment.find.hisui.csp",TStatus)  //翻译    
	set Data=$lb(TRowID,TRegNo,TCardNo,TType,TAmount,TStatus,TDate,TTime,TUser,TRemark,TName,Sex,Age,EndLineDate,Rebate,Tel,IDCard)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SearchAdvancePaymentNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchAdvancePaymentNewExecute ]
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

ClassMethod SearchAdvancePaymentNewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchAdvancePaymentNewExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query SearchAdvancePayment(RegNo As %String = "", Name As %String = "", Status As %String = "", BeginDate As %String = "", EndDate As %String = "", Type As %String = "R") As %Query(ROWSPEC = "TRowID:%String,TRegNo:%String,TCardNo:%String,TType:%String,TAmount:%String,TStatus:%String,TDate:%String,TTime:%String,TUser:%String,TRemark:%String,TName:%String,TSex:%String,TAge:%String")
{
}

ClassMethod SearchAdvancePaymentExecute(ByRef qHandle As %Binary, RegNo As %String = "", Name As %String = "", Status As %String = "", BeginDate As %String = "", EndDate As %String = "", Type As %String = "R") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s Name=##class(web.DHCPE.DHCPECommon).UnEscape(Name)
 	i ((RegNo="")&(Name="")&(Status="")&(BeginDate="")&(EndDate="")){
		Set qHandle=$lb(0,repid,0)
		q $$$OK
	}
	
	i BeginDate'="" s BeginDate=##class(websys.Conversions).DateHtmlToLogical(BeginDate) 
	i EndDate'="" s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate) 
	
	i BeginDate="" s BeginDate=1
	i EndDate="" s EndDate=+$H

	i RegNo'=""
	{
		i Type'="C"
		{
			i RegNo'="" s RegNo=##class(web.DHCPE.DHCPECommon).RegNoMask(RegNo)
			s APID=0
			f  s APID=$O(^DHCPEAP(0,"RegNo",RegNo,APID)) q:APID=""  d
			.d GetOneInfo
		}
		else
		{
			s APID=0
			f  s APID=$O(^DHCPEAP(0,"CardNo",RegNo,APID)) q:APID=""  d
			.d GetOneInfo
		}
	}
	elseif (Name'="")&&(Type'="C")
	{
		S Name=$$ALPHAUP^SSUTIL4(Name)
		s CName=$O(^PAPERi("PAPER_PatName",Name),-1)
		f  s CName=$O(^PAPERi("PAPER_PatName",CName)) q:(CName="")||(CName'[Name)  d
		.s PID=0
		.f  s PID=$O(^PAPERi("PAPER_PatName",CName,PID)) q:(PID="")  d
		..s CRegNo=$P(^PAPER(PID,"PAT",1),"^",1)
		..s APID=0
		..f  s APID=$O(^DHCPEAP(0,"RegNo",CRegNo,APID)) q:APID=""  d
		...d GetOneInfo
	}
	elseif Status'=""
	{
		s APID=0
		f  s APID=$O(^DHCPEAP(0,"Status",Status,APID)) q:APID=""  d
		.d GetOneInfo
	}
	else
	{
		s CDate=BeginDate-1
		f  s CDate=$O(^DHCPEAP(0,"UpdateDate",CDate)) q:(CDate="")||(CDate>EndDate)  d
		.s APID=0
		.f  s APID=$O(^DHCPEAP(0,"UpdateDate",CDate,APID)) q:(APID="")  d
		..d GetOneInfo
	}
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
GetOneInfo
 	s TRowID=APID
 	q:1=##class(web.DHCPE.AdvancePayment).IsCurLocCard(APID)
	s TRegNo=$p($g(^DHCPEAP(TRowID)),"^",1)

	q:(TRegNo="")&&(Type'="C")
	s TCardNo=$p($g(^DHCPEAP(TRowID)),"^",2)
	s TType=$p($g(^DHCPEAP(TRowID)),"^",3)

	q:TType'=Type
	s TAmount=$p($g(^DHCPEAP(TRowID)),"^",4)
	s TStatus=$p($g(^DHCPEAP(TRowID)),"^",5)
	q:(Status'="")&&(TStatus'=Status)
	s TStatus=##class(web.DHCPE.AdvancePayment).GetStatusDesc(TStatus)
	s TDate=$p($g(^DHCPEAP(TRowID)),"^",6)
	q:(TDate<BeginDate)||(TDate>EndDate)
	s TTime=$p($g(^DHCPEAP(TRowID)),"^",7)
	I TDate'="" S TDate=##class(websys.Conversions).DateLogicalToHtml(TDate)
	s TUser=$p($g(^DHCPEAP(TRowID)),"^",8)
	i TUser'="" s TUser=$p($g(^SSU("SSUSR",TUser)),"^",2)
	s TRemark=$p($g(^DHCPEAP(TRowID)),"^",9)
	i Type'="C"
	{
		s ID=$O(^PAPERi("PAPMI_PatNo",TRegNo,0))
		q:ID=""
		s TName=$P(^PAPER(ID,"ALL"),"^",1)
		S TUName=$$ALPHAUP^SSUTIL4(TName)
		q:(Name'="")&&(TUName'[Name)
		//q:(Name'="")&&(TName'[Name)
		s Sex=$p($g(^PAPER(ID,"ALL")),"^",7)
		s:Sex'="" Sex=$p($g(^CT("SEX",Sex)),"^",2)
		s Birth=$p($g(^PAPER(ID,"ALL")),"^",6)
		//s Age=##class(web.DHCLCNUREXCUTE).CalAge(Birth,+$h)
		//s Age=$P(Age,"Y",1)
		s Age=##class(web.DHCBillInterface).GetPapmiAge(ID)
		//s TName=TName_"^"_Sex_"^"_Age
	}
	else
	{
		s ID=""
		s TName=$p($G(^DHCPEDataEx("DHCPEAD","Info",TRowID)),"^",1)
		s Sex=$p($G(^DHCPEDataEx("DHCPEAD","Info",TRowID)),"^",2)
		s Age=$p($G(^DHCPEDataEx("DHCPEAD","Info",TRowID)),"^",3)
        q:TName'[Name
	}
	d FindBuild
	q 	
FindBuild      
	set Data=$lb(TRowID,TRegNo,TCardNo,TType,TAmount,TStatus,TDate,TTime,TUser,TRemark,TName,Sex,Age)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SearchAdvancePaymentFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchAdvancePaymentExecute ]
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

ClassMethod SearchAdvancePaymentClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchAdvancePaymentExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Description: 查询体检卡明细
/// debug: d ##class(%ResultSet).RunQuery("web.DHCPE.APQuery","SearchAPACDetail","","","","2022-09-05","","C","105")
Query SearchAPACDetail(RegNo As %String = "", Name As %String = "", Type As %String = "", BeginDate As %String = "", EndDate As %String = "", CardType As %String = "R", CTLocID As %String = "") As %Query(ROWSPEC = "TRowID:%String,TRegNo:%String,TRemainAmount:%String,TType:%String,TAmount:%String,TSourceNo:%String,TDate:%String,TTime:%String,TUser:%String,TRemark:%String,TName:%String,TReport:%String,TPayModeID:%String,TPayMode:%String,TCardNo:%String,TTime:%String,TSex:%String,TAge:%String,TReRemark:%String,TBilledName:%String,TPAADMTypeDesc")
{
}

ClassMethod SearchAPACDetailExecute(ByRef qHandle As %Binary, RegNo As %String = "", Name As %String = "", Type As %String = "", BeginDate As %String = "", EndDate As %String = "", CardType As %String = "R", CTLocID As %String = "") As %Status
{
	s ^tempdhcpe("SearchAPACDetail")=$lb(RegNo,Name,Type,BeginDate,EndDate,CardType,CTLocID)
	s repid=$I(^CacheTemp)
	s ind=1
	s User=%session.Get("LOGON.USERID")
	k ^TEMPDHCPE("CRegNo",User)
	
 	i ((RegNo="")&(Name="")&(Type="")&(BeginDate="")&(EndDate="")){
		Set qHandle=$lb(0,repid,0)
		q $$$OK
	}
	
	i BeginDate'="" s BeginDate=##class(websys.Conversions).DateHtmlToLogical(BeginDate) 
	i EndDate'="" s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate) 
	
	i BeginDate="" s BeginDate=1
	i EndDate="" s EndDate=+$H
		
		i RegNo'=""
		{
			i CardType="R"
			{
				i RegNo'="" s RegNo=##class(web.DHCPE.DHCPECommon).RegNoMask(RegNo)		
				s APID=0
				f  s APID=$O(^DHCPEAP(0,"RegNo",RegNo,APID)) q:APID=""  d
				.s Sub=""
				.f  s Sub=$O(^DHCPEAP(APID,"AC",Sub),-1) q:(Sub="")||(Sub=0)  d
				..d GetOneInfoDetail
			}
			else
			{
				s APID=0
				f  s APID=$O(^DHCPEAP(0,"CardNo",RegNo,APID)) q:APID=""  d
				.s Sub=""
				.f  s Sub=$O(^DHCPEAP(APID,"AC",Sub),-1) q:(Sub="")||(Sub=0)  d
				..d GetOneInfoDetail
			}
		}
		elseif Name'=""
		{
			if (CardType="R"){
			S NameU=$$ALPHAUP^SSUTIL4(Name)
			s CName=$O(^PAPERi("PAPER_PatName",NameU),-1)
			f  s CName=$O(^PAPERi("PAPER_PatName",CName)) q:(CName="")||(CName'[NameU)  d
			.s PID=0
			.f  s PID=$O(^PAPERi("PAPER_PatName",CName,PID)) q:(PID="")  d
			..s CRegNo=$P(^PAPER(PID,"PAT",1),"^",1)
			..Q:$D(^TEMPDHCPE("CRegNo",User,CRegNo))
			..S ^TEMPDHCPE("CRegNo",User,CRegNo)=1
			..s APID=0
			..f  s APID=$O(^DHCPEAP(0,"RegNo",CRegNo,APID)) q:APID=""  d
			...s Sub=""
			...f  s Sub=$O(^DHCPEAP(APID,"AC",Sub),-1) q:(Sub="")||(Sub=0)  d
			....d GetOneInfoDetail
			}else{
				
	            S ID=""
				f  s ID=$O(^DHCPEDataEx("DHCPEAD","Info",ID)) q:ID=""  d
				.s CName=$p($G(^DHCPEDataEx("DHCPEAD","Info",ID)),"^",1)
				.q:(Name'="")&&(CName'[Name)
				.s APID=ID
				.s Sub=""
				.f  s Sub=$O(^DHCPEAP(APID,"AC",Sub),-1) q:(Sub="")||(Sub=0)  d  
				..d GetOneInfoDetail
	           

			}

		}
		elseif Type'=""
		{
			s APID=0
			f  s APID=$O(^DHCPEAP(0,"Type",Type,APID)) q:APID=""  d
			.s Sub=""
			.f  s Sub=$O(^DHCPEAP(0,"Type",Type,APID,Sub),-1) q:(Sub="")||(Sub=0)  d
			..d GetOneInfoDetail
		}
		else
		{
			s CDate=EndDate+1
			f  s CDate=$O(^DHCPEAP(0,"Date",CDate),-1) q:(CDate="")||(CDate<BeginDate)  d
			.s APID=0
			.f  s APID=$O(^DHCPEAP(0,"Date",CDate,APID)) q:(APID="")  d
			..s Sub=""
			..f  s Sub=$O(^DHCPEAP(0,"Date",CDate,APID,Sub),-1) q:(Sub="")||(Sub=0)  d
			...d GetOneInfoDetail
		}
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
GetOneInfoDetail
    s PAADMType="",PAADMTypeDesc=""
	q:1=##class(web.DHCPE.AdvancePayment).IsCurLocCard(APID,CTLocID)
 	s CType=$p($g(^DHCPEAP(APID)),"^",3)
 	q:CType'=CardType
 	s TRowID=APID_"||"_Sub
 	
	i CardType="R" d
	.s TRegNo=$p($g(^DHCPEAP(APID)),"^",1)
	
	s TCardNo=$p($g(^DHCPEAP(APID)),"^",2)
	s TType=$p($g(^DHCPEAP(APID,"AC",Sub)),"^",1)
	q:(Type'="")&&(TType'=Type)
	s TAmount=$p($g(^DHCPEAP(APID,"AC",Sub)),"^",2)
	s TRemainAmount=$p($g(^DHCPEAP(APID,"AC",Sub)),"^",3)
	s TSourceNo=$p($g(^DHCPEAP(APID,"AC",Sub)),"^",4)
	s InvoID=TSourceNo
	
	s FocusPrintID=$o(^User.DHCPEINVFocusPrtI("IFPINVDRIndex"," "_TRowID,""))
	//i FocusPrintID'="" s TSourceNo=$LG(^User.DHCPEINVFocusPrtD(FocusPrintID),3)_"(集)"
    s FocusPrintEng=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpeapacfind.hisui.csp","集")
	i FocusPrintID'="" s TSourceNo=$LG(^User.DHCPEINVFocusPrtD(FocusPrintID),3)_"("_FocusPrintEng_")"
	
	s InvName=""
	s:InvoID'="" InvName=$G(^DHCPEDataEx("AdvancePayment","InvName",InvoID))
	
	i TType="RF" d
	.s InvoID=$p($g(^DHCPEAP(+TSourceNo,"AC",$p(TSourceNo,"||",2))),"^",4)
	.s:InvoID'="" InvName=$G(^DHCPEDataEx("AdvancePayment","InvName",InvoID))
	.;s TSourceNo="退发票号"_$p($g(^DHCPEAP(+TSourceNo,"AC",$p(TSourceNo,"||",2))),"^",4)
	.s RefSourceNoEng=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpeapacfind.hisui.csp","退发票号")
	.i TSourceNo'=""  s TSourceNo=$p($g(^DHCPEAP(+TSourceNo,"AC",$p(TSourceNo,"||",2))),"^",4)_"("_RefSourceNoEng_")"
	
	i (TType="B")||(TType="R") d
	.q:$D(^DHCPEAP(0,"SourceNo","RF",TRowID))
	.;s TSourceNo=TSourceNo_"(发票号)"
	.s SourceNoEng=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpeapacfind.hisui.csp","发票号")
	.i TSourceNo'="" s TSourceNo=TSourceNo_"("_SourceNoEng_")"
	
	i (TType="B")||(TType="R") d
	.q:'$D(^DHCPEAP(0,"SourceNo","RF",TRowID))
	.;s TSourceNo=TSourceNo_"(发票号已退)"
	.s RefedSourceNoEng=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpeapacfind.hisui.csp","发票号已退")
	.i TSourceNo'=""  s TSourceNo=TSourceNo_"("_RefedSourceNoEng_")"
	
	s TTypeDesc=""
	I TType'="" s TTypeDesc=##class(web.DHCPE.AdvancePayment).GetTypeDesc(TType)

	//s TType=##class(web.DHCPE.AdvancePayment).GetTypeDesc(TType)
	s TDate=$p($g(^DHCPEAP(APID,"AC",Sub)),"^",5)
	q:(TDate<BeginDate)||(TDate>EndDate)
	s TDate=##class(websys.Conversions).DateLogicalToHtml(TDate)
	s TTime=$p($g(^DHCPEAP(APID,"AC",Sub)),"^",6)
	s:TTime'="" TTime=##class(websys.Conversions).TimeLogicalToHtml(TTime)
	s TUser=$p($g(^DHCPEAP(APID,"AC",Sub)),"^",7)
	s:TUser'="" TUser=$P($g(^SSU("SSUSR",TUser)),"^",2)
	s TRemark=$p($g(^DHCPEAP(APID,"AC",Sub)),"^",8)
	//i TType="B" s TRemark=$p($g(^DHCPEAP(APID)),"^",9)
	i TType="B" d
	.s TRemark=$p($g(^DHCPEAP(APID)),"^",9)
	.i TRemark="" s TRemark=$p($G(^DHCPEAP(APID,"AC",Sub)),"^",8)

	s TReRemark=""
	i TType="RF" d
	.s TReRemark=$p($g(^DHCPEAP(APID,"AC",Sub)),"^",8)
	.s TRemark=""

	s TReport=$p($g(^DHCPEAP(APID,"AC",Sub)),"^",9)
	s TReportFlag=$p($g(^DHCPEAP(APID,"AC",Sub)),"^",13)
	i (TReportFlag="Y")&&(TReport="") s TReport="是"
	e  s TReport="否"
	
	s TPayModeID=$p($g(^DHCPEAP(APID,"AC",Sub)),"^",10)
	i TPayModeID'="" d  
	.s TPayMode=$P($G(^CT("CTPM",TPayModeID)),"^",2)
	.s TPayMode=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.CTPayMode",TPayMode,"CTPMDesc","cls") //翻译
	.i $g(^DHCPEDataEx("DHCPEAD","paymode",APID_"||"_Sub))'=""  d
	..s TPayMode=TPayMode_"("_$g(^DHCPEDataEx("DHCPEAD","paymode",APID_"||"_Sub))_")"
	s Sex=""
	i CardType="R" d
	.q:TRegNo=""
	.s ID=$O(^PAPERi("PAPMI_PatNo",TRegNo,0))
	.q:ID=""
	.s TName=$P($g(^PAPER(ID,"ALL")),"^",1)
	.q:(Name'="")&&(TName'[Name)
	.s TBilledName=TName
	.s Sex=$p($g(^PAPER(ID,"ALL")),"^",7)
	.s:Sex'="" Sex=$p($g(^CT("SEX",Sex)),"^",2)
	.s Sex=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.CTSex",Sex,"CTSEXDesc","cls") //翻译
	.s Birth=$p($g(^PAPER(ID,"ALL")),"^",6)
	.S Birth=##class(websys.Conversions).DateLogicalToHtml(Birth)
	.S Age=##class(web.DHCBillInterface).GetPapmiAge(ID)
	.s flag=##class(web.DHCPE.PreIADM).JudgeIGByRegNo(TRegNo)
	.if (flag="G") s Sex="",Age="",Birth=""
	.i (TTypeDesc="结算")||(TTypeDesc="结算退费") d
	..i TSourceNo["#" s TSourceNo=$p(TSourceNo,"#",1) //门诊一张发票可能对应多个账单
	..s PRTROWID=$o(^DHCPEINVPRT(0,"PB",TSourceNo,0))
	..s PAADM=$P($G(^DHCPB(TSourceNo)),"^",1)
	..q:PAADM=""
	..S PAADMType=$P($g(^PAADM(PAADM)),"^",2)
	..i PAADMType="H" d
	...s PAADMTypeDesc="体检"
	...s SourceNoEng=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpeapacfind.hisui.csp","发票号")
	...s:PRTROWID'="" TSourceNo=$p($g(^DHCPEINVPRT(PRTROWID)),"^",1)_"("_SourceNoEng_")"
	..e  d
	...s SourceNoEng=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpeapacfind.hisui.csp","账单ID")
	...s TSourceNo=TSourceNo_"     ("_SourceNoEng_")"
	
	...i PAADMType="I" s PAADMTypeDesc="住院"
	...i PAADMType="O" s PAADMTypeDesc="门诊"
	...i PAADMType="E" s PAADMTypeDesc="急诊"
	e  d
	.i (TTypeDesc="结算")||(TTypeDesc="结算退费") d
	..i TSourceNo["#" s TSourceNo=$p(TSourceNo,"#",1) //门诊一张发票可能对应多个账单
	..s PAADM=$P($G(^DHCPB(TSourceNo)),"^",1)
	..q:PAADM=""
	..S PAADMType=$P($g(^PAADM(PAADM)),"^",2)
	..i PAADMType="H" s PAADMTypeDesc="体检"
	..i PAADMType="I" s PAADMTypeDesc="住院"
	..i PAADMType="O" s PAADMTypeDesc="门诊"
	..i PAADMType="E" s PAADMTypeDesc="急诊"
	..s PatID=$P($g(^PAADM(PAADM)),"^",1)
	..s TRegNo=$P($g(^PAPER(PatID,"PAT",1)),"^",1)
	..s TName=$p($g(^DHCPEDataEx("DHCPEAD","Info",APID)),"^",1)
	..s TBilledName=$P($g(^PAPER(PatID,"ALL")),"^",1)
	..s Sex=$p($g(^PAPER(PatID,"ALL")),"^",7)
	..s:Sex'="" Sex=$p($g(^CT("SEX",Sex)),"^",2)
	..s Sex=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.CTSex",Sex,"CTSEXDesc","cls") //翻译
	..s Birth=$p($g(^PAPER(PatID,"ALL")),"^",6)
	..S Birth=##class(websys.Conversions).DateLogicalToHtml(Birth)
    ..s LocID=$P($g(^PAADM(PAADM)),"^",4) 
	..S HospID=##class(web.DHCPE.CT.DHCPEMappingLoc).GetHospIDByLocID(LocID)
	..s Age=##class(web.DHCPE.DHCPECommon).GetPapmiAge(PatID,HospID,LocID)
	..s SourceNoEng=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpeapacfind.hisui.csp","账单ID")
	..s TSourceNo=TSourceNo_"     ("_SourceNoEng_")"
	.e  i (TTypeDesc="转入")||(TTypeDesc="转出") d
	..s TName=$p($G(^DHCPEDataEx("DHCPEAD","Info",APID)),"^",1)
	..s TBilledName=""
	..s Sex=$p($G(^DHCPEDataEx("DHCPEAD","Info",APID)),"^",2)
	..s Sex=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpeapacfind.hisui.csp",Sex) //翻译
	..s Birth="",TRegNo=""
	.e  i TTypeDesc="退预缴金" d
	..s TSourceNo=TSourceNo
	..;s TSourceNo="退"_$p($g(^DHCPEAP(+TRowID,"AC",$p(TRowID,"||",2))),"^",4)
	..s TName=$p($G(^DHCPEDataEx("DHCPEAD","InvID",$p($g(^DHCPEAP(+TRowID,"AC",$p(TRowID,"||",2))),"^",4))),"^",1)
	..q:(Name'="")&&(TName'[Name)
	..s Sex=$p($G(^DHCPEDataEx("DHCPEAD","InvID",$p($g(^DHCPEAP(+TRowID,"AC",$p(TRowID,"||",2))),"^",4))),"^",2)
	..s Age=$p($G(^DHCPEDataEx("DHCPEAD","InvID",$p($g(^DHCPEAP(+TRowID,"AC",$p(TRowID,"||",2))),"^",4))),"^",3)
    ..s Birth="",TRegNo=""
    ..s TBilledName=""
    ..s Sex=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpeapacfind.hisui.csp",Sex) //翻译
	.e  d
	..;q:InvoID=""
	..;s TName=$G(^DHCPEDataEx("DHCPEAD","InvID",TRowID))
	..s TName=$p($G(^DHCPEDataEx("DHCPEAD","InvID",TRowID)),"^",1)
	..q:(Name'="")&&(TName'[Name)
	..s Sex=$p($G(^DHCPEDataEx("DHCPEAD","InvID",TRowID)),"^",2)
	..s Age=$p($G(^DHCPEDataEx("DHCPEAD","InvID",TRowID)),"^",3)
    ..s Birth="",TRegNo=""
    ..s TBilledName=""
    ..s Sex=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpeapacfind.hisui.csp",Sex) //翻译
    //s:InvName'="" TName=TName_"("_InvName_")"
	d FindBuildDetail
	q 	
FindBuildDetail  
 	/***翻译 start***/  
    s PAADMTypeDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpeapacfind.hisui.csp",PAADMTypeDesc)
    s TTypeDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpeapacfind.hisui.csp",TTypeDesc)
    s TReport=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpeapacfind.hisui.csp",TReport)
    /***翻译 end***/      
	set Data=$lb(TRowID,TRegNo,$j(TRemainAmount,3,2),TTypeDesc,$j(TAmount,3,2),TSourceNo,TDate,TTime,TUser,TRemark,TName,TReport,TPayModeID,TPayMode,TCardNo,$G(TTime),Sex,Birth,TReRemark,TBilledName,PAADMTypeDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SearchAPACDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchAPACDetailExecute ]
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

ClassMethod SearchAPACDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchAPACDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query SearchAPSCDetail(RegNo As %String = "", Name As %String = "", Type As %String = "", BeginDate As %String = "", EndDate As %String = "", Status As %String = "", CardNo As %String = "") As %Query(ROWSPEC = "TRowID:%String,TRegNo:%String,TType:%String,TStatus:%String,TSourceNo:%String,TDate:%String,TTime:%String,TUser:%String,TRemark:%String,TName:%String,TCardNo:%String")
{
}

ClassMethod SearchAPSCDetailExecute(ByRef qHandle As %Binary, RegNo As %String = "", Name As %String = "", Type As %String = "", BeginDate As %String = "", EndDate As %String = "", Status As %String = "", CardNo As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s Name=##class(web.DHCPE.DHCPECommon).UnEscape(Name)
 	i ((RegNo="")&(Name="")&(Type="")&(BeginDate="")&(EndDate="")&(Status="")&(CardNo="")){
		Set qHandle=$lb(0,repid,0)
		q $$$OK
	}
	
	i BeginDate'="" s BeginDate=##class(websys.Conversions).DateHtmlToLogical(BeginDate) 
	i EndDate'="" s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate) 

	i BeginDate="" s BeginDate=1
	i EndDate="" s EndDate=+$H
	i RegNo'="" s RegNo=##class(web.DHCPE.DHCPECommon).RegNoMask(RegNo)
		
	i RegNo'=""
	{
		s APID=0
		f  s APID=$O(^DHCPEAP(0,"RegNo",RegNo,APID)) q:APID=""  d
		.s Sub=0
		.f  s Sub=$O(^DHCPEAP(APID,"SC",Sub)) q:Sub=""  d
		..d GetOneSCInfoDetail
	}
	elseif Name'=""
	{
		if (Type="R"){
		S Name=$$ALPHAUP^SSUTIL4(Name)
		s CName=$O(^PAPERi("PAPER_PatName",Name),-1)
		f  s CName=$O(^PAPERi("PAPER_PatName",CName)) q:(CName="")||(CName'[Name)  d
		.s PID=0
		.f  s PID=$O(^PAPERi("PAPER_PatName",CName,PID)) q:(PID="")  d
		..s CRegNo=$P(^PAPER(PID,"PAT",1),"^",1)
		..s APID=0
		..f  s APID=$O(^DHCPEAP(0,"RegNo",CRegNo,APID)) q:APID=""  d
		...s Sub=0
		...f  s Sub=$O(^DHCPEAP(APID,"SC",Sub)) q:Sub=""  d
		....d GetOneSCInfoDetail
		}elseif (Type="C"){
			s APID=""
			f  s APID=$o(^DHCPEDataEx("DHCPEAD","Info",APID)) q:APID=""  d
			.s TName=$p($g(^DHCPEDataEx("DHCPEAD","Info",APID)),"^",1)
			.q:(Name'="")&&(TName'[Name)
			.s Sub=0
			.f  s Sub=$O(^DHCPEAP(APID,"SC",Sub)) q:Sub=""  d
			..d GetOneSCInfoDetail
			
		}

	}
	elseif Type'=""
	{
		s APID=0
		f  s APID=$O(^DHCPEAP(0,"CardType",Type,APID)) q:APID=""  d
		.s Sub=0
		.f  s Sub=$O(^DHCPEAP(APID,"SC",Sub)) q:Sub=""  d
		..d GetOneSCInfoDetail
	}
	elseif CardNo'=""
	{   S APID=""
		f  S APID=$o(^DHCPEAP(0,"CardNo",CardNo,APID)) q:APID=""  d
		.s Sub=0
		.f  s Sub=$O(^DHCPEAP(APID,"SC",Sub)) q:Sub=""  d
		..d GetOneSCInfoDetail
	}
	else
	{
		s CDate=BeginDate-1
		f  s CDate=$O(^DHCPEAP(0,"SCDate",CDate)) q:(CDate="")||(CDate>EndDate)  d
		.s APID=0
		.f  s APID=$O(^DHCPEAP(0,"SCDate",CDate,APID)) q:(APID="")  d
		..s Sub=0
		..f  s Sub=$O(^DHCPEAP(0,"SCDate",CDate,APID,Sub)) q:(Sub="")  d
		...d GetOneSCInfoDetail
	}
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
GetOneSCInfoDetail
	q:1=##class(web.DHCPE.AdvancePayment).IsCurLocCard(APID)
 	s TRowID=APID_"||"_Sub
	s TRegNo=$p($g(^DHCPEAP(APID)),"^",1)
	s TCardNo=$p($g(^DHCPEAP(APID)),"^",2)
	s TType=$p($g(^DHCPEAP(APID)),"^",3)
	q:TType="R"
	q:(Type'="")&&(TType'=Type)
	q:(CardNo'="")&&(TCardNo'=CardNo)
	s TType=##class(web.DHCPE.AdvancePayment).GetCardTypeDesc(TType)
	s TStatus=$p($g(^DHCPEAP(APID,"SC",Sub)),"^",1)
	q:(Status'="")&&(TStatus'=Status)
	s TStatus=##class(web.DHCPE.AdvancePayment).GetStatusDesc(TStatus)
	s TSourceNo=$p($g(^DHCPEAP(APID,"SC",Sub)),"^",6)
	s TDate=$p($g(^DHCPEAP(APID,"SC",Sub)),"^",2)
	q:(TDate<BeginDate)||(TDate>EndDate)
	s TDate=##class(websys.Conversions).DateLogicalToHtml(TDate)
	s TTime=$p($g(^DHCPEAP(APID,"SC",Sub)),"^",3)
	s TTime=$zt(TTime,1)
	s TUser=$p($g(^DHCPEAP(APID,"SC",Sub)),"^",4)
	s TUser=$P(^SSU("SSUSR",TUser),"^",2)
	s TRemark=$p($g(^DHCPEAP(APID,"SC",Sub)),"^",5)
	s ID="",TName=""
	i TRegNo'="" s ID=$O(^PAPERi("PAPMI_PatNo",TRegNo,0))
	i ID'="" s TName=$P(^PAPER(ID,"ALL"),"^",1)
	i TName'="" S TUName=$$ALPHAUP^SSUTIL4(TName)
	i TType="代金卡" D
	.S TName=$P($G(^DHCPEDataEx("DHCPEAD","Info",APID)),"^",1)
	.s TUName=TName
	q:(Name'="")&&(TUName'[Name)
	//q:(Name'="")&&(TName'[Name)
	d FindSCBuildDetail
	q 	
FindSCBuildDetail  
     /***翻译 start***/
    s TType=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpeapsc.find.hisui.csp",TType)
    s TStatus=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpeapsc.find.hisui.csp",TStatus)
    /***翻译 end***/  
	set Data=$lb(TRowID,TRegNo,TType,TStatus,TSourceNo,TDate,TTime,TUser,TRemark,TName,TCardNo)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SearchAPSCDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchAPSCDetailExecute ]
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

ClassMethod SearchAPSCDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchAPSCDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
