Import SQLUser

Class web.DHCCRM.CRMLiPei Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod SaveLiPei(Instring)
{
	s SQLCODE=0
	s lprowid=$p(Instring,"^",1)
	s PatAmount=$p(Instring,"^",2)
	s PatFactAmout=$p(Instring,"^",3)
	s Remark=$p(Instring,"^",4)
	s equal=$p(Instring,"^",5)
	s User=%session.Get("LOGON.USERID")
	s Date=+$h
	s LPFact="",oldequal=""
	&sql(select LP_FactAmount,LP_Equal into :LPFact,:oldequal from DHC_CRM_LiPeiRecord where LP_RowId=:lprowid)
	i +LPFact'=+PatFactAmout d  &sql(update DHC_CRM_LiPeiRecord (LP_FactAmount,LP_FactUserDr,LP_FactDate) values (:PatFactAmout,:User,:Date) where LP_RowId=:lprowid)
	i (oldequal'=equal)&&(equal="true") d  &sql(update DHC_CRM_LiPeiRecord (LP_Equal,LP_EqualUserDr,LP_EqualDate) values (:equal,:User,:Date) where LP_RowId=:lprowid)
	i (oldequal'=equal)&&(equal="false") d  &sql(update DHC_CRM_LiPeiRecord (LP_Equal,LP_EqualUserDr,LP_EqualDate) values (null,null,null) where LP_RowId=:lprowid)
	&sql(update DHC_CRM_LiPeiRecord (LP_PayAmount,LP_Remark) values (:PatAmount,:Remark) where LP_RowId=:lprowid)
	
	
	
	q SQLCODE
}

ClassMethod InsertNewRecord(PAADM, PAPMI)
{
	q:(PAADM="")&&(PAPMI="") ""
	s SQLCODE=0
	s User=%session.Get("LOGON.USERID")
	s Date=+$h
	&sql(insert into DHC_CRM_LiPeiRecord values (:PAADM,null,null,null,:User,:Date,null,null,null,null,null,null,null,null,null,null,null,null,null,null,:PAPMI,null,null,null))
	s IPInfo=$g(^DHCPESetting("DHCPE","PhotoFTP"))
	s PatNo=$p($g(^PAPER(PAPMI,"PAT",1)),"^",1)
	s Directory="DHCCRMliPei/LP"_%ROWID_"No"_PatNo
	d ##class(web.DHCPE.FTPManager).CreateDirectory($p(IPInfo,"^",1),$p(IPInfo,"^",2),$p(IPInfo,"^",3),$p(IPInfo,"^",4),Directory)
	q SQLCODE
}

ClassMethod GetInsuInfo(LPPAADM)
{
		s BillCon=0,LPInsurer="",LPInvAmount=0
	 	f  s BillCon=$o(^DHCBCI(0,"ADM",LPPAADM,BillCon)) q:BillCon=""  d
	 	.s PrtId=$p($g(^DHCBCI(BillCon)),"^",1)
	 	.s Sub=0
	 	.f  s Sub=$o(^DHCINVPRT(PrtId,"P",Sub)) q:Sub=""  d
	 	..s PayMode=$p(^DHCINVPRT(PrtId,"P",Sub),"^",1)
	 	..q:PayMode'=16
	 	..s Amt=$p(^DHCINVPRT(PrtId,"P",Sub),"^",3)
	 	..s InsuTypeID=$p(^DHCINVPRT(PrtId,"P",Sub),"^",13)
	 	..i +InsuTypeID'=0  s LPInsurer=$p(^ARC("INST",+InsuTypeID),"^",2)
	 	..s LPInvAmount=LPInvAmount+Amt
	 	q LPInvAmount_"^"_LPInsurer
}

/// w ##class(web.DHCCRM.CRMLiPei).GetLiPeiInfo("","","","","false","","","","")
ClassMethod GetLiPeiInfo(papmino, lpuser, lpinsuer, doctor, HadAmount, StartDate, EndDate, start, limit)
{
	s start=$G(start)
	s limit=$G(limit)
	
	s rs=##class(%ResultSet).%New("web.DHCCRM.CRMLiPei:SearchLiPeiInfo") 
	d rs.Execute(papmino,lpuser,lpinsuer,doctor,HadAmount,StartDate,EndDate)
 	
 	
 	
 	s count=0
 	s mess=""
 	s topnum=start+limit
 	
	while (rs.Next())
 	{
	 	
	 	
	 	s lprowid=rs.Get("lprowid")
	 	
	 	s LPPAADM=rs.Get("LPPAADM")
	 	s PapmiId=rs.Get("LPPAPMI")
	 	i LPPAADM'="" s PapmiId=$p(^PAADM(LPPAADM),"^",1)
	 	
	 	s LPPatNo=$p($g(^PAPER(PapmiId,"PAT",1)),"^",1)
	 	s episno=$p($g(^PAPER(PapmiId,"PAT",1)),"^",22)
	 	i episno'="" s episno=..RegNoMask(episno)
	 	i papmino'="" s papmino=..RegNoMask(papmino)
	 	continue:(papmino'="")&&((papmino'=LPPatNo)&&(papmino'=episno))
	 	
   		s LPPatName=$p($g(^PAPER(PapmiId,"ALL")),"^",1)
	 	s LPPatName="<a href='ftp://192.168.2.68/DHCCRMliPei/LP"_lprowid_"No"_LPPatNo_"/'target='_blank'>"_LPPatName_"</a>"
	 	s LPADMDate=""
	 	i LPPAADM'="" s LPADMDate=$p(^PAADM(LPPAADM),"^",6)
	 	i LPADMDate'="" s LPADMDate=$zd(LPADMDate,3)
	 	
	 	s LPDiagnosis=##class(web.DHCCRM.SetPlan).GetAllMDiagnos(LPPAADM)
	 	s InsuInfo=""
	 	i LPPAADM'="" s InsuInfo=..GetInsuInfo(LPPAADM)
	 	s LPInvAmount=+InsuInfo
	 	s LPInsurer=$p(InsuInfo,"^",2)
	 	s lpinsuer=$zcvt(lpinsuer,"U")
	 	s LPInsurer=$zcvt(LPInsurer,"U")
	 	continue:(lpinsuer'="")&&(LPInsurer'[lpinsuer)
	 	s LPInvAmount=$fn(LPInvAmount,"",2)
	 	s LPDocDr="",LPDocName=""
	 	i LPPAADM'="" s LPDocDr=$p(^PAADM(LPPAADM),"^",9)
	 	i LPDocDr'="" s LPDocName=$p($g(^CTPCP(LPDocDr,1)),"^",2)
	 	s doctor=$zcvt(doctor,"U")
	 	s LPDocName=$zcvt(LPDocName,"U")
	 	continue:(doctor'="")&&(LPDocName'[doctor)
	 	s LPDedAmount=rs.Get("LPDedAmount")
	 	s LPCoAmount=rs.Get("LPCoAmount")
	 	s LPNCAmount=rs.Get("LPNCAmount")
	 	;s LPPatAmount=LPDedAmount+LPCoAmount+LPNCAmount
	 	s LPPatAmount=rs.Get("LPPayAmount")
	 	s LPPatAmount=$fn(LPPatAmount,"",2)
	 	s LPUserDr=rs.Get("LPUserDr"),LPUserName=""
	 	i LPUserDr'="" s LPUserName=$p(^SSU("SSUSR",LPUserDr),"^",2)
	 	continue:(lpuser'="")&&(lpuser'=LPUserName)
	 	s LPDate=rs.Get("LPDate")
	 	
	 	i LPDate'="" s LPDate=$zd(LPDate,3)
	 	s LPFactDedAmount=rs.Get("LPFactDedAmount")
	 	s LPDedUserDr=rs.Get("LPDedUserDr"),LPDedUserName=""
	 	i LPDedUserDr'="" s LPDedUserName=$p(^SSU("SSUSR",LPDedUserDr),"^",2)
	 	s LPDedDate=rs.Get("LPDedDate")
	 	i LPDedDate'="" s LPDedDate=$zd(LPDedDate,3)
	 	s LPFactCoAmount=rs.Get("LPFactCoAmount")
	 	s LPCoUserDr=rs.Get("LPCoUserDr"),LPCoUserName=""
	 	i LPCoUserDr'="" s LPCoUserName=$p(^SSU("SSUSR",LPCoUserDr),"^",2)
	 	s LPCoDate=rs.Get("LPCoDate")
	 	i LPCoDate'="" s LPCoDate=$zd(LPCoDate,3)
	 	s LPFactNCAmount=rs.Get("LPFactNCAmount"),LPNCUserName=""
	 	s LPNCUserDr=rs.Get("LPNCUserDr"),LPNCUserName=""
	 	i LPNCUserDr'="" s LPNCUserName=$p(^SSU("SSUSR",LPNCUserDr),"^",2)
	 	s LPNCDate=rs.Get("LPNCDate")
	 	i LPNCDate'="" s LPNCDate=$zd(LPNCDate,3)
	 	s LPRemark=rs.Get("LPRemark")
	 	s LPRemark=$tr(LPRemark,$c(13,10),"\n")
	 	s LPPatFactAmout=0
	 	;s LPPatFactAmout=LPFactDedAmount+LPFactCoAmount+LPFactNCAmount
	 	s LPPatFactAmout=rs.Get("LPFactAmount")
	 	s LPPatFactAmout=$fn(LPPatFactAmout,"",2)
	 	
	 	s LPFactUserDr=rs.Get("LPFactUserDr"),LPFactUserName=""
	 	i LPFactUserDr'="" s LPFactUserName=$p(^SSU("SSUSR",LPFactUserDr),"^",2)
	 	s LPFactDate=rs.Get("LPFactDate")
	 	i LPFactDate'="" s LPFactDate=$zd(LPFactDate,3)
	 	
	 	s LPEqual=rs.Get("LPEqual")
	 	s LPEqualUserDr=rs.Get("LPEqualUserDr"),LPEqualUserName=""
	 	i LPEqualUserDr'="" s LPEqualUserName=$p(^SSU("SSUSR",LPEqualUserDr),"^",2)
	 	s LPEqualDate=rs.Get("LPEqualDate")
	 	i LPEqualDate'="" s LPEqualDate=$zd(LPEqualDate,3)
	 	
	 	continue:(HadAmount="true")&&(LPPatFactAmout=LPPatAmount)
	 	continue:(HadAmount="true")&&(LPEqual="true")
	 	
	 	s count=count+1
	 	i (start'="")&(limit'="") continue:(count<=start)!(count>topnum)
	 	
		i (mess'="") s mess=mess_","
		s mess=mess_"{""lprowid"":"_""""_lprowid_""""
		s mess=mess_","_"""LPPatNo"":"_""""_LPPatNo_""""
		s mess=mess_","_"""LPPatName"":"_""""_LPPatName_""""
		s mess=mess_","_"""LPPAADM"":"_""""_LPPAADM_""""
		s mess=mess_","_"""LPADMDate"":"_""""_LPADMDate_""""
		s mess=mess_","_"""LPDiagnosis"":"_""""_LPDiagnosis_""""
		s mess=mess_","_"""LPInvAmount"":"_""""_LPInvAmount_""""
		s mess=mess_","_"""LPDocName"":"_""""_LPDocName_""""
		s mess=mess_","_"""LPInsurer"":"_""""_LPInsurer_""""
		s mess=mess_","_"""LPDedAmount"":"_""""_LPDedAmount_""""
		s mess=mess_","_"""LPCoAmount"":"_""""_LPCoAmount_""""
		s mess=mess_","_"""LPNCAmount"":"_""""_LPNCAmount_""""
		s mess=mess_","_"""LPUserName"":"_""""_LPUserName_""""
		s mess=mess_","_"""LPDate"":"_""""_LPDate_""""
		s mess=mess_","_"""LPFactDedAmount"":"_""""_LPFactDedAmount_""""
		s mess=mess_","_"""LPDedUserName"":"_""""_LPDedUserName_""""
		s mess=mess_","_"""LPDedDate"":"_""""_LPDedDate_""""
		s mess=mess_","_"""LPFactCoAmount"":"_""""_LPFactCoAmount_""""
		s mess=mess_","_"""LPCoUserName"":"_""""_LPCoUserName_""""
		s mess=mess_","_"""LPCoDate"":"_""""_LPCoDate_""""
		s mess=mess_","_"""LPFactNCAmount"":"_""""_LPFactNCAmount_""""
		s mess=mess_","_"""LPNCUserName"":"_""""_LPNCUserName_""""
		s mess=mess_","_"""LPNCDate"":"_""""_LPNCDate_""""
		s mess=mess_","_"""LPRemark"":"_""""_LPRemark_""""
		s mess=mess_","_"""LPPatAmount"":"_""""_LPPatAmount_""""
		s mess=mess_","_"""LPPatFactAmout"":"_""""_LPPatFactAmout_""""
		s mess=mess_","_"""LPFactUserName"":"_""""_LPFactUserName_""""
		s mess=mess_","_"""LPFactDate"":"_""""_LPFactDate_""""
		s mess=mess_","_"""LPEqual"":"_""""_LPEqual_""""
		s mess=mess_","_"""LPEqualUserName"":"_""""_LPEqualUserName_""""
		s mess=mess_","_"""LPEqualDate"":"_""""_LPEqualDate_""""
		s mess=mess_"}"
	}	 	 
 	s mess="["_mess_"]"
 	s mess="{""results"":"_""""_count_""""_","_"""rows"""_":"_mess_"}"
 	   
 	q mess
}

ClassMethod RegNoMask(RegNo)
{
	s length=+$G(^DHCCRMSetting("DHCCRM","RegNoLength"))
	i length=0 s length=10
	s ZeroStr=$E("00000000000000000000000000",1,length)
	s RegNo=$E(ZeroStr,1,length-$l(RegNo))_RegNo
	q RegNo
}

/// w ##class(web.DHCCRM.CRMLiPei).GetPatInfo()
ClassMethod GetPatInfo(patno)
{
	i patno="" q "{results:0,rows:[{}]}"
	s json=##class(dhc.ca.cache.comm.JsonObj).%New()
	s jsonTitle="PAADM^PatNo^Name^AdmDate^Doc^Insuer^InvAmount^Diagnosis^PAPMI"
	s count=0
	s PAPMI=$o(^PAPERi("Medicare",patno_"Z",0))
	i PAPMI="" d
	.s patno=##class(web.DHCPE.DHCPECommon).UnEscape(patno)
	.s patno=..RegNoMask(patno)
	.s PAPMI=$o(^PAPERi("PAPMI_PatNo",patno,0))
	s PAPMINO=$p($g(^PAPER(PAPMI,"PAT",1)),"^",1)
	s PatName=$p($g(^PAPER(PAPMI,"ALL")),"^",1)
	s PAADM=""
	f  s PAADM=$o(^PAPERdr(PAPMI,"ADM","O",PAADM),-1) q:PAADM=""  d
	.s LPADMDate=$p(^PAADM(PAADM),"^",6)
	.i LPADMDate'="" s LPADMDate=$zd(LPADMDate,3)
	.s LPDocDr=$p(^PAADM(PAADM),"^",9),LPDocName=""
	.i LPDocDr'="" s LPDocName=$p($g(^CTPCP(LPDocDr,1)),"^",2)
	.s InsuInfo=..GetInsuInfo(PAADM)
	.s LPInvAmount=+InsuInfo
	.s LPInsurer=$p(InsuInfo,"^",2)
	.s LPInvAmount=$fn(LPInvAmount,"",2)
	.q:LPInsurer=""
	.s LPDiagnosis="" //    ##class(web.DHCCRM.SetPlan).GetAllMDiagnos(PAADM)
	.//s LPDiagnosis=$tr(LPDiagnosis,$c(13,10),"")
	.s tmp=PAADM_"^"_PAPMINO_"^"_PatName_"^"_LPADMDate_"^"_LPDocName_"^"_LPInsurer_"^"_LPInvAmount_"^"_LPDiagnosis_"^"_PAPMI
	.d json.InsertRowData(tmp)
	.s count=count+1
	s tmp=""_"^"_PAPMINO_"^"_PatName_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""_"^"_PAPMI
	d json.InsertRowData(tmp)
	s count=count+1
	s jsonStr = json.getJsonData(jsonTitle,count)

 	k json
	q jsonStr
}

/// d ##class(%ResultSet).RunQuery("web.DHCCRM.CRMLiPei","SearchLiPeiInfo","","","","","","","")
Query SearchLiPeiInfo(papmino, lpuser, lpinsuer, doctor, HadAmount, StartDate, EndDate) As %Query(ROWSPEC = "lprowid,LPPAADM,LPDedAmount,LPCoAmount,LPNCAmount,LPUserDr,LPDate,LPFactDedAmount,LPDedUserDr,LPDedDate,LPFactCoAmount,LPCoUserDr,LPCoDate,LPFactNCAmount,LPNCUserDr,LPNCDate,LPRemark:%String,LPPayAmount,LPFactAmount,LPFactUserDr,LPFactDate,LPPAPMI,LPEqual,LPEqualUserDr,LPEqualDate")
{
}

ClassMethod SearchLiPeiInfoExecute(ByRef qHandle As %Binary, papmino, lpuser, lpinsuer, doctor, HadAmount, StartDate, EndDate) As %Status
{
   
   
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	i StartDate="" s StartDate=0
	e  s StartDate=$zdh(StartDate,3)
	i EndDate="" s EndDate=+$h
	e  s EndDate=$zdh(EndDate,3)
	s lprowid=""
	f  s lprowid=$o(^User.DHCCRMLiPeiRecordD(lprowid),-1) q:lprowid=""  d
	.s LPPAADM=$lg(^User.DHCCRMLiPeiRecordD(lprowid),2)
	.s LPDedAmount=$lg(^User.DHCCRMLiPeiRecordD(lprowid),3)
	.s LPCoAmount=$lg(^User.DHCCRMLiPeiRecordD(lprowid),4)
	.s LPNCAmount=$lg(^User.DHCCRMLiPeiRecordD(lprowid),5)
	.s LPUserDr=$lg(^User.DHCCRMLiPeiRecordD(lprowid),6)
	.s LPDate=$lg(^User.DHCCRMLiPeiRecordD(lprowid),7)
	.q:(LPDate<StartDate)||(LPDate>EndDate)
	.s LPFactDedAmount=$lg(^User.DHCCRMLiPeiRecordD(lprowid),8)
	.s LPDedUserDr=$lg(^User.DHCCRMLiPeiRecordD(lprowid),9)
	.s LPDedDate=$lg(^User.DHCCRMLiPeiRecordD(lprowid),10)
	.s LPFactCoAmount=$lg(^User.DHCCRMLiPeiRecordD(lprowid),11)
	.s LPCoUserDr=$lg(^User.DHCCRMLiPeiRecordD(lprowid),12)
	.s LPCoDate=$lg(^User.DHCCRMLiPeiRecordD(lprowid),13)
	.s LPFactNCAmount=$lg(^User.DHCCRMLiPeiRecordD(lprowid),14)
	.s LPNCUserDr=$lg(^User.DHCCRMLiPeiRecordD(lprowid),15)
	.s LPNCDate=$lg(^User.DHCCRMLiPeiRecordD(lprowid),16)
	.s LPRemark=$lg(^User.DHCCRMLiPeiRecordD(lprowid),17)
	.s LPPayAmount=$lg(^User.DHCCRMLiPeiRecordD(lprowid),18)
	.s LPFactAmount=$lg(^User.DHCCRMLiPeiRecordD(lprowid),19)
	.s LPFactUserDr=$lg(^User.DHCCRMLiPeiRecordD(lprowid),20)
	.s LPFactDate=$lg(^User.DHCCRMLiPeiRecordD(lprowid),21)
	.s LPPAPMI=$lg(^User.DHCCRMLiPeiRecordD(lprowid),22)
	.s LPEqual=$lg(^User.DHCCRMLiPeiRecordD(lprowid),23)
	.s LPEqualUserDr=$lg(^User.DHCCRMLiPeiRecordD(lprowid),24)
	.s LPEqualDate=$lg(^User.DHCCRMLiPeiRecordD(lprowid),25)
    .d OutputRow
    
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow
	set Data=$lb(lprowid,LPPAADM,LPDedAmount,LPCoAmount,LPNCAmount,LPUserDr,LPDate,LPFactDedAmount,LPDedUserDr,LPDedDate,LPFactCoAmount,LPCoUserDr,LPCoDate,LPFactNCAmount,LPNCUserDr,LPNCDate,LPRemark,LPPayAmount,LPFactAmount,LPFactUserDr,LPFactDate,LPPAPMI,LPEqual,LPEqualUserDr,LPEqualDate)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod SearchLiPeiInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchLiPeiInfoExecute ]
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

ClassMethod SearchLiPeiInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchLiPeiInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 2016-06-06 判断病人是否有未理赔的信息 , 1---有未理赔项，0 --没有理赔项
ClassMethod InsuNLiquidation(patid)
{
   s NLiquidation=0
   q:patid="" 0
   s lpid=$o(^User.DHCCRMLiPeiRecordI("IndexPAPMI",patid,0))
   q:lpid="" 0
   s LPPayAmount=$lg(^User.DHCCRMLiPeiRecordD(lpid),18)
   s LPFactAmount=$lg(^User.DHCCRMLiPeiRecordD(lpid),19)
   s:+LPPayAmount'=+LPFactAmount NLiquidation=1
   q NLiquidation
}

}
