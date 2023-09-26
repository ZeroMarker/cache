Class web.RunqianQueryReport Extends %RegisteredObject [ ProcedureBlock ]
{

//d ##class(%ResultSet).RunQuery("web.RunqianQueryReport","GetDeptsDirectCost","2","2",1)

ClassMethod GetDeptsDirectCostExecute(ByRef qHandle As %Binary, stdate As %String, endate As %String, units As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	q:stdate="" $$$OK
    q:endate="" $$$OK
    q:stdate>endate $$$OK
    k ^temp($zn,$j)
    s Rowid="" ,num=0
    //****************************************************
    //depsetId:部门分层套中全成本分摊设置dr
    s depsetId=$o(^DHCCADEPTLEVELSETS(0,"Code","c001",0))
    //部门分层套中临床服务类科室dr
    s depsetIdLc=$o(^DHCCADEPTLEVELSETS(0,"Code","d104",0))
    //部门分层套中临床大科分层dr
    s depsetIdDk=$o(^DHCCADEPTLEVELSETS(0,"Code","L101",0))
    //数据分层套中新会计制度报表dr
    s datsetId=$o(^DHCCADATALEVELSETS(0,"Code","f001",0))
    //****************************************************
    s stMonObj=##class(dhc.ca.cache.data.AccountMonths).%OpenId(stdate)
    s stName=stMonObj.AccountMonthsname
    s enMonObj=##class(dhc.ca.cache.data.AccountMonths).%OpenId(endate)
    s enName=enMonObj.AccountMonthsname
 	f i=stdate:1:endate  d
 	.f  s Rowid=$o(^DHCCAVOUCHDATAS(0,"Interval",i,Rowid)) q:Rowid=""  d  
 	..s VouchObj=##class(dhc.ca.cache.data.VouchDatas).%OpenId(Rowid)
 	..s DeptDr=VouchObj.VouchDatasdeptDr.%Id()
 	..s unitObj=##class(dhc.ca.cache.data.UnitDepts).%OpenId(DeptDr)
 	..s unitDr=unitObj.UnitDeptsunitDr.%Id()
 	..q:units'[unitDr
 	..s itemDr=VouchObj.VouchDatasitemDr.%Id()

    ..s debit=VouchObj.VouchDatasdebit
    ..s ^temp($zn,$j,"dhchs",unitDr,DeptDr,itemDr)=$g(^temp($zn,$j,"dhchs",unitDr,DeptDr,itemDr))+debit

    s unitDr="" f  s unitDr=$o(^temp($zn,$j,"dhchs",unitDr)) q:unitDr=""  d 
    .s deptDr="" f  s deptDr=$o(^temp($zn,$j,"dhchs",unitDr,deptDr)) q:deptDr=""  d 
    ..s itemDr="" f  s itemDr=$o(^temp($zn,$j,"dhchs",unitDr,deptDr,itemDr)) q:itemDr=""  d 
    ...s debit=$g(^temp($zn,$j,"dhchs",unitDr,deptDr,itemDr))
    ...d OutputRow1
    k ^temp($zn,$j)
 
 	q $$$OK	
  	
OutputRow1
    
    //部门分层dr
    q:'$d(^DHCCAUNITDEPTS(deptDr))
    s deptCode=$p(^DHCCAUNITDEPTS(deptDr),"^",1)
    s deptName=$p(^DHCCAUNITDEPTS(deptDr),"^",2)
    
	i $d(^DHCCADEPTLEVELSETS(0,"Dept",depsetIdLc,deptDr)) s deptPar=depsetIdDk 
	e  s deptPar=depsetId   
	s deplsDr=##class(dhc.ca.cache.udata.uDeptLevelSets).GetParRef(deptPar,deptDr)     
  	s deplsObj=##class(dhc.ca.cache.data.DeptLevelSets).%OpenId(deplsDr)
  	s deplsRemark=deplsObj.DeptLevelSetsremark,deplsName=deplsObj.DeptLevelSetsname,deplsCode=deplsObj.DeptLevelSetscode
  	//数据分层
  	s datlsDr=##class(dhc.ca.cache.udata.uDataLevelSets).GetLevelItemsParRef(datsetId,itemDr) 
  	s datlsObj=##class(dhc.ca.cache.data.DataLevelSets).%OpenId(datlsDr)
  	s datlsCode=datlsObj.DataLevelSetscode,datlsName=datlsObj.DataLevelSetsname
  	
  	s Data=$lb(stName,enName,unitDr,deplsDr,deplsCode,deplsRemark,deplsName,deptDr,deptCode,deptName,datlsDr,datlsCode,datlsName,itemDr,$num(debit,2))

    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
 	
	q
}

ClassMethod GetDeptsDirectCostFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDeptsDirectCostExecute ]
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

ClassMethod GetDeptsDirectCostClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDeptsDirectCostExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetDeptsDirectCost(stdate As %String, endate As %String, units As %String) As %Query(ROWSPEC = "stName:%String,enName:%String,unitDr:%Integer,deplsDr:%Integer,deplsCode:%String,deplsRemark:%String,deplsName:%String,deptDr:%Integer,deptCode:%String,deptName:%String,datlsDr:%Integer,datlsCode:%String,datlsName:%String,itemDr:%Integer,debit:%Float") [ SqlProc ]
{
}

//新会计制度-科室直接间接成本查询

//d ##class(%ResultSet).RunQuery("web.RunqianQueryReport","GetClinicaDepCost","31","31","1")

ClassMethod GetClinicaDepCostExecute(ByRef qHandle As %Binary, stdate As %String, endate As %String, units As %String) As %Status
{
                            
	Set repid=$I(^CacheTemp) 
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
 	
 	q:stdate="" $$$OK
	q:endate="" $$$OK
	q:endate<stdate $$$OK

    k ^temp($zn,$j) 
    
    q:'$d(^DHCCAACCOUNTMONTHS(stdate)) 
    s stmonObj=##class(dhc.ca.cache.data.AccountMonths).%OpenId(stdate)
    s stmonth=stmonObj.AccountMonthsname
    s enmonObj=##class(dhc.ca.cache.data.AccountMonths).%OpenId(endate)
    s enmonth=enmonObj.AccountMonthsname
   
    //****************************************************
    s setid=$o(^DHCCADEPTLEVELSETS(0,"Code","c001",0))      //depsetId:部门分层套中全成本分摊设置dr
    s depsetIdLc=$o(^DHCCADEPTLEVELSETS(0,"Code","d104",0)) //部门分层套中临床服务类科室dr
    s depsetIdDk=$o(^DHCCADEPTLEVELSETS(0,"Code","L101",0)) //部门分层套中临床大科分层dr
    s datsetId=$o(^DHCCADATALEVELSETS(0,"Code","f001",0))   //数据分层套中新会计制度报表dr
    //****************************************************

    s dept = ##class(dhc.ca.cache.udata.DoCostDist1).GetCurrentLayerDepts(depsetIdLc)
	s depts=##class(dhc.ca.cache.udata.uCostResultData).GetDepts(dept)  
  
    s len=$l(depts,",")
    f d=1:1:len d 
    .s distdept=$p(depts,",",d)
    .s i="",childSub=0
    .f i=stdate:1:endate d
    ..f  s childSub=$o(^DHCCACOSTDISTSETS(0,"DIntDistdept",setid,i,distdept,childSub)) q:childSub=""  d
    ...s RowId=setid_"||"_childSub
    ...s Obj=##class(dhc.ca.cache.data.CostResultData).%OpenId(RowId)
    ...s data=Obj.CostResultDataitemDr.%Id()            //成本项目
    ...s distFlag=Obj.CostResultDatadistFlag            //分摊标志
    ...s dataFee=Obj.CostResultDatafee                  //金额
    ...s ^temp($zn,$j,"CostResult",distdept,data,distFlag)=$g(^temp($zn,$j,"CostResult",units,distdept,data,distFlag))+dataFee

      s deptDr="" f  s deptDr=$o(^temp($zn,$j,"CostResult",deptDr)) q:deptDr=""  d
      .s itemDr="" f  s itemDr=$o(^temp($zn,$j,"CostResult",deptDr,itemDr)) q:itemDr=""  d 
      ..s distFlag=""  f  s distFlag=$o(^temp($zn,$j,"CostResult",deptDr,itemDr,distFlag)) q:distFlag=""  d 
      ...s sumdata=$g(^temp($zn,$j,"CostResult",deptDr,itemDr,distFlag))
      ...d OutputRow2
    k ^temp($zn,$j)        
   q $$$OK
	
OutputRow2
    //部门分层dr
    q:'$d(^DHCCAUNITDEPTS(deptDr))
    s deptCode=$p(^DHCCAUNITDEPTS(deptDr),"^",1)
    s deptName=$p(^DHCCAUNITDEPTS(deptDr),"^",2)
	s deplsDr=##class(dhc.ca.cache.udata.uDeptLevelSets).GetParRef(depsetIdDk,deptDr)     //科室所在分层dr
  	s deplsObj=##class(dhc.ca.cache.data.DeptLevelSets).%OpenId(deplsDr)
  	s deplsCode=deplsObj.DeptLevelSetscode,deplsName=deplsObj.DeptLevelSetsname
  	//数据分层
  	s datlsDr=##class(dhc.ca.cache.udata.uDataLevelSets).GetLevelItemsParRef(datsetId,itemDr) //50-新会计制度报表
  	s datlsObj=##class(dhc.ca.cache.data.DataLevelSets).%OpenId(datlsDr)
  	s datlsCode=datlsObj.DataLevelSetscode,datlsName=datlsObj.DataLevelSetsname
	
	s Data=$lb(stmonth,enmonth,deplsDr,deplsCode,deplsName,deptDr,deptCode,deptName,datlsDr,datlsCode,datlsName,itemDr,distFlag,$num(sumdata,2))
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetClinicaDepCostFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetClinicaDepCostExecute ]
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

ClassMethod GetClinicaDepCostClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetClinicaDepCostExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetClinicaDepCost(stdate As %String, endate As %String, units As %String) As %Query(ROWSPEC = "stmonth:%String,enmonth:%String,deplsDr:%Integer,deplsCode:%String,deplsName:%String,deptDr:%Integer,deptCode:%String,deptName:%String,datlsDr:%Integer,datlsCode:%String,datlsName:%String,itemDr:%Integer,distFlag:%String,sumdata:%Float") [ SqlProc ]
{
}

//新会计制度-临床科室全成本构成分析表

//d ##class(%ResultSet).RunQuery("web.RunqianQueryReport","GetCostGcXhj","1","1","1")

ClassMethod GetCostGcXhjExecute(ByRef qHandle As %Binary, stdate As %String, endate As %String, units As %String) As %Status
{
	Set repid=$I(^CacheTemp) 
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
 	
 	q:stdate="" $$$OK
	q:endate="" $$$OK
	q:units="" $$$OK
	q:stdate>endate $$$OK
   
    k ^temp($zn,$j)  
    
    //****************************************************
    s setid=$o(^DHCCADEPTLEVELSETS(0,"Code","c001",0))      //depsetId:部门分层套中全成本分摊设置dr
    s depsetIdLc=$o(^DHCCADEPTLEVELSETS(0,"Code","d104",0)) //部门分层套中临床服务类科室dr
    s depsetIdDk=$o(^DHCCADEPTLEVELSETS(0,"Code","L101",0)) //部门分层套中临床大科分层dr
    s datsetId=$o(^DHCCADATALEVELSETS(0,"Code","f001",0))   //数据分层套中新会计制度报表dr
    s mzrc=$o(^DHCCAALLDATAITEMS(0,"Code","mzrc",0))        //门诊人次
    s zycr=$o(^DHCCAALLDATAITEMS(0,"Code","zycr",0))        //住院床日数
    //****************************************************      
    q:'$d(^DHCCAACCOUNTMONTHS(stdate)) 
    s stmonObj=##class(dhc.ca.cache.data.AccountMonths).%OpenId(stdate)
    s stmonth=stmonObj.AccountMonthsname
    s enmonObj=##class(dhc.ca.cache.data.AccountMonths).%OpenId(endate)
    s enmonth=enmonObj.AccountMonthsname
    s dept = ##class(dhc.ca.cache.udata.DoCostDist1).GetCurrentLayerDepts(depsetIdLc)
	s depts=##class(dhc.ca.cache.udata.uCostResultData).GetDepts(dept)  
    s RowIdI="",RowIdP="",childsub=0
    s len=$l(depts,",")
    f i=1:1:len d 
    .s locdr=$p(depts,",",i) //查询科室
    .s unitrid=$p(^DHCCAUNITDEPTS(locdr),"^",8) //科室所属单位类别
    .;q:units'[unitrid
    .f i1=stdate:1:endate d
    
    ..f  s RowIdI=$o(^DHCCAINCOMEDATAS(0,"IntervalPatdeptdr",i1,locdr,RowIdI)) q:RowIdI=""  d
    ...s incomeObj=##class(dhc.ca.cache.data.IncomeDatas).%OpenId(RowIdI)
    ...s itemDr=incomeObj.IncomeDatasitemDr.%Id()  //.%Id()                  //收费项目dr
    
    ...s fee=incomeObj.IncomeDatasfee 
    ...s ^temp($zn,$j,locdr,"income",itemDr)=$g(^temp($zn,$j,locdr,"income",itemDr))+fee
    
    ..f  s RowIdP=$o(^DHCCAPARAMDATAS(0,"IntervalSereddep",i1,locdr,RowIdP)) q:RowIdP=""  d
    ...s paramObj=##class(dhc.ca.cache.data.ParamDatas).%OpenId(RowIdP)
    ...s itemDr=paramObj.ParamDatasitemDr.%Id() q:(itemDr'=mzrc)&(itemDr'=zycr)  //门诊人次、住院床日
    ...s data=paramObj.ParamDatasvalue
    ...s ^temp($zn,$j,locdr,"param",itemDr)=$g(^temp($zn,$j,"param",itemDr))+data
             
    ..f  s childsub=$o(^DHCCACOSTDISTSETS(0,"DIntDistdept",unitrid,i1,locdr,childsub)) q:childsub=""  d
    ...s RowIdC=unitrid_"||"_childsub 
    ...s costObj=##class(dhc.ca.cache.data.CostResultData).%OpenId(RowIdC)
    ...s itemDr=costObj.CostResultDataitemDr.%Id()
    ...s datafee=costObj.CostResultDatafee
    ...s ^temp($zn,$j,locdr,"cost",itemDr)=$g(^temp($zn,$j,locdr,"cost",itemDr))+datafee
    
    
        
   s locdr=0 f  s locdr=$o(^temp($zn,$j,locdr)) q:locdr=""  d 
   .s type=0  f  s type=$o(^temp($zn,$j,locdr,type)) q:type=""  d 
   ..s itemdr=0 f  s itemdr=$o(^temp($zn,$j,locdr,type,itemdr)) q:itemdr=""  d 
   ...s fee=$g(^temp($zn,$j,locdr,type,itemdr))
   ...d OutputRow3
    k ^temp($zn,$j)
    q $$$OK
 
OutputRow3
    
    
    //部门分层dr
    q:'$d(^DHCCAUNITDEPTS(locdr))
    s deptCode=$p(^DHCCAUNITDEPTS(locdr),"^",1)
    s deptName=$p(^DHCCAUNITDEPTS(locdr),"^",2)
	s deplsDr=##class(dhc.ca.cache.udata.uDeptLevelSets).GetParRef(depsetIdDk,locdr)     
  	s deplsObj=##class(dhc.ca.cache.data.DeptLevelSets).%OpenId(deplsDr)
  	s deplsCode=deplsObj.DeptLevelSetscode,deplsName=deplsObj.DeptLevelSetsname
  	//数据分层
  	s datlsDr=##class(dhc.ca.cache.udata.uDataLevelSets).GetLevelItemsParRef(datsetId,itemdr) 
  	s datlsObj=##class(dhc.ca.cache.data.DataLevelSets).%OpenId(datlsDr)
  	s datlsCode=datlsObj.DataLevelSetscode,datlsName=datlsObj.DataLevelSetsname
  	s itemObj=##class(dhc.ca.cache.data.AllDataItems).%OpenId(itemdr)
  	s itemCode=itemObj.AllDataItemscode

    
    
  	s Data=$lb(stmonth,enmonth,deplsDr,deplsCode,deplsName,locdr,deptCode,deptName,type,datlsDr,datlsCode,datlsName,itemdr,itemCode,$fn($g(fee),"",2))
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
}

ClassMethod GetCostGcXhjFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCostGcXhjExecute ]
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

ClassMethod GetCostGcXhjClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCostGcXhjExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetCostGcXhj(stdate As %String, endate As %String, units As %String) As %Query(ROWSPEC = "stmonth:%String,enmonth:%String,deplsDr:%Integer,deplsCode:%String,deplsName:%String,locdr:%Integer,deptCode:%String,deptName:%String,type:%String,datlsDr:%Integer,datlsCode:%String,datlsName:%String,itemdr:%Integer,itemCode:%String,fee:%Float") [ SqlProc ]
{
}

//d ##class(%ResultSet).RunQuery("web.RunqianQueryReport","MedDepartMentIncome",1,1,10,38,"O")

ClassMethod MedDepartMentIncomeExecute(ByRef qHandle As %Binary, stdate As %String, endate As %String, deptPar As %String, itemPar As %String, pattype As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	q:(stdate="")||(endate="")||(stdate>endate) $$$OK
	q:'$d(^DHCCAACCOUNTMONTHS(stdate)) $$$OK
	q:'$d(^DHCCAACCOUNTMONTHS(endate)) $$$OK
	q:(deptPar="") $$$OK
	k ^TEMPDHCCAHS("dhcahs",$j)
	s (rowid,rowidTJ,locs,itms,itmsTJ,start,end,startMonth,endMonth,month)=""
	s locs=$$GetHisDepts^HERPBONUSCOMMON(stdate,endate,deptPar)
	s itms=$$GetHisItems^HERPBONUSCOMMON(itemPar,"his")
	s itmsTJ=$$GetHisItems^HERPBONUSCOMMON(itemPar,"TTJ")
	s itmsTJ2=$$GetHisItems^HERPBONUSCOMMON(itemPar,"ARC")
	s start=$p(^DHCCAACCOUNTMONTHS(stdate),"^",4)
	s end=$p(^DHCCAACCOUNTMONTHS(endate),"^",5)
	s startMonth=$p(^DHCCAACCOUNTMONTHS(stdate),"^",2)
	s endMonth=$p(^DHCCAACCOUNTMONTHS(endate),"^",2)
	s len=$LL(locs)
	;门急诊/住院/收入
	i pattype'["H" d
	.f i=1:1:len  d 
	..s loc=$LIST(locs,i)
	..f date=start:1:end  d 
	...f  s rowid=$o(^DHCWorkLoad(0,"ORDDATERESDEP",date,loc,rowid)) q:rowid=""  d 
	....s type=$p(^DHCWorkLoad(rowid),"^",4)                         //病人类型
	....q:type="H"                          
	....q:(pattype'="")&&(pattype'[type)
	....s TarEcDr=$p(^DHCWorkLoad(rowid),"^",41)                      //核算子类dr	
	....q:(itms'="")&&($LF(itms,TarEcDr)=0)
	....s itemord=$p(^DHCWorkLoad(rowid),"^",2)                       //医嘱项dr
	....s arcinfo=$$GetArcInfoByDr^HERPBONUSCOMMON(itemord)           //医嘱项信息
	....s arcCode=$p(arcinfo,"^",1)                                   //医嘱项代码
	....s arcDesc=$p(arcinfo,"^",2)                                   //医嘱项名称
    ....s fee=$p(^DHCWorkLoad(rowid),"^",16)
    ....s locName=$p(^CTLOC(loc),"^",2)
    ....s tarEcName=$p(^DHCTarC("EC",TarEcDr),"^",2)
    ....s ^TEMPDHCCAHS("dhcahs",$j,loc,locName,TarEcDr,tarEcName,arcCode,arcDesc,type)=$g(^TEMPDHCCAHS("dhcahs",$j,loc,locName,TarEcDr,tarEcName,arcCode,arcDesc,type))+fee
    ;体检一科收入明细
    i pattype="H" d
    .f  s month=$o(^dhcbsBonusTJDataI("TJDate",month)) q:month=""  d 
    ..q:((startMonth]month)||(month]endMonth))
    ..f  s rowidTJ=$o(^dhcbsBonusTJDataI("TJDate",month,rowidTJ)) q:rowidTJ=""  d 
    ...s RecDep=$LIST(^dhcbsBonusTJDataD(rowidTJ),6)
    ...s RecDepName=$LIST(^dhcbsBonusTJDataD(rowidTJ),7)
    ...s itemtype=$LIST(^dhcbsBonusTJDataD(rowidTJ),3)
    ...q:(itmsTJ'="")&&($LF(itmsTJ,itemtype)=0)
    ...s itemtypename=$LIST(^dhcbsBonusTJDataD(rowidTJ),10)
    ...s arcCode=$LIST(^dhcbsBonusTJDataD(rowidTJ),2)
    ...s arcDesc=$LIST(^dhcbsBonusTJDataD(rowidTJ),9)
    ...s fee=$LIST(^dhcbsBonusTJDataD(rowidTJ),5)
    ...s ^TEMPDHCCAHS("dhcahs",$j,RecDep,RecDepName,itemtype,itemtypename,arcCode,arcDesc,"H")=$g(^TEMPDHCCAHS("dhcahs",$j,RecDep,RecDepName,itemtype,itemtypename,arcCode,arcDesc,"H"))+fee
    ;体检二科收入明细
    if (pattype="H2") 
    {
    s stdate=$zd(start,3)
	s endate=$zd(end,3)
	s rs=##class(%Library.ResultSet).%New()
	s rs.ClassName="web.DHCPE.ItemDetailRecord"
	s rs.QueryName="FindItemDetail"
	d rs.Execute(stdate,endate,"","","")
     
	while(rs.Next())
	{
	 s fdeptDr=rs.Data("OrderDepart")
	 s fdeptDesc=rs.Data("DepartDesc")
	 s RecDep=rs.Data("RecLoc")
	 s RecDepDesc=rs.Data("LocDesc")
	 s ArcItem=rs.Data("ArcItem")
	 s iteminfo=$$GetArcInfoByDr^HERPBONUSCOMMON(ArcItem)
	 s arccat=$p(iteminfo,"^",3)
	 s arccatname=$p(iteminfo,"^",4)
	 i (itmsTJ2'="")&&($LF(itmsTJ2,arccat)=0) continue 
	 s arccode=$p(iteminfo,"^",1)
	 s arcname=$p(iteminfo,"^",2)
	 
	 s price=rs.Data("Acount")
	 s account=rs.Data("ItemCount")
	 s fee=$num(price*account,2)
	 s ^TEMPDHCCAHS("dhcahs",$j,RecDep,RecDepDesc,arccat,arccatname,arccode,arcname,"H")=$g(^TEMPDHCCAHS("dhcahs",$j,RecDep,RecDepDesc,arccat,arccatname,arccode,arcname,"H"))+fee	

	}
   }
    
    s loc="" f  s loc=$o(^TEMPDHCCAHS("dhcahs",$j,loc)) q:loc=""  d 
	.s locName="" f  s locName=$o(^TEMPDHCCAHS("dhcahs",$j,loc,locName)) q:locName=""  d 
	..s tarEcdr="" f  s tarEcdr=$o(^TEMPDHCCAHS("dhcahs",$j,loc,locName,tarEcdr)) q:tarEcdr=""  d 
	...s tarEcName=""  f  s tarEcName=$o(^TEMPDHCCAHS("dhcahs",$j,loc,locName,tarEcdr,tarEcName)) q:tarEcName=""  d 
	....s arccode="" f  s arccode=$o(^TEMPDHCCAHS("dhcahs",$j,loc,locName,tarEcdr,tarEcName,arccode)) q:arccode=""  d 
	.....s arcname="" f  s arcname=$o(^TEMPDHCCAHS("dhcahs",$j,loc,locName,tarEcdr,tarEcName,arccode,arcname)) q:arcname=""  d 
	......s type="" f  s type=$o(^TEMPDHCCAHS("dhcahs",$j,loc,locName,tarEcdr,tarEcName,arccode,arcname,type)) q:type=""  d 
	.......s fee=$g(^TEMPDHCCAHS("dhcahs",$j,loc,locName,tarEcdr,tarEcName,arccode,arcname,type))
	.......d OutputRow4
	k ^TEMPDHCCAHS("dhcahs",$j)
   
 	k ^temp($j)
 	;输出合计
 	;d OutputRowWorkSum
 	q $$$OK	
  	
OutputRow4
    s pre=$case(pattype,"H":"TTJ","H2":"ARC",:"his")
    s code=pre_tarEcdr
    s datafc=$$GetDataFc^HERPBONUSCOMMON(34,code)
    w pre_"^"_code_"^"_datafc_"^"
    s datafcName=$p(^DHCCADATALEVELSETS(datafc),"^",2)
  
  	s Data=$lb(datafc,datafcName,loc,locName,tarEcdr,tarEcName,arccode,arcname,type,fee)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod MedDepartMentIncomeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MedDepartMentIncomeExecute ]
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

ClassMethod MedDepartMentIncomeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MedDepartMentIncomeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query MedDepartMentIncome(stdate As %String, endate As %String, deptPar As %String, itemPar As %String, pattype As %String) As %Query(ROWSPEC = "datafc:%Integer,datafcName:%String,loc:%Integer,locName:%String,tarEcdr:%Integer,tarEcName:%String,arccode:%String,arcname:%String,type:%String,fee:%Float") [ SqlProc ]
{
}

//全院收入成本明细表query

//d ##class(%ResultSet).RunQuery("web.RunqianQueryReport","GetIncomeAndVouchdatas",4,1)

ClassMethod GetIncomeAndVouchdatasExecute(ByRef qHandle As %Binary, endate As %String, units As %String) As %Status
{
	Set repid=$I(^CacheTemp) 
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
 	
	q:endate="" $$$OK
	q:units="" $$$OK
	k ^TEMPDHCCAHS("dhcahs") 
	s year=$p($p(^DHCCAACCOUNTMONTHS(endate),"^",2),"-",1)
	s stmonth=year_"-01"
	s stdate=$o(^DHCCAACCOUNTMONTHS(0,"Name",stmonth,""))
	q:stdate=""
	s child=""

	s jqendate=$$Getqntq^HERPBONUSCOMMON(endate)
	s jqstdate=$$Getqntq^HERPBONUSCOMMON(stdate)


	s result0=..BuildIncomeDatas(stdate,endate,"bq") ;本期数据生成；

	s result1=..BuildIncomeDatas(jqstdate,jqendate,"qntq") ;去年同期数据生成 
	
	s result2=..BuildVouchDatas(stdate,endate,"bq") ;本期数据生成
    s result3=..BuildVouchDatas(jqstdate,jqendate,"qntq") ;去年同期数据生成 

     s flag="" f  s flag=$o(^TEMPDHCCAHS("dhcahs",$j,flag)) q:flag=""  d 
     .s type="" f  s type=$o(^TEMPDHCCAHS("dhcahs",$j,flag,type)) q:type=""  d 
     ..s period="" f  s period=$o(^TEMPDHCCAHS("dhcahs",$j,flag,type,period)) q:period=""  d 
     ...s fcorder="" f  s fcorder=$o(^TEMPDHCCAHS("dhcahs",$j,flag,type,period,fcorder)) q:fcorder=""  d 
     ....s fcname="" f  s fcname=$o(^TEMPDHCCAHS("dhcahs",$j,flag,type,period,fcorder,fcname)) q:fcname=""  d 
     .....s fee=$g(^TEMPDHCCAHS("dhcahs",$j,flag,type,period,fcorder,fcname))
     .....d OutputRow5   
    k ^TEMPDHCCAHS("dhcahs") 
    q $$$OK
OutputRow5
    s fcname=$case(fcname,"glks":"管理费用","yfks":"医疗辅助成本","yjks":"医疗技术成本","lcks":"临床服务成本",:fcname)
  	s Data=$lb(flag,type,fcorder,fcname,period,fee)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
}

ClassMethod GetIncomeAndVouchdatasFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetIncomeAndVouchdatasExecute ]
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

ClassMethod GetIncomeAndVouchdatasClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetIncomeAndVouchdatasExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetIncomeAndVouchdatas(endate As %String, units As %String) As %Query(ROWSPEC = "flag:%Integer,type:%String,fcorder:%Integer,fcname:%String,period:%String,fee:%Float") [ SqlProc ]
{
}

//d ##class(%ResultSet).RunQuery("web.RunqianQueryReport","GetMeterialDetail","2014-01","2014-01","10301")

ClassMethod GetMeterialDetailExecute(ByRef qHandle As %Binary, stdate As %String, endate As %String, itemcode As %String) As %Status
{
	Set repid=$I(^CacheTemp) 
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
	q:stdate="" $$$OK
	q:endate="" $$$OK
	k ^TEMPDHCCAHS("dhcahs")
	
	s monthstart=$o(^DHCCAACCOUNTMONTHS(0,"Name",stdate,""))
	s monthend=$o(^DHCCAACCOUNTMONTHS(0,"Name",endate,""))
    s startday=$p(^DHCCAACCOUNTMONTHS(monthstart),"^",4) ;起始月的起始日期
    s endday=$p(^DHCCAACCOUNTMONTHS(monthend),"^",5)     ;截止月的截止日期
	

	s result0=..BuildMeterila(startday,endday,"T")       ;物资出库明细数据[转出] 
	s result0=..BuildMeterila(startday,endday,"K")                ;[转入]
	s result1=..GetWorkLoadDatas(startday,endday)
   B
    s date="" f  s date=$o(^TEMPDHCCAHS("dhcahs",$j,date)) q:date=""  d 
    .s loc="" f  s loc=$o(^TEMPDHCCAHS("dhcahs",$j,date,loc)) q:loc=""  d 
    ..s stkcate="" f  s stkcate=$o(^TEMPDHCCAHS("dhcahs",$j,date,loc,stkcate)) q:stkcate=""  d 
    ...s inci="" f  s inci=$o(^TEMPDHCCAHS("dhcahs",$j,date,loc,stkcate,inci)) q:inci=""  d 
    ....s data=$g(^TEMPDHCCAHS("dhcahs",$j,date,loc,stkcate,inci))
    ....s account=$p(data,"^",1)
    ....s price=$p(data,"^",2)
    ....s cost=$p(data,"^",3)
    ....d OutputRow6   
    k ^TEMPDHCCAHS("dhcahs") 
    q $$$OK
OutputRow6
  	
  	 s stkcatCode=$p(^INC("SC",stkcate),"^",1)      //库存分类代码
  	 s itmcode=$$GetInitem^HERPBONUSCOMMON("WZYP"_stkcatCode)
  	 q:(itemcode'="")&&(itmcode'=itemcode)
     s stkcatDesc=$p(^INC("SC",stkcate),"^",2)      //库存分类名称 
  	 s incitmcode=$p(^INCI(inci,1),"^",1)
     s incitmname=$p(^INCI(inci,1),"^",2)
     s locname=$p(^CTLOC(loc),"^",2)
     i locname["-" s locname=$p(locname,"-",2)
     s day=$zd(date,3)
  	s Data=$lb(day,loc,locname,stkcatCode,stkcatDesc,incitmcode,incitmname,account,price,cost)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
}

ClassMethod GetMeterialDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMeterialDetailExecute ]
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

ClassMethod GetMeterialDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMeterialDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetMeterialDetail(stdate As %String, endate As %String, itemcode As %String) As %Query(ROWSPEC = "day:%String,loc:%Integer,locname,stkcatCode:%String,stkcatDesc:%String,incitmcode:%String,incitmname:%String,account:%Float,price:%Float,cost:%Float") [ SqlProc ]
{
}

//取医院

Query GetHostpital() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
 SELECT UnitTypes_name FROM dhc_ca_cache_data.Unittypes where %id>0
}

// 取院区

Query GetUnits() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
 select units_rowid,units_name from dhc_ca_cache_data.units where %id between 1 and 4 and units_active='Y'
}

//收入数据生成

ClassMethod BuildIncomeDatas(stdate, endate, accper) As %Integer
{
	q:((stdate="")||(endate="")||(stdate>endate)) ""
	s fee=0 ,sumfee=0

    f date=stdate:1:endate  d
	.s rowid=""  f  s rowid=$o(^DHCCAINCOMEDATAS(0,"Interval",date,rowid)) q:rowid=""  d 
	..s Inobj=##class(dhc.ca.cache.data.IncomeDatas).%OpenId(rowid)
	..s pattype=Inobj.IncomeDataspatType
	..s itemDr=Inobj.IncomeDatasitemDr.%Id()
	..s sumfee=Inobj.IncomeDatasfee
	..i date=endate  s fee=sumfee
	..e  s fee=0
	..s datafc=$$GetDataFc2^HERPBONUSCOMMON(3,itemDr)
	..q:datafc=""
	..s datafcorder=$p(^DHCCADATALEVELSETS(datafc),"^",8)
    ..s datafcname=$p(^DHCCADATALEVELSETS(datafc),"^",2)
	..;本年累计
	..s ^TEMPDHCCAHS("dhcahs",$j,1,pattype,accper,datafcorder,datafcname)=$g(^TEMPDHCCAHS("dhcahs",$j,1,pattype,accper,datafcorder,datafcname))+sumfee
	..;本月
	..s ^TEMPDHCCAHS("dhcahs",$j,2,pattype,accper,datafcorder,datafcname)=$g(^TEMPDHCCAHS("dhcahs",$j,2,pattype,accper,datafcorder,datafcname))+fee	
 q 0
}

//成本数据生成

ClassMethod BuildVouchDatas(stdate, endate, accper) As %Integer
{
	q:((stdate="")||(endate="")||(stdate>endate)) ""
	s fee=0 ,sumfee=0
	f date=stdate:1:endate  d 
	.s rowid="" f  s rowid=$o(^DHCCAVOUCHDATAS(0,"Interval",date,rowid)) q:rowid=""  d 
	..s Vobj=##class(dhc.ca.cache.data.VouchDatas).%OpenId(rowid)
	..s deptDr=Vobj.VouchDatasdeptDr.%Id()
	..s itemDr=Vobj.VouchDatasitemDr.%Id()
	..s sumfee=Vobj.VouchDatasdebit
	..i date=endate s fee=sumfee
	..e  s fee=0
	..s datafc=$$GetDataFc2^HERPBONUSCOMMON(5,itemDr) //项目分层
	..q:datafc=""
	..s datafcorder=$p(^DHCCADATALEVELSETS(datafc),"^",8)
	..s deptfc=$$GetDeptFc2^HERPBONUSCOMMON(1,deptDr) //数据分层
    ..s deptfcremark=$p(^DHCCADEPTLEVELSETS(deptfc),"^",4)
    ..s datafcname=$p(^DHCCADATALEVELSETS(datafc),"^",2)
    ..;按性质分类
    ..s ^TEMPDHCCAHS("dhcahs",$j,1,"x",accper,datafcorder,datafcname)=$g(^TEMPDHCCAHS("dhcahs",$j,1,"x",accper,datafcorder,datafcname))+sumfee
    ..s ^TEMPDHCCAHS("dhcahs",$j,2,"x",accper,datafcorder,datafcname)=$g(^TEMPDHCCAHS("dhcahs",$j,2,"x",accper,datafcorder,datafcname))+fee
    ..;按功能分类
    ..s ^TEMPDHCCAHS("dhcahs",$j,1,"g",accper,deptfc,deptfcremark)=$g(^TEMPDHCCAHS("dhcahs",$j,1,"g",accper,deptfc,deptfcremark))+sumfee
    ..s ^TEMPDHCCAHS("dhcahs",$j,2,"g",accper,deptfc,deptfcremark)=$g(^TEMPDHCCAHS("dhcahs",$j,2,"g",accper,deptfc,deptfcremark))+fee

  q 0
}

//w ##class(web.RunqianQueryReport).BuildMeterila("2014-04-01",2014-04-05","T")

/// 药品和物资消耗
/// w ##class(web.RunqianQueryReport).GetWorkLoadDatas(63188,63218)
ClassMethod GetWorkLoadDatas(stdate, endate) As %Integer
{
	q:((stdate="")||(endate="")||(stdate>endate)) ""
	s totalrp=0
    f date=stdate:1:endate  d
	.s rowid="" f  s rowid=$o(^DHCWorkLoad(0,"ORDDATE",date,rowid)) q:rowid=""  d 
	..s ItmMastdr=$p(^DHCWorkLoad(rowid),"^",2) 
	..s arcinfo=$$GetArcInfoByDr^HERPBONUSCOMMON(ItmMastdr)
	..s catdesc=$p(arcinfo,"^",4)
    ..q:catdesc'["材料"
	..s stkcate=$P(arcinfo,"^",7)
	..i stkcate="" s stkcate="999"
	..s inci=$p(arcinfo,"^",8)
	..i inci=""  s inci="999"
	..s incitmcode=$p(^INCI(inci,1),"^",1)
    ..s incitmname=$p(^INCI(inci,1),"^",2) 
	..s orddr=$p(^DHCWorkLoad(rowid),"^",21)  
	..s Counts=$p(^DHCWorkLoad(rowid),"^",15)             ;医嘱次数
	..s fee=$p(^DHCWorkLoad(rowid),"^",16) 
	..s UnitDR=$p(^OEORD(+orddr,"I",$p(orddr,"||",2),2),"^",3)   //单位
    ..s ItmRp=$$GetItmRp^DHCWLInPutCAData(ItmMastdr,date,UnitDR)
    ..s totalrp=$fn(ItmRp*Counts,"",2)
    ..s loc=$p(^DHCWorkLoad(rowid),"^",3) 
    ..i $d(^TEMPDHCCAHS("dhcahs",$j,date,loc,incitmcode,incitmname))  d 
    ...s $p(^TEMPDHCCAHS("dhcahs",$j,date,loc,incitmcode,incitmname),"^",4)=$p(^TEMPDHCCAHS("dhcahs",$j,date,loc,incitmcode,incitmname),"^",4)+Counts
    ...s $p(^TEMPDHCCAHS("dhcahs",$j,date,loc,incitmcode,incitmname),"^",5)=ItmRp
    ...s $p(^TEMPDHCCAHS("dhcahs",$j,date,loc,incitmcode,incitmname),"^",6)=$p(^TEMPDHCCAHS("dhcahs",$j,date,loc,incitmcode,incitmname),"^",6)+totalrp
    ...s $p(^TEMPDHCCAHS("dhcahs",$j,date,loc,incitmcode,incitmname),"^",7)=$p(^TEMPDHCCAHS("dhcahs",$j,date,loc,incitmcode,incitmname),"^",7)+fee
    ..e   d 
    ...s $p(^TEMPDHCCAHS("dhcahs",$j,date,loc,incitmcode,incitmname),"^",4)=Counts
    ...s $p(^TEMPDHCCAHS("dhcahs",$j,date,loc,incitmcode,incitmname),"^",5)=ItmRp
    ...s $p(^TEMPDHCCAHS("dhcahs",$j,date,loc,incitmcode,incitmname),"^",6)=totalrp
    ...s $p(^TEMPDHCCAHS("dhcahs",$j,date,loc,incitmcode,incitmname),"^",7)=fee
    
 
 q 0
}

//物资出库信息汇总数据生成

/// w ##class(web.RunqianQueryReport).BuildMeterila(63188,63218,"T")
ClassMethod BuildMeterila(stdate, endate, type) As %Integer
{
  ;s stdate=$zdh(stdate,3)
  ;s endate=$zdh(endate,3)
  s num=0
  ;廊坊管道局库房科室列表
  s locstr=$LB(73,471,537,198,188)
  f date=stdate:1:endate d 
  .s intr="" f  s intr=$o(^DHCINTR(0,"TypeDate",type,date,intr)) q:intr=""  d
  ..s phdicrowid=$P(^DHCINTR(intr),"^",9)	       //DHC_PHDISITMCLB表RowID
  ..S phd=$P(phdicrowid,"||",1)
  ..s phdisub=$P(phdicrowid,"||",2)
  ..i type="T" d
  ...s locdr=$p(^DHCINIT(phd),"^",6)	    ;请求科室(转出时)
  ...s frlocdr=$p(^DHCINIT(phd),"^",5)	    ;供应科室
  ..i type="K" d
  ...s locdr=$p(^DHCINIT(phd),"^",5)	          //请求科室(转入时)
  ...s frlocdr=$p(^DHCINIT(phd),"^",6)	          //供应科室
  ..;请求科室在库房科室列表或者供应科室不在库房科室列表则退出  
  ..q:($LF(locstr,locdr)'=0)||($LF(locstr,frlocdr)=0)
  ..s inci=$p(^DHCINTR(intr),"^",15)              //库存项dr
  ..s incitmcode=$p(^INCI(inci,1),"^",1)
  ..s incitmname=$p(^INCI(inci,1),"^",2)
  ..s stkcate=$p(^INCI(inci,2),"^",2)	          //库存分类rowid
  ..zn "dhc-data"
  ..s tmpstkgrp=$$GetStkGrp^DHCHSCommon(stkcate)
  ..zn "dhc-app"
  ..;过滤掉药库转给药房的数据(保留科室直接从药库领用的药品)
  ..q:(tmpstkgrp["药")&&((locname["药房")||(locname'["药房"))
  ..;s stkcatCode=$p(^INC("SC",stkcate),"^",1)      //库存分类代码
  ..;s stkcatDesc=$p(^INC("SC",stkcate),"^",2)      //库存分类名称
  ..s qty=-$p(^DHCINTR(intr),"^",6)                //转移数量
  ..S truom=$p(^DHCINTR(intr),"^",10)              //药品单位
  ..s pakuom=$p(^INCI(inci,1),"^",10)              //库存项单位
  ..zn "dhc-data"
  ..s fac=$$UOMFac^DHCSTCOMMONSRV(truom,pakuom)
  ..zn "dhc-app"
  ..s:fac'=0 qty=qty*fac
  ..s inclb=$p(^DHCINTR(intr),"^",7)
  ..zn "dhc-data"
  ..s Rp=$$LastInPrice^DHCSTPRICE(inclb,"")        //批次进价
  ..zn "dhc-app"
  ..s RpAmt=qty*Rp 
  ..q:(RpAmt=0)||(RpAmt="")	
  ..i $d(^TEMPDHCCAHS("dhcahs",$j,date,locdr,incitmcode,incitmname)) d 
  ...s $p(^TEMPDHCCAHS("dhcahs",$j,date,locdr,incitmcode,incitmname),"^",1)=$p(^TEMPDHCCAHS("dhcahs",$j,date,locdr,incitmcode,incitmname),"^",1)+qty
  ...s $p(^TEMPDHCCAHS("dhcahs",$j,date,locdr,incitmcode,incitmname),"^",2)=Rp
  ...s $p(^TEMPDHCCAHS("dhcahs",$j,date,locdr,incitmcode,incitmname),"^",3)=$p(^TEMPDHCCAHS("dhcahs",$j,date,locdr,incitmcode,incitmname),"^",3)+RpAmt
  ..e  d
  ...s ^TEMPDHCCAHS("dhcahs",$j,date,locdr,incitmcode,incitmname)=qty_"^"_Rp_"^"_RpAmt
  q 0
}

//d ##class(%ResultSet).RunQuery("web.RunqianQueryReport","GetDeptsDirectCost1","2","2",1)

ClassMethod GetDeptsDirectCost1Execute(ByRef qHandle As %Binary, stdate As %String, endate As %String, units As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	q:stdate="" $$$OK
    q:endate="" $$$OK
    q:stdate>endate $$$OK
    k ^temp($zn,$j)
    s Rowid="" ,num=0
    //****************************************************
    //depsetId:部门分层套中全成本分摊设置dr
    s depsetId=$o(^DHCCADEPTLEVELSETS(0,"Code","c001",0))
    //部门分层套中临床服务类科室dr
    s depsetIdLc=$o(^DHCCADEPTLEVELSETS(0,"Code","d104",0))
    //部门分层套中临床大科分层dr
    s depsetIdDk=$o(^DHCCADEPTLEVELSETS(0,"Code","L101",0))
    //数据分层套中新会计制度报表dr
    s datsetId=$o(^DHCCADATALEVELSETS(0,"Code","f002",0))
    //****************************************************
    s stMonObj=##class(dhc.ca.cache.data.AccountMonths).%OpenId(stdate)
    s stName=stMonObj.AccountMonthsname
    s enMonObj=##class(dhc.ca.cache.data.AccountMonths).%OpenId(endate)
    s enName=enMonObj.AccountMonthsname
 	f i=stdate:1:endate  d
 	.f  s Rowid=$o(^DHCCAVOUCHDATAS(0,"Interval",i,Rowid)) q:Rowid=""  d  
 	..s VouchObj=##class(dhc.ca.cache.data.VouchDatas).%OpenId(Rowid)
 	..s DeptDr=VouchObj.VouchDatasdeptDr.%Id()
 	..s unitObj=##class(dhc.ca.cache.data.UnitDepts).%OpenId(DeptDr)
 	..s unitDr=unitObj.UnitDeptsunitDr.%Id()
 	..q:units'[unitDr
 	..s itemDr=VouchObj.VouchDatasitemDr.%Id()

    ..s debit=VouchObj.VouchDatasdebit
    ..s ^temp($zn,$j,"dhchs",unitDr,DeptDr,itemDr)=$g(^temp($zn,$j,"dhchs",unitDr,DeptDr,itemDr))+debit

    s unitDr="" f  s unitDr=$o(^temp($zn,$j,"dhchs",unitDr)) q:unitDr=""  d 
    .s deptDr="" f  s deptDr=$o(^temp($zn,$j,"dhchs",unitDr,deptDr)) q:deptDr=""  d 
    ..s itemDr="" f  s itemDr=$o(^temp($zn,$j,"dhchs",unitDr,deptDr,itemDr)) q:itemDr=""  d 
    ...s debit=$g(^temp($zn,$j,"dhchs",unitDr,deptDr,itemDr))
    ...d OutputRow1
    k ^temp($zn,$j)
 
 	q $$$OK	
  	
OutputRow1
    
    //部门分层dr
    q:'$d(^DHCCAUNITDEPTS(deptDr))
    s deptCode=$p(^DHCCAUNITDEPTS(deptDr),"^",1)
    s deptName=$p(^DHCCAUNITDEPTS(deptDr),"^",2)
    
	i $d(^DHCCADEPTLEVELSETS(0,"Dept",depsetIdLc,deptDr)) s deptPar=depsetIdDk 
	e  s deptPar=depsetId   
	s deplsDr=##class(dhc.ca.cache.udata.uDeptLevelSets).GetParRef(deptPar,deptDr)     
  	s deplsObj=##class(dhc.ca.cache.data.DeptLevelSets).%OpenId(deplsDr)
  	s deplsRemark=deplsObj.DeptLevelSetsremark,deplsName=deplsObj.DeptLevelSetsname,deplsCode=deplsObj.DeptLevelSetscode
  	//数据分层
  	s datlsDr=##class(dhc.ca.cache.udata.uDataLevelSets).GetLevelItemsParRef(datsetId,itemDr) 
  	s datlsObj=##class(dhc.ca.cache.data.DataLevelSets).%OpenId(datlsDr)
  	s datlsCode=datlsObj.DataLevelSetscode,datlsName=datlsObj.DataLevelSetsname
  	// 数据项
  	q:'$d(^DHCCAALLDATAITEMS(itemDr))
  	s itemcode =$p(^DHCCAALLDATAITEMS(itemDr),"^",2)
  	s itemname =$p(^DHCCAALLDATAITEMS(itemDr),"^",3)
  	
  	
  	s Data=$lb(stName,enName,unitDr,deplsDr,deplsCode,deplsRemark,deplsName,deptDr,deptCode,deptName,datlsDr,datlsCode,datlsName,itemDr,itemcode,itemname,$num(debit,2))

    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
 	
	q
}

ClassMethod GetDeptsDirectCost1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDeptsDirectCostExecute ]
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

ClassMethod GetDeptsDirectCost1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDeptsDirectCostExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetDeptsDirectCost1(stdate As %String, endate As %String, units As %String) As %Query(ROWSPEC = "stName:%String,enName:%String,unitDr:%Integer,deplsDr:%Integer,deplsCode:%String,deplsRemark:%String,deplsName:%String,deptDr:%Integer,deptCode:%String,deptName:%String,datlsDr:%Integer,datlsCode:%String,datlsName:%String,itemDr:%Integer,itemcode:%String,itemname:%String,debit:%Float") [ SqlProc ]
{
}

//d ##class(%ResultSet).RunQuery("web.RunqianQueryReport","GetDeptsDirectCost2","2","2",1)

ClassMethod GetDeptsDirectCost2Execute(ByRef qHandle As %Binary, stdate As %String, endate As %String, units As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	q:stdate="" $$$OK
    q:endate="" $$$OK
    q:stdate>endate $$$OK
    k ^temp($zn,$j)
    s Rowid="" ,num=0
    //****************************************************
    //depsetId:部门分层套中全成本分摊设置dr
    s depsetId=$o(^DHCCADEPTLEVELSETS(0,"Code","c001",0))
    //部门分层套中临床服务类科室dr
    s depsetIdLc=$o(^DHCCADEPTLEVELSETS(0,"Code","d104",0))
    //部门分层套中临床大科分层dr
    s depsetIdDk=$o(^DHCCADEPTLEVELSETS(0,"Code","L101",0))
    //数据分层套中新会计制度报表dr
    s datsetId=$o(^DHCCADATALEVELSETS(0,"Code","f003",0))
    //****************************************************
    s stMonObj=##class(dhc.ca.cache.data.AccountMonths).%OpenId(stdate)
    s stName=stMonObj.AccountMonthsname
    s enMonObj=##class(dhc.ca.cache.data.AccountMonths).%OpenId(endate)
    s enName=enMonObj.AccountMonthsname
 	f i=stdate:1:endate  d
 	.f  s Rowid=$o(^DHCCAVOUCHDATAS(0,"Interval",i,Rowid)) q:Rowid=""  d  
 	..s VouchObj=##class(dhc.ca.cache.data.VouchDatas).%OpenId(Rowid)
 	..s DeptDr=VouchObj.VouchDatasdeptDr.%Id()
 	..s unitObj=##class(dhc.ca.cache.data.UnitDepts).%OpenId(DeptDr)
 	..s unitDr=unitObj.UnitDeptsunitDr.%Id()
 	..q:units'[unitDr
 	..s itemDr=VouchObj.VouchDatasitemDr.%Id()

    ..s debit=VouchObj.VouchDatasdebit
    ..s ^temp($zn,$j,"dhchs",unitDr,DeptDr,itemDr)=$g(^temp($zn,$j,"dhchs",unitDr,DeptDr,itemDr))+debit

    s unitDr="" f  s unitDr=$o(^temp($zn,$j,"dhchs",unitDr)) q:unitDr=""  d 
    .s deptDr="" f  s deptDr=$o(^temp($zn,$j,"dhchs",unitDr,deptDr)) q:deptDr=""  d 
    ..s itemDr="" f  s itemDr=$o(^temp($zn,$j,"dhchs",unitDr,deptDr,itemDr)) q:itemDr=""  d 
    ...s debit=$g(^temp($zn,$j,"dhchs",unitDr,deptDr,itemDr))
    ...d OutputRow2
    k ^temp($zn,$j)
 
 	q $$$OK	
  	
OutputRow2
    
    //部门分层dr
    q:'$d(^DHCCAUNITDEPTS(deptDr))
    s deptCode=$p(^DHCCAUNITDEPTS(deptDr),"^",1)
    s deptName=$p(^DHCCAUNITDEPTS(deptDr),"^",2)
    
	i $d(^DHCCADEPTLEVELSETS(0,"Dept",depsetIdLc,deptDr)) s deptPar=depsetIdDk 
	e  s deptPar=depsetId   
	s deplsDr=##class(dhc.ca.cache.udata.uDeptLevelSets).GetParRef(deptPar,deptDr)     
  	s deplsObj=##class(dhc.ca.cache.data.DeptLevelSets).%OpenId(deplsDr)
  	s deplsRemark=deplsObj.DeptLevelSetsremark,deplsName=deplsObj.DeptLevelSetsname,deplsCode=deplsObj.DeptLevelSetscode
  	//数据分层
  	s datlsDr=##class(dhc.ca.cache.udata.uDataLevelSets).GetLevelItemsParRef(datsetId,itemDr) 
  	s datlsObj=##class(dhc.ca.cache.data.DataLevelSets).%OpenId(datlsDr)
  	s datlsCode=datlsObj.DataLevelSetscode,datlsName=datlsObj.DataLevelSetsname
  	
  	s Data=$lb(stName,enName,unitDr,deplsDr,deplsCode,deplsRemark,deplsName,deptDr,deptCode,deptName,datlsDr,datlsCode,datlsName,itemDr,$num(debit,2))

    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
 	
	q
}

ClassMethod GetDeptsDirectCost2Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDeptsDirectCostExecute ]
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

ClassMethod GetDeptsDirectCost2Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDeptsDirectCostExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetDeptsDirectCost2(stdate As %String, endate As %String, units As %String) As %Query(ROWSPEC = "stName:%String,enName:%String,unitDr:%Integer,deplsDr:%Integer,deplsCode:%String,deplsRemark:%String,deplsName:%String,deptDr:%Integer,deptCode:%String,deptName:%String,datlsDr:%Integer,datlsCode:%String,datlsName:%String,itemDr:%Integer,debit:%Float") [ SqlProc ]
{
}

//d ##class(%ResultSet).RunQuery("web.RunqianQueryReport","MedDepartMentIncome2","3","3","3","319")

ClassMethod MedDepartMentIncome2Execute(ByRef qHandle As %Binary, stdate As %String, endate As %String, deptPar As %String, itemPar As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	q:(stdate="")||(endate="")||(stdate>endate) $$$OK
	q:'$d(^DHCCAACCOUNTMONTHS(stdate)) $$$OK
	q:'$d(^DHCCAACCOUNTMONTHS(endate)) $$$OK
	q:(deptPar="") $$$OK
	k ^TEMPDHCCAHS("dhcahs",$j)
	s pattype="O"
	s (rowid,rowidTJ,locs,itms,itmsTJ,itmsTJ2,start,end,startMonth,endMonth,month)=""
	s locs=$$GetHisdirDepts^HERPBONUSCOMMON(stdate,endate,deptPar)
	s itms=$$GetHisDirItems^HERPBONUSCOMMON(itemPar,"his")
	s itmsTJ=$$GetHisDirItems^HERPBONUSCOMMON(itemPar,"TTJ")
	s itmsTJ2=$$GetHisDirItems^HERPBONUSCOMMON(itemPar,"ARC")
	s start=$p(^DHCCAACCOUNTMONTHS(stdate),"^",4)
	s end=$p(^DHCCAACCOUNTMONTHS(endate),"^",5)
	s startMonth=$p(^DHCCAACCOUNTMONTHS(stdate),"^",2)
	s endMonth=$p(^DHCCAACCOUNTMONTHS(endate),"^",2)
	s len=$LL(locs)
	;门急诊/住院/收入
	i deptPar ="42" s pattype="H"
	i deptPar ="43" s pattype="H2" 
	i pattype'["H" d
	.f i=1:1:len  d 
	..s loc=$LIST(locs,i)
	..f date=start:1:end  d 
	...f  s rowid=$o(^DHCWorkLoad(0,"ORDDATERESDEP",date,loc,rowid)) q:rowid=""  d 
	....s type=$p(^DHCWorkLoad(rowid),"^",4)                         //病人类型
	....q:type="H"                          
	....;q:(pattype'="")&&(pattype'[type)
	....s TarEcDr=$p(^DHCWorkLoad(rowid),"^",41)                      //核算子类dr	
	....q:(itms'="")&&($LF(itms,TarEcDr)=0) 
	....s itemord=$p(^DHCWorkLoad(rowid),"^",2)                       //医嘱项dr
	....s arcinfo=$$GetArcInfoByDr^HERPBONUSCOMMON(itemord)           //医嘱项信息
	....s arcCode=$p(arcinfo,"^",1)                                   //医嘱项代码
	....s arcDesc=$p(arcinfo,"^",2)                                   //医嘱项名称
    ....s fee=$p(^DHCWorkLoad(rowid),"^",16)
    ....s locName=$p($g(^CTLOC(loc)),"^",2)
    ....s tarEcName=$p(^DHCTarC("EC",TarEcDr),"^",2)
    ....s ^TEMPDHCCAHS("dhcahs",$j,loc,locName,TarEcDr,tarEcName,arcCode,arcDesc,type)=$g(^TEMPDHCCAHS("dhcahs",$j,loc,locName,TarEcDr,tarEcName,arcCode,arcDesc,type))+fee
    ;体检一科收入明细
    i pattype="H" d
    .f  s month=$o(^dhcbsBonusTJDataI("TJDate",month)) q:month=""  d 
    ..q:((startMonth]month)||(month]endMonth))
    ..f  s rowidTJ=$o(^dhcbsBonusTJDataI("TJDate",month,rowidTJ)) q:rowidTJ=""  d 
    ...s RecDep=$LIST(^dhcbsBonusTJDataD(rowidTJ),6)
    ...s RecDepName=$LIST(^dhcbsBonusTJDataD(rowidTJ),7)
    ...s itemtype=$LIST(^dhcbsBonusTJDataD(rowidTJ),3)
    ...q:(itmsTJ'="")&&($LF(itmsTJ,itemtype)=0)
    ...s itemtypename=$LIST(^dhcbsBonusTJDataD(rowidTJ),10)
    ...s arcCode=$LIST(^dhcbsBonusTJDataD(rowidTJ),2)
    ...s arcDesc=$LIST(^dhcbsBonusTJDataD(rowidTJ),9)
    ...s fee=$LIST(^dhcbsBonusTJDataD(rowidTJ),5)
    ...s ^TEMPDHCCAHS("dhcahs",$j,RecDep,RecDepName,itemtype,itemtypename,arcCode,arcDesc,"H")=$g(^TEMPDHCCAHS("dhcahs",$j,RecDep,RecDepName,itemtype,itemtypename,arcCode,arcDesc,"H"))+fee
    ;体检二科收入明细
    i pattype="H2"  d
    
    .s stday=$p(^DHCCAACCOUNTMONTHS(stdate),"^",4)
    .s enday=$p(^DHCCAACCOUNTMONTHS(endate),"^",5)
    .f AdmDate=stday:1:enday  d 
	..s AdmTime=0 f  s AdmTime=$O(^DHCPEIADM(0,"AdmDateTime",AdmDate,AdmTime)) q:(""=AdmTime)  d
	...s IAdmRowId=0  f  s IAdmRowId=$O(^DHCPEIADM(0,"AdmDateTime",AdmDate,AdmTime,IAdmRowId))  Q:(""=IAdmRowId)  d
	....s Status=$P($g(^DHCPEIADM(IAdmRowId)),"^",8)
	....q:'(("ARRIVED"=Status)||("COMPLETED"=Status))
	....s PAADM=$P($g(^DHCPEIADM(IAdmRowId)),"^",1)
	....q:PAADM=""
	....s OEORDRowId=0
	....f  s OEORDRowId=$O(^OEORD(0,"Adm",PAADM,OEORDRowId)) q:OEORDRowId=""  d
	.....s OEORIChildsub=0
	.....f  s OEORIChildsub=$O(^OEORD(OEORDRowId,"I",OEORIChildsub)) q:OEORIChildsub=""  d
	......q:(""=$O(^DHCPECRMO(0,"OEORI",(OEORDRowId_"||"_OEORIChildsub),0))) //过滤非体检项目
	......; 过滤非医嘱站点
	......s OtherSTRowId=$O(^DHCPEST(0,"STORD_ARCIM",(OEORDRowId_"||"_OEORIChildsub),0))
	......s OEORIItemStatDR=+$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",13)

	......s ItmMastDR=$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",2)
	......;q:(""'=OEItemDR)&(OEItemDR'=ItmMastDR)

	......s RecDepDR=$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,3)),"^",6)
	......q:(""=RecDepDR)
	......s OrdDeptDR=$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",1)
	......q:(""'=OrdDeptDR) // 医嘱套项目不计算
	
	......s OEORDIDR=OEORDRowId_"||"_OEORIChildsub
	......s crmodr=$O(^DHCPECRMO(0,"OEORI",OEORDIDR,0))
	......s PIOIDR=$P($G(^DHCPECRMO(crmodr)),"^",2)
	......s FactAmount=+##class(web.DHCPE.HandlerPreOrds).GetFactAmountByItem(PIOIDR,"","")
	......s arcinfo=$$GetArcInfoByDr^HERPBONUSCOMMON(ItmMastDR)
    ......s arccode=$p(arcinfo,"^",1),arcname=$p(arcinfo,"^",2),arccat=$p(arcinfo,"^",3),arccatname=$p(arcinfo,"^",4) ,arcic=$p(arcinfo,"^",5),arcicname=$p(arcinfo,"^",6)
 	......q:(itmsTJ2'="")&&($LF(itmsTJ2,arccat)=0)
	......s RecDepName=$p(^CTLOC(RecDepDR),"^",2)
	......s ^TEMPDHCCAHS("dhcahs",$j,RecDepDR,RecDepName,arccat,arccatname,arccode,arcname,"H")=$g(^TEMPDHCCAHS("dhcahs",$j,RecDepDR,RecDepName,arccat,arccatname,arccode,arcname,"H"))+FactAmount
    
    s loc="" f  s loc=$o(^TEMPDHCCAHS("dhcahs",$j,loc)) q:loc=""  d 
	.s locName="" f  s locName=$o(^TEMPDHCCAHS("dhcahs",$j,loc,locName)) q:locName=""  d 
	..s tarEcdr="" f  s tarEcdr=$o(^TEMPDHCCAHS("dhcahs",$j,loc,locName,tarEcdr)) q:tarEcdr=""  d 
	...s tarEcName=""  f  s tarEcName=$o(^TEMPDHCCAHS("dhcahs",$j,loc,locName,tarEcdr,tarEcName)) q:tarEcName=""  d 
	....s arccode="" f  s arccode=$o(^TEMPDHCCAHS("dhcahs",$j,loc,locName,tarEcdr,tarEcName,arccode)) q:arccode=""  d 
	.....s arcname="" f  s arcname=$o(^TEMPDHCCAHS("dhcahs",$j,loc,locName,tarEcdr,tarEcName,arccode,arcname)) q:arcname=""  d 
	......s type="" f  s type=$o(^TEMPDHCCAHS("dhcahs",$j,loc,locName,tarEcdr,tarEcName,arccode,arcname,type)) q:type=""  d 
	.......s fee=$g(^TEMPDHCCAHS("dhcahs",$j,loc,locName,tarEcdr,tarEcName,arccode,arcname,type))
	.......d OutputRow4
	k ^TEMPDHCCAHS("dhcahs",$j)
   
 	k ^temp($j)
 	;输出合计
 	;d OutputRowWorkSum
 	q $$$OK	
  	
OutputRow4
    s pre=$case(pattype,"H":"TTJ","H2":"ARC",:"his")
    s code=pre_tarEcdr
    s datafc=$$GetDataFc^HERPBONUSCOMMON(34,code)
    ;w pre_"^"_code_"^"_datafc_"^"
    s datafcName=$p(^DHCCADATALEVELSETS(datafc),"^",2)
  
  	s Data=$lb(datafc,datafcName,loc,locName,tarEcdr,tarEcName,arccode,arcname,type,fee)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod MedDepartMentIncome2Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MedDepartMentIncome2Execute ]
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

ClassMethod MedDepartMentIncome2Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MedDepartMentIncome2Execute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query MedDepartMentIncome2(stdate As %String, endate As %String, deptPar As %String, itemPar As %String) As %Query(ROWSPEC = "datafc:%Integer,datafcName:%String,loc:%Integer,locName:%String,tarEcdr:%Integer,tarEcName:%String,arccode:%String,arcname:%String,type:%String,fee:%Float") [ SqlProc ]
{
}

/// Description:   科室分析:临床科室分析（奖金分配）
/// Creator：     
/// CreatDate：    2014-04-13
/// Table：        incomedatas,paramdatas,costresultsum
/// Input：        stdate:起始日期[月]，endate:截止日期[月]
/// Output：       deplsDr,deplsCode,deplsName,locdr,deptCode,deptName,role,type,fee
/// OutPutDesc:    科室分层Dr,科室分层代码,科室分层名称,科室Dr,科室代码,科室名称,科室角色,数据类型,数值
/// Debug:       d ##class(%ResultSet).RunQuery("web.RunqianQueryReport","GetLcKsFxJJ","1","1")
ClassMethod GetLcKsFxJJExecute(ByRef qHandle As %Binary, stdate As %String, endate As %String) As %Status
{
	Set repid=$I(^CacheTemp) 
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
 	q:stdate="" $$$OK
	q:endate="" $$$OK
	q:stdate>endate $$$OK
	
    k ^temp($zn,$j)  

    ;s items=..GetItems("f102,f103")                     //卫生材料、药品费分层下各项目dr
    s layer =7							 //取全成本分层下的所有临床科室
    s dept = ##class(dhc.ca.cache.udata.DoCostDist1).GetCurrentLayerDepts(layer)
	s depts=##class(dhc.ca.cache.udata.uCostResultData).GetDepts(dept)             
    s len=$l(depts,",")       
    f i=1:1:len d 
    .s locdr=$p(depts,",",i)  
    .;w i1_"^"_stdate,!                         //科室循环
    .f i1=stdate:1:endate d
    .. s ^temp($zn,$j,locdr,"income")=0			//shouru 
    .. s ^temp($zn,$j,locdr,"yao")=0			// yaopin
    .. s ^temp($zn,$j,locdr,"cl")=0				//cailiao
    .. s ^temp($zn,$j,locdr,"zjcb")=0			//zjcb
    .. S ^temp($zn,$j,locdr,"jjcb")=0			//奖金成本
    .. s ^temp($zn,$j,locdr,"clcb")= 0			//材料成本
    .. s ^temp($zn,$j,locdr,"yaocost")=0		//药品成本
    .. S ^temp($zn,$j,locdr,"glcb")=0    //glft
    ..s ^temp($zn,$j,locdr,"glcbjj")=0
    ..s ^temp($zn,$j,locdr,"glcbyp")=0
    ..s ^temp($zn,$j,locdr,"glcbcl")=0 
    
    ..;收入部分
    ..;w i1_"^"_locdr,!
    ..s RowIdI="" f  s RowIdI=$o(^DHCCAINCOMEDATAS(0,"IntervalPatdeptdr",i1,locdr,RowIdI)) q:RowIdI=""  d ;取病人科室收入
    ...s fee=$p(^DHCCAINCOMEDATAS(RowIdI),"^",7)
    
    ...s ^temp($zn,$j,locdr,"income")=$g(^temp($zn,$j,locdr,"income"))+fee
    ..s RowIdI="" f  s RowIdI=$o(^DHCCAINCOMEDATAS(0,"IntervalPatdeptdr",i1,locdr,RowIdI)) q:RowIdI=""  d ;取病人科室收入
    ...s itemDr=$p(^DHCCAINCOMEDATAS(RowIdI),"^",6) q:itemDr=""
    ...q:'$d(^DHCCADATALEVELSETS(0,"Item","7",itemDr))				  ;3为 取药品收入分类 id
    ...s yaofee=$p(^DHCCAINCOMEDATAS(RowIdI),"^",7)
    
   
    ...s ^temp($zn,$j,locdr,"yao")=$g(^temp($zn,$j,locdr,"yao"))+yaofee
    ..s RowIdI="" f  s RowIdI=$o(^DHCCAINCOMEDATAS(0,"IntervalPatdeptdr",i1,locdr,RowIdI)) q:RowIdI=""  d ;取病人科室收入
    ...s itemDr=$p(^DHCCAINCOMEDATAS(RowIdI),"^",6) q:itemDr=""
    ...q:'$d(^DHCCADATALEVELSETS(0,"Item","8",itemDr))					;3为 取材料收入分类 id
    ...s clfee=$p(^DHCCAINCOMEDATAS(RowIdI),"^",7)
    ...s ^temp($zn,$j,locdr,"cl")=$g(^temp($zn,$j,locdr,"cl"))+clfee
    
    ..;直接成本
    ..s locdr1=locdr
    ..s RowIdI ="" f  s RowIdI=$o(^DHCCACOSTDISTSETS(0,"DInterval",1,i1,RowIdI)) q:RowIdI=""  d
    ...s distflag=$p(^DHCCACOSTDISTSETS("1","CostResultData",RowIdI),"^",6)  q:distflag'="self"
    ...s itemDrc=$p(^DHCCACOSTDISTSETS(1,"CostResultData",RowIdI),"^",4)
    ...s datafee=$p(^DHCCACOSTDISTSETS("1","CostResultData",RowIdI),"^",5)
    ...s distdept=$p($g(^DHCCACOSTDISTSETS(1,"CostResultData",RowIdI)),"^",3) q:distdept'=locdr1
    ...;q:$F(","_locdr1_",",","_distdept_",")=0					//
   
    ...s ^temp($zn,$j,locdr1,"zjcb")=$g(^temp($zn,$j,locdr1,"zjcb"))+datafee   
    ...;w locdr_"^"_locdr1_"^"_distflag_"^"_datafee   
    
    ..;奖金 
    ...i $d(^DHCCADATALEVELSETS(0,"Item","26",itemDrc)) d
   
    ....s ^temp($zn,$j,locdr1,"jjcb")=$g(^temp($zn,$j,locdr1,"jjcb"))+datafee  
    
    ..;cailiao
    ...i $d(^DHCCADATALEVELSETS(0,"Item","27",itemDrc))	d				// 材料的id分层
 
    ....s ^temp($zn,$j,locdr1,"clcb")=$g(^temp($zn,$j,locdr1,"clcb"))+datafee 
    
    ..;yaopin
    ...i $d(^DHCCADATALEVELSETS(0,"Item","28",itemDrc))	d				// 药品成本的id分层
  
    ....s ^temp($zn,$j,locdr1,"yaocost")=$g(^temp($zn,$j,locdr1,"yaocost"))+datafee   
    
  
    ..;奖金
    ..;s locdr1=locdr
    ..;s RowIdI ="" f  s RowIdI=$o(^DHCCACOSTDISTSETS(0,"DInterval",1,i1,RowIdI)) q:RowIdI=""  d
    ...;s distflag=$p(^DHCCACOSTDISTSETS("1","CostResultData",RowIdI),"^",6)  q:distflag'="self"
    ...;s itemDrc=$p(^DHCCACOSTDISTSETS(1,"CostResultData",RowIdI),"^",4)
    ...;s datafee=$p(^DHCCACOSTDISTSETS("1","CostResultData",RowIdI),"^",5)
    ...;s distdept=$p($g(^DHCCACOSTDISTSETS(1,"CostResultData",RowIdI)),"^",3) q:distdept'=locdr1
    ...;q:$F(","_locdr1_",",","_distdept_",")=0
    ...;q:'$d(^DHCCADATALEVELSETS(0,"Item","26",itemDrc))					// 奖金的id
    ...;w locdr_"^"_locdr1_"^"_distflag_"^"_datafee
    ...;s ^temp($zn,$j,locdr1,"jjcb")=$g(^temp($zn,$j,locdr1,"jjcb"))+datafee   
    
     
    ..; 材料
    ..;s locdr1=locdr
    ..;s RowIdI ="" f  s RowIdI=$o(^DHCCACOSTDISTSETS(0,"DInterval",1,i1,RowIdI)) q:RowIdI=""  d
    ...;s distflag=$p(^DHCCACOSTDISTSETS("1","CostResultData",RowIdI),"^",6)  q:distflag'="self"
    ...;s itemDrc=$p(^DHCCACOSTDISTSETS(1,"CostResultData",RowIdI),"^",4)
    ...;s datafee=$p(^DHCCACOSTDISTSETS("1","CostResultData",RowIdI),"^",5)
    ...;s distdept=$p($g(^DHCCACOSTDISTSETS(1,"CostResultData",RowIdI)),"^",3) q:distdept'=locdr1
    ...;q:$F(","_locdr1_",",","_distdept_",")=0
    ...;q:'$d(^DHCCADATALEVELSETS(0,"Item","27",itemDrc))					// 材料的id分层
    ...;s ^temp($zn,$j,locdr1,"clcb")=$g(^temp($zn,$j,locdr1,"clcb"))+datafee   
    
    ..; 药品
    ..;s locdr1=locdr
    ..;s RowIdI ="" f  s RowIdI=$o(^DHCCACOSTDISTSETS(0,"DInterval",1,i1,RowIdI)) q:RowIdI=""  d
    ...;s distflag=$p(^DHCCACOSTDISTSETS("1","CostResultData",RowIdI),"^",6)  q:distflag'="self"
    ...;s distdept=$p($g(^DHCCACOSTDISTSETS(1,"CostResultData",RowIdI)),"^",3) q:distdept'=locdr1
    ...;q:$F(","_locdr1_",",","_distdept_",")=0
    ...;s itemDrc=$p(^DHCCACOSTDISTSETS(1,"CostResultData",RowIdI),"^",4)
    ...;q:'$d(^DHCCADATALEVELSETS(0,"Item","28",itemDrc))					// 药品成本的id分层
    ...;s datafee=$p(^DHCCACOSTDISTSETS("1","CostResultData",RowIdI),"^",5)
    ...;s ^temp($zn,$j,locdr1,"yaocost")=$g(^temp($zn,$j,locdr1,"yaocost"))+datafee   	
        
        
    ..;分摊成本
    ..s locdr1=locdr
    ..s RowIdI ="" f  s RowIdI=$o(^DHCCACOSTDISTSETS(0,"DInterval",1,i1,RowIdI)) q:RowIdI=""  d
    ...s distflag=$p(^DHCCACOSTDISTSETS("1","CostResultData",RowIdI),"^",6)  q:distflag'="dist"
    ...s distdept=$p($g(^DHCCACOSTDISTSETS(1,"CostResultData",RowIdI)),"^",3) q:distdept'=locdr1
    ...s depted=$p($g(^DHCCACOSTDISTSETS(1,"CostResultData",RowIdI)),"^",2) q:depted=""
    ...s layer1 =4							 //取全成本分层下的所有管理科室
    ...s dept1 = ##class(dhc.ca.cache.udata.DoCostDist1).GetCurrentLayerDepts(layer1)
	...s depts1=##class(dhc.ca.cache.udata.uCostResultData).GetDepts(dept1)
    ...q:$F(","_depts1_",",","_depted_",")=0
    ...s itemDrc=$p(^DHCCACOSTDISTSETS(1,"CostResultData",RowIdI),"^",4)
    ...s datafee=$p(^DHCCACOSTDISTSETS("1","CostResultData",RowIdI),"^",5)
   
    ...s ^temp($zn,$j,locdr1,"glcb")=$g(^temp($zn,$j,locdr1,"glcb"))+datafee  
    
    ...i $d(^DHCCADATALEVELSETS(0,"Item","26",itemDrc))	d			//分摊奖金
    ....;s datafee=$p(^DHCCACOSTDISTSETS("1","CostResultData",RowIdI),"^",5)
    ....;i ^temp($zn,$j,locdr1,"glcbjj")="" s ^temp($zn,$j,locdr1,"glcbjj")=0
   	....s ^temp($zn,$j,locdr1,"glcbjj")=$g(^temp($zn,$j,locdr1,"glcbjj"))+datafee    
   	
   	...i $d(^DHCCADATALEVELSETS(0,"Item","28",itemDrc))	d			//分摊药品
    ....;s datafee=$p(^DHCCACOSTDISTSETS("1","CostResultData",RowIdI),"^",5)
   
    ....s ^temp($zn,$j,locdr1,"glcbyp")=$g(^temp($zn,$j,locdr1,"glcbyp"))+datafee   
    
    
    ...i $d(^DHCCADATALEVELSETS(0,"Item","27",itemDrc))	d			//分摊材料
    ....;s datafee=$p(^DHCCACOSTDISTSETS("1","CostResultData",RowIdI),"^",5)
    
   	
    ....s ^temp($zn,$j,locdr1,"glcbcl")=$g(^temp($zn,$j,locdr1,"glcbcl"))+datafee   
    
     ..;分摊成本奖金	
    ..;s locdr1=locdr
    ..;s RowIdI ="" f  s RowIdI=$o(^DHCCACOSTDISTSETS(0,"DInterval",1,i1,RowIdI)) q:RowIdI=""  d
    ...;s distflag=$p(^DHCCACOSTDISTSETS("1","CostResultData",RowIdI),"^",6)  q:distflag'="dist"
     ...;s distdept=$p($g(^DHCCACOSTDISTSETS(1,"CostResultData",RowIdI)),"^",3) q:distdept'=locdr1
    ...;s depted=$p($g(^DHCCACOSTDISTSETS(1,"CostResultData",RowIdI)),"^",2) q:depted=""
    ...;s layer1 =4							 //取全成本分层下的所有管理科室
    ...;s dept1 = ##class(dhc.ca.cache.udata.DoCostDist1).GetCurrentLayerDepts(layer1)
	...;s depts1=##class(dhc.ca.cache.udata.uCostResultData).GetDepts(dept1)
    ...;q:$F(","_depts1_",",","_depted_",")=0
   
    ...;s itemDrc=$p(^DHCCACOSTDISTSETS(1,"CostResultData",RowIdI),"^",4)
    ...;q:'$d(^DHCCADATALEVELSETS(0,"Item","26",itemDrc))				//分摊奖金
    ...;s datafee=$p(^DHCCACOSTDISTSETS("1","CostResultData",RowIdI),"^",5)
   	
    ...;s ^temp($zn,$j,locdr1,"glcbjj")=$g(^temp($zn,$j,locdr1,"glcbjj"))+datafee   
    
    ..;分摊成本药品	
    ..;s locdr1=locdr
    ..;s RowIdI ="" f  s RowIdI=$o(^DHCCACOSTDISTSETS(0,"DInterval",1,i1,RowIdI)) q:RowIdI=""  d
    ...;s distflag=$p(^DHCCACOSTDISTSETS("1","CostResultData",RowIdI),"^",6)  q:distflag'="dist"
    ...;s depted=$p($g(^DHCCACOSTDISTSETS(1,"CostResultData",RowIdI)),"^",2) q:depted=""
    ...;s distdept=$p($g(^DHCCACOSTDISTSETS(1,"CostResultData",RowIdI)),"^",3) q:distdept'=locdr1
    ...;s layer1 =4							 //取全成本分层下的所有管理科室
    ...;s dept1 = ##class(dhc.ca.cache.udata.DoCostDist1).GetCurrentLayerDepts(layer1)
	...;s depts1=##class(dhc.ca.cache.udata.uCostResultData).GetDepts(dept1)
    ...;q:$F(","_depts1_",",","_depted_",")=0
    
    ...;s itemDrc=$p(^DHCCACOSTDISTSETS(1,"CostResultData",RowIdI),"^",4)
    ...;q:'$d(^DHCCADATALEVELSETS(0,"Item","28",itemDrc))				//分摊药品
    ...;s datafee=$p(^DHCCACOSTDISTSETS("1","CostResultData",RowIdI),"^",5)
    ...;s ^temp($zn,$j,locdr1,"glcbyp")=$g(^temp($zn,$j,locdr1,"glcbyp"))+datafee   
     
     ..;分摊成本材料	
    ..;s locdr1=locdr
    ..;s RowIdI ="" f  s RowIdI=$o(^DHCCACOSTDISTSETS(0,"DInterval",1,i1,RowIdI)) q:RowIdI=""  d
    ...;s distflag=$p(^DHCCACOSTDISTSETS("1","CostResultData",RowIdI),"^",6) q:distflag'="dist"
    ...;s depted=$p($g(^DHCCACOSTDISTSETS(1,"CostResultData",RowIdI)),"^",2) q:depted=""
    ...;s distdept=$p($g(^DHCCACOSTDISTSETS(1,"CostResultData",RowIdI)),"^",3) q:distdept'=locdr1
    ...;s layer1 =4							 //取全成本分层下的所有管理科室
    ...;s dept1 = ##class(dhc.ca.cache.udata.DoCostDist1).GetCurrentLayerDepts(layer1)
	...;s depts1=##class(dhc.ca.cache.udata.uCostResultData).GetDepts(dept1)
    ...;q:$F(","_depts1_",",","_depted_",")=0   
    ...;s itemDrc=$p(^DHCCACOSTDISTSETS(1,"CostResultData",RowIdI),"^",4)
    ...;q:'$d(^DHCCADATALEVELSETS(0,"Item","27",itemDrc))				//分摊材料
    ...;s datafee=$p(^DHCCACOSTDISTSETS("1","CostResultData",RowIdI),"^",5)
   	
    ...;s ^temp($zn,$j,locdr1,"glcbcl")=$g(^temp($zn,$j,locdr1,"glcbcl"))+datafee   
    
    
	s (ylsr,ypsr,clsr,ksylsr,kszjcb,ksjjcb,ksclcb,ksypcb,kszjcb1,kszjcb1,glftcb,glftjjcb,glftypcb,glftclcb,glftcb1) =0
      s locdrs=0 f  s locdrs=$o(^temp($zn,$j,locdrs)) q:locdrs=""  d
      .s outdata1=$g(^temp($zn,$j,locdrs,"income"))_"^"_$g( ^temp($zn,$j,locdrs,"yao"))_"^"_$g(^temp($zn,$j,locdrs,"cl"))_"^"_$g( ^temp($zn,$j,locdrs,"zjcb"))_"^"_$g(^temp($zn,$j,locdrs,"jjcb"))_"^"_$g(^temp($zn,$j,locdrs,"clcb"))_"^"_$g(^temp($zn,$j,locdrs,"yaocost"))_"^"_$g(^temp($zn,$j,locdrs,"glcb"))_"^"_$g( ^temp($zn,$j,locdrs,"glcbjj"))_"^"_$g(^temp($zn,$j,locdrs,"glcbyp"))_"^"_$g(^temp($zn,$j,locdrs,"glcbcl"))
    .s ylsr=$p(outdata1,"^",1)
    .s ypsr=$p(outdata1,"^",2)
    .s clsr=$p(outdata1,"^",3)
    .s ksylsr=ylsr-ypsr-clsr
    .s kszjcb=$p(outdata1,"^",4)
   	.s ksjjcb=$p(outdata1,"^",5)
   	.s ksclcb=$p(outdata1,"^",6)
   	.s ksypcb=$p(outdata1,"^",7)
   	.s kszjcb1=kszjcb-ksjjcb-ksjjcb-ksypcb
   	.s glftcb=$p(outdata1,"^",8)
   	.s glftjjcb=$p(outdata1,"^",9)
   	.s glftypcb=$p(outdata1,"^",10)
   	.s glftclcb=$p(outdata1,"^",11)
   	.s glftcb1=glftcb-glftjjcb-glftypcb-glftclcb
   	.;w ylsr_"^"_ypsr,!
    .d OutputRow1
   
    k ^temp($zn,$j)

    q $$$OK
OutputRow1

    //部门分层信息
   ; w locdrs,!
    s locInfo=..DeptsInfo(locdrs)
    q:locInfo=0
    s deplsDr=$p(locInfo,"^",1)
    s deplsCode=$p(locInfo,"^",2)
    s deplsName=$p(locInfo,"^",3)
    s deptCode=$p(locInfo,"^",5)
    s deptName=$p(locInfo,"^",6)
   ; w deplsDr_":"_deplsCode_":"_deplsName_":"_locdr_":"_deptCode_":"_deptName_":"_$fn($g(ylsr),"",2)
   	s Data=$lb(deplsDr,deplsCode,deplsName,locdr,deptCode,deptName,$fn($g(ylsr),"",2),$fn($g(ksylsr),"",2),$fn($g(ypsr),"",2),$fn($g(clsr),"",2),$fn($g(kszjcb),"",2),$fn($g(kszjcb1),"",2),$fn($g(ksjjcb),"",2),$fn($g(ksclcb),"",2),$fn($g(ksypcb),"",2),$fn($g(glftcb),"",2),$fn($g(glftcb1),"",2),$fn($g(glftjjcb),"",2),$fn($g(glftypcb),"",2),$fn($g(glftclcb),"",2))
   ; w data,!
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
}

ClassMethod GetLcKsFxJJFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLcKsFxJJExecute ]
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

ClassMethod GetLcKsFxJJClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLcKsFxJJExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetLcKsFxJJ(stdate As %String, endate As %String) As %Query(ROWSPEC = "deplsDr:%Integer,deplsCode:%String,deplsName:%String,locdr:%Integer,deptCode:%String,deptName:%String,ylsr:%Float,ksylsr:%Float,ypsr:%Float,clsr:%Float,kszjcb:%Float,kszjcb1:%Float,ksjjcb:%Float,ksclcb:%Float,ksypcb:%Float,glftcb:%Float,glftcb1:%Float,glftjjcb:%Float,glftypcb:%Float,glftclcb:%Float") [ SqlProc ]
{
}

/// Description:   部门及所在大科分层信息
/// Creator：  
/// CreatDate：    2014-04-13
/// Table：        DHC_CA_CACHE_DATA.DEPTLEVELSETS ,DHC_CA_CACHE_DATA.UNITDEPTS
/// Input：        locdr-科室dr
/// OutPut:        s deptsInfo=deplsDr_"^"_deplsCode_"^"_deplsName_"^"_deplsremark_"^"_deptCode_"^"_deptName
/// OutPutDesc     大科分层dr^大科分层代码^大科分层名称^大科分层备注^科室代码^科室名称
/// Debug:         w ##class(web.RunqianQueryReport).DeptsInfo(2)
ClassMethod DeptsInfo(locdr) As %String
{
    
    q:locdr="" "0"
	q:'$d(^DHCCAUNITDEPTS(locdr)) "0"
	s deptCode=$p(^DHCCAUNITDEPTS(locdr),"^",1)
	s deptName=$p(^DHCCAUNITDEPTS(locdr),"^",2)
	s unitDr=$p(^DHCCAUNITDEPTS(locdr),"^",8)
	i unitDr=1 s DkSetId=$o(^DHCCADEPTLEVELSETS(0,"Code","L101",""))
	s deplsDr=##class(dhc.ca.cache.udata.uDeptLevelSets).GetParRef(DkSetId,locdr)     
  	s deplsObj=##class(dhc.ca.cache.data.DeptLevelSets).%OpenId(deplsDr)
  	s deplsCode=deplsObj.DeptLevelSetscode,deplsName=deplsObj.DeptLevelSetsname,deplsremark=deplsObj.DeptLevelSetsremark
	s deptsInfo=deplsDr_"^"_deplsCode_"^"_deplsName_"^"_deplsremark_"^"_deptCode_"^"_deptName
	q deptsInfo
}

/// Description:   科室分析:医疗技术科室分析（奖金分配）
/// Creator：     
/// CreatDate：    2014-04-13
/// Table：        incomedatas,paramdatas,costresultsum
/// Input：        stdate:起始日期[月]，endate:截止日期[月]
/// Output：       deplsDr,deplsCode,deplsName,locdr,deptCode,deptName,role,type,fee
/// OutPutDesc:    科室分层Dr,科室分层代码,科室分层名称,科室Dr,科室代码,科室名称,科室角色,数据类型,数值
/// Debug:       d ##class(%ResultSet).RunQuery("web.RunqianQueryReport","GetYjKsFxJJ","1","1")
ClassMethod GetYjKsFxJJExecute(ByRef qHandle As %Binary, stdate As %String, endate As %String) As %Status
{
	Set repid=$I(^CacheTemp) 
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
 	q:stdate="" $$$OK
	q:endate="" $$$OK
	q:stdate>endate $$$OK
	
    k ^temp($zn,$j)  

    s layer =6							 //取全成本分层下的所有临床科室
    s dept = ##class(dhc.ca.cache.udata.DoCostDist1).GetCurrentLayerDepts(layer)
	s depts=##class(dhc.ca.cache.udata.uCostResultData).GetDepts(dept)             
    s len=$l(depts,",")       
    f i=1:1:len d 
    .s locdr=$p(depts,",",i)                            
    .f i1=stdate:1:endate d
    .. s ^temp($zn,$j,locdr,"income")=0			//shouru 
    .. s ^temp($zn,$j,locdr,"yao")=0			// yaopin
    .. s ^temp($zn,$j,locdr,"cl")=0				//cailiao
    .. s ^temp($zn,$j,locdr,"zjcb")=0			//zjcb
    .. S ^temp($zn,$j,locdr,"jjcb")=0			//奖金成本
    .. s ^temp($zn,$j,locdr,"clcb")= 0			//材料成本
    .. s ^temp($zn,$j,locdr,"yaocost")=0		//药品成本
    .. S ^temp($zn,$j,locdr,"glcb")=0    //glft
    ..s ^temp($zn,$j,locdr,"glcbjj")=0
    ..s ^temp($zn,$j,locdr,"glcbyp")=0
    ..s ^temp($zn,$j,locdr,"glcbcl")=0 
    
    ..;收入部分
    ..;w i1_"^"_locdr,!
    ..s RowIdI="" f  s RowIdI=$o(^DHCCAINCOMEDATAS(0,"IntervalTdeptdr",i1,locdr,RowIdI)) q:RowIdI=""  d ;取接受科室收入
    ...s fee=$p(^DHCCAINCOMEDATAS(RowIdI),"^",7)
    ...s ^temp($zn,$j,locdr,"income")=$g(^temp($zn,$j,locdr,"income"))+fee
    
    ..s RowIdI="" f  s RowIdI=$o(^DHCCAINCOMEDATAS(0,"IntervalTdeptdr",i1,locdr,RowIdI)) q:RowIdI=""  d ;取接受科室收入
    ...s itemDr=$p(^DHCCAINCOMEDATAS(RowIdI),"^",6) q:itemDr=""
    ...q:'$d(^DHCCADATALEVELSETS(0,"Item","7",itemDr))				  ;3为 取药品收入分类 id
    ...s yaofee=$p(^DHCCAINCOMEDATAS(RowIdI),"^",7)
    
   
    ...s ^temp($zn,$j,locdr,"yao")=$g(^temp($zn,$j,locdr,"yao"))+yaofee
    ..s RowIdI="" f  s RowIdI=$o(^DHCCAINCOMEDATAS(0,"IntervalTdeptdr",i1,locdr,RowIdI)) q:RowIdI=""  d ;取病人科室收入
    ...s itemDr=$p(^DHCCAINCOMEDATAS(RowIdI),"^",6) q:itemDr=""
    ...q:'$d(^DHCCADATALEVELSETS(0,"Item","8",itemDr))					;3为 取材料收入分类 id
    ...s clfee=$p(^DHCCAINCOMEDATAS(RowIdI),"^",7)
    ...s ^temp($zn,$j,locdr,"cl")=$g(^temp($zn,$j,locdr,"cl"))+clfee
    
    ..;直接成本
    ..s locdr1=locdr
    ..s RowIdI ="" f  s RowIdI=$o(^DHCCACOSTDISTSETS(0,"DInterval",1,i1,RowIdI)) q:RowIdI=""  d
    ...s distflag=$p(^DHCCACOSTDISTSETS("1","CostResultData",RowIdI),"^",6)  q:distflag'="self"
    ...s itemDrc=$p(^DHCCACOSTDISTSETS(1,"CostResultData",RowIdI),"^",4)
    ...s datafee=$p(^DHCCACOSTDISTSETS("1","CostResultData",RowIdI),"^",5)
    ...s distdept=$p($g(^DHCCACOSTDISTSETS(1,"CostResultData",RowIdI)),"^",3) q:distdept'=locdr1
    ...;q:$F(","_locdr1_",",","_distdept_",")=0					//
   
    ...s ^temp($zn,$j,locdr1,"zjcb")=$g(^temp($zn,$j,locdr1,"zjcb"))+datafee   
    ...;w locdr_"^"_locdr1_"^"_distflag_"^"_datafee   
    
    ..;奖金 
    ...i $d(^DHCCADATALEVELSETS(0,"Item","26",itemDrc)) d
   
    ....s ^temp($zn,$j,locdr1,"jjcb")=$g(^temp($zn,$j,locdr1,"jjcb"))+datafee  
    
    ..;cailiao
    ...i $d(^DHCCADATALEVELSETS(0,"Item","27",itemDrc))	d				// 材料的id分层
 
    ....s ^temp($zn,$j,locdr1,"clcb")=$g(^temp($zn,$j,locdr1,"clcb"))+datafee 
    
    ..;yaopin
    ...i $d(^DHCCADATALEVELSETS(0,"Item","28",itemDrc))	d				// 药品成本的id分层
  
    ....s ^temp($zn,$j,locdr1,"yaocost")=$g(^temp($zn,$j,locdr1,"yaocost"))+datafee   
    
  
    
    ..;分摊成本
    ..s locdr1=locdr
    ..s RowIdI ="" f  s RowIdI=$o(^DHCCACOSTDISTSETS(0,"DInterval",1,i1,RowIdI)) q:RowIdI=""  d
    ...s distflag=$p(^DHCCACOSTDISTSETS("1","CostResultData",RowIdI),"^",6)  q:distflag'="dist"
    ...s distdept=$p($g(^DHCCACOSTDISTSETS(1,"CostResultData",RowIdI)),"^",3) q:distdept'=locdr1
    ...s depted=$p($g(^DHCCACOSTDISTSETS(1,"CostResultData",RowIdI)),"^",2) q:depted=""
    ...s layer1 =4							 //取全成本分层下的所有管理科室
    ...s dept1 = ##class(dhc.ca.cache.udata.DoCostDist1).GetCurrentLayerDepts(layer1)
	...s depts1=##class(dhc.ca.cache.udata.uCostResultData).GetDepts(dept1)
    ...q:$F(","_depts1_",",","_depted_",")=0
    ...s itemDrc=$p(^DHCCACOSTDISTSETS(1,"CostResultData",RowIdI),"^",4)
    ...s datafee=$p(^DHCCACOSTDISTSETS("1","CostResultData",RowIdI),"^",5)
   
    ...s ^temp($zn,$j,locdr1,"glcb")=$g(^temp($zn,$j,locdr1,"glcb"))+datafee  
    
    ...i $d(^DHCCADATALEVELSETS(0,"Item","26",itemDrc))	d			//分摊奖金
    ....;s datafee=$p(^DHCCACOSTDISTSETS("1","CostResultData",RowIdI),"^",5)
    ....;i ^temp($zn,$j,locdr1,"glcbjj")="" s ^temp($zn,$j,locdr1,"glcbjj")=0
   	....s ^temp($zn,$j,locdr1,"glcbjj")=$g(^temp($zn,$j,locdr1,"glcbjj"))+datafee    
   	
   	...i $d(^DHCCADATALEVELSETS(0,"Item","28",itemDrc))	d			//分摊药品
    ....;s datafee=$p(^DHCCACOSTDISTSETS("1","CostResultData",RowIdI),"^",5)
   
    ....s ^temp($zn,$j,locdr1,"glcbyp")=$g(^temp($zn,$j,locdr1,"glcbyp"))+datafee   
    
    
    ...i $d(^DHCCADATALEVELSETS(0,"Item","27",itemDrc))	d			//分摊材料
    ....;s datafee=$p(^DHCCACOSTDISTSETS("1","CostResultData",RowIdI),"^",5)
    
   	
    ....s ^temp($zn,$j,locdr1,"glcbcl")=$g(^temp($zn,$j,locdr1,"glcbcl"))+datafee   
    
    
	s (ylsr,ypsr,clsr,ksylsr,kszjcb,ksjjcb,ksclcb,ksypcb,kszjcb1,kszjcb1,glftcb,glftjjcb,glftypcb,glftclcb,glftcb1) =0
    s locdrs=0 f  s locdrs=$o(^temp($zn,$j,locdrs)) q:locdrs=""  d
    .s outdata1=$g(^temp($zn,$j,locdrs,"income"))_"^"_$g( ^temp($zn,$j,locdrs,"yao"))_"^"_$g(^temp($zn,$j,locdrs,"cl"))_"^"_$g( ^temp($zn,$j,locdrs,"zjcb"))_"^"_$g(^temp($zn,$j,locdrs,"jjcb"))_"^"_$g(^temp($zn,$j,locdrs,"clcb"))_"^"_$g(^temp($zn,$j,locdrs,"yaocost"))_"^"_$g(^temp($zn,$j,locdrs,"glcb"))_"^"_$g( ^temp($zn,$j,locdrs,"glcbjj"))_"^"_$g(^temp($zn,$j,locdrs,"glcbyp"))_"^"_$g(^temp($zn,$j,locdrs,"glcbcl"))
    .s ylsr=$p(outdata1,"^",1)
    .s ypsr=$p(outdata1,"^",2)
    .s clsr=$p(outdata1,"^",3)
    .s ksylsr=ylsr-ypsr-clsr
    .s kszjcb=$p(outdata1,"^",4)
   	.s ksjjcb=$p(outdata1,"^",5)
   	.s ksclcb=$p(outdata1,"^",6)
   	.s ksypcb=$p(outdata1,"^",7)
   	.s kszjcb1=kszjcb-ksjjcb-ksjjcb-ksypcb
   	.s glftcb=$p(outdata1,"^",8)
   	.s glftjjcb=$p(outdata1,"^",9)
   	.s glftypcb=$p(outdata1,"^",10)
   	.s glftclcb=$p(outdata1,"^",11)
   	.s glftcb1=glftcb-glftjjcb-glftypcb-glftclcb
   	.;w ylsr_"^"_ypsr,!
    .d OutputRow111
   
    k ^temp($zn,$j)

    q $$$OK
OutputRow111

    //部门分层信息
   ; w locdrs,!
   	
	s deptCode=$p(^DHCCAUNITDEPTS(locdrs),"^",1)
	s deptName=$p(^DHCCAUNITDEPTS(locdrs),"^",2)
	  
 
   ; w deplsDr_":"_deplsCode_":"_deplsName_":"_locdr_":"_deptCode_":"_deptName_":"_$fn($g(ylsr),"",2)
   	s Data=$lb(locdrs,deptCode,deptName,$fn($g(ylsr),"",2),$fn($g(ksylsr),"",2),$fn($g(ypsr),"",2),$fn($g(clsr),"",2),$fn($g(kszjcb),"",2),$fn($g(kszjcb1),"",2),$fn($g(ksjjcb),"",2),$fn($g(ksclcb),"",2),$fn($g(ksypcb),"",2),$fn($g(glftcb),"",2),$fn($g(glftcb1),"",2),$fn($g(glftjjcb),"",2),$fn($g(glftypcb),"",2),$fn($g(glftclcb),"",2))
   ; w data,!
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
}

ClassMethod GetYjKsFxJJFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetYjKsFxJJExecute ]
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

ClassMethod GetYjKsFxJJClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetYjKsFxJJExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetYjKsFxJJ(stdate As %String, endate As %String) As %Query(ROWSPEC = "locdr:%Integer,deptCode:%String,deptName:%String,ylsr:%Float,ksylsr:%Float,ypsr:%Float,clsr:%Float,kszjcb:%Float,kszjcb1:%Float,ksjjcb:%Float,ksclcb:%Float,ksypcb:%Float,glftcb:%Float,glftcb1:%Float,glftjjcb:%Float,glftypcb:%Float,glftclcb:%Float") [ SqlProc ]
{
}

/// d ##class(%ResultSet).RunQuery("web.RunqianQueryReport","GetMeTerial")
ClassMethod GetMeTerialExecute(ByRef qHandle As %Binary, stdate As %String, endate As %String, loc) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	q:stdate="" $$$OK
	q:endate="" $$$OK
	q:stdate>endate $$$OK
	q:loc="" $$$OK
 	k ^TEMPDHCCAHS
 	s stdate=$zdh(stdate,3)
 	s endate=$zdh(endate,3)
 	d GetWorkLoadDatas^HERPBONUSCOMMON(stdate,endate,loc)
 	d BuildMeterila^HERPBONUSCOMMON(stdate,endate,"T",loc)
    s sys="" f  s sys=$o(^TEMPDHCCAHS(sys)) q:sys=""  d  
    .s type="" f  s type=$o(^TEMPDHCCAHS(sys,$j,type)) q:type=""  d 
    ..s date="" f  s date=$o(^TEMPDHCCAHS(sys,$j,type,date)) q:date=""  d 
    ...s loc=""  f  s loc=$o(^TEMPDHCCAHS(sys,$j,type,date,loc)) q:loc=""  d 
    ....s inci="" f  s inci=$o(^TEMPDHCCAHS(sys,$j,type,date,loc,inci)) q:inci=""  d
    .....s qty=$p(^TEMPDHCCAHS(sys,$j,type,date,loc,inci),"^",1)
    .....s price=$p(^TEMPDHCCAHS(sys,$j,type,date,loc,inci),"^",2)
    .....s cost=$p(^TEMPDHCCAHS(sys,$j,type,date,loc,inci),"^",3)
    .....s fee=$p(^TEMPDHCCAHS(sys,$j,type,date,loc,inci),"^",4)
    .....d outzbp
 k ^TEMPDHCCAHS
 	q $$$OK	
  	
outzbp
    

  	s day=$zd(date,3)
  	s locdesc=$p(^CTLOC(loc),"^",2)
  	s stkcate=$p(^INCI(inci,2),"^",2)
  	s stkcatCode=$p(^INC("SC",stkcate),"^",1)      //库存分类代码
    s stkcatDesc=$p(^INC("SC",stkcate),"^",2)      //库存分类名称
    s itmcode=$p(^INCI(inci,1),"^",1)
    s itmname=$p(^INCI(inci,1),"^",2)
  	s Data=$lb(day,type,loc,locdesc,stkcatCode,stkcatDesc,itmcode,itmname,qty,price,cost,fee)

    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
 	
	q
}

ClassMethod GetMeTerialFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMeTerialExecute ]
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

ClassMethod GetMeTerialClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMeTerialExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetMeTerial(stdate As %String, endate As %String, loc As %String) As %Query(ROWSPEC = "day:%String,type:%Integer,loc:%Integer,locdesc:%String,stkcatCode:%String,stkcatDesc:%String,itmcode:%String,itmname:%String,qty:%Float,price:%Float,cost:%Float,fee:%Float") [ SqlProc ]
{
}

}
