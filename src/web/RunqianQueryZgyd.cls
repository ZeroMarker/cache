Import SQLUser

Class web.RunqianQueryZgyd Extends %RegisteredObject [ ProcedureBlock ]
{

//d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","GetYear")

ClassMethod GetYearExecute(ByRef qHandle As %Binary) As %Status [ SqlProc ]
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
	k ^temp($j)

    s RowId="" 
 
    f  s RowId=$o(^DHCCAACCOUNTMONTHS(RowId))  q:RowId=""  d
    .q:RowId=0
	.s month=$p(^DHCCAACCOUNTMONTHS(RowId),"^",2)
    .s monthQ=$p(month,"-",1)
    .s monthname=monthQ_""_"年" 
    .s ^temp($j,monthQ)=monthQ_"^"_monthname
    s locdr=0 f  s locdr=$o(^temp($j,locdr)) q:locdr=""  d
    .s monthyd=$g(^temp($j,locdr))
    .s monthy=$p(monthyd,"^",1)
    .s monthnd=$p(monthyd,"^",2)
    .d OutputRow1
 	;输出合计
 	;d OutputRowWorkSum
 	k ^temp($j)
 	q $$$OK	
  	
OutputRow1
	;
  	s Data=$lb(monthy,monthnd)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetYearFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetYearExecute, SqlProc ]
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

ClassMethod GetYearClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetYearExecute, SqlProc ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetYear() As %Query(ROWSPEC = "monthy:%String,monthnd:%String") [ SqlProc ]
{
}

//d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","GetMonth")

ClassMethod GetMonthExecute(ByRef qHandle As %Binary) As %Status [ SqlProc ]
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
	k ^temp($j)

    s RowId="" 
 
    f  s RowId=$o(^DHCCAACCOUNTMONTHS(RowId))  q:RowId=""  d
    .q:RowId=0
	.s code=$p(^DHCCAACCOUNTMONTHS(RowId),"^",1)
	.s name=$p(^DHCCAACCOUNTMONTHS(RowId),"^",2)
	.s monthQ=$p(name,"-",1)
    .s yearname=monthQ_""_"年" 
    .d OutputRow2
 	
 	k ^temp($j)
    q $$$OK	
  	
OutputRow2
	;
  	s Data=$lb(RowId,code,name,monthQ)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetMonthFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMonthExecute, SqlProc ]
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

ClassMethod GetMonthClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMonthExecute, SqlProc ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetMonth() As %Query(ROWSPEC = "RowId:%Integer,code:%Integer,name:%String,monthQ:%String") [ SqlProc ]
{
}

//d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","month")

Query month() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT AccountMonths_rowid,AccountMonths_name,AccountMonths_code
from dhc_ca_cache_data.AccountMonths WHERE
AccountMonths_rowid <>0
ORDER BY AccountMonths_code DESC
}

Query incomdatasJc() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
select incomedatas_intervaldr->AccountMonths_name,incomedatas_fdeptdr->unitdepts_name FROM dhc_ca_cache_data.incomedatas
where   incomedatas_fdeptdr not in(
select rdepts_deptdr  from dhc_ca_cache_data.rdepts)
group by incomedatas_intervaldr,incomedatas_fdeptdr
}

//月分析:以收定支—成本/医疗收入

//d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","GetCostYlsrBMonth","2014")

ClassMethod GetCostYlsrBMonthExecute(ByRef qHandle As %Binary, stdate As %String) As %Status [ SqlProc ]
{
	
 	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	q:stdate="" $$$OK
    k ^temp($j)

    s RowIdI="",RowIdIncome="",totalFeeZ=0
    s RowId="",RowId2="",id="",monthname="",Rowidfz=""
    
    f  s RowIdI=$o(^DHCCAACCOUNTMONTHS(RowIdI))  q:RowIdI=""  d
    .s desc=$p(^DHCCAACCOUNTMONTHS(RowIdI),"^",2)
    .s year=$p(desc,"-",1)
    .q:year'=stdate 
    .f  s RowIdIncome=$o(^DHCCAINCOMEDATAS(0,"Interval",RowIdI,RowIdIncome)) q:RowIdIncome=""  d
    ..s initem=$p(^DHCCAINCOMEDATAS(RowIdIncome),"^",6) ;q:(initem=29)!(initem=30)!(initem=1152)!(initem=25)
    ..q:$d(^DHCCADATALEVELSETS(0,"Item","38",initem))   //以收定支下的分层id
    ..s totalFee=$p(^DHCCAINCOMEDATAS(RowIdIncome),"^",7) 
    ..s ^temp($j,RowIdI,"Income")=$g(^temp($j,RowIdI,"Income"))+totalFee
 
    .f  s RowId=$o(^DHCCACOSTDISTSETS(0,"DInterval",1,RowIdI,RowId)) q:RowId=""  d
    ..s distflag=$p($g(^DHCCACOSTDISTSETS("1","CostResultData",RowId)),"^",6)  q:distflag'="self"
    ..s itemDr=$p(^DHCCACOSTDISTSETS(1,"CostResultData",RowId),"^",4) q:itemDr=""
    ..s VouchDatasdebit=$p(^DHCCACOSTDISTSETS("1","CostResultData",RowId),"^",5)  //成本金额
    ..f  s Rowidfz=$o(^DHCCADATALEVELSETS(Rowidfz))  q:Rowidfz=""  d  
    ...s parent=$p(^DHCCADATALEVELSETS(Rowidfz),"^",7)
    ...q:parent'=2
    ...q:'$d(^DHCCADATALEVELSETS(0,"Item",Rowidfz,itemDr)) 
   
    ...s ^temp($j,RowIdI,Rowidfz)=$g(^temp($j,RowIdI,Rowidfz))+VouchDatasdebit
    s locdr1=0 f  s locdr1=$o(^temp($j,locdr1)) q:locdr1=""  d
    .s descm=$p(^DHCCAACCOUNTMONTHS(locdr1),"^",2)
    .s monorder=+$p(descm,"-",2)
    .s mon=+$p(descm,"-",2)_""_"月"
    .s sumfee=$g(^temp($j,locdr1,"Income")) 
    .s fz=0 f  s fz=$o(^temp($j,locdr1,fz)) q:fz=""  d
    ..q:'$d(^DHCCADATALEVELSETS(fz))
    ..s fzname=$p(^DHCCADATALEVELSETS(fz),"^",2)
    ..s sumamt=$g(^temp($j,locdr1,fz)) 
    ..d OutputRow3
	
	k ^temp($j)
 	q $$$OK
    
OutputRow3
    	
 	s Data=$lb($g(stdate),$g(locdr1),$g(mon),$g(monorder),$fn(sumfee,"",2),$g(fz),$g(fzname),$fn(sumamt,"",2))
   	S ^CacheTemp(repid,ind)=Data
 	S ind=ind+1
	q
}

ClassMethod GetCostYlsrBMonthFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCostYlsrBMonthExecute, SqlProc ]
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

ClassMethod GetCostYlsrBMonthClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCostYlsrBMonthExecute, SqlProc ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetCostYlsrBMonth(stdate As %String) As %Query(ROWSPEC = "stdate:%String,locdr1:%Integer,mon:%String,monorder:%Integer,sumfee:%Float,fz:%String,fzname:%String,sumamt:%Float") [ SqlProc ]
{
}

//年分析:以收定支—成本/医疗收入

//d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","GetCostYlsrB")

ClassMethod GetCostYlsrBExecute(ByRef qHandle As %Binary) As %Status [ SqlProc ]
{
	
 	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
    k ^temp($j)

    s RowIdI="",RowIdIncome="",totalFeeZ=0
    s RowId="",RowId2="",id="",monthname="",Rowidfz=""
    
    f  s RowIdI=$o(^DHCCAACCOUNTMONTHS(RowIdI))  q:RowIdI=""  d
    .s desc=$p(^DHCCAACCOUNTMONTHS(RowIdI),"^",2)
    .s mon=+$p(desc,"-",2)_""_"月"
    .s year=$p(desc,"-",1)
    .;q:year<"2010"   
    .f  s RowIdIncome=$o(^DHCCAINCOMEDATAS(0,"Interval",RowIdI,RowIdIncome)) q:RowIdIncome=""  d
    ..s initem=$p(^DHCCAINCOMEDATAS(RowIdIncome),"^",6) 
    ..q:$d(^DHCCADATALEVELSETS(0,"Item","38",initem))
    ..s totalFee=$p(^DHCCAINCOMEDATAS(RowIdIncome),"^",7) 
    ..s ^temp($j,year,"Income")=$g(^temp($j,year,"Income"))+totalFee
 
    .f  s RowId=$o(^DHCCAVOUCHDATAS(0,"Interval",RowIdI,RowId)) q:RowId=""  d  
    ..s itemDr=$p(^DHCCAVOUCHDATAS(RowId),"^",3) q:itemDr=""
    ..s VouchDatasdebit=$p(^DHCCAVOUCHDATAS(RowId),"^",16) //成本金额
    ..f  s Rowidfz=$o(^DHCCADATALEVELSETS(Rowidfz))  q:Rowidfz=""  d  
    ...s parent=$p(^DHCCADATALEVELSETS(Rowidfz),"^",7)
    ...q:parent'=2
   
    ...q:'$d(^DHCCADATALEVELSETS(0,"Item",Rowidfz,itemDr)) 
    ...s itemDr1=itemDr
      
    ...s ^temp($j,year,Rowidfz)=$g(^temp($j,year,Rowidfz))+VouchDatasdebit
    s locdr1=0 f  s locdr1=$o(^temp($j,locdr1)) q:locdr1=""  d
    .s sumfee=$g(^temp($j,locdr1,"Income")) 
    .s fz=0 f  s fz=$o(^temp($j,locdr1,fz)) q:fz=""  d
    ..q:'$d(^DHCCADATALEVELSETS(fz))
    ..s fzname=$p(^DHCCADATALEVELSETS(fz),"^",2)
    ..s sumamt=$g(^temp($j,locdr1,fz)) 
    ..d OutputRow4
	 
	k ^temp($j)	
	q $$$OK
    
OutputRow4
    s yearN=locdr1_""_"年"
		
 	s Data=$lb($g(yearN),$fn(sumfee,"",2),$g(fz),$g(fzname),$fn(sumamt,"",2))
   	S ^CacheTemp(repid,ind)=Data
 	S ind=ind+1
	q
}

ClassMethod GetCostYlsrBFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCostYlsrBExecute, SqlProc ]
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

ClassMethod GetCostYlsrBClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCostYlsrBExecute, SqlProc ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetCostYlsrB() As %Query(ROWSPEC = "yearN:%String,sumfee:%Float,fz:%String,fzname:%String,sumamt:%Float") [ SqlProc ]
{
}

//月分析到明细:以收定支—成本/医疗收入,卢晓春10-10-05,暂时不用,做项目预算的时候用到

//d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","GetCostYlsrBMonthMx","2010")

ClassMethod GetCostYlsrBMonthMxExecute(ByRef qHandle As %Binary, stdate As %String) As %Status [ SqlProc ]
{
	
 	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	q:stdate="" $$$OK
    k ^temp($j)

    s RowIdI="",RowIdIncome="",totalFeeZ=0
    s RowId="",RowId2="",id="",monthname="",Rowidfz=""
    
    f  s RowIdI=$o(^DHCCAACCOUNTMONTHS(RowIdI))  q:RowIdI=""  d
    .s desc=$p(^DHCCAACCOUNTMONTHS(RowIdI),"^",2)
    .s year=$p(desc,"-",1)
    .q:year'=stdate 
    .f  s RowIdIncome=$o(^DHCCAINCOMEDATAS(0,"Interval",RowIdI,RowIdIncome)) q:RowIdIncome=""  d
    ..s initem=$p(^DHCCAINCOMEDATAS(RowIdIncome),"^",6) ;q:(initem=29)!(initem=30)!(initem=1152)!(initem=25)
    ..q:$d(^DHCCADATALEVELSETS(0,"Item","92",initem))
    ..s totalFee=$p(^DHCCAINCOMEDATAS(RowIdIncome),"^",7) 
    ..s ^temp($j,RowIdI,"Income")=$g(^temp($j,RowIdI,"Income"))+totalFee
 
    .f  s RowId=$o(^DHCCACOSTDISTSETS(0,"DInterval",1,RowIdI,RowId)) q:RowId=""  d
    ..s distflag=$p(^DHCCACOSTDISTSETS("1","CostResultData",RowId),"^",6)  q:distflag'="self"
    ..s itemDr=$p(^DHCCACOSTDISTSETS(1,"CostResultData",RowId),"^",4) q:itemDr=""
    ..s VouchDatasdebit=$p(^DHCCACOSTDISTSETS("1","CostResultData",RowId),"^",5)  //成本金额
    ..f  s Rowidfz=$o(^DHCCADATALEVELSETS(Rowidfz))  q:Rowidfz=""  d  
    ...s parent=$p(^DHCCADATALEVELSETS(Rowidfz),"^",7)
    ...q:parent'=70
    ...q:'$d(^DHCCADATALEVELSETS(0,"Item",Rowidfz,itemDr)) 
    ...s itemDr1=itemDr
      
    ...s ^temp($j,RowIdI,Rowidfz,itemDr1)=$g(^temp($j,RowIdI,Rowidfz,itemDr1))+VouchDatasdebit
    s locdr1=0 f  s locdr1=$o(^temp($j,locdr1)) q:locdr1=""  d
    .s descm=$p(^DHCCAACCOUNTMONTHS(locdr1),"^",2)
    .s monorder=+$p(descm,"-",2)
    .s mon=+$p(descm,"-",2)_""_"月"
    .s sumfee=$g(^temp($j,locdr1,"Income")) 
    .s fz=0 f  s fz=$o(^temp($j,locdr1,fz)) q:fz=""  d
    ..s item=0 f  s item=$o(^temp($j,locdr1,fz,item)) q:item=""  d
    ...s sumamt=$g(^temp($j,locdr1,fz,item)) 
    ...d OutputRow5
	
	k ^temp($j)
 	q $$$OK
    
OutputRow5
        
	s fzname=$p(^DHCCADATALEVELSETS(fz),"^",2)
	s itemDesc=$P(^DHCCAALLDATAITEMS(item),"^",3)
 	s Data=$lb($g(stdate),$g(locdr1),$g(mon),$g(monorder),$fn(sumfee,"",2),$g(fz),$g(fzname),$g(item),$g(itemDesc),$fn(sumamt,"",2))
   	S ^CacheTemp(repid,ind)=Data
 	S ind=ind+1
	q
}

ClassMethod GetCostYlsrBMonthMxFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCostYlsrBMonthMxExecute, SqlProc ]
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

ClassMethod GetCostYlsrBMonthMxClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCostYlsrBMonthMxExecute, SqlProc ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetCostYlsrBMonthMx(stdate As %String) As %Query(ROWSPEC = "stdate:%String,locdr1:%Integer,mon:%String,monorder:%Integer,sumfee:%Float,fz:%String,fzname:%String,item:%Integer,itemDesc:%String,sumamt:%Float") [ SqlProc ]
{
}

//合理用药：d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","GetincomedataMonthYao","2014")

ClassMethod GetincomedataMonthYaoExecute(ByRef qHandle As %Binary, stdate As %Integer) As %Status [ SqlProc ]
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	k ^temp($j)
	s sumfee="",totalFee="",totalyaoFee="",totalzsr="",zyyaofee=""
	q:stdate="" $$$OK
  	
 	s RowId="",RowId1="",RowIdIncome="",RowId1zy=""
 	s RowIdq="",RowIdq1="",RowIdqy="",RowIdqy1=""
    /*
    i $d(^DHCCAACCOUNTMONTHS(stdate)) d
	.s month=$p(^DHCCAACCOUNTMONTHS(stdate),"^",2)
    .s monthQ=$p(month,"-",1)
    .s monthname=monthQ_""_"年度"
    */
    s monthQ=stdate 
    s monthname=monthQ_""_"年度"
    f  s RowId=$o(^DHCCAACCOUNTMONTHS(RowId))  q:RowId=""  d
    .s desc=$p(^DHCCAACCOUNTMONTHS(RowId),"^",2)
    .s mon=+$p(desc,"-",2)_""_"月"
    .s desc1=$p(desc,"-",1)
    .q:desc1'=monthQ 
    .;s ^temp($j,RowId)=$g(^temp($j,RowId))
    .s locdr=RowId
  
    .f  s RowIdIncome=$o(^DHCCAINCOMEDATAS(0,"Interval",locdr,RowIdIncome)) q:RowIdIncome=""  d
    ..s totalFee=$p(^DHCCAINCOMEDATAS(RowIdIncome),"^",7) 
    ..s ^temp($j,"zsr",locdr)=$g(^temp($j,"zsr",locdr))+totalFee
    
    .f  s RowIdq=$o(^DHCCAACCOUNTMONTHS(0,"Period",locdr,19,RowIdq)) q:RowIdq=""  d
 	..s monthDrq=$p(^DHCCAACCOUNTMONTHS(locdr,"Periods",RowIdq),"^",2)
 	..f  s RowIdq1=$o(^DHCCAINCOMEDATAS(0,"Interval",monthDrq,RowIdq1)) q:RowIdq1=""  d
    ...s sumamtq1=$p(^DHCCAINCOMEDATAS(RowIdq1),"^",7) //去年同期收入
    ...s ^temp($j,"qnzsr",locdr)=$g(^temp($j,"qnzsr",locdr))+sumamtq1
      
    .f  s RowId1=$o(^DHCCAINCOMEDATAS(0,"Interval",locdr,RowId1)) q:RowId1=""  d
    ..s itemDr=$p(^DHCCAINCOMEDATAS(RowId1),"^",6) q:itemDr=""
    ..q:'$d(^DHCCADATALEVELSETS(0,"Item","3",itemDr)) //药品收入
    ..s yaofee=$p(^DHCCAINCOMEDATAS(RowId1),"^",7) 
    ..s ^temp($j,"yp",locdr)=$g(^temp($j,"yp",locdr))+yaofee
    
    .f  s RowIdqy=$o(^DHCCAACCOUNTMONTHS(0,"Period",locdr,19,RowIdqy)) q:RowIdqy=""  d
 	..s monthDrq1=$p(^DHCCAACCOUNTMONTHS(locdr,"Periods",RowIdqy),"^",2)
  	..f  s RowIdqy1=$o(^DHCCAINCOMEDATAS(0,"Interval",monthDrq1,RowIdqy1)) q:RowIdqy1=""  d
    ...s itemDry=$p(^DHCCAINCOMEDATAS(RowIdqy1),"^",6) q:itemDry=""
    ...q:'$d(^DHCCADATALEVELSETS(0,"Item","3",itemDry)) //药品收入
    ...s yaofeey=$p(^DHCCAINCOMEDATAS(RowIdqy1),"^",7) //去年同期药品收入
    ...s ^temp($j,"qnyp",locdr)=$g(^temp($j,"qnyp",locdr))+yaofeey
    
    .f  s RowId1zy=$o(^DHCCAINCOMEDATAS(0,"Interval",locdr,RowId1zy)) q:RowId1zy=""  d
    ..s itemDrzy=$p(^DHCCAINCOMEDATAS(RowId1zy),"^",6) q:itemDrzy'="18"  //中草药
    ..q:'$d(^DHCCADATALEVELSETS(0,"Item","3",itemDrzy)) //药品收入
    ..s zyyaofee=$p(^DHCCAINCOMEDATAS(RowId1zy),"^",7) 
    ..s ^temp($j,"zyyp",locdr)=$g(^temp($j,"zyyp",locdr))+zyyaofee
    
    s locdrs=0 f  s locdrs=$o(^temp($j,"zsr",locdrs)) q:locdrs=""  d
    .s outdata=$g(^temp($j,"zsr",locdrs))_"^"_$g(^temp($j,"yp",locdrs))_"^"_$g(^temp($j,"qnzsr",locdrs))_"^"_$g(^temp($j,"qnyp",locdrs))_"^"_$g(^temp($j,"zyyp",locdr))
    
    .s zsr=$p(outdata,"^",1)
    .s yao=$p(outdata,"^",2)
    .s zsrq=$p(outdata,"^",3)
    .s yaoq=$p(outdata,"^",4)
    .s zyyao=$p(outdata,"^",5)
    .s yaobl=yao/zsr
    .s zyaobl=zyyao/zsr
    .s yaoz=yao-yaoq  
    .s ylsz=zsr-yao-zsrq+yaoq
    .s ylqn=zsrq-yaoq
    .i yaoq'="" s ypzf=yaoz/$g(yaoq),ylzf=ylsz/$g(ylqn)
    .e  s ypzf=0,ylzf=0
   	.d OutputRow6
  
 	;输出合计
 	;d OutputRowWorkSum
 	;k ^temp($j)
 	q $$$OK
OutputRow6
	
 	q:'$d(^DHCCAACCOUNTMONTHS(locdrs))
    s descy=$p(^DHCCAACCOUNTMONTHS(locdrs),"^",2)
    s monthQ=+$p(descy,"-",2)
    s mony=+$p(descy,"-",2)_""_"月"
 	
 	s Data=$lb($g(monthname),$g(locdrs),$g(mony),$g(zsr),$g(yao),$g(yaobl),$g(zyaobl),$g(ypzf),$g(ylzf),$g(zsrq),$g(yaoq),monthQ,$g(zyyao))
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
	
OutputRowWorkSum6
    s Data=$lb("total",$g(totalFee))
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
 //ResetVariables
 //	 q
}

ClassMethod GetincomedataMonthYaoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetincomedataMonthYaoExecute, SqlProc ]
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

ClassMethod GetincomedataMonthYaoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetincomedataMonthYaoExecute, SqlProc ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetincomedataMonthYao(stdate As %Integer) As %Query(ROWSPEC = "monthname:%String,locdrs:%Integer,mony:%String,zsr:%Float,yao:%Float,yaobl:%Float,zyaobl:%Float,ypzf:%Float,ylzf:%Float,zsrq:%Float,yaoq:%Float,monthQ:%Integer,zyyao:%Float") [ SqlProc ]
{
}

//科室用药占比：d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","GetincomedataDeptYao","3","137")

ClassMethod GetincomedataDeptYaoExecute(ByRef qHandle As %Binary, stdate As %Integer, dept As %Integer) As %Status [ SqlProc ]
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	k ^temp($j)
	
	s sumfee="",totalFee="",totalyaoFee="",totalzsr=""
	q:stdate="" $$$OK
  	q:dept="" $$$OK
  	i $d(^DHCCAUNITDEPTS(dept)) s deptname=$p(^DHCCAUNITDEPTS(dept),"^",2)
 	s RowId="",RowId1="",RowIdIncome=""
 	s RowIdq="",RowIdq1="",RowIdqy="",RowIdqy1=""
    
    i $d(^DHCCAACCOUNTMONTHS(stdate)) d
	.s month=$p(^DHCCAACCOUNTMONTHS(stdate),"^",2)
    .s monthQ=$p(month,"-",1)
    .s monthname=monthQ_""_"年度"
    
    ;s monthQ=stdate 
    ;s monthname=monthQ_""_"年度"
    f  s RowId=$o(^DHCCAACCOUNTMONTHS(RowId))  q:RowId=""  d
    .s desc=$p(^DHCCAACCOUNTMONTHS(RowId),"^",2)
    .s mon=+$p(desc,"-",2)_""_"月"
    .s desc1=$p(desc,"-",1)
    .q:desc1'=monthQ 
    .s ^temp($j,RowId)=$g(^temp($j,RowId))
    .s locdr=RowId
 
    .f  s RowIdIncome=$o(^DHCCAINCOMEDATAS(0,"IntervalFdeptdr",locdr,dept,RowIdIncome)) q:RowIdIncome=""  d
    ..s totalFee=$p(^DHCCAINCOMEDATAS(RowIdIncome),"^",7) 
    ..s ^temp($j,"zsr",locdr)=$g(^temp($j,"zsr",locdr))+totalFee
    
    .f  s RowIdq=$o(^DHCCAACCOUNTMONTHS(0,"Period",locdr,19,RowIdq)) q:RowIdq=""  d
 	..s monthDrq=$p(^DHCCAACCOUNTMONTHS(locdr,"Periods",RowIdq),"^",2)
 	..f  s RowIdq1=$o(^DHCCAINCOMEDATAS(0,"IntervalFdeptdr",monthDrq,dept,RowIdq1)) q:RowIdq1=""  d
    ...s sumamtq1=$p(^DHCCAINCOMEDATAS(RowIdq1),"^",7) //去年同期收入
    ...s ^temp($j,"qnzsr",locdr)=$g(^temp($j,"qnzsr",locdr))+sumamtq1
      
    .f  s RowId1=$o(^DHCCAINCOMEDATAS(0,"IntervalFdeptdr",locdr,dept,RowId1)) q:RowId1=""  d
    ..s itemDr=$p(^DHCCAINCOMEDATAS(RowId1),"^",6) q:itemDr=""
    ..q:'$d(^DHCCADATALEVELSETS(0,"Item","3",itemDr))
    ..s yaofee=$p(^DHCCAINCOMEDATAS(RowId1),"^",7) 
    ..s ^temp($j,"yp",locdr)=$g(^temp($j,"yp",locdr))+yaofee
    
    .f  s RowIdqy=$o(^DHCCAACCOUNTMONTHS(0,"Period",locdr,19,RowIdqy)) q:RowIdqy=""  d
 	..s monthDrq1=$p(^DHCCAACCOUNTMONTHS(locdr,"Periods",RowIdqy),"^",2)
  	..f  s RowIdqy1=$o(^DHCCAINCOMEDATAS(0,"IntervalFdeptdr",monthDrq1,dept,RowIdqy1)) q:RowIdqy1=""  d
    ...s itemDry=$p(^DHCCAINCOMEDATAS(RowIdqy1),"^",6) q:itemDry=""
    ...q:'$d(^DHCCADATALEVELSETS(0,"Item","3",itemDry))
    ...s yaofeey=$p(^DHCCAINCOMEDATAS(RowIdqy1),"^",7) //去年同期药品收入
    ...s ^temp($j,"qnyp",locdr)=$g(^temp($j,"qnyp",locdr))+yaofeey
    
    
    s locdrs=0 f  s locdrs=$o(^temp($j,"zsr",locdrs)) q:locdrs=""  d
    .s outdata=$g(^temp($j,"zsr",locdrs))_"^"_$g(^temp($j,"yp",locdrs))_"^"_$g(^temp($j,"qnzsr",locdrs))_"^"_$g(^temp($j,"qnyp",locdrs))
    
    .s zsr=$p(outdata,"^",1)
    .s yao=$p(outdata,"^",2)
    .s zsrq=$p(outdata,"^",3)
    .s yaoq=$p(outdata,"^",4)
    .s yaobl=yao/zsr
    .s yaoz=yao-yaoq  
    .s ylsz=zsr-yao-zsrq+yaoq
    .s ylqn=zsrq-yaoq
    .i yaoq'="" s ypzf=yaoz/$g(yaoq),ylzf=ylsz/$g(ylqn)
    .e  s ypzf=0,ylzf=0
   	.d OutputRow7
  
 	;输出合计
 	;d OutputRowWorkSum
 	k ^temp($j)
 	q $$$OK
OutputRow7
	
 	q:'$d(^DHCCAACCOUNTMONTHS(locdrs))
    s descy=$p(^DHCCAACCOUNTMONTHS(locdrs),"^",2)
    s monthm=+$p(descy,"-",2)
    s mony=+$p(descy,"-",2)_""_"月"
 	
 	s Data=$lb($g(monthname),$g(locdrs),$g(mony),$fn($g(zsr),"",2),$fn($g(yao),"",2),$g(yaobl),$g(ypzf),$g(ylzf),$fn($g(zsrq),"",2),$fn($g(yaoq),"",2),$g(monthm),$g(deptname))
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
	
OutputRowWorkSum4
    s Data=$lb("total",$g(totalFee))
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
 //ResetVariables
 //	 q
}

ClassMethod GetincomedataDeptYaoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetincomedataDeptYaoExecute, SqlProc ]
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

ClassMethod GetincomedataDeptYaoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetincomedataDeptYaoExecute, SqlProc ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetincomedataDeptYao(stdate As %Integer, dept As %Integer) As %Query(ROWSPEC = "monthname:%String,locdrs:%Integer,mony:%String,zsr:%Float,yao:%Float,yaobl:%Float,ypzf:%Float,ylzf:%Float,zsrq:%Float,yaoq:%Float,monthm:%Integer,deptname:%String") [ SqlProc ]
{
}

//科室分析:

//d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","GetFtJyfx1","1","1","demo")

ClassMethod GetFtJyfx1Execute(ByRef qHandle As %Binary, stdate As %String, type As %String, user As %String) As %Status [ SqlProc ]
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
 	
	q:stdate="" $$$OK
	q:type="" $$$OK
	q:user="" $$$OK
	k ^temp($j)
	
	s RowIdu="",unitrid=""  
    s RowId="",RowId2="",RowIdRole="",RowIdPara="",RowIdParaM="",RowIdParaZ=""
    s RowIdIncome="",RowIdcost="",RowIdDept=""
    i $d(^DHCCAACCOUNTMONTHS(stdate)) s month=$p(^DHCCAACCOUNTMONTHS(stdate),"^",2)
    s month1=$p(month,"-",1)
    s day=$p(month,"-",2)
    s monthname=month1_""_"年"_""_day_""_"月"

 
  /* f  s RowId=$o(^DHCCAUSERS(0,"Loginname",user,RowId)) q:RowId=""  d
    .f  s RowIdRole=$o(^DHCCAUSERS(RowId,"URoles",RowIdRole))  q:RowIdRole=""  d*/
    f  s RowIdu=$o(^DHCCAUSERS(0,"Loginname",user,RowIdu)) q:RowIdu=""  d	//取Users表DR
    .s bz=$p(^DHCCAUSERS(RowIdu),"^",5)  //取集团医院ID 1总部,2二部,3三部  --Users_remark
    .f  s unitrid=$o(^DHCCAUNITDEPTS(0,"Unit",unitrid))  q:unitrid=""  d	//取医院units表DR
    ..q:$F(","_bz_",",","_unitrid_",")=0
    
    ..f  s RowIdDept=$o(^DHCCAROLES(type,"RDepts",RowIdDept)) q:RowIdDept=""  d		//取角色科室表RDepts的RDepts_childSub
    ...q:RowIdDept=0
    ...s deptdr=$P(^DHCCAROLES(type,"RDepts",RowIdDept),"^",2) q:deptdr=""			//取角色科室表RDepts的RDepts_deptDr
    ...q:'$d(^DHCCAUNITDEPTS(0,"Unit",unitrid,deptdr))
    ...s ^temp($j,deptdr,unitrid)=$g(^temp($j,deptdr,unitrid))			//根据科室角色得到对应的科室DR和该科室的归属医院DR
    
 	s paraitem=0 
    s locdr=0 f  s locdr=$o(^temp($j,locdr)) q:locdr=""  d
    .i ($d(^DHCCAUNITDEPTS(locdr)))  s deptName=$p(^DHCCAUNITDEPTS(locdr),"^",2)
    .f  s RowIdIncome=$o(^DHCCAINCOMEDATAS(0,"IntervalFdeptdr",stdate,locdr,RowIdIncome)) q:RowIdIncome=""  d
    ..s InComeDatafee=$p(^DHCCAINCOMEDATAS(RowIdIncome),"^",7)
    ..s ^temp($j,locdr,"Income")=$g(^temp($j,locdr,"Income"))+InComeDatafee
      
    ..s itemDr=$p(^DHCCAINCOMEDATAS(RowIdIncome),"^",6) q:itemDr=""
    ..q:'$d(^DHCCADATALEVELSETS(0,"Item","3",itemDr))
    ..s yaofeei=$p(^DHCCAINCOMEDATAS(RowIdIncome),"^",7) 
    ..s ^temp($j,locdr,"yaopi")=$g(^temp($j,locdr,"yaopi"))+yaofeei   //药品收入
       
    .f  s RowIdParaM=$o(^DHCCAPARAMDATAS(0,"IntervalSereddep",stdate,locdr,RowIdParaM)) q:RowIdParaM=""  d
    ..s paraitem=$p(^DHCCAPARAMDATAS(RowIdParaM),"^",4)   q:(paraitem'=141)&(paraitem'=142)
    ..s paradata=$p(^DHCCAPARAMDATAS(RowIdParaM),"^",11) //门诊人次、住院床日
    ..s ^temp($j,locdr,"Para")=$g(^temp($j,locdr,"Para"))+$g(paradata)
    
    ..;f  s RowIdcost=$o(^DHCCACOSTDISTSETS(1,"IntIDFlag",stdate,locdr,"leaf",RowIdcost)) q:RowIdcost=""   d
    ..;.s sumamt=$p(^DHCCACOSTDISTSETS(1,"CostResultSum",RowIdcost),"^",7)	//全成本金额
    ..;.s sumdir=$p(^DHCCACOSTDISTSETS(unit,"CostResultSum",RowIdcost),"^",4)	//直接成本金额
    ..;.s ^temp($j,locdr,"Cost")=$g(^temp($j,locdr,"Cost"))+$g(sumamt)
    ..;.s ^temp($j,locdr,"DirCost")=$g(^temp($j,locdr,"DirCost"))+$g(sumdir)
    
    
    .s RowIdcrd="" f  s RowIdcrd=$o(^DHCCACOSTDISTSETS(0,"DIntDistdept",1,stdate,locdr,RowIdcrd)) q:RowIdcrd=""  d
    ..;s distflag=$p(^DHCCACOSTDISTSETS(1,"CostResultData",RowIdcrd),"^",6)	//成本标志 self/dist
    ..s datafee=$p(^DHCCACOSTDISTSETS(1,"CostResultData",RowIdcrd),"^",5)	//成本金额
    ..s depted=$p(^DHCCACOSTDISTSETS(1,"CostResultData",RowIdcrd),"^",2) 	//被分摊科室DR
    ..s ^temp($j,locdr,"Cost")=$g(^temp($j,locdr,"Cost"))+$g(datafee)		//全成本
    ..i depted="" d		//被分摊科室为空，则获取成本为直接成本，否则为分摊成本
    ...s ^temp($j,locdr,"DirCost")=$g(^temp($j,locdr,"DirCost"))+$g(datafee)	//直接成本
    ..e  d
    ...i $d(^DHCCADEPTLEVELSETS(0,"Dept",2,depted)) s ^temp($j,locdr,"ggCost")=$g(^temp($j,locdr,"xzhqCost"))+$g(datafee)	//公共分摊
    ...i $d(^DHCCADEPTLEVELSETS(0,"Dept",3,depted)) s ^temp($j,locdr,"xzCost")=$g(^temp($j,locdr,"xzhqCost"))+$g(datafee)	//行政分摊
    ...i $d(^DHCCADEPTLEVELSETS(0,"Dept",4,depted)) s ^temp($j,locdr,"yfCost")=$g(^temp($j,locdr,"yfCost"))+$g(datafee)		//医辅分摊
    ...i $d(^DHCCADEPTLEVELSETS(0,"Dept",5,depted)) s ^temp($j,locdr,"yjCost")=$g(^temp($j,locdr,"yjCost"))+$g(datafee)		//医技分摊

    .s parasum=$g(^temp($j,locdr,"Para")) 
    .s sumfee=$g(^temp($j,locdr,"Income")) 
    .s costFee=$g(^temp($j,locdr,"Cost")) 
    .s DirCostFee=$g(^temp($j,locdr,"DirCost")) 
    .s ggCostFee=$g(^temp($j,locdr,"ggCost")) 
    .s xzCostFee=$g(^temp($j,locdr,"xzCost")) 
    .s yfCostFee=$g(^temp($j,locdr,"yfCost")) 
    .s yjCostFee=$g(^temp($j,locdr,"yjCost")) 
    .s amt=sumfee-costFee
    .s sumyao=$g(^temp($j,locdr,"yaopi")) 
    .i parasum'=""  s sumpara=sumfee/parasum,costpara=costFee/parasum,amtpara=amt/parasum
    .e  s sumpara=0,costpara=0,amtpara=0
    .d OutputRow8 
   	 
   	k ^temp($j)
  	q $$$OK
OutputRow8
	
  	s Data=$lb($g(monthname),locdr,$g(deptName),$g(parasum),$g(sumfee),$g(costFee),$g(DirCostFee),$g(ggCostFee),$g(xzCostFee),$g(yfCostFee),$g(yjCostFee),$g(amt),$g(sumpara),$g(costpara),$g(amtpara),$g(sumyao))
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
}

ClassMethod GetFtJyfx1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetFtJyfx1Execute, SqlProc ]
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

ClassMethod GetFtJyfx1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetFtJyfx1Execute, SqlProc ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetFtJyfx1(stdate As %String, type As %String, user As %String) As %Query(ROWSPEC = "monthname:%String,locdr:%Integer,deptname:%String,parasum:%Float,sumfee:%Float,costfee:%Float,DirCostFee:%Float,ggCostFee:%Float,xzCostFee:%Float,yfCostFee:%Float,yjCostFee:%Float,amt:%Float,sumpara:%Float,costpara:%Float,amtpara:%Float,sumyao:%Float") [ SqlProc ]
{
}

//年度趋势分析

//d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","GetFtQsfx1Year","2014")

ClassMethod GetFtQsfx1YearExecute(ByRef qHandle As %Binary, stdate As %String) As %Status [ SqlProc ]
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
 	
 
	q:stdate="" $$$OK
	s RowId="",RowIdIncome="",RowIdCost="",Income="",Cost=""
	k ^temp($j)
	;i $d(^DHCCAUNITDEPTS(dept)) s deptname=$p(^DHCCAUNITDEPTS(dept),"^",2)
	/*
	i $d(^DHCCAACCOUNTMONTHS(stdate)) d
	.s month=$p(^DHCCAACCOUNTMONTHS(stdate),"^",2)
    .s monthQ=$p(month,"-",1)
    .s monthname=monthQ_""_"年度"
    */
    f  s RowId=$o(^DHCCAACCOUNTMONTHS(RowId))  q:RowId=""  d
    .s desc=$p(^DHCCAACCOUNTMONTHS(RowId),"^",2)
    .s mon=+$p(desc,"-",2)_""_"月"
    .s desc1=$p(desc,"-",1)
    .q:desc1'=stdate 
    .s monthorder=+$p(desc,"-",2)
    
    .s ^temp($j,RowId)=$g(^temp($j,RowId))
    .s locdr=RowId
    .f  s RowIdIncome=$o(^DHCCAINCOMEDATAS(0,"Interval",locdr,RowIdIncome)) q:RowIdIncome=""  d
    ..s Income1=$p(^DHCCAINCOMEDATAS(RowIdIncome),"^",7)
    ..s ^temp($j,locdr,"Income")=$g(^temp($j,locdr,"Income"))+Income1
 
    .f  s RowIdCost=$o(^DHCCACOSTDISTSETS(1,"IntIDFlag",locdr,1,"branch",RowIdCost)) q:RowIdCost=""   d
    ..s Cost1=$p(^DHCCACOSTDISTSETS(1,"CostResultSum",RowIdCost),"^",4) //成本金额
   	..s ^temp($j,locdr,"Cost")=$g(^temp($j,locdr,"Cost"))+Cost1
   
    .s incomefee=$g(^temp($j,locdr,"Income")) 
    .s costfee=$g(^temp($j,locdr,"Cost")) 
    .s amt=incomefee-costfee
 	.d OutputRow9
    
    k ^temp($j)
 	q $$$OK
OutputRow9
	;
  	s Data=$lb(locdr,$g(mon),$g(monthorder),$g(incomefee),$g(costfee),$g(amt))
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetFtQsfx1YearFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetFtQsfx1YearExecute, SqlProc ]
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

ClassMethod GetFtQsfx1YearClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetFtQsfx1YearExecute, SqlProc ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetFtQsfx1Year(stdate As %String) As %Query(ROWSPEC = "locdr:%Integer,mon:%String,monthorder:%Integer,incomefee:%Float,costfee:%Float,amt:%Float") [ SqlProc ]
{
}

//d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","GetFtQsfx1","1","3")

ClassMethod GetFtQsfx1Execute(ByRef qHandle As %Binary, stdate As %String, dept As %String) As %Status [ SqlProc ]
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
 	
 
	q:stdate="" $$$OK
	s RowId="",RowIdIncome="",RowIdCost="",Income="",Cost=""
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
    .s monthorder=+$p(desc,"-",2)
    
    .s ^temp($j,RowId)=$g(^temp($j,RowId))
    .s locdr=RowId
    .f  s RowIdIncome=$o(^DHCCAINCOMEDATAS(0,"IntervalFdeptdr",locdr,dept,RowIdIncome)) q:RowIdIncome=""  d
    ..s Income1=$p(^DHCCAINCOMEDATAS(RowIdIncome),"^",7)
    ..s ^temp($j,locdr,"Income")=$g(^temp($j,locdr,"Income"))+Income1
 
    .f  s RowIdCost=$o(^DHCCACOSTDISTSETS(1,"IntIDFlag",locdr,dept,"leaf",RowIdCost)) q:RowIdCost=""   d
    ..s Cost1=$p(^DHCCACOSTDISTSETS(1,"CostResultSum",RowIdCost),"^",7) //成本金额
   	..s ^temp($j,locdr,"Cost")=$g(^temp($j,locdr,"Cost"))+Cost1
   
    .s incomefee=$g(^temp($j,locdr,"Income")) 
    .s costfee=$g(^temp($j,locdr,"Cost")) 
    .s amt=incomefee-costfee
 	.d OutputRow10
    
    k ^temp($j)
 	q $$$OK
OutputRow10
	;
  	s Data=$lb($g(monthname),$g(mon),deptname,locdr,$g(incomefee),$g(costfee),$g(amt),$g(monthorder))
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetFtQsfx1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetFtQsfx1Execute, SqlProc ]
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

ClassMethod GetFtQsfx1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetFtQsfx1Execute, SqlProc ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetFtQsfx1(stdate As %String, dept As %String) As %Query(ROWSPEC = "monthname:%String,mon:%String,deptname:%String,locdr:%Integer,incomefee:%Float,costfee:%Float,amt:%Float,monthorder:%Integer") [ SqlProc ]
{
}

//d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","GetincomedataDeptMonth","7","126")

ClassMethod GetincomedataDeptMonthExecute(ByRef qHandle As %Binary, stdate As %Integer, dept As %Integer) As %Status [ SqlProc ]
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	//Do ResetVariables
	k ^temp($j) //,sumfee //totalFee
	q:stdate="" $$$OK
 	q:dept="" $$$OK
 	
 	s RowId=""
    f  s RowId=$o(^DHCCAINCOMEDATAS(0,"IntervalFdeptdr",stdate,dept,RowId)) q:RowId=""  d
    .s itemDr=$p(^DHCCAINCOMEDATAS(RowId),"^",6)
    .s IncomeDatafee=$p(^DHCCAINCOMEDATAS(RowId),"^",7) 
    .s ^temp($j,itemDr)=$g(^temp($j,itemDr))+IncomeDatafee
    s locdr=0 f  s locdr=$o(^temp($j,locdr)) q:locdr=""  d
    .s sumfee=$g(^temp($j,locdr))
    .s totalFee=$g(totalFee)+sumfee
    .d OutputRow11
 	 
 	;输出合计
 	d OutputRowSum11
 	k ^temp($j)
 	q $$$OK
OutputRow11
	;
 	s Data=$lb(locdr,$fn($g(sumfee),"",2))
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q

OutputRowSum11
    s Data=$lb(0,$fn($g(totalFee),"",2))
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
    q
}

ClassMethod GetincomedataDeptMonthFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetincomedataDeptMonthExecute, SqlProc ]
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

ClassMethod GetincomedataDeptMonthClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetincomedataDeptMonthExecute, SqlProc ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetincomedataDeptMonth(stdate As %Integer, dept As %Integer) As %Query(ROWSPEC = "locdr:%Integer,sumfee:%Float") [ SqlProc ]
{
}

Query datazfc() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT levelitems_parref,levelitems_itemdr,levelitems_itemdr->alldataitems_name 
from dhc_ca_cache_data.LevelItems
WHERE levelitems_childsub<>0  and dhc_ca_cache_data.LevelItems.LevelItems_childSub <>0
}

//d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","GetCostResultDataDept","126")

ClassMethod GetCostResultDataDeptExecute(ByRef qHandle As %Binary, dept As %String) As %Status [ SqlProc ]
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
	k ^temp($j)
	q:dept="" $$$OK
	
 	s RowId=""    

    f  s RowId=$o(^DHCCACOSTDISTSETS(0,"Distdept",1,dept,RowId)) q:RowId=""  d

    .s intervalDr=$p(^DHCCACOSTDISTSETS(1,"CostResultData",RowId),"^",1) 
    .s datafee=$p(^DHCCACOSTDISTSETS(1,"CostResultData",RowId),"^",5) //成本金额
     
    .s ^temp($j,intervalDr)=$g(^temp($j,intervalDr))+datafee
    s locdr=0 f  s locdr=$o(^temp($j,locdr)) q:locdr=""  d
    .s sumamt=$g(^temp($j,locdr)) 
    .d OutputRow12
 	;输出合计
 	;d OutputRowWorkSum
 	k ^temp($j)
 	q $$$OK	
  	
OutputRow12
	;
  	s Data=$lb(locdr,$fn(sumamt,"",2))
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetCostResultDataDeptFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCostResultDataDeptExecute, SqlProc ]
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

ClassMethod GetCostResultDataDeptClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCostResultDataDeptExecute, SqlProc ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetCostResultDataDept(dept As %String) As %Query(ROWSPEC = "locdr:%Integer,sumamt:%Float") [ SqlProc ]
{
}

//d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","GetCostResultData","3","126")

ClassMethod GetCostResultDataExecute(ByRef qHandle As %Binary, stdate As %String, dept As %String) As %Status [ SqlProc ]
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
	k ^temp($j)

	q:stdate="" $$$OK
	
 	s RowId=""    
 
    f  s RowId=$o(^DHCCACOSTDISTSETS(0,"DIntDistdept",1,stdate,dept,RowId)) q:RowId=""  d

    .s itemdr=$p(^DHCCACOSTDISTSETS(1,"CostResultData",RowId),"^",4)
    .s datafee=$p(^DHCCACOSTDISTSETS(1,"CostResultData",RowId),"^",5) //成本金额
    .s flag=$p(^DHCCACOSTDISTSETS(1,"CostResultData",RowId),"^",6)
    
    .s ^temp($j,dept,itemdr)=$g(^temp($j,dept,itemdr))+datafee
    s locdr=0 f  s locdr=$o(^temp($j,locdr)) q:locdr=""  d
    .s item=0 f  s item=$o(^temp($j,locdr,item)) q:item=""  d
    ..s sumamt=$g(^temp($j,locdr,item)) 
    ..s totalFee=$g(totalFee)+sumamt
    ..d OutputRow13
 	;输出合计
 	d OutputRowWorkSum13
 	k ^temp($j)
 	q $$$OK	
  	
OutputRow13
	;
  	s Data=$lb(item,$fn(sumamt,"",2))
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q

OutputRowWorkSum13
    s Data=$lb(0,$g(totalFee))
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1 
    q
}

ClassMethod GetCostResultDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCostResultDataExecute, SqlProc ]
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

ClassMethod GetCostResultDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCostResultDataExecute, SqlProc ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetCostResultData(stdate As %String, dept As %String) As %Query(ROWSPEC = "item:%Integer,sumamt:%Float") [ SqlProc ]
{
}

ClassMethod GetCostResultDataZjExecute(ByRef qHandle As %Binary, stdate As %String, dept As %String) As %Status [ SqlProc ]
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
	k ^temp($j)
	q:stdate="" $$$OK
	
 	s RowId=""    
 
    f  s RowId=$o(^DHCCACOSTDISTSETS(1,"IntIDFlag",stdate,dept,"leaf",RowId)) q:RowId=""   d
    .s datafee=$p(^DHCCACOSTDISTSETS(1,"CostResultSum",RowId),"^",4)

    .s sumamt=datafee
    .d OutputRow14
 	;输出合计
 	;d OutputRowWorkSum
 	k ^temp($j)
 	q $$$OK	
  	
OutputRow14
	;
  	s Data=$lb(locdr,$fn(sumamt,"",2))
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetCostResultDataZjFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCostResultDataZjExecute, SqlProc ]
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

ClassMethod GetCostResultDataZjClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCostResultDataZjExecute, SqlProc ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetCostResultDataZj(stdate As %String, dept As %String) As %Query(ROWSPEC = "locdr:%String,sumamt:%Float") [ SqlProc ]
{
}

ClassMethod GetUnitDeptExecute(ByRef qHandle As %Binary) As %Status [ SqlProc ]
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	

 	s RowId=""
    f  s RowId=$o(^DHCCAUNITDEPTS(RowId)) q:RowId=""  d
    .s UnitDeptsname=$p(^DHCCAUNITDEPTS(RowId),"^",2)
    . d OutputRow15
 	
  	q $$$OK
OutputRow15
	;
 	s Data=$lb(RowId,UnitDeptsname)
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
 //OutputRowWorkSum
    
 //ResetVariables
 //	 q
}

ClassMethod GetUnitDeptFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUnitDeptExecute, SqlProc ]
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

ClassMethod GetUnitDeptClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUnitDeptExecute, SqlProc ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetUnitDept() As %Query(ROWSPEC = "RowId:%Integer,UnitDeptsname:%String") [ SqlProc ]
{
}

ClassMethod GetParaDataExecute(ByRef qHandle As %Binary, stdate As %String, dept As %String) As %Status [ SqlProc ]
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
	k ^temp($j)

	q:stdate="" $$$OK
	
 	s RowId=""    

    f  s RowId=$o(^DHCCAPARAMDATAS(0,"IntervalSereddep",stdate,dept,RowId)) q:RowId=""  d

    .s itemdr=$p(^DHCCAPARAMDATAS(RowId),"^",4)
    .s paradata=$p(^DHCCAPARAMDATAS(RowId),"^",11) 
     
    .s ^temp($j,itemdr)=$g(^temp($j,itemdr))+paradata
    s locdr=0 f  s locdr=$o(^temp($j,locdr)) q:locdr=""  d
    .s sumamt=$g(^temp($j,locdr)) 
    .d OutputRow16
 	;输出合计
 	;d OutputRowWorkSum
 	k ^temp($j)
 	q $$$OK	
  	
OutputRow16
	;
  	s Data=$lb(locdr,$fn(sumamt,"",2))
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetParaDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetParaDataExecute, SqlProc ]
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

ClassMethod GetParaDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetParaDataExecute, SqlProc ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetParaData(stdate As %String, dept As %String) As %Query(ROWSPEC = "locdr:%Integer,sumamt:%Float") [ SqlProc ]
{
}

//d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","GetRole","demo")

ClassMethod GetRoleExecute(ByRef qHandle As %Binary, usercode As %String) As %Status [ SqlProc ]
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
 	
	q:usercode="" $$$OK

    s RowId="",RowIdRole=""
    f  s RowId=$o(^DHCCAUSERS(0,"Loginname",usercode,RowId)) q:RowId=""  d
    .s userActive=$p(^DHCCAUSERS(RowId),"^",6)
    .q:userActive="N"
    .f  s RowIdRole=$o(^DHCCAUSERS(RowId,"URoles",RowIdRole))  q:RowIdRole=""  d
    ..s roledr=$p(^DHCCAUSERS(RowId,"URoles",RowIdRole),"^",2) 
    ..q:roledr=""
    ..i $d(^DHCCAROLES(roledr)) d
    ...s dept=$p(^DHCCAROLES(roledr),"^",3) 
    ...s page1=$p(^DHCCAROLES(roledr),"^",6)
    ...s roleActive=$p(^DHCCAROLES(roledr),"^",8)
    ...q:roleActive="N"
    ...d OutputRow17
 	 
  	q $$$OK
OutputRow17
	
  	s Data=$lb(roledr,dept,page1)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
}

ClassMethod GetRoleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRoleExecute, SqlProc ]
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

ClassMethod GetRoleClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRoleExecute, SqlProc ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetRole(usercode As %String) As %Query(ROWSPEC = "roledr:%Integer,dept:%String,page1:%String") [ SqlProc ]
{
}

//d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","GetBbdfx","3","3","1") 

ClassMethod GetBbdfxExecute(ByRef qHandle As %Binary, stdate As %String, endate As %String, type As %String) As %Status [ SqlProc ]
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
 	
	q:stdate="" $$$OK
	q:endate="" $$$OK
	q:type="" $$$OK
	k ^temp($j)
    
    s RowIdDept=""
    s incomefee="",costfee="",gzl="",gdcb1=0
    s gdcb1=0    
 
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
    
    f  s RowIdDept=$o(^DHCCAROLES(type,"RDepts",RowIdDept)) q:RowIdDept=""  d
    .q:RowIdDept=0
    .s deptdr=$P(^DHCCAROLES(type,"RDepts",RowIdDept),"^",2) q:deptdr=""
    .s ^temp($j,"dept",deptdr)=$g(^temp($j,"dept",deptdr))
     
    s locdr=0 f  s locdr=$o(^temp($j,"dept",locdr)) q:locdr=""  d
    .s i1="",i=""
    .f i1=stdatecode:1:endatecode d
    ..f  s i=$o(^DHCCAACCOUNTMONTHS(0,"Code",i1,i)) q:i=""  d
    ...s IncomeData(i)=$$Getincomedata^DHCCAFunction(i,locdr)
   	...s CostData(i)=$$GetCostResultSum^DHCCAFunction(i,locdr)
  	...s gdcbData(i)=$$GetCostResultGdcb^DHCCAFunction(i,locdr) //固定成本数据获取
    ...s mzrc(i)=$$GetMzrcData^DHCCAFunction(i,locdr)
  	...s zycr(i)=$$GetZycrData^DHCCAFunction(i,locdr)
  	
    ...s ^temp($j,"Income",locdr)=$g(^temp($j,"Income",locdr))+IncomeData(i)
    ...s ^temp($j,"Cost",locdr)=$g(^temp($j,"Cost",locdr))+CostData(i)
    ...s ^temp($j,"gdcb",locdr)=$g(^temp($j,"gdcb",locdr))+gdcbData(i)
    ...s ^temp($j,"gzl",locdr)=$g(^temp($j,"gzl",locdr))+mzrc(i)+zycr(i)
   
    s locdr1=0 f  s locdr1=$o(^temp($j,"Income",locdr1)) q:locdr1=""  d
    .i ($d(^DHCCAUNITDEPTS(locdr1)))  s deptname=$p(^DHCCAUNITDEPTS(locdr1),"^",2)
    .s outdata=$g(^temp($j,"Income",locdr1))_"^"_$g(^temp($j,"Cost",locdr1))_"^"_$g(^temp($j,"gdcb",locdr1))_"^"_$g(^temp($j,"gzl",locdr1))
    .s incomefee=$p(outdata,"^",1)
    .s costfee=$p(outdata,"^",2)
    .s amt=incomefee-costfee
    .s gdcb1=$p(outdata,"^",3)
    .s gzl=$p(outdata,"^",4)
    .s bdcb=costfee-gdcb1
    .i gzl'=0 s dwsr=incomefee/gzl,dwbdcb=bdcb/gzl
    .e  s dwsr=0,dwbdcb=0
    .s dwrc=dwsr-dwbdcb
    .i dwrc'=0 s bbgzl=gdcb1/dwrc
    .e  s bbgzl=0
    .;s bbsr=bbgzl*dwsr
    .s bbsr=costfee
    .;w !,locdr1_"^"_date_"^"_incomefee_"^"_costfee_"^"_gzl_"^"_gdcb1
   
    .d OutputRow18
     
     k ^temp($j)
  	q $$$OK
OutputRow18
	
  	s Data=$lb($g(monthname1),$g(monthname2),locdr1,$g(deptname),$g(gzl),$g(incomefee),$g(costfee),$g(amt),$g(gdcb1),$g(bdcb),$g(bbgzl),$g(bbsr))
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
}

ClassMethod GetBbdfxFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBbdfxExecute, SqlProc ]
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

ClassMethod GetBbdfxClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBbdfxExecute, SqlProc ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetBbdfx(stdate As %String, endate As %String, type As %String) As %Query(ROWSPEC = "monthname1:%String,monthname2:%String,locdr1:%Integer,deptName:%String,gzl:%Float,incomefee:%Float,costfee:%Float,amt:%Float,gdcb1:%Float,bgcb:%Float,bbgzl:%Float,bbsr:%Float") [ SqlProc ]
{
}

//d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","GetYjBbdfx","1","1","3") 

//医技科室保本点分析

ClassMethod GetYjBbdfxExecute(ByRef qHandle As %Binary, stdate As %String, endate As %String, type As %String) As %Status [ SqlProc ]
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
 	
	q:stdate="" $$$OK
	q:endate="" $$$OK
	q:type="" $$$OK
	k ^temp($j)
    
    s RowIdDept=""
    s incomefee="",costfee="",gzl="",gdcb1=0
    s gdcb1=0    
 
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
    
    f  s RowIdDept=$o(^DHCCAROLES(type,"RDepts",RowIdDept)) q:RowIdDept=""  d
    .q:RowIdDept=0
    .s deptdr=$P(^DHCCAROLES(type,"RDepts",RowIdDept),"^",2) q:deptdr=""
    .s ^temp($j,"dept",deptdr)=$g(^temp($j,"dept",deptdr))
     
    s locdr=0 f  s locdr=$o(^temp($j,"dept",locdr)) q:locdr=""  d
    .s i1="",i=""
    .f i1=stdatecode:1:endatecode d
    ..f  s i=$o(^DHCCAACCOUNTMONTHS(0,"Code",i1,i)) q:i=""  d
    ...s IncomeData(i)=$$GetTincomedata^DHCCAFunction(i,locdr)
   	...s CostData(i)=$$GetCostResultSum^DHCCAFunction(i,locdr)
  	...s gdcbData(i)=$$GetCostResultGdcb^DHCCAFunction(i,locdr)
    ...s yjrc(i)=$$GetMzrcData^DHCCAFunction(i,locdr)
  
  	
    ...s ^temp($j,"Income",locdr)=$g(^temp($j,"Income",locdr))+IncomeData(i)
    ...s ^temp($j,"Cost",locdr)=$g(^temp($j,"Cost",locdr))+CostData(i)
    ...s ^temp($j,"gdcb",locdr)=$g(^temp($j,"gdcb",locdr))+gdcbData(i)
    ...s ^temp($j,"gzl",locdr)=$g(^temp($j,"gzl",locdr))+yjrc(i)
   
    s locdr1=0 f  s locdr1=$o(^temp($j,"Income",locdr1)) q:locdr1=""  d
    .i ($d(^DHCCAUNITDEPTS(locdr1)))  s deptname=$p(^DHCCAUNITDEPTS(locdr1),"^",2)
    .s outdata=$g(^temp($j,"Income",locdr1))_"^"_$g(^temp($j,"Cost",locdr1))_"^"_$g(^temp($j,"gdcb",locdr1))_"^"_$g(^temp($j,"gzl",locdr1))
    .s incomefee=$p(outdata,"^",1)
    .s costfee=$p(outdata,"^",2)
    .s amt=incomefee-costfee
    .s gdcb1=$p(outdata,"^",3)
    .s gzl=$p(outdata,"^",4)
    .s bdcb=costfee-gdcb1
    .i gzl'=0 s dwsr=incomefee/gzl,dwbdcb=bdcb/gzl
    .e  s dwsr=0,dwbdcb=0
    .s dwrc=dwsr-dwbdcb
    .i dwrc'=0 s bbgzl=gdcb1/dwrc
    .e  s bbgzl=0
    .;s bbsr=bbgzl*dwsr
    .s bbsr=costfee
    .;w !,locdr1_"^"_date_"^"_incomefee_"^"_costfee_"^"_gzl_"^"_gdcb1
   
    .d OutputRow19
     
     k ^temp($j)
  	q $$$OK
OutputRow19
	
  	s Data=$lb($g(monthname1),$g(monthname2),$g(locdr1),$g(deptname),$fn($g(gzl),"",2),$fn($g(incomefee),"",2),$fn($g(costfee),"",2),$fn($g(amt),"",2),$fn($g(gdcb1),"",2),$fn($g(bdcb),"",2),$fn($g(bbgzl),"",2),$fn($g(bbsr),"",2))
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
}

ClassMethod GetYjBbdfxFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetYjBbdfxExecute, SqlProc ]
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

ClassMethod GetYjBbdfxClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetYjBbdfxExecute, SqlProc ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetYjBbdfx(stdate As %String, endate As %String, type As %String) As %Query(ROWSPEC = "monthname1:%String,monthname2:%String,locdr1:%Integer,deptName:%String,gzl:%Float,incomefee:%Float,costfee:%Float,amt:%Float,gdcb1:%Float,bgcb:%Float,bbgzl:%Float,bbsr:%Float") [ SqlProc ]
{
}

ClassMethod GetCostResultGdcbbak(stdate As %String, endate As %String, type As %String) [ SqlProc ]
{
	q:stdate=""
	q:endate=""
	q:type=""
	
	k ^temp($j)
	i $d(^DHCCAACCOUNTMONTHS(stdate)) s stmonth=$p(^DHCCAACCOUNTMONTHS(stdate),"^",2)
    s stdatecode=$p(^DHCCAACCOUNTMONTHS(stdate),"^",1)
    
    i $d(^DHCCAACCOUNTMONTHS(endate)) s enmonth=$p(^DHCCAACCOUNTMONTHS(endate),"^",2)
    s endatecode=$p(^DHCCAACCOUNTMONTHS(endate),"^",1)
	
	q:stdatecode>endatecode
 	
 	s RowId="",RowIdRole="" ,RowIditem="",RowIdData="",RowIdfee=""
 	s i2="",i=""
    f i2=stdatecode:1:endatecode d
    .f  s i=$o(^DHCCAACCOUNTMONTHS(0,"Code",i2,i)) q:i=""  d
 	..f  s RowId=$o(^DHCCACOSTDISTSETS(0,"DInterval","1",i,RowId)) q:RowId=""  d
    ...s dept=$p(^DHCCACOSTDISTSETS("1","CostResultData",RowId),"^",3)
    ...q:'$d(^DHCCAROLES(0,"RDDeptdr",type,dept))
    ...s item=$p(^DHCCACOSTDISTSETS(1,"CostResultData",RowId),"^",4)
    ...q:'$d(^DHCCADATALEVELSETS(0,"Item","40",item))
    ...s datafee=$p(^DHCCACOSTDISTSETS("1","CostResultData",RowId),"^",5)
    ...s ^temp($j,"gdcb",dept,i)=$g(^temp($j,"gdcb",dept,i))+datafee
    s locdr=0 f  s locdr=$o(^temp($j,"gdcb",locdr)) q:locdr=""  d
    .s date=0 f  s date=$o(^temp($j,"gdcb",locdr,date)) q:date=""  d
    ..s sumamt=$g(^temp($j,"gdcb",locdr,date))
    k ^temp($j)
	q sumamt
}

ClassMethod GetCostResultDataMExecute(ByRef qHandle As %Binary, stdate As %String, endate As %String, type As %String) As %Status [ SqlProc ]
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
	q:stdate="" $$$OK
	q:endate="" $$$OK
	q:type="" $$$OK
	
	k ^temp($j)
	q:stdate>endate
 	
 	s RowId="",RowIdRole="" ,RowIditem="",RowIdData="",RowIdfee=""
 	
 	f i=stdate:1:endate d
    .f  s RowId=$o(^DHCCACOSTDISTSETS(0,"DInterval","1",i,RowId)) q:RowId=""  d
    ..s dept=$p(^DHCCACOSTDISTSETS("1","CostResultData",RowId),"^",3)
    ..q:'$d(^DHCCAROLES(0,"RDDeptdr",type,dept))
    ..s item=$p(^DHCCACOSTDISTSETS(1,"CostResultData",RowId),"^",4)
    ..q:'$d(^DHCCADATALEVELSETS(0,"Item","40",item))
    ..s datafee=$p(^DHCCACOSTDISTSETS("1","CostResultData",RowId),"^",5)

    ..s ^temp($j,dept,i)=$g(^temp($j,dept,i))+datafee
    
    s locdr=0 f  s locdr=$o(^temp($j,locdr)) q:locdr=""  d
    .s date=0 f  s date=$o(^temp($j,locdr,date)) q:date=""  d
    ..s sumamt=$g(^temp($j,locdr,date))
    ..d OutputRow20 
 	;输出合计
 	;d OutputRowWorkSum15
 	k ^temp($j)
 	q $$$OK	
  	
OutputRow20
	;
  	s Data=$lb(locdr,date,$fn(sumamt,"",2))
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
OutputRowWorkSum20
    s Data=$lb("total",$g(totalFee))
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
}

ClassMethod GetCostResultDataMFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCostResultDataMExecute, SqlProc ]
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

ClassMethod GetCostResultDataMClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCostResultDataMExecute, SqlProc ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetCostResultDataM(stdate As %String, endate As %String, type As %String) As %Query(ROWSPEC = "locdr:%String,date:%Integer,sumamt:%Float") [ SqlProc ]
{
}

//成本分摊设置科室d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","GetFtszDept")

ClassMethod GetFtszDeptExecute(ByRef qHandle As %Binary) As %Status [ SqlProc ]
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
 		
    s RowId="",RowId1=""
    f  s RowId=$o(^DHCCADEPTLEVELSETS(RowId)) q:RowId=""  d
    .s parent=$p(^DHCCADEPTLEVELSETS(RowId),"^",7) q:parent'=1 //全成本分摊
    .s fcname=$p(^DHCCADEPTLEVELSETS(RowId),"^",2) 
    .f  s RowId1=$o(^DHCCADEPTLEVELSETS(RowId,"Depts",RowId1)) q:RowId1=""  d
    ..q:RowId1=0
    ..s deptDr=$p(^DHCCADEPTLEVELSETS(RowId,"Depts",RowId1),"^",1) q:deptDr=""
    ..s deptname=$P(^DHCCAUNITDEPTS(deptDr),"^",2)
    ..d OutputRow21
 	 
  	q $$$OK
OutputRow21
	
  	s Data=$lb(RowId,fcname,deptDr,deptname)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
}

ClassMethod GetFtszDeptFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetFtszDeptExecute, SqlProc ]
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

ClassMethod GetFtszDeptClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetFtszDeptExecute, SqlProc ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetFtszDept() As %Query(ROWSPEC = "RowId:%Integer,fcname:%String,deptDr:%Integer,deptname:%String") [ SqlProc ]
{
}

/*//选择统计项目d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","GetItem")

ClassMethod GetItemExecute(ByRef qHandle As %Binary) As %Status [ SqlProc ]
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
     
    s RowId=1,RowId1=""
    
    f  s RowId=$o(^DHCCADATALEVELSETS(RowId))  q:RowId=""  d
    .s parent=$p(^DHCCADATALEVELSETS(RowId),"^",7) q:parent'=34  //新会计制度
    .s fldesc=$p(^DHCCADATALEVELSETS(RowId),"^",2)
    .f  s RowId1=$o(^DHCCADATALEVELSETS(RowId,"Items",RowId1))  q:RowId1=""  d
    ..s item=$p(^DHCCADATALEVELSETS(RowId,"Items",RowId1),"^",3) 
    ..q:item=""
    ..s ItemDesc=$P(^DHCCAALLDATAITEMS(item),"^",3)
    ..d OutputRow22
  
   	q $$$OK

OutputRow22
	
  	s Data=$lb(RowId,fldesc,item,ItemDesc)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
}

ClassMethod GetItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetItemExecute, SqlProc ]
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

ClassMethod GetItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetItemExecute, SqlProc ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetItem() As %Query(ROWSPEC = "RowId:%Integer,fldesc:%String,item:%Integer,ItemDesc:%String") [ SqlProc ]
{
}
*/

//选择统计项目d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","GetItem")

ClassMethod GetItemExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
     
    s RowId=1,RowId1=""
    
    f  s RowId=$o(^DHCCADATALEVELSETS(RowId))  q:RowId=""  d
    .s parent=$p(^DHCCADATALEVELSETS(RowId),"^",7) q:parent'=25  //新会计制度
    
    .s fldesc=$p(^DHCCADATALEVELSETS(RowId),"^",2)
    .f  s RowId1=$o(^DHCCADATALEVELSETS(RowId,"Items",RowId1))  q:RowId1=""  d
    ..s item=$p(^DHCCADATALEVELSETS(RowId,"Items",RowId1),"^",3) 
    ..q:item=""
    ..s ItemDesc=$P(^DHCCAALLDATAITEMS(item),"^",3)
    ..d OutputRow17
  
   	q $$$OK

OutputRow17
	
  	s Data=$lb(RowId,fldesc,item,ItemDesc)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
}

ClassMethod GetItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetItemExecute ]
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

ClassMethod GetItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetItem() As %Query(ROWSPEC = "RowId:%Integer,fldesc:%String,item:%Integer,ItemDesc:%String") [ SqlProc ]
{
}

//科室直接间接成本查询d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","GetZjJjCost","1","1","2,3")

ClassMethod GetZjJjCostExecute(ByRef qHandle As %Binary, stdate As %String, endate As %String, dept As %Text) As %Status [ SqlProc ]
{
                            
	Set repid=$I(^CacheTemp) 
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
 	
	q:stdate="" $$$OK
	q:endate="" $$$OK
	q:dept="" $$$OK
	s RowId="",RowId1="",RowId2="",dep=""
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
    s i1="",i=""
    f i1=stdatecode:1:endatecode d
    .f  s i=$o(^DHCCAACCOUNTMONTHS(0,"Code",i1,i)) q:i=""  d
    ..f  s RowId=$o(^DHCCACOSTDISTSETS(0,"DInterval",1,i,RowId)) q:RowId=""  d
    ...s distdept=$p($g(^DHCCACOSTDISTSETS(1,"CostResultData",RowId)),"^",3)
    ...q:$F(","_dept_",",","_distdept_",")=0
    ...s data=$p(^DHCCACOSTDISTSETS(1,"CostResultData",RowId),"^",4)
    ...s distflag=$p(^DHCCACOSTDISTSETS("1","CostResultData",RowId),"^",6)  q:distflag'="self"
    ...s datafee=$p(^DHCCACOSTDISTSETS("1","CostResultData",RowId),"^",5)
    ...s depted=$p(^DHCCACOSTDISTSETS("1","CostResultData",RowId),"^",2)  
    ...f  s RowId1=$o(^DHCCADATALEVELSETS(RowId1))  q:RowId1=""  d
    ....s parent=$p(^DHCCADATALEVELSETS(RowId1),"^",7) q:parent'=25   //新会计制度
    ....q:'$d(^DHCCADATALEVELSETS(0,"Item",RowId1,data))
    ....i depted="" s ^temp($j,"depted",distdept,distflag,RowId1,data)=$g(^temp($j,"depted",distdept,distflag,RowId1,data))+datafee
       
    s costdept=0 f  s costdept=$o(^temp($j,"depted",costdept)) q:costdept=""  d
    .s costflag=0 f  s costflag=$o(^temp($j,"depted",costdept,costflag)) q:costflag=""  d
    ..s costdatafc=0 f  s costdatafc=$o(^temp($j,"depted",costdept,costflag,costdatafc)) q:costdatafc=""  d
    ...s costitem=0 f  s costitem=$o(^temp($j,"depted",costdept,costflag,costdatafc,costitem)) q:costitem=""  d
    ....s costsum=$g(^temp($j,"depted",costdept,costflag,costdatafc,costitem))
    ....s costfenc=""
    ....s costfencw=""
    ....;w !,costdept_"^"_costdatafc_"^"_costitem_"^"_costflag_"^"_costsum
    ....d OutputRow23 
    
    s RowIdB="",RowIdB1="",RowIdB2="",ward="",RowIdBD=""
    s i1="",i=""
    f i1=stdatecode:1:endatecode d
    .f  s i=$o(^DHCCAACCOUNTMONTHS(0,"Code",i1,i)) q:i=""  d
    ..f  s RowIdB=$o(^DHCCACOSTDISTSETS(0,"DInterval",1,i,RowIdB)) q:RowIdB=""  d
    ...s distdept=$p($g(^DHCCACOSTDISTSETS(1,"CostResultData",RowIdB)),"^",3) 
    ...q:$F(","_dept_",",","_distdept_",")=0
    ...s data=$p(^DHCCACOSTDISTSETS(1,"CostResultData",RowIdB),"^",4)
    ...s distflag=$p(^DHCCACOSTDISTSETS("1","CostResultData",RowIdB),"^",6)
    ...s datafee=$p(^DHCCACOSTDISTSETS("1","CostResultData",RowIdB),"^",5)
    ...s depted=$p(^DHCCACOSTDISTSETS("1","CostResultData",RowIdB),"^",2) q:depted=""
    
    ...f  s RowIdB2=$o(^DHCCADATALEVELSETS(RowIdB2))  q:RowIdB2=""  d
    ....s parent=$p(^DHCCADATALEVELSETS(RowIdB2),"^",7) q:parent'=25   //新会计制度
    ....q:'$d(^DHCCADATALEVELSETS(0,"Item",RowIdB2,data))
    ....f  s RowIdB1=$o(^DHCCADEPTLEVELSETS(0,"Parent",1,RowIdB1))  q:RowIdB1=""  d
    .....f  s dep=$o(^DHCCADEPTLEVELSETS(0,"Dept",RowIdB1,depted,dep))  q:dep=""  d
    ......s ^temp($j,"depted",distdept,distflag,RowIdB2,data,RowIdB1)=$g(^temp($j,"depted",distdept,distflag,RowIdB2,data,RowIdB1))+datafee
             
    s costdept=0 f  s costdept=$o(^temp($j,"depted",costdept)) q:costdept=""  d
    .s costflag=0 f  s costflag=$o(^temp($j,"depted",costdept,costflag)) q:costflag=""  d
    ..s costdatafc=0 f  s costdatafc=$o(^temp($j,"depted",costdept,costflag,costdatafc)) q:costdatafc=""  d
    ...s costitem=0 f  s costitem=$o(^temp($j,"depted",costdept,costflag,costdatafc,costitem)) q:costitem=""  d
    ....s costfenc=0 f  s costfenc=$o(^temp($j,"depted",costdept,costflag,costdatafc,costitem,costfenc))  q:costfenc=""  d
    .....s costsum=$g(^temp($j,"depted",costdept,costflag,costdatafc,costitem,costfenc))
    .....s costfencw=""
    .....;w !,costdept_"^"_costitem_"^"_costflag_"^"_costfenc_"^"_costsum
    .....d OutputRow23 
    
    k ^temp($j)      
   q $$$OK
	
OutputRow23
    s datafcname=$p(^DHCCADATALEVELSETS(costdatafc),"^",2)  
    i $d(^DHCCAALLDATAITEMS(costitem)) s ItemDesc=$P(^DHCCAALLDATAITEMS(costitem),"^",3)
    s deptname=$P(^DHCCAUNITDEPTS(costdept),"^",2)
    
    i costfenc="" s costfencname="直接成本"  //参照全成本分摊科室层次设置
	i costfenc=2 s costfencname="公用分摊"
	i costfenc=3 s costfencname="管理分摊"
	i costfenc=4 s costfencname="医辅分摊"
	i costfenc=5 s costfencname="医技分摊"
	
	s Data=$lb(monthname1,monthname2,costdatafc,datafcname,costitem,ItemDesc,costdept,deptname,costflag,costfenc,costfencname,$g(costsum))
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetZjJjCostFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetZjJjCostExecute, SqlProc ]
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

ClassMethod GetZjJjCostClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetZjJjCostExecute, SqlProc ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetZjJjCost(stdate As %String, endate As %String, dept As %Text) As %Query(ROWSPEC = "monthname1:%String,monthname2:%String,costdatafc:%Integer,datafcname:%String,costitem:%Integer,ItemDesc:%String,costdept:%Integer,deptname:%String,costflag:%String,costfenc:%String,costfencname:%String,costsum:%Float") [ SqlProc ]
{
}

//科室直接间接成本查询

//d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","GetZjJjDeptCost","1","1","3")

ClassMethod GetZjJjDeptCostExecute(ByRef qHandle As %Binary, stdate As %Integer, endate As %Integer, dept As %String) As %Status [ SqlProc ]
{
                            
	Set repid=$I(^CacheTemp) 
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
 	
	q:stdate="" $$$OK
	q:endate="" $$$OK
	q:dept="" $$$OK
	
	
	s RowId="",RowId1="",RowId2="",dep=""
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
    
    s i1="",i=""
    f i1=stdatecode:1:endatecode d
    .f  s i=$o(^DHCCAACCOUNTMONTHS(0,"Code",i1,i)) q:i=""  d
    ..f  s RowId=$o(^DHCCACOSTDISTSETS(0,"DIntDistdept",1,i,dept,RowId)) q:RowId=""  d
    ...;s distdept=$p(^DHCCACOSTDISTSETS(1,"CostResultData",RowId),"^",3)
    ...s distdept=dept
    ...s data=$p(^DHCCACOSTDISTSETS(1,"CostResultData",RowId),"^",4)
    ...s distflag=$p(^DHCCACOSTDISTSETS("1","CostResultData",RowId),"^",6) q:distflag'="self"
    ...s datafee=$p(^DHCCACOSTDISTSETS("1","CostResultData",RowId),"^",5)
    ...s depted=$p(^DHCCACOSTDISTSETS("1","CostResultData",RowId),"^",2)  
    ...f  s RowId1=$o(^DHCCADATALEVELSETS(RowId1))  q:RowId1=""  d
    ....s parent=$p(^DHCCADATALEVELSETS(RowId1),"^",7) q:parent'=25  //新会计制度
    ....q:'$d(^DHCCADATALEVELSETS(0,"Item",RowId1,data))
    ....i depted="" s ^temp($j,"depted",distdept,distflag,RowId1,data)=$g(^temp($j,"depted",distdept,distflag,RowId1,data))+datafee
       
    s costdept=0 f  s costdept=$o(^temp($j,"depted",costdept)) q:costdept=""  d
    .s costflag=0 f  s costflag=$o(^temp($j,"depted",costdept,costflag)) q:costflag=""  d
    ..s costdatafc=0 f  s costdatafc=$o(^temp($j,"depted",costdept,costflag,costdatafc)) q:costdatafc=""  d
    ...s costitem=0 f  s costitem=$o(^temp($j,"depted",costdept,costflag,costdatafc,costitem)) q:costitem=""  d
    ....s costsum=$g(^temp($j,"depted",costdept,costflag,costdatafc,costitem))
    ....s costfenc=""
    ....s costfencw=""
    ....;w !,costdept_"^"_costdatafc_"^"_costitem_"^"_costflag_"^"_costsum
    ....d OutputRow24
    
    s RowIdB="",RowIdB1="",RowIdB2="",ward="",RowIdBD=""
    s i1="",i=""
    f i1=stdatecode:1:endatecode d
    .f  s i=$o(^DHCCAACCOUNTMONTHS(0,"Code",i1,i)) q:i=""  d
    ..f  s RowIdB=$o(^DHCCACOSTDISTSETS(0,"DIntDistdept",1,i,dept,RowIdB)) q:RowIdB=""  d
    ...;s distdept=$p(^DHCCACOSTDISTSETS(1,"CostResultData",RowIdB),"^",3) 
    ...s distdept=dept
    ...s data=$p(^DHCCACOSTDISTSETS(1,"CostResultData",RowIdB),"^",4)
    ...s distflag=$p(^DHCCACOSTDISTSETS("1","CostResultData",RowIdB),"^",6)
    ...s datafee=$p(^DHCCACOSTDISTSETS("1","CostResultData",RowIdB),"^",5)
    ...s depted=$p(^DHCCACOSTDISTSETS("1","CostResultData",RowIdB),"^",2) q:depted=""
    
    ...f  s RowIdB2=$o(^DHCCADATALEVELSETS(RowIdB2))  q:RowIdB2=""  d
    ....s parent=$p(^DHCCADATALEVELSETS(RowIdB2),"^",7) q:parent'=25  //新会计制度
    ....q:'$d(^DHCCADATALEVELSETS(0,"Item",RowIdB2,data))
    ....f  s RowIdB1=$o(^DHCCADEPTLEVELSETS(0,"Parent",1,RowIdB1))  q:RowIdB1=""  d
    .....f  s dep=$o(^DHCCADEPTLEVELSETS(0,"Dept",RowIdB1,depted,dep))  q:dep=""  d
    ......s ^temp($j,"depted",distdept,distflag,RowIdB2,data,RowIdB1)=$g(^temp($j,"depted",distdept,distflag,RowIdB2,data,RowIdB1))+datafee
             
    s costdept=0 f  s costdept=$o(^temp($j,"depted",costdept)) q:costdept=""  d
    .s costflag=0 f  s costflag=$o(^temp($j,"depted",costdept,costflag)) q:costflag=""  d
    ..s costdatafc=0 f  s costdatafc=$o(^temp($j,"depted",costdept,costflag,costdatafc)) q:costdatafc=""  d
    ...s costitem=0 f  s costitem=$o(^temp($j,"depted",costdept,costflag,costdatafc,costitem)) q:costitem=""  d
    ....s costfenc=0 f  s costfenc=$o(^temp($j,"depted",costdept,costflag,costdatafc,costitem,costfenc))  q:costfenc=""  d
    .....s costsum=$g(^temp($j,"depted",costdept,costflag,costdatafc,costitem,costfenc))
    .....s costfencw=""
    .....;w !,costdept_"^"_costitem_"^"_costflag_"^"_costfenc_"^"_costsum
    .....d OutputRow24 
    
    k ^temp($j)      
   q $$$OK
	
OutputRow24
    s datafcname=$p(^DHCCADATALEVELSETS(costdatafc),"^",2)  
    i $d(^DHCCAALLDATAITEMS(costitem)) s ItemDesc=$P(^DHCCAALLDATAITEMS(costitem),"^",3)
    s deptname=$P(^DHCCAUNITDEPTS(costdept),"^",2)
    
    i costfenc="" s costfencname="直接成本"
	i costfenc=2 s costfencname="公用分摊"
	i costfenc=3 s costfencname="管理分摊"
	i costfenc=4 s costfencname="医辅分摊"
	i costfenc=5 s costfencname="医技分摊"
	
	s Data=$lb(monthname1,monthname2,costdatafc,datafcname,costitem,ItemDesc,costdept,deptname,costflag,costfenc,costfencname,$g(costsum))
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetZjJjDeptCostFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetZjJjDeptCostExecute, SqlProc ]
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

ClassMethod GetZjJjDeptCostClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetZjJjDeptCostExecute, SqlProc ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetZjJjDeptCost(stdate As %Integer, endate As %Integer, dept As %Integer) As %Query(ROWSPEC = "monthname1:%String,monthname2:%String,costdatafc:%Integer,datafcname:%String,costitem:%Integer,ItemDesc:%String,costdept:%Integer,deptname:%String,costflag:%String,costfenc:%String,costfencname:%String,costsum:%Float") [ SqlProc ]
{
}

//全院汇总

//d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","GetFtJyfxZ","1","1","demo")

ClassMethod GetFtJyfxZExecute(ByRef qHandle As %Binary, stdate As %String, endate As %String, user As %String) As %Status [ SqlProc ]
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
 	
	q:stdate="" $$$OK
	q:endate="" $$$OK
	q:user="" $$$OK
	k ^temp($j)
    
    s RowId="",RowId2="",RowIdRole="",RowIdPara="",RowIdParaM="",RowIdParaZ=""
    s RowIdIncome="",RowIdCost="",RowIdDept="",InComeDatafee="",sumfee="",id=""
    s RowIdY="",RowIdYC="",RowIdClc="",RowIdCl="",date1=""
        
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
    f  s RowId=$o(^DHCCAUSERS(0,"Loginname",user,RowId)) q:RowId=""  d
    .f  s RowIdRole=$o(^DHCCAUSERS(RowId,"URoles",RowIdRole))  q:RowIdRole=""  d
    ..q:RowIdRole=0
    ..s roledr=$p(^DHCCAUSERS(RowId,"URoles",RowIdRole),"^",2) 
       
    ..f  s RowIdDept=$o(^DHCCAROLES(roledr,"RDepts",RowIdDept)) q:RowIdDept=""  d
    ...q:RowIdDept=0
    ...s deptdr=$P(^DHCCAROLES(roledr,"RDepts",RowIdDept),"^",2) q:deptdr=""
    ...s ^temp($j,"dept",deptdr)=$g(^temp($j,"dept",deptdr))
    
    ...i ($d(^DHCCAUNITDEPTS(deptdr)))  s deptname=$p(^DHCCAUNITDEPTS(deptdr),"^",2)
    ...s ^temp($j,roledr,deptdr)=$g(^temp($j,roledr,deptdr))
    ...f datecode=stdatecode:1:endatecode d   
    ....f  s date1=$o(^DHCCAACCOUNTMONTHS(0,"Code",datecode,date1))  q:date1=""  d
    .....s ^temp($j,"roledr",deptdr,date1)=roledr
     
    s locdr=0 f  s locdr=$o(^temp($j,"dept",locdr)) q:locdr=""  d
    .s i1="",i=""
    .f i1=stdatecode:1:endatecode d
    ..f  s i=$o(^DHCCAACCOUNTMONTHS(0,"Code",i1,i)) q:i=""  d
   	...s IncomeData(i)=$$Getincomedata^DHCCAFunction(i,locdr)
  	...s CostData(i)=$$GetCostResultSum^DHCCAFunction(i,locdr)
    ...s ^temp($j,"Income",locdr,i)=$g(^temp($j,"Income",locdr,i))+IncomeData(i)
    ...s ^temp($j,"Cost",locdr,i)=$g(^temp($j,"Cost",locdr,i))+CostData(i)
    
    ...f  s RowIdY=$o(^DHCCAINCOMEDATAS(0,"IntervalPatdeptdr",i,locdr,RowIdY)) q:RowIdY=""  d     //20110704lxc按病人科室
    ....s itemDr=$p(^DHCCAINCOMEDATAS(RowIdY),"^",6) q:itemDr=""
    ....q:'$d(^DHCCADATALEVELSETS(0,"Item","3",itemDr))
    ....s yaofeei=$p(^DHCCAINCOMEDATAS(RowIdY),"^",7) 
    ....s ^temp($j,"yaopi",locdr,i)=$g(^temp($j,"yaopi",locdr,i))+yaofeei   //药品收入
      
    ...f  s RowIdYC=$o(^DHCCACOSTDISTSETS(0,"DIntDistdept",1,i,locdr,RowIdYC)) q:RowIdYC=""  d
    ....s itemDrc=$p(^DHCCACOSTDISTSETS(1,"CostResultData",RowIdYC),"^",4)
    ....q:'$d(^DHCCADATALEVELSETS(0,"Item","2",itemDrc))
    ....s yaofeec=$p(^DHCCACOSTDISTSETS(1,"CostResultData",RowIdYC),"^",5) 
    ....s ^temp($j,"yaopc",locdr,i)=$g(^temp($j,"yaopc",locdr,i))+yaofeec   //药品成本
    
    /*
    ...f  s RowIdCl=$o(^DHCCAINCOMEDATAS(0,"IntervalFdeptdr",i,locdr,RowIdCl)) q:RowIdCl=""  d
    ....s itemDr=$p(^DHCCAINCOMEDATAS(RowIdCl),"^",6) q:itemDr=""
    ....q:'$d(^DHCCADATALEVELSETS(0,"Item","7",itemDr))
    ....s clfeei=$p(^DHCCAINCOMEDATAS(RowIdCl),"^",7) 
    ....s ^temp($j,"clpi",locdr,i)=$g(^temp($j,"clpi",locdr,i))+clfeei   //材料收入
      
    ...f  s RowIdClc=$o(^DHCCACOSTDISTSETS(0,"DIntDistdept",1,i,locdr,RowIdClc)) q:RowIdClc=""  d
    ....s itemDrc=$p(^DHCCACOSTDISTSETS(1,"CostResultData",RowIdClc),"^",4)
    ....q:'$d(^DHCCADATALEVELSETS(0,"Item","8",itemDrc))
    ....s clfeec=$p(^DHCCACOSTDISTSETS(1,"CostResultData",RowIdClc),"^",5) 
    ....s ^temp($j,"clpc",locdr,i)=$g(^temp($j,"clpc",locdr,i))+clfeec   //材料成本
    */      
    s locdr1=0 f  s locdr1=$o(^temp($j,"Income",locdr1)) q:locdr1=""  d
    .i ($d(^DHCCAUNITDEPTS(locdr1)))  s deptname=$p(^DHCCAUNITDEPTS(locdr1),"^",2)
    .s date=0 f  s date=$o(^temp($j,"Income",locdr1,date)) q:date=""  d  
    ..s incomefee=$g(^temp($j,"Income",locdr1,date))
    ..s costfee=$g(^temp($j,"Cost",locdr1,date))
    ..s amt=incomefee-costfee
    ..s role=$g(^temp($j,"roledr",locdr1,date))
    ..i $d(^DHCCAROLES(role)) s rolesname=$p(^DHCCAROLES(role),"^",3)
    ..s yaoincome=$g(^temp($j,"yaopi",locdr1,date)) 
    ..s yaocost=$g(^temp($j,"yaopc",locdr1,date)) 
    ..;s clincome=$g(^temp($j,"clpi",locdr1,date)) 
    ..;s clcost=$g(^temp($j,"clpc",locdr1,date)) 
    ..s ylincome=incomefee-yaoincome  //-clincome
    ..s ylcost=costfee-yaocost   //-clcost
    ..s ylamt=ylincome-ylcost
    ..s yaoamt=yaoincome-yaocost
    ..;s clamt=clincome-clcost
    ..;w !,role_"^"_locdr1_"^"_date_"^"_incomefee_"^"_costfee
    ..d OutputRow25
    k ^temp($j)
  	q $$$OK
OutputRow25
	;
  	;s Data=$lb($g(monthname1),$g(monthname2),$g(role),$g(rolesname),locdr1,$g(deptname),$fn($g(incomefee),"",2),$fn($g(costfee),"",2),$fn($g(amt),"",2),$fn($g(ylincome),"",2),$fn($g(yaoincome),"",2),$fn($g(ylcost),"",2),$fn($g(yaocost),"",2),$fn($g(ylamt),"",2),$fn($g(yaoamt),"",2),$fn($g(clincome),"",2),$fn($g(clcost),"",2),$fn($g(clamt),"",2))
  	s Data=$lb($g(monthname1),$g(monthname2),$g(role),$g(rolesname),locdr1,$g(deptname),$g(incomefee),$g(costfee),$g(amt),$g(ylincome),$g(yaoincome),$g(ylcost),$g(yaocost),$g(ylamt),$g(yaoamt))
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
}

ClassMethod GetFtJyfxZFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetFtJyfxZExecute, SqlProc ]
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

ClassMethod GetFtJyfxZClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetFtJyfxZExecute, SqlProc ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

//,clincome:%Float,clcost:%Float,clamt:%Float")

Query GetFtJyfxZ(stdate As %String, endate As %String, user As %String) As %Query(ROWSPEC = "monthname1:%String,monthname2:%String,role:%String,rolesname:%String,locdr1:%Integer,deptName:%String,incomefee:%Float,costfee:%Float,amt:%Float,ylincome:%Float,yaoincome:%Float,ylcost:%Float,yaocost:%Float,ylamt:%Float,yaoamt:%Float") [ SqlProc ]
{
}

//预算执行分析

//d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","YszxFx","10","13")

ClassMethod YszxFxExecute(ByRef qHandle As %Binary, stdate As %String, endate As %String) As %Status [ SqlProc ]
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
 	
	q:stdate="" $$$OK
	q:endate="" $$$OK
	
	k ^temp($j)
    
    s RowIdY="",RowIdCl="",RowIdM="",RowIdLM="",RowIdPClc="",RowIdGClc="",RowIdYpClc=""
    s RowIdZjClc="",RowIdNhYC="",RowIdOffClc="",RowIdTelYC="",RowIdOthYC=""
        
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
   
    s i1="",i=""
    f i1=stdatecode:1:endatecode d
    .f  s i=$o(^DHCCAACCOUNTMONTHS(0,"Code",i1,i)) q:i=""  d
   	..s IncomeData(i)=$$GetQyincomedata^DHCCAFunction(i)
  	..s CostData(i)=$$GetQyCostResultSum^DHCCAFunction(i)
    ..s ^temp($j,"Income")=$g(^temp($j,"Income"))+IncomeData(i)
    ..s ^temp($j,"Cost")=$g(^temp($j,"Cost"))+CostData(i)
   
    ..f  s RowIdY=$o(^DHCCAINCOMEDATAS(0,"Interval",i,RowIdY)) q:RowIdY=""  d
    ...s itemDr=$p(^DHCCAINCOMEDATAS(RowIdY),"^",6) q:itemDr=""
    ...q:'$d(^DHCCADATALEVELSETS(0,"Item","6",itemDr))
    ...s yaofeei=$p(^DHCCAINCOMEDATAS(RowIdY),"^",7) 
    ...s ^temp($j,"yaopi")=$g(^temp($j,"yaopi"))+yaofeei   //药品收入
    
    ..f  s RowIdCl=$o(^DHCCAINCOMEDATAS(0,"Interval",i,RowIdCl)) q:RowIdCl=""  d
    ...s itemDr=$p(^DHCCAINCOMEDATAS(RowIdCl),"^",6) q:itemDr=""
    ...q:'$d(^DHCCADATALEVELSETS(0,"Item","10",itemDr))
    ...s clfeei=$p(^DHCCAINCOMEDATAS(RowIdCl),"^",7) 
    ...s ^temp($j,"clpi")=$g(^temp($j,"clpi"))+clfeei   //材料收入
    
    ..f  s RowIdM=$o(^DHCCACOSTDISTSETS(0,"DInterval",1,i,RowIdM)) q:RowIdM=""  d
    ...s itemDrc=$p(^DHCCACOSTDISTSETS(1,"CostResultData",RowIdM),"^",4)
    ...q:'$d(^DHCCADATALEVELSETS(0,"Item","13",itemDrc))
    ...s manc=$p(^DHCCACOSTDISTSETS(1,"CostResultData",RowIdM),"^",5) 
    ...s ^temp($j,"manc")=$g(^temp($j,"manc"))+manc   //人力成本
    
    ..f  s RowIdLM=$o(^DHCCACOSTDISTSETS(0,"DInterval",1,i,RowIdLM)) q:RowIdLM=""  d
    ...s itemDrc=$p(^DHCCACOSTDISTSETS(1,"CostResultData",RowIdLM),"^",4)
    ...q:'$d(^DHCCADATALEVELSETS(0,"Item","15",itemDrc))
    ...s ltmanc=$p(^DHCCACOSTDISTSETS(1,"CostResultData",RowIdLM),"^",5) 
    ...s ^temp($j,"ltmanc")=$g(^temp($j,"ltmanc"))+ltmanc   //离退休人员成本
    
    ..f  s RowIdPClc=$o(^DHCCACOSTDISTSETS(0,"DInterval",1,i,RowIdPClc)) q:RowIdPClc=""  d
    ...s itemDrc=$p(^DHCCACOSTDISTSETS(1,"CostResultData",RowIdPClc),"^",4)
    ...q:'$d(^DHCCADATALEVELSETS(0,"Item","14",itemDrc))
    ...s clpc=$p(^DHCCACOSTDISTSETS(1,"CostResultData",RowIdPClc),"^",5) 
    ...s ^temp($j,"clpc")=$g(^temp($j,"clpc"))+clpc   //普通材料成本
  
    ..f  s RowIdYpClc=$o(^DHCCACOSTDISTSETS(0,"DInterval",1,i,RowIdYpClc)) q:RowIdYpClc=""  d
    ...s itemDrc=$p(^DHCCACOSTDISTSETS(1,"CostResultData",RowIdYpClc),"^",4)
    ...q:'$d(^DHCCADATALEVELSETS(0,"Item","11",itemDrc))
    ...s yaopc=$p(^DHCCACOSTDISTSETS(1,"CostResultData",RowIdYpClc),"^",5) 
    ...s ^temp($j,"yaopc")=$g(^temp($j,"yaopc"))+yaopc   //药品成本
    
    ..f  s RowIdZjClc=$o(^DHCCACOSTDISTSETS(0,"DInterval",1,i,RowIdZjClc)) q:RowIdZjClc=""  d
    ...s itemDrc=$p(^DHCCACOSTDISTSETS(1,"CostResultData",RowIdZjClc),"^",4)
    ...q:'$d(^DHCCADATALEVELSETS(0,"Item","12",itemDrc))
    ...s zjpc=$p(^DHCCACOSTDISTSETS(1,"CostResultData",RowIdZjClc),"^",5) 
    ...s ^temp($j,"zjpc")=$g(^temp($j,"zjpc"))+zjpc   //折旧成本
        
    ..f  s RowIdNhYC=$o(^DHCCACOSTDISTSETS(0,"DInterval",1,i,RowIdNhYC)) q:RowIdNhYC=""  d
    ...s itemDrc=$p(^DHCCACOSTDISTSETS(1,"CostResultData",RowIdNhYC),"^",4)
    ...q:'$d(^DHCCADATALEVELSETS(0,"Item","16",itemDrc))
    ...s nhc=$p(^DHCCACOSTDISTSETS(1,"CostResultData",RowIdNhYC),"^",5) 
    ...s ^temp($j,"nhc")=$g(^temp($j,"nhc"))+nhc   //能耗成本
   
    ..f  s RowIdOthYC=$o(^DHCCACOSTDISTSETS(0,"DInterval",1,i,RowIdOthYC)) q:RowIdOthYC=""  d
    ...s itemDrc=$p(^DHCCACOSTDISTSETS(1,"CostResultData",RowIdOthYC),"^",4)
    ...q:'$d(^DHCCADATALEVELSETS(0,"Item","17",itemDrc))
    ...s othc=$p(^DHCCACOSTDISTSETS(1,"CostResultData",RowIdOthYC),"^",5) 
    ...s ^temp($j,"othc")=$g(^temp($j,"othc"))+othc   //其他成本 
         
   
    s incomefee=$g(^temp($j,"Income"))  //总收入
    s costfee=$g(^temp($j,"Cost"))     //总成本
    s amt=incomefee-costfee                       //总利润   

    s yaoincome=$g(^temp($j,"yaopi")) //药品收入
    s clincome=$g(^temp($j,"clpi"))  //材料收入
    s ylincome=incomefee-yaoincome-clincome     //医疗收入
    
    s mancc=$g(^temp($j,"manc"))   //人力成本
    s ltmancc=$g(^temp($j,"ltmanc"))  //离退休人员成本
    s clpcc=$g(^temp($j,"clpc"))   //普通材料成本
    ;s gzclpcc=$g(^temp($j,"gzclpc"))   //高值材料成本
    s yaopcc=$g(^temp($j,"yaopc"))  //药品成本
    s zjpcc=$g(^temp($j,"zjpc"))   //折旧成本
    s nhcc=$g(^temp($j,"nhc"))   //能耗成本
    ;s offcc=$g(^temp($j,"offc"))   //办公成本
    ;s telcc=$g(^temp($j,"telc"))   //通讯成本 
    s othcc=$g(^temp($j,"othc"))   //其他成本 

    d OutputRow26
    k ^temp($j)
  	q $$$OK
OutputRow26
   ; 
    s Data=$lb($g(monthname1),$g(monthname2),$fn($g(incomefee),"",2),$fn($g(costfee),"",2),$fn($g(amt),"",2),$fn($g(ylincome),"",2),$fn($g(yaoincome),"",2),$fn($g(clincome),"",2),$fn($g(mancc),"",2),$fn($g(ltmancc),"",2),$fn($g(clpcc),"",2),$fn($g(gzclpcc),"",2),$fn($g(yaopcc),"",2),$fn($g(zjpcc),"",2),$fn($g(nhcc),"",2),$fn($g(offcc),"",2),$fn($g(telcc),"",2),$fn($g(othcc),"",2))
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
}

ClassMethod YszxFxFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = YszxFxExecute, SqlProc ]
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

ClassMethod YszxFxClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = YszxFxExecute, SqlProc ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query YszxFx(stdate As %String, endate As %String) As %Query(ROWSPEC = "monthname1:%String,monthname2:%String,incomefee:%Float,costfee:%Float,amt:%Float,ylincome:%Float,yaoincome:%Float,clincome:%Float,mancc:%Float,ltmancc:%Float,clpcc:%Float,gzclpcc:%Float,yaopcc:%Float,zjpcc:%Float,nhcc:%Float,offcc:%Float,telcc:%Float,othcc:%Float") [ SqlProc ]
{
}

//收支结余分析

//d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","SZBjfx")

ClassMethod SZBjfxExecute(ByRef qHandle As %Binary) As %Status [ SqlProc ]
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
 	

	k ^temp($j)
    s RowId1="",RowIdCost="",RowId="" 
    s RowIdY="",RowIdCl="",RowIdM="",RowIdLM="",RowIdPClc="",RowIdGClc="",RowIdYpClc=""
    s RowIdZjClc="",RowIdNhYC="",RowIdOffClc="",RowIdTelYC="",RowIdOthYC=""
   
   
     f  s RowId=$o(^DHCCAACCOUNTMONTHS(RowId))  q:RowId=""  d
    .s desc=$p(^DHCCAACCOUNTMONTHS(RowId),"^",2)
    .s year=$p(desc,"-",1)
    .;s IncomeData(RowId)=$$GetQyincomedata^DHCCAFunction(RowId)
    
    .f  s RowId1=$o(^DHCCAINCOMEDATAS(0,"Interval",RowId,RowId1)) q:RowId1=""  d
    ..s IncomeData=$p(^DHCCAINCOMEDATAS(RowId1),"^",7)
    ..s ^temp($j,year,"Income")=$g(^temp($j,year,"Income"))+IncomeData   
    
    .f  s RowIdCost=$o(^DHCCACOSTDISTSETS(1,"IntIDFlag",RowId,1,"branch",RowIdCost)) q:RowIdCost=""   d
    ..s CostData=$p(^DHCCACOSTDISTSETS(1,"CostResultSum",RowIdCost),"^",4) //成本金额
    ..s ^temp($j,year,"Cost")=$g(^temp($j,year,"Cost"))+CostData
    
    .f  s RowIdY=$o(^DHCCAINCOMEDATAS(0,"Interval",RowId,RowIdY)) q:RowIdY=""  d
    ..s itemDr=$p(^DHCCAINCOMEDATAS(RowIdY),"^",6) q:itemDr=""
    ..q:'$d(^DHCCADATALEVELSETS(0,"Item","6",itemDr))
    ..s yaofeei=$p(^DHCCAINCOMEDATAS(RowIdY),"^",7) 
    ..s ^temp($j,year,"yaopi")=$g(^temp($j,year,"yaopi"))+yaofeei   //药品收入
    
    .f  s RowIdCl=$o(^DHCCAINCOMEDATAS(0,"Interval",RowId,RowIdCl)) q:RowIdCl=""  d
    ..s itemDr=$p(^DHCCAINCOMEDATAS(RowIdCl),"^",6) q:itemDr=""
    ..q:'$d(^DHCCADATALEVELSETS(0,"Item","7",itemDr))
    ..s clfeei=$p(^DHCCAINCOMEDATAS(RowIdCl),"^",7) 
    ..s ^temp($j,year,"clpi")=$g(^temp($j,year,"clpi"))+clfeei   //材料收入
    
    .f  s RowIdM=$o(^DHCCACOSTDISTSETS(0,"DInterval",1,RowId,RowIdM)) q:RowIdM=""  d
    ..s itemDrc=$p(^DHCCACOSTDISTSETS(1,"CostResultData",RowIdM),"^",4)
    ..q:'$d(^DHCCADATALEVELSETS(0,"Item","11",itemDrc))
    ..s manc=$p(^DHCCACOSTDISTSETS(1,"CostResultData",RowIdM),"^",5) 
    ..s ^temp($j,year,"manc")=$g(^temp($j,year,"manc"))+manc   //人力成本
    
    .f  s RowIdLM=$o(^DHCCACOSTDISTSETS(0,"DInterval",1,RowId,RowIdLM)) q:RowIdLM=""  d
    ..s itemDrc=$p(^DHCCACOSTDISTSETS(1,"CostResultData",RowIdLM),"^",4)
    ..q:'$d(^DHCCADATALEVELSETS(0,"Item","13",itemDrc))
    ..s ltmanc=$p(^DHCCACOSTDISTSETS(1,"CostResultData",RowIdLM),"^",5) 
    ..s ^temp($j,year,"ltmanc")=$g(^temp($j,year,"ltmanc"))+ltmanc   //离退休人员成本
    
    .f  s RowIdPClc=$o(^DHCCACOSTDISTSETS(0,"DInterval",1,RowId,RowIdPClc)) q:RowIdPClc=""  d
    ..s itemDrc=$p(^DHCCACOSTDISTSETS(1,"CostResultData",RowIdPClc),"^",4)
    ..q:'$d(^DHCCADATALEVELSETS(0,"Item","12",itemDrc))
    ..s clpc=$p(^DHCCACOSTDISTSETS(1,"CostResultData",RowIdPClc),"^",5) 
    ..s ^temp($j,year,"clpc")=$g(^temp($j,year,"clpc"))+clpc   //普通材料成本
    
    .f  s RowIdGClc=$o(^DHCCACOSTDISTSETS(0,"DInterval",1,RowId,RowIdGClc)) q:RowIdGClc=""  d
    ..s itemDrc=$p(^DHCCACOSTDISTSETS(1,"CostResultData",RowIdGClc),"^",4)
    ..q:'$d(^DHCCADATALEVELSETS(0,"Item","79",itemDrc))
    ..s gzclpc=$p(^DHCCACOSTDISTSETS(1,"CostResultData",RowIdGClc),"^",5) 
    ..s ^temp($j,year,"gzclpc")=$g(^temp($j,year,"gzclpc"))+gzclpc   //高值材料成本
    
    .f  s RowIdYpClc=$o(^DHCCACOSTDISTSETS(0,"DInterval",1,RowId,RowIdYpClc)) q:RowIdYpClc=""  d
    ..s itemDrc=$p(^DHCCACOSTDISTSETS(1,"CostResultData",RowIdYpClc),"^",4)
    ..q:'$d(^DHCCADATALEVELSETS(0,"Item","5",itemDrc))
    ..s yaopc=$p(^DHCCACOSTDISTSETS(1,"CostResultData",RowIdYpClc),"^",5) 
    ..s ^temp($j,year,"yaopc")=$g(^temp($j,year,"yaopc"))+yaopc   //药品成本
    
    .f  s RowIdZjClc=$o(^DHCCACOSTDISTSETS(0,"DInterval",1,RowId,RowIdZjClc)) q:RowIdZjClc=""  d
    ..s itemDrc=$p(^DHCCACOSTDISTSETS(1,"CostResultData",RowIdZjClc),"^",4)
    ..q:'$d(^DHCCADATALEVELSETS(0,"Item","10",itemDrc))
    ..s zjpc=$p(^DHCCACOSTDISTSETS(1,"CostResultData",RowIdZjClc),"^",5) 
    ..s ^temp($j,year,"zjpc")=$g(^temp($j,year,"zjpc"))+zjpc   //折旧成本
       
    .f  s RowIdNhYC=$o(^DHCCACOSTDISTSETS(0,"DInterval",1,RowId,RowIdNhYC)) q:RowIdNhYC=""  d
    ..s itemDrc=$p(^DHCCACOSTDISTSETS(1,"CostResultData",RowIdNhYC),"^",4)
    ..q:'$d(^DHCCADATALEVELSETS(0,"Item","14",itemDrc))
    ..s nhc=$p(^DHCCACOSTDISTSETS(1,"CostResultData",RowIdNhYC),"^",5) 
    ..s ^temp($j,year,"nhc")=$g(^temp($j,year,"nhc"))+nhc   //能耗成本
    
    .f  s RowIdOffClc=$o(^DHCCACOSTDISTSETS(0,"DInterval",1,RowId,RowIdOffClc)) q:RowIdOffClc=""  d
    ..s itemDrc=$p(^DHCCACOSTDISTSETS(1,"CostResultData",RowIdOffClc),"^",4)
    ..q:'$d(^DHCCADATALEVELSETS(0,"Item","77",itemDrc))
    ..s offc=$p(^DHCCACOSTDISTSETS(1,"CostResultData",RowIdOffClc),"^",5) 
    ..s ^temp($j,year,"offc")=$g(^temp($j,year,"offc"))+offc   //办公成本
        
    .f  s RowIdTelYC=$o(^DHCCACOSTDISTSETS(0,"DInterval",1,RowId,RowIdTelYC)) q:RowIdTelYC=""  d
    ..s itemDrc=$p(^DHCCACOSTDISTSETS(1,"CostResultData",RowIdTelYC),"^",4)
    ..q:'$d(^DHCCADATALEVELSETS(0,"Item","78",itemDrc))
    ..s telc=$p(^DHCCACOSTDISTSETS(1,"CostResultData",RowIdTelYC),"^",5) 
    ..s ^temp($j,year,"telc")=$g(^temp($j,year,"telc"))+telc   //通讯成本  
    
    .f  s RowIdOthYC=$o(^DHCCACOSTDISTSETS(0,"DInterval",1,RowId,RowIdOthYC)) q:RowIdOthYC=""  d
    ..s itemDrc=$p(^DHCCACOSTDISTSETS(1,"CostResultData",RowIdOthYC),"^",4)
    ..q:'$d(^DHCCADATALEVELSETS(0,"Item","15",itemDrc))
    ..s othc=$p(^DHCCACOSTDISTSETS(1,"CostResultData",RowIdOthYC),"^",5) 
    ..s ^temp($j,year,"othc")=$g(^temp($j,year,"othc"))+othc   //其他成本 
         
    s loc=0 f  s loc=$o(^temp($j,loc)) q:loc=""  d
	.s outdata=$g(^temp($j,loc,"Income"))_"^"_$g(^temp($j,loc,"Cost"))_"^"_$g(^temp($j,loc,"yaopi"))_"^"_$g(^temp($j,loc,"clpi"))_"^"_$g(^temp($j,loc,"manc"))_"^"_$g(^temp($j,loc,"ltmanc"))_"^"_$g(^temp($j,loc,"clpc"))_"^"_$g(^temp($j,loc,"gzclpc"))_"^"_$g(^temp($j,loc,"yaopc"))_"^"_$g(^temp($j,loc,"zjpc"))_"^"_$g(^temp($j,loc,"nhc"))_"^"_$g(^temp($j,loc,"offc"))_"^"_$g(^temp($j,loc,"telc"))_"^"_$g(^temp($j,loc,"othc"))
 
    .s incomefee=$p(outdata,"^",1)  //总收入
    .s costfee=$p(outdata,"^",2)     //总成本
    .s amt=incomefee-costfee                       //总利润   

    .s yaoincome=$p(outdata,"^",3) //药品收入
    .s clincome=$p(outdata,"^",4)  //材料收入
    .s ylincome=incomefee-yaoincome-clincome     //医疗收入
    
    .s mancc=$p(outdata,"^",5)   //人力成本
    .s ltmancc=$p(outdata,"^",6)  //离退休人员成本
    .s clpcc=$p(outdata,"^",7)   //普通材料成本
    .s gzclpcc=$p(outdata,"^",8)   //高值材料成本
    .s yaopcc=$p(outdata,"^",9)  //药品成本
    .s zjpcc=$p(outdata,"^",10)   //折旧成本
    .s nhcc=$p(outdata,"^",11)   //能耗成本
    .s offcc=$p(outdata,"^",12)   //办公成本
    .s telcc=$p(outdata,"^",13)   //通讯成本 
    .s othcc=$p(outdata,"^",14)  //其他成本 

    .d OutputRow27
    k ^temp($j)
  	q $$$OK
OutputRow27
   ; 
    s Data=$lb($g(loc),$fn($g(incomefee),"",2),$fn($g(costfee),"",2),$fn($g(amt),"",2),$fn($g(ylincome),"",2),$fn($g(yaoincome),"",2),$fn($g(clincome),"",2),$fn($g(mancc),"",2),$fn($g(ltmancc),"",2),$fn($g(clpcc),"",2),$fn($g(gzclpcc),"",2),$fn($g(yaopcc),"",2),$fn($g(zjpcc),"",2),$fn($g(nhcc),"",2),$fn($g(offcc),"",2),$fn($g(telcc),"",2),$fn($g(othcc),"",2))
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
}

ClassMethod SZBjfxFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SZBjfxExecute, SqlProc ]
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

ClassMethod SZBjfxClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SZBjfxExecute, SqlProc ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query SZBjfx() As %Query(ROWSPEC = "loc:%String,incomefee:%Float,costfee:%Float,amt:%Float,ylincome:%Float,yaoincome:%Float,clincome:%Float,mancc:%Float,ltmancc:%Float,clpcc:%Float,gzclpcc:%Float,yaopcc:%Float,zjpcc:%Float,nhcc:%Float,offcc:%Float,telcc:%Float,othcc:%Float") [ SqlProc ]
{
}

//全院总成本分类查询

//d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","GetQyMonCost","2014")

ClassMethod GetQyMonCostExecute(ByRef qHandle As %Binary, stdate As %Integer) As %Status [ SqlProc ]
{
                            
	Set repid=$I(^CacheTemp) 
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
 	
	q:stdate="" $$$OK
			
	s monthQ=stdate 
    ;s monthname=monthQ_""_"年度"
    k ^temp($j) 
    s RowId="",RowIdCost="",RowId1=""
    f  s RowId=$o(^DHCCAACCOUNTMONTHS(RowId))  q:RowId=""  d
    .s desc=$p(^DHCCAACCOUNTMONTHS(RowId),"^",2)
    .s desc1=$p(desc,"-",1)
    .q:desc1'=monthQ 
    .s ^temp($j,RowId)=$g(^temp($j,RowId))
    .s locdr=RowId
	.f  s RowIdCost=$o(^DHCCACOSTDISTSETS(0,"DInterval",1,locdr,RowIdCost))	q:RowIdCost=""  d
	..s distflag=$p($g(^DHCCACOSTDISTSETS("1","CostResultData",RowIdCost)),"^",6) q:distflag'="self"
	..s data=$p(^DHCCACOSTDISTSETS(1,"CostResultData",RowIdCost),"^",4)
	..s datafee=$p(^DHCCACOSTDISTSETS("1","CostResultData",RowIdCost),"^",5)
	..f  s RowId1=$o(^DHCCADATALEVELSETS(RowId1))  q:RowId1=""  d
    ...s parent=$p(^DHCCADATALEVELSETS(RowId1),"^",7) q:parent'=25  //成本项目构成//新会计制度
    ...q:'$d(^DHCCADATALEVELSETS(0,"Item",RowId1,data))
	...s ^temp($j,locdr,RowId1,data)=$g(^temp($j,locdr,RowId1,data))+datafee
	
	s monloc=0 f  s monloc=$o(^temp($j,monloc)) q:monloc=""  d
	.s datafc=0  f  s datafc=$o(^temp($j,monloc,datafc)) q:datafc=""  d
	..s item=0  f  s item=$o(^temp($j,monloc,datafc,item)) q:item=""  d
	...s sum=$g(^temp($j,monloc,datafc,item))
	...d OutputRow28
           
   k ^temp($j)
   q $$$OK
	
OutputRow28
    s datafcname=$p(^DHCCADATALEVELSETS(datafc),"^",2)  
    i $d(^DHCCAALLDATAITEMS(item)) s itemdesc=$P(^DHCCAALLDATAITEMS(item),"^",3)
    
    s desc=$p(^DHCCAACCOUNTMONTHS(monloc),"^",2)
    s mon=+$p(desc,"-",2)
    s month=+$p(desc,"-",2)_""_"月"
         
	s Data=$lb(monloc,mon,month,datafc,datafcname,item,itemdesc,$g(sum))
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetQyMonCostFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetQyMonCostExecute, SqlProc ]
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

ClassMethod GetQyMonCostClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetQyMonCostExecute, SqlProc ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetQyMonCost(stdate As %Integer) As %Query(ROWSPEC = "monloc:%Integer,mon:%Integer,month:%String,datafc:%Integer,datafcname:%String,item:%Integer,itemdesc:%String,sum:%Float") [ SqlProc ]
{
}

//收入指标同期比较

//d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","SrzbTqbj")

ClassMethod SrzbTqbjExecute(ByRef qHandle As %Binary) As %Status [ SqlProc ]
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
 	

	k ^temp($j)
    s RowId1="",RowIdCost="",RowId="",RowIdCZ="",RowIdQt=""
    s RowIdY="",RowIdCl="",RowIdM="",RowIdLM="",RowIdPClc="",RowIdGClc="",RowIdYpClc=""
    s RowIdZjClc="",RowIdNhYC="",RowIdOffClc="",RowIdTelYC="",RowIdOthYC=""
   
   
     f  s RowId=$o(^DHCCAACCOUNTMONTHS(RowId))  q:RowId=""  d
    .s desc=$p(^DHCCAACCOUNTMONTHS(RowId),"^",2)
    .s year=$p(desc,"-",1) q:year<"2007"
    
    .f  s RowIdCZ=$o(^DHCCABUDGETDATA(0,"IntDeptItem",RowId,279,533,RowIdCZ)) q:RowIdCZ=""  d
    ..s CZData=$p(^DHCCABUDGETDATA(RowIdCZ),"^",6)
    ..s ^temp($j,year,"CZData")=$g(^temp($j,year,"CZData"))+CZData //财政补助  
    
    .f  s RowIdQt=$o(^DHCCABUDGETDATA(0,"IntDeptItem",RowId,279,534,RowIdQt)) q:RowIdQt=""  d
    ..s QtData=$p(^DHCCABUDGETDATA(RowIdQt),"^",6)
    ..s ^temp($j,year,"QtData")=$g(^temp($j,year,"QtData"))+QtData //其他收入 
        
    .f  s RowId1=$o(^DHCCAINCOMEDATAS(0,"Interval",RowId,RowId1)) q:RowId1=""  d
    ..s IncomeData=$p(^DHCCAINCOMEDATAS(RowId1),"^",7)
    ..s ^temp($j,year,"Income")=$g(^temp($j,year,"Income"))+IncomeData //HIS总收入  
       
    .f  s RowIdY=$o(^DHCCAINCOMEDATAS(0,"Interval",RowId,RowIdY)) q:RowIdY=""  d
    ..s itemDr=$p(^DHCCAINCOMEDATAS(RowIdY),"^",6) q:itemDr=""
    ..q:'$d(^DHCCADATALEVELSETS(0,"Item","6",itemDr))
    ..s yaofeei=$p(^DHCCAINCOMEDATAS(RowIdY),"^",7) 
    ..s ^temp($j,year,"yaopi")=$g(^temp($j,year,"yaopi"))+yaofeei   //药品收入
    
    .f  s RowIdCost=$o(^DHCCACOSTDISTSETS(1,"IntIDFlag",RowId,1,"branch",RowIdCost)) q:RowIdCost=""   d
    ..s Cost=$p(^DHCCACOSTDISTSETS(1,"CostResultSum",RowIdCost),"^",4) //成本金额
   	..s ^temp($j,year,"Cost")=$g(^temp($j,year,"Cost"))+Cost  //总成本
      
    .f  s RowIdYpClc=$o(^DHCCAVOUCHDATAS(0,"Interval",RowId,RowIdYpClc)) q:RowIdYpClc=""  d
    ..s itemDrc=$p(^DHCCAVOUCHDATAS(RowIdYpClc),"^",3) 
    ..q:itemDrc=""
    ..q:'$d(^DHCCADATALEVELSETS(0,"Item","5",itemDrc))
    ..s yaopc=$p(^DHCCAVOUCHDATAS(RowIdYpClc),"^",16) 
    ..s ^temp($j,year,"yaopc")=$g(^temp($j,year,"yaopc"))+yaopc   //药品成本
    
    
     /*
    .f  s RowIdYpClc=$o(^DHCCACOSTDISTSETS(0,"DInterval",1,RowId,RowIdYpClc)) q:RowIdYpClc=""  d
    ..s flag=$p(^DHCCACOSTDISTSETS(1,"CostResultData",RowIdYpClc),"^",6) 
    ..q:flag'="self"
    ..s itemDrc=$p(^DHCCACOSTDISTSETS(1,"CostResultData",RowIdYpClc),"^",4)
    ..q:'$d(^DHCCADATALEVELSETS(0,"Item","2",itemDrc))
    ..s yaopc=$p(^DHCCACOSTDISTSETS(1,"CostResultData",RowIdYpClc),"^",5) 
    ..s ^temp($j,year,"yaopc")=$g(^temp($j,year,"yaopc"))+yaopc   //药品成本
    

    .f  s RowIdCl=$o(^DHCCAINCOMEDATAS(0,"Interval",RowId,RowIdCl)) q:RowIdCl=""  d
    ..s itemDr=$p(^DHCCAINCOMEDATAS(RowIdCl),"^",6) q:itemDr=""
    ..q:'$d(^DHCCADATALEVELSETS(0,"Item","12",itemDr))
    ..s clfeei=$p(^DHCCAINCOMEDATAS(RowIdCl),"^",7) 
    ..s ^temp($j,year,"clpi")=$g(^temp($j,year,"clpi"))+clfeei   //材料收入
    */        
    s loc=0 f  s loc=$o(^temp($j,loc)) q:loc=""  d
	.s outdata=$g(^temp($j,loc,"Income"))_"^"_$g(^temp($j,loc,"yaopi"))_"^"_$g(^temp($j,loc,"CZData"))_"^"_$g(^temp($j,loc,"QtData"))_"^"_$g(^temp($j,loc,"Cost"))_"^"_$g(^temp($j,loc,"yaopc"))
 
    .s incomefee=$p(outdata,"^",1)  //总收入
    .s yaoincome=$p(outdata,"^",2) //药品收入
    .;s clincome=$p(outdata,"^",3)  //材料收入
    .s ylincome=incomefee-yaoincome ;-clincome     //医疗收入
    .s Czfee=$p(outdata,"^",3)  //财政补助
    .s Qtfee=$p(outdata,"^",4)  //其他收入
    .s Zcost=$p(outdata,"^",5)  //总成本
    .s ypcost=$p(outdata,"^",6)  //药品成本
    .s ylcost=Zcost-ypcost  //医疗成本
    
    .d OutputRow29
    k ^temp($j)
  	q $$$OK
OutputRow29
   ; 
    s Data=$lb($g(loc),$fn($g(incomefee),"",2),$fn($g(ylincome),"",2),$fn($g(yaoincome),"",2),$fn($g(Czfee),"",2),$fn($g(Qtfee),"",2),$fn($g(Zcost),"",2),$fn($g(ypcost),"",2),$fn($g(ylcost),"",2))
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
}

ClassMethod SrzbTqbjFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SrzbTqbjExecute, SqlProc ]
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

ClassMethod SrzbTqbjClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SrzbTqbjExecute, SqlProc ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query SrzbTqbj() As %Query(ROWSPEC = "loc:%String,incomefee:%Float,ylincome:%Float,yaoincome:%Float,Czfee:%Float,Qtfee:%Float,Zcost:%Float,ypcost:%Float,ylcost:%Float") [ SqlProc ]
{
}

//d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","GetfDeptMonthHz","2012")	

//临床大科利润分析

ClassMethod GetfDeptMonthHzExecute(ByRef qHandle As %Binary, stdate As %Integer) As %Status [ SqlProc ]
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
   
    q:stdate="" $$$OK
	s RowId="",RowIdIncome="",Income="",RowidZ="",RowidDept="",parentz="" 
	s RowIdData="",RowIdDataZc="",RowIdZj="",RowidcZ=""
	k ^temp($j)
    
    s monthname=stdate_""_"年度" 
    f  s RowId=$o(^DHCCAACCOUNTMONTHS(RowId))  q:RowId=""  d
    .s desc=$p(^DHCCAACCOUNTMONTHS(RowId),"^",2)
    .s mon=+$p(desc,"-",2)_""_"月"
    .s desc1=$p(desc,"-",1)
    .;i $d(^DHCCAACCOUNTMONTHS(stdate)) s month=$p(^DHCCAACCOUNTMONTHS(stdate),"^",2),monthQ=$p(month,"-",1),monthname=monthQ_""_"年度"
    .q:desc1'=stdate
   
    .f  s RowIdIncome=$o(^DHCCAINCOMEDATAS(0,"Interval",RowId,RowIdIncome)) q:RowIdIncome=""  d
    ..s dept=$p(^DHCCAINCOMEDATAS(RowIdIncome),"^",11)
    ..;s tdept=$p(^DHCCAINCOMEDATAS(RowIdIncome),"^",14)
    ..;q:tdept'=dept   //lxc-2011-02-21 add
    ..s itemdr=$p(^DHCCAINCOMEDATAS(RowIdIncome),"^",6)
   
    ..s Income1=$p(^DHCCAINCOMEDATAS(RowIdIncome),"^",7)
    ..;f RowidZ=21:1:55 d
    ..;.q:dept=""
    ..;.q:'$d(^DHCCADEPTLEVELSETS(0,"Dept",RowidZ,dept))
    ..;.s parentz=$p(^DHCCADEPTLEVELSETS(RowidZ),"^",7)
    ..;.i $d(^DHCCADEPTLEVELSETS(parentz)) s pa=$p(^DHCCADEPTLEVELSETS(parentz),"^",7)  q:pa'="18"  //q:pa'="13"
    ..; 20140903 zjw 屏蔽  修改见下
    ..s pa=7  //大科分类id
    ..s parentz=8  //临床医疗大科分组id
    ..f  s RowidZ=$O(^DHCCADEPTLEVELSETS(0,"Parent",parentz,RowidZ)) q:RowidZ=""  d
    ...q:dept=""
    ...q:'$d(^DHCCADEPTLEVELSETS(0,"Dept",RowidZ,dept))
    ...;//^temp  月份id  大科分类id  临床医疗大科分组id   大科科室分组id
    ...s ^temp($j,"Income",RowId,pa,parentz,RowidZ)=$g(^temp($j,"Income",RowId,pa,parentz,RowidZ))+Income1 
    
    
    .f  s RowIdZj=$o(^DHCCACOSTDISTSETS(1,"CostResultSum",RowIdZj)) q:RowIdZj=""   d
    ..s inter=$p(^DHCCACOSTDISTSETS(1,"CostResultSum",RowIdZj),"^",1) q:inter'=RowId
    ..s flag=$p(^DHCCACOSTDISTSETS(1,"CostResultSum",RowIdZj),"^",2) q:flag'="leaf"
    ..s deptc=$p(^DHCCACOSTDISTSETS(1,"CostResultSum",RowIdZj),"^",3) 
    ..s zjcost=$p(^DHCCACOSTDISTSETS(1,"CostResultSum",RowIdZj),"^",4)
    ..s jjcost=$p(^DHCCACOSTDISTSETS(1,"CostResultSum",RowIdZj),"^",5) 
    ..s pac=7  //大科分类id
    ..s parentcz=8  //临床医疗大科分组id
    ..f  s RowidcZ=$O(^DHCCADEPTLEVELSETS(0,"Parent",parentcz,RowidcZ)) q:RowidcZ=""  d
    ...q:deptc=""
    ...q:'$d(^DHCCADEPTLEVELSETS(0,"Dept",RowidcZ,deptc))
    ...s ^temp($j,"zjCost",RowId,pac,parentcz,RowidcZ)=$g(^temp($j,"zjCost",RowId,pac,parentcz,RowidcZ))+zjcost
    ...s ^temp($j,"jjCost",RowId,pac,parentcz,RowidcZ)=$g(^temp($j,"jjCost",RowId,pac,parentcz,RowidcZ))+jjcost
    
   
   
   
    s locdr=0 f  s locdr=$o(^temp($j,"Income",locdr)) q:locdr=""  d
    .s paz=0 f  s paz=$o(^temp($j,"Income",locdr,paz)) q:paz=""  d
    ..s parz=0 f  s parz=$o(^temp($j,"Income",locdr,paz,parz)) q:parz=""  d
    ...s deptz=0 f  s deptz=$o(^temp($j,"Income",locdr,paz,parz,deptz)) q:deptz=""  d
 	....s outdata=$g(^temp($j,"Income",locdr,paz,parz,deptz))_"^"_$g(^temp($j,"zjCost",locdr,paz,parz,deptz))_"^"_$g(^temp($j,"jjCost",locdr,paz,parz,deptz))
 	....s incomefee=$p(outdata,"^",1)
 	....s zjsum=$p(outdata,"^",2)
 	....s jjsum=$p(outdata,"^",3)
    ....d OutputRow30
 	
 	;输出合计
 	;d OutputRowWorkSum
 	k ^temp($j)
 	q $$$OK
OutputRow30
	s descy=$p(^DHCCAACCOUNTMONTHS(locdr),"^",2)
    s mony=+$p(descy,"-",2)
    s monthy=+$p(descy,"-",2) _""_"月"
    s pazname=$p(^DHCCADEPTLEVELSETS(paz),"^",2)
    s parzname=$p(^DHCCADEPTLEVELSETS(parz),"^",2)
    s deptzname=$p(^DHCCADEPTLEVELSETS(deptz),"^",2)
    s Data=$lb(monthname,locdr,mony,monthy,paz,pazname,parz,parzname,deptz,deptzname,$g(incomefee),$g(zjsum),$g(jjsum))
 	
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
	
OutputRowWorkSum30
    s Data=$lb("total",$g(totalFee))
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
 //ResetVariables
 //	 q
}

ClassMethod GetfDeptMonthHzFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetfDeptMonthHzExecute, SqlProc ]
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

ClassMethod GetfDeptMonthHzClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetfDeptMonthHzExecute, SqlProc ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetfDeptMonthHz(stdate As %Integer) As %Query(ROWSPEC = "monthname:%String,locdr:%Integer,mony:%Integer,monthy:%String,paz:%Integer,pazname:%String,parz:%Integer,parzname:%String,deptz:%Integer,deptzname:%String,incomefee:%Float,zjsum:%Float,jjsum:%Float") [ SqlProc ]
{
}

//d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","GettDeptMonthHz","2013")	

//医技大科利润分析

ClassMethod GettDeptMonthHzExecute(ByRef qHandle As %Binary, stdate As %Integer) As %Status [ SqlProc ]
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
   
    q:stdate="" $$$OK
	s RowId="",RowIdIncome="",Income="",RowidZ="",RowidDept="",parentz="" 
	s RowIdData="",RowIdDataZc="",RowIdZj="",RowidcZ=""
	k ^temp($j)
	
	s monthname=stdate_""_"年度"  
    f  s RowId=$o(^DHCCAACCOUNTMONTHS(RowId))  q:RowId=""  d
    .s desc=$p(^DHCCAACCOUNTMONTHS(RowId),"^",2)
    .s mon=+$p(desc,"-",2)_""_"月"
    .s desc1=$p(desc,"-",1)
    .i $d(^DHCCAACCOUNTMONTHS(stdate)) s month=$p(^DHCCAACCOUNTMONTHS(stdate),"^",2),monthQ=$p(month,"-",1),monthname=monthQ_""_"年度"
    .q:desc1'=stdate
   
    .f  s RowIdIncome=$o(^DHCCAINCOMEDATAS(0,"Interval",RowId,RowIdIncome)) q:RowIdIncome=""  d
    ..s dept=$p(^DHCCAINCOMEDATAS(RowIdIncome),"^",14)
    ..s Income1=$p(^DHCCAINCOMEDATAS(RowIdIncome),"^",7)
    ..;f RowidZ=56:1:63 d 
    ..;.q:dept=""
    ..;.q:'$d(^DHCCADEPTLEVELSETS(0,"Dept",RowidZ,dept))
    ..;.s parentz=$p(^DHCCADEPTLEVELSETS(RowidZ),"^",7)
    ..;.i $d(^DHCCADEPTLEVELSETS(parentz)) s pa=$p(^DHCCADEPTLEVELSETS(parentz),"^",7) q:pa'="18"
    ..; 20140903 zjw 屏蔽  修改见下
    ..s pa=7  //大科分类id
    ..s parentz=9  //医技大科分组id
    ..f  s RowidZ=$O(^DHCCADEPTLEVELSETS(0,"Parent",parentz,RowidZ)) q:RowidZ=""  d
    ...q:dept=""
    ...q:'$d(^DHCCADEPTLEVELSETS(0,"Dept",RowidZ,dept))
    ...;//^temp  月份id  大科分类id  医技大科分组id   大科科室分组id
    ...s ^temp($j,"Income",RowId,pa,parentz,RowidZ)=$g(^temp($j,"Income",RowId,pa,parentz,RowidZ))+Income1 
    
    .f  s RowIdZj=$o(^DHCCACOSTDISTSETS(1,"CostResultSum",RowIdZj)) q:RowIdZj=""   d
    ..s inter=$p(^DHCCACOSTDISTSETS(1,"CostResultSum",RowIdZj),"^",1) q:inter'=RowId
    ..s flag=$p(^DHCCACOSTDISTSETS(1,"CostResultSum",RowIdZj),"^",2) q:flag'="leaf"
    ..s deptc=$p(^DHCCACOSTDISTSETS(1,"CostResultSum",RowIdZj),"^",3) 
    ..s zjcost=$p(^DHCCACOSTDISTSETS(1,"CostResultSum",RowIdZj),"^",4)
    ..s jjcost=$p(^DHCCACOSTDISTSETS(1,"CostResultSum",RowIdZj),"^",5) 
    ..s pac=7  //大科分类id
    ..s parentcz=9  //医技大科分组id
    ..f  s RowidcZ=$O(^DHCCADEPTLEVELSETS(0,"Parent",parentcz,RowidcZ)) q:RowidcZ=""  d
    ...q:deptc=""
    ...q:'$d(^DHCCADEPTLEVELSETS(0,"Dept",RowidcZ,deptc))
    ...s ^temp($j,"zjCost",RowId,pac,parentcz,RowidcZ)=$g(^temp($j,"zjCost",RowId,pac,parentcz,RowidcZ))+zjcost
    ...s ^temp($j,"jjCost",RowId,pac,parentcz,RowidcZ)=$g(^temp($j,"jjCost",RowId,pac,parentcz,RowidcZ))+jjcost
   
    s locdr=0 f  s locdr=$o(^temp($j,"Income",locdr)) q:locdr=""  d
    .s paz=0 f  s paz=$o(^temp($j,"Income",locdr,paz)) q:paz=""  d
    ..s parz=0 f  s parz=$o(^temp($j,"Income",locdr,paz,parz)) q:parz=""  d
    ...s deptz=0 f  s deptz=$o(^temp($j,"Income",locdr,paz,parz,deptz)) q:deptz=""  d
 	....s outdata=$g(^temp($j,"Income",locdr,paz,parz,deptz))_"^"_$g(^temp($j,"zjCost",locdr,paz,parz,deptz))_"^"_$g(^temp($j,"jjCost",locdr,paz,parz,deptz))
 	....s incomefee=$p(outdata,"^",1)
 	....s zjsum=$p(outdata,"^",2)
 	....s jjsum=$p(outdata,"^",3)
    ....d OutputRow31
 	
 	;输出合计
 	;d OutputRowWorkSum
 	k ^temp($j)
 	q $$$OK
OutputRow31
	s descy=$p(^DHCCAACCOUNTMONTHS(locdr),"^",2)
    s mony=+$p(descy,"-",2)
    s monthy=+$p(descy,"-",2) _""_"月"
    s pazname=$p(^DHCCADEPTLEVELSETS(paz),"^",2)
    s parzname=$p(^DHCCADEPTLEVELSETS(parz),"^",2)
    s deptzname=$p(^DHCCADEPTLEVELSETS(deptz),"^",2)
    s Data=$lb(monthname,locdr,mony,monthy,paz,pazname,parz,parzname,deptz,deptzname,$fn($g(incomefee),"",2),$fn($g(zjsum),"",2),$fn($g(jjsum),"",2))
 	
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
	
OutputRowWorkSum31
    s Data=$lb("total",$g(totalFee))
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
 //ResetVariables
 //	 q
}

ClassMethod GettDeptMonthHzFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GettDeptMonthHzExecute, SqlProc ]
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

ClassMethod GettDeptMonthHzClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GettDeptMonthHzExecute, SqlProc ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GettDeptMonthHz(stdate As %Integer) As %Query(ROWSPEC = "monthname:%String,locdr:%Integer,mony:%Integer,monthy:%String,paz:%Integer,pazname:%String,parz:%Integer,parzname:%String,deptz:%Integer,deptzname:%String,incomefee:%Float,zjsum:%Float,jjsum:%Float") [ SqlProc ]
{
}

//科室开单收入查询d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","GetDeptKdIncome","1","1","2,3")

ClassMethod GetDeptKdIncomeExecute(ByRef qHandle As %Binary, stdate As %String, endate As %String, dept As %String) As %Status [ SqlProc ]
{
                            
	Set repid=$I(^CacheTemp) 
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
 	
	q:stdate="" $$$OK
	q:endate="" $$$OK
	q:dept="" $$$OK
	s RowId="",RowId1="",RowId2="",dep=""
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
    s i1="",i=""
    f i1=stdatecode:1:endatecode d
    .f  s i=$o(^DHCCAACCOUNTMONTHS(0,"Code",i1,i)) q:i=""  d
    ..f  s RowId=$o(^DHCCAINCOMEDATAS(0,"Interval",i,RowId)) q:RowId=""  d
    ...s fdept=$p(^DHCCAINCOMEDATAS(RowId),"^",11)
    ...q:$F(","_dept_",",","_fdept_",")=0
    ...s tdept=$p(^DHCCAINCOMEDATAS(RowId),"^",14)
    ...s item=$p(^DHCCAINCOMEDATAS(RowId),"^",6)
    ...s fee=$p(^DHCCAINCOMEDATAS(RowId),"^",7)
    ...f  s RowId1=$o(^DHCCADATALEVELSETS(RowId1))  q:RowId1=""  d
    ....s parent=$p(^DHCCADATALEVELSETS(RowId1),"^",7) q:parent'=6  //收入分类
    ....q:'$d(^DHCCADATALEVELSETS(0,"Item",RowId1,item))
    ....s ^temp($j,"depted",fdept,RowId1,item,tdept)=$g(^temp($j,"depted",fdept,RowId1,item,tdept))+fee
   
         
    s fdeptdr=0 f  s fdeptdr=$o(^temp($j,"depted",fdeptdr)) q:fdeptdr=""  d
    .s datafc=0 f  s datafc=$o(^temp($j,"depted",fdeptdr,datafc)) q:datafc=""  d
    ..s itemdr=0 f  s itemdr=$o(^temp($j,"depted",fdeptdr,datafc,itemdr)) q:itemdr=""  d 
    ...s tdeptdr=0 f  s tdeptdr=$o(^temp($j,"depted",fdeptdr,datafc,itemdr,tdeptdr)) q:tdeptdr=""  d
    ....s sum=$g(^temp($j,"depted",fdeptdr,datafc,itemdr,tdeptdr))
    ....d OutputRow32
   
   k ^temp($j)        
   q $$$OK
	
OutputRow32
	
    i $d(^DHCCAALLDATAITEMS(itemdr)) s ItemDesc=$P(^DHCCAALLDATAITEMS(itemdr),"^",3)
    s fdeptname=$P(^DHCCAUNITDEPTS(fdeptdr),"^",2)
	s tdeptname=$P(^DHCCAUNITDEPTS(tdeptdr),"^",2)
	s datafcname=$p(^DHCCADATALEVELSETS(datafc),"^",2)  
	
	s Data=$lb(monthname1,monthname2,fdeptdr,fdeptname,datafc,datafcname,itemdr,ItemDesc,tdeptdr,tdeptname,$g(sum))
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetDeptKdIncomeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDeptKdIncomeExecute, SqlProc ]
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

ClassMethod GetDeptKdIncomeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDeptKdIncomeExecute, SqlProc ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetDeptKdIncome(stdate As %String, endate As %String, dept As %String) As %Query(ROWSPEC = "monthname1:%String,monthname2:%String,fdeptdr:%Integer,fdeptname:%String,datafc:%Integer,datafcname:%String,itemdr:%Integer,ItemDesc:%String,tdeptdr:%Integer,tdeptname:%String,sum:%Float") [ SqlProc ]
{
}

//科室执行收入查询d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","GetDeptZxIncome","1","1","2,3,5,6")

ClassMethod GetDeptZxIncomeExecute(ByRef qHandle As %Binary, stdate As %String, endate As %String, dept As %String) As %Status [ SqlProc ]
{
                            
	Set repid=$I(^CacheTemp) 
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
 	
	q:stdate="" $$$OK
	q:endate="" $$$OK
	q:dept="" $$$OK
	s RowId="",RowId1="",RowId2="",dep=""
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
    s i1="",i=""
    f i1=stdatecode:1:endatecode d
    .f  s i=$o(^DHCCAACCOUNTMONTHS(0,"Code",i1,i)) q:i=""  d
    ..f  s RowId=$o(^DHCCAINCOMEDATAS(0,"Interval",i,RowId)) q:RowId=""  d
    ...s tdept=$p(^DHCCAINCOMEDATAS(RowId),"^",14)
    ...q:$F(","_dept_",",","_tdept_",")=0
    ...s fdept=$p(^DHCCAINCOMEDATAS(RowId),"^",11)
    ...s item=$p(^DHCCAINCOMEDATAS(RowId),"^",6)
    ...s fee=$p(^DHCCAINCOMEDATAS(RowId),"^",7)
    ...f  s RowId1=$o(^DHCCADATALEVELSETS(RowId1))  q:RowId1=""  d
    ....s parent=$p(^DHCCADATALEVELSETS(RowId1),"^",7) q:parent'=6  //收入分类
    ....q:'$d(^DHCCADATALEVELSETS(0,"Item",RowId1,item))
    ....s ^temp($j,"depted",tdept,RowId1,item,fdept)=$g(^temp($j,"depted",tdept,RowId1,item,fdept))+fee
   
         
    s tdeptdr=0 f  s tdeptdr=$o(^temp($j,"depted",tdeptdr)) q:tdeptdr=""  d
    .s datafc=0 f  s datafc=$o(^temp($j,"depted",tdeptdr,datafc)) q:datafc=""  d
    ..s itemdr=0 f  s itemdr=$o(^temp($j,"depted",tdeptdr,datafc,itemdr)) q:itemdr=""  d 
    ...s fdeptdr=0 f  s fdeptdr=$o(^temp($j,"depted",tdeptdr,datafc,itemdr,fdeptdr)) q:fdeptdr=""  d
    ....s sum=$g(^temp($j,"depted",tdeptdr,datafc,itemdr,fdeptdr))
    ....d OutputRow33
   
   k ^temp($j)        
   q $$$OK
	
OutputRow33
	
    i $d(^DHCCAALLDATAITEMS(itemdr)) s ItemDesc=$P(^DHCCAALLDATAITEMS(itemdr),"^",3)
    s fdeptname=$P(^DHCCAUNITDEPTS(fdeptdr),"^",2)
	s tdeptname=$P(^DHCCAUNITDEPTS(tdeptdr),"^",2)
	s datafcname=$p(^DHCCADATALEVELSETS(datafc),"^",2)  
	
	s Data=$lb(monthname1,monthname2,tdeptdr,tdeptname,datafc,datafcname,itemdr,ItemDesc,fdeptdr,fdeptname,$g(sum))    
	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetDeptZxIncomeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDeptZxIncomeExecute, SqlProc ]
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

ClassMethod GetDeptZxIncomeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDeptZxIncomeExecute, SqlProc ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetDeptZxIncome(stdate As %String, endate As %String, dept As %String) As %Query(ROWSPEC = "monthname1:%String,monthname2:%String,tdeptdr:%Integer,tdeptname:%String,datafc:%Integer,datafcname:%String,itemdr:%Integer,ItemDesc:%String,fdeptdr:%Integer,fdeptname:%String,sum:%Float") [ SqlProc ]
{
}

//选择收入统计项目d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","GetIncomeFl")

ClassMethod GetIncomeFlExecute(ByRef qHandle As %Binary) As %Status [ SqlProc ]
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
     
    s RowId=1,RowId1=""
    
    f  s RowId=$o(^DHCCADATALEVELSETS(RowId))  q:RowId=""  d
    .s parent=$p(^DHCCADATALEVELSETS(RowId),"^",7) q:parent'=6  //收入分类
    .s fldesc=$p(^DHCCADATALEVELSETS(RowId),"^",2)
    .f  s RowId1=$o(^DHCCADATALEVELSETS(RowId,"Items",RowId1))  q:RowId1=""  d
    ..s item=$p(^DHCCADATALEVELSETS(RowId,"Items",RowId1),"^",3) 
    ..q:item=""
    ..s ItemDesc=$P(^DHCCAALLDATAITEMS(item),"^",3)
    ..d OutputRow34
  
   	q $$$OK

OutputRow34
	
  	s Data=$lb(RowId,fldesc,item,ItemDesc)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
}

ClassMethod GetIncomeFlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetIncomeFlExecute, SqlProc ]
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

ClassMethod GetIncomeFlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetIncomeFlExecute, SqlProc ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetIncomeFl() As %Query(ROWSPEC = "RowId:%Integer,fldesc:%String,item:%Integer,ItemDesc:%String") [ SqlProc ]
{
}

//医技科室分析:

//d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","GetYjFtJyfx1","21","7")

ClassMethod GetYjFtJyfx1Execute(ByRef qHandle As %Binary, stdate As %String, type As %String) As %Status [ SqlProc ]
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
 	
	q:stdate="" $$$OK
	q:type="" $$$OK
	k ^temp($j)
	 
    s RowId="",RowId2="",RowIdRole="",RowIdPara="",RowIdParaM="",RowIdParaZ=""
    s RowIdIncome="",RowIdcost="",RowIdDept=""
    i $d(^DHCCAACCOUNTMONTHS(stdate)) s month=$p(^DHCCAACCOUNTMONTHS(stdate),"^",2)
    s month1=$p(month,"-",1)
    s day=$p(month,"-",2)
    s monthname=month1_""_"年"_""_day_""_"月"

 
   /* f  s RowId=$o(^DHCCAUSERS(0,"Loginname",user,RowId)) q:RowId=""  d
    .f  s RowIdRole=$o(^DHCCAUSERS(RowId,"URoles",RowIdRole))  q:RowIdRole=""  d*/
    f  s RowIdDept=$o(^DHCCAROLES(type,"RDepts",RowIdDept)) q:RowIdDept=""  d
    .q:RowIdDept=0
    .s deptdr=$P(^DHCCAROLES(type,"RDepts",RowIdDept),"^",2) q:deptdr=""
    .s ^temp($j,deptdr)=$g(^temp($j,deptdr))
    
    s paraitem=0 
    s locdr=0 f  s locdr=$o(^temp($j,locdr)) q:locdr=""  d
    .i ($d(^DHCCAUNITDEPTS(locdr)))  s deptName=$p(^DHCCAUNITDEPTS(locdr),"^",2)
    
    .f  s RowIdIncome=$o(^DHCCAINCOMEDATAS(0,"IntervalTdeptdr",stdate,locdr,RowIdIncome)) q:RowIdIncome=""  d
    ..s InComeDatafee=$p(^DHCCAINCOMEDATAS(RowIdIncome),"^",7)
    ..s ^temp($j,locdr,"Income")=$g(^temp($j,locdr,"Income"))+InComeDatafee
   
    .f  s RowIdcost=$o(^DHCCACOSTDISTSETS(1,"IntIDFlag",stdate,locdr,"leaf",RowIdcost)) q:RowIdcost=""   d
    ..s sumamt=$p(^DHCCACOSTDISTSETS(1,"CostResultSum",RowIdcost),"^",7)  //成本金额
    ..s ^temp($j,locdr,"Cost")=$g(^temp($j,locdr,"Cost"))+$g(sumamt)
       
    .;f  s RowIdParaM=$o(^DHCCAPARAMDATAS(0,"IntervalSereddep",stdate,locdr,RowIdParaM)) q:RowIdParaM=""  d
    .;.s paraitem=$p(^DHCCAPARAMDATAS(RowIdParaM),"^",4) q:(paraitem'=174)&(paraitem'=175)   //医技科室参数 
    .;.s paradata=$p(^DHCCAPARAMDATAS(RowIdParaM),"^",11) 
    .;.s ^temp($j,locdr,"Para")=$g(^temp($j,locdr,"Para"))+$g(paradata)
           
    .;s parasum=$g(^temp($j,locdr,"Para")) 
    .s sumfee=$g(^temp($j,locdr,"Income")) 
    .s costFee=$g(^temp($j,locdr,"Cost")) 
    .s amt=sumfee-costFee
    .;i parasum'=""  s sumpara=sumfee/parasum,costpara=costFee/parasum,amtpara=amt/parasum
    .;e  s sumpara=0,costpara=0,amtpara=0
    .d OutputRow35
 	 
 	k ^temp($j)
  	q $$$OK
OutputRow35
	
  	;s Data=$lb($g(monthname),locdr,$g(deptName),$fn($g(parasum),"",2),$fn($g(sumfee),"",2),$fn($g(costFee),"",2),$fn($g(amt),"",2),$fn($g(sumpara),"",2),$fn($g(costpara),"",2),$fn($g(amtpara),"",2))
    s Data=$lb($g(monthname),locdr,$g(deptName),$g(sumfee),$g(costFee),$g(amt))
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
}

ClassMethod GetYjFtJyfx1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetYjFtJyfx1Execute, SqlProc ]
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

ClassMethod GetYjFtJyfx1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetYjFtJyfx1Execute, SqlProc ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetYjFtJyfx1(stdate As %String, type As %String) As %Query(ROWSPEC = "monthname:%String,locdr:%Integer,deptname:%String,sumfee:%Float,costfee:%Float,amt:%Float") [ SqlProc ]
{
}

//d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","GetYjFtQsfx1","1","202")

//医技科室

ClassMethod GetYjFtQsfx1Execute(ByRef qHandle As %Binary, stdate As %String, dept As %String) As %Status [ SqlProc ]
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
 	
 
	q:stdate="" $$$OK
	s RowId="",RowIdIncome="",RowIdCost="",Income="",Cost=""
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
    .s monthorder=+$p(desc,"-",2)
    
    .s ^temp($j,RowId)=$g(^temp($j,RowId))
    .s locdr=RowId
    .f  s RowIdIncome=$o(^DHCCAINCOMEDATAS(0,"IntervalTdeptdr",locdr,dept,RowIdIncome)) q:RowIdIncome=""  d
    ..s Income1=$p(^DHCCAINCOMEDATAS(RowIdIncome),"^",7)
    ..s ^temp($j,locdr,"Income")=$g(^temp($j,locdr,"Income"))+Income1
 
    .f  s RowIdCost=$o(^DHCCACOSTDISTSETS(1,"IntIDFlag",locdr,dept,"leaf",RowIdCost)) q:RowIdCost=""   d
    ..s Cost1=$p(^DHCCACOSTDISTSETS(1,"CostResultSum",RowIdCost),"^",7) //成本金额
   	..s ^temp($j,locdr,"Cost")=$g(^temp($j,locdr,"Cost"))+Cost1
   
    .s incomefee=$g(^temp($j,locdr,"Income")) 
    .s costfee=$g(^temp($j,locdr,"Cost")) 
    .s amt=incomefee-costfee
 	.d OutputRow36
    
    k ^temp($j)
 	q $$$OK
OutputRow36
	;
  	s Data=$lb($g(monthname),$g(mon),deptname,locdr,$g(incomefee),$g(costfee),$g(amt),$g(monthorder))
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetYjFtQsfx1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetYjFtQsfx1Execute, SqlProc ]
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

ClassMethod GetYjFtQsfx1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetYjFtQsfx1Execute, SqlProc ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetYjFtQsfx1(stdate As %String, dept As %String) As %Query(ROWSPEC = "monthname:%String,mon:%String,deptname:%String,locdr:%Integer,incomefee:%Float,costfee:%Float,amt:%Float,monthorder:%Integer") [ SqlProc ]
{
}

//成本构成分析

//d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","GetCostGcFx","1","1","demo")

ClassMethod GetCostGcFxExecute(ByRef qHandle As %Binary, stdate As %String, endate As %String, user As %String) As %Status [ SqlProc ]
{
	
 	Set repid=$I(^CacheTemp) 
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
    
	q:stdate="" $$$OK
	q:endate="" $$$OK		
    q:user="" $$$OK
    k ^temp($j) 
    
    s RowId="",RowIdCost="",RowId1="",RowIdu="",unitrid=""

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
    
    ..s i1="",locdr="" 
    ..f i1=stdatecode:1:endatecode d   
    ...f  s locdr=$o(^DHCCAACCOUNTMONTHS(0,"Code",i1,locdr))  q:locdr=""  d
    ....f  s RowIdCost=$o(^DHCCACOSTDISTSETS(0,"DInterval",unitrid,locdr,RowIdCost))	q:RowIdCost=""  d
	.....s distflag=$p($g(^DHCCACOSTDISTSETS(unitrid,"CostResultData",RowIdCost)),"^",6) q:distflag'="self"
	.....s data=$p(^DHCCACOSTDISTSETS(unitrid,"CostResultData",RowIdCost),"^",4)
	.....s datafee=$p(^DHCCACOSTDISTSETS(unitrid,"CostResultData",RowIdCost),"^",5)
	.....f  s RowId1=$o(^DHCCADATALEVELSETS(RowId1))  q:RowId1=""  d
    ......s parent=$p(^DHCCADATALEVELSETS(RowId1),"^",7) q:parent'=25   //新会计制度
    ......q:'$d(^DHCCADATALEVELSETS(0,"Item",RowId1,data))
	......s ^temp($j,RowId1,data)=$g(^temp($j,RowId1,data))+datafee
	
	s datafc=0  f  s datafc=$o(^temp($j,datafc)) q:datafc=""  d
	.s item=0  f  s item=$o(^temp($j,datafc,item)) q:item=""  d
	..s sum=$g(^temp($j,datafc,item))
	..d OutputRow37
   
   k ^temp($j)
   q $$$OK
	
OutputRow37
    s datafcname=$p(^DHCCADATALEVELSETS(datafc),"^",2)  
    i $d(^DHCCAALLDATAITEMS(item)) s itemdesc=$P(^DHCCAALLDATAITEMS(item),"^",3)
    
	s Data=$lb(monthname1,monthname2,datafc,datafcname,item,itemdesc,$g(sum))
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetCostGcFxFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCostGcFxExecute, SqlProc ]
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

ClassMethod GetCostGcFxClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCostGcFxExecute, SqlProc ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetCostGcFx(stdate As %String, endate As %String, user As %String) As %Query(ROWSPEC = "monthname1:%String,monthname2:%String,datafc:%Integer,datafcname:%String,item:%String,itemdesc:%String,sum:%Float") [ SqlProc ]
{
}

//大科分摊趋势分析d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","GetFtQsfx1Dk","1","1","demo")

ClassMethod GetFtQsfx1DkExecute(ByRef qHandle As %Binary, stdate As %String, type As %String, user As %String) As %Status [ SqlProc ]
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
 	
 	q:user="" $$$OK
    q:type="" $$$OK
	q:stdate="" $$$OK
	
	s RowIdu="",unitrid="",RowIdDept=""
	s RowId="",RowIdIncome="",RowIdCost="",Income="",Cost=""
	k ^temp($j)
	
	i $d(^DHCCAROLES(type)) s typename=$p(^DHCCAROLES(type),"^",3)
	
    i $d(^DHCCAACCOUNTMONTHS(stdate)) d
	.s month=$p(^DHCCAACCOUNTMONTHS(stdate),"^",2)
    .s monthQ=$p(month,"-",1)
    .s monthname=monthQ_""_"年度"
    
    f  s RowId=$o(^DHCCAACCOUNTMONTHS(RowId))  q:RowId=""  d
    .s desc=$p(^DHCCAACCOUNTMONTHS(RowId),"^",2)
    .s mon=+$p(desc,"-",2)_""_"月"
    .s desc1=$p(desc,"-",1)
    .q:desc1'=monthQ 
    .s monthorder=+$p(desc,"-",2)
    .s locdr=RowId
    .f  s RowIdu=$o(^DHCCAUSERS(0,"Loginname",user,RowIdu)) q:RowIdu=""  d
    ..s bz=$p(^DHCCAUSERS(RowIdu),"^",5)  //取集团医院ID 1总部,2二部,3三部
    ..f  s unitrid=$o(^DHCCAUNITDEPTS(0,"Unit",unitrid))  q:unitrid=""  d
    ...q:$F(","_bz_",",","_unitrid_",")=0
    ...f  s RowIdDept=$o(^DHCCAROLES(type,"RDepts",RowIdDept)) q:RowIdDept=""  d
    ....q:RowIdDept=0
    ....s deptdr=$P(^DHCCAROLES(type,"RDepts",RowIdDept),"^",2) q:deptdr=""
    ....q:'$d(^DHCCAUNITDEPTS(0,"Unit",unitrid,deptdr))
    ....s ^temp($j,locdr,deptdr,unitrid)=$g(^temp($j,locdr,deptdr,unitrid))
    
    s loc=0 f  s loc=$o(^temp($j,loc)) q:loc=""  d
    .s dept=0 f  s dept=$o(^temp($j,loc,dept)) q:dept=""  d
    ..f  s RowIdIncome=$o(^DHCCAINCOMEDATAS(0,"IntervalFdeptdr",loc,dept,RowIdIncome)) q:RowIdIncome=""  d
    ...s Income1=$p(^DHCCAINCOMEDATAS(RowIdIncome),"^",7)
    ...s ^temp($j,loc,"Income")=$g(^temp($j,loc,"Income"))+Income1
    
    ..s unit=0 f  s unit=$o(^temp($j,loc,dept,unit)) q:unit=""  d
    ...f  s RowIdCost=$o(^DHCCACOSTDISTSETS(unit,"IntIDFlag",loc,dept,"leaf",RowIdCost)) q:RowIdCost=""   d
    ....s Cost1=$p(^DHCCACOSTDISTSETS(unit,"CostResultSum",RowIdCost),"^",7) //成本金额
   	....s ^temp($j,loc,"Cost")=$g(^temp($j,loc,"Cost"))+Cost1

    .s incomefee=$g(^temp($j,loc,"Income")) 
    .s costfee=$g(^temp($j,loc,"Cost")) 
    .s amt=incomefee-costfee
 	.d OutputRow38
    
    k ^temp($j)
 	q $$$OK
OutputRow38
	s desca=$p(^DHCCAACCOUNTMONTHS(loc),"^",2)
    s mon=+$p(desca,"-",2)_""_"月"
  	s Data=$lb($g(monthname),$g(mon),typename,loc,$fn(incomefee,"",2),$fn(costfee,"",2),$fn(amt,"",2),$g(monthorder))
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetFtQsfx1DkFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetFtQsfx1DkExecute, SqlProc ]
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

ClassMethod GetFtQsfx1DkClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetFtQsfx1DkExecute, SqlProc ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetFtQsfx1Dk(stdate As %String, type As %String, user As %String) As %Query(ROWSPEC = "monthname:%String,mon:%String,typename:%String,loc:%Integer,incomefee:%Float,costfee:%Float,amt:%Float,monthorder:%Integer") [ SqlProc ]
{
}

//大科用药占比：d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","GetincomedataDeptYaoDk","1","1","demo")

ClassMethod GetincomedataDeptYaoDkExecute(ByRef qHandle As %Binary, stdate As %String, type As %String, user As %String) As %Status [ SqlProc ]
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	k ^temp($j)
	s RowIdu="",unitrid="",RowIdDept=""
	s sumfee="",totalFee="",totalyaoFee="",totalzsr=""
	q:user="" $$$OK
    q:type="" $$$OK
	q:stdate="" $$$OK
	
  	i $d(^DHCCAROLES(type)) s typename=$p(^DHCCAROLES(type),"^",3)
 	s RowId="",RowId1="",RowIdIncome=""
 	s RowIdq="",RowIdq1="",RowIdqy="",RowIdqy1=""
    
    i $d(^DHCCAACCOUNTMONTHS(stdate)) d
	.s month=$p(^DHCCAACCOUNTMONTHS(stdate),"^",2)
    .s monthQ=$p(month,"-",1)
    .s monthname=monthQ_""_"年度"
 
    f  s RowId=$o(^DHCCAACCOUNTMONTHS(RowId))  q:RowId=""  d
    .s desc=$p(^DHCCAACCOUNTMONTHS(RowId),"^",2)
    .s mon=+$p(desc,"-",2)_""_"月"
    .s desc1=$p(desc,"-",1)
    .q:desc1'=monthQ 
    .s ^temp($j,RowId)=$g(^temp($j,RowId))
    .s locdr=RowId
    .f  s RowIdu=$o(^DHCCAUSERS(0,"Loginname",user,RowIdu)) q:RowIdu=""  d
    ..s bz=$p(^DHCCAUSERS(RowIdu),"^",5)  //取集团医院ID 1总部,2二部,3三部
    ..f  s unitrid=$o(^DHCCAUNITDEPTS(0,"Unit",unitrid))  q:unitrid=""  d
    ...q:$F(","_bz_",",","_unitrid_",")=0
    ...f  s RowIdDept=$o(^DHCCAROLES(type,"RDepts",RowIdDept)) q:RowIdDept=""  d
    ....q:RowIdDept=0
    ....s deptdr=$P(^DHCCAROLES(type,"RDepts",RowIdDept),"^",2) q:deptdr=""
    ....q:'$d(^DHCCAUNITDEPTS(0,"Unit",unitrid,deptdr))
    ....s ^temp($j,locdr,deptdr)=$g(^temp($j,locdr,deptdr))
   
 	s loc=0 f  s loc=$o(^temp($j,loc)) q:loc=""  d
    .s dept=0 f  s dept=$o(^temp($j,loc,dept)) q:dept=""  d
    ..f  s RowIdIncome=$o(^DHCCAINCOMEDATAS(0,"IntervalFdeptdr",loc,dept,RowIdIncome)) q:RowIdIncome=""  d
    ...s totalFee=$p(^DHCCAINCOMEDATAS(RowIdIncome),"^",7) 
    ...s ^temp($j,"zsr",loc)=$g(^temp($j,"zsr",loc))+totalFee
    
    ..f  s RowIdq=$o(^DHCCAACCOUNTMONTHS(0,"Period",loc,4,RowIdq)) q:RowIdq=""  d
 	...s monthDrq=$p(^DHCCAACCOUNTMONTHS(loc,"Periods",RowIdq),"^",2)
 	...f  s RowIdq1=$o(^DHCCAINCOMEDATAS(0,"IntervalFdeptdr",monthDrq,dept,RowIdq1)) q:RowIdq1=""  d
    ....s sumamtq1=$p(^DHCCAINCOMEDATAS(RowIdq1),"^",7) //去年同期收入
    ....s ^temp($j,"qnzsr",loc)=$g(^temp($j,"qnzsr",loc))+sumamtq1
      
    ..f  s RowId1=$o(^DHCCAINCOMEDATAS(0,"IntervalFdeptdr",loc,dept,RowId1)) q:RowId1=""  d
    ...s itemDr=$p(^DHCCAINCOMEDATAS(RowId1),"^",6) q:itemDr=""
    ...q:'$d(^DHCCADATALEVELSETS(0,"Item","7",itemDr))
    ...s yaofee=$p(^DHCCAINCOMEDATAS(RowId1),"^",7) 
    ...s ^temp($j,"yp",loc)=$g(^temp($j,"yp",loc))+yaofee
    
    ..f  s RowIdqy=$o(^DHCCAACCOUNTMONTHS(0,"Period",loc,4,RowIdqy)) q:RowIdqy=""  d
 	...s monthDrq1=$p(^DHCCAACCOUNTMONTHS(loc,"Periods",RowIdqy),"^",2)
  	...f  s RowIdqy1=$o(^DHCCAINCOMEDATAS(0,"IntervalFdeptdr",monthDrq1,dept,RowIdqy1)) q:RowIdqy1=""  d
    ....s itemDry=$p(^DHCCAINCOMEDATAS(RowIdqy1),"^",6) q:itemDry=""
    ....q:'$d(^DHCCADATALEVELSETS(0,"Item","7",itemDry))
    ....s yaofeey=$p(^DHCCAINCOMEDATAS(RowIdqy1),"^",7) //去年同期药品收入
    ....s ^temp($j,"qnyp",loc)=$g(^temp($j,"qnyp",loc))+yaofeey
    
    
    s locdrs=0 f  s locdrs=$o(^temp($j,"zsr",locdrs)) q:locdrs=""  d
    .s outdata=$g(^temp($j,"zsr",locdrs))_"^"_$g(^temp($j,"yp",locdrs))_"^"_$g(^temp($j,"qnzsr",locdrs))_"^"_$g(^temp($j,"qnyp",locdrs))
    
    .s zsr=$p(outdata,"^",1)
    .s yao=$p(outdata,"^",2)
    .s zsrq=$p(outdata,"^",3)
    .s yaoq=$p(outdata,"^",4)
    .i zsr'=0 s yaobl=yao/zsr  e  s yaobl=0
    .s yaoz=yao-yaoq  
    .s ylsz=zsr-yao-zsrq+yaoq
    .s ylqn=zsrq-yaoq
    .i yaoq'="" s ypzf=yaoz/$g(yaoq),ylzf=ylsz/$g(ylqn)
    .e  s ypzf=0,ylzf=0
   	.d OutputRow39
  
 	;输出合计
 	;d OutputRowWorkSum
 	k ^temp($j)
 	q $$$OK
OutputRow39
	
 	q:'$d(^DHCCAACCOUNTMONTHS(locdrs))
    s descy=$p(^DHCCAACCOUNTMONTHS(locdrs),"^",2)
    s monthm=+$p(descy,"-",2)
    s mony=+$p(descy,"-",2)_""_"月"
 	
 	s Data=$lb($g(monthname),$g(locdrs),$g(mony),$fn($g(zsr),"",2),$fn($g(yao),"",2),$g(yaobl),$g(ypzf),$g(ylzf),$fn($g(zsrq),"",2),$fn($g(yaoq),"",2),$g(monthm),$g(typename))
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
	
OutputRowWorkSum39
    s Data=$lb("total",$g(totalFee))
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
 //ResetVariables
 //	 q
}

ClassMethod GetincomedataDeptYaoDkFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetincomedataDeptYaoDkExecute, SqlProc ]
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

ClassMethod GetincomedataDeptYaoDkClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetincomedataDeptYaoDkExecute, SqlProc ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetincomedataDeptYaoDk(stdate As %String, type As %String, user As %String) As %Query(ROWSPEC = "monthname:%String,locdrs:%Integer,mony:%String,zsr:%Float,yao:%Float,yaobl:%Float,ypzf:%Float,ylzf:%Float,zsrq:%Float,yaoq:%Float,monthm:%Integer,typename:%String") [ SqlProc ]
{
}

//大科直接间接成本查询

//d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","GetZjJjDeptCostDk","27","27","1","025561")

ClassMethod GetZjJjDeptCostDkExecute(ByRef qHandle As %Binary, stdate As %Integer, endate As %Integer, type As %String, user As %String) As %Status [ SqlProc ]
{
                            
	Set repid=$I(^CacheTemp) 
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
 	
	q:stdate="" $$$OK
	q:endate="" $$$OK
	q:type="" $$$OK
	q:user="" $$$OK
	
	s RowId="",RowId1="",RowId2="",dep=""
	s RowIdu="",unitrid="",RowIdDept=""
    k ^temp($j) 
    
    i $d(^DHCCAROLES(type)) s typename=$p(^DHCCAROLES(type),"^",3)
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
    
        
    s i1="",i=""
    f i1=stdatecode:1:endatecode d
    .f  s i=$o(^DHCCAACCOUNTMONTHS(0,"Code",i1,i)) q:i=""  d
    
    ..f  s RowIdu=$o(^DHCCAUSERS(0,"Loginname",user,RowIdu)) q:RowIdu=""  d
    ...s bz=$p(^DHCCAUSERS(RowIdu),"^",5)  //取集团医院ID 1总部,2二部,3三部
    ...f  s unitrid=$o(^DHCCAUNITDEPTS(0,"Unit",unitrid))  q:unitrid=""  d
    ....q:$F(","_bz_",",","_unitrid_",")=0
    ....f  s RowIdDept=$o(^DHCCAROLES(type,"RDepts",RowIdDept)) q:RowIdDept=""  d
    .....q:RowIdDept=0
    .....s deptdr=$P(^DHCCAROLES(type,"RDepts",RowIdDept),"^",2) q:deptdr=""
    .....q:'$d(^DHCCAUNITDEPTS(0,"Unit",unitrid,deptdr))
    .....s ^temp($j,i,deptdr,unitrid)=$g(^temp($j,i,deptdr,unitrid))
    
    s loc=0 f  s loc=$o(^temp($j,loc)) q:loc=""  d
    .s dept=0 f  s dept=$o(^temp($j,loc,dept)) q:dept=""  d 
    ..s unit=0 f  s unit=$o(^temp($j,loc,dept,unit)) q:unit=""  d 
    ...f  s RowId=$o(^DHCCACOSTDISTSETS(0,"DIntDistdept",unit,loc,dept,RowId)) q:RowId=""  d
    ....;s distdept=$p(^DHCCACOSTDISTSETS(unit,"CostResultData",RowId),"^",3)
    ....s distdept=dept
    ....s data=$p(^DHCCACOSTDISTSETS(unit,"CostResultData",RowId),"^",4)
    ....s distflag=$p(^DHCCACOSTDISTSETS(unit,"CostResultData",RowId),"^",6) q:distflag'="self"
    ....s datafee=$p(^DHCCACOSTDISTSETS(unit,"CostResultData",RowId),"^",5)
    ....s depted=$p(^DHCCACOSTDISTSETS(unit,"CostResultData",RowId),"^",2)  
    ....f  s RowId1=$o(^DHCCADATALEVELSETS(RowId1))  q:RowId1=""  d
    .....s parent=$p(^DHCCADATALEVELSETS(RowId1),"^",7) q:parent'=5  //新会计成本
    .....q:'$d(^DHCCADATALEVELSETS(0,"Item",RowId1,data))
    .....s ^temp($j,"depted",distflag,RowId1,data)=$g(^temp($j,"depted",distflag,RowId1,data))+datafee
       
    s costflag=0 f  s costflag=$o(^temp($j,"depted",costflag)) q:costflag=""  d
    .s costdatafc=0 f  s costdatafc=$o(^temp($j,"depted",costflag,costdatafc)) q:costdatafc=""  d
    ..s costitem=0 f  s costitem=$o(^temp($j,"depted",costflag,costdatafc,costitem)) q:costitem=""  d
    ...s costsum=$g(^temp($j,"depted",costflag,costdatafc,costitem))
    ...s costfenc=""
    ...;s costfencw=""
    ...;w !,costdept_"^"_costdatafc_"^"_costitem_"^"_costflag_"^"_costsum
    ...d OutputRow40
    
    s RowIdB="",RowIdB1="",RowIdB2="",ward="",RowIdBD=""
    s RowIdu1="",unitrid1="",RowIdDept1=""
    s i1="",i=""
    f i1=stdatecode:1:endatecode d
    .f  s i=$o(^DHCCAACCOUNTMONTHS(0,"Code",i1,i)) q:i=""  d
    ..f  s RowIdu1=$o(^DHCCAUSERS(0,"Loginname",user,RowIdu1)) q:RowIdu1=""  d
    ...s bz=$p(^DHCCAUSERS(RowIdu1),"^",5)  //取集团医院ID 1总部,2二部,3三部
    ...f  s unitrid1=$o(^DHCCAUNITDEPTS(0,"Unit",unitrid1))  q:unitrid1=""  d
    ....q:$F(","_bz_",",","_unitrid1_",")=0
    ....f  s RowIdDept1=$o(^DHCCAROLES(type,"RDepts",RowIdDept1)) q:RowIdDept1=""  d
    .....q:RowIdDept1=0
    .....s dept=$P(^DHCCAROLES(type,"RDepts",RowIdDept1),"^",2) q:dept=""
    .....q:'$d(^DHCCAUNITDEPTS(0,"Unit",unitrid1,dept))
    .....s ^temp($j,i,dept,unitrid1)=$g(^temp($j,i,dept,unitrid1))
    
    
    s loc=0 f  s loc=$o(^temp($j,loc)) q:loc=""  d
    .s dept=0 f  s dept=$o(^temp($j,loc,dept)) q:dept=""  d 
    ..s unit=0 f  s unit=$o(^temp($j,loc,dept,unit)) q:unit=""  d 
    ...;i unit=1 s setid=1
    ...;i unit=2 s setid=7
    ...;i unit=3 s setid=8
    ...f  s RowIdB=$o(^DHCCACOSTDISTSETS(0,"DIntDistdept",unit,loc,dept,RowIdB)) q:RowIdB=""  d
    ....;s distdept=$p(^DHCCACOSTDISTSETS(unitrid1,"CostResultData",RowIdB),"^",3) 
    ....s distdept=dept
    ....s data=$p(^DHCCACOSTDISTSETS(unit,"CostResultData",RowIdB),"^",4)
    ....s distflag=$p(^DHCCACOSTDISTSETS(unit,"CostResultData",RowIdB),"^",6)
    ....s datafee=$p(^DHCCACOSTDISTSETS(unit,"CostResultData",RowIdB),"^",5)
    ....s depted=$p(^DHCCACOSTDISTSETS(unit,"CostResultData",RowIdB),"^",2) q:depted=""
    ....f  s RowIdB2=$o(^DHCCADATALEVELSETS(RowIdB2))  q:RowIdB2=""  d
    .....s parent=$p(^DHCCADATALEVELSETS(RowIdB2),"^",7) q:parent'=5  //新会计成本
    .....q:'$d(^DHCCADATALEVELSETS(0,"Item",RowIdB2,data))
    .....f  s RowIdB1=$o(^DHCCADEPTLEVELSETS(0,"Parent",1,RowIdB1))  q:RowIdB1=""  d
    ......;q:'$d(^DHCCADEPTLEVELSETS(0,"Dept",RowIdB1,depted))
    ......;i (RowIdB1=2)!(RowIdB1=9)!(RowIdB1=14) s RowIdBf=2
    ......;i (RowIdB1=3)!(RowIdB1=10)!(RowIdB1=15) s RowIdBf=3
    ......;i (RowIdB1=4)!(RowIdB1=11)!(RowIdB1=16) s RowIdBf=4
    ......;i (RowIdB1=5)!(RowIdB1=12)!(RowIdB1=17) s RowIdBf=5
    ......f  s dep=$o(^DHCCADEPTLEVELSETS(0,"Dept",RowIdB1,depted,dep))  q:dep=""  d
    .......s ^temp($j,"depted",distflag,RowIdB2,data,RowIdB1)=$g(^temp($j,"depted",distflag,RowIdB2,data,RowIdB1))+datafee
   
    s costflag=0 f  s costflag=$o(^temp($j,"depted",costflag)) q:costflag=""  d
    .s costdatafc=0 f  s costdatafc=$o(^temp($j,"depted",costflag,costdatafc)) q:costdatafc=""  d
    ..s costitem=0 f  s costitem=$o(^temp($j,"depted",costflag,costdatafc,costitem)) q:costitem=""  d
    ...s costfenc=0 f  s costfenc=$o(^temp($j,"depted",costflag,costdatafc,costitem,costfenc))  q:costfenc=""  d
    ....s costsum=$g(^temp($j,"depted",costflag,costdatafc,costitem,costfenc))
    ....;s costfencw=""
    ....;w !,costdept_"^"_costitem_"^"_costflag_"^"_costfenc_"^"_costsum
    ....d OutputRow40
    
    k ^temp($j)    
   q $$$OK
	
OutputRow40
    s datafcname=$p(^DHCCADATALEVELSETS(costdatafc),"^",2)  
    i $d(^DHCCAALLDATAITEMS(costitem)) s ItemDesc=$P(^DHCCAALLDATAITEMS(costitem),"^",3)
       
    i costfenc="" s costfencname="直接成本"
	i costfenc=2 s costfencname="公用分摊"
	i costfenc=3 s costfencname="管理分摊"
	i costfenc=4 s costfencname="医辅分摊"
	i costfenc=5 s costfencname="医技分摊"
	
	s Data=$lb(monthname1,monthname2,costdatafc,datafcname,costitem,ItemDesc,type,typename,costflag,costfenc,costfencname,$fn(costsum,"",2))
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetZjJjDeptCostDkFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetZjJjDeptCostDkExecute, SqlProc ]
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

ClassMethod GetZjJjDeptCostDkClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetZjJjDeptCostDkExecute, SqlProc ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetZjJjDeptCostDk(stdate As %Integer, endate As %Integer, type As %String, user As %String) As %Query(ROWSPEC = "monthname1:%String,monthname2:%String,costdatafc:%Integer,datafcname:%String,costitem:%Integer,ItemDesc:%String,type:%Integer,typename:%String,costflag:%String,costfenc:%String,costfencname:%String,costsum:%Float") [ SqlProc ]
{
}

//大科收入趋势

//d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","GetincomedataDkMonth1","13","2","demo")	

ClassMethod GetincomedataDkMonth1Execute(ByRef qHandle As %Binary, stdate As %Integer, type As %String, user As %String) As %Status [ SqlProc ]
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
   
    q:stdate="" $$$OK
    q:type="" $$$OK
    q:user="" $$$OK
	s RowId="",RowIdIncome="",Income="",RowIdu="",unitrid="",RowIdDept=""
	s RowIdData="",RowIdDataZc=""
	k ^temp($j)
	
	i $d(^DHCCAROLES(type)) s typename=$p(^DHCCAROLES(type),"^",3)
	i $d(^DHCCAACCOUNTMONTHS(stdate)) d
	.s month=$p(^DHCCAACCOUNTMONTHS(stdate),"^",2)
    .s monthQ=$p(month,"-",1)
    .s monthname=monthQ_""_"年度"
    
    f  s RowId=$o(^DHCCAACCOUNTMONTHS(RowId))  q:RowId=""  d
    .s desc=$p(^DHCCAACCOUNTMONTHS(RowId),"^",2)
    .s mon=+$p(desc,"-",2)_""_"月"
    .s desc1=$p(desc,"-",1)
    .q:desc1'=monthQ
    
    .f  s RowIdu=$o(^DHCCAUSERS(0,"Loginname",user,RowIdu)) q:RowIdu=""  d
    ..s bz=$p(^DHCCAUSERS(RowIdu),"^",5)  //取集团医院ID 1总部,2二部,3三部
    ..f  s unitrid=$o(^DHCCAUNITDEPTS(0,"Unit",unitrid))  q:unitrid=""  d
    ...q:$F(","_bz_",",","_unitrid_",")=0
    ...f  s RowIdDept=$o(^DHCCAROLES(type,"RDepts",RowIdDept)) q:RowIdDept=""  d
    ....q:RowIdDept=0
    ....s dept=$P(^DHCCAROLES(type,"RDepts",RowIdDept),"^",2) q:dept=""
    ....q:'$d(^DHCCAUNITDEPTS(0,"Unit",unitrid,dept))
    ....s ^temp($j,RowId,dept)=$g(^temp($j,RowId,dept))
          
    ....f  s RowIdIncome=$o(^DHCCAINCOMEDATAS(0,"IntervalFdeptdr",RowId,dept,RowIdIncome)) q:RowIdIncome=""  d
    .....s itemDr=$p(^DHCCAINCOMEDATAS(RowIdIncome),"^",6)
    .....s Income1=$p(^DHCCAINCOMEDATAS(RowIdIncome),"^",7)
    .....s ^temp($j,"Income",RowId,itemDr)=$g(^temp($j,"Income",RowId,itemDr))+Income1

    f  s RowIdData=$o(^DHCCADATALEVELSETS(RowIdData)) q:RowIdData=""  d
    .s dataname=$p(^DHCCADATALEVELSETS(RowIdData),"^",2)
    .s parent=$p(^DHCCADATALEVELSETS(RowIdData),"^",7) 
    .q:parent'=3  //收入分类
    .f  s RowIdDataZc=$o(^DHCCADATALEVELSETS(RowIdData,"Items",RowIdDataZc)) q:RowIdDataZc=""  d
    ..q:RowIdDataZc="0"
    ..s item1=$p(^DHCCADATALEVELSETS(RowIdData,"Items",RowIdDataZc),"^",3)
    ..s itemname1=$P(^DHCCAALLDATAITEMS(item1),"^",3)
    ..s ^temp($j,"item",item1)=RowIdData

    s locdr=0 f  s locdr=$o(^temp($j,"Income",locdr)) q:locdr=""  d
    .s descy=$p(^DHCCAACCOUNTMONTHS(locdr),"^",2)
    .s mony=+$p(descy,"-",2) ;_""_"月"
    
    .s item=0 f  s item=$o(^temp($j,"Income",locdr,item)) q:item=""  d
    ..s itemrowid=$g(^temp($j,"item",item)) q:itemrowid=""
    ..s itemname1=$p(^DHCCADATALEVELSETS(itemrowid),"^",2)
    ..i $d(^DHCCAALLDATAITEMS(item)) s itemname=$P(^DHCCAALLDATAITEMS(item),"^",3)
 	..s incomefee=$g(^temp($j,"Income",locdr,item)) 
    ..d OutputRow41
 	
 	;输出合计
 	;d OutputRowWorkSum
 	k ^temp($j)
 	q $$$OK
OutputRow41
	;
 	s Data=$lb(typename,monthname,locdr,mony,itemrowid,itemname1,item,itemname,$fn($g(incomefee),"",2))
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
	
OutputRowWorkSum41
    s Data=$lb("total",$g(totalFee))
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
 //ResetVariables
 //	 q
}

ClassMethod GetincomedataDkMonth1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetincomedataDkMonth1Execute, SqlProc ]
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

ClassMethod GetincomedataDkMonth1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetincomedataDkMonth1Execute, SqlProc ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetincomedataDkMonth1(stdate As %Integer, type As %String, user As %String) As %Query(ROWSPEC = "typename:%String,monthname:%String,locdr:%Integer,mony:%Integer,itemrowid:%Integer,itemname1:%String,item:%Integer,itemname:%String,sumfee:%Float") [ SqlProc ]
{
}

//新会计制度-科室直接间接成本查询

//d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","GetZjJjCostXHJ","1","1","1","demo")

ClassMethod GetZjJjCostXHJExecute(ByRef qHandle As %Binary, stdate As %String, endate As %String, dept As %Text, user As %String) As %Status [ SqlProc ]
{
                            
	Set repid=$I(^CacheTemp) 
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
 	
 	q:stdate="" $$$OK
	q:endate="" $$$OK
	q:dept="" $$$OK
	q:user="" $$$OK
	s RowId="",RowId1="",RowId2="",dep="",RowIdu="",unitrid=""
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
   
    ..s i1="",i=""
    ..f i1=stdatecode:1:endatecode d
    ...f  s i=$o(^DHCCAACCOUNTMONTHS(0,"Code",i1,i)) q:i=""  d
    ....f  s RowId=$o(^DHCCACOSTDISTSETS(0,"DInterval",unitrid,i,RowId)) q:RowId=""  d
    .....s distdept=$p($g(^DHCCACOSTDISTSETS(unitrid,"CostResultData",RowId)),"^",3)
    .....q:$F(","_dept_",",","_distdept_",")=0
   
    .....s data=$p(^DHCCACOSTDISTSETS(unitrid,"CostResultData",RowId),"^",4)
    .....s distflag=$p(^DHCCACOSTDISTSETS(unitrid,"CostResultData",RowId),"^",6)  q:distflag'="self"
    .....s datafee=$p(^DHCCACOSTDISTSETS(unitrid,"CostResultData",RowId),"^",5)
    .....s depted=$p(^DHCCACOSTDISTSETS(unitrid,"CostResultData",RowId),"^",2)  
    .....f  s RowId1=$o(^DHCCADATALEVELSETS(RowId1))  q:RowId1=""  d
    ......s parent=$p(^DHCCADATALEVELSETS(RowId1),"^",7) q:parent'=25   //新会计制度
    ......q:'$d(^DHCCADATALEVELSETS(0,"Item",RowId1,data))
    ......i depted="" s ^temp($j,"depted",distdept,distflag,RowId1)=$g(^temp($j,"depted",distdept,distflag,RowId1))+datafee
     
    s costdept=0 f  s costdept=$o(^temp($j,"depted",costdept)) q:costdept=""  d
    .s costflag=0 f  s costflag=$o(^temp($j,"depted",costdept,costflag)) q:costflag=""  d
    ..s costdatafc=0 f  s costdatafc=$o(^temp($j,"depted",costdept,costflag,costdatafc)) q:costdatafc=""  d
    ...s costsum=$g(^temp($j,"depted",costdept,costflag,costdatafc))
    ...s costfenc=""
    ...s costfencw=""
    ...;w !,costdept_"^"_costdatafc_"^"_costitem_"^"_costflag_"^"_costsum
    ...d OutputRow42
   
    s RowIdB="",RowIdB1="",RowIdB2="",ward="",RowIdBD=""
    s RowIdu1="",unitrid1=""
    f  s RowIdu1=$o(^DHCCAUSERS(0,"Loginname",user,RowIdu1)) q:RowIdu1=""  d
    .s bz=$p(^DHCCAUSERS(RowIdu1),"^",5)  //取集团医院ID 1总部,2二部,3三部
    .f  s unitrid1=$o(^DHCCAUNITDEPTS(0,"Unit",unitrid1))  q:unitrid1=""  d
    ..q:$F(","_bz_",",","_unitrid1_",")=0
    ..i unitrid1=1 s setid=1
    ..i unitrid1=2 s setid=7
    ..i unitrid1=3 s setid=8
    ..s i1="",i=""
    ..f i1=stdatecode:1:endatecode d
    ...f  s i=$o(^DHCCAACCOUNTMONTHS(0,"Code",i1,i)) q:i=""  d
    ....f  s RowIdB=$o(^DHCCACOSTDISTSETS(0,"DInterval",unitrid1,i,RowIdB)) q:RowIdB=""  d
    .....s distdept=$p($g(^DHCCACOSTDISTSETS(unitrid1,"CostResultData",RowIdB)),"^",3) 
    .....q:$F(","_dept_",",","_distdept_",")=0
    .....s data=$p(^DHCCACOSTDISTSETS(unitrid1,"CostResultData",RowIdB),"^",4)
    .....s distflag=$p(^DHCCACOSTDISTSETS(unitrid1,"CostResultData",RowIdB),"^",6)
    .....s datafee=$p(^DHCCACOSTDISTSETS(unitrid1,"CostResultData",RowIdB),"^",5)
    .....s depted=$p(^DHCCACOSTDISTSETS(unitrid1,"CostResultData",RowIdB),"^",2) q:depted=""
    
    .....f  s RowIdB2=$o(^DHCCADATALEVELSETS(RowIdB2))  q:RowIdB2=""  d
    ......s parent=$p(^DHCCADATALEVELSETS(RowIdB2),"^",7) q:parent'=25   //新会计制度
    ......q:'$d(^DHCCADATALEVELSETS(0,"Item",RowIdB2,data))
    ......f  s RowIdB1=$o(^DHCCADEPTLEVELSETS(0,"Parent",setid,RowIdB1))  q:RowIdB1=""  d
    .......f  s dep=$o(^DHCCADEPTLEVELSETS(0,"Dept",RowIdB1,depted,dep))  q:dep=""  d
    ........s ^temp($j,"depted",distdept,distflag,RowIdB2,RowIdB1)=$g(^temp($j,"depted",distdept,distflag,RowIdB2,RowIdB1))+datafee
             
    s costdept=0 f  s costdept=$o(^temp($j,"depted",costdept)) q:costdept=""  d
    .s costflag=0 f  s costflag=$o(^temp($j,"depted",costdept,costflag)) q:costflag=""  d
    ..s costdatafc=0 f  s costdatafc=$o(^temp($j,"depted",costdept,costflag,costdatafc)) q:costdatafc=""  d
    ...s costfenc=0 f  s costfenc=$o(^temp($j,"depted",costdept,costflag,costdatafc,costfenc))  q:costfenc=""  d
    ....s costsum=$g(^temp($j,"depted",costdept,costflag,costdatafc,costfenc))
    ....s costfencw=""
    ....;w !,costdept_"^"_costitem_"^"_costflag_"^"_costfenc_"^"_costsum
    ....d OutputRow42
    
    k ^temp($j)       
   q $$$OK
	
OutputRow42
    s datafcname=$p(^DHCCADATALEVELSETS(costdatafc),"^",2)  
    ;i $d(^DHCCAALLDATAITEMS(costitem)) s ItemDesc=$P(^DHCCAALLDATAITEMS(costitem),"^",3)
    s deptname=$P(^DHCCAUNITDEPTS(costdept),"^",2)
    
    i costfenc="" s costfencname="直接成本"
    i costfenc'="" s costfencname="间接成本"
	;i costfenc=2 s costfencname="公用分摊"
	;i costfenc=3 s costfencname="管理分摊"
	;i costfenc=4 s costfencname="医辅分摊"
	;i costfenc=5 s costfencname="医技分摊"
	
	;s Data=$lb(monthname1,monthname2,costdatafc,datafcname,costdept,deptname,costflag,costfencname,$fn(costsum,"",2))
    s Data=$lb(monthname1,monthname2,costdatafc,datafcname,costdept,deptname,costflag,costfencname,costsum)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetZjJjCostXHJFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetZjJjCostXHJExecute, SqlProc ]
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

ClassMethod GetZjJjCostXHJClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetZjJjCostXHJExecute, SqlProc ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetZjJjCostXHJ(stdate As %String, endate As %String, dept As %Text, user As %String) As %Query(ROWSPEC = "monthname1:%String,monthname2:%String,costdatafc:%Integer,datafcname:%String,costdept:%Integer,deptname:%String,costflag:%String,costfencname:%String,costsum:%Float") [ SqlProc ]
{
}

//新会计制度-科室直接成本表

//d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","GetZjCostXHJ","1","1","demo")

ClassMethod GetZjCostXHJExecute(ByRef qHandle As %Binary, stdate As %String, endate As %String, user As %String) As %Status [ SqlProc ]
{
                            
	Set repid=$I(^CacheTemp) 
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
 	
 	q:stdate="" $$$OK
	q:endate="" $$$OK
	q:user="" $$$OK
	s RowId="",RowId1="",RowId2="",dep="",RowIdu="",unitrid="",RowIdDE=""
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
    .s bz=$p(^DHCCAUSERS(RowIdu),"^",5)  //备注->  取集团医院ID 1总部,2二部,3三部
    .f  s unitrid=$o(^DHCCAUNITDEPTS(0,"Unit",unitrid))  q:unitrid=""  d
    ..q:$F(","_bz_",",","_unitrid_",")=0
    
    ..i unitrid=1 s setid=1
    ..i unitrid=2 s setid=7
    ..i unitrid=3 s setid=8
         
    ..s i1="",i=""
    ..f i1=stdatecode:1:endatecode d
    ...f  s i=$o(^DHCCAACCOUNTMONTHS(0,"Code",i1,i)) q:i=""  d
    ....f  s RowId=$o(^DHCCACOSTDISTSETS(0,"DInterval",unitrid,i,RowId)) q:RowId=""  d
    .....s distdept=$p($g(^DHCCACOSTDISTSETS(unitrid,"CostResultData",RowId)),"^",3)
  
    .....f  s RowIdDE=$o(^DHCCADEPTLEVELSETS(RowIdDE)) q:RowIdDE=""  d
    ......s parentd=$p(^DHCCADEPTLEVELSETS(RowIdDE),"^",7)  q:parentd'=setid
    ......q:'$d(^DHCCADEPTLEVELSETS(0,"Dept",RowIdDE,distdept))
    
    ......s data=$p(^DHCCACOSTDISTSETS(unitrid,"CostResultData",RowId),"^",4)
    ......s distflag=$p(^DHCCACOSTDISTSETS(unitrid,"CostResultData",RowId),"^",6)  q:distflag'="self"
    ......s datafee=$p(^DHCCACOSTDISTSETS(unitrid,"CostResultData",RowId),"^",5)
    ......s depted=$p(^DHCCACOSTDISTSETS(unitrid,"CostResultData",RowId),"^",2)  
    
    ......f  s RowId1=$o(^DHCCADATALEVELSETS(RowId1))  q:RowId1=""  d
    .......s parent=$p(^DHCCADATALEVELSETS(RowId1),"^",7) q:parent'=25   //新会计制度  
    .......q:'$d(^DHCCADATALEVELSETS(0,"Item",RowId1,data))
    .......i depted="" s ^temp($j,"depted",RowIdDE,distdept,RowId1)=$g(^temp($j,"depted",RowIdDE,distdept,RowId1))+datafee
    .......; w !, ^temp($j,"depted",RowIdDE,distdept,RowId1)
    s deptfc=0 f  s deptfc=$o(^temp($j,"depted",deptfc)) q:deptfc=""  d
    .s costdept=0 f  s costdept=$o(^temp($j,"depted",deptfc,costdept)) q:costdept=""  d
    ..s costdatafc=0 f  s costdatafc=$o(^temp($j,"depted",deptfc,costdept,costdatafc)) q:costdatafc=""  d
    ...s costsum=$g(^temp($j,"depted",deptfc,costdept,costdatafc))
    ...d OutputRow43
   
   k ^temp($j)
   q $$$OK
	
OutputRow43
    s datafcname=$p(^DHCCADATALEVELSETS(costdatafc),"^",2)  
    s deptname=$P(^DHCCAUNITDEPTS(costdept),"^",2)
    s fcname=$p(^DHCCADEPTLEVELSETS(deptfc),"^",2) 
    
 	;s Data=$lb(monthname1,monthname2,costdatafc,datafcname,deptfc,fcname,costdept,deptname,$fn(costsum,"",2))
    s Data=$lb(monthname1,monthname2,costdatafc,datafcname,deptfc,fcname,costdept,deptname,costsum)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetZjCostXHJFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetZjCostXHJExecute, SqlProc ]
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

ClassMethod GetZjCostXHJClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetZjCostXHJExecute, SqlProc ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetZjCostXHJ(stdate As %String, endate As %String, user As %String) As %Query(ROWSPEC = "monthname1:%String,monthname2:%String,costdatafc:%String,datafcname:%String,deptfc:%String,fcname:%String,costdept:%String,deptname:%String,costsum:%Float") [ SqlProc ]
{
}

//新会计制度-临床科室全成本构成分析表

//d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","GetCostGcXhj","1","1","2,3","demo")

ClassMethod GetCostGcXhjExecute(ByRef qHandle As %Binary, stdate As %String, endate As %String, dept As %Text, user As %String) As %Status [ SqlProc ]
{
	Set repid=$I(^CacheTemp) 
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
 	
 	q:stdate="" $$$OK
	q:endate="" $$$OK
	q:dept="" $$$OK
	q:user="" $$$OK
	s RowId="",RowId1="",RowId2="",dep="",RowIdu="",unitrid="",RowIdDE="",RowIdIncome="",RowIdParaM=""
    s RowIdC=""
    k ^temp($j) 
    k ^temp1($j) 
       
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
    ....f  s RowId=$o(^DHCCACOSTDISTSETS(0,"DInterval",unitrid,i,RowId)) q:RowId=""  d
    .....s distdept=$p($g(^DHCCACOSTDISTSETS(unitrid,"CostResultData",RowId)),"^",3)
    .....q:$F(","_dept_",",","_distdept_",")=0
    .....f  s RowIdDE=$o(^DHCCADEPTLEVELSETS(RowIdDE)) q:RowIdDE=""  d
    ......s parentd=$p(^DHCCADEPTLEVELSETS(RowIdDE),"^",7)  q:parentd'=setid
    ......q:'$d(^DHCCADEPTLEVELSETS(0,"Dept",RowIdDE,distdept))
    ......s ^temp($j,distdept,unitrid)=$g(^temp($j,distdept,unitrid))
    
    ....s paraitem=0
    ....s locdr=0 f  s locdr=$o(^temp($j,locdr)) q:locdr=""  d
    .....f  s RowIdIncome=$o(^DHCCAINCOMEDATAS(0,"IntervalFdeptdr",i,locdr,RowIdIncome)) q:RowIdIncome=""  d
    ......s InComeDatafee=$p(^DHCCAINCOMEDATAS(RowIdIncome),"^",7)
    ......s ^temp1($j,locdr,"Income")=$g(^temp1($j,locdr,"Income"))+InComeDatafee //科室收入
    
    .....f  s RowIdParaM=$o(^DHCCAPARAMDATAS(0,"IntervalSereddep",i,locdr,RowIdParaM)) q:RowIdParaM=""  d
    ......s paraitem=$p(^DHCCAPARAMDATAS(RowIdParaM),"^",4)  q:(paraitem'=141)&(paraitem'=142)
    ......s paraitem=paraitem_"para"
    ......s paradata=$p(^DHCCAPARAMDATAS(RowIdParaM),"^",11)
    ......s ^temp1($j,locdr,paraitem)=$g(^temp1($j,locdr,paraitem))+$g(paradata)   //门诊人次、床日数
    
    .....s unit=0 f  s unit=$o(^temp($j,locdr,unit)) q:unit=""  d   
    ......f  s RowIdC=$o(^DHCCACOSTDISTSETS(0,"DIntDistdept",unit,i,locdr,RowIdC)) q:RowIdC=""  d
    .......s data=$p(^DHCCACOSTDISTSETS(unit,"CostResultData",RowIdC),"^",4)
    .......s datafee=$p(^DHCCACOSTDISTSETS(unit,"CostResultData",RowIdC),"^",5)
    .......f  s RowId1=$o(^DHCCADATALEVELSETS(RowId1))  q:RowId1=""  d
    ........s parent=$p(^DHCCADATALEVELSETS(RowId1),"^",7) q:parent'=25   //新会计制度
    ........q:'$d(^DHCCADATALEVELSETS(0,"Item",RowId1,data))
    ........s ^temp1($j,locdr,RowId1)=$g(^temp1($j,locdr,RowId1))+datafee //科室成本
    
    s dep=0 f  s dep=$o(^temp1($j,dep)) q:dep=""  d  
    .s xm=0 f  s xm=$o(^temp1($j,dep,xm)) q:xm=""  d  
    ..s outdata=$g(^temp1($j,dep,xm))
    ..d OutputRow44
    
     k ^temp($j) 
     k ^temp1($j)
    q $$$OK
 
OutputRow44
	i ($d(^DHCCAUNITDEPTS(dep)))  s deptName=$p(^DHCCAUNITDEPTS(dep),"^",2)
  	i ($d(^DHCCADATALEVELSETS(xm)))  s dataname=$p(^DHCCADATALEVELSETS(xm),"^",2)  
  	e  i xm="Income" s dataname="科室收入" 
  	e  s dataname=$P(^DHCCAALLDATAITEMS(+xm),"^",3) 
  	
  	;s Data=$lb(monthname1,monthname2,dep,$g(deptName),xm,dataname,$fn($g(outdata),"",2))
    s Data=$lb(monthname1,monthname2,dep,$g(deptName),xm,dataname,$g(outdata))
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
}

ClassMethod GetCostGcXhjFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCostGcXhjExecute, SqlProc ]
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

ClassMethod GetCostGcXhjClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCostGcXhjExecute, SqlProc ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetCostGcXhj(stdate As %String, endate As %String, dept As %Text, user As %String) As %Query(ROWSPEC = "monthname1:%String,monthname2:%String,dep:%Integer,deptname:%String,xm:%String,dataname:%String,outdata:%Float") [ SqlProc ]
{
}

//收入、工作量等同比环比分析

//d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","GetHbTbFx","demo","2009,2010")

ClassMethod GetHbTbFxExecute(ByRef qHandle As %Binary, user As %String, syear As %String) As %Status [ SqlProc ]
{
	Set repid=$I(^CacheTemp) 
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
    
    q:user="" $$$OK
    q:syear="" $$$OK
	s RowId="",RowId1="",RowId2="",dep="",RowIdu="",unitrid="",RowIdDE="",RowIdIncome="",RowIdParaM=""
    s RowIdC="",RowIdI=""
    k ^temp($j)
    k ^tempy($j)
    
    f  s RowIdI=$o(^DHCCAACCOUNTMONTHS(RowIdI))  q:RowIdI=""  d
    .s desc=$p(^DHCCAACCOUNTMONTHS(RowIdI),"^",2)
    .s year=$p(desc,"-",1)
    .q:$F(","_syear_",",","_year_",")=0 
    .f  s RowIdu=$o(^DHCCAUSERS(0,"Loginname",user,RowIdu)) q:RowIdu=""  d
    ..s bz=$p(^DHCCAUSERS(RowIdu),"^",5)  //取集团医院ID 1总部,2二部,3三部
    ..f  s unitrid=$o(^DHCCAUNITDEPTS(0,"Unit",unitrid))  q:unitrid=""  d
    ...q:$F(","_bz_",",","_unitrid_",")=0
    ...i unitrid=1 s set=1
    ...i unitrid=2 s set=7
    ...i unitrid=3 s set=8
    ...s ^tempy($j,RowIdI,set)=RowIdI_"^"_set
        
    s int1=0 f  s int1=$o(^tempy($j,int1)) q:int1=""  d 
    .s xm1=0 f  s xm1=$o(^tempy($j,int1,xm1)) q:xm1=""  d  
    ..s RowIdint=$g(^tempy($j,int1,xm1))
    ..s i=$p(RowIdint,"^",1),setid=$p(RowIdint,"^",2)
    ..f  s RowId=$o(^DHCCAINCOMEDATAS(0,"Interval",i,RowId)) q:RowId=""  d
    ...s fdept=$p($g(^DHCCAINCOMEDATAS(RowId)),"^",11)
    ...q:fdept=""
    ...f  s RowIdDE=$o(^DHCCADEPTLEVELSETS(RowIdDE)) q:RowIdDE=""  d
    ....s parentd=$p(^DHCCADEPTLEVELSETS(RowIdDE),"^",7)  q:parentd'=setid
    ....q:'$d(^DHCCADEPTLEVELSETS(0,"Dept",RowIdDE,fdept))
    ...s inter=$p($g(^DHCCAINCOMEDATAS(RowId)),"^",1)
    ...s type=$p($g(^DHCCAINCOMEDATAS(RowId)),"^",3)
    ...s InComeDatafee=$p($g(^DHCCAINCOMEDATAS(RowId)),"^",7)
    ...s ^temp($j,inter,type)=$g(^temp($j,inter,type))+InComeDatafee

    ..f  s RowIdParaM=$o(^DHCCAPARAMDATAS(0,"Interval",i,RowIdParaM)) q:RowIdParaM=""  d
    ...s dept=$p(^DHCCAPARAMDATAS(RowIdParaM),"^",10)
    ...q:dept=""
    ...f  s RowIdDE=$o(^DHCCADEPTLEVELSETS(RowIdDE)) q:RowIdDE=""  d
    ....s parentd=$p(^DHCCADEPTLEVELSETS(RowIdDE),"^",7)  q:parentd'=setid
    ....q:'$d(^DHCCADEPTLEVELSETS(0,"Dept",RowIdDE,dept))
    ...s inter=$p(^DHCCAPARAMDATAS(RowIdParaM),"^",1)
    ...s item=$p(^DHCCAPARAMDATAS(RowIdParaM),"^",4) q:(item'=174)
    ...s paradata=$p(^DHCCAPARAMDATAS(RowIdParaM),"^",11)
    ...s ^temp($j,inter,item)=$g(^temp($j,inter,item))+$g(paradata)   //门诊人次
    
    s int=0 f  s int=$o(^temp($j,int)) q:int=""  d  
    .s xm=0 f  s xm=$o(^temp($j,int,xm)) q:xm=""  d  
    ..s outdata=$g(^temp($j,int,xm))
    ..d OutputRow45
    k ^temp($j)
    k ^tempy($j)
    q $$$OK
 
OutputRow45
	i ($d(^DHCCAACCOUNTMONTHS(int)))  s month=$p(^DHCCAACCOUNTMONTHS(int),"^",2)  ;s syear=$p(month,"-",1) s month=$p(month,"-",2)
  	i xm="I" s dataname="住院收入" 
  	i xm="O" s dataname="门诊收入" 
  	i xm="H" s dataname="体检收入" 
  	i xm="265" s dataname="门诊人次" 
  
  	
  	s Data=$lb(month,xm,dataname,$fn($g(outdata),"",2))
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
}

ClassMethod GetHbTbFxFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetHbTbFxExecute, SqlProc ]
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

ClassMethod GetHbTbFxClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetHbTbFxExecute, SqlProc ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetHbTbFx(user As %String, syear As %String) As %Query(ROWSPEC = "month:%String,xm:%String,dataname:%String,outdata:%Float") [ SqlProc ]
{
}

//本量利分析

//d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","GetBllfx","60","68","1") 

ClassMethod GetBllfxExecute(ByRef qHandle As %Binary, stdate As %String, endate As %String, type As %String) As %Status [ SqlProc ]
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
 	
	q:stdate="" $$$OK
	q:endate="" $$$OK
	q:type="" $$$OK
	k ^temp($j)
    
    s RowIdDept=""
    s incomefee="",costfee="",gzl="",gdcb1=0
    s gdcb1=0    
 
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
    
    f  s RowIdDept=$o(^DHCCAROLES(type,"RDepts",RowIdDept)) q:RowIdDept=""  d
    .q:RowIdDept=0
    .s deptdr=$P(^DHCCAROLES(type,"RDepts",RowIdDept),"^",2) q:deptdr=""
    .q:deptdr'=2
    .s ^temp($j,"dept",deptdr)=$g(^temp($j,"dept",deptdr))
     
    s locdr=0 f  s locdr=$o(^temp($j,"dept",locdr)) q:locdr=""  d
    .s i1="",i=""
    .f i1=stdatecode:1:endatecode d
    ..f  s i=$o(^DHCCAACCOUNTMONTHS(0,"Code",i1,i)) q:i=""  d
    ...s IncomeData(i)=$$Getincomedata^DHCCAFunction(i,locdr)
   	...s CostData(i)=$$GetCostResultSum^DHCCAFunction(i,locdr)
  	...s gdcbData(i)=$$GetCostResultGdcb^DHCCAFunction(i,locdr)
    ...s mzrc(i)=$$GetMzrcData^DHCCAFunction(i,locdr)
  	...s zycr(i)=$$GetZycrData^DHCCAFunction(i,locdr)
  	
    ...s ^temp($j,"Income",locdr,i)=$g(^temp($j,"Income",locdr,i))+IncomeData(i)
    ...s ^temp($j,"Cost",locdr,i)=$g(^temp($j,"Cost",locdr,i))+CostData(i)
    ...s ^temp($j,"gdcb",locdr,i)=$g(^temp($j,"gdcb",locdr,i))+gdcbData(i)
    ...s ^temp($j,"gzl",locdr,i)=$g(^temp($j,"gzl",locdr,i))+mzrc(i)+zycr(i)
   
    s locdr1=0 f  s locdr1=$o(^temp($j,"Income",locdr1)) q:locdr1=""  d
    .i ($d(^DHCCAUNITDEPTS(locdr1)))  s deptname=$p(^DHCCAUNITDEPTS(locdr1),"^",2)
    .s loc=0 f  s loc=$o(^temp($j,"Income",locdr1,loc)) q:loc=""  d
    ..s outdata=$g(^temp($j,"Income",locdr1,loc))_"^"_$g(^temp($j,"Cost",locdr1,loc))_"^"_$g(^temp($j,"gdcb",locdr1,loc))_"^"_$g(^temp($j,"gzl",locdr1,loc))
    ..s incomefee=$p(outdata,"^",1)
    ..s costfee=$p(outdata,"^",2)
    ..s amt=incomefee-costfee
    ..s gdcb1=$p(outdata,"^",3)
    ..s gzl=$p(outdata,"^",4)
    ..s bdcb=costfee-gdcb1
    ..i gzl'=0 s dwsr=incomefee/gzl,dwbdcb=bdcb/gzl
    ..e  s dwsr=0,dwbdcb=0
    ..s dwrc=dwsr-dwbdcb
    ..i dwrc'=0 s bbgzl=gdcb1/dwrc
    ..e  s bbgzl=0
    ..;s bbsr=bbgzl*dwsr
    ..s bbsr=costfee
    ..;w !,locdr1_"^"_date_"^"_incomefee_"^"_costfee_"^"_gzl_"^"_gdcb1
   
    ..d OutputRow46
     
    k ^temp($j)
  	q $$$OK
OutputRow46
	i $d(^DHCCAACCOUNTMONTHS(loc)) s monname=$p(^DHCCAACCOUNTMONTHS(loc),"^",2)
  	s Data=$lb($g(monthname1),$g(monthname2),loc,monname,locdr1,$g(deptname),$fn($g(gzl),"",2),$fn($g(incomefee),"",2),$fn($g(costfee),"",2),$fn($g(amt),"",2),$fn($g(gdcb1),"",2),$fn($g(bdcb),"",2),$fn($g(bbgzl),"",2),$fn($g(bbsr),"",2))
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
}

ClassMethod GetBllfxFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBllfxExecute, SqlProc ]
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

ClassMethod GetBllfxClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBllfxExecute, SqlProc ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetBllfx(stdate As %String, endate As %String, type As %String) As %Query(ROWSPEC = "monthname1:%String,monthname2:%String,loc:%Integer,monname:%String,locdr1:%Integer,deptName:%String,gzl:%Float,incomefee:%Float,costfee:%Float,amt:%Float,gdcb1:%Float,bgcb:%Float,bbgzl:%Float,bbsr:%Float") [ SqlProc ]
{
}

//收入构成分析

//d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","GetIncomeGcFx","1","1","demo")

ClassMethod GetIncomeGcFxExecute(ByRef qHandle As %Binary, stdate As %String, endate As %String, user As %String) As %Status [ SqlProc ]
{
	
 	Set repid=$I(^CacheTemp) 
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
    
	q:stdate="" $$$OK
	q:endate="" $$$OK		
    q:user="" $$$OK
    k ^temp($j) 
    
    s RowId="",RowIdIncome="",RowId1="",RowIdu="",unitrid=""

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
    
    ..s i1="",locdr="" 
    ..f i1=stdatecode:1:endatecode d   
    ...f  s locdr=$o(^DHCCAACCOUNTMONTHS(0,"Code",i1,locdr))  q:locdr=""  d
    ....f  s RowIdIncome=$o(^DHCCAINCOMEDATAS(0,"Interval",locdr,RowIdIncome))	q:RowIdIncome=""  d
	.....s data=$p(^DHCCAINCOMEDATAS(RowIdIncome),"^",6)
	.....s datafee=$p(^DHCCAINCOMEDATAS(RowIdIncome),"^",7)
	.....f  s RowId1=$o(^DHCCADATALEVELSETS(RowId1))  q:RowId1=""  d
    ......s parent=$p(^DHCCADATALEVELSETS(RowId1),"^",7) q:parent'=6   //收入分类
    ......q:'$d(^DHCCADATALEVELSETS(0,"Item",RowId1,data))
	......s ^temp($j,RowId1,data)=$g(^temp($j,RowId1,data))+datafee
	
	s datafc=0  f  s datafc=$o(^temp($j,datafc)) q:datafc=""  d
	.s item=0  f  s item=$o(^temp($j,datafc,item)) q:item=""  d
	..s sum=$g(^temp($j,datafc,item))
	..d OutputRow47
   
   k ^temp($j)
   q $$$OK
	
OutputRow47
    s datafcname=$p(^DHCCADATALEVELSETS(datafc),"^",2)  
    i $d(^DHCCAALLDATAITEMS(item)) s itemdesc=$P(^DHCCAALLDATAITEMS(item),"^",3)
    
	s Data=$lb(monthname1,monthname2,datafc,datafcname,item,itemdesc,$g(sum))
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetIncomeGcFxFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetIncomeGcFxExecute, SqlProc ]
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

ClassMethod GetIncomeGcFxClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetIncomeGcFxExecute, SqlProc ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetIncomeGcFx(stdate As %String, endate As %String, user As %String) As %Query(ROWSPEC = "monthname1:%String,monthname2:%String,datafc:%Integer,datafcname:%String,item:%String,itemdesc:%String,sum:%Float") [ SqlProc ]
{
}

//选择统计项目d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","GetXHJItem")

ClassMethod GetXHJItemExecute(ByRef qHandle As %Binary) As %Status [ SqlProc ]
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
     
    s RowId=1,RowId1=""
    
    f  s RowId=$o(^DHCCADATALEVELSETS(RowId))  q:RowId=""  d
    .s parent=$p(^DHCCADATALEVELSETS(RowId),"^",7) q:parent'=25   //新会计制度
    .s fldesc=$p(^DHCCADATALEVELSETS(RowId),"^",2)
    .f  s RowId1=$o(^DHCCADATALEVELSETS(RowId,"Items",RowId1))  q:RowId1=""  d
    ..s item=$p(^DHCCADATALEVELSETS(RowId,"Items",RowId1),"^",3) 
    ..q:item=""
    ..s ItemDesc=$P(^DHCCAALLDATAITEMS(item),"^",3)
    ..d OutputRow48
  
   	q $$$OK

OutputRow48
	
  	s Data=$lb(RowId,fldesc,item,ItemDesc)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
}

ClassMethod GetXHJItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetXHJItemExecute, SqlProc ]
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

ClassMethod GetXHJItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetXHJItemExecute, SqlProc ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetXHJItem() As %Query(ROWSPEC = "RowId:%Integer,fldesc:%String,item:%Integer,ItemDesc:%String") [ SqlProc ]
{
}

//科室开单  d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","GetKskdDept")

/// /////////////
ClassMethod GetKskdDeptExecute(ByRef qHandle As %Binary) As %Status [ SqlProc ]
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
 		
    s RowId="",RowId1=""
    f  s RowId=$o(^DHCCADEPTLEVELSETS(RowId)) q:RowId=""  d
    .s parent=$p(^DHCCADEPTLEVELSETS(RowId),"^",7)  q:parent'=1
    .s fcname=$p(^DHCCADEPTLEVELSETS(RowId),"^",2) 
    .f  s RowId1=$o(^DHCCADEPTLEVELSETS(RowId,"Depts",RowId1)) q:RowId1=""  d
    ..q:RowId1=0
    ..s deptDr=$p(^DHCCADEPTLEVELSETS(RowId,"Depts",RowId1),"^",1) q:deptDr=""
    ..s deptname=$P(^DHCCAUNITDEPTS(deptDr),"^",2)
    ..d OutputRow49
 	 
  	q $$$OK
OutputRow49
	
  	s Data=$lb(RowId,fcname,deptDr,deptname)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
}

ClassMethod GetKskdDeptFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetKskdDeptExecute, SqlProc ]
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

ClassMethod GetKskdDeptClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetKskdDeptExecute, SqlProc ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetKskdDept() As %Query(ROWSPEC = "RowId:%Integer,fcname:%String,deptDr:%Integer,deptname:%String") [ SqlProc ]
{
}

//新会计制度-大科室直接间接成本查询

//d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","GetZjJjCostXHJDK","13","13","27,23,24","demo")

ClassMethod GetZjJjCostXHJDKExecute(ByRef qHandle As %Binary, stdate As %String, endate As %String, type As %Text, user As %String) As %Status [ SqlProc ]
{
                            
	Set repid=$I(^CacheTemp) 
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
 	
 	q:stdate="" $$$OK
	q:endate="" $$$OK
	q:type="" $$$OK
	q:user="" $$$OK
	s RowId="",RowId1="",RowId2="",dep="",RowIdu="",unitrid="",Rolrowid="",RowIdDept="",dept=""
    k ^temp($j) 
    k ^temp1($j) 
       
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
    
    ..f  s Rolrowid=$o(^DHCCADEPTLEVELSETS(Rolrowid))  q:Rolrowid=""  d
    ...q:$F(","_type_",",","_Rolrowid_",")=0
    ...f  s RowIdDept=$o(^DHCCADEPTLEVELSETS(Rolrowid,"Depts",RowIdDept)) q:RowIdDept=""  d
    ....q:RowIdDept=0
    ....s deplxc=$P(^DHCCADEPTLEVELSETS(Rolrowid,"Depts",RowIdDept),"^",1) q:deplxc=""
    ....q:'$d(^DHCCAUNITDEPTS(0,"Unit",unitrid,deplxc))
    ....s dept=deplxc_","_dept
    ....s ^temp1($j,deplxc)=Rolrowid
  
    ..s i1="",i=""
    ..f i1=stdatecode:1:endatecode d
    ...f  s i=$o(^DHCCAACCOUNTMONTHS(0,"Code",i1,i)) q:i=""  d
    ....f  s RowId=$o(^DHCCACOSTDISTSETS(0,"DInterval",unitrid,i,RowId)) q:RowId=""  d
    .....s distdept=$p($g(^DHCCACOSTDISTSETS(unitrid,"CostResultData",RowId)),"^",3)
    .....q:$F(","_dept_",",","_distdept_",")=0
    .....s data=$p(^DHCCACOSTDISTSETS(unitrid,"CostResultData",RowId),"^",4)
    .....s distflag=$p(^DHCCACOSTDISTSETS(unitrid,"CostResultData",RowId),"^",6)  q:distflag'="self"
    .....s datafee=$p(^DHCCACOSTDISTSETS(unitrid,"CostResultData",RowId),"^",5)
    .....s depted=$p(^DHCCACOSTDISTSETS(unitrid,"CostResultData",RowId),"^",2)  
    .....f  s RowId1=$o(^DHCCADATALEVELSETS(RowId1))  q:RowId1=""  d
    ......s parent=$p(^DHCCADATALEVELSETS(RowId1),"^",7) q:parent'=34
    ......q:'$d(^DHCCADATALEVELSETS(0,"Item",RowId1,data))
    ......i $d(^temp1($j,distdept)) s rol=^temp1($j,distdept)
    ......i depted="" s ^temp($j,"depted",rol,distdept,distflag,RowId1)=$g(^temp($j,"depted",rol,distdept,distflag,RowId1))+datafee
    
    s costrol=0 f  s costrol=$o(^temp($j,"depted",costrol)) q:costrol=""  d 
    .s costdept=0 f  s costdept=$o(^temp($j,"depted",costrol,costdept)) q:costdept=""  d
    ..s costflag=0 f  s costflag=$o(^temp($j,"depted",costrol,costdept,costflag)) q:costflag=""  d
    ...s costdatafc=0 f  s costdatafc=$o(^temp($j,"depted",costrol,costdept,costflag,costdatafc)) q:costdatafc=""  d
    ....s costsum=$g(^temp($j,"depted",costrol,costdept,costflag,costdatafc))
    ....s costfenc=""
    ....s costfencw=""
    ....;w !,costrol_"^"_costdept_"^"_costdatafc_"^"_costitem_"^"_costflag_"^"_costsum
    ....d OutputRow50
   
    s RowIdB="",RowIdB1="",RowIdB2="",ward="",RowIdBD=""
    s RowIdu1="",unitrid1="",Rolrowid1="",RowIdDept1="",dept1=""
    f  s RowIdu1=$o(^DHCCAUSERS(0,"Loginname",user,RowIdu1)) q:RowIdu1=""  d
    .s bz=$p(^DHCCAUSERS(RowIdu1),"^",5)  //取集团医院ID 1总部,2二部,3三部
    .f  s unitrid1=$o(^DHCCAUNITDEPTS(0,"Unit",unitrid1))  q:unitrid1=""  d
    ..q:$F(","_bz_",",","_unitrid1_",")=0
    ..i unitrid1=1 s setid=1
    ..i unitrid1=2 s setid=7
    ..i unitrid1=3 s setid=8
    ..f  s Rolrowid1=$o(^DHCCADEPTLEVELSETS(Rolrowid1))  q:Rolrowid1=""  d
    ...q:$F(","_type_",",","_Rolrowid1_",")=0
    ...f  s RowIdDept1=$o(^DHCCADEPTLEVELSETS(Rolrowid1,"Depts",RowIdDept1)) q:RowIdDept1=""  d
    ....q:RowIdDept1=0
    ....s deplxc1=$P(^DHCCADEPTLEVELSETS(Rolrowid1,"Depts",RowIdDept1),"^",1) q:deplxc1=""
    ....q:'$d(^DHCCAUNITDEPTS(0,"Unit",unitrid1,deplxc1))
    ....s dept1=deplxc1_","_dept1
    ....s ^temp1($j,deplxc1)=Rolrowid1
        
    ..s i1="",i=""
    ..f i1=stdatecode:1:endatecode d
    ...f  s i=$o(^DHCCAACCOUNTMONTHS(0,"Code",i1,i)) q:i=""  d
    ....f  s RowIdB=$o(^DHCCACOSTDISTSETS(0,"DInterval",unitrid1,i,RowIdB)) q:RowIdB=""  d
    .....s distdept=$p($g(^DHCCACOSTDISTSETS(unitrid1,"CostResultData",RowIdB)),"^",3) 
    .....q:$F(","_dept_",",","_distdept_",")=0
    .....s data=$p(^DHCCACOSTDISTSETS(unitrid1,"CostResultData",RowIdB),"^",4)
    .....s distflag=$p(^DHCCACOSTDISTSETS(unitrid1,"CostResultData",RowIdB),"^",6)
    .....s datafee=$p(^DHCCACOSTDISTSETS(unitrid1,"CostResultData",RowIdB),"^",5)
    .....s depted=$p(^DHCCACOSTDISTSETS(unitrid1,"CostResultData",RowIdB),"^",2) q:depted=""
    .....f  s RowIdB2=$o(^DHCCADATALEVELSETS(RowIdB2))  q:RowIdB2=""  d
    ......s parent=$p(^DHCCADATALEVELSETS(RowIdB2),"^",7) q:parent'=34
    ......q:'$d(^DHCCADATALEVELSETS(0,"Item",RowIdB2,data))
    ......f  s RowIdB1=$o(^DHCCADEPTLEVELSETS(0,"Parent",setid,RowIdB1))  q:RowIdB1=""  d
    .......f  s dep=$o(^DHCCADEPTLEVELSETS(0,"Dept",RowIdB1,depted,dep))  q:dep=""  d
    ........i $d(^temp1($j,distdept)) s rol=^temp1($j,distdept)
    ........s ^temp($j,"depted",rol,distdept,distflag,RowIdB2,RowIdB1)=$g(^temp($j,"depted",rol,distdept,distflag,RowIdB2,RowIdB1))+datafee
    
    s costrol=0 f  s costrol=$o(^temp($j,"depted",costrol)) q:costrol=""  d          
    .s costdept=0 f  s costdept=$o(^temp($j,"depted",costrol,costdept)) q:costdept=""  d
    ..s costflag=0 f  s costflag=$o(^temp($j,"depted",costrol,costdept,costflag)) q:costflag=""  d
    ...s costdatafc=0 f  s costdatafc=$o(^temp($j,"depted",costrol,costdept,costflag,costdatafc)) q:costdatafc=""  d
    ....s costfenc=0 f  s costfenc=$o(^temp($j,"depted",costrol,costdept,costflag,costdatafc,costfenc))  q:costfenc=""  d
    .....s costsum=$g(^temp($j,"depted",costrol,costdept,costflag,costdatafc,costfenc))
    .....s costfencw=""
    .....;w !,costdept_"^"_costitem_"^"_costflag_"^"_costfenc_"^"_costsum
    .....d OutputRow50
    k ^temp($j) 
    k ^temp1($j)      
   q $$$OK
	
OutputRow50
    s datafcname=$p(^DHCCADATALEVELSETS(costdatafc),"^",2)  
    ;i $d(^DHCCAALLDATAITEMS(costitem)) s ItemDesc=$P(^DHCCAALLDATAITEMS(costitem),"^",3)
    s deptname=$P(^DHCCAUNITDEPTS(costdept),"^",2)
    i $d(^DHCCADEPTLEVELSETS(costrol)) s costrolname=$p(^DHCCADEPTLEVELSETS(costrol),"^",2)   
    i costfenc="" s costfencname="直接成本"
    i costfenc'="" s costfencname="间接成本"
	;i costfenc=5 s costfencname="公用分摊"
	;i costfenc=6 s costfencname="管理分摊"
	;i costfenc=7 s costfencname="医辅分摊"
	;i costfenc=8 s costfencname="医技分摊"
	
	s Data=$lb(monthname1,monthname2,costdatafc,datafcname,costrol,costrolname,costdept,deptname,costflag,costfencname,$fn(costsum,"",2))
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetZjJjCostXHJDKFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetZjJjCostXHJDKExecute, SqlProc ]
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

ClassMethod GetZjJjCostXHJDKClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetZjJjCostXHJDKExecute, SqlProc ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetZjJjCostXHJDK(stdate As %String, endate As %String, type As %Text, user As %String) As %Query(ROWSPEC = "monthname1:%String,monthname2:%String,costdatafc:%Integer,datafcname:%String,costrol:%Integer,costrolname:%String,costdept:%Integer,deptname:%String,costflag:%String,costfencname:%String,costsum:%Float") [ SqlProc ]
{
}

//新会计制度-大科直接成本表

//d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","GetZjCostXHJDK","1","1","demo")

ClassMethod GetZjCostXHJDKExecute(ByRef qHandle As %Binary, stdate As %String, endate As %String, user As %String) As %Status [ SqlProc ]
{
                            
	Set repid=$I(^CacheTemp) 
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
 	
 	q:stdate="" $$$OK
	q:endate="" $$$OK
	q:user="" $$$OK
	s RowId="",RowId1="",RowId2="",dep="",RowIdu="",unitrid="",RowIdDE="",Rolrowid="",RowIdDept="",dept=""
    k ^temp($j) 
    k ^temp1($j)    
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
    f  s Rolrowid=$o(^DHCCADEPTLEVELSETS(Rolrowid))  q:Rolrowid=""  d
    .s parentcz=$p(^DHCCADEPTLEVELSETS(Rolrowid),"^",7) q:parentcz'=19  //临床科室   
    .f  s RowIdDept=$o(^DHCCADEPTLEVELSETS(Rolrowid,"Depts",RowIdDept)) q:RowIdDept=""  d
    ..q:RowIdDept=0
    ..s deplxc=$P(^DHCCADEPTLEVELSETS(Rolrowid,"Depts",RowIdDept),"^",1) q:deplxc=""
    ..;q:'$d(^DHCCAUNITDEPTS(0,"Unit",unitrid,deplxc))
    ..s dept=deplxc_","_dept
    ..s ^temp1($j,deplxc)=Rolrowid
    
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
    ....f  s RowId=$o(^DHCCACOSTDISTSETS(0,"DInterval",unitrid,i,RowId)) q:RowId=""  d
    .....s distdept=$p($g(^DHCCACOSTDISTSETS(unitrid,"CostResultData",RowId)),"^",3)
    .....f  s RowIdDE=$o(^DHCCADEPTLEVELSETS(RowIdDE)) q:RowIdDE=""  d
    ......s parentd=$p(^DHCCADEPTLEVELSETS(RowIdDE),"^",7)  q:parentd'=setid
    ......q:'$d(^DHCCADEPTLEVELSETS(0,"Dept",RowIdDE,distdept))
    ......i $d(^temp1($j,distdept)) s rol=$g(^temp1($j,distdept)) 
    ......e  s rol="99999"
    ......s data=$p(^DHCCACOSTDISTSETS(unitrid,"CostResultData",RowId),"^",4)
    ......s distflag=$p(^DHCCACOSTDISTSETS(unitrid,"CostResultData",RowId),"^",6)  q:distflag'="self"
    ......s datafee=$p(^DHCCACOSTDISTSETS(unitrid,"CostResultData",RowId),"^",5)
    ......s depted=$p(^DHCCACOSTDISTSETS(unitrid,"CostResultData",RowId),"^",2)  
    ......f  s RowId1=$o(^DHCCADATALEVELSETS(RowId1))  q:RowId1=""  d
    .......s parent=$p(^DHCCADATALEVELSETS(RowId1),"^",7) q:parent'=34
    .......q:'$d(^DHCCADATALEVELSETS(0,"Item",RowId1,data))
    .......i depted="" s ^temp($j,"depted",RowIdDE,distdept,RowId1,rol)=$g(^temp($j,"depted",RowIdDE,distdept,RowId1,rol))+datafee
     
    s deptfc=0 f  s deptfc=$o(^temp($j,"depted",deptfc)) q:deptfc=""  d
    .s costdept=0 f  s costdept=$o(^temp($j,"depted",deptfc,costdept)) q:costdept=""  d
    ..s costdatafc=0 f  s costdatafc=$o(^temp($j,"depted",deptfc,costdept,costdatafc)) q:costdatafc=""  d
    ...s costrol=0 f  s costrol=$o(^temp($j,"depted",deptfc,costdept,costdatafc,costrol)) q:costrol=""  d
    ....s costsum=$g(^temp($j,"depted",deptfc,costdept,costdatafc,costrol))
    ....d OutputRow51
    k ^temp($j)
    k ^temp1($j)
   q $$$OK

OutputRow51
    s datafcname=$p(^DHCCADATALEVELSETS(costdatafc),"^",2)  
    s deptname=$P(^DHCCAUNITDEPTS(costdept),"^",2)
    s fcname=$p(^DHCCADEPTLEVELSETS(deptfc),"^",2) 
    i costrol="99999"  s costrolname="未分组科室"
    i $d(^DHCCADEPTLEVELSETS(costrol)) s costrolname=$p(^DHCCADEPTLEVELSETS(costrol),"^",2)   
 	s Data=$lb(monthname1,monthname2,costdatafc,datafcname,deptfc,fcname,costrol,costrolname,costdept,deptname,$fn(costsum,"",2))
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetZjCostXHJDKFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetZjCostXHJDKExecute, SqlProc ]
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

ClassMethod GetZjCostXHJDKClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetZjCostXHJDKExecute, SqlProc ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetZjCostXHJDK(stdate As %String, endate As %String, user As %String) As %Query(ROWSPEC = "monthname1:%String,monthname2:%String,costdatafc:%String,datafcname:%String,deptfc:%String,fcname:%String,costrol:%String,costrolname:%String,costdept:%String,deptname:%String,costsum:%Float") [ SqlProc ]
{
}

//新会计制度-临床大科室全成本构成分析表

//d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","GetCostGcXhjDK","13","13","23,24,27","demo")

ClassMethod GetCostGcXhjDKExecute(ByRef qHandle As %Binary, stdate As %String, endate As %String, type As %Text, user As %String) As %Status [ SqlProc ]
{
	Set repid=$I(^CacheTemp) 
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
 	
 	q:stdate="" $$$OK
	q:endate="" $$$OK
	q:type="" $$$OK
	q:user="" $$$OK
	s RowId="",RowId1="",RowId2="",dep="",RowIdu="",unitrid="",RowIdDE="",RowIdIncome="",RowIdParaM=""
    s RowIdC="",Rolrowid="",RowIdDept="",dept=""
    k ^temp($j) 
    k ^temp1($j) 
    k ^temp2($j) 
       
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
    
    ..f  s Rolrowid=$o(^DHCCADEPTLEVELSETS(Rolrowid))  q:Rolrowid=""  d
    ...q:$F(","_type_",",","_Rolrowid_",")=0
    ...f  s RowIdDept=$o(^DHCCADEPTLEVELSETS(Rolrowid,"Depts",RowIdDept)) q:RowIdDept=""  d
    ....q:RowIdDept=0
    ....s deplxc=$P(^DHCCADEPTLEVELSETS(Rolrowid,"Depts",RowIdDept),"^",1) q:deplxc=""
    ....q:'$d(^DHCCAUNITDEPTS(0,"Unit",unitrid,deplxc))
    ....s dept=deplxc_","_dept
    ....s ^temp2($j,deplxc)=Rolrowid
        
    ..s i1="",i=""
    ..f i1=stdatecode:1:endatecode d
    ...f  s i=$o(^DHCCAACCOUNTMONTHS(0,"Code",i1,i)) q:i=""  d
    ....f  s RowId=$o(^DHCCACOSTDISTSETS(0,"DInterval",unitrid,i,RowId)) q:RowId=""  d
    .....s distdept=$p($g(^DHCCACOSTDISTSETS(unitrid,"CostResultData",RowId)),"^",3)
    .....q:$F(","_dept_",",","_distdept_",")=0
    .....f  s RowIdDE=$o(^DHCCADEPTLEVELSETS(RowIdDE)) q:RowIdDE=""  d
    ......s parentd=$p(^DHCCADEPTLEVELSETS(RowIdDE),"^",7)  q:parentd'=setid
    ......q:'$d(^DHCCADEPTLEVELSETS(0,"Dept",RowIdDE,distdept))
    ......s ^temp($j,distdept,unitrid)=$g(^temp($j,distdept,unitrid))
    
    ....s paraitem=0
    ....s locdr=0 f  s locdr=$o(^temp($j,locdr)) q:locdr=""  d
    .....f  s RowIdIncome=$o(^DHCCAINCOMEDATAS(0,"IntervalFdeptdr",i,locdr,RowIdIncome)) q:RowIdIncome=""  d
    ......s InComeDatafee=$p(^DHCCAINCOMEDATAS(RowIdIncome),"^",7)
    ......i $d(^temp2($j,locdr)) s rol=^temp2($j,locdr)
    ......s ^temp1($j,rol,locdr,"Income")=$g(^temp1($j,rol,locdr,"Income"))+InComeDatafee //科室收入
    
    .....f  s RowIdParaM=$o(^DHCCAPARAMDATAS(0,"IntervalSereddep",i,locdr,RowIdParaM)) q:RowIdParaM=""  d
    ......s paraitem=$p(^DHCCAPARAMDATAS(RowIdParaM),"^",4) q:(paraitem'=174)&(paraitem'=175)
    ......s paraitem=paraitem_"para"
    ......s paradata=$p(^DHCCAPARAMDATAS(RowIdParaM),"^",11)
    ......i $d(^temp2($j,locdr)) s rol=^temp2($j,locdr)
    ......s ^temp1($j,rol,locdr,paraitem)=$g(^temp1($j,rol,locdr,paraitem))+$g(paradata)   //门诊人次、床日数
    
    .....s unit=0 f  s unit=$o(^temp($j,locdr,unit)) q:unit=""  d   
    ......f  s RowIdC=$o(^DHCCACOSTDISTSETS(0,"DIntDistdept",unit,i,locdr,RowIdC)) q:RowIdC=""  d
    .......s data=$p(^DHCCACOSTDISTSETS(unit,"CostResultData",RowIdC),"^",4)
    .......s datafee=$p(^DHCCACOSTDISTSETS(unit,"CostResultData",RowIdC),"^",5)
    .......f  s RowId1=$o(^DHCCADATALEVELSETS(RowId1))  q:RowId1=""  d
    ........s parent=$p(^DHCCADATALEVELSETS(RowId1),"^",7) q:parent'=34
    ........q:'$d(^DHCCADATALEVELSETS(0,"Item",RowId1,data))
    ........i $d(^temp2($j,locdr)) s rol=^temp2($j,locdr)
    ........s ^temp1($j,rol,locdr,RowId1)=$g(^temp1($j,rol,locdr,RowId1))+datafee //科室成本
    
    s dk=0 f  s dk=$o(^temp1($j,dk)) q:dk=""  d  
    .s dep=0 f  s dep=$o(^temp1($j,dk,dep)) q:dep=""  d  
    ..s xm=0 f  s xm=$o(^temp1($j,dk,dep,xm)) q:xm=""  d  
    ...s outdata=$g(^temp1($j,dk,dep,xm))
    ...d OutputRow52
    k ^temp($j) 
    k ^temp1($j) 
    k ^temp2($j) 
    q $$$OK
 
OutputRow52
	i ($d(^DHCCAUNITDEPTS(dep)))  s deptName=$p(^DHCCAUNITDEPTS(dep),"^",2)
  	i ($d(^DHCCADATALEVELSETS(xm)))  s dataname=$p(^DHCCADATALEVELSETS(xm),"^",2)  
  	e  i xm="Income" s dataname="科室收入" 
  	e  s dataname=$P(^DHCCAALLDATAITEMS(+xm),"^",3) 
  	i $d(^DHCCADEPTLEVELSETS(dk)) s dkname=$p(^DHCCADEPTLEVELSETS(dk),"^",2)   
  	s Data=$lb(monthname1,monthname2,dk,dkname,dep,$g(deptName),xm,dataname,$fn($g(outdata),"",2))
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
}

ClassMethod GetCostGcXhjDKFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCostGcXhjDKExecute, SqlProc ]
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

ClassMethod GetCostGcXhjDKClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCostGcXhjDKExecute, SqlProc ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetCostGcXhjDK(stdate As %String, endate As %String, type As %Text, user As %String) As %Query(ROWSPEC = "monthname1:%String,monthname2:%String,dk:%Integer,dkname:%String,dep:%Integer,deptname:%String,xm:%String,dataname:%String,outdata:%Float") [ SqlProc ]
{
}

//大科核算报表配置科室

//d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","GetDkHsDept")

ClassMethod GetDkHsDeptExecute(ByRef qHandle As %Binary) As %Status [ SqlProc ]
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
 		
    
    s RowId="",RowId1="",RowIdu="",unitrid=""
     
    f  s RowId=$o(^DHCCADEPTLEVELSETS(RowId)) q:RowId=""  d
    .s parent=$p(^DHCCADEPTLEVELSETS(RowId),"^",7)  q:((parent="0") || (parent=""))
    .s fcname=$p(^DHCCADEPTLEVELSETS(RowId),"^",2) 
    .d OutputRow53
   
  	q $$$OK
OutputRow53
	
    i $d(^DHCCADEPTLEVELSETS(parent)) s parentname=$p(^DHCCADEPTLEVELSETS(parent),"^",2) 
   	s Data=$lb(parent,parentname,RowId,fcname)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
}

ClassMethod GetDkHsDeptFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDkHsDeptExecute, SqlProc ]
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

ClassMethod GetDkHsDeptClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDkHsDeptExecute, SqlProc ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetDkHsDept() As %Query(ROWSPEC = "parent:%Integer,parentname:%String,RowId:%Integer,fcname:%String") [ SqlProc ]
{
}

//选择单位类别d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","Getunits")

ClassMethod GetunitsExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
     
    s RowId="",RowId1="",unitsActive=""
    
    f  s RowId=$o(^DHCCAUNITS(RowId))  q:(RowId="")||(RowId="5")  d
    .s unitsActive=$p(^DHCCAUNITS(RowId),"^",9)
    .i unitsActive="Y" d
    ..s unitsCode=$p(^DHCCAUNITS(RowId),"^",1)
    ..s unitsName=$P(^DHCCAUNITS(RowId),"^",2)
    
    ..d OutputRow54
  
   	q $$$OK

OutputRow54
	
  	s Data=$lb(RowId,unitsCode,unitsName)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
}

ClassMethod GetunitsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetunitsExecute ]
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

ClassMethod GetunitsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetunitsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query Getunits() As %Query(ROWSPEC = "RowId:%Integer,unitsCode:%String,unitsName:%String") [ SqlProc ]
{
}

//----------------------------------------------------------------------------------

//------------------------------------

/// Creator:张金旺
/// CreatDate:2014.2.24
/// Description: 取参数项目
/// Table:  dhc_ca_cache_data.DataItemCorres，dhc_ca_cache_data.AllDataItems
/// Input:
/// Output:参数Dr 参数名称
/// Return:
/// Others：d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","GetParamItems")
Query GetParamItems() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT DataItemCorres_itemDr as ParamItemsDr,DataItemCorres_itemDr->AllDataItems_name as ParamItemsName FROM dhc_ca_cache_data.DataItemCorres WHERE   DataItemCorres_typeDr=3 AND DataItemCorres_rowid>0
}

//-------------------------------------

/// Creator:张金旺
/// CreatDate:2014.2.25
/// Description: 取科室参数数据
/// Table: dhc_ca_cache_data.paramdatas
/// Input: 核算周期名称必写  参数DR可写、可不写（默认全部） 
/// Output:参数指标名称 医院科室代码 医院科室名称  核算科室代码  核算科室名称 参数值 导数人 导数时间
/// Return:
/// Others：d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","GetParamDatas","2014-03","208,209")
ClassMethod GetParamDatasExecute(ByRef qHandle As %Binary, stdate As %String, ItemsDr As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
 	
 	q:stdate="" $$$OK
	;q:endate="" $$$OK
	;q:ParamDr="" $$$OK
	 
    s sqlStr="SELECT ParamDatas_itemDr->AllDataItems_name,ParamDatas_servedDeptCode,ParamDatas_servedDeptName,ParamDatas_servedDeptDr->UnitDepts_code"
             _",ParamDatas_servedDeptDr->UnitDepts_name,ParamDatas_value,ParamDatas_inType,ParamDatas_inPersonDr->UnitPersons_name,ParamDatas_inDate"
             _" FROM dhc_ca_cache_data.ParamDatas WHERE ParamDatas_intervalDr->AccountMonths_name = '"_stdate_"'"
   
   i ItemsDr'="" s sqlStr=sqlStr_" and ParamDatas_itemDr IN ("_ItemsDr_")"
   s sqlStr=sqlStr_" ORDER BY ParamDatas_servedDeptDr "

    
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	;w sqlStr,!
	d result.Execute()	
 While(result.Next()){
      s ItemName =result.Data("AllDataItems_name")
      s servedDeptCode =result.Data("ParamDatas_servedDeptCode")
      s servedDeptName =result.Data("ParamDatas_servedDeptName")
      s UnitDeptsCode =result.Data("UnitDepts_code")
      s UnitDeptsName =result.Data("UnitDepts_name")
      s value =result.Data("ParamDatas_value")
      s inType =result.Data("ParamDatas_inType")
      i inType="load" s inType="接口导入"
      i inType="input" s inType="手工录入"
      s UnitPersonsName =result.Data("UnitPersons_name")
      s inDate =result.Data("ParamDatas_inDate")
      ;s inDate=$zdt(inDate,3)
      ;w inDate,!
	 d OutputRow56
	  
	}
 
  	q $$$OK
OutputRow56
    s Data=$lb(ItemName,servedDeptCode,servedDeptName,UnitDeptsCode,UnitDeptsName,$fn(value,"",2),UnitPersonsName,inDate)
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod GetParamDatasFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetParamDatasExecute ]
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

ClassMethod GetParamDatasClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetParamDatasExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetParamDatas(stdate As %String, ItemsDr As %String) As %Query(ROWSPEC = "ItemName:%String,servedDeptCode:%String,servedDeptName:%String,UnitDeptsCode:%String,UnitDeptsName:%String,value:%Float,UnitPersonsName:%String,inDate:%String") [ SqlProc ]
{
}

//-------------------------------------

/// Creator:张金旺
/// CreatDate:2014.2.24
/// Description: 取收入类型
/// Table:  dhc_ca_cache_data.DataItemCorres，dhc_ca_cache_data.AllDataItems
/// Input:
/// Output:参数Dr 参数名称
/// Return:
/// Others：d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","GetIncomeType")
Query GetIncomeType() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
 SELECT DataItemCorres_itemDr->AllDataItems_code as IncomeTypeCode ,DataItemCorres_itemDr->AllDataItems_name as IncomeTypeName FROM dhc_ca_cache_data.DataItemCorres WHERE DataItemCorres_typeDr=7 AND DataItemCorres_rowid>0
}

//取核算收入项目

/// Others：d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","GetIncomeItems")
Query GetIncomeItems() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
 SELECT AllDataItems_rowid ,AllDataItems_name  FROM dhc_ca_cache_data.AllDataItems WHERE AllDataItems_remark LIKE '成本核算收入%' AND AllDataItems_active='Y'
}

/// Creator:张金旺
/// CreatDate:2014.2.28
/// Description: 取科室HIS收入数据
/// Table: dhc_ca_cache_data.IncomeDatas
/// Input:核算周期名称（必须有）   收入类型、收入项目Dr、核算科室Dr（此三项可有可无）  报表条件的顺序应跟函数参数顺序相同，不然会有参数位置问题
/// Output:
/// Return://报表query
/// Others：d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","GetHISInomeDatas","2014-03","O","1,2,3,4,5","7,14,20")
ClassMethod GetHISInomeDatasExecute(ByRef qHandle As %Binary, stdate As %String, patType As %String, ItemsDr As %String, DeptDr As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
 	
 	q:stdate="" $$$OK
	;q:patType="" $$$OK
	;q:ParamDr="" $$$OK
	
	
    s sqlStr="SELECT IncomeDatas_patType,IncomeDatas_itemName,IncomeDatas_itemDr,IncomeDatas_itemDr->AllDataItems_name,IncomeDatas_fee,"
    _"IncomeDatas_fDeptName,IncomeDatas_fDeptDr,IncomeDatas_fDeptDr->UnitDepts_name as fDept,IncomeDatas_tDeptName,IncomeDatas_tDeptDr->UnitDepts_name as tDept,"
    _"IncomeDatas_patDeptName,IncomeDatas_patDeptDr->UnitDepts_name as patDept,IncomeDatas_inPersonDr->UnitPersons_name,IncomeDatas_inDate "
    _" FROM dhc_ca_cache_data.IncomeDatas WHERE IncomeDatas_intervalDr->AccountMonths_name = '"_stdate_"'"
    
    ;i patType'="" s sqlStr=sqlStr_" and IncomeDatas_patType IN ("_patType_")" //类型无法用 IN 语句  
   i patType'=""  d
   .s patType=$p(patType,"-",1)
   .s sqlStr=sqlStr_" and IncomeDatas_patType='"_patType_"'" 
   
   i ItemsDr'="" s sqlStr=sqlStr_" and IncomeDatas_itemDr IN ("_ItemsDr_")" 

   i DeptDr'="" s sqlStr=sqlStr_" and IncomeDatas_fDeptDr IN ("_DeptDr_")"
   
    ;S ^TEMPZJWCBCS($J,"CBCS","ZJW")=sqlStr

   
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	;w sqlStr,!
	d result.Execute()	
 While(result.Next()){
      s Type =result.Data("IncomeDatas_patType")
      i Type ="O"  s Type="门诊"
      i Type ="I"  s Type="住院"
      i Type ="E"  s Type="急诊"
      i Type ="H"  s Type="体检"
      s HISitem =result.Data("IncomeDatas_itemName")
      s ItemDr=result.Data("IncomeDatas_itemDr")
      s Item =result.Data("AllDataItems_name")
      s Fee =result.Data("IncomeDatas_fee")
      s HISfDept =result.Data("IncomeDatas_fDeptName")
      s fDeptDr =result.Data("IncomeDatas_fDeptDr")
      s fDept =result.Data("fDept")
      s HIStDept =result.Data("IncomeDatas_tDeptName")
      s tDept =result.Data("tDept")
      s HISpatDept =result.Data("IncomeDatas_patDeptName")
      s patDept =result.Data("patDept")
      s Person =result.Data("UnitPersons_name")
      s inDate =result.Data("IncomeDatas_inDate")
	 d OutputRow56
	}
 
  	q $$$OK
OutputRow56
    s Data=$lb(Type,HISitem,Item,$fn(Fee,"",2),HISfDept,fDeptDr,fDept,HIStDept,tDept,HISpatDept,patDept,Person,inDate)
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod GetHISInomeDatasFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetHISInomeDatasExecute ]
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

ClassMethod GetHISInomeDatasClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetHISInomeDatasExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetHISInomeDatas(stdate As %String, patType As %String, ItemsDr As %String, DeptDr As %String) As %Query(ROWSPEC = "Type:%String,HISitem:%String,Item:%String,Fee:%Float,HISfDept:%String,fDeptDr:%String,fDept:%String,HIStDept:%String,tDept:%String,HISpatDept:%String,patDept:%String,Person:%String,inDate:%String") [ SqlProc ]
{
}

//-----------------------------------------------------------------------------------------------------------

//取财务成本接口名称

Query GetCostInterfaceName() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
 SELECT AllDataItems_rowid,AllDataItems_code,AllDataItems_name  FROM dhc_ca_cache_data.AllDataItems WHERE AllDataItems_remark='成本接口分类' AND AllDataItems_active='Y'
}

/// Creator:张金旺
/// CreatDate:2014.2.27
/// Description: 取成本支出数据
/// Table:dhc_ca_cache_data.VouchDatas  
/// Input:核算周期名称   成本接口类别Code
/// Output:核算单元 核算项目 导入类型 导数人  导入日期  科室代码 科室名称 项目代码  项目名称  金额 
/// Return://报表query
/// Others：d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","GetVouchDatas","2013-01")
ClassMethod GetVouchDatasExecute(ByRef qHandle As %Binary, stdate As %String, InterfaceCode As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
 	
 	q:stdate="" $$$OK
	;q:endate="" $$$OK
	 
 
    s sqlStr="SELECT VouchDatas_deptDr->UnitDepts_name,VouchDatas_itemDr->AllDataItems_name,VouchDatas_inType,VouchDatas_personDr->UnitPersons_name"
             _",VouchDatas_date,VouchDatas_deptCode,VouchDatas_deptName,VouchDatas_subjCode,VouchDatas_subjName,VouchDatas_debit"
             _" FROM dhc_ca_cache_data.VouchDatas WHERE VouchDatas_intervalDr->AccountMonths_name = '"_stdate_"'"
    

    i InterfaceCode'="" s sqlStr=sqlStr_"and VouchDatas_inType ='"_InterfaceCode_"'"

	
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	;w sqlStr,!
	d result.Execute()	
 While(result.Next()){
      s UnitDepts=result.Data("UnitDepts_name")
      s Items=result.Data("AllDataItems_name")
      s inType=result.Data("VouchDatas_inType")
      i inType="load" s inType="接口导入"
      i inType="input" s inType="手工录入"
      s PersonName=result.Data("UnitPersons_name")
      s Date=result.Data("VouchDatas_date")
      s DeptCode=result.Data("VouchDatas_deptCode")
      s DeptName=result.Data("VouchDatas_deptName")
      s subjCode=result.Data("VouchDatas_subjCode")
      s subjName=result.Data("VouchDatas_subjName")
      s debit=result.Data("VouchDatas_debit")
     
	 d OutputRow57
	  
	}
 
  	q $$$OK
OutputRow57
    s Data=$lb(UnitDepts,Items,inType,PersonName,Date,DeptCode,DeptName,subjCode,subjName,$fn(debit,"",2))
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod GetVouchDatasFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetVouchDatasExecute ]
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

ClassMethod GetVouchDatasClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetVouchDatasExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetVouchDatas(stdate As %String, InterfaceCode As %String) As %Query(ROWSPEC = "UnitDepts:%String,Items:%String,inType:%String,PersonName:%String,Date:%String,DeptCode:%String,DeptName:%String,subjCode:%String,subjName:%String,debit:%Float") [ SqlProc ]
{
}

/// Creator:张金旺
/// CreatDate:2014.9.8
/// Description: 根据 医保结算时间 获取出院患者医保支付的费用
/// Table: 就诊表pa_adm    医保结算信息表INSU_Divide
/// Input:核算周期ID
/// Output:科室ID、科室名称、科室代码、医保信息总费用、个人自付费、医保费用
/// remark:医保判定方法需跟医院项目沟通，各项目标准不同，PAC_admreason中字段有的用REA_NationalCode、有的用REA_AdmSource
/// Other:d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","GetYBIncomeCY","1")
ClassMethod GetYBIncomeCYExecute(ByRef qHandle As %Binary, stdate As %String) As %Status [ SqlProc ]
{
	
 	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	q:stdate="" $$$OK

	k ^tempcbcs($j)
    i $d(^DHCCAACCOUNTMONTHS(stdate)) d
	.s sday=$P(^DHCCAACCOUNTMONTHS(stdate),"^",4)
	.s eday=$P(^DHCCAACCOUNTMONTHS(stdate),"^",5)
	w sday_"^"_eday,!
	/*
	;i type="I" s IndexName="DischDate"
	; e  s IndexName="PAADM_AdmDate"
    f day=sday:1:eday  d
    .s admdr=0 f  s admdr=$o(^PAADMi("DischDate",day,admdr)) q:admdr=""  d
 	..s admtype=$p(^PAADM(admdr),"^",2)     //取就诊病人类型
 	..q:admtype'="I"
 	..q:$p(^PAADM(admdr),"^",20)="C"       //A在院  C取消住院(退院)  D出院  P预约 
 	..s reasondr=$p(^PAADM(admdr,1),"^",7)  //取PAADM_AdmReason_DR字段--连接表PAC_AdmReason
 	..q:reasondr=""
 	..;s NationalCode=$p($g(^PAC("ADMREA",reasondr)),"^",5) 
 	..;q:NationalCode=""                    //REA_NationalCode有值时是医保，其他为自费
 	..s AdmSource=$p($g(^PAC("ADMREA",reasondr)),"^",9) 
 	..q:AdmSource="" 				        //REA_AdmSource有值时是医保，其他为自费
 	..s Depdr=$p(^PAADM(admdr),"^",4)       //就诊科室ID--病人科室
    ..s INPAYRowid="" f  s INPAYRowid=$o(^DHCINDIV("0","Paadm",admdr,INPAYRowid)) q:INPAYRowid=""  d
    ...s INPAYFlag=$p(^DHCINDIV(INPAYRowid),"^",5) 
    ...q:INPAYFlag="D"          // D（医保结算但是没有确认的数据） I（正常数据）  S（作废数据-正）B（被作废数据-负）
	...s ^tempcbcs($j,"cbcs",Depdr,"bcbxf0")=$p(^DHCINDIV(INPAYRowid),"^",7)+$g(^tempcbcs($j,"cbcs",Depdr,"bcbxf0"))   //取医保结算总费用
	...s ^tempcbcs($j,"cbcs",Depdr,"grzfe0")=$p(^DHCINDIV(INPAYRowid),"^",15)+$g(^tempcbcs($j,"cbcs",Depdr,"grzfe0"))   //取医保结算个人自付费
 */
 	f day=sday:1:eday  d
    .s INPAYRowid="" f  s INPAYRowid=$o(^DHCINDIV("0","IDate",day,INPAYRowid)) q:INPAYRowid=""  d
    ..s INPAYFlag=$p(^DHCINDIV(INPAYRowid),"^",5) 
    ..q:INPAYFlag="D"          // D（医保结算但是没有确认的数据） I（正常数据）  S（作废数据-正）B（被作废数据-负）
    ..s AdmDr=$p(^DHCINDIV(INPAYRowid),"^",1) 
    ..s AdmType=$p(^PAADM(AdmDr),"^",2)     //取就诊病人类型
 	..q:AdmType'="I"
 	..q:$p(^PAADM(AdmDr),"^",20)="C"       //A在院  C取消住院(退院)  D出院  P预约 
 	..s Depdr=$p(^PAADM(AdmDr),"^",4)       //就诊科室ID--病人科室
	..s ^tempcbcs($j,"cbcs",Depdr,"bcbxf0")=$p(^DHCINDIV(INPAYRowid),"^",7)+$g(^tempcbcs($j,"cbcs",Depdr,"bcbxf0"))   //取医保结算总费用
	..s ^tempcbcs($j,"cbcs",Depdr,"grzfe0")=$p(^DHCINDIV(INPAYRowid),"^",15)+$g(^tempcbcs($j,"cbcs",Depdr,"grzfe0"))   //取医保结算个人自付费
 	..;w $g(^tempcbcs($j,"cbcs",Depdr,"bcbxf0"))_"^"_$g(^tempcbcs($j,"cbcs",Depdr,"grzfe0")),!
 
 	s locdr="" f  s locdr=$o(^tempcbcs($j,"cbcs",locdr)) q:locdr=""  d
 	.;w locdr,!
 	.s locCode=$p(^CTLOC(locdr),"^",1)
 	.s locName=$p(^CTLOC(locdr),"^",2)
    .s INSUPrice=$g(^tempcbcs($j,"cbcs",locdr,"bcbxf0"))  //医保结算信息总费用
    .s INSUFee=$g(^tempcbcs($j,"cbcs",locdr,"grzfe0"))	//医保结算自费
    .s INSUYB=INSUPrice-INSUFee  	//医保费用
    .d OutputRow58
	k ^tempcbcs($j)	
	q $$$OK
    
OutputRow58
    
 	s Data=$lb($g(locdr),locCode,locName,$fn(INSUPrice,"",2),$fn(INSUFee,"",2),$fn(INSUYB,"",2))
   	S ^CacheTemp(repid,ind)=Data
 	S ind=ind+1
	q
}

ClassMethod GetYBIncomeCYFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetYBIncomeCYExecute, SqlProc ]
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

ClassMethod GetYBIncomeCYClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetYBIncomeCYExecute, SqlProc ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetYBIncomeCY(stdate As %String) As %Query(ROWSPEC = "locdr:%String,locCode:%String,locName:%String,INSUPrice:%Float,INSUFee:%Float,INSUYB:%Float") [ SqlProc ]
{
}

/// Creator:张金旺
/// CreatDate:2014.9.24
/// Description: 统计科室收入和部分特殊成本，---开单和执行分别占有一定比例---
/// Table: 
/// Input:核算年度  科室DR  开单比例值ratio
/// Output:科室ID、科室名称、科室代码、科室收入类别、（1）收入类别对应的同是开单和执行收入、（2）单独开单收入、（3）单独执行收入 总金额（1+2*Fratio+3Tratio）
/// remark:科室只能单选
/// Other:d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","GetIncomeByFT","2014","20","30")
ClassMethod GetIncomeByFTExecute(ByRef qHandle As %Binary, Year As %String, DeptDr As %String) As %Status [ SqlProc ]
{
	
 	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	q:Year="" $$$OK
	q:DeptDr="" $$$OK
	;q:Fratio="" $$$OK
	;s ^tempzjwzjw($j,"cbcs")=Year_"^"_DeptDr_"^"_Fratio

	k ^tempcbcs($j)
    s YearName=Year_""_"年度" 
    s MonthDr="" f  s MonthDr=$o(^DHCCAACCOUNTMONTHS(MonthDr))  q:MonthDr=""  d
    .s desc=$p(^DHCCAACCOUNTMONTHS(MonthDr),"^",2)
    .s MonthYear=$p(desc,"-",1)
    .q:MonthYear'=Year
    .//取收入
    .s IncomeRowId="" f  s IncomeRowId=$o(^DHCCAINCOMEDATAS(0,"Interval",MonthDr,IncomeRowId)) q:IncomeRowId=""  d
    ..s FDeptDr=$p(^DHCCAINCOMEDATAS(IncomeRowId),"^",11)   //开单科室Dr
    ..s TDeptDr=$p(^DHCCAINCOMEDATAS(IncomeRowId),"^",14)   //执行科室Dr
    ..s ItemDr=$p(^DHCCAINCOMEDATAS(IncomeRowId),"^",6)     //收费项目Dr
    ..s fee=$p(^DHCCAINCOMEDATAS(IncomeRowId),"^",7)        //收费
    ..i FDeptDr=TDeptDr d 
    ...i FDeptDr=DeptDr s ^tempcbcs($j,"cbcs",MonthDr,DeptDr,ItemDr,"Income")=fee+$g(^tempcbcs($j,"cbcs",MonthDr,DeptDr,ItemDr,"Income"))     //独自收入
    ..e  d
    ...i FDeptDr=DeptDr s ^tempcbcs($j,"cbcs",MonthDr,DeptDr,ItemDr,"IncomeF")=fee+$g(^tempcbcs($j,"cbcs",MonthDr,DeptDr,ItemDr,"IncomeF"))   //单开收入
    ...i TDeptDr=DeptDr s ^tempcbcs($j,"cbcs",MonthDr,DeptDr,ItemDr,"IncomeT")=fee+$g(^tempcbcs($j,"cbcs",MonthDr,DeptDr,ItemDr,"IncomeT"))   //单执收入
    .//取成本
    .s BaseRowId="" f  s BaseRowId=$o(^DHCCABASEDATA(0,"Int",MonthDr,BaseRowId)) q:BaseRowId=""  d
    ..s BaseDeptDr=$P(^DHCCABASEDATA(BaseRowId),"^",14)      //科室Dr
    ..s CostItemDr=$p(^DHCCABASEDATA(BaseRowId),"^",5)     	 //项目Dr
    ..s Cost=$p(^DHCCABASEDATA(BaseRowId),"^",22)        	 //收费
    ..i BaseDeptDr=DeptDr s ^tempcbcs($j,"cbcs",MonthDr,DeptDr,CostItemDr,"Income")=Cost+$g(^tempcbcs($j,"cbcs",MonthDr,DeptDr,CostItemDr,"Income"))

	s DeptName=$p(^DHCCAUNITDEPTS(DeptDr),"^",2)
    s MonthDR="" f  s MonthDR=$o(^tempcbcs($j,"cbcs",MonthDR)) q:MonthDR=""  d
    .s ItemDR="" f  s ItemDR=$o(^tempcbcs($j,"cbcs",MonthDR,DeptDr,ItemDR)) q:ItemDR=""  d
    ..s month=+$p($p(^DHCCAACCOUNTMONTHS(MonthDR),"^",2),"-",2)_""_"月"
    ..s ItemName=$P(^DHCCAALLDATAITEMS(ItemDR),"^",3)
    ..&sql(SELECT DataItemCorres_typeDr into:TypeDR FROM dhc_ca_cache_data.DataItemCorres WHERE  DataItemCorres_itemDr=:ItemDR)
    ..s TypeName=$p(^DHCCADATAITEMTYPES(TypeDR),"^",3)
 	..s FTfee=$g(^tempcbcs($j,"cbcs",MonthDR,DeptDr,ItemDR,"Income"))
 	..s Ffee=$g(^tempcbcs($j,"cbcs",MonthDR,DeptDr,ItemDR,"IncomeF"))
 	..s Tfee=$g(^tempcbcs($j,"cbcs",MonthDR,DeptDr,ItemDR,"IncomeT"))
 	..;s ZSTotle=$g(FTfee)+($g(Ffee)*Fratio/100)+($g(Tfee)*(100-Fratio)/100)  //合计
 	..;i TypeDR'=1  s FTfee="",Ffee="",Tfee=""  //非收入分类只有合计
    ..d OutputRow59
	k ^tempcbcs($j)	
	q $$$OK
    
OutputRow59
    
 	;s Data=$lb(DeptName,$g(MonthDR),month,$g(TypeDR),TypeName,$g(ItemDR),ItemName,$fn(FTfee,"",2),$fn(Ffee,"",2),$fn(Tfee,"",2),$fn(ZSTotle,"",2))
 	s Data=$lb(DeptName,$g(MonthDR),month,$g(TypeDR),TypeName,$g(ItemDR),ItemName,$fn(FTfee,"",2),$fn(Ffee,"",2),$fn(Tfee,"",2))
   	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetIncomeByFTFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetIncomeByFTExecute, SqlProc ]
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

ClassMethod GetIncomeByFTClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetIncomeByFTExecute, SqlProc ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetIncomeByFT(Year As %String, DeptDr As %String) As %Query(ROWSPEC = "DeptName:%String,MonthDR:%String,month:%String,TypeDR:%String,TypeName:%String,ItemDR:%String,ItemName:%String,FTfee:%Float,Ffee:%Float,Tfee:%Float") [ SqlProc ]
{
}

/// Creator:张金旺
/// CreatDate:2014.9.24
/// Description: 统计科室收入和部分特殊成本，---开单和执行分别占有一定比例---
/// Table: 
/// Input:核算月份DR  科室DR  开单比例值ratio
/// Output:核算月份、科室名称、科室项目类别DR、科室项目类别、项目DR、项目名称、（1）收入类别对应的同是开单和执行收入、（2）单独开单收入、（3）单独执行收入 总金额（1+2*Fratio+3Tratio）
/// Remark:科室不能为空，且可多选
/// Other:d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","GetIncomeByFTMonth","1","20,21,22")
ClassMethod GetIncomeByFTMonthExecute(ByRef qHandle As %Binary, stdate As %String, DeptDr As %String) As %Status [ SqlProc ]
{
	
 	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	q:stdate="" $$$OK
	q:DeptDr="" $$$OK

	k ^tempcbcs($j)
	
	i $d(^DHCCAACCOUNTMONTHS(stdate)) d
	.s desc=$p(^DHCCAACCOUNTMONTHS(stdate),"^",2)
    .s Year=$p(desc,"-",1)
    .s month=$p(desc,"-",2)
    .s monthname=Year_""_"年"_""_month_""_"月"
    //取收入
    
    s IncomeRowId="" f  s IncomeRowId=$o(^DHCCAINCOMEDATAS(0,"Interval",stdate,IncomeRowId)) q:IncomeRowId=""  d
    .s FDeptDr=$p(^DHCCAINCOMEDATAS(IncomeRowId),"^",11)   //开单科室Dr
    .s TDeptDr=$p(^DHCCAINCOMEDATAS(IncomeRowId),"^",14)   //执行科室Dr
    .s ItemDr=$p(^DHCCAINCOMEDATAS(IncomeRowId),"^",6)     //收费项目Dr
    .s fee=$p(^DHCCAINCOMEDATAS(IncomeRowId),"^",7)        //收费
    .;W FDeptDr,!
    .i FDeptDr=TDeptDr  d 
    ..i $F(","_DeptDr_",",","_FDeptDr_",")>0 s ^tempcbcs($j,"cbcs",stdate,FDeptDr,ItemDr,"Income")=fee+$g(^tempcbcs($j,"cbcs",stdate,FDeptDr,ItemDr,"Income"))     //独自收入
    .e  d
    ..i $F(","_DeptDr_",",","_FDeptDr_",")>0 s ^tempcbcs($j,"cbcs",stdate,FDeptDr,ItemDr,"IncomeF")=fee+$g(^tempcbcs($j,"cbcs",stdate,FDeptDr,ItemDr,"IncomeF"))   //单开收入
    ..i $F(","_DeptDr_",",","_TDeptDr_",")>0 s ^tempcbcs($j,"cbcs",stdate,TDeptDr,ItemDr,"IncomeT")=fee+$g(^tempcbcs($j,"cbcs",stdate,TDeptDr,ItemDr,"IncomeT"))   //单执收入
    //取成本
    s BaseRowId="" f  s BaseRowId=$o(^DHCCABASEDATA(0,"Int",stdate,BaseRowId)) q:BaseRowId=""  d
    .s BaseDeptDr=$P(^DHCCABASEDATA(BaseRowId),"^",14)       //科室Dr
    .s CostItemDr=$p(^DHCCABASEDATA(BaseRowId),"^",5)     	 //项目Dr
    .s Cost=$p(^DHCCABASEDATA(BaseRowId),"^",22)        	 //收费
    .q:$F(","_DeptDr_",",","_BaseDeptDr_",")=0
    .s ^tempcbcs($j,"cbcs",stdate,BaseDeptDr,CostItemDr,"Income")=Cost+$g(^tempcbcs($j,"cbcs",stdate,BaseDeptDr,CostItemDr,"Income"))


    s DeptDR="" f  s DeptDR=$o(^tempcbcs($j,"cbcs",stdate,DeptDR)) q:DeptDR=""  d
    .s ItemDR="" f  s ItemDR=$o(^tempcbcs($j,"cbcs",stdate,DeptDR,ItemDR)) q:ItemDR=""  d
    ..s DeptName=$p(^DHCCAUNITDEPTS(DeptDR),"^",2)
    ..s ItemName=$P(^DHCCAALLDATAITEMS(ItemDR),"^",3)
    ..&sql(SELECT DataItemCorres_typeDr into:TypeDR FROM dhc_ca_cache_data.DataItemCorres WHERE  DataItemCorres_itemDr=:ItemDR)
    ..s TypeName=$p(^DHCCADATAITEMTYPES(TypeDR),"^",3)
 	..s FTfee=$g(^tempcbcs($j,"cbcs",stdate,DeptDR,ItemDR,"Income"))
 	..s Ffee=$g(^tempcbcs($j,"cbcs",stdate,DeptDR,ItemDR,"IncomeF"))
 	..s Tfee=$g(^tempcbcs($j,"cbcs",stdate,DeptDR,ItemDR,"IncomeT"))
    ..d OutputRow60
	k ^tempcbcs($j)	
	q $$$OK
    
OutputRow60
    
 	s Data=$lb(monthname,$g(DeptDR),DeptName,$g(TypeDR),TypeName,$g(ItemDR),ItemName,$fn(FTfee,"",2),$fn(Ffee,"",2),$fn(Tfee,"",2))
   	S ^CacheTemp(repid,ind)=Data
 	S ind=ind+1
	q
}

ClassMethod GetIncomeByFTMonthFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetIncomeByFTMonthExecute, SqlProc ]
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

ClassMethod GetIncomeByFTMonthClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetIncomeByFTMonthExecute, SqlProc ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetIncomeByFTMonth(stdate As %String, DeptDr As %String) As %Query(ROWSPEC = "monthname:%String,DeptDR:%String,DeptName:%String,TypeDR:%String,TypeName:%String,ItemDR:%String,ItemName:%String,FTfee:%Float,Ffee:%Float,Tfee:%Float") [ SqlProc ]
{
}

/// Creator:张金旺
/// CreatDate:2014.9.28
/// Description: 统计科室部分特殊成本
/// Table: Basedata
/// Input:核算月份DR  科室DR  
/// Output:核算月份、科室DR、科室名称、特殊成本项目DR、特殊成本项目名称、金额
/// Remark:科室可为空，可多选
/// Other:d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","GetBaseCostByMonth","1","20,21,22")
ClassMethod GetBaseCostByMonthExecute(ByRef qHandle As %Binary, stdate As %String, DeptDr As %String) As %Status [ SqlProc ]
{
	
 	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	q:stdate="" $$$OK
	;q:DeptDr="" $$$OK

	k ^tempcbcs($j)
	
	i $d(^DHCCAACCOUNTMONTHS(stdate)) d
	.s desc=$p(^DHCCAACCOUNTMONTHS(stdate),"^",2)
    .s Year=$p(desc,"-",1)
    .s month=$p(desc,"-",2)
    .s monthname=Year_""_"年"_""_month_""_"月"
    //取成本
    s BaseRowId="" f  s BaseRowId=$o(^DHCCABASEDATA(0,"Int",stdate,BaseRowId)) q:BaseRowId=""  d
    .s BaseDeptDr=$P(^DHCCABASEDATA(BaseRowId),"^",14)       //科室Dr
    .s CostItemDr=$p(^DHCCABASEDATA(BaseRowId),"^",5)     	 //项目Dr
    .s Cost=$p(^DHCCABASEDATA(BaseRowId),"^",22)        	 //收费
    .i DeptDr="" d
    ..s ^tempcbcs($j,"cbcs",stdate,BaseDeptDr,CostItemDr,"cost")=Cost+$g(^tempcbcs($j,"cbcs",stdate,BaseDeptDr,CostItemDr,"cost"))
    .e  d
    ..q:$F(","_DeptDr_",",","_BaseDeptDr_",")=0
    ..s ^tempcbcs($j,"cbcs",stdate,BaseDeptDr,CostItemDr,"cost")=Cost+$g(^tempcbcs($j,"cbcs",stdate,BaseDeptDr,CostItemDr,"cost"))


    s DeptDR="" f  s DeptDR=$o(^tempcbcs($j,"cbcs",stdate,DeptDR)) q:DeptDR=""  d
    .s ItemDR="" f  s ItemDR=$o(^tempcbcs($j,"cbcs",stdate,DeptDR,ItemDR)) q:ItemDR=""  d
    ..s Deptlayers="" f  s Deptlayers=$o(^DHCCADEPTLEVELSETS(0,"Parent",1,Deptlayers)) q:Deptlayers=""  d   //1 全成本分摊顶层ID
    ...i $d(^DHCCADEPTLEVELSETS(0,"Dept",Deptlayers,DeptDR))  d     // only one
    ....s Deptlayer=Deptlayers     									//取科室所在分层套Dr
    ....s DeptlayerName=$p(^DHCCADEPTLEVELSETS(Deptlayer),"^",2)
    ..s DeptCode=$p(^DHCCAUNITDEPTS(DeptDR),"^",1)
    ..s DeptName=$p(^DHCCAUNITDEPTS(DeptDR),"^",2)
    ..s ItemName=$P(^DHCCAALLDATAITEMS(ItemDR),"^",3)
 	..s CostFee=$g(^tempcbcs($j,"cbcs",stdate,DeptDR,ItemDR,"cost"))
    ..d OutputRow61
	k ^tempcbcs($j)	
	q $$$OK
    
OutputRow61
    
 	s Data=$lb(monthname,$g(Deptlayer),DeptlayerName,$g(DeptDR),DeptCode,DeptName,$g(ItemDR),ItemName,$fn(CostFee,"",2))
   	S ^CacheTemp(repid,ind)=Data
 	S ind=ind+1
	q
}

ClassMethod GetBaseCostByMonthFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBaseCostByMonthExecute, SqlProc ]
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

ClassMethod GetBaseCostByMonthClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBaseCostByMonthExecute, SqlProc ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetBaseCostByMonth(stdate As %String, DeptDr As %String) As %Query(ROWSPEC = "monthname:%String,Deptlayer:%String,DeptlayerName:%String,DeptDR:%String,DeptCode:%String,DeptName:%String,ItemDR:%String,ItemName:%String,CostFee:%Float") [ SqlProc ]
{
}

//取临床科室总开单收入

///      SELECT InDepts_deptDr,InDepts_deptDr->UnitDepts_code,InDepts_deptDr->UnitDepts_name,count(OutDepts_code) FROM dhc_ca_cache_data.Indepts LEFT JOIN  dhc_ca_cache_data.OutDepts  on InDepts_rowid=OutDepts_parRef
///       WHERE  InDepts_childSub>0 AND OutDepts_childSub>0 AND OutDepts_remark='人员-科室' AND OutDepts_code NOT LIKE '%-%' GROUP BY InDepts_deptDr
/// Others：d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","GetLCZIncome","1","1")
Query GetLCZIncome(stdate As %Integer, endate As %Integer) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
 SELECT sum(IncomeDatas_fee) AS SumIncome FROM dhc_ca_cache_data.IncomeDatas WHERE  IncomeDatas_intervalDr BETWEEN :stdate  AND :endate
}

/// Creator:张金旺
/// CreatDate:2015.1.23
/// Description: 取临床科室直接成本和分摊成本
/// Table:dhc_ca_cache_data.costresultdata dhc_ca_cache_data.leveldepts dhc_ca_cache_data.LevelItems  
/// Input:
/// Output:
/// Return:
/// Others：d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","GetLCCateCosts","1","1")
ClassMethod GetLCCateCostsExecute(ByRef qHandle As %Binary, stdate As %Integer, endate As %Integer) As %Status
{
	
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
 	
 	q:stdate="" $$$OK
	q:endate="" $$$OK
	q:stdate>endate $$$OK
	
	s stmonth=$p(^DHCCAACCOUNTMONTHS(stdate),"^",2)   
	s enmonth=$p(^DHCCAACCOUNTMONTHS(endate),"^",2)
	 
    s sqlStr="select costresultdata_distflag as distflag,c.levelitems_parref->datalevelsets_code as datacode,c.levelitems_parref->datalevelsets_name as dataname,sum(costresultdata_fee) as Sumfee "
			_" from dhc_ca_cache_data.costresultdata as a  left join dhc_ca_cache_data.leveldepts as b on b.leveldepts_deptdr=a.CostResultData_distDeptDr "
	 		_" left join dhc_ca_cache_data.levelitems as c on c.levelitems_itemdr=costresultdata_itemdr "
			_" where costresultdata_intervaldr BETWEEN '"_stdate_"' AND '"_endate_"'" 
			_" and costresultdata_parref=1 "
			_" and b.leveldepts_parref->deptlevelsets_remark='lcks' "
			_" and c.levelitems_parref->datalevelsets_code between 'f101' and 'f107' "
			_" group by costresultdata_distflag,c.levelitems_parref "     
   
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	;w sqlStr,!
	d result.Execute()	
 While(result.Next()){
      s distflag=result.Data("distflag")
      s datacode=result.Data("datacode")
      s dataname=result.Data("dataname")
      s Sumfee=result.Data("Sumfee")
     
	 d OutputRow57
	  
	}
 
  	q $$$OK
OutputRow57
    s Data=$lb(stmonth,enmonth,distflag,datacode,dataname,$g(Sumfee))
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod GetLCCateCostsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLCCateCostsExecute ]
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

ClassMethod GetLCCateCostsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLCCateCostsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetLCCateCosts(stdate As %Integer, endate As %Integer) As %Query(ROWSPEC = "stmonth:%String,enmonth:%String,distflag:%String,datacode:%String,dataname:%String,Sumfee:%Float") [ SqlProc ]
{
}

/// Creator:liuyuanfang
/// CreatDate:2015.4.15
/// Description: 全院诊次状况
/// Table:incomedatas   costresultsum
/// Input:核算年度
/// Output: 核算月份 全院诊次收入   全院诊次成本   全院诊次收益
/// Others：d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","GetClinicCase","2014")
ClassMethod GetClinicCaseExecute(ByRef qHandle As %Binary, stdate As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
 	
 	q:stdate="" $$$OK

    &sql(SELECT AllDataItems_rowid into:ItemDr FROM dhc_ca_cache_data.alldataitems WHERE  AllDataItems_name='门诊人次')
    s sqlStr="SELECT ParamDatas_intervalDr->AccountMonths_name AS Monthname ,ISNULL(sum(ParamDatas_Value),0) AS PersonCount,"
		_"(SELECT ISNULL(sum(IncomeDatas_fee),0) FROM dhc_ca_cache_data.IncomeDatas WHERE IncomeDatas_intervalDr=ParamDatas_intervalDr AND IncomeDatas_patType='O') AS IncomeSum,"
		_"(SELECT ISNULL(sum(CostResultSum_sum),0) FROM dhc_ca_cache_data.CostResultSum WHERE CostResultSum_parRef=1 AND CostResultSum_intervalDr=ParamDatas_intervalDr"
        _" AND CostResultSum_branchFlag='leaf' AND CostResultSum_blDr IN("
		_" SELECT RDepts_deptDr FROM dhc_ca_cache_data.RDepts WHERE RDepts_parRef=1 AND RDepts_childSub>0)) AS CostSum "
		_" FROM dhc_ca_cache_data.ParamDatas"
		_" WHERE ParamDatas_itemDr='"_ItemDr_"' AND ParamDatas_intervalDr->AccountMonths_name like '"_stdate_"%'"
		_" GROUP BY ParamDatas_intervalDr"
		
		//CostResultSum_parRef=1 全成本分摊     RDepts_parRef=1  门诊角色  zjw
		
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
    ;w sqlStr,!
	d result.Execute()	
    While(result.Next()){
	  s monthname=+$p(result.Data("Monthname"),"-",2)_""_"月"
	  s monthorder=+$p(result.Data("Monthname"),"-",2)
      s PersonCount=result.Data("PersonCount")
      s IncomeSum=result.Data("IncomeSum")
      s IncomeSumCase=IncomeSum/PersonCount
      s CostSum=result.Data("CostSum")
      s CostSumCase=CostSum/PersonCount
      s RealSumCase=IncomeSumCase-CostSumCase
	 d OutputRow60
	
	}
 
  	q $$$OK
OutputRow60
    s Data=$lb(monthname,monthorder,PersonCount,IncomeSum,CostSum,IncomeSumCase,CostSumCase,RealSumCase)
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod GetClinicCaseFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetClinicCaseExecute ]
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

ClassMethod GetClinicCaseClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetClinicCaseExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetClinicCase(stdate As %String) As %Query(ROWSPEC = "monthname:%String,monthorder:%Integer,PersonCount:%Float,IncomeSum:%Float,CostSum:%Float,IncomeSumCase:%Float,CostSumCase:%Float,RealSumCase:%Float") [ SqlProc ]
{
}

/// Creator:liuyuanfang
/// CreatDate:2015.4.17
/// Description: 全院床日状况
/// Table:incomedatas   costresultsum
/// Input:核算年度
/// Output: 核算月份 全院床日收入   全院床日成本   全院床日收益
/// Others：d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","GetPerBedCost","2014")
ClassMethod GetPerBedCostExecute(ByRef qHandle As %Binary, stdate As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
 	
 	q:stdate="" $$$OK

    &sql(SELECT AllDataItems_rowid into:ItemDr FROM dhc_ca_cache_data.alldataitems WHERE  AllDataItems_name='住院床日')
    s sqlStr="SELECT ParamDatas_intervalDr->AccountMonths_name AS Monthname ,ISNULL(sum(ParamDatas_Value),0) AS PersonCount,"
		_"(SELECT ISNULL(sum(IncomeDatas_fee),0) FROM dhc_ca_cache_data.IncomeDatas WHERE IncomeDatas_intervalDr=ParamDatas_intervalDr AND IncomeDatas_patType='I') AS IncomeSum,"
		_"(SELECT ISNULL(sum(CostResultSum_sum),0) FROM dhc_ca_cache_data.CostResultSum WHERE CostResultSum_parRef=1 AND CostResultSum_intervalDr=ParamDatas_intervalDr"
        _" AND CostResultSum_branchFlag='leaf' AND CostResultSum_blDr IN("
		_" SELECT RDepts_deptDr FROM dhc_ca_cache_data.RDepts WHERE RDepts_parRef=2 AND RDepts_childSub>0)) AS CostSum "
		_" FROM dhc_ca_cache_data.ParamDatas"
		_" WHERE ParamDatas_itemDr='"_ItemDr_"' AND ParamDatas_intervalDr->AccountMonths_name like '"_stdate_"%'"
		_" GROUP BY ParamDatas_intervalDr"
				
		//CostResultSum_parRef=1 全成本分摊     RDepts_parRef=2  住院角色   zjw
		
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
    ;w sqlStr,!
	d result.Execute()	
    While(result.Next()){
	  s monthname=+$p(result.Data("Monthname"),"-",2)_""_"月"
	  s monthorder=+$p(result.Data("Monthname"),"-",2)
      s PersonCount=result.Data("PersonCount")
      s IncomeSum=result.Data("IncomeSum")
      s IncomeSumCase=IncomeSum/PersonCount
      s CostSum=result.Data("CostSum")
      s CostSumCase=CostSum/PersonCount
      s RealSumCase=IncomeSumCase-CostSumCase
	 d OutputRow61
	
	}
 
  	q $$$OK
OutputRow61
    s Data=$lb(monthname,monthorder,PersonCount,IncomeSum,CostSum,IncomeSumCase,CostSumCase,RealSumCase)
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod GetPerBedCostFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPerBedCostExecute ]
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

ClassMethod GetPerBedCostClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPerBedCostExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetPerBedCost(stdate As %String) As %Query(ROWSPEC = "monthname:%String,monthorder:%Integer,PersonCount:%Float,IncomeSum:%Float,CostSum:%Float,IncomeSumCase:%Float,CostSumCase:%Float,RealSumCase:%Float") [ SqlProc ]
{
}

/// Creator:张金旺
/// CreatDate:2014.8.15
/// Description: 取临床大科数据
/// Table:incomedatas   costresultsum
/// Input:核算周期ID
/// Output:大科ID  大科名称  小科ID  小科名称  科室全成本   科室收入 药品收入  门诊人次  住院床日 
/// Return://报表query
/// Others：d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","GetLCParentDatas","1")
ClassMethod GetLCParentDatasExecute(ByRef qHandle As %Binary, stdate As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
 	
 	q:stdate="" $$$OK
 	i $d(^DHCCAACCOUNTMONTHS(stdate)) s month=$p(^DHCCAACCOUNTMONTHS(stdate),"^",2)
    s month1=$p(month,"-",1)
    s day=$p(month,"-",2)
    s monthname=month1_""_"年"_""_day_""_"月"
	;q:endate="" $$$OK
	 
    /*
    s sqlStr="SELECT '"_monthname_"' as AcuPeriod , a.DeptLevelSets_rowid,a.DeptLevelSets_name,b.LevelDepts_deptDr,b.LevelDepts_deptDr->UnitDepts_name"
			_",(SELECT ISNULL(CostResultSum_sum,0) FROM dhc_ca_cache_data.CostResultSum WHERE CostResultSum_parRef=1 AND CostResultSum_intervalDr='"_stdate_"' AND CostResultSum_branchFlag='leaf' AND CostResultSum_blDr=b.LevelDepts_deptDr) AS AcuPeriodCost"
			_",(SELECT ISNULL(SUM(IncomeDatas_fee),0) FROM dhc_ca_cache_data.IncomeDatas WHERE IncomeDatas_intervalDr='"_stdate_"' and IncomeDatas_fDeptDr=b.LevelDepts_deptDr) AS AcuPeriodIncome"
			_",(SELECT ISNULL(SUM(IncomeDatas_fee),0) FROM dhc_ca_cache_data.IncomeDatas WHERE IncomeDatas_intervalDr='"_stdate_"' and IncomeDatas_fDeptDr=b.LevelDepts_deptDr AND IncomeDatas_itemDr IN ('11','12','13') ) AS AcuPeriodYP"
			_",(SELECT ISNULL(SUM(ParamDatas_value),0) FROM dhc_ca_cache_data.ParamDatas WHERE  ParamDatas_intervalDr='"_stdate_"' AND ParamDatas_itemDr->AllDataItems_name ='门诊人次' AND ParamDatas_servedDeptDr=b.LevelDepts_deptDr) AS AcuPeriodMZRC"
			_",(SELECT ISNULL(SUM(ParamDatas_value),0) FROM dhc_ca_cache_data.ParamDatas WHERE  ParamDatas_intervalDr='"_stdate_"' AND ParamDatas_itemDr->AllDataItems_name ='住院床日' AND ParamDatas_servedDeptDr=b.LevelDepts_deptDr) AS AcuPeriodZYCR"
		_" FROM dhc_ca_cache_data.DeptLevelSets a LEFT JOIN dhc_ca_cache_data.LevelDepts b ON a.DeptLevelSets_rowid=b.LevelDepts_parRef "
		_" WHERE a.DeptLevelSets_parent=8 AND b.LevelDepts_childSub>0 "
		
		//IncomeDatas_itemDr IN ('11','12','13') 药品收入分类下项目Dr       a.DeptLevelSets_parent=8 临床大科分类ID  
	*/
	s sqlStr="SELECT '"_monthname_"' as AcuPeriod , a.DeptLevelSets_rowid,a.DeptLevelSets_name,b.LevelDepts_deptDr,b.LevelDepts_deptDr->UnitDepts_name"
			_",(SELECT ISNULL(SUM(CostResultSum_sum),0) FROM dhc_ca_cache_data.CostResultSum WHERE CostResultSum_parRef=1 AND CostResultSum_intervalDr='"_stdate_"' AND CostResultSum_branchFlag='leaf' AND CostResultSum_blDr=b.LevelDepts_deptDr) AS AcuPeriodCost "
 			_",(SELECT ISNULL(SUM(CostResultSum_sum),0) FROM dhc_ca_cache_data.CostResultSum WHERE CostResultSum_parRef=1 AND CostResultSum_intervalDr='"_stdate_"' AND CostResultSum_branchFlag='leaf' AND CostResultSum_blDr=b.LevelDepts_deptDr AND b.LevelDepts_deptDr IN (SELECT RDepts_deptDr FROM dhc_ca_cache_data.RDepts WHERE RDepts_parRef=1 AND RDepts_childSub>0) ) AS AcuPeriodCostMZ "
 			_",(SELECT ISNULL(SUM(CostResultSum_sum),0) FROM dhc_ca_cache_data.CostResultSum WHERE CostResultSum_parRef=1 AND CostResultSum_intervalDr='"_stdate_"' AND CostResultSum_branchFlag='leaf' AND CostResultSum_blDr=b.LevelDepts_deptDr AND b.LevelDepts_deptDr IN (SELECT RDepts_deptDr FROM dhc_ca_cache_data.RDepts WHERE RDepts_parRef=2 AND RDepts_childSub>0)) AS AcuPeriodCostZY "
			_",(SELECT ISNULL(SUM(IncomeDatas_fee),0) FROM dhc_ca_cache_data.IncomeDatas WHERE IncomeDatas_intervalDr='"_stdate_"' and IncomeDatas_fDeptDr=b.LevelDepts_deptDr) AS AcuPeriodIncome "
 			_",(SELECT ISNULL(SUM(IncomeDatas_fee),0) FROM dhc_ca_cache_data.IncomeDatas WHERE  IncomeDatas_intervalDr='"_stdate_"' AND  IncomeDatas_tDeptDr=b.LevelDepts_deptDr) AS AcuPeriodIncomeT "
 			_",(SELECT ISNULL(SUM(IncomeDatas_fee),0) FROM dhc_ca_cache_data.IncomeDatas WHERE  IncomeDatas_intervalDr='"_stdate_"' AND  IncomeDatas_fDeptDr=b.LevelDepts_deptDr AND IncomeDatas_tDeptDr IN ( "
 			_" SELECT LevelDepts_deptDr FROM dhc_ca_cache_data.LevelDepts WHERE  LevelDepts_parRef=93 AND LevelDepts_childSub>0 AND LevelDepts_recCost='Y'  ) ) AS AcuPeriodIncomeGJ "
			_",(SELECT ISNULL(SUM(IncomeDatas_fee),0) FROM dhc_ca_cache_data.IncomeDatas WHERE IncomeDatas_intervalDr='"_stdate_"' and IncomeDatas_fDeptDr=b.LevelDepts_deptDr AND b.LevelDepts_deptDr IN (SELECT RDepts_deptDr FROM dhc_ca_cache_data.RDepts WHERE RDepts_parRef=1 AND RDepts_childSub>0) ) AS AcuPeriodIncomeMZ "
 			_",(SELECT ISNULL(SUM(IncomeDatas_fee),0) FROM dhc_ca_cache_data.IncomeDatas WHERE IncomeDatas_intervalDr='"_stdate_"' and IncomeDatas_fDeptDr=b.LevelDepts_deptDr AND b.LevelDepts_deptDr IN (SELECT RDepts_deptDr FROM dhc_ca_cache_data.RDepts WHERE RDepts_parRef=2 AND RDepts_childSub>0) ) AS AcuPeriodIncomeZY "			
 
			_",(SELECT ISNULL(SUM(IncomeDatas_fee),0) FROM dhc_ca_cache_data.IncomeDatas WHERE IncomeDatas_intervalDr='"_stdate_"' and IncomeDatas_fDeptDr=b.LevelDepts_deptDr AND IncomeDatas_itemDr IN ('115','116','117') ) AS AcuPeriodYP "
			_",(SELECT ISNULL(SUM(ParamDatas_value),0) FROM dhc_ca_cache_data.ParamDatas WHERE  ParamDatas_intervalDr='"_stdate_"' AND ParamDatas_itemDr->AllDataItems_name ='门诊人次' AND ParamDatas_servedDeptDr=b.LevelDepts_deptDr) AS AcuPeriodMZRC "
			_",(SELECT ISNULL(SUM(ParamDatas_value),0) FROM dhc_ca_cache_data.ParamDatas WHERE  ParamDatas_intervalDr='"_stdate_"' AND ParamDatas_itemDr->AllDataItems_name ='住院床日' AND ParamDatas_servedDeptDr=b.LevelDepts_deptDr) AS AcuPeriodZYCR "
 			_",(SELECT ISNULL(SUM(ParamDatas_value),0) FROM dhc_ca_cache_data.ParamDatas WHERE  ParamDatas_intervalDr='"_stdate_"' AND ParamDatas_itemDr->AllDataItems_name ='科室人数' AND ParamDatas_servedDeptDr=b.LevelDepts_deptDr) AS AcuPeriodKSRS "
 			
 			_" FROM dhc_ca_cache_data.DeptLevelSets a LEFT JOIN dhc_ca_cache_data.LevelDepts b ON a.DeptLevelSets_rowid=b.LevelDepts_parRef "
			_"  WHERE a.DeptLevelSets_parent=8 AND b.LevelDepts_childSub>0 "
 
	
	//IncomeDatas_itemDr IN ('115','116','117') 药品收入分类下项目Dr    LevelDepts_parRef=93  功检类科室 设置
	
	
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	w sqlStr,!
	d result.Execute()	
 While(result.Next()){
	  s monthname=result.Data("AcuPeriod")
	  s ParentDeptDr=result.Data("DeptLevelSets_rowid")
      s ParentDeptName=result.Data("DeptLevelSets_name")
      s DeptDr=result.Data("LevelDepts_deptDr")
      s DeptName=result.Data("UnitDepts_name")
      s AcuPeriodCost=result.Data("AcuPeriodCost")
      s AcuPeriodCostMZ=result.Data("AcuPeriodCostMZ")
      s AcuPeriodCostZY=result.Data("AcuPeriodCostZY")
      s AcuPeriodIncome=result.Data("AcuPeriodIncome")
      s AcuPeriodIncomeT=result.Data("AcuPeriodIncomeT")
      s AcuPeriodIncomeGJ=result.Data("AcuPeriodIncomeGJ")
      s AcuPeriodIncomeMZ=result.Data("AcuPeriodIncomeMZ")
      s AcuPeriodIncomeZY=result.Data("AcuPeriodIncomeZY")
      s AcuPeriodReceipts=AcuPeriodIncome-AcuPeriodCost
      s AcuPeriodYP=result.Data("AcuPeriodYP")
      s AcuPeriodMZRC=result.Data("AcuPeriodMZRC")
      s AcuPeriodZYCR=result.Data("AcuPeriodZYCR")
      s AcuPeriodKSRS=result.Data("AcuPeriodKSRS")
     
	 d OutputRow58
	  
	}
 
  	q $$$OK
OutputRow58
    q:(AcuPeriodCost=0)&&(AcuPeriodIncome=0)&&(AcuPeriodMZRC=0)&&(AcuPeriodZYCR=0)  
    s Data=$lb(monthname,ParentDeptDr,ParentDeptName,DeptDr,DeptName,AcuPeriodCost,AcuPeriodCostMZ,AcuPeriodCostZY,AcuPeriodIncome,AcuPeriodIncomeT,AcuPeriodIncomeGJ,AcuPeriodIncomeMZ,AcuPeriodIncomeZY,AcuPeriodReceipts,AcuPeriodYP,AcuPeriodMZRC,AcuPeriodZYCR,AcuPeriodKSRS)
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod GetLCParentDatasFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLCParentDatasExecute ]
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

ClassMethod GetLCParentDatasClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLCParentDatasExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetLCParentDatas(stdate As %String) As %Query(ROWSPEC = "monthname:%String,ParentDeptDr:%String,ParentDeptName:%String,DeptDr:%String,DeptName:%String,AcuPeriodCost:%Float,AcuPeriodCostMZ:%Float,AcuPeriodCostZY:%Float,AcuPeriodIncome:%Float,AcuPeriodIncomeT:%Float,AcuPeriodIncomeGJ:%Float,AcuPeriodIncomeMZ:%Float,AcuPeriodIncomeZY:%Float,AcuPeriodReceipts:%Float,AcuPeriodYP:%Float,AcuPeriodMZRC:%Float,AcuPeriodZYCR:%Float,AcuPeriodKSRS:%Float") [ SqlProc ]
{
}

/// Creator:张金旺
/// CreatDate:2014.8.15
/// Description: 取医技大科数据
/// Table:incomedatas   costresultsum
/// Input:核算周期id
/// Output:大科ID  大科名称  小科ID  小科名称  科室全成本   科室收入    
/// Return://报表query
/// Others：d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","GetYJParentDatas","1")
ClassMethod GetYJParentDatasExecute(ByRef qHandle As %Binary, stdate As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
 	
 	q:stdate="" $$$OK
 	i $d(^DHCCAACCOUNTMONTHS(stdate)) s month=$p(^DHCCAACCOUNTMONTHS(stdate),"^",2)
    s month1=$p(month,"-",1)
    s day=$p(month,"-",2)
    s monthname=month1_""_"年"_""_day_""_"月"
	;q:endate="" $$$OK
	 
    /*
    s sqlStr="SELECT '"_monthname_"' as AcuPeriod , a.DeptLevelSets_rowid,a.DeptLevelSets_name,b.LevelDepts_deptDr,b.LevelDepts_deptDr->UnitDepts_name"
			_",(SELECT ISNULL(sum(CostResultSum_sum),0) FROM dhc_ca_cache_data.CostResultSum WHERE CostResultSum_parRef=1 AND CostResultSum_intervalDr='"_stdate_"' AND CostResultSum_branchFlag='leaf' AND CostResultSum_blDr=b.LevelDepts_deptDr) AS AcuPeriodCost"
			_",(SELECT ISNULL(sum(IncomeDatas_fee),0) FROM dhc_ca_cache_data.IncomeDatas WHERE IncomeDatas_intervalDr='"_stdate_"' and IncomeDatas_tDeptDr=b.LevelDepts_deptDr) AS AcuPeriodIncome"
			_",(SELECT ISNULL(sum(IncomeDatas_fee),0) FROM dhc_ca_cache_data.IncomeDatas WHERE IncomeDatas_intervalDr='"_stdate_"' and IncomeDatas_fDeptDr=b.LevelDepts_deptDr) AS AcuPeriodIncomeF"
		_" FROM dhc_ca_cache_data.DeptLevelSets a LEFT JOIN dhc_ca_cache_data.LevelDepts b ON a.DeptLevelSets_rowid=b.LevelDepts_parRef "
		_" WHERE a.DeptLevelSets_parent=9 AND b.LevelDepts_childSub>0 "
		
		//a.DeptLevelSets_parent=9 医技大科分类ID  
	*/
	s sqlStr="SELECT '"_monthname_"' as AcuPeriod , a.DeptLevelSets_rowid,a.DeptLevelSets_name,b.LevelDepts_deptDr,b.LevelDepts_deptDr->UnitDepts_name"
			_",(SELECT ISNULL(sum(CostResultData_fee),0) FROM dhc_ca_cache_data.CostResultData WHERE CostResultData_parRef=1 AND CostResultData_intervalDr='"_stdate_"' AND CostResultData_distFlag='self' AND CostResultData_distDeptDr=b.LevelDepts_deptDr) AS AcuPeriodCost"
			_",(SELECT ISNULL(sum(IncomeDatas_fee),0) FROM dhc_ca_cache_data.IncomeDatas WHERE IncomeDatas_intervalDr='"_stdate_"' and IncomeDatas_tDeptDr=b.LevelDepts_deptDr) AS AcuPeriodIncome"
			_",(SELECT ISNULL(sum(IncomeDatas_fee),0) FROM dhc_ca_cache_data.IncomeDatas WHERE IncomeDatas_intervalDr='"_stdate_"' and IncomeDatas_fDeptDr=b.LevelDepts_deptDr) AS AcuPeriodIncomeF"
			_",(SELECT ISNULL(SUM(ParamDatas_value),0) FROM dhc_ca_cache_data.ParamDatas WHERE  ParamDatas_intervalDr='"_stdate_"' AND ParamDatas_itemDr->AllDataItems_name ='科室人数' AND ParamDatas_servedDeptDr=b.LevelDepts_deptDr) AS AcuPeriodKSRS "
		_" FROM dhc_ca_cache_data.DeptLevelSets a LEFT JOIN dhc_ca_cache_data.LevelDepts b ON a.DeptLevelSets_rowid=b.LevelDepts_parRef "
		_" WHERE a.DeptLevelSets_parent=9 AND b.LevelDepts_childSub>0 "
		
		//a.DeptLevelSets_parent=9 医技大科分类ID 
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	w sqlStr,!
	d result.Execute()	
 While(result.Next()){
	  s monthname=result.Data("AcuPeriod")
	  s ParentDeptDr=result.Data("DeptLevelSets_rowid")
      s ParentDeptName=result.Data("DeptLevelSets_name")
      s DeptDr=result.Data("LevelDepts_deptDr")
      s DeptName=result.Data("UnitDepts_name")
      s AcuPeriodCost=result.Data("AcuPeriodCost")
      s AcuPeriodIncome=result.Data("AcuPeriodIncome")
      s AcuPeriodIncomeF=result.Data("AcuPeriodIncomeF")
      s AcuPeriodKSRS=result.Data("AcuPeriodKSRS")
      s AcuPeriodReceipts=AcuPeriodIncome-AcuPeriodCost
	 d OutputRow59
	  
	}
 
  	q $$$OK
OutputRow59
    q:(AcuPeriodCost=0)&&(AcuPeriodIncome=0)
    s Data=$lb(monthname,ParentDeptDr,ParentDeptName,DeptDr,DeptName,$g(AcuPeriodCost),$g(AcuPeriodIncome),$g(AcuPeriodIncomeF),$g(AcuPeriodKSRS),$g(AcuPeriodReceipts))
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod GetYJParentDatasFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetYJParentDatasExecute ]
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

ClassMethod GetYJParentDatasClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetYJParentDatasExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetYJParentDatas(stdate As %String) As %Query(ROWSPEC = "monthname:%String,ParentDeptDr:%String,ParentDeptName:%String,DeptDr:%String,DeptName:%String,AcuPeriodCost:%Float,AcuPeriodIncome:%Float,AcuPeriodIncomeF:%Float,AcuPeriodKSRS:%Float,AcuPeriodReceipts:%Float") [ SqlProc ]
{
}

//-------------------------------------

/// Creator:ZJW
/// CreatDate:2015.5.12
/// Description: 取大科当年收入、成本
/// Table:incomedatas  CostResultData  costresultsum
/// Input:核算周期id  大科id
/// Output:大科ID  大科名称  小科ID  小科名称  科室全成本   科室收入   科室人数 
/// Return://报表query
/// Others：d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","GetDKParentDatas","1","65")
ClassMethod GetDKParentDatasExecute(ByRef qHandle As %Binary, stdate As %String, deptLevDR As %String) As %Status [ SqlProc ]
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
 	
 
	q:stdate="" $$$OK
	s Income="",Cost=""
	k ^temp($j,"zjwcbcs")
	i $d(^DHCCADEPTLEVELSETS(deptLevDR)) d
	.s deptname=$p(^DHCCADEPTLEVELSETS(deptLevDR),"^",2)
	.s deptparentDR=$p(^DHCCADEPTLEVELSETS(deptLevDR),"^",7)		//取部门分层的父节点，便于区分是临床-8或医技-9
	
	
	i $d(^DHCCAACCOUNTMONTHS(stdate)) d
	.s month=$p(^DHCCAACCOUNTMONTHS(stdate),"^",2)
    .s monthQ=$p(month,"-",1)
    .s monthname=monthQ_""_"年度"
    
    s IntervalDr="" f  s IntervalDr=$o(^DHCCAACCOUNTMONTHS(IntervalDr))  q:IntervalDr=""  d
    .s desc=$p(^DHCCAACCOUNTMONTHS(IntervalDr),"^",2)
    .s mon=+$p(desc,"-",2)_""_"月"
    .s desc1=$p(desc,"-",1)
    .q:desc1'=monthQ 
    .s monthorder=+$p(desc,"-",2)
    .s ^temp($j,"zjwcbcs",IntervalDr)=$g(^temp($j,"zjwcbcs",IntervalDr))
    .//s IntervalDr=RowId
    .s dept="" f  s dept=$o(^DHCCADEPTLEVELSETS(0,"Dept",deptLevDR,dept)) q:dept=""  d
    ..i deptparentDR=8 d  //临床科室分层取开单收入，成本取全成本
    ...s RowIdIncome="" f  s RowIdIncome=$o(^DHCCAINCOMEDATAS(0,"IntervalFdeptdr",IntervalDr,dept,RowIdIncome)) q:RowIdIncome=""  d
    ....s Income=$p(^DHCCAINCOMEDATAS(RowIdIncome),"^",7)
    ....s ^temp($j,"zjwcbcs",IntervalDr,"Income")=$g(^temp($j,"zjwcbcs",IntervalDr,"Income"))+Income	//取收入
    ...s RowIdCost=""  f  s RowIdCost=$o(^DHCCACOSTDISTSETS(1,"IntIDFlag",IntervalDr,dept,"leaf",RowIdCost)) q:RowIdCost=""   d
    ....s Cost=$p(^DHCCACOSTDISTSETS(1,"CostResultSum",RowIdCost),"^",7) 
   	....s ^temp($j,"zjwcbcs",IntervalDr,"Cost")=$g(^temp($j,"zjwcbcs",IntervalDr,"Cost"))+Cost			//取成本
    ..i deptparentDR=9 d  //医技科室取执行收入,成本取直接成本
    ...s RowIdIncome="" f  s RowIdIncome=$o(^DHCCAINCOMEDATAS(0,"IntervalTdeptdr",IntervalDr,dept,RowIdIncome)) q:RowIdIncome=""  d
    ....s Income=$p(^DHCCAINCOMEDATAS(RowIdIncome),"^",7)
    ....s ^temp($j,"zjwcbcs",IntervalDr,"Income")=$g(^temp($j,"zjwcbcs",IntervalDr,"Income"))+Income	//取收入
    ...s RowIdCost=""  f  s RowIdCost=$o(^DHCCAVOUCHDATAS(0,"IntervalDept",IntervalDr,dept,RowIdCost)) q:RowIdCost=""  d
    ....s Cost=$p(^DHCCAVOUCHDATAS(RowIdCost),"^",16) //成本金额
   	....s ^temp($j,"zjwcbcs",IntervalDr,"Cost")=$g(^temp($j,"zjwcbcs",IntervalDr,"Cost"))+Cost			//取成本
    ..s RowIdParam="" f  s RowIdParam=$o(^DHCCAPARAMDATAS(0,"IntervalSereddepItem",IntervalDr,dept,139,RowIdParam)) q:RowIdParam=""  d
    ...s ParamKSRS=$p(^DHCCAPARAMDATAS(RowIdParam),"^",11)
    ...s ^temp($j,"zjwcbcs",IntervalDr,"ParamKSRS")=$g(^temp($j,"zjwcbcs",IntervalDr,"ParamKSRS"))+ParamKSRS  //取科室人数
   
    .s incomefee=$g(^temp($j,"zjwcbcs",IntervalDr,"Income")) 
    .s costfee=$g(^temp($j,"zjwcbcs",IntervalDr,"Cost")) 
    .s amt=incomefee-costfee
    .s KSRS=$g(^temp($j,"zjwcbcs",IntervalDr,"ParamKSRS"))
 	.d OutputRow60
    
    k ^temp($j,"zjwcbcs")
 	q $$$OK
OutputRow60
	;
  	s Data=$lb($g(monthname),$g(mon),deptname,IntervalDr,$g(incomefee),$g(costfee),$g(amt),$g(KSRS),$g(monthorder))
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetDKParentDatasFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDKParentDatasExecute, SqlProc ]
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

ClassMethod GetDKParentDatasClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDKParentDatasExecute, SqlProc ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetDKParentDatas(stdate As %String, deptLevDR As %String) As %Query(ROWSPEC = "monthname:%String,mon:%String,deptname:%String,IntervalDr:%Integer,incomefee:%Float,costfee:%Float,amt:%Float,KSRS:%Float,monthorder:%Integer") [ SqlProc ]
{
}

/// Creator:ZJW
/// CreatDate:2015.5.12
/// Description: 取指定临床大科当年各月开单收入、开单药品收入、开单功检收入、执行收入和科室人数
/// Table:incomedatas    paramdatas  
/// Input:核算周期id  大科id
/// Output:    
/// Return://报表query
/// Others：d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","GetDKYaoGJDatas","1","10")
ClassMethod GetDKYaoGJDatasExecute(ByRef qHandle As %Binary, stdate As %String, deptLevDR As %String) As %Status [ SqlProc ]
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
 	
 
	q:stdate="" $$$OK
	s Income="",Cost=""
	k ^temp($j,"zjwcbcs")
	i $d(^DHCCADEPTLEVELSETS(deptLevDR)) d
	.s deptname=$p(^DHCCADEPTLEVELSETS(deptLevDR),"^",2)
	//.s deptparentDR=$p(^DHCCADEPTLEVELSETS(deptLevDR),"^",7)		//取部门分层的父节点，便于区分是临床-8或医技-9
	
	
	i $d(^DHCCAACCOUNTMONTHS(stdate)) d
	.s month=$p(^DHCCAACCOUNTMONTHS(stdate),"^",2)
    .s monthQ=$p(month,"-",1)
    .s monthname=monthQ_""_"年度"
    
    s IntervalDr="" f  s IntervalDr=$o(^DHCCAACCOUNTMONTHS(IntervalDr))  q:IntervalDr=""  d
    .s desc=$p(^DHCCAACCOUNTMONTHS(IntervalDr),"^",2)
    .s mon=+$p(desc,"-",2)_""_"月"
    .s desc1=$p(desc,"-",1)
    .q:desc1'=monthQ 
    .s monthorder=+$p(desc,"-",2)
    .s ^temp($j,"zjwcbcs",IntervalDr)=$g(^temp($j,"zjwcbcs",IntervalDr))
    .s dept="" f  s dept=$o(^DHCCADEPTLEVELSETS(0,"Dept",deptLevDR,dept)) q:dept=""  d
    ..s RowIdIncomef="" f  s RowIdIncomef=$o(^DHCCAINCOMEDATAS(0,"IntervalFdeptdr",IntervalDr,dept,RowIdIncomef)) q:RowIdIncomef=""  d
    ...s Incomef=$p(^DHCCAINCOMEDATAS(RowIdIncomef),"^",7)
    ...s ^temp($j,"zjwcbcs",IntervalDr,"Incomef")=$g(^temp($j,"zjwcbcs",IntervalDr,"Incomef"))+Incomef	//取开单收入
	...s ItemF=$p(^DHCCAINCOMEDATAS(RowIdIncomef),"^",6)
	...s tDeptDr=$p(^DHCCAINCOMEDATAS(RowIdIncomef),"^",14)
	...;i $d(^DHCCADATALEVELSETS(0,"Item",33,ItemF)) d
	...i $d(^DHCCADEPTLEVELSETS(0,"Dept",93,tDeptDr)) d
	....s ^temp($j,"zjwcbcs",IntervalDr,"IncomefGJ")=$g(^temp($j,"zjwcbcs",IntervalDr,"IncomefGJ"))+Incomef	//取开单功检收入
	...i $d(^DHCCADATALEVELSETS(0,"Item",3,ItemF)) d
	....s ^temp($j,"zjwcbcs",IntervalDr,"IncomefYP")=$g(^temp($j,"zjwcbcs",IntervalDr,"IncomefYP"))+Incomef	//取开单药品收入
	..s RowIdIncomet="" f  s RowIdIncomet=$o(^DHCCAINCOMEDATAS(0,"IntervalTdeptdr",IntervalDr,dept,RowIdIncomet)) q:RowIdIncomet=""  d
    ...s Incomet=$p(^DHCCAINCOMEDATAS(RowIdIncomet),"^",7)
    ...s ^temp($j,"zjwcbcs",IntervalDr,"Incomet")=$g(^temp($j,"zjwcbcs",IntervalDr,"Incomet"))+Incomet	//取执行收入
    ..s RowIdParam="" f  s RowIdParam=$o(^DHCCAPARAMDATAS(0,"IntervalSereddepItem",IntervalDr,dept,139,RowIdParam)) q:RowIdParam=""  d
    ...s ParamKSRS=$p(^DHCCAPARAMDATAS(RowIdParam),"^",11)
    ...s ^temp($j,"zjwcbcs",IntervalDr,"ParamKSRS")=$g(^temp($j,"zjwcbcs",IntervalDr,"ParamKSRS"))+ParamKSRS  //取科室人数
   
    .s Incomef=$g(^temp($j,"zjwcbcs",IntervalDr,"Incomef"))
    .s IncomefGJ=$g(^temp($j,"zjwcbcs",IntervalDr,"IncomefGJ"))
    .s IncomefYP=$g(^temp($j,"zjwcbcs",IntervalDr,"IncomefYP"))
     
    .s Incomet=$g(^temp($j,"zjwcbcs",IntervalDr,"Incomet")) 
    .s ParamKSRS=$g(^temp($j,"zjwcbcs",IntervalDr,"ParamKSRS"))
 	.d OutputRow61
    
    k ^temp($j,"zjwcbcs")
 	q $$$OK
OutputRow61
	;
  	s Data=$lb($g(monthname),$g(mon),deptname,IntervalDr,$g(Incomef),$g(IncomefGJ),$g(IncomefYP),$g(Incomet),$g(ParamKSRS),$g(monthorder))
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetDKYaoGJDatasFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDKYaoGJDatasExecute, SqlProc ]
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

ClassMethod GetDKYaoGJDatasClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDKYaoGJDatasExecute, SqlProc ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetDKYaoGJDatas(stdate As %String, deptLevDR As %String) As %Query(ROWSPEC = "monthname:%String,mon:%String,deptname:%String,IntervalDr:%Integer,Incomef:%Float,IncomefGJ:%Float,IncomefYP:%Float,Incomet:%Float,ParamKSRS:%Float,monthorder:%Integer") [ SqlProc ]
{
}

/// Creator:ZJW
/// CreatDate:2015.5.18
/// Description: 取指定临床大科当年各月门诊人次、门诊收入、门诊全成本、住院床日、住院收入、住院全成本
/// Table:incomedatas  costresultsum  paramdatas  
/// Input:核算周期id  deptLevDR
/// Output:   
/// Return://报表query
/// Others：d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","GetLCDKMzZy","1","10")
ClassMethod GetLCDKMzZyExecute(ByRef qHandle As %Binary, stdate As %String, deptLevDR As %String) As %Status [ SqlProc ]
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
 	
 
	q:stdate="" $$$OK
	s Income="",Cost=""
	k ^temp($j,"zjwcbcs")
	i $d(^DHCCADEPTLEVELSETS(deptLevDR)) d
	.s deptname=$p(^DHCCADEPTLEVELSETS(deptLevDR),"^",2)
	//.s deptparentDR=$p(^DHCCADEPTLEVELSETS(deptLevDR),"^",7)		//取部门分层的父节点，便于区分是临床-8或医技-9
	
	
	i $d(^DHCCAACCOUNTMONTHS(stdate)) d
	.s month=$p(^DHCCAACCOUNTMONTHS(stdate),"^",2)
    .s monthQ=$p(month,"-",1)
    .s monthname=monthQ_""_"年度"
    
    s IntervalDr="" f  s IntervalDr=$o(^DHCCAACCOUNTMONTHS(IntervalDr))  q:IntervalDr=""  d
    .s desc=$p(^DHCCAACCOUNTMONTHS(IntervalDr),"^",2)
    .s mon=+$p(desc,"-",2)_""_"月"
    .s desc1=$p(desc,"-",1)
    .q:desc1'=monthQ 
    .s monthorder=+$p(desc,"-",2)
    .s ^temp($j,"zjwcbcs",IntervalDr)=$g(^temp($j,"zjwcbcs",IntervalDr))
    .s dept="" f  s dept=$o(^DHCCADEPTLEVELSETS(0,"Dept",deptLevDR,dept)) q:dept=""  d
    ..i $d(^DHCCAROLES(0,"RDDeptdr",1,dept)) d		//判断若是门诊科室   
    
    ...s RowIdParam="" f  s RowIdParam=$o(^DHCCAPARAMDATAS(0,"IntervalSereddepItem",IntervalDr,dept,141,RowIdParam)) q:RowIdParam=""  d
    ....s ParamMzrc=$p(^DHCCAPARAMDATAS(RowIdParam),"^",11)
    ....s ^temp($j,"zjwcbcs",IntervalDr,"ParamMzrc")=$g(^temp($j,"zjwcbcs",IntervalDr,"ParamMzrc"))+ParamMzrc  //取门诊人次
    
    ...s RowIdIncomef="" f  s RowIdIncomef=$o(^DHCCAINCOMEDATAS(0,"IntervalFdeptdr",IntervalDr,dept,RowIdIncomef)) q:RowIdIncomef=""  d
    ....s Incomef=$p(^DHCCAINCOMEDATAS(RowIdIncomef),"^",7)
    ....s ^temp($j,"zjwcbcs",IntervalDr,"IncomeMz")=$g(^temp($j,"zjwcbcs",IntervalDr,"IncomeMz"))+Incomef	//取门诊收入
    
    ...s RowIdCost=""  f  s RowIdCost=$o(^DHCCACOSTDISTSETS(1,"IntIDFlag",IntervalDr,dept,"leaf",RowIdCost)) q:RowIdCost=""   d
    ....s CostMz=$p(^DHCCACOSTDISTSETS(1,"CostResultSum",RowIdCost),"^",7) 
   	....s ^temp($j,"zjwcbcs",IntervalDr,"CostMz")=$g(^temp($j,"zjwcbcs",IntervalDr,"CostMz"))+CostMz		//取门诊全成本
    
    ..e  d
    ...s RowIdParam="" f  s RowIdParam=$o(^DHCCAPARAMDATAS(0,"IntervalSereddepItem",IntervalDr,dept,142,RowIdParam)) q:RowIdParam=""  d 
    ....s ParamZycr=$p(^DHCCAPARAMDATAS(RowIdParam),"^",11)
    ....s ^temp($j,"zjwcbcs",IntervalDr,"ParamZycr")=$g(^temp($j,"zjwcbcs",IntervalDr,"ParamZycr"))+ParamZycr  //取住院床日
    
    ...s RowIdIncomef="" f  s RowIdIncomef=$o(^DHCCAINCOMEDATAS(0,"IntervalFdeptdr",IntervalDr,dept,RowIdIncomef)) q:RowIdIncomef=""  d
    ....s Incomef=$p(^DHCCAINCOMEDATAS(RowIdIncomef),"^",7)
    ....s ^temp($j,"zjwcbcs",IntervalDr,"IncomeZy")=$g(^temp($j,"zjwcbcs",IntervalDr,"IncomeZy"))+Incomef	//取住院收入
    
    ...s RowIdCost=""  f  s RowIdCost=$o(^DHCCACOSTDISTSETS(1,"IntIDFlag",IntervalDr,dept,"leaf",RowIdCost)) q:RowIdCost=""   d
    ....s CostZy=$p(^DHCCACOSTDISTSETS(1,"CostResultSum",RowIdCost),"^",7) 
   	....s ^temp($j,"zjwcbcs",IntervalDr,"CostZy")=$g(^temp($j,"zjwcbcs",IntervalDr,"CostZy"))+CostZy			//取住院全成本
    
    .s ParamMzrc=$g(^temp($j,"zjwcbcs",IntervalDr,"ParamMzrc"))
    .s IncomeMz=$g(^temp($j,"zjwcbcs",IntervalDr,"IncomeMz"))
    .s CostMz=$g(^temp($j,"zjwcbcs",IntervalDr,"CostMz"))
    .s ParamZycr=$g(^temp($j,"zjwcbcs",IntervalDr,"ParamZycr"))
    .s IncomeZy=$g(^temp($j,"zjwcbcs",IntervalDr,"IncomeZy"))
    .s CostZy=$g(^temp($j,"zjwcbcs",IntervalDr,"CostZy"))
 	.d OutputRow62
    
    k ^temp($j,"zjwcbcs")
 	q $$$OK
OutputRow62
	;
  	s Data=$lb($g(monthname),$g(mon),deptname,IntervalDr,$g(ParamMzrc),$g(IncomeMz),$g(CostMz),$g(ParamZycr),$g(IncomeZy),$g(CostZy),$g(monthorder))
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetLCDKMzZyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLCDKMzZyExecute, SqlProc ]
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

ClassMethod GetLCDKMzZyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLCDKMzZyExecute, SqlProc ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetLCDKMzZy(stdate As %String, deptLevDR As %String) As %Query(ROWSPEC = "monthname:%String,mon:%String,deptname:%String,IntervalDr:%Integer,ParamMzrc:%Float,IncomeMz:%Float,CostMz:%Float,ParamZycr:%Float,IncomeZy:%Float,CostZy:%Float,monthorder:%Integer") [ SqlProc ]
{
}

/// Creator:ZJW
/// CreatDate:2015.5.18
/// Description: 取大科当年收入趋势
/// Table:incomedatas   
/// Input:核算周期id  大科id
/// Output:
/// Return://报表query
/// Others：d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","GetDKIncomeDatas","1","65")
ClassMethod GetDKIncomeDatasExecute(ByRef qHandle As %Binary, stdate As %String, deptLevDR As %String) As %Status [ SqlProc ]
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
 	
 
	q:stdate="" $$$OK
	s Income="",Cost=""
	k ^temp($j,"zjwcbcs")
	i $d(^DHCCADEPTLEVELSETS(deptLevDR)) d
	.s deptname=$p(^DHCCADEPTLEVELSETS(deptLevDR),"^",2)
	.s deptparentDR=$p(^DHCCADEPTLEVELSETS(deptLevDR),"^",7)		//取部门分层的父节点，便于区分是临床-8或医技-9
	
	
	i $d(^DHCCAACCOUNTMONTHS(stdate)) d
	.s month=$p(^DHCCAACCOUNTMONTHS(stdate),"^",2)
    .s monthQ=$p(month,"-",1)
    .s monthname=monthQ_""_"年度"
    
    s IntervalDr="" f  s IntervalDr=$o(^DHCCAACCOUNTMONTHS(IntervalDr))  q:IntervalDr=""  d
    .s desc=$p(^DHCCAACCOUNTMONTHS(IntervalDr),"^",2)
    .s mon=+$p(desc,"-",2)_""_"月"
    .s desc1=$p(desc,"-",1)
    .q:desc1'=monthQ 
    .s monthorder=+$p(desc,"-",2)
    .s ^temp($j,"zjwcbcs",IntervalDr)=$g(^temp($j,"zjwcbcs",IntervalDr))
    .//s IntervalDr=RowId
    .s dept="" f  s dept=$o(^DHCCADEPTLEVELSETS(0,"Dept",deptLevDR,dept)) q:dept=""  d
    ..i deptparentDR=8 d  //临床科室分层取开单收入
    ...s RowIdIncome="" f  s RowIdIncome=$o(^DHCCAINCOMEDATAS(0,"IntervalFdeptdr",IntervalDr,dept,RowIdIncome)) q:RowIdIncome=""  d
    ....s Incomef=$p(^DHCCAINCOMEDATAS(RowIdIncome),"^",7)
    ....s ItemF=$p(^DHCCAINCOMEDATAS(RowIdIncome),"^",6)
    ....s HSIncomeorder="" f  s HSIncomeorder=$o(^DHCCADATALEVELSETS(0,"Parent",6,HSIncomeorder)) q:HSIncomeorder=""  d
    .....s HSIncomeDR=""
    .....s HSIncomeDR=$o(^DHCCADATALEVELSETS(0,"Parent",6,HSIncomeorder,HSIncomeDR))		// 3-收入分类  only one
    .....i $d(^DHCCADATALEVELSETS(0,"Item",HSIncomeDR,ItemF)) d
    ......s ^temp($j,"zjwcbcs",IntervalDr,"Income",HSIncomeDR)=$g(^temp($j,"zjwcbcs",IntervalDr,"Income",HSIncomeDR))+Incomef	//取收入

    ..i deptparentDR=9 d  //医技科室取执行收入
    ...s RowIdIncome="" f  s RowIdIncome=$o(^DHCCAINCOMEDATAS(0,"IntervalTdeptdr",IntervalDr,dept,RowIdIncome)) q:RowIdIncome=""  d
    ....s Incomet=$p(^DHCCAINCOMEDATAS(RowIdIncome),"^",7)
    ....s ItemF=$p(^DHCCAINCOMEDATAS(RowIdIncome),"^",6)
    ....s HSIncomeorder="" f  s HSIncomeorder=$o(^DHCCADATALEVELSETS(0,"Parent",6,HSIncomeorder)) q:HSIncomeorder=""  d
    .....s HSIncomeDR=""
    .....s HSIncomeDR=$o(^DHCCADATALEVELSETS(0,"Parent",6,HSIncomeorder,HSIncomeDR))		// 3-收入分类  only one
    .....i $d(^DHCCADATALEVELSETS(0,"Item",HSIncomeDR,ItemF)) d
    ......s ^temp($j,"zjwcbcs",IntervalDr,"Income",HSIncomeDR)=$g(^temp($j,"zjwcbcs",IntervalDr,"Income",HSIncomeDR))+Incomet	//取收入

    .s HSItemDR="" f  s HSItemDR=$o(^temp($j,"zjwcbcs",IntervalDr,"Income",HSItemDR)) q:HSItemDR=""  d
    ..s HSItemName=$p(^DHCCADATALEVELSETS(HSItemDR),"^",2)
    ..s incomefee=$g(^temp($j,"zjwcbcs",IntervalDr,"Income",HSItemDR)) 
 	..d OutputRow63
    
    k ^temp($j,"zjwcbcs")
 	q $$$OK
OutputRow63
	;
  	s Data=$lb($g(monthname),$g(mon),deptname,IntervalDr,$g(HSItemDR),HSItemName,$g(incomefee),$g(monthorder))
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetDKIncomeDatasFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDKIncomeDatasExecute, SqlProc ]
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

ClassMethod GetDKIncomeDatasClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDKIncomeDatasExecute, SqlProc ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetDKIncomeDatas(stdate As %String, deptLevDR As %String) As %Query(ROWSPEC = "monthname:%String,mon:%String,deptname:%String,IntervalDr:%Integer,HSItemDR:%Integer,HSItemName:%String,incomefee:%Float,monthorder:%Integer") [ SqlProc ]
{
}

/// Creator:ZJW
/// CreatDate:2015.5.18
/// Description: 取大科当年成本趋势
/// Table:incomedatas   
/// Input:核算周期id  大科id
/// Output:
/// Return://报表query
/// Others：d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","GetDKDeptCost","1","65")
ClassMethod GetDKDeptCostExecute(ByRef qHandle As %Binary, stdate As %String, deptLevDR As %String) As %Status [ SqlProc ]
{
                            
	Set repid=$I(^CacheTemp) 
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
 	
	q:stdate="" $$$OK
	q:deptLevDR="" $$$OK
	
	k ^temp($j,"zjwcbcs") 
	i $d(^DHCCADEPTLEVELSETS(deptLevDR)) d
	.s deptname=$p(^DHCCADEPTLEVELSETS(deptLevDR),"^",2)
	
	i $d(^DHCCAACCOUNTMONTHS(stdate)) d
	.s month=$p(^DHCCAACCOUNTMONTHS(stdate),"^",2)
    .s monthQ=$p(month,"-",1)
    .s monthname=monthQ_""_"年度"
    
    s IntervalDr="" f  s IntervalDr=$o(^DHCCAACCOUNTMONTHS(IntervalDr))  q:IntervalDr=""  d
    .s desc=$p(^DHCCAACCOUNTMONTHS(IntervalDr),"^",2)
    .s desc1=$p(desc,"-",1)
    .q:desc1'=monthQ
    .s ^temp($j,"zjwcbcs",IntervalDr)=$g(^temp($j,"zjwcbcs",IntervalDr))
	.s dept="" f  s dept=$o(^DHCCADEPTLEVELSETS(0,"Dept",deptLevDR,dept)) q:dept=""  d
	..s ChidSub="" f  s ChidSub=$o(^DHCCACOSTDISTSETS(0,"DIntDistdept",1,IntervalDr,dept,ChidSub)) q:ChidSub=""  d
	...s distflag=$p(^DHCCACOSTDISTSETS("1","CostResultData",ChidSub),"^",6) q:distflag'="self"
	...s itemdata=$p(^DHCCACOSTDISTSETS(1,"CostResultData",ChidSub),"^",4)
    ...s datafee=$p(^DHCCACOSTDISTSETS("1","CostResultData",ChidSub),"^",5)
    ...s depted=$p(^DHCCACOSTDISTSETS("1","CostResultData",ChidSub),"^",2)  //CostResultData_distedDeptDr
	...s RowId1="" f  s RowId1=$o(^DHCCADATALEVELSETS(RowId1))  q:RowId1=""  d
	....s parent=$p(^DHCCADATALEVELSETS(RowId1),"^",7) q:parent'=25  //新会计制度分类
	....q:'$d(^DHCCADATALEVELSETS(0,"Item",RowId1,itemdata))
    ....i depted="" s ^temp($j,"zjwcbcs",IntervalDr,deptLevDR,distflag,RowId1,itemdata)=$g(^temp($j,"depted",deptLevDR,distflag,RowId1,itemdata))+datafee
    
    s monthDr="" f  s monthDr=$o(^temp($j,"zjwcbcs",monthDr)) q:monthDr=""  d
    .s costflag=0 f  s costflag=$o(^temp($j,"zjwcbcs",monthDr,deptLevDR,costflag)) q:costflag=""  d							//分摊标记
    ..s costdatafc=0 f  s costdatafc=$o(^temp($j,"zjwcbcs",monthDr,deptLevDR,costflag,costdatafc)) q:costdatafc=""  d		//分类
    ...s costitem=0 f  s costitem=$o(^temp($j,"zjwcbcs",monthDr,deptLevDR,costflag,costdatafc,costitem)) q:costitem=""  d		//分类项目
    ....s costsum=$g(^temp($j,"zjwcbcs",monthDr,deptLevDR,costflag,costdatafc,costitem))		//金额
    ....s costfenc=""
    ....d OutputRow64
    
    
    s IntervalDr="" f  s IntervalDr=$o(^DHCCAACCOUNTMONTHS(IntervalDr))  q:IntervalDr=""  d
    .s desc=$p(^DHCCAACCOUNTMONTHS(IntervalDr),"^",2)
    .s desc1=$p(desc,"-",1)
    .q:desc1'=monthQ 
	.s dept="" f  s dept=$o(^DHCCADEPTLEVELSETS(0,"Dept",deptLevDR,dept)) q:dept=""  d
	..s ChidSub="" f  s ChidSub=$o(^DHCCACOSTDISTSETS(0,"DIntDistdept",1,IntervalDr,dept,ChidSub)) q:ChidSub=""  d
	...s distflag=$p(^DHCCACOSTDISTSETS("1","CostResultData",ChidSub),"^",6) q:distflag'="dist"
	...s depted=$p(^DHCCACOSTDISTSETS("1","CostResultData",ChidSub),"^",2)  q:depted="" //CostResultData_distedDeptDr
	...s itemdata=$p(^DHCCACOSTDISTSETS(1,"CostResultData",ChidSub),"^",4)
    ...s datafee=$p(^DHCCACOSTDISTSETS("1","CostResultData",ChidSub),"^",5)
	...s RowIdB2="" f  s RowIdB2=$o(^DHCCADATALEVELSETS(RowIdB2))  q:RowIdB2=""  d
	....s parent=$p(^DHCCADATALEVELSETS(RowIdB2),"^",7) q:parent'=25  //新会计制度分类
	....q:'$d(^DHCCADATALEVELSETS(0,"Item",RowIdB2,itemdata))
	....s RowIdB1="" f  s RowIdB1=$o(^DHCCADEPTLEVELSETS(0,"Parent",1,RowIdB1))  q:RowIdB1=""  d	//父节点为1的分层DR
	.....s depchild="" f  s depchild=$o(^DHCCADEPTLEVELSETS(0,"Dept",RowIdB1,depted,depchild))  q:depchild=""  d	//判断该分层下有没有对应的分摊科室 depted
	......s ^temp($j,"zjwcbcs",IntervalDr,deptLevDR,distflag,RowIdB2,itemdata,RowIdB1)=$g(^temp($j,"zjwcbcs",IntervalDr,deptLevDR,RowIdB2,itemdata,RowIdB1))+datafee
     
    s monthDr="" f  s monthDr=$o(^temp($j,"zjwcbcs",monthDr)) q:monthDr=""  d
    .s costflag=0 f  s costflag=$o(^temp($j,"zjwcbcs",monthDr,deptLevDR,costflag)) q:costflag=""  d
    ..s costdatafc=0 f  s costdatafc=$o(^temp($j,"zjwcbcs",monthDr,deptLevDR,costflag,costdatafc)) q:costdatafc=""  d					//分类
    ...s costitem=0 f  s costitem=$o(^temp($j,"zjwcbcs",monthDr,deptLevDR,costflag,costdatafc,costitem)) q:costitem=""  d				//分类项目
    ....s costfenc=0 f  s costfenc=$o(^temp($j,"zjwcbcs",monthDr,deptLevDR,costflag,costdatafc,costitem,costfenc))  q:costfenc=""  d		//分摊部门的分层DR
    .....s costsum=$g(^temp($j,"zjwcbcs",monthDr,deptLevDR,costflag,costdatafc,costitem,costfenc))
	.....d OutputRow64 
    
    k ^temp($j,"zjwcbcs")       
   q $$$OK
	
OutputRow64
	s monthdesc=$p(^DHCCAACCOUNTMONTHS(monthDr),"^",2)
    s mon=+$p(monthdesc,"-",2)_""_"月"
    s monthorder=+$p(monthdesc,"-",2)
    
    s datafcname=$p(^DHCCADATALEVELSETS(costdatafc),"^",2)  
    i $d(^DHCCAALLDATAITEMS(costitem)) s ItemDesc=$P(^DHCCAALLDATAITEMS(costitem),"^",3)
    
    i costfenc="" s costfencname="直接成本"
	i costfenc=2 s costfencname="公用分摊"
	i costfenc=3 s costfencname="管理分摊"
	i costfenc=4 s costfencname="医辅分摊"
	i costfenc=5 s costfencname="医技分摊"
	
	s Data=$lb(monthname,mon,monthorder,costdatafc,datafcname,costitem,ItemDesc,deptname,costflag,$g(costfenc),costfencname,$g(costsum))
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetDKDeptCostFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDKDeptCostExecute, SqlProc ]
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

ClassMethod GetDKDeptCostClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDKDeptCostExecute, SqlProc ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetDKDeptCost(stdate As %String, deptLevDR As %String) As %Query(ROWSPEC = "monthname:%String,mon:%String,monthorder:%Integer,costdatafc:%Integer,datafcname:%String,costitem:%Integer,ItemDesc:%String,deptname:%String,costflag:%String,costfenc:%String,costfencname:%String,costsum:%Float") [ SqlProc ]
{
}

//冀州报表需求

//-----------------------------------------------

//临床科室直接成本利润表

/// Creator: liuyuanfang   20140617 zjw 修改
/// CreatDate: 2014-5-28
/// Description: 用户信息Query
/// Others:d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","GetfDepProfit","36","36")
Query GetfDepProfit(stdate As %String, endate As %String) As %Query(ROWSPEC = "monthname1:%String,monthname2:%String,RoleDr:%String,RoleName:%String,deptDr:%String,DeptCode:%String,DeptName:%String,AcuPeriodIncome:%String,AcuPeriodCost:%String,Profit:%String,Paramvalue:%String") [ SqlProc ]
{
}

ClassMethod GetfDepProfitExecute(ByRef qHandle As %Binary, stdate As %String, endate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	q:stdate="" $$$OK
	q:endate="" $$$OK
	
	s stmonth=$p(^DHCCAACCOUNTMONTHS(stdate),"^",2)
    s stdatecode=$p(^DHCCAACCOUNTMONTHS(stdate),"^",1)
    s month1=$p(stmonth,"-",1)
    s day1=$p(stmonth,"-",2)
    s monthname1=month1_""_"年"_""_day1_""_"月"
    
    s enmonth=$p(^DHCCAACCOUNTMONTHS(endate),"^",2)
    s endatecode=$p(^DHCCAACCOUNTMONTHS(endate),"^",1)
    s month2=$p(enmonth,"-",1)
    s day2=$p(enmonth,"-",2)
    s monthname2=month2_""_"年"_""_day2_""_"月"
    q:stdatecode>endatecode
    
    &SQL(SELECT alldataitems_rowid into:itemId FROM dhc_ca_cache_data.alldataitems where alldataitems_name ='科室人数')
	/* zjw 从部门分层套中取科室 收入全部按开单
       s sqlStr="SELECT LevelDepts_deptDr,LevelDepts_deptDr->unitdepts_code AS DeptCode ,LevelDepts_deptDr->unitdepts_name AS DeptName ,"
             _"(select  case  when Sum(IncomeDatas_fee) is  null then 0 else Sum(IncomeDatas_fee) end FROM dhc_ca_cache_data.IncomeDatas  WHERE  IncomeDatas_fDeptDr= LevelDepts_deptDr AND  IncomeDatas_intervalDr BETWEEN '"_stdate_"' AND '"_endate_"') AS AcuPeriodIncome,"
         	 _"(select  case  when Sum(VouchDatas_debit) is  null then 0 else Sum(VouchDatas_debit) end FROM dhc_ca_cache_data.VouchDatas  where VouchDatas_deptDr=LevelDepts_deptDr and VouchDatas_intervalDr BETWEEN '"_stdate_"' AND '"_endate_"') AS AcuPeriodCost,"
			 _"(select  case  when Sum(ParamDatas_value) is  null then 0 else Sum(ParamDatas_value) end FROM dhc_ca_cache_data.ParamDatas  where ParamDatas_servedDeptDr=LevelDepts_deptDr and ParamDatas_intervalDr BETWEEN '"_stdate_"' AND '"_endate_"' and ParamDatas_itemDr='"_itemId_"') AS Paramvalue "
 			 _" FROM dhc_ca_cache_data.LevelDepts WHERE LevelDepts_parRef=7 AND LevelDepts_childSub>0 " 
             _" order by LevelDepts_deptDr asc"
             
         //LevelDepts_parRef=7 部门分层套临床医疗科室分层DR
    */
    //zjw 从角色维护中取科室  门诊收入按开单科室  住院科室按病人科室
    s sqlStr="SELECT RDepts_parRef,RDepts_parRef->Roles_name,RDepts_deptDr,RDepts_deptDr->UnitDepts_code,RDepts_deptDr->UnitDepts_name "
			_" ,(SELECT isnull(Sum(IncomeDatas_fee),0) FROM dhc_ca_cache_data.IncomeDatas  WHERE decode(sign(RDepts_parRef-1),0,IncomeDatas_fDeptDr,IncomeDatas_patDeptDr)= RDepts_deptDr AND  IncomeDatas_intervalDr BETWEEN '"_stdate_"' AND '"_endate_"') AS AcuPeriodIncome "
			_" ,(select isnull(Sum(VouchDatas_debit),0) FROM dhc_ca_cache_data.VouchDatas  where VouchDatas_deptDr=RDepts_deptDr and VouchDatas_intervalDr BETWEEN '"_stdate_"' AND '"_endate_"') AS AcuPeriodCost "
			_" ,(select isnull(Sum(ParamDatas_value),0) FROM dhc_ca_cache_data.ParamDatas  where ParamDatas_servedDeptDr=RDepts_deptDr and ParamDatas_intervalDr BETWEEN '"_stdate_"' AND '"_endate_"' and ParamDatas_itemDr='"_itemId_"') AS Paramvalue " 
 			_" FROM dhc_ca_cache_data.Rdepts  WHERE RDepts_parRef IN ('1','2') AND RDepts_childSub>0 " 
 			_" order by RDepts_parRef asc "   
 			 
 	// RDepts_parRef IN ('1','2') 门诊、住院角色ID
 	
 			
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	;w sqlStr,!
	d result.Execute()	
    While(result.Next()){
	  s RoleDr=result.Data("RDepts_parRef")
	  s RoleName=result.Data("Roles_name")
	  s deptDr=result.Data("RDepts_deptDr")
	  s DeptCode=result.Data("UnitDepts_code")
      s DeptName=result.Data("UnitDepts_name")
      s AcuPeriodIncome=result.Data("AcuPeriodIncome")
      s AcuPeriodCost=result.Data("AcuPeriodCost")
      s Profit=AcuPeriodIncome-AcuPeriodCost
      s Paramvalue=result.Data("Paramvalue")
	 d OutputRow65	  
	}
	
 	q $$$OK
OutputRow65
	q:(AcuPeriodIncome=0)&&(AcuPeriodCost=0)&&(Paramvalue=0)   //zjw 20140618 增加
 	s Data=$lb(monthname1,monthname2,RoleDr,RoleName,deptDr,DeptCode,DeptName,$g(AcuPeriodIncome),$g(AcuPeriodCost),$g(Profit),$g(Paramvalue))
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod GetfDepProfitFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetfDepProfitExecute ]
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

ClassMethod GetfDepProfitClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetfDepProfitExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

//医技执行科室直接成本利润表

/// Creator: liuyuanfang  20140617 zjw 修改
/// CreatDate: 2014-5-28
/// Description: 用户信息Query
/// Others:d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","GettDepProfit","36","36")
Query GettDepProfit(stdate As %String, endate As %String) As %Query(ROWSPEC = "monthname1:%String,monthname2:%String,LevelName:%String,deptDr:%String,DeptCode:%String,DeptName:%String,AcuPeriodIncome:%String,AcuPeriodCost:%String,Profit:%String,Paramvalue:%String") [ SqlProc ]
{
}

ClassMethod GettDepProfitExecute(ByRef qHandle As %Binary, stdate As %String, endate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	q:stdate="" $$$OK
	q:endate="" $$$OK
	
	i $d(^DHCCAACCOUNTMONTHS(stdate)) d
	.s stmonth=$p(^DHCCAACCOUNTMONTHS(stdate),"^",2)
    .s stdatecode=$p(^DHCCAACCOUNTMONTHS(stdate),"^",1)
    .s month1=$p(stmonth,"-",1)
    .s day1=$p(stmonth,"-",2)
    .s monthname1=month1_""_"年"_""_day1_""_"月"
    
    i $d(^DHCCAACCOUNTMONTHS(endate)) d
    .s enmonth=$p(^DHCCAACCOUNTMONTHS(endate),"^",2)
    .s endatecode=$p(^DHCCAACCOUNTMONTHS(endate),"^",1)
    .s month2=$p(enmonth,"-",1)
    .s day2=$p(enmonth,"-",2)
    .s monthname2=month2_""_"年"_""_day2_""_"月"
    q:stdatecode>endatecode
    
    &SQL(SELECT alldataitems_rowid into:itemId FROM dhc_ca_cache_data.alldataitems where alldataitems_name ='科室人数')
	/*
	s sqlStr="select  distinct DeptLevelSets_remark, IncomeDatas_tDeptDr->unitdepts_code as IncomeDatas_tDeptCode,IncomeDatas_tDeptDr->unitdepts_name as IncomeDatas_tDeptName,Sum(IncomeDatas_fee) as AcuPeriodIncome,"
            _"(select  case  when Sum(VouchDatas_debit) is  null then 0 else Sum(VouchDatas_debit) end FROM dhc_ca_cache_data.VouchDatas  where VouchDatas_deptDr=IncomeDatas_tDeptDr and VouchDatas_intervalDr>='"_stdate_"' and VouchDatas_intervalDr<='"_endate_"') as AcuPeriodOutcome,"
            _"(select  case  when Sum(ParamDatas_value) is  null then 0 else Sum(ParamDatas_value) end FROM dhc_ca_cache_data.ParamDatas  where ParamDatas_servedDeptDr=IncomeDatas_tDeptDr and ParamDatas_intervalDr>='"_stdate_"' and ParamDatas_intervalDr<='"_endate_"' and ParamDatas_itemDr='"_itemId_"') as Paramvalue"
            _" from dhc_ca_cache_data.IncomeDatas,dhc_ca_cache_data.LevelDepts,dhc_ca_cache_data.DeptLevelSets "
            _" where  IncomeDatas_intervalDr>='"_stdate_"' and IncomeDatas_intervalDr<='"_endate_"' and IncomeDatas_tDeptDr=LevelDepts_DeptDr and LevelDepts_parRef=DeptLevelSets_rowid and DeptLevelSets_parent=1 and leveldepts_childSub<>0"
            _" group by IncomeDatas_tDeptDr"
            _" order by IncomeDatas_tDeptDr asc"   
    */
        s sqlStr="SELECT distinct LevelDepts_parRef->DeptLevelSets_name, LevelDepts_deptDr,LevelDepts_deptDr->unitdepts_code AS DeptCode ,LevelDepts_deptDr->unitdepts_name AS DeptName ,"
             _"(select  case  when Sum(IncomeDatas_fee) is  null then 0 else Sum(IncomeDatas_fee) end FROM dhc_ca_cache_data.IncomeDatas  WHERE  IncomeDatas_tDeptDr= LevelDepts_deptDr AND  IncomeDatas_intervalDr BETWEEN '"_stdate_"' AND '"_endate_"') AS AcuPeriodIncome,"
         	 _"(select  case  when Sum(VouchDatas_debit) is  null then 0 else Sum(VouchDatas_debit) end FROM dhc_ca_cache_data.VouchDatas  where VouchDatas_deptDr=LevelDepts_deptDr and VouchDatas_intervalDr BETWEEN '"_stdate_"' AND '"_endate_"') AS AcuPeriodCost,"
			 _"(select  case  when Sum(ParamDatas_value) is  null then 0 else Sum(ParamDatas_value) end FROM dhc_ca_cache_data.ParamDatas  where ParamDatas_servedDeptDr=LevelDepts_deptDr and ParamDatas_intervalDr BETWEEN '"_stdate_"' AND '"_endate_"' and ParamDatas_itemDr='"_itemId_"') AS Paramvalue "
 			 _" FROM dhc_ca_cache_data.LevelDepts WHERE LevelDepts_parRef=5 AND LevelDepts_childSub>0 " 
             _" order by LevelDepts_parRef DESC , LevelDepts_deptDr asc"   
 			 
 	        // LevelDepts_parRef=5 部门分层套医技科室分层DR
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	;w sqlStr,!
	d result.Execute()	
    While(result.Next()){
	  s LevelName=result.Data("DeptLevelSets_name")
	  s deptDr=result.Data("LevelDepts_deptDr")
	  s DeptCode=result.Data("DeptCode")
      s DeptName=result.Data("DeptName")
      s AcuPeriodIncome=result.Data("AcuPeriodIncome")
      s AcuPeriodCost=result.Data("AcuPeriodCost")
      s Profit=AcuPeriodIncome-AcuPeriodCost
      s Paramvalue=result.Data("Paramvalue")
	 d OutputRow66	  
	}
	
 	q $$$OK
OutputRow66
	q:(AcuPeriodIncome=0)&&(AcuPeriodCost=0)&&(Paramvalue=0)   //zjw 20140618 增加
 	s Data=$lb(monthname1,monthname2,LevelName,deptDr,DeptCode,DeptName,$g(AcuPeriodIncome),$g(AcuPeriodCost),$g(Profit),$g(Paramvalue))
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod GettDepProfitFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GettDepProfitExecute ]
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

ClassMethod GettDepProfitClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GettDepProfitExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

//全成本利润月报--临床

/// Creator: liuyuanfang    20140617 zjw 修改
/// CreatDate: 2014-5-29
/// Description: 用户信息Query
/// Others:d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","GetfSumDepProfit","36","36")
Query GetfSumDepProfit(stdate As %String, endate As %String) As %Query(ROWSPEC = "monthname1:%String,monthname2:%String,RoleDr:%String,RoleName:%String,deptDr:%String,DeptCode:%String,DeptName:%String,AcuPeriodIncome:%String,AcuPeriodCost:%String,Profit:%String,Paramvalue1:%String,Paramvalue2:%String,Paramvalue3:%String") [ SqlProc ]
{
}

ClassMethod GetfSumDepProfitExecute(ByRef qHandle As %Binary, stdate As %String, endate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	q:stdate="" $$$OK
	q:endate="" $$$OK
	
	i $d(^DHCCAACCOUNTMONTHS(stdate)) d
	.s stmonth=$p(^DHCCAACCOUNTMONTHS(stdate),"^",2)
    .s stdatecode=$p(^DHCCAACCOUNTMONTHS(stdate),"^",1)
    .s month1=$p(stmonth,"-",1)
    .s day1=$p(stmonth,"-",2)
    .s monthname1=month1_""_"年"_""_day1_""_"月"
    
    i $d(^DHCCAACCOUNTMONTHS(endate)) d
    .s enmonth=$p(^DHCCAACCOUNTMONTHS(endate),"^",2)
    .s endatecode=$p(^DHCCAACCOUNTMONTHS(endate),"^",1)
    .s month2=$p(enmonth,"-",1)
    .s day2=$p(enmonth,"-",2)
    .s monthname2=month2_""_"年"_""_day2_""_"月"
    
    q:stdatecode>endatecode
    
    &SQL(SELECT alldataitems_rowid into:itemId1 FROM dhc_ca_cache_data.alldataitems where alldataitems_name ='科室人数')
    &SQL(SELECT alldataitems_rowid into:itemId2 FROM dhc_ca_cache_data.alldataitems where alldataitems_name ='住院床日')
    &SQL(SELECT alldataitems_rowid into:itemId3 FROM dhc_ca_cache_data.alldataitems where alldataitems_name ='门诊人次')
	/*  //zjw  从部门分层套中取科室 收入全部按开单
       s sqlStr="SELECT LevelDepts_deptDr,LevelDepts_deptDr->unitdepts_code AS DeptCode ,LevelDepts_deptDr->unitdepts_name AS DeptName ,"
			_" (select  case  when Sum(IncomeDatas_fee) is  null then 0 else Sum(IncomeDatas_fee) end FROM dhc_ca_cache_data.IncomeDatas  WHERE IncomeDatas_fDeptDr= LevelDepts_deptDr AND  IncomeDatas_intervalDr BETWEEN '"_stdate_"' AND '"_endate_"') AS AcuPeriodIncome,"
			_" (select  case  when Sum(CostResultSum_sum) is  null then 0 else Sum(CostResultSum_sum) end FROM dhc_ca_cache_data.CostResultSum  where  CostResultSum_blDr=LevelDepts_deptDr and CostResultSum_intervalDr BETWEEN '"_stdate_"' AND '"_endate_"' AND CostResultSum_parRef=1 AND CostResultSum_branchFlag='leaf' ) as AcuPeriodCost,"
			_" (select  case  when Sum(ParamDatas_value) is  null then 0 else Sum(ParamDatas_value) end FROM dhc_ca_cache_data.ParamDatas where ParamDatas_servedDeptDr=LevelDepts_deptDr and ParamDatas_intervalDr BETWEEN '"_stdate_"' AND '"_endate_"' and ParamDatas_itemDr='"_itemId1_"') as Paramvalue1,"
			_" (select  case  when Sum(ParamDatas_value) is  null then 0 else Sum(ParamDatas_value) end FROM dhc_ca_cache_data.ParamDatas where ParamDatas_servedDeptDr=LevelDepts_deptDr and ParamDatas_intervalDr BETWEEN '"_stdate_"' AND '"_endate_"' and ParamDatas_itemDr='"_itemId2_"') as Paramvalue2,"
			_" (select  case  when Sum(ParamDatas_value) is  null then 0 else Sum(ParamDatas_value) end FROM dhc_ca_cache_data.ParamDatas where ParamDatas_servedDeptDr=LevelDepts_deptDr and ParamDatas_intervalDr BETWEEN '"_stdate_"' AND '"_endate_"' and ParamDatas_itemDr='"_itemId3_"') as Paramvalue3 "
			_" FROM dhc_ca_cache_data.LevelDepts WHERE LevelDepts_parRef=7 AND LevelDepts_childSub>0 "
			_" order by LevelDepts_deptDr ASC " 
     
            //CostResultSum_parRef=1  全成本分摊DR  LevelDepts_parRef=7 部门分层套临床医疗科室分层DR
    */ 
    //zjw 从角色维护中取科室  门诊收入按开单科室  住院科室按病人科室
     s sqlStr="SELECT RDepts_parRef,RDepts_parRef->Roles_name,RDepts_deptDr,RDepts_deptDr->unitdepts_code AS DeptCode ,RDepts_deptDr->unitdepts_name AS DeptName ,"
			_" (select  isnull(Sum(IncomeDatas_fee),0)  FROM dhc_ca_cache_data.IncomeDatas  WHERE decode(sign(RDepts_parRef-1),0,IncomeDatas_fDeptDr,IncomeDatas_patDeptDr)= RDepts_deptDr AND  IncomeDatas_intervalDr BETWEEN '"_stdate_"' AND '"_endate_"') AS AcuPeriodIncome,"
			_" (select  isnull(Sum(CostResultSum_sum),0) FROM dhc_ca_cache_data.CostResultSum  where  CostResultSum_blDr=RDepts_deptDr and CostResultSum_intervalDr BETWEEN '"_stdate_"' AND '"_endate_"' AND CostResultSum_parRef=1 AND CostResultSum_branchFlag='leaf' ) as AcuPeriodCost,"
			_" (select  isnull(Sum(ParamDatas_value),0)  FROM dhc_ca_cache_data.ParamDatas where ParamDatas_servedDeptDr=RDepts_deptDr and ParamDatas_intervalDr BETWEEN '"_stdate_"' AND '"_endate_"' and ParamDatas_itemDr='"_itemId1_"') as Paramvalue1,"
			_" (select  isnull(Sum(ParamDatas_value),0)  FROM dhc_ca_cache_data.ParamDatas where ParamDatas_servedDeptDr=RDepts_deptDr and ParamDatas_intervalDr BETWEEN '"_stdate_"' AND '"_endate_"' and ParamDatas_itemDr='"_itemId2_"') as Paramvalue2,"
			_" (select  isnull(Sum(ParamDatas_value),0)  FROM dhc_ca_cache_data.ParamDatas where ParamDatas_servedDeptDr=RDepts_deptDr and ParamDatas_intervalDr BETWEEN '"_stdate_"' AND '"_endate_"' and ParamDatas_itemDr='"_itemId3_"') as Paramvalue3 "
 			_" FROM dhc_ca_cache_data.Rdepts  WHERE RDepts_parRef IN ('1','2') AND RDepts_childSub>0 " 
 			_" order by RDepts_parRef asc "   

     //RDepts_parRef IN ('1','2')  门诊、住院角色ID
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	;w sqlStr,!
	d result.Execute()	
    While(result.Next()){
	  s RoleDr=result.Data("RDepts_parRef")
	  s RoleName=result.Data("Roles_name")
	  s deptDr=result.Data("RDepts_deptDr")
	  s DeptCode=result.Data("DeptCode")
      s DeptName=result.Data("DeptName")
      s AcuPeriodIncome=result.Data("AcuPeriodIncome")
      s AcuPeriodCost=result.Data("AcuPeriodCost")
      s Profit=AcuPeriodIncome-AcuPeriodCost
      s Paramvalue1=result.Data("Paramvalue1")
      s Paramvalue2=result.Data("Paramvalue2")
      s Paramvalue3=result.Data("Paramvalue3")
	 d OutputRow67	  
	}
	
 	q $$$OK
OutputRow67
	q:(AcuPeriodIncome=0)&&(AcuPeriodCost=0)&&(Paramvalue1=0)&&(Paramvalue2=0)&&(Paramvalue3=0)   //zjw 20140618 增加
 	s Data=$lb(monthname1,monthname2,RoleDr,RoleName,deptDr,DeptCode,DeptName,$g(AcuPeriodIncome),$g(AcuPeriodCost),$g(Profit),$g(Paramvalue1),$g(Paramvalue2),$g(Paramvalue3))
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod GetfSumDepProfitFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetfSumDepProfitExecute ]
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

ClassMethod GetfSumDepProfitClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetfSumDepProfitExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

//全成本利润月报--医技执行

/// Creator: liuyuanfang  20140617 zjw 修改
/// CreatDate: 2014-5-29
/// Description: 用户信息Query
/// Others:d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","GettSumDepProfit","36","36")
Query GettSumDepProfit(stdate As %String, endate As %String) As %Query(ROWSPEC = "monthname1:%String,monthname2:%String,LevelName:%String,deptDr:%String,DeptCode:%String,DeptName:%String,AcuPeriodIncome:%String,AcuPeriodCost:%String,Profit:%String,Paramvalue:%String") [ SqlProc ]
{
}

ClassMethod GettSumDepProfitExecute(ByRef qHandle As %Binary, stdate As %String, endate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	q:stdate="" $$$OK
	q:endate="" $$$OK
	
	i $d(^DHCCAACCOUNTMONTHS(stdate)) d
	.s stmonth=$p(^DHCCAACCOUNTMONTHS(stdate),"^",2)
    .s stdatecode=$p(^DHCCAACCOUNTMONTHS(stdate),"^",1)
    .s month1=$p(stmonth,"-",1)
    .s day1=$p(stmonth,"-",2)
    .s monthname1=month1_""_"年"_""_day1_""_"月"
    
    i $d(^DHCCAACCOUNTMONTHS(endate)) d
    .s enmonth=$p(^DHCCAACCOUNTMONTHS(endate),"^",2)
    .s endatecode=$p(^DHCCAACCOUNTMONTHS(endate),"^",1)
    .s month2=$p(enmonth,"-",1)
    .s day2=$p(enmonth,"-",2)
    .s monthname2=month2_""_"年"_""_day2_""_"月"
    q:stdatecode>endatecode
    
    &SQL(SELECT alldataitems_rowid into:itemId FROM dhc_ca_cache_data.alldataitems where alldataitems_name ='科室人数')
    /*
	s sqlStr="select  distinct DeptLevelSets_remark, IncomeDatas_tDeptDr->unitdepts_code as IncomeDatas_tDeptCode,IncomeDatas_tDeptDr->unitdepts_name as IncomeDatas_tDeptName,Sum(IncomeDatas_fee) as AcuPeriodIncome,"
            _"(select  case  when Sum(CostResultSum_sum) is  null then 0 else Sum(CostResultSum_sum) end FROM dhc_ca_cache_data.CostResultSum  where  CostResultSum_blDr=IncomeDatas_fDeptDr and CostResultSum_intervalDr>='"_stdate_"' and CostResultSum_intervalDr<='"_endate_"') as AcuPeriodOutcome,"
            _"(select  case  when Sum(ParamDatas_value) is  null then 0 else Sum(ParamDatas_value) end FROM dhc_ca_cache_data.ParamDatas  where ParamDatas_servedDeptDr=IncomeDatas_fDeptDr and ParamDatas_intervalDr>='"_stdate_"' and ParamDatas_intervalDr<='"_endate_"' and ParamDatas_itemDr='"_itemId_"') as Paramvalue" 
            _" from dhc_ca_cache_data.IncomeDatas,dhc_ca_cache_data.LevelDepts,dhc_ca_cache_data.DeptLevelSets "
            _" where  IncomeDatas_intervalDr>='"_stdate_"' and IncomeDatas_intervalDr<='"_endate_"' and IncomeDatas_tDeptDr=LevelDepts_DeptDr and LevelDepts_parRef=DeptLevelSets_rowid and DeptLevelSets_parent=1 and leveldepts_childSub<>0"
            _" group by IncomeDatas_tDeptDr"
            _" order by IncomeDatas_tDeptDr asc"   
    */
         s sqlStr="SELECT LevelDepts_parRef->DeptLevelSets_name,LevelDepts_deptDr,LevelDepts_deptDr->unitdepts_code AS DeptCode ,LevelDepts_deptDr->unitdepts_name AS DeptName ,"
			_" (select  case  when Sum(IncomeDatas_fee) is  null then 0 else Sum(IncomeDatas_fee) end FROM dhc_ca_cache_data.IncomeDatas  WHERE IncomeDatas_tDeptDr= LevelDepts_deptDr AND  IncomeDatas_intervalDr BETWEEN '"_stdate_"' AND '"_endate_"') AS AcuPeriodIncome,"
			_" (select  case  when Sum(CostResultSum_sum) is  null then 0 else Sum(CostResultSum_sum) end FROM dhc_ca_cache_data.CostResultSum  where  CostResultSum_blDr=LevelDepts_deptDr and CostResultSum_intervalDr BETWEEN '"_stdate_"' AND '"_endate_"' AND CostResultSum_parRef=1 AND CostResultSum_branchFlag='leaf' ) as AcuPeriodCost,"
			_" (select  case  when Sum(ParamDatas_value) is  null then 0 else Sum(ParamDatas_value) end FROM dhc_ca_cache_data.ParamDatas where ParamDatas_servedDeptDr=LevelDepts_deptDr and ParamDatas_intervalDr BETWEEN '"_stdate_"' AND '"_endate_"' and ParamDatas_itemDr='"_itemId_"') as Paramvalue "
			_" FROM dhc_ca_cache_data.LevelDepts WHERE LevelDepts_parRef=5 AND LevelDepts_childSub>0 "
			_" order by LevelDepts_deptDr ASC " 
			
			//CostResultSum_parRef=1  全成本分摊DR  LevelDepts_parRef=5 部门分层套医技科室分层DR
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	;w sqlStr,!
	d result.Execute()	
    While(result.Next()){
	  s LevelName=result.Data("DeptLevelSets_name")
	  s deptDr=result.Data("LevelDepts_deptDr")
	  s DeptCode=result.Data("DeptCode")
      s DeptName=result.Data("DeptName")
      s AcuPeriodIncome=result.Data("AcuPeriodIncome")
      s AcuPeriodCost=result.Data("AcuPeriodCost")
      s Profit=AcuPeriodIncome-AcuPeriodCost
      s Paramvalue=result.Data("Paramvalue")
	 d OutputRow68	  
	}
	
 	q $$$OK
OutputRow68
    q:(AcuPeriodIncome=0)&&(AcuPeriodCost=0)&&(Paramvalue=0)   //zjw 20140618增加
 	s Data=$lb(monthname1,monthname2,LevelName,deptDr,DeptCode,DeptName,$g(AcuPeriodIncome),$g(AcuPeriodCost),$g(Profit),$g(Paramvalue))
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod GettSumDepProfitFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GettSumDepProfitExecute ]
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

ClassMethod GettSumDepProfitClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GettSumDepProfitExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

// 科室直接成本结构分析表

/// Creator:liuyuanfang   zjw  20140618修改   
/// CreatDate:2014-5-16
/// Description:用户信息Query
/// Others:d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","GetDeptVouchDatas","36")
Query GetDeptVouchDatas(month As %String) As %Query(ROWSPEC = "monthname1:%String,LevelparRef:%Integer,LevelName:%String,deptDr:%String,DeptCode:%String,DeptName:%String,AcuPeriodCost:%String,UpPeriodCost:%String,AllPeriodCost:%String") [ SqlProc ]
{
}

ClassMethod GetDeptVouchDatasExecute(ByRef qHandle As %Binary, month As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	q:month="" $$$OK
	i $d(^DHCCAACCOUNTMONTHS(month)) d
	.s stmonth=$p(^DHCCAACCOUNTMONTHS(month),"^",2)
    .s month1=$p(stmonth,"-",1)
    .s day1=$p(stmonth,"-",2)
    .s monthname1=month1_""_"年"_""_day1_""_"月"
    //AccPeriods_periodDr=18、20  表AccPeriod上期、本年首月DR   
    //取本月上期DR
    s upmonth=""
    &SQL(SELECT AccPeriods_monthDr into:upmonth FROM dhc_ca_cache_data.AccPeriods WHERE  AccPeriods_parRef=:month AND AccPeriods_childSub>0 AND AccPeriods_periodDr=18)
    i upmonth="" s upmonth=month
    //取本年首月DR
    &SQL(SELECT AccPeriods_monthDr into:MonthDr FROM dhc_ca_cache_data.AccPeriods WHERE AccPeriods_parRef=:month AND AccPeriods_childSub>0 AND AccPeriods_periodDr=20)
	/*
	s sqlStr="select VouchDatas_intervalDr->AccountMonths_name,VouchDatas_deptDr->unitdepts_code as DeptCode ,VouchDatas_deptDr->unitdepts_name as DeptName,Sum(VouchDatas_debit) as AcuPeriod,"
            _"(select Sum(VouchDatas_debit) FROM dhc_ca_cache_data.VouchDatas b where b.VouchDatas_intervalDr='"_upmonth_"' and b.VouchDatas_deptDr=a.VouchDatas_deptDr) as UpPeriod,"
            _"(select Sum(VouchDatas_debit) FROM dhc_ca_cache_data.VouchDatas b where b.VouchDatas_intervalDr>='"_MonthDr_"' and b.VouchDatas_intervalDr<='"_month_"' and b.VouchDatas_deptDr=a.VouchDatas_deptDr) as AllPeriod"
            _" FROM dhc_ca_cache_data.VouchDatas a where VouchDatas_intervalDr='"_month_"'"
            _" group by VouchDatas_deptDr"    
     */
    s sqlStr=" SELECT LevelDepts_parRef,LevelDepts_parRef->DeptLevelSets_name,LevelDepts_deptDr,LevelDepts_deptDr->unitdepts_code AS DeptCode ,LevelDepts_deptDr->unitdepts_name AS DeptName ,"
			_" (select  case  when Sum(VouchDatas_debit) is  null then 0 else Sum(VouchDatas_debit) end FROM dhc_ca_cache_data.VouchDatas  where VouchDatas_deptDr=LevelDepts_deptDr and VouchDatas_intervalDr='"_month_"') as AcuPeriodCost,"
			_" (select  case  when Sum(VouchDatas_debit) is  null then 0 else Sum(VouchDatas_debit) end FROM dhc_ca_cache_data.VouchDatas  where VouchDatas_deptDr=LevelDepts_deptDr and VouchDatas_intervalDr='"_upmonth_"') as UpPeriodCost,"
			_" (select  case  when Sum(VouchDatas_debit) is  null then 0 else Sum(VouchDatas_debit) end FROM dhc_ca_cache_data.VouchDatas  where VouchDatas_deptDr=LevelDepts_deptDr and VouchDatas_intervalDr BETWEEN '"_MonthDr_"' AND '"_month_"') as AllPeriodCost "
			_" FROM dhc_ca_cache_data.LevelDepts WHERE LevelDepts_parRef IN ('2','3','4','5','6')  AND LevelDepts_childSub>0 "
			_" order by LevelDepts_parRef DESC ,LevelDepts_deptDr ASC "
	
	//'3','4','5','6','2' 全成本分摊五个分层的DR
     
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()	
    While(result.Next()){
	  s LevelparRef=result.Data("LevelDepts_parRef")
	  s LevelName=result.Data("DeptLevelSets_name")
	  s deptDr=result.Data("LevelDepts_deptDr")
	  s DeptCode=result.Data("DeptCode")
      s DeptName=result.Data("DeptName")
      s AcuPeriodCost=result.Data("AcuPeriodCost")
      s UpPeriodCost=result.Data("UpPeriodCost")
      s AllPeriodCost=result.Data("AllPeriodCost")
      ;q:(AcuPeriodCost=0)&&(UpPeriodCost=0)&&(AllPeriodCost=0)
	 d OutputRow69	  
	}
 
 	q $$$OK
OutputRow69
	i upmonth=month s UpPeriodCost=0
    q:(AcuPeriodCost=0)&&(UpPeriodCost=0)&&(AllPeriodCost=0)   //zjw 20140618增加
 	s Data=$lb(monthname1,LevelparRef,LevelName,deptDr,DeptCode,DeptName,$g(AcuPeriodCost),$g(UpPeriodCost),$g(AllPeriodCost))
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod GetDeptVouchDatasFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDeptVouchDatasInfo ]
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

ClassMethod GetDeptVouchDatasClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDeptVouchDatasInfo ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

// 科室全成本结构表

/// Creator: liuyuanfang  zjw  20140618修改  
/// CreatDate: 2014-5-20
/// Description: 用户信息Query
/// Others:d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","GetCostResultSum","36")
Query GetCostResultSum(month As %String) As %Query(ROWSPEC = "monthname1:%String,LevelparRef:%Integer,LevelName:%String,deptDr:%String,DeptCode:%String,DeptName:%String,AcuPeriodCost:%String,UpPeriodCost:%String,AllPeriodCost:%String") [ SqlProc ]
{
}

ClassMethod GetCostResultSumExecute(ByRef qHandle As %Binary, month As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	q:month="" $$$OK
	i $d(^DHCCAACCOUNTMONTHS(month)) d
	.s stmonth=$p(^DHCCAACCOUNTMONTHS(month),"^",2)
    .s month1=$p(stmonth,"-",1)
    .s day1=$p(stmonth,"-",2)
    .s monthname1=month1_""_"年"_""_day1_""_"月"
    //AccPeriods_periodDr=18、20  表AccPeriod上期、本年首月DR   
    //取本月上期DR
    s upmonth=""
    &SQL(SELECT AccPeriods_monthDr into:upmonth FROM dhc_ca_cache_data.AccPeriods WHERE  AccPeriods_parRef=:month AND AccPeriods_childSub>0 AND AccPeriods_periodDr=18)
    i upmonth="" s upmonth=month
    //取本年首月DR
    &SQL(SELECT AccPeriods_monthDr into:MonthDr FROM dhc_ca_cache_data.AccPeriods WHERE AccPeriods_parRef=:month AND AccPeriods_childSub>0 AND AccPeriods_periodDr=20)
	/*s sqlStr="select distinct DeptLevelSets_remark,CostResultSum_blDr->unitdepts_code as DeptCode,CostResultSum_blDr->unitdepts_name as DeptName,Sum(CostResultSum_sum) as AcuPeriod,"
            _"(select CostResultSum_sum FROM dhc_ca_cache_data.CostResultSum b where b.CostResultSum_intervalDr='"_upmonth_"' and b.CostResultSum_blDr=a.CostResultSum_blDr and b.CostResultSum_parRef=a.CostResultSum_parRef) as UpPeriod,"
            _"(select Sum(CostResultSum_sum) FROM dhc_ca_cache_data.CostResultSum b where b.CostResultSum_intervalDr>='"_MonthDr_"' and b.CostResultSum_intervalDr<='"_month_"' and b.CostResultSum_blDr=a.CostResultSum_blDr and b.CostResultSum_parRef=a.CostResultSum_parRef) as AllPeriod"
            _" FROM dhc_ca_cache_data.CostResultSum a,dhc_ca_cache_data.CostDistSets,dhc_ca_cache_data.deptlevelsets,dhc_ca_cache_data.leveldepts"
            _" where CostResultSum_parRef=1 and CostResultSum_parRef=CostDistSets_rowid and CostDistSets_deptSetDr=DeptLevelSets_parent"
            _" and LevelDepts_parRef=DeptLevelSets_rowid and CostResultSum_blDr=LevelDepts_deptDr and  CostResultSum_intervalDr='"_month_"'"
            _" and leveldepts_childSub<>0 and CostResultSum_branchFlag='leaf'"
            _" group by CostResultSum_blDr"
    s sqlStr=sqlStr_" order by DeptLevelSets_rowid" 
    */  
    
    s sqlStr=" SELECT LevelDepts_parRef,LevelDepts_parRef->DeptLevelSets_name,LevelDepts_deptDr,LevelDepts_deptDr->unitdepts_code AS DeptCode ,LevelDepts_deptDr->unitdepts_name AS DeptName ,"
			_" (select  case  when Sum(CostResultSum_sum) is  null then 0 else Sum(CostResultSum_sum) end FROM dhc_ca_cache_data.CostResultSum  where  CostResultSum_blDr=LevelDepts_deptDr and CostResultSum_intervalDr='"_month_"' AND CostResultSum_parRef=1 AND CostResultSum_branchFlag='leaf' ) as AcuPeriodCost,"
			_" (select  case  when Sum(CostResultSum_sum) is  null then 0 else Sum(CostResultSum_sum) end FROM dhc_ca_cache_data.CostResultSum  where  CostResultSum_blDr=LevelDepts_deptDr and CostResultSum_intervalDr='"_upmonth_"' AND CostResultSum_parRef=1 AND CostResultSum_branchFlag='leaf' ) as UpPeriodCost,"
			_" (select  case  when Sum(CostResultSum_sum) is  null then 0 else Sum(CostResultSum_sum) end FROM dhc_ca_cache_data.CostResultSum  where  CostResultSum_blDr=LevelDepts_deptDr and CostResultSum_intervalDr BETWEEN  '"_MonthDr_"' AND '"_month_"' AND CostResultSum_parRef=1 AND CostResultSum_branchFlag='leaf' ) as AllPeriodCost "
			_" FROM dhc_ca_cache_data.LevelDepts WHERE LevelDepts_parRef IN ('2','3','4','5','6')  AND LevelDepts_childSub>0 "
			_" order by LevelDepts_parRef DESC ,LevelDepts_deptDr ASC "
	
	////CostResultSum_parRef=1  全成本分摊DR    '2','3','4','5','6' 全成本分摊五个分层的DR
        
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	;w sqlStr,!
	d result.Execute()	
    While(result.Next()){
	  s LevelparRef=result.Data("LevelDepts_parRef")
	  s LevelName=result.Data("DeptLevelSets_name")
	  s deptDr=result.Data("LevelDepts_deptDr")
	  s DeptCode=result.Data("DeptCode")
      s DeptName=result.Data("DeptName")
      s AcuPeriodCost=result.Data("AcuPeriodCost")
      s UpPeriodCost=result.Data("UpPeriodCost")
      s AllPeriodCost=result.Data("AllPeriodCost")
	 d OutputRow70	  
	}
	
 	q $$$OK
OutputRow70
	i upmonth=month s UpPeriodCost=0
    q:(AcuPeriodCost=0)&&(UpPeriodCost=0)&&(AllPeriodCost=0)   //zjw 20140618增加
 	s Data=$lb(monthname1,LevelparRef,LevelName,deptDr,DeptCode,DeptName,$g(AcuPeriodCost),$g(UpPeriodCost),$g(AllPeriodCost))
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod GetCostResultSumFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCostResultSumExecute ]
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

ClassMethod GetCostResultSumClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCostResultSumExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

// 科室收入结构表 -临床统计

/// Creator: liuyuanfang    zjw 20140618修改  
/// CreatDate: 2014-5-23
/// Description: 用户信息Query
/// Others:d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","GetfIncomeDatas","36")
Query GetfIncomeDatas(month As %String) As %Query(ROWSPEC = "monthname1:%String,RoleDr:%String,RoleName:%String,deptDr:%String,DeptCode:%String,DeptName:%String,AcuPeriodIncome:%String,UpPeriodIncome:%String,AllPeriodIncome:%String") [ SqlProc ]
{
}

ClassMethod GetfIncomeDatasExecute(ByRef qHandle As %Binary, month As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	q:month="" $$$OK

	i $d(^DHCCAACCOUNTMONTHS(month)) s stmonth=$p(^DHCCAACCOUNTMONTHS(month),"^",2)
    s month1=$p(stmonth,"-",1)
    s day1=$p(stmonth,"-",2)
    s monthname1=month1_""_"年"_""_day1_""_"月"
     //AccPeriods_periodDr=18、20  表AccPeriod上期、本年首月DR   
    //取本月上期DR
    s upmonth=""
    &SQL(SELECT AccPeriods_monthDr into:upmonth FROM dhc_ca_cache_data.AccPeriods WHERE  AccPeriods_parRef=:month AND AccPeriods_childSub>0 AND AccPeriods_periodDr=18)
    i upmonth="" s upmonth=month
    //取本年首月DR
    &SQL(SELECT AccPeriods_monthDr into:MonthDr FROM dhc_ca_cache_data.AccPeriods WHERE AccPeriods_parRef=:month AND AccPeriods_childSub>0 AND AccPeriods_periodDr=20)
	
    /*  //zjw  从部门分层套中取科室 收入全部按开单
    	s sqlStr="SELECT LevelDepts_parRef->DeptLevelSets_name,LevelDepts_deptDr,LevelDepts_deptDr->unitdepts_code AS DeptCode ,LevelDepts_deptDr->unitdepts_name AS DeptName ,"
			_" (select  case  when Sum(IncomeDatas_fee) is  null then 0 else Sum(IncomeDatas_fee) end FROM dhc_ca_cache_data.IncomeDatas WHERE  IncomeDatas_fDeptDr= LevelDepts_deptDr AND  IncomeDatas_intervalDr='"_month_"') AS AcuPeriodIncome,"
			_" (select  case  when Sum(IncomeDatas_fee) is  null then 0 else Sum(IncomeDatas_fee) end FROM dhc_ca_cache_data.IncomeDatas WHERE  IncomeDatas_fDeptDr= LevelDepts_deptDr AND  IncomeDatas_intervalDr='"_upmonth_"') AS UpPeriodIncome, "
			_" (select  case  when Sum(IncomeDatas_fee) is  null then 0 else Sum(IncomeDatas_fee) end FROM dhc_ca_cache_data.IncomeDatas WHERE  IncomeDatas_fDeptDr= LevelDepts_deptDr AND  IncomeDatas_intervalDr BETWEEN '"_MonthDr_"' AND '"_month_"' ) AS AllPeriodIncome "
 			_" FROM dhc_ca_cache_data.LevelDepts WHERE LevelDepts_parRef=7 AND LevelDepts_childSub>0 "
			_" order by LevelDepts_deptDr ASC "
			
			// LevelDepts_parRef=7 部门分层套临床医疗科室分层DR

      */   
     
     //zjw 从角色维护中取科室  门诊收入按开单科室  住院科室按病人科室
	s sqlStr="SELECT RDepts_parRef,RDepts_parRef->Roles_name,RDepts_deptDr,RDepts_deptDr->unitdepts_code AS DeptCode ,RDepts_deptDr->unitdepts_name AS DeptName ,"
			_" (select  isnull(Sum(IncomeDatas_fee),0) FROM dhc_ca_cache_data.IncomeDatas WHERE  decode(sign(RDepts_parRef-1),0,IncomeDatas_fDeptDr,IncomeDatas_patDeptDr)= RDepts_deptDr AND  IncomeDatas_intervalDr='"_month_"') AS AcuPeriodIncome,"
			_" (select  isnull(Sum(IncomeDatas_fee),0) FROM dhc_ca_cache_data.IncomeDatas WHERE  decode(sign(RDepts_parRef-1),0,IncomeDatas_fDeptDr,IncomeDatas_patDeptDr)= RDepts_deptDr AND  IncomeDatas_intervalDr='"_upmonth_"') AS UpPeriodIncome, "
			_" (select  isnull(Sum(IncomeDatas_fee),0) FROM dhc_ca_cache_data.IncomeDatas WHERE  decode(sign(RDepts_parRef-1),0,IncomeDatas_fDeptDr,IncomeDatas_patDeptDr)= RDepts_deptDr AND  IncomeDatas_intervalDr BETWEEN '"_MonthDr_"' AND '"_month_"' ) AS AllPeriodIncome "
 			_" FROM dhc_ca_cache_data.Rdepts WHERE RDepts_parRef IN ('1','2') AND RDepts_childSub>0 "
			_" order by RDepts_parRef asc "
			
			// RDepts_parRef IN ('1','2')  门诊、住院角色ID
			
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	;w sqlStr,!
	d result.Execute()	
    While(result.Next()){
	  s RoleDr=result.Data("RDepts_parRef")
	  s RoleName=result.Data("Roles_name")
	  s deptDr=result.Data("RDepts_deptDr")
	  s DeptCode=result.Data("DeptCode")
      s DeptName=result.Data("DeptName")
      s AcuPeriodIncome=result.Data("AcuPeriodIncome")
      s UpPeriodIncome=result.Data("UpPeriodIncome")
      s AllPeriodIncome=result.Data("AllPeriodIncome")
	 d OutputRow71	  
	}
	
 	q $$$OK
OutputRow71
	i upmonth=month s UpPeriodIncome=0
    q:(AcuPeriodIncome=0)&&(UpPeriodIncome=0)&&(AllPeriodIncome=0)   //zjw 20140618 增加
 	s Data=$lb(monthname1,RoleDr,RoleName,deptDr,DeptCode,DeptName,$g(AcuPeriodIncome),$g(UpPeriodIncome),$g(AllPeriodIncome))
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod GetfIncomeDatasFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetfIncomeDatasExecute ]
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

ClassMethod GetfIncomeDatasClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetfIncomeDatasExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

// 科室收入结构表 -医技执行统计

/// Creator: liuyuanfang  zjw  20140618修改  
/// CreatDate: 2014-5-26
/// Description: 用户信息Query
/// Others:d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","GettIncomeDatas","36")
Query GettIncomeDatas(month As %String) As %Query(ROWSPEC = "monthname1:%String,LevelName:%String,deptDr:%String,DeptCode:%String,DeptName:%String,AcuPeriodIncome:%String,UpPeriodIncome:%String,AllPeriodIncome:%String") [ SqlProc ]
{
}

ClassMethod GettIncomeDatasExecute(ByRef qHandle As %Binary, month As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	q:month="" $$$OK
	i $d(^DHCCAACCOUNTMONTHS(month)) s stmonth=$p(^DHCCAACCOUNTMONTHS(month),"^",2)
    s month1=$p(stmonth,"-",1)
    s day1=$p(stmonth,"-",2)
    s monthname1=month1_""_"年"_""_day1_""_"月"
     //AccPeriods_periodDr=18、20  表AccPeriod上期、本年首月DR   
    //取本月上期DR
    s upmonth=""
    &SQL(SELECT AccPeriods_monthDr into:upmonth FROM dhc_ca_cache_data.AccPeriods WHERE  AccPeriods_parRef=:month AND AccPeriods_childSub>0 AND AccPeriods_periodDr=18)
    i upmonth="" s upmonth=month
    //取本年首月DR
    &SQL(SELECT AccPeriods_monthDr into:MonthDr FROM dhc_ca_cache_data.AccPeriods WHERE AccPeriods_parRef=:month AND AccPeriods_childSub>0 AND AccPeriods_periodDr=20)
		
    /*
    &SQL(SELECT AccountMonths_rowid into:MonthDr FROM dhc_ca_cache_data.AccountMonths where AccountMonths_name=:monthname)
	s sqlStr="select  distinct DeptLevelSets_remark,IncomeDatas_tDeptDr->unitdepts_code as IncomeDatas_tDeptCode,IncomeDatas_tDeptDr->unitdepts_name as IncomeDatas_tDeptName,IncomeDatas_tDeptDr,Sum(IncomeDatas_fee) as AcuPeriod,"
            _"(select  Sum(IncomeDatas_fee) FROM dhc_ca_cache_data.IncomeDatas b where b.IncomeDatas_intervalDr='"_upmonth_"' and b.IncomeDatas_tDeptDr=a.IncomeDatas_tDeptDr) as UpPeriod,"
            _"(select  Sum(IncomeDatas_fee) FROM dhc_ca_cache_data.IncomeDatas b where b.IncomeDatas_intervalDr>='"_MonthDr_"' and b.IncomeDatas_intervalDr<='"_month_"' and b.IncomeDatas_tDeptDr=a.IncomeDatas_tDeptDr) as AllPeriod"
            _" FROM dhc_ca_cache_data.IncomeDatas a,dhc_ca_cache_data.LevelDepts,dhc_ca_cache_data.DeptLevelSets"
            _" where  IncomeDatas_intervalDr='"_month_"' and IncomeDatas_tDeptDr=LevelDepts_DeptDr and LevelDepts_parRef=DeptLevelSets_rowid and DeptLevelSets_parent=1 and leveldepts_childSub<>0"
            _" group by IncomeDatas_tDeptDr" 
     */ 
      
    s sqlStr="SELECT LevelDepts_parRef->DeptLevelSets_name,LevelDepts_deptDr,LevelDepts_deptDr->unitdepts_code AS DeptCode ,LevelDepts_deptDr->unitdepts_name AS DeptName ,"
			_" (select  case  when Sum(IncomeDatas_fee) is  null then 0 else Sum(IncomeDatas_fee) end FROM dhc_ca_cache_data.IncomeDatas WHERE  IncomeDatas_tDeptDr= LevelDepts_deptDr AND  IncomeDatas_intervalDr='"_month_"') AS AcuPeriodIncome,"
			_" (select  case  when Sum(IncomeDatas_fee) is  null then 0 else Sum(IncomeDatas_fee) end FROM dhc_ca_cache_data.IncomeDatas WHERE  IncomeDatas_tDeptDr= LevelDepts_deptDr AND  IncomeDatas_intervalDr='"_upmonth_"') AS UpPeriodIncome, "
			_" (select  case  when Sum(IncomeDatas_fee) is  null then 0 else Sum(IncomeDatas_fee) end FROM dhc_ca_cache_data.IncomeDatas WHERE  IncomeDatas_tDeptDr= LevelDepts_deptDr AND  IncomeDatas_intervalDr BETWEEN '"_MonthDr_"' AND '"_month_"' ) AS AllPeriodIncome "
 			_" FROM dhc_ca_cache_data.LevelDepts WHERE LevelDepts_parRef=5 AND LevelDepts_childSub>0 "
			_" order by LevelDepts_deptDr ASC " 
			 
			 //LevelDepts_parRef=5 部门分层套医技科室分层DR
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	;w sqlStr,!
	d result.Execute()	
    While(result.Next()){
	  s LevelName=result.Data("DeptLevelSets_name")
	  s deptDr=result.Data("LevelDepts_deptDr")
	  s DeptCode=result.Data("DeptCode")
      s DeptName=result.Data("DeptName")
      s AcuPeriodIncome=result.Data("AcuPeriodIncome")
      s UpPeriodIncome=result.Data("UpPeriodIncome")
      s AllPeriodIncome=result.Data("AllPeriodIncome")
	 d OutputRow72	  
	}
	
 	q $$$OK
OutputRow72
	i upmonth=month s UpPeriodIncome=0
    q:(AcuPeriodIncome=0)&&(UpPeriodIncome=0)&&(AllPeriodIncome=0)   //zjw 20140618 增加
 	s Data=$lb(monthname1,LevelName,deptDr,DeptCode,DeptName,$g(AcuPeriodIncome),$g(UpPeriodIncome),$g(AllPeriodIncome))
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod GettIncomeDatasFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GettIncomeDatasExecute ]
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

ClassMethod GettIncomeDatasClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GettIncomeDatasExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

//-----------------------------------------------

// 支出项目新会计分类明细结构表

/// Creator:  zjw  20140619  
/// CreatDate:
/// Description: 
/// Others:d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","GetItemsCost","36")
Query GetItemsCost(month As %String) As %Query(ROWSPEC = "monthname1:%String,LevelName:%String,ItemDr:%String,ItemCode:%String,ItemName:%String,AcuPeriodCost:%String,UpPeriodCost:%String,AllPeriodCost:%String") [ SqlProc ]
{
}

ClassMethod GetItemsCostExecute(ByRef qHandle As %Binary, month As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	q:month="" $$$OK
	i $d(^DHCCAACCOUNTMONTHS(month)) s stmonth=$p(^DHCCAACCOUNTMONTHS(month),"^",2)
    s month1=$p(stmonth,"-",1)
    s day1=$p(stmonth,"-",2)
    s monthname1=month1_""_"年"_""_day1_""_"月"
     //AccPeriods_periodDr=18、20  表AccPeriod上期、本年首月DR   
    //取本月上期DR
    s upmonth=""
    &SQL(SELECT AccPeriods_monthDr into:upmonth FROM dhc_ca_cache_data.AccPeriods WHERE  AccPeriods_parRef=:month AND AccPeriods_childSub>0 AND AccPeriods_periodDr=18)
    i upmonth="" s upmonth=month
    //取本年首月DR
    &SQL(SELECT AccPeriods_monthDr into:MonthDr FROM dhc_ca_cache_data.AccPeriods WHERE AccPeriods_parRef=:month AND AccPeriods_childSub>0 AND AccPeriods_periodDr=20)
	
	/* 备用
	
	s sqlStr="SELECT AllDataItems_rowid, AllDataItems_code, AllDataItems_name ,"
			_" (select  case  when Sum(VouchDatas_debit) is  null then 0 else Sum(VouchDatas_debit) end FROM dhc_ca_cache_data.VouchDatas WHERE  VouchDatas_itemDr= AllDataItems_rowid AND  VouchDatas_intervalDr='"_month_"') AS AcuPeriodCost,"
			_" (select  case  when Sum(VouchDatas_debit) is  null then 0 else Sum(VouchDatas_debit) end FROM dhc_ca_cache_data.VouchDatas WHERE  VouchDatas_itemDr= AllDataItems_rowid AND  VouchDatas_intervalDr='"_upmonth_"' ) AS UpPeriodCost,"
			_" (select  case  when Sum(VouchDatas_debit) is  null then 0 else Sum(VouchDatas_debit) end FROM dhc_ca_cache_data.VouchDatas WHERE  VouchDatas_itemDr= AllDataItems_rowid AND  VouchDatas_intervalDr BETWEEN '"_MonthDr_"' AND '"_month_"' ) AS AllPeriodCost "
			_" FROM dhc_ca_cache_data.AllDataItems WHERE  AllDataItems_remark= '核算成本项目' AND AllDataItems_active='Y' 
			_" ORDER BY AllDataItems_rowid "
	
	*/
	
    s sqlStr="SELECT LevelItems_parRef->DataLevelSets_name,LevelItems_ItemDr,LevelItems_itemDr->AllDataItems_code AS ItemCode,LevelItems_itemDr->AllDataItems_name AS ItemName ,"
			_" (select  case  when Sum(VouchDatas_debit) is  null then 0 else Sum(VouchDatas_debit) end FROM dhc_ca_cache_data.VouchDatas WHERE  VouchDatas_itemDr= LevelItems_itemDr AND  VouchDatas_intervalDr='"_month_"' ) AS AcuPeriodCost,"
			_" (select  case  when Sum(VouchDatas_debit) is  null then 0 else Sum(VouchDatas_debit) end FROM dhc_ca_cache_data.VouchDatas WHERE  VouchDatas_itemDr= LevelItems_itemDr AND  VouchDatas_intervalDr='"_upmonth_"' ) AS UpPeriodCost,"
			_" (select  case  when Sum(VouchDatas_debit) is  null then 0 else Sum(VouchDatas_debit) end FROM dhc_ca_cache_data.VouchDatas WHERE  VouchDatas_itemDr= LevelItems_itemDr AND  VouchDatas_intervalDr BETWEEN '"_MonthDr_"' AND '"_month_"' ) AS AllPeriodCost "
			_" FROM dhc_ca_cache_data.LevelItems WHERE  LevelItems_parRef IN ('26','27','28','29','30','31','32') AND LevelItems_childSub>0 "
			_" ORDER BY LevelItems_parRef,LevelItems_itemDr "
	
	// LevelItems_parRef IN ('26','27','28','29','30','31','32') 数据分层套之新会计制度分类DR
			 
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	;w sqlStr,!
	d result.Execute()	
    While(result.Next()){
	  s LevelName=result.Data("DataLevelSets_name")
	  s ItemDr=result.Data("LevelItems_itemDr")
	  s ItemCode=result.Data("ItemCode")
      s ItemName=result.Data("ItemName")
      s AcuPeriodCost=result.Data("AcuPeriodCost")
      s UpPeriodCost=result.Data("UpPeriodCost")
      s AllPeriodCost=result.Data("AllPeriodCost")
	 d OutputRow73	  
	}
	
 	q $$$OK
OutputRow73
	i upmonth=month s UpPeriodCost=0
	q:(AcuPeriodCost=0)&&(UpPeriodCost=0)&&(AllPeriodCost=0)   //zjw 20150921 增加
 	s Data=$lb(monthname1,LevelName,ItemDr,ItemCode,ItemName,$g(AcuPeriodCost),$g(UpPeriodCost),$g(AllPeriodCost))
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod GetItemsCostFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetItemsCostExecute ]
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

ClassMethod GetItemsCostClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetItemsCostExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

// 全成本分摊科室分类成本明细表

/// Creator:  zjw  20140619  
/// CreatDate:
/// Description: 
/// Others:d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","GetDeptCost","36")
Query GetDeptCost(month As %String) As %Query(ROWSPEC = "DeptLevelDr:%String,DeptLevelName:%String,DeptDr:%String,DeptCode:%String,DeptName:%String,AcuPeriodCost:%String,UpPeriodCost:%String,AllPeriodCost:%String") [ SqlProc ]
{
}

ClassMethod GetDeptCostExecute(ByRef qHandle As %Binary, month As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	q:month="" $$$OK
	;i $d(^DHCCAACCOUNTMONTHS(month)) s stmonth=$p(^DHCCAACCOUNTMONTHS(month),"^",2)
    ;s month1=$p(stmonth,"-",1)
    ;s monthname=month1_"-"_"01"
     //AccPeriods_periodDr=18、20  表AccPeriod上期、本年首月DR   
    //取本月上期DR
    s upmonth=""
    &SQL(SELECT AccPeriods_monthDr into:upmonth FROM dhc_ca_cache_data.AccPeriods WHERE  AccPeriods_parRef=:month AND AccPeriods_childSub>0 AND AccPeriods_periodDr=18)
    i upmonth="" s upmonth=month
    //取本年首月DR
    &SQL(SELECT AccPeriods_monthDr into:MonthDr FROM dhc_ca_cache_data.AccPeriods WHERE AccPeriods_parRef=:month AND AccPeriods_childSub>0 AND AccPeriods_periodDr=20)
		
	
    s sqlStr="SELECT LevelDepts_parRef,LevelDepts_parRef->DeptLevelSets_name, LevelDepts_deptDr,LevelDepts_deptDr->unitdepts_code AS DeptCode,LevelDepts_deptDr->unitdepts_name AS DeptName ,"
			_" (select  case  when Sum(VouchDatas_debit) is  null then 0 else Sum(VouchDatas_debit) end FROM dhc_ca_cache_data.VouchDatas WHERE  VouchDatas_deptDr= LevelDepts_deptDr AND  VouchDatas_intervalDr='"_month_"' ) AS AcuPeriodCost, "
			_" (select  case  when Sum(VouchDatas_debit) is  null then 0 else Sum(VouchDatas_debit) end FROM dhc_ca_cache_data.VouchDatas WHERE  VouchDatas_deptDr= LevelDepts_deptDr AND  VouchDatas_intervalDr='"_upmonth_"' ) AS UpPeriodCost, "
			_" (select  case  when Sum(VouchDatas_debit) is  null then 0 else Sum(VouchDatas_debit) end FROM dhc_ca_cache_data.VouchDatas WHERE  VouchDatas_deptDr= LevelDepts_deptDr AND  VouchDatas_intervalDr BETWEEN '"_MonthDr_"' AND '"_month_"' ) AS AllPeriodCost "
			_" FROM dhc_ca_cache_data.LevelDepts WHERE LevelDepts_parRef IN ('2','3','4','5','6') AND LevelDepts_childSub>0 "
			_" ORDER BY LevelDepts_parRef, LevelDepts_deptDr "
	
	// LevelDepts_parRef IN ('2','3','4','5','6')  部门分层套之全成本分摊科室分类DR
			 
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	;w sqlStr,!
	d result.Execute()	
    While(result.Next()){
	  s DeptLevelDr=result.Data("LevelDepts_parRef") 
	  s DeptLevelName=result.Data("DeptLevelSets_name")
	  s DeptDr=result.Data("LevelDepts_deptDr")
	  s DeptCode=result.Data("DeptCode")
      s DeptName=result.Data("DeptName")
      s AcuPeriodCost=result.Data("AcuPeriodCost")
      s UpPeriodCost=result.Data("UpPeriodCost")
      s AllPeriodCost=result.Data("AllPeriodCost")
	 d OutputRow74	  
	}
	
 	q $$$OK
OutputRow74
	i upmonth=month s UpPeriodCost=0
	q:(AcuPeriodCost=0)&&(UpPeriodCost=0)&&(AllPeriodCost=0)   //zjw 20150921 增加
 	s Data=$lb(DeptLevelDr,DeptLevelName,DeptDr,DeptCode,DeptName,$num(AcuPeriodCost,2),$num(UpPeriodCost,2),$num(AllPeriodCost,2))
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod GetDeptCostFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDeptCostExecute ]
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

ClassMethod GetDeptCostClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDeptCostExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

// 门诊住院数据分层套分类收入累计汇总

/// Creator:  zjw  20140619  
/// CreatDate:
/// Description: 
/// Others:d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","GetDeptItemIncome","25","32")
Query GetDeptItemIncome(stdate As %String, endate As %String) As %Query(ROWSPEC = "monthname1:%String,monthname2:%String,RoleDr:%String,RoleName:%String,DeptDr:%String,DeptCode:%String,DeptName:%String,DrugIncome:%String,ExamineIncome:%String,CureIncome:%String,OperationIncome:%String,MaterialIncome:%String,BedIncome:%String,OtherIncome:%String") [ SqlProc ]
{
}

ClassMethod GetDeptItemIncomeExecute(ByRef qHandle As %Binary, stdate As %String, endate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	q:stdate="" $$$OK
	q:endate="" $$$OK
	
	s stmonth=$p(^DHCCAACCOUNTMONTHS(stdate),"^",2)
    s stdatecode=$p(^DHCCAACCOUNTMONTHS(stdate),"^",1)
    s month1=$p(stmonth,"-",1)
    s day1=$p(stmonth,"-",2)
    s monthname1=month1_""_"年"_""_day1_""_"月"
    
    s enmonth=$p(^DHCCAACCOUNTMONTHS(endate),"^",2)
    s endatecode=$p(^DHCCAACCOUNTMONTHS(endate),"^",1)
    s month2=$p(enmonth,"-",1)
    s day2=$p(enmonth,"-",2)
    s monthname2=month2_""_"年"_""_day2_""_"月"
    q:stdatecode>endatecode

    s sqlStr="SELECT RDepts_parRef,RDepts_parRef->Roles_name,RDepts_deptDr,RDepts_deptDr->unitdepts_code AS DeptCode,RDepts_deptDr->unitdepts_name AS DeptName ,"
			_" (select  isnull(Sum(IncomeDatas_fee),0) FROM dhc_ca_cache_data.IncomeDatas WHERE  IncomeDatas_fDeptDr= RDepts_deptDr AND  IncomeDatas_intervalDr between '"_stdate_"' AND '"_endate_"' AND IncomeDatas_itemDr IN ('30','31','32') ) AS DrugIncome, " 
			_" (select  isnull(Sum(IncomeDatas_fee),0) FROM dhc_ca_cache_data.IncomeDatas WHERE  IncomeDatas_fDeptDr= RDepts_deptDr AND  IncomeDatas_intervalDr between '"_stdate_"' AND '"_endate_"' AND IncomeDatas_itemDr IN ('11','12','13','14','15','16','17','18','19','20','21','22','23','24','25') ) AS ExamineIncome, "  
			_" (select  isnull(Sum(IncomeDatas_fee),0) FROM dhc_ca_cache_data.IncomeDatas WHERE  IncomeDatas_fDeptDr= RDepts_deptDr AND  IncomeDatas_intervalDr between '"_stdate_"' AND '"_endate_"' AND IncomeDatas_itemDr IN ('1','2','3','7','8','9','10') ) AS CureIncome, " 
			_" (select  isnull(Sum(IncomeDatas_fee),0) FROM dhc_ca_cache_data.IncomeDatas WHERE  IncomeDatas_fDeptDr= RDepts_deptDr AND  IncomeDatas_intervalDr between '"_stdate_"' AND '"_endate_"' AND IncomeDatas_itemDr IN ('26','27') ) AS OperationIncome, "
			_" (select  isnull(Sum(IncomeDatas_fee),0) FROM dhc_ca_cache_data.IncomeDatas WHERE  IncomeDatas_fDeptDr= RDepts_deptDr AND  IncomeDatas_intervalDr between '"_stdate_"' AND '"_endate_"' AND IncomeDatas_itemDr IN ('28','29') ) AS MaterialIncome, "
			_" (select  isnull(Sum(IncomeDatas_fee),0) FROM dhc_ca_cache_data.IncomeDatas WHERE  IncomeDatas_fDeptDr= RDepts_deptDr AND  IncomeDatas_intervalDr between '"_stdate_"' AND '"_endate_"' AND IncomeDatas_itemDr IN ('5','6') ) AS BedIncome, "
			_" (select  isnull(Sum(IncomeDatas_fee),0) FROM dhc_ca_cache_data.IncomeDatas WHERE  IncomeDatas_fDeptDr= RDepts_deptDr AND  IncomeDatas_intervalDr between '"_stdate_"' AND '"_endate_"' AND IncomeDatas_itemDr IN ('4','33') ) AS OtherIncome "
			_"  FROM dhc_ca_cache_data.RDepts WHERE RDepts_parRef IN ('1','2') AND RDepts_childSub>0 "
			_"  ORDER BY RDepts_parRef , RDepts_deptDr "
	
	// IncomeDatas_itemDr IN ('3','4','5','6','7','8')  核算分类DR根据数据分层套划分
			 
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	;w sqlStr,!
	d result.Execute()	
    While(result.Next()){
	  s RoleDr=result.Data("RDepts_parRef") 
	  s RoleName=result.Data("Roles_name")
	  s DeptDr=result.Data("RDepts_deptDr")
	  s DeptCode=result.Data("DeptCode")
      s DeptName=result.Data("DeptName")
      s DrugIncome=result.Data("DrugIncome")
      s ExamineIncome=result.Data("ExamineIncome")
      s CureIncome=result.Data("CureIncome")
      s OperationIncome=result.Data("OperationIncome")
      s MaterialIncome=result.Data("MaterialIncome")
      s BedIncome=result.Data("BedIncome")
      s OtherIncome=result.Data("OtherIncome")
	 d OutputRow75	  
	}
	
 	q $$$OK
OutputRow75
    q:(DrugIncome=0)&&(ExamineIncome=0)&&(CureIncome=0)&&(OperationIncome=0)&&(MaterialIncome=0)&&(BedIncome=0)&&(OtherIncome=0)
 	s Data=$lb(monthname1,monthname2,RoleDr,RoleName,DeptDr,DeptCode,DeptName,$num(DrugIncome,2),$num(ExamineIncome,2),$num(CureIncome,2),$num(OperationIncome,2),$num(MaterialIncome,2),$num(BedIncome,2),$num(OtherIncome,2))
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod GetDeptItemIncomeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDeptItemIncomeExecute ]
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

ClassMethod GetDeptItemIncomeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDeptItemIncomeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

//-----------------------------------------------------------------------------------------------------------

//取临床大科名称

//d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","GetDKDept")

Query GetDKDept() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
 SELECT DeptLevelSets_parent,"临床大科" as parent ,DeptLevelSets_rowid, DeptLevelSets_name FROM dhc_ca_cache_data.DeptLevelSets WHERE DeptLevelSets_parent=8 AND DeptLevelSets_active='Y' ORDER BY DeptLevelSets_rowid
}

// CreatDate:2015.1.4

/// Description: 取临床大科参数   大科科室--小科--小科、月份--参数dr--参数值
/// Table:dhc_ca_cache_data.VouchDatas  
/// Input:核算周期名称   临床大科DR
/// Output:大科dr 大科名称 小科dr 小科名称 参数dr 参数名称  参数值 
/// Return://报表query
/// Others：d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","GetDKDeptItem","49","21,22,23,24")
ClassMethod GetDKDeptItemExecute(ByRef qHandle As %Binary, stdate As %String, DeptDR As %String) As %Status [ SqlProc ]
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	;s ^tempzjw($j,"cbcs")=stdate_"^"_DeptDR
   
	q:stdate="" $$$OK
	;q:DeptDR="" $$$OK
	k ^temp($j,"Item")
	
	i $d(^DHCCAACCOUNTMONTHS(stdate)) s stmonth=$p(^DHCCAACCOUNTMONTHS(stdate),"^",2)
    s month1=$p(stmonth,"-",1)
    s day1=$p(stmonth,"-",2)
    s monthname=month1_""_"年"_""_day1_""_"月"
	s parentz=8  //临床医疗大科分组id
 	s RowidZ="" f  s RowidZ=$O(^DHCCADEPTLEVELSETS(0,"Parent",parentz,RowidZ)) q:RowidZ=""  d
 	.i DeptDR'="" d
	..q:$F(","_DeptDR_",",","_RowidZ_",")=0
	..S Order="" f  S Order=$O(^DHCCADEPTLEVELSETS(0,"DeptOrder",RowidZ,Order)) q:Order=""  d  
	...S childSub=""   
	...S childSub=$O(^DHCCADEPTLEVELSETS(0,"DeptOrder",RowidZ,Order,childSub))  //Only one
	...q:childSub=""
	...s dept=$p(^DHCCADEPTLEVELSETS(RowidZ,"Depts",childSub),"^",1)
	...q:dept=""
	...s item="" f  s item=$O(^DHCCAPARAMDATAS(0,"IntervalSereddepItem",stdate,dept,item)) q:item=""  d
	....s rowid="" f  s rowid=$o(^DHCCAPARAMDATAS(0,"IntervalSereddepItem",stdate,dept,item,rowid)) q:rowid=""  d
	.....s ItemValue=$p(^DHCCAPARAMDATAS(rowid),"^",11)
	.....s ^temp($j,"Item",RowidZ,dept,item)=$g(^temp($j,"Item",RowidZ,dept,item))+ItemValue
	.e  d
	..S Order="" f  S Order=$O(^DHCCADEPTLEVELSETS(0,"DeptOrder",RowidZ,Order)) q:Order=""  d  
	...S childSub=""   
	...S childSub=$O(^DHCCADEPTLEVELSETS(0,"DeptOrder",RowidZ,Order,childSub))  //Only one
	...q:childSub=""
	...s dept=$p(^DHCCADEPTLEVELSETS(RowidZ,"Depts",childSub),"^",1)
	...q:dept=""
	...s item="" f  s item=$O(^DHCCAPARAMDATAS(0,"IntervalSereddepItem",stdate,dept,item)) q:item=""  d
	....s rowid="" f  s rowid=$o(^DHCCAPARAMDATAS(0,"IntervalSereddepItem",stdate,dept,item,rowid)) q:rowid=""  d
	.....s ItemValue=$p(^DHCCAPARAMDATAS(rowid),"^",11)
	.....s ^temp($j,"Item",RowidZ,dept,item)=$g(^temp($j,"Item",RowidZ,dept,item))+ItemValue
	
	s locdr=0 f  s locdr=$o(^temp($j,"Item",locdr)) q:locdr=""  d
	.s deptdr="" f  s deptdr=$o(^temp($j,"Item",locdr,deptdr)) q:deptdr=""  d
	..s itemdr="" f  s itemdr=$o(^temp($j,"Item",locdr,deptdr,itemdr)) q:itemdr=""  d
	...s Value=$g(^temp($j,"Item",locdr,deptdr,itemdr))
	...d OutputRow76

 	k ^temp($j,"Item")
 	q $$$OK
OutputRow76
	s locname=$p(^DHCCADEPTLEVELSETS(locdr),"^",2)
	s deptname=$p(^DHCCAUNITDEPTS(deptdr),"^",2)
	s itemname=$p(^DHCCAALLDATAITEMS(itemdr),"^",3)
	s Data=$lb(monthname,locdr,locname,deptdr,deptname,itemdr,itemname,$g(Value))
 	
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod GetDKDeptItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDKDeptItemExecute, SqlProc ]
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

ClassMethod GetDKDeptItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDKDeptItemExecute, SqlProc ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetDKDeptItem(stdate As %String, DeptDR As %String) As %Query(ROWSPEC = "monthname:%String,locdr:%Integer,locname:%String,deptdr:%Integer,deptname:%String,itemdr:%Integer,itemname:%String,Value:%Float") [ SqlProc ]
{
}

// 支出项目新会计分类明细结构区间表

/// Creator:  zjw  20160320  
/// CreatDate:
/// Description: 
/// Others:d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","GetQjItemsCost","3","6")
Query GetQjItemsCost(stdate As %String, endate As %String) As %Query(ROWSPEC = "monthname1:%String,monthname2:%String,LevelName:%String,ItemDr:%String,ItemCode:%String,ItemName:%String,AcuPeriodCost:%String,UpPeriodCost:%String") [ SqlProc ]
{
}

ClassMethod GetQjItemsCostExecute(ByRef qHandle As %Binary, stdate As %String, endate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	q:stdate="" $$$OK
	q:endate="" $$$OK
	q:(+stdate)>(+endate) $$$OK
	
	;w (+stdate)_"^"_(+endate),!
	i $d(^DHCCAACCOUNTMONTHS(stdate)) s stmonth=$p(^DHCCAACCOUNTMONTHS(stdate),"^",2)
    s month1=$p(stmonth,"-",1)
    s day1=$p(stmonth,"-",2)
    s monthname1=month1_""_"年"_""_day1_""_"月"
    
    i $d(^DHCCAACCOUNTMONTHS(endate)) s enmonth=$p(^DHCCAACCOUNTMONTHS(endate),"^",2)
    s month2=$p(enmonth,"-",1)
    s day2=$p(enmonth,"-",2)
    s monthname2=month2_""_"年"_""_day2_""_"月"
    
    //取上个期间的首月和末月
    s QjNum=(+endate)-(+stdate)+1		//期间相隔月数
    s upmonthNum=(+stdate)-QjNum		//上期间首月
    s downmonthNum=(+endate)-QjNum		//上期间末月
    //防止上个期间没有核算周期
    i upmonthNum<=0 s upmonthNum=1		
    ;i downmonthNum<=0 s downmonthNum=1	
    
    s sqlStr="SELECT LevelItems_parRef->DataLevelSets_name,LevelItems_ItemDr,LevelItems_itemDr->AllDataItems_code AS ItemCode,LevelItems_itemDr->AllDataItems_name AS ItemName ,"
			_" (select  case  when Sum(VouchDatas_debit) is  null then 0 else Sum(VouchDatas_debit) end FROM dhc_ca_cache_data.VouchDatas WHERE  VouchDatas_itemDr= LevelItems_itemDr AND  VouchDatas_intervalDr BETWEEN '"_stdate_"' AND '"_endate_"' ) AS AcuPeriodCost,"
			_" (select  case  when Sum(VouchDatas_debit) is  null then 0 else Sum(VouchDatas_debit) end FROM dhc_ca_cache_data.VouchDatas WHERE  VouchDatas_itemDr= LevelItems_itemDr AND  VouchDatas_intervalDr BETWEEN '"_upmonthNum_"' AND '"_downmonthNum_"' ) AS UpPeriodCost"
			_" FROM dhc_ca_cache_data.LevelItems WHERE  LevelItems_parRef IN ('26','27','28','29','30','31','32') AND LevelItems_childSub>0 "
			_" ORDER BY LevelItems_parRef,LevelItems_itemDr "
	
	// LevelItems_parRef IN ('26','27','28','29','30','31','32') 数据分层套之新会计制度分类DR
			 
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	;w sqlStr,!
	d result.Execute()	
    While(result.Next()){
	  s LevelName=result.Data("DataLevelSets_name")
	  s ItemDr=result.Data("LevelItems_itemDr")
	  s ItemCode=result.Data("ItemCode")
      s ItemName=result.Data("ItemName")
      s AcuPeriodCost=result.Data("AcuPeriodCost")
      s UpPeriodCost=result.Data("UpPeriodCost")
	 d OutputRow77	  
	}
	
 	q $$$OK
OutputRow77
	i downmonthNum=0 s UpPeriodCost=0	
	q:(AcuPeriodCost=0)&&(UpPeriodCost=0)   //zjw 20150921 增加
 	s Data=$lb(monthname1,monthname2,LevelName,ItemDr,ItemCode,ItemName,$g(AcuPeriodCost),$g(UpPeriodCost))
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod GetQjItemsCostFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetQjItemsCostExecute ]
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

ClassMethod GetQjItemsCostClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetQjItemsCostExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator: zjw    
/// CreatDate: 20160505
/// Description: 获取分摊前各科室直接成本 
/// Table:dhc_ca_cache_data.VouchDatas  
/// Input: 年份(YYYY)--月份(MM)
/// Output:年份-月份-核算科室代码-核算科室名称-财务科室代码-财务科室名称-成本类别-成本核算项目-金额
/// Others：d ##class(%ResultSet).RunQuery("web.RunqianQueryZgyd","GetDeptItemsCost","2015","09")
Query GetDeptItemsCost(year As %String, month As %String) As %Query(ROWSPEC = "year:%String,month:%String,HSdeptCode:%String,HSdeptName:%String,deptCode:%String,deptName:%String,Itemtype:%String,debit:%String") [ SqlProc ]
{
}

ClassMethod GetDeptItemsCostExecute(ByRef qHandle As %Binary, year As %String, month As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	q:year="" $$$OK
	q:month="" $$$OK
	s AccountMonthsname=year_"-"_month,monthDr=""
	s monthDr=$o(^DHCCAACCOUNTMONTHS(0,"Name",AccountMonthsname,""))
    
    s sqlStr="SELECT VouchDatas_deptDr, VouchDatas_itemDr, VouchDatas_deptCode, VouchDatas_deptName, VouchDatas_subjCode, VouchDatas_subjName, sum(VouchDatas_debit) as fee "
    	_" FROM dhc_ca_cache_data.VouchDatas WHERE VouchDatas_intervalDr='"_monthDr_"'"
    	_" group by VouchDatas_deptDr, VouchDatas_itemDr, VouchDatas_deptCode, VouchDatas_deptName, VouchDatas_subjCode, VouchDatas_subjName"
			 
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	;w sqlStr,!
	d result.Execute()	
    While(result.Next()){
	  s deptDr=result.Data("VouchDatas_deptDr")
	  i deptDr'="" d
	  .s HSdeptCode=$p(^DHCCAUNITDEPTS(deptDr),"^",1)
	  .s HSdeptName=$p(^DHCCAUNITDEPTS(deptDr),"^",2)
	  e  d
	  .s HSdeptCode=""
	  .s HSdeptName=""
	  
	  s deptCode=result.Data("VouchDatas_deptCode")
	  s deptName=result.Data("VouchDatas_deptName")

      s itemDr=result.Data("VouchDatas_itemDr")
      i itemDr'="" d
      .s ItemName=$p(^DHCCAALLDATAITEMS(itemDr),"^",1)
      .f DataLevelSetsrowid=94:1:105 d
      ..q:DataLevelSetsrowid=100
      ..i $d(^DHCCADATALEVELSETS(0,"Item",DataLevelSetsrowid,itemDr)) s Itemtype=$p(^DHCCADATALEVELSETS(DataLevelSetsrowid),"^",2)
      ..e  s Itemtype=""
	  e  d
      .s Itemtype=""
      .s ItemName=""
      s debit=result.Data("fee")
	 d OutputRow77	  
	}
	
 	q $$$OK
OutputRow77	
	q:debit=0
 	s Data=$lb(year,month,HSdeptCode,HSdeptName,deptCode,deptName,Itemtype,$g(debit))
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod GetDeptItemsCostFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDeptItemsCostExecute ]
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

ClassMethod GetDeptItemsCostClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDeptItemsCostExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Storage Default
{
<StreamLocation>^web.RunqianQueryZgydS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
