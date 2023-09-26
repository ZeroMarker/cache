/// 数据库的相关操作
Class web.DHCFHQ.DHCFDataBaseSet Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

/// 标准版程序升级
ClassMethod UpdatePro()
{
	//增加图表类型定义
	s RetStr=""
	if $d(^epr.CTChartItemTypeI("UniqueCITCodeIndex","CSPNAME")) d
	.s CtCharItemTypeId=$o(^epr.CTChartItemTypeI("UniqueCITCodeIndex","CSPNAME",""))
	else  d
	.s CharItemTypeObj=##class(epr.CTChartItemType).%New()
	.s CharItemTypeObj.CITClass="epr.CTProfileParams"
	.s CharItemTypeObj.CITCode="CSPNAME"
	.s CharItemTypeObj.CITDesc="自定义CSP"
	.s CompId=$o(^websys.ComponentI("UniqueNameIndex","DHCCSPEDITPROFILE",""))
	.s:$g(CompId)="" RetStr="组件DHCCsp.Edit.Profile没有找到"
	.q:$g(CompId)="" 
	.d CharItemTypeObj.CITListProfileComponentDRSetObjectId(CompId)						
	.S CharItemTypeObj.CITURL="epr.ctprofileparams.edit.csp"
	.d CharItemTypeObj.%Save()
	.s CtCharItemTypeId=CharItemTypeObj.%Id()

	//增加自定义CSP
	if $g(CtCharItemTypeId)'="" d
	.s PPTypeDR="CSPNAME"
	.s PPDesc="prnorderdoctorFrame",PPParameters="dhcdoc.prnorderdoctor.csp^0^"
	.s prnorderdoctorFrameId=..InsertCtProfileParams($$ALPHAUP^SSUTIL4(PPDesc),PPParameters,PPTypeDR)
	.s PPDesc="prnordernurseFrame",PPParameters="dhcdoc.prnordernurse.csp^0^"
	.s prnordernurseFrameId=..InsertCtProfileParams($$ALPHAUP^SSUTIL4(PPDesc),PPParameters,PPTypeDR)
	.s PPDesc="sosorderdoctorFrame",PPParameters="dhcdoc.sosorderdoctor.csp^0^"
	.s sosorderdoctorFrameId=..InsertCtProfileParams($$ALPHAUP^SSUTIL4(PPDesc),PPParameters,PPTypeDR)
	.s PPDesc="sosordernurseFrame",PPParameters="dhcdoc.sosordernurse.csp^0^"
	.s sosordernurseFrameId=..InsertCtProfileParams($$ALPHAUP^SSUTIL4(PPDesc),PPParameters,PPTypeDR)
	.s PPDesc="orderfeeFindFrame",PPParameters="dhcipbillpatfeeinfo.csp^1^"
	.s orderfeeFindFrameId=..InsertCtProfileParams($$ALPHAUP^SSUTIL4(PPDesc),PPParameters,PPTypeDR)
	.s PPDesc="orderfeeCheckFrame",PPParameters="dhcipbillpatordfeecheck.csp^1^"
	.s orderfeeCheckFrameId=..InsertCtProfileParams($$ALPHAUP^SSUTIL4(PPDesc),PPParameters,PPTypeDR)
	;q RetStr
	//插入EPR.CHART
	s Name="长期医嘱医生"
	s ChartIdLongDoctor=..InserteprChart(Name,prnorderdoctorFrameId)
	s Name="长期医嘱护士"
	s ChartIdLongNurse=..InserteprChart(Name,prnordernurseFrameId)
	s Name="临时医嘱医生"
	s ChartIdShortDoctor=..InserteprChart(Name,sosorderdoctorFrameId)
	s Name="临时医嘱护士"
	s ChartIdShortNurse=..InserteprChart(Name,sosordernurseFrameId)
	s Name="费用清单"
    s ChartIdChargeDetail=..InserteprChart(Name,orderfeeFindFrameId)
	s Name="医嘱费用查询"
	s ChartIdOrdCharge=..InserteprChart(Name,orderfeeCheckFrameId)
	s Name="DHCMEDICINEMRDIAGNOS"  //诊断录入
	s DHCMEDICINEMRDIAGNOS=..InserteprChart(Name,"")
	s Name="DHCOE"  //医嘱录入
	s DHCOE=..InserteprChart(Name,"")
	s Name="DHCOECM"  //草药录入
	s DHCOECM=..InserteprChart(Name,"")
	s Name="就诊列表"  //就诊列表
	s patlist=..InserteprChart(Name,"")
	s Name="过敏记录"  //
	s gmrec=..InserteprChart(Name,"")
	s Name="检验结果"  //
	s labresult=..InserteprChart(Name,"")
	s Name="检查结果"  //
	s examresult=..InserteprChart(Name,"")
	s Name="病理结果"
	s blresult=..InserteprChart(Name,"")
	s Name="公共卫生报告"  //
	s ggws=..InserteprChart(Name,"")
	s Name="DHCEPRMRDIAGNOSCM"  //中医诊断录入
	s DHCEPRMRDIAGNOSCM=..InserteprChart(Name,"")
	
	s ChartBookObj=##class(epr.ChartBook).%New()
	s ChartBookObj.Description="医生医嘱"
	s a1=##class(epr.Chart).%OpenId(ChartIdLongDoctor)
	s a2=##class(epr.Chart).%OpenId(ChartIdLongNurse)
	s a3=##class(epr.Chart).%OpenId(ChartIdShortDoctor)
	s a4=##class(epr.Chart).%OpenId(ChartIdShortNurse)
	s a5=##class(epr.Chart).%OpenId(ChartIdChargeDetail)
	s a6=##class(epr.Chart).%OpenId(ChartIdOrdCharge)
	s a7=##class(epr.Chart).%OpenId(DHCMEDICINEMRDIAGNOS)
	s a8=##class(epr.Chart).%OpenId(DHCOE)
	s a9=##class(epr.Chart).%OpenId(DHCOECM)
	s a10=##class(epr.Chart).%OpenId(patlist)
	s a11=##class(epr.Chart).%OpenId(gmrec)
	s a12=##class(epr.Chart).%OpenId(labresult)
	s a13=##class(epr.Chart).%OpenId(examresult)
	s a14=##class(epr.Chart).%OpenId(blresult)
	s a15=##class(epr.Chart).%OpenId(ggws)
	s a16=##class(epr.Chart).%OpenId(DHCEPRMRDIAGNOSCM)
	
	s ChartBookId=""
	if '$d(^epr.ChartBookI("UniqueDescriptionIndex","医生医嘱"))  d
	.d ChartBookObj.ChartList.Insert(a1)
	.d ChartBookObj.ChartList.Insert(a3)
	.d ChartBookObj.ChartList.Insert(a6)
	.d ChartBookObj.ChartList.Insert(a7)
	.d ChartBookObj.ChartList.Insert(a8)
	.d ChartBookObj.ChartList.Insert(a9)
	.d ChartBookObj.ChartList.Insert(a10)
	.d ChartBookObj.ChartList.Insert(a11)
	.d ChartBookObj.ChartList.Insert(a12)
	.d ChartBookObj.ChartList.Insert(a13)
	.d ChartBookObj.ChartList.Insert(a14)
	.d ChartBookObj.ChartList.Insert(a15)
	.d ChartBookObj.ChartList.Insert(a16)
	.s status=ChartBookObj.%Save()
	if '$d(^epr.ChartBookI("UniqueDescriptionIndex","护士医嘱"))  d
	.s ChartBookObj=##class(epr.ChartBook).%New()
	.s ChartBookObj.Description="护士医嘱"
	.d ChartBookObj.ChartList.Insert(a2)
	.d ChartBookObj.ChartList.Insert(a4)
	.d ChartBookObj.ChartList.Insert(a6)
	.d ChartBookObj.ChartList.Insert(a5)
	.d ChartBookObj.ChartList.Insert(a12)
	.d ChartBookObj.ChartList.Insert(a13)
	.d ChartBookObj.ChartList.Insert(a14)
	.s status=ChartBookObj.%Save()
}

ClassMethod InsertCtProfileParams(PPDesc, PPParameters, PPTypeDR As %String) As %String
{
	if $d(^epr.CTProfileParamsI("UniquePPDescIndex",PPDesc)) d
	.s CtProfileParamsId=$o(^epr.CTProfileParamsI("UniquePPDescIndex",PPDesc,""))
	else  d
	.s CtProfileParamsObj=##class(epr.CTProfileParams).%New()
	.s CtProfileParamsObj.PPDesc=PPDesc
	.s CtProfileParamsObj.PPParameters=PPParameters
	.d CtProfileParamsObj.PPTypeDRSetObjectId(PPTypeDR)
	.s Status=CtProfileParamsObj.%Save()	
	.s CtProfileParamsId=CtProfileParamsObj.%Id()
	q CtProfileParamsId
}

/// 插入epr.Chart
ClassMethod InserteprChart(Name, CTprofileParamsId) As %String
{
	if $d(^ooChartI("NameIndex",Name)) d
	.s Id=$o(^ooChartI("NameIndex",Name,""))
	else  d
	.q:$g(CTprofileParamsId)=""
	.S ChartObj=##class(epr.Chart).%New()
	.s ChartObj.Name=Name
	.s ChartItemObj = ##Class(epr.ChartItem).%New()
	.s ChartItemObj.Item=CTprofileParamsId
	.s ChartItemObj.Rows=20
	.s ChartItemObj.ItemType=$list(^epr.CTProfileParamsD(CTprofileParamsId),4)
	.d ChartObj.ChartSettings.Insert(ChartItemObj)
	.s status = ChartObj.%Save()
	.s Id=ChartObj.%Id()
	q $g(Id)
}

//d ##class(web.DHCFHQ.DHCFDataBaseSet).setDataBase()

ClassMethod setDataBase()
{
	zn "%sys"
	s ResourceExists=##class(Security.Resources).Exists("%DB_TrakApp")
	if ResourceExists'=1 d
	.s ResourceExists=##class(Security.Resources).Create("%DB_TrakApp","Dthealth Resource","R,W")
	if $g(ResourceExists)="" w "创建资源失败" q
	s RoleExists=##class(Security.Roles).Exists("TrakUser")
	if RoleExists'=1 d
	.s RoleObj=##class(Security.Roles).%New()
	.s RoleObj.Name="TrakUser"
	.d RoleObj.%Save()
	.d RoleObj.%Close()
	s RoleObj=##class(Security.Roles).%OpenId("trakuser")
	if RoleObj d
	.s ResObj=##class(Security.Resource).%New("trakuser")
	.s ResObj.Name="%DB_TrakApp"
	.s ResObj.TheRole=RoleObj
	.s ResObj.Permission=3
	.d ResObj.%Save()
	.d ResObj.%Close()
	.s ResObj=##class(Security.Resource).%New("trakuser")
	.s ResObj.Name="%DB_CACHESYS"
	.s ResObj.TheRole=RoleObj
	.s ResObj.Permission=3
	.d ResObj.%Save()
	.d ResObj.%Close()
	.s ResObj=##class(Security.Resource).%New("trakuser")
	.s ResObj.Name="%Service_CSP"
	.s ResObj.TheRole=RoleObj
	.s ResObj.Permission=4
	.d ResObj.%Save()	
	.d ResObj.%Close()
	.s ResObj=##class(Security.Resource).%New("trakuser")
	.s ResObj.Name="%Service_CacheDirect"
	.s ResObj.TheRole=RoleObj
	.s ResObj.Permission=4
	.d ResObj.%Save()
	.d ResObj.%Close()

	q:'RoleObj "Role:TrakUser为空"
	s UserExists=##class(Security.Users).Exists("tkuser")
	if UserExists'=1 d
	.D ##class(Security.Users).Create("tkuser","TrakUser","dhcc","dhcc","DHC-APP")
	
	zn "dhc-app"
}

}
