Class EMRservice.HISInterface.Resource.Consult Extends (%RegisteredObject, %XML.Adaptor)
{

/// 入参 EpisodeID(paadm_rowid)  AInterFace 调用接口标识
/// 返回值 登记号 病案号 姓名 性别 年龄 科别 病区 床号 诊断 会诊目的 会诊类别 会诊申请科室 申请医生 会诊科室 会诊医生 会诊意见 会诊日期 会诊时间 申请医生职称 会诊医生职称 会诊摘要
/// d ##class(%ResultSet).RunQuery("EMRservice.HISInterface.Resource.Consult","ConsultInfo","68279")
Query ConsultInfo(EpisodeID As %String, InterFace As %String) As %Query(ROWSPEC = "PatRegNo,PatId,PatName,SEX,AGE,PatDep,PatWard,BedCode,Diag,ConDestination,ConType,PatDep2,PatDoc,ConsultDep,ConsultDoc,Attitude,ConsultDate,ConsultTime,PatDocCarprv,condocCarprv,ConSummary")
{
}

ClassMethod ConsultInfoExecute(ByRef qHandle As %Binary, EpisodeID As %String, InterFace As %String) As %Status
{
	
	s repid=$i(^CacheTemp)
	s EpisodeID=$g(EpisodeID)
	i EpisodeID="" s ind=1 s qHandle=$lb(0,repid,0) Quit $$$OK
	s ind=1
 	
	if (InterFace = "HIS")
	{
		s ds = ##Class(%Library.ResultSet).%New("web.DHCNurComFX:ConsultInfo")
		d ds.Execute(EpisodeID)
	
		While (ds.Next())
		{
			s PatRegNo = ds.Data("PatRegNo")
			s PatId = ds.Data("PatId")
			s PatName = ds.Data("PatName") 
			s SEX = ds.Data("SEX") 
			s AGE = ds.Data("AGE")
			s PatDep = ds.Data("PatDep")
			s PatWard = ds.Data("PatWard")
			s BedCode = ds.Data("BedCode")
			s Diag = ds.Data("Diag")
			s ConDestination = ds.Data("ConDestination")
			s ConType = ds.Data("ConType") 
			s PatDep2 = ds.Data("PatDep2") 
			s PatDoc = ds.Data("PatDoc")
			s ConsultDep = ds.Data("ConsultDep")
			s ConsultDoc = ds.Data("ConsultDoc")
			s Attitude = ds.Data("Attitude")
			s ConsultDate = ds.Data("ConsultDate")
			s ConsultTime = ds.Data("ConsultTime")
			s PatDocCarprv = $g(ds.Data("PatDocCarprv"))
			s condocCarprv = $g(ds.Data("condocCarprv"))
			d Consult
		}
	}
	elseif(InterFace = "会诊")
	{
		s ds = ##Class(%Library.ResultSet).%New("web.DHCEMConsInterface:QryPatConsList")
		d ds.Execute(EpisodeID)
	
		While (ds.Next())
		{
			s PatRegNo = ds.Data("PatNo")
			s PatId = ds.Data("MedicareNo")
			s PatName = ds.Data("PatName") 
			s SEX = ds.Data("PatSex") 
			s AGE = $g(ds.Data("AGE"))
			s PatDep = ds.Data("PatLoc")
			s PatWard = ds.Data("PatWard")
			s BedCode = ds.Data("PatBed")
			s Diag = ds.Data("PatDiagDesc")
			s ConDestination = ds.Data("CstPurpose")
			s ConType = ds.Data("CstCstType") 
			s PatDep2 = ds.Data("CstRLoc") 
			s PatDoc = ds.Data("CstRUser")
			s ConsultDep = ds.Data("CsLocDesc")
			s ConsultDoc = ds.Data("CsUser")
			s Attitude = ds.Data("Opinion")
			s ConsultDate= ds.Data("CstNDate")
			s ConsultTime= ds.Data("CstNTime")
			s PatDocCarprv = $g(ds.Data("PatDocCarprv"))
			s condocCarprv = $g(ds.Data("PrvTp"),"") //会诊医生职称
			s ConSummary = $g(ds.Data("CstTrePro"),"") //会诊摘要
			d Consult
		}
		
		
		///MDT,会诊信息 
		s dsMDT =##Class(%Library.ResultSet).%New("web.DHCMDTInterface:QryPatMDTConsList")
		d dsMDT.Execute(EpisodeID)
		
		While (dsMDT.Next())
		{
			s PatRegNo = $g(dsMDT.Data("PatNo"))
			s PatId = $g(dsMDT.Data("MedicareNo"))
			s PatName = $g(dsMDT.Data("PatName") )
			s SEX = $g(dsMDT.Data("PatSex") )
			s AGE = $g(dsMDT.Data("AGE"))
			s PatDep = $g(dsMDT.Data("PatLoc"))
			s PatWard = $g(dsMDT.Data("PatWard"))
			s BedCode = $g(dsMDT.Data("PatBed"))
			s Diag = $g(dsMDT.Data("PatDiagDesc"))
			s ConDestination = $g(dsMDT.Data("CstPurpose"))
			s ConType = "MDT"
			s PatDep2 = $g(dsMDT.Data("CstRLoc") )
			s PatDoc = $g(dsMDT.Data("CstRUser"))
			s ConsultDep = $g(dsMDT.Data("CsLocDesc"))
			s ConsultDoc = $g(dsMDT.Data("CsUser"))
			s Attitude = $g(dsMDT.Data("TreMeasures"))
			s ConsultDate= $g(dsMDT.Data("CstNDate"))
			s ConsultTime= $g(dsMDT.Data("CstNTime"))
			s PatDocCarprv = $g(dsMDT.Data("PatDocCarprv"))
			s condocCarprv = $g(dsMDT.Data("PrvTp"),"") //会诊医生职称
			s ConSummary = $g(dsMDT.Data("CstTrePro"),"") //会诊摘要
			d Consult
		}
		
	}
	else
	{
		s ds = ##Class(%Library.ResultSet).%New("EMRservice.Ajax.consult:ConsultInfo")
		d ds.Execute(EpisodeID)
	
		While (ds.Next())
		{
			s PatRegNo = ds.Data("PatRegNo")
			s PatId = ds.Data("PatId")
			s PatName = ds.Data("PatName") 
			s SEX = ds.Data("SEX") 
			s AGE = ds.Data("AGE")
			s PatDep = ds.Data("PatDep")
			s PatWard = ds.Data("PatWard")
			s BedCode = ds.Data("BedCode")
			s Diag = ds.Data("Diag")
			s ConDestination = ds.Data("ConDestination")
			s ConType = ds.Data("ConType") 
			s PatDep2 = ds.Data("PatDep2") 
			s PatDoc = ds.Data("PatDoc")
			s ConsultDep = ds.Data("ConsultDep")
			s ConsultDoc = ds.Data("ConsultDoc")
			s Attitude = ds.Data("Attitude")
			s ConsultDate = ds.Data("ConsultDate")
			s ConsultTime = ds.Data("ConsultTime")
			s PatDocCarprv = $g(ds.Data("PatDocCarprv"))
			s condocCarprv = $g(ds.Data("condocCarprv"))
			d Consult
		}
	}
 	
 	
	s qHandle=$lb(0,repid,0)
	q $$$OK

Consult
	s Data=$lb(PatRegNo,PatId,PatName,SEX,AGE,PatDep,PatWard,BedCode,Diag,ConDestination,ConType,PatDep2,PatDoc,ConsultDep,ConsultDoc,Attitude,ConsultDate,ConsultTime,PatDocCarprv,condocCarprv,$g(ConSummary,""))
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod ConsultInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ConsultInfoExecute ]
{
	s AtEnd=$li(qHandle,1)
	s repid=$li(qHandle,2)
	s ind=$li(qHandle,3)
	s ind=$o(^CacheTemp(repid,ind))
	i ind="" {				// if there are no more rows, finish fetching
		s AtEnd=1
		s Row=""
	}
	else {			
		s Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod ConsultInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ConsultInfoExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

}
