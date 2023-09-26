Import sqluser

/// Descript:供应商供应项目列表维护
/// Creater:	zhangxiao
/// CreateDate:	2013-05-10
/// 
Class web.DHCSTMHUI.ApcWarn Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	查找资质信息不符供应商合条件的
/// Creater:	zhangxiao
/// CreateDate:	2013-05-07
/// Table:DHC_STVendor ,DHC_STVendor
/// Input:开始行,一页显示记录数,合同开始日期^合同结束日期^资质有效日期
/// Output:		
/// Return：资质不符合日期范围的供应商的 rowid^供应商代码^供应商名称^合同截止日期
/// w ##class(web.DHCSTMHUI.ApcWarn).Query(0,40,"2013-05-18^2026-06-25^2017-05-17")
ClassMethod Query(Start As %Integer, Limit As %Integer, List As %String) As %String
{
	 n (Start,Limit,List)
	 s sdate=$p(List,"^",1)
	 s edate=$p(List,"^",2)
	 s zedate=$p(List,"^",3)
     s nullResult="{rows:[],results:0}"
	 i zedate="" w nullResult q     
     s:zedate'="" zedate=$zdh(zedate,3)
     s Type=..sssCode()
	 s result = ##class(%Library.ResultSet).%New()
	 s StrSql="select APCVM_RowId,APCVM_Code,APCVM_Name,APCVM_LstPoDate,DHCIV_Rowid,DHCIV_INCI_DR,DHCIV_MANF_DR,APCVM_Status Status from  APC_Vendor "
	 s StrSql=StrSql_"left JOIN DHC_ItmVen on APCVM_RowId=DHCIV_APCVM_DR where  APCVM_Type="_"'"_Type_"'"
	 
	 d result.Prepare(StrSql)
	 d result.Execute()
	 s count=0
	 s resultString = ""
	 s end = Start+Limit
	 s json=##class(web.DHCSTMHUI.Common.JsonObj).%New()
	 While(result.Next())
	 {
		s apcdr = result.Data("APCVM_RowId") 
		CONTINUE:+apcdr=0
		s ApcvmCode=result.Data("APCVM_Code")
		s ApcvmName=result.Data("APCVM_Name")
		s Status=result.Data("Status")
	 	CONTINUE:Status'="A"  //按状态加以过滤
		s itmven=result.Data("DHCIV_Rowid")
		s IncItm=result.Data("DHCIV_INCI_DR")
		s phmanfdr=result.Data("DHCIV_MANF_DR")
		s LstPoDate=result.Data("APCVM_LstPoDate")
		s slist=apcdr_"||"_IncItm_"||"_phmanfdr_"||"_count
		i (LstPoDate'="") d
		.s LstPoDate=..DL2H(LstPoDate)
		s MDesc=""
		i IncItm'="" d
		.s MDesc=$p(^INCI(IncItm,1),"^",2)
		s PhManf=""
		i (phmanfdr'="") d
		.s PhManf=$p(^PHMNF(phmanfdr),"^",2)
		s ret=0
		s ret=..CheckDate(zedate,apcdr)
		s err=0
		i phmanfdr'="" d
		.s err=..CheckPhManf(zedate,phmanfdr)
	    CONTINUE:((ret=0)&(err=0))
        s Data=apcdr_"^"_ApcvmCode_"^"_ApcvmName_"^"_LstPoDate_"^"_IncItm_"^"_MDesc_"^"_PhManf_"^"_slist
        s count=count+1
        d json.InsertRowData(Data)
        CONTINUE:count<(Start+1)
	   	CONTINUE:count>end
	}
	d result.Close()
	d json.getJsonData("apcdr^ApcvmCode^ApcvmName^LstPoDate^IncItm^MDesc^PhManf^slist",count)
}

/// Descript:	查找资质信息不符供应商合条件的
/// Creater:	zhangxiao
/// CreateDate:	2013-05-07
/// Table:DHC_STVendor ,DHC_STVendor
/// Input:开始行,一页显示记录数,开始日期^结束日期
/// Output:		
/// Return：0 不符合条件 
ClassMethod CheckPhManf(zedate As %Integer, phmanfdr As %String) As %String
{
	n (zedate,phmanfdr)
	q:phmanfdr="" 1
	q:'$d(^DHCMANF(0,"MANF",phmanfdr)) 3
	s manfdr=$o(^DHCMANF(0,"MANF",phmanfdr,""))   // 生产厂家附加信息rowid
	q:manfdr="" 4
	s DrugProductExpDate=$p(^DHCMANF(manfdr),"^",4)
	q:((DrugProductExpDate'="")&(DrugProductExpDate<zedate)) 5  //药品生产许可证
	s MatProductExpDate=$p(^DHCMANF(manfdr),"^",6)
	q:((MatProductExpDate'="")&(MatProductExpDate<zedate)) 6 //材料生产许可证
	s ComLicDate=$p(^DHCMANF(manfdr),"^",9)
	q:((ComLicDate'="")&(ComLicDate<zedate)) 7          //工商执照
	s BusinessRegExpDate=$p(^DHCMANF(manfdr),"^",12)
	q:((BusinessRegExpDate'="")&(BusinessRegExpDate<zedate)) 8   //工商注册号
	s OrgCodeExpDate=$p(^DHCMANF(manfdr),"^",14)
	q:((OrgCodeExpDate'="")&(OrgCodeExpDate<zedate)) 9   //组织机构代码
	s TaxRegNo=$p(^DHCMANF(manfdr),"^",15)                //税务登记号  
	q 0
}

/// Descript:	查找资质信息不符供应商合条件的
/// Creater:	zhangxiao
/// CreateDate:	2013-05-07
/// Table:DHC_STVendor ,DHC_STVendor
/// Input:开始行,一页显示记录数,开始日期^结束日期
/// Output:		
/// Return：0 不符合条件 
ClassMethod CheckDate(zedate As %Integer, apcdr As %String) As %String
{
  n (apcdr,zedate)
  q:'$d(^DHCSTV(0,apcdr)) 1
  s dhcdr=$o(^DHCSTV(0,apcdr,""))
  q:dhcdr="" 1
  s comlicdate=$p(^DHCSTV(dhcdr),"^",2)
  q:((comlicdate'="")&(comlicdate<zedate)) 2 
  s revregdate=$p(^DHCSTV(dhcdr),"^",24)
  q:((revregdate'="")&(revregdate<zedate)) 3 
  s drugmanlicdate=$p(^DHCSTV(dhcdr),"^",5)
  q:((drugmanlicdate'="")&(drugmanlicdate<zedate)) 4 
  s matmanlicdate=$p(^DHCSTV(dhcdr),"^",15)
  q:((matmanlicdate'="")&(matmanlicdate<zedate)) 5
  s matenroldate=$p(^DHCSTV(dhcdr),"^",13)
  q:((matenroldate'="")&(matenroldate<zedate)) 6 
  s sanitationdate=$p(^DHCSTV(dhcdr),"^",26)
  q:((sanitationdate'="")&(sanitationdate<zedate)) 7 
  s orgcodedate=$p(^DHCSTV(dhcdr),"^",19)
  q:((orgcodedate'="")&(orgcodedate<zedate)) 8 
  s gspdate=$p(^DHCSTV(dhcdr),"^",7)
  q:((gspdate'="")&(gspdate<zedate)) 9
  s matprodate=$p(^DHCSTV(dhcdr),"^",17)
  q:((matprodate'="")&(matprodate<zedate)) 10
  s propermitdate=$p(^DHCSTV(dhcdr),"^",22)
  q:((propermitdate'="")&(propermitdate<zedate)) 11 
  s impenroldate=$p(^DHCSTV(dhcdr),"^",9)
  q:((impenroldate'="")&(impenroldate<zedate)) 12 
  s implicdate=$p(^DHCSTV(dhcdr),"^",11)
  q:((implicdate'="")&(implicdate<zedate)) 13
  s agentlicdate=$p(^DHCSTV(dhcdr),"^",30)
  q:((agentlicdate'="")&(agentlicdate<zedate)) 14
  s qualitydate=$p(^DHCSTV(dhcdr),"^",31)
  q:((qualitydate'="")&(qualitydate<zedate)) 15 
  s salesdate=$p(^DHCSTV(dhcdr),"^",33)
  q:((salesdate'="")&(salesdate<zedate)) 16
  q 0
}

}
