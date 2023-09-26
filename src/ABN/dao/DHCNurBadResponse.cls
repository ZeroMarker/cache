Class ABN.dao.DHCNurBadResponse Extends %RegisteredObject
{

ClassMethod BreathListLookupExecute(ByRef qHandle As %Binary) As %Status
{
   ;w ##class(%ResultSet).RunQuery("ABN.dao.DHCNurBadResponse","BreathListLookup","")
  S repid=$I(^CacheTemp)
  s ind=1,grpIn=""
  s GrpRowId=0,num=0
 
  s TList="胸闷"
  do OutPutL1
  s TList="喘息"
  do OutPutL1
  s TList="咳嗽"
  do OutPutL1
  s TList="气短"
  do OutPutL1
  s TList="喉鸣"
  do OutPutL1
   	  
  S qHandle=$lb(0,repid,0)
  Q $$$OK
OutPutL1
    s Data=$lb(TList)
 	S ^CacheTemp(repid,ind)=Data
 	S ind=ind+1
	q
}

ClassMethod BreathListLookupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = BreathListLookupExecute ]
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
	Quit $$$OK
}

ClassMethod BreathListLookupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = BreathListLookupExecute ]
{
   //住院收费员查询
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query BreathListLookup() As %Query(ROWSPEC = "TList:%String")
{
}

ClassMethod SkinListLookupExecute(ByRef qHandle As %Binary) As %Status
{
   ;w ##class(%ResultSet).RunQuery("ABN.dao.DHCNurBadResponse","BreathListLookup","")
  S repid=$I(^CacheTemp)
  s ind=1,grpIn=""
  s GrpRowId=0,num=0
 
  s TList="手心足底或头皮瘙痒"
  do OutPutL2
  s TList="风团"
  do OutPutL2
  s TList="血管性水肿"
  do OutPutL2
  s TList="全身瘙痒"
  do OutPutL2
  s TList="潮红"
  do OutPutL2
   	  
  S qHandle=$lb(0,repid,0)
  Q $$$OK
OutPutL2
    s Data=$lb(TList)
 	S ^CacheTemp(repid,ind)=Data
 	S ind=ind+1
	q
}

ClassMethod SkinListLookupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SkinListLookupExecute ]
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
	Quit $$$OK
}

ClassMethod SkinListLookupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SkinListLookupExecute ]
{
   //住院收费员查询
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query SkinListLookup() As %Query(ROWSPEC = "TList:%String")
{
}

ClassMethod NoseEyeListLookupExecute(ByRef qHandle As %Binary) As %Status
{
   ;w ##class(%ResultSet).RunQuery("ABN.dao.DHCNurBadResponse","BreathListLookup","")
  S repid=$I(^CacheTemp)
  s ind=1,grpIn=""
  s GrpRowId=0,num=0
 
  s TList="鼻/眼痒"
  do OutPutL3
  s TList="喷嚏"
  do OutPutL3
  s TList="流涕"
  do OutPutL3
  s TList="鼻塞"
  do OutPutL3
  s TList="结膜充血水肿"
  do OutPutL3
   	  
  S qHandle=$lb(0,repid,0)
  Q $$$OK
OutPutL3
    s Data=$lb(TList)
 	S ^CacheTemp(repid,ind)=Data
 	S ind=ind+1
	q
}

ClassMethod NoseEyeListLookupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = NoseEyeListLookupExecute ]
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
	Quit $$$OK
}

ClassMethod NoseEyeListLookupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = NoseEyeListLookupExecute ]
{
   //住院收费员查询
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query NoseEyeListLookup() As %Query(ROWSPEC = "TList:%String")
{
}

ClassMethod CardiovascularLookupExecute(ByRef qHandle As %Binary) As %Status
{
   ;w ##class(%ResultSet).RunQuery("ABN.dao.DHCNurBadResponse","BreathListLookup","")
  S repid=$I(^CacheTemp)
  s ind=1,grpIn=""
  s GrpRowId=0,num=0
 
  s TList="低血压"
  do OutPutL4
  s TList="心前区不适"
  do OutPutL4
  s TList="头晕"
  do OutPutL4
  s TList="头痛"
  do OutPutL4
  s TList="乏力,视物模糊"
  do OutPutL4
   	  
  S qHandle=$lb(0,repid,0)
  Q $$$OK
OutPutL4
    s Data=$lb(TList)
 	S ^CacheTemp(repid,ind)=Data
 	S ind=ind+1
	q
}

ClassMethod CardiovascularLookupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CardiovascularLookupExecute ]
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
	Quit $$$OK
}

ClassMethod CardiovascularLookupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CardiovascularLookupExecute ]
{
   //住院收费员查询
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query CardiovascularLookup() As %Query(ROWSPEC = "TList:%String")
{
}

ClassMethod OtherListLookupExecute(ByRef qHandle As %Binary) As %Status
{
   ;w ##class(%ResultSet).RunQuery("ABN.dao.DHCNurBadResponse","BreathListLookup","")
  S repid=$I(^CacheTemp)
  s ind=1,grpIn=""
  s GrpRowId=0,num=0
 
  s TList="吞咽困难"
  do OutPutL5
  s TList="恶心腹痛"
  do OutPutL5
  s TList="出汗"
  do OutPutL5
   	  
  S qHandle=$lb(0,repid,0)
  Q $$$OK
OutPutL5
    s Data=$lb(TList)
 	S ^CacheTemp(repid,ind)=Data
 	S ind=ind+1
	q
}

ClassMethod OtherListLookupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = OtherListLookupExecute ]
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
	Quit $$$OK
}

ClassMethod OtherListLookupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = OtherListLookupExecute ]
{
   //住院收费员查询
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query OtherListLookup() As %Query(ROWSPEC = "TList:%String")
{
}

ClassMethod MeasureLLookupExecute(ByRef qHandle As %Binary) As %Status
{
   ;w ##class(%ResultSet).RunQuery("ABN.dao.DHCNurBadResponse","BreathListLookup","")
  S repid=$I(^CacheTemp)
  s ind=1,grpIn=""
  s GrpRowId=0,num=0
 
  s TList="评估气道,呼吸,循环以及意识状态"
  do OutPutL6
  s TList="口服或肌肉注射抗组胺药"
  do OutPutL6
  s TList="肾上腺素局部封闭"
  do OutPutL6
  s TList="肌注肾上腺素"
  do OutPutL6

   	  
  S qHandle=$lb(0,repid,0)
  Q $$$OK
OutPutL6
    s Data=$lb(TList)
 	S ^CacheTemp(repid,ind)=Data
 	S ind=ind+1
	q
}

ClassMethod MeasureLLookupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MeasureLLookupExecute ]
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
	Quit $$$OK
}

ClassMethod MeasureLLookupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MeasureLLookupExecute ]
{
   //住院收费员查询
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query MeasureLLookup() As %Query(ROWSPEC = "TList:%String")
{
}

ClassMethod ClinicalImpressionLookupExecute(ByRef qHandle As %Binary) As %Status
{
   ;w ##class(%ResultSet).RunQuery("ABN.dao.DHCNurBadResponse","BreathListLookup","")
  S repid=$I(^CacheTemp)
  s ind=1,grpIn=""
  s GrpRowId=0,num=0
 
  s TList="明确SR(全身反应)"
  do OutPutL7
  s TList="可疑SR"
  do OutPutL7
  s TList="无SR"
  do OutPutL7
 
   	  
  S qHandle=$lb(0,repid,0)
  Q $$$OK
OutPutL7
    s Data=$lb(TList)
 	S ^CacheTemp(repid,ind)=Data
 	S ind=ind+1
	q
}

ClassMethod ClinicalImpressionLookupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ClinicalImpressionLookupExecute ]
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
	Quit $$$OK
}

ClassMethod ClinicalImpressionLookupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ClinicalImpressionLookupExecute ]
{
   //住院收费员查询
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query ClinicalImpressionLookup() As %Query(ROWSPEC = "TList:%String")
{
}

ClassMethod SaveIn(Usr, Info, ID, SubID)
{
	s ^TMP("savein")=Usr_"$$"_Info_"$$"_ID_"$$"_SubID
	   //var saveinfo=BreathL+"^"+SkinL+"^"+NoseEyeL+"^"+CardiovascularL+"^"+OtherL+"^"+MeasureL
	//saveinfo=saveinfo+"^"+InjectD+"^"+InjectT+"^"+ReactD+"^"+ReactT+"^"+LeaveD+"^"+LeaveT
	//saveinfo=saveinfo+"^"+LStatus+"^"+Guide+"^"+Localreact+"^"+deepness+"^"+AdjustDose
	//saveinfo=saveinfo+"^"+firstinject+"^"+ClinImpression
	q:(ID="") -1
	s child=$p(ID,"||",2)
	s BreathL=$p(Info,"^",1)
	s SkinL=$p(Info,"^",2)
	s NoseEyeL=$p(Info,"^",3)
	s CardiovascularL=$p(Info,"^",4)
	s OtherL=$p(Info,"^",5)
	s MeasureL=$p(Info,"^",6)
	s InjectD=$p(Info,"^",7)
	s:InjectD["/" InjectD=$zdh(InjectD,4)
	s InjectT=$p(Info,"^",8)
	s:InjectT'="" InjectT=$zth(InjectT)
	s ReactD=$p(Info,"^",9)
	s:ReactD["/" ReactD=$zdh(ReactD,4)
	s ReactT=$p(Info,"^",10)
	s:ReactT'="" ReactT=$zth(ReactT)
	s LeaveD=$p(Info,"^",11)
	s:LeaveD["/" LeaveD=$zdh(LeaveD,4)
	s LeaveT=$p(Info,"^",12)
	s:LeaveT'="" LeaveT=$zth(LeaveT)
	s LStatus=$p(Info,"^",13)
	s Guide=$p(Info,"^",14)
	s Localreact=$p(Info,"^",15)
	s MissionWind=""
	s Blushes=""
	i Localreact["LR"   d
	.s Lreact=$p(Localreact,"LR",2)
	.s Lreact=$tr(Lreact," ","")
	.s MissionWind=+$p(Lreact,"/",1)
	.s Blushes=+$p(Lreact,"/",2)
	i Localreact["RL"   d
	.s Lreact=$p(Localreact,"LR",2)
	.s Lreact=$tr(Lreact," ","")
	.s MissionWind=+$p(Lreact,"/",2)
	.s Blushes=+$p(Lreact,"/",1)
	s deepness=$p(Info,"^",16)
	s AdjustDose=$p(Info,"^",17)
	s firstinject=$p(Info,"^",18)
	s ClinImpression=$p(Info,"^",19)
	if SubID="" s SubID=$o(^ABN.DHCNurCureRecD(+ID,"ChildSub",child,"BadSub",""),-1)
	if (+SubID>0)  s a=##class(ABN.DHCNurBadResponse).%OpenId(+ID_"||"_child_"||"_SubID)
	e    d
	.s a=##class(ABN.DHCNurBadResponse).%New(+ID_"||"_child)
	.d a.CureRecsubParefSetObjectId(+ID_"||"_child)
    
    s a.InjectionDate=InjectD
    s a.InjectionTime=InjectT
    s a.ResponseDate=ReactD
    s a.RecponseTime=ReactT
    s a.LiquidDensity=deepness
    s a.FirstInjection=firstinject
    s a.MissionWind= Localreact ;MissionWind
    s a.Blushes=Blushes
    s a.Breath=BreathL
    s a.Skin=SkinL
    s a.NoseEye=NoseEyeL
    s a.CardiovascularSystem=CardiovascularL
    s a.Other=OtherL
    s a.Measure=MeasureL
    s a.leaveDate=LeaveD
    s a.LeaveTime=LeaveT
    s a.LeaveStatus=LStatus
    s a.InstructionForPatients=Guide
    s a.ClinicalImpression=ClinImpression
    s a.AdjustDose=AdjustDose
    s a.Signature=Usr
    s a.SignatureDate=+$h
    s a.SignatureTime=$p($h,",",2)
    
    d a.%Save()

    q 0
}

ClassMethod GetInfo(ID, SubID)
{
	
	q:ID="" ""
	s child=$p(ID,"||",2)
	if SubID=""  s SubID=$o(^ABN.DHCNurCureRecD(+ID,"ChildSub",child,"BadSub",""),-1)
	q:SubID="" ""
	s rowid=+ID_"||"_child_"||"_SubID
	s a=##class(ABN.DHCNurBadResponse).%OpenId(rowid)	
    s InjectD=a.InjectionDate
    s:InjectD'="" InjectD=$zd(InjectD,4)
    s InjectT=a.InjectionTime
    s:InjectT'="" InjectT=$zt(InjectT)
    s ReactD=a.ResponseDate
    s:ReactD'="" ReactD=$zd(ReactD,4)
    s ReactT=a.RecponseTime
    s:ReactT'="" ReactT=$zt(ReactT)
    s deepness=a.LiquidDensity
    s firstinject=a.FirstInjection
    s MissionWind=a.MissionWind
    s Blushes=a.Blushes
    s BreathL=a.Breath
    s SkinL=a.Skin
    s NoseEyeL=a.NoseEye
    s CardiovascularL=a.CardiovascularSystem
    s OtherL=a.Other
    s MeasureL=a.Measure
    s LeaveD=a.leaveDate
    s:LeaveD'="" LeaveD=$zd(LeaveD,4)
    s LeaveT=a.LeaveTime
    s:LeaveT'="" LeaveT=$zt(LeaveT)
    s LStatus=a.LeaveStatus
    s Guide=a.InstructionForPatients
    s ClinImpression=a.ClinicalImpression
    s AdjustDose=a.AdjustDose
    s Usr=a.Signature
    s SignD=a.SignatureDate
    s:SignD'="" SignD=$zd(SignD,4)
    s SignT=a.SignatureTime
    s:SignT'="" SignT=$zt(SignT)
    s Localreact=a.MissionWind
	d a.%Close()
	//if (MissionWind'="")||(Blushes'="")  s Localreact="LR"_MissionWind_"/"_Blushes	
	s OutStr=BreathL_"^"_SkinL_"^"_NoseEyeL_"^"_CardiovascularL_"^"_OtherL_"^"_MeasureL
	s OutStr=OutStr_"^"_InjectD_"^"_InjectT_"^"_ReactD_"^"_ReactT_"^"_LeaveD_"^"_LeaveT
	s OutStr=OutStr_"^"_LStatus_"^"_Guide_"^"_Localreact_"^"_deepness_"^"_AdjustDose
	s OutStr=OutStr_"^"_firstinject_"^"_ClinImpression
   
    q OutStr
}

}
