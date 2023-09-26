Class web.DHCPdaPatientList Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query GetPatientList(StDate As %String, EndDate As %String, Loc As %String, Ward As %String, Doc As %String) As %Query(ROWSPEC = "No,BedNo,PatName,MainDoc,EpisodeId,PatientId")
{
}

ClassMethod GetPatientListExecute(ByRef qHandle As %Binary, StDate As %String, EndDate As %String, Loc As %String, Ward As %String, Doc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	Set qHandle=$lb(0,repid,0)
 	//s ^TMP("gh")=$LB(StDate, EndDate, Loc, Ward, Doc)
    if StDate'=""{
	     f Date=StDate:1:EndDate
	     { //本科 某日期段病人
		     s Lable="PAADM_LocDateTime",WL=Loc,date=Date
		    d DocLocWard
		 }
  	Quit $$$OK
	    }
	if (Doc'="")&(Loc'="")
	{
	
	   s admdate="" f  s admdate=$O(^PAADMi("TypeLocDocDateTime","I",Loc,Doc,admdate)) q:admdate=""  d
	   .s admtime=""  f  s admtime=$O(^PAADMi("TypeLocDocDateTime","I",Loc,Doc,admdate,admtime))  q:admtime=""  d
	   ..s Rw=""  f  s Rw=$O(^PAADMi("TypeLocDocDateTime","I",Loc,Doc,admdate,admtime,Rw))  q:Rw=""  d
	   ...d Adminf
  	Quit $$$OK

	}
    if (Doc'=""){
	    //按本医生查
	  s Lable="AdmDocDateTime",WL=Doc
      d Docloc
     Quit $$$OK

    }
    if Ward'="" {
	    s Room=""  f  s Room=$O(^PAADMi("CurrWard",Ward,Room)) q:Room=""  d
        .s Rw=""  f  s Rw=$O(^PAADMi("CurrWard",Ward,Room,Rw)) q:Rw=""  d
        ..d Adminf
       Quit $$$OK

	    }
	if (Loc'="")&(StDate=""){
		//按本科查
		s Lable="CurrLoc",WL=Loc
        d Docloc
	  	Quit $$$OK
	
		}

DocLocWard
	   	 s admtime=""  f  s admtime=$O( ^PAADMi(Lable,WL,date,admtime)) q:admtime=""  d
	      .s Rw=""  f  s Rw=$O(^PAADMi(Lable,WL,date,admtime,Rw)) q:Rw=""  d
	      ..d Adminf
	    q
  
Docloc
	    s admdate=""  f  s admdate=$O( ^PAADMi(Lable,WL,admdate)) q:admdate=""  d
	      .s admtime=""  f  s admtime=$O( ^PAADMi(Lable,WL,admdate,admtime)) q:admtime=""  d
	      ..s Rw=""  f  s Rw=$O(^PAADMi(Lable,WL,admdate,admtime,Rw)) q:Rw=""  d
	      ...d Adminf
      q
Adminf
	     q:Rw=""
	     s ret=..getpatinf(Rw)
	     q:ret=""
	     s BedCode="",PatName="",RegNo="",Adm="",DocName=""
	     s BedCode=$P(ret,"^",2),PatName=$P(ret,"^",1),RegNo=$P(ret,"^",3),Adm=$P(ret,"^",4),DocName=$P(ret,"^",5),PatientId=$P(ret,"^",6)
	     d OutRow
      q
OutRow
	set Data=$lb("",BedCode,PatName,DocName,Adm,PatientId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod getpatinf(Adm As %String) As %String
{
  //病人信息
    s DischgDate=$P(^PAADM(Adm),"^",17)
    q:DischgDate'="" ""
    s Type=$P(^PAADM(Adm),"^",2)
    q:Type'="I" ""
    
    s roomdr=$P(^PAADM(Adm),"^",69)
    s papmiId=+^PAADM(Adm)
    if (roomdr'="") s room=$P(^PAROOM(roomdr),"^",2)
    s regno=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
    s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
    s bedSub=$p($p($g(^PAADM(Adm)),"^",73),"||",2)
    s curWardId=$p($g(^PAADM(Adm)),"^",70)  
    if curWardId'="" s WardDes=$P(^PAWARD(curWardId),"^",1)
    if (bedSub'="")&(curWardId'="") s bedCode=$p($g(^PAWARD(curWardId,"BED",bedSub)),"^",1)
    e  s bedCode=""	    
   	s doc=$p(^PAADM(Adm),"^",9)
	if doc'="" s DocDes=$P(^CTPCP(doc,1),"^",2)
	e  s DocDes=""
    s ret=$G(patName)_"^"_$G(bedCode)_"^"_regno_"^"_Adm_"^"_DocDes_"^"_papmiId
    q ret
}

ClassMethod GetPatientListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPatientListExecute ]
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

ClassMethod GetPatientListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPatientListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetPatList(StDate As %String, EndDate As %String, Loc As %String, Ward As %String, Doc As %String, PatientId As %String) As %String
{
  // n (WardLoc, Adm, Excute , UnExcute , scroll, UserId,VarTyp)
   if StDate="-1" s StDate=""
   if Loc="-1" s Loc=""
   if Ward="-1" s Ward=""
   if Doc="-1"  s Doc=""
   s QueryName="web.DHCPdaPatientList:GetPatientList"
   Set rset = ##class(%ResultSet).%New(QueryName)
   Set columns = rset.GetColumnCount()

 // Execute the query
    if (StDate'="")
    {
	     s StDate=$ZDH(StDate,3)
	     S EndDate=$ZDH(EndDate,3)
	}
    s sc = rset.Execute(StDate, EndDate, Loc, Ward , Doc)

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

}
