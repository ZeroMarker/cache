Class web.DHCLabReportForLis Extends %RegisteredObject [ ProcedureBlock ]
{

ClassMethod QueryOrderResultClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryOrderResultExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryOrderResultExecute(ByRef qHandle As %Binary, OrderID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	Set qHandle=$lb(0,repid,0)
	If '$l(OrderID) Quit 0
	Set TestSetRow=$p(^OEORD(+OrderID,"I",$p(OrderID,"||",2),3),"^",35)
	//If '$l(TestSetRow) Quit 0
	Set Config=##Class(websys.Configuration).%OpenId(1)
	Set LABDATA=Config.LabDataNamespace
	If '$Length(LABDATA) Set LABDATA="LABDATA"
 	Set labno=$Piece(TestSetRow,"||",1)
 	If '$Length(labno) Quit 0
 	//Set ts=$Piece(TestSetRow,"||",2)
 	//Set tscnt=$Piece(TestSetRow,"||",3)
 	Set isSen="N"
 	k ^TMP($zn,$j)
 	/*
 	Set ReportFormat=""
 	If $D(^[LABDATA]DHCTSReport(ts)){
	 	Set ReportFormat=$Piece(^[LABDATA]DHCTSReport(ts),"\",1)
	}
 	If '$l(ReportFormat),$D(^[LABDATA]DHCDepReport($E(ts,1))){
	 	Set ReportFormat=$Piece(^[LABDATA]DHCDepReport($E(ts,1)),"\",1)
 	}
 	*/
 	Set tc="代码",tcDesc="项目名称",tcSyn="缩写",tcResult="结果"
 	Set tcUnit="单位",tcFlag="异常提示",tcRanges="参考范围",isSen="药敏结果",WarnFlag="危急提示"
 	/*
 	If $L(ReportFormat),$D(^DHCReportDefFormat(ReportFormat)){
	 	Set RepStr=$g(^DHCReportDefFormat(ReportFormat))
	 	Set tcDesc=$p(RepStr,"\",11)
	 	Set tcSyn=$p(RepStr,"\",12)
	 	Set tcResult=$p(RepStr,"\",13)
	 	Set tcUnit=$p(RepStr,"\",14)
	 	Set tcFlag=$p(RepStr,"\",15)
	 	Set tcRanges=$p(RepStr,"\",16)
 	}
 	*/
	//标题头
 	Set DataStr=$lb(tc,tcDesc,tcSyn,tcResult,tcUnit,tcFlag,tcRanges,isSen,WarnFlag,"","")
 	Do OutPut
 	//
 	Set ts="" For  Set ts=$Order(^TEPI(labno,1,ts)) Quit:ts=""  Do
 	.Set tscnt="" For  Set tscnt=$Order(^TEPI(labno,1,ts,tscnt)) Quit:tscnt=""  Do
 	..Set tc=""  For  Set tc=$Order(^TEPI(labno,1,ts,tscnt,"DATA",tc)) Quit:tc=""  Do
 	...Set resStr=$Get(^TEPI(labno,1,ts,tscnt,"DATA",tc))
 	...Set tcSeq=+$p(resStr,"\",9)
 	...Set tcResult=$p(resStr,"\",1)
 	...Set tcFlag=$p(resStr,"\",2)
 	...Set WarnFlag=$p(resStr,"\",8)
 	...If '$Length(WarnFlag) Set WarnFlag="N"
 	...Set tcRanges=$g(^TEPI(labno,1,ts,tscnt,"DATA",tc,"RANGES"))
 	...Set tcUnit=$g(^TEPI(labno,1,ts,tscnt,"DATA",tc,"UNIT"))
 	...Set tcMemo=""
 	...Set isSen="N"
 	...If $d(^TEPI(labno,1,ts,tscnt,"DATA",tc,"ANT")) Set isSen="Y" 
 	...Set ^TMP($zn,$j,"Seq",tcSeq,tc)=tcResult_"\"_tcFlag_"\"_WarnFlag_"\"_tcUnit_"\"_tcRanges_"\"_tcMemo_"\"_isSen_"\"_labno_"||"_ts_"||"_tscnt
 	//
    Set seq="" For  Set seq=$Order(^TMP($zn,$j,"Seq",seq)) Quit:seq=""  Do
    .Set tc=""  For  Set tc=$Order(^TMP($zn,$j,"Seq",seq,tc)) Quit:tc=""  Do
    ..Set resStr=^(tc)
    ..Set tcDesc=$Piece(^TTAB("TC",tc),"\",1)
    ..Set tcSyn=$Piece(^TTAB("TC",tc),"\",12)
    ..Set tcResult=$p(resStr,"\",1)
    ..Set tcFlag=$p(resStr,"\",2)
    ..Set WarnFlag=$p(resStr,"\",3)
    ..Set tcUnit=$p(resStr,"\",4)
    ..Set tcRanges=$p(resStr,"\",5)
    ..Set tcMemo=$p(resStr,"\",6)
 	..Set isSen=$p(resStr,"\",7)
 	..Set TestSetRow=$p(resStr,"\",8)
 	..Set SenStr=""
 	..If isSen="Y" Set SenStr="websys.default.csp?WEBSYS.TCOMPONENT=DHCLabOrderResultSen&OrgName="_tcResult_"&TSRowId="_OrderID_"&TC="_tc
 	..If '$l(tcSyn) Set tcSyn="&nbsp;"
 	..If '$L(tcUnit) Set tcUnit="&nbsp;"
 	..If '$l(tcFlag) Set tcFlag="&nbsp;"
 	..If '$l(tcRanges) Set tcRanges="&nbsp;"
 	..If '$l(WarnFlag) Set WarnFlag="&nbsp;"
 	..s tcStr="PatientBanner=0&ID="_TestSetRow_"||"_tc_"&Name="_tcDesc_"&Syn="_tcSyn_"&Units="_tcUnit
 	..Do OutPut
 	..//s ^TMP($zn,$j,"Order",Order)=$lb(tc,tcDesc,tcSyn,tcResult,tcUnit,tcFlag,tcRanges,isSen,WarnFlag,tcStr,SenStr)
	//排序
	//s ord="" f  s ord=$o(^TMP($zn,$j,"Order",ord)) q:ord=""  d
	//.s DataStr=^(ord)
	//.Do OutPut
	k ^TMP($zn,$j)
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutPut
	Set Data =$lb(tc,tcDesc,tcSyn,tcResult,tcUnit,tcFlag,tcRanges,isSen,WarnFlag,tcStr,SenStr)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod QueryOrderResultFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryOrderResultExecute ]
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

/// Creator：      huhm
/// CreatDate：    20101102
/// Description:： 根据报告ID得到报告结果
/// Table：        EP_VisitNumber,EP_VisitTestSet,EP_VisitTestSetData
/// Input：        报告ID
/// Output：       项目代码,项目名称,缩写,结果,单位,标志,参考范围
/// Return：         函数返回值的说明
/// Others：        其它说明
Query QueryOrderResult(OrderID As %String) As %Query(ROWSPEC = "TCCode:%String,TCName:%String,TCSyn:%String,Result:%String,TCUnit:%String,ResultFlag:%String,RefRanges:%String,Sensitive:%String,WarnFlag:%String,tcDetails:%String,SenResult:%String")
{
}

ClassMethod QueryReportInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryReportInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryReportInfoExecute(ByRef qHandle As %Binary, OrderID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	S ^TMPLABREPORT=OrderID
	If $g(ind)="" Set ind=1
	If '$l(OrderID) Quit 0
	Set TestSetRow=$p(^OEORD(+OrderID,"I",$p(OrderID,"||",2),3),"^",35)
	If '$l(TestSetRow) Quit 0
 	Set labno=$Piece(TestSetRow,"||",1)
 	Set ts=$Piece(TestSetRow,"||",2)
 	Set tscnt=$Piece(TestSetRow,"||",3)
	Set Config=##Class(websys.Configuration).%OpenId(1)
	Set LABDATA=Config.LabDataNamespace
	If '$Length(LABDATA) Set LABDATA="LABDATA"
 	//第一行
 	//登记号
 	Set Name="登记号",Value=$p(^TEPI(labno),"\",18)
 	Set DebtorStr="<td>"_$j(Name,20)_"</td><td bgcolor=white>"_Value_"</td>"
 	//申请医生
 	Set Name="申请医生",Value=##Class(web.DHCLabCommon).GetReqDoctor(TestSetRow)
	Set ReqDocStr="<td>"_Name_"</td><td bgcolor=white>"_Value_"</td>"
 	//申请时间
    Set RequestDate=$p(^TEPI(labno),"\",12) 
    If $l(RequestDate) s RequestDate=$zd(RequestDate,3) 
 	Set Name="申请日期",Value=RequestDate
 	Set ReqDateStr="<td>"_Name_"</td><td bgcolor=white>"_Value_"</td>"
 	Set Value=DebtorStr_ReqDocStr_ReqDateStr
 	Do OutPut
 	//第二行
 	//姓名
 	Set Name="姓名",Value=##Class(web.DHCLabCommon).GetPatName(labno)
 	Set NameStr="<td>"_Name_"</td><td bgcolor=white>"_Value_"</td>"
 	//申请科室
    Set LocCode=$p(^TEPI(labno),"\",36)
    Set PatLoc="" 
    If LocCode'="",$d(^TTAB("USLOC",LocCode)) s PatLoc=$p($g(^TTAB("USLOC",LocCode)),"\",1)
    Set PatLoc1=$p(PatLoc,"-",1),PatLoc2=$p(PatLoc,"-",2)
    If $l(PatLoc2)  d
    .s PatLoc=PatLoc2
    e  d
    .s PatLoc=PatLoc1
 	Set Name="申请科室",Value=PatLoc
 	Set LocStr="<td>"_Name_"</td><td bgcolor=white>"_Value_"</td>"
 	//采样时间
    Set CollDate=$p(^TEPI(labno,1,ts,tscnt),"\",44)
    If $l(CollDate) Set CollDate=$zd(CollDate,3)
    Set CollTime=$p(^TEPI(labno,1,ts,tscnt),"\",45)
    If $l(CollTime) s CollTime=$zt(CollTime,2)
 	Set Name="采样时间",Value=CollDate_" "_CollTime	
 	Set CollStr="<td>"_Name_"</td><td bgcolor=white>"_Value_"</td>"
 	Set Value=NameStr_LocStr_CollStr
 	Do OutPut
 	//第三行
 	//性别
 	Set Name="性别",Value=##Class(web.DHCLabCommon).GetSpecies(labno)
 	Set SexStr="<td>"_Name_"</td><td bgcolor=white>"_Value_"</td>"
 	//病区
    Set WardDr=$p(^TEPI(labno),"\",20)
    Set WardName=""
    If $l(WardDr),$d(^TTAB("RH",WardDr)) s WardName=$p(^TTAB("RH",WardDr),"\",1)
 	Set Name="申请病区",Value=WardName
 	Set WardStr="<td>"_Name_"</td><td bgcolor=white>"_Value_"</td>"
 	//接收时间
    Set RecDate=$p(^TEPI(labno,1,ts,tscnt),"\",21)
    If $l(RecDate) Set RecDate=$zd(RecDate,3)
    Set RecTime=$p(^TEPI(labno,1,ts,tscnt),"\",22)
    If $l(RecTime) s RecTime=$zt(RecTime*60,2)
 	Set Name="接收时间",Value=RecDate_" "_RecTime
 	Set RecStr="<td>"_Name_"</td><td bgcolor=white>"_Value_"</td>"
 	Set Value=SexStr_WardStr_RecStr
 	Do OutPut
 	//第四行
 	//出生日期
 	Set Name="出生日期",Value=$p(^TEPI(labno),"\",4)
 	If $l(Value) Set Value=$zd(Value,3)
 	Set DOBStr="<td>"_Name_"</td><td bgcolor=white>"_Value_"</td>"
 	//检验号
 	Set Name="检验号",Value=labno
 	Set LabStr="<td>"_Name_"</td><td bgcolor=white>"_Value_"</td>"
 	//报告时间
    Set AuthDate=$p(^TEPI(labno,1,ts,tscnt),"\",4)
    If $l(AuthDate) Set AuthDate=$zd(AuthDate,3)
    Set AuthTime=$p(^TEPI(labno,1,ts,tscnt),"\",5)
    If $l(AuthTime) s AuthTime=$zt(AuthTime*60,2)
 	Set Name="报告时间",Value=AuthDate_" "_AuthTime
 	Set AuthStr="<td>"_Name_"</td><td bgcolor=white>"_Value_"</td>"
 	Set Value=DOBStr_LabStr_AuthStr
 	Do OutPut
 	//第五行
 	//年龄
 	Set Name="年龄",Value=##Class(web.DHCLabCommon).GetPatAge(TestSetRow,OrderID)
 	Set AgeStr="<td>"_Name_"</td><td bgcolor=white>"_Value_"</td>"
 	//标本
 	Set SpecCode=$p(^TEPI(labno,1,ts,tscnt),"\",46) ;标本类型
 	Set Specimen=""
 	If $l(SpecCode),$d(^TTAB("SPEC",SpecCode)) s Specimen=$p(^TTAB("SPEC",SpecCode),"\",1)
 	Set Name="标本",Value=Specimen
 	Set SpecStr="<td>"_Name_"</td><td bgcolor=white>"_Value_"</td>"
 	//审核人
 	s AuthUser=$p(^TEPI(labno,1,ts,tscnt),"\",6)
 	i $l(AuthUser),$d(^[LABDATA]SSU("SSUSR",1,AuthUser)) s AuthUser=$p(^[LABDATA]SSU("SSUSR",1,AuthUser),"^",2) 
 	Set Name="报告者",Value=AuthUser //"&nbsp;"
 	Set SpaceStr="<td>"_Name_"</td><td bgcolor=white>"_Value_"</td>"
 	Set Value=AgeStr_SpecStr_SpaceStr
 	Do OutPut
 	//病案号
 	Set Name="病案号",Value=$p(^TEPI(labno),"\",6)
 	Set MedNoStr="<td>"_Name_"</td><td bgcolor=white>"_Value_"</td>"
 	//医嘱
 	Set TestName=""
 	Set TestSet="" For  Set TestSet=$Order(^TEPI(labno,1,TestSet)) Quit:TestSet=""  Do
 	.Set TestName=TestName_$p(^TTAB("TS",TestSet),"\",1)_"+"
 	Set TestName=$Piece(TestName,"+",1,$Length(TestName,"+")-1)
 	Set Name="医嘱名称",Value=TestName ///$p(^TTAB("TS",ts),"\",1)
 	Set TSStr="<td>"_Name_"</td><td bgcolor=white width=200>"_Value_"</td>"
 	//危急提示
 	Set Name="危急说明",Value=##Class(web.DHCLabTestCode).GetWarnReportComment(OrderID)
	Set WarnStr="<td>"_Name_"</td><td bgcolor=white width=200>"_Value_"</td>"
	Set Value=MedNoStr_TSStr_WarnStr
	Do OutPut
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPut
	//Set Data =$lb(tc,tcDesc,tcSyn,tcResult,tcUnit,tcFlag,tcRanges,isSen,WarnFlag)
 	Set ^CacheTemp(repid,ind)=$lb(Value) //Data
 	Set ind=ind+1
	Quit
}

ClassMethod QueryReportInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryReportInfoExecute ]
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

/// Creator：      huhm
/// CreatDate：    20101102
/// Description:： 根据报告ID得到报告基本信息
/// Table：        EP_VisitNumber,EP_VisitTestSet
/// Input：        报告ID
/// Output：       显示行内容
/// Return：         
/// Others：        其它说明
Query QueryReportInfo(OrderID As %String) As %Query(ROWSPEC = "LineStr:%String")
{
}

}
