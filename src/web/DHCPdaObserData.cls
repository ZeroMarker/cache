Import SQLUser

Class web.DHCPdaObserData Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod GetObserItemExecute(ByRef qHandle As %Binary, Grp As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
    s timstr=""
    s str=""
	s n=1
	s color("体温")="blue"
	s color("脉搏")="red"
	s color("呼吸")=""
	s color("心率")="red"
	s color("收缩压")=""
	s color("舒张压")=""
	s color("物理降温")="blue"
	s lyztstr="搀扶~担架~自来"
	s GrpRow="" s GrpRow=$O(^MRC("OBGRP",0,"Code",$ZConvert(Grp,"U"),GrpRow))
	if (GrpRow'=""){
		 s chl=0 f  s chl=$O(^MRC("OBGRP",GrpRow,"ITM",chl)) q:chl=""  d
		 .s itmrw=$P(^MRC("OBGRP",GrpRow,"ITM",chl),"^",1) 
		 .s sort=$P(^MRC("OBGRP",GrpRow,"ITM",chl),"^",2)
	     .s des=$p(^MRC("OBITM",itmrw),"^",2)
	     .s typ=$p(^MRC("OBITM",itmrw),"^",3)
	     .s color=""
	     .s color=$g(color(des))
	     .if sort="" s sort=n
	     .s itm(sort)=des_"^"_typ_"^"_color_"^"_itmrw
	     .s n=n+1
		}
	 s rw="" f  s rw=$O(itm(rw)) q:rw=""  d
	 .s des=$P(itm(rw),"^",1)
	 .s typ=$P(itm(rw),"^",2)
     .s color=$P(itm(rw),"^",3)
     .s itmrw=$P(itm(rw),"^",4)
     .d out1
  Set qHandle=$lb(0,repid,0)
  Quit $$$OK
	
out1
	set Data=$lb(des,typ,"" ,color,itmrw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetObserItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetObserItemExecute ]
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

ClassMethod GetObserItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetObserItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query GetObserItem(Grp As %String) As %Query(ROWSPEC = "des : %String,typ : %String,ItmValue : %String,color: %String,itmrw : %String")
{
}

ClassMethod GetOBInOutDataExecute(ByRef qHandle As %Binary, Adm As %String, StDate As %String, StTim As %String, EndDate As %String, EndTim As %String, Grp As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
 	s ind=1
 	Set qHandle=$lb(0,repid,0)
	if Adm="" Quit $$$OK
	//s ^TM(0)=CDate5
	//获得体温,物理降温 ID
	s ^TMP=$Lb( Adm, StDate, StTim, EndDate , EndTim, Grp)
	//("94","2008-8-13","12:40:59","2008-8-13","17:40:59","OutIn")
	//s Grp="OutIn",Adm="94"
	//s StDate="2008-08-13",EndDate="2008-08-13",StTim="1:11:48",EndTim="17:11:48"
	s StDate=$ZDH(StDate,3),StTim=$ZTH(StTim,3),EndDate=$ZDH(EndDate,3),EndTim=$ZTH(EndTim,3)

	s Mradm=$P(^PAADM(Adm),"^",61) 
	s itm=""
	s itmstr=##class(web.DHCPdaComm).GetOBInOutItm(Grp,.itm)
	s GrpRow="" s GrpRow=$O(^MRC("OBGRP",0,"Code",$ZConvert(Grp,"U"),GrpRow))
    s StDtTim=..GetAbsTime(StDate_","_StTim)
    s EndDtTim=..GetAbsTime(EndDate_","_EndTim)
    s InAmount=0
    s OutAmount=0
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
	..s Dt=..GetAbsTime(OBSD_","_OBST)
	..if (Dt<StDtTim)!(Dt>EndDtTim) q
	..s Desc=$P(^MR(Mradm,"OBS",chl),"^",6)
	..q:typ'="N"  //数字类型才求和
	..if IOTyp="O" s OutAmount=OutAmount+Value
	..if IOTyp="I" s InAmount=InAmount+Value
	..s itmval(ItmDr)=$G(itmval(ItmDr))+Value
	}
	//des_"^"_typ_"^"_""_"^"_itmrw
	s des="总出量",rw="",val=OutAmount,typ="N"
	d OutwardRow1
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

Query GetOBInOutData(Adm, StDate, StTim, EndDate, EndTim, Grp = "") As %Query(ROWSPEC = "desc,rw,itemval,typ")
{
}

ClassMethod GetAbsTime(dt As %String) As %String
{
 //将日期时间转换成秒
 // n (dt)
  s dat=$P(dt,",",1),tim=$P(dt,",",2)
  q ((dat*86400)+tim)
}

ClassMethod GetOutInAmount(Adm, StDate, StTim, EndDate, EndTim, Grp = "") As %String
{

	s Mradm=$P(^PAADM(Adm),"^",61) 
	s itm=""
	s itmstr=##class(web.DHCPdaComm).GetOBInOutItm(Grp,.itm)
	s GrpRow="" s GrpRow=$O(^MRC("OBGRP",0,"Code",$ZConvert(Grp,"U"),GrpRow))
    s StDtTim=..GetAbsTime(StDate_","_StTim)
    s EndDtTim=..GetAbsTime(EndDate_","_EndTim)
    s OutAmount=0,InAmount=0
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
	..s Dt=..GetAbsTime(OBSD_","_OBST)
	..if (Dt<StDtTim)!(Dt>EndDtTim) q
	..s Desc=$P(^MR(Mradm,"OBS",chl),"^",6)
	..q:typ'="N"  //数字类型才求和
	..if IOTyp="O" s OutAmount=OutAmount+Value
	..if IOTyp="I" s InAmount=InAmount+Value
	}
	q OutAmount_"^"_InAmount
}

ClassMethod GetOutInData(Adm As %String, StDate As %String, StTim As %String, EndDate As %String, EndTim As %String, Grp = "") As %String
{
   //n (WardLoc, Adm, Excute , UnExcute , scroll, UserId,VarTyp)
   s QueryName="web.DHCPdaObserData:GetOBInOutData"
   Set rset = ##class(%ResultSet).%New(QueryName)
   Set columns = rset.GetColumnCount()

 // Execute the query
    s sc = rset.Execute(Adm, StDate , StTim, EndDate, EndTim, Grp)

   s QueryName=$TR(QueryName,":","&")
   s ret=$P(QueryName,"&",2)_"&"
  s i=0
  While (rset.Next()) {
       i (i=0){
        For col = 1:1:columns {
            s ret=ret_rset.GetColumnName(col)_"&"
        }
       }
       s coldata=""
       For col = 1:1:columns {
            s coldata=coldata_rset.GetData(col)_"^"
        }

      if (i=0){
	      s ret=ret_"$"_coldata_"&"
	      }else{
		    s ret=ret_coldata_"&"

		      }
      s i=i+1
      if i>300  q
      
 }
 Do rset.Close()
 s qu=$P(QueryName,"&",2)_"&"
 if ret=qu  s ret="-1"
 b
 q ret
}

ClassMethod GetEventTyp() As %String
{
	s QueryName="web.DHCADMQTREC:QtTyp"
	Set rset = ##class(%ResultSet).%New(QueryName)
	Set columns = rset.GetColumnCount()
	s sc = rset.Execute()
	s QueryName=$TR(QueryName,":","&")
	s ret=$P(QueryName,"&",2)_"&"
	s i=0
	While (rset.Next()) {
       i (i=0){
        For col = 1:1:columns {
            s ret=ret_rset.GetColumnName(col)_"&"
        }
       }
       s coldata=""
       For col = 1:1:columns {
            s coldata=coldata_rset.GetData(col)_"^"
        }

      if (i=0){
	      s ret=ret_"$"_coldata_"&"
	      }else{
		    s ret=ret_coldata_"&"
		      }
      s i=i+1
      if i>300  q
	}
	Do rset.Close()
	s qn=$P(QueryName,"&",2)_"&"
	if ret=qn  s ret="-1"
	q ret
}

ClassMethod GetOtherData(EpisodeID As %String = "") As %String
{
	s QueryName="web.DHCADMQTREC:QtList"
	Set rset = ##class(%ResultSet).%New(QueryName)
	Set columns = rset.GetColumnCount()
	s sc = rset.Execute(EpisodeID)
	s QueryName=$TR(QueryName,":","&")
	s ret=$P(QueryName,"&",2)_"&"
	s i=0
	While (rset.Next()) {
       i (i=0){
        For col = 1:1:columns {
            s ret=ret_rset.GetColumnName(col)_"&"
        }
       }
       s coldata=""
       For col = 1:1:columns {
            s coldata=coldata_rset.GetData(col)_"^"
        }

      if (i=0){
	      s ret=ret_"$"_coldata_"&"
	      }else{
		    s ret=ret_coldata_"&"
		      }
      s i=i+1
      if i>300  q
	}
	Do rset.Close()
	s qn=$P(QueryName,"&",2)_"&"
	if ret=qn  s ret="-1"
	q ret
}

ClassMethod InsertOtherData(EpisodeID As %String = "", eventDate As %String = "", eventTime As %String = "", eventType As %String = "", insertUser As %String = "") As %String
{
  s PLIST(2)=EpisodeID
  s PLIST(3)=$ZDH(eventDate,3)
  s PLIST(4)=$ZTH(eventTime)
  s PLIST(5)=eventType
  s PLIST(6)=$P($H,",")
  s PLIST(7)=$P($H,",",1)
  s PLIST(8)=insertUser
  &sql(insert into DHC_ADMQTREC values PLIST())
  q SQLCODE
}

ClassMethod DeleteOtherData(rowid As %String) As %String
{
	&sql(delete from DHC_ADMQTREC where QTREC_ROWID=:rowid)
	q SQLCODE
}

ClassMethod GetListItemDataExecute(ByRef qHandle As %Binary, Adm As %String, CDate As %String, CTime As %String, Grp As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	Set qHandle=$lb(0,repid,0)
	if Adm="" Quit $$$OK
	//s ^TM(0)=CDate
	//获得体温,物理降温 ID
	s setstr=..GetSingleTempdata()
	s tempid=$P(setstr,"^",3)
	s item1id=$P(setstr,"^",4)  //项目1，项目2
	s item2id=$P(setstr,"^",5)
	s item3id=$P(setstr,"^",6)
    s item4id=$P(setstr,"^",7)
    s item5id=$P(setstr,"^",8)
    s item6id=$P(setstr,"^",9)
    s item7id=$P(setstr,"^",10)

	s wultempid=$P(setstr,"^")
    s itm=""  //des_"^"_typ_"^"_sort_"^"_rw
    if Grp="-1"{
    d ##class(web.DHCPdaComm).GetObserItm(.itm)
    }else{
	    d ##class(web.DHCPdaComm).GetOBInOutItm(Grp,.itm)
	    }
    b ;;-----
	s CDate=$ZD(CDate,3)
	s CTime=$ZT(CTime,3)
    ;s item1=..SelectHavelable(Adm,item1id,CDate)
    ;s item2=..SelectHavelable(Adm,item2id,CDate)
    s item1=##class(User.DHCThreeBlankLabel).getlabel(Adm,"Item34",CDate)
    s item2=##class(User.DHCThreeBlankLabel).getlabel(Adm,"Item26",CDate)
    s item3=##class(User.DHCThreeBlankLabel).getlabel(Adm,"Item28",CDate)
    s item4=##class(User.DHCThreeBlankLabel).getlabel(Adm,"Item30",CDate)
    s item5=##class(User.DHCThreeBlankLabel).getlabel(Adm,"Item32",CDate)
    s item6=##class(User.DHCThreeBlankLabel).getlabel(Adm,"Item17",CDate)
    s item7=##class(User.DHCThreeBlankLabel).getlabel(Adm,"Item15",CDate)
	s num=""  f  s num=$O(itm(num)) q:num=""  d
	.s typ="",des=""
	.s des=$p(itm(num),"^",1)
	.s typ=$p(itm(num),"^",2)
	.s rw=$p(itm(num),"^",4)
	.s color=$p(itm(num),"^",3)
	.s value=""
	.s listitm=""
	.if rw=wultempid s value=..SelectIsDesc(Adm,tempid,CDate,CTime)
	.e  s value=..SelectIsRecord(Adm,rw,CDate,CTime)
	.if rw=item1id s value=item1
	.if rw=item2id s value=item2
	.if rw=item3id s value=item3
	.if rw=item4id s value=item4
	.if rw=item5id s value=item5
	.if rw=item6id s value=item6
	.if rw=item7id s value=item7
	.if des="来院状态" s listitm=$p(itm(num),"^",5)
	.s des=des
   	.Do OutwardRow1
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	//des,typ,ItmValue,color,itmrw
OutwardRow1
	set Data=$lb(des,typ,value,color,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetListItemDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListItemDataExecute ]
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

ClassMethod GetListItemDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListItemDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query GetListItemData(Adm, CDate, CTime, Grp = "") As %Query(ROWSPEC = "des,typ,ItmValue,color,itmrw")
{
}

ClassMethod GetSingleTempdata() As %String
{
  //设置物理降温，和每天只录入一条数据的项目；
	set wultemp=3
	set tempid=14  //体温
	;set item1id=36  //项目1
	;set item2id=43  //项目2
	set item1id=44  //项目1
	set item2id=19  //项目2
	set item3id=23  //项目3
	set item4id=24  //项目4
	set item5id=30  //项目5
	set item6id=28  //项目6
	set item7id=26  //项目7
	set singldata="|12|"  //16|17|
	q wultemp_"^"_singldata_"^"_tempid_"^"_item1id_"^"_item2id_"^"_item3id_"^"_item4id_"^"_item5id_"^"_item6id_"^"_item7id
}

ClassMethod SelectHavelable(RowId As %String, StrItem As %String, date As %String = "") As %String
{
	 //n (RowId,StrItem,date)
	 //从小到大找
	 s MRADMROWId=$P(^PAADM(RowId),"^",61) 
	 s date=date-1
	 b
	 s StrDate=date f  s StrDate=$O(^MR(MRADMROWId,"OBS",0,"Date",StrDate)) q:(StrDate="")!($G(P1)'="")  d 
	 .s chl="" f  s chl=$O(^MR(MRADMROWId,"OBS",0,"Date",StrDate,StrItem,chl)) q:chl=""  d
	 ..s P1=$P(^MR(MRADMROWId,"OBS",chl),"^",2)
	 ..b
	 ..q:P1'=""
	 .q:$G(P1)'=""
	 q $G(P1)
}

ClassMethod SelectIsDesc(RowId As %String, StrItem As %String, StrDate As %String, StrTime As %String) As %String
{
	  //n (RowId,StrItem,StrDate,StrTime)
	  s StrDate=$ZDH(StrDate,3)
	  s StrTime=$ZTH(StrTime,3)   
 
	  s MRADMROWId=$P(^PAADM(RowId),"^",61)    
	  s chl=""  f  s chl=$O(^MR(MRADMROWId,"OBS",0,"Date",StrDate,StrItem,chl)) q:chl=""  d
	  .s time=$P(^MR(MRADMROWId,"OBS",chl),"^",4)
	  .if time=StrTime  s P1=$P(^MR(MRADMROWId,"OBS",chl),"^",6)
	  q $G(P1)
}

ClassMethod SelectIsRecord(RowId As %String, StrItem As %String, StrDate As %String, StrTime As %String) As %String
{
	//n (RowId,StrItem,StrDate,StrTime)   
	  s StrDate=$ZDH(StrDate,3)
	  s StrTime=$ZTH(StrTime,3)   
	  s MRADMROWId=$P(^PAADM(RowId),"^",61)    
	  s chl=""  f  s chl=$O(^MR(MRADMROWId,"OBS",0,"Date",StrDate,StrItem,chl)) q:chl=""  d
	  .s time=$P(^MR(MRADMROWId,"OBS",chl),"^",4)
	  .if time=StrTime  s P1=$P(^MR(MRADMROWId,"OBS",chl),"^",2)
	  q $G(P1)
}

}
