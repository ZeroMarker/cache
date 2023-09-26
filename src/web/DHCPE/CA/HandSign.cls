Class web.DHCPE.CA.HandSign Extends %CSP.Page [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	s action = $g(%request.Data("Action", 1), "")
	
	if (action="SaveSign")
	{
		d ..SaveSign()
	} else {
		w ""
	}
	
	Quit $$$OK
}

ClassMethod SaveSign()
{
	 
	 
	s $zt = "Error"
	s ^DHCPEtest("SaveSignInfo0")=1
	s CRM = $g(%request.Data("CRM", 1), "")
	s ^DHCPEtest("SaveSignInfo",CRM,1,$h)=CRM
	s algorithm = $g(%request.Data("Algorithm", 1), "")
	s ^DHCPEtest("SaveSignInfo",CRM,2,$h)=algorithm
	
	s bioFeature = ..getReqStream("BioFeature")
	s ^DHCPEtest("SaveSignInfo",CRM,3,$h)=bioFeature
	s eventCert = $g(%request.Data("EventCert", 1), "")
	s ^DHCPEtest("SaveSignInfo",CRM,4,$h)=eventCert
	s sigValue = $g(%request.Data("SigValue", 1), "")
	s ^DHCPEtest("SaveSignInfo",CRM,5,$h)=sigValue
	s tsValue = $g(%request.Data("TSValue", 1), "")
	s ^DHCPEtest("SaveSignInfo",CRM,6,$h)=tsValue
	s version = $g(%request.Data("Version", 1), "")
    s ^DHCPEtest("SaveSignInfo",CRM,7,$h)=version
	s signScript = ..getReqStream("SignScript")
	s ^DHCPEtest("SaveSignInfo",CRM,8,$h)=signScript
	s fingerprint = ..getReqStream("Fingerprint")
	s ^DHCPEtest("SaveSignInfo",CRM,9,$h)=fingerprint
	s HeaderImage = ..getReqStream("HeaderImage")
	s ^DHCPEtest("SaveSignInfo",CRM,10,$h)=HeaderImage
	s plainText = $g(%request.Data("PlainText", 1), "")
	s ^DHCPEtest("SaveSignInfo",CRM,11,$h)=plainText
	s Code = $g(%request.Data("Code", 1), "")
	s ^DHCPEtest("SaveSignInfo",1,CRM,$h)=CRM_"^"_algorithm_"^"_eventCert_"^"_sigValue_"^"_tsValue_"^"_version_"^"_bioFeature_"^"_signScript_"^"_fingerprint_"^"_plainText
	s ret = ..SaveSignInfo(CRM,Code, 
			algorithm, eventCert, sigValue, tsValue, version, bioFeature , 
			signScript, fingerprint, plainText,HeaderImage)
	s ^DHCPEtest("SaveSignInfo",2,CRM,$h)=CRM_"^"_algorithm_"^"_eventCert_"^"_sigValue_"^"_tsValue_"^"_version_"^"_bioFeature_"^"_signScript_"^"_fingerprint_"^"_plainText
			
	w "{""Value"":"""_ret_"""}"
	q	
Error	
	w "{""Err"":"""_$zerror_"""}"
	q
}

ClassMethod getReqStream(reqParamName) As %String
{
	s reqValue = $g(%request.Data(reqParamName,1),"")
	s reqStream = ##Class(%Library.GlobalCharacterStream).%New()
	q:(reqValue="") reqStream
	
	s clsReq = $e(reqValue,1,50)
	if ($f(clsReq,"CharacterStream")>1)
	{
		d reqStream.CopyFrom(reqValue)
	}
	else
	{
		d reqStream.Write(reqValue)
	}	
	q reqStream
}

/// 保存签名 信息
ClassMethod SaveSignInfo(CRM, Code, Algorithm, EventCert, SigValue, TSValue, Version As %String, BioFeature As %Stream, SignScript, FingerPrint As %Stream, PlainText As %String, HeaderImage As %Stream) As %String
{
	s dt= $h
	s log = ##Class(User.DHCPECAHandSignLog).%New()
	s log.IsValid = 1
	
	s log.CreatDate = $P(dt, "," , 1) 
	s log.CreatTime = $P(dt, "," , 2)
	s log.UpdateDate = $P(dt, "," , 1)
	s log.UpdateTime = $P(dt, "," , 2)
		
	s log.CRMID = CRM
	s log.Code = Code

	s log.Algorithm  = Algorithm 
	//s log.BioFeature  = BioFeature
	//d log.BioFeature.Write(BioFeature)
	d log.BioFeature.CopyFrom(BioFeature)
	s log.EventCert  = EventCert 
	s log.SigValue  = SigValue  
	s log.TSValue  = TSValue  
	s log.Version = Version
	
	//s log.SignScript  = SignScript
	//s log.FingerPrint  = FingerPrint
	//d log.SignScript.Write(SignScript)
	//d log.FingerPrint.Write(FingerPrint)	 
	d log.SignScript.CopyFrom(SignScript)
	d log.FingerPrint.CopyFrom(FingerPrint)	
	d log.HeaderImage.CopyFrom(HeaderImage)	
	s log.PlainText  = PlainText  

	s sc=log.%Save()
	if $$$ISERR(sc)
	{
	 	q "-1"
	}
	q log.%Id()
}

/// 根据代码 姓名 项目信息 获取签名数据
/// ##Class(web.DHCPE.CA.HandSign).GetInfoByCode()
ClassMethod GetInfoByCode(Code, Name As %String = "", Items As %String = "", CRMID As %String = "")
{
	s Date=$zd(+$H,3)
	i (Name="")&&(CRMID'="") d
	.
	.s PreIBI=$p(^DHCPEPreIADM(CRMID),"^",1)
	.s Name=$p(^DHCPEPreIBI(PreIBI),"^",2)
	s ID=$o(^User.DHCPEHandSignMassageI("CodeIndex",Code,0))
	q:(ID="") ""
	s Title=$lg(^User.DHCPEHandSignMassageD(ID),3)
	s Massage=$lg(^User.DHCPEHandSignMassageD(ID),4)
	s Massage=$replace(Massage,"[Name]",Name)
	s Massage=$replace(Massage,"[Date]",Date)
	s Massage=$replace(Massage,"[Items]",Items)
	s ret=Title_":"_Massage
	
	q ret
}

ClassMethod RecordInfo(ID, Str)
{
	s ^DHCPERecord("RecordSign",ID,$H)=Str
	q 0
}

/// 根据代码 姓名 项目信息 获取签名数据
/// ##Class(web.DHCPE.CA.HandSign).GetMsgByCode(03,"","",677166)
ClassMethod GetMsgByCode(Code, Name As %String = "", Items As %String = "", CRMID As %String = "")
{
	//w CRMID_"CRMID"
	s Date=$zd(+$H,3)
	i (Name="")&&(CRMID'="") d
	.
	.s PreIBI=$p(^DHCPEPreIADM(CRMID),"^",1)
	.s Name=$p(^DHCPEPreIBI(PreIBI),"^",2)
	s ID=$o(^User.DHCPEHandSignMassageI("CodeIndex",Code,0))
	q:(ID="") ""
	s Title=$lg(^User.DHCPEHandSignMassageD(ID),3)
	s Massage=$lg(^User.DHCPEHandSignMassageD(ID),4)
	s Massage=$replace(Massage,"[Name]",Name)
	s Massage=$replace(Massage,"[Date]",Date)
	s Massage=$replace(Massage,"[Items]",Items)
	s ret=Massage
	q ret
}

/// /根据adm code获取签名笔迹信息
/// ##Class(web.DHCPE.CA.HandSign).GetSignScript(602589,"01")
ClassMethod GetSignScript(CRMADM, Code)
{
	s ID=$o(^User.DHCPECAHandSignLogI("TypeADMIndex",Code," "_CRMADM,""),-1)
	b ;1
	q:(ID="") ""
	s obj=##Class(User.DHCPECAHandSignLog).%OpenId(ID)
	//EMRinstance.AnySignLog
	s sign=obj.SignScript
	b ;2
	//s Stream = ##Class(%Library.GlobalCharacterStream).%New()
	s length=sign.SizeGet()
	d sign.Rewind()
	s ret=sign.Read(length)
	q ret
}

/// /输出签名笔迹
/// //// d ##Class(web.DHCPE.CA.HandSign).OutSignScript(602589,"01")
ClassMethod OutSignScript(CRMADM, Code)
{
	//w CRMADM_"CRMADM"
	s Sign=..GetSignScript(CRMADM,Code)
	q:(Sign="") ""
	//<img src='data:image/png;base64,"_AuditSignName_"'/>
	w "<img src='data:image/png;base64,"_Sign_"'/>"
}

ClassMethod OutSignScriptNew(CRMADM, Code)
{
	
	s Sign=..GetSignScript(CRMADM,Code)
	q:(Sign="") ""
	q "<img src='data:image/png;base64,"_Sign_"'/>"
}

ClassMethod Test(str)
{
	s ^DHCPETest("test1")=str
	q 0
}

/// 乙肝知情同意书
Query SearchPreIADM(DateBegin As %String = "", DateEnd As %String = "") As %Query(ROWSPEC = "CRM, TRegNo:%String, TName:%String, TDate:%String:%String")
{
}

ClassMethod SearchPreIADMExecute(ByRef qHandle As %Binary, DateBegin As %String = "", DateEnd As %String = "") As %Status
{

	Set repid=$I(^CacheTemp)
	if (""=DateBegin)||(DateEnd="") {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s ind=1
	///^User.DHCPECAHandSignLogI("DateTypeIndex",65141,"03",7)=""
	s Date=DateBegin-1
 	f  s Date=$O(^User.DHCPECAHandSignLogI("DateTypeIndex",Date)) q:(Date="")||(Date>DateEnd)  d
 	.s ID=0
 	.f  s ID=$o(^User.DHCPECAHandSignLogI("DateTypeIndex",Date,"03",ID)) q:(ID="")  d
 	..s CRM=$lg(^User.DHCPECAHandSignLogD(ID),4)
 	..s PreIBI=$p($g(^DHCPEPreIADM(CRM)),"^",1)
 	..q:(PreIBI="")
 	..s Reg=$p(^DHCPEPreIBI(PreIBI),"^",1)
 	..s Name=$p(^DHCPEPreIBI(PreIBI),"^",2)
 	..s outDate=$zd(Date,3)
 	..d FindBuild
 	
 	
	
	
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
GetPIADMInfo
	
FindBuild   
	set Data=$lb($g(CRM), Reg, Name, outDate)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SearchPreIADMFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchPreIADMExecute ]
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

ClassMethod SearchPreIADMClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchPreIADMExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetCRMADMAndNameByPAADM(PAADM)
{
	q:(PAADM="") ""
	s IADM=$o(^DHCPEIADM(0,"PAADM",PAADM,0))
	s CRMADM=$p(^DHCPEIADM(IADM),"^",4)
	s PreIBI=$p(^DHCPEPreIADM(CRMADM),"^",1)
	s Name=$p(^DHCPEPreIBI(PreIBI),"^",2)
	q CRMADM_"^"_Name
}

ClassMethod GetCRMADMByRPTID(RPTID)
{
	q:(RPTID="") ""
	s IADM=$p(^DHCPERPT(RPTID),"^",1)
	s CRMADM=$p(^DHCPEIADM(IADM),"^",4)
	
	q CRMADM
}

ClassMethod UpGbl()
{
	s ^DHCPECTDataEx("HandSign","YGHadKnow")=^DHCPEDataExCT("YGHadKnowDetail")
	q 0
}

/// 功能：获取乙肝同意知情书详情
ClassMethod GetYGHadKnowDetail()
{
	q $g(^DHCPECTDataEx("HandSign","YGHadKnow"))
}

}
