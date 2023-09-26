Import sqluser

/// Descript:	同ECS供应链之间的接口程序
Class web.DHCSTMService.ECS.ECS2STMClient Extends (%RegisteredObject, web.DHCSTMHUI.StkTypeM) [ ProcedureBlock ]
{

Parameter Version = "HisUI";

/// 私有云版本--使用的医院用户名/密码
/// 公有云版本--医院系统上的AppId/AppSecret
/// 
Parameter wsuser = "dhwebservice";

Parameter wsps = "1wMu21i$9E";

/// IP^User^PassWord^Port^Path(下载图片，为空webservice下载供应链图片，不为空下载SFTP的图片)
Parameter FileSFTP;

/// 获取接口使用的标志
/// w ##class(web.DHCSTMService.ECS.ECS2STMClient).GetUseFlag(2,.SterTypeId)
ClassMethod GetUseFlag(HospId, SerTypeId)
{
	s UseFlag=##class(web.DHCSTMHUI.ServiceConfig).GetSerUseFlag("ECS",HospId)
	q:UseFlag'="Y" "N"
	
	s user=$p(^DHCSTM("ServiceConfig","ECS"_HospId),"^",2)
	s ps=$p(^DHCSTM("ServiceConfig","ECS"_HospId),"^",3)
	s SerTypeId=$p(^DHCSTM("ServiceConfig","ECS"_HospId),"^",4)
	q:(user="")||(ps="") "N"
	
	q "Y"
}

/// 公共调用Service方法
ClassMethod GetResult(Code, Input, HospId = "")
{
	s user=$p(^DHCSTM("ServiceConfig","ECS"_HospId),"^",2)
	s ps=$p(^DHCSTM("ServiceConfig","ECS"_HospId),"^",3)
	s ServiceConfigId=$p(^DHCSTM("ServiceConfig","ECS"_HospId),"^",4)
	s Token=..GetValidToken(ServiceConfigId)
	
	s ServiceObj=##class(web.DHCSTMService.ECS.ECS2STMServiceSoap).%New()
	s ServiceObj.OpenTimeout=5
	s ServiceObj.Timeout=600
	s ServiceObj.Username=..#wsuser
	s ServiceObj.Password=..#wsps
	s operateResult=ServiceObj.ECSService(Token,user,ps,Code,Input)
	s operateResult=operateResult.Read()
	q:operateResult="" ""
	
	;如遇token过期,补充获取 (ecs清空redis等情况下可能发生)
	;{"msg":"token不正确或者已过期，请重新获取","state":false}
	s RetObj={}.%FromJSON(operateResult)
	s State=RetObj.%Get("state")
	s Msg=RetObj.%Get("msg")
	i (State'=1)&&(Msg["token") d
	.;获取token
	.;再次调用 ECSService
	.s Token=..GetValidToken(ServiceConfigId,"Y")
	.s operateResult=ServiceObj.ECSService(Token,user,ps,Code,Input)
	.s operateResult=operateResult.Read()
	
	q operateResult
}

/// Description:获取有效
/// Input:		接口配置表rowid, ForceGet:强制获取新token
/// w ##class(web.DHCSTMService.ECS.ECS2STMClient).GetValidToken(2)
ClassMethod GetValidToken(ConfigId, ForceGet = "") As %String
{
	q:ConfigId="" ""
	s ConfigData=^User.DHCServiceConfigD(ConfigId)
	s User=$lg(ConfigData,4)
	s PassWord=$lg(ConfigData,5)
	s Token=$lg(ConfigData,7)
	s TokenDate=$lg(ConfigData,8)
	s TokenTime=$lg(ConfigData,9)
	s PassWord=##class(web.DHCSTMHUI.Common.UtilCommon).DecryptPW(PassWord)
	
	s NowDate=$p($h,",",1),NowTime=$p($h,",",2)
	s TimeGap=(NowDate-TokenDate)*86400+(NowTime-TokenTime)
	;按照2小时有效, 留出5分钟余量
	s ValidSecond=7200,MarginSecond=300
	s ValidSecond=ValidSecond-MarginSecond
	
	i (TimeGap>ValidSecond)||(ForceGet="Y") d
	.;若超出时长,则重新获取token,并保存
	.s Token=""
	.s ServiceObj=##class(web.DHCSTMService.ECS.ECS2STMServiceSoap).%New()
	.s ServiceObj.OpenTimeout=5
	.s ServiceObj.Timeout=600
	.s ServiceObj.Username=..#wsuser
	.s ServiceObj.Password=..#wsps
	.s OperateResult=ServiceObj.ECSService("",User,PassWord,"getToken","")
	.s ResultJson={}.%FromJSON(OperateResult)
	.s state=ResultJson.%Get("state")
	.q:state'=1
	.s Token=ResultJson.%Get("data").%Get("token")
	.
	.s Obj=##class(User.DHCServiceConfig).%OpenId(ConfigId)
	.s Obj.SCToken=Token
	.s Obj.SCTokenDate=NowDate
	.s Obj.SCTokenTime=NowTime
	.s Sc=Obj.%Save()
	
	q Token
}

/// w ##class(web.DHCSTMService.ECS.ECS2STMClient).test(2)
ClassMethod test(HospId)
{
	q:..GetUseFlag(HospId,.SerTypeId)'="Y" -1	//接口配置
	
	s Ret=..GetResult("test","",HospId)
	q:Ret="" -2	//接口不通
	
	s RetObj={}.%FromJSON(Ret)
	s State=RetObj.%Get("state")
	q:State'=1 -3		//接口失败
	
	q 0
}

/// 1.上传配送企业信息
/// Input:		VendorIdStr(如有多个,用^隔开)
/// w ##class(web.DHCSTMService.ECS.ECS2STMClient).saveSupDict("")
ClassMethod saveSupDict(VendorIdStr As %String, HospId = "")
{
	q:..GetUseFlag(HospId,.SerTypeId)'="Y" 0
	s MethodName="saveSupDict"
	s Params=VendorIdStr_";"_HospId
	d ##class(web.DHCSTMHUI.DHCDataExchangeLog).Log(.LogRowId,"",SerTypeId,$CLASSNAME(),MethodName,Params)
	
	s JsonObj={}
	s DataArray=[]
	s VendorList=$lfs(VendorIdStr,"^")
	s Count=0,Err=0
	s VendorId=0
	f  s VendorId=$o(^APC("APCVM",VendorId)) q:VendorId=""  d
	.q:(VendorIdStr'="")&&'$lf(VendorList,VendorId)
	.s VendorCode=$p(^APC("APCVM",VendorId),"^",2)
	.s VendorDesc=$p(^APC("APCVM",VendorId),"^",3)
	.s Type=$p(^APC("APCVM",VendorId),"^",9)
	.s Status=$p(^APC("APCVM",VendorId),"^",18)
	.q:Type'="M"
	.s CloudId=$p($g(^APC("APCVM",VendorId,1)),"^",16)		;云平台上供应商ID
	.s Bank=$p(^APC("APCVM",VendorId),"^",8)
	.s Account=$p(^APC("APCVM",VendorId),"^",10)
	.
	.s Obj=##class(User.APCVendor).%OpenId(VendorId)
	.s Address=""
	.&sql(select APCVM_Addr into :Address from apc_vendor where apcvm_rowid=:VendorId)
	.s Address=$lts(Address)
	.s StopFlag=$s(Status="S":1,1:0)					;是否停用:1-是,0-否
	.
	.s (SpellCode,WBCode,Abbrev,ResponsiblePerson)=""
	.s STVId=$o(^DHCSTV(0,VendorId,0))
	.i STVId'="" d
	..s Abbrev=$p(^DHCSTV(STVId),"^",37)
	..s Alias=$p(^DHCSTV(STVId),"^",46)
	..s SpellCode=$p(Alias,"/",1)
	..s ResponsiblePerson=$p(^DHCSTV(STVId),"^",58)
	.i SpellCode="" s SpellCode=##class(web.DHCSTMHUI.Common.AppCommon).GetCNCODE(VendorDesc,4,"",200)
	.i WBCode="" s WBCode=##class(web.DHCSTMHUI.Common.AppCommon).GetCNCODE(VendorDesc,6,"",200)
	.
	.s VenJson={}
	.d VenJson.%Set("sup_id",VendorId,"number")
	.d VenJson.%Set("sup_name",VendorDesc,"string")
	.d VenJson.%Set("short_name",Abbrev,"string")
	.d VenJson.%Set("note","","string")
	.d VenJson.%Set("spell_code",SpellCode,"string")
	.d VenJson.%Set("wbx_code",WBCode,"string")
	.d VenJson.%Set("is_stop",StopFlag,"number")
	.d VenJson.%Set("phone","","string")
	.d VenJson.%Set("address",Address,"string")
	.d VenJson.%Set("province","","string")
	.d VenJson.%Set("city","","string")
	.d VenJson.%Set("county","","string")
	.d VenJson.%Set("is_three_cert","","string")
	.d VenJson.%Set("taxpayer","","string")
	.d VenJson.%Set("bank",Bank,"string")
	.d VenJson.%Set("account",Account,"string")
	.d VenJson.%Set("csup_id",CloudId,"string")
	.d VenJson.%Set("contract_person",ResponsiblePerson,"string")
	.s Count=Count+1
	.d DataArray.%Push(VenJson)
	.i Count = 100  d sendVendor
	.q:(Err '= 0)
	i Count > 0 d sendVendor
	q 0
sendVendor
	s Count=0
	d JsonObj.%Set("list",DataArray)
	
	s Code="postSuppliers"
	s Input=JsonObj.%ToJSON()
	s JsonObj={}
	s DataArray=[]
	s Ret=..GetResult(Code,Input,HospId)
	d ##class(web.DHCSTMHUI.DHCDataExchangeLog).Log(.LogRowId,Ret,SerTypeId)
	s:Ret="" Err=-1
	q:Ret="" Err
	
	s RetObj={}.%FromJSON(Ret)
	s State=RetObj.%Get("state")
	s:State'=1 Err=-2
	q:State'=1 Err
	
	q 0
}

/// 2.下载配送企业信息（任务）
/// w ##class(web.DHCSTMService.ECS.ECS2STMClient).getSuppliers("","2022-06-23","2022-06-24","2")
ClassMethod getSuppliers(VendorIdStr, StartDate, EndDate, HospId) As %String
{
	q:HospId="" -1			;HospId在BDP基础数据中用到,不能为空
	q:..GetUseFlag(HospId,.SerTypeId)'="Y" 0
	s MethodName="getSuppliers"
	s Params=VendorIdStr_";"_StartDate_";"_EndDate_";"_HospId
	d ##class(web.DHCSTMHUI.DHCDataExchangeLog).Log(.LogRowId,"",SerTypeId,$CLASSNAME(),MethodName,Params)
	
	s JsonObj={}
	s DataArray=[]
	
	s VendorArray=[]
	s Len=$l(VendorIdStr,"^")
	f i=1:1:Len  d
	.s VendorId=$p(VendorIdStr,"^",i)
	.d VendorArray.%Push(VendorId)
	i VendorIdStr'="" d
	.d JsonObj.%Set("ids",VendorArray)
	d JsonObj.%Set("start_date",StartDate,"string")
	d JsonObj.%Set("end_date",EndDate,"string")
	d JsonObj.%Set("is_bind","","string")	//为0时，下载平台创建的，和物流没有对应关系的配送企业,为“”，下载全部
	s Code="getSuppliers"
	s Input=JsonObj.%ToJSON()
	s Ret=..GetResult(Code,Input,HospId)
	d ##class(web.DHCSTMHUI.DHCDataExchangeLog).Log(.LogRowId,Ret,SerTypeId)
	q:Ret="" -1
	
	s RetObj={}.%FromJSON(Ret)
	s State=RetObj.%Get("state")
	q:State'=1 -2
	s DatasObj=RetObj.%Get("data")
	q:DatasObj="" 0
	s DataSize=DatasObj.%Size()
	q:DataSize=0 0
	
	
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	ts
	s Err=0,PostRowIdStr=""
	f i=0:1:(DataSize-1) d
	.s VenObj=DatasObj.%Get(i)
	.s CloudId=VenObj.%Get("csup_id")
	.s VendorId=VenObj.%Get("sup_id")
	.s VendorDesc=VenObj.%Get("sup_name")
	.s ShortName=VenObj.%Get("short_name")
	.s Province=VenObj.%Get("province")
	.s City=VenObj.%Get("city")
	.s County=VenObj.%Get("county")
	.s Address=VenObj.%Get("address")
	.s Phone=VenObj.%Get("phone")
	.s SpellCode=VenObj.%Get("spell_code")
	.s WbxCode=VenObj.%Get("wbx_code")
	.s IsThreeCert=VenObj.%Get("is_three_cert")
	.s IsStop=VenObj.%Get("is_stop")
	.s UseFlag="A"
	.i IsStop="1" s UseFlag="S"
	.s Note=VenObj.%Get("note")
	.s Taxpayer=VenObj.%Get("taxpayer")
	.s Bank=VenObj.%Get("bank")
	.s Account=VenObj.%Get("account")
	.s ResponsiblePerson=VenObj.%Get("contract_person")
	.
	.d ..sssSetLogID()
	.i VendorId="" d
	..s tmpVendorId=""
	..&sql(SELECT APCVM_RowId into :tmpVendorId FROM APC_Vendor WHERE APCVM_Type='M' AND APCVM_Name=:VendorDesc)
	..i SQLCODE=0 s VendorId=tmpVendorId
	.
	.i VendorId="" d
	..s VendorCode=##class(web.DHCSTMHUI.Common.AppCommon).GetAppNo("DHCSTVENDORMTM","","")
	..s Obj=##class(User.APCVendor).%New()
	..s Obj.APCVMCode=VendorCode
	..s Obj.APCVMName=VendorDesc
	..s Obj.APCVMType="M"
	..s LogType="A"
	..s OldJsonStr=""
	.e  d
	..s Obj=##class(User.APCVendor).%OpenId(VendorId)
	..s LogType="U"
	..s OldJsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("APC_Vendor",VendorId)
	.
	.s Obj.APCVMCloudID=CloudId
	.s Obj.APCVMTel=Phone
	.s Obj.APCVMStatus=UseFlag
	.s Obj.APCVMContPerson=Bank
	.s Obj.APCVMCtrlAcctDR=Account
	.s Sc=Obj.%Save()
	.i $$$ISERR(Sc) s Err=-3
	.q:Err<0
	.
	.s VendorId=Obj.%Id()
	.i PostRowIdStr="" s PostRowIdStr=VendorId
	.e  s PostRowIdStr=PostRowIdStr_"^"_VendorId
	.d ##class(web.DHCSTMHUI.APCVenNew).SaveAddress(Address,VendorId)
	.s VendorCode=Obj.APCVMCode
	.s Alias=##class(web.DHCSTMHUI.APCVenNew).MakeVenAlias(VendorCode,VendorDesc,"")	//生成供应商别名
	.s STV=$o(^DHCSTV(0,VendorId,0))
    .i STV'=""  d
	..s STVObj=##class(User.DHCSTVendor).%OpenId(STV)
	..s STVLogType="U"
	..s STVOldJsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_STVendor",STV)
	.e  d
	..s STVObj=##class(User.DHCSTVendor).%New()
	..d STVObj.STVVendorDRSetObjectId(VendorId)
	..s STVObj.STVType="M"
	..s STVLogType="A"
	..s STVOldJsonStr=""
	.s STVObj.STVAlias=Alias
	.s STVObj.STVAbbrev=ShortName
	.s STVObj.STVResponsiblePerson=ResponsiblePerson
    .s Sc=STVObj.%Save()
	.i $$$ISERR(Sc) s Err=-4
	.q:Err<0
	.
	.s ret=##class(web.DHCSTMHUI.MatForBDPData).SaveHOSP("APC_Vendor",VendorId,HospId)
	.i ret<0 s Err=-5
	.q:Err<0
	.
	.s RtnObj=##class(web.DHCSTMHUI.Log).SaveLog("APC_Vendor","User.APCVendor","供应商信息",VendorId,VendorDesc,LogType,"",OldJsonStr)
	.i RtnObj.success'=0 s Err=-5
	.q:Err<0
	.s RtnObj=##class(web.DHCSTMHUI.Log).SaveLog("DHC_STVendor","User.DHCSTVendor","供应商附加信息",STV,VendorDesc,STVLogType,"",STVOldJsonStr)
	.i RtnObj.success'=0 s Err=-5
	.q:Err<0
	i Err<0 tro  q Err
	
	i PostRowIdStr'="" d
	.s ret=..saveSupDict(PostRowIdStr,HospId)
	.s:ret'=0 Err=-6
	
	i Err<0 tro  q Err
	tc
	q 0
}

/// 3.上传生产企业信息
/// Input:		ManfIdStr(如有多个,用^隔开)
/// w ##class(web.DHCSTMService.ECS.ECS2STMClient).postFactories("2402")
ClassMethod postFactories(ManfIdStr As %String, HospId = "")
{
	q:..GetUseFlag(HospId,.SerTypeId)'="Y" 0
	s MethodName="postFactories"
	s Params=ManfIdStr_";"_HospId
	d ##class(web.DHCSTMHUI.DHCDataExchangeLog).Log(.LogRowId,"",SerTypeId,$CLASSNAME(),MethodName,Params)
	
	s JsonObj={}
	s DataArray=[]
	s ManfList=$lfs(ManfIdStr,"^")
	s Count=0,Err=0
	s ManfId=0
	f  s ManfId=$o(^PHMNF(ManfId)) q:ManfId=""  d
	.q:(ManfIdStr'="")&&'$lf(ManfList,ManfId)
	.s ManfCode=$p(^PHMNF(ManfId),"^",1)
	.s ManfDesc=$p(^PHMNF(ManfId),"^",2)
	.s Phone=$p(^PHMNF(ManfId),"^",3)
	.s ManfAddId=$o(^DHCMANF(0,"MANF",ManfId,""))
	.q:ManfAddId=""
	.s Type=$p(^DHCMANF(ManfAddId),"^",7)
	.s Status=$p(^DHCMANF(ManfAddId),"^",10)
	.q:Type'="M"
	.
	.s Address=##class(web.DHCSTMHUI.ItmManfNew).GetAddress(ManfId)
	.s StopFlag=$s(Status="Y":0,1:1)					;是否停用:1-是,0-否
	.
	.s SpellCode=##class(web.DHCSTMHUI.Common.AppCommon).GetCNCODE(ManfDesc,4,"",200)
	.s WBCode=##class(web.DHCSTMHUI.Common.AppCommon).GetCNCODE(ManfDesc,6,"",200)
	.
	.s VenJson={}
	.d VenJson.%Set("fac_id",ManfId,"number")
	.d VenJson.%Set("fac_name",ManfDesc,"string")
	.d VenJson.%Set("spell_code",SpellCode,"string")
	.d VenJson.%Set("wbx_code",WBCode,"string")
	.d VenJson.%Set("fac_type_name","","string")
	.d VenJson.%Set("province","","string")
	.d VenJson.%Set("city","","string")
	.d VenJson.%Set("county","","string")
	.d VenJson.%Set("address",Address,"string")
	.d VenJson.%Set("phone",Phone,"string")
	.s Count=Count+1
	.d DataArray.%Push(VenJson)
	.i Count = 100  d sendManf
	.q:(Err '= 0)
	i Count > 0 d sendManf
	q 0
sendManf
	s Count=0
	d JsonObj.%Set("list",DataArray)
	
	s Code="postFactories"
	s Input=JsonObj.%ToJSON()
	s JsonObj={}
	s DataArray=[]
	s Ret=..GetResult(Code,Input,HospId)
	d ##class(web.DHCSTMHUI.DHCDataExchangeLog).Log(.LogRowId,Ret,SerTypeId)
	s:Ret="" Err=-1
	q:Ret="" Err
	
	s RetObj={}.%FromJSON(Ret)
	s State=RetObj.%Get("state")
	s:State'=1 Err=-2
	q:State'=1 Err
	
	q 0
}

/// 4.下载生产企业信息（任务）
/// w ##class(web.DHCSTMService.ECS.ECS2STMClient).getFactories("","2021-07-19","2021-07-19","")
ClassMethod getFactories(ManfIdStr, StartDate, EndDate, HospId) As %String
{
	i HospId="" q -1
	q:..GetUseFlag(HospId,.SerTypeId)'="Y" 0
	s MethodName="getFactories"
	s Params=ManfIdStr_";"_StartDate_";"_EndDate_";"_HospId
	d ##class(web.DHCSTMHUI.DHCDataExchangeLog).Log(.LogRowId,"",SerTypeId,$CLASSNAME(),MethodName,Params)
	
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	s JsonObj={}
	s DataArray=[]
	
	s ManfArray=[]
	s Len=$l(ManfIdStr,"^")
	f i=1:1:Len  d
	.s ManfId=$p(ManfIdStr,"^",i)
	.d ManfArray.%Push(ManfId)
	i ManfIdStr'="" d
	.d JsonObj.%Set("ids",ManfArray)
	d JsonObj.%Set("start_date",StartDate,"string")
	d JsonObj.%Set("end_date",EndDate,"string")
	s Code="getFactories"
	s Input=JsonObj.%ToJSON()
	s Ret=..GetResult(Code,Input,HospId)
	d ##class(web.DHCSTMHUI.DHCDataExchangeLog).Log(.LogRowId,Ret,SerTypeId)
	q:Ret="" -1
	
	s RetObj={}.%FromJSON(Ret)
	s State=RetObj.%Get("state")
	q:State'=1 -2
	s DatasObj=RetObj.%Get("data")
	q:DatasObj="" 0
	s DataSize=DatasObj.%Size()
	q:DataSize=0 0
	
	ts
	s Err=0,PostRowIdStr=""
	f i=0:1:(DataSize-1) d
	.s ManfObj=DatasObj.%Get(i)
	.s CloudId=ManfObj.%Get("cfac_id")
	.s ManfId=ManfObj.%Get("fac_id")
	.s ManfDesc=ManfObj.%Get("fac_name")
	.s SpellCode=ManfObj.%Get("spell_code")
	.s WbxCode=ManfObj.%Get("wbx_code")
	.s FacTypeName=ManfObj.%Get("fac_type_name")
	.s Province=ManfObj.%Get("province")
	.s City=ManfObj.%Get("city")
	.s County=ManfObj.%Get("county")
	.s Address=ManfObj.%Get("address")
	.s Tel=ManfObj.%Get("phone")
	.
	.d ..sssSetLogID()
	.i ManfId="" d
	..s tmpManfId=""
	..&sql(SELECT MANF_PhcManf_DR into :tmpManfId FROM DHC_Manf_AddionInfo	WHERE MANF_Type='M' AND MANF_PhcManf_DR->PHMNF_Name=:ManfDesc)
	..i SQLCODE=0 s ManfId=tmpManfId
	.i ManfId="" d
	..s Obj=##class(User.PHManufacturer).%New()
	..s AppName=##class(web.DHCSTMHUI.ItmManfNew).%GetParameter("AppName")
	..s ManfCode=##class(web.DHCSTMHUI.Common.AppCommon).GetAppNo(AppName,"","","")
	..s Obj.PHMNFCode=ManfCode
	..s Obj.PHMNFName=ManfDesc
	..s LogType="A"
	..s OldJsonStr=""
	.e  d
	..s Obj=##class(User.PHManufacturer).%OpenId(ManfId)
	..s LogType="U"
	..s OldJsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("PH_Manufacturer",ManfId)
	.s Obj.PHMNFTel=Tel
	.s Sc=Obj.%Save()
	.i $$$ISERR(Sc) s Err=-1
	.q:Err<0
	.s ManfId=Obj.%Id()
	.i PostRowIdStr="" s PostRowIdStr=ManfId
	.e  s PostRowIdStr=PostRowIdStr_"^"_ManfId
	.d ##class(web.DHCSTMHUI.ItmManfNew).SaveAddress(Address,ManfId)
	.
	.s ManfCode=Obj.PHMNFCode
	.s SPAlias=##class(web.DHCSTMHUI.Common.AppCommon).GetCNCODE(ManfDesc,4)
	.s QPAlias=##class(web.DHCSTMHUI.Common.AppCommon).GetCNCODE(ManfDesc,3,"",50)
	.s Alias=ManfCode_"/"_ManfDesc_"/"_SPAlias_"/"_QPAlias
	.
	.s AddionId=$o(^DHCMANF(0,"MANF",ManfId,""),-1)
	.i AddionId="" d
	..s AddionObj=##class(User.DHCManfAddionInfo).%New()
	..s AddionObj.MANFType=..sssCode()
	..d AddionObj.MANFPhcManfDRSetObjectId(ManfId)
	..s AddionObj.MANFActive="Y"
	..s AddLogType="A"
	..s AddOldJsonStr=""
	.e  d
	..s AddionObj=##class(User.DHCManfAddionInfo).%OpenId(AddionId)
	..s AddLogType="U"
	..s AddOldJsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_Manf_AddionInfo",AddionId)
	.s AddionObj.MANFAlias=Alias
	.s AddionObj.MANFCloudId=CloudId
	.s Sc=AddionObj.%Save()
	.i $$$ISERR(Sc) s Err=-2
	.q:Err<0
	.
	.s ret=##class(web.DHCSTMHUI.MatForBDPData).SaveHOSP("PH_Manufacturer",ManfId,HospId)
	.i ret<0 s Err=-3
	.q:Err<0
	.
	.s RtnObj=##class(web.DHCSTMHUI.Log).SaveLog("PH_Manufacturer","User.PHManufacturer","生产厂家信息",ManfId,ManfDesc,LogType,"",OldJsonStr)
	.i RtnObj.success'=0 s Err=-4
	.q:Err<0
	.s RtnObj=##class(web.DHCSTMHUI.Log).SaveLog("DHC_Manf_AddionInfo","User.DHCManfAddionInfo","生产厂家附加信息",AddionId,ManfDesc,AddLogType,"",AddOldJsonStr)
	.i RtnObj.success'=0 s Err=-5
	.q:Err<0
	i Err<0 tro  q Err
	
	i PostRowIdStr'="" d
	.s ret=..postFactories(PostRowIdStr,HospId)
	.s:ret'=0 Err=-6
	
	i Err<0  tro  q Err
	tc
	
	q 0
}

/// 5.上传院内分类信息
/// Description:同步库存分类信息到平台
/// CreateDate:	2021-03-08
/// Input:		库存分类RowId(如有多个,用^隔开)
/// Output:		
/// Return:		"":成功; 非空:有错误信息
/// w ##class(web.DHCSTMService.ECS.ECS2STMClient).updateHosCat("")
ClassMethod updateHosCat(IncscIdStr As %String, HospId = "") As %String
{
	q:..GetUseFlag(HospId,.SerTypeId)'="Y" 0
	s MethodName="updateHosCat"
	s Params=IncscIdStr_";"_HospId
	d ##class(web.DHCSTMHUI.DHCDataExchangeLog).Log(.LogRowId,"",SerTypeId,$CLASSNAME(),MethodName,Params)
	
	s JsonObj={}
	s DataArray=[]
	s IncscList=$lfs(IncscIdStr,"^")
	s RowId=0
	f  s RowId=$o(^INC("SC",RowId)) q:RowId=""  d
	.q:(IncscIdStr'="")&&'$lf(IncscList,RowId)
	.s IncscDesc=$p(^INC("SC",RowId),"^",2)
	.s StkType=$p(^INC("SC",RowId),"^",3)
	.q:StkType'=..sssCode()
	.s IncscCode=$p(^INC("SC",RowId),"^",1)
	.s StkGrpId=$o(^DHCSCG("STKCAT",RowId,0))
	.s CatJson={}
	.d CatJson.%Set("cat_id",RowId,"string")
	.d CatJson.%Set("cat_name",IncscDesc,"string")
	.d CatJson.%Set("cat_code",IncscCode,"string")
	.d CatJson.%Set("parent_id","","string")
	.d CatJson.%Set("type_id",StkGrpId,"string")
	.d DataArray.%Push(CatJson)
	d JsonObj.%Set("list",DataArray)
	
	s Code="postCategories"
	s Input=JsonObj.%ToJSON()
	s Ret=..GetResult(Code,Input,HospId)
	d ##class(web.DHCSTMHUI.DHCDataExchangeLog).Log(.LogRowId,Ret,SerTypeId)
	q Ret
}

/// 上传院内类组信息
/// Description:同步类组信息到平台
/// CreateDate:	2023-03-20
/// Input:		类组RowId(如有多个,用^隔开)
/// Output:		
/// Return:		"":成功; 非空:有错误信息
/// w ##class(web.DHCSTMService.ECS.ECS2STMClient).updateHosType("")
ClassMethod updateHosType(StkGrpIdStr As %String, HospId = "") As %String
{
	q:..GetUseFlag(HospId,.SerTypeId)'="Y" 0
	s MethodName="updateHosCat"
	s Params=StkGrpIdStr_";"_HospId
	d ##class(web.DHCSTMHUI.DHCDataExchangeLog).Log(.LogRowId,"",SerTypeId,$CLASSNAME(),MethodName,Params)
	
	s JsonObj={}
	s DataArray=[]
	s StkGrpIdList=$lfs(StkGrpIdStr,"^")
	s RowId=0
	f  s RowId=$o(^DHCSCG(RowId)) q:RowId=""  d
	.q:+RowId=0
	.q:(StkGrpIdStr'="")&&'$lf(StkGrpIdList,RowId)
	.s StkType=$p(^DHCSCG(RowId),"^",3)
	.q:StkType'=..sssCode()
	.s StkGrpCode=$p(^DHCSCG(RowId),"^",1)
	.s StkGrpDesc=$p(^DHCSCG(RowId),"^",2)
	.s ParentStkGrpId=$p(^DHCSCG(RowId),"^",4)
	.s StkGrpJson={}
	.d StkGrpJson.%Set("type_id",RowId,"string")
	.d StkGrpJson.%Set("type_name",StkGrpDesc,"string")
	.d StkGrpJson.%Set("type_code",StkGrpCode,"string")
	.d StkGrpJson.%Set("parent_id",ParentStkGrpId,"string")
	.d StkGrpJson.%Set("type",StkType,"string")
	.d DataArray.%Push(StkGrpJson)
	d JsonObj.%Set("list",DataArray)
	
	s Code="postHosType"
	s Input=JsonObj.%ToJSON()
	s Ret=..GetResult(Code,Input,HospId)
	d ##class(web.DHCSTMHUI.DHCDataExchangeLog).Log(.LogRowId,Ret,SerTypeId)
	q Ret
}

/// 6.上传部门信息（任务）
/// w ##class(web.DHCSTMService.ECS.ECS2STMClient).saveHopDepart("")
ClassMethod saveHopDepart(LocIdStr As %String = "", HospId = "") As %String
{
	q:..GetUseFlag(HospId,.SerTypeId)'="Y" 0
	s MethodName="saveHopDepart"
	s Params=LocIdStr_";"_HospId
	d ##class(web.DHCSTMHUI.DHCDataExchangeLog).Log(.LogRowId,"",SerTypeId,$CLASSNAME(),MethodName,Params)
	
	s count=0
	s loc=0,Ret=0,Err=0
	s RowsArray=[]
	s JsonObj={}
	f  s loc=$O(^CTLOC(loc)) q:loc=""  d
	.q:(LocIdStr'="")&&(("^"_LocIdStr_"^")'[("^"_loc_"^"))
	.s Code=$p(^CTLOC(loc),"^",1)
	.s Desc=$p(^CTLOC(loc),"^",2)
	.s Type=$p(^CTLOC(loc),"^",13)
	.s LocType=1
	.s ifstock=##class(web.DHCSTMHUI.Common.UtilCommon).IfStockLoc(loc)
	.s:ifstock="Y" LocType=2
	.s detailObj={}
	.d detailObj.%Set("his_id",loc,"string")
	.d detailObj.%Set("depart_code",Code,"string")
	.d detailObj.%Set("depart_name",Desc,"string")
	.d detailObj.%Set("depart_type",LocType,"string")
	.d RowsArray.%Push(detailObj)
	.s count = count +1
	.i count = 100  d sendLoc
	.q:(Err '= 0)
	i count > 0 d sendLoc
	q 0
	
sendLoc	
	s count = 0
	d JsonObj.%Set("list",RowsArray)
	s Code="postDepartments"
	s Input=JsonObj.%ToJSON()
	s RowsArray=[]
	s JsonObj={}
	s Ret=..GetResult(Code,Input,HospId)
	d ##class(web.DHCSTMHUI.DHCDataExchangeLog).Log(.LogRowId,Ret,SerTypeId)
	s:Ret="" Err=-1
	q:Ret="" Err
	s RetObj={}.%FromJSON(Ret)
	s State=RetObj.%Get("state")
	s:State'=1 Err=-2
	q:State'=1 Err
	
	q 0
}

/// 7.上传品规信息(批量)
/// w ##class(web.DHCSTMService.ECS.ECS2STMClient).postSpecifications("15848")
ClassMethod postSpecifications(InciStr As %String, HospId = "") As %String
{
	q:..GetUseFlag(HospId,.SerTypeId)'="Y" 0
	s MethodName="postSpecifications"
	s Params=InciStr_";"_HospId
	d ##class(web.DHCSTMHUI.DHCDataExchangeLog).Log(.LogRowId,"",SerTypeId,$CLASSNAME(),MethodName,Params)
	
	//q:InciStr="" ""
	s JsonObj={}
	s DataArray=[]
	s InciList=$lfs(InciStr,"^")
	s count=0,Err=0
	s Inci=0
	f  s Inci=$o(^INCI(Inci)) q:(Inci="")||(Err'= 0)  d
	.q:+Inci=0
	.q:(InciStr'="")&&'$lf(InciList,Inci)
	.s NotUseFlag=$p(^INCI(Inci,2),"^",9)
	.q:NotUseFlag="Y"
	.s InciFlag=..GetInciFlag(Inci)
	.q:InciFlag'="Y"
	.s VenIncInci="",TemInci=""
	.&sql(SELECT NI_SciId into :TemInci FROM DHC_NewItm WHERE NI_InciDR=:Inci)
	.i SQLCODE=0 s VenIncInci=TemInci
	.s InciCode=$p(^INCI(Inci,1),"^",1)
	.s InciDesc=$p(^INCI(Inci,1),"^",2)
	.s IncscId=$p(^INCI(Inci,2),"^",2)
	.//s InciUom=$p(^INCI(Inci,3),"^",6)   ///入库单位
	.s InciUom=$p(^INCI(Inci,1),"^",10)		///基本单位
	.s StopFlag=$s(NotUseFlag="Y":1,1:0)
	.s InciUomDesc=""
	.s:InciUom'="" InciUomDesc=$P(^CT("UOM",InciUom),"^",2)
	.s Rp=##class(web.DHCSTMHUI.Common.PriceCommon).GetInciBasicRp(Inci,+$h,InciUom,"","")
	.s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",Inci)
	.s Model=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetModel(Inci)
	.s isImpl=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncImplantationMat(Inci)
	.i isImpl="Y" d
	..s isImpl=1
	.e  d
	..s isImpl=0
	.s (brand,model,BatchCodeFlag,TemPurchase)=""
	.s info=$o(^DHCITMINFO(0,"INCI",Inci,""))
	.i info'="" d
	..s brand=$p(^DHCITMINFO(info),"^",58)
	..s model=$p(^DHCITMINFO(info),"^",59)
	..s BatchCodeFlag=$p($g(^DHCITMINFO(info,1)),"^",23)
	..s TemPurchase=$p($g(^DHCITMINFO(info,1)),"^",17)
	.i TemPurchase="Y" d
	..s TemPurchase=1
	.e  d
	..s TemPurchase=0
	.s HVFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(Inci)
	.
	.;不是批次码,并且为高值的,ECS按"唯一码"处理; 即UniqueCodeFlag=1
	.;是批次码的,ECS按"自带码"处理; 即OrginalCodeFlag=1
	.s (UniqueCodeFlag,OrginalCodeFlag)=0
	.i (BatchCodeFlag'="Y")&&(HVFlag="Y") s UniqueCodeFlag=1
	.i BatchCodeFlag="Y" s OrginalCodeFlag=1
	.
	.s VendorInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetPbVendor(Inci)
	.s VendorId=$p(VendorInfo,"^",1)
	.s VendorDesc=$p(VendorInfo,"^",2)
	.s Manf=$p(##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetManf(Inci),"^",1)
	.s ManfDesc=$p(##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetManf(Inci),"^",3)
	.s CertInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetCert(Inci)
	.s CertNo=$p(CertInfo,"^",1)
	.s StartDate=$p(CertInfo,"^",22)
	.s StartDate=..DH2L(StartDate)
	.s:StartDate'="" StartDate=$zd(StartDate,3)
	.s EndDate=$p(CertInfo,"^",2)		;YYYY-mm-dd 注意日期转换
	.s EndDate=..DH2L(EndDate)
	.s:EndDate'="" EndDate=$zd(EndDate,3)
	.s NewId=$o(^DHCNEWITM(0,"INCI",Inci,0))
	.s SCIId=$s(NewId'="":$p(^DHCNEWITM(NewId),"^",34),1:"")
	.
	.s InciJson={}	
	.d InciJson.%Set("inv_id",Inci,"string")
	.d InciJson.%Set("inv_code",InciCode,"string")
	.d InciJson.%Set("inv_name",InciDesc,"string")
	.d InciJson.%Set("inv_model",Model,"string")
	.d InciJson.%Set("inv_spec",Spec,"string")
	.d InciJson.%Set("unit_code",InciUom,"string")
	.d InciJson.%Set("unit_name",InciUomDesc,"string")
	.d InciJson.%Set("bid_code","","string")
	.d InciJson.%Set("price",Rp,"number")
	.d InciJson.%Set("brand_name",brand,"string")
	.d InciJson.%Set("is_impl",isImpl,"number")
	.d InciJson.%Set("fac_id",Manf,"string")
	.d InciJson.%Set("fac_name",ManfDesc,"string")
	.d InciJson.%Set("cert_code",CertNo)
	.d InciJson.%Set("start_date",StartDate)
	.d InciJson.%Set("end_date",EndDate)
	.d InciJson.%Set("spell_code","")
	.d InciJson.%Set("wbx_code","")
	.d InciJson.%Set("is_hospbarcode",UniqueCodeFlag,"number")	;唯一码标记
	.d InciJson.%Set("is_stop",StopFlag,"number")
	.d InciJson.%Set("spec_id",SCIId,"string")
	.d InciJson.%Set("is_temp",TemPurchase,"string")
	.d InciJson.%Set("hos_cat_id",IncscId,"string")
	.s SupArray=[]
	.s SupJson={}
	.d SupJson.%Set("sup_id",VendorId,"string")
	.d SupJson.%Set("sup_name",VendorDesc,"string")
	.d SupArray.%Push(SupJson)
	.d InciJson.%Set("sup",SupArray)
	.d DataArray.%Push(InciJson)
	.s count = count +1
	.i count = 100  d sendSpec
	.q:(Err '= 0)
	
	i count > 0 d sendSpec
	q 0
	
sendSpec
	s count = 0
	d JsonObj.%Set("list",DataArray)
	s Code="postSpecifications"
	s Input = JsonObj.%ToJSON()
	s JsonObj = {}
	s DataArray=[]
	s Ret=..GetResult(Code,Input,HospId)
	d ##class(web.DHCSTMHUI.DHCDataExchangeLog).Log(.LogRowId,Ret,SerTypeId)
	s:Ret="" Err=-2
	q:Err<0 Err
	s RetObj={}.%FromJSON(Ret)
	s State=RetObj.%Get("state")
	s:State'=1 Err=-3
	q Err
}

/// 8.getSpecifications（任务）
/// w ##class(web.DHCSTMService.ECS.ECS2STMClient).getSpecifications("","2021-07-19","2021-07-19")
ClassMethod getSpecifications(InciStr, StartDate, EndDate, HospId = "") As %String
{
	q:..GetUseFlag(HospId,.SerTypeId)'="Y" 0
	s MethodName="getSpecifications"
	s Params=InciStr_";"_StartDate_";"_EndDate_";"_HospId
	d ##class(web.DHCSTMHUI.DHCDataExchangeLog).Log(.LogRowId,"",SerTypeId,$CLASSNAME(),MethodName,Params)
	
	s Inci=+InciStr,TemInci="",BindFlag=0
	i InciStr'="" d
	.&sql(SELECT NI_SciId into :TemInci FROM DHC_NewItm WHERE NI_InciDR=:Inci)
	i TemInci'="" s BindFlag=1

	s JsonObj={}
	s DataArray=[]
	
	s InciArray=[]
	s Len=$l(InciStr,"^")
	s tmpInciStr=""
	f i=1:1:Len  d
	.s Inci=$p(InciStr,"^",i)
	.d InciArray.%Push(Inci)
	i InciStr'="" d
	.d JsonObj.%Set("ids",InciArray)
	d JsonObj.%Set("is_bind",BindFlag,"string")
	d JsonObj.%Set("start_date",StartDate,"string")
	d JsonObj.%Set("end_date",EndDate,"string")
	
	s Code="getSpecifications"
	s Input=JsonObj.%ToJSON()
	s InvRet=..GetResult(Code,Input,HospId)
	d ##class(web.DHCSTMHUI.DHCDataExchangeLog).Log(.LogRowId,InvRet,SerTypeId)
	
	q:InvRet="" -1
	s InvRetObj={}.%FromJSON(InvRet)
	s State=InvRetObj.%Get("state")
	q:State'=1 -2
	s DatasObj=InvRetObj.%Get("data")
	q:DatasObj="" 0
	s DataSize=DatasObj.%Size()
	q:DataSize=0 0	
	
	s Err=0
	f i=0:1:(DataSize-1) d
	.s InvObj=DatasObj.%Get(i)
	.s VendorId=InvObj.%Get("sup_id")
	.s VendorDesc=$s(VendorId'="":$p(^APC("APCVM",VendorId),"^",3),1:"")
	.s ProdId=InvObj.%Get("prod_id")	
	.s SpecId=InvObj.%Get("spec_id")	
	.s ProdName=InvObj.%Get("prod_name")
	.s SpecName=InvObj.%Get("spec_name")
	.s FacName=InvObj.%Get("fac_name")
	.s ManfId=##class(web.DHCSTMHUI.Tools.CodeInputNew).validManf(FacName,HospId)
	.//s InvCode=InvObj.%Get("prod_type_name1")
	.//s InvCode=InvObj.%Get("prod_type_name2")
	.//s InvCode=InvObj.%Get("prod_type_name3")
	.//s InvCode=InvObj.%Get("prod_type_name4")
	.s RegNo=InvObj.%Get("cert_code")
	.s CertBatch=InvObj.%Get("cert_batch")
	.s Startdate=InvObj.%Get("start_date")
	.s:Startdate'="" Startdate=$zdh($p(Startdate," ",1),3)
	.s Enddate=InvObj.%Get("end_date")
	.s:Enddate'="" Enddate=$zdh($p(Enddate," ",1),3)
	.s IsLong=InvObj.%Get("is_long")
	.s IsLong=$s(IsLong=1:"Y",1:"N")
	.s OriginType=InvObj.%Get("origin_type")
	.s ImportFlag=$s(OriginType=1:"国产",OriginType=2:"进口",1:"")
	.s Model=InvObj.%Get("model")
	.s BrandName=InvObj.%Get("brand_name")
	.s OriginName=InvObj.%Get("origin_name")
	.s IsCode=InvObj.%Get("is_cold")
	.s StoreTerm=InvObj.%Get("stora_term")
	.s TermName=InvObj.%Get("term_name")
	.s SpecNameSec=InvObj.%Get("spec_name_sec")
	.s Package=InvObj.%Get("package")
	.s IsImpl=InvObj.%Get("is_impl")
	.s IsImpl=$s(IsImpl=1:"Y",1:"N")
	.s ReceiveUnit=InvObj.%Get("receive_unit")
	.s BUom=##class(web.DHCSTMHUI.Tools.CodeInputNew).validUom(ReceiveUnit)
	.s BarCode=InvObj.%Get("bar_code")
	.s TenderName=InvObj.%Get("tender_name")
	.s BidCode=InvObj.%Get("bid_code")
	.s Price=InvObj.%Get("price")
	.s Appdate=InvObj.%Get("app_date")
	.s CheckState=InvObj.%Get("check_state")
	.s Inci=InvObj.%Get("inv_id")
	.s IsBind=InvObj.%Get("is_bind")
	.s BaFlag=""
	.s TemPurchase=InvObj.%Get("is_temp")
	.s TemPurchase=$s(TemPurchase=1:"Y",1:"N")
	.s CentralPurFlag=InvObj.%Get("is_collect_purchase")
	.s CentralPurFlag=$s(CentralPurFlag=1:"Y",1:"N")
	.s Batchequired=InvObj.%Get("is_batch_no_required")
	.s BatchReq=""
	.s:Batchequired=1 BatchReq="R"
	.s ExpRequired=InvObj.%Get("is_inva_date_required")
	.s ExpReq=""
	.s:ExpRequired=1 ExpReq="R"
	.ts
	.;先生成注册证信息
	.s RegId=""
	.i RegNo'="" d
	..s RegId=$o(^DHCMRCT(0,"NO",RegNo,""),-1)
	..i RegId'="" d
	...s RegObj=##class(User.DHCMatRegCert).%OpenId(RegId)
	..e  d
	...s RegObj=##class(User.DHCMatRegCert).%New()
	...s RegObj.MRCNo=RegNo
	..
	..d RegObj.MRCPHManfDRSetObjectId(ManfId)
	..s RegObj.MRCProArea=""
	..s RegObj.MRCStructure=""
	..s RegObj.MRCAppliedRange=""
	..s RegObj.MRCRegName=""
	..s RegObj.MRCRegPerAddress=""
	..s RegObj.MRCInciDesc=ProdName
	..s RegObj.MRCSpecForm=SpecName
	..s RegObj.MRCRemark=""
	..s RegObj.MRCApprovalDate=Startdate
	..s RegObj.MRCValidUntil=Enddate
	..s RegObj.MRCValidLong=IsLong
	..d RegObj.MRCPHManfDRSetObjectId(ManfId)
	..s sc=RegObj.%Save()
	..i $$$ISERR(sc) d
	...s Err=-10
	..q:Err<0
	..s RegId=RegObj.%Id()
	.i Err<0 tro 1 q
	.///已经生成库存项
	.i +Inci>0  d
	..s InciObj=##class(User.INCItm).%OpenId(Inci)
	..s InciObj.INCIDesc=ProdName
	..s InciObj.INCIBarCode=BarCode
	..s InciObj.INCIBatchReq=BatchReq
	..s InciObj.INCIExpReq=ExpReq
	..s Sc=InciObj.%Save()
	..i $$$ISERR(Sc) d
	...s Err=-11
	..i Err<0 q
	..s InfoId=$o(^DHCITMINFO(0,"INCI",Inci,0))
	..i InfoId'="" d
	...s InfoObj=##class(User.DHCItmAddionInfo).%OpenId(InfoId)
	..e  d
	...s InfoObj=##class(User.DHCItmAddionInfo).%New()
	...d InfoObj.INFOINCIDRSetObjectId(Inci)
	..s InfoObj.INFOBrand=BrandName
	..s InfoObj.INFOSpec=SpecName
	..s InfoObj.INFOModel=Model
	..s InfoObj.INFOTemPurchase=TemPurchase
	..s InfoObj.INFOCentralPurFlag=CentralPurFlag
	..d InfoObj.INFOPbManfDRSetObjectId(ManfId)
	..s Sc=InfoObj.%Save()
	..i $$$ISERR(Sc) d
	...s Err=-11
	..i Err<0 q
	..;保存耗材自带码
	..s Err=..SaveMainBarCode(Inci,BarCode)
	..i Err<0 q
	.e  d
	..s NewItmId=$o(^DHCNEWITM(0,"SCICODE",SpecId,""))
	..i NewItmId="" d
	...s NewItmObj=##class(User.DHCNewItm).%New()
	..e  d
	...s NewItmObj=##class(User.DHCNewItm).%OpenId(NewItmId)
	..s NewItmObj.NIDate=+$h
	..s NewItmObj.NITime=$p($h,",",2)
	..s NewItmObj.NIDesc=ProdName
	..s NewItmObj.NISpec=SpecName
	..s NewItmObj.NIManf=FacName
	..s NewItmObj.NIBUom=ReceiveUnit
	..s NewItmObj.NIPUom=ReceiveUnit
	..s NewItmObj.NIPRp=Price
	..s NewItmObj.NIPSp=Price
	..s NewItmObj.NIAckFlag="Y"
	..s NewItmObj.NISciId=SpecId
	..s NewItmObj.NIImportFlag=ImportFlag
	..s NewItmObj.NIBAFlag=BaFlag
	..s NewItmObj.NIModel=Model
	..s NewItmObj.NIBrand=BrandName
	..s NewItmObj.NIRegNo=RegNo
	..s NewItmObj.NIVendor=VendorDesc
	..s NewItmObj.NITemPurchase=TemPurchase
	..s NewItmObj.NICentralPurFlag=CentralPurFlag
	..s NewItmObj.NIBatchReq=BatchReq
	..s NewItmObj.NIExpReq=ExpReq
	..s Sc=NewItmObj.%Save()
	..i $$$ISERR(Sc) d
	...s Err=-11
	..i Err<0 q
	.i Err<0 tro 1  q
	.tc
	
	i Err<0 q Err
	q 0
}

/// 9.下载资质信息（任务）
/// w ##class(web.DHCSTMService.ECS.ECS2STMClient).getCertificates("","2022-06-16","2022-06-17","Vendor")
/// w ##class(web.DHCSTMService.ECS.ECS2STMClient).getCertificates("","2022-08-15","2022-08-17","Vendor")
ClassMethod getCertificates(IdStr, StartDate, EndDate, OrgType, HospId = "") As %String
{
	q:..GetUseFlag(HospId,.SerTypeId)'="Y" 0
	q:OrgType="" -1
	s MethodName="getCertificates"
	s Params=IdStr_";"_StartDate_";"_EndDate_";"_OrgType_";"_HospId
	d ##class(web.DHCSTMHUI.DHCDataExchangeLog).Log(.LogRowId,"",SerTypeId,$CLASSNAME(),MethodName,Params)
	
	s CloudType=""
	i OrgType="Vendor" s CloudType="supplier"
	e  i OrgType="Manf" s CloudType="factory"
	e  i OrgType="Inci" s CloudType="product"
	
	s JsonObj={}
	s DataArray=[]
	
	s IdArray=[]
	s Len=$l(IdStr,"^")
	f i=1:1:Len  d
	.s Id=$p(IdStr,"^",i)
	.d IdArray.%Push(Id)
	i IdStr'="" d
	.d JsonObj.%Set("ids",IdArray)
	d JsonObj.%Set("start_date",StartDate,"string")
	d JsonObj.%Set("end_date",EndDate,"string")
	d JsonObj.%Set("type",CloudType,"string")
	s Code="getCertificates"
	s Input=JsonObj.%ToJSON()
	s Ret=..GetResult(Code,Input,HospId)
	d ##class(web.DHCSTMHUI.DHCDataExchangeLog).Log(.LogRowId,Ret,SerTypeId)
	
	q:Ret="" -1
	s RetObj={}.%FromJSON(Ret)
	s State=RetObj.%Get("state")
	q:State'=1 -2
	s DatasObj=RetObj.%Get("data")
	q:DatasObj="" 0
	s DataSize=DatasObj.%Size()
	q:DataSize=0 0

	ts
	s Err=0,AllFileStr=""
	f i=0:1:(DataSize-1) d
	.s CertObj=DatasObj.%Get(i)
	.s Id=CertObj.%Get("id")
	.s CertId=CertObj.%Get("cert_id")
	.s CertType=CertObj.%Get("cert_type_code")			;资质类型Code(如营业执照-YYZZ,经营许可等)
	.s CertCode=CertObj.%Get("cert_code")
	.s CertName=CertObj.%Get("cert_name")
	.s BusScope=CertObj.%Get("business_scope") 			//经营范围
	.s Startdate=CertObj.%Get("start_date")
	.s Enddate=CertObj.%Get("end_date")
	.s LongFlag=CertObj.%Get("is_long")
	.i LongFlag="1" s LongFlag="Y",Enddate=""
	.e  s LongFlag="N"
	.s CertDate=CertObj.%Get("cert_date")
	.s IsStop=CertObj.%Get("is_stop")
	.i IsStop="1" s ShowFlag="N"
	.e  s ShowFlag="Y"
	.s IsNew=CertObj.%Get("is_new")
	.s (CERTRowId,CERTType,GrpType)=""
	.i (OrgType="Vendor")||(OrgType="Manf") d		//资质下载
	..s GrpType="Cert"
	..s CERTType=..GetCertType(OrgType,CertType)
	..i CERTType="" s Err=-3 b
	..q:Err'=0
	..q:CERTType=""			;未做对应的,不予处理
	..
	..s CERTText=CertCode
	..s CERTRowId=##class(web.DHCSTMHUI.DHCCertDetail).GetCertId(OrgType,Id,CERTType,CERTText)
	..s CERTIssuedDept=""
	..s CERTIssuedDate=Startdate
	..s CERTDateFrom=Startdate
	..s CERTDateTo=Enddate
	..s CERTBlankedFlag=LongFlag
	..s CERTDelayFlag=""
	..s CERTDelayDateTo=""
	..s CERTShowFlag=ShowFlag
	..s CertData=CERTType_"^"_CERTRowId_"^"_CERTText_"^"_CERTIssuedDept_"^"_CERTIssuedDate_"^"_CERTDateFrom_"^"_CERTDateTo_"^"_CERTBlankedFlag_"^"_CERTDelayFlag_"^"_CERTDelayDateTo_"^"_CERTShowFlag_"^"_HospId
	..s CertTitle="CERTType^CERTRowId^CERTText^CERTIssuedDept^CERTIssuedDate^CERTDateFrom^CERTDateTo^CERTBlankedFlag^CERTDelayFlag^CERTDelayDateTo^CERTShowFlag^HospId"
	..s CERTParams=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(CertData,CertTitle)
	..s RtnObj=##class(web.DHCSTMHUI.DHCCertDetail).SaveCertDetail(OrgType,Id,CERTParams)
	..i RtnObj.success<0 s Err=-4
	..q:Err'=0
	..s CERTRowId=RtnObj.rowid
	.e  i OrgType="Inci" d			//注册证号下载
	..s RegCertId=$s(CertCode'="":$o(^DHCMRCT(0,"NO",CertCode,""),-1),1:"")
	..s regTitle="MRCRowID^MRCNo^MRCApprovalDate^MRCValidUntil^MRCInciDesc^MRCValidExtend^MRCAppliedRange"
	..s regData=RegCertId_"^"_CertCode_"^"_Startdate_"^"_Enddate_"^"_CertName_"^"_""_"^"_BusScope
	..s regObj=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(regData,regTitle)
	..s paramstr=Id_"^"_""_"^"_""
	..s RtnObj=##class(web.DHCSTMHUI.DHCMatRegCert).save(regObj,paramstr)
	..i RtnObj.success'=0 s Err=-5
	..q:Err'=0
	.//图片信息下载
	.s CertFilesObj=CertObj.%Get("cert_files")
	.q:CertFilesObj=""
	.s CertFilesSize=CertFilesObj.%Size()
	.q:CertFilesSize=0
	.s FileStr=""
	.f j=0:1:(CertFilesSize-1) q:(Err'=0)  d
	..s FileObj=CertFilesObj.%Get(j)
	..s FileName=FileObj.%Get("file_name")
	..s FileNameO=FileObj.%Get("file_name_o")
	..s FileType=FileObj.%Get("file_type")			;附件类型
	..s FilePath=FileObj.%Get("file_path")			;ECS图片路径
	..s FileSize=FileObj.%Get("file_size")
	..s SizeUnit=FileObj.%Get("size_unit")
	..q:FileName=""
	..s PicId=""
	..&sql(SELECT %id into :PicId FROM DHC_ItmPicture WHERE IPIC_OrgType=:OrgType and IPIC_OrgId=:Id and 
		isnull(IPIC_GrpType,'')=:GrpType and isnull(IPIC_PointerType,'')=:CERTType and isnull(IPIC_Pointer,'')=:CERTRowId 
		and IPIC_FileSrc=:FileName)
	..q:(SQLCODE=0)&&(PicId'="")
	..&sql(insert into DHC_ItmPicture
		(IPIC_OrgType,IPIC_OrgId,IPIC_GrpType,IPIC_PointerType,IPIC_Pointer,IPIC_FileName,IPIC_FileSrc,IPIC_Active,IPIC_Type)
		values(:OrgType,:Id,:GrpType,:CERTType,:CERTRowId,:FileName,:FileName,'Y',:FileType))
	..i SQLCODE'=0 s Err=-6
	..q:Err'=0
	..s FileRowId=$G(%ROWID)
	..i FileStr="" d
	...s FileStr=""""_FileName_""""
	..e  d
	...s FileStr=FileStr_","_""""_FileName_""""
	.i FileStr'="" d
	..s FileStr="{""list"":["_"{""cert_id"":"""_CertId_""",""type"":"""_FileType_""",""file_names"":["_FileStr_"]}"_"]}"
	..i AllFileStr="" d
	...s AllFileStr=FileStr
	..e  d
	...s AllFileStr=AllFileStr_"^"_FileStr
	i Err'=0 d
	.tro
	q:Err'=0 Err
	tc
	
	i AllFileStr'="" d
	.s FileLen=$l(AllFileStr,"^")
	.f m=1:1:FileLen q:(Err'=0)  d
	..s OnceFileStr=$p(AllFileStr,"^",m)
	..s FileSFTPStr=..#FileSFTP
	..i FileSFTPStr="" d
	...job ..getFile(OnceFileStr,HospId)
	..e  d
	...job ..getFileSFTP(OnceFileStr)
	
	q 0
}

/// w ##class(web.DHCSTMService.ECS.ECS2STMClient).getFileSFTP("{""list"": [{""file_names"": [""1EO220121-1-3.txt"", ""196349862544181.pdf""],""cert_id"": ""585017080049633"",""type"": ""supplier""}]}")
ClassMethod getFileSFTP(OnceFileStr)
{
	s Err=0
	s FileSFTPStr=..#FileSFTP
	s Param=..sssParamStr()
	q:FileSFTPStr="" 0
	
	s ftpserver=$p(FileSFTPStr,"^",1)
	s username=$p(FileSFTPStr,"^",2)
	s password=$p(FileSFTPStr,"^",3)
	s port=$p(FileSFTPStr,"^",4)
	s path=$p(FileSFTPStr,"^",5)
	
	set ssh = ##class(%Net.SSH.Session).%New()
	do ssh.Connect(ftpserver,port)
	do ssh.AuthenticateWithUsername(username,password)
	do ssh.OpenSFTP(.sftp)
	
	s CertStr={}.%FromJSON(OnceFileStr)
	s CertObj=CertStr.%Get("list")
	q:CertObj="" 0
	s CertSize=CertObj.%Size()
	q:CertSize=0 0
	
	f i=0:1:(CertSize-1) q:(Err'=0)  d
	.s OneCertObj=CertObj.%Get(i)
	.s FileNamesObj=OneCertObj.%Get("file_names")
	.s FileSize=FileNamesObj.%Size()
	.f j=0:1:(FileSize-1) q:(Err'=0)  d
	..s FileName=FileNamesObj.%Get(j)
	..s FileDir=path_FileName
	..s stream =##class(%Stream.FileBinary).%New()
	..s sc= sftp.GetStream(FileDir,.stream)
	..i $$$ISERR(sc) s Err=-1
	..q:Err'=0
	..s result=##class(web.DHCSTMHUI.Common.FtpFile).UpFile(stream,Param,FileName)
	..i result'=0 s Err=-4
	..q:Err'=0
	..
	q Err
}

/// 每次处理一个资质的图片
/// w ##class(web.DHCSTMService.ECS.ECS2STMClient).getFile("{""list"": [{""file_names"": [""705830767252106.pdf"", ""196349862544181.pdf""],""cert_id"": ""585017080049633"",""type"": ""supplier""}]}",2)
ClassMethod getFile(OnceFileStr, HospId = "") As %String
{
	s Param=..sssParamStr()
	s Err=0
	//下载图片(放在事务外边)
	s AllFileData=..GetResult("getFiles",OnceFileStr,HospId)
	//d ##class(web.DHCSTMHUI.DHCDataExchangeLog).Log(.LogRowId,AllFileData,SerTypeId)
	q:AllFileData="" -1
	
	s AllFileObj={}.%FromJSON(AllFileData)
	s CertFileObj=AllFileObj.%Get("data")
	q:CertFileObj="" -2
	s FileSize=CertFileObj.%Size()
	q:FileSize=0 -3
	
	f i=0:1:(FileSize-1) q:(Err'=0)  d
	.s FileObj=CertFileObj.%Get(i)
	.s certid=FileObj.%Get("cert_id")
	.s type=FileObj.%Get("type")
	.s FileDataObj=FileObj.%Get("file_data")
	.q:FileDataObj=""
	.s FileDataSize=FileDataObj.%Size()
	.q:FileSize=0
	.f j=0:1:(FileDataSize-1) q:(Err'=0)  d
	..s FileNameObj=FileDataObj.%Get(j)
	..s FileName=FileNameObj.%Get("file_name")
	..s FileStr=FileNameObj.%Get("data")
	..q:FileStr=""
	..s File=##class(%FileBinaryStream).%New()
	..s byteList=##class(%SYSTEM.Encryption).Base64Decode(FileStr)
	..d File.Write(byteList)
	..d File.SaveStream()
	..d File.%Close()
	..s result=##class(web.DHCSTMHUI.Common.FtpFile).UpFile(File,Param,FileName)
	..i result'=0 s Err=-4
	..q:Err'=0
	..
	q Err
}

/// 10.上传订单信息
/// w ##class(web.DHCSTMService.ECS.ECS2STMClient).saveSupOrder(13,"")
ClassMethod saveSupOrder(inpo As %String, emflag As %String, HospId = "") As %String
{
	q:..GetUseFlag(HospId,.SerTypeId)'="Y" 0
	s MethodName="saveSupOrder"
	s Params=inpo_";"_emflag_";"_HospId
	d ##class(web.DHCSTMHUI.DHCDataExchangeLog).Log(.LogRowId,"",SerTypeId,$CLASSNAME(),MethodName,Params)
	
	q:inpo="" -1
	i emflag="" s emflag=0
	s JsonObj={}
	s DataArray=[]
	s ret =0
	s count=0
	s OrderJson={}
	s no=$P(^INPO(inpo),"^",1)
	s vendor=$P(^INPO(inpo),"^",2)
	s CloudId=$p(^APC("APCVM",vendor,1),"^",16)
	;q:CloudId="" ""     //供应商未对照情况
	s podate=$P(^INPO(inpo),"^",3)
	s PoUserId=$p(^INPO(inpo),"^",7)
	s demandDate=$P(^INPO(inpo),"^",13)
	s PoUserName=$s(PoUserId'="":$p(^SSU("SSUSR",PoUserId),"^",2),1:"")
	s (PoLoc,PoLocDesc,ReqLoc,ReqLocDesc)=""
	s DhcPoId=$o(^DHCINPO(0,"INPO",inpo,0))
	i DhcPoId'=""  d
	.s PoLoc=$p(^DHCINPO(DhcPoId),"^",2)		//科室
	.s ReqLoc=$p(^DHCINPO(DhcPoId),"^",5)
	
	;比如骨科向设备库请领, 设备库负责采购订单, 供应商直接送货给骨科病区.
	;则: 采购部门-设备库, 需求科室-骨科病区, 定向科室-骨科
	s (PoLocObj,ReqLocObj,OrientLocObj)=""
	;采购部门
	i PoLoc'="" d
	.s PoLocCode=$p(^CTLOC(PoLoc),"^",1)
	.s PoLocDesc=$p(^CTLOC(PoLoc),"^",2)
	.s LocType=..GetLocType(PoLoc)
	.s PoLocType=$s(LocType="A":"2",1:"1")		;1-科室, 2-库房
	.s PoLocObj={}
	.d PoLocObj.%Set("his_id",PoLoc,"string")
	.d PoLocObj.%Set("depart_code",PoLocCode,"string")
	.d PoLocObj.%Set("depart_name",PoLocDesc,"string")
	.d PoLocObj.%Set("depart_type",PoLocType,"string")
	
	;需求科室
	i ReqLoc'="" d
	.s ReqLocCode=$p(^CTLOC(ReqLoc),"^",1)
	.s ReqLocDesc=$p(^CTLOC(ReqLoc),"^",2)
	.s LocType=..GetLocType(ReqLoc)
	.s ReqLocType=$s(LocType="A":"2",1:"1")
	.s ReqLocObj={}
	.d ReqLocObj.%Set("his_id",ReqLoc,"string")
	.d ReqLocObj.%Set("depart_code",ReqLocCode,"string")
	.d ReqLocObj.%Set("depart_name",ReqLocDesc,"string")
	.d ReqLocObj.%Set("depart_type",ReqLocType,"string")
	
	s:podate'="" podate=$zd(podate,3)
	s:demandDate'="" demandDate=$zd(demandDate,3)
	
	;订单主表数据
	d OrderJson.%Set("sup_id",vendor,"string")
	d OrderJson.%Set("order_id",inpo,"string")
	d OrderJson.%Set("order_no",no,"string")
	d OrderJson.%Set("order_date",podate,"string")
	d OrderJson.%Set("send_date",$zdt($h,3,1),"string")
	d OrderJson.%Set("req_date",demandDate,"string")
	d OrderJson.%Set("rece_address","","string")
	d OrderJson.%Set("rece_dept",ReqLocDesc,"string")	//需求科室
	d OrderJson.%Set("demand_dept",PoLocDesc,"string")	//需求仓库
	d OrderJson.%Set("orient_dept","","string")
	d OrderJson.%Set("send_oper",PoUserName,"string")
	d OrderJson.%Set("bill_type",1,"number")			//订单类型先默认处理
	d OrderJson.%Set("note","","string")
	;demand_dept_obj, rece_dept_obj, orient_dept_obj	//使用obj格式
	//d OrderJson.%Set("demand_dept_obj",PoLocObj)
	//d OrderJson.%Set("rece_dept_obj",ReqLocObj)
	//d OrderJson.%Set("orient_dept_obj",OrientLocObj)
	s detailArray=[]
	
	s sub="",ret=0,count=0 
	f  s sub=$o(^INPO(inpo,"POI",sub)) q:sub=""  d
	.s inpoitmid=inpo_"||"_sub
	.s inci=$p(^INPO(inpo,"POI",sub),"^",1)
	.s InciFlag=..GetInciFlag(inci)
	.q:InciFlag'="Y"
	.s HVFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(inci)
	.s InciCode=$p(^INCI(inci,1),"^",1) ;代码
	.s InciDesc=$p(^INCI(inci,1),"^",2) ;描述
	.s qty=$p(^INPO(inpo,"POI",sub),"^",7)
	.s uomdr=$p(^INPO(inpo,"POI",sub),"^",3)
	.s rp=$p(^INPO(inpo,"POI",sub),"^",4)
	.
	.s remark="",inSpec=""
	.&sql(SELECT INPOI_Remarks into :remark  FROM IN_POItm WHERE IN_POItm=:inpoitmid)
	.;&sql(SELECT POI_SpecList into :inSpec FROM DHC_INPOItm WHERE POI_INPOI_DR=:inpoitmid)
	.s MemoDelim=##class(web.DHCSTMHUI.Common.UtilCommon).MemoDelim()
	.s remark=$lts(remark,MemoDelim)
	.
	.;2022-06: 改为按照订单上的单位,数量,价格, 不做转换
	.s UomDesc=$p(^CT("UOM",uomdr),"^",2)
	.
	.s detailJson={}
	.d detailJson.%Set("or_detail_id",inpoitmid,"string")
	.d detailJson.%Set("inv_id",inci,"string")			;暂时hosp_goodid和inv_id都传
	.d detailJson.%Set("amount",qty,"number")
	.d detailJson.%Set("price",rp,"number")
	.d detailJson.%Set("amount_money",qty*rp,"number")
	.d detailJson.%Set("note",remark,"string")
	.d detailJson.%Set("req_date",demandDate,"string")
	.d detailJson.%Set("unit_name",UomDesc,"string")
	.d detailArray.%Push(detailJson)
	.s count = count +1
	
	q:count=0 ret
	d OrderJson.%Set("detail",detailArray)
	d DataArray.%Push(OrderJson)
	d JsonObj.%Set("list",DataArray)
	s Code="postOrders"
	s Input=JsonObj.%ToJSON()
	s Ret=..GetResult(Code,Input,HospId)
	d ##class(web.DHCSTMHUI.DHCDataExchangeLog).Log(.LogRowId,Ret,SerTypeId)
	q Ret
}

/// 11.上传订单状态
/// w ##class(web.DHCSTMService.ECS.ECS2STMClient).postOrdersState("10||1^11||1","quick")
ClassMethod postOrdersState(InpoiStr, state, HospId = "") As %String
{
	q:..GetUseFlag(HospId,.SerTypeId)'="Y" 0
	s MethodName="postOrdersState"
	s Params=InpoiStr_";"_state_";"_HospId
	d ##class(web.DHCSTMHUI.DHCDataExchangeLog).Log(.LogRowId,"",SerTypeId,$CLASSNAME(),MethodName,Params)
	q:(InpoiStr="")||(state="") -1
	
	s JsonObj={}
	s DataArray=[]
	
	s InpoiArray=[]
	s Len=$l(InpoiStr,"^")
	f i=1:1:Len  d
	.s InpoiId=$p(InpoiStr,"^",i)
	.d InpoiArray.%Push(InpoiId)
	i InpoiStr'="" d
	.d JsonObj.%Set("ids",InpoiArray)
	d JsonObj.%Set("state",state,"string")
	s Code="postOrdersState"
	s Input=JsonObj.%ToJSON()
	s Ret=..GetResult(Code,Input,HospId)
	d ##class(web.DHCSTMHUI.DHCDataExchangeLog).Log(.LogRowId,Ret,SerTypeId)
	q Ret
}

/// 12.下载订单状态（任务）
/// w ##class(web.DHCSTMService.ECS.ECS2STMClient).getOrdersState("","2021-07-27","2021-07-27","00:00:00","17:00:00")
ClassMethod getOrdersState(InpoStr, StartDate, EndDate, HospId = "") As %String
{
	q:..GetUseFlag(HospId,.SerTypeId)'="Y" 0
	s MethodName="getOrdersState"
	s Params=InpoStr_";"_StartDate_";"_EndDate_";"_HospId
	d ##class(web.DHCSTMHUI.DHCDataExchangeLog).Log(.LogRowId,"",SerTypeId,$CLASSNAME(),MethodName,Params)
	q:(InpoStr="")&&((StartDate="")||(EndDate="")) -1
	
	s JsonObj={}
	s DataArray=[]
	
	s InpoArray=[]
	s Len=$l(InpoStr,"^")
	f i=1:1:Len  d
	.s Inpo=$p(InpoStr,"^",i)
	.d InpoArray.%Push(Inpo)
	i InpoStr'="" d
	.d JsonObj.%Set("ids",InpoArray)
	d JsonObj.%Set("start_date",StartDate,"string")
	d JsonObj.%Set("end_date",EndDate,"string")
	s Code="getOrdersState"
	s Input=JsonObj.%ToJSON()
	s Ret=..GetResult(Code,Input,HospId)
	d ##class(web.DHCSTMHUI.DHCDataExchangeLog).Log(.LogRowId,Ret,SerTypeId)
	
	q:Ret="" -1
	s RetObj={}.%FromJSON(Ret)
	s State=RetObj.%Get("state")
	q:State'=1 -2
	s DatasObj=RetObj.%Get("data")
	q:DatasObj="" 0
	s DataSize=DatasObj.%Size()
	q:DataSize=0 0

	s Err=0
	f i=0:1:(DataSize-1) d
	.s InpoObj=DatasObj.%Get(i)
	.s Inpo=InpoObj.%Get("order_id")
	.s state=InpoObj.%Get("state")
	.s DhcPo=$o(^DHCINPO(0,"INPO",Inpo,""))
	.i DhcPo'=""  d
	..s DhcPoObj=##class(User.DHCINPO).%OpenId(DhcPo)
	..s DhcPoObj.POPlatStat=state
	..s Sc=DhcPoObj.%Save()
	..i $$$ISERR(Sc) s Err=-3
	.q:Err<0
	
	q:Err<0 Err
	
	q 0
}

/// 13.下载配送单信息
/// Description:扫描供应商平台随行单获取订单信息
/// Input:		随行单号barcode, 高值标记("":所有,Y:仅高值,N:仅低值), needCheck(0:未验收,1:已验收,"":全部)
/// Output:		
/// Return:		
/// w ##class(web.DHCSTMService.ECS.ECS2STMClient).getOrderDetail("202107290005","N","")
ClassMethod getOrderDetail(SxNo As %String, HVFlag As %String, needCheck, HospId = "") As %String
{
	q:..GetUseFlag(HospId,.SerTypeId)'="Y" "{}"
	s MethodName="getOrderDetail"
	s Params=SxNo_";"_HVFlag_";"_needCheck_";"_HospId
	d ##class(web.DHCSTMHUI.DHCDataExchangeLog).Log(.LogRowId,"",SerTypeId,$CLASSNAME(),MethodName,Params)
	
	s JsonObj={}
	s:HVFlag'="Y" HVFlag=0
	s:HVFlag="Y" HVFlag=1
	d JsonObj.%Set("ps_no",SxNo)
	d JsonObj.%Set("hv_flag",HVFlag)
	i (needCheck'=0)&&(needCheck'=1) s needCheck=2
	d JsonObj.%Set("need_check",needCheck)
	s Code="getDistributions"
	s Input=JsonObj.%ToJSON()
	s ret=..GetResult(Code,Input,HospId)
	d ##class(web.DHCSTMHUI.DHCDataExchangeLog).Log(.LogRowId,ret,SerTypeId)
	q:ret="" "{}"
	
	s JsonObj={}.%FromJSON(ret)
	s State=JsonObj.%Get("state")
	q:State'=1 "{}"
	s dataJson=JsonObj.%Get("data").%Get(0)
	s detailJson=dataJson.%Get("detail")
	q:detailJson="" "{}"
	s RowsSize=detailJson.%Size()
	q:RowsSize=0 "{}"
	
	s:HVFlag=0 HVFlag="N"
	s:HVFlag=1 HVFlag="Y"
	s Inpo=dataJson.%Get("order_id")
	s (PoNo,PoVendor,PoDate,PoApproved,PoLoc,PoReqLoc,DeliveryId,PoState)=""
	i Inpo'="" d
	.&sql(SELECT INPO_No ,INPO_APCVM_DR ,INPO_Date ,INPO_Approved
		into :PoNo,:PoVendor,:PoDate,:PoApproved
		FROM IN_PO where %ID=:Inpo)
	.&sql(select PO_CTLOC_DR,PO_ReqLoc_DR into :PoLoc,:PoReqLoc from DHC_INPO where PO_INPO_DR=:Inpo)
	e  d
	.s PoVendor=dataJson.%Get("sup_id")
	.s PoDate=dataJson.%Get("create_date")
	.s:PoDate'="" PoDate=$zdh(PoDate,3)
	.s PoLocDesc=dataJson.%Get("rece_dept")
	.s PoLoc=$s(PoLocDesc'="":$o(^CTLOC(0,"Desc",PoLocDesc,0)),1:"")
	.i (PoLoc="")&&$d(%session) s PoLoc=$G(%session.Data("LOGON.CTLOCID"))
	s DeliveryId=dataJson.%Get("ps_id")
	s PoState=dataJson.%Get("state")
	s PoVenDesc=$s(PoVendor'="":$p(^APC("APCVM",PoVendor),"^",3),1:"")
	s:PoDate'="" PoDate=$zd(PoDate,3)
	s PoLocDesc=$s(PoLoc'="":$p(^CTLOC(PoLoc),"^",2),1:"")
	s PoReqLocDesc=$s(PoReqLoc'="":$p(^CTLOC(PoReqLoc),"^",2),1:"")
	s SCIPoVendor=##class(web.DHCSTMHUI.StkTypeM).sssComboStr(PoVendor,PoVenDesc)
	s SCIPoReqLoc=##class(web.DHCSTMHUI.StkTypeM).sssComboStr(PoReqLoc,PoReqLocDesc)
	s SCIPoLoc=##class(web.DHCSTMHUI.StkTypeM).sssComboStr(PoLoc,PoLocDesc)
	s ListDetail=PoNo_"^"_PoVendor_"^"_PoVenDesc_"^"_PoDate_"^"_PoApproved
		_"^"_PoLoc_"^"_PoLocDesc_"^"_PoReqLoc_"^"_PoReqLocDesc_"^"_SCIPoVendor
		_"^"_SCIPoReqLoc_"^"_SCIPoLoc_"^"_SxNo_"^"_PoState
	s Title="SCIPoNo^PoVendor^PoVenDesc^SCIPoDate^PoApproved"
		_"^PoLoc^PoLocDesc^PoReqLoc^PoReqLocDesc^SCIPoVendor"
		_"^SCIPoReqLoc^SCIPoLoc^SCINo^PoState"
	s Rtn=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(ListDetail,Title)
	w "{"_$c(34)_"Main"_$c(34)_":"_Rtn_","_$c(34)_"Detail"_$c(34)_":"
	s Err=0
	s Count=0
	s json=##class(web.DHCSTMHUI.Common.JsonObj).%New()
	f i=0:1:(RowsSize-1) q:Err<0  d
	.s inGdRecItmObj=detailJson.%Get(i)
	.s OrderDetailSubId=inGdRecItmObj.%Get("ps_detail_id")
	.s PoItmId=inGdRecItmObj.%Get("order_detail_id")
	.s BatNo=inGdRecItmObj.%Get("batch_no")
	.s ExpDate=inGdRecItmObj.%Get("inva_date")
	.s ProduceDate=inGdRecItmObj.%Get("fac_date")
	.s Qty=inGdRecItmObj.%Get("amount")
	.s PSInci=inGdRecItmObj.%Get("inv_id")
	.s Price=inGdRecItmObj.%Get("price")
	.s label=inGdRecItmObj.%Get("bar_code")				;ECS配送单,高值明细数量都为1
	.s BatchCode=inGdRecItmObj.%Get("origin_barcode")	;高值批次码,数量可不为1
	.s SterilizedNo=inGdRecItmObj.%Get("disinfect_no")	//灭菌批号
	.s OriginalCode=""
	.i ExpDate'="" d
	..s ExpDate=$zdh(ExpDate,3)
	..s ExpDate=..DL2H(ExpDate)
	.
	.i ProduceDate'="" d
	..s ProduceDate=$zdh(ProduceDate,3)
	..s ProduceDate=..DL2H(ProduceDate)
	.
	.s HighValueFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(PSInci)
	.q:((HVFlag'="")&&(HVFlag'=HighValueFlag))
	.
	.q:(label'="")&&$d(^DHCIT(0,"LABEL",label))		;已经导入的高值条码,不再处理
	.
	.s DHCITID=""
	.i label'="" d
	..s DHCITID=$o(^DHCIT(0,"LABEL",label,0))
	.e  i BatchCode'="" d
	..s DHCITID=$o(^DHCIT(0,"LABEL",BatchCode,0))
	.s AvaQty=Qty
	.s AvaBarcodeQty=Qty		;还可以入库的数量(条码)--ECS一个发货明细对应一个条码
	.q:AvaBarcodeQty<=0
	.s BarcodeQty=0
	.s (IncId,PurUomId,PurUom,Rp,PurQty)=""
	.i PoItmId'="" d
	..&sql(SELECT INPOI_INCI_DR, INPOI_CTUOM_DR,INPOI_UnitCost,INPOI_Pur_Qty
		into
		:IncId,:PurUomId,:Rp,:PurQty
		FROM IN_PoItm WHERE IN_POItm =:PoItmId)
	..s BUomId=$p(^INCI(IncId,1),"^",10)
	..s BPFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PurUomId,BUomId)
	..s AvaQty=AvaQty/BPFac
	.e  d
	..;直接发货的单据
	..s IncId=PSInci,Rp=Price
	..s PurUomId=$p(^INCI(IncId,1),"^",10)		;默认使用基本单位
	.q:IncId'=PSInci
	.s ImpQty=+##class(web.DHCSTMHUI.INPOItm).GetImpQty(PoItmId,PurUomId)
	.s PurUom=""
	.s:PurUomId'="" PurUom=$p(^CT("UOM",PurUomId),"^",2)
	.s IncCode=$p(^INCI(IncId,1),"^",1)
	.s IncDesc=$p(^INCI(IncId,1),"^",2)
	.s Param="^"_PoLoc_"^"
	.s ItmDefaultInfo=##class(web.DHCSTMHUI.DHCINGdRec).GetItmInfo(IncId,Param)
	.s ItmDefaultInfoJson={}.%FromJSON(ItmDefaultInfo)
	.s ManfId=ItmDefaultInfoJson.%Get("ManfId")
	.s Manf=ItmDefaultInfoJson.%Get("ManfDesc")
	.s Sp=ItmDefaultInfoJson.%Get("Sp")
	.s BUomId=ItmDefaultInfoJson.%Get("BUomId")
	.s ConFac=ItmDefaultInfoJson.%Get("ConFac")
	.s BatchReq=$p(^INCI(IncId,2),"^",10)
	.s ExpReq=$p(^INCI(IncId,2),"^",11)
	.s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",IncId) ;规格
	.s Reqi=##class(web.DHCSTMHUI.DHCINReqItmMoveStatus).GetInrqi(PoItmId,"PO")
	.s (INRQIType,INRQICanceled,reqremark,qtyApproved,SpecDesc)=""
	.i Reqi'="" d
	..s dhcinrqi=$o(^DHCINRQI(0,"INRQI",Reqi,""))
	..q:dhcinrqi=""
	..s INRQIType=$p(^DHCINRQI(dhcinrqi),"^",7)
	..s INRQICanceled=$p(^DHCINRQI(dhcinrqi),"^",8)
	..s remark=$p(^DHCINRQI(dhcinrqi),"^",2)
	..s qtyApproved=$p(^DHCINRQI(dhcinrqi),"^",3)
	..s SpecDesc=$p(^DHCINRQI(dhcinrqi),"^",6)
	.s CerInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetCert(IncId)
	.s CerNo=$p(CerInfo,"^",1)
	.s CerExpDate=$p(CerInfo,"^",2)
	.s BatchCodeFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetBatchCodeFlag(IncId)
	.s Data1=PoItmId_"^"_IncId_"^"_IncCode_"^"_IncDesc_"^"_PurUomId_"^"_PurUom_"^"_AvaQty_"^"_Rp_"^"_ManfId_"^"_Manf
	.s Data2=Sp_"^"_BatNo_"^"_ExpDate_"^"_BUomId_"^"_ConFac_"^"_PurQty_"^"_ImpQty_"^"_BatchReq_"^"_ExpReq_"^"_Spec
	.s Data3=BarcodeQty_"^"_AvaBarcodeQty_"^"_SpecDesc_"^"_CerNo_"^"_CerExpDate_"^"_HighValueFlag_"^"_label_"^"_OrderDetailSubId_"^"_ProduceDate_"^"_OriginalCode
	.s Data4=BatNo_"^"_DeliveryId_"^"_BatchCode_"^"_DHCITID_"^"_BatchCodeFlag
	.s Data=Data1_"^"_Data2_"^"_Data3_"^"_Data4
	.s Count=Count+1
	.d json.InsertRowData(Data)
	s Title="PoItmId^IncId^IncCode^IncDesc^PurUomId^PurUom^AvaQty^Rp^ManfId^Manf"
		_"^Sp^BatNo^ExpDate^BUomId^ConFac^PurQty^ImpQty^BatchReq^ExpReq^Spec"
		_"^BarcodeQty^AvaBarcodeQty^SpecDesc^CerNo^CerExpDate^HighValueFlag^BarCode^OrderDetailSubId^ProduceDate^OriginalCode"
		_"^BatchNo^DeliveryId^BatchCode^DHCITID^BatchCodeFlag"
	d json.getJsonData(Title,Count)
	k json
	w "}"
	q ""
}

/// 14.下载配送单信息
/// 根据单号直接生成入库单(暂只处理低值单据)
/// w ##class(web.DHCSTMService.ECS.ECS2STMClient).CreateIngrBySxNo("202107300001",163,6423)
ClassMethod CreateIngrBySxNo(barcode As %String, LocId As %String, UserId As %String, HospId = "") As %String
{
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	q:..GetUseFlag(HospId,.SerTypeId)'="Y" RtnObj
	s MethodName="CreateIngrBySxNo"
	s Params=barcode_";"_LocId_";"_UserId_";"_HospId
	d ##class(web.DHCSTMHUI.DHCDataExchangeLog).Log(.LogRowId,"",SerTypeId,$CLASSNAME(),MethodName,Params)
	
	s HVFlag=0,needCheck="2"
	s JsonObj={}
	d JsonObj.%Set("ps_no",barcode)
	d JsonObj.%Set("hv_flag",HVFlag)
	i (needCheck'=0)&&(needCheck'=1) s needCheck=2
	d JsonObj.%Set("need_check",needCheck)
	s Code="getDistributions"
	s Input=JsonObj.%ToJSON()
	s ret=..GetResult(Code,Input,HospId)
	d ##class(web.DHCSTMHUI.DHCDataExchangeLog).Log(.LogRowId,ret,SerTypeId)
	q:ret="" RtnObj.Err(-1,"","接口调用失败!")
	
	s JsonObj={}.%FromJSON(ret)
	s State=JsonObj.%Get("state")
	q:State'=1 RtnObj.Err(-1,"","接口调用失败!")
	
	s dataJson=JsonObj.%Get("data").%Get(0)
	s detailJson=dataJson.%Get("detail")
	q:detailJson="" RtnObj.Err(-1,"","没有需要保存的明细!")
	s RowsSize=detailJson.%Size()
	q:RowsSize=0 RtnObj.Err(-1,"","没有需要保存的明细!")
	
	s:HVFlag=0 HVFlag="N"
	s:HVFlag=1 HVFlag="Y"
	s Inpo=dataJson.%Get("order_id")
	s (PoNo,PoVendor,PoDate,PoApproved,PoLoc,PoReqLoc)=""
	i Inpo'="" d
	.&sql(SELECT INPO_No ,INPO_APCVM_DR ,INPO_Date ,INPO_Approved
		into :PoNo,:PoVendor,:PoDate,:PoApproved
		FROM IN_PO where %ID=:Inpo)
	.&sql(select PO_CTLOC_DR,PO_ReqLoc_DR into :PoLoc,:PoReqLoc from DHC_INPO where PO_INPO_DR=:Inpo)
	e  d
	.s PoVendor=dataJson.%Get("sup_id")
	.s PoDate=dataJson.%Get("create_date")
	.s:PoDate'="" PoDate=$zdh(PoDate,3)
	.s PoLocDesc=dataJson.%Get("rece_dept")
	.s PoLocDesc=$$ALPHAUP^SSUTIL4(PoLocDesc)
	.s PoLoc=$s(PoLocDesc'="":$o(^CTLOC(0,"Desc",PoLocDesc,0)),1:"")
	.i (PoLoc="")&&$d(%session) s PoLoc=$G(%session.Data("LOGON.CTLOCID"))
	s DeliveryId=dataJson.%Get("ps_id")
	s PoVenDesc=$s(PoVendor'="":$p(^APC("APCVM",PoVendor),"^",3),1:"")
	s:PoDate'="" PoDate=$zd(PoDate,3)
	s PoLocDesc=$s(PoLoc'="":$p(^CTLOC(PoLoc),"^",2),1:"")
	s PoReqLocDesc=$s(PoReqLoc'="":$p(^CTLOC(PoReqLoc),"^",2),1:"")
	s SCIPoVendor=##class(web.DHCSTMHUI.StkTypeM).sssComboStr(PoVendor,PoVenDesc)
	s SCIPoReqLoc=##class(web.DHCSTMHUI.StkTypeM).sssComboStr(PoReqLoc,PoReqLocDesc)
	s SCIPoLoc=##class(web.DHCSTMHUI.StkTypeM).sssComboStr(PoLoc,PoLocDesc)
	
	s MainData="^"_PoVendor_"^"_LocId_"^"_UserId_"^N^N^^^^"_Inpo
		_"^^^"_PoReqLoc_"^"_barcode_"^^^"
	s MainTitle="IngrId^ApcvmDr^RecLoc^gUserId^GiftFlag^AdjCheque^IngrTypeId^PurchaseUser^StkGrpId^PoId"
		_"^InGrRemarks^SourceOfFund^ReqLocId^SynBarcode^InitId^AcceptUserId^OeriRecflag"
	s MainDataJson=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(MainData,MainTitle)
	
	s IngriTitle="RowId^IncId^BatchNo^ExpDate^ManfId^IngrUomId^Rp^HVBarCode^RecQty^NewSp"
		_"^SxNo^InvNo^InvDate^Inpoi^Remark^Remarks^QualityNo^MtDr^SterilizedNo^AdmNo"
		_"^AdmExpdate^InvMoney^SpecDesc^OrderDetailSubId^reqLocId^Sp^Tax"
	s DetailStream=##class(%GlobalCharacterStream).%New()
	d DetailStream.Write("[")
	
	s Err=0
	s Count=0
	f i=0:1:(RowsSize-1) q:Err<0  d
	.s inGdRecItmObj=detailJson.%Get(i)
	.s OrderDetailSubId=inGdRecItmObj.%Get("detail_id")
	.s PoItmId=inGdRecItmObj.%Get("order_detail_id")
	.s BatNo=inGdRecItmObj.%Get("batch_no")
	.s ExpDate=inGdRecItmObj.%Get("inva_date")
	.i ExpDate'="" d
	..s ExpDate=$zdh(ExpDate,3)
	..s ExpDate=..DL2H(ExpDate)
	.s ProduceDate=inGdRecItmObj.%Get("fac_date")
	.i ProduceDate'="" d
	..s ProduceDate=$zdh(ProduceDate,3)
	..s ProduceDate=..DL2H(ProduceDate)
	.
	.s Qty=inGdRecItmObj.%Get("amount")
	.s PSInci=inGdRecItmObj.%Get("inv_id")
	.s Price=inGdRecItmObj.%Get("price")
	.s HighValueFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(PSInci)
	.q:((HVFlag'="")&&(HVFlag'=HighValueFlag))
	.s label=inGdRecItmObj.%Get("bar_code")				;ECS配送单,高值明细数量都为1
	.s BatchCode=inGdRecItmObj.%Get("origin_barcode")	;高值批次码,数量可不为1
	.q:(label'="")&&$d(^DHCIT(0,"LABEL",label))			;已经导入的高值条码,不再处理
	.s SterilizedNo=inGdRecItmObj.%Get("disinfect_no")	//灭菌批号
	.
	.s DHCITID=""
	.i label'="" d
	..s DHCITID=$o(^DHCIT(0,"LABEL",label,0))
	.e  i BatchCode'="" d
	..s DHCITID=$o(^DHCIT(0,"BatchCode",BatchCode,0))
	.
	.i DHCITID'="" d
	..s label=$p(^DHCIT(DHCITID),"^",2)
	.
	.s AvaQty=Qty
	.s AvaBarcodeQty=Qty		;还可以入库的数量(条码)--ECS一个发货明细对应一个条码
	.q:AvaBarcodeQty<=0
	.s BarcodeQty=0
	.
	.s (IncId,PurUomId,PurUom,Rp,PurQty,InvNo,InvDate)=""
	.i PoItmId'="" d
	..&sql(SELECT INPOI_INCI_DR, INPOI_CTUOM_DR,INPOI_UnitCost,INPOI_Pur_Qty
		into
		:IncId,:PurUomId,:Rp,:PurQty
		FROM IN_PoItm WHERE IN_POItm =:PoItmId)
	.e  d
	..;直接发货的单据
	..s IncId=PSInci,Rp=Price
	..s PurUomId=$p(^INCI(IncId,1),"^",10)		;默认使用基本单位
	.q:IncId'=PSInci
	.
	.s ImpQty=+##class(web.DHCSTMHUI.INPOItm).GetImpQty(PoItmId,PurUomId)
	.
	.s PurUom=""
	.s:PurUomId'="" PurUom=$p(^CT("UOM",PurUomId),"^",2)
	.s IncCode=$p(^INCI(IncId,1),"^",1)
	.s IncDesc=$p(^INCI(IncId,1),"^",2)
	.s Param="^"_PoLoc_"^"
	.s ItmDefaultInfo=##class(web.DHCSTMHUI.DHCINGdRec).GetItmInfo(IncId,Param)
	.s ItmDefaultInfoJson={}.%FromJSON(ItmDefaultInfo)
	.s ManfId=ItmDefaultInfoJson.%Get("ManfId")
	.s Manf=ItmDefaultInfoJson.%Get("ManfDesc")
	.s Sp=ItmDefaultInfoJson.%Get("Sp")
	.s BUomId=ItmDefaultInfoJson.%Get("BUomId")
	.s ConFac=ItmDefaultInfoJson.%Get("ConFac") 
	.s BatchReq=$p(^INCI(IncId,2),"^",10)
	.s ExpReq=$p(^INCI(IncId,2),"^",11)
	.s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",IncId) ;规格
	.s Reqi=##class(web.DHCSTMHUI.DHCINReqItmMoveStatus).GetInrqi(PoItmId,"PO")
	.s (INRQIType,INRQICanceled,reqremark,qtyApproved,SpecDesc)=""
	.
	.i Reqi'="" d
	..s dhcinrqi=$o(^DHCINRQI(0,"INRQI",Reqi,""))
	..q:dhcinrqi=""
	..s INRQIType=$p(^DHCINRQI(dhcinrqi),"^",7)
	..s INRQICanceled=$p(^DHCINRQI(dhcinrqi),"^",8)
	..s remark=$p(^DHCINRQI(dhcinrqi),"^",2)
	..s qtyApproved=$p(^DHCINRQI(dhcinrqi),"^",3)
	..s SpecDesc=$p(^DHCINRQI(dhcinrqi),"^",6)
	.s CerInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetCert(IncId)
	.s CerNo=$p(CerInfo,"^",1)
	.s CerExpDate=$p(CerInfo,"^",2)
	.s BatchCodeFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetBatchCodeFlag(IncId)
	.
	.s IngriData1="^"_IncId_"^"_BatNo_"^"_ExpDate_"^"_ManfId_"^"_PurUomId_"^"_Rp_"^"_label_"^"_Qty_"^"_Sp
	.s IngriData2="^"_InvNo_"^"_InvDate_"^"_PoItmId_"^^^^^^"_CerNo
	.s IngriData3=CerExpDate_"^^^"_OrderDetailSubId_"^^"_Sp_"^"
	.s IngriData=IngriData1_"^"_IngriData2_"^"_IngriData3
	.s IngriJson=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(IngriData,IngriTitle)
	.i i=1 d DetailStream.Write(IngriJson)
	.e  d DetailStream.Write(","_IngriJson)
	d DetailStream.Write("]")
	
	ts
	s RtnObj=##class(web.DHCSTMHUI.DHCINGdRec).Save(MainDataJson,DetailStream)
	i RtnObj.success<0  tro  q RtnObj
	tc
	q RtnObj
}

/// 上传验收信息
/// CreateDate:	2020-08-17
/// Description:配送单验收
/// Input:		json
/// Output:		
/// Return:		
/// w ##class(web.DHCSTMService.ECS.ECS2STMClient).psAccept("{""list"":[{""ps_detail_id"":""256127252627208"",""amount"":3}]}")
ClassMethod psAccept(AcceptInfo As %String, HospId = "") As %String
{
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	q:..GetUseFlag(HospId,.SerTypeId)'="Y" RtnObj.Json()
	s MethodName="psAccept"
	s Params=AcceptInfo_";"_HospId
	d ##class(web.DHCSTMHUI.DHCDataExchangeLog).Log(.LogRowId,"",SerTypeId,$CLASSNAME(),MethodName,Params)
	
	s Code="postAccepts"
	s Input=AcceptInfo
	s RetStr=..GetResult(Code,Input,HospId)
	d ##class(web.DHCSTMHUI.DHCDataExchangeLog).Log(.LogRowId,RetStr,SerTypeId)
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(RetStr)
	s State=PJObj.%Get("state")
	
	i State'=1 s RtnObj.success=-1
	s RtnObj.msg=PJObj.%Get("msg")
	
	q RtnObj.Json()
}

/// 16.上传入库信息
/// 入库单保存时调用
/// w ##class(web.DHCSTMService.ECS.ECS2STMClient).SaveIngr()
ClassMethod SaveIngr(IngrId As %String, HospId = "") As %String
{
	q:..GetUseFlag(HospId,.SerTypeId)'="Y" 0
	s MethodName="SaveIngr"
	s Params=IngrId_";"_HospId
	d ##class(web.DHCSTMHUI.DHCDataExchangeLog).Log(.LogRowId,"",SerTypeId,$CLASSNAME(),MethodName,Params)
	s ret=0
	s Count=0
	s JsonObj={}
	s DataArray=[]
	s IngrDate=$p(^DHCINGR(IngrId),"^",14)
	s IngrDate=$zd(IngrDate,3)
	s IngrTime=$p(^DHCINGR(IngrId),"^",14)
	s IngrTime=$zt(IngrTime,1)
	s IngrDate=IngrDate_" "_IngrTime
	s Ch=0
	f  s Ch=$o(^DHCINGR(IngrId,"GRI",Ch)) q:Ch=""  d
	.s InciId=$p(^DHCINGR(IngrId,"GRI",Ch),"^",25)
	.s OrderDetailSubId=$p(^DHCINGR(IngrId,"GRI",Ch),"^",64)
	.q:OrderDetailSubId=""
	.
	.s BUomId=$p(^INCI(InciId,1),"^",10)
	.s BUomDesc=$p(^CT("UOM",BUomId),"^",2)
	.s inamount=0		;计算求和
	.
	.s SumIngrId=0,IngrNoArr=[]
	.f  s SumIngrId=$o(^DHCINGR(0,"DetailSubId",OrderDetailSubId,SumIngrId)) q:SumIngrId=""  d
	..s IngrNo=$p(^DHCINGR(SumIngrId),"^",1)
	..d IngrNoArr.%Push(IngrNo)
	..s SumIngrCh=0
	..f  s SumIngrCh=$o(^DHCINGR(0,"DetailSubId",OrderDetailSubId,SumIngrId,SumIngrCh)) q:SumIngrCh=""  d
	...s SumIngriData=^DHCINGR(SumIngrId,"GRI",SumIngrCh)
	...s IngriQty=$p(SumIngriData,"^",4)
	...s UomId=$p(SumIngriData,"^",10)
	...s UomFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(UomId,BUomId)
	...s IngriQty=IngriQty*UomFac
	...s inamount=inamount+IngriQty
	..s IngrJsonObj={}
	..s IngrDataArray=[]
	..d IngrJsonObj.%Set("ingr_no",IngrNo,"string")
	..d IngrJsonObj.%Set("ingr_amount",inamount,"string")
	..d IngrJsonObj.%Set("ingr_date",IngrDate,"string")
	..d IngrDataArray.%Push(IngrJsonObj)
	.s OrderDetail={}
	.d OrderDetail.%Set("ps_detail_id",OrderDetailSubId,"string")
	.d OrderDetail.%Set("in_amount",inamount,"string")
	.d OrderDetail.%Set("reject_amount","","string")
	.d OrderDetail.%Set("ingrs",IngrDataArray)
	.d OrderDetail.%Set("unit_name",BUomDesc,"string")
	.
	.d DataArray.%Push(OrderDetail)
	.s Count=Count+1
	q:Count=0 ""
	d JsonObj.%Set("list",DataArray)
	s Code="postStockIns"
	s Input=JsonObj.%ToJSON()
	s Ret=..GetResult(Code,Input,HospId)
	d ##class(web.DHCSTMHUI.DHCDataExchangeLog).Log(.LogRowId,Ret,SerTypeId)
	q Ret
}

/// 17.上传入库信息
/// 入库删除明细时调用
/// 根据主表遍历子表数据
/// 第一：获取detail_id 和数量
/// w ##class(web.DHCSTMService.ECS.ECS2STMClient).DeleteIngrItm("40||1")
ClassMethod DeleteIngrItm(rowid As %String, HospId = "") As %String
{
	q:..GetUseFlag(HospId,.SerTypeId)'="Y" 0
	s MethodName="DeleteIngrItm"
	s Params=rowid_";"_HospId
	d ##class(web.DHCSTMHUI.DHCDataExchangeLog).Log(.LogRowId,"",SerTypeId,$CLASSNAME(),MethodName,Params)
	
	s IngrId=+rowid
	s ret=0
	s Count=0
	s JsonObj={}
	s DataArray=[]
	s IngrDate=$p(^DHCINGR(IngrId),"^",14)
	s IngrDate=$zd(IngrDate,3)
	s IngrTime=$p(^DHCINGR(IngrId),"^",14)
	s IngrTime=$zt(IngrTime,1)
	s IngrDate=IngrDate_" "_IngrTime
	
	s Ch=0
	f  s Ch=$o(^DHCINGR(IngrId,"GRI",Ch)) q:Ch=""  d
	.s InciId=$p(^DHCINGR(IngrId,"GRI",Ch),"^",25)
	.s OrderDetailSubId=$p(^DHCINGR(IngrId,"GRI",Ch),"^",64)
	.q:OrderDetailSubId=""
	.
	.s BUomId=$p(^INCI(InciId,1),"^",10)
	.s BUomDesc=$p(^CT("UOM",BUomId),"^",2)
	.
	.s inamount=0		;计算求和
	.//s IngrNoStr=""
	.
	.s SumIngrId=0,IngrNoArr=[]
	.f  s SumIngrId=$o(^DHCINGR(0,"DetailSubId",OrderDetailSubId,SumIngrId)) q:SumIngrId=""  d
	..s IngrNo=$p(^DHCINGR(SumIngrId),"^",1)
	..d IngrNoArr.%Push(IngrNo)
	..s SumIngrCh=0
	..f  s SumIngrCh=$o(^DHCINGR(0,"DetailSubId",OrderDetailSubId,SumIngrId,SumIngrCh)) q:SumIngrCh=""  d
	...s Ingri=SumIngrId_"||"_SumIngrCh
	...s SumIngriData=^DHCINGR(SumIngrId,"GRI",SumIngrCh)
	...s IngriQty=$p(SumIngriData,"^",4)
	...i Ingri=rowid s IngriQty=0 	//删除时数量为0
	...s UomId=$p(SumIngriData,"^",10)
	...s UomFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(UomId,BUomId)
	...s IngriQty=IngriQty*UomFac
	...s inamount=inamount+IngriQty
	..s IngrJsonObj={}
	..s IngrDataArray=[]
	..d IngrJsonObj.%Set("ingr_no",IngrNo,"string")
	..d IngrJsonObj.%Set("ingr_amount",inamount,"string")
	..d IngrJsonObj.%Set("ingr_date",IngrDate,"string")
	..d IngrDataArray.%Push(IngrJsonObj)
	.q:inamount=0		;宁愿不传,也不传一半...
	.//s IngrNoStr="["_IngrNoStr_"]"
	.s OrderDetail={}
	.d OrderDetail.%Set("ps_detail_id",OrderDetailSubId,"string")
	.d OrderDetail.%Set("in_amount",inamount,"string")
	.d OrderDetail.%Set("reject_amount","","string")
	.//d OrderDetail.%Set("stock_in_time",IngrDate,"string")
	.d OrderDetail.%Set("ingrs",IngrDataArray)
	.d OrderDetail.%Set("unit_name",BUomDesc,"string")
	.d DataArray.%Push(OrderDetail)
	.s Count=Count+1
	q:Count=0 ""
	d JsonObj.%Set("list",DataArray)
	
	s Code="postStockIns"
	s Input=JsonObj.%ToJSON()

	s Ret=..GetResult(Code,Input,HospId)
	d ##class(web.DHCSTMHUI.DHCDataExchangeLog).Log(.LogRowId,Ret,SerTypeId)
	q Ret
}

/// 18.上传入库信息
/// 删除入库单
/// 根据主表遍历子表数据
/// 第一：获取detail_id 
/// 第二：根据获取到的detail_id 获取其他入库单上面的数量进行累加
/// w ##class(web.DHCSTMService.ECS.ECS2STMClient).DeleteIngr(35)
ClassMethod DeleteIngr(IngrId As %String, HospId = "") As %String
{
	q:..GetUseFlag(HospId,.SerTypeId)'="Y" 0
	s MethodName="DeleteIngr"
	s Params=IngrId_";"_HospId
	d ##class(web.DHCSTMHUI.DHCDataExchangeLog).Log(.LogRowId,"",SerTypeId,$CLASSNAME(),MethodName,Params)
	s ret=0
	s Count=0
	s JsonObj={}
	s DataArray=[]
	s IngrDate=$p(^DHCINGR(IngrId),"^",14)
	s IngrDate=$zd(IngrDate,3)
	s IngrTime=$p(^DHCINGR(IngrId),"^",14)
	s IngrTime=$zt(IngrTime,1)
	s IngrDate=IngrDate_" "_IngrTime
	s Ch=0
	f  s Ch=$o(^DHCINGR(IngrId,"GRI",Ch)) q:Ch=""  d
	.s InciId=$p(^DHCINGR(IngrId,"GRI",Ch),"^",25)
	.s OrderDetailSubId=$p(^DHCINGR(IngrId,"GRI",Ch),"^",64)
	.q:OrderDetailSubId=""
	.
	.s BUomId=$p(^INCI(InciId,1),"^",10)
	.s BUomDesc=$p(^CT("UOM",BUomId),"^",2)
	.
	.s inamount=0		;计算求和
	.//s IngrNoStr=""
	.
	.s SumIngrId=0,IngrNoArr=[]
	.f  s SumIngrId=$o(^DHCINGR(0,"DetailSubId",OrderDetailSubId,SumIngrId)) q:SumIngrId=""  d
	..s IngrNo=$p(^DHCINGR(SumIngrId),"^",1)
	..d IngrNoArr.%Push(IngrNo)
	..s SumIngrCh=0
	..f  s SumIngrCh=$o(^DHCINGR(0,"DetailSubId",OrderDetailSubId,SumIngrId,SumIngrCh)) q:SumIngrCh=""  d
	...s SumIngriData=^DHCINGR(SumIngrId,"GRI",SumIngrCh)
	...s IngriQty=$p(SumIngriData,"^",4)
	...s IngriQty=0	//删除时数量为0
	...s UomId=$p(SumIngriData,"^",10)
	...s UomFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(UomId,BUomId)
	...s IngriQty=IngriQty*UomFac
	...s inamount=inamount+IngriQty
	..s IngrJsonObj={}
	..s IngrDataArray=[]
	..d IngrJsonObj.%Set("ingr_no",IngrNo,"string")
	..d IngrJsonObj.%Set("ingr_amount",inamount,"string")
	..d IngrJsonObj.%Set("ingr_date",IngrDate,"string")
	..d IngrDataArray.%Push(IngrJsonObj)
	.//s IngrNoStr="["_IngrNoStr_"]"
	.s OrderDetail={}
	.d OrderDetail.%Set("ps_detail_id",OrderDetailSubId,"string")
	.d OrderDetail.%Set("in_amount",inamount,"string")
	.d OrderDetail.%Set("reject_amount","","string")
	.//d OrderDetail.%Set("stock_in_time",IngrDate,"string")
	.d OrderDetail.%Set("ingrs",IngrDataArray)
	.d OrderDetail.%Set("unit_name",BUomDesc,"string")
	.
	.d DataArray.%Push(OrderDetail)
	.s Count=Count+1
	q:Count=0 ""
	d JsonObj.%Set("list",DataArray)
	s Code="postStockIns"
	s Input=JsonObj.%ToJSON()
	s Ret=..GetResult(Code,Input,HospId)
	d ##class(web.DHCSTMHUI.DHCDataExchangeLog).Log(.LogRowId,Ret,SerTypeId)
	q Ret
}

/// 19.上传消耗汇总信息(任务)
/// 上传停医嘱的记录
/// w ##class(web.DHCSTMService.ECS.ECS2STMClient).getHvReturnLabels()
ClassMethod getHvReturnLabels(HospId = "") As %String
{
	q:..GetUseFlag(HospId,.SerTypeId)'="Y" 0
	s MethodName="getHvReturnLabels"
	s Params=HospId
	d ##class(web.DHCSTMHUI.DHCDataExchangeLog).Log(.LogRowId,"",SerTypeId,$CLASSNAME(),MethodName,Params)
	
	s JsonObj={}
	s RowsArray=[]

	s count=0
	s hvrId=0
	f  s hvrId=$o(^DHCHVMORIRET(0,"PlatFlag","N",hvrId)) q:hvrId=""  d
	.s vendordr=$p(^DHCHVMORIRET(hvrId,1),"^",17)
	.s rp=$p(^DHCHVMORIRET(hvrId,1),"^",20)
	.s hvRowId=$p(^DHCHVMORIRET(hvrId,1),"^",12)
	.s barcode=$p(^DHCHVMORIRET(hvrId,1),"^",24)
	.s InciId=$p(^DHCHVMORIRET(hvrId,1),"^",34)
	.s date=$p(^DHCHVMORIRET(hvrId,1),"^",8)		;使用$h格式
	.s qty=$p(^DHCHVMORIRET(hvrId,1),"^",19)
	.s oeori=$p(^DHCHVMORIRET(hvrId,1),"^",1)
	.s admloc=$p(^DHCHVMORIRET(hvrId,1),"^",7)
	.s hvId=$p(^DHCHVMORIRET(hvrId,1),"^",12)		;dhc_hvmat_orditm
	.
	.s useLoc=##class(web.DHCSTMHUI.HVMatOrdItm).GetHVInitLocByOeori(oeori,admloc)
	.s UseLocDesc=$s(useLoc'="":$p(^CTLOC(useLoc),"^",2),1:"")
	.s Ingri=$p(^DHCHVMORI(hvId,1),"^",12)			;取暂存库入库记录
	.s OrderDetailSubId=$s(Ingri'="":$p(^DHCINGR(+Ingri,"GRI",$p(Ingri,"||",2)),"^",64),1:"")
	.q:(Ingri'="")&&(OrderDetailSubId="")			;入库单上未记录OrderDetailSubId的,暂不传递
	.s TableFlag=$s(Ingri'="":"1",1:"2")			;跟台(1:普通代销; 2:跟台高值)
	.s IngrLocDesc=$s(Ingri'="":$p(^DHCINGR(+Ingri),"^",13),1:"")
	.
	.s count=count+1
	.s RowObj={}
	.d RowObj.%Set("ps_detail_id",OrderDetailSubId,"string")
	.d RowObj.%Set("hosp_barcode",barcode,"string")
	.d RowObj.%Set("isuse_barcode",0,"string")
	.d RowObj.%Set("barcodeuse_date",$zd(date,3),"string")
	.d RowObj.%Set("use_id",hvrId,"string")
	.d RowObj.%Set("user_name","","string")
	.d RowObj.%Set("realprice",rp,"number")
	.d RowObj.%Set("note","","string")
	.d RowObj.%Set("inv_id",InciId,"string")
	.d RowObj.%Set("sup_id",vendordr,"string")
	.d RowObj.%Set("mode_flag",TableFlag,"string")
	.d RowObj.%Set("rece_dept",UseLocDesc)			;"使用科室"
	.d RowObj.%Set("orient_dept",IngrLocDesc)		;"采购库房"
	.d RowsArray.%Push(RowObj)
	
	d JsonObj.%Set("list",RowsArray)
	s Code="postUseInfo"
	s Input=JsonObj.%ToJSON()
	s Ret=..GetResult(Code,Input,HospId)
	d ##class(web.DHCSTMHUI.DHCDataExchangeLog).Log(.LogRowId,Ret,SerTypeId)
	s RetObj={}.%FromJSON(Ret)
	i (RetObj'="")&&(RetObj.%Get("state")=1) {
		While(1) {
			s ItmObj=RowsArray.%Pop()
			q:ItmObj=""
			s state=ItmObj.%Get("state")
			;q:state'=1
			s ORIRId=ItmObj.%Get("use_id")
			&sql(update DHC_HVMat_OrdItmRet set ORIR_PlatSendFlag='Y' where %ID=:ORIRId)
		}
	}
	
	q 0
}

/// 20.上传消耗汇总信息（任务）
/// 发送高值医嘱信息到平台
/// 需后台挂任务
/// w ##class(web.DHCSTMService.ECS.ECS2STMClient).getHvLabels()
ClassMethod getHvLabels(HospId = "") As %String
{
	q:..GetUseFlag(HospId,.SerTypeId)'="Y" 0
	s MethodName="getHvLabels"
	s Params=HospId
	d ##class(web.DHCSTMHUI.DHCDataExchangeLog).Log(.LogRowId,"",SerTypeId,$CLASSNAME(),MethodName,Params)
	
	s JsonObj={}
	s RowsArray=[]
	s count=0
	s yes="Y"
	s hvId=0
	f  s hvId=$o(^DHCHVMORI(0,"PlatFlag","N",hvId)) q:hvId=""  d
	.s vendordr=$p(^DHCHVMORI(hvId,1),"^",17)
	.s cancel=$p(^DHCHVMORI(hvId,1),"^",26)
	.i cancel="Y" d
	..&sql(UPDATE DHC_HVMat_OrdItm SET ORI_PlatSentFlag=:yes WHERE ORI_RowId=:hvId)
	.q:cancel="Y"
	.s rp=$p(^DHCHVMORI(hvId,1),"^",20) 
	.s barcode=$p(^DHCHVMORI(hvId,1),"^",24)
	.s InciId = $p(^DHCHVMORI(hvId,1),"^",34)
	.s date=$p(^DHCHVMORI(hvId,1),"^",8)		;使用$h格式
	.s qty=$p(^DHCHVMORI(hvId,1),"^",19)
	.s oeori=$p(^DHCHVMORI(hvId,1),"^",1)
	.s admloc=$p(^DHCHVMORI(hvId,1),"^",7)
	.s batno=$p(^DHCHVMORI(hvId,1),"^",13)
	.s expdate=$p(^DHCHVMORI(hvId,1),"^",14)
	.s useLoc=##class(web.DHCSTMHUI.HVMatOrdItm).GetHVInitLocByOeori(oeori,admloc)
	.s UseLocDesc=$s(useLoc'="":$p(^CTLOC(useLoc),"^",2),1:"")
	.;s ingrecitmid=$p(^DHCHVMORI(hvId,1),"^",36)	;ori_ingri_modify_dr
	.s Ingri=$p(^DHCHVMORI(hvId,1),"^",12)			;ori_ingri_dr
	.;q:Ingri=""
	.s OrderDetailSubId=$s(Ingri'="":$p(^DHCINGR(+Ingri,"GRI",$p(Ingri,"||",2)),"^",64),1:"")
	.q:(Ingri'="")&&(OrderDetailSubId="")			;入库单上未记录OrderDetailSubId的,暂不传递
	.s TableFlag=$s(Ingri'="":"1",1:"2")			;跟台(1:普通代销; 2:跟台高值)
	.s IngrLocDesc=$s(Ingri'="":$p(^DHCINGR(+Ingri),"^",13),1:"")
	.
	.s RowObj={}
	.d RowObj.%Set("ps_detail_id",OrderDetailSubId,"string")
	.d RowObj.%Set("hosp_barcode",barcode,"string")
	.d RowObj.%Set("isuse_barcode",1,"string")
	.d RowObj.%Set("barcodeuse_date",$zd(date,3),"string")
	.d RowObj.%Set("use_id",hvId,"string")
	.d RowObj.%Set("user_name","","string")
	.d RowObj.%Set("realprice",rp,"number")
	.d RowObj.%Set("note","","string")
	.d RowObj.%Set("inv_id",InciId,"string")
	.d RowObj.%Set("sup_id",vendordr,"string")
	.d RowObj.%Set("mode_flag",TableFlag,"string")
	.d RowObj.%Set("rece_dept",UseLocDesc)			;"使用科室"
	.d RowObj.%Set("orient_dept",IngrLocDesc)		;"采购库房"
	.d RowsArray.%Push(RowObj)
	.s count=count+1
	.i count=100 d
	..d HvLabels
	..s JsonObj={}
	..s RowsArray=[]
	i count'=0  d HvLabels
	q 0
HvLabels
	s count=0
	d JsonObj.%Set("list",RowsArray)
	s Code="postUseInfo"
	s Input=JsonObj.%ToJSON()
	s Ret=..GetResult(Code,Input,HospId)
	d ##class(web.DHCSTMHUI.DHCDataExchangeLog).Log(.LogRowId,Ret,SerTypeId)
	
	s RetObj={}.%FromJSON(Ret)
	i (RetObj'="")&&(RetObj.%Get("state")=1) {
		While(1) {
			s ItmObj=RowsArray.%Pop()
			q:ItmObj=""
			s HVMId=ItmObj.%Get("use_id")
			&sql(update DHC_HVMat_OrdItm set ORI_PlatSentFlag='Y' where %ID=:HVMId)
		}
	}
	
	q 0
}

/// 21.上传退货信息
/// saveSupRet
/// w ##class(web.DHCSTMService.ECS.ECS2STMClient).saveSupRet(44)
ClassMethod saveSupRet(IngRetid As %String, HospId = "") As %String
{
	q:..GetUseFlag(HospId,.SerTypeId)'="Y" 0
	s MethodName="saveSupRet"
	s Params=IngRetid_";"_HospId
	d ##class(web.DHCSTMHUI.DHCDataExchangeLog).Log(.LogRowId,"",SerTypeId,$CLASSNAME(),MethodName,Params)
	
	s ret=0
	s JsonObj={}
	s RowsArray=[]
	s RowObj={}
	s OrderDetail={}
	//第一步获取到配送单主表id
	s RetLoc=$p(^INGRT(IngRetid),"^",7)  ;退货科室
	s RetVen=$p(^INGRT(IngRetid),"^",2)  ;退货供应商
	s CloudId=$p(^APC("APCVM",RetVen,1),"^",16)
	;q:CloudId="" ""
	s hosno=$p(^INGRT(IngRetid),"^",1)
	s hosuser=$p(^INGRT(IngRetid),"^",5)
	s hosaudituser=$p(^INGRT(IngRetid),"^",8)
	s hosdate=$p(^INGRT(IngRetid),"^",3)
	s hosdate=$zd(hosdate,3)
	s hostime=$p(^INGRT(IngRetid),"^",4)
	s hostime=$zt(hostime,1)
	s hosauditdate=$p(^INGRT(IngRetid),"^",9)
	s hosaudittime=$p(^INGRT(IngRetid),"^",10)
	i hosauditdate'="" s hosauditdate=$zd(hosauditdate,3)
	i hosaudittime'="" s hosaudittime=$zt(hosaudittime,1)
	s hosdate=hosdate_" "_hostime
	s:hosauditdate'="" hosauditdate=hosauditdate_" "_hosaudittime
	///退货单主表信息
	d RowObj.%Set("sup_id",RetVen,"string")
	d RowObj.%Set("hos_ret_id",IngRetid,"string")
	d RowObj.%Set("hos_no",hosno,"string")
	d RowObj.%Set("hos_user",..sssUserName(hosuser),"string")
	d RowObj.%Set("hos_audit_user",..sssUserName(hosaudituser),"string")
	d RowObj.%Set("hos_date",hosdate,"string")
	d RowObj.%Set("hos_audit_date",hosauditdate,"string")
	
	s detailArr=[]
	s Count=0
	//明细信息
	s sub=""
	f  s sub=$o(^INGRT(IngRetid,"DHCGRR",sub)) q:sub=""  d
	.q:'$d(^INGRT(IngRetid,"DHCGRR",sub))
	.s detailObj={}
	.s IngRetItmid=IngRetid_"||"_sub
	.s IngRetInfo=^INGRT(IngRetid,"DHCGRR",sub)
	.s ingrecitmid=$p(IngRetInfo,"^",1)		;入库明细ID
	.s Ingr=+ingrecitmid,IngrCh=$p(ingrecitmid,"||",2)
	.s poitmid=$p(^DHCINGR(Ingr,"GRI",IngrCh),"^",17)
	.s OrderDetailSubId=$p(^DHCINGR(Ingr,"GRI",IngrCh),"^",64)
	.q:OrderDetailSubId=""
	.s inci=$P(^DHCINGR(Ingr,"GRI",IngrCh),"^",25)
	.s InciFlag=..GetInciFlag(inci)
	.q:InciFlag'="Y"
	.s InciCode=$p(^INCI(inci,1),"^",1)
	.s InciDesc=$p(^INCI(inci,1),"^",2)
	.s RetQty=$p(IngRetInfo,"^",2)			;退货数量
	.s RetUomDR=$p(IngRetInfo,"^",3)
	.s rp=$p(IngRetInfo,"^",7)
	.s RetAmt=$p(IngRetInfo,"^",4)
	.s RetReasondr=$p(IngRetInfo,"^",5)
	.s RetReason=""
	.s:RetReasondr'="" RetReason=$p(^INC("RET",RetReasondr),"^",2)
	.s BUomId=$p(^INCI(inci,1),"^",10)
	.s BUomDesc=$p(^CT("UOM",BUomId),"^",2)
	.s BarCode=$p(^INCI(inci,3),"^",9)
	.i RetUomDR'=BUomId d
	..s fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(RetUomDR,BUomId)
	..q:fac=1
	..s RetQty=RetQty*fac
	..s rp=rp/fac
	.s HvFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(inci)
	.s objItm=##class(User.DHCINGdRecItm).%OpenId(ingrecitmid)
	.s InclbObj=objItm.INGRIINCLBDR q:InclbObj=""
	.s Inclb=InclbObj.%Id() q:Inclb=""
	.s BatExp=##class(web.DHCSTMHUI.Common.DrugStkCommon).Bat(Inclb)
	.s BatNo=$p(BatExp,"^",1),ExpDate=$p(BatExp,"^",2)
	.s:ExpDate'="" ExpDate=$zd(..DH2L(ExpDate),3)
	.d detailObj.%Set("ps_detail_id",OrderDetailSubId,"string")
	.d detailObj.%Set("amount",RetQty,"number")
	.d detailObj.%Set("price",rp,"number")
	.d detailObj.%Set("amount_money",RetAmt,"number")
	.d detailObj.%Set("batch_no",BatNo,"string")
	.d detailObj.%Set("batch_date",ExpDate,"string")
	.d detailObj.%Set("serial_no","","string")
	.d detailObj.%Set("bar_code","","string")
	.d detailObj.%Set("barcode","","string")
	.d detailObj.%Set("unit_name",BUomDesc,"string")
	.d detailArr.%Push(detailObj)
	.s Count=Count+1
	q:Count=0 ""
	d RowObj.%Set("detail",detailArr)
	
	d RowsArray.%Push(RowObj)
	d JsonObj.%Set("list",RowsArray)
	s Code="postReturns"
	s Input=JsonObj.%ToJSON()
	s Ret=..GetResult(Code,Input,HospId)
	d ##class(web.DHCSTMHUI.DHCDataExchangeLog).Log(.LogRowId,Ret,SerTypeId)

	s RetObj={}.%FromJSON(Ret)
	q:RetObj="" -10
	q:RetObj.%Get("state")'=1 -11
	q 0
}

/// 22.上传退货状态
/// Descript:	撤销退货单
/// Creator:	wangjiabin
/// CreateDate:	2021-03-16
/// Input:		IngrtStr(如有多个,^隔开)	
/// Output:		
/// w ##class(web.DHCSTMService.ECS.ECS2STMClient).cancelSupRet("11^21")
ClassMethod cancelSupRet(IngrtStr, HospId = "")
{
	q:..GetUseFlag(HospId,.SerTypeId)'="Y" 0
	s MethodName="cancelSupRet"
	s Params=IngrtStr_";"_HospId
	d ##class(web.DHCSTMHUI.DHCDataExchangeLog).Log(.LogRowId,"",SerTypeId,$CLASSNAME(),MethodName,Params)
	
	q:IngrtStr="" ""
	s JsonObj={}
	s DataArray=[]
	s Count=$l(IngrtStr,"^")
	f i=1:1:Count d
	.s IngrtId=$p(IngrtStr,"^",i)
	.d DataArray.%Push(IngrtId)
	d JsonObj.%Set("state","cancel")
	d JsonObj.%Set("ids",DataArray)
	
	s Code="postReturnsState"
	s Input=JsonObj.%ToJSON()
	s CancelRet=..GetResult(Code,Input,HospId)
	d ##class(web.DHCSTMHUI.DHCDataExchangeLog).Log(.LogRowId,CancelRet,SerTypeId)
	s CancelRetObj={}.%FromJSON(CancelRet)
	q:CancelRetObj="" -10
	q:CancelRetObj.%Get("state")'=1 -11
	
	q 0
}

/// 23.下载退货状态
/// w ##class(web.DHCSTMService.ECS.ECS2STMClient).getRetrunsState(4)
ClassMethod getRetrunsState(IngrtStr, HospId = "") As %String
{
	q:..GetUseFlag(HospId,.SerTypeId)'="Y" 0
	s MethodName="getRetrunsState"
	s Params=IngrtStr_";"_HospId
	d ##class(web.DHCSTMHUI.DHCDataExchangeLog).Log(.LogRowId,"",SerTypeId,$CLASSNAME(),MethodName,Params)
	
	q:(IngrtStr="") -1
	
	s JsonObj={}
	s DataArray=[]
	
	s IngrtArray=[]
	s Len=$l(IngrtStr,"^")
	f i=1:1:Len  d
	.s Ingrt=$p(IngrtStr,"^",i)
	.d IngrtArray.%Push(Ingrt)
	d JsonObj.%Set("ids",IngrtArray)
	s Code="getRetrunsState"
	s Input=JsonObj.%ToJSON()
	s Ret=..GetResult(Code,Input,HospId)
	d ##class(web.DHCSTMHUI.DHCDataExchangeLog).Log(.LogRowId,Ret,SerTypeId)
	q:Ret="" -1
	
	s RetObj={}.%FromJSON(Ret)
	s State=RetObj.%Get("state")
	q:State'=1 -2
	s DatasObj=RetObj.%Get("data")
	s DataSize=DatasObj.%Size()
	q:DataSize=0 0

	s Err=0
	f i=0:1:(DataSize-1) d
	.s RetObj=DatasObj.%Get(i)
	.s RetId=RetObj.%Get("hos_ret_id")
	.s state=RetObj.%Get("state")
	.&sql(update DHC_INGDRET set INGRT_HRPFlag='1' where %ID=:RetId)
	
	q 0
}

/// 24.下载发票信息（任务）
/// 需后台挂任务
/// d ##class(web.DHCSTMService.ECS.ECS2STMClient).getInvNos()
ClassMethod getInvNos(HospId = "") As %String
{
	s ret=..getInvNosNotHv(HospId)
	s rethv=..getInvNosHv(HospId)
	q 0
}

ClassMethod getInvNosNotHv(HospId)
{
	q:..GetUseFlag(HospId,.SerTypeId)'="Y" 0
	s MethodName="getInvNosNotHv"
	s Params=HospId
	d ##class(web.DHCSTMHUI.DHCDataExchangeLog).Log(.LogRowId,"",SerTypeId,$CLASSNAME(),MethodName,Params)
	
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	s Pid=..NewPid()
	//非高值
	s (Nomcnt)=0
	s ingr=""
	s psIds="",IdArr=[]
	f  s ingr=$o(^DHCINGR(0,"SynInvFlag","N",ingr)) q:ingr=""  d
	.s StkType=$p(^DHCINGR(ingr),"^",30)
	.q:StkType'="M"
	.s ch=""
	.f  s ch=$o(^DHCINGR(ingr,"GRI",ch)) q:ch=""  d
	..s invNo=$p(^DHCINGR(ingr,"GRI",ch),"^",27)
	..q:invNo'=""
	..s inci=$p(^DHCINGR(ingr,"GRI",ch),"^",25)
	..s ingri=ingr_"||"_ch
	..s HvFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(inci)
	..q:HvFlag="Y"
	..s OrderDetailSubId=$p(^DHCINGR(ingr,"GRI",ch),"^",64)
	..q:OrderDetailSubId=""
	..d IdArr.%Push(OrderDetailSubId)
	..s Nomcnt=Nomcnt+1 
	..s ^TMPDHCSTM(Pid,"SynNomInv",OrderDetailSubId,ingri)=""
	..i Nomcnt=100 d SynNomInv
	i Nomcnt'=0 d SynNomInv
	
SynNomInv
	s ret=0
	s JsonObj={}
	d JsonObj.%Set("ps_detail_ids",IdArr)
	s IdArr=[]
	s Code="getInvoices"
	s Input=JsonObj.%ToJSON()
	s InvRet=..GetResult(Code,Input,HospId)
	d ##class(web.DHCSTMHUI.DHCDataExchangeLog).Log(.LogRowId,InvRet,SerTypeId)
	q:InvRet="" 0
	s InvRetObj={}.%FromJSON(InvRet)
	s state=InvRetObj.%Get("state")
	q:state'=1 0
	s DatasObj=InvRetObj.%Get("data")
	q:DatasObj="" 0
	s DataSize=DatasObj.%Size()
	ts
	f i=0:1:(DataSize-1) q:(ret'=0)  d
	.s InvObj=DatasObj.%Get(i)
	.s DetailList=InvObj.%Get("detail")
	.s InvDate=InvObj.%Get("inv_date")
	.s InvNo=InvObj.%Get("inv_no")
	.s InvCode=InvObj.%Get("inv_code")
	.q:(DetailList="")||(DetailList.%Size()=0)
	.s:InvDate'="" InvDate=$zdh(InvDate,3)
	.
	.s VendorId="",LocId=""
	.s DetailSize=DetailList.%Size()
	.f j=0:1:(DetailSize-1) q:(ret'=0)  d
	..s InvItmObj=DetailList.%Get(j)
	..s OrderDetailSubId=InvItmObj.%Get("ps_detail_id")
	..s IngriId=""
	..f  s IngriId=$o(^TMPDHCSTM(Pid,"SynNomInv",OrderDetailSubId,IngriId)) q:(IngriId="")||(ret'=0)  d
	...s Ingr=+IngriId
	...i (VendorId="")||(LocId="") d
	....&sql(SELECT INGR_APCVM_DR,INGR_Loc_Dr into :VendorId,:LocId FROM DHC_INGdRec WHERE INGR_RowId=:Ingr)
	...s RpAmt=$p(^DHCINGR(Ingr,"GRI",$p(IngriId,"||",2)),"^",31)
	...s InvAmount=RpAmt
	...s IngriObj=##class(User.DHCINGdRecItm).%OpenId(IngriId)
	...s IngriObj.initminvno=InvNo
	...s IngriObj.initminvdate=InvDate
	...s IngriObj.initmInvCode=InvCode
	...s IngriObj.initminvmoney=InvAmount
	...s IngriObj.initmSynInvFlag="Y"
	...s Sc=IngriObj.%Save()
	...i $$$ISERR(Sc) s ret=-1
	.i (InvCode'="")||(InvNo'="") d
	..s InvId=""
	..&sql(select %ID into :InvId from DHC_VendorInv where INV_InvCode=:InvCode and INV_InvNo=:InvNo)
	..i InvId="" d
	...s InvAmt=##class(web.DHCSTMHUI.DHCVendorInv).GetInvAmtByIngr(InvCode,InvNo)
	...s Data=InvId_"^"_VendorId_"^"_InvCode_"^"_InvNo_"^"_InvAmt_"^"_InvDate_"^"_LocId_"^"_"Y"_"^"_"Y"
	...s Title="RowId^Vendor^InvCode^InvNo^InvAmt^InvDate^IngrLoc^CompFlag^FilledFlag"
	...s InvDate=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	...s RtnObj=##class(web.DHCSTMHUI.DHCVendorInv).SaveInvInfo(InvDate)
	...i RtnObj.success'=0 s ret=-2
	k ^TMPDHCSTM(Pid,"SynNomInv")
	s psIds=""
	s Nomcnt=0
	q:ret'=0 tro ret
	
	tc
	q ret
}

ClassMethod getInvNosHv(HospId)
{
	q:..GetUseFlag(HospId,.SerTypeId)'="Y" 0
	s MethodName="getInvNosHv"
	s Params=HospId
	d ##class(web.DHCSTMHUI.DHCDataExchangeLog).Log(.LogRowId,"",SerTypeId,$CLASSNAME(),MethodName,Params)
	
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	s Pid=..NewPid()
	//高值
	s (HVNomcnt)=0
	s hvm=""
	s HVpsIds="",HVIdArr=[]
	f  s hvm=$o(^DHCHVMORI(0,"SynInvFlag","N",hvm)) q:hvm=""  d
	.s hvminfo=^DHCHVMORI(hvm,1)
	.s BarCode=$p(hvminfo,"^",24)
	.//q:BarCode'="190901732514826"
	.s PlatSentFlag=$p(hvminfo,"^",39)
	.q:PlatSentFlag'="Y"
	.s InvNo=$p(hvminfo,"^",31)
	.s ModifyIngri=$p(hvminfo,"^",36)
	.i ModifyIngri'="" d
	..s InvNo=$p(^DHCINGR(+ModifyIngri,"GRI",$p(ModifyIngri,"||",2)),"^",27)
	.q:InvNo'=""
	.s dhcit=$o(^DHCIT(0,"LABEL",BarCode,0))
	.s:dhcit="" dhcit=$o(^DHCIT(0,"ORIGINALCODE",BarCode,0))
	.q:dhcit=""
	.s dhcitDR=$p(^DHCIT(dhcit),"^",28)
	.q:dhcitDR'=""		;重生成条码
	.s OrderDetailSubId=$p(^DHCIT(dhcit),"^",25)
	.q:OrderDetailSubId=""
	.d HVIdArr.%Push(OrderDetailSubId)
	.s HVNomcnt=HVNomcnt+1
	.s ^TMPDHCSTM(Pid,"SynNomInvHV",OrderDetailSubId,hvm)=dhcit
	.i HVNomcnt=100 d SynNomInvHV
	i HVNomcnt'=0 d SynNomInvHV
	
	q 0
	
SynNomInvHV
	s ret=0
	s JsonObj={}
	d JsonObj.%Set("ps_detail_ids",HVIdArr)
	s HVIdArr=[]
	s Code="getInvoices"
	s Input=JsonObj.%ToJSON()
	s InvRet=..GetResult(Code,Input,HospId)
	d ##class(web.DHCSTMHUI.DHCDataExchangeLog).Log(.LogRowId,InvRet,SerTypeId)
	q:InvRet="" 0
	s InvRetObj={}.%FromJSON(InvRet)
	s state=InvRetObj.%Get("state")
	q:state'=1 0
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	s DatasObj=InvRetObj.%Get("data")
	q:DatasObj="" 0
	s DataSize=DatasObj.%Size()
	
	ts
	s newDetail=""
	f i=0:1:(DataSize-1) q:(ret'=0)  d
	.s InvObj=DatasObj.%Get(i)
	.s DetailList=InvObj.%Get("detail")
	.s InvDate=InvObj.%Get("inv_date")
	.s InvNo=InvObj.%Get("inv_no")
	.s InvCode=InvObj.%Get("inv_code")
	.q:(DetailList="")||(DetailList.%Size()=0)
	.s InvDate=$zdh(InvDate,3)
	.s InvDate=..DL2H(InvDate)
	.
	.s VendorId="",LocId=""
	.s DetailSize=DetailList.%Size()
	.f j=0:1:(DetailSize-1) q:(ret'=0)  d
	..s InvItmObj=DetailList.%Get(j)
	..s OrderDetailSubId=InvItmObj.%Get("ps_detail_id")
	..s hvm=""
	..f  s hvm=$o(^TMPDHCSTM(Pid,"SynNomInvHV",OrderDetailSubId,hvm)) q:(hvm="")||(ret'=0)  d
	...s dhcit=^TMPDHCSTM(Pid,"SynNomInvHV",OrderDetailSubId,hvm)
	...s hvminfo=^DHCHVMORI(hvm,1)
	...i (VendorId="")||(LocId="") d
	....s VendorId=$p(hvminfo,"^",17)
	....s LocId=$p(hvminfo,"^",42)
	...s ModifyIngri=$p(hvminfo,"^",36)
	...i ModifyIngri'="" d
	....s RpAmt=$p(^DHCINGR(+ModifyIngri,"GRI",$p(ModifyIngri,"||",2)),"^",31)
	...e  d
	....s AppParams="^"_LocId_"^^"
	....s rp=##class(web.DHCSTMHUI.HVMatOrdItm).GetRp(hvm,AppParams)
	....s qty=$p(hvminfo,"^",19)
	....s RpAmt=rp*qty
	...s InvAmount=RpAmt
	...s newDetailObj={}
	...s newDetailObj.RowId=hvm
	...s newDetailObj.InvCode=InvCode
	...s newDetailObj.InvNo=InvNo
	...s newDetailObj.InvDate=InvDate
	...s newDetailObj.InvAmt=InvAmount
	...s newDetailObj.VendorDr=VendorId
	...s nDetailObj=newDetailObj.%ToJSON()
	...i newDetail'="" d
	....s newDetail=newDetail_","_nDetailObj
	...e  d
	....s newDetail=nDetailObj
	...&sql(update DHC_HVMat_OrdItm set ORI_SynInvFlag='Y' where ORI_RowId=:hvm)
	...i SQLCODE'=0 s ret=-2
	k ^TMPDHCSTM(Pid,"SynNomInvHV")
	s HVpsIds=""
	s HVNomcnt=0
	i ret'=0 tro  q ret
	
	i newDetail'="" d
	.s newDetail="["_newDetail_"]"
	.s RtnObj=##class(web.DHCSTMHUI.HVMatOrdItm).SaveInvInfo(newDetail)
	.s:RtnObj.success'=0 ret=-1
	i ret'=0 tro  q ret
	
	tc
	q ret
}

/// 25.上传发票状态
/// Description:物流系统发票确认,回传
/// Input:		
/// Output:
/// d ##class(web.DHCSTMService.ECS.ECS2STMClient).updateInvState(1)		
ClassMethod updateInvState(InvId, HospId = "")
{
	q:..GetUseFlag(HospId,.SerTypeId)'="Y" 0
	q:InvId="" 0
	s MethodName="updateInvState"
	s Params=InvId_";"_HospId
	d ##class(web.DHCSTMHUI.DHCDataExchangeLog).Log(.LogRowId,"",SerTypeId,$CLASSNAME(),MethodName,Params)
	
	s InvCode=$p(^DHCVendorInv(InvId),"^",16)
	s InvNo=$p(^DHCVendorInv(InvId),"^",10)
	q:(InvCode="")&&(InvNo="") -1
	
	s Ingri=""
	&sql(select %ID into :Ingri from DHC_INGdRecItm where isnull(initm_invno,'')=:InvNo and isnull(initm_InvCode,'')=:InvCode and initm_OrderDetailSubId is not null)
	q:Ingri="" -2
	
	s InvObj={},DataArray=[]
	d InvObj.%Set("inv_code",InvCode,"String")
	d InvObj.%Set("inv_no",InvNo,"String")
	d DataArray.%Push(InvObj)
	s JsonObj={}
	d JsonObj.%Set("state","checked")
	d JsonObj.%Set("list",DataArray)
	
	s Code="postInvoicesState"
	s Input=JsonObj.%ToJSON()
	s Ret=..GetResult(Code,Input,HospId)
	d ##class(web.DHCSTMHUI.DHCDataExchangeLog).Log(.LogRowId,Ret,SerTypeId)
	s Ret={}.%FromJSON(Ret)
	q:Ret="" -3
	q:Ret.%Get("state")'=1 -4
	
	q 0
}

/// 26.上传库存信息
/// Description: 上传库存信息
/// Input:		
/// Output:
/// w ##class(web.DHCSTMService.ECS.ECS2STMClient).postStock()
ClassMethod postStock(InciDr As %String = "", LocDr As %String = "", HospId = "") As %String
{
	q:..GetUseFlag(HospId,.SerTypeId)'="Y" 0
	s MethodName="postStock"
	s Params=InciDr_";"_LocDr_";"_HospId
	d ##class(web.DHCSTMHUI.DHCDataExchangeLog).Log(.LogRowId,"",SerTypeId,$CLASSNAME(),MethodName,Params)
	
	s Ret = 0
	s count = 0
	s StockObj = {}
	s InciArr = []
	s Inci=0
	f  s Inci = $O(^INCI(Inci)) q:(+Inci=0)  d
	.q:(InciDr '= "")&&(InciDr '= Inci)
	.s NotUseFlag=$p(^INCI(Inci,2),"^",9)
	.q:NotUseFlag="Y"
	.s InciFlag=..GetInciFlag(Inci)
	.q:InciFlag'="Y"
	.s PUom = $P(^INCI(Inci, 3), "^", 6)
	.s BUom = $P(^INCI(Inci, 1), "^", 10)
	.s ConFac = ##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PUom, BUom)
	.s Info=$o(^DHCITMINFO(0,"INCI",Inci,0))
	.s InfoData=$g(^DHCITMINFO(Info))
	.s VenId=$p(InfoData,"^",24)
	.s sub = ""
	.f  s sub = $O(^INCI(Inci, "IL", sub)) q:(sub = "")  d
	..q:$g(^INCI(Inci, "IL", sub))=""
	..s ILData = ^INCI(Inci, "IL", sub)
	..s LocId = $p(ILData, "^", 1)
	..s LocDesc = $P(^CTLOC(LocId), "^", 2)
	..q:(LocDr '= "")&&(LocDr '= LocId)
	..s MaxQty = $p(ILData, "^", 7)
	..s MinQty = $p(ILData, "^", 4)
	..s:(MaxQty '= "") MaxQty = MaxQty / ConFac
	..s:(MinQty '= "") MinQty = MinQty / ConFac
	..s StockQty = ##class(web.DHCSTMHUI.Common.DrugStkCommon).IL(Inci, LocId, +$h)
	..s StockQty = StockQty / ConFac
	..s ItmObj = {}
	..d ItmObj.%Set("sup_id",VenId,"string")
	..d ItmObj.%Set("depart_name",LocDesc,"string")
	..d ItmObj.%Set("inv_id",Inci,"string")
	..d ItmObj.%Set("amount",StockQty,"string")
	..d ItmObj.%Set("max_amount",MaxQty,"string")
	..d ItmObj.%Set("min_amount",MinQty,"string")
	..d ItmObj.%Set("note","","string")
	..d InciArr.%Push(ItmObj)
	..s count = count +1
	..i count = 1000  d sendStock
	..q:(Ret '= 0)
	
	i count > 0 d sendStock
	q 0
	
sendStock
	s count = 0
	d StockObj.%Set("list",InciArr)
	s Code="postStock"
	s Input = StockObj.%ToJSON()
	s Ret=..GetResult(Code,Input,HospId)
	d ##class(web.DHCSTMHUI.DHCDataExchangeLog).Log(.LogRowId,Ret,SerTypeId)
	s StockObj = {}
	q Ret
}

/// Description:上传合同信息
/// Input:		
/// Output:
/// w ##class(web.DHCSTMService.ECS.ECS2STMClient).postContracts("3",2)
ClassMethod postContracts(ContIdStr, HospId = "")
{
	q:..GetUseFlag(HospId,.SerTypeId)'="Y" 0
	s ContArr=[]
	
	s Count=0
	s RowId=0
	f  s RowId=$o(^DHCSTMCONTRACK(RowId)) q:RowId=""  d
	.q:(ContIdStr'="")&&(("^"_ContIdStr_"^")'[("^"_RowId_"^"))
	.s ContInfo=$g(^DHCSTMCONTRACK(RowId))
	.s ContNo=$p(ContInfo,"^",1)
	.s ContName=$p(ContInfo,"^",2)
	.s StartDate=$p(ContInfo,"^",4)
	.s EndDate=$p(ContInfo,"^",5)
	.s LocId=$p(ContInfo,"^",6)
	.s RegDate=$p(ContInfo,"^",7)
	.s VendorId=$p(ContInfo,"^",8)
	.s AuditFlag=$p(ContInfo,"^",11)
	.s LocDesc=$p(^CTLOC(LocId),"^",2)
	.s LocHospId=$p(^CTLOC(LocId),"^",22)
	.q:(HospId'="")&&(LocHospId'=HospId)
	.s AuditState=$s(AuditFlag="Y":2,1:1)
	.
	.;type-合同类型 1 普通合同 2 采购协议 3 战略框架
	.;app_state-审核状态 (1新建 2审核 3正式)
	.s ContObj={}
	.d ContObj.%Set("no",ContNo),ContObj.%Set("name",ContName),ContObj.%Set("sign_date",""),ContObj.%Set("start_date",StartDate),ContObj.%Set("end_date",EndDate)
	.d ContObj.%Set("hos_id",LocHospId),ContObj.%Set("hos_user_name",""),ContObj.%Set("sup_id",VendorId),ContObj.%Set("sup_user_name",""),ContObj.%Set("depart_name",LocDesc)
	.d ContObj.%Set("type",1),ContObj.%Set("app_state",AuditState)
	.
	.s ContItmArr=[]
	.s Inci=0
	.f  s Inci=$o(^DHCSTMITMCONTRACK(0,"CONTRACT",RowId,Inci)) q:Inci=""  d
	..s InciCode=$p(^INCI(Inci,1),"^",1)
	..s InciDesc=$p(^INCI(Inci,1),"^",2)
	..s BUomId=$p(^INCI(Inci,1),"^",10)
	..s Rp=##class(web.DHCSTMHUI.Common.PriceCommon).GetInciBasicRp(Inci,EndDate,BUomId)
	..s ContItmObj={}
	..d ContItmObj.%Set("inv_id",Inci)
	..d ContItmObj.%Set("inv_code",InciCode)
	..d ContItmObj.%Set("inv_name",InciDesc)
	..d ContItmObj.%Set("price",Rp)
	..d ContItmObj.%Set("qty",0)
	..d ContItmObj.%Set("amount",0)
	..d ContItmArr.%Push(ContItmObj)
	.
	.d ContObj.%Set("products",ContItmArr)
	.s Count=Count+1
	.d ContArr.%Push(ContObj)
	i Count'>0 q ""
	
	s JsonObj={}
	d JsonObj.%Set("list",ContArr)
	
	s Code="postContracts"
	s Input=JsonObj.%ToJSON()
	s Ret=..GetResult(Code,Input,HospId)
	d ##class(web.DHCSTMHUI.DHCDataExchangeLog).Log(.LogRowId,Ret,SerTypeId)
	q Ret
}

/// Description:上传合同状态
/// Input:		
/// Output:
/// w ##class(web.DHCSTMService.ECS.ECS2STMClient).postContractsState("3",2)
ClassMethod postContractsState(ContIdStr, HospId = "")
{
	q:..GetUseFlag(HospId,.SerTypeId)'="Y" 0
	
	s ContArr=[]
	s RowId=0
	f  s RowId=$o(^DHCSTMCONTRACK(RowId)) q:RowId=""  d
	.q:(ContIdStr'="")&&(("^"_ContIdStr_"^")'[("^"_RowId_"^"))
	.s ContInfo=$g(^DHCSTMCONTRACK(RowId))
	.s ContNo=$p(ContInfo,"^",1)
	.s ContName=$p(ContInfo,"^",2)
	.s LocId=$p(ContInfo,"^",6)
	.s LocHospId=$p(^CTLOC(LocId),"^",22)
	.q:(HospId'="")&&(LocHospId'=HospId)
	.
	.;type-合同类型 1 普通合同 2 采购协议 3 战略框架
	.;app_state-审核状态 (1新建 2审核 3正式)
	.;合同状态（1草稿 2签订 3履行 4 作废 5中止 6存档）
	.s State="2"
	.
	.s ContObj={}
	.d ContObj.%Set("no",ContNo),ContObj.%Set("state",State)
	.d ContArr.%Push(ContObj)
	s JsonObj={}
	d JsonObj.%Set("list",ContArr)
	
	s Code="postContractsState"
	s Input=JsonObj.%ToJSON()
	s Ret=..GetResult(Code,Input,HospId)
	d ##class(web.DHCSTMHUI.DHCDataExchangeLog).Log(.LogRowId,Ret,SerTypeId)
	q Ret
}

/// Description:下载请求单
/// Input:		
/// Output:
/// w ##class(web.DHCSTMService.ECS.ECS2STMClient).getPurchases(2,"2022-08-26 00:00:01","2022-08-26 23:59:59")
ClassMethod getPurchases(HospId, StartDateTime, EndDateTime)
{
	q:..GetUseFlag(HospId,.SerTypeId)'="Y" 0
	
	s JsonObj={}
	d JsonObj.%Set("start_date",StartDateTime)
	d JsonObj.%Set("end_date",EndDateTime)
	
	s Code="getPurchases"
	s Input=JsonObj.%ToJSON()
	d ##class(web.DHCSTMHUI.DHCDataExchangeLog).Log(.LogRowId,"",SerTypeId,$CLASSNAME(),Code,Input)
	
	s RetJson=..GetResult(Code,Input,HospId)
	d ##class(web.DHCSTMHUI.DHCDataExchangeLog).Log(.LogRowId,RetJson,SerTypeId)
	
	s RetObj={}.%FromJSON(RetJson)
	q:(RetObj.%Get("data")="")||(RetObj.%Get("data").%Size()=0) 0
	s DataSize=RetObj.%Get("data").%Size()
	
	s SaveRet=0
	f i=0:1:(DataSize-1) d
	.s ReqObj=RetObj.%Get("data").%Get(i)
	.
	.s SupLocId=ReqObj.%Get("supply_depart_hisid")
	.s ReqLocId=ReqObj.%Get("req_depart_hisid")
	.s ECSReqId=ReqObj.%Get("req_id")
	.s ECSReqNo=ReqObj.%Get("req_no")
	.s DetailArr=ReqObj.%Get("detail")
	.s NewReqNo="ECS"_ECSReqId_"-"_ECSReqNo		;记录ECS请求单id,单号
	.q:(ECSReqId="")||(ECSReqNo="")
	.q:(SupLocId="")||(ReqLocId="")
	.q:(DetailArr="")||(DetailArr.%Size()=0)
	.q:$d(^DHCINRQ(0,"SNCCNum",NewReqNo))			;已保存的,过来
	.s DetailSize=DetailArr.%Size()
	.
	.s MainObj={}
	.d MainObj.%Set("SupLoc",SupLocId),MainObj.%Set("ReqLoc",ReqLocId),MainObj.%Set("ZnccNum",NewReqNo)
	.d MainObj.%Set("ReqRemarks","供应链云平台生成")
	.s Main=MainObj.%ToJSON()
	.
	.s Arr=[]
	.f j=(DetailSize-1):-1:1 d
	..s DetailObj=DetailArr.%Get(j)
	..s Qty=DetailObj.%Get("amount")
	..s Inci=DetailObj.%Get("inv_id")
	..s Uom=$p(^INCI(Inci,3),"^",6)
	..s ItmObj={}
	..s ItmObj.Uom=Uom,ItmObj.Inci=Inci,ItmObj.Qty=Qty
	..d Arr.%Push(ItmObj)
	.s Detail=Arr.%ToJSON()
	.
	.ts
	.s SaveRet=##class(web.DHCSTMHUI.INRequest).Save(Main,Detail)
	.s ReqObj={}.%FromJSON(SaveRet)
	.s InrqId=ReqObj.rowid,Success=ReqObj.success
	.i (Success'=0)||(InrqId'>0) tro  q
	.s ParamsObj={}.%Set("RowId",InrqId).%Set("gUserId","")
	.s CompParams=ParamsObj.%ToJSON()
	.s RtnObj=##class(web.DHCSTMHUI.INRequest).SetComp(CompParams)
	.i RtnObj.success<0 tro  q
	.tc
	.s Ret=..postPurchaseState(HospId,ECSReqId,1)
	
	q SaveRet
}

/// Description:同步请求单状态postPurchaseState
/// Input:		RowIdStr(^隔开), State(1:已同步；2:已发布；3:已取消)
/// Output:
/// w ##class(web.DHCSTMService.ECS.ECS2STMClient).postPurchaseState(2,47,"1")
ClassMethod postPurchaseState(HospId, RowIdStr, State)
{
	q:..GetUseFlag(HospId,.SerTypeId)'="Y" 0
	q:(RowIdStr="")||(State="") ""
	
	s RowIdArr=[]
	f i=1:1:$l(RowIdStr,"^") d
	.s RowId=$p(RowIdStr,"^",i)
	.d RowIdArr.%Push(RowId)
	s JsonObj={}
	d JsonObj.%Set("state",State)
	d JsonObj.%Set("ids",RowIdArr)
	
	s Code="postPurchaseState"
	s Input=JsonObj.%ToJSON()
	d ##class(web.DHCSTMHUI.DHCDataExchangeLog).Log(.LogRowId,"",SerTypeId,$CLASSNAME(),Code,Input)
	
	s RetJson=..GetResult(Code,Input,HospId)
	d ##class(web.DHCSTMHUI.DHCDataExchangeLog).Log(.LogRowId,RetJson,SerTypeId)
	
	s RetObj={}.%FromJSON(RetJson)
	q:RetObj.%Get("state")'=1 -1
	
	q 0
}

/// Input:		OrgType:机构类型(Vendor-供应商;Manf-生产厂家;Carrier-配送商;),
/// 			CertTypeName:资质类型Code(ECS平台)
/// w ##class(web.DHCSTMService.ECS.ECS2STMClient).GetCertType("Vendor","YLQXJYXKZ")
ClassMethod GetCertType(OrgType, CertTypeCode)
{
	q:(OrgType="")||(CertTypeCode="") ""
	
	;$lb(供应链平台资质类型, 物流系统资质类型, 资质名字)
	s CertInfo("Vendor",$i(CertInfo("Vendor")))=$lb("YYZZ","comLic","营业执照")
	s CertInfo("Vendor",$i(CertInfo("Vendor")))=$lb("YLQXJYXKZ","insBusLic","器械经营许可证")
	s CertInfo("Vendor",$i(CertInfo("Vendor")))=$lb("YLQXSCBAPZ","secondBusLic","第二类医疗器械经营备案凭证")
	s CertInfo("Vendor",$i(CertInfo("Vendor")))=$lb("GMPRZZS","GMPRZZS","GMP认证证书")
	
	;s CertInfo("Vendor","税务登记证")=$lb("taxLic","税务登记证")
	;s CertInfo("Vendor","组织机构代码证")=$lb("orgCode","机构代码")
	;s CertInfo("Vendor","售后服务承诺书")=$lb("saleServComm","售后服务书")
	;s CertInfo("Vendor","法人授权委托书")=$lb("legalComm","法人委托书")
	
	s CertInfo("Manf",$i(CertInfo("Manf")))=$lb("YYZZCS","comLic","营业执照")
	s CertInfo("Manf",$i(CertInfo("Manf")))=$lb("YLQXSCXKZ","insProLic","器械生产许可证")
	s CertInfo("Manf",$i(CertInfo("Manf")))=$lb("YLQXSCBAPZ","firstProdLic","第一类医疗器械生产备案凭证")
	s CertInfo("Manf",$i(CertInfo("Manf")))=$lb("XDCPSCQYWSXKZ","steHeaLic","消毒产品生产企业卫生许可证")
	
	s CertType=""
	s Len=$o(CertInfo(OrgType,""),-1)
	f i=1:1:Len q:CertType'=""  d
	.i $lg(CertInfo(OrgType,i),1)=CertTypeCode s CertType=$lg(CertInfo(OrgType,i),2) q

	q CertType
}

/// 获取附加表的科室类型
ClassMethod GetLocType(LocId)
{
	q:LocId="" ""
	s DhcLocId=$o(^DHCLOC(0,"LOC",LocId,0))
	q:DhcLocId="" ""
	s LocType=$p(^DHCLOC(DhcLocId),"^",5)
	q LocType
}

/// 保存主条码
ClassMethod SaveMainBarCode(Inci As %String, barcodestr As %String)
{
	q:barcodestr="" 0
	s tmpbarcodestr=""
	s tmprowid=""
	s err=0
	
	ts
	f  s tmprowid=$o(^DHCSPLIT(0,"INCI",Inci,tmprowid)) q:(tmprowid="")||(err'=0)  d
	.s tmpbarcode=$p(^DHCSPLIT(tmprowid),"^",2)
	.q:("/"_barcodestr_"/")[tmpbarcode
	.&sql(delete from DHC_BarCodeSplitInfo where SPLIT_RowId=:tmprowid)
	.i SQLCODE'=0 d
	..s err=-1
	i err'=0 tro  
	q:err'=0 err
	
	s len=$l(barcodestr,"/")
	f i=1:1:len  d
	.s BarCode=$p(barcodestr,"/",i)
	.s splitrowid=$o(^DHCSPLIT(0,"BarCode",BarCode,""))
	.i splitrowid="" d
	..&sql(INSERT INTO DHC_BarCodeSplitInfo (SPLIT_INCI_DR,SPLIT_BarCode) VALUES (:Inci,:BarCode))
	.e  d
	..s splitinci=$p(^DHCSPLIT(splitrowid),"^",1)
	..i splitinci'=Inci d
	...s err=-12
	..e  d
	...&sql(update DHC_BarCodeSplitInfo set SPLIT_BarCode=:Barcode where SPLIT_RowId=:splitrowid)
	...
	i err'=0 tro  
	q:err'=0 err
	tc
	q 0
}

/// 判断库存项是否在使用范围内
/// [各方法统一调用]
ClassMethod GetInciFlag(Inci) As %String
{
	q:Inci="" ""
	s Flag="N"
	s StkType="M"
	s IncscId=$p(^INCI(Inci,2),"^",2)	;库存分类id
	q:IncscId="" Flag
	s ScgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(Inci)
	s ScgType=$p(ScgInfo,"^",3)			;类组(M表示物资)
	s ScgId=$p(ScgInfo,"^",5)			;类组rowid
	s ScgSet=$p(ScgInfo,"^",7)			;类组集合(MM,MO,MR等)
	q:(ScgType'=StkType) Flag
	;q:IncscId'=** Flag					;条件不满足的及时退出
	
	s Flag="Y"
	q Flag
}

}
