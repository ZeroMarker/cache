Import sqluser

Class web.CSSDHUI.HospMap Extends (%RegisteredObject, CSSDType) [ Not ProcedureBlock ]
{

/// Descript:	根据session来获取此角色的真实医院级别权限
/// Creator:	lihui
/// CreateDate:	20200327
/// Input: 	医院ID	
/// return: Y：有权限；N:无权限
/// (off:未启用医院级别授权;1:不受限制; {limited:1,IDS:[{ID:2},{ID:3}]} :其中2,3为所能看到哪些医院数据的 医院rowid)
/// w ##class(web.CSSDHUI.HospMap).GetHospAutFlag(2)
ClassMethod GetHospAutFlag(gHospId = "") As %String
{
	n (%session,gHospId)
	i '$d(^||TMPCSSDHUI("GetHospAutFlag",$j)) d
	.s ClassMethodStr="web.DHCBL.BDP.BDPConfig||GetConfigValue"
	.s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	.s BDPHospAutFlag="N"
	.i $IsObject(CompiledObj) d
	..s BDPHospAutFlag=##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPHospAut") //是否开启医院授权
	.s ^||TMPCSSDHUI("GetHospAutFlag",$j)=BDPHospAutFlag
	e  d
	.s BDPHospAutFlag=$p(^||TMPCSSDHUI("GetHospAutFlag",$j),"^",1)
	q BDPHospAutFlag
}

/// Descript:	获取BDP_MappingHosp内对应的数据ID
/// 			基础数据,多院区改造模式用到
/// Creator:	wangjiabin
/// CreateDate:	20200528
/// Input:		表名, 医院ID, 表内记录rowid
/// return:		BDP_MappingHosp记录rowid
ClassMethod GetBDPMapId(TableName, HospId, Reference) As %String
{
	n (TableName,HospId,Reference)
	q:(TableName="")||(HospId="")||(Reference="") ""
	s BDPMapId=$o(^User.BDPMappingHospI("DataRef",TableName,HospId,Reference,""),-1) 
	q BDPMapId
}

/// Descript:	获取重复id
/// Creator:	lihui
/// CreateDate:	20200327
/// Input: 	授权开启标志，表类型，表名称，医院id，重复id，原始id，计数	
/// return: 成功:ID^添加成功；失败:-1^添加失败
/// w ##class(web.CSSDHUI.HospMap).DeleteArcHOSP(ArcimId,医院ID)
ClassMethod GetRepeatId(BDPHospAutFlag, TableType, tableName, HospId, Rowid, OriRowId, count)
{
	n (BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,count)
	s repeatFlag="Y"
	q:(OriRowId'="")&&(OriRowId=Rowid) ""	;过滤修改
	s flag="Y"
	s count=count+1
	i ((BDPHospAutFlag="Y")&&(TableType'="G"))  d
	.s flag = ..GetShowDataFlag(tableName,Rowid,HospId,"",repeatFlag) //医院级别授权
	q:flag="N" ""
	q:(BDPHospAutFlag'="Y")&&(count>0) Rowid
	q Rowid
}

/// Descript:	根据代码 名称获取对应ID(注意自带院区字段的表)
/// Creator:	lihui
/// CreateDate:	202000416
/// Input: 	type(代码:CODE;名称:DESC),类型值,表名,医院ID	
/// return: 重复:id 不重复:空 报错:小于0
ClassMethod GetShowId(BDPHospAutFlag, TableType, tableName, HospId, Rowid)
{
	n (BDPHospAutFlag,TableType,tableName,HospId,Rowid)
	s repeatFlag="Y"
	s flag="N",BDPMapId=""
	
	i ((BDPHospAutFlag="Y")&&(TableType'="G"))  d
	.s flag = ..GetShowDataFlag(tableName,Rowid,HospId,"",repeatFlag) //医院级别授权
	q:flag="Y" Rowid
	
	i (BDPHospAutFlag'="Y") d
	.s BDPMapId=..GetBDPMapId(tableName,HospId,Rowid)
	q:BDPMapId'="" Rowid
	
	q ""
}

/// Descript:	根据代码 名称获取对应ID(注意自带院区字段的表)
/// Creator:	lihui
/// CreateDate:	202000416
/// Input: 	type(代码:CODE;名称:DESC),类型值,表名,医院ID	
/// return: 重复:id 不重复:空 报错:小于0
/// w ##class(web.CSSDHUI.HospMap).CodeDescGetId("CODE","001","CSSD_SterType",2)
/// w ##class(web.CSSDHUI.HospMap).CodeDescGetId("DESC","002","CSSD_SterType",2)
ClassMethod CodeDescGetId(type, value, tableName, HospId, other = "")
{
	n (type, value, tableName, HospId,other,%session)
	q:(type="")||(value="")||(tableName="")||(HospId="") ""
	
	s TableType=..GetTableType(tableName)  //表类型
	s RetRowID=""
	s tmpvalue=value
	s tmpStkType=$p(other,"^",1)
	s value=$$ALPHAUP^SSUTIL4(value)
	s repeatFlag="Y"
	i '$d(^||TMPCSSDHUI("CodeDescGetId",$j)) d
	.s ClassMethodStr="web.DHCBL.BDP.BDPConfig||GetConfigValue"
	.s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	.s BDPHospAutFlag="N"
	.i $IsObject(CompiledObj) d
	..s BDPHospAutFlag=##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPHospAut") //是否开启医院授权
	.s ^||TMPCSSDHUI("CodeDescGetId",$j)=BDPHospAutFlag
	e  d
	.s BDPHospAutFlag=$p(^||TMPCSSDHUI("CodeDescGetId",$j),"^",1)
	
	;灭菌方式
	i (type="CODE")&&(tableName="CSSD_SterType") d
	.s Rowid=0,count=0,tmpid=""
	.f  s Rowid=$o(^INC("SC",0,"Code",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s count=count+1,tmpid=Rowid
	..s RetRowID=..GetShowId(BDPHospAutFlag,TableType,tableName,HospId,Rowid)
	.q:RetRowID'=""
	.i (BDPHospAutFlag'="Y")&&(count=1) s RetRowID=tmpid
	
	i (type="DESC")&&(tableName="CSSD_SterType") d
	.s Rowid=0,count=0,tmpid=""
	.f  s Rowid=$o(^INC("SC",0,"Desc",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s count=count+1,tmpid=Rowid
	..s RetRowID=..GetShowId(BDPHospAutFlag,TableType,tableName,HospId,Rowid)
	.q:RetRowID'=""
	.i (BDPHospAutFlag'="Y")&&(count=1) s RetRowID=tmpid
	q $g(RetRowID)
}

/// Descript:	机器设置、消毒包、码表维护等 判断代码或者名称是否重复
/// Creator:	ban
/// CreateDate:	20200415
/// Input: 	type(代码:CODE;名称:DESC),类型值,表名,医院ID,原始数据的RowId：OriRowId,	tmpType(辅助参数),other(辅助参数)
/// return: 重复:id 不重复:空 报错:小于0
/// w ##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Type","DefStartDate","CSSD_Parameter",2,"",6)
ClassMethod CodeDescIfRepeat(type, value, tableName, HospId, OriRowId = "", tmpType = "", other = "")
{
	n (type, value, tableName, HospId, OriRowId,tmpType,other,%session)
	q:(type="")||(value="")||(tableName="") -1	//||(HospId="") 2021/1/28   医院为空，则判断所有医院数据
	
	s TableType=..GetTableType(tableName)  //表类型
	s RetRowID=""
	s tmpvalue=value
	s tmpOriRowId=OriRowId
	s tmpType=tmpType
	s tmpOther=other
	;s value=$$ALPHAUP^SSUTIL4(value)
	i '$d(^||TMPCSSDHUI("CodeDescIfRepeat",$j)) d
	.s ClassMethodStr="web.DHCBL.BDP.BDPConfig||GetConfigValue"
	.s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	.s BDPHospAutFlag="N"
	.i $IsObject(CompiledObj) d
	..s BDPHospAutFlag=##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPHospAut") //是否开启医院授权
	.s ^||TMPCSSDHUI("CodeDescIfRepeat",$j)=BDPHospAutFlag
	e  d
	.s BDPHospAutFlag=$p(^||TMPCSSDHUI("CodeDescIfRepeat",$j),"^",1)
	s repeatFlag="Y"
	
	;消毒包信息-消毒分类
	i (type="Code")&&(tableName="CSSD_PackageClass") d
	.s Rowid=0,count=0
	.f  s Rowid=$o(^User.CSSDPackageClassI("CSSDPCPackClassCodeIndex",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	i (type="Desc")&&(tableName="CSSD_PackageClass") d
	.s Rowid=0,count=0
	.f  s Rowid=$o(^User.CSSDPackageClassI("CSSDPCPackCalssNameIndex",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	
	;消毒包信息-消毒包维护
	i (type="Desc")&&(tableName="CSSD_Package") d
	.s Rowid=0,count=0
	.f  s Rowid=$o(^User.CSSDPackageI("CSSDPackageDescIndex",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	
	;消毒包信息-器械维护
	i (type="Desc")&&(tableName="CSSD_Item") d
	.s Rowid=0,count=0
	.i tmpType="" d
	..&sql(declare itemrepeat cursor for 
			select %ID from CSSD_Item
			where CSSDI_Desc=:value and CSSDI_Spec IS NULL and CSSDI_CreateLocDr=:tmpOther)
	..&sql(open itemrepeat)
	..f  &sql(fetch itemrepeat into :Rowid) q:(SQLCODE)||(RetRowID'="")  d
	...s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	..&sql(close itemrepeat)
	.e  d
	..f  s Rowid=$o(^User.CSSDItemI("CSSDIDescSPecCreateLocIndex",value,tmpType,tmpOther,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	...s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	
	;消毒包信息-标牌编码维护
	i (type="Desc")&&(tableName="CSSD_CodeDict") d
	.s Rowid=0,count=0
	.f  s Rowid=$o(^User.CSSDCodeDictI("CSSDCDPackNameIndex",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	
	;基础信息维护-字典维护-码表维护-清洗方式
	i (type="Code")&&(tableName="CSSD_CleanType") d
	.s Rowid=0,count=0
	.f  s Rowid=$o(^User.CSSDCleanTypeI("IndexCleanCode",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	i (type="Desc")&&(tableName="CSSD_CleanType") d
	.s Rowid=0,count=0
	.f  s Rowid=$o(^User.CSSDCleanTypeI("IndexCleanMode",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	
	;基础信息维护-字典维护-码表维护-灭菌方式
	i (type="Code")&&(tableName="CSSD_SterType") d
	.s Rowid=0,count=0
	.f  s Rowid=$o(^User.CSSDSterTypeI("CSSDSTSterCodeIndex",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	i (type="Desc")&&(tableName="CSSD_SterType") d
	.s Rowid=0,count=0
	.f  s Rowid=$o(^User.CSSDSterTypeI("CSSDSTSterNameIndex",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	
	;基础信息维护-字典维护-码表维护-清洗程序
	i (type="Code")&&(tableName="CSSD_BaseCode") d
	.s Rowid=0,count=0
	.f  s Rowid=$o(^User.CSSDBaseCodeI("IndexCSSDDCCodeType",value,tmpType,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	i (type="Desc")&&(tableName="CSSD_BaseCode") d
	.s Rowid=0,count=0
	.f  s Rowid=$o(^User.CSSDBaseCodeI("IndexCSSDDCNameType",value,tmpType,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	i (type="BegLabel")&&(tableName="CSSD_BaseCode") d
	.s Rowid=0,count=0
	.f  s Rowid=$o(^User.CSSDBaseCodeI("IndexCSSDDCBegLabelType",value,tmpType,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	
	;基础信息维护-字典维护-码表维护-灭菌程序
	i (type="Code")&&(tableName="CSSD_BaseCode") d
	.s Rowid=0,count=0
	.f  s Rowid=$o(^User.CSSDBaseCodeI("IndexCSSDDCCodeType",value,tmpType,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	i (type="Desc")&&(tableName="CSSD_BaseCode") d
	.s Rowid=0,count=0
	.f  s Rowid=$o(^User.CSSDBaseCodeI("IndexCSSDDCNameType",value,tmpType,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	i (type="BegLabel")&&(tableName="CSSD_BaseCode") d
	.s Rowid=0,count=0
	.f  s Rowid=$o(^User.CSSDBaseCodeI("IndexCSSDDCBegLabelType",value,tmpType,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	
	;基础信息维护-字典维护-码表维护-灭菌不合格原因
	i (type="Code")&&(tableName="CSSD_SteCheckReason") d
	.s Rowid=0,count=0
	.f  s Rowid=$o(^User.CSSDSteCheckReasonI("CSSDSteFailCodeIndex",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	i (type="Desc")&&(tableName="CSSD_SteCheckReason") d
	.s Rowid=0,count=0
	.f  s Rowid=$o(^User.CSSDSteCheckReasonI("CSSDSteFailDescIndex",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	
	;基础信息维护-字典维护-码表维护-清洗不合格原因
	i (type="Code")&&(tableName="CSSD_CleanItmReason") d
	.s Rowid=0,count=0
	.f  s Rowid=$o(^User.CSSDCleanItmReasonI("CSSDRejectCodeIndex",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	i (type="Desc")&&(tableName="CSSD_CleanItmReason") d
	.s Rowid=0,count=0
	.f  s Rowid=$o(^User.CSSDCleanItmReasonI("CSSDRejectDescIndex",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	
	;基础信息维护-字典维护-码表维护-包装材料字典
	i (type="Code")&&(tableName="CSSD_Material") d
	.s Rowid=0,count=0
	.f  s Rowid=$o(^User.CSSDMaterialI("CSSDMCodeIndex",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	i (type="Desc")&&(tableName="CSSD_Material") d
	.s Rowid=0,count=0
	.f  s Rowid=$o(^User.CSSDMaterialI("CSSDMDescIndex",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	
	;基础信息维护-字典维护-码表维护-消毒包规格
	i (type="Code")&&(tableName="CT_STER_CSSD.PackageSpec") d
	.s Rowid=0,count=0
	.f  s Rowid=$o(^CT.STER.CSSD.PackageSpecI("SpecCodeIndex",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	i (type="Desc")&&(tableName="CT_STER_CSSD.PackageSpec") d
	.s Rowid=0,count=0
	.f  s Rowid=$o(^CT.STER.CSSD.PackageSpecI("SpecDescIndex",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	
	;基础信息维护-字典维护-码表维护-满意度调查项目
	i (type="Code")&&(tableName="CT_STER_CSSD.Satisfaction") d
	.s Rowid=0,count=0
	.f  s Rowid=$o(^CT.STER.CSSD.SatisfactionI("CSSDSCodeIndex",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	i (type="Desc")&&(tableName="CT_STER_CSSD.Satisfaction") d
	.s Rowid=0,count=0
	.f  s Rowid=$o(^CT.STER.CSSD.SatisfactionI("CSSDSDescIndex",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	
	;基础信息维护-字典维护-码表维护-器械缺失原因维护
	i (type="Code")&&(tableName="CSSD_MachineConsumeReason") d
	.s Rowid=0,count=0
	.f  s Rowid=$o(^User.CSSDMachineConsumeReasonI("CSSDMConsumeCodeIndex",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	i (type="Desc")&&(tableName="CSSD_MachineConsumeReason") d
	.s Rowid=0,count=0
	.f  s Rowid=$o(^User.CSSDMachineConsumeReasonI("CSSDMConsumeDescIndex",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	
	;基础信息维护-字典维护-码表维护-召回原因维护
	i (type="Code")&&(tableName="CSSD_RecallReason") d
	.s Rowid=0,count=0
	.f  s Rowid=$o(^User.CSSDRecallReasonI("CSSDRecallCodeIndex",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	i (type="Desc")&&(tableName="CSSD_RecallReason") d
	.s Rowid=0,count=0
	.f  s Rowid=$o(^User.CSSDRecallReasonI("CSSDRecallDescIndex",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	
	;基础信息维护-字典维护-机器设置
	i (type="Key")&&(tableName="CSSD_MachineConfig") d
	.s Rowid=0,count=0
	.f  s Rowid=$o(^User.CSSDMachineConfigI("IndexCSSDMCKeyType",value,tmpType,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	i (type="Alias")&&(tableName="CSSD_MachineConfig") d
	.s Rowid=0,count=0
	.f  s Rowid=$o(^User.CSSDMachineConfigI("IndexCSSDMCAliasType",value,tmpType,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	i (type="MachineNum")&&(tableName="CSSD_MachineConfig") d
	.s Rowid=0,count=0
	.f  s Rowid=$o(^User.CSSDMachineConfigI("IndexCSSDMCNumType",value,tmpType,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	
	;基础信息维护-字典维护-消毒包包装材料绑定
	i (type="Parref")&&(tableName="CSSD_Expire") d
	.s Rowid=0,count=0
	.f  s Rowid= $O(^User.CSSDExpireI("IndexCSSDEXPkgMatLen",value,tmpType,other,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	
	;基础信息维护-字典维护-外来器械厂商维护
	i (type="Code")&&(tableName="CSSD_Ven") d
	.s Rowid=0,count=0
	.f  s Rowid=$o(^User.CSSDVenI("IndexCSSDVenCode",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	i (type="Desc")&&(tableName="CSSD_Ven") d
	.s Rowid=0,count=0
	.f  s Rowid=$o(^User.CSSDVenI("IndexCSSDVenName",value,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	i (type="CodeName")&&(tableName="CSSD_Ven") d
	.s Rowid=0,count=0
	.f  s Rowid=$o(^User.CSSDVenI("IndexCSSDVenNameCode",value,tmpType,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	
	;基础信息维护-字典维护-科室绑定维护
	i (type="Key")&&(tableName="CSSD_BindLoc") d
	.s Rowid=0,count=0
	.f  s Rowid=$o(^User.CSSDBindLocI("CSSDBLTypeLocDrIndex",value,tmpType,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	
	;基础信息维护-系统管理-参数设置
	i (type="Code")&&(tableName="CSSD_Parameter") d
	.s Rowid="",count=0
	.f  s Rowid=$o(^User.CSSDParameterI("IndexCSSDPParaCodeType",tmpvalue,tmpType,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	i (type="DESC")&&(tableName="CSSD_Parameter") d
	.s Rowid="",count=0
	.f  s Rowid=$o(^User.CSSDParameterI("IndexCSSDPParaDescType",tmpvalue,tmpType,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	i (type="Type")&&(tableName="CSSD_Parameter") d
	.s Rowid="",count=0
	.f  s Rowid=$o(^User.CSSDParameterI("IndexCSSDPParaCodeType",tmpvalue,tmpType,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	..s RetRowID=..GetRepeatId(BDPHospAutFlag,TableType,tableName,HospId,Rowid,OriRowId,.count)
	q $g(RetRowID)
}

/// Descript:	保存医院关联
/// Creator:	lihui
/// CreateDate:	20200327
/// Table: BDP_MappingHosp
/// Input: 	表名,rowid,医院ID	
/// return: 成功:ID^添加成功；失败:-1^添加失败; 已经存在：1
/// w ##class(web.CSSDHUI.HospMap).SaveHOSP("DHCST_BookCat",1,2)
ClassMethod SaveHOSP(BDPMPHTableName, BDPMPHDataReference, BDPMPHHospital) As %String
{
	n (BDPMPHTableName,BDPMPHDataReference, BDPMPHHospital,%session)
	i '$d(^||TMPCSSDHUI("SaveHOSP",$j)) d
	.s ClassMethodStr="web.DHCBL.BDP.BDPConfig||GetConfigValue"
	.s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	.s BDPHospAutFlag="N"
	.i $IsObject(CompiledObj) d
	..s BDPHospAutFlag=##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPHospAut") //是否开启医院授权
	.s ^||TMPCSSDHUI("SaveHOSP",$j)=BDPHospAutFlag
	e  d
	.s BDPHospAutFlag=$p(^||TMPCSSDHUI("SaveHOSP",$j),"^",1)
	q:BDPHospAutFlag'="Y" 0
	
	s TableType=..GetTableType(BDPMPHTableName)
	q:TableType="G" 0
	
	i '$d(^||TMPCSSDHUI("SaveHOSP",$j)) d
	.s ClassMethodStr="web.DHCBL.BDP.BDPMappingHOSP||SaveHOSP"
	.s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	.s Flag=$s($IsObject(CompiledObj):"Y",1:"N")
	.s ^||TMPCSSDHUI("SaveHOSP",$j)=Flag
	e  d
	.s Flag=$p(^||TMPCSSDHUI("SaveHOSP",$j),"^",1)
	q:Flag'="Y" 0
	s ret=0
	s ReturnStr=##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP(BDPMPHTableName,BDPMPHDataReference,BDPMPHHospital)
	i +ReturnStr'>0 s ret=-1
	q ret
}

/// Descript:	删除医院关联
/// Creator:	lihui
/// CreateDate:	20200327
/// Input: 		
/// return: 成功:1；失败:-1^关联医院表数据删除失败
/// w ##class(web.CSSDHUI.HospMap).DeleteHospitals(表名,rowid)
ClassMethod DeleteHospitals(BDPMPHTableName, BDPMPHDataReference = "", hospid = "") As %String
{
	n (BDPMPHTableName, BDPMPHDataReference,hospid,%session)
	
	s TableType=..GetTableType(BDPMPHTableName)
	q:TableType="G" 0
	
	i '$d(^||TMPCSSDHUI("DeleteHospitals",$j)) d
	.s ClassMethodStr="web.DHCBL.BDP.BDPMappingHOSP||DeleteHospitals"
	.s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	.s Flag=$s($IsObject(CompiledObj):"Y",1:"N")
	.s ^||TMPCSSDHUI("DeleteHospitals",$j)=Flag
	e  d
	.s Flag=$p(^||TMPCSSDHUI("DeleteHospitals",$j),"^",1)
	q:Flag'="Y" 1
	
	s ReturnStr=0
	i hospid'="" d
	.s ReturnStr=##class(web.DHCBL.BDP.BDPMappingHOSP).DeleteHospital(BDPMPHTableName,BDPMPHDataReference,hospid)
	e  i (BDPMPHDataReference'="") d
	.s ReturnStr=##class(web.DHCBL.BDP.BDPMappingHOSP).DeleteHospitals(BDPMPHTableName,BDPMPHDataReference)
	e  d
	.s ReturnStr=##class(web.DHCBL.BDP.BDPMappingHOSP).DeleteTableHospitals(BDPMPHTableName)
	i ReturnStr=1 s ReturnStr=0
	q ReturnStr
}

/// Descript:	当前登录人是否有权限查看(基础平台配置,是否公有,是否授权院区)
/// Creator:	lihui
/// CreateDate:	20200327
/// talbe : DHC_ItmAddHosp，BDP_MappingHosp,ARC_ItemHosp(针对存储在这三张表的数据判断)
/// Input: 	表名,rowid,医院ID,是否忽略医院授权管理启用与否	(Y:忽略,N|"":不忽略),是否判断基础信息重名 (Y:是；否则：否)
/// return: Y:有权限；N:无权限
/// w ##class(web.CSSDHUI.HospMap).GetShowDataFlag("INC_Itm",4856,9)
ClassMethod GetShowDataFlag(tableName, dataid, HospId, Flag = "", repeatFlag = "", ShowAllFlag = "") As %String
{
	n (%session,tableName, dataid, HospId, Flag, repeatFlag, ShowAllFlag)
	q:(ShowAllFlag="Y")||(HospId="") "Y"	//取所有医院范围 //院区为空默认取全部
	q:(tableName="")||(dataid="") "N"
	
	i '$d(^||TMPCSSDHUI("GetShowDataFlag",$j)) d
	.s ClassMethodStr="web.DHCBL.BDP.BDPMappingHOSP||GetHospShowDataFlag"
	.s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	.s IsObject=$s($IsObject(CompiledObj):"Y",1:"N")
	.s BDPHospAutFlag="N"
	.i IsObject="Y" d
	..s BDPHospAutFlag=##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPHospAut") //是否开启医院授权
	.s ^||TMPCSSDHUI("GetShowDataFlag",$j)=BDPHospAutFlag_"^"_IsObject
	e  d
	.s BDPConfigInfo=^||TMPCSSDHUI("GetShowDataFlag",$j)
	.s BDPHospAutFlag=$p(BDPConfigInfo,"^",1)
	.s IsObject=$p(BDPConfigInfo,"^",2)
	
	q:((Flag'="Y")&&(BDPHospAutFlag'="Y")) "Y"
	q:IsObject="N" "Y"
	s retValue=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(tableName,dataid,HospId)
	q retValue
}

/// Descript:	获取表的类型（公有G ，私有S，管控C，绝对私有A）
/// Creator:	lxt
/// CreateDate:	20200514
/// Table: 
/// Input: 	表名,rowid	
/// return: 表类型
/// w ##class(web.CSSDHUI.HospMap).GetTableType("DHCST_BookCat")
ClassMethod GetTableType(BDPMPHTableName) As %String
{
	n (BDPMPHTableName,%session)
	i '$d(^||TMPCSSDHUI("GetTableType",$j)) d
	.s ClassMethodStr="web.DHCBL.BDP.BDPMappingHOSP||GetDataType"
	.s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	.s Flag=$s($IsObject(CompiledObj):"Y",1:"N")
	.s ^||TMPCSSDHUI("GetTableType",$j)=Flag
	e  d
	.s Flag=$p(^||TMPCSSDHUI("GetTableType",$j),"^",1)
	q:Flag'="Y" "G"
	
	s DataTypeFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDataType(BDPMPHTableName)	 //获取数据共有私有类型
	q DataTypeFlag
}

/// Descript:	获取院区Id(多院区)
/// Creator:	lxt
/// CreateDate:	20200514
/// Table: 
/// Input: 	多院区下拉框Id，登录院区Id，院区下拉框为空时是否赋值登录医院id	
/// return: 表类型
/// w ##class(web.CSSDHUI.HospMap).GetBDPHospId("","","","")
ClassMethod GetBDPHospId(BDPHospId, gHospId, SetDefFlag = "Y", TableName = "") As %String
{
	n (BDPHospId,gHospId,SetDefFlag,TableName,%session)
	
	s HospId=BDPHospId	//取医院下拉框取值
	q:(HospId="")&&(SetDefFlag="N") ""	//不取默认值
	s:HospId="" HospId=gHospId
	s:(HospId="")&&($g(%session)) HospId=$g(%session.Data("LOGON.HOSPID"))
	i (HospId'="")&&(TableName'="") d	//依据表名和当前医院获取对应展示医院的ID
	.s HospId=..GetDefHospId(TableName,HospId)
	q HospId
}

/// Descript:	根据表名、业务数据中的医院、日期取要取哪个医院的配置，返回医院id
/// Creator:	lxt
/// CreateDate:	20200514
/// Table: 
/// Input: 	表名,rowid	
/// return: 表类型
/// w ##class(web.CSSDHUI.HospMap).GetTableType("DHCST_BookCat")
ClassMethod GetDefHospId(TableName, HospId) As %String
{
	n (TableName,HospId,%session)
	
	i '$d(^||TMPCSSDHUI("GetDefHospId",$j)) d
	.s ClassMethodStr="web.DHCBL.BDP.BDPMappingHOSP||GetDefHospIdByTableName"
	.s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	.s Flag=$s($IsObject(CompiledObj):"Y",1:"N")
	.s ^||TMPCSSDHUI("GetDefHospId",$j)=Flag
	e  d
	.s Flag=$p(^||TMPCSSDHUI("GetDefHospId",$j),"^",1)
	q:Flag'="Y" HospId
	
	s Date=$zd(+$h,3)
	s HospId=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName(TableName,HospId,Date)
	q HospId
}

/// Descript:	根据表名、日期取要取哪个医院的配置，返回医院id
/// Creator:	lxt
/// CreateDate:	20200514
/// Table: 
/// Input: 	表名,rowid	
/// return: 表类型
/// w ##class(web.CSSDHUI.HospMap).GetDefHospStr("CSSD_Parameter")
ClassMethod GetDefHospStr(TableName) As %String
{
	n (TableName,%session)
	s HospStr=""
	
	s BDPHospAutFlag=..GetHospAutFlag() //是否开启医院授权
	q:BDPHospAutFlag'="Y" HospStr
	
	s TableType=..GetTableType(TableName)
	q:TableType="G" HospStr
	
	i '$d(^||TMPCSSDHUI("GetDefHospId",$j)) d
	.s ClassMethodStr="web.DHCBL.BDP.BDPMappingHOSP||GetDefHospIdByTableName"
	.s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	.s Flag=$s($IsObject(CompiledObj):"Y",1:"N")
	.s ^||TMPCSSDHUI("GetDefHospId",$j)=Flag
	e  d
	.s Flag=$p(^||TMPCSSDHUI("GetDefHospId",$j),"^",1)
	q:Flag'="Y" HospStr
	
	s HospId=0
	f  s HospId=$o(^CT("HOSP",HospId)) q:+HospId=0  d
	.s tmpHospId=..GetDefHospId(TableName,HospId)
	.i HospStr="" d
	..s HospStr=tmpHospId
	.e  d
	..q:(HospStr[tmpHospId)
	..s HospStr=HospStr_"^"_tmpHospId
	q HospStr
}

/// Descript:	根据表名获取医院id和Description
/// Creater:	ljl
/// CreateDate:	2022-11-29
/// Input: 	表名,rowid	
/// return: 医院id 名称
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.HospMap","GetDefHosp","CSSD_Package")
Query GetDefHosp(TableName As %String) As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,Description") [ SqlProc ]
{
}

ClassMethod GetDefHospExecute(ByRef qHandle As %Binary, TableName As %String) As %Status
{
	n (qHandle,TableName)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:TableName="" $$$OK

	s HospStr=..GetDefHospStr(TableName)
	s HospStr=$replace(HospStr,"^",",")
	s Result=##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	s SqlStr = "select HOSP_RowId as RowId, HOSP_Desc as Description,"
		_"HOSP_DateTo, HOSP_DateFrom from CT_Hospital where HOSP_RowId in ("_HospStr_")"
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		s Description = Result.Data("Description")
		s dateFrom = Result.Data("HOSP_DateFrom")
		s dateTo = Result.Data("HOSP_DateTo")
		s date =+$h
		continue:(dateFrom'="")&&(date<dateFrom)
		continue:(dateTo'="")&&(date>dateTo)
		d OutPutHospRow
	}
	d Result.Close()
	Quit $$$OK
OutPutHospRow
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	根据表名、医院获取医院组内医院id串（非例外医院）
/// Creator:	lxt
/// CreateDate:	20220316
/// Table: 
/// Input: 	表名,rowid	
/// return: 表类型
/// w ##class(web.CSSDHUI.HospMap).GetGroupHospStr("CT_Loc",2)
ClassMethod GetGroupHospStr(TableName, HospId) As %String
{
	n (TableName,HospId,%session)
	s HospStr=""
	q:(TableName="")||(HospId="") HospStr
	
	s BDPHospAutFlag=..GetHospAutFlag() //是否开启医院授权
	q:BDPHospAutFlag'="Y" HospStr
	
	i '$d(^||TMPCSSDHUI("GetDefHospId",$j)) d
	.s ClassMethodStr="web.DHCBL.BDP.BDPMappingHOSP||GetGroupHospIdsByTableName"
	.s CompiledObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	.s Flag=$s($IsObject(CompiledObj):"Y",1:"N")
	.s ^||TMPCSSDHUI("GetDefHospId",$j)=Flag
	e  d
	.s Flag=$p(^||TMPCSSDHUI("GetDefHospId",$j),"^",1)
	q:Flag'="Y" HospStr
	
	s HospStr=##class(web.DHCBL.BDP.BDPMappingHOSP).GetGroupHospIdsByTableName(TableName,HospId)
	q HospStr
}

/// Descript:	获取所有院区的id串
/// Creator:	lxt
/// CreateDate:	20220316
/// Table: 
/// Input: 	表名,rowid	
/// return: 表类型
/// w ##class(web.CSSDHUI.HospMap).GetGroupHospStr("CT_Loc",2)
ClassMethod GetAllHospStr() As %String
{
	s HospStr=""
	
	s HospId=0
	f  s HospId=$o(^CT("HOSP",HospId)) q:HospId=""  d
	.i HospStr="" s HospStr=HospId
	.e  s HospStr=HospStr_","_HospId
	
	q HospStr
}

}
