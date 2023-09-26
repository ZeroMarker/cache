Class DHCEPRFS.BL.HISInfo.BLHISInfo Extends %RegisteredObject [ ProcedureBlock ]
{

/// Desc:	w ##Class(DHCEPRFS.BL.HISInfo.BLHISInfo).GetUserName("1")
ClassMethod GetUserName(AUserID As %String) As %String
{
	q:(AUserID="") ""
	
	s userName = $p($g(^SSU("SSUSR",AUserID)),"^",2)
	q userName
}

/// Desc:	w ##Class(DHCEPRFS.BL.HISInfo.BLHISInfo).GetUserCode("1")
ClassMethod GetUserCode(AUserID As %String) As %String
{
	q:(AUserID="") ""
	
	s userCode = $p($g(^SSU("SSUSR",AUserID)),"^",1)
	q userCode
}

/// Desc：查询一段时时间住院病人的就诊号
/// d ##Class(%ResultSet).RunQuery("web.sxyu","GetADMInfo","2010-01-01","2014-04-02")
Query GetADMInfo(startDate As %String, EndDate As %String) As %Query(ROWSPEC = "admrowid:%String")
{
}

ClassMethod GetADMInfoExecute(ByRef qHandle As %Binary, startDate As %String, EndDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
    
    s startDate=$zdh(startDate,3)
    s EndDate=$zdh(EndDate,3)
    s:startDate="" startDate=+$h
	s:EndDate="" EndDate=+$h
   
    f PAADMDischgDate=startDate:1:EndDate  d
    .s PAADMRowID="" 
    .f  s PAADMRowID=$o(^PAADMi("DischDate",PAADMDischgDate,PAADMRowID)) q:PAADMRowID=""   d 
    ..s admrowid=PAADMRowID
    ..d OutputRow
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	s Data=$lb(admrowid)
 	S ^CacheTemp(repid,ind)=Data
 	S ind=ind+1
	q
}

ClassMethod GetADMInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetADMInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetADMInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetADMInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

/// Desc: w ##Class(DHCEPRFS.BL.HISInfo.BLHISInfo).CheckCTLocType("1")
ClassMethod CheckCTLocType(ACTLocID As %String) As %String
{
    q:(ACTLocID = "") ""
    
    s hospitalFlag = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("HospitalFlag")
    
    s ret = "1"
    
    if (hospitalFlag = "WLDYRM")
    {
        s ctlocType = ""
        &sql(select CTLOC_Dep_DR into :ctlocType from SQLUser.CT_Loc where CTLOC_RowID = :ACTLocID)
        //过滤非临床科室
        if (ctlocType '= "3")
        {
            s ret = "0"    
        }
    }
    
    q ret
}

/// Desc: 取关联科室rowID，以"^"分隔
/// Debug: w ##class(DHCEPRFS.BL.HISInfo.BLHISInfo).GetLinkLocID("30")
ClassMethod GetLinkLocID(ACTLocID As %String) As %String
{
	s hospitalFlag = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("HospitalFlag")
	s ret = ""
	if (hospitalFlag = "SDYGBX")
	{
		s ret = ##class(web.YGRHReports).GetLinkLoc(ACTLocID)
	}
	elseif (hospitalFlag = "WLDYRM")
	{
		s ret = ##class(web.DHCNurCom).GetLinkLocId(ACTLocID)
	}
	elseif (hospitalFlag = "SDLKRMYY")
	{
		s ret = ##class(web.DHCINSUEPR).GetLinkLoc(ACTLocID)
	}
	else
	{
		q:(ACTLocID = "") ret
		s linkSub = 0
		f {
			s linkSub = $o(^CTLOC(ACTLocID,"LINK",linkSub))
			q:(linkSub = "")
			s linkLocID = ^CTLOC(ACTLocID,"LINK",linkSub)
			if (ret = "")
			{
				s ret = linkLocID
			}
			else
			{
				s ret = ret_"^"_linkLocID
			}
		}
	}
	q ret
}

/// Desc: 根据科室ID获取科室及其关联科室的诊疗组（医疗单元）列表
/// Debug: d ##Class(%ResultSet).RunQuery("DHCEPRFS.BL.HISInfo.BLHISInfo","GetMedUnitByCTLocID","30")
Query GetMedUnitByCTLocID(ACTLocID As %String) As %Query(ROWSPEC = "TCTMUCode:%String,TCTMUDesc:%String,TCTMUActiveFlag:%String,TDateFrom:%String,TDateTo:%String,TCTLocDr:%String,TCTCode:%String,TMURowid:%String")
{
}

ClassMethod GetMedUnitByCTLocIDExecute(ByRef qHandle As %Binary, ACTLocID As %String) As %Status
{
	set repid=$I(^CacheTemp)
    set ind = 1
    set qHandle = $lb(0,repid,0)
    
    s ctLocIDS = ACTLocID
	s linkLocIDS = ..GetLinkLocID(ACTLocID)
	
	//2023-3-3 去重 yangshun
	s checkLinkLocIDS = "^"_linkLocIDS_"^"
    s:((linkLocIDS '= "" && ('(checkLinkLocIDS[("^"_ACTLocID_"^"))))) ctLocIDS = ctLocIDS_"^"_linkLocIDS
    
    f i=1:1:$l(ctLocIDS,"^")
    {
	    s CTLocDr = $p(ctLocIDS,"^",i)
		s TCTLocDr = CTLocDr
		s TCTCode = $p(^CTLOC(CTLocDr),"^",1)
		s CTChildsub = 0
		f {
			s CTChildsub = $o(^CTLOC(CTLocDr,"MU",CTChildsub))
			q:(CTChildsub = "")
			s MURowid = CTLocDr_"||"_CTChildsub
			s CTMUCode = $p(^CTLOC(CTLocDr,"MU",CTChildsub),"^",1)
			s CTMUDesc = $p(^CTLOC(CTLocDr,"MU",CTChildsub),"^",2)
			s CTMUActiveFlag = $p(^CTLOC(CTLocDr,"MU",CTChildsub),"^",3)
			s DateFrom = $p(^CTLOC(CTLocDr,"MU",CTChildsub),"^",4)
			s:(DateFrom '= "") DateFrom = $zd(DateFrom,3)
			s DateTo = $p(^CTLOC(CTLocDr,"MU",CTChildsub),"^",5)
			s:(DateTo '= "") DateTo = $zd(DateTo,3)
			s ^CacheTemp(repid,ind) = $lb(CTMUCode,CTMUDesc,CTMUActiveFlag,DateFrom,DateTo,TCTLocDr,TCTCode,MURowid)
			s ind = ind + 1
		}
    }
    
    q $$$OK
}

ClassMethod GetMedUnitByCTLocIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMedUnitByCTLocIDExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
 	Set repid = $LIST(qHandle,2)
 	Set ind = $LIST(qHandle,3)
 	Set ind = $o(^CacheTemp(repid,ind))
 	If ind = "" {				// if there are no more rows, finish fetching
 		Set AtEnd = 1
 		Set Row = ""
 	}
 	Else      {				// fetch row
 		Set Row = ^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetMedUnitByCTLocIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMedUnitByCTLocIDExecute ]
{
	Set repid = $LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Desc: 取诊疗组（医疗单元）rowID
/// Debug: w ##class(DHCEPRFS.BL.HISInfo.BLHISInfo).GetMedUnitIDByEpisode("601")
ClassMethod GetMedUnitIDByEpisode(AEpisodeID As %String) As %String
{
	s ret = ""
	s hospitalFlag = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("HospitalFlag")
	if (hospitalFlag = "WLDYRM")
	{
		s ret = ##class(web.DHCNurCom).BYPatRowid(AEpisodeID)
	}
	q ret
}

/// Desc: 通过病案号得到病人号
/// AMedRecordID:病案号   PAPMI:病人号  
/// Debug: w ##Class(DHCEPRFS.BL.HISInfo.BLHISInfo).GetPAPMIByMedRecord(500303)
ClassMethod GetPAPMIByMedRecord(AMedRecordID As %String) As %String
{
	s PAPMI = ""
    s PAPMI = $o(^PAPERi("Medicare1",AMedRecordID,0))        //通过病案号得到病人号
	q PAPMI
}

/// Desc: 通过登记号得到病人号
/// AMedRecordID:病案号   PAPMI:病人号  
/// Debug: w ##Class(DHCEPRFS.BL.HISInfo.BLHISInfo).GetPAPMIByRegNo(0000000087)
ClassMethod GetPAPMIByRegNo(ARegNo As %String) As %String
{
	s PAPMI = ""
    s PAPMI = $o(^PAPERi("PAPMI_PatNo",ARegNo,""))        //通过登记号得到病人号
	q PAPMI
}

/// Desc: 通过病人号取就诊号
/// AMedRecordID:病案号   PAPMI:病人号  PAAdm:就诊号   AdmType:就诊类型
/// Debug: w ##Class(%ResultSet).RunQuery("DHCEPRFS.BL.HISInfo.BLHISInfo","GetEpisodeIDByPAPMI","199")
Query GetEpisodeIDByPAPMI(APAPMI As %String) As %Query(ROWSPEC = "EpisodeID:%String")
{
}

ClassMethod GetEpisodeIDByPAPMIExecute(ByRef qHandle As %Binary, APAPMI As %String) As %Status
{
	set repid=$I(^CacheTemp)
    set ind = 1
    set qHandle = $lb(0,repid,0)
    
	q:(APAPMI = "") $$$OK											//如果病人号为空代表此病案不在HIS里
	s AdmType = ""
	for {
		s AdmType = $o(^PAPERdr(APAPMI,"ADM",AdmType))         //通过病人号得到就诊类型
	    q:(AdmType = "")
	    s PAAdm = ""
	    for {
		    s PAAdm = $o(^PAPERdr(APAPMI,"ADM",AdmType,PAAdm))      //通过就诊类型得到就诊号
		    q:(PAAdm = "")
			s ^CacheTemp(repid,ind) = $lb(PAAdm)
			s ind = ind + 1
		}
    }   
    q $$$OK
}

ClassMethod GetEpisodeIDByPAPMIFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEpisodeIDByPAPMIExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
 	Set repid = $LIST(qHandle,2)
 	Set ind = $LIST(qHandle,3)
 	Set ind = $o(^CacheTemp(repid,ind))
 	If ind = "" {				// if there are no more rows, finish fetching
 		Set AtEnd = 1
 		Set Row = ""
 	}
 	Else      {				// fetch row
 		Set Row = ^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetEpisodeIDByPAPMIClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEpisodeIDByPAPMIExecute ]
{
	Set repid = $LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Desc: 通过出院时间取就诊号
/// ADisdate:出院时间   PAAdm:就诊号
/// Debug: w ##Class(%ResultSet).RunQuery("DHCEPRFS.BL.HISInfo.BLHISInfo","GetEpisodeIDByDisDate","2017-05-17")
Query GetEpisodeIDByDisDate(ADisdate As %String) As %Query(ROWSPEC = "EpisodeID:%String")
{
}

ClassMethod GetEpisodeIDByDisDateExecute(ByRef qHandle As %Binary, ADisdate As %String) As %Status
{
	set repid=$I(^CacheTemp)
    set ind = 1
    set qHandle = $lb(0,repid,0)
    
    q:(ADisdate = "") $$$OK
    s Disdate = $zdh(ADisdate,3)
    
	s PAAdm = ""
	for {
		s PAAdm = $o(^PAADMi("DischDate",Disdate,PAAdm))
		q:(PAAdm = "")
		s ^CacheTemp(repid,ind) = $lb(PAAdm)
		s ind = ind + 1
    }   
    q $$$OK
}

ClassMethod GetEpisodeIDByDisDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEpisodeIDByDisDateExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
 	Set repid = $LIST(qHandle,2)
 	Set ind = $LIST(qHandle,3)
 	Set ind = $o(^CacheTemp(repid,ind))
 	If ind = "" {				// if there are no more rows, finish fetching
 		Set AtEnd = 1
 		Set Row = ""
 	}
 	Else      {				// fetch row
 		Set Row = ^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetEpisodeIDByDisDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEpisodeIDByDisDateExecute ]
{
	Set repid = $LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Desc: 遍历科室ID
/// CTLocID:科室ID  
/// Debug: w ##Class(%ResultSet).RunQuery("DHCEPRFS.BL.HISInfo.BLHISInfo","GetCTLocID")
Query GetCTLocID() As %Query(ROWSPEC = "CTLocID:%String")
{
}

ClassMethod GetCTLocIDExecute(ByRef qHandle As %Binary) As %Status
{
	set repid=$I(^CacheTemp)
    set ind = 1
    set qHandle = $lb(0,repid,0)
    
    
	s CTLocID="0"
	for {
		s CTLocID=$o(^CTLOC(CTLocID))
		q:(CTLocID="")
		s ^CacheTemp(repid,ind) = $lb(CTLocID)
		s ind = ind + 1
    }   
    q $$$OK
}

ClassMethod GetCTLocIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCTLocIDExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
 	Set repid = $LIST(qHandle,2)
 	Set ind = $LIST(qHandle,3)
 	Set ind = $o(^CacheTemp(repid,ind))
 	If ind = "" {				// if there are no more rows, finish fetching
 		Set AtEnd = 1
 		Set Row = ""
 	}
 	Else      {				// fetch row
 		Set Row = ^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetCTLocIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCTLocIDExecute ]
{
	Set repid = $LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Desc: 通过科室ID取科室信息
/// ACTLocID:科室ID   PAPMI:病人号  PAAdm:就诊号   AdmType:就诊类型
/// Debug: w ##Class(DHCEPRFS.BL.HISInfo.BLHISInfo).GetCTLocInfoByCTLocID("1")
ClassMethod GetCTLocInfoByCTLocID(ACTLocID As %String) As %ArrayOfDataTypes
{
	q:(ACTLocID = "") ""
	
	s ctLocInfo = $g(^CTLOC(ACTLocID))
	s arrFiles = ##class(%ArrayOfDataTypes).%New()
	//科室编码
	s CTLocCode = ""
	s CTLocCode = $p(ctLocInfo,"^",1)
	d arrFiles.SetAt(CTLocCode,"CTLocCode")
	//科室描述
	s CTLocDesc =""
	s CTLocDesc = $p(ctLocInfo,"^",2)
	d arrFiles.SetAt(CTLocDesc,"CTLocDesc")
	//成本中心
	s CTLocGLCCC =""
	s CTLocGLCCC = $p(ctLocInfo,"^",3)
	d arrFiles.SetAt(CTLocGLCCC,"CTLocGLCCC")
	//是否为病区
	s CTLocWardFlag = ""
	s CTLocWardFlag = $p(ctLocInfo,"^",5)
	d arrFiles.SetAt(CTLocWardFlag,"CTLocWardFlag")
	//科室类型
	s CTLocType = ""
	s CTLocType = $p(ctLocInfo,"^",13)
	d arrFiles.SetAt(CTLocType,"CTLocType")
	//科室地面
	s CTLocFloor = ""
	s CTLocFloor = $p(ctLocInfo,"^",16)
	d arrFiles.SetAt(CTLocFloor,"CTLocFloor")
	//部门组
	s CTLocDepDR = ""
	s CTLocDepDR = $p(ctLocInfo,"^",19)
	d arrFiles.SetAt(CTLocDepDR,"CTLocDepDR")
	//院区
	s CTLocHospitalDR = ""
	s CTLocHospitalDR = $p(ctLocInfo,"^",22)
	d arrFiles.SetAt(CTLocHospitalDR,"CTLocHospitalDR")
	//生效时间
	s CTLocDateActiveFrom = ""
	s CTLocDateActiveFrom = $p(ctLocInfo,"^",24)
	d arrFiles.SetAt(CTLocDateActiveFrom,"CTLocDateActiveFrom")
	//截止时间
	s CTLocDateActiveTo =""
	s CTLocDateActiveTo = $p(ctLocInfo,"^",25)
	d arrFiles.SetAt(CTLocDateActiveTo,"CTLocDateActiveTo")
	//复原标识
	s CTLocRehabilitativeFlag =""
	s CTLocRehabilitativeFlag = $p(ctLocInfo,"^",26)
	d arrFiles.SetAt(CTLocRehabilitativeFlag,"CTLocRehabilitativeFlag")
	//在此科室病历可用
	s CTLocMedicalRecordActive =""
	s CTLocMedicalRecordActive = $p(ctLocInfo,"^",27)
	d arrFiles.SetAt(CTLocMedicalRecordActive,"CTLocMedicalRecordActive")
	//收集
	s CTLocResultDelivery =""
	s CTLocResultDelivery = $p(ctLocInfo,"^",29)
	d arrFiles.SetAt(CTLocResultDelivery,"CTLocResultDelivery")
	//电话号码
	s CTLocTelephone =""
	s CTLocTelephone = $p(ctLocInfo,"^",40)
	d arrFiles.SetAt(CTLocTelephone,"CTLocTelephone")
	//电话号码额外信息
	s CTLocTelephoneExt =""
	s CTLocTelephoneExt = $p(ctLocInfo,"^",41)
	d arrFiles.SetAt(CTLocTelephoneExt,"CTLocTelephoneExt")
	//联系人姓名
	s CTLocContactName =""
	s CTLocContactName = $p(ctLocInfo,"^",43)
	d arrFiles.SetAt(CTLocContactName,"CTLocContactName")
	
	q arrFiles
}

/// Desc: 通过就诊类型得到科室ID
/// ACTLocType:科室类型   CTLocID:科室ID
/// Debug: w ##Class(%ResultSet).RunQuery("DHCEPRFS.BL.HISInfo.BLHISInfo","GetCTLocIDByCTLocType","E")
Query GetCTLocIDByCTLocType(ACTLocType As %String) As %Query(ROWSPEC = "CTLocID:%String")
{
}

ClassMethod GetCTLocIDByCTLocTypeExecute(ByRef qHandle As %Binary, ACTLocType As %String) As %Status
{
	set repid=$I(^CacheTemp)
    set ind = 1
    set qHandle = $lb(0,repid,0)
    
    q:(ACTLocType = "") $$$OK
    
    s CTLocID = ""
	for {
		s CTLocID = $o(^CTLOC(0,"LocType",ACTLocType,CTLocID))
		q:(CTLocID = "")

		s ^CacheTemp(repid,ind) = $lb(CTLocID)
		s ind = ind + 1
    }   
    q $$$OK
}

ClassMethod GetCTLocIDByCTLocTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCTLocIDByCTLocTypeExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
 	Set repid = $LIST(qHandle,2)
 	Set ind = $LIST(qHandle,3)
 	Set ind = $o(^CacheTemp(repid,ind))
 	If ind = "" {				// if there are no more rows, finish fetching
 		Set AtEnd = 1
 		Set Row = ""
 	}
 	Else      {				// fetch row
 		Set Row = ^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetCTLocIDByCTLocTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCTLocIDByCTLocTypeExecute ]
{
	Set repid = $LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Desc: 通过院区ID取院区信息
/// AHospitalID:院区ID
/// Output:
/// HospCode:院区编码
/// HospDesc:院区描述
/// HospBillNo:账单编号
/// HospCreditNoteNo:信用笔记编号
/// HospDateFrom:有效起始时间
/// HospDateTo:有效结束时间
/// HospPhone:院区电话
/// HospFax:院区传真
/// HospEmail:院区邮箱
/// HospZip:邮编
/// HospState:院区区域
/// HospAddress:院区地址
/// HospCity:院区市 
/// Debug: w ##Class(DHCEPRFS.BL.HISInfo.BLHISInfo).GetHospitalInfoByHospitalID("2")
ClassMethod GetHospitalInfoByHospitalID(AHospitalID As %String) As %ArrayOfDataTypes
{
	q:(AHospitalID = "") ""
	//s CTLocInfo = ""
	
	s arrFiles = ##class(%ArrayOfDataTypes).%New()
	s hospitalInfo = $g(^CT("HOSP",AHospitalID))

	//院区编码
	s HospCode = ""
	s HospCode = $p(hospitalInfo,"^",1)
	d arrFiles.SetAt(HospCode,"HospCode")
	//院区描述
	s HospDesc = ""
	s HospDesc = $p(hospitalInfo,"^",2)
	d arrFiles.SetAt(HospDesc,"HospDesc")
	//账单编号
	s HospBillNo = ""
	s HospBillNo = $p(hospitalInfo,"^",3)
	d arrFiles.SetAt(HospBillNo,"HospBillNo")
	//信用笔记编号
	s HospCreditNoteNo = ""
	s HospCreditNoteNo = $p(hospitalInfo,"^",4)
	d arrFiles.SetAt(HospCreditNoteNo,"HospCreditNoteNo")
	//有效起始时间
	s HospDateFrom = ""
	s HospDateFrom = $p(hospitalInfo,"^",9)
	d arrFiles.SetAt(HospDateFrom,"HospDateFrom")
	//有效结束时间
	s HospDateTo = ""
	s HospDateTo = $p(hospitalInfo,"^",10)
	d arrFiles.SetAt(HospDateTo,"HospDateTo")
	//院区电话
	s HospPhone = ""
	s HospPhone = $p(hospitalInfo,"^",11)
	d arrFiles.SetAt(HospPhone,"HospPhone")
	//院区传真
	s HospFax = ""
	s HospFax = $p(hospitalInfo,"^",12)
	d arrFiles.SetAt(HospFax,"HospFax")
	//院区邮箱
	s HospEmail = ""
	s HospEmail = $p(hospitalInfo,"^",13)
	d arrFiles.SetAt(HospEmail,"HospEmail")
	//邮编
	s HospZip = ""
	s HospZip = $p(hospitalInfo,"^",16)
	d arrFiles.SetAt(HospZip,"HospZip")
	//院区区域
	s HospState = ""
	s HospState = $p(hospitalInfo,"^",17)
	d arrFiles.SetAt(HospState,"HospState")
	//院区地址
	s HospAddress = ""
	s HospAddress = $p(hospitalInfo,"^",18)
	d arrFiles.SetAt(HospAddress,"HospAddress")
	//院区市
	s HospCity = ""
	s HospCity = $p(hospitalInfo,"^",19)
	d arrFiles.SetAt(HospCity,"HospCity")
	
	q arrFiles
}

/// Desc: 通过诊断ID取诊断信息
/// AMRCID:诊断ID
/// Output:
/// MRCIDCode:诊断编码
/// MRCIDDesc:诊断描述
/// MRCIDICD9CMCode:国际疾病分类手术码
/// MRCIDMaxWaitPerio:预计停留长度
/// MRCIDDateActiveFrom:生效日期
/// MRCIDDateActiveTo:截止日期
/// MRCIDSex:性别
/// Debug: w ##Class(DHCEPRFS.BL.HISInfo.BLHISInfo).GetMRCIDInfoByMRCID("2")
ClassMethod GetMRCIDInfoByMRCID(AMRCID As %String) As %ArrayOfDataTypes
{
	q:(AMRCID = "") ""
	//s CTLocInfo = ""
	
	s arrFiles = ##class(%ArrayOfDataTypes).%New()
	s mrcIDInfo = $g(^MRC("ID",AMRCID))
	
	//诊断编码
	s MRCIDCode = ""
	s MRCIDCode = $p(mrcIDInfo,"^",1)
	d arrFiles.SetAt(MRCIDCode,"MRCIDCode")
	//诊断描述
	s MRCIDDesc = ""
	s MRCIDDesc = $p(mrcIDInfo,"^",2)
	d arrFiles.SetAt(MRCIDDesc,"MRCIDDesc")
	//国际疾病分类手术码
	s MRCIDICD9CMCode = ""
	s MRCIDICD9CMCode = $p(mrcIDInfo,"^",4)
	d arrFiles.SetAt(MRCIDICD9CMCode,"MRCIDICD9CMCode")
	//预计停留长度
	s MRCIDMaxWaitPerio = ""
	s MRCIDMaxWaitPerio = $p(mrcIDInfo,"^",5)
	d arrFiles.SetAt(MRCIDMaxWaitPerio,"MRCIDMaxWaitPerio")
	//生效日期
	s MRCIDDateActiveFrom = ""
	s MRCIDDateActiveFrom = $p(mrcIDInfo,"^",6)
	d arrFiles.SetAt(MRCIDDateActiveFrom,"MRCIDDateActiveFrom")
	//截止日期
	s MRCIDDateActiveTo = ""
	s MRCIDDateActiveTo = $p(mrcIDInfo,"^",7)
	d arrFiles.SetAt(MRCIDDateActiveTo,"MRCIDDateActiveTo")
	//性别
	s MRCIDSex = ""
	s MRCIDSex = $p(mrcIDInfo,"^",10)
	d arrFiles.SetAt(MRCIDSex,"MRCIDSex")
	
	q arrFiles
}

/// Desc: 通过诊断ID取诊断别名
/// ACTLocType:科室类型   CTLocID:科室ID
/// Debug: w ##Class(%ResultSet).RunQuery("DHCEPRFS.BL.HISInfo.BLHISInfo","GetAliasTextByMRCID","25280")
Query GetAliasTextByMRCID(AMRCID As %String) As %Query(ROWSPEC = "AliasText:%String")
{
}

ClassMethod GetAliasTextByMRCIDExecute(ByRef qHandle As %Binary, AMRCID As %String) As %Status
{
	set repid=$I(^CacheTemp)
    set ind = 1
    set qHandle = $lb(0,repid,0)
    
    q:(AMRCID = "") $$$OK
    
    s AliasText = ""
    s aliasRowid=0
	for {
		s aliasRowid=$o(^MRC("ID",AMRCID,"ALIAS",aliasRowid))
		q:(aliasRowid="")
		s AliasText=$p($g(^MRC("ID",AMRCID,"ALIAS",aliasRowid)),"^",1)

		s ^CacheTemp(repid,ind) = $lb(AliasText)
		s ind = ind + 1
    }   
    q $$$OK
}

ClassMethod GetAliasTextByMRCIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAliasTextByMRCIDExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
 	Set repid = $LIST(qHandle,2)
 	Set ind = $LIST(qHandle,3)
 	Set ind = $o(^CacheTemp(repid,ind))
 	If ind = "" {				// if there are no more rows, finish fetching
 		Set AtEnd = 1
 		Set Row = ""
 	}
 	Else      {				// fetch row
 		Set Row = ^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetAliasTextByMRCIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAliasTextByMRCIDExecute ]
{
	Set repid = $LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Desc: 遍历诊断ID
/// MRCID:诊断ID 
/// Debug: w ##Class(%ResultSet).RunQuery("DHCEPRFS.BL.HISInfo.BLHISInfo","GetMRCID")
Query GetMRCID() As %Query(ROWSPEC = "MRCID:%String")
{
}

ClassMethod GetMRCIDExecute(ByRef qHandle As %Binary) As %Status
{
	set repid=$I(^CacheTemp)
    set ind = 1
    set qHandle = $lb(0,repid,0)
    
    
	s MRCID = 0
	for {
		s MRCID=$o(^MRC("ID",MRCID))
		q:(MRCID = "")
		s ^CacheTemp(repid,ind) = $lb(MRCID)
		s ind = ind + 1
    }   
    q $$$OK
}

ClassMethod GetMRCIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMRCIDExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
 	Set repid = $LIST(qHandle,2)
 	Set ind = $LIST(qHandle,3)
 	Set ind = $o(^CacheTemp(repid,ind))
 	If ind = "" {				// if there are no more rows, finish fetching
 		Set AtEnd = 1
 		Set Row = ""
 	}
 	Else      {				// fetch row
 		Set Row = ^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetMRCIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMRCIDExecute ]
{
	Set repid = $LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Desc: 遍历手术ID
/// OPERID:手术ID 
/// Debug: w ##Class(%ResultSet).RunQuery("DHCEPRFS.BL.HISInfo.BLHISInfo","GetOPERID")
Query GetOPERID() As %Query(ROWSPEC = "OPERID:%String")
{
}

ClassMethod GetOPERIDExecute(ByRef qHandle As %Binary) As %Status
{
	set repid=$I(^CacheTemp)
    set ind = 1
    set qHandle = $lb(0,repid,0)
    
    
	s OPERID = 0
	for {
		s OPERID=$o(^ORC("OPER",OPERID))
		q:(OPERID = "")
		s ^CacheTemp(repid,ind) = $lb(OPERID)
		s ind = ind + 1
    }   
    q $$$OK
}

ClassMethod GetOPERIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOPERIDExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
 	Set repid = $LIST(qHandle,2)
 	Set ind = $LIST(qHandle,3)
 	Set ind = $o(^CacheTemp(repid,ind))
 	If ind = "" {				// if there are no more rows, finish fetching
 		Set AtEnd = 1
 		Set Row = ""
 	}
 	Else      {				// fetch row
 		Set Row = ^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetOPERIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOPERIDExecute ]
{
	Set repid = $LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Desc: 通过手术ID取手术信息
/// OPERID:手术ID
/// Output:
/// OPERCode:手术编码
/// OPERDesc:手术描述
/// OPERARCIMDR:默认医嘱项目
/// OPERDateActiveFrom:起始时间
/// OPERDateActiveTo:截止日期
/// OPERDefaultCategory:手术种类
/// OPERICD10:ICD10代码
/// Debug: w ##Class(DHCEPRFS.BL.HISInfo.BLHISInfo).GetMRCIDInfoByMRCID("2")
ClassMethod GetOPERInfoByOPERID(AOPERID As %String) As %ArrayOfDataTypes
{
	q:(AOPERID = "") ""
	//s CTLocInfo = ""
	
	s arrFiles = ##class(%ArrayOfDataTypes).%New()
	s operInfo = $g(^ORC("OPER",AOPERID))

	//手术编码
	s OPERCode = ""
	s OPERCode = $p(operInfo,"^",1)
	d arrFiles.SetAt(OPERCode,"OPERCode")
	//手术描述
	s OPERDesc = ""
	s OPERDesc = $p(operInfo,"^",2)
	d arrFiles.SetAt(OPERDesc,"OPERDesc")
	//默认医嘱项目
	s OPERARCIMDR = ""
	s OPERARCIMDR = $p(operInfo,"^",4)
	d arrFiles.SetAt(OPERARCIMDR,"OPERARCIMDR")
	//起始时间
	s OPERDateActiveFrom = ""
	s OPERDateActiveFrom = $p(operInfo,"^",5)
	d arrFiles.SetAt(OPERDateActiveFrom,"OPERDateActiveFrom")
	//结束时间
	s OPERDateActiveTo = ""
	s OPERDateActiveTo = $p(operInfo,"^",6)
	d arrFiles.SetAt(OPERDateActiveTo,"OPERDateActiveTo")
	//手术种类
	s OPERDefaultCategory = ""
	s OPERDefaultCategory = $p(operInfo,"^",7)
	d arrFiles.SetAt(OPERDefaultCategory,"OPERDefaultCategory")
	//ICD10代码
	s OPERICD10 = ""
	s OPERICD10 = $p(operInfo,"^",14)
	d arrFiles.SetAt(OPERICD10,"OPERICD10")
	
	
	q arrFiles
}

/// Desc: 通过手术ID取手术别名
/// AOPERID:手术ID
/// Debug: w ##Class(%ResultSet).RunQuery("DHCEPRFS.BL.HISInfo.BLHISInfo","GetAliasTextByOPERID","6152")
Query GetAliasTextByOPERID(AOPERID As %String) As %Query(ROWSPEC = "AliasText:%String")
{
}

ClassMethod GetAliasTextByOPERIDExecute(ByRef qHandle As %Binary, AOPERID As %String) As %Status
{
	set repid=$I(^CacheTemp)
    set ind = 1
    set qHandle = $lb(0,repid,0)
    
    q:(AOPERID = "") $$$OK
    
    s AliasText = ""
    s aliasRowid=0
	for {
		s aliasRowid=$o(^ORC("OPER",AOPERID,"ALIAS",aliasRowid))
		q:(aliasRowid="")
		s AliasText=$p($g(^ORC("OPER",AOPERID,"ALIAS",aliasRowid)),"^",1)

		s ^CacheTemp(repid,ind) = $lb(AliasText)
		s ind = ind + 1
    }   
    q $$$OK
}

ClassMethod GetAliasTextByOPERIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAliasTextByOPERIDExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
 	Set repid = $LIST(qHandle,2)
 	Set ind = $LIST(qHandle,3)
 	Set ind = $o(^CacheTemp(repid,ind))
 	If ind = "" {				// if there are no more rows, finish fetching
 		Set AtEnd = 1
 		Set Row = ""
 	}
 	Else      {				// fetch row
 		Set Row = ^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetAliasTextByOPERIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAliasTextByOPERIDExecute ]
{
	Set repid = $LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Desc: 遍历麻醉ID
/// ANMETID:麻醉ID 
/// Debug: w ##Class(%ResultSet).RunQuery("DHCEPRFS.BL.HISInfo.BLHISInfo","GetANMETID")
Query GetANMETID() As %Query(ROWSPEC = "ANMETID:%String")
{
}

ClassMethod GetANMETIDExecute(ByRef qHandle As %Binary) As %Status
{
	set repid=$I(^CacheTemp)
    set ind = 1
    set qHandle = $lb(0,repid,0)
    
    
	s ANMETID = 0
	for {
		s ANMETID=$o(^ORC("ANMET",ANMETID))
		q:(ANMETID = "")
		s ^CacheTemp(repid,ind) = $lb(ANMETID)
		s ind = ind + 1
    }   
    q $$$OK
}

ClassMethod GetANMETIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetANMETIDExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
 	Set repid = $LIST(qHandle,2)
 	Set ind = $LIST(qHandle,3)
 	Set ind = $o(^CacheTemp(repid,ind))
 	If ind = "" {				// if there are no more rows, finish fetching
 		Set AtEnd = 1
 		Set Row = ""
 	}
 	Else      {				// fetch row
 		Set Row = ^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetANMETIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetANMETIDExecute ]
{
	Set repid = $LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Desc: 通过麻醉ID取麻醉信息
/// ANMETID:麻醉ID
/// Output:
/// ANMETCode:麻醉编码
/// ANMETDesc:麻醉描述
/// ANMETTypeDR:麻醉类型
/// ANMETARCOSDR:医嘱套
/// ANMETDateFrom:起始时间
/// ANMETDateTo:结束时间
/// Debug: w ##Class(DHCEPRFS.BL.HISInfo.BLHISInfo).GetANMETInfoByANMETID("191")
ClassMethod GetANMETInfoByANMETID(AANMETID As %String) As %ArrayOfDataTypes
{
	q:(AANMETID = "") ""
	
	s arrFiles = ##class(%ArrayOfDataTypes).%New()
	s anmetInfo = $g(^ORC("ANMET",AANMETID))

	//麻醉编码
	s ANMETCode = ""
	s ANMETCode = $p(anmetInfo,"^",1)
	d arrFiles.SetAt(ANMETCode,"ANMETCode")
	//麻醉描述
	s ANMETDesc = ""
	s ANMETDesc = $p(anmetInfo,"^",2)
	d arrFiles.SetAt(ANMETDesc,"ANMETDesc")
	//麻醉类型
	s ANMETTypeDR = ""
	s ANMETTypeDR = $p(anmetInfo,"^",3)
	d arrFiles.SetAt(ANMETTypeDR,"ANMETTypeDR")
	//医嘱套
	s ANMETARCOSDR = ""
	s ANMETARCOSDR = $p(anmetInfo,"^",4)
	d arrFiles.SetAt(ANMETARCOSDR,"ANMETARCOSDR")
	//起始时间
	s ANMETDateFrom = ""
	s ANMETDateFrom = $p(anmetInfo,"^",5)
	d arrFiles.SetAt(ANMETDateFrom,"ANMETDateFrom")
	//结束时间
	s ANMETDateTo = ""
	s ANMETDateTo = $p(anmetInfo,"^",6)
	d arrFiles.SetAt(ANMETDateTo,"ANMETDateTo")


	q arrFiles
}

/// Desc: 通过麻醉ID取麻醉别名
/// ANMETID:麻醉ID
/// Debug: w ##Class(%ResultSet).RunQuery("DHCEPRFS.BL.HISInfo.BLHISInfo","GetAliasTextByANMETID","191")
Query GetAliasTextByANMETID(AANMETID As %String) As %Query(ROWSPEC = "AliasText:%String")
{
}

ClassMethod GetAliasTextByANMETIDExecute(ByRef qHandle As %Binary, AANMETID As %String) As %Status
{
	set repid=$I(^CacheTemp)
    set ind = 1
    set qHandle = $lb(0,repid,0)
    
    q:(AANMETID = "") $$$OK
    
    s AliasText = ""
    s aliasRowid=0
	for {
		s aliasRowid=$o(^ORC("ANMET",AANMETID,"ALIAS",aliasRowid))
		q:(aliasRowid="")
		s AliasText=$g(^ORC("ANMET",AANMETID,"ALIAS",aliasRowid))

		s ^CacheTemp(repid,ind) = $lb(AliasText)
		s ind = ind + 1
    }   
    q $$$OK
}

ClassMethod GetAliasTextByANMETIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAliasTextByANMETIDExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
 	Set repid = $LIST(qHandle,2)
 	Set ind = $LIST(qHandle,3)
 	Set ind = $o(^CacheTemp(repid,ind))
 	If ind = "" {				// if there are no more rows, finish fetching
 		Set AtEnd = 1
 		Set Row = ""
 	}
 	Else      {				// fetch row
 		Set Row = ^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetAliasTextByANMETIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAliasTextByANMETIDExecute ]
{
	Set repid = $LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Desc: 通过就诊时间取就诊号
/// AAdmdate:就诊时间   PAAdm:就诊号
/// Debug: w ##Class(%ResultSet).RunQuery("DHCEPRFS.BL.HISInfo.BLHISInfo","GetEpisodeIDByAdmDate","2017-05-17")
Query GetEpisodeIDByAdmDate(AAdmdate As %String) As %Query(ROWSPEC = "EpisodeID:%String")
{
}

ClassMethod GetEpisodeIDByAdmDateExecute(ByRef qHandle As %Binary, AAdmdate As %String) As %Status
{
	set repid=$I(^CacheTemp)
    set ind = 1
    set qHandle = $lb(0,repid,0)
    
    q:(AAdmdate = "") $$$OK
    s Admdate = $zdh(AAdmdate,3)
    
	s PAAdm = ""
	for {
		s PAAdm = $o(^PAADMi("PAADM_AdmDate",Admdate,PAAdm))
		q:(PAAdm = "")
		s ^CacheTemp(repid,ind) = $lb(PAAdm)
		s ind = ind + 1
    }   
    q $$$OK
}

ClassMethod GetEpisodeIDByAdmDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEpisodeIDByAdmDateExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
 	Set repid = $LIST(qHandle,2)
 	Set ind = $LIST(qHandle,3)
 	Set ind = $o(^CacheTemp(repid,ind))
 	If ind = "" {				// if there are no more rows, finish fetching
 		Set AtEnd = 1
 		Set Row = ""
 	}
 	Else      {				// fetch row
 		Set Row = ^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetEpisodeIDByAdmDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEpisodeIDByAdmDateExecute ]
{
	Set repid = $LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
