Class web.DHCEQ.Plat.CTManufacturer Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 创建:zx 2018-12-11
/// 目的:系统自动录入生产厂商
/// 描述:检测生产厂商表是否存在当前数据.是则返回RowID,否则新增记录并返回RowID
/// 输入: Data:生产厂商
/// 输出: 无
/// 返回值: 成功返回RowID, 失败返回错误代码
/// w ##Class(web.DHCEQ.Plat.CTManufacturer).UpdManufacturer("测试数据")
ClassMethod UpdManufacturer(Data)
{
	n MFRowID,ManufacturerOperMethod,Manufacturer,Code,Desc
	s (MFRowID,Code)=""
	s Desc=$ZCONVERT(Data,"U")
	s CodeInfo=##class(web.DHCEQ.Plat.CTCHanZiEncoding).GetEncoding(Desc,4,"","U")
	s CodeInfo=##class(web.DHCEQ.Plat.JsonObject).FromJSON(CodeInfo)	//CZF0131 2020-01-20
	i CodeInfo.%Get("SQLCODE")=0 s Code=CodeInfo.%Get("Data")
	s FirmType=3		//modified by CZF0093 begin
	s SQLCODE=0
	s ManufacturerOperMethod=##class(web.DHCEQCommon).GetSysInfo("201005")
	if (ManufacturerOperMethod=0)||(Desc="") q ""
	//&SQL(Select MF_RowID Into:MFRowID from SQLUSER.DHC_EQCManufacturer Where MF_InvalidFlag='N' and MF_Name=:Desc)
	&SQL(Select V_RowID Into:MFRowID from SQLUSER.DHC_EQCVendor Where V_InvalidFlag='N' and V_Name=:Desc and V_Hold3=:FirmType)
	if MFRowID="" //新增当前生产厂商
	{
		&SQL(Insert Into SQLUSER.DHC_EQCVendor(V_Code,V_Name,V_ShName,V_InvalidFlag,V_Hold3) Values(:Code,:Desc,:Desc,'N',:FirmType))	//modified by CZF0093 end
		if SQLCODE
		{
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
		s MFRowID=$G(%ROWID)
	}
	/*
	if MFRowID="" //新增当前生产厂商
	{
		&SQL(Insert Into SQLUSER.DHC_EQCManufacturer(MF_Code,MF_Name,MF_ShName,MF_InvalidFlag) Values(:Code,:Desc,:Desc,'N'))
		if SQLCODE
		{
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
		s MFRowID=$G(%ROWID)
	}
	*/
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,MFRowID)
}

}
