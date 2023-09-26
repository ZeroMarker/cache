Import sqluser

Class web.DHCADVCLEARDATA Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Description: 清除不良事件业务数据
/// Creator:     CongYue
/// CreateDate:  2017-05-23
/// Others: 	 d ##class(web.DHCADVCLEARDATA).KillBascData()
ClassMethod KillBascData() As %String
{
	// 旧版不良事件业务数据
	//医疗报告
	k ^DHCMEDADRR
	k ^mdata("DHCMedAdrReport")
	k ^DHCADVPARINFO ;医疗不良事件当事人信息表
	k ^mdata("DHCAdvParInformation")
	//器械报告
	k ^DHCMATADRR
	k ^mdata("DHCMatAdrReport")
	//药品报告
	k ^DHCADVDRUGREP
	k ^mdata("DHCAdvDrugReport")	
	k ^DHCADVDRUGDI ;原患疾病 
	k ^mdata("DHCAdvDrugRepDiag")
	k ^mdata("DHCAdvDrugRepItm") ;药品明细
	k ^mdata("DHCAdvDrugRepEvent") ;不良反应事件
	
	//用药差错报告
	k ^DHCADVMEDSAR
	k ^mdata("DHCMedSafetyReport")
	k ^DHCADVMEDRLK ;用药安全报告环节
	k ^mdata("DHCMedReportLink")
	k ^mdata("DHCMedReportLinkItm")
	k ^DHCADVMEDRRET ;用药差错报告后果
	k ^mdata("DHCMedReportResult")
	
	//输血报告
	k ^DHCBLDADVRPT
	k ^mdata("DHCAdvBloodReport")
	k ^DHCADVBLDRLI ;输血类别
	k ^mdata("DHCAdvBldRepList")
	k ^DHCADVBLDRLIN ;输血编号
	k ^mdata("DHCAdvBldRepListNo")
	k ^DHCADVBLDBACI ;输血患者体征 临床症状
	k ^mdata("DHCAdvBldBasInfo")
		
	//新版不良事件关联表
	k ^DHCADVMASTER  ;不良事件主表
	k ^mdata("DHCAdvMaster")
	k ^User.DHCAdvFormRecordD  ;不良事件表单填写记录表
	k ^User.DHCAdvFormRecordI  
	k ^User.DHCAdvFormRecordItmD ;不良事件表单填写记录子表
	k ^User.DHCAdvFormRecordItmI
	k ^User.DHCAdvFormRecordVersionI ;不良事件表单 记录版本表
	k ^User.DHCAdvFormRecordVersionD
	k ^DHCADVFILE ;不良事件归档记录表
	k ^mdata("DHCAdvRepFile") 
	k ^DHCADVCASHARE  ;不良事件案例共享记录表
	k ^mdata("DHCAdvCaseShare")
	k ^DHCADVULCP  ;不良事件压疮记录表
	k ^mdata("DHCAdvUlcPartInfo")
	k ^DHCADVMASTERCAT  ;不良事件类别存储表
	k ^mdata("DHCADVMASTERCAT")
	k ^DHCADVATTR  ;不良事件上传图片关联表
	k ^mdata("DHCAdvAttachRec")
	k ^User.DHCMedAdvRepNotesD  ;不良事件报告批注
	k ^User.DHCMedAdvRepNotesI
	
	// 公用业务数据
	//评估明细
	k ^DHCADVREPMAN
	k ^mdata("DHCAdvRepManage")
	
	//审批明细
	k ^DHCMEDREPADT 
	k ^mdata("DHCMedAdrRepAudit")
	k ^mdata("DHCMedAdrRepAuditItm")
	
	//在线分享评论
	k ^DHCADVRSH ;分享
	k ^mdata("DHCAdvRepShare")
	k ^DHCADVRON ;在线评价
	k ^mdata("DHCAdvRepOnline")
	k ^DHCADVROA ;在线点赞计数
	k ^mdata("DHCAdvRepOnlineAcc")
	
	// 二维统计模板数据
	k ^DHCADVST
}

/// Description: 清除不良事件配置数据
/// Creator:     CongYue
/// CreateDate:  2017-06-05
/// Others: 	 d ##class(web.DHCADVCLEARDATA).KillConfigData()
ClassMethod KillConfigData() As %String
{
	
	// 旧版配置数据
	;k ^DHCADVDEMED ;处理办法
	;k ^mdata("DHCAdvDealMethod")	
	;k ^DHCADVIMPMED ;改进办法 
	;k ^mdata("DHCAdvImpMethod")
	;k ^DHCADVDRUGEV ;药物不良事件名称
	;k ^mdata("DHCAdvDrugEvent") 
	//提供何种服务时发生（医疗不良事件服务类型）
	;k ^DHCADVSERTYPE
	;k ^mdata("DHCAdvServiceType")
	//医疗不良事件病人状态表
	;k ^DHCADVPATSTA
	;k ^mdata("DHCAdvPatStatus")
	//医疗不良事件与当事人可能相关因素
	;k ^DHCADVPARFAC
	;k ^mdata("DHCAdvPartyFactors")
	
	//新版不良事件
	;k ^User.DHCAdvFormCatD  ;不良事件表单 表单分类表
	;k ^User.DHCAdvFormCatI
	;k ^User.DHCAdvFormD  ;不良事件表单 样式记录表
	;k ^User.DHCAdvFormI  
	;k ^User.DHCAdvFormDicD ;不良事件表单元素表
	;k ^User.DHCAdvFormDicI
	;k ^User.DHCAdvFormNameI ;不良事件表单 表单名称表
	;k ^User.DHCAdvFormNameD
	;k ^DHCADVEXPF           ;不良事件导出字典维护
	;k ^mdata("DHCAdvExpField")
	;k ^DHCADVSECUG          ;不良事件安全小组维护（大科） 
	;k ^mdata("^DHCADVSECUG")
	;k ^DHCADVSECUGU          ;不良事件安全小组维护（大科） 成员
	;k ^mdata("^DHCADVSECUGU")
	;k ^DHCADVSECUGUW          ;不良事件安全小组维护（大科） 病区
	;k ^mdata("^DHCADVSECUGUW")
	;k ^DHCADVSECUGUL          ;不良事件安全小组维护（大科） 科室
	;k ^mdata("DHCAdvSecuGroupUserLoc")
	;k ^DHCADVSTF              ;不良事件报告统计字典维护
	;k ^mdata("DHCADVSTATFIELD")
	;k ^DHCADVSTFV             ;不良事件报告统计自定义字典维护
	;k ^mdata("DHCADVSTATFEILDVAL")
	;k ^DHCADVAUTLOC             ;科室维护(科室1，科室2)
	;k ^mdata("DHCAdvAutLoc")
	;k ^DHCADVFF             ;不良事件 表单业务字段维护
	;k ^mdata("DHCADVFORMFIELD")
	;k ^DHCADVFDC             ;不良事件表单元素对照关系
	;k ^mdata("DHCADVFORMDICCONTRAST")
	;k ^DHCADVHOLIDAY             ;不良事件 节假日维护
	;k ^mdata("DHCAdvHoliday")
	;k ^DHCADVFDLINK  ;表单元素字典维护关联表(绑定)
	;k ^mdata("DHCADVFORMDICLINK")
	;k ^DHCADVEAE   ;属性值维护表
	;k ^mdata("DHCADVELEATTREXT")
	;k ^DHCADVDC  ;统计接口字段对照
	;k ^mdata("DHCADVDICCONTRAST")
	;k ^DHCADVAFC   ;接口输出字段维护
	;k ^mdata("DHCADVAFC")
	
	
	//  公用
	;k ^DHCADREVTWF ;工作流
	;k ^mdata("DHCAdrEvtWorkFlow")
	;k ^DHCADREVTWFI ;工作流项目
	;k ^mdata("DHCAdrEvtWorkFlowItm")
	;k ^DHCADREVTWFGR ;工作流项目授权
	;k ^mdata("DHCAdrWorkFlowGrant")
	;k ^DHCADREVTWFL  ;工作流项目级别关联表
	;k ^mdata("DHCAdrEvtWorkFlowLink")
	;k ^DHCADVQUS ;不良事件查看授权按类别
	;k ^mdata("DHCAdvQuerySec")
	
	;k ^User.DHCAdvGenericRelationD ;通用关系表数据与属性
	;k ^User.DHCAdvGenericRelationI
}

/// Description: 清除不良事件配置数据（与科室相关）
/// Creator:     CongYue
/// CreateDate:  2018-03-30
/// Others: 	 d ##class(web.DHCADVCLEARDATA).KillADVDataOnlyLinkLoc()
ClassMethod KillADVDataOnlyLinkLoc() As %String
{
	
	TS
	//工作流
	;k ^DHCADREVTWF ;工作流
	;k ^mdata("DHCAdrEvtWorkFlow")
	;k ^DHCADREVTWFI ;工作流项目
	;k ^mdata("DHCAdrEvtWorkFlowItm")
	;k ^DHCADREVTWFGR ;工作流项目授权
	;k ^mdata("DHCAdrWorkFlowGrant")

	k ^DHCADREVTWFL  ;工作流项目级别关联表
	k ^mdata("DHCAdrEvtWorkFlowLink")	
	k ^User.DHCAdvGenericRelationD ;通用关系表数据与属性
	k ^User.DHCAdvGenericRelationI
	
	
	//不良事件查看授权按类别
	;k ^DHCADVQUS 
	;k ^mdata("DHCAdvQuerySec")
	
	//新版不良事件	
	;k ^DHCADVSECUG          ;不良事件安全小组维护（大科） 
	;k ^mdata("^DHCADVSECUG")
	k ^DHCADVSECUGU          ;不良事件安全小组维护（大科） 成员
	k ^mdata("^DHCADVSECUGU")
	k ^DHCADVSECUGUW          ;不良事件安全小组维护（大科） 病区
	k ^mdata("^DHCADVSECUGUW")
	k ^DHCADVSECUGUL          ;不良事件安全小组维护（大科） 科室
	k ^mdata("DHCAdvSecuGroupUserLoc")
	// 清除不良事件可查看权限数据、工作流权限数据（人员、科室数据）
	S DelFlag= ##class(web.DHCADVCLEARDATA).KillAdvSecData()
	I DelFlag'="" tro
	Q:DelFlag'="" DelFlag
	TC
	Q ""
}

/// Description: 清除不良事件可查看权限数据、工作流权限数据（人员、科室数据）
/// Creator:     CongYue
/// CreateDate:  2022-01-10
/// Others: 	 d ##class(web.DHCADVCLEARDATA).KillAdvSecData()
ClassMethod KillAdvSecData() As %String
{
	
	TS
	// 删除可查看权限 科室、人员、大科权限数据
	&SQL(Delete From DHC_AdvQuerySec Where ADVQS_Type=2 OR ADVQS_Type=3)
	I SQLCODE'=0 tro
	Q:SQLCODE'=0 SQLCODE

	// 删除工作流权限 科室、人员、大科权限数据
	&SQL(Delete From DHC_AdrWorkFlowGrant Where ADRWFG_Type=2 OR ADRWFG_Type=3)
	I SQLCODE'=0 tro
	Q:SQLCODE'=0 SQLCODE
	TC
	
	Q ""
}

}
