Import SQLUser

Class web.DHCPE.PreCommon Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

ClassMethod OutImmigrantCountryToHTML(ContrlWidth As %String = "") As %String
{
	s:(""=ContrlWidth) ContrlWidth="155"
	//下拉列表
	w "<select name='ImmigrantCountry' id='ImmigrantCountry' style='width:"_ContrlWidth_"' HEIGHT=0 tabIndex=0>",!
	w "<option value='Canada'>Canada</option>",!
	w "<option value='Spain'>Spain</option>",!
	w "<option value='Singapore'>Singapore</option>",!
	w "<option value='Nevis'>Nevis</option>",!
	w "<option value='Antigua and Barbuda'>Antigua and Barbuda</option>",!
	w "<option value='Cyprus'>Cyprus</option>",!
	w "<option value='Switzerland'>Switzerland</option>",!
	w "<option value='South Africa'>South Africa</option>",!
	w "<option value='NewZealand'>NewZealand</option>",!
	w "<option value='Finland'>Finland</option>",!
	w "<option value='Australia'>Australia</option>",!
	w "<option value='Germany'>Germany</option>",!
	w "<option value='UK'>UK</option>",! 
	w "<option value='GREECE'>GREECE</option>",!  
	w "<option value='Israel'>Israel</option>",!
	w "<option value='Papua New Guinea'>Papua New Guinea</option>",!	
    w "<option value='U.S.A'>U.S.A</option>",!
    w "<option value='Grenada'>Grenada</option>",!
    w "<option value='Individual'>Individual</option>",!
    w "<option value='Belgium'>Belgium</option>",!
	w "<option value=''>  </option>",!
	w "</select>",!
	Quit $$$OK
}

/// 通过医嘱rowid得到是否是套餐里的 1不是套餐的 0 是套餐里的
/// w ##class(web.DHCPE.PreCommon).GetIfSetBymast("3363602||2")
ClassMethod GetIfSetBymast(OEOrdItemDr)
{
	;q "0"
	q:OEOrdItemDr="" ""
	s OrdEntDR="",Flag=0
	//^DHCPECRMO(0,"CRMORI",{CRMO_CRMORI},{CRMO_RowId}) DHC_PE_CRMOrder
	s OEORDRowId=$P($g(OEOrdItemDr),"||",1)
	s OEORIChildsub=$P($g(OEOrdItemDr),"||",2)
	s OrdEntDR=$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",1)
	s:(OrdEntDR="") Flag=1
	
	q Flag
}

// w ##class(web.DHCPE.PreCommon).GetTelNo("PIBI",PIBI)

ClassMethod GetTelNo(Type, ID)
{
	q:ID="" ""
	s PGBITel=""
	i Type="PAADM" d
	.s IADM=$O(^DHCPEIADM(0,"PAADM",ID,0))
	.q:IADM=""
	.s PGBITel=..GetTelNo("IADM",IADM)
	i Type="IADM" d
	.s PIADM=$P(^DHCPEIADM(ID),"^",4)
	.q:PIADM=""
	.s PGBITel=..GetTelNo("PIADM",PIADM)
	i Type="PIADM" d
	.s PIBI=$P(^DHCPEPreIADM(ID),"^",1)
	.q:PIBI=""
	.s PGBITel=..GetTelNo("PIBI",PIBI)
	i Type="PIBI" d
	.q:ID=""
	.d GetTelByPIBI(ID)
	q PGBITel
GetTelByPIBI(PIADMPIBIDR)
	s PGBITel1=$p($g(^DHCPEPreIBI(PIADMPIBIDR)),"^",6) //电话1 
	s PGBITel2=$p($g(^DHCPEPreIBI(PIADMPIBIDR)),"^",7) //电话2
	s MobilTel=$p($g(^DHCPEPreIBI(PIADMPIBIDR)),"^",8) //移动电话 
	i MobilTel'="" s PGBITel=MobilTel
	e  d 
	.i PGBITel1'=""  s PGBITel=PGBITel1
	.e  s PGBITel=PGBITel2
	q
}

// w ##class(web.DHCPE.PreCommon).ExcMethod("web.DHCPE.PreCommon","Testaaa","")

ClassMethod ExcMethod(Class, Method, Args)
{
	s ret="s ret=##class("_Class_")."_Method_"("
	s Arg=""
	i Args'=""
	{
		s ArgLength=$L(Args,$C(5))
		for i=1:1:ArgLength  d
		.s Arg=Arg_""""_$P(Args,$C(5),i)_""""_","
		
	}
	i Arg'="" d
	.s Arg=$P(Arg,",",1,$L(Arg,",")-1)
	s ret=ret_Arg_")"
	xecute ret
	q ret
}

// w ##class(web.DHCPE.PreCommon).CalcExpression(tthhsn,"val[hhsn")

ClassMethod CalcExpression(val, expression)
{
	s tem="s ret="_expression
	xecute tem
	q ret
}

ClassMethod CalcExpressionNew(expression)
{
	s tem="ret="_expression
	s @tem
	q ret
}

ClassMethod Testaaa(a, b)
{
	q "aaaa"
}

Parameter BUILD = 137;

/// 病人类型 列表
Query SocialStatusList(Desc As %String = "") As %SQLQuery(CONTAINID = 1, ROWSPEC = "类型:%String,代码:%String,编码:%String")
{
	select SS_Desc,SS_Code,SS_RowId 
	from CT_SocialStatus
	where SS_Desc %STARTSWITH :Desc
}

/// 性别 列表
Query SexList(Desc As %String = "") As %SQLQuery(CONTAINID = 1, ROWSPEC = "类型:%String,代码:%String,编码:%String")
{
	select CTSEX_Desc, CTSEX_Code, CTSEX_RowId
	from CT_Sex
	where CTSEX_Desc %STARTSWITH :Desc
}

/// 婚姻状况 列表
Query MaritalList(Desc As %String = "") As %SQLQuery(CONTAINID = 1, ROWSPEC = "类型:%String, 代码:%String, 编码:%String")
{
	select CTMAR_Desc, CTMAR_Code, CTMAR_RowId
	from CT_Marital
	where CTMAR_Desc %STARTSWITH :Desc
}

/// 血型 列表
Query BloodTypeList(Desc As %String = "") As %SQLQuery(CONTAINID = 1, ROWSPEC = "类型:%String, 代码:%String, 编码:%String")
{
	select BLDT_Desc,BLDT_Code,BLDT_RowId
	from PAC_BloodType
	where BLDT_Desc %STARTSWITH :Desc
}

/// 使用模块
/// 		DHCPEPreGADM.Edit   团体预约
/// 		DHCPEPreGTeam.Edit	团体分组
/// 		DHCPEPreIADM.GTEdit	团体成员预约修改
/// 生成一个页面元素　显示个人报告发送列表 使用组件 DHCPEPreIADM.Team
/// d ##class(web.DHCPE.PreCommon).OutIReportSendToHTML()
ClassMethod OutIReportSendToHTML(ContrlWidth As %String = "") As %String
{
	s:(""=ContrlWidth) ContrlWidth="120"
	//下拉列表
	;w "<select name='IReportSend' id='IReportSend' style='width:"_ContrlWidth_"' HEIGHT=0>",!
	w ##class(web.DHCPE.DHCPECommon).GetDefaultStyle("IReportSend","")
	w "<option value=''>  </option>",!
	w "<option value='GS'>统取</option>",!
	w "<option value='IS'>自取</option>",!
	w "</select>",!
	Quit $$$OK
}

/// 使用模块
/// 		DHCPEPreGADM.Edit   团体预约
/// 		DHCPEPreGTeam.Edit	团体分组
/// 		DHCPEPreIADM.GTEdit	团体成员预约修改
/// 生成一个页面元素　显示结算方式列表 使用组件 DHCPEPreIADM.Team
/// d ##class(web.DHCPE.PreCommon).OutVocationToHTML()
ClassMethod OutDisChargedModeToHTML(ContrlWidth As %String = "") As %String
{
	s:(""=ContrlWidth) ContrlWidth="155"
	//下拉列表
	;w "<select name='DisChargedMode' id='DisChargedMode' style='width:"_ContrlWidth_"' HEIGHT=0>",!
	w ##class(web.DHCPE.DHCPECommon).GetDefaultStyle("DisChargedMode","")
	//w "<option value=''>  </option>",!
	w "<option value='GD'>统结</option>",!
	w "<option value='ID'>自结</option>",!
	w "</select>",!
	Quit $$$OK
}

/// 使用模块
/// 		DHCPEPreGADM.Edit   团体预约
/// 		DHCPEPreGTeam.Edit	团体分组
/// 		DHCPEPreIADM.GTEdit	团体成员预约修改
/// 生成一个页面元素　显示团体报告发送列表 使用组件 DHCPEPreIADM.Team
/// d ##class(web.DHCPE.PreCommon).OutVocationToHTML()
ClassMethod OutGReportSendToHTML(ContrlWidth As %String = "") As %String
{
	s:(""=ContrlWidth) ContrlWidth="120"
	//下拉列表
	;w "<select name='GReportSend' id='GReportSend' style='width:"_ContrlWidth_"' HEIGHT=0>",!
	w ##class(web.DHCPE.DHCPECommon).GetDefaultStyle("GReportSend","")
	w "<option value=''>  </option>",!
	w "<option value='AC'>挂帐可取</option>",!
	w "<option value='DC'>结帐取</option>",!
	w "</select>",!
	Quit $$$OK
}

// /////////////////////////////////////////////////////////////////////////////

/// 获取状态编码的含义
/// w ##Class(web.DHCPE.PreCommon).TransStatus("UNCHARGED")
ClassMethod TransStatus(Status As %String = "")
{
	n (Status)
	s StatusDesc=""
	i Status="" q ""
	//s StatusList=""
	i "PREREG"=Status s StatusDesc="预约"
	//s:(""=Status) StatusList=StatusList_";"_"PREREG"_"^"_"预约"
	
	i "REGISTERED"=Status s StatusDesc="登记"
	//s:(""=Status) StatusList=StatusList_";"_"REGISTERED"_"^"_"登记"
	i "ARRIVED"=Status s StatusDesc="到达"
	i "CANCELPREREG"=Status s StatusDesc="取消预约"
	//s:(""=Status) StatusList=StatusList_";"_"CANCELPREREG"_"^"_"取消预约"
	i "PREREGED"=Status s StatusDesc="完成预约"
	
	i "CANCELARRIVED"=Status s StatusDesc="取消到达"
	i "CANCELPE"=Status s StatusDesc="取消体检"
	//Q:(""'=StatusList) StatusList
	Q StatusDesc
}

/// 获取收费状态的含义
/// w ##Class(web.DHCPE.PreCommon).TransChargedStatus("UNCHARGED")
ClassMethod TransChargedStatus(Status As %String = "")
{
	s StatusDesc=""
	s StatusList=""
	i "UNCHARGED"=Status s StatusDesc="未收费"
	s:(""=Status) StatusList=StatusList_";"_"UNCHARGED"_"^"_"未收费"
	
	i "CHARGED"=Status s StatusDesc="已收费"
	s:(""=Status) StatusList=StatusList_";"_"CHARGED"_"^"_"未收费"_";"
	
	i "ADDUNCHARGED"=Status s StatusDesc="中间加项未收费"
	s:(""=Status) StatusList=StatusList_";"_"ADDUNCHARGED"_"^"_"中间加项未收费"
	
	i "ADDCHARGED"=Status s StatusDesc="中间加项已收费"
	s:(""=Status) StatusList=StatusList_";"_"ADDCHARGED"_"^"_"中间加项已收费"
	
	Q:(""'=StatusList) StatusList
	Q StatusDesc
}

/// 获取审核状态的含义
/// w ##Class(web.DHCPE.PreCommon).TransCheckedStatus("UNCHECKED")
ClassMethod TransCheckedStatus(Status As %String = "")
{
	s StatusDesc=""
	s StatusList=""
	i "UNCHECKED"=Status s StatusDesc="未审核"
	s:(""=Status) StatusList=StatusList_";"_"UNCHECKED"_"^"_"未审核"

	i "CHECKED"=Status s StatusDesc="已审批"
	s:(""=Status) StatusList=StatusList_";"_"CHECKED"_"^"_"已审批"

	i "NOCHECKED"=Status s StatusDesc="不需审核"
	s:(""=Status) StatusList=StatusList_";"_"NOCHECKED"_"^"_"不需审核"

	Q:(""'=StatusList) StatusList
	Q StatusDesc
}

/// 获取个人报告发送的含义 如果不输入个人报告发送的含义编码则得到含义数组
/// w ##Class(web.DHCPE.PreCommon).TransIReportSend()
ClassMethod TransIReportSend(Status As %String = "")
{
	s StatusDesc=""
	s StatusList=""
	i ("GSend"=Status)||("GS"=Status) s StatusDesc=""
	s:(""=Status) StatusList=StatusList_";"_"GSend"_"^"_"统取"

	i ("ISend"=Status)||("IS"=Status) s StatusDesc="自取"
	s:(""=Status) StatusList=StatusList_";"_"ISend"_"^"_"自取"

	Q:(""'=StatusList) StatusList
	Q StatusDesc
}

/// 获取结算方式的含义 如果不输入结算方式的含义编码则得到含义数组
/// w ##Class(web.DHCPE.PreCommon).TransDisChargedMode()
ClassMethod TransDisChargedMode(Status As %String = "")
{
	s StatusDesc=""
	s StatusList=""
	i ("GDischarged"=Status)||("GD"=Status) s StatusDesc="统结"
	s:(""=Status) StatusList=StatusList_";"_"GDischarged"_"^"_"统结"

	i ("Idischarged"=Status)||("ID"=Status) s StatusDesc="自结"
	s:(""=Status) StatusList=StatusList_";"_"Idischarged"_"^"_"自结"

	Q:(""'=StatusList) StatusList
	Q StatusDesc
}

/// w ##Class(web.DHCPE.PreCommon).TransAddOrdItem("IA")
ClassMethod TransAddOrdItem(Status As %String = "")
{
	q:Status=""
	s StatusDesc=""
	s StatusList=""
	i ("GAddOrdItem"=Status)||("GA"=Status)||("Y"=Status) s StatusDesc="公费"

	i ("IAddOrdItem"=Status)||("IA"=Status)||("N"=Status) s StatusDesc="自费"

	Q:(""'=StatusList) StatusList
	Q StatusDesc
}

ClassMethod TransGReportSend(Status As %String = "")
{
	s StatusDesc=""
	s StatusList=""
	i ("AsCharged"=Status)||("AC"=Status) s StatusDesc="挂帐可取"
	s:(""=Status) StatusList=StatusList_";"_"AsCharged"_"^"_"挂帐可取"

	i ("Discharged"=Status)||("DC"=Status) s StatusDesc="结帐取"
	s:(""=Status) StatusList=StatusList_";"_"Discharged"_"^"_"结帐取"

	Q:(""'=StatusList) StatusList
	Q StatusDesc
}

/// 生成一个页面元素　显示职业列表 
/// 使用模块
/// 		DHCPEPreIBaseInfo.Edit 
/// d ##class(web.DHCPE.PreCommon).OutVocationToHTML()
ClassMethod OutVocationToHTML(ContrlWidth As %String = "") As %String
{
	s:(""=ContrlWidth) ContrlWidth="155"
	//下拉列表
	//w "<select name='Vocation' id='Vocation' style='width:"_ContrlWidth_"' HEIGHT=0 tabIndex=0>",!
	w ##class(web.DHCPE.DHCPECommon).GetDefaultStyleNoEdit("Vocation","")
	w "<option value=''>  </option>",!
	
	w "<option value='商务人员'>商务人员</option>",!
	w "<option value='公务人员及职员'>公务人员及职员</option>",!
	w "<option value='离退休人员'>离退休人员</option>",!
	w "<option value='干部'>干部</option>",!
	w "<option value='其他'>其他</option>",!
		
	w "</select>",!
	Quit $$$OK
}

/// 生成一个页面元素　显示性别列表 
/// 使用模块
/// 		DHCPEPreIBaseInfo.Edit
/// d ##class(web.DHCPE.PreCommon).OutSexToHTML()
ClassMethod OutSexToHTML(ContrlWidth As %String = "", DefaultValue As %String = "", tabIndex As %String = "0") As %String
{
	s:(""=ContrlWidth) ContrlWidth="155"
	//下拉列表
	//w "<select name='Sex_DR_Name' id='Sex_DR_Name' style='width:"_ContrlWidth_"' HEIGHT=0  tabIndex="_tabIndex_">",!
	w ##class(web.DHCPE.DHCPECommon).GetDefaultStyleNoEdit("Sex_DR_Name","")
	w "<option value=''>  </option>",!
	s id=0
	f  s id=$O(^CT("SEX",id)) q:id=""  d
	.w "<option value='"_id_"'>"_$P($G(^CT("SEX",id)),"^",2)_"</option>",!
		
	w "</select>",!
	Quit $$$OK
}

/// 生成一个页面元素　显示性别列表 
/// 使用模块
/// 		DHCPEPreIBaseInfo.Edit
/// d ##class(web.DHCPE.PreCommon).OutNewSexToHTML(150,)
ClassMethod OutNewSexToHTML(ContrlWidth As %String = "", DefaultValue As %String = "", tabIndex As %String = "0") As %String
{
  
	w !,DefaultValue
	s:(""=ContrlWidth) ContrlWidth="155"
	//下拉列表
	w "<select name='SexDR' id='SexDR' style='width:"_ContrlWidth_"' HEIGHT=0  tabIndex="_tabIndex_">",!
	w "<option value=''>  </option>",!
	s id=0
	f  s id=$O(^CT("SEX",id)) q:id=""  d
	.s selected=""
	.s:DefaultValue=id selected="selected"
	.w "<option value='"_id_"'>"_$P($G(^CT("SEX",id)),"^",2)_"</option>",!	
	w "</select>",!
	Quit $$$OK
}

/// 生成一个页面元素　显示民族列表 
/// 使用模块
/// 		DHCPEPreIBaseInfo.Edit
/// d ##class(web.DHCPE.PreCommon).OutCTNationToHTML(150,)
ClassMethod OutCTNationToHTML(ContrlWidth As %String = "", DefaultValue As %String = "", tabIndex As %String = "0") As %String
{
  
	w !,DefaultValue
	s:(""=ContrlWidth) ContrlWidth="155"
	//下拉列表
	//w "<select name='CTNationDR' id='CTNationDR' style='width:"_ContrlWidth_"' HEIGHT=0  tabIndex="_tabIndex_">",!
	w ##class(web.DHCPE.DHCPECommon).GetDefaultStyleNoEdit("CTNationDR","")
	w "<option value=''>  </option>",!
	
	s myRowID=0
	f  s myRowID=$o(^CT("NAT", myRowID))  q:(myRowID="")  d
	.s myCode=$p(^CT("NAT", myRowID),"^",1)
	.s myDesc=$p(^CT("NAT", myRowID),"^",2)
	.s selected=""
	.s:DefaultValue=myRowID selected="selected"
	.w "<option value='"_myRowID_"'>"_$P($G(^CT("NAT", myRowID)),"^",2)_"</option>",!
		
	w "</select>",!
	Quit $$$OK
}

/// 生成一个页面元素　显示婚姻状况列表
/// 使用模块
/// 		DHCPEPreIBaseInfo.Edit
/// d ##class(web.DHCPE.PreCommon).OutMarriedToHTML()
ClassMethod OutMarriedToHTML(ContrlWidth As %String = "", tabIndex As %String = "0") As %String
{
	s:(""=ContrlWidth) ContrlWidth="155"
	//下拉列表
	//w "<select name='Married_DR_Name' id='Married_DR_Name' style='width:"_ContrlWidth_"' HEIGHT=0 tabIndex="_tabIndex_">",!
	w ##class(web.DHCPE.DHCPECommon).GetDefaultStyleNoEdit("Married_DR_Name","")
	w "<option value=''>  </option>",!
	s id=0
	f  s id=$O(^CT("MAR",id)) q:id=""  d
	.
	.w "<option value='"_id_"'>"_$P($G(^CT("MAR",id)),"^",2)_"</option>",!
		
	w "</select>",!
	Quit $$$OK
}

/// 使用模块
/// 		DHCPEPreIBaseInfo.Edit
/// 生成一个页面元素　显示当前的团体组列表 使用组件
/// d ##class(web.DHCPE.PreCommon).OutVocationToHTML()
ClassMethod OutBloodToHTML(ContrlWidth As %String = "") As %String
{
	s:(""=ContrlWidth) ContrlWidth="155"
	//下拉列表
	//w "<select name='Blood_DR_Name' id='Blood_DR_Name' style='width:"_ContrlWidth_"' HEIGHT=0 tabIndex=0>",!
	w ##class(web.DHCPE.DHCPECommon).GetDefaultStyleNoEdit("Blood_DR_Name","")
	w "<option value=''>  </option>",!
	s id=0
	f  s id=$O(^PAC("BLDT",id)) q:id=""  d
	.
	.w "<option value='"_id_"'>"_$P($G(^PAC("BLDT",id)),"^",2)_"</option>",!
		
	w "</select>",!
	Quit $$$OK
}

/// 
/// 视同收费
ClassMethod OutAsChargedToHTML(ContrlWidth As %String = "", DefaultValue As %String = "") As %String
{
	s:(""=ContrlWidth) ContrlWidth="155"
	s (NoAsCharged,AsCharged,AsCharged1,AsCharged2,AsCharged3)=""
	//下拉列表
	//w "<select name='IFSTSF' id='IFSTSF' style='width:"_ContrlWidth_"' HEIGHT=0 tabIndex=0>",!
	w ##class(web.DHCPE.DHCPECommon).GetDefaultStyle("IFSTSF","")
	s:DefaultValue="0" NoAsCharged=" selected"
	s:DefaultValue="1" AsCharged=" selected"
	s:DefaultValue="1^1" AsCharged1=" selected"
	s:DefaultValue="1^2" AsCharged2=" selected"
	s:DefaultValue="1^3" AsCharged3=" selected"
	w "<option value=''>  </option>",!
	s id=0
	w "<option value='0'"_NoAsCharged_">"_"否"_"</option>",!
	w "<option value='1'"_AsCharged_">"_"全部视同收费"_"</option>",!
	w "<option value='1^1'"_AsCharged1_">"_"遗留视同收费"_"</option>",!
	w "<option value='1^2'"_AsCharged2_">"_"特批视同收费"_"</option>",!
	w "<option value='1^3'"_AsCharged3_">"_"其它视同收费"_"</option>",!
	w "</select>",!
	Quit $$$OK
}

/// 使用模块
/// 		DHCPEPreIBaseInfo.Edit
/// 生成一个页面元素　显示当前的团体组列表 使用组件
/// d ##class(web.DHCPE.PreCommon).OutVocationToHTML()
ClassMethod OutPatTypeToHTML(ContrlWidth As %String = "") As %String
{
	s:(""=ContrlWidth) ContrlWidth="155"
	//下拉列表
	//w "<select name='PatType_DR_Name' id='PatType_DR_Name' style='width:"_ContrlWidth_"' HEIGHT=0 tabIndex=0>",!
	w ##class(web.DHCPE.DHCPECommon).GetDefaultStyleNoEdit("PatType_DR_Name","")
	w "<option value=''></option>",!
	s id=0
	f  s id=$O(^CT("SS",id)) q:id=""  d
	.
	.w "<option value='"_id_"'>"_$P($G(^CT("SS",id)),"^",2)_"</option>",!
		
	w "</select>",!
	Quit $$$OK
}

/// d ##class(web.DHCPE.PreCommon).OutPatFeeTypeToHTML()
ClassMethod OutPatFeeTypeToHTML(ContrlWidth As %String = "", tabIndex As %String = "") As %String
{
	s:(""=ContrlWidth) ContrlWidth="155"
	//下拉列表
	;w "<select name='PatFeeType_DR_Name' id='PatFeeType_DR_Name' style='width:"_ContrlWidth_"' HEIGHT=0 tabIndex="_tabIndex_">",!
	w ##class(web.DHCPE.DHCPECommon).GetDefaultStyle("PatFeeType_DR_Name","")
	w "<option value=''></option>",!
	s id=0
	f  s id=$O(^PAC("SUBT",id)) q:id=""  d
	.;q:((id'=6)&&(id'=8))
	.s Desc=$P($G(^PAC("SUBT",id)),"^",2)
	.;s Desc=##class(web.DHCPE.Public.Setting).Replace(Desc,"病人","客人")
	.w "<option value='"_id_"'>"_Desc_"</option>",!	
	w "</select>",!
	Quit $$$OK
}

/// 预约病人类型下拉框
ClassMethod OutPreTypeToHTML(ContrlWidth As %String = "") As %String
{
	s:(""=ContrlWidth) ContrlWidth="155"
	//下拉列表
	w "<select name='Type' id='Type' style='width:"_ContrlWidth_"' HEIGHT=0>",!
	w "<option value=''>  </option>",!
	s HospitalCode=$G(^DHCPESetting("DHCPE","HospitalCode"))
	i HospitalCode="AZ"
	{
		s id=1,Type=..GetPreTypeDesc(id)
		d OneType
		s id=2,Type=..GetPreTypeDesc(id)
		d OneType
		s id=3,Type=..GetPreTypeDesc(id)
		d OneType
	}
	else
	{
		s id=1,Type=..GetPreTypeDesc(id)
		d OneType
		s id=2,Type=..GetPreTypeDesc(id)
		d OneType
		s id=3,Type=..GetPreTypeDesc(id)
		d OneType
	}
	
	/*
	s id=0
	f  s id=$O(^CT("SEX",id)) q:id=""  d
	.
	.w "<option value='"_id_"'>"_$P($G(^CT("SEX",id)),"^",2)_"</option>",!*/
		
	w "</select>",!
	Quit $$$OK
	
OneType
	w "<option value='"_id_"'>"_Type_"</option>",!
	q
}

/// ##class(web.DHCPE.PreCommon).GetPreTypeDesc(id)
ClassMethod GetPreTypeDesc(id)
{
	q id
	new Desc
	s Desc=""
	s HospitalCode=$G(^DHCPESetting("DHCPE","HospitalCode"))
	i HospitalCode="AZ"
	{
		s:id=1 Desc="招工"
		s:id=2 Desc="贵宾"
		s:id=3 Desc="特殊"
	}
	else
	{
		s:id=1 Desc="招工"
		s:id=2 Desc="贵宾"
		s:id=3 Desc="特殊"
	}
	q Desc
}

/// 团体预约支付类型
ClassMethod OutPayTypeToHTML(ContrlWidth As %String = "") As %String
{
	s:(""=ContrlWidth) ContrlWidth="155"
	//下拉列表
	w "<select name='payType' id='PayType' style='width:"_ContrlWidth_"' HEIGHT=0>",!
	w "<option value=''>  </option>",!
	s HospitalCode=$G(^DHCPESetting("DHCPE","HospitalCode"))
	i HospitalCode="AZ"
	{
		s id=1,Type=..GetPayTypeDesc(id)
		d OnePayType
		s id=2,Type=..GetPayTypeDesc(id)
		d OnePayType
		s id=3,Type=..GetPayTypeDesc(id)
		d OnePayType
		s id=4,Type=..GetPayTypeDesc(id)
		d OnePayType
	}
	else
	{
		s id=1,Type=..GetPayTypeDesc(id)
		d OnePayType
		s id=2,Type=..GetPayTypeDesc(id)
		d OnePayType
		s id=3,Type=..GetPayTypeDesc(id)
		d OnePayType
		s id=4,Type=..GetPayTypeDesc(id)
		d OnePayType
	}
	
	/*
	s id=0
	f  s id=$O(^CT("SEX",id)) q:id=""  d
	.
	.w "<option value='"_id_"'>"_$P($G(^CT("SEX",id)),"^",2)_"</option>",!
	*/
		
	w "</select>",!
	Quit $$$OK
	
OnePayType
	w "<option value='"_id_"'>"_Type_"</option>",!
	q
}

/// ##class(web.DHCPE.PreCommon).GetPayTypeDesc(id)
ClassMethod GetPayTypeDesc(id)
{
	new Desc
	s Desc=""
	s HospitalCode=$G(^DHCPESetting("DHCPE","HospitalCode"))
	i HospitalCode="AZ"
	{
		s:id=1 Desc="现金一次付"
		s:id=2 Desc="现金百分比"
		s:id=3 Desc="支票一次付"
		s:id=4 Desc="空白支票"
	}
	else
	{
		s:id=1 Desc="现金一次付"
		s:id=2 Desc="现金百分比"
		s:id=3 Desc="支票一次付"
		s:id=4 Desc="空白支票"
	}
	q Desc
}

ClassMethod OutHcpdrHTML(ContrlWidth As %String = "") As %String
{
	s:(""=ContrlWidth) ContrlWidth="155"
	/*
	w "<select   name='select' style='position:absolute;   left:   10px;   top:   10px;   width:   120px;   height:   20px;   clip:   rect(0   120   21   100)'   id='select'   onchange='textfield.value=select.value;textfield.select()'>",!   
    w "<option   value='aaaaaaaa'>aaaaaaaa</option>",!   
    w "<option   value='bbbbbbbb'>bbbbbbbb</option>",!   
    w "<option   value='cccccccc'>cccccccc</option>",!   
    w "</select>",!   
    w "<input   type='text'   style='position:absolute;   left:   10px;   top:   10px;   width:   100px;   height:   21px'   name='textfield'>",!

	Quit $$$OK
	*/
	//下拉列表
	w "<select name='hcpdr' id='hcpdr' style='width:"_ContrlWidth_"' HEIGHT=0>",!
	w "<option value=''>  </option>",!
	s id=0
	f  s id=$O(^CT("HCP",id)) q:id=""  d
	.
	.w "<option value='"_id_"'>"_$p($P($G(^CT("HCP",id)),"^",2),"-",2)_"</option>",!
		
	w "</select>",!
	Quit $$$OK
}

/// 向界面输出健康地区
ClassMethod OutHCRToWeb(ContrlWidth As %String = "") As %String
{
	s:(""=ContrlWidth) ContrlWidth="155"
	w "<select name='HCRDR' id='HCRDR' style='width:"_ContrlWidth_"' HEIGHT=0>",!
	w "<option value=''>  </option>",!
	s id=0
	f  s id=$O(^CT("HCR",id)) q:id=""  d
	.
	.w "<option value='"_id_"'>"_$P($G(^CT("HCR",id)),"^",2)_"</option>",!
		
	w "</select>",!
	Quit $$$OK
}

/// 查询健康区域
Query SearchHCAList(HCRDR As %Library.String = "") As %SQLQuery(ROWSPEC = "HCA_Desc:%String, HCA_Code:%String, HCA_RowId:%String")
{
SELECT HCA_Desc,HCA_Code,HCA_RowId 
FROM CT_HealthCareArea
where HCA_HCR_DR = :HCRDR
}

/// 查询合同单位
Query SearchHCPList(HCADR As %Library.String = "") As %SQLQuery(ROWSPEC = "HCP_Desc:%String, HCP_Code:%String, HCP_RowId:%String")
{
SELECT HCP_Desc,HCP_Code,HCP_RowId 
FROM CT_HealthCareProvider
where HCP_HCA_DR = :HCADR
}

/*
ClassMethod GetVIPLevel(Type, ID)
{
	;##class(web.DHCPE.PreCommon).GetVIPLevel("IADM", ID)
	n (Type, ID)
	s ret=""
	i Type="Pre" d
	.d PreVIP(ID)
	i Type="PAADM" d
	.s IADM=$O(^DHCPEIADM(0,"PAADM",ID,0))
	.d IADMVIP(IADM)
	i Type="IADM" d
	.d IADMVIP(ID)
	i ret="" d
	.s ret=$G(^DHCPEVIPLevel("VIPapprove"))
	.s ret=ret_"^"_$P(^DHCPEVIPLevel("VIP",ret),"^",2)
	q ret
IADMVIP(IADM)
	q:IADM=""
	s PreIADM=$P(^DHCPEIADM(IADM),"^",4)
	d PreVIP(PreIADM)
	q
PreVIP(PreID)
	s VIPLevel=$P($g(^DHCPEPreIADM(PreID)),"^",18)
	q:VIPLevel=""
	s VIPDesc=$P(^DHCPEVIPLevel("VIP",VIPLevel),"^",2)
	s ret=VIPLevel_"^"_VIPDesc
	q
}
*/
/// Creator：     xy 
/// CreatDate：   20210820
/// Description:  获取客户VIP等级
/// Table：       VIP等级表 DHC_PE_VIPLevel 
/// Input:        Type（类型:Pre,PAADM,IADM）, ID(类型对应的ID)
/// Return：      return=VIPID^VIP描述
/// debug:  w ##class(web.DHCPE.PreCommon).GetVIPLevel("IADM", ID)
ClassMethod GetVIPLevel(Type, ID)
{
	n (Type, ID)
	s ret="",ADMLocDR=""
	i Type="Pre" d
	.d PreVIP(ID)
	i Type="PAADM" d
	.s IADM=$O(^DHCPEIADM(0,"PAADM",ID,0))
	.d IADMVIP(IADM)
	i Type="IADM" d
	.d IADMVIP(ID)
	
	i (ret="")&&(ADMLocDR'="") d
	.s ret=##class(web.DHCPE.CT.VIPLevel).GetDefaultVIP(ADMLocDR)
	.s ret=ret_"^"_$lg($g(^CT.PE.VIPLevelD(ret)),3)
	q ret
IADMVIP(IADM)
	q:IADM=""
	s PreIADM=$P(^DHCPEIADM(IADM),"^",4)
	d PreVIP(PreIADM)
	q
PreVIP(PreID)
	s VIPLevel=$P($g(^DHCPEPreIADM(PreID)),"^",18)
	q:VIPLevel=""
	s ADMLocDR=$P($g(^DHCPEPreIADM(PreID)),"^",26) //就诊科室
	s VIPDesc=$lg($g(^CT.PE.VIPLevelD(VIPLevel)),3) //VIP描述
	s ret=VIPLevel_"^"_VIPDesc
	q
}

/// Add By wrz At 2008-02-22
/// 前三种类型得到此人之前的体检次数、后两种得到此人的总体检次数
/// w ##class(web.DHCPE.PreCommon).GetReCheckFlag(394,"PAADM")
/// id:对应类型数据的RowID
/// Type:   "PreADM"   预约ADM号(返回之前次数)
///        	"PEADM"    到达后ADM号
///        	"PAADM"    
///        	"RegNo"    登记号(返回总次数)
///        	"PIBI"     基本信息表id
///        	
ClassMethod GetReCheckFlag(id, Type)
{
	s ^lisatest("0610","GetReCheckFlag")=id_"^"_Type
	Quit:id="" ""
	s ReCheckCount=0
	
	i Type="PAADM" d
	.d PAADM
	e  i Type="PEADM" d
	.d PEADM(id)
	e  i Type="PreADM" d
	.d PreADM(id)
	e  i Type="RegNo" d
	.d RegNo(id,"")
	e  i Type="PIBI" d
	.d GetCount(id,"")
	
	q ReCheckCount
PAADM
	s peid=$o(^DHCPEIADM(0,"PAADM",id,0))
	q:peid=""
	d PEADM(peid)
	q
PEADM(PEADM)
 	s preid=$p(^DHCPEIADM(PEADM),"^",4)
 	q:preid=""
 	d PreADM(preid)
	q
PreADM(PreADM)
	s baseinfoid=$p($G(^DHCPEPreIADM(PreADM)),"^",1)
	q:baseinfoid=""
	d GetCount(baseinfoid,PreADM)
	q
RegNo(RegNo,PreIADMID)
	s baseinfoid=$o(^DHCPEPreIBI(0,"PAPMINo",RegNo,0))
	q:baseinfoid=""
	d GetCount(baseinfoid,"")
	q
 //得到之前体检总次数
GetCount(BaseInfoID,PreIADM)
	f  s PreIADM=$o(^DHCPEPreIADM(0,"PIBI",BaseInfoID,PreIADM),-1)  q:PreIADM=""  d
	.s Status=$p($G(^DHCPEPreIADM(PreIADM)),"^",8)
	.q:Status'="ARRIVED"
	.s ReCheckCount=ReCheckCount+1
	
	q
}

/// IsFeeLocFlag: 收费是否按科室过滤
/// w ##class(web.DHCPE.PreCommon).GetLocFlag("PAADM","","")
ClassMethod GetLocFlag(Type, id, LocID As %Library.String = "", IsFeeLocFlag As %Library.String = "Y")
{
	Quit:id="" ""
	s flag=1
	i LocID="" d
	.s:$d(%session) LocID=%session.Get("LOGON.CTLOCID")
	.s:'$d(%session) LocID=370
	

	i Type="SPEC" d
	.d SPEC(id)
	e  i Type="PAADM" d
	.d PAADM1(id)
	e  i Type="PEADM" d
	.d PEADM1(id)
	e  i Type="PreADM" d
	.d PreADM1(id)
	e  i Type="PGADM" d
	.d PEPGADM(id)
	e  i Type="GADM" d
	.d PEGADM(id)
	e  i Type="GIBI" d
	.d PEGIBI(id)
	e  i Type="ITEM" d
	.d ITEM(id)
	e  i Type="ORDSET" d
	.d ORDSET(id)
	e  i Type="ED" d
	.d ED(id)
	e  i Type="APAC" d
	.d APAC
	e  i Type="RP" d
	.d RPReport
	e  i Type="Contract" d
	.d Contract(id)
	
	q flag
RPReport
	s CurUserID=%session.Get("LOGON.USERID") 
	s CurHos=$P(^SSU("SSUSR",CurUserID),"^",98)
	
	s UserID=$P(^DHCPEUSERREPORT(id),"^",1)
	s UserHos=$P(^SSU("SSUSR",UserID),"^",98)
	i (CurHos=UserHos) s flag=0
	q
	
	s InvID=$O(^DHCPEINVPRT(0,"REPORT",id,0))
	s PAADM=$P(^DHCPEINVPRT(InvID),"^",2)
	s UserLoc=$P(^PAADM(PAADM),"^",4)
	;i (UserLoc=LocID) s flag=0
	s UserHos=$P(^CTLOC(UserLoc),"^",22)
	s LocHos=$P(^CTLOC(LocID),"^",22)
	i (UserHos=LocHos) s flag=0
	q
APAC
	s UserLoc=$p(^DHCPEAP(+id,"AC",$P(id,"||",2)),"^",12)
  	i (UserLoc=LocID) s flag=0
  	q
SPEC(id)
	s OrderID=$O(^OEORD(0,"EpisNo",id,0))
	q:OrderID=""
	s AdmID=$P(^OEORD(OrderID),"^",1)
	d PAADM1(AdmID)
	q 
ED(id)
    s LocID=##class(web.DHCPE.DHCPECommon).GetEDloc(LocID)
	s edLocsub=0
	f  s edLocsub=$O(^DHCPEED(id,"EDL",edLocsub)) q:edLocsub=""  d
	.s edLocID=$P(^DHCPEED(id,"EDL",edLocsub),"^",1)
	.i edLocID=LocID s flag=0
	q
PAADM1(id)
	
	s UserLoc=$P($G(^PAADM(id)),"^",4)
	i (UserLoc=LocID) s flag=0
	
	S HospID=$p($g(^CTLOC(LocID)),"^",22)
	S UserHospID=$p($g(^CTLOC(UserLoc)),"^",22)
	i (UserLoc'=LocID)&&(IsFeeLocFlag="N")&&(HospID=UserHospID) s flag=0

	q
	s peid=$o(^DHCPEIADM(0,"PAADM",id,0))
	q:peid=""
	d PEADM1(peid)
	q
PEADM1(PEADM)
 	s preid=$p(^DHCPEIADM(PEADM),"^",4)
 	q:preid=""
 	d PreADM1(preid)
	q
PreADM1(PreADM)
	s UserLoc=$p(^DHCPEPreIADM(PreADM),"^",26)
	i (UserLoc=LocID) s flag=0
	S HospID=$p($g(^CTLOC(LocID)),"^",22)
	S UserHospID=$p($g(^CTLOC(UserLoc)),"^",22)
	i (UserLoc'=LocID)&&(IsFeeLocFlag="N")&&(HospID=UserHospID) s flag=0

	q	
PEGIBI(GID)
 	s GADM=0
 	f  s GADM=$o(^DHCPEGADM(0,"GBI",GID,GADM))  q:GADM=""  d 
 	.d PEGADM(GADM)
 	q 
PEGADM(GADM)
	;q:GADM=0
	q:$d(^DHCPEGADM(GADM))=10
    S PGADM=$P(^DHCPEGADM(GADM),"^",2)
	d PEPGADM(PGADM)
	q
PEPGADM(PGADM)
	s GDepLoc=$p($G(^DHCPEPreGADM(PGADM)),"^",23)
	i (GDepLoc=LocID) s flag=0
	
	S HospID=$p($g(^CTLOC(LocID)),"^",22)
	S GHospID=$p($g(^CTLOC(GDepLoc)),"^",22)
	i (GDepLoc'=LocID)&&(IsFeeLocFlag="N")&&(HospID=GHospID) s flag=0

	//i (GDepLoc'=LocID)&&(IsFeeLocFlag="N") s flag=0
   	q

ITEM(ItemID)
	s:$O(^DHCPEST(+ItemID,"O",$p(ItemID,"||",2),"STORDL",0))="" flag=0
	s STORDLChildsub=0
	f  s STORDLChildsub=$O(^DHCPEST(+ItemID,"O",$p(ItemID,"||",2),"STORDL",STORDLChildsub)) q:(STORDLChildsub="")||(flag=0)  d
	.s STORDLLocDR=$p(^DHCPEST(+ItemID,"O",$p(ItemID,"||",2),"STORDL",STORDLChildsub),"^",1)
	.s:STORDLLocDR=LocID flag=0
	q 
ORDSET(SetID)
	/*
	s:'$D(^DHCPEDataEx("DHCPEBaseData","PEARCOS",SetID,"LOC")) flag=0
	s DepLoc=0                                                               
	f  s DepLoc=$o(^DHCPEDataEx("DHCPEBaseData","PEARCOS",SetID,"LOC",DepLoc))  q:(DepLoc="")||(flag=0)  d
	.s:DepLoc=LocID flag=0
	*/
	s LocStr=$p($g(^DHCPEOSE(SetID)),"^",7)
	s:LocStr="" flag=0
	s len=$l(LocStr,",")
	f i=1:1:len d
	.q:($p(LocStr,",",i)="")||(flag=0)
	.s:LocID=$p(LocStr,",",i) flag=0
	q

	
Contract(id)
	s ConLoc=$LG(^User.DHCPEContractD(id),8)
	i (ConLoc=LocID) s flag=0
	q
}

ClassMethod OutInsUnitToHTML(ContrlWidth As %String = "") As %String
{
	s:(""=ContrlWidth) ContrlWidth="155"
	//下拉列表
	w "<select name='InsureUnit' id='InsureUnit' style='width:"_ContrlWidth_"' HEIGHT=0 tabIndex=0>",!
	w "<option value=''>  </option>",!
	s id=0
	f  s id=$O(^ARC("INST", id)) q:id=""  d
	.w "<option value='"_id_"'>"_$P($G(^ARC("INST", id)),"^",2)_"</option>",!
		
	w "</select>",!
	Quit $$$OK
}

ClassMethod OutCheckRoomToHTML(ContrlWidth As %String = "") As %String
{
	s:(""=ContrlWidth) ContrlWidth="155"
	//下拉列表
	w "<select name='CheckRoom' id='CheckRoom' style='width:"_ContrlWidth_"' HEIGHT=0 tabIndex=0>",!
	w "<option value=''>  </option>",!
	s Loc=%session.Get("LOGON.CTLOCID")
	s id=0
	f  s id=$O(^DHCPEDataEx("RoomCheck",Loc,id)) q:id=""  d
	.s Str=$G(^DHCPEDataEx("RoomCheck",Loc,id))
	.s Flag=$P(Str,"^",4)
	.q:Flag="0"
	.s Desc=$P(Str,"^",1)
	.w "<option value='"_id_"'>"_Desc_"</option>",!
		
	w "</select>",!
	Quit $$$OK
}

/// Description: 获取诊室位置
/// Input: Type（类型：PreADM/PGTADM）,ID（预约ID）
/// Debug：w ##class(web.DHCPE.PreCommon).GetRoomPlace()
ClassMethod GetRoomPlace(Type, ID)
{
	s RoomPlace=""
	q:ID="" RoomPlace
	i Type="PreADM" d
	.s RoomPlaceId=$G(^DHCPEDataEx("DHCPEPreIADM","RoomPlace",ID)) 
	.q:RoomPlaceId=""
	.;s RoomPlace=$P($G(^DHCPECTDataEx("RoomPlace",RoomPlaceId)),"^",2)
	.//诊室位置表(多院区) DHC_PE_RoomPlace
	.s RoomPlace=$lg($g(^CF.PE.RoomPlaceD(RoomPlaceId)),3) 
	
	i Type="PGTADM" d
	.s RoomPlaceId=$g(^DHCPEDataEx("DHCPEPreGTeam","RoomPlace",ID)) 
	.q:RoomPlaceId=""
	.;s RoomPlace=$P($G(^DHCPECTDataEx("RoomPlace",RoomPlaceId)),"^",2)
	.//诊室位置表(多院区) DHC_PE_RoomPlace
	.s RoomPlace=$lg($g(^CF.PE.RoomPlaceD(RoomPlaceId)),3) 
	q RoomPlace
}

ClassMethod GetPosition(Type, ID)
{
	s Position=""
	q:ID="" Position
	i Type="PAADM" d
	.s IADM=$O(^DHCPEIADM(0,"PAADM",ID,0))
	.q:IADM=""
	.d ..GetPosition("IADM",IADM)
	i Type="IADM" d
	.s PreADM=$p($G(^DHCPEIADM(ID)),"^",4)
	.q:PreADM=""
	.d ..GetPosition("PreADM",PreADM)
	i Type="PreADM" d
	.s Position=$G(^DHCPEDataEx("DHCPEPreIADM","Position",ID))
	.i Position="" d
	..s IBIID=$p($G(^DHCPEPreIADM(ID)),"^",1)
	..s Position=$p($G(^DHCPEPreIBI(IBIID)),"^",11)
	.;.s:Position'="" ^DHCPEDataEx("DHCPEPreIADM","Position",ID)=Position
	.;s IBIID=$p($G(^DHCPEPreIADM(ID)),"^",1)
	.;q:IBIID=""
	.;d ..GetPosition("IBI",IBIID)
	i Type="REG" d
	.s IBIID=$o(^DHCPEPreIBI(0,"PAPMINo",ID,0))
	.q:IBIID=""
	.d ..GetPosition("IBI",IBIID)
	i Type="IBI" d
	.q:ID=""
	.s Position=$p($G(^DHCPEPreIBI(ID)),"^",11)
	q Position
}

ClassMethod OutDiagnosisLevelToHTML(ContrlWidth As %String = "") As %String
{
	s:(""=ContrlWidth) ContrlWidth="155"
	//下拉列表
	w "<select name='ILLLevel' id='ILLLevel' style='width:"_ContrlWidth_"' HEIGHT=0 tabIndex=0>",!
	w "<option value=''>  </option>",!
	s id=0
	f  s id=$O(^DHCPEEDC(id)) q:id=""  d
	.q:$g(^DHCPEDataEx("DHCPEDiagnosisLevel",id))'="Y"
	.w "<option value='"_id_"'>"_$P($G(^DHCPEEDC(id)),"^",1)_"  "_$P($G(^DHCPEEDC(id)),"^",2)_"</option>",!
		
	w "</select>",!
	Quit $$$OK
}

ClassMethod OutTeamLevelToHTML(ContrlWidth As %String = "") As %String
{
	s:(""=ContrlWidth) ContrlWidth="155"
	//下拉列表
	w "<select name='TeamLevel' id='TeamLevel' style='width:"_ContrlWidth_"' HEIGHT=0>",!
	w "<option value=''>  </option>",!
	w "<option value='A'>A</option>",!
	w "<option value='B'>B</option>",!
	w "<option value='C'>C</option>",!
	w "<option value='D'>D</option>",!
	w "</select>",!
	Quit $$$OK
}

// s val=##class(web.DHCPE.PreCommon).CreatPatFeeType("TItemFeeTypez7","6")

ClassMethod CreatPatFeeType(ItemColName As %String, ItemValue As %String, ColWidth As %String = "") As %String
{
	i ColWidth="" s ColWidth=180
	set AddtionStr=""
	Do SelectBox
	Quit ""
	
SelectBox
	Write "<select id='"_ItemColName_"' name='"_ItemColName_"' size=1 style='WIDTH: "_ColWidth_"px; HEIGHT: 24px'"_AddtionStr_">"
	Write "<option  value=''></option>"
		
	s id=0
	f  s id=$O(^PAC("SUBT",id)) q:id=""  d
	.Set ListVal=$P($G(^PAC("SUBT",id)),"^",2)
	.If ListVal=ItemValue Write "<option value="_id_" selected>"_ListVal_"</option>"
	.Else  Write "<option value="_id_">"_ListVal_"</option>"
	Write "</select>"
	Quit
}

ClassMethod OutReCheck(ContrlWidth As %String = "", DefaultValue As %String = "") As %String
{

	s:(""=ContrlWidth) ContrlWidth="120"
	s (Re,NoRe)=""
	s DefaultValue=$P(DefaultValue,"^",1)
	s:DefaultValue="0" NoRe=" selected"
	s:DefaultValue="1" Re=" selected"
	s:(DefaultValue="") NoRe=" selected"
	//下拉列表
	//w "<select name='ReCheck' id='ReCheck' style='width:"_ContrlWidth_"' HEIGHT=0>",!
	w ##class(web.DHCPE.DHCPECommon).GetDefaultStyle("ReCheck","")
	w "<option value=''></option>",!
	w "<option value='1'"_Re_">复查</option>",!
	w "<option value='0'"_NoRe_">非复查</option>",!
	w "</select>",!
	Quit $$$OK
}

ClassMethod OutReCheckPS(ContrlWidth As %String = "", DefaultValue As %String = "") As %String
{
	;DHCPEPersonStatistic
	s:(""=ContrlWidth) ContrlWidth="120"
	s (RePS,NoRePS)=""
	s DefaultValue=$P(DefaultValue,"^",1)
	s:DefaultValue="0" NoRePS=" selected"
	s:DefaultValue="1" RePS=" selected"
	;s:(DefaultValue="") NoRePS=" selected"
	//下拉列表
	w "<select name='ReCheck' id='ReCheck' style='width:"_ContrlWidth_"' HEIGHT=0>",!
	w "<option value=''></option>",!
	w "<option value='1'"_RePS_">复查</option>",!
	w "<option value='0'"_NoRePS_">非复查</option>",!
	w "</select>",!
	Quit $$$OK
}

// 判断是否复检  1:复检  0:非复检

/// /w ##class(web.DHCPE.PreCommon).IsReCheck("ID","Type")
ClassMethod IsReCheck(ID, Type, LocID As %String = "")
{
	n (ID,Type,LocID)
	s ret="1"
	i Type="IADM" d
	.s PreID=$P(^DHCPEIADM(ID),"^",4)
	.d PreReCheck(PreID)
	i Type="Pre" d
	.d PreReCheck(ID)
	
	q ret
PreReCheck(PreIADM)
	s ReCheckFlag=$P(^DHCPEPreIADM(PreIADM),"^",28)
	//s:ReCheckFlag="Y" ret="1"
	//s:ReCheckFlag'="Y" ret="0"
	//s ReportPrint=$G(^DHCPESetting("DHCPE","MainReportPrint"))
	i LocID = ""  s LocID = $P(^DHCPEPreIADM(PreIADM),"^",26)
	s ReportPrint=$G(^DHCPESetting("DHCPE","MainReportPrint",LocID))
	i (ReCheckFlag="Y") d
	.i ReportPrint="N" d
	..s ret="1"
	.e  d
	..s ret="0"
	s:ReCheckFlag'="Y" ret="0"

	q
}

/// 发票类型：非预交金、预交金
/// w ##class(web.DHCPE.PreCommon).OutInvType("","")
ClassMethod OutInvType(ContrlWidth As %String = "", DefaultValue As %String = "") As %String
{
	;DHCPEPersonStatistic
	s:(""=ContrlWidth) ContrlWidth="120"
	s (Advance,NoAdvance)=""
	s DefaultValue=$P(DefaultValue,"^",1)
	s:DefaultValue="0" NoAdvance=" selected"
	s:DefaultValue="1" Advance=" selected"
	;s:(DefaultValue="") NoRePS=" selected"
	//下拉列表
	;w "<select name='InvType' id='InvType' style='width:"_ContrlWidth_"' HEIGHT=0>",!
	w ##class(web.DHCPE.DHCPECommon).GetDefaultStyle("InvType","")
	;w "<option value=''></option>",!
	w "<option value='0'"_NoAdvance_">非预交金</option>",!
	w "<option value='1'"_Advance_">预交金</option>",!	
	w "</select>",!
	Quit $$$OK
}

/// 收费状态
ClassMethod OutChargeStatusToHTMLNew(ContrlWidth As %String = "", DefaultValue As %String = "") As %String
{
	s:(""=ContrlWidth) ContrlWidth="155"
	s (NoFee,PartFee,Fee)=""
	s DefaultValue=$P(DefaultValue,"^",2)
	s:DefaultValue="0" NoFee=" selected"
	s:DefaultValue="2" Fee=" selected"
	//下拉列表
	;w "<select name='ChargeStatus' id='ChargeStatus' style='width:"_ContrlWidth_"' HEIGHT=0 tabIndex=0>",!
	w ##class(web.DHCPE.DHCPECommon).GetDefaultStyle("ChargeStatus","")
	w "<option value=''>  </option>",!
	w "<option value='0'"_NoFee_">"_"未付费"_"</option>",!
	w "<option value='2'"_Fee_">"_"已付费"_"</option>",!
	w "</select>",!
	Quit $$$OK
}

/// 收费状态
ClassMethod OutChargeStatusToHTML(ContrlWidth As %String = "", DefaultValue As %String = "") As %String
{
	s:(""=ContrlWidth) ContrlWidth="155"
	s (NoFee,PartFee,Fee)=""
	s DefaultValue=$P(DefaultValue,"^",2)
	s:DefaultValue="0" NoFee=" selected"
	s:DefaultValue="1" PartFee=" selected"
	s:DefaultValue="2" Fee=" selected"
	//下拉列表
	//w "<select name='ChargeStatus' id='ChargeStatus' style='width:"_ContrlWidth_"' HEIGHT=0 tabIndex=0>",!
    w ##class(web.DHCPE.DHCPECommon).GetDefaultStyle("ChargeStatus","")
	w "<option value=''>  </option>",!
	w "<option value='0'"_NoFee_">"_"未付费"_"</option>",!
	w "<option value='1'"_PartFee_">"_"部分付费"_"</option>",!
	w "<option value='2'"_Fee_">"_"全部付费"_"</option>",!
	w "</select>",!
	Quit $$$OK
}

/// 收费状态
ClassMethod OutGChargeStatusToHTML(ContrlWidth As %String = "", DefaultValue As %String = "") As %String
{
	s:(""=ContrlWidth) ContrlWidth="155"
	s (NoAFee,NoFee,PartFee,Fee)=""
	s DefaultValue=$P(DefaultValue,"^",2)
	s:DefaultValue="0" NoAFee=" selected"
	s:DefaultValue="1" NoFee=" selected"
	s:DefaultValue="2" Fee=" selected"
	s:DefaultValue="3" PartFee=" selected"
	//下拉列表
	
    w ##class(web.DHCPE.DHCPECommon).GetDefaultStyle("ChargeStatus","")
	w "<option value=''> </option>",!
	w "<option value='0'"_NoAFee_">"_"无收费记录"_"</option>",!
	w "<option value='1'"_NoFee_">"_"未收费"_"</option>",!
	w "<option value='2'"_Fee_">"_"已收费"_"</option>",!
	w "<option value='3'"_PartFee_">"_"部分收费"_"</option>",!
	w "</select>",!
	Quit $$$OK
}

/// 收费状态
ClassMethod OutIChargeStatusToHTML(ContrlWidth As %String = "", DefaultValue As %String = "") As %String
{
	s:(""=ContrlWidth) ContrlWidth="155"
	s (NoAFee,PartFee,Fee,NoItem)=""
	s DefaultValue=$P(DefaultValue,"^",2)
	s:DefaultValue="0" NoAFee=" selected"
	s:DefaultValue="1" PartFee=" selected"
	s:DefaultValue="2" Fee=" selected"
	s:DefaultValue="3" NoItem=" selected"
	//下拉列表
	
    w ##class(web.DHCPE.DHCPECommon).GetDefaultStyle("ChargeStatus","")
	w "<option value=''> </option>",!
	w "<option value='0'"_NoAFee_">"_"未付费"_"</option>",!
	w "<option value='1'"_PartFee_">"_"部分付费"_"</option>",!
	w "<option value='2'"_Fee_">"_"全部付费"_"</option>",!
	w "<option value='3'"_NoItem_">"_"没有项目"_"</option>",!
	w "</select>",!
	Quit $$$OK
}

// w ##class(web.DHCPE.PreCommon).GetPEID("7353078","PAADM")

ClassMethod GetPEID(ID, Type)
{
	s ret=""
	q:ID="" ret
	i Type="PAADM" d
	.d GetByPAADM
	i Type="PRE" d
	.d GetByPreIADM
	q ret
GetByPreIADM
	s ret=$p($g(^DHCPEPreIADM(ID)),"^",27)
	q
GetByPAADM	
	s IADM=$O(^DHCPEIADM(0,"PAADM",ID,0))
	q:IADM=""
	s PIADM=$P(^DHCPEIADM(IADM),"^",4)
	q:PIADM=""
	s ret=$p($g(^DHCPEPreIADM(PIADM)),"^",27)
	q
}

// 国籍下拉框

ClassMethod OutCountryToHTML(ContrlWidth As %String = "") As %String
{
	s:(""=ContrlWidth) ContrlWidth="155"
	//下拉列表
	w "<select name='Country_DR_Name' id='Country_DR_Name' style='width:"_ContrlWidth_"' HEIGHT=0 tabIndex=0>",!
	w "<option value=''> </option>",!
	s id=0
	//^CT("COU",{CTCOU_RowId})
	f  s id=$o(^CT("COU",id)) q:id=""  d
	.w "<option value='"_id_"'>"_$P($G(^CT("COU",id)),"^",2)_"</option>",! 
	w "</select>",!
	Quit $$$OK
}

ClassMethod OutPISCodeToHTML(ContrlWidth As %String = "") As %String
{
	s:(""=ContrlWidth) ContrlWidth="155"

	//下拉列表
	w "<select name='PISCode' id='PISCode' style='width:"_ContrlWidth_"' HEIGHT=0>",!
	w "<option value=''> </option>",!
	w "<option value='20'>细胞</option>",!
	w "<option value='23'>TCT</option>",!
	w "</select>",!
	Quit $$$OK
}

// 显示新产品病理标本类型

ClassMethod OutPISCodeNewToHTML(ContrlWidth As %String = "") As %String
{
	s:(""=ContrlWidth) ContrlWidth="155"
	//下拉列表
	w "<select name='PISCodeNew' id='PISCodeNew' style='width:"_ContrlWidth_"' HEIGHT=0 tabIndex=0>",!
	w "<option value=''> </option>",!
	s id=0
	f  s id=$o(^DHCAPPTS(id)) q:id=""  d
	.w "<option value='"_id_"'>"_$P($G(^DHCAPPTS(id)),"^",2)_"</option>",! 
	w "</select>",!
	Quit $$$OK
}

ClassMethod GetVIPDescBYLevel(VIPLevel)
{
	q:VIPLevel="" ""
	s VIPDesc=""
	s VIPDesc=$P(^DHCPEVIPLevel("VIP",VIPLevel),"^",2)
	q VIPDesc
}

ClassMethod IsFeeTypeSuperGroup()
{
 
	s flag=0
	s CurLoc=%session.Get("LOGON.CTLOCID")
	//s FeeTypeSuperGroup=$g(^DHCPESetting("DHCPE","FeeTypeSuperGroup"))
	s FeeTypeSuperGroup=$g(^DHCPESetting("DHCPE","FeeTypeSuperGroup",CurLoc))

	s CurGroupID=%session.Get("LOGON.GROUPID")
	if (CurGroupID'=FeeTypeSuperGroup) s flag=1
	q flag
}

/// 生成一个页面元素　显示hiS病人基本信息表的证件类型列表
/// d ##class(web.DHCPE.PreCommon).OutPAPMICardTypeToHTML()
ClassMethod OutPAPMICardTypeToHTML(ContrlWidth As %String = "", tabIndex As %String = "0") As %String
{
	s:(""=ContrlWidth) ContrlWidth="155"
	//下拉列表
	//w "<select name='PAPMICardType_DR_Name' id='PAPMICardType_DR_Name' style='width:"_ContrlWidth_"' HEIGHT=0 tabIndex="_tabIndex_">",!
	w ##class(web.DHCPE.DHCPECommon).GetDefaultStyleNoEdit("PAPMICardType_DR_Name","")
	w "<option value=''> </option>",!
	s id=0
	f  s id=$O(^PAC("CARD",id)) q:id=""  d
	.s active=$p($g(^PAC("CARD",id,"DHC")),"^",1)
	.q:active'="Y"
	.w "<option value='"_id_"'>"_$P($G(^PAC("CARD",id)),"^",2)_"</option>",!
		
	w "</select>",!
	Quit $$$OK
}

/// w ##class(web.DHCPE.PreCommon).GetNationDR("回族")
ClassMethod GetNationDR(Desc)
{
	q:Desc="" ""
	i (Desc'["族") S Desc=Desc_"族"
	s ID=$O(^CT("NAT",0,"Desc",Desc,0))
	Q ID
}

/// function:问卷级别
/// d ##class(web.DHCPE.PreCommon).OutHMServiceToHTML()
ClassMethod OutHMServiceToHTML(ContrlWidth As %String = "", tabIndex As %String = "") As %String
{
	s:(""=ContrlWidth) ContrlWidth="155"
	//下拉列表
	w "<select name='HMService' id='HMService' style='width:"_ContrlWidth_"' HEIGHT=0 tabIndex="_tabIndex_">",!
	w "<option value=''></option>",!
	s id=0
	f  s id=$o(^User.DHCHMCServiceClassD(id)) q:(id="")  d
	.s Code=$lg(^User.DHCHMCServiceClassD(id),3)
	.s Desc=$lg(^User.DHCHMCServiceClassD(id),4)
	.s Active=$lg(^User.DHCHMCServiceClassD(id),2)
	.q:Active="N"

	.w "<option value='"_id_"'>"_Desc_"</option>",! 
	
	w "</select>",!
	Quit $$$OK
}

ClassMethod OutRoundingFeeMode(ContrlWidth As %String = "", DefaultValue As %String = "") As %String
{
	s:(""=ContrlWidth) ContrlWidth="120"
	//下拉列表    
	w "<select name='RoundingFeeMode' id='RoundingFeeMode' style='width:"_ContrlWidth_"' HEIGHT=0>",!
	w "<option value=''></option>",!
	w "<option value='0'>不允许</option>",!
	w "<option value='1'>个人收费允许</option>",!
	w "<option value='2'>团体收费允许</option>",!
	w "<option value='3'>个人和团体收费均允许</option>",!
	w "</select>",!
	Quit $$$OK
}

/// 已检状态
ClassMethod OutCheckItemStatusToHTML(ContrlWidth As %String = "", DefaultValue As %String = "") As %String
{
	s:(""=ContrlWidth) ContrlWidth="155"
	s (PartCheck,AllCheck)=""
	s DefaultValue=$P(DefaultValue,"^",2)
	s:DefaultValue="1" PartCheck=" selected"
	s:DefaultValue="2" AllCheck=" selected"
	//下拉列表
	w ##class(web.DHCPE.DHCPECommon).GetDefaultStyle("CheckItemStatus","")
	w "<option value=''> </option>",!
	w "<option value='1'"_PartCheck_">"_"部分已检"_"</option>",!
	w "<option value='2'"_AllCheck_">"_"全部已检"_"</option>",!
	w "</select>",!
	Quit $$$OK
}

Storage Default
{
<Data name="PreCommonDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCP.PreCommonD</DataLocation>
<DefaultData>PreCommonDefaultData</DefaultData>
<IdLocation>^web.DHCP.PreCommonD</IdLocation>
<IndexLocation>^web.DHCP.PreCommonI</IndexLocation>
<StreamLocation>^web.DHCP.PreCommonS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
