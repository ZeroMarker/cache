/// 名称:BDP数据导入-库存分类
/// 描述:包含保存和校验
/// 编写者:基础数据平台组 -陈莹
/// 编写日期: 2017-03-16
Class web.BDPExt.INCStkCatBLL Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：陈莹
/// CreatDate: 2017-03-16
/// Description：保存修改医嘱子分类的内容
/// Table：INC_StkCat（库存分类），DHC_StkCatGroup（库存类组），dhc_stkcatgrprelations（类组与库存分类关联)
/// Input：Ceobj(web.BDPExt.INCStkCatEntity 实体类)
/// Return：成功返回success:'true'和新增或修改的数据id；失败返回success:'false'和失败原因
/// Other: d ##class(web.BDPExt.INCStkCatBLL).SaveEntity()
ClassMethod SaveEntity(Ceobj As web.BDPExt.INCStkCatEntity) As %String
{
	n (Ceobj,%session)
	s $zt="ERROR"
	s ImportResult=""

	///2018-11-18 医嘱模式
	s Ceobj.scSGStruModeFlag=$CASE(Ceobj.scSGStruModeFlag,"一对多":"Y","一对一":"N",:"N") 
	
	///字段名和值之间用上箭头"^" 拼接，然后它们之间再用"|"拼接。
	s liststr="scSet^"_Ceobj.scSet_"|scSGCode^"_Ceobj.scSGCode_"|scSGDesc^"_Ceobj.scSGDesc_"|scSCCode^"_Ceobj.scSCCode_"|scSCDesc^"_Ceobj.scSCDesc_"|scStkType^"_Ceobj.scStkType_"|scSGStruModeFlag^"_Ceobj.scSGStruModeFlag
	s ^tmpcy("web.BDPExt.INCStkCatBLL")=liststr
	Ts
	//2020-04-16调用物资组李慧新接口web.DHCSTMHUI.Tools.CodeInputX
	//s ret= ##class(web.DHCSTM.Tools.CodeInputX).SaveStkCat(liststr)  //>0 - rowid,<0 - 失败
	/*if (ret'>0)
	{
		s msg=ret
		if ret=-5 s msg="库存类组保存失败"
		if ret=-6 s msg="库存分类保存失败"
		if ret=-7  s msg="库存类组和库存分类保存关联失败"
		s ImportResult= "{success:'false',info:'"_msg_"！'}" 
	}
	
	if (ImportResult="")
	{
		Tc
		//s JsonStr="{INCSCCode:"""_Ceobj.scSCCode_""",INCSCDesc:"""_Ceobj.scSCDesc_""",INCSCStkType:"""_Ceobj.scStkType_"""}"     
		//d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("INC_StkCat","User.INCStkCat","库存分类",$p(ret,"||",1),Ceobj.scSCDesc,"A",JsonStr)
		
		s ImportResult="{success:'true',id:'"_ret_"'}" 
	}
	else
	{
		Tro	
	}
	q ImportResult
	*/
	try
	{
		i (Ceobj.scStkType = "G") //调药房接口
		{
			s ret= ##class(PHA.TOOLS.Import.StkCat).SaveStkCat(liststr,Ceobj.LinkHospId)
		}
		else //调物资接口
		{
			s ret= ##class(web.DHCSTMHUI.Tools.CodeInputX).SaveStkCat(liststr,Ceobj.LinkHospId)  //2021-01-27 返回值改成json串 ：{"rowid":"1441","msg":"操作成功","success":"0","keyValue":{}}
		}
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
			s ImportResult= "保存失败："_messageJsonObj.msg
			if $tl>0 Tro	
		}
		else   //保存成功
		{
			Tc
			//s JsonStr="{INCSCCode:"""_Ceobj.scSCCode_""",INCSCDesc:"""_Ceobj.scSCDesc_""",INCSCStkType:"""_Ceobj.scStkType_"""}"     
			//d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("INC_StkCat","User.INCStkCat","库存分类",$p(ret,"||",1),Ceobj.scSCDesc,"A",JsonStr)
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
/// CreatDate:2017-3-14
/// Description:数据重复验证方法,js调用
/// Table:INC_StkCat（库存分类）
/// Input:id, code, desc
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:d ##class(web.BDPExt.INCStkCatBLL).FormValidate("","","")
ClassMethod FormValidate(code As %String, desc As %String, hospid As %String, pStkType As %String = "") As %String
{
	n (code,desc,hospid,pStkType)
	s flag=0
	if $$ALPHAUP^SSUTIL4(code)'=""
	{
		s idc=0
		for
		{
			s idc=$o(^INC("SC",0,"Code",$$ALPHAUP^SSUTIL4(code),idc)) q:idc=""
			s Value=$p($g(^INC("SC",idc)),"^",1)
			s stkType = $p($g(^INC("SC", idc)), "^", 3)
			continue:((pStkType'="")&&(pStkType '= stkType))
			if (Value=code)
			{
				s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("INC_StkCat",idc,hospid)
				continue:showflag="N"
				s flag=1
			}
		}
	}
	if $$ALPHAUP^SSUTIL4(desc)'=""
	{
		s idd=0
		for
		{
			s idd=$o(^INC("SC",0,"Desc",$$ALPHAUP^SSUTIL4(desc),idd)) q:idd=""
			s Value=$p($g(^INC("SC",idd)),"^",2)
			s stkType = $p($g(^INC("SC", idd)), "^", 3)
			continue:((pStkType'="")&&(pStkType '= stkType))
			if (Value=desc)
			{
				s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("INC_StkCat",idd,hospid)
				continue:showflag="N"
				s flag=1
			}
		}
	}
	q flag
}

}
