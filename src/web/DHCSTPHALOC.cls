Import SQLUser

Class web.DHCSTPHALOC Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod Insert(locdr, spflag, cydyflag, dts, prefix, auditneedflag, resretflag, parastr) As %String
{
 n (locdr,spflag,cydyflag,dts,prefix,auditneedflag,resretflag,parastr)
 s dispsd=$p(dts,"^",1)
 s disped=$p(dts,"^",2)
 s dispst=$p(dts,"^",3)
 s dispet=$p(dts,"^",4)
 s statsd=$p(dts,"^",5)
 s stated=$p(dts,"^",6)
 s statst=$p(dts,"^",7)
 s statet=$p(dts,"^",8)
 s retstdate=$p(dts,"^",9)
 s retenddate=$p(dts,"^",10)

 s dispuserflag=$p(parastr,"^",1)
 s retallflag=$p(parastr,"^",2) 
 s operaterflag=$p(parastr,"^",3)
 s aduitbillflag=$p(parastr,"^",4)
 s disptypelocalflag=$p(parastr,"^",5)
 s displayemyflag=$p(parastr,"^",6)
 s displayoutflag=$p(parastr,"^",7)
 s lsflag=$p(parastr,"^",8)
 s reqwardflag=$p(parastr,"^",9)
 s dispdefaultflag=$p(parastr,"^",10)
 s peret=$p(parastr,"^",11)  //配液打印停止签时自动退药
 s sendmachine=$p(parastr,"^",12) //摆药机
 s ordauditflag=$p(parastr,"^",13) //发药前禁忌审核
 s dealordflag=$p(parastr,"^",14) //发药前医嘱处理

 &sql(
	insert into DHC_PhaLocation
	(
		PL_CTLOC_DR, PL_WardRequired, PL_CYDYFlag, PL_DispStartDate, PL_DispEndDate,
	 	PL_DispStartTime, PL_DispEndTime, PL_StatStartDate, PL_StatEndDate, PL_StatStartTime,
		PL_StatEndTime, PL_CountPrefix, PL_AuditNeed_Flag, PL_ReserveRetFlag,PL_DispUserFlag,
		PL_RetStDate, PL_RetEndDate, PL_RetAllFlag, PL_OperaterFlag,PL_AduitBillFlag,
		PL_DispTypeLocalFlag, PL_DisplayEmyFlag, PL_DisplayOutFlag, PL_LSFlag, PL_ReqWardFlag,
		PL_DispDefaultFlag, PL_PrtRetFlag, PL_SendMachine, PL_OrdAuditFlag, PL_DealOrdFlag
	)
    values
	(
		:locdr, :spflag, :cydyflag, :dispsd, :disped,
		:dispst, :dispet, :statsd, :stated, :statst,
		:statet, :prefix, :auditneedflag, :resretflag, :dispuserflag,
		:retstdate, :retenddate, :retallflag, :operaterflag, :aduitbillflag,
		:disptypelocalflag, :displayemyflag, :displayoutflag, :lsflag, :reqwardflag,
		:dispdefaultflag, :peret, :sendmachine, :ordauditflag, :dealordflag
	)
) 
 q:SQLCODE'=0 -1
 q $p(%ROWID,$c(1))
}

ClassMethod Update(dr, locdr, spflag, cydyflag, dts, prefix, auditneedflag, resretflag, parastr) As %String
{
 n (dr,locdr,spflag,cydyflag,dts,prefix,auditneedflag,resretflag,parastr)
 s phalc="",existFlag=0
 f  s phalc=$o(^DHCPL(0,"Loc",locdr,phalc)) q:phalc=""  d
 .i phalc'=dr s existFlag=existFlag+1
 q:existFlag'=0 -2
 s dispsd=$p(dts,"^",1)
 s disped=$p(dts,"^",2)
 s dispst=$p(dts,"^",3)
 s dispet=$p(dts,"^",4)
 s statsd=$p(dts,"^",5)
 s stated=$p(dts,"^",6)
 s statst=$p(dts,"^",7)
 s statet=$p(dts,"^",8)
 s retstdate=$p(dts,"^",9)
 s retenddate=$p(dts,"^",10)
 s dispuserflag=$p(parastr,"^",1)
 s retallflag=$p(parastr,"^",2)
 s operaterflag=$p(parastr,"^",3)
 s aduitbillflag=$p(parastr,"^",4)
 s disptypelocalflag=$p(parastr,"^",5)
 s displayemyflag=$p(parastr,"^",6)
 s displayoutflag=$p(parastr,"^",7)
 s lsflag=$p(parastr,"^",8)
 s reqwardflag=$p(parastr,"^",9)
 s dispdefaultflag=$p(parastr,"^",10)
 s peret=$p(parastr,"^",11)  //配液打印停止签时自动退药
 s sendmachine=$p(parastr,"^",12) //摆药机
 s ordauditflag=$p(parastr,"^",13) //发药前禁忌审核
 s dealordflag=$p(parastr,"^",14) //发药前医嘱处理
 s result = ##class(%Library.ResultSet).%New()
 s sqlStr="select PL_CTLOC_DR as loc,PL_Rowid as rowid from DHC_PhaLocation "
 d result.Prepare(sqlStr)
 d result.Execute()
 While(result.Next())
 {	
	 s rowid=result.Data("rowid")
	 s loc=result.Data("loc")
 }
 d result.Close()
 if (dr'=rowid)&&(locdr=loc)  q -2
 ;s dispoperflag=dispuserflag+"^"+operaterflag
 &sql(update DHC_PhaLocation  set PL_CTLOC_DR=:locdr,PL_WardRequired=:spflag,PL_CYDYFlag=:cydyflag,
  PL_DispStartDate=:dispsd,PL_DispEndDate=:disped,PL_DispStartTime=:dispst,PL_DispEndTime=:dispet,
  PL_StatStartDate=:statsd,PL_StatEndDate=:stated,PL_StatStartTime=:statst,PL_StatEndTime=:statet,
  PL_CountPrefix=:prefix,PL_AuditNeed_Flag=:auditneedflag,PL_ReserveRetFlag=:resretflag,PL_DispUserFlag=:dispuserflag,
  PL_RetStDate=:retstdate,PL_RetEndDate=:retenddate,PL_RetAllFlag=:retallflag,PL_OperaterFlag=:operaterflag,
  PL_AduitBillFlag=:aduitbillflag,PL_DispTypeLocalFlag=:disptypelocalflag,PL_DisplayEmyFlag=:displayemyflag,
  PL_DisplayOutFlag=:displayoutflag,PL_LSFlag=:lsflag,PL_ReqWardFlag=:reqwardflag,PL_DispDefaultFlag=:dispdefaultflag,
  PL_PrtRetFlag=:peret,PL_SendMachine=:sendmachine,PL_OrdAuditFlag=:ordauditflag,PL_DealOrdFlag=:dealordflag
  where PL_Rowid=:dr)
 q:SQLCODE'=0 -1
 q:SQLCODE=0 1
}

ClassMethod Delete(id) As %String
{
 &sql(delete from  DHC_PhaLocation where PL_Rowid=:id)
 q:SQLCODE'=0 -1
 q:SQLCODE=0 1
}

/// w ##class(web.DHCSTPHALOC).InsertItm(35,4,"","","","")
ClassMethod InsertItm(parref, drugtypedr, longflag, shortflag, cydyflag, defaultflag) As %String
{
 //&sql(select max(PLDP_Childsub) into :childsub from DHC_PhaLocDisType where PLDP_PL_Parref=:parref)
 &SQL(SELECT * FROM DHC_PhaLocDisType WHERE PLDP_PL_Parref=:parref AND PLDP_DrugType_DR=:drugtypedr)
 q:SQLCODE=0 -2
 s childsub=$o(^DHCPL(parref,"DIS",""),-1)
 s childsub=childsub+1
 &sql(insert into DHC_PhaLocDisType(PLDP_PL_Parref,PLDP_Childsub,PLDP_DrugType_DR,
      PLDP_OrdLongFlag,PLDP_OrdShortFlag,PLDP_OrdCYDYFlag,PLDP_DefaultFlag)      
      values(:parref,:childsub,:drugtypedr,:longflag,:shortflag,:cydyflag,:defaultflag))
 q:SQLCODE'=0 SQLCODE
 q $p(%ROWID,$c(1))
}

ClassMethod UpdateItm(id, drugtypedr, longflag, shortflag, cydyflag, defaultflag) As %String
{
 &sql(update DHC_PhaLocDisType set PLDP_DrugType_DR=:drugtypedr,PLDP_OrdLongFlag=:longflag,
  PLDP_OrdShortFlag=:shortflag,PLDP_OrdCYDYFlag=:cydyflag,PLDP_DefaultFlag=:defaultflag
 where PLDP_Rowid=:id)
 q:SQLCODE'=0 -1
 q:SQLCODE=0 1
}

ClassMethod DeleteItm(id) As %String
{
 &sql(delete from  DHC_PhaLocDisType where PLDP_Rowid=:id)
 q:SQLCODE'=0 -1
 q:SQLCODE=0 1
}

ClassMethod GetDrugTypeByLoc(loc)
{
 k PLIST
 s num=0
 s Parref=""
 s loc=##class(web.DHCSTCOMMONSRV).LocToRowID(loc)
 s Parref=$o(^DHCPL(0,"Loc",loc,""))
 q:Parref="" num
 s specflag=$p(^DHCPL(Parref),"^",2)
 s CHI=""
 f  s CHI=$o(^DHCPL(Parref,"DIS",CHI)) q:CHI=""  d
 .s defaultflag=$p(^DHCPL(Parref,"DIS",CHI),"^",5) 
 .s drugtypedr=$p(^DHCPL(Parref,"DIS",CHI),"^",1)
 .s typecode=$p(^DHCSTDRUGGRP(drugtypedr),"^",1)
 .s typedesc=$p(^DHCSTDRUGGRP(drugtypedr),"^",2)
 .s drugtype=typecode_"^"_typedesc
 .s num=num+1
 .s PLIST(num)=drugtypedr_"^"_drugtype_"^"_$p(defaultflag,$c(1),1)
 s PLIST=num
 q num
}

ClassMethod GetPhaLoc(rowid)
{
	s locdr=$p(^DHCPL(rowid),"^",1)
	i locdr'="" s locdesc=$p(^CTLOC(locdr),"^",2)
	s specflag=$p(^DHCPL(rowid),"^",2)   ;按病区发药标志
	s cydyflag=$p(^DHCPL(rowid),"^",3)   ;出院带药标志
	s dsd=$p(^DHCPL(rowid),"^",4)
	s ded=$p(^DHCPL(rowid),"^",5)
	s dst=$p(^DHCPL(rowid),"^",6)
	s det=$p(^DHCPL(rowid),"^",7)
	s ssd=$p(^DHCPL(rowid),"^",8)
	s sed=$p(^DHCPL(rowid),"^",9)
	s sst=$p(^DHCPL(rowid),"^",10)
	s set=$p(^DHCPL(rowid),"^",11)
	;
	s needAuditFlag=$p(^DHCPL(rowid),"^",14)
	s resFlag=$p(^DHCPL(rowid),"^",16)
	;
	s countno=$p(^DHCPL(rowid),"^",12)
	s coutnfix=$p(^DHCPL(rowid),"^",13)
	s finaldate=$p(^DHCPL(rowid),"^",15)
	s dispuser=$p(^DHCPL(rowid),"^",17)
	s retstdate=$p(^DHCPL(rowid),"^",18)
	s retenddate=$p(^DHCPL(rowid),"^",19)
	s retallflag=$p(^DHCPL(rowid),"^",20)
	s operaterflag=$p(^DHCPL(rowid),"^",21)
	s aduitBillflag=$p(^DHCPL(rowid),"^",22)
	s disptypelocalflag=$p(^DHCPL(rowid),"^",23)
	s displayemyflag=$p(^DHCPL(rowid),"^",24)
	s displayoutflag=$p(^DHCPL(rowid),"^",25)
	s lsflag=$p(^DHCPL(rowid),"^",26)
	s reqwardflag=$p(^DHCPL(rowid),"^",27)
	s dispdefaultflag=$p(^DHCPL(rowid),"^",28)
	s outprint=$p(^DHCPL(rowid),"^",29)
	s prtret=$p(^DHCPL(rowid),"^",30)
	s sendmachine=$p(^DHCPL(rowid),"^",31)
	s ordauditflag=$p(^DHCPL(rowid),"^",32)
	s dealordflag=$p(^DHCPL(rowid),"^",37)
	s audituserflag=$p(^DHCPL(rowid),"^",38)
	q $g(specflag)_"^"_$g(cydyflag)_"^"_$g(dsd)_"^"_$g(ded)_"^"_$g(dst)_"^"_$G(det)_"^"_$g(ssd)_"^"_$g(sed)_"^"_$g(sst)_"^"_$g(set)_"^"_$g(needAuditFlag)_"^"_$g(resFlag)_"^"_$g(locdr)
	_"^"_$g(locdesc)_"^"_$g(finaldate)_"^"_$g(coutnfix)_"^"_$g(countno)_"^"_$g(dispuser)_"^"_$g(retstdate)_"^"_$g(retenddate)_"^"_$g(retallflag)_"^"_$g(operaterflag)
	_"^"_$g(aduitBillflag)_"^"_$g(disptypelocalflag)_"^"_$g(displayemyflag)_"^"_$g(displayoutflag)_"^"_$g(lsflag)_"^"_$g(reqwardflag)_"^"_$g(dispdefaultflag)_"^"_$g(outprint)_"^"_$g(prtret)
	_"^"_$g(sendmachine)_"^"_$g(ordauditflag)_"^"_dealordflag_"^"_audituserflag
}

ClassMethod GetPhaflag(locdr)
{
 n (locdr)
 s result=""
 s Parref=""
 
 i locdr'="" d
 .s locdr=+locdr
 .i $d(^DHCPL(0,"Loc",locdr)) d
 ..s Parref=$o(^DHCPL(0,"Loc",locdr,"")) 
 ..i Parref'="" d
 ... s result=..GetPhaLoc(Parref)
 q result
}

ClassMethod GetLocDrugType(parref)
{
 k PLIST
 s i=0     
 &sql(declare curc cursor for select PLDP_Rowid,PLDP_DrugType_DR,
   PLDP_DrugType_DR,
   PLDP_OrdLongFlag,PLDP_OrdShortFlag,PLDP_OrdCYDYFlag,PLDP_DefaultFlag
   into :dr,:drugtypedr,:drug,:longflag,:shortflag,:cydyflag,:DefaultFlag
   from DHC_PhaLocDisType
   where PLDP_PL_Parref=:parref)    
 &sql(open curc)
 f  &sql(fetch curc)  q:SQLCODE  d
 .s i=i+1
 .s drugcode=$p(^DHCSTDRUGGRP(drug),"^",1)
 .s drugdesc=$p(^DHCSTDRUGGRP(drug),"^",2)
 .s drugdesc=drugcode_"~"_drugdesc
 .s longflag=$p(longflag,$c(1),1)
 .s shortflag=$p(shortflag,$c(1),1)
 .s cydyflag=$p(cydyflag,$c(1),1)
 .s DefaultFlag=$p(DefaultFlag,$c(1),1)
 .s PLIST(i)=dr_"^"_+drugtypedr_"^"_drugdesc_"^"_longflag_"^"_shortflag_"^"_cydyflag_"^"_DefaultFlag
 s PLIST=$o(PLIST(""),-1)                                            
 &sql(close curc)
 q i
}

ClassMethod GetPhaLocDisType(loc As %String) As %String
{
  n (loc)
  s pha=$o(^DHCPL(0,"Loc",loc,"")) q:pha="" ""
  s ch=0
  s result=""
  f  s ch=$o(^DHCPL(pha,"DIS",ch)) q:ch=""  d
  .s drugtype=$p(^(ch),"^",1)
  .//q:drugtype=1  d
  .s distypecode=$p(^DHCSTDRUGGRP(drugtype),"^",1)
  .i result="" s result=distypecode
  .e  s result=result_"^"_distypecode
  q result
}

ClassMethod PhaLocExecute(ByRef qHandle As %Binary) As %Status
{
	
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	d GetLocation()	
	q $$$OK
GetLocation()
 k PLIST  
 s i=0  
 s rowid=""
 s locdr=""
 s specflag=""
 s cydyflag=""
 s dsd=""
 s ded=""
 s dst=""
 s det=""
 s ssd=""
 s sed=""
 s sst=""
 s set=""
 s countprefix=""
 s countnum=""
 s auditneed="" 
    
 &sql(declare curb cursor for select PL_Rowid,PL_CTLOC_DR,
   PL_WardRequired,PL_CYDYFlag,PL_DispStartDate,PL_DispEndDate,PL_DispStartTime,PL_DispEndTime,
     PL_StatStartDate,PL_StatEndDate,PL_StatStartTime,PL_StatEndTime,PL_CountPrefix,PL_CountNum,PL_AuditNeed_Flag,PL_ReserveRetFlag,PL_DispUserFlag,
    PL_RetStDate,PL_RetEndDate,PL_RetAllFlag
   into :rowid,:locdr,:specflag,:cydyflag,:dsd,:ded,:dst,:det,:ssd,:sed,:sst,:set,:countprefix,:countnum,:auditneed,:resretflag,:dispuserflag,:retstdate,:retenddate,:retallflag from DHC_PhaLocation )
 &sql(open curb)
 f  &sql(fetch curb)  q:SQLCODE  d
 .q:locdr=""
 .q:+locdr<1
 .s locdr=+locdr,loc=$p(^CTLOC(locdr),"^",2)
 .s i=i+1
 .;
 .s specflag=$p(specflag,$c(1),1)
 .s cydyflag=$p(cydyflag,$c(1),1)
 .
 .s auditneed=$p(auditneed,$c(1))
 .s resretflag=$p(resretflag,$c(1))
 .
 .;s PLIST(i)=+dr_"^"_locdr_"^"_loc_"^"_specflag_"^"_$p(cydyflag,$char(1),1)_"^"_dsd_"^"_ded_"^"_dst_"^"_det_"^"_ssd_"^"_sed_"^"_sst_"^"_set
 .d outputrow
 &sql(close curb)
 q
outputrow
 s Data=$lb(+rowid,+locdr,loc,specflag,cydyflag,dsd,ded,dst,det,ssd,sed,sst,set,countprefix,countnum,auditneed,resretflag,dispuserflag,retstdate,retenddate,retallflag )
 s ^CacheTemp(repid,ind)=Data	
 s ind=ind+1
 q
}

ClassMethod PhaLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PhaLocExecute ]
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

ClassMethod PhaLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PhaLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// w ##class(%ResultSet).RunQuery("web.DHCSTPHALOC","PhaLoc")
Query PhaLoc() As %Query(ROWSPEC = "dr:%String,locdr:%String,loc:%String,specflag:%String,cydyflag:%String,dsd:%String,ded:%String,dst:%String,det:%String,ssd:%String,sed:%String,sst:%String,set:%String,countprefix:%String,countnum:%String,auditneed:%String,ReserveRetFlag:%String,DispUserFlag:%String,RetStDate:%String,RetEndDate:%String,RetAllFlag:%String")
{
}

ClassMethod PhaLocDispTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PhaLocDispTypeExecute ]
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

ClassMethod PhaLocDispTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PhaLocDispTypeExecute ]
{
	
   Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod PhaLocDispTypeExecute(ByRef qHandle As %Binary, Parref As %String) As %Status
{
	 
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	q:Parref="" $$$OK
	s ch=0
	f  s ch=$o(^DHCPL(Parref,"DIS",ch)) q:ch=""  s s=^(ch)  d
	.s Rowid=Parref_"||"_ch
	.s DispTypeDR=$p(s,"^",1)
	.s DispTypeDesc=""
	.i (DispTypeDR'="") d 
	.. i $d(^DHCSTDRUGGRP(DispTypeDR)) s DispTypeDesc=$p(^DHCSTDRUGGRP(DispTypeDR),"^",2)
	.s SelectDefault=$p(s,"^",5)
	.d outputrow2
	q $$$OK
outputrow2
 s Data=$lb(Rowid,DispTypeDR,DispTypeDesc,SelectDefault )
 s ^CacheTemp(repid,ind)=Data	
 s ind=ind+1
 q
}

Query PhaLocDispType(Parref As %String) As %Query(ROWSPEC = "Rowid:%String,DispTypeDR:%String,DispTypeDesc:%String,SelectDefault:%String")
{
}

ClassMethod PopuLateDispCats(loc As %String) As %String
{
 s result=""
 s Parref=""
 s Parref=$o(^DHCPL(0,"Loc",loc,""))
 q:Parref="" result
 s CHI=""
 f  s CHI=$o(^DHCPL(Parref,"DIS",CHI)) q:CHI=""  d
 .s defaultflag=$p(^DHCPL(Parref,"DIS",CHI),"^",5) 
 .s drugtypedr=$p(^DHCPL(Parref,"DIS",CHI),"^",1)
 .s typecode=$p(^DHCSTDRUGGRP(drugtypedr),"^",1)
 .s typedesc=$p(^DHCSTDRUGGRP(drugtypedr),"^",2)
 .s drugtype=typecode_"^"_typedesc
 .i result="" s result=drugtype
 .e  s result=result_"!"_drugtype
 .
 q result
}

/// Description:获取发药科室发药类别
/// Creator:Liang Qiang
/// CreatDate:2009-09-28
/// Input:loc - 发药科室Rowid
/// Output:发药类别
/// Return:发药类别Code1_"@"_发药类别Desc1_"^"_发药类别Code2_"@"_发药类别Desc2
/// Others:w ##class(web.DHCSTPHALOC).GetPhaLocDispType("100")
ClassMethod GetPhaLocDispType(loc As %String) As %String
{
	 n (loc)
	 q:loc="" ""
	 s config=##Class(web.DHCSTKUTIL).GetPhaConfig("Con_DispTypeLocal")
	 s ret=""
	 s plid=$o(^DHCPL(0,"Loc",loc,"")) q:plid="" ""
	 s chl=""
	 f  s chl=$o(^DHCPL(plid,"DIS",chl)) q:chl=""  d
	 .s disptype=$p(^DHCPL(plid,"DIS",chl),"^",1)
	 .s defaultflag=$p(^DHCPL(plid,"DIS",chl),"^",5)
	 .q:'$d(^DHCSTDRUGGRP(disptype))
	 .s typecode=$p(^DHCSTDRUGGRP(disptype),"^",1)
	 .s typedesc=$p(^DHCSTDRUGGRP(disptype),"^",2)
	 .i ret="" d
	 ..s ret=$g(typecode)_"@"_$g(typedesc)
	 .e  d
	 ..s ret=ret_"^"_$g(typecode)_"@"_$g(typedesc)
	 ;
	 s AddType=""
	 //s DisplayOut=##Class(web.DHCSTKUTIL).GetPhaConfig("Con_DisplayOut")
	 s rowid=""
	 s rowid=$o(^DHCPL(0,"Loc",loc,rowid))
	 s result=..GetPhaLoc(rowid)
	 //s DisplayOut=$p(result,"^",26)
	 //i DisplayOut="Y" s DisplayOut=1
	 //e  s DisplayOut=0
	 s DisplayEmy=$p(result,"^",25)
	 i DisplayEmy="Y" s DisplayEmy=1
	 e  s DisplayEmy=0
	 //i DisplayOut=1 d
	 //.s outcat="OUT"_"@"_"出院带药"
	 //.s AddType=outcat
	 //s DisplayEmy=##Class(web.DHCSTKUTIL).GetPhaConfig("Con_DisplayEmy")
	 //i DisplayEmy=1 d
	 //.s emy="EMY"_"@"_"加急"
	 //.i AddType="" d
	 //..s AddType=emy
	 //.e  d
	 //..s AddType=AddType_"^"_emy
	 // QT
	 s qt="QT@其他"
	 i AddType'[qt d
	 .i AddType="" d
	 ..s AddType=qt
	 .e  d
	 ..s AddType=AddType_"^"_qt
	 i ret="" d
	 .s ret=AddType
	 e  d
	 .i AddType'="" d
	 ..s ret=ret_"^"_AddType
	 
	 q ret
}

/// w ##class(web.DHCSTPHALOC).GetDefaultCatTypeStr(246)
ClassMethod GetDefaultCatTypeStr(loc)
{
	s ret=""
	s phaLoc=$o(^DHCPL(0,"Loc",loc,""))
 	q:phaLoc="" ""
 	s chl=0
	f  s chl=$o(^DHCPL(phaLoc,"DIS",chl)) q:chl=""  d
	.s defFlag=$p(^DHCPL(phaLoc,"DIS",chl),"^",5) 
	.q:defFlag'="Y"
	.s cat=$p(^DHCPL(phaLoc,"DIS",chl),"^",1)
	.q:cat=""
	.s code=$p($g(^DHCSTDRUGGRP(cat)),"^",1)
	.s ret=$s(ret="":code,1:ret_"^"_code)
	q ret
}

}
