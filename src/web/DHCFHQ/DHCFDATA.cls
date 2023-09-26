/// 更新数据
Class web.DHCFHQ.DHCFDATA Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

ClassMethod UpData(ChangeType As %String = "", RowStr As %String = "", UpType As %String = "", Para As %String = "") As %String
{
	q:UpType=""
	s RetStr=""
	if Para'=""  d
	.s DateStr=$p(Para,"^")
	else  d
	.s DateStr=""
    s:UpType="CareMark" RetStr=##class(web.DHCFHQ.DHCFFHQ).CareMark(ChangeType,RowStr) //科室普通号别
	s:UpType="CTGROUP" RetStr=##class(web.DHCFHQ.DHCFFHQ).CtGroup(ChangeType,RowStr) //科室部门组
	s:UpType="CTLOC" RetStr=##class(web.DHCFHQ.DHCFFHQ).CtLoc(ChangeType,RowStr) //科室
	s:UpType="CtLink" RetStr=##class(web.DHCFHQ.DHCFFHQ).CtLink(ChangeType,RowStr) //科室关联
	s:UpType="CtSpecialty" RetStr=##class(web.DHCFHQ.DHCFFHQ).CtSpecialty(ChangeType,RowStr) //科室专业组
	s:UpType="CARETYPE" RetStr=##class(web.DHCFHQ.DHCFFHQ).CareType(ChangeType,RowStr) //医嘱护类型
	s:UpType="CtSpec" RetStr=##class(web.DHCFHQ.DHCFFHQ).CtSpec(ChangeType,RowStr) // 医生专长
	s:UpType="TarFac" RetStr=##class(web.DHCFHQ.DHCFFHQ).TarFac(ChangeType,RowStr) //
	s:UpType="BillCon" RetStr=##class(web.DHCFHQ.DHCFFHQ).BillCondition(ChangeType,RowStr) //记帐系统
	s:UpType="CTPROV" RetStr=##class(web.DHCFHQ.DHCFFHQ).CareData(ChangeType,RowStr) //医护人员
	s:UpType="UpCareSpec" RetStr=##class(web.DHCFHQ.DHCFFHQ).UpCareSpec(ChangeType,RowStr) //
	s:UpType="CTUOM" RetStr=##class(web.DHCFHQ.DHCFFHQ).CtUom(ChangeType,RowStr) //单位
	s:UpType="MANUFACTURER" RetStr=##class(web.DHCFHQ.DHCFFHQ).ManuFacturer(ChangeType,RowStr) //
	s:UpType="PHCFORM" RetStr=##class(web.DHCFHQ.DHCFFHQ).PhcForm(ChangeType,RowStr) //剂型
	s:UpType="STOCKTYPE" RetStr=##class(web.DHCFHQ.DHCFFHQ).StockType(ChangeType,RowStr) //库存与盘点分类
	s:UpType="PHCCAT" RetStr=##class(web.DHCFHQ.DHCFFHQ).PhcCat(ChangeType,RowStr) //药理学分类
	s:UpType="PhcPoison" RetStr=##class(web.DHCFHQ.DHCFFHQ).PhcPoison(ChangeType,RowStr) //药品管理分类
	s:UpType="PhcFreq" RetStr=##class(web.DHCFHQ.DHCFFHQ).PhcFreq(ChangeType,RowStr) //频次
	s:UpType="OECCAT" RetStr=##class(web.DHCFHQ.DHCFFHQ).OrdCat(ChangeType,RowStr) //医嘱子类
	s:UpType="OECCATHosp" RetStr=##class(web.DHCFHQ.DHCFFHQ).OrdCatHosp(ChangeType,RowStr) //医嘱子类集团化多院区
	s:UpType="ARCCatRecLoc" RetStr=##class(web.DHCFHQ.DHCFFHQ).ARCCatRecLoc(ChangeType,RowStr) //医嘱子类接收科室导入
	s:UpType="OECCatRecLoc" RetStr=##class(web.DHCFHQ.DHCFFHQ).OECCatRecLoc(ChangeType,RowStr) //医嘱大类接收科室导入
	s:UpType="DHCExaBorough" RetStr=##class(web.DHCFHQ.DHCFFHQ).DHCExaBorough(ChangeType,RowStr) //诊区导入
	s:UpType="DHCBorExaRoom" RetStr=##class(web.DHCFHQ.DHCFFHQ).DHCBorExaRoom(ChangeType,RowStr) //诊区与诊室对照
	s:UpType="DHCExaBorDep" RetStr=##class(web.DHCFHQ.DHCFFHQ).DHCExaBorDep(ChangeType,RowStr) //诊区与科室对照导入
	s:UpType="DHCMarkDoc" RetStr=##class(web.DHCFHQ.DHCFFHQ).DHCMarkDoc(ChangeType,RowStr) //医生与号别对照室导入
	s:UpType="DHCDepMark" RetStr=##class(web.DHCFHQ.DHCFFHQ).DHCDepMark(ChangeType,RowStr) //诊区与号别对照导入
	s:UpType="PHCINSTRUC" RetStr=##class(web.DHCFHQ.DHCFFHQ).PhcInstruc(ChangeType,RowStr) //用法
	s:UpType="PACROOM" RetStr=##class(web.DHCFHQ.DHCFFHQ).PacRoom(ChangeType,RowStr) //房间
	s:UpType="PACBED" RetStr=##class(web.DHCFHQ.DHCFFHQ).PacBed(ChangeType,RowStr) //病人床位
	s:UpType="WaitArea" RetStr=##class(web.DHCFHQ.DHCFFHQ).WaitArea(ChangeType,RowStr) //房间
	s:UpType="UpBed" RetStr=##class(web.DHCFHQ.DHCFFHQ).UpBed(ChangeType,RowStr) //病人床位
	
	s:UpType="DRUG" RetStr=##class(web.DHCFHQ.DHCFFHQ).DrugData(ChangeType,RowStr) //药品
	s:UpType="CityArea" RetStr=##class(web.DHCFHQ.DHCFFHQ).CityArea(ChangeType,RowStr) //省市区县数据更新插入
	s:UpType="DrugDataGen" RetStr=##class(web.DHCFHQ.DHCFFHQ).DrugDataGen(ChangeType,RowStr) //药品通用名
	s:UpType="MRCDiagnosSignSymptom" RetStr=##class(web.DHCFHQ.DHCFFHQ).MRCDiagnosSignSymptom(ChangeType,RowStr) //辩证
	s:UpType="Phcuration" RetStr=##class(web.DHCFHQ.DHCFFHQ).Phcuration(ChangeType,RowStr) //疗程
	s:UpType="CtCountry" RetStr=##class(web.DHCFHQ.DHCFFHQ).CtCountry(ChangeType,RowStr) //国籍
	s:UpType="CtNation" RetStr=##class(web.DHCFHQ.DHCFFHQ).CtNation(ChangeType,RowStr) //民族
	//药品相关
	s:UpType="PhcDisCatAndOrdSubCat" RetStr=##class(web.DHCFHQ.DHCFFHQ).PhcDisCatAndOrdSubCat(ChangeType,RowStr) //摆药分类与医嘱子类对照
	s:UpType="PhVendor" RetStr=##class(web.DHCFHQ.DHCFFHQ).PhVendor(ChangeType,RowStr)
	
	s:UpType="TARTYPE" RetStr=##class(web.DHCFHQ.DHCFFHQ).TarType(ChangeType,RowStr) //收费类别
	s:UpType="ARCITM" RetStr=##class(web.DHCFHQ.DHCFFHQ).ArcimData(ChangeType,RowStr) //医嘱数据
	s:UpType="ArcRec" RetStr=##class(web.DHCFHQ.DHCFFHQ).ArcRec(ChangeType,RowStr) //医嘱项接收科室
	
	s:UpType="OrdSet" RetStr=##class(web.DHCFHQ.DHCFFHQ).OrdSet(ChangeType,RowStr) //医嘱套
	s:UpType="OrdExtCode" RetStr=##class(web.DHCFHQ.DHCFFHQ).OrdExtCode(ChangeType,RowStr) //外部代码
	s:UpType="UPARCITM" RetStr=##class(web.DHCFHQ.DHCFFHQ).ArcimDataUp(ChangeType,RowStr)
	
	s:UpType="ArcimAlias" RetStr=##class(web.DHCFHQ.DHCFFHQ).ArcimAlias(ChangeType,RowStr) //医嘱别名
	
	;s:UpType="PatInof" RetStr=##class(web.DHCFHQ.DHCFFHQ).PatInfo(ChangeType,RowStr)
	;s:UpType="PatInof" RetStr=##class(web.DHCFHQ.DHCFFHQ).SetGloble(RowStr)
	s:UpType="PatInof" RetStr=##class(web.DHCFHQ.DHCFFHQ).UPPat(ChangeType,RowStr)
	s:UpType="RBSessType" RetStr=##class(web.DHCFHQ.DHCFFHQ).RbSessionType(ChangeType,RowStr)
	s:UpType="PreUnit" RetStr=##class(web.DHCFHQ.DHCFFHQ).PreUnit(ChangeType,RowStr) //预约单位
	s:UpType="Schedule" RetStr=##class(web.DHCFHQ.DHCFFHQ).Schedule(ChangeType,RowStr,DateStr) //排表表
	s:UpType="SSGROUP" RetStr=##class(web.DHCFHQ.DHCFFHQ).SSGroup(ChangeType,RowStr) //安全组
	s:UpType="CTTITLE" RetStr=##class(web.DHCFHQ.DHCFFHQ).CtTitle(ChangeType,RowStr) //职务
	s:UpType="ChangeData" RetStr=##class(web.DHCFHQ.DHCFFHQ).CtZip(ChangeType,RowStr)
	;s:UpType="ChangeData" RetStr=##class(web.DHCFHQ.DHCFFHQUP).UpTarItem(ChangeType,RowStr)

	s:UpType="IcdDate" RetStr=##class(web.DHCFHQ.DHCFFHQ).ICD(ChangeType,RowStr) //ICD
	s:UpType="EqResource" RetStr=##class(web.DHCFHQ.DHCFFHQ).EqResource(ChangeType,RowStr) //设备与资源
	s:UpType="ICD9-CM3" RetStr=##class(web.DHCFHQ.DHCFFHQ).ICD9CM3(ChangeType,RowStr) //手术CM3模板
	s:UpType="Level" RetStr=##class(web.DHCFHQ.DHCFFHQ).Level(ChangeType,RowStr) //手术CM3模板
	s:UpType="PatChangeType" RetStr=##class(web.DHCFHQ.DHCFFHQ).PatChangeType(ChangeType,RowStr) //费别
	s:UpType="CtSpecmen" RetStr=##class(web.DHCFHQ.DHCFFHQ).CtSpecmen(ChangeType,RowStr) //标本
	s:UpType="NewCard" RetStr=##class(web.DHCFHQ.DHCFFHQ).NewCard(ChangeType,RowStr) //批量建卡
	s:UpType="Operation" RetStr=##class(web.DHCFHQ.DHCFFHQ).Operation(ChangeType,RowStr) //手术
	s:UpType="ArcInsuranceType" RetStr=##class(web.DHCFHQ.DHCFFHQ).ArcInsuranceType(ChangeType,RowStr) //商业保险
	s:UpType="CTHealthCareProvider" RetStr=##class(web.DHCFHQ.DHCFFHQ).CTHealthCareProvider(ChangeType,RowStr) //合同单位记账
	s:UpType="UpdateDrugotherinfo" RetStr=##class(web.DHCFHQ.DHCFFHQ).UpdateDrugotherinfo(ChangeType,RowStr) //药物信息更新
	s:UpType="DHCRFRETREASON" RetStr=##class(web.DHCFHQ.DHCFFHQ).DHCRFRETREASON(ChangeType,RowStr) //不可退药原因
	s:UpType="CtEducation" RetStr=##class(web.DHCFHQ.DHCFFHQ).CtEducation(ChangeType,RowStr) //导入学历字典
	s:UpType="CtOccupation" RetStr=##class(web.DHCFHQ.DHCFFHQ).CtOccupation(ChangeType,RowStr) //职业
	s:UpType="CtRelation" RetStr=##class(web.DHCFHQ.DHCFFHQ).CtRelation(ChangeType,RowStr) //关系
	s:UpType="CtTransDoc" RetStr=##class(web.DHCFHQ.DHCFFHQ).CtTransDoc(ChangeType,RowStr) //轮转医生
	s:UpType="RBResourceDate" RetStr=##class(web.DHCFHQ.DHCFFHQ).RBResourceDate(ChangeType,RowStr) //轮转医生
	s:UpType="InsertDepMark" RetStr=##class(web.DHCFHQ.DHCFFHQ).InsertDepMark(ChangeType,RowStr) //诊区科室号别对照	
	s:UpType="RBResourceDate" RetStr=##class(web.DHCFHQ.DHCFFHQ).RBResourceDate(ChangeType,RowStr) //轮转医生
	s:UpType="InsertDepMark" RetStr=##class(web.DHCFHQ.DHCFFHQ).InsertDepMark(ChangeType,RowStr) //诊区科室号别对照
	s:UpType="COMPAREDATA" RetStr=##class(web.DHCFHQ.DHCFFHQ).COMPAREDATA(ChangeType,RowStr) //药品数据校对
	s:UpType="ZLCompare" RetStr=##class(web.DHCFHQ.DHCFFHQ).ZLCompare(ChangeType,RowStr) //诊疗数据校对更新

	//if ChangeType="Test" TROLLBACK  Quit RetStr
	Q RetStr
}

ClassMethod UpDataBatch(ChangeType As %String = "", UpType As %String = "", DateStr As %String = "") As %String
{
	;d ##class(web.DHCFFHQ).UpDataBatch("Test","Schedule","11/29/2007")
	q:UpType=""
	s del="^",RowNum=0
	Q:($G(^TMPFHQ(UpType,0))<1) "没有数据"
	s RetStr=""
	s DateStr=$zdh(DateStr,4)
	TSTART
	IF ChangeType="Init" d
	.s ChangeType="Clear"
	.s RowStr=""
	.s:UpType="CTGROUP" RetStr=##class(web.DHCFHQ.DHCFFHQ).CtGroup(ChangeType,RowStr)
	.s:UpType="CTLOC" RetStr=##class(web.DHCFHQ.DHCFFHQ).CtLoc(ChangeType,RowStr)
	.s:UpType="CTSPEC" RetStr=##class(web.DHCFHQ.DHCFFHQ).CtSpecialty(ChangeType,RowStr)
	.s:UpType="CARETYPE" RetStr=##class(web.DHCFHQ.DHCFFHQ).CareType(ChangeType,RowStr)
	.s:UpType="CTPROV" RetStr=##class(web.DHCFHQ.DHCFFHQ).CareData(ChangeType,RowStr)
	.s:UpType="CTUOM" RetStr=##class(web.DHCFHQ.DHCFFHQ).CtUom(ChangeType,RowStr)
	.s:UpType="MANUFACTURER" RetStr=##class(web.DHCFHQ.DHCFFHQ).ManuFacturer(ChangeType,RowStr)
	.s:UpType="PHCFORM" RetStr=##class(web.DHCFHQ.DHCFFHQ).PhcForm(ChangeType,RowStr)
	.s:UpType="STOCKTYPE" RetStr=##class(web.DHCFHQ.DHCFFHQ).StockType(ChangeType,RowStr)
	.s:UpType="PHCCAT" RetStr=##class(web.DHCFHQ.DHCFFHQ).PhcCat(ChangeType,RowStr)
	.s:UpType="TarFac" RetStr=##class(web.DHCFHQ.DHCFFHQ).TarFac(ChangeType,RowStr)
	.s:UpType="OECCAT" RetStr=##class(web.DHCFHQ.DHCFFHQ).OrdCat(ChangeType,RowStr)
	.s:UpType="PACROOM" RetStr=##class(web.DHCFHQ.DHCFFHQ).PacRoom(ChangeType,RowStr)
	.s:UpType="PACBED" RetStr=##class(web.DHCFHQ.DHCFFHQ).PacBed(ChangeType,RowStr)
	.s:UpType="WaitArea" RetStr=##class(web.DHCFHQ.DHCFFHQ).WaitArea(ChangeType,RowStr)
	.s:UpType="UpBed" RetStr=##class(web.DHCFHQ.DHCFFHQ).UpBed(ChangeType,RowStr)
	.s:UpType="DRUG" RetStr=##class(web.DHCFHQ.DHCFFHQ).DrugData(ChangeType,RowStr)
	.s:UpType="ARCITM" RetStr=##class(web.DHCFHQ.DHCFFHQ).ArcimData(ChangeType,RowStr)
	.s:UpType="PatInof" RetStr=##class(web.DHCFHQ.DHCFFHQ).PatInfo(ChangeType,RowStr)
	.s:UpType="RBSessType" RetStr=##class(web.DHCFHQ.DHCFFHQ).RbSessionType(ChangeType,RowStr)
	.s:UpType="PreUnit" RetStr=##class(web.DHCFHQ.DHCFFHQ).PreUnit(ChangeType,RowStr)
	.s:UpType="Schedule" RetStr=##class(web.DHCFHQ.DHCFFHQ).Schedule(ChangeType,RowStr)
	.s:UpType="SSGROUP" RetStr=##class(web.DHCFHQ.DHCFFHQ).SSGroup(ChangeType,RowStr)
	.s:UpType="CTTITLE" RetStr=##class(web.DHCFHQ.DHCFFHQ).CtTitle(ChangeType,RowStr)
	.s:UpType="Level" RetStr=##class(web.DHCFHQ.DHCFFHQ).Level(ChangeType,RowStr)
	IF ChangeType="Clear" d
	.s ChangeType="Init"
	f  s RowNum=$o(^TMPFHQ(UpType,RowNum)) q:RowNum=""  d
	.s RowStr=^TMPFHQ(UpType,RowNum)
	.s:UpType="CTGROUP" RetStr=##class(web.DHCFHQ.DHCFFHQ).RetErrorValue(RetStr,"第"_RowNum_"行"_##class(web.DHCFHQ.DHCFFHQ).CtGroup(ChangeType,RowStr))
	.s:UpType="CTLOC" RetStr=##class(web.DHCFHQ.DHCFFHQ).RetErrorValue(RetStr,"第"_RowNum_"行"_##class(web.DHCFHQ.DHCFFHQ).CtLoc(ChangeType,RowStr))
	.s:UpType="CTSPEC" RetStr=##class(web.DHCFHQ.DHCFFHQ).RetErrorValue(RetStr,"第"_RowNum_"行"_##class(web.DHCFHQ.DHCFFHQ).CtSpecialty(ChangeType,RowStr))
	.s:UpType="CARETYPE" RetStr=##class(web.DHCFHQ.DHCFFHQ).RetErrorValue(RetStr,"第"_RowNum_"行"_##class(web.DHCFHQ.DHCFFHQ).CareType(ChangeType,RowStr))
	.s:UpType="CTPROV" RetStr=##class(web.DHCFHQ.DHCFFHQ).RetErrorValue(RetStr,"第"_RowNum_"行"_##class(web.DHCFHQ.DHCFFHQ).CareData(ChangeType,RowStr))
	.s:UpType="CTUOM" RetStr=##class(web.DHCFHQ.DHCFFHQ).RetErrorValue(RetStr,"第"_RowNum_"行"_##class(web.DHCFHQ.DHCFFHQ).CtUom(ChangeType,RowStr))
	.s:UpType="MANUFACTURER" RetStr=##class(web.DHCFHQ.DHCFFHQ).RetErrorValue(RetStr,"第"_RowNum_"行"_##class(web.DHCFHQ.DHCFFHQ).ManuFacturer(ChangeType,RowStr))
	.s:UpType="PHCFORM" RetStr=##class(web.DHCFHQ.DHCFFHQ).RetErrorValue(RetStr,"第"_RowNum_"行"_##class(web.DHCFHQ.DHCFFHQ).PhcForm(ChangeType,RowStr))
	.s:UpType="STOCKTYPE" RetStr=##class(web.DHCFHQ.DHCFFHQ).RetErrorValue(RetStr,"第"_RowNum_"行"_##class(web.DHCFHQ.DHCFFHQ).StockType(ChangeType,RowStr))
	.s:UpType="PHCCAT" RetStr=##class(web.DHCFHQ.DHCFFHQ).RetErrorValue(RetStr,"第"_RowNum_"行"_##class(web.DHCFHQ.DHCFFHQ).PhcCat(ChangeType,RowStr))
	.//s:UpType="TARPAYSELF" RetStr=##class(web.DHCFHQ.DHCFFHQ).RetErrorValue(RetStr,"第"_RowNum_"行"_##class(web.DHCFHQ.DHCFFHQ).TarPaySelf(ChangeType,RowStr))
	.s:UpType="OECCAT" RetStr=##class(web.DHCFHQ.DHCFFHQ).RetErrorValue(RetStr,"第"_RowNum_"行"_##class(web.DHCFHQ.DHCFFHQ).OrdCat(ChangeType,RowStr))
	.//s:UpType="PHCINSTRUC" RetStr=##class(web.DHCFHQ.DHCFFHQ).RetErrorValue(RetStr,"第"_RowNum_"行"_##class(web.DHCFHQ.DHCFFHQ).PhcInstruc(ChangeType,RowStr))
	.s:UpType="PACROOM" RetStr=##class(web.DHCFHQ.DHCFFHQ).RetErrorValue(RetStr,"第"_RowNum_"行"_##class(web.DHCFHQ.DHCFFHQ).PacRoom(ChangeType,RowStr))
	.s:UpType="PACBED" RetStr=##class(web.DHCFHQ.DHCFFHQ).RetErrorValue(RetStr,"第"_RowNum_"行"_##class(web.DHCFHQ.DHCFFHQ).PacBed(ChangeType,RowStr))
	.s:UpType="DRUG" RetStr=##class(web.DHCFHQ.DHCFFHQ).RetErrorValue(RetStr,"第"_RowNum_"行"_##class(web.DHCFHQ.DHCFFHQ).DrugData(ChangeType,RowStr))
	.s:UpType="ARCITM" RetStr=##class(web.DHCFHQ.DHCFFHQ).RetErrorValue(RetStr,"第"_RowNum_"行"_##class(web.DHCFHQ.DHCFFHQ).ArcimData(ChangeType,RowStr))
	.s:UpType="PatInof" RetStr=##class(web.DHCFHQ.DHCFFHQ).RetErrorValue(RetStr,"第"_RowNum_"行"_##class(web.DHCFHQ.DHCFFHQ).PatInfo(ChangeType,RowStr))
	.s:UpType="RBSessType" RetStr=##class(web.DHCFHQ.DHCFFHQ).RetErrorValue(RetStr,"第"_RowNum_"行"_##class(web.DHCFHQ.DHCFFHQ).RbSessionType(ChangeType,RowStr))
	.s:UpType="PreUnit" RetStr=##class(web.DHCFHQ.DHCFFHQ).RetErrorValue(RetStr,"第"_RowNum_"行"_##class(web.DHCFHQ.DHCFFHQ).PreUnit(ChangeType,RowStr))
	.s:UpType="Schedule" RetStr=##class(web.DHCFHQ.DHCFFHQ).RetErrorValue(RetStr,"第"_RowNum_"行"_##class(web.DHCFHQ.DHCFFHQ).Schedule(ChangeType,RowStr,DateStr))
	.s:UpType="SSGROUP" RetStr=##class(web.DHCFHQ.DHCFFHQ).RetErrorValue(RetStr,"第"_RowNum_"行"_##class(web.DHCFHQ.DHCFFHQ).SSGroup(ChangeType,RowStr))
	.s:UpType="CTTITLE" RetStr=##class(web.DHCFHQ.DHCFFHQ).RetErrorValue(RetStr,"第"_RowNum_"行"_##class(web.DHCFHQ.DHCFFHQ).CtTitle(ChangeType,RowStr))
	.s:UpType="Level" RetStr=##class(web.DHCFHQ.DHCFFHQ).RetErrorValue(RetStr,"第"_RowNum_"行"_##class(web.DHCFHQ.DHCFFHQ).Level(ChangeType,RowStr))
	.s:UpType="NewCard" RetStr=##class(web.DHCFHQ.DHCFFHQ).RetErrorValue(RetStr,"第"_RowNum_"行"_##class(web.DHCFHQ.DHCFFHQ).NewCard(ChangeType,RowStr))
	if ChangeType="Test" d
	.TROLLBACK
	TCOMMIT
	q RetStr
}

/// 清除数据
ClassMethod ClearData(ChangeType As %String = "", UpType As %String = "", Para As %String = "") As %String
{
	q:UpType="" "没有正确的删除信息"
	s RetStr=""
	s RetStr= $ZOBJCLASSMETHOD("web.DHCFHQ.ClearData", UpType, ChangeType)
	q RetStr
	//药品业务 DRUGINFO
      //医嘱业务 ORDINFO
      //挂号及预约记录	APPOINT
      //排班记录	SHEDULE
      //发票信息    INVOICE
      //收费业务	CASHIER
      //  门诊收费业务	OUTPCASHIER
      //  住院收费业务	INPCASHIER
      //病人信息	PATINFO
      //库存管理业务	STOCKTRANS
      //药房业务	STOCKINFO
      //  门诊药房业务	OUTPSTOCKINFO
      //  住院药房业务	INPSTOCKINFO
      //RIS业务		RISINFO
      //病理业务	PISINFO
      //体验业务	TJINFO
      //心电业务	XDINFO
      //检验业务	LABINFO
      //电子病历业务	EPRINFO
      //医保业务	INSU
      //医政业务	DHCMED
      //  传染病业务	DHCMEDINFECT
      //  死亡业务	DHCMEDDIE
      //  垃圾业务	DHCRUBBISH
      //  医院感染业务	DHCINFECT
      //  临床路径	CLINICPATH
      //综合查询	WORKLOAD
      //护理业务	CLINICWARD
      //手术排班	OPERATION
      //重症监护	DHCICU
}

}
