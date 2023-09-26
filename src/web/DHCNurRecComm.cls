Class web.DHCNurRecComm Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

// w ##class(Nur.DHCNurseRecSub).InsertFirstTZ("60","69","住院护士")

/// 描述：第一次生命体征插入护理记录
ClassMethod InsertFirstTZ(EpisodeID, user, usergroup) As %String
{
   q:EpisodeID="" ""
   s curWardId=$p($g(^PAADM(EpisodeID)),"^",70) 
   s loc=$p(^PAWARD(curWardId),"^",5)
   q:loc="" ""
   s RecTypStr=..getloccode(loc)
   s tmplinkcode("DHCNURSZYJLD")="Item2^Item3^Item4^Item5^Item6" //体温单,脉搏，呼吸,收缩压,舒张压对应的护理记录中的列名
   s tmplinkcode("DHCNURANHUI3")="Item1^Item2^Item3^Item4^Item5"
   s tempval=..getfirstpattz(EpisodeID)
   q:tempval="" ""
   b ;33
   s date=$p(tempval,"^") //日期
   s time=$p(tempval,"^",2) //时间
   s tpval1=$p(tempval,"^",3) //体温
   s tpval2=$p(tempval,"^",4) //脉搏
   s tpval3=$p(tempval,"^",5) //呼吸
   s tpval4=$p(tempval,"^",6) //收缩压
   s tpval5=$p(tempval,"^",7) //舒张压
   s parr="CareDate|"_date_"^CareTime|"_time
   s par=$O(^Nur.DHCNurseRecParentI("Episode"," "_EpisodeID,""))
   f seqcode=1:1:$l(RecTypStr,"^") d
   .s RecTyp=$p(RecTypStr,"^",seqcode)  
   .i RecTyp'="" d
   ..i RecTyp="DHCNURANHUI3" B ;
   ..s flag=$o(^Nur.DHCNurseRecSubI("TypHeadDatTim"," "_RecTyp," ",$zdh(date,3),$zth(time,2),par,""))
   ..i flag=""  d //该时间点没有记录
   ...s linkcode=""
   ...q:'$d(tmplinkcode(RecTyp))
   ...i $d(tmplinkcode(RecTyp)) s linkcode=tmplinkcode(RecTyp)
   ...e  s linkcode=tmplinkcode("DHCNURSZYJLD")
   ...s parr=parr_"^"_$p(linkcode,"^",1)_"|"_tpval1_"^"_$p(linkcode,"^",2)_"|"_tpval2_"^"_$p(linkcode,"^",3)_"|"_tpval3_"^"_$p(linkcode,"^",4)_"|"_tpval4_"^"_$p(linkcode,"^",5)_"|"_tpval5
   ...b ;
   ...d ##class(Nur.DHCNurseRecSub).Save(EpisodeID,parr,user,RecTyp, usergroup)
   q ""
}

// CareDate|2016-06-29^CareTime|18:00^Item2|38^Item3|100^Item4|45^Item5|100^Item6|78^Item1|38^Item2|100^Item3|45^Item4|100^Item5|78

// w ##class(Nur.DHCNurseRecSub).getloccode("31")

ClassMethod getloccode(loc)
{
	s ret=""
	s DepModelStr=##class(web.DHCNUREMRNEWOnPage).GetDepModel(loc)
	s DepModelStr=$zcvt(DepModelStr,"U")
	s AllStr=##class(web.DHCNUREMRNEWOnPage).GetDepModel("All")
	s AllStr=$zcvt(AllStr,"U")
	i '$d(^User.DHCNURMenuSubI("LocSeq"," "_loc)) d
	.s loc=""
	s id=""  f  s id=$O(^User.DHCNURMenuSubI("LocSeq"," "_loc,id)) q:(id="")  d
	.s gid=$tr(id," ","")
	.s mseq=""  f  s mseq=$O(^User.DHCNURMenuSubI("LocSeq"," "_loc,id,mseq)) q:(mseq="")  d
	..s subchl=""  f  s subchl=$O(^User.DHCNURMenuSubI("LocSeq"," "_loc,id,mseq,gid,subchl)) q:(subchl="")  d
    ...s seqsub=$tr(mseq," ","")
    ...q:seqsub=""
    ...s depcodesort(seqsub)=id_"||"_subchl
    s rw="" f  s rw=$o(depcodesort(rw)) q:rw=""  d
    .s rowid=$tr(depcodesort(rw)," ","")
 	.s a=##class(User.DHCNURMenuSub).%OpenId(rowid)
 	.q:a=""
 	.s code=$zcvt(a.Code,"U")
 	.q:(DepModelStr'[code)&(AllStr'[code)
 	.s codetype=..getCodeTyp(a.Code)
 	.q:codetype=""
 	.i ret="" s ret=code
 	.e  s ret=ret_"^"_code
    q ret
}

ClassMethod getCodeTyp(RecTyp) As %String
{
    s ret="" 
    s RecTyp=$zconvert(RecTyp,"U")
    s id="" f  s id=$O(^User.DHCNURMoudelLinkI("CodeIndex"," "_RecTyp,id)) q:id=""  d
 	.s a=##class(User.DHCNURMoudelLink).%OpenId(id)
 	.s PrintCode=a.typ
 	.s typ=a.typ
 	.i typ["记录单" s ret=typ
	q ret
}

// 取病人第一次生命体征

// w ##class(Nur.DHCNurseRecSub).getfirstpattz(134)

ClassMethod getfirstpattz(EpisodeID) As %String
{
	    s tmptempval("Item1")="" //体温"
	    s tmptempval("Item7")="" //脉搏"
	    s tmptempval("Item4")="" //呼吸"
	    s tmptempval("Item5")="" //收缩压"
	    s tmptempval("Item6")="" //舒张压"
	    s MRADMROWId=$P(^PAADM(EpisodeID),"^",61)    
	    s firstime=""
	    s date=$O(^MR(MRADMROWId,"OBS",0,"Date","")) 
	    q:date="" ""
	    s itmdr=""  f  s itmdr=$O(^MR(MRADMROWId,"OBS",0,"Date",date,itmdr)) q:itmdr=""  d
        .s chl=""  f  s chl=$O(^MR(MRADMROWId,"OBS",0,"Date",date,itmdr,chl)) q:chl=""  d
        ..s time=$P($G(^MR(MRADMROWId,"OBS",chl)),"^",4)
        ..q:time=""
        ..s val=$P($G(^MR(MRADMROWId,"OBS",chl)),"^",2)
        ..q:val=""
        ..q:(firstime'="")&(firstime'=time)
        ..s itmcode=$p($G(^MRC("OBITM",itmdr)),"^",1)
        ..q:'$d(tmptempval(itmcode))
        ..s tmptempval(itmcode)=val
        ..i firstime="" s firstime=time
        q:firstime="" ""
        s ret=$zd(date,3)_"^"_$zt(firstime,2)_"^"_tmptempval("Item1")_"^"_tmptempval("Item7")_"^"_tmptempval("Item4")_"^"_tmptempval("Item5")_"^"_tmptempval("Item6")
        b ;33
        q ret
}

ClassMethod GetHeadChangeExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s ^TMP("parr")=parr

   // s parr="337862^DHCNURHEADCHANGE"
 	//d ##class(%ResultSet).RunQuery("web.DHCNurRecComm","GetHeadChange","")
 	s Adm=$P(parr,"^",1)
 	s RecTyp=$P(parr,"^",2)
 	s RecTyp=$ZConvert(RecTyp,"U")
 	//s dep=parr
	s par=$O(^Nur.DHCNurseRecParentI("Episode"," "_Adm,""))
    if par=""  Set qHandle=$lb(0,repid,0)	Quit $$$OK
	//分项统计对应列
	
        b
        s typ="" f  s typ=$O(^Nur.DHCNurRecHeadChangeRecI("TypDatTim"," "_RecTyp,typ)) q:typ=""  d
        .s rw="" f  s rw=$O(^Nur.DHCNurRecHeadChangeRecI("TypDatTim"," "_RecTyp,typ,par,rw)) q:rw=""  d
        ..s arr=$G(^Nur.DHCNurRecHeadChangeRecD(par,rw))
        ..s tmp=""
        ..s tmp("rw")=rw,tmp("par")=par
        ..s a=##class(Nur.DHCNurRecHeadChangeRec).getVal(par_"||"_rw,.tmp)
        ..s cdate=tmp("CareDate"),ctime=tmp("CareTime")
		..s cdate=$ZD(cdate,3),ctime=$ZT(ctime,2)
		..s tmp("CareDate")=cdate,tmp("CareTime")=ctime
		..s recuserId=tmp("RecUser")
		..i recuserId'="" s tmp("User")=$p($g(^SSU("SSUSR",recuserId)),"^",2)
		..e  s tmp("User")=""
		..s aa=..getRet(.tmp)
		..d OutRowtyp
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

 
OutRowtyp
	set Data=$lb(aa)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetHeadChangeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetHeadChangeExecute ]
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

ClassMethod GetHeadChangeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetHeadChangeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetHeadChange(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod GetCareRecCommExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s ^TMP("parr333")=parr

    //s parr="316213^2010-09-21^00:00^2010-09-22^00:00^DHCNUR6"
 	//d ##class(%ResultSet).RunQuery("web.DHCNurRecComm","GetCareRecComm","50^2015-07-06^00:00^2015-07-07^00:00^DHCNURweishoushu^false")
 	i parr["&" s parr=$tr(parr,"&",":")
 	s Adm=$P(parr,"^",1)
 	s StTime=$P(parr,"^",3)
 	i StTime="" s StTime="0:00"
 	s EndTime=$P(parr,"^",5)
 	i EndTime="" s EndTime="0:00"
 	s stdate=$P(parr,"^",2)
 	s stdate=##class(websys.Conversions).DateHtmlToLogical(stdate)
 	s eddate=$P(parr,"^",4)
 	s eddate=##class(websys.Conversions).DateHtmlToLogical(eddate)
 	//s stdate=$ZDH($P(parr,"^",2),3)
 	//s eddate=$ZDH($P(parr,"^",4),3)
 	s StTime=$ZTH(StTime)
 	s EndTime=$ZTH(EndTime)
 	
 	s stdatetime=..GetAbsTime(stdate_","_StTime)
 	s endatetime=..GetAbsTime(eddate_","_EndTime)
 	s RecTyp=$P(parr,"^",6)
 	s RecTyp=$ZConvert(RecTyp,"U")
 	s IfCancelRec=$P(parr,"^",7)
 	s nurseSign=$P(parr,"^",8)
 	//s dep=parr
	s par=$O(^Nur.DHCNurseRecParentI("Episode"," "_Adm,""))
    if par=""  Set qHandle=$lb(0,repid,0)	Quit $$$OK
	//分项统计对应列
	s ret=##class(Nur.DHCNurseRecSet).getSet(RecTyp)
	s PartInProperty=$P(ret,"^",3)
	s PartInNameProperty=$P(PartInProperty,"&",1)
	s PartInAmountProperty=$P(PartInProperty,"&",2)
	s PartOutProperty=$P(ret,"^",4)
	s PartOutNameProperty=$P(PartOutProperty,"&",1)
	s PartOutAmountProperty=$P(PartOutProperty,"&",2)
	
	f date=eddate:-1:stdate
	{
        s tim="" f  s tim=$O(^Nur.DHCNurseRecSubI("TypDatTim"," "_RecTyp,date,tim),-1) q:tim=""  d
        .s rw="" f  s rw=$O(^Nur.DHCNurseRecSubI("TypDatTim"," "_RecTyp,date,tim,par,rw),-1) q:rw=""  d
        ..s arr=$G(^Nur.DHCNurseRecSubD(par,rw))
        ..s tmp=""
        ..s tmp("rw")=rw,tmp("par")=par
        ..s a=##class(Nur.DHCNurseRecSub).getVal(par_"||"_rw,.tmp)
        ..s cdate=tmp("CareDate"),ctime=tmp("CareTime")
        ..s cdatetime=..GetAbsTime(cdate_","_ctime)
        ..q:((cdatetime>endatetime)!(cdatetime<stdatetime))
        ..//b //hh
		..s cdate=$ZD(cdate,3),ctime=$ZT(ctime,2)
		..s CaseMeasure=tmp("CaseMeasure")
		..s tmp("CareDate")=cdate,tmp("CareTime")=ctime
		..s recuserId=tmp("RecUser")
		..i recuserId'="" s tmp("User")=$p($g(^SSU("SSUSR",recuserId)),"^",2)
		..e  s tmp("User")=""
		..s recaudituserId=tmp("RecAuditUser")
		..i recaudituserId'="" s AuditUser=$p($g(^SSU("SSUSR",recaudituserId)),"^",2)
		..e  s AuditUser=""
		..i AuditUser'="" d
		...s tmp("User")=tmp("User")_" "_AuditUser
		..s reccanceluserId=tmp("RecCancelUser")
		..q:(IfCancelRec="true")&(reccanceluserId="")
		..q:(IfCancelRec'="true")&(reccanceluserId'="")
		
		..i reccanceluserId'="" d
		...s CancelUser=$p($g(^SSU("SSUSR",reccanceluserId)),"^",2)
		...s reccanceldate=tmp("RecCancelDate")
		...i reccanceldate'="" d
		....//s reccanceldate=$ZD(reccanceldate,3)
		....s reccanceldate=##class(websys.Conversions).DateLogicalToHtml(reccanceldate)
		...s reccanceltime=tmp("RecCancelTime")
		...i reccanceltime'="" s reccanceltime=$ZT(reccanceltime)
		...s tmp("User")=tmp("User")_" 作废记录:"_CancelUser_" "_reccanceldate_" "_reccanceltime
		..s audituserId=tmp("AuditUser")
		..i audituserId'="" d
		...s AuditUser=$p($g(^SSU("SSUSR",audituserId)),"^",2)
		...s tmp("User")=tmp("User")_"/"_AuditUser
		..s tmp("par")=par
		..s tmp("rw")=rw
		..q:(nurseSign'="")&&(tmp("User")'[nurseSign)
		..s aa=..getRet(.tmp)
		..d OutRowtyp
	 }
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

 
OutRowtyp
	set Data=$lb(aa)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetCareRecCommFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCareRecCommExecute ]
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

ClassMethod GetCareRecCommClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCareRecCommExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetCareRecComm(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod GetAbsTime(dt As %String) As %String
{
 //将日期时间转换成秒
  //n (dt)
  s dat=$P(dt,",",1),tim=$P(dt,",",2)
  q ((dat*86400)+tim)
}

ClassMethod getRet(tmp) As %String
{
	s k=""
	s ret=""
	f {
	s k=$O(tmp(k))
	q:k=""
	s ret=ret_k_"|"_tmp(k)_"^"
	}
 q ret
}

ClassMethod ParseStr(arr) As %String
{
   //s arr="B118!7!38!神志^B119!199!38!语言能力^B124!8!176!口腔粘膜^B126!432!176!有无义齿^B128!397!38!皮肤^B129!85!219!小便^B130!86!259!大便^B132!251!219!小便其他^B133!253!259!大便其他^B134!8!300!情绪状态^B135!157!300!情绪其他^B136!405!300!自理能力^B137!77!340!是否吸烟^B138!372!340!是否饮酒^B139!77!379!饮食习惯^B140!236!379!饮食其他^B141!460!379!忌食^B142!77!421!睡眠^B143!189!421!睡眠时间^B144!357!421!有无药物辅助睡眠^B145!211!340!吸烟量^B146!503!340!饮酒量^B147!8!460!既往史^B148!8!512!既往史其他^B161!7!75!视力^B162!10!123!听力^B163!186!75!异常^B164!185!123!异常^B165!165!176!口腔其他^B167!546!421!药物^B168!8!550!过敏史^B169!118!550!药物^B170!331!550!食物^B171!483!550!过敏史其他^Item37!88!460!undefined^Item37_1!undefined!undefined!高血压^Item43!50!75!undefined^Item43_1!undefined!undefined!正常^Item44!50!123!undefined^Item44_2!undefined!undefined!异常^Item15!51!38!嗜睡^Item16!273!38!正常^Item17!78!176!完整^Item18!502!176!有^Item19!441!38!完整^Item20!129!219!失禁^Item21!130!259!失禁^Item24!78!300!焦虑^Item26!475!300!部分依赖^Item27!150!340!否^Item50!57!550!无^Item22!326!219!33^Item23!326!259!33^Item25!230!300!ee^Item30!308!379!^Item31!505!379!^Item33!255!421!^Item35!264!340!^Item36!559!340!^Item38!88!512!dfg^Item45!229!75!777^Item46!229!123!yyy^Item47!229!176!55^Item49!584!421!^Item51!158!550!33^Item52!371!550!3^Item53!560!550!4^_Label106!7!5!二、护理评估^_Label111!8!219!排泄情况：^_Label112!8!340!生活习惯：^_Label117!307!340!支/天^_Label118!601!340!两/天^_Label120!292!421!小时/天^"
   //"B102!50!30!姓名^B103!50!69!性别^B104!50!111!护理措施^B105!50!159!日期^CareDate!118!159!Wed Mar 20 00:00:00 UTC+0800 2013^Item3!146!111!undefined^Item3_1!undefined!undefined!床上系统^Item2!110!63!女^Item1!106!30!哦哦^"
   //s a=##class(web.DHCNurRecComm).ParseStr("B102!50!30!姓名^B103!50!63!性别^B104!50!113!护理措施^B105!50!159!日期^CareDate!118!159!Wed Mar 20 00:00:00 UTC+0800 2013^Item3!146!111!undefined^Item3_1!undefined!undefined!床上系统^Item3_2!undefined!undefined!肯定打开^Item2!110!63!男^Item1!106!30!1222^")
   //s arr=^TMP("arr")
      s ^ojbkkk(arr)=""
   s l=$L(arr,"^")
   k tmp,txt,pmp
   s tmp=""
   for i=1:1:l
   {
     s itm=$P(arr,"^",i)
     if itm="" continue
     s at=$P(itm,"!",1)
     s av=$P(itm,"!",4)
     s del=$P(at,"_")
     if (del'="")&($P(at,"_",2)="") s del=""
     
     s x=$P(itm,"!",2)
     s y=$P(itm,"!",3)
     if del'=""
     {
	   if $D(tmp(del))&($G(tmp(del))'="")&(av'="")  
	   {
		   if (av'="undefined") s tmp(del)=tmp(del)_","_av
	   }
	   if '$D(tmp(del))
	   {
		    if (av'="undefined") s tmp(del)=av
	   }
	 }else{
		  if (av'="undefined") s tmp(at)=av
		 if (x'="undefined") s pmp(at)=x_"!"_y
     
		 }
   }
   s itm=""  f  s itm=$O(pmp(itm)) q:itm=""  d
   .s x=$P(pmp(itm),"!"),y=$P(pmp(itm),"!",2)
   .s x=$INUMBER(x,"T"),y=$INUMBER(y,"T")
   .if $D(tmp(itm))&($G(tmp(itm))'="") d
   ..if ($F(itm,"Label")'=0) s txt(y,x)=..getitm(tmp(itm))
   ..e  d
   ...if ($E(itm,1)="B") s txt(y,x)=..getitm(tmp(itm))
   ...e  s txt(y,x)=tmp(itm)_";"
   .
   s strret=""
   s preY=""
   /*
      s py=""  f  s py=$O(txt(py)) q:py=""  d
   .s px=""  f  s px=$O(txt(py,px)) q:px=""  d
   ..s strret=txt(py,px)
   ..if (($F(strret,":")'=0)!($F(strret,"：")'=0)) d
   ...s aa=$O(txt(py,px))
   ...b //ssss
   ...s retstr=txt(py,aa)
   ...b
   ...if ($F(retstr,";")=0) k txt(py,px)

   
   */
   s i=1
   s rrr=""
   s py=""  f  s py=$O(txt(py)) q:py=""  d
   .s px=""  f  s px=$O(txt(py,px)) q:px=""  d
   ..s strret=txt(py,px)
   ..s tt(i)=strret
   ..s i=i+1
  
   s j=1
   s r=""  f  s r=$O(tt(r)) q:r=""  d
   .s a=$O(tt(r))
   .if (a'="") d
   ..s bb=tt(a)
   ..if ($F(bb,";")'=0) d
   ...s lm(j)=tt(r)
   ...s j=j+1
   ...s lm(j)=bb
   ...s j=j+1
   s ret=""
   s k="" f  s k=$O(lm(k)) q:k=""  d
   .s ret=ret_lm(k)
   b //
 q ret
}

// d ##class(web.DHCNurRecComm).getitm("Wed Mar 20 00:00:00 UTC+0800 2013;")

ClassMethod getitm(itm) As %String
{
  
   if ($F(itm,":")=0)&($F(itm,"：")=0)  s itm=itm_":"
   q itm
}

// d ##class(%ResultSet).RunQuery("web.DHCNurRecComm","GetAllPatient","70^^2013-03-02^10:00^")

ClassMethod GetAllPatientExecute(ByRef qHandle As %Binary, Parr As %String) As %Status
{
	  // n (Ward,RegNo)
	      Set repid=$I(^CacheTemp)
 	      s ind=1
 	     // s Parr="83^^2010-12-10^3:00^"
 	      //s ^tmpparrTH=Parr
 	      s Ward=$p(Parr,"^")
 	      s RegNo=$p(Parr,"^",2)
 	      s StrDate=$p(Parr,"^",3)
 	      s StrTime=$p(Parr,"^",4)
 	      s BabyFlag=$p(Parr,"^",5)
 	      
 	      //按就诊ID只查询出院病人
 	      i RegNo'="" d
 	      .s admVisitStat=$p($g(^PAADM(RegNo)),"^",20)
		  .i admVisitStat'="D" s RegNo=""
		  
		  s wardFlag=$P($g(^CTLOC(Ward)),"^",13)
		  i (wardFlag="W")!(wardFlag="EM") s Ward=..getlocward(Ward)
		  
		  b ;001
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
           ...s parr=Adm_"^"_StrDate_"^"_StrTime_"^"_"DHCNURXH_YTCRL^false"
           ...s aaa=..getobjval2(parr)
           ...b ;33
           ...//s aa=..getobjval(Adm,StrDate,StrTime)
	       ...s aaa="Adm|"_Adm_"^PatName|"_Name_"^BedCode|"_Bed_"^RegNo|"_PatRegNo_"^"_aaa
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
           ...s parr=Adm_"^"_StrDate_"^"_StrTime_"^"_"DHCNURXH_YTCRL^false"
           ...s aaa=..getobjval2(parr)
	       ...s aaa="Adm|"_Adm_"^PatName|"_Name_"^BedCode|"_Bed_"^RegNo|"_PatRegNo_"^"_aaa
           ...d OutPat
	      }
	      //b ;03
	      if (RegNo'="")
	      {        s RowId=RegNo
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
	set Data=$lb(aaa)
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

ClassMethod Patinfo(Adm As %String) As %String
{
		//n (Adm)
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
    ///s a=##class(web.DHCThreeNew).getobjval()
	//n (RowId,StrDate,StrTime) 
	 //s RowId=325017
	// s StrDate="2010-11-5"  
	// s StrTime="02:00:00"
	  s a=##class(Nur.DHCNurTempSet).GetSetID("TempChart")
      s tmp=""
      s ret=##class(Nur.DHCNurTempSet).getVal(a)
      s aa=##class(web.DHCMGNurComm).settmp(ret,.tmp)

	  s temp=tmp("YTemp")  //体温与
	  s wultemp=tmp("WlTemp")   //物理降温
	  s blankitm=tmp("BlankCode")
	  s HP=""
	  s l=$L(blankitm,",")
	  for i=1:1:l
	  {
	    s itm=$P(blankitm,",",i)
	    s code=$P(itm,":",1)
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
	  ...i itmdr'=12 s P1=$TR(P1," ","")
	  ...s P1=$ZCVT(P1,"O","JS")
	  ...s itmcode=$p($G(^MRC("OBITM",itmdr)),"^",1)
	  ...q:itmcode=""
	  ...q:$D(Blank(itmcode)) //如果空白栏已有值
	  ...s tmp(itmcode)=P1
	  ...if (Desc'="" )&(P1'="")&((itmcode=temp)!(itmcode="Item12")!(itmcode="Item20")) s tmp(wultemp)=Desc
	  s ret=""
	   s k=""  
	  	f {
		   s k=$O(tmp(k))
		   q:k=""  
		   s ret=ret_k_"|"_tmp(k)_"^"
	  	  }

	  q ret
}

ClassMethod getlocward(loc) As %String
{
  s ward=$O(^PAWARD(0,"WARD_LocationDR",loc,"")) 
  q ward
}

// d ##class(web.DHCNurRecComm).getobjval2("1277836^2013-03-02^14:00^DHCNURXH_YTCRL^false")

ClassMethod getobjval2(parr) As %String
{
   
 	s aa=""
 	s Adm=$P(parr,"^",1)
 	s stdate=$ZDH($P(parr,"^",2),3)
 	s StTime=$ZTH($P(parr,"^",3))
 	s RecTyp=$P(parr,"^",4)
 	s RecTyp=$ZConvert(RecTyp,"U")
 	s IfCancelRec=$P(parr,"^",5)
 	 // s a=##class(Nur.DHCNurTempSet).GetSetID("TempChart")
      //s tmp=""
      //s ret=##class(Nur.DHCNurTempSet).getVal2(a)
      //s aa=##class(web.DHCMGNurComm).settmp(ret,.tmp)
     // s blankitm=tmp("BlankCode")
	s tmp("Item1")=""
 	s tmp("Item2")=""
 	s tmp("Item3")=""
 	s tmp("Item4")=""
 	s tmp("Item21")=""
 	s tmp("Item27")=""
 	s tmp("Item29")=""
 	s tmp("Item31")=""
 	s tmp("Item33")=""
 	s tmp("Item24")=""
 	s tmp("Item16")=""
 	s tmp("rw")=""
 	s tmp("par")=""
 	s tmp("CaseMeasure")=""
	s par=$O(^Nur.DHCNurseRecParentI("Episode"," "_Adm,""))
	//b ;00
	s flagcancell=""
	s existflag=""
    if par=""  q aa
    s rw="" f  s rw=$O(^Nur.DHCNurseRecSubI("TypDatTim"," "_RecTyp,stdate,StTime,par,rw)) q:(rw="")!(existflag=1)  d
        .s arr=$G(^Nur.DHCNurseRecSubD(par,rw))
        .s tmp=""
        .s flagcancell=""
        
        .s tmp("rw")=rw,tmp("par")=par
        .s a=##class(Nur.DHCNurseRecSub).getVal(par_"||"_rw,.tmp)
        .s cdate=tmp("CareDate"),ctime=tmp("CareTime")
        .s cdatetime=..GetAbsTime(cdate_","_ctime)
		.s cdate=$ZD(cdate,3),ctime=$ZT(ctime,2)
		.s CaseMeasure=tmp("CaseMeasure")
		.s tmp("CareDate")=cdate,tmp("CareTime")=ctime
		.s recuserId=tmp("RecUser")
		.i recuserId'="" s tmp("User")=$p($g(^SSU("SSUSR",recuserId)),"^",2)
		.e  s tmp("User")=""
		.s recaudituserId=tmp("RecAuditUser")
		.i recaudituserId'="" s AuditUser=$p($g(^SSU("SSUSR",recaudituserId)),"^",2)
		.e  s AuditUser=""
		.i AuditUser'="" d
		..s tmp("User")=tmp("User")_" "_AuditUser
		.s reccanceluserId=tmp("RecCancelUser")
		.i (IfCancelRec'="true")&(reccanceluserId'="") d
		..s flagcancell=1
		.b ;009
		.q:(IfCancelRec="true")&(reccanceluserId="")
		.q:(IfCancelRec'="true")&(reccanceluserId'="")
		.i reccanceluserId'="" d
		..s CancelUser=$p($g(^SSU("SSUSR",reccanceluserId)),"^",2)
		..s reccanceldate=tmp("RecCancelDate")
		..i reccanceldate'="" s reccanceldate=$ZD(reccanceldate,3)
		..s reccanceltime=tmp("RecCancelTime")
		..i reccanceltime'="" s reccanceltime=$ZT(reccanceltime)
		..s tmp("User")=tmp("User")_" 作废记录:"_CancelUser_" "_reccanceldate_" "_reccanceltime
		..s existflag=1
		
		b ;4
      //s l=$L(blankitm,",")
      s ret=##class(Nur.DHCNurseRecSub).GetBlankDesc2(Adm,stdate,StTime,"1")
      s tmp("Item34")=$p(ret,"^",1)
      s tmp("Item26")=$p(ret,"^",2)
      s tmp("Item28")=$p(ret,"^",3)
      s tmp("Item30")=$p(ret,"^",4)
      s tmp("Item32")=$p(ret,"^",5)
      s tmp("Item17")=$p(ret,"^",6)
      s tmp("Item15")=$p(ret,"^",7)
   
 s tmp("Adm")=Adm
 i flagcancell=1 q aa
 s aa=..getRet2(.tmp)
 b ;01
 q aa
}

ClassMethod getRet2(tmp) As %String
{
	s k=""
	s str="ChartCode^GMS^DiagnosDr^GTemp^HPItm^HeadDR^Heart^InOutCode^InOutDr^InOutTime^"
	s ret=""
	f {
	s k=$O(tmp(k))
	//q:str[k
	i k="BlankCode" continue
	q:k=""
	s ret=ret_k_"|"_tmp(k)_"^"
	}
 q ret
}

ClassMethod DischargePatinfo(Adm As %String) As %String
{
		//n (Adm)
           
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

// d ##class(web.DHCNurRecComm).getxyd("1192312","2013-03-08")

ClassMethod getxyd(Adm, date) As %String
{
     
      i (Adm="")!(date="") q "&"
      s par=$O(^Nur.DHCNurseRecParentI("Episode"," "_Adm,""))
	  s RecTyp="DHCNURXH_ZXGXBYZBRHLJLD"
	  s date=$zdh(date,3)
	  s flag1=""  //移植后天数
	  s flag2=""
	  s flag3=""
	  s flag4=""
	  s flag5=""
	  s flag6=""
	  s ret=""
	  s tim="" f  s tim=$O(^Nur.DHCNurseRecSubI("TypDatTim"," "_RecTyp,date,tim),-1) q:(tim="")!(flag6=1)  d
      .s rw="" f  s rw=$O(^Nur.DHCNurseRecSubI("TypDatTim"," "_RecTyp,date,tim,par,rw),-1) q:(rw="")!(flag6=1)  d
      ..s id=par_"||"_rw
      ..s a=##class(Nur.DHCNurseRecSub).%OpenId(id)
      ..s Item24=a.Item24 //移植后天数
      ..s WBC=a.Item25
      ..s NEUT=a.Item26
      ..s PLT=a.Item27
      ..s HGB=a.Item28
      ..b ;00
      ..i (flag1="")&&(Item24'="") s flag1=Item24
      ..i (flag2="")&&(WBC'="") s flag2=WBC
      ..i (flag3="")&&(NEUT'="") s flag3=NEUT
      ..i (flag4="")&&(PLT'="") s flag4=PLT
      ..i (flag5="")&&(HGB'="") s flag5=HGB
      ..i (flag1'="")&(flag2'="")&(flag3'="")&(flag4'="")&(flag5'="") s flag6=1
      ..b ;001
      s ret=flag1_"&WBC:"_flag2_"   NEUT:"_flag3_"   PLT:"_flag4_"   HGB:"_flag5
      b
      q ret
}

/// 获取生命体征第一次的值  传进就诊ID参数 传出温度，脉搏，呼吸，收缩压，舒张压
/// lwd 20130329
ClassMethod GetFirstData(EpisodeID As %String) As %String
{
	//w ##class(web.DHCTHREEE).GetFirstData("24")
	//n (EpisodeID)
	s MRADMROWId=$P(^PAADM(EpisodeID),"^",61)  
	s flag=0 s flag2=0 s flag3=0 s flag4=0 s flag5=0
	s nurTime="" s nurTime2="" s nurTime3="" s nurTime4="" s nurTime5=""  s GetTime=""
	s StrItemold=""
	s temper="" s plus="" s SSY="" s SZY="" s BreathValue="" s ObDate=""
	s StrDate=""  f  s StrDate=$O(^MR(MRADMROWId,"OBS",0,"Date",StrDate)) q:(StrDate="")||((ObDate'="")&&(ObDate'=StrDate))  d
	.s ObDate=StrDate
	.s StrItem=""  f  s StrItem=$O(^MR(MRADMROWId,"OBS",0,"Date",StrDate,StrItem)) q:(StrItem="")  d
    ..s chl="" 
    ..f  s chl=$O(^MR(MRADMROWId,"OBS",0,"Date",StrDate,StrItem,chl)) q:(chl="")  d
    ...s temperID=MRADMROWId_"||"_chl
    ...s GetTime=$P(^MR(MRADMROWId,"OBS",chl),"^",4)
    ...s tempItem="" s tempOBSValue="" s tempOBSTime=""
    ...s ddd=MRADMROWId_"@"_chl_"@"_flag_"@"_StrItem
    ...i (StrItem="14")&&(flag'=1) d
    ....s temper=$P(^MR(MRADMROWId,"OBS",chl),"^",2)
    ....s nurTime=$P(^MR(MRADMROWId,"OBS",chl),"^",4)
    ....s flag=1
    ...i (StrItem="10")&&(flag2'=1) d
    ....s plus=$P(^MR(MRADMROWId,"OBS",chl),"^",2)
    ....s nurTime2=$P(^MR(MRADMROWId,"OBS",chl),"^",4)
    ....s flag2=1   
    ...i (StrItem="11")&&(flag3'=1) d
    ....s BreathValue=$P(^MR(MRADMROWId,"OBS",chl),"^",2)
    ....s nurTime3=$P(^MR(MRADMROWId,"OBS",chl),"^",4)
    ....s flag3=1
    ...i (StrItem="16")&&(flag4'=1) d
    ....s SSY=$P(^MR(MRADMROWId,"OBS",chl),"^",2)
    ....s nurTime4=$P(^MR(MRADMROWId,"OBS",chl),"^",4)
    ....s flag4=1
    ...i (StrItem="17")&&(flag5'=1) d
    ....s SZY=$P(^MR(MRADMROWId,"OBS",chl),"^",2)
    ....s nurTime5=$P(^MR(MRADMROWId,"OBS",chl),"^",4)
    ....s flag5=1
    ...i (StrItem="14")&&(flag=1)&&(GetTime<nurTime)&&(GetTime'="")&&(nurTime'="") d
    ....b ;31
    ....s temper=$P(^MR(MRADMROWId,"OBS",chl),"^",2)
    ....s nurTime=$P(^MR(MRADMROWId,"OBS",chl),"^",4)
    ...i (StrItem="10")&&(flag2=1)&&(GetTime<nurTime2)&&(GetTime'="")&&(nurTime2'="") d
    ....b ;32
    ....s plus=$P(^MR(MRADMROWId,"OBS",chl),"^",2)
    ....s nurTime2=$P(^MR(MRADMROWId,"OBS",chl),"^",4)
    ...i (StrItem="11")&&(flag3=1)&&(GetTime<nurTime3)&&(GetTime'="")&&(nurTime3'="") d
    ....b ;33
    ....s BreathValue=$P(^MR(MRADMROWId,"OBS",chl),"^",2)
    ....s nurTime3=$P(^MR(MRADMROWId,"OBS",chl),"^",4)
    ...i (StrItem="16")&&(flag4=1)&&(GetTime<nurTime4)&&(GetTime'="")&&(nurTime4'="") d
    ....b ;34
    ....s SSY=$P(^MR(MRADMROWId,"OBS",chl),"^",2)
    ....s nurTime4=$P(^MR(MRADMROWId,"OBS",chl),"^",4)
    ...i (StrItem="17")&&(flag5=1)&&(GetTime<nurTime5)&&(GetTime'="")&&(nurTime5'="") d
    ....b ;35
    ....s SZY=$P(^MR(MRADMROWId,"OBS",chl),"^",2)
    ....s nurTime5=$P(^MR(MRADMROWId,"OBS",chl),"^",4)
    
    q $G(temper)_"^"_$g(plus)_"^"_$G(BreathValue)_"^"_$G(SSY)_"/"_$G(SZY)
}

ClassMethod getUserNameByCode(usercode As %String) As %String
{
	q:usercode="" ""
	s usercode=$tr(usercode," ","")
	s usercode=$ZCvt(usercode,"U")
	s ret=""
	s userid=$O(^SSU("SSUSR",0,"SSUSR_Initials",usercode,""))
	i userid'="" d
	.s name=$P($g(^SSU("SSUSR",userid)),"^",2)
	.s ret=name
	q ret
}

}
