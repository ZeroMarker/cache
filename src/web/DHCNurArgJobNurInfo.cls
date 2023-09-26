Class web.DHCNurArgJobNurInfo Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

Query FindNurInfoData(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindNurInfoDataExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCNurArgJobNurInfo","FindNurInfoData","115^2015-10-12^2015-10-18")
	s repid=$I(^CacheTemp)
	s ind=1
	s tmp=""
	i parr=""
	{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s WardId = $p(parr,"^",1)
	s StDate = $zdh($P(parr,"^",2),3)
	s EndDate = $zdh($P(parr,"^",3),3)
	s NurArray=""
	s OrdArray=""
	s max=0
	s ID="" f  s ID=$O(^DHCMGNUR.MgNurArgJobNurInfoI("Ward"," "_WardId,ID)) q:ID=""  d
	.s obj=##class(DHCMGNUR.MgNurArgJobNurInfo).%OpenId(ID)
	.s NurseID=obj.NurseID
	.s NurseType=obj.NurseType
	.q:(NurseType="N")&(..CheckNurDept(NurseID_"^"_parr)=0) 
	.q:(NurseType'="N")&(..CheckTmpNurDept(NurseID_"^"_parr)=0)
	.s NurseName=obj.NurseName
	.s NurseBty=obj.NurseBty
	.s NurseType=obj.NurseType
	.s NurseOrder=obj.NurseOrder
	.s max=..FindMax(max,NurseOrder)
	.s OrdArray(NurseOrder)="PersonID|"_NurseID_"^PersonName|"_NurseName_"^PersonType|"_NurseType_"^PersonBty|"_NurseBty_"^PersonOrder|"_NurseOrder
	.s NurArray(NurseID,NurseType)=OrdArray(NurseOrder)
	s nOrder=max+1
	d ..getDeptNurse(parr,.tmp)
	s Id="" f  s Id=$O(tmp(Id)) q:Id=""  d
	.s nurarr=""
	.k nurarr
	.d ##class(web.DHCNurRosterComm).setTmp(tmp(Id),.nurarr)
	.q:$g(NurArray(nurarr("PersonID"),nurarr("PersonType")))'=""
	.;q:$d(NurArray(Id))'=0
	.s OrdArray(nOrder)=tmp(Id)_nOrder
	.s nOrder=nOrder+1
	s AdmOrder="" f  s AdmOrder=$O(OrdArray(AdmOrder)) q:AdmOrder=""  d
	.s ret = OrdArray(AdmOrder)
	.d OutputNIRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputNIRow      
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindMax(str1, str2)
{
	i str1>str2 s max=str1
	e  s max=str2
	q max
}

ClassMethod FindNurInfoDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNurInfoDataExecute ]
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

ClassMethod FindNurInfoDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNurInfoDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// d ##class(web.DHCNurArgJobNurInfo).getDeptNurse("351^2014-12-22^2014-12-28",.tmp)
ClassMethod getDeptNurseOld(parr As %String, tmp As %String) As %String
{
	s WardId=$P(parr,"^",1) q:WardId=""
	s StDate=$zdh($P(parr,"^",2),3)
	s EndDate=$zdh($P(parr,"^",3),3)
	s tmp=""
	s ID="" f  s ID=$O(^DHCMGNUR.MgPersonsI("TempDep"," "_WardId,ID)) q:ID=""  d
	.s PerObj = ##class(DHCMGNUR.MgPersons).%OpenId(ID)
	.s PersonID=PerObj.PersonID
	.s PersonName=PerObj.PersonName
	.s PersonBty=PerObj.PersonBattery
	.i PersonBty'="" s PersonBtyCode=PersonBty.Code
	.else  s PersonBtyCode=""
	.s flag=..CheckNurDept(PersonID_"^"_parr)
	.q:flag=0
	.s tmp(ID)="PersonID|"_PersonID_"^PersonName|"_PersonName_"^PersonType|MP"_"^PersonBty|"_PersonBtyCode_"^PersonOrder|"
	s ID="" f  s ID=$O(^DHCMGNUR.MgPersonsI("Dep"," "_WardId,ID)) q:ID=""  do
	.s PerObj = ##class(DHCMGNUR.MgPersons).%OpenId(ID)
	.s PerTmpCTLoc = PerObj.PersonTempDepDR
	.q:PerTmpCTLoc'=""
	.s PersonID=PerObj.PersonID
	.s PersonName=PerObj.PersonName
	.s PersonBty=PerObj.PersonBattery
	.i PersonBty'="" s PersonBtyCode=PersonBty.Code
	.else  s PersonBtyCode=""
	.i $d(tmp(ID))=0 s tmp(ID)="PersonID|"_PersonID_"^PersonName|"_PersonName_"^PersonType|MP"_"^PersonBty|"_PersonBtyCode_"^PersonOrder|"
	s TransId="" f  s TransId=$O(^DHCMGNUR.MgNurTransDepI("Dep"," "_WardId,TransId)) q:TransId=""  d
	.s TransObj=##class(DHCMGNUR.MgNurTransDep).%OpenId(TransId)
	.s TransPerID=TransObj.PerID
	.s MgPerID=$O(^DHCMGNUR.MgPersonsI("SSID"," "_$ZCvt(TransPerID,"U"),""))
	.s MgPerObj=##class(DHCMGNUR.MgPersons).%OpenId(MgPerID)
	.s PersonName=MgPerObj.PersonName
	.s PersonBty=MgPerObj.PersonBattery
	.i PersonBty'="" s PersonBtyCode=PersonBty.Code
	.else  s PersonBtyCode=""
	.s TransCurrent=TransObj.PerTranCurrent
	.s TransStDate=TransObj.PerTranStDate
	.s TransEndDate=TransObj.PerTranEndDate
	.q:((TransEndDate'="")&&(TransEndDate<StDate))||(TransStDate>EndDate)
	.i $d(tmp(MgPerID))=0 s tmp(MgPerID)="PersonID|"_TransPerID_"^PersonName|"_PersonName_"^PersonType|MP"_"^PersonBty|"_PersonBtyCode_"^PersonOrder|"
	s wpsID="" f  s wpsID=$O(^DHCMGNUR.MgPSPersonsI("Ward"," "_WardId,wpsID)) q:wpsID=""  d
	.s wpsp=##class(DHCMGNUR.MgPSPersons).%OpenId(wpsID)
	.s PersonStDate=wpsp.PersonStDate
	.s PersonEndDate=wpsp.PersonEndDate
	.s PersonType=wpsp.PersonType
	.q:PersonType'="W"
	.q:wpsp.PersonStatus="N"
	.q:((PersonEndDate'="")&&(PersonEndDate<StDate))||(PersonStDate>EndDate)
	.s PersonName=wpsp.PersonName
	.s PersonBtyCode=wpsp.PersonType2
	.s tmp(PersonType_wpsID)="PersonID|"_wpsID_"^PersonName|"_PersonName_"^PersonType|MGR"_"^PersonBty|"_PersonBtyCode_"^PersonOrder|"
	q 0
}

ClassMethod CheckNurDeptOld(parr As %String) As %String
{
	;w ##class(web.DHCNurArgJobNurInfo).CheckNurDept("9151^1018^2014-04-21^2014-04-27")
	s NurseId=$P(parr,"^",1) q:(NurseId="")
	s WardId=$P(parr,"^",2)
	s StDate=$zdh($P(parr,"^",3),3)
	s EndDate=$zdh($P(parr,"^",4),3)
	s flag=1
	f AdmDate=StDate:1:EndDate d
	.s TransId="" f  s TransId=$O(^DHCMGNUR.MgNurTransDepI("PerID"," "_NurseId,TransId)) q:TransId=""  d
	..s TransObj=##class(DHCMGNUR.MgNurTransDep).%OpenId(TransId)
	..s TransCurrent=TransObj.PerTranCurrent
	..s TransStDate=TransObj.PerTranStDate
	..s TransEndDate=TransObj.PerTranEndDate
	..s TransWardId=TransObj.PerDepart
	..q:((TransEndDate'="")&&(TransEndDate<AdmDate))||(TransStDate>AdmDate)
	..q:TransWardId=WardId
	..s flag=0
	q flag
}

ClassMethod getDeptNurse(parr As %String, tmp As %String) As %String
{
	;d ##class(web.DHCNurArgJobNurInfo).getDeptNurse("82^2015-10-12^2015-10-18",.tmp)
	s WardId=$P(parr,"^",1) q:WardId=""
	s StDate=$zdh($P(parr,"^",2),3)
	s EndDate=$zdh($P(parr,"^",3),3)
	;b ;00
	s tmp=""
	s ID="" f  s ID=$O(^DHCMGNUR.MgPersonsI("Dep"," "_WardId,ID)) q:ID=""  do
	.s PerObj = ##class(DHCMGNUR.MgPersons).%OpenId(ID)
	.s PersonID=$ZConvert(PerObj.PersonID,"U")
	.;b ;01
	.s:PerObj.PersonType2="N" flag=..CheckNurDept(PersonID_"^"_parr)
	.s:PerObj.PersonType2'="N" flag=..CheckTmpNurDept(PersonID_"^"_parr)
	.i PersonID="HLY20150087" b ;00
	.q:flag=0
	.s PersonName=PerObj.PersonName
	.s PersonBty=PerObj.PersonBattery
	.i PersonBty'="" s PersonBtyCode=PersonBty.Code
	.else  s PersonBtyCode=""
	.s PersonType2=PerObj.PersonType2
	.i $d(tmp(PersonID))=0 s tmp(PersonID)="PersonID|"_PersonID_"^PersonName|"_PersonName_"^PersonType|"_PersonType2_"^PersonBty|"_PersonBtyCode_"^PersonOrder|"
	;b ;00
	s tmpid="" f  s tmpid=$O(^DHCMGNUR.MgPersonsD(tmpid)) q:tmpid=""  d
	.s tmpperobj= ##class(DHCMGNUR.MgPersons).%OpenId(tmpid)
	.q:(tmpperobj.PersonRetireDate'="")&&(tmpperobj.PersonRetireDate<=StDate)
	.q:tmpperobj.PersonDepDR=WardId
	.q:tmpperobj.PersonTmpDep=""
	.q:tmpperobj.PersonTmpDep'=WardId
	.q:(tmpperobj.PersonTmpDate>EndDate)||(tmpperobj.PersonTmpDate<=+$h)
	.s tmpperid=tmpperobj.PersonID
	.s tmppername=tmpperobj.PersonName
	.s tmpperbty=tmpperobj.PersonBattery
	.i tmpperbty'="" s PersonBtyCode=tmpperbty.Code
	.else  s PersonBtyCode=""
	.s PersonType2=tmpperobj.PersonType2
	.i $d(tmp(tmpperid))=0 s tmp(tmpperid)="PersonID|"_tmpperid_"^PersonName|"_tmppername_"^PersonType|"_PersonType2_"^PersonBty|"_PersonBtyCode_"^PersonOrder|"
	s TransId="" f  s TransId=$O(^DHCMGNUR.MgNurTransDepI("Dep"," "_WardId,TransId)) q:TransId=""  d
	.s TransObj=##class(DHCMGNUR.MgNurTransDep).%OpenId(TransId)
	.s TransPerID=$ZConvert(TransObj.PerID,"U")
	.s trsflag=..CheckNurDept(TransPerID_"^"_parr)
	.q:trsflag=0
	.s MgPerID=$O(^DHCMGNUR.MgPersonsI("SSID"," "_$ZCvt(TransPerID,"U"),""))
	.q:MgPerID=""
	.s MgPerObj=##class(DHCMGNUR.MgPersons).%OpenId(MgPerID)
	.s PersonName=MgPerObj.PersonName
	.s PersonBty=MgPerObj.PersonBattery
	.i PersonBty'="" s PersonBtyCode=PersonBty.Code
	.else  s PersonBtyCode=""
	.s PersonType2=MgPerObj.PersonType2
	.s TransCurrent=TransObj.PerTranCurrent
	.s TransStDate=TransObj.PerTranStDate
	.s TransEndDate=TransObj.PerTranEndDate
	.q:((TransEndDate'="")&&(TransEndDate<=StDate))||(TransStDate>EndDate)
	.i $d(tmp(TransPerID))=0 s tmp(TransPerID)="PersonID|"_TransPerID_"^PersonName|"_PersonName_"^PersonType|"_PersonType2_"^PersonBty|"_PersonBtyCode_"^PersonOrder|"
	s tmptrsid="" f  s tmptrsid=$O(^DHCMGNUR.MgNurTmpTransDepI("Dep"," "_WardId,tmptrsid)) q:tmptrsid=""  d
	.s tmptrsobj=##class(DHCMGNUR.MgNurTmpTransDep).%OpenId(tmptrsid)
	.s tmptrsperid=tmptrsobj.PerID
	.s perid=$O(^DHCMGNUR.MgPersonsI("SSID"," "_$ZCvt(tmptrsperid,"U"),""))
	.q:perid=""
	.s PerObj=##class(DHCMGNUR.MgPersons).%OpenId(perid)
	.q:(PerObj.PersonType2'="P")&&(PerObj.PersonType2'="S")&&(PerObj.PersonInternEndDate'="")&&(PerObj.PersonInternEndDate<=StDate)
	.s PersonName=PerObj.PersonName
	.s PersonBty=PerObj.PersonBattery
	.i PersonBty'="" s PersonBtyCode=PersonBty.Code
	.else  s PersonBtyCode=""
	.s PersonType2=PerObj.PersonType2
	.s TransCurrent=tmptrsobj.PerTranCurrent
	.s TransStDate=tmptrsobj.PerTranStDate
	.s TransEndDate=tmptrsobj.PerTranEndDate
	.q:((TransEndDate'="")&&(TransEndDate<=StDate))||(TransStDate>EndDate)
	.i $d(tmp(tmptrsperid))=0 s tmp(tmptrsperid)="PersonID|"_tmptrsperid_"^PersonName|"_PersonName_"^PersonType|"_PersonType2_"^PersonBty|"_PersonBtyCode_"^PersonOrder|"
	
	q 0
}

ClassMethod CheckNurDept(parr As %String) As %String
{
	;w ##class(web.DHCNurArgJobNurInfo).CheckNurDept("11660^115^2015-10-12^2015-10-18")
	s perid=$P(parr,"^",1) q:(perid="")
	s wardid=$P(parr,"^",2)
	s stdate=$zdh($P(parr,"^",3),3)
	s enddate=$zdh($P(parr,"^",4),3)
	s tflag=0,flag=0
	s perdr=$O(^DHCMGNUR.MgPersonsI("SSID"," "_$zcvt(perid,"U"),""))
	i perdr'="" d
	.s perobj=##class(DHCMGNUR.MgPersons).%OpenId(perdr)
	.q:(perobj.PersonRetireDate'="")&&(perobj.PersonRetireDate<=stdate)
	.s tempdate=perobj.PersonTmpDate
	.s tempdep=perobj.PersonTmpDep
	.q:(tempdep="")!((tempdate'="")&&((tempdate>enddate)||(tempdate<=+$h)))
	.s tflag=1
	.i tempdep=wardid s flag=1
	q:tflag=1 flag
	s trsid="" f  s trsid=$O(^DHCMGNUR.MgNurTransDepI("PerID"," "_$zcvt(perid,"U"),trsid)) q:(trsid="")!(flag=1)  d
	.s trsobj=##class(DHCMGNUR.MgNurTransDep).%OpenId(trsid)
	.s trsstdate=trsobj.PerTranStDate
	.s trsenddate=trsobj.PerTranEndDate
	.s trswardid=trsobj.PerDepart
	.q:((trsenddate'="")&&(trsenddate<=stdate))||(trsstdate>enddate)||(trswardid'=wardid)
	.s flag=1
	q flag
}

ClassMethod CheckTmpNurDept(parr As %String) As %String
{
	;w ##class(web.DHCNurArgJobNurInfo).CheckTmpNurDept("11660^115^2015-10-12^2015-10-18")
	s perid=$P(parr,"^",1) q:(perid="")
	s wardid=$P(parr,"^",2)
	s stdate=$zdh($P(parr,"^",3),3)
	s enddate=$zdh($P(parr,"^",4),3)
	s perdr=$O(^DHCMGNUR.MgPersonsI("SSID"," "_$zcvt(perid,"U"),""))
	q:perdr="" 0
	s perobj=##class(DHCMGNUR.MgPersons).%OpenId(perdr)
	q:(perobj.PersonType2'="P")&&(perobj.PersonType2'="S")&&(perobj.PersonInternEndDate'="")&&(perobj.PersonInternEndDate<=stdate) 0
	s flag=0,tflag=0,ttflag=0
	s trsid="" f  s trsid=$O(^DHCMGNUR.MgNurTmpTransDepI("PerID"," "_$zcvt(perid,"U"),trsid)) q:(trsid="")!(tflag=1)  d
	.s ttflag=1
	.s trsobj=##class(DHCMGNUR.MgNurTmpTransDep).%OpenId(trsid)
	.s trsstdate=trsobj.PerTranStDate
	.s trsenddate=trsobj.PerTranEndDate
	.s trswardid=trsobj.PerDepart
	.q:((trsenddate'="")&&(trsenddate<=stdate))||(trsstdate>enddate)||(trswardid'=wardid)
	.s tflag=1
	i (ttflag=0)!(tflag=1) s flag=1
	q flag
}

/// d ##class(web.DHCNurArgJobNurInfo).getNowDeptNurse("351^2014-12-22^2014-12-28",.temp)
ClassMethod getNowDeptNurse(parr, OrdArray)
{
	q:parr=""
	s WardId = $p(parr,"^",1)
	s StDate = $zdh($P(parr,"^",2),3)
	s EndDate = $zdh($P(parr,"^",3),3)
	s NurArray=""
	s OrdArray=""
	s max=0
	s ID="" f  s ID=$O(^DHCMGNUR.MgNurArgJobNurInfoI("Ward"," "_WardId,ID)) q:ID=""  d
	.s obj=##class(DHCMGNUR.MgNurArgJobNurInfo).%OpenId(ID)
	.s NurseID=obj.NurseID
	.s flag=..CheckNurDept(NurseID_"^"_parr)
	.q:flag=0
	.s NurseName=obj.NurseName
	.s NurseBty=obj.NurseBty
	.s NurseOrder=obj.NurseOrder
	.i obj.NurseType'="MP" d
	..s wpsobj=##class(DHCMGNUR.MgPSPersons).%OpenId(NurseID)
	..q:wpsobj.PersonStatus="N"
	.s max=..FindMax(max,NurseOrder)
	.s OrdArray(NurseOrder)="PersonID|"_NurseID_"^PersonName|"_NurseName_"^PersonBty|"_NurseBty_"^PersonOrder|"_NurseOrder
	.i obj.NurseType="MP" d
	..s PerDr=$O(^DHCMGNUR.MgPersonsI("SSID"," "_NurseID,""))
	..s NurArray(PerDr)=OrdArray(NurseOrder)
	.e  d
	..s wpsobj=##class(DHCMGNUR.MgPSPersons).%OpenId(NurseID)
	..s NurArray(wpsobj.PersonType_NurseID)=OrdArray(NurseOrder)
	s nOrder=max+1
	b ;00
	d ..getDeptNurse(parr,.tmp)
	b ;01
	s Id="" f  s Id=$O(tmp(Id)) q:Id=""  d
	.;s tempnur="" k tempnur
	.;d ##class(web.DHCNurRosterComm).setTmp(tmp(Id),.tempnur)
	.q:$d(NurArray(Id))'=0
	.s OrdArray(nOrder)=tmp(Id)_nOrder
	.s nOrder=nOrder+1
	q 0
}

ClassMethod getNurseWard(parr As %String) As %String
{
	q:parr=""
	s StDate=$zdh($P(parr,"^",1),3)
	s EndDate=$zdh($P(parr,"^",2),3)
	s PersonID=$P(parr,"^",3)
	s ret=""
	f AdmDate=StDate:1:EndDate d
	.s TransId="" f  s TransId=$O(^DHCMGNUR.MgNurTransDepI("PerID"," "_NurseId,TransId)) q:TransId=""  d
	..s TransObj=##class(DHCMGNUR.MgNurTransDep).%OpenId(TransId)
	..;s TransCurrent=TransObj.PerTranCurrent
	..s TransStDate=TransObj.PerTranStDate
	..s TransEndDate=TransObj.PerTranEndDate
	..s TransWardId=TransObj.PerDepart
	..q:((TransEndDate'="")&&(TransEndDate<AdmDate))||(TransStDate>AdmDate)
	..i ret="" s ret=TransWardId
	..else  s ret=ret_"^"_TransWardId
	q ret
}

}
