/// Description:多院区设置公共方法
/// Creator:	CZF0138
/// CreateDate:	20210419
Class web.DHCEQ.Util.BDPCommonUtil Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// 获取登录医院id
/// debug:    w ##class(web.DHCEQ.Util.BDPCommonUtil).GetCurrentSYSHospitalId()
ClassMethod GetCurrentSYSHospitalId(HospitalId As %String = "") As %String
{
	n (HospitalId,%session)
	i (HospitalId="")&&($d(%session)) s HospitalId=%session.Get("LOGON.HOSPID")
	Q HospitalId
}

/// Creator:	czf
/// CreateDate:	2021-04-19
/// Descript:	获取平台配置是否开启医院级别授权
/// Input: 		gHospId:医院ID	
/// Output: 	Y：有权限；N:无权限
/// Command:	w ##class(web.DHCEQ.Util.BDPCommonUtil).GetHospAutFlag(2)
ClassMethod GetHospAutFlag(gHospId = "") As %String
{
	n (gHospId)
	s ClassMethodStr="web.DHCBL.BDP.BDPConfig||GetConfigValue"
	s ClassMethodObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	q:'$IsObject(ClassMethodObj) "N"
	s BDPHospAutFlag=##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPHospAut") //是否开启医院授权
	
	q BDPHospAutFlag
}

/// Creator:	czf
/// CreateDate:	2021-04-19
/// Descript:	获取BDP_MappingHosp内对应的数据ID
/// 			基础数据,多院区改造模式用到
/// Input:		TableName:表名
/// 			HospId:医院ID
/// 			Reference:表记录rowid
/// Output:		BDP_MappingHosp记录rowid
/// Command:	w ##class(web.DHCEQ.Util.BDPCommonUtil).GetBDPMapId(2)
ClassMethod GetBDPMapId(TableName, HospId, Reference) As %String
{
	n (TableName,HospId,Reference)
	q:(TableName="")||(HospId="")||(Reference="") ""
	s BDPMapId=$o(^User.BDPMappingHospI("DataRef",TableName,HospId,Reference,""),-1) 
	q BDPMapId
}

/// Creator:	czf
/// CreateDate:	2021-04-19
/// Description:保存医院关联
/// Table: 		BDP_MappingHosp
/// Input: 		BDPMPHTableName:表名
/// 			BDPMPHDataReference:rowid
/// 			BDPMPHHospital:医院ID	
/// Output: 	成功:ID^添加成功；失败:-1:添加失败;  0:未开启医院授权
/// Command:	w ##class(web.DHCEQ.Util.BDPCommonUtil).SaveHOSP("DHCEQ_EQCMasterItem",1,2)
ClassMethod SaveHOSP(BDPMPHTableName, BDPMPHDataReference, BDPMPHHospital) As %String
{
	n (BDPMPHTableName, BDPMPHDataReference, BDPMPHHospital)
	s HospFlag=##class(web.DHCEQCommon).GetSysInfo("990051")	//未开启平台医院权限，则不保存
	i HospFlag'=2 q 0
	
	s BDPHospAutFlag=##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPHospAut") //医院级别授权是否开启
	q:BDPHospAutFlag'="Y" 0
	
	s TableType=..GetTableType(BDPMPHTableName)
	q:TableType="G" 0
	
	s ClassMethodStr="web.DHCBL.BDP.BDPMappingHOSP||SaveHOSP"
	s ClassMethodObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	q:'$IsObject(ClassMethodObj) 0
	s ret=0
	s ReturnStr=##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP(BDPMPHTableName,BDPMPHDataReference,BDPMPHHospital)
	i +ReturnStr'>0 s ret=-1
	q ret
}

/// Creator:	czf
/// CreateDate:	2021-04-19
/// Description:删除表数据医院关联
/// Input: 		BDPMPHTableName:表名
/// 			BDPMPHDataReference:表数据rowid
/// 			hospid:医院RowID
/// Output: 	成功:1；失败:-1^关联医院表数据删除失败
/// Command:	w ##class(web.DHCEQ.Util.BDPCommonUtil).DeleteHospitals("DHC_EQCMasterItem",1)
ClassMethod DeleteHospitals(BDPMPHTableName, BDPMPHDataReference, hospid = "") As %String
{
	n (BDPMPHTableName, BDPMPHDataReference,hospid)
	
	s HospFlag=##class(web.DHCEQCommon).GetSysInfo("990051")	//未开启平台医院权限，则不删除
	i HospFlag'=2 q 1
	
	s TableType=..GetTableType(BDPMPHTableName)
	q:TableType="G" 1
	
	s ClassMethodStr="web.DHCBL.BDP.BDPMappingHOSP||DeleteHospitals"
	s ClassMethodObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	q:'$IsObject(ClassMethodObj) 1
	
	;hospid为空时，删除所有表数据关联医院关系
	s ReturnStr=0
	i hospid'="" d
	.s ReturnStr=##class(web.DHCBL.BDP.BDPMappingHOSP).DeleteHospital(BDPMPHTableName,BDPMPHDataReference,hospid)
	e  d
	.s ReturnStr=##class(web.DHCBL.BDP.BDPMappingHOSP).DeleteHospitals(BDPMPHTableName,BDPMPHDataReference)
	i ReturnStr=1 s ReturnStr=0
	q ReturnStr
}

/// Creator:	czf
/// CreateDate:	2021-04-19
/// Description:当前登录人是否有权限查看表数据(基础平台配置,是否公有,是否授权院区)
/// Input: 		tableName:表名
/// 			dataid:表数据rowid
/// 			HospId:医院ID
/// 			Flag:是否忽略医院授权管理启用与否(Y:忽略,N|"":不忽略)
/// 			ShowAllFlag:是否显示所有医院(Y:显示,N|"":不完全显示)
/// Output: 	Y:有权限；N:无权限
/// Command:	w ##class(web.DHCEQ.Util.BDPCommonUtil).GetHospShowDataFlag("DHC_EQCMasterItem",4856,9)
ClassMethod GetHospShowDataFlag(tableName, dataid, HospId, Flag = "", ShowAllFlag = "") As %String
{
	n (%session,tableName, dataid, HospId, Flag, ShowAllFlag)
	
	s HospFlag=##class(web.DHCEQCommon).GetSysInfo("990051")
	i HospFlag'=2 q "Y"
	
	;取所有医院范围
	q:ShowAllFlag="Y" "Y"
	
	;判断是否开启医院授权管理
	s BDPHospAutFlag=##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPHospAut")
	q:((Flag'="Y")&&(BDPHospAutFlag'="Y")) "Y"
	
	;表类型为共有则可访问
	s TableType=..GetTableType(tableName)
	q:TableType="G" "Y"
	
	q:($g(tableName)="")||($g(dataid)="") "N" 
	
	;院区为空默认取全部
	q:($g(HospId)="") "Y"
	
	;取平台表数据授权
	s ClassMethodStr="web.DHCBL.BDP.BDPMappingHOSP||GetHospShowDataFlag"
	s ClassMethodObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	q:'$IsObject(ClassMethodObj) "Y"
	s retValue=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(tableName,dataid,HospId)
	
	q retValue
}

/// Creator:    czf
/// CreateDate: 2021-04-19
/// Description:获取表的类型（公有G ，私有S，管控C，绝对私有A）
/// 			公有G：不限制
/// 			私有S：私有不允许有多家医院，并且医院只能为这个表对应的默认医院或者例外医院
/// 			绝对私有A：绝对私有不允许有多家医院,并且允许是任何一家医院
/// 			管控C：管控允许多家医院，并且医院只能为这个表对应的默认医院或者例外医院
/// Input: 		BDPMPHTableName:表名
/// Output: 	表类型
/// Command:	w ##class(web.DHCEQ.Util.BDPCommonUtil).GetTableType("DHC_EQCMasterItem")
ClassMethod GetTableType(BDPMPHTableName) As %String
{
	n (BDPMPHTableName)
	
	s ClassMethodStr="web.DHCBL.BDP.BDPMappingHOSP||GetDataType"
	s ClassMethodObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	q:'$IsObject(ClassMethodObj) "G"
	s DataTypeFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDataType(BDPMPHTableName)	 //获取数据共有私有类型
	
	q DataTypeFlag
}

/// Creator:    czf
/// CreateDate: 2021-04-19
/// Description:获取院区Id(多院区)
/// Input: 		BDPHospId:多院区下拉框Id
/// 			gHospId:登录院区Id
/// 			SetDefFlag:院区下拉框为空时是否赋值登录医院id
/// 			TableName:表名
/// Output: 	表类型
/// Command:	w ##class(web.DHCEQ.Util.BDPCommonUtil).GetBDPHospId("","","","")
ClassMethod GetBDPHospId(BDPHospId, gHospId, SetDefFlag = "Y", TableName = "") As %String
{
	n (BDPHospId,gHospId,SetDefFlag,TableName,%session)
	
	s HospFlag=##class(web.DHCEQCommon).GetSysInfo("990051")
	i HospFlag'=2
	{
		i gHospId="" s gHospId=..GetCurrentSYSHospitalId()
		q gHospId		//未开启平台医院权限,返回登录医院ID
	} 
	
	s HospId=""
	
	s:HospId="" HospId=BDPHospId	//取医院下拉框取值
	
	q:(HospId="")&&(SetDefFlag="N") ""	//SetDefFlag为N不取默认值
	
	s:HospId="" HospId=gHospId
	
	s:(HospId="")&&($g(%session)) HospId=$g(%session.Data("LOGON.HOSPID"))
	
	i (HospId'="")&&(TableName'="") d
	.s HospId=..GetDefHospIdByTableName(TableName,HospId)
	
	q HospId
}

/// Creator:    czf
/// CreateDate: 2021-04-19
/// Description:获取医院接口（配置数据用）
/// 			根据表名、业务数据中的医院、日期取要取哪个医院的配置。
/// Input:      TableName:表名/配置名
/// 			HospID:医院ID
/// 			Date:日期
/// Output:     医院ID
/// Command: 	w ##Class(web.DHCEQ.Util.BDPCommonUtil).GetDefHospIdByTableName()
ClassMethod GetDefHospIdByTableName(TableName, HospID, Date = "") As %String
{
	n (TableName,HospId,Date)
	
	s ClassMethodStr="web.DHCBL.BDP.BDPMappingHOSP||GetDefHospIdByTableName"
	s ClassMethodObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassMethodStr,0)
	q:'$IsObject(ClassMethodObj) HospId
	s Date=$zd(+$h,3)
	s HospId=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName(TableName,HospId,Date)
	
	q HospId
}

/// Creator:    czf
/// CreateDate: 2021-09-01
/// Description:获取医院的默认医院
/// Input:      HospID:医院ID
/// Output:     默认医院ID
/// Command: 	w ##Class(web.DHCEQ.Util.BDPCommonUtil).GetDefaultHospital()
ClassMethod GetDefaultHospital(HospID As %String = "") As %String
{
	n (HospID)
	
	q:HospID="" ""
	s HOSPDefaultHospitalDR=$p($g(^CT("HOSP",HospID)),"^",41)	//取默认医院
	q:HOSPDefaultHospitalDR="" HospID	//没有默认医院，返回其本身
	q HOSPDefaultHospitalDR
}

/// Creator:    czf
/// CreateDate: 2021-09-01
/// Description:获取当前医院的默认医院
/// Input:      HospitalDR:医院ID
/// 			QXType:0或空:所有数据访问 1:组内安全组访问医院 2:当前登录医院 3:人员访问科室院区 4:当前医院及其默认医院 5.当前医院的默认医院
/// 			CurGroupID:当前登录安全组ID
/// 			CurHosptailID:当前登录医院ID
/// 			HospLimitFlag:审批流中医院限制 1.当前医院及医院组总院 2.本院 3.医院组总院
/// Output:     0：有权限访问 1：无权限访问
/// Command: 	w ##Class(web.DHCEQ.Util.BDPCommonUtil).GetShowBussDataFlag(10,1,82,10)
ClassMethod GetShowBussDataFlag(HospitalDR As %String = "", QXType As %String = "", CurGroupID As %String = "", CurHosptailID As %String = "", HospLimitFlag As %String = "") As %String
{
	n (HospitalDR,QXType,CurHosptailID,CurGroupID,HospLimitFlag,Flag,%session)
	i (CurGroupID="")&($d(%session)) Set CurGroupID=%session.Get("LOGON.GROUPID")
	i (CurHosptailID="") Set CurHosptailID=..GetCurrentSYSHospitalId()
	
	;不启用多院区则不走院区过滤
	s ManyHosFlag=##class(web.DHCEQCommon).GetSysInfo("990051")
	i ManyHosFlag=0	q 0
	
	i HospLimitFlag'="" s QXType=$case(HospLimitFlag,"1":"4","2":"2","3":"5",:"0")
	s Flag=1
	i +QXType=0 q 0
	i QXType=1
	{
		;安全组访问医院
		s HosptailIDS=##class(web.DHCEQCommon).GetHospIDSByGroup(CurGroupID)
		i HosptailIDS="" s HosptailIDS="^"
		s HosptailIDS=HosptailIDS_CurHosptailID_"^"
		i (HospitalDR'="")&&(HosptailIDS[("^"_HospitalDR_"^")) q 0
	}
	elseif QXType=2
	{
		;当前登录医院
		i (HospitalDR'="")&&(HospitalDR=CurHosptailID) q 0
	}
	elseif QXType=4
	{
		;当前医院及其默认医院
		s DefaultHospID=..GetDefaultHospital(HospitalDR)
		s HosptailIDS="^"_DefaultHospID_"^"_HospitalDR_"^"
		i (HospitalDR'="")&&(HosptailIDS[("^"_CurHosptailID_"^")) q 0
	}
	elseif QXType=5
	{
		;当前医院的默认医院
		s HospDRDefHospID=..GetDefaultHospital(HospitalDR)
		i (HospDRDefHospID'="")&&(HospDRDefHospID=CurHosptailID) q 0
	}
	q Flag
}

/// Creator:	czf
/// CreateDate:	2021-05-08
/// Description:调用基础平台方法批量更新和医院的关联关系(包括新增删除，基础平台调用）
/// Input:		tableName:表名
/// 			dataid:表数据rowid
/// 			HospIDs:医院rowid串和勾选保存标识，2$Y^3$N(Y授权,N取消授权)
/// Output:		失败:"-1^原因",成功:1
/// Command: 	w ##class(web.DHCEQ.Util.BDPCommonUtil).UpdateHOSP("DHC_EQCMasterItem",1,"2$N^3$Y^9$N")
ClassMethod UpdateHOSP(tableName As %String, dataid As %String, HospIDs As %String) As %String
{
	n (tableName,dataid,HospIDs)
	
	i tableName="" q "-1^表名不能为空"
	i dataid="" q "-1^对应表数据RowID不能为空"
	s RtnMsg=""
	
	for i=1:1:$l(HospIDs,"^")
	{
		q:RtnMsg'=""
    	s str=$p(HospIDs,"^",i)
    	s HospID=$p(str,"$",1)
    	continue:HospID=""
    	s flag=$p(str,"$",2)
    	if flag="Y"
    	{
			s ErrInfo=..CodeDescIsRepeat(tableName,dataid,"",HospID)
			s RepeatRowID=$p(ErrInfo,"$",1)
			s Msg=$p(ErrInfo,"$",2)
			i Msg'="" s RtnMsg=Msg
    	}
	}
	i RtnMsg'="" q RtnMsg
	
	s RtnMsg=##class(web.DHCBL.BDP.BDPMappingHOSP).UpdateHOSP(tableName,dataid,HospIDs)
	q RtnMsg
}

/// Creator:	czf
/// CreateDate:	2021-05-08
/// Description:判断当前数据是否重复
/// Input:		TableName:表名
/// 			TableRowID:表数据rowid
/// 			TableInfo:表信息串
/// 			HospID:CT_Hospital医院表rowid
/// Output: 	重复RowID_"$"_"-1^"_错误提示!
/// Command: 	w ##class(web.DHCEQ.Util.BDPCommonUtil).CodeDescIsRepeat("DHC_EQCEquipType","","014^房屋及构筑物","2")
ClassMethod CodeDescIsRepeat(TableName As %String, TableRowID As %String, TableInfo As %String, HospID As %String) As %String
{
	n (TableName,TableRowID,TableInfo,HospID,HospFlag)
	i (TableName="") q ""
	i (TableRowID="")&&(TableInfo="") q ""
	s HospFlag=##class(web.DHCEQCommon).GetSysInfo("990051")
	s HospDesc=""
	i HospID'="" s HospDesc=$p($g(^CT("HOSP",HospID)),"^",2)
	s FindID=""
	s ErrMsg=""
	if TableName="DHC_EQCMasterItem"
	{	
		;设备项
		i (TableRowID'="")&&(TableInfo="")		;管控数据保存医院授权
		{
			s Code=$p($g(^DHCEQCCode("DHCEQCMasterItem",TableRowID)),"^",2)
			s Desc=$p($g(^DHCEQCCode("DHCEQCMasterItem",TableRowID)),"^",1)
			s EquipTypeDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",TableRowID)),"^",3)
		}
		else
		{
			s Code=$p(TableInfo,"^",1)
			s Desc=$p(TableInfo,"^",2)
			s EquipTypeDR=$p(TableInfo,"^",3)
		}
		
		i Code="" q "$-1^代码不能为空!"
		i Desc="" q "$-1^描述不能为空!"
		i EquipTypeDR="" q "$-1^类组不能为空!"
		
		s RepRowID=""
		f  s RepRowID=$o(^DHCEQCCode("DHCEQCMasterItem",RepRowID)) q:(RepRowID="")||(FindID'="")  d
		.s RepInfo=$g(^DHCEQCCode("DHCEQCMasterItem",RepRowID))
		.q:$p(RepInfo,"^",8)="Y"
		.q:(EquipTypeDR'="")&&(EquipTypeDR'=$p(RepInfo,"^",3))
		.q:(Desc'="")&&(Desc'=$p(RepInfo,"^",1))
		.s RetFlag=""
		.i RepRowID'=TableRowID d		;原数据代码、描述、类组与当前数据一致，但RowID不相同，且原数据已授权HospID权限，则当前数据重复
		..s RetFlag=..GetHospShowDataFlag(TableName,RepRowID,HospID)	;获取当前表数据医院访问权限: "Y":有权限 "N":无权限
		..i RetFlag="Y" s FindID=RepRowID
	}
	elseif TableName="DHC_EQCEquipType"
	{	
		s Code=$p(TableInfo,"^",1)
		s Desc=$p(TableInfo,"^",2)
		s FinanceTypeDR=$p(TableInfo,"^",3)
		
		i Code="" q "$-1^代码不能为空!"
		i Desc="" q "$-1^描述不能为空!"
		;i FinanceTypeDR="" q "$-1^财务大类不能为空!"
		
		s RepRowID=""
		f  s RepRowID=$o(^DHCEQCCode("DHCEQCEquipType",RepRowID)) q:(RepRowID="")||(FindID'="")  d
		.s RepInfo=$g(^DHCEQCCode("DHCEQCEquipType",RepRowID))
		.q:$p(RepInfo,"^",4)="Y"
		.s RetFlag=""
		.i HospFlag=2 d		//启用平台多院区，代码不能重复
		..q:(Code'="")&&(Code'=$p(RepInfo,"^",1))
		..i RepRowID'=TableRowID d
		...s FindID=RepRowID
		..i FindID'="" d
		...s ErrMsg="-3004^代码已存在!"
		.q:FindID'=""	
		.q:(Desc'="")&&(Desc'=$p(RepInfo,"^",2))
		.;q:(FinanceTypeDR'="")&&(FinanceTypeDR'=$p(RepInfo,"^",9))
		.s RetFlag=""
		.i RepRowID'=TableRowID d		;原数据代码、描述与当前数据一致，但RowID不相同，且原数据已授权HospID权限，则当前数据重复
		..s RetFlag=..GetHospShowDataFlag(TableName,RepRowID,HospID)	;获取当前表数据医院访问权限: "Y":有权限 "N":无权限
		..i RetFlag="Y" s FindID=RepRowID
		..i FindID'="" d
		...i HospDesc'="" s ErrMsg="-3003^描述已在"_HospDesc_"中存在!"
		...e  s ErrMsg="-3003^描述不能重复!"
		
		q FindID_"$"_ErrMsg
	}
	elseif TableName="DHC_EQCFinaceItem"
	{	
		;核算项目
		s Code=$p(TableInfo,"^",1)
		s Desc=$p(TableInfo,"^",2)
		i Code="" q "$-1^代码不能为空!"
		i Desc="" q "$-1^描述不能为空!"
		
		s RepRowID=""
		f  s RepRowID=$o(^DHCEQCCode("DHCEQCFinaceItem",RepRowID)) q:(RepRowID="")||(FindID'="")  d
		.s RepInfo=$g(^DHCEQCCode("DHCEQCFinaceItem",RepRowID))
		.q:$p(RepInfo,"^",4)="Y"
		.i HospFlag=2 d		//启用平台多院区，代码不能重复
		..q:(Code'="")&&(Code'=$p(RepInfo,"^",1))
		..i RepRowID'=TableRowID d
		...s FindID=RepRowID
		..i FindID'="" d
		...s ErrMsg="-3004^代码已存在!"
		.q:FindID'=""	
		.q:(Desc'="")&&(Desc'=$p(RepInfo,"^",2))
		.s RetFlag=""
		.i RepRowID'=TableRowID d		;原数据代码、描述与当前数据一致，但RowID不相同，且原数据已授权HospID权限，则当前数据重复
		..s RetFlag=..GetHospShowDataFlag(TableName,RepRowID,HospID)	;获取当前表数据医院访问权限: "Y":有权限 "N":无权限
		..i RetFlag="Y" s FindID=RepRowID
		..i FindID'="" d
		...i HospDesc'="" s ErrMsg="-3003^描述已在"_HospDesc_"中存在!"
		...e  s ErrMsg="-3003^描述不能重复!"
		
		q FindID_"$"_ErrMsg
	}
	elseif TableName="DHC_EQCFunctionCat"
	{	
		s Code=$p(TableInfo,"^",1)
		s Desc=$p(TableInfo,"^",2)
		i Code="" q "$-1^代码不能为空!"
		i Desc="" q "$-1^描述不能为空!"
		
		s RepRowID=""
		f  s RepRowID=$o(^DHCEQCCode("DHCEQCFunctionCat",RepRowID)) q:(RepRowID="")||(FindID'="")  d
		.s RepInfo=$g(^DHCEQCCode("DHCEQCFunctionCat",RepRowID))
		.q:$p(RepInfo,"^",4)="Y"
		.i HospFlag=2 d		//启用平台多院区，代码不能重复
		..q:(Code'="")&&(Code'=$p(RepInfo,"^",1))
		..i RepRowID'=TableRowID d
		...s FindID=RepRowID
		..i FindID'="" d
		...s ErrMsg="-3004^代码已存在!"
		.q:FindID'=""	
		.q:(Desc'="")&&(Desc'=$p(RepInfo,"^",2))
		.s RetFlag=""
		.i RepRowID'=TableRowID d		;原数据代码、描述与当前数据一致，但RowID不相同，且原数据已授权HospID权限，则当前数据重复
		..s RetFlag=..GetHospShowDataFlag(TableName,RepRowID,HospID)	;获取当前表数据医院访问权限: "Y":有权限 "N":无权限
		..i RetFlag="Y" s FindID=RepRowID
		..i FindID'="" d
		...i HospDesc'="" s ErrMsg="-3003^描述已在"_HospDesc_"中存在!"
		...e  s ErrMsg="-3003^描述不能重复!"
		
		q FindID_"$"_ErrMsg
	}
	elseif TableName="DHC_EQCSysSet"
	{
		i (TableRowID'="")&&(TableInfo="")		;管控数据保存医院授权
		{
			s Code=$p($g(^DHCEQCCode("DHCEQCSysSet",TableRowID)),"^",1)
			s Value=$p($g(^DHCEQCCode("DHCEQCSysSet",TableRowID)),"^",2)
		}
		else
		{
			s Code=$p(TableInfo,"^",1)
			s Value=$p(TableInfo,"^",2)
		}
		i Code="" q "$-1^代码不能为空!"
		
		s RepRowID=""
		f  s RepRowID=$o(^DHCEQCCode("DHCEQCSysSet",RepRowID)) q:(RepRowID="")||(FindID'="")  d
		.s RepInfo=$g(^DHCEQCCode("DHCEQCSysSet",RepRowID))
		.q:(Code'="")&&(Code'=$p(RepInfo,"^",1))
		.;q:(Value'=$p(RepInfo,"^",2))
		.s RetFlag=""
		.i RepRowID'=TableRowID d		;原数据代码、描述与当前数据一致，但RowID不相同，且原数据已授权HospID权限，则当前数据重复
		..s RetFlag=..GetHospShowDataFlag(TableName,RepRowID,HospID)	;获取当前表数据医院访问权限: "Y":有权限 "N":无权限
		..i RetFlag="Y" s FindID=RepRowID
	}
	elseif TableName="DHC_EQCLocation"
	{
		s Code=$p(TableInfo,"^",1)
		s Desc=$p(TableInfo,"^",2)
		s LocDR=$p(TableInfo,"^",3)			//czf 2021-07-02 begin
		s BildingDR=$p(TableInfo,"^",4)
		s BildingUnitDR=$p(TableInfo,"^",5)
		s SysFlag=##class(web.DHCEQCommon).GetSysInfo("990082")	//存放地点是否绑定空间 0:不需绑定 1:可绑定限制 2:必须绑定
		i Code="" q "$-1^代码不能为空!"
		i Desc="" q "$-1^描述不能为空!"
		
		s RepRowID=""
		f  s RepRowID=$o(^DHCEQCCode("DHCEQCLocation",RepRowID)) q:(RepRowID="")||(FindID'="")  d
		.s RepInfo=$g(^DHCEQCCode("DHCEQCLocation",RepRowID))
		.q:$p(RepInfo,"^",11)="Y"    //modify by lmm 2021-09-07 hold2更改无效标记字段
		.i HospFlag=2 d		//启用平台多院区，代码不能重复
		..q:(Code'="")&&(Code'=$p(RepInfo,"^",1))
		..i RepRowID'=TableRowID d
		...s FindID=RepRowID
		..i FindID'="" d
		...s ErrMsg="-3004^代码已存在!"
		.q:FindID'=""	
		.q:(Desc'="")&&(Desc'=$p(RepInfo,"^",2))
		.q:(+SysFlag'=0)&&(LocDR'="")&&(LocDR'=$p(RepInfo,"^",5))
		.q:(+SysFlag'=0)&&(BildingDR'="")&&(BildingDR'=$p(RepInfo,"^",6))
		.q:(+SysFlag'=0)&&(BildingUnitDR'="")&&(BildingUnitDR'=$p(RepInfo,"^",7))	//czf 2021-07-02 end
		.s RetFlag=""
		.i RepRowID'=TableRowID d	;原数据代码、描述与当前数据一致，但RowID不相同，且原数据已授权HospID权限，则当前数据重复
		..s RetFlag=..GetHospShowDataFlag(TableName,RepRowID,HospID)	;获取当前表数据医院访问权限: "Y":有权限 "N":无权限
		..i RetFlag="Y" s FindID=RepRowID
		..i FindID'="" d
		...i HospDesc'="" s ErrMsg="-3003^描述已在"_HospDesc_"中存在!"
		...e  s ErrMsg="-3003^描述不能重复!"
		
		q FindID_"$"_ErrMsg
	}
	elseif TableName="DHC_EQCApproveSet"
	{
		s Code=$p(TableInfo,"^",1)
		s Desc=$p(TableInfo,"^",2)
		s ApproveTypeDR=$p(TableInfo,"^",3)
		i Code="" q "$-1^代码不能为空!"
		i Desc="" q "$-1^描述不能为空!"
		i ApproveTypeDR="" q "$-1^审批类型不能为空!"
		
		s RepRowID=""
		f  s RepRowID=$o(^DHCEQCCode("DHCEQCApproveSet",RepRowID)) q:(RepRowID="")||(FindID'="")  d
		.s RepInfo=$g(^DHCEQCCode("DHCEQCApproveSet",RepRowID))
		.q:(ApproveTypeDR'="")&&(ApproveTypeDR'=$p(RepInfo,"^",1))
		.q:(Code'="")&&(Code'=$p(RepInfo,"^",3))
		.q:(Desc'="")&&(Desc'=$p(RepInfo,"^",2))
		.s RetFlag=""
		.i RepRowID'=TableRowID d	;原数据代码、描述与当前数据一致，但RowID不相同，且原数据已授权HospID权限，则当前数据重复
		..s RetFlag=..GetHospShowDataFlag(TableName,RepRowID,HospID)	;获取当前表数据医院访问权限: "Y":有权限 "N":无权限
		..i RetFlag="Y" s FindID=RepRowID
	}
	elseif TableName="DHC_EQCOrigin"  ;Add By QW20210525 BUG:QW0115
	{	
		;设备来源
		s Code=$p(TableInfo,"^",1)
		s Desc=$p(TableInfo,"^",2)
		i Code="" q "$-1^代码不能为空!"
		i Desc="" q "$-1^描述不能为空!"
		
		s RepRowID=""
		f  s RepRowID=$o(^DHCEQCCode("DHCEQCOrigin",RepRowID)) q:(RepRowID="")||(FindID'="")  d
		.s RepInfo=$g(^DHCEQCCode("DHCEQCOrigin",RepRowID))
		.q:$p(RepInfo,"^",4)="Y"
		.q:((Code'="")&&(Code'=$p(RepInfo,"^",1)))&&((Desc'="")&&(Desc'=$p(RepInfo,"^",2)))
		.s RetFlag=""
		.i RepRowID'=TableRowID d		;原数据代码、描述与当前数据一致，但RowID不相同，且原数据已授权HospID权限，则当前数据重复
		..s RetFlag=..GetHospShowDataFlag(TableName,RepRowID,HospID)	;获取当前表数据医院访问权限: "Y":有权限 "N":无权限
		..i RetFlag="Y" s FindID=RepRowID
	}
	elseif TableName="DHC_EQCDisuseReason"  ;Add By ZYQ20220913
	{	
		;设备报废原因维护
		s Code=$p(TableInfo,"^",1)
		s Desc=$p(TableInfo,"^",2)
		i Code="" q "$-1^代码不能为空!"
		i Desc="" q "$-1^描述不能为空!"
		s RepRowID=""
		f  s RepRowID=$o(^DHCEQCCode("DHCEQCDisuseReason",RepRowID)) q:(RepRowID="")||(FindID'="")  d
		.s RepInfo=$g(^DHCEQCCode("DHCEQCDisuseReason",RepRowID))
		.q:$p(RepInfo,"^",4)="Y"
		.q:((Code'="")&&(Code'=$p(RepInfo,"^",1)))&&((Desc'="")&&(Desc'=$p(RepInfo,"^",2)))
		.s RetFlag=""
		.i RepRowID'=TableRowID d		;原数据代码、描述与当前数据一致，但RowID不相同，且原数据已授权HospID权限，则当前数据重复
		..s RetFlag=..GetHospShowDataFlag(TableName,RepRowID,HospID)	;获取当前表数据医院访问权限: "Y":有权限 "N":无权限
		..i RetFlag="Y" s FindID=RepRowID
	}
	i FindID'=""
	{
		i HospDesc'="" s ErrMsg="-1^数据已在"_HospDesc_"中存在!"
		e  s ErrMsg="-1^数据已存在!"
	}
	
	q FindID_"$"_ErrMsg
}

/// Creator:    czf
/// CreateDate: 2021-04-19
/// Description:医院对照表数据初始化
/// Input:      TableName:表名/配置名
/// 			FromTableID:起始rowid
/// 			ToTableID:结束rowid
/// 			HospitalIDs:CTHospID串,用","分隔
/// Output:     成功："success"
/// w ##Class(web.DHCEQ.Util.BDPCommonUtil).InitBDPMappingHosp("DHC_EQCApproveSet","","","2")
ClassMethod InitBDPMappingHosp(TableName, FromTableID As %String = "", ToTableID As %String = "", HospitalIDs)
{
	n (TableName,FromTableID,ToTableID,HospitalIDs,RowID)
	i +FromTableID>+ToTableID q "入参值错误!"
	s RowID=""
	
	i TableName="DHC_EQCEquipType"
	{
		s ETRowID=0
		f  s ETRowID=$o(^DHCEQCCode("DHCEQCEquipType",ETRowID)) q:ETRowID=""  d
		.q:(FromTableID'="")&&(FromTableID>ETRowID)
		.q:(ToTableID'="")&&(ToTableID<ETRowID)
		.s RowID=ETRowID
		.d SaveMappingHosp
	}
	elseif TableName="DHC_EQCMasterItem"
	{
		s MIRowID=0
		f  s MIRowID=$o(^DHCEQCCode("DHCEQCMasterItem",MIRowID)) q:MIRowID=""  d
		.q:(FromTableID'="")&&(FromTableID>MIRowID)
		.q:(ToTableID'="")&&(ToTableID<MIRowID)
		.s RowID=MIRowID
		.d SaveMappingHosp
	}
	elseif TableName="DHC_EQCSysSet"
	{
		s SSRowID=0
		f  s SSRowID=$o(^DHCEQCCode("DHCEQCSysSet",SSRowID)) q:SSRowID=""  d
		.q:(FromTableID'="")&&(FromTableID>SSRowID)
		.q:(ToTableID'="")&&(ToTableID<SSRowID)
		.s RowID=SSRowID
		.d SaveMappingHosp
	}
	elseif TableName="DHC_EQCFinaceItem"
	{
		s FIRowID=0
		f  s FIRowID=$o(^DHCEQCCode("DHCEQCFinaceItem",FIRowID)) q:FIRowID=""  d
		.q:(FromTableID'="")&&(FromTableID>FIRowID)
		.q:(ToTableID'="")&&(ToTableID<FIRowID)
		.s RowID=FIRowID
		.d SaveMappingHosp
	}
	elseif TableName="DHC_EQCFunctionCat"
	{
		s FCRowID=0
		f  s FCRowID=$o(^DHCEQCCode("DHCEQCFunctionCat",FCRowID)) q:FCRowID=""  d
		.q:(FromTableID'="")&&(FromTableID>FCRowID)
		.q:(ToTableID'="")&&(ToTableID<FCRowID)
		.s RowID=FCRowID
		.d SaveMappingHosp
	}
	elseif TableName="DHC_EQCLocation"
	{
		s LRowID=0
		f  s LRowID=$o(^DHCEQCCode("DHCEQCLocation",LRowID)) q:LRowID=""  d
		.q:(FromTableID'="")&&(FromTableID>LRowID)
		.q:(ToTableID'="")&&(ToTableID<LRowID)
		.s RowID=LRowID
		.d SaveMappingHosp
	}
	elseif TableName="DHC_EQCApproveSet"
	{
		s ASRowID=0
		f  s ASRowID=$o(^DHCEQCCode("DHCEQCApproveSet",ASRowID)) q:ASRowID=""  d
		.q:(FromTableID'="")&&(FromTableID>ASRowID)
		.q:(ToTableID'="")&&(ToTableID<ASRowID)
		.s RowID=ASRowID
		.d SaveMappingHosp
	}
	q "success"
	
SaveMappingHosp
	f i=1:1:$l(HospitalIDs,",") d
	.s HospitalID=$p(HospitalIDs,",",i)
	.q:HospitalID=""
	.s ReturnStr=##class(web.DHCBL.BDP.BDPMappingHOSP).SaveHOSP(TableName,RowID,HospitalID)
	.q:+ReturnStr'>0
		
	quit
}

}
