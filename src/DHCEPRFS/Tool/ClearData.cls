Class DHCEPRFS.Tool.ClearData Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator：     yangpeng
/// CreatDate：   2020-04-14
/// Description:  归档系统清理业务数据方法（上线前清数据） 含归档和RBAC业务数据
/// Input：       Flag 是否删除数据标志，只有是Y才会删除数据    
/// d ##class(DHCEPRFS.Tool.ClearData).KillInstanceData("Y")
ClassMethod KillInstanceData(AFlag As %String) As %String
{
	q:(AFlag'="Y") "0"

	//清电子病历归档业务数据
	Kill ^DHCEPRFS.INST.AdmMRStatusD
	Kill ^DHCEPRFS.INST.AdmMRStatusI
	Kill ^DHCEPRFS.INST.AdmMRStatusLogD
	Kill ^DHCEPRFS.INST.AdmMRStatusLogI
	Kill ^DHCEPRFS.INST.AdmTaskCrDtlD
	Kill ^DHCEPRFS.INST.AdmTaskCrDtlI
	Kill ^DHCEPRFS.INST.AdmTaskCreateD
	Kill ^DHCEPRFS.INST.AdmTaskCreateI
	Kill ^DHCEPRFS.INST.AdmTaskExecD
	Kill ^DHCEPRFS.INST.AdmTaskExecI
	Kill ^DHCEPRFS.INST.AdmTaskQueueD
	Kill ^DHCEPRFS.INST.AdmTaskQueueI
	Kill ^DHCEPRFS.INST.AdmTaskSucceedD
	Kill ^DHCEPRFS.INST.AdmTaskSucceedI
	Kill ^DHCEPRFS.INST.CheckedPatListD
	Kill ^DHCEPRFS.INST.CheckedPatListI
	Kill ^DHCEPRFS.INST.CreateServersLogD
	Kill ^DHCEPRFS.INST.CreateServersLogI
	Kill ^DHCEPRFS.INST.DirLocD
	Kill ^DHCEPRFS.INST.DirLocI
	Kill ^DHCEPRFS.INST.DirMasterD
	Kill ^DHCEPRFS.INST.DirMasterI
	Kill ^DHCEPRFS.INST.FileMasterD
	Kill ^DHCEPRFS.INST.FileMasterI
	Kill ^DHCEPRFS.INST.FileTemporaryD
	Kill ^DHCEPRFS.INST.FileTemporaryI
	Kill ^DHCEPRFS.INST.IDScanD
	Kill ^DHCEPRFS.INST.IDScanI
	Kill ^DHCEPRFS.INST.InputMedLogD
	Kill ^DHCEPRFS.INST.InputMedLogI
	Kill ^DHCEPRFS.INST.MREpisodeD
	Kill ^DHCEPRFS.INST.MREpisodeI
	Kill ^DHCEPRFS.INST.MREpisodeFPD
	Kill ^DHCEPRFS.INST.MREpisodeFPI
	Kill ^DHCEPRFS.INST.MREpisodeFeeD
	Kill ^DHCEPRFS.INST.MREpisodeFeeI
	Kill ^DHCEPRFS.INST.MREpisodePatD
	Kill ^DHCEPRFS.INST.MREpisodePatI
	Kill ^DHCEPRFS.INST.MREpisodeRelateD
	Kill ^DHCEPRFS.INST.MREpisodeRelateI
	Kill ^DHCEPRFS.INST.MRLogD
	Kill ^DHCEPRFS.INST.MRLogI
	Kill ^DHCEPRFS.INST.MRLogDetailI
	Kill ^DHCEPRFS.INST.MRLogDetailSubD
	Kill ^DHCEPRFS.INST.MRLogDetailSubI
	Kill ^DHCEPRFS.INST.MRLogDtlFSubD
	Kill ^DHCEPRFS.INST.MRLogDtlFSubI
	Kill ^DHCEPRFS.INST.MRLogDtlFinalD
	Kill ^DHCEPRFS.INST.MRLogDtlFinalI
	Kill ^DHCEPRFS.INST.MRLogViewD
	Kill ^DHCEPRFS.INST.MRLogViewI
	Kill ^DHCEPRFS.INST.MRMedRecordD
	Kill ^DHCEPRFS.INST.MRMedRecordI
	Kill ^DHCEPRFS.INST.MRPatientD
	Kill ^DHCEPRFS.INST.MRPatientI
	Kill ^DHCEPRFS.INST.MRPrintChargeC
	Kill ^DHCEPRFS.INST.MRPrintChargeD
	Kill ^DHCEPRFS.INST.MRPrintChargeDetI
	Kill ^DHCEPRFS.INST.MRPrintChargeI
	Kill ^DHCEPRFS.INST.MRPrintChrgLogD
	Kill ^DHCEPRFS.INST.MRPrintChrgLogI
	Kill ^DHCEPRFS.INST.MRPrintInvoiceD
	Kill ^DHCEPRFS.INST.MRPrintInvoiceI
	Kill ^DHCEPRFS.INST.MRPrintListFeeD
	Kill ^DHCEPRFS.INST.MRPrintListFeeI
	Kill ^DHCEPRFS.INST.MRPrintListItemD
	Kill ^DHCEPRFS.INST.MRPrintListItemI
	Kill ^DHCEPRFS.INST.MRPrintListRecD
	Kill ^DHCEPRFS.INST.MRPrintListRecI
	Kill ^DHCEPRFS.INST.MRSealUpD
	Kill ^DHCEPRFS.INST.MRSealUpI
	Kill ^DHCEPRFS.INST.MRVerItemD
	Kill ^DHCEPRFS.INST.MRVerItemI
	Kill ^DHCEPRFS.INST.MRVerItemDetailI
	Kill ^DHCEPRFS.INST.MRVersionD
	Kill ^DHCEPRFS.INST.MRVersionI
	Kill ^DHCEPRFS.INST.MetaLCManageLogD
	Kill ^DHCEPRFS.INST.MetaLCManageLogI
	Kill ^DHCEPRFS.INST.PrintInfoD
	Kill ^DHCEPRFS.INST.PrintInfoI
	Kill ^DHCEPRFS.INST.PrintSchemeLogD
	Kill ^DHCEPRFS.INST.ScanArrangeD
	Kill ^DHCEPRFS.INST.ScanArrangeI
	Kill ^DHCEPRFS.INST.ScanArrangeSubD
	Kill ^DHCEPRFS.INST.ScanArrangeSubI
	
	//清电子病历归档RBAC业务数据
	Kill ^DHCEPRRBAC.INST.ASecurityLD
	Kill ^DHCEPRRBAC.INST.ASecurityLI
	Kill ^DHCEPRRBAC.INST.DefaultRoleD
	Kill ^DHCEPRRBAC.INST.DefaultRoleI
	Kill ^DHCEPRRBAC.INST.FavorD
	Kill ^DHCEPRRBAC.INST.FavorI
	Kill ^DHCEPRRBAC.INST.FavorCatD
	Kill ^DHCEPRRBAC.INST.FavorCatI
	Kill ^DHCEPRRBAC.INST.FSAuthD
	Kill ^DHCEPRRBAC.INST.FSAuthI
	Kill ^DHCEPRRBAC.INST.FSAuthGD
	Kill ^DHCEPRRBAC.INST.FSAuthGI
	Kill ^DHCEPRRBAC.INST.LogD
	Kill ^DHCEPRRBAC.INST.LogI
	Kill ^DHCEPRRBAC.INST.ResourceItemD
	Kill ^DHCEPRRBAC.INST.ResourceItemI
	Kill ^DHCEPRRBAC.INST.ResourceRItemD
	Kill ^DHCEPRRBAC.INST.ResourceRItemI
	Kill ^DHCEPRRBAC.META.ASecurityD
	Kill ^DHCEPRRBAC.META.ASecurityI
	
	//清全文检索业务数据
	Kill ^DHCEPRSearch.INST.WordDicLogD
	Kill ^DHCEPRSearch.INST.WordDicLogD
	Kill ^DHCEPRSearch.INST.ExportQueryD
	Kill ^DHCEPRSearch.INST.ExportQueryI
	Kill ^DHCEPRSearch.INST.FavoritesD
	Kill ^DHCEPRSearch.INST.FavoritesI
	Kill ^DHCEPRSearch.INST.FavCateD
	Kill ^DHCEPRSearch.INST.FavCateI
	Kill ^DHCEPRSearch.INST.SearchQueueD
	Kill ^DHCEPRSearch.INST.SearchQueueI
	Kill ^DHCEPRSearch.INST.SearchSucD
	Kill ^DHCEPRSearch.INST.SearchSucI
}

/// Creator：     zhangenbin
/// CreatDate：   2020-09-07
/// Description:  归档系统清理基础数据方法（上线前清理部分标准版垃圾数据）
/// Input：  AFlag 是否删除数据标志，只有是Y才会删除数据     
/// d ##class(DHCEPRFS.Tool.ClearData).KillMetaData("Y")
ClassMethod KillMetaData(AFlag As %String) As %String
{
	q:(AFlag'="Y") "0"
	
	//清电子病历归档基础数据
	Kill ^DHCEPRFS.META.B.DepartmentD
	Kill ^DHCEPRFS.META.B.DepartmentI
	Kill ^DHCEPRFS.META.B.HospitalAreaD
	Kill ^DHCEPRFS.META.B.HospitalAreaI
	Kill ^DHCEPRFS.META.B.MarriageD
	Kill ^DHCEPRFS.META.B.MarriageI
	Kill ^DHCEPRFS.META.B.ProvinceD
	Kill ^DHCEPRFS.META.B.ProvinceI
	Kill ^DHCEPRFS.META.ASTypeD
	Kill ^DHCEPRFS.META.ASTypeI
	Kill ^DHCEPRFS.META.BoxD
	Kill ^DHCEPRFS.META.BoxI
	Kill ^DHCEPRFS.META.ConfigMetaLCD
	Kill ^DHCEPRFS.META.ConfigMetaLCI
	Kill ^DHCEPRFS.META.ConfigMetaTableD
	Kill ^DHCEPRFS.META.ConfigMetaTableI
	Kill ^DHCEPRFS.META.CreateServerD
	Kill ^DHCEPRFS.META.CreateServerI
	Kill ^DHCEPRFS.META.CreateServersD
	Kill ^DHCEPRFS.META.CreateServersI
	Kill ^DHCEPRFS.META.CTFunctionD
	Kill ^DHCEPRFS.META.CTFunctionI
	Kill ^DHCEPRFS.META.CTItemInvokeD
	Kill ^DHCEPRFS.META.CTItemInvokeI
	Kill ^DHCEPRFS.META.CTItemTypeD
	Kill ^DHCEPRFS.META.CTItemTypeI
	Kill ^DHCEPRFS.META.CTSchemeTypeD
	Kill ^DHCEPRFS.META.CTSchemeTypeI
	Kill ^DHCEPRFS.META.CTSourceD
	Kill ^DHCEPRFS.META.CTSourceI
	Kill ^DHCEPRFS.META.CTTaskTypeD
	Kill ^DHCEPRFS.META.CTTaskTypeI
	Kill ^DHCEPRFS.META.CustomDicD
	Kill ^DHCEPRFS.META.CustomDicI
	Kill ^DHCEPRFS.META.DepartmentFuncD
	Kill ^DHCEPRFS.META.DepartmentFuncI
	Kill ^DHCEPRFS.META.EstimatePageD
	Kill ^DHCEPRFS.META.EstimatePageI
	Kill ^DHCEPRFS.META.FileStoreConfigD
	Kill ^DHCEPRFS.META.FileStoreConfigI
	Kill ^DHCEPRFS.META.FilterQueryItemD
	Kill ^DHCEPRFS.META.FilterQueryItemI
	Kill ^DHCEPRFS.META.HistoryMPRD
	Kill ^DHCEPRFS.META.HistoryMPRI
	Kill ^DHCEPRFS.META.ImportSortMPD
	Kill ^DHCEPRFS.META.ImportSortMPI
	Kill ^DHCEPRFS.META.ItemCorrelationD
	Kill ^DHCEPRFS.META.ItemCorrelationI
	Kill ^DHCEPRFS.META.LateToCreateD
	Kill ^DHCEPRFS.META.LateToCreateI
	Kill ^DHCEPRFS.META.MRActionD
	Kill ^DHCEPRFS.META.MRActionI
	Kill ^DHCEPRFS.META.MRCategoryD
	Kill ^DHCEPRFS.META.MRCategoryI
	Kill ^DHCEPRFS.META.MRChargeTypeD
	Kill ^DHCEPRFS.META.MRChargeTypeI
	Kill ^DHCEPRFS.META.MRItemD
	Kill ^DHCEPRFS.META.MRItemI
	Kill ^DHCEPRFS.META.MRStatusD
	Kill ^DHCEPRFS.META.MRStatusI
	Kill ^DHCEPRFS.META.MRSubCategoryD
	Kill ^DHCEPRFS.META.MRSubCategoryI
	Kill ^DHCEPRFS.META.MRTransitionD
	Kill ^DHCEPRFS.META.MRTransitionI
	Kill ^DHCEPRFS.META.MRTransPageD
	Kill ^DHCEPRFS.META.MRTransPageI
	Kill ^DHCEPRFS.META.PrintItemCorD
	Kill ^DHCEPRFS.META.PrintItemCorI
	Kill ^DHCEPRFS.META.PrintPageInfoD
	Kill ^DHCEPRFS.META.PrintPageInfoI
	Kill ^DHCEPRFS.META.PrintReceiptD
	Kill ^DHCEPRFS.META.PrintReceiptI
	Kill ^DHCEPRFS.META.PrintReceiptS
	Kill ^DHCEPRFS.META.PrintRecipiFA59D
	Kill ^DHCEPRFS.META.PrintRecipiFA59I
	Kill ^DHCEPRFS.META.PrintSchemeD
	Kill ^DHCEPRFS.META.PrintSchemeI
	Kill ^DHCEPRFS.META.PrintSchemeLocD
	Kill ^DHCEPRFS.META.PrintSchemeLocI
	Kill ^DHCEPRFS.META.QAEPRD
	Kill ^DHCEPRFS.META.QAEPRI
	Kill ^DHCEPRFS.META.QRCodeInfoD
	Kill ^DHCEPRFS.META.QRCodeInfoI
	Kill ^DHCEPRFS.META.QueryCategoryD
	Kill ^DHCEPRFS.META.QueryCategoryI
	Kill ^DHCEPRFS.META.QueryFieldsD
	Kill ^DHCEPRFS.META.QueryFieldsI
	Kill ^DHCEPRFS.META.QueryFunctionD
	Kill ^DHCEPRFS.META.QueryFunctionI
	Kill ^DHCEPRFS.META.QueryRoleD
	Kill ^DHCEPRFS.META.QueryRoleI
	Kill ^DHCEPRFS.META.QueryRoleFunD
	Kill ^DHCEPRFS.META.QueryRoleFunI
	Kill ^DHCEPRFS.META.QueryRoleFunSEQD
	Kill ^DHCEPRFS.META.QueryRoleFunSEQI
	Kill ^DHCEPRFS.META.QueryUserD
	Kill ^DHCEPRFS.META.QueryUserI
	Kill ^DHCEPRFS.META.QueryUserCateD
	Kill ^DHCEPRFS.META.QueryUserCateI
	Kill ^DHCEPRFS.META.QueryUserCateDtD
	Kill ^DHCEPRFS.META.QueryUserCateDtI
	Kill ^DHCEPRFS.META.QueryUserDateD
	Kill ^DHCEPRFS.META.QueryUserDateI
	Kill ^DHCEPRFS.META.QueryUserGroupD
	Kill ^DHCEPRFS.META.QueryUserGroupI
	Kill ^DHCEPRFS.META.QueryUserLocD
	Kill ^DHCEPRFS.META.QueryUserLocI
	Kill ^DHCEPRFS.META.QueryUserMedNoD
	Kill ^DHCEPRFS.META.QueryUserMedNoI
	Kill ^DHCEPRFS.META.QueryUserMedRcdD
	Kill ^DHCEPRFS.META.QueryUserMedRcdI
	Kill ^DHCEPRFS.META.QueryUserRoleD
	Kill ^DHCEPRFS.META.QueryUserRoleI
	Kill ^DHCEPRFS.META.RecordCheckD
	Kill ^DHCEPRFS.META.RecordCheckI
	Kill ^DHCEPRFS.META.ResourceDisDateD
	Kill ^DHCEPRFS.META.ResourceDisDateI
	Kill ^DHCEPRFS.META.ResourceFuncD
	Kill ^DHCEPRFS.META.ResourceFuncI
	Kill ^DHCEPRFS.META.ResourceLocD
	Kill ^DHCEPRFS.META.ResourceLocI
	Kill ^DHCEPRFS.META.ResourceMRItemD
	Kill ^DHCEPRFS.META.ResourceMRItemI
	Kill ^DHCEPRFS.META.ResourceOperaD
	Kill ^DHCEPRFS.META.ResourceOperaI
	Kill ^DHCEPRFS.META.ResourceTypeD
	Kill ^DHCEPRFS.META.ResourceTypeI
	Kill ^DHCEPRFS.META.ResultColumnD
	Kill ^DHCEPRFS.META.ResultColumnI
	Kill ^DHCEPRFS.META.RoleFunctionD
	Kill ^DHCEPRFS.META.RoleFunctionI
	Kill ^DHCEPRFS.META.ServerDiskD
	Kill ^DHCEPRFS.META.ServerDiskI
	Kill ^DHCEPRFS.META.SuperUserD
	Kill ^DHCEPRFS.META.SuperUserI
	Kill ^DHCEPRFS.META.SysOptionD
	Kill ^DHCEPRFS.META.SysOptionI
	Kill ^DHCEPRFS.META.UserRoleD
	Kill ^DHCEPRFS.META.UserRoleI
	Kill ^DHCEPRFS.META.VersionCodeD
	Kill ^DHCEPRFS.META.VersionCodeI
	Kill ^DHCEPRFS.META.WatermarkSchemeD
	Kill ^DHCEPRFS.META.WatermarkSchemeI
	
	//清全文检索基础数据
	Kill ^DHCEPRSearch.META.CtmWordDicD
	Kill ^DHCEPRSearch.META.CtmWordDicI
	Kill ^DHCEPRSearch.META.FilterQueryD
	Kill ^DHCEPRSearch.META.FilterQueryI
	Kill ^DHCEPRSearch.META.FQCategoryD
	Kill ^DHCEPRSearch.META.FQCategoryI
	Kill ^DHCEPRSearch.META.FQSubCateD
	Kill ^DHCEPRSearch.META.FQSubCateI
	Kill ^DHCEPRSearch.META.SystemOptionD
	Kill ^DHCEPRSearch.META.SystemOptionI
}

}
