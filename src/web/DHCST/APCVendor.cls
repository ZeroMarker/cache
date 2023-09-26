Import sqluser

/// Descript:供应商相关
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-14
Class web.DHCST.APCVendor Extends (%RegisteredObject, StkTypeG) [ Not ProcedureBlock ]
{

Parameter TableName [ Final ] = "APC_Vendor";

/// Descript:   查询供应商信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-14
/// Table:APC_Vendor,DHC_STVendor
/// Input:开始行,一页显示列数,排序字段,排序方向(ASC,DESC),代码,名称,状态(S,A)
/// Output:     
/// Return：RowId^代码^名称^电话^分类^分类id^账户^注册资金^合同截止日期^传真^法人身份证^使用标志
/// d ##class(web.DHCST.APCVendor).Query("0","40","RowId","DESC","","","","2")
ClassMethod Query(Start As %Integer, Limit As %Integer, Sort As %String, Dir As %String, Code As %String, Name As %String, Status As %String, Hosp) As %String
{
    n (Code,Name,Start,Limit,Sort,Dir,Status,Hosp)
    //s ^YSJTMP("Query")=$Lb(Start,Limit,Sort,Dir,Code,Name,Status,Hosp)
    s count = 0
    s resultString = ""
    s type=..sssCode()
    s StrSql="select APCVM_RowId,APCVM_Code,APCVM_Name,"_
    "APCVM_Tel,APCVM_Category_DR,APCVM_Category_DR->APCVC_Desc,APCVM_CtrlAcct_DR,"_
    "APCVM_CrAvail,APCVM_LstPoDate,APCVM_Fax,APCVM_President,APCVM_Status,APCVM_Type"_
    " from APC_Vendor where APCVM_Code is not null"
    s OrderField="APCVM_RowId"
    s:Code'="" StrSql=StrSql_" and APCVM_Code like '%"_Code_"%'"
    s:Name'="" StrSql=StrSql_" and APCVM_Name like '%"_Name_"%'"
    s:Status'="" StrSql=StrSql_" and APCVM_Status = '"_Status_"'"
    s:Sort="Code" OrderField="APCVM_Code"
    s:Sort="Name" OrderField="APCVM_Name"
    s:Sort="Status" OrderField="APCVM_Status"
    ;
    s Dir=$$ALPHAUP^SSUTIL4(Dir)
    s:(Dir="")&(Dir'="ASC")&(Dir'="DESC") Dir="DESC"
    i OrderField'=""  d
    .s StrSql=StrSql_" order by "_OrderField_" "_Dir
    ;s ^zdm("Query_sql")=StrSql
    s json = ##class(Code.JsonObj).%New()
    ;
    s result = ##class(%Library.ResultSet).%New()
    d result.Prepare(StrSql)
    s sc=result.Execute()
    s err=$$$ISERR(sc)
    ;b ;2
    ;
    If err q ""
    ;b ;3
    s count = 0
    s resultString = ""
    s end = Start+Limit
    s json = ##class(Code.JsonObj).%New()
    ;
    While(result.Next())
    {   
        s Rowid = result.Data("APCVM_RowId")
        continue:##class(PHA.FACE.IN.Com).GetShowDataFlag(..#TableName,Rowid,Hosp)="N"
        s Universal=""
        s STV=$o(^DHCSTV(0,Rowid,""))
        s:STV'="" Universal=$p(^DHCSTV(STV),"^",49) ;通用标志
        s Type=result.Data("APCVM_Type")
        CONTINUE:(Universal'="Y")&&(Type'=type)
        s ApcCode = result.Data("APCVM_Code")
        s ApcName = result.Data("APCVM_Name")
        s Tel = result.Data("APCVM_Tel")
        s CategoryId=result.Data("APCVM_Category_DR")
        s Category = result.Data("APCVC_Desc")
        s CtrlAcct = result.Data("APCVM_CtrlAcct_DR")
        s CrAvail = result.Data("APCVM_CrAvail")
        s LstPoDate = result.Data("APCVM_LstPoDate")
        s:LstPoDate'="" LstPoDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(LstPoDate,"ST")
        s Fax = result.Data("APCVM_Fax")
        s President = result.Data("APCVM_President")
        s President=$p(President,"||",2)
        s ApcStatus = result.Data("APCVM_Status")
        i ApcStatus="Active" s ApcStatus="A"
        i ApcStatus="Suspended"  s ApcStatus="S"
        
        s Data1=Rowid_"^"_ApcCode_"^"_ApcName_"^"_Tel_"^"_Category_"^"_CategoryId_"^"_CtrlAcct
        s Data2=CrAvail_"^"_LstPoDate_"^"_Fax_"^"_President_"^"_ApcStatus
        s Data=Data1_"^"_Data2
        s count = count+1   
        CONTINUE:count<(Start+1)
        CONTINUE:count>end  
        d json.InsertRowData(Data)
    }
    d result.Close()
    s resultString = json.getJsonData("RowId^Code^Name^Tel^Category^CategoryId^CtrlAcct^CrAvail^LstPoDate^Fax^President^Status",count)
    k json
    Q resultString
}

/// Descript:查询某供应商明细
/// Creater:ZhangDongmei
/// CreateDate: 2012-05-14
/// Table:APC_Vendor,DHC_STVendor
/// Input:rowid
/// Output:     
/// Return：
/// w ##class(web.DHCST.APCVendor).Select(493)
ClassMethod Select(Rowid) As %Library.String
{

    n (Rowid)
    q:Rowid="" ""
    q:'$d(^APC("APCVM",Rowid)) ""
    ;
    s Code=$p(^APC("APCVM",Rowid),"^",2)
    s Name=$p(^APC("APCVM",Rowid),"^",3)
    s Tel=$p(^APC("APCVM",Rowid),"^",7)
    s ConPerson=$p(^APC("APCVM",Rowid),"^",8)   ;开户行
    s CtrlAcct=$p(^APC("APCVM",Rowid),"^",10)   ;账户
    s CrLimit=$p(^APC("APCVM",Rowid),"^",11)   ;信贷限额采购额
    s Fax=$p(^APC("APCVM",Rowid),"^",15)        ;传真
    s President=$p(^APC("APCVM",Rowid),"^",16)   ;法人
    s PresidentId=$p(President,"||",2)          ;法人身份证
    s President=$p(President,"||",1)
    s Status=$p(^APC("APCVM",Rowid),"^",18)         ;状态
    s CategoryId=$p($g(^APC("APCVM",Rowid,1)),"^",1)    ;分类id
    s:CategoryId'="" Category=$p($g(^APC("APCVC",CategoryId)),"^",3)
    s CrAvail=$p($g(^APC("APCVM",Rowid,1)),"^",2)   ;注册资金
    s LstPoDate=$p($g(^APC("APCVM",Rowid,1)),"^",6)   ;合同截止日期
    s:LstPoDate'="" LstPoDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(LstPoDate,"ST")
    s Address=..GetAddress(Rowid)
    s RCFlag=$p($g(^APC("APCVM",Rowid,1)),"^",11)   ;限制供应标志
    ;
    s STV=$o(^DHCSTV(0,Rowid,""))
    i STV'=""  d
    .q:'$d(^DHCSTV(STV))
    .s ComLic=$p(^DHCSTV(STV),"^",1)     ;工商执照
    .s ComLicDate=$p(^DHCSTV(STV),"^",2)
    .s:ComLicDate'="" ComLicDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(ComLicDate,"ST")
    .
    .s AgentLic=$p(^DHCSTV(STV),"^",3)    ;代理授权书
    .s DrugManLic=$p(^DHCSTV(STV),"^",4)    ;药品经营许可证
    .s DrugManLicDate=$p(^DHCSTV(STV),"^",5)    ;药品经营许可证有效期
    .s:DrugManLicDate'="" DrugManLicDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(DrugManLicDate,"ST")
    .s Gsp=$p(^DHCSTV(STV),"^",6)               ;GSP认证
    .s GspDate=$p(^DHCSTV(STV),"^",7)           ;GSP认证有效期
    .s:GspDate'="" GspDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(GspDate,"ST")
    .s ImportEnrol=$p(^DHCSTV(STV),"^",8)       ;进口注册证
    .s ImportEnrolDate=$p(^DHCSTV(STV),"^",9)    ;进口注册证有效期
    .s:ImportEnrolDate'="" ImportEnrolDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(ImportEnrolDate,"ST")
    .s ImportLic=$p(^DHCSTV(STV),"^",10)        ;进口注册登记表
    .s ImportLicDate=$p(^DHCSTV(STV),"^",11)        ;进口注册登记表有效期
    .s:ImportLicDate'="" ImportLicDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(ImportLicDate,"ST")
    .s MatEnrol=$p(^DHCSTV(STV),"^",12)     ;器械注册证
    .s MatEnrolDate=$p(^DHCSTV(STV),"^",13)     ;器械注册证有效期
    .s:MatEnrolDate'="" MatEnrolDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(MatEnrolDate,"ST")
    .s MatManLic=$p(^DHCSTV(STV),"^",14)        ;器械经营许可证
    .s MatManLicDate=$p(^DHCSTV(STV),"^",15)        ;器械经营许可证有效期
    .s:MatManLicDate'="" MatManLicDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(MatManLicDate,"ST")
    .
    .s MatPro=$p(^DHCSTV(STV),"^",16)       ;器械生产许可证
    .s MatProDate=$p(^DHCSTV(STV),"^",17)       ;器械生产许可证有效期
    .s:MatProDate'="" MatProDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(MatProDate,"ST")
    .s OrgCode=$p(^DHCSTV(STV),"^",18)      ;组织机构代码
    .s OrgCodeDate=$p(^DHCSTV(STV),"^",19)      ;组织机构有效期
    .s:OrgCodeDate'="" OrgCodeDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(OrgCodeDate,"ST")
    .s Promises=$p(^DHCSTV(STV),"^",20)     ;售后承诺服务书
    .s ProPermit=$p(^DHCSTV(STV),"^",21)        ;药品生产许可证
    .s ProPermitDate=$p(^DHCSTV(STV),"^",22)        ;药品生产许可证有效期
    .s:ProPermitDate'="" ProPermitDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(ProPermitDate,"ST")
    .s RevReg=$p(^DHCSTV(STV),"^",23)       ;税务登记
    .s RevRegDate=$p(^DHCSTV(STV),"^",24)       ;税务登记有效期
    .s:RevRegDate'="" RevRegDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(RevRegDate,"ST")
    .s Sanitation=$p(^DHCSTV(STV),"^",25)       ;药品注册批件
    .s SanitationDate=$p(^DHCSTV(STV),"^",26)       ;药品注册批件有效期
    .s:SanitationDate'="" SanitationDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(SanitationDate,"ST")
    .s TrustDeed=$p(^DHCSTV(STV),"^",27)        ;法人委托书
    .s Quality=$p(^DHCSTV(STV),"^",29)      ;质量承诺书
    .s AgentLicDate=$p(^DHCSTV(STV),"^",30)     ;代理授权书有效期
    .s:AgentLicDate'="" AgentLicDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(AgentLicDate,"ST")
    .s QualityDate=$p(^DHCSTV(STV),"^",31)      ;质量承诺书有效期
    .s:QualityDate'="" QualityDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(QualityDate,"ST")
    .s SalesName=$p(^DHCSTV(STV),"^",32)        ;业务员姓名
    .s SalesNameDate=$p(^DHCSTV(STV),"^",33)        ;业务员授权书有效期  
    .s:SalesNameDate'="" SalesNameDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(SalesNameDate,"ST")
    .s SalesTel=$p(^DHCSTV(STV),"^",34)     ;业务员电话
    .s Alias=$p(^DHCSTV(STV),"^",46)
    .s VendorAlias=$p(Alias,"/",1)		;第一部分为自行维护的助记码
    .s Universal=$p(^DHCSTV(STV),"^",49) ;通用标志
    ;
    s Data1=Code_"^"_Name_"^"_Tel_"^"_ConPerson_"^"_CtrlAcct_"^"_CrLimit_"^"_Fax
    s Data2=$g(President)_"^"_$g(PresidentId)_"^"_$g(Status)_"^"_$g(CategoryId)_"^"_$g(Category)_"^"_$g(CrAvail)_"^"_$g(LstPoDate)
    s Data3=$g(Address)_"^"_$g(RCFlag)_"^"_$g(ComLic)_"^"_$g(ComLicDate)_"^"_$g(AgentLic)_"^"_$g(DrugManLic)_"^"_$g(DrugManLicDate)
    s Data4=$g(Gsp)_"^"_$g(GspDate)_"^"_$g(ImportEnrol)_"^"_$g(ImportEnrolDate)_"^"_$g(ImportLic)_"^"_$g(ImportLicDate)
    s Data5=$g(MatEnrol)_"^"_$g(MatEnrolDate)_"^"_$g(MatManLic)_"^"_$g(MatManLicDate)_"^"_$g(MatPro)_"^"_$g(MatProDate)
    s Data6=$g(OrgCode)_"^"_$g(OrgCodeDate)_"^"_$g(Promises)_"^"_$g(ProPermit)_"^"_$g(ProPermitDate)_"^"_$g(RevReg)
    s Data7=$g(RevRegDate)_"^"_$g(Sanitation)_"^"_$g(SanitationDate)_"^"_$g(TrustDeed)_"^"_$g(Quality)_"^"_$g(QualityDate)
    s Data8=$g(AgentLicDate)_"^"_$g(SalesName)_"^"_$g(SalesNameDate)_"^"_$g(SalesTel)_"^"_$g(VendorAlias)_"^"_$g(Universal)
    s Data=Data1_"^"_Data2_"^"_Data3_"^"_Data4_"^"_Data5_"^"_Data6_"^"_Data7_"^"_Data8
    q $TR(Data,$c(13,10))
}

/// Descript:   取供应商地址信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-14
/// Table:APC_Vendor
/// Input:rowid
/// Output:     
/// Return：地址
ClassMethod GetAddress(rowid As %String) As %Library.String
{
    n (rowid)
    s chl=0
    s ret=""
    f  s chl=$o(^APC("APCVM",rowid,"ADDR",chl))  q:chl=""  d
    .s address=^APC("APCVM",rowid,"ADDR",chl)
    .i ret=""  d
    ..s ret=address
    .e  d
    ..s ret=ret_address
    .
    q ret
}

/// Descript:   增加供应商信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-14
/// Table:APC_Vendor,DHC_STVendor
/// Input:供应商代码^名称^电话^开户行^账户^采购限额^传真
/// ^法人^法人id^使用标志^分类id^注册资金^合同截止日期
/// ^地址^限制供应标志^工商执照^工商执照效期^代理授权书^药品许可证^药品许可证有效期
/// ^Gsp认证^Gsp认证有效期^进口注册证^进口注册证有效期^进口注册登记表^进口注册登记表有效期
/// ^器械注册证^器械注册证有效期^器械经营许可证^器械经营许可证有效期^器械生产许可证^器械生产许可证有效期
/// ^组织机构代码^组织机构有效期^售后服务承诺书^药品生产许可证^药品生产许可证有效期^税务登记
/// ^税务登记有效期^药品注册批件^药品注册批件有效期^法人委托书^质量承诺书^质量承诺书有效期
/// ^代理授权书有效期^业务员姓名^业务员授权书有效期^业务员电话
/// Output:     
/// Return：成功:rowid, 失败:"", -1:代码和名称不能为空，-2:代码不能重复，-3:名称不能重复
/// w ##class(web.DHCST.APCVendor).Save("M999946^长春供应^^^^^^^^A^^^^^N^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^N",2)
ClassMethod Save(listData As %String, hosp) As %Library.String
{
    n (listData,%session,hosp)
    s ^YSJTMP("Save")=listData
    ;不能为空项
    q:listData="" ""
    s Code=$p(listData,"^",1)
    q:Code="" ""  -1
    s Name=$p(listData,"^",2)
    q:Name="" "" -1
    s Tel=$p(listData,"^",3)
    s ConPerson=$p(listData,"^",4)
    s CtrlAcct=$p(listData,"^",5)
    s CrLimit=$p(listData,"^",6)
    s Fax=$p(listData,"^",7)
    s President=$p(listData,"^",8)
    s PresidentId=$p(listData,"^",9)
    s President=President_"||"_PresidentId
    s Status=$p(listData,"^",10)
    s CategoryId=$p(listData,"^",11)
    s CrAvail=$p(listData,"^",12)
    s LstPoDate=$p(listData,"^",13)
    s:LstPoDate'="" LstPoDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(LstPoDate)
    s Address=$p(listData,"^",14)
    s RCFlag=$p(listData,"^",15)
    s ComLic=$p(listData,"^",16)
    s ComLicDate=$p(listData,"^",17)
    s:ComLicDate'="" ComLicDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(ComLicDate)
    s AgentLic=$p(listData,"^",18)
    s DrugManLic=$p(listData,"^",19)
    s DrugManLicDate=$p(listData,"^",20)
    s:DrugManLicDate'="" DrugManLicDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(DrugManLicDate)
    s Gsp=$p(listData,"^",21)
    s GspDate=$p(listData,"^",22)
    s:GspDate'="" GspDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(GspDate)
    s ImportEnrol=$p(listData,"^",23)
    s ImportEnrolDate=$p(listData,"^",24)
    s:ImportEnrolDate'="" ImportEnrolDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(ImportEnrolDate)
    s ImportLic=$p(listData,"^",25)
    s ImportLicDate=$p(listData,"^",26)
    s:ImportLicDate'="" ImportLicDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(ImportLicDate)
    s MatEnrol=$p(listData,"^",27)
    s MatEnrolDate=$p(listData,"^",28)
    s:MatEnrolDate'="" MatEnrolDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(MatEnrolDate)
    s MatManLic=$p(listData,"^",29)
    s MatManLicDate=$p(listData,"^",30)
    s:MatManLicDate'="" MatManLicDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(MatManLicDate)
    s MatPro=$p(listData,"^",31)
    s MatProDate=$p(listData,"^",32)
    s:MatProDate'="" MatProDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(MatProDate)
    s OrgCode=$p(listData,"^",33)
    s OrgCodeDate=$p(listData,"^",34)
    s:OrgCodeDate'="" OrgCodeDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(OrgCodeDate)
    s Promises=$p(listData,"^",35)
    s ProPermit=$p(listData,"^",36)
    s ProPermitDate=$p(listData,"^",37)
    s:ProPermitDate'="" ProPermitDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(ProPermitDate)
    s RevReg=$p(listData,"^",38)
    s RevRegDate=$p(listData,"^",39)
    s:RevRegDate'="" RevRegDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(RevRegDate)
    s Sanitation=$p(listData,"^",40)
    s SanitationDate=$p(listData,"^",41)
    s:SanitationDate'="" SanitationDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(SanitationDate)
    s TrustDeed=$p(listData,"^",42)
    s Quality=$p(listData,"^",43)
    s QualityDate=$p(listData,"^",44)
    s:QualityDate'="" QualityDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(QualityDate)
    s AgentLicDate=$p(listData,"^",45)
    s:AgentLicDate'="" AgentLicDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(AgentLicDate)
    s SalesName=$p(listData,"^",46)
    s SalesNameDate=$p(listData,"^",47)
    s:SalesNameDate'="" SalesNameDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(SalesNameDate)
    s SalesTel=$p(listData,"^",48)
    s VendorAlias=$p(listData,"^",49)
    s Universal=$p(listData,"^",50)
    s tmpid=""
    s tmpid=..CheckCode(Code,Universal,hosp)
    q:+tmpid>0 -2 ;代码不能重复
    q:+tmpid=-1 -6	;代码已存在于物资
    q:+tmpid=-2 $p(tmpid,"^",2)
    s tmpid=..CheckDesc(Name,Universal,hosp)
    q:+tmpid>0 -3 ;名称不能重复
    q:+tmpid=-1 -7	;名称已存在于物资
    q:+tmpid=-2 $p(tmpid,"^",2)
	s Alias=VendorAlias_"/"_Code_"/"_Name_"/"_##class(web.DHCST.Common.AppCommon).GetCNCODE(Name)
    s Type=..sssCode()
    s Err=0
    tstart
    s $ZT="Error^DHCSTERROR"                        ;增加错误处理
    &sql(Insert into APC_Vendor(APCVM_Code,APCVM_Name,APCVM_Tel,APCVM_ContPerson,
    APCVM_Type,APCVM_CtrlAcct_DR,APCVM_CrLimit,APCVM_Category_DR,APCVM_CrAvail,
    APCVM_LstPoDate,APCVM_Fax,APCVM_President,APCVM_RcFlag,APCVM_ShName,APCVM_Status)
    values(:Code,:Name,:Tel,:ConPerson,:Type,:CtrlAcct,:CrLimit,:CategoryId,:CrAvail,
    :LstPoDate,:Fax,:President,:RCFlag,:Name,:Status))
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Save:APC_Vendor",Name,SQLCODE_":"_%msg)
    .s Err=-4
    i Err'=0 trollback
    q:Err'=0 ""
    s VendorId=$p(%ROWID,$c(1))
    d ..SaveAddress(Address,VendorId)
    &sql(Insert into DHC_STVendor(STV_Vendor_DR,STV_ComLic,STV_ComLicDate,STV_RevReg,
    STV_RevRegDate,STV_DrugManLic,STV_DrugManLicDate,STV_MatManLic,STV_MatManLicDate,
    STV_MatEnrol,STV_MatEnrolDate,STV_Sanitation,STV_SanitationDate,STV_OrgCode,STV_OrgCodeDate,
    STV_Gsp,STV_GspDate,STV_MatPro,STV_MatProDate,STV_ProPermit,STV_ProPermitDate,
    STV_ImportEnrol,STV_ImportEnrolDate,STV_ImportLic,STV_ImportLicDate,STV_AgentLic,
    STV_Promises,STV_TrustDeed,STV_Quality,STV_AgentLicDate,STV_QualityDate,STV_SalesName,
    STV_SalesDate,STV_SalesTel,STV_Type,STV_Alias,STV_Universal)
    values(:VendorId,:ComLic,:ComLicDate,:RevReg,:RevRegDate,:DrugManLic,:DrugManLicDate,
    :MatManLic,:MatManLicDate,:MatEnrol,:MatEnrolDate,:Sanitation,:SanitationDate,:OrgCode,:OrgCodeDate,
    :Gsp,:GspDate,:MatPro,:MatProDate,:ProPermit,:ProPermitDate,:ImportEnrol,:ImportEnrolDate,
    :ImportLic,:ImportLicDate,:AgentLic,:Promises,:TrustDeed,:Quality,:AgentLicDate,:QualityDate,
    :SalesName,:SalesNameDate,:SalesTel,:Type,:Alias,:Universal))
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Save:DHC_STVendor",Name,SQLCODE_":"_%msg)
    .s Err=-5
    i Err'=0 trollback
    q:Err'=0 ""
    tcommit
    d ##class(PHA.FACE.IN.Com).SaveBasicDataHosp(..#TableName, VendorId, hosp)
    s AppName="DHCSTCOMMON"
    s RecordTrace=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"RecordTraceFlag","")
    i RecordTrace="Y" d
    .s JsonStr=##class(web.DHCST.Common.JsonObj).GetValue("APC_Vendor",VendorId)
	.d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("APC_Vendor","User.APCVendor","供应商信息",VendorId,Name,"A",JsonStr)
	.s JsonStrCh=##class(web.DHCST.Common.JsonObj).GetValue("DHC_STVendor",$SYSTEM.SQL.GetROWID())
	.d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_STVendor","User.DHCSTVendor","供应商资质信息",$SYSTEM.SQL.GetROWID(),Name,"A",JsonStrCh)
    q VendorId
}

/// Descript:   更新供应商信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-14
/// Table:APC_Vendor,DHC_STVendor
/// Input:rowid^供应商代码^名称^电话^开户行^账户^采购限额^传真
/// ^法人^法人id^使用标志^分类id^注册资金^合同截止日期
/// ^地址^限制供应标志^工商执照^工商执照效期^代理授权书^药品许可证^药品许可证有效期
/// ^Gsp认证^Gsp认证有效期^进口注册证^进口注册证有效期^进口注册登记表^进口注册登记表有效期
/// ^器械注册证^器械注册证有效期^器械经营许可证^器械经营许可证有效期^器械生产许可证^器械生产许可证有效期
/// ^组织机构代码^组织机构有效期^售后服务承诺书^药品生产许可证^药品生产许可证有效期^税务登记
/// ^税务登记有效期^药品注册批件^药品注册批件有效期^法人委托书^质量承诺书^质量承诺书有效期
/// ^代理授权书有效期^业务员姓名^业务员授权书有效期^业务员电话
/// Output:     
/// Return：成功:0, 失败: -1:代码和名称和id不能为空，-2:代码不能重复，-3:名称不能重复,保存失败
/// 
ClassMethod Update(listData As %String, hosp) As %Library.String
{
    n (listData,%session,hosp)
    ;不能为空项
    q:listData="" -1
    s VendorId=$p(listData,"^",1)
    q:VendorId="" -1
    s Code=$p(listData,"^",2)
    q:Code="" ""  -1
    s Name=$p(listData,"^",3)
    q:Name="" "" -1
    s Tel=$p(listData,"^",4)
    s ConPerson=$p(listData,"^",5)
    s CtrlAcct=$p(listData,"^",6)
    s CrLimit=$p(listData,"^",7)
    s Fax=$p(listData,"^",8)
    s President=$p(listData,"^",9)
    s PresidentId=$p(listData,"^",10)
    s President=President_"||"_PresidentId
    s Status=$p(listData,"^",11)
    s CategoryId=$p(listData,"^",12)
    s CrAvail=$p(listData,"^",13)
    s LstPoDate=$p(listData,"^",14)
    s:LstPoDate'="" LstPoDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(LstPoDate)
    s Address=$p(listData,"^",15)
    s RCFlag=$p(listData,"^",16)
    s ComLic=$p(listData,"^",17)
    s ComLicDate=$p(listData,"^",18)
    s:ComLicDate'="" ComLicDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(ComLicDate)
    s AgentLic=$p(listData,"^",19)
    s DrugManLic=$p(listData,"^",20)
    s DrugManLicDate=$p(listData,"^",21)
    s:DrugManLicDate'="" DrugManLicDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(DrugManLicDate)
    s Gsp=$p(listData,"^",22)
    s GspDate=$p(listData,"^",23)
    s:GspDate'="" GspDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(GspDate)
    s ImportEnrol=$p(listData,"^",24)
    s ImportEnrolDate=$p(listData,"^",25)
    s:ImportEnrolDate'="" ImportEnrolDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(ImportEnrolDate)
    s ImportLic=$p(listData,"^",26)
    s ImportLicDate=$p(listData,"^",27)
    s:ImportLicDate'="" ImportLicDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(ImportLicDate)
    s MatEnrol=$p(listData,"^",28)
    s MatEnrolDate=$p(listData,"^",29)
    s:MatEnrolDate'="" MatEnrolDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(MatEnrolDate)
    s MatManLic=$p(listData,"^",30)
    s MatManLicDate=$p(listData,"^",31)
    s:MatManLicDate'="" MatManLicDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(MatManLicDate)
    s MatPro=$p(listData,"^",32)
    s MatProDate=$p(listData,"^",33)
    s:MatProDate'="" MatProDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(MatProDate)
    s OrgCode=$p(listData,"^",34)
    s OrgCodeDate=$p(listData,"^",35)
    s:OrgCodeDate'="" OrgCodeDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(OrgCodeDate)
    s Promises=$p(listData,"^",36)
    s ProPermit=$p(listData,"^",37)
    s ProPermitDate=$p(listData,"^",38)
    s:ProPermitDate'="" ProPermitDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(ProPermitDate)
    s RevReg=$p(listData,"^",39)
    s RevRegDate=$p(listData,"^",40)
    s:RevRegDate'="" RevRegDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(RevRegDate)
    s Sanitation=$p(listData,"^",41)
    s SanitationDate=$p(listData,"^",42)
    s:SanitationDate'="" SanitationDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(SanitationDate)
    s TrustDeed=$p(listData,"^",43)
    s Quality=$p(listData,"^",44)
    s QualityDate=$p(listData,"^",45)
    s:QualityDate'="" QualityDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(QualityDate)
    s AgentLicDate=$p(listData,"^",46)
    s:AgentLicDate'="" AgentLicDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(AgentLicDate)
    s SalesName=$p(listData,"^",47)
    s SalesNameDate=$p(listData,"^",48)
    s:SalesNameDate'="" SalesNameDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(SalesNameDate)
    s SalesTel=$p(listData,"^",49)
	s VendorAlias=$p(listData,"^",50)
	s Alias=VendorAlias_"/"_Code_"/"_Name_"/"_##class(web.DHCST.Common.AppCommon).GetCNCODE(Name)
	s Universal=$p(listData,"^",51)
    s tmpid=""
    s tmpid=..CheckCode(Code,Universal,hosp)
    q:(tmpid'="")&(tmpid'=VendorId) -2 ;代码不能重复
    
    s tmpid=..CheckDesc(Name,Universal,hosp)
    q:(tmpid'="")&(tmpid'=VendorId) -3 ;名称不能重复
    s OldJsonStr=##class(web.DHCST.Common.JsonObj).GetValue("APC_Vendor",VendorId)
    s Err=0
    tstart
    s $ZT="Error^DHCSTERROR"                        ;增加错误处理
    &sql(update APC_Vendor set APCVM_Code=:Code,APCVM_Name=:Name,APCVM_Tel=:Tel,
    APCVM_ContPerson=:ConPerson,APCVM_CtrlAcct_DR=:CtrlAcct,APCVM_CrLimit=:CrLimit,
    APCVM_Category_DR=:CategoryId,APCVM_CrAvail=:CrAvail,APCVM_LstPoDate=:LstPoDate,
    APCVM_Fax=:Fax,APCVM_President=:President,APCVM_RcFlag=:RCFlag,APCVM_ShName=:Name,APCVM_Status=:Status
     where APCVM_Rowid=:VendorId)

    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Update:APC_Vendor",Name,SQLCODE_":"_%msg)
    .s Err=-4
    i Err'=0 trollback
    q:Err'=0 -4
    d ..SaveAddress(Address,VendorId)
    s STV=$o(^DHCSTV(0,VendorId,""))
    //zhwh 2013-02-28 add
    if STV="" d
    .&sql(insert into DHC_STVendor (stv_vendor_dr) values(:VendorId) )
    .i SQLCODE'=0 s Err=-50
    i Err'=0 trollback
    q:Err'=0 -9
    //zhwh 2013-02-28 add
    s STV=$o(^DHCSTV(0,VendorId,""))
    i STV'=""  d
    .s OldJsonStrCh=##class(web.DHCST.Common.JsonObj).GetValue("DHC_STVendor",STV)
    .&sql(update DHC_STVendor set STV_ComLic=:ComLic,STV_ComLicDate=:ComLicDate,STV_RevReg=:RevReg,
    STV_RevRegDate=:RevRegDate,STV_DrugManLic=:DrugManLic,STV_DrugManLicDate=:DrugManLicDate,
    STV_MatManLic=:MatManLic,STV_MatManLicDate=:MatManLicDate,STV_MatEnrol=:MatEnrol,
    STV_MatEnrolDate=:MatEnrolDate,STV_Sanitation=:Sanitation,STV_SanitationDate=:SanitationDate,
    STV_OrgCode=:OrgCode,STV_OrgCodeDate=:OrgCodeDate,STV_Gsp=:Gsp,STV_GspDate=:GspDate,
    STV_MatPro=:MatPro,STV_MatProDate=:MatProDate,STV_ProPermit=:ProPermit,STV_ProPermitDate=:ProPermitDate,
    STV_ImportEnrol=:ImportEnrol,STV_ImportEnrolDate=:ImportEnrolDate,STV_ImportLic=:ImportLic,
    STV_ImportLicDate=:ImportLicDate,STV_AgentLic=:AgentLic,STV_Promises=:Promises,STV_TrustDeed=:TrustDeed,
    STV_Quality=:Quality,STV_AgentLicDate=:AgentLicDate,STV_QualityDate=:QualityDate,STV_SalesName=:SalesName,
    STV_SalesDate=:SalesNameDate,STV_SalesTel=:SalesTel,STV_Alias=:Alias,STV_Universal=:Universal where STV_Rowid=:STV)
    .i SQLCODE'=0  d
    ..s rett=$$ErrorRecord^DHCSTERROR("Update:DHC_STVendor",Name,SQLCODE_":"_%msg)
    ..s Err=-5
    .
    i Err'=0 trollback
    q:Err'=0 -5
    tcommit
    s AppName="DHCSTCOMMON"
    s RecordTrace=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"RecordTraceFlag","")
    i RecordTrace="Y" d
    .s JsonStr=##class(web.DHCST.Common.JsonObj).GetValue("APC_Vendor",VendorId)
	.d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("APC_Vendor","User.APCVendor","供应商信息",VendorId,Name,"U",JsonStr,OldJsonStr)
	.s JsonStrCh=##class(web.DHCST.Common.JsonObj).GetValue("DHC_STVendor",STV)
	.d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_STVendor","User.DHCSTVendor","供应商资质信息",STV,Name,"U",JsonStrCh,OldJsonStrCh)
    q 0
}

/// Descript:   保存供应商地址信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-15
/// Table:APC_Vendor
/// Input:地址,供应商id
/// Output:     
/// Return：
ClassMethod SaveAddress(add As %String, rowid As %String) As %Library.String
{

 n (add,rowid)
 s linenum=$l(add,$c(13,10))
 k ^APC("APCVM",rowid,"ADDR")
 s ^APC("APCVM",rowid,"ADDR",0)=linenum 
 f i=1:1:linenum d
 .s ^APC("APCVM",rowid,"ADDR",i)=$p(add,$c(13,10),i) 
 .
 q
}

/// Descript:检查供应商代码是否已经在药库中维护
/// Creater:    zhangxiao
/// CreateDate: 2013-02-21
/// Table:APC_Vendor
/// Input:代码
/// Output:     
/// Return：rowid-存在
/// 空-不存在
/// w ##class(web.DHCST.APCVendor).CheckCode("M99994","",2)
ClassMethod CheckCode(code As %String, universal As %String, hosp) As %Library.String
{
    n (code,universal,hosp)
    s (rowid,Type,Universal)=""
    s err=""
    s type=..sssCode()
    /*
    s sqlStr="SELECT APCVM_RowId AS rowID FROM APC_Vendor WHERE APCVM_Code='"_code_"'"
    s rowid=##class(PHA.COM.Method).IsSQLDataExist(sqlStr,..#TableName,hosp)
    q:rowid="" ""	;不存在
    &sql(select APCVM_Type into :Type from APC_Vendor where APCVM_RowId=:rowid)
    q:Type'=type 0
    */
    
    s tableName="APC_Vendor"
    s tmpAPCV="", rowid=""
    s code=$$ALPHAUP^SSUTIL4(code)
    f  s tmpAPCV=$O(^APC("APCVM",0,"APCVM_Code",code,tmpAPCV)) q:tmpAPCV=""  d
    .s tmpType=$P(^APC("APCVM",tmpAPCV) ,"^",9)
    .q:tmpType'=type
    .q:##class(PHA.FACE.IN.Com).GetShowDataFlag(tableName,tmpAPCV,hosp)="N"
    .s rowid=tmpAPCV
    q:rowid="" "" ;不存在
    
    s STV=$o(^DHCSTV(0,rowid,""))
    s:STV'="" Universal=$p(^DHCSTV(STV),"^",49) ;通用标志
	q:Universal="Y" rowid	;通用的,已存在
	//q:type=Type rowid	;类型相同,已存在
	i universal="Y" d
	.&sql(UPDATE DHC_STVendor SET STV_Universal=:universal WHERE STV_Vendor_DR=:rowid)
	.i SQLCODE=0 s err=-2_"^"_rowid
    q:err'="" err
    q rowid
}

/// Descript:检查供应商名称是否已经在药库中维护
/// Creater:    zhangxiao
/// CreateDate: 2013-02-21
/// Table:APC_Vendor
/// Input:名称
/// Output:     
/// Return：rowid-存在
/// 空-不存在
/// w ##class(web.DHCST.APCVendor).CheckDesc("长春供应","",2)
ClassMethod CheckDesc(desc As %String, universal As %String, hosp) As %String
{
    n (desc,universal,%session,hosp)
    s (rowid,Universal,Type)=""
    s err=""
    s type=..sssCode()
    /*
    s sqlStr="SELECT APCVM_RowId AS rowID FROM APC_Vendor WHERE APCVM_Name='"_desc_"'"
    s rowid=##class(PHA.COM.Method).IsSQLDataExist(sqlStr,..#TableName,hosp)
    q:rowid="" ""	;不存在
    &sql(select APCVM_Type into :Type from APC_Vendor where APCVM_RowId=:rowid)
    q:Type'=type 0
    */
    
    s tableName="APC_Vendor"
    s tmpAPCV="", rowid=""
    s desc=$$ALPHAUP^SSUTIL4(desc)
    f  s tmpAPCV=$O(^APC("APCVM",0,"APCVM_Name",desc,tmpAPCV)) q:tmpAPCV=""  d
    .s tmpType=$P(^APC("APCVM",tmpAPCV) ,"^",9)
    .q:tmpType'=type
    .q:##class(PHA.FACE.IN.Com).GetShowDataFlag(tableName,tmpAPCV,hosp)="N"
    .s rowid=tmpAPCV
    q:rowid="" "" ;不存在
    
    s STV=$o(^DHCSTV(0,rowid,""))
    s:STV'="" Universal=$p(^DHCSTV(STV),"^",49) ;通用标志
	q:Universal="Y" rowid	;通用的,已存在
	//q:type=Type rowid	;类型相同,已存在
	i universal="Y" d
	.&sql(UPDATE DHC_STVendor SET STV_Universal=:universal WHERE STV_Vendor_DR=:rowid)
	.i SQLCODE=0 s err=-2_"^"_rowid
    q:err'="" err
    q rowid
}

/// 插入新的供应商前检查判断是否允许插入
/// w ##class(web.DHCST.APCVendor).CheckVendorBeforeInsert("M99994^长春供应^^^^^^^^A^^^^^N^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^N",2)
ClassMethod CheckVendorBeforeInsert(listData, hosp)
{
	n (listData,hosp)
	//s ^YSJTMP("CheckVendorBeforeInsert")=listData
	s Code=$p(listData,"^",1)
    q:Code="" "-1^"_"供应商代码不能为空!"  
    s Name=$p(listData,"^",2)
    q:Name="" "-1^"_"供应商名称不能为空!" 
    s Universal=$p(listData,"^",50)
    s ret=..CheckVendorCode(Code,Universal,"",hosp)
    q:+ret<0 "-2^"_$p(ret,"^",2)
    q:+ret>0 "1^"_ret
    s ret=..CheckVendorDesc(Name,Universal,"",hosp)
    q:+ret<0 "-2^"_$p(ret,"^",2)
    q:+ret>0 "1^"_ret
    s ret="0^没有重复代码和名称"
    q ret
}

/// 更新通用标志
ClassMethod UpdateUniversal(rowid, updflag)
{
	n (rowid,updflag)
	//s ^YSJTMP("UpdateUniversal")=$LB(rowid, updflag)
	s Err=0
	TStart
	&sql(update APC_Vendor set APCVM_Status="A" where APCVM_Rowid=:rowid)
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("UpdateVendor:APC_Vendor",rowid,SQLCODE_":"_%msg)
    .s Err=-4
    i Err'=0 trollback
    q:Err'=0 "-1^"_"激活原有记录失败!"
    i updflag=1  d
	.s universal="Y"
	.&sql(UPDATE DHC_STVendor SET STV_Universal=:universal WHERE STV_Vendor_DR=:rowid)
	.i SQLCODE'=0  d
    ..s rett=$$ErrorRecord^DHCSTERROR("UpdateVendor:APC_Vendor",rowid,SQLCODE_":"_%msg)
    ..s Err=-4
    .i Err'=0 trollback
    q:Err'=0 "-1^"_"更新原有记录通用标志失败!"
    TCommit
	q Err
}

/// w ##class(web.DHCST.APCVendor).CheckVendorCode("M99994","N","521","2")
ClassMethod CheckVendorCode(code As %String, universal As %String, VendorId As %String = "", hosp) As %Library.String
{
    n (code,universal,VendorId,hosp)
    s (rowid,Type,Universal)=""
    s type=..sssCode()
    
    /*
    s sqlStr="SELECT APCVM_RowId AS rowID FROM APC_Vendor WHERE APCVM_Code='"_code_"'"
    s rowid=##class(PHA.COM.Method).IsSQLDataExist(sqlStr,..#TableName,hosp)
    q:rowid="" 0	;不存在
    &sql(select APCVM_Type into :Type from APC_Vendor where APCVM_RowId=:rowid)
    q:Type'=type 0
    */
    s tableName="APC_Vendor"
    s tmpAPCV="", rowid=""
    s code=$$ALPHAUP^SSUTIL4(code)
    f  s tmpAPCV=$O(^APC("APCVM",0,"APCVM_Code",code,tmpAPCV)) q:tmpAPCV=""  d
    .q:(VendorId'="")&&(VendorId=tmpAPCV)
    .s tmpType=$P(^APC("APCVM",tmpAPCV) ,"^",9)
    .q:tmpType'=type
    .q:##class(PHA.FACE.IN.Com).GetShowDataFlag(tableName,tmpAPCV,hosp)="N"
    .s rowid=tmpAPCV
    q:rowid="" 0 ;不存在
    
    
    //q:VendorId=rowid 0
    s STV=$o(^DHCSTV(0,rowid,""))
    s:STV'="" Universal=$p(^DHCSTV(STV),"^",49) ;通用标志
	q:Universal="Y" -1_"^"_rowid	;通用的,已存在
	//q:type=Type -1_"^"_rowid	;类型相同,已存在
	q rowid
}

/// w ##class(web.DHCST.APCVendor).CheckVendorDesc("HFH-火凤凰1")
ClassMethod CheckVendorDesc(desc As %String, universal As %String, VendorId As %String = "", hosp) As %String
{
    n (desc,universal,VendorId,hosp)
    s (rowid,Universal,Type)=""
    s err=-1
    s type=..sssCode()
    /*
    s sqlStr="SELECT APCVM_RowId AS rowID FROM APC_Vendor WHERE APCVM_Name='"_desc_"'"
    s rowid=##class(PHA.COM.Method).IsSQLDataExist(sqlStr,..#TableName,hosp)
    q:rowid="" 0	;不存在
    &sql(select APCVM_Type into :Type from APC_Vendor where APCVM_RowId=:rowid)
    q:rowid="" 0	;不存在
    */
    
    s tableName="APC_Vendor"
    s tmpAPCV="", rowid=""
    s desc=$$ALPHAUP^SSUTIL4(desc)
    f  s tmpAPCV=$O(^APC("APCVM",0,"APCVM_Name",desc,tmpAPCV)) q:tmpAPCV=""  d
    .q:(VendorId'="")&&(VendorId=tmpAPCV)
    .s tmpType=$P(^APC("APCVM",tmpAPCV),"^",9)
    .q:tmpType'=type
    .q:##class(PHA.FACE.IN.Com).GetShowDataFlag(tableName,tmpAPCV,hosp)="N"
    .s rowid=tmpAPCV
    q:rowid="" 0 ;不存在
    
    //q:Type'=type 0
    //q:VendorId=rowid 0
    s STV=$o(^DHCSTV(0,rowid,""))
    s:STV'="" Universal=$p(^DHCSTV(STV),"^",49) ;通用标志
	q:Universal="Y" -1_"^"_rowid	;通用的,已存在
	//q:type=Type -1_"^"_rowid	;类型相同,已存在
	q rowid
}

/// 更新前检查是否有重复记录
/// w ##class(web.DHCST.APCVendor).CheckVendorBeforeUpdate("1^AM00002^江苏润辉康尔医疗器械有限公司^^^^^^^^A^^^^^N^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^08/10/2018^^JSRHKEYLQXYXGS^Y")
ClassMethod CheckVendorBeforeUpdate(listData, hosp)
{
	n (listData,hosp)
	s VendorId=$p(listData,"^",1)
    q:VendorId="" "-1^"_"供应商ID不能为空!" 
    s Code=$p(listData,"^",2)
    q:Code="" "-1^"_"供应商代码不能为空!"  
    s Name=$p(listData,"^",3)
    q:Name="" "-1^"_"供应商名称不能为空!"  
    s Universal=$p(listData,"^",51)
    s ret=..CheckVendorCode(Code,Universal,VendorId,hosp)
    q:+ret<0 "-2^"_$p(ret,"^",2)
    q:+ret>0 "1^"_ret
    s ret=..CheckVendorDesc(Name,Universal,VendorId,hosp)
    q:+ret<0 "-2^"_$p(ret,"^",2)
    q:+ret>0 "1^"_ret
    s ret="0^没有重复代码和名称"
    q ret
}

/// 更新供应商记录
/// w ##class(web.DHCST.APCVendor).UpdateVendor("492^AM00029^AM00029^^^^^^^^A^^^^^N^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ZZFMSDSWKJYXGS^N","498","1")
ClassMethod UpdateVendor(listData, rowid, updateflag)
{
	n (listData,rowid,updateflag)
	s VendorId=$p(listData,"^",1)
    q:VendorId="" "-1^"_"供应商ID不能为空!"  
    s Code=$p(listData,"^",2)
    q:Code="" "-1^"_"供应商代码不能为空!"  
    s Name=$p(listData,"^",3)
    q:Name="" "-1^"_"供应商名称不能为空!"
    s Err=0
    Tstart
    s $ZT="Error^DHCSTERROR"                        ;增加错误处理
    &sql(update APC_Vendor set APCVM_Status="S" where APCVM_Rowid=:VendorId)
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("UpdateVendor:APC_Vendor",Name,SQLCODE_":"_%msg)
    .s Err=-4
    i Err'=0 trollback
    q:Err'=0 "-1^"_"作废本次修改记录失败!"
    &sql(update APC_Vendor set APCVM_Status="A" where APCVM_Rowid=:rowid)
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("UpdateVendor:APC_Vendor",Name,SQLCODE_":"_%msg)
    .s Err=-4
    i Err'=0 trollback
    q:Err'=0 "-1^"_"激活原有记录失败!"
    i updateflag=1  d
    .s universal="Y"
    .&sql(UPDATE DHC_STVendor SET STV_Universal=:universal WHERE STV_Vendor_DR=:rowid)
	.i SQLCODE'=0  d
    ..s rett=$$ErrorRecord^DHCSTERROR("UpdateVendor:APC_Vendor",Name,SQLCODE_":"_%msg)
    ..s Err=-4
    i Err'=0 trollback
    q:Err'=0 "-1^"_"更新原有记录通用标志失败!"
    TCommit
    q 0_"^"_"更新成功"
}

}
