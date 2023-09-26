Class web.PMP.KillPMP Extends %Persistent
{

/// Creat  zzp
/// date:2015-05-21
/// description: 清除项目质量管理业务数据 
/// input:  InPut（""为只清业务数据，"AllFull"为清除全部数据,"All"为清除业务数+配置数据）
/// output: 0:失败;业务OK:业务数据清除完成;全部OK:全部数据清除完毕;
/// others: w ##class(web.PMP.KillPMP).KillPMP("")
ClassMethod KillPMP(InPut As %String) As %String
{
	s ret="0"
	i InPut="All"  d
	.K ^PMPCompany,^PMPCompanyi,^PMPContract,^PMPContractAging,^PMPContractAgingMode,^PMPContractAgingModei,^PMPContractAgingi,^PMPContractDetails,^PMPContractDetailsi
	.K ^PMPContractMode,^PMPContractModei,^PMPContracti,^PMPDevelop,^PMPDevelopAppraisal,^PMPDevelopImprovement,^PMPDocument,^PMPDocumentReceive,^PMPDocumentReceivei
	.K ^PMPDocumenti,^PMPDownloads,^PMPDownloadsi,^PMPImproveAdjuncti,^PMPImprovementAdjunct,^PMPImprovementAppraisal,^PMPImprovementDetail,^PMPImprovementDetaili,^DHCPMComRecordi
	.K ^PMPImprovementList,^PMPImprovementListi,^PMPImprovementRevList,^PMPImprovementRevListi,^PMPImprovmentRevList,^PMPJobLogging,^PMPJobLogi,^PMPModuleUser,^PMPModuleUseri
	.K ^PMPOperatingRecord,^PMPOperatingRecordi,^PMPPermisBusiness,^PMPPermisBusinessi,^PMPPermission,^PMPPermissioni,^PMPProduct,^PMPProducti,^PMPProject,^PMPProjectPlan
	.K ^PMPProjectPlanUser,^PMPProjectPlani,^PMPProjectUser,^PMPProjectUseri,^PMPProjecti,^PMPStatusButton,^PMPStatusButtoni,^PMPUserTel,^PMPUserTelI,^PMPUserTeli,^DHCPMComRecord
	.S ^User.PMPCompany=0,^User.PMPContract=0,^User.PMPContractAging=0,^User.PMPContractMode=0,^User.PMPDevelop=0,^User.PMPDocument=0,^User.PMPDownloads=0
	.S ^User.PMPImprovementAdjunct=0,^User.PMPImprovementList=0,^User.PMPJobLogging=0,^User.PMPModuleUser=0,^User.PMPOperatingRecord=0,^User.PMPPermission=0,^User.PMPProduct=0,^User.PMPProjectPlan=0
	.s ret="业务+配置Ok！"
    i InPut="AllFull"  d
    .k ^PMPCompany,^PMPContractAging,^PMPContractAging,^PMPDownloads,^PMPDownloadsi,^PMPDocumentReceive,^PMPDocumentReceivei,^PMPContractAgingi,^PMPContractMode,^PMPDevelop,^PMPImproveAdjuncti,^PMPImprovementDetail,^PMPImprovementListi,^PMPImprovmentRevList
	.k ^PMPModuleUser,^PMPOperatingRecord,^PMPPermisBusinessi,^PMPProduct,^PMPProjectPlan,^PMPProjectUseri,^PMPStatusButtoni,^PMPUserTelI,^DHCPMComRecord,^DHCPMComRecordi,^DHCPMComRecord,^DHCPMComRecordi
	.k ^PMPCompanyi,^PMPContractAgingMode,^PMPContractDetails,^PMPContractModei,^PMPDevelopAppraisal,^PMPImprovementAdjunct,^PMPImprovementDetaili,^PMPImprovementRevList,^DHCPMComRecord,^DHCPMComRecordi
	.k ^PMPJobLogging,^PMPModuleUseri,^PMPOperatingRecordi,^PMPPermission,^PMPProducti,^PMPProjectPlani,^PMPProjecti,^PMPUserTeli,^PMPContract,^PMPContractAgingModei,^PMPContractDetailsi,^PMPContracti
	.k ^PMPDevelopImprovement,^PMPImprovementAppraisal,^PMPImprovementList,^PMPImprovementRevListi,^PMPJobLogi,^PMPPermisBusiness,^PMPPermissioni,^PMPProject,^PMPProjectUser,^PMPStatusButton,^PMPUserTel,^TempPMPTypeNum
	.s ^User.PMPContractMode=0,^User.PMPImprovementAdjunct=0,^User.PMPPermission=0,^User.PMPContract=0,^User.PMPDevelop=0,^User.PMPImprovementList=0,^User.PMPModuleUser=0,^User.PMPProduct=0
	.s ^User.PMPContractAging=0,^User.PMPJobLogging=0,^User.PMPOperatingRecord=0,^User.PMPProjectPlan=0,^User.PMPDownloads=0,^User.PMPDocumentReceive=0
    .k ^PMPDictionary,^PMPModule,^PMPModuleDetail,^PMPModulei,^PMPModuleDetaili,^DHCPM.SS.SecurityD,^DHCPM.SS.SecurityI
    .s ^User.PMPModule=0
    .s ret="全部OK！"
    i InPut=""  d
    .K ^PMPContract,^PMPContractAging,^PMPContractAgingMode,^PMPContractAgingModei,^PMPContractAgingi,^PMPContractDetails,^PMPContractDetailsi
	.K ^PMPContractMode,^PMPContractModei,^PMPContracti,^PMPDevelop,^PMPDevelopAppraisal,^PMPDevelopImprovement,^PMPDocument,^PMPDocumentReceive,^PMPDocumentReceivei
	.K ^PMPDocumenti,^PMPDownloads,^PMPDownloadsi,^PMPImproveAdjuncti,^PMPImprovementAdjunct,^PMPImprovementAppraisal,^PMPImprovementDetail,^PMPImprovementDetaili,^DHCPMComRecordi
	.K ^PMPImprovementList,^PMPImprovementListi,^PMPImprovementRevList,^PMPImprovementRevListi,^PMPImprovmentRevList,^PMPJobLogging,^PMPJobLogi
	.K ^PMPProjectPlan,^PMPProjectPlanUser,^PMPProjectPlani,^PMPStatusButton,^PMPStatusButtoni,^DHCPMComRecord
	.S ^User.PMPContract=0,^User.PMPContractAging=0,^User.PMPContractMode=0,^User.PMPDevelop=0,^User.PMPDocument=0,^User.PMPDownloads=0
	.S ^User.PMPImprovementAdjunct=0,^User.PMPImprovementList=0,^User.PMPJobLogging=0,^User.PMPProduct=0,^User.PMPProjectPlan=0
    .s ret="业务Ok！"
    q ret
}

Storage Default
{
<Data name="KillPMPDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.PMP.KillPMPD</DataLocation>
<DefaultData>KillPMPDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.PMP.KillPMPD</IdLocation>
<IndexLocation>^web.PMP.KillPMPI</IndexLocation>
<StreamLocation>^web.PMP.KillPMPS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
