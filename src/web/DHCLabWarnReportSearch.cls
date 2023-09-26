Class web.DHCLabWarnReportSearch Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 49;

ClassMethod FindReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindReportExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindReportExecute(ByRef qHandle As %Binary, DateFrom As %String, DateTo As %String, WardCode As %String, DoctorCode As %String, getreclocid As %String, RegNo As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	Kill ^TMP($zn,$j)
	s ^TMPLOCATION=$G(DateFrom)_","_$g(DateTo)_","_$G(getreclocid)_","_WardCode_","_RegNo_","_DoctorCode
	s Location=$g(getreclocid)
	Set Config=##Class(websys.Configuration).%OpenId(1)
	Set LabData=Config.LabDataNamespace
	If '$Length(LabData) Set LabData="labdata"
	Set WebNS=$ZUTIL(5)
	//^CF("PATCF",1,3)=8^^8^8^81^^^^
	Set IPNoLength=$Piece(^CF("PATCF",1,3),"^",5)
	If '$Length(IPNoLength) Set IPNoLength=10
	If $Length(RegNo) Set RegNo=$tr($j(RegNo,IPNoLength)," ","0")
	//按登记号查询
	If $Length(RegNo){
		Set CDate=""
		For {
			Set CDate=$Order(^TDEB(RegNo,CDate),-1)
			Quit:CDate=""
			Set epis=""
			For {
				Set epis=$Order(^TDEB(RegNo,CDate,0,epis))
				Quit:epis=""
				Set TS=""
				//w !,epis
				For {
					Set TS=$Order(^TEPI(epis,1,TS))
					Quit:TS=""
					Set TSCNT=""
					For {
						Set TSCNT=$Order(^TEPI(epis,1,TS,TSCNT))
						Quit:TSCNT=""
						If $Piece(^TEPI(epis,1,TS,TSCNT),"\",31)="A"{
							Set Status=##Class(web.DHCLabReportControl).ReportStatus(epis_"||"_TS_"||"_TSCNT,LabData)
							i $Piece(Status,"^",1)=0{
								 Set ADate=$zdh($Piece($Piece(Status,"^",4)," ",1),3)
								 Set (flag1,flag2)=1
								 If $Length(DateFrom),ADate<DateFrom Set flag1=0
								 If $Length(DateTo),ADate>DateTo Set flag2=0
								 If flag1&flag2{
									 Set ATime=$zth($Piece($Piece(Status,"^",4)," ",2))
									 Set ReportMemo=$Piece(Status,"^",2)
									 Set ^TMP($zn,$j,"DT",ADate,ATime)=epis_"||"_TS_"||"_TSCNT_"^"_ReportMemo
								 }
							}	
						}
					}
				}
			}
		}
	}
	
	s ReportType="1"   ///检验危机值
	//按日期查询
	If '$Length(RegNo){
		If '$Length(DateFrom) Set DateFrom=+$h
		If '$Length(DateTo) Set DateTo=+$h
		For AuthDate=DateFrom:1:DateTo {
			Set LabNo=""
			For {
				Set LabNo=$Order(^[LabData]DHCPanicReport(0,"DATE",AuthDate,ReportType,LabNo))
				Quit:LabNo=""
				Set TS=""
				For {
					Set TS=$Order(^TEPI(LabNo,1,TS))
					Quit:TS=""
					Set TSCNT=""
					For {
						Set TSCNT=$Order(^TEPI(LabNo,1,TS,TSCNT))
						Quit:TSCNT=""
						//病区
						Set Flag=0
						If $Length(WardCode),$Piece(^TEPI(LabNo),"\",20)'=WardCode Set Flag=1 
						//科室
						If Flag=0,$Length(Location),$Piece(^TEPI(LabNo),"\",36)'=Location Set Flag=1
						//医生
						If Flag=0,$Length(DoctorCode),$Piece(^TEPI(LabNo),"\",13)'=DoctorCode Set Flag=1
						If Flag=0{
							Set Status=##Class(web.DHCLabReportControl).ReportStatus(LabNo_"||"_TS_"||"_TSCNT,LabData)
							//RetValue_"^"_TransMemo_"^"_RecDate_" "_RecTime_"^"_AuthDate_" "_AuthTime
							i $Piece(Status,"^",1)=0{
								 Set ADate=$zdh($Piece($Piece(Status,"^",4)," ",1),3)
								 Set ATime=$zth($Piece($Piece(Status,"^",4)," ",2))
								 Set ReportMemo=$Piece(Status,"^",2)
								 Set ^TMP($zn,$j,"DT",ADate,ATime)=LabNo_"||"_TS_"||"_TSCNT_"^"_ReportMemo
							}
						}
					}	
				}
			}
		}
	}
	Set ADate=""
	For {
		Set ADate=$Order(^TMP($zn,$j,"DT",ADate),-1)
		Quit:ADate=""
		Set ATime=""
		For {
			Set ATime=$Order(^TMP($zn,$j,"DT",ADate,ATime),-1)
			Quit:ATime=""
			//审核日期
			//审核时间
			//阅读标志
			Set TSRowId=$Piece(^TMP($zn,$j,"DT",ADate,ATime),"^",1)
			//提示
			Set ReportMemo=$Piece(^TMP($zn,$j,"DT",ADate,ATime),"^",2)
			Set LabNo=$Piece(TSRowId,"||",1)
			Set TS=$Piece(TSRowId,"||",2)
			Set TSCNT=$Piece(TSRowId,"||",3)
			//登记号
			Set Debtor=$Piece(^TEPI(LabNo),"\",18)
			//病人名称
			Set PatName=##Class(web.DHCLabCommon).GetPatName(LabNo)
			//医嘱名
			Set OrdName=$Piece(^TTAB("TS",TS),"\",1)
			//标本
			Set SpecDr=$Piece(^TEPI(LabNo,1,TS,TSCNT),"\",46)
			Set SpecName=""
			If $Length(SpecDr),$Data(^TTAB("SPEC",SpecDr)) Set SpecName=$Piece(^TTAB("SPEC",SpecDr),"\",1)
			//医生
			Set DocDr=$Piece(^TEPI(LabNo),"\",13)
			Set DocDesc=""
			If $Length(DocDr),$Data(^TTAB("DR",DocDr)) Set DocDesc=$Piece(^TTAB("DR",DocDr),"\",1)
			//科室
			Set LocDr=$Piece(^TEPI(LabNo),"\",36)
			Set LocDesc=""
			If $Length(LocDr),$Data(^TTAB("USLOC",LocDr)) Set LocDesc=$Piece(^TTAB("USLOC",LocDr),"\",1)
			//医嘱ID
			Set OrdId=$Order(^OEORD(0,"EpisNo",LabNo,""))
			Set OrdSub=""
			If $Length(OrdId) Set OrdSub=$Order(^OEORDi(0,"LabTS",OrdId,TSRowId,""))
			Set Flag=100
			Set PatId=""
			Set OrderId=""
			Set AdmNo=""
			If $Length(OrdId),$Length(OrdSub){
				Set OrderId=OrdId_"||"_OrdSub
				Set Flag=##Class(web.DHCLabReportControl).ReportViewLog(OrderId)
				Set AdmNo=$Piece(^OEORD(OrdId),"^",1)
				If $Length(AdmNo) Set PatId=$Piece(^PAADM(AdmNo),"^",1)
			}
			
			Do OutputRow
		}
	}
	Kill ^TMP($zn,$j)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(Debtor,PatName,OrdName,SpecName,$zd(ADate,3),$zt(ATime,2),ReportMemo,DocDesc,LocDesc,Flag,PatId,AdmNo,OrderId,TSRowId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindReportExecute ]
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

/// Creator：      huhm
/// CreatDate：    20090704
/// Description:： 查询危急值报告
/// Table：        EP_VisitNumber,EP_VisitTestSet,DHC_Trans,Websys.log
/// Input：        报告时间段,申请病区,申请科室,申请医生,登记号
/// Output：       登记号,病人姓名,医嘱名称,标本,报告日期,报告时间,危急提示,申请医生,申请科室,PatientID,EpisodeID,报告ID
/// Return：       
/// Others
Query FindReport(DateFrom As %String, DateTo As %String, WardCode As %String, DoctorCode As %String, getreclocid As %String, RegNo As %String) As %Query(ROWSPEC = "DebtorNo:%String,PatName:%String,OrdName:%String,SpecName:%String,AuthDate:%String,AuthTime:%String,WarnMemo:%String,CTDoc:%String,CTLoc:%String,ReadFlag:%String,PatientID:%String,EpisodeID:%String,OrderId:%String,TSRow:%String")
{
}

ClassMethod CTLocLookUpClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CTLocLookUpExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod CTLocLookUpExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
 	Set repid=$I(^CacheTemp)

 	If $g(ind)="" Set ind=1
	s rowid=0
	i $g(desc)=""  d
	.s desc="%"
	e  d
	.s desc=$$ALPHAUP^SSUTIL4(desc)
	.s desc=desc_"%"
	&sql(declare ctloc cursor  for 
	select distinct ctloc_desc,ctloc_Code
	              from SQLUser.ct_loc 
	              WHERE (UPPER(ctloc_desc) like :desc))
	&sql(open ctloc)
	f  &sql(fetch ctloc into :ctlocdesc,:ctlocrowid) q:SQLCODE  d
	.//
 	.Do OutputRow4	 	
 	&sql(close ctloc)
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow4
	set Data=$lb(ctlocdesc,ctlocrowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod CTLocLookUpFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CTLocLookUpExecute ]
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
/// CreatDate：    20090704
/// Description:： 查询科室
/// Table：        ct_loc
/// Input：        科室名称
/// Output：       科室名称,科室代码
/// Return：       
/// Others
Query CTLocLookUp(desc As %String) As %Query(ROWSPEC = "ctloc:%String,ctlocid:%String")
{
}

}
