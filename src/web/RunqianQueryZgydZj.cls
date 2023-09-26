Import SQLUser

Class web.RunqianQueryZgydZj Extends %RegisteredObject [ ProcedureBlock ]
{

//d ##class(%ResultSet).RunQuery("web.RunqianQueryZgydZj","GetincomedataDeptMonth1","3","3")	

ClassMethod GetincomedataDeptMonth1Execute(ByRef qHandle As %Binary, stdate As %Integer, dept As %Integer) As %Status [ SqlProc ]
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
   
    q:stdate="" $$$OK
	s RowId="",RowIdIncome="",Income=""
	s RowIdData="",RowIdDataZc=""
	k ^temp($j)
	
	i $d(^DHCCAUNITDEPTS(dept)) s deptname=$p(^DHCCAUNITDEPTS(dept),"^",2)
	
	i $d(^DHCCAACCOUNTMONTHS(stdate)) d
	.s month=$p(^DHCCAACCOUNTMONTHS(stdate),"^",2)
    .s monthQ=$p(month,"-",1)
    .s monthname=monthQ_""_"年度"
    
    f  s RowId=$o(^DHCCAACCOUNTMONTHS(RowId))  q:RowId=""  d
    .s desc=$p(^DHCCAACCOUNTMONTHS(RowId),"^",2)
    .s mon=+$p(desc,"-",2)_""_"月"
    .s desc1=$p(desc,"-",1)
    
    .q:desc1'=monthQ

    .f  s RowIdIncome=$o(^DHCCAINCOMEDATAS(0,"IntervalFdeptdr",RowId,dept,RowIdIncome)) q:RowIdIncome=""  d
    ..s itemDr=$p(^DHCCAINCOMEDATAS(RowIdIncome),"^",6)
    ..s Income1=$p(^DHCCAINCOMEDATAS(RowIdIncome),"^",7)
    ..s ^temp($j,"Income",RowId,itemDr)=$g(^temp($j,"Income",RowId,itemDr))+Income1

    f  s RowIdData=$o(^DHCCADATALEVELSETS(RowIdData)) q:RowIdData=""  d
    .s dataname=$p(^DHCCADATALEVELSETS(RowIdData),"^",2)
    .s parent=$p(^DHCCADATALEVELSETS(RowIdData),"^",7) 
    .q:parent'=6  //收入分类
    .f  s RowIdDataZc=$o(^DHCCADATALEVELSETS(RowIdData,"Items",RowIdDataZc)) q:RowIdDataZc=""  d
    ..q:RowIdDataZc="0"
    ..s item1=$p(^DHCCADATALEVELSETS(RowIdData,"Items",RowIdDataZc),"^",3)
    ..s itemname1=$P(^DHCCAALLDATAITEMS(item1),"^",3)
    ..s ^temp($j,"item",item1)=RowIdData

    s locdr=0 f  s locdr=$o(^temp($j,"Income",locdr)) q:locdr=""  d
    .s descy=$p(^DHCCAACCOUNTMONTHS(locdr),"^",2)
    .s mony=+$p(descy,"-",2) ;_""_"月"
    
    .s item=0 f  s item=$o(^temp($j,"Income",locdr,item)) q:item=""  d
    ..s itemrowid=$g(^temp($j,"item",item)) 
    ..s itemname1=$p(^DHCCADATALEVELSETS(itemrowid),"^",2)
    ..i $d(^DHCCAALLDATAITEMS(item)) s itemname=$P(^DHCCAALLDATAITEMS(item),"^",3)
 	..s incomefee=$g(^temp($j,"Income",locdr,item)) 
    ..d OutputRow1
 	
 	;输出合计
 	;d OutputRowWorkSum
 	k ^temp($j)
 	q $$$OK
OutputRow1
	;
 	s Data=$lb(deptname,monthname,locdr,mony,itemrowid,itemname1,item,itemname,$g(incomefee))
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
	
OutputRowWorkSum1
    s Data=$lb("total",$g(totalFee))
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
 //ResetVariables
 //	 q
}

ClassMethod GetincomedataDeptMonth1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetincomedataDeptMonth1Execute, SqlProc ]
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

ClassMethod GetincomedataDeptMonth1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetincomedataDeptMonth1Execute, SqlProc ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetincomedataDeptMonth1(stdate As %Integer, dept As %Integer) As %Query(ROWSPEC = "deptname:%String,monthname:%String,locdr:%Integer,mony:%Integer,itemrowid:%Integer,itemname1:%String,item:%Integer,itemname:%String,sumfee:%Float") [ SqlProc ]
{
}

//科室直接成本查询

//d ##class(%ResultSet).RunQuery("web.RunqianQueryZgydZj","GetVouchDatasDeptItem","3")	

ClassMethod GetVouchDatasDeptItemExecute(ByRef qHandle As %Binary, dept As %Integer) As %Status [ SqlProc ]
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
	k ^temp($j)
	q:dept="" $$$OK
	
 	s RowId="",RowId2="",id="",monthname=""
     
    i $d(^DHCCAUNITDEPTS(dept)) s deptname=$p(^DHCCAUNITDEPTS(dept),"^",2)

    f  s RowId=$o(^DHCCAVOUCHDATAS(0,"Dept",dept,RowId)) q:RowId=""  d  
    .s itemDr=$p(^DHCCAVOUCHDATAS(RowId),"^",3)
    .s IntervalDr=$p(^DHCCAVOUCHDATAS(RowId),"^",1)
    .s VouchDatasdebit=$p(^DHCCAVOUCHDATAS(RowId),"^",16) //成本金额
    .f id=1:1:111  d  
    ..s RowId2=$o(^DHCCADATALEVELSETS(0,"Item",id,itemDr,RowId2)) q:RowId2=""
    ..s itemDr1=itemDr
    
    ..s ^temp($j,IntervalDr,itemDr1)=$g(^temp($j,IntervalDr,itemDr1))+VouchDatasdebit
    s locdr=0 f  s locdr=$o(^temp($j,locdr)) q:locdr=""  d
    
    .i $d(^DHCCAACCOUNTMONTHS(locdr)) s month=$p(^DHCCAACCOUNTMONTHS(locdr),"^",2)
    .s month1=$p(month,"-",1)

    .s monthname=month1_""_"年度"
    
    .s item=0 f  s item=$o(^temp($j,locdr,item)) q:item=""  d
    ..s sumamt=$g(^temp($j,locdr,item)) 
    ..d OutputRow2
    
     k ^temp($j)  
  	q $$$OK
OutputRow2
	;
  	s Data=$lb($g(monthname),$g(deptname),$g(locdr),$g(item),$fn(sumamt,"",2))
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
 //OutputRowWorkSum
    
 //ResetVariables
 //	 q
}

ClassMethod GetVouchDatasDeptItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetVouchDatasDeptItemExecute, SqlProc ]
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

ClassMethod GetVouchDatasDeptItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetVouchDatasDeptItemExecute, SqlProc ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetVouchDatasDeptItem(dept As %Integer) As %Query(ROWSPEC = "monthname:%String,deptname:%String,locdr:%Integer,item:%Integer,sumamt:%Double") [ SqlProc ]
{
}

//管理指标：d ##class(%ResultSet).RunQuery("web.RunqianQueryZgydZj","GetManagerZb")

ClassMethod GetManagerZbExecute(ByRef qHandle As %Binary) As %Status [ SqlProc ]
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	k ^temp($j)
 	s RowId="",RowId1="",RowIdIncome=""
  
    f  s RowId=$o(^DHCCAACCOUNTMONTHS(RowId))  q:RowId=""  d
    .s desc=$p(^DHCCAACCOUNTMONTHS(RowId),"^",2)
    .s year=$p(desc,"-",1)
    .q:year<"2011"
    
    .f  s RowIdIncome=$o(^DHCCAINCOMEDATAS(0,"Interval",RowId,RowIdIncome)) q:RowIdIncome=""  d
    ..s pattype=$p(^DHCCAINCOMEDATAS(RowIdIncome),"^",3) 
    ..s totalFee=$p(^DHCCAINCOMEDATAS(RowIdIncome),"^",7) 
    ..s ^temp($j,"zsr",year,pattype)=$g(^temp($j,"zsr",year,pattype))+totalFee
    
    ..s ItemDR=$p(^DHCCAINCOMEDATAS(RowIdIncome),"^",6)  //zjw 20140815add  药品收入
    ..s ItemparRef=3   //DATALEVELSETS 药品收入ID
    ..q:'$d(^DHCCADATALEVELSETS(0,"Item",ItemparRef,ItemDR))
    ..s ^temp($j,"zsr",year,ItemparRef)=$g(^temp($j,"zsr",year,ItemparRef))+totalFee
    
    /* 20140603 zjw 屏蔽
    .f  s RowId1=$o(^DHCCAPARAMDATAS(0,"Interval",RowId,RowId1)) q:RowId1=""  d
    ..s itemDr=$p(^DHCCAPARAMDATAS(RowId1),"^",4) 
    ..q:'$d(^DHCCADATALEVELSETS(0,"Item","27",itemDr))
    ..;q:itemDr=277  //???
    ..s fee=$p(^DHCCAPARAMDATAS(RowId1),"^",11) 
    ..s ^temp($j,"zsr",year,itemDr)=$g(^temp($j,"zsr",year,itemDr))+fee
    */ 
    s loc=0 f  s loc=$o(^temp($j,"zsr",loc)) q:loc=""  d
    .s type=0 f  s type=$o(^temp($j,"zsr",loc,type)) q:type=""  d
    ..s outdata=$g(^temp($j,"zsr",loc,type))
    ..d OutputRow3
	k ^temp($j)
 	q $$$OK
OutputRow3
    i type="O" s name="门诊收入"
 	i type="E" s name="急诊收入"
 	i type="I" s name="住院收入"
 	i type="H" s name="体检收入"
 	i type="3" s name="药品收入"   //zjw 20140815add
 	 	
	;i $d(^DHCCAALLDATAITEMS(type)) s name=$P(^DHCCAALLDATAITEMS(type),"^",3)	
 	s Data=$lb($g(loc),$g(type),$g(name),$g(outdata))
 	s ^CacheTemp(repid,ind)=Data	
	s ind=ind+1
	q
}

ClassMethod GetManagerZbFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetManagerZbExecute, SqlProc ]
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

ClassMethod GetManagerZbClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetManagerZbExecute, SqlProc ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetManagerZb() As %Query(ROWSPEC = "loc:%Integer,type:%String,name:%String,outdata:%Float") [ SqlProc ]
{
}

//总床位指标：d ##class(%ResultSet).RunQuery("web.RunqianQueryZgydZj","GetManagerBedZb")

ClassMethod GetManagerBedZbExecute(ByRef qHandle As %Binary) As %Status [ SqlProc ]
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	k ^temp($j)
 	s RowId="",RowId2=""
  
    f  s RowId=$o(^DHCCAACCOUNTMONTHS(RowId))  q:RowId=""  d
    .s desc=$p(^DHCCAACCOUNTMONTHS(RowId),"^",2)
    .s year=$p(desc,"-",1)
       
    .f  s RowId2=$o(^DHCCAPARAMDATAS(0,"Interval",RowId,RowId2)) q:RowId2=""  d
    ..s itemDr=$p(^DHCCAPARAMDATAS(RowId2),"^",4) q:itemDr'=493
    ..s fee=$p(^DHCCAPARAMDATAS(RowId2),"^",11) 
    ..s ^temp($j,"zsr",year,RowId)=$g(^temp($j,"zsr",year,RowId))+fee
         
    s loc1=0 f  s loc1=$o(^temp($j,"zsr",loc1)) q:loc1=""  d
    .s int=0 f  s int=$o(^temp($j,"zsr",loc1,int)) q:int=""  d
    ..s descy=$p(^DHCCAACCOUNTMONTHS(int),"^",2)
    ..s enday=$p(^DHCCAACCOUNTMONTHS(int),"^",5)
    ..s days=$p($zd(enday,3),"-",3)
    ..s outdata1=$g(^temp($j,"zsr",loc1,int))*days
    ..s ^temp($j,"zsr",loc1)=$g(^temp($j,"zsr",loc1))+outdata1
    
    s loc=0 f  s loc=$o(^temp($j,"zsr",loc)) q:loc=""  d
    .s outdata=$g(^temp($j,"zsr",loc))
    .d OutputRow4
    k ^temp($j)
 	q $$$OK
OutputRow4
   	s Data=$lb($g(loc),$fn($g(outdata),"",2))
 	s ^CacheTemp(repid,ind)=Data	
	s ind=ind+1
	q
}

ClassMethod GetManagerBedZbFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetManagerBedZbExecute, SqlProc ]
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

ClassMethod GetManagerBedZbClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetManagerBedZbExecute, SqlProc ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetManagerBedZb() As %Query(ROWSPEC = "loc:%Integer,outdata:%Float") [ SqlProc ]
{
}

//月管理指标：d ##class(%ResultSet).RunQuery("web.RunqianQueryZgydZj","GetManagerMonZb","2012")

ClassMethod GetManagerMonZbExecute(ByRef qHandle As %Binary, stdate As %String) As %Status [ SqlProc ]
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	q:stdate="" $$$OK
	k ^temp($j)
 	s RowId="",RowId1="",RowIdIncome="",RowIdq="",RowIdq1="",RowIdqz="",RowIdqz1=""
  
    f  s RowId=$o(^DHCCAACCOUNTMONTHS(RowId))  q:RowId=""  d
    .s desc=$p(^DHCCAACCOUNTMONTHS(RowId),"^",2)
    .s year=$p(desc,"-",1)
    .q:year'=stdate
    
    .f  s RowIdIncome=$o(^DHCCAINCOMEDATAS(0,"Interval",RowId,RowIdIncome)) q:RowIdIncome=""  d
    ..s pattype=$p(^DHCCAINCOMEDATAS(RowIdIncome),"^",3) 
    ..s totalFee=$p(^DHCCAINCOMEDATAS(RowIdIncome),"^",7)
    ..s ^temp($j,"zsr",RowId,pattype)=$g(^temp($j,"zsr",RowId,pattype))+totalFee
    
    .f  s RowIdq=$o(^DHCCAACCOUNTMONTHS(0,"Period",RowId,19,RowIdq)) q:RowIdq=""  d
 	..s monthDrq=$p(^DHCCAACCOUNTMONTHS(RowId,"Periods",RowIdq),"^",2)
 	..f  s RowIdq1=$o(^DHCCAINCOMEDATAS(0,"Interval",monthDrq,RowIdq1)) q:RowIdq1=""  d
    ...s pattypeq=$p(^DHCCAINCOMEDATAS(RowIdq1),"^",3) 
    ...s sumamtq1=$p(^DHCCAINCOMEDATAS(RowIdq1),"^",7) //去年同期收入
    ...s ^temp($j,"qnzsr",RowId,pattypeq)=$g(^temp($j,"qnzsr",RowId,pattypeq))+sumamtq1
     /*   20140603 zjw 屏蔽
    .f  s RowId1=$o(^DHCCAPARAMDATAS(0,"Interval",RowId,RowId1)) q:RowId1=""  d
    ..s itemDr=$p(^DHCCAPARAMDATAS(RowId1),"^",4) 
    ..q:'$d(^DHCCADATALEVELSETS(0,"Item","27",itemDr))
    ..s fee=$p(^DHCCAPARAMDATAS(RowId1),"^",11) 
    ..s ^temp($j,"zsr",RowId,itemDr)=$g(^temp($j,"zsr",RowId,itemDr))+fee
    
    .f  s RowIdqz=$o(^DHCCAACCOUNTMONTHS(0,"Period",RowId,4,RowIdqz)) q:RowIdqz=""  d
 	..s monthDrqzb=$p(^DHCCAACCOUNTMONTHS(RowId,"Periods",RowIdqz),"^",2)
    ..f  s RowIdqz1=$o(^DHCCAPARAMDATAS(0,"Interval",monthDrqzb,RowIdqz1)) q:RowIdqz1=""  d
    ...s itemDrq=$p(^DHCCAPARAMDATAS(RowIdqz1),"^",4) 
    ...q:'$d(^DHCCADATALEVELSETS(0,"Item","27",itemDrq))
    ...s feeq=$p(^DHCCAPARAMDATAS(RowIdqz1),"^",11)  //去年同期指标
    ...s ^temp($j,"qnzsr",RowId,itemDrq)=$g(^temp($j,"qnzsr",RowId,itemDrq))+feeq
    */
    s loc=0 f  s loc=$o(^temp($j,"zsr",loc)) q:loc=""  d
    .s type=0 f  s type=$o(^temp($j,"zsr",loc,type)) q:type=""  d
    ..s outdata=$g(^temp($j,"zsr",loc,type))_"^"_$g(^temp($j,"qnzsr",loc,type))  
    ..s today=$p(outdata,"^",1) 
    ..s ago=$p(outdata,"^",2)  
    ..d OutputRow5
     k ^temp($j)   
 	q $$$OK
OutputRow5
    
    q:'$d(^DHCCAACCOUNTMONTHS(loc))
    s descy=$p(^DHCCAACCOUNTMONTHS(loc),"^",2)
   
    s enday=$p(^DHCCAACCOUNTMONTHS(loc),"^",5)
    s days=$p($zd(enday,3),"-",3)
  
    s monthQ=+$p(descy,"-",2)
    s mony=+$p(descy,"-",2)_""_"月"
        
    i type="O" s name="门诊收入"
 	i type="E" s name="急诊收入"
 	i type="I" s name="住院收入"
 	i type="H" s name="体检收入"
	i $d(^DHCCAALLDATAITEMS(type)) s name=$P(^DHCCAALLDATAITEMS(type),"^",3)	
 	
    s Data=$lb($g(year),$g(loc),$g(mony),$g(type),$g(name),$g(today),$g(ago),$g(monthQ),$g(days))
 	s ^CacheTemp(repid,ind)=Data	
	s ind=ind+1
	q
}

ClassMethod GetManagerMonZbFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetManagerMonZbExecute, SqlProc ]
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

ClassMethod GetManagerMonZbClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetManagerMonZbExecute, SqlProc ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetManagerMonZb(stdate As %String) As %Query(ROWSPEC = "year:%String,loc:%Integer,mony:%String,type:%String,name:%String,outdata:%Float,ago:%Float,monthQ:%Integer,days:%Integer") [ SqlProc ]
{
}

//科室月管理指标：d ##class(%ResultSet).RunQuery("web.RunqianQueryZgydZj","GetDeptManagerMonZb","1","3")

ClassMethod GetDeptManagerMonZbExecute(ByRef qHandle As %Binary, stdate As %Integer, dept As %Integer) As %Status [ SqlProc ]
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	q:stdate="" $$$OK
	q:dept="" $$$OK
	k ^temp($j)
 	
 	i $d(^DHCCAUNITDEPTS(dept)) s deptname=$p(^DHCCAUNITDEPTS(dept),"^",2)
 	s RowIddep=""
 	s RowId1="",RowIdIncome="",RowIdq="",RowIdq1="",RowIdqz="",RowIdqz1=""
    
    i $d(^DHCCAACCOUNTMONTHS(stdate)) d
	.s month=$p(^DHCCAACCOUNTMONTHS(stdate),"^",2)
    .s year=$p(month,"-",1)
    .s yearname=year_""_"年度"
    
    f  s RowIddep=$o(^DHCCAACCOUNTMONTHS(RowIddep))  q:RowIddep=""  d
    .s desc=$p(^DHCCAACCOUNTMONTHS(RowIddep),"^",2)
    .s mon=+$p(desc,"-",2)_""_"月"
    .s desc1=$p(desc,"-",1)
    .q:desc1'=year 
    .s ^temp($j,RowIddep)=$g(^temp($j,RowIddep))
    .s RowId=RowIddep
      
    .f  s RowIdIncome=$o(^DHCCAINCOMEDATAS(0,"IntervalFdeptdr",RowId,dept,RowIdIncome)) q:RowIdIncome=""  d
    ..s pattype=$p(^DHCCAINCOMEDATAS(RowIdIncome),"^",3) 
    ..s totalFee=$p(^DHCCAINCOMEDATAS(RowIdIncome),"^",7) 
    ..s ^temp($j,"zsr",RowId,pattype)=$g(^temp($j,"zsr",RowId,pattype))+totalFee

    .f  s RowIdq=$o(^DHCCAACCOUNTMONTHS(0,"Period",RowId,19,RowIdq)) q:RowIdq=""  d  //7对应AccPeriod表去年同期id
 	..s monthDrq=$p(^DHCCAACCOUNTMONTHS(RowId,"Periods",RowIdq),"^",2)
 	..f  s RowIdq1=$o(^DHCCAINCOMEDATAS(0,"IntervalFdeptdr",monthDrq,dept,RowIdq1)) q:RowIdq1=""  d
    ...s pattypeq=$p(^DHCCAINCOMEDATAS(RowIdq1),"^",3) 
    ...s sumamtq1=$p(^DHCCAINCOMEDATAS(RowIdq1),"^",7) //去年同期收入
    ...s ^temp($j,"qnzsr",RowId,pattypeq)=$g(^temp($j,"qnzsr",RowId,pattypeq))+sumamtq1
  
     /*  //20140604 zjw 屏蔽
    .f  s RowId1=$o(^DHCCAPARAMDATAS(0,"IntervalSereddep",RowId,dept,RowId1)) q:RowId1=""  d
    ..s itemDr=$p(^DHCCAPARAMDATAS(RowId1),"^",4) 
    ..q:'$d(^DHCCADATALEVELSETS(0,"Item","27",itemDr))
    ..s fee=$p(^DHCCAPARAMDATAS(RowId1),"^",11) 
    ..s ^temp($j,"zsr",RowId,itemDr)=$g(^temp($j,"zsr",RowId,itemDr))+fee
    
    .f  s RowIdqz=$o(^DHCCAACCOUNTMONTHS(0,"Period",RowId,19,RowIdqz)) q:RowIdqz=""  d
 	..s monthDrqzb=$p(^DHCCAACCOUNTMONTHS(RowId,"Periods",RowIdqz),"^",2)
    ..f  s RowIdqz1=$o(^DHCCAPARAMDATAS(0,"IntervalSereddep",monthDrqzb,dept,RowIdqz1)) q:RowIdqz1=""  d
    ...s itemDrq=$p(^DHCCAPARAMDATAS(RowIdqz1),"^",4) 
    ...q:'$d(^DHCCADATALEVELSETS(0,"Item","27",itemDrq))
    ...s feeq=$p(^DHCCAPARAMDATAS(RowIdqz1),"^",11)  //去年同期指标
    ...s ^temp($j,"qnzsr",RowId,itemDrq)=$g(^temp($j,"qnzsr",RowId,itemDrq))+feeq
    */
    s loc=0 f  s loc=$o(^temp($j,"zsr",loc)) q:loc=""  d
    .s type=0 f  s type=$o(^temp($j,"zsr",loc,type)) q:type=""  d
    ..s outdata=$g(^temp($j,"zsr",loc,type))_"^"_$g(^temp($j,"qnzsr",loc,type))  
    ..s today=$p(outdata,"^",1) 
    ..s ago=$p(outdata,"^",2)  
    ..d OutputRow6
     
    k ^temp($j)   
 	q $$$OK
OutputRow6
    
    q:'$d(^DHCCAACCOUNTMONTHS(loc))
    s descy=$p(^DHCCAACCOUNTMONTHS(loc),"^",2)
   
    s enday=$p(^DHCCAACCOUNTMONTHS(loc),"^",5)
    s days=$p($zd(enday,3),"-",3)
  
    s monthQ=+$p(descy,"-",2)
    s mony=+$p(descy,"-",2)_""_"月"
        
    i type="O" s name="门诊收入"
 	i type="E" s name="急诊收入"
 	i type="I" s name="住院收入"
 	i type="H" s name="体检收入"
	i $d(^DHCCAALLDATAITEMS(type)) s name=$P(^DHCCAALLDATAITEMS(type),"^",3)	
 	
    s Data=$lb($g(yearname),$g(loc),$g(mony),$g(type),$g(name),$g(today),$g(ago),$g(monthQ),$g(days),$g(deptname))
 	s ^CacheTemp(repid,ind)=Data	
	s ind=ind+1
	q
}

ClassMethod GetDeptManagerMonZbFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDeptManagerMonZbExecute, SqlProc ]
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

ClassMethod GetDeptManagerMonZbClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDeptManagerMonZbExecute, SqlProc ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetDeptManagerMonZb(stdate As %Integer, dept As %Integer) As %Query(ROWSPEC = "yearname:%String,loc:%Integer,mony:%String,type:%String,name:%String,outdata:%Float,ago:%Float,monthQ:%Integer,days:%Integer,deptname:%String") [ SqlProc ]
{
}

//全院收入：d ##class(%ResultSet).RunQuery("web.RunqianQueryZgydZj","GetIncomeZ","2010")

ClassMethod GetIncomeZExecute(ByRef qHandle As %Binary, stdate As %String) As %Status [ SqlProc ]
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	q:stdate="" $$$OK
	k ^temp($j)
	s sumfee="",totalFee="",totalyaoFee="",totalzsr=""

 	s RowIdY="",RowId="",RowId1="",RowIdIncome="",itemdr=""
 	s RowIdq="",RowIdq1="",RowIdqy="",RowIdqy1=""
  
    f  s RowId=$o(^DHCCAACCOUNTMONTHS(RowId))  q:RowId=""  d
    .s desc=$p(^DHCCAACCOUNTMONTHS(RowId),"^",2)
    .s year=$p(desc,"-",1)
    .q:year'=stdate
    .f  s RowIdIncome=$o(^DHCCAINCOMEDATAS(0,"Interval",RowId,RowIdIncome)) q:RowIdIncome=""  d
    ..s pattype=$p(^DHCCAINCOMEDATAS(RowIdIncome),"^",3) 
    ..s totalFee=$p(^DHCCAINCOMEDATAS(RowIdIncome),"^",7) 
    ..s ^temp($j,"zsr",RowId,pattype)=$g(^temp($j,"zsr",RowId,pattype))+totalFee
    
    s loc=0 f  s loc=$o(^temp($j,"zsr",loc)) q:loc=""  d
    .s type=0 f  s type=$o(^temp($j,"zsr",loc,type)) q:type=""  d
    ..s outdata=$g(^temp($j,"zsr",loc,type))
    ..d OutputRow7
    
    k ^temp($j)
 	;输出合计
 	;d OutputRowWorkSum
 	q $$$OK
OutputRow7
	
 	q:'$d(^DHCCAACCOUNTMONTHS(loc))
    s descy=$p(^DHCCAACCOUNTMONTHS(loc),"^",2)
    s moncode=$p(^DHCCAACCOUNTMONTHS(loc),"^",1)
    s monthQ=+$p(descy,"-",2)
    s mony=+$p(descy,"-",2)_""_"月"
 	i type="O" s srname="门诊收入"
 	i type="E" s srname="急诊收入"
 	i type="I" s srname="住院收入"
 	i type="H" s srname="体检收入"
 	
 	s Data=$lb($g(loc),$g(moncode),$g(mony),srname,$fn($g(outdata),"",2))
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod GetIncomeZFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetIncomeZExecute, SqlProc ]
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

ClassMethod GetIncomeZClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetIncomeZExecute, SqlProc ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetIncomeZ(stdate As %String) As %Query(ROWSPEC = "loc:%Integer,moncode:%Integer,mony:%String,srname:%String,outdata:%Float") [ SqlProc ]
{
}

//科室医师工作量数据：d ##class(%ResultSet).RunQuery("web.RunqianQueryZgydZj","GetDeptDocGzl","13","83")

ClassMethod GetDeptDocGzlExecute(ByRef qHandle As %Binary, stdate As %Integer, dept As %Integer) As %Status [ SqlProc ]
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	q:stdate="" $$$OK
	q:dept="" $$$OK
	k ^temp($j)
 	
 	i $d(^DHCCAUNITDEPTS(dept)) s deptname=$p(^DHCCAUNITDEPTS(dept),"^",2)
 	s RowIddep=""
 	s RowId1="",RowId2="",RowId3=""
    
    i $d(^DHCCAACCOUNTMONTHS(stdate)) d
	.s month=$p(^DHCCAACCOUNTMONTHS(stdate),"^",2)
    .s year=$p(month,"-",1)
    .s yearname=year_""_"年度"
    
    f  s RowIddep=$o(^DHCCAACCOUNTMONTHS(RowIddep))  q:RowIddep=""  d
    .s desc=$p(^DHCCAACCOUNTMONTHS(RowIddep),"^",2)
    .s mon=+$p(desc,"-",2)_""_"月"
    .s desc1=$p(desc,"-",1)
    .q:desc1'=year 
    .s ^temp($j,RowIddep)=$g(^temp($j,RowIddep))
    .s RowId=RowIddep
 
    .f  s RowId3=$o(^DHCCAINCOMEDATAS(0,"IntervalFdeptdr",RowId,dept,RowId3)) q:RowId3=""  d
    ..s fee=$p(^DHCCAINCOMEDATAS(RowId3),"^",7) 
    ..s Docdr3=$p(^DHCCAINCOMEDATAS(RowId3),"^",30)  
    ..i Docdr3'="" s ^temp($j,"zsr",RowId,Docdr3)=$g(^temp($j,"zsr",RowId,Docdr3))+fee  //科室医师每月开单总收入
          
    .f  s RowId1=$o(^DHCCAINCOMEDATAS(0,"IntervalFdeptdr",RowId,dept,RowId1)) q:RowId1=""  d
    ..s itemDr=$p(^DHCCAINCOMEDATAS(RowId1),"^",6) ;q:itemDr=""
    ..q:'$d(^DHCCADATALEVELSETS(0,"Item","6",itemDr))
    ..s yaofee=$p(^DHCCAINCOMEDATAS(RowId1),"^",7) 
    ..s Docdr=$p(^DHCCAINCOMEDATAS(RowId1),"^",30)  
    ..i Docdr'="" s ^temp($j,"ys",RowId,Docdr)=$g(^temp($j,"ys",RowId,Docdr))+yaofee  //科室医师每月总开药费
          
    .f  s RowId2=$o(^DHCCAPARAMDATAS(0,"IntervalSereddep",RowId,dept,RowId2)) q:RowId2=""  d
    ..s itemDr1=$p(^DHCCAPARAMDATAS(RowId2),"^",4) q:(itemDr1'=200)&&(itemDr1'=201) //zjw 门诊医师工作量、住院医师工作量
    ..s fDocdr=$p(^DHCCAPARAMDATAS(RowId2),"^",18) 
    ..s fee=$p(^DHCCAPARAMDATAS(RowId2),"^",11) 
    ..i fDocdr'="" s ^temp($j,"ysgzl",RowId,fDocdr)=$g(^temp($j,"ysgzl",RowId,fDocdr))+fee
      
    s loc=0 f  s loc=$o(^temp($j,"zsr",loc)) q:loc=""  d
    .s doc=0 f  s doc=$o(^temp($j,"zsr",loc,doc)) q:doc=""  d
    ..s person=$p(^DHCCAUNITPERSONS(doc),"^",2)
    ..s outdata=$g(^temp($j,"zsr",loc,doc))_"^"_$g(^temp($j,"ys",loc,doc))_"^"_$g(^temp($j,"ysgzl",loc,doc))  
    ..s docfee=$p(outdata,"^",1)
    ..s docyao=$p(outdata,"^",2) 
    ..s docgzl=$p(outdata,"^",3)  
    ..d OutputRow8
    
    k ^temp($j)    
 	q $$$OK
OutputRow8
    
    s descy=$p(^DHCCAACCOUNTMONTHS(loc),"^",2)
    s monthQ=+$p(descy,"-",2)
    s mony=+$p(descy,"-",2)_""_"月"
    
    s Data=$lb($g(yearname),$g(loc),$g(mony),$g(monthQ),$g(doc),$g(person),$fn($g(docfee),"",2),$fn($g(docyao),"",2),$fn($g(docgzl),"",2),$g(deptname))
    s ^CacheTemp(repid,ind)=Data	
	s ind=ind+1
	q
}

ClassMethod GetDeptDocGzlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDeptDocGzlExecute, SqlProc ]
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

ClassMethod GetDeptDocGzlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDeptDocGzlExecute, SqlProc ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetDeptDocGzl(stdate As %Integer, dept As %Integer) As %Query(ROWSPEC = "yearname:%String,loc:%Integer,mony:%String,monthQ:%Integer,doc:%String,person:%String,docfee:%Float,docyao:%Float,docgzl:%Float,deptname:%String") [ SqlProc ]
{
}

//年度业务收入指标分析：d ##class(%ResultSet).RunQuery("web.RunqianQueryZgydZj","GetYWSRZb")

ClassMethod GetYWSRZbExecute(ByRef qHandle As %Binary) As %Status [ SqlProc ]
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	k ^temp($j)
 	s RowId="",RowId1="",RowId2="",RowIdIncome="",RowIdIncomeZ=""
 
    f  s RowId=$o(^DHCCAACCOUNTMONTHS(RowId))  q:RowId=""  d
    .s desc=$p(^DHCCAACCOUNTMONTHS(RowId),"^",2)
    .s year=$p(desc,"-",1)
    .q:year<"2006"

    .f  s RowIdIncome=$o(^DHCCAINCOMEDATAS(0,"Interval",RowId,RowIdIncome)) q:RowIdIncome=""  d
    ..s pattype=$p(^DHCCAINCOMEDATAS(RowIdIncome),"^",3) 
    ..q:(pattype'="O")&&(pattype'="E") 
    ..s totalFee=$p(^DHCCAINCOMEDATAS(RowIdIncome),"^",7) 
    ..s ^temp($j,"mzsr",year)=$g(^temp($j,"mzsr",year))+totalFee //门、急诊收入   
    ..s item=$p(^DHCCAINCOMEDATAS(RowIdIncome),"^",6) q:item=""
    ..q:('$d(^DHCCADATALEVELSETS(0,"Item","6",item)))  //&&('$d(^DHCCADATALEVELSETS(0,"Item","34",item)))
    ..s fee=$p(^DHCCAINCOMEDATAS(RowIdIncome),"^",7) 
    ..i $d(^DHCCADATALEVELSETS(0,"Item","6",item)) d
    ...s yaofee=fee  
    ...s ^temp($j,"myfsr",year)=$g(^temp($j,"myfsr",year))+yaofee  //门诊药费
          
    .f  s RowIdIncomeZ=$o(^DHCCAINCOMEDATAS(0,"Interval",RowId,RowIdIncomeZ)) q:RowIdIncomeZ=""  d
    ..s pattype=$p(^DHCCAINCOMEDATAS(RowIdIncomeZ),"^",3) 
    ..q:pattype'="I"
    ..s ZtotalFee=$p(^DHCCAINCOMEDATAS(RowIdIncomeZ),"^",7) 
    ..s ^temp($j,"zysr",year)=$g(^temp($j,"zysr",year))+ZtotalFee //住院收入 
    ..s itemz=$p(^DHCCAINCOMEDATAS(RowIdIncomeZ),"^",6)  q:itemz=""
    ..q:('$d(^DHCCADATALEVELSETS(0,"Item","6",itemz)))  //&&('$d(^DHCCADATALEVELSETS(0,"Item","34",itemz)))
    ..s zfee=$p(^DHCCAINCOMEDATAS(RowIdIncomeZ),"^",7) 
    ..i $d(^DHCCADATALEVELSETS(0,"Item","6",itemz)) d
    ...s zyaofee=zfee  
    ...s ^temp($j,"zyyfsr",year)=$g(^temp($j,"zyyfsr",year))+zyaofee  //住院药费
             
    
    .f  s RowId1=$o(^DHCCAPARAMDATAS(0,"Interval",RowId,RowId1)) q:RowId1=""  d
    ..s itemmz=$p(^DHCCAPARAMDATAS(RowId1),"^",4) 
    ..q:(itemmz'=494)&&(itemmz'=497)&&(itemmz'=501)&&(itemmz'=502)&&(itemmz'=199)&&(itemmz'=500)&&(itemmz'=498)&&(itemmz'=202)&&(itemmz'=205)&&(itemmz'=203)&&(itemmz'=206)&&(itemmz'=204)
    ..;q:(itemmz'=174)&&(itemmz'=191)&&(itemmz'=197)&&(itemmz'=198)&&(itemmz'=196)&&(itemmz'=193)&&(itemmz'=202)&&(itemmz'=205)&&(itemmz'=203)&&(itemmz'=206)&&(itemmz'=204)
    ..s rc=$p(^DHCCAPARAMDATAS(RowId1),"^",11) 
    ..If (itemmz="494") { 
    ..s mzrc=rc
    ..s ^temp($j,"mzrc",year)=$g(^temp($j,"mzrc",year))+mzrc   //494门诊人次
    ..}ElseIf (itemmz="497") {
    ..s cyrs=rc
    ..s ^temp($j,"cyrs",year)=$g(^temp($j,"cyrs",year))+cyrs  //497出院人数
    ..}ElseIf (itemmz="501") {
    ..s mzyb=rc
    ..s ^temp($j,"mzyb",year)=$g(^temp($j,"mzyb",year))+mzyb  //501门诊医保人次
    ..}ElseIf (itemmz="502") {
    ..s zyyb=rc
    ..s ^temp($j,"zyyb",year)=$g(^temp($j,"zyyb",year))+zyyb  //502住院医保人次
    ..}ElseIf (itemmz="199") {
    ..;s cyfy=rc
    ..s zysr=rc
    ..;s ^temp($j,"cyfy",year)=$g(^temp($j,"cyfy",year))+cyfy  //199出院病人费用--临时修改
    ..s ^temp($j,"zysr",year)=$g(^temp($j,"zysr",year))+zysr  //199住院收入
    ..}ElseIf (itemmz="500") {
    ..s cyzyts=rc
    ..s ^temp($j,"cyzyts",year)=$g(^temp($j,"cyzyts",year))+cyzyts  //500出院患者住院天数
    ..}ElseIf (itemmz="498") {
	..s zyrs=rc
    ..s ^temp($j,"zyrs",year)=$g(^temp($j,"zyrs",year))+zyrs  //498在院人数
	..}ElseIf (itemmz="202") {
	..;s cyypfy=rc
    ..;s ^temp($j,"cyypfy",year)=$g(^temp($j,"cyypfy",year))+cyypfy  //202出院患者药品费用2011-01-29增加以下
    ..s zyyfsr=rc
    ..s ^temp($j,"zyyfsr",year)=$g(^temp($j,"zyyfsr",year))+zyyfsr
    ..}ElseIf (itemmz="205") {
    ..s mzybfy=rc
    ..s ^temp($j,"mzybfy",year)=$g(^temp($j,"mzybfy",year))+mzybfy  //205门诊医保患者费用
    ..}ElseIf (itemmz="203") {
    ..s mzybypfy=rc
    ..s ^temp($j,"mzybypfy",year)=$g(^temp($j,"mzybypfy",year))+mzybypfy  //203门诊医保患者药品费用
    ..}ElseIf (itemmz="206") {
	..s zyybfy=rc
    ..s ^temp($j,"zyybfy",year)=$g(^temp($j,"zyybfy",year))+zyybfy  //206住院医保患者费用
	..}ElseIf (itemmz="204") {
	..s zyybypfy=rc
    ..s ^temp($j,"zyybypfy",year)=$g(^temp($j,"zyybypfy",year))+zyybypfy  //204住院医保患者药品费用
    ..}
       
    s loc=0 f  s loc=$o(^temp($j,"zsr",loc)) q:loc=""  d
    .s type=0 f  s type=$o(^temp($j,"zsr",loc,type)) q:type=""  d
    ..s outdata=$g(^temp($j,"zsr",loc,type))
 
    s loc=0 f  s loc=$o(^temp($j,"mzsr",loc)) q:loc=""  d
    .s outdata1=$g(^temp($j,"mzsr",loc))_"^"_$g(^temp($j,"myfsr",loc))_"^"_$g(^temp($j,"mzrc",loc))_"^"_$g(^temp($j,"cyrs",loc))_"^"_$g(^temp($j,"zysr",loc))_"^"_$g(^temp($j,"cyzyts",loc))_"^"_$g(^temp($j,"zyrs",loc))_"^"_$g(^temp($j,"zyyfsr",loc))
    .s outdata=outdata1_"^"_$g(^temp($j,"mzyb",loc))_"^"_$g(^temp($j,"zyyb",loc))_"^"_$g(^temp($j,"mzybfy",loc))_"^"_$g(^temp($j,"mzybypfy",loc))_"^"_$g(^temp($j,"zyybfy",loc))_"^"_$g(^temp($j,"zyybypfy",loc))
    
 	.s mzsrsum=$p(outdata,"^",1)
 	.s myfsrsum=$p(outdata,"^",2)
 	.s mzylfsum=mzsrsum-myfsrsum
 	.s mzrcsum=$p(outdata,"^",3)
 	.s cyrssum=$p(outdata,"^",4)
 	.s cyfysum=$p(outdata,"^",5) ////出院费用
 	.s cyzytssum=$p(outdata,"^",6)
 	.s zyrssum=$p(outdata,"^",7)
 	.s cyypfysum=$p(outdata,"^",8)
 	.s cyylfsum=cyfysum-cyypfysum
 	.s mzybsum=$p(outdata,"^",9)
 	.s zyybsum=$p(outdata,"^",10)
 	.s mzybfysum=$p(outdata,"^",11)
 	.s mzybypfysum=$p(outdata,"^",12)
 	.s zyybypfysum=$p(outdata,"^",13)
    .d OutputRow9
    k ^temp($j)

 	q $$$OK
OutputRow9
     	 	
	s Data=$lb($g(loc),$fn($g(mzsrsum),"",2),$fn($g(myfsrsum),"",2),$fn($g(mzylfsum),"",2),$fn($g(mzrcsum),"",2),$fn($g(cyrssum),"",2),$fn($g(cyfysum),"",2),$fn($g(cyzytssum),"",2),$fn($g(zyrssum),"",2),$fn($g(cyypfysum),"",2),$fn($g(cyylfsum),"",2),$fn($g(mzybsum),"",2),$fn($g(zyybsum),"",2),$fn($g(mzybfysum),"",2),$fn($g(mzybypfysum),"",2),$fn($g(zyybypfysum),"",2))
 	s ^CacheTemp(repid,ind)=Data	
	s ind=ind+1
	q
}

ClassMethod GetYWSRZbFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetYWSRZbExecute, SqlProc ]
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

ClassMethod GetYWSRZbClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetYWSRZbExecute, SqlProc ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetYWSRZb() As %Query(ROWSPEC = "loc:%Integer,mzsrsum:%Float,myfsrsum:%Float,mzylfsum:%Float,mzrcsum:%Float,cyrssum:%Float,cyfysum:%Float,cyzytssum:%Float,zyrssum:%Float,cyypfysum:%Float,cyylfsum:%Float,mzybsum:%Float,zyybsum:%Float,mzybfysum:%Float,mzybypfysum:%Float,zyybypfysum:%Float") [ SqlProc ]
{
}

//出院人数月度指标：d ##class(%ResultSet).RunQuery("web.RunqianQueryZgydZj","GetCyrsZb")

ClassMethod GetCyrsZbExecute(ByRef qHandle As %Binary) As %Status [ SqlProc ]
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	;q:stdate="" $$$OK
	k ^temp($j)
 	s RowId="",RowId1="",RowIdIncome="",RowIdq="",RowIdq1="",RowIdqz="",RowIdqz1=""
  
    f  s RowId=$o(^DHCCAACCOUNTMONTHS(RowId))  q:RowId=""  d
    .s desc=$p(^DHCCAACCOUNTMONTHS(RowId),"^",2)
    .s year=$p(desc,"-",1)
    .q:year<"2009"
    
    .f  s RowId1=$o(^DHCCAPARAMDATAS(0,"Interval",RowId,RowId1)) q:RowId1=""  d
    ..s itemDr=$p(^DHCCAPARAMDATAS(RowId1),"^",4) 
    ..q:itemDr'="143"   //出院人数
    ..;q:'$d(^DHCCADATALEVELSETS(0,"Item","30",itemDr))
    ..s fee=$p(^DHCCAPARAMDATAS(RowId1),"^",11) 
    ..s ^temp($j,"zsr",year,RowId,itemDr)=$g(^temp($j,"zsr",year,RowId,itemDr))+fee
    
    s locy=0 f  s locy=$o(^temp($j,"zsr",locy)) q:locy=""  d
    .s loc=0 f  s loc=$o(^temp($j,"zsr",locy,loc)) q:loc=""  d
    ..s type=0 f  s type=$o(^temp($j,"zsr",locy,loc,type)) q:type=""  d
    ...s outdata=$g(^temp($j,"zsr",locy,loc,type))
    ...s today=$p(outdata,"^",1) 
    ...d OutputRow10
     
    k ^temp($j)   
 	q $$$OK
OutputRow10
    
    q:'$d(^DHCCAACCOUNTMONTHS(loc))
    s descy=$p(^DHCCAACCOUNTMONTHS(loc),"^",2)
   
    s monthQ=+$p(descy,"-",2)
    s mony=+$p(descy,"-",2)_""_"月"
 
	i $d(^DHCCAALLDATAITEMS(type)) s name=$P(^DHCCAALLDATAITEMS(type),"^",3)
	//季度取值	
 	i (monthQ=1)!(monthQ=2)!(monthQ=3) s jd=1
 	i (monthQ=4)!(monthQ=5)!(monthQ=6) s jd=2
 	i (monthQ=7)!(monthQ=8)!(monthQ=9) s jd=3
 	i (monthQ=10)!(monthQ=11)!(monthQ=12) s jd=4
 	//半年度取值
 	i (monthQ=1)!(monthQ=2)!(monthQ=3)!(monthQ=4)!(monthQ=5)!(monthQ=6) s nd="上半年"
 	i (monthQ=7)!(monthQ=8)!(monthQ=9)!(monthQ=10)!(monthQ=11)!(monthQ=12) s nd="下半年"
   // s Data=$lb($g(year),$g(loc),$g(mony),$g(type),$g(name),$fn($g(today),"",2),$fn($g(ago),"",2),$g(monthQ),$g(days))
    s Data=$lb($g(locy),$g(loc),$g(mony),$g(type),$g(name),$fn($g(today),"",2),$g(monthQ),$g(jd),$g(nd))
 	s ^CacheTemp(repid,ind)=Data	
	s ind=ind+1
	q
}

ClassMethod GetCyrsZbFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCyrsZbExecute, SqlProc ]
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

ClassMethod GetCyrsZbClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCyrsZbExecute, SqlProc ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetCyrsZb() As %Query(ROWSPEC = "locy:%String,loc:%Integer,mony:%String,type:%String,name:%String,outdata:%Float,monthQ:%Integer,jd:%Integer,nd:%String") [ SqlProc ]
{
}

//门诊人次月度指标：d ##class(%ResultSet).RunQuery("web.RunqianQueryZgydZj","GetMzrcZb")

ClassMethod GetMzrcZbExecute(ByRef qHandle As %Binary) As %Status [ SqlProc ]
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	;q:stdate="" $$$OK
	k ^temp($j)
 	s RowId="",RowId1="",RowIdIncome="",RowIdq="",RowIdq1="",RowIdqz="",RowIdqz1=""
  
    f  s RowId=$o(^DHCCAACCOUNTMONTHS(RowId))  q:RowId=""  d
    .s desc=$p(^DHCCAACCOUNTMONTHS(RowId),"^",2)
    .s year=$p(desc,"-",1)
    .q:year<"2009"
    
    .f  s RowId1=$o(^DHCCAPARAMDATAS(0,"Interval",RowId,RowId1)) q:RowId1=""  d
    ..s itemDr=$p(^DHCCAPARAMDATAS(RowId1),"^",4) 
    ..q:itemDr'="141" //门诊人次
    ..;q:'$d(^DHCCADATALEVELSETS(0,"Item","30",itemDr))
    ..s fee=$p(^DHCCAPARAMDATAS(RowId1),"^",11) 
    ..s ^temp($j,"zsr",year,RowId,itemDr)=$g(^temp($j,"zsr",year,RowId,itemDr))+fee
    
    s locy=0 f  s locy=$o(^temp($j,"zsr",locy)) q:locy=""  d
    .s loc=0 f  s loc=$o(^temp($j,"zsr",locy,loc)) q:loc=""  d
    ..s type=0 f  s type=$o(^temp($j,"zsr",locy,loc,type)) q:type=""  d
    ...s outdata=$g(^temp($j,"zsr",locy,loc,type))
    ...s today=$p(outdata,"^",1) 
    ...d OutputRow11
    
    k ^temp($j)   
 	q $$$OK
OutputRow11
    
    q:'$d(^DHCCAACCOUNTMONTHS(loc))
    s descy=$p(^DHCCAACCOUNTMONTHS(loc),"^",2)
   
    s monthQ=+$p(descy,"-",2)
    s mony=+$p(descy,"-",2)_""_"月"
 
	i $d(^DHCCAALLDATAITEMS(type)) s name=$P(^DHCCAALLDATAITEMS(type),"^",3)	
 	//季度取值	
 	i (monthQ=1)!(monthQ=2)!(monthQ=3) s jd=1
 	i (monthQ=4)!(monthQ=5)!(monthQ=6) s jd=2
 	i (monthQ=7)!(monthQ=8)!(monthQ=9) s jd=3
 	i (monthQ=10)!(monthQ=11)!(monthQ=12) s jd=4
 	//半年度取值
 	i (monthQ=1)!(monthQ=2)!(monthQ=3)!(monthQ=4)!(monthQ=5)!(monthQ=6) s nd="上半年"
 	i (monthQ=7)!(monthQ=8)!(monthQ=9)!(monthQ=10)!(monthQ=11)!(monthQ=12) s nd="下半年"
   // s Data=$lb($g(year),$g(loc),$g(mony),$g(type),$g(name),$fn($g(today),"",2),$fn($g(ago),"",2),$g(monthQ),$g(days))
    s Data=$lb($g(locy),$g(loc),$g(mony),$g(type),$g(name),$fn($g(today),"",2),$g(monthQ),$g(jd),$g(nd))
 	s ^CacheTemp(repid,ind)=Data	
	s ind=ind+1
	q
}

ClassMethod GetMzrcZbFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMzrcZbExecute, SqlProc ]
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

ClassMethod GetMzrcZbClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMzrcZbExecute, SqlProc ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetMzrcZb() As %Query(ROWSPEC = "locy:%String,loc:%Integer,mony:%String,type:%String,name:%String,outdata:%Float,monthQ:%Integer,jd:%Integer,nd:%String") [ SqlProc ]
{
}

//绩效考核指标输出：d ##class(%ResultSet).RunQuery("web.RunqianQueryZgydZj","GetPAJxZb","65")

ClassMethod GetPAJxZbExecute(ByRef qHandle As %Binary, stdate As %Integer) As %Status [ SqlProc ]
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	q:stdate="" $$$OK
	
	k ^temp($j)
 	s RowId=stdate,RowId1="",RowId2="",RowIdIncomezj="",RowIdZj="",RowIdIncome=""
        
    f  s RowIdIncome=$o(^DHCCAINCOMEDATAS(0,"Interval",RowId,RowIdIncome)) q:RowIdIncome=""  d
    .s fdeptdr=$p(^DHCCAINCOMEDATAS(RowIdIncome),"^",11) 
    .q:'$d(^DHCCADEPTLEVELSETS(0,"Dept",16,fdeptdr))  //非配置的直接医疗科室的退出
    .s totalFee=$p(^DHCCAINCOMEDATAS(RowIdIncome),"^",7) 
    .s ^temp($j,fdeptdr,"zsr")=$g(^temp($j,fdeptdr,"zsr"))+totalFee //总收入   
    .s item=$p(^DHCCAINCOMEDATAS(RowIdIncome),"^",6) q:item=""
    .q:('$d(^DHCCADATALEVELSETS(0,"Item","3",item)))  
    .s fee=$p(^DHCCAINCOMEDATAS(RowIdIncome),"^",7) 
    .i $d(^DHCCADATALEVELSETS(0,"Item","3",item)) d
    ..s yaofee=fee  
    ..s ^temp($j,fdeptdr,"yfsr")=$g(^temp($j,fdeptdr,"yfsr"))+yaofee  //药费
    
    f  s RowIdIncomezj=$o(^DHCCAINCOMEDATAS(0,"Interval",RowId,RowIdIncomezj)) q:RowIdIncomezj=""  d
    .s fdeptdr1=$p(^DHCCAINCOMEDATAS(RowIdIncomezj),"^",11) 
    .q:'$d(^DHCCADEPTLEVELSETS(0,"Dept",16,fdeptdr1))  //非配置的直接医疗科室的退出
    .s tdeptdr1=$p(^DHCCAINCOMEDATAS(RowIdIncomezj),"^",14)
    .q:tdeptdr1'=fdeptdr1  //lxc-2011-02-23 add
    .s totalFeezj=$p(^DHCCAINCOMEDATAS(RowIdIncomezj),"^",7) 
    .s ^temp($j,fdeptdr1,"zjzsr")=$g(^temp($j,fdeptdr1,"zjzsr"))+totalFeezj //自己开单自己执行总收入   
         
    f  s RowIdZj=$o(^DHCCACOSTDISTSETS(1,"CostResultSum",RowIdZj)) q:RowIdZj=""   d
    .s inter=$p(^DHCCACOSTDISTSETS(1,"CostResultSum",RowIdZj),"^",1) q:inter'=RowId
    .s flag=$p(^DHCCACOSTDISTSETS(1,"CostResultSum",RowIdZj),"^",2) q:flag'="leaf"
    .s deptc=$p(^DHCCACOSTDISTSETS(1,"CostResultSum",RowIdZj),"^",3) 
    .q:'$d(^DHCCADEPTLEVELSETS(0,"Dept",16,deptc))  //非配置的直接医疗科室的退出
    .s zjcost=$p(^DHCCACOSTDISTSETS(1,"CostResultSum",RowIdZj),"^",4) //直接成本
    .;s Zcost=$p(^DHCCACOSTDISTSETS(1,"CostResultSum",RowIdZj),"^",7) //总成本
    .;s ^temp($j,deptc,"zcost")=$g(^temp($j,deptc,"zcost"))+Zcost //总成本
    .s ^temp($j,deptc,"zjcost")=$g(^temp($j,deptc,"zjcost"))+zjcost //总直接成本
    
    f  s RowId1=$o(^DHCCAPARAMDATAS(0,"Interval",RowId,RowId1)) q:RowId1=""  d
    .s deptp=$p(^DHCCAPARAMDATAS(RowId1),"^",10)
    .q:'$d(^DHCCADEPTLEVELSETS(0,"Dept",16,deptp))  //非配置的直接医疗科室的退出
    .s itemmz=$p(^DHCCAPARAMDATAS(RowId1),"^",4) 
    .;q:(itemmz'=507)&&(itemmz'=520)&&(itemmz'=528)&&(itemmz'=529)&&(itemmz'=530)&&(itemmz'=527)&&(itemmz'=524)&&(itemmz'=535)&&(itemmz'=538)&&(itemmz'=536)&&(itemmz'=539)&&(itemmz'=537)&&(itemmz'=540)&&(itemmz'=541)
    .q:'$d(^DHCCADATALEVELSETS(0,"Item","36",itemmz)) //报表配置-数据分成套-绩效指标
    .s rc=$p(^DHCCAPARAMDATAS(RowId1),"^",11) 
    .s ^temp($j,deptp,itemmz)=$g(^temp($j,deptp,itemmz))+rc  
  
    s Num=0   
    s loc=0 f  s loc=$o(^temp($j,loc)) q:loc=""  d
    .s type=0 f  s type=$o(^temp($j,loc,type)) q:type=""  d
    ..s outdata=$g(^temp($j,loc,type))	
    ..d OutputRow12
    k ^temp($j)
 	q $$$OK

OutputRow12
    i $d(^DHCCAUNITDEPTS(loc)) d 
    .s deptcode=$p(^DHCCAUNITDEPTS(loc),"^",1)
	.s deptname=$p(^DHCCAUNITDEPTS(loc),"^",2) 
	
    i type="zsr" s itemname="总收入"
    i type="zjzsr" s itemname="自己开单执行收入"
    i type="yfsr" s itemname="药费"
    ;i type="zcost" s itemname="总成本"
    i type="zjcost" s itemname="直接成本"
    i $d(^DHCCAALLDATAITEMS(type)) s itemname=$P(^DHCCAALLDATAITEMS(type),"^",3)	
 
 	s Data=$lb(stdate,$g(loc),deptcode,deptname,type,itemname,$fn($g(outdata),"",2))
 	s ^CacheTemp(repid,ind)=Data	
	s ind=ind+1
	q
}

ClassMethod GetPAJxZbFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPAJxZbExecute, SqlProc ]
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

ClassMethod GetPAJxZbClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPAJxZbExecute, SqlProc ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetPAJxZb(stdate As %Integer) As %Query(ROWSPEC = "stdate:%Integer,loc:%Integer,deptcode:%String,deptname:%String,type:%String,itemname:%String,outdata:%Float") [ SqlProc ]
{
}

//绩效考核指标输出：w ##class(web.RunqianQueryZgydZj).GetPAJxJkZb("66-65")

ClassMethod GetPAJxJkZb(quote As %String) As %String [ SqlProc ]
{
	//n (quote)
	q:quote=""  
	k ^temp($j)
    k ^TMPDHCALXY("dhc","ca","jxzbjk",$j)
    k ^TEMPDHCALXY("dhc","ca","jxzbjk",$j)
   
	s Length=$L(quote,"-")
	f i=1:1:Length d
	.s intervalDr = $P(quote,"-",i)
	.s RowId=intervalDr,RowId1="",RowId2="",RowIdIncome="",RowIdZj="",RowIdIncomezj=""
 	 	
 	.f  s RowIdIncome=$o(^DHCCAINCOMEDATAS(0,"Interval",RowId,RowIdIncome)) q:RowIdIncome=""  d
    ..s fdeptdr=$p(^DHCCAINCOMEDATAS(RowIdIncome),"^",11) 
    ..q:'$d(^DHCCADEPTLEVELSETS(0,"Dept",16,fdeptdr))  //非配置的直接医疗科室的退出
    ..s totalFee=$p(^DHCCAINCOMEDATAS(RowIdIncome),"^",7) 
    ..s ^temp($j,fdeptdr,"zsr")=$g(^temp($j,fdeptdr,"zsr"))+totalFee //总收入   
    ..s item=$p(^DHCCAINCOMEDATAS(RowIdIncome),"^",6) q:item=""
    ..q:('$d(^DHCCADATALEVELSETS(0,"Item","3",item)))  
    ..s fee=$p(^DHCCAINCOMEDATAS(RowIdIncome),"^",7) 
    ..i $d(^DHCCADATALEVELSETS(0,"Item","3",item)) d
    ...s yaofee=fee  
    ...s ^temp($j,fdeptdr,"yfsr")=$g(^temp($j,fdeptdr,"yfsr"))+yaofee  //药费
    
    .f  s RowIdIncomezj=$o(^DHCCAINCOMEDATAS(0,"Interval",RowId,RowIdIncomezj)) q:RowIdIncomezj=""  d
    ..s fdeptdr1=$p(^DHCCAINCOMEDATAS(RowIdIncomezj),"^",11) 
    ..q:'$d(^DHCCADEPTLEVELSETS(0,"Dept",16,fdeptdr1))  //非配置的直接医疗科室的退出
    ..s tdeptdr1=$p(^DHCCAINCOMEDATAS(RowIdIncomezj),"^",14)
    ..q:tdeptdr1'=fdeptdr1  //lxc-2011-02-23 add
    ..s totalFeezj=$p(^DHCCAINCOMEDATAS(RowIdIncomezj),"^",7) 
    ..s ^temp($j,fdeptdr1,"zjzsr")=$g(^temp($j,fdeptdr1,"zjzsr"))+totalFeezj //自己开单自己执行总收入   
         
    .f  s RowIdZj=$o(^DHCCACOSTDISTSETS(1,"CostResultSum",RowIdZj)) q:RowIdZj=""   d
    ..s inter=$p(^DHCCACOSTDISTSETS(1,"CostResultSum",RowIdZj),"^",1) q:inter'=RowId
    ..s flag=$p(^DHCCACOSTDISTSETS(1,"CostResultSum",RowIdZj),"^",2) q:flag'="leaf"
    ..s deptc=$p(^DHCCACOSTDISTSETS(1,"CostResultSum",RowIdZj),"^",3) 
    ..q:'$d(^DHCCADEPTLEVELSETS(0,"Dept",16,deptc))  //非配置的直接医疗科室的退出
    ..s zjcost=$p(^DHCCACOSTDISTSETS(1,"CostResultSum",RowIdZj),"^",4) //直接成本
    ..;s Zcost=$p(^DHCCACOSTDISTSETS(1,"CostResultSum",RowIdZj),"^",7) //总成本
    ..;s ^temp($j,deptc,"zcost")=$g(^temp($j,deptc,"zcost"))+Zcost //总成本
    ..s ^temp($j,deptc,"zjcost")=$g(^temp($j,deptc,"zjcost"))+zjcost //总直接成本
    
    .f  s RowId1=$o(^DHCCAPARAMDATAS(0,"Interval",RowId,RowId1)) q:RowId1=""  d
    ..s deptp=$p(^DHCCAPARAMDATAS(RowId1),"^",10)
    ..q:'$d(^DHCCADEPTLEVELSETS(0,"Dept",16,deptp))  //非配置的直接医疗科室的退出
    ..s itemmz=$p(^DHCCAPARAMDATAS(RowId1),"^",4) 
    ..q:'$d(^DHCCADATALEVELSETS(0,"Item","36",itemmz))  //报表配置-数据分成套-绩效指标
    ..s rc=$p(^DHCCAPARAMDATAS(RowId1),"^",11) 
    ..s ^temp($j,deptp,itemmz)=$g(^temp($j,deptp,itemmz))+rc  
     
    s Num=0   
    s loc=0 f  s loc=$o(^temp($j,loc)) q:loc=""  d
    .s type=0 f  s type=$o(^temp($j,loc,type)) q:type=""  d
    ..s outdata=$g(^temp($j,loc,type))	
    ..i $d(^DHCCAUNITDEPTS(loc)) d
    ...s deptname=$p(^DHCCAUNITDEPTS(loc),"^",2)
    ...s deptcode=$p(^DHCCAUNITDEPTS(loc),"^",1)
    ..i type="zsr" s itemname="总收入"
    ..i type="zjzsr" s itemname="自己开单执行收入"
    ..i type="yfsr" s itemname="药费"
    ..;i type="zcost" s itemname="总成本"
    ..i type="zjcost" s itemname="直接成本"
    ..i $d(^DHCCAALLDATAITEMS(type)) s itemname=$P(^DHCCAALLDATAITEMS(type),"^",3)	 	
	..s ^TMPDHCALXY("dhc","ca","jxzbjk",$j,Num)=loc_"^"_deptcode_"^"_deptname_"^"_type_"^"_itemname_"^"_$fn($g(outdata),"",2)
	..;w loc_"^"_deptcode_"^"_deptname_"^"_type_"^"_itemname_"^"_$fn($g(outdata),"",2),!
	..s ^TEMPDHCALXY("dhc","ca","jxzbjk",$j,deptcode,type)=deptcode_"^"_deptname_"^"_type_"^"_itemname_"^"_$fn($g(outdata),"",2)
	..;w ^TEMPDHCALXY("dhc","ca","jxzbjk",$j,deptcode,type),!
    ..s Num=Num+1
    
  k ^temp($j)
  q Num
}

//Test：d ##class(%ResultSet).RunQuery("web.RunqianQueryZgydZj","GetTest","64")

ClassMethod GetTestExecute(ByRef qHandle As %Binary, stdate As %Integer) As %Status [ SqlProc ]
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	q:stdate="" $$$OK
	k ^temp($j)
 	s RowId="",stdate=64
    
    f  s RowId=$o(^DHCCACOSTDISTSETS(0,"DIntervalItem",1,stdate,RowId)) q:RowId=""  d
    .s dept=$p(^DHCCACOSTDISTSETS("1","DeptCostItem",RowId),"^",2) 
    .q:dept'=2
    .s item=$p(^DHCCACOSTDISTSETS("1","DeptCostItem",RowId),"^",3) 
    .s prim=$p(^DHCCACOSTDISTSETS("1","DeptCostItem",RowId),"^",5) 
    .s ^temp($j,"cost",dept,item)=$g(^temp($j,"cost",dept,item))+prim
    
    s loc=0 f  s loc=$o(^temp($j,"cost",loc)) q:loc=""  d
    .s type=0 f  s type=$o(^temp($j,"cost",loc,type)) q:type=""  d
    ..s outdata=$g(^temp($j,"cost",loc,type))
    ..d OutputRow13
    
    k ^temp($j)   
 	q $$$OK
OutputRow13
    
 
    i $d(^DHCCAUNITDEPTS(loc)) s deptname=$p(^DHCCAUNITDEPTS(loc),"^",2)
	i $d(^DHCCAALLDATAITEMS(type)) s name=$P(^DHCCAALLDATAITEMS(type),"^",3)	
 
    s Data=$lb($g(loc),deptname,$g(type),$g(name),$g(outdata))
 	s ^CacheTemp(repid,ind)=Data	
	s ind=ind+1
	q
}

ClassMethod GetTestFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTestExecute, SqlProc ]
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

ClassMethod GetTestClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTestExecute, SqlProc ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetTest(stdate As %Integer) As %Query(ROWSPEC = "loc:%Integer,deptname:%String,type:%Integer,name:%String,outdata:%Float") [ SqlProc ]
{
}

/*
//全院收入医疗药品：d ##class(%ResultSet).RunQuery("web.RunqianQueryZgydZj","GetIncomeZylyp","2012")

ClassMethod GetIncomeZylypExecute(ByRef qHandle As %Binary, stdate As %String) As %Status [ SqlProc ]
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	q:stdate="" $$$OK
	k ^temp($j)
	s sumfee="",totalFee="",totalyaoFee="",totalzsr=""

 	s RowIdY="",RowId="",RowId1="",RowIdIncome="",itemDr="",RowIdzY="",itemDrzy=""
 	s RowIdq="",RowIdq1="",RowIdqy="",RowIdqy1=""
  
    f  s RowId=$o(^DHCCAACCOUNTMONTHS(RowId))  q:RowId=""  d
    .s desc=$p(^DHCCAACCOUNTMONTHS(RowId),"^",2)
    .s year=$p(desc,"-",1)
    .q:year'=stdate
    
    .f  s RowIdIncome=$o(^DHCCAINCOMEDATAS(0,"Interval",RowId,RowIdIncome)) q:RowIdIncome=""  d
    ..s totalFee=$p(^DHCCAINCOMEDATAS(RowIdIncome),"^",7) 
    ..s ^temp($j,"zsr",RowId)=$g(^temp($j,"zsr",RowId))+totalFee  //总收入
    
    .f  s RowIdY=$o(^DHCCAINCOMEDATAS(0,"Interval",RowId,RowIdY)) q:RowIdY=""  d
    ..s itemDr=$p(^DHCCAINCOMEDATAS(RowIdY),"^",6) q:itemDr="" //收入项目id
    ..q:'$d(^DHCCADATALEVELSETS(0,"Item","3",itemDr)) //判断数据分层套药品收入节点id下的项目id是否在收入数据中存在
    ..s yaofeei=$p(^DHCCAINCOMEDATAS(RowIdY),"^",7) 
    ..s ^temp($j,"yaopi",RowId)=$g(^temp($j,"yaopi",RowId))+yaofeei   //药品收入
      
    .f  s RowIdzY=$o(^DHCCAINCOMEDATAS(0,"Interval",RowId,RowIdzY)) q:RowIdzY=""  d
    ..s itemDrz=$p(^DHCCAINCOMEDATAS(RowIdzY),"^",6) q:itemDrz'="117"  //中草药品收入
    ..q:'$d(^DHCCADATALEVELSETS(0,"Item","3",itemDrz))
    ..s zyaofeei=$p(^DHCCAINCOMEDATAS(RowIdzY),"^",7) 
    ..s ^temp($j,"zyaopi",RowId)=$g(^temp($j,"zyaopi",RowId))+zyaofeei   //药品收入  
    
    s loc=0 f  s loc=$o(^temp($j,"zsr",loc)) q:loc=""  d
    .s outdata=$g(^temp($j,"zsr",loc))_"^"_$g(^temp($j,"yaopi",loc))_"^"_$g(^temp($j,"zyaopi",loc))
    .s incomefee=$p(outdata,"^",1)  //总收入
    .s yaoincome=$p(outdata,"^",2) //药品收入
    .s ylincome=incomefee-yaoincome //医疗收入
    .s zyaoincome=$p(outdata,"^",3) //中草药收入
    .d OutputRow14
  
 	;输出合计
 	;d OutputRowWorkSum
 	k ^temp($j)
 	q $$$OK
 	
OutputRow14
	
 	q:'$d(^DHCCAACCOUNTMONTHS(loc))
    s descy=$p(^DHCCAACCOUNTMONTHS(loc),"^",2)
    s moncode=$p(^DHCCAACCOUNTMONTHS(loc),"^",1)
    s monthQ=+$p(descy,"-",2)
    s mony=+$p(descy,"-",2)_""_"月"
  	
 	s Data=$lb($g(loc),$g(moncode),$g(mony),$fn($g(ylincome),"",2),$fn($g(yaoincome),"",2),$fn($g(zyaoincome),"",2),$fn($g(incomefee),"",2))
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod GetIncomeZylypFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetIncomeZylypExecute, SqlProc ]
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

ClassMethod GetIncomeZylypClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetIncomeZylypExecute, SqlProc ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetIncomeZylyp(stdate As %String) As %Query(ROWSPEC = "loc:%Integer,moncode:%Integer,mony:%String,ylincome:%Float,yaoincome:%Float,zyaoincome:%Float,incomefee:%Float") [ SqlProc ]
{
}
*/

//全院收入医疗药品：d ##class(%ResultSet).RunQuery("web.RunqianQueryZgydZj","GetIncomeZylyp","2014")

ClassMethod GetIncomeZylypExecute(ByRef qHandle As %Binary, stdate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	q:stdate="" $$$OK
	k ^temp($j)
	s sumfee="",totalFee="",totalyaoFee="",totalzsr=""

 	s RowIdY="",RowId="",RowId1="",RowIdIncome="",itemdr="",RowIdC=""
 	s RowIdq="",RowIdq1="",RowIdqy="",RowIdqy1=""
 	s (outdata1,outdata2,OPincome,IPincome)=""
  
    f  s RowId=$o(^DHCCAACCOUNTMONTHS(RowId))  q:RowId=""  d
    .s desc=$p(^DHCCAACCOUNTMONTHS(RowId),"^",2)
    .s year=$p(desc,"-",1)
    .q:year'=stdate
    .f  s RowIdIncome=$o(^DHCCAINCOMEDATAS(0,"Interval",RowId,RowIdIncome)) q:RowIdIncome=""  d
    ..s pattype=$p(^DHCCAINCOMEDATAS(RowIdIncome),"^",3)  ;
    ..Q:((pattype="H")||(pattype="C"))    ;Q出体检和社区2014-11-27
    ..s totalFee=$p(^DHCCAINCOMEDATAS(RowIdIncome),"^",7)
    ..i pattype="O" d
    ...s ^temp($j,"Ozsr",RowId)=$g(^temp($j,"Ozsr",RowId))+totalFee  //门诊总收入
    ..i pattype="I" d
    ...s ^temp($j,"Izsr",RowId)=$g(^temp($j,"Izsr",RowId))+totalFee  //住院总收入
    ..s ^temp($j,"zsr",RowId)=$g(^temp($j,"Ozsr",RowId))_"^"_$g(^temp($j,"Izsr",RowId))  //总收入
    
    .f  s RowIdY=$o(^DHCCAINCOMEDATAS(0,"Interval",RowId,RowIdY)) q:RowIdY=""  d
    ..s pattype=$p(^DHCCAINCOMEDATAS(RowIdY),"^",3)  ;
    ..Q:((pattype="H")||(pattype="C"))
    ..s itemDr=$p(^DHCCAINCOMEDATAS(RowIdY),"^",6) q:itemDr=""
    ..q:'$d(^DHCCADATALEVELSETS(0,"Item","3",itemDr))
    ..s yaofeei=$p(^DHCCAINCOMEDATAS(RowIdY),"^",7)
    ..i pattype="O" d
    ...s ^temp($j,"Oyaopi",RowId)=$g(^temp($j,"Oyaopi",RowId))+yaofeei   //门诊药品收入
    ..i pattype="I" d
    ...s ^temp($j,"Iyaopi",RowId)=$g(^temp($j,"Iyaopi",RowId))+yaofeei   //住院药品收入
    ..s ^temp($j,"yaopi",RowId)=$g(^temp($j,"Oyaopi",RowId))_"^"_$g(^temp($j,"Iyaopi",RowId))
    
    s loc=0 f  s loc=$o(^temp($j,"zsr",loc)) q:loc=""  d
    .s outdata=$g(^temp($j,"zsr",loc))_"^"_$g(^temp($j,"yaopi",loc))
    .;modify by baoshi经营科要求此报表分为:门诊医疗、门诊药品、住院医疗、住院药品、同时包含体检和社区收入2014-11-27 
    .s OPlincome=$p(outdata,"^",1)    ;门诊总收入    
    .s IPlincome=$p(outdata,"^",2)    ;住院总收入
    .s OPdrgcome=$p(outdata,"^",3)    ;门诊药品总收入
    .s IPdrgcome=$p(outdata,"^",4)    ;住院药品总收入
    .s Oylincome=OPlincome-OPdrgcome  ;门诊医疗收入
    .s Iylincome=IPlincome-IPdrgcome  ;住院医疗收入
    .s incomefee=OPlincome+IPlincome  ;总收入
    .;b ;111
    .;w !,OPlincome_"^"_IPlincome_"^"_OPdrgcome_"^"_IPdrgcome_"**"_Oylincome_"**"_Iylincome_"**"_incomefee
    .d OutputRow9
    k ^temp($j)
 	;输出合计
 	;d OutputRowWorkSum
 	q $$$OK
 	
OutputRow9
	
 	q:'$d(^DHCCAACCOUNTMONTHS(loc))
    s descy=$p(^DHCCAACCOUNTMONTHS(loc),"^",2)
    s moncode=$p(^DHCCAACCOUNTMONTHS(loc),"^",1)
    s monthQ=+$p(descy,"-",2)
    s mony=+$p(descy,"-",2)_""_"月"
  	
 	s Data=$lb($g(loc),$g(moncode),$g(mony),$fn($g(Oylincome),"",2),$fn($g(Iylincome),"",2),$fn($g(OPdrgcome),"",2),$fn($g(IPdrgcome),"",2),$fn($g(incomefee),"",2))
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod GetIncomeZylypFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetIncomeZylypExecute ]
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

ClassMethod GetIncomeZylypClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetIncomeZylypExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetIncomeZylyp(stdate As %String) As %Query(ROWSPEC = "loc:%Integer,moncode:%Integer,mony:%String,Oylincome:%Float,Iylincome:%Float,Oyaoincome:%Float,Iyaoincome:%Float,incomefee:%Float") [ SqlProc ]
{
}

//年度按月份医保业务收入指标分析：d ##class(%ResultSet).RunQuery("web.RunqianQueryZgydZj","GetYBYWSRZb","2011")

ClassMethod GetYBYWSRZbExecute(ByRef qHandle As %Binary, stdate As %String) As %Status [ SqlProc ]
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	k ^temp($j)
 	s RowId="",RowId1="",RowId2="",RowIdIncome="",RowIdIncomeZ=""
 	s monthQ=stdate //yyf20110211
 	s monthname=monthQ_""_"年度" //yyf20110211
    f  s RowId=$o(^DHCCAACCOUNTMONTHS(RowId))  q:RowId=""  d
    .s desc=$p(^DHCCAACCOUNTMONTHS(RowId),"^",2)
    .s mon=+$p(desc,"-",2)_""_"月" //yyf20110211
    .s year=$p(desc,"-",1)
    .q:year'=monthQ 
    .;q:year<"2006"
    .s ^temp($j,RowId)=$g(^temp($j,RowId)) //yyf20110211
    .;f  s RowIdIncome=$o(^DHCCAINCOMEDATAS(0,"Interval",RowId,RowIdIncome)) q:RowIdIncome=""  d
    ..;s pattype=$p(^DHCCAINCOMEDATAS(RowIdIncome),"^",3) 
    ..;q:(pattype'="O")&&(pattype'="E") 
    ..;s totalFee=$p(^DHCCAINCOMEDATAS(RowIdIncome),"^",7) 

    ..;s ^temp($j,"mzsr",RowId)=$g(^temp($j,"mzsr",RowId))+totalFee //门、急诊收入   
    ..;s item=$p(^DHCCAINCOMEDATAS(RowIdIncome),"^",6) q:item=""
    ..;q:('$d(^DHCCADATALEVELSETS(0,"Item","3",item)))  //&&('$d(^DHCCADATALEVELSETS(0,"Item","34",item)))
    ..;s fee=$p(^DHCCAINCOMEDATAS(RowIdIncome),"^",7) 
    ..;i $d(^DHCCADATALEVELSETS(0,"Item","3",item)) d
    ...;s yaofee=fee  
    ...;s ^temp($j,"myfsr",RowId)=$g(^temp($j,"myfsr",RowId))+yaofee  //门诊药费
          
    .;f  s RowIdIncomeZ=$o(^DHCCAINCOMEDATAS(0,"Interval",RowId,RowIdIncomeZ)) q:RowIdIncomeZ=""  d
    ..;s pattype=$p(^DHCCAINCOMEDATAS(RowIdIncomeZ),"^",3) 
    ..;q:pattype'="I"
    ..;s ZtotalFee=$p(^DHCCAINCOMEDATAS(RowIdIncomeZ),"^",7) 
    ..;s ^temp($j,"zysr",RowId)=$g(^temp($j,"zysr",RowId))+ZtotalFee //住院收入 
    ..;s itemz=$p(^DHCCAINCOMEDATAS(RowIdIncomeZ),"^",6)  q:itemz=""
    ..;q:('$d(^DHCCADATALEVELSETS(0,"Item","3",itemz)))  //&&('$d(^DHCCADATALEVELSETS(0,"Item","34",itemz)))
    ..;s zfee=$p(^DHCCAINCOMEDATAS(RowIdIncomeZ),"^",7) 
    ..;i $d(^DHCCADATALEVELSETS(0,"Item","3",itemz)) d
    ...;s zyaofee=zfee  
    ...;s ^temp($j,"zyyfsr",RowId)=$g(^temp($j,"zyyfsr",RowId))+zyaofee  //住院药费
             
    
    .f  s RowId1=$o(^DHCCAPARAMDATAS(0,"Interval",RowId,RowId1)) q:RowId1=""  d
    ..s itemmz=$p(^DHCCAPARAMDATAS(RowId1),"^",4) 
    ..q:(itemmz'=174)&&(itemmz'=191)&&(itemmz'=197)&&(itemmz'=198)&&(itemmz'=207)&&(itemmz'=208)&&(itemmz'=199)&&(itemmz'=196)&&(itemmz'=193)&&(itemmz'=202)&&(itemmz'=203)&&(itemmz'=204)&&(itemmz'=205)&&(itemmz'=206)
    ..s rc=$p(^DHCCAPARAMDATAS(RowId1),"^",11) 
    ..If (itemmz="174") { 
    ..s mzrc=rc
    ..s ^temp($j,"mzrc",RowId)=$g(^temp($j,"mzrc",RowId))+mzrc   //265门诊人次174
    ..}ElseIf (itemmz="191") {
    ..s cyrs=rc
    ..s ^temp($j,"cyrs",RowId)=$g(^temp($j,"cyrs",RowId))+cyrs  //276出院人数191
    ..}ElseIf (itemmz="207") {
    ..s mzsr=rc
    ..s ^temp($j,"mzsr",RowId)=$g(^temp($j,"mzsr",RowId))+mzsr  //292门诊收入，按打发票时间207
    ..}ElseIf (itemmz="208") {
    ..s myfsr=rc
    ..s ^temp($j,"myfsr",RowId)=$g(^temp($j,"myfsr",RowId))+myfsr  //291门诊药费收入，按打发票时间208
    ..}ElseIf (itemmz="197") {
    ..s mzyb=rc
    ..s ^temp($j,"mzyb",RowId)=$g(^temp($j,"mzyb",RowId))+mzyb  //284门诊医保人次197
    ..}ElseIf (itemmz="198") {
    ..s zyyb=rc
    ..s ^temp($j,"zyyb",RowId)=$g(^temp($j,"zyyb",RowId))+zyyb  //285出院医保人次198
    ..}ElseIf (itemmz="199") {
    ..s cyfy=rc
    ..s ^temp($j,"cyfy",RowId)=$g(^temp($j,"cyfy",RowId))+cyfy  //338出院病人费用199
    ..}ElseIf (itemmz="196") {
    ..s cyzyts=rc
    ..s ^temp($j,"cyzyts",RowId)=$g(^temp($j,"cyzyts",RowId))+cyzyts  //281出院患者住院天数196
    ..}ElseIf (itemmz="193") {
	..s zyrs=rc
    ..s ^temp($j,"zyrs",RowId)=$g(^temp($j,"zyrs",RowId))+zyrs  //278在院人数193
	..}ElseIf (itemmz="202") {
	..s cyypfy=rc
    ..s ^temp($j,"cyypfy",RowId)=$g(^temp($j,"cyypfy",RowId))+cyypfy  //339出院患者药品费用2011-01-29增加以下 202
    ..}ElseIf (itemmz="205") {
    ..s mzybfy=rc
    ..s ^temp($j,"mzybfy",RowId)=$g(^temp($j,"mzybfy",RowId))+mzybfy  //289门诊医保患者费用  205
    ..}ElseIf (itemmz="203") {
    ..s mzybypfy=rc
    ..s ^temp($j,"mzybypfy",RowId)=$g(^temp($j,"mzybypfy",RowId))+mzybypfy  //282门诊医保患者药品费用 203
    ..}ElseIf (itemmz="206") {
	..s zyybfy=rc
    ..s ^temp($j,"zyybfy",RowId)=$g(^temp($j,"zyybfy",RowId))+zyybfy  //290住院医保患者费用 206
	..}ElseIf (itemmz="204") {
	..s zyybypfy=rc
    ..s ^temp($j,"zyybypfy",RowId)=$g(^temp($j,"zyybypfy",RowId))+zyybypfy  //283住院医保患者药品费用 204
    ..}
   
     s loc=0 f  s loc=$o(^temp($j,"mzyb",loc)) q:loc=""  d
    .s outdata1=$g(^temp($j,"mzsr",loc))_"^"_$g(^temp($j,"myfsr",loc))_"^"_$g(^temp($j,"mzrc",loc))_"^"_$g(^temp($j,"cyrs",loc))_"^"_$g(^temp($j,"cyfy",loc))_"^"_$g(^temp($j,"cyzyts",loc))_"^"_$g(^temp($j,"zyrs",loc))_"^"_$g(^temp($j,"cyypfy",loc))
    .s outdata=outdata1_"^"_$g(^temp($j,"mzyb",loc))_"^"_$g(^temp($j,"zyyb",loc))_"^"_$g(^temp($j,"mzybfy",loc))_"^"_$g(^temp($j,"mzybypfy",loc))_"^"_$g(^temp($j,"zyybfy",loc))_"^"_$g(^temp($j,"zyybypfy",loc))
    
 	.s mzsrsum=$p(outdata,"^",1)
 	.s myfsrsum=$p(outdata,"^",2)
 	.s mzylfsum=mzsrsum-myfsrsum
 	.s mzrcsum=$p(outdata,"^",3)
 	.s cyrssum=$p(outdata,"^",4)
 	.s cyfysum=$p(outdata,"^",5)
 	.s cyzytssum=$p(outdata,"^",6)
 	.s zyrssum=$p(outdata,"^",7)
 	.s cyypfysum=$p(outdata,"^",8)
 	.s cyylfsum=cyfysum-cyypfysum
 	.s mzybsum=$p(outdata,"^",9)
 	.s zyybsum=$p(outdata,"^",10)
 	.s mzybfysum=$p(outdata,"^",11)
 	.s mzybypfysum=$p(outdata,"^",12)
 	.s zyybfysum=$p(outdata,"^",13)
 	.s zyybypfysum=$p(outdata,"^",14)
    .d OutputRow15
    
    k ^temp($j)

 	q $$$OK
OutputRow15
   	q:'$d(^DHCCAACCOUNTMONTHS(loc))
    s descy=$p(^DHCCAACCOUNTMONTHS(loc),"^",2)

    s month=+$p(descy,"-",2)
    s mony=+$p(descy,"-",2)_""_"月" 
    	
	s Data=$lb(monthname,$g(mony),$g(loc),$fn($g(mzsrsum),"",2),$fn($g(myfsrsum),"",2),$fn($g(mzylfsum),"",2),$fn($g(mzrcsum),"",2),$fn($g(cyrssum),"",2),$fn($g(cyfysum),"",2),$fn($g(cyzytssum),"",2),$fn($g(zyrssum),"",2),$fn($g(cyypfysum),"",2),$fn($g(cyylfsum),"",2),$fn($g(mzybsum),"",2),$fn($g(zyybsum),"",2),$fn($g(mzybfysum),"",2),$fn($g(mzybypfysum),"",2),$fn($g(zyybfysum),"",2),$fn($g(zyybypfysum),"",2),monthQ)
 	s ^CacheTemp(repid,ind)=Data	
	s ind=ind+1
	q
}

ClassMethod GetYBYWSRZbFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetYBYWSRZbExecute, SqlProc ]
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

ClassMethod GetYBYWSRZbClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetYBYWSRZbExecute, SqlProc ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetYBYWSRZb(stdate As %Integer) As %Query(ROWSPEC = "monthname:%String,mony:%String,loc:%Integer,mzsrsum:%Float,myfsrsum:%Float,mzylfsum:%Float,mzrcsum:%Float,cyrssum:%Float,cyfysum:%Float,cyzytssum:%Float,zyrssum:%Float,cyypfysum:%Float,cyylfsum:%Float,mzybsum:%Float,zyybsum:%Float,mzybfysum:%Float,mzybypfysum:%Float,zyybfysum:%Float,zyybypfysum:%Float,monthQ") [ SqlProc ]
{
}

//年度-按年度医保业务收入指标分析：d ##class(%ResultSet).RunQuery("web.RunqianQueryZgydZj","GetNDYBYWSRZb")

ClassMethod GetNDYBYWSRZbExecute(ByRef qHandle As %Binary) As %Status [ SqlProc ]
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	k ^temp($j)
 	s RowId="",RowId1="",RowId2="",RowIdIncome="",RowIdIncomeZ=""
 	;s monthQ=stdate //yyf20110211
 	;s monthname=monthQ_""_"年度" //yyf20110211
    f  s RowId=$o(^DHCCAACCOUNTMONTHS(RowId))  q:RowId=""  d
    .s desc=$p(^DHCCAACCOUNTMONTHS(RowId),"^",2)
    .s mon=+$p(desc,"-",2)_""_"月" //yyf20110211
    .s year=$p(desc,"-",1)
    .;q:year'=monthQ 
    .q:year<"2006"
    .s ^temp($j,RowId)=$g(^temp($j,RowId)) //yyf20110211
    .;f  s RowIdIncome=$o(^DHCCAINCOMEDATAS(0,"Interval",RowId,RowIdIncome)) q:RowIdIncome=""  d
    ..;s pattype=$p(^DHCCAINCOMEDATAS(RowIdIncome),"^",3) 
    ..;q:(pattype'="O")&&(pattype'="E") 
    ..;s totalFee=$p(^DHCCAINCOMEDATAS(RowIdIncome),"^",7) 

    ..;s ^temp($j,"mzsr",RowId)=$g(^temp($j,"mzsr",RowId))+totalFee //门、急诊收入   
    ..;s item=$p(^DHCCAINCOMEDATAS(RowIdIncome),"^",6) q:item=""
    ..;q:('$d(^DHCCADATALEVELSETS(0,"Item","3",item)))  //&&('$d(^DHCCADATALEVELSETS(0,"Item","34",item)))
    ..;s fee=$p(^DHCCAINCOMEDATAS(RowIdIncome),"^",7) 
    ..;i $d(^DHCCADATALEVELSETS(0,"Item","3",item)) d
    ...;s yaofee=fee  
    ...;s ^temp($j,"myfsr",RowId)=$g(^temp($j,"myfsr",RowId))+yaofee  //门诊药费
          
    .;f  s RowIdIncomeZ=$o(^DHCCAINCOMEDATAS(0,"Interval",RowId,RowIdIncomeZ)) q:RowIdIncomeZ=""  d
    ..;s pattype=$p(^DHCCAINCOMEDATAS(RowIdIncomeZ),"^",3) 
    ..;q:pattype'="I"
    ..;s ZtotalFee=$p(^DHCCAINCOMEDATAS(RowIdIncomeZ),"^",7) 
    ..;s ^temp($j,"zysr",RowId)=$g(^temp($j,"zysr",RowId))+ZtotalFee //住院收入 
    ..;s itemz=$p(^DHCCAINCOMEDATAS(RowIdIncomeZ),"^",6)  q:itemz=""
    ..;q:('$d(^DHCCADATALEVELSETS(0,"Item","3",itemz)))  //&&('$d(^DHCCADATALEVELSETS(0,"Item","34",itemz)))
    ..;s zfee=$p(^DHCCAINCOMEDATAS(RowIdIncomeZ),"^",7) 
    ..;i $d(^DHCCADATALEVELSETS(0,"Item","3",itemz)) d
    ...;s zyaofee=zfee  
    ...;s ^temp($j,"zyyfsr",RowId)=$g(^temp($j,"zyyfsr",RowId))+zyaofee  //住院药费
             
    .f  s RowId1=$o(^DHCCAPARAMDATAS(0,"Interval",RowId,RowId1)) q:RowId1=""  d
    ..s itemmz=$p(^DHCCAPARAMDATAS(RowId1),"^",4) 
    ..q:(itemmz'=265)&&(itemmz'=276)&&(itemmz'=284)&&(itemmz'=285)&&(itemmz'=338)&&(itemmz'=281)&&(itemmz'=278)&&(itemmz'=339)&&(itemmz'=289)&&(itemmz'=282)&&(itemmz'=290)&&(itemmz'=283)&&(itemmz'=292)&&(itemmz'=291)
    ..s rc=$p(^DHCCAPARAMDATAS(RowId1),"^",11) 
    ..If (itemmz="284") {
    ..s mzyb=rc
    ..s ^temp($j,"mzyb",year)=$g(^temp($j,"mzyb",year))+mzyb  //284门诊医保人次
    ..}ElseIf (itemmz="285") {
    ..s zyyb=rc
    ..s ^temp($j,"zyyb",year)=$g(^temp($j,"zyyb",year))+zyyb  //285出院医保人次
    ..}ElseIf (itemmz="289") {
    ..s mzybfy=rc
    ..s ^temp($j,"mzybfy",year)=$g(^temp($j,"mzybfy",year))+mzybfy  //289门诊医保患者费用
    ..}ElseIf (itemmz="282") {
    ..s mzybypfy=rc
    ..s ^temp($j,"mzybypfy",year)=$g(^temp($j,"mzybypfy",year))+mzybypfy  //282门诊医保患者药品费用
    ..}ElseIf (itemmz="290") {
	..s zyybfy=rc
    ..s ^temp($j,"zyybfy",year)=$g(^temp($j,"zyybfy",year))+zyybfy  //290住院医保患者费用
	..}ElseIf (itemmz="283") {
	..s zyybypfy=rc
    ..s ^temp($j,"zyybypfy",year)=$g(^temp($j,"zyybypfy",year))+zyybypfy  //283住院医保患者药品费用
    ..}
    
   
     s loc=0 f  s loc=$o(^temp($j,"mzyb",loc)) q:loc=""  d
    .s outdata=$g(^temp($j,"mzyb",loc))_"^"_$g(^temp($j,"zyyb",loc))_"^"_$g(^temp($j,"mzybfy",loc))_"^"_$g(^temp($j,"mzybypfy",loc))_"^"_$g(^temp($j,"zyybfy",loc))_"^"_$g(^temp($j,"zyybypfy",loc))
    
 	
 	.s mzybsum=$p(outdata,"^",1)
 	.s zyybsum=$p(outdata,"^",2)
 	.s mzybfysum=$p(outdata,"^",3)
 	.s mzybypfysum=$p(outdata,"^",4)
 	.s mzybylfsum=mzybfysum-mzybypfysum
 	.s zyybfysum=$p(outdata,"^",5)
 	.s zyybypfysum=$p(outdata,"^",6)
 	.s zyybylfsum=zyybfysum-zyybypfysum
    .d OutputRow16
    
    k ^temp($j)
 	q $$$OK
OutputRow16
   	;q:'$d(^DHCCAACCOUNTMONTHS(loc))
    ;s descy=$p(^DHCCAACCOUNTMONTHS(loc),"^",2)

    ;s month=+$p(descy,"-",2)
    ;s mony=+$p(descy,"-",2)_""_"月" 
    	
	s Data=$lb($g(loc),$fn($g(mzybsum),"",2),$fn($g(zyybsum),"",2),$fn($g(mzybfysum),"",2),$fn($g(mzybypfysum),"",2),$fn($g(zyybfysum),"",2),$fn($g(zyybypfysum),"",2),$fn($g(mzybylfsum),"",2),$fn($g(zyybylfsum),"",2))
 	s ^CacheTemp(repid,ind)=Data	
	s ind=ind+1
	q
}

ClassMethod GetNDYBYWSRZbFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetNDYBYWSRZbExecute, SqlProc ]
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

ClassMethod GetNDYBYWSRZbClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetNDYBYWSRZbExecute, SqlProc ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetNDYBYWSRZb() As %Query(ROWSPEC = "loc:%Integer,mzybsum:%Float,zyybsum:%Float,mzybfysum:%Float,mzybypfysum:%Float,zyybfysum:%Float,zyybypfysum:%Float,mzybylfsum:%Float,zyybylfsum:%Float") [ SqlProc ]
{
}

//全院按月收入医疗药品：d ##class(%ResultSet).RunQuery("web.RunqianQueryZgydZj","GetIncomeZayylyp","2011")

ClassMethod GetIncomeZayylypExecute(ByRef qHandle As %Binary, stdate As %String) As %Status [ SqlProc ]
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	q:stdate="" $$$OK
	k ^temp($j)
	;k ^TMPYYF
	;s ^TMPYYF(0)=1
	;s ^TMPYYF(1)=stdate
	s sumfee="",totalFee="",totalyaoFee="",totalzsr=""

 	s RowIdY="",RowId="",RowId1="",RowIdIncome="",itemdr=""
 	s RowIdq="",RowIdq1="",RowIdqy="",RowIdqy1="",RowIdq2=""
  
    f  s RowId=$o(^DHCCAACCOUNTMONTHS(RowId))  q:RowId=""  d
    .s desc=$p(^DHCCAACCOUNTMONTHS(RowId),"^",2)
    .s year=$p(desc,"-",1)
    .q:year'=stdate
    
    .f  s RowIdIncome=$o(^DHCCAINCOMEDATAS(0,"Interval",RowId,RowIdIncome)) q:RowIdIncome=""  d
    ..s totalFee=$p(^DHCCAINCOMEDATAS(RowIdIncome),"^",7) 
    ..s ^temp($j,"zsr",RowId)=$g(^temp($j,"zsr",RowId))+totalFee  //总收入
    
    
    .;取RowIdq、RowIdqy1的函数列中的数字‘19’是核算区间配置中“去年同期”的Rowid     
    .f  s RowIdq=$o(^DHCCAACCOUNTMONTHS(0,"Period",RowId,19,RowIdq)) q:RowIdq=""  d
 	..s monthDrq=$p(^DHCCAACCOUNTMONTHS(RowId,"Periods",RowIdq),"^",2)
 	..f  s RowIdq1=$o(^DHCCAINCOMEDATAS(0,"Interval",monthDrq,RowIdq1)) q:RowIdq1=""  d
    ...s sumamtq1=$p(^DHCCAINCOMEDATAS(RowIdq1),"^",7) //去年同期总收入
    ...s ^temp($j,"qnzsr",RowId)=$g(^temp($j,"qnzsr",RowId))+sumamtq1
    
    
    .f  s RowIdY=$o(^DHCCAINCOMEDATAS(0,"Interval",RowId,RowIdY))  q:RowIdY=""  d
 
    ..s itemDr=$p(^DHCCAINCOMEDATAS(RowIdY),"^",6) q:itemDr=""
    ..q:'$d(^DHCCADATALEVELSETS(0,"Item","3",itemDr))
    ..s yaofeei=$p(^DHCCAINCOMEDATAS(RowIdY),"^",7) 
    
    ..s ^temp($j,"yaopi",RowId)=$g(^temp($j,"yaopi",RowId))+yaofeei   //药品收入

    
    
	.f  s RowIdqy1=$o(^DHCCAACCOUNTMONTHS(0,"Period",RowId,19,RowIdqy1)) q:RowIdqy1=""  d
 	..s monthDrqy=$p(^DHCCAACCOUNTMONTHS(RowId,"Periods",RowIdqy1),"^",2)
 	..f  s RowIdq2=$o(^DHCCAINCOMEDATAS(0,"Interval",monthDrqy,RowIdq2)) q:RowIdq2=""  d 
 	...s itemDrq=$p(^DHCCAINCOMEDATAS(RowIdq2),"^",6) q:itemDrq=""
    ...q:'$d(^DHCCADATALEVELSETS(0,"Item","3",itemDrq))
    ...s sumamtq2=$p(^DHCCAINCOMEDATAS(RowIdq2),"^",7) //去年同期药费收入
    ...s ^temp($j,"qnyaopi",RowId)=$g(^temp($j,"qnyaopi",RowId))+sumamtq2

      
  
    s loc=0 f  s loc=$o(^temp($j,"zsr",loc)) q:loc=""  d
    .s outdata=$g(^temp($j,"zsr",loc))_"^"_$g(^temp($j,"yaopi",loc))_"^"_$g(^temp($j,"qnzsr",loc))_"^"_$g(^temp($j,"qnyaopi",loc))
    .s incomefee=$p(outdata,"^",1)  //总收入
    .s yaoincome=$p(outdata,"^",2) //药品收入
    .s ylincome=incomefee-yaoincome //医疗收入
    .s qnincomefee=$p(outdata,"^",3) //去年同期总收入
    .s qnyaoincome=$p(outdata,"^",4) //去年同期药费
    .s qnylincome=qnincomefee-qnyaoincome //去年同期医疗
    .d OutputRow17
    
    k ^temp($j)
 	;输出合计
 	;d OutputRowWorkSum
 	q $$$OK
OutputRow17
	
 	q:'$d(^DHCCAACCOUNTMONTHS(loc))
    s descy=$p(^DHCCAACCOUNTMONTHS(loc),"^",2)
    s moncode=$p(^DHCCAACCOUNTMONTHS(loc),"^",1)
    s monthQ=+$p(descy,"-",2)
    s mony=+$p(descy,"-",2)_""_"月"
    s year=+$p(descy,"-",1)
 	s Data=$lb($g(year),$g(loc),$g(mony),$g(incomefee),$g(yaoincome),$g(ylincome),$g(qnincomefee),$g(qnyaoincome),$g(qnylincome),$g(monthQ))
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod GetIncomeZayylypFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetIncomeZayylypExecute, SqlProc ]
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

ClassMethod GetIncomeZayylypClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetIncomeZayylypExecute, SqlProc ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetIncomeZayylyp(stdate As %String) As %Query(ROWSPEC = "year:%Integer,loc:%Integer,mony:%String,incomefee:%Float,yaoincome:%Float,ylincome:%Float,qnincomefee:%Float,qnyaoincome:%Float,qnylincome:%Float,monthQ:%Integer") [ SqlProc ]
{
}

//韶关财务收入

//d ##class(%ResultSet).RunQuery("web.RunqianQueryZgydZj","GetincomedataCwsr","13","13","95,96,97,98","demo")	

ClassMethod GetincomedataCwsrExecute(ByRef qHandle As %Binary, stdate As %Integer, endate As %Integer, dept As %String, user As %String) As %Status [ SqlProc ]
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
   
    q:stdate="" $$$OK
	q:endate="" $$$OK
	q:dept="" $$$OK
	q:user="" $$$OK
	    	
    s RowId="",RowIdIncome="",Income="",RowIdu="",unitrid="",RowIdQt=""
	s RowIdData="",RowIdDataZc=""
    k ^temp($j) 
       
    i $d(^DHCCAACCOUNTMONTHS(stdate)) s stmonth=$p(^DHCCAACCOUNTMONTHS(stdate),"^",2)
    s stdatecode=$p(^DHCCAACCOUNTMONTHS(stdate),"^",1)
    s month1=$p(stmonth,"-",1)
    s day1=$p(stmonth,"-",2)
    s monthname1=month1_""_"年"_""_day1_""_"月"
    
    i $d(^DHCCAACCOUNTMONTHS(endate)) s enmonth=$p(^DHCCAACCOUNTMONTHS(endate),"^",2)
    s endatecode=$p(^DHCCAACCOUNTMONTHS(endate),"^",1)
    s month2=$p(enmonth,"-",1)
    s day2=$p(enmonth,"-",2)
    s monthname2=month2_""_"年"_""_day2_""_"月"
    q:stdatecode>endatecode
    
    f  s RowIdu=$o(^DHCCAUSERS(0,"Loginname",user,RowIdu)) q:RowIdu=""  d
    .s bz=$p(^DHCCAUSERS(RowIdu),"^",5)  //取集团医院ID 1总部,2二部,3三部
    .f  s unitrid=$o(^DHCCAUNITDEPTS(0,"Unit",unitrid))  q:unitrid=""  d
    ..q:$F(","_bz_",",","_unitrid_",")=0
    ..i unitrid=1 s setid=1
    ..i unitrid=2 s setid=7
    ..i unitrid=3 s setid=8
    ..s i1="",i=""
    ..f i1=stdatecode:1:endatecode d
    ...f  s i=$o(^DHCCAACCOUNTMONTHS(0,"Code",i1,i)) q:i=""  d
    ....f  s RowIdIncome=$o(^DHCCAINCOMEDATAS(0,"Interval",i,RowIdIncome)) q:RowIdIncome=""  d
    .....s fdept=$p(^DHCCAINCOMEDATAS(RowIdIncome),"^",11)
    .....q:$F(","_dept_",",","_fdept_",")=0
    .....s pattype=$p(^DHCCAINCOMEDATAS(RowIdIncome),"^",3)
    .....s itemDr=$p(^DHCCAINCOMEDATAS(RowIdIncome),"^",6)
    .....s fee=$p(^DHCCAINCOMEDATAS(RowIdIncome),"^",7)
    .....s ^temp($j,"Income",fdept,pattype,itemDr)=$g(^temp($j,"Income",fdept,pattype,itemDr))+fee //HIS收入

    ....f  s RowIdQt=$o(^DHCCABUDGETDATA(RowIdQt)) q:RowIdQt=""  d
    .....s inter=$p(^DHCCABUDGETDATA(RowIdQt),"^",1) q:inter'=i
    .....s fdeptQ=$p(^DHCCABUDGETDATA(RowIdQt),"^",2) 
    .....q:'$d(^DHCCAUNITDEPTS(0,"Unit",unitrid,fdeptQ))
    .....s QtData=$p(^DHCCABUDGETDATA(RowIdQt),"^",6)
    .....s QtSr=$g(^temp($j,"QtData"))+QtData //其他收入 

    f  s RowIdData=$o(^DHCCADATALEVELSETS(RowIdData)) q:RowIdData=""  d
    .s dataname=$p(^DHCCADATALEVELSETS(RowIdData),"^",2)
    .s parent=$p(^DHCCADATALEVELSETS(RowIdData),"^",7) 
    .q:parent'=15
    .f  s RowIdDataZc=$o(^DHCCADATALEVELSETS(RowIdData,"Items",RowIdDataZc)) q:RowIdDataZc=""  d
    ..q:RowIdDataZc="0"
    ..s item1=$p(^DHCCADATALEVELSETS(RowIdData,"Items",RowIdDataZc),"^",3)
    ..s itemname1=$P(^DHCCAALLDATAITEMS(item1),"^",3)
    ..s ^temp($j,"item",item1)=RowIdData
   
    s dep=0 f  s dep=$o(^temp($j,"Income",dep)) q:dep=""  d
    .s type=0 f  s type=$o(^temp($j,"Income",dep,type)) q:type=""  d
    ..s item=0 f  s item=$o(^temp($j,"Income",dep,type,item)) q:item=""  d
    ...s itemrowid=$g(^temp($j,"item",item)) q:itemrowid=""
    ...s itemname1=$p(^DHCCADATALEVELSETS(itemrowid),"^",2)
    ...i $d(^DHCCAALLDATAITEMS(item)) s itemname=$P(^DHCCAALLDATAITEMS(item),"^",3)
 	...s incomefee=$g(^temp($j,"Income",dep,type,item)) 
    ...d OutputRow18
 	;输出合计
 	;d OutputRowWorkSum
 	k ^temp($j)
 	q $$$OK
OutputRow18
	i $d(^DHCCAUNITDEPTS(dep)) s deptname=$p(^DHCCAUNITDEPTS(dep),"^",2)
 	s Data=$lb(monthname1,monthname2,dep,deptname,type,itemrowid,itemname1,item,itemname,$fn($g(incomefee),"",2),$fn($g(QtSr),"",2))
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
OutputRowWorkSum18
    s Data=$lb("total",$g(totalFee))
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
 //ResetVariables
 //	 q
}

ClassMethod GetincomedataCwsrFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetincomedataCwsrExecute, SqlProc ]
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

ClassMethod GetincomedataCwsrClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetincomedataCwsrExecute, SqlProc ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetincomedataCwsr(stdate As %Integer, endate As %Integer, dept As %String, user As %String) As %Query(ROWSPEC = "monthname1:%String,monthname2:%String,dep:%String,deptname:%String,type:%String,itemrowid:%String,itemname1:%String,item:%String,itemname:%String,incomefee:%Float,QtSr:%Float") [ SqlProc ]
{
}

/*
//d ##class(%ResultSet).RunQuery("web.RunqianQueryZgydZj","GetincomedataMonth","60")
//全院收入分析

ClassMethod GetincomedataMonthExecute(ByRef qHandle As %Binary, stdate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
   
    q:stdate="" $$$OK
	s RowId="",RowIdIncome="",Income=""
	s RowIdData="",RowIdDataZc=""
	k ^temp($j)
    f  s RowId=$o(^DHCCAACCOUNTMONTHS(RowId))  q:RowId=""  d
    .s desc=$p(^DHCCAACCOUNTMONTHS(RowId),"^",2)
    .s year=$p(desc,"-",1)
    .q:year'=stdate
    .s monthname=year_""_"年度"
    .f  s RowIdIncome=$o(^DHCCAINCOMEDATAS(0,"Interval",RowId,RowIdIncome)) q:RowIdIncome=""  d
    ..s itemDr=$p(^DHCCAINCOMEDATAS(RowIdIncome),"^",6)
    ..s Income1=$p(^DHCCAINCOMEDATAS(RowIdIncome),"^",7)
    ..s ^temp($j,"Income",RowId,itemDr)=$g(^temp($j,"Income",RowId,itemDr))+Income1


    s locdr=0 f  s locdr=$o(^temp($j,"Income",locdr)) q:locdr=""  d
    .s item=0 f  s item=$o(^temp($j,"Income",locdr,item)) q:item=""  d
 	..s incomefee=$g(^temp($j,"Income",locdr,item)) 
    ..d OutputRow19
 	

 	q $$$OK
OutputRow19
	s descy=$p(^DHCCAACCOUNTMONTHS(locdr),"^",2)
    s mony=+$p(descy,"-",2) ;_""_"月"
    s itemrowid= ##class(dhc.ca.cache.udata.uDataLevelSets).GetLevelItemsParRef("f002",item)
    s itemname1=$p($g(^DHCCADATALEVELSETS(itemrowid)),"^",2)
    i $d(^DHCCAALLDATAITEMS(item)) s itemname=$P(^DHCCAALLDATAITEMS(item),"^",3)
 	s Data=$lb(monthname,locdr,mony,itemrowid,itemname1,item,itemname,$fn($g(incomefee),"",2))
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
	
OutputRowWorkSum1
    s Data=$lb("total",$g(totalFee))
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
 //ResetVariables
 //	 q
}

ClassMethod GetincomedataMonthFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetincomedataMonthExecute ]
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

ClassMethod GetincomedataMonthClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetincomedataMonthExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetincomedataMonth(stdate As %String) As %Query(ROWSPEC = "monthname:%String,locdr:%Integer,mony:%Integer,itemrowid:%Integer,itemname1:%String,item:%Integer,itemname:%String,sumfee:%Float") [ SqlProc ]
{
}

*/

//d ##class(%ResultSet).RunQuery("web.RunqianQueryZgydZj","GetincomedataMonth","")

//全院收入分析

ClassMethod GetincomedataMonthExecute(ByRef qHandle As %Binary, stdate As %String) As %Status [ SqlProc ]
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
   
    q:stdate="" $$$OK
	s RowId="",RowIdIncome="",Income=""
	s RowIdData="",RowIdDataZc=""
	k ^temp($j)
	
    f  s RowId=$o(^DHCCAACCOUNTMONTHS(RowId))  q:RowId=""  d
    .s desc=$p(^DHCCAACCOUNTMONTHS(RowId),"^",2)
    .s year=$p(desc,"-",1)
    .q:year'=stdate
    .s monthname=year_""_"年度"
    .f  s RowIdIncome=$o(^DHCCAINCOMEDATAS(0,"Interval",RowId,RowIdIncome)) q:RowIdIncome=""  d
    ..s itemDr=$p(^DHCCAINCOMEDATAS(RowIdIncome),"^",6) //收入项目id
    ..s Income1=$p(^DHCCAINCOMEDATAS(RowIdIncome),"^",7) //收费金额
    ..s ^temp($j,"Income",RowId,itemDr)=$g(^temp($j,"Income",RowId,itemDr))+Income1 //某月某项目的收费金额

    f  s RowIdData=$o(^DHCCADATALEVELSETS(RowIdData)) q:RowIdData=""  d
    .s dataname=$p(^DHCCADATALEVELSETS(RowIdData),"^",2) //数据项名称
    .s parent=$p(^DHCCADATALEVELSETS(RowIdData),"^",7)  //数据项父id
    .q:parent'=6 //收入分类
    .f  s RowIdDataZc=$o(^DHCCADATALEVELSETS(RowIdData,"Items",RowIdDataZc)) q:RowIdDataZc=""  d
    ..q:RowIdDataZc="0"
    ..s item1=$p(^DHCCADATALEVELSETS(RowIdData,"Items",RowIdDataZc),"^",3)
    ..s itemname1=$P(^DHCCAALLDATAITEMS(item1),"^",3)
    ..s ^temp($j,"item",item1)=RowIdData

    s locdr=0 f  s locdr=$o(^temp($j,"Income",locdr)) q:locdr=""  d
    .s descy=$p(^DHCCAACCOUNTMONTHS(locdr),"^",2)
    .s mony=+$p(descy,"-",2) ;_""_"月"
    
    .s item=0 f  s item=$o(^temp($j,"Income",locdr,item)) q:item=""  d
    ..s itemrowid=$g(^temp($j,"item",item))
    ..s itemname1=$p(^DHCCADATALEVELSETS(itemrowid),"^",2)
    ..i $d(^DHCCAALLDATAITEMS(item)) s itemname=$P(^DHCCAALLDATAITEMS(item),"^",3)
 	..s incomefee=$g(^temp($j,"Income",locdr,item)) 
    ..d OutputRow19
 	
 	;输出合计
 	;d OutputRowWorkSum
 	k ^temp($j)
 	q $$$OK
OutputRow19
	;
 	s Data=$lb(monthname,locdr,mony,itemrowid,itemname1,item,itemname,$fn($g(incomefee),"",2))
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
	
OutputRowWorkSum19
    s Data=$lb("total",$g(totalFee))
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
 //ResetVariables
 //	 q
}

ClassMethod GetincomedataMonthFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetincomedataMonthExecute, SqlProc ]
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

ClassMethod GetincomedataMonthClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetincomedataMonthExecute, SqlProc ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetincomedataMonth(stdate As %String) As %Query(ROWSPEC = "monthname:%String,locdr:%Integer,mony:%Integer,itemrowid:%Integer,itemname1:%String,item:%Integer,itemname:%String,sumfee:%Float") [ SqlProc ]
{
}

//科室原始成本查询检查[汇总]

//d ##class(%ResultSet).RunQuery("web.RunqianQueryZgydZj","GetVouchDatasdl","6","1")	

ClassMethod GetVouchDatasdlExecute(ByRef qHandle As %Binary, stdate As %Integer, endate As %Integer, UnitDr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 
	k ^temp($j)
	q:stdate="" $$$OK
	q:endate="" $$$OK
	q:stdate>endate $$$OK
	
	f i=stdate:1:endate d 
 	.s RowId="",RowId2="",id="",monthname="",RowId1=""
    
    .f  s RowId=$o(^DHCCAVOUCHDATAS(0,"Interval",i,RowId)) q:RowId=""  d  
    ..s itemDr=$p(^DHCCAVOUCHDATAS(RowId),"^",3)
    ..s dept=$p(^DHCCAVOUCHDATAS(RowId),"^",2)
    ..s deptsUnitDr=$p(^DHCCAUNITDEPTS(dept),"^",8) //判断科室所属单位类别
    ..q:$F(","_UnitDr_",",","_deptsUnitDr_",")=0
    ..s datafee=$p(^DHCCAVOUCHDATAS(RowId),"^",16) //成本金额
    
    ..f  s RowId2=$o(^DHCCADEPTLEVELSETS(RowId2))  q:RowId2=""  d
    ...s parent=$p(^DHCCADEPTLEVELSETS(RowId2),"^",7) q:parent'=1 //"全成本分摊设置" rowid
    ...q:'$d(^DHCCADEPTLEVELSETS(0,"Dept",RowId2,dept))
    
    ...f  s RowId1=$o(^DHCCADATALEVELSETS(RowId1))  q:RowId1=""  d 
    ....s parxm=$p(^DHCCADATALEVELSETS(RowId1),"^",7)  q:parxm'=25   //"新会计制度"rowid
    ....q:'$d(^DHCCADATALEVELSETS(0,"Item",RowId1,itemDr))
  
	....s ^temp($j,RowId2,dept,RowId1,itemDr)=$g(^temp($j,RowId2,dept,RowId1,itemDr))+datafee

    s depfc=0 f  s depfc=$o(^temp($j,depfc)) q:depfc=""  d
    .s dept=0  f  s dept=$o(^temp($j,depfc,dept)) q:dept=""  d 
    ..s datafc=0 f  s datafc=$o(^temp($j,depfc,dept,datafc)) q:datafc=""  d  
    ...s xm=0 f  s xm=$o(^temp($j,depfc,dept,datafc,xm)) q:xm=""  d
    ....s fee=$g(^temp($j,depfc,dept,datafc,xm))
    
    ....d OutputRow21
    k ^temp($j)
       
  	q $$$OK
OutputRow21
   	i $d(^DHCCAACCOUNTMONTHS(stdate)) s stmonth=$p(^DHCCAACCOUNTMONTHS(stdate),"^",2)
   	i $d(^DHCCAACCOUNTMONTHS(endate)) s enmonth=$p(^DHCCAACCOUNTMONTHS(endate),"^",2)
    i $d(^DHCCADEPTLEVELSETS(depfc)) s depfcname=$p(^DHCCADEPTLEVELSETS(depfc),"^",2)
    i $d(^DHCCADATALEVELSETS(datafc)) s datafcname=$p(^DHCCADATALEVELSETS(datafc),"^",2)
    i $d(^DHCCADATALEVELSETS(datafc)) d 
    .s child=$o(^DHCCADATALEVELSETS(0,"Item",datafc,xm,0))
    .s itemorder=$p(^DHCCADATALEVELSETS(datafc,"Items",child),"^",1)
	i $d(^DHCCAALLDATAITEMS(xm)) s itemname=$P(^DHCCAALLDATAITEMS(xm),"^",3)
	i $d(^DHCCAUNITDEPTS(dept)) s deptname=$p(^DHCCAUNITDEPTS(dept),"^",2)
	
  	s Data=$lb($g(stmonth),$g(enmonth),$g(depfc),$g(depfcname),dept,$g(deptname),$g(datafc),$g(datafcname),$g(xm),itemorder,$g(itemname),$g(fee))
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetVouchDatasdlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetVouchDatasdlExecute ]
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

ClassMethod GetVouchDatasdlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetVouchDatasdlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetVouchDatasdl(stdate As %Integer, endate As %Integer, UnitDr As %String) As %Query(ROWSPEC = "stmonth:%String,enmonth:%String,depfc:%Integer,depfcname:%String,dept:%Integer,deptname:%String,datafc:%Integer,datafcname:%String,xm:%Integer,itemorder:%Integer,itemname:%String,fee:%Float") [ SqlProc ]
{
}

//项目收入按科室统计结构分析

//d ##class(%ResultSet).RunQuery("web.RunqianQueryZgydZj","GetDeptincomedataMonth","1","3")	

ClassMethod GetDeptincomedataMonthExecute(ByRef qHandle As %Binary, stdate As %String, xm As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
   
    q:stdate="" $$$OK
    q:xm="" $$$OK
	s RowId="",RowIdIncome="",Income=""
	s RowIdData="",RowIdDataZc=""
	k ^temp($j)

    f  s RowIdIncome=$o(^DHCCAINCOMEDATAS(0,"IntervalItemdr",stdate,xm,RowIdIncome)) q:RowIdIncome=""  d
    .s fdept=$p(^DHCCAINCOMEDATAS(RowIdIncome),"^",11) q:fdept=""
    .s Income1=$p(^DHCCAINCOMEDATAS(RowIdIncome),"^",7) q:Income1=0
    .s ^temp($j,"Income",fdept)=$g(^temp($j,"Income",fdept))+Income1

    s dep=0 f  s dep=$o(^temp($j,"Income",dep)) q:dep=""  d
   	.s incomefee=$g(^temp($j,"Income",dep)) 
    .d OutputRow8
 	k ^temp($j)
 	;输出合计
 	;d OutputRowWorkSum
 	q $$$OK
OutputRow8
	;
	s descy=$p(^DHCCAACCOUNTMONTHS(stdate),"^",2)
    s mony=+$p(descy,"-",2)_""_"月"
    
	i $d(^DHCCAUNITDEPTS(dep)) s deptname=$p(^DHCCAUNITDEPTS(dep),"^",2)
	i $d(^DHCCAALLDATAITEMS(xm)) s itemname=$P(^DHCCAALLDATAITEMS(xm),"^",3)
 	s Data=$lb(mony,itemname,dep,deptname,$fn($g(incomefee),"",2))
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
	
OutputRowWorkSum1
    s Data=$lb("total",$g(totalFee))
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
 //ResetVariables
 //	 q
}

ClassMethod GetDeptincomedataMonthFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDeptincomedataMonthExecute ]
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

ClassMethod GetDeptincomedataMonthClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDeptincomedataMonthExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetDeptincomedataMonth(stdate As %String, xm As %String) As %Query(ROWSPEC = "mony:%String,itemname:%String,dep:%String,deptname:%String,incomefee:%Float") [ SqlProc ]
{
}

}
