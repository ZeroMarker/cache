Import SQLUser

Class web.DHCRisStatics Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 222;

//----------------------------------------------------------------------

Query FindexeLoc(Desc As %String) As %Query(ROWSPEC = "TLocName:%String,TRowid:%String")
{
}

ClassMethod FindexeLocExecute(ByRef qHandle As %Binary, Desc As %String) As %Status
{
	
 	Set repid=$I(^CacheTemp)
 	//if $G(type)="" Set qHandle=$lb(0,repid,0) quit $$$OK	;s type="I"
	If $g(ind)="" Set ind=1
	;w !,"desc--"_Desc
	s ^test1111=Desc
	s LocType="E"
	Set RowId=0	f  s RowId=$o(^CTLOC(0,"LocType",LocType,RowId)) q:RowId=""  d
	.s GetDesc=$p(^CTLOC(RowId),"^",2) 
	.i (GetDesc[Desc) d
	..;w !,GetDesc 
	..Do OutputRow
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow
	set Data=$lb(GetDesc,RowId)
 	Set ^CacheTemp(repid,ind)=Data
 	//s ^TMPINV(ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindexeLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindexeLocExecute ]
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

ClassMethod FindexeLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindexeLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetLocName(LocID) As %String
{
	s LocName=""
	if (LocID'="") s LocName=$p(^CTLOC(LocID),"^",2)
	q LocName
}

/// /d ##class(%ResultSet).RunQuery("web.DHCRisStatics","QueryStatics",^tmLocID,^tmpstdate,^tmpeddate)
Query QueryStatics(LocID As %String, stdate As %String, eddate As %String, EQID As %String) As %Query(ROWSPEC = "TDocName:%String,TRegNum:%String,TARegNum:%String,TReportNum:%String,TVeryReportNum:%String,TIncome:%String,OptionNum:%String,AssiantDoc:%String,IPRNums:%String,IPcost:%String,OPcost:%String,totalfee:%String,HPcost:%String,HPRNums:%String,TechImcome:%String,Detail:%String")
{
}

ClassMethod QueryStaticsExecute(ByRef qHandle As %Binary, LocID As %String, stdate As %String, eddate As %String, EQID As %String) As %Status
{
	set repid=$I(^CacheTemp)
	s ind=1
	s ^tts=LocID_"^"_stdate_"^"_eddate_"^"_EQID
 	k ^tempDocSta
 	s ^tmpEQID=EQID
 	i LocID'=""
 	{
	s resrowid=0
	f  s resrowid=$o(^RB("RES",0,"CTLOC",LocID,resrowid)) q:(resrowid="")  d
	.s ResInfo=^RB("RES",resrowid)
	.s CareProvrowid=$p($g(ResInfo),"^",2)
	.i CareProvrowid'=""  d
	..s CareProvDesc=$p(^CTPCP(CareProvrowid,1),"^",2)
	..s ^tempDocSta(CareProvrowid)=ind
 	..s ^tempDocSta(ind,1)=CareProvDesc
 	..s ^tempDocSta(ind,2)=0                   //技师操作数量
 	..s ^tempDocSta(ind,3)=0                   //辅助登记数量
 	..s ^tempDocSta(ind,4)=0                   //报告数量
 	..s ^tempDocSta(ind,5)=0                   //审核人数
 	..s ^tempDocSta(ind,6)=0               
 	..s ^tempDocSta(ind,7)=0                   //登记人员操作数量
 	..s ^tempDocSta(ind,8)=0                   //辅助报告医生数量
 	..s ^tempDocSta(ind,9)=0                   //住院病人报告数量
 	..s ^tempDocSta(ind,10)=0                  //住院病人检查费用
 	..s ^tempDocSta(ind,11)=0                  //门诊费用
 	..s ^tempDocSta(ind,12)=0                  //总费用
 	..s ^tempDocSta(ind,13)=0                  //体检人数
 	..s ^tempDocSta(ind,14)=0                  //体检费用
 	..s ^tempDocSta(ind,15)=0                  //技师收入
 	..s ind=ind+1
    s ^tempDocSta=ind-1
    s ind=1
   	f regdate=stdate:1:eddate d 
	.Set RowId=0	f  s RowId=$o(^DHCPACRegInfoi("RegDate",regdate,RowId)) q:RowId=""  d
	..s reglocdr=$p($g(^DHCPACRegInfo(RowId)),"^",13)
	..s paadmdr=$p($g(^DHCPACRegInfo(RowId)),"^",10)
	..s OrditemRowid=$p($g(^DHCPACRegInfo(RowId)),"^",11) 
	..s StudyNo=$p($g(^DHCPACRegInfo(RowId)),"^",2)
	..q:(StudyNo="")
	..s Flag=$p($g(^DHCPACRegInfo(RowId)),"^",21)  
	..q:Flag'=""                        ;不统计转诊病人，不统计住院再收费病人
	..i reglocdr=LocID d 
	...s GetEQId=$p($g(^DHCPACRegInfo(RowId)),"^",14)
	...q:(EQID'="")&(EQID'=GetEQId)
	...s MainDr=$p($g(^DHCPACRegInfo(RowId)),"^",5)
	...i (MainDr'="") d
	....i $g(^tempDocSta(MainDr))'="" d
	.....s Index=^tempDocSta(MainDr)
	.....i $g(^tempDocSta(Index,StudyNo))="" d   ;同一检查号，算一个工作量
	......s ^tempDocSta(Index,StudyNo)=1
	......s ^tempDocSta(Index,2)=^tempDocSta(Index,2)+1
	.....s Num=""
	.....s Num=$p($g(^OEORD(+OrditemRowid,"I",$p(OrditemRowid,"||",2),9)),"^",4)
	.....i Num="" s Num=$p($g(^OEORD(+OrditemRowid,"I",$p(OrditemRowid,"||",2),1)),"^",12)
	.....s price=##class(web.DHCRisCommFunction).GetItemPrice(OrditemRowid)
	.....s perIcome=Num*price
    .....s ^tempDocSta(Index,15)=^tempDocSta(Index,15)+perIcome         //技师收入          ; 
	.....;s paadmtype=$p(^PAADM(paadmdr),"^",2)
	.....;i paadmtype="I" d
	......;s ^tempDocSta(Index,9)=^tempDocSta(Index,9)+1         //统计住院病人Longyf090308
	......;s IPcost=$p(^OEORD(+oeorddr,"I",$p(oeorddr,"||",2),2),"^",13)
	......;s ^tempDocSta(Index,10)=^tempDocSta(Index,10)+IPcost_"元"
	......;s ^tempDocSta(Index,2)=^tempDocSta(Index,2)-1
	.....;i paadmtype="O" d
	......;s ^tempDocSta(Index,2)=^tempDocSta(Index,2)+1
	......;s OPcost=$p(^OEORD(+oeorddr,"I",$p(oeorddr,"||",2),2),"^",13)
	......;s ^tempDocSta(Index,11)=^tempDocSta(Index,11)+OPcost_"元"
	......;w !,  ^tempDocSta(Index,11)
	...s AssiDr=$p(^DHCPACRegInfo(RowId),"^",6)
	...i (AssiDr'="") d
	....if $g(^tempDocSta(AssiDr))'="" d
	.....s Index=^tempDocSta(AssiDr)
	.....i $g(^tempDocSta(Index,StudyNo))="" d  ;同一检查号，算一个工作量  
	.....s ^tempDocSta(Index,StudyNo)=1
	.....s ^tempDocSta(Index,3)=^tempDocSta(Index,3)+1
	...;统计操作员登记的数量
	...s OpSSUSRDr=$p($g(^DHCPACRegInfo(RowId)),"^",7)
	...if OpSSUSRDr'="" d
	....s OpCareDr=$p($g(^SSU("SSUSR",OpSSUSRDr)),"^",14)
	....q:OpCareDr=""
	....if $g(^tempDocSta(OpCareDr))'="" d
	.....s Index=^tempDocSta(OpCareDr)
	.....i $g(^tempDocSta(Index,StudyNo))="" d   ;同一检查号，算一个工作量
	......s ^tempDocSta(Index,StudyNo)=1
	......s ^tempDocSta(Index,7)=^tempDocSta(Index,7)+1
 
    //按报告日期进行统计
   	f rptdate=stdate:1:eddate d
	.Set RowId=0 f  s RowId=$o(^DHCRBStudyi("ReportDate",rptdate,RowId)) q:RowId=""  d
	..s oeorddr=$p(^DHCRBStudy("Report",RowId),"^",15)
	..s orddate=$p(^OEORD(+oeorddr,"I",$p(oeorddr,"||",2),1),"^",9)
	..s StudyNo=$p(^DHCRBStudy("Report",RowId),"^",1)
	..q:(StudyNo="")
    ..s RegRowid=0  f  s RegRowid=$o(^DHCPACRegInfoi("StudyNo",StudyNo,RegRowid)) q:RegRowid=""  d
	...s reglocdr=$p($g(^DHCPACRegInfo(RegRowid)),"^",13)
	...s paadmdr=$p($g(^DHCPACRegInfo(RegRowid)),"^",10)
	...s paadmtype=$p(^PAADM(paadmdr),"^",2) //long
	...q:reglocdr'=LocID
	...s GetEQId=$p(^DHCPACRegInfo(RegRowid),"^",14)
	...q:(EQID'="")&(EQID'=GetEQId)
	...s Flag=$p(^DHCPACRegInfo(RegRowid),"^",21)
	...s OPcost1=0
	...s IPcost1=0
	...s HPcost1=0
	...s arcost=0
	...s arcost1=0
	...s totalfee=0
	...//w OPcost1
	...q:Flag'=""            ;不统计转诊病人，不统计和住院再收费病人
	...; 报告统计是按检查号为单位进行统计
	...s rptssdr=$p(^DHCRBStudy("Report",RowId),"^",8) 
    ...i rptssdr'="" d
    ....s ReportCPDr=$p(^SSU("SSUSR",rptssdr),"^",14) 
    ....i ReportCPDr'="" d
    .....i $g(^tempDocSta(ReportCPDr))'="" d 
    ......s Index=^tempDocSta(ReportCPDr)
    ......i $g(^tempDocSta(Index,4,StudyNo))="" d     //同一检查号，算一个工作量
	.......s ^tempDocSta(Index,4,StudyNo)=1
	.......s ^tempDocSta(Index,4)=^tempDocSta(Index,4)+1
	.......i paadmtype="I" d
	........s ^tempDocSta(Index,9)=^tempDocSta(Index,9)+1         //统计住院病人Longyf090308
	........s Num=$p(^OEORD(+oeorddr,"I",$p(oeorddr,"||",2),1),"^",12)
	........s price=##class(web.DHCRisCommFunction).GetItemPrice(oeorddr)
	........s IPcost1=price*Num
	........i IPcost1="" s IPcost1=0
	........s ^tempDocSta(Index,10)=^tempDocSta(Index,10)+IPcost1_"元"
	........s ^tempDocSta(Index,12)=^tempDocSta(Index,12)+IPcost1_"元"
	.......i paadmtype="O" d
	........s ^tempDocSta(Index,2)=^tempDocSta(Index,2)+1
	........s Num=""
	........s Num=$p($g(^OEORD(+oeorddr,"I",$p(oeorddr,"||",2),9)),"^",4)
	........i Num="" s Num=$p($g(^OEORD(+oeorddr,"I",$p(oeorddr,"||",2),1)),"^",12)
	........s price=##class(web.DHCRisCommFunction).GetItemPrice(oeorddr)
	........s OPcost1=price*Num
	........i OPcost1="" s OPcost1=0
	........s ^tempDocSta(Index,11)=^tempDocSta(Index,11)+OPcost1_"元"
	........s ^tempDocSta(Index,12)=^tempDocSta(Index,12)+OPcost1_"元" 
	.......i paadmtype="H" d
	........s ^tempDocSta(Index,13)=^tempDocSta(Index,13)+1
	........s Num=""
	........s Num=$p($g(^OEORD(+oeorddr,"I",$p(oeorddr,"||",2),9)),"^",4) 
	........i Num="" s Num=$p($g(^OEORD(+oeorddr,"I",$p(oeorddr,"||",2),1)),"^",12)
	........s price=##class(web.DHCRisCommFunction).GetItemPrice(oeorddr)
	........s HPcost1=price*Num
	........i HPcost1="" s HPcost1=0
	........s ^tempDocSta(Index,14)=^tempDocSta(Index,14)+HPcost1_"元"
	........//w HPcost1_"^"
	........s ^tempDocSta(Index,12)=^tempDocSta(Index,12)+HPcost1_"元" 
    ...s Veriedssdr=$p(^DHCRBStudy("Report",RowId),"^",11) 
    ...i Veriedssdr'="" d
    ....s VeriedCPDr=$p(^SSU("SSUSR",Veriedssdr),"^",14) 
    ....i VeriedCPDr'="" d
    .....i $g(^tempDocSta(VeriedCPDr))'="" d
    ......s Index=^tempDocSta(VeriedCPDr)
    ......;已经统计过的不在统计
    ......i $g(^tempDocSta(Index,5,StudyNo))="" d   //同一检查号，算一个工作量
	.......s ^tempDocSta(Index,5,StudyNo)=1
	.......s ^tempDocSta(Index,5)=^tempDocSta(Index,5)+1
	...;按辅助报告医生进行统计
    ...s Assiantssdr=$p(^DHCRBStudy("Report",RowId),"^",25) 
    ...i Assiantssdr'="" d
    ....s AssiantCPDr=$p(^SSU("SSUSR",Assiantssdr),"^",14) 
    ....i AssiantCPDr'="" d
    .....i $g(^tempDocSta(AssiantCPDr))'="" d
    ......s Index=^tempDocSta(AssiantCPDr)
    ......;已经统计过的不在统计
    ......i $g(^tempDocSta(Index,8,StudyNo))="" d   //同一检查号，算一个工作量
	.......s ^tempDocSta(Index,8,StudyNo)=1
	.......s ^tempDocSta(Index,8)=^tempDocSta(Index,8)+1
    do OutputRow1
 	}
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow1
    s RNums=0,ANums=0,RepNums=0,VNums=0,opnums=0,AssiantNums=0,IPRNums=0,IPcost=0,OPcost=0,totalfee=0,HPRNums=0,HPcost=0,TechTotalFee=0
    for i=1:1:^tempDocSta d
	.set Data=$lb(^tempDocSta(i,1),^tempDocSta(i,2),^tempDocSta(i,3),^tempDocSta(i,4),^tempDocSta(i,5),^tempDocSta(i,6),^tempDocSta(i,7),^tempDocSta(i,8),^tempDocSta(i,9),^tempDocSta(i,10),^tempDocSta(i,11),^tempDocSta(i,12),^tempDocSta(i,14),^tempDocSta(i,13),^tempDocSta(i,15),"明细")
	.set RNums=RNums+^tempDocSta(i,2)
	.set ANums=ANums+^tempDocSta(i,3)
	.Set RepNums=RepNums+^tempDocSta(i,4)
	.Set VNums=VNums+^tempDocSta(i,5)
	.Set opnums=opnums+^tempDocSta(i,7)
	.set AssiantNums=AssiantNums+^tempDocSta(i,8)
	.set IPRNums=IPRNums+^tempDocSta(i,9)
	.set HPRNums=HPRNums+^tempDocSta(i,13)
	.set IPcost=IPcost+^tempDocSta(i,10)
	.set OPcost=OPcost+^tempDocSta(i,11)
	.set HPcost=HPcost+^tempDocSta(i,14)
	.set totalfee=totalfee+^tempDocSta(i,12)
	.set TechTotalFee=TechTotalFee+^tempDocSta(i,15)
	.set IPcost=IPcost_"元"
	.set OPcost=OPcost_"元"
	.set HPcost=HPcost_"元"
	.set totalfee=totalfee_"元"
	.set TechTotalFee=TechTotalFee_"元"
 	.Set ^CacheTemp(repid,i)=Data
 	.Set ^CacheTemp(repid,i+1)=$lb("合计",RNums,ANums,RepNums,VNums,"",opnums,AssiantNums,IPRNums,IPcost,OPcost,totalfee,HPcost,HPRNums,TechTotalFee)
  	.Set ind=ind+1
	quit
}

ClassMethod QueryStaticsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryStaticsExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
  	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryStaticsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryStaticsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query StaticsEQWorkNum(LocID As %String, stdate As %String, eddate As %String) As %Query(ROWSPEC = "TEQGroupDesc:%String,TEQCode:%String,TEQName:%String,TARegNum:%String")
{
}

ClassMethod StaticsEQWorkNumExecute(ByRef qHandle As %Binary, LocID As %String, stdate As %String, eddate As %String) As %Status
{
	s ^test=LocID_"^"_stdate_"^"_eddate
	Set repid=$I(^CacheTemp)
	s ind=1
 	k ^tempDocSta
 	i LocID'=""
 	{
	s resrowid=0 f  s resrowid=$o(^RB("RES",0,"CTLOC",LocID,resrowid)) q:(resrowid="")  d
	.s ResInfo=^RB("RES",resrowid)
	.s EQrowid=$p(ResInfo,"^",3)
	.i EQrowid'=""  d
	..s EQCode=$p(^RBC("EQ",EQrowid),"^",1)
	..s EQName=$p(^RBC("EQ",EQrowid),"^",2)
	..s EQGroupDr=$p(^RBC("EQ",EQrowid),"^",3)
	..s EQGroupDesc=""
	..i EQGroupDr'="" d
    ...s EQGroupDesc=$p(^RBC("GRP",EQGroupDr),"^",2)
 	..s ^tempDocSta(ind,0)=EQrowid
 	..s ^tempDocSta(EQrowid)=ind
 	..s ^tempDocSta(ind,1)=EQCode
 	..s ^tempDocSta(ind,2)=EQName 
 	..s ^tempDocSta(ind,3)=EQGroupDesc
 	..s ^tempDocSta(ind,4)=0
 	..s ind=ind+1
    s ^tempDocSta=ind-1
    s ind=1
	f regdate=stdate:1:eddate d 
	.Set RowId=0	f  s RowId=$o(^DHCPACRegInfoi("RegDate",regdate,RowId)) q:RowId=""  d
	..s reglocdr=$p(^DHCPACRegInfo(RowId),"^",13)
	..i reglocdr=LocID d 
	...s EQDr=$p(^DHCPACRegInfo(RowId),"^",14)
	...i (EQDr'="") d
	....s Index=^tempDocSta(EQDr)
	....s ^tempDocSta(Index,4)=^tempDocSta(Index,4)+1
	do OutputRow2
 	}
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow2
    for i=1:1:^tempDocSta d
	.set Data=$lb(^tempDocSta(i,3),^tempDocSta(i,1),^tempDocSta(i,2),^tempDocSta(i,4))
 	.Set ^CacheTemp(repid,i)=Data
  	.Set ind=ind+1
	quit
}

ClassMethod StaticsEQWorkNumFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = StaticsEQWorkNumExecute ]
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

ClassMethod StaticsEQWorkNumClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = StaticsEQWorkNumExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod StaticsByOEItem(LocID As %String, stdate As %String, eddate As %String)
{
	s ^test=stdate_"-"_LocID
	Set repid=$I(^CacheTemp)
    s ind=0
 	k ^tempDocSta
 	k ^tempStatics
    k ^gpQuery
  
    s ^tempDocSta(1)="" 
	s ^tempDocSta(1,1)="" ;医嘱名称
	s ^tempDocSta(1,2)="" ;价格
	s ^tempDocSta(1,3)="" ;数量
	s ^tempDocSta(1,2)="" ;总费用
    f date=stdate:1:eddate d
    .s OrderRowid=""
    .f  s OrderRowid=$o(^OEORDi(0,"ItemDate",date,OrderRowid)) q:OrderRowid=""  d               ;循环查询
	..q:$g(OrderRowid)=""
	..s paadmdr=$p(^OEORD(OrderRowid),"^",1) 
	..s patienttype=$p(^PAADM(paadmdr),"^",2) ;病人类型
    ..s Locdr=$p(^PAADM(paadmdr),"^",4)
    ..i $g(Locdr)'="" s LocName=$p(^CTLOC(Locdr),"^",2) 
   	..s itemsub=0 
   	..f  s itemsub=$o(^OEORDi(0,"ItemDate",date,OrderRowid,itemsub)) q:(itemsub="")  d
	...s reploc=$p(^OEORD(OrderRowid,"I",itemsub,3),"^",6)   ;
	...q:(reploc'=LocID)&(LocID'="")
	...s SttDate=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",9)  
	...s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)
	...s priceinfo=##class(web.UDHCJFPRICE).GetOrderPrice("", "", arcimid, SttDate, "", "", "", "")
	...s price=$p(priceinfo,"^",1)
	...s billed=$p(^OEORD(OrderRowid,"I",itemsub,3),"^",5)   ;
	...q:(billed'="P")&(patienttype="O")&(price'="0")     ;门诊病人没有付费的退出
	...s oeorditemdr=OrderRowid_"||"_itemsub 
	...s strOrderName=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)
	...s Date1=$p(^OEORD(OrderRowid,"I",itemsub,3),"^",7)
	...q:(Date1>eddate)!(Date1<stdate)
	...s ind=ind+1
	...s ^tempDocSta(ind)=arcimid
	...s ^tempDocSta(ind,1)=strOrderName
 	...s ^tempDocSta(ind,2)=price  
 	...s ^tempDocSta(ind,3)=1
 	...s ^tempDocSta(ind,4)=0
	do OutputRow4
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow4
    s index=1
    s isSame=1
	s ^tempStatics(index)=^tempDocSta(1) ;医嘱
	s ^tempStatics(index,1)=^tempDocSta(1,1) ;医嘱名称
	s ^tempStatics(index,2)=^tempDocSta(1,2) ;价格
	s ^tempStatics(index,3)=0 ;数量
	s ^tempStatics(index,4)=0 ;总费用
	
	s ^testind=ind
	f i=1:1:ind d
	.s isSame=1
	.f j=1:1:index d
	..i ^tempStatics(j)'=^tempDocSta(i) d
	...s isSame=isSame+1
	.i isSame>index d
	..s index=index+1
	..s ^tempStatics(index)=^tempDocSta(i)
	..s ^tempStatics(index,1)=^tempDocSta(i,1)
	..s ^tempStatics(index,2)=^tempDocSta(i,2)
	..s ^tempStatics(index,3)=0
	..s ^tempStatics(index,4)=0
	
	s ^testindex=index
	f i=1:1:index d
	.f j=1:1:ind d
	..i ^tempStatics(i)=^tempDocSta(j) d
	...s ^tempStatics(i,3)=^tempStatics(i,3)+1
	...s ^tempStatics(i,4)=^tempStatics(i,4)+^tempDocSta(j,2)
	.set Data=$lb(^tempStatics(i,1),^tempStatics(i,2),^tempStatics(i,3),^tempStatics(i,4),"","","","","",RowId)
	.Set ^CacheTemp(repid,i)=Data
	
	;总计
	s AllSum=0
	f i=1:1:index d
	.s AllSum=AllSum+^tempStatics(i,4)
	set Data=$lb("","","","总计:"_AllSum,"","","","","",RowId)
	Set ^CacheTemp(repid,i+1)=Data
  	quit
}

Query QueryPatientFee(LocID As %String, stdate As %String, eddate As %String, CTCareProvDr As %String) As %Query(ROWSPEC = "TRegNo:%String,TName:%String,TIteName:%String,TTotalFee:%String,OperateDoc:%String,ModiCount:%String")
{
}

ClassMethod QueryPatientFeeExecute(ByRef qHandle As %Binary, LocID As %String, stdate As %String, eddate As %String, CTCareProvDr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s LocID=$p(LocID,$c(0))
	s stdate=$p(stdate,$c(0))
	s eddate=$p(eddate,$c(0))
	S CTCareProvDr=$p(CTCareProvDr,$c(0))
	
   if LocID="" s LocID=##class(web.DHCRisCommFunction).GetSession("SelLocID")
   if LocID="" s LocID=%session.Get("LOGON.CTLOCID")

	
	;s LocID=780,stdate=60630,eddate=60707,CTCareProvDr=""
	;s ^Inn=LocID_"^"_stdate_"^"_eddate_"^"_CTCareProvDr_"^"
 	s alltotalfee=0
 	for date=stdate:1:eddate d
 	.s regrowid=0 f  s regrowid=$o(^DHCPACRegInfoi("Loc-date",LocID,date,regrowid)) q:regrowid=""  d
 	..s userdr=$p(^DHCPACRegInfo(regrowid),"^",7)
 	..s StudyNo=$p(^DHCPACRegInfo(regrowid),"^",2)  
 	..s ctcpdr=$p($g(^SSU("SSUSR",userdr)),"^",14)
 	..q:(CTCareProvDr'="")&(ctcpdr'=CTCareProvDr)
 	..s CareDesc=$p(^CTPCP(ctcpdr,1),"^",2) 
    ..s orditemrowid=$p(^DHCPACRegInfo(regrowid),"^",11)
    ..s orderrowid=$p(orditemrowid,"||",1)
    ..s childsub=$p(orditemrowid,"||",2)
    ..s ordInfo=##class(web.DHCRisCommFunctionEx).GetOeorditminfo(orderrowid,childsub)
    ..s OeordFee=$p(ordInfo,"^",12)
    ..s Num=$p(ordInfo,"^",11)
    ..s GetstrOrderName=$p(ordInfo,"^",1)
    ..s paadmdr=$p(^DHCPACRegInfo(regrowid),"^",10)
    ..s patinfo=##class(web.DHCRisCommFunctionEx).GetPaadmInfo(paadmdr)
    ..s regno=$p(patinfo,"^",1)
    ..s name=$p(patinfo,"^",2)
    ..s TotalFee=$p(^DHCPACRegInfo(regrowid),"^",18)
    ..i (TotalFee="")!(TotalFee="0") d
    ...s DHCRisSystemInfo=##class(web.DHCRisSystemParam).GetSystemParam()
    ...s DHCRisVersion=$p(DHCRisSystemInfo,"^",15)
    ...i DHCRisVersion="BJ_AZ" d
    ....d ##class(web.DHCRisSystemParam).SetMedTrakNameSpace()
    ....s TotalFee=$$getMasterOrderFee^CHOPOrderEntry(orditemrowid)
    ....zn "RIS"
    ...if (DHCRisVersion="HRB_HYD") d
	....zn "meddata"
	....s OrderRowid=$p(orditemrowid,"||",1) 
	....s itemsub=$p(orditemrowid,"||",2)
	....s SttDate=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",9)  
	....s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)
	....s priceinfo=$$GetOrderPrice^DHCPRICE("","",arcimid,SttDate,"","","","") 
	....s price=$p(price,"^",1)
	....s TotalFee=price*Num
	....zn "RIS"
	...if (DHCRisVersion="SG_YB") 
	...s TotalFee=OeordFee
	..s alltotalfee=alltotalfee+TotalFee
    ..s ModiCount=0
    ..if StudyNo'="" d
    ...s Rptrowid=0  f  s Rptrowid=$o(^DHCRBStudyi("Report","StudyNo",StudyNo,Rptrowid)) q:Rptrowid=""  d
    ....s GetReportStatusCode=""
    ....s GetRptStatusDR=$p(^DHCRBStudy("Report",Rptrowid),"^",4)
    ....i GetRptStatusDR'="" d
    .....s GetReportStatusCode=$p(^DHCRBCStatus("ReportStatus",GetRptStatusDR),"^",1)
    .....i GetReportStatusCode="S" s ModiCount=ModiCount+1
   	..do OutputFee
  	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputFee
     Set ^CacheTemp(repid,ind)=$lb(regno,name,GetstrOrderName,TotalFee,CareDesc,ModiCount)
     s count=ind_"人"
     Set ^CacheTemp(repid,ind+1)=$lb("合计",count,"-------",alltotalfee,"","")
  	 Set ind=ind+1
	quit
}

ClassMethod QueryPatientFeeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryPatientFeeExecute ]
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

ClassMethod QueryPatientFeeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryPatientFeeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCRisStatics","ListPersons","1") [ SqlProc ]
Query ListPersons(Rowid As %String = "") As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
        SELECT CTLOC_RowID FROM CT_Loc
}

/// do ##Class(web.DHCRisStatics).Get()
ClassMethod Get()
{
   s t=""
	s t=##class(%ResultSet).RunQuery("web.DHCRisStatics","ListPersons","1")
	q t
}

}
