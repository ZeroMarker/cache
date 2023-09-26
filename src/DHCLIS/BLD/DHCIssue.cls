Class DHCLIS.BLD.DHCIssue Extends %RegisteredObject
{

/// w ##class(DHCLIS.BLD.DHCIssue).GetPackScoutRecordDRsByAdm("1440265")
ClassMethod GetPackScoutRecordDRsByAdm(AdmNo) As %String
{
	s repid=$i(^CacheTemp)
 	s ind=1 
    s PackScouts=""
	k ^TMP($zn,repid,$j) 
	s total=0   
	
	
	s ReqFormDR="" f  s ReqFormDR=$o(^dbo.BDReqFormI("IndexAdmNo",##Class(LIS.Util.Common).IndexData(AdmNo),ReqFormDR)) Q:ReqFormDR=""  d
	.s IssueRecordDR="" f  s IssueRecordDR=$o(^dbo.BDIssueRecordI("IndexReqForm",ReqFormDR,IssueRecordDR)) q:(IssueRecordDR="")  d
	..s IssueRecordflag=""
	..s PackDR="" f  s PackDR=$o(^dbo.BDIssueRecordItemsI("IndexMaster",IssueRecordDR,PackDR)) q:(PackDR="")||(IssueRecordflag="1")  d
	...s IssueRecordItemsDR=$o(^dbo.BDIssueRecordItemsI("IndexMaster",IssueRecordDR,PackDR,""))
	...s IssueRecordItemsData=$g(^dbo.BDIssueRecordItemsD(IssueRecordItemsDR))
	...s IsReturned=$lg(IssueRecordItemsData,4)
	...i IsReturned=1 q
	...s IssueRecordflag="1"
	...i '$l(PackScouts) s PackScouts=PackDR
	...e  s PackScouts=PackScouts_","_PackDR
	

	q PackScouts
}

// w ##class(DHCLIS.BLD.DHCIssue).GetIssueRecordDRsByAdm("62233")

ClassMethod GetIssueRecordDRsByAdm(AdmNo) As %String
{
	s repid=$i(^CacheTemp)
 	s ind=1 
    s IssueRecords=""
	k ^TMP($zn,repid,$j) 
	s total=0   
	
	
	s ReqFormDR="" f  s ReqFormDR=$o(^dbo.BDReqFormI("IndexAdmNo",##Class(LIS.Util.Common).IndexData(AdmNo),ReqFormDR)) Q:ReqFormDR=""  d
	.s IssueRecordDR="" f  s IssueRecordDR=$o(^dbo.BDIssueRecordI("IndexReqForm",ReqFormDR,IssueRecordDR)) q:(IssueRecordDR="")  d
	..s IssueRecordflag=""
	..s PackDR="" f  s PackDR=$o(^dbo.BDIssueRecordItemsI("IndexMaster",IssueRecordDR,PackDR)) q:(PackDR="")||(IssueRecordflag="1")  d
	...s IssueRecordItemsDR=$o(^dbo.BDIssueRecordItemsI("IndexMaster",IssueRecordDR,PackDR,""))
	...s IssueRecordItemsData=$g(^dbo.BDIssueRecordItemsD(IssueRecordItemsDR))
	...s IsReturned=$lg(IssueRecordItemsData,4)
	...i IsReturned=1 q
	...s IssueRecordflag="1"
	...i '$l(IssueRecords) s IssueRecords=IssueRecordDR
	...e  s IssueRecords=IssueRecords_","_IssueRecordDR
	

	q IssueRecords
}

ClassMethod GetXMRecordDRsByAdm(AdmNo) As %String
{
	s repid=$i(^CacheTemp)
 	s ind=1 
    s IssueRecords=""
	k ^TMP($zn,repid,$j) 
	s total=0   
	
	
	s ReqFormDR="" f  s ReqFormDR=$o(^dbo.BDReqFormI("IndexAdmNo",##Class(LIS.Util.Common).IndexData(AdmNo),ReqFormDR)) Q:ReqFormDR=""  d
	.s PackDR="" f  s PackDR=$o(^dbo.BDXMPlanI("IndexMaster",ReqFormDR,PackDR)) q:(PackDR="")  d
	..s XMPlandr="" f  s XMPlandr=$o(^dbo.BDXMPlanI("IndexMaster",ReqFormDR,PackDR,XMPlandr)) q:(XMPlandr="")  d
	...s XMPlanNo=$lg($g(^dbo.BDXMPlanD(XMPlandr)),26)
	...S IsFinished=$lg($g(^dbo.BDXMPlanD(XMPlandr)),30)
	...I IsFinished'="1" Q
	...i '$l(XMRecords) s XMRecords=XMPlanNo
	...e  s XMRecords=XMRecords_","_XMPlanNo
	q XMRecords
}

ClassMethod GetReqFormDRsByAdm(AdmNo) As %String
{
	s repid=$i(^CacheTemp)
 	s ind=1 
    s ReqFormDRs=""
	k ^TMP($zn,repid,$j) 
	s total=0   
	 
	s ReqFormDR="" f  s ReqFormDR=$o(^dbo.BDReqFormI("IndexAdmNo",##Class(LIS.Util.Common).IndexData(AdmNo),ReqFormDR)) Q:ReqFormDR=""  d
    .s ReqFormData=$g(^dbo.BDReqFormD(ReqFormDR))
    .s Status=$lg(ReqFormData,51)
	.i (Status'=25)&&(Status'=35) q
	.i $l(ReqFormDRs) s ReqFormDRs=ReqFormDRs_","_ReqFormDR
	.e  s ReqFormDRs=ReqFormDR
	 
	q ReqFormDRs
}

/// w 
ClassMethod GetAgreeFormDRsByAdm(AdmNo) As %String
{
	s repid=$i(^CacheTemp)
 	s ind=1 
    s AgreeFormDRs=""
	k ^TMP($zn,repid,$j) 
	s total=0   
	 
	s AgreeFormDR="" f  s AgreeFormDR=$o(^dbo.BDAgreeFormI("IndexAdmNo",##Class(LIS.Util.Common).IndexData(AdmNo),AgreeFormDR)) Q:AgreeFormDR=""  d
    .s ReqFormData=$g(^dbo.BDAgreeFormD(AgreeFormDR))
    .s Status=$lg(ReqFormData,33)
	.i (Status'=20) q
	.i $l(AgreeFormDRs) s AgreeFormDRs=AgreeFormDRs_","_AgreeFormDR
	.e  s AgreeFormDRs=AgreeFormDR
	 
	q AgreeFormDRs
}

}
