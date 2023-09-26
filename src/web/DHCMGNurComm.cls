Class web.DHCMGNurComm Extends %RegisteredObject [ ProcedureBlock ]
{

// 获得手术

ClassMethod GetORCOperation(ids As %String) As %String
{
 	//s a=##class(web.DHCMGNurComm).GetORCOperation("SKZXS")
     q:"" ""
     s ids=$ZConvert(ids,"U")
	 s id=ids
	 s ln=$L(ids)
	 s im=ids
	 s ret=""
	 if (ids'="") d
	 .s ids=$$ALPHAUP^SSUTIL4(ids)
	 .s flag="N"
	 .s OpDes=$O(^ORC("OPER",0,"ALIAS",ids),-1)
	 .if ids'="" d
	 ..f  s OpDes=$O(^ORC("OPER",0,"ALIAS",OpDes)) q:(OpDes="")!(flag="Y")  d
	 ...i $p(OpDes,ids)'="" s flag="Y" q
	 ...s operId=""
	 ...f  s operId=$O(^ORC("OPER",0,"ALIAS",OpDes,operId)) q:operId=""  d
	 ....s rowid0=operId
	 ....s OPTypeDes=$p(^ORC("OPER",operId),"^",2)
	 ....s OPTypeCode=$p(^ORC("OPER",operId),"^",1)
	 ....s Opcatdr=$p(^ORC("OPER",operId),"^",7)
	 ....b ;44
	 ....i Opcatdr'="" d
	 .....s Opcatdesc=$p(^ORC("CATEG",Opcatdr),"^",2)
	 ....d sa
	 q ret
	 
sa
     s ret=ret_OPTypeCode_"|"_OPTypeDes_"^"
     q
}

ClassMethod GetQueryCombox(QueryName As %String, parrm As %String, funname As %String, desc As %String) As %String
{
  	//s a=##class(web.DHCPrisonComm).GetQueryCombox()
  	//s QueryName="web.DHCPrisonComm:ArcItemCat"
  	// s parrm=""
  	// s funname="addLab"
  	// s desc="CatDesc"

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
     	if i<l s pp=pp_p_","
     	e  s pp=pp_p 
   	}
   	Set rset = ##class(%ResultSet).%New(QueryName)
   	Set columns = rset.GetColumnCount()
 	// Execute the query
  	if pp="" s sc=rset.Execute()
  	else  s sc = rset.Execute(@pp)
  	s i=0
  	While (rset.Next()) 
  	{
       	s coldata=""
       	s rd="["
       	For col = 1:1:columns 
       	{
	       	s aa=rset.GetData(col)
	       	s l=$L(aa,"^")
	       	k tmp
	       	s tmp=""
	       	s aa=##class(web.DHCPrisonComm).settmp(aa,.tmp)
		   	s colret="{id:'"_tmp("rw")_"',desc:'"_tmp(desc)_"'}"
        }
        s coldata="'"_$ZCVT(colret,"O","JS")_"'"
   		s rtnval=funname_"("_coldata_");"

  	&javascript<#(rtnval)#>
 	}
 	Do rset.Close()
 	//	    .//s rtnval=funname_"('"_$ZCVT($g(condep),"O","JS")_"','"_$ZCVT($g(status),"O","JS")_"','"_$ZCVT($P($g(bedcode),"@",2),"O","JS")_"','"_$ZCVT($g(appdep),"O","JS")_"','"_$ZCVT($g(inout),"O","JS")_"','"_$ZCVT($P($g(Diag),"@",2),"O","JS")_"','"_$ZCVT($g(condestinat),"O","JS")_"','"_$ZCVT($P($g(patname),"@",2),"O","JS")_"','"_$ZCVT($g(apptime),"O","JS")_"','"_$ZCVT($g(appdate),"O","JS")_"','"_$ZCVT($g(consultdate),"O","JS")_"','"_$ZCVT($g(contime),"O","JS")_"','"_$ZCVT($g(Adm),"O","JS")_"','"_$ZCVT($g(id),"O","JS")_"');"

 	q 0
}

ClassMethod getCdate(datestr) As %String
{
  	//s aa=##class(User.DHCPregCurrStat).getdate(datestr)
   	if datestr'=""  s datestr=$ZD(datestr,3)
   	q datestr
}

ClassMethod getCtime(timstr) As %String
{
  	//s aa=##class(User.DHCPregCurrStat).gettime(datestr)
   	if timstr'=""  s timstr=$Zt(timstr,4)
   	q timstr
}

ClassMethod setmoudtmp(parr, tmval)
{
  	//class(web.DHCMGNurComm).setmoudtmp()
    s par1=$P(parr,"&")
    s chepar=$P(parr,"&",2)
	s l=$L(chepar,"^")
	//s ^TMVAL("V")=chepar
	s comboret=$P(parr,"&",3)
	f i=1:1:l
	{
	  	s itm=$P(chepar,"^",i)
	  	if itm="" continue
	  	s arr=$P(itm,"|")
	  	s name=$P(arr,"_")
	  	s selcode=$P(arr,"_",2)
	  	s val=$P(itm,"|",2)
	  	s ll=$l(itm,"|")                      //多选
	  	s val3=$P(itm,"|",3)                  //多选
	  	if (val'="")&&(ll=2) s val=val        //多选
	  	if (val'="")&&(ll=3) s val="☑"_val  //多选
	  	if (val="")&&(ll=3) s val="□"_val3    //多选
      	//if '$D(tmval(name)) s tmval(name)=selcode_"|"_val
	  	//e  s tmval(name)=tmval(name)_selcode_"|"_val_"^"
	  	if '$D(tmval(name))
	  	{
			// if (val'="") 
		 	s tmval(name)=val
	  	}
	  	else  
	  	{ 
		 	if (val'="") s tmval(name)=tmval(name)_";"_val
	  	}
	}
	s l=$L(par1,"^")
	for i=1:1:l
	{
	  	s itm=$P(par1,"^",i)
	  	if itm="" continue
	  	s name=$P(itm,"|")
	  	s val=$P(itm,"|",2)
	  	s tmval(name)=val
	}
	s l=$L(comboret,"^")
	for i=1:1:l
	{
	  	s itm=$P(comboret,"^",i)
	  	if itm="" continue
	  	s name=$P(itm,"|")
	  	s arr=$P(itm,"|",2)
	  	s val=$P(arr,"!",1)
	  	s des=$P(arr,"!",2)
	  	//s tmval(name)=val_"!"_des
	  	s tmval(name)=val
	}
	//圆形单选
	s radioret=$P(parr,"&",4)
	s ralen=$L(radioret,"^")
	for r=1:1:ralen
	{
		s rr=$P(radioret,"^",r)	
		if rr="" continue
	  	s arr=$P(rr,"|")
	  	s name=$P(arr,"_")
	  	s selcode=$P(arr,"_",2)
	  	s val=$P(rr,"|",2)
	  	if '$D(tmval(name))
	  	{
		 	s tmval(name)=val
	 	}
	  	else  
	  	{ 
		 	i selcode'="" s tmval(name)=tmval(name)_";"_val
	  	}
	}
	//m ^TMVAL=tmval
	q 0
}

ClassMethod setmoudtmpback(parr, tmval)
{
  	//class(web.DHCMGNurComm).setmoudtmp()

    s par1=$P(parr,"&")
    s ^objcyf0909=parr
    s chepar=$P(parr,"&",2)
	s l=$L(chepar,"^")
	//s ^TMVAL("V")=chepar
	s comboret=$P(parr,"&",3)
	s radioret=$P(parr,"&",4)
	f i=1:1:l
	{
	  	s itm=$P(chepar,"^",i)
	  	if itm="" continue
	  	s arr=$P(itm,"|")
	  	s name=$P(arr,"_")
	  	s selcode=$P(arr,"_",2)
	  	s val=$P(itm,"|",2)
      	//if '$D(tmval(name)) s tmval(name)=selcode_"|"_val
	  	//e  s tmval(name)=tmval(name)_selcode_"|"_val_"^"
	  	if '$D(tmval(name)) s tmval(name)=val
	  	e  s tmval(name)=tmval(name)_";"_val
	}
	s l=$L(par1,"^")
	for i=1:1:l
	{
	  	s itm=$P(par1,"^",i)
	  	if itm="" continue
	  	s name=$P(itm,"|")
	  	s val=$P(itm,"|",2)
	  	s tmval(name)=val
	}
	s l=$L(comboret,"^")
	for i=1:1:l
	{
	  	s itm=$P(comboret,"^",i)
	  	if itm="" continue
	  	s name=$P(itm,"|")
	  	s arr=$P(itm,"|",2)
	  	s val=$P(arr,"!",1)
	  	s des=$P(arr,"!",2)
	  	//s tmval(name)=val_"!"_des
	  	s tmval(name)=val
	}
	s l=$L(radioret,"^")
	for i=1:1:l
	{
	  	s itm=$P(radioret,"^",i)
	  	if itm="" continue
	  	s arr=$P(itm,"|")
	  	s name=$P(arr,"_")
	  	s selcode=$P(arr,"_",2)
	  	s val=$P(itm,"|",2)
      	//if '$D(tmval(name)) s tmval(name)=selcode_"|"_val
	  	//e  s tmval(name)=tmval(name)_selcode_"|"_val_"^"
	  	if '$D(tmval(name)) s tmval(name)=val
	  	e  s tmval(name)=tmval(name)_";"_val
	}
	//m ^TMVAL=tmval
	q 0
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

ClassMethod Getuser(user) As %String
{
  	s user=$p(^SSU("SSUSR",user),"^",2)
  	q user_"^"
}

ClassMethod SubMessageExecute(ByRef qHandle As %Binary, parent As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//补贴调节记录
    //s parr="2009-10-4^2009-12-25"
 	//Set qHandle=$lb(0,repid,0) Quit $$$OK
	s rw=""  f  s rw=$O(^User.DHCMGDepMessageD(parent,"ChildSub",rw)) q:rw=""  d
    .s a=^User.DHCMGDepMessageD(parent,"ChildSub",rw)
    .s usdr=$List(a,5)
    .q:usdr=""
    .s content=$List(a,2)  //s date=$List(a,7)
    .s time=$list(a,4)
    .s date=$list(a,3)
    .q:'$D(^User.DHCMGPersonsD(usdr))
 	.s parr=^User.DHCMGPersonsD(usdr)
    .s name=$list(parr,21)
    .s sdate=$ZD(date,3)
    .s stime=$ZT(time)
    .d OutRowtyp

	//s head="科  室|总分|"_head  
   	//	s colwidth="100|70|"_colwidth
	//s quret=head_$C(2)_colwidth_$C(2)_quret
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(sdate,stime,name,content,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod SubMessageFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SubMessageExecute ]
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

ClassMethod SubMessageClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SubMessageExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

Query SubMessage(parr As %String) As %Query(ROWSPEC = "mdate,mtime,muser,content,rw")
{
}

ClassMethod DepParMessageExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//补贴调节记录
    //s parr="2009-10-4^2009-12-25^1304"
 	s stdate=$P(parr,"^",1)
 	s edate=$P(parr,"^",2)
 	s dep=$P(parr,"^",3)
 	s stdate=$ZDH(stdate,3),edate=$ZDH(edate,3)
 	//Set qHandle=$lb(0,repid,0) Quit $$$OK
    f date=stdate:1:edate
    {
		s rw=""  f  s rw=$O(^User.DHCMGDepMessageI("DepDate"," "_dep,date,rw)) q:rw=""  d
        .s a=^User.DHCMGDepMessageD(rw)
        .s usdr=$List(a,6)
        .q:usdr=""
        .s loc=$List(a,3)
        .s content=$List(a,2)  //s date=$List(a,7)
        .s time=$list(a,5)
        .q:'$D(^User.DHCMGPersonsD(usdr))
     	.s parr=^User.DHCMGPersonsD(usdr)
        .s name=$list(parr,21)
        .s sdate=$ZD(date,4)
        .s stime=$ZT(time)
        .d OutRowtyp
    }
   	//s head="科  室|总分|"_head  
   	// s colwidth="100|70|"_colwidth
   	//s quret=head_$C(2)_colwidth_$C(2)_quret
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(sdate,stime,name,content,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod DepParMessageFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DepParMessageExecute ]
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

ClassMethod DepParMessageClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DepParMessageExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

Query DepParMessage(parr As %String) As %Query(ROWSPEC = "mdate,mtime,muser,content,rw")
{
}

ClassMethod GetWardInfo(ward) As %String
{
 	//交班记录 web.DHCMGNurComm^GetWardInfo^Ward^S104|outpat@S102|inpat@S105|tranin@S103|tranout@S106|death@S109|sicktodeath@S107|oper@S101|sumpat
  	s outpat=0,inpat=0,tranin=0,tranout=0,death=0,sicktodeath=0,oper=0,sumpat=0,baby=0
  	s itm="" f  s itm=$O(^Nur.DHCMGCurrDayAttenNumI("WardCurr"," "_ward,+$H,itm)) q:itm=""  d
  	.s rw=""  f  s rw=$O(^Nur.DHCMGCurrDayAttenNumI("WardCurr"," "_ward,+$H,itm,rw)) q:rw=""  d
   	.. s itmw=$TR(itm," ","")
   	.. s a=^User.DHCMGNurWorkItmD(itmw)
   	.. s Name=$ListGet(a,4)
   	.. 
   	.. s b=^Nur.DHCMGCurrDayAttenNumD(rw)
   	.. s num=$listget(b,4)
   	.. if Name["出院" s outpat=num
   	.. if Name["入院" s inpat=num
   	.. if Name["转入" s tranin=num
   	.. if Name["转出" s tranout=num
   	.. if Name["死亡" s death=num
   	.. if Name["病危" s sicktodeath=num
   	.. if Name["手术" s oper=num
   	.. if Name["接生" s baby=num

   	s sumpat=..getcurrpatnum(ward)
   	s ret="outpat@"_outpat_"^inpat@"_inpat_"^tranin@"_tranin_"^tranout@"_tranout_"^death@"_death_"^sicktodeath@"_sicktodeath_"^oper@"_oper_"^sumpat@"_sumpat_"^baby@"_baby
  	q ret
}

ClassMethod getcurrpatnum(ward) As %String
{
  	s pacward=$O(^PAWARD(0,"WARD_LocationDR",ward,""))
  	q:pacward=""
   	s num=0
  	s room=""  f  s room=$O(^PAADMi("CurrWard",pacward,room)) q:room=""  d
  	.s adm=""  f  s adm=$O(^PAADMi("CurrWard",pacward,room,adm)) q:adm=""  d   
  	..s num=num+1
  	q num
}

ClassMethod GetPat(RegNo As %String) As %String
{
 	//s a=##class(web.DHCMGNurComm).GetPat(
   	s str=##class(web.DHCMGNurComm).GetCurrAdm(RegNo)
   	if str="" q ""

   	s patinfo=..PatInfo(str)
   	s patname=$P(patinfo,"^",5)
   	s BedCode=$P(patinfo,"^",6)
   	q $P(patname,"@",2)_"^Adm@"_str_"^"_BedCode
}

ClassMethod Diag20141216(mradm, typ)
{
 	//web.DHCMGNurComm^GetPat^^S0|PATNAME@S1|AGE@S2|SEX@S3|DIAG@S4|LOC
    s i=0
    s diag=""
    f a2=1:1:$g(^MR(mradm,"DIA",0)) d
    .s icdr=$p($g(^MR(mradm,"DIA",a2)),"^",1)
    .i icdr'="" d
    ..i $g(diatypedr)'="" s diatype=$P($g(^MRC("DTYP",diatypedr)),"^",1)  ;诊断类型
    ..e  s diatype=""
    ..;q:diatype'=typ
    ..q:(diatype'=typ)&(typ'="")
    ..s date=$ZD($p($g(^MR(mradm,"DIA",a2)),"^",7),3) ;日期
    ..s statusdr=$p($g(^MR(mradm,"DIA",a2)),"^",9)
    ..//i statusdr'="" d
    ..//.s status=$P($g(^MRC("DSTAT",statusdr)),"^",2)
    ..//.e  d
    ..//..s status=""
    ..s icdcode=$P($g(^MRC("ID",icdr)),"^",2)   ;疾病描述
    ..s mrdesc=""
    ..f de=1:1:$g(^MR(mradm,"DIA",a2,"DES",0)) d
    ...s mrdesc=$g(mrdesc)_$g(^MR(mradm,"DIA",a2,"DES",de)) ;
    ..s i=i+1
    ..;s diag=icdcode_" "_$g(mrdesc)
    ..i diag="" s diag=icdcode_" "_$g(mrdesc)
    ..e  s diag=diag_";"_icdcode_" "_$g(mrdesc)
  
    q diag
}

// w ##class(web.DHCMGNurComm).PatInfo("267")

ClassMethod PatInfo127(curId) As %String
{
	//病人基本信息;入参:登记号或OEORI_ROWID,根据最后一个ADM取信息
   	// n (curId)
    s ^ojbcff=curId
    q:curId="" ""
    s admId=curId
    //s Res=##class(web.DHCCLCom).PatInfo(""_"^"_curId)  //WKZ 071119
    s admreasondr=$p($g(^PAADM(curId,1)),"^",7) //病人类别
    if admreasondr'="" s admreason=$P($G(^PAC("ADMREA",admreasondr)),"^",2)
    q:'$d(^PAADM(admId)) ""
    s papmiId=+$g(^PAADM(admId))
    q:papmiId=""
    s NationDr=$p($g(^PAPER(papmiId,"PER",2)),"^",1)
    i NationDr'="" d
    .s Nation=$p($P(^CT("NAT",NationDr),"^",2),"-",2)
    e  d
    .s Nation=""                                       //民族
    s paersonLX=$p($g(^PAPER(papmiId,"PER",2)),"^",13) //联系人
    s PAPEROccupationdr=$p($g(^PAPER(papmiId,"PER",2)),"^",6) //职业
    i PAPEROccupationdr'="" s PAPEROccupationdesc=$p(^CT("OCC",PAPEROccupationdr),"^",2)
    e  s PAPEROccupationdesc=""
    s PAPERCTRLTDR=$p($g(^PAPER(papmiId,"EMP")),"^",4) //与患者关系
    i PAPERCTRLTDR'="" s PAPERCTRLTDesc=$p(^CT("RLT",PAPERCTRLTDR),"^",2)
    e  s PAPERCTRLTDesc=""
    s PAPERMaritalDR=$p($g(^PAPER(papmiId,"PER",2)),"^",3) //婚姻状况
    i PAPERMaritalDR'="" s PAPERMaritalDesc=$p(^CT("MAR",PAPERMaritalDR),"^",2)   //CT_Marital
    e  s PAPERMaritalDesc=""
    s mradm=$p(^PAADM(admId),"^",61)
    ;s diag=..Diag(mradm,"PRE")
    s diag=..Diag(mradm,"")
    s ctlocId=$p(^PAADM(admId),"^",4)
	s ctlocDesc=$p(^CTLOC(+ctlocId),"^",2)	
	i ctlocDesc["-"  s ctlocDesc=$P(ctlocDesc,"-",2)
	s doc=$p(^PAADM(admId),"^",9)
	if doc'="" s DocDes=$P($G(^CTPCP(doc,1)),"^",2)
    s roomId=$p(^PAADM(admId),"^",69)
    i (roomId'="") s room=$p(^PAROOM(roomId),"^",2)
    s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
    s MedCareNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)
    s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
    i $d(^PAPER(papmiId,"PAT",3)) s safetyNetCardNo=$p(^PAPER(papmiId,"PAT",3),"^",4) ;病案号
    e  s safetyNetCardNo=""
    s sex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
   
    S homeAddres=$g(^PAPER(papmiId,"PER","ADD")) // 住址
    s homeTel=$p($g(^PAPER(papmiId,"PER",1)),"^",11)  //家庭电话
    s workTel=$p($g(^PAPER(papmiId,"PER",1)),"^",9)   //工作电话
    s handtel=$p($g(^PAPER(papmiId,"PER",4)),"^",21)  //手机
    s bedSub=$p($p($g(^PAADM(admId)),"^",73),"||",2)
    s curWardId=$p($g(^PAADM(admId)),"^",70)  
    i curWardId'="" s wardDesc=$p(^PAWARD(curWardId),"^",2)
    i $g(wardDesc)["-" s wardDesc=$p(wardDesc,"-",2)
    i $g(wardDesc)["(" s wardDesc=$p(wardDesc,"(",1)
    i bedSub'="" s bedCode=$p($g(^PAWARD(curWardId,"BED",bedSub)),"^",1)
    e  s bedCode=""
    s birth=$p($g(^PAPER(papmiId,"ALL")),"^",6)
    s age=..CalAge(birth,+$h)
    s age=$p(age,"Y",1)
    s year=$p(age,"Y",1)
    i (year<2)  d
    .s month=$p($p(age,"Y",2),"M",1)
    .s day=$p($p(age,"M",2),"D",1)
    .s month=$tr(month," ","")
    .s day=$tr(day," ","")
    .i (month>0) s age=year*12+month_"月"
    .i (year=0)&(month=0) s age=day_"天"
    e  s age=year
    s DiagnosDr=$O(^Nur.DHCNurCopyDiagnosI("EpisodeId"," "_admId,""),-1)
	i DiagnosDr'="" s diag=$List(^Nur.DHCNurCopyDiagnosD(DiagnosDr),2)
	//e  s diag=""
	s diag=$tr(diag,";",",")
	s diag=$tr(diag," ","")
	s diag=$zcvt(diag,"O","JS")
	// i admId=195885 s ^pjf(1)=diag
	s AdmDate=$ZD($p($g(^PAADM(admId)),"^",6),3)
    s AdmTime=$ZT($p($g(^PAADM(admId)),"^",7),2)
     s DischgDate=$p($g(^PAADM(admId)),"^",17)
    i DischgDate'=""  s DischgDate=$zd(DischgDate,3)
    s DischgTime=$p($g(^PAADM(admId)),"^",18)
    i DischgTime'="" s DischgTime=$zt(DischgTime,2)
    //ctlocDesc未取后半部分 ypz 060522
    Set PatEncryptLevel=##class(web.DHCCLCom).GetPatEncryptLevel("",admId)
    Set EncryptLevel=$p(PatEncryptLevel,"^",1)
    Set PatLevel=$p(PatEncryptLevel,"^",2)
    s retStr="REGNO@"_regNo_"^LOC@"_ctlocDesc_"^ROOM@"_$g(room)_"^SEX@"_$g(sex)_"^PATNAME@"_$g(patName)_"^BEDCODE@"_$g(bedCode)_"^AGE@"_$g(age)_"岁^WARD@"_$g(wardDesc)_"^DIAG@"_diag_"^MedCareNo@"_MedCareNo_"^Telephone@"_homeTel_"^PatAddress@"_homeAddres_"^BirthDate@"_$ZD(birth,3)_"^BirthDate@"_$ZD(birth,3)_"^AdmDate@"_AdmDate_"^AdmTime@"_AdmTime_"^DischgDate@"_DischgDate_"^DischgTime@"_DischgTime_"^Nation@"_Nation_"^admreason@"_admreason_"^paersonLX@"_paersonLX_"^PAPEROccupationdesc@"_PAPEROccupationdesc_"^PAPERCTRLTDesc@"_PAPERCTRLTDesc_"^PAPERMaritalDesc@"_PAPERMaritalDesc
    q retStr
}

/// w ##class(web.DHCMGNurComm).PatInfo("313","")
ClassMethod PatInfo(curId, emrCode As %String = "") As %String
{
	//病人基本信息;入参:登记号或OEORI_ROWID,根据最后一个ADM取信息
   	// n (curId)
   	//w ##class(web.DHCMGNurComm).PatInfo(16)
    q:curId="" ""
    s admId=curId
    //s Res=##class(web.DHCCLCom).PatInfo(""_"^"_curId)  //WKZ 071119
  
    s admreasondr=$p($g(^PAADM(curId,1)),"^",7) //病人类别
    if admreasondr'="" s admreason=$P($G(^PAC("ADMREA",admreasondr)),"^",2)
    if $g(admreason)="广州医保" s admreason=admreason_"("_##class(web.DHCINSUPort).GetSybRylb(admId)_")"
    s InPatNo=$p($g(^PAADM(admId)),"^",29)   //住院次数
    s papmiId=+^PAADM(admId)
    s NationDr=$p($g(^PAPER(papmiId,"PER",2)),"^",1)
    i NationDr'="" d
    .s Nation=$P(^CT("NAT",NationDr),"^",2)
    e  d
    .s Nation=""                                       //民族
    s paersonLX=$p($g(^PAPER(papmiId,"PER",2)),"^",13) //联系人
    s PAPEROccupationdr=$p($g(^PAPER(papmiId,"PER",2)),"^",6) //职业
    i PAPEROccupationdr'="" s PAPEROccupationdesc=$p(^CT("OCC",PAPEROccupationdr),"^",2)
    e  s PAPEROccupationdesc=""
    s PAPERCTRLTDR=$p($g(^PAPER(papmiId,"EMP")),"^",4) //与患者关系
    i PAPERCTRLTDR'="" s PAPERCTRLTDesc=$p($g(^CT("RLT",PAPERCTRLTDR)),"^",2)
    e  s PAPERCTRLTDesc=""
    s PAPERMaritalDR=$p($g(^PAPER(papmiId,"PER",2)),"^",3) //婚姻状况
    i PAPERMaritalDR'=""&&(+PAPERMaritalDR'=0) s PAPERMaritalDesc=$p(^CT("MAR",PAPERMaritalDR),"^",2)   //CT_Marital
    e  s PAPERMaritalDesc=""
    s mradm=$p(^PAADM(admId),"^",61)
    s PreDiag=..Diag(mradm,"M")
    
    //add by yjn 20171127 床头卡的诊断取临时修改诊断
  	;s tmpDiag=##class(web.DHCNurCom).GetBedCardTempDiag(admId)
  	;s tmpDiag=$tr(tmpDiag," ","")
  	;s pDiag=$tr(PreDiag," ","")
  	;if (tmpDiag'=pDiag){
	  	;s PreDiag=tmpDiag
	;}
    
    s diag=..Diag(mradm,"")
    s ctlocId=$p(^PAADM(admId),"^",4)
    s CTLOCHospitalDR=$P(^CTLOC(+ctlocId),"^",22)
	s ctlocDesc=$p(^CTLOC(+ctlocId),"^",2)	
	i ctlocDesc["-"  s ctlocDesc=$P(ctlocDesc,"-",2)
	s doc=$p(^PAADM(admId),"^",9)
	if doc'="" s DocDes=$P($G(^CTPCP(doc,1)),"^",2)
    s roomId=$p(^PAADM(admId),"^",69)
    i (roomId'="") s room=$p(^PAROOM(roomId),"^",2)
    s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
    s MedCareNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)
    ;s MedCareNo=##Class(web.DHCWMRService).IGetMrNoByEpisodeID(curId) //取新病案号
    s MedCareNo=##class(Nur.CommonInterface.Patient).getMedicareNo(admId)   //##class(web.DHCWMRService).IGetMrNoByEpisodeID(admId) //调用病案接口取病案号
    i MedCareNo="-2" q "病案卷不存在"
    i MedCareNo="-1" q "获取病案号失败"
    s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
    i $d(^PAPER(papmiId,"PAT",3)) s safetyNetCardNo=$p(^PAPER(papmiId,"PAT",3),"^",4) ;病案号
    e  s safetyNetCardNo=""
    s sex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
    
    //取最后一次分娩日期时间-tangshuang20.4.22 
    i sex="女" d
    .s pregnancyID=$o(^PAPRGi("PREG_Person",papmiId,""))
    .q:pregnancyID=""
    .s deliveryID=$o(^PAPRGi("DEL_Adm_DR",admId,pregnancyID,"DEL",""),-1)
    .q:deliveryID=""
    .s babyOrderNumber="" f  s babyOrderNumber=$o(^PAPRGi("BABY_BirthOrderNumber",babyOrderNumber),-1) q:(babyOrderNumber="")!($g(deliveryDate)'="")  d
    ..s deliveryBabyID="" f  s deliveryBabyID=$o(^PAPRGi("BABY_BirthOrderNumber",babyOrderNumber,pregnancyID,"DEL",deliveryID,"BABY",deliveryBabyID)) q:deliveryBabyID=""  d
    ...s deliveryBabyData=^PAPRG(pregnancyID,"DEL",deliveryID,"BABY",deliveryBabyID)
    ...s deliveryDate=##class(websys.Conversions).DateLogicalToHtml($p(deliveryBabyData,"^",13))
    ...s deliveryTime=$zt($p(deliveryBabyData,"^",49),2)
    
    s hospDr=$p(^CTLOC(+ctlocId),"^",22)
	s hospDesc=$p(^CT("HOSP",hospDr),"^",2)	//医院名称
	s patInDays=##Class(Nur.CommonInterface.Patient).patInDays(curId)	//住院天数
	
    s BirthCityDr=$p($g(^PAPER(papmiId,"ALL")),"^",18) //籍贯
    i BirthCityDr'="" s BirthCityDesc=$p(^CT("CIT",BirthCityDr),"^",2)
    i $g(BirthCityDesc)["-" s BirthCityDesc=$p(BirthCityDesc,"-",2)
    S homeAddres=$g(^PAPER(papmiId,"PER","ADD")) // 住址
    s homeTel=$p($g(^PAPER(papmiId,"PER",1)),"^",11)  //家庭电话
    s workTel=$p($g(^PAPER(papmiId,"PER",1)),"^",9)   //工作电话
    s handtel=$p($g(^PAPER(papmiId,"PER",4)),"^",21)  //手机
    s bedSub=$p($p($g(^PAADM(admId)),"^",73),"||",2)
    s curWardId=$p($g(^PAADM(admId)),"^",70)  
    i curWardId'="" s wardDesc=$p(^PAWARD(curWardId),"^",2)
    i $g(wardDesc)["-" s wardDesc=$p(wardDesc,"-",2)
    i $g(wardDesc)["(" s wardDesc=$p(wardDesc,"(",1)
    i bedSub'="" s bedCode=$p($g(^PAWARD(curWardId,"BED",bedSub)),"^",1)
    e  s bedCode=""
    s birth=$p($g(^PAPER(papmiId,"ALL")),"^",6)
    s age=##class(web.DHCBillInterface).GetPapmiAge(papmiId,admId)
    s motherAdm=$p($g(^PAADM(admId)),"^",75)
	s pavisit=$p($g(^PAADM(admId)),"^",20)
	//出院小孩取出院时年龄
	i ctlocId=349&&(pavisit'="A")  d  
	.s dischDate=$p(^PAADM(admId),"^",17) 
	.s dischTime=$p(^PAADM(admId),"^",18)
	.q:dischDate=""
	.i $d(^PAPER("DHC",papmiId,1)) d
	..s babybirstr=^PAPER("DHC",papmiId,1)
	..s birthDate=$p(babybirstr,"^",1)
	..s birthTime=$p(babybirstr,"^",2)
	.e  d
	..s babybirstr=$g(^PAPER(papmiId,"ALL"))
	..s birthDate=$p($g(^PAPER(papmiId,"ALL")),"^",6)
	..s birthTime=0
	.s age=##class(web.UDHCJFCOMMON).DispPatAge(birthDate,dischDate,birthTime,dischTime,CTLOCHospitalDR,"Y")
	.s age=$p(age,"||",1)
	//end

    s DiagnosDr=$O(^Nur.DHCNurCopyDiagnosI("EpisodeId"," "_admId,""),-1)
	i DiagnosDr'="" s diag=$List(^Nur.DHCNurCopyDiagnosD(DiagnosDr),2)
	//e  s diag=""
	s diag=$tr(diag,";",",")
	s diag=$tr(diag," ","")
	s diag=$zcvt(diag,"O","JS")
	//s diag="999999"
	// i admId=195885 s ^pjf(1)=diag
	s AdmDate=$ZD($p($g(^PAADM(admId)),"^",6),3)
    s AdmTime=$ZT($p($g(^PAADM(admId)),"^",7),2)
    s pacInBedDateTime=##class(web.DHCADMQTREC).PACInPatDateBed(admId)
    i pacInBedDateTime'="" d
    .s AdmDate=$ZD($p(pacInBedDateTime,"^",1),3)
    .s AdmTime=$ZT($p(pacInBedDateTime,"^",2),2)
    
     s DischgDate=$p($g(^PAADM(admId)),"^",59)
    i DischgDate'=""  s DischgDate=$zd(DischgDate,3)
    s DischgTime=$p($g(^PAADM(admId)),"^",60)
    i DischgTime'="" s DischgTime=$zt(DischgTime,2)
    //ctlocDesc未取后半部分 ypz 060522
    Set PatEncryptLevel=##class(web.DHCCLCom).GetPatEncryptLevel("",admId)
    Set EncryptLevel=$p(PatEncryptLevel,"^",1)
    Set PatLevel=$p(PatEncryptLevel,"^",2)
    ;s SecretCode=##class(web.DHCLCNUREXCUTE).GetItemCatOrd(admId,"饮食嘱托")  //add by yjn 20171207
    ;s SecretCode=$p(SecretCode,",",1)
    s SecretCode=""
    s CareLevel=##class(Nur.CommonInterface.Patient).getCareLevel(admId)
    s CTPCPDr=$p(^PAADM(admId),"^",9)
    i CTPCPDr'="" s MainDoc=$p($g(^CTPCP(CTPCPDr,1)),"^",2)
    
    // 人员待遇类型
    s personTypeDr=$p($g(^PAPER(papmiId,"INSU")),"^",4)
    s personType=##class(web.DHCINSUPort).RtnDicDescByDicCode("GYPersonType",personTypeDr)
	
	s admType=$p(^PAADM(admId),"^",2)
	
	;s patAlg=##class(web.DHCCLCom).GetPAAllergyStr(admId,";")
	s patAlg=""
	; 急诊抢救单1 取 过敏史、诊断、抢救医生、抢救护士
	i emrCode="DHCNURBG_JZQJD1" s moudDataInfo=##class(Nur.DHCMoudData).getValueByCodeItemEpisode(admId,emrCode,"Item43#Item58#Item54#Item55")
	i $g(moudDataInfo)'="" d
	.s patAlg=$p($p(moudDataInfo,"#",1),"|",2)
	.s diag=$p($p(moudDataInfo,"#",2),"|",2)
	.s qjDoctor=$p($p(moudDataInfo,"#",3),"|",2)
	.s qjNurse=$p($p(moudDataInfo,"#",4),"|",2)
	
	s admType=$p(^PAADM(admId),"^",2)
	if (admType="I"){
		s diag=##class(Nur.CommonInterface.Patient).getDiagnosis(admId) //诊断同床位图一致 add by yjn 20180109
	}
	
	;s palldesc=##class(web.DHCLCNUREXCUTE).GetLastAdmPaal(admId)
	s palldesc=""
    s retStr="REGNO@"_regNo_"^LOC@"_ctlocDesc_"^ROOM@"_$g(room)_"^SEX@"_$g(sex)_"^PATNAME@"_$g(patName)_"^BEDCODE@"_$g(bedCode)_"^AGE@"_$g(age)_"^WARD@"_$g(wardDesc)_"^DIAG@"_diag_"^MedCareNo@"_MedCareNo_"^Telephone@"_homeTel_"^PatAddress@"_homeAddres_"^BirthDate@"_$ZD(birth,3)_"^BirthDate@"_$ZD(birth,3)_"^AdmDate@"_AdmDate_"^AdmTime@"_AdmTime_"^DischgDate@"_DischgDate_"^DischgTime@"_DischgTime_"^Nation@"_Nation_"^admreason@"_admreason_"^paersonLX@"_paersonLX_"^PAPEROccupationdesc@"_PAPEROccupationdesc_"^PAPERCTRLTDesc@"_PAPERCTRLTDesc_"^PAPERMaritalDesc@"_PAPERMaritalDesc
    s retStr=retStr_"^EncryptLevel@"_EncryptLevel_"^PatLevel@"_PatLevel_"^MainDoc@"_$g(MainDoc)_"^PreDiag@"_$g(PreDiag)_"^InPatNo@"_InPatNo_"^BirthCityDesc@"_$g(BirthCityDesc)_"^personType@"_$g(personType)_"^admType@"_$g(admType)_"^patAlg@"_$g(patAlg)_"^qjDoctor@"_$g(qjDoctor)_"^qjNurse@"_$g(qjNurse)_"^SecretCode@"_$g(SecretCode)_"^CareLevel@"_$g(CareLevel)_"^palldesc@"_$g(palldesc)
    s retStr=retStr_"^HospDesc@"_hospDesc_"^PatInDays@"_patInDays_"^DeliveryDate@"_$g(deliveryDate)_"^DeliveryTime@"_$g(deliveryTime)
    q retStr
}

ClassMethod GetHead(adm) As %String
{
 	//    s retStr="REGNO@"_regNo_"
    //^LOC@"_ctlocDesc_
    // "^ROOM@"_$g(room)
    //  _"^SEX@"_$g(sex)_
    //  "^PATNAME@"_$g(patName)_
    //  "^BEDCODE@"_$g(bedCode)
    //  _"^AGE@"_$g(age)_"岁
    //  ^WARD@"_$g(wardDesc)_
    //  "^DIAG@"_diag_
    //  "^MedCareNo@"_MedCareNo
    //s diag=..GetPatDiag(adm,"S116")
    s diag=""
    s DiagnosDr=$O(^Nur.DHCNurCopyDiagnosI("EpisodeId"," "_adm,""),-1)
	i DiagnosDr'="" s diag=$List(^Nur.DHCNurCopyDiagnosD(DiagnosDr),2)
	s diag=$tr(diag,";",",")
	s diag=$tr(diag," ","")
	s diag=$zcvt(diag,"O","JS")
	s diag="hhh"
    s patinfo=##class(web.DHCMGNurComm).PatInfo(adm)
    s loc=$P(patinfo,"^",2),ward=$P(patinfo,"^",8),pname=$P(patinfo,"^",5),bed=$P(patinfo,"^",6),diag=$p($P(patinfo,"^",9),"@",2),regno=$P(patinfo,"^",1)
    s sex=$P(patinfo,"^",4),age=$P(patinfo,"^",7)  
    s EncryptLevel=$P(patinfo,"^",25),PatLevel=$P(patinfo,"^",26)
	s papmiId=+^PAADM(adm)
    //s MedCareNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)
    s MedCareNo=##class(web.DHCWMRService).IGetMrNoByEpisodeID(adm) //调用病案接口取病案号
    i MedCareNo="-2" q "病案卷不存在"
    i MedCareNo="-1" q "获取病案号失败"
    //取护士录入的最新一条诊断
	//s DiagnosDr=$O(^Nur.DHCNurCopyDiagnosI("EpisodeId"," "_adm,""),-1)
	//i DiagnosDr'="" s diag=$List(^Nur.DHCNurCopyDiagnosD(DiagnosDr),2)
	//e  s diag=""
	//如果床位为空取转科记录最后一条
	s BedCode=$P(bed,"@",2)
    if BedCode="" 
    {
		s chl="" f  s chl=$O(^PAADM(adm,"TRANS",chl),-1) q:(chl="")!(BedCode'="")  d
		.s bedDr=$P(^PAADM(adm,"TRANS",chl),"^",8)
		.q:bedDr=""
		.s BedCode=$p($g(^PAWARD($P(bedDr,"||",1),"BED",$P(bedDr,"||",2))),"^",1)
	}
    s ret="PatInfo@"_"床号:"_BedCode_"   姓名:"_$P(pname,"@",2)_"   性别:"_$P(sex,"@",2)_"   年龄:"_$P(age,"@",2)_"   诊断:"_diag_"  ID号:"_$P(regno,"@",2)_"  住院号:"_MedCareNo_" 病人密级:"_$p(EncryptLevel,"@",2)_" 病人级别:"_$p(PatLevel,"@",2)_"^科室:"_$P(ward,"@",2)
    ;s ret="床号:"_BedCode_"&nbsp;&nbsp;&nbsp;姓名:"_$P(pname,"@",2)_"&nbsp;&nbsp;&nbsp;性别:"_$P(sex,"@",2)_"&nbsp;&nbsp;&nbsp;年龄:"_$P(age,"@",2)_"&nbsp;&nbsp;&nbsp;诊断:"_diag_"&nbsp;&nbsp;&nbsp;ID号:"_$P(regno,"@",2)_"&nbsp;&nbsp;&nbsp;住院号:"_MedCareNo_"&nbsp;&nbsp;&nbsp;^科室:"_$P(ward,"@",2)
    q ret
}

// 根据科室取医院名称

ClassMethod getPatAdmInfo(adm)
{
	s zycs=1
	s zcks=""
	s PAADMPAPMIDR=$P(^PAADM(adm),"^",1)
	s PAADMRowID=adm
	f  s PAADMRowID=$o(^PAPERdr(PAADMPAPMIDR,"ADM","I",PAADMRowID),-1) q:PAADMRowID=""  d
	.s PAADMVisitStatus=$p(^PAADM(PAADMRowID),"^",20)
	.q:PAADMVisitStatus="C"
	.s zycs=zycs+1
	
	s zcksdr=""
	s zhksdr=""
	s TRANSChildsub=""
	f  s TRANSChildsub=$o(^PAADM(adm,"TRANS",TRANSChildsub),-1) q:TRANSChildsub=""  d
	.s TRANSCTLOCDR=$p(^PAADM(adm,"TRANS",TRANSChildsub),"^",6)
	.i TRANSCTLOCDR'=""  d
	..i zhksdr=""  d
	...s zhksdr=TRANSCTLOCDR
	..e  d
	...i zhksdr'=TRANSCTLOCDR  d
	....s zcksdr=TRANSCTLOCDR
	i zcksdr'=""  d
	.s zcks=$p(^CTLOC(zcksdr),"^",2)
	
	q zycs_"^"_zcks
}

ClassMethod gethospital(id)
{
	q:id="" ""
	s hospitaldr=$p(^CTLOC(id),"^",22)
	q:hospitaldr="" ""
	s desc=$p(^CT("HOSP",hospitaldr),"^",2)
	q desc
}

ClassMethod PatInfoold(curId) As %String
{
	//病人基本信息;入参:登记号或OEORI_ROWID,根据最后一个ADM取信息
   	// n (curId)
    q:curId="" ""
    s admId=curId
    //s Res=##class(web.DHCMGNurComm).PatInfo("16")  //WKZ 071119
  
    s admreasondr=$p($g(^PAADM(curId,1)),"^",7) //病人类别
    if admreasondr'="" s admreason=$P($G(^PAC("ADMREA",admreasondr)),"^",2)
    s papmiId=+^PAADM(admId)
    s NationDr=$p($g(^PAPER(papmiId,"PER",2)),"^",1)
    i NationDr'="" d
    .s Nation=$P(^CT("NAT",NationDr),"^",2)
    e  d
    .s Nation=""        
    s RegisterPlace=""
    s DHCPersonID=$O(^DHCPERSON(0,"PAPERSON",papmiId,0))
	i DHCPersonID'="" d
	.s RegisterPlace=$P(^DHCPERSON(DHCPersonID),"^",20) //地址
	s countrydesc=""
    s countrydr =$p($g(^PAPER(papmiId,"PER",1)),"^",8) //国籍
    i countrydr'=""  d
    .s countrydesc=$p(^CT("COU",countrydr),"^",2)                               //民族
    set TPAPERForeignAddress = $G(^PAPER(papmiId,"PER","ADD",1))
    s gzdw =$p($g(^PAPER(papmiId,"PER",4)),"^",18) //工作单位 
    s lxphone =$p($g(^PAPER(papmiId,"ALL")),"^",4) //联系人联系电话                      
    s paersonLX=$p($g(^PAPER(papmiId,"PER",2)),"^",13) //联系人
    s PAPEROccupationdr=$p($g(^PAPER(papmiId,"PER",2)),"^",6) //职业
    i PAPEROccupationdr'="" s PAPEROccupationdesc=$p(^CT("OCC",PAPEROccupationdr),"^",2)
    e  s PAPEROccupationdesc=""
    s PAPERCTRLTDR=$p($g(^PAPER(papmiId,"EMP")),"^",4) //与患者关系
    i PAPERCTRLTDR'="" s PAPERCTRLTDesc=$p(^CT("RLT",PAPERCTRLTDR),"^",2)
    e  s PAPERCTRLTDesc=""
    s PAPERMaritalDR=$p($g(^PAPER(papmiId,"PER",2)),"^",3) //婚姻状况
    i PAPERMaritalDR'="" s PAPERMaritalDesc=$p(^CT("MAR",PAPERMaritalDR),"^",2)   //CT_Marital
    e  s PAPERMaritalDesc=""
    s mradm=$p(^PAADM(admId),"^",61)
    ;s diag=..Diag(mradm,"PRE")
    s diag=..Diag(mradm,"C008") //取入院诊断
    i diag="" d
    .s diag=..Diag(mradm,"M") //入院诊断为空取主诊断
    i diag=""  d
    .s diag=..Diag(mradm,"PRE") //入院诊断，主诊断为空取初步诊断
    s ctlocId=$p(^PAADM(admId),"^",4)
    s hospital=""
    i ctlocId'=""  d
    .s hospital=..gethospital(ctlocId)
	s ctlocDesc=$p(^CTLOC(+ctlocId),"^",2)	
	i ctlocDesc["-"  s ctlocDesc=$P(ctlocDesc,"-",2)
	s doc=$p(^PAADM(admId),"^",9)
	if doc'="" s DocDes=$P($G(^CTPCP(doc,1)),"^",2)
    s roomId=$p(^PAADM(admId),"^",69)
    i (roomId'="") s room=$p(^PAROOM(roomId),"^",2)
    s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
    //s MedCareNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)
    ;s MedCareNo=##Class(web.DHCWMRService).IGetMrNoByEpisodeID(curId) //取新病案号
    s MedCareNo=##class(Nur.CommonInterface.Patient).getMedicareNo(curId) //调用病案接口取病案号
    
    s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
    i $d(^PAPER(papmiId,"PAT",3)) s safetyNetCardNo=$p(^PAPER(papmiId,"PAT",3),"^",4) ;病案号
    e  s safetyNetCardNo=""
    s sex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
   
    S homeAddres=$g(^PAPER(papmiId,"PER","ADD")) // 住址
    s homeTel=$p($g(^PAPER(papmiId,"PER",1)),"^",11)  //家庭电话
    s workTel=$p($g(^PAPER(papmiId,"PER",1)),"^",9)   //工作电话
    s handtel=$p($g(^PAPER(papmiId,"PER",4)),"^",21)  //手机
    s bedSub=$p($p($g(^PAADM(admId)),"^",73),"||",2)
    s curWardId=$p($g(^PAADM(admId)),"^",70)  
    i curWardId'="" s wardDesc=$p(^PAWARD(curWardId),"^",2)
    i $g(wardDesc)["-" s wardDesc=$p(wardDesc,"-",2)
    i $g(wardDesc)["(" s wardDesc=$p(wardDesc,"(",1)
    i bedSub'="" s bedCode=$p($g(^PAWARD(curWardId,"BED",bedSub)),"^",1)
    e  s bedCode=""
    s bedCode=##class(Nur.Interface.OutSide.Patient).getPatientLastBedCode(admId)
    s birth=$p($g(^PAPER(papmiId,"ALL")),"^",6)
    //s ageret=..CalAge(birth,+$h)
   	// s age=$p(ageret,"Y",1)
    //s month=$p(ageret,"Y",2)
    //i age=0  d
    //.s mm=$p(month,"M",1)
    //.s age=mm_"月"
    //e  d
    //.s age=age_"岁"
    s age=##class(web.DHCBillInterface).GetPapmiAge(papmiId,curId)
    //s DiagnosDr=$O(^Nur.DHCNurCopyDiagnosI("EpisodeId"," "_admId,""),-1)
	//i DiagnosDr'="" s diag=$List(^Nur.DHCNurCopyDiagnosD(DiagnosDr),2)
	//e  s diag=""
	s diag=$tr(diag,";",",")
	s diag=$tr(diag," ","")
	s diag=$zcvt(diag,"O","JS")
	//s diag="999999"
	// i admId=195885 s ^pjf(1)=diag
	
	s AdmDateDT=##class(web.DHCDischargeHistory).GetAdminDateTime(curId)
	s AdmDate=$p(AdmDateDT,"^",1)
	s AdmTime=$p(AdmDateDT,"^",2)
	i AdmDate'="" s AdmDate=$ZD(AdmDate,3)
	i AdmTime'="" s AdmTime=$ZT(AdmTime,2)
	i AdmDate="" s AdmDate=$ZD($p($g(^PAADM(admId)),"^",6),3)
    i AdmTime="" s AdmTime=$ZT($p($g(^PAADM(admId)),"^",7),2)
     s DischgDate=$p($g(^PAADM(admId)),"^",59)
    i DischgDate'=""  s DischgDate=$zd(DischgDate,3)
    s DischgTime=$p($g(^PAADM(admId)),"^",60)
    i DischgTime'="" s DischgTime=$zt(DischgTime,2)
    //ctlocDesc未取后半部分 ypz 060522
    Set PatEncryptLevel=##class(web.DHCCLCom).GetPatEncryptLevel("",admId)
    Set EncryptLevel=$p(PatEncryptLevel,"^",1)
    Set PatLevel=$p(PatEncryptLevel,"^",2)
    s opration=..getANOperation(admId)
    i opration=-1 d
    .s opname=""
    .s opdate=""
    e  d
    .s opname=$p(opration,"^",2)
    .s opdate=$p(opration,"^",3)
    .i opdate'="" s opdate=$zd(opdate,3)
    s diagdis=..Diag(mradm,"DIS") //出院诊断
    s diag=##class(web.DHCCLCom).GetDiag(curId) 
    s retStr="REGNO@"_regNo_"^LOC@"_ctlocDesc_"^ROOM@"_$g(room)_"^SEX@"_$g(sex)_"^PATNAME@"_$g(patName)_"^BEDCODE@"_$g(bedCode)_"^AGE@"_$g(age)_"^WARD@"_$g(wardDesc)_"^DIAG@"_diag_"^MedCareNo@"_MedCareNo_"^Telephone@"_homeTel_"^PatAddress@"_TPAPERForeignAddress_"^BirthDate@"_$ZD(birth,3)_"^BirthDate@"_$ZD(birth,3)_"^AdmDate@"_AdmDate_"^AdmTime@"_AdmTime_"^DischgDate@"_DischgDate_"^DischgTime@"_DischgTime_"^Nation@"_Nation_"^admreason@"_admreason_"^paersonLX@"_paersonLX_"^PAPEROccupationdesc@"_PAPEROccupationdesc_"^PAPERCTRLTDesc@"_PAPERCTRLTDesc_"^PAPERMaritalDesc@"_PAPERMaritalDesc
    s retStr=retStr_"^EncryptLevel@"_EncryptLevel_"^PatLevel@"_PatLevel_"^Place@"_RegisterPlace_"^Country@"_countrydesc_"^Company@"_gzdw_"^LXPhone@"_lxphone_"^opname@"_opname_"^opdate@"_opdate
    s retStr=retStr_"^diagdis@"_diagdis_"^DIAG2@"_diag_"^Title@"_hospital
    q retStr
}

/// 护理病历用，根据就诊ID返回麻醉方法和手术名称
ClassMethod getANOperation(EpisodeID As %String) As %String
{
	q:EpisodeID="" ""
	s ret=""
	s opaId=""
	s opaId=$O(^DHCANOPArrange(0,"Adm",EpisodeID,opaId),-1)
	q:(opaId="") -1
	s anaId=$P(^DHCANOPArrange(opaId),"^",2) ;手术麻醉Id
    s opStartDate=$P(^DHCANOPArrange(opaId),"^",14)
    s opsttime=$P(^DHCANOPArrange(opaId),"^",15) ;手术开始日期
    s anaSub=$P(anaId,"||",2)
    s anmthdr=$P(^OR(EpisodeID,"ANA",anaSub),"^",5) ;/麻醉方法相关
	s anaMethod=""        
	i anmthdr'=""
	{
		s anmetNum=$l(anmthdr,"|")
		f i=1:1:anmetNum d
		.s anmetId=$p(anmthdr,"|",i)
		.q:anmetId=""
		.s anmetDesc=$p($g(^ORC("ANMET",anmetId)),"^",2) ;麻醉方法描述
		.i $P(anmetDesc,"-",2)'="" s anmetDesc=$P(anmetDesc,"-",2)
		.i anaMethod="" s anaMethod=anmetDesc
		.e  s anaMethod=anaMethod_"^"_anmetDesc
	}
	
	s opName="",anaOPSurgeonDR="",operId=""
	s anaopSub=0 f  s anaopSub=$O(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub)) q:(anaopSub="")  d
	.s curOperId=$P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",6)       ;ANAOP_Type_DR；手术名称
	.q:curOperId=""
	.if $D(^ORC("OPER",curOperId)) d
	..i opName="" s opName=$P(^ORC("OPER",curOperId),"^",2)
	..e  s opName=$G(opName)_","_$P(^ORC("OPER",curOperId),"^",2)
	s ret=anaMethod_"^"_opName_"^"_opStartDate
	;b
	q ret
}

ClassMethod GetPatInfo(EpisodeId, emrCode As %String = "") As %String
{
  	s ret=..PatInfo(EpisodeId,emrCode)
  	s ret=$TR(ret,"@","|")
  	q ret
}

/// 根据出生日计算年龄
ClassMethod CalAge(IBirth As %String, IToday As %String)
{
    s IBirth=$g(IBirth),IToday=$g(IToday)
    i IBirth>2980000 s IBirth=""
    i IBirth<0 s IBirth=""
    q:'$g(IBirth) ""
    s XBirth=$zd(IBirth)
    s XToday=$zd(IToday)
    s AgeMth=XToday-XBirth
    s AgeDay=$p(XToday,"/",2)-$p(XBirth,"/",2)
    s CurrYear=$p(XToday,"/",3) s:CurrYear<100 CurrYear=CurrYear+1900
    s BirthYear=$p(XBirth,"/",3) s:BirthYear<100 BirthYear=BirthYear+1900
    s AgeYear=CurrYear-BirthYear
    i AgeDay<0 d
        . s AgeMth=AgeMth-1
	    . s AgeDay=AgeDay+$p("31,31,28,31,30,31,30,31,31,30,31,30,31",",",+XToday)
	    . q:XToday'=2
	    . s:((CurrYear#4)=0)&(((CurrYear#100)'=0)!((CurrYear#400)=0)) AgeDay=AgeDay+1
	i AgeMth<0 s AgeMth=AgeMth+12,AgeYear=AgeYear-1
	s $p(AgeYr,"|",12)=AgeYear
	s reage=$p(AgeYr,"|",12)_"Y "_AgeMth_"M "_AgeDay_"D"
	q reage
}

ClassMethod GetUserWardId(userId)
{
 	///获得用户病区
  	//	n (userId)
  	s loc=$p(^SSU("SSUSR",userId),"^",4)
  	s warddes=$p(^CTLOC(loc),"^",2)
  	s wardid=$O(^PAWARD(0,"WARD_LocationDR",loc,""),-1)
  	s ctcpt=$p(^SSU("SSUSR",userId),"^",14)
  	i $g(ctcpt)'="" s typid=$p(^CTPCP(ctcpt,1),"^",4)
  	i $g(typid)'="" s typdes=$p($g(^CT("CPT",typid)),"^",4)
  	i ($g(typdes)="NURSE") q warddes_"^"_wardid
  	q ""
}

ClassMethod GetDate() As %String
{
  	//取系统时间
	q $zd($h,4)_"^"_$zd(($h),4)
}

ClassMethod GetToday() As %String
{
	q $zd($h,4)
}

ClassMethod GetArcim(ids As %String) As %String
{
 	//s a=##class(web.DHCMGNurComm).GetArcim()
    q:"" ""
    s ids=$ZConvert(ids,"U")

	s id=ids_" "
	s ln=$L(ids)
	s im=ids
	s flag=0
	s ret="" 
	s n=0
	s des="" f  s des=$O(^ARC("ALIAS",0,"Desc",id,des)) q:des=""  d
	.s rw=""  f  s rw=$O(^ARC("ALIAS",0,"Desc",id,des,rw)) q:rw=""  d
	..s typ=$P(^ARC("ALIAS",0,"Desc",id,des,rw,1),"^",2)
	..q:typ'="ARCIM"
	..s arcimrow=$P(^ARC("ALIAS",0,"Desc",id,des,rw,1),"^",1)
	..d sa 
	f  s id=$O(^ARC("ALIAS",0,"Desc",id)) q:(id="")!(flag=1)  d
	.if $E($TR(id," ",""),0,ln)'=im s flag=1
	.w !,id
	.b
	.s des="" f  s des=$O(^ARC("ALIAS",0,"Desc",id,des)) q:(des="")!(flag=1)  d
	..s rw=""  f  s rw=$O(^ARC("ALIAS",0,"Desc",id,des,rw)) q:(rw="")!(flag=1)  d
	...s typ=$P(^ARC("ALIAS",0,"Desc",id,des,rw,1),"^",2)
	...q:typ'="ARCIM"
	...s arcimrow=$P(^ARC("ALIAS",0,"Desc",id,des,rw,1),"^",1)
	...d sa
    ...
   	q ret
sa
	s ARCIMRowid=$P(arcimrow,"||",1)
	s ARCIMSub=$P(arcimrow,"||",2) 
	s ItmName=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",2)  ;ord name   
    s aa=ARCIMRowid_"!"_ARCIMSub
    s n=n+1
    q:n=500
    s ret=ret_aa_"|"_id_"-"_ItmName_"^"
    q
}

ClassMethod GetSSPerson(ids As %String) As %String
{
 	//s a=##class(web.DHCMGNurComm).GetSSPerson()
    q:"" ""
    s ids=$ZConvert(ids,"U")
	s id=ids
	s ln=$L(ids)
	s im=ids
	s flag=0
	s ret=""
	s rw="" s rw=$O(^SSU("SSUSR",0,"SSUSR_Initials",id,rw))
	if rw'=""  d sa
	f  s id=$O(^SSU("SSUSR",0,"SSUSR_Initials",id)) q:(id="")!(flag=1)  d
	.if $E(id,0,ln)'=im s flag=1
	.s rw=""  f  s rw=$O(^SSU("SSUSR",0,"SSUSR_Initials",id,rw)) q:rw=""!(flag=1)  d
    ..d sa
    ..
  	q ret
sa
 	s parr=^SSU("SSUSR",rw)
    s name=$P(parr,"^",2)
    s ret=ret_rw_"|"_name_"^"
    q
}

ClassMethod GetPersonOld(ids As %String) As %String
{
 	//s a=##class(web.DHCMGNurComm).GetPerson()
    q:"" ""
    s ids=$ZConvert(ids,"U")

	s id=" "_ids
	s ln=$L(" "_ids)
	s im=" "_ids
	s flag=0
	s ret=""
	s rw="" s rw=$O(^User.DHCMGPersonsI("SSID",id,rw))
	if rw'=""  d sa
	f  s id=$O(^User.DHCMGPersonsI("SSID",id)) q:(id="")!(flag=1)  d
	.if $E(id,0,ln)'=im s flag=1
	.s rw=""  f  s rw=$O(^User.DHCMGPersonsI("SSID",id,rw)) q:rw=""!(flag=1)  d
    ..d sa
    ..
   	q ret
sa
 	s parr=^User.DHCMGPersonsD(rw)
    s name=$list(parr,21)
    s ret=ret_rw_"|"_name_"^"
    q
}

ClassMethod GetPerson(ids As %String) As %String
{
 	//s a=##class(web.DHCMGNurComm).GetPerson()
    q:"" ""
    s ids=$ZConvert(ids,"U")

	s ret=""
	s rw="" s rw=$O(^SSU("SSUSR",0,"SSUSR_Initials",ids,rw) )
	if rw'=""  d sa
	q ret
sa
    s name=$p(^SSU("SSUSR",rw),"^",2)
    s ret=ret_rw_"|"_name_"^"
    q
}

ClassMethod GetLoc(ids As %String) As %String
{
   	//s a=##class(web.DHCMGNurComm).GetLoc()
    s ids=$ZConvert(ids,"U")

	s ln=$L(ids)
	s im=ids
	s flag=0
	s ret=""
	s rw="" s rw=$O(^CTLOC(0,"Desc",ids,rw))
	if rw'=""  d sa
	f  s ids=$O(^CTLOC(0,"Desc",ids)) q:(ids="")!(flag=1)  d
	.if $E(ids,0,ln)'=im s flag=1
	.s rw=""  f  s rw=$O(^CTLOC(0,"Desc",ids,rw)) q:rw=""!(flag=1)  d
    ..d sa
    ..
   	q ret
sa
 	s parr=^CTLOC(rw)
    s name=$P(parr,"^",1)
    s ret=ret_rw_"|"_name_"^"
    q
}

ClassMethod GetMessageExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//补贴调节记录
    //s parr="2009-10-4^2009-12-25"
 	s stdate=$P(parr,"^",1)
 	s edate=$P(parr,"^",2)
 	s stdate=$ZDH(stdate,3),edate=$ZDH(edate,3)
 	//Set qHandle=$lb(0,repid,0) Quit $$$OK
    f date=stdate:1:edate
    {
		s rw=""  f  s rw=$O(^User.DHCMGNurMessageI("Date",date,rw)) q:rw=""  d
        .s a=^User.DHCMGNurMessageD(rw)
        .s usdr=$List(a,6)
        .q:usdr=""
        .s title=$List(a,5)
        .s content=$List(a,2)  //s date=$List(a,7)
        .s time=$list(a,4)
        .q:'$D(^User.DHCMGPersonsD(usdr))
     	.s parr=^User.DHCMGPersonsD(usdr)
        .s name=$list(parr,21)
        .s sdate=$ZD(date,3)
        .s stime=$ZT(time)
        .d OutRowtyp

    }
	//s head="科  室|总分|"_head  
  	//	s colwidth="100|70|"_colwidth
	//s quret=head_$C(2)_colwidth_$C(2)_quret
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(sdate,stime,name,title,content,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetMessageFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMessageExecute ]
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

ClassMethod GetMessageClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMessageExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

Query GetMessage(parr As %String) As %Query(ROWSPEC = "mdate,mtime,muser,mtitle,content,rw")
{
}

ClassMethod GetCurrAdm(RegNo) As %String
{
 	//s a=##classmethod(web.DHCMGNurComm).GetCurrAdm(RegNo)
  	q:RegNo="" ""
  	s nvar=""
	s ln=$L(RegNo)
	s le=8-ln
	s $P(nvar,"0",le+1)=RegNo

	s papmi=""
	s CurrAdm=0

	f  s papmi=$o(^PAPERi("PAPMI_PatNo",nvar,papmi)) q:papmi=""  d
	.s name=$p(^PAPER(papmi,"ALL"),"^",1)
	.s Adm=""
	.f  s Adm=$o(^PAPERdr(papmi,"ADM","I",Adm)) q:Adm=""  d  	
	..;s visitstatus=$p(^PAADM(Adm),"^",20)
	..;q:visitstatus'="A"
	..s Typ=$p(^PAADM(Adm),"^",2)
	..q:Typ'="I"
	..if Adm>CurrAdm  s CurrAdm=Adm
	if CurrAdm=0 s CurrAdm=""
	q CurrAdm
}

/// 学校
ClassMethod GetSchoolCode(ids As %String) As %String
{
   	q ..GetCode(ids,2)
}

/// 学历
ClassMethod GetDegreeCode(ids As %String) As %String
{
   	q ..GetCode(ids,5)
}

/// 公用
ClassMethod GetCode(ids As %String, CodeRowId As %String = "") As %String
{
    q:CodeRowId="" ""
    s ids=$ZConvert(ids,"U")
	s ln=$L(ids)
	s im=ids
	s flag=0
	s ret=""
	s rw="" f  s rw=$O(^User.DHCMGCCodeI("Typ",CodeRowId,rw)) q:rw=""  d
	.s parr=^User.DHCMGCCodeD(rw)
    .s name=$List(parr,3)
    .q:$E(name,0,ln)'=im
    .s ret=ret_rw_"|"_name_"^"
   	q ret
}

// 返回：eqUomId等效剂量单位_"^"_eqDefaultDose医嘱缺省量_"^"_baseUomId基本单位_"^"_eqQty转换系数：基本单位数量*eqQty=等效剂量单位数量_"^"_volume单位代码为"ML"的转换系数,无则为""

ClassMethod PhGener(ARCIMRowid, ARCIMSub) As %String
{
 	//通用名+规格  --->缩写
	//n (ARCIMRowid,ARCIMSub)
	//s PHCGERDR=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,8)),"^",20)
	s PHCFDr=+$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",12)
	s PHCGERDR=$P($G(^PHCD(PHCFDr,4)),"^",1)
	//s GerName=PHCGERDR
	if PHCGERDR'="" s GerName=$P(^PHCGE("GE",PHCGERDR),"^",2)
	e  s GerName=""
	if $P(GerName,"-",2)'="" s GerName=$P(GerName,"-",2)
	i GerName="" s GerName=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",2)   //通用名不存在取医嘱项描述
	////^INCI(0,"ARCIM_DR",$p({INCI_OriginalARCIM_DR},"||",1), {INCI_RowId})
	s incDr="" s incDr=$O(^INCI(0,"ARCIM_DR",ARCIMRowid,incDr))
	if incDr'="" s Spec=..GetDrugSpec(ARCIMRowid_"||"_ARCIMSub)         //$P(^INCI(incDr,3),"^",9)
	q $G(GerName)   //_$G(Spec) //"("_$G(Spec)_")"
}

ClassMethod GetDrugSpec(ArcimID As %Library.String = "") As %String
{
  	s rtn=""
  	q:ArcimID="" rtn
  	s inc=$o(^INCI(0,"ARCIM_DR",$p(ArcimID,"||",1),""))
  	q:inc="" rtn
  	s itminf=""
  	s itminf=$o(^DHCITMINFO(0,"INCI",inc,""))
  	i itminf'=""  d
  	.s rtn=$p($g(^DHCITMINFO(itminf)),"^",27)
  	q rtn
}

ClassMethod GetEqUomQty(arcimId) As %String
{
	q:arcimId="" "^1^^1"
	s phcdfId=$p($g(^ARCIM(+arcimId,$p(arcimId,"||",2),1)),"^",12)
	q:phcdfId="" "^1^^1"
	s phcdId=+phcdfId,phcdfSub=$p(phcdfId,"||",2)
	q:phcdfSub="" "^1^^1"
	s baseUomId=$p($g(^PHCD(phcdId,"DF",phcdfSub,2)),"^",4)
	
	s volume=""
	s volUomId=$o(^CT("UOM",0,"Code","ML",""))
	s eqUomId=baseUomId,eqQty=1,eqDefaultDose=1
	s eqId=0,haveData=0
	f  s eqId=$o(^PHCD(phcdId,"DF",phcdfSub,"EQ",eqId)) q:eqId=""  d
	.i volUomId=+^PHCD(phcdId,"DF",phcdfSub,"EQ",eqId) d
	..s volume=$p(^PHCD(phcdId,"DF",phcdfSub,"EQ",eqId),"^",2)
	..i +volume=0 s volume=1
	.q:haveData>0
	.s eqUomId=+^PHCD(phcdId,"DF",phcdfSub,"EQ",eqId)
	.s eqQty=$p(^PHCD(phcdId,"DF",phcdfSub,"EQ",eqId),"^",2)
	.s eqDefaultDose=$p(^PHCD(phcdId,"DF",phcdfSub,"EQ",eqId),"^",3)
	.s haveData=1
	i eqQty=0 s eqQty=1
	i $p(eqQty,".",1)="" s eqQty=0_eqQty
	i eqDefaultDose<1 s eqDefaultDose=eqQty
	i eqDefaultDose<1 s eqDefaultDose=1
	
	q eqUomId_"^"_eqDefaultDose_"^"_baseUomId_"^"_eqQty_"^"_volume
}

ClassMethod changeAdmDate(Adm) As %String
{
	s retbeddr=""
	s AdmDate=$ZD($p($g(^PAADM(Adm)),"^",6),3)
    s curdate=+$H
   	s chl="" f  s chl=$O(^PAADM(Adm,"TRANS",chl)) q:chl=""  d
  	.s loc=$P(^PAADM(Adm,"TRANS",chl),"^",6)
  	.s beddr=$P(^PAADM(Adm,"TRANS",chl),"^",8)
  	.if beddr'="" s retbeddr=beddr
    if (retbeddr="")&(curdate>AdmDate)
    {
	    s a=##class(User.PAAdm).%OpenId(Adm)
	    s a.PAADMAdmDate=curdate
	    d a.%Save()
	}
	q 0
}

ClassMethod GetQueryData(QueryName As %String, parrm As %String, funname As %String) As %String
{
  	//s a=##class(web.DHCMGNurComm).GetQueryData()
   	//s QueryName="web.DHCPrisonMoudComm:MoudData"
   	//s parrm="parr$PRISON_Salvage^8"
  	// s funname="AddRec"

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
     	if i<l s pp=pp_p_","
     	e  s pp=pp_p 
   	}

   	Set rset = ##class(%ResultSet).%New(QueryName)
   	Set columns = rset.GetColumnCount()


 	// Execute the query
  	if pp="" s sc=rset.Execute()
  	else  s sc = rset.Execute(@pp)
  	s i=0
  	While (rset.Next()) 
  	{
       	s coldata=""
       	s rd="["
       	For col = 1:1:columns 
       	{
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
  		&javascript<#(rtnval)#>
 	}
 	Do rset.Close()
 	//	    .//s rtnval=funname_"('"_$ZCVT($g(condep),"O","JS")_"','"_$ZCVT($g(status),"O","JS")_"','"_$ZCVT($P($g(bedcode),"@",2),"O","JS")_"','"_$ZCVT($g(appdep),"O","JS")_"','"_$ZCVT($g(inout),"O","JS")_"','"_$ZCVT($P($g(Diag),"@",2),"O","JS")_"','"_$ZCVT($g(condestinat),"O","JS")_"','"_$ZCVT($P($g(patname),"@",2),"O","JS")_"','"_$ZCVT($g(apptime),"O","JS")_"','"_$ZCVT($g(appdate),"O","JS")_"','"_$ZCVT($g(consultdate),"O","JS")_"','"_$ZCVT($g(contime),"O","JS")_"','"_$ZCVT($g(Adm),"O","JS")_"','"_$ZCVT($g(id),"O","JS")_"');"

 	q 0
}

/// added by panshuai 2013-03-11 
ClassMethod getRTypPatinfo(admId) As %String
{
 	//##class(web.DHCMGNurComm).GetPatInfo
  	//s ret=..PatInfo(EpisodeId)
    s papmiId=+^PAADM(admId)
    s mradm=$p(^PAADM(admId),"^",61)
    s diag=..Diag(mradm,"PRE")
    s ctlocId=$p(^PAADM(admId),"^",4)
	s ctlocDesc=$p(^CTLOC(+ctlocId),"^",2)	
	s doc=$p(^PAADM(admId),"^",9)
	if doc'="" s DocDes=$P($G(^CTPCP(doc,1)),"^",2)
    s roomId=$p(^PAADM(admId),"^",69)
    i (roomId'="") s room=$p(^PAROOM(roomId),"^",2)
    s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
    s MedCareNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)
    s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
    i $d(^PAPER(papmiId,"PAT",3)) s safetyNetCardNo=$p(^PAPER(papmiId,"PAT",3),"^",4) ;病案号
    e  s safetyNetCardNo=""
    s sex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
    S homeAddres=$g(^PAPER(papmiId,"PER","ADD")) // 住址
    s homeTel=$p($g(^PAPER(papmiId,"PER",1)),"^",11)  //家庭电话
    s workTel=$p($g(^PAPER(papmiId,"PER",1)),"^",9)   //工作电话
    s handtel=$p($g(^PAPER(papmiId,"PER",4)),"^",21)  //手机
    s bedSub=$p($p($g(^PAADM(admId)),"^",73),"||",2)
    s curWardId=$p($g(^PAADM(admId)),"^",70)  
    i curWardId'="" s wardDesc=$p(^PAWARD(curWardId),"^",1)
    i bedSub'="" s bedCode=$p($g(^PAWARD(curWardId,"BED",bedSub)),"^",1)
    e  s bedCode=""
    s birth=$p($g(^PAPER(papmiId,"ALL")),"^",6)
    s age=..CalAge(birth,+$h)
    s age=$p(age,"Y",1)
    s DiagnosDr=$O(^Nur.DHCNurCopyDiagnosI("EpisodeId"," "_admId,""),-1)
	i DiagnosDr'="" s diag=$List(^Nur.DHCNurCopyDiagnosD(DiagnosDr),2)
	//e  s diag=""
	s AdmDate=$ZD($p($g(^PAADM(admId)),"^",6),3)

    //ctlocDesc未取后半部分 ypz 060522
   	// s retStr="^Telephone@"_homeTel_"^PatAddress@"_homeAddres_"^BirthDate@"_$ZD(birth,3)_"^BirthDate@"_$ZD(birth,3)_"^AdmDate@"_AdmDate_"^REGNO@"_regNo_"^LOC@"_ctlocDesc_"^ROOM@"_$g(room)_"^SEX@"_$g(sex)_"^PATNAME@"_$g(patName)_"^BEDCODE@"_$g(bedCode)_"^AGE@"_$g(age)_"岁^WARD@"_$g(wardDesc)_"^DIAG@"_diag_"^MedCareNo@"_MedCareNo
    //s retStr="Item5@"_regNo_"^Item3@"_ctlocDesc_"^ROOM@"_$g(room)_"^Item40@"_$g(sex)_"^Item1@"_$g(patName)_"^Item4@"_$g(bedCode)_"^Item2@"_$g(age)_"岁^WARD@"_$g(wardDesc)_"^Item13@"_diag_"^MedCareNo@"_MedCareNo
    s retStr="Item6@"_regNo_"^Item4@"_ctlocDesc_"^ROOM@"_$g(room)_"^Item2@"_$g(sex)_"^Item1@"_$g(patName)_"^Item5@"_$g(bedCode)_"^Item3@"_$g(age)_"岁^WARD@"_$g(wardDesc)_"^Item18@"_diag_"^MedCareNo@"_MedCareNo  //入院评估单新版数据对应的ITEM返回值
    
    s retStr=$TR(retStr,"@","|")
    q retStr
}

/// typ: DIS^出院诊断 M^主诊断 PRE^初步诊断,空取所有诊断
/// /ifnotICD:默认为true,默认icd诊断和非icd诊断一起取,否则只取icd诊断
/// w ##class(web.DHCMGNurComm).Diag()
ClassMethod Diag(mradm, typ, ifnotICD = "true")
{
 	//web.DHCMGNurComm^GetPat^^S0|PATNAME@S1|AGE@S2|SEX@S3|DIAG@S4|LOC
    s i=0
    s diag=""
    f a2=1:1:$g(^MR(mradm,"DIA",0)) d
    .s icdr=$p($g(^MR(mradm,"DIA",a2)),"^",1)
    .i icdr'="" d
    ..s diatypedr=$P($g(^MR(mradm,"DIA",a2,"TYP",1)),"^",1)
    ..i $g(diatypedr)'="" s diatype=$P($g(^MRC("DTYP",diatypedr)),"^",1)  ;诊断类型
    ..e  s diatype=""
    ..;q:diatype'=typ
    ..q:(diatype'=typ)&(typ'="")
    ..s date=$ZD($p($g(^MR(mradm,"DIA",a2)),"^",7),3) ;日期
    ..s statusdr=$p($g(^MR(mradm,"DIA",a2)),"^",9)
    ..//i statusdr'="" d
    ..//.s status=$P($g(^MRC("DSTAT",statusdr)),"^",2)
    ..//.e  d
    ..//..s status=""
    ..s icdcode=$P($g(^MRC("ID",icdr)),"^",2)   ;疾病描述
    ..s mrdesc=""
    ..f de=1:1:$g(^MR(mradm,"DIA",a2,"DES",0)) d
    ...s mrdesc=$g(mrdesc)_$g(^MR(mradm,"DIA",a2,"DES",de)) ;
    ..s i=i+1
    ..;s diag=icdcode_" "_$g(mrdesc)
    ..i diag="" s diag=icdcode_" "_$g(mrdesc)
    ..e  s diag=diag_";"_icdcode_" "_$g(mrdesc)
          
    //---------- 取非标准ICD诊断，按诊断类型过滤
    s ret="",MRDIADesc=""
    s chl="" f  s chl=$o(^MR(mradm,"DIA",chl)) q:chl=""  d
    .q:chl=""
    .s typedr=$P($g(^MR(mradm,"DIA",chl,"TYP",1)),"^",1)
    .i $g(typedr)'="" s type=$P($g(^MRC("DTYP",typedr)),"^",1)  ;诊断类型
    .e  s type=""
    .q:(type'=typ)&(typ'="")
    .s MRDIADesc=0 s MRDIADesc=$o(^MR(mradm,"DIA",chl,"DES",MRDIADesc))
    .q:MRDIADesc=""
    .s MRDIADesc=$p(^MR(mradm,"DIA",chl,"DES",MRDIADesc),"^",1)
    .i ret="" s ret=MRDIADesc
    .e  s ret=ret_";"_MRDIADesc
    i ifnotICD="true" d
    .i ret'="" d
    ..i diag="" s diag=ret
    ..e  s diag=diag_";"_ret
    q diag
}

ClassMethod PACInPatDateBed(EpisodeID As %String = "") As %String
{
    q:EpisodeID="" ""
    s ret=""
    s TRANSChildsub=0,Flag=0
    f  s TRANSChildsub=$o(^PAADM(EpisodeID,"TRANS",TRANSChildsub)) q:(TRANSChildsub="")!(Flag=1)  d
    .s TRANBed=$p(^PAADM(EpisodeID,"TRANS",TRANSChildsub),"^",8)
    .q:TRANBed=""
    .i TRANBed'="" s Flag=1
    .s TRANDate=$p(^PAADM(EpisodeID,"TRANS",TRANSChildsub),"^",1)
    .s TRANDate=##class(websys.Conversions).DateLogicalToHtml(TRANDate)
    .s TRANTime=$p(^PAADM(EpisodeID,"TRANS",TRANSChildsub),"^",2)
    .s ^par("admDate")=TRANTime
    .s TRANTime=$zt(TRANTime,1)
    .s userDr=$p(^PAADM(EpisodeID,"TRANS",TRANSChildsub),"^",16)
    .s ret=TRANDate_"^"_TRANTime_"^"_userDr
    .;s ret=userDr
    q ret
}

ClassMethod PatTransDateLoc(Adm)
{
	s dqks=""
	s zrks=""
	s zrrq=""
	s sub=""
	f  s sub=$o(^PAADM(Adm,"TRANS",sub),-1) q:(sub="")||((dqks'="")&&(zrks'=""))  d
	.s CTLOCDR=$p(^PAADM(Adm,"TRANS",sub),"^",6)
	.s TRANSStartDate=$p(^PAADM(Adm,"TRANS",sub),"^",1)
	.q:CTLOCDR=""
	.i dqks=""  s dqks=CTLOCDR
	.i dqks=CTLOCDR  s zrrq=$zd(TRANSStartDate,3)
	.i (dqks'="")&&(dqks'=CTLOCDR)&&(zrks="")  d
	..s zrks=$p(^CTLOC(CTLOCDR),"^",2)
	
	q zrks_"^"_zrrq
}

ClassMethod setmoudtmp1(parr, tmval)
{
    s par1=$P(parr,"&")
    s chepar=$P(parr,"&",2)
	s l=$L(chepar,"^")
	s comboret=$P(parr,"&",3)
	f i=1:1:l
	{
	  	s itm=$P(chepar,"^",i)
	  	if itm="" continue
	 
	  	s arr=$P(itm,"|")
	  	s name=$P(arr,"_")
	  	s selcode=$P(arr,"_",2)
	  	s val=$P(itm,"|",2)
	  	s val3=$P(itm,"|",3)       //多选
	  	if val'="" s val="☑"_val  //多选
	  	if val="" s val="□"_val3  //多选
	  	if '$D(tmval(name)) s tmval(name)=val
	  	e  s tmval(name)=tmval(name)_";"_val
	}
	s l=$L(par1,"^")
	for i=1:1:l
	{
	  	s itm=$P(par1,"^",i)
	  	if itm="" continue

	  	s name=$P(itm,"|")
	  	s val=$P(itm,"|",2)
	  	s tmval(name)=val
	}
	s l=$L(comboret,"^")
	for i=1:1:l
	{
	  	s itm=$P(comboret,"^",i)
	  	if itm="" continue
	  	s name=$P(itm,"|")
	  	s arr=$P(itm,"|",2)
	  	s val=$P(arr,"!",1)
	  	s des=$P(arr,"!",2)
	  	s tmval(name)=val_"!"_des
	  	if (des="date")
	  	{
		  	if (val'="") s val=$ZDH(val,3)
		  	e  s val=""
		  	s tmval(name)=val
	  	}
	  	if (des="time")
	  	{
		  	if (val'="") s val=$ZTH(val,4)
		  	e  s val=""
		  	s tmval(name)=val
	  	}
	}
	q 0
}

/// 返回病人年龄按"岁"向下取整后的数字-XTang20.3.27
/// w ##class(web.DHCMGNurComm).getAgeYearNum("267")
ClassMethod getAgeYearNum(admId As %String)
{
	s retStr=""
	q:admId="" retStr
	s papmiId=+^PAADM(admId)
	s birth=$p($g(^PAPER(papmiId,"ALL")),"^",6)
    s age=##class(web.DHCBillInterface).GetPapmiAge(papmiId,admId)
    s motherAdm=$p($g(^PAADM(admId)),"^",75)
	s pavisit=$p($g(^PAADM(admId)),"^",20)
	//出院小孩取出院时年龄--349为儿科/产科科室ID
	s ctlocId=$p(^PAADM(admId),"^",4)
	s CTLOCHospitalDR=$P(^CTLOC(+ctlocId),"^",22)
	i ctlocId=349&&(pavisit'="A") d  		
	.s dischDate=$p(^PAADM(admId),"^",17) 
	.s dischTime=$p(^PAADM(admId),"^",18)
	.q:dischDate=""
	.i $d(^PAPER("DHC",papmiId,1)) d
	..s babybirstr=^PAPER("DHC",papmiId,1)
	..s birthDate=$p(babybirstr,"^",1)
	..s birthTime=$p(babybirstr,"^",2)
	.e  d
	..s babybirstr=$g(^PAPER(papmiId,"ALL"))
	..s birthDate=$p($g(^PAPER(papmiId,"ALL")),"^",6)
	..s birthTime=0
	.s age=##class(web.UDHCJFCOMMON).DispPatAge(birthDate,dischDate,birthTime,dischTime,CTLOCHospitalDR,"Y")
	.s age=$p(age,"||",1)
	i age'["岁" s retStr="AgeYearNum@"_"0"
	e  s retStr="AgeYearNum@"_(+age)
	q retStr
}

/// Creator: 		tangshuang
/// CreatDate: 		
/// Description: 	取分娩日期时间
/// Other           
ClassMethod getDeliveryDateTime(episodeID)
{
    s pregnancyID=$o(^PAPRGi("PREG_Person",personID,""))
    s deliveryID=$o(^PAPRGi("DEL_Adm_DR",episodeID,pregnancyID,"DEL",""))
    i pregnancyID="" s qHandle=$lb(0,repid,0) q $$$OK
    s babyOrderNumber=0 f  s babyOrderNumber=$o(^PAPRGi("BABY_BirthOrderNumber",babyOrderNumber)) q:babyOrderNumber=""  d
    .s deliveryBabyID="" f  s deliveryBabyID=$o(^PAPRGi("BABY_BirthOrderNumber",babyOrderNumber,pregnancyID,"DEL",deliveryID,"BABY",deliveryBabyID)) q:deliveryBabyID=""  d
    ..s deliveryBabyData=^PAPRG(pregnancyID,"DEL",deliveryID,"BABY",deliveryBabyID)
    ..s pregDelBabyID=pregnancyID_"||"_deliveryID_"||"_deliveryBabyID
    ..s babyPersonID=$p(deliveryBabyData,"^",73)
    ..s birthDate=##class(websys.Conversions).DateLogicalToHtml($p(deliveryBabyData,"^",13))
    ..s birthTime=$zt($p(deliveryBabyData,"^",49),2)
}

}
