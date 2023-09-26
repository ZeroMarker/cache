Import SQLUser

Class web.DHCRisInit Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// w ##class(web.DHCRisInit).ClearRisDate()
/// 清除ris相关的业务数据
ClassMethod ClearRisDate() As %String
{
	Set $ZT="ErrorClearRis"	
	//登记信息
	&sql(delete from dhcrb_reginfo_bodyparts)
	&sql(delete from dhcrb_reginfo)
	&sql(delete from DHCRB_ReturnFee) 
	&sql(delete from DHCRB_CallQueue)
	//预约信息
	&sql(delete from DHCRBC_SchduleDetailBody)
	&sql(delete from dhcrbc_resschduledetail)
	&sql(delete from DHCRBC_BookInfoExternal)  //不用
	&sql(delete from DHCRBC_ExternalBookInfo)
	&sql(delete from DHCRBC_ResSchdule) 
	//报告信息
	&sql(delete from DHCRB_Report)
	&sql(delete from DHCRB_Report_Files)
	&sql(delete from DHCRB_Report_Unit)
	&sql(delete from DHCRB_StudyDesc)
	&sql(delete from DHCRB_StudyImages)
	k ^DHCRBStudy
	
	//申请单信息
	&sql(delete from DHCRB_ApplicationBill_OrdItem)
    &sql(delete from DHCRB_ApplicationBill)
    &sql(delete from DHCRB_RejectApplication)
	k ^DHCRBAppOrd
  	k ^DHCRBAppOrdi
  	
  	
  	
  	//发送申请单时存放信息变量
	k ^DHCRISAPPINFOS("APPLICATIONBILL")

	//获取检查号变量 
	k ^DHCRISSTUDYINFOTMEP

	//RISService接口存放信息变量
	k ^DHCRISBOOKEDINFO

	//预约流水号
	//(天)
	k ^DHCRisLocBookIndex
	k ^DHCRisBookRoomIndex
	k ^DHCRisBookGroupIndex
	//(预约保留号-天)
	k ^DHCRisBookLocCancel
	k ^DHCRisBookRoomCancel
	k ^DHCRisBookGroupCancel
	//(时段)
	k ^DHCRisResLocBKIndex
	k ^DHCRisResBookRoomIndex
	k ^DHCRisResBookGroupIndex
	//(预约保留号-时段)
	k ^DHCRisBookTimeLocCancel
	k ^DHCRisBookTimeRoomCancel
	k ^DHCRisBookTimeGroupCancel

	//登记流水号
	k ^DHCRisRegIndex
	k ^DHCRisCheckRoomIndex
	k ^DHCRisCheckGroupIndex
	
	
	//大查询的global
	k ^DHCRisLookupCondition
	k ^DHCRisTmpPrintData
	k ^DHCRisExportExcelData
	
	
	//临床大夫看报告记录表
	k ^DHCRBCLINICRPTCONNECTDOC,^DHCRBCLINICRPTCONNECTDOCi
	k ^DHCRBCLINICCHECKRPTINFO,^DHCRBCLINICCHECKRPTINFOi
	q "Success"

ErrorClearRis	          
 	Quit "<ERROR>"_$ZE
}

/// w ##class(web.DHCRisInit).ClearRisSetInfo()
/// 清空和his相关的配置数据
ClassMethod ClearRisSetInfo() As %String
{
	s $ZT="ErrorClearRisSetInfo"
	//检查项目关联申请单
	&sql(delete from DHCRBC_OrdAppSet)	
	&sql(delete from DHCRBC_ItmMastAppSet)
	&sql(delete from DHCRBC_ItemCatAppSet)	
	&sql(delete from DHCRBC_OrdCatAppSet)
	
	//模板数据(申请单检查目的、临床所见等)
	&sql(delete from DHCRBC_ApplicationTempl)
	&sql(delete from DHCRBC_IllStatus)
	&sql(delete from DHCRBC_Goal)
	
	// 注意事项
	&sql(delete from  DHCRB_Memo)
	
	// 诊间设备关联
	&sql(delete from DHCRBC_Room_Equipment)
	
	//体位
	&sql(delete from DHCRBC_BodyPart_Posture)
	&sql(delete from DHCRBC_Orditem_BodyPart)
	
	//检查号规则
	&sql(delete from DHCRB_StudyNo_CreateRule)
	&sql(delete from DHCRB_Number_CreateRule)
	
	//科室设置
	&sql(delete from  DHCRBC_LocParam)
	&sql(delete from DHCRBC_ClinicSet)

	//和资源相关
	&sql(delete from DHCRBC_Client)  //dicom 客户端
	//&sql(delete from DHCRBC_EquipmentTag)
	
	//测值
	&sql(delete from DHCRBC_ItemBase)
	&sql(delete from DHCRBC_ItemScheme)
	//&sql(delete from DHCRBC_ItemValue)
	// 权限 人员和科室相关
	&sql(delete from  DHCRB_Right)
	//报告内容模板
	&sql(delete from DHCRBC_LocTempl)
	&sql(delete from DHCRBC_UserTempl)
	//影像号，很少使用
	&sql(delete from DHCRB_NO)
	
	//基本单元 没用
	//&sql(delete from DHCRB_Unit)
	//&sql(delete from DHCRB_AppointmentInfo)  //不用
	
	//预约相关
	&sql(delete from DHCRBC_ItemBookProperty)
	&sql(delete from DHCRBC_ItemBookProperty_ServiceG)
	&sql(delete from DHCRBC_BookParam)
	&sql(delete from DHCRBC_BookParamSG)
	&sql(delete from DHCRBC_ResPlan)
    
    //报告模板表
  	&sql(delete from DHCRBC_LocationRShape)
    
    //诊间表
	&sql(delete from DHCRBC_Room)
	//时间段表
	&sql(delete from DHCRBC_TimePeriodSet)
	
	// 检查排序组配置
	&sql(delete from DHCRB_ExamSortGroup)
	&sql(delete from DHCRB_ExamSortProperty)
	// 检查组配置
	&sql(delete from DHCRB_ExamGroupItem)
	&sql(delete from DHCRB_ExamGroup)
	// 检查关系配置
	&sql(delete from DHCRB_ExamRejectItem)
	&sql(delete from DHCRB_ExamPrepositionItem)
    
    q "Success"
   
ErrorClearRisSetInfo	          
 	Quit "<ERROR>"_$ZE
}

}
