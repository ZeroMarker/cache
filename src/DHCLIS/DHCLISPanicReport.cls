Class DHCLIS.DHCLISPanicReport Extends %RegisteredObject
{

Query QueryPanicReport(fLocationDR, fWardDR, FromDate, ToDate, HospID, fDoctorDR, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %Query(ROWSPEC = "RegNo,SurName,TestSetName,SpecimenName,LocationName,DoctorName,MachineParameterName,VisitNumber,TestCodeName,Result,TextRes,ExtraRes,OtherRes,ResNotes,AbFlag,RefRanges,AddDateTime,AddUserName,EntryDateTime,EntryUserName,AuthDateTime,AuthUserName,MajorConclusion,VisitNumberReportDR")
{
}

/// Creator：      sunzhiwen
/// CreatDate：    
/// Description:： 根据科室查询病区信息
/// Table：        
/// Input：        
/// Others：  d ##Class(%ResultSet).RunQuery("DHCLIS.DHCLISPanicReport","QueryPanicReport","","","20140101","20151212","2","2","","","","","","","","","")     
ClassMethod QueryPanicReportExecute(ByRef qHandle As %Binary, fLocationDR, fWardDR, FromDate, ToDate, HospID, fDoctorDR, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1	
	i $l(FromDate) s FromDate=$tr(FromDate,"-")
	i $l(ToDate) S ToDate=$tr(ToDate,"-")
	i $l(HospID) s CurHospitalCode=$p(^CT("HOSP",HospID),"^",1) s HospitalDR=$o(^dbo.BTHospitalI("IndexCode",##Class(LIS.Util.Common).IndexData(CurHospitalCode),""))
	i '$l(HospitalDR) s HospitalDR = $o(^dbo.BTHospitalD(""))
	s RequestDate = FromDate-1
	for {
		s RequestDate = $o(^dbo.RPVisitNumberI("IndexRequestDate",HospitalDR,RequestDate)) 
		q:(RequestDate>ToDate)||(RequestDate="")
		s VisitNumberDR=""
		for {
			s VisitNumberDR = $o(^dbo.RPVisitNumberI("IndexRequestDate",HospitalDR,RequestDate,VisitNumberDR))
			q:VisitNumberDR=""
			s AddDate=""
			for {
				s AddDate = $o(^dbo.RPVisitNumberPanicReportI("IndexMaster",VisitNumberDR,AddDate))
				q:AddDate=""
				s AddTime=""
				for {
					s AddTime = $o(^dbo.RPVisitNumberPanicReportI("IndexMaster",VisitNumberDR,AddDate,AddTime))
					q:AddTime=""
					s (RegNo,SurName,TestSetName,SpecimenName,LocationName,DoctorName,MachineParameterName,VisitNumber,TestCodeName,Result,TextRes,ExtraRes,OtherRes,ResNotes,AbFlag,RefRanges,AddDateTime,AddUserName,EntryDateTime,EntryUserName,AuthDateTime,AuthUserName,MajorConclusion,VisitNumberReportDR)=""
					s VisitNumberData = $g(^dbo.RPVisitNumberD(VisitNumberDR))
					s VisitNumber=$lg(VisitNumberData,2)
					s RegNo = $lg(VisitNumberData,3)
					s SurName=$lg(VisitNumberData,13)
					s WorkGroupMachineDR = $o(^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR,""))
					i $l(WorkGroupMachineDR) d
					.s OrderNo = $o(^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR,WorkGroupMachineDR,""))
					.s VisitNumberReportDR = $o(^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR,WorkGroupMachineDR,OrderNo,""))
					s TestSetName=""
					s TestSetDR="" f  s TestSetDR=$o(^dbo.RPVisitNumberTestSetI("IndexMaster",VisitNumberDR,TestSetDR)) q:TestSetDR=""  d
					.i $l(TestSetName) s TestSetName=TestSetName_"+"_$lg($g(^dbo.BTTestSetD(TestSetDR)),3)
					.e  s TestSetName=$lg(^dbo.BTTestSetD(TestSetDR),3)
					s LocationDR = $lg(VisitNumberData,22)
					s WardDR = $lg(VisitNumberData,26)
					i $l(fLocationDR),LocationDR'=fLocationDR q
					i $l(fWardDR),WardDR'=fWardDR q
					s LocationName=""
					i $l(LocationDR) s LocationName=$lg(^dbo.BTLocationD(LocationDR),3)
					s DoctorDR = $lg(VisitNumberData,23)
					i $l(fDoctorDR),fDoctorDR'=DoctorDR q
					s DoctorName=""
					i $l(DoctorDR) s DoctorName=$lg($g(^dbo.BTDoctorD(DoctorDR)),3)
					s SpecimenDR = $lg(VisitNumberData,56)
					s SpecimenName=""
					i $l(SpecimenDR) s SpecimenName=$lg(^dbo.BTSpecimenD(SpecimenDR),3)
					s PanicReportDR = $o(^dbo.RPVisitNumberPanicReportI("IndexMaster",VisitNumberDR,AddDate,AddTime,""))
					s PanicReportData = $g(^dbo.RPVisitNumberPanicReportD(PanicReportDR))
					s AddDate = $lg(PanicReportData,4)
					s AddTime = $lg(PanicReportData,5)
					s AddDateTime = AddDate_" "_$zt(AddTime)
					s AddUserDR = $lg(PanicReportData,6)
					s AddUserName=""
					i $l(AddUserDR) s AddUserName=$lg(^dbo.SYSUserD(AddUserDR),3)
					s EntryDate=$lg(PanicReportData,7)
					s EntryTime=$lg(PanicReportData,8)
					s EntryDateTime = EntryDate_" "_$zt(EntryTime)
					s EntryUserDR=$lg(PanicReportData,9),EntryUserName=""
					i $l(EntryUserDR) s EntryUserName=$lg(^dbo.SYSUserD(EntryUserDR),3)
					s AuthDate=$lg(PanicReportData,10)
					s AuthTime=$lg(PanicReportData,11)
					s AuthDateTime = AuthDate_" "_$zt(AuthTime)
					s AuthUserDR=$lg(PanicReportData,12),AuthUserName=""
					i $l(AuthUserDR) s AuthUserName=$lg(^dbo.SYSUserD(AuthUserDR),3)
					s MajorConclusion=$lg(PanicReportData,13)
					s Data = $lb(RegNo,SurName,TestSetName,SpecimenName,LocationName,DoctorName,MachineParameterName,VisitNumber,TestCodeName,Result,TextRes,ExtraRes,OtherRes,ResNotes,AbFlag,RefRanges,AddDateTime,AddUserName,EntryDateTime,EntryUserName,AuthDateTime,AuthUserName,MajorConclusion,VisitNumberReportDR)
					d OutputRow
#;					s TestCodeDR=""
#;					f  {
#;						s TestCodeDR=$o(^dbo.RPVisitNumberPanicResultI("IndexMaster",PanicReportDR,TestCodeDR)) 
#;						Quit:TestCodeDR=""
#;						s PanicResultDR=""
#;						for {
#;							s PanicResultDR = $o(^dbo.RPVisitNumberPanicResultI("IndexMaster",PanicReportDR,TestCodeDR,PanicResultDR))
#;							q:PanicResultDR=""
#;							s PanicResultData = $g(^dbo.RPVisitNumberPanicResultD(PanicResultDR))
#;							s TestCodeName=""
#;							i $l(TestCodeDR) s TestCodeName=$lg($g(^dbo.BTTestCodeD(TestCodeDR)),3)
#;							s MachineParameterDR=$lg(PanicResultData,12),MachineParameterName=""
#;							i $l(MachineParameterDR) s MachineParameterName=$lg($g(^dbo.BTMIMachineParameterD(MachineParameterDR)),3)
#;							s Result=$lg(PanicResultData,4)
#;						    s TextRes=$lg(PanicResultData,5)
#;						    s ExtraRes=$lg(PanicResultData,6)
#;						    s OtherRes=$lg(PanicResultData,7)
#;						    s ResNotes=$lg(PanicResultData,8)
#;						    s AbFlag=$lg(PanicResultData,9)
#;						    s RefRanges=$lg(PanicResultData,10)
#;						    s MethodDR=$lg(PanicResultData,11)
#;						    s AssayDate=$lg(PanicResultData,13)
#;						    s AssayTime=$lg(PanicResultData,14)
#;							
#;						}
#;					}
				}
			}
		}
	}
	
	Set qHandle=$lb(0,repid,0)
	k TMP($zn,$j)
	Quit $$$OK
	
OutputRow
	s iLen=$LISTLENGTH(Data)
	f i=1:1:iLen s $LI(Data,i)=$tr($LI(Data,i),$c(0))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryPanicReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryPanicReportExecute ]
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

ClassMethod QueryPanicReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryPanicReportExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
