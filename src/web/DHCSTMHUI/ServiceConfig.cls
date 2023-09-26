Import sqluser

Class web.DHCSTMHUI.ServiceConfig Extends (%RegisteredObject, %XML.Adaptor, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	查询接口配置
/// Creator:	lxt
/// CreateDate:	2021-6-24
/// Table:		DHC_ServiceConfig
/// Input:		查询条件
/// Return：	
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.ServiceConfig","SelectAll",^templxt("SelectAll"))
Query SelectAll(Params As %String) As Query(ROWSPEC = "RowId,Type,LocalIP,User,PassWord,UseFlag") [ SqlProc ]
{
}

ClassMethod SelectAllExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)

	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)

	s pType=PJObj.%Get("Type")
	s pLocalIP=PJObj.%Get("LocalIP")		// Cache服务器IP地址,如果有多个ECP,使用逗号隔开; 防止备测试库之后,测试库会调用ECS的可能.

	s pUser=PJObj.%Get("User")		//用户名
	s pUseFlag=PJObj.%Get("UseFlag")		//是否启用
	s gHospId=PJObj.%Get("gHospId")
	s pHospId=PJObj.%Get("BDPHospital")
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	
	s RowId=""
	f  s RowId=$o(^User.DHCServiceConfigD(RowId)) q:(+RowId=0)  d
	.//判断医院权限
	.s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("DHC_ServiceConfig",RowId,pHospId)
	.q:ShowDataFlag="N"
	.s SCInfo=^User.DHCServiceConfigD(RowId)
	.s Type=$list(SCInfo,2)
	.s LocalIP=$list(SCInfo,3)
	.s User=$list(SCInfo,4)
	.s PassWord=$list(SCInfo,5)
	.s:PassWord'="" PassWord="******"
	.s UseFlag=$list(SCInfo,6)
	.s:UseFlag="" UseFlag="N"
	.q:(pType'="")&&(pType'=Type)
	.q:(pLocalIP'="")&&(LocalIP'[pLocalIP)
	.q:(pUser'="")&&(pUser'=User)
	.q:(pUseFlag'="")&&(pUseFlag'=UseFlag)
	.d OutPutRow1
	Quit $$$OK
	
OutPutRow1
	s Data=$lb(RowId,Type,LocalIP,User,PassWord,UseFlag)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	保存
/// 对象类型数据
/// w ##class(web.DHCSTMHUI.ServiceConfig).jsSave(^templxt("save",1),^templxt("save",2))
ClassMethod jsSave(Main As %String, Detail As %String) As %String
{
	n (Main,Detail,%session)
	s $ZT=..sssError()
	ts
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..Save(Main,Detail)
	i RtnObj.success'=0  tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Descript:	保存接口配置
/// Creator:	lxt
/// CreateDate:	2021-6-24
/// Table:		DHC_ServiceConfig
/// Input:		
/// Return：	成功，失败
ClassMethod Save(Main As %String, Detail As %String) As RtnObj
{
	n (Main,Detail,%session)
	s RtnObj=##class(RtnObj).%New()
	s MethodName=$CLASSNAME()_".Save"
	
	s MainPJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	q:MainPJObj.%FromJSON(Main)'=0 RtnObj.Err(-1,"","入参解析失败!","",0)
	
	s gHospId=MainPJObj.%Get("gHospId")
	s pHospId=MainPJObj.%Get("BDPHospital")
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	q:PJObj.%FromJSON(Detail)'=0 RtnObj.Err(-1,"","入参解析失败!","",0)
	
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		s Type=Obj.%Get("Type")
		s LocalIP=Obj.%Get("LocalIP")
		s User=Obj.%Get("User")
		s PassWord=Obj.%Get("PassWord")
		s:PassWord'="******" PassWord=##class(web.DHCSTMHUI.Common.UtilCommon).EncryptPW(PassWord)
		s UseFlag=Obj.%Get("UseFlag")
		
		i (UseFlag="Y")&&(Type="ECS")&&((LocalIP="")||(User="")||(PassWord="")) d RtnObj.Err(-6,"",MethodName_":IP、授权ID、授权码不能为空!")
		e  i (UseFlag="Y")&&(Type'="ECS")&&(LocalIP="") d RtnObj.Err(-6,"",MethodName_":IP不能为空!")
		q:RtnObj.success<0
		
		i RowId="" d
		.s obj=##class(User.DHCServiceConfig).%New()
		e  d
		.s obj=##class(User.DHCServiceConfig).%OpenId(RowId)
		.d obj.%Reload()
		
		s obj.SCType=Type
		s obj.SCLocalIP=LocalIP
		s obj.SCUser=User
		s:PassWord'="******" obj.SCPassWord=PassWord
		s obj.SCUseFlag=UseFlag
		s Sc=obj.%Save()
		i $$$ISERR(Sc) d RtnObj.Err(-6,"",MethodName_":保存失败!")
		q:RtnObj.success<0
		
		i RowId="" d
		.s RowId=obj.%Id()
		.//保存医院关联
		.s ret=##class(web.DHCSTMHUI.MatForBDPData).SaveHOSP("DHC_ServiceConfig",RowId,pHospId)
		.i ret<0 d RtnObj.Err(-7,"","关联医院失败"_ret)
		q:RtnObj.success<0
	}
	
	q RtnObj
}

/// Descript:	获取接口配置
/// Creator:	lxt
/// CreateDate:	2021-6-24
/// Table:		DHC_ServiceConfig
/// Input:		
/// Return：	成功，失败
/// w ##class(web.DHCSTMHUI.ServiceConfig).GetSerUseFlag("ECS",2)
ClassMethod GetSerUseFlag(Type As %String, HospId As %String = "") As %String
{
	n (Type,HospId)
	q:(Type="") "N"
	
	s ServerIP=##class(web.DHCSTMHUI.Common.UtilCommon).ServerIP()
	
	s (RowId,LocalIP,User,PassWord,UseFlag,TypeId)=""
	s count=0
	f  s RowId=$o(^User.DHCServiceConfigI("Type",Type,RowId)) q:(+RowId=0)||(count>0)  d
	.//判断医院权限
	.q:(HospId'="")&&(##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("DHC_ServiceConfig",RowId,HospId)="N")
	.s SCInfo=^User.DHCServiceConfigD(RowId)
	.s UseFlag=$list(SCInfo,6)
	.q:UseFlag'="Y"
	.s LocalIP=$list(SCInfo,3)
	.s User=$list(SCInfo,4)
	.s PassWord=$list(SCInfo,5)
	.s PassWord=##class(web.DHCSTMHUI.Common.UtilCommon).DecryptPW(PassWord)
	.s TypeId=RowId
	.q:LocalIP=""
	.s LoccalIPList=$lfs(LocalIP,",")
	.q:'$lf(LoccalIPList,ServerIP)
	.s count=count+1
	q:count=0 "N"
	
	s ^DHCSTM("ServiceConfig",Type_HospId)=LocalIP_"^"_User_"^"_PassWord_"^"_TypeId
	
	q "Y"
}

/// Descript:	获取所有接口配置
/// Creator:	lxt
/// CreateDate:	2021-6-24
/// Table:		DHC_ServiceConfig
/// Input:		
/// Return：	成功，失败
/// w ##class(web.DHCSTMHUI.ServiceConfig).GetAllSerUseFlag(2)
ClassMethod GetAllSerUseFlag(HospId As %String = "") As %String
{
	n (HospId)
	
	s ServerIP=##class(web.DHCSTMHUI.Common.UtilCommon).ServerIP()
	s (TitleStr,DataStr)=""
	s Type=""
	f  s Type=$o(^User.DHCServiceConfigI("Type",Type)) q:(Type="")  d
	.s tmpId="",count=0
	.f  s tmpId=$o(^User.DHCServiceConfigI("Type",Type,tmpId)) q:(+tmpId=0)||(count>0)  d
	..//判断医院权限
	..q:(HospId'="")&&(##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("DHC_ServiceConfig",tmpId,HospId)="N")
	..s SCInfo=^User.DHCServiceConfigD(tmpId)
	..s Type=$list(SCInfo,2)
	..s UseFlag=$list(SCInfo,6)
	..s LocalIP=$list(SCInfo,3)
	..s:UseFlag'="Y" UseFlag="N"
	..q:LocalIP=""
	..s LoccalIPList=$lfs(LocalIP,",")
	..q:'$lf(LoccalIPList,ServerIP)
	..i TitleStr="" d
	...s TitleStr=Type
	...s DataStr=UseFlag
	..e  d
	...s TitleStr=TitleStr_"^"_Type
	...s DataStr=DataStr_"^"_UseFlag
	..s count=count+1
	
	s ValueStr=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(DataStr,TitleStr)
	q ValueStr
}

}
