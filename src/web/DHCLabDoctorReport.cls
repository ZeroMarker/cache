Class web.DHCLabDoctorReport Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod QueryOrderResultClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryOrderResultExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryOrderResultExecute(ByRef qHandle As %Binary, OrderIDs As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	S ^TMPLABREPORT=OrderIDs
	If $g(ind)="" Set ind=1
	Set qHandle=$lb(0,repid,0)
	If '$l(OrderIDs) Quit 0

	Set Config=##Class(websys.Configuration).%OpenId(1)
	Set LABDATA=Config.LabDataNamespace
	If '$Length(LABDATA) Set LABDATA="LABDATA"
	
	s OrderID=$p(OrderIDs,",",1)
	Set TestSetRow=$p(^OEORD(+OrderID,"I",$p(OrderID,"||",2),3),"^",35)
	If '$l(TestSetRow) Quit 0
 	Set labno=$Piece(TestSetRow,"||",1)
 	Set ts=$Piece(TestSetRow,"||",2)
 	Set tscnt=$Piece(TestSetRow,"||",3)
 	Set isSen="N"
 	k ^TMP($zn,$j)
 	Set ReportFormat=""
 	If $D(^[LABDATA]DHCTSReport(ts)){
	 	Set ReportFormat=$Piece(^[LABDATA]DHCTSReport(ts),"\",1)
	}
 	If '$l(ReportFormat),$D(^[LABDATA]DHCDepReport($E(ts,1))){
	 	Set ReportFormat=$Piece(^[LABDATA]DHCDepReport($E(ts,1)),"\",1)
 	}
 	Set tc="代码",tcDesc="项目名称",tcSyn="缩写",tcResult="结果"
 	Set tcUnit="单位",tcFlag="异常提示",tcRanges="参考范围",isSen="药敏结果",WarnFlag="危急提示"
 	If $L(ReportFormat),$D(^DHCReportDefFormat(ReportFormat)){
	 	Set RepStr=$g(^DHCReportDefFormat(ReportFormat))
	 	Set tcDesc=$p(RepStr,"\",11)
	 	Set tcSyn=$p(RepStr,"\",12)
	 	Set tcResult=$p(RepStr,"\",13)
	 	Set tcUnit=$p(RepStr,"\",14)
	 	Set tcFlag=$p(RepStr,"\",15)
	 	Set tcRanges=$p(RepStr,"\",16)
 	}
	//标题头
 	Set DataStr=$lb(tc,tcDesc,tcSyn,tcResult,tcUnit,tcFlag,tcRanges,isSen,WarnFlag,"","")
 	Do OutPut
 	//
 	f i=1:1:$l(OrderIDs,",") d
	.s OrderID=$p(OrderIDs,",",i)
	.q:'$l(OrderID)
	.Set TestSetRow=$p(^OEORD(+OrderID,"I",$p(OrderID,"||",2),3),"^",35)
	.q:'$l(TestSetRow)
 	.Set labno=$Piece(TestSetRow,"||",1),ts=$Piece(TestSetRow,"||",2),tscnt=$Piece(TestSetRow,"||",3)
 	.Set tc="" For  Set tc=$Order(^TEPI(labno,1,ts,tscnt,"DATA",tc)) Quit:tc=""  Do
 	..Set resStr=$Piece(^(tc),"\",1)
 	..Set RecDate=$P(^TEPI(labno,1,ts,tscnt),"\",21)
 	..Set temres=##Class(web.DHCLabTestCode).GetTestCodeResult(labno,tc,resStr,RecDate)
 	..Set tcDesc=$Piece(temres,$Char(2),2)
 	..Set tcSyn=$Piece(temres,$Char(2),7)
 	..Set tcResult=$Piece(temres,$Char(2),3)
 	..Set tcUnit=$Piece(temres,$Char(2),4)
 	..Set tcFlag=$Piece(temres,$Char(2),5)
 	..Set tcRanges=$Piece(temres,$Char(2),6)
 	..Set WarnFlag=$Piece(temres,$Char(2),8)
 	..Set isSen="N",SenStr=""
 	..If $d(^TEPI(labno,1,ts,tscnt,"DATA",tc,"ANT")) d
 	...Set isSen="Y"
 	...s SenStr="websys.default.csp?WEBSYS.TCOMPONENT=DHCLabOrderResultSen&OrgName="_tcResult_"&TSRowId="_OrderID_"&TC="_tc
 	..i $d(^TTAB("TC",tc,1,ts)) d
 	...Set Order1=$p(^TTAB("TC",tc,1,ts),"\",1)
 	...Set LayOrder=$p(^TTAB("TC",tc,1,ts),"\",2)
 	...Set Order=$p(^TTAB("TS",ts,LayOrder,Order1),"\",15)
 	...Set Report=$p(^TTAB("TS",ts,LayOrder,Order1),"\",13)
 	..e  d
 	...s Report="Y"
 	...s tcRanges=$g(^TEPI(labno,1,ts,tscnt,"DATA",tc,"Ranges"))
 	...s tcUnit=$g(^TEPI(labno,1,ts,tscnt,"DATA",tc,"Unit"))
 	...s Order=$p($g(^TEPI(labno,1,ts,tscnt,"DATA",tc)),"\",9)
 	...s tcFlag=$p($g(^TEPI(labno,1,ts,tscnt,"DATA",tc)),"\",2)
 	...s WarnFlag=tcFlag
 	..If Report'="Y" Quit
 	..If '$l(tcSyn) Set tcSyn="&nbsp;"
 	..If '$L(tcUnit) Set tcUnit="&nbsp;"
 	..If '$l(tcFlag) Set tcFlag="&nbsp;"
 	..If '$l(tcRanges) Set tcRanges="&nbsp;"
 	..If '$l(WarnFlag) Set WarnFlag="&nbsp;"
 	..s tcStr="PatientBanner=0&TestSetRowID="_TestSetRow_"||"_tc_"&Name="_tcDesc_"&Syn="_tcSyn_"&Units="_tcUnit
	..s mi=$p(^TEPI(labno,1,ts,tscnt),"\",27)
	..i '$l(mi) s mi=$e(ts)   ///
    ..i $l(mi),$l(tc),$d(^[LABDATA]DHCMachinePara(mi,"TC",tc)) s Order=$g(^[LABDATA]DHCMachinePara(mi,"TC",tc))
    ..i $d(^TMP($zn,$j,"Order",Order)) s Order=ts_Order  ///判断医嘱合并没有维护仪器项目顺序出现序号相同处理
 	..s ^TMP($zn,$j,"Order",Order)=$lb(tc,tcDesc,tcSyn,tcResult,tcUnit,tcFlag,tcRanges,isSen,WarnFlag,tcStr,SenStr)
	//排序
	s ord="" f  s ord=$o(^TMP($zn,$j,"Order",ord)) q:ord=""  d
	.s DataStr=^(ord)
	.Do OutPut
	k ^TMP($zn,$j)
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutPut
	//Set Data =$lb(tc,tcDesc,tcSyn,tcResult,tcUnit,tcFlag,tcRanges,isSen,WarnFlag)
 	Set ^CacheTemp(repid,ind)=DataStr //Data
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
/// CreatDate：    20090723
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
	s TSName=..GetTSNames(OrderID)
		
	s OrderID=$p(OrderID,",",1)
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
 	Set Name="医嘱名称",Value=TSName
 	Set TSStr="<td>"_Name_"</td><td bgcolor=white width=200>"_Value_"</td>"
 	//危急提示
 	Set Name="危急说明",Value=##Class(web.DHCLabCommon).GetWarnComment(labno,ts,tscnt)
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
/// CreatDate：    20090724
/// Description:： 根据报告ID得到报告基本信息
/// Table：        EP_VisitNumber,EP_VisitTestSet
/// Input：        报告ID
/// Output：       显示行内容
/// Return：         
/// Others：        其它说明
Query QueryReportInfo(OrderID As %String) As %Query(ROWSPEC = "LineStr:%String")
{
}

ClassMethod QueryResultSenClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryResultSenExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryResultSenExecute(ByRef qHandle As %Binary, TSRowId As %String, TC As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s OrderID=$g(TSRowId)
	i '$l(OrderID) q $$$OK
	s ^TMPSEN2=TSRowId_","_TC
	Set Config=##Class(websys.Configuration).%OpenId(1)
	Set LABDATA=Config.LabDataNamespace
	If '$Length(LABDATA) Set LABDATA="LABDATA"
	s TSId=$p(^OEORD(+OrderID,"I",$p(OrderID,"||",2),3),"^",35)
	i '$l(TSId) q ""
	s epis=$p(TSId,"||",1)
	s ts=$p(TSId,"||",2)
	s tscnt=$p(TSId,"||",3)
	s ant="" 
	f {
		s ant=$o(^TEPI(epis,1,ts,tscnt,"DATA",TC,"ANT",ant)) 
		q:ant=""
		s temStr=^(ant)
		s antName=""
		i $d(^TTAB("ANT",ant)) s antName=$p(^TTAB("ANT",ant),"\",1)
		///Antibiotics Extra Information 20081121
		s (engName,senResDesc,mic,mm,dosage,surem)="&nbsp;"
		B
		i $d(^[LABDATA]DHCANTIBIOTICS(ant)){
			i $l($p(^[LABDATA]DHCANTIBIOTICS(ant),"\",1)) s engName=$p(^[LABDATA]DHCANTIBIOTICS(ant),"\",1)
			i $l($p(^[LABDATA]DHCANTIBIOTICS(ant),"\",4)) s dosage=$p(^[LABDATA]DHCANTIBIOTICS(ant),"\",4)
			i $l($p(^[LABDATA]DHCANTIBIOTICS(ant),"\",5)) s surem=$p(^[LABDATA]DHCANTIBIOTICS(ant),"\",5)
		}
		s senResDr=$p(temStr,"\",1)
		i $l(senResDr),$d(^TTAB("SENS",senResDr)){
			i $l($p(^TTAB("SENS",senResDr),"\",1)) s senResDesc=$p(^TTAB("SENS",senResDr),"\",1)
		}
		s report=$p(temStr,"\",2)
		i report="Y",$l(senResDesc) {
			Set (mic,mm)="&nbsp;"
			If $l($p(temStr,"\",3)) s mic=$p(temStr,"\",3)
			If $l($p(temStr,"\",4)) s mm=$p(temStr,"\",4)
			i $e(mic,1)="." s mic="0"_mic
			i $e(mm,1)="." s mm="0"_mm
			Do OutPut
		}
	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPut
	Set Data=$lb(ant,antName,engName,senResDesc,mic,mm,dosage,surem)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod QueryResultSenFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryResultSenExecute ]
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
/// CreatDate：    20090724
/// Description:： 根据报告ID和项目得到药敏结果
/// Table：        EP_VisitNumber,EP_VisitTestSet,EP_VisitTestSetData
/// Input：        报告ID和项目代码
/// Output：       抗生物代码,抗生素名称,抗生素英文名称,药敏结果,mic,mm,用法,尿液浓度用法
/// Return：         函数返回值的说明
/// Others：        其它说明
Query QueryResultSen(TSRowId As %String, TC As %String) As %Query(ROWSPEC = "AntiCode:%String,AntiName:%String,AntiSyn:%String,Result:%String,MIC:%String,mm:%String,Dosage:%String,Surem:%String")
{
}

ClassMethod QueryResultBugsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryResultBugsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryResultBugsExecute(ByRef qHandle As %Binary, OrderIDs As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s OrderIDs=$g(OrderIDs)
	
	f i=1:1:$l(OrderIDs,",") d 
	.s OrderID=$p(OrderIDs,",",i)
	.q:'$l(OrderID)
	.q:'$l($p(OrderID,"||",2))
	.s TSId=$p(^OEORD(+OrderID,"I",$p(OrderID,"||",2),3),"^",35)
	.Q:'$l(TSId)
	.s epis=$p(TSId,"||",1)
	.s ts=$p(TSId,"||",2)
	.s tscnt=$p(TSId,"||",3)
	.s TC="" f  s TC=$o(^TEPI(epis,1,ts,tscnt,"DATA",TC)) q:TC=""  d
	..i $p(^TTAB("TC",TC),"\",3)="V" d
	...i $d(^TEPI(epis,1,ts,tscnt,"DATA",TC,"ANT")) d
	....Set Code=$p($g(^TEPI(epis,1,ts,tscnt,"DATA",TC)),"\",1)
	....Set (Name,EngName)="&nbsp;"
	....If $l(Code),$d(^TTAB("BUG",Code)) d
	.....Set Name=$P(^TTAB("BUG",Code),"\",1)
	.....Set EngName=$P(^TTAB("BUG",Code),"\",8)
	.....d OutPut

    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPut
	Set Data=$lb(TC,Code,Name,EngName)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod QueryResultBugsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryResultBugsExecute ]
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
/// CreatDate：    20090724
/// Description:： 根据报告ID得到有药敏结果的项目代码
/// Table：        EP_VisitNumber,EP_VisitTestSet,EP_VisitTestSetData
/// Input：        报告ID
/// Output：       项目代码
/// Return：         函数返回值的说明
/// Others：        其它说明
Query QueryResultBugs(OrderID As %String) As %Query(ROWSPEC = "TestCode:%String,BugCode:%String,BugName:%String,BugEng:%String")
{
}

ClassMethod QueryResultGraphClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryResultGraphExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryResultGraphExecute(ByRef qHandle As %Binary, OrderIDs As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s OrderIDs=$g(OrderIDs)
	f i=1:1:$l(OrderIDs,",") d 
	.s OrderID=$p(OrderIDs,",",i)
	.q:'$l(OrderID)
	.q:'$l($p(OrderID,"||",2))
	.s TSId=$p(^OEORD(+OrderID,"I",$p(OrderID,"||",2),3),"^",35)
	.q:'$l(TSId)
	.s epis=$p(TSId,"||",1)
	.s ts=$p(TSId,"||",2)
	.s tscnt=$p(TSId,"||",3)
	.Set result=##class(%ResultSet).%New("%DynamicQuery:SQL")
	.Do result.Prepare("SELECT %ID as RowId,DLRG_GraphWidth as GraphWidth,DLRG_GraphHeight as GraphHeight FROM DHCLAB.DHC_LabResultGraph WHERE (DLRG_LABNO = ? AND DLRG_TS = ? AND DLRG_TSCNT = ?)  ORDER BY DLRG_SEQ")
	.Do result.Execute(epis,ts,tscnt)
	.While result.Next() {
		.//Write result.Data("RowId"),!
		.Set graphRowId=result.Data("RowId")
		.Set GraphWidth=result.Data("GraphWidth")
		.Set GraphHeight=result.Data("GraphHeight")
		.Do OutPut
	.}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPut
	Set Data=$lb(graphRowId,GraphWidth,GraphHeight)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod QueryResultGraphFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryResultGraphExecute ]
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
/// CreatDate：    20090724
/// Description:： 根据报告ID得到有药敏结果的项目代码
/// Table：        
/// Input：        报告ID
/// Output：       项目代码
/// Return：         函数返回值的说明
/// Others：        其它说明
Query QueryResultGraph(OrderIDs As %String) As %Query(ROWSPEC = "GraphId:%String,GraphWidth:%String,GraphHeight:%String")
{
}

ClassMethod QueryResultBBPClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryResultBBPExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryResultBBPExecute(ByRef qHandle As %Binary, OrderIDs As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s OrderIDs=$g(OrderIDs)
	k ^TMP($zn,$j)
	f i=1:1:$l(OrderIDs,",") d 
	.s OrderID=$p(OrderIDs,",",i)
	.q:'$l(OrderID)
	.q:'$l($p(OrderID,"||",2))
	.s TSId=$p(^OEORD(+OrderID,"I",$p(OrderID,"||",2),3),"^",35)
	.q:'$l(TSId)
	.s labno=$p(TSId,"||",1)
	.s ts=$p(TSId,"||",2)
	.s tscnt=$p(TSId,"||",3)
	.//血袋信息
	.Set PackId="" For  Set PackId=$Order(^TEPI(labno,1,ts,tscnt,"BBP",PackId)) Quit:PackId=""  Do
	..Set SubId="" For  Set SubId=$Order(^TEPI(labno,1,ts,tscnt,"BBP",PackId,SubId)) Quit:SubId=""  Do
	...Set resStr=$g(^TEPI(labno,1,ts,tscnt,"BBP",PackId,SubId))
	...Set XMStusDr=$p(resStr,"\",1)
	...Set XMStatus=$s(XMStusDr="C":"相溶",XMStusDr="I":"不相溶",XMStusDr="A":"可接受",1:"")
	...Set TransDr=$p(resStr,"\",2)
	...Set TransDesc=""
	...If $l(TransDr),$d(^TTAB("BB-TR",TransDr)) d
	....Set TransDesc=$p(^TTAB("BB-TR",TransDr),"\",1)
	...Set TransStusDr=$p(resStr,"\",3)
	...Set TransStusDesc=""
	...If $l(TransStusDr),$d(^TTAB("BB-ST",TransStusDr))  d
	....Set TransStusDesc=$p(^TTAB("BB-ST",TransStusDr),"\",1)
	...Set XMRes=$p(resStr,"\",4)
	...Set XMRes1=$p(XMRes,",",1)
	...If $l(XMRes1) Set XMRes1=$s(XMRes1="0":"相溶",1:"不相溶")
	...Set XMRes2=$p(XMRes,",",2)
	...If $l(XMRes2) Set XMRes2=$s(XMRes2="0":"相溶",2:"不相溶")
	...Set Order=+$p(resStr,"\",10)
    ...Set BldProductDr=$p(^TBBP(PackId,SubId),"\",4)
    ...Set BldGroupDr=$p(^TBBP(PackId,SubId),"\",5)
    ...Set (BldProductDesc,BldGroupDesc,PackUnit)=""
    ...If $l(BldProductDr),$d(^TTAB("BB-BP",BldProductDr)) d
    ....Set BldProductDesc=$p(^TTAB("BB-BP",BldProductDr),"\",1)
    ....If $d(^TTAB("BB-BP",BldProductDr,"REM",1)) S PackUnit=$p(^TTAB("BB-BP",BldProductDr,"REM",1),"&",1)
    ...If $l(BldGroupDr),$d(^TTAB("BB-BG",BldGroupDr)) Set BldGroupDesc=$p(^TTAB("BB-BG",BldGroupDr),"\",1)
    ...Set PackVolum=$p(^TBBP(PackId,SubId),"\",21)
	...s ^TMP($zn,$j,"BBP",Order,PackId,SubId)=$lb(PackId,SubId,XMRes1,XMRes2,XMStatus,TransDesc,TransStusDesc,BldProductDesc,BldGroupDesc,PackVolum,PackUnit)
	//排序
	s ord="" f  s ord=$o(^TMP($zn,$j,"BBP",ord)) q:ord=""  d
	.s PackId="" f  s PackId=$o(^TMP($zn,$j,"BBP",ord,PackId)) q:PackId=""  d
	..s SubId="" f  s SubId=$o(^TMP($zn,$j,"BBP",ord,PackId,SubId)) q:SubId=""  d
	...s Data=^(SubId)
	...Do OutPut
	k ^TMP($zn,$j)
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPut
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod QueryResultBBPFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryResultBBPExecute ]
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
/// CreatDate：    20090729
/// Description:： 根据报告ID得到配血信息
/// Table：        
/// Input：        报告ID
/// Output：       
/// Return：         函数返回值的说明
/// Others：        其它说明
Query QueryResultBBP(OrderID As %String) As %Query(ROWSPEC = "PackId:%String,SubId:%String,XMRes1:%String,XMRes2:%String,XMStatus:%String,Transaction:%String,TransStatus:%String,PackBP:%String,PackBG:%String,Volumn:%String,Unit:%String")
{
}

ClassMethod GetTSNames(OrderIDs As %String) As %String
{
	s ret=""
	s OrderIDs=$g(OrderIDs)
 	f i=1:1:$l(OrderIDs,",") d
	.s OrderID=$p(OrderIDs,",",i)
	.q:'$l(OrderID)
	.Set TestSetRow=$p(^OEORD(+OrderID,"I",$p(OrderID,"||",2),3),"^",35)
	.q:'$l(TestSetRow)
	.s ts=$p(TestSetRow,"||",2)
	.i $l(ts),$d(^TTAB("TS",ts)) d
	..s TSName=$p(^TTAB("TS",ts),"\",1)
	..i $l(ret) s ret=ret_"+"_TSName
	..e  s ret=TSName
	q ret
}

}
