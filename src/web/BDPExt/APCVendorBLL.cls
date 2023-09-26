Class web.BDPExt.APCVendorBLL Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator:陈莹 
/// CreatDate:2017-3-14
/// Description:数据导入 之 供应商导入(物资)
/// APC_Vendor,DHC_STVendor
/// Other:d ##class(web.BDPExt.APCVendorBLL).SaveEntity(Ceobj)
ClassMethod SaveEntity(Ceobj As web.BDPExt.APCVendorEntity) As %String
{
	n (Ceobj,%session)
	s $zt="ERROR"
	s ImportResult=""

	///字段名和值之间用上箭头"^" 拼接，然后它们之间再用"|"拼接。
	s liststr="vCode^"_Ceobj.vCode_"|vName^"_Ceobj.vName_"|vShortName^"_Ceobj.vShortName_"|vAlias^"_Ceobj.vAlias_"|vType^"_Ceobj.vType_"|vTel^"_Ceobj.vTel_"|vAddress^"_Ceobj.vAddress  //_"|vUniversal^"_Ceobj.vUniversal  2021-01-27去掉通用字段
	
	//营业执照号	营业执照开始日期	营业执照截止日期	经营许可证编号	经营许可起始日期	经营许可截止日期	二类经营备案号	二类经营备案起始日期	二类经营备案截止日期
	s liststr=liststr_"|vComLic^"_Ceobj.vComLic_"|vComLicDateFrom^"_Ceobj.vComLicDateFrom_"|vComLicDateTo^"_Ceobj.vComLicDateTo_"|vInsBusLic^"_Ceobj.vInsBusLic_"|vInsBusLicDateFrom^"_Ceobj.vInsBusLicDateFrom_"|vInsBusLicDateTo^"_Ceobj.vInsBusLicDateTo_"|vSecondBusLic^"_Ceobj.vSecondBusLic_"|vSecondBusLicDateFrom^"_Ceobj.vSecondBusLicDateFrom_"|vSecondBusLicDateTo^"_Ceobj.vSecondBusLicDateTo
	s ^tmpcy("web.BDPExt.APCVendorBLL")=liststr
	Tstart
	//2020-04-16调用物资组李慧新接口web.DHCSTMHUI.Tools.CodeInputX
	//s ret= ##class(web.DHCSTM.Tools.CodeInputX).SaveVendor(liststr)  //>0 - rowid,<0 - 失败
	/*if (ret'>0)
	{
		tro
		s msg=ret
		if ret=-4 s msg="存在重复供应商"
		if ret=-5 s msg="添加到APC_Vendor表失败"
		if ret=-51 s msg="更新电话、简称失败"
		if ret=-6 s msg="添加到DHC_STVendor表失败"
		if ret=-61  s msg="更新供应商别名失败"
		q "供应商保存失败："_msg 
	}
	Tcommit
	//s JsonStr="{APCVMCode:"""_Ceobj.vCode_""",APCVMName:"""_Ceobj.vName_""",APCVMShName:"""_Ceobj.vShortName_""",APCVMAddr:"""_Ceobj.vAddress_""",APCVMType:"""_Ceobj.vType_""",APCVMTel:"""_Ceobj.vTel_"""}"     
	//d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("APC_Vendor","User.APCVendor","供应商",ret,Ceobj.vName,"A",JsonStr)
	q "{success:'true',id:'"_ret_"'}"
	*/
	try
	{
		s ret= ##class(web.DHCSTMHUI.Tools.CodeInputX).SaveVendor(liststr,Ceobj.LinkHospId)  //2021-01-27 返回值改成json串 ：{"rowid":"1441","msg":"操作成功","success":"0","keyValue":{}}
	}
	catch myvar
	{
		//s ret="-1^"_$ze
		s errormsg=$tr($ze,"""","")
		s ret="{""rowid"":"""",""msg"":"""_errormsg_""",""success"":""-1"",""keyValue"":{}}"
	}
	if ret["rowid"
	{
		
		set messageJsonObj=##class(%DynamicAbstractObject).%FromJSON(ret)  //将返回值json处理成对象
		//set messageJsonObj=##class(ext.util.JsonObject).%New().FromJSON(ret)
		//if (messageJsonObj.Get("success")=0)
		if (messageJsonObj.success<0)  //为负数时为保存失败
		{
			if $tl>0 Tro
			s ImportResult= "保存失败："_messageJsonObj.msg
			
		}
		else   //保存成功
		{
			Tcommit
			//s JsonStr="{APCVMCode:"""_Ceobj.vCode_""",APCVMName:"""_Ceobj.vName_""",APCVMShName:"""_Ceobj.vShortName_""",APCVMAddr:"""_Ceobj.vAddress_""",APCVMType:"""_Ceobj.vType_""",APCVMTel:"""_Ceobj.vTel_"""}"     
			//d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("APC_Vendor","User.APCVendor","供应商",ret,Ceobj.vName,"A",JsonStr)
			s ImportResult="{success:'true',id:'"_messageJsonObj.rowid_"'}"
		}
	}
	else
	{
		s ImportResult= "保存失败："_ret
		if $tl>0 Tro
	}
	q ImportResult
ERROR
	if $tl>0 Tro
	Q "导入报错"_$ZE
}

/// 2019-07-03  增加
/// chenying
/// 供应商有同名的情况，获取对应标志的供应商，物资和药品导入时调用。
/// Other:d ##class(web.BDPExt.APCVendorBLL).GetRowIDByDesc("Desc","M",2)
ClassMethod GetRowIDByDesc(name As %String, flag As %String, hospid As %String = "") As %String
{
	n (name,flag,hospid)
	s HospAutflag = ##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPHospAut")
	s qid=""
	if $$ALPHAUP^SSUTIL4(name)'=""
	{
		s id=0
		for
		{
			s id=$o(^APC("APCVM",0,"APCVM_Name",$$ALPHAUP^SSUTIL4(name),id)) q:id=""
			s APCVMType=$p($g(^APC("APCVM",id)),"^",9)
			if APCVMType=flag
			{
				if (HospAutflag="Y")
				{
					if (hospid="")
					{
						s qid=id
					}
					elseif $d(^User.BDPMappingHospI("DataRef","APC_Vendor",hospid,id))>0
					{
						s qid=id
					}
				}
				else
				{
					s qid=id
				}
				
			}
		}
	
	}
	q qid
}

/// Creator:陈莹
/// CreatDate:2021-12-16
/// Description:清除供应商相关数据
/// Other:d ##class(web.BDPExt.APCVendorBLL).ClearData()
ClassMethod ClearData()
{
	n
	k ^APC("APCVM"),^DHCSTV,^mdata("DHCSTVENDOR"),^APC("APCVC"),^APCVENDORINFO,^mdata("APCVENDORADDINFO")
	
	///清除资质信息表
	S Type="Vendor" //(Vendor代表供应商, Manf代表厂商, Carrier代表配送商)
	s CERTID=0
	for  
	{	
		s CERTID=$o(^User.DHCCertDetailD(CERTID)) q:CERTID=""
		s CERTOrgType=$listget($g(^User.DHCCertDetailD(CERTID)),3)
		if (CERTOrgType=Type)
		{
			d ##class(User.DHCCertDetail).%DeleteId(CERTID)
		}
	}
}

}
