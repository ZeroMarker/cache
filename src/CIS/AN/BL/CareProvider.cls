Import SQLUser

Class CIS.AN.BL.CareProvider Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// d ##Class(%ResultSet).RunQuery("CIS.AN.BL.CareProvider","FindCareProv","","","","","","")
Query FindCareProv(descV As %String = "", aliasV As %String = "", ctlocId As %String = "", clcptype As %String, clcpifdoc As %String, clcpinActive As %String) As %Query(ROWSPEC = "clcpRowId:%String,Code:%String,ctlocdr:%String,ctlocdesc:%String,desc:%String,alias:%String,inActiveDes:%String,inActive:%String,ifDocDes:%String,ifDoc:%String,typeDes:%String,type:%String,fdate:%String,tdate:%String,hospitalDesc:%String,hospitalDr:%String")
{
}

ClassMethod FindCareProvExecute(ByRef qHandle As %Binary, descV As %String = "", aliasV As %String = "", ctlocId As %String = "", clcptype As %String = "", clcpifdoc As %String = "", clcpinActive As %String = "") As %Status
{
	s repid=$i(^CacheTemp)
 	s ind=1
 	s provider=""
 	s ^tempzmy(1)=aliasV_"^"_aliasV_"^"_ctlocId_"^"_clcptype_"^"_clcpifdoc_"^"_clcpinActive
 	f  s provider=$o(^CF.AN.CareProviderD(provider)) q:provider=""  d
		.q:provider=""
		.s clcpRowId=provider
		.;b ;1
		.s ctlocdr=$p(..GetAllLoc(provider),"&",1)
		.q:((ctlocId'="")&&'(..CheckIsSameLoc(ctlocdr,ctlocId)))
		.s ctlocdesc=$p(..GetAllLoc(provider),"&",2)
		.s desc=$li(^CF.AN.CareProviderD(provider),1)
		.q:((descV'="")&&(descV'=desc))
		.s alias=$li(^CF.AN.CareProviderD(provider),2)
		.q:((aliasV'="")&&(aliasV'=alias))
		.s inActive=$li(^CF.AN.CareProviderD(provider),11)
		.q:((clcpinActive'="")&&(clcpinActive'=inActive))
		.i inActive="Y" s inActiveDes="是"
		.i inActive="N" s inActiveDes="否"
		.s ifDoc=$li(^CF.AN.CareProviderD(provider),12)
		.q:((clcpifdoc'="")&&(clcpifdoc'=ifDoc))
		.i ifDoc="Y" s ifDocDes="是"
		.i ifDoc="N" s ifDocDes="否"
		.s type=$li(^CF.AN.CareProviderD(provider),7)
		.q:((clcptype'="")&&(clcptype'=type))
		.s typeDes=""
		.s CodeResourceId=$o(^CF.AN.ResourceI("ICareProv",provider,""))
		.s Code=$li(^CF.AN.ResourceD(CodeResourceId),1)
		.s:type=1 typeDes="院外专家"
		.s:type=2 typeDes="实习"
		.s fdate=$li(^CF.AN.CareProviderD(provider),8)
		.i fdate'="" s fdate=$zd(fdate,3)
		.s tdate=$li(^CF.AN.CareProviderD(provider),9)
		.i tdate'="" s tdate=$zd(tdate,3)
		.s hospitalDesc=""
		.s:provider>3 hospitalDesc=$li(^CF.AN.CareProviderD(provider),18)
		.d OutCareProv
    s qHandle=$lb(0,repid,0)
	q $$$OK
OutCareProv
	s Data=$lb(clcpRowId,Code,ctlocdr,ctlocdesc,desc,alias,inActiveDes,inActive,ifDocDes,ifDoc,typeDes,type,fdate,tdate,hospitalDesc,hospitalDr)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod DeleteCareProv(clcpRowId As %String)
{
	q:clcpRowId="" "clcpRowId不能为空!"
	
	&sql(delete from CF_AN.CareProvider where RowId=:clcpRowId)
	
	i SQLCODE'="0" q "删除失败!"
	&sql(delete from CF_AN.Resource  where CareProvider=:clcpRowId)
	
	q "0"
}

/// 
/// 
/// w ##class(CIS.AN.BL.CareProvider).UpdateCareProv("9","yt6","2","kok","NJJNJN","2020-05-14","2020-05-25","N","Y","1","2333")
/// 
ClassMethod UpdateCareProv(clcpRowId As %String, Code As %String, ctlocdr As %String, desc As %String, alias As %String, fdate As %String, tdate As %String, inActive As %String = "", ifDoc As %String = "", type As %String = "", hospital As %String) As %String
{
    s ^tempzmy(12)=clcpRowId_"^"_Code_"^"_ctlocdr_"^"_desc_"^"_alias_"^"_fdate_"^"_tdate_"^"_inActive_"^"_ifDoc_"^"_type_"^"_hospital
	q:clcpRowId="" "请选择一行"
	q:ctlocdr="" "科室不能为空!"
	q:desc="" "姓名不能为空!"
	q:alias="" "拼音不能为空!"
	s ^LiTmpData("IhosId")=hospital
	s fdate=##Class(web.DHCANOPCom).ConvertToDateH(fdate)
	s:tdate'="" tdate=##Class(web.DHCANOPCom).ConvertToDateH(tdate)
	s alias=$$ALPHAUP^SSUTIL4(alias)
	//s ctcpRowId=$o(^CTPCP(0,"Decs",desc,""))
	//s clcpRowId=$o(^DHCCLCPI("Desc",desc,""))
	//i (ctcpRowId'="")!(clcpRowId'="") q "该用户已存在"
	//&sql(insert into SQLUser.DHC_CL_CareProv (CLCP_CTLOC_Dr,CLCP_Desc,CLCP_Alias,CLCP_InActive,CLCP_IfDoctor,CLCP_Type,CLCP_Hospitsl_Dr) values(:ctlocdr,:desc,:alias,:inActive,:ifDoc,:type,:hospital))
	//b ;;1
	//s qqq=%ROWID
	//&sql(insert into CF_AN.CareProvider (FullName,Alias,CareProvType,Active,Surgeon,Code) values('wwww','WWWW','2','1','1','wwww'))
	&sql(update  CF_AN.CareProvider set FullName=:desc,Alias=:alias,CareProvType=:type,Active=:inActive,Surgeon=:ifDoc, Code=:code ,Hospital=:hospital where RowId=:clcpRowId)
	s CareProviderId=clcpRowId
	//b
	s $li(^CF.AN.CareProviderD(CareProviderId),8)=fdate
	s $li(^CF.AN.CareProviderD(CareProviderId),9)=tdate
	b
	&sql(update  CF_AN.Resource  set Code=:Code,Description=:desc,Dept=:ctlocdr,Active=:inActive where CareProvider=:CareProviderId)
	s ResourceId=%ROWID
	s $li(^CF.AN.ResourceD(ResourceId),5)=fdate
	s $li(^CF.AN.ResourceD(ResourceId),6)=tdate
	i SQLCODE'="0" q "插入失败!"
	
	q "0"
}

ClassMethod CheckIsSameLoc(ctlocdstr, ctlocId)
{
	s Itemnum=$l(ctlocdstr,"^")
	s i=0,tag=0
	f  s i=i+1 q:i>Itemnum  d
	  .i ctlocId=$p(ctlocdstr,"^",i) s tag=1
	q tag
}

/// w ##class(CIS.AN.BL.CareProvider).GetAllLoc(1)
ClassMethod GetAllLoc(CareProvider)
{
 s ResourceId="",LocIdStr="",LocDescStr=""
  f  s ResourceId=$o(^CF.AN.ResourceI("ICareProv",CareProvider,ResourceId)) Q:ResourceId=""  d
     .;q:$li(^CF.AN.ResourceD(ResourceId),7)'="Y"
     .;B ;3
     .i LocIdStr="" s LocIdStr=$li(^CF.AN.ResourceD(ResourceId),3),LocDescStr=$P($g(^CTLOC($li(^CF.AN.ResourceD(ResourceId),3))),"^",2)
     .e  s LocIdStr=LocIdStr_"^"_$li(^CF.AN.ResourceD(ResourceId),3),LocDescStr=LocDescStr_"；"_$P($g(^CTLOC($li(^CF.AN.ResourceD(ResourceId),3))),"^",2)
 
   q LocIdStr_"&"_LocDescStr
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
 	s CareProvType(1)="ywzj^院外专家"
 	s CareProvType(2)="sx^实习"
 	f  s codeId=$o(CareProvType(codeId)) q:codeId=""  d
 		.s tCode=codeId
 		.s tDesc=$p(CareProvType(codeId),"^",2)
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

/// w ##class(CIS.AN.BL.CareProvider).InsertCareProv("www","1","www","www","2020-02-23","","Y","Y","7","13")
/// 
/// 科室^姓名^拼音^开始日期^结束日期^是否离开^是否医生^类型(进修/实习/学生/参观)
/// CLCP_CTLOC_Dr^CLCP_Desc^CLCP_Alias^CLCP_FromDate^CLCP_ToDate^CLCP_InActive^CLCP_IfDoctor^CLCP_Type
ClassMethod InsertCareProv(Code As %String, ctlocdr As %String, desc As %String, alias As %String, fdate As %String, tdate As %String, inActive As %String, ifDoc As %String, type As %String, hospital As %String) As %String
{
	s ^tempzmy(13)=Code_"^"_ctlocdr_"^"_desc_"^"_alias_"^"_fdate_"^"_tdate_"^"_inActive_"^"_ifDoc_"^"_type_"^"_hospital
	q:ctlocdr="" "科室不能为空!"
	q:desc="" "姓名不能为空!"
	q:alias="" "拼音不能为空!"
	s ^LiTmpData("IhosId")=hospital
	s fdate=##Class(web.DHCANOPCom).ConvertToDateH(fdate)
	s:tdate'="" tdate=##Class(web.DHCANOPCom).ConvertToDateH(tdate)
	s alias=$$ALPHAUP^SSUTIL4(alias)
	//s ctcpRowId=$o(^CTPCP(0,"Decs",desc,""))
	//s clcpRowId=$o(^DHCCLCPI("Desc",desc,""))
	//i (ctcpRowId'="")!(clcpRowId'="") q "该用户已存在"
	//&sql(insert into SQLUser.DHC_CL_CareProv (CLCP_CTLOC_Dr,CLCP_Desc,CLCP_Alias,CLCP_InActive,CLCP_IfDoctor,CLCP_Type,CLCP_Hospitsl_Dr) values(:ctlocdr,:desc,:alias,:inActive,:ifDoc,:type,:hospital))
	//b ;;1
	//s qqq=%ROWID
	//&sql(insert into CF_AN.CareProvider (FullName,Alias,CareProvType,Active,Surgeon,Code) values('wwww','WWWW','2','1','1','wwww'))
	&sql(insert into CF_AN.CareProvider (FullName,Alias,CareProvType,Active,Surgeon,Code,Hospital) values(:desc,:alias,:type,:inActive,:ifDoc,:code,:hospital))
	s CareProviderId=%ROWID
	b
	s $li(^CF.AN.CareProviderD(CareProviderId),8)=fdate
	s $li(^CF.AN.CareProviderD(CareProviderId),9)=tdate
	b
	&sql(insert into CF_AN.Resource (Code,Description,Dept,CareProvider,Active) values(:Code,:desc,:ctlocdr,:CareProviderId,:inActive))
	s ResourceId=%ROWID
	s $li(^CF.AN.ResourceD(ResourceId),5)=fdate
	s $li(^CF.AN.ResourceD(ResourceId),6)=tdate
	i SQLCODE'="0" q "插入失败!"
	
	q "0"
}

ClassMethod SaveCareProv(jsonData As %DynamicObject, updateUserID As %String) As %String
{
	set $zt="Error"
  //set jsonData=##class(%DynamicObject).%FromJSON(jsonStr)
  set careProv=""
  if (##class(CF.AN.CareProvider).%ExistsId(jsonData.RowId))
  {
    set careProv=##class(CF.AN.CareProvider).%OpenId(jsonData.RowId)
  }
  else
  {
    set careProv=##class(CF.AN.CareProvider).%New()
  }
  set careProv.Code=jsonData.Code
  set careProv.FullName=jsonData.FullName
  set careProv.Alias=jsonData.Alias
  set careProv.MobileNo=jsonData.MobileNo
  set careProv.Dept=jsonData.Dept
  set careProv.Hospital=jsonData.Hospital
  set careProv.Active="Y"
  set activeDateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(jsonData.ActiveDate,"")
  set:(activeDateH>0) careProv.ActiveDate=activeDateH
  set expireDateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(jsonData.ExpireDate,"")
  set:(expireDateH>0) careProv.ExpireDate=expireDateH
  
  set sc=careProv.%Save()
  quit:($SYSTEM.Status.IsError(sc)) "E^"_$SYSTEM.Status.GetErrorText(sc)
  quit "S^"_careProv.%Id()
Error
  quit "E^"_$ze
}

ClassMethod DelCareProv(dataRowId As %String, updateUserID As %String) As %String
{
  set $zt="Error"
  set sc=##class(CF.AN.CareProvider).%DeleteId(dataRowId)
  quit:($SYSTEM.Status.IsError(sc)) "E^"_$SYSTEM.Status.GetErrorText(sc)
  quit "S^"
Error
  quit "E^"_$ze
}

}
