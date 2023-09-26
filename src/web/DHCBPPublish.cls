Class web.DHCBPPublish
{

/// 添加血透使用的HIS菜单，该方法只在血透上线前搭建环境时执行
/// w ##class(web.DHCBPPublish).InitHisMenu()
ClassMethod InitHisMenu()
{
	do ..SaveHisMenu("System.MainMenu", "DHC.Clinic.BP.Side", "血液透析配置管理", "", "", "", "", "54", "SideMenu", "2015/2/12 0:00:00", "13:19:00", 1, "")
	do ..SaveHisMenu("DHC.Clinic.BP.Side", "dhcbpbedequip", "净化监护设备维护", "dhcbpbedequip.csp", "", "", "", "", "SideMenu", "2015/9/10 0:00:00", "9:09:29", 1, "")
	do ..SaveHisMenu("DHC.Clinic.BP.Side", "dhcbpcanticoagulantmode", "抗凝方式维护", "dhcbpcanticoagulantmode.csp", "", "", "", "", "SideMenu", "2015/1/23 0:00:00", "14:10:34", 1, "")
	do ..SaveHisMenu("DHC.Clinic.BP.Side", "dhcbpcbed", "床位信息维护", "dhcbpcbed.csp", "", "", "", "", "SideMenu", "2015/1/23 0:00:00", "14:11:25", 1, "")
	do ..SaveHisMenu("DHC.Clinic.BP.Side", "dhcbpcbedgroup", "床位组维护", "dhcbpcbedgroup.csp", "", "", "", "", "SideMenu", "2015/1/23 0:00:00", "14:12:23", 1, "")
	do ..SaveHisMenu("DHC.Clinic.BP.Side", "dhcbpcbloodpurificationmode", "血液净化方式", "dhcbpcbloodpurificationmode.csp", "", "", "", "", "SideMenu", "2015/1/23 0:00:00", "14:13:22", 1, "")
	do ..SaveHisMenu("DHC.Clinic.BP.Side", "dhcbpcconsumable", "材料码表维护", "dhcbpcconsumable.csp", "", "", "", "", "SideMenu", "2015/1/23 0:00:00", "14:14:06", 1, "")
	do ..SaveHisMenu("DHC.Clinic.BP.Side", "dhcbpcdeceasereason", "死亡原因", "dhcbpcdeceasereason.csp", "", "", "", "", "SideMenu", "2015/1/23 0:00:00", "14:14:56", 1, "")
	do ..SaveHisMenu("DHC.Clinic.BP.Side", "dhcbpcequip", "净化设备维护-停用", "dhcbpcequip.csp", "", "", "", "", "SideMenu", "2015/9/10 0:00:00", "8:44:20", 1, "")
	do ..SaveHisMenu("DHC.Clinic.BP.Side", "dhcbpcequipmodel", "净化设备型号维护", "dhcbpcequipmodel.csp", "", "", "", "", "SideMenu", "2015/1/23 0:00:00", "14:16:32", 1, "")
	do ..SaveHisMenu("DHC.Clinic.BP.Side", "dhcbpcequippart", "设备配件维护", "dhcbpcequippart.csp", "", "", "", "", "SideMenu", "2015/1/23 0:00:00", "14:17:14", 1, "")
	do ..SaveHisMenu("DHC.Clinic.BP.Side", "dhcbpcequiprunmode", "透析设备运行模式", "dhcbpcequiprunmode.csp", "", "", "", "", "SideMenu", "2015/1/23 0:00:00", "14:20:58", 1, "")
	do ..SaveHisMenu("DHC.Clinic.BP.Side", "dhcbpcrecordcat", "监护大类维护", "dhcbpcrecordcat.csp", "", "", "", "", "SideMenu", "2015/1/23 0:00:00", "14:22:21", 1, "")
	do ..SaveHisMenu("DHC.Clinic.BP.Side", "dhcbpcrecorditem", "记录项目", "dhcbpcrecorditem.csp", "", "", "", "", "SideMenu", "2015/1/23 0:00:00", "14:23:35", 1, "")
	do ..SaveHisMenu("DHC.Clinic.BP.Side", "dhcbpcvascularaccess", "血管通路维护", "dhcbpcvascularaccess.csp", "", "", "", "", "SideMenu", "2015/1/23 0:00:00", "14:24:51", 1, "")
	do ..SaveHisMenu("DHC.Clinic.BP.Side", "dhcbpcvisitstatus", "病人转归维护", "dhcbpcvisitstatus.csp", "", "", "", "", "SideMenu", "2015/1/23 0:00:00", "14:25:34", 1, "")
	do ..SaveHisMenu("DHC.Clinic.BP.Side", "dhcbpdetection", "技师质量控制", "dhcbpdetection.csp", "", "", "", "", "SideMenu", "2015/1/23 0:00:00", "14:26:22", 1, "")
	do ..SaveHisMenu("DHC.Clinic.BP.Side", "dhcbpequipmaintain", "设备档案管理维护", "dhcbpequipmaintain.csp", "", "", "", "", "SideMenu", "2015/1/23 0:00:00", "14:27:05", 1, "")
	do ..SaveHisMenu("DHC.Clinic.BP.Side", "DHCBPCInquiry", "血液净化统计配置", "DHCBPCInquiry.csp", "", "", "", "", "SideMenu", "2015/11/19 0:00:00", "13:45:55", 1, "")
	do ..SaveHisMenu("OUTDOCHEAD", "dhcbloodpurification", "血液透析管理", "dhcbloodpurification.csp", "", "StartBPMonitoring", "", "", "HeaderMenu", "2017/9/28 0:00:00", "16:53:04", 1, "")
	do ..SaveHisMenu("DHC.Clinic.BP.Side", "dhcbpcanticoagulantdrug", "抗凝药品和抗凝方式维护", "dhcbpcanticoagulantdrug.csp", "", "", "", "", "SideMenu", "2015/4/20 0:00:00", "15:42:26", 1, "")
	do ..SaveHisMenu("DHC.Clinic.BP.Side", "dhcbpcbusinessfieldextend", "血液透析项维护", "dhcbpcbusinessfieldextend.csp", "", "", "", "", "SideMenu", "2015/7/31 0:00:00", "8:59:51", 1, "")
	do ..SaveHisMenu("OUTNURHEAD", "dhcbloodpurificationNur", "血液透析管理", "dhcbloodpurification.csp", "bottom:10px;right:10px;", "StartBPMonitoring", "", "", "HeaderMenu", "2017/9/28 0:00:00", "16:53:22", 1, "")
	quit "Over"
}

ClassMethod SaveHisMenu(subMenuOf, name, caption, linkurl, helpStyle, javaScriptFunction, isXhrRefresh, sequence, type, updateDate, updatetime, updateUser, valueExpression)
{
    set parentId=""
    &sql(select id into:parentId from websys.Menu where Name=:subMenuOf)
    write "parentId:",parentId,!
    quit:parentId="" "parentId is null"
	&sql(select id into:id from websys.Menu where Name=:name)
	set menuObj=##class(websys.Menu).%New()
	if (id'="")
	{
		set menuObj=##class(websys.Menu).%OpenId(id)
	}
	
	set menuObj.SubMenuOf=##class(websys.Menu).%OpenId(parentId)
	set menuObj.Name=name
	set menuObj.Caption=caption
	set menuObj.LinkUrl=linkurl
	set menuObj.HelpStyle=helpStyle
	set menuObj.JavascriptFunction=javaScriptFunction
	set menuObj.IsXhrRefresh=isXhrRefresh
	set menuObj.Sequence=sequence
	set menuObj.Type=type
	//set menuObj.UpdateDate
	//set menuObj.Updatetime
	//set menuObj.UpdateUser
	set menuObj.ValueExpression=valueExpression
	do menuObj.%Save()
	write "id:"_id,!
	quit menuObj.%Id()
}

/// 备份血透基础数据至^DHCBPBasicDataBak
/// 该方法用于标准版为项目准备基础数据
/// 参数：
///     tag:用于添加备份的别名
///          如,tag=20210324,备份后Global名字为^DHCBPBasicDataBak20210324
/// w ##class(web.DHCBPPublish).BackupBasicData()
ClassMethod BackupBasicData(tag = "")
{
	kill ^DHCBPBasicDataBak
	set sub=""
	
	for
	{
		set sub=$O(^DHCBPC(sub))
		quit:(sub="")
		;Continue:sub="AnticoagulantMode"
		;Continue:sub="BloodPurificationMode"
		;Continue:sub="DeceaseReason"
		;Continue:sub="EquipModel"
		;Continue:sub="EquipPart"
		;Continue:sub="RecordCat"
		;Continue:sub="EquipRunMode"
		;Continue:sub="RecordItem"
		;Continue:sub="VascularAccess"
		;Continue:sub="VisitStatus"
		;Continue:sub="BusinessFieldExtend"
		;Continue:sub="DiagCat"
		;Continue:sub="DiagCatLink"
		;Continue:sub="PDFConfig"

		w "backup:",sub,"=>^DHCBPBasicDataBak",!
		x "merge "_"^DHCBPBasicDataBak"_tag_"("""_sub_""")=^DHCBPC("""_sub_""")"
	}
	
	quit "S^"
}

/// 注意！！！：只在血透上线前导入基础数据时使用,该方法会删除基础数据！
/// 导入血透基础数据至^DHCBPBasicDataBak
/// 该方法用于标准版为项目准备基础数据
/// 参数：
///     tag:用于添加备份的别名
///          如,tag=20210324,备份后Global名字为^DHCBPBasicDataBak20210324
/// w ##class(web.DHCBPPublish).LoadBasicData()
ClassMethod LoadBasicData()
{
		;do ..BackupBasicData($Replace($zd(+$h,3),"-",1))
	if ($o(^DHCBPBasicDataBak(""))="")
	{
		write "^DHCBPBasicDataBak不存在，请先导入",!
	}
	// 导入 
	set globalName=""
	for{
		set globalName=$O(^DHCBPBasicDataBak(globalName))
		quit:globalName=""
		write "load:"_globalName,!
		x "kill ^DHCBPC("""_globalName_""")"
		if (globalName="DiagCat")
    	{
    		x "merge ^DHCCLC("""_globalName_""")="_"^DHCBPBasicDataBak("""_globalName_""")"
   		}
   		if (globalName="PDFConfig")
		{
   			x "merge ^DHCBPPDFConfig="_"^DHCBPBasicDataBak("""_globalName_""")"
		}
		x "merge ^DHCBPC("""_globalName_""")="_"^DHCBPBasicDataBak("""_globalName_""")"
	}
	Q "导入血透基础数据成功"
}

ClassMethod InitPByLocId(locId)
{
	// 统计
	do ..SaveDHCBPCInquiry("patMonthSum", "病人总数(月份)", "140", "I", "", "", "", "", 0, "S", "P", "63288", "1931/4/5 0:00:00", "", "")
	do ..SaveDHCBPCInquiry("pat1.2", "新进入病人（月份）", "140", "I", "", "", "", "", 0, "S", "P", "63288", "1931/4/5 0:00:00", "", "")
	do ..SaveDHCBPCInquiry("pat1.3", "新进入病人信息", "140", "I", "", "", "", "", 0, "S", "P", "63288", "1931/4/5 0:00:00", "", "")
	do ..SaveDHCBPCInquiry("pat1.4", "转归病人（月份）", "140", "I", "", "", "", "", 0, "S", "P", "63288", "1931/4/5 0:00:00", "", "")
	do ..SaveDHCBPCInquiry("pat1.5", "转归病人信息", "140", "I", "", "", "", "", 0, "S", "P", "63288", "1931/4/5 0:00:00", "", "")
	do ..SaveDHCBPCInquiry("pat1.6", "危重症病人", "140", "I", "", "", "", "", 0, "S", "P", "63288", "1931/4/5 0:00:00", "", "")
	do ..SaveDHCBPCInquiry("pat2.0", "Hgb人数比例", "140", "I", "", "", "", "", 0, "S", "P", "63288", "1931/4/5 0:00:00", "", "")
	do ..SaveDHCBPCInquiry("pat2.1", "检验固定项目", "140", "I", "", "", "", "", 0, "S", "P", "63288", "1931/4/5 0:00:00", "", "")
	do ..SaveDHCBPCInquiry("arr1.1", "充分性评估", "140", "I", "", "", "", "", 1, "", "", "63288", "1931/4/5 0:00:00", "", "A")
	do ..SaveDHCBPCInquiry("arr1.2", "腹膜平衡试验", "140", "I", "", "", "", "", 1, "", "", "63288", "1931/4/5 0:00:00", "", "A")
	do ..SaveDHCBPCInquiry("FMTXWSW", "微生物(暂不可用)", "140", "I", "", "", "", "", 0, "S", "P", "65248", "2002/9/8 0:00:00", "", "")
	do ..SaveDHCBPCInquiry("FMTXWNX", "凝血(暂不可用)", "140", "I", "", "", "", "", 0, "S", "P", "65248", "2002/9/8 0:00:00", "", "")
	do ..SaveDHCBPCInquiry("FMTXMYXM", "免疫项目(暂不可用)", "140", "I", "", "", "", "", 0, "S", "P", "65248", "2002/9/8 0:00:00", "", "")
	
	// 血管通路
	do ..SaveDHCBPCVascularAccess("tencoffzg", "Tencoff直管", locId)
    do ..SaveDHCBPCVascularAccess("swanneckjqg", "SwanNeck卷曲管", locId)
}

/// 按科室配置初始化配置数据
/// 参数：
///     locId:血透室科室ID 
/// w ##class(web.DHCBPPublish).LoadBasicData(101,102)
ClassMethod InitHDByLocId(locId)
{
	// 统计配置
	do ..SaveDHCBPCInquiry("1.1", "1.1    当前患者透析龄", locId, "I", "", "", "", "", 0, "S", "CP", "63288", "1931/4/5 0:00:00", "", "")
	do ..SaveDHCBPCInquiry("1.4", "1.4    新增血透患者", locId, "I", "", "", "", "", 1, "", "P", "63288", "1931/4/5 0:00:00", "", "")
	do ..SaveDHCBPCInquiry("1.5", "1.5    患者转归", locId, "I", "", "", "", "", 1, "", "P", "63510", "1968/7/31 0:00:00", "", "")
	do ..SaveDHCBPCInquiry("3.1", "3.1    血红蛋白和红细胞压积平均值", locId, "I", "", "", "", "", 1, "", "", "63288", "1931/4/5 0:00:00", "", "")
	do ..SaveDHCBPCInquiry("4.4", "4.4    Ca,P,PTH结合分析", locId, "I", "", "", "", "", 0, "", "", "63288", "1931/4/5 0:00:00", "", "")
	do ..SaveDHCBPCInquiry("2.1", "2.1    肝炎病毒标志物", locId, "I", "", "", "", "", 0, "", "", "63288", "1931/4/5 0:00:00", "", "")
	do ..SaveDHCBPCInquiry("5.3", "5.3    血清白蛋白控制指标", locId, "I", "", "", "", "", 0, "", "", "63288", "1931/4/5 0:00:00", "", "")
	do ..SaveDHCBPCInquiry("3.2", "3.2    血常规", locId, "I", "", "", "", "", 0, "", "", "63288", "1931/4/5 0:00:00", "", "")
	do ..SaveDHCBPCInquiry("1.3", "1.3    血管通路趋势变化", locId, "I", "", "", "", "", 1, "", "CP", "63288", "1931/4/5 0:00:00", "", "")
	do ..SaveDHCBPCInquiry("4.2", "4.2    血钙血磷控制指标", locId, "I", "", "", "", "", 1, "", "", "63288", "1931/4/5 0:00:00", "", "")
	do ..SaveDHCBPCInquiry("4.5", "4.5    生化定时检验", locId, "I", "", "", "", "", 0, "", "", "63288", "1931/4/5 0:00:00", "", "")
	do ..SaveDHCBPCInquiry("3.4", "3.4    血清铁蛋白和转铁蛋白饱和度", locId, "I", "", "", "", "", 0, "", "", "63288", "1931/4/5 0:00:00", "", "")
	do ..SaveDHCBPCInquiry("4.6", "4.6    PTH定时检验", locId, "I", "", "", "", "", 0, "", "", "63288", "1931/4/5 0:00:00", "", "")
	do ..SaveDHCBPCInquiry("3.3", "3.3    肾性贫血控制", locId, "I", "", "", "", "", 0, "", "", "63288", "1931/4/5 0:00:00", "", "")
	do ..SaveDHCBPCInquiry("4.1", "4.1    继发性甲状旁腺功能亢进分布", locId, "I", "", "", "", "", 0, "", "", "63288", "1931/4/5 0:00:00", "", "")
	do ..SaveDHCBPCInquiry("1.2", "1.2    原发病分布", locId, "I", "", "", "", "", 0, "", "P", "63288", "1931/4/5 0:00:00", "", "")
	do ..SaveDHCBPCInquiry("5.1", "5.1    患者透析充分性", locId, "I", "", "", "", "", 0, "", "", "63288", "1931/4/5 0:00:00", "", "")
	do ..SaveDHCBPCInquiry("5.2", "5.2    年度溶质清除（URR）", locId, "I", "", "", "", "", 0, "", "", "63288", "1931/4/5 0:00:00", "", "")
	do ..SaveDHCBPCInquiry("4.3", "4.3    钙磷乘积", locId, "I", "", "", "", "", 0, "", "", "63288", "1931/4/5 0:00:00", "", "")
	do ..SaveDHCBPCInquiry("2.2", "2.2    乙肝DNA丙肝RNA检测", locId, "I", "", "", "", "", 0, "", "", "63288", "1931/4/5 0:00:00", "", "")
	do ..SaveDHCBPCInquiry("9.3", "9.3    病人透析记录", locId, "I", "", "", "", "", 0, "", "", "63288", "1931/4/5 0:00:00", "", "A")
	do ..SaveDHCBPCInquiry("6.2", "6.2    手细菌培养", locId, "I", "", "", "", "", 0, "", "D", "63288", "1931/4/5 0:00:00", "", "")
	do ..SaveDHCBPCInquiry("6.3", "6.3    物体表面细菌培养", locId, "I", "", "", "", "", 0, "", "D", "63288", "1931/4/5 0:00:00", "", "")
	do ..SaveDHCBPCInquiry("6.1", "6.1    空气细菌培养", locId, "I", "", "", "", "", 0, "", "D", "63288", "1931/4/5 0:00:00", "", "")
	do ..SaveDHCBPCInquiry("7.3", "7.3    反渗水化学污染", locId, "I", "", "", "", "", 0, "", "D", "63288", "1931/4/5 0:00:00", "", "")
	do ..SaveDHCBPCInquiry("7.2", "7.2    内毒素", locId, "I", "", "", "", "", 0, "", "D", "63288", "1931/4/5 0:00:00", "", "")
	do ..SaveDHCBPCInquiry("7.1", "7.1    细菌培养", locId, "I", "", "", "", "", 0, "S", "D", "63288", "1931/4/5 0:00:00", "", "")
	do ..SaveDHCBPCInquiry("8.0", "8.0    病人基础信息", locId, "I", "", "", "", "", "", "0", "", "N", "2014/4/11 0:00:00", "9:09:26", "")
	do ..SaveDHCBPCInquiry("9.0", "9.0    病人透析次数", locId, "I", "", "", "", "", "", "0", "", "N", "2014/4/11 0:00:00", "9:09:26", "")
	do ..SaveDHCBPCInquiry("9.1", "9.1    抗肾小球基底膜抗体检测", locId, "I", "", "", "", "", "", "0", "", "N", "2014/4/11 0:00:00", "9:09:26", "")
	do ..SaveDHCBPCInquiry("9.2", "9.2    无肝素患者", locId, "I", "", "", "", "", 1, "", "", "63288", "1931/4/5 0:00:00", "", "A")
	do ..SaveDHCBPCInquiry("9.3", "9.3    血透常用药", locId, "I", "", "", "", "", 1, "", "", "", "", "", "A")
	do ..SaveDHCBPCInquiry("9.4", "9.4    检验固定项目", locId, "I", "", "", "", "", 0, "S", "P", "63288", "1931/4/5 0:00:00", "", "")
	do ..SaveDHCBPCInquiry("9.5", "9.5    下机护士(周)", locId, "I", "", "", "", "", 1, "", "A", "63288", "1931/4/5 0:00:00", "", "S")
	// 抗凝方式?
	
	do ..SaveDHCBPCAnticoagulantDrug("Heparin", "肝素", -1, -1, "278", "", "", -1, "-1", 4, -1, -1, "1", locId, "")
	do ..SaveDHCBPCAnticoagulantDrug("Protamine", "鱼精蛋白", -1, -1, "110", -1, -1, -1, "-1", 4, -1, -1, "", locId, "")
	do ..SaveDHCBPCAnticoagulantDrug("Fragmin", "法安明", -1, -1, "", -1, "", -1, "-1", 8, -1, -1, "2", locId, "")
	do ..SaveDHCBPCAnticoagulantDrug("Fraxiparine", "速碧林", -1, -1, "", -1, "", -1, "-1", 8, -1, -1, "2", locId, "")
	do ..SaveDHCBPCAnticoagulantDrug("Clexane", "克赛", -1, -1, "", -1, "", -1, "-1", 8, -1, -1, "2", locId, "")
	do ..SaveDHCBPCAnticoagulantDrug("Saline", "盐水", -1, -1, "103", -1, "", -1, "-1", 3, -1, "", "", locId, "")
	do ..SaveDHCBPCAnticoagulantDrug("Other", "其他", -1, -1, "", -1, -1, -1, "", "", -1, -1, "", locId, "")
	do ..SaveDHCBPCAnticoagulantDrug("CitriciAcid", "4%枸橼酸", -1, -1, "", -1, "", -1, "-1", 1, -1, -1, "3", locId, "")
	do ..SaveDHCBPCAnticoagulantDrug("CalciumGluconate", "10%葡萄糖酸钙", -1, -1, "", -1, "", -1, "-1", 1, -1, -1, "4", locId, "")
	do ..SaveDHCBPCAnticoagulantDrug("CitriciAcid3", "3%枸橼酸", -1, -1, "", -1, "", -1, "-1", 1, -1, -1, "3", locId, "")
	do ..SaveDHCBPCAnticoagulantDrug("Icodextrin1.5%", "钙1.75糖1.5%", "", -1, "19", -1, -1, "", "-1", "", "", -1, "", locId, "")
	do ..SaveDHCBPCAnticoagulantDrug("Icodextrin2.5%", "钙1.75糖2.5%", "", -1, "19", -1, -1, "", "-1", "", "", -1, "", locId, "")
	do ..SaveDHCBPCAnticoagulantDrug("Icodextrin4.25%", "钙1.75糖4.25%", "", -1, "19", -1, -1, "", "-1", "", "", -1, "", locId, "")
	do ..SaveDHCBPCAnticoagulantDrug("Icodextrin1.5%5L", "钙1.75糖1.5%5L", -1, -1, "19", -1, -1, "", "-1", "", -1, -1, "", locId, "")
	do ..SaveDHCBPCAnticoagulantDrug("Icodextrin2.5%5L", "钙1.75糖2.5%5L", -1, -1, "19", -1, -1, "", "-1", "", -1, -1, "", locId, "")
	do ..SaveDHCBPCAnticoagulantDrug("LoCaIcodextrin1.5%", "钙1.25糖1.5%", "", -1, "19", -1, -1, "", "-1", "", "", -1, "", locId, "")
	do ..SaveDHCBPCAnticoagulantDrug("LoCaIcodextrin2.5%", "钙1.25糖2.5%", "", -1, "19", -1, -1, "", "-1", "", "", -1, "", locId, "")
	do ..SaveDHCBPCAnticoagulantDrug("LoCaIcodextrin4.25%", "钙1.25糖4.25%", "", -1, "19", -1, -1, "", "-1", "", "", -1, "", locId, "")
	do ..SaveDHCBPCAnticoagulantDrug("CalciumChloride", "5%氯化钙", -1, -1, "", -1, "", -1, "-1", 1, -1, -1, "4", locId, "")
	// 血管通路
	do ..SaveDHCBPCVascularAccess("ztdjmnl", "自体动静脉内瘘", locId)
	do ..SaveDHCBPCVascularAccess("yzwdjmnl", "移植物动静脉内瘘", locId)
	do ..SaveDHCBPCVascularAccess("qt", "其他", locId)
	do ..SaveDHCBPCVascularAccess("lsjmzg", "临时静脉置管", locId)
	do ..SaveDHCBPCVascularAccess("cqjmzg", "长期静脉置管", locId)
	// 血液净化方式
	do ..SaveDHCBPCBloodPurificationMode("HDF", "HDF血液透析滤过", "N", locId)
	do ..SaveDHCBPCBloodPurificationMode("HF", "HF血液滤过", "N", locId)
	do ..SaveDHCBPCBloodPurificationMode("HD", "HD血液透析", "N", NULL)
	do ..SaveDHCBPCBloodPurificationMode("HFD", "HFD高通量透析", "N", locId)
	do ..SaveDHCBPCBloodPurificationMode("HP", "HP血液灌流", "N", locId)
	do ..SaveDHCBPCBloodPurificationMode("CVVHD", "CVVHD", "Y", locId)
	do ..SaveDHCBPCBloodPurificationMode("CVVHF", "CVVHF", "Y", locId)
	do ..SaveDHCBPCBloodPurificationMode("CVVHDF", "CVVHDF", "Y", locId)
	do ..SaveDHCBPCBloodPurificationMode("ELAD", "MARS", "Y", locId)
	do ..SaveDHCBPCBloodPurificationMode("IMS", "免疫吸附", "Y", locId)
	do ..SaveDHCBPCBloodPurificationMode("BBS", "胆红素吸附", "Y", locId)
	do ..SaveDHCBPCBloodPurificationMode("PE", "PE", "Y", locId)
	do ..SaveDHCBPCBloodPurificationMode("DFPP", "DFPP", "Y", locId)
	do ..SaveDHCBPCBloodPurificationMode("CAPD", "CAPD", "N", locId)
	do ..SaveDHCBPCBloodPurificationMode("IPD", "IPD", "N", locId)
	do ..SaveDHCBPCBloodPurificationMode("NIPD", "NIPD", "N", locId)
	do ..SaveDHCBPCBloodPurificationMode("CCPD", "CCPD", "N", locId)
	do ..SaveDHCBPCBloodPurificationMode("NIPD+IPD", "NIPD+IPD", "N", locId)
	// 统计Code
	do ..SaveDHCBPCInquiry("patName", "姓名", "P", locId, NULL)
	do ..SaveDHCBPCInquiry("patSex", "性别", "P", locId, ";男;女")
	do ..SaveDHCBPCInquiry("patAge", "年龄", "P", locId, NULL)
	do ..SaveDHCBPCInquiry("curPatBPMonth", "透析龄(月)", "P", locId, NULL)
	do ..SaveDHCBPCInquiry("patStatus", "病人状态", "P", locId, NULL)


	quit
}

ClassMethod SaveDHCBPCInquiry(BPCICode, BPCIDesc, BPCICtlocDr, BPCIStatus, BPCIType, BPCISearchLevel, BPCIBpaCount, BPCIResultCount, BPCIIsByDate, BPCIDataType, BPCIDateTimeType, BPCIUpdateUserDr, BPCIUpdateDate, BPCIUpdateTime, BPCIClassifyCode)
{
	set rowId=..GetIdByCode("User.DHCBPCInquiry","BPCIClassifyCode",BPCIClassifyCode)
    set obj=##class(User.DHCBPCInquiry).%New()
    if (rowId'="")
    {
    set obj=##class(User.DHCBPCInquiry).%OpenId(rowId)
    }
    else
    {
    set obj=##class(User.DHCBPCInquiry).%New()
    }
    set obj.BPCICode=BPCICode
    set obj.BPCIDesc=BPCIDesc
    set obj.BPCICtlocDr=BPCICtlocDr
    set obj.BPCIStatus=BPCIStatus
    set obj.BPCIType=BPCIType
    set obj.BPCISearchLevel=BPCISearchLevel
    set obj.BPCIBpaCount=BPCIBpaCount
    set obj.BPCIResultCount=BPCIResultCount
    set obj.BPCIIsByDate=BPCIIsByDate
    set obj.BPCIDataType=BPCIDataType
    set obj.BPCIDateTimeType=BPCIDateTimeType
    set obj.BPCIUpdateUserDr=BPCIUpdateUserDr
    set obj.BPCIUpdateDate=BPCIUpdateDate
    set obj.BPCIUpdateTime=BPCIUpdateTime
    set obj.BPCIClassifyCode=BPCIClassifyCode
    do obj.%Save()
    quit obj.%Id()
}

ClassMethod SaveDHCBPCVascularAccess(BPCVACode, BPCVADesc, BPCVALocationDr)
{
    set rowId=..GetIdByCode("User.DHCBPCVascularAccess","BPCVACode",BPCVACode)
    set obj=##class(User.DHCBPCVascularAccess).%New()
    if (rowId'="")
    {
    set obj=##class(User.DHCBPCVascularAccess).%OpenId(rowId)
    }
    else
    {
    set obj=##class(User.DHCBPCVascularAccess).%New()
    }
    set obj.BPCVACode=BPCVACode
    set obj.BPCVADesc=BPCVADesc
    set obj.BPCVALocationDr=BPCVALocationDr
    do obj.%Save()
    quit obj.%Id()
}

ClassMethod SaveDHCBPCBloodPurificationMode(BPCBPMCode, BPCBPMDesc, BPCBPMIsSpecial, BPCBPMLocationDr)
{
    set rowId=..GetIdByCode("User.DHCBPCBloodPurificationMode","BPCBPMCode",BPCBPMCode)
    set obj=##class(User.DHCBPCBloodPurificationMode).%New()
    if (rowId'="")
    {
    set obj=##class(User.DHCBPCBloodPurificationMode).%OpenId(rowId)
    }
    else
    {
    set obj=##class(User.DHCBPCBloodPurificationMode).%New()
    }
    set obj.BPCBPMCode=BPCBPMCode
    set obj.BPCBPMDesc=BPCBPMDesc
    set obj.BPCBPMIsSpecial=BPCBPMIsSpecial
    set obj.BPCBPMLocationDr=BPCBPMLocationDr
    do obj.%Save()
    quit obj.%Id()
}

ClassMethod SaveDHCBPCInquiryCode(BPCICCode, BPCICDesc, BPCICType, BPCICCtlocDr, BPCICOption)
{
    set rowId=..GetIdByCode("User.DHCBPCInquiryCode","BPCICCode",BPCICCode)
    set obj=##class(User.DHCBPCInquiryCode).%New()
    if (rowId'="")
    {
    set obj=##class(User.DHCBPCInquiryCode).%OpenId(rowId)
    }
    else
    {
    set obj=##class(User.DHCBPCInquiryCode).%New()
    }
    set obj.BPCICCode=BPCICCode
    set obj.BPCICDesc=BPCICDesc
    set obj.BPCICType=BPCICType
    set obj.BPCICCtlocDr=BPCICCtlocDr
    set obj.BPCICOption=BPCICOption
    do obj.%Save()
    quit obj.%Id()
}

ClassMethod SaveDHCCLCBodySite(CLCBSCode, CLCBSDesc, CLCBSLocDr)
{
    set rowId=..GetIdByCode("User.DHCCLCBodySite","CLCBSCode",CLCBSCode)
    set obj=##class(User.DHCCLCBodySite).%New()
    if (rowId'="")
    {
    set obj=##class(User.DHCCLCBodySite).%OpenId(rowId)
    }
    else
    {
    set obj=##class(User.DHCCLCBodySite).%New()
    }
    set obj.CLCBSCode=CLCBSCode
    set obj.CLCBSDesc=CLCBSDesc
    set obj.CLCBSLocDr=CLCBSLocDr
    do obj.%Save()
    quit obj.%Id()
}

ClassMethod SaveDHCBPCAnticoagulantDrug(BPCADCode, BPCADDesc, BPCADAmount, BPCADConcentration, BPCADUomDr, BPCADFirstAmount, BPCADDose, BPCADFrequency, BPCADNote, BPCADBPCSUDr, BPCADDuration, BPCADIntervalMinute, BPCADCatDr, BPCADLocationDr, BPCADLastReservation)
{
    set rowId=..GetIdByCode("User.DHCBPCAnticoagulantDrug","BPCADCode",BPCADCode)
    set obj=##class(User.DHCBPCAnticoagulantDrug).%New()
    if (rowId'="")
    {
    set obj=##class(User.DHCBPCAnticoagulantDrug).%OpenId(rowId)
    }
    else
    {
    set obj=##class(User.DHCBPCAnticoagulantDrug).%New()
    }
    set obj.BPCADCode=BPCADCode
    set obj.BPCADDesc=BPCADDesc
    set obj.BPCADAmount=BPCADAmount
    set obj.BPCADConcentration=BPCADConcentration
    set obj.BPCADUomDr=BPCADUomDr
    set obj.BPCADFirstAmount=BPCADFirstAmount
    set obj.BPCADDose=BPCADDose
    set obj.BPCADFrequency=BPCADFrequency
    set obj.BPCADNote=BPCADNote
    set obj.BPCADBPCSUDr=BPCADBPCSUDr
    set obj.BPCADDuration=BPCADDuration
    set obj.BPCADIntervalMinute=BPCADIntervalMinute
    set obj.BPCADCatDr=BPCADCatDr
    set obj.BPCADLocationDr=BPCADLocationDr
    set obj.BPCADLastReservation=BPCADLastReservation
    do obj.%Save()
    quit obj.%Id()
}

ClassMethod GetIdByCode(className, codeFieldName, code)
{
	set rowIdName=..GetRowIdName(className)
	set tableName=..GetTableName(className)
	set sqlStr="select "_rowIdName_" as Id from SQLUser."_tableName_" where "_codeFieldName_"="""_code_""""
	set ^tempClDebug("2")=sqlStr
	SET tStatement=##class(%SQL.Statement).%New()
	// SET tStatement.%ObjectSelectMode=1
    SET tStatus=tStatement.%Prepare(sqlStr)
    SET rset=tStatement.%Execute()
    set id=""
    
    while rset.%Next() {
	   set id=rset.%Get("Id")
	   set ^tempClDebug("4")=id
	   quit
    }
    
    IF ((rset.%SQLCODE'=0)&&(rset.%SQLCODE'=100))
    {
	    set ^tempClDebug("3")=rset.%Message
	    quit rset.%Message
    }
    do tStatement.%Close()
    quit id
}

ClassMethod GetRowIdName(cdef)
{
	if (cdef'["%Dictionary.ClassDefinition")
	{
		set cdef = ##class(%Dictionary.ClassDefinition).%OpenId(cdef)
	}
	set rowIdName=""
	if cdef.ClassType="persistent" 
	{
		if (cdef.SqlRowIdName'="")
		{
			s rowIdName = dsd.SqlRowIdName		
		}
		else
		{
			if ((cdef.Storages)&&(cdef.Storages.Count()>0) && (cdef.Storages.GetAt(1).SqlRowIdName'="")){
				s rowIdName=cdef.Storages.GetAt(1).SqlRowIdName
			}
		}
	}
	quit rowIdName
}

ClassMethod GetTableName()
{
	if (cdef'["%Dictionary.ClassDefinition")
	{
		set cdef = ##class(%Dictionary.ClassDefinition).%OpenId(cdef)
	}
	set tableName=cdef.SqlTableName
	quit tableName
}

}
