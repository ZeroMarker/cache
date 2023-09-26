Class web.DHCCLCareProv Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// w ##class(web.DHCCLCareProv).insert()
/// 
/// 科室^姓名^拼音^开始日期^结束日期^是否离开^是否医生^类型(进修/实习/学生/参观)
/// CLCP_CTLOC_Dr^CLCP_Desc^CLCP_Alias^CLCP_FromDate^CLCP_ToDate^CLCP_InActive^CLCP_IfDoctor^CLCP_Type
ClassMethod InsertCareProv(ctlocdr As %String, desc As %String, alias As %String, fdate As %String, tdate As %String, inActive As %String, ifDoc As %String, type As %String, hospital As %String) As %String
{
	q:ctlocdr="" "科室不能为空!"
	q:desc="" "姓名不能为空!"
	q:alias="" "拼音不能为空!"
	s ^LiTmpData("IhosId")=hospital
	s fdate=##Class(web.DHCANOPCom).ConvertToDateH(fdate)
	s tdate=##Class(web.DHCANOPCom).ConvertToDateH(tdate)
	s alias=$$ALPHAUP^SSUTIL4(alias)
	s ctcpRowId=$o(^CTPCP(0,"Decs",desc,""))
	s clcpRowId=$o(^DHCCLCPI("Desc",desc,""))
	i (ctcpRowId'="")!(clcpRowId'="") q "该用户已存在"
	&sql(insert into SQLUser.DHC_CL_CareProv (CLCP_CTLOC_Dr,CLCP_Desc,CLCP_Alias,CLCP_FromDate,CLCP_ToDate,CLCP_InActive,CLCP_IfDoctor,CLCP_Type,CLCP_Hospitsl_Dr) values(:ctlocdr,:desc,:alias,:fdate,:tdate,:inActive,:ifDoc,:type,:hospital))
	i SQLCODE'="0" q "插入失败!"
	q "0"
}

/// 
/// 
/// ctlocId,desc,alias,fromDate,toDate,inActive,ifDoctor,type
ClassMethod UpdateCareProv(clcpRowId As %String, ctlocdr As %String, desc As %String, alias As %String, fdate As %String, tdate As %String, inActive As %String = "", ifDoc As %String = "", type As %String = "", hospital As %String) As %String
{
    s ^LiTmpData("UhosId")=hospital
    s ^ztTmp=inActive_"^"_ifDoc
	q:clcpRowId="" "clcpRowId不能为空!"
	q:ctlocdr="" "科室不能为空!"
	q:desc="" "姓名不能为空!"
	q:alias="" "拼音不能为空!"
	s alias=$$ALPHAUP^SSUTIL4(alias)
	s fdate=##Class(web.DHCANOPCom).ConvertToDateH(fdate)
	s tdate=##Class(web.DHCANOPCom).ConvertToDateH(tdate)
	s ctcpRowId=$o(^CTPCP(0,"Decs",desc,""))
	i ctcpRowId'="" q "该用户已存在"
	&sql(update SQLUser.DHC_CL_CareProv set CLCP_CTLOC_Dr=:ctlocdr,CLCP_Desc=:desc,CLCP_Alias=:alias,CLCP_FromDate=:fdate,CLCP_ToDate=:tdate,CLCP_InActive=:inActive,CLCP_IfDoctor=:ifDoc,CLCP_Type=:type,CLCP_Hospitsl_Dr=:hospital where CLCP_RowId=:clcpRowId)
	i SQLCODE'="0" q "更新失败!"
	q "0"
}

ClassMethod DeleteCareProv(clcpRowId As %String)
{
	q:clcpRowId="" "clcpRowId不能为空!"
	
	&sql(delete from SQLUser.DHC_CL_CareProv where CLCP_RowId=:clcpRowId)
	
	i SQLCODE'="0" q "删除失败!"
	q "0"
}

/// d ##Class(%ResultSet).RunQuery("web.DHCCLCareProv","FindCareProv","","","","")
Query FindCareProv(descV As %String = "", aliasV As %String = "", ctlocId As %String = "", clcptype As %String, clcpifdoc As %String, clcpinActive As %String) As %Query(ROWSPEC = "clcpRowId:%String,ctlocdr:%String,ctlocdesc:%String,desc:%String,alias:%String,inActiveDes:%String,inActive:%String,ifDocDes:%String,ifDoc:%String,typeDes:%String,type:%String,fdate:%String,tdate:%String,hospital:%String,hospitalDr:%String")
{
}

ClassMethod FindCareProvExecute(ByRef qHandle As %Binary, descV As %String = "", aliasV As %String = "", ctlocId As %String = "", clcptype As %String = "", clcpifdoc As %String = "", clcpinActive As %String = "") As %Status
{
	s repid=$i(^CacheTemp)
 	s ind=1
 	 s dateformatnum=##class(websys.Conversions).DateFormat()
 	s ctlocdr=""
 	f  s ctlocdr=$o(^DHCCLCPI("CtLoc",ctlocdr)) q:ctlocdr=""  d
		.s clcpRowId=""
		.f  s clcpRowId=$o(^DHCCLCPI("CtLoc",ctlocdr,clcpRowId)) q:clcpRowId=""  d
		 	..s ctlocdesc=$p($g(^CTLOC(ctlocdr)),"^",2)
		 	..s desc=$li(^DHCCLCP(clcpRowId),2)
		 	..q:(descV'="")&($$ALPHAUP^SSUTIL4(desc)'[$$ALPHAUP^SSUTIL4(descV))
		 	..s alias=$li(^DHCCLCP(clcpRowId),3)
		 	..q:(aliasV'="")&($$ALPHAUP^SSUTIL4(alias)'[$$ALPHAUP^SSUTIL4(aliasV))
		 	..
		 	..s fdate=$zd($li(^DHCCLCP(clcpRowId),4),dateformatnum)
		 	..s tdate=$zd($li(^DHCCLCP(clcpRowId),5),dateformatnum)
		 	..s inActive=$li(^DHCCLCP(clcpRowId),6)
		 	..s inActiveDes=""
		 	..i inActive=0 s inActiveDes="否"
		 	..i inActive=1 s inActiveDes="是"
		 	..q:(clcpinActive'="")&(clcpinActive'=inActive)
		 	..s ifDoc=$li(^DHCCLCP(clcpRowId),7)
		 	..q:(clcpifdoc'="")&(clcpifdoc'=ifDoc)
		 	..s ifDocDes=""
		 	..i ifDoc=0 s ifDocDes="否"
		 	..i ifDoc=1 s ifDocDes="是"
		 	..s type=$li(^DHCCLCP(clcpRowId),8)
		    ..s typeId="",typeDes="" 
		    ..f  s typeId=$o(^DHCCLComCode("UserType",typeId)) q:typeId=""  d
			    ...i $p(^DHCCLComCode("UserType",typeId),"^",1)=type d
			    	....s typeDes=$p(^DHCCLComCode("UserType",typeId),"^",2)
		 	..q:(clcptype'="")&(clcptype'=type)
		 	..s hospitalDr = $li(^DHCCLCP(clcpRowId),9) //医院信息 20100906 liangq
		 	..s hospitalDesc = ""
		 	..i (hospitalDr '= "")&(hospitalDr'=0) s hospitalDesc = $list(^DHCCLC("Hospital",hospitalDr),2)
			..d OutCareProv
    s qHandle=$lb(0,repid,0)
	q $$$OK
OutCareProv
	s Data=$lb(clcpRowId,ctlocdr,ctlocdesc,desc,alias,inActiveDes,inActive,ifDocDes,ifDoc,typeDes,type,fdate,tdate,hospitalDesc,hospitalDr)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindCareProvFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCareProvExecute ]
{
	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {
 		s AtEnd=1
 		s Row=""
 	}
 	else {			
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindCareProvClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCareProvExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
    q $$$OK
}

Query LookUpCareProv(type) As %Query(ROWSPEC = "tCode:%String,tDesc:%String")
{
}

ClassMethod LookUpCareProvExecute(ByRef qHandle As %Binary, type) As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 	i type="" s type="UserType"
 	s codeId=0
 	f  s codeId=$o(^DHCCLComCode(type,codeId)) q:codeId=""  d
 		.s tCode=$p(^DHCCLComCode(type,codeId),"^",1)
 		.s tDesc=$p(^DHCCLComCode(type,codeId),"^",2)
 		.d OutputRow2
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
OutputRow2
	s Data=$lb(tCode,tDesc)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod LookUpCareProvFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpCareProvExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
	//
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {				// fetch row
 		s Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod LookUpCareProvClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpCareProvExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

Query FindHospital() As %Query(ROWSPEC = "ROWID:%String,HOSPDesc:%String")
{
}

ClassMethod FindHospitalExecute(ByRef qHandle As %Binary) As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1 
 	s codeId=0
 	f  s codeId=$o(^DHCCLC("Hospital",codeId)) q:codeId=""  d
 		.s tCode=$li(^DHCCLC("Hospital",codeId),1)
 		.s tDesc=$li(^DHCCLC("Hospital",codeId),2)
 		.d OutputRow3
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
OutputRow3
	s Data=$lb(codeId,tDesc)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindHospitalFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindHospitalExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
	//
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {				// fetch row
 		s Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindHospitalClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindHospitalExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

}
