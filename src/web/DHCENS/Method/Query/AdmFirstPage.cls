/// Creator:lipan
/// CreatDate:2014-12-21
/// d ##class(%ResultSet).RunQuery("web.DHCENS.Method.Query.AdmFirstPage","AdmFirstPage","2013-05-28","2013-06-01")
Class web.DHCENS.Method.Query.AdmFirstPage Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

/// 病案首页
Query AdmFirstPage(SDate As %String, EDate As %String) As %Query(ROWSPEC = "DocumentID:%String,VisitNum:%String,OperationCode:%String,OperationDesc:%String,OperationCode1:%String,OperationDesc1:%String,OperationCode2:%String,OperationDesc2:%String,OperationCode3:%String,OperationDesc3:%String,OperationCode4:%String,OperationDesc4:%String,InDiagCode:%String,InDiagDesc:%String,DiagnoseCode1:%String,DiagnoseDesc1:%String,DiagnoseCode2:%String,DiagnoseDesc2:%String,DiagnoseCode3:%String,DiagnoseDesc3:%String,DiagnoseCode4:%String,DiagnoseDesc4:%String,Year:%String,AdmSDate:%String,AdmSDeptCode:%String,AdmSDept:%String,AdmDDate:%String, AdmDDeptCode:%String, AdmDDept:%String,AgeYear:%String,AdmDays:%String,Charges:%String,BXAmount:%String,ZFAmount:%String,SalvageNumber:%String,HZSFCode:%String,HZSFDesc:%String,TranDeptCode:%String,TranDept:%String") [ SqlProc ]
{
}

ClassMethod AdmFirstPageExecute(ByRef qHandle As %Binary, SDate As %String, EDate As %String) As %Status
{
   
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	
	s Count = ..GetRecordAdmList(SDate,EDate)
	
	d OutputRow 
	 
	Quit $$$OK
OutputRow
		f num=1:1:Count-1
		{
			k ^TMPDHCENS("OperationCode",$j)
			k ^TMPDHCENS("OperationDesc",$j)
			k ^TMPDHCENS("DiagnoseDesc",$j)
			k ^TMPDHCENS("DiagnoseCode",$j)
	
			s PaadmRowId=^AdmFirstPage("AdmFirstPage",$j,num)
			s AdmObj=##class(web.DHCENS.BLL.Empi.Model.AdmFirstPageNew).%New()
			s AdmObj=##class(web.DHCENS.BLL.Empi.Method.SendAdmFirstPageNew).GetAdmFirstPage(PaadmRowId,"0")

			s DocumentID=AdmObj.DocumentID
			s VisitNum=AdmObj.VisitNum
			s num1=AdmObj.OperationInfo.Count()
			f i=0:1:num1-1
			{
				
				s SubObj=AdmObj.OperationInfo.GetAt(i+1)
				if (i=0)
				{	
					s OperationCode=SubObj.OperationCode
					s OperationDesc=SubObj.OperationDesc
				}
				else
				{
					s ^TMPDHCENS("OperationCode",$j,PaadmRowId,i)=SubObj.OperationCode
					s ^TMPDHCENS("OperationDesc",$j,PaadmRowId,i)=SubObj.OperationDesc
				}
			}

			s num2=AdmObj.DiagnoseInfo.Count()
			f j=0:1:num2-1
			{
				
				s SubObj=AdmObj.DiagnoseInfo.GetAt(j+1)
				if (j=0)
				{	
					s InDiagCode=SubObj.DiagnoseCode
					s InDiagDesc=SubObj.DiagnoseDesc
				}
				else
				{
	
					s ^TMPDHCENS("DiagnoseCode",$j,PaadmRowId,j)=SubObj.DiagnoseCode

					s ^TMPDHCENS("DiagnoseDesc",$j,PaadmRowId,j)=SubObj.DiagnoseDesc
				}
			}
			
			s AdmSDate=$p(AdmObj.AdmSDate," ")
			s Year=$p(AdmSDate,"-",1)
			
			s AdmSDept=AdmObj.AdmSDept
			s:AdmSDept'="" AdmSDeptCode=$o(^CTLOC(0,"Code",AdmSDept,""))
			s AdmDDate=$p(AdmObj.AdmDDate," ")
			
			s AdmDDept=AdmObj.AdmDDept
			s:AdmDDept'="" AdmDDeptCode=$o(^CTLOC(0,"Code",AdmDDept,""))
			s AgeYear=AdmObj.AgeYear
			s AdmDays=AdmObj.AdmDays
			s Charges=AdmObj.Charges
			s SalvageNumber=AdmObj.SalvageNumber
		
			s BXAmount=""
			s ZFAmount=""
			s HZSFCode=$p(^PAADM(PaadmRowId,1),"^",7)
			s HZSFDesc=$p(^PAC("ADMREA",HZSFCode),"^",2)
	
			s DiagnoseStr=##Class(web.DHCWMRCodingInterface).getFrontPageICDList(PaadmRowId,"D")
			s TranDeptCode=$p(DiagnoseStr,$c(2),3)
			s TranDept=$p(DiagnoseStr,$c(2),3)
			s data=$lb(DocumentID,VisitNum,$g(OperationCode),$g(OperationDesc),$g(^TMPDHCENS("OperationCode",$j,PaadmRowId,1)),$g(^TMPDHCENS("OperationDesc",$j,PaadmRowId,1)),$g(^TMPDHCENS("OperationCode",$j,PaadmRowId,2)),$g(^TMPDHCENS("OperationDesc",$j,PaadmRowId,2)),$g(^TMPDHCENS("OperationCode",$j,PaadmRowId,3)),$g(^TMPDHCENS("OperationDesc",$j,PaadmRowId,3)),$g(^TMPDHCENS("OperationCode",$j,PaadmRowId,4)),$g(^TMPDHCENS("OperationDesc",$j,PaadmRowId,4)),$g(InDiagCode),$g(InDiagDesc),$g(^TMPDHCENS("DiagnoseCode",$j,PaadmRowId,1)),$g(^TMPDHCENS("DiagnoseDesc",$j,PaadmRowId,1)),$g(^TMPDHCENS("DiagnoseCode",$j,PaadmRowId,2)),$g(^TMPDHCENS("DiagnoseDesc",$j,PaadmRowId,2)),$g(^TMPDHCENS("DiagnoseCode",$j,PaadmRowId,3)),$g(^TMPDHCENS("DiagnoseDesc",$j,PaadmRowId,3)),$g(^TMPDHCENS("DiagnoseCode",$j,PaadmRowId,4)),$g(^TMPDHCENS("DiagnoseDesc",$j,PaadmRowId,4)),Year,AdmSDate,AdmSDeptCode,AdmSDept,AdmDDate, AdmDDeptCode, AdmDDept,AgeYear,AdmDays,Charges,BXAmount,ZFAmount,SalvageNumber,HZSFCode,HZSFDesc,TranDeptCode,TranDept)
			
			s ^CacheTemp(repid,ind)=data
			s ind=ind+1
		}
	q
}

ClassMethod AdmFirstPageClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = AdmFirstPageExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod AdmFirstPageFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = AdmFirstPageExecute ]
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

ClassMethod GetRecordAdmList(argDateFrom As %String, argDateTo As %String) As %String
{
	k ^AdmFirstPage("AdmFirstPage",$j)
	s Num=1
	;New (argDateFrom,argDateTo)
	//Set return=""
	/*Set:argDateFrom["/" argDateFrom=$zdh(argDateFrom,4)
	Set:argDateFrom["-" argDateFrom=$zdh(argDateFrom,3)
	Set:argDateFrom'="" argDateFrom=+argDateFrom
	Set:argDateTo["/" argDateTo=$zdh(argDateTo,4)
	Set:argDateTo["-" argDateTo=$zdh(argDateTo,3)
	Set:argDateTo'="" argDateTo=+argDateTo*/
    s:(argDateFrom="")||(argDateFrom=$c(0)) argDateFrom=$zd(+$h-2,3)
    s:( argDateTo="")||( argDateTo=$c(0)) argDateTo=$zd(+$h-2,3)
    s:(argDateFrom'="") argDateFrom=$zdh(argDateFrom,3)
    s:(argDateTo'="") argDateTo=$zdh(argDateTo,3)
	//取当前系统的病案编目操作ID   归档上架
	//s ^tmpgsbEnsHQMS=argDateFrom_"#"_argDateTo 
	
	//update by zf 病案3.0版本升级，兼容原有接口
	set MRSVersion=##Class(DHCWMR.IO.OutService).GetMRSVersion()
	if MRSVersion=3 {
		set stdata=argDateFrom,sttime=$zth("00:00:00",1)
		set enddata=argDateTo,endtime=$zth("23:59:59",1)
		for mDate=stdata:1:enddata {
			set $p(strInput,"^",1)=mDate
			set $p(strInput,"^",2)=$s(mDate=stdata:sttime,1:0)
			set $p(strInput,"^",3)=0
			set $p(strInput,"^",4)=""
			set $p(strInput,"^",5)=""
			set $p(strInput,"^",6)=enddata
			set $p(strInput,"^",7)=endtime
			for {
				set strOutput=##class(DHCWMR.IO.OutService).IGetFPCodingAdms(strInput,"")
				quit:strOutput=""
				set IsFinish=+$p(strOutput,"^",4)
				set AdmList=$p(strOutput,"^",5)
				quit:AdmList=""
				for indAdm=1:1:$l(AdmList,",") {
					set admdr=$p(AdmList,",",indAdm)
					continue:admdr=""
					
					set ^AdmFirstPage("AdmFirstPage",$j,Num)=admdr
					set Num=Num+1
				}
				quit:IsFinish=1
				set $p(strInput,"^",1)=$p(strOutput,"^",1)
				set $p(strInput,"^",2)=$p(strOutput,"^",2)
				set $p(strInput,"^",3)=$p(strOutput,"^",3)
				set $p(strInput,"^",4)=""
				set $p(strInput,"^",5)=""
				set $p(strInput,"^",6)=$p(strOutput,"^",6)
				set $p(strInput,"^",7)=$p(strOutput,"^",7)
			}
		}
	} else {
		Set WorkItemId="",ret="-1"
		For{
			Set WorkItemId=$o(^DHCWMRWITM(WorkItemId))
			Quit:WorkItemId=""
			Continue:$p($g(^DHCWMRWITM(WorkItemId)),"^",3)="N"
			s:$p($g(^DHCWMRWITM(WorkItemId)),"^",2)="病案编目" StatusDr=WorkItemId   //根据医院病案编目具体的描述来判断
		}
		//如果传入参数为空，前一天的归档操作的所有病案
		if (argDateTo="")&&(argDateFrom="")
		{
			f QueryDate=argDateFrom:1:argDateTo
			{
				Set MainVolumeId=""
				for{
					Set MainVolumeId=$o(^DHCWMRVOL(0,"VSDateStatus",QueryDate,StatusDr,MainVolumeId))
					Quit:MainVolumeId=""
					Continue:QueryDate>argDateTo
			
					Continue:$p($g(^DHCWMRVOL(MainVolumeId)),"^",7)="N"
					Set PaadmDr=$p($g(^DHCWMRVOL(MainVolumeId)),"^",2)
				
					s ^AdmFirstPage("AdmFirstPage",$j,Num)=PaadmDr
					s Num=Num+1
					}
			
			}
		}
		//如果两个传入参数不为空
		if (argDateFrom'="")&&(argDateTo'="")
		{
			f QueryDate=argDateFrom:1:argDateTo
			{
				Set MainVolumeId=""
				for{
					Set MainVolumeId=$o(^DHCWMRVOL(0,"VSDateStatus",QueryDate,StatusDr,MainVolumeId))
					Quit:MainVolumeId=""
					Continue:QueryDate>argDateTo
			
					Continue:$p($g(^DHCWMRVOL(MainVolumeId)),"^",7)="N"
					Set PaadmDr=$p($g(^DHCWMRVOL(MainVolumeId)),"^",2)
				
					s ^AdmFirstPage("AdmFirstPage",$j,Num)=PaadmDr
					s Num=Num+1
				   }
			}
		
		}	
	}
	q Num
}

}
