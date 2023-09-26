Import SQLUser

Class web.DHCThreeNewDT Extends %RegisteredObject
{

ClassMethod GetCurTime() As %String
{
	q $zt($p($h,",",2),2)
}

ClassMethod GetStatusInfo(Adm) As %String
{
	//w ##class(web.DHCThreeNewDT).GetStatusInfo(3078306)
	s ret="",ADate="",ATime=""
	
	s transc=0,chd=0 f  s transc=$o(^PAADM(Adm,"TRANS",transc)) q:(transc="")  d
	  .q:chd'=0
	  .s ttype=$p(^PAADM(Adm,"TRANS",transc),"^",21)
	  .i ttype'="" s chd=transc
	q:$g(chd)="" ""
	s sdate=$p(^PAADM(Adm,"TRANS",chd),"^",1)
	s stime=$p(^PAADM(Adm,"TRANS",chd),"^",2)
	s ADate=$zd(sdate,3), ATime=$zt(stime,2)
	
	s papmi=$p($g(^PAADM(Adm)),"^",1)
	s IBirth=$p($g(^PAPER(papmi,"ALL")),"^",6)
	s today=$p($g(^PAADM(Adm)),"^",6)
	s PatAge=##class(web.DHCTHREEEX).CalAge(IBirth,today)
	q ADate_" "_ATime_"    年龄："_PatAge
}

ClassMethod GetCurDate() As %String
{
	q $zd(+$h,3)
}

ClassMethod GetQueryData(QueryName As %String, parrm As %String, funname As %String) As %String
{
  //s a=##class(web.DHCThreeNew).GetQueryData()
 //  s QueryName="web.DHCNurNeedMeasureTempPat:GetNeedMeaserPat"
   //s parrm="parr$211^^2011-04-26^19:00:00"
   //s funname="addLab"
   //s ^TT("a")=QueryName
   s l=$L(parrm,"!")
   s pp=""
   f i=1:1:l
   {
     s itm=$P(parrm,"!",i)
     s p=$P(itm,"$",1)
     s v=$P(itm,"$",2)
     s @p=v
     //b
     if i<l s pp=pp_p_","
     e  s pp=pp_p 
     //b
   }

   Set rset = ##class(%ResultSet).%New(QueryName)
   Set columns = rset.GetColumnCount()


 // Execute the query
  //b
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
		     s colret=colret_na_":'"_nv_"',"
		    // s tm(na)=nv
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
   //b
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

	;s ^lf(QueryName)=parrm_"||"_funname
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

ClassMethod GetQtEvent(Adm, typ) As %String
{
	s ret=##class(web.DHCADMQTRECDT).QtPatAdmDate2(Adm)
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

ClassMethod GetQtEventBak(Adm, typ) As %String
{
	; w ##class(web.DHCThreeNewDT).GetQtEvent(3106607,"入住")
	s ret=##class(web.DHCADMQTRECDT).QtPatAdmDate2(Adm)
	b
 	s ret=""
 	s rw=0  f  s rw=$O(^DHCADMQTREC("adm",Adm,rw)) q:rw=""  d
	.s TypDr=$P(^DHCADMQTREC("QTREC",rw),"^",4)
	.if TypDr'="" s TypCode=$P(^DHCQTRECTYP("typ",TypDr),"^",1)
	.//入院急诊手术也算入院 by pjf 2012/05/03
	.q:(TypCode'=typ)&(typ'="QtItem1")&(typ'="QtItem7")
	.q:((typ="QtItem1")&(TypCode'="QtItem5")&(TypCode'="QtItem1"))!((typ="QtItem7")&(TypCode'="QtItem6")&(TypCode'="QtItem7"))
	.//呼吸心跳也算出院 by pjf 2012/07/16
	.s ADate=$P(^DHCADMQTREC("QTREC",rw),"^",2)
	.s ATime=$P(^DHCADMQTREC("QTREC",rw),"^",3)
	.if ADate'="" s Date=$ZD(ADate,3)
	.if ATime'="" s Time=$ZT(ATime,2)
	.s ret=ret_Date_"^"_Time_"|"
	q ret
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
    
    //s tim(1)="1-5"
    //s tim(2)="5-9"
   // s tim(3)="9-13"
   // s tim(4)="13-17"
   // s tim(5)="17-21"
   // s tim(6)="21-25"

    
	s intim=$ZT($P($H,",",2),2)
	s h=$P(intim,":")
	s minute=$P(intim,":",2)
	s intim=h+(minute/60)
	//s intim=16.99
	s p=1
	s n="" f  s n=$O(tim(n)) q:n=""  d
	.s st=$P(tim(n),"-",1)
	.s et=$P(tim(n),"-",2)
	.i (intim<et) s p=n,n=6  
	.;i (intim'<st)&(intim<et) s p=n
	.b
	//s nn=1
	//s num=$FN(intim*6/86400,"",1)
	//s num1=$FN(intim*6/86400,"",0)
	//if num1>num s nn=num1
	//e  s nn=num1
	//i nn'<6 s nn=1
	
	q p
}

ClassMethod GetAllPatientExecute(ByRef qHandle As %Binary, Parr As %String) As %Status
{
	  // n (Ward,RegNo)
	      Set repid=$I(^CacheTemp)
 	      s ind=1
 	      s Ward=$p(Parr,"^")  ;Ward为空时表示是医生在使用体温单
 	      s RegNo=$p(Parr,"^",2)
 	      s StrDate=$p(Parr,"^",3)
 	      s StrTime=$p(Parr,"^",4)
 	      s BabyFlag=$p(Parr,"^",5)
 	      
 	      //按就诊ID只查询出院病人
 	      i RegNo'="" d
 	      .s admVisitStat=$p($g(^PAADM(RegNo)),"^",20)
		  .i ((admVisitStat'="D")&&(Ward'="")) s RegNo=""
		  
		  i Ward'="" d 
		  .s wardFlag=$P($g(^CTLOC(Ward)),"^",13)
		  .i (wardFlag="W")!(wardFlag="EM") s Ward=..getlocward(Ward)
	      if (Ward'="")&&(RegNo="")
	      {
		   i (wardFlag="W")!(wardFlag="EM")  d
	       .s room="" 
	       .f  s room=$O(^PAADMi("CurrWard",Ward,room)) q:room=""  d
	       ..s RowId=""  f  s RowId=$O(^PAADMi("CurrWard",Ward,room,RowId)) q:RowId=""  d
	       ...s VistStatus=$P(^PAADM(RowId),"^",20)
	       ...q:VistStatus="D"
	       ...s pinfo=..Patinfo(RowId)
	       ...q:pinfo=""
     	   ...s Name=$P(pinfo,"#",2)
           ...s Bed=$P(pinfo,"#",3)
           ...s left=$P(pinfo,"#",6)
           ...s top=$P(pinfo,"#",7)
           ...s Adm=RowId
           ...s MotherAdm=$p($g(^PAADM(Adm)),"^",75)
    	   ...q:(MotherAdm="")&(BabyFlag="1")
    	   ...q:(MotherAdm'="")&(BabyFlag'="1")
           ...s PatRegNo=$P(pinfo,"#",8)
           ...s Data(top,left)=Adm_"^"_Name_"^"_Bed_"^"_PatRegNo
       	   ...//s ^DataQ(top,left)=Adm_"^"_Name_"^"_Bed_"^"_PatRegNo
	      
      	   .s r="" f  s r=$O(Data(r)) q:r=""  d
           ..s c=""  f  s c=$O(Data(r,c)) q:c=""  d
           ...s Adm=$P(Data(r,c),"^",1),Name=$P(Data(r,c),"^",2),Bed=$P(Data(r,c),"^",3),PatRegNo=$P(Data(r,c),"^",4)
           ...s aa=..getobjval(Adm,StrDate,StrTime)
	       ...s aa="Adm|"_Adm_"^PatName|"_Name_"^BedCode|"_Bed_"^RegNo|"_PatRegNo_"^"_aa
           ...d OutPat
           e  d
           .s admDate=""
		   .f  s admDate=$O(^PAADMi("CurrLoc",Ward,admDate)) q:admDate=""  d
		   ..s admTime="" f  s admTime=$O(^PAADMi("CurrLoc",Ward,admDate,admTime)) q:admTime=""  d
           ...s RowId="" f  s RowId=$O(^PAADMi("CurrLoc",Ward,admDate,admTime,RowId)) q:RowId=""  d
           ....s VistStatus=$P(^PAADM(RowId),"^",20)
	       ....q:(VistStatus="D")
	       ....s pinfo=..Patinfo(RowId)
	       ....q:pinfo=""
     	   ....s Name=$P(pinfo,"#",2)
           ....s Bed=$P(pinfo,"#",3)
           ....s left=$P(pinfo,"#",6)
           ....s top=$P(pinfo,"#",7)
           ....s Adm=RowId
           ....s MotherAdm=$p($g(^PAADM(Adm)),"^",75)
    	   ....q:(MotherAdm="")&(BabyFlag="1")
    	   ....q:(MotherAdm'="")&(BabyFlag'="1")
           ....s PatRegNo=$P(pinfo,"#",8)
           ....s Data(top,left)=Adm_"^"_Name_"^"_Bed_"^"_PatRegNo
       	   ....//s ^DataQ(top,left)=Adm_"^"_Name_"^"_Bed_"^"_PatRegNo
	      
      	   .s r="" f  s r=$O(Data(r)) q:r=""  d
           ..s c=""  f  s c=$O(Data(r,c)) q:c=""  d
           ...s Adm=$P(Data(r,c),"^",1),Name=$P(Data(r,c),"^",2),Bed=$P(Data(r,c),"^",3),PatRegNo=$P(Data(r,c),"^",4)
           ...s aa=..getobjval(Adm,StrDate,StrTime)
	       ...s aa="Adm|"_Adm_"^PatName|"_Name_"^BedCode|"_Bed_"^RegNo|"_PatRegNo_"^"_aa
	       
           ...d OutPat
	      }
	      //b ;03
	      if (RegNo'="")
	      {
	       s RowId=RegNo
	               //b ;06
		           s pinfo=..DischargePatinfo(RowId)
		           b ;05
	               q:pinfo=""
	               s Reg=$P(pinfo,"#",8)
	               s Name=$P(pinfo,"#",2)
	               s Bed=$P(pinfo,"#",3)
	               s Adm=RowId
	               b ;04
	               s aa=..getobjval(Adm,StrDate,StrTime)
	               s aa="Adm|"_Adm_"^PatName|"_Name_"^BedCode|"_Bed_"^RegNo|"_Reg_"^"_aa
                   //b ;02
	               d OutPat

		  }
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPat

	set Data=$lb(aa)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
 /////////////////////////////////////////////////////////////////////
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

ClassMethod getlocward(loc) As %String
{
	
  s ward=$O(^PAWARD(0,"WARD_LocationDR",loc,"")) 
  q ward
}

ClassMethod getlocwardesc(loc) As %String
{
  s ward=$O(^PAWARD(0,"WARD_LocationDR",loc,"")) 
  s wardesc=$p(^PAWARD(ward),"^",2)
  s wardesc1=$p(wardesc,"-",2)
  q wardesc1
}

ClassMethod Patinfo(Adm As %String) As %String
{
	
           s CurrentBedDR=$P(^PAADM(Adm),"^",73)
	       q:CurrentBedDR="" ""
	       s Papmidr=$P(^PAADM(Adm),"^",1)
	       s ctlocdr=$P(^PAADM(Adm),"^",4)
	       s Name=$P(^PAPER(Papmidr,"ALL"),"^",1)
	       s RegNo=$P(^PAPER(Papmidr,"PAT",1),"^",1)
	       s bedchl=$P(CurrentBedDR,"||",2)
	       s Ward=$P(CurrentBedDR,"||",1)
	       s wardloc=$P(^PAWARD(Ward),"^",5) //s name="F",cttypdes="NURSE"

	       s Bed=$P(^PAWARD(Ward,"BED",bedchl),"^",1)
	       s pstop=$P(^PAWARD(Ward,"BED",bedchl),"^",15)
	       s psleft=$P(^PAWARD(Ward,"BED",bedchl),"^",16)
	       s adm(Bed)=Adm_"#"_Name_"#"_Bed_"#"_$G(ctlocdr)_"#"_$G(wardloc)_"#"_pstop_"#"_psleft_"#"_RegNo
         q adm(Bed)
}

ClassMethod getobjval(RowId, StrDate, StrTime) As %String
{
    //s ^lf("getobj")=RowId_" "_StrDate_" "_StrTime
	 ; w ##class(web.DHCThreeNewDT).getobjval("3106607","2013-01-07","16:00:00") 
	   s blankitm=##class(User.DHCThreeBlankLabel).getBlankItm() 
	  s blank=""
	  s l=$L(blankitm,"^")
	  s Blank=""
	  s temp="体温"
	  s wultemp="物理降温"
	  s pain="疼痛"
	  s wulpain="缓解疼痛"
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
	  .;b
	  .s chl=""  f  s chl=$O(^MR(MRADMROWId,"OBS",0,"Date",StrDate,itmdr,chl)) q:chl=""  d
	  ..s time=$P(^MR(MRADMROWId,"OBS",chl),"^",4)
	  ..if time=StrTime d
	  ...s P1=$P(^MR(MRADMROWId,"OBS",chl),"^",2)
	  ...s Desc=$P(^MR(MRADMROWId,"OBS",chl),"^",6)
	  ...s itmcode=$p($G(^MRC("OBITM",itmdr)),"^",1)
	  ...q:$g(itmcode)=""  //对应的观察项已删除
	  ...q:$D(Blank(itmcode)) //如果空白栏已有值
	  ...s:(itmcode'="24小时入量")&(itmcode'="24小时出量")&(itmcode'="体重(kg)/身高(cm)") tmp(itmcode)=P1
	  ...;b //s
	  ...if (Desc'="" )&(itmcode=temp) s tmp(wultemp)=Desc
	  ...if (Desc'="" )&(itmcode=pain) s tmp(wulpain)=Desc
	  ...if (itmcode="24小时入量") s tmp("二十四小时入量")=P1
	  ...if (itmcode="24小时出量") s tmp("二十四小时出量")=P1
	  ...if (itmcode="体重(kg)/身高(cm)") s tmp("体重KG身高CM")=P1
	  s ret=""
	   s k=""  
	  	f {
		   s k=$O(tmp(k))
		   q:k=""  
		   s ret=ret_k_"|"_tmp(k)_"^"
	  	  }

	  q ret
}

/*ClassMethod settmp(parr, tmp) As %String
{
 //s aa=##class(web.DHCMGNurComm).settmp(parr,.tmp)
	s l=$L(parr,"^")
	for i=1:1:l
	{
	  s itm=$P(parr,"^",i)
	  if itm="" continue
	  s name=$P(itm,"|")
	  if $P(name,"_",2)'=""  s name=$P(name,"_",1)
	  s val=$P(itm,"|",2)
	  if '$D(tmp(name)) s tmp(name)=val
	  e  s tmp(name)=tmp(name)_";"_val
	  if $F(val,"!")'=0
	  {
	    s rw=$P(val,"!")
	    s rwv=$P(val,"!",2)
	    if rwv'=""
	    {
		  if (rwv="date")
		  {
			  if (rw'="") s val=$ZDH(rw,3)
			  e  s val=""
		  }
		  if (rwv="time")
		  {
			  if (rw'="") s val=$ZTH(rw,4)
			  e  s val=""
		  }
		}else{
			s val=""
			}
	   s tmp(name)=val
	  }
	 
	}
  q 0
}*/
ClassMethod DischargePatinfo(Adm As %String) As %String
{
	       s Papmidr=$P(^PAADM(Adm),"^",1)
	       s Name=$P(^PAPER(Papmidr,"ALL"),"^",1)
	       s RegNo=$P(^PAPER(Papmidr,"PAT",1),"^",1)
	       s ctlocdr=$P(^PAADM(Adm),"^",4)
	       s CurrentBedDR=$P(^PAADM(Adm),"^",73)
	       i CurrentBedDR'="" d
	       .s Ward=$P(CurrentBedDR,"||",1)
	       .s bedchl=$P(CurrentBedDR,"||",2)
	       .s wardloc=$P(^PAWARD(Ward),"^",5) //s name="F",cttypdes="NURSE"
	       .s Bed=$P(^PAWARD(Ward,"BED",bedchl),"^",1)
	       .s pstop=$P(^PAWARD(Ward,"BED",bedchl),"^",15)
	       .s psleft=$P(^PAWARD(Ward,"BED",bedchl),"^",16)
	       s aa=Adm_"#"_Name_"#"_$g(Bed)_"#"_$G(ctlocdr)_"#"_$G(wardloc)_"#"_$g(pstop)_"#"_$g(psleft)_"#"_RegNo
         q $g(aa)
}

ClassMethod Save(EpisodeID, parr As %String, user, RecTyp, usergroup, indate, intime) As %String
{
	s ^lf("save")= parr_" "_user_" "_RecTyp_" "_usergroup_" "_indate_" "_intime
   //##class(web.DHCTHREEE).InsertData()##class(web.DHCTHREEE).InsertDesc(adm,itmdr,date,tim,user,val)
 	//w ##class(web.DHCThreeNewDT).Save("3106607","体重(KG)/身高(CM)|22^CareDate|^CareTime|","3133","DHCNUR6","住院护士","2013-01-09", "16:00:00")
	//s ^TMP("aa",EpisodeID)=$LB(EpisodeID, parr , user, RecTyp, usergroup, indate, intime)
	//s a=##class(web.DHCThreeNew).Save()
	//s EpisodeID=325017
	//s parr=$list(^TMP("aa",EpisodeID),2)
	//s user=$list(^TMP("aa",EpisodeID),3)
	//s RecTyp=$list(^TMP("aa",EpisodeID),4)
	//s usergroup=$list(^TMP("aa",EpisodeID),5)
	//s indate=$list(^TMP("aa",EpisodeID),6)
	//s intime=$list(^TMP("aa",EpisodeID),7)
	//
	  s temp="体温"  //体温
	  s pain="疼痛"
	  s wultemp="物理降温"   //物理降温
	  s wulpain="缓解疼痛"
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
	  if name = wultemp 
	  {
		  s ^TMP("codetemp")=itm
		  s flag=1
		  s name=temp
		  
	  }
	   if name = wulpain 
	  {
		  s flag=1
		  s name=pain
		  
	  }
	  if $D(Blank(name)) continue  //空白项标题退出
	  s val=$P(itm,"|",2)
	  s itmdr=..getItmDr(name)
	   b //l
	  if itmdr="" continue
	  if name="Adm" continue   //物理降温插在备注、
	  b //s1
	  if flag=1 s r=##class(web.DHCTHREEE).InsertDesc(EpisodeID,itmdr,indate,intime,user,val)
	  e  s r=##class(web.DHCTHREEE).InsertData(EpisodeID,itmdr,indate,intime,user,val)
	}
	q 0
}

ClassMethod getItmDr(itemcode As %String) As %String
{
  //##class(web.DHCThreeNew).getItmDr
    s itemcode=$ZConvert(itemcode,"U")
    b //code
    s rw=$O(^MRC("OBITM",0,"Code",itemcode,""))
   q rw
}

ClassMethod GetEvents(Adm) As %String
{
	//s a=##class(web.DHCThreeNew).GetEvents()
	s data=""
	s num=1
	//s ret=##class(web.DHCADMQTREC).QtPatAdmDate(Adm)
	k TMP
	s rw=0 f  s rw=$O(^DHCADMQTREC("adm",Adm,rw)) q:rw=""  d
	.s ADate=$P(^DHCADMQTREC("QTREC",rw),"^",2)
	.s ATime=$P(^DHCADMQTREC("QTREC",rw),"^",3)
	.s TypDr=$P(^DHCADMQTREC("QTREC",rw),"^",4)
	.if ADate'="" s Date=$ZD(ADate,3)
	.if ATime'="" s Time=$ZT(ATime,2)
	
	.s timpos=ATime/14400
	.b //1
	.i ATime'=0 s ATime=(ATime-1) ;地坛要求整点事件放前一格 
	.s pos=..getPos($ZT(ATime,2))  //\14400
	.b //2
	.s timpos=$FN(timpos,"",1)
	.b //3
	.if TypDr'="" s TypCode=$P(^DHCQTRECTYP("typ",TypDr),"^",1)
	.if TypDr'="" s TypDes=$P(^DHCQTRECTYP("typ",TypDr),"^",2)
	.s TMP(ADate,ATime,num)=pos_"^"_timpos_"^"_Date_"^"_Time_"^"_TypCode_"^"_TypDes
	.s num=num+1
    s date=""  f  s date=$O(TMP(date)) q:date=""  d
    .s tm=""  f  s tm=$O(TMP(date,tm)) q:tm=""  d
    ..s n=""  f  s n=$O(TMP(date,tm,n)) q:n=""  d
    ...s data=data_TMP(date,tm,n)_"|"
   q data
}

ClassMethod getPos(tim) As %String
{
 //w ##class(web.DHCThreeNew).getPos() //24/6
    //s ^TMP("gg")=a
    s tim(1)="0-4"
    s tim(2)="4-8"
    s tim(3)="8-12"
    s tim(4)="12-16"
    s tim(5)="16-20"
    s tim(6)="20-24"
    
    
	s intim=tim  //$ZT($P($H,",",2),2)
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
	
	q p-1
}

ClassMethod GetOBSData(Adm As %String, StDate As %String, EndDate As %String) As %String
{
 //s a=##class(web.DHCThreeNewDT).GetOBSData("1134203","2012-11-19","2012-11-20")
	//s Adm="45"      //高压（收缩压）和低压（舒张压），
   // s StDate="2010-12-10"
  	//s EndDate="2010-12-10"
	
   s DM="",DayNum=""
   s ret=""
  // b //ss
   d ..PatLeave(Adm, StDate, EndDate,.DM,.DayNum)
   //b
    
   s n=""  f  s n=$O(DM(n)) q:n=""  d
   .s st=$P(DM(n),"^",1),ed=$P(DM(n),"^",2)
   .if $ZDH(st,3)=0 b
   .//w !,st,"/",ed
   .//b //
   .s ret=ret_..GetPatValue(Adm,st,ed,.DayNum)_"!"
   q ret
}

ClassMethod PatLeave(Adm As %String, StDate As %String, EndDate As %String, DM, DayNum)
{
	;Create by qse 2005-6-16 s a=##class(web.DHCThreeNew).PatLeave()
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
}

ClassMethod GetBlankDesc(Adm As %String, codeitm As %String, blankitm As %String, StrDate As %String) As %String
{
  q:Adm="" ""
  s ret=""
  s l=$L(blankitm,",")
  for i=1:1:l
  {
    s itm=$P(blankitm,",",i)
    s code=$P(itm,":",1)
    s vcode=$P(itm,":",2)
    //b ;01
    i codeitm'=vcode continue
    s label=##class(User.DHCThreeBlankLabel).getlabel(Adm,code,$ZD(StrDate,3))
    //b ;02
    i label="" continue
    s ret=label
  }
  
  q ret
}

ClassMethod GetPatValue(Adm As %String, StDate As %String, EndDate As %String, DayNum) As %String
{
   //生命体征数据查询
   ////s a=##class(web.DHCThreeNew).GetPatValue()
	//s Adm="337862"      //高压（收缩压）和低压（舒张压），
    //s StDate="2010-11-01"
	//s EndDate="2010-11-07"
	s StDate=$ZDH(StDate,3)
	s EndDate=$ZDH(EndDate,3)
	
	s Mradm=$P(^PAADM(Adm),"^",61) 
	s num=0
	//s nuitGridTim=86400/6
	//s gridw=UnitW/240  //(4小时)
	//s gridh=UnitH  //(每小格0.2度，4次)
    //s Pulses="",Tw="",Breath=""
    s HPItm="收缩压",LPItm="舒张压",InSumDr=..GetInSumDr(), OutSumDr=..GetOutSumDr(),curveDr=..GetCurveDr()
	f Date=StDate:1:EndDate
	{
		;s InSum=0,OutSum=0
		s num=DayNum(Date)
		s ItmDr=""  f  s ItmDr=$O(^MR(Mradm,"OBS",0,"Date",Date,ItmDr)) q:ItmDr=""  d
		.q:'$D(^MRC("OBITM",ItmDr))
		.s code=$P(^MRC("OBITM",ItmDr),"^",1)
		.i code="体重(kg)/身高(cm)" s code="体重KG身高CM"
		.s chl=""  f  s chl=$O(^MR(Mradm,"OBS",0,"Date",Date,ItmDr,chl)) q:chl=""  d
		..s Value=$P(^MR(Mradm,"OBS",chl),"^",2)
		..;i (InSumDr [ ("^"_ItmDr_"^")) d
		... ;i $G(Value)'="" s InSum=InSum+Value
		..;i (OutSumDr [ ("^"_ItmDr_"^")) d
		... ;i $G(Value)'="" s OutSum=OutSum+Value
		..s OBSD=$P(^MR(Mradm,"OBS",chl),"^",3)
		..s OBST=$P(^MR(Mradm,"OBS",chl),"^",4)
		..s Desc=$P(^MR(Mradm,"OBS",chl),"^",6)
		..;i (curveDr '[ ("^"_ItmDr_"^"))  s OBST=OBST-1
		..s TimPos=(OBST\14400)
		..i (OBST#14400)=0 d
		...s TimPos=TimPos-0.43
		..e  d
		...s TimPos=TimPos+0.57
		..i (Value'="")  d
		...  //时间方向位置 
		...//s Value=$FN(((Value)),"",2)
		...i Desc'="" s TM(code,num,OBST)=num_"^"_Value_"^"_TimPos_"^"_Desc_"#"    ;物理降温
		...e  s TM(code,num,OBST)=num_"^"_Value_"^"_TimPos_"^"_"#"
		;i InSum'=0 s TM("总入量",num,36000)=num_"^"_InSum_"^"_2.5_"^"_"#"
		;i OutSum'=0 s TM("总出量",num,36000)=num_"^"_OutSum_"^"_2.5_"^"_"#"
	
	}
	b
	 s Data=""
	 s d=""  f  s d=$O(TM(HPItm,d)) q:d=""  d
	 .s t=""  f  s t=$O(TM(HPItm,d,t)) q:t=""  d
	 ..s tpos=$P(TM(HPItm,d,t),"^",3)
	 ..s val=$P(TM(HPItm,d,t),"^",2)
	 ..if $D(TM(LPItm,d,t)) d
	 ...s val=val_"/"_$P(TM(LPItm,d,t),"^",2)
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


	 s code="" f  s code=$O(TM(code)) q:code=""  d
	 .s ret=""
	 .q:code=HPItm
	 .q:code=LPItm
	 .s d=""  f  s d=$O(TM(code,d)) q:d=""  d
	 ..s t=""  f  s t=$O(TM(code,d,t)) q:t=""  d
	 ...s ret=ret_TM(code,d,t)
	 .s Data=Data_code_"|"_ret_"&"
	 s Data=HPItm_"|"_hp_"&"_Data
	// b
	q Data
}

ClassMethod GetPatTempDataExecute(ByRef qHandle As %Binary, Parr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	//d ##class(%ResultSet).RunQuery("web.DHCThreeNewDT","GetPatTempData","1134203^2012-11-17^2012-11-21")
	s EpisodeID=$p(Parr,"^",1)
	s StartDate=$p(Parr,"^",2)
	i StartDate["-" s StartDate=$ZDH(StartDate,3)
	i StartDate["/" s StartDate=$ZDH(StartDate,4)
	s EndTime=$p(Parr,"^",3)
	i EndTime["-" s EndTime=$ZDH(EndTime,3)
	i EndTime["/" s EndTime=$ZDH(EndTime,4)
	s blankitm=##class(User.DHCThreeBlankLabel).getBlankItm() //空白栏
	for StrDate=StartDate:1:EndTime 
	{
		//空白栏
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
		s MRADMROWId=$P(^PAADM(EpisodeID),"^",61)    
		s itmdr=""  f  s itmdr=$O(^MR(MRADMROWId,"OBS",0,"Date",StrDate,itmdr)) q:itmdr=""  d
		.s chl=""  f  s chl=$O(^MR(MRADMROWId,"OBS",0,"Date",StrDate,itmdr,chl)) q:chl=""  d
		..s time=$P($G(^MR(MRADMROWId,"OBS",chl)),"^",4)
		..q:time=""
		..s P1=$P($G(^MR(MRADMROWId,"OBS",chl)),"^",2)
		..s Desc=$P($G(^MR(MRADMROWId,"OBS",chl)),"^",6)
		..s itmcode=$p($G(^MRC("OBITM",itmdr)),"^",1)
		..q:itmcode=""
		..i itmcode="24小时出量" s itmcode="二十四小时出量" 
		..i itmcode="24小时入量" s itmcode="二十四小时入量"
		..i itmcode="体重(kg)/身高(cm)" s itmcode="体重KG身高CM"
		..s tmp(time,itmcode)=P1
		..if (Desc'="" )&(P1'="")&((itmcode="体温")!(itmcode="Item12")!(itmcode="Item20")) s tmp(time,"物理降温")=Desc
		..if (Desc'="" )&(P1'="")&((itmcode="疼痛")) s tmp(time,"缓解疼痛")=Desc
		s aa=""
		s curTime="" f  s curTime=$O(tmp(curTime)) q:curTime=""  d
		.//显示日期与时间
		.s aa="RecDate|"_$ZD(StrDate,3)_"^RecTime|"_$ZT(curTime)_"^"
		.s curCode=""  f  s curCode=$O(tmp(curTime,curCode)) q:curCode=""  d
		..s aa=aa_curCode_"|"_tmp(curTime,curCode)_"^"
		.s blankCode="" f  s blankCode=$O(Blank(blankCode)) q:blankCode=""  d
		..s aa=aa_blankCode_"|"_Blank(blankCode)_"^"
		.do OutPatDetail
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

ClassMethod settmp(parr, tmp) As %String
{
 //s aa=##class(web.DHCMGNurComm).settmp(parr,.tmp)
	s l=$L(parr,"^")
	for i=1:1:l
	{
	  s itm=$P(parr,"^",i)
	  if itm="" continue
	  s name=$P(itm,"|")
	  if $P(name,"_",2)'=""  s name=$P(name,"_",1)
	  s val=$P(itm,"|",2)
	  if '$D(tmp(name)) s tmp(name)=val
	  e  s tmp(name)=tmp(name)_";"_val
	  if $F(val,"!")'=0
	  {
	    s rw=$P(val,"!")
	    s rwv=$P(val,"!",2)
	    if rwv'=""
	    {
		  if (rwv="date")
		  {
			  if (rw'="") s val=$ZDH(rw,3)
			  e  s val=""
		  }
		  if (rwv="time")
		  {
			  if (rw'="") s val=$ZTH(rw,4)
			  e  s val=""
		  }
		}else{
			s val=""
			}
	   s tmp(name)=val
	  }
	 
	}
  q 0
}

ClassMethod GetInSumDr() As %String
{
	q "^"_..getItmDr("食入量")_"^"_..getItmDr("液体入量")_"^"
}

ClassMethod GetCurveDr() As %String
{
	// ##class(web.DHCThreeNewDT).GetCurveDr()
	q "^"_..getItmDr("体温")_"^"_..getItmDr("脉搏")_"^"_..getItmDr("心率")_"^"_..getItmDr("物理降温")_"^"_..getItmDr("疼痛值")_"^"_..getItmDr("体重")_"^"
}

ClassMethod GetOutSumDr() As %String
{
	q "^"_..getItmDr("尿量")_"^"_..getItmDr("呕吐量")_"^"_..getItmDr("引流量")_"^"_..getItmDr("Item35")_"^"
}

ClassMethod QtInsert(Adm As %String, ADate As %String, ATime As %String, Typ As %String, user As %String) As %String
{
 ///n (Adm ,ADate,ATime,Typ ,user)
 s ^lf(Adm)= ADate_"^"_Typ
 &sql(delete from DHC_ADMQTREC where QTREC_ADM_DR=:Adm and QTREC_TYP_DR=:Typ)
  s PLIST(2)=Adm
  s PLIST(3)=$ZDH(ADate,3)
  s PLIST(4)=$ZTH(ATime)
  q:Typ="" -1
  s PLIST(5)=Typ
  s PLIST(6)=$P($H,",")
  s PLIST(7)=$P($H,",",1)
  s PLIST(8)=user
  &sql(insert into DHC_ADMQTREC values PLIST())
  q SQLCODE
}

ClassMethod GetIllDate(Adm As %String) As %String
{
  //患病日期 
  //w ##class(web.DHCThreeNewDT).GetIllDate(1134203)
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

ClassMethod ClearRecord(EpisodeID As %String, StDate As %String, StTime As %String) As %String
{
	
	//##class(web.DHCThreeNewDT).ClearRecord(1134203,"2012-11-29","14:00:01")
	 s MRADMROWId=$P(^PAADM(EpisodeID),"^",61)  
	  s StDate=$ZDH(StDate,3)
	  s StTime=$ZTH(StTime,3) 
	 &sql(delete from  MR_Observations 
	        where OBS_ParRef =:MRADMROWId
	         and OBS_Date=:StDate
	         and OBS_Time=:StTime)
	  q SQLCODE
}

ClassMethod GetWeightBase(EpisodeID As %String) As %String
{
	 s MRADMROWId=$P(^PAADM(EpisodeID),"^",61) 
	 s chl=$o(^MRC("OBITM",0,"Code","体重基数",0)) 
	 q:$g(chl)="" ""
	 s weight=""
	 &sql(select OBS_value into :weight from  MR_Observations 
	        where OBS_ParRef =:MRADMROWId
	         and OBS_Item_DR=:chl)
	 q weight
}

ClassMethod SaveWeightBase(EpisodeID As %String, weight As %String) As %String
{
	 s MRADMROWId=$P(^PAADM(EpisodeID),"^",61) 
	 s chl=$o(^MRC("OBITM",0,"Code","体重基数",0)) 
	 q:$g(chl)="" ""
	 set oldweight=""
	 &sql(select OBS_value into :oldweight from  MR_Observations 
	        where OBS_ParRef =:MRADMROWId
	         and OBS_Item_DR=:chl)
	         B
	  i oldweight="" d
	  .&sql(insert into MR_Observations (OBS_ParRef,OBS_Item_DR,OBS_Value) values(:MRADMROWId,:chl,:weight))
	  e  d 
	  .&sql(update MR_Observations set OBS_Value=:weight where OBS_ParRef =:MRADMROWId and OBS_Item_DR=:chl)
	q SQLCODE
}

}
