Class web.DHCLabDoctorPreReport Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod GetReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetReportExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetReportExecute(ByRef qHandle As %Binary, TestSetRow As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	Set LabNo=$Piece(TestSetRow,"||",1)
	Set TS=$Piece(TestSetRow,"||",2)
	Set TSCNT=$Piece(TestSetRow,"||",3)
	Set Num=""
	Set RepSeq=1
	For {
		Set Num=$Order(^["LABDATA"]DHCPreReport(LabNo,TS,TSCNT,Num))
		Quit:Num=""
		Set RepStatus=$Piece(^["LABDATA"]DHCPreReport(LabNo,TS,TSCNT,Num),"\",7)
		If RepStatus="A"{
			Set RepDate=$Piece(^["LABDATA"]DHCPreReport(LabNo,TS,TSCNT,Num),"\",4)
			If $Length(RepDate) Set RepDate=$zd(RepDate,3)
			Set RepTime=$Piece(^["LABDATA"]DHCPreReport(LabNo,TS,TSCNT,Num),"\",5)
			If $Length(RepTime) Set RepTime=$zt(RepTime,2)
			Set RepUser=$Piece(^["LABDATA"]DHCPreReport(LabNo,TS,TSCNT,Num),"\",6)
			Set RepRowid=LabNo_"||"_TS_"||"_TSCNT_"||"_Num
			Set RepName="第"_RepSeq_"次预报告"
			Set RepSeq=RepSeq+1
			d OutputRow
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(RepRowid,RepName,RepDate,RepTime,RepUser)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetReportExecute ]
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
/// CreatDate：    20090824
/// Description:： 根据检验医嘱到到预报告ID列表
/// Table：        DHC_PreReport
/// Input：        就诊号
/// Output：       预报告ID,报告名称,报告日期,时间,用户
/// Return：         
/// Others：       其它说明
Query GetReport(TestSetRow As %String) As %Query(ROWSPEC = "ReportId:%String,ReportName:%String,ReportDate:%String,ReportTime:%String,ReportUser:%String")
{
}

ClassMethod GetReportResultClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetReportResultExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetReportResultExecute(ByRef qHandle As %Binary, PreReportID As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	//
	Kill ^TMP($zn,$j)
	Set LabNo=$Piece(PreReportID,"||",1)
	Set TS=$Piece(PreReportID,"||",2)
	Set TSCNT=$Piece(PreReportID,"||",3)
	Set Num=$Piece(PreReportID,"||",4)
	Set RepDate=$Piece(^["LABDATA"]DHCPreReport(LabNo,TS,TSCNT,Num),"\",4)
	If '$Length(RepDate) Set RepDate=+$h
	Set tc=""
	For {
		Set tc=$Order(^["LABDATA"]DHCPreReport(LabNo,TS,TSCNT,Num,"DATA",tc))
		Quit:tc=""
		Set resStr=$Piece(^["LABDATA"]DHCPreReport(LabNo,TS,TSCNT,Num,"DATA",tc),"\",1)
		Set Order=$Piece(^["LABDATA"]DHCPreReport(LabNo,TS,TSCNT,Num,"DATA",tc),"\",2)
		if $l(resStr) {
	 		Set temRes=##Class(web.DHCLabTestCode).GetTestCodeResult(LabNo,tc,resStr,RepDate)
	 		Set tcDesc=$Piece(temRes,$Char(2),2)
	 		Set tcSyn=$Piece(temRes,$Char(2),7)
	 		Set Result=$Piece(temRes,$Char(2),3)
	 		Set Unit=$Piece(temRes,$Char(2),4)
	 		Set tcFlag=$Piece(temRes,$Char(2),5)
	 		Set Ranges=$Piece(temRes,$Char(2),6)
	 		If '$Length(Order) Set Order=1
	 		Set TCName=$Piece(^TTAB("TC",tc),"\",1)
	 		Set TCSyn=$Piece(^TTAB("TC",tc),"\",12)
	 		Set IncludeSen="N"
	 		Set SenStr=""
	 		If $Data(^["LABDATA"]DHCPreReport(LabNo,TS,TSCNT,Num,"DATA",tc,"ANT")) {
		 		Set IncludeSen="Y"
		 		Set SenStr="websys.default.csp?WEBSYS.TCOMPONENT=DHCLabPreRepResSen&ReportID="_PreReportID_"&TC="_tc
	 		}
	 		If '$Length(TCSyn) Set TCSyn="&nbsp;"
	 		If '$Length(Unit) Set Unit="&nbsp;"
	 		If '$Length(Ranges) Set Ranges="&nbsp;"
	 		set Data=$lb(tc,TCName,TCSyn,Result,Unit,Ranges,IncludeSen,SenStr)
	 		Set ^TMP($zn,$j,1,Order,tc)=Data
		}
	}
	Set ord=""
	For {
		Set ord=$Order(^TMP($zn,$j,1,ord))
		Quit:ord=""
		Set tc=""
		For {
			Set tc=$Order(^TMP($zn,$j,1,ord,tc))
			Quit:tc=""
			Set Data=^TMP($zn,$j,1,ord,tc)
			d OutputRow
		}
	}
	Set qHandle=$lb(0,repid,0)
	Kill ^TMP($zn,$j)
	Quit $$$OK
OutputRow
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetReportResultFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetReportResultExecute ]
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
/// CreatDate：    20090824
/// Description:： 根据报告ID得到预报告结果
/// Table：        DHC_PreReportData
/// Input：        预报告ID
/// Output：       代码,名称,缩写,结果,单位,范围值,是否有药敏结果,药敏结果显示url地址
/// Return：         
/// Others：       
Query GetReportResult(PreReportID As %String) As %Query(ROWSPEC = "TCCode:%String,TCName:%String,TCSyn:%String,Result:%String,Unit:%String,RefRanges:%String,SenResult:%String,LnkSenRes:%String")
{
}

ClassMethod GetReportResultSenClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetReportResultSenExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetReportResultSenExecute(ByRef qHandle As %Binary, ReportID As %String, TC As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	//
	s ^TMPPREREP=$g(ReportID)_":"_$g(TC)
	Kill ^TMP($zn,$j)
	Set LabNo=$Piece(ReportID,"||",1)
	Set TS=$Piece(ReportID,"||",2)
	Set TSCNT=$Piece(ReportID,"||",3)
	Set Num=$Piece(ReportID,"||",4)
	Set ant=""
	For {
		Set ant=$Order(^["LABDATA"]DHCPreReport(LabNo,TS,TSCNT,Num,"DATA",TC,"ANT",ant))
		Quit:ant=""
		Set SenResDr=$Piece(^["LABDATA"]DHCPreReport(LabNo,TS,TSCNT,Num,"DATA",TC,"ANT",ant),"\",1)
		Set mmRes=$Piece(^["LABDATA"]DHCPreReport(LabNo,TS,TSCNT,Num,"DATA",TC,"ANT",ant),"\",3)
		Set Order=$Piece(^["LABDATA"]DHCPreReport(LabNo,TS,TSCNT,Num,"DATA",TC,"ANT",ant),"\",4)
		Set SenResDesc=""
		If $Length(SenResDr),$Data(^TTAB("SENS",SenResDr)) Set SenResDesc=$Piece(^TTAB("SENS",SenResDr),"\",1)
		If '$Length(Order) Set Order=1
		Set AntName=$Piece(^TTAB("ANT",ant),"\",1)
		Set AntEng=""
		i $Data(^["LABDATA"]DHCANTIBIOTICS(ant)) Set AntEng=$Piece(^["LABDATA"]DHCANTIBIOTICS(ant),"\",1)
		Set Data=$lb(ant,AntName,AntEng,mmRes,SenResDesc)
		Set ^TMP($zn,$j,1,Order,ant)=Data
	}
	//输出
	Set ord=""
	For {
		Set ord=$Order(^TMP($zn,$j,1,ord))
		Quit:ord=""
		Set ant=""
		For {
			Set ant=$Order(^TMP($zn,$j,1,ord,ant))
			Quit:ant=""
			Set Data=^TMP($zn,$j,1,ord,ant)
			Do OutputRow
		}
	}
	Set qHandle=$lb(0,repid,0)
	Kill ^TMP($zn,$j)
	Quit $$$OK
OutputRow
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetReportResultSenFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetReportResultSenExecute ]
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
/// CreatDate：    20090824
/// Description:： 根据报告ID得到预报告药敏结果
/// Table：        DHC_PreReportDataAntibiotics
/// Input：        预报告ID,项目代码
/// Output：       抗生素代码,名称,英文名称,mm结果,药敏结果
/// Return：         
/// Others
Query GetReportResultSen(ReportID As %String, TC As %String) As %Query(ROWSPEC = "AntCode:%String,AntName:%String,AntSyn:%String,mmRes:%String,Result:%String")
{
}

}
