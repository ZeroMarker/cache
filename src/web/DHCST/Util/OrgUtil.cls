Import sqluser

/// Descript:医院、科室、人员等Store的取法
/// 在dhcst.orgutil.csp中调用
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-07
Class web.DHCST.Util.OrgUtil Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// creator:zhangyong
/// date:2011-10-14
/// description: 药房ComboBox
/// input:  Start(起始数值)  Limit(增长数值)
/// output: String "RowId^Description"
/// others:
/// w ##class(web.DHCST.Util.OrgUtil).GetPhaDept(0,30,"mzx")
ClassMethod GetPhaDept(Start, Limit, Desc)
{
	s hos=%session.Data("LOGON.HOSPID")
	s Desc=$$ALPHAUP^SSUTIL4(Desc)
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "SELECT CTLOC_ROWID AS RowId, CTLOC_DESC AS Description,CTLOC_ContactName AS ConName FROM CT_Loc WHERE CTLOC_TYPE = 'D' AND  CTLOC_Hospital_DR=:hos ORDER BY CTLOC_ROWID"
    d result.Prepare(sqlStr)
    d result.Execute()
    s count = 0
    s resultString = ""
    s end = Start+Limit
    s json = ##class(Code.JsonObj).%New()
    While(result.Next())
    {
	    s Rowid = result.Data("RowId")
	    s Description = result.Data("Description")
	    s quitFlag=""
	    if (Desc'="") {
		    s ConName=$zcvt(result.Data("Description"),"U")
			s DescPY=##class(web.DHCST.Common.AppCommon).GetCNCODE(Description)
			i (DescPY'[Desc)&&(Description'[Desc)&&(ConName'[Desc) s quitFlag=1
		}
	    s dateTo = $p(^CTLOC(Rowid), "^", 25)
		continue:(dateTo '= "")&&(dateTo <= (+$h))
	    continue:quitFlag'=""
	    s tmp=Rowid_"^"_Description
	    s count = count+1
	    i (count>Start)&(count<=end) d
	    .d json.InsertRowData(tmp)
    }
    d result.Close()
    s resultString = json.getJsonData("RowId^Description",count)
    k json
    q resultString
}

/// creator:zhangyong
/// date:2011-10-14
/// description: 药房ComboBox
/// input:  Start(起始数值)  Limit(增长数值)
/// output: String "RowId^Description"
/// others:
/// w ##class(web.DHCST.Util.OrgUtil).GetExeDept(0,30,"nfm")
ClassMethod GetExeDept(Start, Limit, Desc)
{
	s hos=%session.Data("LOGON.HOSPID")
	s Desc=$$ALPHAUP^SSUTIL4(Desc)
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "SELECT CTLOC_ROWID AS RowId, CTLOC_DESC AS Description,CTLOC_ContactName AS ConName FROM CT_Loc WHERE CTLOC_TYPE = 'E' AND CTLOC_Hospital_DR=:hos ORDER BY CTLOC_ROWID"
    d result.Prepare(sqlStr)
    d result.Execute()
    s count = 0
    s resultString = ""
    s end = Start+Limit
    s json = ##class(Code.JsonObj).%New()
    While(result.Next())
    {
	    s Rowid = result.Data("RowId")
	    s Description = result.Data("Description")
	    s quitFlag=""
	    if (Desc'="") {
		    s ConName=$zcvt(result.Data("Description"),"U")
			s DescPY=##class(web.DHCST.Common.AppCommon).GetCNCODE(Description)
			i (DescPY'[Desc)&&(Description'[Desc)&&(ConName'[Desc) s quitFlag=1
		}
	    s dateTo = $p(^CTLOC(Rowid), "^", 25)
		continue:(dateTo '= "")&&(dateTo <= (+$h))
	    continue:quitFlag'=""
	    s tmp=Rowid_"^"_Description
	    s count = count+1
	    i (count>Start)&(count<=end) d
	    .d json.InsertRowData(tmp)
    }
    d result.Close()
    s resultString = json.getJsonData("RowId^Description",count)
    k json
    q resultString
}

/// creator:zhangyong
/// date:2011-10-14
/// description: 临床科室ComboBox
/// input:  Start(起始数值)  Limit(增长数值)
/// output: String "RowId^Description"
/// others:
ClassMethod GetClinicDept(Start, Limit)
{
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "SELECT CTLOC_ROWID AS RowId, CTLOC_DESC AS Description FROM CT_Loc WHERE CTLOC_TYPE = 'E' ORDER BY CTLOC_ROWID"
    d result.Prepare(sqlStr)
    d result.Execute()
    s count = 0
    s resultString = ""
    s end = Start+Limit
    s json = ##class(Code.JsonObj).%New()
    While(result.Next())
    {
    s Rowid = result.Data("RowId")
    s Description = result.Data("Description")
    s tmp=Rowid_"^"_Description
    s count = count+1
    i (count>Start)&(count<=end) d
    .d json.InsertRowData(tmp)
    }
    d result.Close()
    s resultString = json.getJsonData("RowId^Description",count)
    k json
    q resultString
}

/// creator:zhangyong
/// date:2011-10-14
/// description: 科室ComboBox
/// input:  Start(起始数值)  Limit(增长数值)
/// output: String "RowId^Description"
/// others:w ##class(web.DHCST.Util.OrgUtil).GetDeptLoc(0,999,"mzx",9)
ClassMethod GetDeptLoc(Start, Limit, Desc, HospId = "") As %String
{
    n (Start, Limit,Desc,HospId)
    s Desc=$$ALPHAUP^SSUTIL4(Desc)
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "SELECT CTLOC_ROWID AS RowId, CTLOC_DESC AS Description FROM CT_Loc WHERE (%ALPHAUP(CTLOC_DESC) like '%"_Desc_"%' or %ALPHAUP(CTLOC_ContactName) like '%"_Desc_"%')"
    d result.Prepare(sqlStr)
    d result.Execute()
    s count = 0
    s resultString = ""
    s end = Start+Limit
    s json = ##class(Code.JsonObj).%New()
    While(result.Next())
    {
    s Rowid = result.Data("RowId")
    s ActTo=$p(^CTLOC(Rowid),"^",25)
    Continue:(ActTo'="")&&(ActTo<+$H)
    s locHosp=$p(^CTLOC(Rowid),"^",22)
    Continue:(HospId'=locHosp)
    s Description = result.Data("Description")
    s tmp=Rowid_"^"_Description
    s count = count+1
    i (count>Start)&(count<=end) d
    .d json.InsertRowData(tmp)
    }
    d result.Close()
    s resultString = json.getJsonData("RowId^Description",count)
    k json
    q resultString
}

/// creator:zhangyong
/// date:2011-12-20
/// description: 招标配送商ComboBox
/// input:  
/// output: String "RowId^Description"
/// others:w ##class(web.DHCST.Util.OrgUtil).GetCarrier("bj",0,999)
ClassMethod GetCarrier(CADesc, Start, Limit, StkType As %String = "G", Hosp = "")
{
	s CADesc=$$ALPHAUP^SSUTIL4(CADesc)
    s StkType=$g(StkType)
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "SELECT Ca_RowId as RowId, Ca_Desc as Description FROM DHC_Carrier WHERE CA_Type ="_"'"_StkType_"'"_" ORDER BY Ca_RowId"
    d result.Prepare(sqlStr)
    d result.Execute()
    s count = 0
    s resultString = ""
    s end = Start+Limit
    s json = ##class(Code.JsonObj).%New()
    While(result.Next())
    {
    s Rowid = result.Data("RowId")
    s Description = result.Data("Description")
	continue:(Hosp'="")&&(##class(PHA.FACE.IN.Com).GetShowDataFlag("DHC_Carrier",Rowid,Hosp)="N")
    s DescPY=##class(web.DHCST.Common.AppCommon).GetCNCODE(Description)
    continue:(CADesc'="")&&(DescPY'[CADesc)&&(Description'[CADesc)
    s tmp=Rowid_"^"_Description
    s count = count+1
    i (count>Start)&(count<=end) d
    .d json.InsertRowData(tmp)
    }
    d result.Close()
    s resultString = json.getJsonData("RowId^Description",count)
    k json
    Q resultString
}

/// creator:zhangyong
/// date:2011-10-23
/// description: 药品生产厂商ComboBox
/// input:  Start, Limit
/// output: String "RowId^Description"
/// others:
/// w ##class(web.DHCST.Util.OrgUtil).GetPhManufacturer("bj",0,99)
ClassMethod GetPhManufacturer(PHMNFName As %String, Start As %String, Limit As %String, StkType As %String = "G", Hosp = "")
{
	s PHMNFName=$$ALPHAUP^SSUTIL4(PHMNFName)
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "select a.PHMNF_RowId,a.PHMNF_Name from ph_manufacturer a left join DHC_Manf_AddionInfo b "_
    "on a.phMnf_rowid=b.MANF_PhcManf_DR where b.MANF_Type="_"'"_StkType_"'"_" and b.MANF_Active='Y' ORDER BY PHMNF_RowId"
    d result.Prepare(sqlStr)
    d result.Execute()
    s count = 0
    s resultString = ""
    s end = Start+Limit
    s json = ##class(Code.JsonObj).%New()
    While(result.Next())
    {
    s Rowid = result.Data("PHMNF_RowId")
	continue:(Hosp'="")&&(##class(PHA.FACE.IN.Com).GetShowDataFlag("PH_Manufacturer",Rowid,Hosp)="N")
    s Description = result.Data("PHMNF_Name")
    s DescPY=##class(web.DHCST.Common.AppCommon).GetCNCODE(Description)
    continue:(PHMNFName'="")&&(DescPY'[PHMNFName)&&(Description'[PHMNFName)
    s tmp=Rowid_"^"_Description
    s count = count+1
    i (count>Start)&(count<=end) d
	.s tmp=##class(web.DHCST.Common.JsonObj).GetData(tmp)
    .d json.InsertRowData(tmp)
    }
    d result.Close()
    s resultString = json.getJsonData("RowId^Description",count)
    k json
    Q resultString
}

/// creator:wyx
/// date:2013-12-12
/// description: 退货原因ComboBox
/// input:  Start, Limit
/// output: String "RowId^Description"
/// others:
ClassMethod GetRetReason(ReasonDesc As %String, Start As %String, Limit As %String, Hosp = "")
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT RET_Rowid as Rowid,RET_Code as Code,RET_Desc as Description"_  
	" FROM INC_ReasonForReturn"
	d result.Prepare(sqlStr)
	d result.Execute()
	;
	s count = 0
	s resultString = ""
	s json = ##class(Code.JsonObj).%New()
	While(result.Next())
	{	
		s Rowid = result.Data("Rowid")
		s Code = result.Data("Code")
		CONTINUE:+Rowid=0
		continue:(Hosp'="")&&(##class(PHA.FACE.IN.Com).GetShowDataFlag("INC_ReasonForReturn",Rowid,Hosp)="N")
		s Description = result.Data("Description")
		s tmp=Rowid_"^"_Description
		s count = count+1		
		d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("RowId^Description",count)
	k json
	Q resultString
}

/// creator:zhangdongmei
/// date:2012-06-29
/// description: 供货厂商ComboBox
/// input:  Start(起始数值)  Limit(增长数值)
/// output: String "RowId^Description"
/// others:
/// w ##class(web.DHCST.Util.OrgUtil).GetAPCVendor("",0,99,,3)
ClassMethod GetAPCVendor(Filter, Start, Limit, APCType = "G", Hosp = "")
{
	s Filter=$$ALPHAUP^SSUTIL4(Filter)
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "SELECT APCVM_ROWID AS RowId, APCVM_NAME AS Description FROM APC_Vendor WHERE"_
    " APCVM_Status= 'A' ORDER BY APCVM_ROWID"
    d result.Prepare(sqlStr)
    d result.Execute()
    s count = 0
    s resultString = ""
    s end = Start+Limit
    s json = ##class(Code.JsonObj).%New()
    While(result.Next())
    {
    s Rowid = result.Data("RowId")
	continue:##class(PHA.FACE.IN.Com).GetShowDataFlag("APC_Vendor",Rowid,Hosp)="N"
    s Description = result.Data("Description")
	s STV=$o(^DHCSTV(0,Rowid,""))
	s APCStkType=$p(^APC("APCVM",Rowid),"^",9)
	s Universal=$s(STV'="":$p(^DHCSTV(STV),"^",49),1:"") ;通用标志
	continue:(Universal'="Y")&(APCStkType'=APCType)
	s Alias=$s(STV'="":$p(^DHCSTV(+STV),"^",46),1:"")
	//continue:(Filter'="")&&(Alias'="")&&(Alias'[Filter)  // 如果别名不存在就直接过滤了，没判断供应商名称 2021-09-08
	s DescPY=##class(web.DHCST.Common.AppCommon).GetCNCODE(Description)
	continue:(Filter'="")&&(DescPY'[Filter)&&(Description'[Filter)
    s tmp=Rowid_"^"_Description
    s count = count+1
    i (count>Start)&(count<=end) d
    .d json.InsertRowData(tmp)
    }
    d result.Close()
    s resultString = json.getJsonData("RowId^Description",count)
    k json
    Q resultString
}

/// creator:zhangdongmei
/// date:2012-05-14
/// description: 供应商分类ComboBox
/// input:  Start, Limit
/// output: String "RowId^Description"
/// others:
ClassMethod GetVendorCat(Desc, Start, Limit, Hosp = "")
{
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "select APCVC_RowId,APCVC_Desc from APC_VendCat "_
    "where (APCVC_StkType='G' OR APCVC_StkType is NULL) and APCVC_Desc like '%"_Desc_"%' ORDER BY APCVC_RowId"
    d result.Prepare(sqlStr)
    d result.Execute()
    s count = 0
    s resultString = ""
    s end = Start+Limit
    s json = ##class(Code.JsonObj).%New()
    While(result.Next())
    {
    s Rowid = result.Data("APCVC_RowId")
    continue:(Hosp'="")&&(##class(PHA.FACE.IN.Com).GetShowDataFlag("APC_VendCat",Rowid,Hosp)="N")
    s Description = result.Data("APCVC_Desc")
    s tmp=Rowid_"^"_Description
    s count = count+1
    i (count>Start)&(count<=end) d
    .d json.InsertRowData(tmp)
    }
    d result.Close()
    s resultString = json.getJsonData("RowId^Description",count)
    k json
    Q resultString
}

/// creator:zhangdongmei
/// date:2012-05-16
/// description: 安全组能访问的科室ComboBox
/// input:  Start(起始数值)  Limit(增长数值),安全组id,科室名称
/// output: String "RowId^Code^Description"
/// others:  w ##class(web.DHCST.Util.OrgUtil).GetGroupDept("0","20","42","","","2")
ClassMethod GetGroupDept(Start As %Integer, Limit As %Integer, GroupId As %String, LocDesc As %String, Type As %String = "", HospId = "")
{
    n (Start,Limit,GroupId,LocDesc,Type,HospId)
    s result = ##class(%Library.ResultSet).%New()
    s Type=$g(Type)
    s sqlStr="Select st_ctloc_dr AS RowId,st_ctloc_dr->ctloc_desc  AS Description from ss_groupstocklocations where st_parref="_GroupId_" AND (ST_ActiveFlag IS NULL OR ST_ActiveFlag='Y')"
    i Type'="" d
    .s sqlStr = sqlStr_" and st_ctloc_dr->ctloc_type="_Type
    i LocDesc'="" d
    .s LocDesc=$$ALPHAUP^SSUTIL4(LocDesc)
    .s sqlStr = sqlStr_" and (%ALPHAUP(st_ctloc_dr->ctloc_desc) %STARTSWITH "_"'"_LocDesc_"'"
    .s sqlStr = sqlStr_" or %ALPHAUP(st_ctloc_dr->ctloc_contactname) %STARTSWITH "_"'"_LocDesc_"')"
    s sqlStr = sqlStr_" ORDER BY st_ctloc_dr"
    d result.Prepare(sqlStr)
    d result.Execute()
    s count = 0
    s resultString = ""
    s end = Start+Limit
    s json = ##class(Code.JsonObj).%New()
    s BDPHospAut=##class(PHA.FACE.IN.Com).GetHospAut() //医院级别授权是否开启
    While(result.Next())
    {
    s Rowid = result.Data("RowId")
    s ActTo=$p(^CTLOC(Rowid),"^",25)
    Continue:(ActTo'="")&&(ActTo<+$H)
    s LocHosp=$p(^CTLOC(Rowid),"^",22)
    Continue:(BDPHospAut="Y")&&(LocHosp'=HospId)
    s Description = result.Data("Description")
    s tmp=Rowid_"^"_Description
    s count = count+1
    i (count>Start)&(count<=end) d
    .d json.InsertRowData(tmp)
    }
    d result.Close()
    s resultString = json.getJsonData("RowId^Description",count)
    k json
    q resultString
}

/// creator:zhangdongmei
/// date:2012-05-23
/// description: 科室组
/// input:  Start(起始数值)  Limit(增长数值),科室组类型,科室组名称
/// output: String "RowId^Description"
/// others:
ClassMethod GetLocGroup(Start As %Integer, Limit As %Integer, Type As %String, LocGrpDesc As %String, DispLocID As %String = "", Hosp = "")
{
    n (Start,Limit,Type,LocGrpDesc,DispLocID,Hosp)
    ;
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr ="select SLG_RowId as Rowid,SLG_Desc as Description from DHC_StkLocGroup "_
    " where %ALPHAUP(SLG_Type) = 'G' And SLG_Desc like '%"_LocGrpDesc_"%'"_
	" AND SLG_Loc_Dr Is NULL"
    i DispLocID'=""  d
    .s sqlStr=sqlStr_" and SLG_Loc_Dr='"_DispLocID_"'"
    d result.Prepare(sqlStr)
    d result.Execute()
    s count = 0
    s resultString = ""
    s end = Start+Limit
    s json = ##class(Code.JsonObj).%New()
    While(result.Next())
    {
        s Rowid = result.Data("Rowid")
		continue:##class(PHA.FACE.IN.Com).GetShowDataFlag("DHC_StkLocGroup",Rowid,Hosp)="N"
        s Description = result.Data("Description")
        s tmp=Rowid_"^"_Description
        s count = count+1
        i (count>Start)&(count<=end) d
        .d json.InsertRowData(tmp)
    }
    d result.Close()
    s resultString = json.getJsonData("RowId^Description",count)
    k json
    q resultString
}

/// creator:zhangdongmei
/// date:2012-05-23
/// description: 取科室组
/// input:  Start(起始数值)  Limit(增长数值),科室组名称,药房科室ID
/// output: String "RowId^Description"
/// others:
/// w ##class(web.DHCST.OrgUtil).GetLocSLG(0,20,"")
ClassMethod GetLocSLG(Start As %Integer, Limit As %Integer, LocGrpDesc As %String, DispLocID As %String = "", Hosp = "")
{
   
    //s resultString=..GetLocGroup(Start,Limit,"L",LocGrpDesc)  //zhwh 2013-03-04
    s resultString=..GetLocGroup(Start,Limit,"G",LocGrpDesc,DispLocID,Hosp)

    q resultString
}

/// creator:zhangdongmei
/// date:2012-05-23
/// description: 取科室项目组
/// input:  Start(起始数值)  Limit(增长数值),科室组名称
/// output: String "RowId^Description"
/// others:
/// ReWrite:zhwh,2013-03-04
ClassMethod GetLocLIG(Start As %Integer, Limit As %Integer, LocGrpDesc As %String, Hosp = "")
{
    //s resultString=..GetLocGroup(Start,Limit,"I",LocGrpDesc)
    //q resultString
    
    n (Start,Limit,LocGrpDesc,Hosp)
    ;
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr ="select LIG_RowID as Rowid,LIG_Desc as Description from DHC_LocItemGrp "_
    " where LIG_Flag='Y' and LIG_Desc like '%"_LocGrpDesc_"%'"
    d result.Prepare(sqlStr)
    d result.Execute()
    s count = 0
    s resultString = ""
    s end = Start+Limit
    s json = ##class(Code.JsonObj).%New()
    While(result.Next())
    {
        s Rowid = result.Data("Rowid")
		continue:##class(PHA.FACE.IN.Com).GetShowDataFlag("DHC_LocItemGrp",Rowid,Hosp)="N"
        s Description = result.Data("Description")
        s tmp=Rowid_"^"_Description
        s count = count+1
        i (count>Start)&(count<=end) d
        .d json.InsertRowData(tmp)
    }
    d result.Close()
    s resultString = json.getJsonData("RowId^Description",count)
    k json
    q resultString
}

/// creator:zhangdongmei
/// date:2012-06-06
/// description: 医院ComboBox
/// input:  Start(起始数值)  Limit(增长数值)
/// output: String "RowId^Description"
/// others:
ClassMethod GetHospital(Start, Limit)
{
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "SELECT HOSP_RowId AS RowId, HOSP_Desc AS Description FROM CT_Hospital"
    d result.Prepare(sqlStr)
    d result.Execute()
    s count = 0
    s resultString = ""
    s end = Start+Limit
    s json = ##class(Code.JsonObj).%New()
    While(result.Next())
    {
    s Rowid = result.Data("RowId")
    s Description = result.Data("Description")
    s tmp=Rowid_"^"_Description
    s count = count+1
    i (count>Start)&(count<=end) d
    .d json.InsertRowData(tmp)
    }
    d result.Close()
    s resultString = json.getJsonData("RowId^Description",count)
    k json
    q resultString
}

/// creator:zhangdongmei
/// date:2012-06-06
/// description: 安全组
/// input:  Start(起始数值)  Limit(增长数值),安全组名称
/// output: String "RowId^Description"
/// others: w ##class(web.DHCST.Util.OrgUtil).GetGroup(0,999,"",9)
ClassMethod GetGroup(Start As %Integer, Limit As %Integer, Desc As %String, HospId = "")
{
    n (Start,Limit,Desc,HospId)
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "SELECT SSGRP_RowId AS RowId, SSGRP_Desc AS Description FROM SS_Group WHERE SSGRP_Desc like '%"_Desc_"%'"
    d result.Prepare(sqlStr)
    d result.Execute()
    s count = 0
    s resultString = ""
    s end = Start+Limit
    s json = ##class(Code.JsonObj).%New()
    While(result.Next())
    {
	    s Rowid = result.Data("RowId")
	    continue:##class(PHA.FACE.IN.Com).GetShowDataFlag("SS_Group",Rowid,HospId)="N"
	    s Description = result.Data("Description")
	    s tmp=Rowid_"^"_Description
	    s count = count+1
	    i (count>Start)&(count<=end) d
	    .d json.InsertRowData(tmp)
    }
    d result.Close()
    s resultString = json.getJsonData("RowId^Description",count)
    k json
    q resultString
}

/// creator:zhangyong
/// date:2011-10-14
/// description: 科室ComboBox
/// input:  Start(起始数值)  Limit(增长数值)
/// output: String "RowId^Description"
/// others: w ##class(web.DHCST.Util.OrgUtil).GetDeptUser(0, 25, 311, "")
ClassMethod GetDeptUser(Start, Limit, LocId, Name)
{
    n (Start, Limit, LocId,Name)
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "SELECT SSUSR_RowId AS RowId, SSUSR_Name AS Name,SSUSR_Active AS ActiveFlag,SSUSR_DateTo AS DateTo FROM SS_User where SSUSR_DefaultDept_DR="_LocId_"  and SSUSR_Name like '%"_Name_"%'"
    s sqlStr1 = "select othll_parref as RowId,othll_parref->ssusr_name as Name,othll_parref->ssusr_active as ActiveFlag,othll_parref->ssusr_dateto AS DateTo From SS_UserOtherLogonLoc  where othll_ctloc_dr="_LocId_" and othll_parref->ssusr_name like '%"_Name_"%'"
    s sqlStr =sqlStr_" union "_sqlStr1 
    ;w sqlStr,!
    d result.Prepare(sqlStr)
    d result.Execute()
    s count = 0
    s resultString = ""
    s end = Start+Limit
    s json = ##class(Code.JsonObj).%New()
    While(result.Next())
    {
    s Rowid = result.Data("RowId")
    s Description = result.Data("Name")
    s ActiveFlag = result.Data("ActiveFlag")
    continue:ActiveFlag="N"
    s DateTo = result.Data("DateTo")
    s date=$p($h,",",1)
    continue:(DateTo'="")&&(DateTo<date)
    s tmp=Rowid_"^"_Description
    s count = count+1
    i (count>Start)&(count<=end) d
    .d json.InsertRowData(tmp)
    }
    d result.Close()
    s resultString = json.getJsonData("RowId^Description",count)
    k json
    q resultString
}

/// creator:zhangdongmei
/// date:2012-02-07
/// description:某安去组下的人(采购员ComboBox)
/// input:  Start(起始数值)  Limit(增长数值),"采购员"
/// output: String "Description"
/// others:
ClassMethod GetGroupUser(Start As %Integer, Limit As %Integer, GrpDesc As %String) As %String
{
    n (Start,Limit,GrpDesc)
    //s ^zdm("GetGroupUser")=GrpDesc
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "select ssusr_rowid as Rowid,ssusr_name as Name from SS_user where ssusr_group->ssgrp_desc like '%"_GrpDesc_"%'"
    d result.Prepare(sqlStr)
    d result.Execute()
    s count = 0
    s resultString = ""
    s end = Start+Limit
    s json = ##class(Code.JsonObj).%New()
    While(result.Next())
    {
        s Rowid = result.Data("Rowid")
        s Description = result.Data("Name")
        s tmp=Rowid_"^"_Description
        s count = count+1
        i (count>Start)&(count<=end) d
        .d json.InsertRowData(tmp)
    }
    d result.Close()
    s resultString = json.getJsonData("Rowid^Name",count)
    k json
    Q resultString
}

/// creator:zhangdongmei
/// date:2012-02-07
/// description:某安去组下的人(采购员ComboBox)
/// input:  Start(起始数值)  Limit(增长数值),"采购员"
/// output: String "Description"
/// others:
ClassMethod GetGroupUserByGroupId(Start As %Integer, Limit As %Integer, Group As %String, Desc As %String) As %String
{
    n (Start,Limit,Group,Desc)
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "select ssusr_rowid as Rowid,ssusr_name as Name from SS_user where ssusr_group="_Group_
    " and ssusr_name like '%"_Desc_"%'"
    d result.Prepare(sqlStr)
    d result.Execute()
    s count = 0
    s resultString = ""
    s end = Start+Limit
    s json = ##class(Code.JsonObj).%New()
    While(result.Next())
    {
        s Rowid = result.Data("Rowid")
        s Description = result.Data("Name")
        s tmp=Rowid_"^"_Description
        s count = count+1
        i (count>Start)&(count<=end) d
        .d json.InsertRowData(tmp)
    }
    d result.Close()
    s resultString = json.getJsonData("RowId^Description",count)
    k json
    Q resultString
}

/// creator:zhangdongmei
/// date:2012-06-06
/// description: 权限指向ComboBox
/// input:  Start, Limit
/// output: String "RowId^Description"
/// others:
/// w ##class(web.DHCST.Util.OrgUtil).GetSSPPoint("G","","999","0","1")
ClassMethod GetSSPPoint(Type As %String, Group As %String, Desc As %String, Start As %Integer, Limit As %Integer, Hosp = "")
{
    n (Type,Desc,Limit,Start,Group,Hosp)
    s resultString=""
    ;G,L,U
    ;SS_Group,CT_Loc,SS_User,DHC
    i Type="G"  d       //按安全组
    .s resultString=..GetGroup(Start,Limit,Desc,Hosp)
    i Type="L"  d       //按科室
    .s resultString=..GetDeptLoc(Start,Limit,Desc,Hosp)
    i Type="U"  d       //按人员
    .s resultString=..GetHospUser(Start,Limit,Desc,Hosp) 
    i Type="D"  d
    .s resultString="{results:1,rows:[{RowId:'DHC',Description:'DHC'}]}"
    Q resultString
}

/// creator:zhangyong
/// date:2011-10-14
/// description: 药房窗口ComboBox
/// input:  Start(起始数值)  Limit(增长数值)  PhaDept(药房)
/// output: String "RowId^Description"
/// others:
/// w ##class(web.DHCST.Util.OrgUtil).GetPhaWindow(0,20,311)
ClassMethod GetPhaWindow(Start, Limit, PhaDept)
{
	q:PhaDept="" ""
    s result = ##class(%Library.ResultSet).%New()
    SET WHERE = ""
    IF PhaDept '= "" DO
    .SET PhaDept = $O(^DHCPHLOCi("LOC",PhaDept,0))
    .SET WHERE = "WHERE PHW_PHL_DR = "_$G(PhaDept)
    s sqlStr = "SELECT PHW_ROWID AS RowId, PHW_DESC AS Description FROM dhc_phwindow "_WHERE_" ORDER BY PHW_ROWID"
    d result.Prepare(sqlStr)
    d result.Execute()
    s count = 0
    s resultString = ""
    s end = Start+Limit
    s json = ##class(Code.JsonObj).%New()
    While(result.Next())
    {
    s Rowid = result.Data("RowId")
    s Description = result.Data("Description")
    s tmp=Rowid_"^"_Description
    s count = count+1
    i (count>Start)&(count<=end) d
    .d json.InsertRowData(tmp)
    }
    d result.Close()
    s resultString = json.getJsonData("RowId^Description",count)
    k json
    Q resultString
}

/// creator:zhangdongmei
/// date:2012-08-21
/// description: 管理组ComboBox
/// input:  Start(起始数值)  Limit(增长数值)  PhaDept(科室id)
/// output: String "RowId^Description"
/// others:w ##class(web.DHCST.Util.OrgUtil).GetLocManGrp("0","30",100,"590")
ClassMethod GetLocManGrp(Start, Limit, PhaDept, UserId = "")
{
    n (Start,Limit,PhaDept,UserId)
    q:PhaDept="" ""
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "SELECT LMG_Rowid AS RowId, LMG_Desc AS Description FROM DHC_LocManGrp WHERE LMG_CTLOC_DR="_PhaDept_" ORDER BY Description"
    d result.Prepare(sqlStr)
    d result.Execute()
    s count = 0
    s resultString = ""
    s end = Start+Limit
    s json = ##class(Code.JsonObj).%New()
    While(result.Next())
    {
    s Rowid = result.Data("RowId")
    s Description = result.Data("Description")
    s tmp=Rowid_"^"_Description
    s active="N"
    i UserId'="" d
    .s sub=$o(^DHCLMG(0,"USER",UserId,Rowid,""))
    .i sub'="" s active=$p(^DHCLMG(Rowid,"I",sub),"^",2)
    .i '$d(^DHCLMG(0,"USER")) s active="Y"
    e  s active="Y"  //yunhaibao20160202
    continue:active'="Y"
    s count = count+1
    i (count>Start)&(count<=end) d
    .d json.InsertRowData(tmp)
    }
    d result.Close()
    s resultString = json.getJsonData("RowId^Description",count)
    k json
    Q resultString
}

/// creator:wangjiabin
/// date:2013-07-04
/// description: 实盘窗口ComboBox
/// input:  Start(起始数值), Limit(增长数值), 科室id
/// output: String "RowId^Description"
/// others:
ClassMethod GetInStkTkWindow(Start, Limit, LocId)
{
	n (Start, Limit, LocId)
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "SELECT STTKW_RowID AS RowId, STTKW_Desc AS Description FROM dhc_instktkwindow WHERE STTKW_CTLOC_DR="_LocId
    d result.Prepare(sqlStr)
    d result.Execute()
    s count = 0
    s resultString = ""
    s end = Start+Limit
    s json = ##class(Code.JsonObj).%New()
    While(result.Next())
    {
    s Rowid = result.Data("RowId")
    s Description = result.Data("Description")
    s tmp=Rowid_"^"_Description
    s count = count+1
    i (count>Start)&(count<=end) d
    .d json.InsertRowData(tmp)
    }
    d result.Close()
    s resultString = json.getJsonData("RowId^Description",count)
    k json
    Q resultString
}

/// creator:gwj
/// date:2013-05-29
/// description: 根据用户取供货厂商，用于供应商应用
/// input:  Start(起始数值)  Limit(增长数值)
/// output: String "RowId^Description"
/// others:
ClassMethod GetVendorbyUsr(Start, Limit, VendorUsr, APCType = "M")
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT vu_apcvm_dr->APCVM_ROWID AS RowId, vu_apcvm_dr->APCVM_NAME AS Description FROM dhc_ssvendoruser WHERE"_
	" vu_ssusr_dr='"_VendorUsr_"' and vu_apcvm_dr->apcvm_type='"_APCType_"'"
	d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	s resultString = ""
	s end = Start+Limit
	s json = ##class(Code.JsonObj).%New()
	While(result.Next())
	{
	s Rowid = result.Data("RowId")
	s Description = result.Data("Description")
	s tmp=Rowid_"^"_Description
	s count = count+1
	;i (count>Start)&(count<=end) d
	d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("RowId^Description",count)
	k json
	Q resultString
}

/// creator:wyx
/// date:2014-05-26
/// description: 病区ComboBox
/// input:  Start(起始数值)  Limit(增长数值)
/// output: String "RowId^Description"
/// others:
/// w ##class(web.DHCST.Util.OrgUtil).GetLocWard("ck",0,99)
ClassMethod GetLocWard(Filter, Start, Limit, Hosp = "")
{
    s Filter=$$ALPHAUP^SSUTIL4(Filter)
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "SELECT WARD_RowID AS RowId, WARD_Desc AS Description FROM PAC_Ward WHERE"_
    " %ALPHAUP(WARD_Desc) LIKE '%"_Filter_"%' or %ALPHAUP(WARD_LocationDR->ctloc_contactname) like '%"_Filter_"%' ORDER BY WARD_RowID"
    d result.Prepare(sqlStr)
    d result.Execute()
    s count = 0
    s resultString = ""
    s end = Start+Limit
    s json = ##class(Code.JsonObj).%New()
    While(result.Next())
    {
    s Rowid = result.Data("RowId")
    s Description = result.Data("Description")
    s tmp=Rowid_"^"_Description
    s count = count+1
    i (count>Start)&(count<=end) d
    .d json.InsertRowData(tmp)
    }
    d result.Close()
    s resultString = json.getJsonData("RowId^Description",count)
    k json
    Q resultString
}

/// creator:wyx
/// date:2014-05-28
/// description: 发药类别ComboBox
/// input:  Start(起始数值)  Limit(增长数值)
/// output: String "RowId^Description"
/// others:
ClassMethod GetDispType(Filter, Start, Limit)
{
      
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "select SDG_Type AS Type,SDG_Desc AS Description from DHCStkDrugGroup WHERE"_
    " SDG_Code LIKE '%"_Filter_"%' ORDER BY SDG_RowId"
    d result.Prepare(sqlStr)
    d result.Execute()
    s count = 0
    s resultString = ""
    s end = Start+Limit
    s json = ##class(Code.JsonObj).%New()
    While(result.Next())
    {
    s Rowid = result.Data("Type")
    s Description = result.Data("Description")
    s tmp=Rowid_"^"_Description
    s count = count+1
    i (count>Start)&(count<=end) d
    .d json.InsertRowData(tmp)
    }
    d result.Close()
    s resultString = json.getJsonData("Type^Description",count)
    k json
    Q resultString
}

/// creator:wyx
/// date:2014-05-28
/// description: link的科室ComboBox
/// input: 科室id, Start, Limit
/// output: String "RowId^Description"
/// others:
ClassMethod GetDocLoc(FroLoc, Start, Limit) As %String
{
    q:FroLoc="" ""
    s End = Start+Limit
    s json = ##class(Code.JsonObj).%New()
    s Count=0
    ;
    s Chl=0
    i FroLoc'=""  d
    .s linkdr="" f  s linkdr=$o(^CTLOC(FroLoc,"LINK",0,"Loc",linkdr)) q:linkdr=""  d
    ..s locdesc=$p(^CTLOC(linkdr),"^",2)
    ..s Data=linkdr_"^"_locdesc
    ..s Count=Count+1
    ..i (Count>Start)&(Count<=End) d
    ...d json.InsertRowData(Data)
    ..
    s resultString = json.getJsonData("RowId^Description",Count)
    k json
    Q resultString
}

/// creator:wyx
/// date:2014-05-28
/// description: link的科室ComboBox
/// input: 科室id, Start, Limit
/// output: String "RowId^Description"
/// others:
ClassMethod GetLocUser(FroLoc, Start, Limit) As %String
{
    q:FroLoc="" ""
    s End = Start+Limit
    s json = ##class(Code.JsonObj).%New()
    s Count=0
    i FroLoc'=""  d
    .s user="" f  s user=$o(^SSU("SSUSR",user)) q:user=""  d
    ..q:$p(^SSU("SSUSR",user),"^",4)'=FroLoc
    ..s Data=user_"^"_$p(^SSU("SSUSR",user),"^",2)
    ..s Count=Count+1
    ..i (Count>Start)&(Count<=End) d
    ...d json.InsertRowData(Data)
    ..
    s resultString = json.getJsonData("RowId^Description",Count)
    k json
    Q resultString
}

/// creator:wyx
/// date:2014-09-23
/// description: 获取医生列表
/// input: 科室desc, Start, Limit
/// output: String "RowId^Description"
/// others:
ClassMethod GetDoctorDs(InputDoc, Start, Limit) As %String
{
      
       s End = Start+Limit
       s json = ##class(Code.JsonObj).%New()
	s Count=0
	s ctpt=""
	f  s ctpt=$o(^CT("CPT",ctpt)) q:ctpt=""  d
	.s active=$p(^CT("CPT",ctpt),"^",3)
	.q:active'="Y"
	.s type=$p(^CT("CPT",ctpt),"^",4)
	.q:type'="DOCTOR"
	.s ctpcp=""
	.f  s ctpcp=$o(^CTPCP(0,"CareProvType",ctpt,ctpcp)) q:ctpcp=""  d 
	..s ssuser=$o(^SSU("SSUSR",0,"CTPCP",ctpcp,""))
	..q:ssuser=""
	..s chkflag=0
	..s reslocdr=""
       ..s docname=$p(^SSU("SSUSR",ssuser),"^",2)
       ..q:(docname'[InputDoc)&&(InputDoc'="")
	..i $f(docname,$c(13)) s docname=$p(docname,$c(13),1)
       ..s Data=ssuser_"^"_docname
       ..s Count=Count+1
       ..i (Count>Start)&(Count<=End) d
       ...d json.InsertRowData(Data)
       ..
    s resultString = json.getJsonData("RowId^Description",Count)
    k json
    Q resultString
}

/// w ##class(web.DHCST.Util.OrgUtil).GetGroupMBCUser(0,19,"煎药","")
ClassMethod GetGroupMBCUser(Start As %Integer, Limit As %Integer, GrpDesc As %String, mbcdesc)
{
      
	s End = Start+Limit
	s json = ##class(Code.JsonObj).%New()
	s Count=0
	s groupid="0"
	s pid=..NewPid()
	f  s groupid=$o(^SSU("SSUSR",0,"Group",groupid)) q:groupid=""  d
	.s ssusid="0"
	.f  s ssusid=$o(^SSU("SSUSR",0,"Group",groupid,ssusid)) q:ssusid=""  d
	..q:groupid=""
	..q:'$d(^SSU("SSGRP",groupid))
	..s groupdesc=$p(^SSU("SSGRP",groupid),"^",1)
	..s ssuser=$p(^SSU("SSUSR",ssusid),"^",2)
	..q:(mbcdesc'[ssuser)&&(mbcdesc'="")
	..i (groupdesc[GrpDesc) d
	...s ^TMP("web","DHCST","Util","OrgUtil","GetGroupMBCUser",pid,ssusid)=ssuser
	..s sub="0"
	..f  s sub=$o(^SSU("SSUSR",ssusid,"OTHLL",sub)) q:sub=""  d
	...s groupsubid=$p(^SSU("SSUSR",ssusid,"OTHLL",sub),"^",2)
	...q:groupsubid=""
	...q:'$d(^SSU("SSGRP",groupsubid))
	...s groupsubdesc=$p(^SSU("SSGRP",groupsubid),"^",1)
	...i groupsubdesc[GrpDesc d
	....s ^TMP("web","DHCST","Util","OrgUtil","GetGroupMBCUser",pid,ssusid)=ssuser
	s ssid=""
	f  s ssid=$o(^TMP("web","DHCST","Util","OrgUtil","GetGroupMBCUser",pid,ssid)) q:ssid=""  d 
	.s ssuser=ssid
	.s name=^TMP("web","DHCST","Util","OrgUtil","GetGroupMBCUser",pid,ssid)
	.s Data=ssuser_"^"_name
	.s Count=Count+1
	.i (Count>Start)&(Count<=End) d
	..d json.InsertRowData(Data)
	..
	s resultString = json.getJsonData("RowId^Description",Count)
	k json
	Q resultString
}

/// creator:wyx
/// date:2014-09-24
/// description: 获取医生列表
/// input: 科室desc, Start, Limit
/// output: String "RowId^Description"
/// others:
ClassMethod GetSurOpDs(Input, Start, Limit)
{
 	
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "SELECT SCDI_RowID as Rowid,SCDI_Code as Code,SCDI_Desc as Description,SCDI_Type as Type"_  
    " FROM DHC_StkComDictionary where SCDI_Desc LIKE '%"_Input_"%' and SCDI_Type="_"'N'"
    d result.Prepare(sqlStr)
    d result.Execute()
    ;
    s count = 0
    s resultString = ""
    s json = ##class(Code.JsonObj).%New()
    While(result.Next())
    {   
        s Rowid = result.Data("Rowid")
        s Code = result.Data("Code")
        CONTINUE:+Rowid=0
        s Description = result.Data("Description")
        s Type = result.Data("Type")
        s tmp=Rowid_"^"_Description
        s count = count+1       
        d json.InsertRowData(tmp)
    }
    d result.Close()
    s resultString = json.getJsonData("RowId^Description",count)
    k json
    Q resultString
}

/// creator:wyx
/// date:2014-10-15
/// description: 加载配置的煎药状态ComboBox
/// input:  Start(起始数值)  Limit(增长数值)
/// output: String "RowId^Description"
/// others:w ##class(web.DHCST.Util.OrgUtil).GetMBCState(0,99)
ClassMethod GetMBCState(Start As %Integer, Limit As %Integer)
{
    n (Start,Limit)
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "SELECT MBCS_Rowid AS RowId, MBCS_Name AS Description,MBCS_Type AS Type FROM DHCST_MBCState WHERE MBCS_Flag='Y' ORDER BY MBCS_Rowid"
    d result.Prepare(sqlStr)
    d result.Execute()
    s count = 0
    s resultString = ""
    s end = Start+Limit
    s json = ##class(Code.JsonObj).%New()
    While(result.Next())
    {
    s Rowid = result.Data("RowId")
    s Type = result.Data("Type")
    s Description = result.Data("Description")
    i Type="O" s Description=Description_"(门诊)"
    e  s Description=Description_"(住院)"
    s tmp=Rowid_"^"_Description
    s count = count+1
    i (count>Start)&(count<=end) d
    .d json.InsertRowData(tmp)
    }
    d result.Close()
    s resultString = json.getJsonData("RowId^Description",count)
    k json
    q resultString
}

ClassMethod NewPid() As %String
{
  q $I(^DHCSTPID("DHCSTUtilOrgUtil"))
}

/// w ##class(web.DHCST.Util.OrgUtil).GetRelLoc(0,100,"xy","2","Y")
ClassMethod GetRelLoc(Start, Limit, Desc, HospId = "", OverHospFlag = "") As %String
{
    n (Start, Limit,Desc,HospId,OverHospFlag,%session)
    //s ^YSJTMP("GetRelLoc")=$lb(Start, Limit,Desc,HospId,OverHospFlag)
    s HospStr=""
    i OverHospFlag="Y" s HospStr=..GetHospStrByLogon()
    s BDPHospAut=##class(PHA.FACE.IN.Com).GetHospAut() //医院级别授权是否开启
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "SELECT CTLOC_ROWID AS RowId,CTLOC_CODE AS Code,CTLOC_DESC AS Description FROM CT_Loc where CTLOC_DESC like '%"_Desc_"%' or %ALPHAUP(CTLOC_ContactName) like '%"_$zcvt(Desc,"U")_"%'"
    d result.Prepare(sqlStr)
    d result.Execute()
    s count = 0
    s resultString = ""
    s end = Start+Limit
    s json = ##class(Code.JsonObj).%New()
    While(result.Next())
    {
	    s Rowid = result.Data("RowId")
	    Continue:Rowid=""
	    s LocHosp=$p($g(^CTLOC(Rowid)),"^",22)
	    Continue:(BDPHospAut="Y")&&(OverHospFlag'="Y")&&(LocHosp'=HospId)
	    Continue:(BDPHospAut="Y")&&(OverHospFlag="Y")&&((","_HospStr_",")'[(","_LocHosp_","))
	    s Code = result.Data("Code")
	    s Description = result.Data("Description")
	    s tmp=Rowid_"^"_Code_"^"_Description
	    s count = count+1
	    i (count>Start)&(count<=end) d
	    .d json.InsertRowData(tmp)
    }
    d result.Close()
    s resultString = json.getJsonData("RowId^Code^Desc",count)
    k json
    q resultString
}

///  获取当前登陆信息能看到的医院id串
///  w ##class(web.DHCST.Util.OrgUtil).GetTest()
ClassMethod GetHospStrByLogon()
{
	s tablename="PHA-IN-LocStkCatGrp"
	s result = ##class(%Library.ResultSet).%New("web.DHCBL.BDP.BDPMappingHOSP:GetHospDataForCombo")
	s sc = result.Execute("", "", tablename, "" )
	i $$$ISERR(sc) q ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
	s hospStr="" 
	While (result.Next()) { 
		s ret = ""
		s hos = result.%GetData(1)
		s hosDesc = result.%GetData(2)
		s hospStr=$s(hospStr="":hos,1:hospStr_","_hos)
	}
	
	q hospStr
}

/// creator:lihui
/// date:2015-06-16
/// description:科室下维护的采购人员(采购员ComboBox)
/// input:  Start(起始数值)  Limit(增长数值),"采购员"
/// output: String "Description"
/// others:
ClassMethod GetLocPPLUser(Start As %Integer, Limit As %Integer, LocDr As %String) As %String
{
    n (Start,Limit,LocDr)
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "select LPP_RowId as LPPRowId,LPP_SSUSR_DR as RowId,LPP_SSUSR_DR->SSUSR_Name as Description,LPP_Active,LPP_Default from DHC_LocPurPlanUser where LPP_CTLOC_DR="_LocDr
    d result.Prepare(sqlStr)
    d result.Execute()
    s count = 0
    s resultString = ""
    s end = Start+Limit
    s json = ##class(Code.JsonObj).%New()
    While(result.Next())
    {
        s Rowid = result.Data("RowId")
        s Description = result.Data("Description")
        s Active = result.Data("LPP_Active")
        continue:Active'="Y"
        s Default = result.Data("LPP_Default")
        s tmp=Rowid_"^"_Description_"^"_Default
        s count = count+1
        i (count>Start)&(count<=end) d
        .d json.InsertRowData(tmp)
    }
    d result.Close()
    s resultString = json.getJsonData("RowId^Description^Default",count)
    k json
    Q resultString
}

/// creator:wfg
/// date:	2014-12-29
/// description: 取所有的安全组
/// input:  Start(起始数值)  Limit(增长数值)
/// output: "RowId^Description"
/// others:w ##class(web.DHCST.Util.OrgUtil).QueryGroup("0","20","",13609,"2")
ClassMethod QueryGroup(Start, Limit, FilterDesc, userId, HospId = "")
{
	n (Start,Limit,FilterDesc,userId,HospId)
	i Start="" s Start=0
	i Limit="" s Limit=20
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT SSGRP_RowId AS RowId, SSGRP_Desc AS Description,SSGRP_ActiveFlag AS ActiveFlag  FROM ss_group WHERE "_
				" ssgrp_rowid IN ( SELECT othll_usergroup_dr FROM SS_UserOtherLogonLoc WHERE othll_parref = "_userId_") "_
				" or ssgrp_rowid=(SELECT ssusr_group FROM SS_User WHERE SSUSR_RowId= "_userId_") "_
				" and SSGRP_Desc LIKE '%"_FilterDesc_"%'"
				
	d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	s end = Start+Limit
	s resultString = ""
	s json = ##class(Code.JsonObj).%New()
	While(result.Next())
	{
		s Rowid = result.Data("RowId")
		s Description = result.Data("Description")
		s ActiveFlag = result.Data("ActiveFlag")
		continue:(ActiveFlag '= "Y")
		//continue:(HospId'="")&&('$d(^SSU("SSGRP",Rowid,"HOSP",0,"Hosp",+HospId))) //安全组院区授权SS_GroupHospitals
		continue:(HospId'="")&&(##class(PHA.FACE.IN.Com).GetShowDataFlag("SS_Group",Rowid,HospId)="N")
		continue:(FilterDesc'="")&&(Description'[FilterDesc)
		s tmp=Rowid_"^"_Description
		s count = count+1
		i (count>Start)&(count<=end) d
		.d json.InsertRowData(tmp)
	}
	d result.Close()
	i count=0 d
	.s tmp=Rowid_"^"_Description
	.d json.InsertRowData(tmp)
	s resultString = json.getJsonData("RowId^Description",count)
	k json
	Q resultString
}

/// creator:MYQ
/// date:2014-7-22
/// description: 药品产地ComboBox
/// input:  Start, Limit
/// output: String "RowId^Description"
/// others:
/// w ##class(web.DHCST.Util.OrgUtil).GetOrigin("0","20","","G")
ClassMethod GetOrigin(Start As %String, Limit As %String, FilterName As %String, StkType As %String = "G", Hosp = "")
{
	n (%session,Start,Limit,FilterName,StkType,Hosp)
	s FilterName=$$ALPHAUP^SSUTIL4(FilterName)
	i Hosp'="" s HospId=Hosp
	e  s HospId=$s($d(%session):$Get(%session.Data("LOGON.HOSPID")),1:"")
	s Param="^^^"_HospId
	s GroupFlag=##class(web.DHCST.Common.AppCommon).GetAppPropValue("DHCSTCOMMON","GroupFlag",Param)
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "SELECT Orig_Rowid as RowId,Orig_Code as Code,Orig_Name as Description,Orig_Hosp_Dr as OrigHosp"_  
	" FROM DHC_STOrigin where Orig_Type='"_StkType_"'"
	//i FilterName'="" s sqlStr=sqlStr_" and (%ALPHAUP(Orig_Name) like '%"_FilterName_"%'"_" or %ALPHAUP(Orig_Alias) like '%"_FilterName_"%')"
	d result.Prepare(sqlStr)
    d result.Execute()
    s count = 0
    s resultString = ""
    s end = Start+Limit
    s json = ##class(Code.JsonObj).%New()
    While(result.Next())
    {
	    s RowId = result.Data("RowId")
	    s Description = result.Data("Description")
	    continue:(HospId'="")&&(##class(PHA.FACE.IN.Com).GetShowDataFlag("DHC_STOrigin",RowId,HospId)="N")
	    s DescPY=##class(web.DHCST.Common.AppCommon).GetCNCODE(Description)   //检索过滤移动到此处，增加首拼检索  2020-02-10 yangsj
    	continue:(FilterName'="")&&(DescPY'[FilterName)&&(Description'[FilterName)
	    
	    continue:(GroupFlag=2)&&(HospId'="")&&(HospId'=result.Data("OrigHosp"))&&(result.Data("OrigHosp")) //增加(result.Data("OrigHosp"))条件，如果不维护医院则该产地所有院区都能看  2020-02-06 yangsj
	    s tmp=RowId_"^"_Description
	    s count = count+1
	    i (count>Start)&(count<=end) d
	    .d json.InsertRowData(tmp)
    }
    d result.Close()
    s resultString = json.getJsonData("RowId^Description",count)
    k json
    Q resultString
}

/// / creator:zhaoxinlong 2018-8-1 16:05:56
/// decription:获取类组多选Json
/// w ##class(web.DHCST.Util.OrgUtil).GetStkGrp(0,20)
ClassMethod GetStkGrp(Start As %Integer, Limit As %Integer, Hosp = "")
{
    n (Start,Limit,Hosp,%session)
    //s ^zhxl("GetGroupDept")=$lb(Start,Limit,GroupId,LocDesc,Type)
    s result = ##class(%Library.ResultSet).%New()
  
  	i Hosp'="" s HospId=Hosp
	e  s HospId=$s($d(%session):$Get(%session.Data("LOGON.HOSPID")),1:"")
  
    s sqlStr="SELECT SCG_Rowid RowId,SCG_Desc Description FROM DHC_StkCatGroup WHERE SCG_Type='G'"
  	b ;0
    d result.Prepare(sqlStr)
    d result.Execute()
    s count = 0
    s resultString = ""
    s end = Start+Limit
    s json = ##class(Code.JsonObj).%New()
    While(result.Next())
    {
    s Rowid = result.Data("RowId")
    continue:(HospId'="")&&(##class(PHA.FACE.IN.Com).GetShowDataFlag("DHC_StkCatGroup",Rowid,HospId)="N")
    s Description = result.Data("Description")
    s tmp=Rowid_"^"_Description
    s count = count+1
    i (count>Start)&(count<=end) d
    .d json.InsertRowData(tmp)
    }
    d result.Close()
    s resultString = json.getJsonData("RowId^Description",count)
    k json
    q resultString
}

/// creator:LG
/// date:2019-7-22
/// description: 医院ComboBox
/// input:  Start, Limit
/// output: String "RowId^Description"
/// others:
/// w ##class(web.DHCST.Util.OrgUtil).Hospital("0","20","","","")
ClassMethod GetAuHospData(Start As %String, Limit As %String, FilterName As %String, tablename As %String, dataid As %String)
{
	n (%session,Start,Limit,FilterName,tablename,dataid)
	s FilterName=$$ALPHAUP^SSUTIL4(FilterName)
	s HospId=$s($d(%session):$Get(%session.Data("LOGON.HOSPID")),1:"")
	s Param="^^^"_HospId
	s GroupFlag=##class(web.DHCST.Common.AppCommon).GetAppPropValue("DHCSTCOMMON","GroupFlag",Param)
    s result = ##class(%Library.ResultSet).%New("web.DHCBL.BDP.BDPMappingHOSP:GetHospDataForCloud")
    s sc=result.Execute("",FilterName,tablename,dataid)    
 	i $$$ISERR(sc) q ""
    s count = 0
    s resultString = ""
    s end = Start+Limit
    s json = ##class(Code.JsonObj).%New()
    While(result.Next())
    {
	    s RowId = result.Data("HOSPRowId")
	    s Description = result.Data("HOSPDesc")
	    s tmp=RowId_"^"_Description
	    s count = count+1
	    i (count>Start)&(count<=end) d
	    .d json.InsertRowData(tmp)
    }
    d result.Close()
    s resultString = json.getJsonData("RowId^Description",count)
    k json
    Q resultString
}

/// w ##class(web.DHCST.Util.OrgUtil).GetHospUser(0
ClassMethod GetHospUser(Start As %Integer, Limit As %Integer, Filter As %String, Hosp As %String) As %String
{
    n (Start,Limit,Filter,Hosp)
	s Filter=$zcvt(Filter,"U")
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "select ssusr_rowid as RowId,ssusr_name as Description,SSUSR_Initials as Code from SS_user"
    d result.Prepare(sqlStr)
    d result.Execute()
    s count = 0
    s resultString = ""
    s end = Start+Limit
    s json = ##class(Code.JsonObj).%New()
    While(result.Next())
    {
        s RowId = result.Data("RowId")
        s Description = result.Data("Description")
		continue:##class(PHA.FACE.IN.Com).GetShowDataFlag("SS_User",RowId,Hosp)="N"
		continue:(Filter'="")&&($zcvt(Description,"U")'[Filter)&&($zcvt(result.Data("Code"),"U")'[Filter)
        s tmp=RowId_"^"_Description
        s count = count+1
        i (count>Start)&(count<=end) d
        .d json.InsertRowData(tmp)
    }
    d result.Close()
    s resultString = json.getJsonData("RowId^Description",count)
    k json
    Q resultString
}

/// creator:yangsj 2020-08-11 
/// decription:获取库存请求单多个状态
/// w ##class(web.DHCST.Util.OrgUtil).GetReqStatus(0,20)
ClassMethod GetReqStatus(Start As %Integer, Limit As %Integer, StatusStr As %String = "")
{
    n (Start,Limit,StatusStr)
    //s ^YSJTMP("GetReqStatus")=$LB(Start,Limit,StatusStr)
    
    
  	s:StatusStr="" StatusStr="保存^完成^部分转移^全部转移^部分作废^全部作废"   //因为简拼无法直观展示描述，所以直接用描述显示
  	s json = ##class(Code.JsonObj).%New()
  	s len=$l(StatusStr,"^")
  	f i=1:1:len d
  	.s Status=$P(StatusStr,"^",i)
  	.d json.InsertRowData(Status_"^"_Status)
  	
    s resultString = json.getJsonData("RowId^Description",len)
    k json
    q resultString
}

}
