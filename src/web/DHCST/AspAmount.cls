/// Descript:调价损益查询及统计
/// Creater:	ZhangDongmei
/// CreateDate:	2013-01-08
Class web.DHCST.AspAmount Extends (%RegisteredObject, StkTypeG) [ Not ProcedureBlock ]
{

/// Descript:查询一段时间内的调价损益明细
/// Creater:	ZhangDongmei
/// CreateDate:	2013-01-08
/// Table:dhc_aspamount
/// Input:开始行,一页显示记录条数,开始日期,截止日期,
/// 科室id^调价单号^调价原因id^金额类型（1:差额为正，-1:差额为负,0:全部）^药品id
/// Output:		
/// Return：调价损益信息  
/// w ##class(web.DHCST.AspAmount).jsQueryAspAmount("0","30","","","27/01/2021","28/01/2021","165^^^0^3554^1^^^^2","","")
ClassMethod jsQueryAspAmount(Start As %Integer, Limit As %Integer, Sort As %String, Dir As %String, StartDate As %String, EndDate As %String, Others As %String, StartTime As %String, EndTime As %String) As %String
{
	s $p(Others,"^",6)=1   ;标识Ext界面调用
	//s ^YSJTMP("jsQueryAspAmount")=$LB(Start , Limit, Sort , Dir , StartDate , EndDate , Others , StartTime , EndTime)
	s result=##class(%Library.ResultSet).%New("web.DHCST.AspAmount:QueryAspAmount")
	s sc=result.Execute(Sort,Dir,StartDate,EndDate,Others,StartTime,EndTime)	 
	i $$$ISERR(sc) q ""
	s colNum=result.GetColumnCount()
	s colNameStr=""
	f i=1:1:colNum d
	.i colNameStr="" s colNameStr=result.GetColumnName(i)
	.e  s colNameStr=colNameStr_"^"_result.GetColumnName(i)
	;
	s count = 0
	s resultString = ""
	s end = Start+Limit
	s json = ##class(Code.JsonObj).%New()
	While(result.Next())
	{ 
		s ret=""
		f i=1:1:colNum d
		.i ret="" s ret=result.%GetData(i)
		.e   s ret=ret_"^"_result.%GetData(i)

		s tmp=ret
		s count = count+1

		CONTINUE:count<(Start+1)
		CONTINUE:count>end			

		d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData(colNameStr,count)
	k json
	Q resultString
}

/// Descript:查询一段时间内的调价损益明细
/// Creater:	ZhangDongmei
/// CreateDate:	2013-01-08
/// Table:dhc_aspamount
/// Input:开始行,一页显示记录条数,开始日期,截止日期,
/// 科室id^调价单号^调价原因id^金额类型（1:差额为正，-1:差额为负,0:全部）^药品id
/// Output:		
/// Return：调价损益信息  
/// w ##class(web.DHCST.AspAmount).jsQueryAspBatAmount("0","30","","","27/01/2021","28/01/2021","395^^^0^","","")
ClassMethod jsQueryAspBatAmount(Start As %Integer, Limit As %Integer, Sort As %String, Dir As %String, StartDate As %String, EndDate As %String, Others As %String, StartTime As %String, EndTime As %String) As %String
{
	//s ^YSJTMP("jsQueryAspBatAmount")=$LB(Start,Limit,Sort,Dir,StartDate,EndDate,Others,StartTime,EndTime)
	s $p(Others,"^",6)=1   ;标识Ext界面调用
	s result=##class(%Library.ResultSet).%New("web.DHCST.AspAmount:QueryAspBatAmount")
	s sc=result.Execute(Sort,Dir,StartDate,EndDate,Others,StartTime,EndTime)	 
	i $$$ISERR(sc) q ""
	s colNum=result.GetColumnCount()
	s colNameStr=""
	f i=1:1:colNum d
	.i colNameStr="" s colNameStr=result.GetColumnName(i)
	.e  s colNameStr=colNameStr_"^"_result.GetColumnName(i)
	;
	s count = 0
	s resultString = ""
	s end = Start+Limit
	s json = ##class(Code.JsonObj).%New()
	While(result.Next())
	{ 
		s ret=""
		f i=1:1:colNum d
		.i ret="" s ret=result.%GetData(i)
		.e   s ret=ret_"^"_result.%GetData(i)

		s tmp=ret
		s count = count+1

		CONTINUE:count<(Start+1)
		CONTINUE:count>end			

		d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData(colNameStr,count)
	k json
	Q resultString
}

/// Descript:查询一段时间内的调价损益明细
/// Creater:	ZhangDongmei
/// CreateDate:	2013-01-08
/// Table:dhc_aspamount
/// Input:开始行,一页显示记录条数,开始日期,截止日期,
/// 科室id^调价单号^调价原因id^金额类型（1:差额为正，-1:差额为负,0:全部）^药品id^标志(1:ext调用，其他：润乾调用)
/// Output:		
/// Return：调价损益信息
/// w ##class(%ResultSet).RunQuery("web.DHCST.AspAmount","QueryAspAmount","","","01/03/2017","01/03/2017","102^^^0^^^^1","","")
Query QueryAspAmount(Sort As %String = "", Dir As %String = "", StartDate As %String = "", EndDate As %String = "", Others As %String = "", StartTime As %String = "", EndTime As %String = "") As %Query(ROWSPEC = "AspaIdLb:%String,IncId:%String,IncCode:%String,IncDesc:%String,Spec:%String,ExecuteDate:%String,AspUom:%String,StkLbQty:%String,PriorSp:%Numeric,ResultSp:%Numeric,DiffSp:%Numeric,PriorRp:%Numeric,ResultRp:%Numeric,DiffLbRp:%Numeric,SpLbAmt:%Numeric,RpLbAmt:%Numeric,AspReason:%String,AspUser:%String,AuditUser:%String,AspDate:%String,WarrentNo:%String,LocDesc:%String") [ SqlProc ]
{
}

ClassMethod QueryAspAmountExecute(ByRef qHandle As %Binary, Sort As %String = "", Dir As %String = "", StartDate As %String = "", EndDate As %String = "", Others As %String = "", StartTime As %String = "", EndTime As %String = "") As %Status
{
	n (qHandle, Sort, Dir, StartDate, EndDate, Others, StartTime, EndTime)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:StartDate="" $$$OK
	q:EndDate="" $$$OK
	s pid=..NewPid()
	s AdjLocId=$p(Others,"^",1)
	s AdjNo=$p(Others,"^",2)
	s AdjReasonId=$p(Others,"^",3)
	s DiffType=$p(Others,"^",4)
	s ItmId=$p(Others,"^",5)
	s Flag=$p(Others,"^",6)
	s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	i StartTime[":" s StartTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(StartTime)
    i EndTime[":" s EndTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(EndTime)
    s VenId=$p(Others,"^",7) //批次供应商id
    s type=$p(Others,"^",8) //统计类型
    s GrpTypeId=$p(Others,"^",9) //类组
    s hospid=$p(Others,"^",10)
	s Dir=$$ALPHAUP^SSUTIL4(Dir)
	s:(Dir="")&(Dir'="ASC")&(Dir'="DESC") Dir="DESC"
	s CacuDate="",count=0
	f CacuDate=StartDate:1:EndDate {
		s AspaId=""
		while ("1"){
			s AspaId=$o(^ASPA(0,"DATE",CacuDate,AspaId)) 
			q:+AspaId=0
			s sql="select ASPALB_Rowid AspaIdLb,"
			s sql=sql_"ASPALB_ASPA_Parref->ASPA_No AspNo,"
			s sql=sql_"ASPALB_ASPA_Parref->ASPA_CTLOC_DR LocId,"
			s sql=sql_"ASPALB_ASPA_Parref->ASPA_CTLOC_DR->ctloc_desc LocDesc,"
			s sql=sql_"ASPALB_ASPA_Parref->ASPA_AdjPrice DiffSp,"
			s sql=sql_"ASPALB_ASPA_Parref->ASPA_INASP_DR AspId,"
			s sql=sql_"ASPALB_ASPA_Parref->ASPA_INCI_DR IncId,"
			s sql=sql_"ASPALB_ASPA_Parref->ASPA_INCI_DR->inci_code IncCode,"
			s sql=sql_"ASPALB_ASPA_Parref->ASPA_INCI_DR->inci_desc IncDesc,"
			s sql=sql_"ASPALB_ASPA_Parref->ASPA_StkQty StkQty,"
			s sql=sql_"ASPALB_Qty StkLbQty,"
			s sql=sql_"ASPALB_ASPA_Parref->ASPA_Amount SpAmt,"
			s sql=sql_"ASPALB_AdjAmt SpLbAmt,"
			s sql=sql_"ASPALB_ASPA_Parref->ASPA_Date AspaDate,"
			s sql=sql_"ASPALB_ASPA_Parref->ASPA_Time AspaTime,"
			s sql=sql_"ASPALB_ASPA_Parref->ASPA_AdjRP DiffRp,"
			s sql=sql_"ASPALB_AdjRP DiffLbRp,"
			s sql=sql_"ASPALB_ASPA_Parref->ASPA_RPAmt RpAmt,"
			s sql=sql_"ASPALB_RPAmt RpLbAmt,"
			s sql=sql_"ASPALB_INCLB_DR InciLb"
			s sql=sql_" from DHC_ASPAmountLB"
		    s sql=sql_" where ASPALB_ASPA_Parref="_AspaId
			s:Sort="" Sort="IncCode"
			i Sort'="" d
			.s sql=sql_"   Order By "_Sort_" "_Dir
			s xrs=##class(%Library.ResultSet).%New()
			d xrs.Prepare(sql)
			s sc=xrs.Execute()
			i $$$ISERR(sc) q 
			while (xrs.Next())
			{  
				//s AspaId=xrs.Data("AspaId") 
				s AspaDate=xrs.Data("AspaDate")
				s AspaTime=xrs.Data("AspaTime")
				i AspaDate'="" s AspaDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(AspaDate)
				continue:AspaDate<StartDate
				continue:AspaDate>EndDate
				i AspaTime'="" s AspaTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(AspaTime)
				continue:(AspaTime<StartTime)&&(StartTime'="")&&(AspaDate=StartDate)
				continue:(AspaTime>EndTime)&&(EndTime'="")&&(AspaDate=EndDate)
				s AspaIdLb=xrs.Data("AspaIdLb")
				s AspNo=xrs.Data("AspNo")
				continue:(AdjNo'="")&(AspNo'=AdjNo)
				s LocId=xrs.Data("LocId")
				continue:(AdjLocId'="")&(LocId'=AdjLocId)
				s tmpHospId=$P(^CTLOC(LocId),"^",22)  
				continue:(hospid'="")&&(tmpHospId'=hospid)
				s LocDesc=xrs.Data("LocDesc")
				s DiffSp=xrs.Data("DiffSp")  
				continue:(DiffType=1)&(DiffSp<=0)   ;只统计差额为正
				continue:(DiffType=-1)&(DiffSp>=0)   ;只统计差额为负
				s AspId=xrs.Data("AspId")
				continue:AspId=""
				s AspReasonId=$p(^INASP(AspId),"^",28)
				s AspReason=""
				s:AspReasonId'="" AspReason=$p(^DHCSTREASON("ASP",AspReasonId),"^",2) 
				continue:(AdjReasonId'="")&(AspReasonId'=AdjReasonId)
				s IncId=xrs.Data("IncId")  
				continue:(ItmId'="")&(IncId'=ItmId)
				s scgInfo=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(IncId)
				s stkType=$p(scgInfo,"^",3)
				s stkTypeId=$p(scgInfo,"^",5)
				q:(stkType'="")&(stkType'=..sssCode())
				continue:(stkType'="")&(stkType'=..sssCode())
				continue:(GrpTypeId'="")&&(GrpTypeId'=stkTypeId)
				s IncCode=xrs.Data("IncCode")
				s IncDesc=xrs.Data("IncDesc")
				s StkQty=xrs.Data("StkQty")
				s StkLbQty=xrs.Data("StkLbQty")
				s SpAmt=xrs.Data("SpAmt")    //差额(售价)
				s SpLbAmt=xrs.Data("SpLbAmt")  
				s InciLb=xrs.Data("InciLb")
				//wyx add 2014-01-16 增加对批次供应商的过滤，由从DHC_ASPAmount取数据改为从DHC_ASPAmountLB取数据
				s VendorInfo=##class(web.DHCST.Common.DrugStkCommon).GetInclbVend(InciLb,AspaDate)
				s VendorId=$p(VendorInfo,"^",1)
				s VendorDesc=$p(VendorInfo,"^",2)
				continue:(VenId'="")&(VendorId'=VenId)
				s DiffRp=xrs.Data("DiffRp")
				s DiffLbRp=xrs.Data("DiffLbRp")
				s RpAmt=xrs.Data("RpAmt")   //差额(进价)
				s RpLbAmt=xrs.Data("RpLbAmt") 
				s Spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",IncId)
				s ExecuteDate=$p(^INASP(AspId),"^",2)
				s:ExecuteDate'="" ExecuteDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(ExecuteDate,"ST")
				s AspUomId=$p(^INASP(AspId),"^",10)
				s:AspUomId'="" AspUom=$p(^CT("UOM",AspUomId),"^",2)
				s BUomId=$p(^INCI(IncId,1),"^",10)
				s ConFac=##class(web.DHCST.Common.UtilCommon).UOMFac(AspUomId,BUomId)
				s PriorRp=$p(^INASP(AspId),"^",15)     ;基本单位对应的调前进价
				s ResultRp=$p(^INASP(AspId),"^",16)		;基本单位对应的调后进价
				s PriorSp=$p(^INASP(AspId),"^",6)      ;基本单位对应的调前售价
				s ResultSp=$p(^INASP(AspId),"^",7)		;基本单位对应的调后售价
				s ResultRpUom=$p(^INASP(AspId),"^",14)		;调价单位对应的调后进价
				s ResultSpUom=$p(^INASP(AspId),"^",11)		;调价单位对应的调后售价
				s ResultRp=ResultRpUom
				s ResultSp=ResultSpUom
				s PriorRp=PriorRp*ConFac
				s PriorSp=PriorSp*ConFac
				s DiffSp=DiffSp*ConFac
				s DiffRp=DiffRp*ConFac
				s DiffLbRp=DiffLbRp*ConFac
				s PriorRp=##Class(web.DHCST.Common.AppCommon).FormatRpAmt(PriorRp,hospid,"G")
				s PriorSp=##Class(web.DHCST.Common.AppCommon).FormatSpAmt(PriorSp,hospid,"G")
				s StkQty=##class(web.DHCST.Common.DrugStkCommon).QtyWithUom(IncId,StkQty)
				//s StkLbQty=##class(web.DHCST.Common.DrugStkCommon).QtyWithUom(IncId,StkLbQty)
				s AdjUserId=$p(^INASP(AspId),"^",3)
				s AdjUserName="",AuditUserName=""
				s:AdjUserId'="" AdjUserName=$p($g(^SSU("SSUSR",AdjUserId)),"^",2)
				s AuditUserId=$p(^INASP(AspId),"^",21) 
				s:AuditUserId'="" AuditUserName=$p(^SSU("SSUSR",AuditUserId),"^",2)
				s WarrentNo=$p(^INASP(AspId),"^",12)    ;物价文件号
				i AspaDate'="" s AspaDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(AspaDate,"ST")
				s data=AspaIdLb_"^"_IncId_"^"_IncCode_"^"_IncDesc_"^"_Spec_"^"_ExecuteDate_"^"_AspUom_"^"_StkLbQty_"^"_PriorSp_"^"_ResultSp_"^"_DiffSp_"^"_PriorRp_"^"_ResultRp_"^"_DiffLbRp_"^"_SpLbAmt_"^"_RpLbAmt_"^"_AspReason_"^"_AdjUserName_"^"_AuditUserName_"^"_AspaDate_"^"_WarrentNo_"^"_LocDesc
				i type="1" s Index=IncCode_"^"_IncDesc
				e  s Index=IncCode_"^"_IncDesc_"^"_LocId_"^"_LocDesc_"^"_AspId //wyx add "AspId" 2014-04-24
				i '$d(^TMP("DHCST","AspAmount","QueryAspAmount",pid,Index)) d
				.s ^TMP("DHCST","AspAmount","QueryAspAmount",pid,Index)=data
				e  d
				.s $p(^TMP("DHCST","AspAmount","QueryAspAmount",pid,Index),"^",8)=$p(^TMP("DHCST","AspAmount","QueryAspAmount",pid,Index),"^",8)+StkLbQty
				.s $p(^TMP("DHCST","AspAmount","QueryAspAmount",pid,Index),"^",15)=$p(^TMP("DHCST","AspAmount","QueryAspAmount",pid,Index),"^",15)+SpLbAmt
				.s $p(^TMP("DHCST","AspAmount","QueryAspAmount",pid,Index),"^",16)=$p(^TMP("DHCST","AspAmount","QueryAspAmount",pid,Index),"^",16)+RpLbAmt
			}
		}
	}
	s sub=""
	f  s sub=$o(^TMP("DHCST","AspAmount","QueryAspAmount",pid,sub)) q:sub=""  d
	.s data=^TMP("DHCST","AspAmount","QueryAspAmount",pid,sub)
	.s AspaIdLb=$p(data,"^",1)
	.s IncId=$p(data,"^",2)  q:IncId=""
	.s IncCode=$p(data,"^",3)
	.s IncDesc=$p(data,"^",4)
	.s Spec=$p(data,"^",5)
	.s ExecuteDate=$p(data,"^",6)
	.s AspUom=$p(data,"^",7)
	.s StkLbQty=$p(data,"^",8) q:+StkLbQty=0 
	.i StkLbQty<0  s tmpqty=StkLbQty,StkLbQty=-StkLbQty q:$g(tmpqty)<0 
	.s BUOM=$p(^INCI(IncId,1),"^",10) q:BUOM=""
	.s PurUom=$p(^INCI(IncId,3),"^",6)
	.s:PurUom="" PurUom=BUOM
	.s PurUomDesc=$p(^CT("UOM",PurUom),"^",2)
	.i $f(PurUomDesc,"[")  d
	..s PurUomDesc=$p(PurUomDesc,"[",1)
	.s BUomDesc=$p(^CT("UOM",BUOM),"^",2)
	.i PurUom=BUOM d
	..s StkLbQty=StkLbQty
	.e  d
	..s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(PurUom,BUOM)
	..s remainder=StkLbQty#fac     ;取余
	..i remainder=0  d
	...s StkLbQty=StkLbQty\fac
	..e  d
	...s IntQty=StkLbQty\fac
	...i IntQty>0  d
	....s StkLbQty=IntQty_PurUomDesc_remainder
	...e  d
	....s StkLbQty=remainder_BUomDesc
	.//s StkLbQty=##class(web.DHCST.Common.DrugStkCommon).QtyWithUom(IncId,StkLbQty)
	.s PriorSp=$p(data,"^",9)
	.s ResultSp=$p(data,"^",10)
	.s DiffSp=$p(data,"^",11)
	.s PriorRp=$p(data,"^",12)
	.s ResultRp=$p(data,"^",13)
	.s DiffLbRp=$p(data,"^",14)
	.s SpLbAmt=$p(data,"^",15)
	.s RpLbAmt=$p(data,"^",16)
	.s AspReason=$p(data,"^",17)
	.s AspUser=$p(data,"^",18)
	.s AuditUser=$p(data,"^",19)
	.s AspDate=$p(data,"^",20)
	.s WarrentNo=$p(data,"^",21)
	.s LocDesc=$p(data,"^",22)
	.d OutPutRow1
	k ^TMP("DHCST","AspAmount","QueryAspAmount",pid)
	q $$$OK

OutPutRow1
	s Data=$lb(AspaIdLb,IncId,IncCode,IncDesc,Spec,ExecuteDate,AspUom,StkLbQty,PriorSp,ResultSp,DiffSp,PriorRp,ResultRp,DiffLbRp,SpLbAmt,RpLbAmt,AspReason,AspUser,AuditUser,AspDate,WarrentNo,LocDesc)   
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod QueryAspAmountClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryAspAmountExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryAspAmountFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryAspAmountExecute ]
{
	 Set AtEnd=$LIST(qHandle,1)
	 Set repid=$LIST(qHandle,2)
	 Set ind=$LIST(qHandle,3)
	 Set ind=$o(^CacheTemp(repid,ind))
	 If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	 }
	 Else {			
	 		Set Row=^CacheTemp(repid,ind)
	 }
 
	 s qHandle=$lb(AtEnd,repid,ind)
	 Quit $$$OK
}

/// Descript:查询一段时间内的调价损益明细(批次)
/// Creater:	ZhangDongmei
/// CreateDate:	2013-01-08
/// Table:dhc_aspamount
/// Input:开始行,一页显示记录条数,开始日期,截止日期,
/// 科室id^调价单号^调价原因id^金额类型（1:差额为正，-1:差额为负,0:全部）^药品id^标志(1:ext调用，其他：润乾调用)
/// Output:		
/// Return：调价损益信息(批次)
/// w ##class(%ResultSet).RunQuery("web.DHCST.AspAmount","QueryAspBatAmount","","","2017-01-01","2017-01-07","102^^^1^^^^1","","")
Query QueryAspBatAmount(Sort As %String = "", Dir As %String = "", StartDate As %String = "", EndDate As %String = "", Others As %String = "", StartTime As %String = "", EndTime As %String = "") As %Query(ROWSPEC = "AspaIdLb:%String,IncId:%String,IncCode:%String,IncDesc:%String,Spec:%String,ExecuteDate:%String,AspUom:%String,StkLbQty:%Numeric,PriorSp:%Numeric,ResultSp:%Numeric,DiffSp:%Numeric,PriorRp:%Numeric,ResultRp:%Numeric,DiffLbRp:%Numeric,SpLbAmt:%Numeric,RpLbAmt:%Numeric,AspReason:%String,AspUser:%String,AuditUser:%String,AspDate:%String,WarrentNo:%String,LocDesc:%String,Incib:%String,BatExp:%String,DiffRp:%String,VendorDesc:%String") [ SqlProc ]
{
}

ClassMethod QueryAspBatAmountExecute(ByRef qHandle As %Binary, Sort As %String = "", Dir As %String = "", StartDate As %String = "", EndDate As %String = "", Others As %String = "", StartTime As %String = "", EndTime As %String = "") As %Status
{
	n (qHandle, Sort, Dir, StartDate, EndDate, Others, StartTime, EndTime)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:StartDate="" $$$OK
	q:EndDate="" $$$OK
	s pid=..NewPid()
	s AdjLocId=$p(Others,"^",1)
	s AdjBatNo=$p(Others,"^",2)
	s AdjReasonId=$p(Others,"^",3)
	s DiffType=$p(Others,"^",4)
	s ItmId=$p(Others,"^",5)
	s Flag=$p(Others,"^",6)
	i StartDate'="" s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	i EndDate'="" s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	i StartTime'="" s StartTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(StartTime)
    i EndTime'="" s EndTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(EndTime)
    s VenId=$p(Others,"^",7) //批次供应商id
    s type=$p(Others,"^",8) //统计类型
	s Dir=$$ALPHAUP^SSUTIL4(Dir)
	s:(Dir="")&(Dir'="ASC")&(Dir'="DESC") Dir="DESC"
	s CacuDate="",count=0
	f CacuDate=StartDate:1:EndDate {
		s AspaId=""
		while ("1"){
			s AspaId=$o(^ASPA(0,"DATE",CacuDate,AspaId)) 
			q:+AspaId=0
			s sql="select ASPALB_ASPA_Parref AspaId,"
			s sql=sql_"ASPALB_Rowid AspaIdLb,"
			s sql=sql_"ASPALB_ASPA_Parref->ASPA_No AspBatNo,"
			s sql=sql_"ASPALB_ASPA_Parref->ASPA_CTLOC_DR LocId,"
			s sql=sql_"ASPALB_ASPA_Parref->ASPA_CTLOC_DR->ctloc_desc LocDesc,"
			s sql=sql_"ASPALB_ASPA_Parref->ASPA_AdjPrice DiffSp,"
			s sql=sql_"ASPALB_ASPA_Parref->ASPA_INAPB_Dr AspBatId,"
			s sql=sql_"ASPALB_ASPA_Parref->ASPA_INCI_DR IncId,"
			s sql=sql_"ASPALB_ASPA_Parref->ASPA_INCI_DR->inci_code IncCode,"
			s sql=sql_"ASPALB_ASPA_Parref->ASPA_INCI_DR->inci_desc IncDesc,"
			s sql=sql_"ASPALB_ASPA_Parref->ASPA_StkQty StkQty,"
			s sql=sql_"ASPALB_Qty StkLbQty,"
			s sql=sql_"ASPALB_ASPA_Parref->ASPA_Amount SpAmt,"
			s sql=sql_"ASPALB_AdjAmt SpLbAmt,"
			s sql=sql_"ASPALB_ASPA_Parref->ASPA_Date AspaDate,"
			s sql=sql_"ASPALB_ASPA_Parref->ASPA_Time AspaTime,"
			s sql=sql_"ASPALB_ASPA_Parref->ASPA_AdjRP DiffRp,"
			s sql=sql_"ASPALB_AdjRP DiffLbRp,"
			s sql=sql_"ASPALB_ASPA_Parref->ASPA_RPAmt RpAmt,"
			s sql=sql_"ASPALB_RPAmt  RpLbAmt,"
			s sql=sql_"ASPALB_INCLB_DR InciLb"
			s sql=sql_" from DHC_ASPAmountLB"
			s sql=sql_" where ASPALB_ASPA_Parref="_AspaId
			s:Sort="" Sort="IncCode"
			i Sort'="" d
			.s sql=sql_"   Order By "_Sort_" "_Dir
			s xrs=##class(%Library.ResultSet).%New()
			d xrs.Prepare(sql)
			s sc=xrs.Execute()
			i $$$ISERR(sc) q 
			while (xrs.Next())
			{  
				s AspaId=xrs.Data("AspaId") 
				//w AspaId,!
				s AspaDate=xrs.Data("AspaDate")
				s AspaTime=xrs.Data("AspaTime")
				i AspaDate'="" s AspaDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(AspaDate)

				continue:AspaDate<StartDate
				continue:AspaDate>EndDate
				i AspaTime'="" s AspaTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(AspaTime)
				continue:(AspaTime<StartTime)&&(StartTime'="")&&(AspaDate=StartDate)
				continue:(AspaTime>EndTime)&&(EndTime'="")&&(AspaDate=EndDate)

				s AspaIdLb=xrs.Data("AspaIdLb")

				s AspBatNo=xrs.Data("AspBatNo")
				s AspBatNoI=$$ALPHAUP^SSUTIL4(AspBatNo)
				//s APBID=$o(^DHCSTINAPB(0,"ASPNO",AspBatNoI,""))
				//continue:APBID=""
				continue:(AdjBatNo'="")&(AspBatNo'=AdjBatNo)
				s LocId=xrs.Data("LocId")
				continue:(AdjLocId'="")&(LocId'=AdjLocId)
				s LocDesc=xrs.Data("LocDesc")
				s DiffSp=xrs.Data("DiffSp") 
				continue:(DiffType=1)&(DiffSp<=0)   ;只统计差额为正
				continue:(DiffType=-1)&(DiffSp>=0)   ;只统计差额为负
				s AspBatId=xrs.Data("AspBatId")
				continue:AspBatId=""
				s AspReasonId=$p(^DHCSTINAPB(AspBatId),"^",29)
				s AspReason=""
				s:AspReasonId'="" AspReason=$p(^DHCSTREASON("ASP",AspReasonId),"^",2) 
				continue:(AdjReasonId'="")&(AspReasonId'=AdjReasonId)
				s IncId=xrs.Data("IncId")  
				continue:(ItmId'="")&(IncId'=ItmId)
				s scgInfo=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(IncId)
				s stkType=$p(scgInfo,"^",3)
				//q:(stkType'="")&(stkType'=..sssCode())
				continue:(stkType'="")&(stkType'=..sssCode())
				s IncCode=xrs.Data("IncCode")
				s IncDesc=xrs.Data("IncDesc")

				s StkQty=xrs.Data("StkQty")
				s StkLbQty=xrs.Data("StkLbQty")

				s SpAmt=xrs.Data("SpAmt")    //差额(售价)
				s SpLbAmt=xrs.Data("SpLbAmt")
				s InciLb=xrs.Data("InciLb")
				//wyx add 2014-01-16 增加对批次供应商的过滤，由从DHC_ASPAmount取数据改为从DHC_ASPAmountLB取数据
				s VendorInfo=##class(web.DHCST.Common.DrugStkCommon).GetInclbVend(InciLb,AspaDate)
				s VendorId=$p(VendorInfo,"^",1)
				s VendorDesc=$p(VendorInfo,"^",2)
				continue:(VenId'="")&(VendorId'=VenId)

				s DiffRp=xrs.Data("DiffRp")
				s DiffLbRp=xrs.Data("DiffLbRp")

				s RpAmt=xrs.Data("RpAmt")   //差额(进价)
				s RpLbAmt=xrs.Data("RpLbAmt") 

				s Spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",IncId)
				s ExecuteDate=$p(^DHCSTINAPB(AspBatId),"^",16)
				s:ExecuteDate'="" ExecuteDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(ExecuteDate,"ST")
				s AspUomId=$p(^DHCSTINAPB(AspBatId),"^",5)
				s:AspUomId'="" AspUom=$p(^CT("UOM",AspUomId),"^",2)
				s BUomId=$p(^INCI(IncId,1),"^",10)
				s ConFac=##class(web.DHCST.Common.UtilCommon).UOMFac(AspUomId,BUomId)
				s PriorRp=$p(^DHCSTINAPB(AspBatId),"^",10)     ;基本单位对应的调前进价
				s ResultRp=$p(^DHCSTINAPB(AspBatId),"^",11)		;基本单位对应的调后进价
				s PriorSp=$p(^DHCSTINAPB(AspBatId),"^",12)      ;基本单位对应的调前售价
				s ResultSp=$p(^DHCSTINAPB(AspBatId),"^",13)		;基本单位对应的调后售价
				
				s ResultRpUom=$p(^DHCSTINAPB(AspBatId),"^",7)		;调价单位对应的调后进价
				s ResultSpUom=$p(^DHCSTINAPB(AspBatId),"^",9)		;调价单位对应的调后售价
				s ResultRp=ResultRpUom
				s ResultSp=ResultSpUom
				s PriorRp=$p(^DHCSTINAPB(AspBatId),"^",6)
				s PriorSp=$p(^DHCSTINAPB(AspBatId),"^",8)
				
				s DiffSp=DiffSp*ConFac
				s DiffRp=DiffRp*ConFac
				s DiffLbRp=DiffLbRp*ConFac
				s StkQty=##class(web.DHCST.Common.DrugStkCommon).QtyWithUom(IncId,StkQty)
				//s StkLbQty=##class(web.DHCST.Common.DrugStkCommon).QtyWithUom(IncId,StkLbQty)
				s AdjUserId=$p(^DHCSTINAPB(AspBatId),"^",18)
				s:AdjUserId'="" AdjUserName=$p(^SSU("SSUSR",AdjUserId),"^",2)
				s AuditUserId=$p(^DHCSTINAPB(AspBatId),"^",21) 
				s:AuditUserId'="" AuditUserName=$p(^SSU("SSUSR",AuditUserId),"^",2)
				s WarrentNo=$p(^DHCSTINAPB(AspBatId),"^",27)    ;物价文件号
				s Incib=$p(^DHCSTINAPB(AspBatId),"^",4)
				continue:'$d(^INCI(+Incib,"IB",$p(Incib,"||",2)))

				s BatNo=$p(^INCI(+Incib,"IB",$p(Incib,"||",2)),"^",1)
				s ExpDate=$p(^INCI(+Incib,"IB",$p(Incib,"||",2)),"^",2)
				s ExpDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(ExpDate,"ST")
				s BatExp = BatNo_"~"_ExpDate
				i AspaDate'="" s AspaDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(AspaDate,"ST")
				s data=AspaIdLb_"^"_IncId_"^"_IncCode_"^"_IncDesc_"^"_Spec_"^"_ExecuteDate_"^"_AspUom_"^"_StkLbQty_"^"_PriorSp_"^"_ResultSp_"^"_DiffSp_"^"_PriorRp_"^"_ResultRp_"^"_DiffLbRp_"^"_SpLbAmt_"^"_RpLbAmt_"^"_AspReason_"^"_AdjUserName_"^"_AuditUserName_"^"_AspaDate_"^"_WarrentNo_"^"_LocDesc_"^"_Incib_"^"_BatExp_"^"_DiffRp_"^"_VendorDesc
				i type="1" s Index=IncCode_","_IncDesc_","_Incib
				e  s Index=IncCode_","_IncDesc_","_LocId_","_LocDesc_","_Incib
				i '$d(^TMP("DHCST","AspAmount","QueryAspBatAmount",pid,Index)) d
				.s ^TMP("DHCST","AspAmount","QueryAspBatAmount",pid,Index)=data
				e  d
				.s $p(^TMP("DHCST","AspAmount","QueryAspBatAmount",pid,Index),"^",8)=$p(^TMP("DHCST","AspAmount","QueryAspBatAmount",pid,Index),"^",8)+StkLbQty
				.s $p(^TMP("DHCST","AspAmount","QueryAspBatAmount",pid,Index),"^",15)=$p(^TMP("DHCST","AspAmount","QueryAspBatAmount",pid,Index),"^",15)+SpLbAmt
				.s $p(^TMP("DHCST","AspAmount","QueryAspBatAmount",pid,Index),"^",16)=$p(^TMP("DHCST","AspAmount","QueryAspBatAmount",pid,Index),"^",16)+RpLbAmt
			}
		}  	
	}
	s sub=""
	f  s sub=$o(^TMP("DHCST","AspAmount","QueryAspBatAmount",pid,sub)) q:sub=""  d
	.s data=^TMP("DHCST","AspAmount","QueryAspBatAmount",pid,sub)
	.s AspaIdLb=$p(data,"^",1)
	.s IncId=$p(data,"^",2)
	.s IncCode=$p(data,"^",3)
	.s IncDesc=$p(data,"^",4)
	.s Spec=$p(data,"^",5)
	.s ExecuteDate=$p(data,"^",6)
	.s AspUom=$p(data,"^",7)
	.s StkLbQty=$p(data,"^",8)
	.;s StkLbQty=##class(web.DHCST.Common.DrugStkCommon).QtyWithUom(IncId,StkLbQty)
	.s PriorSp=$p(data,"^",9)
	.s ResultSp=$p(data,"^",10)
	.s DiffSp=$p(data,"^",11)
	.s PriorRp=$p(data,"^",12)
	.s ResultRp=$p(data,"^",13)
	.s DiffLbRp=$p(data,"^",14)
	.s SpLbAmt=$p(data,"^",15)
	.s RpLbAmt=$p(data,"^",16)
	.s AspReason=$p(data,"^",17)
	.s AspUser=$p(data,"^",18)
	.s AuditUser=$p(data,"^",19)
	.s AspDate=$p(data,"^",20)
	.s WarrentNo=$p(data,"^",21)
	.s LocDesc=$p(data,"^",22)
	.s Incib=$p(data,"^",23)
	.s BatExp=$p(data,"^",24)
	.s DiffRp=$p(data,"^",25)
	.s VendorDesc=$p(data,"^",26)
	.d OutPutRow11
	.
	q $$$OK

OutPutRow11
	s Data=$lb(AspaIdLb,IncId,IncCode,IncDesc,Spec,ExecuteDate,AspUom,StkLbQty,PriorSp,ResultSp,DiffSp,PriorRp,ResultRp,DiffLbRp,SpLbAmt,RpLbAmt,AspReason,AspUser,AuditUser,AspDate,WarrentNo,LocDesc,Incib,BatExp,DiffRp,VendorDesc)   
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod QueryAspBatAmountClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryAspBatAmountExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryAspBatAmountFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryAspBatAmountExecute ]
{
	 Set AtEnd=$LIST(qHandle,1)
	 Set repid=$LIST(qHandle,2)
	 Set ind=$LIST(qHandle,3)
	 Set ind=$o(^CacheTemp(repid,ind))
	 If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	 }
	 Else {			
	 		Set Row=^CacheTemp(repid,ind)
	 }
 
	 s qHandle=$lb(AtEnd,repid,ind)
	 Quit $$$OK
}

/// Descript:查询一段时间内的批次调价损益明细
/// Creater:	ZhangDongmei
/// CreateDate:	2013-01-10
/// Table:dhc_aspamountlb
/// Input:排序字段,排序方向,开始日期,截止日期,
/// 科室id^调价单号^调价原因id^金额类型（1:差额为正，-1:差额为负,0:全部）^药品id^供应商id
/// Output:		
/// Return：调价损益信息
/// w ##class(%ResultSet).RunQuery("web.DHCST.AspAmount","QueryAspAmountLB","2016-11-28","2016-11-29","102^^^0^^"","","")
Query QueryAspAmountLB(StartDate As %String = "", EndDate As %String = "", Others As %String = "", StartTime As %String = "", EndTime As %String = "") As %Query(ROWSPEC = "AspalbId:%String,IncId:%String,IncCode:%String,IncDesc:%String,Spec:%String,ExecuteDate:%String,AspUom:%String,Qty:%Numeric,PriorSp:%Numeric,ResultSp:%Numeric,DiffSp:%Numeric,PriorRp:%Numeric,ResultRp:%Numeric,DiffRp:%Numeric,SpAmt:%Numeric,RpAmt:%Numeric,AspReason:%String,AspUser:%String,AuditUser:%String,AspDate:%String,WarrentNo:%String,LocDesc:%String,AspNo:%String,VendorId:%String,VendorDesc:%String") [ SqlProc ]
{
}

ClassMethod QueryAspAmountLBExecute(ByRef qHandle As %Binary, StartDate As %String = "", EndDate As %String = "", Others As %String = "", StartTime As %String = "", EndTime As %String = "") As %Status
{
	//s ^hlh($h)=$lb(StartDate,EndDate,Others,StartTime,EndTime)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:StartDate="" $$$OK
	q:EndDate="" $$$OK
	s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	s AdjLocId=$p(Others,"^",1)
	s AdjNo=$p(Others,"^",2)
	s AdjReasonId=$p(Others,"^",3)
	s DiffType=$p(Others,"^",4)
	s ItmId=$p(Others,"^",5)
	s VenId=$p(Others,"^",6)
	;
    i StartTime[":" s StartTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(StartTime)
    i EndTime[":" s EndTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(EndTime)
	f date=StartDate:1:EndDate  d
	.i ItmId'=""  d
	..i AdjLocId'=""  d
	...s Aspa=0
	...f  s Aspa=$o(^ASPA(0,"DATEINCIL",date,ItmId,AdjLocId,Aspa)) q:Aspa=""  d
	....s AspaTime=$p(^ASPA(Aspa),"^",9)
	....i date=StartDate q:(AspaTime<StartTime)&&(StartTime'="")
    ....i date=EndDate q:(AspaTime>EndTime)&&(EndTime'="")
	....d GetDetail(Aspa)
	..e   d
	...s Loc=0
	...f  s Loc=$o(^ASPA(0,"DATEINCIL",date,ItmId,Loc)) q:Loc=""  d
	....s Aspa=0
	....f  s Aspa=$o(^ASPA(0,"DATEINCIL",date,ItmId,Loc,Aspa)) q:Aspa=""  d
	.....s AspaTime=$p(^ASPA(Aspa),"^",9)
	.....i date=StartDate q:(AspaTime<StartTime)&&(StartTime'="")
    .....i date=EndDate q:(AspaTime>EndTime)&&(EndTime'="")
	.....d GetDetail(Aspa)
	....
	...
	..
	.e   d
	..s Inc=0
	..f  s Inc=$o(^ASPA(0,"DATEINCIL",date,Inc))  q:Inc=""  d
	...s Loc=0
	...f  s Loc=$o(^ASPA(0,"DATEINCIL",date,Inc,Loc)) q:Loc=""  d
	....s Aspa=0
	....f  s Aspa=$o(^ASPA(0,"DATEINCIL",date,Inc,Loc,Aspa)) q:Aspa=""  d
	.....q:'$d(^ASPA(Aspa))
	.....s AspaTime=$p(^ASPA(Aspa),"^",9)
	.....i date=StartDate q:(AspaTime<StartTime)&&(StartTime'="")
    .....i date=EndDate q:(AspaTime>EndTime)&&(EndTime'="")
	.....d GetDetail(Aspa)
	....
	...
	..
	.
	q $$$OK
GetDetail(AspaId)
  s chl=0
  f  s chl=$o(^ASPA(AspaId,"LB",chl))  q:chl=""  d
  .s AspalbId=AspaId_"||"_chl
  .s Inclb=$p(^ASPA(AspaId,"LB",chl),"^",1)
  .s Qty=$p(^ASPA(AspaId,"LB",chl),"^",2)
  .s DiffSp=$p(^ASPA(AspaId,"LB",chl),"^",3)
  .s SpAmt=$p(^ASPA(AspaId,"LB",chl),"^",4)
  .s DiffRp=$p(^ASPA(AspaId,"LB",chl),"^",5)
  .s RpAmt=$p(^ASPA(AspaId,"LB",chl),"^",6)
  .s PriorRp=$p(^ASPA(AspaId,"LB",chl),"^",7)
  .s LocId=$p(^ASPA(AspaId),"^",2)
  .s AspNo=$p(^ASPA(AspaId),"^",6)
  .s AspaDate=$p(^ASPA(AspaId),"^",8)
  .q:(AdjNo'="")&(AspNo'=AdjNo)
  .q:(AdjLocId'="")&(LocId'=AdjLocId)
  .q:(DiffType=1)&(DiffSp<0)   ;只统计差额为正
  .q:(DiffType=-1)&(DiffSp>0)   ;只统计差额为负
  .s IncId=+Inclb
  .q:(ItmId'="")&(IncId'=ItmId)
  .s scgInfo=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(IncId)
  .s stkType=$p(scgInfo,"^",3)
  .q:(stkType'="")&(stkType'=..sssCode())
  .s VendorInfo=##class(web.DHCST.Common.DrugStkCommon).GetInclbVend(Inclb,AspaDate)
  .s VendorId=$p(VendorInfo,"^",1)
  .s VendorDesc=$p(VendorInfo,"^",2)
  .q:(VenId'="")&(VendorId'=VenId)
  .s LocDesc=$p(^CTLOC(LocId),"^",2)
  .s:AspaDate'="" AspaDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(AspaDate,"ST")
  .s IncCode=$p(^INCI(IncId,1),"^",1)
  .s IncDesc=$p(^INCI(IncId,1),"^",2)
  .s Spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",IncId)
  .s adjbtAspId=$p(^ASPA(AspaId),"^",13)
  .i adjbtAspId'=""  d
  ..s AspReasonId=$p(^DHCSTINAPB(adjbtAspId),"^",29)
  ..s ExecuteDate=$p(^DHCSTINAPB(adjbtAspId),"^",16)
  ..s AspUomId=$p(^DHCSTINAPB(adjbtAspId),"^",5)
  ..s ResultRp=$p(^DHCSTINAPB(adjbtAspId),"^",11)		;基本单位对应的调后进价
  ..s PriorSp=$p(^DHCSTINAPB(adjbtAspId),"^",12)      ;基本单位对应的调前售价
  ..s ResultSp=$p(^DHCSTINAPB(adjbtAspId),"^",13)		;基本单位对应的调后售价
  ..s AdjUserId=$p(^DHCSTINAPB(adjbtAspId),"^",18)
  ..s AuditUserId=$p(^DHCSTINAPB(adjbtAspId),"^",21)
  ..s WarrentNo=$p(^DHCSTINAPB(adjbtAspId),"^",27)    ;物价文件号 
  .e  d
  ..s AspId=$p(^ASPA(AspaId),"^",10)
  ..s AspReasonId=$p(^INASP(AspId),"^",28)
  ..s ExecuteDate=$p(^INASP(AspId),"^",2)
  ..s AspUomId=$p(^INASP(AspId),"^",10)
  ..s ResultRp=$p(^INASP(AspId),"^",16)		;基本单位对应的调后进价
  ..s PriorSp=$p(^INASP(AspId),"^",6)      ;基本单位对应的调前售价
  ..s ResultSp=$p(^INASP(AspId),"^",7)		;基本单位对应的调后售价
  ..s AdjUserId=$p(^INASP(AspId),"^",3)
  ..s AuditUserId=$p(^INASP(AspId),"^",21) 
  ..s WarrentNo=$p(^INASP(AspId),"^",12)    ;物价文件号
  .s:AspReasonId'="" AspReason=$p(^DHCSTREASON("ASP",AspReasonId),"^",2) 
  .q:(AdjReasonId'="")&(AspReasonId'=AdjReasonId)
  .s:ExecuteDate'="" ExecuteDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(ExecuteDate,"ST")
  .s:AspUomId'="" AspUom=$p(^CT("UOM",AspUomId),"^",2)
  .s BUomId=$p(^INCI(IncId,1),"^",10)
  .s ConFac=##class(web.DHCST.Common.UtilCommon).UOMFac(AspUomId,BUomId)
  .s PriorRp=PriorRp*ConFac
  .s ResultRp=ResultRp*ConFac
  .s PriorSp=PriorSp*ConFac
  .s ResultSp=ResultSp*ConFac
  .s DiffSp=DiffSp*ConFac
  .s DiffRp=DiffRp*ConFac
  .s Qty=Qty/ConFac //数量
  .s:AdjUserId'="" AdjUserName=$p(^SSU("SSUSR",AdjUserId),"^",2)
  .s:AuditUserId'="" AuditUserName=$p(^SSU("SSUSR",AuditUserId),"^",2)
  .d OutPutRow2
  q
OutPutRow2
	s Data=$lb(AspalbId,IncId,IncCode,IncDesc,Spec,ExecuteDate,AspUom,Qty,PriorSp,ResultSp,DiffSp,PriorRp,ResultRp,DiffRp,SpAmt,RpAmt,AspReason,AdjUserName,AuditUserName,AspaDate,WarrentNo,LocDesc,AspNo,VendorId,VendorDesc)   
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod QueryAspAmountLBClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryAspAmountLBExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryAspAmountLBFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryAspAmountLBExecute ]
{
	 Set AtEnd=$LIST(qHandle,1)
	 Set repid=$LIST(qHandle,2)
	 Set ind=$LIST(qHandle,3)
	 Set ind=$o(^CacheTemp(repid,ind))
	 If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	 }
	 Else {			
	 		Set Row=^CacheTemp(repid,ind)
	 }
 
	 s qHandle=$lb(AtEnd,repid,ind)
	 Quit $$$OK
}

ClassMethod NewPid() As %String
{
	  	q $I(^DHCSTPID("AspAmount"))
}

}
