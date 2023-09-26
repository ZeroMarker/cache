Class EMRservice.Tools.StandardPublishOption Extends %RegisteredObject
{

/// d ##class(EMRservice.Tools.StandardPublishOption).ModifyStandardPublishOption()
ClassMethod ModifyStandardPublishOption()
{
	
	//系统参数表变更内容
	
	
	//查看数据sql
	// select Name,OptionValue from EMRmeta.SysOption where Name 
	// in ("LevelSource","ENABLE_PASTE_LIMIT","FIXED_STRUCTS_ELEMENT_BGCOLOR","IsDisplayAllPersonalKBNode",
	// "IsRevokeSign","MedicalRecordDocID","Observer","RequestReasonLimitStr","RequestReasonRequiredStr",
	// "SignType","SignTypeInP")
	///更新数据
	
	
	//发布启用HIS医师权限
	&sql(update EMRmeta.SysOption set OptionValue = "HIS"  where Name= "LevelSource" )
	//查看医师级别对照
	//EMRmeta.SignRoleLinkCarPrvTp
	//CT_CarPrvTp
	//当前数据验证，查看sql
	//SELECT a.CarPrvTpCode,a.SignRoleCode,b.CTCPT_Desc,b.CTCPT_InternalType FROM EMRmeta.SignRoleLinkCarPrvTp a
	//JOIN CT_CarPrvTp b ON a.CarPrvTpCode = b.CTCPT_Code


	
	&sql(update EMRmeta.SysOption set OptionValue = "Y"  where Name= "ENABLE_PASTE_LIMIT" )
	
	&sql(update EMRmeta.SysOption set OptionValue = "#C0C0C0"  where Name= "FIXED_STRUCTS_ELEMENT_BGCOLOR" )
	
	&sql(update EMRmeta.SysOption set OptionValue = "Y"  where Name= "IsDisplayAllPersonalKBNode" )
	
	&sql(update EMRmeta.SysOption set OptionValue = "Y"  where Name= "IsRevokeSign" )
	
	&sql(update EMRmeta.SysOption set OptionValue = "52"  where Name= "MedicalRecordDocID" )
	
	&sql(update EMRmeta.SysOption set OptionValue = "N"  where Name= "Observer" )
	
	&sql(update EMRmeta.SysOption set OptionValue = "10^10^10"  where Name= "RequestReasonLimitStr" )
	
	&sql(update EMRmeta.SysOption set OptionValue = "Y^Y^Y^Y"  where Name= "RequestReasonRequiredStr" )
	
	&sql(update EMRmeta.SysOption set OptionValue = "Text"  where Name= "SignType" )
	
	&sql(update EMRmeta.SysOption set OptionValue = "Text"  where Name= "SignTypeInP" )
	
	
	
	///SystemParamter变更内容
	///1.失效签名的级别 
	///GetRevokeStatusall -sup
	///保存验证
	///2.IsEnableMultiEditSaveCheck N->Y
}

}
