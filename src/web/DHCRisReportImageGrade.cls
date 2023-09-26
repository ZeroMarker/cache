Import SQLUser

Class web.DHCRisReportImageGrade Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// do ##class(web.DHCRisReportImageGrade).SaveStudyGrade("20017||3860^20017-38604^1^1^600")
ClassMethod SaveStudyGrade(Info As %String) As %String
{
	s ^t=Info
	s OeOrditemID=$p($g(Info),"^",1)
	s StudyNo=$p($g(Info),"^",2)
	s DoctorDR=$p($g(Info),"^",3)
	s ReportDesc=$p($g(Info),"^",4)
	s ImageDesc=$p($g(Info),"^",5)
	
	i (OeOrditemID'="")
	{
	  s StudyInfo=..GetStudyNo(OeOrditemID)
	}
	s RptDoctorID=$p($g(StudyInfo),"^",2)
	s ReLocID= $p($g(StudyInfo),"^",3)
	s Date=+$h
	s Time=$p($h,",",2)
	s ret="",SendMessage=""
	
	q:(OeOrditemID="") "-1"
	
	s rowid=""
 	&sql(select DRIG_Rowid into :rowid from DHCRBC_ReportImage_Grade where DRIG_OEOrdItem_DR =:OeOrditemID)
	i (rowid="") d
	 .&sql(insert into DHCRBC_ReportImage_Grade(DRIG_OEOrdItem_DR,DRIG_StudyNo,DRIG_Doctor_DR,DRIG_Grade_Date,DRIG_Grade_Time,DRIG_RptDoctor_DR,DRIG_RecLocDr)
	      values(:OeOrditemID,:StudyNo,:DoctorDR,:Date,:Time,:RptDoctorID,:ReLocID))
	 .s srowid=$p(%ROWID,$c(1))
     .i srowid'="" d
     ..s $p(^DHCRBCRIG("RptImgGrade",srowid),"^",3)=ReportDesc
     ..s $p(^DHCRBCRIG("RptImgGrade",srowid),"^",4)=ImageDesc
     ..s ^DHCRISISGRADE(OeOrditemID)="Y"
      
	e  d
	.&sql(update DHCRBC_ReportImage_Grade(DRIG_OEOrdItem_DR,DRIG_StudyNo,DRIG_Doctor_DR,DRIG_Grade_Date,DRIG_Grade_Time,DRIG_RptDoctor_DR)
	     values(:OeOrditemID,:StudyNo,:DoctorDR,:Date,:Time,:RptDoctorID) where DRIG_Rowid=:rowid)
	.s srowid=$p($g(%ROWID),$c(1))
    .i srowid'="" d
    ..s $p(^DHCRBCRIG("RptImgGrade",srowid),"^",3)=ReportDesc
    ..s $p(^DHCRBCRIG("RptImgGrade",srowid),"^",4)=ImageDesc
    ..s ^DHCRISISGRADE(OeOrditemID)="Y"
    
	q SQLCODE
}

/// do ##class(web.DHCRisReportImageGrade).GetGradeInfo("70882||375")
ClassMethod GetGradeInfo(oeorditemdr As %String) As %String
{
	s (ArcItemDesc,ReportDesc,ImageDesc,Date,Time,DoctorDR,DoctorDesc,arcimid)=""
	s (OrderRowid,arcimid,DRIGRowid,StudyNo,Info,RptImgInfo,StudyInfo)=""
	s (RptCode,ImgCode)=""
	q:(oeorditemdr="") "^^^^^^^^"
	
	s OrderRowid=$p(oeorditemdr,"||",1)
	s itemsub=$p(oeorditemdr,"||",2)
	s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)
    i arcimid'=""
    {
      s ArcItemDesc=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)
    }
    
    s DRIGRowid=$o(^DHCRBCRIGi("OeOrdItemID-Grade",oeorditemdr,0))
    i DRIGRowid'=""
    {
	  s ReportDesc=$p($g(^DHCRBCRIG("RptImgGrade",DRIGRowid)),"^",3)
	  s RptCode=..GetCodebyDesc(ReportDesc)
	  s ImageDesc=$p($g(^DHCRBCRIG("RptImgGrade",DRIGRowid)),"^",4)
	  s ImgCode=..GetCodebyDesc(ImageDesc)
	  s DoctorDR=$p($g(^DHCRBCRIG("RptImgGrade",DRIGRowid)),"^",5)
	  i DoctorDR'="" s DoctorDesc=$p($g(^SSU("SSUSR",DoctorDR)),"^",2)
	  s Date=$p($g(^DHCRBCRIG("RptImgGrade",DRIGRowid)),"^",6)
	  i Date'="" s Date=$zd(Date,3) 
	  s Time=$p($g(^DHCRBCRIG("RptImgGrade",DRIGRowid)),"^",7)
	  i Time'="" s Time=$zt(Time,1) 
	  
	}
	
	s StudyInfo=..GetStudyNo(oeorditemdr)
	s StudyNo=$p($g(StudyInfo),"^",1)
	
	s Info=StudyNo_"^"_ArcItemDesc_"^"_RptCode_"^"_ImgCode_"^"_DoctorDesc_"^"_Date_"^"_Time
	
	q Info
}

/// w ##class(web.DHCRisReportImageGrade).GetStudyNo("55918||1711")
ClassMethod GetStudyNo(OrdItemID As %String) As %String
{
	q:(OrdItemID="") ""
	s (StudyNo,RecLocID,Rptrowid,GetRptDocDR,Info)=""
	
	s Rowid=$o(^DHCPACRegInfoi("OEORI",OrdItemID,0))
	i Rowid'="" d
	.s RecLocID=$p($g(^DHCPACRegInfo(Rowid)),"^",13)
	.s StudyNo=$p($g(^DHCPACRegInfo(Rowid)),"^",2)
	.i StudyNo'="" d
	..s Rptrowid=$o(^DHCRBStudyi("Report","StudyNo",StudyNo,""),-1)
	..i Rptrowid'="" d
	...s GetRptDocDR=$p($g(^DHCRBStudy("Report",Rptrowid)),"^",8)
    s Info=StudyNo_"^"_GetRptDocDR_"^"_RecLocID
	
	q Info
}

/// w ##class(web.DHCRisclinicQueryOEItemDo).IsGrade("20017||3860")
ClassMethod IsGrade(OrdItemID As %String)
{
	 s IsSave="N"
	 
	 i ($d(^DHCRISISGRADE(OrdItemID)))
	 {
		 s IsSave=$g(^DHCRISISGRADE(OrdItemID))
	 }
	 
	 q IsSave
}

//按照时间查询评级

//w ##class(web.DHCRisReportImageGrade).GetGradeInfobydate("62920","62923")

ClassMethod GetGradeInfobydate(strDate As %String, endDate As %String) As %String
{
	s A=0,B=0,C=0,D=0,total=0
	k ^DHCRisTempGradeInfo
	k ^DHCRBCRIGtemp
	m ^DHCRBCRIGtemp=^DHCRBCRIG
	;s ^DHCRBCRIGtemp("RptImgGrade",5)=""
	for date=strDate:1:endDate
	{

		s Regrowid=0 
		f  s Regrowid=$o(^DHCRBCRIGi("GradeDate",date,Regrowid)) q:Regrowid=""  d
		.s OrditemRowid=$p($g(^DHCRBCRIGtemp("RptImgGrade",Regrowid)),"^",1)
		.s StudyNo=$p($g(^DHCRBCRIGtemp("RptImgGrade",Regrowid)),"^",2)
		.q:(OrditemRowid="")
		.q:(StudyNo="")
		.s Infos=""
		.s Infos=..GetVistyInfo(OrditemRowid,StudyNo)
		.s DoctorDR=$p($g(Infos),"^",1)
		.q:DoctorDR=""
		.s DoctorDesc=$p($g(Infos),"^",2)
		.;s DoctorDR=$p($g(^DHCRBCRIGtemp("RptImgGrade",Regrowid)),"^",5)
		.;q:DoctorDR=""
	    .;s DoctorDesc=$p($g(^SSU("SSUSR",DoctorDR)),"^",2)
	    .s ReportDesc=$p($g(^DHCRBCRIGtemp("RptImgGrade",Regrowid)),"^",3)
	    .q:ReportDesc=""
	    .s total=total+1
	    .i ((ReportDesc="非常满意")!(ReportDesc="优秀")) s A=A+1
	    .i ((ReportDesc="基本满意")!(ReportDesc="良好")) s B=B+1
	    .i ((ReportDesc="一般")!(ReportDesc="及格")) s C=C+1
	    .i ((ReportDesc="不满意")!(ReportDesc="差"))   s D=D+1
	    .;w !,Regrowid
	    .s Regrowid2=Regrowid
	    .f  s Regrowid2=$o(^DHCRBCRIGi("GradeDate",date,Regrowid2)) q:Regrowid2=""  d
	    ..;w !,Regrowid2
		..;s DoctorDR2=$p($g(^DHCRBCRIGtemp("RptImgGrade",Regrowid2)),"^",5)
		..s OrditemRowid=$p($g(^DHCRBCRIGtemp("RptImgGrade",Regrowid2)),"^",1)
		..s StudyNo=$p($g(^DHCRBCRIGtemp("RptImgGrade",Regrowid2)),"^",2)
		..q:(OrditemRowid="")
		..q:(StudyNo="")
		..s Infos=""
		..s Infos=..GetVistyInfo(OrditemRowid,StudyNo)
		..s DoctorDR2=$p($g(Infos),"^",1)
		..s DoctorDesc2=$p($g(Infos),"^",2)
		..q:DoctorDR'=DoctorDR2
		..s ReportDesc2=$p($g(^DHCRBCRIGtemp("RptImgGrade",Regrowid2)),"^",3)
	    ..q:ReportDesc2=""
	    ..s total=total+1
	    ..i ((ReportDesc2="非常满意")!(ReportDesc2="优秀")) s A=A+1
	    ..i ((ReportDesc2="基本满意")!(ReportDesc2="良好")) s B=B+1
	    ..i ((ReportDesc2="一般")!(ReportDesc2="及格")) s C=C+1
	    ..i ((ReportDesc2="不满意")!(ReportDesc2="差"))   s D=D+1
		..s ^DHCRBCRIGtemp("RptImgGrade",Regrowid2)=""
	    .for date2=date+1:1:endDate
	    ..s Regrowid1=0
	    ..f  s Regrowid1=$o(^DHCRBCRIGi("GradeDate",date2,Regrowid1)) q:Regrowid1=""  d
	    ...;s DoctorDR1=$p($g(^DHCRBCRIGtemp("RptImgGrade",Regrowid1)),"^",5)
	    ...s OrditemRowid=$p($g(^DHCRBCRIGtemp("RptImgGrade",Regrowid1)),"^",1)
		...s StudyNo=$p($g(^DHCRBCRIGtemp("RptImgGrade",Regrowid1)),"^",2)
		...q:(OrditemRowid="")
		...q:(StudyNo="")
		...s Infos=""
		...s Infos=..GetVistyInfo(OrditemRowid,StudyNo)
		...s DoctorDR1=$p($g(Infos),"^",1)
		...s DoctorDesc=$p($g(Infos),"^",2)
	    ...q:DoctorDR'=DoctorDR1
	    ...s ReportDesc1=$p($g(^DHCRBCRIGtemp("RptImgGrade",Regrowid1)),"^",3)
	    ...q:ReportDesc1=""
	    ...s total=total+1
	    ...i ((ReportDesc1="非常满意")!(ReportDesc1="优秀")) s A=A+1
	    ...i ((ReportDesc1="基本满意")!(ReportDesc1="良好")) s B=B+1
	    ...i ((ReportDesc1="一般")!(ReportDesc1="及格")) s C=C+1
	    ...i ((ReportDesc1="不满意")!(ReportDesc1="差"))   s D=D+1
	    ...s ^DHCRBCRIGtemp("RptImgGrade",Regrowid1)=""
	    .s Apart=$fn((A/total)*100,"",3)_"%",Bpart=$fn((B/total)*100,"",3)_"%",Cpart=$fn((C/total)*100,"",3)_"%",Dpart=$fn((D/total)*100,"",3)_"%"
	    .s ^DHCRisTempGradeInfo("Doctor",$J,DoctorDR)=$g(DoctorDR)_"^"_$J_"^"_$g(DoctorDesc)_"^"_$g(A)_"^"_$g(Apart)_"^"_$g(B)_"^"_$g(Bpart)_"^"_$g(C)_"^"_$g(Cpart)_"^"_$g(D)_"^"_$g(Dpart)_"^"_$g(total)
	    .s A=0,B=0,C=0,D=0,total=0
	
	}
     q $J
}

//评价报告统计

/// d ##class(%ResultSet).RunQuery("web.DHCRisReportImageGrade","QueryReportGrade","62920","62923")
Query QueryReportGrade(strDate As %String, endDate As %String) As %Query(ROWSPEC = "DoctorDr:%String,DoctorName:%String,Anum:%String,Aparts:%String,Bnum:%String,Bparts:%String,Cnum:%String,Cparts:%String,Dnum:%String,Dparts:%String,total:%String")
{
}

ClassMethod QueryReportGradeExecute(ByRef qHandle As %Binary, strDate As %String, endDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	s jpat=..GetGradeInfobydate(strDate,endDate)
	s DocDr=0 
	f  s DocDr=$o(^DHCRisTempGradeInfo("Doctor",jpat,DocDr)) q:DocDr=""  d
	.;s docdr=DocDr
	.s name=$p(^DHCRisTempGradeInfo("Doctor",jpat,DocDr),"^",3)
	.s A=$p(^DHCRisTempGradeInfo("Doctor",jpat,DocDr),"^",4)
	.s Apart=$p(^DHCRisTempGradeInfo("Doctor",jpat,DocDr),"^",5)
	.s B=$p(^DHCRisTempGradeInfo("Doctor",jpat,DocDr),"^",6)
	.s Bpart=$p(^DHCRisTempGradeInfo("Doctor",jpat,DocDr),"^",7)
	.s C=$p(^DHCRisTempGradeInfo("Doctor",jpat,DocDr),"^",8)
	.s Cpart=$p(^DHCRisTempGradeInfo("Doctor",jpat,DocDr),"^",9)
	.s D=$p(^DHCRisTempGradeInfo("Doctor",jpat,DocDr),"^",10)
	.s Dpart=$p(^DHCRisTempGradeInfo("Doctor",jpat,DocDr),"^",11)
	.s total=$p(^DHCRisTempGradeInfo("Doctor",jpat,DocDr),"^",12)
	.Do OutRow3
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutRow3
    
	set Data=$lb(DocDr,name,A,Apart,B,Bpart,C,Cpart,D,Dpart,total)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryReportGradeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryReportGradeExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

ClassMethod QueryReportGradeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryReportGradeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetCodebyDesc(Desc)
{
	  s Code=""
	  
	  i ((Desc="非常满意")!(Desc="优秀"))
	  {
		 s Code="A"
	  }elseif((Desc="基本满意")!(Desc="良好"))
	  {
		 s Code="B"
	  }elseif((Desc="一般")!(Desc="及格"))
	  {
		 s Code="C" 
	  }elseif ((Desc="不满意")!(Desc="差"))
	  {
		 s Code="D"
	  }
	  
	  q Code
}

/// w ##class(web.DHCRisReportImageGrade).GetVistyInfo("70882||375","U20130305-001")
ClassMethod GetVistyInfo(OrditemRowid As %String, StudyNo As %String) As %String
{
	s Rptrowid=0  f  s Rptrowid=$o(^DHCRBStudyi("Report","StudyNo",StudyNo,Rptrowid)) q:Rptrowid=""  d 
	.s GetVerifyDocDR="",GetVerifyDocName="",Info="",GetOrditemRowid=""
    .s GetVerifyDocDR=$p($g(^DHCRBStudy("Report",Rptrowid)),"^",11)
    .s GetOrditemRowid=$p($g(^DHCRBStudy("Report",Rptrowid)),"^",15)
    .i GetVerifyDocDR'="" s GetVerifyDocName=$p(^SSU("SSUSR",GetVerifyDocDR),"^",2)
    .i $g(^DHCRBStudy("Report",Rptrowid,"VeriedDoc"))'="" s GetVerifyDocName=$g(^DHCRBStudy("Report",Rptrowid,"VeriedDoc"))
    .q:(GetOrditemRowid'=OrditemRowid)
    .s Info=GetVerifyDocDR_"^"_GetVerifyDocName
    
    q $g(Info)
}

}
