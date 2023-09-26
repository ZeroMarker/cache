Class web.BDPExt.PHManufacturerBLL Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator:陈莹 
/// CreatDate:2017-3-14
/// Description:数据导入 之 厂商导入(物资)
/// PH_Manufacturer，DHC_Manf_AddionInfo
/// Other:d ##class(web.BDPExt.PHManufacturerBLL).SaveEntity(Ceobj)
ClassMethod SaveEntity(Ceobj As web.BDPExt.PHManufacturerEntity) As %String
{
	n (Ceobj,%session)
	s $zt="ERROR"
	s ImportResult=""
	///字段名和值之间用上箭头"^" 拼接，然后它们之间再用"|"拼接。
	// 厂商代码	厂商名称	简称	别名	类型(G药品,M物资材料)	电话	地址
	s liststr="mCode^"_Ceobj.mCode_"|mName^"_Ceobj.mName_"|mShortName^"_Ceobj.mShortName_"|mAlias^"_Ceobj.mAlias_"|mType^"_Ceobj.mType_"|mTel^"_Ceobj.mTel_"|mAddress^"_Ceobj.mAddress
	//营业执照号	营业执照开始日期	营业执照截止日期	器械生产许可号	器械生产许可起始日期	器械生产许可截止日期	一类器械生产备案号	一类器械生产备案起始日期	一类器械生产备案截止日期
	s liststr=liststr_"|mComLic^"_Ceobj.mComLic_"|mComLicDateFrom^"_Ceobj.mComLicDateFrom_"|mComLicDateTo^"_Ceobj.mComLicDateTo_"|mInsProLic^"_Ceobj.mInsProLic_"|mInsProLicDateFrom^"_Ceobj.mInsProLicDateFrom_"|mInsProLicDateTo^"_Ceobj.mInsProLicDateTo_"|mFirstProdLic^"_Ceobj.mFirstProdLic_"|mFirstProdLicDateFrom^"_Ceobj.mFirstProdLicDateFrom_"|mFirstProdLicDateTo^"_Ceobj.mFirstProdLicDateTo
	
	s ^tmpcy("web.BDPExt.PHManufacturerBLL")=liststr
	//s ret= ##class(web.DHCSTM.Tools.CodeInputX).SaveManf(liststr)  //>0 - rowid,<0 - 失败
	Ts
	//2020-04-16调用物资组李慧新接口web.DHCSTMHUI.Tools.CodeInputX 厂商 
	/*if (ret'>0)
	{
		s msg=ret
		if ret=-4 s msg="添加到PH_Manufacturer表失败"
		if ret=-42 s msg="更新电话失败"
		if ret=-41 s msg="代码或描述已存在"
		if ret=-5 s msg="添加到DHC_Manf_AddionInfo表失败"
		s ImportResult= "厂商保存失败："_msg
	}
	
	if (ImportResult="")
	{
		Tc
		//s JsonStr="{PHMNFCode:"""_Ceobj.mCode_""",PHMNFName:"""_Ceobj.mName_""",mShortName:"""_Ceobj.mShortName_""",PHMNFAddress:"""_Ceobj.mAddress_""",mType:"""_Ceobj.mType_""",PHMNFTel:"""_Ceobj.mTel_"""}"     
		//d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("PH_Manufacturer","User.PHManufacturer","厂商",ret,Ceobj.mName,"A",JsonStr)
	
		s ImportResult="{success:'true',id:'"_ret_"'}" 
	}
	else
	{
		Tro	
	}
	q ImportResult*/
	try
	{
		s ret= ##class(web.DHCSTMHUI.Tools.CodeInputX).SaveManf(liststr,Ceobj.LinkHospId) //2021-01-27 返回值改成json串 ：{"rowid":"1441","msg":"操作成功","success":"0","keyValue":{}}
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
		if (messageJsonObj.success<0)  //为负数时为保存失败
		{
			s ImportResult= "厂商保存失败："_messageJsonObj.msg
			if $tl>0 Tro	
		}
		else   //保存成功
		{
			Tc
			//s JsonStr="{PHMNFCode:"""_Ceobj.mCode_""",PHMNFName:"""_Ceobj.mName_""",mShortName:"""_Ceobj.mShortName_""",PHMNFAddress:"""_Ceobj.mAddress_""",mType:"""_Ceobj.mType_""",PHMNFTel:"""_Ceobj.mTel_"""}"     
			//d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("PH_Manufacturer","User.PHManufacturer","厂商",ret,Ceobj.mName,"A",JsonStr)
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

/// Creator:陈莹
/// CreatDate:2021-12-16
/// Description:清除厂商相关数据
/// Other:d ##class(web.BDPExt.PHManufacturerBLL).ClearData()
ClassMethod ClearData()
{
	n
	k ^PHMNF,^DHCMANF,^mdata("DHCMANFADDIONINFO")
	
	///清除资质信息表
	S Type="Manf" //(Vendor代表供应商, Manf代表厂商, Carrier代表配送商)
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
