/// Create Time: 20130901
/// 对教育能力需求评估表进行操作
Class web.DHCEduAbtNdAss Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 插入一条教育能力需求评估记录
/// Input:PatientId^评估日期^评估时间^评估对象^语言交流^阅读能力^书写能力^理解能力^实施能力^可接受方式^乐意接受内容^护士签名
/// OutPut:无
/// w ##class(web.DHCEduAbtNdAss).AddEduAbtNdAss("76^2012-12-12^12:12:00^家属^普通话^是^是^是^是^讲课,口授^病发原因,治疗方法^hs001")
ClassMethod AddEduAbtNdAss(EANAInfo As %String)
{
	q:EANAInfo=""
	s object = ##class(DHCMGNUR.DHCNurAbtNdAss).%New()
	s EpisodeID = $P(EANAInfo,"^",1) //PatientId
	s PAAdmObj = ##class(User.PAAdm).%OpenId(EpisodeID)
	s object.EANAPAPMDr = PAAdmObj
	s object.EANADate = $zdh($P(EANAInfo,"^",2),3) //评估日期
	s object.EANATime = $zth($P(EANAInfo,"^",3),1) //评估时间
	s object.EANAObject = $P(EANAInfo,"^",4) //评估对象
	s object.EANALangTalk = $P(EANAInfo,"^",5) //语言交流
	s object.EANAReadAbt = $P(EANAInfo,"^",6) //阅读能力
	s object.EANAWriteAbt = $P(EANAInfo,"^",7) //书写能力
	s object.EANAUnderStandAbt = $P(EANAInfo,"^",8) //理解能力
	s object.EANAImplementAbt = $P(EANAInfo,"^",9) //实施能力
	s object.EANAAcceptWay = $P(EANAInfo,"^",10) //可接受方式
	s object.EANALkAcptContent = $P(EANAInfo,"^",11) //乐意接受内容
	s SSUSRInitials = $P(EANAInfo,"^",12) //护士签名
	//s ret = ##class(web.DHCNurHlthEduComm).GetPerson(SSUSRInitials)
	//s SSUserRowId=$P(ret,"|",1)
	set SSUserRowId=$O(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(SSUSRInitials),""))
	//s ^TempXBL("ENA")=SSUserRowId
	s SSUserObj = ##class(User.SSUser).%OpenId(SSUserRowId)
	b
	s object.EANANurSign = SSUserObj
	TStart
	S sc = object.%Save()
 	I $$$ISERR(sc)  ///If ($$$ISOK(sc))
	{
		TRollBack
		Do $System.Status.DisplayError(sc)
   		q "添加失败"
	}
	else
	{
		TCommit
		q "添加成功"
	}
	//q
}

/// 修改一条记录
/// Input:EANARowId^评估日期^评估时间^评估对象^语言交流^阅读能力^书写能力^理解能力^实施能力^可接受方式^乐意接受内容^护士签名
/// OutPut:无
/// w ##class(web.DHCEduAbtNdAss).UpdateEduAbtNdAss("6^62222^25555^患者^方言^是^是^是^是^讲课,口授^病发原因,治疗方法^121")
ClassMethod UpdateEduAbtNdAss(EANAInfo As %String)
{
	q:EANAInfo=""
	s EANARowID = $P(EANAInfo,"^",1)
	q:$d(^EDUANA(EANARowID))=0
	s object = ##class(DHCMGNUR.DHCNurAbtNdAss).%OpenId(EANARowID) 
	s object.EANADate = $zdh($P(EANAInfo,"^",2),3) //评估日期
	s object.EANATime = $zth($P(EANAInfo,"^",3),1) //评估时间
	s object.EANAObject = $P(EANAInfo,"^",4) //评估对象
	s object.EANALangTalk = $P(EANAInfo,"^",5) //语言交流
	s object.EANAReadAbt = $P(EANAInfo,"^",6) //阅读能力
	s object.EANAWriteAbt = $P(EANAInfo,"^",7) //书写能力
	s object.EANAUnderStandAbt = $P(EANAInfo,"^",8) //理解能力
	s object.EANAImplementAbt = $P(EANAInfo,"^",9) //实施能力
	s object.EANAAcceptWay = $P(EANAInfo,"^",10) //可接受方式
	s object.EANALkAcptContent = $P(EANAInfo,"^",11) //乐意接受内容
	s SSUSRInitials = $P(EANAInfo,"^",12) //护士签名
	set SSUserRowId=$O(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(SSUSRInitials),""))
	s SSUserObj = ##class(User.SSUser).%OpenId(SSUserRowId)
	s object.EANANurSign = SSUserObj
	TStart
	S sc = object.%Save()
 	I $$$ISERR(sc)  ///If ($$$ISOK(sc))
	{
		TRollBack
		Do $System.Status.DisplayError(sc)
   		q "修改失败"
	}
	else
	{
		TCommit
		q "修改成功"
	}
	//q
}

/// 作废一条记录
/// Input:EANARowId
/// OutPut:无
/// w ##class(web.DHCEduAbtNdAss).DeleteEduAbtNdAss(3)
ClassMethod DeleteEduAbtNdAss(parr As %String)
{
	q:parr=""
	set EANARowID = $P(parr,"^",1)
	set EANAValid = $P(parr,"^",2)
	s object = ##class(DHCMGNUR.DHCNurAbtNdAss).%OpenId(EANARowID)
	s object.EANAValid = EANAValid
	TStart
	S sc = object.%Save()
 	I $$$ISERR(sc)  ///If ($$$ISOK(sc))
	{
		TRollBack
		Do $System.Status.DisplayError(sc)
   		q "Fail"
	}
	else
	{
		TCommit
		q "Success"
	}
}

Query FindEduAbtNdAss(EpisodeID As %String) As %Query(ROWSPEC = "EANADateData:%String,EANATimeData:%String,EANAObjectData:%String,EANALangTalkData:%String,EANAReadAbtData:%String,EANAWriteAbtData:%String,EANAUdstdAbtData:%String,EANAImplmtAbtData:%String,EANAAcptWayData:%String,EANALkAcptCttData:%String,EANANurSignData:%String,EANARowIDData:%String")
{
}

ClassMethod FindEduAbtNdAssExecute(ByRef qHandle As %Binary, EpisodeID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	i (EpisodeID="")
	{
		Set qHandle=$lb(0,repid,0)
		q $$$OK
	}
	s EANARowID = "" 
	f  s EANARowID=$O(^EDUANA(EpisodeID,"EANAPAPM",EANARowID))  q:EANARowID=""  do
	.q:$d(^EDUANA(EANARowID))=0
	.s EANADate = $P(^EDUANA(EANARowID),"^",2) //评估日期
	.s EANATime = $P(^EDUANA(EANARowID),"^",3) //评估时间
	.s EANAObject = $P(^EDUANA(EANARowID),"^",4) //评估对象
	.s EANALangTalk = $P(^EDUANA(EANARowID),"^",5) //语言交流
	.s EANAReadAbt = $P(^EDUANA(EANARowID),"^",6) //阅读能力
	.s EANAWriteAbt = $P(^EDUANA(EANARowID),"^",7) //书写能力
	.s EANAUnderStandAbt = $P(^EDUANA(EANARowID),"^",8) //理解能力
	.s EANAImplementAbt = $P(^EDUANA(EANARowID),"^",9) //实施能力
	.s EANAAcceptWay = $P(^EDUANA(EANARowID),"^",10) //可接受方式
	.s EANALkAcptContent = $P(^EDUANA(EANARowID),"^",11) //乐意接受内容
	.s EANANurRowId = $P(^EDUANA(EANARowID),"^",12) //护士签名
	.if EANANurRowId'="" s EANANurSign = $P(^SSU("SSUSR",EANANurRowId),"^",2)
	.else  s EANANurSign=""
	.s EANAValid = $P(^EDUANA(EANARowID),"^",13)
	.if EANAValid'="N" Do OutputRow
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow      
	set Data=$lb($Zd(EANADate,3),$zt(EANATime,1),EANAObject,EANALangTalk,EANAReadAbt,EANAWriteAbt,EANAUnderStandAbt,EANAImplementAbt,EANAAcceptWay,EANALkAcptContent,EANANurSign,EANARowID)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindEduAbtNdAssFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindEduAbtNdAssExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindEduAbtNdAssClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindEduAbtNdAssExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 通过RowId获取记录信息
ClassMethod FindEANAByRowId(parr As %String) As %String
{
	q:parr=""
	s EANARowID=parr
	q:$d(^EDUANA(EANARowID))=0
	s EANADate = $P(^EDUANA(EANARowID),"^",2) //评估日期
	s EANATime = $P(^EDUANA(EANARowID),"^",3) //评估时间
	s EANAObject = $P(^EDUANA(EANARowID),"^",4) //评估对象
	s EANALangTalk = $P(^EDUANA(EANARowID),"^",5) //语言交流
	s EANAReadAbt = $P(^EDUANA(EANARowID),"^",6) //阅读能力
	s EANAWriteAbt = $P(^EDUANA(EANARowID),"^",7) //书写能力
	s EANAUnderStandAbt = $P(^EDUANA(EANARowID),"^",8) //理解能力
	s EANAImplementAbt = $P(^EDUANA(EANARowID),"^",9) //实施能力
	s EANAAcceptWay = $P(^EDUANA(EANARowID),"^",10) //可接受方式
	s EANALkAcptContent = $P(^EDUANA(EANARowID),"^",11) //乐意接受内容
	s EANANurRowId = $P(^EDUANA(EANARowID),"^",12) //护士签名
	if EANANurRowId'="" s SSUSRInitials = $P(^SSU("SSUSR",EANANurRowId),"^",1)
	else  s SSUSRInitials=""
	s ret = $zd(EANADate,3)_"^"_$zt(EANATime,1)_"^"_EANAObject_"^"_EANALangTalk_"^"_EANAReadAbt_"^"_EANAWriteAbt_"^"_EANAUnderStandAbt_"^"_EANAImplementAbt_"^"_EANAAcceptWay_"^"_EANALkAcptContent_"^"_SSUSRInitials
	q ret
}

}
