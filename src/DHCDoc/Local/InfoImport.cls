/// CreateDate：2019.2.21
/// CreateUser: gry
/// Desc:医生站业务信息导入类，处理比如上线时的患者信息导入、预约信息导入
Class DHCDoc.Local.InfoImport Extends (%RegisteredObject, %XML.Adaptor)
{

/// 导入患者信息模式：
/// 老库为Cache数据库且使用直连数据库的模式导入数据(Y)
/// 	整理直连模式需要读取的老库global，用于DBA映射数据库,如下:
/// 		^PAPER、^PAPERi、^DHCPERSON、^SS、^CT、^PAC、^DHCCARDi、^DHCCARD、^DHCACDi、^DHCACD、^DHCCARDTYPEDef、^DHCCARDINVPRT	
/// 老库为非Cache数据库时使用文本文件导入数据库(N)
Parameter OldDababaseIs = "N";

/// OldDababaseIs = "Y"的情况下新库中映射的namespace，注意需要同时挂载MEDDATA和MEDCODE，否则无法获取老库的基础配置global
Parameter DataNameSpace = "DHC-DATA-OLD";

/// SS_User表中的SSUSR_Initials，即登录工号，用于导入数据时记录的导入人工号，方便后期区分导入数据
Parameter UserInitials = "demo";

/// 用于设置导入卡押金或账户余额时的支付方式,CT_PayMode
Parameter PayModeCode = "DEPZZ";

/*
--------------------------总体说明---------------------------
1：	目前该方法导入卡数据及患者基本信息，OldDababaseIs=“Y”时如需导入卡押金及账户余额，因涉及到导入过程中老库尚存在预交金消费，请本地化讨论处理
2：	执行结果数据记录-执行完成后核对该global的内容，确认执行结果
	最近的一次导入错误合计:zw ^gry("ImportPatInfo",^gry("ImportPatInfo"),"Err")
	最近的一次导入程序执行时间:zw ^gry("ImportPatInfoErr",^gry("ImportPatInfo"),"RunTime")
3： 因模式问题，病案号在老系统的取值需要参照GetPatInfoFromCurrCache中病案号的说明，特殊处理取值程序
	病案号直接导入到新库的Pa_PatMas->PAPMI_Medicare,该字段的应用需要电子病案管理组在住院登记时自行处理（经李毅0920沟通结果：需要病案管理组识别该字段并插入病案相关表）
-------------------------OldDababaseIs==Y时-----------------------------
运行注意事项
1：★★★重要★★★
	s ^PAPER(0,"CNT","I")="2200000"		//一般在老库最大登记号的基础上，预留【2w*老库预计运行天数】即可；
	新库登记号计算器应按照老库同步计数器，并预留一定的数量，防止新库登记号生成有误；
	新库登记号计数器应在新库最后一次清除业务数据后执行，且仅需要执行一次即可。分批多次导入老库数据时，不需要重复重置计数器！
2:
	若导入数据时不需要进行主索引管理，需暂时把卡类型上的【验证方式】配置为【NONE】；同步完数据后需要改回去【ID Unqiue】！
3:

4:	
	因项目情况考虑是否执行第四步
	若存在新老库并行使用阶段，有可能会出现新库建档病人前往老系统就诊，
	因此需要在新库建卡时自动把建档信息同步至老库，需给新库建卡方法添加方法
	d ##Class(DHCDoc.Local.InfoImportMethod).SendPatInfoToMedTrak(PatientID)
-------------------------OldDababaseIs==N时-----------------------------
1：	处理文件目录：D:\ImportPatInfo.txt;
2:	每一行数据格式描述
		流水号或PatientID(必填)^登记号^姓名(必填)^性别(必填,CT_Sex->CTSEX_Desc)^出生日期(必填,YYYY-MM-DD)
		^语言(SS_Language->CTLAN_Desc)^民族(CT_Nation->CTNAT_Desc)^宗教(CT_Religion->CTRLG_Desc)^婚姻(CT_Marital->CTMAR_Desc)^教育(CT_Education->EDU_Desc)
		^社会地位(必填,CT_SocialStatus->SS_Desc)^血型(PAC_BloodType->BLDT_Desc)^邮编(CT_Zip->CTZIP_Desc)^联系电话(必填)^单位电话
		^个人电话^工作单位^身份证号^住院次数^预留
		^预留^预留^预留^预留^预留
		^住址^证件类型(PAC_CardType->CARD_Desc)^证件号^联系人姓名^联系人证件类型(PAC_CardType->CARD_Desc)
		^联系人证件号^联系人联系方式^个人医保卡号^病案号^国籍(CT_Country->CTCOU_Desc)
		^现住省(CT_Province->PROV_Desc)^现住市(CT_City->CTCIT_Desc)^现住区(CT_CityArea->CITAREA_Desc)^出生省(CT_Province->PROV_Desc)^出生市(CT_City->CTCIT_Desc)
		^出生区(CT_CityArea->CITAREA_Desc)^籍贯省(CT_Province->PROV_Desc)^籍贯市(CT_City->CTCIT_Desc)^籍贯区(CT_CityArea->CITAREA_Desc)^院内账户余额(必填,大于等于0)
		##########(10个#)
		若需要导入卡片信息,可传入多组:
		卡类型代码(必填,DHC_CardTypeDef->CTD_Code)^卡号(必填)^卡片内校验码(明文)^卡押金费用(必填,建卡时收取的押金费用,大于等于0)
		$卡类型代码^卡号^卡片内校验码^卡押金费用
		$卡类型代码^卡号^卡片内校验码^卡押金费用
		$......
3:	需要给第三方提供的字典表信息如下
		性别:select CTSEX_Desc from CT_Sex
		语言:select CTLAN_Desc from SS_Language
		民族:select CTNAT_Desc from CT_Nation
		宗教:select CTRLG_Desc from CT_Religion
		婚姻:select CTMAR_Desc from CT_Marital
		教育:select EDU_Desc from CT_Education
		社会地位:select SS_Desc from CT_SocialStatus
		血型:select BLDT_Desc from PAC_BloodType
		邮编:select CTZIP_Desc from CT_Zip
		证件类型:select CARD_Desc from PAC_CardType
		国籍:select CTCOU_Desc from CT_Country
		省:select PROV_Desc from CT_Province
		市:select CTCIT_Desc from CT_City
		区:select CITAREA_Desc from CT_CityArea
--
*/
/// 导入患者信息
ClassMethod ImportPatInfo() As %String
{
	if ..#OldDababaseIs="Y" {
		///老库起始病人ID，可用于分批次导入数据
		s BeginID=""
		d ##class(DHCDoc.Local.InfoImportMethod).ImportPatInfoCache(BeginID,..#UserInitials,..#DataNameSpace,..#PayModeCode)
	}else{
		d ##class(DHCDoc.Local.InfoImportMethod).ImportPatInfoNotCache(..#UserInitials,..#PayModeCode)
	}
}

/*

---------功能说明--------------------
该方法建议仅导入患者预约记录；
对于提前挂号或提前取号的处理：
	场景：项目上线且不同意停止就诊日期为上线后日期的提前挂号或取号业务（优先方案应说服医院停止提前挂号和取号业务）
	此方案缺陷：仅导入就诊信息及处理资源表占序号，不处理其他就诊相关业务数据；相关退号处理需在老系统中处理；
---------使用说明--------------------
处理文件目录：D:\ImportAppInfo.txt;
文件中每一行应记录单独的预约记录，每条预约记录应按以下格式组织数据：
	科室代码(CT_Loc->CTLoc_Code)^号别代码(CT_CareProv->CTPCP_Code)^预约日期(YYYY-MM-DD)^时段代码(DHC_TimeRange->TR_Code)^登记号(与个人信息选择性必填)
	^姓名^联系电话^身份证号码^是否生成就诊(Y/N,Y时登记号必填)^就诊序号(非必填)
	^就诊分时段信息(排班分时段信息段，非必填)^预约方式代码(RBC_AppointMethod，必填)
导入错误历史存储位置为:
	最近的一次导入错误合计:zw ^gry("ImportAppInfo",^gry("ImportAppInfo"),"Err")
	最近的一次导入程序执行时间:zw ^gry("ImportAppInfoErr",^gry("ImportAppInfo"),"RunTime")
*/
/// 导入预约相关信息
/// d ##Class(DHCDoc.Local.InfoImport).ImportAppInfo()
ClassMethod ImportAppInfo() As %String
{
	Q ##class(DHCDoc.Local.InfoImportMethod).ImportAppInfo(..#UserInitials)
}

}
