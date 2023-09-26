Import SQLUser

Class web.DHCRisBookSelSeat Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

//w ##class(web.DHCRisBookSelSeat).getBookList()

ClassMethod getBookList(locId As %String, resourceId As %String, BookDate As %String) As %String
{
	s ^DHCRisTemp("getBookList")=locId_"^"_resourceId_"^"_BookDate
	s ret=""
	;q ret
	q:((locId="")||(resourceId="")||(BookDate="")) ret
	s date=$zdh(BookDate,"3")
	s row=""
	s time=""
	for
	{
		s range=""
		s time=$o(^DHCRBCResourceSchdulei("Res-Date-Time",locId,resourceId,date,time)) q:(time="")	
		s resourceScheduleDr=0	
		for 
		{
			s resourceScheduleDr=$o(^DHCRBCResourceSchdulei("Res-Date-Time",locId,resourceId,date,time,resourceScheduleDr)) q:(resourceScheduleDr="")
			s startTime=$p($g(^DHCRBCResourceSchdule(resourceScheduleDr)),"^",5)
			s endTime=$p($g(^DHCRBCResourceSchdule(resourceScheduleDr)),"^",6)
			;s remainNum=$p($g(^DHCRBCResourceSchdule(resourceScheduleDr)),"^",10)
			;s useNum=$p($g(^DHCRBCResourceSchdule(resourceScheduleDr)),"^",9)
			s maxNum=$p($g(^DHCRBCResourceSchdule(resourceScheduleDr)),"^",7)
			s minute=(endTime-startTime)\maxNum\60
			;w !,minute
			;b ;001
			s col=""
			s colNum=12
			s nextStartTime=""
			for i=1:1:maxNum
			{
				
				//{SeqNo:'8',Time:'09:00-09:30',Status:0},
				s timeGet=startTime+(minute*(i-1)*60)
				s Name="",info=""
				s resDetail=""
				s status="0"
				s resDetail=$o(^DHCRBCResSchduleDetaili("BKSTARTTIME",resourceScheduleDr,timeGet,resDetail))
				i (resDetail'="")
				{
					s info=resDetail
					s orderDr=$p(^DHCRBCResSchduleDetail("Detail",resDetail),"^",1)
					s paadmdr=$p(^OEORD($p(orderDr,"||",1)),"^",1)
			      	s papatmasmdr=$p(^PAADM(paadmdr),"^",1) 
			        s RegNo=$p($g(^PAPER(papatmasmdr,"PAT",1)),"^",1) 
			        s Name=$p($g(^PAPER(papatmasmdr,"ALL")),"^",1)
			        s status="1"
				}
				else
				{
					s info=resourceScheduleDr
				}
				;w !,timeGet
				if (col="")
				{
					;s col="{SeqNo:'"_i_"',Time:'"_$zt(timeGet,2)_"',Status:0,patName:'测试'}"
					s col="{info:'"_info_"',Time:'"_$zt(timeGet,2)_"',Status:"_status_",Name:'"_Name_"'}"
				}
				else
				{
					;s col=col_","_"{SeqNo:'"_i_"',Time:'"_$zt(timeGet,2)_"',Status:0,Name:'测试'}"
					s col=col_","_"{info:'"_info_"',Time:'"_$zt(timeGet,2)_"',Status:"_status_",Name:'"_Name_"'}"
				}
				;w !,i
				if (i#colNum=0  )
				{
					;s sTime=timeGet-((colNum-1)*60)
					;s eTime=timeGet(+(minute-1)*60)
					;w !,sTime_"^"_eTime
					s range="{TimeRange:'"_$zt((timeGet-((colNum-1)*60*minute)),2)_"-"_$zt((timeGet+(minute*60)),2)_"',col:["_col_"]}"
					s col=""
					s nextStartTime=timeGet+(minute*60)
					if (row="")
					{
						s row=range
					}
					else
					{
						s row=row_","_range
					}
				}
			}
			if (col'="")
			{
				if (nextStartTime="")
				{
					s nextStartTime=startTime
				}
				s range="{TimeRange:'"_$zt(nextStartTime,2)_"-"_$zt(endTime,2)_"',col:["_col_"]}"
				if (row="")
				{
					s row=range
				}
				else
				{
					s row=row_","_range
				}
			}
			
		}
		
	}
	
	s ret="{record:'AppTimeRange',row:["_row_"]}"
	q ret
}

//w ##class(web.DHCRisBookSelSeat).getOrderInfo()

ClassMethod getOrderInfo(orderList As %String) As %String
{
	s ^DHCRisTemp("getOrderInfo")=orderList
	s ret=""
	q:(orderList="") ret
	s len=$l(orderList,"@")
	s orderName=""
	s (Name,orderName,ResouceId,ResourceDesc,bookDate,bookTime,detailDrList)=""
	for i=1:1:len
	{
		s orderDr=$p(orderList,"@",i)
		if (orderDr="")
		{
			continue
		}
		;w !,i_"^"_orderDr
		s OrderRowid=$p(orderDr,"||",1)
		s itemsub=$p(orderDr,"||",2)
		if $d(^OEORD(OrderRowid,"I",itemsub,1))
      	{
    		s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)
    		s strOrderName=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)
    		if (orderName="")
    		{
    			s orderName=strOrderName
    		}
    		else  
    		{
    			s orderName=orderName_"  "_strOrderName
    		}
      	}
      	s paadmdr=$p(^OEORD(OrderRowid),"^",1)
      	s papatmasmdr=$p(^PAADM(paadmdr),"^",1) 
        s RegNo=$p($g(^PAPER(papatmasmdr,"PAT",1)),"^",1) 
        s Name=$p($g(^PAPER(papatmasmdr,"ALL")),"^",1)
        
        s bookDetailDr=""
        s bookDetailDr=$o(^DHCRBCResSchduleDetaili(0,orderDr,0))
        
        if ( bookDetailDr'="")
        {
	        if (detailDrList="")
	        {
		        s detailDrList=bookDetailDr
	        }
	        else
	        {
		        s detailDrList=detailDrList_"@"_bookDetailDr
	        }
	        s bookTime=$p(^DHCRBCResSchduleDetail("Detail",bookDetailDr),"^",18)
	        if bookTime'="" s bookTime=$zt(bookTime,2)
	       
	        s resSchDr=$p(^DHCRBCResSchduleDetail("Detail",bookDetailDr),"^",2)
	        if (resSchDr'="")
	        {
		        ;
		        s bookDate=$p(^DHCRBCResourceSchdule(resSchDr),"^",2)
		        i bookDate'="" s bookDate=$zd(bookDate,3)
		         
				s ResouceId=$p(^DHCRBCResourceSchdule(resSchDr),"^",1)
			    i ResouceId'=""
			    {
				 	s EqId=$p(^RB("RES",ResouceId),"^",3)
				 	s CareProvId=$p(^RB("RES",ResouceId),"^",2)
				 	i EqId'="" s ResourceDesc=$p(^RBC("EQ",EqId),"^",2)
				 	i CareProvId'="" s ResourceDesc=$p(^CTPCP(CareProvId,1),"^",2)
			    }
	        }
        }
      	
	}
	
	s ret=Name_"^"_orderName_"^"_ResouceId_"^"_ResourceDesc_"^"_bookDate_"^"_bookTime_"^"_detailDrList
	q ret
}

//w ##class(web.DHCRisBookSelSeat).getOrderStatus()

ClassMethod getOrderStatus(orderList As %String) As %String
{
	s ^DHCRisTemp("getOrderStatus")=orderList
	s status=""
	q:(orderList="") status
	s len=$l(orderList,"@")
	for i=1:1:len
	{
		s orderDr=$p(orderList,"@",i)
		if (orderDr="")
		{
			continue
		}
		s OrderRowid=$p(orderDr,"||",1)
		s itemsub=$p(orderDr,"||",2)
		
      	s regInfoDr=""
      	s regInfoDr=$o(^DHCPACRegInfoi("OEORI",orderDr,regInfoDr) )
      	if (regInfoDr'="")
      	{
	      	s status="R"
	      	q
      	}
      	s detailDr=""
      	s detailDr=$o(^DHCRBCResSchduleDetaili(0,orderDr,detailDr))
      	if (detailDr'="" )
      	{
	      	s status="B"
	      	q
      	}
	}
	q status
}

/// 根据就诊信息查询病人申请和预约状态的医嘱
/// d ##class(%ResultSet).RunQuery("web.DHCRisBookSelSeat","QueryBookOrder","402")
Query QueryBookOrder(detailDr As %String) As %Query(ROWSPEC = "ExamOrder:%String,ArcItmId:%String,SchRowid:%String,OrderName:%String,datestr:%String,timestr:%String,BookDate:%String,BookTime:%String,BookRes:%String,ResourceID:%String,RecLocDR:%String,LocDesc:%String")
{
}

ClassMethod QueryBookOrderExecute(ByRef qHandle As %Binary, detailDr As %String) As %Status
{
 
 Set repid=$I(^CacheTemp)
 s ind=1
 s detailDr=$p(detailDr,$C(0))
 
 i detailDr="" Set qHandle=$lb(0,repid,0)
 i detailDr="" Quit $$$OK
 
 ;s PatType=$p($g(^PAADM(PaAdmID)),"^",2)
 
 //s (ExamOrder,ArcItmId,SchRowid,OrderName,Status,datestr,timestr,bookDate,bookTime,BookRes,BookTypeFlag,GetPatientStatusCode)=""
 s studyNo=$p(^DHCRBCResSchduleDetail("Detail",detailDr),"^",6)
 ;s SchRowid=$p(^DHCRBCResSchduleDetail("Detail",detailDr),"^",2)
 ;s bookDate=$p(^DHCRBCResSchduleDetail("Detail",detailDr),"^",1)
 ;s bookTime=$p(^DHCRBCResSchduleDetail("Detail",detailDr),"^",18)
 if studyNo'="" d
 .s detailDrGet="" f  s detailDrGet=$o(^DHCRBCResSchduleDetaili("StudyNo",studyNo,detailDrGet)) q:(detailDrGet="")  d
 ..s (orderDr,ResSchduleID,bookTime,ArcItmId,ordInfo,GetstrOrderName,datestr,timestr,bookDate,ResouceId,ResourceDesc,recLocDr,recLocDesc)=""
 ..s orderDr=$p(^DHCRBCResSchduleDetail("Detail",detailDrGet),"^",1) 
 ..;s ResSchduleID=$p(^DHCRBCResSchduleDetail("Detail",detailDrGet),"^",2)
 ..s bookTime=$p(^DHCRBCResSchduleDetail("Detail",detailDrGet),"^",18)
 ..i bookTime'="" s bookTime=$zt(bookTime,2)
 ..s ordrowid=$p(orderDr,"||",1)
 ..s itmsub=$p(orderDr,"||",2)
 ..s ArcItmId=$p(^OEORD(ordrowid,"I",itmsub,1),"^",2)
 ..s ordInfo=##class(web.DHCRisCommFunctionEx).GetOeorditminfo(ordrowid,itmsub)
 ..;w !,ordInfo,!
 ..s GetstrOrderName=$p(ordInfo,"^",1)
 ..s datestr=$p(ordInfo,"^",2)
 ..s timestr=$p(ordInfo,"^",3)
 ..s recLocDesc=$p(ordInfo,"^",21)
 ..s recLocDr=$p(ordInfo,"^",19)
 ..s ResSchduleID=$p(^DHCRBCResSchduleDetail("Detail",detailDrGet),"^",2)
 ..s bookDate=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",2)
 ..i bookDate'="" s bookDate=$zd(bookDate,3)
 ..i ResSchduleID'="" d
 ...s ResouceId=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",1)
 ...s ResourceDesc=""
 ...i ResouceId'="" d
 ....s EqId=$p(^RB("RES",ResouceId),"^",3)
 ....s CareProvId=$p(^RB("RES",ResouceId),"^",2)
 ....i EqId'="" s ResourceDesc=$p(^RBC("EQ",EqId),"^",2)
 ....i CareProvId'="" s ResourceDesc=$p(^CTPCP(CareProvId,1),"^",2)
 ..DO outBookOrder
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK

 
outBookOrder
 
 set Data=$lb(orderDr,ArcItmId,ResSchduleID,GetstrOrderName,datestr,timestr,bookDate,bookTime,ResourceDesc,ResouceId,recLocDr,recLocDesc)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod QueryBookOrderFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryBookOrderExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
	 // if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod QueryBookOrderClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryBookOrderExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCRisBookSelSeat","QueryResource","83")
Query QueryResource(LocID As %String) As %Query(ROWSPEC = "TResDesc:%String,TRowid:%String")
{
}

ClassMethod QueryResourceExecute(ByRef qHandle As %Binary, LocID As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1

	Set RowId="" f  s RowId=$o(^RB("RES",0,"CTLOC",LocID,RowId) ) q:RowId=""  d
	.s CTCPDR=$p(^RB("RES",RowId),"^",2)
	.i CTCPDR'="" d
	..s ResDesc=$p(^CTPCP(CTCPDR,1),"^",2)
	.else  d
	..s EQDR=$p(^RB("RES",RowId),"^",3)
	..s ResDesc=$p(^RBC("EQ",EQDR),"^",2)
	.s scdrowid=$o(^RBAS(RowId,0))
	.;w !,scdrowid
	.i (CTCPDR ="") d    ;有排版计划
    ..Do OutputResRow
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	

OutputResRow
	set Data=$lb($g(ResDesc),RowId)
 	Set ^CacheTemp(repid,ind)=Data
 	;Set ^CacheTemp(repid,1)=$lb("所有","")
 	
 	Set ind=ind+1
	quit
}

ClassMethod QueryResourceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryResourceExecute ]
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

ClassMethod QueryResourceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryResourceExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
