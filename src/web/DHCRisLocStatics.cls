Import SQLUser

Class web.DHCRisLocStatics Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 202;

//Projection CPP As %Projection.CPP(ROOTDIR = "");

//

//

/// /
ClassMethod Updateflag(oeresrowid, flag1)
{
	s Ordrowid=$p(oeresrowid,"||",1)
	s Orditemrowid=$p(oeresrowid,"||",2)
	s Resrowid=$p(oeresrowid,"||",3)
	s ^OEORD(Ordrowid,"I",Orditemrowid,"RES",Resrowid,"TXT",0)=1
	s ^OEORD(Ordrowid,"I",Orditemrowid,"RES",Resrowid,"TXT",1)=flag1
	;&sql(Update OE_OrdResult set RES_Desc = :flag1 where RES_RowId=:oeresrowid)
	q 0
}

Query LocStatics(FLocation As %String, stdate As %String, eddate As %String, BodyPart As %String, Techician As %String, ReportDoc As %String, CheckDoc As %String) As %Query(ROWSPEC = "TDate:%String,TBodyPart:%String,TName:%String,TTechnician:%String,Treportdoc:%String,TCheckDoc:%String,Tincome:%String,Tfilm8:%String,Tfilm11:%String,Tfilm14:%String,TFlag:%String,Tordresultrowid:%String")
{
}

ClassMethod LocStaticsExecute(ByRef qHandle As %Binary, FLocation As %String, stdate As %String, eddate As %String, BodyPart As %String, Techician As %String, ReportDoc As %String, CheckDoc As %String) As %Status
{
	s ^test=FLocation_"^"_stdate_"^"_eddate_"^"_BodyPart_"^"_Techician_"^"_ReportDoc_"^"_CheckDoc
	;q:FLocation=""
	Set repid=$I(^CacheTemp)
	s ind=1
	s FilmCount=0    //胶片的数量
	s TotalFilmCount8=0,TotalFilmCount11=0,TotalFilmCount14=0
	s TotalInCome=0  //总的收入
	s reccount=0     //记录数
	s masculinecount=0 //阳性的数目
	s yyl=0
    s FindBody=0
    k ^PrintData
    i $g(^DHCRisGetNameSet)="" s ^DHCRisGetNameSet="ID"
   
 	if (FLocation'="") 
 	{
 	S locID=$o(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(FLocation),""))
 	f regdate=stdate:1:eddate d 
	.Set RowId=0	f  s RowId=$o(^DHCPACRegInfoi("RegDate",regdate,RowId)) q:RowId=""  d
	..s getVeriedDoc="",getReportDoc=""
	..s reglocdr=$p(^DHCPACRegInfo(RowId),"^",13)
	..i reglocdr=locID d 
	...s OeordDR=$p(^DHCPACRegInfo(RowId),"^",11)
	...q:OeordDR=""
	...s Paadmdr=$p(^DHCPACRegInfo(RowId),"^",10)
	...s patmasdr=$p(^PAADM($g(Paadmdr)),"^",1)
	...s patname=$p(^PAPER(patmasdr,"ALL"),"^",1)
    ...s FindBody=0,getBodyDesc=""
    ...s BodyRowid=0  f  s BodyRowid=$o(^DHCPACRegInfoBD("BODYPARTS",0,RowId,BodyRowid)) q:(BodyRowid="")!(FindBody=1)  d
    ....s Bodydr=$p(^DHCPACRegInfoBD("BODYPARTS",0,RowId,BodyRowid),"^",1)
    ....i Bodydr'="" d
    .....s getBodyDesc1=$p($g(^MRC("BODP",Bodydr)),"^",2)
    .....i getBodyDesc="" d
    ......s getBodyDesc=getBodyDesc1
    .....else  d
    ......s getBodyDesc=getBodyDesc_","_getBodyDesc1
    ....i (getBodyDesc1=BodyPart) s FindBody=1
    ...i (FindBody=1)!(BodyPart="") d
    ....s MainDr=$p(^DHCPACRegInfo(RowId),"^",5)
    ....i MainDr'="" d
    .....i ^DHCRisGetNameSet="ID" d
	......s getTechician=$p(^CTPCP(MainDr,1),"^",3)
	.....else  d
    ......s getTechician=$p(^CTPCP(MainDr,1),"^",2) ; 技师
    ....s getTechician=$g(getTechician)
    ....;------------------------------------------------------------------
    ...s StudyNo=$p(^DHCPACRegInfo(RowId),"^",2)  
    ...if StudyNo'="" d
    ....s Rptrowid=$o(^DHCRBStudyi("Report","StudyNo",StudyNo,""),-1)
    ....i Rptrowid'="" d
    .....s rptssdr=$p(^DHCRBStudy("Report",Rptrowid),"^",8) ;报告医生
    .....i rptssdr'="" d
    ......s ReportCPDr=$p(^SSU("SSUSR",rptssdr),"^",14) 
    ......;w "ReportCPDr"_ReportCPDr,!
    ......i ReportCPDr'="" d
    .......i ^DHCRisGetNameSet="ID" d
	........s getReportDoc=$p(^CTPCP(ReportCPDr,1),"^",3)
    .......else  d
	........s getReportDoc=$p($g(^CTPCP(ReportCPDr,1)),"^",2)
    .....;----------------------
    .....s rptssdr=$p(^DHCRBStudy("Report",Rptrowid),"^",11) ;审核医生
    .....i rptssdr'="" d
    ......s ReportCPDr=$p(^SSU("SSUSR",rptssdr),"^",14) 
    ......i ReportCPDr'="" d
    .......i ^DHCRisGetNameSet="ID" d
	........s getVeriedDoc=$p(^CTPCP(ReportCPDr,1),"^",3)
    .......else  d
	........s getVeriedDoc=$p($g(^CTPCP(ReportCPDr,1)),"^",2)
    ....i ($g(getTechician)=Techician)&&(Techician'="") d
    .....d OutputRow1
    ....i (ReportDoc=$g(getReportDoc))&&(ReportDoc'="") d
	.....d OutputRow1
	....i (CheckDoc'="")&&(CheckDoc=$g(getVeriedDoc)) d
	.....d OutputRow1
	....i (ReportDoc ="")&&(CheckDoc="")&&(Techician="") d 
	.....d OutputRow1
 	}else
 	{
	 	d outputdata
 	}
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRow1
  i $g(flag)="阳性"  d
   .s masculinecount=masculinecount+1
   s TotalAmount=0
   s count=0
   s FilmCount8=0,FilmCount11=0,FilmCount14=0
   s PBRowid=0  s PBRowid=$o(^DHCPBi(0,"OEORI",OeordDR,PBRowid))
   i (PBRowid'="") d 
   .s PBORowid=0  s PBORowid=$o(^DHCPBi(0,"OEORI",OeordDR,PBRowid,PBORowid))
   .i (PBORowid'="") d
   ..s TotalAmount=$p(^DHCPB(PBRowid,"O",PBORowid),"^",8)
   ..s TotalInCome=TotalInCome+TotalAmount
   ..s childsub=0 f  s childsub=$o(^DHCPB(PBRowid,"O",PBORowid,"D",childsub)) q:childsub=""  d
   ...s ItemNamedr=$p(^DHCPB(PBRowid,"O",PBORowid,"D",childsub),"^",3)
   ...i $g(ItemNamedr)'="" d
   ....s EMCCatDr=$p(^DHCTARI(ItemNamedr),"^",16)
   ....s ItemName=$p(^DHCTARI(ItemNamedr),"^",2)
   ....s ItemName=$$ALPHAUP^SSUTIL4(ItemName)
   ....s EMCCatName=$p(^DHCTarC("EC",EMCCatDr),"^",2)
   ....;w !,"^"_ItemName_"@"_EMCCatName
   ....i EMCCatName["胶片" d 
   .....s count=$p(^DHCPB(PBRowid,"O",PBORowid,"D",childsub),"^",5)
   .....i ItemName["8X10"  s FilmCount8=FilmCount8+count
   .....i ItemName["11X14" s FilmCount11=FilmCount11+count
   .....i ItemName["14X17" s FilmCount14=FilmCount14+count
   
outputdata
    i $g(regdate)'="" d
     .s TotalFilmCount8=TotalFilmCount8+FilmCount8
     .s TotalFilmCount11=TotalFilmCount11+FilmCount11
     .s TotalFilmCount14=TotalFilmCount14+FilmCount14
     .s Data=$lb($zd(regdate,3),$g(getBodyDesc),$g(patname),$g(getTechician),$g(getReportDoc),$g(getVeriedDoc),$g(TotalAmount),$g(FilmCount8),$g(FilmCount11),$g(FilmCount14),$g(flag),$g(ordresultrowid))
     .Set ^CacheTemp(repid,ind)=Data
     .s ^PrintData(ind)=$zd(regdate,3)_"^"_$g(getBodyDesc)_"^"_$g(patname)_"^"_$g(getTechician)_"^"_$g(getReportDoc)_"^"_$g(getVeriedDoc)_"^"_$g(TotalAmount)_"^"_$g(FilmCount8)_"^"_$g(FilmCount11)_"^"_$g(FilmCount14)_"^"_$g(flag)
     .s yyl=$j(masculinecount/ind,3,2)
   	 .set ^CacheTemp(repid,ind+1)=$lb("合计","总人数["_ind_"]","","","","",$g(TotalInCome),$g(TotalFilmCount8),$g(TotalFilmCount11),$g(TotalFilmCount14),$g(yyl),"")
   	 .s ^PrintData(ind+1)="合计"_"^"_"总人数["_ind_"]"_"^"_""_"^"_""_"^"_""_"^"_""_"^"_$g(TotalInCome)_"^"_$g(TotalFilmCount8)_"^"_$g(TotalFilmCount11)_"^"_$g(TotalFilmCount14)_"^"_$g(yyl)
   	 .s ^PrintData=ind+1
   	 .Set ind=ind+1
   quit
}

ClassMethod LocStaticsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LocStaticsExecute ]
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

ClassMethod GetNum() As %Integer
{
	q ^PrintData
}

ClassMethod GetData(i) As %String
{
	q ^PrintData(i)
}

ClassMethod LocStaticsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LocStaticsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetPath() As %String
{
	
	//&sql(select pathtoreports into :reportPath from websys.configuration)
	//q reportPath
}

}
