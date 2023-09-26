Import sqluser

Class web.CSSDHUI.DataInit Extends (%RegisteredObject, %XML.Adaptor, CSSDType) [ Not ProcedureBlock ]
{

/// Descript:	查询数据初始化信息
/// Creator:	lxt
/// CreateDate:	2021-12-27
/// Table:		DataInitRecord
/// Input:		查询条件
/// Return：	
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.DataInit","Query",^tmpljlkk)
Query Query(Params As %String) As Query(ROWSPEC = "RowId:%Integer,Type,Name,Description,Date,Time,User,Hosp,TableName") [ SqlProc ]
{
}

ClassMethod QueryExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s ^tmpljlkk=Params
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	s pInitFlag=PJObj.%Get("InitFlag")
	
	k DataType
	s DataType($i(DataType))=$lb("SysParame","参数配置","程序模块，参数配置","N")
	s DataType($i(DataType))=$lb("PrintRule","打印规则","","Y")
	s DataType($i(DataType))=$lb("CleanSterType","清洗和灭菌的方式","清洗方式 灭菌方式","N")
	s DataType($i(DataType))=$lb("CleanSterPro","清洗和灭菌的程序","清洗程序 灭菌程序","N")
	s DataType($i(DataType))=$lb("Reason","原因参考值","灭菌不合格原因 清洗不合格原因 器械报损原因 消毒包召回原因","N")
	s DataType($i(DataType))=$lb("Material","包装材料参考值","","N")
	s DataType($i(DataType))=$lb("PackageSpec","消毒包规格参考值","","N")
	s DataType($i(DataType))=$lb("Satisfaction","满意度调查项目","","N")
	
	s i=0
	s (Type,Name,Description,OnlyInitFlag,TableName)=""
	f  s i=$o(DataType(i)) q:(i="")  d
	.s data=DataType(i)
	.s Type=$list(data,1)
	.s:Type="SysParame" TableName="CSSD_Parameter"
	.s:Type="CleanSterType" TableName="CSSD_CleanType"
	.s:Type="CleanSterPro" TableName="CSSD_BaseCode"
	.s:Type="Reason" TableName="CSSD_SteCheckReason" 
	.s:Type="Material" TableName="CSSD_Material" 
	.s:Type="PackageSpec" TableName="CT_STER_CSSD.PackageSpec"
	.s:Type="Satisfaction" TableName="CT_STER_CSSD.Satisfaction"
	.s HospStr=##class(web.CSSDHUI.HospMap).GetDefHospStr(TableName)
	.q:((pInitFlag'="Y")&&(HospStr=""))
	.
	.s Name=$list(data,2)
	.s Description=$list(data,3)
	.s OnlyInitFlag=$list(data,4)	//是否仅系统部署时初始化
	.q:(pInitFlag'="Y")&&(OnlyInitFlag="Y")
	.
	.s (RowId,Date,Time,User,Hosp,UserName,HospDesc)=""
	.s RowId=$o(^CT.STER.CSSD.DataInitRecordI("Type",Type,""),-1)
	.i RowId'="" d
	..s RecordData=^CT.STER.CSSD.DataInitRecordD(RowId)
	..s Date=$list(RecordData,3)
	..s Time=$list(RecordData,4)
	..s UserId=$list(RecordData,5)
	..s HospId=$list(RecordData,6)
	..s:Date'="" Date=..DL2H(Date)
	..s:Time'="" Time=..TL2H(Time)
	..s:UserId'="" UserName=$p(^SSU("SSUSR",UserId),"^",2)
	..s:HospId'="" HospDesc=$p(^CT("HOSP",HospId),"^",2)
	.d OutPutRow1
	Quit $$$OK
	
OutPutRow1
	s Data=$lb(RowId,Type,Name,Description,Date,Time,UserName,HospDesc,TableName)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	初始化配置(院区、系统)
/// Creator:	lxt
/// CreateDate:	2021-6-24
/// Table:		DataInitRecord
/// Input:		InitFlag:"Y"首次初始化,"N"同步新增
/// Return：	成功，失败
/// w ##class(web.CSSDHUI.DataInit).jsInit(^tmpljlkk)
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

ClassMethod Init(Params As %String) As RtnObj
{
	n (Params,%session)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	q:PJObj.%FromJSON(Params)'=0 RtnObj.Err(-1,"","入参解析失败!","",0)
	
	s gUserId=PJObj.%Get("gUserId")
	s gLocId=PJObj.%Get("gLocId")
	s gGroupId=PJObj.%Get("gGroupId")
	s gHospId=PJObj.%Get("gHospId")
	s BDPHospId=PJObj.%Get("BDPHospital")	//医院下拉框数据
	s pType=PJObj.%Get("Type")	//初始化数据类型
	s pSynFlag=PJObj.%Get("SynFlag") //同步标志
	s pInitFlag=PJObj.%Get("InitFlag")	//是否首次部署系统
	s:pInitFlag="" pInitFlag="N"
	s Date=+$h
	s Time=$p($h,",",2)
	
	s PkgSpecHospId="",SatisHospId=""
	i ((pInitFlag="N")&&(pType="PackageSpec")) d
	.s PkgSpecHospId=##class(web.CSSDHUI.HospMap).GetDefHospStr("CT_STER_CSSD.PackageSpec")
	.i PkgSpecHospId="" d RtnObj.Err(-11,"","此模块仅允许首次部署系统初始化","",0)
	.q:RtnObj.success'=0
	q:RtnObj.success'=0 RtnObj
	
	i ((pInitFlag="N")&&(pType="Satisfaction")) d
	.s SatisHospId=##class(web.CSSDHUI.HospMap).GetDefHospStr("CT_STER_CSSD.Satisfaction")
	.i SatisHospId="" d RtnObj.Err(-1,"","此模块仅允许首次部署系统初始化","",0)
	.q:RtnObj.success'=0
	q:RtnObj.success'=0 RtnObj
	
	q:((pInitFlag="N")&&(BDPHospId="")) RtnObj.Err(-1,"","非首次部署系统初始化，必须选择院区","",0)
	q:((pInitFlag="N")&&((pType="GridSet")||(pType="PrintRule"))) RtnObj.Err(-1,"","此模块仅允许首次部署系统初始化","",0)
	
	i (pInitFlag="N")&&(pSynFlag'="1") d
	.s RowId=$o(^CT.STER.CSSD.DataInitRecordI("TypeHosp",pType,BDPHospId,""),-1)
	.i RowId'="" d RtnObj.Err(-2,"","医院此模块已初始化，不允许院区初始化","",0)
	.q:RtnObj.success'=0
	q:RtnObj.success'=0 RtnObj
	
	i (pInitFlag="Y") d
	.s RowId=$o(^CT.STER.CSSD.DataInitRecordI("Type",pType,""),-1)
	.i RowId'="" d RtnObj.Err(-2,"","此模块已初始化，不允许系统部署初始化","",0)
	.q:RtnObj.success'=0
	q:RtnObj.success'=0 RtnObj
	
	s HospStr=""
	i pType="SysParame" d
	.s HospStr=..InitHosp(pInitFlag,"CSSD_Parameter",BDPHospId)
	.s RtnObj=..InitSysParame(HospStr,pInitFlag)
	.q:RtnObj.success'=0
	.
	e  i pType="GridSet" d
	.s RtnObj=..InitGridSet()
	.q:RtnObj.success'=0
	.
	e  i pType="PrintRule" d
	.s RtnObj=..InitPrintRule()
	.q:RtnObj.success'=0
	.
	e  i pType="CleanSterType" d
	.s HospStr=..InitHosp(pInitFlag,"CSSD_CleanType",BDPHospId)
	.s RtnObj=..InitCleanType(HospStr,pInitFlag)
	.q:RtnObj.success'=0
	.s RtnObj=..InitSterType(HospStr,pInitFlag)
	.q:RtnObj.success'=0
	.
	e  i pType="CleanSterPro" d
	.s HospStr=..InitHosp(pInitFlag,"CSSD_BaseCode",BDPHospId)
	.s RtnObj=..InitCleanPro(HospStr,pInitFlag)
	.q:RtnObj.success'=0
	.s RtnObj=..InitSterPro(HospStr,pInitFlag)
	.q:RtnObj.success'=0
	.
	e  i pType="Reason" d
	.s HospStr=..InitHosp(pInitFlag,"CSSD_SteCheckReason",BDPHospId)
	.s RtnObj=..InitSteCheckReason(HospStr,pInitFlag)
	.q:RtnObj.success'=0
	.s RtnObj=..InitCleanItmReason(HospStr,pInitFlag)
	.q:RtnObj.success'=0
	.s RtnObj=..InitMachineConsumeReason(HospStr,pInitFlag)
	.q:RtnObj.success'=0
	.s RtnObj=..InitRecallReason(HospStr,pInitFlag)
	.q:RtnObj.success'=0
	.
	e  i pType="Material" d
	.s HospStr=..InitHosp(pInitFlag,"CSSD_Material",BDPHospId)
	.s RtnObj=..InitMaterial(HospStr,pInitFlag)
	.q:RtnObj.success'=0
	.
	e  i pType="PackageSpec" d
	.s InitRtnObj=..InitHosp(pInitFlag,"CT_STER_CSSD.PackageSpec",BDPHospId)
	.s RtnObj=..InitPackageSpec(HospStr,pInitFlag)
	.q:RtnObj.success'=0
	.
	e  i pType="Satisfaction" d
	.s HospStr=..InitHosp(pInitFlag,"CT_STER_CSSD.Satisfaction",BDPHospId)
	.s RtnObj=..InitSatisfaction(HospStr,pInitFlag)
	.q:RtnObj.success'=0
	q:RtnObj.success'=0 RtnObj
	
	i HospStr="" d
	.&sql(insert into CT_STER_CSSD.DataInitRecord(DIR_Type,DIR_Date,DIR_Time,DIR_User,DIR_Hosp) values (:pType,:Date,:Time,:gUserId,:HospStr))
	.i SQLCODE'=0 d RtnObj.Err(-3,"","插入初始化记录失败","",0)
	e  d
	.s HospLen=$l(HospStr,"^")
	.f i=1:1:HospLen q:RtnObj.success'=0  d
	..s HospId=$p(HospStr,"^",i)
	..&sql(insert into CT_STER_CSSD.DataInitRecord(DIR_Type,DIR_Date,DIR_Time,DIR_User,DIR_Hosp) values (:pType,:Date,:Time,:gUserId,:HospId))
	..i SQLCODE'=0 d RtnObj.Err(-3,"","插入初始化记录失败","",0)
	..q:RtnObj.success'=0
	.q:RtnObj.success'=0
	
	q RtnObj
}

/// 根据表名取哪个医院的配置，返回医院id
ClassMethod InitHosp(InitFlag, TableName, BDPHospId) As RtnObj
{
	n (InitFlag,TableName,BDPHospId)
	s HospStr=""
	i InitFlag="Y" d
	.s HospStr=##class(web.CSSDHUI.HospMap).GetDefHospStr(TableName)
	e  d
	.s HospStr=##class(web.CSSDHUI.HospMap).GetDefHospId(TableName,BDPHospId)
	q HospStr
}

/// InitFlag:"Y" 首次初始化
/// 初始化参数配置
ClassMethod InitSysParame(HospStr, InitFlag) As RtnObj
{
	n (HospStr,InitFlag,%session)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	
	i InitFlag="Y" d
	.s count=0
	.&sql(SELECT count(1) into :count FROM CSSD_BaseDataType)
	.i count>0 d RtnObj.Err(-2,"","系统未进行数据清理，不允许初始化！")
	.q:RtnObj.success'=0
	.
	.d ##class(web.CSSDHUI.Tools.CleanData).DeleteBDPMappingHosp("CSSD_Parameter")
	.s HospStr=##class(web.CSSDHUI.HospMap).GetDefHospStr("CSSD_Parameter")
	q:RtnObj.success'=0 RtnObj
	
	k PARAME
	d ##class(web.CSSDHUI.Init.InitParamete).InitBaseCodeType()
	d ##class(web.CSSDHUI.Init.InitParamete).InitParameterData()
	
	s Len=$l(HospStr,"^")
	s i=0
	f  s i=$o(PARAME(i)) q:(i="")||(RtnObj.success'=0)  d
	.s lbdata=PARAME(i)
	.s baseTypeCode=$list(lbdata,1)
	.s paramCode=$list(lbdata,2)
	.s paramDesc=$list(lbdata,3)
	.s paraValue=$list(lbdata,4)
	.s paraExplain=$list(lbdata,5)
	.s baseTypeId=##class(web.CSSDHUI.Init.InitParamete).getparF(baseTypeCode)
	.q:baseTypeId=""
	.
	.i HospStr="" d
	..s ExistId=$$CheckExistParame(baseTypeId,paramCode,HospStr)
	..i ExistId="" d
	...&sql(INSERT INTO CSSD_Parameter(CSSDP_ParaCode,CSSDP_ParaName,CSSDP_ParaValue,CSSDP_ParaExplain,CSSDDP_BaseTypeDr ) 
		VALUES (:paramCode,:paramDesc,:paraValue,:paraExplain,:baseTypeId))
	...i SQLCODE'=0 d RtnObj.Err(-3,"","保存参数失败")
	...q:RtnObj.success'=0
	...
	..e  d
	...&sql(update CSSD_Parameter set CSSDP_ParaExplain=:paraExplain where ID=:ExistId)
	...i SQLCODE'=0 d RtnObj.Err(-3,"","保存参数失败")
	...q:RtnObj.success'=0
	..q:RtnObj.success'=0
	..
	.e  d
	..f j=1:1:Len q:(RtnObj.success'=0)  d
	...s HospId=$p(HospStr,"^",j)
	...s ExistId=$$CheckExistParame(baseTypeId,paramCode,HospId)
	...i ExistId="" d
	....&sql(INSERT INTO CSSD_Parameter(CSSDP_ParaCode,CSSDP_ParaName,CSSDP_ParaValue,CSSDP_ParaExplain,CSSDDP_BaseTypeDr ) 
		VALUES (:paramCode,:paramDesc,:paraValue,:paraExplain,:baseTypeId))
	....i SQLCODE'=0 d RtnObj.Err(-3,"","保存参数失败")
	....q:RtnObj.success'=0
	....
	....s RowId=%ROWID
	....s ret=##class(web.CSSDHUI.HospMap).SaveHOSP("CSSD_Parameter",RowId,HospId)
	....i ret'=0 d RtnObj.Err(-5,"","关联院区失败")
	....q:RtnObj.success'=0
	....
	...e  d
	....&sql(update CSSD_Parameter set CSSDP_ParaExplain=:paraExplain where ID=:ExistId)
	....i SQLCODE'=0 d RtnObj.Err(-4,"","保存参数失败")
	....q:RtnObj.success'=0
	...q:RtnObj.success'=0
	..q:RtnObj.success'=0
	.q:RtnObj.success'=0
	
	q RtnObj
	
CheckExistParame(type,code,HospId)
	s ExistId=""
	i HospId'="" d
	.s tmprowid=""
	.f  s tmprowid=$o(^User.CSSDParameterI("IndexCSSDPParaCodeType",code,type,tmprowid)) q:(tmprowid="")||(ExistId'="")  d
	..s ShowDataFlag=##class(web.CSSDHUI.HospMap).GetShowDataFlag("CSSD_Parameter",tmprowid,HospId)
	..q:ShowDataFlag="N"
	..s ExistId=tmprowid
	e  d
	.s tmpExistId=""
	.&sql(select %ID into :tmpExistId from CSSD_Parameter where CSSDDP_BaseTypeDr=:type and CSSDP_ParaCode=:code)
	.i SQLCODE s ExistId=tmpExistId
	
	q ExistId
}

/// 仅支持首次初始化
/// 初始化列设置
ClassMethod InitGridSet() As RtnObj
{
	n (%session)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s count=0
	&sql(select count(1) into :count from CSSD_SysGridSet)
	q:count'>0 RtnObj
	
	&sql(delete from CSSD_SysGridSet)
	i SQLCODE'=0 d RtnObj.Err(-3,"","初始化列设置失败！","",0)
	
	q RtnObj
}

/// InitFlag:"Y" 首次初始化
/// 初始化打印规则
ClassMethod InitPrintRule() As web.CSSDHUI.RtnObj
{
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	
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
	
	s count=0
	&sql(select count(1) into :count from CT_STER_CSSD.PrintRules)
	i count>0 d RtnObj.Err(-2,"","系统未进行数据清理，不允许初始化！")
	q:RtnObj.success'=0 RtnObj
	
	s i=0
	f  s i=$o(PrintRules(i)) q:(i="")||(RtnObj.success'=0)  d
	.s data=PrintRules(i)
	.s Code=$list(data,1)
	.s Description=$list(data,2)
	.s RowId=$o(^CT.STER.CSSD.PrintRulesI("CSSDPRCode",Code,""))
	.q:RowId'=""
	.
	.&sql(insert into CT_STER_CSSD.PrintRules(PR_Code,PR_Desc) values(:Code,:Description))
	.i SQLCODE'=0 d RtnObj.Err(-2,"","初始化打印规则失败")
	
	q RtnObj
}

/// InitFlag:"Y" 首次初始化
/// 初始化清洗方法
ClassMethod InitCleanType(HospStr, InitFlag) As web.CSSDHUI.RtnObj
{
	n (HospStr,InitFlag)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	
	i InitFlag="Y" d
	.s count=0
	.&sql(SELECT count(1) into :count FROM CSSD_CleanType)
	.i count>0 d RtnObj.Err(-2,"","系统未进行数据清理，不允许初始化！")
	.q:RtnObj.success'=0
	.
	.d ##class(web.CSSDHUI.Tools.CleanData).DeleteBDPMappingHosp("CSSD_CleanType")
	.s HospStr=##class(web.CSSDHUI.HospMap).GetDefHospStr("CSSD_CleanType")
	q:RtnObj.success'=0 RtnObj
	
	k BasicData
	s BasicData($i(BasicData))=$lb("01","手工清洗","Y")
	s BasicData($i(BasicData))=$lb("02","机器清洗","N")
	s BasicData($i(BasicData))=$lb("03","手工+机器清洗","N")
	
	s Len=$l(HospStr,"^")
	s i=0
	f  s i=$o(BasicData(i)) q:(i="")||(RtnObj.success'=0)  d
	.s Data=BasicData(i)
	.s Code=$list(Data,1)
	.s Desc=$list(Data,2)
	.s IsManual=$list(Data,3)
	.i HospStr="" d
	..s tmprowid=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Code",Code,"CSSD_CleanType","")
	..q:tmprowid'=""
	..
	..s tmprowid=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Desc",Desc,"CSSD_CleanType","")
	..q:tmprowid'=""
	..
	..&sql(insert into CSSD_CleanType (CSSDCT_CleanCode,CSSDCT_CleanMode,CSSDCT_IsManualTemp)
		values (:Code,:Desc,:IsManual)) 
	..i SQLCODE'=0 d RtnObj.Err(-3,"","初始化数据失败")
	.e  d
	..f j=1:1:Len q:(RtnObj.success'=0)  d
	...s HospId=$p(HospStr,"^",j)
	...s tmprowid=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Code",Code,"CSSD_CleanType",HospId)
	...q:tmprowid'=""
	...
	...s tmprowid=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Desc",Desc,"CSSD_CleanType",HospId)
	...q:tmprowid'=""
	...
	...&sql(insert into CSSD_CleanType (CSSDCT_CleanCode,CSSDCT_CleanMode,CSSDCT_IsManualTemp)
		values (:Code,:Desc,:IsManual))
	...i SQLCODE'=0 d RtnObj.Err(-4,"","初始化数据失败")
	...s RowId=%ROWID
	...s ret=##class(web.CSSDHUI.HospMap).SaveHOSP("CSSD_CleanType",RowId,HospId)
	...i ret'=0 d RtnObj.Err(-5,"","关联院区失败")
	
	q RtnObj
}

/// InitFlag:"Y" 首次初始化
/// 初始化灭菌方式
ClassMethod InitSterType(HospStr, InitFlag) As web.CSSDHUI.RtnObj
{
	n (HospStr,InitFlag)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	
	i InitFlag="Y" d
	.s count=0
	.&sql(SELECT count(1) into :count FROM CSSD_SterType)
	.i count>0 d RtnObj.Err(-2,"","系统未进行数据清理，不允许初始化！")
	.q:RtnObj.success'=0
	.
	.d ##class(web.CSSDHUI.Tools.CleanData).DeleteBDPMappingHosp("CSSD_SterType")
	.s HospStr=##class(web.CSSDHUI.HospMap).GetDefHospStr("CSSD_SterType")
	q:RtnObj.success'=0 RtnObj
	
	k BasicData
	s BasicData($i(BasicData))=$lb("01","高温灭菌","Y","Y","N","#EE4F38")
	s BasicData($i(BasicData))=$lb("02","低温灭菌","Y","Y","Y","#328100")
	s BasicData($i(BasicData))=$lb("03","高水平消毒","Y","N","N","#449BE3")
	s BasicData($i(BasicData))=$lb("04","环氧乙烷灭菌","Y","Y","Y","#8BE550")
	s BasicData($i(BasicData))=$lb("05","过氧化氢低温等离子灭菌","Y","Y","Y","#D17604")
	
	s Len=$l(HospStr,"^")
	s i=0
	f  s i=$o(BasicData(i)) q:(i="")||(RtnObj.success'=0)  d
	.s Data=BasicData(i)
	.s Code=$list(Data,1)
	.s Desc=$list(Data,2)
	.s UseFlag=$list(Data,3)
	.s IsSter=$list(Data,4)
	.s IsLower=$list(Data,5)
	.s DisplayColor=$list(Data,6)
	.i HospStr="" d
	..s tmprowid=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Code",Code,"CSSD_SterType","")
	..q:tmprowid'=""
	..
	..s tmprowid=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Desc",Desc,"CSSD_SterType","")
	..q:tmprowid'=""
	..
	..&sql(insert into CSSD_SterType (CSSDST_SterCode,CSSDST_SterName,CSSDST_NotUseFlag,CSSDST_IsSter,CSSDST_IsLowerTemp,CSSDST_DisplayColor) 
		values (:Code,:Desc,:UseFlag,:IsSter,:IsLower,:DisplayColor))
	..i SQLCODE'=0 d RtnObj.Err(-3,"","初始化数据失败")
	.e  d
	..f j=1:1:Len q:(RtnObj.success'=0)  d
	...s HospId=$p(HospStr,"^",j)
	...s tmprowid=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Code",Code,"CSSD_SterType",HospId)
	...q:tmprowid'=""
	...
	...s tmprowid=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Desc",Desc,"CSSD_SterType",HospId)
	...q:tmprowid'=""
	...
	...&sql(insert into CSSD_SterType (CSSDST_SterCode,CSSDST_SterName,CSSDST_NotUseFlag,CSSDST_IsSter,CSSDST_IsLowerTemp,CSSDST_DisplayColor) 
		values (:Code,:Desc,:UseFlag,:IsSter,:IsLower,:DisplayColor))
	...i SQLCODE'=0 d RtnObj.Err(-4,"","初始化数据失败")
	...s RowId=%ROWID
	...s ret=##class(web.CSSDHUI.HospMap).SaveHOSP("CSSD_SterType",RowId,HospId)
	...i ret'=0 d RtnObj.Err(-5,"","关联院区失败")
	
	q RtnObj
}

/// InitFlag:"Y" 首次初始化
/// 初始化清洗程序
ClassMethod InitCleanPro(HospStr, InitFlag) As web.CSSDHUI.RtnObj
{
	n (HospStr,InitFlag)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	
	s CodeType="1001"
	i InitFlag="Y" d
	.s count=0
	.&sql(SELECT count(1) into :count FROM CSSD_BaseCode where CSSDDC_CodeType=:CodeType)
	.i count>0 d RtnObj.Err(-2,"","系统未进行数据清理，不允许初始化！")
	.q:RtnObj.success'=0
	.
	.d ##class(web.CSSDHUI.Tools.CleanData).DeleteBDPMappingHosp("CSSD_BaseCode")
	.s HospStr=##class(web.CSSDHUI.HospMap).GetDefHospStr("CSSD_BaseCode")
	q:RtnObj.success'=0 RtnObj
	
	k BasicData
	s BasicData($i(BasicData))=$lb("01","手工清洗","Y")
	s BasicData($i(BasicData))=$lb("02","机械清洗","Y")
	s BasicData($i(BasicData))=$lb("03","终末漂洗","Y")
	
	s Len=$l(HospStr,"^")
	s i=0
	f  s i=$o(BasicData(i)) q:(i="")||(RtnObj.success'=0)  d
	.s Data=BasicData(i)
	.s Code=$list(Data,1)
	.s Desc=$list(Data,2)
	.s UseFlag=$list(Data,3)
	.i HospStr="" d
	..s tmprowid=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Code",Code,"CSSD_BaseCode","","",CodeType)
	..q:tmprowid'=""
	..
	..s tmprowid=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Desc",Desc,"CSSD_BaseCode","","",CodeType)
	..q:tmprowid'=""
	..
	..&sql(insert into CSSD_BaseCode (CSSDDC_Code,CSSDDC_Name,CSSDDC_CodeType,CSSDDC_NotUseFlag) 
		values (:Code,:Desc,:CodeType,:UseFlag))
	..i SQLCODE'=0 d RtnObj.Err(-3,"","初始化数据失败")
	.e  d
	..f j=1:1:Len q:(RtnObj.success'=0)  d
	...s HospId=$p(HospStr,"^",j)
	...s tmprowid=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Code",Code,"CSSD_BaseCode",HospId,"",CodeType)
	...q:tmprowid'=""
	...
	...s tmprowid=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Desc",Desc,"CSSD_BaseCode",HospId,"",CodeType)
	...q:tmprowid'=""
	...
	...&sql(insert into CSSD_BaseCode (CSSDDC_Code,CSSDDC_Name,CSSDDC_CodeType,CSSDDC_NotUseFlag) 
		values (:Code,:Desc,:CodeType,:UseFlag))
	...i SQLCODE'=0 d RtnObj.Err(-4,"","初始化数据失败")
	...s RowId=%ROWID
	...s ret=##class(web.CSSDHUI.HospMap).SaveHOSP("CSSD_BaseCode",RowId,HospId)
	...i ret'=0 d RtnObj.Err(-5,"","关联院区失败")
	
	q RtnObj
}

/// InitFlag:"Y" 首次初始化
/// 初始化灭菌程序
ClassMethod InitSterPro(HospStr, InitFlag) As web.CSSDHUI.RtnObj
{
	n (HospStr,InitFlag)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	
	s CodeType="2001"
	i InitFlag="Y" d
	.s count=0
	.&sql(SELECT count(1) into :count FROM CSSD_BaseCode where CSSDDC_CodeType=:CodeType)
	.i count>0 d RtnObj.Err(-2,"","系统未进行数据清理，不允许初始化！")
	.q:RtnObj.success'=0
	.
	.s HospStr=##class(web.CSSDHUI.HospMap).GetDefHospStr("CSSD_BaseCode")
	q:RtnObj.success'=0 RtnObj
	
	k BasicData
	s BasicData($i(BasicData))=$lb("01","高温灭菌","高温灭菌","Y")
	s BasicData($i(BasicData))=$lb("02","低温灭菌","低温灭菌","Y")
	s BasicData($i(BasicData))=$lb("03","环氧乙烷","环氧乙烷灭菌","Y")
	s BasicData($i(BasicData))=$lb("04","过氧化氢","过氧化氢低温等离子灭菌","Y")
	s BasicData($i(BasicData))=$lb("05","消毒","高水平消毒","Y")
	
	s Len=$l(HospStr,"^")
	s i=0
	f  s i=$o(BasicData(i)) q:(i="")||(RtnObj.success'=0)  d
	.s Data=BasicData(i)
	.s Code=$list(Data,1)
	.s Desc=$list(Data,2)
	.s SterWayName=$list(Data,3)
	.s UseFlag=$list(Data,4)
	.i HospStr="" d
	..s SterTypeId=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Desc",SterWayName,"CSSD_SterType","")
	..s tmprowid=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Code",Code,"CSSD_BaseCode","","",CodeType)
	..q:tmprowid'=""
	..
	..s tmprowid=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Desc",Desc,"CSSD_BaseCode","","",CodeType)
	..q:tmprowid'=""
	..
	..&sql(insert into CSSD_BaseCode (CSSDDC_Code,CSSDDC_Name,CSSDDC_CodeType,CSSDDC_NotUseFlag,CSSDDC_SterWay) 
		values (:Code,:Desc,:CodeType,:UseFlag,:SterTypeId))
	..i SQLCODE'=0 d RtnObj.Err(-3,"","初始化数据失败")
	.e  d
	..f j=1:1:Len q:(RtnObj.success'=0)  d
	...s HospId=$p(HospStr,"^",j)
	...s SterTypeId=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Desc",SterWayName,"CSSD_SterType",HospId)
	...s tmprowid=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Code",Code,"CSSD_BaseCode",HospId,"",CodeType)
	...q:tmprowid'=""
	...
	...s tmprowid=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Desc",Desc,"CSSD_BaseCode",HospId,"",CodeType)
	...q:tmprowid'=""
	...
	...&sql(insert into CSSD_BaseCode (CSSDDC_Code,CSSDDC_Name,CSSDDC_CodeType,CSSDDC_NotUseFlag,CSSDDC_SterWay) 
		values (:Code,:Desc,:CodeType,:UseFlag,:SterTypeId))
	...i SQLCODE'=0 d RtnObj.Err(-4,"","初始化数据失败")
	...s RowId=%ROWID
	...s ret=##class(web.CSSDHUI.HospMap).SaveHOSP("CSSD_BaseCode",RowId,HospId)
	...i ret'=0 d RtnObj.Err(-5,"","关联院区失败")
	
	q RtnObj
}

/// InitFlag:"Y" 首次初始化
/// 初始化灭菌不合格原因
ClassMethod InitSteCheckReason(HospStr, InitFlag) As web.CSSDHUI.RtnObj
{
	n (HospStr,InitFlag)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	
	i InitFlag="Y" d
	.s count=0
	.&sql(SELECT count(1) into :count FROM CSSD_SteCheckReason)
	.i count>0 d RtnObj.Err(-2,"","系统未进行数据清理，不允许初始化！")
	.q:RtnObj.success'=0
	.
	.d ##class(web.CSSDHUI.Tools.CleanData).DeleteBDPMappingHosp("CSSD_SteCheckReason")
	.s HospStr=##class(web.CSSDHUI.HospMap).GetDefHospStr("CSSD_SteCheckReason")
	q:RtnObj.success'=0 RtnObj
	
	k BasicData
	s BasicData($i(BasicData))=$lb("01","包外标示脱落","Y")
	s BasicData($i(BasicData))=$lb("02","包装松散","Y")
	s BasicData($i(BasicData))=$lb("03","包外化学监测不合格","Y")
	s BasicData($i(BasicData))=$lb("04","包内化学监测不合格","Y")
	s BasicData($i(BasicData))=$lb("05","物理监测不合格","Y")
	s BasicData($i(BasicData))=$lb("06","灭菌日期错误","Y")
	s BasicData($i(BasicData))=$lb("07","包装密封性不合格","Y")
	s BasicData($i(BasicData))=$lb("08","生物监测不合格","Y")
	s BasicData($i(BasicData))=$lb("09","其它","Y")
	
	s Len=$l(HospStr,"^")
	s i=0
	f  s i=$o(BasicData(i)) q:(i="")||(RtnObj.success'=0)  d
	.s Data=BasicData(i)
	.s Code=$list(Data,1)
	.s Desc=$list(Data,2)
	.s UseFlag=$list(Data,3)
	.i HospStr="" d
	..s tmprowid=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Code",Code,"CSSD_SteCheckReason","")
	..q:tmprowid'=""
	..
	..s tmprowid=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Desc",Desc,"CSSD_SteCheckReason","")
	..q:tmprowid'=""
	..
	..&sql(insert into CSSD_SteCheckReason (CSSD_SteFailCode,CSSD_SteFailDesc,CSSDS_NotUseFlag) 
		values (:Code,:Desc,:UseFlag))
	..i SQLCODE'=0 d RtnObj.Err(-3,"","初始化数据失败")
	.e  d
	..f j=1:1:Len q:(RtnObj.success'=0)  d
	...s HospId=$p(HospStr,"^",j)
	...s tmprowid=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Code",Code,"CSSD_SteCheckReason",HospId)
	...q:tmprowid'=""
	...
	...s tmprowid=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Desc",Desc,"CSSD_SteCheckReason",HospId)
	...q:tmprowid'=""
	...
	...&sql(insert into CSSD_SteCheckReason (CSSD_SteFailCode,CSSD_SteFailDesc,CSSDS_NotUseFlag) 
		values (:Code,:Desc,:UseFlag))
	...i SQLCODE'=0 d RtnObj.Err(-4,"","初始化数据失败")
	...s RowId=%ROWID
	...s ret=##class(web.CSSDHUI.HospMap).SaveHOSP("CSSD_SteCheckReason",RowId,HospId)
	...i ret'=0 d RtnObj.Err(-5,"","关联院区失败")
	
	q RtnObj
}

/// InitFlag:"Y" 首次初始化
/// 初始化清洗不合格原因
ClassMethod InitCleanItmReason(HospStr, InitFlag) As web.CSSDHUI.RtnObj
{
	n (HospStr,InitFlag)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	
	i InitFlag="Y" d
	.s count=0
	.&sql(SELECT count(1) into :count FROM CSSD_CleanItmReason)
	.i count>0 d RtnObj.Err(-2,"","系统未进行数据清理，不允许初始化！")
	.q:RtnObj.success'=0
	.
	.d ##class(web.CSSDHUI.Tools.CleanData).DeleteBDPMappingHosp("CSSD_CleanItmReason")
	.s HospStr=##class(web.CSSDHUI.HospMap).GetDefHospStr("CSSD_CleanItmReason")
	q:RtnObj.success'=0 RtnObj
	
	k BasicData
	s BasicData($i(BasicData))=$lb("01","锈斑","Y")
	s BasicData($i(BasicData))=$lb("02","血迹","Y")
	s BasicData($i(BasicData))=$lb("03","白斑","Y")
	s BasicData($i(BasicData))=$lb("04","水垢","Y")
	s BasicData($i(BasicData))=$lb("05","其它","Y")
	
	s Len=$l(HospStr,"^")
	s i=0
	f  s i=$o(BasicData(i)) q:(i="")||(RtnObj.success'=0)  d
	.s Data=BasicData(i)
	.s Code=$list(Data,1)
	.s Desc=$list(Data,2)
	.s UseFlag=$list(Data,3)
	.i HospStr="" d
	..s tmprowid=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Code",Code,"CSSD_CleanItmReason","")
	..q:tmprowid'=""
	..
	..s tmprowid=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Desc",Desc,"CSSD_CleanItmReason","")
	..q:tmprowid'=""
	..
	..&sql(insert into CSSD_CleanItmReason (CSSD_RejectCode,CSSD_RejectDesc,CSSDC_NotUseFlag) 
		values (:Code,:Desc,:UseFlag))
	..i SQLCODE'=0 d RtnObj.Err(-3,"","初始化数据失败")
	.e  d
	..f j=1:1:Len q:(RtnObj.success'=0)  d
	...s HospId=$p(HospStr,"^",j)
	...s tmprowid=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Code",Code,"CSSD_CleanItmReason",HospId)
	...q:tmprowid'=""
	...
	...s tmprowid=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Desc",Desc,"CSSD_CleanItmReason",HospId)
	...q:tmprowid'=""
	...
	...&sql(insert into CSSD_CleanItmReason (CSSD_RejectCode,CSSD_RejectDesc,CSSDC_NotUseFlag) 
		values (:Code,:Desc,:UseFlag))
	...i SQLCODE'=0 d RtnObj.Err(-4,"","初始化数据失败")
	...s RowId=%ROWID
	...s ret=##class(web.CSSDHUI.HospMap).SaveHOSP("CSSD_CleanItmReason",RowId,HospId)
	...i ret'=0 d RtnObj.Err(-5,"","关联院区失败")
	
	q RtnObj
}

/// InitFlag:"Y" 首次初始化
/// 初始化报损原因
ClassMethod InitMachineConsumeReason(HospStr, InitFlag) As web.CSSDHUI.RtnObj
{
	n (HospStr,InitFlag)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	
	i InitFlag="Y" d
	.s count=0
	.&sql(SELECT count(1) into :count FROM CSSD_MachineConsumeReason)
	.i count>0 d RtnObj.Err(-2,"","系统未进行数据清理，不允许初始化！")
	.q:RtnObj.success'=0
	.
	.d ##class(web.CSSDHUI.Tools.CleanData).DeleteBDPMappingHosp("CSSD_MachineConsumeReason")
	.s HospStr=##class(web.CSSDHUI.HospMap).GetDefHospStr("CSSD_MachineConsumeReason")
	q:RtnObj.success'=0 RtnObj
	
	k BasicData
	s BasicData($i(BasicData))=$lb("01","回收后缺失","Y")
	s BasicData($i(BasicData))=$lb("02","正常使用消耗","Y")
	s BasicData($i(BasicData))=$lb("03","清洗报损","Y")
	s BasicData($i(BasicData))=$lb("04","灭菌报损","Y")
	s BasicData($i(BasicData))=$lb("05","其它","Y")
	
	s Len=$l(HospStr,"^")
	s i=0
	f  s i=$o(BasicData(i)) q:(i="")||(RtnObj.success'=0)  d
	.s Data=BasicData(i)
	.s Code=$list(Data,1)
	.s Desc=$list(Data,2)
	.s UseFlag=$list(Data,3)
	.i HospStr="" d
	..s tmprowid=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Code",Code,"CSSD_MachineConsumeReason","")
	..q:tmprowid'=""
	..
	..s tmprowid=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Desc",Desc,"CSSD_MachineConsumeReason","")
	..q:tmprowid'=""
	..
	..&sql(insert into CSSD_MachineConsumeReason (CSSD_MConsumeCode,CSSD_MConsumeDesc,CSSDC_NotUseFlag) 
		values (:Code,:Desc,:UseFlag))
	..i SQLCODE'=0 d RtnObj.Err(-3,"","初始化数据失败")
	.e  d
	..f j=1:1:Len q:(RtnObj.success'=0)  d
	...s HospId=$p(HospStr,"^",j)
	...s tmprowid=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Code",Code,"CSSD_MachineConsumeReason",HospId)
	...q:tmprowid'=""
	...
	...s tmprowid=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Desc",Desc,"CSSD_MachineConsumeReason",HospId)
	...q:tmprowid'=""
	...
	...&sql(insert into CSSD_MachineConsumeReason (CSSD_MConsumeCode,CSSD_MConsumeDesc,CSSDC_NotUseFlag) 
		values (:Code,:Desc,:UseFlag))
	...i SQLCODE'=0 d RtnObj.Err(-4,"","初始化数据失败")
	...s RowId=%ROWID
	...s ret=##class(web.CSSDHUI.HospMap).SaveHOSP("CSSD_MachineConsumeReason",RowId,HospId)
	...i ret'=0 d RtnObj.Err(-5,"","关联院区失败")
	
	q RtnObj
}

/// InitFlag:"Y" 首次初始化
/// 初始化召回原因
ClassMethod InitRecallReason(HospStr, InitFlag) As web.CSSDHUI.RtnObj
{
	n (HospStr,InitFlag)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	
	i InitFlag="Y" d
	.s count=0
	.&sql(SELECT count(1) into :count FROM CSSD_RecallReason)
	.i count>0 d RtnObj.Err(-2,"","系统未进行数据清理，不允许初始化！")
	.q:RtnObj.success'=0
	.
	.d ##class(web.CSSDHUI.Tools.CleanData).DeleteBDPMappingHosp("CSSD_RecallReason")
	.s HospStr=##class(web.CSSDHUI.HospMap).GetDefHospStr("CSSD_RecallReason")
	q:RtnObj.success'=0 RtnObj
	
	k BasicData
	s BasicData($i(BasicData))=$lb("01","批次生物监测不合格召回","Y")
	s BasicData($i(BasicData))=$lb("02","批次清洗不合格召回","Y")
	s BasicData($i(BasicData))=$lb("03","清洗设备不合格召回","Y")
	s BasicData($i(BasicData))=$lb("04","灭菌器生物检测不合格召回","Y")
	
	s Len=$l(HospStr,"^")
	s i=0
	f  s i=$o(BasicData(i)) q:(i="")||(RtnObj.success'=0)  d
	.s Data=BasicData(i)
	.s Code=$list(Data,1)
	.s Desc=$list(Data,2)
	.s UseFlag=$list(Data,3)
	.i HospStr="" d
	..s tmprowid=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Code",Code,"CSSD_RecallReason","")
	..q:tmprowid'=""
	..
	..s tmprowid=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Desc",Desc,"CSSD_RecallReason","")
	..q:tmprowid'=""
	..
	..&sql(insert into CSSD_RecallReason (CSSD_RecallCode,CSSD_RecallDesc,CSSD_RecallUseFlag) 
		values (:Code,:Desc,:UseFlag))
	..i SQLCODE'=0 d RtnObj.Err(-3,"","初始化数据失败")
	.e  d
	..f j=1:1:Len q:(RtnObj.success'=0)  d
	...s HospId=$p(HospStr,"^",j)
	...s tmprowid=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Code",Code,"CSSD_RecallReason",HospId)
	...q:tmprowid'=""
	...
	...s tmprowid=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Desc",Desc,"CSSD_RecallReason",HospId)
	...q:tmprowid'=""
	...
	...&sql(insert into CSSD_RecallReason (CSSD_RecallCode,CSSD_RecallDesc,CSSD_RecallUseFlag) 
		values (:Code,:Desc,:UseFlag))
	...i SQLCODE'=0 d RtnObj.Err(-4,"","初始化数据失败")
	...s RowId=%ROWID
	...s ret=##class(web.CSSDHUI.HospMap).SaveHOSP("CSSD_RecallReason",RowId,HospId)
	...i ret'=0 d RtnObj.Err(-5,"","关联院区失败")
	
	q RtnObj
}

/// InitFlag:"Y" 首次初始化
/// 初始化消毒包包装材料
ClassMethod InitMaterial(HospStr, InitFlag) As web.CSSDHUI.RtnObj
{
	n (HospStr,InitFlag)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	
	i InitFlag="Y" d
	.s count=0
	.&sql(SELECT count(1) into :count FROM CSSD_Material)
	.i count>0 d RtnObj.Err(-2,"","系统未进行数据清理，不允许初始化！")
	.q:RtnObj.success'=0
	.
	.d ##class(web.CSSDHUI.Tools.CleanData).DeleteBDPMappingHosp("CSSD_Material")
	.s HospStr=##class(web.CSSDHUI.HospMap).GetDefHospStr("CSSD_Material")
	q:RtnObj.success'=0 RtnObj
	
	k BasicData
	s BasicData($i(BasicData))=$lb("01","棉布材料","Y",7)
	s BasicData($i(BasicData))=$lb("06","医用纸袋","Y",30)
	s BasicData($i(BasicData))=$lb("03","医用无纺布","Y",180)
	s BasicData($i(BasicData))=$lb("04","医用皱纹纸","Y",180)
	s BasicData($i(BasicData))=$lb("02","纸塑袋","Y",180)
	s BasicData($i(BasicData))=$lb("05","硬质容器","Y",180)
	
	s Len=$l(HospStr,"^")
	s i=0
	f  s i=$o(BasicData(i)) q:(i="")||(RtnObj.success'=0)  d
	.s Data=BasicData(i)
	.s Code=$list(Data,1)
	.s Desc=$list(Data,2)
	.s UseFlag=$list(Data,3)
	.s Length=$list(Data,4)
	.i HospStr="" d
	..s tmprowid=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Code",Code,"CSSD_Material","")
	..q:tmprowid'=""
	..
	..s tmprowid=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Desc",Desc,"CSSD_Material","")
	..q:tmprowid'=""
	..
	..&sql(insert into CSSD_Material (CSSDM_Code,CSSDM_Desc,CSSDM_IsUsed,CSSDM_ExpLength) 
		values (:Code,:Desc,:UseFlag,:Length))
	..i SQLCODE'=0 d RtnObj.Err(-3,"","初始化数据失败")
	.e  d
	..f j=1:1:Len q:(RtnObj.success'=0)  d
	...s HospId=$p(HospStr,"^",j)
	...s tmprowid=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Code",Code,"CSSD_Material",HospId)
	...q:tmprowid'=""
	...
	...s tmprowid=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Desc",Desc,"CSSD_Material",HospId)
	...q:tmprowid'=""
	...
	...&sql(insert into CSSD_Material (CSSDM_Code,CSSDM_Desc,CSSDM_IsUsed,CSSDM_ExpLength) 
		values (:Code,:Desc,:UseFlag,:Length))
	...i SQLCODE'=0 d RtnObj.Err(-4,"","初始化数据失败")
	...s RowId=%ROWID
	...s ret=##class(web.CSSDHUI.HospMap).SaveHOSP("CSSD_Material",RowId,HospId)
	...i ret'=0 d RtnObj.Err(-5,"","关联院区失败")
	
	q RtnObj
}

/// InitFlag:"Y" 首次初始化
/// 初始化消毒包规格
ClassMethod InitPackageSpec(HospStr, InitFlag) As web.CSSDHUI.RtnObj
{
	n (HospStr,InitFlag)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	
	i InitFlag="Y" d
	.s count=0
	.&sql(SELECT count(1) into :count FROM CT_STER_CSSD.PackageSpec)
	.i count>0 d RtnObj.Err(-2,"","系统未进行数据清理，不允许初始化！")
	.q:RtnObj.success'=0
	.
	.d ##class(web.CSSDHUI.Tools.CleanData).DeleteBDPMappingHosp("CT_STER_CSSD.PackageSpec")
	.s HospStr=##class(web.CSSDHUI.HospMap).GetDefHospStr("CT_STER_CSSD.PackageSpec")
	q:RtnObj.success'=0 RtnObj
	
	k BasicData
	s BasicData($i(BasicData))=$lb("01","大","Y")
	s BasicData($i(BasicData))=$lb("02","中","Y")
	s BasicData($i(BasicData))=$lb("03","小","Y")
	s BasicData($i(BasicData))=$lb("04","精贵","Y")
	s BasicData($i(BasicData))=$lb("05","精","Y")
	s BasicData($i(BasicData))=$lb("06","贵","Y")
	
	s Len=$l(HospStr,"^")
	s i=0
	f  s i=$o(BasicData(i)) q:(i="")||(RtnObj.success'=0)  d
	.s Data=BasicData(i)
	.s Code=$list(Data,1)
	.s Desc=$list(Data,2)
	.s UseFlag=$list(Data,3)
	.i HospStr="" d
	..s tmprowid=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Code",Code,"CT_STER_CSSD.PackageSpec","")
	..q:tmprowid'=""
	..
	..s tmprowid=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Desc",Desc,"CT_STER_CSSD.PackageSpec","")
	..q:tmprowid'=""
	..
	..&sql(insert into CT_STER_CSSD.PackageSpec(PS_SpecCode,PS_SpecDesc,PS_SpecUseFlag) 
		values (:Code,:Desc,:UseFlag))
	..i SQLCODE'=0 d RtnObj.Err(-3,"","初始化数据失败")
	.e  d
	..f j=1:1:Len q:(RtnObj.success'=0)  d
	...s HospId=$p(HospStr,"^",j)
	...s tmprowid=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Code",Code,"CT_STER_CSSD.PackageSpec",HospId)
	...q:tmprowid'=""
	...
	...s tmprowid=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Desc",Desc,"CT_STER_CSSD.PackageSpec",HospId)
	...q:tmprowid'=""
	...
	...&sql(insert into CT_STER_CSSD.PackageSpec(PS_SpecCode,PS_SpecDesc,PS_SpecUseFlag) 
		values (:Code,:Desc,:UseFlag))
	...i SQLCODE'=0 d RtnObj.Err(-4,"","初始化数据失败")
	...s RowId=%ROWID
	...s ret=##class(web.CSSDHUI.HospMap).SaveHOSP("CT_STER_CSSD.PackageSpec",RowId,HospId)
	...i ret'=0 d RtnObj.Err(-5,"","关联院区失败")
	
	q RtnObj
}

/// InitFlag:"Y" 首次初始化
/// 初始化清洗架、灭菌架
ClassMethod InitMachine(HospStr, InitFlag) As web.CSSDHUI.RtnObj
{
	n (HospStr,InitFlag)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	
	i InitFlag="Y" d
	.s count=0
	.&sql(SELECT count(1) into :count FROM CSSD_MachineConfig)
	.i count>0 d RtnObj.Err(-2,"","系统未进行数据清理，不允许初始化！")
	.q:RtnObj.success'=0
	.
	.d ##class(web.CSSDHUI.Tools.CleanData).DeleteBDPMappingHosp("CSSD_MachineConfig")
	.s HospStr=##class(web.CSSDHUI.HospMap).GetDefHospStr("CSSD_MachineConfig")
	q:RtnObj.success'=0 RtnObj
	
	k BasicData
	s BasicData($i(BasicData))=$lb("sterilizer","1","01","Y","Y","Y","1")
	s BasicData($i(BasicData))=$lb("sterilizer","2","02","Y","Y","Y","1")
	s BasicData($i(BasicData))=$lb("washer","1","01","N","Y","N","")
	s BasicData($i(BasicData))=$lb("washer","2","02","N","Y","N","")
	
	s Len=$l(HospStr,"^")
	s i=0
	f  s i=$o(BasicData(i)) q:(i="")||(RtnObj.success'=0)  d
	.s Data=BasicData(i)
	.s Type=$list(Data,1)
	.s Code=$list(Data,2)
	.s Desc=$list(Data,3)
	.s IsBd=$list(Data,4)
	.s IsUseFlag=$list(Data,5)
	.s IsLeak=$list(Data,6)
	.s LeakTime=$list(Data,7)
	.i HospStr="" d
	..s tmprowid=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("MachineNum",Code,"CSSD_MachineConfig","","",Type)
	..q:tmprowid'=""
	..
	..s tmprowid=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Alias",Desc,"CSSD_MachineConfig","","",Type)
	..q:tmprowid'=""
	..
	..&sql(insert into CSSD_MachineConfig (CSSDMC_Alias,CSSDMC_Num,CSSDMC_MachineType,CSSDMC_IsBD,CSSDMC_IsLeak,CSSDMC_LeakTime,CSSDMC_NotUseFlag) 
		values (:Desc,:Code,:Type,:IsBd,:IsLeak,:LeakTime,:IsUseFlag))
	..i SQLCODE'=0 d RtnObj.Err(-3,"","初始化数据失败")
	.e  d
	..f j=1:1:Len q:(RtnObj.success'=0)  d
	...s HospId=$p(HospStr,"^",j)
	...s tmprowid=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("MachineNum",Code,"CSSD_MachineConfig",HospId,"",Type)
	...q:tmprowid'=""
	...
	...s tmprowid=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Alias",Desc,"CSSD_MachineConfig",HospId,"",Type)
	...q:tmprowid'=""
	...
	...&sql(insert into CSSD_MachineConfig (CSSDMC_Alias,CSSDMC_Num,CSSDMC_MachineType,CSSDMC_IsBD,CSSDMC_IsLeak,CSSDMC_LeakTime,CSSDMC_NotUseFlag) 
		values (:Desc,:Code,:Type,:IsBd,:IsLeak,:LeakTime,:IsUseFlag))
	...i SQLCODE'=0 d RtnObj.Err(-4,"","初始化数据失败")
	...s RowId=%ROWID
	...s ret=##class(web.CSSDHUI.HospMap).SaveHOSP("CSSD_MachineConfig",RowId,HospId)
	...i ret'=0 d RtnObj.Err(-5,"","关联院区失败")
	
	q RtnObj
}

/// InitFlag:"Y" 首次初始化
/// 初始化满意度
ClassMethod InitSatisfaction(HospStr, InitFlag) As web.CSSDHUI.RtnObj
{
	n (HospStr,InitFlag)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	
	i InitFlag="Y" d
	.s count=0
	.&sql(SELECT count(1) into :count FROM CT_STER_CSSD.Satisfaction)
	.i count>0 d RtnObj.Err(-2,"","系统未进行数据清理，不允许初始化！")
	.q:RtnObj.success'=0
	.
	.d ##class(web.CSSDHUI.Tools.CleanData).DeleteBDPMappingHosp("CT_STER_CSSD.Satisfaction")
	.s HospStr=##class(web.CSSDHUI.HospMap).GetDefHospStr("CT_STER_CSSD.Satisfaction")
	q:RtnObj.success'=0 RtnObj
	
	k BasicData
	s BasicData($i(BasicData))=$lb("01","工作人员仪表规范、整洁、语言文明","Y","R")
	s BasicData($i(BasicData))=$lb("02","运送工具洁污分开","Y","R")
	s BasicData($i(BasicData))=$lb("03","物资按照病房计划每天下收下送","Y","R")
	s BasicData($i(BasicData))=$lb("04","物资需要按照病房制作","Y","R")
	s BasicData($i(BasicData))=$lb("05","消毒供应中心物品方便临床工作","Y","R")
	s BasicData($i(BasicData))=$lb("06","物品灭菌标识明显清楚、容易识别","Y","R")
	s BasicData($i(BasicData))=$lb("07","灭菌物品包装整洁、规范","Y","R")
	s BasicData($i(BasicData))=$lb("08","灭菌物品无过期、失效、质量达标","Y","R")
	s BasicData($i(BasicData))=$lb("09","突发事件，特殊抢救物品，配送及时","Y","R")
	s BasicData($i(BasicData))=$lb("10","对消毒供应中心服务总体印象","Y","R")
	s BasicData($i(BasicData))=$lb("11","最满意的供应中心工作人员","Y","I")
	s BasicData($i(BasicData))=$lb("12","最不满意的供应中心工作人员","Y","I")
	s BasicData($i(BasicData))=$lb("13","对消毒供应中心工作有什么建议和意见","Y","I")
	
	s Len=$l(HospStr,"^")
	s i=0
	f  s i=$o(BasicData(i)) q:(i="")||(RtnObj.success'=0)  d
	.s Data=BasicData(i)
	.s Code=$list(Data,1)
	.s Desc=$list(Data,2)
	.s UseFlag=$list(Data,3)
	.s SfType=$list(Data,4)
	.i HospStr="" d
	..s tmprowid=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Code",Code,"CT_STER_CSSD.Satisfaction","")
	..q:tmprowid'=""
	..
	..s tmprowid=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Desc",Desc,"CT_STER_CSSD.Satisfaction","")
	..q:tmprowid'=""
	..
	..&sql(Insert into CT_STER_CSSD.Satisfaction(S_Code,S_Desc,S_Type,S_UseFlag)
		values(:Code,:Desc,:SfType,:UseFlag))
	..i SQLCODE'=0 d RtnObj.Err(-3,"","初始化数据失败")
	.e  d
	..f j=1:1:Len q:(RtnObj.success'=0)  d
	...s HospId=$p(HospStr,"^",j)
	...s tmprowid=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Code",Code,"CT_STER_CSSD.Satisfaction",HospId)
	...q:tmprowid'=""
	...
	...s tmprowid=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Desc",Desc,"CT_STER_CSSD.Satisfaction",HospId)
	...q:tmprowid'=""
	...
	...&sql(Insert into CT_STER_CSSD.Satisfaction(S_Code,S_Desc,S_Type,S_UseFlag)
		values(:Code,:Desc,:SfType,:UseFlag))
	...i SQLCODE'=0 d RtnObj.Err(-4,"","初始化数据失败")
	...s RowId=%ROWID
	...s ret=##class(web.CSSDHUI.HospMap).SaveHOSP("CT_STER_CSSD.Satisfaction",RowId,HospId)
	...i ret'=0 d RtnObj.Err(-5,"","关联院区失败")
	
	q RtnObj
}

/// Descript:	后台命令初始化
/// w ##class(web.CSSDHUI.DataInit).clsInit("")
ClassMethod clsInit(TypeStr As %String = "") As %String
{
	n (TypeStr)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	ts
	s:TypeStr="" TypeStr="SysParame^GridSet^PrintRule"
	s len=$l(TypeStr,"^")
	f i=1:1:len q:RtnObj.success'=0  d
	.s Type=$p(TypeStr,"^",i)
	.s InitFlag="Y"
	.s Data=""_"^"_Type_"^"_InitFlag
	.s Title="BDPHospital^Type^InitFlag"
	.s Params=##class(web.CSSDHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	.s RtnObj=..Init(Params)
	.
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

}
