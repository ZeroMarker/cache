Import SQLUser

Class web.DHCICUPublish Extends web.DHCICUPublishCom
{

/// 注意！！！：只在重症上线前导入基础数据时使用,该方法会删除基础数据！
/// 导入重症基础数据至^DHCICUBasicDataBak
/// 该方法用于标准版为项目准备基础数据
/// 参数：
///     tag:用于添加备份的别名
///          如,tag=20210324,备份后Global名字为^DHCICUBasicDataBak20210324
/// w ##class(web.DHCICUPublish).LoadBasicData()
ClassMethod LoadBasicData()
{
	
	if ($o(^DHCICUBasicDataBak(""))="")
	{
		write "^DHCICUBasicDataBak不存在，请先导入",!
	}
	// do ..BackupBasicData($Replace($zd(+$h,3),"-",1)) 
	// 导入 
	set globalName=""
	for{
		set globalName=$O(^DHCICUBasicDataBak(globalName))	
		quit:globalName=""
		write "load:"_globalName,!
		if (globalName'["^")
		{
			x "kill "_globalName
			x "merge ^DHCICUC("""_globalName_""")="_"^DHCICUBasicDataBak("""_globalName_""")" 
		}
		else
		{
			x "kill "_globalName
			x "merge "_globalName_"="_"^DHCICUBasicDataBak("""_globalName_""")" 
		}
	}
	Q "导入成功"
}

/// 根据科室ID和模板名称初始化配置数据(科室模板、出入量汇总、体温单配置)
/// locId: 科室ID
/// w ##class(web.DHCICUPublish).InitConfigDataByLoc(203, "标准版")
/// tempName: 科室模板
ClassMethod InitConfigDataByLoc(locId, tempName)
{
	// 科室模板	
	 w ##class(web.DHCICUPublish).InitTemplateItem(tempName, locId)
	// 备份(因配置数据并不多，所以直接全备份)
	m ^DHCICUCBackup($h)=^DHCICUC
	//kill ^DHCICUC
	// 初始化HIS菜单
	//w ##class(web.DHCICUPublish).InitHisMenu() 
	// 删除现有体温单数据
	&sql(delete from DHC_ICUC_Temperature WHERE ICUCT_CtlocId=:locId)
	// 体温单
	do ..SaveTempItem(locId,"Temper","temperature","6","2:00:00","0:00:00")
	do ..SaveTempItem(locId,"Pulse","pulse","6","2:00:00","0:00:00")
	do ..SaveTempItem(locId,"RR","breath","6","2:00:00","0:00:00")
	do ..SaveTempItem(locId,"ASBP","sysPressure","6","2:00:00","0:00:00")
	do ..SaveTempItem(locId,"ADBP","diaPressure","6","2:00:00","0:00:00")
	do ..SaveTempItem(locId,"HR","heartbeat","6","2:00:00","0:00:00")
	do ..SaveTempItem(locId,"Stoolcount","defFreq","1","6:00:00","0:00:00")
	do ..SaveTempItem(locId,"TotalIn3","liquidln","1","6:00:00","0:00:00")
	do ..SaveTempItem(locId,"nyndgnl","uriVolume","1","6:00:00","0:00:00")
	do ..SaveTempItem(locId,"PatWeight","weight","1","6:00:00","0:00:00")
	do ..SaveTempItem(locId,"PatHeight","height","1","6:00:00","0:00:00")
	do ..SaveTempItem(locId,"gangwen","rectemperature","6","2:00:00","0:00:00")

	// 删除现有汇总数据
    &sql(delete from DHC_ICUC_IOItem WHERE ICUCIOI_Ctloc_Dr=:locId)
	// 出入量汇总
	do ..SaveIOItem("TotalIn","总入量","","6691","222","","Y",locId,"","AfterTotalInOut","1","Volume")
	do ..SaveIOItem("TotalOut","总出量","","5498","222","","Y",locId,"","","-1","")
	do ..SaveIOItem("TotalBalance","出入量平衡","","5533","222","","Y",locId,"","","1","")
	do ..SaveIOItem("DrugIntake","静脉入/肌注/皮下注","I","5374","222","","Y",locId,"222","HourAndTotal","1","Volume")
	do ..SaveIOItem("MicropumpIntake","微泵用药","I","5379","222","","Y",locId,"222","HourAndTotal","1","Volume")
	do ..SaveIOItem("Desc","鼻饲","I","5318","222","","Y",locId,"222","HourAndTotal","1","Volume")
	do ..SaveIOItem("TransBlood","输血","I","5324","222","","N",locId,"222","HourAndTotal","1","Volume")
	do ..SaveIOItem("OralIntake","口服","I","5322","222","","Y",locId,"222","HourAndTotal","1","Volume")
	do ..SaveIOItem("UrineVolume","尿量","O","5361","222","","Y",locId,"223","HourAndTotal","1","Qty")
	do ..SaveIOItem("TtubeDrainage","引流量","O","5362","222","","Y",locId,"223","HourAndTotal","1","Qty")
	do ..SaveIOItem("Stool","大便","O","5369","222","","Y",locId,"223","HourAndTotal","1","Qty")
	do ..SaveIOItem("YINLIUTIJI","体积","O","5659","222","","Y",locId,"223","HourAndTotal","1","Qty")
	do ..SaveIOItem("xueyejinghuapingheng","血液净化平衡","","6694","222","","Y",locId,"","AfterTotalInOut","1","")
	do ..SaveIOItem("FoodVolume","进食","I","6067","222","","Y",locId,"222","HourAndTotal","1","Qty")
	do ..SaveIOItem("IrrigationInchuliang","冲入出量","O","6083","222","","N",locId,"223","HourAndTotal","1","Qty")
	do ..SaveIOItem("Enemachuliang","灌肠出量","O","6085","222","","N",locId,"223","HourAndTotal","1","Qty")
	do ..SaveIOItem("IrrigationInruliang","冲入入量","I","6082","222","","N",locId,"222","HourAndTotal","1","Qty")
	do ..SaveIOItem("Enemaruliang","灌肠入量","I","6084","222","","N",locId,"222","HourAndTotal","1","Qty")
	do ..SaveIOItem("LVCHUTIJI","体积","O","6098","222","","Y",locId,"223","HourAndTotal","1","Qty")
	do ..SaveIOItem("SKFYYT","口服","I","6101","222","","Y",locId,"222","HourAndTotal","1","Volume")
	do ..SaveIOItem("inputVOl","输入量","I","6000","222","","Y",locId,"222","HourAndTotal","1","Qty")
	do ..SaveIOItem("DetailVolumeInjection","注射量","I","5324","222","","Y",locId,"222","HourAndTotal","1","Volume")
	do ..SaveIOItem("InputVOlXueYePH","输入量","I","6000","222","","Y",locId,"235","HourAndTotal","1","Qty")
	do ..SaveIOItem("CitricAcidBT","枸椽酸(百特)(ml/hr)","I","6071","222","","N",locId,"245","HourAndTotal","1","Qty")
	do ..SaveIOItem("FormerDiluentph","前稀释液(ml/hr)","I","6003","222","","N",locId,"235","HourAndTotal","1","Qty")
	do ..SaveIOItem("DiluentAfterph","后稀释液(ml/hr)","I","6004","222","","N",locId,"235","HourAndTotal","1","Volume")
	do ..SaveIOItem("CitricAcidph","枸椽酸(金宝)(ml/hr)","I","6006","222","","N",locId,"235","HourAndTotal","1","Qty")
	do ..SaveIOItem("CitricAcidBTph","枸椽酸(百特)(ml/hr)","I","6071","222","","N",locId,"235","HourAndTotal","1","Qty")
	do ..SaveIOItem("LVCHUTIJIph","滤出体积(ml)","O","6098","222","","Y",locId,"235","HourAndTotal","-1","Qty")
	do ..SaveIOItem("Stoolcount","大便次数","O","6100","222","","Y",locId,"","TimePoint","1","Qty")
	do ..SaveIOItem("JMYYMSXRL","每小时入量","I","5441","222","","Y",locId,"222","HourAndTotal","1","Volume")
	do ..SaveIOItem("FoodVolume2","进食","I","6067","222","","Y",locId,"224","HourAndTotal","1","Qty")
	do ..SaveIOItem("DrugIntake2","静脉入/肌注/皮下注","I","5374","222","","Y",locId,"224","HourAndTotal","1","Volume")
	do ..SaveIOItem("MicropumpIntake2","微泵用药","I","5379","222","","Y",locId,"224","HourAndTotal","1","Volume")
	do ..SaveIOItem("Desc2","鼻饲","I","5318","222","","Y",locId,"224","HourAndTotal","1","Volume")
	do ..SaveIOItem("TransBlood2","输血","I","5324","222","","N",locId,"224","HourAndTotal","1","Volume")
	do ..SaveIOItem("OralIntake2","口服","I","5322","222","","Y",locId,"224","HourAndTotal","1","Volume")
	do ..SaveIOItem("UrineVolume2","尿量","O","5361","222","","Y",locId,"224","HourAndTotal","-1","Qty")
	do ..SaveIOItem("TtubeDrainage2","引流量","O","5362","222","","Y",locId,"224","HourAndTotal","-1","Qty")
	do ..SaveIOItem("Stool2","大便","O","5369","222","","Y",locId,"224","HourAndTotal","-1","Qty")
	do ..SaveIOItem("YINLIUTIJI2","体积","O","5659","222","","Y",locId,"224","HourAndTotal","-1","Qty")
	do ..SaveIOItem("IrrigationInchuliang2","冲入出量","O","6083","222","","N",locId,"224","HourAndTotal","-1","Qty")
	do ..SaveIOItem("Enemachuliang2","灌肠出量","O","6085","222","","N",locId,"224","HourAndTotal","-1","Qty")
	do ..SaveIOItem("IrrigationInruliang2","冲入入量","I","6082","222","","N",locId,"224","HourAndTotal","1","Qty")
	do ..SaveIOItem("Enemaruliang2","灌肠入量","I","6084","222","","N",locId,"224","HourAndTotal","1","Qty")
	do ..SaveIOItem("LVCHUTIJI2","体积","O","6098","222","","Y",locId,"224","HourAndTotal","-1","Qty")
	do ..SaveIOItem("SKFYYT2","口服","I","6101","222","","Y",locId,"224","HourAndTotal","1","Volume")
	do ..SaveIOItem("DetailVolumeInjection2","注射量","I","5324","222","","Y",locId,"224","HourAndTotal","1","Volume")
	do ..SaveIOItem("InputVOl2","输入量","I","6000","222","","Y",locId,"224","HourAndTotal","1","Qty")
	do ..SaveIOItem("LVCHUTIJIph2","滤出体积(ml)","O","6098","222","","N",locId,"224","HourAndTotal","-1","Qty")
	do ..SaveIOItem("JMYYMSXRL2","每小时入量","I","5441","222","","Y",locId,"224","HourAndTotal","1","Volume")
	do ..SaveIOItem("nyndgnl","尿量","O","6096","222","","Y",locId,"223","HourAndTotal","1","Qty")
	do ..SaveIOItem("nyndgnl2","尿量","O","6096","222","","Y",locId,"224","HourAndTotal","-1","Qty")
	do ..SaveIOItem("WPCWYYLTJ","胃液引流体积","O","6092","222","","Y",locId,"223","HourAndTotal","1","Qty")
	do ..SaveIOItem("WPCWYYLTJ2","胃液引流体积","O","6092","222","","Y",locId,"224","HourAndTotal","-1","Qty")
	do ..SaveIOItem("SKFYYTKF","口服（ml）","I","6549","222","","Y",locId,"222","HourAndTotal","1","Qty")
	do ..SaveIOItem("SKFYYTKF2","口服（ml）","I","6549","222","","Y",locId,"224","HourAndTotal","1","Qty")
	do ..SaveIOItem("CRRTBalance","CRRT净平衡","","6699","222","","Y",locId,"","AfterTotalInOut","1","")
	do ..SaveIOItem("UltrafiltrationRateCRRTBalance","超滤率(ML/HR)","I","6720","222","","Y",locId,"281","HourAndTotal","-1","Qty")
	do ..SaveIOItem("AcD-A","AcD-A(ml/hr)","I","6697","222","","N",locId,"281","HourAndTotal","1","Qty")
	do ..SaveIOItem("CaGlu","CaGlu(ml/hr)","I","6698","222","","N",locId,"281","HourAndTotal","1","Qty")
	do ..SaveIOItem("CRRTBalanceInfusionpump","血滤输液泵CRRT平衡","I","6741","222","","Y",locId,"281","HourAndTotal","1","Volume")
	do ..SaveIOItem("UltrafiltrationRateTotalOut","超滤率(ML/HR)","I","6720","222","","Y",locId,"223","HourAndTotal","1","Qty")
	do ..SaveIOItem("AcD-ATotalIn","AcD-A(ml/hr)","I","6697","222","","N",locId,"222","HourAndTotal","1","Qty")
	do ..SaveIOItem("CaGluTotalIn","CaGlu(ml/hr)","I","6698","222","","N",locId,"222","HourAndTotal","1","Qty")
	do ..SaveIOItem("CRRTTotalInInfusionpump","血滤输液泵总入量","I","6741","222","","Y",locId,"222","HourAndTotal","1","Volume")
	do ..SaveIOItem("UltrafiltrationRateTotalBalance","超滤率(ML/HR)","I","6720","222","","Y",locId,"224","HourAndTotal","-1","Qty")
	do ..SaveIOItem("AcD-ATotalBalance","AcD-A(ml/hr)","I","6697","222","","N",locId,"224","HourAndTotal","1","Qty")
	do ..SaveIOItem("CaGluTotalBalance","CaGlu(ml/hr)","I","6698","222","","N",locId,"224","HourAndTotal","1","Qty")
	do ..SaveIOItem("CRRTTotalBalanceInfusionPump","血滤输液泵出入量平衡","I","6741","222","","Y",locId,"224","HourAndTotal","1","Volume")
	do ..SaveIOItem("EmesisTotalOut","呕吐","O","6526","222","","Y",locId,"223","HourAndTotal","1","Qty")
	do ..SaveIOItem("EmesisTotalBalance","呕吐","O","6526","222","","Y",locId,"224","HourAndTotal","-1","Qty")

	
	quit "Over"
}

/// 使用^DHCICUTemplateDataBak初始化重症科室模板数据
/// 该方法用于标准版为项目准备基础数据
/// 参数：
///     name:要导入的别名，如协和医院外科ICU
///     locId: 要添加科室模板的科室ID
///          
/// w ##class(web.DHCICUPublish).BackupBasicData(name, locId)
ClassMethod InitTemplateItem(name, locId)
{
	set lastRowId=+$g(^DHCICUPara(0))
	Set paraId=$ORDER(^DHCICUPara(100),-1)
    Set paraId=paraId+1
    If (paraId>100)
    {
        Return "paraId>100" 
    }
	// 科室模板数据和科室模板属性数据
	// 备份数据
	Merge ^TempBackupInitTemplateItem(paraId,$HOROLOG)=^DHCICUPara(paraId,"I")
    
	Kill ^DHCICUPara(paraId,"I")
	Merge ^DHCICUPara(paraId,"I")=^DHCICUTemplateDataBak(name)
	Set loc=##class(User.CTLoc).%OpenId(locId)
    set $p(^DHCICUPara(paraId),"^",2)=locId
    set $p(^DHCICUPara(paraId),"^",6)="ICUConfiguration"
    set ^DHCICUPara(0,"Ctloc",locId,paraId)=""
    if (lastRowId<=100)
    {
	    set ^DHCICUPara(0)=100
    }
   	Quit "初始化模版成功"
}

/*ClassMethod InitHisMenu()
{
	do ..SaveHisMenu("INPNURHEAD","DHC.IP.ICU.Nurse.Manager", "重症管理", "", "", "", "0", "006", "HeaderMenu", "", "", "", "")
	do ..SaveHisMenu("INPDOCHEAD", "DHC.IP.ICU.Doctor.Manager", "重症管理", "", "", "", "0", "007", "HeaderMenu", "2013/11/13 0:00:00", "13:34:56", 1, "")
	do ..SaveHisMenu("System.MainMenu","DHC.ICU.Base.Side", "重症监护", "", "", "", "", "52", "SideMenu", "2012/4/18 0:00:00", "11:36:20", 1, "")
	// demo菜单
	// do ..SaveHisMenu("DHCICUBedEquipDetail", "重症监护设备-停用", "dhcicubedequip.csp", "", "", "", "", "SideMenu", "2015/3/9 0:00:00", "22:39:29", 1, "")
	do ..SaveHisMenu("DHC.ICU.Base.Side", "dhcicucrecorditem.csp", "重症常用医嘱", "dhcicucrecorditem.csp", "", "", "", "", "SideMenu", "2015/3/12 0:00:00", "10:56:09", 1, "")
	do ..SaveHisMenu("DHC.ICU.Base.Side", "DHCICUDisplayTemplate", "科室显示模板-停用", "DHCICUDisplayTemplate.csp", "", "", "", "", "SideMenu", "2015/3/9 0:00:00", "22:46:33", 1, "")
	do ..SaveHisMenu("DHC.ICU.Base.Side", "DHCICUCommonOrdMapping", "医嘱关联常用医嘱-停用", "websys.default.csp", "", "", "", "", "SideMenu", "2015/3/9 0:00:00", "22:41:28", 1, """&IcuApply=Y""")
	do ..SaveHisMenu("DHC.ICU.Base.Side", "DHCICUCProperty", "显示项属性", "websys.default.csp", "", "", "", "", "SideMenu", "2013/8/9 0:00:00", "8:50:16", 1, "")
	
	do ..SaveHisMenu("DHC.ICU.Base.Side", "DHCICUDoctorArrange", "重症列表-停用", "dhcicuarrangeandbedequip.csp", "", "", "", "", "HeaderMenu", "2015/3/4 0:00:00", "14:10:45", 1, "")
	do ..SaveHisMenu("DHC.ICU.Base.Side", "DHCICUBedEquipExt", "重症监护设备", "DHCICUBedEquipExt.CSP", "", "", "", "", "SideMenu", "2015/3/9 0:00:00", "22:48:53", 1, "")
	do ..SaveHisMenu("DHC.ICU.Base.Side", "DHCICUCInquiry", "重症统计配置", "DHCICUCInquiry.csp", "", "", "", "", "SideMenu", "2015/11/19 0:00:00", "14:01:47", 1, "")
	do ..SaveHisMenu("DHC.ICU.Base.Side", "dhcicucviewcat", "重症显示分类维护", "dhcicucviewcat.csp", "", "", "", "", "SideMenu", "2015/3/9 0:00:00", "22:49:24", 1, "")
	do ..SaveHisMenu("DHC.ICU.Base.Side", "dhcicucviewsupercat", "重症显示大类维护", "dhcicucviewsupercat.csp", "", "", "", "", "SideMenu", "2015/3/9 0:00:00", "22:51:28", 1, "")
	do ..SaveHisMenu("DHC.ICU.Base.Side", "icucioitemext", "重症项目汇总", "DHCICUCIOItem.csp", "", "", "", "", "SideMenu", "2015/3/9 0:00:00", "22:51:06", 1, "")
	do ..SaveHisMenu("DHC.ICU.Base.Side", "DHCICUComOrdInstructExtjs", "常用医嘱关联用药途径", "DHCICUComOrdInstructExtjs.CSP", "", "", "", "", "SideMenu", "2015/3/9 0:00:00", "22:51:49", 1, "")
	do ..SaveHisMenu("DHC.ICU.Base.Side", "DHCICUCommonOrdMappingExtjs", "医嘱关联常用医嘱", "DHCICUCommonOrdMappingExtjs.CSP", "", "", "", "", "SideMenu", "2015/3/9 0:00:00", "22:49:39", 1, "")
	do ..SaveHisMenu("DHC.ICU.Base.Side", "DHCICUDisplayPropertiesExt", "科室显示模板", "dhcicudisplaytemplateext.csp", "", "", "", "", "SideMenu", "2015/3/9 0:00:00", "22:46:59", 1, "")
	//do ..SaveHisMenu("DHC.IP.ICU.Doctor.Manager","dhcicuarrangeExt", "重症监护列表-停用", "dhcicuarrange.csp", "", "CheckLinkDetails", "", "", "HeaderMenu", "2016/7/21 0:00:00", "16:21:51", 1, "")
	do ..SaveHisMenu("DHC.IP.ICU.Doctor.Manager","DHCICUTotal", "重症统计", "dhcicurecord3.csp", "", "StartICUAutoTotal", "0", "003", "HeaderMenu", "2015/11/19 0:00:00", "14:01:28", 1, "")
	//do ..SaveHisMenu("dhcicuarrangeExtNew", "重症列表-停用2", "dhcicuarrangeExt.csp", "", "", "0", "", "HeaderMenu", "2018/10/24 0:00:00", "9:32:05", 1, "")
	
	// 护士
	do ..SaveHisMenu("DHC.IP.ICU.Nurse.Manager""dhcicuarrange.view", "重症列表", "dhcicuarrange.view.csp", "bottom:10px;right:10px;", "", "0", "", "HeaderMenu", "2018/10/24 0:00:00", "9:42:52", 1, "")
	do ..SaveHisMenu("DHC.IP.ICU.Nurse.Manager","dhcicuarrange.view.IPNurse", "重症列表", "dhcicuarrange.view.csp", "bottom:10px;right:10px;", "", "0", "002", "HeaderMenu", "", "", "", "")
	do ..SaveHisMenu("DHC.IP.ICU.Nurse.Manager","DHCICUDisplay.IPNurse", "重症监护", "dhcicurecord2.csp", "", "StartICUMonitoring", "0", "001", "HeaderMenu", "", "", "", "")
	do ..SaveHisMenu("DHC.IP.ICU.Nurse.Manager","DHCICUTotal.IPNurse", "重症统计", "dhcicurecord3.csp", "", "StartICUAutoTotal", "0", "003", "HeaderMenu", "", "", "", "")
	do ..SaveHisMenu("DHC.IP.ICU.Nurse.Manager","DHCICUDisplay.OutNurse", "重症监护", "dhcicurecord2.csp", "", "StartICUMonitoring", "0", "001", "HeaderMenu", "", "", "", "")
	do ..SaveHisMenu("DHC.IP.ICU.Nurse.Manager","dhcicu.nurse.statistic.index", "重症统计新", "dhcicu.statistic.index.csp", "", "", "0", "003", "HeaderMenu", "", "", "", "")
	// 医生
	do ..SaveHisMenu("DHC.IP.ICU.Doctor.Manager","dhcicuarrange.view.OutNurse", "重症列表", "dhcicuarrange.view.csp", "bottom:10px;right:10px;", "", "0", "002", "HeaderMenu", "", "", "", "")
	do ..SaveHisMenu("DHC.IP.ICU.Doctor.Manager","DHCICUDisplay", "重症监护", "dhcicurecord2.csp", "", "StartICUMonitoring", "0", "002", "HeaderMenu", "2013/12/25 0:00:00", "16:05:04", 1, "")
    do ..SaveHisMenu("DHC.IP.ICU.Doctor.Manager","DHC.IP.ICU.Doctor.Manager.OutNurse", "重症统计", "dhcicurecord3.csp", "", "StartICUAutoTotal", "0", "003", "HeaderMenu", "", "", "", "")
    set id=..SaveHisMenu("DHC.IP.ICU.Doctor.Manager","dhcicu.doctor.statistic.indexxxxx", "重症统计xxxx", "dhcicu.statistic.index.csp", "", "", "0", "003", "HeaderMenu", "", "", "", "")
	
	b // DHC.IP.ICU.NurseManage
	
	quit "Over"
}
*/
/// 添加ICU使用的HIS菜单，该方法只在重症上线前搭建环境时执行
/// w ##class(web.DHCICUPublish).InitHisMenu()
/// 因HIS图片控不能由程序添加
ClassMethod SaveTempItem(locId, code, nurseCode, factor, startTime, validSpan)
{
	set startTime=##class(web.DHCClinicCom).ConvertToDateH(startTime)
	set validSpan=##class(web.DHCClinicCom).ConvertToDateH(validSpan)
	&sql(select ICUCT_RowId into :rowId from DHC_ICUC_Temperature 
	where ICUCT_RecordItemCode=:code and ICUCT_CtlocId=:locId)
	
	
	if (rowId="")
	{
		set obj=##class(User.DHCICUCTemperature).%New(rowId)
	}
	else
	{
		set obj=##class(User.DHCICUCTemperature).%OpenId(rowId)
	}
	set obj.ICUCTRecordItemCode=code
	set obj.ICUCTObservationItemCode=nurseCode
	set obj.ICUCTDayFactor=factor
	set obj.ICUCTStartTime=startTime
	set obj.ICUCTValidSpan=validSpan
	set obj.ICUCTCtlocId=locId
	do obj.%Save()
	quit obj.%Id()
}

ClassMethod SaveIOItem(ICUCIOICode, ICUCIOIDesc, ICUCIOIType, ICUCIOIComOrdDr, ICUCIOIViewCatDr, ICUCIOIInstructDr, ICUCIOIActive, ICUCIOICtlocDr, ICUCIOIMainICUCIOIDr, ICUCIOIStrategy, ICUCIOIMultiple, ICUCIOIValueField)
{
	set rowId=..GetIdByCode("User.DHCICUCIOItem","ICUCIOI_Code",ICUCIOICode)
    set obj=##class(User.DHCICUCIOItem).%New()
    if (rowId="")
    {
    	set obj=##class(User.DHCICUCIOItem).%New()
    }
    else
    {
    	set obj=##class(User.DHCICUCIOItem).%OpenId(rowId)
    }
    set obj.ICUCIOICode=ICUCIOICode
    set obj.ICUCIOIDesc=ICUCIOIDesc
    set obj.ICUCIOIType=ICUCIOIType
    set obj.ICUCIOIComOrdDr=##class(User.DHCICUCRecordItem).%OpenId(ICUCIOIComOrdDr)
    set obj.ICUCIOIViewCatDr=##class(User.DHCICUCViewCat).%OpenId(ICUCIOIViewCatDr)  
    set obj.ICUCIOIInstructDr=ICUCIOIInstructDr
    set obj.ICUCIOIActive=ICUCIOIActive
    set obj.ICUCIOICtlocDr=ICUCIOICtlocDr
    set obj.ICUCIOIMainICUCIOIDr=##class(User.DHCICUCIOItem).%OpenId(ICUCIOIMainICUCIOIDr)    
    set obj.ICUCIOIStrategy=ICUCIOIStrategy
    set obj.ICUCIOIMultiple=ICUCIOIMultiple
    set obj.ICUCIOIValueField=ICUCIOIValueField
    do obj.%Save()
    quit obj.%Id()
}

ClassMethod BackupMedOrder()
{
	// 评分
	m ^User.DHCICUCModuleD=^User.DHCICUCModuleD20210906
	m ^User.DHCICUCModuleI=^User.DHCICUCModuleI20210906
	m ^User.DHCICUScoreD=^User.DHCICUScoreD20210906
	m ^User.DHCICUScoreI=^User.DHCICUScoreI20210906
	m ^User.DHCICUScoreDataD=^User.DHCICUScoreDataD20210906
	m ^User.DHCICUScoreDataI=^User.DHCICUScoreDataI20210906
	
	m ^User.DHCICUSheetD=^User.DHCICUSheetD20210906
	m ^User.DHCICUSheetI=^User.DHCICUSheetI20210906 

	// 导管
	m ^User.DHCICUCCatheterCategoryD=^User.DHCICUCCatheterCategoryD37
	m ^User.DHCICUCCatheterD=^User.DHCICUCCatheterD37
	m ^User.DHCICUCCatheterI=^User.DHCICUCCatheterI37
	m ^User.DHCICUCCatheterPosD=^User.DHCICUCCatheterPosD37
	m ^User.DHCICUCDeptCatheterCatD=^User.DHCICUCDeptCatheterCatD37
	m ^User.DHCICUCDeptCatheterCatI =^User.DHCICUCDeptCatheterCatI37
}

/// 备份重症科室模板数据至^DHCICUTemplateDataBak
/// 该方法用于标准版为项目准备基础数据
/// 参数：
///     name:用于添加备份的别名，如协和医院外科ICU
///     locId: 科室ID
///          
/// w ##class(web.DHCICUPublish).BackupTemplateItem("标准版",203)
ClassMethod BackupTemplateItem(name, locId)
{
	&sql(SELECT ICUP_RowId into :paraId FROM DHC_ICU_Para WHERE ICUP_Ctloc_Dr=:locId)
	quit:paraId="" locId_"没有配置科室模板"
	// 科室模板数据和科室模板属性数据
	m ^DHCICUTemplateDataBak(name)=^DHCICUPara(paraId,"I")
	q "备份成功"
}

/// 备份重症基础数据至^DHCICUBasicDataBak
/// 该方法用于标准版为项目准备基础数据
/// 参数：
///     tag:用于添加备份的别名
///          如,tag=20210324,备份后Global名字为^DHCICUBasicDataBak20210324
/// w ##class(web.DHCICUPublish).BackupBasicData()
ClassMethod BackupBasicData(tag = "")
{
	x "kill ^DHCICUBasicDataBak"_tag
	set sub=""
	
	for
	{
		set sub=$O(^DHCICUC(sub))
		quit:(sub="")
		Continue:sub="AnticoagulantDrug"
		Continue:sub="IOItem"
		Continue:sub="InquiryCode"
		

		w "backup:",sub,"=>^DHCICUBasicDataBak",!
		x "merge "_"^DHCICUBasicDataBak"_tag_"("""_sub_""")=^DHCICUC("""_sub_""")"
	}
	// 评分
	Merge ^DHCICUBasicDataBak(tag_"^User.DHCICUCModuleD")=^User.DHCICUCModuleD
	Merge ^DHCICUBasicDataBak(tag_"^User.DHCICUCModuleI")=^User.DHCICUCModuleI
	//Merge ^DHCICUBasicDataBak(tag_"^User.DHCICUScoreD")=^User.DHCICUScoreD
	//Merge ^DHCICUBasicDataBak(tag_"^User.DHCICUScoreI")=^User.DHCICUScoreI
	//Merge ^DHCICUBasicDataBak(tag_"^User.DHCICUScoreDataD")=^User.DHCICUScoreDataD
	//Merge ^DHCICUBasicDataBak(tag_"^User.DHCICUScoreDataI")=^User.DHCICUScoreDataI
	//Merge ^DHCICUBasicDataBak(tag_"^User.DHCICUSheetD")=^User.DHCICUSheetD
	//Merge ^DHCICUBasicDataBak(tag_"^User.DHCICUSheetI")=^User.DHCICUSheetI
	Merge ^DHCICUBasicDataBak(tag_"^User.DHCICUCPrintTemplateD")=^User.DHCICUCPrintTemplateD
	Merge ^DHCICUBasicDataBak(tag_"^User.DHCICUCPrintTemplateI")=^User.DHCICUCPrintTemplateI

	// 导管
	Merge ^DHCICUBasicDataBak(tag_"^User.DHCICUCCatheterD")=^User.DHCICUCCatheterD
	Merge ^DHCICUBasicDataBak(tag_"^User.DHCICUCCatheterI")=^User.DHCICUCCatheterI
	Merge ^DHCICUBasicDataBak(tag_"^User.DHCICUCCatheterCategoryD")=^User.DHCICUCCatheterCategoryD
	Merge ^DHCICUBasicDataBak(tag_"^User.DHCICUCCatheterCategoryI")=^User.DHCICUCCatheterCategoryI
	Merge ^DHCICUBasicDataBak(tag_"^User.DHCICUCDeptCatheterCatD")=^User.DHCICUCDeptCatheterCatD
	Merge ^DHCICUBasicDataBak(tag_"^User.DHCICUCDeptCatheterCatI")=^User.DHCICUCDeptCatheterCatI
	Merge ^DHCICUBasicDataBak(tag_"^User.DHCICUCCatheterPosD")=^User.DHCICUCCatheterPosD
	Merge ^DHCICUBasicDataBak(tag_"^User.DHCICUCCatheterPosI")=^User.DHCICUCCatheterPosI
	
	quit "S^"
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
