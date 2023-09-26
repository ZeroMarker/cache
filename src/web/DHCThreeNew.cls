Import SQLUser

Include Nur.DateFormat

Class web.DHCThreeNew Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Description : 提供给电子病历接口
/// Input :       患者就诊号 AdmId
/// Return ：     患者首次录入的体温、脉搏、呼吸、血压、体重数据
/// Table：       MR_Observations、MRC_ObservationItem
/// Others ：     体温:Item1、脉搏:Item7、呼吸:Item4、血压:Item5(收缩压),Item6(舒张压)、体重Item2
/// w ##class(web.DHCThreeNew).GetFirstPatInfo(8,"Item1")
ClassMethod GetFirstPatInfo(AdmID As %String, KeyWord As %String)
{
	
	s AdmDateTime=##class(web.DHCDischargeHistory).GetAdminDateTime(AdmID)
	i AdmDateTime'="" s AdmDate=$p(AdmDateTime,",",1) s AdmTime=$p(AdmDateTime,"^",2)
	s fromDt=AdmDate*100000+AdmTime
	s Ret=0
	s MRADMROWId=$P(^PAADM(AdmID),"^",61)   
	s offDay=-1
	f date=AdmDate:1:(+$h) {
		s itmdr=""  f  s itmdr=$O(^MR(MRADMROWId,"OBS",0,"Date",date,itmdr)) q:itmdr=""  d
		.s chl=""  f  s chl=$O(^MR(MRADMROWId,"OBS",0,"Date",date,itmdr,chl)) q:chl=""  d
		..s time=$P($G(^MR(MRADMROWId,"OBS",chl)),"^",4)
		..q:time=""
		..s nDT=date*100000+time
		..;q:(nDT<fromtime)
		..s P1=$P($G(^MR(MRADMROWId,"OBS",chl)),"^",2)
		..s Desc=$P($G(^MR(MRADMROWId,"OBS",chl)),"^",6)
		..s itmcode=$p($G(^MRC("OBITM",itmdr)),"^",1)
		..q:(itmcode="")!(KeyWord'=itmcode)
		..i P1'="" d
		...i offDay=-1 s Ret=P1 s offDay=$zabs(nDT-fromDt)
		...i $zabs(nDT-fromDt)<offDay s Ret=P1 s offDay=$zabs(nDT-fromDt)
	}
	q Ret
}

// 取最后一次生命体征

ClassMethod GetLastData(EpisodeID) As %String
{
	s ret=""
	 s MRADMROWId=$P(^PAADM(EpisodeID),"^",61)  
	// s lastDate="" 
	 k dataArr 
	 k sort
	  s lastDate=$O(^MR(MRADMROWId,"OBS",0,"Date",""),-1)
	  q:lastDate="" ""
	   s itmdr=""  f  s itmdr=$O(^MR(MRADMROWId,"OBS",0,"Date",lastDate,itmdr)) q:itmdr=""  d
	   .s chl=""  f  s chl=$O(^MR(MRADMROWId,"OBS",0,"Date",lastDate,itmdr,chl)) q:chl=""  d
	   ..s time=$P(^MR(MRADMROWId,"OBS",chl),"^",4)
	   ..s Value=$P(^MR(MRADMROWId,"OBS",chl),"^",2)
       ..s Desc=$P(^MR(MRADMROWId,"OBS",chl),"^",6)
	   ..s dataArr(time,itmdr)=Value  //最后一天按时间排序
	
	s time=""
	   s lastTime=$O(dataArr(""),-1)
	   q:(lastTime="") ""  //按输出顺序排序
	   s itmdr=""  f  s itmdr=$O(dataArr(lastTime,itmdr)) q:itmdr=""  d
	   .s code=$p(^MRC("OBITM",itmdr),"^",1)
	   .i (code="Item1")||(code="Item1")||(code="Item1") s sort(1,"T")=dataArr(lastTime,itmdr)
	   .i (code="Item7") s sort(2,"P")=dataArr(lastTime,itmdr)
	   .i (code="Item4") s sort(3,"R")=dataArr(lastTime,itmdr)
	   .i (code="Item5") s $p(sort(4,"BP"),"/",1)=dataArr(lastTime,itmdr)
	   .i (code="Item6") s $p(sort(4,"BP"),"/",2)=dataArr(lastTime,itmdr)
	
    
	   s i=$O(sort(0))
	   q:(i="") ""
	   s i=0  f  s i=$O(sort(i)) q:i=""  d
	    .s itemdesc="" f  s itemdesc=$O(sort(i,itemdesc)) q:itemdesc=""  d
	     ..s value=sort(i,itemdesc)
	     ..i ret="" s ret=itemdesc_value
	     ..e  s ret=ret_" "_itemdesc_value
	   
	   i (ret'="")  d 
	   .i (lastTime>25200)&&(lastTime<68400) s lastTimeStr="2PM"
	   .e  s lastTimeStr="6AM"
	   .s dtStr= lastTimeStr
	   .s ret=ret_" "_dtStr
	  
	  q ret
}

ClassMethod ListItemExecute(ByRef qHandle As %Binary, GrpCode As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
	s rw="",des="序号"
	Do OutwardRow2
	s rw="",des="登记号"
	Do OutwardRow2
	s rw="",des="姓名"
	Do OutwardRow2
	s rw="",des="床号"
	Do OutwardRow2
	
	s n=1
	s GrpRow="" s GrpRow=$O(^MRC("OBGRP",0,"Code",$ZConvert(GrpCode,"U"),GrpRow))
	if (GrpRow'=""){
		 s chl=0 f  s chl=$O(^MRC("OBGRP",GrpRow,"ITM",chl)) q:chl=""  d
		 .s itmrw=$P(^MRC("OBGRP",GrpRow,"ITM",chl),"^",1) 
		 .s sort=$P(^MRC("OBGRP",GrpRow,"ITM",chl),"^",2)
	     .s des=$p(^MRC("OBITM",itmrw),"^",2)
	     .s typ=$p(^MRC("OBITM",itmrw),"^",3)
	     .if sort="" s sort=n
	     .s itm(sort)=des_"^"_typ_"^"_itmrw
	     .s n=n+1
		}
	 s st="" f  s st=$O(itm(st)) q:st=""  d
	 .s des=$P(itm(st),"^",1)
	 .s typ=$P(itm(st),"^",2)
     .s rw=$P(itm(st),"^",3)
     .s des=des_"^"_typ
     .Do OutwardRow2
	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutwardRow2
	set Data=$lb(des,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod ListItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ListItemExecute ]
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

ClassMethod ListItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ListItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query ListItem(GrpCode As %String = "") As %Query(ROWSPEC = "desc,rw")
{
}

ClassMethod GetTimePointExecute(ByRef qHandle As %Binary, Adm As %String, CDate As %String, Grp As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
    s timstr=""
    s MRADMROWId=$P(^PAADM(Adm),"^",61) 
    s CDate=$ZDH(CDate,3)  
    s itmstr=##class(web.DHCPdaComm).GetOBInOutItm(Grp,.itm)
    s itmstr="^"_itmstr
    s itm=""  f  s itm=$O(^MR(MRADMROWId,"OBS",0,"Date",CDate,itm)) q:itm=""  d
    .q:itmstr'[itm
    .s chl=0  f  s chl=$O(^MR(MRADMROWId,"OBS",0,"Date",CDate,itm,chl)) q:chl=""  d
    ..s Ctim=$P(^MR(MRADMROWId,"OBS",chl),"^",4)
    ..s Ctim=$ZT(Ctim,1)
    ..q:(timstr[Ctim)&(timstr'="")
    ..s timstr=timstr_Ctim_"^"
    ..s id=chl,des=Ctim
    ..d out1
   	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
out1
	set Data=$lb(id,des)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetTimePointFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTimePointExecute ]
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

ClassMethod GetTimePointClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTimePointExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query GetTimePoint(Adm As %String, CDate As %String, Grp As %String) As %Query(ROWSPEC = "id,des")
{
}

ClassMethod GetOBInOutDataExecute(ByRef qHandle As %Binary, Adm As %String, StDate As %Library.Date, StTim As %Library.Date, EndDate As %String, EndTim As %String, Grp As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	Set qHandle=$lb(0,repid,0)
	if Adm="" Quit $$$OK
	//s ^TM(0)=CDate
	//获得体温,物理降温 ID
	//s ^TMP=$Lb( Adm, StDate, StTim, EndDate , EndTim, Grp )
	//s Grp="OutIn",Adm="1205"
	//s StDate="2008-5-28",EndDate="2008-5-29",StTim="1:11:48",EndTim="17:11:48"
	s StDate=$ZDH(StDate,3),EndDate=$ZDH(EndDate,3)
	s StTim=$ZTH(StTim,3)
	s EndTim=$ZTH(EndTim,3)

	s Mradm=$P(^PAADM(Adm),"^",61) 
	s itm=""
	s itmstr="^"_##class(web.DHCPdaComm).GetOBInOutItm(Grp,.itm)
	s GrpRow="" s GrpRow=$O(^MRC("OBGRP",0,"Code",$ZConvert(Grp,"U"),GrpRow))
    s StDtTim=##class(web.DHCPdaObserData).GetAbsTime(StDate_","_StTim)
    s EndDtTim=##class(web.DHCPdaObserData).GetAbsTime(EndDate_","_EndTim)
    s itmval=""
    s InAmount=0
    for Date=StDate:1:EndDate
    {
	s ItmDr=""  f  s ItmDr=$O(^MR(Mradm,"OBS",0,"Date",Date,ItmDr)) q:ItmDr=""  d
	.s inoutitm="^"_ItmDr_"^"
	.if itmstr'[inoutitm q
	.s IOTyp=$P(^MRC("OBITM",ItmDr),"^",6)
	.s typ=$P(^MRC("OBITM",ItmDr),"^",3)
	.s Name=$P(^MRC("OBITM",ItmDr),"^",2)
	.s chl=""  f  s chl=$O(^MR(Mradm,"OBS",0,"Date",Date,ItmDr,chl)) q:chl=""  d
	..s Value=$P(^MR(Mradm,"OBS",chl),"^",2)
	..s OBSD=$P(^MR(Mradm,"OBS",chl),"^",3)
	..s OBST=$P(^MR(Mradm,"OBS",chl),"^",4)
	..s Dt=##class(web.DHCPdaObserData).GetAbsTime(OBSD_","_OBST)
	..if (Dt<StDtTim)!(Dt>EndDtTim) q
	..s Desc=$P(^MR(Mradm,"OBS",chl),"^",6)
	..//q:typ'="N"  //数字类型才求和
	..//if IOTyp="O" s OutAmount=OutAmount+Value
	..if IOTyp="I" s InAmount=InAmount+Value
	..s itmval(ItmDr)=$G(itmval(ItmDr))+Value
	}
	//des_"^"_typ_"^"_""_"^"_itmrw
	s des="总入量",rw="",val=InAmount,typ="N"
	d OutwardRow1
	s num=""  f  s num=$O(itm(num)) q:num=""  d
	.s des=$P(itm(num),"^")
	.s typ=$P(itm(num),"^",2)
	.//q:typ'="N"
	.s rw=$P(itm(num),"^",4)
	.s val=$G(itmval(rw))
	.d OutwardRow1
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutwardRow1
	set Data=$lb(des,rw,val,typ)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetOBInOutDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOBInOutDataExecute ]
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

ClassMethod GetOBInOutDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOBInOutDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query GetOBInOutData(Adm, StDate As %Library.Date, StTim, EndDate As %Library.Date, EndTim, Grp = "") As %Query(ROWSPEC = "desc,rw,itemval,typ")
{
}

ClassMethod GetQueryData(QueryName As %String, parrm As %String, funname As %String) As %String
{
  //s a=##class(web.DHCNurseRecordComm).GetQueryData()
   //s QueryName="web.DHCNurseRecordComm:GetCareRec"
  // s parrm="parr$338155^2010-07-12^0:00^2010-07-18^18:00"
  // s funname="addLab"

   //s ^TT("a")=QueryName
   s l=$L(parrm,"!")
   s pp=""
   f i=1:1:l
   {
     s itm=$P(parrm,"!",i)
     s p=$P(itm,"$",1)
     s v=$P(itm,"$",2)
     s @p=v
     b
     if i<l s pp=pp_p_","
     e  s pp=pp_p 
     b
   }

   Set rset = ##class(%ResultSet).%New(QueryName)
   Set columns = rset.GetColumnCount()


 // Execute the query
  b
  s sc = rset.Execute(@pp)
  s i=0
  While (rset.Next()) {
       s coldata=""
       s rd="["
       For col = 1:1:columns {
	       s aa=rset.GetData(col)
	       s l=$L(aa,"^")
	       s colret="{"
	       for i=1:1:l
	       {
		     s vv=$P(aa,"^",i)
		     if vv="" continue
		     s na=$P(vv,"|",1)
		     s nv=$P(vv,"|",2)
		     s nv = ##class(ext.util.String).EvalJSON(nv)
		     s colret=colret_na_":'"_nv_"',"
		   }
          s colret=$e(colret,0,$l(colret)-1)
          s colret=colret_"}"
          //s rd=rd_colret_","
           // s coldata=coldata_"'"_$ZCVT(rset.GetData(col),"O","JS")_"',"
        }
        s coldata="'"_$ZCVT(colret,"O","JS")_"'"
  // s rd=$e(rd,0,$l(rd)-1)_"]"
  // s coldata=$e(coldata,0,$l(coldata)-1)
   s rtnval=funname_"("_coldata_");"
   b
  &javascript<#(rtnval)#>
 }
 Do rset.Close()
 //	    .//s rtnval=funname_"('"_$ZCVT($g(condep),"O","JS")_"','"_$ZCVT($g(status),"O","JS")_"','"_$ZCVT($P($g(bedcode),"@",2),"O","JS")_"','"_$ZCVT($g(appdep),"O","JS")_"','"_$ZCVT($g(inout),"O","JS")_"','"_$ZCVT($P($g(Diag),"@",2),"O","JS")_"','"_$ZCVT($g(condestinat),"O","JS")_"','"_$ZCVT($P($g(patname),"@",2),"O","JS")_"','"_$ZCVT($g(apptime),"O","JS")_"','"_$ZCVT($g(appdate),"O","JS")_"','"_$ZCVT($g(consultdate),"O","JS")_"','"_$ZCVT($g(contime),"O","JS")_"','"_$ZCVT($g(Adm),"O","JS")_"','"_$ZCVT($g(id),"O","JS")_"');"

 q 0
}

ClassMethod GetQueryData1(QueryName As %String, parrm As %String, funname As %String) As %String
{
  //s a=##class(web.DHCThreeNew).GetQueryData()
   //s QueryName="web.DHCTHREEEX.GetTimePoint"
   //s parrm=""
   //s funname="AddRec"

   //s ^TT("a")=QueryName
   s l=$L(parrm,"!")
   s pp=""
   f i=1:1:l
   {
     s itm=$P(parrm,"!",i)
     if itm="" continue
     s p=$P(itm,"$",1)
     s v=$P(itm,"$",2)
     s @p=v
     b
     if i<l s pp=pp_p_","
     e  s pp=pp_p 
   }

   Set rset = ##class(%ResultSet).%New(QueryName)
   Set columns = rset.GetColumnCount()


 // Execute the query
 
  if pp="" s sc=rset.Execute()
  else  s sc = rset.Execute(@pp)
  s i=0
  While (rset.Next()) {
	   i (i=0){
        For col = 1:1:columns {
         s head(col)=rset.GetColumnName(col)
        }
       }
       s coldata=""
       s rd="["
       s colret="{"
       For col = 1:1:columns {
	       s aa=rset.GetData(col)

		   s colret=colret_head(col)_":'"_aa_"',"
        }
        s colret=$e(colret,0,$l(colret)-1)
	    s colret=colret_"}"
        b //
        s coldata="'"_$ZCVT(colret,"O","JS")_"'"
  // s rd=$e(rd,0,$l(rd)-1)_"]"
  // s coldata=$e(coldata,0,$l(coldata)-1)
   s rtnval=funname_"("_coldata_");"
  &javascript<#(rtnval)#>
 }
 Do rset.Close()
 //	    .//s rtnval=funname_"('"_$ZCVT($g(condep),"O","JS")_"','"_$ZCVT($g(status),"O","JS")_"','"_$ZCVT($P($g(bedcode),"@",2),"O","JS")_"','"_$ZCVT($g(appdep),"O","JS")_"','"_$ZCVT($g(inout),"O","JS")_"','"_$ZCVT($P($g(Diag),"@",2),"O","JS")_"','"_$ZCVT($g(condestinat),"O","JS")_"','"_$ZCVT($P($g(patname),"@",2),"O","JS")_"','"_$ZCVT($g(apptime),"O","JS")_"','"_$ZCVT($g(appdate),"O","JS")_"','"_$ZCVT($g(consultdate),"O","JS")_"','"_$ZCVT($g(contime),"O","JS")_"','"_$ZCVT($g(Adm),"O","JS")_"','"_$ZCVT($g(id),"O","JS")_"');"

 q 0
}

ClassMethod getlocward(loc) As %String
{
  s ward=$O(^PAWARD(0,"WARD_LocationDR",loc,"")) 
  q ward
}

ClassMethod Patinfo(Adm As %String) As %String
{
		n (Adm)
		   s bedchl=""
		   s chl="" f  s chl=$o(^PAADM(Adm,"TRANS",chl)) q:chl=""  d
	       .s CurrentBedDR=$p(^PAADM(Adm,"TRANS",chl),"^",8)
	       .q:CurrentBedDR=""
	       .s bedchl=$P(CurrentBedDR,"||",2)
	       .s Ward=$P(CurrentBedDR,"||",1)
	       .s Bed=$P(^PAWARD(Ward,"BED",bedchl),"^",1)
	       q:bedchl="" ""
	       s Papmidr=$P(^PAADM(Adm),"^",1)
	       s ctlocdr=$P(^PAADM(Adm),"^",4)
	       s AdmDate=$ZD($P(^PAADM(Adm),"^",6),3)_" "_$ZT($P(^PAADM(Adm),"^",7))
	       s Name=$P(^PAPER(Papmidr,"ALL"),"^",1)
	       s RegNo=$P(^PAPER(Papmidr,"PAT",1),"^",1)
	       s wardloc=$P(^PAWARD(Ward),"^",5) //s name="F",cttypdes="NURSE"
           s birth=$p($g(^PAPER(Papmidr,"ALL")),"^",6)
           s age=##class(web.DHCCLCom).CalAge(birth,+$h)
           Set PatEncryptLevel=##class(web.DHCCLCom).GetPatEncryptLevel(Papmidr,"")
           Set EncryptLevel=$p(PatEncryptLevel,"^",1)
           Set PatLevel=$p(PatEncryptLevel,"^",2) 
	       //s Bed=$P(^PAWARD(Ward,"BED",bedchl),"^",1)
	       s adm(Bed)=Adm_"#"_Name_"#"_Bed_"#"_$G(ctlocdr)_"#"_$G(wardloc)_"#"_bedchl_"#"_$G(RegNo)_"#"_EncryptLevel_"#"_PatLevel
         q adm(Bed)
}

// d ##class(%ResultSet).RunQuery("web.DHCThreeNew","GetAllPatient","197^272^2017-08-18^14:00:00^^^Y")

ClassMethod GetAllPatientExecute(ByRef qHandle As %Binary, Parr As %String) As %Status
{
	    // n (Ward,RegNo)
	      Set repid=$I(^CacheTemp)
 	      s ind=1
 	      //s ^tempSC(8181)=Parr
 	      s Ward=$p(Parr,"^")
 	      s EpisodeID=$p(Parr,"^",2)
 	      s StrDate=$p(Parr,"^",3)
 	      s StrTime=$p(Parr,"^",4)
 	      s BabyFlag=$p(Parr,"^",5)
 	      s RegNo=$p(Parr,"^",6)
 	      s transFlag=$p(Parr,"^",7)
 	      s Ward=..getlocward(Ward)
 	      //按就诊ID只查询出院病人
 	      i (EpisodeID'="")&&(RegNo="") d
 	      .s admVisitStat=$p($g(^PAADM(EpisodeID)),"^",20)
		  .i admVisitStat'="D" s EpisodeID=""
	      if (Ward'="")&&(EpisodeID="")&&(transFlag'="Y")
	      {
	       s room="" 
	       f  s room=$O(^PAADMi("CurrWard",Ward,room)) q:room=""  d
	       .s RowId=""  f  s RowId=$O(^PAADMi("CurrWard",Ward,room,RowId)) q:RowId=""  d
	       ..s VistStatus=$P(^PAADM(RowId),"^",20)
	       ..q:VistStatus="D"
	       ..s pinfo=..Patinfo(RowId)
	       ..q:pinfo=""
     	   ..s Name=$P(pinfo,"#",2)
           ..;s Bed=$P(pinfo,"#",3)
           ..s BedDr=$p($g(^PAADM(RowId)),"^",73) ;$P(pinfo,"#",3)    	   
	       ..q:BedDr=""
    	   ..s bedchl=$P(BedDr,"||",2)
	       ..s WardDr=$P(BedDr,"||",1)
	       ..s Bed=$P($g(^PAWARD(WardDr,"BED",bedchl)),"^",1)
           ..s left=$P(pinfo,"#",5)
           ..s top=$P(pinfo,"#",6)
           ..s Adm=RowId
           ..s MotherAdm=$p($g(^PAADM(Adm)),"^",75)
    	   ..q:(MotherAdm="")&(BabyFlag="1")
    	   ..q:(MotherAdm'="")&(BabyFlag'="1")
           ..s PatRegNo=$P(pinfo,"#",7)
           ..s EncryptLevel=$P(pinfo,"#",8)
           ..s PatLevel=$P(pinfo,"#",9)
           ..s Data(top,left)=Adm_"^"_Name_"^"_Bed_"^"_PatRegNo_"^"_EncryptLevel_"^"_PatLevel
       	   ..//s ^DataQ(top,left)=Adm_"^"_Name_"^"_Bed_"^"_PatRegNo
	      
      	   s r="" f  s r=$O(Data(r)) q:r=""  d
           .s c=""  f  s c=$O(Data(r,c)) q:c=""  d
           ..s Adm=$P(Data(r,c),"^",1),Name=$P(Data(r,c),"^",2),Bed=$P(Data(r,c),"^",3),PatRegNo=$P(Data(r,c),"^",4)
           ..s EncryptLevel=$P(Data(r,c),"^",5),PatLevel=$P(Data(r,c),"^",6)
           ..s AdmDate=$$$ZD($P(^PAADM(Adm),"^",6),3)
           ..s aa=..getobjval(Adm,StrDate,StrTime)
	       ..s aa="Adm|"_Adm_"^PatName|"_Name_"^BedCode|"_Bed_"^RegNo|"_PatRegNo_"^EncryptLevel|"_EncryptLevel_"^PatLevel|"_PatLevel_"^AdmDate|"_AdmDate_"^"_aa
           ..d OutPat

	      }
	      if ((EpisodeID'="")!(RegNo'=""))&&(transFlag'="Y")
	      {        
	      		
	      		   s RowId=EpisodeID
	      		   s:(RegNo'="") RowId=..GetCurrAdm(RegNo)
	      		   q:RowId="" ""
		           s pinfo=..Patinfo(RowId)
	               q:pinfo="" ""
	               s outWardId = $p(^PAADM(EpisodeID),"^",70)
	               q:ward'=outWardId ""
	               s Reg=$P(pinfo,"#",7)
	               s Name=$P(pinfo,"#",2)
	               s Bed=$P(pinfo,"#",3)
	               s EncryptLevel=$P(pinfo,"#",8)
	               s PatLevel=$P(pinfo,"#",9)
	               s Adm=RowId
	               s MotherAdm=$p($g(^PAADM(Adm)),"^",75)
    	   		   q:(MotherAdm="")&(BabyFlag="1") ""
    	   		   q:(MotherAdm'="")&(BabyFlag'="1") ""
	               s aa=..getobjval(Adm,StrDate,StrTime)
	               s aa="Adm|"_Adm_"^PatName|"_Name_"^BedCode|"_Bed_"^RegNo|"_Reg_"^EncryptLevel|"_EncryptLevel_"^PatLevel|"_PatLevel_"^"_aa
					s ^TMPWXJ(Adm)=aa
	               d OutPat

		  }
	if (transFlag="Y"){
		s LocID=$p(Parr,"^")
		s admrowid=0 f  s admrowid=$o(^PAADMi("AdmTypeCurr","I",admrowid)) q:admrowid=""  d
		.q:$p(^PAADM(admrowid),"^",20)'="A"	 ;VisitStatus
		.s PAPMI = $p(^PAADM(admrowid),"^",1)
		.S:$d(^PAPER(PAPMI,"PAT",1)) PatientNo=$P(^PAPER(PAPMI,"PAT",1),"^",1)
		.s WardID = $O(^PAWARD(0,"WARD_LocationDR",LocID,""))
		.i $d(^PAPER(PAPMI,"PAT",1)),$$findAdmTransWard(admrowid,WardID),$p(^PAADM(admrowid),"^",70)'=WardID d
		..s RowId=admrowid          
		..s pinfo=..Patinfo(RowId)
		..q:pinfo=""
		..s Reg=$P(pinfo,"#",7)
		..s Name=$P(pinfo,"#",2)
		..s Bed=$P(pinfo,"#",3)
		..s EncryptLevel=$P(pinfo,"#",8)
		..s PatLevel=$P(pinfo,"#",9)
		..s Adm=RowId
		..s aa=..getobjval(Adm,StrDate,StrTime)
		..s aa="Adm|"_Adm_"^PatName|"_Name_"^BedCode|"_""_"^RegNo|"_Reg_"^EncryptLevel|"_EncryptLevel_"^PatLevel|"_PatLevel_"^"_aa
		..d OutPat	
		}	  
		  
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPat
	set Data=$lb(aa)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
	
findAdmTransWard(PAAdm,WardID)
	s find=0
	s child=0 f {
		s child=$O(^PAADM(PAAdm,"TRANS",child))
		Q:child=""
		s TransWardID=$P(^PAADM(PAAdm,"TRANS",child),"^",9)
		if TransWardID=WardID {
			s find=1
			Quit
		}
	}
	Q find
}

ClassMethod GetAllPatientFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAllPatientExecute ]
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

ClassMethod GetAllPatientClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllPatientExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query GetAllPatient(Parr As %String) As %Query(ROWSPEC = "aa")
{
}

/// Creator：     于淼
/// CreatDate：   2014-10-31
/// Description： 插入生命体征数据
/// Table：       MR_Observations
/// Input：       @Adm:病人就诊号 @parr:生命体征蚕食 @user:用户ID @indate:测量生命体征数据日期"2014-10-31" @intime:测量生命体征数据时间"10:00:00"
/// param：       s parr="PatName|姓名^Item1|42^Item2|122^"
/// w ##class(web.DHCThreeNew).InsertOBSData(550,parr,11,"2014-10-31","10:00:00")
ClassMethod InsertOBSData(EpisodeID, parr As %String, user, indate, intime) As %String
{
	n (EpisodeID, parr , user, usergroup, indate, intime)
	s temp="Item1" //体温
	s wultemp="Item22" //物理降温
	s blankitm=##class(User.DHCThreeBlankLabel).getBlankItm() 
	s blank=""
	s l=$L(blankitm,"^")
	s Blank=""
	for i=1:1:l
	{
		s itm=$P(blankitm,"^",i)
		s code=$P(itm,"|",1)
		s Blank(code)=""
	}
	s l=$L(parr,"^")
	for i=1:1:l
	{
	  s itm=$P(parr,"^",i)
	  if itm="" continue
	  s flag=0
	  s name=$P(itm,"|")
	  if name=wultemp 
	  {
		  s ^TMP("codetemp")=itm
		  s flag=1
		  s name=temp
	  }
	  if $D(Blank(name))
	  {
		  d ..SaveBlank(EpisodeID,name,$P(itm,"|",2))
		  }
	  if $D(Blank(name)) continue  //空白项标题退出
	  s val=$P(itm,"|",2)
	  s itmdr=##class(web.DHCThreeNew).getItmDr(name)
	  if itmdr="" continue
	  if name="Adm" continue   //物理降温插在备注
	  
	  if flag=1 s r=##class(web.DHCTHREEE).InsertDesc(EpisodeID,itmdr,indate,intime,user,val)
	  e  s r=##class(web.DHCTHREEE).InsertData(EpisodeID,itmdr,indate,intime,user,val)
	}
	q 0
}

/// d ##class(web.DHCThreeNew).Save(550,parr,11,"DHCNUR6",23,"2014-03-17","10:00:00")
ClassMethod Save(EpisodeID, parr As %String, user, RecTyp, usergroup, indate, intime) As %String
{
   //##class(web.DHCTHREEE).InsertData()##class(web.DHCTHREEE).InsertDesc(adm,itmdr,date,tim,user,val)
 	//w ##class(Nur.DHCNurseRecSub).Save("316213","CareDate|2010-08-27^CareTime|17:08^","4337","DHCNUR6")
	//s ^TMP("aa",EpisodeID)=$LB(EpisodeID, parr , user, RecTyp, usergroup, indate, intime)
	//s a=##class(web.DHCThreeNew).Save()
	n (EpisodeID, parr , user, RecTyp, usergroup, indate, intime)
	//s EpisodeID=325017
	//s parr=$list(^TMP("aa",EpisodeID),2)
	//s user=$list(^TMP("aa",EpisodeID),3)
	//s RecTyp=$list(^TMP("aa",EpisodeID),4)
	//s usergroup=$list(^TMP("aa",EpisodeID),5)
	//s indate=$list(^TMP("aa",EpisodeID),6)
	//s intime=$list(^TMP("aa",EpisodeID),7)
	//
	  s temp="Item1"  //体温与
	  s wultemp="Item22"   //物理降温
	  s pain="Item60",lpain="Item61"  //疼痛
	  s blankitm=##class(User.DHCThreeBlankLabel).getBlankItm() 
	  s blank=""
	  s l=$L(blankitm,"^")
	  s Blank=""
	  for i=1:1:l
	  {

	    s itm=$P(blankitm,"^",i)
	    s code=$P(itm,"|",1)
	    s codeDesc=$P(itm,"|",3)
	    s valDesc=$P(itm,"|",4)
	    s Blank(code)=codeDesc_"^"_valDesc
	  }

	s l=$L(parr,"^")
	 for j=1:1:l
    {
	    s itm=$P(parr,"^",j)
	    s code=$P(itm,"|",1)
	    s value=$P(itm,"|",2)
	    i code="Item1"  d  
	    .i ((value'="")&((value<36)!(value>37.3)))  s str=##class(web.DHCENS.EnsHISService).DHCHisInterface("S00000027",EpisodeID,"1")  ;腋温
	    i code="Item12"  d   
	    .i ((value'="")&((value<36.3)!(value>37.2)))  s str=##class(web.DHCENS.EnsHISService).DHCHisInterface("S00000027",EpisodeID,"1")   ;口温
	    i code="Item20"  d
	    .i ((value'="")&((value<36.5)!(value>37.7)))  s str=##class(web.DHCENS.EnsHISService).DHCHisInterface("S00000027",EpisodeID,"1")    ;肛温
	   }
	s ret=""
	//w parr,!
	for i=1:1:l
	{
	  s itm=$P(parr,"^",i)
	  if itm="" continue
	  s flag=0
	  s name=$P(itm,"|")
	  if name=wultemp 
	  {
		  s ^TMP("codetemp")=itm
		  s flag=1
		  s name=temp
		  
	  }
	  if name=lpain 
	  {
		  s ^TMP("codetemp")=itm
		  s flag=1
		  s name=pain
	  }

	  //if $D(Blank(name)) continue  //空白项标题退出
	  i $D(Blank(name)) d
	  .s labeldesc=$P(itm,"|",2)
	  .s labelid=##class(User.DHCThreeBlankLabel).SaveForWeb(EpisodeID,name,labeldesc,indate,user)
	  .i labelid=-2 d
	  ..i ret="" s ret="【"_$p(Blank(name),"^",2)_"】当前页已保存过数据不建议修改【"_$p(Blank(name),"^",1)_"】"
	  ..e  s ret=ret_"^"_"【"_$p(Blank(name),"^",2)_"】当前页已保存过数据不建议修改【"_$p(Blank(name),"^",1)_"】"
	  .continue
	  s val=$P(itm,"|",2)
	  s itmdr=..getItmDr(name)
	  if itmdr="" continue
	  if name="Adm" continue   //物理降温插在备注、
	  
	  if flag=1 s r=##class(web.DHCTHREEE).InsertDesc(EpisodeID,itmdr,indate,intime,user,val)
	  e  s r=##class(web.DHCTHREEE).InsertData(EpisodeID,itmdr,indate,intime,user,val)

	}
	q 0
}

/// w ##class(web.DHCThreeNew).Test()
ClassMethod Test() As %String
{
   s str="^TFOutputP|11^"
   i str["TFOutputP" q str
   e  q "qqq"
}

/// w ##class(web.DHCThreeNew).getItmDr("Item2")
ClassMethod getItmDr(itemcode As %String) As %String
{
   n (itemcode)
    s itemcode=$ZConvert(itemcode,"U")
    s rw=$O(^MRC("OBITM",0,"Code",itemcode,""))
   q rw
}

ClassMethod getobjval(RowId, StrDate, StrTime) As %String
{
    ///s a=##class(web.DHCThreeNew).getobjval()
	n (RowId,StrDate,StrTime) 
	 //s RowId=325017
	// s StrDate="2010-11-5"  
	// s StrTime="02:00:00"
	  s blankitm=##class(User.DHCThreeBlankLabel).getBlankItm() 
	  s blank=""
	  s l=$L(blankitm,"^")
	  s Blank=""
	  s temp="Item1"
	  s wultemp="Item22"
	  s pain="Item60",lpain="Item61"  //疼痛
	  s HP=""
	  for i=1:1:l
	  {
	    s itm=$P(blankitm,"^",i)
	    s code=$P(itm,"|",1)
	    s label=##class(User.DHCThreeBlankLabel).getlabel(RowId,code,StrDate)
	    //s ^TMP("code",RowId,code)=$LB(RowId,code,StrDate,label)
	    s tmp(code)=label
	    s Blank(code)=""
	  }
	  s StrDate=$ZDH(StrDate,3)
	  s StrTime=$ZTH(StrTime,3)  
	  s MRADMROWId=$P(^PAADM(RowId),"^",61)    
	  s itmdr=""  f  s itmdr=$O(^MR(MRADMROWId,"OBS",0,"Date",StrDate,itmdr)) q:itmdr=""  d
	  .s chl=""  f  s chl=$O(^MR(MRADMROWId,"OBS",0,"Date",StrDate,itmdr,chl)) q:chl=""  d
	  ..s time=$P(^MR(MRADMROWId,"OBS",chl),"^",4)
	  ..if time=StrTime d
	  ...s P1=$P(^MR(MRADMROWId,"OBS",chl),"^",2)
	  ...;s P1=$tr(P1," ","")
	  ...s Desc=$P(^MR(MRADMROWId,"OBS",chl),"^",6)
	  ...s itmcode=$p($G(^MRC("OBITM",itmdr)),"^",1)
	  ...q:$D(Blank(itmcode)) //如果空白栏已有值
	  ...s tmp(itmcode)=P1
	  ...if (Desc'="" )&(itmcode=temp) s tmp(wultemp)=Desc
	  ...if (Desc'="" )&(itmcode=pain) s tmp(lpain)=Desc
	  s ret=""
	   s k=""  
	  	f {
		   s k=$O(tmp(k))
		   q:k=""  
		   s tmp(k)=$ZCVT(tmp(k),"O","JS")
		   s ret=ret_k_"|"_tmp(k)_"^"
	  	  }
	  q ret
}

ClassMethod GetPatValue1(Adm As %String, StDate As %String, EndDate As %String) As %String
{
   //生命体征数据查询
	//n (Adm,StDate,EndDate)
	s Mradm=$P(^PAADM(Adm),"^",61) 
	s num=0
	//s nuitGridTim=86400/6
	//s gridw=UnitW/240  //(4小时)
	//s gridh=UnitH  //(每小格0.2度，4次)
    s Pulses="",Tw="",Breath=""
	f Date=StDate:1:EndDate
	{
		s num=num+1
		s ItmDr=""  f  s ItmDr=$O(^MR(Mradm,"OBS",0,"Date",Date,ItmDr)) q:ItmDr=""  d
		.s Name=$P(^MRC("OBITM",ItmDr),"^",2)
		.s chl=""  f  s chl=$O(^MR(Mradm,"OBS",0,"Date",Date,ItmDr,chl)) q:chl=""  d
		..s Value=$P(^MR(Mradm,"OBS",chl),"^",2)
		..s OBSD=$P(^MR(Mradm,"OBS",chl),"^",3)
		..s OBST=$P(^MR(Mradm,"OBS",chl),"^",4)
		..s Desc=$P(^MR(Mradm,"OBS",chl),"^",6)
		..s TimPos=(OBST/14400)
		..i (code="Item7")&(code="Item13") s Value=Value+20
		..i ((Name["体温"))&(Value'="")  d
		...  //时间方向位置 
		...s Value=$FN(((Value)),"",2)
		...i Desc'="" s Tw(num,OBST)=num_"^"_Value_"^"_TimPos_"^"_Desc_"#"    ;不是物理降温
		...e  s Tw(num,OBST)=num_"^"_Value_"^"_TimPos_"^"_"#"
		..i Name["脉搏"&(Value'="") d
		...s Value=$FN(((Value)),"",2)
		...s Pulses(num,OBST)=num_"^"_Value_"^"_TimPos_"^"_"#"  
		..i Name["呼吸"&(Value'="") d
    	...s Value=$FN(((Value)),"",2)
    	...s Breath(num,OBST)=num_"^"_Value_"^"_TimPos_"^"_"#" 
	}
	s d="" f  s d=$O(Tw(d)) q:d=""  d
    .s t=""  f  s t=$O(Tw(d,t)) q:t=""  d
    ..s Tw=$G(Tw)_Tw(d,t)
    
    s d="" f  s d=$O(Pulses(d)) q:d=""  d
    .s t=""  f  s t=$O(Pulses(d,t)) q:t=""  d
    ..s Pulses=$G(Pulses)_Pulses(d,t)
    
    s d="" f  s d=$O(Breath(d)) q:d=""  d
    .s t=""  f  s t=$O(Breath(d,t)) q:t=""  d
    ..s Breath=$G(Breath)_Breath(d,t)
    
    s Data=$G(Tw)_"&"_$G(Pulses)_"&"_$G(Breath)
	q Data
}

ClassMethod GetPatValue(Adm As %String, StDate As %String, EndDate As %String, DayNum) As %String
{
   //生命体征数据查询
   ////s a=##class(web.DHCThreeNew).GetPatValue("891","2019-01-16","2019-01-17","")
	n (Adm,StDate,EndDate,DayNum)
	//s Adm="337862"      //高压（收缩压）和低压（舒张压），
    //s StDate="2010-11-01"
	//s EndDate="2010-11-07"
	s ^TEMPZW("201712120946")=$lb(Adm,StDate,EndDate,DayNum)
	s StDate=$$$ZDH(StDate,3)
	s EndDate=$$$ZDH(EndDate,3)
	
	;获取患者分床时间
	s PatRet=##class(web.DHCADMQTREC).PACInPatDateBed(Adm)
	s PatADate=$P(PatRet,"^",1)
	s PatATime=$P(PatRet,"^",2)
	
	s ItemCodeStr="^breath^pulse^temperature^heartbeat^"
	
	s Mradm=$P(^PAADM(Adm),"^",61) 
	s num=0
	//s nuitGridTim=86400/6
	//s gridw=UnitW/240  //(4小时)
	//s gridh=UnitH  //(每小格0.2度，4次)
    //s Pulses="",Tw="",Breath=""
    s HPItm="sysPressure",LPItm="diaPressure"
    s KW="Item12", GW="rectemperature",YW="temperature" ,WR="Reason" //口温。肛温 .腋温,未测原因
    s WlTemp="phyCooling"
    s Pain="Item60",LPain="Item61",PWR="Item62" //疼痛,止痛后分数,疼痛未测原因
	f Date=StDate:1:EndDate
	{
		s num=DayNum(Date)
		s painDr=..getItmDr(Pain)
		//疼痛隔天后断开
		i (painDr'="")&&('$D(^MR(Mradm,"OBS",0,"Date",Date,painDr))) s TM(Pain,num,5)=num_"^-1"_$C(129)_"隔天^3^"_"#"	
		
		s ItmDr=""  f  s ItmDr=$O(^MR(Mradm,"OBS",0,"Date",Date,ItmDr)) q:ItmDr=""  d
		.q:'$D(^MRC("OBITM",ItmDr))
		.s code=$P(^MRC("OBITM",ItmDr),"^",1)
		.q:code=WlTemp
		.q:code=LPain //止痛后分值
		.i code=PWR s code=Pain //疼痛未测原因
		.s flag=""
    	.if code=KW  s flag="K"
		.if code=GW  s flag="G"
		.if code=YW  s flag="Y"
		.if (code=KW)!(code=GW)!(code=WR) s code=YW
	    .s chl=""  f  s chl=$O(^MR(Mradm,"OBS",0,"Date",Date,ItmDr,chl)) q:chl=""  d
		..s Value=$P(^MR(Mradm,"OBS",chl),"^",2)
		..;b ;;;
		..i Value=" " s Value=$replace(Value," ","")
		..s OBSD=$P(^MR(Mradm,"OBS",chl),"^",3)
		..s OBST=$P(^MR(Mradm,"OBS",chl),"^",4)
		..;安贞医院规则,入院事件之前的格子不显示数据
		..s OneOrTwoStr=##class(Nur.CommonInterface.Temperature).getOneOrTwoStrByDay()
		..i (PatATime'="")&&(OBSD=PatADate)&&(PatADate'="")&&(OBST<PatATime)&&(("^"_OneOrTwoStr_"^")'[("^"_ItmDr_"^")) d
		...s QtTimePos=##class(Nur.CommonInterface.Temperature).GetCurrTimePos(PatATime)
		...s OBSTImePos=##class(Nur.CommonInterface.Temperature).GetCurrTimePos(OBST)
		..e  s QtTimePos="",OBSTImePos=""
		..q:(QtTimePos'="")&&(OBSTImePos'="")&&(QtTimePos>OBST)&&(("^"_OneOrTwoStr_"^")'[("^"_ItmDr_"^"))
		..;q:(PatADate'="")&&(PatATime'="")&&(OBSD=PatADate)&&(OBST<PatATime)&&((PatATime-OBST)>14400)&&(ItemCodeStr[("^"_code_"^"))
		..;i (PatADate'="")&&(PatATime'="")&&(OBSD=PatADate)&&(OBST<PatATime)&&(((PatATime-OBST)<14400))&&(ItemCodeStr[("^"_code_"^")) d
		...;s QtTimePos=##class(Nur.CommonInterface.Temperature).GetCurrTimePos(PatATime)
		...;s OBST=QtTimePos
		..s Desc=$P(^MR(Mradm,"OBS",chl),"^",6)
		..s TimPos=(OBST/14400)
		..if ("^拒测^请假^外出^入睡^血透^检查"[Value)&&(Value'="") d
		...b ;;;
		...s flag=Value,Value="30"
		...;s TM("Item7",num,OBST)=num_"^"_Value_$C(129)_flag_"^"_TimPos_"^"_"#"
		...;s TM("Item13",num,OBST)=num_"^"_Value_$C(129)_flag_"^"_TimPos_"^"_"#"
		...s TM("temperature",num,OBST)=num_"^"_Value_$C(129)_flag_"^"_TimPos_"^"_"#"
		...s TM("pulse",num,OBST)=num_"^"_Value_$C(129)_flag_"^"_TimPos_"^"_"#"
		...;s TM("breath",num,OBST)=num_"^"_Value_$C(129)_flag_"^"_TimPos_"^"_"#" ;有问题,不能给呼吸赋值
		...s TM("heartbeat",num,OBST)=num_"^"_Value_$C(129)_flag_"^"_TimPos_"^"_"#"
		...;i (code'=Pain)&(code="temperature") d
		....;s flag=Value,Value="35"
		....;s TM("pulse",num,OBST)=num_"^"_Value_$C(129)_flag_"^"_TimPos_"^"_"#"
		....;s TM("heartbeat",num,OBST)=num_"^"_Value_$C(129)_flag_"^"_TimPos_"^"_"#"
		...;e  s flag=Value,Value="-1"
		..;if code=WR d
		...;s flag=Value  未测原因
		...;s Value=35  //为了断开曲线
		..
		..i (Value'="")  d
		...;  //时间方向位置
		...;//s Value=$FN(((Value)),"",2)
		...;i Desc'="" s TM(code,num,OBST)=num_"^"_Value_$C(129)_flag_"^"_TimPos_"^"_Desc_"#"    ;不是物理降温
		...;e  s TM(code,num,OBST)=num_"^"_Value_$C(129)_flag_"^"_TimPos_"^"_"#"
		...;新版物理降温改造
		...i code=YW d
		....s wlItmDR=$O(^MRC("OBITM",0,"Code",$ZCVT(WlTemp,"U"),""))
		....i wlItmDR'="" d
		....s coolSub=$o(^MR(Mradm,"OBS",0,"Item",wlItmDR,OBSD,OBST,""))
		....i coolSub'="" d
		.....s Desc=$p(^MR(Mradm,"OBS",coolSub),"^",2)
		.....i Desc[" " s Desc=$replace(Desc," ","")
		...i Desc'="" s TM(code,num,OBST)=num_"^"_Value_$C(129)_flag_"^"_TimPos_"^"_Desc_"#"    ;不是物理降温
		...e  d
		....i "height^weight"[code k TM(code,num) //身高体重一天只测一次,只取最后一次测量
		....s TM(code,num,OBST)=num_"^"_Value_$C(129)_flag_"^"_TimPos_"^"_"#"
		
		S GMSValue = ..GetAllergiesByDate(Adm,Date)
		s GmsTime=$p($h,",",2)
		i GMSValue'="" d
		.s flag="过敏史"
		.s TM("allergicHistory",num,GmsTime)=num_"^"_GMSValue_$C(129)_flag_"^"_"^"_"#"
		
	}
	 s Data=""
	 s d=""  f  s d=$O(TM(HPItm,d)) q:d=""  d
	 .s t=""  f  s t=$O(TM(HPItm,d,t)) q:t=""  d
	 ..s tpos=$P(TM(HPItm,d,t),"^",3)
	 ..if tpos'>3 s tpos="L" //左边
	 ..if tpos>3 s tpos="R"  //右边
	 ..s val=$P(TM(HPItm,d,t),"^",2)
	 ..s val=$p(val,$c(129),1)
	 ..q:('$D(TM(LPItm,d,t)))
	 ..if $D(TM(LPItm,d,t)) d
	 ...s val=val_"/"_$p($P(TM(LPItm,d,t),"^",2),$c(129),1)_$C(129)_tpos
#;	 ...i (val>140)||(val<90)||($p($P(TM(LPItm,d,t),"^",2),$c(129),1)>90)||($p($P(TM(LPItm,d,t),"^",2),$c(129),1)<60) d
#;	 ....s val="@@"_val_"/"_$p($P(TM(LPItm,d,t),"^",2),$c(129),1)_$C(129)_tpos //安贞医院体温单区分收缩压异常值,源码特殊处理
#;	 ...e  s val=val_"/"_$p($P(TM(LPItm,d,t),"^",2),$c(129),1)_$C(129)_tpos
	 ..s TM(HPItm,d,t)=d_"^"_val_"^"_tpos_"^#"
	
	 s d=""  f  s d=$O(TM(HPItm,d)) q:d=""  d
	 .s valstr=""
	 .s t=""  f  s t=$O(TM(HPItm,d,t)) q:t=""  d
	 ..s tpos=$P(TM(HPItm,d,t),"^",3)
	 ..s val=$P(TM(HPItm,d,t),"^",2)
	 ..q:(val["R")&&(valstr["R")
	 ..q:(val["L")&&(valstr["L") ;一天只填下午两次值时只显示下午一次的值
	 ..s valstr=valstr_val_","
	 .s TM(HPItm,d)=d_"^"_valstr_"^"_tpos_"^#"

	 s hp=""  //血压
	 s d=""  f  s d=$O(TM(HPItm,d)) q:d=""  d
	 .s hp=hp_TM(HPItm,d)
	 
	 s dm=""  f  s dm=$O(TM("pulse",dm)) q:dm=""  d
	 .s tm=""  f  s tm=$O(TM("pulse",dm,tm)) q:tm=""  d
	 ..i ($d(TM("pulse",dm,tm))) d
	 ...i '($d(TM("heartbeat",dm,tm)))  s TM("heartbeat",dm,tm)=TM("pulse",dm,tm)

	 s code="" f  s code=$O(TM(code)) q:code=""  d
	 .s ret=""
	 .q:code=HPItm
	 .q:code=LPItm
	 .s d=""  f  s d=$O(TM(code,d)) q:d=""  d
	 ..s t=""  f  s t=$O(TM(code,d,t)) q:t=""  d
	 ...s ret=ret_TM(code,d,t)
	 .s Data=Data_code_"|"_ret_"&"
	 s Data=HPItm_"|"_hp_"&"_Data
	b
	q Data
}

/// w ##class(web.DHCThreeNew).GetPatValue("550","2014-03-17","2014-10-17",1)
ClassMethod GetPatValueOld(Adm As %String, StDate As %String, EndDate As %String, DayNum) As %String
{
   //生命体征数据查询
   ////s a=##class(web.DHCThreeNew).GetPatValue()
	n (Adm,StDate,EndDate,DayNum)
	//s Adm="337862"      //高压（收缩压）和低压（舒张压），
    //s StDate="2010-11-01"
	//s EndDate="2010-11-07"
	s StDate=$$$ZDH(StDate,3)
	s EndDate=$$$ZDH(EndDate,3)
	
	s Mradm=$P(^PAADM(Adm),"^",61) 
	s num=0
	//s nuitGridTim=86400/6
	//s gridw=UnitW/240  //(4小时)
	//s gridh=UnitH  //(每小格0.2度，4次)
    //s Pulses="",Tw="",Breath=""
    s HPItm="sysPressure",LPItm="diaPressure"
    s KW="Item12", GW="rectemperature",YW="temperature" ,WR="Reason" //口温。肛温 .腋温,未测原因
    s WlTemp="phyCooling"
    s Pain="painInten",LPain="Item61",PWR="Item62" //疼痛,止痛后分数,疼痛未测原因
	f Date=StDate:1:EndDate
	{
		s num=DayNum(Date)
		s painDr=..getItmDr(Pain)
		//疼痛隔天后断开
		i (painDr'="")&&('$D(^MR(Mradm,"OBS",0,"Date",Date,painDr))) s TM(Pain,num,5)=num_"^-1"_$C(129)_"隔天^3^"_"#"	
		
		s ItmDr=""  f  s ItmDr=$O(^MR(Mradm,"OBS",0,"Date",Date,ItmDr)) q:ItmDr=""  d
		.q:'$D(^MRC("OBITM",ItmDr))
		.s code=$P(^MRC("OBITM",ItmDr),"^",1)
		.q:code=WlTemp
		.q:code=LPain //止痛后分值
		.i code=PWR s code=Pain //疼痛未测原因
		.s flag=""
    	.if code=KW  s flag="K"
		.if code=GW  s flag="G"
		.if code=YW  s flag="Y"
		.if (code=KW)!(code=GW)!(code=WR) s code=YW
	    .s chl=""  f  s chl=$O(^MR(Mradm,"OBS",0,"Date",Date,ItmDr,chl)) q:chl=""  d
		..s Value=$P(^MR(Mradm,"OBS",chl),"^",2)
		..s OBSD=$P(^MR(Mradm,"OBS",chl),"^",3)
		..s OBST=$P(^MR(Mradm,"OBS",chl),"^",4)
		..s Desc=$P(^MR(Mradm,"OBS",chl),"^",6)
		..s TimPos=(OBST/14400)

		..if ("^拒测^请假^外出^入睡^"[Value)&&(Value'="") d
		...;s flag=Value,Value="35"
		...;s TM("Item7",num,OBST)=num_"^"_Value_$C(129)_flag_"^"_TimPos_"^"_"#"
		...;s TM("Item13",num,OBST)=num_"^"_Value_$C(129)_flag_"^"_TimPos_"^"_"#"
		...i (code'=Pain)&(code="temperature") d
		....s flag=Value,Value="35"
		....s TM("Item7",num,OBST)=num_"^"_Value_$C(129)_flag_"^"_TimPos_"^"_"#"
		....s TM("Item13",num,OBST)=num_"^"_Value_$C(129)_flag_"^"_TimPos_"^"_"#"
		...e  s flag=Value,Value="-1"
		..;if code=WR d
		...;s flag=Value  未测原因
		...;s Value=35  //为了断开曲线
		..
		..i (Value'="")  d
		...  //时间方向位置
		...//s Value=$FN(((Value)),"",2)
		...i Desc'="" s TM(code,num,OBST)=num_"^"_Value_$C(129)_flag_"^"_TimPos_"^"_Desc_"#"    ;不是物理降温
		...e  s TM(code,num,OBST)=num_"^"_Value_$C(129)_flag_"^"_TimPos_"^"_"#"
		S GMSValue = ..GetAllergiesByDate(Adm,Date)
		s GmsTime=$p($h,",",2)
		i GMSValue'="" d
		.s flag="过敏史"
		.s TM("Item8",num,GmsTime)=num_"^"_GMSValue_$C(129)_flag_"^"_"^"_"#"
	}
	 s Data=""
	 s d=""  f  s d=$O(TM(HPItm,d)) q:d=""  d
	 .s t=""  f  s t=$O(TM(HPItm,d,t)) q:t=""  d
	 ..s tpos=$P(TM(HPItm,d,t),"^",3)
	 ..if tpos'>3 s tpos="L" //左边
	 ..if tpos>3 s tpos="R"  //右边
	 ..s val=$P(TM(HPItm,d,t),"^",2)
	 ..s val=$p(val,$c(129),1)
	 ..if $D(TM(LPItm,d,t)) d
	 ...s val=val_"/"_$p($P(TM(LPItm,d,t),"^",2),$c(129),1)_$C(129)_tpos
	 ..s TM(HPItm,d,t)=d_"^"_val_"^"_tpos_"^#"
	
	 s d=""  f  s d=$O(TM(HPItm,d)) q:d=""  d
	 .s valstr=""
	 .s t=""  f  s t=$O(TM(HPItm,d,t)) q:t=""  d
	 ..s tpos=$P(TM(HPItm,d,t),"^",3)
	 ..s val=$P(TM(HPItm,d,t),"^",2)
	 ..s valstr=valstr_val_","
	 .s TM(HPItm,d)=d_"^"_valstr_"^"_tpos_"^#"

	 s hp=""  //血压
	 s d=""  f  s d=$O(TM(HPItm,d)) q:d=""  d
	 .s hp=hp_TM(HPItm,d)
	 
	 s dm=""  f  s dm=$O(TM("Item7",dm)) q:dm=""  d
	 .s tm=""  f  s tm=$O(TM("Item7",dm,tm)) q:tm=""  d
	 ..i ($d(TM("Item7",dm,tm))) d
	 ...i '($d(TM("Item13",dm,tm)))  s TM("Item13",dm,tm)=TM("Item7",dm,tm)

	 s code="" f  s code=$O(TM(code)) q:code=""  d
	 .s ret=""
	 .q:code=HPItm
	 .q:code=LPItm
	 .s d=""  f  s d=$O(TM(code,d)) q:d=""  d
	 ..s t=""  f  s t=$O(TM(code,d,t)) q:t=""  d
	 ...s ret=ret_TM(code,d,t)
	 .s Data=Data_code_"|"_ret_"&"
	 s Data=HPItm_"|"_hp_"&"_Data
	b
	q Data
}

ClassMethod GetPatAllergy(Adm) As %String
{
  /////过敏记录、
	q $G(^DHCPatAllergy(Adm))
}

ClassMethod GetOBS(adm, datestr) As %String
{
  // 生命体征数据 s a=##class(web.DHCThreeNew).GetOBS()
  n (adm,datestr)
  //s adm=338155
  //s datestr="2009-9-23 0:00:00^2009-9-29 0:00:00|2009-9-30 0:00:00^2009-10-6 0:00:00|2009-10-7 0:00:00^2009-10-13 0:00:00|2009-10-14 0:00:00^2009-10-20 0:00:00|2009-10-21 0:00:00^2009-10-27 0:00:00|2009-10-28 0:00:00^2009-11-3 0:00:00|2009-11-4 0:00:00^2009-11-10 0:00:00|2009-11-11 0:00:00^2009-11-17 0:00:00|2009-11-18 0:00:00^2009-11-24 0:00:00|2009-11-25 0:00:00^2009-12-1 0:00:00|2009-12-2 0:00:00^2009-12-8 0:00:00|2009-12-9 0:00:00^2009-12-15 0:00:00|2009-12-16 0:00:00^2009-12-22 0:00:00|2009-12-23 0:00:00^2009-12-29 0:00:00|2009-12-30 0:00:00^2010-1-5 0:00:00|2010-1-6 0:00:00^2010-1-12 0:00:00|2010-1-13 0:00:00^2010-1-19 0:00:00|2010-1-20 0:00:00^2010-1-26 0:00:00|2010-1-27 0:00:00^2010-2-2 0:00:00|2010-2-3 0:00:00^2010-2-9 0:00:00|2010-2-10 0:00:00^2010-2-16 0:00:00|2010-2-17 0:00:00^2010-2-23 0:00:00|2010-2-24 0:00:00^2010-3-2 0:00:00|2010-3-3 0:00:00^2010-3-9 0:00:00|2010-3-10 0:00:00^2010-3-16 0:00:00|2010-3-17 0:00:00^2010-3-23 0:00:00|2010-3-24 0:00:00^2010-3-30 0:00:00|2010-3-31 0:00:00^2010-4-6 0:00:00|2010-4-7 0:00:00^2010-4-13 0:00:00|2010-4-14 0:00:00^2010-4-20 0:00:00|2010-4-21 0:00:00^2010-4-27 0:00:00|2010-4-28 0:00:00^2010-5-4 0:00:00|2010-5-5 0:00:00^2010-5-11 0:00:00|2010-5-12 0:00:00^2010-5-18 0:00:00|2010-5-19 0:00:00^2010-5-25 0:00:00|2010-5-26 0:00:00^2010-6-1 0:00:00|2010-6-2 0:00:00^2010-6-8 0:00:00|2010-6-9 0:00:00^2010-6-15 0:00:00|2010-6-16 0:00:00^2010-6-22 0:00:00|2010-6-23 0:00:00^2010-6-29 0:00:00|2010-6-30 0:00:00^2010-7-6 0:00:00|2010-7-7 0:00:00^2010-7-13 0:00:00|2010-7-14 0:00:00^2010-7-20 0:00:00|2010-7-21 0:00:00^2010-7-27 0:00:00|2010-7-28 0:00:00^2010-8-3 0:00:00|2010-8-4 0:00:00^2010-8-10 0:00:00|2010-8-11 0:00:00^2010-8-17 0:00:00|2010-8-18 0:00:00^2010-8-24 0:00:00|2010-8-25 0:00:00^2010-8-31 0:00:00|2010-9-1 0:00:00^2010-9-7 0:00:00|2010-9-8 0:00:00^2010-9-14 0:00:00|2010-9-15 0:00:00^2010-9-21 0:00:00|2010-9-22 0:00:00^2010-9-28 0:00:00|2010-9-29 0:00:00^2010-10-5 0:00:00|2010-10-6 0:00:00^2010-10-12 0:00:00|2010-10-13 0:00:00^2010-10-19 0:00:00|2010-10-20 0:00:00^2010-10-26 0:00:00|2010-10-27 0:00:00^2010-11-2 0:00:00|2010-11-3 0:00:00^2010-11-9 0:00:00|2010-11-10 0:00:00^2010-11-16 0:00:00|2010-11-17 0:00:00^2010-11-21 0:00:00|"
  s l=$L(datestr,"^")
  s data=""
  for i=1:1:l
  {
    s itm=$P(datestr,"|",i)
    if itm="" continue
    s std=$P(itm,"^",1)
    s edt=$P(itm,"^",2)
    //w !, std,"|",edt
   // b //
    s data=data_##class(web.DHCThreeNew).GetOBSData(adm,$P(std," "),$P(edt," "))_$C(1)
  }
  q data
}

/// w ##class(web.DHCThreeNew).GetOBSData("981","2019-1-16","2018-1-18")
ClassMethod GetOBSData(Adm As %String, StDate As %String, EndDate As %String) As %String
{
 //s a=##class(web.DHCThreeNew).GetOBSData()
  	n (Adm,StDate,EndDate)
  	s ^tempsc("GetOBSData")=$lb(Adm, StDate, EndDate)
	//s Adm="45"      //高压（收缩压）和低压（舒张压），
   // s StDate="2010-12-10"
  	//s EndDate="2010-12-10"

   s DM="",DayNum=""
   s ret=""
  // b //ss
   d ..PatLeave(Adm, StDate, EndDate,.DM,.DayNum)
   
   s n=""  f  s n=$O(DM(n)) q:n=""  d
   .s st=$P(DM(n),"^",1),ed=$P(DM(n),"^",2)
   .if $$$ZDH(st,3)=0 b
   .s ret=ret_..GetPatValue(Adm,st,ed,.DayNum)_"!"
   q ret
}

ClassMethod PatLeave(Adm As %String, StDate As %String, EndDate As %String, DM, DayNum)
{
	;Create by qse 2005-6-16 s a=##class(web.DHCThreeNew).PatLeave()
	n (Adm,StDate,EndDate,DM,DayNum)
	//s Adm="45"      //高压（收缩压）和低压（舒张压），
	//s StDate="2010-12-10"
  	//s EndDate="2010-12-10"
	s StDate=$$$ZDH(StDate,3)
	s EndDate=$$$ZDH(EndDate,3)
	/// 第一步：取得离院事件
	s seq=0
	k absence
	s Date="" f  s Date=$O(^PAADMi("LeaveDateFrom",Date)) q:(Date="")!(Date>EndDate)  d
	.s admlsub=""  f  s admlsub=$O(^PAADMi("LeaveDateFrom",Date,Adm,admlsub)) q:(admlsub="")  d
	..s DateOut=$p($g(^PAADM(Adm,"LEA",admlsub)),"^",2) // 这个实际就是Date
	..s DateReturn=$p($g(^PAADM(Adm,"LEA",admlsub)),"^",9)
	..i (DateReturn<DateOut) s DateReturn=DateOut // 返回日期更早则认为是当天
	..q:(DateOut<StDate)&(DateReturn'>StDate) // 即使外出日期在本周之前也要计算，如若返回日期比本周早则不算在内
	..i (DateOut<StDate) s DateOut=StDate-1 // 本周前实际从本周第一天开始，-1是为了去掉第一天
	..i (DateReturn>EndDate) s DateReturn=EndDate+1
	..i (DateReturn="") s DateReturn=EndDate+1 // 没有返回就是直到本周结束，+1是为了去掉末一天
	..s seq=seq+1
	..s absence(seq)=DateOut_"^"_DateReturn_"^"_admlsub
	/// 第二步：去掉包含关系
	s seq=0 f  s seq=$o(absence(seq)) q:(seq="")  d // 一定要遍历自己，因为录入顺序不一定是自然顺序，而且可能有包含关系
	.s DateOut=$p(absence(seq),"^",1)
	.s DateReturn=$p(absence(seq),"^",2)
	.s seq2=0  f  s seq2=$o(absence(seq2)) q:(seq2="")  d
	..q:(seq2=seq)
	..s DateOut2=$p(absence(seq2),"^",1)
	..s DateReturn2=$p(absence(seq2),"^",2)
	..q:(DateOut>DateOut2)
	..s quitflag=0
	..s curseq2=seq2
	..i (DateReturn'<DateReturn2) d // 包含直接去掉
	...s seq2=$o(absence(seq2),-1) // 回到前一个继续遍历
	...k absence(curseq2)
	...s quitflag=1
	..q:(quitflag=1)
	..i (DateReturn>DateOut2) d // 交叉直接合并
	...s seq2=$o(absence(seq2),-1) // 回到前一个继续遍历
	...s absence(seq)=DateOut_"^"_DateReturn2_"^"_$p(absence(seq),"^",3)
	...k absence(curseq2)
	...s quitflag=1
	..q:(quitflag=1)
	/// 第三步：计算可用区间
	/// 原方法也是从开始日期到第一个外出日期，返回日期到下一个外出日期为有效区间
	/// 现在只需要挑选中间的日期，然后计算区间
	/// 原方法并未计算时间
	k absent
	s seq=0 f  s seq=$o(absence(seq)) q:(seq="")  d
	.s DateOut=$p(absence(seq),"^",1)
	.s DateReturn=$p(absence(seq),"^",2)
	.s Date=DateOut f  s Date=Date+1 q:(Date'<DateReturn)  d
	..s absent(Date)=""
	s seq=0
	s Date=StDate-1 f  s Date=Date+1 q:(Date>EndDate)  d
	.s seq=seq+1 
   	.s DayNum(Date)=seq
	s seq=0
	s DateOne=StDate-1 f  q:(DateOne="")  d
	.s DateFrom=""
	.s DateEnd=""
	.s Date=DateOne f  s Date=Date+1 q:(Date>EndDate)!($d(absent(Date)))  d
	..i (DateFrom="") s DateFrom=Date
	.s DateOne=Date
	.i (Date>EndDate) s DateOne=""
	.i (DateFrom'="") d
	..s DateEnd=Date-1 // Date的值应是结束日期+1
	..s seq=seq+1
	..s DM(seq)=$ZD(DateFrom,3)_"^"_$ZD(DateEnd,3)
	q ""
}

/*ClassMethod PatLeave(Adm As %String, StDate As %String, EndDate As %String, DM, DayNum)
{
	;Create by qse 2005-6-16 s a=##class(web.DHCThreeNew).PatLeave()
	n (Adm,StDate,EndDate,DM,DayNum)
	//s Adm="45"      //高压（收缩压）和低压（舒张压），
    //s StDate="2010-12-10"
  	//s EndDate="2010-12-10"
	s StDate=$ZDH(StDate,3)
	s EndDate=$ZDH(EndDate,3)

   	s ret=""
   	s D1=StDate,D2=EndDate
   	s n=0
   	s num=0
   	f Date=StDate:1:EndDate
   	{ 
   	   s num=num+1 
   	   s DayNum(Date)=num
	   s admlsub=""  f  s admlsub=$O(^PAADMi("LeaveDateFrom",Date,Adm,admlsub)) q:admlsub=""  d
		.s DateReturn=$p($g(^PAADM(Adm,"LEA",admlsub)),"^",9)
		.s TimeReturn=$p($g(^PAADM(Adm,"LEA",admlsub)),"^",10)
		.if DateReturn="" q
		.s DateOut=$p($g(^PAADM(Adm,"LEA",admlsub)),"^",2)
		.s TimeOut=$p($g(^PAADM(Adm,"LEA",admlsub)),"^",3)
		.//s ret=DateOut_"|"_TimeOut_"^"_DateReturn_"|"_TimeReturn_"@"
		.s a1=D1,b1=DateOut,a2=DateReturn,b2=D2
		.s TM(n)=$ZD(a1,3)_"^"_$ZD(b1,3)_"|"_$ZD(a2,3)_"^"_$ZD(b2,3)
		.s n=n+1
		.s D1=a2,D2=b2
	}
	s j=0
	s n=""  f  s n=$O(TM(n)) q:n=""  d
	.s DM(j)=$P(TM(n),"|")
	.if '$D(TM(n+1)) d
	..s j=j+1
	..s DM(j)=$P(TM(n),"|",2)
	.s j=j+1
	if j=0 s DM(j)=$ZD(StDate,3)_"^"_$ZD(EndDate,3)
	//b 
	q ret
} */
ClassMethod GetEvents(Adm) As %String
{
	//s a=##class(web.DHCThreeNew).GetEvents()
	s data=""
	s num=1
	s ret=##class(web.DHCADMQTREC).QtPatAdmDate(Adm)
	s ret=..SyncEventByOrder(Adm)
	k TMP
	s rw=0 f  s rw=$O(^DHCADMQTREC("adm",Adm,rw)) q:rw=""  d
	.s ADate=$P(^DHCADMQTREC("QTREC",rw),"^",2)
	.s ATime=$P(^DHCADMQTREC("QTREC",rw),"^",3)
	.s TypDr=$P(^DHCADMQTREC("QTREC",rw),"^",4)
	.if ADate'="" s Date=$ZD(ADate,3)
	.if ATime'="" s Time=$ZT(ATime,2)
	.s timpos=ATime/14400
	.s pos=ATime\14400
	.i ((ATime>0)&(ATime<14400))||(ATime=0)          s pos=0
	.i ((ATime>14400)&(ATime<28800))||(ATime=14400)  s pos=1
	.i ((ATime>28800)&(ATime<43200))||(ATime=28800)  s pos=2
	.i ((ATime>43200)&(ATime<57600))||(ATime=43200)  s pos=3
	.i ((ATime>57600)&(ATime<72000))||(ATime=57600)  s pos=4
	.i ((ATime>72000)&(ATime<86400))||(ATime=72000)  s pos=5
	.s timpos=$FN(timpos,"",1)
	.if TypDr'="" s TypCode=$P($g(^DHCQTRECTYP("typ",TypDr)),"^",1)
	.if TypDr'="" s TypDes=$P($g(^DHCQTRECTYP("typ",TypDr)),"^",2)
	.s TMP(ADate,ATime,num)=pos_"^"_timpos_"^"_Date_"^"_Time_"^"_TypCode_"^"_TypDes
	.s num=num+1
    s date=""  f  s date=$O(TMP(date)) q:date=""  d
    .s tm=""  f  s tm=$O(TMP(date,tm)) q:tm=""  d
    ..s n=""  f  s n=$O(TMP(date,tm,n)) q:n=""  d
    ...s data=data_TMP(date,tm,n)_"|"
   q data
}

/// w ##class(web.DHCThreeNew).GetQtEvent("5906","QtItem1")
ClassMethod GetQtEvent(Adm, typ) As %String
{
	n (Adm, typ)
	d ##class(web.DHCADMQTREC).QtPatAdmDate(Adm)

 	s ret=""
 	s rw=0  f  s rw=$O(^DHCADMQTREC("adm",Adm,rw)) q:rw=""  d
	.s TypDr=$P(^DHCADMQTREC("QTREC",rw),"^",4)
	.if TypDr'="" s TypCode=$P($g(^DHCQTRECTYP("typ",TypDr)),"^",1)
	.q:TypCode'=typ
	.s ADate=$P(^DHCADMQTREC("QTREC",rw),"^",2)
	.s ATime=$P(^DHCADMQTREC("QTREC",rw),"^",3)
	.if ADate'="" s Date=$ZD(ADate,3)
	.if ATime'="" s Time=$ZT(ATime,2)
	.s ret=ret_Date_"^"_Time_"|"
	q ret
}

// 根据体温单事件维护的插入类型type插入不同的事件,flag为1表示 事件只能有一次  --pjf

ClassMethod SyncEvent(Adm, date, time, type, userId, flag = 0)
{
	
	s sub="" f  s sub=$o(^DHCQTRECTYP("typ",sub)) q:(sub="")!($g(tempThreeTypeDr)'="")  d
	.s QTRECTYPTyp=$p(^DHCQTRECTYP("typ",sub),"^",3)
	.q:QTRECTYPTyp'=type
	.s tempThreeTypeDr=sub
	q:$g(tempThreeTypeDr)="" 0
	
	i flag'=1 d
	.d ##class(web.DHCADMQTREC).QtInsert(Adm,$zd(date,3),$zt(time),tempThreeTypeDr,userId)
	
	//判断是否存在相同事件
	q:flag'=1 0
	s rw=0  f  s rw=$O(^DHCADMQTREC("adm",Adm,rw)) q:(rw="")!($g(existDr)'="")  d
	.s QTRECTYPDr=$P(^DHCADMQTREC("QTREC",rw),"^",4)
	.q:QTRECTYPDr=""
	.s QTRECTYPTyp=$p(^DHCQTRECTYP("typ",QTRECTYPDr),"^",3)
	.q:QTRECTYPTyp'=type
	.s existDr=QTRECTYPDr
	i $g(existDr)="" d
	.d ##class(web.DHCADMQTREC).QtInsert(Adm,$zd(date,3),$zt(time),tempThreeTypeDr,userId)
	q 0
}

// 删除事件 --pjf

ClassMethod DeleteEvent(Adm, type)
{
	
	s rw=0  f  s rw=$O(^DHCADMQTREC("adm",Adm,rw)) q:(rw="")!($g(existDr)'="")  d
	.s QTRECTYPDr=$P(^DHCADMQTREC("QTREC",rw),"^",4)
	.q:QTRECTYPDr=""
	.s QTRECTYPTyp=$p(^DHCQTRECTYP("typ",QTRECTYPDr),"^",3)
	.q:QTRECTYPTyp'=type
	.s existDr=rw
	q:$g(existDr)=""
	d ##class(web.DHCADMQTREC).QtDelete(existDr)
}

// 根据体温单事件维护的医嘱项code 插入事件  --pjf

// ##class(web.DHCThreeNew).SyncEventByOrder(172)

ClassMethod SyncEventByOrder(Adm)
{
	s tempArcimCode=[]
	s sub="" f  s sub=$o(^DHCQTRECTYP("typ",sub)) q:sub=""  d
	.s type=$p(^DHCQTRECTYP("typ",sub),"^",3)
	.q:type'="order"
	.s orderCode=$p(^DHCQTRECTYP("typ",sub),"^",4)
	.s orderCode=$replace(orderCode," ","")
	.q:orderCode=""
	.s num=$l(orderCode,"@")
	.f i=1:1:num d
	..s arcimCode=$p(orderCode,"@",i)
	..s tempThree(arcimCode)=sub
	..s ARCIMSubscript="",ARCIMVersion=""
	..s ARCIMSubscript=$o(^ARCIM(0,"Code",arcimCode,ARCIMSubscript))
	..q:ARCIMSubscript=""
	..s ARCIMVersion=$o(^ARCIM(0,"Code",arcimCode,ARCIMSubscript,ARCIMVersion))
	..s ItmMastDR=ARCIMSubscript_"||"_ARCIMVersion
	..d tempArcimCode.%Push(ItmMastDR)
	
	s sub=0  f  s sub=$O(^DHCADMQTREC("adm",Adm,sub)) q:(sub="")  d
	.s orderId=$P(^DHCADMQTREC("QTREC",sub),"^",8)
	.s oeordId=+orderId
	.s oeoriSub=+$p(orderId,"||",2)
	.q:(oeordId=0)!(oeoriSub=0)
	.s ordStatDR=$P($G(^OEORD(oeordId,"I",oeoriSub,1)),"^",13)
	.q:ordStatDR=""
	.s ordStatCode=$p(^OEC("OSTAT",ordStatDR),"^",1)
	.s arcimDr=$P($G(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)
	.q:arcimDr=""
	.s arcimCode=$P(^ARCIM(+arcimDr,$P(arcimDr,"||",2),1),"^",1)
	.i ((ordStatCode'="V")&&(ordStatCode'="E"))!($g(tempThree(arcimCode))="") d    //医嘱非核实非执行  或者 没有在体温单事件里配置的医嘱的事件都删除
	..d ##class(web.DHCADMQTREC).QtDelete(sub)
	.e  s order(orderId)=1
	
	s oeordId=$o(^OEORD(0,"Adm",Adm,0)) 
    q:oeordId="" ""
    s AdmDate = $p(^PAADM(Adm),"^",6)
   	q:AdmDate=""
   	set iter = tempArcimCode.%GetIterator()
   	while iter.%GetNext(.key, .value) {
		s ItmMastDR = value
		f SttDat=AdmDate:1:+$h d
		.s oeoriSub=0 f  s oeoriSub=$o(^OEORDi(0,"ARCIM",oeordId,ItmMastDR,SttDat,oeoriSub)) q:oeoriSub=""  d
		..q:$g(order(oeordId_"||"_oeoriSub))=1
    	..s ordStatDR=$P($G(^OEORD(oeordId,"I",oeoriSub,1)),"^",13) //20130122discontinue do GetXOrderItemSingle 
		..q:ordStatDR=""
		..s ordStatCode=$p(^OEC("OSTAT",ordStatDR),"^",1)
		..q:((ordStatCode'="V")&&(ordStatCode'="E"))
		..s arcimDr=$P($G(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)
		..q:arcimDr=""
		..s arcimCode=$P(^ARCIM(+arcimDr,$P(arcimDr,"||",2),1),"^",1)
		..q:$g(tempThree(arcimCode))=""
		..s tempThreeEventDr=tempThree(arcimCode)	
		..s date=$P($G(^OEORD(oeordId,"I",oeoriSub,1)),"^",9)
		..s date=$zd(date,3)
		..s time=$P($G(^OEORD(oeordId,"I",oeoriSub,1)),"^",10)
		..s time=$zt(time)
		..s userDr=$P($G(^OEORD(oeordId,"I",oeoriSub,7)),"^",1)
		..s typeDesc = $P($G(^DHCQTRECTYP("typ",tempThreeEventDr)),"^",2)
		..i ((typeDesc'="")&&(typeDesc["死亡"))  d
		...s paperId=+^PAADM(Adm)
		...&sql(select PAPER_Deceased_Date,PAPER_DeceasedTime into :date,:time from PA_Person where Paper_RowId=:paperId)
		...s date = $zd(date,3)
		...s time = $zt(time)
		..d ##class(web.DHCADMQTREC).QtInsert(Adm,date,time,tempThreeEventDr,userDr,oeordId_"||"_oeoriSub)
   	}
	q ""
}

ClassMethod getTime() As %String
{
 //w ##class(web.DHCThreeNew).getTime() //24/6
    //s ^TMP("gg")=a
    s tim(1)="0-4"
    s tim(2)="4-8"
    s tim(3)="8-12"
    s tim(4)="12-16"
    s tim(5)="16-20"
    s tim(6)="20-24"
    
    
	s intim=$ZT($P($H,",",2),2)
	s h=$P(intim,":")
	s minute=$P(intim,":",2)
	s intim=h+(minute/60)
	s p=1
	s n="" f  s n=$O(tim(n)) q:n=""  d
	.s st=$P(tim(n),"-",1)
	.s et=$P(tim(n),"-",2)
	.i (intim'<st)&(intim<et) s p=n
	//s nn=1
	//s num=$FN(intim*6/86400,"",1)
	//s num1=$FN(intim*6/86400,"",0)
	//if num1>num s nn=num1
	//e  s nn=num1
	//i nn'<6 s nn=1
	
	q p
}

ClassMethod GetPatTempDataExecute(ByRef qHandle As %Binary, Parr As %String) As %Status
{
	;s ^temp("sccc")=Parr
	Set repid=$I(^CacheTemp)
	s ind=1
	//d ##class(%ResultSet).RunQuery("web.DHCThreeNew","GetPatTempData","323^2017-09-18^2017-09-21")
	s EpisodeID=$p(Parr,"^",1)
	s StartDate=$p(Parr,"^",2)
	i StartDate["-" s StartDate=$ZDH(StartDate,3)
	i StartDate["/" s StartDate=$ZDH(StartDate,4)
	S startDate=$$$ZDH(StartDate,4)
	s EndTime=$p(Parr,"^",3)
	i EndTime["-" s EndTime=$ZDH(EndTime,3)
	i EndTime["/" s EndTime=$ZDH(EndTime,4)
	s EndTime=$$$ZDH(EndTime,4)
	for StrDate=StartDate:1:EndTime 
	{
		//空白栏
		s blankitm=##class(User.DHCThreeBlankLabel).getBlankItm() 
		s l=$L(blankitm,"^")
		k Blank
		for i=1:1:l
		{
			s itm=$P(blankitm,"^",i)
			s code=$P(itm,"|",1)
			s label=##class(User.DHCThreeBlankLabel).getlabel(EpisodeID,code,$ZD(StrDate,3))
			s Blank(code)=label
		}
		k tmp
		s temp="Item1"
		s wultemp="Item22"
		s pain="Item60",lpain="Item61"  //疼痛
		s MRADMROWId=$P(^PAADM(EpisodeID),"^",61)    
		s itmdr=""  f  s itmdr=$O(^MR(MRADMROWId,"OBS",0,"Date",StrDate,itmdr)) q:itmdr=""  d
		.s chl=""  f  s chl=$O(^MR(MRADMROWId,"OBS",0,"Date",StrDate,itmdr,chl)) q:chl=""  d
		..s time=$P($G(^MR(MRADMROWId,"OBS",chl)),"^",4)
		..q:time=""
		..s P1=$P($G(^MR(MRADMROWId,"OBS",chl)),"^",2)
		..s Desc=$P($G(^MR(MRADMROWId,"OBS",chl)),"^",6)
		..s itmcode=$p($G(^MRC("OBITM",itmdr)),"^",1)
		..q:itmcode=""
		..s tmp(time,itmcode)=P1
		..if (Desc'="" )&(itmcode=temp) s tmp(time,wultemp)=Desc
		..if (Desc'="" )&(itmcode=pain) s tmp(time,lpain)=Desc
		s aa=""
		s curTime="" f  s curTime=$O(tmp(curTime)) q:curTime=""  d
		.//显示日期与时间
		.s aa="RecDate|"_$$$ZD(StrDate,3)_"^RecTime|"_$ZT(curTime)_"^"
		.s startaa=aa
		.s curCode=""  f  s curCode=$O(tmp(curTime,curCode)) q:curCode=""  d
		..q:tmp(curTime,curCode)=""
		..s aa=aa_curCode_"|"_tmp(curTime,curCode)_"^"
		.s blankCode="" f  s blankCode=$O(Blank(blankCode)) q:blankCode=""  d
		..q:Blank(blankCode)=""
		..s aa=aa_blankCode_"|"_Blank(blankCode)_"^"
		.i aa'=startaa do OutPatDetail
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPatDetail
	set Data=$lb(aa)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
 /////////////////////////////////////////////////////////////////////
}

ClassMethod GetPatTempDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPatTempDataExecute ]
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

ClassMethod GetPatTempDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPatTempDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query GetPatTempData(Parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod GetPatTempDataNewExecute(ByRef qHandle As %Binary, Parr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	//d ##class(%ResultSet).RunQuery("web.DHCThreeNew","GetPatTempData","338155^2011-03-24^2011-03-24")
	s EpisodeID=$p(Parr,"^",1)
	s StartDate=$p(Parr,"^",2)
	i StartDate["-" s StartDate=$ZDH(StartDate,3)
	i StartDate["/" s StartDate=$ZDH(StartDate,4)
	S startDate=$$$ZDH(StartDate,4)
	s EndTime=$p(Parr,"^",3)
	i EndTime["-" s EndTime=$ZDH(EndTime,3)
	i EndTime["/" s EndTime=$ZDH(EndTime,4)
	s EndTime=$$$ZDH(EndTime,4)
	for StrDate=StartDate:1:EndTime 
	{
		//空白栏
		s blankitm=##class(User.DHCThreeBlankLabel).getBlankItm() 
		s l=$L(blankitm,"^")
		k Blank
		for i=1:1:l
		{
			s itm=$P(blankitm,"^",i)
			s code=$P(itm,"|",1)
			s label=##class(User.DHCThreeBlankLabel).getlabel(EpisodeID,code,$ZD(StrDate,3))
			s Blank(code)=label
		}
		k tmp
		s temp="Item1"
		s wultemp="Item22"
 		s pain="Item60",lpain="Item61"  //疼痛		
		s MRADMROWId=$P(^PAADM(EpisodeID),"^",61)    
		s itmdr=""  f  s itmdr=$O(^MR(MRADMROWId,"OBS",0,"Date",StrDate,itmdr)) q:itmdr=""  d
		.s chl=""  f  s chl=$O(^MR(MRADMROWId,"OBS",0,"Date",StrDate,itmdr,chl)) q:chl=""  d
		..s time=$P($G(^MR(MRADMROWId,"OBS",chl)),"^",4)
		..q:(time="")||(time'=25200)
		..s P1=$P($G(^MR(MRADMROWId,"OBS",chl)),"^",2)
		..s Desc=$P($G(^MR(MRADMROWId,"OBS",chl)),"^",6)
		..s itmcode=$p($G(^MRC("OBITM",itmdr)),"^",1)
		..q:itmcode=""
		..s tmp(time,itmcode)=P1
		..if (Desc'="" )&(itmcode=temp) s tmp(time,wultemp)=Desc
		..if (Desc'="" )&(itmcode=pain) s tmp(time,lpain)=Desc
		..if (itmcode="breath") s tmp(time,"Item4")=P1
		..if (itmcode="diaPressure") s tmp(time,"Item6")=P1
		..if (itmcode="pulse") s tmp(time,"Item7")=P1
		..if (itmcode="sysPressure") s tmp(time,"Item5")=P1
		..if (itmcode="temperature") s tmp(time,"Item1")=P1
		
		s aa=""
		s curTime="" f  s curTime=$O(tmp(curTime)) q:curTime=""  d
		.//显示日期与时间
		.s aa="RecDate|"_$$$ZD(StrDate,3)_"^RecTime|"_$ZT(curTime)_"^"
		.s curCode=""  f  s curCode=$O(tmp(curTime,curCode)) q:curCode=""  d
		..s aa=aa_curCode_"|"_tmp(curTime,curCode)_"^"
		.s blankCode="" f  s blankCode=$O(Blank(blankCode)) q:blankCode=""  d
		..s aa=aa_blankCode_"|"_Blank(blankCode)_"^"
		.do OutPatDetailnew
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPatDetailnew
	set Data=$lb(aa)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
 /////////////////////////////////////////////////////////////////////
}

ClassMethod GetPatTempDataNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPatTempDataNewExecute ]
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

ClassMethod GetPatTempDataNewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPatTempDataNewExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query GetPatTempDataNew(Parr As %String) As %Query(ROWSPEC = "aa")
{
}

/// w ##class(web.DHCThreeNew).getWardLoc(576)
ClassMethod getWardLoc(Adm) As %String
{
           s ward=$p(^PAADM(Adm),"^",70) 
	       s wardloc=$P(^PAWARD(ward),"^",5) 
	       q wardloc
}

ClassMethod GetIllDate(Adm As %String) As %String
{
	n (Adm)
  //患病日期 
  //w ##class(web.DHCThreeNewDT).GetIllDate(550)
	s illdate="",TypDr="",Typ=""
	s rw=0  f  s rw=$O(^DHCADMQTREC("adm",Adm,rw)) q:rw=""  d
	.s ADate=$P(^DHCADMQTREC("QTREC",rw),"^",2)
	.if ADate'="" s ADate=$ZD(ADate,3)
	.s ATime=$P(^DHCADMQTREC("QTREC",rw),"^",3)
	.if ATime'="" s ATime=$ZT(ATime,2)
	.s TypDr=$P(^DHCADMQTREC("QTREC",rw),"^",4)
	.if TypDr'="" s Typ=$P($G(^DHCQTRECTYP("typ",TypDr)),"^",2)
	.s:Typ="患病" illdate=ADate
	.q:illdate'=""
	q illdate
}

ClassMethod getIOItem(Adm) As %String
{
 //变动体征项目
   //s a=##class(web.DHCThreeNew).getIOItem
    s ward=##class(web.DHCThreeNew).getWardLoc(Adm)
    q:ward="" ""
    s ret=""
    s id="" f  s id=$O(^User.DHCQtIOItemD(id)) q:id=""  d
 	.s a=##class(User.DHCQtIOItem).%OpenId(id)
	.s flag=a.StopFlag
	.s des=a.ItmDesc
	.s rw=id
	.q:(ward'=a.WardId)&&(flag="Y")
	.s ret=ret_rw_"|"_des_"^"
	.b
	q ret
}

/// add 2014-11-15
Query FindCurWardPat(WardID As %String, LocID As %String, Flag As %String = "") As %Query(ROWSPEC = "patRegNo:%String,patName:%String,bedCode:%String,EpisodeID:%String")
{
}

ClassMethod FindCurWardPatExecute(ByRef qHandle As %Binary, WardID As %String, LocID As %String, Flag As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCThreeNew","FindCurWardPat","5","197","0")
	s repid=$i(^CacheTemp)
	s ^TempLYX("flag")=$lb(WardID,LocID,Flag)
	i WardID="" d
	.s logonLocType=$p($g(^CTLOC(LocID)),"^",13)
	.i logonLocType="W" d
	..s WardID=$o(^PAWARD(0,"WARD_LocationDR",LocID,""))
	.e  d
	..s chl=0 f  s chl=$O(^CTLOC(LocID,"LINK",chl)) q:chl=""  d
	...s link=$P(^CTLOC(LocID,"LINK",chl),"^",1)
	...s logonLocType=$p($g(^CTLOC(link)),"^",13)
	...i logonLocType="W" d
	....i WardID="" s WardID=$o(^PAWARD(0,"WARD_LocationDR",link,"")) 
	....e  s WardID=WardID_"^"_$o(^PAWARD(0,"WARD_LocationDR",link,""))
	i WardID="" s ind=1 s qHandle=$lb(0,repid,0) Quit $$$OK
	s ind=1
	s num=$l(WardID,"^")
	f i=1:1:num d
	.s wardId=$p(WardID,"^",i)
	.s curRoomId="" f  s curRoomId=$o(^PAADMi("CurrWard",wardId,curRoomId)) q:curRoomId=""  d
	..s EpisodeID=0 f  s EpisodeID=$o(^PAADMi("CurrWard",wardId,curRoomId,EpisodeID)) q:EpisodeID=""  d
	...s PatientID=$p($g(^PAADM(EpisodeID)),"^",1)
	...s patRegNo=$p($g(^PAPER(PatientID,"PAT",1)),"^",1)
	...s patName=$p($g(^PAPER(PatientID,"ALL")),"^",1)
	...q:(Flag="0")&(patName["之婴")
	...q:(Flag="1")&(patName'["之婴")
	...s bedSub=$p($g(^PAADM(EpisodeID)),"^",73)
	...i bedSub="" d
	....s chl="" f  s chl=$o(^PAADM(EpisodeID,"TRANS",chl),-1) q:(chl="")!(bedSub'="")  d
	.....s bedSub=$p(^PAADM(EpisodeID,"TRANS",chl),"^",8)
	...q:bedSub=""
	...s curWardId=$P(bedSub,"||",1)
	...s curBedSub=$P(bedSub,"||",2)
	...q:(curWardId="")!(curBedSub="")
	...s bedCode=$p($g(^PAWARD(curWardId,"BED",curBedSub)),"^",1)
    ...q:bedCode=""
    ...i bedCode'["床" s bedCode=bedCode_"床"
    ...s wAdmDr=$o(^PAWARDA(0,"WADM",EpisodeID,curWardId,""))
    ...s rAdmDr=$o(^PAWARDA(0,"RADM",EpisodeID,curWardId,""))
    ...i (wAdmDr'="")!(rAdmDr'="") s bedCode="       "
    ...s chargeStatus=##class(web.DHCDischargeHistory).GetCurrentDischargeStatus(EpisodeID)
    ...q:chargeStatus="R"
    ...;s x=$p($g(^PAWARD(curWardId,"BED",curBedSub)),"^",15)
    ...;s y=$p($g(^PAWARD(curWardId,"BED",curBedSub)),"^",16)
    ...;q:x=""
    ...;q:y=""
    ...s tmp(wardId,+bedCode,patName)=patRegNo_"^"_patName_"^"_bedCode_"^"_EpisodeID //Modify by liulei 20091118
    s no="" f  s no=$o(tmp(no)) q:no=""  d
    .s sub="" f  s sub=$o(tmp(no,sub)) q:sub=""  d
    ..s subT="" f  s subT=$o(tmp(no,sub,subT)) q:subT=""  d
    ...s patRegNo=$P(tmp(no,sub,subT),"^",1)
    ...s patName=$P(tmp(no,sub,subT),"^",2)
    ...s bedCode=$P(tmp(no,sub,subT),"^",3)_" "
    ...s EpisodeID=$P(tmp(no,sub,subT),"^",4)
	...d OutRowReg
	s qHandle=$lb(0,repid,0)
	q $$$OK

OutRowReg
	s Data=$lb(patRegNo,patName,bedCode,EpisodeID)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod FindCurWardPatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCurWardPatExecute ]
{
	s AtEnd=$li(qHandle,1)
	s repid=$li(qHandle,2)
	s ind=$li(qHandle,3)
	s ind=$o(^CacheTemp(repid,ind))
	i ind="" {				// if there are no more rows, finish fetching
		s AtEnd=1
		s Row=""
	}
	else {			
		s Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindCurWardPatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCurWardPatExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

ClassMethod getDateTime() As %String
{
  s date= $ZD(+$H,3)
  s tim=..getTime()
  q date_"^"_tim
}

/// update by linyuxu
/// CHFlag为true表示filepath带有http或者ftp头部，医生查房去体温单图片调用
/// CHFlag为false表示filepath不带http或者ftp头部，移动护理调用
ClassMethod GetTempatureImagPathExecute(ByRef qHandle As %Binary, adm As %String, CHFlag As %String = "true") As %Status
{
    s repid=$i(^CacheTemp)
    s ind=1
    i CHFlag="true"
    {
	    //s ftppath="http://192.168.191.1/ipad"
	    s ftppath=$G(^DHCDWRSET("NUR","FTP"))
	    s rw=""  f  s rw=$O(^Nur.DHCNURPATEMFPI("Adm"," "_adm,rw)) q:rw=""  d
	    .s a=##class(Nur.DHCNurPaTemperatureFilePath).%OpenId(rw)
	    .s filepath=ftppath_a.filePath   //a.filePath
	    .s weekno=a.weekno
	    .s tmp(weekno)=filepath
    }else
    {
	    s rw=""  f  s rw=$O(^Nur.DHCNURPATEMFPI("Adm"," "_adm,rw)) q:rw=""  d
	    .s a=##class(Nur.DHCNurPaTemperatureFilePath).%OpenId(rw)
	    .s filepath=a.filePath   //a.filePath
	    .s weekno=a.weekno
	    .s tmp(weekno)=filepath   
    }
    s w=""  f  s w=$O(tmp(w)) q:w=""  d
	.s filepath=tmp(w)
	.s weekno=w
	.d OutRowInfo1

    s qHandle=$lb(0,repid,0)
    q $$$OK
OutRowInfo1
    s Data=$lb(weekno,filepath)
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
    q
}

ClassMethod GetTempatureImagPathFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTempatureImagPathExecute ]
{
    s AtEnd=$li(qHandle,1)
    s repid=$li(qHandle,2)
    s ind=$li(qHandle,3)
    s ind=$o(^CacheTemp(repid,ind))
    i ind="" {              // if there are no more rows, finish fetching
        s AtEnd=1
        s Row=""
    }
    else {          
        s Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    q $$$OK
}

ClassMethod GetTempatureImagPathClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTempatureImagPathExecute ]
{
    s repid=$li(qHandle,2)
    k ^CacheTemp(repid)
    q $$$OK
}

Query GetTempatureImagPath(adm As %String, CHFlag As %String = "true") As %Query(ROWSPEC = "weekno,filepath")
{
}

/// /保存体温单项目名称
ClassMethod SaveBlank(EpisodeID As %String, Code As %String, Value As %String) As %String
{
	q:EpisodeID="" ""
	s Exception="^ ^.^"
	q:Exception[("^"_Value_"^") ""
	s admdate=$zd($p(^PAADM(EpisodeID),"^",6),3)
	s parr=EpisodeID_"^"_Code_"^"_Value_"^"_admdate
	d ##class(User.DHCThreeBlankLabel).save(parr)
	q ""
}

/// /日志审核及配置，存储打印记录
/// w ##class(web.DHCThreeNew).SavePrintRecord()
/// Input:预览开始日期串，预览截止日期串,打印开始日期串，打印结束日期串，就诊id，userid
ClassMethod SavePrintRecord(StartDateStr, ETDateStr, StPrintDateStr, ETPrintDateStr, StPrintPage, ETPrintPage, EpisodeID, UserId)
{
	s ModelName="DHCNurTemperatrue" //模块代码，demo->系统配置->日志审核及配置->日志模块配置
	s result=##class(%Dictionary.MethodDefinition).%ExistsId("web.DHCEventModel||ValidModelCode")
	q:result="" "类不存在"
	s ModelId=##class(web.DHCEventModel).ValidModelCode(ModelName)
	q:ModelId=0 "模块未激活"
	s CurDate=$zd(+$h,3)
	s StartDate=..GenToDate(StartDateStr,1) ///预览起始日期
	s EndDate=..GenToDate(ETDateStr,2) ///today
	s StPrintDate=..GenToDate(StPrintDateStr,1) ///开始打印页的日期
	s EndPrintDate=..GenToDate(ETPrintDateStr,1) 
	;s EndDate=$zd(($zdh(EndDate,3)+6),3)
	s EndPrintDate=$zd(($zdh(EndPrintDate,3)+6),3) ///打印最后一页日期
	s PatientId=$P(^PAADM(EpisodeID),"^",1)
	s ItemNameArr="PatientId^EpisodeID^UserId^StPrintDate^EndPrintDate"
	s ItemValueArr=PatientId_"^"_EpisodeID_"^"_UserId_"^"_StPrintDate_"^"_EndPrintDate
	s Condition=##class(web.DHCCLCom).GenToJoson(ItemNameArr,ItemValueArr)  ///操作条件(判断打印重复的唯一条件)
	;s Content=..GetOBSData(EpisodeID, StartDate, CurDate) //内容过多可能会maxstring
	s ItemNameArr="EpisodeID^PatientId^预览起始日期^预览截止日期^打印起始日期^打印截止日期^打印起始页^打印结束页"
	s ItemValueArr=EpisodeID_"^"_PatientId_"^"_StartDate_"^"_EndDate_"^"_StPrintDate_"^"_EndPrintDate_"^"_StPrintPage_"^"_ETPrintPage
	s Content=##class(web.DHCCLCom).GenToJoson(ItemNameArr,ItemValueArr)
	Set PatEncryptLevel=##class(web.DHCCLCom).GetPatEncryptLevel("",EpisodeID)
    Set SecretCode=$p(PatEncryptLevel,"^",3)  //密级代码
    q ##class(web.DHCEventLog).EventLog(ModelName, Condition, Content,SecretCode,"",UserId)
}

/// Input:日期串,位置
/// w ##class(web.DHCThreeNew).GenToDate("2015/1/9 0:00:00^2015/1/15 0:00:00",1)
ClassMethod GenToDate(DateStr, Position)
{
	s DateStr=$p(DateStr,"^",Position)
	s Date=$p(DateStr," ",1)
	s Date=$zd($zdh(Date,5),3)
	q Date
}

/// 通过就诊ID和项目代码获取首次体征记录值
/// 入参:就诊ID,项目代码串(为空走程序默认代码<Item1^Item2^Item4>),查询方式(默认true每个项目的第一次记录的数据,false为第一次有体温数据的时间点各项目的数据)
/// 返回值:空或者返回串(Item1|值^Item2|值^Item3|值……)
/// 代码:Item1(体温),Item2(体重),Item4(呼吸),Item5(收缩压),Item6(舒张压),Item7(脉搏),Item9(小便),Item11(大便),Item13(心率),Item(25血氧饱和度)
ClassMethod GetFirstTempValue(EpisodeID, CodeStr = "", SearchByItem = "true") As %String
{
	n (EpisodeID,CodeStr,SearchByItem)
	s MRAdm=$p($g(^PAADM(EpisodeID)),"^",61)
	q:MRAdm="" ""
	i CodeStr="" s CodeStr="Item1^Item2^Item4^Item5^Item6^Item7^Item9^Item11^Item13^Item25"
	s len=$l(CodeStr,"^")
	s ret=""
	s TempItmDr=##class(web.DHCThreeNew).getItmDr("Item1")
	s FirstDate=$o(^MR(MRAdm,"OBS",0,"Item",TempItmDr,""))
	i FirstDate'="" s FirstTime=$o(^MR(MRAdm,"OBS",0,"Item",TempItmDr,FirstDate,""))

	for i=1:1:len d
	.s Code=$p(CodeStr,"^",i)
	.q:Code=""
	.s ItmDr=##class(web.DHCThreeNew).getItmDr(Code)
	.q:ItmDr=""
	.s Value=""
	.i SearchByItem="true" d
	..s Date=$o(^MR(MRAdm,"OBS",0,"Item",ItmDr,""))
	..q:Date=""
	..s Time=$o(^MR(MRAdm,"OBS",0,"Item",ItmDr,Date,""))
	..q:Time=""
	..s Chl=$o(^MR(MRAdm,"OBS",0,"Item",ItmDr,Date,Time,""))
	..q:Chl=""
	..s Value=$P($g(^MR(MRAdm,"OBS",Chl)),"^",2)
	.e  d
	..q:FirstDate=""
	..q:$g(FirstTime)=""
	..s Chl=$o(^MR(MRAdm,"OBS",0,"Item",ItmDr,FirstDate,FirstTime,""))
	..q:Chl=""
	..s Value=$P($g(^MR(MRAdm,"OBS",Chl)),"^",2)
	.s ret=$s(ret="":Code_"|"_Value,1:ret_"^"_Code_"|"_Value)
	q ret
}

/// 通过发作日期查询过敏记录
/// d ##class(web.DHCThreeNew).GetAllergiesByDate("369","2017-02-16")
ClassMethod GetAllergiesByDate(Adm, ByOnsetDate)
{
	q:Adm="" -1
	q:ByOnsetDate="" -2
	s PatientID=$p(^PAADM(Adm),"^",1)
	q:PatientID="" -3
	s ret=""
	s ByOnsetDate=$$$zdh(ByOnsetDate,1)
	s objpat=##class(User.PAPatMas).%OpenId(PatientID)
	i $ISOBject(objpat){
		s count=objpat.ChildPAAllergy.Count()
		for i=1:1:count {
			s (RowID,Allergen,OnsetDate,OnsetDateText)=""
			s objAllergy=objpat.ChildPAAllergy.GetAt(i)
			s RowID=objAllergy.%Id()
			s OnsetDate=objAllergy.ALGOnsetDate
			continue:OnsetDate'=ByOnsetDate
			s OnsetDateFreeText=objAllergy.ALGOnsetDateFreeText
			if objAllergy.ALGTypeDRGetObjectId()'="" {
				s Allergen=objAllergy.ALGTypeDR.ALGDesc
			}
			else{
				s Allergen=objAllergy.ALGPHCDMDR.PHCDName
#;				q:phcdmDr="" 
#;				s drgName=$p($g(^PHCD(+phcdmDr,1)),"^",2) 
#;				s drgName=$p(drgName,"[",1)
#;				s Allergen=drgName
			}
			s OnsetDateText=##Class(websys.Conversions).DateLogicalToHtml(OnsetDate)_OnsetDateFreeText
			i ret="" s ret=Allergen
			e  s ret=ret_"、"_Allergen
		}
	}
	q ret
}

/// //
/// ##class(%ResultSet).RunQuery("web.DHCNurThreeNew","GetPatTempDataBlank","")
ClassMethod GetPatTempDataBlankExecute(ByRef qHandle As %Binary, Parr As %String) As %Status
{
	;s ^scv1("wltw")=Parr
	;s tPoints=##class(web.DHCThreeNew).GetTimePointGlobal()
	;s ll=$L(tPoints,"^")
	Set repid=$I(^CacheTemp)
	s ind=1
	//d ##class(%ResultSet).RunQuery("web.DHCThreeNew","GetPatTempDataBlank","170^2011-03-24^2014-04-19")
	s EpisodeID=$p(Parr,"^",1)
	s StartDate=$p(Parr,"^",2)
	i StartDate["-" s StartDate=$ZDH(StartDate,3)
	i StartDate["/" s StartDate=$ZDH(StartDate,4)
	S startDate=$$$ZDH(StartDate,4)
	s EndTime=$p(Parr,"^",3)
	i EndTime["-" s EndTime=$ZDH(EndTime,3)
	i EndTime["/" s EndTime=$ZDH(EndTime,4)
	s EndTime=$$$ZDH(EndTime,4)
	for StrDate=StartDate:1:EndTime 
	{
		//空白栏
		s blankitm=##class(User.DHCThreeBlankLabel).getBlankItm() 
		s l=$L(blankitm,"^")
		k Blank
		for i=1:1:l
		{
			s itm=$P(blankitm,"^",i)
			s code=$P(itm,"|",1)
			s label=##class(User.DHCThreeBlankLabel).getlabel(EpisodeID,code,$ZD(StrDate,3))
			s Blank(code)=label
		}
		k tmp
		s temp="Item1"
		s wultemp="Item22"
		s tPoints="7200^21600^36000^50400^64800^79200" ;##class(web.DHCThreeNew).GetTimePointGlobal()
		s ll=$L(tPoints,"^")
		f m=1:1:ll {
			s timePointNum=$p(tPoints,"^",m)
			s MRADMROWId=$P(^PAADM(EpisodeID),"^",61)  
			s chl=""
			s chl=$O(^MR(MRADMROWId,"OBS",0,"Item",14,StrDate,timePointNum,chl))
			i $g(chl)="" d
			.s curTime=timePointNum
			.s aa="RecDate|"_$$$ZD(StrDate,3)_"^RecTime|"_$ZT(curTime)_"^Item1|^"
			.s blankCode="" f  s blankCode=$O(Blank(blankCode)) q:blankCode=""  d
			..s aa=aa_blankCode_"|"_Blank(blankCode)_"^"
			.do OutPatDetailBlank
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutPatDetailBlank
	set Data=$lb(aa)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
 /////////////////////////////////////////////////////////////////////
}

ClassMethod GetPatTempDataBlankFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPatTempDataBlankExecute ]
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

ClassMethod GetPatTempDataBlankClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPatTempDataBlankExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// ##class(%ResultSet).RunQuery("web.DHCThreeNew","GetPatTempDataBlank","170^2017-04-19^2017-04-19")
Query GetPatTempDataBlank(Parr As %String) As %Query(ROWSPEC = "aa")
{
}

/// ##class(web.DHCThreeNew).GetTimePointGlobal()
ClassMethod GetTimePointGlobal()
{
	s rset=##class(%ResultSet).%New("web.DHCTHREEEX:GetTimePoint")
	;s timePoints=##class(%ListOfDataTypes).%New()
	s ret=""
	do rset.Execute()
	while (rset.Next()) {
		s timePointId=rset.GetData(1)
		s timePoint=rset.GetData(2)
		s timePointNum=$zth(timePoint)
		;d timePoints.Insert(timePointNum)
		i ret="" s ret=timePointNum
		e  s ret=ret_"^"_timePointNum
	}	
	;d rset.Close()
	q ret
}

/// 项目对照
/// update zw 2018.01.15 for 安贞
ClassMethod GetItemDesc(ByRef arr) As %String
{
	k arr
	s arr("temperature")="腋温"
	s arr("pulse")="脉搏"
	s arr("breath")="呼吸"
	s arr("defFreq")="大便次数"
	s arr("sysPressure")="收缩压"
	s arr("diaPressure")="舒张压"
	s arr("weight")="体重"
	s arr("height")="身高"
	s arr("phyCooling")="物理降温"
	s arr("heartbeat")="心率"
	s arr("liquidln")="总入量"
	s arr("uriVolume")="尿量"
	s arr("degrBlood")="血氧饱和度"
	s arr("Barthel")="Barthel评分"
	s arr("Bedsore")="压疮风险评估"
	s arr("degrBlood")="血氧饱和度"
	s arr("Fallrisk")="跌倒风险评估"
	s arr("Fallbed")="坠床风险评估"
	s arr("rectemperature")="肛温"
	s arr("Item34")="空白栏1"
	s arr("Item34_Title")="空白栏1标题"
	s arr("Item35")="空白栏2"
	s arr("Item35_Title")="空白栏2标题"
	s arr("Item36")="空白栏3"
	s arr("Item36_Title")="空白栏3标题"
	s arr("Reason")="未测原因"
	s arr("Item38_NewTitle")="血压类型"
	s arr("painInten")="疼痛评分"
	q ""
}

/// 新生儿项目对照
ClassMethod GetItemDescNewBorn(ByRef arr) As %String
{
	k arr
	s arr("Item1")="体温"
	s arr("Item22")="物理降温"
	s arr("Item10")="母乳"
	s arr("Item14")="人工"
	s arr("Item17")="黄疸"
	s arr("Item11")="大便"
	s arr("Item9")="尿量"
	s arr("Item2")="体重"
	s arr("Item21")="卡介苗接种日期"
	s arr("Item15")="批号"
	s arr("Item16")="乙肝疫苗接种日期"
	s arr("Item18")="批号"
	q ""
}

ClassMethod GetPatTempModiExecute(ByRef qHandle As %Binary, Parr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s ^tempsc("GetTempModi")= $lb(Parr)
	//d ##class(%ResultSet).RunQuery("web.DHCThreeNew","GetPatTempModi","50063601^2018-01-12^2018-01-14^")
	s EpisodeID=$p(Parr,"^",1)
	s StartDate=$p(Parr,"^",2)
	s StartDate=$$$ZDH(StartDate,3)
	s EndTime=$p(Parr,"^",3)
	s EndTime=$$$ZDH(EndTime,3)
	s NewBorn=$p(Parr,"^",4)
	s Ctloc=$g(%session.Data("LOGON.CTLOCID")) //$p(Parr,"^",5)
	i 
	;i NewBorn=1 d
	;.d ..GetItemDescNewBorn(.arr)
	;e  d
	d ..GetItemDesc(.arr)
	s date1=StartDate-1 f  s date1=##class(Nur.NurseModiNew).order(Ctloc,EpisodeID,date1,"","",3) q:(date1="")!(date1>EndTime)  d
	.s time1="" f  s time1=##class(Nur.NurseModiNew).order(Ctloc,EpisodeID,date1,time1,"",4) q:(time1="")  d
	..s chl="" f  s chl=##class(Nur.NurseModiNew).order(Ctloc,EpisodeID,date1,time1,chl,5) q:(chl="")  d
	...s rw=##class(Nur.NurseModiNew).getid(Ctloc,EpisodeID,date1,time1,chl)
	...q:(rw="")
	...s act=##class(Nur.NurseModiNew).getf1(rw,7)
	...s user1=##class(Nur.NurseModiNew).getf1(rw,8)
	...s original=##class(Nur.NurseModiNew).getf1(rw,14)
	...s value=##class(Nur.NurseModiNew).getf1(rw,15)
	...s date2=##class(Nur.NurseModiNew).getf1(rw,11)
	...s time2=##class(Nur.NurseModiNew).getf1(rw,12)
	...s item=##class(Nur.NurseModiNew).getf1(rw,9)
	...s note=##class(Nur.NurseModiNew).getf1(rw,13)
	...i (item'="") d
	....s code=$p($g(^MRC("OBITM",item)),"^",1)
	....i (code'="") s code=$g(arr(code))
	....i (code'="") s item=code
	...s aa="rw|"_rw
	...s aa=aa_"^act|"_act
	...s aa=aa_"^date1|"_##class(Nur.Utility).Id2Desc("date1",date1)
	...s aa=aa_"^time1|"_##class(Nur.Utility).Id2Desc("time1",time1)
	...s aa=aa_"^user1|"_##class(Nur.Utility).Id2Desc("user1",user1)
	...s aa=aa_"^date2|"_##class(Nur.Utility).Id2Desc("date2",date2)
	...s aa=aa_"^time2|"_##class(Nur.Utility).Id2Desc("time2",time2)
	...s aa=aa_"^item|"_item
	...s aa=aa_"^original|"_original
	...s aa=aa_"^value|"_value
	...d OutTempModied
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutTempModied
	set Data=$lb(aa)
 	Set ^CacheTemp(repid,ind)=Data
 	set ^EH(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetPatTempModiFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPatTempModiExecute ]
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

ClassMethod GetPatTempModiClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPatTempModiExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query GetPatTempModi(Parr As %String) As %Query(ROWSPEC = "aa")
{
}

/// Creator:      SongChao
/// CreateDate:   2017.8.18
/// Description:  通过登记号找病人就诊ID
/// Input:        RegNo
/// Return:       EpisodeID
/// Other:        ##class(web.DHCThreeNew).GetCurrAdm(5)
ClassMethod GetCurrAdm(RegNo) As %String
{
  	q:RegNo="" ""
  	s nvar=""
	s patConfig=##class(web.DHCCLCom).GetPatConfig()
	s regNoLong=+$p(patConfig,"^")
	s RegNoL = +$l(RegNo)
	s l = regNoLong-RegNoL+1
	i regNoLong>RegNoL	s $P(nvar,"0",l)=RegNo
	e  s nvar=RegNo
	
	s papmi=""
	s CurrAdm=0
	f  s papmi=$o(^PAPERi("PAPMI_PatNo",nvar,papmi)) q:papmi=""  d
	.s name=$p(^PAPER(papmi,"ALL"),"^",1)
	.s Adm=""
	.f  s Adm=$o(^PAPERdr(papmi,"ADM","I",Adm)) q:Adm=""  d  	
	..s Typ=$p(^PAADM(Adm),"^",2)
	..q:Typ'="I"
	..if Adm>CurrAdm  s CurrAdm=Adm
	if CurrAdm=0 s CurrAdm=""
	q CurrAdm
}

/// Creator:      SongChao
/// CreateDate:   2017.8.18
/// Description:
/// Input:
/// Return:
/// Other:       ##class(web.DHCThreeNew).getCurrLocPeriod(5,5)
ClassMethod getCurrLocPeriod(episodId, wardId)
{
	s lastLocId=""
		s locs=##class(%ListOfDataTypes).%New()
		s i=0
		s chl="" f  s chl=$O(^PAADM(episodId,"TRANS",chl)) q:chl=""  d
	  	.s locId=$P(^PAADM(episodId,"TRANS",chl),"^",9)
	  	.q:(locId="")
	  	.s bedDR=$p(^PAADM(episodId,"TRANS",chl),"^",8)
		.s locDesc=$P(^PAWARD(locId),"^",2)
	  	.i locDesc["-" s locDesc=$p(locDesc,"-",2)
	  	.q:lastLocId=locId
	  	.s startDate=$P(^PAADM(episodId,"TRANS",chl),"^",1)
	  	.s startTime=$P(^PAADM(episodId,"TRANS",chl),"^",2)
	  	.s endDate=$P(^PAADM(episodId,"TRANS",chl),"^",3)
	    .s endTime=$P(^PAADM(episodId,"TRANS",chl),"^",4)
	    .i (lastLocId'="") d
	  	..d loc.SetAt($$$zd(startDate,3),"EndDate")
	  	..d loc.SetAt($zt(startTime),"EndTime")
	  	..d locs.Insert(loc)
	    .s loc=##class(%ArrayOfDataTypes).%New()
	    .d loc.SetAt(locId,"LocId")
	    .d loc.SetAt(locDesc,"LocDesc")
	    .d loc.SetAt($$$zd(startDate,3),"StartDate")
	    .d loc.SetAt($zt(startTime),"StartTime")
	    .d loc.SetAt(i,"No")
	    .s i=i+1
	    .s lastLocId=locId
	    i $g(loc)'="" d
	    .d loc.SetAt($$$zd(+$h,3),"EndDate")
	  	.d loc.SetAt("","EndTime")
	  	.d locs.Insert(loc)
		s admType=$p(^PAADM(episodId),"^",2)
		q:(admType="E") ##class(Nur.DoctorOrderSheet).getPatLocsWard(episodId)
	 	s key=""
	 	F {
        	s pData=locs.GetNext(.key)        	
        	q:key=""
        	i pData.Data("LocId")'=wardId  d locs.RemoveAt(key)        	
	 	}
	    q ##class(Nur.JSON).Encode(locs)
}

/// w ##class(web.DHCThtreeNew).getPatWards(5)
ClassMethod getPatWards(episodId)
{
		s lastLocId=""
		s locs=##class(%ListOfDataTypes).%New()
		s i=0
		s chl="" f  s chl=$O(^PAADM(episodId,"TRANS",chl)) q:chl=""  d
	  	.s locId=$P(^PAADM(episodId,"TRANS",chl),"^",9)
	  	.q:locId=""
	  	.s bedDR=$p(^PAADM(episodId,"TRANS",chl),"^",8)
		.;q:bedDR="" 
		.;s wardDesc=$P(^PAWARD(locId),"^",2)
	  	.s locDesc=$P(^PAWARD(locId),"^",2)
	  	.i locDesc["-" s locDesc=$p(locDesc,"-",2)
	  	.q:lastLocId=locId
	  	.s startDate=$P(^PAADM(episodId,"TRANS",chl),"^",1)
	  	.s startTime=$P(^PAADM(episodId,"TRANS",chl),"^",2)
	  	.s endDate=$P(^PAADM(episodId,"TRANS",chl),"^",3)
	    .s endTime=$P(^PAADM(episodId,"TRANS",chl),"^",4)
	    .i (lastLocId'="") d
	  	..d loc.SetAt($zd(startDate,3),"EndDate")
	  	..d loc.SetAt($zt(startTime),"EndTime")
	  	..d locs.Insert(loc)
	    .s loc=##class(%ArrayOfDataTypes).%New()
	    .d loc.SetAt(locId,"LocId")
	    .d loc.SetAt(locDesc,"LocDesc")
	    .d loc.SetAt($zd(startDate,3),"StartDate")
	    .d loc.SetAt($zt(startTime),"StartTime")
	    .d loc.SetAt(i,"No")
	    .s i=i+1
	    .s lastLocId=locId
	    i $g(loc)'="" d
	    .d loc.SetAt("","EndDate")
	  	.d loc.SetAt("","EndTime")
	  	.d locs.Insert(loc)
		s admType=$p(^PAADM(episodId),"^",2)
		q:(admType="E") ##class(Nur.DoctorOrderSheet).getPatLocsWard(episodId)
	    q ##class(Nur.JSON).Encode(locs)
}

/// 可以提前录入体温的病人
/// d ##class(%ResultSet).RunQuery("web.DHCThreeNew","FindTomorowDish","44^2017-09-05^14:00:00^N")
ClassMethod FindTomorowDishExecute(ByRef qHandle As %Binary, Parr As %String) As %Status
{
	    // n (Ward,RegNo)
	      Set repid=$I(^CacheTemp)
 	      s ind=1
 	      //s ^tempSC(8181)=Parr
 	      s Ward=$p(Parr,"^")
 	      s StrDate=$p(Parr,"^",2)
 	      s StrTime=$p(Parr,"^",3)
 	      s BabyFlag=$p(Parr,"^",4)
 	      //s Ward=##class(web.DHCThreeNew).getlocward(Ward) 	
 	      //^OEORDi(0,"ARCIM",{OE_Order.OEORD_RowId},{OEORI_ItmMast_DR},{OEORI_SttDat},{OEORI_Childsub})
 	      //	^OEORD(0,"Adm",{OEORD_Adm_DR},{OEORD_RowId})     
	      if (Ward'="")
	      {
	       s room="" 
	       f  s room=$O(^PAADMi("CurrWard",Ward,room)) q:room=""  d
	       .s RowId=""  f  s RowId=$O(^PAADMi("CurrWard",Ward,room,RowId)) q:RowId=""  d
	       ..s VistStatus=$P(^PAADM(RowId),"^",20)
	       ..q:VistStatus="D"
	       ..s oeordID = $o(^OEORD(0,"Adm",RowId,""))
	       ..q:oeordID=""
	       ..s ItmMastDR=$P(^DHCDishChargeSet("Disch","tomorrowDischArcims"),"^",1)
	       ..s oeorisSub=$O(^OEORDi(0,"ARCIM",oeordID,ItmMastDR,+$h,""))
	       ..q:oeorisSub=""
	       ..s pinfo=##class(web.DHCThreeNew).Patinfo(RowId)
	       ..q:pinfo=""
     	   ..s Name=$P(pinfo,"#",2)
           ..s Bed=$P(pinfo,"#",3)
           ..s left=$P(pinfo,"#",5)
           ..s top=$P(pinfo,"#",6)
           ..s Adm=RowId
           ..s MotherAdm=$p($g(^PAADM(Adm)),"^",75)
    	   ..q:(MotherAdm="")&(BabyFlag="1")
    	   ..q:(MotherAdm'="")&(BabyFlag'="1")
           ..s PatRegNo=$P(pinfo,"#",7)
           ..s EncryptLevel=$P(pinfo,"#",8)
           ..s PatLevel=$P(pinfo,"#",9)
           ..s Data(top,left)=Adm_"^"_Name_"^"_Bed_"^"_PatRegNo_"^"_EncryptLevel_"^"_PatLevel
       	   ..//s ^DataQ(top,left)=Adm_"^"_Name_"^"_Bed_"^"_PatRegNo
	      
      	   s r="" f  s r=$O(Data(r)) q:r=""  d
           .s c=""  f  s c=$O(Data(r,c)) q:c=""  d
           ..s Adm=$P(Data(r,c),"^",1),Name=$P(Data(r,c),"^",2),Bed=$P(Data(r,c),"^",3),PatRegNo=$P(Data(r,c),"^",4)
           ..s EncryptLevel=$P(Data(r,c),"^",5),PatLevel=$P(Data(r,c),"^",6)
           ..s AdmDateVal=+($P(^PAADM(Adm),"^",6))
           ..s AdmDate=##class(websys.Conversions).DateLogicalToHtml(AdmDateVal)
           ..s aa=##class(web.DHCThreeNew).getobjval(Adm,StrDate,StrTime)
	       ..s aa="Adm|"_Adm_"^PatName|"_Name_"^BedCode|"_Bed_"^RegNo|"_PatRegNo_"^EncryptLevel|"_EncryptLevel_"^PatLevel|"_PatLevel_"^AdmDate|"_AdmDate_"^"_aa
           ..d OutPatTor

	      }	        
		  
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPatTor
	set Data=$lb(aa)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindTomorowDishFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindTomorowDishExecute ]
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

ClassMethod FindTomorowDishClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindTomorowDishExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Creator:      SongChao
/// CreateDate:   2017.9.6
/// Description:  查询可以提前录入明日体温的明日出院患者
/// Input:
/// Return:
/// Other:
Query FindTomorowDish(Parr As %String) As %Query(ROWSPEC = "aa")
{
}

/// Creator：   SongChao
/// CreatDate： 2017.10.11
/// Description： 获取能否提前录入明日体温配置的医嘱
/// Table： 
/// Input：
/// Output：配置的医嘱项
/// Others： w ##class(web.DHCThreeNew).getTormorrowConfig()
ClassMethod getTormorrowConfig()
{
	q $g(^DHCDishChargeSet("Disch","tomorrowDischArcims"))
}

/// Creator:      SongChao
/// CreateDate:   2017.9.21
/// Description:
/// Input:
/// Return:
/// Other:   ##class(web.DHCThreeNew).GetXmlConfig(5)
ClassMethod GetXmlConfig(EpisodeID)
{
	s json = ##class(Nur.DoctorOrderSheet).getPatLocs(EpisodeID)
	s locs = ##class(Nur.JSON).Decode(json)
	s count = locs.Count()
	s xmlName=""
	f i=1:1:count q:xmlName'=""  d
	.s loc= locs.GetAt(i)
	.s locId = loc.GetAt("LocId")
	.s xmlConifgId=$O(^Nur.DHCThreeXmlConfigI("CTLocDR"," "_locId,""))
	.i xmlConifgId'="" d
	..s xmlObject=##class(Nur.DHCThreeXmlConfig).%OpenId(xmlConifgId)
	..s xmlName = xmlObject.XMLFileName
	q xmlName
}

/// Creator： WuJiang
/// CreatDate： 2022.04.07
/// Description：获取患者体征项数据
/// Other：w ##class(web.DHCThreeNew).GetOBSDateValue(285)
ClassMethod GetOBSDateValue(adm, startDate, endDate)
{
	s res=##class(Nur.NIS.Service.VitalSign.Temperature).GetTempDataByDateArea(adm,startDate,endDate)
	s data=##class(%GlobalCharacterStream).%New()
	f i=1:1:res.Count() {
		s dayData=res.GetAt(i)
		s date=##class(websys.Conversions).DateHtmlToLogical(res.GetAt(i).GetAt("date"))
		s itemkey=dayData.Next("")
		While itemkey'="" {
			s itemVal=""
			
			set:itemkey="weight" itemVal="Item2"
			set:itemkey="pulse" itemVal="Item7"
			set:itemkey="sysPressure" itemVal="Item5"
			set:itemkey="diaPressure" itemVal="Item6"
			set:itemkey="temperature" itemVal="Item1"
			set:itemkey="height" itemVal="height"
			s itemData=dayData.GetAt(itemkey)
			i [(itemData)].%GetTypeOf(0)="oref" {
				s timekey=itemData.Next("")
				While (timekey'="")&&(itemVal'="") {
					s time=##class(websys.Conversions).TimeHtmlToLogical(timekey)
					s val=itemData.GetAt(timekey).GetAt("value")
					s str = date_"^"_time_"^"_itemVal_"^^"_val
					d data.WriteLine(str)
					s timekey=itemData.Next(timekey)
				}
			}
			s itemkey=dayData.Next(itemkey)
		}
	}
	q data
}

}
