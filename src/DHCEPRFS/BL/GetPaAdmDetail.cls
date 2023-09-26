Class DHCEPRFS.BL.GetPaAdmDetail Extends %Persistent [ ProcedureBlock ]
{

/// craater:  YHY
/// Debug:    d ##class(%ResultSet).RunQuery("DHCEPRFS.BL.GetPaAdmDetail","GetPaAdmList","2011-11-25","2013-10-09","","500144")
Query GetPaAdmList(Stdate As %Date, Enddate As %Date, APAAdmStatus As %String, AMedicareNo As %String) As %Query(ROWSPEC = "PAPMIDR:%String,MedicareNo:%String,PAADMRowID:%String,PAPMIName:%String,PAPMIDOB:%String,PAPMISex:%String,PAAdmDate:%String,PAAdmTime:%String,PAAdmDepCodeDR:%String,PAAdmDocCodeDR:%String,PAAdmWard:%String,PAADMReason:%String,PADischgeDate:%String,PADischgeTime:%String,Warddesc:%String,EprDocStatusDesc:%String,EprNurStatusDesc:%String,EprPdfStatusDesc:%String,DisDate:%String,mrEpisodeID:%String,MRVerItemsIDs:%String,StatusDesc:%String")
{
}

ClassMethod GetPaAdmListExecute(ByRef qHandle As %Binary, Stdate As %Date, Enddate As %Date, APAAdmStatus As %String, AMedicareNo As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set ind = 1
	set qHandle = $lb(0,repid,0)
	s MedicareNo = ""
	s PAADMRowID = ""
	if (AMedicareNo '="")
	{
		s PAPMIDR = $o(^PAPERi("Medicare1",AMedicareNo,""))
		s PAAdmType = "O"
		d GetPAADMRowID
		s PAAdmType = "I"
		d GetPAADMRowID
		s PAAdmType = "E"
		d GetPAADMRowID
	}
	elseif (Stdate '= "")&(Enddate '= "")
	{
		s StDate = $zdh(Stdate,3),EndDate=$zdh(Enddate,3)
		for AdmDate = StDate:1:EndDate {
			s PAADMRowID = ""
			//w "按时间段查询",!
			for {	
				s PAADMRowID = $o(^PAADMi("DischDate",AdmDate,PAADMRowID))
				q:(PAADMRowID = "")
				s AdmStatus=$P($g(^PAADM(PAADMRowID)),"^",20)
				continue:(AdmStatus '= "D")
				s StatusDescCode = ##Class(DHCEPRFS.BL.BLMRLog).IsRecordPassed(PAADMRowID)
				continue:(APAAdmStatus '= StatusDescCode)
				d IsArrivedQue
			}
		}			
	}
	
	Quit $$$OK
GetPAADMRowID
    for {
		s PAADMRowID = $o(^PAPERdr(PAPMIDR,"ADM",PAAdmType,PAADMRowID))
		q:(PAADMRowID = "")
		s AdmStatus=$P($g(^PAADM(PAADMRowID)),"^",20)
		continue:(AdmStatus '= "D")
		s StatusDescCode = ##Class(DHCEPRFS.BL.BLMRLog).IsRecordPassed(PAADMRowID)
		continue:(APAAdmStatus '= StatusDescCode)
		if (Stdate '= "")
		{
			s StDate = $zdh(Stdate,3)
			s AdmStdate = $P($g(^PAADM(PAADMRowID)),"^",17)
			
			continue:(AdmStdate < StDate)
		}
		if (Enddate '= "")
		{
			s EndDate=$zdh(Enddate,3)
			s AdmEndDate = $P($g(^PAADM(PAADMRowID)),"^",17)
			
			continue:(AdmEndDate > EndDate)
			
		}
		
		d IsArrivedQue
		
	}
	Quit	
IsArrivedQue
	s mCurrRow = $g(^PAADM(PAADMRowID))
	s PAADMDepCode=$p($g(mCurrRow),"^",4)
	if (PAADMDepCode '= "")
	{
		s PAAdmDepCodeDR = $p($g(^CTLOC(PAADMDepCode)),"^",2)
	}
	else
	{
		s PAAdmDepCodeDR = "无"
	}
	d outputrow
	Quit
	
outputrow
	s PAPMIDR = $p($g(mCurrRow),"^",1)
	s PAPMIName = $p($g(^PAPER(PAPMIDR,"ALL")),"^",1)
	s MedicareNo = $P($g(^PAPER(PAPMIDR,"PAT",1)),"^",22)
	s PAPMISexDR = $P($g(^PAPER(PAPMIDR,"ALL")),"^",7)
	s PAPMISex = $p($g(^CT("SEX",PAPMISexDR)),"^",2)
	//日期时间处理
	s PAPMIDOB = $p($g(^PAPER(PAPMIDR,"ALL")),"^",6)
	if (PAPMIDOB '= "")
	{
		s PAPMIDOB = $zd(PAPMIDOB,3)
	}
	s PAAdmTime = $p($g(mCurrRow),"^",7)
	if (PAAdmTime '= "")
	{
		s PAAdmTime = $zt(PAAdmTime,3)
	}
	s PAAdmDate = $p($g(mCurrRow),"^",6)
	if (PAAdmDate '= "")
	{
		s PAAdmDate = $zd(PAAdmDate,3)
	}
	s PADischgeDate=$P($g(^PAADM(PAADMRowID)),"^",17)
	if (PADischgeDate '= "")
	{
		s PADischgeDate = $zd(PADischgeDate,3)
	}
	s PADischgeTime=$P($g(^PAADM(PAADMRowID)),"^",18)
	if (PADischgeTime '= "")
	{
		s PADischgeTime = $zt(PADischgeTime,3)
	}
	
	s PAADMReasonDR = $p($g(^PAADM(PAADMRowID,1)),"^",7)
	if (PAADMReasonDR '= "")
	{
		s PAADMReason = $p($g(^PAC("ADMREA",PAADMReasonDR)),"^",2)
	}
	else
	{
		s PAADMReason = "无"
	}
	s PAADMDocCode=$p($g(mCurrRow),"^",9)
	if (PAADMDocCode '= "")
	{
		s PAAdmDocCodeDR = $p($g(^CTPCP(PAADMDocCode,1)),"^",2)
	}
	else
	{
		s PAAdmDocCodeDR = "无"
	}
	
	//以下是获取患者当前病区
	s disWardDR = $P($g(^PAADM(PAADMRowID)),"^",70)
	if (disWardDR '= "")
	{
		s Wardcode =$p($g(^PAWARD(disWardDR)),"^",1)
		s Warddesc =$p($g(^PAWARD(disWardDR)),"^",2) 
	}
	else
	{
		s Wardcode = "无"
		s Warddesc = "无"
	}
	s EprStatus=##Class(DHCEPRFS.BI.BIToWMR).GetMedRecordStatus(PAADMRowID)
	
	s EprDocStatus=+$p(EprStatus,"^",2)
	s EprDocStatusDesc=$s(EprDocStatus=1:"是",1:"否")
	s EprNurStatus=+$p(EprStatus,"^",1)
	s EprNurStatusDesc=$s(EprNurStatus=1:"是",1:"否")
	s EprPdfStatus=+$p(EprStatus,"^",3)
	s EprPdfStatusDesc=$s(EprPdfStatus=1:"是",1:"否")
	s DisDateTime=##class(EPRservice.HISInterface.PatientInfoAssist).DisDateTime(PAADMRowID)
	s DisDate = $p(DisDateTime,",",1)
	s DisTime = $p(DisDateTime,",",2)
	s DisDate=$zd(DisDate,3)_" "_$zt(DisTime,3)
	
	s mrEpisodeID = ##Class(DHCEPRFS.BL.BLMREpisode).GetMREpisodeIDByAdm(PAADMRowID, "DHC")
	s mrVersionID = ##Class(DHCEPRFS.BL.BLMRVersion).GetMRVersionID(mrEpisodeID,"")
	s MRVerItemsIDs = ##class(DHCEPRFS.BL.BLMRVerItem).GetAllByVersionString(mrVersionID)
	s StatusDescCode = ##Class(DHCEPRFS.BL.BLMRLog).IsRecordPassed(PAADMRowID)
	
	if (StatusDescCode="0") {s StatusDesc = "未审核"}
	if (StatusDescCode="DEPTREVIEWED") {s StatusDesc = "审核通过"}
	if (StatusDescCode="INITIALIZED") {s StatusDesc = "审核退回"}

	
	set ^CacheTemp(repid,ind) = $LB(PAPMIDR,MedicareNo,PAADMRowID,PAPMIName,PAPMIDOB,PAPMISex,PAAdmDate,PAAdmTime,PAAdmDepCodeDR,PAAdmDocCodeDR,PAAdmWard,PAADMReason,PADischgeDate,PADischgeTime,Warddesc,EprDocStatusDesc,EprNurStatusDesc,EprPdfStatusDesc,DisDate,mrEpisodeID,MRVerItemsIDs,StatusDesc)
	set ind = ind + 1
	Quit
}

ClassMethod GetPaAdmListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPaAdmListExecute ]
{
	Set repid = $LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetPaAdmListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPaAdmListExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
 	Set repid = $LIST(qHandle,2)
 	Set ind = $LIST(qHandle,3)
 	Set ind = $o(^CacheTemp(repid,ind))
 	If ind = "" {				// if there are no more rows, finish fetching
 		Set AtEnd = 1
 		Set Row = ""
 	}
 	Else      {				// fetch row
 		Set Row = ^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

Storage Default
{
<Data name="GetPaAdmDetailDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.BL.GetPaAdmDetailD</DataLocation>
<DefaultData>GetPaAdmDetailDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRFS.BL.GetPaAdmDetailD</IdLocation>
<IndexLocation>^DHCEPRFS.BL.GetPaAdmDetailI</IndexLocation>
<StreamLocation>^DHCEPRFS.BL.GetPaAdmDetailS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
