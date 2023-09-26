/// 名称:安全组实体类
/// 编写者:基础数据平台组 - 陈莹
/// 编写日期:2013-05-06
Class web.Entity.CT.SSGroup Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.SSGroup";

Property SSGRPRowId As %String;

Property SSGRPDesc As %String;

// 1.Bed Management

Property SSGRPWardViewLocListDR As %String;

Property SSGRPWardPlaceLocListDR As %String;

Property SSGRPAllowDeleteBedTransactions As %String;

Property SSGRPRestrictWardsToDepartment As %String;

// Booking

Property SSGRPAllowBookOutsideRange As %String;

Property SSGRPAllowedtoBookOR As %String;

// Property SSGRPAllowBookPastGuarDateOP As %String;

Property SSGRPAllowMultipleServAdhoc As %String;

Property SSGRPAllowOverBookRB As %String;

Property SSGRPAllowOverBookOnSlotZero As %String;

Property SSGRPAllowUndoAppt As %String;

Property SSGRPAllowOverPayorRestrict As %String;

Property SSGRPChkFutureAppts As %String;

Property SSGRPNotBookOutSess As %String;

Property SSGRPNotExcLoadLevelOverrides As %String;

Property SSGRPNAllAddPastAppt As %String;

Property SSGRPDFLocListDR As %String;

/// billing and cashiers
Property SSGRPAllowDiscPaidOrder As %String;

Property SSGRPRoundingAutomatic As %String;

Property SSGRPRoundingOnPayment As %String;

// clinical and EMR

Property SSGRPAllowOSFEdit24hrs As %String;

Property SSGRPOrdersPrevEpisode As %String;

// Property SSGRPAllowToExecuteOrderOutsideShift As %String;

Property SSGRPShowAllPatientsInNWB As %String;

Property SSGRPDisplayDiagnProcDRG As %String;

Property SSGRPClinicalLocListDr As %String;

// Discharge	

Property SSGRPAutoMedDischarge As %String;

Property SSGRPDischargeLocList As %String;

// general system information

Property SSGRPAllowSendMsgAll As %String;

Property SSGRPEnableSystemCT As %String;

Property SSGRPRestrictLocForGrHospitals As %String;

Property SSGRPSecurityLevel As %String;

Property SSGRPInactivityTimeOut As %String;

Property SSGRPPasswordDaysToExpire As %String;

// operating theatre workbench

Property SSGRPAllowChangeDepOT As %String;

Property SSGRPNAllORBookNA As %String;

Property SSGRPNAllORBookNoSess As %String;

Property SSGRPNAllORBookPast As %String;

Property SSGRPDontBookOutsideOTSchedule As %String;

Property SSGRPWarnORBookingMoveRes As %String;

// order and results

Property SSGRPAllowToChangeOEStatus As %String;

Property SSGRPAllowDiscOrdPackedPres As %String;

Property SSGRPAllowedSeeSEnsitRes As %String;

Property SSGRPCheckApproved As %String;

Property SSGRPDefaultDoseEquiv As %String;

Property SSGRPDisableAddAll As %String;

Property SSGRPDiscontinueExecOrders As %String;

Property SSGRPSuppressPin As %String;

Property SSGRPIgnoreOrderRestrictions As %String;

Property SSGRPJobOE As %String;

Property SSGRPMinimizeOEUpdate As %String;

Property SSGRPRetainOrderCategory As %String;

Property SSGRPPrice As %String;

// paper record traking

Property SSGRPAllowIssueArchiveMR As %String;

Property SSGRPRestrictMRTypeCurrHosp As %String;

Property SSGRPAllowActivateVolume As %String;

Property SSGRPAllowNewMRTypesPat As %String;

// patient management

Property SSGRPWaitListStatusDR As %String;

Property SSGRPEmergencyLocListDR As %String;

Property SSGRPHealthPromLocListDR As %String;

Property SSGRPInPatLocListDR As %String;

Property SSGRPOnlyInpatUnitsForMyHospita As %String;

Property SSGRPTempPatLocList As %String;

Property SSGRPOutPatLocListDR As %String;

Property SSGRPOnlyOutpatUnitsForMyHospit As %String;

Property SSGRPInPatTransferListDR As %String;

Property SSGRPRadLocList As %String;

Property SSGRPWaitListLocListDR As %String;

Property SSGRPWLStatusListDR As %String;

// User.PACWLStatusList

Property SSGRPWardAttendLocListDR As %String;

// patient management2

Property SSGRPAllowDeleteEpisode As %String;

Property SSGRPAllowedAddOrdersReview As %String;

// Property SSGRPAllowBookPastGuarDateWL As %String;

Property SSGRPAllowToChangeFamilyDoctor As %String;

Property SSGRPChangeDataAfterDischarge As %String;

Property SSGRPAllowDeleteDiagOtherUs As %String;

Property SSGRPAllowEditEpLogLoc As %String;

Property SSGRPAllowEditWLStatusTreated As %String;

Property SSGRPAllowViewVIPPatients As %String;

Property SSGRPShowPatientSearch As %String;

Property SSGRPDisplayDiagnosis As %String;

Property SSGRPCheckOrdersCovered As %String;

Property SSGRPShowOnlyIPUnitsForWL As %String;

Property SSGRPRestrictSearchEMR As %String;

Property SSGRPShowAllLocations As %String;

Property SSGRPShowPreadmafterAppoint As %String;

Property SSGRPMoveToDefaultBed As %String;

Property SSGRPWLAuditLetterDays As %String;

// stock	

Property SSGRPAllowEditPriceGR As %String;

Property SSGRPAllowToChangeAgrPrice As %String;

// Property SSGRPAllowToAddItemToVendPortfolio As %String;

Property SSGRPAllowAddStockItem As %String;

// Property SSGRPAllowToAddItemToLocPortfolio As %String;

Property SSGRPOnePOforEveryVendor As %String;

Property SSGRPConsReasonMandatory As %String;

Property SSGRPUserPOReferenceNotMandator As %String;

Property SSGRPDefaultPOReferenceDR As %String;

Property SSGRPMaxPOAmount As %String;

// 有效标志 （空和Y为有效）

Property SSGRPActiveFlag As %String;

/// 安全组代码=角色代码
Property SSGRPCode As %String;

/// 开始日期
Property SSGRPStartDate As %String;

/// 结束日期
Property SSGRPEndDate As %String;

/// 系统创建日期
Property SSGRPCreateDate As %String;

/// 系统创建时间
Property SSGRPCreateTime As %String;

/// 系统创建人
Property SSGRPCreateUser As %String;

/// 系统排序号
Property SSGRPSeqNo As %String;

/// 系统最后更新日期
Property SSGRPLastUpdateDate As %String;

/// 系统最后更新时间
Property SSGRPLastUpdateTime As %String;

/// 系统最新更新人
Property SSGRPLastUpdateUser As %String;

/// 拼音码
Property SSGRPPYCode As %String;

/// 五笔码
Property SSGRPWBCode As %String;

/// 备注
Property SSGRPMark As %String;

/// 上级安全组代码-外键
Property SSGRPGroupDr As %String;

}
