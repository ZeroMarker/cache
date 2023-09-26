Import sqluser

/// Descript:	经销商
/// Creator:	lxt
/// CreateDate: 2020-12-16
Class web.DHCSTMHUI.DHCDealer Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	查询经销商信息
/// Creator:	lxt
/// CreateDate:	2020-12-16
/// Table:		DHC_Dealer
/// Input:		查询条件
/// Return：	经销商信息
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCDealer","Query",^templxt("1111"))
Query Query(Params As %String) As Query(ROWSPEC = "RowId:%Integer,DealerCat,DealerCode,DealerDesc,City,Zip,Tel,ContPerson,CtrlAcct,CrLimit:%Float,CrAvail:%Float,LstPoDate,ShName,Fax,Grading,President,PresidentCard,PresidentTel,Registration,Status,CreditTerm,LstBsDate") [ SqlProc ]
{
}

ClassMethod QueryExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	
	s pRowId=PJObj.%Get("RowId")
	s pDealerCode=PJObj.%Get("DealerCode")
	s pDealerDesc=PJObj.%Get("DealerDesc")
	s pStatus=PJObj.%Get("Status")
	s pDealerCat=PJObj.%Get("DealerCat")
	s gHospId=PJObj.%Get("gHospId")
	s pHospId=PJObj.%Get("BDPHospital")
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	
	s SqlStr="SELECT DL_RowId, DL_Code, DL_Name, DL_Addr, DL_City_DR,"
		_"DL_State_DR, DL_Zip_DR, DL_Tel, DL_ContPerson,"
		_"DL_CtrlAcct_DR, DL_CrLimit, DL_Category_DR, DL_CrAvail, DL_LstPoDate,"
		_"DL_ShName, DL_Fax, DL_Grading, DL_President,"
		_"DL_Registration, DL_Status, DL_CreditTerm_DR, DL_LstBsDate"
		_" FROM DHC_Dealer where 1=1 "
	i pRowId'="" d
	.s SqlStr=SqlStr_" AND DL_RowId="_pRowId
	e  d
	.i pDealerDesc'="" d
	..s pDealerDesc=$$ALPHAUP^SSUTIL4(pDealerDesc)
	..s SqlStr=SqlStr_" AND (%ALPHAUP(DL_Name) LIKE '%"_pDealerDesc_"%' OR %ALPHAUP(DL_Code) LIKE '%"_pDealerDesc_"%')"
	.i pStatus'="" d
	..s SqlStr=SqlStr_" AND DL_Status ='"_pStatus_"'"

	s Result=##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	s sc=Result.Execute()
	i $$$ISERR(sc) q $$$OK
	while (Result.Next())
	{
		s RowId=Result.Data("DL_RowId")
		s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("DHC_Dealer",RowId,pHospId)
		continue:ShowDataFlag'="Y"
		s DealerCat=Result.Data("DL_Category_DR")
		CONTINUE:(pDealerCat'="")&&(pDealerCat'=DealerCat)
		s DealerCat=$s(DealerCat'="":$p(^APC("APCVC",DealerCat),"^",3),1:"")
		s DealerCode=Result.Data("DL_Code")
		s DealerDesc=Result.Data("DL_Name")
		s City=Result.Data("DL_City_DR")
		s Country=Result.Data("DL_State_DR")
		s Zip=Result.Data("DL_Zip_DR")
		s Tel=Result.Data("DL_Tel")
		s ContPerson=Result.Data("DL_ContPerson")
		s CtrlAcct=Result.Data("DL_CtrlAcct_DR")
		s CrLimit=Result.Data("DL_CrLimit")
		s CrAvail=Result.Data("DL_CrAvail")
		s LstPoDate=Result.Data("DL_LstPoDate")
		s:LstPoDate'="" LstPoDate=..DL2H(LstPoDate)
		s ShName=Result.Data("DL_ShName")
		s Fax=Result.Data("DL_Fax")
		s Grading=Result.Data("DL_Grading")
		s xPresident=Result.Data("DL_President")
		s President=$p(xPresident,"||",1)
		s PresidentCard=$p(xPresident,"||",2)
		s PresidentTel=$p(xPresident,"||",3)
		s Registration=Result.Data("DL_Registration")
		s Status=Result.Data("DL_Status")
		s CreditTerm=Result.Data("DL_CreditTerm_DR")
		s LstBsDate=Result.Data("DL_LstBsDate")
		s:LstBsDate'="" LstBsDate=..DL2H(LstBsDate)
		d OutPutRow 
	}
	d Result.Close()
	Quit $$$OK
OutPutRow
	s Data=$lb(RowId,DealerCat,DealerCode,DealerDesc,City,Zip,Tel,ContPerson,CtrlAcct,CrLimit,CrAvail,LstPoDate,ShName,Fax,Grading,President,PresidentCard,PresidentTel,Registration,Status,CreditTerm,LstBsDate)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	保存经销商信息
/// 对象类型数据
/// w ##class(web.DHCSTMHUI.DHCDealer).jsSave(^templxt("33"))
ClassMethod jsSave(Params As %String) As %String
{
	n (Params,%session)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..Save(Params)
	q RtnObj.Json()
}

/// Descript:	保存经销商信息
/// Creator:	lxt
/// CreateDate:	2020-12-16
/// Table:		DHC_Dealer
/// Input:		明细
/// Return：	成功，失败
ClassMethod Save(Params As %String) As RtnObj
{
	n (Params,%session)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 RtnObj.Err(-1,"","入参解析失败!")

	s gUserId=PJObj.%Get("gUserId")
	s gLocId=PJObj.%Get("gLocId")
	s gHospId=PJObj.%Get("gHospId")
	s pHospId=PJObj.%Get("BDPHospital")
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)

	s RowId=PJObj.%Get("RowId")
	s DealerCode=PJObj.%Get("DealerCode")
	s DealerDesc=PJObj.%Get("DealerDesc")
	q:DealerDesc="" RtnObj.Err(-2,"","经销商名称不能为空!","",0)
	
	i DealerCode="" d
	.s AppName=##class(web.DHCSTMHUI.APCVenNew).%GetParameter("AppName")
	.s DealerCode=##class(web.DHCSTMHUI.Common.AppCommon).GetAppNo(AppName,"","",pHospId)
	q:DealerCode="" RtnObj.Err(-3,"","经销商代码不能为空!","",0)
	
	s Tel=PJObj.%Get("Tel")
	s DealerCat=PJObj.%Get("DealerCat")
	s Fax=PJObj.%Get("Fax")
	s Email=PJObj.%Get("Email")
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
	s Alias=PJObj.%Get("Alias")
	s Status=PJObj.%Get("Status")
	s ResponsiblePerson=PJObj.%Get("ResponsiblePerson")
	s DepotAddress=PJObj.%Get("DepotAddress")
	s QualityManager=PJObj.%Get("QualityManager")
	s RegAddress=PJObj.%Get("RegAddress")
	s SMSFlag=PJObj.%Get("SMSFlag")
	s PurchPlatFlag=PJObj.%Get("PurchPlatFlag")
	s CarryFlag=PJObj.%Get("CarryFlag")
	s UniversalFlag=PJObj.%Get("UniversalFlag")
	s RenameFlag=PJObj.%Get("RenameFlag")

	i BarCode'="" d		//高值条码前缀判断
	.&sql(select %ID into :tmpDealerId from DHC_Dealer where DL_BarCode=:BarCode)
	.i (SQLCODE=0)&&(RowId'=tmpDealerId) d RtnObj.Err(-4,RowId,BarCode_"高值条码前缀已存在!","",0)
	q:RtnObj.success'=0 RtnObj
	
	s HospMsg=""
	s TableType=##class(web.DHCSTMHUI.MatForBDPData).GetTableType("DHC_Dealer")
	i TableType="C" s HospMsg="该数据属于管控类型数据,请联系相关人员进行授权!"
	s TmpId=##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat("CODE",DealerCode,"DHC_Dealer",pHospId,RowId)
	i (TmpId'="") d RtnObj.Err(-3,"",DealerCode_"代码重复!"_HospMsg,"",0)
	q:RtnObj.success'=0 RtnObj
	s TmpId=##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat("DESC",DealerDesc,"DHC_Dealer",pHospId,RowId)
	i (TmpId'="") d RtnObj.Err(-4,"",DealerDesc_"名称重复!"_HospMsg,"",0)
	q:RtnObj.success'=0 RtnObj
	
	s Alias=$$ALPHAUP^SSUTIL4(Alias)
	s Alias=##class(web.DHCSTMHUI.APCVenNew).MakeVenAlias(DealerCode,DealerDesc,Alias)	//生成供应商别名
	
	s MemoDelim=##class(web.DHCSTMHUI.Common.UtilCommon).MemoDelim()
	s Address=$lfs(Address,MemoDelim)

	d ..sssSetLogID()
	tstart
	i RowId="" d
	.s Obj=##class(User.DHCDealer).%New()
	.s LogType="A"		;日志记录使用
	.s OldJsonStr=""
	e  d
	.s Obj=##class(User.DHCDealer).%OpenId(RowId)
	.s lastCode=Obj.DLCode
	.s lastName=Obj.DLName
	.s lastStatus=Obj.DLStatus
	.i (lastStatus="S")&&(Status="A") s LstBsDate=+$h
	.s LogType="U"
	.s OldJsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_Dealer",RowId)
	s Obj.DLCode=DealerCode
	s Obj.DLName=DealerDesc
	s Obj.DLTel=Tel
	s Obj.DLContPerson=Bank
	s Obj.DLCtrlAcctDR=CtrlAcct
	s Obj.DLCrLimit=CrLimit
	d Obj.DLCategoryDRSetObjectId(DealerCat)
	s Obj.DLCrAvail=CrAvail
	s Obj.DLLstPoDate=LstPoDate
	s Obj.DLFax=Fax
	s Obj.DLPresident=President
	s Obj.DLShName=DealerDesc
	s Obj.DLStatus=Status
	s Obj.DLLstBsDate=LstBsDate
	d Obj.DLAddr.Clear()
	d Obj.DLAddr.InsertList(Address)
	s Obj.DLAbbrev=Abbrev
	s Obj.DLExpdtBySms=SMSFlag
	s Obj.DLExpdtByPurchPlat=PurchPlatFlag
	s Obj.DLAlias=Alias
	s Obj.DLBarCode=BarCode
	s Obj.DLBankLicApprovalNo=BankLicApprovalNo
	s Obj.DLBankLicNo=BankLicNo
	s Obj.DLBusinessTerm=BusinessTerm
	s Obj.DLEstablishedDate=EstablishedDate
	s Obj.DLEmail=Email
	s Obj.DLCoRenameFlag=RenameFlag
	s Obj.DLCarryFlag=CarryFlag
	s Obj.DLRegAddress=RegAddress
	s Obj.DLResponsiblePerson=ResponsiblePerson
	s Obj.DLQualityManager=QualityManager
	s Obj.DLDepotAddress=DepotAddress
	s Sc=Obj.%Save()
	i $$$ISERR(Sc) tro  q RtnObj.Err(-7,RowId,DealerDesc_"保存失败!")
	s RowId=Obj.%Id()
	s RtnObj=##class(Log).SaveLog("DHC_Dealer","User.DHCDealer","经销商信息",RowId,DealerDesc,LogType,"",OldJsonStr)
	i RtnObj.success'=0 tro  q RtnObj
	
	s ret=##class(web.DHCSTMHUI.MatForBDPData).SaveHOSP("DHC_Dealer",RowId,pHospId)
	i +ret<0 d RtnObj.Err(-5,"",DealerDesc_"关联院区失败!")
	i RtnObj.success'=0 tro  q RtnObj

	tcommit
	d ..sssKillLogID()
	
	s RtnObj.rowid=RowId
	q RtnObj
}

/// Descript:	根据Id查询经销商信息
/// Creator:	lxt
/// CreateDate:	2020-12-16
/// Table:		DHC_Dealer
/// Input: 		Id
/// w ##class(web.DHCSTMHUI.DHCDealer).Select(2)
ClassMethod Select(RowId As %String) As %Library.String
{
	n (RowId)
	s $ZT=..sssError()
	q:RowId="" ""
	
	s DealerData=^User.DHCDealerD(RowId)
	s DealerCode=$lg(DealerData,3)
	s DealerDesc=$lg(DealerData,4)
	s Tel=$lg(DealerData,9)
	s ConPerson=$lg(DealerData,10)	//开户行
	s CtrlAcct=$lg(DealerData,11)	//账户
	s CrLimit=$lg(DealerData,12)	//信贷限额采购额
	s Fax=$lg(DealerData,28)		//传真
	s xPresident=$lg(DealerData,30)
	s President=$p(xPresident,"||",1)			//法人
	s PresidentCard=$p(xPresident,"||",2)		//法人身份证
	s PresidentTel=$p(xPresident,"||",3)		//法人电话
	s Status=$lg(DealerData,32)	//状态
	s DealerCat=""
	s DealerCatId=$lg(DealerData,16)
	s:DealerCatId'="" DealerCat=$p(^APC("APCVC",DealerCatId),"^",3)	//分类
	s DealerCat=..sssComboStr(DealerCatId,DealerCat)
	s CrAvail=$lg(DealerData,17) //注册资金
	s LstPoDate=$lg(DealerData,21) //合同截止日期
	s:LstPoDate'="" LstPoDate=..DL2H(LstPoDate)
	s LstBsDate=$lg(DealerData,34)						//最后业务日期
	s:LstBsDate'="" LstBsDate=..DL2H(LstBsDate)
	s Address=$lg(DealerData,5)
	s Address=$LTS(Address,..sssMemoDelim())
	s Vendor=""
	s VendorId=$lg(DealerData,39)				//供应商
	s:VendorId'="" Vendor=$p(^APC("APCVM",VendorId),"^",3)
	s Vendor=..sssComboStr(VendorId,Vendor)
	s ParDealer=""
	s ParDealerId=$lg(DealerData,40)
	s:ParDealerId'="" ParDealer=$lg(^User.DHCDealerD(ParDealerId),4)
	s ParDealer=..sssComboStr(ParDealerId,ParDealer)
	s Abbrev=$lg(DealerData,41)					//简称
	s Barcode=$lg(DealerData,43)
	s Sms=$lg(DealerData,44)
	s PurchPlat=$lg(DealerData,45)
	s Alias=$lg(DealerData,47)
	s Alias=$p(Alias,"/",1)						//助记码
	s BankLicApprovalNo=$lg(DealerData,49)
	s BankLicNo=$lg(DealerData,50)
	s BusinessTerm=$lg(DealerData,51)
	s:BusinessTerm'="" BusinessTerm=..DL2H(BusinessTerm)
	s EstablishedDate=$lg(DealerData,52)
	s:EstablishedDate'="" EstablishedDate=..DL2H(EstablishedDate)
	s Email=$lg(DealerData,42)
	s CoRenameFlag=$lg(DealerData,53)
	s CarryFlag=$lg(DealerData,54)
	s RegAddress=$lg(DealerData,63)
	s ResponsiblePerson=$lg(DealerData,55)
	s QualityManager=$lg(DealerData,56)
	s DepotAddress=$lg(DealerData,57)
	s MatCatOfficial=""
	s MatCatOfficialId=$lg(DealerData,59)
	s:MatCatOfficialId'="" MatCatOfficial=$p(^DHCMCO(MatCatOfficialId),"^",2)
	s MatCatOfficial=..sssComboStr(MatCatOfficialId,MatCatOfficial)
	
	s Data=RowId_"^"_DealerCode_"^"_DealerDesc_"^"_Tel_"^"_ConPerson_"^"_CtrlAcct_"^"_CrLimit_"^"_Fax_"^"_President_"^"_PresidentCard
	_"^"_PresidentTel_"^"_Status_"^"_DealerCat_"^"_CrAvail_"^"_LstPoDate_"^"_LstBsDate_"^"_Address_"^"_Vendor_"^"_ParDealer_"^"_Abbrev
	_"^"_Barcode_"^"_Sms_"^"_PurchPlat_"^"_Alias_"^"_BankLicApprovalNo_"^"_BankLicNo_"^"_BusinessTerm_"^"_EstablishedDate_"^"_Email_"^"_CoRenameFlag
	_"^"_CarryFlag_"^"_RegAddress_"^"_ResponsiblePerson_"^"_QualityManager_"^"_DepotAddress_"^"_MatCatOfficial
	
	s Title="RowId^DealerCode^DealerDesc^Tel^Bank^CtrlAcct^CrLimit^Fax^President^PresidentCard"
		_"^PresidentTel^Status^DealerCat^CrAvail^LstPoDate^LstBsDate^Address^Vendor^ParDealer^Abbrev"
		_"^BarCode^SMSFlag^PurchPlatFlag^Alias^BankLicApprovalNo^BankLicNo^BusinessTerm^EstablishedDate^Email^RenameFlag"
		_"^CarryFlag^RegAddress^ResponsiblePerson^QualityManager^DepotAddress^MatCatOfficial"
	s Rtn=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	
	q Rtn
}

}
