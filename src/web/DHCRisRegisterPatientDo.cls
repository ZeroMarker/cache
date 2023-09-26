Import SQLUser

/// 程序名DHCRisRegisterPatientDo 病人登记
Class web.DHCRisRegisterPatientDo Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 672;

// JST 2006-11-17 需求   放射科发片需求

Query GetCareProv(Locrowid As %String) As %Query(ROWSPEC = "desc:%String,rw:%String")
{
}

ClassMethod GetCareProvExecute(ByRef qHandle As %Binary, Locrowid As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	i $g(^DHCRisGetNameSet)="" s ^DHCRisGetNameSet="ID"
	s ind=1
	
	s resrowid=0 f  s resrowid=$o(^RB("RES",0,"CTLOC",Locrowid,resrowid)) q:(resrowid="")  d
	.s ResInfo=^RB("RES",resrowid)
	.s CareProvrowid=$p(ResInfo,"^",2)
	.i CareProvrowid'=""  d
	..i ^DHCRisGetNameSet="ID" d
	...s CareProvDesc=$p(^CTPCP(CareProvrowid,1),"^",3)
	..else  d
	...s CareProvDesc=$p(^CTPCP(CareProvrowid,1),"^",2)
 	..Do OutCareProv 
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutCareProv
	set Data=$lb(CareProvDesc,CareProvrowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetCareProvFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCareProvExecute ]
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

ClassMethod GetCareProvClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCareProvExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query GetBodyPart(Locrowid As %String) As %Query(ROWSPEC = "desc:%String,rw:%String")
{
}

ClassMethod GetBodyPartExecute(ByRef qHandle As %Binary, Locrowid As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s bodyrowid=0 f  s bodyrowid=$o(^MRC("BODP",bodyrowid)) q:(bodyrowid="")  d
	.s bodyInfo=^MRC("BODP",bodyrowid)
	.;s bodycode=$p(bodyInfo,"^",1)
	.s bodydesc=$p(bodyInfo,"^",2)
	.Do OutBodyPart 
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutBodyPart
	set Data=$lb(bodydesc,bodyrowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetBodyPartFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCareProvExecute ]
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

ClassMethod GetBodyPartClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCareProvExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query GetResource(Locrowid As %String) As %Query(ROWSPEC = "desc:%String,rw:%String")
{
}

ClassMethod GetResourceExecute(ByRef qHandle As %Binary, Locrowid As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s resrowid=0 f  s resrowid=$O(^RB("RES",0,"CTLOC",Locrowid,resrowid)) q:(resrowid="")  d
	.s ResInfo=^RB("RES",resrowid)
	.s Equipmentrowid=$p(ResInfo,"^",3)
 	.i Equipmentrowid'="" d 
 	..s ResourceDesc=$p(^RBC("EQ",Equipmentrowid) ,"^",2)
 	..Do OutResource 
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutResource
	set Data=$lb(ResourceDesc,Equipmentrowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ^CacheTemp(repid,ind+1)=$lb("所有"," ")
 	Set ind=ind+1
	quit
}

ClassMethod GetResourceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetResourceExecute ]
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

ClassMethod GetResourceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetResourceExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetPatientInfo(paadmrowid)
{
	s PAPMIdr=$p(^PAADM(paadmrowid),"^",1)
	s patname=$p(^PAPER(PAPMIdr,"ALL"),"^",1)
	q patname
}

ClassMethod GetPatientInfoEx(paadmrowid)
{
	s DOB="",strAge="",wardname="",bedname=""
	s PAPMIdr=$p(^PAADM(paadmrowid),"^",1)
	s patname=$p(^PAPER(PAPMIdr,"ALL"),"^",1)
	
	s Sexdr=$p(^PAPER(PAPMIdr,"ALL"),"^",7)
	i Sexdr'="" s Sex=$p(^CT("SEX",Sexdr),"^",2)
	s NO=$p(^PAPER(PAPMIdr,"PAT",1),"^",1)
	s DOB=$p(^PAPER(PAPMIdr,"ALL"),"^",6)
	i DOB'="" d 
	.s DOB=##class(websys.Conversions).DateLogicalToHtml(DOB)  ;$zd(DOB,3)
	.;s strToday=$ZD(+$h,3)
    .s strAge=##class(web.DHCBillInterface).GetPapmiAge(PAPMIdr,paadmrowid)   ;##class(web.DHCRisWorkBenchDo).CalAge(DOB,strToday)
    s WardDr=$p(^PAADM(paadmrowid),"^",70)
    i WardDr'=""  s wardname=$p(^PAWARD(WardDr),"^",2)
    s beddr=$p(^PAADM(paadmrowid),"^",73)
    i beddr'=""  d 
     .s wardrowid=$p(beddr,"||",1)
     .s bedchildsub=$p(beddr,"||",2)
     .s bedname=$p(^PAWARD(wardrowid,"BED",bedchildsub),"^",1)
	q patname_"^"_Sex_"^"_NO_"^"_DOB_"^"_$g(strAge)_"^"_wardname_"^"_bedname
}

ClassMethod GetBookedInfo(orditmrowid)
{
	s ^gp11=orditmrowid
	s approwid="",returninfo=""
	i $g(^DHCRisGetNameSet)="" s ^DHCRisGetNameSet="ID"
	&sql(Select OEORI_APPT_DR into :approwid from OE_ORDitem where  OEORI_Rowid=:orditmrowid)
	i (approwid'="")&(approwid'=$c(0)) d
	.s resrowid=$p(approwid,"||",1)
	.s Schrowid=$p(approwid,"||",2)
	.s scheInfo=^RBAS(resrowid,Schrowid)
	.s AppointDate=$p(scheInfo,"^",1)
	.s AppointDate=$zd(AppointDate,3)
	.s AppointstTime=$p(scheInfo,"^",4)
	.s AppointstTime=$zt(AppointstTime,1)
	.s AppointedTime=$p(scheInfo,"^",5)
	.s Equipmentrowid=$p(^RB("RES",resrowid),"^",3)
	.i Equipmentrowid'="" d
	..s EQDesc=$p(^RBC("EQ",Equipmentrowid),"^",2)
	..s returninfo=approwid_"^"_resrowid_"^"_EQDesc_"^"_AppointDate_"^"_AppointstTime_"^"_AppointedTime_"^"_EQDesc_"^"_Equipmentrowid
	.s CareProvRowid=$p(^RB("RES",resrowid),"^",2)
	.i CareProvRowid'="" d
	..i ^DHCRisGetNameSet="ID" d
	...s CareDesc=$p(^CTPCP(CareProvRowid,1),"^",3)
	..else  d
	...s CareDesc=$P(^CTPCP(CareProvRowid,1),"^",2)
	..s returninfo=approwid_"^"_resrowid_"^"_CareDesc_"^"_AppointDate_"^"_AppointstTime_"^"_AppointedTime_"^^"
	else  d
	.s BookedRowid=$o(^DHCRBCResSchduleDetaili(0,orditmrowid,0))
    .i BookedRowid'="" d
    ..s GetPatientStatusCode="B"
    ..s SchudleRowid=$p(^DHCRBCResSchduleDetail("Detail",BookedRowid),"^",2)
    ..i SchudleRowid'="" d
    ...s ResourceId=$p(^DHCRBCResourceSchdule(SchudleRowid),"^",1)
    ...s ResDesc=""
 	...s CTCPDR=$p($g(^RB("RES",ResourceId)),"^",2)
    ...s CTCPDR=$p(CTCPDR,$c(0))
    ...i CTCPDR'="" d
    ....s ResDesc=$p($g(^CTPCP(CTCPDR,1)),"^",2)
    ...else  d
    ....s EQDR=$p($g(^RB("RES",ResourceId)),"^",3)
    ....s ResDesc=$p($g(^RBC("EQ",EQDR)),"^",2)
    ...s RppDate=$p(^DHCRBCResourceSchdule(SchudleRowid),"^",2)
    ...s AppointDate=$zd(RppDate,3)
    ...s RppTime=$p(^DHCRBCResourceSchdule(SchudleRowid),"^",5)
    ...s AppointstTime=$zt(RppTime,1)
    ..s returninfo=BookedRowid_"^"_ResourceId_"^"_ResDesc_"^"_AppointDate_"^"_AppointstTime
	
	
	q returninfo
}

ClassMethod GetAccessionNumber(orditmrowid)
{
	q:orditmrowid=""
	s OErowid=$p(orditmrowid,"||",1)
	s Childsub=$p(orditmrowid,"||",2)
	s AccesionNumber=$p(^OEORD(OErowid,"I",Childsub,8),"^",19)
	s Access=$p(AccesionNumber,"/",1)_"-"_$p(AccesionNumber,"/",2)
	q Access
}

ClassMethod GetNo(paadmrowid, locrowid)
{
	s ^aaa=paadmrowid_"^"_locrowid
	s No=""
	s PAPMIDR=$p(^PAADM(paadmrowid),"^",1)          
	s rowid=0  f  s rowid =$o(^DHCPACRegInfoNOi("adm",0,PAPMIDR,rowid)) q:rowid=""  d
	.s locdr= $p($g(^DHCPACRegInfoNO("NO",0,rowid)),"^",2)
	.i locdr=locrowid d
	..s No=$p(^DHCPACRegInfoNO("NO",0,rowid),"^",3) 
	q No
}

ClassMethod GetCreateType()
{
   s IsAuto=##class(web.DHCRisStudyNoSetDo).GetCreateType()
   q IsAuto
}

ClassMethod GetStudyNo(EQDr, LocDr)
{
	s ^yy=EQDr_"^"_LocDr
	s StudyNo=""
	i (EQDr=""&LocDr="") q StudyNo
	s rowid=""
	i $g(EQDr)'="" d 
	    .s EQGoupDr=$p(^RBC("EQ",EQDr),"^",3)
	    .i $g(EQGoupDr)'="" d 
	    ..s rowid=$o(^DHCPACRegInfoCRi("EQG_CreateNo",0,EQGoupDr,rowid),-1)
	else   d
	   .s rowid=$o(^DHCPACRegInfoCRi("LocCreateNo",0,LocDr,rowid),-1)
	q:rowid=""
	i (rowid'=0&& rowid'="")
	{ 
		s Number=$p($g(^DHCPACRegInfoCR("CreateRule",0,rowid)),"^",4)
		s Number=Number+1
		//&sql(update DHCRB_StudyNo_Createrule set RSC_MaxNumber=:Number where RSC_Rowid =:rowid)
		s Prefix=$p($g(^DHCPACRegInfoCR("CreateRule",0,rowid)),"^",2)
		s StudyNo=rowid_"^"_Prefix_"^"_Number
	}
	q StudyNo
}

// do ##class(web.DHCRisRegisterPatientDo).InsertRegInfo(^info,^bodyNum,^BodyInfo)

ClassMethod InsertRegInfo(Info, bodyNum, BodyInfo)
{
	
	s Appointdr=$p(Info,"^",1)
	s AssDocDr=$p(Info,"^",2)
	s MainDocDr=$p(Info,"^",3)
	s No=$p(Info,"^",4)
	s OEORIDr=$p(Info,"^",5)
	s paadr=$p(Info,"^",6)
	s RegEQDr=$p(Info,"^",7)
	s RegLOCDr=$p(Info,"^",8)
	s SSUSERDr=$p(Info,"^",9)
	s StudyNo=$p(Info,"^",10)
	s Index=$p(Info,"^",11)
	s weight=$p(Info,"^",12)
	s InpNo=$p(Info,"^",13)  //pa_patmas. PAPMI_Medicare
	s TelNo=$p(Info,"^",14)  //pa_person. PAPER_TelH
	

	s RegDate=+$h
	s RegTime=$p($h,",",2)
	s rowid=""
	s norowid=""
	s ^info=Info
	s ^bodyNum=bodyNum
	s ^BodyInfo=BodyInfo
	s SQLCODE=0
	
	//如有退费审核的话,则退出
	s redr=""
	s redr=$o(^DHCORDItem(0,OEORIDr,0))
	q:redr'="" 100

	d ##class(web.DHCRisRegisterPatientDo).UpdateIndex(RegLOCDr,Index,RegDate)
  	TSTART 
  	
  	s papatmasdr=$p(^PAADM(paadr),"^",1)
	if (No'="")
	{
		&sql(select  RNO_Rowid into :norowid from DHCRB_NO where RNO_NO=:No)
		if (norowid="") d
		 .&sql(insert into DHCRB_NO (RNO_LOC_DR,RNO_PAPATMAS_DR,RNO_NO)
		 	values (:RegLOCDr,:papatmasdr,:No))
		 .s norowid=$o(^DHCPACRegInfoNOi("No",1,No,0)) 
	}
   	&sql(insert into DHCRB_RegInfo 
		(RAR_Appointment_DR,RAR_AssistantDoctor_DR,RAR_MainDoctor_DR,RAR_OEORI_DR,
		RAR_PAADM_DR,RAR_RegEQ_DR,RAR_RegDate,RAR_RegLoc_DR,RAR_RegTime,RAR_SSUSER_DR,RAR_StudyNo,RAR_No_DR,RAR_RegEQ_Index)
	  values (:Appointdr,:AssDocDr,:MainDocDr,:OEORIDr,
	  :paadr,:RegEQDr,:RegDate,:RegLOCDr,:RegTime,:SSUSERDr,:StudyNo,:norowid,:Index))
  
	i SQLCODE TRollback  q SQLCODE 
	 
	s rowid=$o(^DHCPACRegInfoi("StudyNo",StudyNo,0))
	
	i (rowid '="")&(bodyNum'="")
	{
		for i=1:1:bodyNum
		{
			s bodydr=$p(BodyInfo,"^",i)
			&sql(insert into DHCRB_RegInfo_BodyParts (RRB_ParRef,RRB_BodyPart_DR ) 
						values (:rowid,:bodydr))
		}
	}
	
	if (rowid'="")
	{
		s ret=0
		s ret=##class(web.DHCRisRegisterPatientDo).UpdataOrdInfo(SSUSERDr,OEORIDr,"6","RG")
	}
	I SQLCODE TRollback  q SQLCODE
	
	//update weight 2006-10-16
	s mrrowid=$p(^PAADM(paadr),"^",61)
	&sql(update MR_Adm SET MRADM_Weight=:weight where MRADM_Rowid=:mrrowid)

    //update 住院号
    &sql(update PA_PATMAS set PAPMI_Medicare=:InpNo where PAPMI_RowId=:papatmasdr)
    
    //update 电话号
    
    &sql(update pa_person set PAPER_TelH =:TelNo where PAPER_Rowid=:papatmasdr) 
	TCOMMIT
	
	//设备的接口设计
	//s ret=##class(web.DHCEQIUsedRecord).BuildRISUseRecord(RegEQDr,OEORIDr)

   
  		
	q SQLCODE
}

ClassMethod UpdateRegInfo(Info, bodyNum, BodyInfo)
{
	s Appointdr=$p(Info,"^",1)
	s AssDocDr=$p(Info,"^",2)
	s MainDocDr=$p(Info,"^",3)
	s No=$p(Info,"^",4)
	s OEORIDr=$p(Info,"^",5)
	s paadr=$p(Info,"^",6)
	s RegEQDr=$p(Info,"^",7)
	s RegLOCDr=$p(Info,"^",8)
	s SSUSERDr=$p(Info,"^",9)
	s StudyNo=$p(Info,"^",10)
	s Index=$p(Info,"^",11)
	s weight=$p(Info,"^",12)
	s InpNo=$p(Info,"^",13)  //pa_patmas. PAPMI_Medicare
    s TelNo=$p(Info,"^",14) 
	
	
	s RegDate=+$h
	s RegTime=$p($h,",",2)
	s rowid=""
	s norowid=0,regrowid=0
	s ^Info1=Info
	s ^bodyNum1=bodyNum
	s ^BodyInfo=BodyInfo
	
	d ##class(web.DHCRisRegisterPatientDo).UpdateIndex(RegLOCDr,Index,RegDate)

	
	TSTART 
	s regrowid=""
	s regrowid=$o(^DHCPACRegInfoi("OEORI",OEORIDr,regrowid))
	s nodr=$p(^DHCPACRegInfo(regrowid),"^",3)
	s papatmasdr=$p(^PAADM(paadr),"^",1)  
	if (nodr'="")
	{
		&sql(update  DHCRB_NO set RNO_NO=:No where RNO_Rowid=:nodr)
		I SQLCODE TRollBack  Quit SQLCODE
		
	}
	else
	{
		if (No'="") d
		.;s papatmasdr=$p(^PAADM(paadr),"^",1)
		.&sql(insert into DHCRB_NO (RNO_LOC_DR,RNO_PAPATMAS_DR,RNO_NO)
		 	values (:RegLOCDr,:papatmasdr,:No))
		.s nodr=$o(^DHCPACRegInfoNOi("No",1,No,0)) 
		
	}
	
	&sql(update  DHCRB_RegInfo 
		(RAR_AssistantDoctor_DR,RAR_MainDoctor_DR,
		RAR_RegEQ_DR,RAR_RegDate,RAR_RegLoc_DR,RAR_RegTime,RAR_SSUSER_DR,RAR_StudyNo,RAR_No_DR,RAR_RegEQ_Index)
	  values (:AssDocDr,:MainDocDr,:RegEQDr,:RegDate,:RegLOCDr,:RegTime,:SSUSERDr,:StudyNo,:nodr,:Index)
	  where RAR_OEORI_DR=:OEORIDr
	  )
    I SQLCODE TRollBack  Quit SQLCODE
	//  ?????????????
 	// &sql(delete from DHCRB_RegInfo_BodyParts where  RRB_ParRef=:regrowid)
	i (bodyNum'="")
	{
		for i=1:1:bodyNum
		{
			s bodydr=$p(BodyInfo,"^",i)
			&sql(insert into DHCRB_RegInfo_BodyParts (RRB_ParRef,RRB_BodyPart_DR ) 
						values (:regrowid,:bodydr))
		}
	}
	s ret=0
	//if (regrowid'="")
	//{
		//s ret=##class(web.DHCRisRegisterPatientDo).UpdataOrdInfo(SSUSERDr,OEORIDr,"6","RG")
	//}
	
	
	//update weight 2006-10-16
	s mrrowid=$p(^PAADM(paadr),"^",61)
	&sql(update MR_Adm SET MRADM_Weight=:weight where MRADM_Rowid=:mrrowid)
	
	    //update 住院号
    &sql(update PA_PATMAS set PAPMI_Medicare=:InpNo where PAPMI_RowId=:papatmasdr)
	
	 //update 电话号
     &sql(update pa_person set PAPER_TelH =:TelNo where PAPER_Rowid=:papatmasdr) 
   
	I ret TRollBack  Quit SQLCODE
	TCOMMIT
	
	
	q SQLCODE
}

ClassMethod GetRegInfo(OEordrowid)
{
	s ^testor=OEordrowid
	s BodyInfo="",No=""
	s rowid=0,Info="",returnInfo=""
	s StudyNo="",MainDocDr="",MainDoc="",AssiantDocDr="",AssiantDoc=""
	s RegEQDr="",RegEQ="",RegDate="",RegTime=""
	s OEordrowid=$g(OEordrowid)
	;q OEordrowid=""
	s rowid =$o(^DHCPACRegInfoi("OEORI",OEordrowid,rowid))
	i (rowid'="")&(rowid'=0) d
	.s Info= ^DHCPACRegInfo(rowid)
	.s StudyNo=$p(Info,"^",2)
	.s Nodr=$p(Info,"^",3)
	.i Nodr'=""  s No=$p($g(^DHCPACRegInfoNO("NO",0,Nodr)),"^",3)
	.s MainDocDr=$p(Info,"^",5)
	.i MainDocDr'="" d
	..i ^DHCRisGetNameSet="ID" d
	...s MainDoc=$p(^CTPCP(MainDocDr,1),"^",3)
	..else  d
	...s MainDoc=$p(^CTPCP(MainDocDr,1),"^",2)
	.s AssiantDocDr=$p(Info,"^",6)
	.i AssiantDocDr'=""  d
	..i ^DHCRisGetNameSet="ID" d
	...s AssiantDoc=$p(^CTPCP(AssiantDocDr,1),"^",3)
	..else  d
	...s AssiantDoc=$p(^CTPCP(AssiantDocDr,1),"^",2)
	.s RegEQDr=$p(Info,"^",14)
	.i RegEQDr'="" s RegEQ=$p(^RBC("EQ",RegEQDr),"^",2)
	.s RegDate=$p(Info,"^",8)
	.s RegDate=$zd(RegDate,3)
	.s RegTime=$p(Info,"^",9)
	.s RegTime=$zt(RegTime,1)
	.s Index=$p(Info,"^",15)
	.s Num=0
	.s ChildSub=0  f  s ChildSub=$o(^DHCPACRegInfoBD("BODYPARTS",0,rowid,ChildSub)) q:ChildSub=""  d
	..s BodyDr=$p(^DHCPACRegInfoBD("BODYPARTS",0,rowid,ChildSub),"^",1) 
	..i BodyDr'="" d
	...s Num=Num+1
	...s BodyDesc=$p(^MRC("BODP",BodyDr),"^",2)
	...s BodyInfo=BodyInfo_BodyDr_":"_BodyDesc_"~"
	.s returnInfo=No_"^"_StudyNo_"^"_MainDocDr_"^"_MainDoc_"^"_AssiantDocDr_"^"_AssiantDoc_"^"_RegEQDr_"^"_RegEQ_"^"_RegDate_"^"_RegTime_"^"_Index_"^"_Num_"@"_BodyInfo           
	q returnInfo
}

ClassMethod GetOrdDate(OrditmRowid)
{
	s Oeodrowid=$p(OrditmRowid,"||",1)
    s OeodChild=$p(OrditmRowid,"||",2)
    s ordate=$p(^OEORD(Oeodrowid,"I",OeodChild,3),"^",7)
    i ordate'="" s ordate=$zd(ordate,3)
    q ordate
}

ClassMethod updatenumber(rowid, Number)
{
	&sql(update DHCRB_StudyNo_Createrule set RSC_MaxNumber=:Number where RSC_Rowid =:rowid)
	q SQLCODE
}

Query GetCancelReason(Locrowid As %String) As %Query(ROWSPEC = "desc:%String,rw:%String")
{
}

ClassMethod GetCancelReasonExecute(ByRef qHandle As %Binary, Locrowid As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s resrowid=0 f  s resrowid=$o(^DHCRBRR("Reason",0,resrowid)) q:(resrowid="")  d
	.s ResInfo=$p(^DHCRBRR("Reason",0,resrowid),"^",1)
	.Do OutCancelReason
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutCancelReason
	set Data=$lb(ResInfo,resrowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetCancelReasonFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCancelReasonExecute ]
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

ClassMethod GetCancelReasonClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCancelReasonExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod UnRegister(OEordDr, Reason, LocDR, usercode, price)
{
	s ^aa=OEordDr_"^"_Reason_"^"_LocDR_"^"_usercode
	
	s date1=+$h,time1=$p($h,",",2)
	s rrowid=""
	TSTART
	&sql(delete from DHCRB_RegInfo where RAR_OEORI_DR=:OEordDr)
    
    ;I SQLCODE TRollBack  Quit SQLCODE
   	
   	&sql(delete from OE_OrdResult where RES_ParRef=:OEordDr)
	&sql(select OSTAT_RowId into :StatusDr from OEC_OrderStatus where  OSTAT_Code='V')
	&sql(update OE_OrdItem set OEORI_ItemStat_DR=:StatusDr where OEORI_RowId=:OEordDr)
    I SQLCODE TRollBack  Quit SQLCODE
    s userid=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(usercode),""))
    if Reason'="" d
    .&sql(select DBRR_Rowid into :rrowid  from DHCRB_ReturnReason where DBRR_Reason=:Reason)
    .i (rrowid="") d 
    ..&sql(insert into DHCRB_ReturnReason (DBRR_Reason)values(:Reason))
    ..&sql(select DBRR_Rowid into :rrowid  from DHCRB_ReturnReason where DBRR_Reason=:Reason)
    
    &sql(insert into  DHCRB_ReturnFee(DRBR_Reason_DR,DRBR_Loc_DR,DRBR_OEORDITEM_DR,DRBR_DATE,DRBR_Time,DRBR_USSER_DR,DRBR_TotalPrice)
    							values (:rrowid,:LocDR,:OEordDr,:date1,:time1,:userid,:price))
    I SQLCODE TRollBack  Quit SQLCODE
    TCOMMIT
	q SQLCODE
}

ClassMethod CheckPass(code, password)
{
 s userid=""
 i code="" q -5
 s userid=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(code),""))
 s userpass="",newpass=""
 i userid="" q -1
 /*
 s userpass=$p(^SSU("SSUSR",userid),"^",3)
 s newpass=##class(web.SSUser).Encrypt(password)
 i newpass'=userpass q -2
 */
 
 s ret=##class(web.SSUser).IsValidUser(code, password)
 if ret'=userid q -2
 q 0
}

ClassMethod UpdataOrdInfo(Userid, OrditmRowid, Status, ResultStatus)
{
  ;Status: 医嘱状态
  ;ResultStatus 当医嘱状态为执行状态时： 结果状态 R:报告状态,V:报告审核状态,RG:登记状态,H:发片状态
  s ^gpgp=Userid_"^"_OrditmRowid_"^"_Status_"^"_ResultStatus
  //k (Userid,OrditmRowid,Status,ResultStatus)
  //q:$g(OrditmRowid)=""
  //q:$g(Status)=""
  s Oeodrowid=$p(OrditmRowid,"||",1)
  s OeodChild=$p(OrditmRowid,"||",2)
  ; 获得系统的当前日期?时间
  s CurrDate=$p($h,",",1)
  s CurrTime=$p($h,",",2)
  s reccount=0
  &sql(update OE_OrdItem set OEORI_ItemStat_DR=:Status where OEORI_RowId=:OrditmRowid)
 
  s Statdr=$o(^OEC("RESST",0,"Code",$$ALPHAUP^SSUTIL4(ResultStatus),0)) 
  q:Statdr="" 100
  ; 医嘱的结果状态
  &sql(select count(*) into :reccount from  OE_OrdResult  where  RES_ParRef =:OrditmRowid)
  
  if reccount=0 d 
	.&sql(insert into OE_OrdResult (RES_ParRef,RES_UserCreated,RES_ResStat_DR) values (:OrditmRowid,:Userid,:Statdr))
  else  d
	.&sql(select max(RES_Childsub) into :maxChildSub from OE_OrdResult where  RES_ParRef =:OrditmRowid )
	.s Resrowid1=OrditmRowid_"||"_$g(maxChildSub)
	.s Resrowid1=$g(Resrowid1)
	.s CProveDr=$p(^SSU("SSUSR",Userid),"^",14)
	.i ResultStatus="V" d
	..&sql(Update OE_OrdResult (RES_UserVerified, RES_DateVerified,RES_TimeVerified,RES_ResStat_DR,RES_FileName,RES_Type,RES_CPVerified_DR)values(:Userid,:CurrDate,:CurrTime,:Statdr,'\20050722\.wav','Voice',:CProveDr) where RES_Rowid=:Resrowid1)
	.else  if (ResultStatus="R")!(ResultStatus="H")  d   ;录入状态
	..&sql(Update OE_OrdResult (RES_LastUpdateUser_DR, RES_LastUpdateDate, RES_LastUpdateTime,RES_ResStat_DR,RES_FileName,RES_CPReported_DR,RES_Type)values(:Userid,:CurrDate,:CurrTime,:Statdr,'\20050722\.wav',:CProveDr,'Voice') where RES_Rowid=:Resrowid1)
	q SQLCODE
}

ClassMethod GetItemName(orditmrowid)
{
	q:orditmrowid=""
	s OErowid=$p(orditmrowid,"||",1)
	s Childsub=$p(orditmrowid,"||",2)
	s ItemMasterDr=$p(^OEORD(OErowid,"I",Childsub,1),"^",2)
	//^ARCIM({ARCIM_Subscript},{ARCIM_Version})    
	s Qty=$p(^OEORD(OErowid,"I",Childsub,1),"^",18)
	i Qty="" s Qty=1
	
	s subscript=$p(ItemMasterDr,"||",1)
	s version=$p(ItemMasterDr,"||",2)
	s ItemName=$p(^ARCIM(subscript,version,1),"^",2)
	s arcimid=subscript_"||"_version
	
	s paadmdr=$p(^OEORD(OErowid),"^",1)
	s SttDate=$p(^OEORD(OErowid,"I",Childsub,1),"^",9)  
	s arcimid=$p(^OEORD(OErowid,"I",Childsub,1),"^",2)
	s OEPrice=$p($g(^OEORD(OErowid,"I",Childsub,3)),"^",25)		;;取出P   价格 OE_OrdItem->OEORI_Price
	s instypedr=$p(^PAADM(paadmdr,1),"^",7) 
	s priceinfo=##class(web.UDHCJFPRICE).GetOrderPrice("", instypedr, arcimid, SttDate, "", "", "", OEPrice)
	s price=$p(priceinfo,"^",1)
	s Num=$p(^OEORD(OErowid,"I",Childsub,1),"^",12)
	s TotalPrice=price*Num
		
	q ItemName_"^"_TotalPrice_"^"_Num_"^"_price
}

ClassMethod GetStudyNO1(orditmrowid)
{
	s rowid=""
	s rowid =$o(^DHCPACRegInfoi("OEORI",orditmrowid,rowid))
	i (rowid'="")&(rowid'=0) d
	.s Info= ^DHCPACRegInfo(rowid)
	.s StudyNo=$p(Info,"^",2)
	q $g(StudyNo)
}

ClassMethod IniRegIndex()
{
	s Locrowid=0  f  s locrowid=$o(^DHCRisRegIndex(locrowid)) q:locrowid=""  d
	.s ^DHCRisRegIndex(locrowid)=0 
	q 0
}

ClassMethod GetCurentIndex(LocDr)
{
	i $g(^DHCRisRegIndex(LocDr))="" s ^DHCRisRegIndex(LocDr)=0
	s CurrentIndex=^DHCRisRegIndex(LocDr)+1
	q CurrentIndex
}

ClassMethod UpdateIndex(LocDr, Index, day)
{
  ;s ^AA=LocDr_"^"_Index_"^"_day
  s SQLCODE=0
  s getIndex=Index
  s rowid=0 f  s rowid=$o(^DHCPACRegInfoi("Loc-date",LocDr,day,rowid)) q:rowid=""  d 
   .s getIndex=$p(^DHCPACRegInfo(rowid),"^",15)
   .i getIndex="" s getIndex=0 
   .i (getIndex>=Index) d 
   ..s getIndex=getIndex+1
   ..&sql(update DHCRB_RegInfo set RAR_RegEQ_Index=:getIndex where RAR_Rowid=:rowid)
  
  i getIndex>Index  s ^DHCRisRegIndex(LocDr)=getIndex
  else  s ^DHCRisRegIndex(LocDr)=Index
  
  q SQLCODE
}

ClassMethod GetWeight(paadmrowid)
{
	s weight=""
	s mrrowid=$p(^PAADM(paadmrowid),"^",61)
	i mrrowid'="" s weight=$p(^MR(mrrowid,"PRO",1),"^",27)
	q weight
}

ClassMethod GetIPNo(paadmrowid)
{
	s IpNo="",TelNo=""
	s ErrMsg=""
	s patienttype=$p(^PAADM(paadmrowid),"^",2)
	s papatmasdr=$p(^PAADM(paadmrowid),"^",1)
	//s IpNo=$p(^PAPER(papatmasdr,"PAT",1),"^",22)
	s IpNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(paadmrowid,patienttype,.ErrMsg)
	s TelNo=$p(^PAPER(papatmasdr,"PER",1),"^",11) 
	q IpNo_"^"_TelNo
}

ClassMethod SendFilm(Userid, oeorditemrowid) As %String
{
 //发片
 s ret=##class(web.DHCRisRegisterPatientDo).UpdataOrdInfo(Userid, oeorditemrowid, "E", "H")
 q ret
}

}
