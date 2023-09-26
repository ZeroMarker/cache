Class web.DHCWLCommon Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator?      
/// CreatDate?    2017-09
/// description:  取得会诊申请状态
/// Table?        DHC_EmConsStatus 
/// Input?        
/// Output?      
/// d ##class(%ResultSet).RunQuery("web.DHCWLCommon","GetAllEmConsultStatus") 
Query GetAllEmConsultStatus(hosId As %String) As %Query(ROWSPEC = "id:%String,code:%String,desc:%String") [ SqlProc ]
{
}

ClassMethod GetAllEmConsultStatusExecute(ByRef qHandle As %Binary, hosId As %String) As %Status
{
	n (qHandle,hosId)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1

 	s id=0
 	f  s id=$o(^DHCEMCONS(id)) q:id=""  d
 	.s desc=$p(^DHCEMCONS(id),"^",2)
 	.s code=$p(^DHCEMCONS(id),"^",1)
 	.s hosDr=$p(^DHCEMCONS(id),"^",4)
 	.q:hosDr'=hosId   //
 	.d outputRowECStatus
    
	Quit $$$OK
	
outputRowECStatus
 s row=$listbuild(id,code,desc)
 s ^CacheTemp(repid,ind)=row
 s ind=ind+1
 q
}

ClassMethod GetAllEmConsultStatusClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllEmConsultStatusExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod GetAllEmConsultStatusFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAllEmConsultStatusExecute ]
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

/// Creator?      czx
/// CreatDate?    2017-09
/// description:  取得门诊科室明细(科室查询条件用)，通过BS代码维护获取
/// Table?        CT_LOC 
/// Input?        
/// Output?       depId:科室id,depDesc:科室描述
/// d ##class(%ResultSet).RunQuery("web.DHCWLCommon","GetOpDep","KSCRZ") 
Query GetOpDep(depSubCode As %String) As %Query(ROWSPEC = "depId:%String,depDesc:%String") [ SqlProc ]
{
}

ClassMethod GetOpDepExecute(ByRef qHandle As %Binary, depSubCode As %String) As %Status
{
	n (qHandle,depSubCode)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	k ^TEMPDHCWL($j)
 	
 	d InitItem^DHCWLTJSCommon(depSubCode) //初始化门诊科室子组放在^TEMPDHCWL($j,"item")中
 	
 	s depId="" f  s depId=$o(^TEMPDHCWL($j,"item",depId)) q:depId=""  d
 	.s depDesc=$$GetDepDesc^DHCWLCommon(depId) ;获取科室描述
 	.d outputRow1
    k ^TEMPDHCWL($j)
	Quit $$$OK
	
outputRow1
 s row=$listbuild(depId,depDesc)
 s ^CacheTemp(repid,ind)=row
 s ind=ind+1
 q
}

ClassMethod GetOpDepClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOpDepExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod GetOpDepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOpDepExecute ]
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

/// Creator?      chenyi
/// CreatDate?    2019-07
/// description:  获取所有的出诊级别-号别(用于出诊级别下拉数据集)
/// Table?        PAC_AdmReason
/// Input?        
/// Output?       reasonId:病人身份id,reasonDesc:病人身份描述
/// d ##class(%ResultSet).RunQuery("web.DHCWLCommon","GetAllSess") 
Query GetAllSess() As %Query(ROWSPEC = "mSESSDr:%String,sessCode:%String,sessDesc:%String") [ SqlProc ]
{
}

ClassMethod GetAllSessExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	k ^TEMPDHCWL($j)
 	
 	s mSESSDr=0 
 	f  s mSESSDr=$o(^RBC("SESS",mSESSDr)) q:mSESSDr=""  d
 	.s sessDesc=$p(^RBC("SESS",mSESSDr),"^",2)
 	.s sessCode=$p(^RBC("SESS",mSESSDr),"^",1)
 	.d outputRowSess
    k ^TEMPDHCWL($j)
	Quit $$$OK
	
outputRowSess
 s row=$listbuild(mSESSDr,sessCode,sessDesc)
 s ^CacheTemp(repid,ind)=row
 s ind=ind+1
 q
}

ClassMethod GetAllSessClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllSessExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod GetAllSessFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAllSessExecute ]
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

/// Creator?      czx
/// CreatDate?    2017-09
/// description:  通过科室Id取得科室描述(用于报表查询条件说明)
/// Table?        CT_LOC
/// Input?        
/// Output?       locIdStr:科室id串,locDescStr:科室描述串
/// d ##class(%ResultSet).RunQuery("web.DHCWLCommon","GetSessDescById","9,10") 
Query GetSessDescById(sessId As %String) As %Query(ROWSPEC = "sessIdStr:%String,sessDescStr:%String") [ SqlProc ]
{
}

ClassMethod GetSessDescByIdExecute(ByRef qHandle As %Binary, sessId As %String) As %Status
{
	n (qHandle,sessId)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	k ^TEMPDHCWL($j)
 	
 	s outPutDescStr="",outPutIdStr=""
 	i sessId="" d
 	.s outPutIdStr=999999,outPutDescStr="全部" 
 	e  d
 	.s num=0,outPutDescStr="",outPutIdStr=""
 	.s mSESSDr=0 f  s mSESSDr=$o(^RBC("SESS",mSESSDr)) q:mSESSDr=""  d
 	..q:(sessId'="")&&($Find(","_sessId_",",","_mSESSDr_",")=0)
 	..s desc=$p(^RBC("SESS",mSESSDr),"^",2)
 	..i outPutDescStr="" s outPutDescStr=desc,outPutIdStr=mSESSDr
 	..e  s outPutDescStr=outPutDescStr_","_desc,outPutIdStr=outPutIdStr_","_mSESSDr
 	
 	//查询条件默认空显示全部；选择A，显示A；选择2个及2个以上显示A,B等
 	s lenth=$l(outPutDescStr,",")
 	i lenth>=2 d
 	.s sessIdStr=$p(outPutIdStr,",",1,2)_"等"
 	.s sessDescStr=$p(outPutDescStr,",",1,2)_"等"
 	.d outputRowSessId
 	e  d
 	.s sessIdStr=outPutIdStr
 	.s sessDescStr=outPutDescStr
 	.d outputRowSessId

    k ^TEMPDHCWL($j)
	Quit $$$OK
	
outputRowSessId
 s row=$listbuild(sessIdStr,sessDescStr)
 s ^CacheTemp(repid,ind)=row
 s ind=ind+1
 q
}

ClassMethod GetSessDescByIdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSessDescByIdExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod GetSessDescByIdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSessDescByIdExecute ]
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

/// Creator?      czx
/// CreatDate?    2017-09
/// description:  取得病人身份明细(用于病人身份下拉数据集)
/// Table?        PAC_AdmReason
/// Input?        
/// Output?       reasonId:病人身份id,reasonDesc:病人身份描述
/// d ##class(%ResultSet).RunQuery("web.DHCWLCommon","GetALLAdmReason") 
Query GetALLAdmReason() As %Query(ROWSPEC = "reasonId:%String,reasonDesc:%String") [ SqlProc ]
{
}

ClassMethod GetALLAdmReasonExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	k ^TEMPDHCWL($j)
 	
 	
 	s reasonId=0 f  s reasonId=$o(^PAC("ADMREA",reasonId)) q:reasonId=""  d
 	.s reasonDesc=$p(^PAC("ADMREA",reasonId),"^",2)
 	.d outputRow2
    k ^TEMPDHCWL($j)
	Quit $$$OK
	
outputRow2
 s row=$listbuild(reasonId,reasonDesc)
 s ^CacheTemp(repid,ind)=row
 s ind=ind+1
 q
}

ClassMethod GetALLAdmReasonClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetALLAdmReasonExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod GetALLAdmReasonFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetALLAdmReasonExecute ]
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

/// Creator?      czx
/// CreatDate?    2017-09
/// description:  取得各个分院描述(用于院区下拉数据集)
/// Table?        CT_Hospital
/// Input?        
/// Output?       hosId:分院id,hosDesc:分院描述
/// d ##class(%ResultSet).RunQuery("web.DHCWLCommon","GetHospDetail") 
Query GetHospDetail() As %Query(ROWSPEC = "hosId:%String,hosDesc:%String") [ SqlProc ]
{
}

ClassMethod GetHospDetailExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	k ^TEMPDHCWL($j)
 	
 	
 	s hosId=0 f  s hosId=$o(^CT("HOSP",hosId)) q:hosId=""  d
 	.s hosDesc=$p(^CT("HOSP",hosId),"^",2)
 	.d outputRow3
    k ^TEMPDHCWL($j)
	Quit $$$OK
	
outputRow3
 s row=$listbuild(hosId,hosDesc)
 s ^CacheTemp(repid,ind)=row
 s ind=ind+1
 q
}

ClassMethod GetHospDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetHospDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod GetHospDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetHospDetailExecute ]
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

/// Creator?      czx
/// CreatDate?    2017-09
/// description:  通过分院Id取得分院描述(用于报表查询条件说明)
/// Table?        CT_Hospital
/// Input?        hosId：分院ID串
/// Output?       hospIdStr:院区id串,hospDescStr:院区描述串
/// d ##class(%ResultSet).RunQuery("web.DHCWLCommon","GetHospDetailById","2") 
Query GetHospDetailById(hosId As %String) As %Query(ROWSPEC = "hospIdStr:%String,hospDescStr:%String") [ SqlProc ]
{
}

ClassMethod GetHospDetailByIdExecute(ByRef qHandle As %Binary, hosId As %String) As %Status
{
	n (qHandle,hosId)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	k ^TEMPDHCWL($j)
 	
 	s outPutDescStr="",outPutIdStr=""
 	i hosId="" d
 	.s outPutIdStr=999999,outPutDescStr="全部" 
 	e  d
 	.s num=0,outPutDescStr="",outPutIdStr=""
 	.s hospitalId=0 f  s hospitalId=$o(^CT("HOSP",hospitalId)) q:hospitalId=""  d
 	..q:(hosId'="")&&($Find(","_hosId_",",","_hospitalId_",")=0)
 	..s lenth=$l(hosId,",")
 	..s hosDesc=$p(^CT("HOSP",hospitalId),"^",2)
 	..i outPutDescStr="" s outPutDescStr=hosDesc,outPutIdStr=hospitalId
 	..e  s outPutDescStr=outPutDescStr_","_hosDesc,outPutIdStr=outPutIdStr_","_hospitalId  //outPutIdStr存放院区描述串
 	
 	//查询条件默认空显示全部；选择A，显示A；选择2个及2个以上显示A,B等
 	s lenth=$l(outPutDescStr,",")
 	i lenth>=2 d
 	.s hospIdStr=$p(outPutIdStr,",",1,2)_"等"
 	.s hospDescStr=$p(outPutDescStr,",",1,2)_"等"
 	.d outputRow4
 	e  d
 	.s hospIdStr=outPutIdStr
 	.s hospDescStr=outPutDescStr
 	.d outputRow4

    k ^TEMPDHCWL($j)
	Quit $$$OK
	
outputRow4
 s row=$listbuild(hospIdStr,hospDescStr)
 s ^CacheTemp(repid,ind)=row
 s ind=ind+1
 q
}

ClassMethod GetHospDetailByIdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetHospDetailByIdExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod GetHospDetailByIdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetHospDetailByIdExecute ]
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

/// Creator?      czx
/// CreatDate?    2017-09
/// description:  通过科室Id取得科室描述(用于报表查询条件说明)
/// Table?        CT_LOC
/// Input?        
/// Output?       locIdStr:科室id串,locDescStr:科室描述串
/// d ##class(%ResultSet).RunQuery("web.DHCWLCommon","GetDepDetailById","2") 
Query GetDepDetailById(dep As %String) As %Query(ROWSPEC = "locIdStr:%String,locDescStr:%String") [ SqlProc ]
{
}

ClassMethod GetDepDetailByIdExecute(ByRef qHandle As %Binary, dep As %String) As %Status
{
	n (qHandle,dep)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	k ^TEMPDHCWL($j)
 	
 	s outPutDescStr="",outPutIdStr=""
 	i dep="" d
 	.s outPutIdStr=999999,outPutDescStr="全部" 
 	e  d
 	.s num=0,outPutDescStr="",outPutIdStr=""
 	.s locId=0 f  s locId=$o(^CTLOC(locId)) q:locId=""  d
 	..q:(dep'="")&&($Find(","_dep_",",","_locId_",")=0)
 	..s locDesc=$$GetDepDesc^DHCWLCommon(locId) ;获取科室描述
 	..i outPutDescStr="" s outPutDescStr=locDesc,outPutIdStr=locId
 	..e  s outPutDescStr=outPutDescStr_","_locDesc,outPutIdStr=outPutIdStr_","_locId
 	
 	//查询条件默认空显示全部；选择A，显示A；选择2个及2个以上显示A,B等
 	s lenth=$l(outPutDescStr,",")
 	i lenth>=2 d
 	.s locIdStr=$p(outPutIdStr,",",1,2)_"等"
 	.s locDescStr=$p(outPutDescStr,",",1,2)_"等"
 	.d outputRow5
 	e  d
 	.s locIdStr=outPutIdStr
 	.s locDescStr=outPutDescStr
 	.d outputRow5

    k ^TEMPDHCWL($j)
	Quit $$$OK
	
outputRow5
 s row=$listbuild(locIdStr,locDescStr)
 s ^CacheTemp(repid,ind)=row
 s ind=ind+1
 q
}

ClassMethod GetDepDetailByIdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDepDetailByIdExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod GetDepDetailByIdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDepDetailByIdExecute ]
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

/// Creator?      chenyi
/// CreatDate?    2019-07-25
/// description:  通过科室Id取得科室描述(用于报表查询条件说明)
/// Table?        CT_LOC
/// Input?        
/// Output?       locIdStr:科室id串,locDescStr:科室描述串
/// d ##class(%ResultSet).RunQuery("web.DHCWLCommon","GetDocDetailById","2") 
Query GetDocDetailById(doc As %String) As %Query(ROWSPEC = "docIdStr:%String,docDescStr:%String") [ SqlProc ]
{
}

ClassMethod GetDocDetailByIdExecute(ByRef qHandle As %Binary, doc As %String) As %Status
{
	n (qHandle,doc)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	k ^TEMPDHCWL($j)
 	
 	s outPutDescStr="",outPutIdStr=""
 	i doc="" d
 	.s outPutIdStr=999999,outPutDescStr="全部" 
 	e  d
 	.s num=0,outPutDescStr="",outPutIdStr=""
 	.s docId=0 f  s docId=$o(^CTPCP(docId)) q:docId=""  d
 	..q:(doc'="")&&($Find(","_doc_",",","_docId_",")=0)
 	..s docDesc=$p(^CTPCP(docId,1),"^",2) ;获取科室描述
 	..i outPutDescStr="" s outPutDescStr=docDesc,outPutIdStr=docId
 	..e  s outPutDescStr=outPutDescStr_","_docDesc,outPutIdStr=outPutIdStr_","_docId
 	
 	//查询条件默认空显示全部；选择A，显示A；选择2个及2个以上显示A,B等
 	s lenth=$l(outPutDescStr,",")
 	i lenth>=2 d
 	.s docIdStr=$p(outPutIdStr,",",1,2)_"等"
 	.s docDescStr=$p(outPutDescStr,",",1,2)_"等"
 	.d outputRowDoc
 	e  d
 	.s docIdStr=outPutIdStr
 	.s docDescStr=outPutDescStr
 	.d outputRowDoc

    k ^TEMPDHCWL($j)
	Quit $$$OK
	
outputRowDoc
 s row=$listbuild(docIdStr,docDescStr)
 s ^CacheTemp(repid,ind)=row
 s ind=ind+1
 q
}

ClassMethod GetDocDetailByIdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDocDetailByIdExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod GetDocDetailByIdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDocDetailByIdExecute ]
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

/// Creator?      czx
/// CreatDate?    2017-09
/// description:  通过就诊类型code取得就诊类型描述(用于报表查询条件说明)
/// Table?        
/// Input?        
/// Output?       admTypeIdStr:就诊类型code串,admTypeDescStr:就诊类型描述串
/// d ##class(%ResultSet).RunQuery("web.DHCWLCommon","GetAdmTypeDetailById","O,E") 
Query GetAdmTypeDetailById(admType As %String) As %Query(ROWSPEC = "admTypeIdStr:%String,admTypeDescStr:%String") [ SqlProc ]
{
}

ClassMethod GetAdmTypeDetailByIdExecute(ByRef qHandle As %Binary, admType As %String) As %Status
{
	n (qHandle,admType)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	k ^TEMPDHCWL($j)
 	
 	s outPutDescStr="",outPutIdStr=""
 	i admType="" d
 	.s outPutIdStr=999999,outPutDescStr="全部" 
 	e  d
 	.s num=0,outPutDescStr="",outPutIdStr=""
 	.s typeLenth=$l(admType,",")
 	.f i=1:1:typeLenth d
 	..s type=$p(admType,",",i)
 	..s typeDesc=$Case(type,"O":"门诊","E":"急诊","I":"住院","H":"体检")
 	..i outPutDescStr="" s outPutDescStr=typeDesc,outPutIdStr=type
 	..e  s outPutDescStr=outPutDescStr_","_typeDesc,outPutIdStr=outPutIdStr_","_type
 	
 	//查询条件默认空显示全部；选择A，显示A；选择2个及2个以上显示A,B等
 	s lenth=$l(outPutDescStr,",")
 	i lenth>=2 d
 	.s admTypeIdStr=$p(outPutIdStr,",",1,2)_"等"
 	.s admTypeDescStr=$p(outPutDescStr,",",1,2)_"等"
 	.d outputRow6
 	e  d
 	.s admTypeIdStr=outPutIdStr
 	.s admTypeDescStr=outPutDescStr
 	.d outputRow6

    k ^TEMPDHCWL($j)
	Quit $$$OK
	
outputRow6
 s row=$listbuild(admTypeIdStr,admTypeDescStr)
 s ^CacheTemp(repid,ind)=row
 s ind=ind+1
 q
}

ClassMethod GetAdmTypeDetailByIdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAdmTypeDetailByIdExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod GetAdmTypeDetailByIdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAdmTypeDetailByIdExecute ]
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

/// Creator?      czx
/// CreatDate?    2017-09
/// description:  通过病人身份Id取得病人身份描述(用于报表查询条件说明)
/// Table?        PAC_AdmReason
/// Input?        
/// Output?       reasonIdStr:病人身份id串,reasonDescStr:病人身份描述串
/// d ##class(%ResultSet).RunQuery("web.DHCWLCommon","GetAdmTypeDetailById","2") 
Query GetAdmReasonDetailById(admReason As %String) As %Query(ROWSPEC = "reasonIdStr:%String,reasonDescStr:%String") [ SqlProc ]
{
}

ClassMethod GetAdmReasonDetailByIdExecute(ByRef qHandle As %Binary, admReason As %String) As %Status
{
	n (qHandle,admReason)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	k ^TEMPDHCWL($j)
 	
 	s outPutDescStr="",outPutIdStr=""
 	i admReason="" d
 	.s outPutIdStr=999999,outPutDescStr="全部" 
 	e  d
 	.s num=0,outPutDescStr="",outPutIdStr=""
 	.s admReasonId=0 f  s admReasonId=$o(^PAC("ADMREA",admReasonId)) q:admReasonId=""  d
 	..q:(admReason'="")&&($Find(","_admReason_",",","_admReasonId_",")=0)
 	..s reasonDesc=$p(^PAC("ADMREA",admReasonId),"^",2)
 	..i outPutDescStr="" s outPutDescStr=reasonDesc,outPutIdStr=admReasonId
 	..e  s outPutDescStr=outPutDescStr_","_reasonDesc,outPutIdStr=outPutIdStr_","_admReasonId
 	
 	//查询条件默认空显示全部；选择A，显示A；选择2个及2个以上显示A,B等
 	s lenth=$l(outPutDescStr,",")
 	i lenth>=2 d
 	.s reasonIdStr=$p(outPutIdStr,",",1,2)_"等"
 	.s reasonDescStr=$p(outPutDescStr,",",1,2)_"等"
 	.d outputRow7
 	e  d
 	.s reasonIdStr=outPutIdStr
 	.s reasonDescStr=outPutDescStr
 	.d outputRow7

    k ^TEMPDHCWL($j)
	Quit $$$OK
	
outputRow7
 s row=$listbuild(reasonIdStr,reasonDescStr)
 s ^CacheTemp(repid,ind)=row
 s ind=ind+1
 q
}

ClassMethod GetAdmReasonDetailByIdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAdmReasonDetailByIdExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod GetAdmReasonDetailByIdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAdmReasonDetailByIdExecute ]
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

/// Creator?      czx
/// CreatDate?    2017-09
/// description:  模糊查询医生(用于医生查询条件放大镜)
/// Table?        CT_CareProv
/// Input?        
/// Output?       reasonIdStr:病人身份id串,reasonDescStr:病人身份描述串
/// d ##class(%ResultSet).RunQuery("web.DHCWLCommon","GetDocByDesc","刘晓") 
Query GetDocByDesc(inputDocDesc As %String) As %Query(ROWSPEC = "docId:%String,docDesc:%String") [ SqlProc ]
{
}

ClassMethod GetDocByDescExecute(ByRef qHandle As %Binary, inputDocDesc As %String) As %Status
{
	n (qHandle,inputDocDesc)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	k ^TEMPDHCWL($j)
 	
 	
 	s docDesc="全部",docId="" d outputRow8
 	s docId=0 f  s docId=$o(^CTPCP(docId)) q:docId=""  d
 	.s docDesc=$p(^CTPCP(docId,1),"^",2)
 	.q:docDesc'[inputDocDesc
 	.d outputRow8
 

    k ^TEMPDHCWL($j)
	Quit $$$OK
	
outputRow8
 s row=$listbuild(docId,docDesc)
 s ^CacheTemp(repid,ind)=row
 s ind=ind+1
 q
}

ClassMethod GetDocByDescClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDocByDescExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod GetDocByDescFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDocByDescExecute ]
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

/// Creator?      czx
/// CreatDate?    2017-09
/// description:  门诊科室子组维护明细
/// Table?        DHCWL_CodeCfg.SubGroupItem,DHCWL_CodeCfg.SubGroup
/// Input?        
/// Output?       subDesc:子组描述,depDesc:科室描述
/// d ##class(%ResultSet).RunQuery("web.DHCWLCommon","GetMZKSGroup") 
Query GetMZKSGroup() As %Query(ROWSPEC = "subDesc,depDesc") [ SqlProc ]
{
}

ClassMethod GetMZKSGroupExecute(ByRef qHandle As %Binary) As %Status
{
	//n (qHandle,inputDocDesc)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	k ^TEMPDHCWL($j)
 	
    s grpId = $o(^DHCWL.CodeCfg.GroupI("Code"," MZKS",""))  
    s subId = "" f  s subId = $o(^DHCWL.CodeCfg.SubGroupI("GrpDr",grpId,subId)) q:subId=""  d
    .s arcId = "" f  s arcId = $o( ^DHCWL.CodeCfg.SubGroupItemI("SGrpIM",subId,arcId)) q:arcId=""  d
    ..s tarItem = $e(arcId,2,$l(arcId))
    ..s subDesc=$lg(^DHCWL.CodeCfg.SubGroupD(subId),3)  //子组描述
    ..s depDesc=$$GetDepDesc^DHCWLCommon(tarItem)  //科室描述
    ..d outputRow9
    k ^TEMPDHCWL($j)
	Quit $$$OK
	
outputRow9
 s row=$listbuild(subDesc,depDesc)
 s ^CacheTemp(repid,ind)=row
 s ind=ind+1
 q
}

ClassMethod GetMZKSGroupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMZKSGroupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod GetMZKSGroupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMZKSGroupExecute ]
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

/// Creator?      czx
/// CreatDate?    2017-12
/// description:  收费员下拉数据集
/// Table?        SS_USER
/// Input?        
/// Output?       subDesc:子组描述,depDesc:科室描述
/// d ##class(%ResultSet).RunQuery("web.DHCWLCommon","GetPrtUser") 
Query GetPrtUser() As %Query(ROWSPEC = "userId,userName") [ SqlProc ]
{
}

ClassMethod GetPrtUserExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	k ^TEMPDHCWL($j)
	
	s userId="" f  s userId=$o(^SSU("SSUSR",userId)) q:userId=""  d
	.s defaltDep=$p(^SSU("SSUSR",userId),"^",4)
	.q:defaltDep=""
	.q:'$d(^CTLOC(defaltDep))
	.s ctlocType=$p(^CTLOC(defaltDep),"^",13)
	.Q:ctlocType'="C"
	.s userName=$p(^SSU("SSUSR",userId),"^",2)
	.d outputRow10
    k ^TEMPDHCWL($j)
	Quit $$$OK
	
outputRow10
 s row=$listbuild(userId,userName)
 s ^CacheTemp(repid,ind)=row
 s ind=ind+1
 q
}

ClassMethod GetPrtUserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPrtUserExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod GetPrtUserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPrtUserExecute ]
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

/// Creator?      chenyi
/// CreatDate?    2017-12-14
/// description:  取得病区，在代码维护统计子组类面的病区
/// Table?        pac_ward 
/// Input?        
/// Output?       wardId:id,wardDesc:病区描述
/// d ##class(%ResultSet).RunQuery("web.DHCWLCommon","GetWardInBSSub","BQCRZ") 
Query GetWardInBSSub(subCode As %String) As %Query(ROWSPEC = "wardId:%String,wardDesc:%String,subDesc:%String") [ SqlProc ]
{
}

ClassMethod GetWardInBSSubExecute(ByRef qHandle As %Binary, subCode As %String) As %Status
{
	n (qHandle,subCode)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	k ^TEMPDHCWL($j)
 	q:subCode="" $$$OK
 	d InitItem^DHCWLTJSCommon(subCode) //初始化门诊科室子组放在^TEMPDHCWL($j,"item")中
 	
 	s wardId="" f  s wardId=$o(^TEMPDHCWL($j,"item",wardId)) q:wardId=""  d
 	.s wardDesc=$$GetWardDesc^DHCWLCommon(wardId) ;获取科室描述
 	.s subDesc=$g(^TEMPDHCWL($j,"item",wardId))
 	.d outputWardInSub
    k ^TEMPDHCWL($j)
	Quit $$$OK
	
outputWardInSub
 s row=$listbuild(wardId,wardDesc,subDesc)
 s ^CacheTemp(repid,ind)=row
 s ind=ind+1
 q
}

ClassMethod GetWardInBSSubClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetWardInBSSubExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod GetWardInBSSubFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetWardInBSSubExecute ]
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

/// Creator?      chenyi
/// CreatDate?    2017-12-14
/// description:  通过科室Id取得科室描述(用于报表查询条件说明)
/// Table?        pac_desc
/// Input?        
/// Output?       locIdStr:科室id串,locDescStr:科室描述串
/// d ##class(%ResultSet).RunQuery("web.DHCWLCommon","GetWardDetailById","2") 
Query GetWardDetailById(ward As %String) As %Query(ROWSPEC = "locIdStr:%String,locDescStr:%String") [ SqlProc ]
{
}

ClassMethod GetWardDetailByIdExecute(ByRef qHandle As %Binary, ward As %String) As %Status
{
	n (qHandle,ward)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	k ^TEMPDHCWL($j)
 	
 	s outPutDescStr="",outPutIdStr=""
 	i ward="" d
 	.s outPutIdStr=999999,outPutDescStr="全部" 
 	e  d
 	.s num=0,outPutDescStr="",outPutIdStr=""
 	.s wardId=0 f  s wardId=$o(^PAWARD(wardId)) q:wardId=""  d
 	..q:(wardId="BED_BedType_DR")||(wardId="BED_Room_DR")
 	..s wardDesc=$$GetWardDesc^DHCWLCommon(wardId) ;获取科室描述
 	..q:(ward'="")&&($Find(","_ward_",",","_wardId_",")=0)&&($Find(","_ward_",",","_wardDesc_",")=0)
 	..i outPutDescStr="" s outPutDescStr=wardDesc,outPutIdStr=wardId
 	..e  s outPutDescStr=outPutDescStr_","_wardDesc,outPutIdStr=outPutIdStr_","_wardId
 	
 	//查询条件默认空显示全部；选择A，显示A；选择2个及2个以上显示A,B等
 	s lenth=$l(outPutDescStr,",")
 	i lenth>=2 d
 	.s locIdStr=$p(outPutIdStr,",",1,2)_"等"
 	.s locDescStr=$p(outPutDescStr,",",1,2)_"等"
 	.d outputRowWard
 	e  d
 	.s locIdStr=outPutIdStr
 	.s locDescStr=outPutDescStr
 	.d outputRowWard

    k ^TEMPDHCWL($j)
	Quit $$$OK
	
outputRowWard
 s row=$listbuild(locIdStr,locDescStr)
 s ^CacheTemp(repid,ind)=row
 s ind=ind+1
 q
}

ClassMethod GetWardDetailByIdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetWardDetailByIdExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod GetWardDetailByIdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetWardDetailByIdExecute ]
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

/// Creator?      chenyi
/// CreatDate?    2017-12-14
/// description:  通过代码子组的code,取子组明细query(用于报表查询条件说明)
/// Table?        
/// Input?        
/// Output?       
/// d ##class(%ResultSet).RunQuery("web.DHCWLCommon","QuerySubDetailByCode","KSCRZ") 
Query QuerySubDetailByCode(code As %String) As %Query(ROWSPEC = "sort:%String,subCode:%String,subDesc:%String,subDtDr:%String,subDtDesc:%String") [ SqlProc ]
{
}

ClassMethod QuerySubDetailByCodeExecute(ByRef qHandle As %Binary, code As %String) As %Status
{
	n (qHandle,code)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	k ^||TEMPDHCWL($j)
 	
 	q:code="" 0
	s code=$zcvt(code,"U")
	s grpId=$o(^DHCWL.CodeCfg.GroupI("Code"," "_code,"")) 
	q:grpId="" 0

	s subgrpId=0 f  s subgrpId=$o(^DHCWL.CodeCfg.SubGroupI("GrpDr",grpId,subgrpId)) q:subgrpId=""  d
	.s value=##class(DHCWL.CodeCfg.SubGroup).%OpenId(subgrpId)
	.s subgrpDesc=value.SGrpDesc
	.s subgrpCode=value.SGrpCode
	.s subgrpSort=value.SGrpSort
	.s mainDr=$li(^DHCWL.CodeCfg.SubGroupD(subgrpId),4)		//关联的大组id
	
	.s dimDr=$li(^DHCWL.CodeCfg.GroupD(mainDr),11)
	.s dimPDr=$o(^DHCWL.MKPI.DimPropertyI("DimProDr",dimDr,"Y",""))
	.s exCode=$li(^DHCWL.MKPI.DimPropertyD(dimPDr),6)
	.w !,exCode
	.s itemDr=0 f  s itemDr=$o(^DHCWL.CodeCfg.SubGroupItemI("SGrpIM",subgrpId,itemDr)) q:itemDr=""  d
	..s itemDrE=$tr(itemDr," ","")
	..s ^||TEMPDHCWL($j,subgrpSort,itemDrE)=subgrpDesc_"^"_subgrpCode_"^"_itemDrE
	..s ^||TEMPDHCWL($j,subgrpSort)=subgrpDesc_"^"_subgrpCode_"^"_exCode
	;zw ^||TEMPDHCWL($j)
	s sort=0 f  s sort=$o(^||TEMPDHCWL($j,sort)) q:sort=""  d
	.s subDtDr=0 f  s subDtDr=$o(^||TEMPDHCWL($j,sort,subDtDr)) q:subDtDr=""  d
	..s subDesc=$p($g(^||TEMPDHCWL($j,sort)),"^",1)
	..s subCode=$p($g(^||TEMPDHCWL($j,sort)),"^",2)
	..s exCode=$p($g(^||TEMPDHCWL($j,sort)),"^",3)_"^"_$p($g(^||TEMPDHCWL($j,sort)),"^",4)
	..s exeStr="s subDtDesc=$$"_exCode_"("""_subDtDr_""")"
	..x exeStr
	..d outputSubDet
	

    k ^||TEMPDHCWL($j)
	Quit $$$OK
	
outputSubDet
 s row=$listbuild(sort,subCode,subDesc,subDtDr,subDtDesc)
 s ^CacheTemp(repid,ind)=row
 s ind=ind+1
 q
}

ClassMethod QuerySubDetailByCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QuerySubDetailByCodeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod QuerySubDetailByCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QuerySubDetailByCodeExecute ]
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

/// Creator?      chenyi	
/// CreatDate?    2018-06
/// description:  获取所有科室
/// Table?        CT_LOC 
/// Input?        
/// Output?       depId:科室id,depDesc:科室描述
/// d ##class(%ResultSet).RunQuery("web.DHCWLCommon","GetAllDep") 
Query GetAllDep() As %Query(ROWSPEC = "depId:%String,depDesc:%String") [ SqlProc ]
{
}

ClassMethod GetAllDepExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 
 	 	
 	s depId=0 f  s depId=$o(^CTLOC(depId)) q:depId=""  d
 	.s depDesc=$$GetDepDesc^DHCWLCommon(depId) ;获取科室描述
 	.d outputRowADep

	Quit $$$OK
	
outputRowADep
 s row=$listbuild(depId,depDesc)
 s ^CacheTemp(repid,ind)=row
 s ind=ind+1
 q
}

ClassMethod GetAllDepClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllDepExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod GetAllDepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAllDepExecute ]
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

/// Creator?      chenyi	
/// CreatDate?    2018-06
/// description:  获取所有病区
/// Table?        pac_ward 
/// Input?        
/// Output?       depId:科室id,depDesc:科室描述
/// d ##class(%ResultSet).RunQuery("web.DHCWLCommon","GetAllWard") 
Query GetAllWard() As %Query(ROWSPEC = "wardId:%String,wardDesc:%String") [ SqlProc ]
{
}

ClassMethod GetAllWardExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	s wardId=0 f  s wardId=$o(^PAWARD(wardId)) q:wardId=""  d
 	.q:wardId="BED_BedType_DR"
 	.q:wardId="BED_Room_DR"
 	.s wardDesc=$$GetWardDesc^DHCWLCommon(wardId) ;获取科室描述
 	.d outputRowAWard

	Quit $$$OK
	
outputRowAWard
 s row=$listbuild(wardId,wardDesc)
 s ^CacheTemp(repid,ind)=row
 s ind=ind+1
 q
}

ClassMethod GetAllWardClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllWardExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod GetAllWardFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAllWardExecute ]
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

/// Creator?      chenyi
/// CreatDate?    2018-06
/// description:  查询所有医生
/// Table?        CT_CareProv
/// Input?        
/// Output?       reasonIdStr:病人身份id串,reasonDescStr:病人身份描述串
/// d ##class(%ResultSet).RunQuery("web.DHCWLCommon","GetAllDoc") 
Query GetAllDoc() As %Query(ROWSPEC = "docId:%String,docDesc:%String") [ SqlProc ]
{
}

ClassMethod GetAllDocExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	s docId=0 f  s docId=$o(^CTPCP(docId)) q:docId=""  d
 	.s docDesc=$p(^CTPCP(docId,1),"^",2)
 	.d outputRowADoc
 
	Quit $$$OK
	
outputRowADoc
 s row=$listbuild(docId,docDesc)
 s ^CacheTemp(repid,ind)=row
 s ind=ind+1
 q
}

ClassMethod GetAllDocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllDocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod GetAllDocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAllDocExecute ]
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

/// Creator?      chenyi
/// CreatDate?    2018-06
/// description:  查询所有就诊状态
/// Table?        
/// Input?        
/// Output?       reasonIdStr:病人身份id串,reasonDescStr:病人身份描述串
/// d ##class(%ResultSet).RunQuery("web.DHCWLCommon","QueryAdmTypeByCode","") 
Query QueryAdmTypeByCode(code As %String) As %Query(ROWSPEC = "codeStr:%String") [ SqlProc ]
{
}

ClassMethod QueryAdmTypeByCodeExecute(ByRef qHandle As %Binary, code As %String) As %Status
{
	n (qHandle,code)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	s codeStr=$replace(code,"I","住院")
 	s codeStr=$replace(codeStr,"O","门诊")
 	s codeStr=$replace(codeStr,"E","急诊")
 	s codeStr=$replace(codeStr,"H","体检")
 	i (codeStr="")||(codeStr="999999") s codeStr="全部"
 	d outputAdmType
 
	Quit $$$OK
	
outputAdmType
 s row=$listbuild(codeStr)
 s ^CacheTemp(repid,ind)=row
 s ind=ind+1
 q
}

ClassMethod QueryAdmTypeByCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryAdmTypeByCodeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod QueryAdmTypeByCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryAdmTypeByCodeExecute ]
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

/// Creator?      chenyi
/// CreatDate?    2018-06
/// description:  查询所有就诊状态
/// Table?        
/// Input?        
/// Output?       reasonIdStr:病人身份id串,reasonDescStr:病人身份描述串
/// d ##class(%ResultSet).RunQuery("web.DHCWLCommon","GetYJDepTree","") 
Query GetYJDepTree() As %Query(ROWSPEC = "id:%String,desc:%String,type:%String") [ SqlProc ]
{
}

ClassMethod GetYJDepTreeExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle,code)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	s id=0 f  s id=$o(^CTLOC(id)) q:id=""  d
 	.s desc=$$GetDepDesc^DHCWLCommon(id) ;获取科室描述
 	.s type=$$GetBSSubDesc^DHCWLBuildDimDataGetSubGrp(id_"~XMTJKS")
 	.q:(type="")||(type="NULL")
 	.d outputSubGrpDep
 
	Quit $$$OK
	
outputSubGrpDep
 s row=$listbuild(id,desc,type)
 s ^CacheTemp(repid,ind)=row
 s ind=ind+1
 q
}

ClassMethod GetYJDepTreeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetYJDepTreeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod GetYJDepTreeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetYJDepTreeExecute ]
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

}
