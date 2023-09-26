/// 配库专用
Class web.DHCPE.Init Extends %Persistent
{

/// 体检科室ID  CT_Loc
Parameter LocID = 304;

/// 登记状态插入医嘱是否设置为"预开"状态  1:使用预开  非1：不使用预开状态
Parameter PreOrder = 0;

/// 自动提交科室默认的提交人SS_User
Parameter AutoAuditUser = 1;

/// 默认支付方式 CT_PayMode
Parameter DefaultPayMode = 1;

/// 自动到达 Y,N 设置医生界面^打印条码是否自动到达^到达界面读卡自动到达^打印指引单 
Parameter AutoArrived = "Y^N^N^N";

/// 医生录入界面默认正常值YN
Parameter AutoNormalResult = "Y";

/// 叫号接口YN
Parameter CallVoice = "N";

/// 能找零的支付方式
Parameter CanChangePayModes = "1,2";

/// 收费时，可以找零的特殊支付方式  CT_PayMode
Parameter SpecialPayModes = "1,2";

/// 默认识同收费的模式0：都不默认  1：个人视同收费 2：团体视同收费 3：都视同收费
Parameter CashierSystem = 2;

/// 团体收费是否需要允许缴费  1：需要  0：不需要
Parameter AllowCharge = 0;

/// 取消体检时是否删除未做的项目1：不删除
Parameter CancelPEType = 1;

/// 默认的病人类型、性别 、证件类型  自费^男^男^女^居民身份证  CT_SocialStatus  CT_Sex    PAC_CardType
Parameter DefPatientType = "1^^1^2^20";

/// 团体报告中是统计诊断还是疾病   以及打印的建议是疾病的建议还是诊断的建议  维护诊断时是否需要关联疾病
/// Y为疾病  N为诊断
Parameter GRDiagnosisType = "Y^Y^N";

/// 医院代码
Parameter HospitalCode = "BJXH";

/// 打印报告csp中间的代码,不设置就使用dhcpeireport.normal.*.csp
Parameter ReportCode;

/// 打印报告时化验项目是否合并标本号打印
Parameter LisReportMerge = "N";

/// 发票中打印的明细列数
Parameter InvCol = 1;

/// 打印发票的明细的格式：
/// 1:ItemName_"^"_ItemPrice_"^"_qty_"^"_FactAmount 
/// 2:ItemName_"^"_Uom_"^"_qty_"^"_FactAmount 
/// 3:ItemName_"^"_Uom_"^"_qty_"^"_ItemPrice_"^"_FactAmount
Parameter InvColSortType = 3;

/// 发票标志区别,友谊用N,复兴用空,其他用Y
Parameter InvFlag = "Y";

/// 打印发票时是否打印明细  1  打印  0 不打印
Parameter InvListFlag = 1;

/// 打印发票明细打印的行数
Parameter InvMaxListCount = 11;

/// 是否打印费用类别YN 统计发票中对应的化验费、检查费等具体
Parameter InvPrintCatInfo = "N";

/// 发票是否打印新分类，北京协和、北京有几家医院是新分类
Parameter TarOCIsNew = "N";

/// 检验是否接口 Y是 N公司的
Parameter LisInterface = "N";

/// 检验是否新版本  Y表示是新版本，N表示是旧版本
Parameter LisNewVersion = "Y";

/// 是否需要复检审核YN
Parameter MainDoctorGroup = "N";

/// 是否需要网上查看体检报告YN
Parameter NetReport = "N";

/// 默认的体检医生CT_CareProv
Parameter PhyExamDrId = 2;

/// 总检医生使用的安全组
Parameter SummarizeAudit = ",179,";

/// 是否调用平台方法发送接口信息YN
Parameter SendOrder = "N";

/// 套餐不拆分时默认的收费项ID，不设置就按照项目真实的分类走 DHC_TarItem
Parameter SetsDefaultTar;

/// 是否自动分币误差 0:没有  5：四舍五入  6：五舍六入
Parameter RoundManager = 0;

/// 超级权限的安全组可以修改提交以后的结果
Parameter SuperGroup = 164;

/// his系统的类别 MedTrak TrakCare
Parameter TrakVerison = "TrakCare";

/// 检验的命名空间名字
Parameter LABDATA = "LABDATA";

/// 数据的的命名空间名字
Parameter MEDDATA = "DHC-DATA";

/// 登记号的长度，不设置或者设置为0就不补零
Parameter RegNoLength = 10;

/// 登记号是否和卡表建立关联Yes No
Parameter CardRelate = "Yes";

/// 默认的卡类型DHC_CardTypeDef
Parameter CardType = 2;

/// 医嘱描述是否取缩写Arc_ItmMast 第二个位置
Parameter ItemAbridgeFlag = "N";

/// 体检拍照ftp信息  FTPIP^User^PassWord^Port^目录^图片高^图片宽  空的话不使用ftp
Parameter PhotoFTP = "10.160.16.90^root^Rootdb01^21^tmp^300^200";

/// 导出体检报告ftp  FTPIP^User^PassWord^Port^目录），不设置就是保存到本地
Parameter ReportFTP = "10.160.16.90^root^Rootdb01^21^tmp";

/// 体检号信息  前缀^长度
Parameter HPNo = "^10";

/// 未付费是否允许打印 Y:允许  N:不允许
Parameter AllowPrint = "Y";

/// 体检收费退费是否插入门诊发票表数据  Y  N
Parameter InsertOPInv = "N";

/// 登记或者确认加项时，弹出RIs申请界面的站点
Parameter SendRisApplication = "^13^14^15^27^28^";

/// 允许重复添加医嘱的站点
Parameter AllowAddItem;

/// 允许修改费用类别的安全组
Parameter FeeTypeSuperGroup = 1;

/// 是否调用新版检查申请单  Y 是   N 否
Parameter OrderInterface = "Y";

/// 调用新版检查申请时,插入医嘱调用医生站的M还是类方法 M:调用医生站M N：类方法
Parameter OrderInterfaceType = "N";

/// 检查站点
Parameter RisStation = "8^9^10^11^12";

/// 检验站点
Parameter LabStation = 7;

/// 药品站点
Parameter MedicalStation = 20;

/// 其他站点
Parameter OtherStation = 18;

/// 复检是否打印报告 Y 打印 N不打印
Parameter MainReportPrint = "N";

/// 是否显示建议结论的符号[] Y 显示 其他 不显示
Parameter ShowEDDiagnosisSign = "Y";

/// 打印检验条码是否使用护理组NurseOrderOP.xml Y:调用护理组xml N:调用体检组打印条码cab包
Parameter PrintBarNurseXML = "Y";

/// 是否发送病理申请 Y 是 N 否
Parameter SendPisApplication = "Y";

/// 是否调用新产品组发送病理申请 Y 是 N 否
Parameter SendPisInterface = "Y";

/// 前台、后台发送病理申请 F 前台 B 后台
Parameter SendPisFBWay = "F";

/// 是否调用新产品组打印病理条码 Y 是 N 否
Parameter PrintPISTiaomaNew = "Y";

/// 处理基础数据
/// d ##class(web.DHCPE.Init).SetAllInfo()
ClassMethod SetAllInfo()
{
	//设置ID的Global
	d ##class(web.DHCPE.TempTools).SetEXID()
	//更新诊室对应的科室ID
	s LocID=..#LocID
	&SQL(Update SQLUser.DHC_PE_Area set A_Loc_DR=:LocID)
	//更新建议对应的科室
	&SQL(Update SQLUser.DHC_PE_EDLoc set EDL_Loc_DR=:LocID)
	//更新建议的小分类
	&SQL(Update SQLUser.DHC_PE_ExpertDiagnosis set ED_StationLocID=null)
	//更新基础数据,设置站点代码和新建医嘱项的对照关系
	s PLIST("1")="PE001"
	s PLIST("2")="PE002"
	s PLIST("3")="PE003"
	s PLIST("4")="PE004"
	s PLIST("5")="PE005"
	s PLIST("6")="PE006"
	s PLIST("21")="PE007"
	s PLIST("22")="PE008"
	s PLIST("23")="PE009"
	s PLIST("31")="PE010"
	s STID=0
	f  s STID=$O(^DHCPEST(STID)) q:STID=""  d
	.s STCode=$P(^DHCPEST(STID),"^",1)
	.i $D(PLIST(STCode)) d
	..s ArcCode=PLIST(STCode)
	..s ArcimID=$O(^ARCIM(0,"Code",ArcCode,0))
	..i ArcimID="" w STID_"设置的对应医嘱编码不存在"_ArcCode,!
	..q:ArcimID=""
	..s ArcimID=ArcimID_"||1"
	..s OSub=$O(^DHCPEST(STID,"O",0))
	..q:OSub=""
	..s OldArcimID=$P(^DHCPEST(STID,"O",OSub),"^",1)
	..;b ;OldArcimID
	..&SQL(Update SQLUser.DHC_PE_StationOrder set STORD_ARCIM_DR=:ArcimID where STORD_ARCIM_DR=:OldArcimID)
	..w:SQLCODE'=0 STID_"更新大项错误"_SQLCODE,!
	..q:SQLCODE'=0
	..&SQL(Update SQLUser.DHC_PE_OrderDetailRelate set ODR_ARCIM_DR=:ArcimID where ODR_ARCIM_DR=:OldArcimID)
	..w:SQLCODE'=0 STID_"更新大项和细项组合错误"_SQLCODE,!
	..q:SQLCODE'=0
	
	..&SQL(Delete from SQLUser.DHC_PE_StationOrder where STORD_ParRef=:STID and STORD_ChildSub <> :OSub)
	..s:SQLCODE=100 SQLCODE=0
	..w:(SQLCODE'=0) STID_"删除大项错误"_SQLCODE,!
	..q:SQLCODE'=0
	.e  d
	..&SQL(Delete from SQLUser.DHC_PE_StationOrder where STORD_ParRef=:STID)
	..s:SQLCODE=100 SQLCODE=0
	..w:(SQLCODE'=0) STID_"删除大项错误"_SQLCODE,!
	..q:SQLCODE'=0
	&SQL(Delete from SQLUser.DHC_PE_OrderDetailRelate where ODR_ARCIM_DR not in (select STORD_ARCIM_DR from SQLUser.DHC_PE_StationOrder))
	s:SQLCODE=100 SQLCODE=0
	w:SQLCODE'=0 "删除不存在的细项关联错误"_SQLCODE,!
	&SQL(Delete from SQLUser.DHC_PE_OrderDetail where OD_RowId not in (select ODR_OD_DR from SQLUser.DHC_PE_OrderDetailRelate))
	s:SQLCODE=100 SQLCODE=0
	w:SQLCODE'=0 "删除不存在的细项错误"_SQLCODE,!
	d ..DeleteOtherData()
	//设置站点Setting中的global
	k ^DHCPESetting
	d ..SetSetting()
	d ##class(web.DHCPE.Station).SetSettingGlobal()
}

/// 处理基础数据
/// d ##class(web.DHCPE.Init).SetAllInfoNew()
ClassMethod SetAllInfoNew()
{
	//设置ID的Global
	d ##class(web.DHCPE.TempTools).SetEXID()
	//更新诊室对应的科室ID
	s LocID=..#LocID
	&SQL(Update SQLUser.DHC_PE_Area set A_Loc_DR=:LocID)
	//更新建议对应的科室
	&SQL(Update SQLUser.DHC_PE_EDLoc set EDL_Loc_DR=:LocID)
	//更新建议的小分类
	&SQL(Update SQLUser.DHC_PE_ExpertDiagnosis set ED_StationLocID=null)
	//更新基础数据,设置站点代码和新建医嘱项的对照关系
	s PLIST("1")="PE001"
	s PLIST("2")="PE002"
	s PLIST("3")="PE003"
	s PLIST("4")="PE004"
	s PLIST("5")="PE005"
	s PLIST("6")="PE006"
	s PLIST("21")="PE007"
	s PLIST("22")="PE008"
	s PLIST("23")="PE009"
	s PLIST("31")="PE010"
	s STID=0
	f  s STID=$O(^DHCPEST(STID)) q:STID=""  d
	.s STCode=$P(^DHCPEST(STID),"^",1)
	.i $D(PLIST(STCode)) d
	..s ArcCode=PLIST(STCode)
	..s ArcimID=$O(^ARCIM(0,"Code",ArcCode,0))
	..i ArcimID="" w STID_"设置的对应医嘱编码不存在"_ArcCode,!
	..q:ArcimID=""
	..s ArcimID=ArcimID_"||1"
	..s OSub=$O(^DHCPEST(STID,"O",0))
	..q:OSub=""
	..s OldArcimID=$P(^DHCPEST(STID,"O",OSub),"^",1)
	..;b ;OldArcimID
	..&SQL(Update SQLUser.DHC_PE_StationOrder set STORD_ARCIM_DR=:ArcimID where STORD_ARCIM_DR=:OldArcimID)
	..w:SQLCODE'=0 STID_"更新大项错误"_SQLCODE,!
	..q:SQLCODE'=0
	..&SQL(Update SQLUser.DHC_PE_OrderDetailRelate set ODR_ARCIM_DR=:ArcimID where ODR_ARCIM_DR=:OldArcimID)
	..w:SQLCODE'=0 STID_"更新大项和细项组合错误"_SQLCODE,!
	..q:SQLCODE'=0
	
	..&SQL(Delete from SQLUser.DHC_PE_StationOrder where STORD_ParRef=:STID and STORD_ChildSub <> :OSub)
	..s:SQLCODE=100 SQLCODE=0
	..w:(SQLCODE'=0) STID_"删除大项错误"_SQLCODE,!
	..q:SQLCODE'=0
	.e  d
	..&SQL(Delete from SQLUser.DHC_PE_StationOrder where STORD_ParRef=:STID)
	..s:SQLCODE=100 SQLCODE=0
	..w:(SQLCODE'=0) STID_"删除大项错误"_SQLCODE,!
	..q:SQLCODE'=0
	&SQL(Delete from SQLUser.DHC_PE_OrderDetailRelate where ODR_ARCIM_DR not in (select STORD_ARCIM_DR from SQLUser.DHC_PE_StationOrder))
	s:SQLCODE=100 SQLCODE=0
	w:SQLCODE'=0 "删除不存在的细项关联错误"_SQLCODE,!
	&SQL(Delete from SQLUser.DHC_PE_OrderDetail where OD_RowId not in (select ODR_OD_DR from SQLUser.DHC_PE_OrderDetailRelate))
	s:SQLCODE=100 SQLCODE=0
	w:SQLCODE'=0 "删除不存在的细项错误"_SQLCODE,!
	d ..DeleteOtherData()
	//设置站点Setting中的global
	d ##class(web.DHCPE.Station).SetSettingGlobal()
}

// d ##class(web.DHCPE.Init).SetImportArcCat()

/// 设置站点和医嘱子类的对照关系，导入检验检查项目
ClassMethod SetImportArcCat()
{
	;检验
	s ^renzwangImportStationOrder(7,"ArcCatDetail","LIS") = "34,RF_LIS^35,RF_LIS^36,RF_LIS^37,RF_LIS" 
	;放射科
	s ^renzwangImportStationOrder(8,"ArcCatDetail","RIS") = "19,RF_RIS" 
	;超声室
	s ^renzwangImportStationOrder(9,"ArcCatDetail","RIS") = "22,RF_RIS" 
	;心电图
	s ^renzwangImportStationOrder(10,"ArcCatDetail","RIS") = "29,RF_RIS" 
	;骨密度
	s ^renzwangImportStationOrder(11,"ArcCatDetail","RIS") = "" 
	;病理科
	s ^renzwangImportStationOrder(12,"ArcCatDetail","RIS") = "28,RF_RIS" 
	;CT室
	s ^renzwangImportStationOrder(13,"ArcCatDetail","RIS") = "18,RF_RIS" 
	;核磁共振
	s ^renzwangImportStationOrder(14,"ArcCatDetail","RIS") = "33,RF_RIS" 
	;内镜
	s ^renzwangImportStationOrder(15,"ArcCatDetail","RIS") = "25,RF_RIS^26,RF_RIS"
	;肺功能室
	s ^renzwangImportStationOrder(16,"ArcCatDetail","RIS") = "" 
	;经颅多普勒
	s ^renzwangImportStationOrder(17,"ArcCatDetail","RIS") = "" 
	;乳透室
	s ^renzwangImportStationOrder(19,"ArcCatDetail","RIS") = "" 
	;小器官超声
	s ^renzwangImportStationOrder(24,"ArcCatDetail","RIS") = "" 
	;心脏彩超
	s ^renzwangImportStationOrder(25,"ArcCatDetail","RIS") = "" 
	;动脉硬化检测
	s ^renzwangImportStationOrder(26,"ArcCatDetail","RIS") = "" 
	;乳腺检查
	s ^renzwangImportStationOrder(27,"ArcCatDetail","RIS") = "" 
	;呼吸睡眠监测
	s ^renzwangImportStationOrder(28,"ArcCatDetail","RIS") = "" 
	;24小时动态心电图
	s ^renzwangImportStationOrder(29,"ArcCatDetail","RIS") = "" 
	;24小时动态血压监测
	s ^renzwangImportStationOrder(30,"ArcCatDetail","RIS") = ""
}

// d ##class(web.DHCPE.Init).ImportStationOrder()

/// 导入站点包含项目，并设置对应的导检单类别
ClassMethod ImportStationOrder()
{
	d ##class(web.DHCPE.Init).SetImportArcCat()
	s STID=0
	f  s STID=$O(^DHCPEST(STID)) q:STID=""  d
	.d ##class(web.DHCPE.StationOrder).ImportStationArcItem(STID)
	d ..SetItemPatInfo()
}

// d ##class(web.DHCPE.Init).SetItemPatInfo()

/// 设置站点和导检单类别的对照关系
ClassMethod SetItemPatInfo()
{
	;一般检查
	d ##class(web.DHCPE.TempTools).StationRelateDJD(1,1,"")
	;内科
	d ##class(web.DHCPE.TempTools).StationRelateDJD(2,13,"")
	;外科
	d ##class(web.DHCPE.TempTools).StationRelateDJD(3,14,"")
	;妇科
	d ##class(web.DHCPE.TempTools).StationRelateDJD(4,20,"")
	;眼科
	d ##class(web.DHCPE.TempTools).StationRelateDJD(5,15,"")
	;耳鼻喉科
	d ##class(web.DHCPE.TempTools).StationRelateDJD(6,16,"")
	;化验
	d ##class(web.DHCPE.TempTools).StationRelateDJD(7,4,3)
	;放射科
	d ##class(web.DHCPE.TempTools).StationRelateDJD(8,5,"")
	;超声室
	d ##class(web.DHCPE.TempTools).StationRelateDJD(9,6,"")
	;心电
	d ##class(web.DHCPE.TempTools).StationRelateDJD(10,7,"")
	;骨密度
	d ##class(web.DHCPE.TempTools).StationRelateDJD(11,24,"")
	;病理科
	d ##class(web.DHCPE.TempTools).StationRelateDJD(12,30,"")
	;CT
	d ##class(web.DHCPE.TempTools).StationRelateDJD(13,8,"")
	;核磁
	d ##class(web.DHCPE.TempTools).StationRelateDJD(14,35,"")
	;内镜
	d ##class(web.DHCPE.TempTools).StationRelateDJD(15,31,"")
	;肺功能
	d ##class(web.DHCPE.TempTools).StationRelateDJD(16,26,"")
	;经颅多普勒
	d ##class(web.DHCPE.TempTools).StationRelateDJD(17,23,"")
	;乳透室
	d ##class(web.DHCPE.TempTools).StationRelateDJD(19,36,"")
	;口腔科
	d ##class(web.DHCPE.TempTools).StationRelateDJD(21,17,"")
	;营养科
	d ##class(web.DHCPE.TempTools).StationRelateDJD(22,21,"")
	;神经科
	d ##class(web.DHCPE.TempTools).StationRelateDJD(23,18,"")
	;小器官超声
	;d ##class(web.DHCPE.TempTools).StationRelateDJD(24,18,"")
	;心脏彩超
	d ##class(web.DHCPE.TempTools).StationRelateDJD(25,23,"")
	;动脉硬化检测
	d ##class(web.DHCPE.TempTools).StationRelateDJD(26,34,"")
	;乳腺检查
	d ##class(web.DHCPE.TempTools).StationRelateDJD(27,36,"")
	;呼吸睡眠监测
	d ##class(web.DHCPE.TempTools).StationRelateDJD(28,38,"")
	;24小时动态心电图
	d ##class(web.DHCPE.TempTools).StationRelateDJD(29,7,"")
	;24小时动态血压监测
	d ##class(web.DHCPE.TempTools).StationRelateDJD(30,39,"")
	;皮肤科
	d ##class(web.DHCPE.TempTools).StationRelateDJD(31,41,"")
}

/// 删除其它数据
ClassMethod DeleteOtherData()
{
	k ^DHCPEDataEX("DHCPEGTeamTemplate")
	k ^DHCPEDataEX("DHCPEGTeamTemplateRowId")
	k ^DHCPEDataEX("DHCPEInvice")
	k ^DHCPEDataEX("DHCPERigsterWinSet")
	k ^DHCPEDataEx("AsCharged")
	k ^DHCPEDataEx("AutoSummarizeRecomm")
	k ^DHCPECTDataEx("BaseData","ZhToEn")
	k ^DHCPECTDataEx("BaseData","IllnessStandard")
	k ^DHCPECFDataEx("ChartAssign")
	k ^DHCPEDataEx("ConfirmRecPaper")
	k ^DHCPEDataEx("YJJInvID")
	k ^DHCPEDataEx("YHKInvID")
	k ^DHCPECTDataEx("YGFlag")
	k ^DHCPEDataEx("SendRisRequest")
	k ^DHCPEDataEx("SSPInvID")
	k ^DHCPEDataEx("SDiaginosis")
	k ^DHCPEDataEx("RoomUserEx")
	k ^DHCPEDataEx("ReportUser")
	k ^DHCPECTDataEx("ReportItemSort")
	k ^DHCPEDataEx("ReportDateUser")
	k ^DHCPEDataEx("ReportDate")
	k ^DHCPEDataEx("Report")
	k ^DHCPECTDataEx("PatItemSort")
	k ^DHCPEDataEx("OrdSetsEx")
	k ^DHCPEDataEx("OEOrderItem")
	k ^DHCPEDataEx("OEOrder")
	k ^DHCPEDataEx("InvName")
	k ^DHCPEDataEx("InsertRoundFee")
	k ^DHCPEDataEx("GDiaginosis")
	k ^DHCPEDataEx("DeleteNoUserRoomInfo")
	k ^DHCPEDataEx("DJKInvID")
	k ^DHCPEDataEx("DHC_PE_PreIOrdItemFee")
	k ^DHCPEDataEx("DHC_PE_PreIOrdItem")
	k ^DHCPEDataEx("DHCPEStationChart")
	k ^DHCPEDataEx("DHCPESSDocName")
	k ^DHCPEDataEx("DHCPESSDiagnosis")
	k ^DHCPEDataEx("DHCPEResult")
	k ^DHCPEDataEx("DHCPERefundApply")
	k ^DHCPEDataEx("DHCPEPreTEAM")
	k ^DHCPEDataEx("DHCPEPreIOrdItem")
	k ^DHCPEDataEx("DHCPEPreIOrdEnt")
	k ^DHCPEDataEx("DHCPEPreIADM")
	k ^DHCPEDataEx("DHCPEPreGTeam")
	k ^DHCPEDataEx("DHCPEPreGTOrdItem")
	k ^DHCPEDataEx("DHCPEPreGTOrdEnt")
	k ^DHCPEDataEx("DHCPEPreGADM")
	k ^DHCPEDataEx("DHCPEOtherStation")
	k ^DHCPEDataEx("DHCPEOrderDetailRelate")
	k ^DHCPECTDataEx("DHCPEOrderDetail")
	k ^DHCPEDataEx("DHCPEInvice")
	k ^DHCPEDataEx("DHCPEInvPrt")
	k ^DHCPEDataEx("DHCPEHighRiskRemind")
	k ^DHCPEDataEx("DHCPEHighRiskFlag")
	k ^DHCPEDataEx("DHCPEHighRiskCondition")
	k ^DHCPEDataEx("DHCPEHighRisk")
	k ^DHCPEDataEx("DHCPEGeneralSummarize")
	k ^DHCPEDataEx("DHCPEGSDiagnosis")
	k ^DHCPEDataEx("DHCPEExpertDiagnosis")
	k ^DHCPEDataEx("DHCPEDiagnosisLevel")
	k ^DHCPEDataEx("DHCPECharge")
	k ^DHCPEDataEx("DHCPEBaseData")
	k ^DHCPEDataEx("DHCPEAD")
	k ^DHCPEDataEx("Content")
	k ^DHCPEDataEx("ConfirmRecPaper")
	k ^DHCPECTDataEx("DHCPEStationOrder")
	k ^DHCPEDataEx("DHCPEODStandard","HighRiskFlag")
	k ^DHCPEDataEx("DHCPEODStandard","NoPrint")
	k ^DHCPEDataEx("AutoSaveResult")
	s ODSID=""
	f  s ODSID=$O(^DHCPEDataEx("DHCPEODStandard","DHCPEODSTemplate",ODSID)) q:ODSID=""  d
	.q:$D(^DHCPEST(+ODSID,"OD",$P(ODSID,"||",2),"ODS",$P(ODSID,"||",3)))
	.k ^DHCPEDataEx("DHCPEODStandard","DHCPEODSTemplate",ODSID)
	k ^DHCPECTDataEx("DHCPEStation")
	k ^DHCPEItemSort
	s STID=""
	f  s STID=$O(^DHCPECTDataEx("DHCPEStation",STID)) q:STID=""  d
	.s CurLocID=""
	.s Notice=""
	.f  s CurLocID=$O(^DHCPECTDataEx("DHCPEStation",STID,"Place",CurLocID)) q:CurLocID=""  d
	..s Notice=$G(^DHCPECTDataEx("DHCPEStation",STID,"Place",CurLocID))
	..k ^DHCPECTDataEx("DHCPEStation",STID,"Place",CurLocID)
	.s ^DHCPECTDataEx("DHCPEStation",STID,"Place",..#LocID)=Notice
	
	s PatItemID=""
	f  s PatItemID=$O(^DHCPECTDataEx("PatItem",PatItemID)) q:PatItemID=""  d
	.s CurLocID=""
	.s Notice=""
	.f  s CurLocID=$O(^DHCPECTDataEx("PatItem",PatItemID,"Place",CurLocID)) q:CurLocID=""  d
	..s Notice=$G(^DHCPECTDataEx("PatItem",PatItemID,"Place",CurLocID))
	..k ^DHCPECTDataEx("PatItem",PatItemID,"Place",CurLocID)
	.s ^DHCPEDataEx("PatItem",PatItemID,"Place",..#LocID)=Notice
	
	s PatItemID=""
	f  s PatItemID=$O(^DHCPECTDataEx("ReportItem",PatItemID)) q:PatItemID=""  d
	.s CurLocID=""
	.f  s CurLocID=$O(^DHCPECTDataEx("ReportItem",PatItemID,"Place",CurLocID)) q:CurLocID=""  d
	..k ^DHCPECTDataEx("ReportItem",PatItemID,"Place",CurLocID)
	
	k ^DHCPECBVIPLevel("PGT")
	k ^DHCPECBVIPLevel("PIBI")
	
	k ^User.DHCPEExpressD
	k ^User.DHCPEExpressI
}

/// 设置体检配置的一些Global
ClassMethod SetSetting()
{
	s LocID=..#LocID
	s ^DHCPESetting("DHCPE","AutoArrived",LocID)=..#AutoArrived
	s ^DHCPESetting("DHCPE","AutoAuditUser",LocID)=..#AutoAuditUser
	s ^DHCPESetting("DHCPE","PreOrder",LocID)=..#PreOrder
	s ^DHCPESetting("DHCPE","AutoNormalResult",LocID)=..#AutoNormalResult
	s ^DHCPESetting("DHCPE","BilledMode")="New"
	s ^DHCPESetting("DHCPE","BookDateLimit")="No"
	s ^DHCPESetting("DHCPE","CallVoice",LocID)=..#CallVoice
	s ^DHCPESetting("DHCPE","CanChangePayModes")=..#CanChangePayModes
	s ^DHCPESetting("DHCPE","CancelPEType",LocID)=..#CancelPEType
	s ^DHCPESetting("DHCPE","CardRelate")=..#CardRelate
	s ^DHCPESetting("DHCPE","CardType")=..#CardType
	s ^DHCPESetting("DHCPE","CashierSystem",LocID)=..#CashierSystem
	s ^DHCPESetting("DHCPE","AllowCharge",LocID)=..#AllowCharge
	s ^DHCPESetting("DHCPE","CashierMin")=100
	s ^DHCPESetting("DHCPE","ClassName of CRMGateWay")="web.DHCPE.CRM.GatewayDHC"
	s ^DHCPESetting("DHCPE","DefADMFeeType",LocID)=""
	s ^DHCPESetting("DHCPE","DefPatientType")=..#DefPatientType
	s ^DHCPESetting("DHCPE","DefaultPAADM",LocID)=""
	s ^DHCPESetting("DHCPE","GRDiagnosisType")=..#GRDiagnosisType
	s ^DHCPESetting("DHCPE","GetHWOrder")=""
	s ArcCode="PE012"
	s ArcimID=$O(^ARCIM(0,"Code",ArcCode,0))
	w:ArcimID="" "没有设置收费使用的医嘱代码",!
	s ^DHCPESetting("DHCPE","Group'sOEArcItemId")=ArcimID_"||1"
	s ^DHCPESetting("DHCPE","GroupPatNO_Begin")="00000000"
	s ^DHCPESetting("DHCPE","GroupPatNO_CurNo")=""
	s ^DHCPESetting("DHCPE","HospYBCode")=""
	s ^DHCPESetting("DHCPE","HospitalCode")=..#HospitalCode
	s ^DHCPESetting("DHCPE","HospitalName")=""
	s ^DHCPESetting("DHCPE","IAdmStatuses_Resultable")="^ARRIVED^CHARGED^COMPLETED^"
	s ^DHCPESetting("DHCPE","InvCol")=..#InvCol
	s ^DHCPESetting("DHCPE","InvColSortType")=..#InvColSortType
	s ^DHCPESetting("DHCPE","InvDefaulltFee")=ArcimID_"||1"
	s ^DHCPESetting("DHCPE","InvDefaultPayMode")=..#DefaultPayMode
	s ^DHCPESetting("DHCPE","InvFlag")=..#InvFlag
	s ^DHCPESetting("DHCPE","InvListFlag")=..#InvListFlag
	s ^DHCPESetting("DHCPE","InvMaxListCount")=..#InvMaxListCount
	s ^DHCPESetting("DHCPE","InvPrintCatInfo")=..#InvPrintCatInfo
	s ^DHCPESetting("DHCPE","LisInterface")=..#LisInterface
	s ^DHCPESetting("DHCPE","LisNewVersion")=..#LisNewVersion
	s ^DHCPESetting("DHCPE","MainDoctorGroup",LocID)=..#MainDoctorGroup
	s ^DHCPESetting("DHCPE","NetReport",LocID)=..#NetReport
	s ^DHCPESetting("DHCPE","NoCodeLabItem")=""
	s ^DHCPESetting("DHCPE","NoReportStation")=""
	s ^DHCPESetting("DHCPE","ODStr")=""
	s ^DHCPESetting("DHCPE","OEItemPrint",LocID)="OEItemPrintA4"
	s ^DHCPESetting("DHCPE","PAPMINo_GenModel")="NoGen"
	s ^DHCPESetting("DHCPE","PEItemCodePrefix")="PE"
	s ^DHCPESetting("DHCPE","PEPatType")="公费"
	s ^DHCPESetting("DHCPE","PESystemStartDate")=60823
	s ^DHCPESetting("DHCPE","PageModel",LocID)="A4"
	s ^DHCPESetting("DHCPE","PatItemSort")=""
	s ^DHCPESetting("DHCPE","PatItemSortTemp")=""
	s ^DHCPESetting("DHCPE","PatNO_Begin")=""
	s ^DHCPESetting("DHCPE","PatOrdFlag")="0^0"
	s ^DHCPESetting("DHCPE","PhyExamDrId",LocID)=..#PhyExamDrId
	s ^DHCPESetting("DHCPE","RegNoLength")=..#RegNoLength
	s:..#ReportCode'="" ^DHCPESetting("DHCPE","ReportCode",LocID)=..#ReportCode
	s ^DHCPESetting("DHCPE","LisReportMerge")=..#LisReportMerge
	s ^DHCPESetting("DHCPE","ReportTitle")="北京协和医院"
	s ArcCode="PE011"
	s ArcimID=$O(^ARCIM(0,"Code",ArcCode,0))
	w:ArcimID="" "没有设置收费凑整费使用的医嘱代码",!
	s ^DHCPESetting("DHCPE","RoundingFee")=ArcimID_"||1"
	s ^DHCPESetting("DHCPE","RoundingFeeLimitMin")=50
	s ^DHCPESetting("DHCPE","SSGroup_SummarizeAudit")=..#SummarizeAudit
	s ^DHCPESetting("DHCPE","SalesDefaultDept")=""
	s ^DHCPESetting("DHCPE","SendOrder",LocID)=..#SendOrder
	s ^DHCPESetting("DHCPE","SetsDefaultTar",LocID)=..#SetsDefaultTar
	s ^DHCPESetting("DHCPE","SpecialPayModes")=..#SpecialPayModes
	s ^DHCPESetting("DHCPE","RoundManager")=..#RoundManager
	s ^DHCPESetting("DHCPE","TarOCIsNew")=..#TarOCIsNew
	s ^DHCPESetting("DHCPE","StationId_NoAdvice")=""
	s ^DHCPESetting("DHCPE","StationId_NoSubmit")=""
	s ^DHCPESetting("DHCPE","SuperGroup")=..#SuperGroup
	s ^DHCPESetting("DHCPE","TrakVerison")=..#TrakVerison
	s ^DHCPESetting("DHCPE","ItemAbridgeFlag")=..#ItemAbridgeFlag
	s ^DHCPESetting("DHCPE","PhotoFTP")=..#PhotoFTP
	s ^DHCPESetting("DHCPE","HPNo",LocID)=..#HPNo
	s ^DHCPESetting("DHCPE","AllowPrint",LocID)=..#AllowPrint
	s ^DHCPESetting("DHCPEBaseData","PEARCOS")=""
	s ^DHCPESetting("NAMESPACE","LABDATA")=..#LABDATA
	s ^DHCPESetting("NAMESPACE","MEDDATA")=..#MEDDATA
	s ^DHCPESetting("DHCPE","InsertOPInv")=..#InsertOPInv
	s ^DHCPESetting("DHCPE","ReportFTP")=..#ReportFTP
	s ^DHCPESetting("DHCPE","StationId_Ris","SendRisApplication")=..#SendRisApplication
	s ^DHCPESetting("DHCPE","AllowAddItem")=..#AllowAddItem
	s ^DHCPESetting("DHCPE","FeeTypeSuperGroup")=..#FeeTypeSuperGroup
	s ^DHCPESetting("DHCPE","OrderInterface",LocID)=..#OrderInterface
	S ^DHCPESetting("DHCPE","OrderInterfaceType",LocID)=..#OrderInterfaceType
	S ^DHCPESetting("DHCPE","StationId_Lab")=..#LabStation
	S ^DHCPESetting("DHCPE","StationId_Ris")=..#RisStation
	s ^DHCPESetting("DHCPE","StationId_Medical")=..#MedicalStation
    S ^DHCPESetting("DHCPE","StationId_Other")=..#OtherStation
    S ^DHCPESetting("DHCPE","IsPrintBarNurseXML")=..#PrintBarNurseXML
    S ^DHCPESetting("DHCPE","MainReportPrint")=..#MainReportPrint
    S ^DHCPESetting("DHCPE","ShowEDDiagnosisSign")=..#ShowEDDiagnosisSign
    S ^DHCPESetting("DHCPE","SendPisApplication")=..#SendPisApplication
    S ^DHCPESetting("DHCPE","SendPisInterface")=..#SendPisInterface
 	S ^DHCPESetting("DHCPE","SendPisFBWay")=..#SendPisFBWay
    S ^DHCPESetting("DHCPE","PrintPISTiaomaNew")=..#PrintPISTiaomaNew
}

/// 体检基础数据维护-体检设置无法设置的一些Global
ClassMethod SetSettingNew()
{
	s LocID=..#LocID
	s ^DHCPESetting("DHCPE","BilledMode")="New"
	s ^DHCPESetting("DHCPE","BookDateLimit")="No"
	s ^DHCPESetting("DHCPE","CashierMin")=100
	s ^DHCPESetting("DHCPE","ClassName of CRMGateWay")="web.DHCPE.CRM.GatewayDHC"
	s ^DHCPESetting("DHCPE","DefADMFeeType",LocID)=""
	s ^DHCPESetting("DHCPE","DefPatientType")=..#DefPatientType
	s ^DHCPESetting("DHCPE","DefaultPAADM",LocID)=""
	s ^DHCPESetting("DHCPE","GRDiagnosisType")=..#GRDiagnosisType
	s ^DHCPESetting("DHCPE","GetHWOrder")=""
	s ^DHCPESetting("DHCPE","GroupPatNO_Begin")="00000000"
	s ^DHCPESetting("DHCPE","GroupPatNO_CurNo")=""
	s ^DHCPESetting("DHCPE","HospYBCode")=""
	s ^DHCPESetting("DHCPE","HospitalCode")=..#HospitalCode
	s ^DHCPESetting("DHCPE","HospitalName")=""
	s ^DHCPESetting("DHCPE","IAdmStatuses_Resultable")="^ARRIVED^CHARGED^COMPLETED^"
	s ^DHCPESetting("DHCPE","NoCodeLabItem")=""
	s ^DHCPESetting("DHCPE","NoReportStation")=""
	s ^DHCPESetting("DHCPE","ODStr")=""
	s ^DHCPESetting("DHCPE","InvFlag")=..#InvFlag
	s ^DHCPESetting("DHCPE","OEItemPrint",LocID)="OEItemPrintA4"
	s ^DHCPESetting("DHCPE","PAPMINo_GenModel")="NoGen"
	s ^DHCPESetting("DHCPE","PEItemCodePrefix")="PE"
	s ^DHCPESetting("DHCPE","PEPatType")="公费"
	s ^DHCPESetting("DHCPE","PESystemStartDate")=60823
	s ^DHCPESetting("DHCPE","PageModel",LocID)="A4"
	s ^DHCPESetting("DHCPE","PatItemSort")=""
	s ^DHCPESetting("DHCPE","PatItemSortTemp")=""
	s ^DHCPESetting("DHCPE","PatNO_Begin")=""
	s ^DHCPESetting("DHCPE","PatOrdFlag")="0^0"
	s ^DHCPESetting("DHCPE","RegNoLength")=..#RegNoLength
	s ^DHCPESetting("DHCPE","LisReportMerge")=..#LisReportMerge
	s ^DHCPESetting("DHCPE","ReportTitle")="北京协和医院"
	s ^DHCPESetting("DHCPE","RoundingFeeLimitMin")=50
	s ^DHCPESetting("DHCPE","SalesDefaultDept")=""
	s ^DHCPESetting("DHCPE","SetsDefaultTar",LocID)=..#SetsDefaultTar
	s ^DHCPESetting("DHCPE","SpecialPayModes")=..#SpecialPayModes
	s ^DHCPESetting("DHCPE","TarOCIsNew")=..#TarOCIsNew
	s ^DHCPESetting("DHCPE","StationId_NoAdvice")=""
	s ^DHCPESetting("DHCPE","StationId_NoSubmit")=""
	s ^DHCPESetting("DHCPE","SuperGroup")=..#SuperGroup
	s ^DHCPESetting("DHCPE","TrakVerison")=..#TrakVerison
	s ^DHCPESetting("DHCPEBaseData","PEARCOS")=""
}

/// 设置发票上分类的xml标签名字
ClassMethod SetInvCat()
{
	;d ##class(web.DHCPE.Init).SetInvCat()
	k ^DHCPESetting("DHCPE","InvFeeCat")
	//设置发票分类，在发票xml上的对应的标签名字
	s ^DHCPESetting("DHCPE","InvFeeCat","DHC_TarOC发票分类ID")="ElementName"
}

/// 设置凑整费的权限
ClassMethod SetRoundingFee(UserID, QXType)
{
	;d ##class(web.DHCPE.Init).SetRoundingFee("1","2")
	//凑整费的权限  0：不允许   1：个人收费允许  2：团体收费允许  3：个人和团体收费均允许。
	s ^DHCPESetting("DHCPE","RoundingFeeMode",UserID)=QXType
}

/// 删除所有的体检数据
ClassMethod KillAllPEGlobal()
{
	;d ##class(web.DHCPE.Init).KillAllPEGlobal()
	k ^DHCPEComponent
	k ^DHCPEMenu
	k ^BAKDHCPEODR 
	k ^BAKDHCPEST 
	k ^DHCPE 
	k ^DHCPEAP 
	k ^DHCPEARCIMCon 
	k ^DHCPECRMO 
	k ^DHCPECashierTemp 
	k ^DHCPEComponent 
	k ^DHCPECreateSMSID 
	k ^DHCPEData 
	k ^DHCPEDataEX 
	k ^DHCPEDataEx 
	k ^DHCPEDataExBak 
	k ^DHCPEDataExWrz 
	k ^DHCPEDataExi 
	k ^DHCPEDateEx 
	k ^DHCPEED 
	k ^DHCPEEDA 
	k ^DHCPEEDC 
	k ^DHCPEEDCR 
	k ^DHCPEGADM 
	k ^DHCPEGBI 
	k ^DHCPEGC 
	k ^DHCPEGGS 
	k ^DHCPEGS 
	k ^DHCPEGSDM 
	k ^DHCPEGenED 
	k ^DHCPEHCRelate 
	k ^DHCPEHPNoRecord 
	k ^DHCPEHighRiskOrder 
	k ^DHCPEIADM 
	k ^DHCPEIDR 
	k ^DHCPEIE 
	k ^DHCPEILLS 
	k ^DHCPEILLSA 
	k ^DHCPEINVPRT 
	k ^DHCPEImportGInfo 
	k ^DHCPEItemSort 
	k ^DHCPELabPatNo 
	k ^DHCPEMenu 
	k ^DHCPENetReport 
	k ^DHCPENetReportPage 
	k ^DHCPENoPayCashier 
	k ^DHCPENoRelateDetailResult 
	k ^DHCPEODR 
	k ^DHCPEOEITEM 
	k ^DHCPEOEITEMAccAcc 
	k ^DHCPEOEITEMAccAccSource 
	k ^DHCPEOEITEMAccAccTemp 
	k ^DHCPEOEITEMAccAccTempSource 
	k ^DHCPEOEITEMBAK 
	k ^DHCPEOEITEMSource 
	k ^DHCPEOEITEMTemp 
	k ^DHCPEOEITEMTempSource 
	k ^DHCPEOSE 
	k ^DHCPEOldXHData 
	k ^DHCPEOutResultDetailTemp 
	k ^DHCPEPAPBR 
	k ^DHCPEPRT 
	k ^DHCPEPatItemPrintFlag 
	k ^DHCPEPatSortForNorCus 
	k ^DHCPEPayedCashier 
	k ^DHCPEPreA 
	k ^DHCPEPreAI 
	k ^DHCPEPreGADM 
	k ^DHCPEPreGBI 
	k ^DHCPEPreIADM 
	k ^DHCPEPreIBI 
	k ^DHCPEQueryResultTemp 
	k ^DHCPERLT 
	k ^DHCPERPT 
	k ^DHCPERegisterTempData 
	k ^DHCPERoom 
	k ^DHCPESS 
	k ^DHCPEST 
	k ^DHCPESWATMP 
	k ^DHCPESetting 
	k ^DHCPEShowEDInfo 
	k ^DHCPESort 
	k ^DHCPESortTemp 
	k ^DHCPESpecial 
	k ^DHCPESpecialBak 
	k ^DHCPESpecialContral 
	k ^DHCPESpecialReportInfo 
	k ^DHCPESpecialReportInfoBase 
	k ^DHCPESpecialReportPrintRecord 
	k ^DHCPEStationOrder 
	k ^DHCPETEMPArcCosStatic 
	k ^DHCPETMIC 
	k ^DHCPETMP 
	k ^DHCPETMPChargeStr 
	k ^DHCPETMPContrast 
	k ^DHCPETMPDWA 
	k ^DHCPETMPFTZYYExport 
	k ^DHCPETMPICExport 
	k ^DHCPETMPIS 
	k ^DHCPETMPLWA 
	k ^DHCPETMPNRData 
	k ^DHCPETMPNormalFlag 
	k ^DHCPETMPOSQ 
	k ^DHCPETMPOrdSets 
	k ^DHCPETMPPA 
	k ^DHCPETMPPC 
	k ^DHCPETMPPQ 
	k ^DHCPETMPPRS 
	k ^DHCPETMPPRSExport 
	k ^DHCPETMPRECPAPERData 
	k ^DHCPETMPSAQ 
	k ^DHCPETMPSWA 
	k ^DHCPETMPSWAExport 
	k ^DHCPETemp 
	k ^DHCPETempHPNo 
	k ^DHCPETempLabEpisodeNo 
	k ^DHCPETempLabEpisodeScan 
	k ^DHCPETempQuery 
	k ^DHCPETempResult 
	k ^DHCPETmpHadCheck 
	k ^DHCPEUSERREPORT 
	k ^DHCPEUpdateAuditRecord 
	k ^DHCPEUpdateLabNo 
	k ^DHCPEUserReportEx 
	k ^DHCPEVIPLevel 
	k ^DHCPEVIPLevelI 
	k ^DHCPEXWMTMP 
	k ^TEMPDHCPEInv 
	k ^TEMPDHCPELocWork 
	k ^TempDHCPE 
	k ^TempDHCPEAdviceSort 
	k ^TempDHCPEArcDesc 
	k ^TempDHCPEBarCodeSort 
	k ^TempDHCPEBarPrint 
	k ^TempDHCPEBarPrintFind 
	k ^TempDHCPECatInfo 
	k ^TempDHCPEChangeReult 
	k ^TempDHCPECheckInfo 
	k ^TempDHCPECheckInfoSex 
	k ^TempDHCPECheckProgress 
	k ^TempDHCPEDesc 
	k ^TempDHCPEDoc 
	k ^TempDHCPEEDDesc 
	k ^TempDHCPEEDInfo 
	k ^TempDHCPEEX 
	k ^TempDHCPEExportCommon 
	k ^TempDHCPEExportRecord 
	k ^TempDHCPEGADMList 
	k ^TempDHCPEGSS 
	k ^TempDHCPEGetInfor 
	k ^TempDHCPEGroupReport 
	k ^TempDHCPEInsertOtherItem 
	k ^TempDHCPEItemInfo 
	k ^TempDHCPELabRelate 
	k ^TempDHCPEListInfo 
	k ^TempDHCPEPerIADM 
	k ^TempDHCPEPreInfoFind 
	k ^TempDHCPEPreItemListEx 
	k ^TempDHCPEPrintDirect 
	k ^TempDHCPEPrintDirectSpecNum 
	k ^TempDHCPEPrintIAdmInfoSort 
	k ^TempDHCPERecPaper 
	k ^TempDHCPERecomm 
	k ^TempDHCPEResultDiagnosis 
	k ^TempDHCPEResultDiagnosisNew 
	k ^TempDHCPEResultDiagnosisNewAdvi 
	k ^TempDHCPEResultDiagnosisNewOrde 
	k ^TempDHCPEResultDiagnosisNewSpec 
	k ^TempDHCPEResultNew 
	k ^TempDHCPEResultNewLabSpecNo 
	k ^TempDHCPERoomInsert 
	k ^TempDHCPERoomManager 
	k ^TempDHCPERoomPerson 
	k ^TempDHCPESendAudit 
	k ^TempDHCPESetPatItem 
	k ^TempDHCPESetPatItemList 
	k ^TempDHCPESort 
	k ^TempDHCPESpec 
	k ^TempDHCPESpecialItem 
	k ^TempDHCPEStationOrder 
	k ^TempDHCPETransResult 
	k ^TempDHCPEUpdTar 
	k ^TempDHCPEUserReport 
	k ^User.DHCPEAdmRecordManagerD 
	k ^User.DHCPEAdmRecordManagerI 
	k ^User.DHCPEAdmRefuseRoomD 
	k ^User.DHCPEAdmRefuseRoomI 
	k ^User.DHCPEAdmRoomRecordD 
	k ^User.DHCPEAdmRoomRecordI 
	k ^User.DHCPEAreaC 
	k ^User.DHCPEAreaD 
	k ^User.DHCPEAreaI 
	k ^User.DHCPECardMonthReportC 
	k ^User.DHCPECardMonthReportD 
	k ^User.DHCPECardMonthReportI 
	k ^User.DHCPEContractD 
	k ^User.DHCPEContractI 
	k ^User.DHCPECurDateAdmInfoD 
	k ^User.DHCPECurDateAdmInfoI 
	k ^User.DHCPEEDKeyD 
	k ^User.DHCPEEDKeyI
	k ^User.DHCPEExpressD
	k ^User.DHCPEExpressI 
	k ^User.DHCPEGSDUnitRecordD 
	k ^User.DHCPEGSDUnitRecordI 
	k ^User.DHCPEGSSumD 
	k ^User.DHCPEGSSumI 
	k ^User.DHCPEGSSumS 
	k ^User.DHCPEGSSumSBak 
	k ^User.DHCPEHighRiskResultD 
	k ^User.DHCPEHighRiskResultI 
	k ^User.DHCPEHighRiskResultS 
	k ^User.DHCPEModifyDateRecordD 
	k ^User.DHCPEModifyDateRecordI 
	k ^User.DHCPENetItemTypeD 
	k ^User.DHCPENetItemTypeI 
	k ^User.DHCPENetOrdSetsC 
	k ^User.DHCPENetOrdSetsD 
	k ^User.DHCPENetOrdSetsI 
	k ^User.DHCPENetPreRecordD 
	k ^User.DHCPENetPreRecordI 
	k ^User.DHCPENetSetsItemC 
	k ^User.DHCPENetSetsItemDetailI 
	k ^User.DHCPENetSetsItemI 
	k ^User.DHCPENetSetsItemTypeC 
	k ^User.DHCPENetSetsItemTypeI 
	k ^User.DHCPENewMessageTempletD 
	k ^User.DHCPENewMessageTempletI 
	k ^User.DHCPENewSendMessageD 
	k ^User.DHCPENewSendMessageI 
	k ^User.DHCPEPositiveRecordD 
	k ^User.DHCPEPositiveRecordI 
	k ^User.DHCPEPreManagerC 
	k ^User.DHCPEPreManagerD 
	k ^User.DHCPEPreManagerI 
	k ^User.DHCPEPreTemplateC 
	k ^User.DHCPEPreTemplateD 
	k ^User.DHCPEPreTemplateI 
	k ^User.DHCPERoomC 
	k ^User.DHCPERoomI 
	k ^User.DHCPERoomIPI 
	k ^User.DHCPERoomSpecialRoomI 
	k ^User.DHCPERoomSpecimenI 
	k ^User.DHCPESendAuditD 
	k ^User.DHCPESendAuditI 
	k ^User.DHCPETempExpertDiagnosisD 
	k ^User.DHCPETempExpertDiagnosisI 
	k ^wrzDHCPEAP 
	k ^zlTempDHCPE 
	k ^DHCPEFTPhysical 
	k ^DHCPEFTPhysicalFlag 
	k ^DHCPEHMInterfaceErrRecord 
	k ^DHCPESM 
	k ^DHCPESettingBak 
	k ^DHCPESettingHYD 
	k ^DHCPETMPLabData 
	k ^DHCPETmp 
	k ^TMPDHCPE
	k ^TempDHCPEDBResult
	k ^TempDHCPEDocPatientChecking
	k ^TempDHCPEEDSort
	k ^TempDHCPEReport
	k ^TempLXLDHCPEPersonStatistic
	k ^User.DHCPEBasePicInfoD 
	k ^User.DHCPEBasePicInfoI
	k ^User.DHCPEEndangerC
	k ^User.DHCPEEndangerD
	k ^User.DHCPEEndangerS
}

/// d ##class(web.DHCPE.Init).LoadProgressByDir("D:\DHCPE\")
ClassMethod LoadProgressByDir(dir)
{
	s OneDir=dir_"Progress\cls\"
	s (qspec, Errorlog, loadedlist) =""
	s recurse=1
	Do $system.OBJ.LoadDir(OneDir, .qspec, .Errorlog, recurse,.loadedlist)
	Do $system.OBJ.CompileList(loadedlist, .qspec,.Errorlog)
	d ##class(web.DHCPE.Init).CompileByDir(dir,1)
}

// d ##class(web.DHCPE.Init).CompileByDir("D:\DHCPE\")

ClassMethod CompileByDir(dir, DeleteOldData As %String = "1")
{
	s qspec=""
	s Errorlog=""
	s loadedlist=""
	s OneDir=dir_"Progress\GBL\"
	s recurse=1
	;删除以往数据
	i DeleteOldData="1" d
	.d ##class(web.DHCPE.Init).KillAllPEGlobal()
	.s recurse=1
	.Do $system.OBJ.LoadDir(OneDir, .qspec, .Errorlog, recurse,.loadedlist)
	.Do $system.OBJ.CompileList(loadedlist, .qspec,.Errorlog)
	d ##class(web.DHCPE.IMPMenuAndCompont).UpdateComponents(dir)
	d ##class(web.DHCPE.IMPMenuAndCompont).UpdateMenus("")
	d ##class(web.DHCPE.IMPMenuAndCompont).UpdateBDPMenus("dhc.bdp.ProductConfig")
}

// d ##class(web.DHCPE.Init).ExportClassByPackage("DHCPE","D:/wrz/")

ClassMethod ExportClassByPackage(Package, DirName)
{
	s ItemList=""
	s Errorlog=""
	s qspec=""
	s DirName=##class(web.DHCPE.IMPMenuAndCompont).Replace(DirName,"\","/")
	s DirName=DirName_"Progress/cls/"
	s flag=##class(web.DHCPE.IMPMenuAndCompont).CreateDirectory(DirName)
	Do $system.OBJ.GetPackageList(.ItemList,Package,.Errorlog)
	s OneName="" 
	f  s OneName=$o(ItemList(OneName)) q:OneName=""  d
	.s filename=DirName_OneName_".xml"
	.s ClassName=OneName_".cls"
	.d $system.OBJ.Export(ClassName,filename,.qspec,.Errorlog,"")
}

// d ##class(web.DHCPE.Init).Export("D:/DHCPE/")

ClassMethod Export(DirName)
{
	;导包DHCPE中的所有文件
	d ##class(web.DHCPE.IMPMenuAndCompont).ExportProgressByProject("DHCPE","XML",DirName)
	;导出组件
	d ##class(web.DHCPE.IMPMenuAndCompont).BakComponent("DHCPE",DirName)
	;导出菜单
	d ##class(web.DHCPE.IMPMenuAndCompont).BackPEMenu(DirName)
	;导出基础数据菜单
	d ##class(web.DHCPE.IMPMenuAndCompont).ExportPEBDPMenu("dhc.bdp.ProductConfig","dhc.bdp.DHCPE.BaseManager")
	;导出数据global
	d ##class(web.DHCPE.Init).ExportPEGBL(DirName)
}

// d ##class(web.DHCPE.Init).ExportGBL("DHCPEST.GBL","D:/wrz/")

ClassMethod ExportGBL(GBLName, DirName)
{
	s Errorlog=""
	s qspec=""
	;s GBLName="DHCPEST"
	s DirName=##class(web.DHCPE.IMPMenuAndCompont).Replace(DirName,"\","/")
	s DirName=DirName_"Progress/GBL/"
	s flag=##class(web.DHCPE.IMPMenuAndCompont).CreateDirectory(DirName)
	s filename=DirName_GBLName_".xml"
	d $system.OBJ.Export(GBLName,filename,.qspec,.Errorlog,"")
}

// d ##class(web.DHCPE.Init).ExportPEGBL("D:/wrz/")

ClassMethod ExportPEGBL(DirName)
{
	s GBLName="^DHCPEBDPMenu.gbl"
	d ..ExportGBL(GBLName,DirName)
	s GBLName="^DHCPEMenu.gbl"
	d ..ExportGBL(GBLName,DirName)
	s GBLName="^DHCPEComponent.gbl"
	d ..ExportGBL(GBLName,DirName)
	s GBLName="^DHCPEDataEx.gbl"
	d ..ExportGBL(GBLName,DirName)
	
	s GBLName="^DHCPECTDataEx.gbl"
	d ..ExportGBL(GBLName,DirName)
	s GBLName="^DHCPECFDataEx.gbl"
	d ..ExportGBL(GBLName,DirName)
	
	;s GBLName="^DHCPEDataEX.gbl"
	;d ..ExportGBL(GBLName,DirName)
	s GBLName="^DHCPEED.gbl"
	d ..ExportGBL(GBLName,DirName)
	s GBLName="^DHCPEEDA.gbl"
	d ..ExportGBL(GBLName,DirName)
	s GBLName="^DHCPEEDC.gbl"
	d ..ExportGBL(GBLName,DirName)
	s GBLName="^DHCPEEDCR.gbl"
	d ..ExportGBL(GBLName,DirName)
	s GBLName="^DHCPEIDR.gbl"
	d ..ExportGBL(GBLName,DirName)
	s GBLName="^DHCPEILLS.gbl"
	d ..ExportGBL(GBLName,DirName)
	s GBLName="^DHCPEILLSA.gbl"
	d ..ExportGBL(GBLName,DirName)
	s GBLName="^DHCPEODR.gbl"
	d ..ExportGBL(GBLName,DirName)
	//s GBLName="^DHCPERoom.gbl"
	//d ..ExportGBL(GBLName,DirName)
	s GBLName="^DHCPEST.gbl"
	d ..ExportGBL(GBLName,DirName)
	s GBLName="^DHCPESetting.gbl"
	d ..ExportGBL(GBLName,DirName)
	s GBLName="^DHCPEVIPLevel.gbl"
	d ..ExportGBL(GBLName,DirName)
	s GBLName="^DHCPEVIPLevelI.gbl"
	d ..ExportGBL(GBLName,DirName)
	s GBLName="^User.DHCPEAreaC.gbl"
	d ..ExportGBL(GBLName,DirName)
	s GBLName="^User.DHCPEAreaD.gbl"
	d ..ExportGBL(GBLName,DirName)
	s GBLName="^User.DHCPEAreaI.gbl"
	d ..ExportGBL(GBLName,DirName)
	s GBLName="^User.DHCPEEDKeyD.gbl"
	d ..ExportGBL(GBLName,DirName)
	s GBLName="^User.DHCPEEDKeyI.gbl"
	d ..ExportGBL(GBLName,DirName)
	s GBLName="^User.DHCPERoomC.gbl"
	d ..ExportGBL(GBLName,DirName)
	s GBLName="^User.DHCPERoomI.gbl"
	d ..ExportGBL(GBLName,DirName)
	s GBLName="^User.DHCPERoomIPI.gbl"
	d ..ExportGBL(GBLName,DirName)
	s GBLName="^User.DHCPERoomSpecialRoomI.gbl"
	d ..ExportGBL(GBLName,DirName)
	s GBLName="^User.DHCPERoomSpecimenI.gbl"
	d ..ExportGBL(GBLName,DirName)
}

ClassMethod ExportUpdateCom()
{
	//d ##class(web.DHCPE.Init).ExportUpdateCom()
	s filename="D:/DHCPE/"
	s ComponentName="DHCPEPreGADM.Home"
	d ##Class(web.Util.UtilService).GetExportComponents(ComponentName,filename)
	s ComponentName="DHCPEPreTemplateTime"
	d ##Class(web.Util.UtilService).GetExportComponents(ComponentName,filename)
	s ComponentName="DHCPEPreTemplate"
	d ##Class(web.Util.UtilService).GetExportComponents(ComponentName,filename)
	s ComponentName="DHCPEPreManagerList"
	d ##Class(web.Util.UtilService).GetExportComponents(ComponentName,filename)
	s ComponentName="DHCPEPreManager"
	d ##Class(web.Util.UtilService).GetExportComponents(ComponentName,filename)
	s ComponentName="DHCPEPreGADM.Find"
	d ##Class(web.Util.UtilService).GetExportComponents(ComponentName,filename)
	s ComponentName="DHCPESaveCollectSpec"
	d ##Class(web.Util.UtilService).GetExportComponents(ComponentName,filename)
	s ComponentName="DHCPEPreIBaseInfo.Edit"
	d ##Class(web.Util.UtilService).GetExportComponents(ComponentName,filename)
	s ComponentName="DHCPEIReport"
	d ##Class(web.Util.UtilService).GetExportComponents(ComponentName,filename)
	s ComponentName="DHCPEPreDate"
	d ##Class(web.Util.UtilService).GetExportComponents(ComponentName,filename)
	s ComponentName="DHCPEUpdateCheckDate"
	d ##Class(web.Util.UtilService).GetExportComponents(ComponentName,filename)
	s ComponentName="DHCPEPreIADM.Find"
	d ##Class(web.Util.UtilService).GetExportComponents(ComponentName,filename)
	s ComponentName="DHCPEPreIADM.Edit"
	d ##Class(web.Util.UtilService).GetExportComponents(ComponentName,filename)
	s ComponentName="DHCPEPreAuditPay"
	d ##Class(web.Util.UtilService).GetExportComponents(ComponentName,filename)
	s ComponentName="DHCPEDropItem"
	d ##Class(web.Util.UtilService).GetExportComponents(ComponentName,filename)
	s ComponentName="DHCPECheckProgress"
	d ##Class(web.Util.UtilService).GetExportComponents(ComponentName,filename)
	s ComponentName="DHCPEAPAC.Find"
	d ##Class(web.Util.UtilService).GetExportComponents(ComponentName,filename)
}

// d ##class(web.DHCPE.Init).MoveLocInfo(263,53,0)

/// 根据已有科室复制一份数据到另外一个科室
ClassMethod MoveLocInfo(SourceLocID, ToLocID, killFlag As %String = "0")
{
	d ##class(web.DHCPE.TempTools).MoveLocInfo(SourceLocID, ToLocID, killFlag)
}

/// d ##class(web.DHCPE.Init).ExportZYBPEGBL("D:/zrc/")
ClassMethod ExportZYBPEGBL(DirName)
{
	// 检查种类
	s GBLName="^User.DHCPEOMETypeD"_".gbl"
	d ..ExportGBL(GBLName,DirName)
	s GBLName="^User.DHCPEOMETypeI"_".gbl"
	d ..ExportGBL(GBLName,DirName)
	// 目标疾病
	s GBLName="^User.DHCPEOMEIllnessD"_".gbl"
	d ..ExportGBL(GBLName,DirName)
	s GBLName="^User.DHCPEOMEIllnessI"_".gbl"
	d ..ExportGBL(GBLName,DirName)
	// 诊断标准
	s GBLName="^User.DHCPEDiagnosticCriteriaD"_".gbl"
	d ..ExportGBL(GBLName,DirName)
	s GBLName="^User.DHCPEDiagnosticCriteriaI"_".gbl"
	d ..ExportGBL(GBLName,DirName)
	// 接害种类
	s GBLName="^User.DHCPEEndangerTypeD"_".gbl"
	d ..ExportGBL(GBLName,DirName)
	s GBLName="^User.DHCPEEndangerTypeI"_".gbl"
	d ..ExportGBL(GBLName,DirName)
	s GBLName="^User.DHCPEEndangerD"_".gbl"
	d ..ExportGBL(GBLName,DirName)
	s GBLName="^User.DHCPEEndangerI"_".gbl"
	d ..ExportGBL(GBLName,DirName)
	s GBLName="^User.DHCPEEndangerC"_".gbl"
	d ..ExportGBL(GBLName,DirName)
	// 接害种类对应的目标疾病
	s GBLName="^User.DHCPEEDIllnessI"_".gbl"
	d ..ExportGBL(GBLName,DirName)
	// 接害种类对应的检查周期
	s GBLName="^User.DHCPEEDCheckCycleI"_".gbl"
	d ..ExportGBL(GBLName,DirName)
	// 接害种类对应的诊断标准
	s GBLName="^User.DHCPEEDCheckCriteriaI"_".gbl"
	d ..ExportGBL(GBLName,DirName)
	// 接害种类对应的检查内容(项目)
	s GBLName="^User.DHCPEEDItemI"_".gbl"
	d ..ExportGBL(GBLName,DirName)
	s GBLName="^User.DHCPEEDItemC"_".gbl"
	d ..ExportGBL(GBLName,DirName)
	// 接害种类对应的检查内容下的重点检查内容
	s GBLName="^User.DHCPEEDItemDetailI"_".gbl"
	d ..ExportGBL(GBLName,DirName)
	// 检查结论
	s GBLName="^User.DHCPEConclusionD"_".gbl"
	d ..ExportGBL(GBLName,DirName)
	s GBLName="^User.DHCPEConclusionI"_".gbl"
	d ..ExportGBL(GBLName,DirName)
	// 处理意见
	s GBLName="^User.DHCPEHandlingOpinionsD"_".gbl"
	d ..ExportGBL(GBLName,DirName)
	s GBLName="^User.DHCPEHandlingOpinionsI"_".gbl"
	d ..ExportGBL(GBLName,DirName)
	// 防护措施
	s GBLName="^User.DHCPEProtectiveMeasuresD"_".gbl"
	d ..ExportGBL(GBLName,DirName)
	s GBLName="^User.DHCPEProtectiveMeasuresI"_".gbl"
	d ..ExportGBL(GBLName,DirName)
	// 行业
	s GBLName="^User.DHCPEIndustryD"_".gbl"
	d ..ExportGBL(GBLName,DirName)
	s GBLName="^User.DHCPEIndustryI"_".gbl"
	d ..ExportGBL(GBLName,DirName)
	// 工种 
	s GBLName="^User.DHCPEWorkTypeD"_".gbl"
	d ..ExportGBL(GBLName,DirName)
	s GBLName="^User.DHCPEWorkTypeI"_".gbl"
	d ..ExportGBL(GBLName,DirName)
}

/// d ##class(web.DHCPE.Init).ImportZYBPEGBL("D:/zrc/")
ClassMethod ImportZYBPEGBL(DirName)
{
	s DirName=##class(web.DHCPE.IMPMenuAndCompont).Replace(DirName,"/","\")
	d ##class(web.DHCPE.Init).KillZYBPEGlobal()
	s OneDir=DirName_"Progress\GBL\"
	s recurse=1
	Do $system.OBJ.LoadDir(OneDir, .qspec, .Errorlog, recurse,.loadedlist)
}

ClassMethod KillZYBPEGlobal()
{
	// 检查种类
	k ^User.DHCPEOMETypeD
	k ^User.DHCPEOMETypeI
	// 目标疾病
	k ^User.DHCPEOMEIllnessD
	k ^User.DHCPEOMEIllnessI
	// 诊断标准
	k ^User.DHCPEDiagnosticCriteriaD
	k ^User.DHCPEDiagnosticCriteriaI
	// 接害种类
	k ^User.DHCPEEndangerTypeD
	k ^User.DHCPEEndangerTypeI
	k ^User.DHCPEEndangerD
	k ^User.DHCPEEndangerI
	k ^User.DHCPEEndangerC
	// 接害种类对应的目标疾病
	k ^User.DHCPEEDIllnessI
	// 接害种类对应的检查周期
	k ^User.DHCPEEDCheckCycleI
	// 接害种类对应的诊断标准
	k ^User.DHCPEEDCheckCriteriaI
	// 接害种类对应的检查内容(项目)
	k ^User.DHCPEEDItemI
	k ^User.DHCPEEDItemC
	// 接害种类对应的检查内容下的重点检查内容
	k ^User.DHCPEEDItemDetailI
	// 检查结论
	k ^User.DHCPEConclusionD
	k ^User.DHCPEConclusionI
	// 处理意见
	k ^User.DHCPEHandlingOpinionsD
	k ^User.DHCPEHandlingOpinionsI
	// 防护措施
	//k ^User.DHCPEProtectiveMeasuresD
	//k ^User.DHCPEProtectiveMeasuresI
	// 行业
	//k ^User.DHCPEIndustryD
	//k ^User.DHCPEIndustryI
	// 工种 
	//k ^User.DHCPEWorkTypeD
	//k ^User.DHCPEWorkTypeI
}

/// 体检基础数据维护-体检设置固定的一些Global 多院区
/// d ##class(web.DHCPE.Init).SetSettingNewByLocID()
ClassMethod SetSettingNewByLocID(LocID)
{
	//s LocID=..#LocID
	s ^DHCPESetting("DHCPE","BilledMode")="New"
	s ^DHCPESetting("DHCPE","BookDateLimit")="No"
	s ^DHCPESetting("DHCPE","CashierMin")=100
	s ^DHCPESetting("DHCPE","ClassName of CRMGateWay")="web.DHCPE.CRM.GatewayDHC"
	s ^DHCPESetting("DHCPE","DefADMFeeType",LocID)=""
	s ^DHCPESetting("DHCPE","DefPatientType",LocID)=..#DefPatientType
	s ^DHCPESetting("DHCPE","CanChangePayModes",LocID)=..#CanChangePayModes
	s ^DHCPESetting("DHCPE","GRDiagnosisType",LocID)=..#GRDiagnosisType
	s ^DHCPESetting("DHCPE","GetHWOrder")=""
	s ^DHCPESetting("DHCPE","GroupPatNO_Begin")="00000000"
	s ^DHCPESetting("DHCPE","GroupPatNO_CurNo")=""
	s ^DHCPESetting("DHCPE","HospYBCode")=""
	s ^DHCPESetting("DHCPE","HospitalCode",LocID)=..#HospitalCode
	s ^DHCPESetting("DHCPE","HospitalName")=""
	s ^DHCPESetting("DHCPE","IAdmStatuses_Resultable")="^ARRIVED^CHARGED^COMPLETED^"
	s ^DHCPESetting("DHCPE","NoCodeLabItem")=""
	s ^DHCPESetting("DHCPE","NoReportStation")=""
	s ^DHCPESetting("DHCPE","ODStr")=""
	s ^DHCPESetting("DHCPE","InvFlag",LocID)=..#InvFlag
	s ^DHCPESetting("DHCPE","OEItemPrint",LocID)="OEItemPrintA4"
	s ^DHCPESetting("DHCPE","PAPMINo_GenModel")="NoGen"
	s ^DHCPESetting("DHCPE","PEItemCodePrefix")="PE"
	s ^DHCPESetting("DHCPE","PEPatType")="公费"
	s ^DHCPESetting("DHCPE","PESystemStartDate")=60823
	s ^DHCPESetting("DHCPE","PageModel",LocID)="A4"
	s ^DHCPESetting("DHCPE","PatItemSort")=""
	s ^DHCPESetting("DHCPE","PatItemSortTemp")=""
	s ^DHCPESetting("DHCPE","PatNO_Begin")=""
	s ^DHCPESetting("DHCPE","PatOrdFlag")="0^0"
	s ^DHCPESetting("DHCPE","RegNoLength",LocID)=..#RegNoLength
	s ^DHCPESetting("DHCPE","ReportTitle")=""
	s ^DHCPESetting("DHCPE","RoundingFeeLimitMin",LocID)=50
	s ^DHCPESetting("DHCPE","SalesDefaultDept")=""
	s ^DHCPESetting("DHCPE","SSGroup_SummarizeAudit",LocID)=..#SummarizeAudit
	s ^DHCPESetting("DHCPE","SalesDefaultDept")=""
	s ^DHCPESetting("DHCPE","SetsDefaultTar",LocID)=..#SetsDefaultTar
	s ^DHCPESetting("DHCPE","SpecialPayModes")=..#SpecialPayModes
	s ^DHCPESetting("DHCPE","StationId_NoAdvice")=""
	s ^DHCPESetting("DHCPE","StationId_NoSubmit")=""
	s ^DHCPESetting("DHCPE","TrakVerison")=..#TrakVerison
	s ^DHCPESetting("DHCPE","InsertOPInv",LocID)=..#InsertOPInv
	s ^DHCPESetting("DHCPE","InvColSortType",LocID)=..#InvColSortType
	s ^DHCPESetting("DHCPE","TarOCIsNew",LocID)=..#TarOCIsNew

	s ^DHCPESetting("DHCPEBaseData","PEARCOS")=""
}

Storage Default
{
<Data name="InitDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCPE.InitD</DataLocation>
<DefaultData>InitDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCPE.InitD</IdLocation>
<IndexLocation>^web.DHCPE.InitI</IndexLocation>
<StreamLocation>^web.DHCPE.InitS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
