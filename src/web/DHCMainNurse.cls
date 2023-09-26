Class web.DHCMainNurse Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/*科室  */
ClassMethod GetWardStr(CTType As %String = "W") As %String
{
	;w ##class(web.DHCMainNurse).GetWardStr("W")
	s rset=##class(%ResultSet).%New("web.DHCMainNurse:WardList")
	s ret=""
	i CTType=""  s CTType="W"
	do rset.Execute(CTType)
	while (rset.Next()) {
		i ret=""  s ret=rset.GetData(1)_$C(1)_rset.GetData(2)_"-"_rset.GetData(3)
		e  s ret=ret_"^"_rset.GetData(1)_$C(1)_rset.GetData(2)_"-"_rset.GetData(3)
	}	
	d rset.Close()
	q ret
}

Query WardList(CTType As %String) As %Query(ROWSPEC = "CTCode:%String,CTDesc:%String,CTAlias:%String")
{
}

ClassMethod WardListExecute(ByRef qHandle As %Binary, CTType As %String = "W") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1	
	i CTType="" s CTType="W"
	s ctlocId=""
	f  s ctlocId=$o(^CTLOC(0,"LocType",CTType,ctlocId)) q:ctlocId=""  d
	.s CTDesc=$P($p($g(^CTLOC(ctlocId)),"^",2),"-",2)
	.s CTAlias=$P($p($g(^CTLOC(ctlocId)),"^",2),"-",1)
	.s CTRowId=ctlocId
	.Do OutputRow1
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(CTRowId,CTDesc,CTAlias)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod WardListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = WardListExecute ]
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

ClassMethod WardListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = WardListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/* 护士 */
ClassMethod GetNurStr(DepRowId As %String) As %String
{
	;w ##class(web.DHCMainNurse).GetNurStr(210)
	s rset=##class(%ResultSet).%New("web.DHCMainNurse:IPNurList")
	s ret=""
	do rset.Execute(DepRowId)
	while (rset.Next()) {
		i ret=""  s ret=rset.GetData(1)_"$c(2)"_rset.GetData(2)
		e  s ret=ret_"$c(1)"_rset.GetData(1)_"$c(2)"_rset.GetData(2)
	}	
	d rset.Close()
	q ret
}

Query IPNurList(DepRowId As %String = "", ComparePart As %String = "") As %Query(ROWSPEC = "NurId:%String,NurDesc:%String")
{
}

/// ##class(%ResultSet).RunQuery("web.DHCMainNurse","IPNurList",286,"")
ClassMethod IPNurListExecute(ByRef qHandle As %Binary, DepRowId As %String = "", ComparePart As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1 
	i DepRowId="" s DepRowId=$g(%session.Data("LOGON.CTLOCID"))
	i DepRowId="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s wardFlag=$p(^CTLOC(DepRowId),"^",5)
	;s ^tempsc("IPNurList")=$lb(DepRowId,ComparePart)
	;i wardFlag'="Y" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s ResRowId=""
	f  s ResRowId=$o(^RB("RES",0,"CTLOC",DepRowId,ResRowId)) q:ResRowId=""  d
	.s NurId=$p($G(^RB("RES",ResRowId)),"^",2)
	.s NurDesc=$p($G(^RB("RES",ResRowId)),"^",17)
	.s RESDateTo=$p($g(^RB("RES",ResRowId)),"^",19)
	.q:(RESDateTo'="")&&(RESDateTo<(+$h))
	.q:NurId=""
	.s CTCPTypeId=$P($G(^CTPCP(NurId,1)),"^",4)
	.q:CTCPTypeId=""
	.s UserCode=$P($G(^CTPCP(NurId,1)),"^",1)
	.s activeFlag=$P($G(^CTPCP(NurId,1)),"^",9)
	.q:activeFlag'="Y"
	.q:(NurDesc'[ComparePart)&&(UserCode'[ComparePart)&&(ComparePart'="")
	.s CTCPType=$P($G(^CT("CPT",CTCPTypeId)),"^",4)
	.q:CTCPType'="NURSE"
	.s today=+$h
	.s ssuserID = $o(^SSU("SSUSR",0,"CTPCP",NurId,""))	
	.quit:(today'="")&&($P(^SSU("SSUSR",ssuserID),"^",96)'="")&&($P(^SSU("SSUSR",ssuserID),"^",96)>today)
	.quit:(today'="")&&($P(^SSU("SSUSR",ssuserID),"^",97)'="")&&($P(^SSU("SSUSR",ssuserID),"^",97)<today)
	.Do OutputRow2
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow2
	set Data=$lb(NurId,NurDesc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod IPNurListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = IPNurListExecute ]
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

ClassMethod IPNurListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = IPNurListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

// 医生

Query IPDocList(LocId, ComparePart = "") As %Query(ROWSPEC = "DocId:%String,DocDesc:%String")
{
}

ClassMethod IPDocListExecute(ByRef qHandle As %Binary, LocId, ComparePart = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1 
	i LocId="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s ResRowId=""
	f  s ResRowId=$o(^RB("RES",0,"CTLOC",LocId,ResRowId)) q:ResRowId=""  d
	.s DocId=$p($G(^RB("RES",ResRowId)),"^",2)
	.s admright=$p($G(^RB("RES",ResRowId)),"^",20)
	.q:(admright'="Y")
	.s DocDesc=$p($G(^RB("RES",ResRowId)),"^",17)
	.q:DocId=""
	.s CTCPTypeId=$P($G(^CTPCP(DocId,1)),"^",4)
	.q:CTCPTypeId=""
	.s UserCode=$P($G(^CTPCP(DocId,1)),"^",1)
	.q:(DocDesc'[ComparePart)&&(UserCode'[ComparePart)&&(ComparePart'="")
	.s CTCPType=$P($G(^CT("CPT",CTCPTypeId)),"^",4)
	.;q:CTCPType'="DOCTOR"
	.Do OutputRow2
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow2
	set Data=$lb(DocId,DocDesc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod IPDocListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = IPDocListExecute ]
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

ClassMethod IPDocListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = IPDocListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod UpdateMainDocAndNurse(EpisodeID, CTPCPCode, MainNurseID, MainNurseID2, LocationID, userId)
{

	s CTPCPID=$S(CTPCPCode'="":$O(^CTPCP(0,"Code",$ZCVT(CTPCPCode,"U"),0)),1:"")
	//更新主管医生
	i CTPCPID'=""
	{
		s curCTPCTID=$p(^PAADM(EpisodeID),"^",9)
		if (curCTPCTID'=CTPCPID)
		{
			s retU=##class(web.DHCMainNurse).UpdateDoc(EpisodeID,CTPCPID,LocationID,userId)
			i retU q 0
		}
	}

		
	//更新主管护士
	i $g(MainNurseID)'=""
	{
		s retN=##class(web.DHCMainNurse).UpdateMainNurse(EpisodeID,MainNurseID,MainNurseID2)
		i retN q 0
	}
	q 0
}

ClassMethod UpdateMainNurse(EpisodeId As %String, NurRowId As %String, NurRowId2 As %String) As %String
{
	s ret=1
	q:(EpisodeId="") ret
	s DHCAdmRowId=""
	s DHCAdmRowId=$O(^DHCPAAdm(0,"PAAdm",EpisodeId,DHCAdmRowId),-1)
	i DHCAdmRowId'="" d
	.TStart 
	.&SQL(Update SQLUSER.DHC_PA_Adm set DHCADM_PAADM_Dr=:EpisodeId,DHCADM_MainNurse_Dr=:NurRowId,DHCADM_MainNurse2_Dr=:NurRowId2 where DHCADM_RowId=:DHCAdmRowId)
	.s ret=SQLCODE
	.i SQLCODE'=0 TRollBack
	.q:SQLCODE'=0
	.TCommit
	i DHCAdmRowId="" d
	.TStart 
	.&SQL(Insert into SQLUSER.DHC_PA_Adm (DHCADM_PAADM_Dr,DHCADM_MainNurse_Dr,DHCADM_MainNurse2_Dr) values (:EpisodeId,:NurRowId,:NurRowId2))
	.s ret=SQLCODE
	.i SQLCODE'=0 TRollBack
	.q:SQLCODE'=0
	.TCommit
	q ret
}

ClassMethod UpdateDoc(EpisodeId As %String, DocId As %String, CTLocId As %String, UserId As %String, MainNurse = "") As %String
{
	s ret=0
	s reqstId=$o(^PAC("REQST",0,"Code","T",""))
	s transtypId=$o(^PAC("TRANSTYP",0,"Code","T",""))	
	s editPreTrans="Y"
	s TRANSMain="Y"
	s preTransSub="",transSub=0
	s StDate=+$h,StTime=$p($h,",",2)
	i CTLocId="" s CTLocId=$p(^PAADM(EpisodeId),"^",4) //添加科室传参
	TStart
	f  s preTransSub=$o(^PAADM(EpisodeId,"TRANS",preTransSub),-1) q:(preTransSub="")!(transSub>0)  d
	.i $p(^PAADM(EpisodeId,"TRANS",preTransSub),"^",21)=transtypId s transSub=preTransSub
	.;$p(^PAADM(EpisodeID,"TRANS",preTransSub),"^",9)中 9->6 wanghc 20130224 结束转移科室记录,而不是结束转移病区记录
	.i $p(^PAADM(EpisodeId,"TRANS",preTransSub),"^",21)="",$p(^PAADM(EpisodeId,"TRANS",preTransSub),"^",6)'="" s transSub=preTransSub
	s StDate=+$h,StTime=$p($h,",",2)
	s SQLCODE=0
	i transSub>0,editPreTrans="Y" {
		s preTransId=EpisodeId_"||"_transSub
		s preReqstId=$o(^PAC("REQST",0,"Code","D",""))
		&sql(update SQLUser.PA_AdmTransaction set TRANS_Status_DR=:preReqstId,TRANS_EndDate=:StDate,TRANS_EndTime=:StTime where TRANS_RowId=:preTransId)
		
	}
	i SQLCODE TRollBack
	q:SQLCODE SQLCODE
	s curDate=+$h,curTime=$p($h,",",2)
	
	&sql(insert into SQLUser.PA_AdmTransaction 
	(TRANS_ParRef,TRANS_StartDate,TRANS_StartTime,
		TRANS_Status_DR,TRANS_UpdateDate,TRANS_UpdateTime,TRANS_UpdateUser_DR,
			TRANS_TransType_DR,TRANS_CTLOC_DR,TRANS_CTCP_DR,TRANS_Main,TRANS_MianNurse)  
			Values (:EpisodeId,:StDate,:StTime,:reqstId,:curDate,:curTime,:UserId,
				:transtypId,:CTLocId,:DocId,:TRANSMain,:MainNurse))	
	i SQLCODE TRollBack
	q:SQLCODE SQLCODE
	&sql(update SQLUser.PA_Adm (PAADM_AdmDocCodeDR)
	 Values (:DocId) Where PAADM_RowId=:EpisodeId)
	i SQLCODE TRollBack
	q:SQLCODE SQLCODE
	TCommit
	q ret
}

ClassMethod GetWardNurse(EpisodeId As %String) As %String
{
	q:EpisodeId="" ""
	s Str=..GetPatWardId(EpisodeId)
	q:Str="" ""
	s WardDesc=$P(Str,"^")
	s WardId=$P(Str,"^",2)
	s DHCAdmRowId=""
	s DHCAdmRowId=$O(^DHCPAAdm(0,"PAAdm",EpisodeId,DHCAdmRowId),-1)
	i DHCAdmRowId'="" d
	.s NurseId=$P($G(^DHCPAAdm(DHCAdmRowId)),"^",2)
	.i NurseId'="" d
	..s NurseDesc=$P($G(^CTPCP(NurseId,1)),"^",2)
	.s NurseId2=$P($G(^DHCPAAdm(DHCAdmRowId)),"^",20)
	.i NurseId2'="" d
	..s NurseDesc2=$P($G(^CTPCP(NurseId2,1)),"^",2)
	e  d
	.s NurseId=""
	.s NurseDesc=""
	.s NurseId2=""
	.s NurseDesc2=""
	s RetStr=WardDesc_"^"_WardId_"^"_$g(NurseDesc)_"^"_NurseId_"^"_$g(NurseDesc2)_"^"_$g(NurseId2)
	q RetStr
}

ClassMethod GetPatWardId(EpisodeID As %String)
{
   s res=""
   q:EpisodeID="" ""
   i EpisodeID'="" d
   .s WardID=$p(^PAADM(EpisodeID),"^",70)
   .q:WardID=""
   .s WardDesc=$p(^PAWARD(WardID),"^",2)
   .s WardID=$P($G(^PAWARD(WardID)),"^",5)
   .s res=WardDesc_"^"_WardID
   q $g(res)
}

ClassMethod GetPatLocId(EpisodeID As %String)
{
   q:EpisodeID="" ""
   s locId=$p(^PAADM(EpisodeID),"^",4)

   q $g(locId)
}

/// 取得主管医生
ClassMethod GetCTPCPDesc(EpisodeID As %String) As %String
{
	s CTPCPDr=$p(^PAADM(EpisodeID),"^",9)
	q:CTPCPDr="" ""
	s CTPCPDesc=$p($g(^CTPCP(CTPCPDr,1)),"^",2)
	q $g(CTPCPDesc)
}

/// 转移清除主管医生和主管护士
/// w ##Class(web.DHCMainNurse).ClearMainNurseDoc(55,"","","","")
ClassMethod ClearMainNurseDoc(EpisodeId As %String, NurRowId As %String, NurRowId2 As %String, Doc As %String, PhysicianId As %String, Doc2 As %String = "") As %String
{
	s ret=1
	q:(EpisodeId="") ret
	s DHCAdmRowId=""
	s DHCAdmRowId=$O(^DHCPAAdm(0,"PAAdm",EpisodeId,DHCAdmRowId),-1)
	
	TStart 
	i DHCAdmRowId'="" d
	.&SQL(Update SQLUSER.DHC_PA_Adm set DHCADM_PAADM_Dr=:EpisodeId,DHCADM_MainNurse_Dr=:NurRowId,DHCADM_MainNurse2_Dr=:NurRowId2,DHCADM_MainDoctor2_Dr=:Doc2 where DHCADM_RowId=:DHCAdmRowId)
	.s ret=SQLCODE
	.i SQLCODE'=0 TRollBack
	.q:SQLCODE'=0
	i DHCAdmRowId="" d
	.&SQL(Insert into SQLUSER.DHC_PA_Adm (DHCADM_PAADM_Dr,DHCADM_MainNurse_Dr,DHCADM_MainNurse2_Dr,DHCADM_MainDoctor2_Dr) values (:EpisodeId,:NurRowId,:NurRowId2,:Doc2))
	.s ret=SQLCODE
	.i SQLCODE'=0 TRollBack
	.q:SQLCODE'=0	
	&sql(update SQLUser.PA_Adm (PAADM_AdmDocCodeDR)
	 Values (:DocId) Where PAADM_RowId=:EpisodeId)
	i SQLCODE TRollBack
	q:SQLCODE SQLCODE
	TCommit
	q ret
}

/// 转移清除主管护士
/// w ##Class(web.DHCMainNurse).ClearMainNurse(55,"")
ClassMethod ClearMainNurse(EpisodeId As %String, NurRowId As %String) As %String
{
	s ret=1
	q:(EpisodeId="") ret
	s DHCAdmRowId=""
	s DHCAdmRowId=$O(^DHCPAAdm(0,"PAAdm",EpisodeId,DHCAdmRowId),-1)
	i DHCAdmRowId'="" d
	.TStart 
	.&SQL(Update SQLUSER.DHC_PA_Adm set DHCADM_PAADM_Dr=:EpisodeId,DHCADM_MainNurse_Dr=:NurRowId where DHCADM_RowId=:DHCAdmRowId)
	.s ret=SQLCODE
	.i SQLCODE'=0 TRollBack
	.q:SQLCODE'=0
	.TCommit
	q ret
}

}
