/// 描述: HIS-Location与HR-组织关联关系表(HCP) 增删改类方法
/// 编写者：基础数据平台 likefan
/// 编写日期: 2020-07-25
Class web.DHCBL.CT.CTDepartmentLocation Extends %RegisteredObject
{

/// Creator：基础数据平台-李可凡
/// CreatDate: 2020-07-25
/// Description：查询Query
/// Table：User.CTDepartmentLocation
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTDepartmentLocation","GetList","","","","")
Query GetList(rowid As %String, deptdesc As %String, locsource As %String, loccode As %String, locdesc As %String) As %Query(ROWSPEC = "ID,DEPRowId,DEPLDeptDR,CTRFCCode,CTRFCDesc,DEPLLocSource,DEPLLocID,DEPLLocCode,DEPLLocDesc,LocationType,DEPLParentLocSource,DEPLParentLocID,DEPLParentLocCode,DEPLParentLocDesc,DEPLDateFrom,DEPLDateTo")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, deptdesc As %String, locsource As %String, loccode As %String, locdesc As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	
 	if (rowid'="")
 	{
		s ID=rowid
		s DEPLDeptDR=$lg($g(^User.CTDepartmentLocationD(ID)),2)			//组织部门DR
		s DEPRowId="",DEPRefClinDR="",CTRFCCode="",CTRFCDesc=""
		if (DEPLDeptDR'="")
		{
			s DEPRowId=$lg($g(^User.CTDepartmentD(DEPLDeptDR)),2)		// HR里（MDM平台）的组织部门代码
			s DEPRefClinDR=$lg($g(^User.CTDepartmentD(DEPLDeptDR)),9)	// HIS医疗机构DR
			s:DEPRefClinDR'="" CTRFCCode=$p($g(^CT("RFC",DEPRefClinDR)),"^",1)			// 医疗机构代码
        	s:DEPRefClinDR'="" CTRFCDesc=$p($g(^CT("RFC",DEPRefClinDR)),"^",2)			// 医疗机构名称
		}
        s:DEPLDeptDR'="" DEPLDeptDR=$lg($g(^User.CTDepartmentD(DEPLDeptDR)),4)		// 组织部门描述
		s DEPLLocSource=$lg($g(^User.CTDepartmentLocationD(ID)),3)		//Location来源
		s DEPLLocID=$lg($g(^User.CTDepartmentLocationD(ID)),4)			//Location rowid
		s DEPLLocCode=$lg($g(^User.CTDepartmentLocationD(ID)),5)		//Location代码
		s DEPLLocDesc=$lg($g(^User.CTDepartmentLocationD(ID)),6)		//Location名称
		s LocationType=""											//Location类型
		if (DEPLLocID'="")	//根据科室取科室分类
		{
			//s typestr=##class(web.DHCBL.CT.PACAdmTypeLocation).GetAdmTypeByLoc(DEPLLocID)
			//s LocationType=$p(typestr,"^",3)
			//s LocationType=$case(LocationType,"O":"门诊","I":"住院","E":"急诊","H":"体检",:"")
			s LocationType=##class(web.DHCBL.CT.PACAdmTypeLocation).GetAdmTypeDescStrByLoc(DEPLLocID)
		}
		s DEPLParentLocSource=$lg($g(^User.CTDepartmentLocationD(ID)),7)		//上级Location来源
		s DEPLParentLocID=$lg($g(^User.CTDepartmentLocationD(ID)),8)			//上级Location rowid
		s DEPLParentLocCode=$lg($g(^User.CTDepartmentLocationD(ID)),9)			//上级Location代码
		s DEPLParentLocDesc=$lg($g(^User.CTDepartmentLocationD(ID)),10)			//上级Location名称
		s DEPLDateFrom=$lg($g(^User.CTDepartmentLocationD(ID)),11)				//开始日期
		if (DEPLDateFrom="")&&(DEPLLocID'="")&&(DEPLLocSource="CT_Loc")
		{
			s DEPLDateFrom=$p($g(^CTLOC(DEPLLocID)),"^",24)
		}
		s DEPLDateTo=$lg($g(^User.CTDepartmentLocationD(ID)),12)				//结束日期
		if (DEPLDateTo="")&&(DEPLLocID'="")&&(DEPLLocSource="CT_Loc")
		{
			s DEPLDateTo=$p($g(^CTLOC(DEPLLocID)),"^",25)
		}
		if (DEPLParentLocID'="")	//从CT_Loc表取代码名称
		{
			s DEPLParentLocCode=$p($g(^CTLOC(DEPLParentLocID)),"^",1)
			s DEPLParentLocDesc=$p($g(^CTLOC(DEPLParentLocID)),"^",2)
		}
		if (DEPLLocID'="")	//从CT_Loc表取代码、名称
		{
			s DEPLLocCode=$p($g(^CTLOC(DEPLLocID)),"^",1)
			s DEPLLocDesc=$p($g(^CTLOC(DEPLLocID)),"^",2)
		}
		s:DEPLDateFrom'="" DEPLDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(DEPLDateFrom)	//转换日期格式
		s:DEPLDateTo'="" DEPLDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(DEPLDateTo)	//转换日期格式
		d OutputRow
	}
	else
	{
		s:deptdesc'="" deptdesc=$ZCONVERT(deptdesc,"U")
		s:locsource'="" locsource=$ZCONVERT(locsource,"U")
		s:loccode'="" loccode=$ZCONVERT(loccode,"U")
		s:locdesc'="" locdesc=$ZCONVERT(locdesc,"U")
		s ID=0
		for
		{
		 	s ID=$o(^User.CTDepartmentLocationD(ID)) q:ID=""
		 	s DEPLDeptDR=$lg($g(^User.CTDepartmentLocationD(ID)),2)			//组织部门DR
		 	s DEPRowId="",DEPRefClinDR="",CTRFCCode="",CTRFCDesc=""
			if (DEPLDeptDR'="")
			{
				s DEPRowId=$lg($g(^User.CTDepartmentD(DEPLDeptDR)),2)		// HR里（MDM平台）的组织部门代码
				s DEPRefClinDR=$lg($g(^User.CTDepartmentD(DEPLDeptDR)),9)	// HIS医疗机构DR
				s:DEPRefClinDR'="" CTRFCCode=$p($g(^CT("RFC",DEPRefClinDR)),"^",1)			// 医疗机构代码
	        	s:DEPRefClinDR'="" CTRFCDesc=$p($g(^CT("RFC",DEPRefClinDR)),"^",2)			// 医疗机构名称
			}
	        s:DEPLDeptDR'="" DEPLDeptDR=$lg($g(^User.CTDepartmentD(DEPLDeptDR)),4)		// 组织部门描述
			s DEPLLocSource=$lg($g(^User.CTDepartmentLocationD(ID)),3)		//Location来源
			s DEPLLocID=$lg($g(^User.CTDepartmentLocationD(ID)),4)			//Location rowid
			s DEPLLocCode=$lg($g(^User.CTDepartmentLocationD(ID)),5)		//Location代码
			s DEPLLocDesc=$lg($g(^User.CTDepartmentLocationD(ID)),6)		//Location名称
			s LocationType=""											//Location类型
			if (DEPLLocID'="")	//根据科室取科室分类
			{
				//s typestr=##class(web.DHCBL.CT.PACAdmTypeLocation).GetAdmTypeByLoc(DEPLLocID)
				//s LocationType=$p(typestr,"^",3)
				//s LocationType=$case(LocationType,"O":"门诊","I":"住院","E":"急诊","H":"体检",:"")
				s LocationType=##class(web.DHCBL.CT.PACAdmTypeLocation).GetAdmTypeDescStrByLoc(DEPLLocID)
			}
			s DEPLParentLocSource=$lg($g(^User.CTDepartmentLocationD(ID)),7)		//上级Location来源
			s DEPLParentLocID=$lg($g(^User.CTDepartmentLocationD(ID)),8)			//上级Location rowid
			s DEPLParentLocCode=$lg($g(^User.CTDepartmentLocationD(ID)),9)			//上级Location代码
			s DEPLParentLocDesc=$lg($g(^User.CTDepartmentLocationD(ID)),10)			//上级Location名称
			s DEPLDateFrom=$lg($g(^User.CTDepartmentLocationD(ID)),11)				//开始日期
			if (DEPLDateFrom="")&&(DEPLLocID'="")
			{
				s DEPLDateFrom=$p($g(^CTLOC(DEPLLocID)),"^",24)
			}
			s DEPLDateTo=$lg($g(^User.CTDepartmentLocationD(ID)),12)				//结束日期
			if (DEPLDateTo="")&&(DEPLLocID'="")
			{
				s DEPLDateTo=$p($g(^CTLOC(DEPLLocID)),"^",25)
			}
			if (DEPLParentLocID'="")	//从CT_Loc表取代码名称
			{
				s DEPLParentLocCode=$p($g(^CTLOC(DEPLParentLocID)),"^",1)
				s DEPLParentLocDesc=$p($g(^CTLOC(DEPLParentLocID)),"^",2)
			}
			if (DEPLLocID'="")	//从CT_Loc表取代码、名称、日期
			{
				s DEPLLocCode=$p($g(^CTLOC(DEPLLocID)),"^",1)
				s DEPLLocDesc=$p($g(^CTLOC(DEPLLocID)),"^",2)
			}
			s:DEPLDateFrom'="" DEPLDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(DEPLDateFrom)	//转换日期格式
			s:DEPLDateTo'="" DEPLDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(DEPLDateTo)	//转换日期格式
			
			s PINYINDept="",PINYINSource="",PINYINCode="",PINYINDesc=""
			s PINYINDept=##class(web.DHCBL.BDP.FunLib).GetPYCODE(DEPLDeptDR)
			s PINYINSource=##class(web.DHCBL.BDP.FunLib).GetPYCODE(DEPLLocSource)
			s PINYINCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE(DEPLLocCode)
			s PINYINDesc=##class(web.DHCBL.BDP.FunLib).GetPYCODE(DEPLLocDesc)
		 	if ((($ZCONVERT(DEPLDeptDR,"U")[deptdesc)||(PINYINDept[deptdesc))&&(($ZCONVERT(DEPLLocSource,"U")[locsource)||(PINYINSource[locsource))&&(($ZCONVERT(DEPLLocCode,"U")[loccode)||(PINYINCode[loccode))&&(($ZCONVERT(DEPLLocDesc,"U")[locdesc)||(PINYINDesc[locdesc)))
			{
				d OutputRow
			}
		}
	}
 	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(ID,DEPRowId,DEPLDeptDR,CTRFCCode,CTRFCDesc,DEPLLocSource,DEPLLocID,DEPLLocCode,DEPLLocDesc,LocationType,DEPLParentLocSource,DEPLParentLocID,DEPLParentLocCode,DEPLParentLocDesc,DEPLDateFrom,DEPLDateTo)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator：基础数据平台-李可凡
/// CreatDate: 2020-07-25
/// Description：新增修改时的查询
/// Table：User.CTDepartmentLocation
/// Input：id
/// Others：w ##class(web.DHCBL.CT.CTDepartmentLocation).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
	s str=""
	s obj = ##class(User.CTDepartmentLocation).%OpenId(id)
	s eobj = ##class(web.Entity.CT.CTDepartmentLocation).%New()
	s eobj.ID = id				//RowId
	s:obj.DEPLDeptDR'="" eobj.DEPLDeptDR=obj.DEPLDeptDR.%Id()	//HR组织部门表id
	s eobj.DEPLLocSource=obj.DEPLLocSource						//Location来源
	s eobj.DEPLLocID=obj.DEPLLocID								//Location rowid
	s eobj.DEPLParentLocSource=obj.DEPLParentLocSource			//上级Location来源
	s eobj.DEPLParentLocID=obj.DEPLParentLocID					//上级Location rowid
	s eobj.DEPLDateFrom=obj.DEPLDateFrom						//开始日期
	if (eobj.DEPLDateFrom="")&&(eobj.DEPLLocID'="")&&(eobj.DEPLLocSource="CT_Loc")
	{
		s eobj.DEPLDateFrom=$p($G(^CTLOC(eobj.DEPLLocID)),"^",24)
	}
	s eobj.DEPLDateTo=obj.DEPLDateTo							//结束日期
	if (eobj.DEPLDateTo="")&&(eobj.DEPLLocID'="")&&(eobj.DEPLLocSource="CT_Loc")
	{
		s eobj.DEPLDateTo=$p($G(^CTLOC(eobj.DEPLLocID)),"^",25)
	}
	s:eobj.DEPLDateFrom'="" eobj.DEPLDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.DEPLDateFrom)
	s:eobj.DEPLDateTo'="" eobj.DEPLDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.DEPLDateTo)
	d obj.%Close()
	k obj
	s str = eobj.JsonS()
	//s str = "{list:["_str_"]}"
	q str
}

/// Creator：基础数据平台-李可凡
/// CreatDate: 2020-07-26
/// function:新增修改保存
/// Table：User.CTDepartmentLocation
ClassMethod SaveEntity(eobj As web.Entity.CT.CTDepartmentLocation) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		s:eobj.DEPLDateFrom'="" eobj.DEPLDateFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.DEPLDateFrom)  //转换日期
        s:eobj.DEPLDateTo'="" eobj.DEPLDateTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.DEPLDateTo)  //转换日期
		s:eobj.DEPLLocSource="" eobj.DEPLLocSource="CT_Loc"
		s flag=..FormValidate(eobj.ID,eobj.DEPLDeptDR,eobj.DEPLLocSource,eobj.DEPLLocID,"")  //调用重复验证
		if (flag=1)
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		if (eobj.ID="")
		{
			s obj=##class(User.CTDepartmentLocation).%New()
		}
		else
		{
			s obj=##class(User.CTDepartmentLocation).%OpenId(eobj.ID)
			s bobj=##class(web.Entity.CT.CTDepartmentLocation).%New()
		    s bobj.ID=eobj.ID
		    s:obj.DEPLDeptDR'="" bobj.DEPLDeptDR=obj.DEPLDeptDR.%Id()
			s bobj.DEPLLocSource=obj.DEPLLocSource
			s bobj.DEPLLocID=obj.DEPLLocID
			s bobj.DEPLParentLocSource=obj.DEPLParentLocSource
			s bobj.DEPLParentLocID=obj.DEPLParentLocID
			s bobj.DEPLDateFrom=obj.DEPLDateFrom
			s bobj.DEPLDateTo=obj.DEPLDateTo
		}
		d obj.DEPLDeptDRSetObjectId(eobj.DEPLDeptDR)			//HR组织部门表id
		s obj.DEPLLocSource=eobj.DEPLLocSource					//Location来源
		s obj.DEPLLocID=eobj.DEPLLocID							//Location rowid
		s obj.DEPLParentLocSource=eobj.DEPLParentLocSource		//上级Location来源
		s obj.DEPLParentLocID=eobj.DEPLParentLocID				//上级Location rowid
		s obj.DEPLDateFrom=eobj.DEPLDateFrom					//开始日期
		s obj.DEPLDateTo=eobj.DEPLDateTo						//结束日期
		TS
		s sc=obj.%Save()
		if (sc=1)
		{
			TC
			s id=obj.%Id()
			s result="{success:'true',id:'"_id_"'}"
			
			//推送ID到MDM
			s SyncHCPFlag=##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("SyncForHCP")
			if (SyncHCPFlag="Y"){
				d ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTDeptLinkOrg).SendCTDeptLinkOrg(id)
			}
			
			s DEPDesc=$lg($g(^User.CTDepartmentD(eobj.DEPLDeptDR)),4)		// 描述
			d:eobj.ID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_DepartmentLocation","User.CTDepartmentLocation","HIS-Location与HR-组织关联关系",eobj.ID,DEPDesc,"U",eobj,bobj)
			d:eobj.ID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_DepartmentLocation","User.CTDepartmentLocation","HIS-Location与HR-组织关联关系",id,DEPDesc,"A",eobj)
		}
		else
		{
			TRO
			s result="{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
		}
	}
	else
	{
		s result= "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

/// w ##class(web.DHCBL.CT.CTDepartmentLocation).savetest()
ClassMethod savetest()
{
	s eobj=##class(web.Entity.CT.CTDepartmentLocation).%New()
	s eobj.ID=""							//RowId
	s eobj.DEPLDeptDR=""					//HR组织部门表id
	s eobj.DEPLLocSource=""					//Location来源
	s eobj.DEPLLocID=""						//Location rowid
	s eobj.DEPLParentLocSource=""			//上级Location来源
	s eobj.DEPLParentLocID=""				//上级Location rowid
	s re=##class(web.DHCBL.CT.CTDepartmentLocation).SaveEntity(eobj)
	q re
}

/// Creator：基础数据平台-李可凡
/// CreatDate: 2020-07-26
/// Description：数据重复校验
/// Table：User.CTDepartmentLocation
/// Input:id,deptdr(组织部门DR),locsource(Location来源),loccode(Location代码)
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.DHCBL.CT.CTDepartmentLocation).FormValidate("","4","CT_Loc","1","")
ClassMethod FormValidate(id As %String, deptdr As %String, locsource As %String, locid As %String, loccode As %String) As %String
{
	s flag=0
	q:deptdr="" ""
	q:locsource="" ""
	q:(locid="")&&(loccode="") ""
	if (locid'="")	//CT_Loc表的数据
	{
		s ID=0
		for
		{
			s ID=$o(^User.CTDepartmentLocationI("DEPLDeptDR",deptdr,ID)) q:ID=""
			s DEPLLocSource=$lg($g(^User.CTDepartmentLocationD(ID)),3)		//Location来源
			s DEPLLocID=$lg($g(^User.CTDepartmentLocationD(ID)),4)			//Location rowid
			if (DEPLLocSource=locsource)&&(DEPLLocID=locid)	//组织、来源、LocationID都相同
			{
				s:ID'=id flag=1
			}
		}
	}
	else	//非CT_Loc表的数据用Location代码校验
	{
		s ID=0
		for
		{
			s ID=$o(^User.CTDepartmentLocationI("DEPLDeptDR",deptdr,ID)) q:ID=""
			s DEPLLocSource=$lg($g(^User.CTDepartmentLocationD(ID)),3)		//Location来源
			s DEPLLocCode=$lg($g(^User.CTDepartmentLocationD(ID)),5)		//Location代码
			if (DEPLLocSource=locsource)&&($$ALPHAUP^SSUTIL4(DEPLLocCode)=$$ALPHAUP^SSUTIL4(loccode))	//组织、来源、Location代码都相同
			{
				s:ID'=id flag=1
			}
		}
	}
	q flag
}

/// Creator：基础数据平台-李可凡
/// CreatDate: 2020-07-22
/// Description：删除数据
/// Table：User.CTDepartmentLocation
/// Others：w ##class(web.DHCBL.CT.CTDepartmentLocation).DeleteData(2)
ClassMethod DeleteData(id As %String) As %String
{
	s result=""
	if (id'="")
	{
		s obj=##class(User.CTDepartmentLocation).%OpenId(id)
		s pobj=##class(web.Entity.CT.CTDepartmentLocation).%New()
		s pobj.ID=id
		s:obj.DEPLDeptDR'="" pobj.DEPLDeptDR=obj.DEPLDeptDR.%Id()
		s pobj.DEPLLocSource=obj.DEPLLocSource
		s pobj.DEPLLocID=obj.DEPLLocID
		s pobj.DEPLLocCode=obj.DEPLLocCode
		s pobj.DEPLLocDesc=obj.DEPLLocDesc
		s pobj.DEPLParentLocSource=obj.DEPLParentLocSource
		s pobj.DEPLParentLocID=obj.DEPLParentLocID
		s pobj.DEPLParentLocCode=obj.DEPLParentLocCode
		s pobj.DEPLParentLocDesc=obj.DEPLParentLocDesc
		s pobj.DEPLDateFrom=obj.DEPLDateFrom
		s pobj.DEPLDateTo=obj.DEPLDateTo
		TS
		s sc=##class(User.CTDepartmentLocation).%DeleteId(id)
		if (sc=1)
		{
			TC
			s result="{success:'true',info:'删除成功！'}"
			s DEPDesc=$lg($g(^User.CTDepartmentD(pobj.DEPLDeptDR)),4)		// 描述
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_DepartmentLocation","User.CTDepartmentLocation","HIS-Location与HR-组织关联关系",id,DEPDesc,"D",pobj)
		}
		else
		{
			TRO
			s result="{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
		}
	}
	else
	{
		s result="{success:'false',info:'数据不存在！'}"
	}
	q result
}

/// Creator：基础数据平台-李可凡
/// CreatDate: 2020-07-23
/// Description：提供给上级Location来源下拉框
/// Input：desc
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTDepartmentLocation","GetSource","")
Query GetSource(desc) As %Query(ROWSPEC = "Source")
{
}

ClassMethod GetSourceExecute(ByRef qHandle As %Binary, desc) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
	s:desc'="" desc=$ZCONVERT(desc,"U")
	s SourceList("CT_Loc")=""
	s DEPLLocSource=""
	for
	{
		s DEPLLocSource=$o(^User.CTDepartmentLocationI("DEPLLocSource",DEPLLocSource))
		q:DEPLLocSource=""
		s SourceList(DEPLLocSource)=""
	}
	s Source=""
	for
	{
		s Source=$o(SourceList(Source)) q:Source=""
		d OutputSource
	}
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputSource
    set Data=$lb(Source)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetSourceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSourceExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetSourceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSourceExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    
    Set ind=$o(^CacheTemp(repid,ind))
    If ind=""
    {
        //if there are no more rows,finish fetching...
        Set AtEnd=1
        Set Row=""
    }
    Else
    {
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

/// Creator：基础数据平台-李可凡
/// CreatDate: 2020-07-23
/// Description：提供给上级Location下拉框
/// Input：desc
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTDepartmentLocation","GetParentLoc","")
Query GetParentLoc(desc) As %Query(ROWSPEC = "DEPLLocID,DEPLLocCode,DEPLLocDesc")
{
}

ClassMethod GetParentLocExecute(ByRef qHandle As %Binary, desc) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
	s:desc'="" desc=$ZCONVERT(desc,"U")
	s ID=""
	s LocationList=""
	for
	{
		s ID=$o(^User.CTDepartmentLocationD(ID)) q:ID=""
		s DEPLLocID=$lg($g(^User.CTDepartmentLocationD(ID)),4)		//Location rowid
		if (DEPLLocID'="")
		{
			s DEPLLocCode=$p($g(^CTLOC(DEPLLocID)),"^",1)
			s DEPLLocDesc=$p($g(^CTLOC(DEPLLocID)),"^",2)
			s CTLOCHospitalDR=$p($g(^CTLOC(DEPLLocID)),"^",22)     //医院DR
			s HOSPShortName=$p($g(^CT("HOSP",CTLOCHospitalDR)),"^",39)   //简称
			s HOSPDesc=$p($g(^CT("HOSP",CTLOCHospitalDR)),"^",2)	//描述
			if (HOSPShortName'="")
			{
				s DEPLLocDesc=DEPLLocDesc_"【"_HOSPShortName_"】"
			}
			else
			{
				s DEPLLocDesc=DEPLLocDesc_"【"_HOSPDesc_"】"
			}
			if ($d(LocationList(DEPLLocDesc))=0)
			{
				s LocationList(DEPLLocDesc)=""
				d OutputParentLoc
			}
		}
	}
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputParentLoc
    set Data=$lb(DEPLLocID,DEPLLocCode,DEPLLocDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetParentLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetParentLocExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetParentLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetParentLocExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    
    Set ind=$o(^CacheTemp(repid,ind))
    If ind=""
    {
        //if there are no more rows,finish fetching...
        Set AtEnd=1
        Set Row=""
    }
    Else
    {
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

}
