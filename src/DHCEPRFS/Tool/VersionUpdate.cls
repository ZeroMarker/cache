Class DHCEPRFS.Tool.VersionUpdate Extends %RegisteredObject [ ProcedureBlock ]
{

/// Debug: d ##class(DHCEPRFS.Tool.VersionUpdate).Update("2017.9.1")
ClassMethod Update(AVersion As %String, ABreak As %String = "N")
{
	s ret = ..Check(AVersion,"2017.2.1")
	if (ret = 1)
	{
		d ..UpdateToV2017V2V1()
		w !,"后台更新到Version 2017.2.1成功"	
		s AVersion = "2017.2.1"
		d ..UpdateVersion("Version 2017.2.1")
	}
	
	if (ABreak = "Y")
	{
		b "2017.2.1"	
	}
	
	s ret = ..Check(AVersion,"2017.2.2")
	if (ret = 1)
	{
		d ..UpdateToV2017V2V2()
		w !,"后台更新到Version 2017.2.2成功"	
		s AVersion = "2017.2.2"
		d ..UpdateVersion("Version 2017.2.2")
	}
	
	if (ABreak = "Y")
	{
		b "2017.2.2"	
	}
	
	s ret = ..Check(AVersion,"2017.4.1")
	if (ret = 1)
	{
		d ..UpdateToV2017V4V1()
		w !,"后台更新到Version 2017.4.1成功"	
		s AVersion = "2017.4.1"
		d ..UpdateVersion("Version 2017.4.1")
	}
	
	if (ABreak = "Y")
	{
		b "2017.4.1"	
	}
	
	s ret = ..Check(AVersion,"2017.6.1")
	if (ret = 1)
	{
		d ..UpdateToV2017V6V1()
		w !,"后台更新到Version 2017.6.1成功"	
		s AVersion = "2017.6.1"
		d ..UpdateVersion("Version 2017.6.1")
	}
	
	if (ABreak = "Y")
	{
		b "2017.6.1"	
	}
	
	s ret = ..Check(AVersion,"2017.7.1")
	if (ret = 1)
	{
		d ..UpdateToV2017V7V1()
		w !,"后台更新到Version 2017.7.1成功"	
		s AVersion = "2017.7.1"
		d ..UpdateVersion("Version 2017.7.1")
	}
	
	if (ABreak = "Y")
	{
		b "2017.7.1"	
	}
	
	s ret = ..Check(AVersion,"2017.7.2")
	if (ret = 1)
	{
		w !,"后台更新到Version 2017.7.2成功"	
		s AVersion = "2017.7.2"
		d ..UpdateVersion("Version 2017.7.2")
	}
	
	if (ABreak = "Y")
	{
		b "2017.7.2"	
	}
			
	s ret = ..Check(AVersion,"2017.9.1")
	if (ret = 1)
	{
		d ..UpdateToV2017V9V1()
		w !,"后台更新到Version 2017.9.1成功"	
		s AVersion = "2017.9.1"
		d ..UpdateVersion("Version 2017.9.1")
	}

	if (ABreak = "Y")
	{
		b "2017.9.1"	
	}
			
	
	s ret = ..Check(AVersion,"2017.10.1")
	if (ret = 1)
	{
		d ..UpdateToV2017V10V1()
		w !,"后台更新到Version 2017.10.1成功"	
		s AVersion = "2017.10.1"
		d ..UpdateVersion("Version 2017.10.1")
	}

	if (ABreak = "Y")
	{
		b "2017.10.1"	
	}
	
	s ret = ..Check(AVersion,"2018.1.1")
	if (ret = 1)
	{
		d ..UpdateToV2018V1V1()
		w !,"后台更新到Version 2018.1.1成功"	
		s AVersion = "2018.1.1"
		d ..UpdateVersion("Version 2018.1.1")
	}

	if (ABreak = "Y")
	{
		b "2018.1.1"	
	}
	
	s ret = ..Check(AVersion,"2018.3.1")
	if (ret = 1)
	{
		d ..UpdateToV2018V3V1()
		w !,"后台更新到Version 2018.3.1成功"	
		s AVersion = "2018.3.1"
		d ..UpdateVersion("Version 2018.3.1")
	}

	if (ABreak = "Y")
	{
		b "2018.3.1"	
	}
			
	/*	
	s ret = ..Check(AVersion,"2018.3.1")
	if (ret = 1)
	{
		d ..UpdateToV2018V3V1()
		w !,"后台更新到Version 2018.3.1成功"	
		s AVersion = "2018.3.1"
		d ..UpdateVersion("Version 2018.3.1")
	}

	if (ABreak = "Y")
	{
		b "2018.3.1"	
	}
	*/
}

ClassMethod UpdateVersion(AVersion)
{
    s rowid = ""
	&sql(select ID into :rowid from DHCEPRFS_META.SysOption
		where OptionName = 'Version')
	w !,rowid
	if (rowid = "")
	{
		&sql(insert into DHCEPRFS_META.SysOption (OptionName, OptionValue, OptionDesc, OptionType) 
			values ('Version', :AVersion, '电子病历归档管理程序版本号','base'))
	}
	else
	{
		&sql(update DHCEPRFS_META.SysOption set OptionValue = :AVersion where OptionName = 'Version')
	}
}

ClassMethod Check(AVersion1, AVersion2)
{
	if ((+$p(AVersion1,".",1)) < (+$p(AVersion2,".",1)))
	{
		q "1"	
	}	
	
	if ((+$p(AVersion1,".",1)) = (+$p(AVersion2,".",1))) 
	{
		if ((+$p(AVersion1,".",2)) < (+$p(AVersion2,".",2)))
		{
			q "1"	
		}
		
		if ((+$p(AVersion1,".",2)) = (+$p(AVersion2,".",2))) 
		{
			if ((+$p(AVersion1,".",3)) < (+$p(AVersion2,".",3)))
			{
				q "1"	
			}
		}
	}
	
	q "0"
}

ClassMethod UpdateToV2017V2V1()
{
	//---------------------------------------------------------
	//改变的基础数据
	d ##class(DHCEPRFS.Tool.VersionUpdate).SysOpV2017V2V1()
	
	//---------------------------------------------------------
	//改变索引
	d ##class(DHCEPRFS.INST.InputMedLog).%BuildIndices()
	
	//---------------------------------------------------------
	//改变数据
	d ##class(DHCEPRFS.Tool.UpdateData).UpdateInputMVE()
}

ClassMethod UpdateToV2017V2V2()
{
	//---------------------------------------------------------
	//改变的基础数据
	d ##class(DHCEPRFS.Tool.VersionUpdate).SysOpV2017V2V2()
	//增加综合查询结果列、查询字段、查询分类
	d ##Class(DHCEPRFS.Tool.UpdateData).AddResultColumn()
	//---------------------------------------------------------
	//改变索引
	
	//---------------------------------------------------------
	//改变数据
}

ClassMethod UpdateToV2017V4V1()
{
	//---------------------------------------------------------
	//改变的基础数据
	d ##class(DHCEPRFS.Tool.VersionUpdate).SysOpV2017V4V1()

	//---------------------------------------------------------
	//改变索引
	d ##class(DHCEPRFS.INST.MRLogDetail).%BuildIndices()  
	d ##class(DHCEPRFS.INST.EstimatePagesLog).%BuildIndices()  
	d ##class(DHCEPRRBAC.INST.FSAuthorizationGroup).%BuildIndices()  
	//---------------------------------------------------------
	//改变数据
}

ClassMethod UpdateToV2017V6V1()
{
	//---------------------------------------------------------
	//改变的基础数据
	d ##class(DHCEPRFS.Tool.VersionUpdate).SysOpV2017V6V1()

	//---------------------------------------------------------
	//改变索引
	d ##class(DHCEPRFS.INST.CheckedRetList).%BuildIndices()  

	//---------------------------------------------------------
	//改变数据
	d ##class(DHCEPRFS.Tool.UpdateData).UpdateMetaLCFields()
	
	s parentID = ""
	&sql(select ID into :parentID from DHCEPRFS_META.QueryFunction where FuncName = 'Menu_Enable')
	s rowid = ""
	&sql(select ID into :rowid from DHCEPRFS_META.QueryFunction where FuncName = 'Menu_Enable_QueryExportLog')
	if (rowid = "")
	{
		&sql(insert into DHCEPRFS_META.QueryFunction (FuncName,FuncDesc,ParentID,Notes) values ('Menu_Enable_QueryExportLog', '病历导出日志', :parentID, ''))
	}
}

/// Debug: d ##Class(DHCEPRFS.Tool.VersionUpdate).UpdateToV2017V7V1()
ClassMethod UpdateToV2017V7V1()
{
	//---------------------------------------------------------
	//改变的基础数据
	d ##class(DHCEPRFS.Tool.VersionUpdate).SysOpV2017V7V1()

	//---------------------------------------------------------
	//改变索引

	//---------------------------------------------------------
	//改变数据
	s parentID = ""
	&sql(select ID into :parentID from DHCEPRFS_META.QueryFunction where FuncName = 'Menu_Operation')
	s rowid = ""
	&sql(select ID into :rowid from DHCEPRFS_META.QueryFunction where FuncName = 'Menu_Operation_Create')
	if (rowid = "")
	{
		&sql(insert into DHCEPRFS_META.QueryFunction (FuncName,FuncDesc,ParentID,Notes) values ('Menu_Operation_Create', '队列查看可直接生成', :parentID, ''))
	}
	
	d ##class(DHCEPRFS.Tool.UpdateData).UpdateConfigMetaLC()
	
	d ##Class(DHCEPRFS.Tool.BaseDataMgr).InitCTItemInvokeType()
	
	d ##Class(DHCEPRFS.Tool.BaseDataMgr).InitCTItemType()
	
	s hospitalFlag = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("HospitalFlag")
	s anesthesiaFtpConfig = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("AnesthesiaFTPConfig")
	s pisFtpConfig = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("PISFTPConfig")
	s ekgFtpConfig = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("EKGFTPConfig")
	
	
	if (hospitalFlag ="QYFY")
	{
		s CG08Folder = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("CG08Folder")
		s CG18Folder = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("CG18Folder")
		s CG81Folder = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("CG81Folder")

		s sc = $$UpdateCTItemType("08","麻醉记录","麻醉记录","DHCANOneStepPrint.csp","8",anesthesiaFtpConfig,"CG08",CG08Folder,"01","CREATETYPEFTP","东华软件","临床组","ANESTHESIA")
		s sc = $$UpdateCTItemType("18","麻醉记录","麻醉记录","DHCANOneStepPrint.csp","18",anesthesiaFtpConfig,"CG18",CG18Folder,"01","CREATETYPEFTP","东华软件","临床组","ANESTHESIA")
		s sc = $$UpdateCTItemType("81","麻醉记录","麻醉记录","DHCANOneStepPrint.csp","81",anesthesiaFtpConfig,"CG81",CG81Folder,"01","CREATETYPEFTP","东华软件","临床组","ANESTHESIA")
		
		s sc = $$UpdateCTItemType("10","心电图","心电图","DHCRISReport.PrintCentral.csp","10",ekgFtpConfig,"CG10","","01","CREATETYPEFTP","东华软件","心电组","EKG")
		
		s sc = $$UpdateCTItemType("86", "病理(朗珈)", "病理(朗珈)", "xxx.csp", "86","","CG86","","","CREATETYPETHIRDPARTYFTP","宁医附院、青医附院朗珈","第三方","QYFYTHIRDPARTYPIS")
	}
	elseif (hospitalFlag ="YDYY")||(hospitalFlag ="DYEY")
	{
		s sc = $$UpdateCTItemType("08","麻醉记录","麻醉记录","DHCANOneStepPrint.csp","8",anesthesiaFtpConfig,"CG08","","02","CREATETYPEFTP","东华软件","临床组","ANESTHESIA")
		s sc = $$UpdateCTItemType("10","心电图","心电图","DHCRISReport.PrintCentral.csp","10",ekgFtpConfig,"CG10","","01","CREATETYPEFTP","东华软件","心电组","EKG")
		s sc = $$UpdateCTItemType("17","病理报告", "病理报告", "DHCPISReport.Print.csp", "17",pisFtpConfig,"CG17","","01","CREATETYPEFTP","东华软件","病理组","PIS")
	}
	elseif (hospitalFlag ="WLDYRM")
	{
		s sc = $$UpdateCTItemType("01","检查报告","检查报告","DHCRISReport.PrintCentral.csp","1","","CG01","","01","CREATETYPEFTP","东华软件","PACS","PACS")
		s sc = $$UpdateCTItemType("08","麻醉记录","麻醉记录","DHCANOneStepPrint.csp","8",anesthesiaFtpConfig,"CG08","","03","CREATETYPEFTP","东华软件","临床组","ANESTHESIA")
		s sc = $$UpdateCTItemType("10","心电图","心电图","DHCRISReport.PrintCentral.csp","10",ekgFtpConfig,"CG10","","01","CREATETYPEFTP","东华软件","心电组","EKG")
		s sc = $$UpdateCTItemType("17","病理报告", "病理报告", "DHCPISReport.Print.csp", "17",pisFtpConfig,"CG17","","01","CREATETYPEFTP","东华软件","病理组","PIS")
		
		s sc = $$UpdateCTItemType("94", "检验报告", "检验报告", "", "94","","CG94","","","CREATETYPETHIRDPARTYFTP","上海杏和","第三方","WLDYRMTHIRDPARTYLIS")
	}
	elseif (hospitalFlag ="LYZXYY")
	{
		s CG18Folder = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("CG18Folder")
		s sc = $$UpdateCTItemType("08","麻醉记录","麻醉记录","DHCANOneStepPrint.csp","8",anesthesiaFtpConfig,"CG08","","02","CREATETYPEFTP","东华软件","临床组","ANESTHESIA")
		s sc = $$UpdateCTItemType("10","心电图","心电图","DHCRISReport.PrintCentral.csp","10",ekgFtpConfig,"CG10","","01","CREATETYPEFTP","东华软件","心电组","EKG")
		s sc = $$UpdateCTItemType("18","麻醉记录","麻醉记录","DHCANOneStepPrint.csp","18",anesthesiaFtpConfig,"CG18",CG18Folder,"01","CREATETYPEFTP","东华软件","临床组","ANESTHESIA")
	}
	elseif (hospitalFlag ="SDYGBX")
	{
		s CG08Folder = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("CG08Folder")
		s CG18Folder = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("CG18Folder")
		s CG24Folder = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("CG24Folder")
		s CG25Folder = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("CG25Folder")
		s CG81Folder = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("CG81Folder")
		s sc = $$UpdateCTItemType("08","麻醉记录","麻醉记录","DHCANOneStepPrint.csp","8",anesthesiaFtpConfig,"CG08",CG08Folder,"01","CREATETYPEFTP","东华软件","临床组","ANESTHESIA")
		s sc = $$UpdateCTItemType("18","麻醉记录","麻醉记录","DHCANOneStepPrint.csp","18",anesthesiaFtpConfig,"CG18",CG18Folder,"01","CREATETYPEFTP","东华软件","临床组","ANESTHESIA")
		s sc = $$UpdateCTItemType("81","麻醉记录","麻醉记录","DHCANOneStepPrint.csp","81",anesthesiaFtpConfig,"CG81",CG81Folder,"01","CREATETYPEFTP","东华软件","临床组","ANESTHESIA")
		s sc = $$UpdateCTItemType("24","麻醉记录","麻醉记录","DHCANOneStepPrint.csp","24",anesthesiaFtpConfig,"CG24",CG24Folder,"01","CREATETYPEFTP","东华软件","临床组","ANESTHESIA")
		s sc = $$UpdateCTItemType("25","麻醉记录","麻醉记录","DHCANOneStepPrint.csp","25",anesthesiaFtpConfig,"CG25",CG25Folder,"01","CREATETYPEFTP","东华软件","临床组","ANESTHESIA")
	}
	elseif (hospitalFlag ="BJXHYY")
	{
		s sc = $$UpdateCTItemType("82","北京协和GE检查", "北京协和GE检查","xxx.csp","82","","CG82","","","CREATETYPETHIRDPARTYFTP","北京协和GE","第三方","BJXHGE")
	}
	elseif (hospitalFlag ="FCYY")
	{
		s sc = $$UpdateCTItemType("91","超声检查报告单", "超声检查报告单", "xxx.csp", "91","","CG91","","","CREATETYPETHIRDPARTYFTP","四合天地超声图文系统","第三方","FCYYBULTRASONIC")
		s sc = $$UpdateCTItemType("92","手术麻醉单", "手术麻醉单", "xxx.csp", "92","","CG92","","","CREATETYPETHIRDPARTYFTP","麦迪斯顿","第三方","FCYYANESTHESIA")
		s sc = $$UpdateCTItemType("96", "术前访视", "术前访视", "xxx.csp", "96","","CG96","","","CREATETYPETHIRDPARTYFTP","麦迪斯顿","第三方","FCYYANESTHESIA")
		s sc = $$UpdateCTItemType("97", "术后随访", "术后随访", "xxx.csp", "97","","CG97","","","CREATETYPETHIRDPARTYFTP","麦迪斯顿","第三方","FCYYANESTHESIA")
		s sc = $$UpdateCTItemType("98", "药品清点记录", "药品清点记录", "xxx.csp", "98","","CG98","","","CREATETYPETHIRDPARTYFTP","麦迪斯顿","第三方","FCYYANESTHESIA")
		s sc = $$UpdateCTItemType("99", "麻醉同意书", "麻醉同意书", "xxx.csp", "99","","CG99","","","CREATETYPETHIRDPARTYFTP","麦迪斯顿","第三方","FCYYANESTHESIA")
	}
	elseif (hospitalFlag ="LYEY")
	{
		s sc = $$UpdateCTItemType("99", "麻醉同意书", "麻醉同意书", "xxx.csp", "99","","CG99","","","CREATETYPETHIRDPARTYFTP","麦迪斯顿","第三方","LYEYANESTHESIA")
		s sc = $$UpdateCTItemType("80", "手术收费", "手术收费", "xxx.csp", "80","","CG80","","","CREATETYPETHIRDPARTYFTP","麦迪斯顿","第三方","LYEYANESTHESIA")
		s sc = $$UpdateCTItemType("79", "手术护理", "手术护理", "xxx.csp", "79","","CG79","","","CREATETYPETHIRDPARTYFTP","麦迪斯顿","第三方","LYEYANESTHESIA")
		s sc = $$UpdateCTItemType("78", "术前访视空", "术前访视空", "xxx.csp", "78","","CG78","","","CREATETYPETHIRDPARTYFTP","麦迪斯顿","第三方","LYEYANESTHESIA")
		s sc = $$UpdateCTItemType("77", "复苏单", "复苏单", "xxx.csp", "77","","CG77","","","CREATETYPETHIRDPARTYFTP","麦迪斯顿","第三方","LYEYANESTHESIA")
		s sc = $$UpdateCTItemType("97", "术后随访", "术后随访", "xxx.csp", "97","","CG97","","","CREATETYPETHIRDPARTYFTP","麦迪斯顿","第三方","LYEYANESTHESIA")
		s sc = $$UpdateCTItemType("76", "麻醉单空", "麻醉单空", "xxx.csp", "76","","CG76","","","CREATETYPETHIRDPARTYFTP","麦迪斯顿","第三方","LYEYANESTHESIA")
		s sc = $$UpdateCTItemType("96", "术前访视", "术前访视", "xxx.csp", "96","","CG96","","","CREATETYPETHIRDPARTYFTP","麦迪斯顿","第三方","LYEYANESTHESIA")
		s sc = $$UpdateCTItemType("75", "手术护理访视", "手术护理访视", "xxx.csp", "75","","CG75","","","CREATETYPETHIRDPARTYFTP","麦迪斯顿","第三方","LYEYANESTHESIA")
		s sc = $$UpdateCTItemType("92","手术麻醉单", "手术麻醉单", "xxx.csp", "92","","CG92","","","CREATETYPETHIRDPARTYFTP","麦迪斯顿","第三方","LYEYANESTHESIA")
		s sc = $$UpdateCTItemType("74", "复苏单护士", "复苏单护士", "xxx.csp", "74","","CG74","","","CREATETYPETHIRDPARTYFTP","麦迪斯顿","第三方","LYEYANESTHESIA")
		s sc = $$UpdateCTItemType("73", "护理访视", "护理访视", "xxx.csp", "73","","CG73","","","CREATETYPETHIRDPARTYFTP","麦迪斯顿","第三方","LYEYANESTHESIA")
		s sc = $$UpdateCTItemType("72", "术后随访空", "术后随访空", "xxx.csp", "72","","CG72","","","CREATETYPETHIRDPARTYFTP","麦迪斯顿","第三方","LYEYANESTHESIA")
		s sc = $$UpdateCTItemType("70", "龙岩市二_01", "龙岩市二_01", "xxx.csp", "70","","CG70","","","CREATETYPETHIRDPARTYFTP","麦迪斯顿","第三方","LYEYANESTHESIA")
		s sc = $$UpdateCTItemType("69", "龙岩市二末梢血糖检测表", "龙岩市二末梢血糖检测表", "xxx.csp", "69","","CG69","","","CREATETYPETHIRDPARTYFTP","麦迪斯顿","第三方","LYEYANESTHESIA")
		
		s sc = $$UpdateCTItemType("68", "卡易龙岩二院温岭检查、那龙龙岩二院心电图", "卡易龙岩二院温岭检查、那龙龙岩二院心电图", "", "68","","CG68","","","CREATETYPETHIRDPARTYFTP","卡易、那龙","第三方","THIRDPARTYURLCOMMON")
		s sc = $$UpdateCTItemType("67", "龙岩二院病理", "龙岩二院病理", "", "67","","CG67","","","CREATETYPETHIRDPARTYFTP","卡易","第三方","THIRDPARTYURLCOMMON")
	}
	elseif (hospitalFlag ="NYFY")
	{
		s sc = $$UpdateCTItemType("87", "PACS(英飞达)", "PACS(英飞达)", "xxx.csp", "87","","CG87","","","CREATETYPETHIRDPARTYFTP","英飞达","第三方","NYFYTHIRDPARTYPACS")
		
		s sc = $$UpdateCTItemType("86", "病理(朗珈)", "病理(朗珈)", "xxx.csp", "86","","CG86","","","CREATETYPETHIRDPARTYFTP","宁医附院、青医附院朗珈","第三方","NYFYTHIRDPARTYPIS")
	}
	else
	{
		s sc = $$UpdateCTItemType("22", "CS输血单", "CS输血单", "xxx.csp", "22","","CG22","","","CREATETYPEEXE","东华软件","检验组","LISPRINTCS")
	}

UpdateCTItemType(typeCode,typeName,typeDesc,cspPath,sequence,typeFTPConfig,CGURL,typeNote,typeFlag,createType,company,productTeam,createTypeSub)
	s typeURL = ""
	s cgURLValue = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName(CGURL_"URL")
	if (cgURLValue '="")
	{
		s typeURL = cgURLValue
	}
	
	s typeClass = ""
	s cgClassValue = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName(CGURL_"CLASS")
	if (cgClassValue '="")
	{
		s typeClass = cgClassValue
	}
	
	s typeMethod = ""
	s cgMethodValue = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName(CGURL_"METHOD")
	if (cgMethodValue '="")
	{
		s typeMethod = cgMethodValue
	}
	
	s rowid = ""
	&sql(select ID into :rowid from DHCEPRFS_META.CTItemType where TypeCode = :typeCode)
	if (rowid = "")
	{
		&sql(insert into DHCEPRFS_META.CTItemType (TypeCode,TypeName,TypeDesc,CSPPath,Sequence,TypeURL,TypeClass,TypeMethod,TypeFTPConfig,TypeNote,TypeFlag,CreateType,Company,ProductTeam,CreateTypeSub) values (:typeCode, :typeName, :typeDesc, :cspPath,:sequence,:typeURL,:typeClass,:typeMethod,:typeFTPConfig,:typeNote,:typeFlag,:createType,:company,:productTeam,:createTypeSub))
	}
	else
	{
		&sql(update DHCEPRFS_META.CTItemType set TypeURL = :typeURL,TypeClass=:typeClass,TypeMethod=:typeMethod,TypeFTPConfig=:typeFTPConfig,TypeNote=:typeNote,TypeFlag=:typeFlag,CreateType=:createType,Company=:company ,ProductTeam=:productTeam ,CreateTypeSub=:createTypeSub where ID = :rowid)
	}
	
	q "1"
}

/// Desc: 更新系统参数
/// Debug: d ##Class(DHCEPRFS.Tool.VersionUpdate).UpdateToV2017V9V1()
ClassMethod UpdateToV2017V9V1()
{
	//---------------------------------------------------------
	//改变的基础数据
	d ##class(DHCEPRFS.Tool.VersionUpdate).SysOpV2017V9V1()

	//---------------------------------------------------------
	//改变索引
	
	//---------------------------------------------------------
	//改变数据
	d ##class(DHCEPRFS.Tool.UpdateData).UpdateInPatientWay()
	d ##class(DHCEPRFS.Tool.UpdateData).UpdateCustomDic()
	d ##class(DHCEPRFS.Tool.UpdateData).UpdateQueryField()
	d ##class(DHCEPRFS.Tool.UpdateData).UpdateResultColumn()
	d ##class(DHCEPRFS.Tool.UpdateData).UpdateMRAction()
	d ##class(DHCEPRFS.Tool.UpdateData).UpdateConfigMetaLCV2()
	d ##class(DHCEPRFS.Tool.UpdateData).UpdateFileUniqueID()
	d ##Class(DHCEPRFS.Tool.BaseDataMgr).InitCTItemInvokeType()
	d ##Class(DHCEPRFS.Tool.BaseDataMgr).InsertQueryFunction()
	d ##Class(DHCEPRFS.Tool.InitMetaBase).InitMetaBaseProvice()
	d ##Class(DHCEPRFS.Tool.InitMetaBase).InitMetaBaseMarriage()
}

/// Desc: 更新系统参数
/// Debug: d ##Class(DHCEPRFS.Tool.VersionUpdate).UpdateToV2017V10V1()
ClassMethod UpdateToV2017V10V1()
{
	//---------------------------------------------------------
	//改变的基础数据
	d ##class(DHCEPRFS.Tool.VersionUpdate).SysOpV2017V10V1()

	//---------------------------------------------------------
	//改变索引
	d ##class(DHCEPRFS.INST.CheckedPatList).%BuildIndices()
	d ##class(DHCEPRFS.INST.MRVerSubItem).%BuildIndices()
	
	//---------------------------------------------------------
	//改变数据
	d ##Class(DHCEPRFS.Tool.BaseDataMgr).InsertQueryFunction()
	d ##Class(DHCEPRFS.Tool.BaseDataMgr).InitMRAction()
	d ##Class(DHCEPRFS.Tool.InitMetaBase).InitMetaBaseProvice()
	d ##Class(DHCEPRFS.Tool.InitMetaBase).InitMetaBaseMarriage()
	d ##Class(DHCEPRFS.Tool.InitMetaBase).InitMetaBaseDepartment()
	d ##Class(DHCEPRFS.Tool.InitMetaBase).InitMetaBaseHospital()
}

/// Desc: 更新系统参数
/// Debug: d ##Class(DHCEPRFS.Tool.VersionUpdate).UpdateToV2018V1V1()
ClassMethod UpdateToV2018V1V1()
{
	//---------------------------------------------------------
	//改变的基础数据
	d ##class(DHCEPRFS.Tool.VersionUpdate).SysOpV2018V1V1()

	//---------------------------------------------------------
	//改变索引
	d ##class(DHCEPRFS.INST.MRPatient).%BuildIndices()
	
	//---------------------------------------------------------
	//改变数据
	s parentID = ""
	&sql(select ID into :parentID from DHCEPRFS_META.QueryFunction where FuncName = 'Menu_Enable')
	s rowid = ""
	&sql(select ID into :rowid from DHCEPRFS_META.QueryFunction where FuncName = 'Menu_Enable_BSAuthorization')
	if (rowid = "")
	{
		&sql(insert into DHCEPRFS_META.QueryFunction (FuncName,FuncDesc,ParentID,Notes) values ('Menu_Enable_BSAuthorization', '借阅审批', :parentID, ''))
	}
	s rowid = ""
	&sql(select ID into :rowid from DHCEPRFS_META.QueryFunction where FuncName = 'Menu_Enable_Report_Print')
	if (rowid = "")
	{
		&sql(insert into DHCEPRFS_META.QueryFunction (FuncName,FuncDesc,ParentID,Notes) values ('Menu_Enable_Report_Print', '操作者打印工作量报表', :parentID, ''))
	}
	s rowid = ""
	&sql(select ID into :rowid from DHCEPRFS_META.QueryFunction where FuncName = 'Menu_Enable_Report_Receipt')
	if (rowid = "")
	{
		&sql(insert into DHCEPRFS_META.QueryFunction (FuncName,FuncDesc,ParentID,Notes) values ('Menu_Enable_Report_Receipt', '逾期签收统计报表', :parentID, ''))
	}

	s rowID = $o(^DHCEPRFS.META.SysOptionI("IdxOptionName"," "_$zcvt("FTPConfig","U"),""))
	s obj = ##class(DHCEPRFS.META.SysOption).%OpenId(rowID)
	s value = obj.OptionValue
	s valueAfter = "edtftp^"_$p(value,"^",2,$l(value,"^"))
	s obj.OptionValue = valueAfter
	d obj.%Save()
	
	s hospitalFlag = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("HospitalFlag")
	s opsFtpConfig = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("OPSFTPConfig")
	s chaRecordFtpConfig = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("CHARecordFTPConfig")
	s prevVisitFtpConfig = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("PrevVisitFTPConfig")
	
	s sc = $$UpdateCTItemType("28", "手术安全核查", "手术安全核查", "DHCANOneStepPrint.FS.csp", "127",opsFtpConfig,"CG28","","03","CREATETYPEFTP","东华软件","临床组","ANESTHESIA")
	s sc = $$UpdateCTItemType("29", "麻醉前访视", "麻醉前访视", "DHCANOneStepPrint.FS.csp", "128",prevVisitFtpConfig,"CG29","","03","CREATETYPEFTP","东华软件","临床组","ANESTHESIA")
	s sc = $$UpdateCTItemType("30", "CHA手术风险评估", "CHA手术风险评估", "DHCANOneStepPrint.FS.csp", "129","","CG30","","03","CREATETYPEFTP","东华软件","临床组","ANESTHESIA")
	s sc = $$UpdateCTItemType("35", "静脉血栓栓塞", "静脉血栓栓塞", "DHCNurseIPhulibingliCOMMNew.csp", "130","","","","","CREATETYPECSP","东华软件","护理组","")
	
	if (hospitalFlag = "LYEY")
	{
		s sc = $$UpdateCTItemType("36", "住院病案首页(编目)", "住院病案首页(编目)", "emr.interface.print.fs.csp", "131","","","","","CREATETYPEEMR3FP","东华软件","电子病历","")
	}
	
UpdateCTItemType(typeCode,typeName,typeDesc,cspPath,sequence,typeFTPConfig,CGURL,typeNote,typeFlag,createType,company,productTeam,createTypeSub)
	s typeURL = ""
	s cgURLValue = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName(CGURL_"URL")
	if (cgURLValue '="")
	{
		s typeURL = cgURLValue
	}
	
	s typeClass = ""
	s cgClassValue = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName(CGURL_"CLASS")
	if (cgClassValue '="")
	{
		s typeClass = cgClassValue
	}
	
	s typeMethod = ""
	s cgMethodValue = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName(CGURL_"METHOD")
	if (cgMethodValue '="")
	{
		s typeMethod = cgMethodValue
	}
	
	s rowid = ""
	&sql(select ID into :rowid from DHCEPRFS_META.CTItemType where TypeCode = :typeCode)
	if (rowid = "")
	{
		&sql(insert into DHCEPRFS_META.CTItemType (TypeCode,TypeName,TypeDesc,CSPPath,Sequence,TypeURL,TypeClass,TypeMethod,TypeFTPConfig,TypeNote,TypeFlag,CreateType,Company,ProductTeam,CreateTypeSub) values (:typeCode, :typeName, :typeDesc, :cspPath,:sequence,:typeURL,:typeClass,:typeMethod,:typeFTPConfig,:typeNote,:typeFlag,:createType,:company,:productTeam,:createTypeSub))
	}
	else
	{
		&sql(update DHCEPRFS_META.CTItemType set TypeURL = :typeURL,TypeClass=:typeClass,TypeMethod=:typeMethod,TypeFTPConfig=:typeFTPConfig,TypeNote=:typeNote,TypeFlag=:typeFlag,CreateType=:createType,Company=:company ,ProductTeam=:productTeam ,CreateTypeSub=:createTypeSub where ID = :rowid)
	}
	
	q "1"
}

/// Desc: 更新系统参数
/// Debug: d ##Class(DHCEPRFS.Tool.VersionUpdate).UpdateToV2018V3V1()
ClassMethod UpdateToV2018V3V1()
{
	//---------------------------------------------------------
	//改变的基础数据
	d ##class(DHCEPRFS.Tool.VersionUpdate).SysOpV2018V3V1()

	s noNeedCheck = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("NoNeedCheckAtUpload")
	s count = $l(noNeedCheck,"^")
	if (count = 0)
	{
		s noNeedCheck = "ME"
	}
	else 
	{
		s noNeedCheck = noNeedCheck_"^ME"
	}
	d ##class(DHCEPRFS.BL.BLSysOption).UpdateValueByName("NoNeedCheckAtUpload", noNeedCheck)

	//---------------------------------------------------------
	//改变索引

	
	//---------------------------------------------------------
	//改变数据
	w ##Class(DHCEPRFS.Tool.BaseDataMgr).InitFileStoreConfig()
	
	s transID = ""
	&sql(select ID into :transID from DHCEPRFS_META.MRTransition where PrevStatusCode = "ARRANGED" and ActionCode = "QCBACK")
	if (transID = "")
	{
		&sql(insert into DHCEPRFS_META.MRTransition (PrevStatusCode, ActionCode, PostStatusCode, IsActive) values ("ARRANGED", "QCBACK", "INITIALIZED", "1"))
	}
	s parentID = ""
	&sql(select ID into :parentID from DHCEPRFS_META.QueryFunction where FuncName = "Menu_Enable")
	s rowid = ""
	&sql(select ID into :rowid from DHCEPRFS_META.QueryFunction where FuncName = "Menu_Enable_Report_QCBack")
	if (rowid = "")
	{
		&sql(insert into DHCEPRFS_META.QueryFunction (FuncName,FuncDesc,ParentID,Notes) values ("Menu_Enable_Report_QCBack", "质控退回统计报表", :parentID, ""))
	}
	s actionID = ""
	&sql(select ID into :actionID from DHCEPRFS_META.MRAction where ActionCode = "DELAYCREATE")
	if (actionID = "")
	{
		&sql(insert into DHCEPRFS_META.MRAction (ActionCode, ActionName, IsActive, CategoryCode, CategoryName) values ("DELAYCREATE","迟归生成","1","PROCESS","病案处理"))
	}

	w ##class(DHCEPRFS.Tool.UpdateData).UpdateQueryFieldsOperCode()
	w ##class(DHCEPRFS.Tool.UpdateData).UpdateResultColumnOperCode()
	
	w ##class(DHCEPRFS.Tool.UpdateData).UpdateQueryFieldsDPDiagnose()
	w ##class(DHCEPRFS.Tool.UpdateData).UpdateResultColumnDPDiagnose()
	
	w ##class(DHCEPRFS.Tool.UpdateData).UpdateQueryFieldsEMRMainDiag()
	w ##class(DHCEPRFS.Tool.UpdateData).UpdateResultColumnEMRMainDiag()
	
	
	if (hospitalFlag = "WLDYRM")
	{
		s sc = $$UpdateCTItemType("25", "术后访视", "术后访视", "xxx.csp", "25","http://128.8.33.91/dthealth/web/DHCEPRFS.DHCC.Srv.SrvAnesthesia.cls?wsdl","DHCCAnesthesia","GetPostVisitPath","FTP^128.8.33.79^23^anonymous^^5","","03","CREATETYPEFTP","东华软件","临床组","ANESTHESIA")
	}
	
UpdateCTItemType(argTypeCode, argTypeName, argTypeDesc, argCSPPath, argSequence,typeURL,typeClass,typeMethod,typeFTPConfig,typeNote,typeFlag,createType,company,productTeam,createTypeSub)	
	s rowid = ""
	&sql(select ID into :rowid from DHCEPRFS_META.CTItemType
		where TypeCode = :argTypeCode)
	w !,rowid
	if (rowid = "")
	{
		&sql(insert into DHCEPRFS_META.CTItemType (TypeCode,TypeName,TypeDesc,CSPPath,Sequence,TypeURL,TypeClass,TypeMethod,TypeFTPConfig,TypeNote,TypeFlag,CreateType,Company,ProductTeam,CreateTypeSub) values (:argTypeCode, :argTypeName, :argTypeDesc,:argCSPPath, :argSequence,:typeURL,:typeClass,:typeMethod,:typeFTPConfig,:typeNote,:typeFlag,:createType,:company,:productTeam,:createTypeSub))
	}
	else
	{
		&sql(update DHCEPRFS_META.CTItemType set TypeCode = :argTypeCode,TypeName=:argTypeName,TypeDesc=:argTypeDesc,CSPPath=:argCSPPath,Sequence=:argSequence,TypeURL=:typeURL,TypeClass=:typeClass,TypeMethod=:typeMethod ,TypeFTPConfig=:typeFTPConfig ,TypeNote=:typeNote,TypeFlag=:typeFlag,CreateType=:createType,Company=:company,ProductTeam=:productTeam,CreateTypeSub=:createTypeSub where ID = :rowid)
	}
	
	q "1"
}

/// Desc: 更新系统参数
/// Debug: d ##Class(DHCEPRFS.Tool.VersionUpdate).SysOpV2017V10V1()
ClassMethod SysOpV2017V10V1()
{
	s sc = $$UpdateSysOption("Version", "Version 2017.10.1", "电子病历归档管理程序版本号", "base")
	s sc = $$UpdateSysOption("CompleteQueue", "N", "门急诊医生提交后延迟加入队列功能Y开启提交延迟加入队列功能，N不开启", "base")
	s sc = $$UpdateSysOption("AddEpisodeWhenAddQueue", "N", "在加入队列时就从his获取患者和就诊信息到归档库，Y开启，N不开启", "base")
	s sc = $$UpdateSysOption("ReviewMode", "0", "病案复核模式，0-不分先后，1-先质控科后病案室，2-先病案室后质控科", "BROWSE")
	s sc = $$UpdateSysOption("CardScanMRItemID", "", "证件扫描项目ID", "scan")
	
UpdateSysOption(argOptionName,argOptionValue,argOptionDesc,argOptionType)
    s rowid = ""
	&sql(select ID into :rowid from DHCEPRFS_META.SysOption
		where OptionName = :argOptionName and OptionValue = :argOptionValue)
	w !,rowid
	if (rowid = "")
	{
		&sql(insert into DHCEPRFS_META.SysOption (OptionName, OptionValue, OptionDesc, OptionType) 
			values (:argOptionName, :argOptionValue, :argOptionDesc,:argOptionType))
	}
	
	q "1"
}

/// Desc: 更新系统参数
/// Debug: d ##Class(DHCEPRFS.Tool.VersionUpdate).SysOpV2017V9V1()
ClassMethod SysOpV2017V9V1()
{
	s sc = $$UpdateSysOption("ToolStripItemSort", "PageNum^PageLabel^ZoomOut^ZoomIn^FitPage^FitWidth^ActualSize^Mod^Preview^RotateCC^RotateC^Next^Previous", "PDF浏览界面工具栏配置参数", "BROWSE")
	s sc = $$UpdateSysOption("MREpisodeFPTypeCode", "DHC", "取诊断项目信息的途径", "create")
	
UpdateSysOption(argOptionName,argOptionValue,argOptionDesc,argOptionType)
    s rowid = ""
	&sql(select ID into :rowid from DHCEPRFS_META.SysOption
		where OptionName = :argOptionName and OptionValue = :argOptionValue)
	w !,rowid
	if (rowid = "")
	{
		&sql(insert into DHCEPRFS_META.SysOption (OptionName, OptionValue, OptionDesc, OptionType) 
			values (:argOptionName, :argOptionValue, :argOptionDesc,:argOptionType))
	}
	
	q "1"
}

/// Desc: 更新系统参数
/// Debug: d ##Class(DHCEPRFS.Tool.VersionUpdate).SysOpV2017V7V1()
ClassMethod SysOpV2017V7V1()
{
	s sc = $$UpdateSysOption("ShowWaterMarkComponent", "QUEUEVIEW^QUERYVIEW^PRINT^EXPORT^ACTIVEXVIEW", "开启水印的控件，QUEUEVIEW-队列管理浏览，QUERYVIEW-简单、综合查询浏览，PRINT-打印，EXPORT-导出，ACTIVEXVIEW-控件浏览，以^分隔", "BROWSE")
	s sc = $$UpdateSysOption("WaterMarkStyle", "15^30^255.0.0^0^80", "水印的样式，重复次数^字体大小^字体的RGB颜色，倾斜角度，行高，比如2^120^255.0.0^60^100", "BROWSE")
	s sc = $$UpdateSysOption("DataServiceURL", "http://0.0.0.0/dthealth/web/", "数据访问Web服务地址", "base")
	
	s sc = $$UpdateSysOption("MREpisodeFPTypeCode", "DHC", "取诊断项目信息的途径", "create")
		
UpdateSysOption(argOptionName,argOptionValue,argOptionDesc,argOptionType)
    s rowid = ""
	&sql(select ID into :rowid from DHCEPRFS_META.SysOption
		where OptionName = :argOptionName and OptionValue = :argOptionValue)
	w !,rowid
	if (rowid = "")
	{
		&sql(insert into DHCEPRFS_META.SysOption (OptionName, OptionValue, OptionDesc, OptionType) 
			values (:argOptionName, :argOptionValue, :argOptionDesc,:argOptionType))
	}
	
	q "1"
}

/// Desc: 更新系统参数
/// Debug: d ##Class(DHCEPRFS.Tool.VersionUpdate).SysOpV2017V6V1()
ClassMethod SysOpV2017V6V1()
{
	s sc = $$UpdateSysOption("ShowDeptNotReviewed", "Y", "病案室复核列表是否显示未通过科室复核的就诊", "BROWSE")
	s sc = $$UpdateSysOption("GetIPLogListTimeSpan", "7", "查看服务器工作日志的默认时间段", "common")
		
UpdateSysOption(argOptionName,argOptionValue,argOptionDesc,argOptionType)
    s rowid = ""
	&sql(select ID into :rowid from DHCEPRFS_META.SysOption
		where OptionName = :argOptionName and OptionValue = :argOptionValue)
	w !,rowid
	if (rowid = "")
	{
		&sql(insert into DHCEPRFS_META.SysOption (OptionName, OptionValue, OptionDesc, OptionType) 
			values (:argOptionName, :argOptionValue, :argOptionDesc,:argOptionType))
	}
	
	q "1"
}

/// Desc: 更新系统参数
/// Debug: d ##Class(DHCEPRFS.Tool.VersionUpdate).SysOpV2017V4V1()
ClassMethod SysOpV2017V4V1()
{
	s sc = $$UpdateSysOption("AutoCompleteFirstTimeSpan", "1", "第一次自动生成提交的时间段", "create")
	s sc = $$UpdateSysOption("AutoCompleteSecondTimeSpan", "3", "第二次自动生成提交的时间段", "create")
		
UpdateSysOption(argOptionName,argOptionValue,argOptionDesc,argOptionType)
    s rowid = ""
	&sql(select ID into :rowid from DHCEPRFS_META.SysOption
		where OptionName = :argOptionName and OptionValue = :argOptionValue)
	w !,rowid
	if (rowid = "")
	{
		&sql(insert into DHCEPRFS_META.SysOption (OptionName, OptionValue, OptionDesc, OptionType) 
			values (:argOptionName, :argOptionValue, :argOptionDesc,:argOptionType))
	}
	
	q "1"
}

/// Desc: 更新系统参数
/// Debug: d ##Class(DHCEPRFS.Tool.VersionUpdate).SysOpV2017V2V2()
ClassMethod SysOpV2017V2V2()
{
	s sc = $$UpdateSysOption("DBVersion", "2010", "数据库版本 2010-Cache2010，2016-Cache2016 5-包括5.0.15的5系列，6-比如6.9的6系列", "base")
	s sc = $$UpdateSysOption("DBUserPassword", "qzEE+9pnaI5oGxgiu1TjpQ==^3I8gYVHTbpycbOGbX7aHpg==", "数据库Webservice用户的用户名密码，密文", "base")
		
UpdateSysOption(argOptionName,argOptionValue,argOptionDesc,argOptionType)
    s rowid = ""
	&sql(select ID into :rowid from DHCEPRFS_META.SysOption
		where OptionName = :argOptionName and OptionValue = :argOptionValue)
	w !,rowid
	if (rowid = "")
	{
		&sql(insert into DHCEPRFS_META.SysOption (OptionName, OptionValue, OptionDesc, OptionType) 
			values (:argOptionName, :argOptionValue, :argOptionDesc,:argOptionType))
	}
	
	q "1"
}

/// Desc: 更新系统参数
/// Debug: d ##Class(DHCEPRFS.Tool.VersionUpdate).SysOpV2017V2V1()
ClassMethod SysOpV2017V2V1()
{
	//病案复核
	s sc = $$UpdateSysOption("ShowTimeLine", "Y", "病案复核是否显示示踪时间轴，Y-显示，N-不显示", "BROWSE")
	s sc = $$UpdateSysOption("SuperSSGroup", "54^58^62^63", "分配病案复核超级权限的安全组ID，以'^'分隔", "BROWSE")
		
UpdateSysOption(argOptionName,argOptionValue,argOptionDesc,argOptionType)
    s rowid = ""
	&sql(select ID into :rowid from DHCEPRFS_META.SysOption
		where OptionName = :argOptionName and OptionValue = :argOptionValue)
	w !,rowid
	if (rowid = "")
	{
		&sql(insert into DHCEPRFS_META.SysOption (OptionName, OptionValue, OptionDesc, OptionType) 
			values (:argOptionName, :argOptionValue, :argOptionDesc,:argOptionType))
	}
	
	q "1"
}

/// Desc: 更新系统参数
/// Debug: d ##Class(DHCEPRFS.Tool.VersionUpdate).SysOpV2018V1V1()
ClassMethod SysOpV2018V1V1()
{
	s hospitalFlag = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("HospitalFlag")
	 
	s sc = $$UpdateSysOption("Version", "Version 2018.1.1", "电子病历归档管理程序版本号", "base")
	s sc = $$UpdateSysOption("EnableObservedNo", "Y", "是否启用留观号查询条件，Y-开启，非Y-不开启", "common")
	
	if (hospitalFlag ="WLDYRM")
	{
		s sc = $$UpdateSysOption("OPSFTPConfig", "FTP^128.8.33.79^23^anonymous^^5", "OPSFTPConfig", "create")
		s sc = $$UpdateSysOption("CHARecordFTPConfig", "FTP^128.8.33.79^23^anonymous^^5", "CHARecordFTPConfig", "create")
		s sc = $$UpdateSysOption("PrevVisitFTPConfig", "FTP^128.8.33.79^23^anonymous^^5", "PrevVisitFTPConfig", "create")

		s sc = $$UpdateSysOption("CG28URL", "http://128.8.33.91/dthealth/web/DHCEPRFS.DHCC.Srv.SrvAnesthesia.cls?wsdl", "CG28", "create")
		s sc = $$UpdateSysOption("CG28CLASS", "DHCCAnesthesia", "CG28", "create")
		s sc = $$UpdateSysOption("CG28METHOD", "GetOPSPDFPath", "CG28", "create")
		
		s sc = $$UpdateSysOption("CG29URL", "http://128.8.33.91/dthealth/web/DHCEPRFS.DHCC.Srv.SrvAnesthesia.cls?wsdl", "CG28", "create")
		s sc = $$UpdateSysOption("CG29CLASS", "DHCCAnesthesia", "CG29", "create")
		s sc = $$UpdateSysOption("CG29METHOD", "GetPrevVisitPath", "CG29", "create")
		
		s sc = $$UpdateSysOption("CG30URL", "http://128.8.33.91/dthealth/web/DHCEPRFS.DHCC.Srv.SrvAnesthesia.cls?wsdl", "CG28", "create")
		s sc = $$UpdateSysOption("CG30CLASS", "DHCCAnesthesia", "CG30", "create")
		s sc = $$UpdateSysOption("CG30METHOD", "GetCHARecordPath", "CG30", "create")
	}
		
UpdateSysOption(argOptionName,argOptionValue,argOptionDesc,argOptionType)
    s rowid = ""
	&sql(select ID into :rowid from DHCEPRFS_META.SysOption
		where OptionName = :argOptionName and OptionValue = :argOptionValue)
	w !,rowid
	if (rowid = "")
	{
		&sql(insert into DHCEPRFS_META.SysOption (OptionName, OptionValue, OptionDesc, OptionType) 
			values (:argOptionName, :argOptionValue, :argOptionDesc,:argOptionType))
	}
	
	q "1"
}

/// Desc: 更新系统参数
/// Debug: d ##Class(DHCEPRFS.Tool.VersionUpdate).SysOpV2018V3V1()
ClassMethod SysOpV2018V3V1()
{
	s sc = $$UpdateSysOption("SystemName", "电子病历归档管理系统", "电子病历归档管理程序名称", "base")
	s sc = $$UpdateSysOption("EnableThreeLevelSecurity", "Y", "是否启用三级等保", "base")
	
UpdateSysOption(argOptionName,argOptionValue,argOptionDesc,argOptionType)
    s rowid = ""
	&sql(select ID into :rowid from DHCEPRFS_META.SysOption
		where OptionName = :argOptionName and OptionValue = :argOptionValue)
	w !,rowid
	if (rowid = "")
	{
		&sql(insert into DHCEPRFS_META.SysOption (OptionName, OptionValue, OptionDesc, OptionType) 
			values (:argOptionName, :argOptionValue, :argOptionDesc,:argOptionType))
	}
	
	q "1"
}

}
