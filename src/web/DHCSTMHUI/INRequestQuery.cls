Import sqluser

Class web.DHCSTMHUI.INRequestQuery Extends (%RegisteredObject, %XML.Adaptor, StkTypeM) [ Not ProcedureBlock ]
{

/// 检索需要出库的请求单
/// Author:XuChao
/// Date:2018-05-16
/// Argu:
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.INRequestQuery","INReq",^tmpxu)
Query INReq(Params As %String) As Query(ROWSPEC = "RowId,ToLoc,ToLocDesc,FrLoc,FrLocDesc,ReqUser,UserName,ReqDate,ReqTime,ReqType,Complete,TransStatus,ReqNo,AuditUser,AuditUserProv")
{
}

ClassMethod INReqExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Params)
	s StartDate=PJobj.%Get("StartDate")	//起始日期
	s EndDate=PJobj.%Get("EndDate")			//截止日期
	s pToLoc=PJobj.%Get("ReqLoc")			//申请部门 
	s pFrLoc=PJobj.%Get("SupLoc")			//供给部门
	s pComp=PJobj.%Get("Complate")			//包含完成的
	s pScg=PJobj.%Get("Scg")					//类组
	s pInci=PJobj.%Get("Inci")	
	s pInciDesc=PJobj.%Get("InciDesc")	
	q:StartDate="" $$$OK
	q:EndDate="" $$$OK
	s StartDate=..DH2L(StartDate)
	s EndDate=..DH2L(EndDate)
	s StkType=..sssCode()
	s sql="select %ID Req,"
	s sql=sql_"inrq_recloc_dr ToLoc,"
	s sql=sql_"inrq_recloc_dr->ctloc_Desc ToLocDesc,"
	s sql=sql_"inrq_reqloc_dr FrLoc,"
	s sql=sql_"inrq_reqloc_dr->ctloc_desc FrLocDesc,"
	s sql=sql_"inrq_ssusr_dr ReqUser,"
	s sql=sql_"inrq_ssusr_dr->ssusr_name UserName,"
	s sql=sql_"inrq_date ReqDate,"
	s sql=sql_"inrq_time ReqTime,"
	s sql=sql_"inrq_status ReqType,"
	s sql=sql_"inrq_usercompleted Complete,"
	s sql=sql_"INRQ_No ReqNo "
	s sql=sql_" from in_request"
	s sql=sql_" where inrq_date between "_StartDate_" and "_EndDate
	s xrs=##class(%Library.ResultSet).%New()
	d xrs.RuntimeModeSet(0)
	d xrs.Prepare(sql)
	s sc=xrs.Execute()
	i $$$ISERR(sc) q $$$OK
	while (xrs.Next())
	{
		s Complete=xrs.Data("Complete")
		s Req=xrs.Data("Req")  
		s IfMatDoc=##class(web.DHCSTMHUI.Common.UtilCommon).IfMatDoc(Req,"REQ")
		continue:(IfMatDoc="N")
		;过滤模板数据
		s Template=""
		&sql(select inrq_template  
			into :Template  
			from DHC_INRequest 
			where INRQ_INRQ_DR=:Req)
		continue:Template="Y"     //过滤掉请求模板
		s FrLoc=xrs.Data("FrLoc")
		i pFrLoc'="" continue:pFrLoc'=FrLoc
		s FrLocDesc=xrs.Data("FrLocDesc")
		s FrLocDesc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(FrLocDesc)
		s ToLoc=xrs.Data("ToLoc")
		i pToLoc'="" continue:pToLoc'=ToLoc
		s ToLocDesc=xrs.Data("ToLocDesc")
		s ToLocDesc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(ToLocDesc)
		s ReqUser=xrs.Data("ReqUser")  
		s UserName=xrs.Data("UserName")
		s ReqDate=xrs.Data("ReqDate")
		s ReqDate=..DL2H(ReqDate)
		s ReqTime=xrs.Data("ReqTime")
		s ReqTime=..TL2H(ReqTime)
		s ReqNo=xrs.Data("ReqNo")
		s ReqType=xrs.Data("ReqType")
		//类组过滤
		s (INRQRowId,Scg,AuditUserId,AuditUserProvId,AuditUser,AuditUserProv,ReqStkType)="" 
		s INRQRowId=$o(^DHCINRQ(0,"INRQ",Req,INRQRowId))
		i INRQRowId'="" d
		.s Scg=$p(^DHCINRQ(INRQRowId),"^",10)
		.s AuditUserId=$p(^DHCINRQ(INRQRowId),"^",11)
		.s AuditUserProvId=$p(^DHCINRQ(INRQRowId),"^",14)
		.s ReqStkType=$p(^DHCINRQ(INRQRowId),"^",31)
		i pScg'="" continue:pScg'=Scg
		continue:ReqStkType'=StkType
		i AuditUserId'="" s AuditUser=$p(^SSU("SSUSR",AuditUserId),"^",2)
		i AuditUserProvId'="" s AuditUserProv=$p(^SSU("SSUSR",AuditUserProvId),"^",2)
		//物资名称过滤
		s Ret=0
		s ReqItm=""
		f  s ReqItm=$o(^INRQ(Req,"RQI",ReqItm)) q:(ReqItm="")||((pInci="")&(pInciDesc=""))  d
		.s Inci=""
		.s Inci=$p(^INRQ(Req,"RQI",ReqItm),"^",4)
		.i (pInci'="")&(pInci=Inci) d
		..s Ret=1
		.s InciDesc=$p(^INCI(Inci,1),"^",2)
		.i (pInciDesc'="")&(InciDesc[pInciDesc) d
		..s ret=1
		i pInci'="" continue:Ret=0
		i pInciDesc'="" continue:Ret=0
		s TransStatus=##class(web.DHCSTMHUI.DHCINIsTrf).TransferStatus(Req)
		d OutPutRow  
	}
	Quit $$$OK

OutPutRow
	s Data=$lb(Req,ToLoc,ToLocDesc,FrLoc,FrLocDesc,ReqUser,UserName,ReqDate,ReqTime,ReqType,Complete,TransStatus,ReqNo,AuditUser,AuditUserProv)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

}
