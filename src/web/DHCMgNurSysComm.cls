Import SQLUser

Class web.DHCMgNurSysComm Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod FindWardPatType(wardid As %String) As %String
{
	;s ^TEMP("g20141212114001")=wardid
	//d ##Class(web.DHCMgNurSysComm).FindWardPatType(792)
	s getwardid=$o(^PAWARD(0,"WARD_LocationDR",wardid,""))
	q:getwardid=""
	s num=0,ret=""
    s roomdr=""
    f  s roomdr=$o(^PAADMi("CurrWard",getwardid,roomdr)) q:roomdr=""  d
     .s admId=""      
     .f  s admId=$o(^PAADMi("CurrWard",getwardid,roomdr,admId)) q:admId=""  d
     ..q:'$d(^PAADM(admId))     
     ..s visitstatus=$p(^PAADM(admId),"^",20)
     ..q:visitstatus=""
     ..q:visitstatus="C"
     ..s bedrowid=$p(^PAADM(admId),"^",73)
     ..q:bedrowid=""
     ..s num=num+1
     b
     s bwnum=0,opnum=0
     //病危
     ; s Adm=""  f  s Adm=$O(^Nur.DHCMGCurrDayAttenPatI("WardCurr"," "_wardid,+$H," 68",Adm)) q:Adm=""  d
      ;.s bwnum=bwnum+1
     //手术
    ; s Adm=""  f  s Adm=$O(^Nur.DHCMGCurrDayAttenPatI("WardCurr"," "_wardid,+$H," 69",Adm)) q:Adm=""  d
    ; .s opnum=opnum+1
	   s i=0
   s OEORDType=$g(OEORDType)
   Set now = +$Horolog 
   s OeordStat=""
   s OEORDRowId=""
	
   /*	
   s Date=""
   s Date=now
   f  s OEORDRowId=$o(^OEORDi(0,"StDt",Date,OEORDRowId)) q:OEORDRowId=""  d
   .s OEORIChildsub=0 
   .f  s OEORIChildsub=$o(^OEORDi(0,"StDt",Date,OEORDRowId,OEORIChildsub))  q:OEORIChildsub=""  d
   ..s (PAPMIIPNo,paname,DepDesc,WardDesc,PaadmCurrentBedDesc,PAADMAdmDocDesc,PAADMCurrentRoomDesc)=""
   ..s OEORIItmMastDR=$p(^OEORD(OEORDRowId,"I",OEORIChildsub,1),"^",2)
   ..q:(OEORIItmMastDR'="23084||1")&&(OEORIItmMastDR'="32876||1")
   ..;b ;000
   ..s OeordStat=$p(^OEORD(OEORDRowId,"I",OEORIChildsub,1),"^",13)
   ..q:OeordStat="4"
   ..&SQL(select OEORI_SttDat into :TOrderStartDate from OE_OrdItem where OEORI_OEORD_ParRef=:OEORDRowId and OEORI_ItmMast_DR=:OEORIItmMastDR order by OEORI_SttDat ASC)
   ..s adm=$p(^OEORD(OEORDRowId),"^",1)  
   ..s paadmtype=$p(^PAADM(adm),"^",2)
   ..i (paadmtype="I") d
   ...s PAADMCurrentWardDR=$p(^PAADM(adm),"^",70)
   ...s WardID=$p(^PAWARD(PAADMCurrentWardDR),"^",5)
   ..q:(WardID'=wardid)
   ..i (OEORIItmMastDR'="23084||1") s bwnum=bwnum+1
   ..i (OEORIItmMastDR'="32876||1") s opnum=opnum+1
   */
    
   s Date=""
   s Date=now
   f  s OEORDRowId=$o(^OEORDi(0,"StDt",Date,OEORDRowId)) q:OEORDRowId=""  d
   .s OEORIChildsub=0 
   .f  s OEORIChildsub=$o(^OEORDi(0,"StDt",Date,OEORDRowId,OEORIChildsub))  q:OEORIChildsub=""  d
   ..s (PAPMIIPNo,paname,DepDesc,WardDesc,PaadmCurrentBedDesc,PAADMAdmDocDesc,PAADMCurrentRoomDesc)=""
   ..s OEORIItmMastDR=$p(^OEORD(OEORDRowId,"I",OEORIChildsub,1),"^",2)
   ..q:(OEORIItmMastDR'="23084||1")
   ..;b ;000
   ..s OeordStat=$p(^OEORD(OEORDRowId,"I",OEORIChildsub,1),"^",13)
   ..q:OeordStat="4"
   ..&SQL(select OEORI_SttDat into :TOrderStartDate from OE_OrdItem where OEORI_OEORD_ParRef=:OEORDRowId and OEORI_ItmMast_DR=:OEORIItmMastDR order by OEORI_SttDat ASC)
   ..s adm=$p(^OEORD(OEORDRowId),"^",1)  
   ..s paadmtype=$p(^PAADM(adm),"^",2)
   ..i (paadmtype="I") d
   ...s PAADMCurrentWardDR=$p(^PAADM(adm),"^",70)
   ...s WardID=$p(^PAWARD(PAADMCurrentWardDR),"^",5)
   ..q:(WardID'=wardid)
   ..i (OEORIItmMastDR="23084||1") s bwnum=bwnum+1
   
   s Date=""
   s Date=now-1
   //for Date=now-1:1:now
   //{
   f  s OEORDRowId=$o(^OEORDi(0,"StDt",Date,OEORDRowId)) q:OEORDRowId=""  d
   .s OEORIChildsub=0 
   .f  s OEORIChildsub=$o(^OEORDi(0,"StDt",Date,OEORDRowId,OEORIChildsub))  q:OEORIChildsub=""  d
   ..s (PAPMIIPNo,paname,DepDesc,WardDesc,PaadmCurrentBedDesc,PAADMAdmDocDesc,PAADMCurrentRoomDesc)=""
   ..s OEORIItmMastDR=$p(^OEORD(OEORDRowId,"I",OEORIChildsub,1),"^",2)
   ..q:(OEORIItmMastDR'="32877||1")
   ..;b ;000
   ..s OeordStat=$p(^OEORD(OEORDRowId,"I",OEORIChildsub,1),"^",13)
   ..q:OeordStat="4"
   ..&SQL(select OEORI_SttDat into :TOrderStartDate from OE_OrdItem where OEORI_OEORD_ParRef=:OEORDRowId and OEORI_ItmMast_DR=:OEORIItmMastDR order by OEORI_SttDat ASC)
   ..s adm=$p(^OEORD(OEORDRowId),"^",1)  
   ..s paadmtype=$p(^PAADM(adm),"^",2)
   ..i (paadmtype="I") d
   ...s PAADMCurrentWardDR=$p(^PAADM(adm),"^",70)
   ...s WardID=$p(^PAWARD(PAADMCurrentWardDR),"^",5)
   ..q:(WardID'=wardid)
   ..i (OEORIItmMastDR="32877||1") s opnum=opnum+1
   
   
   s Date=""
   s Date=now
   f  s OEORDRowId=$o(^OEORDi(0,"StDt",Date,OEORDRowId)) q:OEORDRowId=""  d
   .s OEORIChildsub=0 
   .f  s OEORIChildsub=$o(^OEORDi(0,"StDt",Date,OEORDRowId,OEORIChildsub))  q:OEORIChildsub=""  d
   ..s (PAPMIIPNo,paname,DepDesc,WardDesc,PaadmCurrentBedDesc,PAADMAdmDocDesc,PAADMCurrentRoomDesc)=""
   ..s OEORIItmMastDR=$p(^OEORD(OEORDRowId,"I",OEORIChildsub,1),"^",2)
   ..q:(OEORIItmMastDR'="32876||1")
   ..;b ;000
   ..s OeordStat=$p(^OEORD(OEORDRowId,"I",OEORIChildsub,1),"^",13)
   ..q:OeordStat="4"
   ..&SQL(select OEORI_SttDat into :TOrderStartDate from OE_OrdItem where OEORI_OEORD_ParRef=:OEORDRowId and OEORI_ItmMast_DR=:OEORIItmMastDR order by OEORI_SttDat ASC)
   ..s adm=$p(^OEORD(OEORDRowId),"^",1)  
   ..s paadmtype=$p(^PAADM(adm),"^",2)
   ..i (paadmtype="I") d
   ...s PAADMCurrentWardDR=$p(^PAADM(adm),"^",70)
   ...s WardID=$p(^PAWARD(PAADMCurrentWardDR),"^",5)
   ..q:(WardID'=wardid)
   ..i (OEORIItmMastDR="32876||1") s opnum=opnum+1
   
   s ret=num_"^"_bwnum_"^"_opnum
   q ret
}

ClassMethod getsuser(recuserId) As %String
{
  q:recuserId="" ""
  s User=$p($g(^SSU("SSUSR",recuserId)),"^",2)
  q recuserId_"!"_User
}

ClassMethod SendMessage(par) As %String
{
	/*
		 s ret=##class(DHCMGNUR.QuCheckWard).getVal1(par)
   	//ret="CheckDate|2013-06-29^CheckEndTime|16:19^CheckRoom|夜查房^CheckSTime|16:19
   	//^CheckUsers|白璐;程恩荷;^Wards|ZHWKBQ-保18F综合外科病区;^"
   	//w ##Class(web.DHCMgNurSysComm).SendMessage(36)
		s CheckDate=$p(ret,"^",1)
		s CheckEndTime=$p(ret,"^",2)
		s CheckRoom=$p(ret,"^",3)
		s CheckSTime=$p(ret,"^",4)
		 s CheckUsers=$p(ret,"^",7)
		s Wards=$p(ret,"^",11)
		s ward=$p($p(Wards,"|",2),";",1)
		*/
	s a=##class(DHCMGNUR.QuCheckWard).%OpenId(par)
	s CheckDate=$zd(a.CheckDate,3)
	s CheckEndTime=a.CheckEndTime
	s aa("DayChk")="随机督查"
	s aa("NightChk")="夜查房"
	s CheckRoom=$g(aa(a.CheckTyp))
	s CheckSTime=a.CheckSTime
	s l=a.CheckUsers.Count()
	s userstr=""
	for i=1:1:l
	{
		s rw=a.CheckUsers.GetAt(i)
		s des=$P(..getsuser(rw),"!",2)
		s userstr=userstr_des_";"
	} 
	s CheckUsers=userstr
	s ward=""
	s l=a.Wards.Count()
	for i=1:1:l
	{
		s rw=a.Wards.GetAt(i)
		s des=$p($p(^CTLOC(rw),"^",2),"-",2)	    
		s ward=ward_des_";"
	}
	s Wards=ward
	;s ward=$p($p(Wards,"|",2),";",1)

   //s content="您于"_$p(CheckDate,"|",2)_$p(CheckRoom,"|",2)_":时间段"_$p(CheckSTime,"|",2)_"-"_$p(CheckEndTime,"|",2)_";检查人员为:"_$p(CheckUsers,"|",2)_"需检查病区为:"_$p(Wards,"|",2)_",收到后请回复黄主任(18963789080)或护理部,"_"祝工作愉快!"
    s content="您于"_CheckDate_CheckRoom_":时间段"_CheckSTime_"-"_CheckEndTime_";检查人员为:"_CheckUsers_"需检查病区为:"_Wards_",收到后请回复黄主任(18963789080)或护理部,"_"祝工作愉快!" 
    //s CheckUsers=$p(CheckUsers,"|",2)
    for i=1:1:$L(CheckUsers,";")
   	{
	   	s tmpuser(i)=$P(CheckUsers,";",i)
	   	s usercode="" f  s usercode=$o(^DHCNURTSYHZ("TSYHZ",usercode)) q:usercode=""  d
	   	.s usercoded=$p(^DHCNURTSYHZ("TSYHZ",usercode),"^",1)
	   	.;b ;01
	   	.q:usercoded'=tmpuser(i)
	   	.;q:usercoded'=tmpuser(i) tmpphone(i)=
	   	.s tmpphone(i)=$p(^DHCNURTSYHZ("TSYHZ",usercode),"^",2)
	   	;i $g(tmpphone(i))="" s tmpphone(i)=""
	}
	b ;02
	s id="" f  s id=$o(tmpphone(id)) q:id=""  d
	.;i tmpphone(i)=  s ss=##class(web.DHCConsultInterfaceMethods).DHCConsultSendHZInfo(tmpphone(id),content1)  content1=tmpuser(i)
	.s ss=##class(web.DHCConsultInterfaceMethods).DHCConsultSendHZInfo(tmpphone(id),content)
    .;q:ss
}

ClassMethod CheckRoomListExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//补贴调节记录
 	s ^TMP("qq")=parr //2016-06-01^2016-06-30^^69^0^Z
    s stdate=$P(parr,"^",1)
    s edate=$P(parr,"^",2)
    s typ=$P(parr,"^",3)
    s userid=$P(parr,"^",4)
    s flag=$P(parr,"^",5)
    s stdate=$ZDH(stdate,3)
    s edate=$ZDH(edate,3)
    s limittyp=$P(parr,"^",6)
    s secgrp=$P(parr,"^",7)
 	f date=stdate:1:edate
 	{
	 	s p=""
	  	f { 
	    	s p=$O(^DHCMGNUR.QuCheckWardI("CheckDate",date,p))
	     	q:p=""
	     	s a=##class(DHCMGNUR.QuCheckWard).%OpenId(p)
	     	if a.CheckTyp="SelfDayChk" continue
	     	if (typ'=a.CheckTyp)&&(typ'="") continue
	     	;i ((limittyp'="")&&(a.CheckLevel'=limittyp)) continue
	     	s ret=##class(DHCMGNUR.QuCheckWard).getVal(p)
	     	s l=a.CheckUsers.Count()
	     	s userstr=""
	     	for i=1:1:l
	     	{
		    	s rw=a.CheckUsers.GetAt(i)
		  	 	s userstr=userstr_rw_";"
		 	} 
	     	q:(userstr'[userid)&&(flag=1)
	     	q:((userstr'[userid)&&(secgrp="nurhead"!secgrp="znurhead"))
	     	
	     	s ret=ret_"^row|"_p
	     	d OutRowtyp
	   }
	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod CheckRoomListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CheckRoomListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod CheckRoomListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CheckRoomListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

Query CheckRoomList(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod SelfCheckRoomListExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//补贴调节记录
 	s ^TMP("qq")=parr
    //s parr="2013-04-01^2013-06-20"
   // s parr=^TMP("parr")
 	//Set qHandle=$lb(0,repid,0) Quit $$$OK
 	//
    s stdate=$P(parr,"^",1)
    s edate=$P(parr,"^",2)
    s typ=$P(parr,"^",3)
    s stdate=$ZDH(stdate,3)
    s edate=$ZDH(edate,3)
    
 	f date=stdate:1:edate
 	{
	  s p=""
	  f { 
	     s p=$O(^DHCMGNUR.QuCheckWardI("CheckDate",date,p))
	     q:p=""
	     
	     s a=##class(DHCMGNUR.QuCheckWard).%OpenId(p)
	     if a.CheckTyp'="SelfDayChk" continue
	     if (typ'=a.CheckTyp)&&(typ'="") continue
	     s ret=##class(DHCMGNUR.QuCheckWard).getVal(p)
	     s ret=ret_"^rw|"_p
	     d OutRowtyp

	   }
	}

    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod SelfCheckRoomListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelfCheckRoomListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SelfCheckRoomListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelfCheckRoomListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

Query SelfCheckRoomList(parr As %String) As %Query(ROWSPEC = "aa")
{
}

/// ctlocDesc,CtLocDr
Query FindWardLoc(HsDr, typ, ward = "", Par = "") As %Query(ROWSPEC = "LocDes,LocDr,SortPos")
{
}

ClassMethod FindWardLocExecute(ByRef qHandle As %Binary, HsDr, typ, ward = "", Par = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	//s ^TMP("a")=$LB(HsDr,typ)
 	//d ##Class(%ResultSet).RunQuery("web.DHCMgNurSysComm","FindWardLoc",1,"","pw","")
 	s ^mw1233("WardLoc")=HsDr_"^"_typ_"^"_ward_"^"_Par
 	s typ=$TR($ZConvert(typ,"U")," ","")
 	s ward=$TR($ZConvert(ward,"U")," ","")
 	;i typ="N" s typ=""
    s tmp=""
    if Par'=""
    {
	   s rw=""  f  s rw=$O(^DHCMGNUR.MgNurseD(Par,"ChildSub",rw)) q:rw=""  d
	   .s a=##class(DHCMGNUR.MgNurseSub).%OpenId(Par_"||"_rw)
	   .s CtLocDr=a.WardLoc
	   .s ctlocDesc=$p(^CTLOC(CtLocDr),"^",2)
	   .q:(ctlocDesc'[ward)&&(ward'="")
	   .s p=rw
	   .d OutputRow8
      Set qHandle=$lb(0,repid,0)
	  Quit $$$OK
	 }
     if (typ="")
     {
         s ty="" f  s ty=$O(^DHCMGNUR.MgNurWardI("Typ",HsDr,ty)) q:ty=""  d
         .s loc="" f  s loc=$O(^DHCMGNUR.MgNurWardI("Typ",HsDr,ty,loc)) q:loc=""  d
       	 ..s rw="" f  s rw=$O(^DHCMGNUR.MgNurWardI("Typ",HsDr,ty,loc,rw)) q:rw=""  d
         ...s a=##class(DHCMGNUR.MgNurWard).%OpenId(rw)
         ...s CtLocDr=a.WardLoc  
         ...s p=a.SortPos
         ...s ctlocDesc=$p(^CTLOC(CtLocDr),"^",2)
         ...q:(ctlocDesc'[ward)&&(ward'="")
         ...;b ;001
         ...d OutputRow8

	 }else{
		 s CtLocDr="" f  s CtLocDr=$O(^DHCMGNUR.MgNurWardI("Typ",HsDr," "_typ,CtLocDr)) q:CtLocDr=""  d
		 .s rw="" f  s rw=$O(^DHCMGNUR.MgNurWardI("Typ",HsDr," "_typ,CtLocDr,rw)) q:rw=""  d
	 	 ..s a=##class(DHCMGNUR.MgNurWard).%OpenId(rw)
	 	 ..s sort=a.SortPos
	 	 ..s ctlocDesc=$p(^CTLOC(CtLocDr),"^",2)
	 	 ..q:(ctlocDesc'[ward)&&(ward'="")
	 	 ..;b ;01
	 	 ..if '$D(tmp(sort)) s tmp(sort)=ctlocDesc_"^"_CtLocDr
	 	 ..e  s tmp(sort+1)=ctlocDesc_"^"_CtLocDr
	 	 s p=""   f  s p=$O(tmp(p)) q:p=""  d
	 	 .s ctlocDesc=$P(tmp(p),"^"),CtLocDr=$P(tmp(p),"^",2)
	 	 .d OutputRow8
	 }
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(ctlocDesc,CtLocDr,p)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindWardLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWardLocExecute ]
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

ClassMethod FindWardLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWardLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindWardItem() As %Query(ROWSPEC = "LocDes,LocDr")
{
}

ClassMethod FindWardItemExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s CtLocDr="" f  s CtLocDr=$o(^CTLOC(CtLocDr)) q:CtLocDr=""  d
 	.s ctlocDesc=$p(^CTLOC(CtLocDr),"^",2)
 	.d OutputRow8
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(ctlocDesc,CtLocDr)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindWardItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWardItemExecute ]
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

ClassMethod FindWardItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWardItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod getmouldext(ssgrp = "") As %String
{
	
 //w ##class(web.DHCMgNurSysComm).getmouldext()
   	s ret=""
   	if ssgrp'=""
   	{
	   	s maxorder=1000
		s mouldid="" f  s mouldid=$O(^DHCMGNUR.GSSGRPLAYOUTI("ssgrp"," "_ssgrp,mouldid)) q:mouldid=""  d
   		.s a=##class(DHCMGNUR.Mould).%OpenId($TR(mouldid," ",""))
		.s order=a.MSort
		.i order="" s order=maxorder,maxorder=maxorder-1
		.s temp(order)=a
		s ord="" f  s ord=$O(temp(ord)) q:ord=""  d
		.s b=temp(ord)
		.s mouldname=b.MouldName
    	.s mouldcode=b.Code
    	.q:mouldcode=""
    	.s ico=b.Icon
    	.if ret'="" s ret=ret_","
    	.s ret=ret_"{iconCls:'"_ico_"',title:'"_mouldname_"',html:'<div id="""_mouldcode_""" autoScroll:true></div>'}"
   		s ret="["_ret_"]"
  	}else{
	  	;b
   		s rw=""  f  s rw=$O(^DHCMGNUR.MenuSystemI("Product",rw)) q:rw=""  d
   		.s a= ##class(DHCMGNUR.Mould).%OpenId(rw)
   		.;b
   		.q:a=""
   		.;b
   		.s mouldname=a.MouldName
   		.s mouldcode=a.Code
   		.q:mouldcode=""
   		.s ico=a.Icon
   		.if ret'="" s ret=ret_","
   		.s ret=ret_"{iconCls:'"_ico_"',title:'"_mouldname_"',html:'<div id="""_mouldcode_""" autoScroll:true></div>'}"
   		s ret="["_ret_"]"
  	}
  	s ^gyongao=ret
   	q ret
}

ClassMethod GetMouldExecute(ByRef qHandle As %Binary, sid As %String, mouldname) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	;if WardId="" Quit $$$OK
 	s ^TMP("88bb")="ss"
 	s id="" f  s id=$O(^DHCMGNUR.MouldD(id)) q:id=""  d
 	.s a=##class(DHCMGNUR.Mould).%OpenId(id)
	.s rw=id
	.q:(mouldname'=a.MouldName)&(mouldname'="")
	.q:((rw'=sid)&(sid'=""))
	.s ret=""
	.s ret=##class(DHCMGNUR.Mould).getVal(rw)
	.s ret=ret_"^rw|"_id
	.d outtyp2
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
outtyp2
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetMouldFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMouldExecute ]
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

Query GetMould(sid As %String, mouldname = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod GetMouldClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMouldExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query GetMenus(mouldid As %String, mouldname As %String, menu As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod GetMenusExecute(ByRef qHandle As %Binary, mouldid As %String, mouldname As %String, menu As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ^TEMP("g20141208182101")=mouldid_"^"_mouldname_"^"_menu
 	s ind=1
 	;if WardId="" Quit $$$OK
 	s id="" f  s id=$O(^DHCMGNUR.MenuSystemD(id)) q:id=""  d
 	.s a=##class(DHCMGNUR.MenuSystem).%OpenId(id)
 	.q:a.NurProduct=""
 	.q:(mouldname'=a.NurProduct.MouldName)&(mouldname'="")
	.s rw=id
	.q:((menu'=a.MenuTitle)&(menu'=""))
	.q:((mouldid'=a.NurProduct.%Id())&(mouldid'=""))
	.s ret=""
	.;s ret=##class(DHCMGNUR.MenuSystem).getVal(rw)
	.i rw'="" d
	..s obj=##class(DHCMGNUR.MenuSystem).%OpenId(rw)
	..s tdata="",tmp=""
	..s p="" f  s p=$O(^oddCOM("DHCMGNUR.MenuSystem","a",p)) q:p=""  d
	...q:p["%"
	...s tmp(p)=$ZOBJPROPERTY(obj,p)
	...if ((p="NurProduct")&(tmp(p)'="")) d
	....s tmp(p)=obj.NurProduct.MouldName
	...if ((p="ParentMenuNod")&(tmp(p)'="")) d
	....s b=##class(DHCMGNUR.MenuSystem).%OpenId(tmp(p))
	....s tmp(p)=b.MenuTitle
	..s k="" f  s k=$O(tmp(k)) q:k=""  d
	...s ret=ret_k_"|"_tmp(k)_"^"
	.s ret=ret_"^rw|"_id
	.d outtyp2
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
outtyp2
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetMenusFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMenusExecute ]
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

ClassMethod GetMenusClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMenusExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetMenuItemExecute(ByRef qHandle As %Binary, Par As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	;if WardId="" Quit $$$OK
 	
 	s id="" f  s id=$O(^DHCMGNUR.MenuSystemSubD(Par,id)) q:id=""  d
 	.//s a=##class(DHCMGNUR.MenuSystemSub).%OpenId()
	.s ret=##class(DHCMGNUR.MenuSystemSub).getVal(Par_"||"_id)
	.s ret=ret_"^rw|"_id_"^Par|"_Par
	.d outtyp2
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
outtyp2
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetMenuItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMenuItemExecute ]
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

Query GetMenuItem(Par As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod GetMenuItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMenuItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetCommDicExecute(ByRef qHandle As %Binary, sid As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	;if WardId="" Quit $$$OK
 	s ^TMP("bb")=sid
 	s id="" f  s id=$O(^DHCMGNUR.CommDictionaryD(id)) q:id=""  d
 	.s a=##class(DHCMGNUR.CommDictionary).%OpenId(id)
	.s rw=id
	.s MouldCode=a.MouldCode
	.q:(sid'="")&(MouldCode'=sid)
	.;q:((rw'=sid)&(sid'=""))
	.s ret=""
	.s ret=##class(DHCMGNUR.CommDictionary).getVal(rw)
	.s ret=ret_"^rw|"_id
	.d outtyp2
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
outtyp2
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetCommDicFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCommDicExecute ]
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

Query GetCommDic(sid As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod GetCommDicClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCommDicExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetCodeItemExecute(ByRef qHandle As %Binary, Par As %String, Code As %String, Desc As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	;if WardId="" Quit $$$OK
 	s ^TMP("desc")=Desc
 	if (Code'="" ) s Par=##class(DHCMGNUR.CommDictionary).getcodepar(Code)
 	s id="" f  s id=$O(^DHCMGNUR.CommDictionarySubD(Par,id)) q:id=""  d
 	.s a=##class(DHCMGNUR.CommDictionarySub).%OpenId(Par_"||"_id)
 	.q:((Desc'="")&(Desc'=a.CodeDesc))
	.s ret=##class(DHCMGNUR.CommDictionarySub).getVal(Par_"||"_id)
	.s ret=ret_"^rw|"_id_"^Par|"_Par_"^RwId|"_Par_"_"_id
	.d outtyp2
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
outtyp2
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetCodeItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCodeItemExecute ]
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

Query GetCodeItem(Par As %String = "", Code As %String = "", Desc As %String = "") As %Query(ROWSPEC = "aa")
{
}

/*
ClassMethod GetQualItemSubExecute(ByRef qHandle As %Binary, Par) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	;if WardId="" Quit $$$OK

 	s id="" f  s id=$O(^DHCMGNUR.QualCodeItemSubD(Par,id)) q:id=""  d
 	.s a=##class(DHCMGNUR.QualCodeItemSub).%OpenId(Par_"||"_id)
	.//s ret=##class(DHCMGNUR.QualCodeItemSub).getVal(Par_"||"_id)
	.s code=a.ItemCode
	.s level=a.ItemLevel
	.s ItemDesc=a.ItemDesc
	.s itmvalue=a.ItemValue
	.//s itmmem=a.ItemMem
	.i level="" s level=code
	.s I=$INUMBER($P(code,"."),"T"),II=$P(code,".",2),III=$P(code,".",3)
	.if II="" s TMI(I)=Par_"||"_id //
	.if (II'="")&(III="") d
	..s II=$INUMBER(II,"T")
	..s TMII(I,II)=Par_"||"_id
	.if (III'="") d
	..s III=$INUMBER(III,"T")
	..s TMIII(I,II,III)=Par_"||"_id
	.//s ret=ret_"^rw|"_id_"^Par|"_Par
	.//d outtyp2
	.//
	s r="" f  s r=$O(TMI(r)) q:r=""  d
	.s ret=##class(DHCMGNUR.QualCodeItemSub).getVal(TMI(r))
	.s Par=$P(TMI(r),"||",1),rw=$P(TMI(r),"||",2)
	.s ret=ret_"^rw|"_rw_"^Par|"_Par
	.d outtyp2
	.s p="" f  s p=$O(TMII(r,p)) q:p=""  d
	..s Par=$P(TMII(r,p),"||",1),rw=$P(TMII(r,p),"||",2)
	..s ret=##class(DHCMGNUR.QualCodeItemSub).getVal(TMII(r,p))
	..s ret=ret_"^rw|"_rw_"^Par|"_Par
	..d outtyp2
	..s w=""  f  s w=$O(TMIII(r,p,w)) q:w=""  d
	...s Par=$P(TMIII(r,p,w),"||",1),rw=$P(TMIII(r,p,w),"||",2)
	...s ret=##class(DHCMGNUR.QualCodeItemSub).getVal(TMIII(r,p,w))
	...s ret=ret_"^rw|"_rw_"^Par|"_Par
	...d outtyp2
 	

    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
outtyp2
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}
*/
ClassMethod GetQualItemSubExecute(ByRef qHandle As %Binary, Par) As %Status
{
	
	//b 1
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	
 	//b dsf
 	;if WardId="" Quit $$$OK
     //s ^SZ=par
 	s id="" f  s id=$O(^DHCMGNUR.QualCodeItemSubD(Par,id)) q:id=""  d
 	.s a=##class(DHCMGNUR.QualCodeItemSub).%OpenId(Par_"||"_id)
	.//s ret=##class(DHCMGNUR.QualCodeItemSub).getVal(Par_"||"_id)
	.s code=a.ItemCode
	.s level=a.ItemLevel
	.s ItemDesc=a.ItemDesc
	.s itmvalue=a.ItemValue
	.//.s QualWeight=a.QualWeight
	.//s itmmem=a.ItemMem
	.i level="" s level=code
	.s I=$INUMBER($P(code,"."),"T"),II=$P(code,".",2),III=$P(code,".",3)
	.if II="" s TMI(I)=Par_"||"_id //
	.if (II'="")&(III="") d
	..s II=$INUMBER(II,"T")
	..s TMII(I,II)=Par_"||"_id
	.if (III'="") d
	..s III=$INUMBER(III,"T")
	..s TMIII(I,II,III)=Par_"||"_id
	.//s ret=ret_"^rw|"_id_"^Par|"_Par
	.//d outtyp2
	.//

	s r="" f  s r=$O(TMI(r)) q:r=""  d
	.s ret=##class(DHCMGNUR.QualCodeItemSub).getVal(TMI(r))
	.s Par=$P(TMI(r),"||",1),rw=$P(TMI(r),"||",2)
	.s ret=ret_"^rw|"_rw_"^Par|"_Par 
	.d outtyp2
	.s p="" f  s p=$O(TMII(r,p)) q:p=""  d
	..s Par=$P(TMII(r,p),"||",1),rw=$P(TMII(r,p),"||",2)
	..s ret=##class(DHCMGNUR.QualCodeItemSub).getVal(TMII(r,p))
	..s ret=ret_"^rw|"_rw_"^Par|"_Par 
	..d outtyp2
	..s w=""  f  s w=$O(TMIII(r,p,w)) q:w=""  d
	...s Par=$P(TMIII(r,p,w),"||",1),rw=$P(TMIII(r,p,w),"||",2)
	...s ret=##class(DHCMGNUR.QualCodeItemSub).getVal(TMIII(r,p,w))
	...s ret=ret_"^rw|"_rw_"^Par|"_Par
	...d outtyp2
 	

    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
outtyp2
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetQualItemSubFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetQualItemSubExecute ]
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

Query GetQualItemSub(Par As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod getsortno(r, tm) As %String
{
	s r1=$O(tm(r,""),-1)+1
	q r1
}

ClassMethod GetQualCodeOldExecute(ByRef qHandle As %Binary, sid As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	;if WardId="" Quit $$$OK
 	//D ##class(%ResultSet).RunQuery("web.DHCMgNurSysComm","GetQualCode","QualCheck")
 	s ^TMP("bb")=sid
	s id="" 
 	f  s id=$O(^DHCMGNUR.QualCodeItemD(id)) q:id=""  d
 	.s a=##class(DHCMGNUR.QualCodeItem).%OpenId(id)
 	.//q:id=12
	.s rw=id
	.;q:((rw'=sid)&(sid'=""))
	.;b ;01
	.i sid="SafeCheck" q:(a.QualDesc'["核查")
	.i ((sid="SpecCheck")||(sid="QualCheck")) q:(a.QualDesc["安全核查")
	.s ret=""
	.s ret=##class(DHCMGNUR.QualCodeItem).getVal(rw)
	.s we=""
	.s we=##class(DHCMGNUR.QualCodeItem).getWeight(rw)
	.s ret=ret_"^rw|"_id
	.d outtyp2
 	//}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
outtyp2
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetQualCodeOldFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetQualCodeExecute ]
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

Query GetQualCodeOld(sid As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod GetQualCodeExecute(ByRef qHandle As %Binary, sid As %String = "", locid As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	;if WardId="" Quit $$$OK
 	//D ##class(%ResultSet).RunQuery("web.DHCMgNurSysComm","GetQualCode","QualCheck")
 	s ^TMP("bb")=sid
	
	;s id="" f  s id=$O(^DHCMGNUR.QualCodeItemD(id)) q:id=""  d
 	;.s a=##class(DHCMGNUR.QualCodeItem).%OpenId(id)
 	;.//q:id=12
	;.s rw=id
	;.;q:((rw'=sid)&(sid'=""))
	;.;b ;01
	;.i sid="SafeCheck" q:(a.QualDesc'["ºË²é")
	;.i ((sid="SpecCheck")||(sid="QualCheck")) q:(a.QualDesc["°²È«ºË²é")
	;.s ret=""
	;.s ret=##class(DHCMGNUR.QualCodeItem).getVal(rw)
	;.s we=""
	;.s we=##class(DHCMGNUR.QualCodeItem).getWeight(rw)
	;.s ret=ret_"^rw|"_id
	;.d outtyp2
 	//}
 	if (sid="QualSelfCheck")
 	{
	 	s id="" f  s id=$O(^DHCMGNUR.MgNurQualRelLocI("Typ",1," "_locid,id)) q:id=""  d
	 	.s rw="" f  s rw=$O(^DHCMGNUR.MgNurQualRelLocI("Typ",1," "_locid,id,rw)) q:rw=""  d
	 	..s a=##class(DHCMGNUR.MgNurQualRelLoc).%OpenId(rw)
	 	..s Pos=a.SortPos
	 	..s arr(Pos)=##class(DHCMGNUR.QualCodeItem).getVal(id)
	 	..s arr(Pos)=arr(Pos)_"^rw|"_id
	 	b
	 	s row="" f  s row=$o(arr(row)) q:row=""  d
	 	.s ret=arr(row)
	 	.d outtyp2
	}
 	else
 	{
 	s QualTemp=""
 	s Qual="" f  s Qual=$O(^DHCMGNUR.QualCodeItemI("Version",Qual)) q:Qual=""  d
 	.q:QualTemp=Qual
 	.s QualTemp=Qual
 	.s flag=0
 	.s Ver="" f  s Ver=$O(^DHCMGNUR.QualCodeItemI("Version",Qual,Ver),-1) q:Ver=""  d
 	..q:flag=1
 	..s flag=1
 	..s id="" f  s id=$O(^DHCMGNUR.QualCodeItemI("Version",Qual,Ver,id)) q:id=""  d
 	...s a=##class(DHCMGNUR.QualCodeItem).%OpenId(id)
	...s rw=id
	...;q:((rw'=sid)&(sid'=""))
	...q:a.QualDesc="夜查房"
	...q:a.QualCat="Satisfaction"
	...i (sid="SafeCheck")||(sid="SafeSelfCheck") q:a.QualCat'="SafeCheck"   ;(a.QualDesc'["核查")||(a.QualDesc["满意度")
	...;i ((sid="SpecCheck")||(sid="QualCheck")||(sid="QualSelfCheck")) q:a.QualCat'="Quality"  ;(a.QualDesc["核查")||(a.QualDesc["满意度")
	...s ret=""
	...s ret=##class(DHCMGNUR.QualCodeItem).getVal(rw)
	...s ret=ret_"^rw|"_id
	...d outtyp2
 	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
outtyp2
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetQualCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetQualCodeExecute ]
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

Query GetQualCode(sid As %String, locid As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod GetQualCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetQualCodeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 
/// 查询质控检查项目选择
/// 
Query FindWardRoomItem(sid As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindWardRoomItemExecute(ByRef qHandle As %Binary, sid As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s ret=""
 	s rw="" f  s rw=$O(^DHCMGNUR.MgNurQualRelLocI("Typ",1," "_sid,rw)) q:rw=""  d
 	.s a=##class(DHCMGNUR.QualCodeItem).%OpenId(rw)
 	.s QualDesc=a.QualDesc
 	.s QualWeight=a.QualWeight
 	.s ret="QualDesc|"_QualDesc_"^QualWeight|"_QualWeight_"^rw|"_rw
	.d OutRowtyp
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(ret)
	Set ^CacheTemp(repid,ind)=Data
 	
 	Set ind=ind+1
	quit
}

ClassMethod FindWardRoomItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWardRoomItemExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindWardRoomItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWardRoomItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindQualRel(HsDr, typ, ward = "", Par = "") As %Query(ROWSPEC = "QualDesc,qudr,SortPos,QualWeight,rw")
{
}

ClassMethod FindQualRelExecute(ByRef qHandle As %Binary, HsDr, typ, ward = "", Par = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	//D ##class(%ResultSet).RunQuery("web.DHCMgNurSysComm","FindQualRel","1","Ward","","")
 	s ^TMP("k")=$LB(HsDr,typ)
 	s typ=$TR($ZConvert(typ,"U")," ","")
    s tmp=""
	s qudr="" f  s qudr=$O(^DHCMGNUR.MgNurQualRelLocI("Typ",HsDr," "_typ,qudr)) q:qudr=""  d
	.s rw="" f  s rw=$O(^DHCMGNUR.MgNurQualRelLocI("Typ",HsDr," "_typ,qudr,rw)) q:rw=""  d
	..s a=##class(DHCMGNUR.MgNurQualRelLoc).%OpenId(rw)
	..s sort=a.SortPos
	..s q=##class(DHCMGNUR.QualCodeItem).%OpenId(qudr)
	..s QualDesc=q.QualDesc
	..s wet=q.QualWeight
	..s qucode=q.QualCode
	..s rd=##class(DHCMGNUR.QualCodeItem).getqualid(qucode)
	..if '$D(tmp(sort)) s tmp(sort)=QualDesc_"^"_qudr_"^"_wet_"^"_rd
	..e  s tmp(sort+1)=QualDesc_"^"_CtLocDr_"^"_wet_"^"_rd
	s p=""   f  s p=$O(tmp(p)) q:p=""  d
	.s QualDesc=$P(tmp(p),"^"),qudr=$P(tmp(p),"^",2),wet=$p(tmp(p),"^",3),rd=$p(tmp(p),"^",4)
	.d OutputRow8
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(QualDesc,qudr,p,wet,rd)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindQualRelFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindQualRelExecute ]
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

ClassMethod FindQualRelClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindQualRelExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetTypQualItem(typ, w, h) As %String
{
      //w ##class(web.DHCMgNurSysComm).GetTypQualItem("ward","916","872")
      //s ^lf(123)=typ_","_w_","_h
        //s ^pp(12)=w
          s HsDr=1
         s typ=$TR($ZConvert(typ,"U")," ","")
    
   		 s qudr="" f  s qudr=$O(^DHCMGNUR.MgNurQualRelLocI("Typ",HsDr," "_typ,qudr)) q:qudr=""  d
		 .s rw="" f  s rw=$O(^DHCMGNUR.MgNurQualRelLocI("Typ",HsDr," "_typ,qudr,rw)) q:rw=""  d
	 	 ..s a=##class(DHCMGNUR.MgNurQualRelLoc).%OpenId(rw)
	 	 ..s sort=a.SortPos
	 	 ..s q=##class(DHCMGNUR.QualCodeItem).%OpenId(qudr)
	 	 ..s QualDesc=q.QualDesc
	 	 ..s QuCode=q.QualCode
	 	 ..if '$D(tmp(sort)) s tmp(sort)=QualDesc_"^"_qudr_"^"_QuCode
	 	 ..e  s tmp(sort+1)=QualDesc_"^"_CtLocDr
	 	 s ret="["
	 	 s p=""   f  s p=$O(tmp(p)) q:p=""  d
	 	 .s QualDesc=$P(tmp(p),"^"),QuCode=$P(tmp(p),"^",3)
	 	 .s url="dhcmgnurcomm.csp?EmrCode=DHCMGNurCheckList&CheckCode="_QuCode_"&CheckTitle="_QualDesc
	 	 .s ret=ret_"{border: false,region: 'center', layout: 'fit', title: '"_QualDesc_"',height:"_h_",html:'<iframe id =""southTab"" name=""ddd"" style=""width:100%;height:100%"" src="""_url_""" ></iframe>'}"
	 	 .s bb=$O(tmp(p))
	 	 .if bb'="" s ret=ret_","
	 	 s ret=ret_"]"
	 	 q ret
}

ClassMethod GetQualCheck(checkid, CheckTyp, w, h) As %String
{
    s itm=##class(DHCMGNUR.MgCheckWard).%OpenId(checkid)
    s ret="["
    s l=itm.CheckQuals.Count()
	for i=1:1:l
	{
		s rww=itm.CheckQuals.GetAt(i)
		s rw=$p(rww,"!",2)
		s qtype=$p(rww,"!",1)
		i qtype="S"
		{
			s q=##class(DHCMGNUR.QualCodeItem).%OpenId(rw)
			s QualDesc=q.QualDesc
			s QuCode=q.QualCode	
		}elseif qtype="C"
		{
			s obj=##class(DHCMGNUR.MgNurQcModel).%OpenId(rw)
			s QualDesc=obj.ModelName
			s QuCode=rw
		}
		
		;i (CheckTyp="QualSelfCheck")!(CheckTyp="SpecSelfCheck") s url="dhcmgnurcomm.csp?EmrCode=DHCMGNurSelfCheckList&CheckCode="_rw_"&CheckTitle="_QuCode_"&CheckRoomId="_checkid_"&CheckTyp="_CheckTyp
	 	i (CheckTyp="SpecSelfCheck") s url="dhcmgnurcomm.csp?EmrCode=DHCMGNurSelfCheckList&CheckCode="_rw_"&CheckTitle="_QuCode_"&CheckRoomId="_checkid_"&CheckTyp="_CheckTyp
	 	e  s url="dhcmgnurcomm.csp?EmrCode=DHCMGNURCHECKROOMLST&CheckCode="_rw_"&CheckTitle="_QuCode_"&CheckRoomId="_checkid_"&CheckTyp="_CheckTyp_"&qtype="_qtype
	 	s ret=ret_"{border: false,region: 'center', layout: 'fit', title: '"_QualDesc_"',height:"_h_",html:'<iframe id =""southTab"" name=""ddd"" style=""width:100%;height:100%"" src="""_url_""" ></iframe>'}"
	 	s bb=itm.CheckQuals.GetAt(i+1)
	 	if bb'="" s ret=ret_","
	}
	;s QualDesc="质控汇总1"
	;s sumecode="DHCNurQualWardSum"
	;if CheckTyp="SpecCheck" s sumecode="DHCNurQualSpecialSumm"
	;s url="DHCNurEmrComm.csp?EmrCode="_sumecode_"&CheckCode=&CheckTitle=SUM&CheckRoomId="_checkid_"&CheckTyp="_CheckTyp
	;s ret=ret_",{border: false,region: 'center', layout: 'fit', title: '"_QualDesc_"',height:"_h_",html:'<iframe id =""southTab"" name=""ddd"" style=""width:100%;height:100%"" src="""_url_""" ></iframe>'}"
	;s QualDesc="质控汇总2"
	;s sumecode="DHCNurQualWardCountSum"
	;if CheckTyp="SpecCheck" s sumecode="DHCNurQualSpecialCountSumm"
	;s url="DHCNurEmrComm.csp?EmrCode="_sumecode_"&CheckCode=&CheckTitle=SUM&CheckRoomId="_checkid_"&CheckTyp="_CheckTyp
	;s ret=ret_",{border: false,region: 'center', layout: 'fit', title: '"_QualDesc_"',height:"_h_",html:'<iframe id =""southTab"" name=""ddd"" style=""width:100%;height:100%"" src="""_url_""" ></iframe>'}"
	//s QualDesc="病房质控汇总"
	//s sumecode="DHCNurWardQualNew00"
	//if CheckTyp="SpecCheck" s sumecode=""
	//s url="dhcmgnurcomm.csp?EmrCode="_sumecode_"&CheckCode=&CheckTitle=SUM&CheckRoomId="_checkid_"&CheckTyp="_CheckTyp
	//s ret=ret_",{border: false,region: 'center', layout: 'fit', title: '"_QualDesc_"',height:"_h_",html:'<iframe id =""southTab"" name=""ddd"" style=""width:100%;height:100%"" src="""_url_""" ></iframe>'}"
	//s Question="问题汇总"
	//s code="DHCMGNurChkQuseList"
	//s url="dhcmgnurcomm.csp?EmrCode="_code_"&CheckCode=&CheckTitle=SUM&CheckRoomId="_checkid_"&CheckTyp="_CheckTyp
	//s ret=ret_",{border: false,region: 'center', layout: 'fit', title: '"_Question_"',height:"_h_",html:'<iframe id =""southTab"" name=""ddd"" style=""width:100%;height:100%"" src="""_url_""" ></iframe>'}"
	s ret=ret_"]"
	q ret
}

ClassMethod GetSafetyCheck(checkid, CheckTyp, w, h) As %String
{
    // s ^TMP("qw")=$LB(checkid, CheckTyp, w, h)
      //w ##class(web.DHCMgNurSysComm).GetSafetyCheck("3","SafeCheck","1204","704"
    	s itm=##class(DHCMGNUR.MgCheckWard).%OpenId(checkid)
        s ret="["
        s l=itm.CheckQuals.Count()
	    for i=1:1:l
	    {
		  s rw=itm.CheckQuals.GetAt(i)
		  s q=##class(DHCMGNUR.QualCodeItem).%OpenId(rw)
		  s QualDesc=q.QualDesc
		  s CheckMould=q.QualCheckMth
		  s QuCode=q.QualCode
		  ;i (CheckTyp="SafeSelfCheck")
		  s url="dhcmgnurcomm.csp?EmrCode=DHCMGNurSafetyList&CheckCode="_QuCode_"&CheckTitle="_QuCode_"&CheckRoomId="_checkid_"&CheckTyp="_CheckTyp_"&CheckMould="_CheckMould
	 	  s ret=ret_"{border: false,region: 'center', layout: 'fit', title: '"_QualDesc_"',height:"_h_",html:'<iframe id =""southTab"" name=""ddd"" style=""width:100%;height:100%"" src="""_url_""" ></iframe>'}"
	 	  s bb=itm.CheckQuals.GetAt(i+1)
	 	  if bb'="" s ret=ret_","

		}
		s QualDesc="核查汇总"
		s sumecode="DHCNurSafeCheckSum"
		s url="dhcmgnurcomm.csp?EmrCode="_sumecode_"&CheckCode=&CheckTitle=SUM&CheckRoomId="_checkid_"&CheckTyp="_CheckTyp
	 	s ret=ret_",{border: false,region: 'center', layout: 'fit', title: '"_QualDesc_"',height:"_h_",html:'<iframe id =""southTab"" name=""ddd"" style=""width:100%;height:100%"" src="""_url_""" ></iframe>'}"

	   s ret=ret_"]"

	 q ret
}

ClassMethod SelectPersonExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//补贴调节记录
 	s ^TMP("qq")=parr
 	s ret=""
    	s p="" f  s p=$O(^DHCMGNUR.PersonsI("SSID"," "_p)) q:p=""  d
    	.s p=$tr(p," ","")
		.s id="" f  s id=$O(^DHCMGNUR.PersonsI("SSID"," "_p,id)) q:id=""  d
		..s a=##class(DHCMGNUR.Persons).%OpenId(id)
		..s PersonName=a.PersonName
		..s Age=$ZD(a.PersonBirthDay,3)
		..s Mariage=a.Personmarriage
		..i Mariage="1" s Mariage="未婚"
		..i Mariage="2" s Mariage="已婚"
		..i Mariage="3" s Mariage="离婚"
		..s PersonSexDR=a.PersonSexDR
		..i PersonSexDR="1"  s PersonSexDR="男"
		..i PersonSexDR="2"  s PersonSexDR="女"
		..s PersonID=a.PersonID
		..s PersonRegNo=a.PersonRegNo
		..s PersonIdentity=a.PersonIdentity
		..s PersonTeachPostDR=a.PersonTeachPostDR.PostCode
		..i a.PersonWorkDateTime="" s PersonWorkDateTime="" 
		..i a.PersonWorkDateTime'="" s PersonWorkDateTime=$ZD(a.PersonWorkDateTime,3)
		..s PersonTyp=a.PersonTyp
		..i PersonTyp="D" s PersonTyp="Doctor"
		..i PersonTyp="N" s PersonTyp="Nurse"
		..i PersonTyp="W" s Worker="Worker"
		..s PersonTelHome=a.PersonTelHome
		..s PersonTelHand=a.PersonTelHand
		..s PersonAddress=a.PersonAddress
		..s PersonNativePlaceDR=a.PersonNativePlaceDR
		..i a.PersonNurseQualDate="" s PersonNurseQualDate=""
		..i a.PersonNurseQualDate'="" s PersonNurseQualDate=$ZD(a.PersonNurseQualDate,3)
		..s PersonPrefQual=a.PersonPrefQual.MgCodeCode
		..i a.PersonPrefQualDate="" s PersonPrefQualDate=""
		..i a.PersonPrefQualDate'="" s PersonPrefQualDate=$ZD(a.PersonPrefQualDate,3)
		..s PersonDepDR=a.PersonDepDR
		..i a.PersonFromDate="" s PersonFromDate=""
		..i a.PersonFromDate'="" s PersonFromDate=$ZD(a.PersonFromDate,3)
		..s PersonProfPostDR=a.PersonProfPostDR.PostCode
		..i a.PersonTechPostDate="" s PersonTechPostDate=""
		..i a.PersonTechPostDate'="" s PersonTechPostDate=$ZD(a.PersonTechPostDate,3)
		..s PersonAppDutyDR=a.PersonAppDutyDR
		..s PersonheadshipDR=a.PersonheadshipDR.PostCode
		..s PersonMentorDR=a.PersonMentorDR.PostCode
		..i a.PersonGraduateDate="" s PersonGraduateDate=""
		..i a.PersonGraduateDate'="" s PersonGraduateDate=$ZD(a.PersonGraduateDate,3)
		..s PersonGraduateSchool=a.PersonGraduateSchool
		..s PersonSchoolAgeDr=a.PersonSchoolAgeDr.MgCodeCode
		..s PersonDegreeDR=a.PersonDegreeDR.MgCodeCode
		..s PersonLanguage=a.PersonLanguage.MgCodeCode
		..s PersonProfession=a.PersonProfession.MgCodeCode
		..s PersonPresentZipCode=a.PersonPresentZipCode
		..s PersonHouseholdAdd=a.PersonHouseholdAdd
		..i a.PersonCareDate="" s PersonCareDate=""
		..i a.PersonCareDate'="" s PersonCareDate=$ZD(a.PersonCareDate,3)
		..s PersonHeight=a.PersonHeight
		..s PersonShoeNO=a.PersonShoeNO.MgCodeCode
		..s PersonClothesNO=a.PersonClothesNO.MgCodeCode
		..i a.PersonNurHeadDate="" s PersonNurHeadDate=""
		..i a.PersonNurHeadDate'="" s PersonNurHeadDate=$ZD(a.PersonNurHeadDate,3)
		..s PersonBattery=a.PersonBattery.MgCodeCode
		..s PersonNurTyp=a.PersonNurTyp.MgCodeCode
		..s PersonEngageMth=a.PersonEngageMth.MgCodeCode
		..i a.PersonEngageDate="" s PersonEngageDate=""
		..i a.PersonEngageDate'="" s PersonEngageDate=$ZD(a.PersonEngageDate,3)
		..i a.PersonHosEngageDate="" s PersonHosEngageDate=""
		..i a.PersonHosEngageDate'="" s PersonHosEngageDate=$ZD(a.PersonHosEngageDate,3)
		..i a.PersonAdmHosDate="" s PersonAdmHosDate=""
		..i a.PersonAdmHosDate'="" s PersonAdmHosDate=$ZD(a.PersonAdmHosDate,3)
		..s PersonPolitydr=a.PersonPolitydr.MgCodeCode
		..s Personpeopledr=a.Personpeopledr.MgCodeCode
		..b ;001
		..s PersonIFFullTime=a.PersonIFFullTime
		..s PersonSchoolMedWest=a.PersonSchoolMedWest.MgCodeCode
		..s PersonSchoolType=a.PersonSchoolType.MgCodeCode
		..i a.PersonEndDate="" s PersonEndDate=""
		..i a.PersonEndDate'="" s PersonEndDate=$ZD(a.PersonEndDate,3)
		..i a.PersonRetireDate="" s PersonRetireDate=""
		..i a.PersonRetireDate'="" s PersonRetireDate=$ZD(a.PersonRetireDate,3)
		..s PersonHouseZipCode=a.PersonHouseZipCode
		..s ret="PersonHouseZipCode"_"|"_PersonHouseZipCode_"^"_"PersonRetireDate"_"|"_PersonRetireDate_"^"_"PersonEndDate"_"|"_PersonEndDate_"^"_"PersonSchoolType"_"|"_PersonSchoolType_"^"_"PersonSchoolMedWest"_"|"_PersonSchoolMedWest_"^"_"PersonIFFullTime"_"|"_PersonIFFullTime_"^"_"Personpeopledr"_"|"_Personpeopledr_"^"_"PersonPolitydr"_"|"_PersonPolitydr_"^"_"PersonAdmHosDate"_"|"_PersonAdmHosDate_"^"_"PersonHosEngageDate"_"|"_PersonHosEngageDate_"^"_"PersonEngageDate"_"|"_PersonEngageDate_"^"_"PersonEngageMth"_"|"_PersonEngageMth_"^"_"PersonNurTyp"_"|"_PersonNurTyp_"^"_"PersonBattery"_"|"_PersonBattery_"^"_"PersonNurHeadDate"_"|"_PersonNurHeadDate_"^"_"PersonClothesNO"_"|"_PersonClothesNO_"^"_"PersonShoeNO"_"|"_PersonShoeNO_"^"_"PersonHeight"_"|"_PersonHeight_"^"_"PersonCareDate"_"|"_PersonCareDate_"^"_"PersonHouseholdAdd"_"|"_PersonHouseholdAdd_"^"_"PersonPresentZipCode"_"|"_PersonPresentZipCode_"^"_"PersonProfession"_"|"_PersonProfession_"^"_"PersonLanguage"_"|"_PersonLanguage_"^"_"PersonSchoolAgeDr"_"|"_PersonSchoolAgeDr_"^"_"PersonGraduateSchool"_"|"_PersonGraduateSchool_"^"_"PersonGraduateDate"_"|"_PersonGraduateDate_"^"_"PersonMentorDR"_"|"_PersonMentorDR_"^"_"PersonheadshipDR"_"|"_PersonheadshipDR_"^"_"PersonAppDutyDR"_"|"_PersonAppDutyDR_"^"_"PersonTechPostDate"_"|"_PersonTechPostDate_"^"_"PersonProfPostDR"_"|"_PersonProfPostDR_"^"_"PersonFromDate"_"|"_PersonFromDate_"^"_"PersonDepDR"_"|"_PersonDepDR_"^"_"PersonPrefQualDate"_"|"_PersonPrefQualDate_"^"_"PersonPrefQual"_"|"_PersonPrefQual_"^"_"PersonNurseQualDate"_"|"_PersonNurseQualDate_"^"_"PersonNativePlaceDR"_"|"_PersonNativePlaceDR_"^"_"PersonAddress"_"|"_PersonAddress_"^"_"PersonTelHand"_"|"_PersonTelHand_"^"_"PersonTelHome"_"|"_PersonTelHome_"^"_"PersonTyp"_"|"_PersonTyp_"^"_"PersonWorkDateTime"_"|"_PersonWorkDateTime_"^"_"PersonTeachPostDR"_"|"_PersonTeachPostDR_"^"_"PersonIdentity"_"|"_PersonIdentity_"^"_"PersonName"_"|"_PersonName_"^"_"PersonBirthDay"_"|"_Age_"^"_"Personmarriage"_"|"_Mariage_"^"_"PersonSexDR"_"|"_PersonSexDR_"^"_"PersonID"_"|"_PersonID_"^"_"PersonRegNo"_"|"_PersonRegNo_"^rw|"_id
		..//s ret=##class(DHCMGNUR.Persons).getVal(id)
	    ..s ret=ret_"^rw|"_id
		..d OutRowtyp
    
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(ret)
	Set ^CacheTemp(repid,ind)=Data
 	
 	Set ind=ind+1
	quit
}

ClassMethod SelectPersonFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectPersonExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SelectPersonClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectPersonExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

Query SelectPerson(parr As %String) As %Query(ROWSPEC = "aa")
{
}

Query FindPersonpeopledr(typ As %String = "") As %Query(ROWSPEC = "peopledr,id")
{
}

//民族

ClassMethod FindPersonpeopledrExecute(ByRef qHandle As %Binary, typ As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	//s ret=""
 	s tp="" f  s tp=$O(^User.DHCMGCCodeI("Typ",tp)) q:tp=""  d
 	.q:(tp'="9")
 	.s id="" f  s id=$O(^User.DHCMGCCodeI("Typ",tp,id)) q:id=""  d
 	..s a=##class(User.DHCMGCCode).%OpenId(id)
 	..s peopledr=a.MgCodeCode
 	..//b ;01
    ..d OutputRow8
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(peopledr,id)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindPersonpeopledrFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPersonpeopledrExecute ]
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

ClassMethod FindPersonpeopledrClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPersonpeopledrExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindPersonPolitydr(typ As %String = "") As %Query(ROWSPEC = "Politydr,id")
{
}

//政治面貌

ClassMethod FindPersonPolitydrExecute(ByRef qHandle As %Binary, typ As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	//s ret=""
 	s tp="" f  s tp=$O(^User.DHCMGCCodeI("Typ",tp)) q:tp=""  d
 	.q:(tp'="7")
 	.s id="" f  s id=$O(^User.DHCMGCCodeI("Typ",tp,id)) q:id=""  d
 	..s a=##class(User.DHCMGCCode).%OpenId(id)
 	..s Politydr=a.MgCodeCode
 	..//b ;01
    ..d OutputRow8
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(Politydr,id)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindPersonPolitydrFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPersonPolitydrExecute ]
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

ClassMethod FindPersonPolitydrClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPersonPolitydrExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindPersonLanguage(typ As %String = "") As %Query(ROWSPEC = "Language,id")
{
}

ClassMethod FindPersonLanguageExecute(ByRef qHandle As %Binary, typ As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	//s ret=""
 	s tp="" f  s tp=$O(^User.DHCMGCCodeI("Typ",tp)) q:tp=""  d
 	.q:(tp'="4")
 	.s id="" f  s id=$O(^User.DHCMGCCodeI("Typ",tp,id)) q:id=""  d
 	..s a=##class(User.DHCMGCCode).%OpenId(id)
 	..s Language=a.MgCodeCode
 	..//b ;01
    ..d OutputRow8
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(Language,id)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindPersonLanguageFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPersonLanguageExecute ]
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

ClassMethod FindPersonLanguageClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPersonLanguageExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindPersonShoeNO(typ As %String = "") As %Query(ROWSPEC = "ShoeNO,id")
{
}

ClassMethod FindPersonShoeNOExecute(ByRef qHandle As %Binary, typ As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	//s ret=""
 	s tp="" f  s tp=$O(^User.DHCMGCCodeI("Typ",tp)) q:tp=""  d
 	.q:(tp'="20")
 	.s id="" f  s id=$O(^User.DHCMGCCodeI("Typ",tp,id)) q:id=""  d
 	..s a=##class(User.DHCMGCCode).%OpenId(id)
 	..s ShoeNO=a.MgCodeCode
 	..//b ;01
    ..d OutputRow8
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(ShoeNO,id)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindPersonShoeNOFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPersonShoeNOExecute ]
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

ClassMethod FindPersonShoeNOClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPersonShoeNOExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindPersonSchoolMedWest(typ As %String = "") As %Query(ROWSPEC = "SchoolMedWest,id")
{
}

ClassMethod FindPersonSchoolMedWestExecute(ByRef qHandle As %Binary, typ As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	//s ret=""
 	s tp="" f  s tp=$O(^User.DHCMGCCodeI("Typ",tp)) q:tp=""  d
 	.q:(tp'="22")
 	.s id="" f  s id=$O(^User.DHCMGCCodeI("Typ",tp,id)) q:id=""  d
 	..s a=##class(User.DHCMGCCode).%OpenId(id)
 	..s SchoolMedWest=a.MgCodeCode
 	..//b ;01
    ..d OutputRow8
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(SchoolMedWest,id)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindPersonSchoolMedWestFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPersonSchoolMedWestExecute ]
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

ClassMethod FindPersonSchoolMedWestClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPersonSchoolMedWestExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindPersonTeachPostDR(typ As %String = "") As %Query(ROWSPEC = "TeachPostDR,id")
{
}

ClassMethod FindPersonTeachPostDRExecute(ByRef qHandle As %Binary, typ As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	//s ret=""
 	s tp="" f  s tp=$O(^User.DHCMGCPostCodeI("Typ",tp)) q:tp=""  d
 	.q:(tp'=" T")
 	.s id="" f  s id=$O(^User.DHCMGCPostCodeI("Typ",tp,id)) q:id=""  d
 	..s a=##class(User.DHCMGCPostCode).%OpenId(id)
 	..s TeachPostDR=a.PostCode
 	..//b ;01
    ..d OutputRow8
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(TeachPostDR,id)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindPersonTeachPostDRFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPersonTeachPostDRExecute ]
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

ClassMethod FindPersonTeachPostDRClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPersonTeachPostDRExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindPersonClothesNO(typ As %String = "") As %Query(ROWSPEC = "ClothesNO,id")
{
}

ClassMethod FindPersonClothesNOExecute(ByRef qHandle As %Binary, typ As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	//s ret=""
 	s tp="" f  s tp=$O(^User.DHCMGCCodeI("Typ",tp)) q:tp=""  d
 	.q:(tp'="19")
 	.s id="" f  s id=$O(^User.DHCMGCCodeI("Typ",tp,id)) q:id=""  d
 	..s a=##class(User.DHCMGCCode).%OpenId(id)
 	..s ClothesNO=a.MgCodeCode
 	..//b ;01
    ..d OutputRow8
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(ClothesNO,id)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindPersonClothesNOFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPersonClothesNOExecute ]
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

ClassMethod FindPersonClothesNOClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPersonClothesNOExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindPersonBattery(typ As %String = "") As %Query(ROWSPEC = "Battery,id")
{
}

ClassMethod FindPersonBatteryExecute(ByRef qHandle As %Binary, typ As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	//s ret=""
 	s tp="" f  s tp=$O(^User.DHCMGCCodeI("Typ",tp)) q:tp=""  d
 	.q:(tp'="23")
 	.s id="" f  s id=$O(^User.DHCMGCCodeI("Typ",tp,id)) q:id=""  d
 	..s a=##class(User.DHCMGCCode).%OpenId(id)
 	..s Battery=a.MgCodeCode
 	..//b ;01
    ..d OutputRow8
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(Battery,id)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindPersonBatteryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPersonBatteryExecute ]
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

ClassMethod FindPersonBatteryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPersonBatteryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindPersonMentorDR(typ As %String = "") As %Query(ROWSPEC = "MentorDR,id")
{
}

ClassMethod FindPersonMentorDRExecute(ByRef qHandle As %Binary, typ As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	//s ret=""
 	s tp="" f  s tp=$O(^User.DHCMGCPostCodeI("Typ",tp)) q:tp=""  d
 	.q:(tp'=" M")
 	.s id="" f  s id=$O(^User.DHCMGCPostCodeI("Typ",tp,id)) q:id=""  d
 	..s a=##class(User.DHCMGCPostCode).%OpenId(id)
 	..s MentorDR=a.PostCode
 	..//b ;01
    ..d OutputRow8
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(MentorDR,id)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindPersonMentorDRFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPersonMentorDRExecute ]
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

ClassMethod FindPersonMentorDRClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPersonMentorDRExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindPersonGraduateSchool(typ As %String = "") As %Query(ROWSPEC = "GraduateSchool,id")
{
}

ClassMethod FindPersonGraduateSchoolExecute(ByRef qHandle As %Binary, typ As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	//s ret=""
 	s tp="" f  s tp=$O(^User.DHCMGCCodeI("Typ",tp)) q:tp=""  d
 	.q:(tp'="2")
 	.s id="" f  s id=$O(^User.DHCMGCCodeI("Typ",tp,id)) q:id=""  d
 	..s a=##class(User.DHCMGCCode).%OpenId(id)
 	..s GraduateSchool=a.MgCodeDesc
 	..//b ;01
    ..d OutputRow8
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(GraduateSchool,id)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindPersonGraduateSchoolFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPersonGraduateSchoolExecute ]
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

ClassMethod FindPersonGraduateSchoolClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPersonGraduateSchoolExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindPersonSchoolType(typ As %String = "") As %Query(ROWSPEC = "SchoolType,id")
{
}

ClassMethod FindPersonSchoolTypeExecute(ByRef qHandle As %Binary, typ As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	//s ret=""
 	s tp="" f  s tp=$O(^User.DHCMGCCodeI("Typ",tp)) q:tp=""  d
 	.q:(tp'="21")
 	.s id="" f  s id=$O(^User.DHCMGCCodeI("Typ",tp,id)) q:id=""  d
 	..s a=##class(User.DHCMGCCode).%OpenId(id)
 	..s SchoolType=a.MgCodeCode
 	..//b ;01
    ..d OutputRow8
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(SchoolType,id)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindPersonSchoolTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPersonSchoolTypeExecute ]
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

ClassMethod FindPersonSchoolTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPersonSchoolTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindPersonNurTyp(typ As %String = "") As %Query(ROWSPEC = "NurTyp,id")
{
}

ClassMethod FindPersonNurTypExecute(ByRef qHandle As %Binary, typ As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	//s ret=""
 	s tp="" f  s tp=$O(^User.DHCMGCCodeI("Typ",tp)) q:tp=""  d
 	.q:(tp'="1")
 	.s id="" f  s id=$O(^User.DHCMGCCodeI("Typ",tp,id)) q:id=""  d
 	..s a=##class(User.DHCMGCCode).%OpenId(id)
 	..s NurTyp=a.MgCodeCode
 	..//b ;01
    ..d OutputRow8
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(NurTyp,id)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindPersonNurTypFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPersonNurTypExecute ]
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

ClassMethod FindPersonNurTypClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPersonNurTypExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindPersonPostTyp(typ As %String = "") As %Query(ROWSPEC = "PostTyp,id")
{
}

ClassMethod FindPersonPostTypExecute(ByRef qHandle As %Binary, typ As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	//s ret=""
 	s tp="" f  s tp=$O(^User.DHCMGCCodeI("Typ",tp)) q:tp=""  d
 	.q:(tp'="13")
 	.s id="" f  s id=$O(^User.DHCMGCCodeI("Typ",tp,id)) q:id=""  d
 	..s a=##class(User.DHCMGCCode).%OpenId(id)
 	..s PostTyp=a.MgCodeDesc
 	..//b ;01
    ..d OutputRow8
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(PostTyp,id)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindPersonPostTypFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPersonPostTypExecute ]
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

ClassMethod FindPersonPostTypClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPersonPostTypExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindPersonProfession(typ As %String = "") As %Query(ROWSPEC = "Profession,id")
{
}

ClassMethod FindPersonProfessionExecute(ByRef qHandle As %Binary, typ As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	//s ret=""
 	s tp="" f  s tp=$O(^User.DHCMGCCodeI("Typ",tp)) q:tp=""  d
 	.q:(tp'="18")
 	.s id="" f  s id=$O(^User.DHCMGCCodeI("Typ",tp,id)) q:id=""  d
 	..s a=##class(User.DHCMGCCode).%OpenId(id)
 	..s Profession=a.MgCodeCode
 	..//b ;01
    ..d OutputRow8
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(Profession,id)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindPersonProfessionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPersonProfessionExecute ]
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

ClassMethod FindPersonProfessionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPersonProfessionExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindPersonSchoolAgeDr(typ As %String = "") As %Query(ROWSPEC = "SchoolAgeDr,id")
{
}

ClassMethod FindPersonSchoolAgeDrExecute(ByRef qHandle As %Binary, typ As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	//s ret=""
 	s tp="" f  s tp=$O(^User.DHCMGCCodeI("Typ",tp)) q:tp=""  d
 	.q:(tp'="5")
 	.s id="" f  s id=$O(^User.DHCMGCCodeI("Typ",tp,id)) q:id=""  d
 	..s a=##class(User.DHCMGCCode).%OpenId(id)
 	..s SchoolAgeDr=a.MgCodeCode
 	..//b ;01
    ..d OutputRow8
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(SchoolAgeDr,id)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindPersonSchoolAgeDrFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPersonSchoolAgeDrExecute ]
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

ClassMethod FindPersonSchoolAgeDrClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPersonSchoolAgeDrExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindPersonDegreeDR(typ As %String = "") As %Query(ROWSPEC = "DegreeDR,id")
{
}

ClassMethod FindPersonDegreeDRExecute(ByRef qHandle As %Binary, typ As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	//s ret=""
 	s tp="" f  s tp=$O(^User.DHCMGCCodeI("Typ",tp)) q:tp=""  d
 	.q:(tp'="6")
 	.s id="" f  s id=$O(^User.DHCMGCCodeI("Typ",tp,id)) q:id=""  d
 	..s a=##class(User.DHCMGCCode).%OpenId(id)
 	..s DegreeDR=a.MgCodeCode
 	..//b ;01
    ..d OutputRow8
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(DegreeDR,id)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindPersonDegreeDRFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPersonDegreeDRExecute ]
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

ClassMethod FindPersonDegreeDRClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPersonDegreeDRExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindPersonEngageMth(typ As %String = "") As %Query(ROWSPEC = "EngageMth,id")
{
}

ClassMethod FindPersonEngageMthExecute(ByRef qHandle As %Binary, typ As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	//s ret=""
 	s tp="" f  s tp=$O(^User.DHCMGCCodeI("Typ",tp)) q:tp=""  d
 	.q:(tp'="8")
 	.s id="" f  s id=$O(^User.DHCMGCCodeI("Typ",tp,id)) q:id=""  d
 	..s a=##class(User.DHCMGCCode).%OpenId(id)
 	..s EngageMth=a.MgCodeCode
 	..//b ;01
    ..d OutputRow8
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(EngageMth,id)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindPersonEngageMthFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPersonEngageMthExecute ]
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

ClassMethod FindPersonEngageMthClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPersonEngageMthExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindPersonheadshipDR(typ As %String = "") As %Query(ROWSPEC = "headshipDR,id")
{
}

ClassMethod FindPersonheadshipDRExecute(ByRef qHandle As %Binary, typ As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	//s ret=""
 	s tp="" f  s tp=$O(^User.DHCMGCPostCodeI("Typ",tp)) q:tp=""  d
 	.q:(tp'=" D")
 	.s id="" f  s id=$O(^User.DHCMGCPostCodeI("Typ",tp,id)) q:id=""  d
 	..s a=##class(User.DHCMGCPostCode).%OpenId(id)
 	..s headshipDR=a.PostDesc
 	..//b ;01
    ..d OutputRow8
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(headshipDR,id)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindPersonheadshipDRFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPersonheadshipDRExecute ]
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

ClassMethod FindPersonheadshipDRClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPersonheadshipDRExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindPersonPrefQual(typ As %String = "") As %Query(ROWSPEC = "PrefQual,id")
{
}

ClassMethod FindPersonPrefQualExecute(ByRef qHandle As %Binary, typ As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	//s ret=""
 	s tp="" f  s tp=$O(^User.DHCMGCCodeI("Typ",tp)) q:tp=""  d
 	.q:(tp'="10")
 	.s id="" f  s id=$O(^User.DHCMGCCodeI("Typ",tp,id)) q:id=""  d
 	..s a=##class(User.DHCMGCCode).%OpenId(id)
 	..s PrefQual=a.MgCodeCode
 	..//b ;01
    ..d OutputRow8
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(PrefQual,id)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindPersonPrefQualFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPersonPrefQualExecute ]
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

ClassMethod FindPersonPrefQualClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPersonPrefQualExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

//常用模板取数据

ClassMethod GetQualItemUsualExecute(ByRef qHandle As %Binary, Par As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	;if WardId="" Quit $$$OK
 	//s ^TMP("bb")=sid 	
	s id="" f  s id=$O(^DHCMGNUR.QuCheckProjectChildD(Par,id)) q:id=""  d
 	.s a=##class(DHCMGNUR.QuCheckProjectChild).%OpenId(Par_"||"_id)
	.//s ret=##class(DHCMGNUR.QualCodeItemSub).getVal(Par_"||"_id)
	.s code=a.ItemCode
	.s level=a.ItemLevel
	.s chkitm=a.CheckItem
	.s ItemDesc=chkitm.ItemDesc
	.s itmvalue=chkitm.ItemValue
	.//s itmmem=a.ItemMem
	.i level="" s level=code
	.s I=$INUMBER($P(code,"."),"T"),II=$P(code,".",2),III=$P(code,".",3)
	.if $D(TMII(I,II)) s II=..getsortno(I,.TMII)
	.if (II'="")&(III="") d
	..s II=$INUMBER(II,"T")
	..s TMII(I,II)=Par_"||"_id
	.//d outtyp2
	b //
	s r=""  f  s r=$O(TMII(r)) q:r=""  d
	.s p="" f  s p=$O(TMII(r,p)) q:p=""  d
	..s Par=$P(TMII(r,p),"||",1),rw=$P(TMII(r,p),"||",2)
	..s ret=##class(DHCMGNUR.QuCheckProjectChild).getVal(TMII(r,p))
	..s ret=ret_"^rw|"_rw_"^Par|"_Par
	..d outtyp2
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
outtyp2
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetQualItemUsualFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetQualItemUsualExecute ]
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

Query GetQualItemUsual(Par As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod GetQualItemUsualClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetQualItemUsualExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

}
