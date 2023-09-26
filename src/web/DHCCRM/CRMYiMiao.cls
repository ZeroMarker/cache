Import SQLUser

Class web.DHCCRM.CRMYiMiao Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod SendYiMiaoSMS(str)
{
	q:str="" 0
	s Type="YIMIAO"
	q ##class(web.DHCPE.SendMessage).SaveMessage(Type,str)
}

ClassMethod GetOldInfo(ymid)
{
	q:ymid="" ""
	s olduser="",oldshuser="",oldstatus="",oldguser=""
	&sql(select YM_UserDR,YM_Status,YM_SHUserDR,YM_GivenUserDR into :olduser,:oldstatus,:oldshuser,:oldguser from DHC_CRM_YiMiaoRecord where YM_RowId=:ymid)
	q olduser_"^"_oldshuser_"^"_oldstatus_"^"_oldguser
}

/// w ##class(web.DHCCRM.CRMYiMiao).GetPatientInfo()
ClassMethod GetPatientInfo(PapmiId)
{
	
	
 	s mess=""
 	s count=1

    s RegNo=$p($g(^PAPER(PapmiId,"PAT",1)),"^",1)

    s Name=$p($g(^PAPER(PapmiId,"ALL")),"^",1)
    
    s Sex=$p($g(^CT("SEX",$p($g(^PAPER(PapmiId,"ALL")),"^",7))),"^",2)
   	
    s hometel=$p($g(^PAPER(PapmiId,"PER",1)),"^",11)

    s worktel=$p($g(^PAPER(PapmiId,"PER",1)),"^",9)
	
	s MobPhone=$p($g(^PAPER(PapmiId,"PER",4)),"^",21)  
    
	s Birth=$p($g(^PAPER(PapmiId,"ALL")),"^",6)
	s Age=##class(web.DHCLCNUREXCUTE).CalAge(Birth,+$h)
	s Age=$P(Age,"Y",1)_"岁"
	s:(Age="0岁") Age=##class(web.DHCBillInterface).GetPapmiAge(PapmiId,"",$ZD(+$H,3),$Zt($p($H,",",2)))

	s Birth=##class(websys.Conversions).DateLogicalToHtml(Birth) 
	i (mess'="") s mess=mess_","
	s mess=mess_"{""RegNo"":"_""""_RegNo_""""
	s mess=mess_","_"""Name"":"_""""_Name_""""
	s mess=mess_","_"""Sex"":"_""""_Sex_""""
	s mess=mess_","_"""Birth"":"_""""_Birth_""""
	s mess=mess_","_"""Age"":"_""""_Age_""""
	s mess=mess_","_"""hometel"":"_""""_hometel_""""
	s mess=mess_","_"""worktel"":"_""""_worktel_""""
	s mess=mess_","_"""MobPhone"":"_""""_MobPhone_""""
	s mess=mess_"}"
		 	 
 	s mess="["_mess_"]"
 	s mess="{""results"":"_""""_count_""""_","_"""rows"""_":"_mess_"}"
 	q mess
}

/// w ##class(web.DHCCRM.CRMYiMiao).GetSiteInfo()
ClassMethod GetSiteInfo(bid As %String = "")
{
	 
	s rs=##class(%ResultSet).%New("web.DHCCRM.CRMYiMiao:SearchSiteInfo") 
	d rs.Execute(bid)
 
 	s count=0
 	s mess=""
 	
	while (rs.Next())
 	{
	 	s count=count+1
	 
	 	s site=rs.Get("site")
	 	
		i (mess'="") s mess=mess_","
		s mess=mess_"{""id"":"_""""_site_""""
		s mess=mess_","_"""site"":"_""""_site_""""
		s mess=mess_"}"
	}	 	 
 	s mess="["_mess_"]"
 	s mess="{""results"":"_""""_count_""""_","_"""rows"""_":"_mess_"}"
 	q mess
}

/// w ##class(web.DHCCRM.CRMYiMiao).GetYiMiaoInfo(72957)
ClassMethod GetYiMiaoInfo(patientID, start, limit)
{
	s start=$G(start)
	s limit=$G(limit)
	 
	s rs=##class(%ResultSet).%New("web.DHCCRM.CRMYiMiao:SearchYiMiao") 
	d rs.Execute(patientID)
 
 	s count=0
 	s mess=""
 	s topnum=start+limit
 	
	while (rs.Next())
 	{
	 	s count=count+1
	 	i (start'="")&(limit'="") continue:(count<=start)!(count>topnum)
	 	
	 	
	 	s ymid=rs.Get("ymid")
	 	s ymbid=rs.Get("ymbid")
	 	s ymcode=rs.Get("ymcode")
	 	s ymdesc=rs.Get("ymdesc")
	 	s ymnum=rs.Get("ymnum")
	 	s ymgdate=rs.Get("ymgdate")
	 	i ymgdate'="" s ymgdate=$zd(ymgdate,3)
	 	s ymisgiven=rs.Get("ymisgiven")
	 	s ymsite=rs.Get("ymsite")
	 	s ymdose=rs.Get("ymdose")
	 	s ymmf=rs.Get("ymmf")
	 	s ymltno=rs.Get("ymltno")
	 	s ymuser=rs.Get("ymuser")
	 	i ymuser'="" s ymuser=$p(^SSU("SSUSR",ymuser),"^",2)
	 	s shuser=rs.Get("shuser")
	 	i shuser'="" s shuser=$p(^SSU("SSUSR",shuser),"^",2)
	 	s ymremark=rs.Get("ymremark")
	 	s ymndate=rs.Get("ymndate")
	 	i ymndate'="" s ymndate=$zd(ymndate,3)
	 	s ymseq=rs.Get("ymseq")
	 	s ymstatus=rs.Get("ymstatus")
	 	s (ZhiXing,ShenHe)=""
	 	i ymstatus="E" s ZhiXing="true"
	 	i ymstatus="S" s ShenHe="true",ZhiXing="true"
	 	s ymway=rs.Get("ymway")
	 	s ymguser=rs.Get("ymguser")
	 	i ymguser'="" s ymguser=$p(^SSU("SSUSR",ymguser),"^",2)
	 	
		i (mess'="") s mess=mess_","
		s mess=mess_"{""ymid"":"_""""_ymid_""""
		s mess=mess_","_"""ymcode"":"_""""_ymcode_""""
		s mess=mess_","_"""ymdesc"":"_""""_ymdesc_""""
		s mess=mess_","_"""ymnum"":"_""""_ymnum_""""
		s mess=mess_","_"""ymsite"":"_""""_ymsite_""""
		s mess=mess_","_"""ymdose"":"_""""_ymdose_""""
		s mess=mess_","_"""ymmf"":"_""""_ymmf_""""
		s mess=mess_","_"""ymltno"":"_""""_ymltno_""""
		s mess=mess_","_"""ymremark"":"_""""_ymremark_""""
		s mess=mess_","_"""ymseq"":"_""""_ymseq_""""
		s mess=mess_","_"""ymgdate"":"_""""_ymgdate_""""
		s mess=mess_","_"""ymbid"":"_""""_ymbid_""""
		s mess=mess_","_"""ymisgiven"":"_""""_ymisgiven_""""
		s mess=mess_","_"""ymndate"":"_""""_ymndate_""""
		s mess=mess_","_"""ymuser"":"_""""_ymuser_""""
		s mess=mess_","_"""shuser"":"_""""_shuser_""""
		s mess=mess_","_"""ymstatus"":"_""""_ymstatus_""""
		s mess=mess_","_"""ZhiXing"":"_""""_ZhiXing_""""
		s mess=mess_","_"""ShenHe"":"_""""_ShenHe_""""
		s mess=mess_","_"""ymway"":"_""""_ymway_""""
		s mess=mess_","_"""ymguser"":"_""""_ymguser_""""
		s mess=mess_"}"
	}	 	 
 	s mess="["_mess_"]"
 	s mess="{""results"":"_""""_count_""""_","_"""rows"""_":"_mess_"}"
 	q mess
}

/// w ##class(web.DHCCRM.CRMYiMiao).GetYiMiaoBaseInfo()
ClassMethod GetYiMiaoBaseInfo(start, limit)
{
	s start=$G(start)
	s limit=$G(limit)
	
	s rs=##class(%ResultSet).%New("web.DHCCRM.CRMYiMiao:SearchYiMiaoBase") 
	d rs.Execute()
 
 	s count=0
 	s mess=""
 	s topnum=start+limit
 	
	while (rs.Next())
 	{
	 	s count=count+1
	 	i (start'="")&(limit'="") continue:(count<=start)!(count>topnum)
	 	
	 	s ymid=rs.Get("ymid")
	 	s ymcode=rs.Get("ymcode")
	 	s ymdesc=rs.Get("ymdesc")
	 	s ymcount=rs.Get("ymcount")
	 	s ymsite=rs.Get("ymsite")
	 	s ymdose=rs.Get("ymdose")
	 	s ymmf=rs.Get("ymmf")
	 	s ymltno=rs.Get("ymltno")
	 	s ymremark=rs.Get("ymremark")
	 	s ymseq=rs.Get("ymseq")
	 	s ymway=rs.Get("ymway")
	 	s ymactive=rs.Get("ymactive")
	 	i ymactive="Y" s ymactive="true"
		i (mess'="") s mess=mess_","
		s mess=mess_"{""ymid"":"_""""_ymid_""""
		s mess=mess_","_"""ymcode"":"_""""_ymcode_""""
		s mess=mess_","_"""ymdesc"":"_""""_ymdesc_""""
		s mess=mess_","_"""ymcount"":"_""""_ymcount_""""
		s mess=mess_","_"""ymsite"":"_""""_ymsite_""""
		s mess=mess_","_"""ymdose"":"_""""_ymdose_""""
		s mess=mess_","_"""ymmf"":"_""""_ymmf_""""
		s mess=mess_","_"""ymltno"":"_""""_ymltno_""""
		s mess=mess_","_"""ymremark"":"_""""_ymremark_""""
		s mess=mess_","_"""ymseq"":"_""""_ymseq_""""
		s mess=mess_","_"""ymway"":"_""""_ymway_""""
		s mess=mess_","_"""ymactive"":"_""""_ymactive_""""
		s mess=mess_"}"
	}	 	 
 	s mess="["_mess_"]"
 	s mess="{""results"":"_""""_count_""""_","_"""rows"""_":"_mess_"}"
 	   
 	q mess
}

/// d ##class(%ResultSet).RunQuery("web.DHCCRM.CRMYiMiao","SearchYiMiaoBase")
Query SearchYiMiaoBase() As %Query(ROWSPEC = "ymid:%String,ymcode:%String,ymdesc:%String,ymcount:%String,ymsite:%String,ymdose:%String,ymmf:%String,ymltno:%String,ymremark:%String,ymseq:%String,ymway:%String,ymactive:%String")
{
}

ClassMethod SearchYiMiaoBaseExecute(ByRef qHandle As %Binary) As %Status
{
   
   
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s NowHosp=%session.Get("LOGON.HOSPID")
	s ymseq=0
	f  s ymseq=$o(^User.DHCCRMYiMiaoBaseI("YMBSequenceIndex",ymseq)) q:ymseq=""  d
	.s ymid=0
	.f  s ymid=$o(^User.DHCCRMYiMiaoBaseI("YMBSequenceIndex",ymseq,ymid)) q:ymid=""  d
	..s ymcode=$lg(^User.DHCCRMYiMiaoBaseD(ymid),2)
	..s ymdesc=$lg(^User.DHCCRMYiMiaoBaseD(ymid),3)
	..s ymcount=$lg(^User.DHCCRMYiMiaoBaseD(ymid),4)
	..s ymsite=$lg(^User.DHCCRMYiMiaoBaseD(ymid),5)
	..s ymdose=$lg(^User.DHCCRMYiMiaoBaseD(ymid),6)
	..s ymmf=$lg(^User.DHCCRMYiMiaoBaseD(ymid),7)
	..s ymltno=$lg(^User.DHCCRMYiMiaoBaseD(ymid),8)
	..s ymremark=$lg(^User.DHCCRMYiMiaoBaseD(ymid),9)
	..s ymway=$lg(^User.DHCCRMYiMiaoBaseD(ymid),11)
	..s ymactive=$lg(^User.DHCCRMYiMiaoBaseD(ymid),12)
	..s ymhosp=$lg(^User.DHCCRMYiMiaoBaseD(ymid),13)
	..q:NowHosp'=ymhosp
    ..d OutputRow
    
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow
	set Data=$lb(ymid,ymcode,ymdesc,ymcount,ymsite,ymdose,ymmf,ymltno,ymremark,ymseq,ymway,ymactive)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod SearchYiMiaoBaseFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchYiMiaoBaseExecute ]
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

ClassMethod SearchYiMiaoBaseClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchYiMiaoBaseExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod SaveYiMiaoByTime(ymid, ymndate)
{
	s SQLCODE=0
	i ymndate'="" s ymndate=$zdh(ymndate,3)
	s updateuser=%session.Get("LOGON.USERID")
	s updatedate=+$h
	if (ymid'="")
	{
		s oldnextdate=""
		&sql(select YM_NextDate into :oldnextdate from DHC_CRM_YiMiaoRecord where YM_RowId=:ymid)
		&sql(update DHC_CRM_YiMiaoRecord set YM_NextDate=:ymndate where YM_RowId=:ymid)
		i oldnextdate'=ymndate &sql(insert into DHC_CRM_YiMiaoTime (YMTParRef,YMT_UpdateUserDR,YMT_UpdateDate,YMT_NextDate) values (:ymid,:updateuser,:updatedate,:ymndate))
	}
	q SQLCODE
}

ClassMethod SaveYiMiao(ymid, Instring)
{
	s SQLCODE=0
	s ymbid=  $p(Instring,"^",2)
	s ymcode =  $p(Instring,"^",3)
	s ymdesc =  $p(Instring,"^",4)
	s ymnum = $p(Instring,"^",5)
	s ymgdate=$p(Instring,"^",6)
	i ymgdate'="" s ymgdate=$zdh(ymgdate,3)
	s ymisgiven=$p(Instring,"^",7)
	i ymisgiven="false" s ymisgiven="" 
	s ymsite =  $p(Instring,"^",8)
	s ymdose =  $p(Instring,"^",9)
	s ymmf =  $p(Instring,"^",10)
	s ymltno =  $p(Instring,"^",11)
	s ymremark =  $p(Instring,"^",12)
	s ymndate =  $p(Instring,"^",13)
	i ymndate'="" s ymndate=$zdh(ymndate,3)
	s patientID =  $p(Instring,"^",14)
	s ymseq =  $p(Instring,"^",15)
	s zhixing =  $p(Instring,"^",16)
	s shenhe =  $p(Instring,"^",17)
	s ymway =  $p(Instring,"^",18)
	s SHUser="",User="",status=""
	s updatedate=+$h
	i ymisgiven="true" s GUser=%session.Get("LOGON.USERID")
	i zhixing="true" s User=%session.Get("LOGON.USERID"),status="E",ymgdate=+$h
	i shenhe="true" s SHUser=%session.Get("LOGON.USERID"),status="S"
	s nowuser=%session.Get("LOGON.USERID")
	if (ymid="")
	{
		&sql(insert into DHC_CRM_YiMiaoRecord values (:ymbid,:ymcode,:ymdesc,:ymnum,:ymgdate,:ymisgiven,:ymsite,:ymdose,:ymmf,:ymltno,null,:ymremark,:ymndate,:patientID,:ymseq,null,null,:ymway,null))
	}
	else
	{
		s olduser="",oldshuser="",oldstatus="",oldguser="",oldnext=""
		&sql(select YM_UserDR,YM_Status,YM_SHUserDR,YM_GivenUserDR,YM_NextDate into :olduser,:oldstatus,:oldshuser,:oldguser,:oldnext from DHC_CRM_YiMiaoRecord where YM_RowId=:ymid)
		i (oldstatus="S")||(shenhe="true") s User=olduser
		i (ymisgiven="")&&(oldguser'="")&&(oldguser'=nowuser) s GUser=oldguser,ymisgiven="true"
		i (zhixing="false")&&(olduser'="")&&(olduser'=nowuser) s User=olduser,status="E"
		
		i (shenhe="false")&&(oldshuser'="")&&(oldshuser'=nowuser) s SHUser=oldshuser,status="S"
		
		&sql(update DHC_CRM_YiMiaoRecord values (:ymbid,:ymcode,:ymdesc,:ymnum,:ymgdate,:ymisgiven,:ymsite,:ymdose,:ymmf,:ymltno,:User,:ymremark,:ymndate,:patientID,:ymseq,:SHUser,:status,:ymway,:GUser) where YM_RowId=:ymid)
		i oldnext'=ymndate &sql(insert into DHC_CRM_YiMiaoTime (YMTParRef,YMT_UpdateUserDR,YMT_UpdateDate,YMT_NextDate) values (:ymid,:nowuser,:updatedate,:ymndate))
	}
	q SQLCODE
}

ClassMethod SaveYiMiaoBase(ymid, Instring)
{
	s SQLCODE=0
	s ymcode =  $p(Instring,"^",2)
	s ymdesc =  $p(Instring,"^",3)
	s ymcount = $p(Instring,"^",4)
	s ymsite =  $p(Instring,"^",5)
	s ymdose =  $p(Instring,"^",6)
	s ymmf =  $p(Instring,"^",7)
	s ymltno =  $p(Instring,"^",8)
	s ymremark =  $p(Instring,"^",9)
	s ymseq =  $p(Instring,"^",10)
	s ymway =  $p(Instring,"^",11)
	s ymactive =  $p(Instring,"^",12)
	i ymactive="true" s ymactive="Y"
	e  s ymactive=""
	s NowHosp=%session.Get("LOGON.HOSPID")
	&sql(select Max(YMB_Sequence) into :MaxSeq from DHC_CRM_YiMiaoBase)
	i ymseq="99999" s ymseq=MaxSeq+10
	if (ymid="")
	{
		&sql(insert into DHC_CRM_YiMiaoBase values (:ymcode,:ymdesc,:ymcount,:ymsite,:ymdose,:ymmf,:ymltno,:ymremark,:ymseq,:ymway,:ymactive,:NowHosp))
	}
	else
	{
		&sql(update DHC_CRM_YiMiaoBase values (:ymcode,:ymdesc,:ymcount,:ymsite,:ymdose,:ymmf,:ymltno,:ymremark,:ymseq,:ymway,:ymactive,:NowHosp) where YMB_RowId=:ymid)
		
	}
	q SQLCODE
}

ClassMethod InsertYiMiaoBC(PatientID)
{
	
	s SQLCODE=0
	s ymseq=0
	s NowHosp=%session.Get("LOGON.HOSPID")
	f  s ymseq=$o(^User.DHCCRMYiMiaoBaseI("YMBSequenceIndex",ymseq)) q:ymseq=""  d
	.s ymid=0
	.f  s ymid=$o(^User.DHCCRMYiMiaoBaseI("YMBSequenceIndex",ymseq,ymid)) q:ymid=""  d
	..q:$d(^User.DHCCRMYiMiaoRecordI("YMPatientBidIndex",PatientID,ymid))
	..s ymcode=$lg(^User.DHCCRMYiMiaoBaseD(ymid),2)
	..s ymdesc=$lg(^User.DHCCRMYiMiaoBaseD(ymid),3)
	..s ymcount=$lg(^User.DHCCRMYiMiaoBaseD(ymid),4)
	..s ymsite=$lg(^User.DHCCRMYiMiaoBaseD(ymid),5)
	..s ymdose=$lg(^User.DHCCRMYiMiaoBaseD(ymid),6)
	..s ymmf=$lg(^User.DHCCRMYiMiaoBaseD(ymid),7)
	..s ymltno=$lg(^User.DHCCRMYiMiaoBaseD(ymid),8)
	..s ymremark=$lg(^User.DHCCRMYiMiaoBaseD(ymid),9)
	..s ymway=$lg(^User.DHCCRMYiMiaoBaseD(ymid),11)
	..s ymactive=$lg(^User.DHCCRMYiMiaoBaseD(ymid),12)
	..s ymhosp=$lg(^User.DHCCRMYiMiaoBaseD(ymid),13)
	..q:ymhosp'=NowHosp
	..q:ymactive'="Y"
	..f iLoop=1:1:ymcount  d
	...s ymseq=ymseq+1
	...&sql(insert into DHC_CRM_YiMiaoRecord values (:ymid,:ymcode,:ymdesc,:iLoop,null,null,:ymsite,:ymdose,:ymmf,:ymltno,null,:ymremark,null,:PatientID,:ymseq,null,null,:ymway,null))
	q SQLCODE
}

ClassMethod InsertYiMiao(PatientID)
{
	s NextMum=$o(^User.DHCCRMYiMiaoRecordI("YMPatientSeqIndex",PatientID,0))
	q:NextMum'="" "已有数据!"
	s NowHosp=%session.Get("LOGON.HOSPID")
	s SQLCODE=0
	s ymseq=0
	f  s ymseq=$o(^User.DHCCRMYiMiaoBaseI("YMBSequenceIndex",ymseq)) q:ymseq=""  d
	.s ymid=0
	.f  s ymid=$o(^User.DHCCRMYiMiaoBaseI("YMBSequenceIndex",ymseq,ymid)) q:ymid=""  d
	..s ymcode=$lg(^User.DHCCRMYiMiaoBaseD(ymid),2)
	..s ymdesc=$lg(^User.DHCCRMYiMiaoBaseD(ymid),3)
	..s ymcount=$lg(^User.DHCCRMYiMiaoBaseD(ymid),4)
	..s ymsite=$lg(^User.DHCCRMYiMiaoBaseD(ymid),5)
	..s ymdose=$lg(^User.DHCCRMYiMiaoBaseD(ymid),6)
	..s ymmf=$lg(^User.DHCCRMYiMiaoBaseD(ymid),7)
	..s ymltno=$lg(^User.DHCCRMYiMiaoBaseD(ymid),8)
	..s ymremark=$lg(^User.DHCCRMYiMiaoBaseD(ymid),9)
	..s ymway=$lg(^User.DHCCRMYiMiaoBaseD(ymid),11)
	..s ymactive=$lg(^User.DHCCRMYiMiaoBaseD(ymid),12)
	..s ymhosp=$lg(^User.DHCCRMYiMiaoBaseD(ymid),13)
	..q:ymhosp'=NowHosp
	..q:ymactive'="Y"
	..f iLoop=1:1:ymcount  d
	...s ymseq=ymseq+1
	...&sql(insert into DHC_CRM_YiMiaoRecord values (:ymid,:ymcode,:ymdesc,:iLoop,null,null,:ymsite,:ymdose,:ymmf,:ymltno,null,:ymremark,null,:PatientID,:ymseq,null,null,:ymway,null))
	q SQLCODE
}

/// d ##class(%ResultSet).RunQuery("web.DHCCRM.CRMYiMiao","SearchYiMiao",72957)
Query SearchYiMiao(PatientId) As %Query(ROWSPEC = "ymid:%String,ymbid:%String,ymcode:%String,ymdesc:%String,ymnum:%String,ymgdate:%String,ymisgiven:%String,ymsite:%String,ymdose:%String,ymmf:%String,ymltno:%String,ymuser:%String,ymremark,ymndate:%String,ymseq:%String,shuser:%String,ymstatus:%String,ymway:%String,ymguser:%String")
{
}

ClassMethod SearchYiMiaoExecute(ByRef qHandle As %Binary, PatientId) As %Status
{
   
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s ymseq=0
	f  s ymseq=$o(^User.DHCCRMYiMiaoRecordI("YMPatientSeqIndex",PatientId,ymseq)) q:ymseq=""  d
	.s ymid=0
	.f  s ymid=$o(^User.DHCCRMYiMiaoRecordI("YMPatientSeqIndex",PatientId,ymseq,ymid)) q:ymid=""  d
	..s ymbid=$lg(^User.DHCCRMYiMiaoRecordD(ymid),2)
	..s ymcode=$lg(^User.DHCCRMYiMiaoRecordD(ymid),3)
	..s ymdesc=$lg(^User.DHCCRMYiMiaoRecordD(ymid),4)
	..s ymnum=$lg(^User.DHCCRMYiMiaoRecordD(ymid),5)
	..s ymgdate=$lg(^User.DHCCRMYiMiaoRecordD(ymid),6)
	..s ymisgiven=$lg(^User.DHCCRMYiMiaoRecordD(ymid),7)
	..s ymsite=$lg(^User.DHCCRMYiMiaoRecordD(ymid),8)
	..s ymdose=$lg(^User.DHCCRMYiMiaoRecordD(ymid),9)
	..s ymmf=$lg(^User.DHCCRMYiMiaoRecordD(ymid),10)
	..s ymltno=$lg(^User.DHCCRMYiMiaoRecordD(ymid),11)
	..s ymuser=$lg(^User.DHCCRMYiMiaoRecordD(ymid),12)
	..s ymremark=$lg(^User.DHCCRMYiMiaoRecordD(ymid),13)
	..s ymndate=$lg(^User.DHCCRMYiMiaoRecordD(ymid),14)
	..s shuser=$lg(^User.DHCCRMYiMiaoRecordD(ymid),17)
	..s ymstatus=$lg(^User.DHCCRMYiMiaoRecordD(ymid),18)
	..s ymway=$lg(^User.DHCCRMYiMiaoRecordD(ymid),19)
	..s ymguser=$lg(^User.DHCCRMYiMiaoRecordD(ymid),20)
    ..d OutputRow
    
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow
	set Data=$lb(ymid,ymbid,ymcode,ymdesc,ymnum,ymgdate,ymisgiven,ymsite,ymdose,ymmf,ymltno,ymuser,ymremark,ymndate,ymseq,shuser,ymstatus,ymway,ymguser)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod SearchYiMiaoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchYiMiaoExecute ]
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

ClassMethod SearchYiMiaoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchYiMiaoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod UpdateList(ymid)
{
	i ymid="" q "{results:0,rows:[{}]}"
	s json=##class(dhc.ca.cache.comm.JsonObj).%New()
	s jsonTitle="User^Date^NextDate"
	s count=0

	s sub=""
	f  s sub=$o(^User.DHCCRMYiMiaoRecordD(ymid,"ChildDHCCRMYiMiaoTime",sub)) q:sub=""  d
	.s user=$lg(^User.DHCCRMYiMiaoRecordD(ymid,"ChildDHCCRMYiMiaoTime",sub),2)
	.s user=$p(^SSU("SSUSR",user),"^",2)
	.s date=$lg(^User.DHCCRMYiMiaoRecordD(ymid,"ChildDHCCRMYiMiaoTime",sub),3)
	.s date=$zd(date,3)
	.s nextdate=""
	.s nextdate=$lg(^User.DHCCRMYiMiaoRecordD(ymid,"ChildDHCCRMYiMiaoTime",sub),4)
	.i nextdate'="" s nextdate=$zd(nextdate,3)
	.s tmp=user_"^"_date_"^"_nextdate
	.d json.InsertRowData(tmp)
	.s count=count+1
	s jsonStr = json.getJsonData(jsonTitle,count)

 	k json
	q jsonStr
}

//w ##class(web.DHCCRM.CRMYiMiao).NextTimeList("2015-09-01","","","","")

ClassMethod NextTimeList(BeginDate, EndDate, PatName, start, limit)
{
	s start=$G(start)
	s limit=$G(limit)
	s rs=##class(%ResultSet).%New("web.DHCCRM.CRMYiMiao:SearchNextTime") 
	d rs.Execute(BeginDate,EndDate,PatName)
	
	s count=0
 	s mess=""
	s topnum=start+limit
 	while (rs.Next())
 	{
	 	s count=count+1
	 	i (start'="")&(limit'="") continue:(count<=start)!(count>topnum)
	 	s PapmiId=rs.Get("PapmiId")
	 	s mRegno=rs.Get("mRegno")
	 	s mrname=rs.Get("mrname")
	 	s mrgender=rs.Get("mrgender")
		s mrage=rs.Get("mrage")
	 	s mrcardid=rs.Get("mrcardid")
	 	s mrtel=rs.Get("mrtel")
	 	s mraddress=rs.Get("mraddress")
	 	s ymndate=$zd(rs.Get("ymndate"),3)
	 	s YMName=rs.Get("YMName")
	 	s ymid=rs.Get("ymid")
	 	s ymtid=rs.Get("ymtid")
	 	s country=rs.Get("country")
	 	s YMNameEng=rs.Get("YMNameEng")
	 	s Status=rs.Get("Status")
	 	i Status="S" s Status="已发送"
	 	s UpdateUser=rs.Get("UpdateUser")
	 	
	 	i UpdateUser'="" s UpdateUser=$p(^SSU("SSUSR",UpdateUser),"^",2)
	 	s UpdateDate=rs.Get("UpdateDate")
	 	i UpdateDate'="" s UpdateDate=$zd(UpdateDate,3)
		i (mess'="") s mess=mess_","
		s mess=mess_"{""PapmiId"":"_""""_PapmiId_""""
		s mess=mess_","_"""mRegno"":"_""""_mRegno_""""
		s mess=mess_","_"""mrname"":"_""""_mrname_""""
		s mess=mess_","_"""mrgender"":"_""""_mrgender_""""
		s mess=mess_","_"""mrage"":"_""""_mrage_""""
		s mess=mess_","_"""mrcardid"":"_""""_mrcardid_""""
		s mess=mess_","_"""mrtel"":"_""""_mrtel_""""
		s mess=mess_","_"""mraddress"":"_""""_mraddress_""""
		s mess=mess_","_"""ymndate"":"_""""_ymndate_""""
		s mess=mess_","_"""YMName"":"_""""_YMName_""""
		s mess=mess_","_"""ymid"":"_""""_ymid_""""
		s mess=mess_","_"""ymtid"":"_""""_ymtid_""""
		s mess=mess_","_"""country"":"_""""_country_""""
		s mess=mess_","_"""UpdateUser"":"_""""_UpdateUser_""""
		s mess=mess_","_"""UpdateDate"":"_""""_UpdateDate_""""
		s mess=mess_","_"""YMNameEng"":"_""""_YMNameEng_""""
		s mess=mess_","_"""Status"":"_""""_Status_""""
		s mess=mess_"}"
	}	 	 
 s mess="["_mess_"]"
 s mess="{""results"":"_""""_count_""""_","_"""rows"""_":"_mess_"}"
 q mess
}

Query SearchNextTime(BeginDate, EndDate, PatName) As %Query(ROWSPEC = "PapmiId:%String,mRegno:%String,mrname:%String,mrgender:%String,mrage:%String,mrcardid:%String,mrtel:%String,mraddress:%String,ymndate:%String,YMName:%String,ymid:%String,UpdateUser,UpdateDate,ymtid,country,YMNameEng,Status")
{
}

ClassMethod SearchNextTimeExecute(ByRef qHandle As %Binary, BeginDate, EndDate, PatName) As %Status
{
   
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	//s PatName=##class(web.DHCPE.DHCPECommon).UnEscape(PatName)
	i BeginDate="" s BeginDate=$h+1
	else  s BeginDate=$Zdh(BeginDate,3)
	i EndDate="" s EndDate=$h+1
	else  s EndDate=$Zdh(EndDate,3)
	
	f date=BeginDate:1:EndDate d
	.s ymid=0
	.f  s ymid=$o(^User.DHCCRMYiMiaoRecordI("YMNextDateIndex",date,ymid)) q:ymid=""  d
	..s PapmiId=$lg(^User.DHCCRMYiMiaoRecordD(ymid),15)
	..s YMName=$lg(^User.DHCCRMYiMiaoRecordD(ymid),4)
	..s YMNameEng=$lg(^User.DHCCRMYiMiaoRecordD(ymid),3)
	..s mRegno=$p($g(^PAPER(PapmiId,"PAT",1)),"^",1)
    ..s mrname=$p($g(^PAPER(PapmiId,"ALL")),"^",1)
    ..s mrgender=$p($g(^CT("SEX",$p($g(^PAPER(PapmiId,"ALL")),"^",7))),"^",2)
    ..s mrcardid=$p(^PAPER(PapmiId,"ALL"),"^",9)
    ..s mraddress=$g(^PAPER(PapmiId,"PER","ADD"))
	..s mrtel=$p($g(^PAPER(PapmiId,"PER",4)),"^",21)
	..s hometel=$p($g(^PAPER(PapmiId,"PER",1)),"^",11)
    ..s worktel=$p($g(^PAPER(PapmiId,"PER",1)),"^",9)
    ..s mrtel=mrtel //_"/"_hometel_"/"_worktel
    ..s country=$p($g(^PAPER(PapmiId,"PER",1)),"^",8)
	..s Birth=$p($g(^PAPER(PapmiId,"ALL")),"^",6)
	..s mrage=##class(web.DHCLCNUREXCUTE).CalAge(Birth,+$h)
	..s mrage=$P(mrage,"Y",1)_"岁" 
	..s:(mrage="0岁") mrage=##class(web.DHCBillInterface).GetPapmiAge(PapmiId,"",$ZD(+$H,3),$Zt($p($H,",",2)))
	..s Birth=$zd(Birth,3)
	..s ymndate=$lg(^User.DHCCRMYiMiaoRecordD(ymid),14)
	..q:(PatName'="")&&(mrname'[PatName)
	..s UpdateUser="",UpdateDate="",ymtid="",Status=""
	..s sub=$o(^User.DHCCRMYiMiaoRecordD(ymid,"ChildDHCCRMYiMiaoTime",""),-1)
	..i sub'="" d
	...s UpdateUser=$lg(^User.DHCCRMYiMiaoRecordD(ymid,"ChildDHCCRMYiMiaoTime",sub),2)
	...s UpdateDate=$lg(^User.DHCCRMYiMiaoRecordD(ymid,"ChildDHCCRMYiMiaoTime",sub),3)
	...s ymtid=ymid_"||"_sub
	...i $d(^User.DHCPENewSendMessageI("TypeSourceIndex","YIMIAO"," "_ymtid)) s Status="S"

	..d OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow
	set Data=$lb(PapmiId,mRegno,mrname,mrgender,mrage,mrcardid,mrtel,mraddress,ymndate,YMName,ymid,UpdateUser,UpdateDate,ymtid,country,YMNameEng,Status)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod SearchNextTimeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchNextTimeExecute ]
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

ClassMethod SearchNextTimeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchNextTimeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query SearchSiteInfo(Bid As %String = "") As %Query(ROWSPEC = "site:%String")
{
}

ClassMethod SearchSiteInfoExecute(ByRef qHandle As %Binary, Bid) As %Status
{
   
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	if (Bid="")
	{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
		
	}
	
	s ymsite=$lg(^User.DHCCRMYiMiaoBaseD(Bid),5)
	s length=$l(ymsite,"$")
	f i=1:1:length  d
	.s site=$p(ymsite,"$",i)
	.d OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow
	set Data=$lb(site)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod SearchSiteInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchSiteInfoExecute ]
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

ClassMethod SearchSiteInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchSiteInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
