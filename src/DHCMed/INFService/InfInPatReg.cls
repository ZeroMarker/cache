/// 名称: DHCMed.INFService.InfInPatReg
/// 描述: DHCMed.INFService.InfInPatReg 医院感染病例监测月报表
/// 编写者：LYH
/// 编写日期: 2011-05-31
Class DHCMed.INFService.InfInPatReg Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     LYH
/// CreatDate：   2011-05-31
/// Description:  查询医院感染病例信息
/// Input
/// d ##class(%ResultSet).RunQuery("DHCMed.INFService.InfInPatReg","QryMonthInfo","2011-06-03","2012-01-01","")
Query QryMonthInfo(SDate As %String, EDate As %String, Ctloc As %String) As %Query(ROWSPEC = "ind:%String,DepID:%String,PatName:%String,PatSex:%String,PatAge:%String,MrNo:%String,Diagnos:%String,AdmDate:%String,InfDate:%String,DisDate:%String,InfPosCode:%String,Sample:%String,PathDesc:%String,DeathDesc:%String")
{
}

ClassMethod QryMonthInfoExecute(ByRef qHandle As %Binary, SDate As %String, EDate As %String, Ctloc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	q:SDate="" $$$OK
	q:EDate="" $$$OK
	
	s:SDate["-" SDate=$zdh(SDate,3)
	s:SDate["/" SDate=$zdh(SDate,1)
	s:EDate["-" EDate=$zdh(EDate,3)
	s:EDate["/" EDate=$zdh(EDate,1)
	k ^CacheTemp("DHCMEDINF")
	
	s RepID=""
	f  s RepID=$o(^DHCMed.INF.ReportD(RepID)) q:RepID=""  d
	.s obj=##Class(DHCMed.INF.Report).GetObjById(RepID)
	.s StatusDr=obj.StatusDr
	.q:StatusDr=0 //删除状态
	.s Type=obj.Type
	.q:Type'=1	//院感报告
	.s PaadmDR=obj.PaadmDR
	.q:PaadmDR=""
	.s FirstDtlsID=$o(^DHCMed.INF.RepStatusDtlsI("InfRepDr",RepID,""))
	.s FirstDtlsObj=##class(DHCMed.INF.RepStatusDtls).GetObjById(FirstDtlsID)
	.s FirstDate=FirstDtlsObj.UpdateDate	//初次报告时间
	.q:(FirstDate>EDate)||(FirstDate<SDate)
	.s CtlocID=obj.CtLoc
	.q:(Ctloc'="")&(CtlocID'=Ctloc)
	.s ^CacheTemp("DHCMEDINF",$zn,$j,CtlocID,RepID)=""
	
	s LocID=""
	f  s LocID=$o(^CacheTemp("DHCMEDINF",$zn,$j,LocID)) q:LocID=""  d
	.s RepID=""
	.f  s RepID=$o(^CacheTemp("DHCMEDINF",$zn,$j,LocID,RepID)) q:RepID=""  d
	..s (DepID,PatName,PatSex,PatAge,DiagDesc,MrNo,Diagnos,AdmDate,InfDate,DisDate,InfPosCode,Sample,PathDesc,DeathDesc)=""
	..s obj=##Class(DHCMed.INF.Report).GetObjById(RepID)
	..s PaadmDR=obj.PaadmDR
	..s papmi=$p($g(^PAADM(PaadmDR)),"^",1)
	..q:papmi=""
	..s objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(PaadmDR)
    ..q:$IsObject(objAdm)=0
    ..s objPatient=##class(DHCMed.Base.Patient).GetObjById(objAdm.PatientID)
    ..q:$IsObject(objPatient)=0
	..s PatName=objPatient.PatientName
	..s PatSex=objPatient.Sex
	..s PatAge=objPatient.Age
	..s AdmDate=objAdm.AdmitDate  
	..s DepID=objAdm.Department
	..s:DepID["-" DepID=$p(DepID,"-",2)
	..s DisDate=objAdm.DisDate
	..s MrNo=$p($g(^PAPER(papmi,"PAT",1)),"^",22)
	..s DiagnosStr=##class(DHCMed.Base.MRDiagnose).GetByPaadm(PaadmDR)
	..s DiaLen=$l(DiagnosStr,$c(1))
	..s DiagInfo=$p(DiagnosStr,$c(1),DiaLen-1)
	..s Diagnos=$p(DiagInfo,"^",14)	//主要诊断
	..s SummaryID=$o(^DHCMed.INF.SummaryI("InfRepDr",RepID,""))
	..s PosID=$o(^DHCMed.INF.RepPosI("InfRepDr",SummaryID,""))
	..i PosID'="" d
	...s PosObj=##class(DHCMed.INF.RepPos).GetObjById(PosID)
	...s InfDate=PosObj.InfDate
	...s:InfDate'="" InfDate=$zd(InfDate,3)
	...s InfDiagDR=PosObj.InfDiagDR
	...i InfDiagDR'="" d
	....s DiagObj=##Class(DHCMed.INF.InfDiagnose).GetObjById(InfDiagDR)
	....q:'$IsObject(DiagObj)
	....s DiagDesc=DiagObj.DiseaseName
	...s InfPosCode=PosObj.InfPosCode
	...q:InfPosCode=""
	...s InfPosObj=##Class(DHCMed.INF.InfPosition).GetObjById(InfPosCode)
	...q:'$IsObject(InfPosObj)
	...s InfPosCode=InfPosObj.InfPosition
	
	..s PathogenyID=$o(^DHCMed.INF.PathogenyI("InfRepDr",RepID,""))
	..i PathogenyID'="" d
	...s PathObj=##Class(DHCMed.INF.Pathogeny).GetObjById(PathogenyID)
	...s Sample=PathObj.Sample	//标本code
	...q:Sample=""
	...s DicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(Sample,"InfectionLabSampleType")
	...q:DicID=""
	...s DicObj=##class(DHCMed.SS.Dictionary).GetObjById(DicID)
	...q:'$IsObject(DicObj)
	...s Sample=DicObj.Description
	...s PyObjID=$o(^DHCMed.INF.PyObjI("InfPathDr",PathogenyID,""))
	...q:PyObjID=""
	...s PyObjObj=##Class(DHCMed.INF.PyObj).GetObjById(PyObjID)
	...q:'$IsObject(PyObjObj)
	...s objDR=PyObjObj.Object
	...q:objDR=""
	...s PathDicObj=##Class(DHCMed.INF.InfPathogenDic).GetObjById(objDR)
	...s PathDesc=PathDicObj.Description //检验结果
	
	..i SummaryID'="" d
	...s SumObj=##Class(DHCMed.INF.Summary).GetObjById(SummaryID)
	...s DeathConDR=SumObj.DeathConnection
	...q:DeathConDR=""
	...s DicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(DeathConDR,"InfDieRelation")
	...s DicObj=##class(DHCMed.SS.Dictionary).GetObjById(DicID)
	...s DeathDesc=DicObj.Description	//死亡关系
	
	
	..s:PathDesc="" PathDesc=DiagDesc
    ..s Data=$lb(ind,DepID,PatName,PatSex,PatAge,MrNo,Diagnos,AdmDate,InfDate,DisDate,InfPosCode,Sample,PathDesc,DeathDesc)
 	..s ^CacheTemp(repid,ind)=Data
 	..s ind=ind+1
    
	Quit $$$OK
}

ClassMethod QryMonthInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMonthInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryMonthInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMonthInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

/// w ##Class(DHCMed.INFService.InfInPatReg).GetMonthInfo("fillxlSheet","2011-06-01^2012-01-01^")
ClassMethod GetMonthInfo(itmjs As %String, strArguments As %String) As %String
{
	n (itmjs,strArguments)
	s Count=0
	s SDate=$p(strArguments,"^",1)
	s EDate=$p(strArguments,"^",2)
	s Ctloc=$p(strArguments,"^",3)

	s ds = ##class(%Library.ResultSet).%New("DHCMed.INFService.InfInPatReg:QryMonthInfo")
	d ds.Execute(SDate,EDate,Ctloc)
	s StartRow=3
	while(ds.Next())
	{
		s ind=ds.Data("ind")
		s DepID=ds.Data("DepID")
		s PatName=ds.Data("PatName")
		s PatSex=ds.Data("PatSex")
		s PatAge=ds.Data("PatAge")
		s MrNo=ds.Data("MrNo")
		s Diagnos=ds.Data("Diagnos")
		s AdmDate=ds.Data("AdmDate")
		s InfDate=ds.Data("InfDate")
		s DisDate=ds.Data("DisDate")
		s InfPosCode=ds.Data("InfPosCode")
		s Sample=ds.Data("Sample")
		s PathDesc=ds.Data("PathDesc")
		s DeathDesc=ds.Data("DeathDesc")
		s valCells=ind_$c(1)_DepID_$c(1)_PatName_$c(1)_PatSex_$c(1)_PatAge_$c(1)_MrNo_$c(1)_Diagnos_$c(1)_AdmDate_$c(1)_InfDate_$c(1)_DisDate_$c(1)_InfPosCode_$c(1)_Sample_$c(1)_PathDesc_$c(1)_DeathDesc
	 	s retval=itmjs_"(xlSheet,'"_$ZCVT(valCells,"O","JS")_"',"_StartRow_",1);"
		&javascript<#(retval)#>
		
		s Count=Count+1
		s StartRow=StartRow+1
	}
	d ds.Close()
	
	q Count
}

}
