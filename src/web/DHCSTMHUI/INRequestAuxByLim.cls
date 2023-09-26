Import sqluser

/// 根据库存上下限辅助制作库存转移请求单
Class web.DHCSTMHUI.INRequestAuxByLim Extends (%RegisteredObject, %XML.Adaptor, StkTypeM) [ Not ProcedureBlock ]
{

/// 检索需要请求的库存项目明细列表
/// Author:XuChao
/// Date:2018-05-17
/// Argu:
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.INRequestAuxByLim","LocItmForReq",^templxt("LocItmForReq"))
Query LocItmForReq(Params As %String) As Query(ROWSPEC = "Inci,Code,Description,BUom,AvaQty:%Float,MinQty:%Float,MaxQty:%Float,RepQty:%Float,Incil,Uom,UomDesc,SbDesc,ReqQty:%Float,Qty:%Float,Spec,Manf,HvFlag") [ SqlProc ]
{
}

ClassMethod LocItmForReqExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Params)
	s ReqLoc=PJobj.%Get("ReqLoc")
	s SupLoc=PJobj.%Get("SupLoc")	
	s pScgStk=PJobj.%Get("ScgStk")
	s pManger=PJobj.%Get("Manager")			 
	s pHvFlag=PJobj.%Get("HvFlag")
	s pIntSigner=PJobj.%Get("IntSigner")			
	s sql="select incil_inci_parref Inci,"
	s sql=sql_"incil_inci_parref->inci_code Code,"
	s sql=sql_"incil_inci_parref->inci_desc Description,"
	s sql=sql_"incil_inci_parref->inci_ctuom_dr BUom,"
	s sql=sql_"incil_availqty AvaQty , "   
	s sql=sql_"incil_minQty MinQty," 
	s sql=sql_"incil_maxQty MaxQty,"
	s sql=sql_"incil_repQty RepQty,"
	s sql=sql_"incil_rowid Incil,"
	s sql=sql_"incil_inci_parref->inci_ctuom_purch_dr Uom,"
	s sql=sql_"incil_inci_parref->inci_ctuom_purch_dr->ctuom_desc UomDesc,"
	s sql=sql_"incil_incsb_dr->incsb_desc SbDesc"
	s sql=sql_" From inc_itmloc where incil_ctloc_dr="_ReqLoc
	s xrs=##class(%Library.ResultSet).%New()
	d xrs.RuntimeModeSet(0)
	d xrs.Prepare(sql)
	s sc=xrs.Execute()
	i $$$ISERR(sc) q $$$OK
	while (xrs.Next())
	{
		s Inci=xrs.Data("Inci")
		s Code=xrs.Data("Code")
		s Description=xrs.Data("Description")
		s BUom=xrs.Data("BUom")
		s AvaQty=xrs.Data("AvaQty")
		s MinQty=xrs.Data("MinQty")
		s MaxQty=xrs.Data("MaxQty")
		s RepQty=xrs.Data("RepQty")    ;标准库存
		s Incil=xrs.Data("Incil")
		s Uom=xrs.Data("Uom")
		s UomDesc=xrs.Data("UomDesc")
		s SbDesc=xrs.Data("SbDesc")
		continue:MinQty=""   //下限未定义
		continue:MaxQty=""   //上限未定义
		s:RepQty="" RepQty=MinQty+((MaxQty-MinQty)/2)   //计算标准库存
		s StkQty=""
		s StkQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).IL(Inci,ReqLoc,+$h)
		s StkGrpInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(Inci)
		s ScgType=$p(StkGrpInfo,"^",3)
		s ScgStk=$p(StkGrpInfo,"^",5)
		continue:ScgType'=..sssCode()
		continue:(pScgStk'="")&(("^"_pScgStk_"^")'[("^"_ScgStk_"^"))
		s MonitorFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetMonitorFlag(Inci)
		continue:(pManger'="")&(MonitorFlag'=pManger)
		continue:(SupLoc'="")&($o(^INCI("IL_LOC",SupLoc,Inci,""))="")  //过滤掉"供方没有"的库存项目
		continue:StkQty'<RepQty
		s ReqQty=RepQty-StkQty   //请求数量
		s Fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(Uom,BUom)
		s MinQty=MinQty/Fac  //$fn(MinQty/Fac,"",2)
		s MaxQty=MaxQty/Fac  //$fn(MaxQty/Fac,"",2)
		s RepQty=RepQty/Fac  //$fn(RepQty/Fac,"",2)
		s AvaQty=+AvaQty/Fac  //$fn(AvaQty/Fac,"",2)
		s ReqQty=+ReqQty/Fac  //$fn(ReqQty/Fac,"",2)
		s:pIntSigner="Y" ReqQty=$fn(ReqQty,"",0)
		s Qty=ReqQty   //实际请求量
    	s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",Inci)
    	s Manf=$p(##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetManf(Inci),"^",3)
    	s HvFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(Inci)
    	continue:pHvFlag'=HvFlag
		d OutPutRow  
	}
	Q $$$OK
OutPutRow
	s Data=$lb(Inci,Code,Description,BUom,AvaQty,MinQty,MaxQty,RepQty,Incil,Uom,UomDesc,SbDesc,ReqQty,Qty,Spec,Manf,HvFlag)   
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

}
