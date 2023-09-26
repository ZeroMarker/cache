/// Creator:wangpf
/// Desctiptions:专科护士方法类
/// Date:2020-07-20
Class web.INMSpecialComm Extends %RegisteredObject
{

/// Description: 获取人员层级、状态、职务、当前病区
/// Date: 2020-06-20
/// Creator: wangpf
/// Table: CF.DHCINM.HR.Persons
/// Input: id
/// Output: 护士信息
/// Other: w ##class(web.INMSpecialComm).GetNurseInfo(1)
ClassMethod GetNurseInfo(id As %String = "") As %String
{
	q:(id="")||('$d(^CF.DHCINM.HR.PersonsD(id))) ""
	
	s perGlo=^CF.DHCINM.HR.PersonsD(id)
	s perName=$lg(perGlo,2)
	s perLevel=$p(##class(web.INMHRComm).GetNurseLevel(id,+$h),"^",2)
	s perPost=$p(##class(web.INMHRComm).GetNurseDuty(id,+$h),"^",2)
	s perHire=$p(##class(web.INMHRComm).GetNurseHireDuty(id,+$h),"^",2)
	s perCurWard=$lg(perGlo,10)
	s perCurWardDesc=""
	i (perCurWard'="") d
	.s wardGlo=$g(^CF.DHCINM.DB.MgWardD(perCurWard))
	.s perCurWardDesc=$lg(wardGlo,4)
	s perStatus=$lg(perGlo,42)
	s perStatusDesc=""
	i (perStatus'="") d
	.s statusPar=$p(perStatus,"||")
	.s statusSub=$p(perStatus,"||",2)
	.s codeGlo=$g(^CT.DHCINM.DB.MgSetCodeSubD(statusPar,statusSub))
	.s perStatusDesc=$lg(codeGlo,3)
	s ret="Per|"_id_"^PerName|"_perName_"^PerLevel|"_perLevel_"^PerPost|"_perPost_"^PerHire|"_perHire_"^PerCurWard|"_perCurWardDesc_"^PerStatus|"_perStatusDesc
	q ret
}

/// Description: 保存专科护士
/// Date: 2020-07-20
/// Creator: wangpf
/// Table: DHCINM.Special.SpecialNurse
/// Input: parr userid
/// Output: 0：失败 >=1：成功
/// Other: w ##class(web.INMSpecialComm).SaveSpecial("",0)
ClassMethod SaveSpecial(parr As %String = "", nurseid As %String = "") As %String
{
	q:(parr="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	
	s per=$p(parr,"^")
	q:'$d(^CF.DHCINM.HR.PersonsD(per))
	s nurType=$p(parr,"^",2)
	s nurTypePar=$p(nurType,"||")
	s nurTypeSub=$p(nurType,"||",2)
	q:(nurType="")||'$d(^CT.DHCINM.DB.MgSetCodeSubD(nurTypePar,nurTypeSub)) 0
	s type=$p(parr,"^",3)
	s typePar=$p(type,"||")
	s typeSub=$p(type,"||",2)
	q:(type="")||'$d(^CT.DHCINM.DB.MgSetCodeSubD(typePar,typeSub)) 0
	s auth=$p(parr,"^",4)
	s authPar=$p(auth,"||")
	s authSub=$p(auth,"||",2)
	q:(auth="")||'$d(^CT.DHCINM.DB.MgSetCodeSubD(authPar,authSub)) 0
	s date=$p(parr,"^",5)
	s:date'="" date=$zdh(date,3)
	s status=$p(parr,"^",6)
	s rw=$p(parr,"^",7)
	
	i rw="" d
	.s obj=##class(DHCINM.Special.SpecialNurse).%New()
	.s obj.Creator=nurseid
	e  s obj=##class(DHCINM.Special.SpecialNurse).%OpenId(rw)
	q:'$IsObject(obj) 0
	d obj.SpecialPerSetObjectId(per)
	d obj.SpecialNurTypeSetObjectId(nurType)
	d obj.SpecialTypeSetObjectId(type)
	d obj.SpecialAuthSetObjectId(auth)
	s obj.SpecialAuthDate=date
	s obj.SpecialStatus=status
	s sc=obj.%Save()
	i $$$ISOK(sc) q obj.%Id()
	e  q 0
}

/// Description: 保存专科护士文件
/// Date: 2020-08-17
/// Creator: wangpf
/// Table: DHCINM.Special.SpecialNurse
/// Input: id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMSpecialComm).SaveSpecialNurFile(3,"D:/dhcinm/SpecialActivity/3/安贞需求补.txt")
ClassMethod SaveSpecialNurFile(id As %String = "", name As %String = "") As %String
{
	q:(id="")||(name="") 0
	
	s obj=##class(DHCINM.Special.SpecialNurse).%OpenId(id)
	q:'$IsObject(obj) 0
	i obj.SpecialCertificate="" s obj.SpecialCertificate=name
	e  s obj.SpecialCertificate=obj.SpecialCertificate_"」"_name
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Description: 删除专科护士文件
/// Date: 2020-08-17
/// Creator: wangpf
/// Table: DHCINM.Special.SpecialNurse
/// Input: id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMSpecialComm).DeleteSpecialNurFile(3,"D:/dhcinm/SpecialActivity/3/安贞需求补.txt",0)
ClassMethod DeleteSpecialNurFile(id As %String = "", name As %String = "", nurseid As %String = "") As %String
{
	q:(id="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	
	s obj=##class(DHCINM.Special.SpecialNurse).%OpenId(id)
	q:'$IsObject(obj) 0
	q:(nurseid'=0)&&(obj.Creator'=nurseid) 0
	s fileList=$lfs(obj.SpecialCertificate,"」")
	s exist=0,index=0
	s ptr=0 f  s status=$listnext(fileList,ptr,file) q:(status'=1)||(exist'=0)  d
	.s:file=name exist=1
	.s index=index+1
	q:exist=0 0
	s fileLength=$l(obj.SpecialCertificate,"」")
	s tmpFile=""
	f i=1:1:fileLength d
	.q:i=index
	.i tmpFile="" s tmpFile=$lg(fileList,i)
	.e  s tmpFile=tmpFile_"」"_$lg(fileList,i)
	s obj.SpecialCertificate=tmpFile
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Description: 获取专科护士
/// Date: 2020-07-20
/// Creator: wangpf
/// Table: DHCINM.Special.SpecialNurse
/// Input: id
/// Output: 专科护士
/// Other: w ##class(web.INMSpecialComm).GetSpecial(1)
ClassMethod GetSpecial(id As %String = "") As %String
{
	q:(id="")||('$d(^DHCINM.Special.SpecialNurseD(id))) ""
	
	s speGlo=^DHCINM.Special.SpecialNurseD(id)
	
	s spePer=$lg(speGlo,2)
	s spePerName=""
	i spePer'="" d
	.s perGlo=$g(^CF.DHCINM.HR.PersonsD(spePer))
	.s spePerName=$lg(perGlo,2)
	s speType=$lg(speGlo,3)
	s speTypeDesc=""
	i speType'="" d
	.s typePar=$p(speType,"||")
	.s typeSub=$p(speType,"||",2)
	.s typeGlo=$g(^CT.DHCINM.DB.MgSetCodeSubD(typePar,typeSub))
	.s speTypeDesc=$lg(typeGlo,3)
	s speAuth=$lg(speGlo,4)
	s speAuthDesc=""
	i speAuth'="" d
	.s authPar=$p(speAuth,"||")
	.s authSub=$p(speAuth,"||",2)
	.s authGlo=$g(^CT.DHCINM.DB.MgSetCodeSubD(authPar,authSub))
	.s speAuthDesc=$lg(authGlo,3)
	s speAuthDate=$lg(speGlo,5)
	s:speAuthDate'="" speAuthDate=$zd(speAuthDate,3)
	s speCertificate=$lg(speGlo,6)
	s speStatus=$lg(speGlo,7)
	s speStatusDesc=$case(speStatus,"Y":"提交","A":"审核","B":"驳回",:"")
	s creator=$lg(speGlo,8)
	s creatorName=""
	i creator=0 s creatorName="管理员"
	e  i creator'="" d
	.s perGlo=$g(^CF.DHCINM.DB.MgUserD(creator))
	.s creatorName=$lg(perGlo,2)
	s createDate=$lg(speGlo,9)
	s:createDate'="" createDate=$zd(createDate,3)
	s createTime=$lg(speGlo,10)
	s:createTime'="" createTime=$zt(createTime,1)
	s auditor=$lg(speGlo,11)
	s auditorName=""
	i auditor=0 s auditorName="管理员"
	e  i auditor'="" d
	.s perGlo=$g(^CF.DHCINM.DB.MgUserD(auditor))
	.s auditorName=$lg(perGlo,2)
	s auditDate=$lg(speGlo,12)
	s:auditDate'="" auditDate=$zd(auditDate,3)
	s auditTime=$lg(speGlo,13)
	s:auditTime'="" auditTime=$zt(auditTime,1)
	s auditOpinion=$lg(speGlo,14)
	s speNurType=$lg(speGlo,15)
	s speNurTypeDesc=""
	i speNurType'="" d
	.s speNurTypePar=$p(speNurType,"||")
	.s speNurTypeSub=$p(speNurType,"||",2)
	.s authGlo=$g(^CT.DHCINM.DB.MgSetCodeSubD(speNurTypePar,speNurTypeSub))
	.s speNurTypeDesc=$lg(authGlo,3)
	s ret="SpecialPer|"_spePer_"^SpecialPerName|"_spePerName_"^SpecialType|"_$tr(speType,"|","_")_"^SpecialTypeDesc|"_speTypeDesc_"^SpecialAuth|"_$tr(speAuth,"|","_")
	s ret=ret_"^SpecialAuthDesc|"_speAuthDesc_"^SpecialAuthDate|"_speAuthDate_"^SpecialCertificate|"_speCertificate_"^SpecialStatus|"_speStatus
	s ret=ret_"^SpecialStatusDesc|"_speStatusDesc_"^Creator|"_creator_"^CreatorName|"_creatorName_"^CreateDate|"_createDate_"^CreateTime|"_createTime
	s ret=ret_"^Auditor|"_auditor_"^AuditorName|"_auditorName_"^AuditDate|"_auditDate_"^AuditTime|"_auditTime_"^AuditOpinion|"_auditOpinion
	s ret=ret_"^SpecialNurType|"_$tr(speNurType,"|","_")_"^SpecialNurTypeDesc|"_speNurTypeDesc_"^rw|"_id
	q ret
}

/// Description：获取专科护士列表
/// Date:2020-07-20
/// Creator:wangpf
/// Table:DHCINM.Special.SpecialNurse
/// Input: 病区Id^姓名^类型^认证单位^状态 登录人Id
/// Output:专科护士列表
/// Other:d ##class(%ResultSet).RunQuery("web.INMSpecialComm","FindSpecialList","^^^^^^2",0)
Query FindSpecialList(parr As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindSpecialListExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i nurseid="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	s ward=$p(parr,"^")
	s name=$p(parr,"^",2)
	s type=$p(parr,"^",3)
	s auth=$p(parr,"^",4)
	s status=$p(parr,"^",5)
	s year=$p(parr,"^",6)
	/// 增加一列传入人员档案Id
	s perRowId=$P(parr,"^",7)
	
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	
	s id="" f  s id=$o(^DHCINM.Special.SpecialNurseD(id)) q:id=""  d
	.s speGlo=^DHCINM.Special.SpecialNurseD(id)
	.s spePer=$lg(speGlo,2)
	.s perGlo=$g(^CF.DHCINM.HR.PersonsD(spePer))
	.s perName=$lg(perGlo,2)
	.s perID=$lg(perGlo,3)
	.q:(name'="")&&(perName_perID'[name)
	.s perCurWard=$lg(perGlo,10)
	.q:((ward'="")&&(ward'=perCurWard))||((isAll'=1)&&('$d(tmpWard(perCurWard))))
	.s speType=$lg(speGlo,3)
	.q:(type'="")&&(type'=speType)
	.s speAuth=$lg(speGlo,4)
	.q:(auth'="")&&(auth'=speAuth)
	.s speDate=$lg(speGlo,5)
	.q:(year'="")&&((speDate="")||(year'=+$zd(speDate,3)))
	.q:(auth'="")&&(auth'=speAuth)
	.s speStatus=$lg(speGlo,7)
	.q:(status'="")&&(status'=speStatus)
	.q:(perRowId'="")&&(perRowId'=spePer)
	.s ret=..GetSpecial(id)
	.s ret=ret_"^"_..GetNurseInfo(spePer)
	.d:ret'="" OutSpecialList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutSpecialList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindSpecialListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindSpecialListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindSpecialListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindSpecialListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Description：获取去重专科护士列表
/// Date:2020-07-20
/// Creator:wangpf
/// Table:DHCINM.Special.SpecialNurse
/// Input: 病区Id^姓名^类型^认证单位^状态 登录人Id
/// Output:去重专科护士列表
/// Other:d ##class(%ResultSet).RunQuery("web.INMSpecialComm","FindSingleSpecialList","1^^^^",0)
Query FindSingleSpecialList(parr As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindSingleSpecialListExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i nurseid="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	s ward=$p(parr,"^")
	s name=$p(parr,"^",2)
	s type=$p(parr,"^",3)
	s auth=$p(parr,"^",4)
	s status=$p(parr,"^",5)
	
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	
	k tmp
	s id="" f  s id=$o(^DHCINM.Special.SpecialNurseD(id)) q:id=""  d
	.s speGlo=^DHCINM.Special.SpecialNurseD(id)
	.s spePer=$lg(speGlo,2)
	.s perGlo=$g(^CF.DHCINM.HR.PersonsD(spePer))
	.q:perGlo=""
	.s perStatus=##class(web.INMPersonComm).GetCommCode($lg(perGlo,42))
	.q:(perStatus'="在职") ;过滤掉离职/退休
	.s perName=$lg(perGlo,2)
	.s perID=$lg(perGlo,3)
	.q:(name'="")&&(perName_perID'[name)
	.s perCurWard=$lg(perGlo,10)
	.q:((ward'="")&&(ward'=perCurWard))&&((isAll'=1)&&('$d(tmpWard(perCurWard))))
	.s speType=$lg(speGlo,3)
	.q:(type'="")&&(type'=speType)
	.s speAuth=$lg(speGlo,4)
	.q:(auth'="")&&(auth'=speAuth)
	.s speStatus=$lg(speGlo,7)
	.q:(status'="")&&(status'=speStatus)
	.s tmp(spePer)="Per|"_spePer_"^PerName|"_perName
	
	s id="" f  s id=$o(tmp(id)) q:id=""  d
	.s ret=tmp(id)
	.d OutSpecialList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutSpecialList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindSingleSpecialListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindSingleSpecialListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindSingleSpecialListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindSingleSpecialListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Description：获取某人所有专科护士列表
/// Date:2020-07-20
/// Creator:wangpf
/// Table:DHCINM.Special.SpecialNurse
/// Input: perId date
/// Output:某人专科护士列表
/// Other:d ##class(%ResultSet).RunQuery("web.INMSpecialComm","FindPerSpecial","1","2020-07-20")
Query FindPerSpecial(per As %String = "", date As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindPerSpecialExecute(ByRef qHandle As %Binary, per As %String = "", date As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i per="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s:date["-" date=$zdh(date,3)
	
	s id="" f  s id=$o(^DHCINM.Special.SpecialNurseI("Person",per,id)) q:id=""  d
	.q:'$d(^DHCINM.Special.SpecialNurseD(id))
	.s speGlo=^DHCINM.Special.SpecialNurseD(id)
	.s speStatus=$lg(speGlo,7)
	.q:speStatus'="A"
	.s speAuthDate=$lg(speGlo,5)
	.q:(date'="")&&((speAuthDate="")||(date<speAuthDate))
	.s spePer=$lg(speGlo,2)
	.s spePerName=""
	.i spePer'="" d
	..s perGlo=$g(^CF.DHCINM.HR.PersonsD(spePer))
	..s spePerName=$lg(perGlo,2)
	.s speType=$lg(speGlo,3)
	.s speTypeDesc=""
	.i speType'="" d
	..s typePar=$p(speType,"||")
	..s typeSub=$p(speType,"||",2)
	..s typeGlo=$g(^CT.DHCINM.DB.MgSetCodeSubD(typePar,typeSub))
	..s speTypeDesc=$lg(typeGlo,3)
	.s ret="SpecialPer|"_spePer_"^SpecialPerName|"_spePerName_"^SpecialType|"_$tr(speType,"|","_")_"^SpecialTypeDesc|"_speTypeDesc_"^rw|"_id
	.d OutSpecialList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutSpecialList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindPerSpecialClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPerSpecialExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindPerSpecialFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPerSpecialExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Description: 审核专科护士
/// Date: 2020-07-20
/// Creator: wangpf
/// Table: DHCINM.Special.SpecialNurse
/// Input: 状态^意见^id userId
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMSpecialComm).AuditSpecial(1)
ClassMethod AuditSpecial(parr As %String = "", nurseid As %String = "") As %String
{
	q:(parr="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	
	s status=$p(parr,"^")
	s opinion=$p(parr,"^",2)
	s rw=$p(parr,"^",3)
	q:(rw="")||('$d(^DHCINM.Special.SpecialNurseD(rw))) 0
	
	s obj=##class(DHCINM.Special.SpecialNurse).%OpenId(rw)
	q:'$IsObject(obj) 0
	s obj.SpecialStatus=status
	s obj.Auditor=nurseid
	s now=$h
	s obj.AuditDate=+now
	s obj.AuditTime=$p(now,",",2)
	s obj.AuditOpinion=opinion
	s sc=obj.%Save()
	try{
		i (($$$ISOK(sc))&&((obj.SpecialStatus="A")||(obj.SpecialStatus="B"))) d
		.s SpecialStatus=$case(obj.SpecialStatus,"A":"审核","B":"驳回")
		.s SpecialAuthDesc=obj.SpecialAuth.SubDesc
		.s SpecialPerId=$lg($g(^DHCINM.Special.SpecialNurseD(rw)),2)
		.s PerId=$lg($g(^CF.DHCINM.HR.PersonsD(SpecialPerId)),3)
		.s SpicalName=obj.SpecialPer.PerName
		.s SpecialTypeDesc=obj.SpecialType.SubDesc
		.s SpecialNurTypeDesc=obj.SpecialNurType.SubDesc
		.s SpecialAuthDate=$lg($g(^DHCINM.Special.SpecialNurseD(rw)),5)
		.s:SpecialAuthDate'="" SpecialAuthDate=$zd(SpecialAuthDate,3)
		.s Creator=$lg($g(^DHCINM.Special.SpecialNurseD(rw)),8)
		.s ret="【护士档案/专科发展(专业组/专科护士备案)】"_SpecialStatus_" "_SpicalName_" "_PerId_" "_" "_SpecialAuthDesc_" "_SpecialTypeDesc_" "_SpecialNurTypeDesc _" "_SpecialAuthDate
		.d ##class(web.INMPlatform).SaveTrackMessage(Creator,+$H,ret,"","DHCINM.Special.SpecialNurse",rw)
	}catch{
		}

	q $$$ISOK(sc)
}

/// Description: 删除专科护士
/// Date: 2020-07-20
/// Creator: wangpf
/// Table: DHCINM.Special.SpecialNurse
/// Input: id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMSpecialComm).DeleteSpecial(1)
ClassMethod DeleteSpecial(id As %String = "") As %String
{
	q:id="" 0
	s sc=##class(DHCINM.Special.SpecialNurse).%DeleteId(id)
	q $$$ISOK(sc)
}

/// Description：获取专业组列表
/// Date:2020-07-20
/// Creator:wangpf
/// Table:CT.DHCINM.DB.MgSetCodeSub
/// Input: SetCodeDesc
/// Output:专业组列表
/// Other:d ##class(%ResultSet).RunQuery("web.INMSpecialComm","FindMeteriallList",0)
Query FindMeteriallList(nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindMeteriallListExecute(ByRef qHandle As %Binary, nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i (nurseid="")||((nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid)))) Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	s isOverHLB=..IsPerOverHLB(nurseid)
	
	i isOverHLB'=1 d
	.s userGlo=^CF.DHCINM.DB.MgUserD(nurseid)
	.s perId=$lg(userGlo,5)
	i (isOverHLB'=1)&&(perId="") Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	s parId=$o(^CT.DHCINM.DB.MgSetCodeI("Code"," 专业组",""))
	i parId="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s subId="" f  s subId=$o(^CT.DHCINM.DB.MgSetCodeSubD(parId,subId)) q:subId=""  d
	.q:(isOverHLB'=1)&&('$d(^DHCINM.Special.SpecialMemberI("Per",perId,parId_"||"_subId)))
	.s subGlo=^CT.DHCINM.DB.MgSetCodeSubD(parId,subId)
	.s subCode=$lg(subGlo,2)
	.s subDesc=$lg(subGlo,3)
	.s stDate=$lg(subGlo,5)
	.s endDate=$lg(subGlo,6)
	.s now=+$h
	.i (stDate>now)||((endDate'="")&&(endDate<now)) s status="N",statusDesc="停用"
	.e  s status="Y",statusDesc="启用"
	.s ret="SubDesc|"_subCode_"^SubDesc|"_subDesc_"^SubStatus|"_status_"^SubStatusDesc|"_statusDesc_"^SubValue|"_parId_"__"_subId
	.d OutMeterialList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutMeterialList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindMeteriallListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindMeteriallListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindMeteriallListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindMeteriallListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Description: 保存专业组成员
/// Date: 2020-07-20
/// Creator: wangpf
/// Table: DHCINM.Special.SpecialMember
/// Input: parr userid
/// Output: -1:重复 0：失败 1：成功
/// Other: w ##class(web.INMSpecialComm).SaveMember("52__1^4^^2021-03-30^^^",0)
ClassMethod SaveMember(parr As %String = "", nurseid As %String = "") As %String
{
	q:(parr="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	
	s group=$tr($p(parr,"^"),"_","|")
	s groupPar=$p(group,"||")
	s groupSub=$p(group,"||",2)
	q:(group="")||'$d(^CT.DHCINM.DB.MgSetCodeSubD(groupPar,groupSub)) 0
	s per=$p(parr,"^",2)
	q:'$d(^CF.DHCINM.HR.PersonsD(per))
	s post=$tr($p(parr,"^",3),"_","|")
	s postPar=$p(post,"||")
	s postSub=$p(post,"||",2)
	q:(post="")||'$d(^CT.DHCINM.DB.MgSetCodeSubD(postPar,postSub)) 0
	s stDate=$p(parr,"^",4)
	s:stDate'="" stDate=$zdh(stDate,3)
	s endDate=$p(parr,"^",5)
	s:endDate'="" endDate=$zdh(endDate,3)
	s remark=$p(parr,"^",6)
	s rw=$p(parr,"^",7)
	
	s id=$o(^DHCINM.Special.SpecialMemberI("Per",per,group,""))
	q:(id'="")&&(id'=rw) -1
	
	i rw="" s obj=##class(DHCINM.Special.SpecialMember).%New()
	e  s obj=##class(DHCINM.Special.SpecialMember).%OpenId(rw)
	q:'$IsObject(obj) 0
	d obj.MemberPerSetObjectId(per)
	d obj.MemberGroupSetObjectId(group)
	s obj.MemberPost=post
	s obj.MemberStDate=stDate
	s obj.MemberEndDate=endDate
	s obj.MemberRemark=remark
	s sc=$$$ISOK(obj.%Save())
	b ;001
	q sc
}

/// Description: 获取专业组成员
/// Date: 2020-07-20
/// Creator: wangpf
/// Table: DHCINM.Special.SpecialMember
/// Input: id
/// Output: 专业组成员
/// Other: w ##class(web.INMSpecialComm).GetMember(1)
ClassMethod GetMember(id As %String = "") As %String
{
	q:(id="")||('$d(^DHCINM.Special.SpecialMemberD(id))) ""
	
	s memGlo=^DHCINM.Special.SpecialMemberD(id)
	s memPer=$lg(memGlo,2)
	s memPerName=""
	i memPer'="" d
	.s perGlo=$g(^CF.DHCINM.HR.PersonsD(memPer))
	.s memPerName=$lg(perGlo,2)
	s memGroup=$lg(memGlo,3)
	s memGroupDesc=""
	i memGroup'="" d
	.s groupPar=$p(memGroup,"||")
	.s groupSub=$p(memGroup,"||",2)
	.s groupGlo=$g(^CT.DHCINM.DB.MgSetCodeSubD(groupPar,groupSub))
	.s memGroupDesc=$lg(groupGlo,3)
	s memPost=$lg(memGlo,4)
	s memPostDesc=""
	i memPost'="" d
	.s postPar=$p(memPost,"||")
	.s postSub=$p(memPost,"||",2)
	.s postGlo=$g(^CT.DHCINM.DB.MgSetCodeSubD(postPar,postSub))
	.s memPostDesc=$lg(postGlo,3)
	s memStDate=$lg(memGlo,5)
	s:memStDate'="" memStDate=$zd(memStDate,3)
	s memEndDate=$lg(memGlo,6)
	s:memEndDate'="" memEndDate=$zd(memEndDate,3)
	s memRemark=$lg(memGlo,7)
	s createDate=$lg(memGlo,8)
	s:createDate'="" createDate=$zd(createDate,3)
	s createTime=$lg(memGlo,9)
	s:createTime'="" createTime=$zt(createTime,1)
	s ret="MemberPer|"_memPer_"^MemberPerName|"_memPerName_"^MemberGroup|"_$tr(memGroup,"|","_")_"^MemberGroupDesc|"_memGroupDesc_"^MemberPost|"_$tr(memPost,"|","_")
	s ret=ret_"^MemberPostDesc|"_memPostDesc_"^MemberStDate|"_memStDate_"^MemberEndDate|"_memEndDate_"^MemberRemark|"_memRemark_"^CreateDate|"_createDate
	s ret=ret_"^CreateTime|"_createTime_"^rw|"_id
	q ret
}

/// Description：获取专业组成员列表
/// Date:2020-07-20
/// Creator:wangpf
/// Table:DHCINM.Special.SpecialMember
/// Input: groupId
/// Output:专业组成员列表
/// Other:d ##class(%ResultSet).RunQuery("web.INMSpecialComm","FindMemberList","60||1")
Query FindMemberList(parr As %String = "", flag As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindMemberListExecute(ByRef qHandle As %Binary, parr As %String = "", flag As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	s group=$tr($p(parr,"^"),"_","|")
	s date=$p(parr,"^",2)
	s:date'="" date=$zdh(date,3)
	
	s memGroup="" f  s memGroup=$o(^DHCINM.Special.SpecialMemberI("Group",memGroup)) q:memGroup=""  d
	.q:(group'="")&&(group'=memGroup)
	.s post="" f  s post=$o(^DHCINM.Special.SpecialMemberI("Group",memGroup,post)) q:post=""  d
	..s id="" f  s id=$o(^DHCINM.Special.SpecialMemberI("Group",memGroup,post,id)) q:id=""  d
	...q:'$d(^DHCINM.Special.SpecialMemberD(id))
	...s memGlo=^DHCINM.Special.SpecialMemberD(id)
	...s stDate=$lg(memGlo,5)
	...s endDate=$lg(memGlo,6)
	...q:(stDate="")||((date'="")&&(date<stDate))||((endDate'="")&&(endDate<date))
	...s memPer=$lg(memGlo,2)
	...s ret=..GetMember(id)
	...s ret=ret_"^"_..GetNurseInfo(memPer)
	...d:ret'="" OutMemberList
	i flag=1 d
	.s conId="" f  s conId=$o(^DHCINM.Special.SpecialConsQualD(conId)) q:conId=""  d
	..s conGlo=^DHCINM.Special.SpecialConsQualD(conId)
	..s groupId=$lg(conGlo,3)
	..q:groupId=""
	..q:group'=groupId
	..s perId=$lg(conGlo,2)
	..s perName=""
	..i perId'="" d
	...s perGlo=$g(^CF.DHCINM.HR.PersonsD(perId))
	...s perName=$lg(perGlo,2)
	..s groupDesc=""
	..i groupId'="" d
	...s groupPar=$p(groupId,"||")
	...s groupSub=$p(groupId,"||",2)
	...s groupGlo=$g(^CT.DHCINM.DB.MgSetCodeSubD(groupPar,groupSub))
	...s groupDesc=$lg(groupGlo,3)
	..s conCrtDate=$lg(conGlo,5)
	..s:conCrtDate'="" conCrtDate=$zd(conCrtDate,3)
	..s conCrtTime=$lg(conGlo,6)
	..s:conCrtTime'="" conCrtTime=$zt(conCrtTime,1)
	..s ret="MemberPer|"_perId_"^MemberPerName|"_perName_"^MemberGroup|"_$tr(groupId,"|","_")_"^MemberGroupDesc|"_groupDesc_"^MemberPost|"
	..s ret=ret_"^MemberPostDesc|^MemberStDate|"_conCrtDate_"^MemberEndDate|^MemberRemark|^CreateDate|"_conCrtDate
	..s ret=ret_"^CreateTime|"_conCrtTime_"^rw|"
	..s ret=ret_"^"_..GetNurseInfo(perId)
	..d:ret'="" OutMemberList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutMemberList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindMemberListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindMemberListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindMemberListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindMemberListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Description: 删除专业组成员
/// Date: 2020-07-20
/// Creator: wangpf
/// Table: DHCINM.Special.SpecialMember
/// Input: id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMSpecialComm).DeleteMember(1)
ClassMethod DeleteMember(id As %String = "") As %String
{
	q:id="" 0
	s sc=##class(DHCINM.Special.SpecialMember).%DeleteId(id)
	q $$$ISOK(sc)
}

/// Description: 判断登录人是否为护理部及以上角色
/// Date: 2020-07-20
/// Creator: wangpf
/// Table: DHCINM.HR.MgNurRole
/// Input: id
/// Output: 0：低于护理部 1：护理部及以上
/// Other: w ##class(web.INMSpecialComm).IsPerOverHLB(0)
ClassMethod IsPerOverHLB(nurseid As %String = "") As %String
{
	s role=##class(web.INMLoginComm).GetRolesByLoginId(nurseid)
	s isOverHLB=0
	f i=1:1:$l(role,"^") q:isOverHLB=1  d
	.s tRole=$p(role,"^",i)
	.q:tRole=""
	.i tRole=0 s isOverHLB=1
	.e  d
	..s RoleObj=##class(CT.DHCINM.Set.MgRoles).%OpenId(tRole)
	..s rolecode=$zcvt(RoleObj.RoleCode,"U")
	..s:(rolecode="ADMIN")||(rolecode="MANAGER")||(rolecode="HLB")||(rolecode="HLBZR") isOverHLB=1
	q isOverHLB
}

/// Description: 获取人员所辖专业组
/// Date: 2020-06-21
/// Creator: wangpf
/// Table: DHCINM.Special.SpecialMember
/// Input: nurseid
/// Output: 专业组
/// Other:d ##class(%ResultSet).RunQuery("web.INMSpecialComm","FindRoleGroupList","0")
Query FindRoleGroupList(nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindRoleGroupListExecute(ByRef qHandle As %Binary, nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i nurseid="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	s parId=$o(^CT.DHCINM.DB.MgSetCodeI("Code"," 专业组",""))
	i parId="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	s isOverHLB=..IsPerOverHLB(nurseid)
	
	i isOverHLB'=1 d
	.s userGlo=^CF.DHCINM.DB.MgUserD(nurseid)
	.s perId=$lg(userGlo,5)
	i (isOverHLB'=1)&&(perId="") Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	s subId="" f  s subId=$o(^CT.DHCINM.DB.MgSetCodeSubD(parId,subId)) q:subId=""  d
	.s subGlo=^CT.DHCINM.DB.MgSetCodeSubD(parId,subId)
	.s subCode=$lg(subGlo,2)
	.s subDesc=$lg(subGlo,3)
	.s stDate=$lg(subGlo,5)
	.s endDate=$lg(subGlo,6)
	.s now=+$h
	.q:(stDate>now)||((endDate'="")&&(endDate<now))
	.q:(isOverHLB'=1)&&('$d(^DHCINM.Special.SpecialMemberI("Per",perId,parId_"||"_subId)))
	.s ret="SubCode|"_subCode_"^SubDesc|"_subDesc_"^SubValue|"_parId_"__"_subId
	.d OutGroupList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutGroupList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindRoleGroupListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindRoleGroupListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindRoleGroupListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindRoleGroupListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Description: 保存专业组规划
/// Date: 2020-07-21
/// Creator: wangpf
/// Table: DHCINM.Special.SpecialLayout
/// Input: parr userid
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMSpecialComm).SaveLayout("",0)
ClassMethod SaveLayout(parr As %String = "", content As %String = "", nurseid As %String = "") As %String
{
	q:(parr="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	
	s group=$tr($p(parr,"^"),"_","|")
	s groupPar=$p(group,"||")
	s groupSub=$p(group,"||",2)
	q:'$d(^CT.DHCINM.DB.MgSetCodeSubD(groupPar,groupSub)) 0
	s year=$p(parr,"^",2)
	s stDate=$p(parr,"^",3)
	s:stDate'="" stDate=$zdh(stDate,3)
	s endDate=$p(parr,"^",4)
	s:endDate'="" endDate=$zdh(endDate,3)
	s status=$p(parr,"^",5)
	s rw=$p(parr,"^",6)
	
	i rw="" d
	.s obj=##class(DHCINM.Special.SpecialLayout).%New()
	.s obj.Creator=nurseid
	e  s obj=##class(DHCINM.Special.SpecialLayout).%OpenId(rw)
	q:'$IsObject(obj) 0
	d obj.LayoutGroupSetObjectId(group)
	s obj.LayoutYear=year
	s obj.LayoutStDate=stDate
	s obj.LayoutEndDate=endDate
	i $CLASSNAME(content)["CSP.CharacterStream" {
		d obj.LayoutContentExt.CopyFromAndSave(content)
	}
	else {
		d obj.LayoutContentExt.Write(content)
	}
	s obj.LayoutStatus=status
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Description: 获取专业组规划
/// Date: 2020-07-21
/// Creator: wangpf
/// Table: DHCINM.Special.SpecialLayout
/// Input: id flag:是否返回规划内容
/// Output: 专业组规划
/// Other: w ##class(web.INMSpecialComm).GetLayout(1)
ClassMethod GetLayout(id As %String = "", flag As %String = "") As %String
{
	i (id="")||('$d(^DHCINM.Special.SpecialLayoutD(id))){
		i flag=1 q "{}"
		e  q ""
	}
	s layGlo=^DHCINM.Special.SpecialLayoutD(id)
	s layGroup=$lg(layGlo,2)
	s layGroupDesc=""
	i layGroup'="" d
	.s groupPar=$p(layGroup,"||")
	.s groupSub=$p(layGroup,"||",2)
	.s groupGlo=$g(^CT.DHCINM.DB.MgSetCodeSubD(groupPar,groupSub))
	.s layGroupDesc=$lg(groupGlo,3)
	s layYear=$lg(layGlo,3)
	s:layYear'="" layYear=layYear_"年"
	s layStDate=$lg(layGlo,4)
	s:layStDate'="" layStDate=$zd(layStDate,3)
	s layEndDate=$lg(layGlo,5)
	s:layEndDate'="" layEndDate=$zd(layEndDate,3)
	s layContent=""
	;s:flag=1 layContent=$lg(layGlo,6)
	s layStatus=$lg(layGlo,7)
	s layStatusDesc=$case(layStatus,"N":"保存","Y":"提交","A":"审核","B":"驳回",:"")
	s creator=$lg(layGlo,8)
	s creatorName=""
	i creator=0 s creatorName="管理员"
	e  i creator'="" d
	.s perGlo=$g(^CF.DHCINM.DB.MgUserD(creator))
	.s creatorName=$lg(perGlo,2)
	s createDate=$lg(layGlo,9)
	s:createDate'="" createDate=$zd(createDate,3)
	s createTime=$lg(layGlo,10)
	s:createTime'="" createTime=$zt(createTime,1)
	s auditor=$lg(layGlo,11)
	s auditorName=""
	i auditor=0 s auditorName="管理员"
	e  i auditor'="" d
	.s perGlo=$g(^CF.DHCINM.DB.MgUserD(auditor))
	.s auditorName=$lg(perGlo,2)
	s auditDate=$lg(layGlo,12)
	s:auditDate'="" auditDate=$zd(auditDate,3)
	s auditTime=$lg(layGlo,13)
	s:auditTime'="" auditTime=$zt(auditTime,1)
	s auditOpinion=$lg(layGlo,14)

	i flag=1{
		w "{""LayoutGroup"":"""_$tr(layGroup,"|","_")_""",""LayoutGroupDesc"":"""_layGroupDesc_""",""LayoutYear"":"""_layYear_""",""LayoutStDate"":"""_layStDate
		w """,""LayoutEndDate"":"""_layEndDate_""",""LayoutContent"":"""
		s obj=##class(DHCINM.Special.SpecialLayout).%OpenId(id)
		while ('obj.LayoutContentExt.AtEnd){
			;w $tr(obj.LayoutContentExt.Read(),$c(10,13))
			w $replace($zcvt($tr(obj.LayoutContentExt.Read(),$c(10,13)),"O","JS"),"\'","'")
		}
		w """,""LayoutStatus"":"""_layStatus_""",""LayoutStatusDesc"":"""_layStatusDesc_""",""Creator"":"""_creator_""",""CreatorName"":"""_creatorName
		w """,""CreateDate"":"""_createDate_""",""CreateTime"":"""_createTime_""",""Auditor"":"""_auditor_""",""AuditorName"":"""_auditorName
		w """,""AuditDate"":"""_auditDate_""",""AuditTime"":"""_auditTime_""",""AuditOpinion"":"""_auditOpinion_""",""rw"":"""_id_"""}"
		q ""
	}else {
		s ret="LayoutGroup|"_$tr(layGroup,"|","_")_"^LayoutGroupDesc|"_layGroupDesc_"^LayoutYear|"_layYear_"^LayoutStDate|"_layStDate
		s ret=ret_"^LayoutEndDate|"_layEndDate_"^LayoutContent|"_layContent_"^LayoutStatus|"_layStatus_"^LayoutStatusDesc|"_layStatusDesc
		s ret=ret_"^Creator|"_creator_"^CreatorName|"_creatorName_"^CreateDate|"_createDate_"^CreateTime|"_createTime_"^Auditor|"_auditor
		s ret=ret_"^AuditorName|"_auditorName_"^AuditDate|"_auditDate_"^AuditTime|"_auditTime_"^AuditOpinion|"_auditOpinion_"^rw|"_id
		q ret
	}
}

/// Description：获取专业组规划列表
/// Date:2020-07-21
/// Creator:wangpf
/// Table:DHCINM.Special.SpecialLayout
/// Input: 专业组^开始日期^结束日期^状态 登录人Id
/// Output:专业组规划列表
/// Other:d ##class(%ResultSet).RunQuery("web.INMSpecialComm","FindLayoutList","^^^",0)
Query FindLayoutList(parr As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindLayoutListExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i (parr="")||(nurseid="") Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	s group=$tr($p(parr,"^"),"_","|")
	s stDate=$p(parr,"^",2)
	s:stDate["-" stDate=$zdh(stDate,3)
	s endDate=$p(parr,"^",3)
	s:endDate["-" endDate=$zdh(endDate,3)
	s status=$p(parr,"^",4)
	
	s isOverHLB=..IsPerOverHLB(nurseid)
	
	i isOverHLB'=1 d
	.s userGlo=^CF.DHCINM.DB.MgUserD(nurseid)
	.s perId=$lg(userGlo,5)
	i (isOverHLB'=1)&&(perId="") Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	s layStDate="" f  s layStDate=$o(^DHCINM.Special.SpecialLayoutI("ToolIndex",layStDate),-1) q:layStDate=""  d
	.s layGroup="" f  s layGroup=$o(^DHCINM.Special.SpecialLayoutI("ToolIndex",layStDate,layGroup)) q:layGroup=""  d
	..q:((group'="")&&(group'=layGroup))
	..s parId=$p(layGroup,"||")
	..s subId=$p(layGroup,"||",2)
	..q:(isOverHLB'=1)&&('$d(^DHCINM.Special.SpecialMemberI("Per",perId,parId_"||"_subId)))
	..s layStatus="" f  s layStatus=$o(^DHCINM.Special.SpecialLayoutI("ToolIndex",layStDate,layGroup,layStatus)) q:layStatus=""  d
	...q:(status'="")&&(status'=$tr(layStatus," ",""))
	...s id="" f  s id=$o(^DHCINM.Special.SpecialLayoutI("ToolIndex",layStDate,layGroup,layStatus,id)) q:id=""  d
	....q:'$d(^DHCINM.Special.SpecialLayoutD(id))
	....s layGlo=^DHCINM.Special.SpecialLayoutD(id)
	....s layEndDate=$lg(layGlo,5)
	....q:((stDate'="")&&(stDate>layEndDate))||((endDate'="")&&(endDate<layStDate))
	....s ret=..GetLayout(id)
	....d:ret'="" OutLayoutList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutLayoutList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindLayoutListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindLayoutListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindLayoutListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindLayoutListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Description: 审核专业组规划
/// Date: 2020-07-21
/// Creator: wangpf
/// Table: DHCINM.Special.SpecialLayout
/// Input: id userid
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMSpecialComm).AuditLayout("",0)
ClassMethod AuditLayout(parr As %String = "", nurseid As %String = "") As %String
{
	q:(parr="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	
	s status=$p(parr,"^")
	s opinion=$p(parr,"^",2)
	s id=$p(parr,"^",3)
	s obj=##class(DHCINM.Special.SpecialLayout).%OpenId(id)
	q:'$IsObject(obj) 0
	s obj.LayoutStatus=status
	s obj.AuditOpinion=opinion
	s obj.Auditor=nurseid
	s now=$h
	s obj.AuditDate=+now
	s obj.AuditTime=$p(now,",",2)
	s sc=obj.%Save()
	try{
		i (($$$ISOK(sc))&&((obj.LayoutStatus="A")||(obj.LayoutStatus="B"))) d
		.s LayoutStatus=$case(obj.LayoutStatus,"A":"审核","B":"驳回")
		.s LayoutGroup=obj.LayoutGroup.SubDesc
		.s LayoutYear=$lg($g(^DHCINM.Special.SpecialLayoutD(id)),3)
		.s LayoutStDate=$lg($g(^DHCINM.Special.SpecialLayoutD(id)),4)
		.s:LayoutStDate'="" LayoutStDate=$zd(LayoutStDate,3)
		.s LayoutEndDate=$lg($g(^DHCINM.Special.SpecialLayoutD(id)),5)
		.s:LayoutEndDate'="" LayoutEndDate=$zd(LayoutEndDate,3)
		.s Creator=$lg($g(^DHCINM.Special.SpecialLayoutD(id)),8)
		.s ret="【专业组/专业组工作计划/发展规划】"_LayoutStatus_" "_LayoutGroup_" "_LayoutYear_" "_LayoutStDate _" "_LayoutEndDate
		.d ##class(web.INMPlatform).SaveTrackMessage(Creator,+$H,ret,"","DHCINM.Special.SpecialLayout",id)
	}catch{
		}
	q $$$ISOK(sc)
}

/// Description: 删除专业组规划
/// Date: 2020-07-21
/// Creator: wangpf
/// Table: DHCINM.Special.SpecialLayout
/// Input: id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMSpecialComm).DeleteLayout(1)
ClassMethod DeleteLayout(id As %String = "") As %String
{
	q:id="" 0
	s sc=##class(DHCINM.Special.SpecialLayout).%DeleteId(id)
	q $$$ISOK(sc)
}

/// Description: 保存专业组计划
/// Date: 2020-07-21
/// Creator: wangpf
/// Table: DHCINM.Special.SpecialPlan
/// Input: parr userid
/// Output: -1:重复 0：失败 1：成功
/// Other: w ##class(web.INMSpecialComm).SavePlan("",0)
ClassMethod SavePlan(parr As %String = "", nurseid As %String = "") As %String
{
	q:(parr="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	
	s year=$p(parr,"^")
	s group=$tr($p(parr,"^",2),"_","|")
	s groupPar=$p(group,"||")
	s groupSub=$p(group,"||",2)
	q:'$d(^CT.DHCINM.DB.MgSetCodeSubD(groupPar,groupSub)) 0
	s type=$p(parr,"^",3)
	s date=$p(parr,"^",4)
	s status=$p(parr,"^",5)
	s rw=$p(parr,"^",6)
	
	s id=$o(^DHCINM.Special.SpecialPlanI("ToolIndex",year,group," "_type," "_date,""))
	q:(id'="")&&(id'=rw) -1
	i rw="" d
	.s obj=##class(DHCINM.Special.SpecialPlan).%New()
	.s obj.Creator=nurseid
	e  s obj=##class(DHCINM.Special.SpecialPlan).%OpenId(rw)
	q:'$IsObject(obj) 0
	s obj.PlanYear=year
	d obj.PlanGroupSetObjectId(group)
	s obj.PlanType=type
	s obj.PlanDate=date
	s obj.PlanStatus=status
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Description: 获取专业组计划
/// Date: 2020-07-21
/// Creator: wangpf
/// Table: DHCINM.Special.SpecialPlan
/// Input: id
/// Output: 专业组计划
/// Other: w ##class(web.INMSpecialComm).GetPlan(1)
ClassMethod GetPlan(id As %String = "") As %String
{
	q:(id="")||($d(^DHCINM.Special.SpecialPlanD(id))#2'=1) ""
	
	s planGlo=^DHCINM.Special.SpecialPlanD(id)
	s planYear=$lg(planGlo,2)
	s planGroup=$lg(planGlo,3)
	s planGroupDesc=""
	i planGroup'="" d
	.s groupPar=$p(planGroup,"||")
	.s groupSub=$p(planGroup,"||",2)
	.s groupGlo=$g(^CT.DHCINM.DB.MgSetCodeSubD(groupPar,groupSub))
	.s planGroupDesc=$lg(groupGlo,3)
	s planType=$lg(planGlo,4)
	s planTypeDesc=$case(planType,"Y":"年度","H":"半年度","S":"季度","M":"月度","W":"周","D":"日",:"")
	s planDate=$lg(planGlo,5)
	s planStDate="",planEndDate=""
	i planType="Y" d
	.s planStDate=planYear_"-01-01",planEndDate=planYear_"-12-31"
	e  i planType="H" d
	.i planDate="01" s planStDate=planYear_"-01-01",planEndDate=planYear_"-06-30"
	.e  i planDate="02" s planStDate=planYear_"-07-01",planEndDate=planYear_"-12-31"
	e  i planType="S" d
	.i planDate="01" s planStDate=planYear_"-01-01",planEndDate=planYear_"-03-31"
	.e  i planDate="02" s planStDate=planYear_"-04-01",planEndDate=planYear_"-06-30"
	.e  i planDate="03" s planStDate=planYear_"-07-01",planEndDate=planYear_"-09-30"
	.e  i planDate="04" s planStDate=planYear_"-10-01",planEndDate=planYear_"-12-31"
	e  i planType="M" d
	.s stDate=$zdh(planYear_"-"_planDate_"-01",3)
	.s lastDay=$SYSTEM.SQL.LASTDAY(stDate)
	.s lastDate=$zd(lastDay,3)
	.s planStDate=planYear_"-"_planDate_"-01",planEndDate=lastDate
	e  i planType="W" d
	.s stDate=$zdh(planDate,3)
	.s lastDay=stDate+6
	.s lastDate=$zd(lastDay,3)
	.s planStDate=planDate,planEndDate=lastDate
	e  i planType="D" d
	.s planStDate=planDate,planEndDate=planDate
	s planStatus=$lg(planGlo,6)
	s planStatusDesc=$case(planStatus,"N":"保存","Y":"提交","A":"审核","B":"驳回",:"")
	s creator=$lg(planGlo,7)
	s creatorName=""
	i creator=0 s creatorName="管理员"
	e  i creator'="" d
	.s perGlo=$g(^CF.DHCINM.DB.MgUserD(creator))
	.s creatorName=$lg(perGlo,2)
	s createDate=$lg(planGlo,8)
	s:createDate'="" createDate=$zd(createDate,3)
	s createTime=$lg(planGlo,9)
	s:createTime'="" createTime=$zt(createTime,1)
	s auditor=$lg(planGlo,10)
	s auditorName=""
	i auditor=0 s auditorName="管理员"
	e  i auditor'="" d
	.s perGlo=$g(^CF.DHCINM.DB.MgUserD(auditor))
	.s auditorName=$lg(perGlo,2)
	s auditDate=$lg(planGlo,11)
	s:auditDate'="" auditDate=$zd(auditDate,3)
	s auditTime=$lg(planGlo,12)
	s:auditTime'="" auditTime=$zt(auditTime,1)
	s auditOpinion=$lg(planGlo,13)
	s ret="PlanYear|"_planYear_"^PlanGroup|"_$tr(planGroup,"|","_")_"^PlanGroupDesc|"_planGroupDesc_"^PlanType|"_planType_"^PlanTypeDesc|"_planTypeDesc
	s ret=ret_"^PlanDate|"_planDate_"^PlanStDate|"_planStDate_"^PlanEndDate|"_planEndDate_"^PlanStatus|"_planStatus_"^PlanStatusDesc|"_planStatusDesc
	s ret=ret_"^Creator|"_creator_"^CreatorName|"_creatorName_"^CreateDate|"_createDate_"^CreateTime|"_createTime_"^Auditor|"_auditor_"^AuditorName|"_auditorName
	s ret=ret_"^AuditDate|"_auditDate_"^AuditTime|"_auditTime_"^AuditOpinion|"_auditOpinion_"^rw|"_id
	q ret
}

/// Description：获取专业组计划列表
/// Date:2020-07-21
/// Creator:wangpf
/// Table:DHCINM.Special.SpecialPlan
/// Input: 年份^专业组^状态 登录人Id
/// Output:专业组计划列表
/// Other:d ##class(%ResultSet).RunQuery("web.INMSpecialComm","FindPlanList","^^",0)
Query FindPlanList(parr As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindPlanListExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i (parr="")||(nurseid="") Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	s year=$p(parr,"^")
	s group=$tr($p(parr,"^",2),"_","|")
	s status=$p(parr,"^",3)
	
	s isOverHLB=..IsPerOverHLB(nurseid)
	
	i isOverHLB'=1 d
	.s userGlo=^CF.DHCINM.DB.MgUserD(nurseid)
	.s perId=$lg(userGlo,5)
	i (isOverHLB'=1)&&(perId="") Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	s planYear="" f  s planYear=$o(^DHCINM.Special.SpecialPlanI("ToolIndex",planYear),-1) q:planYear=""  d
	.q:(year'="")&&(year'=planYear)
	.s planGroup="" f  s planGroup=$o(^DHCINM.Special.SpecialPlanI("ToolIndex",planYear,planGroup)) q:planGroup=""  d
	..q:(group'="")&&(group'=planGroup)
	..s parId=$p(planGroup,"||")
	..s subId=$p(planGroup,"||",2)
	..q:(isOverHLB'=1)&&('$d(^DHCINM.Special.SpecialMemberI("Per",perId,parId_"||"_subId)))
	..s planType="" f  s planType=$o(^DHCINM.Special.SpecialPlanI("ToolIndex",planYear,planGroup,planType)) q:planType=""  d
	...s planDate="" f  s planDate=$o(^DHCINM.Special.SpecialPlanI("ToolIndex",planYear,planGroup,planType,planDate)) q:planDate=""  d
	....s id="" f  s id=$o(^DHCINM.Special.SpecialPlanI("ToolIndex",planYear,planGroup,planType,planDate,id)) q:id=""  d
	.....q:'$d(^DHCINM.Special.SpecialPlanD(id))
	.....s planGlo=^DHCINM.Special.SpecialPlanD(id)
	.....s planStatus=$lg(planGlo,6)
	.....q:(status'="")&&(status'=planStatus)
	.....s ret=..GetPlan(id)
	.....d:ret'="" OutPlanList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPlanList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindPlanListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPlanListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindPlanListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPlanListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Description: 审核专业组计划
/// Date: 2020-07-21
/// Creator: wangpf
/// Table: DHCINM.Special.SpecialPlan
/// Input: id userid
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMSpecialComm).AuditPlan("",0)
ClassMethod AuditPlan(parr As %String = "", nurseid As %String = "") As %String
{
	q:(parr="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	
	s status=$p(parr,"^")
	s opinion=$p(parr,"^",2)
	s id=$p(parr,"^",3)
	s obj=##class(DHCINM.Special.SpecialPlan).%OpenId(id)
	q:'$IsObject(obj) 0
	s obj.PlanStatus=status
	s obj.AuditOpinion=opinion
	s obj.Auditor=nurseid
	s now=$h
	s obj.AuditDate=+now
	s obj.AuditTime=$p(now,",",2)
	s sc=obj.%Save()
	try{
		i (($$$ISOK(sc))&&((obj.PlanStatus="A")||(obj.PlanStatus="B"))) d
		.s PlanStatus=$case(obj.PlanStatus,"A":"审核","B":"驳回")
		.s PlanYear1=$lg($g(^DHCINM.Special.SpecialPlanD(id)),2)
		.s PlanYear2=""
		.s:PlanYear1'="" PlanYear2=$zd(PlanYear1,3)
		.s PlanYear=$p(PlanYear1,"-",1)		
		.s PlanGroup=obj.PlanGroup.SubDesc
		.s planType=$lg($g(^DHCINM.Special.SpecialPlanD(id)),4)
		.s planTypeDesc=$case(obj.PlanType,"Y":"年度","H":"半年度","S":"季度","M":"月度","W":"周","D":"日") ;计划周期
		.s planDate=$lg($g(^DHCINM.Special.SpecialPlanD(id)),5)
		.s planStDate="",planEndDate="",PlanDateDesc=""
		.i planType="Y" d  ;年
		..s PlanDateDesc=planDate_"年"
		.e  i planType="H" d ;半年
		..i planDate="01" s PlanDateDesc="上半年"
		..e  i planDate="02" s PlanDateDesc="下半年"
		.e  i planType="S" d  ;季度
		..i planDate="01" s PlanDateDesc="第一季度"
		..e  i planDate="02" s PlanDateDesc="第二季度"
		..e  i planDate="03" s PlanDateDesc="第三季度"
		..e  i planDate="04" s PlanDateDesc="第四季度"
		.e  i planType="M" s PlanDateDesc=(planDate-0)_"月"
		.e  i planType="W" d ;周
		..s stDate=$zdh(planDate,3)
		..s lastDay=stDate+6
		..s lastDate=$zd(lastDay,3)
		..s planStDate=planDate,planEndDate=lastDate
		..s PlanDateDesc="第"_$fn($zd(stDate,14)/7,"",0)_"周"_planStDate_"~"_planEndDate
		.e  i planType="D" d  ;日
		..s PlanDateDesc=planDate
		.s Creator=$lg($g(^DHCINM.Special.SpecialPlanD(id)),7)
		.s ret="【专业组/专业组工作计划/工作计划】"_PlanStatus_" "_PlanYear_" "_PlanGroup_" "_planTypeDesc _" "_PlanDateDesc
		.d ##class(web.INMPlatform).SaveTrackMessage(Creator,+$H,ret,"","DHCINM.Special.SpecialPlan",id)
	}catch{
		}
	q $$$ISOK(sc)
}

/// Description: 删除专业组计划
/// Date: 2020-07-21
/// Creator: wangpf
/// Table: DHCINM.Special.SpecialPlan
/// Input: id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMSpecialComm).DeletePlan(1)
ClassMethod DeletePlan(id As %String = "") As %String
{
	q:id="" 0
	s sc=##class(DHCINM.Special.SpecialPlan).%DeleteId(id)
	q $$$ISOK(sc)
}

/// Description: 保存专业组计划子表
/// Date: 2020-07-22
/// Creator: wangpf
/// Table: DHCINM.Special.SpecialPlanSub
/// Input: parr userid
/// Output: -1:重复 0：失败 1：成功
/// Other: w ##class(web.INMSpecialComm).SavePlan("",0)
ClassMethod SavePlanSub(parr As %String = "") As %String
{
	q:parr="" 0
	
	s par=$p(parr,"^")
	q:(par="")||'$d(^DHCINM.Special.SpecialPlanD(par)) 0
	s stDate=$p(parr,"^",2)
	s:stDate'="" stDate=$zdh(stDate,3)
	s endDate=$p(parr,"^",3)
	s:endDate'="" endDate=$zdh(endDate,3)
	s mission=$p(parr,"^",4)
	s target=$p(parr,"^",5)
	s step=$p(parr,"^",6)
	s charger=$p(parr,"^",7)
	q:'$d(^CF.DHCINM.HR.PersonsD(charger)) 0
	s rw=$tr($p(parr,"^",8),"_","|")
	
	s flag=1
	s tmpStDate="" f  s tmpStDate=$o(^DHCINM.Special.SpecialPlanSubI("StDate",par,tmpStDate)) q:(tmpStDate="")||(flag'=1)  d
	.s tmpEndDate="" f  s tmpEndDate=$o(^DHCINM.Special.SpecialPlanSubI("StDate",par,tmpStDate,tmpEndDate)) q:(tmpEndDate="")||(flag'=1)  d
	..s id="" f  s id=$o(^DHCINM.Special.SpecialPlanSubI("StDate",par,tmpStDate,tmpEndDate,id)) q:(id="")||(flag'=1)  d
	...i (par_"||"_id'=rw)&&((tmpStDate=stDate)||(tmpStDate=endDate)||(tmpEndDate=stDate)||(tmpEndDate=endDate)) s flag=0 q
	...i (par_"||"_id'=rw)&&((stDate<tmpEndDate)&&(endDate>tmpStDate)) s flag=0 q
	q:flag'=1 -1
	i rw="" d
	.s obj=##class(DHCINM.Special.SpecialPlanSub).%New()
	.d obj.ParrefSetObjectId(par)
	e  s obj=##class(DHCINM.Special.SpecialPlanSub).%OpenId(rw)
	q:'$IsObject(obj) 0
	s obj.SubStDate=stDate
	s obj.SubEndDate=endDate
	s obj.SubMission=mission
	s obj.SubTarget=target
	s obj.SubStep=step
	d obj.SubChargerSetObjectId(charger)
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Description: 获取专业组计划子表
/// Date: 2020-07-22
/// Creator: wangpf
/// Table: DHCINM.Special.SpecialPlanSub
/// Input: id
/// Output: 专业组计划子表
/// Other: w ##class(web.INMSpecialComm).GetPlanSub("1||1")
ClassMethod GetPlanSub(id As %String = "") As %String
{
	q:(id="") ""
	s id=$tr(id,"_","|")
	s par=$p(id,"||")
	s sub=$p(id,"||",2)
	q:'$d(^DHCINM.Special.SpecialPlanSubD(par,sub)) ""
	
	s subGlo=^DHCINM.Special.SpecialPlanSubD(par,sub)
	s subStDate=$lg(subGlo,2)
	s:subStDate'="" subStDate=$zd(subStDate,3)
	s subEndDate=$lg(subGlo,3)
	s:subEndDate'="" subEndDate=$zd(subEndDate,3)
	s subMission=$lg(subGlo,4)
	s subTarget=$lg(subGlo,5)
	s subStep=$lg(subGlo,6)
	s subCharger=$lg(subGlo,7)
	s subChargerName=""
	i subCharger=0 s subChargerName="管理员"
	e  i subCharger'="" d
	.s perGlo=$g(^CF.DHCINM.HR.PersonsD(subCharger))
	.s subChargerName=$lg(perGlo,2)
	s parGlo=^DHCINM.Special.SpecialPlanD(par)
	s parStatus=$lg(parGlo,6)
	s parStatusDesc=$case(parStatus,"N":"保存","Y":"提交","A":"审核","B":"驳回",:"")
	s parCreator=$lg(parGlo,7)
	s parCreatorName=""
	i parCreator=0 s parCreatorName="管理员"
	e  i parCreator'="" d
	.s perGlo=$g(^CF.DHCINM.DB.MgUserD(parCreator))
	.s parCreatorName=$lg(perGlo,2)
	s ret="SubStDate|"_subStDate_"^SubEndDate|"_subEndDate_"^SubMission|"_subMission_"^SubTarget|"_subTarget_"^SubStep|"_subStep
	s ret=ret_"^SubCharger|"_subCharger_"^SubChargerName|"_subChargerName_"^ParStatus|"_parStatus_"^ParStatusDesc|"_parStatusDesc
	s ret=ret_"^ParCreator|"_parCreator_"^ParCreatorName|"_parCreatorName_"^rw|"_$tr(id,"|","_")
	q ret
}

/// Description：获取专业组计划列表
/// Date:2020-07-22
/// Creator:wangpf
/// Table:DHCINM.Special.SpecialPlanSub
/// Input: 父表Id
/// Output:专业组计划列表
/// Other:d ##class(%ResultSet).RunQuery("web.INMSpecialComm","FindPlanSubList","6")
Query FindPlanSubList(parr As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindPlanSubListExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i parr="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	s subId="" f  s subId=$o(^DHCINM.Special.SpecialPlanSubD(parr,subId)) q:subId=""  d
	.s ret=..GetPlanSub(parr_"||"_subId)
	.d:ret'="" OutPlanSubList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPlanSubList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindPlanSubListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPlanSubListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindPlanSubListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPlanSubListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Description: 删除专业组计划子表
/// Date: 2020-07-22
/// Creator: wangpf
/// Table: DHCINM.Special.SpecialPlanSub
/// Input: id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMSpecialComm).DeletePlanSub("1||1,1||2")
ClassMethod DeletePlanSub(id As %String = "") As %String
{
	q:id="" 0
	s id=$tr(id,"_","|")
	s idList=$lfs(id,",")
	s ptr=0 f  s status=$listnext(idList,ptr,rw) q:status'=1  d
	.d ##class(DHCINM.Special.SpecialPlanSub).%DeleteId(rw)
	q 1
}

/// Description: 保存规范参与情况
/// Date: 2020-07-22
/// Creator: wangpf
/// Table: DHCINM.Special.SpecialStandard
/// Input: parr userid
/// Output: 0：失败 >0：成功
/// Other: w ##class(web.INMSpecialComm).SaveStandard("",0)
ClassMethod SaveStandard(parr As %String = "", nurseid As %String = "") As %String
{
	q:(parr="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	
	s type=$p(parr,"^")
	s typeSub=$p(parr,"^",2)
	s desc=$p(parr,"^",3)
	s group=$tr($p(parr,"^",4),"_","|")
	s groupPar=$p(group,"||")
	s groupSub=$p(group,"||",2)
	q:'$d(^CT.DHCINM.DB.MgSetCodeSubD(groupPar,groupSub)) 0
	s participant=$p(parr,"^",5)
	s partiList=$lfs(participant,",")
	s status=$p(parr,"^",6)
	s rw=$p(parr,"^",7)
	
	i rw="" d
	.s obj=##class(DHCINM.Special.SpecialStandard).%New()
	.s obj.Creator=nurseid
	e  s obj=##class(DHCINM.Special.SpecialStandard).%OpenId(rw)
	q:'$IsObject(obj) 0
	s obj.StandardType=type
	s obj.StandardTypeSub=typeSub
	d obj.StandardGroupSetObjectId(group)
	s obj.StandardDesc=desc
	d obj.StandardParticipant.Clear()
	s ptr=0 f  s stat=$listnext(partiList,ptr,per) q:stat'=1  d
	.q:'$d(^CF.DHCINM.HR.PersonsD(per))
	.d obj.StandardParticipant.Insert(per)
	s obj.StandardStatus=status
	s sc=obj.%Save()
	i $$$ISOK(sc) q obj.%Id()
	e  q 0
}

/// Description: 保存规范参与情况文件
/// Date: 2020-07-22
/// Creator: wangpf
/// Table: DHCINM.Special.SpecialStandard
/// Input: id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMSpecialComm).SaveStandardFile(3,"D:/dhcinm/SpecialActivity/3/安贞需求补.txt")
ClassMethod SaveStandardFile(id As %String = "", name As %String = "") As %String
{
	q:(id="")||(name="") 0
	
	s obj=##class(DHCINM.Special.SpecialStandard).%OpenId(id)
	q:'$IsObject(obj) 0
	i obj.StandardFile="" s obj.StandardFile=name
	e  s obj.StandardFile=obj.StandardFile_"」"_name
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Description: 删除规范参与情况文件
/// Date: 2020-07-22
/// Creator: wangpf
/// Table: DHCINM.Special.SpecialStandard
/// Input: id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMSpecialComm).DeleteStandardFile(3,"D:/dhcinm/SpecialActivity/3/安贞需求补.txt",0)
ClassMethod DeleteStandardFile(id As %String = "", name As %String = "", nurseid As %String = "") As %String
{
	q:(id="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	
	s obj=##class(DHCINM.Special.SpecialStandard).%OpenId(id)
	q:'$IsObject(obj) 0
	q:(nurseid'=0)&&(obj.Creator'=nurseid) 0
	s fileList=$lfs(obj.StandardFile,"」")
	s exist=0,index=0
	s ptr=0 f  s status=$listnext(fileList,ptr,file) q:(status'=1)||(exist'=0)  d
	.s:file=name exist=1
	.s index=index+1
	q:exist=0 0
	s fileLength=$l(obj.StandardFile,"」")
	s tmpFile=""
	f i=1:1:fileLength d
	.q:i=index
	.i tmpFile="" s tmpFile=$lg(fileList,i)
	.e  s tmpFile=tmpFile_"」"_$lg(fileList,i)
	s obj.StandardFile=tmpFile
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Description: 获取规范参与情况
/// Date: 2020-07-22
/// Creator: wangpf
/// Table: DHCINM.Special.SpecialStandard
/// Input: id
/// Output: 规范参与情况
/// Other: w ##class(web.INMSpecialComm).GetStandard(1)
ClassMethod GetStandard(id As %String = "") As %String
{
	q:(id="")||('$d(^DHCINM.Special.SpecialStandardD(id))) ""
	
	s stanGlo=^DHCINM.Special.SpecialStandardD(id)
	s stanType=$lg(stanGlo,2)
	s stanTypeDesc=$case(stanType,"G":"规范","D":"指引","F":"表单","S":"标准","L":"流程","O":"其他",:"")
	s stanTypeSub=$lg(stanGlo,3)
	s stanTypeSubDesc=$case(stanTypeSub,"C":"制定","U":"修订",:"")
	s stanGroup=$lg(stanGlo,4)
	s stanGroupDesc=""
	i stanGroup'="" d
	.s groupPar=$p(stanGroup,"||")
	.s groupSub=$p(stanGroup,"||",2)
	.s groupGlo=$g(^CT.DHCINM.DB.MgSetCodeSubD(groupPar,groupSub))
	.s stanGroupDesc=$lg(groupGlo,3)
	s stanDesc=$lg(stanGlo,5)
	s standardParti=$lg(stanGlo,6)
	s standardPartiId=$lts(standardParti,",")
	s standardPartiName=""
	s index=1,ptr=0 f  s stat=$listnext(standardParti,ptr,per) q:stat'=1  d
	.s perGlo=$g(^CF.DHCINM.HR.PersonsD(per))
	.s perName=$lg(perGlo,2)
	.i index=1 s standardPartiName=perName
	.e  s standardPartiName=standardPartiName_","_perName
	.s index=index+1
	s stanFile=$lg(stanGlo,7)
	s stanStatus=$lg(stanGlo,8)
	s stanStatusDesc=$case(stanStatus,"N":"保存","Y":"提交","A":"审核","B":"驳回",:"")
	s creator=$lg(stanGlo,9)
	s creatorName=""
	i creator=0 s creatorName="管理员"
	e  i creator'="" d
	.s perGlo=$g(^CF.DHCINM.DB.MgUserD(creator))
	.s creatorName=$lg(perGlo,2)
	s createDate=$lg(stanGlo,10)
	s:createDate'="" createDate=$zd(createDate,3)
	s createTime=$lg(stanGlo,11)
	s:createTime'="" createTime=$zt(createTime,1)
	s auditor=$lg(stanGlo,12)
	s auditorName=""
	i auditor=0 s auditorName="管理员"
	e  i auditor'="" d
	.s perGlo=$g(^CF.DHCINM.DB.MgUserD(auditor))
	.s auditorName=$lg(perGlo,2)
	s auditDate=$lg(stanGlo,13)
	s:auditDate'="" auditDate=$zd(auditDate,3)
	s auditTime=$lg(stanGlo,14)
	s:auditTime'="" auditTime=$zt(auditTime,1)
	s auditOpinion=$lg(stanGlo,15)
	s creatorWard="",auditorWard=""
	i creator'="" d
	.s creatorWard=##class(web.INMHRComm).GetCurrentWard($lg($g(^CF.DHCINM.DB.MgUserD(creator)),5),createDate)
	.s:creatorWard'="" creatorWard=$lg($g(^CF.DHCINM.DB.MgWardD(creatorWard)),4)
	i auditor'="" d
	.s auditorWard=##class(web.INMHRComm).GetCurrentWard($lg($g(^CF.DHCINM.DB.MgUserD(auditor)),5),auditDate)
	.s:auditorWard'="" auditorWard=$lg($g(^CF.DHCINM.DB.MgWardD(auditorWard)),4)
	s ret="StandardType|"_stanType_"^StandardTypeDesc|"_stanTypeDesc_"^StandardTypeSub|"_stanTypeSub_"^StandardTypeSubDesc|"_stanTypeSubDesc_"^StandardGroup|"_$tr(stanGroup,"|","_")
	s ret=ret_"^StandardGroupDesc|"_stanGroupDesc_"^StandardDesc|"_stanDesc_"^StandardParticipant|"_standardPartiId_"^StandardParticipantName|"_standardPartiName
	s ret=ret_"^StandardFile|"_stanFile_"^StandardStatus|"_stanStatus_"^StandardStatusDesc|"_stanStatusDesc_"^Creator|"_creator_"^CreatorName|"_creatorName
	s ret=ret_"^CreateDate|"_createDate_"^CreateTime|"_createTime_"^Auditor|"_auditor_"^AuditorName|"_auditorName_"^AuditDate|"_auditDate_"^AuditTime|"_auditTime
	s ret=ret_"^AuditOpinion|"_auditOpinion_"^rw|"_id_"^AuditorWard|"_auditorWard_"^CreatorWard|"_creatorWard
	q ret
}

/// Description：获取规范参与情况列表
/// Date:2020-07-22
/// Creator:wangpf
/// Table:DHCINM.Special.SpecialStandard
/// Input: 年份^专业组^状态 登录人Id
/// Output:规范参与情况列表
/// Other:d ##class(%ResultSet).RunQuery("web.INMSpecialComm","FindStandardList","^^^^^",0)
Query FindStandardList(parr As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindStandardListExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i (parr="")||(nurseid="") Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	s type=$p(parr,"^")
	s typeList=$lfs(type,",")
	s typeSub=$p(parr,"^",2)
	s typeSubList=$lfs(typeSub,",")
	s group=$tr($p(parr,"^",3),"_","|")
	s stDate=$p(parr,"^",4)
	s:stDate'="" stDate=$zdh(stDate,3)
	s endDate=$p(parr,"^",5)
	s:endDate'="" endDate=$zdh(endDate,3)
	s status=$p(parr,"^",6)
	s inPerId=$p(parr,"^",7)
	
	s isOverHLB=..IsPerOverHLB(nurseid)
	
	i isOverHLB'=1 d
	.s userGlo=^CF.DHCINM.DB.MgUserD(nurseid)
	.s perId=$lg(userGlo,5)
	i (isOverHLB'=1)&&(perId="") Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	s stanCrtDate="" f  s stanCrtDate=$o(^DHCINM.Special.SpecialStandardI("ToolIndex",stanCrtDate),-1) q:stanCrtDate=""  d
	.q:((stDate'="")&&(stDate>stanCrtDate))||((endDate'="")&&(endDate<stanCrtDate))
	.s stanGroup="" f  s stanGroup=$o(^DHCINM.Special.SpecialStandardI("ToolIndex",stanCrtDate,stanGroup)) q:stanGroup=""  d
	..q:((group'="")&&(group'=stanGroup))||((isOverHLB'=1)&&('$d(^DHCINM.Special.SpecialMemberI("Per",perId,stanGroup))))
	..s stanType="" f  s stanType=$o(^DHCINM.Special.SpecialStandardI("ToolIndex",stanCrtDate,stanGroup,stanType)) q:stanType=""  d
	...q:(type'="")&&($lf(typeList,$tr(stanType," ",""))=0)
	...s stanTypeSub="" f  s stanTypeSub=$o(^DHCINM.Special.SpecialStandardI("ToolIndex",stanCrtDate,stanGroup,stanType,stanTypeSub)) q:stanTypeSub=""  d
	....q:(typeSub'="")&&($lf(typeSubList,$tr(stanTypeSub," ",""))=0)
	....s stanStatus="" f  s stanStatus=$o(^DHCINM.Special.SpecialStandardI("ToolIndex",stanCrtDate,stanGroup,stanType,stanTypeSub,stanStatus)) q:stanStatus=""  d
	.....q:(status'="")&&(status'=$tr(stanStatus," ",""))
	.....s id="" f  s id=$o(^DHCINM.Special.SpecialStandardI("ToolIndex",stanCrtDate,stanGroup,stanType,stanTypeSub,stanStatus,id)) q:id=""  d
	......q:'$d(^DHCINM.Special.SpecialStandardD(id))
	......s stanGlo=^DHCINM.Special.SpecialStandardD(id)
	......s standardParti=$lg(stanGlo,6)
	......q:(inPerId'="")&&($lf(standardParti,inPerId)=0)
	......s ret=..GetStandard(id)
	......d:ret'="" OutStandardList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutStandardList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindStandardListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindStandardListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindStandardListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindStandardListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Description: 审核规范参与情况
/// Date: 2020-07-22
/// Creator: wangpf
/// Table: DHCINM.Special.SpecialStandard
/// Input: id userid
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMSpecialComm).AuditStandard("",0)
ClassMethod AuditStandard(parr As %String = "", nurseid As %String = "") As %String
{
	q:(parr="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	
	s status=$p(parr,"^")
	s opinion=$p(parr,"^",2)
	s id=$p(parr,"^",3)
	s obj=##class(DHCINM.Special.SpecialStandard).%OpenId(id)
	q:'$IsObject(obj) 0
	s obj.StandardStatus=status
	s obj.AuditOpinion=opinion
	s obj.Auditor=nurseid
	s now=$h
	s obj.AuditDate=+now
	s obj.AuditTime=$p(now,",",2)
	s sc=obj.%Save()
	try{
		i (($$$ISOK(sc))&&((obj.StandardStatus="A")||(obj.StandardStatus="B"))) d
		.s StandardStatus=$case(obj.StandardStatus,"A":"审核","B":"驳回")
		.s StandardType=$case(obj.StandardType,"G":"规范","D":"指引","F":"表单","S":"标准","L":"流程","O":"其他")
		.s StandardTypeSub=$case(obj.StandardTypeSub,"C":"制定","U":"修订")
		.s StandardGroup=obj.StandardGroup.SubDesc
		.s StandardDesc=$lg($g(^DHCINM.Special.SpecialStandardD(id)),5)
		.s perIdList=$lg($g(^DHCINM.Special.SpecialStandardD(id)),6) 
		.s StandardParticipant=""
		.s ptr=0 f  s stat=$listnext(perIdList,ptr,item) q:stat'=1  d
		..s Participant=$p(item,",")
		..i (StandardParticipant="") s StandardParticipant=$lg($g(^CF.DHCINM.HR.PersonsD(Participant)),2)
		..e  s StandardParticipant=StandardParticipant_","_$lg($g(^CF.DHCINM.HR.PersonsD(Participant)),2)
		.s Creator=$lg($g(^DHCINM.Special.SpecialStandardD(id)),9)
		.s ret="【专业组/规范参与情况】"_StandardStatus_" "_StandardType_" "_StandardTypeSub_" "_StandardDesc_" "_StandardGroup  ;_" "_StandardParticipant
		.d ##class(web.INMPlatform).SaveTrackMessage(Creator,+$H,ret,"","DHCINM.Special.SpecialStandard",id)
	}catch{
		}
	q $$$ISOK(sc)
}

/// Description: 删除规范参与情况
/// Date: 2020-07-22
/// Creator: wangpf
/// Table: DHCINM.Special.SpecialStandard
/// Input: id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMSpecialComm).DeleteStandard(1)
ClassMethod DeleteStandard(id As %String = "") As %String
{
	q:id="" 0
	s sc=##class(DHCINM.Special.SpecialStandard).%DeleteId(id)
	q $$$ISOK(sc)
}

/// Description: 保存专科主题活动
/// Date: 2020-07-22
/// Creator: wangpf
/// Table: DHCINM.Special.SpecialActivity
/// Input: parr userid
/// Output: 0：失败 >0：成功
/// Other: w ##class(web.INMSpecialComm).SaveActivity("",0)
ClassMethod SaveActivity(parr As %String = "", nurseid As %String = "") As %String
{
	q:(parr="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	
	s ward=$p(parr,"^")
	q:'$d(^CF.DHCINM.DB.MgWardD(ward)) 0
	s nurse=$p(parr,"^",2)
	s nurseList=$lfs(nurse,",")
	s actType=$p(parr,"^",3)
	s parType=$p(parr,"^",4)
	s level=$p(parr,"^",5)
	s date=$p(parr,"^",6)
	s:date'="" date=$zdh(date,3)
	s topic=$p(parr,"^",7)
	s location=$p(parr,"^",8)
	s status=$p(parr,"^",9)
	s rw=$p(parr,"^",10)
	
	i rw="" d
	.s obj=##class(DHCINM.Special.SpecialActivity).%New()
	.s obj.Creator=nurseid
	e  s obj=##class(DHCINM.Special.SpecialActivity).%OpenId(rw)
	q:'$IsObject(obj) 0
	d obj.ActivityWardSetObjectId(ward)
	d obj.ActivityNurse.Clear()
	s ptr=0 f  s stat=$listnext(nurseList,ptr,per) q:stat'=1  d
	.q:'$d(^CF.DHCINM.HR.PersonsD(per))
	.d obj.ActivityNurse.Insert(per)
	s obj.ActivityType=actType
	s obj.ActivityParType=parType
	s obj.ActivityLevel=level
	s obj.ActivityDate=date
	s obj.ActivityTopic=topic
	s obj.ActivityLocation=location
	s obj.ActivityStatus=status
	s sc=obj.%Save()
	i $$$ISOK(sc) q obj.%Id()
	e  q 0
}

/// Description: 保存专科主题活动文件
/// Date: 2020-07-22
/// Creator: wangpf
/// Table: DHCINM.Special.SpecialActivity
/// Input: id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMSpecialComm).SaveActivityFile(3,"D:/dhcinm/SpecialActivity/3/安贞需求补.txt")
ClassMethod SaveActivityFile(id As %String = "", name As %String = "") As %String
{
	q:(id="")||(name="") 0
	
	s obj=##class(DHCINM.Special.SpecialActivity).%OpenId(id)
	q:'$IsObject(obj) 0
	i obj.ActivityFile="" s obj.ActivityFile=name
	e  s obj.ActivityFile=obj.ActivityFile_"」"_name
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Description: 删除专科主题活动文件
/// Date: 2020-07-22
/// Creator: wangpf
/// Table: DHCINM.Special.SpecialActivity
/// Input: id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMSpecialComm).DeleteActivityFile(3,"D:/dhcinm/SpecialActivity/3/安贞需求补.txt",0)
ClassMethod DeleteActivityFile(id As %String = "", name As %String = "", nurseid As %String = "") As %String
{
	q:(id="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	
	s obj=##class(DHCINM.Special.SpecialActivity).%OpenId(id)
	q:'$IsObject(obj) 0
	q:(nurseid'=0)&&(obj.Creator'=nurseid) 0
	s fileList=$lfs(obj.ActivityFile,"」")
	s exist=0,index=0
	s ptr=0 f  s status=$listnext(fileList,ptr,file) q:(status'=1)||(exist'=0)  d
	.s:file=name exist=1
	.s index=index+1
	q:exist=0 0
	s fileLength=$l(obj.ActivityFile,"」")
	s tmpFile=""
	f i=1:1:fileLength d
	.q:i=index
	.i tmpFile="" s tmpFile=$lg(fileList,i)
	.e  s tmpFile=tmpFile_"」"_$lg(fileList,i)
	s obj.ActivityFile=tmpFile
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Description: 获取专科主题活动
/// Date: 2020-07-22
/// Creator: wangpf
/// Table: DHCINM.Special.SpecialActivity
/// Input: id
/// Output: 专科主题活动
/// Other: w ##class(web.INMSpecialComm).GetActivity(1)
ClassMethod GetActivity(id As %String = "") As %String
{
	q:(id="")||('$d(^DHCINM.Special.SpecialActivityD(id))) ""
	
	s actGlo=^DHCINM.Special.SpecialActivityD(id)
	s actWard=$lg(actGlo,2)
	s actWardDesc=""
	i actWard'="" d
	.s wardGlo=$g(^CF.DHCINM.DB.MgWardD(actWard))
	.s actWardDesc=$lg(wardGlo,4)
	s actNurse=$lg(actGlo,3)
	s actNurseId=$lts(actNurse,",")
	s actNurseName=""
	s index=1,ptr=0 f  s stat=$listnext(actNurse,ptr,per) q:stat'=1  d
	.s perGlo=$g(^CF.DHCINM.HR.PersonsD(per))
	.s perName=$lg(perGlo,2)
	.i index=1 s actNurseName=perName
	.e  s actNurseName=actNurseName_","_perName
	.s index=index+1
	s actType=$lg(actGlo,4)
	s actTypeDesc=##class(DHCINM.Special.SpecialActivity).ActivityTypeLogicalToDisplay(actType)
	s actParType=$lg(actGlo,5)
	s actParTypeDesc=##class(DHCINM.Special.SpecialActivity).ActivityParTypeLogicalToDisplay(actParType)
	s actLevel=$lg(actGlo,6)
	s actLevelDesc=##class(DHCINM.Special.SpecialActivity).ActivityLevelLogicalToDisplay(actLevel)
	s actDate=$lg(actGlo,7)
	s:actDate'="" actDate=$zd(actDate,3)
	s actTopic=$lg(actGlo,8)
	s actLocation=$lg(actGlo,9)
	s actFile=$lg(actGlo,10)
	s actStatus=$lg(actGlo,11)
	s actStatusDesc=##class(DHCINM.Special.SpecialActivity).ActivityStatusLogicalToDisplay(actStatus)
	s creator=$lg(actGlo,12)
	s creatorName=""
	i creator=0 s creatorName="管理员"
	e  i creator'="" d
	.s perGlo=$g(^CF.DHCINM.DB.MgUserD(creator))
	.s creatorName=$lg(perGlo,2)
	s createDate=$lg(actGlo,13)
	s:createDate'="" createDate=$zd(createDate,3)
	s createTime=$lg(actGlo,14)
	s:createTime'="" createTime=$zt(createTime,1)
	s auditor=$lg(actGlo,15)
	s auditorName=""
	i auditor=0 s auditorName="管理员"
	e  i auditor'="" d
	.s perGlo=$g(^CF.DHCINM.DB.MgUserD(auditor))
	.s auditorName=$lg(perGlo,2)
	s auditDate=$lg(actGlo,16)
	s:auditDate'="" auditDate=$zd(auditDate,3)
	s auditTime=$lg(actGlo,17)
	s:auditTime'="" auditTime=$zt(auditTime,1)
	s auditOpinion=$lg(actGlo,18)
	s creatorWard="",auditorWard=""
	i creator'="" d
	.s creatorWard=##class(web.INMHRComm).GetCurrentWard($lg($g(^CF.DHCINM.DB.MgUserD(creator)),5),createDate)
	.s:creatorWard'="" creatorWard=$lg($g(^CF.DHCINM.DB.MgWardD(creatorWard)),4)
	i auditor'="" d
	.s auditorWard=##class(web.INMHRComm).GetCurrentWard($lg($g(^CF.DHCINM.DB.MgUserD(auditor)),5),auditDate)
	.s:auditorWard'="" auditorWard=$lg($g(^CF.DHCINM.DB.MgWardD(auditorWard)),4)
	s ret="ActivityWard|"_actWard_"^ActivityWardDesc|"_actWardDesc_"^ActivityNurse|"_actNurseId_"^ActivityNurseName|"_actNurseName_"^ActivityType|"_actType
	s ret=ret_"^ActivityTypeDesc|"_actTypeDesc_"^ActivityParType|"_actParType_"^ActivityParTypeDesc|"_actParTypeDesc_"^ActivityLevel|"_actLevel
	s ret=ret_"^ActivityLevelDesc|"_actLevelDesc_"^ActivityDate|"_actDate_"^ActivityTopic|"_actTopic_"^ActivityLocation|"_actLocation_"^ActivityFile|"_actFile
	s ret=ret_"^ActivityStatus|"_actStatus_"^ActivityStatusDesc|"_actStatusDesc_"^Creator|"_creator_"^CreatorName|"_creatorName_"^CreateDate|"_createDate
	s ret=ret_"^CreateTime|"_createTime_"^Auditor|"_auditor_"^AuditorName|"_auditorName_"^AuditDate|"_auditDate_"^AuditTime|"_auditTime_"^AuditOpinion|"_auditOpinion
	s ret=ret_"^rw|"_id_"^AuditorWard|"_auditorWard_"^CreatorWard|"_creatorWard
	q ret
}

/// Description：获取专科主题活动列表
/// Date:2020-07-22
/// Creator:wangpf
/// Table:DHCINM.Special.SpecialActivity
/// Input: 病区^活动形式^参与形式^级别^开始日期^结束日期^状态 登录人Id
/// Output:专科主题活动列表
/// Other:d ##class(%ResultSet).RunQuery("web.INMSpecialComm","FindActivityList","^^^^^^",0)
Query FindActivityList(parr As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindActivityListExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i (parr="")||(nurseid="") Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	s ward=$p(parr,"^")
	s type=$p(parr,"^",2)
	s typeList=$lfs(type,",")
	s parType=$p(parr,"^",3)
	s parTypeList=$lfs(parType,",")
	s level=$p(parr,"^",4)
	s levelList=$lfs(level,",")
	s stDate=$p(parr,"^",5)
	s:stDate'="" stDate=$zdh(stDate,3)
	s endDate=$p(parr,"^",6)
	s:endDate'="" endDate=$zdh(endDate,3)
	s status=$p(parr,"^",7)
	s per=$p(parr,"^",8)
	
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	
	s actDate="" f  s actDate=$o(^DHCINM.Special.SpecialActivityI("ToolIndex",actDate),-1) q:actDate=""  d
	.q:((stDate'="")&&(stDate>actDate))||((endDate'="")&&(endDate<actDate))
	.s actWard="" f  s actWard=$o(^DHCINM.Special.SpecialActivityI("ToolIndex",actDate,actWard)) q:actWard=""  d
	..q:((ward'="")&&(ward'=actWard))||((isAll'=1)&&('$d(tmpWard(actWard))))
	..s actLevel="" f  s actLevel=$o(^DHCINM.Special.SpecialActivityI("ToolIndex",actDate,actWard,actLevel)) q:actLevel=""  d
	...q:(level'="")&&($lf(levelList,$tr(actLevel," ",""))=0)
	...s actType="" f  s actType=$o(^DHCINM.Special.SpecialActivityI("ToolIndex",actDate,actWard,actLevel,actType)) q:actType=""  d
	....q:(type'="")&&($lf(typeList,$tr(actType," ",""))=0)
	....s actParType="" f  s actParType=$o(^DHCINM.Special.SpecialActivityI("ToolIndex",actDate,actWard,actLevel,actType,actParType)) q:actParType=""  d
	.....q:(parType'="")&&($lf(parTypeList,$tr(actParType," ",""))=0)
	.....s actStatus="" f  s actStatus=$o(^DHCINM.Special.SpecialActivityI("ToolIndex",actDate,actWard,actLevel,actType,actParType,actStatus)) q:actStatus=""  d
	......q:(status'="")&&(status'=$tr(actStatus," ",""))
	......s id="" f  s id=$o(^DHCINM.Special.SpecialActivityI("ToolIndex",actDate,actWard,actLevel,actType,actParType,actStatus,id)) q:id=""  d
	.......q:'$d(^DHCINM.Special.SpecialActivityD(id))
	.......s actGlo=^DHCINM.Special.SpecialActivityD(id)
	.......s actNurse=$lg(actGlo,3)
	.......q:(per'="")&&($lf(actNurse,per)=0)
	.......s ret=..GetActivity(id)
	.......d:ret'="" OutActivityList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutActivityList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindActivityListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindActivityListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindActivityListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindActivityListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Description: 审核专科主题活动
/// Date: 2020-07-22
/// Creator: wangpf
/// Table: DHCINM.Special.SpecialActivity
/// Input: id userid
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMSpecialComm).AuditActivity("",0)
ClassMethod AuditActivity(parr As %String = "", nurseid As %String = "") As %String
{
	q:(parr="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	
	s status=$p(parr,"^")
	s opinion=$p(parr,"^",2)
	s id=$p(parr,"^",3)
	s obj=##class(DHCINM.Special.SpecialActivity).%OpenId(id)
	q:'$IsObject(obj) 0
	s obj.ActivityStatus=status
	s obj.AuditOpinion=opinion
	s obj.Auditor=nurseid
	s now=$h
	s obj.AuditDate=+now
	s obj.AuditTime=$p(now,",",2)
	s sc=obj.%Save()
	try{
		i (($$$ISOK(sc))&&((obj.ActivityStatus="A")||(obj.ActivityStatus="B"))) d
		.s ActivityStatus=$case(obj.ActivityStatus,"A":"审核","B":"驳回")
		.s ActivityType=$case(obj.ActivityType,"L":"主题论坛","T":"主题讨论","B":"专题读书报告","J":"论坛讲座","G":"专业组讲座","O":"其他")
		.s ActivityParType=$case(obj.ActivityParType,"P":"参与","H":"主持","C":"负责","Z":"组织","O":"其他")
		.s ActivityWard=obj.ActivityWard.WardDesc
		.s ActivityLevel=$case(obj.ActivityLevel,"H":"护理部","L":"科室","W":"病区")
		.s ActivityDate1=$lg($g(^DHCINM.Special.SpecialActivityD(id)),7)
		.s ActivityDate=""
		.s:ActivityDate1'="" ActivityDate=$zd(ActivityDate1,3)
		.s ActivityTopic=$lg($g(^DHCINM.Special.SpecialActivityD(id)),8)
		.s ActivityLocation=$lg($g(^DHCINM.Special.SpecialActivityD(id)),9)
		.s perIdList=$lg($g(^DHCINM.Special.SpecialActivityD(id)),3) 
		.s ActivityNurse=""
		.s ptr=0 f  s stat=$listnext(perIdList,ptr,item) q:stat'=1  d
		..s Participant=$p(item,",")
		..i (ActivityNurse="") s ActivityNurse=$lg($g(^CF.DHCINM.HR.PersonsD(Participant)),2)
		..e  s ActivityNurse=ActivityNurse_","_$lg($g(^CF.DHCINM.HR.PersonsD(Participant)),2)
		.s Creator=$lg($g(^DHCINM.Special.SpecialActivityD(id)),12)
		.s ret="【专业组/专科活动情况/专科主题活动】"_ActivityStatus_" "_ActivityWard_" "_ActivityType_" "_ActivityParType _" "_ActivityLevel_" "_ActivityDate_" "_ActivityTopic_" "_ActivityLocation
		.d ##class(web.INMPlatform).SaveTrackMessage(Creator,+$H,ret,"","DHCINM.Special.SpecialActivity",id)
	}catch{
		}
	q $$$ISOK(sc)
}

/// Description: 删除专科主题活动
/// Date: 2020-07-22
/// Creator: wangpf
/// Table: DHCINM.Special.SpecialActivity
/// Input: id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMSpecialComm).DeleteActivity(1)
ClassMethod DeleteActivity(id As %String = "") As %String
{
	q:id="" 0
	
	s sc=##class(DHCINM.Special.SpecialActivity).%DeleteId(id)
	q $$$ISOK(sc)
}

/// Description: 保存课题专案
/// Date: 2020-07-23
/// Creator: wangpf
/// Table: DHCINM.Special.SpecialCase
/// Input: parr userid
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMSpecialComm).SaveCase("",0)
ClassMethod SaveCase(parr As %String = "", nurseid As %String = "") As %String
{
	q:(parr="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	
	s ward=$p(parr,"^")
	q:'$d(^CF.DHCINM.DB.MgWardD(ward)) 0
	s nurse=$p(parr,"^",2)
	s nurseList=$lfs(nurse,",")
	s caseType=$p(parr,"^",3)
	s parType=$p(parr,"^",4)
	s level=$p(parr,"^",5)
	s stDate=$p(parr,"^",6)
	s:stDate'="" stDate=$zdh(stDate,3)
	s endDate=$p(parr,"^",7)
	s:endDate'="" endDate=$zdh(endDate,3)
	s topic=$p(parr,"^",8)
	s work=$p(parr,"^",9)
	s status=$p(parr,"^",10)
	s rw=$p(parr,"^",11)
	
	i rw="" d
	.s obj=##class(DHCINM.Special.SpecialCase).%New()
	.s obj.Creator=nurseid
	e  s obj=##class(DHCINM.Special.SpecialCase).%OpenId(rw)
	q:'$IsObject(obj) 0
	d obj.CaseWardSetObjectId(ward)
	d obj.CaseNurse.Clear()
	s ptr=0 f  s stat=$listnext(nurseList,ptr,per) q:stat'=1  d
	.q:'$d(^CF.DHCINM.HR.PersonsD(per))
	.d obj.CaseNurse.Insert(per)
	s obj.CaseType=caseType
	s obj.CaseParType=parType
	s obj.CaseLevel=level
	s obj.CaseStDate=stDate
	s obj.CaseEndDate=endDate
	s obj.CaseTopic=topic
	s obj.CaseWork=work
	s obj.CaseStatus=status
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Description: 获取课题专案
/// Date: 2020-07-23
/// Creator: wangpf
/// Table: DHCINM.Special.SpecialCase
/// Input: id
/// Output: 课题专案
/// Other: w ##class(web.INMSpecialComm).GetCase(1)
ClassMethod GetCase(id As %String = "") As %String
{
	q:(id="")||('$d(^DHCINM.Special.SpecialCaseD(id))) ""
	
	s caseGlo=^DHCINM.Special.SpecialCaseD(id)
	s caseWard=$lg(caseGlo,2)
	s caseWardDesc=""
	i caseWard'="" d
	.s wardGlo=$g(^CF.DHCINM.DB.MgWardD(caseWard))
	.s caseWardDesc=$lg(wardGlo,4)
	s caseNurse=$lg(caseGlo,3)
	s caseNurseId=$lts(caseNurse,",")
	s caseNurseName=""
	s index=1,ptr=0 f  s stat=$listnext(caseNurse,ptr,per) q:stat'=1  d
	.s perGlo=$g(^CF.DHCINM.HR.PersonsD(per))
	.s perName=$lg(perGlo,2)
	.i index=1 s caseNurseName=perName
	.e  s caseNurseName=caseNurseName_","_perName
	.s index=index+1
	s caseType=$lg(caseGlo,4)
	s caseTypeDesc=##class(DHCINM.Special.SpecialCase).CaseTypeLogicalToDisplay(caseType)
	s caseParType=$lg(caseGlo,5)
	s caseParTypeDesc=##class(DHCINM.Special.SpecialCase).CaseParTypeLogicalToDisplay(caseParType)
	s caseLevel=$lg(caseGlo,6)
	s caseLevelDesc=##class(DHCINM.Special.SpecialCase).CaseLevelLogicalToDisplay(caseLevel)
	s caseStDate=$lg(caseGlo,7)
	s:caseStDate'="" caseStDate=$zd(caseStDate,3)
	s caseEndDate=$lg(caseGlo,8)
	s:caseEndDate'="" caseEndDate=$zd(caseEndDate,3)
	s caseTopic=$lg(caseGlo,9)
	s caseWork=$lg(caseGlo,10)
	s caseStatus=$lg(caseGlo,11)
	s caseStatusDesc=##class(DHCINM.Special.SpecialCase).CaseStatusLogicalToDisplay(caseStatus)
	s creator=$lg(caseGlo,12)
	s creatorName=""
	i creator=0 s creatorName="管理员"
	e  i creator'="" d
	.s perGlo=$g(^CF.DHCINM.DB.MgUserD(creator))
	.s creatorName=$lg(perGlo,2)
	s createDate=$lg(caseGlo,13)
	s:createDate'="" createDate=$zd(createDate,3)
	s createTime=$lg(caseGlo,14)
	s:createTime'="" createTime=$zt(createTime,1)
	s auditor=$lg(caseGlo,15)
	s auditorName=""
	i auditor=0 s auditorName="管理员"
	e  i auditor'="" d
	.s perGlo=$g(^CF.DHCINM.DB.MgUserD(auditor))
	.s auditorName=$lg(perGlo,2)
	s auditDate=$lg(caseGlo,16)
	s:auditDate'="" auditDate=$zd(auditDate,3)
	s auditTime=$lg(caseGlo,17)
	s:auditTime'="" auditTime=$zt(auditTime,1)
	s auditOpinion=$lg(caseGlo,18)
	s creatorWard="",auditorWard=""
	i creator'="" d
	.s creatorWard=##class(web.INMHRComm).GetCurrentWard($lg($g(^CF.DHCINM.DB.MgUserD(creator)),5),createDate)
	.s:creatorWard'="" creatorWard=$lg($g(^CF.DHCINM.DB.MgWardD(creatorWard)),4)
	i auditor'="" d
	.s auditorWard=##class(web.INMHRComm).GetCurrentWard($lg($g(^CF.DHCINM.DB.MgUserD(auditor)),5),auditDate)
	.s:auditorWard'="" auditorWard=$lg($g(^CF.DHCINM.DB.MgWardD(auditorWard)),4)
	s ret="CaseWard|"_caseWard_"^CaseWardDesc|"_caseWardDesc_"^CaseNurse|"_caseNurseId_"^CaseNurseName|"_caseNurseName_"^CaseType|"_caseType
	s ret=ret_"^CaseTypeDesc|"_caseTypeDesc_"^CaseParType|"_caseParType_"^CaseParTypeDesc|"_caseParTypeDesc_"^CaseLevel|"_caseLevel
	s ret=ret_"^CaseLevelDesc|"_caseLevelDesc_"^CaseStDate|"_caseStDate_"^CaseEndDate|"_caseEndDate_"^CaseTopic|"_caseTopic_"^CaseWork|"_caseWork
	s ret=ret_"^CaseStatus|"_caseStatus_"^CaseStatusDesc|"_caseStatusDesc_"^Creator|"_creator_"^CreatorName|"_creatorName_"^CreateDate|"_createDate
	s ret=ret_"^CreateTime|"_createTime_"^Auditor|"_auditor_"^AuditorName|"_auditorName_"^AuditDate|"_auditDate_"^AuditTime|"_auditTime_"^AuditOpinion|"_auditOpinion
	s ret=ret_"^rw|"_id_"^AuditorWard|"_auditorWard_"^CreatorWard|"_creatorWard
	q ret
}

/// Description：获取课题专案列表
/// Date:2020-07-23
/// Creator:wangpf
/// Table:DHCINM.Special.SpecialCase
/// Input: 病区^类型^参与形式^级别^开始日期^结束日期^状态 登录人Id
/// Output:课题专案列表
/// Other:d ##class(%ResultSet).RunQuery("web.INMSpecialComm","FindCaseList","^^^^^^",0)
Query FindCaseList(parr As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindCaseListExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i (parr="")||(nurseid="") Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	s ward=$p(parr,"^")
	s type=$p(parr,"^",2)
	s typeList=$lfs(type,",")
	s parType=$p(parr,"^",3)
	s parTypeList=$lfs(parType,",")
	s level=$p(parr,"^",4)
	s levelList=$lfs(level,",")
	s stDate=$p(parr,"^",5)
	s:stDate'="" stDate=$zdh(stDate,3)
	s endDate=$p(parr,"^",6)
	s:endDate'="" endDate=$zdh(endDate,3)
	s status=$p(parr,"^",7)
	s perId=$p(parr,"^",8)
	
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	
	s caseStDate="" f  s caseStDate=$o(^DHCINM.Special.SpecialCaseI("ToolIndex",caseStDate),-1) q:caseStDate=""  d
	.q:(endDate'="")&&(endDate<caseStDate)
	.s caseWard="" f  s caseWard=$o(^DHCINM.Special.SpecialCaseI("ToolIndex",caseStDate,caseWard)) q:caseWard=""  d
	..q:((ward'="")&&(ward'=caseWard))||((isAll'=1)&&('$d(tmpWard(caseWard))))
	..s caseLevel="" f  s caseLevel=$o(^DHCINM.Special.SpecialCaseI("ToolIndex",caseStDate,caseWard,caseLevel)) q:caseLevel=""  d
	...q:(level'="")&&($lf(levelList,$tr(caseLevel," ",""))=0)
	...s caseType="" f  s caseType=$o(^DHCINM.Special.SpecialCaseI("ToolIndex",caseStDate,caseWard,caseLevel,caseType)) q:caseType=""  d
	....q:(type'="")&&($lf(typeList,$tr(caseType," ",""))=0)
	....s caseParType="" f  s caseParType=$o(^DHCINM.Special.SpecialCaseI("ToolIndex",caseStDate,caseWard,caseLevel,caseType,caseParType)) q:caseParType=""  d
	.....q:(parType'="")&&($lf(parTypeList,$tr(caseParType," ",""))=0)
	.....s caseStatus="" f  s caseStatus=$o(^DHCINM.Special.SpecialCaseI("ToolIndex",caseStDate,caseWard,caseLevel,caseType,caseParType,caseStatus)) q:caseStatus=""  d
	......q:(status'="")&&(status'=$tr(caseStatus," ",""))
	......s id="" f  s id=$o(^DHCINM.Special.SpecialCaseI("ToolIndex",caseStDate,caseWard,caseLevel,caseType,caseParType,caseStatus,id)) q:id=""  d
	.......q:'$d(^DHCINM.Special.SpecialCaseD(id))
	.......s caseGlo=^DHCINM.Special.SpecialCaseD(id)
	.......s caseEndDate=$lg(caseGlo,8)
	.......q:(stDate'="")&&(caseEndDate'="")&&(stDate>caseEndDate)
	.......s caseNurse=$lg(caseGlo,3)
	.......q:(perId'="")&&($lf(caseNurse,perId)=0)
	.......s ret=..GetCase(id)
	.......d:ret'="" OutCaseList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutCaseList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindCaseListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCaseListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCaseListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCaseListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Description: 审核课题专案
/// Date: 2020-07-23
/// Creator: wangpf
/// Table: DHCINM.Special.SpecialCase
/// Input: id userid
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMSpecialComm).AuditCase("",0)
ClassMethod AuditCase(parr As %String = "", nurseid As %String = "") As %String
{
	q:(parr="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	
	s status=$p(parr,"^")
	s opinion=$p(parr,"^",2)
	s id=$p(parr,"^",3)
	s obj=##class(DHCINM.Special.SpecialCase).%OpenId(id)
	q:'$IsObject(obj) 0
	s obj.CaseStatus=status
	s obj.AuditOpinion=opinion
	s obj.Auditor=nurseid
	s now=$h
	s obj.AuditDate=+now
	s obj.AuditTime=$p(now,",",2)
	s sc=obj.%Save()
	try{
		i (($$$ISOK(sc))&&((obj.CaseStatus="A")||(obj.CaseStatus="B"))) d
		.s CaseStatus=$case(obj.CaseStatus,"A":"审核","B":"驳回")
		.s CaseType=$case(obj.CaseType,"K":"课题","Z":"专案")
		.s CaseWard=obj.CaseWard.WardDesc
		.s perIdList=$lg($g(^DHCINM.Special.SpecialCaseD(id)),3) 
		.s CaseNurse=""
		.s ptr=0 f  s stat=$listnext(perIdList,ptr,item) q:stat'=1  d
		..s Participant=$p(item,",")
		..i (CaseNurse="") s CaseNurse=$lg($g(^CF.DHCINM.HR.PersonsD(Participant)),2)
		..e  s CaseNurse=CaseNurse_","_$lg($g(^CF.DHCINM.HR.PersonsD(Participant)),2)
		.s CaseParType=$case(obj.CaseParType,"P":"参与","H":"主持","C":"负责","Z":"组织","O":"其他")
		.s CaseLevel=$case(obj.CaseLevel,"H":"护理部","L":"科室","W":"病区")
		.s CaseStDate=$lg($g(^DHCINM.Special.SpecialCaseD(id)),7)
		.s:CaseStDate'="" CaseStDate=$zd(CaseStDate,3)
		.s CaseEndDate=$lg($g(^DHCINM.Special.SpecialCaseD(id)),8)
		.s:CaseEndDate'="" CaseEndDate=$zd(CaseEndDate,3)		
		.s CaseTopic=$lg($g(^DHCINM.Special.SpecialCaseD(id)),9)
		.s Creator=$lg($g(^DHCINM.Special.SpecialCaseD(id)),12)
		.s ret="【专业组/专科活动情况/课题专案】"_CaseStatus_" "_CaseWard_" "_CaseType_" "_CaseParType _" "_CaseLevel_" "_CaseStDate_" "_CaseEndDate_" "_CaseTopic
		.d ##class(web.INMPlatform).SaveTrackMessage(Creator,+$H,ret,"","DHCINM.Special.SpecialCase",id)
	}catch{
		}
	q $$$ISOK(sc)
}

/// Description: 删除课题专案
/// Date: 2020-07-23
/// Creator: wangpf
/// Table: DHCINM.Special.SpecialCase
/// Input: id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMSpecialComm).DeleteCase(1)
ClassMethod DeleteCase(id As %String = "") As %String
{
	q:id="" 0
	s sc=##class(DHCINM.Special.SpecialCase).%DeleteId(id)
	q $$$ISOK(sc)
}

/// Description: 保存专业组年终评分
/// Date: 2020-07-23
/// Creator: wangpf
/// Table: DHCINM.Special.MgGroupScore
/// Input: parr userid
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMSpecialComm).SaveGroupScore("",0)
ClassMethod SaveGroupScore(parr As %String = "", nurseid As %String = "") As %String
{
	q:(parr="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	
	s group=$tr($p(parr,"^"),"_","|")
	s groupPar=$p(group,"||")
	s groupSub=$p(group,"||",2)
	q:(group="")||'$d(^CT.DHCINM.DB.MgSetCodeSubD(groupPar,groupSub)) 0
	s nurse=$p(parr,"^",2)
	q:'$d(^CF.DHCINM.HR.PersonsD(nurse)) 0
	s motScore=$p(parr,"^",3)
	s conScore=$p(parr,"^",4)
	s rw=$p(parr,"^",5)
	
	i rw="" d
	.s obj=##class(DHCINM.Special.MgGroupScore).%New()
	.s obj.Creator=nurseid
	e  s obj=##class(DHCINM.Special.MgGroupScore).%OpenId(rw)
	q:'$IsObject(obj) 0
	d obj.ScorePerSetObjectId(nurse)
	d obj.ScoreTypeSetObjectId(group)
	s obj.ScoreMotivation=$fn(motScore,"",2)
	s obj.ScoreContribute=$fn(conScore,"",2)
	s obj.Updator=nurseid
	s now=$h
	s obj.UpdateDate=+now
	s obj.UpdateTime=$p(now,",",2)
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Description: 获取专业组年终评分
/// Date: 2020-07-23
/// Creator: wangpf
/// Table: DHCINM.Special.MgGroupScore
/// Input: id
/// Output: 专业组年终评分
/// Other: w ##class(web.INMSpecialComm).GetGroupScore(1)
ClassMethod GetGroupScore(id As %String = "") As %String
{
	q:(id="")||('$d(^DHCINM.Special.MgGroupScoreD(id))) ""
	
	s scoreGlo=^DHCINM.Special.MgGroupScoreD(id)
	s scorePer=$lg(scoreGlo,2)
	s scorePerName=""
	i scorePer'="" d
	.s perGlo=$g(^CF.DHCINM.HR.PersonsD(scorePer))
	.s scorePerName=$lg(perGlo,2)
	s scoreGroup=$lg(scoreGlo,3)
	s scoreGroupDesc=""
	i scoreGroup'="" d
	.s groupPar=$p(scoreGroup,"||")
	.s groupSub=$p(scoreGroup,"||",2)
	.s groupGlo=$g(^CT.DHCINM.DB.MgSetCodeSubD(groupPar,groupSub))
	.s scoreGroupDesc=$lg(groupGlo,3)
	s groupMot=$fn($lg(scoreGlo,4),"",2)
	s groupCon=$fn($lg(scoreGlo,5),"",2)
	s total=$fn(groupMot+groupCon,"",2)
	s creator=$lg(scoreGlo,6)
	s creatorName=""
	i creator=0 s creatorName="管理员"
	e  i creator'="" d
	.s perGlo=$g(^CF.DHCINM.DB.MgUserD(creator))
	.s creatorName=$lg(perGlo,2)
	s createDate=$lg(scoreGlo,7)
	s:createDate'="" createDate=$zd(createDate,3)
	s createTime=$lg(scoreGlo,8)
	s:createTime'="" createTime=$zt(createTime,1)
	s updator=$lg(scoreGlo,9)
	s updatorName=""
	i updator=0 s updatorName="管理员"
	e  i updator'="" d
	.s perGlo=$g(^CF.DHCINM.DB.MgUserD(updator))
	.s updatorName=$lg(perGlo,2)
	s updateDate=$lg(scoreGlo,10)
	s:updateDate'="" updateDate=$zd(updateDate,3)
	s updateTime=$lg(scoreGlo,11)
	s:updateTime'="" updateTime=$zt(updateTime,1)
	s ret="ScorePer|"_scorePer_"^ScorePerName|"_scorePerName_"^ScoreGroup|"_$tr(scoreGroup,"|","_")_"^ScoreGroupDesc|"_scoreGroupDesc_"^ScoreMotivation|"_groupMot
	s ret=ret_"^ScoreContribute|"_groupCon_"^ScoreTotal|"_total_"^Creator|"_creator_"^CreatorName|"_creatorName_"^CreateDate|"_createDate
	s ret=ret_"^CreateTime|"_createTime_"^Updator|"_updator_"^UpdatorName|"_updatorName_"^UpdateDate|"_updateDate_"^UpdateTime|"_updateTime_"^rw|"_id
	q ret
}

/// Description：获取专业组年终评分列表
/// Date:2020-07-23
/// Creator:wangpf
/// Table:DHCINM.Special.MgGroupScore
/// Input: 专业组^姓名或工号^开始日期^结束日期 登录人Id
/// Output:专业组年终评分列表
/// Other:d ##class(%ResultSet).RunQuery("web.INMSpecialComm","FindGroupScoreList","^^^",0)
Query FindGroupScoreList(parr As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindGroupScoreListExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i (parr="")||(nurseid="") Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	s group=$tr($p(parr,"^"),"_","|")
	s name=$p(parr,"^",2)
	s stDate=$p(parr,"^",3)
	s:stDate'="" stDate=$zdh(stDate,3)
	s endDate=$p(parr,"^",4)
	s:endDate'="" endDate=$zdh(endDate,3)
	s inPerId=$p(parr,"^",5)
	
	s isOverHLB=..IsPerOverHLB(nurseid)
	
	i isOverHLB'=1 d
	.s userGlo=^CF.DHCINM.DB.MgUserD(nurseid)
	.s perId=$lg(userGlo,5)
	i (isOverHLB'=1)&&(perId="") Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	s scoreGroup="" f  s scoreGroup=$o(^DHCINM.Special.MgGroupScoreI("ToolIndex",scoreGroup)) q:scoreGroup=""  d
	.q:(group'="")&&(group'=scoreGroup)
	.s updateDate="" f  s updateDate=$o(^DHCINM.Special.MgGroupScoreI("ToolIndex",scoreGroup,updateDate)) q:updateDate=""  d
	..q:((stDate'="")&&(stDate>updateDate))||((endDate'="")&&(endDate<updateDate))
	..s id="" f  s id=$o(^DHCINM.Special.MgGroupScoreI("ToolIndex",scoreGroup,updateDate,id)) q:id=""  d
	...q:'$d(^DHCINM.Special.MgGroupScoreD(id))
	...s scoreGlo=^DHCINM.Special.MgGroupScoreD(id)
	...s scorePer=$lg(scoreGlo,2)
	...q:(inPerId'="")&&(inPerId'=scorePer)
	...s parId=$p(scoreGroup,"||")
	...s subId=$p(scoreGroup,"||",2)
	...q:(isOverHLB'=1)&&('$d(^DHCINM.Special.SpecialMemberI("Per",perId,parId_"||"_subId)))
	...s perName="",perID=""
	...i scorePer'="" d
	....s perGlo=$g(^CF.DHCINM.HR.PersonsD(scorePer))
	....s perName=$lg(perGlo,2)
	....s perID=$lg(perGlo,3)
	...q:(name'="")&&(perName_perID'[name)
	...s ret=..GetGroupScore(id)
	...d:ret'="" OutScoreList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutScoreList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindGroupScoreListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindGroupScoreListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindGroupScoreListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindGroupScoreListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Description: 删除专业组年终评分
/// Date: 2020-07-23
/// Creator: wangpf
/// Table: DHCINM.Special.MgGroupScore
/// Input: id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMSpecialComm).DeleteGroupScore(1)
ClassMethod DeleteGroupScore(id As %String = "") As %String
{
	q:id="" 0
	s sc=##class(DHCINM.Special.MgGroupScore).%DeleteId(id)
	q $$$ISOK(sc)
}

/// Description：获取去重专业组成员列表
/// Date:2020-07-24
/// Creator:wangpf
/// Table:DHCINM.Special.SpecialMember
/// Input: groupId
/// Output:去重专业组成员列表
/// Other:d ##class(%ResultSet).RunQuery("web.INMSpecialComm","FindSingleMemberList","^2020-07-24")
Query FindSingleMemberList(parr As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindSingleMemberListExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	s parr=$tr(parr,"_","|")
	
	k tmp
	s now=+$h
	s memGroup="" f  s memGroup=$o(^DHCINM.Special.SpecialMemberI("Group",memGroup)) q:memGroup=""  d
	.s post="" f  s post=$o(^DHCINM.Special.SpecialMemberI("Group",memGroup,post)) q:post=""  d
	..s id="" f  s id=$o(^DHCINM.Special.SpecialMemberI("Group",memGroup,post,id)) q:id=""  d
	...q:'$d(^DHCINM.Special.SpecialMemberD(id))
	...s memGlo=^DHCINM.Special.SpecialMemberD(id)
	...s stDate=$lg(memGlo,5)
	...s endDate=$lg(memGlo,6)
	...q:(stDate="")||((now'="")&&(now<stDate))||((endDate'="")&&(endDate<now))
	...s memPer=$lg(memGlo,2)
	...q:(parr'="")&&('$d(^DHCINM.Special.SpecialMemberI("Per",memPer,parr)))
	...s memGroup=$lg(memGlo,3)
	...s memGroupDesc=""
	...i memGroup'="" d
	....s groupPar=$p(memGroup,"||")
	....s groupSub=$p(memGroup,"||",2)
	....s groupGlo=$g(^CT.DHCINM.DB.MgSetCodeSubD(groupPar,groupSub))
	....s memGroupDesc=$lg(groupGlo,3)
	...i $d(tmp(memPer)) s tmp(memPer)=tmp(memPer)_","_memGroupDesc
	...e  s tmp(memPer)="MemberGroupDesc|"_memGroupDesc
	
	s per="" f  s per=$o(tmp(per)) q:per=""  d
	.s lastAdmDate=""
	.s admId=$o(^DHCINM.Special.SpecialReAdmI("Per",per," A",""))
	.i admId="" s lastAdmDate=$o(^DHCINM.Special.SpecialNurseI("AuthDate",per," A",""))
	.e  d
	..s admGlo=$g(^DHCINM.Special.SpecialReAdmD(admId))
	..s lastAdmDate=$lg(admGlo,10)
	.s lastAdmDate=$zd(lastAdmDate,3)
	.s $p(lastAdmDate,"-")=$p(lastAdmDate,"-")+3
	.s validDate=$zdh(lastAdmDate,3)
	.s diff=validDate-now
	.i diff>=60 s status="有效"
	.e  i (diff>=0)&&(diff<60) s status="即将到期"
	.e  s status="已超期"
	.s ret=tmp(per)
	.s ret=ret_"^StatusDesc|"_status
	.s ret=ret_"^"_..GetNurseInfo(per)
	.d OutMemberList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutMemberList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindSingleMemberListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindSingleMemberListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindSingleMemberListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindSingleMemberListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Description: 保存专科护士再认证记录
/// Date: 2020-07-27
/// Creator: wangpf
/// Table: DHCINM.Special.SpecialReAdm
/// Input: id
/// Output: 0:失败 >0:成功
/// Other: w ##class(web.INMSpecialComm).SaveReAdm(1)
ClassMethod SaveReAdm(parr As %String = "", nurseid As %String = "") As %String
{
	q:(parr="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	
	s per=$p(parr,"^")
	q:(per="")||('$d(^CF.DHCINM.HR.PersonsD(per))) 0
	s score=$p(parr,"^",2)
	s scoreList=$lfs(score,",")
	s pass=$p(parr,"^",3)
	s passList=$lfs(pass,",")
	s status=$p(parr,"^",4)
	s rw=$p(parr,"^",5)
	
	i rw="" d
	.s obj=##class(DHCINM.Special.SpecialReAdm).%New()
	.s obj.Creator=nurseid
	e  s obj=##class(DHCINM.Special.SpecialReAdm).%OpenId(rw)
	q:'$IsObject(obj) 0
	d obj.AdmPerSetObjectId(per)
	d obj.AdmScore.Clear()
	s ptr=0 f  s stat=$listnext(scoreList,ptr,sco) q:stat'=1  d
	.d obj.AdmScore.Insert(sco)
	d obj.AdmPass.Clear()
	s ptr=0 f  s stat=$listnext(passList,ptr,pas) q:stat'=1  d
	.d obj.AdmPass.Insert(pas)
	s obj.AdmStatus=status
	i status="A" d
	.s obj.Auditor=nurseid
	.s now=$h
	.s obj.AuditDate=+now
	.s obj.AuditTime=$p(now,",",2)
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Description: 获取专科护士再认证记录
/// Date: 2020-07-23
/// Creator: wangpf
/// Table: DHCINM.Special.SpecialReAdm
/// Input: id
/// Output: 专科护士再认证记录
/// Other: w ##class(web.INMSpecialComm).GetReAdm(1)
ClassMethod GetReAdm(id As %String = "") As %String
{
	q:(id="")||('$d(^DHCINM.Special.SpecialReAdmD(id))) ""
	
	s admGlo=^DHCINM.Special.SpecialReAdmD(id)
	s admPer=$lg(admGlo,2)
	s admPerName=""
	i admPer'="" d
	.s perGlo=$g(^CF.DHCINM.HR.PersonsD(admPer))
	.s admPerName=$lg(perGlo,2)
	s admScore=$lg(admGlo,3)
	s admScoreDesc=$lts(admScore,",")
	s admPass=$lg(admGlo,4)
	s admPassString=$lts(admPass,",")
	s admPassDesc="",count=1
	s ptr=0 f  s status=$listnext(admPass,ptr,pass) q:status'=1  d
	.s passDesc=$case(pass,"Y":"通过","N":"未通过",:"")
	.i count=1 s admPassDesc=passDesc
	.e  s admPassDesc=admPassDesc_","_passDesc
	.s count=count+1
	s admStatus=$lg(admGlo,5)
	s admStatusDesc=$case(admStatus,"N":"保存","A":"审核","B":"撤销审核",:"")
	s creator=$lg(admGlo,6)
	s creatorName=""
	i creator=0 s creatorName="管理员"
	e  i creator'="" d
	.s perGlo=$g(^CF.DHCINM.DB.MgUserD(creator))
	.s creatorName=$lg(perGlo,2)
	s createDate=$lg(admGlo,7)
	s:createDate'="" createDate=$zd(createDate,3)
	s createTime=$lg(admGlo,8)
	s:createTime'="" createTime=$zt(createTime,1)
	s auditor=$lg(admGlo,9)
	s auditorName=""
	i auditor=0 s auditorName="管理员"
	e  i auditor'="" d
	.s perGlo=$g(^CF.DHCINM.DB.MgUserD(auditor))
	.s auditorName=$lg(perGlo,2)
	s auditeDate=$lg(admGlo,10)
	s:auditeDate'="" auditeDate=$zd(auditeDate,3)
	s auditeTime=$lg(admGlo,11)
	s:auditeTime'="" auditeTime=$zt(auditeTime,1)
	s ret="AdmPer|"_admPer_"^AdmPerName|"_admPerName_"^AdmScore|"_admScoreDesc_"^AdmPass|"_admPassString_"^AdmPassDesc|"_admPassDesc_"^AdmStatus|"_admStatus
	s ret=ret_"^AdmStatusDesc|"_admStatusDesc_"^Creator|"_creator_"^CreatorName|"_creatorName_"^CreateDate|"_createDate_"^CreateTime|"_createTime
	s ret=ret_"^Auditor|"_auditor_"^AuditorName|"_auditorName_"^AuditDate|"_auditeDate_"^AuditDate|"_auditeTime_"^rw|"_id
	q ret
}

/// Description：获取专科护士再认证记录列表
/// Date:2020-07-25
/// Creator:wangpf
/// Table:DHCINM.Special.SpecialReAdm
/// Input: groupId
/// Output:专科护士再认证记录列表
/// Other:d ##class(%ResultSet).RunQuery("web.INMSpecialComm","FindReAdmList","1")
Query FindReAdmList(parr As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindReAdmListExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i parr="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s perGlo=$g(^CF.DHCINM.HR.PersonsD(parr))
	s perName=$lg(perGlo,2)
	
	s now=+$h
	
	s date="" f  s date=$o(^DHCINM.Special.SpecialReAdmI("Audit",parr," A",date),-1) q:date=""  d
	.s id="" f  s id=$o(^DHCINM.Special.SpecialReAdmI("Audit",parr," A",date,id)) q:id=""  d
	..q:'$d(^DHCINM.Special.SpecialReAdmD(id))
	..s admDate=$zd(date,3)
	..s admNextDate=admDate
	..s $p(admNextDate,"-")=$p(admNextDate,"-")+3
	..s admNextDate=$zdh(admNextDate,3)+1
	..i now+60<admNextDate s needReAdm=0
	..e  s needReAdm=1
	..s admNextDate=$zd(admNextDate,3)
	..s ret="Per|"_parr_"^PerName|"_perName_"^AdmDate|"_admDate_"^AdmNextDate|"_admNextDate_"^NeedReAdm|"_needReAdm_"^rw|"_id
	..d OutReAdmList
	
	s firstGroupDate=$o(^DHCINM.Special.SpecialNurseI("AuthDate",parr," A",""))
	i firstGroupDate'="" d
	.s recId=$o(^DHCINM.Special.SpecialNurseI("AuthDate",parr," A",firstGroupDate,""))
	.q:recId=""
	.q:'$d(^DHCINM.Special.SpecialNurseD(recId))
	.s recStDate=$zd(firstGroupDate,3)
	.s admNextDate=recStDate
	.s $p(admNextDate,"-")=$p(admNextDate,"-")+3
	.s admNextDate=$zdh(admNextDate,3)+1
	.i now+60<admNextDate s needReAdm=0
	.e  s needReAdm=1
	.s admNextDate=$zd(admNextDate,3)
	.s ret="Per|"_parr_"^PerName|"_perName_"^AdmDate|"_recStDate_"^AdmNextDate|"_admNextDate_"^NeedReAdm|"_needReAdm_"^rw|"
	.d OutReAdmList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutReAdmList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindReAdmListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindReAdmListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindReAdmListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindReAdmListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Description: 保存会诊资质成员
/// Date: 2020-07-27
/// Creator: wangpf
/// Table: DHCINM.Special.SpecialConsQual
/// Input: id
/// Output: -1:重复 0:失败 1:成功
/// Other: w ##class(web.INMSpecialComm).SaveConsQual("",0)
ClassMethod SaveConsQual(parr As %String = "", nurseid As %String = "") As %String
{
	q:(parr="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	
	s per=$p(parr,"^")
	q:(per="")||('$d(^CF.DHCINM.HR.PersonsD(per))) 0
	s group=$tr($p(parr,"^",2),"_","|")
	s groupPar=$p(group,"||")
	s groupSub=$p(group,"||",2)
	q:(group="")||'$d(^CT.DHCINM.DB.MgSetCodeSubD(groupPar,groupSub)) 0
	s rw=$p(parr,"^",3)
	
	s id=$o(^DHCINM.Special.SpecialMemberI("Per",per,group,""))
	q:id'="" -1
	s id2=$o(^DHCINM.Special.SpecialConsQualI("Per",per,group,""))
	q:(id2'="")&&(id2'=rw) -1
	
	i rw="" d
	.s obj=##class(DHCINM.Special.SpecialConsQual).%New()
	.s obj.Creator=nurseid
	e  s obj=##class(DHCINM.Special.SpecialConsQual).%OpenId(rw)
	q:'$IsObject(obj) 0
	d obj.QualPerSetObjectId(per)
	d obj.QualGroupSetObjectId(group)
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Description: 获取会诊资质成员
/// Date: 2020-07-27
/// Creator: wangpf
/// Table: DHCINM.Special.SpecialConsQual
/// Input: id
/// Output: 会诊资质成员
/// Other: w ##class(web.INMSpecialComm).GetConsQual(1)
ClassMethod GetConsQual(id As %String = "") As %String
{
	q:(id="")||('$d(^DHCINM.Special.SpecialConsQualD(id))) ""
	
	s qualGlo=^DHCINM.Special.SpecialConsQualD(id)
	s qualPer=$lg(qualGlo,2)
	s qualPerName=""
	i qualPer'="" d
	.s perGlo=$g(^CF.DHCINM.HR.PersonsD(qualPer))
	.s qualPerName=$lg(perGlo,2)
	s qualGroup=$lg(qualGlo,3)
	s qualGroupDesc=""
	i qualGroup'="" d
	.s groupPar=$p(qualGroup,"||")
	.s groupSub=$p(qualGroup,"||",2)
	.s groupGlo=$g(^CT.DHCINM.DB.MgSetCodeSubD(groupPar,groupSub))
	.s qualGroupDesc=$lg(groupGlo,3)
	s creator=$lg(qualGlo,4)
	s creatorName=""
	i creator=0 s creatorName="管理员"
	e  i creator'="" d
	.s perGlo=$g(^CF.DHCINM.DB.MgUserD(creator))
	.s creatorName=$lg(perGlo,2)
	s createDate=$lg(qualGlo,5)
	s:createDate'="" createDate=$zd(createDate,3)
	s createTime=$lg(qualGlo,6)
	s:createTime'="" createTime=$zt(createTime,1)
	s ret="QualPer|"_qualPer_"^QualPerName|"_qualPerName_"^QualGroup|"_$tr(qualGroup,"|","_")_"^QualGroupDesc|"_qualGroupDesc
	s ret=ret_"^Creator|"_creator_"^CreatorName|"_creatorName_"^CreateDate|"_createDate_"^CreateTime|"_createTime_"^rw|"_id
	q ret
}

/// Description：获取去重会诊资质成员列表
/// Date:2020-07-27
/// Creator:wangpf
/// Table:DHCINM.Special.SpecialMember 
/// Input: groupId
/// Output:去重会诊资质成员列表
/// Other:d ##class(%ResultSet).RunQuery("web.INMSpecialComm","FindSingleQualList","^")
Query FindSingleQualList(parr As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindSingleQualListExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	s ward=$p(parr,"^")
	s group=$tr($p(parr,"^",2),"_","|")
	s name=$p(parr,"^",3)
	
	k tmp
	s now=+$h
	s memGroup="" f  s memGroup=$o(^DHCINM.Special.SpecialMemberI("Group",memGroup)) q:memGroup=""  d
	.q:(group'="")&&(group'=memGroup)
	.s post="" f  s post=$o(^DHCINM.Special.SpecialMemberI("Group",memGroup,post)) q:post=""  d
	..s id="" f  s id=$o(^DHCINM.Special.SpecialMemberI("Group",memGroup,post,id)) q:id=""  d
	...q:'$d(^DHCINM.Special.SpecialMemberD(id))
	...s memGlo=^DHCINM.Special.SpecialMemberD(id)
	...s stDate=$lg(memGlo,5)
	...s endDate=$lg(memGlo,6)
	...q:(stDate="")||((now'="")&&(now<stDate))||((endDate'="")&&(endDate<now))
	...s memPer=$lg(memGlo,2)
	...s perGlo=$g(^CF.DHCINM.HR.PersonsD(memPer))
	...s perName=$lg(perGlo,2)
	...s perID=$lg(perGlo,3)
	...q:(name'="")&&(perName_perID'[name)
	...s curWard=$lg(perGlo,10)
	...q:(ward'="")&&(ward'=curWard)
	...s memGroup=$lg(memGlo,3)
	...s memGroupDesc=""
	...i memGroup'="" d
	....s groupPar=$p(memGroup,"||")
	....s groupSub=$p(memGroup,"||",2)
	....s groupGlo=$g(^CT.DHCINM.DB.MgSetCodeSubD(groupPar,groupSub))
	....s memGroupDesc=$lg(groupGlo,3)
	...s ret=..GetNurseInfo(memPer)
	...s ret=ret_"^QualGroupDesc|"_memGroupDesc_"^rw|"
	...d OutMemberList
	
	s id="" f  s id=$o(^DHCINM.Special.SpecialConsQualD(id)) q:id=""  d
	.s qualGlo=$g(^DHCINM.Special.SpecialConsQualD(id))
	.s per=$lg(qualGlo,2)
	.s perGlo=$g(^CF.DHCINM.HR.PersonsD(per))
	.s perName=$lg(perGlo,2)
	.s perID=$lg(perGlo,3)
	.q:(name'="")&&(perName_perID'[name)
	.s curWard=$lg(perGlo,10)
	.q:(ward'="")&&(ward'=curWard)
	.s qualGroup=$lg(qualGlo,3)
	.q:(group'="")&&(group'=qualGroup)
	.s Creator=$lg(qualGlo,4)
	.s qualGroupDesc=""
	.i qualGroup'="" d
	..s groupPar=$p(qualGroup,"||")
	..s groupSub=$p(qualGroup,"||",2)
	..s groupGlo=$g(^CT.DHCINM.DB.MgSetCodeSubD(groupPar,groupSub))
	..s qualGroupDesc=$lg(groupGlo,3)
	.s ret=..GetNurseInfo(per)
	.s ret=ret_"^QualGroupDesc|"_qualGroupDesc_"^rw|"_id_"^Creator|"_Creator
	.d OutMemberList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutMemberList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindSingleQualListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindSingleQualListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindSingleQualListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindSingleQualListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Description: 删除会诊资质成员
/// Date: 2020-07-27
/// Creator: wangpf
/// Table: DHCINM.Special.SpecialConsQual
/// Input: id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMSpecialComm).DeleteConsQual(1)
ClassMethod DeleteConsQual(id As %String = "") As %String
{
	q:id="" 0
	s sc=##class(DHCINM.Special.SpecialConsQual).%DeleteId(id)
	q $$$ISOK(sc)
}

/// Other: w ##class(web.INMSpecialComm).SetMemberTmp(1)
ClassMethod SetMemberTmp(group As %String = "", date As %String = "", flag As %String = "", ByRef tmp As %String = "") As %String
{
	s:date["-" date=$zdh(date,3)
	s:date="" date=+$h
	s memGroup="" f  s memGroup=$o(^DHCINM.Special.SpecialMemberI("Group",memGroup)) q:memGroup=""  d
	.q:(group'="")&&(group'=memGroup)
	.s post="" f  s post=$o(^DHCINM.Special.SpecialMemberI("Group",memGroup,post)) q:post=""  d
	..s id="" f  s id=$o(^DHCINM.Special.SpecialMemberI("Group",memGroup,post,id)) q:id=""  d
	...q:'$d(^DHCINM.Special.SpecialMemberD(id))
	...s memGlo=^DHCINM.Special.SpecialMemberD(id)
	...s stDate=$lg(memGlo,5)
	...s endDate=$lg(memGlo,6)
	...q:(stDate="")||((date'="")&&(date<stDate))||((endDate'="")&&(endDate<date))
	...s member=$lg(memGlo,2)
	...q:member=""
	...q:$lg($g(^CF.DHCINM.HR.PersonsD(member)),10)'="17||1"
	...s tmp(member)=1
	i flag=1 d
	.s conId="" f  s conId=$o(^DHCINM.Special.SpecialConsQualD(conId)) q:conId=""  d
	..s conGlo=^DHCINM.Special.SpecialConsQualD(conId)
	..s groupId=$lg(conGlo,3)
	..q:groupId=""
	..q:group'=groupId
	..s perId=$lg(conGlo,2)
	..q:perId=""
	..s perGlo=$g(^CF.DHCINM.HR.PersonsD(perId))
	..q:$lg(perGlo,10)'="17||1"
	..s tmp(member)=1
	q 1
}

/// Description: 保存专业会诊
/// Date: 2020-07-30
/// Creator: wangpf
/// Table: DHCINM.Special.SpecialConsult
/// Input: id
/// Output: 0:失败 1:成功
/// Other: w ##class(web.INMSpecialComm).SaveConsult("",0)
ClassMethod SaveConsult(parr As %String = "", nurseid As %String = "") As %String
{
	q:(parr="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	
	i nurseid=0 s userName="管理员"
	e  d
	.s userGlo=^CF.DHCINM.DB.MgUserD(nurseid)
	.s userName=$lg(userGlo,2)
	
	s type=$p(parr,"^")
	s level=$p(parr,"^",2)
	s regno=$p(parr,"^",3)
	s pat=$p(parr,"^",4)
	s patName=$p(parr,"^",5)
	s patSex=$p(parr,"^",6)
	s patAge=$p(parr,"^",7)
	s situation=$p(parr,"^",8)
	s appDate=$p(parr,"^",9)
	s:appDate["-" appDate=$zdh(appDate,3)
	s appTime=$p(parr,"^",10)
	s:appTime[":" appTime=$zth(appTime,1)
	s contector=$p(parr,"^",11)
	s phone=$p(parr,"^",12)
	s appWard=$p(parr,"^",13)
	q:(appWard="")||('$d(^CF.DHCINM.DB.MgWardD(appWard))) 0
	s target=$p(parr,"^",14)
	s abstract=$p(parr,"^",15)
	s reason=$p(parr,"^",16)
	s status=$p(parr,"^",17)
	s rw=$p(parr,"^",18)
	
	i rw="" d
	.s obj=##class(DHCINM.Special.SpecialConsult).%New()
	.s obj.Creator=nurseid
	e  s obj=##class(DHCINM.Special.SpecialConsult).%OpenId(rw)
	q:'$IsObject(obj) 0
	s obj.ConsultType=type
	s obj.ConsultLevel=level
	d obj.ConsultPAPatMasSetObjectId(pat)
	s obj.ConsultPatName=patName
	s obj.ConsultRegNo=regno
	s obj.ConsultPatSex=patSex
	s obj.ConsultPatAge=patAge
	s obj.ConsultSituation=situation
	s obj.ConsultDate=appDate
	s obj.ConsultTime=appTime
	s obj.ConsultContector=contector
	s obj.ConsultPhone=phone
	d obj.ConsultWardSetObjectId(appWard)
	s obj.ConsultAbstract=abstract
	s obj.ConsultReason=reason
	s obj.ConsultStatus=status
	s sc=obj.%Save()
	s flag=$$$ISOK(sc)
	i flag=1 d
	.k tmp
	.s tmpSubId="" f  s tmpSubId=$o(^DHCINM.Special.SpecialConsSubD(obj.%Id(),tmpSubId)) q:tmpSubId=""  d
	..s tmp(tmpSubId)=0
	.s targetList=$lfs(target,"」")
	.s ptr=0 f  s stat=$listnext(targetList,ptr,sub) q:stat'=1  d
	..q:sub=""
	..s subType=$p(sub,"「")
	..s subValue=$tr($p(sub,"「",2),"_","|")
	..s subPoPer=$p(sub,"「",3)
	..s subId=$p(sub,"「",4)
	..i subId="" d
	...s subObj=##class(DHCINM.Special.SpecialConsSub).%New()
	...s subObj.Parref=obj
	..e  s subObj=##class(DHCINM.Special.SpecialConsSub).%OpenId(obj.%Id()_"||"_subId)
	..q:'$IsObject(subObj)
	..s subObj.SubType=subType
	..s subObj.SubValue=subValue
	..i status="Y" d
	...s tmpHistory="Y「发布「"_$zd(obj.CreateDate,3)_"「"_$zt(obj.CreateTime,1)_"「"_nurseid_"「"_userName
	...d subObj.SubHistory.Insert(tmpHistory)
	..s sc=subObj.%Save()
	..i (sc=1)&&(status="Y") d
	...k messageUser
	...i subType="W" d
	....s perId="" f  s perId=$o(^CF.DHCINM.HR.PersonsI("DepID"," "_subValue,perId)) q:perId=""  d
	.....q:$lg($g(^CF.DHCINM.HR.PersonsD(perId)),10)'="17||1"
	.....s userId=$o(^CF.DHCINM.DB.MgUserI("PerDR"," "_perId,""))
	.....q:userId=""
	.....s messageUser(userId)=1
	...e  d
	....k messagePer
	....d ..SetMemberTmp(subValue,+$h,1,.messagePer)
	....s msgPerId="" f  s msgPerId=$o(messagePer(msgPerId)) q:msgPerId=""  d
	.....s userId=$o(^CF.DHCINM.DB.MgUserI("PerDR"," "_msgPerId,""))
	.....s messageUser(userId)=1
	...s msgUserId="" f  s msgUserId=$o(messageUser(msgUserId)) q:msgUserId=""  d
	....s ret="【专业组/专业会诊】 发布 "_$case(subType,"W":"病区",:"专业组")_" "_$case(level,"H":"全院","L":"科室","W":"病区",:"")
	....s ret=ret_" "_regno_" "_$zd(appDate,3) _" "_$zt(appTime,1)_" "_$lg($g(^CF.DHCINM.DB.MgWardD(appWard)),4)
	....s ret=ret_" "_$case(nurseid,0:"管理员","":"",:$lg($g(^CF.DHCINM.DB.MgUserD(nurseid)),2))
	....d ##class(web.INMPlatform).SaveTrackMessage(msgUserId,+$H,ret,"","DHCINM.Special.SpecialConsSub",obj.%Id()_"||"_subId)
	..s:subId'="" tmp(subId)=1
	.s tmpSubId="" f  s tmpSubId=$o(tmp(tmpSubId)) q:tmpSubId=""  d
	..q:tmp(tmpSubId)=1
	..d ##class(DHCINM.Special.SpecialConsSub).%DeleteId(obj.%Id()_"||"_tmpSubId)
	
	q flag
}

/// Description: 获取专业会诊
/// Date: 2020-07-30
/// Creator: wangpf
/// Table: DHCINM.Special.SpecialConsult
/// Input: id
/// Output: 专业会诊
/// Other: w ##class(web.INMSpecialComm).GetConsult(1)
ClassMethod GetConsult(id As %String = "", flag As %String = "") As %String
{
	q:(id="")||($d(^DHCINM.Special.SpecialConsultD(id))#2'=1) ""
	
	s conGlo=^DHCINM.Special.SpecialConsultD(id)
	s conType=$lg(conGlo,2)
	s conTypeDesc=$case(conType,"C":"平会诊","E":"急会诊",:"")
	s conLevel=$lg(conGlo,3)
	s conLevelDesc=$case(conLevel,"H":"全院","L":"科室","W":"病区",:"")
	s conPat=$lg(conGlo,4)
	s conPatRegNo=$lg(conGlo,5)
	s conPatName=$lg(conGlo,6)
	s conPatSex=$lg(conGlo,7)
	s conPatAge=$lg(conGlo,8)
	s conPatLoc=$lg(conGlo,9)
	s conPatLocDesc=$lg(conGlo,10)
	s conSituation=$lg(conGlo,11)
	s conDate=$lg(conGlo,12)
	s:conDate'="" conDate=$zd(conDate,3)
	s conTime=$lg(conGlo,13)
	s:conTime'="" conTime=$zt(conTime,1)
	s conContector=$lg(conGlo,14)
	s conPhone=$lg(conGlo,15)
	s creator=$lg(conGlo,16)
	s creatorName=""
	i creator=0 s creatorName="管理员"
	e  i creator'="" d
	.s perGlo=$g(^CF.DHCINM.DB.MgUserD(creator))
	.s creatorName=$lg(perGlo,2)
	s conWard=$lg(conGlo,17)
	s conWardDesc=""
	i conWard'="" d
	.s wardGlo=$g(^CF.DHCINM.DB.MgWardD(conWard))
	.s conWardDesc=$lg(wardGlo,4)
	s conAbstract=""
	s:flag=1 conAbstract=$lg(conGlo,18)
	s conReason=""
	s:flag=1 conReason=$lg(conGlo,19)
	s createDate=$lg(conGlo,20)
	s:createDate'="" createDate=$zd(createDate,3)
	s createTime=$lg(conGlo,21)
	s:createTime'="" createTime=$zt(createTime,1)
	s conStatus=$lg(conGlo,22)
	s conStatusDesc=$case(conStatus,"N":"保存","Y":"发布","A":"完成",:"")
	s conTarget="",conPoPerAll=""
	s subId="" f  s subId=$o(^DHCINM.Special.SpecialConsSubD(id,subId)) q:subId=""  d
	.s subGlo=^DHCINM.Special.SpecialConsSubD(id,subId)
	.s subType=$lg(subGlo,2)
	.s subTypeDesc=$case(subType,"W":"病区","G":"专业组",:"")
	.s subValue=$tr($lg(subGlo,3),"|","_")
	.s subValueDesc=""
	.i subValue'="" d
	..i subType="W" d
	...s wardGlo=$g(^CF.DHCINM.DB.MgWardD(subValue))
	...s subValueDesc=$lg(wardGlo,4)
	..e  i subType="G" d
	...s groupPar=$p(subValue,"__")
	...s groupSub=$p(subValue,"__",2)
	...s groupGlo=$g(^CT.DHCINM.DB.MgSetCodeSubD(groupPar,groupSub))
	...s subValueDesc=$lg(groupGlo,3)
	.s subAccPer=$lg(subGlo,4)
	.s subAccPerName=""
	.i subAccPer=0 s subAccPerName="管理员"
	.e  i subAccPer'="" d
	..s userGlo=$g(^CF.DHCINM.DB.MgUserD(subAccPer))
	..s subAccPerName=$lg(userGlo,2)
	.s subAccDate=$lg(subGlo,5)
	.s:subAccDate'="" subAccDate=$zd(subAccDate,3)
	.s subAccTime=$lg(subGlo,6)
	.s:subAccTime'="" subAccTime=$zt(subAccTime,1)
	.s subAccStatus=$lg(subGlo,7)
	.s subAccStatusDesc=$case(subAccStatus,"N":"拒绝","Y":"接收",:"")
	.s subPoPer=$lg(subGlo,8)
	.s subPoPerName="",subPoPerPost="",subPoPerLevel=""
	.i subPoPer'="" d
	..s perGlo=$g(^CF.DHCINM.HR.PersonsD(subPoPer))
	..s subPoPerName=$lg(perGlo,2)
	..s subPoPerPost=$p(##class(web.INMHRComm).GetNurseHireDuty(subPoPer,+$h),"^",2)
	..s subPoPerLevel=$p(##class(web.INMHRComm).GetNurseLevel(subPoPer,+$h),"^",2)
	.i conPoPerAll="" s conPoPerAll=subPoPerName
	.e  s conPoPerAll=conPoPerAll_","_subPoPerName
	.s subPoDate=$lg(subGlo,9)
	.s:subPoDate'="" subPoDate=$zd(subPoDate,3)
	.s subPoTime=$lg(subGlo,10)
	.s:subPoTime'="" subPoTime=$zt(subPoTime,1)
	.s subPoStatus=$lg(subGlo,11)
	.s subPoStatusDesc=$case(subPoStatus,"N":"拒绝","Y":"接收",:"")
	.s subPoStatusDate=$lg(subGlo,12)
	.s:subPoStatusDate'="" subPoStatusDate=$zd(subPoStatusDate,3)
	.s subPoStatusTime=$lg(subGlo,13)
	.s:subPoStatusTime'="" subPoStatusTime=$zt(subPoStatusTime,1)
	.s subConclusion=""
	.s:flag=1 subConclusion=$lg(subGlo,14)
	.s subFinish=$lg(subGlo,16)
	.s subFinishDate=$lg(subGlo,17)
	.s:subFinishDate'="" subFinishDate=$zd(subFinishDate,3)
	.s subFinishTime=$lg(subGlo,18)
	.s:subFinishTime'="" subFinishTime=$zt(subFinishTime,1)
	.s curStatDate="",curStatTime=""
	.i conStatus="N" s curStatDate=createDate,curStatTime=createTime
	.e  i conStatus="A" s curStatDate=subFinishDate,curStatTime=subFinishTime
	.s subHistory=$lg(subGlo,15)
	.s subHistory=$lts(subHistory,"ˇ")
	.s subHistory=$tr(subHistory,"「","ˊ")
	.i conTarget="" s conTarget=subType_"「"_subTypeDesc_"「"_subValue_"「"_subValueDesc_"「"_subAccPer_"「"_subAccPerName_"「"_subAccDate_"「"_subAccTime_"「"_subAccStatus_"「"_subAccStatusDesc_"「"_subPoPer_"「"_subPoPerName_"「"_subPoPerLevel_"「"_subPoPerPost_"「"_subPoDate_"「"_subPoTime_"「"_subPoStatus_"「"_subPoStatusDesc_"「"_subPoStatusDate_"「"_subPoStatusTime_"「"_subConclusion_"「"_subFinish_"「"_curStatDate_"「"_curStatTime_"「"_subHistory_"「"_subId
	.e  s conTarget=conTarget_"」"_subType_"「"_subTypeDesc_"「"_subValue_"「"_subValueDesc_"「"_subAccPer_"「"_subAccPerName_"「"_subAccDate_"「"_subAccTime_"「"_subAccStatus_"「"_subAccStatusDesc_"「"_subPoPer_"「"_subPoPerName_"「"_subPoPerLevel_"「"_subPoPerPost_"「"_subPoDate_"「"_subPoTime_"「"_subPoStatus_"「"_subPoStatusDesc_"「"_subPoStatusDate_"「"_subPoStatusTime_"「"_subConclusion_"「"_subFinish_"「"_curStatDate_"「"_curStatTime_"「"_subHistory_"「"_subId
	s ret="ConsultType|"_conType_"^ConsultTypeDesc|"_conTypeDesc_"^ConsultLevel|"_conLevel_"^ConsultLevelDesc|"_conLevelDesc_"^ConsultPAPatMas|"_conPat
	s ret=ret_"^ConsultRegNo|"_conPatRegNo_"^ConsultPatName|"_conPatName_"^ConsultPatSex|"_conPatSex_"^ConsultPatAge|"_conPatAge_"^ConsultCTLoc|"_conPatLoc
	s ret=ret_"^ConsultCTLocDesc|"_conPatLocDesc_"^ConsultSituation|"_conSituation_"^ConsultDate|"_conDate_"^ConsultTime|"_conTime_"^ConsultContector|"_conContector
	s ret=ret_"^ConsultPhone|"_conPhone_"^Creator|"_creator_"^CreatorName|"_creatorName_"^ConsultWard|"_conWard_"^ConsultWardDesc|"_conWardDesc_"^ConsultAbstract|"_conAbstract
	s ret=ret_"^ConsultReason|"_conReason_"^CreateDate|"_createDate_"^CreateTime|"_createTime_"^ConsultStatus|"_conStatus_"^ConsultStatusDesc|"_conStatusDesc
	s ret=ret_"^ConsultTarget|"_conTarget_"^ConsultPoPerAll|"_conPoPerAll_"^rw|"_id
	q ret
}

/// Description: 获取专业会诊
/// Date: 2020-08-01
/// Creator: wangpf
/// Table: DHCINM.Special.SpecialConsSub
/// Input: id
/// Output: 专业会诊
/// Other: w ##class(web.INMSpecialComm).GetConsultSub(1)
ClassMethod GetConsultSub(id As %String = "", flag As %String = "") As %String
{
	q:id="" ""
	s id=$tr(id,"_","|")
	s parId=$p(id,"||")
	s subId=$p(id,"||",2)
	q:'$d(^DHCINM.Special.SpecialConsSubD(parId,subId)) ""
	
	s conGlo=^DHCINM.Special.SpecialConsultD(parId)
	s conType=$lg(conGlo,2)
	s conTypeDesc=$case(conType,"C":"平会诊","E":"急会诊",:"")
	s conLevel=$lg(conGlo,3)
	s conLevelDesc=$case(conLevel,"H":"全院","L":"科室","W":"病区",:"")
	s conPat=$lg(conGlo,4)
	s conPatRegNo=$lg(conGlo,5)
	s conPatName=$lg(conGlo,6)
	s conPatSex=$lg(conGlo,7)
	s conPatAge=$lg(conGlo,8)
	s conPatLoc=$lg(conGlo,9)
	s conPatLocDesc=$lg(conGlo,10)
	s conSituation=$lg(conGlo,11)
	s conDate=$lg(conGlo,12)
	s:conDate'="" conDate=$zd(conDate,3)
	s conTime=$lg(conGlo,13)
	s:conTime'="" conTime=$zt(conTime,1)
	s conContector=$lg(conGlo,14)
	s conPhone=$lg(conGlo,15)
	s creator=$lg(conGlo,16)
	s creatorName=""
	i creator=0 s creatorName="管理员"
	e  i creator'="" d
	.s perGlo=$g(^CF.DHCINM.DB.MgUserD(creator))
	.s creatorName=$lg(perGlo,2)
	s conWard=$lg(conGlo,17)
	s conWardDesc=""
	i conWard'="" d
	.s wardGlo=$g(^CF.DHCINM.DB.MgWardD(conWard))
	.s conWardDesc=$lg(wardGlo,4)
	s conAbstract=""
	s:flag=1 conAbstract=$lg(conGlo,18)
	s conReason=""
	s:flag=1 conReason=$lg(conGlo,19)
	s createDate=$lg(conGlo,20)
	s:createDate'="" createDate=$zd(createDate,3)
	s createTime=$lg(conGlo,21)
	s:createTime'="" createTime=$zt(createTime,1)
	s conStatus=$lg(conGlo,22)
	s conStatusDesc=$case(conStatus,"N":"保存","Y":"发布",:"")
	s subGlo=^DHCINM.Special.SpecialConsSubD(parId,subId)
	s subType=$lg(subGlo,2)
	s subTypeDesc=$case(subType,"W":"病区","G":"专业组",:"")
	s subValue=$tr($lg(subGlo,3),"|","_")
	s subValueDesc=""
	i subValue'="" d
	.i subType="W" d
	..s wardGlo=$g(^CF.DHCINM.DB.MgWardD(subValue))
	..s subValueDesc=$lg(wardGlo,4)
	.e  i subType="G" d
	..s groupPar=$p(subValue,"__")
	..s groupSub=$p(subValue,"__",2)
	..s groupGlo=$g(^CT.DHCINM.DB.MgSetCodeSubD(groupPar,groupSub))
	..s subValueDesc=$lg(groupGlo,3)
	s subAccPer=$lg(subGlo,4)
	s subAccPerName=""
	i subAccPer=0 s subAccPerName="管理员"
	e  i subAccPer'="" d
	.s userGlo=$g(^CF.DHCINM.DB.MgUserD(subAccPer))
	.s subAccPerName=$lg(userGlo,2)
	s subAccDate=$lg(subGlo,5)
	s:subAccDate'="" subAccDate=$zd(subAccDate,3)
	s subAccTime=$lg(subGlo,6)
	s:subAccTime'="" subAccTime=$zt(subAccTime,1)
	s subAccStatus=$lg(subGlo,7)
	s subAccStatusDesc=$case(subAccStatus,"N":"拒绝","Y":"接收",:"")
	s subPoPer=$lg(subGlo,8)
	s subPoPerName="",subPoPerPost="",subPoPerLevel=""
	i subPoPer'="" d
	.s perGlo=$g(^CF.DHCINM.HR.PersonsD(subPoPer))
	.s subPoPerName=$lg(perGlo,2)
	.s subPoPerPost=$p(##class(web.INMHRComm).GetNurseHireDuty(subPoPer,+$h),"^",2)
	.s subPoPerLevel=$p(##class(web.INMHRComm).GetNurseLevel(subPoPer,+$h),"^",2)
	s subPoDate=$lg(subGlo,9)
	s:subPoDate'="" subPoDate=$zd(subPoDate,3)
	s subPoTime=$lg(subGlo,10)
	s:subPoTime'="" subPoTime=$zt(subPoTime,1)
	s subPoStatus=$lg(subGlo,11)
	s subPoStatusDesc=$case(subPoStatus,"N":"拒绝","Y":"接收",:"")
	s subPoStatusDate=$lg(subGlo,12)
	s:subPoStatusDate'="" subPoStatusDate=$zd(subPoStatusDate,3)
	s subPoStatusTime=$lg(subGlo,13)
	s:subPoStatusTime'="" subPoStatusTime=$zt(subPoStatusTime,1)
	s subConclusion=""
	s:flag=1 subConclusion=$lg(subGlo,14)
	s subFinish=$lg(subGlo,16)
	s subFinishDate=$lg(subGlo,17)
	s:subFinishDate'="" subFinishDate=$zd(subFinishDate,3)
	s subFinishTime=$lg(subGlo,18)
	s:subFinishTime'="" subFinishTime=$zt(subFinishTime,1)
	s curStatDate="",curStatTime=""
	i subAccStatus="N" s conStatusDesc=conStatusDesc_"(拒绝申请)",curStatDate=subAccDate,curStatTime=subAccTime
	e  i subAccStatus="Y" d
	.i subPoStatus="" d
	..i subPoPer="" s conStatusDesc=conStatusDesc_"(接收申请)",curStatDate=subAccDate,curStatTime=subAccTime
	..e  s conStatusDesc=conStatusDesc_"(派遣)",curStatDate=subPoStatusDate,curStatTime=subPoStatusTime
	.e  i subPoStatus="N" s conStatusDesc=conStatusDesc_"(拒绝派遣)",curStatDate=subPoStatusDate,curStatTime=subPoStatusTime
	.e  i subPoStatus="Y" d
	..i subFinish="Y" s conStatusDesc=conStatusDesc_"(完成)",curStatDate=subFinishDate,curStatTime=subFinishTime
	..e  s conStatusDesc=conStatusDesc_"(接收派遣)",curStatDate=subPoStatusDate,curStatTime=subPoStatusTime
	s subHistory=$lg(subGlo,15)
	s subHistory=$lts(subHistory,"ˇ")
	s subHistory=$tr(subHistory,"「","ˊ")
	s conTarget=subType_"「"_subTypeDesc_"「"_subValue_"「"_subValueDesc_"「"_subAccPer_"「"_subAccPerName_"「"_subAccDate_"「"_subAccTime_"「"_subAccStatus_"「"_subAccStatusDesc_"「"_subPoPer_"「"_subPoPerName_"「"_subPoPerLevel_"「"_subPoPerPost_"「"_subPoDate_"「"_subPoTime_"「"_subPoStatus_"「"_subPoStatusDesc_"「"_subPoStatusDate_"「"_subPoStatusTime_"「"_subConclusion_"「"_subFinish_"「"_curStatDate_"「"_curStatTime_"「"_subHistory_"「"_subId
	s ret="ConsultType|"_conType_"^ConsultTypeDesc|"_conTypeDesc_"^ConsultLevel|"_conLevel_"^ConsultLevelDesc|"_conLevelDesc_"^ConsultPAPatMas|"_conPat
	s ret=ret_"^ConsultRegNo|"_conPatRegNo_"^ConsultPatName|"_conPatName_"^ConsultPatSex|"_conPatSex_"^ConsultPatAge|"_conPatAge_"^ConsultCTLoc|"_conPatLoc
	s ret=ret_"^ConsultCTLocDesc|"_conPatLocDesc_"^ConsultSituation|"_conSituation_"^ConsultDate|"_conDate_"^ConsultTime|"_conTime_"^ConsultContector|"_conContector
	s ret=ret_"^ConsultPhone|"_conPhone_"^Creator|"_creator_"^CreatorName|"_creatorName_"^ConsultWard|"_conWard_"^ConsultWardDesc|"_conWardDesc_"^ConsultAbstract|"_conAbstract
	s ret=ret_"^ConsultReason|"_conReason_"^CreateDate|"_createDate_"^CreateTime|"_createTime_"^ConsultStatus|"_conStatus_"^ConsultStatusDesc|"_conStatusDesc
	s ret=ret_"^ConsultTarget|"_conTarget_"^rw|"_$tr(id,"|","_")
	q ret
}

/// Description：获取专业会诊列表
/// Date:2020-07-30
/// Creator:wangpf
/// Table:DHCINM.Special.SpecialConsult
/// Input: groupId
/// Output:专业会诊列表
/// Other:d ##class(%ResultSet).RunQuery("web.INMSpecialComm","FindConsultList","^^^2020-07-01^2020-07-31^",0)
Query FindConsultList(parr As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindConsultListExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i (parr="")||(nurseid="") Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	s ward=$p(parr,"^")
	s type=$p(parr,"^",2)
	s typeList=$lfs(type,",")
	s level=$p(parr,"^",3)
	s levelList=$lfs(level,",")
	s stDate=$p(parr,"^",4)
	s:stDate["-" stDate=$zdh(stDate,3)
	s endDate=$p(parr,"^",5)
	s:endDate["-" endDate=$zdh(endDate,3)
	s status=$p(parr,"^",6)
	s statusList=$lfs(status,",")
	s perId=$p(parr,"^",7)
	
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	k tmpGroup
	s isAllGroup=..SetRoleGroup(nurseid,.tmpGroup)
	
	s conDate="" f  s conDate=$o(^DHCINM.Special.SpecialConsultI("ToolIndex",conDate),-1) q:conDate=""  d
	.q:((stDate'="")&&(stDate>conDate))||((endDate'="")&&(endDate<conDate))
	.s conStatus="" f  s conStatus=$o(^DHCINM.Special.SpecialConsultI("ToolIndex",conDate,conStatus)) q:conStatus=""  d
	..s tmpStatus=$tr(conStatus," ","")
	..q:(status'="")&&($lf(statusList,tmpStatus)=0)
	..s conWard="" f  s conWard=$o(^DHCINM.Special.SpecialConsultI("ToolIndex",conDate,conStatus,conWard)) q:conWard=""  d
	...q:((ward'="")&&(ward'=conWard))
	...s conType="" f  s conType=$o(^DHCINM.Special.SpecialConsultI("ToolIndex",conDate,conStatus,conWard,conType)) q:conType=""  d
	....q:(type'="")&&($lf(typeList,$tr(conType," ",""))=0)
	....s conLevel="" f  s conLevel=$o(^DHCINM.Special.SpecialConsultI("ToolIndex",conDate,conStatus,conWard,conType,conLevel)) q:conLevel=""  d
	.....q:(level'="")&&($lf(levelList,$tr(conLevel," ",""))=0)
	.....s id="" f  s id=$o(^DHCINM.Special.SpecialConsultI("ToolIndex",conDate,conStatus,conWard,conType,conLevel,id)) q:id=""  d
	......q:$d(^DHCINM.Special.SpecialConsultD(id))#2'=1
	......s conGlo=^DHCINM.Special.SpecialConsultD(id)
	......i tmpStatus="N" d
	.......s creator=$lg(conGlo,16)
	.......q:(creator'=nurseid)&&(nurseid'=0)
	.......s ret=..GetConsult(id)
	.......d:ret'="" OutConsultList
	......e  i tmpStatus="Y" d
	.......s flag1=0
	.......s creator=$lg(conGlo,16)
	.......s:creator=nurseid flag1=1
	.......s:(isAll=1)||($d(tmpWard(conWard))) flag1=1
	.......s subId="" f  s subId=$o(^DHCINM.Special.SpecialConsSubD(id,subId)) q:subId=""  d
	........s flag2=0
	........s subGlo=^DHCINM.Special.SpecialConsSubD(id,subId)
	........s subType=$lg(subGlo,2)
	........s subTypeValue=$lg(subGlo,3)
	........i (subType="W")&&((isAll=1)||($d(tmpWard(subTypeValue)))) s flag2=1
	........e  i (subType="G")&&((isAllGroup=1)||($d(tmpGroup(subTypeValue)))) s flag2=1
	........q:(flag1'=1)&&(flag2'=1)&&(nurseid'=0)
	........s ret=..GetConsultSub(id_"||"_subId)
	........d:ret'="" OutConsultList
	......e  i tmpStatus="A" d
	.......s flag3=0,flag4=0
	.......s creator=$lg(conGlo,16)
	.......s subId="" f  s subId=$o(^DHCINM.Special.SpecialConsSubD(id,subId)) q:(subId="")||(flag3=1)  d
	........s subGlo=^DHCINM.Special.SpecialConsSubD(id,subId)
	........s subType=$lg(subGlo,2)
	........s subTypeValue=$lg(subGlo,3)
	........i (subType="W")&&((isAll=1)||($d(tmpWard(subTypeValue)))) s flag3=1
	........e  i (subType="G")&&((isAllGroup=1)||($d(tmpGroup(subTypeValue)))) s flag3=1
	........s subPoPer=$lg(subGlo,8)
	........s:subPoPer=perId flag4=1
	.......s:creator=nurseid flag3=1
	.......s:(isAll=1)||($d(tmpWard(conWard))) flag3=1
	.......q:(flag3'=1)&&(nurseid'=0)
	.......q:(perId'="")&&(flag4'=1)
	.......s ret=..GetConsult(id)
	.......d:ret'="" OutConsultList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutConsultList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindConsultListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindConsultListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindConsultListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindConsultListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Description: 获取人员资质专业组
/// Date: 2020-08-01
/// Creator: wangpf
/// Table: DHCINM.Special.SpecialMember DHCINM.Special.SpecialConsQual
/// Input: nurseid
/// Output: 0:非护理部 1:护理部及以上
/// Other: w ##class(web.INMSpecialComm).SetRoleGroup(1,.tmp)
ClassMethod SetRoleGroup(nurseid As %String = "", tmp As %String = "") As %String
{
	q:(nurseid="")||((nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid)))) 0
	
	s flag=0
	s flag=..IsPerOverHLB(nurseid)
	q:flag=1 1
	
	s parId=$o(^CT.DHCINM.DB.MgSetCodeI("Code"," 专业组",""))
	q:parId="" 0
	
	s userGlo=^CF.DHCINM.DB.MgUserD(nurseid)
	s perId=$lg(userGlo,5)
	q:perId="" 0
	
	s subId="" f  s subId=$o(^CT.DHCINM.DB.MgSetCodeSubD(parId,subId)) q:subId=""  d
	.s subGlo=^CT.DHCINM.DB.MgSetCodeSubD(parId,subId)
	.s stDate=$lg(subGlo,5)
	.s endDate=$lg(subGlo,6)
	.s now=+$h
	.q:(stDate>now)||((endDate'="")&&(endDate<now))
	.q:'$d(^DHCINM.Special.SpecialMemberI("Per",perId,parId_"||"_subId))
	.s tmp(parId_"||"_subId)=1
	
	s groupId="" f  s groupId=$o(^DHCINM.Special.SpecialConsQualI("Per",perId,groupId)) q:groupId=""  d
	.s tmp(groupId)=1
	
	q flag
}

/// Description: 获取人员资质专业组列表
/// Date: 2020-08-01
/// Creator: wangpf
/// Table: DHCINM.Special.SpecialMember DHCINM.Special.SpecialConsQual
/// Input: nurseid
/// Output: 专业组列表
/// Other:d ##class(%ResultSet).RunQuery("web.INMSpecialComm","FindRoleQualList","0")
Query FindRoleQualList(nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindRoleQualListExecute(ByRef qHandle As %Binary, nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i nurseid="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	s parId=$o(^CT.DHCINM.DB.MgSetCodeI("Code"," 专业组",""))
	i parId="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	s isOverHLB=..IsPerOverHLB(nurseid)
	
	i isOverHLB'=1 d
	.s userGlo=^CF.DHCINM.DB.MgUserD(nurseid)
	.s perId=$lg(userGlo,5)
	i (isOverHLB'=1)&&(perId="") Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	s subId="" f  s subId=$o(^CT.DHCINM.DB.MgSetCodeSubD(parId,subId)) q:subId=""  d
	.s subGlo=^CT.DHCINM.DB.MgSetCodeSubD(parId,subId)
	.s subCode=$lg(subGlo,2)
	.s subDesc=$lg(subGlo,3)
	.s stDate=$lg(subGlo,5)
	.s endDate=$lg(subGlo,6)
	.s now=+$h
	.q:(stDate>now)||((endDate'="")&&(endDate<now))
	.q:(isOverHLB'=1)&&('$d(^DHCINM.Special.SpecialMemberI("Per",perId,parId_"||"_subId)))&&('$d(^DHCINM.Special.SpecialConsQualI("Per",perId,parId_"||"_subId)))
	.s ret="SubCode|"_subCode_"^SubDesc|"_subDesc_"^SubValue|"_parId_"__"_subId
	.d OutGroupList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutGroupList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindRoleQualListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindRoleQualListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindRoleQualListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindRoleQualListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Description: 保存专业会诊子表
/// Date: 2020-08-01
/// Creator: wangpf
/// Table: DHCINM.Special.SpecialConsSub
/// Input: parr
/// Output: 0:失败 1:成功
/// Other: w ##class(web.INMSpecialComm).SaveConsultSub("",0)
ClassMethod SaveConsultSub(parr As %String = "", nurseid As %String = "") As %String
{
	q:(parr="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	
	s parr=$tr(parr,"_","|")
	s type=$p(parr,"^")
	s typeValue=$p(parr,"^",2)
	s subId=$p(parr,"^",3)
	
	s subObj=##class(DHCINM.Special.SpecialConsSub).%OpenId(subId)
	q:'$IsObject(subObj)
	s subObj.SubType=type
	s subObj.SubValue=typeValue
	s subObj.SubAccPer=""
	s subObj.SubAccStatus=""
	s subObj.SubAccDate=""
	s subObj.SubAccTime=""
	s now=$h
	s nowDate=+now
	s nowTime=$p(now,",",2)
	i nurseid=0 s userName="管理员"
	e  d
	.s userGlo=^CF.DHCINM.DB.MgUserD(nurseid)
	.s userName=$lg(userGlo,2)
	s tmpHistory="Y「发布「"_$zd(nowDate,3)_"「"_$zt(nowTime,1)_"「"_nurseid_"「"_userName
	d subObj.SubHistory.Insert(tmpHistory)
	s sc=subObj.%Save()
	
	q $$$ISOK(sc)
}

/// Description: 保存专业会诊子表接收状态
/// Date: 2020-08-01
/// Creator: wangpf
/// Table: DHCINM.Special.SpecialConsSub
/// Input: parr
/// Output: 0:失败 1:成功
/// Other: w ##class(web.INMSpecialComm).SaveConsultAcc("",0)
ClassMethod SaveConsultAcc(parr As %String = "", nurseid As %String = "") As %String
{
	q:(parr="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	
	i nurseid=0 s userName="管理员"
	e  d
	.s userGlo=^CF.DHCINM.DB.MgUserD(nurseid)
	.s userName=$lg(userGlo,2)
	
	s parr=$tr(parr,"_","|")
	s subId=$p(parr,"^")
	s subIdList=$lfs(subId,",")
	s status=$p(parr,"^",2)
	
	s now=$h
	s nowDateH=+now
	s nowTimeH=$p(now,",",2)
	s nowDate=$zd(nowDateH,3)
	s nowTime=$zt(nowTimeH,1)
	s ptr=0 f  s stat=$listnext(subIdList,ptr,id) q:stat'=1  d
	.s subObj=##class(DHCINM.Special.SpecialConsSub).%OpenId(id)
	.q:'$IsObject(subObj)
	.s subObj.SubAccPer=nurseid
	.s subObj.SubAccStatus=status
	.s subObj.SubAccDate=nowDateH
	.s subObj.SubAccTime=nowTimeH
	.s tmpHistory=status_"「"_$case(status,"Y":"接收","N":"拒绝接收",:"")_"「"_nowDate_"「"_nowTime_"「"_nurseid_"「"_userName
	.d subObj.SubHistory.Insert(tmpHistory)
	.s sc=subObj.%Save()
	.i sc=1 d
	..s ret="【专业组/专业会诊】"_$case(status,"Y":"接收","N":"拒绝接收",:"")_" "_subObj.Parref.ConsultRegNo
	..s ret=ret_" "_$case(nurseid,0:"管理员","":"",:$lg($g(^CF.DHCINM.DB.MgUserD(nurseid)),2))
	..s ret=ret_" "_nowDate_" "_nowTime
	..d ##class(web.INMPlatform).SaveTrackMessage(subObj.Parref.Creator,+$H,ret,"","DHCINM.Special.SpecialConsSub",id)
	
	q 1
}

/// Description: 保存专业会诊子表派遣人
/// Date: 2020-08-01
/// Creator: wangpf
/// Table: DHCINM.Special.SpecialConsSub
/// Input: parr
/// Output: 0:失败 1:成功
/// Other: w ##class(web.INMSpecialComm).SaveConsultPoPer("",0)
ClassMethod SaveConsultPoPer(parr As %String = "", nurseid As %String = "") As %String
{
	q:(parr="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	
	s parr=$tr(parr,"_","|")
	s per=$p(parr,"^")
	q:'$d(^CF.DHCINM.HR.PersonsD(per)) 0
	s subId=$p(parr,"^",2)
	
	s now=$h
	s nowDateH=+now
	s nowTimeH=$p(now,",",2)
	s nowDate=$zd(nowDateH,3)
	s nowTime=$zt(nowTimeH,1)
	s subObj=##class(DHCINM.Special.SpecialConsSub).%OpenId(subId)
	q:'$IsObject(subObj) 0
	d subObj.SubPoPerSetObjectId(per)
	s subObj.SubPoDate=nowDateH
	s subObj.SubPoTime=nowTimeH
	s subObj.SubPoStatus=""
	s subObj.SubPoStatusDate=""
	s subObj.SubPoStatusTime=""
	i nurseid=0 s userName="管理员"
	e  d
	.s userGlo=^CF.DHCINM.DB.MgUserD(nurseid)
	.s userName=$lg(userGlo,2)
	s tmpHistory="Y「派遣「"_nowDate_"「"_nowTime_"「"_nurseid_"「"_userName
	d subObj.SubHistory.Insert(tmpHistory)
	s sc=subObj.%Save()
	try{
		i (($$$ISOK(sc))&&((subObj.SubAccStatus="Y")||(subObj.SubAccStatus="N"))) d
		.s SubAccStatus=$case(subObj.SubAccStatus,"Y":"派遣","N":"拒绝")
		.s PObj=subObj.Parref
		.s ConsultType=$case(PObj.ConsultType,"C":"平会诊","E":"急会诊")
		.s ConsultLevel=$case(PObj.ConsultLevel,"H":"全院","L":"科室","W":"病区")
		.s ConsultRegNo=PObj.ConsultRegNo
		.s ConsultDate=PObj.ConsultDate
		.s:ConsultDate'="" ConsultDate=$zd(ConsultDate,3)
		.s ConsultTime=PObj.ConsultTime
		.s:ConsultTime'="" ConsultTime=$zt(""_ConsultTime_"",3)
		.s ConsultWardId=PObj.ConsultWard.WardCode
		.s ConsultWard=PObj.ConsultWard.WardDesc
		.s SubAccPer=subObj.SubPoPer.PerName
		.s Creator=PObj.Creator		
		.s now=$h
		.s nowDate=+now
		.s nowTime=$p(now,",",2)
		.s ret="【专业组/专业会诊】"_SubAccStatus_" "_ConsultRegNo_" "_subObj.SubPoPer.PerName_" "_$zd(nowDate,3)_" "_$zt(nowTime,1)
		.d ##class(web.INMPlatform).SaveTrackMessage(Creator,+$H,ret,"","DHCINM.Special.SpecialConsSub",subId)
	}catch{
		}
	q $$$ISOK(sc)
}

/// Description: 保存专业会诊子表派遣状态
/// Date: 2020-08-01
/// Creator: wangpf
/// Table: DHCINM.Special.SpecialConsSub
/// Input: parr
/// Output: 0:失败 1:成功
/// Other: w ##class(web.INMSpecialComm).SavePoPerStatus("",0)
ClassMethod SavePoPerStatus(parr As %String = "", nurseid As %String = "") As %String
{
	q:(parr="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	
	i nurseid=0 s userName="管理员"
	e  d
	.s userGlo=^CF.DHCINM.DB.MgUserD(nurseid)
	.s userName=$lg(userGlo,2)
	
	s parr=$tr(parr,"_","|")
	s subId=$p(parr,"^")
	s subIdList=$lfs(subId,",")
	s status=$p(parr,"^",2)
	
	s now=$h
	s nowDateH=+now
	s nowTimeH=$p(now,",",2)
	s nowDate=$zd(nowDateH,3)
	s nowTime=$zt(nowTimeH,1)
	s ptr=0 f  s stat=$listnext(subIdList,ptr,id) q:stat'=1  d
	.s subObj=##class(DHCINM.Special.SpecialConsSub).%OpenId(id)
	.q:'$IsObject(subObj)
	.s subObj.SubPoStatus=status
	.s subObj.SubPoStatusDate=nowDateH
	.s subObj.SubPoStatusTime=nowTimeH
	.s tmpHistory=status_"「"_$case(status,"Y":"接收派遣","N":"拒绝派遣",:"")_"「"_nowDate_"「"_nowTime_"「"_nurseid_"「"_userName
	.d subObj.SubHistory.Insert(tmpHistory)
	.s sc=subObj.%Save()
	.i sc=1 d
	..s ret="【专业组/专业会诊】"_$case(status,"Y":"接收派遣","N":"拒绝派遣",:"")_" "_subObj.Parref.ConsultRegNo
	..s ret=ret_" "_$case(nurseid,0:"管理员","":"",:$lg($g(^CF.DHCINM.DB.MgUserD(nurseid)),2))
	..s ret=ret_" "_nowDate_" "_nowTime
	..d ##class(web.INMPlatform).SaveTrackMessage(subObj.SubAccPer,+$H,ret,"","DHCINM.Special.SpecialConsSub",id)
	..d ##class(web.INMPlatform).SaveTrackMessage(subObj.Parref.Creator,+$H,ret,"","DHCINM.Special.SpecialConsSub",id)
	
	q 1
}

/// Description: 保存专业会诊子表会诊结论
/// Date: 2020-08-02
/// Creator: wangpf
/// Table: DHCINM.Special.SpecialConsSub
/// Input: parr
/// Output: 0:失败 1:成功
/// Other: w ##class(web.INMSpecialComm).SaveConsultConc("",0)
ClassMethod SaveConsultConc(parr As %String = "", nurseid As %String = "") As %String
{
	q:(parr="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	
	s parr=$tr(parr,"_","|")
	s conclusion=$p(parr,"^")
	s subId=$p(parr,"^",2)
	
	s subObj=##class(DHCINM.Special.SpecialConsSub).%OpenId(subId)
	q:'$IsObject(subObj)
	s subObj.SubConclusion=conclusion
	s subObj.SubFinish="Y"
	s now=$h
	s nowDateH=+now
	s nowTimeH=$p(now,",",2)
	s nowDate=$zd(nowDateH,3)
	s nowTime=$zt(nowTimeH,1)
	s subObj.SubFinishDate=nowDateH
	s subObj.SubFinishTime=nowTimeH
	i nurseid=0 s userName="管理员"
	e  d
	.s userGlo=^CF.DHCINM.DB.MgUserD(nurseid)
	.s userName=$lg(userGlo,2)
	s tmpHistory="Y「完成「"_nowDate_"「"_nowTime_"「"_nurseid_"「"_userName
	d subObj.SubHistory.Insert(tmpHistory)
	
	ts
	s sc=subObj.%Save()
	s flag=$$$ISOK(sc)
	i flag=1 d
	.s flag2=1
	.s parObj=subObj.Parref
	.s key="" f  s obj=parObj.ChildSub.GetNext(.key) q:(key="")||(flag2'=1)  d
	..q:'$IsObject(obj)
	..q:obj.SubFinish="Y"
	..s flag2=0
	.q:flag2'=1
	.s parObj.ConsultStatus="A"
	.s sc=parObj.%Save()
	.s flag=$$$ISOK(sc)
	.i sc=1 d
	..s ret="【专业组/专业会诊】完成 "_subObj.Parref.ConsultRegNo
	..s ret=ret_" "_$case(nurseid,0:"管理员","":"",:$lg($g(^CF.DHCINM.DB.MgUserD(nurseid)),2))
	..s ret=ret_" "_nowDate_" "_nowTime
	..d ##class(web.INMPlatform).SaveTrackMessage(subObj.Parref.Creator,+$H,ret,"","DHCINM.Special.SpecialConsult",subObj.Parref.%Id())
	
	i flag=1 tc  q 1
	e  tro  q 0
}

/// Description: 删除专业会诊
/// Date: 2020-08-03
/// Creator: wangpf
/// Table: DHCINM.Special.SpecialConsult
/// Input: id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMSpecialComm).DeleteConsult(1)
ClassMethod DeleteConsult(id As %String = "", nurseid As %String = "") As %String
{
	q:(id="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	
	q:id="" 0
	s sc=##class(DHCINM.Special.SpecialConsult).%DeleteId(id)
	q $$$ISOK(sc)
}

/// Description：获取专科护士列表
/// Date:2020-09-15
/// Creator:wangpf
/// Table:DHCINM.Special.SpecialNurse
/// Input: 病区Id^专业组^岗位^层级^职务^姓名/工号^开始日期^结束日期 登录人Id
/// Output:专科护士列表
/// Other:d ##class(%ResultSet).RunQuery("web.INMSpecialComm","FindSpeNurList","^^^^^^2020-10-01^2020-10-31^",0)
Query FindSpeNurList(parr As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindSpeNurListExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i nurseid="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	s ward=$p(parr,"^")
	s group=$tr($p(parr,"^",2),"_","|")
	s station=$tr($p(parr,"^",3),"_","|")
	s level=$tr($p(parr,"^",4),"_","|")
	s post=$tr($p(parr,"^",5),"_","|")
	s nurse=$p(parr,"^",6)
	s stDate=$p(parr,"^",7)
	s:stDate["-" stDate=$zdh(stDate,3)
	s endDate=$p(parr,"^",8)
	s:endDate["-" endDate=$zdh(endDate,3)
	s area=$p(parr,"^",9)
	
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	
	s today=+$h
	s perId="" f  s perId=$o(^DHCINM.Special.SpecialNurseI("AuthDate",perId)) q:perId=""  d
	.s perGlo=$g(^CF.DHCINM.HR.PersonsD(perId))
	.s perName=$lg(perGlo,2)
	.s perNo=$lg(perGlo,3)
	.q:(nurse'="")&&(perName_perNo'[nurse)
	.s perCurWard=$lg(perGlo,10)
	.q:((ward'="")&&(ward'=perCurWard))||((isAll'=1)&&('$d(tmpWard(perCurWard))))
	.s wardArea=""
	.s loc=$o(^CF.DHCINM.DB.MgWardLocUnitI("Ward",perCurWard,""))
	.i loc'="" d
	..q:'$d(^CF.DHCINM.DB.MgWardLocD(loc))
	..s locGlo=^CF.DHCINM.DB.MgWardLocD(loc)
	..s wardArea=$lg(locGlo,8)
	.q:(area'="")&&(area'=wardArea)
	.s wardDesc=""
	.i perCurWard'="" d
	..s wardGlo=$g(^CF.DHCINM.DB.MgWardD(perCurWard))
	..s wardDesc=$lg(wardGlo,4)
	.s perStation=$lg(perGlo,77)
	.q:(station'="")&&(station'=perStation)
	.s perStationDesc=""
	.i perStation'="" d
	..s perStaPar=$p(perStation,"||")
	..s perStaSub=$p(perStation,"||",2)
	..s staGlo=$g(^CT.DHCINM.DB.MgSetCodeSubD(perStaPar,perStaSub))
	..s perStationDesc=$lg(staGlo,3)
	.s tmpLevel=##class(web.INMHRComm).GetNurseLevel(perId,+$h)
	.s perLevel=$p(tmpLevel,"^")
	.s perLevelDesc=$p(tmpLevel,"^",2)
	.q:(level'="")&&(level'=perLevel)
	.s tmpPost=##class(web.INMHRComm).GetNurseDuty(perId,+$h)
	.s perPost=$p(tmpPost,"^")
	.s perPostDesc=$p(tmpPost,"^",2)
	.q:(post'="")&&(post'=perPost)
	.s groupList=$lb(),groupDescList=$lb(),counter=0
	.s groupId="" f  s groupId=$o(^DHCINM.Special.SpecialMemberI("Per",perId,groupId)) q:groupId=""  d
	..s groupPar=$p(groupId,"||")
	..s groupSub=$p(groupId,"||",2)
	..s groupGlo=$g(^CT.DHCINM.DB.MgSetCodeSubD(groupPar,groupSub))
	..s groupDesc=$lg(groupGlo,3)
	..s memId="" f  s memId=$o(^DHCINM.Special.SpecialMemberI("Per",perId,groupId,memId)) q:memId=""  d
	...q:'$d(^DHCINM.Special.SpecialMemberD(memId))
	...s memGlo=^DHCINM.Special.SpecialMemberD(memId)
	...s memStDate=$lg(memGlo,5)
	...s memEndDate=$lg(memGlo,6)
	...q:((memStDate'="")&&(memStDate>today))||((memEndDate'="")&&(memEndDate<today))
	...s:$lf(groupList,groupId)=0 counter=counter+1,$li(groupList,counter)=groupId,$li(groupDescList,counter)=groupDesc
	.q:(group'="")&&($lf(groupList,group)=0)
	.s groupListStr="",groupDescListStr=""
	.s:counter>0 groupListStr=$lts(groupList),groupDescListStr=$lts(groupDescList)
	.s authDate="" f  s authDate=$o(^DHCINM.Special.SpecialNurseI("AuthDate",perId," A",authDate)) q:authDate=""  d
	..q:((stDate'="")&&(stDate>authDate))||((endDate'="")&&(endDate<authDate))
	..s speId="" f  s speId=$o(^DHCINM.Special.SpecialNurseI("AuthDate",perId," A",authDate,speId)) q:speId=""  d
	...q:'$d(^DHCINM.Special.SpecialNurseD(speId))
	...s ret=..GetSpecial(speId)
	...s ret=ret_"^PerStation|"_$tr(perStation,"|","_")_"^PerStationDesc|"_perStationDesc_"^PerLevel|"_$tr(perLevel,"|","_")
	...s ret=ret_"^PerLevelDesc|"_perLevelDesc_"^PerPost|"_$tr(perPost,"|","_")_"^PerPostDesc|"_perPostDesc_"^PerWard|"_perCurWard
	...s ret=ret_"^PerGroup|"_$tr(groupListStr,"|","_")_"^PerGroupDesc|"_groupDescListStr_"^PerWardDesc|"_wardDesc
	...d OutSpecialList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutSpecialList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindSpeNurListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindSpeNurListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindSpeNurListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindSpeNurListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Description：获取专业会诊统计列表
/// Date:2020-09-18
/// Creator:wangpf
/// Table:DHCINM.Special.SpecialConsult
/// Input: 专业组^类型^级别^开始日期^结束日期 登录人Id
/// Output:专业会诊统计列表
/// Other:d ##class(%ResultSet).RunQuery("web.INMSpecialComm","FindConsuList","^^^^",0)
Query FindConsuList(parr As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindConsuListExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i nurseid="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	s group=$tr($p(parr,"^"),"_","|")
	s type=$p(parr,"^",2)
	s level=$p(parr,"^",3)
	s stDate=$p(parr,"^",4)
	s:stDate["-" stDate=$zdh(stDate,3)
	s endDate=$p(parr,"^",5)
	s:endDate["-" endDate=$zdh(endDate,3)
	
	s conDate="" f  s conDate=$o(^DHCINM.Special.SpecialConsultI("ToolIndex",conDate),-1) q:conDate=""  d
	.q:((stDate'="")&&(stDate>conDate))||((endDate'="")&&(endDate<conDate))
	.s conWard="" f  s conWard=$o(^DHCINM.Special.SpecialConsultI("ToolIndex",conDate," A",conWard)) q:conWard=""  d
	..s conType="" f  s conType=$o(^DHCINM.Special.SpecialConsultI("ToolIndex",conDate," A",conWard,conType)) q:conType=""  d
	...q:(type'="")&&(type'=conType)
	...s conLevel="" f  s conLevel=$o(^DHCINM.Special.SpecialConsultI("ToolIndex",conDate," A",conWard,conType,conLevel)) q:conLevel=""  d
	....q:(level'="")&&(level'=conLevel)
	....s id="" f  s id=$o(^DHCINM.Special.SpecialConsultI("ToolIndex",conDate," A",conWard,conType,conLevel,id)) q:id=""  d
	.....q:$d(^DHCINM.Special.SpecialConsultD(id))#2'=1
	.....s conGlo=^DHCINM.Special.SpecialConsultD(id)
	.....k tmpGroup
	.....s subId="" f  s subId=$o(^DHCINM.Special.SpecialConsSubD(id,subId)) q:subId=""  d
	......s subGlo=^DHCINM.Special.SpecialConsSubD(id,subId)
	......s subType=$lg(subGlo,2)
	......q:subType'="G"
	......s groupId=$lg(subGlo,3)
	......s groupDesc=""
	......s groupPar=$p(groupId,"||")
	......s groupSub=$p(groupId,"||",2)
	......s groupGlo=$g(^CT.DHCINM.DB.MgSetCodeSubD(groupPar,groupSub))
	......s groupDesc=$lg(groupGlo,3)
	......s tmpGroup(groupId)=groupDesc
	.....q:(group'="")&&('$d(tmpGroup(group)))
	.....s groupStr="",groupDescStr="",counter=0
	.....s groupId="" f  s groupId=$o(tmpGroup(groupId)) q:groupId=""  d
	......i counter=0 s groupStr=groupId,groupDescStr=tmpGroup(groupId)
	......e  s groupStr=groupStr_","_groupId,groupDescStr=groupDescStr_","_tmpGroup(groupId)
	......s counter=counter+1
	.....s ret=..GetConsult(id)_"^SpecialGroup|"_$tr(groupStr,"|","_")_"^SpecialGroupDesc|"_groupDescStr
	.....d OutConsuList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutConsuList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindConsuListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindConsuListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindConsuListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindConsuListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Description: 获取专科活动备案统计
/// Date: 2022-02-08
/// Creator: wangpf
/// Table: DHCINM.Special.SpecialActivity
/// Input: 人员id 年份 nurseid
/// Output: 专科活动备案统计
/// Other: w ##class(web.INMSpecialComm).GetActivitySta("",2022,0,0,"")
ClassMethod GetActivitySta(perId As %String = "", year As %String = "", nurseid As %String = "", appFlag As %String = "0", appRet As %ArrayOfDataTypes = "") As %ArrayOfDataTypes
{
	s:appRet="" appRet=##class(%ArrayOfDataTypes).%New()
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	s perName=""
	s:perId'="" perName=$lg(^CF.DHCINM.HR.PersonsD(perId),2)
	
	k tmp,tmpDesc
	s tmp("Type","L")=0,tmp("Type","T")=0,tmp("Type","B")=0,tmp("Type","J")=0,tmp("Type","G")=0,tmp("Type","O")=0
	s tmpDesc("Type","L")="主题论坛",tmpDesc("Type","T")="主题讨论",tmpDesc("Type","B")="专题读书报告",tmpDesc("Type","J")="论坛讲座",tmpDesc("Type","G")="专业组讲座",tmpDesc("Type","O")="其他"
	s tmp("ParType","P")=0,tmp("ParType","H")=0,tmp("ParType","C")=0,tmp("ParType","Z")=0,tmp("ParType","O")=0
	s tmpDesc("ParType","P")="参与",tmpDesc("ParType","H")="主持",tmpDesc("ParType","C")="负责",tmpDesc("ParType","Z")="组织",tmpDesc("ParType","O")="其他"
	s tmp("Level","W")=0,tmp("Level","L")=0,tmp("Level","H")=0
	s tmpDesc("Level","W")="病区",tmpDesc("Level","L")="科室",tmpDesc("Level","H")="护理部"
	
	s id="" f  s id=$o(^DHCINM.Special.SpecialActivityD(id)) q:id=""  d
	.s theGlo=^DHCINM.Special.SpecialActivityD(id)
	.s theStatus=$lg(theGlo,11)
	.q:theStatus'="A"
	.s theDate=$lg(theGlo,7)
	.q:(year'="")&&(+$zd(theDate,3)'=year)
	.s flag=0
	.i perId'="" d
	..s author=$lg(theGlo,3)
	..s ptr=0 f  s stat=$listnext(author,ptr,item) q:(stat'=1)||(flag=1)  d
	...s:item=perId flag=1
	.e  d
	..s authorWard=$lg(theGlo,2)
	..s:(isAll=1)||($d(tmpWard(authorWard))) flag=1
	.q:flag'=1
	.s theType=$lg(theGlo,4)
	.s:theType="" theType="O"
	.s:'$d(tmpDesc("Type",theType)) theTypeDesc=$case(theType,"L":"主题论坛","T":"主题讨论","B":"专题读书报告","J":"论坛讲座","G":"专业组讲座","O":"其他",:"其他"),tmpDesc("Type",theType)=theTypeDesc
	.s thePar=$lg(theGlo,5)
	.s:thePar="" thePar="O"
	.s:'$d(tmpDesc("ParType",thePar)) theParDesc=$case(thePar,"P":"参与","H":"主持","C":"负责","Z":"组织","O":"其他",:"其他"),tmpDesc("ParType",thePar)=theParDesc
	.s theLevel=$lg(theGlo,6)
	.s:theLevel="" theLevel="O"
	.s:'$d(tmpDesc("Level",theLevel)) theLevelDesc=$case(theLevel,"W":"病区","L":"科室","H":"护理部",:"其他"),tmpDesc("Level",theLevel)=theLevelDesc
	.s tmp("Type",theType)=$g(tmp("Type",theType))+1
	.s tmp("ParType",thePar)=$g(tmp("ParType",thePar))+1
	.s tmp("Level",theLevel)=$g(tmp("Level",theLevel))+1
	
	w:appFlag'=1 "{"
	s index=1,type="" f  s type=$o(tmp(type)) q:type=""  d
	.w:(appFlag'=1)&&(index>1) ","
	.w:appFlag'=1 """"_type_""":["
	.s tmpRet=##class(%ListOfDataTypes).%New()
	.s index2=1,subType="" f  s subType=$o(tmp(type,subType)) q:subType=""  d
	..s subDesc=tmpDesc(type,subType)
	..w:(appFlag'=1)&&(index2>1) ","
	..w:(appFlag'=1) "{""Desc"":"""_subDesc_""",""Num"":"""_tmp(type,subType)_"""}"
	..s tmpRetObj=##class(%ArrayOfDataTypes).%New()
	..d tmpRetObj.SetAt(subDesc,"Desc")
	..d tmpRetObj.SetAt(tmp(type,subType),"Num")
	..d tmpRet.Insert(tmpRetObj)
	..s index2=index2+1
	.w:appFlag'=1 "]"
	.d appRet.SetAt(tmpRet,type)
	.s index=index+1
	w:appFlag'=1 "}"
	q:appFlag=1 appRet
	q ""
}

/// Description: 获取课题专案备案统计
/// Date: 2022-02-08
/// Creator: wangpf
/// Table: DHCINM.Special.SpecialCase
/// Input: 人员id 年份 nurseid
/// Output: 课题专案备案统计
/// Other: w ##class(web.INMSpecialComm).GetCaseSta("",2022,0,0,"")
ClassMethod GetCaseSta(perId As %String = "", year As %String = "", nurseid As %String = "", appFlag As %String = "0", appRet As %ArrayOfDataTypes = "") As %ArrayOfDataTypes
{
	s:appRet="" appRet=##class(%ArrayOfDataTypes).%New()
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	s perName=""
	s:perId'="" perName=$lg(^CF.DHCINM.HR.PersonsD(perId),2)
	
	k tmp,tmpDesc
	s tmp("Type","K")=0,tmp("Type","Z")=0
	s tmpDesc("Type","K")="课题",tmpDesc("Type","Z")="专案"
	s tmp("ParType","P")=0,tmp("ParType","H")=0,tmp("ParType","C")=0,tmp("ParType","Z")=0,tmp("ParType","O")=0
	s tmpDesc("ParType","P")="参与",tmpDesc("ParType","H")="主持",tmpDesc("ParType","C")="负责",tmpDesc("ParType","Z")="组织",tmpDesc("ParType","O")="其他"
	s tmp("Level","W")=0,tmp("Level","L")=0,tmp("Level","H")=0
	s tmpDesc("Level","W")="病区",tmpDesc("Level","L")="科室",tmpDesc("Level","H")="护理部"
	
	s id="" f  s id=$o(^DHCINM.Special.SpecialCaseD(id)) q:id=""  d
	.s theGlo=^DHCINM.Special.SpecialCaseD(id)
	.s theStatus=$lg(theGlo,11)
	.q:theStatus'="A"
	.s theDate=$lg(theGlo,7)
	.q:(year'="")&&(+$zd(theDate,3)'=year)
	.s flag=0
	.i perId'="" d
	..s author=$lg(theGlo,3)
	..s ptr=0 f  s stat=$listnext(author,ptr,item) q:(stat'=1)||(flag=1)  d
	...s:item=perId flag=1
	.e  d
	..s authorWard=$lg(theGlo,2)
	..s:(isAll=1)||($d(tmpWard(authorWard))) flag=1
	.q:flag'=1
	.s theType=$lg(theGlo,4)
	.s:theType="" theType="O"
	.s:'$d(tmpDesc("Type",theType)) theTypeDesc=$case(theType,"K":"课题","Z":"专案","O":"其他",:"其他"),tmpDesc("Type",theType)=theTypeDesc
	.s thePar=$lg(theGlo,5)
	.s:thePar="" thePar="O"
	.s:'$d(tmpDesc("ParType",thePar)) theParDesc=$case(thePar,"P":"参与","H":"主持","C":"负责","Z":"组织","O":"其他",:"其他"),tmpDesc("ParType",thePar)=theParDesc
	.s theLevel=$lg(theGlo,6)
	.s:theLevel="" theLevel="O"
	.s:'$d(tmpDesc("Level",theLevel)) theLevelDesc=$case(theLevel,"W":"病区","L":"科室","H":"护理部",:"其他"),tmpDesc("Level",theLevel)=theLevelDesc
	.s tmp("Type",theType)=$g(tmp("Type",theType))+1
	.s tmp("ParType",thePar)=$g(tmp("ParType",thePar))+1
	.s tmp("Level",theLevel)=$g(tmp("Level",theLevel))+1
	
	w:appFlag'=1 "{"
	s index=1,type="" f  s type=$o(tmp(type)) q:type=""  d
	.w:(appFlag'=1)&&(index>1) ","
	.w:appFlag'=1 """"_type_""":["
	.s tmpRet=##class(%ListOfDataTypes).%New()
	.s index2=1,subType="" f  s subType=$o(tmp(type,subType)) q:subType=""  d
	..s subDesc=tmpDesc(type,subType)
	..w:(appFlag'=1)&&(index2>1) ","
	..w:(appFlag'=1) "{""Desc"":"""_subDesc_""",""Num"":"""_tmp(type,subType)_"""}"
	..s tmpRetObj=##class(%ArrayOfDataTypes).%New()
	..d tmpRetObj.SetAt(subDesc,"Desc")
	..d tmpRetObj.SetAt(tmp(type,subType),"Num")
	..d tmpRet.Insert(tmpRetObj)
	..s index2=index2+1
	.w:appFlag'=1 "]"
	.d appRet.SetAt(tmpRet,type)
	.s index=index+1
	w:appFlag'=1 "}"
	q:appFlag=1 appRet
	q ""
}

/// Description: 获取规范参与备案统计
/// Date: 2022-02-08
/// Creator: wangpf
/// Table: DHCINM.Special.SpecialStandard
/// Input: 人员id 年份 nurseid
/// Output: 规范参与备案统计
/// Other: w ##class(web.INMSpecialComm).GetStandardSta("",2022,0,0,"")
ClassMethod GetStandardSta(perId As %String = "", year As %String = "", nurseid As %String = "", appFlag As %String = "0", appRet As %ArrayOfDataTypes = "") As %ArrayOfDataTypes
{
	s:appRet="" appRet=##class(%ArrayOfDataTypes).%New()
	k tmpWard
	s isOverHLB=..IsPerOverHLB(nurseid)
	s nursePerId=""
	s:nurseid'="" nursePerId=$lg($g(^CF.DHCINM.DB.MgUserD(nurseid)),5)
	s perName=""
	s:perId'="" perName=$lg(^CF.DHCINM.HR.PersonsD(perId),2)
	
	k tmp,tmpDesc
	s tmp("Type","G")=0,tmp("Type","D")=0,tmp("Type","F")=0,tmp("Type","S")=0,tmp("Type","L")=0,tmp("Type","O")=0
	s tmpDesc("Type","G")="规范",tmpDesc("Type","D")="指引",tmpDesc("Type","F")="表单",tmpDesc("Type","S")="标准",tmpDesc("Type","L")="流程",tmpDesc("Type","O")="其他"
	s tmp("TypeSub","C")=0,tmp("TypeSub","U")=0
	s tmpDesc("TypeSub","C")="制定",tmpDesc("TypeSub","U")="修订"
	d ##class(web.INMSMComm).SetCodeTmp(.tmp,.tmpDesc,"Group","专业组")
	
	s id="" f  s id=$o(^DHCINM.Special.SpecialStandardD(id)) q:id=""  d
	.s theGlo=^DHCINM.Special.SpecialStandardD(id)
	.s theStatus=$lg(theGlo,8)
	.;q:theStatus'="A"
	.s theDate=$lg(theGlo,10)
	.q:(year'="")&&(+$zd(theDate,3)'=year)
	.s flag=0
	.i perId'="" d
	..s author=$lg(theGlo,6)
	..s ptr=0 f  s stat=$listnext(author,ptr,item) q:(stat'=1)||(flag=1)  d
	...s:item=perId flag=1
	.e  d
	..s authorGruop=$lg(theGlo,4)
	..s:(isOverHLB=1)||((nursePerId'="")&&($d(^DHCINM.Special.SpecialMemberI("Per",nursePerId,authorGruop)))) flag=1
	.q:flag'=1
	.s theType=$lg(theGlo,2)
	.s:theType="" theType="O"
	.s:'$d(tmpDesc("Type",theType)) theTypeDesc=$case(theType,"G":"规范","D":"指引","F":"表单","S":"标准","L":"流程","O":"其他",:"其他"),tmpDesc("Type",theType)=theTypeDesc
	.s theSub=$lg(theGlo,3)
	.s:theSub="" theSub="O"
	.s:'$d(tmpDesc("ParType",theSub)) theSubDesc=$case(theSub,"C":"制定","U":"修订","O":"其他",:"其他"),tmpDesc("ParType",theSub)=theSubDesc
	.s theGroup=$lg(theGlo,4)
	.s:theGroup="" theGroup="O"
	.s:'$d(tmpDesc("Group",theGroup)) theGroupDesc=##class(web.INMPersonComm).GetCommCode(theGroup),theGroupDesc=$case(theGroupDesc,"":"其他",:theGroupDesc),tmpDesc("Group",theGroup)=theGroupDesc
	.s tmp("Type",theType)=$g(tmp("Type",theType))+1
	.s tmp("TypeSub",theSub)=$g(tmp("TypeSub",theSub))+1
	.s tmp("Group",theGroup)=$g(tmp("Group",theGroup))+1
	
	w:appFlag'=1 "{"
	s index=1,type="" f  s type=$o(tmp(type)) q:type=""  d
	.w:(appFlag'=1)&&(index>1) ","
	.w:appFlag'=1 """"_type_""":["
	.s tmpRet=##class(%ListOfDataTypes).%New()
	.s index2=1,subType="" f  s subType=$o(tmp(type,subType)) q:subType=""  d
	..s subDesc=tmpDesc(type,subType)
	..w:(appFlag'=1)&&(index2>1) ","
	..w:(appFlag'=1) "{""Desc"":"""_subDesc_""",""Num"":"""_tmp(type,subType)_"""}"
	..s tmpRetObj=##class(%ArrayOfDataTypes).%New()
	..d tmpRetObj.SetAt(subDesc,"Desc")
	..d tmpRetObj.SetAt(tmp(type,subType),"Num")
	..d tmpRet.Insert(tmpRetObj)
	..s index2=index2+1
	.w:appFlag'=1 "]"
	.d appRet.SetAt(tmpRet,type)
	.s index=index+1
	w:appFlag'=1 "}"
	q:appFlag=1 appRet
	q ""
}

/// Creator: ChenPeng
/// CreateDate: 2021-11-25
/// Description: 根据主键Id查询专科发展数据状态
/// Table: DHCINM.Special.SpecialNurse
/// Input: 行记录Id
/// Output: 行记录状态status
/// Returns: 无
/// Others: Write ##class(web.INMSpecialComm).GetSpecialStatus("2")
ClassMethod GetSpecialStatus(id As %String) As %String
{
	/// Quit ##class(web.INMPerSubComm).GetCommStatus("DHCINM.Special.SpecialNurse", "SpecialStatus", id)
	Quit:id="" ""
	Set status = ""
	Set obj = ##class(DHCINM.Special.SpecialNurse).%OpenId(id)
	Quit:'$IsObject(obj) ""
	Set status = obj.SpecialStatus
	Quit status
}

}
