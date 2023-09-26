Class web.DHCPE.HealthGuide Extends %Persistent
{

/// d ##class(web.DHCPE.IMPMenuAndCompont).ExportProgressByProject("DHCPEHG","XML","D:/JJJ/")
/// w ##class(web.DHCPE.HealthGuide).GetPatBaseIfo(1)
ClassMethod GetPatBaseIfo(RegNo As %String)
{
	
	s PAPMIActive="N"
	s RowId=""
	Set PAPMIRowId=0
	For  Set PAPMIRowId=$O(^PAPERi("PAPMI_PatNo",RegNo,PAPMIRowId)) Quit:(PAPMIRowId="")||(PAPMIActive="Y")  Do
	.
	.s PAPMIActive=$P($g(^PAPER(PAPMIRowId,"PAT",1)),"^",6)
	.q:PAPMIActive'="Y"
	.s RowId=PAPMIRowId
	
	if RowId="" q ""
	s Name=$P($g(^PAPER(RowId,"ALL")),"^",1)
	s Sex=""
	s SexDr=$P($g(^PAPER(RowId,"ALL")),"^",7)
	i SexDr'=""  s Sex=$p($G(^CT("SEX",SexDr)),"^",2)
	s DOB=$P($g(^PAPER(RowId,"ALL")),"^",6)
	If DOB'=""  S DOB=##class(websys.Conversions).DateLogicalToHtml(DOB)
	/***翻译 start***/
	s Sex=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.CTSex",Sex,"CTSEXDesc","cls")
    /***翻译 end***/
	q RowId_"^"_Name_"^"_Sex_"^"_DOB_"^"_RegNo_"^"
}

/// 西南医大附属医院健康分析指导
/// d ##class(%ResultSet).RunQuery("web.DHCPE.HealthGuide","FindNeedHMPatInfo","310","1050","","")
Query FindNeedHMPatInfo(PatientID, CurPAADM, BDate, EDate, LocID) As websys.Query(ROWSPEC = "PaadmID:%String,PAPMINo:%String,AdmDate:%String,Name:%String,Age:%String,Sex:%String,VIPLevel:%String,VIPDesc:%String")
{
}

ClassMethod FindNeedHMPatInfoExecute(ByRef qHandle As %Binary, PatientID, CurPAADM, BDate, EDate, LocID) As %Status
{
	
	s ^tmp("DHCPE","FindNeedHMPatInfo")=$LB(PatientID,CurPAADM, BDate, EDate,LocID)
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1	
    
    s HospID=##class(web.DHCPE.CT.DHCPEMappingLoc).GetHospIDByLocID(LocID)
	
	if (PatientID="")
    {
	  	Set qHandle=$lb(0,repid,0)
		Quit $$$OK  
	}
	
	s:BDate'="" BDate=##class(websys.Conversions).DateHtmlToLogical(BDate) 
	s:EDate'="" EDate=##class(websys.Conversions).DateHtmlToLogical(EDate) 
	
	i (CurPAADM'="")&&(EDate="") d
	.s EDate=$P($g(^PAADM(CurPAADM)),"^",6)
	
	i EDate="" s EDate=+$H+1
	i BDate="" s BDate=0
	
    s (VIPLevel,VIPDesc)=""
    
    s PAPMINo=$P($g(^PAPER(PatientID,"PAT",1)),"^",1)
    s Name=$P($g(^PAPER(PatientID,"ALL")),"^",1)
	s Sex=$P($g(^PAPER(PatientID,"ALL")),"^",7)
	s:Sex'="" Sex=$P($g(^CT("SEX",Sex)),"^",2)
    //s Age=##class(web.DHCBillInterface).GetPapmiAge(PatientID,"")
    s Age=##class(web.DHCPE.DHCPECommon).GetPapmiAge(PatientID,HospID,LocID)

	s PaadmID=""
	f  s PaadmID=$O(^PAPERdr(PatientID,"ADM","H",PaadmID),-1) q:PaadmID=""  d
	.s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PAADM",PaadmID)
	.q:LocFlag=1
	.s GSRowId=$O(^DHCPEGS(0,"PAADM",PaadmID,""))
	.q:GSRowId=""
	.s PIADM=$O(^DHCPEIADM(0,"PAADM",PaadmID,0))
	.q:PIADM=""
	.s PreIADM=$P($g(^DHCPEIADM(PIADM)),"^",4)
	.//第一个为医生界面自动到达\第二个为打印条码自动到达
	.q:##class(web.DHCPE.ResultEdit).IsArrivedStatu(PaadmID)="0"
	.s AdmDate=$P($g(^PAADM(PaadmID)),"^",6)
	.q:((AdmDate<BDate)||(AdmDate>EDate))
	.q:((CurPAADM'="")&(CurPAADM=PaadmID))
	.s AdmDate=##class(websys.Conversions).DateLogicalToHtml(AdmDate)
	.;d ##class(web.DHCPE.TransResult).TransMain(PaadmID)
	.s VIPStr=##class(web.DHCPE.PreCommon).GetVIPLevel("PAADM",PaadmID)
	.i VIPStr'="" d
	..s VIPLevel=$p(VIPStr,"^",1)
	..s VIPDesc=$p(VIPStr,"^",2)
	./***翻译 start***/
	.s Sex=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.CTSex",Sex,"CTSEXDesc","cls")
    .s VIPDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEVIPLevel",VIPDesc,"VLDesc","cls")
    ./***翻译 end***/
    .s ^CacheTemp(repid,ind)=$lb(PaadmID,PAPMINo,AdmDate,Name,Age,Sex,VIPLevel,VIPDesc)
	.s ind=ind+1
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// Creator：      JinLei
/// CreatDate：    2019-2-28
/// Description:： 保存健康分析指导首页的内容
/// Table：        DHC_PE_HealthGuide
/// Input：      PatientID
/// Output：    0 成功， -1 失败
/// w ##class(web.DHCPE.HealthGuide).UpdateHGDetail("Template","<p>少时诵诗书所所所所所所所所所</p>"_$c(10))
ClassMethod UpdateHGDetail(PatientID, HGDetail)
{
	
	s ^TMPDHCPEJL("UpdateHGDetail")=$LB(PatientID, HGDetail)
	Q:PatientID="" "-1^PatientID"
	if (PatientID="Template")
	{
		s ID=$O(^User.DHCPEHealthGuideTemplateI("IndexHGTType","HOMEPAGE","HP",0))
		b ;ID
		i ID="" d
		.s obj=##class(User.DHCPEHealthGuideTemplate).%New()
		e  d
		.s obj=##class(User.DHCPEHealthGuideTemplate).%OpenId(ID)
		s obj.HGTType="HomePage"
		s obj.HGTRecordType="HP"
		s Stream=##class(%Stream.GlobalCharacter).%New()
		d Stream.Write(HGDetail)
		s obj.HGTDetail=Stream
		s obj.HGTVIP=""
		s obj.HGTUser=%session.Get("LOGON.USERID")	
	}
	else
	{
		s ID=$O(^User.DHCPEHealthGuideI("IndexPAPMIDR",PatientID,0))
		i ID="" d
		.s obj=##class(User.DHCPEHealthGuide).%New()
		.d obj.HGPAPMIDRSetObjectId(PatientID)
		e  d
		.s obj=##class(User.DHCPEHealthGuide).%OpenId(ID)
		s Stream=##class(%Stream.GlobalCharacter).%New()
		d Stream.Write(HGDetail)
		s obj.HGDetail=Stream
		s obj.HGUpdateDate=+$H
		s obj.HGUpdateTime=$P($H,",",2)
		s obj.HGUpdateUserDR=%session.Get("LOGON.USERID")
	}
	s sc=obj.%Save()
	d obj.%Close()
	If ($System.Status.IsError(sc))	
	{
		q "-1^"_$System.Status.GetErrorText(sc)
	}else{
		q obj.%Id()
	}
}

ClassMethod testaa()
{
	s obj=##class(User.DHCPEHealthGuideTemplate).%New()
	d obj.%BuildIndices()
}

/// Creator：      JinLei
/// CreatDate：    2019-6-6
/// Description:： 保存健康分析指导的数据分析，风险评估，方案制定，随访记录，疗效评估，需求备注
/// Table：        DHC_PE_HealthGuideRecord
/// Input：      PAADM
/// Output：    0 成功， -1 失败
/// w ##class(web.DHCPE.HealthGuide).UpdateHGRecordDetail("Template","<p>sssssssssss222222222</p>"_$c(10),"DAS")
ClassMethod UpdateHGRecordDetail(PAADM, HGRDetail, Type As %String = "")
{
	
	s ^TMPDHCPEJL("UpdateHGDetail")=$LB(PAADM, HGRDetail,Type)
	
	;s ^DHCPEDataEx("HGDetail",PAADM,Type)=HGDetail
	
	Q:PAADM="" "-1^PAADM"
	;s GSID=$O(^DHCPEGS(0,"PAADM",PAADM,""))
	;Q:GSID="" "-1^GSID"
	if (PAADM="Template")
	{
		s ID=$O(^User.DHCPEHealthGuideTemplateI("IndexHGTType","RECORD",$ZCVT(Type,"U"),0))
		i ID="" d
		.s obj=##class(User.DHCPEHealthGuideTemplate).%New()
		e  d
		.s obj=##class(User.DHCPEHealthGuideTemplate).%OpenId(ID)
		s obj.HGTType="Record"
		s obj.HGTRecordType=Type
		s Stream=##class(%Stream.GlobalCharacter).%New()
		d Stream.Write(HGRDetail)
		s obj.HGTDetail=Stream
		s obj.HGTVIP=""
		s obj.HGTUser=%session.Get("LOGON.USERID")	
	}
	else
	{
		s ID=$O(^User.DHCPEHealthGuideRecordI("IndexPAADMType",PAADM,$ZCVT(Type,"U"),0))
		i ID="" d
		.s obj=##class(User.DHCPEHealthGuideRecord).%New()
		.d obj.HGRPAADMDRSetObjectId(PAADM)
		e  d
		.s obj=##class(User.DHCPEHealthGuideRecord).%OpenId(ID)
		s Stream=##class(%Stream.GlobalCharacter).%New()
		d Stream.Write(HGRDetail)
		s obj.HGRDetail=Stream
		s obj.HGRUpdateDate=+$H
		s obj.HGRUpdateTime=$P($H,",",2)
		s obj.HGRUpdateUserDR=%session.Get("LOGON.USERID")
		s obj.HGRType=Type
	
	}
	s sc=obj.%Save()
	d obj.%Close()
	If ($System.Status.IsError(sc))	
	{
		q "-1^"_$System.Status.GetErrorText(sc)
	}else{
		q obj.%Id()
	}
}

/// Creator：      JinLei
/// CreatDate：    2019-8-6
/// Description:： 取健康分析指导数据分析，风险评估，方案制定，随访记录，疗效评估，需求备注，为空则取模板
/// Table：        DHC_PE_HealthGuideRecord
/// Input：      PAADM
/// Output：    0 成功， -1 失败
ClassMethod GetHGRecordDetail(PAADM As %String, Type As %String)
{
	;w ##class(web.DHCPE.HealthGuide).GetHGRecordDetail("793","DAS")
	s ^TMPDHCPEJL("GetHGRecordDetail")=$LB(PAADM,Type)
	s ID=$O(^User.DHCPEHealthGuideRecordI("IndexPAADMType",PAADM,$ZCVT(Type,"U"),0))
	b ;ID
	i ID="" d
	.s HGRecordDetail=..GetHGDetailTemplate("Record",Type,"")
	e  d
	.s obj=##class(User.DHCPEHealthGuideRecord).%OpenId(ID)
	.s Stream=obj.HGRDetail
	.s len=Stream.SizeGet()
    .d Stream.Rewind()
	.s HGRecordDetail=Stream.Read(len)
	
	q HGRecordDetail
}

/// Creator：      JinLei
/// CreatDate：    2019-8-6
/// Description:： 取健康分析指导首页，为空则取模板
/// Table：        DHC_PE_HealthGuideRecord
/// Input：      PatientID
/// Output：    0 成功， -1 失败
ClassMethod GetHGDetail(PatientID As %String)
{
	
	s ID=$O(^User.DHCPEHealthGuideI("IndexPAPMIDR",PatientID,0))
	s THFlag=0
	i ID="" d
	.s HGDetail=..GetHGDetailTemplate("HomePage","HP","")
	.s THFlag=1
	e  d
	.s obj=##class(User.DHCPEHealthGuide).%OpenId(ID)
	.s Stream=obj.HGDetail
	.s len=Stream.SizeGet()
    .d Stream.Rewind()
	.s HGDetail=Stream.Read(len)
	i HGDetail="" d
	.s HGDetail=..GetHGDetailTemplate("HomePage","HP","")
	.s THFlag=1
	i (THFlag=1)&(PatientID'="Template") d 
	.s RegNo=$p($g(^PAPER(PatientID,"PAT",1)),"^",1)
	.s Name=$P(^PAPER(PatientID,"ALL"),"^",1)
	.s Sex=""
	.s SexDr=$P(^PAPER(PatientID,"ALL"),"^",7)
	.i SexDr'=""  s Sex=$p($G(^CT("SEX",SexDr)),"^",2)
	.s DOB=$P(^PAPER(PatientID,"ALL"),"^",6)
	.If DOB'=""  S IDOB=##class(websys.Conversions).DateLogicalToHtml(DOB)
	.s PatTel=$p($g(^PAPER(PatientID,"PER",4)),"^",21) 
	.s Age=##class(web.DHCLCNUREXCUTE).CalAge(DOB,+$h)
	.s Age=$P(Age,"Y",1)
	.s IDCard=$P(^PAPER(PatientID,"ALL"),"^",9)
	.s Position=""
	.s HGDetail=$Replace(HGDetail,"PatName",Name)
	.s HGDetail=$Replace(HGDetail,"Sex",Sex)
	.s HGDetail=$Replace(HGDetail,"Age",Age)
	.s HGDetail=$Replace(HGDetail,"IDCard",IDCard)
	.s HGDetail=$Replace(HGDetail,"Position",Position)
	.s HGDetail=$Replace(HGDetail,"MobPhone",PatTel)
	.s HGDetail=$Replace(HGDetail,"CurDate",$ZD(+$H,3))
	.s HGDetail=$Replace(HGDetail,"RegNo",RegNo)

	q HGDetail
}

ClassMethod GetHGDetailTemplate(Type, RecordType, VIP)
{
	s Detail=""
	s ID=$O(^User.DHCPEHealthGuideTemplateI("IndexHGTType",$ZCVT(Type,"U"),$ZCVT(RecordType,"U"),0))
	i ID'="" d
	.s obj=##class(User.DHCPEHealthGuideTemplate).%OpenId(ID)
	.s Stream=obj.HGTDetail
	.s len=Stream.SizeGet()
    .d Stream.Rewind()
	.s Detail=Stream.Read(len)
	q Detail
}

/// 取总检对应记录的健康管理内容
/// 	w ##class(web.DHCPE.GeneralSummarizeEx).GetHGDetail(708)
ClassMethod GetHGDetailOld(PAADM, Type As %String = "HM")
{
	s ^TMPDHCPEJL("GetHGDetail")=$LB(PAADM, Type)
	Q:PAADM="" "-1^PAADM"
	i Type'="HM" q $G(^DHCPEDataEx("HGDetail",PAADM,Type))
	Q:Type'="HM" ""
	s GSID=$O(^DHCPEGS(0,"PAADM",PAADM,""))
	Q:GSID="" "-1^GSID"
	s ID=$O(^User.DHCPEHGSumI("IndexParref",GSID,0))
	b ;ID
	s HGDetail=""
	i ID'="" d
	.s obj=##class(User.DHCPEHGSum).%OpenId(ID)
	.s Stream=obj.HGSDetail
	.s len=Stream.SizeGet()
    .d Stream.Rewind()
	.s HGDetail=Stream.Read(len)
	b ;HGDetail
	q:HGDetail["健康管理档案" HGDetail
	s UserID=""
	s:$D(%session) UserID=%session.Get("LOGON.USERID")
	s:UserID="" UserID=PAADM
	d ##Class(web.DHCPE.ReportOutToWeb).GetReportInfor(PAADM,UserID)
	//处理基本信息
	s Name=$G(^TMPReport(UserID,"PatInfo","PatName"))
	s Sex=$G(^TMPReport(UserID,"PatInfo","PatSex"))
	s Age=$G(^TMPReport(UserID,"PatInfo","PatAge"))
	s PatCompany=$G(^TMPReport(UserID,"PatInfo","PatCompany"))
	s Position=$G(^TMPReport(UserID,"PatInfo","Position"))
	s CheckDate=$G(^TMPReport(UserID,"PatInfo","AdmDate"))
	s AuditDoc=$G(^TMPReport(UserID,"GeneralAdvice","AduitUser"))
	s AuditDate=$G(^TMPReport(UserID,"GeneralAdvice","AduitUserDate"))
	s MainDoc=$G(^TMPReport(UserID,"GeneralAdvice","MainDoctor"))
	s MainDate=$G(^TMPReport(UserID,"GeneralAdvice","MainDoctorDate"))
	s VIPDesc=$G(^TMPReport(UserID,"PatInfo","VIPLevel"))
	s RegNo=$G(^TMPReport(UserID,"PatInfo","PatHPNo"))  
	s HPNo=$G(^TMPReport(UserID,"PatInfo","PatRegNo"))
	s PatTel=$G(^TMPReport(UserID,"PatInfo","PatTel"))
	s IDCard=$G(^TMPReport(UserID,"PatInfo","PatID"))
	s PatInfo=^DHCPEDataEx("HealthGuide","PatInfo")
	//q PatInfo
	 
	s PatInfo=$Replace(PatInfo,"PatName",Name)
	s PatInfo=$Replace(PatInfo,"Sex",Sex)
	s PatInfo=$Replace(PatInfo,"Age",Age)
	s PatInfo=$Replace(PatInfo,"IDCard",IDCard)
	s PatInfo=$Replace(PatInfo,"GroupName",PatCompany)
	s PatInfo=$Replace(PatInfo,"Position",Position)
	s PatInfo=$Replace(PatInfo,"MobPhone",PatTel)
	s PatInfo=$Replace(PatInfo,"CheckDate",CheckDate)
	s PatInfo=$Replace(PatInfo,"CurDate",$ZD(+$H,3))
	s PatInfo=$Replace(PatInfo,"RegNo",RegNo)
	/*
	//处理建议
	s Advice=$G(^TMPReport(UserID,"GeneralAdvice","Advice"))
	s Advice=$Replace(Advice,$c(10,10),"<Br>")
	//s Advice=$Replace(Advice,$c(10),"<Br>")
	s PatInfo=$Replace(PatInfo,"GeneralAdvice",Advice)
	*/
	//其他默认
	;s GeneralAdvice=$G(^DHCPEDataEx("HealthGuide","GeneralAdvice"))
	;s GeneralAdvice=$Replace(GeneralAdvice,"[","<h2>")
	;s GeneralAdvice=$Replace(GeneralAdvice,"]","</h2>")
	;s GeneralAdvice=$Replace(GeneralAdvice,"GeneralAdvice",Advice)
	;s Other=$G(^DHCPEDataEx("HealthGuide","Other"))
	b ;
	s HGDetail=PatInfo
	q HGDetail
}

ClassMethod SetDefaultHG()
{
	;w ##class(web.DHCPE.GeneralSummarizeEx).SetDefaultHG()
	s ^DHCPEDataEx("HealthGuide","PatInfo")="<table cellspacing=""0"" style=""width:100%"">"_$c(10,9)_"<thead>"_$c(10,9,9)_"<tr>"_$c(10,9,9,9)_"<th colspan=""7"" scope=""col"" style=""border-color: rgb(0, 0, 0) rgb(0, 0, 0) windowtext; width: 75px; vertical-align: middle;"">"_$c(10,9,9,9)_"<h1><strong>健康管理档案</strong></h1>"_$c(10,9,9,9)_"</th>"_$c(10,9,9,9)_"<th scope=""col"" style=""border-color: rgb(0, 0, 0) rgb(0, 0, 0) windowtext; width: 25%; text-align: left; vertical-align: middle;"">"_$c(10,9,9,9)_"<p>RegNo</p>"_$c(10,9,9,9)_"</th>"_$c(10,9,9)_"</tr>"_$c(10,9)_"</thead>"_$c(10,9)_"<tbody>"_$c(10,9,9)_"<tr>"_$c(10,9,9,9)_"<td colspan=""8"" style=""border-color:#000000 windowtext windowtext; vertical-align:top; width:414.8pt"">"_$c(10,9,9,9)_"<h2>基本信息</h2>"_$c(10,9,9,9)_"</td>"_$c(10,9,9)_"</tr>"_$c(10,9,9)_"<tr>"_$c(10,9,9,9)_"<td style=""border-color:#000000 windowtext windowtext; text-align:justify; vertical-align:middle; width:10%"">"_$c(10,9,9,9)_"<p>姓  名</p>"_$c(10,9,9,9)_"</td>"_$c(10,9,9,9)_"<td style=""border-color:#000000 windowtext windowtext #000000; text-align:justify; vertical-align:middle; width:20%"">"_$c(10,9,9,9)_"<p>PatName</p>"_$c(10,9,9,9)_"</td>"_$c(10,9,9,9)_"<td style=""border-color:#000000 windowtext windowtext #000000; text-align:justify; vertical-align:middle; width:10%"">"_$c(10,9,9,9)_"<p>性    别</p>"_$c(10,9,9,9)_"</td>"_$c(10,9,9,9)_"<td style=""border-color:#000000 windowtext windowtext #000000; text-align:justify; vertical-align:middle; width:10%"">"_$c(10,9,9,9)_"<p>Sex</p>"_$c(10,9,9,9)_"</td>"_$c(10,9,9,9)_"<td style=""border-color:#000000 windowtext windowtext #000000; text-align:justify; vertical-align:middle; width:5%"">"_$c(10,9,9,9)_"<p>年龄</p>"_$c(10,9,9,9)_"</td>"_$c(10,9,9,9)_"<td style=""border-color:#000000 windowtext windowtext #000000; text-align:justify; vertical-align:middle; width:10%"">"_$c(10,9,9,9)_"<p>Age</p>"_$c(10,9,9,9)_"</td>"_$c(10,9,9,9)_"<td style=""border-color:#000000 windowtext windowtext #000000; text-align:justify; vertical-align:middle; width:10%"">"_$c(10,9,9,9)_"<p>身份证</p>"_$c(10,9,9,9)_"</td>"_$c(10,9,9,9)_"<td style=""border-color:#000000 windowtext windowtext #000000; text-align:justify; vertical-align:middle; width:25%"">"_$c(10,9,9,9)_"<p>IDCard</p>"_$c(10,9,9,9)_"</td>"_$c(10,9,9)_"</tr>"_$c(10,9,9)_"<tr>"_$c(10,9,9,9)_"<td style=""border-color:#000000 windowtext windowtext; text-align:justify; vertical-align:middle; width:10%"">"_$c(10,9,9,9)_"<p>单  位</p>"_$c(10,9,9,9)_"</td>"_$c(10,9,9,9)_"<td style=""border-color:#000000 windowtext windowtext #000000; text-align:justify; vertical-align:middle; width:20%"">"_$c(10,9,9,9)_"<p>GroupName</p>"_$c(10,9,9,9)_"</td>"_$c(10,9,9,9)_"<td style=""border-color:#000000 windowtext windowtext #000000; text-align:justify; vertical-align:middle; width:10%"">"_$c(10,9,9,9)_"<p>职    务</p>"_$c(10,9,9,9)_"</td>"_$c(10,9,9,9)_"<td colspan=""3"" style=""border-color:#000000 windowtext windowtext #000000; text-align:justify; vertical-align:middle; width:25%"">"_$c(10,9,9,9)_"<p>Position</p>"_$c(10,9,9,9)_"</td>"_$c(10,9,9,9)_"<td style=""border-color:#000000 windowtext windowtext #000000; text-align:justify; vertical-align:middle; width:10%"">"_$c(10,9,9,9)_"<p>联系电话</p>"_$c(10,9,9,9)_"</td>"_$c(10,9,9,9)_"<td style=""border-color:#000000 windowtext windowtext #000000; text-align:justify; vertical-align:middle; width:25%"">"_$c(10,9,9,9)_"<p>MobPhone</p>"_$c(10,9,9,9)_"</td>"_$c(10,9,9)_"</tr>"_$c(10,9,9)_"<tr>"_$c(10,9,9,9)_"<td style=""border-color:#000000 windowtext windowtext; text-align:justify; vertical-align:middle; width:10%"">"_$c(10,9,9,9)_"<p>联系人</p>"_$c(10,9,9,9)_"</td>"_$c(10,9,9,9)_"<td style=""border-color:#000000 windowtext windowtext #000000; text-align:justify; vertical-align:middle; width:20%"">"_$c(10,9,9,9)_"<p> </p>"_$c(10,9,9,9)_"</td>"_$c(10,9,9,9)_"<td style=""border-color:#000000 windowtext windowtext #000000; text-align:justify; vertical-align:middle; width:10%"">"_$c(10,9,9,9)_"<p>联系电话</p>"_$c(10,9,9,9)_"</td>"_$c(10,9,9,9)_"<td colspan=""3"" style=""border-color:#000000 windowtext windowtext #000000; text-align:justify; vertical-align:middle; width:25%"">"_$c(10,9,9,9)_"<p> </p>"_$c(10,9,9,9)_"</td>"_$c(10,9,9,9)_"<td style=""border-color:#000000 windowtext windowtext #000000; text-align:justify; vertical-align:middle; width:10%"">"_$c(10,9,9,9)_"<p>车牌</p>"_$c(10,9,9,9)_"</td>"_$c(10,9,9,9)_"<td style=""border-color:#000000 windowtext windowtext #000000; text-align:justify; vertical-align:middle; width:25%"">"_$c(10,9,9,9)_"<p> </p>"_$c(10,9,9,9)_"</td>"_$c(10,9,9)_"</tr>"_$c(10,9,9)_"<tr>"_$c(10,9,9,9)_"<td style=""border-color:#000000 windowtext windowtext; text-align:justify; vertical-align:middle; width:10%"">"_$c(10,9,9,9)_"<p>体检日期</p>"_$c(10,9,9,9)_"</td>"_$c(10,9,9,9)_"<td style=""border-color:#000000 windowtext windowtext #000000; text-align:justify; vertical-align:middle; width:20%"">"_$c(10,9,9,9)_"<p>CheckDate</p>"_$c(10,9,9,9)_"</td>"_$c(10,9,9,9)_"<td style=""border-color:#000000 windowtext windowtext #000000; text-align:justify; vertical-align:middle; width:10%"">"_$c(10,9,9,9)_"<p>拟体检日期</p>"_$c(10,9,9,9)_"</td>"_$c(10,9,9,9)_"<td colspan=""3"" style=""border-color:#000000 windowtext windowtext #000000; text-align:justify; vertical-align:middle; width:25%"">"_$c(10,9,9,9)_"<p> </p>"_$c(10,9,9,9)_"</td>"_$c(10,9,9,9)_"<td style=""border-color:#000000 windowtext windowtext #000000; text-align:justify; vertical-align:middle; width:10%"">"_$c(10,9,9,9)_"<p>建档日期</p>"_$c(10,9,9,9)_"</td>"_$c(10,9,9,9)_"<td style=""border-color:#000000 windowtext windowtext #000000; text-align:justify; vertical-align:middle; width:25%"">"_$c(10,9,9,9)_"<p>CurDate</p>"_$c(10,9,9,9)_"</td>"_$c(10,9,9)_"</tr>"_$c(10,9,9)_"<tr>"_$c(10,9,9,9)_"<td colspan=""8"" style=""border-color:#000000 windowtext windowtext; text-align:left; vertical-align:top; width:100%"">"_$c(10,9,9,9)_"<h2>体检结论</h2>"_$c(10,9,9,9)_"</td>"_$c(10,9,9)_"</tr>"_$c(10,9,9)_"<tr>"_$c(10,9,9,9)_"<td colspan=""8"" style=""border-color:#000000 windowtext windowtext; text-align:left; vertical-align:top; width:100%"">"_$c(10,9,9,9)_"<p>GeneralAdvice</p>"_$c(10,9,9,9)_"</td>"_$c(10,9,9)_"</tr>"_$c(10,9,9)_"<tr>"_$c(10,9,9,9)_"<td colspan=""8"" style=""border-color:#000000 windowtext windowtext; text-align:left; vertical-align:top; width:100%"">"_$c(10,9,9,9)_"<h2>疾病风险评估</h2>"_$c(10,9,9,9)_"</td>"_$c(10,9,9)_"</tr>"_$c(10,9,9)_"<tr>"_$c(10,9,9,9)_"<td colspan=""8"" style=""border-color:#000000 windowtext windowtext; text-align:left; vertical-align:top; width:100%"">"_$c(10,9,9,9)_"<p> </p>"_$c(10,9,9,9)_"</td>"_$c(10,9,9)_"</tr>"_$c(10,9,9)_"<tr>"_$c(10,9,9,9)_"<td colspan=""8"" style=""border-color:#000000 windowtext windowtext; text-align:left; vertical-align:top; width:100%"">"_$c(10,9,9,9)_"<h2>复查项目时间表</h2>"_$c(10,9,9,9)_"</td>"_$c(10,9,9)_"</tr>"_$c(10,9,9)_"<tr>"_$c(10,9,9,9)_"<td colspan=""8"" style=""border-color:#000000 windowtext windowtext; text-align:left; vertical-align:top; width:100%"">"_$c(10,9,9,9)_"<p> </p>"_$c(10,9,9,9)_"</td>"_$c(10,9,9)_"</tr>"_$c(10,9,9)_"<tr>"_$c(10,9,9,9)_"<td colspan=""8"" style=""border-color:#000000 windowtext windowtext; text-align:left; vertical-align:top; width:100%"">"_$c(10,9,9,9)_"<h2>高级客户健康管理服务内容</h2>"_$c(10,9,9,9)_"</td>"_$c(10,9,9)_"</tr>"_$c(10,9,9)_"<tr>"_$c(10,9,9,9)_"<td colspan=""8"" style=""border-color:#000000 windowtext windowtext; text-align:left; vertical-align:top; width:100%"">"_$c(10,9,9,9)_"<p> </p>"_$c(10,9,9,9)_"</td>"_$c(10,9,9)_"</tr>"_$c(10,9,9)_"<tr>"_$c(10,9,9,9)_"<td colspan=""8"" style=""border-color:#000000 windowtext windowtext; text-align:left; vertical-align:top; width:100%"">"_$c(10,9,9,9)_"<h2>日常生活注意事项</h2>"_$c(10,9,9,9)_"</td>"_$c(10,9,9)_"</tr>"_$c(10,9,9)_"<tr>"_$c(10,9,9,9)_"<td colspan=""8"" style=""border-color:#000000 windowtext windowtext; text-align:left; vertical-align:top; width:100%"">"_$c(10,9,9,9)_"<p> </p>"_$c(10,9,9,9)_"</td>"_$c(10,9,9)_"</tr>"_$c(10,9,9)_"<tr>"_$c(10,9,9,9)_"<td colspan=""8"" style=""border-color:#000000 windowtext windowtext; text-align:left; vertical-align:top; width:100%"">"_$c(10,9,9,9)_"<h2>客户诉求</h2>"_$c(10,9,9,9)_"</td>"_$c(10,9,9)_"</tr>"_$c(10,9,9)_"<tr>"_$c(10,9,9,9)_"<td colspan=""8"" style=""border-color:#000000 windowtext windowtext; text-align:left; vertical-align:top; width:100%"">"_$c(10,9,9,9)_"<p> </p>"_$c(10,9,9,9)_"</td>"_$c(10,9,9)_"</tr>"_$c(10,9)_"</tbody>"_$c(10)_"</table>"_$c(10)
	s ^DHCPEDataEx("HealthGuide","GeneralAdvice")="<h2>本次体检结论</h2>"_$c(10,10)_"<p>GeneralAdvice</p>"_$c(10,10)
	s ^DHCPEDataEx("HealthGuide","Other")="<h2>疾病风险评估</h2>"_$c(10,10)_"<h2>复查项目时间表</h2>"_$c(10,10)_"<h2>高级客户健康管理服务内容</h2>"_$c(10,10)_"<h2>日常生活注意事项</h2>"_$c(10,10)_"<h2>客户诉求</h2>"_$c(10,10)_"<p> </p>"_$c(10)
}

ClassMethod GetDefaultHG()
{
	//w ##class(web.DHCPE.HealthGuide).GetDefaultHG()
	q $G(^DHCPEDataEx("HealthGuide","PatInfo"))_$G(^DHCPEDataEx("HealthGuide","GeneralAdvice"))_$G(^DHCPEDataEx("HealthGuide","Other"))
}

/// 处理历史数据
ClassMethod MoveHistoryRecord()
{
	;w ##class(web.DHCPE.HealthGuide).MoveHistoryRecord()
	s PAADM=""
	f  s PAADM=$O(^DHCPEDataEx("HGDetail",PAADM)) q:PAADM=""  d
	.s Type="" f  s Type=$O(^DHCPEDataEx("HGDetail",PAADM,Type))  q:Type=""  d
	..s dt=$G(^DHCPEDataEx("HGDetail",PAADM,Type))
	..d ..UpdateHGRecordDetail(PAADM,dt,Type)
	q 0
}

/// 处理历史数据
ClassMethod MoveHistoryPatHP()
{
	;w ##class(web.DHCPE.HealthGuide).MoveHistoryPatHP()
	s id=0
	f  s id=$O(^User.DHCPEHGSumD(id))  q:id=""  d
	.s gsid=$LG(^User.DHCPEHGSumD(id),3)
	.s obj=##class(User.DHCPEHGSum).%OpenId(id)
	.s Stream=obj.HGSDetail
	.s len=Stream.SizeGet()
    .d Stream.Rewind()
	.s HGDetail=Stream.Read(len)
	.s PAADM=$P(^DHCPEGS(gsid,1),"^",8)
	.s Pat=$p(^PAADM(PAADM),"^",1)
	.d ..UpdateHGDetail(Pat,HGDetail)
	q 0
}

/// 得到打印的url地址，页眉，页脚信息
/// w ##Class(web.DHCPE.HealthGuide).GetPrintInfo("793","","dhcpe.healthguide.print.csp?PAADM=793&Type=DAS&PatientID=")
ClassMethod GetPrintInfo(PAADM, PatientID, CotentType, Type)
{
	s ^TMPDHCPEJL("GetPrintInfo")=$LB(PAADM, PatientID,CSPName)
	
	s CSPName="dhcpe.healthguide.print.csp"
	s:Type="Header" CSPName="dhcpe.healthguide.print.header.csp"
	s Url=..GetServerPath()_CSPName_"?PAADM="_PAADM_"&PatientID="_PatientID_"&Type="_CotentType
	q Url
}

ClassMethod GetServerPath()
{
	s ServerPath=##class(ext.util.String).GetCacheURL()
	s ServerPath=$P(ServerPath,"web/csp/",1)
	s ServerPath=ServerPath_"web/csp/"
	q ServerPath
}

Storage Default
{
<Data name="HealthGuideDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCPE.HealthGuideD</DataLocation>
<DefaultData>HealthGuideDefaultData</DefaultData>
<IdLocation>^web.DHCPE.HealthGuideD</IdLocation>
<IndexLocation>^web.DHCPE.HealthGuideI</IndexLocation>
<StreamLocation>^web.DHCPE.HealthGuideS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
