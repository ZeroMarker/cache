/// 名称： EPRservice.BLL.LISDATA.BLLISDATA
/// 描述:按就诊号或按病人号分页查询或查询一段时间内的检验医嘱(返回已经执行的检验套列表)
/// 创建者：Candyxu
/// 创建时间：2011-12-07
Class EPRservice.BLL.LISDATA.BLLISDATA Extends %RegisteredObject [ ProcedureBlock ]
{

///  Creator: Candyxu
///  CreatTime: 2011-12-07
///  Input: PID：当PFlag为1时PID为EpisodeID,否则SelectID为patientID，PStartDate：开始时间
///        PEndDate：结束时间，PStartPage：返回分页开始页号，PEendPage：返回分页结束页号
///  OutPut:OEordItemRowID:医嘱ID,OEordItemDesc:医嘱名称,LabEpisodeNo:标本号,SpecimenDesc:标本类型,CollectionDate:,CollectionTime:,ReceiveDate:送检日期,ReceiveTime:送检时间,AuthorisationDate:,AuthorisationTime:,ExistReport:,EpisodeDate:就诊日期,EpisodeSection:就诊科室	
///  d ##class(%ResultSet).RunQuery("EPRservice.BLL.LISDATA.BLLISDATA","GetListDataList","50729","","",1,5,1)
Query GetListDataList(PID As %String, PStartDate As %String, PEndDate As %String, PStartPage As %String, PEendPage As %String, PFlag As %String) As %Query(ROWSPEC = "OEordItemRowID:%String,OEordItemDesc:%String,LabEpisodeNo:%String,SpecimenDesc:%String,CollectionDate:%String,CollectionTime:%String,ReceiveDate:%String,ReceiveTime:%String,AuthorisationDate:%String,AuthorisationTime:%String,ExistReport:%String,EpisodeDate:%String,EpisodeSection:%String")
{
}

ClassMethod GetListDataListExecute(ByRef qHandle As %Binary, PID As %String, PStartDate As %String, PEndDate As %String, PStartPage As %String, PEendPage As %String, PFlag As %String) As %Status
{
	S repid=$I(^CacheTemp)
	S qHandle=$lb(0,repid,0)
 	S ind=1
 	S TotalCount=0 
 	if PFlag = "1"
 	{
	   s episodeDate = $ZD($p($g(^PAADM(PID)),"^",6),3)	 	
	   s deptId=$p(^PAADM(PID),"^",4)
	   i (deptId'="") set deptDesc=$p(^CTLOC(deptId),"^",2) else  set deptDesc=" "
	   s:($f(deptDesc,"-")'=0) deptDesc = $p(deptDesc,"-",2)
	 		
	   s ds = ##Class(%Library.ResultSet).%New("DHCLabToEPR.DHCLabTestSetQuery:SelectLISItemListByCount")
	   d ds.Execute(PID,PStartPage,PEendPage)
       While (ds.Next()){
	       s OEordItemRowID = ds.Data("OEordItemRowID")
	       s OEordItemDesc = ds.Data("OEordItemDesc")
	       s LabEpisodeNo = ds.Data("LabEpisodeNo")
	       s SpecimenDesc = ds.Data("SpecimenDesc")
	      s CollectionDate = ds.Data("CollectionDate")
	      s CollectionTime = ds.Data("CollectionTime")
	      s ReceiveDate = ds.Data("ReceiveDate")
	      s ReceiveTime = ds.Data("ReceiveTime")
	      s AuthorisationDate = ds.Data("AuthorisationDate")
	      s AuthorisationTime = ds.Data("AuthorisationTime")
	      s ExistReport = ds.Data("ExistReport")
	      s:(OEordItemRowID="") OEordItemRowID = " "
	      s:(OEordItemDesc="") OEordItemDesc = " "
	      s:(LabEpisodeNo="") LabEpisodeNo = " "
	      s:(SpecimenDesc="") SpecimenDesc = " "
	      s:(CollectionDate="") CollectionDate = " "
	      s:(CollectionTime="") CollectionTime = " "
	      s:(ReceiveDate="") ReceiveDate = " "
	      s:(ReceiveTime="") ReceiveTime = " "
	      s:(AuthorisationDate="") AuthorisationDate = " "
	      s:(AuthorisationTime="") AuthorisationTime = " "
	      s:(ExistReport="") ExistReport = " "
	      
	      //20121031 wangwentao add fixed data LabEpisodeNo="$c(0,0)_"0&?0&?"_$c(0,0,0)"
	      s:(+LabEpisodeNo=0) LabEpisodeNo = " "
	      
	      s data = $lb(OEordItemRowID,OEordItemDesc,LabEpisodeNo,SpecimenDesc,CollectionDate,CollectionTime,ReceiveDate,ReceiveTime,AuthorisationDate,AuthorisationTime,ExistReport,episodeDate,deptDesc)
	      
	      //s data = $lb(ds.Data("OEordItemRowID"),ds.Data("OEordItemDesc"),ds.Data("LabEpisodeNo"),ds.Data("SpecimenDesc"),ds.Data("CollectionDate"),ds.Data("CollectionTime"),ds.Data("ReceiveDate"),ds.Data("ReceiveTime"),ds.Data("AuthorisationDate"),ds.Data("AuthorisationTime"),ds.Data("ExistReport"),episodeDate,deptDesc)
	      s ^CacheTemp(repid,ind) = data
	      s ind = ind + 1
       }
	}
   else
	{
	   s typeRowID = "0" 
	   for {
	 	  s typeRowID = $o(^PAPERdr(PID,"ADM",typeRowID))
	 	  q:(typeRowID = "")
	      s episodeID = "0"
	 	  for {
		 	s episodeID = $o(^PAPERdr(PID,"ADM",typeRowID,episodeID))
		 	q:(episodeID = "")
		 	s episodeDate = $ZD($p($g(^PAADM(episodeID)),"^",6),3)
		 	s deptId=$p(^PAADM(episodeID),"^",4)
			i (deptId'="") set deptDesc=$p(^CTLOC(deptId),"^",1) else  set deptDesc=" "
			i (PStartDate = $c(0)) || (PStartDate = "") 
			{
	          s ds = ##Class(%Library.ResultSet).%New("DHCLabToEPR.DHCLabTestSetQuery:SelectLISItemListByCount")
	          d ds.Execute(episodeID,1,1000000)
	        }
	        else
	        {
		      s ds = ##Class(%Library.ResultSet).%New("DHCLabToEPR.DHCLabTestSetQuery:SelectLISItemListByDate")
	          d ds.Execute(episodeID,PStartDate,PEndDate)
		    }
  	        While (ds.Next()){
	           s TotalCount = TotalCount + 1 
		       i (TotalCount>= PStartPage)&&( TotalCount<=PEendPage)
		       {
			       s OEordItemRowID = ds.Data("OEordItemRowID")
			       s OEordItemDesc = ds.Data("OEordItemDesc")
			       s LabEpisodeNo = ds.Data("LabEpisodeNo")
			       s SpecimenDesc = ds.Data("SpecimenDesc")
			      s CollectionDate = ds.Data("CollectionDate")
			      s CollectionTime = ds.Data("CollectionTime")
			      s ReceiveDate = ds.Data("ReceiveDate")
			      s ReceiveTime = ds.Data("ReceiveTime")
			      s AuthorisationDate = ds.Data("AuthorisationDate")
			      s AuthorisationTime = ds.Data("AuthorisationTime")
			      s ExistReport = ds.Data("ExistReport")
			      s:(OEordItemRowID="") OEordItemRowID = " "
			      s:(OEordItemDesc="") OEordItemDesc = " "
			      s:(LabEpisodeNo="") LabEpisodeNo = " "
			      s:(SpecimenDesc="") SpecimenDesc = " "
			      s:(CollectionDate="") CollectionDate = " "
			      s:(CollectionTime="") CollectionTime = " "
			      s:(ReceiveDate="") ReceiveDate = " "
			      s:(ReceiveTime="") ReceiveTime = " "
			      s:(AuthorisationDate="") AuthorisationDate = " "
			      s:(AuthorisationTime="") AuthorisationTime = " "
			      s:(ExistReport="") ExistReport = " "
			      s data = $lb(OEordItemRowID,OEordItemDesc,LabEpisodeNo,SpecimenDesc,CollectionDate,CollectionTime,ReceiveDate,ReceiveTime,AuthorisationDate,AuthorisationTime,ExistReport,episodeDate,deptDesc)
			     
	              //s data = $lb(ds.Data("OEordItemRowID"),ds.Data("OEordItemDesc"),ds.Data("LabEpisodeNo"),ds.Data("SpecimenDesc"),ds.Data("CollectionDate"),ds.Data("CollectionTime"),ds.Data("ReceiveDate"),ds.Data("ReceiveTime"),ds.Data("AuthorisationDate"),ds.Data("AuthorisationTime"),ds.Data("ExistReport"),episodeDate,deptDesc)
	              s ^CacheTemp(repid,ind) = data
	              s ind = ind + 1
		        } 
  	         }
	 	  }
	    }
	}
	Quit $$$OK
}

ClassMethod GetListDataListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListDataListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetListDataListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListDataListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else     
    {				
 		Set Row=^CacheTemp(repid,ind)   // fetch row
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
