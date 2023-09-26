/// 名称: 升级代码表基础数据相关服务
/// 编写者：zhufei
/// 编写日期: 2021-08-19
Class web.DHCPE.Upgrade.CodeTableSrv Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：    zhufei
/// CreatDate：  20210819
/// Description: 升级代码表基础数据主程序
/// Table：      所有新建或新加字段的基础数据表
/// Input:       无
/// Return：     return="OK!!!"
/// debug: w ##class(web.DHCPE.Upgrade.CodeTableSrv).Main(1)
ClassMethod Main(aUserID As %String) As %String
{
    n (aUserID)
    s return="-1^参数为空"
    q:(aUserID="") return
    q:'$d(^SSU("SSUSR",aUserID)) return
    
    //前提条件：
    //1.导入最新的基础数据表结构
    //2.基础数据表计数器迁移
    //3.维护科室分组配置（把所有体检中心配置到一个科室组下）
    //4.导入表登记授权管理数据
    
    //检查是否导入最新的基础数据表结构（部分校验）
    s flg=##Class(%Dictionary.CompiledClass).%ExistsId("User.DHCPELocGrpConfig")
    q:flg<1 "未导入最新的基础数据表结构"
    s flg=##Class(%Dictionary.CompiledClass).%ExistsId("User.DHCPENewMessageTemplet")
    q:flg<1 "未导入最新的基础数据表结构"
    
    //基础数据表计数器迁移
    do ##class(web.DHCPE.Upgrade.TableCounter).SetCounter()
    
    //检查是否维护科室分组配置
    //所有体检中心是否配置到同一个科室组下
    s aLGLocID=..GetLGLocID()
    s aLocIDs=..GetLocIDs()
    q:aLocIDs="" "未维护科室分组配置"
    q:aLGLocID="" "未维护科室分组配置"
    q:$l(aLGLocID,",")>1 "不能维护多个科室分组"
    s xId=0,IsConfig=0
    for {
	    s xId=$o(^CF.PE.LocGrpConfigD(xId))
	    q:xId=""
	    
	    s tLGLocID=$lg($g(^CF.PE.LocGrpConfigD(xId)),3)
	    s tActive=$lg($g(^CF.PE.LocGrpConfigD(xId)),5)
	    continue:tActive'="Y"
	    s IsConfig=1
	    if tLGLocID'=aLGLocID {
		    s IsConfig=0
		    q //原则上要保证所有体检中心未配置到同一个科室组下
		}
	}
	q:IsConfig<1 "所有体检中心未配置到同一个科室组下"
	
	//检查表登记授权是否维护（部分校验）
	q:$o(^CT.PE.PowerTableListD(0))="" "未维护表登记授权管理数据"
	s PowerType=##class(User.DHCPEStationOrder).GetTabPowerType()
	q:PowerType'="S" "未维护表登记授权管理数据"
	s PowerType=##class(User.DHCPEUsherItemCat).GetTabPowerType()
	q:PowerType'="A" "未维护表登记授权管理数据"
	s PowerType=##class(User.DHCPENewMessageTemplet).GetTabPowerType()
	q:PowerType'="A" "未维护表登记授权管理数据"
	
    //体检项目维护
    //DHC_PE_StationOrder--私有
    //DHC_PE_OrderDetail--私有
    //DHC_PE_ODStandard--新加字段，私有
    //DHC_PE_StationSet--新建表，绝对私有
    //DHC_PE_StationOrdCatSort--新建表，私有
    //DHC_PE_StationOrderSort--新建表，私有
    //DHC_PE_StationOrderSet--新建表，绝对私有
    //DHC_PE_OrderDetailSet--新建表，绝对私有
    //DHC_PE_OrderDetailRelate--新加字段，私有
    //DHC_PE_ExcludeArcItem--私有
    //DHC_PE_UsherItemCat--新建表，绝对私有
    
    w "DHC_PE_StationOrder--私有",!
    w "执行结果="_..toStationOrder("DHC_PE_StationOrder",aLGLocID,aUserID,aLocIDs),!!
    
    w "DHC_PE_OrderDetail--私有",!
    w "执行结果="_..toOrderDetail("DHC_PE_OrderDetail",aLGLocID,aUserID,aLocIDs),!!
    
    w "DHC_PE_ODStandard--新加字段，私有",!
    w "执行结果="_..toODStandard("DHC_PE_ODStandard",aLGLocID,aUserID,aLocIDs),!!
    
    w "DHC_PE_StationSet--新建表，绝对私有",!
    w "执行结果="_..toStationSet("DHC_PE_StationSet",aLGLocID,aUserID,aLocIDs),!!
    
    w "DHC_PE_StationOrdCatSort--新建表，私有",!
    w "执行结果="_..toStationOrdCatSort("DHC_PE_StationOrdCatSort",aLGLocID,aUserID,aLocIDs),!!
    
    w "DHC_PE_StationOrderSort--新建表，私有",!
    w "执行结果="_..toStationOrderSort("DHC_PE_StationOrderSort",aLGLocID,aUserID,aLocIDs),!!
    
    w "DHC_PE_UsherItemCat--新建表，绝对私有",!
    w "---此步骤必须在站点项目设置之前执行",!
    w "执行结果="_..toUsherItemCat("DHC_PE_UsherItemCat",aLGLocID,aUserID,aLocIDs),!!
    
    w "DHC_PE_StationOrderSet--新建表，绝对私有",!
    w "---此步骤必须在导诊单分类维护之后执行",!
    w "执行结果="_..toStationOrderSet("DHC_PE_StationOrderSet",aLGLocID,aUserID,aLocIDs),!!
    
    w "DHC_PE_OrderDetailSet--新建表，绝对私有",!
    w "执行结果="_..toOrderDetailSet("DHC_PE_OrderDetailSet",aLGLocID,aUserID,aLocIDs),!!
    
    w "DHC_PE_OrderDetailRelate--新加字段，私有",!
    w "执行结果="_..toOrderDetailRelate("DHC_PE_OrderDetailRelate",aLGLocID,aUserID,aLocIDs),!!
    
    w "DHC_PE_ExcludeArcItem--私有",!
    w "执行结果="_..toExcludeArcItem("DHC_PE_ExcludeArcItem",aLGLocID,aUserID,aLocIDs),!!
    
    //医生建议
    //DHC_PE_EDClass--私有
    //DHC_PE_EDKey--私有
    //DHC_PE_IllnessStandard--私有
    //DHC_PE_ILLSAlias--私有
    //DHC_PE_ILLSExplain--新建表，私有
    //DHC_PE_ILLSSportGuide--新建表，私有
    //DHC_PE_ILLSDietGuide--新建表，私有
    //DHC_PE_ExpertDiagnosis--新加字段，私有
    //DHC_PE_EDAlias--私有
    //DHC_PE_IDRelate--私有
    //DHC_PE_Express--私有
    
    w "DHC_PE_EDClass--私有",!
    w "执行结果="_..toEDClass("DHC_PE_EDClass",aLGLocID,aUserID,aLocIDs),!!
    
    w "DHC_PE_EDKey--私有",!
    w "执行结果="_..toEDKey("DHC_PE_EDKey",aLGLocID,aUserID,aLocIDs),!!
    
    w "DHC_PE_IllnessStandard--私有",!   //管控改为私有
    w "执行结果="_..toIllnessStandard("DHC_PE_IllnessStandard",aLGLocID,aUserID,aLocIDs),!!
    
    w "DHC_PE_ILLSAlias--私有",!   //管控改为私有
    w "执行结果="_..toILLSAlias("DHC_PE_ILLSAlias",aLGLocID,aUserID,aLocIDs),!!
    
    w "DHC_PE_ILLSExplain--新建表，私有",!
    w "执行结果="_..toILLSExplain("DHC_PE_ILLSExplain",aLGLocID,aUserID,aLocIDs),!!
    
    w "DHC_PE_ILLSSportGuide--新建表，私有",!
    w "执行结果="_..toILLSSportGuide("DHC_PE_ILLSSportGuide",aLGLocID,aUserID,aLocIDs),!!
    
    w "DHC_PE_ILLSDietGuide--新建表，私有",!
    w "执行结果="_..toILLSDietGuide("DHC_PE_ILLSDietGuide",aLGLocID,aUserID,aLocIDs),!!
    
    w "DHC_PE_ExpertDiagnosis--私有",!
    w "执行结果="_..toExpertDiagnosis("DHC_PE_ExpertDiagnosis",aLGLocID,aUserID,aLocIDs),!!
    
    w "DHC_PE_EDAlias--私有",!
    w "执行结果="_..toEDAlias("DHC_PE_EDAlias",aLGLocID,aUserID,aLocIDs),!!
    
    w "DHC_PE_IDRelate--私有",!
    w "执行结果="_..toIDRelate("DHC_PE_IDRelate",aLGLocID,aUserID,aLocIDs),!!
    
    w "DHC_PE_Express--私有",!
    w "执行结果="_..toExpress("DHC_PE_IDRelate",aLGLocID,aUserID,aLocIDs),!!
    
    //体检医嘱套维护
	//DHC_PE_OrdSetsEx--绝对私有
	//DHC_PE_Net_ItemType--私有
	//DHC_PE_NetOrdSets--绝对私有
	//DHC_PE_NetSetsItemType--绝对私有
	//DHC_PE_NetSetsItem--绝对私有
	//DHC_PE_NetSetsItemDetail--绝对私有
	
    w "DHC_PE_OrdSetsEx--绝对私有",!  //私有改绝对私有
    w "执行结果="_..toOrdSetsEx("DHC_PE_OrdSetsEx",aLGLocID,aUserID,aLocIDs),!!
    
    w "DHC_PE_NetItemType--私有",!
    w "执行结果="_..toNetItemType("DHC_PE_NetItemType",aLGLocID,aUserID,aLocIDs),!!
	
    w "DHC_PE_NetOrdSets--绝对私有",!
	w "---父子表权限一致：DHC_PE_NetSetsItemType--绝对私有",!
	w "---父子表权限一致：DHC_PE_NetSetsItem--绝对私有",!
	w "---父子表权限一致：DHC_PE_NetSetsItemDetail--绝对私有",!
    w "执行结果="_..toNetOrdSets("DHC_PE_NetOrdSets",aLGLocID,aUserID,aLocIDs),!!
    
    //职业病体检
	//DHC_PE_HandlingOpinions--私有
	//DHC_PE_EDItem--绝对私有
	//DHC_PE_EDItemDetail--绝对私有
	
    w "DHC_PE_HandlingOpinions--私有",!
    w "执行结果="_..toHandlingOpinions("DHC_PE_HandlingOpinions",aLGLocID,aUserID,aLocIDs),!!
    
    w "DHC_PE_EDItem--绝对私有",!  //私有改绝对私有
    w "DHC_PE_EDItemDetail--绝对私有",!  //私有改绝对私有
    w "---此步骤必须在科室站点项目和体检套餐设置之后执行",!
    w "执行结果="_..toEDItem("DHC_PE_EDItem",aLGLocID,aUserID,aLocIDs),!!
    
    //体检项目/医嘱项设置
	//DHC_PE_ItemExtend---私有
	//DHC_PE_IESendItem---绝对私有
	//DHC_PE_IEPrice---绝对私有
	
    w "DHC_PE_ItemExtend---私有",!
    w "执行结果="_..toItemExtend("DHC_PE_ItemExtend",aLGLocID,aUserID,aLocIDs),!!
    
    w "DHC_PE_IESendItem---绝对私有",!
    w "执行结果="_..toIESendItem("DHC_PE_IESendItem",aLGLocID,aUserID,aLocIDs),!!
    
    w "DHC_PE_IEPrice---绝对私有",!
    w "执行结果="_..toIEPrice("DHC_PE_IEPrice",aLGLocID,aUserID,aLocIDs),!!
    
    //体检操作用户权限设置
	//DHC_PE_ChartAssign---新建表，绝对私有
	//DHC_PE_ChartAssignDtl---新建表，绝对私有
	//DHC_PE_ChargeLimit---新建表，绝对私有
	//DHC_PE_SpecialContral---新建表，绝对私有
	//DHC_PE_OthPatToHPBase---新建表，绝对私有
	//DHC_PE_WorkDistributeType---管控
	//DHC_PE_WorkLinkUrl---管控
	//DHC_PE_WorkDoctor---绝对私有
	
    w "DHC_PE_ChartAssign---新建表，绝对私有",!  //私有改绝对私有
    w "执行结果="_..toChartAssign("DHC_PE_ChartAssign",aLGLocID,aUserID,aLocIDs),!!
    
    w "DHC_PE_ChartAssignDtl---新建表，绝对私有",!  //私有改绝对私有
    w "执行结果="_..toChartAssignDtl("DHC_PE_ChartAssignDtl",aLGLocID,aUserID,aLocIDs),!!
    
    w "DHC_PE_ChargeLimit---新建表，绝对私有",!  //私有改绝对私有
    w "执行结果="_..toChargeLimit("DHC_PE_ChargeLimit",aLGLocID,aUserID,aLocIDs),!!
    
    w "DHC_PE_SpecialContral---新建表，绝对私有",!  //私有改绝对私有
    w "执行结果="_..toSpecialContral("DHC_PE_SpecialContral",aLGLocID,aUserID,aLocIDs),!!
	
    w "DHC_PE_OthPatToHPBase---新建表，绝对私有",!
    w "执行结果="_..toOthPatToHPBase("DHC_PE_OthPatToHPBase",aLGLocID,aUserID,aLocIDs),!!
    
    w "DHC_PE_WorkDistributeType---管控",!
    w "执行结果="_..toWorkDistributeType("DHC_PE_WorkDistributeType",aLGLocID,aUserID,aLocIDs),!!
    
    w "DHC_PE_WorkLinkUrl---管控",!
    w "执行结果="_..toWorkLinkUrl("DHC_PE_WorkLinkUrl",aLGLocID,aUserID,aLocIDs),!!
    
    w "DHC_PE_WorkDoctor---私有",!
    w "执行结果="_..toWorkDoctor("DHC_PE_WorkDoctor",aLGLocID,aUserID,aLocIDs),!!
    
    //DHC_PE_Area--绝对私有
    //DHC_PE_Room--绝对私有
    //DHC_PE_RoomIP--绝对私有
    //DHC_PE_RoomSpecialRoom--绝对私有
    //DHC_PE_RoomRoomPlace--绝对私有
    //DHC_PE_RoomSpecimen--绝对私有
    //DHC_PE_RoomPlace--绝对私有
	
    w "DHC_PE_Area--绝对私有",!
    w "执行结果="_..toArea("DHC_PE_Area",aLGLocID,aUserID,aLocIDs),!!
	w "---父子表权限一致：DHC_PE_Room--绝对私有",!
	w "---父子表权限一致：DHC_PE_RoomIP--绝对私有",!
	w "---父子表权限一致：DHC_PE_RoomSpecialRoom--绝对私有",!
	w "---父子表权限一致：DHC_PE_RoomRoomPlace--绝对私有",!
	w "---父子表权限一致：DHC_PE_RoomSpecimen--绝对私有",!
    w "DHC_PE_RoomPlace--绝对私有",!
    w "执行结果="_..toRoomPlace("DHC_PE_RoomPlace",aLGLocID,aUserID,aLocIDs),!!
	
    //DHC_PE_VIPLevel---新建表，公有
    //DHC_PE_LocVIPLevel---新建表，绝对私有
    //DHC_PE_NewMessageTemplet---新增字段，绝对私有
    //DHC_PE_QMType---管控
	
    w "DHC_PE_VIPLevel---新建表，公有",!
    w "---此步骤必须在科室VIP等级维护之前执行",!
    w "执行结果="_..toVIPLevel("DHC_PE_VIPLevel",aLGLocID,aUserID,aLocIDs),!!
    
    w "DHC_PE_LocVIPLevel---新建表，绝对私有",!
    w "---此步骤必须在VIP等级维护之后执行",!
    w "执行结果="_..toLocVIPLevel("DHC_PE_LocVIPLevel",aLGLocID,aUserID,aLocIDs),!!
    
    w "DHC_PE_NewMessageTemplet---新增字段，绝对私有",!
    w "---此表历史数据都归入科室组默认科室，有异常手工改后台数据",!
    w "执行结果="_..toNewMessageTemplet("DHC_PE_NewMessageTemplet",aLGLocID,aUserID,aLocIDs),!!
    
    w "DHC_PE_QMType---管控",!
    w "执行结果="_..toQMType("DHC_PE_QMType",aLGLocID,aUserID,aLocIDs),!!
    
    //DHC_PE_Station--站点---管控
    //DHC_PE_StationLoc--站点分类---管控
    
    w "DHC_PE_Station---管控",!  //公有改管控
    w "执行结果="_..toStation("DHC_PE_Station",aLGLocID,aUserID,aLocIDs),!!
    
    w "DHC_PE_StationLoc---管控",!  //公有改管控
    w "执行结果="_..toStationLoc("DHC_PE_StationLoc",aLGLocID,aUserID,aLocIDs),!!
    
    //DHC_HM_CQuestionnaire	调查问卷主表---私有
    //DHC_HM_CQuestionSubject	调查问卷主题表---私有
    //DHC_HM_CSDLink	调查问卷主题与问题关联表---私有
    //DHC_HM_CQEDLink	调查问卷与评估内容关联表---私有
    //DHC_HM_CServiceClass	服务级别表---私有
	//DHC_HM_CSCQLink	服务级别关联问卷表---私有
	
    w "DHC_HM_CQuestionnaire---私有",!
    w "DHC_HM_CQuestionSubject---私有",!
    w "DHC_HM_CSDLink---私有",!
    w "DHC_HM_CQEDLink---私有",!
    w "执行结果="_..toCQuestionnaire("DHC_HM_CQuestionnaire",aLGLocID,aUserID,aLocIDs),!!
    
    w "DHC_HM_CServiceClass---私有",!
    w "DHC_HM_CSCQLink---私有",!
    w "执行结果="_..toCServiceClass("DHC_HM_CServiceClass",aLGLocID,aUserID,aLocIDs),!!
    
    q "OK!!!"
}

/// DHC_HM_CServiceClass---私有
/// DHC_HM_CSCQLink---私有
ClassMethod toCServiceClass(aTableName As %String, aLGLocID As %String, aUserID As %String, aLocIDs As %String) As %String
{
    n (aTableName,aLGLocID,aUserID,aLocIDs)
    
    s objPowerType=##class(User.DHCHMCServiceClass).GetPowerTypeObj()
    q:'$IsObject(objPowerType) aTableName_" 未维护表登记授权管理数据"
	q:objPowerType.PTPowerType'="S" aTableName_" 未维护表登记授权管理数据"
	s PowerTableDR=objPowerType.%Id()
    
    s return=""
	s xId=0
	for {
		s xId=$o(^User.DHCHMCServiceClassD(xId))
		q:xId=""
		q:return'=""
		
		s ID=xId
		
		s rowData=$g(^User.DHCHMCServiceClassD(xId))
		continue:rowData=""
		s Code=$lg(rowData,3)
		
		k arrMapping
		s arrMapping("ID")=ID
		for idxLoc=1:1:$l(aLocIDs,","){
			s LocID=$p(aLocIDs,",",idxLoc)
			continue:LocID=""
			
			s arrMapping("Loc",LocID)=""
			s xNewID=0
			for {
				s xNewID=$o(^User.DHCHMCServiceClassI("SCCodeIndex"," "_Code,xNewID))
				q:xNewID=""
				
				s NewID=xNewID
				continue:##class(User.DHCHMCServiceClass).GetLocShowDataFlag(NewID,LocID)'="Y"
				s arrMapping("Loc",LocID,NewID)=""
				s:NewID=ID arrMapping("ID")=""
			}
		}
		
		s xLocID=0
		for {
			s xLocID=$o(arrMapping("Loc",xLocID))
			q:xLocID=""
			continue:$o(arrMapping("Loc",xLocID,""))'=""
			
			if $g(arrMapping("ID"))'="" {
				s ID=$g(arrMapping("ID"))
				s flg=##class(User.DHCHMCServiceClass).SaveDataToPowerControl(ID,xLocID,aUserID)
				if (+flg)<1 {
					s return=aTableName_" 表记录授权报错"
				}
			} else {
				//添加新记录，再授权
				s NewID=$i(^User.DHCHMCServiceClassD)
				s ^User.DHCHMCServiceClassD(NewID)=$g(^User.DHCHMCServiceClassD(xId))
				s ID=NewID
				s flg=##class(User.DHCHMCServiceClass).SaveDataToPowerControl(ID,xLocID,aUserID)
				if (+flg)<1 {
					s return=aTableName_" 表记录授权报错"
				}
				
				s xSub=0
				for {
					s xSub=$o(^User.DHCHMCServiceClassD(xId,"DHCHMCSCQLink",xSub))
					q:xSub=""
					
					s NewSub=$i(^User.DHCHMCServiceClassD("DHCHMCSCQLink"))
					s ^User.DHCHMCQuestionnaireD(NewID,"DHCHMCSCQLink",NewSub)=$g(^User.DHCHMCQuestionnaireD(xId,"QEDLink",xSub))
				}
			}
		}
	}
	Do ##class(User.DHCHMCServiceClass).%BuildIndices() //生成索引
	Do ##class(User.DHCHMCSCQLink).%BuildIndices() //生成索引
	
	q return
}

/// DHC_HM_CQuestionnaire---私有
/// DHC_HM_CQuestionSubject---私有
/// DHC_HM_CSDLink---私有
/// DHC_HM_CQEDLink---私有
ClassMethod toCQuestionnaire(aTableName As %String, aLGLocID As %String, aUserID As %String, aLocIDs As %String) As %String
{
    n (aTableName,aLGLocID,aUserID,aLocIDs)
    
    s objPowerType=##class(User.DHCHMCQuestionnaire).GetPowerTypeObj()
    q:'$IsObject(objPowerType) aTableName_" 未维护表登记授权管理数据"
	q:objPowerType.PTPowerType'="S" aTableName_" 未维护表登记授权管理数据"
	s PowerTableDR=objPowerType.%Id()
    
    s return=""
	s xId=0
	for {
		s xId=$o(^User.DHCHMCQuestionnaireD(xId))
		q:xId=""
		q:return'=""
		
		s ID=xId
		
		s rowData=$g(^User.DHCHMCQuestionnaireD(xId))
		continue:rowData=""
		s Code=$lg(rowData,3)
		s Type=$lg(rowData,6)
		
		k arrMapping
		s arrMapping("ID")=ID
		for idxLoc=1:1:$l(aLocIDs,","){
			s LocID=$p(aLocIDs,",",idxLoc)
			continue:LocID=""
			
			s arrMapping("Loc",LocID)=""
			s xNewID=0
			for {
				s xNewID=$o(^User.DHCHMCQuestionnaireI("TypeCodeIndex"," "_Type," "_Code,xNewID))
				q:xNewID=""
				
				s NewID=xNewID
				continue:##class(User.DHCHMCQuestionnaire).GetLocShowDataFlag(NewID,LocID)'="Y"
				s arrMapping("Loc",LocID,NewID)=""
				s:NewID=ID arrMapping("ID")=""
			}
		}
		
		s xLocID=0
		for {
			s xLocID=$o(arrMapping("Loc",xLocID))
			q:xLocID=""
			continue:$o(arrMapping("Loc",xLocID,""))'=""
			
			if $g(arrMapping("ID"))'="" {
				s ID=$g(arrMapping("ID"))
				s flg=##class(User.DHCHMCQuestionnaire).SaveDataToPowerControl(ID,xLocID,aUserID)
				if (+flg)<1 {
					s return=aTableName_" 表记录授权报错"
				}
			} else {
				//添加新记录，再授权
				s NewID=$i(^User.DHCHMCQuestionnaireD)
				s ^User.DHCHMCQuestionnaireD(NewID)=$g(^User.DHCHMCQuestionnaireD(xId))
				s ID=NewID
				s flg=##class(User.DHCHMCQuestionnaire).SaveDataToPowerControl(ID,xLocID,aUserID)
				if (+flg)<1 {
					s return=aTableName_" 表记录授权报错"
				}
				
				s xSub=0
				for {
					s xSub=$o(^User.DHCHMCQuestionnaireD(xId,"QSubject",xSub))
					q:xSub=""
					
					s NewSub=$i(^User.DHCHMCQuestionnaireC("QSubject"))
					s ^User.DHCHMCQuestionnaireD(NewID,"QSubject",NewSub)=$g(^User.DHCHMCQuestionnaireD(xId,"QSubject",xSub))
					
					s xChild=0
					for {
						s xChild=$o(^User.DHCHMCQuestionnaireD(xId,"QSubject",xSub,"QSDLink",xChild))
						q:xChild=""
						
						s NewChild=$i(^User.DHCHMCQuestionSubjectC("QSDLink"))
						s ^User.DHCHMCQuestionnaireD(NewID,"QSubject",NewSub,"QSDLink",NewChild)=$g(^User.DHCHMCQuestionnaireD(xId,"QSubject",xSub,"QSDLink",xChild))
					}
				}
				
				s xSub=0
				for {
					s xSub=$o(^User.DHCHMCQuestionnaireD(xId,"QEDLink",xSub))
					q:xSub=""
					
					s NewSub=$i(^User.DHCHMCQuestionnaireC("QEDLink"))
					s ^User.DHCHMCQuestionnaireD(NewID,"QEDLink",NewSub)=$g(^User.DHCHMCQuestionnaireD(xId,"QEDLink",xSub))
				}
			}
		}
	}
	Do ##class(User.DHCHMCQuestionnaire).%BuildIndices() //生成索引
	Do ##class(User.DHCHMCQuestionSubject).%BuildIndices() //生成索引
	Do ##class(User.DHCHMCSDLink).%BuildIndices() //生成索引
	Do ##class(User.DHCHMCQEDLink).%BuildIndices() //生成索引
	
	q return
}

/// DHC_PE_StationLoc  //站点分类---管控
ClassMethod toStationLoc(aTableName As %String, aLGLocID As %String, aUserID As %String, aLocIDs As %String) As %String
{
    n (aTableName,aLGLocID,aUserID,aLocIDs)
    
    s objPowerType=##class(User.DHCPEStationLoc).GetPowerTypeObj()
    q:'$IsObject(objPowerType) aTableName_" 未维护表登记授权管理数据"
	q:objPowerType.PTPowerType'="C" aTableName_" 未维护表登记授权管理数据"
	s PowerTableDR=objPowerType.%Id()
	
    s return=""
	s xParref=0
	for {
		s xParref=$o(^DHCPEST(xParref))
		q:xParref=""
		q:return'=""
		
		s xSub=0
		for {
			s xSub=$o(^DHCPEST(xParref,"STLOC",xSub))
			q:xSub=""
			
		    for idxLoc=1:1:$length(aLocIDs,",") {
			    s LocID=$p(aLocIDs,",",idxLoc)
			    continue:LocID=""
			    
			    s ID=xParref_"||"_xSub
				s flg=##class(User.DHCPEStation).SaveDataToPowerControl(ID,LocID,aUserID)
				if (+flg)<1 {
					s return=aTableName_" 表记录授权报错"
				}
		    }
		}
	}
	q return
}

/// DHC_PE_Station     //站点---管控
ClassMethod toStation(aTableName As %String, aLGLocID As %String, aUserID As %String, aLocIDs As %String) As %String
{
    n (aTableName,aLGLocID,aUserID,aLocIDs)
    
    s objPowerType=##class(User.DHCPEStation).GetPowerTypeObj()
    q:'$IsObject(objPowerType) aTableName_" 未维护表登记授权管理数据"
	q:objPowerType.PTPowerType'="C" aTableName_" 未维护表登记授权管理数据"
	s PowerTableDR=objPowerType.%Id()
	
    s return=""
	s xId=0
	for {
		s xId=$o(^DHCPEST(xId))
		q:xId=""
		q:return'=""
		
	    for idxLoc=1:1:$length(aLocIDs,",") {
		    s LocID=$p(aLocIDs,",",idxLoc)
		    continue:LocID=""
		    
		    s ID=xId
			s flg=##class(User.DHCPEStation).SaveDataToPowerControl(ID,LocID,aUserID)
			if (+flg)<1 {
				s return=aTableName_" 表记录授权报错"
			}
	    }
	}
	q return
}

/// DHC_PE_QMType---管控
ClassMethod toQMType(aTableName As %String, aLGLocID As %String, aUserID As %String, aLocIDs As %String) As %String
{
    n (aTableName,aLGLocID,aUserID,aLocIDs)
    
    s objPowerType=##class(User.DHCPEQMType).GetPowerTypeObj()
    q:'$IsObject(objPowerType) aTableName_" 未维护表登记授权管理数据"
	q:objPowerType.PTPowerType'="C" aTableName_" 未维护表登记授权管理数据"
	s PowerTableDR=objPowerType.%Id()
	
    s return=""
	s xId=0
	for {
		s xId=$o(^User.DHCPEQMTypeD(xId))
		q:xId=""
		q:return'=""
		
	    for idxLoc=1:1:$length(aLocIDs,",") {
		    s LocID=$p(aLocIDs,",",idxLoc)
		    continue:LocID=""
		    
		    s ID=xId
			s flg=##class(User.DHCPEQMType).SaveDataToPowerControl(ID,LocID,aUserID)
			if (+flg)<1 {
				s return=aTableName_" 表记录授权报错"
			}
	    }
	}
	q return
}

/// DHC_PE_NewMessageTemplet---新增字段，绝对私有
ClassMethod toNewMessageTemplet(aTableName As %String, aLGLocID As %String, aUserID As %String, aLocIDs As %String) As %String
{
    n (aTableName,aLGLocID,aUserID,aLocIDs)
    
    s objPowerType=##class(User.DHCPENewMessageTemplet).GetPowerTypeObj()
    q:'$IsObject(objPowerType) aTableName_" 未维护表登记授权管理数据"
	q:objPowerType.PTPowerType'="A" aTableName_" 未维护表登记授权管理数据"
	s PowerTableDR=objPowerType.%Id()
	
    s return=""
	s xId=0
	for {
		s xId=$o(^User.DHCPENewMessageTempletD(xId))
		q:xId=""
		q:return'=""
		
	    s obj=##class(User.DHCPENewMessageTemplet).%OpenId(xId)
		continue:'$IsObject(obj)
		s obj.NMTLocDR           = aLGLocID
		s obj.NMTUpdateDate      = +$h
		s obj.NMTUpdateTime      = $p($h,",",2)
		s obj.NMTUpdateUserDR    = aUserID
		s sc=obj.%Save()
		if $system.Status.IsError(sc) {        //检查Save是否成功
	   		d $system.OBJ.DisplayError(sc)
	   		s return=aTableName_" 新建表数据迁移报错"
	   		q
		}
		d obj.%Close()
		s ID=obj.%Id()
		
		s flg=##class(User.DHCPENewMessageTemplet).SaveDataToPowerControl(ID,aLGLocID,aUserID)
		if (+flg)<1 {
			s return=aTableName_" 表记录授权报错"
		}
	}
	q return
}

/// DHC_PE_LocVIPLevel---新建表，绝对私有
ClassMethod toLocVIPLevel(aTableName As %String, aLGLocID As %String, aUserID As %String, aLocIDs As %String) As %String
{
    n (aTableName,aLGLocID,aUserID,aLocIDs)
    
    s objPowerType=##class(User.DHCPELocVIPLevel).GetPowerTypeObj()
    q:'$IsObject(objPowerType) aTableName_" 未维护表登记授权管理数据"
	q:objPowerType.PTPowerType'="A" aTableName_" 未维护表登记授权管理数据"
	s PowerTableDR=objPowerType.%Id()
	
    //^DHCPEVIPLevel("VIP",id)= 级别^描述^保密^使用^默认^模板名称^体检类别^套餐编码（现不用）^体检号编码^csp模板（现不用）^默认套餐^指引单指示^指引单模板^问卷级别^总检类型^是否插队
	
    s return=""
	s xId=0
	for {
		s xId=$o(^DHCPEVIPLevel("VIP",xId))
		q:xId=""
		q:return'=""
		
	    for idxLoc=1:1:$length(aLocIDs,",") {
		    s LocID=$p(aLocIDs,",",idxLoc)
		    continue:LocID=""
		    
		    s ID=$o(^CF.PE.LocVIPLevelI("IdxOfLocVIP"," "_LocID,xId,0))
		    if ID="" {
				s obj=##class(User.DHCPELocVIPLevel).%New()
			} else {
				s obj=##class(User.DHCPELocVIPLevel).%OpenId(ID)
			}
			continue:'$IsObject(obj)
			
			s obj.LVLLocDR           = LocID
			d obj.LVLVIPLevelDRSetObjectId(xId)
			s obj.LVLSecret          = $p($g(^DHCPEVIPLevel("VIP",xId)),"^",3)
			s obj.LVLSecret          = $s(obj.LVLSecret["Y":"Y",1:"N")
			s obj.LVLDefale          = $p($g(^DHCPEVIPLevel("VIP",xId)),"^",5)
			s obj.LVLDefale          = $s(obj.LVLDefale["Y":"Y",1:"N")
			s obj.LVLTemplate        = $p($g(^DHCPEVIPLevel("VIP",xId)),"^",6)
			s obj.LVLFeeTypeDR       = $p($g(^DHCPEVIPLevel("VIP",xId)),"^",7)
			s obj.LVLOSCode          = $p($g(^DHCPEVIPLevel("VIP",xId)),"^",8)
			s obj.LVLHPCode          = $p($g(^DHCPEVIPLevel("VIP",xId)),"^",9)
			s obj.LVLCSPTemplate     = $p($g(^DHCPEVIPLevel("VIP",xId)),"^",10)
			s obj.LVLOrdSetsDR       = $p($g(^DHCPEVIPLevel("VIP",xId)),"^",11)
			s obj.LVLZYDInfo         = $p($g(^DHCPEVIPLevel("VIP",xId)),"^",12)
			s obj.LVLZYDTemplate     = $p($g(^DHCPEVIPLevel("VIP",xId)),"^",13)
			d obj.LVLHMServiceDRSetObjectId($p($g(^DHCPEVIPLevel("VIP",xId)),"^",14))
			s obj.LVLGeneralType     = $p($g(^DHCPEVIPLevel("VIP",xId)),"^",15)
			s obj.LVLCutInLine       = $p($g(^DHCPEVIPLevel("VIP",xId)),"^",16)
			s obj.LVLCutInLine       = $s(obj.LVLCutInLine=1:"Y",1:"N")
			s obj.LVLNoActive        = $p($g(^DHCPEVIPLevel("VIP",xId)),"^",4)
			s obj.LVLNoActive        = $s(obj.LVLNoActive["Y":"Y",1:"N")
			s obj.LVLUpdateDate      = +$h
			s obj.LVLUpdateTime      = $p($h,",",2)
			s obj.LVLUpdateUserDR    = aUserID
			
			s sc=obj.%Save()
			if $system.Status.IsError(sc) {        //检查Save是否成功
		   		d $system.OBJ.DisplayError(sc)
		   		s return=aTableName_" 新建表数据迁移报错"
		   		q
			}
			d obj.%Close()
			s ID=obj.%Id()
			
			s flg=##class(User.DHCPELocVIPLevel).SaveDataToPowerControl(ID,aLGLocID,aUserID)
			if (+flg)<1 {
				s return=aTableName_" 表记录授权报错"
			}
	    }
	}
	q return
}

/// DHC_PE_VIPLevel---新建表，公有
ClassMethod toVIPLevel(aTableName As %String, aLGLocID As %String, aUserID As %String, aLocIDs As %String) As %String
{
    n (aTableName,aLGLocID,aUserID,aLocIDs)
    
    s objPowerType=##class(User.DHCPEVIPLevel).GetPowerTypeObj()
    q:'$IsObject(objPowerType) aTableName_" 未维护表登记授权管理数据"
	q:objPowerType.PTPowerType'="G" aTableName_" 未维护表登记授权管理数据"
	s PowerTableDR=objPowerType.%Id()
    
    s return=""
	s xId=0
	for {
		s xId=$o(^DHCPEVIPLevel("VIP",xId))
		q:xId=""
		q:return'=""
		
		s Code=$p($g(^DHCPEVIPLevel("VIP",xId)),"^",1)
		s Desc=$p($g(^DHCPEVIPLevel("VIP",xId)),"^",2)
		s Active=$p($g(^DHCPEVIPLevel("VIP",xId)),"^",4)
		s ^CT.PE.VIPLevelD(xId)=$lb("",Code,Desc,Active,+$h,$p($h,",",2),aUserID)
		s ^CT.PE.VIPLevelD=$o(^CT.PE.VIPLevelD(""),-1)
	}
	q:return'="" return
	
	Do ##class(User.DHCPEVIPLevel).%BuildIndices() //生成索引
	q return
}

/// DHC_PE_RoomPlace--绝对私有
ClassMethod toRoomPlace(aTableName As %String, aLGLocID As %String, aUserID As %String, aLocIDs As %String) As %String
{
    n (aTableName,aLGLocID,aUserID,aLocIDs)
    
    s objPowerType=##class(User.DHCPERoomPlace).GetPowerTypeObj()
    q:'$IsObject(objPowerType) aTableName_" 未维护表登记授权管理数据"
	q:objPowerType.PTPowerType'="A" aTableName_" 未维护表登记授权管理数据"
	s PowerTableDR=objPowerType.%Id()
    
    s return=""
	s xId=0
	for {
		s xId=$o(^DHCPECTDataEx("RoomPlace",xId))
		q:xId=""
		q:return'=""
		
		s ID=xId
		s Code=$p($g(^DHCPECTDataEx("RoomPlace",xId)),"^",1)
		s Desc=$p($g(^DHCPECTDataEx("RoomPlace",xId)),"^",2)
		s VIPLevel=$p($g(^DHCPECTDataEx("RoomPlace",xId)),"^",3)
		s IsGroup=$p($g(^DHCPECTDataEx("RoomPlace",xId)),"^",4)
		s LocID=$p($g(^DHCPECTDataEx("RoomPlace",xId)),"^",5)
		s NotPrintBar=$p($g(^DHCPECTDataEx("RoomPlace",xId)),"^",6)
		s ^CF.PE.RoomPlaceD(xId)=$lb("",Code,Desc,VIPLevel,IsGroup,NotPrintBar,LocID,"Y",+$h,$p($h,",",2),aUserID)
		s ^CF.PE.RoomPlaceD=$o(^CF.PE.RoomPlaceD(""),-1)
		
		s flg=##class(User.DHCPERoomPlace).SaveDataToPowerControl(ID,LocID,aUserID)
		if (+flg)<1 {
			s return=aTableName_" 表记录授权报错"
		}
	}
	q:return'="" return
	
	d ##class(User.DHCPERoomPlace).%BuildIndices()
	q return
}

/// DHC_PE_Area--绝对私有
ClassMethod toArea(aTableName As %String, aLGLocID As %String, aUserID As %String, aLocIDs As %String) As %String
{
    n (aTableName,aLGLocID,aUserID,aLocIDs)
    
    s objPowerType=##class(User.DHCPEArea).GetPowerTypeObj()
    q:'$IsObject(objPowerType) aTableName_" 未维护表登记授权管理数据"
	q:objPowerType.PTPowerType'="A" aTableName_" 未维护表登记授权管理数据"
	s PowerTableDR=objPowerType.%Id()
    
    s return=""
	s xId=0
	for {
		s xId=$o(^User.DHCPEAreaD(xId))
		q:xId=""
		q:return'=""
		
		s objArea=##class(User.DHCPEArea).%OpenId(xId)
		continue:'$IsObject(objArea)
		d objArea.%Close()
		s LocID=objArea.ALocDR
		continue:LocID=""
		
		s ID=xId
		s flg=##class(User.DHCPEArea).SaveDataToPowerControl(ID,LocID,aUserID)
		if (+flg)<1 {
			s return=aTableName_" 表记录授权报错"
		}
	}
	q return
}

/// DHC_PE_WorkDoctor---私有
ClassMethod toWorkDoctor(aTableName As %String, aLGLocID As %String, aUserID As %String, aLocIDs As %String) As %String
{
    n (aTableName,aLGLocID,aUserID,aLocIDs)
    
    s objPowerType=##class(User.DHCPEWorkDoctor).GetPowerTypeObj()
    q:'$IsObject(objPowerType) aTableName_" 未维护表登记授权管理数据"
	q:objPowerType.PTPowerType'="S" aTableName_" 未维护表登记授权管理数据"
	s PowerTableDR=objPowerType.%Id()
    
    s return=""
	s xId=0
	for {
		s xId=$o(^User.DHCPEWorkDistributeTypeD(xId))
		q:xId=""
		q:return'=""
		
		s xSub=""
		for {
			s xSub=$o(^User.DHCPEWorkDistributeTypeD(xId,"WDTDoctor",xSub))
			q:xSub=""
			
			s ID=xId_"||"_xSub
			s flg=##class(User.DHCPEWorkDoctor).SaveDataToPowerControl(ID,aLGLocID,aUserID)
			if (+flg)<1 {
				s return=aTableName_" 表记录授权报错"
			}
		}	
	}
	q return
}

/// DHC_PE_WorkLinkUrl---管控
ClassMethod toWorkLinkUrl(aTableName As %String, aLGLocID As %String, aUserID As %String, aLocIDs As %String) As %String
{
    n (aTableName,aLGLocID,aUserID,aLocIDs)
    
    s objPowerType=##class(User.DHCPEWorkLinkUrl).GetPowerTypeObj()
    q:'$IsObject(objPowerType) aTableName_" 未维护表登记授权管理数据"
	q:objPowerType.PTPowerType'="C" aTableName_" 未维护表登记授权管理数据"
	s PowerTableDR=objPowerType.%Id()
    
    s return=""
	s xId=0
	for {
		s xId=$o(^User.DHCPEWorkDistributeTypeD(xId))
		q:xId=""
		q:return'=""
		
		s xSub=""
		for {
			s xSub=$o(^User.DHCPEWorkDistributeTypeD(xId,"WDTWUrl",xSub))
			q:xSub=""
			
		    for idxLoc=1:1:$length(aLocIDs,",") {
			    s LocID=$p(aLocIDs,",",idxLoc)
			    continue:LocID=""
			    
				s ID=xId_"||"_xSub
				s flg=##class(User.DHCPEWorkLinkUrl).SaveDataToPowerControl(ID,LocID,aUserID)
				if (+flg)<1 {
					s return=aTableName_" 表记录授权报错"
				}
		    }
		}	
	}
	q return
}

/// DHC_PE_WorkDistributeType---管控
ClassMethod toWorkDistributeType(aTableName As %String, aLGLocID As %String, aUserID As %String, aLocIDs As %String) As %String
{
    n (aTableName,aLGLocID,aUserID,aLocIDs)
    
    s objPowerType=##class(User.DHCPEWorkDistributeType).GetPowerTypeObj()
    q:'$IsObject(objPowerType) aTableName_" 未维护表登记授权管理数据"
	q:objPowerType.PTPowerType'="C" aTableName_" 未维护表登记授权管理数据"
	s PowerTableDR=objPowerType.%Id()
    
    s return=""
	s xId=0
	for {
		s xId=$o(^User.DHCPEWorkDistributeTypeD(xId))
		q:xId=""
		q:return'=""
		
	    for idxLoc=1:1:$length(aLocIDs,",") {
		    s LocID=$p(aLocIDs,",",idxLoc)
		    continue:LocID=""
		    
			s ID=xId
			s flg=##class(User.DHCPEWorkDistributeType).SaveDataToPowerControl(ID,LocID,aUserID)
			if (+flg)<1 {
				s return=aTableName_" 表记录授权报错"
			}
	    }
	}
	q return
}

/// DHC_PE_OthPatToHPBase---新建表，绝对私有
ClassMethod toOthPatToHPBase(aTableName As %String, aLGLocID As %String, aUserID As %String, aLocIDs As %String) As %String
{
    n (aTableName,aLGLocID,aUserID,aLocIDs)
    
    s objPowerType=##class(User.DHCPEOthPatToHPBase).GetPowerTypeObj()
    q:'$IsObject(objPowerType) aTableName_" 未维护表登记授权管理数据"
	q:objPowerType.PTPowerType'="A" aTableName_" 未维护表登记授权管理数据"
	s PowerTableDR=objPowerType.%Id()
	
    s return=""
    s xLocId=""
    for {
	    s xLocId=$o(^DHCPEOtherPatientToHPBase("GenConUser",xLocId))
	    q:xLocId=""
	    
	    s UserId=$g(^DHCPEOtherPatientToHPBase("GenConUser",xLocId))
	    continue:UserId=""
	    s ID=$o(^CF.PE.OthPatToHPBaseI("IdxOfLocHPBUser"," "_xLocId," "_UserId,0))
	    if ID="" {
			s obj=##class(User.DHCPEOthPatToHPBase).%New()
		} else {
			s obj=##class(User.DHCPEOthPatToHPBase).%OpenId(ID)
		}
		continue:'$IsObject(obj)
		
		s obj.HPBLocDR           = xLocId
		d obj.HPBStationDRSetObjectId("")
		s obj.HPBRecLocDR        = ""
		s obj.HPBRecDocDR        = ""
		s obj.HPBHPBUserDR       = UserId
		s obj.HPBHPBItemDR       = $g(^DHCPEOtherPatientToHPBase("ConOrderDefault",xLocId))
		s obj.HPBCarPrvTpDR      = ""
		s obj.HPBNoActive        = "Y"
		s obj.HPBUpdateDate      = +$h
		s obj.HPBUpdateTime      = $p($h,",",2)
		s obj.HPBUpdateUserDR    = aUserID
		s sc=obj.%Save()
		if $system.Status.IsError(sc) {        //检查Save是否成功
	   		d $system.OBJ.DisplayError(sc)
	   		s return=aTableName_" 新建表数据迁移报错"
	   		q
		}
		d obj.%Close()
		s ID=obj.%Id()
		
		s flg=##class(User.DHCPEOthPatToHPBase).SaveDataToPowerControl(ID,xLocId,aUserID)
		if (+flg)<1 {
			s return=aTableName_" 表记录授权报错"
		}
	}
	q:return'="" return
	
    s return=""
    s xLocId=""
    for {
	    s xLocId=$o(^DHCPEOtherPatientToHPBase("ConRecLoc",xLocId))
	    q:xLocId=""
	    
	    s xStationId=""
	    for {
		    s xStationId=$o(^DHCPEOtherPatientToHPBase("ConRecLoc",xLocId,xStationId))
		    q:xStationId=""
		    
		    s ID=$o(^CF.PE.OthPatToHPBaseI("IdxOfLocStation"," "_xLocId,xStationId,0))
		    if ID="" {
				s obj=##class(User.DHCPEOthPatToHPBase).%New()
			} else {
				s obj=##class(User.DHCPEOthPatToHPBase).%OpenId(ID)
			}
			continue:'$IsObject(obj)
			
			s obj.HPBLocDR           = xLocId
			d obj.HPBStationDRSetObjectId(xStationId)
			s obj.HPBRecLocDR        = $p($g(^DHCPEOtherPatientToHPBase("ConRecLoc",xLocId,xStationId)),"^",1)
			s obj.HPBRecDocDR        = $p($g(^DHCPEOtherPatientToHPBase("ConRecLoc",xLocId,xStationId)),"^",2)
			s obj.HPBHPBUserDR       = ""
			s obj.HPBHPBItemDR       = ""
			s obj.HPBCarPrvTpDR      = ""
			s obj.HPBNoActive        = "Y"
			s obj.HPBUpdateDate      = +$h
			s obj.HPBUpdateTime      = $p($h,",",2)
			s obj.HPBUpdateUserDR    = aUserID
			s sc=obj.%Save()
			if $system.Status.IsError(sc) {        //检查Save是否成功
		   		d $system.OBJ.DisplayError(sc)
		   		s return=aTableName_" 新建表数据迁移报错"
		   		q
			}
			d obj.%Close()
			s ID=obj.%Id()
			
			s flg=##class(User.DHCPEOthPatToHPBase).SaveDataToPowerControl(ID,xLocId,aUserID)
			if (+flg)<1 {
				s return=aTableName_" 表记录授权报错"
			}
		}
	}
	q:return'="" return
	
    s return=""
    s xLocId=""
    for {
	    s xLocId=$o(^DHCPEOtherPatientToHPBase("CarPrvTpConOrder",xLocId))
	    q:xLocId=""
	    
	    s xCarPrvTpId=""
	    for {
		    s xCarPrvTpId=$o(^DHCPEOtherPatientToHPBase("CarPrvTpConOrder",xLocId,xCarPrvTpId))
		    q:xCarPrvTpId=""
		    
		    s ID=$o(^CF.PE.OthPatToHPBaseI("IdxOfLocCarPrvTp"," "_xLocId," "_xCarPrvTpId,0))
		    if ID="" {
				s obj=##class(User.DHCPEOthPatToHPBase).%New()
			} else {
				s obj=##class(User.DHCPEOthPatToHPBase).%OpenId(ID)
			}
			continue:'$IsObject(obj)
			
			s obj.HPBLocDR           = xLocId
			d obj.HPBStationDRSetObjectId("")
			s obj.HPBRecLocDR        = ""
			s obj.HPBRecDocDR        = ""
			s obj.HPBHPBUserDR       = ""
			s obj.HPBHPBItemDR       = $g(^DHCPEOtherPatientToHPBase("CarPrvTpConOrder",xLocId,xCarPrvTpId))
			s obj.HPBCarPrvTpDR      = xCarPrvTpId
			s obj.HPBNoActive        = "Y"
			s obj.HPBUpdateDate      = +$h
			s obj.HPBUpdateTime      = $p($h,",",2)
			s obj.HPBUpdateUserDR    = aUserID
			s sc=obj.%Save()
			if $system.Status.IsError(sc) {        //检查Save是否成功
		   		d $system.OBJ.DisplayError(sc)
		   		s return=aTableName_" 新建表数据迁移报错"
		   		q
			}
			d obj.%Close()
			s ID=obj.%Id()
			
			s flg=##class(User.DHCPEOthPatToHPBase).SaveDataToPowerControl(ID,aLGLocID,aUserID)
			if (+flg)<1 {
				s return=aTableName_" 表记录授权报错"
			}
		}
	}
	
	q return
}

/// DHC_PE_SpecialContral---新建表，绝对私有
ClassMethod toSpecialContral(aTableName As %String, aLGLocID As %String, aUserID As %String, aLocIDs As %String) As %String
{
    n (aTableName,aLGLocID,aUserID,aLocIDs)
    
    s objPowerType=##class(User.DHCPESpecialContral).GetPowerTypeObj()
    q:'$IsObject(objPowerType) aTableName_" 未维护表登记授权管理数据"
	q:objPowerType.PTPowerType'="A" aTableName_" 未维护表登记授权管理数据"
	s PowerTableDR=objPowerType.%Id()
	
    s return=""
    s xUserId=""
    for {
	    s xUserId=$o(^DHCPESpecialContral("DHCPEXH",xUserId))
	    q:xUserId=""
	    
	    s xItemId=""
	    for {
		    s xItemId=$o(^DHCPESpecialContral("DHCPEXH",xUserId,xItemId))
		    q:xItemId=""
		    
		    s ARCIMID=xItemId
			s StationId=$o(^DHCPEST(0,"STORD_ARCIM",ARCIMID,0))
			continue:StationId=""
			s STOrderSub=$o(^DHCPEST(0,"STORD_ARCIM",ARCIMID,StationId,0))
			continue:STOrderSub=""
			s STOrderID=StationId_"||"_STOrderSub
			
			//科室站点项目-授权科室
			s LocPowerList=""
			s xLoc=0
			for {
				s xLoc=$o(^CF.PE.StationOrderSetI("IdxOfLocOrder",xLoc))
				q:xLoc=""
				continue:'$d(^CF.PE.StationOrderSetI("IdxOfLocOrder",xLoc,STOrderID))
				s LocPowerList=LocPowerList_$lb(xLoc)
			}
			
			for idxLoc=1:1:$ll(LocPowerList) {
				s LocID=$lg(LocPowerList,idxLoc)
				continue:LocID=""
				
			    s ID=$o(^CF.PE.SpecialContralI("IdxOfLocUserOrder"," "_LocID," "_xUserId,STOrderID,0))
			    if ID="" {
					s obj=##class(User.DHCPESpecialContral).%New()
				} else {
					s obj=##class(User.DHCPESpecialContral).%OpenId(ID)
				}
				continue:'$IsObject(obj)
				
				s obj.SCLocDR            = LocID
				s obj.SCUserDR           = xUserId
				d obj.SCOrderDRSetObjectId(STOrderID)
				s obj.SCNoActive         = "Y"
				s obj.SCUpdateDate       = +$h
				s obj.SCUpdateTime       = $p($h,",",2)
				s obj.SCUpdateUserDR     = aUserID
				s sc=obj.%Save()
				if $system.Status.IsError(sc) {        //检查Save是否成功
			   		d $system.OBJ.DisplayError(sc)
			   		s return=aTableName_" 新建表数据迁移报错"
			   		q
				}
				d obj.%Close()
				s ID=obj.%Id()
				
				s flg=##class(User.DHCPESpecialContral).SaveDataToPowerControl(ID,LocID,aUserID)
				if (+flg)<1 {
					s return=aTableName_" 表记录授权报错"
				}
			}
		}
	}
	
	q return
}

/// DHC_PE_ChargeLimit---新建表，绝对私有
ClassMethod toChargeLimit(aTableName As %String, aLGLocID As %String, aUserID As %String, aLocIDs As %String) As %String
{
    n (aTableName,aLGLocID,aUserID,aLocIDs)
    
    s objPowerType=##class(User.DHCPEChargeLimit).GetPowerTypeObj()
    q:'$IsObject(objPowerType) aTableName_" 未维护表登记授权管理数据"
	q:objPowerType.PTPowerType'="A" aTableName_" 未维护表登记授权管理数据"
	s PowerTableDR=objPowerType.%Id()
	
	s UserList=""
	s xUser=""
	for {
		s xUser=$o(^DHCPECFDataEx("DHCPEBaseData","OPChargeLimit","DF",xUser))
		q:xUser=""
		
		continue:$listfind(UserList,xUser)>0
		s UserList=UserList_$lb(xUser)
	}
	s xUser=""
	for {
		s xUser=$o(^DHCPECFDataEx("DHCPEBaseData","OPChargeLimit","OPFlag",xUser))
		q:xUser=""
		
		continue:$listfind(UserList,xUser)>0
		s UserList=UserList_$lb(xUser)
	}
	s xUser=""
	for {
		s xUser=$o(^DHCPECFDataEx("DHCPEBaseData","OPChargeLimit","ASChargedFlag",xUser))
		q:xUser=""
		
		continue:$listfind(UserList,xUser)>0
		s UserList=UserList_$lb(xUser)
	}
	s xUser=""
	for {
		s xUser=$o(^DHCPESetting("DHCPE","RoundingFeeMode",xUser))
		q:xUser=""
		
		continue:$listfind(UserList,xUser)>0
		s UserList=UserList_$lb(xUser)
	}
	
    s return=""
    for idxLoc=1:1:$l(aLocIDs,",") {
	    s LocID=$p(aLocIDs,",",idxLoc)
	    continue:LocID=""
	    
	    for idxUser=1:1:$ll(UserList){
			s xUserId=$lg(UserList,idxUser)
			continue:xUserId=""
			
			s ID=$o(^CF.PE.ChargeLimitI("IdxOfLocUser"," "_LocID," "_xUserId,0))
			if ID="" {
				s obj=##class(User.DHCPEChargeLimit).%New()
			} else {
				s obj=##class(User.DHCPEChargeLimit).%OpenId(ID)
			}
			continue:'$IsObject(obj)
			
			s obj.CLLocDR            = LocID
			s obj.CLUserDR           = xUserId
			s obj.CLChargeLimit      = +$g(^DHCPECFDataEx("DHCPEBaseData","OPChargeLimit","DF",xUserId))
			s obj.CLOPFlag           = $g(^DHCPECFDataEx("DHCPEBaseData","OPChargeLimit","OPFlag",xUserId))
			s obj.CLOPFlag           = $s(obj.CLOPFlag["Y":"Y",1:"N")
			s obj.CLASChargedFlag    = $g(^DHCPECFDataEx("DHCPEBaseData","OPChargeLimit","ASChargedFlag",xUserId))
			s obj.CLASChargedFlag    = $s(obj.CLASChargedFlag["Y":"Y",1:"N")
			s obj.CLOPChargeLimit    = ""
			s obj.CLRoundingFeeMode  = +$g(^DHCPESetting("DHCPE","RoundingFeeMode",xUserId))
			s obj.CLNoActive         = "Y"
			s obj.CLUpdateDate       = +$h
			s obj.CLUpdateTime       = $p($h,",",2)
			s obj.CLUpdateUserDR     = aUserID
			s sc=obj.%Save()
			if $system.Status.IsError(sc) {        //检查Save是否成功
		   		d $system.OBJ.DisplayError(sc)
		   		s return=aTableName_" 新建表数据迁移报错"
			   	q
			}
			d obj.%Close()
			s ID=obj.%Id()
			
			s flg=##class(User.DHCPEChargeLimit).SaveDataToPowerControl(ID,LocID,aUserID)
			if (+flg)<1 {
				s return=aTableName_" 表记录授权报错"
			}
	    }
	}
    
	q return
}

/// DHC_PE_ChartAssignDtl---新建表，绝对私有
ClassMethod toChartAssignDtl(aTableName As %String, aLGLocID As %String, aUserID As %String, aLocIDs As %String) As %String
{
    n (aTableName,aLGLocID,aUserID,aLocIDs)
    
    s objPowerType=##class(User.DHCPEChartAssignDtl).GetPowerTypeObj()
    q:'$IsObject(objPowerType) aTableName_" 未维护表登记授权管理数据"
	q:objPowerType.PTPowerType'="A" aTableName_" 未维护表登记授权管理数据"
	s PowerTableDR=objPowerType.%Id()
	
    s return=""
	s xUserId=0
	for {
		s xUserId=$o(^DHCPECFDataEx("ChartAssign",xUserId))
		q:xUserId=""
		q:return'=""
		
		s xLocId=0
		for {
			s xLocId=$o(^DHCPECFDataEx("ChartAssign",xUserId,xLocId))
			q:xLocId=""
			
			s xGrpId=0
			for {
				s xGrpId=$o(^DHCPECFDataEx("ChartAssign",xUserId,xLocId,xGrpId))
				q:xGrpId=""
				
				s ChartAssignId=$o(^CF.PE.ChartAssignI("IdxOfLocDocSSGrp"," "_xLocId," "_xUserId," "_xGrpId,0))
				continue:ChartAssignId=""
				
				s xStationId=0
				for {
					s xStationId=$o(^DHCPEST(xStationId))
					q:xStationId=""
					
					s Sub=$o(^CF.PE.ChartAssignI("DTL","IdxOfStation",ChartAssignId,xStationId,0))
					if Sub="" {
						s obj=##class(User.DHCPEChartAssignDtl).%New()
					} else {
						s obj=##class(User.DHCPEChartAssignDtl).%OpenId(ChartAssignId_"||"_Sub)
					}
					continue:'$IsObject(obj)
					
					d obj.ParRefSetObjectId(ChartAssignId)
					d obj.CADStationDRSetObjectId(xStationId)
					s obj.CADDetail          = $g(^DHCPECFDataEx("ChartAssign",xUserId,xLocId,xGrpId,"Detail",xStationId))
					s obj.CADDetail          = $s(obj.CADDetail="1":"Y",obj.CADDetail=0:"N",1:obj.CADDetail)
					s obj.CADWrite           = $g(^DHCPECFDataEx("ChartAssign",xUserId,xLocId,xGrpId,"Write",xStationId))
					s obj.CADWrite           = $s(obj.CADWrite="1":"Y",obj.CADWrite=0:"N",1:obj.CADWrite)
					s obj.CADDefault         = $g(^DHCPECFDataEx("ChartAssign",xUserId,xLocId,xGrpId,"Default",xStationId))
					s obj.CADDefault         = $s(obj.CADDefault="1":"Y",obj.CADDefault=0:"N",1:obj.CADDefault)
					s obj.CADWriteWay        = $g(^DHCPECFDataEx("ChartAssign",xUserId,xLocId,xGrpId,"WriteWay",ChartAssignId))
					s sc=obj.%Save()
					if $system.Status.IsError(sc) {        //检查Save是否成功
				   		d $system.OBJ.DisplayError(sc)
				   		s return=aTableName_" 新建表数据迁移报错"
				   		q
					}
					d obj.%Close()
					s ID=obj.%Id()
					
					s flg=##class(User.DHCPEChartAssignDtl).SaveDataToPowerControl(ID,xLocId,aUserID)
					if (+flg)<1 {
						s return=aTableName_" 表记录授权报错"
					}
				}
			}
		}
	}
	q return
}

/// DHC_PE_ChartAssign---新建表，绝对私有
ClassMethod toChartAssign(aTableName As %String, aLGLocID As %String, aUserID As %String, aLocIDs As %String) As %String
{
    n (aTableName,aLGLocID,aUserID,aLocIDs)
    
    s objPowerType=##class(User.DHCPEChartAssign).GetPowerTypeObj()
    q:'$IsObject(objPowerType) aTableName_" 未维护表登记授权管理数据"
	q:objPowerType.PTPowerType'="A" aTableName_" 未维护表登记授权管理数据"
	s PowerTableDR=objPowerType.%Id()
	
    s return=""
	s xUserId=0
	for {
		s xUserId=$o(^DHCPECFDataEx("ChartAssign",xUserId))
		q:xUserId=""
		q:return'=""
		
		s xLocId=0
		for {
			s xLocId=$o(^DHCPECFDataEx("ChartAssign",xUserId,xLocId))
			q:xLocId=""
			
			s xGrpId=0
			for {
				s xGrpId=$o(^DHCPECFDataEx("ChartAssign",xUserId,xLocId,xGrpId))
				q:xGrpId=""
				
				s ID=$o(^CF.PE.ChartAssignI("IdxOfLocDocSSGrp"," "_xLocId," "_xUserId," "_xGrpId,0))
				if ID="" {
					s obj=##class(User.DHCPEChartAssign).%New()
				} else {
					s obj=##class(User.DHCPEChartAssign).%OpenId(ID)
				}
				continue:'$IsObject(obj)
				
				s obj.CALocDR            = xLocId
				s obj.CADocDR            = xUserId
				s obj.CASSGrpDR          = xGrpId
				s obj.CAInDoc            = $g(^DHCPEOtherPatientToHPBase("InDoc",xLocId,xUserId))  //因科室医生对应不上，标志没迁移过来
				s obj.CANoActive         = "Y"
				s obj.CAUpdateDate       = +$p($g(^DHCPECFDataEx("ChartAssign",xUserId,xLocId,xGrpId)),"^",2)
				s obj.CAUpdateTime       = 1
				s obj.CAUpdateUserDR     = $p($g(^DHCPECFDataEx("ChartAssign",xUserId,xLocId,xGrpId)),"^",1)
				s sc=obj.%Save()
				if $system.Status.IsError(sc) {        //检查Save是否成功
			   		d $system.OBJ.DisplayError(sc)
			   		s return=aTableName_" 新建表数据迁移报错"
			   		q
				}
				d obj.%Close()
				s ID=obj.%Id()
				
				s flg=##class(User.DHCPEChartAssign).SaveDataToPowerControl(ID,xLocId,aUserID)
				if (+flg)<1 {
					s return=aTableName_" 表记录授权报错"
				}
			}
		}
	}
	q:return'="" return
	
	s xLocId=0
	for {
		s xLocId=$o(^DHCPEOtherPatientToHPBase("InDoc",xLocId))
		q:xLocId=""
		q:return'=""
		
		s xUserId=0
		for {
			s xUserId=$o(^DHCPEOtherPatientToHPBase("InDoc",xLocId,xUserId))
			q:xUserId=""
			
			if '$d(^CF.PE.ChartAssignI("IdxOfLocDocSSGrp"," "_xLocId," "_xUserId)) {
				s xGrpId=""
				
				s ID=$o(^CF.PE.ChartAssignI("IdxOfLocDocSSGrp"," "_xLocId," "_xUserId," "_xGrpId,0))
				if ID="" {
					s obj=##class(User.DHCPEChartAssign).%New()
				} else {
					s obj=##class(User.DHCPEChartAssign).%OpenId(ID)
				}
				continue:'$IsObject(obj)
				
				s obj.CALocDR            = xLocId
				s obj.CADocDR            = xUserId
				s obj.CASSGrpDR          = xGrpId
				s obj.CAInDoc            = $g(^DHCPEOtherPatientToHPBase("InDoc",xLocId,xUserId))  //因科室医生对应不上，标志没迁移过来
				s obj.CANoActive         = "Y"
				s obj.CAUpdateDate       = +$h
				s obj.CAUpdateTime       = $p($h,",",2)
				s obj.CAUpdateUserDR     = aUserID
				s sc=obj.%Save()
				if $system.Status.IsError(sc) {        //检查Save是否成功
			   		d $system.OBJ.DisplayError(sc)
			   		s return=aTableName_" 新建表数据迁移报错"
			   		q
				}
				d obj.%Close()
				s ID=obj.%Id()
				
				s flg=##class(User.DHCPEChartAssign).SaveDataToPowerControl(ID,xLocId,aUserID)
				if (+flg)<1 {
					s return=aTableName_" 表记录授权报错"
				}
			}
		}
	}
	q return
}

/// DHC_PE_IEPrice---绝对私有
ClassMethod toIEPrice(aTableName As %String, aLGLocID As %String, aUserID As %String, aLocIDs As %String) As %String
{
    n (aTableName,aLGLocID,aUserID,aLocIDs)
    
    s objPowerType=##class(User.DHCPEIEPrice).GetPowerTypeObj()
    q:'$IsObject(objPowerType) aTableName_" 未维护表登记授权管理数据"
	q:objPowerType.PTPowerType'="A" aTableName_" 未维护表登记授权管理数据"
	s PowerTableDR=objPowerType.%Id()
    
    s return=""
	s xId=0
	for {
		s xId=$o(^DHCPEIE(xId))
		q:xId=""
		q:return'=""
		
		s xSub=0
		for {
			s xSub=$o(^DHCPEIE(xId,"P",xSub))
			q:xSub=""
			
			s ID=xId_"||"_xSub
			
			s objIEP=##class(User.DHCPEIEPrice).%OpenId(ID)
			continue:'$IsObject(objIEP)
			d objIEP.%Close()
			s LocID=objIEP.PLocDR
			continue:LocID=""
			
			s flg=##class(User.DHCPEIEPrice).SaveDataToPowerControl(ID,LocID,aUserID)
			if (+flg)<1 {
				s return=aTableName_" 表记录授权报错"
			}
		}
	}
	q return
}

/// DHC_PE_IESendItem---绝对私有
ClassMethod toIESendItem(aTableName As %String, aLGLocID As %String, aUserID As %String, aLocIDs As %String) As %String
{
    n (aTableName,aLGLocID,aUserID,aLocIDs)
    
    s objPowerType=##class(User.DHCPEIESendItem).GetPowerTypeObj()
    q:'$IsObject(objPowerType) aTableName_" 未维护表登记授权管理数据"
	q:objPowerType.PTPowerType'="A" aTableName_" 未维护表登记授权管理数据"
	s PowerTableDR=objPowerType.%Id()
    
    s return=""
	s xId=0
	for {
		s xId=$o(^DHCPEIE(xId))
		q:xId=""
		q:return'=""
		
		s xSub=0
		for {
			s xSub=$o(^DHCPEIE(xId,"SI",xSub))
			q:xSub=""
			
			s ID=xId_"||"_xSub
			
			s objIESI=##class(User.DHCPEIESendItem).%OpenId(ID)
			continue:'$IsObject(objIESI)
			d objIESI.%Close()
			s LocID=objIESI.SILocDR
			continue:LocID=""
			
			s flg=##class(User.DHCPEIESendItem).SaveDataToPowerControl(ID,LocID,aUserID)
			if (+flg)<1 {
				s return=aTableName_" 表记录授权报错"
			}
		}
	}
	q return
}

/// DHC_PE_ItemExtend---私有
ClassMethod toItemExtend(aTableName As %String, aLGLocID As %String, aUserID As %String, aLocIDs As %String) As %String
{
    n (aTableName,aLGLocID,aUserID,aLocIDs)
    
    s objPowerType=##class(User.DHCPEItemExtend).GetPowerTypeObj()
    q:'$IsObject(objPowerType) aTableName_" 未维护表登记授权管理数据"
	q:objPowerType.PTPowerType'="S" aTableName_" 未维护表登记授权管理数据"
	s PowerTableDR=objPowerType.%Id()
    
    s return=""
	s xId=0
	for {
		s xId=$o(^DHCPEIE(xId))
		q:xId=""
		q:return'=""
		
		s objItemExtend=##class(User.DHCPEItemExtend).%OpenId(xId)
		continue:'$IsObject(objItemExtend)
		d objItemExtend.%Close()
		s ARCIMID=objItemExtend.IEARCIMDR
		continue:ARCIMID=""
		
		s StationId=$o(^DHCPEST(0,"STORD_ARCIM",ARCIMID,0))
		continue:StationId=""
		s STOrderSub=$o(^DHCPEST(0,"STORD_ARCIM",ARCIMID,StationId,0))
		continue:STOrderSub=""
		s STOrderID=StationId_"||"_STOrderSub
		
		s ID=xId
		s obj=##class(User.DHCPEItemExtend).%OpenId(ID)
		continue:'$IsObject(obj)
		d obj.IEOrderDRSetObjectId(STOrderID)
		s sc=obj.%Save()
		if $system.Status.IsError(sc) {        //检查Save是否成功
	   		d $system.OBJ.DisplayError(sc)
	   		s return=aTableName_" 新建表数据迁移报错"
	   		q
		}
		d obj.%Close()
		s ID=obj.%Id()
		
		s flg=##class(User.DHCPEItemExtend).SaveDataToPowerControl(ID,aLGLocID,aUserID)
		if (+flg)<1 {
			s return=aTableName_" 表记录授权报错"
		}
	}
	q return
}

/// DHC_PE_NetOrdSets--绝对私有
ClassMethod toNetOrdSets(aTableName As %String, aLGLocID As %String, aUserID As %String, aLocIDs As %String) As %String
{
    n (aTableName,aLGLocID,aUserID,aLocIDs)
    
    s objPowerType=##class(User.DHCPENetOrdSets).GetPowerTypeObj()
    q:'$IsObject(objPowerType) aTableName_" 未维护表登记授权管理数据"
	q:objPowerType.PTPowerType'="A" aTableName_" 未维护表登记授权管理数据"
	s PowerTableDR=objPowerType.%Id()
    
    s return=""
	s xId=0
	for {
		s xId=$o(^User.DHCPENetOrdSetsD(xId))
		q:xId=""
		q:return'=""
		
		s objNetOrdSets=##class(User.DHCPENetOrdSets).%OpenId(xId)
		continue:'$IsObject(objNetOrdSets)
		d objNetOrdSets.%Close()
		s LocID=objNetOrdSets.NOSLocID
		continue:LocID=""
		
		s ID=xId
		s flg=##class(User.DHCPENetOrdSets).SaveDataToPowerControl(ID,LocID,aUserID)
		if (+flg)<1 {
			s return=aTableName_" 表记录授权报错"
		}
	}
	q return
}

/// DHC_PE_NetItemType--私有
ClassMethod toNetItemType(aTableName As %String, aLGLocID As %String, aUserID As %String, aLocIDs As %String) As %String
{
    n (aTableName,aLGLocID,aUserID,aLocIDs)
    
    s objPowerType=##class(User.DHCPENetItemType).GetPowerTypeObj()
    q:'$IsObject(objPowerType) aTableName_" 未维护表登记授权管理数据"
	q:objPowerType.PTPowerType'="S" aTableName_" 未维护表登记授权管理数据"
	s PowerTableDR=objPowerType.%Id()
    
    s return=""
	s xId=0
	for {
		s xId=$o(^User.DHCPENetItemTypeD(xId))
		q:xId=""
		q:return'=""
		
		s ID=xId
		s flg=##class(User.DHCPENetItemType).SaveDataToPowerControl(ID,aLGLocID,aUserID)
		if (+flg)<1 {
			s return=aTableName_" 表记录授权报错"
		}
	}
	q return
}

/// DHC_PE_OrdSetsEx--绝对私有
ClassMethod toOrdSetsEx(aTableName As %String, aLGLocID As %String, aUserID As %String, aLocIDs As %String) As %String
{
    n (aTableName,aLGLocID,aUserID,aLocIDs)
    
    s objPowerType=##class(User.DHCPEOrdSetsEx).GetPowerTypeObj()
    q:'$IsObject(objPowerType) aTableName_" 未维护表登记授权管理数据"
	q:objPowerType.PTPowerType'="A" aTableName_" 未维护表登记授权管理数据"
	s PowerTableDR=objPowerType.%Id()
    
    s return=""
	s xId=0
	for {
		s xId=$o(^DHCPEOSE(xId))
		q:xId=""
		q:return'=""
		
		s obj=##class(User.DHCPEOrdSetsEx).%OpenId(xId)
		continue:'$IsObject(obj)
		d obj.%Close()
		s LocIDStr=obj.OSELoc  //如果此字段无科室，补齐再生成数据
		continue:LocIDStr=""
		s OrdSetsDr=obj.OSEOrdSetsDR
		continue:OrdSetsDr=""
		
		k arrMapping
		s arrMapping("ID")=xId
		for idxLoc=1:1:$l(LocIDStr,","){
			s LocID=$p(LocIDStr,",",idxLoc)
			continue:LocID=""
			
			s arrMapping("Loc",LocID)=""
			s xNewID=0
			for {
				s xNewID=$o(^DHCPEOSE(0,"OrdSets",OrdSetsDr,xNewID))
				q:xNewID=""
				continue:##class(User.DHCPEOrdSetsEx).GetLocShowDataFlag(xNewID,LocID)'="Y"
				s arrMapping(LocID,xNewID)=""
				s:xNewID=xId arrMapping("ID")=""
			}
		}
		
		s xLocID=""
		for {
			s xLocID=$o(arrMapping("Loc",xLocID))
			q:xLocID=""
			continue:$o(arrMapping("Loc",xLocID,0))'=""
			
			if $g(arrMapping("ID"))'="" {
				s ID=$g(arrMapping("ID"))
				s flg=##class(User.DHCPEOrdSetsEx).SaveDataToPowerControl(ID,xLocID,aUserID)
				if (+flg)<1 {
					s return=aTableName_" 表记录授权报错"
				}
			} else {
				//添加新记录，再授权
				s NewID=$i(^DHCPEOSE)
				s newStr=$g(^DHCPEOSE(xId))
				s $p(newStr,"^",7)=xLocID
				s ^DHCPEOSE(NewID)=newStr
				s ID=NewID
				s flg=##class(User.DHCPEOrdSetsEx).SaveDataToPowerControl(ID,xLocID,aUserID)
				if (+flg)<1 {
					s return=aTableName_" 表记录授权报错"
				}
			}
		}
	}
	Do ##class(User.DHCPEOrdSetsEx).%BuildIndices() //生成索引
	
	q return
}

/// DHC_PE_EDItem--绝对私有
/// DHC_PE_EDItemDetail--绝对私有
ClassMethod toEDItem(aTableName As %String, aLGLocID As %String, aUserID As %String, aLocIDs As %String) As %String
{
    n (aTableName,aLGLocID,aUserID,aLocIDs)
    
    s objPowerType=##class(User.DHCPEEDItem).GetPowerTypeObj()
    q:'$IsObject(objPowerType) aTableName_" 未维护表登记授权管理数据"
	q:objPowerType.PTPowerType'="A" aTableName_" 未维护表登记授权管理数据"
	s PowerTableDR=objPowerType.%Id()
	
	//先处理ID计数器的问题
	s xId=0
	for {
		s xId=$o(^User.DHCPEEndangerD(xId))
		q:xId=""
		
		s xSub=0
		for {
			s xSub=$o(^User.DHCPEEndangerD(xId,"EDItemChild",xSub))
			q:xSub=""
			
			s tNum=$o(^User.DHCPEEndangerD(xId,"EDItemChild",""))
			s iNum=$g(^User.DHCPEEndangerC("EDItemChild"))
			if ((+tNum)>(+iNum)){
				s ^User.DHCPEEndangerC("EDItemChild")=+tNum
			}
			
			s xChild=0
			for {
				s xChild=$o(^User.DHCPEEndangerD(xId,"EDItemChild",xSub,"EDItemDetailChild",xChild))
				q:xChild=""
				
				s tNum=$o(^User.DHCPEEndangerD(xId,"EDItemChild",xSub,"EDItemDetailChild",""))
				s iNum=$g(^User.DHCPEEDItemC("EDItemDetailChild"))
				if ((+tNum)>(+iNum)){
					s ^User.DHCPEEDItemC("EDItemDetailChild")=+tNum
				}
			}
		}
	}
    
    s return=""
	s xId=0
	for {
		s xId=$o(^User.DHCPEEndangerD(xId))
		q:xId=""
		q:return'=""
		
		s xSub=0
		for {
			s xSub=$o(^User.DHCPEEndangerD(xId,"EDItemChild",xSub))
			q:xSub=""
			q:return'=""
			
			s ID=xId_"||"_xSub
			
			s rowData=$g(^User.DHCPEEndangerD(xId,"EDItemChild",xSub))
			s ItemMastID=$lg(rowData,2)
			continue:ItemMastID=""
			
			//检查医嘱项/医嘱套哪些科室有权限
			s LocPowerList=""
			if (ItemMastID["||") {
				//体检项目-医嘱项
				s xLoc=0
				for {
					s xLoc=$o(^CF.PE.StationOrderSetI("IdxOfLocOrder",xLoc))
					q:xLoc=""
					continue:'$d(^CF.PE.StationOrderSetI("IdxOfLocOrder",xLoc,ItemMastID))
					s LocID=$e(xLoc,2,*)
					s LocPowerList=LocPowerList_$lb(LocID)
				}
			} else {
				//体检套餐-医嘱套
				s xOSEID=0
				for {
					s xOSEID=$o(^DHCPEOSE(0,"OrdSets",ItemMastID,xOSEID))
					q:xOSEID=""
					
					for idxLoc=1:1:$l(aLocIDs,",") {
						s LocID=$p(aLocIDs,",",idxLoc)
						continue:LocID=""
						continue:##class(User.DHCPEOrdSetsEx).GetLocShowDataFlag(xOSEID,LocID)'="Y"
						s LocPowerList=LocPowerList_$lb(LocID)
					}
				}
			}
			
			k arrMapping
			s arrMapping("ID")=ID
			for idxLoc=1:1:$ll(LocPowerList){
				s LocID=$lg(LocPowerList,idxLoc)
				continue:LocID=""
				
				s arrMapping("Loc",LocID)=""
				s xNewID=0
				for {
					s xNewID=$o(^User.DHCPEEDItemI("ItemIDIndex"," "_ItemMastID,xNewID))
					q:xNewID=""
					
					s xNewSub=0
					for {
						s xNewSub=$o(^User.DHCPEEDItemI("ItemIDIndex"," "_ItemMastID,xNewID,xNewSub))
						q:xNewSub=""
						
						s NewID=xNewID_"||"_xNewSub
						continue:##class(User.DHCPEEDItem).GetLocShowDataFlag(NewID,LocID)'="Y"
						s arrMapping("Loc",LocID,NewID)=""
						s:NewID=ID arrMapping("ID")=""
					}
				}
			}
			
			s xLocID=""
			for {
				s xLocID=$o(arrMapping("Loc",xLocID))
				q:xLocID=""
				continue:$o(arrMapping("Loc",xLocID,0))'=""
				
				if $g(arrMapping("ID"))'="" {
					s ID=$g(arrMapping("ID"))
					s flg=##class(User.DHCPEEDItem).SaveDataToPowerControl(ID,xLocID,aUserID)
					if (+flg)<1 {
						s return=aTableName_" 表记录授权报错"
					}
					
					s xChild=0
					for {
						s xChild=$o(^User.DHCPEEndangerD(xId,"EDItemChild",xSub,"EDItemDetailChild",xChild))
						q:xChild=""
						
						s ID=xId_"||"_xSub_"||"_xChild
						s flg=##class(User.DHCPEEDItemDetail).SaveDataToPowerControl(ID,xLocID,aUserID)
						if (+flg)<1 {
							s return=aTableName_" 表记录授权报错"
						}
					}
				} else {
					//添加新记录，再授权
					s NewSub=$i(^User.DHCPEEndangerC("EDItemChild"))
					s ^User.DHCPEEndangerD(xId,"EDItemChild",NewSub)=$g(^User.DHCPEEndangerD(xId,"EDItemChild",xSub))
					s ID=xId_"||"_NewSub
					s flg=##class(User.DHCPEEDItem).SaveDataToPowerControl(ID,xLocID,aUserID)
					if (+flg)<1 {
						s return=aTableName_" 表记录授权报错"
					}
					
					s xChild=0
					for {
						s xChild=$o(^User.DHCPEEndangerD(xId,"EDItemChild",xSub,"EDItemDetailChild",xChild))
						q:xChild=""
						
						s NewChild=$i(^User.DHCPEEDItemC("EDItemDetailChild"))
						s ^User.DHCPEEndangerD(xId,"EDItemChild",NewSub,"EDItemDetailChild",NewChild)=$g(^User.DHCPEEndangerD(xId,"EDItemChild",xSub,"EDItemDetailChild",xChild))
						s ID=xId_"||"_NewSub_"||"_NewChild
						s flg=##class(User.DHCPEEDItemDetail).SaveDataToPowerControl(ID,xLocID,aUserID)
						if (+flg)<1 {
							s return=aTableName_" 表记录授权报错"
						}
					}
				}
			}
		}
	}
	Do ##class(User.DHCPEEDItem).%BuildIndices() //生成索引
	Do ##class(User.DHCPEEDItemDetail).%BuildIndices() //生成索引
	
	q return
}

/// DHC_PE_HandlingOpinions--私有
ClassMethod toHandlingOpinions(aTableName As %String, aLGLocID As %String, aUserID As %String, aLocIDs As %String) As %String
{
    n (aTableName,aLGLocID,aUserID,aLocIDs)
    
    s objPowerType=##class(User.DHCPEHandlingOpinions).GetPowerTypeObj()
    q:'$IsObject(objPowerType) aTableName_" 未维护表登记授权管理数据"
	q:objPowerType.PTPowerType'="S" aTableName_" 未维护表登记授权管理数据"
	s PowerTableDR=objPowerType.%Id()
    
    s return=""
	s xId=0
	for {
		s xId=$o(^User.DHCPEHandlingOpinionsD(xId))
		q:xId=""
		q:return'=""
		
		s ID=xId
		s flg=##class(User.DHCPEHandlingOpinions).SaveDataToPowerControl(ID,aLGLocID,aUserID)
		if (+flg)<1 {
			s return=aTableName_" 表记录授权报错"
		}
	}
	q return
}

/// DHC_PE_Express--私有
ClassMethod toExpress(aTableName As %String, aLGLocID As %String, aUserID As %String, aLocIDs As %String) As %String
{
    n (aTableName,aLGLocID,aUserID,aLocIDs)
    
    s objPowerType=##class(User.DHCPEExpress).GetPowerTypeObj()
    q:'$IsObject(objPowerType) aTableName_" 未维护表登记授权管理数据"
	q:objPowerType.PTPowerType'="S" aTableName_" 未维护表登记授权管理数据"
	s PowerTableDR=objPowerType.%Id()
    
    s return=""
	s xId=0
	for {
		s xId=$o(^User.DHCPEExpressD(xId))
		q:xId=""
		q:return'=""
		
		s ID=xId
		s flg=##class(User.DHCPEExpress).SaveDataToPowerControl(ID,aLGLocID,aUserID)
		if (+flg)<1 {
			s return=aTableName_" 表记录授权报错"
		}
	}
	q return
}

/// DHC_PE_IDRelate--私有
ClassMethod toIDRelate(aTableName As %String, aLGLocID As %String, aUserID As %String, aLocIDs As %String) As %String
{
    n (aTableName,aLGLocID,aUserID,aLocIDs)
    
    s objPowerType=##class(User.DHCPEIDRelate).GetPowerTypeObj()
    q:'$IsObject(objPowerType) aTableName_" 未维护表登记授权管理数据"
	q:objPowerType.PTPowerType'="S" aTableName_" 未维护表登记授权管理数据"
	s PowerTableDR=objPowerType.%Id()
    
    s return=""
	s xId=0
	for {
		s xId=$o(^DHCPEIDR(xId))
		q:xId=""
		q:return'=""
		
		s ID=xId
		s flg=##class(User.DHCPEIDRelate).SaveDataToPowerControl(ID,aLGLocID,aUserID)
		if (+flg)<1 {
			s return=aTableName_" 表记录授权报错"
		}
	}
	q return
}

/// DHC_PE_EDAlias--私有
ClassMethod toEDAlias(aTableName As %String, aLGLocID As %String, aUserID As %String, aLocIDs As %String) As %String
{
    n (aTableName,aLGLocID,aUserID,aLocIDs)
    
    s objPowerType=##class(User.DHCPEEDAlias).GetPowerTypeObj()
    q:'$IsObject(objPowerType) aTableName_" 未维护表登记授权管理数据"
	q:objPowerType.PTPowerType'="S" aTableName_" 未维护表登记授权管理数据"
	s PowerTableDR=objPowerType.%Id()
    
    s return=""
	s xId=0
	for {
		s xId=$o(^DHCPEEDA(xId))
		q:xId=""
		q:return'=""
		
		s ID=xId
		s flg=##class(User.DHCPEEDAlias).SaveDataToPowerControl(ID,aLGLocID,aUserID)
		if (+flg)<1 {
			s return=aTableName_" 表记录授权报错"
		}
	}
	q return
}

/// DHC_PE_ExpertDiagnosis--私有
ClassMethod toExpertDiagnosis(aTableName As %String, aLGLocID As %String, aUserID As %String, aLocIDs As %String) As %String
{
    n (aTableName,aLGLocID,aUserID,aLocIDs)
    
    s objPowerType=##class(User.DHCPEExpertDiagnosis).GetPowerTypeObj()
    q:'$IsObject(objPowerType) aTableName_" 未维护表登记授权管理数据"
	q:objPowerType.PTPowerType'="S" aTableName_" 未维护表登记授权管理数据"
	s PowerTableDR=objPowerType.%Id()
    
    s return=""
	s xId=0
	for {
		s xId=$o(^DHCPEED(xId))
		q:xId=""
		q:return'=""
		
		s ID=xId
		if ID="" {
			s obj=##class(User.DHCPEExpertDiagnosis).%New()
		} else {
			s obj=##class(User.DHCPEExpertDiagnosis).%OpenId(ID)
		}
		continue:'$IsObject(obj)
		s obj.EDSexDR	   = $g(^DHCPECTDataEx("BaseData","DHCPEExpertDiagnosis","Sex",ID))
		s obj.EDYGCheck	   = $g(^DHCPECTDataEx("BaseData","DHCPEExpertDiagnosis","YGCheck",ID))
		s obj.EDYGCheck    = $s(obj.EDYGCheck["Y":"Y",1:"N")
		s obj.EDActive	   = $g(^DHCPECTDataEx("BaseData","DHCPEExpertDiagnosis","Active",ID))
		s obj.EDActive     = $s(obj.EDActive["Y":"Y",1:"N")
		s sc=obj.%Save()
		if $system.Status.IsError(sc) {        //检查Save是否成功
	   		d $system.OBJ.DisplayError(sc)
	   		s return=aTableName_" 新建表数据迁移报错"
	   		q
		}
		d obj.%Close()
		s ID=obj.%Id()
		
		s flg=##class(User.DHCPEExpertDiagnosis).SaveDataToPowerControl(ID,aLGLocID,aUserID)
		if (+flg)<1 {
			s return=aTableName_" 表记录授权报错"
		}
	}
	q return
}

/// DHC_PE_ILLSDietGuide--新建表，私有
/// w ##class(web.DHCPE.Upgrade.CodeTableSrv).toILLSDietGuide("DHC_PE_ILLSDietGuide","152",1,"113,152,539,261,388,470")
ClassMethod toILLSDietGuide(aTableName As %String, aLGLocID As %String, aUserID As %String, aLocIDs As %String) As %String
{
    n (aTableName,aLGLocID,aUserID,aLocIDs)
    
    s objPowerType=##class(User.DHCPEILLSDietGuide).GetPowerTypeObj()
    q:'$IsObject(objPowerType) aTableName_" 未维护表登记授权管理数据"
	q:objPowerType.PTPowerType'="S" aTableName_" 未维护表登记授权管理数据"
	s PowerTableDR=objPowerType.%Id()
    
    s return=""
	s xILLSDR=0
	for {
		s xILLSDR=$o(^DHCPECTDataEx("BaseData","IllnessStandard","DietGuide",xILLSDR))
		q:xILLSDR=""
		q:return'=""
		
		//获取ID，这块比较特殊，注意下
		s ID=""
		s xId=0
		for {
			s xId=$o(^CF.PE.ILLSDietGuideI("IdxOfILLSDR",xILLSDR,xId))
			q:xId=""
			q:ID'=""
			
			continue:'$d(^CF.PE.PowerControlI("IdxOfLocGrpPower",PowerTableDR,xId,aLGLocID))
			s ID=xId
			q
		}
		
		if ID="" {
			s obj=##class(User.DHCPEILLSDietGuide).%New()
		} else {
			s obj=##class(User.DHCPEILLSDietGuide).%OpenId(ID)
		}
		continue:'$IsObject(obj)
		d obj.IDGILLSDRSetObjectId(xILLSDR)
		s obj.IDGDietGuide     = $g(^DHCPECTDataEx("BaseData","IllnessStandard","IllExplain",xILLSDR))
		s obj.IDGNoActive       = "Y"
		s obj.IDGUpdateDate     = +$h
		s obj.IDGUpdateTime     = $p($h,",",2)
		s obj.IDGUpdateUserDR   = aUserID
		s sc=obj.%Save()
		if $system.Status.IsError(sc) {        //检查Save是否成功
	   		d $system.OBJ.DisplayError(sc)
	   		s return=aTableName_" 新建表数据迁移报错"
	   		q
		}
		d obj.%Close()
		s ID=obj.%Id()
		
		s flg=##class(User.DHCPEILLSDietGuide).SaveDataToPowerControl(ID,aLGLocID,aUserID)
		if (+flg)<1 {
			s return=aTableName_" 表记录授权报错"
		}
	}
	q return
}

/// DHC_PE_ILLSSportGuide--新建表，私有
ClassMethod toILLSSportGuide(aTableName As %String, aLGLocID As %String, aUserID As %String, aLocIDs As %String) As %String
{
    n (aTableName,aLGLocID,aUserID,aLocIDs)
    
    s objPowerType=##class(User.DHCPEILLSSportGuide).GetPowerTypeObj()
    q:'$IsObject(objPowerType) aTableName_" 未维护表登记授权管理数据"
	q:objPowerType.PTPowerType'="S" aTableName_" 未维护表登记授权管理数据"
	s PowerTableDR=objPowerType.%Id()
    
    s return=""
	s xILLSDR=0
	for {
		s xILLSDR=$o(^DHCPECTDataEx("BaseData","IllnessStandard","SportGuide",xILLSDR))
		q:xILLSDR=""
		q:return'=""
		
		//获取ID，这块比较特殊，注意下
		s ID=""
		s xId=0
		for {
			s xId=$o(^CF.PE.ILLSSportGuideI("IdxOfILLSDR",xILLSDR,xId))
			q:xId=""
			q:ID'=""
			
			continue:'$d(^CF.PE.PowerControlI("IdxOfLocGrpPower",PowerTableDR,xId,aLGLocID))
			s ID=xId
			q
		}
		
		if ID="" {
			s obj=##class(User.DHCPEILLSSportGuide).%New()
		} else {
			s obj=##class(User.DHCPEILLSSportGuide).%OpenId(ID)
		}
		continue:'$IsObject(obj)
		d obj.ISGILLSDRSetObjectId(xILLSDR)
		s obj.ISGSportGuide     = $g(^DHCPECTDataEx("BaseData","IllnessStandard","IllExplain",xILLSDR))
		s obj.ISGNoActive       = "Y"
		s obj.ISGUpdateDate     = +$h
		s obj.ISGUpdateTime     = $p($h,",",2)
		s obj.ISGUpdateUserDR   = aUserID
		s sc=obj.%Save()
		if $system.Status.IsError(sc) {        //检查Save是否成功
	   		d $system.OBJ.DisplayError(sc)
	   		s return=aTableName_" 新建表数据迁移报错"
	   		q
		}
		d obj.%Close()
		s ID=obj.%Id()
		
		s flg=##class(User.DHCPEILLSSportGuide).SaveDataToPowerControl(ID,aLGLocID,aUserID)
		if (+flg)<1 {
			s return=aTableName_" 表记录授权报错"
		}
	}
	q return
}

/// DHC_PE_ILLSExplain--新建表，私有
ClassMethod toILLSExplain(aTableName As %String, aLGLocID As %String, aUserID As %String, aLocIDs As %String) As %String
{
    n (aTableName,aLGLocID,aUserID,aLocIDs)
    
    s objPowerType=##class(User.DHCPEILLSExplain).GetPowerTypeObj()
    q:'$IsObject(objPowerType) aTableName_" 未维护表登记授权管理数据"
	q:objPowerType.PTPowerType'="S" aTableName_" 未维护表登记授权管理数据"
	s PowerTableDR=objPowerType.%Id()
    
    s return=""
	s xILLSDR=0
	for {
		s xILLSDR=$o(^DHCPECTDataEx("BaseData","IllnessStandard","IllExplain",xILLSDR))
		q:xILLSDR=""
		q:return'=""
		
		//获取ID，这块比较特殊，注意下
		s ID=""
		s xId=0
		for {
			s xId=$o(^CF.PE.ILLSExplainI("IdxOfILLSDR",xILLSDR,xId))
			q:xId=""
			q:ID'=""
			
			continue:'$d(^CF.PE.PowerControlI("IdxOfLocGrpPower",PowerTableDR,xId,aLGLocID))
			s ID=xId
			q
		}
		
		if ID="" {
			s obj=##class(User.DHCPEILLSExplain).%New()
		} else {
			s obj=##class(User.DHCPEILLSExplain).%OpenId(ID)
		}
		continue:'$IsObject(obj)
		d obj.IEILLSDRSetObjectId(xILLSDR)
		s obj.IEIllExplain     = $g(^DHCPECTDataEx("BaseData","IllnessStandard","IllExplain",xILLSDR))
		s obj.IENoActive       = "Y"
		s obj.IEUpdateDate     = +$h
		s obj.IEUpdateTime     = $p($h,",",2)
		s obj.IEUpdateUserDR   = aUserID
		s sc=obj.%Save()
		if $system.Status.IsError(sc) {        //检查Save是否成功
	   		d $system.OBJ.DisplayError(sc)
	   		s return=aTableName_" 新建表数据迁移报错"
	   		q
		}
		d obj.%Close()
		s ID=obj.%Id()
		
		s flg=##class(User.DHCPEILLSExplain).SaveDataToPowerControl(ID,aLGLocID,aUserID)
		if (+flg)<1 {
			s return=aTableName_" 表记录授权报错"
		}
	}
	q return
}

/// DHC_PE_ILLSAlias--私有    //管控改为了私有
ClassMethod toILLSAlias(aTableName As %String, aLGLocID As %String, aUserID As %String, aLocIDs As %String) As %String
{
    n (aTableName,aLGLocID,aUserID,aLocIDs)
    
    s objPowerType=##class(User.DHCPEILLSAlias).GetPowerTypeObj()
    q:'$IsObject(objPowerType) aTableName_" 未维护表登记授权管理数据"
	q:objPowerType.PTPowerType'="S" aTableName_" 未维护表登记授权管理数据"
	s PowerTableDR=objPowerType.%Id()
    
    s return=""
	s xId=0
	for {
		s xId=$o(^DHCPEILLSA(xId))
		q:xId=""
		q:return'=""
		
		s ID=xId
		s flg=##class(User.DHCPEILLSAlias).SaveDataToPowerControl(ID,aLGLocID,aUserID)
		if (+flg)<1 {
			s return=aTableName_" 表记录授权报错"
		}
	}
	q return
}

/// DHC_PE_IllnessStandard--私有    //管控改为了私有
ClassMethod toIllnessStandard(aTableName As %String, aLGLocID As %String, aUserID As %String, aLocIDs As %String) As %String
{
    n (aTableName,aLGLocID,aUserID,aLocIDs)
    
    s objPowerType=##class(User.DHCPEIllnessStandard).GetPowerTypeObj()
    q:'$IsObject(objPowerType) aTableName_" 未维护表登记授权管理数据"
	q:objPowerType.PTPowerType'="S" aTableName_" 未维护表登记授权管理数据"
	s PowerTableDR=objPowerType.%Id()
    
    s return=""
	s xId=0
	for {
		s xId=$o(^DHCPEILLS(xId))
		q:xId=""
		q:return'=""
		
		s ID=xId
		s flg=##class(User.DHCPEIllnessStandard).SaveDataToPowerControl(ID,aLGLocID,aUserID)
		if (+flg)<1 {
			s return=aTableName_" 表记录授权报错"
		}
	}
	q return
}

/// DHC_PE_EDKey--私有    //管控改为了私有
ClassMethod toEDKey(aTableName As %String, aLGLocID As %String, aUserID As %String, aLocIDs As %String) As %String
{
    n (aTableName,aLGLocID,aUserID,aLocIDs)
    
    s objPowerType=##class(User.DHCPEEDKey).GetPowerTypeObj()
    q:'$IsObject(objPowerType) aTableName_" 未维护表登记授权管理数据"
	q:objPowerType.PTPowerType'="S" aTableName_" 未维护表登记授权管理数据"
	s PowerTableDR=objPowerType.%Id()
    
    s return=""
	s xId=0
	for {
		s xId=$o(^User.DHCPEEDKeyD(xId))
		q:xId=""
		q:return'=""
		
		s ID=xId
		s flg=##class(User.DHCPEEDKey).SaveDataToPowerControl(ID,aLGLocID,aUserID)
		if (+flg)<1 {
			s return=aTableName_" 表记录授权报错"
		}
	}
	q return
}

/// DHC_PE_EDClass--私有
ClassMethod toEDClass(aTableName As %String, aLGLocID As %String, aUserID As %String, aLocIDs As %String) As %String
{
    n (aTableName,aLGLocID,aUserID,aLocIDs)
    
    s objPowerType=##class(User.DHCPEEDClass).GetPowerTypeObj()
    q:'$IsObject(objPowerType) aTableName_" 未维护表登记授权管理数据"
	q:objPowerType.PTPowerType'="S" aTableName_" 未维护表登记授权管理数据"
	s PowerTableDR=objPowerType.%Id()
    
    s return=""
	s xId=0
	for {
		s xId=$o(^DHCPEEDC(xId))
		q:xId=""
		q:return'=""
		
		s ID=xId
		s flg=##class(User.DHCPEEDClass).SaveDataToPowerControl(ID,aLGLocID,aUserID)
		if (+flg)<1 {
			s return=aTableName_" 表记录授权报错"
		}
	}
	q return
}

/// DHC_PE_UsherItemCat--新建表，绝对私有
ClassMethod toUsherItemCat(aTableName As %String, aLGLocID As %String, aUserID As %String, aLocIDs As %String) As %String
{
    n (aTableName,aLGLocID,aUserID,aLocIDs)
    
    s objPowerType=##class(User.DHCPEUsherItemCat).GetPowerTypeObj()
    q:'$IsObject(objPowerType) aTableName_" 未维护表登记授权管理数据"
	q:objPowerType.PTPowerType'="A" aTableName_" 未维护表登记授权管理数据"
	s PowerTableDR=objPowerType.%Id()
	
	s return=""
	s xCode=""
	for {
		s xCode=$o(^DHCPECTDataEx("PatItem",xCode))
		q:xCode=""
		
	    for idxLoc=1:1:$length(aLocIDs,",") {
		    s LocID=$p(aLocIDs,",",idxLoc)
		    continue:LocID=""
		    
			s ID=$o(^CF.PE.UsherItemCatI("IdxOfLocCatCode"," "_LocID," "_xCode,0))
			if ID="" {
				s obj=##class(User.DHCPEUsherItemCat).%New()
			} else {
				s obj=##class(User.DHCPEUsherItemCat).%OpenId(ID)
			}
			continue:'$IsObject(obj)
			s obj.PILocDR          = LocID
			s obj.PICatCode        = xCode
			s obj.PICategory       = $p($g(^DHCPECTDataEx("PatItem",xCode)),"^",1)
			s obj.PISort           = $p($g(^DHCPECTDataEx("PatItem",xCode)),"^",2)
			s obj.PIDiet           = $p($g(^DHCPECTDataEx("PatItem",xCode)),"^",3)
			s obj.PIDiet           = $s(obj.PIDiet["Y":"Y",1:"N")
			s obj.PIAutoChange     = $p($g(^DHCPECTDataEx("PatItem",xCode)),"^",4)
			s obj.PIAutoChange     = $s(obj.PIAutoChange["Y":"Y",1:"N")
			s obj.PIPlace          = $p($g(^DHCPECTDataEx("PatItem",xCode)),"^",5)
			if $d(^DHCPECTDataEx("PatItem",xCode,"Place",LocID)) {
				s obj.PIPlace      = $g(^DHCPECTDataEx("PatItem",xCode,"Place",LocID))
			}
			s obj.PIDocSignName    = $p($g(^DHCPECTDataEx("PatItem",xCode)),"^",6)
			s obj.PIPatSignName    = $p($g(^DHCPECTDataEx("PatItem",xCode)),"^",7)
			s obj.PINoActive       = "Y"
			s obj.PIUpdateDate     = +$h
			s obj.PIUpdateTime     = $p($h,",",2)
			s obj.PIUpdateUserDR   = aUserID
			s sc=obj.%Save()
			if $system.Status.IsError(sc) {        //检查Save是否成功
		   		d $system.OBJ.DisplayError(sc)
		   		s return=aTableName_" 新建表数据迁移报错"
		   		q
			}
			d obj.%Close()
			s ID=obj.%Id()
			
			s flg=##class(User.DHCPEUsherItemCat).SaveDataToPowerControl(ID,LocID,aUserID)
			if (+flg)<1 {
				s return=aTableName_" 表记录授权报错"
			}
		}
	}
	q return
}

/// DHC_PE_ExcludeArcItem--私有
ClassMethod toExcludeArcItem(aTableName As %String, aLGLocID As %String, aUserID As %String, aLocIDs As %String) As %String
{
    n (aTableName,aLGLocID,aUserID,aLocIDs)
    
    s objPowerType=##class(User.DHCPEExcludeArcItem).GetPowerTypeObj()
    q:'$IsObject(objPowerType) aTableName_" 未维护表登记授权管理数据"
	q:objPowerType.PTPowerType'="S" aTableName_" 未维护表登记授权管理数据"
	s PowerTableDR=objPowerType.%Id()
    
    s return=""
	s xId=0
	for {
		s xId=$o(^User.DHCPEExcludeArcItemD(xId))
		q:xId=""
		q:return'=""
		
		s ID=xId
		s flg=##class(User.DHCPEExcludeArcItem).SaveDataToPowerControl(ID,aLGLocID,aUserID)
		if (+flg)<1 {
			s return=aTableName_" 表记录授权报错"
		}
	}
	q return
}

/// DHC_PE_OrderDetailRelate--新加字段，私有
ClassMethod toOrderDetailRelate(aTableName As %String, aLGLocID As %String, aUserID As %String, aLocIDs As %String) As %String
{
    n (aTableName,aLGLocID,aUserID,aLocIDs)
    
    s objPowerType=##class(User.DHCPEOrderDetailRelate).GetPowerTypeObj()
    q:'$IsObject(objPowerType) aTableName_" 未维护表登记授权管理数据"
	q:objPowerType.PTPowerType'="S" aTableName_" 未维护表登记授权管理数据"
	s PowerTableDR=objPowerType.%Id()
	
    s return=""
    s xId=0
	for {
		s xId=$o(^DHCPEODR(xId))
		q:xId=""
		q:return'=""
		
		s objODR=##class(User.DHCPEOrderDetailRelate).%OpenId(xId)
		continue:'$IsObject(objODR)
		d objODR.%Close()
		s ARCIMID=objODR.ODRARCIMDR
		continue:ARCIMID=""
		
		s StationId=$o(^DHCPEST(0,"STORD_ARCIM",ARCIMID,0))
		continue:StationId=""
		s STOrderSub=$o(^DHCPEST(0,"STORD_ARCIM",ARCIMID,StationId,0))
		continue:STOrderSub=""
		s STOrderID=StationId_"||"_STOrderSub
		
		s ID=xId
		s obj=##class(User.DHCPEOrderDetailRelate).%OpenId(ID)
		continue:'$IsObject(obj)
		
		d obj.ODROrderDRSetObjectId(STOrderID)
		s obj.ODRNoActive      = "Y"
		s obj.ODRUpdateDate    = +$h
		s obj.ODRUpdateTime    = $p($h,",",2)
		s obj.ODRUpdateUserDR  = aUserID
		s sc=obj.%Save()
		if $system.Status.IsError(sc) {        //检查Save是否成功
	   		d $system.OBJ.DisplayError(sc)
	   		s return=aTableName_" 新建表数据迁移报错"
	   		q
		}
		d obj.%Close()
		s ID=obj.%Id()
		
		s flg=##class(User.DHCPEOrderDetailRelate).SaveDataToPowerControl(ID,aLGLocID,aUserID)
		if (+flg)<1 {
			s return=aTableName_" 表记录授权报错"
		}
	}
	q return
}

/// DHC_PE_OrderDetailSet--新建表，绝对私有
ClassMethod toOrderDetailSet(aTableName As %String, aLGLocID As %String, aUserID As %String, aLocIDs As %String) As %String
{
    n (aTableName,aLGLocID,aUserID,aLocIDs)
    
    s objPowerType=##class(User.DHCPEOrderDetailSet).GetPowerTypeObj()
    q:'$IsObject(objPowerType) aTableName_" 未维护表登记授权管理数据"
	q:objPowerType.PTPowerType'="A" aTableName_" 未维护表登记授权管理数据"
	s PowerTableDR=objPowerType.%Id()
    
    s return=""
    s xId=0
	for {
		s xId=$o(^DHCPEST(xId))
		q:xId=""
		q:return'=""
		
		s xSub=0
		for {
			s xSub=$o(^DHCPEST(xId,"OD",xSub))
			q:xSub=""
			q:return'=""
			
			s STOrdDtlId=xId_"||"_xSub
			s objSTOD=##class(User.DHCPEOrderDetail).%OpenId(STOrdDtlId)
			continue:'$IsObject(objSTOD)
			d objSTOD.%Close()
			
		    for idxLoc=1:1:$length(aLocIDs,",") {
			    s LocID=$p(aLocIDs,",",idxLoc)
			    continue:LocID=""
			    
				s ID=$o(^CF.PE.OrderDetailSetI("IdxOfLocOrdDtl"," "_LocID,STOrdDtlId,0))
				if ID="" {
					s obj=##class(User.DHCPEOrderDetailSet).%New()
				} else {
					s obj=##class(User.DHCPEOrderDetailSet).%OpenId(ID)
				}
				continue:'$IsObject(obj)
				
				s obj.ODSOrderDtlDR    = objSTOD
				s obj.ODSLocDR         = LocID
				s obj.ODSSummary       = objSTOD.ODSummary
				s obj.ODSSummary       = $s(obj.ODSSummary["Y":"Y",1:"N")
				s obj.ODSAdvice        = objSTOD.ODAdvice
				s obj.ODSAdvice        = $s(obj.ODSAdvice["Y":"Y",1:"N")
				s obj.ODSExplain2      = objSTOD.ODExplain
				s obj.ODSSequence      = objSTOD.ODSequence
				s obj.ODSLabtrakCode2  = objSTOD.ODLabtrakCode
				s obj.ODSZhToEn        = $g(^DHCPECTDataEx("BaseData","ZhToEn",STOrdDtlId))
				s obj.ODSNoPrint       = $g(^DHCPECTDataEx("DHCPEOrderDetail","NoPrint",STOrdDtlId))
				s obj.ODSNoPrint       = $s(obj.ODSNoPrint["Y":"Y",1:"N")
				s obj.ODSHistoryFlag   = $g(^DHCPECTDataEx("DHCPEOrderDetail","HistoryFlag",STOrdDtlId))
				s obj.ODSHistoryFlag   = $s(obj.ODSHistoryFlag["Y":"Y",1:"N")
				s obj.ODSRange         = $g(^DHCPECTDataEx("OrderDetail","Range",STOrdDtlId))
				s obj.ODSMarriedDR     = $g(^DHCPECTDataEx("DHCPEOrderDetail","Married",STOrdDtlId))
				s obj.ODSNoActive      = "Y"
				s obj.ODSUpdateDate    = +$h
				s obj.ODSUpdateTime    = $p($h,",",2)
				s obj.ODSUpdateUserDR  = aUserID
				s sc=obj.%Save()
				if $system.Status.IsError(sc) {        //检查Save是否成功
			   		d $system.OBJ.DisplayError(sc)
			   		s return=aTableName_" 新建表数据迁移报错"
			   		q
				}
				d obj.%Close()
				s ID=obj.%Id()
				
				s flg=##class(User.DHCPEOrderDetailSet).SaveDataToPowerControl(ID,LocID,aUserID)
				if (+flg)<1 {
					s return=aTableName_" 表记录授权报错"
				}
			}
		}
	}
	q return
}

/// DHC_PE_StationOrderSet--新建表，绝对私有
ClassMethod toStationOrderSet(aTableName As %String, aLGLocID As %String, aUserID As %String, aLocIDs As %String) As %String
{
    n (aTableName,aLGLocID,aUserID,aLocIDs)
    
    s objPowerType=##class(User.DHCPEStationOrderSet).GetPowerTypeObj()
    q:'$IsObject(objPowerType) aTableName_" 未维护表登记授权管理数据"
	q:objPowerType.PTPowerType'="A" aTableName_" 未维护表登记授权管理数据"
	s PowerTableDR=objPowerType.%Id()
    
    s return=""
    s xId=0
	for {
		s xId=$o(^DHCPEST(xId))
		q:xId=""
		q:return'=""
		
		s xSub=0
		for {
			s xSub=$o(^DHCPEST(xId,"O",xSub))
			q:xSub=""
			q:return'=""
			
			s STOrderId=xId_"||"_xSub
			s objSTO=##class(User.DHCPEStationOrder).%OpenId(STOrderId)
			continue:'$IsObject(objSTO)
			d objSTO.%Close()
			s ARCIMID=objSTO.STORDARCIMDR
			
			
		    for idxLoc=1:1:$length(aLocIDs,",") {
			    s LocID=$p(aLocIDs,",",idxLoc)
			    continue:LocID=""
			    
			    //导诊单分类ID，通过历史数据转换获得新的ID
			    s UsherItemCatDR=""
				s UsherCatCode=$p($g(^DHCPECTDataEx("PatItemSort",ARCIMID)),"^",1)
				if UsherCatCode'="" {
					s UsherItemCatDR=$o(^CF.PE.UsherItemCatI("IdxOfLocCatCode"," "_LocID," "_UsherCatCode,0))
				}
			    
				s ID=$o(^CF.PE.StationOrderSetI("IdxOfLocOrder"," "_LocID,STOrderId,0))
				if ID="" {
					s obj=##class(User.DHCPEStationOrderSet).%New()
				} else {
					s obj=##class(User.DHCPEStationOrderSet).%OpenId(ID)
				}
				continue:'$IsObject(obj)
				
				s obj.SOSOrderDR       = objSTO
				s obj.SOSLocDR         = LocID
				s obj.SOSDiet          = objSTO.STORDDiet
				s obj.SOSReportFormat  = objSTO.STORDReportFormat
				s obj.SOSNotice        = objSTO.STORDNotice
				s obj.SOSAutoReturn    = objSTO.STORDAutoReturn
				s obj.SOSAutoReturn    = $s(obj.SOSAutoReturn["Y":"Y",1:"N")
				s obj.SOSSort          = objSTO.STORDSort
				s obj.SOSSexDR         = $g(^DHCPECTDataEx("DHCPEStationOrder","Sex",ARCIMID))
				s obj.SOSMarriedDR     = $g(^DHCPECTDataEx("DHCPEStationOrder","Married",ARCIMID))
				s obj.SOSAgeMax        = $p($g(^DHCPECTDataEx("DHCPEStationOrder","Age",ARCIMID)),"^",2)
				s obj.SOSAgeMin        = $p($g(^DHCPECTDataEx("DHCPEStationOrder","Age",ARCIMID)),"^",1)
				s obj.SOSVIPLevelDR    = $g(^DHCPECTDataEx("DHCPEStationOrder","VIPLevelType",ARCIMID))
				s obj.SOSBaseInfoBar   = $g(^DHCPECTDataEx("DHCPEStationOrder","BaseInfoBar",ARCIMID))
				s obj.SOSBaseInfoBar   = $s(obj.SOSBaseInfoBar["1":"Y",1:"N")
				s obj.SOSAlowAddFlag   = $g(^DHCPECTDataEx("DHCPEStationOrder","AlowAddFlag",ARCIMID))
				s obj.SOSAlowAddFlag   = $s(obj.SOSAlowAddFlag["1":"Y",1:"N")
				s obj.SOSPisCodeDR     = $g(^DHCPECTDataEx("DHCPEStationOrder","PISCodeType",ARCIMID))
				s obj.SOSPreNum        = $g(^DHCPECTDataEx("DHCPEStationOrder","PreNum",ARCIMID))
				s obj.SOSTempName      = $g(^DHCPECTDataEx("DHCPEStationOrder","TempName",ARCIMID))
				s obj.SOSYGFlag        = $g(^DHCPECTDataEx("YGFlag",ARCIMID))
				s obj.SOSYGFlag        = $s(obj.SOSYGFlag["Y":"Y",1:"N")
				s obj.SOSSignItem      = $g(^DHCPECTDataEx("DHCPEStationOrder","Sign",ARCIMID))
				s obj.SOSSignItem      = $s(obj.SOSSignItem["Y":"Y",1:"N")
				s obj.SOSShowOrHide    = $g(^DHCPECTDataEx("DHCPEStationOrder","ShowOrHide",ARCIMID))
				s obj.SOSShowOrHide    = $s(obj.SOSShowOrHide["Y":"Y",1:"N")
				s obj.SOSExtend        = $g(^DHCPECTDataEx("DHCPEStationOrder","Extend",ARCIMID))
				s obj.SOSExtend        = $s(obj.SOSExtend["Y":"Y",1:"N")
				s obj.SOSPhoto         = $g(^DHCPECTDataEx("DHCPEStationOrder","Photo",ARCIMID))
				s obj.SOSPhoto         = $s(obj.SOSPhoto["Y":"Y",1:"N")
				s obj.SOSIFReprotPrint = $g(^DHCPECTDataEx("DHCPEStationOrder","IFReprotPrint",ARCIMID))
				s obj.SOSIFReprotPrint = $s(obj.SOSIFReprotPrint["Y":"Y",1:"N")
				s obj.SOSBarPrintNum   = $g(^DHCPECTDataEx("DHCPEStationOrder","BarPrintNum",ARCIMID))
				s obj.SOSNoticeInfo    = $g(^DHCPECTDataEx("DHCPEStationOrder","NoticeInfo",ARCIMID))
				d obj.SOSUsherItemCatDRSetObjectId(UsherItemCatDR)  //导诊单分类ID，通过历史数据转换获得新的ID
				s obj.SOSUsherSort     = $p($g(^DHCPECTDataEx("PatItemSort",ARCIMID)),"^",2)
				s obj.SOSUsherIsPrint  = $p($g(^DHCPECTDataEx("PatItemSort",ARCIMID)),"^",3)
				s obj.SOSUsherIsPrint  = $s(obj.SOSUsherIsPrint["Y":"Y",1:"N")
				s obj.SOSUsherPrtName  = $p($g(^DHCPECTDataEx("PatItemSort",ARCIMID)),"^",4)
				s obj.SOSNoActive      = "Y"
				s obj.SOSUpdateDate    = +$h
				s obj.SOSUpdateTime    = $p($h,",",2)
				s obj.SOSUpdateUserDR  = aUserID
				s sc=obj.%Save()
				if $system.Status.IsError(sc) {        //检查Save是否成功
			   		d $system.OBJ.DisplayError(sc)
			   		s return=aTableName_" 新建表数据迁移报错"
			   		q
				}
				d obj.%Close()
				s ID=obj.%Id()
				
				s flg=##class(User.DHCPEStationOrderSet).SaveDataToPowerControl(ID,LocID,aUserID)
				if (+flg)<1 {
					s return=aTableName_" 表记录授权报错"
				}
			}
		}
	}
	q return
}

/// DHC_PE_StationOrderSort--新建表，私有
ClassMethod toStationOrderSort(aTableName As %String, aLGLocID As %String, aUserID As %String, aLocIDs As %String) As %String
{
    n (aTableName,aLGLocID,aUserID,aLocIDs)
    
    s objPowerType=##class(User.DHCPEStationOrderSort).GetPowerTypeObj()
    q:'$IsObject(objPowerType) aTableName_" 未维护表登记授权管理数据"
	q:objPowerType.PTPowerType'="S" aTableName_" 未维护表登记授权管理数据"
	s PowerTableDR=objPowerType.%Id()
    
    s return=""
    s xId=0
	for {
		s xId=$o(^DHCPEST(xId))
		q:xId=""
		q:return'=""
		
		s xSub=0
		for {
			s xSub=$o(^DHCPEST(xId,"STLOC",xSub))
			q:xSub=""
			q:return'=""
			
			s STLocId=xId_"||"_xSub
			s objSTL=##class(User.DHCPEStationLoc).%OpenId(STLocId)
			continue:'$IsObject(objSTL)
			d objSTL.%Close()
			
			//^DHCPEStationOrder("LocSort",站点分类ID,顺序号,Index)= 医嘱项ID
			//^DHCPEStationOrder("Loc",医嘱项ID)=站点分类ID_"^"_顺序号_"^"_ID
			s xSort=""
			for {
				s xSort=$o(^DHCPEStationOrder("LocSort",STLocId,xSort))
				q:xSort=""
				
				s xIndex=""
				for {
					s xIndex=$o(^DHCPEStationOrder("LocSort",STLocId,xSort,xIndex))
					q:xIndex=""
					
					s ARCIMID=$g(^DHCPEStationOrder("LocSort",STLocId,xSort,xIndex))
					continue:ARCIMID=""
					
					s STOrderSub=$o(^DHCPEST(0,"STORD_ARCIM",ARCIMID,xId,0))
					continue:STOrderSub=""
					s STOrderID=xId_"||"_STOrderSub
					
					//获取ID，这块比较特殊，注意下
					s ID=""
					s xOrdCatId=0
					for {
						s xOrdCatId=$o(^CF.PE.StationOrdSortI("ORD","IdxOfOrderDR",STOrderID,xOrdCatId))
						q:xOrdCatId=""
						q:ID'=""
						
						s xOrderSub=0
						for {
							s xOrderSub=$o(^CF.PE.StationOrdSortI("ORD","IdxOfOrderDR",STOrderID,xOrdCatId,xOrderSub))
							q:xOrderSub=""
							q:ID'=""
							
							continue:'$d(^CF.PE.PowerControlI("IdxOfLocGrpPower",PowerTableDR,xOrdCatId_"||"_xOrderSub,aLGLocID))
							s ID=xOrdCatId_"||"_xOrderSub
							q
						}
					}
					
					if ID="" {
						s obj=##class(User.DHCPEStationOrderSort).%New()
					} else {
						s obj=##class(User.DHCPEStationOrderSort).%OpenId(ID)
					}
					continue:'$IsObject(obj)
					d obj.ParRefSetObjectId(+ID)
					d obj.SOSOrderDRSetObjectId(STOrderID)
					s obj.SOSSort    = xSort
					s sc=obj.%Save()
					if $system.Status.IsError(sc) {        //检查Save是否成功
				   		d $system.OBJ.DisplayError(sc)
				   		s return=aTableName_" 新建表数据迁移报错"
				   		q
					}
					d obj.%Close()
					s ID=obj.%Id()
					
					s flg=##class(User.DHCPEStationOrderSort).SaveDataToPowerControl(ID,aLGLocID,aUserID)
					if (+flg)<1 {
						s return=aTableName_" 表记录授权报错"
					}
				}
			}
		}
	}
	q return
}

/// DHC_PE_StationOrdCatSort--新建表，私有
ClassMethod toStationOrdCatSort(aTableName As %String, aLGLocID As %String, aUserID As %String, aLocIDs As %String) As %String
{
    n (aTableName,aLGLocID,aUserID,aLocIDs)
    
    s objPowerType=##class(User.DHCPEStationOrdCatSort).GetPowerTypeObj()
    q:'$IsObject(objPowerType) aTableName_" 未维护表登记授权管理数据"
	q:objPowerType.PTPowerType'="S" aTableName_" 未维护表登记授权管理数据"
	s PowerTableDR=objPowerType.%Id()
    
    s return=""
    s xId=0
	for {
		s xId=$o(^DHCPEST(xId))
		q:xId=""
		q:return'=""
		
		s xSub=0
		for {
			s xSub=$o(^DHCPEST(xId,"STLOC",xSub))
			q:xSub=""
			q:return'=""
			
			s STLocId=xId_"||"_xSub
			s objSTL=##class(User.DHCPEStationLoc).%OpenId(STLocId)
			continue:'$IsObject(objSTL)
			d objSTL.%Close()
			
			//获取ID，这块比较特殊，注意下
			s ID=""
			s xOrdCatId=0
			for {
				s xOrdCatId=$o(^CF.PE.StationOrdSortI("IdxOfOrdCatDR",STLocId,xOrdCatId))
				q:xOrdCatId=""
				q:ID'=""
				
				continue:'$d(^CF.PE.PowerControlI("IdxOfLocGrpPower",PowerTableDR,xOrdCatId,aLGLocID))
				s ID=xOrdCatId
				q
			}
			
			if ID="" {
				s obj=##class(User.DHCPEStationOrdCatSort).%New()
			} else {
				s obj=##class(User.DHCPEStationOrdCatSort).%OpenId(ID)
			}
			continue:'$IsObject(obj)
			s obj.SOCSOrdCatDR     = objSTL
			s obj.SOCSSort         = objSTL.STLLocSort
			s sc=obj.%Save()
			if $system.Status.IsError(sc) {        //检查Save是否成功
		   		d $system.OBJ.DisplayError(sc)
		   		s return=aTableName_" 新建表数据迁移报错"
		   		q
			}
			d obj.%Close()
			s ID=obj.%Id()
			
			s flg=##class(User.DHCPEStationOrdCatSort).SaveDataToPowerControl(ID,aLGLocID,aUserID)
			if (+flg)<1 {
				s return=aTableName_" 表记录授权报错"
			}
		}
	}
	q return
}

/// DHC_PE_StationSet--新建表，绝对私有
ClassMethod toStationSet(aTableName As %String, aLGLocID As %String, aUserID As %String, aLocIDs As %String) As %String
{
    n (aTableName,aLGLocID,aUserID,aLocIDs)
    
    s objPowerType=##class(User.DHCPEStationSet).GetPowerTypeObj()
    q:'$IsObject(objPowerType) aTableName_" 未维护表登记授权管理数据"
	q:objPowerType.PTPowerType'="A" aTableName_" 未维护表登记授权管理数据"
	s PowerTableDR=objPowerType.%Id()
    
    s return=""
    s xId=0
	for {
		s xId=$o(^DHCPEST(xId))
		q:xId=""
		q:return'=""
		
		s objST=##class(User.DHCPEStation).%OpenId(xId)
		continue:'$IsObject(objST)
		d objST.%Close()
		
	    for idxLoc=1:1:$length(aLocIDs,",") {
		    s LocID=$p(aLocIDs,",",idxLoc)
		    continue:LocID=""
		    
			s ID=$o(^CF.PE.StationSetI("IdxOfLocStation"," "_LocID,xId,0))
			if ID="" {
				s obj=##class(User.DHCPEStationSet).%New()
			} else {
				s obj=##class(User.DHCPEStationSet).%OpenId(ID)
			}
			continue:'$IsObject(obj)
			s obj.SSStationDR      = objST
			s obj.SSLocDR          = LocID
			s obj.SSPlace          = objST.STPlace
			if $d(^DHCPECTDataEx("DHCPEStation",xId,"Place",LocID)) {
				s obj.SSPlace      = $g(^DHCPECTDataEx("DHCPEStation",xId,"Place",LocID))
			}
			s obj.SSSequence       = objST.STSequence
			s obj.SSAutoAudit      = objST.STAutoAudit
			s obj.SSLayoutType     = objST.STLayoutType
			s obj.SSButtonType     = objST.STButtonType
			s obj.SSReportSequence = objST.STReportSequence
			s obj.SSAllResultShow  = $g(^DHCPECTDataEx("DHCPEStation",xId,"AllResultShow",LocID))
			s obj.SSAllResultShow  = $s(obj.SSAllResultShow["Y":"Y",1:"N")
			s obj.SSActive         = objST.STActive
			s obj.SSUpdateDate     = +$h
			s obj.SSUpdateTime     = $p($h,",",2)
			s obj.SSUpdateUserDR   = aUserID
			s sc=obj.%Save()
			if $system.Status.IsError(sc) {        //检查Save是否成功
		   		d $system.OBJ.DisplayError(sc)
		   		s return=aTableName_" 新建表数据迁移报错"
		   		q
			}
			d obj.%Close()
			s ID=obj.%Id()
			
			s flg=##class(User.DHCPEStationSet).SaveDataToPowerControl(ID,LocID,aUserID)
			if (+flg)<1 {
				s return=aTableName_" 表记录授权报错"
			}
		}
	}
	q return
}

/// DHC_PE_ODStandard--新加字段，私有
ClassMethod toODStandard(aTableName As %String, aLGLocID As %String, aUserID As %String, aLocIDs As %String) As %String
{
    n (aTableName,aLGLocID,aUserID,aLocIDs)
    
    s objPowerType=##class(User.DHCPEODStandard).GetPowerTypeObj()
    q:'$IsObject(objPowerType) aTableName_" 未维护表登记授权管理数据"
	q:objPowerType.PTPowerType'="S" aTableName_" 未维护表登记授权管理数据"
	s PowerTableDR=objPowerType.%Id()
    
    s return=""
	s xId=0
	for {
		s xId=$o(^DHCPEST(xId))
		q:xId=""
		q:return'=""
		
		s xSub=0
		for {
			s xSub=$o(^DHCPEST(xId,"OD",xSub))
			q:xSub=""
			q:return'=""
			
			s xChild=0
			for {
				s xChild=$o(^DHCPEST(xId,"OD",xSub,"ODS",xChild))
				q:xChild=""
				q:return'=""
				
				s ID=xId_"||"_xSub_"||"_xChild
				
				s obj=##class(User.DHCPEODStandard).%OpenId(ID)
				continue:'$IsObject(obj)
				s obj.ODSHDValue = $g(^DHCPECTDataEx("DHCPEODStandard","HDValue",ID))
				s obj.ODSEyeSee  = $g(^DHCPECTDataEx("DHCPEODStandard","EyeSee",ID))
				s obj.ODSNoPrint = $g(^DHCPECTDataEx("DHCPEODStandard","NoPrint",ID))
				s obj.ODSNoPrint = $s(obj.ODSNoPrint["Y":"Y",1:"N")
				s obj.ODSSummary = $g(^DHCPECTDataEx("BaseData","ODStandard","ODS_Summary",ID))
				s obj.ODSSummary = $s(obj.ODSSummary["Y":"Y",1:"N")
				s obj.ODSDefault = $g(^DHCPECTDataEx("DHCPEODStandard","Default",ID))
				s obj.ODSDefault = $s(obj.ODSDefault["Y":"Y",1:"N")
				s obj.ODSNoActive       = "Y"
				s obj.ODSUpdateDate     = +$h
				s obj.ODSUpdateTime     = $p($h,",",2)
				s obj.ODSUpdateUserDR   = aUserID
				s sc=obj.%Save()
				if $system.Status.IsError(sc) {        //检查Save是否成功
			   		d $system.OBJ.DisplayError(sc)
			   		s return=aTableName_" 表字段补全报错"
			   		q
				}
				d obj.%Close()
				s ID=obj.%Id()
				
				s flg=##class(User.DHCPEODStandard).SaveDataToPowerControl(ID,aLGLocID,aUserID)
				if (+flg)<1 {
					s return=aTableName_" 表记录授权报错"
				}
			}
		}
	}
	q return
}

/// DHC_PE_OrderDetail--私有
ClassMethod toOrderDetail(aTableName As %String, aLGLocID As %String, aUserID As %String, aLocIDs As %String) As %String
{
    n (aTableName,aLGLocID,aUserID,aLocIDs)
    
    s objPowerType=##class(User.DHCPEOrderDetail).GetPowerTypeObj()
    q:'$IsObject(objPowerType) aTableName_" 未维护表登记授权管理数据"
	q:objPowerType.PTPowerType'="S" aTableName_" 未维护表登记授权管理数据"
	s PowerTableDR=objPowerType.%Id()
    
    s return=""
	s xId=0
	for {
		s xId=$o(^DHCPEST(xId))
		q:xId=""
		q:return'=""
		
		s xSub=0
		for {
			s xSub=$o(^DHCPEST(xId,"OD",xSub))
			q:xSub=""
			q:return'=""
			
			s ID=xId_"||"_xSub
			s flg=##class(User.DHCPEOrderDetail).SaveDataToPowerControl(ID,aLGLocID,aUserID)
			if (+flg)<1 {
				s return=aTableName_" 表记录授权报错"
			}
		}
	}
	q return
}

/// DHC_PE_StationOrder--私有
ClassMethod toStationOrder(aTableName As %String, aLGLocID As %String, aUserID As %String, aLocIDs As %String) As %String
{
    n (aTableName,aLGLocID,aUserID,aLocIDs)
    
    s objPowerType=##class(User.DHCPEStationOrder).GetPowerTypeObj()
    q:'$IsObject(objPowerType) aTableName_" 未维护表登记授权管理数据"
	q:objPowerType.PTPowerType'="S" aTableName_" 未维护表登记授权管理数据"
	s PowerTableDR=objPowerType.%Id()
    
    s return=""
	s xId=0
	for {
		s xId=$o(^DHCPEST(xId))
		q:xId=""
		q:return'=""
		
		s xSub=0
		for {
			s xSub=$o(^DHCPEST(xId,"O",xSub))
			q:xSub=""
			q:return'=""
			
			s ID=xId_"||"_xSub
			s flg=##class(User.DHCPEStationOrder).SaveDataToPowerControl(ID,aLGLocID,aUserID)
			if (+flg)<1 {
				s return=aTableName_" 表记录授权报错"
			}
		}
	}
	q return
}

/// 获取科室组默认科室方法
/// w ##class(web.DHCPE.Upgrade.CodeTableSrv).GetLGLocID()
ClassMethod GetLGLocID()
{
	n
	s return=""
	
    s xId=0
    for {
	    s xId=$o(^CF.PE.LocGrpConfigD(xId))
	    q:xId=""
	    
	    s tLocID=$lg($g(^CF.PE.LocGrpConfigD(xId)),2)
	    s tLGLocID=$lg($g(^CF.PE.LocGrpConfigD(xId)),3)
	    s tActive=$lg($g(^CF.PE.LocGrpConfigD(xId)),5)
	    continue:tActive'="Y"
	    continue:$listfind(return,tLGLocID)>0
	    s return=return_$lb(tLGLocID)
	}
	q $listtostring(return,",")
}

/// 获取科室组配置体检中心ID方法
/// w ##class(web.DHCPE.Upgrade.CodeTableSrv).GetLocIDs()
ClassMethod GetLocIDs()
{
	n
	s return=""
	
    s xId=0
    for {
	    s xId=$o(^CF.PE.LocGrpConfigD(xId))
	    q:xId=""
	    
	    s tLocID=$lg($g(^CF.PE.LocGrpConfigD(xId)),2)
	    s tLGLocID=$lg($g(^CF.PE.LocGrpConfigD(xId)),3)
	    s tActive=$lg($g(^CF.PE.LocGrpConfigD(xId)),5)
	    continue:tActive'="Y"
	    continue:$listfind(return,tLocID)>0
	    s return=return_$lb(tLocID)
	}
	q $listtostring(return,",")
}

/// w ##class(web.DHCPE.Upgrade.CodeTableSrv).KillTestData()
ClassMethod KillTestData()
{
	k ^CT.PE.PowerTableListD
	k ^CT.PE.PowerTableListI
	k ^CT.PE.VIPLevelD
	k ^CT.PE.VIPLevelI
	k ^CF.PE.CTUpdateLogD
	k ^CF.PE.CTUpdateLogI
	k ^CF.PE.ChargeLimitD
	k ^CF.PE.ChargeLimitI
	k ^CF.PE.ChartAssignD
	k ^CF.PE.ChartAssignI
	k ^CF.PE.ILLSExplainD
	k ^CF.PE.ILLSSportGuideD
	k ^CF.PE.LocGrpConfigD
	k ^CF.PE.LocGrpConfigI
	k ^CF.PE.LocVIPLevelD
	k ^CF.PE.LocVIPLevelI
	k ^CF.PE.OrderDetailSetD
	k ^CF.PE.OrderDetailSetI
	k ^CF.PE.OthPatToHPBaseD
	k ^CF.PE.OthPatToHPBaseI
	k ^CF.PE.PowerControlD
	k ^CF.PE.PowerControlI
	k ^CF.PE.PowerSuperUserD
	k ^CF.PE.PowerSuperUserI
	k ^CF.PE.RoomPlaceD
	k ^CF.PE.StationOrdSortD
	k ^CF.PE.StationOrderSetD
	k ^CF.PE.StationOrderSetI
	k ^CF.PE.StationSetD
	k ^CF.PE.StationSetI
	k ^CF.PE.UsherItemCatD
	k ^CF.PE.UsherItemCatI
	q "OK!!!"
}

}
