Import sqluser

/// Descript:	供应商相关
/// Creater:	tsr
/// CreateDate: 2018-08-09
Class web.DHCSTMHUI.APCVenNew Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

Parameter AppName [ Final ] = "DHCSTVENDORMTM";

/// Descript:	查询供应商信息
/// Creator: 	tsr
/// CreatDate: 	2018-08-09
/// Table: 		APC_Vendor
/// Input: 		Params对象-供应商代码,供应商名称,状态,分类,中间商标志
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.APCVenNew","APCVendor",^templxt("vendor"))
Query APCVendor(Params As %String) As Query(ROWSPEC = "RowId:%Integer,VendorCat,VendorCode,VendorDesc,City,Zip,Tel,ContPerson,CtrlAcct,CrLimit:%Float,CrAvail:%Float,LstPoDate,ShName,Fax,Grading,President,PresidentCard,PresidentTel,Registration,Status,CreditTerm,LstBsDate,Alias") [ SqlProc ]
{
}

ClassMethod APCVendorExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s pRowId=PJObj.%Get("RowId")
	s pVendorCode=PJObj.%Get("VendorCode")
	s pVendorDesc=PJObj.%Get("VendorDesc")
	s pStatus=PJObj.%Get("Status")
	s pVendorCat=PJObj.%Get("VendorCat")
	s gHospId=PJObj.%Get("gHospId")
	s pHospId=PJObj.%Get("BDPHospital")
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	s VendorByHosp=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue("DHCSTCOMMONM","VendorByHosp","")	//是否按医院过滤供应商
	s StkType=..sssCode()
	
	s SqlStr="SELECT APCVM_RowId, APCVM_Code, APCVM_Name, APCVM_Addr, APCVM_City_DR,"
		_"APCVM_State_DR, APCVM_Zip_DR, APCVM_Tel, APCVM_ContPerson, APCVM_Type,"
		_"APCVM_CtrlAcct_DR, APCVM_CrLimit, APCVM_Category_DR, APCVM_CrAvail, APCVM_LstPoDate,"
		_"APCVM_ShName, APCVM_Fax, APCVM_Grading, APCVM_President,"
		_"APCVM_Registration, APCVM_Status, APCVM_CreditTerm_DR, APCVM_LstBsDate"
		_" FROM SQLUser.APC_Vendor"
		_" WHERE 1=1"
	i pStatus'="" d
	.s SqlStr=SqlStr_" AND APCVM_Status ='"_pStatus_"'"
	i pRowId'="" d
	.s SqlStr=SqlStr_" AND APCVM_RowId IN ("_pRowId_")"
	i pVendorDesc'="" d
	.s pVendorDesc=$$ALPHAUP^SSUTIL4(pVendorDesc)
	s xrs=##class(%Library.ResultSet).%New()
	d xrs.RuntimeModeSet(0)
	d xrs.Prepare(SqlStr)
	s sc=xrs.Execute()
	i $$$ISERR(sc) q $$$OK
	while (xrs.Next())
	{
		s RowId=xrs.Data("APCVM_RowId")
		s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("APC_Vendor",RowId,pHospId)
		continue:ShowDataFlag'="Y"
		s STV=$o(^DHCSTV(0,RowId,0))
		s Type=xrs.Data("APCVM_Type")
		CONTINUE:Type'=StkType
		s VendorCat=xrs.Data("APCVM_Category_DR")
		CONTINUE:(pVendorCat'="")&&(pVendorCat'=VendorCat)
		s VendorCat=$s(VendorCat'="":$p(^APC("APCVC",VendorCat),"^",3),1:"")
		s VendorCode=xrs.Data("APCVM_Code")
		s VendorDesc=xrs.Data("APCVM_Name")
		s STVAlias=$p(^DHCSTV(STV),"^",46)
		s pVendorDesc=$$ALPHAUP^SSUTIL4(pVendorDesc)
		continue:(pVendorDesc'="")&&(($$ALPHAUP^SSUTIL4(VendorDesc)'[pVendorDesc)
			&&($$ALPHAUP^SSUTIL4(VendorCode)'[pVendorDesc)
			&&($$ALPHAUP^SSUTIL4(STVAlias)'[pVendorDesc))
		s City=xrs.Data("APCVM_City_DR")
		s Country=xrs.Data("APCVM_State_DR")
		s Zip=xrs.Data("APCVM_Zip_DR")
		s Tel=xrs.Data("APCVM_Tel")
		s ContPerson=xrs.Data("APCVM_ContPerson")
		s CtrlAcct=xrs.Data("APCVM_CtrlAcct_DR")
		s CrLimit=xrs.Data("APCVM_CrLimit")
		s CrAvail=xrs.Data("APCVM_CrAvail")
		s LstPoDate=xrs.Data("APCVM_LstPoDate")
		s:LstPoDate'="" LstPoDate=..DL2H(LstPoDate)
		s ShName=xrs.Data("APCVM_ShName")
		s Fax=xrs.Data("APCVM_Fax")
		s Grading=xrs.Data("APCVM_Grading")
		s xPresident=xrs.Data("APCVM_President")
		s President=$p(xPresident,"||",1)
		s PresidentCard=$p(xPresident,"||",2)
		s PresidentTel=$p(xPresident,"||",3)
		s Registration=xrs.Data("APCVM_Registration")
		s Status=xrs.Data("APCVM_Status")
		s CreditTerm=xrs.Data("APCVM_CreditTerm_DR")
		s LstBsDate=xrs.Data("APCVM_LstBsDate")
		s:LstBsDate'="" LstBsDate=..DL2H(LstBsDate)
		s Alias=##class(web.DHCSTMHUI.Common.AppCommon).GetCNCODE(VendorDesc,4)
		d OutPutRow 
	}
	d xrs.Close()
	Quit $$$OK
OutPutRow
	s Data=$lb(RowId,VendorCat,VendorCode,VendorDesc,City,Zip,Tel,ContPerson,CtrlAcct,CrLimit,CrAvail,LstPoDate,ShName,Fax,Grading,President,PresidentCard,PresidentTel,Registration,Status,CreditTerm,LstBsDate,Alias)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	根据Id查询供应商信息
/// Creator: 	tsr
/// CreatDate: 	2018-08-09
/// Table: 		APC_Vendor
/// Input: 		供应商Id
/// w ##class(web.DHCSTMHUI.APCVenNew).Select(568)
ClassMethod Select(Vendor As %String) As %Library.String
{
	n (Vendor)
	s $ZT=..sssError()
	q:Vendor="" ""
	q:'$d(^APC("APCVM",Vendor)) ""
	s VendorCode=$p(^APC("APCVM",Vendor),"^",2)
	s VendorDesc=$p(^APC("APCVM",Vendor),"^",3)
	s Tel=$p(^APC("APCVM",Vendor),"^",7)
	s ConPerson=$p(^APC("APCVM",Vendor),"^",8)	//开户行
	s CtrlAcct=$p(^APC("APCVM",Vendor),"^",10)	//账户
	s CrLimit=$p(^APC("APCVM",Vendor),"^",11)	//信贷限额采购额
	s Fax=$p(^APC("APCVM",Vendor),"^",15)		//传真
	s (President,PresidentCard,PresidentTel)=""
	s xPresident=$p(^APC("APCVM",Vendor),"^",16)
	s President=$p(xPresident,"||",1)			//法人
	s PresidentCard=$p(xPresident,"||",2)		//法人身份证
	s PresidentTel=$p(xPresident,"||",3)		//法人电话
	s Status=$p(^APC("APCVM",Vendor),"^",18)	//状态
	s (ApcInfo,CategoryId,CrAvail,LstPoDate,LstBsDate)=""
	i $d(^APC("APCVM",Vendor,1)) d
	.s ApcInfo=^APC("APCVM",Vendor,1)
	.s CategoryId=$p(ApcInfo,"^",1)
	.s CrAvail=$p(ApcInfo,"^",2) //注册资金
	.s LstPoDate=$p(ApcInfo,"^",6) //合同截止日期
	.s:LstPoDate'="" LstPoDate=..DL2H(LstPoDate)
	.s LstBsDate=$p(ApcInfo,"^",13)						//最后业务日期
	.s:LstBsDate'="" LstBsDate=..DL2H(LstBsDate)
	s Category=$s(CategoryId'="":$p($G(^APC("APCVC",CategoryId)),"^",3),1:"")	//分类
	s Address=..GetAddress(Vendor)
	s Registration=$p(^APC("APCVM",Vendor),"^",17)						//统一社会信用码
	s STV=$o(^DHCSTV(0,Vendor,0))
	s (SalesName,ProxyValidDate,SalesTel,ParVendor,Abbrev,SalesID,Email,ParVendorName,SalesCarrTel,STVBarcode,Sms,
	PurchPlat,Alias,VendorAlias,BankLicApprovalNo,BankLicNo,BusinessTerm,EstablishedDate,VendorEmail,
	CoRenameFlag,CarryFlag,RegAddress,ResponsiblePerson,QualityManager,DepotAddress,MatCatOfficial,
	MatCatOfficialDesc,SocialCreditExpDate,SalesFax)=""
	i STV'=""  d
	.s SalesName=$p(^DHCSTV(STV),"^",32)				//业务员姓名
	.s ProxyValidDate=$p(^DHCSTV(STV),"^",33)			//业务员授权书有效期
	.s:ProxyValidDate'="" ProxyValidDate=..DL2H(ProxyValidDate)
	.s SalesTel=$p(^DHCSTV(STV),"^",34)					//业务员电话
	.s ParVendor=$p(^DHCSTV(STV),"^",36)				//上一级供应商
	.s Abbrev=$p(^DHCSTV(STV),"^",37)					//简称
	.s SalesID=$p(^DHCSTV(STV),"^",38)					//业务员身份证号
	.s Email=$p(^DHCSTV(STV),"^",39)					//业务员邮箱
	.s ParVendorName=$s(ParVendor'="":$p(^APC("APCVM",ParVendor),"^",3),1:"")
	.s SalesCarrTel=$p(^DHCSTV(STV),"^",40)				//配送手机号
	.s STVBarcode=$p(^DHCSTV(STV),"^",42)
	.s Sms=$p(^DHCSTV(STV),"^",43) ;
	.s PurchPlat=$p(^DHCSTV(STV),"^",44)
	.s Alias=$p(^DHCSTV(STV),"^",46)
	.s VendorAlias=$p(Alias,"/",1)						//助记码
	.s BankLicApprovalNo=$p(^DHCSTV(STV),"^",50)
	.s BankLicNo=$p(^DHCSTV(STV),"^",51)
	.s BusinessTerm=$p(^DHCSTV(STV),"^",52)
	.s:BusinessTerm'="" BusinessTerm=..DL2H(BusinessTerm)
	.s EstablishedDate=$p(^DHCSTV(STV),"^",53)
	.s:EstablishedDate'="" EstablishedDate=..DL2H(EstablishedDate)
	.s VendorEmail=$p(^DHCSTV(STV),"^",54)
	.s CoRenameFlag=$p(^DHCSTV(STV),"^",55)
	.s CarryFlag=$p(^DHCSTV(STV),"^",56)
	.s RegAddress=$p(^DHCSTV(STV),"^",57)
	.s ResponsiblePerson=$p(^DHCSTV(STV),"^",58)
	.s QualityManager=$p(^DHCSTV(STV),"^",59)
	.s DepotAddress=$p(^DHCSTV(STV),"^",60)
	.s MatCatOfficial=$p(^DHCSTV(STV),"^",78)
	.s MatCatOfficialDesc=$s(MatCatOfficial'="":$p(^DHCMCO(MatCatOfficial),"^",2),1:"")
	.s SocialCreditExpDate=$p(^DHCSTV(STV),"^",79)
	.s SalesFax=$p(^DHCSTV(STV),"^",80)
	s Data=Vendor_"^"_VendorCode_"^"_VendorDesc_"^"_Tel_"^"_ConPerson_"^"_CtrlAcct_"^"_CrLimit_"^"_Fax_"^"_President_"^"_PresidentCard
		_"^"_Status_"^"_CategoryId_"^"_Category_"^"_CrAvail_"^"_LstPoDate_"^"_Address
		_"^"_SalesName_"^"_ProxyValidDate_"^"_SalesTel_"^"_SalesID
		_"^"_ParVendor_"^"_ParVendorName_"^"_Abbrev_"^"_PresidentTel_"^"_Email_"^"_SalesCarrTel_"^"_Sms_"^"_PurchPlat_"^"_STVBarcode
		_"^"_LstBsDate_"^"_VendorAlias_"^"_BankLicApprovalNo_"^"_BankLicNo_"^"_BusinessTerm
		_"^"_EstablishedDate_"^"_VendorEmail_"^"_CoRenameFlag_"^"_CarryFlag
		_"^"_RegAddress_"^"_ResponsiblePerson_"^"_QualityManager_"^"_DepotAddress
		_"^"_MatCatOfficial_"^"_SalesFax
	
	s Title="RowId^VendorCode^VendorDesc^Tel^Bank^CtrlAcct^CrLimit^Fax^President^PresidentCard"
		_"^Status^CategoryId^VendorCat^CrAvail^LstPoDate^Address"
		_"^SalesName^ProxyValidDate^SalesTel^SalesCard"
		_"^ParVendor^ParVendorName^Abbrev^PresidentTel^SalesEmail^SalesCarrTel^SMSFlag^PurchPlatFlag^BarCode"
		_"^LstBsDate^VendorAlias^BankLicApprovalNo^BankLicNo^BusinessTerm"
		_"^EstablishedDate^VendorEmail^RenameFlag^CarryFlag"
		_"^RegAddress^ResponsiblePerson^QualityManager^DepotAddress"
		_"^MatCatOfficial^SalesFax"
	s BasicData=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	
	q "{""success"":""0"",""BasicData"":"_BasicData_"}"
}

/// Descript:	取供应商地址信息
/// Creater:	ZhangDongmei
/// CreateDate: 2012-05-14
/// Table:		APC_Vendor
/// Input:		供应商Id
/// Return:		地址
ClassMethod GetAddress(Vendor As %String) As %Library.String
{
	n (Vendor)
	s chl=0
	s ret=""
	f  s chl=$o(^APC("APCVM",Vendor,"ADDR",chl)) q:chl=""  d
	.s address=^APC("APCVM",Vendor,"ADDR",chl)
	.i ret="" d
	..s ret=address
	.e  d
	..s ret=ret_address
	.
	q ret
}

/// Descript:	保存供应商信息
/// Creater:	tsr
/// CreateDate: 2018-08-20
/// Table:		APC_Vendor,DHC_STVendor
/// Input:		
/// Return:		
/// w ##class(web.DHCSTMHUI.APCVenNew).Save(^templxt("Basic"),^templxt("Check"),^templxt("SalesMan"))
ClassMethod Save(Basic As %String, Check As %String, SalesMan As %String = "") As %Library.String
{
	n (Basic,Check,SalesMan,%session)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	
	s Sc=PJObj.%FromJSON(Basic)
	i Sc'=0 d RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	
	s GroupId=PJObj.%Get("gGroupId")
	s UserId=PJObj.%Get("gUserId")
	s LocId=PJObj.%Get("gLocId")
	s gHospId=PJObj.%Get("gHospId")
	s pHospId=PJObj.%Get("BDPHospital")
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)

	s RowId=PJObj.%Get("RowId")
	s VendorCode=PJObj.%Get("VendorCode")
	s VendorDesc=PJObj.%Get("VendorDesc")
	i VendorDesc="" d RtnObj.Err(-2,"","供应商名称不能为空!","",0)
	q:RtnObj.success'=0 RtnObj.Json()
	
	s AppName=..%GetParameter("AppName")
	i VendorCode="" d
	.s VendorCode=##class(web.DHCSTMHUI.Common.AppCommon).GetAppNo(AppName,"","",pHospId)
	i VendorCode="" d RtnObj.Err(-3,"","供应商代码不能为空!","",0)
	q:RtnObj.success'=0 RtnObj.Json()
	
	s Param=GroupId_"^"_LocId_"^"_UserId_"^"_pHospId
	s CodeAlphaUp=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppName,"CodeAlphaUp",Param)
	s NameAlphaUp=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppName,"NameAlphaUp",Param)
	i CodeAlphaUp=1 d
	.s VendorCode=$$ALPHAUP^SSUTIL4(VendorCode)
	i NameAlphaUp=1 d
	.s VendorDesc=$$ALPHAUP^SSUTIL4(VendorDesc)

	s Tel=PJObj.%Get("Tel")
	s VendorCat=PJObj.%Get("VendorCat")
	s Fax=PJObj.%Get("Fax")
	s VendorEmail=PJObj.%Get("VendorEmail")
	s Abbrev=PJObj.%Get("Abbrev")
	s Address=PJObj.%Get("Address")
	s President=PJObj.%Get("President")
	s PresidentCard=PJObj.%Get("PresidentCard")
	s PresidentTel=PJObj.%Get("PresidentTel")
	s President=President_"||"_PresidentCard_"||"_PresidentTel
	s CtrlAcct=PJObj.%Get("CtrlAcct")
	s CrAvail=PJObj.%Get("CrAvail")
	s CrLimit=PJObj.%Get("CrLimit")
	s Bank=PJObj.%Get("Bank")
	s BankLicApprovalNo=PJObj.%Get("BankLicApprovalNo")
	s BankLicNo=PJObj.%Get("BankLicNo")
	s BarCode=PJObj.%Get("BarCode")
	s EstablishedDate=PJObj.%Get("EstablishedDate")
	s:EstablishedDate'="" EstablishedDate=..DH2L(EstablishedDate)
	s LstPoDate=PJObj.%Get("LstPoDate")
	s:LstPoDate'="" LstPoDate=..DH2L(LstPoDate)
	s BusinessTerm=PJObj.%Get("BusinessTerm")
	s:BusinessTerm'="" BusinessTerm=..DH2L(BusinessTerm)
	s LstBsDate=PJObj.%Get("LstBsDate")
	s:LstBsDate'="" LstBsDate=..DH2L(LstBsDate)
	s VendorAlias=PJObj.%Get("VendorAlias")
	s Status=PJObj.%Get("Status")
	s ResponsiblePerson=PJObj.%Get("ResponsiblePerson")
	s DepotAddress=PJObj.%Get("DepotAddress")
	s QualityManager=PJObj.%Get("QualityManager")
	s RegAddress=PJObj.%Get("RegAddress")
	
	s Sc=PJObj.%FromJSON(Check)
	i Sc'=0 d RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()

	s SMSFlag=PJObj.%Get("SMSFlag")
	s PurchPlatFlag=PJObj.%Get("PurchPlatFlag")
	s CarryFlag=PJObj.%Get("CarryFlag")
	s RenameFlag=PJObj.%Get("RenameFlag")

	i BarCode'="" d		//高值条码前缀判断
	.s TmpId=##class(web.DHCSTMHUI.APCVenNew).CheckVendor("BARCODE",BarCode,RowId,pHospId)
	.i (TmpId'="") d RtnObj.Err(-3,"",BarCode_"条码前缀重复!","",0)
	q:RtnObj.success'=0 RtnObj.Json()
	
	s HospMsg=""
	s TableType=##class(web.DHCSTMHUI.MatForBDPData).GetTableType("APC_Vendor")
	i TableType="C" s HospMsg="该数据属于管控类型数据,请联系相关人员进行授权!"
	s TmpId=##class(web.DHCSTMHUI.APCVenNew).CheckVendor("CODE",VendorCode,RowId,pHospId)
	i (TmpId'="") d RtnObj.Err(-3,"",VendorCode_"代码重复!"_HospMsg,"",0)
	q:RtnObj.success'=0 RtnObj.Json()
	s TmpId=##class(web.DHCSTMHUI.APCVenNew).CheckVendor("DESC",VendorDesc,RowId,pHospId)
	i (TmpId'="") d RtnObj.Err(-4,"",VendorDesc_"名称重复!"_HospMsg,"",0)
	q:RtnObj.success'=0 RtnObj.Json()
	s StkType=..sssCode()
	s VendorAlias=$$ALPHAUP^SSUTIL4(VendorAlias)
	s Alias=..MakeVenAlias(VendorCode,VendorDesc,VendorAlias)	//生成供应商别名
	
	s MemoDelim=##class(web.DHCSTMHUI.Common.UtilCommon).MemoDelim()
	s Address=$lfs(Address,MemoDelim)

	d ..sssSetLogID()
	tstart
	s stvid=""
	;1.保存供应商基本信息(含附加表信息)
	i RowId="" d
	.s VenObj=##class(User.APCVendor).%New()
	.s VenObj.APCVMType=StkType
	.s NewVendorFlag="Y"
	.s LogType="A"		;日志记录使用
	.s OldJsonStr=""
	e  d
	.s VenObj=##class(User.APCVendor).%OpenId(RowId)
	.s NewVendorFlag="N"
	.s stvid=..CheckSTVId(RowId)
	.s lastCode=$p(^APC("APCVM",RowId),"^",2)
	.s lastName=$p(^APC("APCVM",RowId),"^",3)
	.s oStatus=$p(^APC("APCVM",RowId),"^",18)
	.i (oStatus="S")&&(Status="A") s LstBsDate=+$h
	.
	.s LogType="U"
	.s OldJsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("APC_Vendor",RowId)

	s VenObj.APCVMCode=VendorCode
	s VenObj.APCVMName=VendorDesc
	s VenObj.APCVMTel=Tel
	s VenObj.APCVMContPerson=Bank
	s VenObj.APCVMCtrlAcctDR=CtrlAcct
	s VenObj.APCVMCrLimit=CrLimit
	d VenObj.APCVMCategoryDRSetObjectId(VendorCat)
	s VenObj.APCVMCrAvail=CrAvail
	s VenObj.APCVMLstPoDate=LstPoDate
	s VenObj.APCVMFax=Fax
	s VenObj.APCVMPresident=President
	s VenObj.APCVMShName=VendorDesc
	s VenObj.APCVMStatus=Status
	s VenObj.APCVMLstBsDate=LstBsDate
	;s VenObj.APCVMRegistration=Registration
	d VenObj.APCVMAddr.Clear()
	d VenObj.APCVMAddr.InsertList(Address)
	s Sc=VenObj.%Save()
	i $$$ISERR(Sc) tro  q RtnObj.Err(-7,RowId,VendorDesc_"主表保存失败!").Json()
	s RowId=VenObj.%Id()

	;新建供应商时,自动生成类组授权数据
	i NewVendorFlag="Y" d
	.s ScgStr=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr(UserId,StkType,LocId,"",pHospId)
	.//供应商类组授权
	.s RtnObj=##class(web.DHCSTMHUI.ApcCatGroup).SaveVendorAuthor(RowId,ScgStr)
	.i RtnObj.success<0 d RtnObj.Err(-71,"",VendorDesc_"类组授权失败!")
	
	s sd=$p($h,",",1),ed=$p($h,",",1)
	i stvid'="" d
	.&sql(update DHC_STVendor_History set STVH_EndDate=:ed where STVH_RowId=:stvid)
	.i SQLCODE'=0 d RtnObj.Err(-12,RowId,lastName_"供应商历史表处理失败:"_SQLCODE)
	i RtnObj.success<0 tro  q RtnObj.Json()
	&sql(Insert into DHC_STVendor_History
		(STVH_Vendor_DR,STVH_StartDate,STVH_Code,STVH_Name)
		values
		(:RowId,:sd,:VendorCode,:VendorDesc)
		)
	i SQLCODE'=0 d RtnObj.Err(-12,RowId,lastName_"供应商历史表处理失败:"_SQLCODE)
	i RtnObj.success<0 tro  q RtnObj.Json()
	
	;1.2 记录附加表信息	
	s STV=$o(^DHCSTV(0,RowId,0))
	i (STV'="")&&(NewVendorFlag="Y") d
	.s STV=""
	.&sql(delete from DHC_STVendor where STV_Vendor_DR=:RowId)
	.i SQLCODE'=0 d RtnObj.Err(-9,RowId,VendorDesc_"附加表历史数据删除失败!"_SQLCODE)
	i RtnObj.success'=0 tro  q RtnObj.Json()
	
	i STV="" d
	.s STVObj=##class(User.DHCSTVendor).%New()
	.d STVObj.STVVendorDRSetObjectId(RowId)
	.s STVObj.STVType=StkType
	.;d STVObj.STVHospitalDRSetObjectId(pHospId)  //利用公共方法判断表属性保存，不在此处保存
	.s STVLogType="A"		;日志记录状态
	.s STVOldJsonStr=""
	e  d
	.s STVObj=##class(User.DHCSTVendor).%OpenId(STV)
	.s STVLogType="U"
	.s STVOldJsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_STVendor",STV)
	s STVObj.STVAbbrev=Abbrev
	s STVObj.STVExpdtBySms=SMSFlag						;短信通知
	s STVObj.STVExpdtByPurchPlat=PurchPlatFlag			;平台通知
	s STVObj.STVAlias=Alias								;别名
	s STVObj.STVBarCode=BarCode							;高值前缀
	s STVObj.STVBankLicApprovalNo=BankLicApprovalNo		;许可证核准号
	s STVObj.STVBankLicNo=BankLicNo						;许可证号?
	s STVObj.STVBusinessTerm=BusinessTerm				;营业期限
	s STVObj.STVEstablishedDate=EstablishedDate			;成立日期
	s STVObj.STVVendorEmail=VendorEmail					;供应商邮箱
	s STVObj.STVCoRenameFlag=RenameFlag					;更名标记
	s STVObj.STVCarryFlag=CarryFlag						;转配送标记
	s STVObj.STVRegAddress=RegAddress					;注册地址
	s STVObj.STVResponsiblePerson=ResponsiblePerson		;企业负责人
	s STVObj.STVQualityManager=QualityManager			;质量管理人
	s STVObj.STVDepotAddress=DepotAddress				;仓库地址	
	s Sc=STVObj.%Save()
	i $$$ISERR(Sc) tro  q RtnObj.Err(-11,"",VendorDesc_"附加表更新失败!").Json()
	s STV=STVObj.%Id()
	
	s RtnObj=##class(Log).SaveLog("APC_Vendor","User.APCVendor","供应商信息",RowId,VendorDesc,LogType,"",OldJsonStr)
	i RtnObj.success'=0 tro  q RtnObj.Json()
	
	s RtnObj=##class(Log).SaveLog("DHC_STVendor","User.DHCSTVendor","供应商附加信息",STV,VendorDesc,STVLogType,"",STVOldJsonStr)
	i RtnObj.success'=0 tro  q RtnObj.Json()
	
	s ret=##class(web.DHCSTMHUI.MatForBDPData).SaveHOSP("APC_Vendor",RowId,pHospId)
	i +ret<0 d RtnObj.Err(-5,"",VendorDesc_"关联院区失败!")
	i RtnObj.success'=0 tro  q RtnObj.Json()
	
	tcommit
	d ..sssKillLogID()
	
	//同步供应商信息到平台
	d ##class(web.DHCSTMHUI.ServiceForSCI).getHopVendor(RowId)
	d ##class(web.DHCSTMHUI.ServiceForECS).saveSupDict(RowId,pHospId)
	d ##class(web.DHCSTMHUI.ServiceForLis).SynVendorInfo(RowId,pHospId)
	
	s RtnObj.rowid=RowId
	q RtnObj.Json()
}

/// Description:产生供应商别名
/// Creater:	tsr
/// CreateDate: 2018-08-20
/// Table:		
/// Input:		供应商代码,供应商名称,供应商助记码
/// Return:		别名串("/"分隔): "别名(助记码)/代码/名称/首拼/全拼"
ClassMethod MakeVenAlias(Code As %String, Name As %String, VendorAlias As %String) As %String
{
	n (Code,Name,VendorAlias)
	q:Name="" ""
	s VendorAlias=$$ALPHAUP^SSUTIL4(VendorAlias)
	s SPAlias=##class(web.DHCSTMHUI.Common.AppCommon).GetCNCODE(Name,4)
	s QPAlias=##class(web.DHCSTMHUI.Common.AppCommon).GetCNCODE(Name,3,"",50)
	s Alias=VendorAlias_"/"_Code_"/"_Name_"/"_SPAlias_"/"_QPAlias
	q Alias
}

/// Descript:   保存供应商地址信息
/// Creater:    tsr
/// CreateDate: 2018-08-20
/// Table:		APC_Vendor
/// Input:		地址,供应商id
ClassMethod SaveAddress(Address As %String, Vendor As %String) As %Library.String
{

	n (Address,Vendor)
	s Len=$l(Address,$c(13,10))
	k ^APC("APCVM",Vendor,"ADDR")
	s ^APC("APCVM",Vendor,"ADDR",0)=Len 
	f i=1:1:Len d
	.s ^APC("APCVM",Vendor,"ADDR",i)=$p(Address,$c(13,10),i) 
	.
	q
}

ClassMethod GetVendorAddPicType() As %String
{
	s AddType="salesLic^salsPhoto^salesID"
	s AddTypeDesc="业务员授权书^业务员照片^业务员身份证"
	q AddType_","_AddTypeDesc
}

ClassMethod GetVendorAddPicTypeDesc(Type As %String) As %String
{
	i Type="salesLic" q "业务员授权书"
	i Type="salsPhoto" q "业务员照片"
	i Type="salesID" q "业务员身份证"
	q ""
}

/// Description:根据图片类型获取资质名称
/// Creator:	tsr
/// CreatDate:	2018-09-20
ClassMethod TypeDesc(Type As %String) As %String
{
	n (Type)
	i Type="comLic" q "工商执照" 
	i Type="taxLic" q "税务登记证"
	i Type="orgCode" q "机构代码"
	i Type="drugBusLic" q "药品经营许可证"
	i Type="insBusLic" q "器械经营许可证"
	i Type="insProLic" q "器械生产许可证"
	i Type="legalComm" q "法人委托书"
	i Type="saleServComm" q "售后服务书"
	i Type="agentAuth" q "代理授权书"
	i Type="qualityComm" q "质量承诺书"
	i Type="Sanitation" q "卫生许可证"
	i Type="drugProLic" q "药品生产许可证"
	i Type="gspLic" q "GSP认证"
	i Type="insRegLic" q "器械注册证"
	i Type="inletRegLic" q "进口注册登记表"
	i Type="inletRLic" q "进口注册证"
	i Type="drugRegLic" q "药品注册批件"
	i Type="proPermitList" q "I类生产许可登记表"
	i Type="salesLic" q "业务员授权书"
	i Type="vendorAgreement" q "供应商协议"
	i Type="hospAllowed" q "入院审批材料"
	i Type="saOther" q "授权其他"
	i Type="saAuthorizLic" q "授权书"
	i Type="salesID" q "身份证复印件"
	i Type="salsPhoto" q "业务员照片"
	i Type="socialCreditComm" q "社会信用码"
	i Type="jurPersonID" q "法人身份证"
	i Type="secondInsBusLic" q "第二类医疗器械经营备案凭证"
	q Type
}

/// w ##class(web.DHCSTMHUI.APCVenNew).CheckSTVId(497)
ClassMethod CheckSTVId(VendorId) As %String
{
	n (VendorId)
	s stvendr="",startdate=""
	s startdate=$o(^DHCSTVH(0,"SDVend",VendorId,startdate),-1)
	q:startdate="" ""
	s stvendr=$o(^DHCSTVH(0,"SDVend",VendorId,startdate,stvendr),-1)
	q stvendr
}

/// w ##class(web.DHCSTMHUI.APCVenNew).CheckVendor("CODE","aa","506","2")
/// 判断供应商代码或名称是否重复，hospid为空时判断所有医院
ClassMethod CheckVendor(type, vlaue, OriRowId, HospId, StkType = "M")
{
	n (type,vlaue,OriRowId,HospId,StkType)
	s tableName="APC_Vendor"
	s ret=##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat(type,vlaue,tableName,HospId,OriRowId,StkType)
	q ret
}

/// w ##class(web.DHCSTMHUI.APCVenNew).GetVendorId("CODE","aa","")
/// 获取供应商id
ClassMethod GetVendorId(type, value, HospId, StkType = "M")
{
	n (type,value,HospId,StkType)
	s tableName="APC_Vendor"
	s ret=##class(web.DHCSTMHUI.MatForBDPData).CodeDescGetId(type, value, tableName, HospId, StkType)
	q ret
}

/// 供应商停用时判断该供应商是否存在库存
ClassMethod GetVendorStock(Vendor) As %String
{
	n (Vendor)
	s VendorStock="N"
	s Incib=""
	f  s Incib=$o(^DHCINCIB(0,"APCVM",Incib))  q:(Incib="")||(VendorStock="Y")  d
	.s InciId=+Incib
	.s NotUseFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetNotUseFlag(InciId)
	.q:NotUseFlag="Y"
	.s Incsc=$p(^INCI(InciId,2),"^",2)
	.q:Incsc=""
	.s IncscStkType=$p(^INC("SC",Incsc),"^",3)
	.q:IncscStkType'=..sssCode()
	.s DHCIncib=""
	.f  s DHCIncib=$o(^DHCINCIB(0,"APCVM",Incib,Vendor,DHCIncib))  q:(DHCIncib="")||(VendorStock="Y")  d
	..s Incilch=""
	..f  s Incilch=$o(^INCI("LB_IB",Incib,InciId,Incilch)) q:(Incilch="")||(VendorStock="Y")  d
	...s Incilbch=""
	...f  s Incilbch=$o(^INCI("LB_IB",Incib,InciId,Incilch,Incilbch))  q:(Incilbch="")||(VendorStock="Y")  d
	....s Incilb=InciId_"||"_Incilch_"||"_Incilbch
	....s Qty=##class(web.DHCSTMHUI.Common.DrugStkCommon).CurInclbAvaQty(Incilb,"")
	....s:Qty>0 VendorStock="Y"
	
	q VendorStock
}

}
