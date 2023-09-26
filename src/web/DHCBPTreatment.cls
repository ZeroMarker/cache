Import SQLUser

Class web.DHCBPTreatment Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("web.DHCBPTreatment","FindTreatmentList")
Query FindTreatmentList(locId As %String = "", SuperCatCode As %String = "") As %Query(ROWSPEC = "Id:%String,Code:%String,Description:%String,SymptomNote:%String,TreatmentNote:%String,TreatmentCatId:%String,TreatmentSuperCatId:%String") [ SqlProc ]
{
}

ClassMethod FindTreatmentListExecute(ByRef qHandle As %Binary, locId As %String = "", SuperCatCode As %String = "") As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 	s tBPCTRowId=0
	f  s tBPCTRowId=$o(^DHCBPC("Treatment",tBPCTRowId)) q:tBPCTRowId=""  d
		.s Code=$lg(^DHCBPC("Treatment",tBPCTRowId),1)
		.s Description=$lg(^DHCBPC("Treatment",tBPCTRowId),2)
		.s SymptomNote=$lg(^DHCBPC("Treatment",tBPCTRowId),3)
		.s TreatmentNote=$lg(^DHCBPC("Treatment",tBPCTRowId),4)
		.s TreatmentCatId=$lg(^DHCBPC("Treatment",tBPCTRowId),5)
		.s BPCTIfSuperCat=1,TreatmentCatDesc="",TreatmentSuperCatId="",TreatmentSuperCatDesc=""
		.i TreatmentCatId'="" d
			..s TreatmentCatDesc=$lg(^DHCBPC("TreatmentCat",TreatmentCatId),2)
			..i $lg(^DHCBPC("TreatmentCat",TreatmentCatId),3)'="Y" s BPCTIfSuperCat=0
			..s TreatmentSuperCatId=$lg(^DHCBPC("TreatmentCat",TreatmentCatId),4)
			..i TreatmentSuperCatId'="" d
				...s TreatmentSuperCatCode=$lg(^DHCBPC("TreatmentSuperCat",TreatmentSuperCatId),1)
				...i (SuperCatCode'="")&&(SuperCatCode'=TreatmentSuperCatCode) s BPCTIfSuperCat=0
				...//w TreatmentSuperCatCode_"/"_SuperCatCode,!
				...s TreatmentSuperCatDesc=$lg(^DHCBPC("TreatmentSuperCat",TreatmentSuperCatId),2) 
				...i $lg(^DHCBPC("TreatmentSuperCat",TreatmentSuperCatId),3)'="Y" s BPCTIfSuperCat=0
				...s TreatmentSuperCatLoc=$lg(^DHCBPC("TreatmentSuperCat",TreatmentSuperCatId),4)
				...;i (locId'="")&&(TreatmentSuperCatLoc'=locId) s BPCTIfSuperCat=0
		.q:(BPCTIfSuperCat=0)	
	    .d OutputRow1	    
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
OutputRow1
	s Data=$lb(tBPCTRowId,Code,Description,SymptomNote,TreatmentNote,TreatmentCatId,TreatmentSuperCatId)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindTreatmentListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindTreatmentListExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
	//
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {				// fetch row
 		s Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindTreatmentListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindTreatmentListExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// Creator：      mafucheng
/// CreatDate：    20170609
/// Description：  保存血透治疗记录业务数据表
/// Table：        User.DHCBPTreatment
/// Input：        TreatmentItemPara治疗记录数据串,数据串以$c(3)分割
/// Output：       result治疗记录业务数据表ID,汉字为报错信息
/// Return：       保存成功返回治疗记录业务数据表ID，否则为报错信息
/// Others：       无
/// w ##class(web.DHCBPTreatment).SaveTreatmentItem("32641"_$c(3)_"1"_$c(3)_"2017/6/9 0:00:00"_$c(3)_"2017/6/9 14:31:49"_$c(3)_"症状体征1"_$c(3)_"治疗观察1"_$c(3)_"N"_$c(3)_"199")
ClassMethod SaveTreatmentItem(TreatmentItemPara As %String) As %String
{
	q:TreatmentItemPara="" "参数为空"
	s result=0
	s arrangeId=$p(TreatmentItemPara,$c(3),1)
	s treatmentId=$p(TreatmentItemPara,$c(3),2)
	s id=$p(TreatmentItemPara,$c(3),10)
	s TreatmentItemObj=""
    i (id="") s TreatmentItemObj=##class(User.DHCBPTreatment).%New()
    e  s TreatmentItemObj=##class(User.DHCBPTreatment).%OpenId(id)
	s TreatmentItemObj.BPTBPADr=##class(User.DHCBPArrange).%OpenId(arrangeId)
	s TreatmentItemObj.BPTBPCTDr=##class(User.DHCBPCTreatment).%OpenId(treatmentId)
	s TreatmentItemObj.BPTDate=##class(web.DHCClinicCom).ConvertToDateH($p(TreatmentItemPara,$c(3),3))
	s TreatmentItemObj.BPTTime=##class(web.DHCClinicCom).ConvertToTimeH($p(TreatmentItemPara,$c(3),4))
	s TreatmentItemObj.BPTSymptom=$p(TreatmentItemPara,$c(3),5)
	s TreatmentItemObj.BPTTreatment=$p(TreatmentItemPara,$c(3),6)
	s TreatmentItemObj.BPTStatus=$p(TreatmentItemPara,$c(3),7)
	s TreatmentItemObj.BPTUpdateUserDr=$p(TreatmentItemPara,$c(3),8)
	s TreatmentItemObj.BPTUpdateDate=+$h
	s TreatmentItemObj.BPTUpdateTime=$p($h,",",2)
	s TreatmentItemObj.BPTAdjustmentReason=$p(TreatmentItemPara,$c(3),9)
	d TreatmentItemObj.%Save()
	s result=TreatmentItemObj.%Id()
	d TreatmentItemObj.%Close()
	q result
}

/// d ##class(%ResultSet).RunQuery("web.DHCBPTreatment","FindTreatmentItemList")
Query FindTreatmentItemList(ArrangeId As %String = "", RegisterId As %String = "", FromDate As %String, ToDate As %String, SuperCatCode As %String = "") As %Query(ROWSPEC = "Id:%String,ArrangeId:%String,BPCTTreatmentId:%String,BPCTTreatmentDesc:%String,Date:%String,Time:%String,Symptom:%String,Treatment:%String,UpdateUserId:%String, UpdateUserDesc:%String,UpdateDate:%String,UpdateTime:%String,AdjustmentReason:%String,BPCTTreatmentCatId:%String,BPCTTreatmentCatDesc:%String") [ SqlProc ]
{
}

ClassMethod FindTreatmentItemListExecute(ByRef qHandle As %Binary, ArrangeId As %String = "", RegisterId As %String = "", FromDate As %String, ToDate As %String, SuperCatCode As %String = "") As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1 
 	s FromDate=##class(web.DHCClinicCom).ConvertToDateH(FromDate)
	s ToDate=##class(web.DHCClinicCom).ConvertToDateH(ToDate)	
 	if ArrangeId'="" 
 	{ 
 		s tBPTRowId=0		
		f  s tBPTRowId=$o(^DHCBPTreatment(0,"BPA",ArrangeId,tBPTRowId)) q:tBPTRowId=""  d
      		.q:$$GetTreatmentInfo()<0
      		.d OutputRow1	
 	}
 	if RegisterId'=""
 	{
	 	s tBPTRowId=0
	    f  s tBPTRowId=$o(^DHCBPTreatment(tBPTRowId)) q:tBPTRowId=""  d
	  		.s bpaId=$lg(^DHCBPTreatment(tBPTRowId),1)
	  		.s date=$lg(^DHCBPTreatment(tBPTRowId),3)
	  		.q:(date<FromDate)||(date>ToDate)
	  		.s bpprId=$lg(^DHCBPArrange(bpaId),1)
	  		.q:(RegisterId'=bpprId)
	   		.q:$$GetTreatmentInfo()<0
	   		.d OutputRow1
 	}	    
 	s qHandle=$lb(0,repid,0)
	q $$$OK
GetTreatmentInfo()
    q:tBPTRowId="" -1    
    s arrangeId = $lg(^DHCBPTreatment(tBPTRowId),1)
    s BPCTIfSuperCat=1,BPCTTreatmentDesc="",BPCTTreatmentCatId="",BPCTTreatmentCatDesc=""
    s BPCTTreatmentId = $lg(^DHCBPTreatment(tBPTRowId),2)
    i BPCTTreatmentId'="" d
    	.s BPCTTreatmentDesc = $lg(^DHCBPC("Treatment",BPCTTreatmentId),2)
    	.s BPCTTreatmentCatId=$lg(^DHCBPC("Treatment",BPCTTreatmentId),5)
    	.i BPCTTreatmentCatId'="" d
			..s BPCTTreatmentCatDesc=$lg(^DHCBPC("TreatmentCat",BPCTTreatmentCatId),2)
			..s BPCTTreatmentSuperCatId=$lg(^DHCBPC("TreatmentCat",BPCTTreatmentCatId),4)
			..i BPCTTreatmentSuperCatId'="" d
				...s BPCTTreatmentSuperCatCode=$lg(^DHCBPC("TreatmentSuperCat",BPCTTreatmentSuperCatId),1)
				...i (SuperCatCode'="")&&(SuperCatCode'=BPCTTreatmentSuperCatCode) s BPCTIfSuperCat=0
	q:(BPCTIfSuperCat=0) -3		
    s Date = $lg(^DHCBPTreatment(tBPTRowId),3) 
    i Date'="" s Date =$ZD(Date,3) 
    s Time = $lg(^DHCBPTreatment(tBPTRowId),4)
    i Time'="" s Time =$ZT(Time,2) 
    s Symptom = $lg(^DHCBPTreatment(tBPTRowId),5)  
    s Treatment = $lg(^DHCBPTreatment(tBPTRowId),6) 
    s Status = $lg(^DHCBPTreatment(tBPTRowId),7)
    q:Status'="N" -2
    s UpdateUserId = $lg(^DHCBPTreatment(tBPTRowId),8) 
    i UpdateUserId'="" s UpdateUserDesc=$p($g(^SSU("SSUSR",UpdateUserId)),"^",2)
    s UpdateDate = $zd($lg(^DHCBPTreatment(tBPTRowId),9),3)
    s UpdateTime = $ZT($lg(^DHCBPTreatment(tBPTRowId),10),2)
    s AdjustmentReason = $lg(^DHCBPTreatment(tBPTRowId),11)
    q 0   
OutputRow1
	s Data=$lb(tBPTRowId,arrangeId,BPCTTreatmentId,BPCTTreatmentDesc,Date,Time,Symptom,Treatment,UpdateUserId,UpdateUserDesc,UpdateDate,UpdateTime,AdjustmentReason,BPCTTreatmentCatId,BPCTTreatmentCatDesc)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindTreatmentItemListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindTreatmentItemListExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				
 		s AtEnd=1
 		s Row=""
 	}
 	else      {			
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindTreatmentItemListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindTreatmentItemListExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// Creator：      mafucheng
/// CreatDate：    20170612
/// Description：  删除血透治疗记录业务数据表
/// Table：        User.DHCBPTreatment
/// Input：        BPTRowId治疗记录业务数据表ID
/// Output：       0入参为空,大于0业务数据表ID
/// Return：       删除成功返回治疗记录业务数据表ID，否则为报错信息
/// Others：       无
/// w ##class(web.DHCBPTreatment).DeleteTreatmentItem("1")
ClassMethod DeleteTreatmentItem(BPTRowId As %String) As %String
{
	i BPTRowId="" q -1
	s status="C"
	&SQL(update DHC_BP_Treatment set BPT_Status=:status where BPT_RowId=:BPTRowId)
	q SQLCODE
}

/// d ##class(%ResultSet).RunQuery("web.DHCBPTreatment","FindTreatmentCatList")
Query FindTreatmentCatList(locId As %String = "", SuperCatCode As %String = "") As %Query(ROWSPEC = "Id:%String,Code:%String,Description:%String,TreatmentSuperCatId:%String,TreatmentSuperCatDesc:%String") [ SqlProc ]
{
}

ClassMethod FindTreatmentCatListExecute(ByRef qHandle As %Binary, locId As %String = "", SuperCatCode As %String = "") As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 	s tBPCTCRowId=0
	f  s tBPCTCRowId=$o(^DHCBPC("TreatmentCat",tBPCTCRowId)) q:tBPCTCRowId=""  d
		.s Code=$lg(^DHCBPC("TreatmentCat",tBPCTCRowId),1)
		.s Description=$lg(^DHCBPC("TreatmentCat",tBPCTCRowId),2)
		.q:$lg(^DHCBPC("TreatmentCat",tBPCTCRowId),3)'="Y"
		.s TreatmentSuperCatId=$lg(^DHCBPC("TreatmentCat",tBPCTCRowId),4)
		.s BPCTIfSuperCat=1,TreatmentSuperCatDesc=""
		.i TreatmentSuperCatId'="" d
			..s TreatmentSuperCatCode=$lg(^DHCBPC("TreatmentSuperCat",TreatmentSuperCatId),1)
			..i (SuperCatCode'="")&&(SuperCatCode'=TreatmentSuperCatCode) s BPCTIfSuperCat=0
			..s TreatmentSuperCatDesc=$lg(^DHCBPC("TreatmentSuperCat",TreatmentSuperCatId),2) 
			..i $lg(^DHCBPC("TreatmentSuperCat",TreatmentSuperCatId),3)'="Y" s BPCTIfSuperCat=0
			..s TreatmentSuperCatLoc=$lg(^DHCBPC("TreatmentSuperCat",TreatmentSuperCatId),4)
	    .q:(BPCTIfSuperCat=0)
	    .d OutputRow1	    
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
OutputRow1
	s Data=$lb(tBPCTCRowId,Code,Description,TreatmentSuperCatId,TreatmentSuperCatDesc)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindTreatmentCatListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindTreatmentCatListExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
	//
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {				// fetch row
 		s Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindTreatmentCatListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindTreatmentCatListExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// 把BPT_AdjustmentReason字段的数据移植到BPT_Treatment字段中(程序修改需求)
/// w ##class(web.DHCBPTreatment).updateTreatmentByReasonOldData()
ClassMethod updateTreatmentByReasonOldData() As %String
{
	s tBPTRowId=0
	f  s tBPTRowId=$o(^DHCBPTreatment(tBPTRowId)) q:tBPTRowId=""  d
    	.s Symptom = $lg(^DHCBPTreatment(tBPTRowId),5)  
    	.s Treatment = $lg(^DHCBPTreatment(tBPTRowId),6)
    	.s AdjustmentReason = $lg(^DHCBPTreatment(tBPTRowId),11)
		.i (Treatment="")&&(AdjustmentReason'="") d
    		..&sql(update DHC_BP_Treatment(BPT_Treatment) values(:AdjustmentReason) where BPT_RowId=:tBPTRowId )
	q 1
}

}
