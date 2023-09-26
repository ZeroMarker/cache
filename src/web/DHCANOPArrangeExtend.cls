Class web.DHCANOPArrangeExtend Extends %RegisteredObject
{

/// d ##class(%ResultSet).RunQuery("web.DHCANOPArrangeExtend","FindArrangeExtend","","")
Query FindArrangeExtend(Code As %String = "", Type As %String = "") As %Query(ROWSPEC = "ANCOPAERowId,ANCOPAECode,ANCOPAEDesc,ANCOPAEType,ANCOPAETypeDesc,ANCOPAEActive,ANCOPAEOption,ANCOPAESortNo,ANCOPAEANOPACode")
{
}

ClassMethod FindArrangeExtendExecute(ByRef qHandle As %Binary, Code As %String = "", Type As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	s ANCOPAERowId=""
	i (Code'="")&(Type'="") d
	.f  s ANCOPAERowId=$o(^DHCANC("OPArrangeExtend",0,"TypeCode",Type,Code,ANCOPAERowId)) q:ANCOPAERowId=""  d
	..q:ANCOPAERowId=0
	..s retStr=..GetExtendItemById(ANCOPAERowId)
	..s ANCOPAECode=$p(retStr,"^",1)
	..s ANCOPAEDesc=$p(retStr,"^",2)
	..s ANCOPAEType=$p(retStr,"^",3)
	..s ANCOPAETypeDesc=$p(retStr,"^",4)
	..s ANCOPAEActive=$p(retStr,"^",5)
	..s ANCOPAEOption=$p(retStr,"^",6)
	..s ANCOPAESortNo=$p(retStr,"^",7)
	..s ANCOPAEANOPACode=$p(retStr,"^",8)
	..d OutputExtend
	e  i (Code'="")&(Type="") d
	.f  s ANCOPAERowId=$o(^DHCANC("OPArrangeExtend",0,"Code",Code,ANCOPAERowId)) q:ANCOPAERowId=""  d
	..q:ANCOPAERowId=0
	..s retStr=..GetExtendItemById(ANCOPAERowId)
	..s ANCOPAECode=$p(retStr,"^",1)
	..s ANCOPAEDesc=$p(retStr,"^",2)
	..s ANCOPAEType=$p(retStr,"^",3)
	..s ANCOPAETypeDesc=$p(retStr,"^",4)
	..s ANCOPAEActive=$p(retStr,"^",5)
	..s ANCOPAEOption=$p(retStr,"^",6)
	..s ANCOPAESortNo=$p(retStr,"^",7)
	..s ANCOPAEANOPACode=$p(retStr,"^",8)
	..d OutputExtend	
	e  d
	.f  s ANCOPAERowId=$o(^DHCANC("OPArrangeExtend",ANCOPAERowId)) q:ANCOPAERowId=""  d
	..q:ANCOPAERowId=0
	..s retStr=..GetExtendItemById(ANCOPAERowId)
	..s ANCOPAECode=$p(retStr,"^",1)
	..s ANCOPAEDesc=$p(retStr,"^",2)
	..s ANCOPAEType=$p(retStr,"^",3)
	..q:(Type'="")&(Type'=ANCOPAEType)
	..s ANCOPAETypeDesc=$p(retStr,"^",4)
	..s ANCOPAEActive=$p(retStr,"^",5)
	..s ANCOPAEOption=$p(retStr,"^",6)
	..s ANCOPAESortNo=$p(retStr,"^",7)
	..s ANCOPAEANOPACode=$p(retStr,"^",8)	
	..d OutputExtend
	Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputExtend
 set Data=$lb(ANCOPAERowId,ANCOPAECode,ANCOPAEDesc,ANCOPAEType,ANCOPAETypeDesc,ANCOPAEActive,ANCOPAEOption,ANCOPAESortNo,ANCOPAEANOPACode)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod FindArrangeExtendFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindArrangeExtendExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
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

ClassMethod FindArrangeExtendClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindArrangeExtendExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetExtendItemById(RowId As %String)
{
	q:RowId="" "RowId is null"
	s ANCOPAECode=$li(^DHCANC("OPArrangeExtend",RowId),1)
	s ANCOPAEDesc=$li(^DHCANC("OPArrangeExtend",RowId),2)
	s ANCOPAEType=$li(^DHCANC("OPArrangeExtend",RowId),3)
	s ANCOPAEActive=$li(^DHCANC("OPArrangeExtend",RowId),4)
	s ANCOPAEOption=$li(^DHCANC("OPArrangeExtend",RowId),5)
	s ANCOPAESortNo=$li(^DHCANC("OPArrangeExtend",RowId),6)
	s ANCOPAEANOPACode=$li(^DHCANC("OPArrangeExtend",RowId),7)
	s ANCOPAETypeDesc=""
	i ANCOPAEType="P" s ANCOPAETypeDesc="计划手术"
	e  i ANCOPAEType="PR" s ANCOPAETypeDesc="术前"
	e  i ANCOPAEType="I" s ANCOPAETypeDesc="诱导"
	e  i ANCOPAEType="A" s ANCOPAETypeDesc="麻醉"
	e  i ANCOPAEType="PA" s ANCOPAETypeDesc="复苏室"
	e  i ANCOPAEType="PO" s ANCOPAETypeDesc="术后"
	e  i ANCOPAEType="R" s ANCOPAETypeDesc="恢复"
	
	s retStr=ANCOPAECode_"^"_ANCOPAEDesc_"^"_ANCOPAEType_"^"_ANCOPAETypeDesc_"^"_ANCOPAEActive_"^"_ANCOPAEOption_"^"_ANCOPAESortNo_"^"_ANCOPAEANOPACode
	q retStr
}

/// 添加 修改 数据
/// w ##class(web.DHCANOPArrangeExtend).SaveExtendItem("PR.SQYY^术前用药3^PR^Y^利多卡因;芬太尼;丙泊酚^^")
ClassMethod SaveExtendItem(Para As %String) As %String
{
	s code=$p(Para,"^",1)
	q:code="" "-1^code is null"
	s desc=$p(Para,"^",2)
	s type=$p(Para,"^",3)
	q:type="" "-2^type is null"
	s active=$p(Para,"^",4)
	s option=$p(Para,"^",5)
	s sortno=$p(Para,"^",6)
	s opacode=$p(Para,"^",7)
	
	//s rowId=$o(^DHCANC("OPArrangeExtend",0,"TypeCode",type,code,""))   //code可重复，通过type区分
	s rowId=$o(^DHCANC("OPArrangeExtend",0,"Code",code,""))    //code不可以重复
	i rowId'="" s obj=##class(User.DHCANCOPArrangeExtend).%OpenId(rowId)
	e  s obj=##class(User.DHCANCOPArrangeExtend).%New()
	
	s obj.ANCOPAECode=code
	s obj.ANCOPAEDesc=desc
	s obj.ANCOPAEType=type
	s obj.ANCOPAEActive=active
	s obj.ANCOPAEOption=option
	s obj.ANCOPAESortNo=sortno
	s obj.ANCOPAEANOPACode=opacode
	
	s saveStatus=obj.%Save()
	q:(+saveStatus=0) "-2^数据保存失败!"_code
	s RowId=obj.%Id()
	d obj.%Close()
	q RowId
}

ClassMethod DeleteExtendItem(RowId As %String) As %String
{
	q:RowId="" "RowId is null"
	d ##class(User.DHCANCOPArrangeExtend).%DeleteId(RowId)
	q 0
}

/// w ##class(web.DHCANOPArrangeExtend).SaveArrangeExtend(144,"Name"_$c(3,3)_"^"_"PR.SQYY"_^",3053)
ClassMethod SaveArrangeExtend(opaId, paraStr, userId)
{
	q:opaId="" "-1^opaId is null"
	q:userId="" "-2^userId is null"
	
	s result="",tempResult=""
	f i=1:1:$l(paraStr,"^") d
	.s para=$p(paraStr,"^",i)
	.q:para=""
	.s code=$p(para,$c(3),1)
	.s value=$p(para,$c(3),2)
	.s note=$p(para,$c(3),3)
	.i code'="" d
	..s rowId=$o(^DHCANC("OPArrangeExtend",0,"Code",code,""))
	..i rowId'="" d
	...s retult=..SaveSingleArrangeExtend(opaId,code,value,note,userId)
	...i +retult<0 s result=result_retult_"^"
	..e  d
	...s tempResult=tempResult_code_"^"

	q result
}

ClassMethod SaveSingleArrangeExtend(opaId, code, value, note, userId)
{
	q:opaId="" "-1^opaId is null"
	q:userId="" "-2^userId is null"
	q:code="" "-3^code is null"

	s date=+$h,time=$p($h,",",2)
	s prevalue=""
	s ExtendRowId=$o(^DHCANOPArrangeExtend(0,"OPACode",opaId,code,"")) 
	i ExtendRowId="" s obj=##class(User.DHCANOPArrangeExtend).%New()
	e  d
	.s obj=##class(User.DHCANOPArrangeExtend).%OpenId(ExtendRowId)
	.s prevalue=obj.ANOPAEValue
	
	q:prevalue=value ExtendRowId  //值不改变的 不保存
	
	s obj.ANOPAEANCOPAECode=code
	s obj.ANOPAEOPADr=opaId
	s obj.ANOPAEValue=value
	s obj.ANOPAENote=note
	s obj.ANOPAEUserDr=userId
	s obj.ANOPAEUpdateDate=date
	s obj.ANOPAEUpdateTime=time
	s obj.ANOPAEPreValue=prevalue
	
	s saveStatus=obj.%Save()
	q:(+saveStatus=0) "-4^数据保存失败!"_code
	s RowId=obj.%Id()
	d obj.%Close()

	q RowId
}

/// d ##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(187,"PACU_StewardTime")
ClassMethod SetArrangeExtendValue(opaId, code) As %String
{
	q:opaId="" ""
	q:code="" ""
	s retStr=""

	s extendId=$o(^DHCANOPArrangeExtend(0,"OPACode",opaId,code,""))
	q:extendId="" ""
	s userId=$li(^DHCANOPArrangeExtend(extendId),2)
	s date=$li(^DHCANOPArrangeExtend(extendId),3)
	s time=$li(^DHCANOPArrangeExtend(extendId),4)
	s value=$li(^DHCANOPArrangeExtend(extendId),6)
	s prevalue=$li(^DHCANOPArrangeExtend(extendId),7)
	s note=$li(^DHCANOPArrangeExtend(extendId),8)
	
	s date=##class(web.DHCANOPCom).ConvertToDateH(date,$H)
	s time=##class(web.DHCANOPCom).ConvertToTimeH(time,$H)
	//s time=$zt(time,2)
	//恢复室评分时间跳过以下特殊处理  YuanLin 20170915
	i ($l(value,"-")>=3&&(code'="PACU_StewardTime")) d
	.i $l(value," ")>1 s value=$zt($zth($p(value," ",2)),2)
	;i $l(value,":")>1 s value=$zt($zth(value),2)
		
	s retStr=value_$c(3)_prevalue_$c(3)_userId_$c(3)_date_$c(3)_time_$c(3)_note
	q retStr
}

/// w ##Class(web.DHCANOPArrangeExtend).JudgeExtend("aa")
ClassMethod JudgeExtend(code) As %String
{
	q:code="" "-1"
	//^DHCANC("OPArrangeExtend")
	s rowId="-1"
	s rowId=$o(^DHCANC("OPArrangeExtend",0,"Code",code,""))
	i rowId="" s rowId="-1"
	q rowId
}

/// d ##class(%ResultSet).RunQuery("web.DHCANOPArrangeExtend","FindArrangeExtendValue","187","PA")
Query FindArrangeExtendValue(opaId, extendItemType = "") As %Query(ROWSPEC = "Id,ArrangeId,ExtendItemId,ExtendItemCode,ExtendItemDesc,ExtendItemType,Value,UpdateDT,UserId,UserDesc")
{
}

ClassMethod FindArrangeExtendValueExecute(ByRef qHandle As %Binary, opaId, extendItemType = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	set extendValueId=0
	for
	{
		set extendValueId=$order(^DHCANOPArrangeExtend(0,"OPA",opaId,extendValueId))
		quit:(extendValueId="")
		set extendValueInfo=^DHCANOPArrangeExtend(extendValueId)
		set extendItemCode=$list(extendValueInfo,5)
		set extendItemId=$order(^DHCANC("OPArrangeExtend",0,"Code",extendItemCode,0))
		continue:(+extendItemId<=0)
		set thisItemType=$list(^DHCANC("OPArrangeExtend",extendItemId),3)
		continue:(extendItemType'="")&(thisItemType'=extendItemType)
		set extendItemDesc=$list(^DHCANC("OPArrangeExtend",extendItemId),2)
		set extendValue=$list(extendValueInfo,6)
		set updateDate=$list(extendValueInfo,3)
		set updateTime=$list(extendValueInfo,4)
		set updateDT=##class(web.DHCClinicCom).ConvertToDateTime(updateDate,updateTime)
		set userId=$list(extendValueInfo,2)
		set userDesc=""
		if (+userId>0)
		{
			set userDesc=$piece($get(^SSU(+userId)),"^",2)	
		}
		
		do OutputExtendValue
	}
	
	Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputExtendValue
 set Data=$lb(extendValueId,opaId,extendItemId,extendItemCode,extendItemDesc,thisItemType,extendValue,updateDT,userId,userDesc)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod FindArrangeExtendValueFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindArrangeExtendValueExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
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

ClassMethod FindArrangeExtendValueClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindArrangeExtendValueExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

}
