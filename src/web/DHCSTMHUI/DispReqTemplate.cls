Import sqluser

/// Descript:	二级库物资请领模板
Class web.DHCSTMHUI.DispReqTemplate Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	查询请领模板
/// Creator:	wxj
/// CreateDate:	2023-02-21
/// Table:		DHC_InDisp
/// Return：	请领单信息
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DispReqTemplate","QueryTemplate","{""LocId"":""106"",""gUserId"":""6423"",""gLocId"":""106"",""gGroupId"":""277"",""gHospId"":""2"",""MENUID"":""57996"",""UserGroup"":"""",""TemplateFlag"":""Y""}")
Query QueryTemplate(Params As %String) As Query(ROWSPEC = "RowId,DsrqNo,LocDesc,CreateDate,CreateTime,CreateUser,ReqUser,GrpDesc,ScgDesc,ReqMode,ReqModeDesc,Remark,TemplateFlag") [ SqlProc ]
{
}

ClassMethod QueryTemplateExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s ^tempxj("QueryTemplate")=Params
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:Params="" $$$OK

	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s pLocId=PJObj.%Get("LocId")
	s pUserGroup=PJObj.%Get("UserGroup")
	s pTemplateFlag=PJObj.%Get("TemplateFlag")
	s gUserId=PJObj.%Get("gUserId")
	s gLocId=PJObj.%Get("gLocId")
	s gGroupId=PJObj.%Get("gGroupId")
	s gHospId=PJObj.%Get("gHospId")	
	s:pTemplateFlag="" pTemplateFlag="N"
	q:pLocId="" $$$OK
	s SqlStr="select %ID RowId,"
		_"dsrq_no DsrqNo,"
		_"dsrq_disploc_dr->ctloc_desc LocDesc,"
		_"dsrq_date CreateDate,"
		_"dsrq_time CreateTime,"
		_"dsrq_ssusr_dr->ssusr_name CreateUser,"
		_"dsrq_requser_dr ReqUserId,"
		_"dsrq_requser_dr->ssusr_name ReqUser,"
		_"dsrq_scg_dr->scg_desc ScgDesc,"
		_"dsrq_reqmode ReqMode,"
		_"dsrq_requsergrp_dr Grp,"
		_"dsrq_requsergrp_dr->lug_groupdesc GrpDesc,"
		_"dsrq_remark Remark,"
		_"dsrq_Template TemplateFlag"
		_" From dhc_indispreq"
		_" Where dsrq_disploc_dr="_pLocId
		_" And DSRQ_Template='Y'"
	s xrs=##class(%Library.ResultSet).%New()
	d xrs.RuntimeModeSet(0)
	d xrs.Prepare(SqlStr)
	s sc=xrs.Execute()
	i $$$ISERR(sc) q $$$OK
	while (xrs.Next())
	{
		s RowId=xrs.Data("RowId")
		s DsrqNo=xrs.Data("DsrqNo")
		s LocDesc=xrs.Data("LocDesc")
		s CreateDate=xrs.Data("CreateDate")
		s CreateTime=xrs.Data("CreateTime")
		s CreateUser=xrs.Data("CreateUser")
		s ReqUserId=xrs.Data("ReqUserId")
		s ReqUser=xrs.Data("ReqUser")
		s ReqGrp=xrs.Data("Grp")
		s GrpDesc=xrs.Data("GrpDesc")
		s ScgDesc=xrs.Data("ScgDesc")
		s ReqMode=xrs.Data("ReqMode")
		s Remark=xrs.Data("Remark")
		s TemplateFlag=xrs.Data("TemplateFlag")
		s:TemplateFlag="" TemplateFlag="N"
		continue:(pTemplateFlag'="")&&(TemplateFlag'=pTemplateFlag)
		s MemoDelim=##class(web.DHCSTMHUI.Common.UtilCommon).MemoDelim()
		s Remark=$lts(Remark,MemoDelim)
		CONTINUE:(pUserGroup'="")&&(pUserGroup'=ReqGrp)
		CONTINUE:(gUserId'="")&&(ReqUserId'="")&&(gUserId'=ReqUserId)
		s Ret=##class(web.DHCSTMHUI.DHCINDispReq).SelfGrp(gUserId,ReqGrp)
		CONTINUE:(gUserId'="")&&(ReqGrp'="")&&(Ret<0)
		s LocDesc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(LocDesc)
		s:CreateDate'="" CreateDate=..DL2H(CreateDate)
		s:CreateTime'="" CreateTime=..TL2H(CreateTime)
		s ReqModeDesc=""
		i ReqMode=0 s ReqModeDesc="按专业组请领"
		i ReqMode=1 s ReqModeDesc="按个人请领"
		d OutPutRow
	}
	d xrs.Close()
	Quit $$$OK
OutPutRow
	s Data=$lb(RowId,DsrqNo,LocDesc,CreateDate,CreateTime,CreateUser,ReqUser,GrpDesc,ScgDesc,ReqMode,ReqModeDesc,Remark,TemplateFlag)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

}
