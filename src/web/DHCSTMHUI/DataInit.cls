Import sqluser

Class web.DHCSTMHUI.DataInit Extends (%RegisteredObject, %XML.Adaptor, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	查询数据初始化信息
/// Creator:	lxt
/// CreateDate:	2021-12-27
/// Table:		CT_HRP_MAT.DataInitRecord
/// Input:		查询条件
/// Return：	
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DataInit","Query","")
Query Query(Params As %String) As Query(ROWSPEC = "RowId,Type,Name,Description,Date,Time,User,Hosp") [ SqlProc ]
{
}

ClassMethod QueryExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	
	k DataType
	s DataType($i(DataType))=$lb("App","应用程序","初始化应用程序会同时处理化单号规则、参数设置")
	s DataType($i(DataType))=$lb("CertType","证件类型","包含供应商、生产厂家资质类型，物资注册证、采购合同，及相应报警时间")
	s DataType($i(DataType))=$lb("GridSet","表格列设置","")
	s DataType($i(DataType))=$lb("ServiceConfig","接口信息","")
	s DataType($i(DataType))=$lb("InciParam","物资审核属性","")
	s DataType($i(DataType))=$lb("PrintRule","打印规则","")
	s DataType($i(DataType))=$lb("ComDictType","通用字典类型","包含字典类型及字典类型值")
	
	s i=0
	f  s i=$o(DataType(i)) q:(i="")  d
	.s data=DataType(i)
	.s Type=$list(data,1)
	.s Name=$list(data,2)
	.s Description=$list(data,3)
	.s (RowId,Date,Time,User)=""
	.s RowId=$o(^CT.HRP.MAT.DataInitRecordI("Type",Type,""),-1)
	.i RowId'="" d
	..s RecordData=^CT.HRP.MAT.DataInitRecordD(RowId)
	..s Date=$lg(RecordData,3)
	..s Time=$lg(RecordData,4)
	..s User=$lg(RecordData,5)
	..s Hosp=$lg(RecordData,6)
	..s:Date'="" Date=..DL2H(Date)
	..s:Time'="" Time=..TL2H(Time)
	..s:User'="" User=$p(^SSU("SSUSR",User),"^",2)
	..s:Hosp'="" Hosp=$p(^CT("HOSP",Hosp),"^",2)
	.d OutPutRow1
	Quit $$$OK
	
OutPutRow1
	s Data=$lb(RowId,Type,Name,Description,Date,Time,User,Hosp)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	前台调用初始化
/// 对象类型数据
/// w ##class(web.DHCSTMHUI.DataInit).jsInit(^templxt("jsInit"))
ClassMethod jsInit(Params As %String) As %String
{
	n (Params,%session)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	ts
	s RtnObj=..Init(Params)
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Descript:	初始化接口配置
/// Creator:	lxt
/// CreateDate:	2021-6-24
/// Table:		CT_HRP_MAT.DataInitRecord
/// Input:		InitFlag:"Y"首次初始化,"N"同步新增
/// Return：	成功，失败
ClassMethod Init(Params As %String) As RtnObj
{
	n (Params,%session)
	s RtnObj=##class(RtnObj).%New()
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	q:PJObj.%FromJSON(Params)'=0 RtnObj.Err(-1,"","入参解析失败!","",0)
	
	s gUserId=PJObj.%Get("gUserId")
	s gLocId=PJObj.%Get("gLocId")
	s gGroupId=PJObj.%Get("gGroupId")
	s gHospId=PJObj.%Get("gHospId")
	s HospStr=PJObj.%Get("BDPHospital")
	s Type=PJObj.%Get("Type")
	s InitFlag=PJObj.%Get("InitFlag")
	s:InitFlag="" InitFlag="N"
	s Date=+$h
	s Time=$p($h,",",2)
	s HospAutFlag=##class(web.DHCSTMHUI.MatForBDPData).GetHospAutFlag()
	i HospAutFlag="N" s HospStr=""
	
	i InitFlag="Y" d
	.s HospStr=""
	.s RowId=$o(^CT.HRP.MAT.DataInitRecordI("Type",Type,""),-1)
	.i RowId'="" d RtnObj.Err(-2,"","此模块仅允许首次部署系统进行初始化","",0)
	q:RtnObj.success'=0 RtnObj
	
	&sql(insert into CT_HRP_MAT.DataInitRecord(MATDIR_Type,MATDIR_Date,MATDIR_Time,MATDIR_User,MATDIR_Hosp) values (:Type,:Date,:Time,:gUserId,:HospStr))
	i SQLCODE'=0 d RtnObj.Err(-3,"","插入初始化记录失败","",0)
	q:RtnObj.success'=0 RtnObj
	
	i Type="App" d
	.s RtnObj=..InitApp(HospStr,InitFlag)
	.
	e  i Type="Counte" d
	.i InitFlag="Y" d RtnObj.Err(-2,"","不允许首次部署系统初始化","",0)
	.q:RtnObj.success'=0
	.s RtnObj=..InitCounte(HospStr,InitFlag)
	.
	e  i Type="CertType" d
	.s RtnObj=..InitCertType(HospStr,InitFlag)
	.
	e  i Type="GridSet" d
	.i InitFlag'="Y" d RtnObj.Err(-2,"","仅允许首次部署系统初始化","",0)
	.q:RtnObj.success'=0
	.s RtnObj=..InitGridSet()
	.
	e  i Type="ServiceConfig" d
	.s RtnObj=..InitServiceConfig(HospStr,InitFlag)
	.
	e  i Type="InciParam" d
	.s RtnObj=..InitInciParam(InitFlag)
	.
	e  i Type="PrintRule" d
	.s RtnObj=..InitPrintRule(InitFlag)
	.
	e  i Type="ComDictType" d
	.i InitFlag'="Y" d RtnObj.Err(-2,"","仅允许首次部署系统初始化","",0)
	.q:RtnObj.success'=0
	.s RtnObj=..InitComDictType(InitFlag)
	.
	
	q RtnObj
}

/// InitFlag:"Y" 首次初始化 包括：App、Param、Counte
ClassMethod InitApp(HospStr, InitFlag)
{
	n (HospStr,InitFlag,%session)
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	
	s:InitFlag="Y" HospStr=##class(web.DHCSTMHUI.MatForBDPData).GetDefHospStr("DHC_StkSysCounter")
	s Len=$l(HospStr,"^")
	s StkType=..sssCode()
	
	i InitFlag="Y" d
	.s parref=0
	.f  s parref=$o(^DHCSSA(parref)) q:(parref="")||(RtnObj.success'=0)  d
	..s type=$p(^DHCSSA(parref),"^",3)
	..q:type'=StkType
	..s ch=0
	..f  s ch=$o(^DHCSSA(parref,"SSC",ch))  q:(ch="")||(RtnObj.success'=0)  d
	...s RowId=parref_"||"_ch
	...s ret=##class(web.DHCSTMHUI.MatForBDPData).DeleteHospitals("DHC_StkSysCounter",RowId)
	...i ret<0 d RtnObj.Err(-1,"","删除单号关联失败！")
	.
	.s count=0
	.&sql(SELECT count(1) into :count FROM DHC_StkSysApp WHERE SSA_GrpType=:StkType)
	.q:count'>0
	.&sql(DELETE FROM DHC_StkSysApp WHERE SSA_GrpType=:StkType)
	.i SQLCODE'=0 d RtnObj.Err(-2,"","删除应用程序失败！")
	i RtnObj.success'=0 q RtnObj
	
	s RetStr=##class(web.DHCSTMHUI.Tools.CreateAppPara).Prop()
	s addcnt=$p(RetStr,"^",1)
	s updcnt=$p(RetStr,"^",2)
	s cnt=$p(RetStr,"^",3)
	i cnt'=(addcnt+updcnt) d RtnObj.Err(-3,"","初始化应用程序和参数设置失败！")
	i RtnObj.success'=0 q RtnObj
	
	s RetStr=##class(web.DHCSTMHUI.Tools.CreateAppPara).ProCounter(HospStr)
	s failcun=$p(RetStr,"^",3)
	i failcun>0 d RtnObj.Err(-4,"","初始化参数规则失败！")

	q RtnObj
}

/// InitFlag:"Y" 首次初始化
ClassMethod InitCounte(HospStr, InitFlag) As RtnObj
{
	n (HospStr,InitFlag,%session)
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	
	s:InitFlag="Y" HospStr=##class(web.DHCSTMHUI.MatForBDPData).GetDefHospStr("DHC_StkSysCounter")
	s Len=$l(HospStr,"^")
	s StkType=..sssCode()
	
	i InitFlag="Y" d
	.s parref=0
	.f  s parref=$o(^DHCSSA(parref)) q:(parref="")||(RtnObj.success'=0)  d
	..s type=$p(^DHCSSA(parref),"^",3)
	..q:type'=StkType
	..s ch=0
	..f  s ch=$o(^DHCSSA(parref,"SSC",ch))  q:(ch="")||(RtnObj.success'=0)  d
	...s RowId=parref_"||"_ch
	...s ret=##class(web.DHCSTMHUI.MatForBDPData).DeleteHospitals("DHC_StkSysCounter",RowId)
	...i ret<0 d RtnObj.Err(-1,"","删除单号关联失败！")
	.
	.s count=0
	.&sql(SELECT count(1) into :count FROM DHC_StkSysCounter WHERE SSC_SSA_Parref->SSA_GrpType=:StkType)
	.q:count'>0
	.&sql(delete from DHC_StkSysCounter where SSC_SSA_Parref->SSA_GrpType=:StkType)
	.i SQLCODE'=0 d RtnObj.Err(-1,"","删除单号数据失败！")
	i RtnObj.success'=0 q RtnObj
	
	s RetStr=##class(web.DHCSTMHUI.Tools.CreateAppPara).ProCounter(HospStr)
	s failcun=$p(RetStr,"^",3)
	i failcun>0 d RtnObj.Err(-4,"","初始化参数规则失败！")

	q RtnObj
}

/// InitFlag:"Y" 首次初始化
ClassMethod InitCertType(HospStr, InitFlag) As RtnObj
{
	n (HospStr,InitFlag,%session)
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	
	//分组，代码，全称，简称，序号，是否展示
	k CERTTYPE
	//供应商
	s CERTTYPE($i(CERTTYPE))=$lb("Vendor","comLic","营业执照","营业执照",1,"Y")
	s CERTTYPE($i(CERTTYPE))=$lb("Vendor","insBusLic","器械经营许可证","经营许可",2,"Y")
	s CERTTYPE($i(CERTTYPE))=$lb("Vendor","secondBusLic","第二类医疗器械经营备案凭证","二类经营备案",3,"Y")
	s CERTTYPE($i(CERTTYPE))=$lb("Vendor","qualityComm","质量承诺书","质量承诺书",4,"Y")
	s CERTTYPE($i(CERTTYPE))=$lb("Vendor","legalComm","法人委托书","法人委托书",5,"Y")
	s CERTTYPE($i(CERTTYPE))=$lb("Vendor","saleServComm","售后服务书","售后服务书",6,"Y")
	s CERTTYPE($i(CERTTYPE))=$lb("Vendor","taxLic","税务登记证","税务登记证",7,"N")
	s CERTTYPE($i(CERTTYPE))=$lb("Vendor","orgCode","机构代码","机构代码",8,"N")
	
	//生产厂家
	s CERTTYPE($i(CERTTYPE))=$lb("Manf","comLic","营业执照","营业执照",1,"Y")
	s CERTTYPE($i(CERTTYPE))=$lb("Manf","insProLic","器械生产许可证","生产许可",2,"Y")
	s CERTTYPE($i(CERTTYPE))=$lb("Manf","firstProdLic","第一类医疗器械生产备案凭证","一类生产备案",3,"Y")
	s CERTTYPE($i(CERTTYPE))=$lb("Manf","steHeaLic","消毒产品生产企业卫生许可证","消毒卫生许可证",4,"Y")
	//s CERTTYPE($i(CERTTYPE))=$lb("Manf","prodEprsHygLic","生产企业卫生许可证","卫生许可",5,"Y")
	
	//库存项
	s CERTTYPE($i(CERTTYPE))=$lb("Inci","regCert","医疗器械注册证","注册证",1,"Y")
	s CERTTYPE($i(CERTTYPE))=$lb("Inci","contract","医院采购合同","采购合同",2,"Y")
	
	s:InitFlag="Y" HospStr=##class(web.DHCSTMHUI.MatForBDPData).GetDefHospStr("DHC_CertType")
	s Len=$l(HospStr,"^")
	s WarnDays=30		;缺省30天报警
	
	i InitFlag="Y" d
	.s ret=##class(web.DHCSTMHUI.MatForBDPData).DeleteHospitals("DHC_CertType")
	.i ret<0 d RtnObj.Err(-1,"","删除证件类型关联失败！")
	.s count=0
	.&sql(SELECT count(1) into :count FROM DHC_CertType)
	.q:count'>0
	.&sql(DELETE FROM DHC_CertType)
	.i SQLCODE'=0 d RtnObj.Err(-2,"","删除证件类型失败")
	i RtnObj.success'=0 q RtnObj
	
	s i=0
	f  s i=$o(CERTTYPE(i)) q:(i="")||(RtnObj.success'=0)  d
	.s data=CERTTYPE(i)
	.s type=$list(data,1)
	.s code=$list(data,2)
	.s fullname=$list(data,3)
	.s shortname=$list(data,4)
	.s num=$list(data,5)
	.s showflag=$list(data,6)
	.i HospStr="" d
	..s ExistFlag=$$CheckExistCertType(type,code,HospStr)
	..q:ExistFlag="Y"
	..&sql(insert into DHC_CertType(CT_Type,CT_Code,CT_FullName,CT_ShortName,CT_Num,
		CT_ShowFlag,CT_WarnDays) 
		values(:type,:code,:fullname,:shortname,:num,
		:showflag,:WarnDays))
	..i SQLCODE'=0 d RtnObj.Err(-3,"","重新生成证件类型失败")
	.e  d
	..f j=1:1:Len q:(RtnObj.success'=0)  d
	...s HospId=$p(HospStr,"^",j)
	...s ExistFlag=$$CheckExistCertType(type,code,HospId)
	...q:ExistFlag="Y"
	...&sql(insert into DHC_CertType(CT_Type,CT_Code,CT_FullName,CT_ShortName,CT_Num,
		CT_ShowFlag,CT_WarnDays) 
		values(:type,:code,:fullname,:shortname,:num,
		:showflag,:WarnDays))
	...i SQLCODE'=0 d RtnObj.Err(-4,"","重新生成证件类型失败")
	...s RowId=%ROWID
	...s ret=##class(web.DHCSTMHUI.MatForBDPData).SaveHOSP("DHC_CertType",RowId,HospId)
	...i ret'=0 d RtnObj.Err(-5,"","关联院区失败")
	
	q RtnObj
	
CheckExistCertType(type,code,HospId)
	s Flag="N"
	i HospId'="" d
	.s tmprowid=""
	.f  s tmprowid=$o(^User.DHCCertTypeI("TypeCode",type,code,tmprowid)) q:(tmprowid="")||(Flag="Y")  d
	..s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("DHC_CertType",tmprowid,HospId)
	..q:ShowDataFlag="N"
	..s Flag="Y"
	e  d
	.s cnt=0
	.&sql(select count(1) into :cnt from DHC_CertType where CT_Type=:type and CT_Code=:code)
	.s:cnt>0 Flag="Y"
	
	q Flag
}

/// 仅支持首次初始化
ClassMethod InitGridSet() As RtnObj
{
	n (%session)
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	
	s count=0
	&sql(select count(1) into :count from DHC_StkSysGridSet WHERE GS_SSA_ParRef->ssa_grptype='M')
	q:count'>0 RtnObj
	
	&sql(delete from DHC_StkSysGridSet WHERE GS_SSA_ParRef->ssa_grptype='M')
	i SQLCODE'=0 d RtnObj.Err(-3,"","初始化列设置失败！")
	
	q RtnObj
}

/// InitFlag:"Y" 首次初始化
ClassMethod InitServiceConfig(HospStr, InitFlag) As RtnObj
{
	n (HospStr,InitFlag,%session)
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	
	s TypeStr="ECS^HRP^LIS"
	s:InitFlag="Y" HospStr=##class(web.DHCSTMHUI.MatForBDPData).GetDefHospStr("DHC_ServiceConfig")
	s Len=$l(HospStr,"^")
	
	i InitFlag="Y" d
	.s ret=##class(web.DHCSTMHUI.MatForBDPData).DeleteHospitals("DHC_ServiceConfig")
	.i ret<0 d RtnObj.Err(-2,"","删除接口配置关联失败")
	.s count=0
	.&sql(SELECT count(1) into :count FROM DHC_ServiceConfig)
	.q:count'>0
	.&sql(DELETE FROM DHC_ServiceConfig)
	.i SQLCODE'=0 d RtnObj.Err(-2,"","删除接口配置失败")
	q:RtnObj.success'=0 RtnObj
	
	s TypeLen=$l(TypeStr,"^")
	f i=1:1:TypeLen d
	.s Type=$p(TypeStr,"^",i)
	.s LocalIP=""
	.s User=""
	.s PassWord=""
	.s UseFlag="N"
	.i HospStr="" d
	..s ExistFlag=$$CheckExistServiceConfig(Type,HospStr)
	..q:ExistFlag="Y"
	..&sql(insert into DHC_ServiceConfig(SC_Type,SC_LocalIP,SC_User,SC_PassWord,SC_UseFlag) 
		values (:Type,:LocalIP,:User,:PassWord,:UseFlag))
	..i SQLCODE'=0 d RtnObj.Err(-3,"","重新生成接口配置失败")
	.e  d
	..f j=1:1:Len q:(RtnObj.success'=0)  d
	...s HospId=$p(HospStr,"^",j)
	...s ExistFlag=$$CheckExistServiceConfig(Type,HospId)
	...q:ExistFlag="Y"
	...&sql(insert into DHC_ServiceConfig(SC_Type,SC_LocalIP,SC_User,SC_PassWord,SC_UseFlag) 
		values (:Type,:LocalIP,:User,:PassWord,:UseFlag))
	...i SQLCODE'=0 d RtnObj.Err(-3,"","重新生成接口配置失败")
	...s RowId=%ROWID
	...s ret=##class(web.DHCSTMHUI.MatForBDPData).SaveHOSP("DHC_ServiceConfig",RowId,HospId)
	...i ret'=0 d RtnObj.Err(-5,"","关联院区失败")
	
	q RtnObj
	
CheckExistServiceConfig(Type,HospId)
	s Flag="N"
	i HospId'="" d
	.s tmprowid=""
	.f  s tmprowid=$o(^User.DHCServiceConfigI("Type",Type,tmprowid)) q:(tmprowid="")||(Flag="Y")  d
	..s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("DHC_ServiceConfig",tmprowid,HospId)
	..q:ShowDataFlag="N"
	..s Flag="Y"
	e  d
	.s cnt=0
	.&sql(select count(1) into :cnt from DHC_ServiceConfig where SC_Type=:Type)
	.s:cnt>0 Flag="Y"
	
	q Flag
}

/// InitFlag:"Y" 首次初始化
ClassMethod InitInciParam(InitFlag) As RtnObj
{
	n (InitFlag)
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	
	//1:属性名称;2:属性描述;3.是否审核标志;
	k INCIPARAMS
	
	s INCIPARAMS($i(INCIPARAMS))=$lb("INCICode","代码","Y")
	s INCIPARAMS($i(INCIPARAMS))=$lb("INCIDesc","描述","Y")
	s INCIPARAMS($i(INCIPARAMS))=$lb("INCICTUOMDR","基本单位","Y")
	s INCIPARAMS($i(INCIPARAMS))=$lb("INCICTUOMPurchDR","入库单位","Y")
	s INCIPARAMS($i(INCIPARAMS))=$lb("INCIINCSCDR","库存分类","Y")
	s INCIPARAMS($i(INCIPARAMS))=$lb("INCINotUseFlag","停用标志","N")
	s INCIPARAMS($i(INCIPARAMS))=$lb("INCIBatchReq","要求批次","N")
	s INCIPARAMS($i(INCIPARAMS))=$lb("INCIExpReq","要求效期","N")
	s INCIPARAMS($i(INCIPARAMS))=$lb("INCISterile","消毒项标志","N")
	s INCIPARAMS($i(INCIPARAMS))=$lb("INCISterCatDR","消毒项分类 ","N")
	s INCIPARAMS($i(INCIPARAMS))=$lb("INCIBarCode","条码","N")
	s INCIPARAMS($i(INCIPARAMS))=$lb("INCIReportingDays","协和码","N")
	s INCIPARAMS($i(INCIPARAMS))=$lb("INCICTLOCDR","供应仓库","N")

	; DHC_ItmAddionInfo
	s INCIPARAMS($i(INCIPARAMS))=$lb("INFOImportFlag","进口标志","N")
	s INCIPARAMS($i(INCIPARAMS))=$lb("INFOQualityLevel","质量层次","N")
	s INCIPARAMS($i(INCIPARAMS))=$lb("INFOComFrom","国（省）别","N")
	s INCIPARAMS($i(INCIPARAMS))=$lb("INFORemark","批准文号","N")
	s INCIPARAMS($i(INCIPARAMS))=$lb("INFOHighPrice","高值类标志","N")
	s INCIPARAMS($i(INCIPARAMS))=$lb("INFOMTDR","定价类型","N")
	//s INCIPARAMS($i(INCIPARAMS))=$lb("INFOMaxSp","最高售价","N")
	s INCIPARAMS($i(INCIPARAMS))=$lb("INFOInHosFlag","本院药品目录","N")
	s INCIPARAMS($i(INCIPARAMS))=$lb("INFOPbRp","招标进价","N")
	s INCIPARAMS($i(INCIPARAMS))=$lb("INFOPBLDR","招标名称","N")
	s INCIPARAMS($i(INCIPARAMS))=$lb("INFOPbVendorDR","招标供应商","N")
	s INCIPARAMS($i(INCIPARAMS))=$lb("INFOPbManfDR","招标生产商","N")
	s INCIPARAMS($i(INCIPARAMS))=$lb("INFOPbCarrierDR","招标配送商","N")
	s INCIPARAMS($i(INCIPARAMS))=$lb("INFOSpec","规格","N")
	s INCIPARAMS($i(INCIPARAMS))=$lb("INFOBAflag","一次性标志(物资材料)","N")
	s INCIPARAMS($i(INCIPARAMS))=$lb("INFOPBLevel","招标级别代码","N")
	s INCIPARAMS($i(INCIPARAMS))=$lb("INFOEndDate","截止日期","N")
	s INCIPARAMS($i(INCIPARAMS))=$lb("INFOExpireLen","效期长度(天)","N")
	s INCIPARAMS($i(INCIPARAMS))=$lb("INFOPrcFile","物价文件号","N")
	s INCIPARAMS($i(INCIPARAMS))=$lb("INFOPrcFileD","价格生效日期","N")
	s INCIPARAMS($i(INCIPARAMS))=$lb("INFOBCDr","账簿分类","N")
	s INCIPARAMS($i(INCIPARAMS))=$lb("INFOStandardCode","物资本位码","N")
	s INCIPARAMS($i(INCIPARAMS))=$lb("INFONotUseReasonDr","不可用原因","N")
	s INCIPARAMS($i(INCIPARAMS))=$lb("INFOPHMNFDR","生产厂家","N")
	s INCIPARAMS($i(INCIPARAMS))=$lb("INFOInsuCatDR","医保类别","N")
	s INCIPARAMS($i(INCIPARAMS))=$lb("INFOHighRiskFlag","高危标志","N")
	s INCIPARAMS($i(INCIPARAMS))=$lb("INFOPackUom","大包装","N")
	s INCIPARAMS($i(INCIPARAMS))=$lb("INFOPackUomFactor","大包装转换因子","N")
	s INCIPARAMS($i(INCIPARAMS))=$lb("INFOPackPicPath","外包装图片路径","N")
	s INCIPARAMS($i(INCIPARAMS))=$lb("INFOMaxPurAmt","月采购金额上限","N")
	s INCIPARAMS($i(INCIPARAMS))=$lb("INFODistribFlag","分配标志","N")
	s INCIPARAMS($i(INCIPARAMS))=$lb("INFOChargeFlag","收费标志","N")
	s INCIPARAMS($i(INCIPARAMS))=$lb("INFOBrand","品牌","N")
	s INCIPARAMS($i(INCIPARAMS))=$lb("INFOModel","型号","N")
	s INCIPARAMS($i(INCIPARAMS))=$lb("INFOAbbrev","简称","N")
	s INCIPARAMS($i(INCIPARAMS))=$lb("INFOSupervision","器械材料监管分类","N")
	s INCIPARAMS($i(INCIPARAMS))=$lb("INFOImplantationMat","植入（介入）材料","N")
	s INCIPARAMS($i(INCIPARAMS))=$lb("INFOPbno","招标序号","N")
	s INCIPARAMS($i(INCIPARAMS))=$lb("INFOChangeRate","招标转换比","N")
	s INCIPARAMS($i(INCIPARAMS))=$lb("INFOMatQuality","材质","N")
	s INCIPARAMS($i(INCIPARAMS))=$lb("INFOReqModeLimited","限制请求方式","N")
	s INCIPARAMS($i(INCIPARAMS))=$lb("INFONoLocReq","禁止科室请领","N")
	s INCIPARAMS($i(INCIPARAMS))=$lb("INFOSpeFlag","特殊标志","N")
	s INCIPARAMS($i(INCIPARAMS))=$lb("INFOSterileDateLen","灭菌时间长度（天）","N")
	s INCIPARAMS($i(INCIPARAMS))=$lb("INFOMedEqptCatDR","医疗器械分类","N")
	s INCIPARAMS($i(INCIPARAMS))=$lb("INFOZeroStk","零库存标志","N")
	s INCIPARAMS($i(INCIPARAMS))=$lb("INFOChargeType","收费类型","N")
	s INCIPARAMS($i(INCIPARAMS))=$lb("INFOSpecFlag","具体规格是否可以录入标志","N")
	s INCIPARAMS($i(INCIPARAMS))=$lb("INFOTransDate","到货时间","N")
	s INCIPARAMS($i(INCIPARAMS))=$lb("INFOBidDate","招标日期","N")
	s INCIPARAMS($i(INCIPARAMS))=$lb("INFOFirstReqDept","首请科室","N")
	s INCIPARAMS($i(INCIPARAMS))=$lb("INFOOrigin","原产地","N")
	s INCIPARAMS($i(INCIPARAMS))=$lb("INFOInsuPay","是否医保支付","N")
	s INCIPARAMS($i(INCIPARAMS))=$lb("INFOInsuPrice","医保支付价格","N")
	s INCIPARAMS($i(INCIPARAMS))=$lb("INFOMatCatOfficialDR","材料官方分类","N")
	s INCIPARAMS($i(INCIPARAMS))=$lb("INFOMatCatClinicalDR","材料临床分类","N")
	s INCIPARAMS($i(INCIPARAMS))=$lb("INFOMatCatSpecialDR","材料特殊分类","N")
	s INCIPARAMS($i(INCIPARAMS))=$lb("INFOMatRegCertDR","注册证号","N")
	
	i InitFlag="Y" d
	.s count=0
	.&sql(select count(1) into :count from DHC_InciParamRecord)
	.q:count'>0
	.&sql(delete from DHC_InciParamRecord)
	.i SQLCODE'=0 d RtnObj.Err(-2,"","删除物资审核属性失败")
	i RtnObj.success'=0 q RtnObj
	
	s i=0
	f  s i=$o(INCIPARAMS(i)) q:(i="")||(RtnObj.success'=0)  d
	.s data=INCIPARAMS(i)
	.s paramname=$list(data,1)
	.s paramdesc=$list(data,2)
	.s auditflag=$list(data,3)
	.s RowId=$o(^DHCINCIP(0,"param",paramname,""))
	.q:RowId'=""
	.&sql(INSERT INTO DHC_InciParamRecord (INCIP_ParamName, INCIP_Desc, INCIP_ActiveFlag) VALUES (:paramname,:paramdesc,:auditflag))
	.i SQLCODE'=0 d RtnObj.Err(-2,"","重新生成物资审核属性失败")
	
	q RtnObj
}

/// InitFlag:"Y" 首次初始化
ClassMethod InitPrintRule(InitFlag) As RtnObj
{
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	
	k PrintRules
	
	s PrintRules($i(PrintRules))=$lb("A","")
	s PrintRules($i(PrintRules))=$lb("B","")
	s PrintRules($i(PrintRules))=$lb("C","")
	s PrintRules($i(PrintRules))=$lb("D","")
	s PrintRules($i(PrintRules))=$lb("E","")
	s PrintRules($i(PrintRules))=$lb("F","")
	s PrintRules($i(PrintRules))=$lb("G","")
	s PrintRules($i(PrintRules))=$lb("H","")
	s PrintRules($i(PrintRules))=$lb("I","")
	s PrintRules($i(PrintRules))=$lb("J","")
	s PrintRules($i(PrintRules))=$lb("K","")
	s PrintRules($i(PrintRules))=$lb("L","")
	s PrintRules($i(PrintRules))=$lb("M","")
	s PrintRules($i(PrintRules))=$lb("N","")
	s PrintRules($i(PrintRules))=$lb("O","")
	s PrintRules($i(PrintRules))=$lb("P","")
	s PrintRules($i(PrintRules))=$lb("Q","")
	s PrintRules($i(PrintRules))=$lb("R","")
	s PrintRules($i(PrintRules))=$lb("S","")
	s PrintRules($i(PrintRules))=$lb("T","")
	s PrintRules($i(PrintRules))=$lb("U","")
	s PrintRules($i(PrintRules))=$lb("V","")
	s PrintRules($i(PrintRules))=$lb("W","")
	s PrintRules($i(PrintRules))=$lb("X","")
	s PrintRules($i(PrintRules))=$lb("Y","")
	s PrintRules($i(PrintRules))=$lb("Z","")
	
	i InitFlag="Y" d
	.s count=0
	.&sql(select count(1) into :count from MAT_PrintRules)
	.q:count'>0
	.&sql(delete from MAT_PrintRules)
	.i SQLCODE'=0 d RtnObj.Err(-2,"","删除打印规则失败")
	i RtnObj.success'=0 q RtnObj
	
	s i=0
	f  s i=$o(PrintRules(i)) q:(i="")||(RtnObj.success'=0)  d
	.s data=PrintRules(i)
	.s Code=$list(data,1)
	.s Description=$list(data,2)
	.s RowId=$o(^User.MATPrintRulesI("MATPRCode",Code,""))
	.q:RowId'=""
	.&sql(insert into MAT_PrintRules(MATPR_Code,MATPR_Desc) values(:Code,:Description))
	.i SQLCODE'=0 d RtnObj.Err(-2,"","重新打印规则失败")
	
	q RtnObj
}

/// Descript:	后台命令初始化
/// w ##class(web.DHCSTMHUI.DataInit).clsInit("")
ClassMethod clsInit(TypeStr As %String = "") As %String
{
	n (TypeStr)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	ts
	s:TypeStr="" TypeStr="App^CertType^GridSet^ServiceConfig^InciParam^PrintRule"
	s len=$l(TypeStr,"^")
	f i=1:1:len q:RtnObj.success'=0  d
	.s Type=$p(TypeStr,"^",i)
	.s Info={}
	.s Info.BDPHospital=""
	.s Info.Type=Type
	.s Info.InitFlag="Y"
	.s Params=Info.%ToJSON()
	.s RtnObj=..Init(Params)
	.
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

// 通用字典类型(包括字典类型值)-仅支持首次部署初始化

ClassMethod InitComDictType(InitFlag) As RtnObj
{
	n (InitFlag,%session)
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	
	//
	//1:类型代码;2:类型描述;
	k DICTTYPE
	
	s DICTTYPE($i(DICTTYPE))=$lb("PurType","带量采购类型")
	s DICTTYPE($i(DICTTYPE))=$lb("PurSource","采购来源")
	s DICTTYPE($i(DICTTYPE))=$lb("SunPur","阳光采购类型")
	i InitFlag="Y" d
	.s ret=##class(web.DHCSTMHUI.MatForBDPData).DeleteHospitals("CT_HRP_MAT.ComDictValue")
	.i ret<0 d RtnObj.Err(-1,"","删除字典类型值关联院区失败！")
	.s count=0
	.&sql(SELECT count(1) into :count FROM CT_HRP_MAT.ComDictType)
	.q:count'>0
	.&sql(DELETE FROM CT_HRP_MAT.ComDictType)
	.i SQLCODE'=0 d RtnObj.Err(-2,"","删除字典类型失败！")
	.s count=0
	.&sql(SELECT count(1) into :count FROM CT_HRP_MAT.ComDictValue)
	.q:count'>0
	.&sql(DELETE FROM CT_HRP_MAT.ComDictValue)
	.i SQLCODE'=0 d RtnObj.Err(-2,"","删除字典类型值失败")
	i RtnObj.success'=0 q RtnObj
	
	s i=0
	f  s i=$o(DICTTYPE(i)) q:(i="")||(RtnObj.success'=0)  d
	.s data=DICTTYPE(i)
	.s code=$list(data,1)
	.s desc=$list(data,2)
	.&sql(insert into CT_HRP_MAT.ComDictType
		(ComDI_TypeCode,ComDI_TypeDesc) 
		values(:code,:desc))
	.i SQLCODE'=0 d RtnObj.Err(-3,"","重新生成字典类型失败")
	q RtnObj
}

}
