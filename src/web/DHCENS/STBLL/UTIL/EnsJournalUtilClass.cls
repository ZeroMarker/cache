Class web.DHCENS.STBLL.UTIL.EnsJournalUtilClass Extends (%RegisteredObject, %XML.Adaptor)
{

/// 发布ODS相关方法类
/// w ##class(web.DHCENS.STBLL.UTIL.EnsJournalUtilClass).DeployClasses()
ClassMethod DeployClasses() As %String
{
	d $system.OBJ.MakeClassDeployed("web.DHCENS.STBLL.UTIL.EnsJournalConfig")
	d $system.OBJ.MakeClassDeployed("web.DHCENS.STBLL.UTIL.EnsJournalLog")
	d $system.OBJ.MakeClassDeployed("web.DHCENS.STBLL.UTIL.EnsJournalResult")
	d $system.OBJ.MakeClassDeployed("web.DHCENS.STBLL.UTIL.EnsSendDataInfo")
	d $system.OBJ.MakeClassDeployed("web.DHCENS.STBLL.UTIL.EnsServiceLinkClass")
	d $system.OBJ.MakeClassDeployed("web.DHCENS.STBLL.UTIL.EnsWebServiceClient")
	d $system.OBJ.MakeClassDeployed("web.DHCENS.STBLL.UTIL.RemoteJournalConfig")
	q 1
}

/// 维护推送目标
/// w ##class(web.DHCENS.STBLL.UTIL.EnsJournalUtilClass).ManualRegister()
ClassMethod ManualRegister() As %String
{
	//事件状态_$c(2)_服务代码_$c(2)_事件名称_$c(2)_备注_$c(2)_ip_$c(2,2)_服务地址_$c(2)_服务名称_$c(2)_包名
	s Input="add"_$c(2)_"HDC"_$c(2)_"数据中心"_$c(2)_"备注"_$c(2)_"10.58.1.126"_$c(2,2)_"http://10.58.1.126/csp/hdcv2/hdc.service.WebHDCEnsInterfaceService.CLS?WSDL=1"_$c(2)_"数据中心"_$c(2)_"web.DHCENS.SOAP"_$c(2,2,2)_"DHCENS"_$c(2)_"Y"_$c(2)_"java"
	//s Input="add"_$c(2)_"MDM"_$c(2)_"主数据"_$c(2)_"备注"_$c(2)_"172.21.234.41"_$c(2,2)_"http://172.21.234.41/csp/mdm/mdm.Service.AcceptODSInfo.CLS?WSDL=1"_$c(2)_"数据中心"_$c(2)_"web.DHCENS.SOAP"_$c(2,2,2)_"DHCENS"_$c(2)_"Y"_$c(2)_"java"
	s return=##class(web.DHCENS.STBLL.UTIL.EnsWebServiceClient).SaveEnsWebServiceClientInfo(Input)
	b ;;
	q return
}

/// MDM监听表及推送配置  ExtFlag Y
/// w ##class(web.DHCENS.STBLL.UTIL.EnsJournalUtilClass).MDMDataConfig()
ClassMethod MDMDataConfig(classNS As %String = "") As %String
{
	if classNS="" s classNS="DHC-APP"
	w ##class(web.DHCENS.STBLL.UTIL.EnsJournalConfig).RelationGlobalAndClass("User.PAPatMas^Y^患者基本信息表",classNS)
	w ##class(web.DHCENS.STBLL.UTIL.EnsServiceLinkClass).InsertEnsServiceLinkClass("User.PAPatMas","MDM")
    w "患者基本信息表成功！",!
	w ##class(web.DHCENS.STBLL.UTIL.EnsJournalConfig).RelationGlobalAndClass("User.PACBed^Y^床位字典表",classNS)
    w ##class(web.DHCENS.STBLL.UTIL.EnsServiceLinkClass).InsertEnsServiceLinkClass("User.PACBed","MDM")
    w "床位字典表成功！",!
    w ##class(web.DHCENS.STBLL.UTIL.EnsJournalConfig).RelationGlobalAndClass("User.PACBedType^Y^床位类型字典表",classNS)
    w ##class(web.DHCENS.STBLL.UTIL.EnsServiceLinkClass).InsertEnsServiceLinkClass("User.PACBedType","MDM")
    w "床位类型字典表成功！",!
    w ##class(web.DHCENS.STBLL.UTIL.EnsJournalConfig).RelationGlobalAndClass("User.OECOrderCategory^Y^医嘱大类字典表",classNS)
    w ##class(web.DHCENS.STBLL.UTIL.EnsServiceLinkClass).InsertEnsServiceLinkClass("User.OECOrderCategory","MDM")
    w "医嘱大类字典表成功！",!
    w ##class(web.DHCENS.STBLL.UTIL.EnsJournalConfig).RelationGlobalAndClass("User.ARCItemCat^Y^医嘱子类字典表",classNS)
    w ##class(web.DHCENS.STBLL.UTIL.EnsServiceLinkClass).InsertEnsServiceLinkClass("User.ARCItemCat","MDM")
    w "医嘱子类字典表成功！",!
    w ##class(web.DHCENS.STBLL.UTIL.EnsJournalConfig).RelationGlobalAndClass("User.CTProvince^Y^省字典表",classNS)
    w ##class(web.DHCENS.STBLL.UTIL.EnsServiceLinkClass).InsertEnsServiceLinkClass("User.CTProvince","MDM")
    w "省字典表成功！",!
    w ##class(web.DHCENS.STBLL.UTIL.EnsJournalConfig).RelationGlobalAndClass("User.CTCity^Y^市字典表",classNS)
    w ##class(web.DHCENS.STBLL.UTIL.EnsServiceLinkClass).InsertEnsServiceLinkClass("User.CTCity","MDM")
    w "市字典表成功！",!
    w ##class(web.DHCENS.STBLL.UTIL.EnsJournalConfig).RelationGlobalAndClass("User.CTCountry^Y^国家字典表",classNS)
    w ##class(web.DHCENS.STBLL.UTIL.EnsServiceLinkClass).InsertEnsServiceLinkClass("User.CTCountry","MDM")
    w "国家字典表成功！",!
    w ##class(web.DHCENS.STBLL.UTIL.EnsJournalConfig).RelationGlobalAndClass("User.CTCityArea^Y^县区字典表",classNS)
    w ##class(web.DHCENS.STBLL.UTIL.EnsServiceLinkClass).InsertEnsServiceLinkClass("User.CTCityArea","MDM")
    w "县区字典表成功！",!
    w ##class(web.DHCENS.STBLL.UTIL.EnsJournalConfig).RelationGlobalAndClass("User.RBCDepartmentGroup^Y^科室部门组字典表",classNS)
    w ##class(web.DHCENS.STBLL.UTIL.EnsServiceLinkClass).InsertEnsServiceLinkClass("User.RBCDepartmentGroup","MDM")
    w "科室部门组字典表成功！",!
    w ##class(web.DHCENS.STBLL.UTIL.EnsJournalConfig).RelationGlobalAndClass("User.CTLoc^Y^科室字典表",classNS)
    w ##class(web.DHCENS.STBLL.UTIL.EnsServiceLinkClass).InsertEnsServiceLinkClass("User.CTLoc","MDM")
    w "科室字典表成功！",!
    w ##class(web.DHCENS.STBLL.UTIL.EnsJournalConfig).RelationGlobalAndClass("User.MRCDiagnosType^Y^诊断类型字典表",classNS)
    w ##class(web.DHCENS.STBLL.UTIL.EnsServiceLinkClass).InsertEnsServiceLinkClass("User.MRCDiagnosType","MDM")
    w "诊断类型字典表成功！",!
    w ##class(web.DHCENS.STBLL.UTIL.EnsJournalConfig).RelationGlobalAndClass("User.MRCICDDx^Y^诊断字典表",classNS)
    w ##class(web.DHCENS.STBLL.UTIL.EnsServiceLinkClass).InsertEnsServiceLinkClass("User.MRCICDDx","MDM")
    w "诊断字典表成功！",!
    w ##class(web.DHCENS.STBLL.UTIL.EnsJournalConfig).RelationGlobalAndClass("User.PACWard^Y^病区字典表",classNS)
    w ##class(web.DHCENS.STBLL.UTIL.EnsServiceLinkClass).InsertEnsServiceLinkClass("User.PACWard","MDM")
    w "病区字典表成功！",!
    w ##class(web.DHCENS.STBLL.UTIL.EnsJournalConfig).RelationGlobalAndClass("User.PACDischCondit^Y^出院情况字典表",classNS)
    w ##class(web.DHCENS.STBLL.UTIL.EnsServiceLinkClass).InsertEnsServiceLinkClass("User.PACDischCondit","MDM")
    w "出院情况字典表成功！",!
    w ##class(web.DHCENS.STBLL.UTIL.EnsJournalConfig).RelationGlobalAndClass("User.PHCForm^Y^剂型字典表",classNS)
    w ##class(web.DHCENS.STBLL.UTIL.EnsServiceLinkClass).InsertEnsServiceLinkClass("User.PHCForm","MDM")
    w "剂型字典表成功！",!
    w ##class(web.DHCENS.STBLL.UTIL.EnsJournalConfig).RelationGlobalAndClass("User.CTUOM^Y^剂量单位字典表",classNS)
    w ##class(web.DHCENS.STBLL.UTIL.EnsServiceLinkClass).InsertEnsServiceLinkClass("User.CTUOM","MDM")
    w "剂量单位字典表成功！",!
    w ##class(web.DHCENS.STBLL.UTIL.EnsJournalConfig).RelationGlobalAndClass("User.PHCDuration^Y^疗程字典表",classNS)
    w ##class(web.DHCENS.STBLL.UTIL.EnsServiceLinkClass).InsertEnsServiceLinkClass("User.PHCDuration","MDM")
    w "疗程字典表成功！",!
    w ##class(web.DHCENS.STBLL.UTIL.EnsJournalConfig).RelationGlobalAndClass("User.PACBed^Y^床位字典表",classNS)
    w ##class(web.DHCENS.STBLL.UTIL.EnsServiceLinkClass).InsertEnsServiceLinkClass("User.PACBed","MDM")
    w "床位字典表成功！",!
    w ##class(web.DHCENS.STBLL.UTIL.EnsJournalConfig).RelationGlobalAndClass("User.PHCFreq^Y^频次字典表",classNS)
    w ##class(web.DHCENS.STBLL.UTIL.EnsServiceLinkClass).InsertEnsServiceLinkClass("User.PHCFreq","MDM")
    w "频次字典表成功！",!
    w ##class(web.DHCENS.STBLL.UTIL.EnsJournalConfig).RelationGlobalAndClass("User.PACCardType^Y^证件类型字典表",classNS)
    w ##class(web.DHCENS.STBLL.UTIL.EnsServiceLinkClass).InsertEnsServiceLinkClass("User.PACCardType","MDM")
    w "证件类型字典表成功！",!
    w ##class(web.DHCENS.STBLL.UTIL.EnsJournalConfig).RelationGlobalAndClass("User.PHCInstruc^Y^用法单位字典表",classNS)
    w ##class(web.DHCENS.STBLL.UTIL.EnsServiceLinkClass).InsertEnsServiceLinkClass("User.PHCInstruc","MDM")
    w "用法单位字典表成功！",!
    w ##class(web.DHCENS.STBLL.UTIL.EnsJournalConfig).RelationGlobalAndClass("User.CTMarital^Y^婚姻字典表",classNS)
    w ##class(web.DHCENS.STBLL.UTIL.EnsServiceLinkClass).InsertEnsServiceLinkClass("User.CTMarital","MDM")
    w "婚姻字典表成功！",!
    w ##class(web.DHCENS.STBLL.UTIL.EnsJournalConfig).RelationGlobalAndClass("User.CTNation^Y^民族字典表",classNS)
    w ##class(web.DHCENS.STBLL.UTIL.EnsServiceLinkClass).InsertEnsServiceLinkClass("User.CTNation","MDM")
    w "民族字典表成功！",!
    w ##class(web.DHCENS.STBLL.UTIL.EnsJournalConfig).RelationGlobalAndClass("User.CTOccupation^Y^职业字典表",classNS)
    w ##class(web.DHCENS.STBLL.UTIL.EnsServiceLinkClass).InsertEnsServiceLinkClass("User.CTOccupation","MDM")
    w "职业字典表成功！",!
    w ##class(web.DHCENS.STBLL.UTIL.EnsJournalConfig).RelationGlobalAndClass("User.OECOrderStatus^Y^医嘱状态字典表",classNS)
    w ##class(web.DHCENS.STBLL.UTIL.EnsServiceLinkClass).InsertEnsServiceLinkClass("User.OECOrderStatus","MDM")
    w "医嘱状态字典表成功！",!
    w ##class(web.DHCENS.STBLL.UTIL.EnsJournalConfig).RelationGlobalAndClass("User.OECPriority^Y^医嘱类别字典表",classNS)
    w ##class(web.DHCENS.STBLL.UTIL.EnsServiceLinkClass).InsertEnsServiceLinkClass("User.OECPriority","MDM")
    w "医嘱类别字典表成功！",!
    w ##class(web.DHCENS.STBLL.UTIL.EnsJournalConfig).RelationGlobalAndClass("User.CTRelation^Y^联系人关系字典表",classNS)
    w ##class(web.DHCENS.STBLL.UTIL.EnsServiceLinkClass).InsertEnsServiceLinkClass("User.CTRelation","MDM")
    w "联系人关系字典表成功！",!
    w ##class(web.DHCENS.STBLL.UTIL.EnsJournalConfig).RelationGlobalAndClass("User.EnsStatusCode^Y^检查检验状态字典表",classNS)
    w ##class(web.DHCENS.STBLL.UTIL.EnsServiceLinkClass).InsertEnsServiceLinkClass("User.EnsStatusCode","MDM")
    w "检查检验状态字典表成功！",!
    w ##class(web.DHCENS.STBLL.UTIL.EnsJournalConfig).RelationGlobalAndClass("User.PACRoomType^Y^房间类型字典表",classNS)
    w ##class(web.DHCENS.STBLL.UTIL.EnsServiceLinkClass).InsertEnsServiceLinkClass("User.PACRoomType","MDM")
    w "房间类型字典表成功！",!
    w ##class(web.DHCENS.STBLL.UTIL.EnsJournalConfig).RelationGlobalAndClass("User.PACRoom^Y^房间字典表",classNS)
    w ##class(web.DHCENS.STBLL.UTIL.EnsServiceLinkClass).InsertEnsServiceLinkClass("User.PACRoom","MDM")
    w "房间字典表成功！",!
    w ##class(web.DHCENS.STBLL.UTIL.EnsJournalConfig).RelationGlobalAndClass("User.CTSex^Y^性别字典表",classNS)
    w ##class(web.DHCENS.STBLL.UTIL.EnsServiceLinkClass).InsertEnsServiceLinkClass("User.CTSex","MDM")
    w "性别字典表成功！",!
    w ##class(web.DHCENS.STBLL.UTIL.EnsJournalConfig).RelationGlobalAndClass("User.CTSpecimen^Y^标本类型字典表",classNS)
    w ##class(web.DHCENS.STBLL.UTIL.EnsServiceLinkClass).InsertEnsServiceLinkClass("User.CTSpecimen","MDM")
    w "标本类型字典表成功！",!
    w ##class(web.DHCENS.STBLL.UTIL.EnsJournalConfig).RelationGlobalAndClass("User.SSUser^Y^医护人员字典表",classNS)
    w ##class(web.DHCENS.STBLL.UTIL.EnsServiceLinkClass).InsertEnsServiceLinkClass("User.SSUser","MDM")
    w "医护人员字典表成功！",!
    w ##class(web.DHCENS.STBLL.UTIL.EnsJournalConfig).RelationGlobalAndClass("User.ORCAnaestMethod^Y^麻醉方式字典表",classNS)
    w ##class(web.DHCENS.STBLL.UTIL.EnsServiceLinkClass).InsertEnsServiceLinkClass("User.ORCAnaestMethod","MDM")
    w "麻醉方式字典表成功！",!
    w ##class(web.DHCENS.STBLL.UTIL.EnsJournalConfig).RelationGlobalAndClass("User.DHCTarAC^Y^会计大类字典表",classNS)
    w ##class(web.DHCENS.STBLL.UTIL.EnsServiceLinkClass).InsertEnsServiceLinkClass("User.DHCTarAC","MDM")
    w "会计大类字典表成功！",!
    w ##class(web.DHCENS.STBLL.UTIL.EnsJournalConfig).RelationGlobalAndClass("User.DHCTarAcctCate^Y^会计子类字典表",classNS)
    w ##class(web.DHCENS.STBLL.UTIL.EnsServiceLinkClass).InsertEnsServiceLinkClass("User.DHCTarAcctCate","MDM")
    w "会计子类字典表成功！",!
    w ##class(web.DHCENS.STBLL.UTIL.EnsJournalConfig).RelationGlobalAndClass("User.ARCBillGrp^Y^账单大类字典表",classNS)
    w ##class(web.DHCENS.STBLL.UTIL.EnsServiceLinkClass).InsertEnsServiceLinkClass("User.ARCBillGrp","MDM")
    w "账单大类字典表成功！",!
    w ##class(web.DHCENS.STBLL.UTIL.EnsJournalConfig).RelationGlobalAndClass("User.ARCBillSub^Y^账单子类字典表",classNS)
    w ##class(web.DHCENS.STBLL.UTIL.EnsServiceLinkClass).InsertEnsServiceLinkClass("User.ARCBillSub","MDM")
    w "账单子类字典表成功！",!
    w ##class(web.DHCENS.STBLL.UTIL.EnsJournalConfig).RelationGlobalAndClass("User.DHCCardTypeDef^Y^卡类型字典表",classNS)
    w ##class(web.DHCENS.STBLL.UTIL.EnsServiceLinkClass).InsertEnsServiceLinkClass("User.DHCCardTypeDef","MDM")
    w "卡类型字典表成功！",!
    w ##class(web.DHCENS.STBLL.UTIL.EnsJournalConfig).RelationGlobalAndClass("User.CTCarPrvTp^Y^医护人员类型字典表",classNS)
    w ##class(web.DHCENS.STBLL.UTIL.EnsServiceLinkClass).InsertEnsServiceLinkClass("User.CTCarPrvTp","MDM")
    w "医护人员类型字典表成功！",!
    w ##class(web.DHCENS.STBLL.UTIL.EnsJournalConfig).RelationGlobalAndClass("User.DHCTarCate^Y^收费项大类字典表",classNS)
    w ##class(web.DHCENS.STBLL.UTIL.EnsServiceLinkClass).InsertEnsServiceLinkClass("User.DHCTarCate","MDM")
    w "收费项大类字典表成功！",!
    w ##class(web.DHCENS.STBLL.UTIL.EnsJournalConfig).RelationGlobalAndClass("User.DHCTarSubCate^Y^收费项子类字典表",classNS)
    w ##class(web.DHCENS.STBLL.UTIL.EnsServiceLinkClass).InsertEnsServiceLinkClass("User.DHCTarSubCate","MDM")
    w "收费项子类字典表成功！",!
    w ##class(web.DHCENS.STBLL.UTIL.EnsJournalConfig).RelationGlobalAndClass("User.PACAdmReason^Y^患者费别字典表",classNS)
    w ##class(web.DHCENS.STBLL.UTIL.EnsServiceLinkClass).InsertEnsServiceLinkClass("User.PACAdmReason","MDM")
    w "患者费别字典表成功！",!
    w ##class(web.DHCENS.STBLL.UTIL.EnsJournalConfig).RelationGlobalAndClass("User.CTLocLinkLocation^Y^科室病区关联字典表",classNS)
    w ##class(web.DHCENS.STBLL.UTIL.EnsServiceLinkClass).InsertEnsServiceLinkClass("User.CTLocLinkLocation","MDM")
    w "科室病区关联字典表成功！",!
    w ##class(web.DHCENS.STBLL.UTIL.EnsJournalConfig).RelationGlobalAndClass("User.DHCTarEC^Y^核算大类字典表",classNS)
    w ##class(web.DHCENS.STBLL.UTIL.EnsServiceLinkClass).InsertEnsServiceLinkClass("User.DHCTarEC","MDM")
    w "核算大类字典表成功！",!
    w ##class(web.DHCENS.STBLL.UTIL.EnsJournalConfig).RelationGlobalAndClass("User.DHCTarEMCCate^Y^核算子类字典表",classNS)
    w ##class(web.DHCENS.STBLL.UTIL.EnsServiceLinkClass).InsertEnsServiceLinkClass("User.DHCTarEMCCate","MDM")
    w "核算子类字典表成功！",!
    w ##class(web.DHCENS.STBLL.UTIL.EnsJournalConfig).RelationGlobalAndClass("User.DHCTarIC^Y^住院大类字典表",classNS)
    w ##class(web.DHCENS.STBLL.UTIL.EnsServiceLinkClass).InsertEnsServiceLinkClass("User.DHCTarIC","MDM")
    w "住院大类字典表成功！",!
    w ##class(web.DHCENS.STBLL.UTIL.EnsJournalConfig).RelationGlobalAndClass("User.DHCTarInpatCate^Y^住院子类字典表",classNS)
    w ##class(web.DHCENS.STBLL.UTIL.EnsServiceLinkClass).InsertEnsServiceLinkClass("User.DHCTarInpatCate","MDM")
    w "住院子类字典表成功！",!
    w ##class(web.DHCENS.STBLL.UTIL.EnsJournalConfig).RelationGlobalAndClass("User.DHCTarMC^Y^病案大类字典表",classNS)
    w ##class(web.DHCENS.STBLL.UTIL.EnsServiceLinkClass).InsertEnsServiceLinkClass("User.DHCTarMC","MDM")
    w "病案大类字典表成功！",!
    w ##class(web.DHCENS.STBLL.UTIL.EnsJournalConfig).RelationGlobalAndClass("User.DHCTarMRCate^Y^病案子类字典表",classNS)
    w ##class(web.DHCENS.STBLL.UTIL.EnsServiceLinkClass).InsertEnsServiceLinkClass("User.DHCTarMRCate","MDM")
    w "病案子类字典表成功！",!
    w ##class(web.DHCENS.STBLL.UTIL.EnsJournalConfig).RelationGlobalAndClass("User.DHCTarOC^Y^门诊大类字典表",classNS)
    w ##class(web.DHCENS.STBLL.UTIL.EnsServiceLinkClass).InsertEnsServiceLinkClass("User.DHCTarOC","MDM")
    w "门诊大类字典表成功！",!
    w ##class(web.DHCENS.STBLL.UTIL.EnsJournalConfig).RelationGlobalAndClass("User.DHCTarOutpatCate^Y^门诊子类字典表",classNS)
    w ##class(web.DHCENS.STBLL.UTIL.EnsServiceLinkClass).InsertEnsServiceLinkClass("User.DHCTarOutpatCate","MDM")
    w "门诊子类字典表成功！",!
    w ##class(web.DHCENS.STBLL.UTIL.EnsJournalConfig).RelationGlobalAndClass("User.ORCOperationCategory^Y^手术级别字典表",classNS)
    w ##class(web.DHCENS.STBLL.UTIL.EnsServiceLinkClass).InsertEnsServiceLinkClass("User.ORCOperationCategory","MDM")
    w "手术级别字典表成功！",!
    w ##class(web.DHCENS.STBLL.UTIL.EnsJournalConfig).RelationGlobalAndClass("User.OECBodySite^Y^手术部位字典表",classNS)
    w ##class(web.DHCENS.STBLL.UTIL.EnsServiceLinkClass).InsertEnsServiceLinkClass("User.OECBodySite","MDM")
    w "手术部位字典表成功！",!
    w ##class(web.DHCENS.STBLL.UTIL.EnsJournalConfig).RelationGlobalAndClass("User.ORCOperPosition^Y^手术体位字典表",classNS)
    w ##class(web.DHCENS.STBLL.UTIL.EnsServiceLinkClass).InsertEnsServiceLinkClass("User.ORCOperPosition","MDM")
    w "手术体位字典表成功！",!
    w ##class(web.DHCENS.STBLL.UTIL.EnsJournalConfig).RelationGlobalAndClass("User.CTSocialStatus^Y^患者身份字典表",classNS)
    w ##class(web.DHCENS.STBLL.UTIL.EnsServiceLinkClass).InsertEnsServiceLinkClass("User.CTSocialStatus","MDM")
    w "患者身份字典表成功！",!
    w ##class(web.DHCENS.STBLL.UTIL.EnsJournalConfig).RelationGlobalAndClass("User.PHCGeneric^Y^药品通用名表",classNS)
    w ##class(web.DHCENS.STBLL.UTIL.EnsServiceLinkClass).InsertEnsServiceLinkClass("User.PHCGeneric","MDM")
    w "药品通用名表成功！",!
    w ##class(web.DHCENS.STBLL.UTIL.EnsJournalConfig).RelationGlobalAndClass("User.PHCPoison^Y^药品管制分类表",classNS)
    w ##class(web.DHCENS.STBLL.UTIL.EnsServiceLinkClass).InsertEnsServiceLinkClass("User.PHCPoison","MDM")
    w "药品管制分类表成功！",!
    w ##class(web.DHCENS.STBLL.UTIL.EnsJournalConfig).RelationGlobalAndClass("User.PHCDrgMast^Y^药学项字典表",classNS)
    w ##class(web.DHCENS.STBLL.UTIL.EnsServiceLinkClass).InsertEnsServiceLinkClass("User.PHCDrgMast","MDM")
    w "药学项字典表成功！",!
    w ##class(web.DHCENS.STBLL.UTIL.EnsJournalConfig).RelationGlobalAndClass("User.PHManufacturer^Y^生产厂商字典表",classNS)
    w ##class(web.DHCENS.STBLL.UTIL.EnsServiceLinkClass).InsertEnsServiceLinkClass("User.PHManufacturer","MDM")
    w "生产厂商字典表成功！",!
    w ##class(web.DHCENS.STBLL.UTIL.EnsJournalConfig).RelationGlobalAndClass("User.CTReligion^Y^宗教字典表",classNS)
    w ##class(web.DHCENS.STBLL.UTIL.EnsServiceLinkClass).InsertEnsServiceLinkClass("User.CTReligion","MDM")
    w "宗教字典表成功！",!
    w ##class(web.DHCENS.STBLL.UTIL.EnsJournalConfig).RelationGlobalAndClass("User.DHCCarrier^Y^配送商字典表",classNS)
    w ##class(web.DHCENS.STBLL.UTIL.EnsServiceLinkClass).InsertEnsServiceLinkClass("User.DHCCarrier","MDM")
    w "配送商字典表成功！",!
    w ##class(web.DHCENS.STBLL.UTIL.EnsJournalConfig).RelationGlobalAndClass("User.DHCSTOrigin^Y^产地字典表",classNS)
    w ##class(web.DHCENS.STBLL.UTIL.EnsServiceLinkClass).InsertEnsServiceLinkClass("User.DHCSTOrigin","MDM")
    w "产地字典表成功！",!
    w ##class(web.DHCENS.STBLL.UTIL.EnsJournalConfig).RelationGlobalAndClass("User.APCVendor^Y^供应商字典表",classNS)
    w ##class(web.DHCENS.STBLL.UTIL.EnsServiceLinkClass).InsertEnsServiceLinkClass("User.APCVendor","MDM")
    w "供应商字典表成功！",!
    w ##class(web.DHCENS.STBLL.UTIL.EnsJournalConfig).RelationGlobalAndClass("User.DHCStkCatGroup^Y^库存类组字典表",classNS)
    w ##class(web.DHCENS.STBLL.UTIL.EnsServiceLinkClass).InsertEnsServiceLinkClass("User.DHCStkCatGroup","MDM")
    w "库存类组字典表成功！",!
    w ##class(web.DHCENS.STBLL.UTIL.EnsJournalConfig).RelationGlobalAndClass("User.DHCStkCatSubGrp^Y^库存分类字典表",classNS)
    w ##class(web.DHCENS.STBLL.UTIL.EnsServiceLinkClass).InsertEnsServiceLinkClass("User.DHCStkCatSubGrp","MDM")
    w "库存分类字典表成功！",!
    w ##class(web.DHCENS.STBLL.UTIL.EnsJournalConfig).RelationGlobalAndClass("User.CTCarPrvTp^Y^医生职称字典表",classNS)
    w ##class(web.DHCENS.STBLL.UTIL.EnsServiceLinkClass).InsertEnsServiceLinkClass("User.CTCarPrvTp","MDM")
    w "医生职称字典表成功！",!
    w ##class(web.DHCENS.STBLL.UTIL.EnsJournalConfig).RelationGlobalAndClass("User.DHCTarItem^Y^收费项字典表",classNS)
    w ##class(web.DHCENS.STBLL.UTIL.EnsServiceLinkClass).InsertEnsServiceLinkClass("User.DHCTarItem","MDM")
    w "收费项字典表成功！",!
    w ##class(web.DHCENS.STBLL.UTIL.EnsJournalConfig).RelationGlobalAndClass("User.ORCOperation^Y^手术字典表",classNS)
    w ##class(web.DHCENS.STBLL.UTIL.EnsServiceLinkClass).InsertEnsServiceLinkClass("User.ORCOperation","MDM")
    w "手术字典表成功！",!
    w ##class(web.DHCENS.STBLL.UTIL.EnsJournalConfig).RelationGlobalAndClass("User.ARCItmMast^Y^医嘱项字典表",classNS)
    w ##class(web.DHCENS.STBLL.UTIL.EnsServiceLinkClass).InsertEnsServiceLinkClass("User.ARCItmMast","MDM")
    w "医嘱项字典表成功！",!
    w ##class(web.DHCENS.STBLL.UTIL.EnsJournalConfig).RelationGlobalAndClass("User.PHCFormDoseEquiv^Y^等效单位字典表",classNS)
    w ##class(web.DHCENS.STBLL.UTIL.EnsServiceLinkClass).InsertEnsServiceLinkClass("User.PHCFormDoseEquiv","MDM")
    w "等效单位字典表成功！",!
	q "ok"
}

/// HDC监听表及推送配置  ExtFlag Y
/// w ##class(web.DHCENS.STBLL.UTIL.EnsJournalUtilClass).HDCDataConfig()
ClassMethod HDCDataConfig(classNS As %String = "") As %String
{
	if classNS="" s classNS="DHC-APP"
	w ##class(web.DHCENS.STBLL.UTIL.EnsJournalConfig).RelationGlobalAndClass("User.PAPatMas^Y^患者基本信息表",classNS)
	w ##class(web.DHCENS.STBLL.UTIL.EnsServiceLinkClass).InsertEnsServiceLinkClass("User.PAPatMas","HDC")
    w "患者基本信息表成功！",!
	w ##class(web.DHCENS.STBLL.UTIL.EnsJournalConfig).RelationGlobalAndClass("User.PAAdm^Y^就诊信息表",classNS)
	w ##class(web.DHCENS.STBLL.UTIL.EnsServiceLinkClass).InsertEnsServiceLinkClass("User.PAAdm","HDC")
    w "就诊信息表成功！",!
	w ##class(web.DHCENS.STBLL.UTIL.EnsJournalConfig).RelationGlobalAndClass("User.MRDiagnos^Y^诊断信息表",classNS)
	w ##class(web.DHCENS.STBLL.UTIL.EnsServiceLinkClass).InsertEnsServiceLinkClass("User.MRDiagnos","HDC")
    w "诊断信息表成功！",!
	w ##class(web.DHCENS.STBLL.UTIL.EnsJournalConfig).RelationGlobalAndClass("User.OEOrder^Y^医嘱主表",classNS)
	w ##class(web.DHCENS.STBLL.UTIL.EnsServiceLinkClass).InsertEnsServiceLinkClass("User.OEOrder","HDC")
    w "医嘱主表成功！",!
	w ##class(web.DHCENS.STBLL.UTIL.EnsJournalConfig).RelationGlobalAndClass("User.OEOrdItem^Y^医嘱明细表",classNS)
	w ##class(web.DHCENS.STBLL.UTIL.EnsServiceLinkClass).InsertEnsServiceLinkClass("User.OEOrdItem","HDC")
    w "医嘱明细表成功！",!
    
	//请根据需要自行添加 ... ...
    
	q "ok"
}

}
