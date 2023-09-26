/// Creator:dhh
/// Desctiptions:科研管理方法类
/// Date:2020-07-21
Class web.INMSMComm Extends %RegisteredObject
{

/// Description: 保存论文备案
/// Date: 2020-07-21
/// Creator: dhh
/// Table: DHCINM.SM.Thesis
/// Input: parr
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMSMComm).SaveThesis("论文题目^期刊名称^Y^期刊级别^期刊文章^页码^F「第一作者「「0,S「第二作者「2「1,T「第三作者「1「2^2020-07-01^1^N",0)
ClassMethod SaveThesis(parr As %String = "", nurseid As %String = "") As %String
{
	q:(parr="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	
	s title=$p(parr,"^")
	s name=$p(parr,"^",2)
	s spec=$p(parr,"^",3)
	s level=$p(parr,"^",4)
	s type=$p(parr,"^",5)
	s page=$p(parr,"^",6)
	s authors=$p(parr,"^",7)
	s authorList=$lfs(authors,",")
	s date=$p(parr,"^",8)
	s:date["-" date=$zdh(date,3)
	s rw=$p(parr,"^",9)
	s status=$p(parr,"^",10)
	i rw="" d
	.s obj=##class(DHCINM.SM.Thesis).%New()
	.s obj.Creator=nurseid
	e  s obj=##class(DHCINM.SM.Thesis).%OpenId(rw)
	q:'$IsObject(obj) 0
	s obj.ThesisTitle=title
	s obj.ThesisPublic=date
	s obj.ThesisName=name
	s obj.ThesisSpec=spec
	s obj.ThesisLevel=level
	s obj.ThesisType=type
	s obj.ThesisPage=page
	s obj.ThesisStatus=status
	d obj.ThesisAuthor.Clear()
	s ptr=0 f  s stat=$listnext(authorList,ptr,item) q:stat'=1  d
	.s authType=$p(item,"「")
	.s authName=$p(item,"「",2)
	.s authWard=$p(item,"「",3)
	.s authRw=$p(item,"「",4)
	.q:'$d(^CF.DHCINM.DB.MgWardD(authWard))
	.d obj.ThesisAuthor.Insert(item)
	s sc=obj.%Save()
	i $$$ISOK(sc) q obj.%Id()
	e  q 0
}

/// Description: 保存论文备案文件
/// Date: 2020-08-26
/// Creator: dhh
/// Table: DHCINM.SM.Thesis
/// Input: id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMSMComm).SaveThesisFile(3,"")
ClassMethod SaveThesisFile(id As %String = "", name As %String = "") As %String
{
	q:(id="")||(name="") 0
	
	s obj=##class(DHCINM.SM.Thesis).%OpenId(id)
	q:'$IsObject(obj) 0
	i obj.ThesisPic="" s obj.ThesisPic=name
	e  s obj.ThesisPic=obj.ThesisPic_"」"_name
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Description: 删除论文备案文件
/// Date: 2020-08-26
/// Creator: dhh
/// Table: DHCINM.SM.Thesis
/// Input: id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMSMComm).DeleteThesisFile(2,"",0)
ClassMethod DeleteThesisFile(id As %String = "", name As %String = "", nurseid As %String = "") As %String
{
	q:(id="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	
	s obj=##class(DHCINM.SM.Thesis).%OpenId(id)
	q:'$IsObject(obj) 0
	q:(nurseid'=0)&&(obj.Creator'=nurseid) 0
	s fileList=$lfs(obj.ThesisPic,"」")
	s exist=0,index=0
	s ptr=0 f  s status=$listnext(fileList,ptr,file) q:(status'=1)||(exist'=0)  d
	.s:file=name exist=1
	.s index=index+1
	q:exist=0 0
	s fileLength=$l(obj.ThesisPic,"」")
	s tmpFile=""
	f i=1:1:fileLength d
	.q:i=index
	.i tmpFile="" s tmpFile=$lg(fileList,i)
	.e  s tmpFile=tmpFile_"」"_$lg(fileList,i)
	s obj.ThesisPic=tmpFile
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Description: 获取论文备案
/// Date: 2020-07-21
/// Creator: dhh
/// Table: DHCINM.SM.Thesis
/// Input: id 是否返回内容
/// Output: 论文备案记录
/// Other: w ##class(web.INMSMComm).GetThesis(4)
ClassMethod GetThesis(id As %String = "", flag As %String = "") As %String
{
	q:(id="")||('$d(^DHCINM.SM.ThesisD(id))) ""
	
	s thesisGlo=^DHCINM.SM.ThesisD(id)
	s thesisTitle=$lg(thesisGlo,2)
	s thesisAuthors=$lg(thesisGlo,3)
	s thesisName=$lg(thesisGlo,4)
	s thesisSpec=$lg(thesisGlo,5)
	s thesisSpecDesc=$case(thesisSpec,"Y":"是","N":"否",:"")
	s thesisLevel=$lg(thesisGlo,6)
	s thesisLevelDesc=##class(web.INMPersonComm).GetCommCode($lg(thesisGlo,6))
	s thesisType=$lg(thesisGlo,7)
	s thesisTypeDesc=##class(web.INMPersonComm).GetCommCode($lg(thesisGlo,7))
	s thesisPage=$lg(thesisGlo,8)
	s thesisPublic=$lg(thesisGlo,9)
	s:thesisPublic'="" thesisPublic=$zd(thesisPublic,3)
	s thesisStatus=$lg(thesisGlo,13)
	s thesisStatus=$case(thesisStatus,"Y":"已提交","N":"已保存","B":"驳回","S":"已审核",:"")
	s tableData=0
	s thesisPart="",thesisAuthor="",thesisAuthorsDesc=""
	s ptr=0 f  s status=$listnext(thesisAuthors,ptr,item) q:status'=1  d
	.s AuthorType=$p(item,"「")
	.s AuthorName=$p(item,"「",2)
	.i (AuthorType="F")&&(AuthorName'="") d 
	..i thesisAuthor="" s thesisAuthor=AuthorName
	..e  s thesisAuthor=thesisAuthor_","_AuthorName
	.i (AuthorType'="F")&&(AuthorName'="") d 
	..i thesisPart="" s thesisPart=AuthorName
	..e  s thesisPart=thesisPart_","_AuthorName
	.s AuthorWard=$p(item,"「",3)
	.s rw=$p(item,"「",4)
	.s AuthorWardDesc=$lg($g(^CF.DHCINM.DB.MgWardD(AuthorWard)),4)
	.s AuthorTypeDesc=$case(AuthorType,"F":"第一作者","S":"第二作者","T":"第三作者",:"")
	.s thesisAuthorsDesc=thesisAuthorsDesc_$case(thesisAuthorsDesc,"":"",:",")_AuthorTypeDesc_"「"_AuthorName_"「"_AuthorWardDesc_"「"_rw
	s tableData=$lts(thesisAuthors,",")
	s creator=$lg(thesisGlo,10)
	s creatorName=""
	i creator=0 s creatorName="管理员"
	e  i creator'="" d
	.s perGlo=$g(^CF.DHCINM.DB.MgUserD(creator))
	.s creatorName=$lg(perGlo,2)
	s createDate=$lg(thesisGlo,11)
	s:createDate'="" createDate=$zd(createDate,3)
	s thesisFile=$lg(thesisGlo,12)
	s auditor=$lg(thesisGlo,15)
	s auditorName=""
	i auditor=0 s auditorName="管理员"
	e  i auditor'="" d
	.s perGlo=$g(^CF.DHCINM.DB.MgUserD(auditor))
	.s auditorName=$lg(perGlo,2)
	s auditDate=$lg(thesisGlo,16)
	s:auditDate'="" auditDate=$zd(auditDate,3)
	s auditTime=$lg(thesisGlo,17)
	s:auditTime'="" auditTime=$zt(auditTime,1)
	s creatorWard="",auditorWard=""
	i creator'="" d
	.s creatorWard=##class(web.INMHRComm).GetCurrentWard($lg($g(^CF.DHCINM.DB.MgUserD(creator)),5),createDate)
	.s:creatorWard'="" creatorWard=$lg($g(^CF.DHCINM.DB.MgWardD(creatorWard)),4)
	i auditor'="" d
	.s auditorWard=##class(web.INMHRComm).GetCurrentWard($lg($g(^CF.DHCINM.DB.MgUserD(auditor)),5),auditDate)
	.s:auditorWard'="" auditorWard=$lg($g(^CF.DHCINM.DB.MgWardD(auditorWard)),4)
	s createTime=$lg(thesisGlo,18)
	s:createTime'="" createTime=$zt(createTime,1)
	s ret="ThesisTitle|"_thesisTitle_"^ThesisName|"_thesisName_"^ThesisSpec|"_thesisSpec_"^ThesisSpecDesc|"_thesisSpecDesc
	s ret=ret_"^ThesisLevel|"_thesisLevel_"^ThesisLevelDesc|"_thesisLevelDesc_"^ThesisType|"_thesisType_"^ThesisTypeDesc|"_thesisTypeDesc_"^ThesisPage|"_thesisPage_"^ThesisPublic|"_thesisPublic
	s ret=ret_"^ThesisStatus|"_thesisStatus_"^tableData|"_tableData_"^Creator|"_creator_"^ThesisAuthor|"_thesisAuthor_"^ThesisPart|"_thesisPart
	s ret=ret_"^CreatorName|"_creatorName_"^CreateDate|"_createDate_"^ThesisFile|"_thesisFile_"^rw|"_id_"^Auditor|"_auditor_"^AuditorName|"_auditorName_"^AuditDate|"_auditDate_"^AuditTime|"_auditTime
	s ret=ret_"^tableDataDesc|"_thesisAuthorsDesc_"^AuditorWard|"_auditorWard_"^CreatorWard|"_creatorWard_"^CreateTime|"_createTime
	q ret
}

/// Description:获取论文备案列表
/// Date:2020-07-22
/// Creator:dhh
/// Table: DHCINM.SM.Thesis
/// Input: 病区^开始日期^结束日期^关键字
/// Output:论文备案列表
/// Other:d ##class(%ResultSet).RunQuery("web.INMSMComm","FindThesisList","^2021-03-01^2021-03-31^d",0)
Query FindThesisList(parr As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindThesisListExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i nurseid="" Set qHandle=$lb(0,repid,0) Quit $$$OK

	s ward=$p(parr,"^")
	s stDate=$p(parr,"^",2)
	s:stDate["-" stDate=$zdh(stDate,3)
	s endDate=$p(parr,"^",3)
	s:endDate["-" endDate=$zdh(endDate,3)
	s input=$p(parr,"^",4)
	s status=$p(parr,"^",5)
	
	s userPerId=""
	i nurseid'=0 d
	.s userGlo=$g(^CF.DHCINM.DB.MgUserD(nurseid))
	.s userPerId=$lg(userGlo,5)
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	
	s id="" f  s id=$o(^DHCINM.SM.ThesisD(id),-1) q:id=""  d
	.s theGlo=^DHCINM.SM.ThesisD(id)
	.s flag=0
	.s:isAll=1 flag=1
	.s theWard=$lg(theGlo,3)
	.s wardList=$lb(),index=1
	.s ptr=0 f  s stat=$listnext(theWard,ptr,item) q:(stat'=1)||((flag=1)&&(ward=""))  d
	..s authType=$p(item,"「")
	..q:authType'="F"
	..s wardId=$p(item,"「",3)
	..s $li(wardList,index)=wardId
	..s index=index+1
	..s:$d(tmpWard(wardId)) flag=1
	.s creator=$lg(theGlo,10)
	.s:creator=nurseid flag=1
	.q:flag'=1
	.q:(ward'="")&&($lf(wardList,ward)=0)	
	.s title=$lg(theGlo,2)
	.q:(input'="")&&(title'="")&&(($zcvt(title,"U")'[$zcvt(input,"U")))
	.s recDate=$lg(theGlo,9)
	.q:((stDate'="")&&(recDate<stDate))||((endDate'="")&&(recDate>endDate))
	.s stat=$lg(theGlo,13)
	.q:(status'="")&&(status'=stat)
	.s ret=..GetThesis(id)
	.d:ret'="" OutGetThesis
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutGetThesis
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindThesisListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindThesisListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindThesisListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindThesisListExecute ]
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

/// Description: 审核论文备案
/// Date: 2020-07-22
/// Creator: dhh
/// Table: DHCINM.SM.Thesis
/// Input: 状态^说明^id 登录人Id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMSMComm).AuditThesis("",0)
ClassMethod AuditThesis(parr As %String = "", nurseid As %String = "") As %String
{
	q:(parr="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	
	s status=$p(parr,"^")
	s reason=$p(parr,"^",2)
	s rw=$p(parr,"^",3)
	
	s obj=##class(DHCINM.SM.Thesis).%OpenId(rw)
	q:'$IsObject(obj) 0
	i obj.ThesisStatus="Y" d
	.s obj.ThesisStatus=status
	.s obj.Reason=reason
	.s obj.Auditor=nurseid
	.s obj.AuditDate=+$h
	.s obj.AuditTime=$p($h,",",2)
	s sc=obj.%Save()
	try{
		i (($$$ISOK(sc))&&((obj.ThesisStatus="S")||(obj.ThesisStatus="B"))) d
		.s ThesisStatus=$case(obj.ThesisStatus,"S":"审核","B":"驳回") ;状态描述
		.s AuthList=$lg($g(^DHCINM.SM.ThesisD(rw)),3)
		.s AuthName=""
		.s ptr=0 f  s stat=$listnext(AuthList,ptr,item) q:stat'=1  d
		..s authType=$p(item,"「")
		..s authName=$p(item,"「",2)
		..i (authType="F") d
		...i (AuthName="") s AuthName=authName
		...e  s AuthName=AuthName_","_authName
		.s ThesisName=obj.ThesisName
		.s ThesisPublic=obj.ThesisPublic
		.s:ThesisPublic'="" ThesisPublic=$zd(ThesisPublic,3)
		.s ThesisTitle=obj.ThesisTitle
		.s userID=obj.Creator
		.s ret="【科研/发表论文备案】"_ThesisStatus_" "_ThesisTitle_" "_AuthName_" "_ThesisName_" "_ThesisPublic
		.d ##class(web.INMPlatform).SaveTrackMessage(userID,+$H,ret,"","DHCINM.SM.Thesis",rw)
	}catch{
		}
	q $$$ISOK(sc)
}

/// Description: 删除论文备案
/// Date: 2020-07-22
/// Creator: dhh
/// Table: DHCINM.HB.MgRecessRecord
/// Input: id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMHBComm).DeleteThesis(1)
ClassMethod DeleteThesis(id As %String = "") As %String
{
	q:id="" 0
	s sc=##class(DHCINM.SM.Thesis).%DeleteId(id)
	q $$$ISOK(sc)
}

/// Description: 保存交流获奖论文备案
/// Date: 2020-07-21
/// Creator: dhh
/// Table: DHCINM.SM.AwardThesis
/// Input: parr
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMSMComm).SaveAward("",0)
ClassMethod SaveAward(parr As %String = "", nurseid As %String = "") As %String
{
	q:(parr="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	
	s title=$p(parr,"^")
	s authors=$p(parr,"^",2)
	s authorList=$lfs(authors,",")
	s name=$p(parr,"^",3)
	s level=$p(parr,"^",4)
	s spec=$p(parr,"^",5)
	s situation=$p(parr,"^",6)
	s parts=$p(parr,"^",7)
	s partList=$lfs(parts,",")	
	s date=$p(parr,"^",8)
	s:date["-" date=$zdh(date,3)
	s rw=$p(parr,"^",9)
	s status=$p(parr,"^",10)
	i rw="" d
	.s obj=##class(DHCINM.SM.AwardThesis).%New()
	.s obj.Creator=nurseid
	e  s obj=##class(DHCINM.SM.AwardThesis).%OpenId(rw)
	q:'$IsObject(obj) 0
	s obj.AwardTitle=title
	d obj.AwardAuthor.Clear()
	s ptr=0 f  s stat=$listnext(authorList,ptr,per) q:stat'=1  d
	.q:'$d(^CF.DHCINM.HR.PersonsD(per))
	.d obj.AwardAuthor.Insert(per)
	s obj.AwardName=name
	s obj.AwardLevel=level
	s obj.AwardSpec=spec
	s obj.AwardSituation=situation
	d obj.AwardPart.Clear()
	s ptr=0 f  s stat=$listnext(partList,ptr,per) q:stat'=1  d
	.q:'$d(^CF.DHCINM.HR.PersonsD(per))
	.d obj.AwardPart.Insert(per)
	s obj.AwardDate=date
	s obj.AwardStatus=status
	s sc=obj.%Save()
	i $$$ISOK(sc) q obj.%Id()
	e  q 0
}

/// Description: 保存交流获奖论文文件
/// Date: 2020-08-26
/// Creator: dhh
/// Table: DHCINM.SM.AwardThesis
/// Input: id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMSMComm).SaveAwardFile(3,"")
ClassMethod SaveAwardFile(id As %String = "", name As %String = "") As %String
{
	q:(id="")||(name="") 0
	
	s obj=##class(DHCINM.SM.AwardThesis).%OpenId(id)
	q:'$IsObject(obj) 0
	i obj.AwardFile="" s obj.AwardFile=name
	e  s obj.AwardFile=obj.AwardFile_"」"_name
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Description: 删除交流获奖论文文件
/// Date: 2020-08-26
/// Creator: dhh
/// Table: DHCINM.SM.AwardThesis
/// Input: id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMSMComm).DeleteAwardFile(2,"",0)
ClassMethod DeleteAwardFile(id As %String = "", name As %String = "", nurseid As %String = "") As %String
{
	q:(id="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	
	s obj=##class(DHCINM.SM.AwardThesis).%OpenId(id)
	q:'$IsObject(obj) 0
	q:(nurseid'=0)&&(obj.Creator'=nurseid) 0
	s fileList=$lfs(obj.AwardFile,"」")
	s exist=0,index=0
	s ptr=0 f  s status=$listnext(fileList,ptr,file) q:(status'=1)||(exist'=0)  d
	.s:file=name exist=1
	.s index=index+1
	q:exist=0 0
	s fileLength=$l(obj.AwardFile,"」")
	s tmpFile=""
	f i=1:1:fileLength d
	.q:i=index
	.i tmpFile="" s tmpFile=$lg(fileList,i)
	.e  s tmpFile=tmpFile_"」"_$lg(fileList,i)
	s obj.AwardFile=tmpFile
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Description: 获取交流获奖论文备案
/// Date: 2020-07-23
/// Creator: dhh
/// Table: DHCINM.SM.AwardThesis
/// Input: id 是否返回内容
/// Output: 交流获奖论文备案
/// Other: w ##class(web.INMSMComm).GetAWardThesis(1)
ClassMethod GetAWardThesis(id As %String = "") As %String
{
	q:(id="")||('$d(^DHCINM.SM.AwardThesisD(id))) ""
	
	s awardGlo=^DHCINM.SM.AwardThesisD(id)
	s awardTitle=$lg(awardGlo,2)
	s awardAuthors=$lg(awardGlo,3)
	s awardName=$lg(awardGlo,4)
	s awardLevel=$lg(awardGlo,5)
	s awardLevelDesc=##class(web.INMPersonComm).GetCommCode(awardLevel)
	s awardSituation=$lg(awardGlo,6)
	s awardSituationDesc=##class(web.INMPersonComm).GetCommCode(awardSituation)
	s awardDate=$lg(awardGlo,7)
	s:awardDate'="" awardDate=$zd(awardDate,3)
	s awardSpec=$lg(awardGlo,8)
	s awardSpecDesc=$case(awardSpec,"Y":"是","N":"否",:"")
	s awardParts=$lg(awardGlo,9)
	s awardStatus=$lg(awardGlo,11)
	s awardStatusDesc=$case(awardStatus,"Y":"已提交","N":"已保存","B":"驳回","S":"已审核",:"")
	s awardAuthorsId=$lts(awardAuthors,",")
	s awardAuthorsName=""
	s index=1,ptr=0 f  s stat=$listnext(awardAuthors,ptr,per) q:stat'=1  d
	.s perGlo=$g(^CF.DHCINM.HR.PersonsD(per))
	.s perName=$lg(perGlo,2)
	.i index=1 s awardAuthorsName=perName
	.e  s awardAuthorsName=awardAuthorsName_","_perName
	.s index=index+1
	s awardPartsId=$lts(awardParts,",")
	s awardPartsName=""
	s indexP=1,ptr=0 f  s stat=$listnext(awardParts,ptr,per) q:stat'=1  d
	.s perGlo=$g(^CF.DHCINM.HR.PersonsD(per))
	.s perName=$lg(perGlo,2)
	.i indexP=1 s awardPartsName=perName
	.e  s awardPartsName=awardPartsName_","_perName
	.s indexP=indexP+1
	s creator=$lg(awardGlo,13)
	s creatorName=""
	i creator=0 s creatorName="管理员"
	e  i creator'="" d
	.s perGlo=$g(^CF.DHCINM.DB.MgUserD(creator))
	.s creatorName=$lg(perGlo,2)
	s createDate=$lg(awardGlo,14)
	s:createDate'="" createDate=$zd(createDate,3)
	s awardFile=$lg(awardGlo,10)
	s auditor=$lg(awardGlo,15)
	s auditorName=""
	i auditor=0 s auditorName="管理员"
	e  i auditor'="" d
	.s perGlo=$g(^CF.DHCINM.DB.MgUserD(auditor))
	.s auditorName=$lg(perGlo,2)
	s auditDate=$lg(awardGlo,16)
	s:auditDate'="" auditDate=$zd(auditDate,3)
	s auditTime=$lg(awardGlo,17)
	s:auditTime'="" auditTime=$zt(auditTime,1)
	s creatorWard="",auditorWard=""
	i creator'="" d
	.s creatorWard=##class(web.INMHRComm).GetCurrentWard($lg($g(^CF.DHCINM.DB.MgUserD(creator)),5),createDate)
	.s:creatorWard'="" creatorWard=$lg($g(^CF.DHCINM.DB.MgWardD(creatorWard)),4)
	i auditor'="" d
	.s auditorWard=##class(web.INMHRComm).GetCurrentWard($lg($g(^CF.DHCINM.DB.MgUserD(auditor)),5),auditDate)
	.s:auditorWard'="" auditorWard=$lg($g(^CF.DHCINM.DB.MgWardD(auditorWard)),4)
	s createTime=$lg(awardGlo,18)
	s:createTime'="" createTime=$zt(createTime,1)
	s ret="AwardTitle|"_awardTitle_"^AwardAuthor|"_awardAuthorsId_"^AwardAuthorName|"_awardAuthorsName_"^AwardName|"_awardName_"^AwardSpec|"_awardSpec_"^AwardSpecDesc|"_awardSpecDesc
	s ret=ret_"^AwardLevel|"_awardLevel_"^AwardLevelDesc|"_awardLevelDesc_"^AwardSituation|"_awardSituation_"^AwardSituationDesc|"_awardSituationDesc_"^AwardPart|"_awardPartsId_"^AwardPartName|"_awardPartsName_"^AwardDate|"_awardDate
	s ret=ret_"^AwardStatus|"_awardStatus_"^AwardStatusDesc|"_awardStatusDesc_"^Creator|"_creator_"^CreatorName|"_creatorName_"^CreateDate|"_createDate_"^AwardFile|"_awardFile_"^rw|"_id
	s ret=ret_"^Auditor|"_auditor_"^AuditorName|"_auditorName_"^AuditDate|"_auditDate_"^AuditTime|"_auditTime_"^AuditorWard|"_auditorWard_"^CreatorWard|"_creatorWard_"^CreateTime|"_createTime
	q ret
}

/// Description:获取交流获奖论文备案列表
/// Date:2020-07-23
/// Creator:dhh
/// Table: DHCINM.SM.AwardThesis
/// Input: 病区^开始日期^结束日期^关键字
/// Output:交流获奖论文备案列表
/// Other:d ##class(%ResultSet).RunQuery("web.INMSMComm","FindAwardThesisList","2^2020-07-01^2020-07-31^",0)
Query FindAwardThesisList(parr As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindAwardThesisListExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i nurseid="" Set qHandle=$lb(0,repid,0) Quit $$$OK

	s ward=$p(parr,"^")
	s stDate=$p(parr,"^",2)
	s:stDate["-" stDate=$zdh(stDate,3)
	s endDate=$p(parr,"^",3)
	s:endDate["-" endDate=$zdh(endDate,3)
	s input=$p(parr,"^",4)
	s status=$p(parr,"^",5)
	s userPerId=""
	i nurseid'=0 d
	.s userGlo=$g(^CF.DHCINM.DB.MgUserD(nurseid))
	.s userPerId=$lg(userGlo,5)
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	s id="" f  s id=$o(^DHCINM.SM.AwardThesisD(id),-1) q:id=""  d
	.s awaGlo=^DHCINM.SM.AwardThesisD(id)
	.s flag=0
	.s:isAll=1 flag=1
	.s awardAuthor=$lg(awaGlo,3)
	.s wardList=$lb(),index=1
	.s ptr=0 f  s stat=$listnext(awardAuthor,ptr,item) q:(stat'=1)||((flag=1)&&(ward=""))  d
	..s perGlo=$g(^CF.DHCINM.HR.PersonsD(item))
	..s perWard=$lg(perGlo,10)
	..s $li(wardList,index)=perWard
	..s index=index+1
	..s:$d(tmpWard(perWard)) flag=1
	.s creator=$lg(awaGlo,10)
	.s:creator=nurseid flag=1
	.q:flag'=1
	.q:(ward'="")&&($lf(wardList,ward)=0)	
	.s title=$lg(awaGlo,2)
	.q:(input'="")&&(title'="")&&(($zcvt(title,"U")'[$zcvt(input,"U")))
	.s recDate=$lg(awaGlo,14)
	.q:((stDate'="")&&(recDate<stDate))||((endDate'="")&&(recDate>endDate))
	.s stat=$lg(awaGlo,11)
	.q:(status'="")&&(status'=stat)
	.s ret=..GetAWardThesis(id)
	.d:ret'="" OutAwardThesisList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutAwardThesisList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindAwardThesisListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAwardThesisListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindAwardThesisListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAwardThesisListExecute ]
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

/// Description: 审核交流获奖论文备案
/// Date: 2020-07-23
/// Creator: dhh
/// Table: DHCINM.SM.AwardThesis
/// Input: 状态^说明^id 登录人Id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMSMComm).AuditAward("",0)
ClassMethod AuditAward(parr As %String = "", nurseid As %String = "") As %String
{
	q:(parr="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	
	s status=$p(parr,"^")
	s reason=$p(parr,"^",2)
	s rw=$p(parr,"^",3)
	
	s obj=##class(DHCINM.SM.AwardThesis).%OpenId(rw)
	q:'$IsObject(obj) 0
	i obj.AwardStatus="Y" d
	.s obj.AwardStatus=status
	.s obj.Reason=reason
	.s obj.Auditor=nurseid
	.s obj.AuditDate=+$h
	.s obj.AuditTime=$p($h,",",2)
	s sc=obj.%Save()
	try{
		i (($$$ISOK(sc))&&((obj.AwardStatus="S")||(obj.AwardStatus="B"))) d
		.s AwardStatus=$case(obj.AwardStatus,"S":"审核","B":"驳回") ;状态描述
		.s perIdList=$lg($g(^DHCINM.SM.AwardThesisD(rw)),3) 
		.s AwardAuthor=""
		.s ptr=0 f  s stat=$listnext(perIdList,ptr,item) q:stat'=1  d
		..s authName=$p(item,",")
		..i (AwardAuthor="") s AwardAuthor=$lg($g(^CF.DHCINM.HR.PersonsD(authName)),2)
		..e  s AwardAuthor=AwardAuthor_","_$lg($g(^CF.DHCINM.HR.PersonsD(authName)),2)
		.s AwardTitle=$lg($g(^DHCINM.SM.AwardThesisD(rw)),2)
		.s AwardName=$lg($g(^DHCINM.SM.AwardThesisD(rw)),4)
		.s AwardDate=$lg($g(^DHCINM.SM.AwardThesisD(rw)),7)
		.s:AwardDate'="" AwardDate=$zd(AwardDate,3)
		.s Creator=$lg($g(^DHCINM.SM.AwardThesisD(rw)),13) 
		.s ret="【科研/交流获奖论文备案】"_AwardStatus_" "_AwardAuthor_" "_AwardTitle_" "_AwardName_" "_AwardDate
		.d ##class(web.INMPlatform).SaveTrackMessage(Creator,+$H,ret,"","DHCINM.SM.AwardThesis",rw)
	}catch{
		}
	q $$$ISOK(sc)
}

/// Description: 删除交流获奖论文备案
/// Date: 2020-07-23
/// Creator: dhh
/// Table: DHCINM.SM.AwardThesis
/// Input: id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMSMComm).DeleteAward(1)
ClassMethod DeleteAward(id As %String = "") As %String
{
	q:id="" 0
	s sc=##class(DHCINM.SM.AwardThesis).%DeleteId(id)
	q $$$ISOK(sc)
}

/// Description: 保存年底上交论文备案
/// Date: 2020-07-23
/// Creator: dhh
/// Table: DHCINM.SM.EndYearThseis
/// Input: parr
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMSMComm).SaveEndYearThseis("10^19||1^2^12||1^阿斯顿^阿斯顿^^N",0)
ClassMethod SaveEndYearThseis(parr As %String = "", nurseid As %String = "") As %String
{
	q:(parr="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	
	s EytNurse=$p(parr,"^")
	s EytLevel=$p(parr,"^",2)
	s EytWard=$p(parr,"^",3)
	s EytHire=$p(parr,"^",4)
	s EytTitle=$p(parr,"^",5)
	s EytType=$p(parr,"^",6)
	s rw=$p(parr,"^",7)
	s status=$p(parr,"^",8)
	i rw="" d
	.s obj=##class(DHCINM.SM.EndYearThseis).%New()
	.s obj.Creator=nurseid
	e  s obj=##class(DHCINM.SM.EndYearThseis).%OpenId(rw)
	q:'$IsObject(obj) 0
	d obj.EytNurseSetObjectId(EytNurse)
	d obj.EytWardSetObjectId(EytWard)
	d obj.EytLevelSetObjectId(EytLevel)
	d obj.EytHireSetObjectId(EytHire)
	s obj.EytTitle=EytTitle
	s obj.EytType=EytType
	s obj.EytStatus=status
	s sc=obj.%Save()
	i $$$ISOK(sc) q obj.%Id()
	e  q 0
}

/// Description: 保存年底上交论文文件
/// Date: 2020-08-26
/// Creator: dhh
/// Table: DHCINM.SM.EndYearThseis
/// Input: id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMSMComm).SaveEndFile(3,"")
ClassMethod SaveEndFile(id As %String = "", name As %String = "") As %String
{
	q:(id="")||(name="") 0
	
	s obj=##class(DHCINM.SM.EndYearThseis).%OpenId(id)
	q:'$IsObject(obj) 0
	i obj.EytFile="" s obj.EytFile=name
	e  s obj.EytFile=obj.EytFile_"」"_name
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Description: 删除年底上交论文文件
/// Date: 2020-08-26
/// Creator: dhh
/// Table: DHCINM.SM.EndYearThseis
/// Input: id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMSMComm).DeleteEndFile(2,"",0)
ClassMethod DeleteEndFile(id As %String = "", name As %String = "", nurseid As %String = "") As %String
{
	q:(id="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	
	s obj=##class(DHCINM.SM.EndYearThseis).%OpenId(id)
	q:'$IsObject(obj) 0
	q:(nurseid'=0)&&(obj.Creator'=nurseid) 0
	s fileList=$lfs(obj.EytFile,"」")
	s exist=0,index=0
	s ptr=0 f  s status=$listnext(fileList,ptr,file) q:(status'=1)||(exist'=0)  d
	.s:file=name exist=1
	.s index=index+1
	q:exist=0 0
	s fileLength=$l(obj.EytFile,"」")
	s tmpFile=""
	f i=1:1:fileLength d
	.q:i=index
	.i tmpFile="" s tmpFile=$lg(fileList,i)
	.e  s tmpFile=tmpFile_"」"_$lg(fileList,i)
	s obj.EytFile=tmpFile
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:dhh
/// Description:获取人员病区,层级,职称
/// Date:2019-07-23
/// Table:CF.DHCINM.HR.Persons
/// Input:
/// Output：
/// Return:
/// Others: w ##class(web.INMSMComm).
ClassMethod GetNurInfo(id As %String) As %String
{
	s ^TMP("sid")=id
	s obj=##class(CF.DHCINM.HR.Persons).%OpenId(id)
	s ret=""
	s warId=obj.PerDepDR
	s ret="wardId|"_warId
	//获取层级信息
	s PerLevel="",PerLevelDate=""
	s LeaveId="" f  s LeaveId=$O(^CF.DHCINM.HR.MgLevelI("ssid",id,LeaveId)) q:LeaveId=""  d
	.s LeaveObj=##class(CF.DHCINM.HR.MgLevel).%OpenId(LeaveId)
	.q:'$IsObject(LeaveObj)
	.q:LeaveObj.LevelStatus'="A"
	.q:LeaveObj.LevelDate<PerLevelDate
	.q:LeaveObj.LevelDate>+$H
	.s PerLevel=LeaveObj.NurLevel
	.s PerLevelDate=LeaveObj.LevelDate
	s ret=ret_"^PerNurseLevel|"_PerLevel
	//获取职称信息
	s PerHireDuty="",PerHireDutyDate="",HireFlag=0
	s HireDate="" f  s HireDate=$O(^CF.DHCINM.HR.HireDutyI("HireDate",id,HireDate),-1) q:(HireDate="")||(HireFlag=1)  d
	.s HireRowID=$O(^CF.DHCINM.HR.HireDutyI("HireDate",id,HireDate,""),-1)
	.s HireObj=##class(CF.DHCINM.HR.HireDuty).%OpenId(HireRowID)
	.q:'$IsObject(HireObj)
	.q:HireObj.HireStatus'="A"
	.s PerHireDuty=HireObj.HireDuty
	.i HireObj.HireStDate'="" s PerHireDutyDate=##class(web.INMHISComm).DateLogicalToHtml(HireObj.HireStDate)
	.s HireFlag=1
	s ret=ret_"^RowID|"_id_"^PerHireDuty|"_PerHireDuty_"^PerHireDutyDate|"_PerHireDutyDate
	q ret
}

/// Description: 获取年底上交论文备案
/// Date: 2020-07-24
/// Creator: dhh
/// Table: DHCINM.SM.EndYearThseis
/// Input: id 是否返回内容
/// Output: 交流获奖论文备案
/// Other: w ##class(web.INMSMComm).GetEndYearThseis(1)
ClassMethod GetEndYearThseis(id As %String = "") As %String
{
	q:(id="")||('$d(^DHCINM.SM.EndYearThseisD(id))) ""
	
	s eytGlo=^DHCINM.SM.EndYearThseisD(id)
	s eytNurse=$lg(eytGlo,2)
	s eytNurseName=""
	i eytNurse'="" d
	.s perGlo=$g(^CF.DHCINM.HR.PersonsD(eytNurse))
	.s eytNurseName=$lg(perGlo,2)
	s eytLevel=$lg(eytGlo,3)
	s eytLevelDesc=""
	i eytLevel'="" d
	.s parId=$p(eytLevel,"||")
	.s subId=$p(eytLevel,"||",2)
	.q:'$d(^CT.DHCINM.DB.MgSetCodeSubD(parId,subId))
	.s levelGlo=^CT.DHCINM.DB.MgSetCodeSubD(parId,subId)
	.s eytLevelDesc=$lg(levelGlo,3)
	s eytHire=$lg(eytGlo,4)
	i eytHire'="" d
	.s hireId=$p(eytHire,"||")
	.s hiresub=$p(eytHire,"||",2)
	.q:'$d(^CT.DHCINM.DB.MgSetCodeSubD(hireId,hiresub))
	.s hireGlo=^CT.DHCINM.DB.MgSetCodeSubD(hireId,hiresub)
	.s eytHireDesc=$lg(hireGlo,3)
	s eytWard=$lg(eytGlo,5)
	s eytWardDesc=""
	i eytWard'="" d
	.s wardGlo=$g(^CF.DHCINM.DB.MgWardD(eytWard))
	.s eytWardDesc=$lg(wardGlo,4)
	s eytTitle=$lg(eytGlo,6)
	s eytType=$lg(eytGlo,7)
	s eytTypeDesc=##class(web.INMPersonComm).GetCommCode($lg(eytGlo,7))
	s eytStatus=$lg(eytGlo,9)
	s eytStatusDesc=$case(eytStatus,"Y":"已提交","N":"已保存","B":"驳回","S":"已审核",:"")
	s creator=$lg(eytGlo,11)
	s creatorName=""
	i creator=0 s creatorName="管理员"
	e  i creator'="" d
	.s perGlo=$g(^CF.DHCINM.DB.MgUserD(creator))
	.s creatorName=$lg(perGlo,2)
	s createDate=$lg(eytGlo,12)
	s:createDate'="" createDate=$zd(createDate,3)
	s eytFile=$lg(eytGlo,8)
	s auditor=$lg(eytGlo,13)
	s auditorName=""
	i auditor=0 s auditorName="管理员"
	e  i auditor'="" d
	.s perGlo=$g(^CF.DHCINM.DB.MgUserD(auditor))
	.s auditorName=$lg(perGlo,2)
	s auditDate=$lg(eytGlo,14)
	s:auditDate'="" auditDate=$zd(auditDate,3)
	s auditTime=$lg(eytGlo,15)
	s:auditTime'="" auditTime=$zt(auditTime,1)
	s creatorWard="",auditorWard=""
	i creator'="" d
	.s creatorWard=##class(web.INMHRComm).GetCurrentWard($lg($g(^CF.DHCINM.DB.MgUserD(creator)),5),createDate)
	.s:creatorWard'="" creatorWard=$lg($g(^CF.DHCINM.DB.MgWardD(creatorWard)),4)
	i auditor'="" d
	.s auditorWard=##class(web.INMHRComm).GetCurrentWard($lg($g(^CF.DHCINM.DB.MgUserD(auditor)),5),auditDate)
	.s:auditorWard'="" auditorWard=$lg($g(^CF.DHCINM.DB.MgWardD(auditorWard)),4)
	s createTime=$lg(eytGlo,16)
	s:createTime'="" createTime=$zt(createTime,1)
	s ret="EytNurse|"_eytNurse_"^EytNurseName|"_eytNurseName_"^EytLevel|"_eytLevel_"^EytLevelDesc|"_eytLevelDesc
	s ret=ret_"^EytHire|"_eytHire_"^EytHireDesc|"_eytHireDesc_"^EytWard|"_eytWard_"^EytWardDesc|"_eytWardDesc_"^EytTitle|"_eytTitle_"^EytType|"_eytType_"^EytTypeDesc|"_eytTypeDesc
	s ret=ret_"^EytStatus|"_eytStatus_"^EytStatusDesc|"_eytStatusDesc_"^Creator|"_creator_"^CreatorName|"_creatorName_"^CreateDate|"_createDate_"^EytFile|"_eytFile_"^rw|"_id
	s ret=ret_"^Auditor|"_auditor_"^AuditorName|"_auditorName_"^AuditDate|"_auditDate_"^AuditTime|"_auditTime_"^AuditorWard|"_auditorWard_"^CreatorWard|"_creatorWard_"^CreateTime|"_createTime
	q ret
}

/// Description:获取年底上交论文备案列表
/// Date:2020-07-24
/// Creator:dhh
/// Table: DHCINM.SM.EndYearThseis
/// Input: 病区^开始日期^结束日期^关键字
/// Output:年底上交论文备案列表
/// Other:d ##class(%ResultSet).RunQuery("web.INMSMComm","FindEndYearThesisList","^2020-07-01^2020-07-31^",0)
Query FindEndYearThesisList(parr As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindEndYearThesisListExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i nurseid="" Set qHandle=$lb(0,repid,0) Quit $$$OK

	s ward=$p(parr,"^")
	s stDate=$p(parr,"^",2)
	s:stDate["-" stDate=$zdh(stDate,3)
	s endDate=$p(parr,"^",3)
	s:endDate["-" endDate=$zdh(endDate,3)
	s input=$p(parr,"^",4)
	s status=$p(parr,"^",5)
	s userPerId=""
	i nurseid'=0 d
	.s userGlo=$g(^CF.DHCINM.DB.MgUserD(nurseid))
	.s userPerId=$lg(userGlo,5)
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	s id="" f  s id=$o(^DHCINM.SM.EndYearThseisD(id),-1) q:id=""  d
	.s eytGlo=^DHCINM.SM.EndYearThseisD(id)
	.s flag=0
	.s:isAll=1 flag=1
	.s nurWard=$lg(eytGlo,5)
	.s:$d(tmpWard(nurWard)) flag=1
	.s creator=$lg(eytGlo,10)
	.s:creator=nurseid flag=1
	.q:flag'=1
	.q:(ward'="")&&(ward'=nurWard)	
	.s title=$lg(eytGlo,6)
	.q:(input'="")&&(title'="")&&(($zcvt(title,"U")'[$zcvt(input,"U")))
	.s recDate=$lg(eytGlo,12)
	.q:((stDate'="")&&(recDate<stDate))||((endDate'="")&&(recDate>endDate))
	.s stat=$lg(eytGlo,9)
	.q:(status'="")&&(status'=stat)
	.s ret=..GetEndYearThseis(id)
	.d:ret'="" OutEndYearThesisList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutEndYearThesisList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindEndYearThesisListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindEndYearThesisListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindEndYearThesisListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindEndYearThesisListExecute ]
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

/// Description: 审核年底上交论文备案
/// Date: 2020-07-24
/// Creator: dhh
/// Table: DHCINM.SM.EndYearThseis
/// Input: 状态^说明^id 登录人Id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMSMComm).AuditEndYearThseis("",0)
ClassMethod AuditEndYearThseis(parr As %String = "", nurseid As %String = "") As %String
{
	q:(parr="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	
	s status=$p(parr,"^")
	s reason=$p(parr,"^",2)
	s rw=$p(parr,"^",3)
	
	s obj=##class(DHCINM.SM.EndYearThseis).%OpenId(rw)
	q:'$IsObject(obj) 0
	i obj.EytStatus="Y" d
	.s obj.EytStatus=status
	.s obj.Reason=reason
	.s obj.Auditor=nurseid
	.s obj.AuditDate=+$h
	.s obj.AuditTime=$p($h,",",2)
	s sc=obj.%Save()
	try{
		i (($$$ISOK(sc))&&((obj.EytStatus="S")||(obj.EytStatus="B"))) d
		.s EytStatus=$case(obj.EytStatus,"S":"审核","B":"驳回") ;状态描述
		.s perId=$lg($g(^DHCINM.SM.EndYearThseisD(rw)),2) 
		.s EytNurse=""
		.s:perId'="" EytNurse=$lg($g(^CF.DHCINM.HR.PersonsD(perId)),2)
		.s wardId=$lg($g(^DHCINM.SM.EndYearThseisD(rw)),5)
		.s wardDesc=""
		.s:wardId'="" wardDesc=$lg($g(^CF.DHCINM.DB.MgWardD(wardId)),3)
		.s EytLevel=##class(web.INMPersonComm).GetCommCode(obj.EytLevel)
		.s EytHire=##class(web.INMPersonComm).GetCommCode(obj.EytHire)
		.s EytTitle=$lg($g(^DHCINM.SM.EndYearThseisD(rw)),6) 
		.s Creator=$lg($g(^DHCINM.SM.EndYearThseisD(rw)),11) 
		.s ret="【科研/年底上交论文备案】"_EytStatus_" "_EytNurse_" "_wardDesc_" "_EytLevel_" "_EytHire_" "_EytTitle
		.d ##class(web.INMPlatform).SaveTrackMessage(Creator,+$H,ret,"","DHCINM.SM.EndYearThseis",rw)
	}catch{
		}
	q $$$ISOK(sc)
}

/// Description: 删除交流获奖论文备案
/// Date: 2020-07-24
/// Creator: dhh
/// Table: DHCINM.SM.EndYearThseis
/// Input: id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMSMComm).DeleteEndYearThseis(1)
ClassMethod DeleteEndYearThseis(id As %String = "") As %String
{
	q:id="" 0
	s sc=##class(DHCINM.SM.EndYearThseis).%DeleteId(id)
	q $$$ISOK(sc)
}

/// Description: 保存科研立项备案
/// Date: 2020-07-24
/// Creator: dhh
/// Table: DHCINM.SM.RegScience
/// Input: parr
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMSMComm).SaveRegSci("2020-07-01^2020-07-01^类别^项目名称^9^9,10^完成^^N",0)
ClassMethod SaveRegSci(parr As %String = "", nurseid As %String = "") As %String
{
	q:(parr="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	
	s AppDate=$p(parr,"^")
	s:AppDate["-" AppDate=$zdh(AppDate,3)
	s ItemDate=$p(parr,"^",2)
	s:ItemDate["-" ItemDate=$zdh(ItemDate,3)
	s type=$p(parr,"^",3)
	s name=$p(parr,"^",4)
	s lead=$p(parr,"^",5)
	s part=$p(parr,"^",6)
	s partList=$lfs(part,",")
	s situation=$p(parr,"^",7)
	s rw=$p(parr,"^",8)
	s status=$p(parr,"^",9)
	i rw="" d
	.s obj=##class(DHCINM.SM.RegScience).%New()
	.s obj.Creator=nurseid
	e  s obj=##class(DHCINM.SM.RegScience).%OpenId(rw)
	q:'$IsObject(obj) 0
	s obj.RegSciAppDate=AppDate
	s obj.RegSciItemDate=ItemDate
	s obj.RegSciType=type
	s obj.RegSciName=name
	d obj.RegSciLeadSetObjectId(lead)
	d obj.RegSciPart.Clear()
	s ptr=0 f  s stat=$listnext(partList,ptr,per) q:stat'=1  d
	.q:'$d(^CF.DHCINM.HR.PersonsD(per))
	.d obj.RegSciPart.Insert(per)
	s obj.RegSciSituation=situation
	s obj.RegSciStatus=status
	s sc=obj.%Save()
	i $$$ISOK(sc) q 1
	e  q 0
}

/// Description: 获取科研立项备案
/// Date: 2020-07-24
/// Creator: dhh
/// Table: DHCINM.SM.RegScience
/// Input: id 是否返回内容
/// Output: 科研立项备案
/// Other: w ##class(web.INMSMComm).GetRegSci(1)
ClassMethod GetRegSci(id As %String = "") As %String
{
	q:(id="")||('$d(^DHCINM.SM.RegScienceD(id))) ""
	
	s regSciGlo=^DHCINM.SM.RegScienceD(id)
	s regSciAppDate=$lg(regSciGlo,2)
	s:regSciAppDate'="" regSciAppDate=$zd(regSciAppDate,3)
	s regSciItemDate=$lg(regSciGlo,3)
	s:regSciItemDate'="" regSciItemDate=$zd(regSciItemDate,3)
	s regSciType=$lg(regSciGlo,4)
	s regSciTypeDesc=##class(web.INMPersonComm).GetCommCode($lg(regSciGlo,4))
	s regSciName=$lg(regSciGlo,5)
	s regSciLead=$lg(regSciGlo,6)
	s regSciLeadName=""
	i regSciLead'="" d
	.s perGlo=$g(^CF.DHCINM.HR.PersonsD(regSciLead))
	.s regSciLeadName=$lg(perGlo,2)
	s regSciPart=$lg(regSciGlo,7)
	s regSciPartId=$lts(regSciPart,",")
	s regSciPartName=""
	s index=1,ptr=0 f  s stat=$listnext(regSciPart,ptr,per) q:stat'=1  d
	.s perGlo=$g(^CF.DHCINM.HR.PersonsD(per))
	.s perName=$lg(perGlo,2)
	.i index=1 s regSciPartName=perName
	.e  s regSciPartName=regSciPartName_","_perName
	.s index=index+1
	s regSciSituation=$lg(regSciGlo,8)
	s regSciStatus=$lg(regSciGlo,9)
	s regSciStatusDesc=$case(regSciStatus,"Y":"已提交","N":"已保存","B":"驳回","S":"已审核",:"")
	s creator=$lg(regSciGlo,11)
	s creatorName=""
	i creator=0 s creatorName="管理员"
	e  i creator'="" d
	.s perGlo=$g(^CF.DHCINM.DB.MgUserD(creator))
	.s creatorName=$lg(perGlo,2)
	s createDate=$lg(regSciGlo,12)
	s:createDate'="" createDate=$zd(createDate,3)
	s auditor=$lg(regSciGlo,13)
	s auditorName=""
	i auditor=0 s auditorName="管理员"
	e  i auditor'="" d
	.s perGlo=$g(^CF.DHCINM.DB.MgUserD(auditor))
	.s auditorName=$lg(perGlo,2)
	s auditDate=$lg(regSciGlo,14)
	s:auditDate'="" auditDate=$zd(auditDate,3)
	s auditTime=$lg(regSciGlo,15)
	s:auditTime'="" auditTime=$zt(auditTime,1)
	s creatorWard="",auditorWard=""
	i creator'="" d
	.s creatorWard=##class(web.INMHRComm).GetCurrentWard($lg($g(^CF.DHCINM.DB.MgUserD(creator)),5),createDate)
	.s:creatorWard'="" creatorWard=$lg($g(^CF.DHCINM.DB.MgWardD(creatorWard)),4)
	i auditor'="" d
	.s auditorWard=##class(web.INMHRComm).GetCurrentWard($lg($g(^CF.DHCINM.DB.MgUserD(auditor)),5),auditDate)
	.s:auditorWard'="" auditorWard=$lg($g(^CF.DHCINM.DB.MgWardD(auditorWard)),4)
	s createTime=$lg(regSciGlo,16)
	s:createTime'="" createTime=$zt(createTime,1)
	s ret="RegSciAppDate|"_regSciAppDate_"^RegSciItemDate|"_regSciItemDate_"^RegSciType|"_regSciType_"^RegSciTypeDesc|"_regSciTypeDesc_"^RegSciName|"_regSciName_"^RegSciLead|"_regSciLead_"^RegSciLeadName|"_regSciLeadName
	s ret=ret_"^RegSciPart|"_regSciPartId_"^RegSciPartName|"_regSciPartName_"^RegSciSituation|"_regSciSituation_"^RegSciStatus|"_regSciStatus
	s ret=ret_"^RegSciStatusDesc|"_regSciStatusDesc_"^Creator|"_creator_"^CreatorName|"_creatorName_"^CreateDate|"_createDate_"^rw|"_id
	s ret=ret_"^Auditor|"_auditor_"^AuditorName|"_auditorName_"^AuditDate|"_auditDate_"^AuditTime|"_auditTime_"^AuditorWard|"_auditorWard_"^CreatorWard|"_creatorWard_"^CreateTime|"_createTime
	q ret
}

/// Description:获取科研立项备案列表
/// Date:2020-07-24
/// Creator:dhh
/// Table: DHCINM.SM.RegScience
/// Input: 病区^开始日期^结束日期^关键字
/// Output:科研立项备案列表
/// Other:d ##class(%ResultSet).RunQuery("web.INMSMComm","FindRegSciList","^2020-07-01^2020-07-31^",0)
Query FindRegSciList(parr As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindRegSciListExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i nurseid="" Set qHandle=$lb(0,repid,0) Quit $$$OK

	s ward=$p(parr,"^")
	s stDate=$p(parr,"^",2)
	s:stDate["-" stDate=$zdh(stDate,3)
	s endDate=$p(parr,"^",3)
	s:endDate["-" endDate=$zdh(endDate,3)
	s input=$p(parr,"^",4)
	s status=$p(parr,"^",5)
	s userPerId=""
	i nurseid'=0 d
	.s userGlo=$g(^CF.DHCINM.DB.MgUserD(nurseid))
	.s userPerId=$lg(userGlo,5)
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	s id="" f  s id=$o(^DHCINM.SM.RegScienceD(id),-1) q:id=""  d
	.s regSciGlo=^DHCINM.SM.RegScienceD(id)
	.s flag=0
	.s:isAll=1 flag=1
	.s lead=$lg(regSciGlo,6)
	.s perGlo=$g(^CF.DHCINM.HR.PersonsD(lead))
	.s leadward=$lg(perGlo,10)
	.s:((leadward'="")&&$d(tmpWard(leadward))) flag=1
	.s creator=$lg(regSciGlo,10)
	.s:creator=nurseid flag=1
	.q:flag'=1
	.q:(ward'="")&&(ward'=leadward)	
	.s title=$lg(regSciGlo,5)
	.q:(input'="")&&(title'="")&&(($zcvt(title,"U")'[$zcvt(input,"U")))
	.s recDate=$lg(regSciGlo,2)
	.q:((stDate'="")&&(recDate<stDate))||((endDate'="")&&(recDate>endDate))
	.s stat=$lg(regSciGlo,9)
	.q:(status'="")&&(status'=stat)
	.s ret=..GetRegSci(id)
	.d:ret'="" OutRegSciList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRegSciList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindRegSciListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindRegSciListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindRegSciListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindRegSciListExecute ]
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

/// Description: 审核科研立项备案
/// Date: 2020-07-24
/// Creator: dhh
/// Table: DHCINM.SM.RegScience
/// Input: 状态^说明^id 登录人Id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMSMComm).AuditRegScience("",0)
ClassMethod AuditRegScience(parr As %String = "", nurseid As %String = "") As %String
{
	q:(parr="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	
	s status=$p(parr,"^")
	s reason=$p(parr,"^",2)
	s rw=$p(parr,"^",3)
	
	s obj=##class(DHCINM.SM.RegScience).%OpenId(rw)
	q:'$IsObject(obj) 0
	i obj.RegSciStatus="Y" d
	.s obj.RegSciStatus=status
	.s obj.Reason=reason
	.s obj.Auditor=nurseid
	.s obj.AuditDate=+$h
	.s obj.AuditTime=$p($h,",",2)
	s sc=obj.%Save()
	try{
		i (($$$ISOK(sc))&&((obj.RegSciStatus="S")||(obj.RegSciStatus="B"))) d
		.s RegSciStatus=$case(obj.RegSciStatus,"S":"审核","B":"驳回") ;状态描述
		.s RegSciAppDate=$lg($g(^DHCINM.SM.RegScienceD(rw)),2)
		.s:RegSciAppDate'="" RegSciAppDate=$zd(RegSciAppDate,3)
		.s RegSciName=$lg($g(^DHCINM.SM.RegScienceD(rw)),5)
		.s RegSciLeadId=$lg($g(^DHCINM.SM.RegScienceD(rw)),6)
		.s RegSciLead=""
		.s:RegSciLeadId'="" RegSciLead=$lg($g(^CF.DHCINM.HR.PersonsD(RegSciLeadId)),2)
		.s Creator=$lg($g(^DHCINM.SM.RegScienceD(rw)),11) 
		.s ret="【科研/科研立项备案】"_RegSciStatus_" "_RegSciAppDate_" "_RegSciName_" "_RegSciLead
		.d ##class(web.INMPlatform).SaveTrackMessage(Creator,+$H,ret,"","DHCINM.SM.RegScience",rw)
	}catch{
		}
	q $$$ISOK(sc)
}

/// Description: 删除科研立项备案
/// Date: 2020-07-24
/// Creator: dhh
/// Table: DHCINM.SM.RegScience
/// Input: id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMSMComm).DeleteRegScience(1)
ClassMethod DeleteRegScience(id As %String = "") As %String
{
	q:id="" 0
	s sc=##class(DHCINM.SM.RegScience).%DeleteId(id)
	q $$$ISOK(sc)
}

/// Description: 保存科室创新备案
/// Date: 2020-07-24
/// Creator: dhh
/// Table: DHCINM.SM.LocInnovate
/// Input: parr
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMSMComm).SaveLocInn("",0)
ClassMethod SaveLocInn(parr As %String = "", nurseid As %String = "") As %String
{
	q:(parr="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	
	s type=$p(parr,"^")
	s theme=$p(parr,"^",2)
	s ward=$p(parr,"^",3)
	s spec=$p(parr,"^",4)
	s lead=$p(parr,"^",5)
	s part=$p(parr,"^",6)
	s partList=$lfs(part,",")
	s background=$p(parr,"^",7)
	s advantage=$p(parr,"^",8)
	s method=$p(parr,"^",9)
	s effect=$p(parr,"^",10)
	s rw=$p(parr,"^",11)
	s status=$p(parr,"^",12)
	i rw="" d
	.s obj=##class(DHCINM.SM.LocInnovate).%New()
	.s obj.Creator=nurseid
	e  s obj=##class(DHCINM.SM.LocInnovate).%OpenId(rw)
	q:'$IsObject(obj) 0
	s obj.LocInnType=type
	s obj.LocInnTheme=theme
	d obj.LocInnWardSetObjectId(ward)
	s obj.LocInnSpec=spec
	d obj.LocInnLeadSetObjectId(lead)
	d obj.LocInnPart.Clear()
	s ptr=0 f  s stat=$listnext(partList,ptr,per) q:stat'=1  d
	.q:'$d(^CF.DHCINM.HR.PersonsD(per))
	.d obj.LocInnPart.Insert(per)
	s obj.LocInnBackGround=background
	s obj.LocInnAdvantage=advantage
	s obj.LocInnMethod=method
	s obj.LocInnEffect=effect
	s obj.LocInnStatus=status
	s sc=obj.%Save()
	i $$$ISOK(sc) q obj.%Id()
	e  q 0
}

/// Description: 保存科室创新前图片
/// Date: 2020-08-26
/// Creator: dhh
/// Table: DHCINM.SM.LocInnovate
/// Input: id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMSMComm).SaveLocInnBfPic(3,"")
ClassMethod SaveLocInnBfPic(id As %String = "", name As %String = "") As %String
{
	q:(id="")||(name="") 0
	
	s obj=##class(DHCINM.SM.LocInnovate).%OpenId(id)
	q:'$IsObject(obj) 0
	i obj.LocInnBfPic="" s obj.LocInnBfPic=name
	e  s obj.LocInnBfPic=obj.LocInnBfPic_"」"_name
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Description: 删除科室创新前图片
/// Date: 2020-08-26
/// Creator: dhh
/// Table: DHCINM.SM.LocInnovate
/// Input: id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMSMComm).DeleteLocInnBfPic(2,"",0)
ClassMethod DeleteLocInnBfPic(id As %String = "", name As %String = "", nurseid As %String = "") As %String
{
	q:(id="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	
	s obj=##class(DHCINM.SM.LocInnovate).%OpenId(id)
	q:'$IsObject(obj) 0
	q:(nurseid'=0)&&(obj.Creator'=nurseid) 0
	s fileList=$lfs(obj.LocInnBfPic,"」")
	s exist=0,index=0
	s ptr=0 f  s status=$listnext(fileList,ptr,file) q:(status'=1)||(exist'=0)  d
	.s:file=name exist=1
	.s index=index+1
	q:exist=0 0
	s fileLength=$l(obj.LocInnBfPic,"」")
	s tmpFile=""
	f i=1:1:fileLength d
	.q:i=index
	.i tmpFile="" s tmpFile=$lg(fileList,i)
	.e  s tmpFile=tmpFile_"」"_$lg(fileList,i)
	s obj.LocInnBfPic=tmpFile
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Description: 保存科室创新后图片
/// Date: 2020-08-26
/// Creator: dhh
/// Table: DHCINM.SM.LocInnovate
/// Input: id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMSMComm).SaveLocInnBfPic(3,"")
ClassMethod SaveLocInnAfPic(id As %String = "", name As %String = "") As %String
{
	q:(id="")||(name="") 0
	
	s obj=##class(DHCINM.SM.LocInnovate).%OpenId(id)
	q:'$IsObject(obj) 0
	i obj.LocInnAfPic="" s obj.LocInnAfPic=name
	e  s obj.LocInnAfPic=obj.LocInnAfPic_"」"_name
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Description: 删除科室创新后图片
/// Date: 2020-08-26
/// Creator: dhh
/// Table: DHCINM.SM.LocInnovate
/// Input: id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMSMComm).DeleteLocInnBfPic(2,"",0)
ClassMethod DeleteLocInnAfPic(id As %String = "", name As %String = "", nurseid As %String = "") As %String
{
	q:(id="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	
	s obj=##class(DHCINM.SM.LocInnovate).%OpenId(id)
	q:'$IsObject(obj) 0
	q:(nurseid'=0)&&(obj.Creator'=nurseid) 0
	s fileList=$lfs(obj.LocInnAfPic,"」")
	s exist=0,index=0
	s ptr=0 f  s status=$listnext(fileList,ptr,file) q:(status'=1)||(exist'=0)  d
	.s:file=name exist=1
	.s index=index+1
	q:exist=0 0
	s fileLength=$l(obj.LocInnAfPic,"」")
	s tmpFile=""
	f i=1:1:fileLength d
	.q:i=index
	.i tmpFile="" s tmpFile=$lg(fileList,i)
	.e  s tmpFile=tmpFile_"」"_$lg(fileList,i)
	s obj.LocInnAfPic=tmpFile
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Description: 获取科室创新备案
/// Date: 2020-07-24
/// Creator: dhh
/// Table: DHCINM.SM.LocInnovate
/// Input: id 是否返回内容
/// Output: 科室创新备案
/// Other: w ##class(web.INMSMComm).GetLocInn(1)
ClassMethod GetLocInn(id As %String = "") As %String
{
	q:(id="")||('$d(^DHCINM.SM.LocInnovateD(id))) ""
	
	s locInnGlo=^DHCINM.SM.LocInnovateD(id)
	s locInnType=$lg(locInnGlo,2)
	s locInnTypeDesc=##class(web.INMPersonComm).GetCommCode($lg(locInnGlo,2))
	s locInnTheme=$lg(locInnGlo,3)
	s locInnWard=$lg(locInnGlo,4)
	s locInnWardDesc=""
	i locInnWard'="" d
	.s wardGlo=$g(^CF.DHCINM.DB.MgWardD(locInnWard))
	.s locInnWardDesc=$lg(wardGlo,4)
	s locInnSpec=$lg(locInnGlo,5)
	s locInnSpecDesc=$case(locInnSpec,"Y":"是","N":"否",:"")
	s locInnLead=$lg(locInnGlo,6)
	s locInnLeadName=""
	i locInnLead'="" d
	.s perGlo=$g(^CF.DHCINM.HR.PersonsD(locInnLead))
	.s locInnLeadName=$lg(perGlo,2)
	s locInnPart=$lg(locInnGlo,7)
	s locInnPartId=$lts(locInnPart,",")
	s locInnPartName=""
	s index=1,ptr=0 f  s stat=$listnext(locInnPart,ptr,per) q:stat'=1  d
	.s perGlo=$g(^CF.DHCINM.HR.PersonsD(per))
	.s perName=$lg(perGlo,2)
	.i index=1 s locInnPartName=perName
	.e  s locInnPartName=locInnPartName_","_perName
	.s index=index+1
	s locInnBackGround=$lg(locInnGlo,8)
	s locInnAdvantage=$lg(locInnGlo,9)
	s locInnMethod=$lg(locInnGlo,10)
	s locInnEffect=$lg(locInnGlo,11)
	s locInnStatus=$lg(locInnGlo,14)
	s locInnStatusDesc=$case(locInnStatus,"Y":"已提交","N":"已保存","B":"驳回","S":"已审核",:"")
	s creator=$lg(locInnGlo,16)
	s creatorName=""
	i creator=0 s creatorName="管理员"
	e  i creator'="" d
	.s perGlo=$g(^CF.DHCINM.DB.MgUserD(creator))
	.s creatorName=$lg(perGlo,2)
	s createDate=$lg(locInnGlo,17)
	s:createDate'="" createDate=$zd(createDate,3)
	s locInnBfPic=$lg(locInnGlo,12)
	s locInnAfPic=$lg(locInnGlo,13)
	s auditor=$lg(locInnGlo,18)
	s auditorName=""
	i auditor=0 s auditorName="管理员"
	e  i auditor'="" d
	.s perGlo=$g(^CF.DHCINM.DB.MgUserD(auditor))
	.s auditorName=$lg(perGlo,2)
	s auditDate=$lg(locInnGlo,19)
	s:auditDate'="" auditDate=$zd(auditDate,3)
	s auditTime=$lg(locInnGlo,20)
	s:auditTime'="" auditTime=$zt(auditTime,1)
	s creatorWard="",auditorWard=""
	i creator'="" d
	.s creatorWard=##class(web.INMHRComm).GetCurrentWard($lg($g(^CF.DHCINM.DB.MgUserD(creator)),5),createDate)
	.s:creatorWard'="" creatorWard=$lg($g(^CF.DHCINM.DB.MgWardD(creatorWard)),4)
	i auditor'="" d
	.s auditorWard=##class(web.INMHRComm).GetCurrentWard($lg($g(^CF.DHCINM.DB.MgUserD(auditor)),5),auditDate)
	.s:auditorWard'="" auditorWard=$lg($g(^CF.DHCINM.DB.MgWardD(auditorWard)),4)
	s createTime=$lg(locInnGlo,21)
	s:createTime'="" createTime=$zt(createTime,1)
	s ret="LocInnType|"_locInnType_"^LocInnTypeDesc|"_locInnTypeDesc_"^LocInnTheme|"_locInnTheme_"^LocInnWard|"_locInnWard_"^LocInnWardDesc|"_locInnWardDesc_"^LocInnSpec|"_locInnSpec_"^LocInnSpecDesc|"_locInnSpecDesc
	s ret=ret_"^LocInnLead|"_locInnLead_"^LocInnLeadName|"_locInnLeadName_"^LocInnPart|"_locInnPartId_"^LocInnPartName|"_locInnPartName_"^LocInnBackGround|"_locInnBackGround_"^LocInnAdvantage|"_locInnAdvantage_"^BfPic|"_locInnBfPic_"^AfPic|"_locInnAfPic
	s ret=ret_"^LocInnMethod|"_locInnMethod_"^LocInnEffect|"_locInnEffect_"^LocInnStatus|"_locInnStatus_"^LocInnStatusDesc|"_locInnStatusDesc_"^Creator|"_creator_"^CreatorName|"_creatorName_"^CreateDate|"_createDate_"^rw|"_id
	s ret=ret_"^Auditor|"_auditor_"^AuditorName|"_auditorName_"^AuditDate|"_auditDate_"^AuditTime|"_auditTime_"^AuditorWard|"_auditorWard_"^CreatorWard|"_creatorWard_"^CreateTime|"_createTime
	q ret
}

/// Description:获取科室创新备案列表
/// Date:2020-07-24
/// Creator:dhh
/// Table: DHCINM.SM.LocInnovate
/// Input: 病区^开始日期^结束日期^关键字
/// Output:科室创新备案列表
/// Other:d ##class(%ResultSet).RunQuery("web.INMSMComm","FindLocInnList","^2020-07-01^2020-07-31^",0)
Query FindLocInnList(parr As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindLocInnListExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i nurseid="" Set qHandle=$lb(0,repid,0) Quit $$$OK

	s ward=$p(parr,"^")
	s stDate=$p(parr,"^",2)
	s:stDate["-" stDate=$zdh(stDate,3)
	s endDate=$p(parr,"^",3)
	s:endDate["-" endDate=$zdh(endDate,3)
	s input=$p(parr,"^",4)
	s status=$p(parr,"^",5)
	s userPerId=""
	i nurseid'=0 d
	.s userGlo=$g(^CF.DHCINM.DB.MgUserD(nurseid))
	.s userPerId=$lg(userGlo,5)
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	s id="" f  s id=$o(^DHCINM.SM.LocInnovateD(id),-1) q:id=""  d
	.s locInnGlo=^DHCINM.SM.LocInnovateD(id)
	.s flag=0
	.s:isAll=1 flag=1
	.s nurWard=$lg(locInnGlo,4)
	.s:$d(tmpWard(nurWard)) flag=1
	.s creator=$lg(locInnGlo,16)
	.s:creator=nurseid flag=1
	.q:flag'=1
	.q:(ward'="")&&(ward'=nurWard)	
	.s title=$lg(locInnGlo,3)
	.q:(input'="")&&(title'="")&&(($zcvt(title,"U")'[$zcvt(input,"U")))
	.s recDate=$lg(locInnGlo,17)
	.q:((stDate'="")&&(recDate<stDate))||((endDate'="")&&(recDate>endDate))
	.s stat=$lg(locInnGlo,14)
	.q:(status'="")&&(status'=stat)
	.s ret=..GetLocInn(id)
	.d:ret'="" OutLocInnList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutLocInnList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindLocInnListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindLocInnListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindLocInnListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindLocInnListExecute ]
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

/// Description: 审核科室创新备案
/// Date: 2020-07-24
/// Creator: dhh
/// Table: DHCINM.SM.LocInnovate
/// Input: 状态^说明^id 登录人Id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMSMComm).AuditLocInn("",0)
ClassMethod AuditLocInn(parr As %String = "", nurseid As %String = "") As %String
{
	q:(parr="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	s status=$p(parr,"^")
	s reason=$p(parr,"^",2)
	s rw=$p(parr,"^",3)
	s obj=##class(DHCINM.SM.LocInnovate).%OpenId(rw)
	q:'$IsObject(obj) 0
	i obj.LocInnStatus="Y" d
	.s obj.LocInnStatus=status
	.s obj.Reason=reason
	.s obj.Auditor=nurseid
	.s obj.AuditDate=+$h
	.s obj.AuditTime=$p($h,",",2)
	s sc=obj.%Save()
	try{
		i (($$$ISOK(sc))&&((obj.LocInnStatus="S")||(obj.LocInnStatus="B"))) d
		.s LocInnStatus=$case(obj.LocInnStatus,"S":"审核","B":"驳回") ;状态描述
		.s LocInnTheme=$lg($g(^DHCINM.SM.LocInnovateD(rw)),3)
		.s LocInnType=##class(web.INMPersonComm).GetCommCode(obj.LocInnType)
		.s LocInnLeadId=$lg($g(^DHCINM.SM.LocInnovateD(rw)),6)
		.s LocInnLead=""
		.s:LocInnLeadId'="" LocInnLead=$lg($g(^CF.DHCINM.HR.PersonsD(LocInnLeadId)),2)
		.s LocInnWard=$lg($g(^DHCINM.SM.LocInnovateD(rw)),4)
		.s LocInnWardDesc=""
		.s:LocInnWard'="" LocInnWardDesc=$lg($g(^CF.DHCINM.DB.MgWardD(LocInnWard)),4)
		.s Creator=$lg($g(^DHCINM.SM.LocInnovateD(rw)),16)
		.s ret="【科研/科室创新备案】"_LocInnStatus_" "_LocInnTheme_" "_LocInnType_" "_LocInnLead_" "_LocInnWardDesc
		.d ##class(web.INMPlatform).SaveTrackMessage(Creator,+$H,ret,"","DHCINM.SM.LocInnovate",rw)
	}catch{
		}
	q $$$ISOK(sc)
}

/// Description: 删除科室创新备案
/// Date: 2020-07-24
/// Creator: dhh
/// Table: DHCINM.SM.LocInnovate
/// Input: id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMSMComm).DeleteLocInn(1)
ClassMethod DeleteLocInn(id As %String = "") As %String
{
	q:id="" 0
	s sc=##class(DHCINM.SM.LocInnovate).%DeleteId(id)
	q $$$ISOK(sc)
}

/// Description: 保存获奖创新备案
/// Date: 2020-07-27
/// Creator: dhh
/// Table: DHCINM.SM.AwaInnovate
/// Input: parr
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMSMComm).SaveAwaInn("",0)
ClassMethod SaveAwaInn(parr As %String = "", nurseid As %String = "") As %String
{
	q:(parr="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	
	s type=$p(parr,"^")
	s theme=$p(parr,"^",2)
	s ward=$p(parr,"^",3)
	s spec=$p(parr,"^",4)
	s lead=$p(parr,"^",5)
	s part=$p(parr,"^",6)
	s partList=$lfs(part,",")
	s award=$p(parr,"^",7)
	s level=$p(parr,"^",8)
	s rw=$p(parr,"^",9)
	s status=$p(parr,"^",10)
	i rw="" d
	.s obj=##class(DHCINM.SM.AwaInnovate).%New()
	.s obj.Creator=nurseid
	e  s obj=##class(DHCINM.SM.AwaInnovate).%OpenId(rw)
	q:'$IsObject(obj) 0
	s obj.AwaInnType=type
	s obj.AwaInnTheme=theme
	d obj.AwaInnWardSetObjectId(ward)
	s obj.AwaInnSpec=spec
	d obj.AwaInnLeadSetObjectId(lead)
	d obj.AwaInnPart.Clear()
	s ptr=0 f  s stat=$listnext(partList,ptr,per) q:stat'=1  d
	.q:'$d(^CF.DHCINM.HR.PersonsD(per))
	.d obj.AwaInnPart.Insert(per)
	s obj.AwaInnAward=award
	s obj.AwaInnLevel=level
	s obj.AwaInnStatus=status
	s sc=obj.%Save()
	i $$$ISOK(sc) q obj.%Id()
	e  q 0
}

/// Description: 保存获奖创新文件
/// Date: 2020-08-27
/// Creator: dhh
/// Table: DHCINM.SM.AwaInnovate
/// Input: id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMSMComm).SaveAwa(3,"")
ClassMethod SaveAwa(id As %String = "", name As %String = "") As %String
{
	q:(id="")||(name="") 0
	
	s obj=##class(DHCINM.SM.AwaInnovate).%OpenId(id)
	q:'$IsObject(obj) 0
	i obj.AwaInnPic="" s obj.AwaInnPic=name
	e  s obj.AwaInnPic=obj.AwaInnPic_"」"_name
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Description: 删除获奖创新文件
/// Date: 2020-08-27
/// Creator: dhh
/// Table: DHCINM.SM.AwaInnovate
/// Input: id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMSMComm).DeleteAwa(2,"",0)
ClassMethod DeleteAwa(id As %String = "", name As %String = "", nurseid As %String = "") As %String
{
	q:(id="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	
	s obj=##class(DHCINM.SM.AwaInnovate).%OpenId(id)
	q:'$IsObject(obj) 0
	q:(nurseid'=0)&&(obj.Creator'=nurseid) 0
	s fileList=$lfs(obj.AwaInnPic,"」")
	s exist=0,index=0
	s ptr=0 f  s status=$listnext(fileList,ptr,file) q:(status'=1)||(exist'=0)  d
	.s:file=name exist=1
	.s index=index+1
	q:exist=0 0
	s fileLength=$l(obj.AwaInnPic,"」")
	s tmpFile=""
	f i=1:1:fileLength d
	.q:i=index
	.i tmpFile="" s tmpFile=$lg(fileList,i)
	.e  s tmpFile=tmpFile_"」"_$lg(fileList,i)
	s obj.AwaInnPic=tmpFile
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Description: 获取获奖创新备案
/// Date: 2020-07-27
/// Creator: dhh
/// Table: DHCINM.SM.AwaInnovate
/// Input: id 是否返回内容
/// Output: 获奖创新备案
/// Other: w ##class(web.INMSMComm).GetAwaInn(1)
ClassMethod GetAwaInn(id As %String = "") As %String
{
	q:(id="")||('$d(^DHCINM.SM.AwaInnovateD(id))) ""
	
	s AwaInnGlo=^DHCINM.SM.AwaInnovateD(id)
	s awaInnType=$lg(AwaInnGlo,2)
	s awaInnTypeDesc=##class(web.INMPersonComm).GetCommCode($lg(AwaInnGlo,2))
	s awaInnTheme=$lg(AwaInnGlo,3)
	s awaInnWard=$lg(AwaInnGlo,4)
	s awaInnWardDesc=""
	i awaInnWard'="" d
	.s wardGlo=$g(^CF.DHCINM.DB.MgWardD(awaInnWard))
	.s awaInnWardDesc=$lg(wardGlo,4)
	s awaInnSpec=$lg(AwaInnGlo,5)
	s awaInnSpecDesc=$case(awaInnSpec,"Y":"是","N":"否",:"")
	s awaInnLead=$lg(AwaInnGlo,6)
	s awaInnLeadName=""
	i awaInnLead'="" d
	.s perGlo=$g(^CF.DHCINM.HR.PersonsD(awaInnLead))
	.s awaInnLeadName=$lg(perGlo,2)
	s awaInnPart=$lg(AwaInnGlo,7)
	s awaInnPartId=$lts(awaInnPart,",")
	s awaInnPartName=""
	s index=1,ptr=0 f  s stat=$listnext(awaInnPart,ptr,per) q:stat'=1  d
	.s perGlo=$g(^CF.DHCINM.HR.PersonsD(per))
	.s perName=$lg(perGlo,2)
	.i index=1 s awaInnPartName=perName
	.e  s awaInnPartName=awaInnPartName_","_perName
	.s index=index+1
	s awaInnAward=$lg(AwaInnGlo,8)
	s awaInnAwardDesc=##class(web.INMPersonComm).GetCommCode(awaInnAward)
	s awaInnLevel=$lg(AwaInnGlo,9)
	s awaInnLevelDesc=##class(web.INMPersonComm).GetCommCode(awaInnLevel)
	s awaInnStatus=$lg(AwaInnGlo,11)
	s awaInnStatusDesc=$case(awaInnStatus,"Y":"已提交","N":"已保存","B":"驳回","S":"已审核",:"")
	s creator=$lg(AwaInnGlo,13)
	s creatorName=""
	i creator=0 s creatorName="管理员"
	e  i creator'="" d
	.s perGlo=$g(^CF.DHCINM.DB.MgUserD(creator))
	.s creatorName=$lg(perGlo,2)
	s createDate=$lg(AwaInnGlo,14)
	s:createDate'="" createDate=$zd(createDate,3)
	s AwaInnPic=$lg(AwaInnGlo,10)
	s auditor=$lg(AwaInnGlo,15)
	s auditorName=""
	i auditor=0 s auditorName="管理员"
	e  i auditor'="" d
	.s perGlo=$g(^CF.DHCINM.DB.MgUserD(auditor))
	.s auditorName=$lg(perGlo,2)
	s auditDate=$lg(AwaInnGlo,16)
	s:auditDate'="" auditDate=$zd(auditDate,3)
	s auditTime=$lg(AwaInnGlo,17)
	s:auditTime'="" auditTime=$zt(auditTime,1)
	s creatorWard="",auditorWard=""
	i creator'="" d
	.s creatorWard=##class(web.INMHRComm).GetCurrentWard($lg($g(^CF.DHCINM.DB.MgUserD(creator)),5),createDate)
	.s:creatorWard'="" creatorWard=$lg($g(^CF.DHCINM.DB.MgWardD(creatorWard)),4)
	i auditor'="" d
	.s auditorWard=##class(web.INMHRComm).GetCurrentWard($lg($g(^CF.DHCINM.DB.MgUserD(auditor)),5),auditDate)
	.s:auditorWard'="" auditorWard=$lg($g(^CF.DHCINM.DB.MgWardD(auditorWard)),4)
	s createTime=$lg(AwaInnGlo,18)
	s:createTime'="" createTime=$zt(createTime,1)
	s ret="AwaInnType|"_awaInnType_"^AwaInnTypeDesc|"_awaInnTypeDesc_"^AwaInnTheme|"_awaInnTheme_"^AwaInnWard|"_awaInnWard_"^AwaInnWardDesc|"_awaInnWardDesc_"^AwaInnSpec|"_awaInnSpec_"^AwaInnSpecDesc|"_awaInnSpecDesc
	s ret=ret_"^AwaInnLead|"_awaInnLead_"^AwaInnLeadName|"_awaInnLeadName_"^AwaInnPart|"_awaInnPartId_"^AwaInnPartName|"_awaInnPartName_"^AwaInnAward|"_awaInnAward_"^AwaInnAwardDesc|"_awaInnAwardDesc_"^AwaPic|"_AwaInnPic
	s ret=ret_"^AwaInnLevel|"_awaInnLevel_"^AwaInnLevelDesc|"_awaInnLevelDesc_"^AwaInnStatus|"_awaInnStatus_"^AwaInnStatusDesc|"_awaInnStatusDesc_"^Creator|"_creator_"^CreatorName|"_creatorName_"^CreateDate|"_createDate_"^rw|"_id
	s ret=ret_"^Auditor|"_auditor_"^AuditorName|"_auditorName_"^AuditDate|"_auditDate_"^AuditTime|"_auditTime_"^AuditorWard|"_auditorWard_"^CreatorWard|"_creatorWard_"^CreateTime|"_createTime
	q ret
}

/// Description:获取获奖创新备案列表
/// Date:2020-07-24
/// Creator:dhh
/// Table: DHCINM.SM.AwaInnovate
/// Input: 病区^开始日期^结束日期^关键字
/// Output:获奖创新备案列表
/// Other:d ##class(%ResultSet).RunQuery("web.INMSMComm","FindAwaInnList","^2020-07-01^2020-07-31^",0)
Query FindAwaInnList(parr As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindAwaInnListExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i nurseid="" Set qHandle=$lb(0,repid,0) Quit $$$OK

	s ward=$p(parr,"^")
	s stDate=$p(parr,"^",2)
	s:stDate["-" stDate=$zdh(stDate,3)
	s endDate=$p(parr,"^",3)
	s:endDate["-" endDate=$zdh(endDate,3)
	s input=$p(parr,"^",4)
	s status=$p(parr,"^",5)
	s userPerId=""
	i nurseid'=0 d
	.s userGlo=$g(^CF.DHCINM.DB.MgUserD(nurseid))
	.s userPerId=$lg(userGlo,5)
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	s id="" f  s id=$o(^DHCINM.SM.AwaInnovateD(id),-1) q:id=""  d
	.s AwaInnGlo=^DHCINM.SM.AwaInnovateD(id)
	.s flag=0
	.s:isAll=1 flag=1
	.s nurWard=$lg(AwaInnGlo,4)
	.s:((nurWard'="")&&($d(tmpWard(nurWard)))) flag=1
	.s creator=$lg(AwaInnGlo,13)
	.s:creator=nurseid flag=1
	.q:flag'=1
	.q:(ward'="")&&(ward'=nurWard)	
	.s title=$lg(AwaInnGlo,3)
	.q:(input'="")&&(title'="")&&(($zcvt(title,"U")'[$zcvt(input,"U")))
	.s recDate=$lg(AwaInnGlo,14)
	.q:((stDate'="")&&(recDate<stDate))||((endDate'="")&&(recDate>endDate))
	.s stat=$lg(AwaInnGlo,11)
	.q:(status'="")&&(status'=stat)
	.s ret=..GetAwaInn(id)
	.d:ret'="" OutAwaInnList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutAwaInnList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindAwaInnListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAwaInnListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindAwaInnListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAwaInnListExecute ]
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

/// Description: 审核获奖创新备案
/// Date: 2020-07-27
/// Creator: dhh
/// Table: DHCINM.SM.AwaInnovate
/// Input: 状态^说明^id 登录人Id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMSMComm).AuditAwaInn("",0)
ClassMethod AuditAwaInn(parr As %String = "", nurseid As %String = "") As %String
{
	q:(parr="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	s status=$p(parr,"^")
	s reason=$p(parr,"^",2)
	s rw=$p(parr,"^",3)
	s obj=##class(DHCINM.SM.AwaInnovate).%OpenId(rw)
	q:'$IsObject(obj) 0
	i obj.AwaInnStatus="Y" d
	.s obj.AwaInnStatus=status
	.s obj.Reason=reason
	.s obj.Auditor=nurseid
	.s obj.AuditDate=+$h
	.s obj.AuditTime=$p($h,",",2)
	s sc=obj.%Save()
	try{
		i (($$$ISOK(sc))&&((obj.AwaInnStatus="S")||(obj.AwaInnStatus="B"))) d
		.s AwaInnStatus=$case(obj.AwaInnStatus,"S":"审核","B":"驳回") ;状态描述
		.s AwaInnTheme=$lg($g(^DHCINM.SM.AwaInnovateD(rw)),3)
		.s AwaInnType=##class(web.INMPersonComm).GetCommCode(obj.AwaInnType)
		.s AwaInnAward=##class(web.INMPersonComm).GetCommCode(obj.AwaInnAward)
		.s AwaInnLevel=##class(web.INMPersonComm).GetCommCode(obj.AwaInnLevel)
		.s AwaInnLeadId=$lg($g(^DHCINM.SM.AwaInnovateD(rw)),6)
		.s AwaInnLead=""
		.s:AwaInnLeadId'="" AwaInnLead=$lg($g(^CF.DHCINM.HR.PersonsD(AwaInnLeadId)),2)
		.s AwaInnWard=$lg($g(^DHCINM.SM.AwaInnovateD(rw)),4)
		.s AwaInnWardDesc=""
		.s:AwaInnWard'="" AwaInnWardDesc=$lg($g(^CF.DHCINM.DB.MgWardD(AwaInnWard)),4)
		.s Creator=$lg($g(^DHCINM.SM.AwaInnovateD(rw)),13)
		.s ret="【科研/获奖创新备案】"_AwaInnStatus_" "_AwaInnTheme_" "_AwaInnType_" "_AwaInnAward_" "_AwaInnLevel_" "_AwaInnLead_" "_AwaInnWardDesc
		.d ##class(web.INMPlatform).SaveTrackMessage(Creator,+$H,ret,"","DHCINM.SM.AwaInnovate",rw)
	}catch{
		}
	q $$$ISOK(sc)
}

/// Description: 删除获奖创新备案
/// Date: 2020-07-27
/// Creator: dhh
/// Table: DHCINM.SM.AwaInnovate
/// Input: id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMSMComm).DeleteAwaInn(1)
ClassMethod DeleteAwaInn(id As %String = "") As %String
{
	q:id="" 0
	s sc=##class(DHCINM.SM.AwaInnovate).%DeleteId(id)
	q $$$ISOK(sc)
}

/// Description: 保存专利备案
/// Date: 2020-07-27
/// Creator: dhh
/// Table: DHCINM.SM.Patent
/// Input: parr
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMSMComm).SavePatent("阿萨大^I^阿萨大^阿萨大^2020-07-01^9,10^^N^1",0)
ClassMethod SavePatent(parr As %String = "", nurseid As %String = "") As %String
{
	q:(parr="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	
	s name=$p(parr,"^")
	s type=$p(parr,"^",2)
	s mechanism=$p(parr,"^",3)
	s number=$p(parr,"^",4)
	s date=$p(parr,"^",5)
	s:date["-" date=$zdh(date,3)
	s part=$p(parr,"^",6)
	s partList=$lfs(part,",")
	s rw=$p(parr,"^",7)
	s status=$p(parr,"^",8)
	s ward=$p(parr,"^",9)
	i rw="" d
	.s obj=##class(DHCINM.SM.Patent).%New()
	.s obj.Creator=nurseid
	e  s obj=##class(DHCINM.SM.Patent).%OpenId(rw)
	q:'$IsObject(obj) 0
	s obj.PatentName=name
	s obj.PatentType=type
	s obj.PatentMechanism=mechanism
	s obj.PatentNumber=number
	s obj.PatentDate=date
	d obj.PatentWardSetObjectId(ward)
	d obj.PatentPer.Clear()
	s ptr=0 f  s stat=$listnext(partList,ptr,per) q:stat'=1  d
	.q:'$d(^CF.DHCINM.HR.PersonsD(per))
	.d obj.PatentPer.Insert(per)
	s obj.PatentStatus=status
	s sc=obj.%Save()
	i $$$ISOK(sc) q obj.%Id()
	e  q 0
}

/// Description: 保存专利备案文件
/// Date: 2020-08-27
/// Creator: dhh
/// Table: DHCINM.SM.Patent
/// Input: id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMSMComm).SavePatentPic(3,"")
ClassMethod SavePatentPic(id As %String = "", name As %String = "") As %String
{
	q:(id="")||(name="") 0
	
	s obj=##class(DHCINM.SM.Patent).%OpenId(id)
	q:'$IsObject(obj) 0
	i obj.PatentPic="" s obj.PatentPic=name
	e  s obj.PatentPic=obj.PatentPic_"」"_name
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Description: 删除专利备案文件
/// Date: 2020-08-27
/// Creator: dhh
/// Table: DHCINM.SM.Patent
/// Input: id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMSMComm).DeletePatentPic(2,"",0)
ClassMethod DeletePatentPic(id As %String = "", name As %String = "", nurseid As %String = "") As %String
{
	q:(id="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	
	s obj=##class(DHCINM.SM.Patent).%OpenId(id)
	q:'$IsObject(obj) 0
	q:(nurseid'=0)&&(obj.Creator'=nurseid) 0
	s fileList=$lfs(obj.PatentPic,"」")
	s exist=0,index=0
	s ptr=0 f  s status=$listnext(fileList,ptr,file) q:(status'=1)||(exist'=0)  d
	.s:file=name exist=1
	.s index=index+1
	q:exist=0 0
	s fileLength=$l(obj.PatentPic,"」")
	s tmpFile=""
	f i=1:1:fileLength d
	.q:i=index
	.i tmpFile="" s tmpFile=$lg(fileList,i)
	.e  s tmpFile=tmpFile_"」"_$lg(fileList,i)
	s obj.PatentPic=tmpFile
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Description: 获取获奖创新备案
/// Date: 2020-07-27
/// Creator: dhh
/// Table: DHCINM.SM.Patent
/// Input: id 是否返回内容
/// Output: 获奖创新备案
/// Other: w ##class(web.INMSMComm).GetPatent(1)
ClassMethod GetPatent(id As %String = "") As %String
{
	q:(id="")||('$d(^DHCINM.SM.PatentD(id))) ""
	
	s PatentGlo=^DHCINM.SM.PatentD(id)
	s patentName=$lg(PatentGlo,2)
	s patentType=$lg(PatentGlo,3)
	s patentTypeDesc=##class(web.INMPersonComm).GetCommCode(patentType)
	s patentMechanism=$lg(PatentGlo,4)
	s patentNumber=$lg(PatentGlo,5)
	s patentDate=$lg(PatentGlo,6)
	s:patentDate'="" patentDate=$zd(patentDate,3)
	s patentPer=$lg(PatentGlo,7)
	s patentPerId=$lts(patentPer,",")
	s patentPerName=""
	s index=1,ptr=0 f  s stat=$listnext(patentPer,ptr,per) q:stat'=1  d
	.s perGlo=$g(^CF.DHCINM.HR.PersonsD(per))
	.s perName=$lg(perGlo,2)
	.i index=1 s patentPerName=perName
	.e  s patentPerName=patentPerName_","_perName
	.s index=index+1
	s patentStatus=$lg(PatentGlo,9)
	s patentStatusDesc=$case(patentStatus,"Y":"已提交","N":"已保存","B":"驳回","S":"已审核",:"")
	s creator=$lg(PatentGlo,11)
	s creatorName=""
	i creator=0 s creatorName="管理员"
	e  i creator'="" d
	.s perGlo=$g(^CF.DHCINM.DB.MgUserD(creator))
	.s creatorName=$lg(perGlo,2)
	s createDate=$lg(PatentGlo,12)
	s:createDate'="" createDate=$zd(createDate,3)
	s patentWard=$lg(PatentGlo,13)
	s patentWardDesc=""
	i patentWard'="" d
	.s wardGlo=$g(^CF.DHCINM.DB.MgWardD(patentWard))
	.s patentWardDesc=$lg(wardGlo,4)
	s PatentPic=$lg(PatentGlo,8)
	s auditor=$lg(PatentGlo,14)
	s auditorName=""
	i auditor=0 s auditorName="管理员"
	e  i auditor'="" d
	.s perGlo=$g(^CF.DHCINM.DB.MgUserD(auditor))
	.s auditorName=$lg(perGlo,2)
	s auditDate=$lg(PatentGlo,15)
	s:auditDate'="" auditDate=$zd(auditDate,3)
	s auditTime=$lg(PatentGlo,16)
	s:auditTime'="" auditTime=$zt(auditTime,1)
	s creatorWard="",auditorWard=""
	i creator'="" d
	.s creatorWard=##class(web.INMHRComm).GetCurrentWard($lg($g(^CF.DHCINM.DB.MgUserD(creator)),5),createDate)
	.s:creatorWard'="" creatorWard=$lg($g(^CF.DHCINM.DB.MgWardD(creatorWard)),4)
	i auditor'="" d
	.s auditorWard=##class(web.INMHRComm).GetCurrentWard($lg($g(^CF.DHCINM.DB.MgUserD(auditor)),5),auditDate)
	.s:auditorWard'="" auditorWard=$lg($g(^CF.DHCINM.DB.MgWardD(auditorWard)),4)
	s createTime=$lg(PatentGlo,17)
	s:createTime'="" createTime=$zt(createTime,1)
	s ret="PatentName|"_patentName_"^PatentType|"_patentType_"^PatentTypeDesc|"_patentTypeDesc_"^PatentMechanism|"_patentMechanism
	s ret=ret_"^PatentNumber|"_patentNumber_"^PatentDate|"_patentDate_"^PatentPer|"_patentPerId_"^PatentPerName|"_patentPerName_"^PatentPic|"_PatentPic
	s ret=ret_"^PatentWard|"_patentWard_"^PatentWardDesc|"_patentWardDesc_"^PatentStatus|"_patentStatus_"^PatentStatusDesc|"_patentStatusDesc_"^Creator|"_creator_"^CreatorName|"_creatorName_"^CreateDate|"_createDate_"^rw|"_id
	s ret=ret_"^Auditor|"_auditor_"^AuditorName|"_auditorName_"^AuditDate|"_auditDate_"^AuditTime|"_auditTime_"^AuditorWard|"_auditorWard_"^CreatorWard|"_creatorWard_"^CreateTime|"_createTime
	q ret
}

/// Description:获取专利备案
/// Date:2020-07-27
/// Creator:dhh
/// Table: DHCINM.SM.Patent
/// Input: 病区^开始日期^结束日期^关键字
/// Output:专利备案
/// Other:d ##class(%ResultSet).RunQuery("web.INMSMComm","FindPatentList","^2021-04-01^2021-04-30^",0)
Query FindPatentList(parr As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindPatentListExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i nurseid="" Set qHandle=$lb(0,repid,0) Quit $$$OK

	s ward=$p(parr,"^")
	s stDate=$p(parr,"^",2)
	s:stDate["-" stDate=$zdh(stDate,3)
	s endDate=$p(parr,"^",3)
	s:endDate["-" endDate=$zdh(endDate,3)
	s input=$p(parr,"^",4)
	s status=$p(parr,"^",5)
	s userPerId=""
	i nurseid'=0 d
	.s userGlo=$g(^CF.DHCINM.DB.MgUserD(nurseid))
	.s userPerId=$lg(userGlo,5)
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	s id="" f  s id=$o(^DHCINM.SM.PatentD(id),-1) q:id=""  d
	.s PatentGlo=^DHCINM.SM.PatentD(id)
	.s flag=0
	.s:isAll=1 flag=1
	.s nurWard=$lg(PatentGlo,13)
	.q:nurWard=""
	.s:$d(tmpWard(nurWard)) flag=1
	.s creator=$lg(PatentGlo,11)
	.s:creator=nurseid flag=1
	.q:flag'=1
	.q:(ward'="")&&(ward'=nurWard)	
	.s title=$lg(PatentGlo,2)
	.q:(input'="")&&(title'="")&&(($zcvt(title,"U")'[$zcvt(input,"U")))
	.s recDate=$lg(PatentGlo,12)
	.q:((stDate'="")&&(recDate<stDate))||((endDate'="")&&(recDate>endDate))
	.s stat=$lg(PatentGlo,9)
	.q:(status'="")&&(status'=stat)
	.s ret=..GetPatent(id)
	.d:ret'="" OutFindPatentList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutFindPatentList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindPatentListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPatentListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindPatentListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPatentListExecute ]
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

/// Description: 审核专利备案
/// Date: 2020-07-27
/// Creator: dhh
/// Table: DHCINM.SM.Patent
/// Input: 状态^说明^id 登录人Id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMSMComm).AuditPatent("",0)
ClassMethod AuditPatent(parr As %String = "", nurseid As %String = "") As %String
{
	q:(parr="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	s status=$p(parr,"^")
	s reason=$p(parr,"^",2)
	s rw=$p(parr,"^",3)
	s obj=##class(DHCINM.SM.Patent).%OpenId(rw)
	q:'$IsObject(obj) 0
	i obj.PatentStatus="Y" d
	.s obj.PatentStatus=status
	.s obj.Reason=reason
	.s obj.Auditor=nurseid
	.s obj.AuditDate=+$h
	.s obj.AuditTime=$p($h,",",2)
	s sc=obj.%Save()
	try{
		i (($$$ISOK(sc))&&((obj.PatentStatus="S")||(obj.PatentStatus="B"))) d
		.s PatentStatus=$case(obj.PatentStatus,"S":"审核","B":"驳回") ;状态描述
		.s PatentName=$lg($g(^DHCINM.SM.PatentD(rw)),2)
		.s PatentType=##class(web.INMPersonComm).GetCommCode(obj.PatentType)
		.s PatentNumber=$lg($g(^DHCINM.SM.PatentD(rw)),5)
		.s PatentMechanism=$lg($g(^DHCINM.SM.PatentD(rw)),4)		
		.s PatentWard=$lg($g(^DHCINM.SM.PatentD(rw)),13)
		.s PatentWardDesc=""
		.s:PatentWard'="" PatentWardDesc=$lg($g(^CF.DHCINM.DB.MgWardD(PatentWard)),4)
		.s Creator=$lg($g(^DHCINM.SM.PatentD(rw)),11)
		.s ret="【科研/专利备案】"_PatentStatus_" "_PatentName_" "_PatentType_" "_PatentNumber_" "_PatentMechanism_" "_PatentWardDesc
		.d ##class(web.INMPlatform).SaveTrackMessage(Creator,+$H,ret,"","DHCINM.SM.Patent",rw)
	}catch{
		}
	q $$$ISOK(sc)
}

/// Description: 删除专利备案
/// Date: 2020-07-27
/// Creator: dhh
/// Table: DHCINM.SM.Patent
/// Input: id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMSMComm).DeletePatent(1)
ClassMethod DeletePatent(id As %String = "") As %String
{
	q:id="" 0
	s sc=##class(DHCINM.SM.Patent).%DeleteId(id)
	q $$$ISOK(sc)
}

/// Description: 保存新技术备案
/// Date: 2020-07-28
/// Creator: dhh
/// Table: DHCINM.SM.NewTecApply
/// Input: parr
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMSMComm).SaveTecApply("项目名称^2020-07-01^首创单位^2020-07-01^9「学科特长^9「担任本项目的工作^1^该技术项目目前在国内外或其他省、市医院临床应用基本情况^临床应用意义、适应症和禁忌症^社会效益、经济效益预测^新技术、新项目的诊疗常规及操作规范^科室技术力量、人力配备和设施^新技术新项目预见的风险评估及应急处理预案^^N",0)
ClassMethod SaveTecApply(parr As %String = "", nurseid As %String = "") As %String
{
	q:(parr="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	
	s name=$p(parr,"^")
	s indate=$p(parr,"^",2)
	s:indate["-" indate=$zdh(indate,3)
	s unit=$p(parr,"^",3)
	s undate=$p(parr,"^",4)
	s:undate["-" undate=$zdh(undate,3)	
	s leads=$p(parr,"^",5)
	s leadlist=$lfs(leads,",")
	s parts=$p(parr,"^",6)
	s partlist=$lfs(parts,",")
	s ward=$p(parr,"^",7)
	s situation=$p(parr,"^",8)
	s mean=$p(parr,"^",9)
	s benefit=$p(parr,"^",10)
	s standard=$p(parr,"^",11)
	s resources=$p(parr,"^",12)
	s plan=$p(parr,"^",13)
	s rw=$p(parr,"^",14)
	s status=$p(parr,"^",15)
	i rw="" d
	.s obj=##class(DHCINM.SM.NewTecApply).%New()
	.s obj.Creator=nurseid
	e  s obj=##class(DHCINM.SM.NewTecApply).%OpenId(rw)
	q:'$IsObject(obj) 0
	s obj.TecName=name
	s obj.TecInDate=indate
	s obj.TecUnit=unit
	s obj.TecUnDate=undate
	d obj.TecLead.Clear()
	s leadptr=0 f  s stat=$listnext(leadlist,leadptr,item) q:stat'=1  d
	.s leadWard=$p(item,"「",2)
	.q:'$d(^CF.DHCINM.DB.MgWardD(leadWard))
	.d obj.TecLead.Insert(item)
	d obj.TecPart.Clear()
	s partptr=0 f  s stat=$listnext(partlist,partptr,item) q:stat'=1  d
	.s partWard=$p(item,"「",2)
	.q:'$d(^CF.DHCINM.DB.MgWardD(partWard))
	.d obj.TecPart.Insert(item)
	d obj.TecWardSetObjectId(ward)
	s obj.TecSituation=situation
	s obj.TecMean=mean
	s obj.TecBenefit=benefit
	s obj.TecStandard=standard
	s obj.TecResources=resources
	s obj.TecPlan=plan
	s obj.TecStatus=status
	s sc=obj.%Save()
	i $$$ISOK(sc) q 1
	e  q 0
}

/// Description: 获取新技术审批备案
/// Date: 2020-07-28
/// Creator: dhh
/// Table: DHCINM.SM.NewTecApply
/// Input: id 是否返回内容
/// Output: 论文备案记录
/// Other: w ##class(web.INMSMComm).GetTecApply(1)
ClassMethod GetTecApply(id As %String = "") As %String
{
	q:(id="")||('$d(^DHCINM.SM.NewTecApplyD(id))) ""
	
	s tecGlo=^DHCINM.SM.NewTecApplyD(id)
	s tecName=$lg(tecGlo,2)
	s tecInDate=$lg(tecGlo,3)
	s:tecInDate'="" tecInDate=$zd(tecInDate,3)
	s tecUnit=$lg(tecGlo,4)
	s tecUnDate=$lg(tecGlo,5)
	s:tecUnDate'="" tecUnDate=$zd(tecUnDate,3)	
	s tecLeads=$lg(tecGlo,6)
	s leadData=""
	s leadptr=0 f  s status=$listnext(tecLeads,leadptr,item) q:status'=1  d
	.s leadName=$p(item,"「")
	.s leadWard=$p(item,"「",2)
	.s leadSpc=$p(item,"「",3)
	.q:(leadName="")||('$d(^CF.DHCINM.HR.PersonsD(leadName)))
	.s leadNameDesc=$lg(^CF.DHCINM.HR.PersonsD(leadName),2)
	.s wardDesc=$lg(^CF.DHCINM.DB.MgWardD(leadWard),4)
	.s item=leadName_"「"_leadNameDesc_"「"_leadWard_"「"_wardDesc_"「"_leadSpc
	.s info=..GetPerInfo(leadName)
	.s item=item_"「"_info
	.i item'="" d 
	..i leadData="" s leadData=item
	..e  s leadData=leadData_","_item
	;s leadData=$lts(tecLeads,",")
	s tecParts=$lg(tecGlo,7)
	s partData="", tecPart=""
	s partptr=0 f  s status=$listnext(tecParts,partptr,item) q:status'=1  d
	.s partName=$p(item,"「")
	.s partWard=$p(item,"「",2)
	.s partSpc=$p(item,"「",3)
	.q:(partName="")||('$d(^CF.DHCINM.HR.PersonsD(partName)))
	.s partNameDesc=$lg(^CF.DHCINM.HR.PersonsD(partName),2)
	.s partDesc=$lg(^CF.DHCINM.DB.MgWardD(partWard),4)
	.s item=partName_"「"_partNameDesc_"「"_partWard_"「"_partDesc_"「"_partSpc
	.s info=..GetPerInfo(partName)
	.s item=item_"「"_info
	.i item'="" d 
	..i partData="" s partData=item
	..e  s partData=partData_","_item
	;s partData=$lts(tecParts,",")
	s tecWard=$lg(tecGlo,8)
	s tecWardDesc=""
	i tecWard'="" d
	.s wardGlo=$g(^CF.DHCINM.DB.MgWardD(tecWard))
	.s tecWardDesc=$lg(wardGlo,4)	
	s tecSituation=$lg(tecGlo,9)
	s tecMean=$lg(tecGlo,10)
	s tecBenefit=$lg(tecGlo,11)
	s tecStandard=$lg(tecGlo,12)
	s tecResources=$lg(tecGlo,13)
	s tecPlan=$lg(tecGlo,14)
	s tecStatus=$lg(tecGlo,15)
	s tecStatusDesc=$case(tecStatus,"Y":"已提交","N":"已保存","B":"驳回","S":"已审核",:"")
	s creator=$lg(tecGlo,17)
	s creatorName=""
	i creator=0 s creatorName="管理员"
	e  i creator'="" d
	.s perGlo=$g(^CF.DHCINM.DB.MgUserD(creator))
	.s creatorName=$lg(perGlo,2)
	s createDate=$lg(tecGlo,18)
	s:createDate'="" createDate=$zd(createDate,3)
	s auditor=$lg(tecGlo,19)
	s auditorName=""
	i auditor=0 s auditorName="管理员"
	e  i auditor'="" d
	.s perGlo=$g(^CF.DHCINM.DB.MgUserD(auditor))
	.s auditorName=$lg(perGlo,2)
	s auditDate=$lg(tecGlo,20)
	s:auditDate'="" auditDate=$zd(auditDate,3)
	s auditTime=$lg(tecGlo,21)
	s:auditTime'="" auditTime=$zt(auditTime,1)
	s creatorWard="",auditorWard=""
	i creator'="" d
	.s creatorWard=##class(web.INMHRComm).GetCurrentWard($lg($g(^CF.DHCINM.DB.MgUserD(creator)),5),createDate)
	.s:creatorWard'="" creatorWard=$lg($g(^CF.DHCINM.DB.MgWardD(creatorWard)),4)
	i auditor'="" d
	.s auditorWard=##class(web.INMHRComm).GetCurrentWard($lg($g(^CF.DHCINM.DB.MgUserD(auditor)),5),auditDate)
	.s:auditorWard'="" auditorWard=$lg($g(^CF.DHCINM.DB.MgWardD(auditorWard)),4)
	s createTime=$lg(tecGlo,22)
	s:createTime'="" createTime=$zt(createTime,1)
	s ret="TecName|"_tecName_"^TecInDate|"_tecInDate_"^TecUnit|"_tecUnit_"^TecUnDate|"_tecUnDate_"^LeadData|"_leadData_"^PartData|"_partData
	s ret=ret_"^TecWard|"_tecWard_"^TecWardDesc|"_tecWardDesc_"^TecSituation|"_tecSituation_"^TecMean|"_tecMean_"^TecBenefit|"_tecBenefit
	s ret=ret_"^TecStandard|"_tecStandard_"^TecResources|"_tecResources_"^TecPlan|"_tecPlan_"^TecStatus|"_tecStatus_"^TecStatusDesc|"_tecStatusDesc_"^Creator|"_creator
	s ret=ret_"^CreatorName|"_creatorName_"^CreateDate|"_createDate_"^rw|"_id_"^Auditor|"_auditor_"^AuditorName|"_auditorName_"^AuditDate|"_auditDate_"^AuditTime|"_auditTime_"^AuditorWard|"_auditorWard_"^CreatorWard|"_creatorWard_"^CreateTime|"_createTime
	q ret
}

/// Description:获取新技术申请列表
/// Date:2020-07-28
/// Creator:dhh
/// Table: DHCINM.SM.NewTecApply
/// Input: 病区^开始日期^结束日期^关键字
/// Output:新技术申请列表
/// Other:d ##class(%ResultSet).RunQuery("web.INMSMComm","FindTecList","^^2021-06-30^",0)
Query FindTecList(parr As %String = "", nurseid As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindTecListExecute(ByRef qHandle As %Binary, parr As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i nurseid="" Set qHandle=$lb(0,repid,0) Quit $$$OK

	s ward=$p(parr,"^")
	s stDate=$p(parr,"^",2)
	s:stDate["-" stDate=$zdh(stDate,3)
	s endDate=$p(parr,"^",3)
	s:endDate["-" endDate=$zdh(endDate,3)
	s input=$p(parr,"^",4)
	s status=$p(parr,"^",5)
	s userPerId=""
	i nurseid'=0 d
	.s userGlo=$g(^CF.DHCINM.DB.MgUserD(nurseid))
	.s userPerId=$lg(userGlo,5)
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	
	s id="" f  s id=$o(^DHCINM.SM.NewTecApplyD(id),-1) q:id=""  d
	.s tecGlo=^DHCINM.SM.NewTecApplyD(id)
	.s flag=0
	.s:isAll=1 flag=1
	.s tecWard=$lg(tecGlo,8)
	.s:$d(tmpWard(tecWard)) flag=1
	.s creator=$lg(tecGlo,17)
	.s:creator=nurseid flag=1
	.q:flag'=1
	.q:(ward'="")&&(ward'=tecWard)	
	.s title=$lg(tecGlo,2)
	.q:(input'="")&&(title'="")&&(($zcvt(title,"U")'[$zcvt(input,"U")))
	.s recDate=$lg(tecGlo,18)
	.q:((stDate'="")&&(recDate<stDate))||((endDate'="")&&(recDate>endDate))
	.s stat=$lg(tecGlo,15)
	.q:(status'="")&&(status'=stat)
	.s ret=..GetTecApply(id)
	.d:ret'="" OutTecList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutTecList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindTecListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindTecListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindTecListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindTecListExecute ]
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

/// Description: 审核新技术申请
/// Date: 2020-07-28
/// Creator: dhh
/// Table: DHCINM.SM.NewTecApply
/// Input: 状态^说明^id 登录人Id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMSMComm).AuditTec("",0)
ClassMethod AuditTec(parr As %String = "", nurseid As %String = "") As %String
{
	q:(parr="")||(nurseid="") 0
	q:(nurseid'=0)&&('$d(^CF.DHCINM.DB.MgUserD(nurseid))) 0
	s status=$p(parr,"^")
	s reason=$p(parr,"^",2)
	s rw=$p(parr,"^",3)
	s obj=##class(DHCINM.SM.NewTecApply).%OpenId(rw)
	q:'$IsObject(obj) 0
	i obj.TecStatus="Y" d
	.s obj.TecStatus=status
	.s obj.Reason=reason
	.s obj.Auditor=nurseid
	.s obj.AuditDate=+$h
	.s obj.AuditTime=$p($h,",",2)
	s sc=obj.%Save()
	try{
		i (($$$ISOK(sc))&&((obj.TecStatus="S")||(obj.TecStatus="B"))) d
		.s TecStatus=$case(obj.TecStatus,"S":"审核","B":"驳回") ;状态描述	
		.s TecName=$lg($g(^DHCINM.SM.NewTecApplyD(rw)),2)
		.s TecInDate=$lg($g(^DHCINM.SM.NewTecApplyD(rw)),3)
		.s:TecInDate'="" TecInDate=$zd(TecInDate,3)
		.s TecWard=$lg($g(^DHCINM.SM.NewTecApplyD(rw)),8)
		.s TecWardDesc=""
		.s:TecWard'="" TecWardDesc=$lg($g(^CF.DHCINM.DB.MgWardD(TecWard)),4)
		.s Creator=$lg($g(^DHCINM.SM.NewTecApplyD(rw)),17)
		.s ret="【科研/新技术申报审批】"_TecStatus_" "_TecName_" "_TecInDate_" "_TecWardDesc
		.d ##class(web.INMPlatform).SaveTrackMessage(Creator,+$H,ret,"","DHCINM.SM.NewTecApply",rw)
	}catch{
		}
	q $$$ISOK(sc)
}

/// Description: 删除新技术申请
/// Date: 2020-07-28
/// Creator: dhh
/// Table: DHCINM.SM.NewTecApply
/// Input: id
/// Output: 0：失败 1：成功
/// Other: w ##class(web.INMSMComm).DeleteTec(1)
ClassMethod DeleteTec(id As %String = "") As %String
{
	q:id="" 0
	s sc=##class(DHCINM.SM.NewTecApply).%DeleteId(id)
	q $$$ISOK(sc)
}

/// Creator:liwenzhen
/// Createdate:2020-07-16
/// Description:根据筛选条件查找人
/// Input:
/// Output:
/// Other:
/// Test:d ##class(%ResultSet).RunQuery("web.INMSurveyComm","FindPersonByType","^护士层级^19||1^","",0,0)
Query FindPersonByWard(parr As %String = "", input As %String = "", role As %String = "", nurseid As %String = "") As websys.Query(ROWSPEC = "aa")
{
}

ClassMethod FindPersonByWardExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "", role As %String = "", nurseid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ^TMP("parrpersonlist")=parr_"%"_input_"%"_role_"%"_nurseid
	s ward=$P(parr,"^",1)
	s searchType=$P(parr,"^",2)
	s searchRange=$P(parr,"^",3)
	s perType="",duty="",hire="",level=""
	s:searchType="人员类型" perType=searchRange
	s:searchType="职务" duty=searchRange
	s:searchType="聘任职称" hire=searchRange
	s:searchType="护士层级" level=searchRange
	s input=$zcvt(input,"U")
	s tmpWard=""
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	s perDr="" f  s perDr=$O(^CF.DHCINM.HR.PersonsD(perDr)) q:perDr=""  d
	.s perObj=##class(CF.DHCINM.HR.Persons).%OpenId(perDr)
	.q:(perType'="")&&(perType'[perObj.PerTypeDR)
	.s curWard=##class(web.INMHRComm).GetCurrentWard(perDr,+$h)
	.q:(isAll=0)&&((curWard="")||('$d(tmpWard(curWard))))
	.s:curWard="" curWard=perObj.PerDepDR
	.q:((ward'="")&&(ward'=curWard))
	.s leaveDate=perObj.PerStateDate //离职或退休日期
	.q:(leaveDate'="")&&(leaveDate<=+$h)
	.s perDuty=##class(web.INMHRComm).GetNurseDuty(perDr)
	.q:(duty'="")&&(duty'[$p(perDuty,"^",1))
	.s perHire=##class(web.INMHRComm).GetNurseHireDuty(perDr)
	.q:(hire'="")&&(hire'[$p(perHire,"^",1))
	.s perLevel=##class(web.INMHRComm).GetNurseLevel(perDr)
	.q:(level'="")&&(level'[$p(perLevel,"^",1))
	.s perEdu=##class(web.INMHRComm).GetNurseEdu(perDr)
	.s eduDesc=$p(perEdu,"^",2)
	.s leadPost=$p(perDuty,"^",2)
	.s leadHire=$p(perHire,"^",2)
	.s dutyDesc=$p(perDuty,"^",2)
	.s hireDesc=$p(perHire,"^",2)
	.s levelDesc=$p(perLevel,"^",2)
	.s wardDesc=""
	.i curWard'="" d
	..s wardObj=##class(CF.DHCINM.DB.MgWard).%OpenId(curWard)
	..s:$IsObject(wardObj) wardDesc=wardObj.WardDesc
	.s perId=perObj.PerID
	.i perId="" s perId=perObj.PerNo
	.s perName=perObj.PerName
	.s leadBir=perObj.PerBirthday
	.s:leadBir'="" leadBir=$zd(leadBir,3)
	.s leadSex=##class(web.INMPersonComm).GetCommCode(perObj.PerSexDR)
	.s leadEmail=perObj.Email
	.s leadPhone=perObj.PerPhone
	.s PerNation=##class(web.INMPersonComm).GetCommCode(perObj.PerNation)
	.s perShort=##class(web.INMVueComm).ToChineseSpell(perName)
	.q:(input'="")&&(perName'[input)&&(perId'[input)&&(perShort'[input)
	.s ret="PerDr|"_perDr_"^PerID|"_perId_"^PerName|"_perName_"^perward|"_curWard_"^WardDesc|"_wardDesc_"^LeadPost|"_leadPost_"^LeadHire|"_leadHire_"^eduDesc|"_eduDesc_"^leadPhone|"_leadPhone
	.s ret=ret_"^HireDesc|"_hireDesc_"^LevelDesc|"_levelDesc_"^DutyDesc|"_dutyDesc_"^LeadBir|"_leadBir_"^LeadSex|"_leadSex_"^LeadEmail|"_leadEmail_"^PerNation|"_PerNation_"^leadEmail|"_leadEmail
	.d OutPersons
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPersons
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// Creator:dhh
/// Description:获取人员病区,性别 民族 出生日期 学历 职务 职称 电话 邮箱
/// Date:2019-07-29
/// Table:CF.DHCINM.HR.Persons
/// Input:
/// Output：
/// Return:
/// Others: w ##class(web.INMSMComm).GetPerInfo("1")
ClassMethod GetPerInfo(id As %String) As %String
{
	q:(id="")||('$d(^CF.DHCINM.HR.PersonsD(id))) ""
	s ^TMP("sid")=id,ret=""
	s Glo=$g(^CF.DHCINM.HR.PersonsD(id))
	s curWard=##class(web.INMHRComm).GetCurrentWard(id,+$h)
	s:curWard="" curWard=$lg(Glo,10)
	s leaveDate=$lg(Glo,43) //离职或退休日期
	q:(leaveDate'="")&&(leaveDate<=+$h) ""
	s perDuty=##class(web.INMHRComm).GetNurseDuty(id)
	s perHire=##class(web.INMHRComm).GetNurseHireDuty(id)
	s perLevel=##class(web.INMHRComm).GetNurseLevel(id)
	s leadPost=$p(perDuty,"^",2)
	s leadHire=$p(perHire,"^",2)
	;s dutyDesc=$p(perDuty,"^",2)
	;s hireDesc=$p(perHire,"^",2)
	;s levelDesc=$p(perLevel,"^",2)
	s wardDesc=""
	i curWard'="" d
	.s wardGlo=$g(^CF.DHCINM.DB.MgWardD(curWard))
	.s wardDesc=$lg(wardGlo,4)
	s perId=$lg(Glo,3)
	i perId="" s perId=$lg(Glo,4)
	s perName=$lg(Glo,2)
	s leadBir=$lg(Glo,6)
	s:leadBir'="" leadBir=$zd(leadBir,3)
	s leadSex=##class(web.INMPersonComm).GetCommCode($lg(Glo,9))
	s leadNation=##class(web.INMPersonComm).GetCommCode($lg(Glo,21))
	s leadEmail=$lg(Glo,106)
	s leadPhone=$lg(Glo,30)
	s leadEdu=""
	s leadEdu=##class(web.INMHRComm).GetNurseEdu(id)
	s:leadEdu'="" leadEdu=$p(leadEdu,"^",2)
	s ret=leadSex_"「"_leadNation_"「"_leadBir_"「"_leadEdu_"「"_leadPost_"「"_leadHire_"「"_leadPhone_"「"_leadEmail
	q ret
}

ClassMethod SetCodeTmp(ByRef tmp As %String = "", ByRef tmpDesc As %String = "", type As %String = "", code As %String = "")
{
	s date=+$H
	s par="" f  s par=$O(^CT.DHCINM.DB.MgSetCodeI("Code"," "_$zcvt(code,"U"),par)) q:par=""  d
	.s raw="" f  s raw=$O(^CT.DHCINM.DB.MgSetCodeSubD(par,raw)) q:raw=""  d
	..s objLB=$g(^CT.DHCINM.DB.MgSetCodeSubD(par,raw))
	..q:objLB=""
	..s SubStDate=$LG(objLB,5)
	..s SubEndDate=$LG(objLB,6)
	..q:(SubStDate="")||(SubStDate>date)||((SubEndDate'="")&&(SubEndDate<date))
	..s SubDesc=$LG(objLB,3)
	..s tmp(type,par_"||"_raw)=0
	..s tmpDesc(type,par_"||"_raw)=SubDesc
}

/// Description: 获取论文备案统计
/// Date: 2022-02-08
/// Creator: wangpf
/// Table: DHCINM.SM.Thesis
/// Input: 人员id 年份 nurseid
/// Output: 论文备案统计
/// Other: w ##class(web.INMSMComm).GetThesisSta("",2022,0,0,"")
ClassMethod GetThesisSta(perId As %String = "", year As %String = "", nurseid As %String = "", appFlag As %String = "0", appRet As %ArrayOfDataTypes = "") As %ArrayOfDataTypes
{
	s:appRet="" appRet=##class(%ArrayOfDataTypes).%New()
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	s perName=""
	s:perId'="" perName=$lg(^CF.DHCINM.HR.PersonsD(perId),2)
	
	k tmp,tmpDesc
	s tmp("Spe","Y")=0,tmp("Spe","N")=0
	s tmpDesc("Spe","Y")="是",tmpDesc("Spe","N")="否"
	d ..SetCodeTmp(.tmp,.tmpDesc,"Level","期刊类型")
	d ..SetCodeTmp(.tmp,.tmpDesc,"Type","论文类型")
	
	s id="" f  s id=$o(^DHCINM.SM.ThesisD(id)) q:id=""  d
	.s theGlo=^DHCINM.SM.ThesisD(id)
	.s theStatus=$lg(theGlo,13)
	.q:theStatus'="S"
	.s theDate=$lg(theGlo,9)
	.q:(year'="")&&(+$zd(theDate,3)'=year)
	.s flag=0
	.s:(isAll=1)&&(perId="") flag=1
	.s theAuthor=$lg(theGlo,3)
	.s ptr=0 f  s stat=$listnext(theAuthor,ptr,item) q:(stat'=1)||(flag=1)  d
	..s authType=$p(item,"「")
	..q:authType'="F"
	..s authName=$p(item,"「",2)
	..s:(perId'="")&&(perName=authName) flag=1
	..q:perId'=""
	..s wardId=$p(item,"「",3)
	..s:(isAll=1)||$d(tmpWard(wardId)) flag=1
	.q:flag'=1
	.s theSpec=$lg(theGlo,5)
	.s:theSpec="" theSpec=" "
	.s:'$d(tmpDesc("Spe",theSpec)) theSpecDesc=$case(theSpec,"Y":"是","N":"否",:"其他"),tmpDesc("Spe",theSpec)=theSpecDesc
	.s theLevel=$lg(theGlo,6)
	.s:theLevel="" theLevel=" "
	.s:'$d(tmpDesc("Level",theLevel)) theLevelDesc=##class(web.INMPersonComm).GetCommCode(theLevel),theLevelDesc=$case(theLevelDesc,"":"其他",:theLevelDesc),tmpDesc("Level",theLevel)=theLevelDesc
	.s theType=$lg(theGlo,7)
	.s:theType="" theType=" "
	.s:'$d(tmpDesc("Type",theType)) theTypeDesc=##class(web.INMPersonComm).GetCommCode(theType),theTypeDesc=$case(theTypeDesc,"":"其他",:theTypeDesc),tmpDesc("Type",theType)=theTypeDesc
	.s tmp("Spe",theSpec)=$g(tmp("Spe",theSpec))+1
	.s tmp("Level",theLevel)=$g(tmp("Level",theLevel))+1
	.s tmp("Type",theType)=$g(tmp("Type",theType))+1
	
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

/// Description: 获取获奖论文备案统计
/// Date: 2022-02-08
/// Creator: wangpf
/// Table: DHCINM.SM.AwardThesis
/// Input: 人员id 年份 nurseid
/// Output: 获奖论文备案统计
/// Other: w ##class(web.INMSMComm).GetAwardSta("",2022,0,0,"")
ClassMethod GetAwardSta(perId As %String = "", year As %String = "", nurseid As %String = "", appFlag As %String = "0", appRet As %ArrayOfDataTypes = "") As %ArrayOfDataTypes
{
	s:appRet="" appRet=##class(%ArrayOfDataTypes).%New()
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	s perName=""
	s:perId'="" perName=$lg(^CF.DHCINM.HR.PersonsD(perId),2)
	
	k tmp,tmpDesc
	s tmp("Spe","Y")=0,tmp("Spe","N")=0
	s tmpDesc("Spe","Y")="是",tmpDesc("Spe","N")="否"
	d ..SetCodeTmp(.tmp,.tmpDesc,"Level","获奖等级")
	d ..SetCodeTmp(.tmp,.tmpDesc,"Type","获奖成绩")
	
	s id="" f  s id=$o(^DHCINM.SM.AwardThesisD(id)) q:id=""  d
	.s theGlo=^DHCINM.SM.AwardThesisD(id)
	.s theStatus=$lg(theGlo,11)
	.q:theStatus'="S"
	.s theDate=$lg(theGlo,7)
	.q:(year'="")&&(+$zd(theDate,3)'=year)
	.s awardAuthor=$lg(theGlo,3)
	.s flag=0
	.s:(isAll=1)&&(perId="") flag=1
	.s ptr=0 f  s stat=$listnext(awardAuthor,ptr,item) q:(stat'=1)||(flag=1)  d
	..q:item=""
	..s:item=perId flag=1
	..q:perId'=""
	..s perWard=##class(web.INMHRComm).GetCurrentWard(item,theDate)
	..s:$d(tmpWard(perWard)) flag=1
	.q:flag'=1
	.s theSpec=$lg(theGlo,8)
	.s:theSpec="" theSpec=" "
	.s:'$d(tmpDesc("Spe",theSpec)) theSpecDesc=$case(theSpec,"Y":"是","N":"否",:"其他"),tmpDesc("Spe",theSpec)=theSpecDesc
	.s theLevel=$lg(theGlo,5)
	.s:theLevel="" theLevel=" "
	.s:'$d(tmpDesc("Level",theLevel)) theLevelDesc=##class(web.INMPersonComm).GetCommCode(theLevel),theLevelDesc=$case(theLevelDesc,"":"其他",:theLevelDesc),tmpDesc("Level",theLevel)=theLevelDesc
	.s theType=$lg(theGlo,6)
	.s:theType="" theType=" "
	.s:'$d(tmpDesc("Type",theType)) theTypeDesc=##class(web.INMPersonComm).GetCommCode(theType),theTypeDesc=$case(theTypeDesc,"":"其他",:theTypeDesc),tmpDesc("Type",theType)=theTypeDesc
	.s tmp("Spe",theSpec)=$g(tmp("Spe",theSpec))+1
	.s tmp("Level",theLevel)=$g(tmp("Level",theLevel))+1
	.s tmp("Type",theType)=$g(tmp("Type",theType))+1
	
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

/// Description: 获取上交论文备案统计
/// Date: 2022-02-08
/// Creator: wangpf
/// Table: DHCINM.SM.Thesis
/// Input: 人员id 年份 nurseid
/// Output: 上交论文备案统计
/// Other: w ##class(web.INMSMComm).GetEndYearSta("",2022,0,0,"")
ClassMethod GetEndYearSta(perId As %String = "", year As %String = "", nurseid As %String = "", appFlag As %String = "0", appRet As %ArrayOfDataTypes = "") As %ArrayOfDataTypes
{
	s:appRet="" appRet=##class(%ArrayOfDataTypes).%New()
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	s perName=""
	s:perId'="" perName=$lg(^CF.DHCINM.HR.PersonsD(perId),2)
	
	k tmp,tmpDesc
	d ..SetCodeTmp(.tmp,.tmpDesc,"Type","论文类型")
	
	s id="" f  s id=$o(^DHCINM.SM.EndYearThseisD(id)) q:id=""  d
	.s theGlo=^DHCINM.SM.EndYearThseisD(id)
	.s theStatus=$lg(theGlo,9)
	.q:theStatus'="S"
	.s theDate=$lg(theGlo,12)
	.q:(year'="")&&(+$zd(theDate,3)'=year)
	.s flag=0
	.i perId'="" d
	..s author=$lg(theGlo,2)
	..s:author=perId flag=1
	.e  d
	..s authorWard=$lg(theGlo,5)
	..s:(isAll=1)||($d(tmpWard(authorWard))) flag=1
	.q:flag'=1
	.s theType=$lg(theGlo,7)
	.s:theType="" theType=" "
	.s:'$d(tmpDesc("Type",theType)) theTypeDesc=##class(web.INMPersonComm).GetCommCode(theType),theTypeDesc=$case(theTypeDesc,"":"其他",:theTypeDesc),tmpDesc("Type",theType)=theTypeDesc
	.s tmp("Type",theType)=$g(tmp("Type",theType))+1
	
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

/// Description: 获取科研立项备案统计
/// Date: 2022-02-08
/// Creator: wangpf
/// Table: DHCINM.SM.RegScience
/// Input: 人员id 年份 nurseid
/// Output: 科研立项备案统计
/// Other: w ##class(web.INMSMComm).GetRegScience("",2022,0,0,"")
ClassMethod GetRegScience(perId As %String = "", year As %String = "", nurseid As %String = "", appFlag As %String = "0", appRet As %ArrayOfDataTypes = "") As %ArrayOfDataTypes
{
	s:appRet="" appRet=##class(%ArrayOfDataTypes).%New()
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	s perName=""
	s:perId'="" perName=$lg(^CF.DHCINM.HR.PersonsD(perId),2)
	
	k tmp,tmpDesc
	d ..SetCodeTmp(.tmp,.tmpDesc,"Type","科研类型")
	
	s id="" f  s id=$o(^DHCINM.SM.RegScienceD(id)) q:id=""  d
	.s theGlo=^DHCINM.SM.RegScienceD(id)
	.s theStatus=$lg(theGlo,9)
	.q:theStatus'="S"
	.s theDate=$lg(theGlo,3)
	.q:(year'="")&&(+$zd(theDate,3)'=year)
	.s flag=0
	.s author=$lg(theGlo,6)
	.i perId'="" d
	..s:author=perId flag=1
	.e  d
	..s authorWard=##class(web.INMHRComm).GetCurrentWard(author,theDate)
	..s:(isAll=1)||($d(tmpWard(authorWard))) flag=1
	.q:flag'=1
	.s theType=$lg(theGlo,4)
	.s:theType="" theType=" "
	.s:'$d(tmpDesc("Type",theType)) theTypeDesc=##class(web.INMPersonComm).GetCommCode(theType),theTypeDesc=$case(theTypeDesc,"":"其他",:theTypeDesc),tmpDesc("Type",theType)=theTypeDesc
	.s tmp("Type",theType)=$g(tmp("Type",theType))+1
	
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

/// Description: 获取科室创新备案统计
/// Date: 2022-02-08
/// Creator: wangpf
/// Table: DHCINM.SM.LocInnovate
/// Input: 人员id 年份 nurseid
/// Output: 科室创新备案统计
/// Other: w ##class(web.INMSMComm).GetLocInnovateSta("",2022,0,0,"")
ClassMethod GetLocInnovateSta(perId As %String = "", year As %String = "", nurseid As %String = "", appFlag As %String = "0", appRet As %ArrayOfDataTypes = "") As %ArrayOfDataTypes
{
	s:appRet="" appRet=##class(%ArrayOfDataTypes).%New()
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	s perName=""
	s:perId'="" perName=$lg(^CF.DHCINM.HR.PersonsD(perId),2)
	
	k tmp,tmpDesc
	s tmp("Spe","Y")=0,tmp("Spe","N")=0
	s tmpDesc("Spe","Y")="是",tmpDesc("Spe","N")="否"
	d ..SetCodeTmp(.tmp,.tmpDesc,"Type","创新类型")
	
	s id="" f  s id=$o(^DHCINM.SM.LocInnovateD(id)) q:id=""  d
	.s theGlo=^DHCINM.SM.LocInnovateD(id)
	.s theStatus=$lg(theGlo,14)
	.q:theStatus'="S"
	.s theDate=$lg(theGlo,17)
	.q:(year'="")&&(+$zd(theDate,3)'=year)
	.s flag=0
	.i perId'="" d
	..s author=$lg(theGlo,6)
	..s:author=perId flag=1
	.e  d
	..s authorWard=$lg(theGlo,4)
	..s:(isAll=1)||($d(tmpWard(authorWard))) flag=1
	.q:flag'=1
	.s theSpec=$lg(theGlo,5)
	.s:theSpec="" theSpec=" "
	.s:'$d(tmpDesc("Spe",theSpec)) theSpecDesc=$case(theSpec,"Y":"是","N":"否",:"其他"),tmpDesc("Spe",theSpec)=theSpecDesc
	.s theType=$lg(theGlo,2)
	.s:theType="" theType=" "
	.s:'$d(tmpDesc("Type",theType)) theTypeDesc=##class(web.INMPersonComm).GetCommCode(theType),theTypeDesc=$case(theTypeDesc,"":"其他",:theTypeDesc),tmpDesc("Type",theType)=theTypeDesc
	.s tmp("Spe",theSpec)=$g(tmp("Spe",theSpec))+1
	.s tmp("Type",theType)=$g(tmp("Type",theType))+1
	
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

/// Description: 获取获奖创新备案统计
/// Date: 2022-02-08
/// Creator: wangpf
/// Table: DHCINM.SM.AwaInnovate
/// Input: 人员id 年份 nurseid
/// Output: 获奖创新备案统计
/// Other: w ##class(web.INMSMComm).GetAwaInnovate("",2022,0,0,"")
ClassMethod GetAwaInnovate(perId As %String = "", year As %String = "", nurseid As %String = "", appFlag As %String = "0", appRet As %ArrayOfDataTypes = "") As %ArrayOfDataTypes
{
	s:appRet="" appRet=##class(%ArrayOfDataTypes).%New()
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	s perName=""
	s:perId'="" perName=$lg(^CF.DHCINM.HR.PersonsD(perId),2)
	
	k tmp,tmpDesc
	s tmp("Spe","Y")=0,tmp("Spe","N")=0
	s tmpDesc("Spe","Y")="是",tmpDesc("Spe","N")="否"
	d ..SetCodeTmp(.tmp,.tmpDesc,"Level","获奖等级")
	d ..SetCodeTmp(.tmp,.tmpDesc,"Score","获奖成绩")
	d ..SetCodeTmp(.tmp,.tmpDesc,"Type","创新类型")
	
	s id="" f  s id=$o(^DHCINM.SM.AwaInnovateD(id)) q:id=""  d
	.s theGlo=^DHCINM.SM.AwaInnovateD(id)
	.s theStatus=$lg(theGlo,11)
	.q:theStatus'="S"
	.s theDate=$lg(theGlo,14)
	.q:(year'="")&&(+$zd(theDate,3)'=year)
	.s flag=0
	.i perId'="" d
	..s author=$lg(theGlo,6)
	..s:author=perId flag=1
	.e  d
	..s authorWard=$lg(theGlo,4)
	..s:(isAll=1)||($d(tmpWard(authorWard))) flag=1
	.q:flag'=1
	.s theSpec=$lg(theGlo,5)
	.s:theSpec="" theSpec=" "
	.s:'$d(tmpDesc("Spe",theSpec)) theSpecDesc=$case(theSpec,"Y":"是","N":"否",:"其他"),tmpDesc("Spe",theSpec)=theSpecDesc
	.s theLevel=$lg(theGlo,9)
	.s:theLevel="" theLevel=" "
	.s:'$d(tmpDesc("Level",theLevel)) theLevelDesc=##class(web.INMPersonComm).GetCommCode(theLevel),theLevelDesc=$case(theLevelDesc,"":"其他",:theLevelDesc),tmpDesc("Level",theLevel)=theLevelDesc
	.s theType=$lg(theGlo,2)
	.s:theType="" theType=" "
	.s:'$d(tmpDesc("Type",theType)) theTypeDesc=##class(web.INMPersonComm).GetCommCode(theType),theTypeDesc=$case(theTypeDesc,"":"其他",:theTypeDesc),tmpDesc("Type",theType)=theTypeDesc
	.s theScore=$lg(theGlo,8)
	.s:theScore="" theScore=" "
	.s:'$d(tmpDesc("Score",theScore)) theScoreDesc=##class(web.INMPersonComm).GetCommCode(theScore),theScoreDesc=$case(theScoreDesc,"":"其他",:theScoreDesc),tmpDesc("Score",theScore)=theScoreDesc
	.s tmp("Spe",theSpec)=$g(tmp("Spe",theSpec))+1
	.s tmp("Level",theLevel)=$g(tmp("Level",theLevel))+1
	.s tmp("Type",theType)=$g(tmp("Type",theType))+1
	.s tmp("Score",theScore)=$g(tmp("Score",theScore))+1
	
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

/// Description: 获取专利备案统计
/// Date: 2022-02-08
/// Creator: wangpf
/// Table: DHCINM.SM.Patent
/// Input: 人员id 年份 nurseid
/// Output: 专利备案统计
/// Other: w ##class(web.INMSMComm).GetPatentSta("",2022,0,0,"")
ClassMethod GetPatentSta(perId As %String = "", year As %String = "", nurseid As %String = "", appFlag As %String = "0", appRet As %ArrayOfDataTypes = "") As %ArrayOfDataTypes
{
	s:appRet="" appRet=##class(%ArrayOfDataTypes).%New()
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	s perName=""
	s:perId'="" perName=$lg(^CF.DHCINM.HR.PersonsD(perId),2)
	
	k tmp,tmpDesc
	d ..SetCodeTmp(.tmp,.tmpDesc,"Type","专利类型")
	
	s id="" f  s id=$o(^DHCINM.SM.PatentD(id)) q:id=""  d
	.s theGlo=^DHCINM.SM.PatentD(id)
	.s theStatus=$lg(theGlo,9)
	.q:theStatus'="S"
	.s theDate=$lg(theGlo,6)
	.q:(year'="")&&(+$zd(theDate,3)'=year)
	.s flag=0
	.i perId'="" d
	..s author=$lg(theGlo,7)
	..s ptr=0 f  s stat=$listnext(author,ptr,item) q:(stat'=1)||(flag=1)  d
	...s:item=perId flag=1
	.e  d
	..s authorWard=$lg(theGlo,13)
	..s:(isAll=1)||($d(tmpWard(authorWard))) flag=1
	.q:flag'=1
	.s theType=$lg(theGlo,3)
	.s:theType="" theType=" "
	.s:'$d(tmpDesc("Type",theType)) theTypeDesc=##class(web.INMPersonComm).GetCommCode(theType),theTypeDesc=$case(theTypeDesc,"":"其他",:theTypeDesc),tmpDesc("Type",theType)=theTypeDesc
	.s tmp("Type",theType)=$g(tmp("Type",theType))+1
	
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

}
