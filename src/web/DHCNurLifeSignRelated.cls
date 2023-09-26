Class web.DHCNurLifeSignRelated Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 
/// 病区下拉框  
/// 
Query SearchWardCode(ward = "") As %Query(ROWSPEC = "ctlocDesc,CtLocDr")
{
}

ClassMethod SearchWardCodeExecute(ByRef qHandle As %Binary, ward = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1 
 	s ward=$TR($ZConvert(ward,"U")," ","")
 	s rw="" f  s rw=$O(^CTLOC(rw)) q:rw=""  d
    .s CtLocDr=rw
    .s ctlocDesc=$P(^CTLOC(rw),"^",2)
    .q:ctlocDesc=""
    .q:ctlocDesc["停用"
    .s bm=$P(^CTLOC(rw),"^",43)
    .q:(ctlocDesc'[ward)&&(bm'[ward)&&(ward'="")
    .s LocType=$P(^CTLOC(rw),"^",13)
    .q:LocType'="W"
    .d OutputRow8
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(ctlocDesc,CtLocDr)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod SearchWardCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchWardCodeExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SearchWardCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchWardCodeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 
/// 模板下拉框  
/// w ##class(%ResultSet).RunQuery("web.DHCNurLifeSignRelated","SearchTemplates",27,"压疮")
Query SearchTemplates(LocId = "") As %Query(ROWSPEC = "TempDesc,TempCode")
{
}

ClassMethod SearchTemplatesExecute(ByRef qHandle As %Binary, LocId = "", RecDesc = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1 
 	s DepModelSort=""
	i LocId'="" d
	.s DepModelStr=$G(^DHCNurDepModelSet(LocId))
	.f ii=1:1:$L(DepModelStr) d
	..s DepModel=$P(DepModelStr,"^",ii)
	..q:DepModel=""
	..s ModelKey=$P(DepModel,"|",1)
	..s ModelName=$P(DepModel,"|",2)
	..s ModelSort=$P(DepModel,"|",3)
	..s DepModel(ModelKey)=ModelName_"^"_ModelSort
	..s DepModelSort(ModelSort,ModelKey)=ModelName_"^"_ModelSort
    
 	i (LocId'="")&&(LocId'="9000")  d //按科室查询
 	.s rw="" f  s rw=$o(DepModelSort(rw)) q:rw=""  d //查询科室的
 	..s id="" f  s id=$o(DepModelSort(rw,id)) q:id=""  d
 	...s itm=DepModelSort(rw,id)
 	...s name=$p(itm,"^")
 	...s allshow=0,select=1,ifshow=1,gitem=1
 	...s gitem=##class(User.DHCNURMenuSub).getgnamebycodenew(id) //获取根目录名
 	...q:(name'[RecDesc)&&(RecDesc'="")
 	...s TempDesc=name_"("_id_")",TempCode=id
 	...d OutputRow88
 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow88
	set Data=$lb(TempDesc,TempCode)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod SearchTemplatesFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchTemplatesExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SearchTemplatesClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchTemplatesExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 
/// 模板表头项目 
/// w ##class(%ResultSet).RunQuery("web.DHCNurLifeSignRelated","SearchTemplateColumns","DHCNURANHUI6")
Query SearchTemplateColumns(EmrCode = "") As %Query(ROWSPEC = "ColumnDesc,ColumnItem")
{
}

ClassMethod SearchTemplateColumnsExecute(ByRef qHandle As %Binary, EmrCode = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1 
 	if EmrCode="" 
 	{
	  Set qHandle=$lb(0,repid,0)
	  Quit $$$OK	
	 }
	s Data="" 
 	s str=##class(NurEmr.NurEmrSub).GetKCode(EmrCode)
    if str="" s str=##class(NurEmr.NurEmrSub).getData(EmrCode)
    if str'=""   
	   {
		S ITM=##CLASS(NurEmr.NurEmrSub).%OpenId(str)
		s Data=ITM.EmrSubData
		s title=ITM.EmrSubDesc
		d Data.Rewind()
		s Reader=##class(web.DHCNUREMR).GetReader(EmrCode,Data)
		while Reader.Read()
		{
			if Reader.Name["T"
	    	{
		    	s headstr=""
		    	if Reader.MoveToAttributeName("Head") s headstr=Reader.Value
		    	if (headstr'="")
		    	{
			    	s len=$L(headstr,"|")
			    	f i=1:1:len d
			    	.s t1=$P(headstr,"|",i)
			    	.s tlen=$L(t1,"^")
			    	.s ColumnItem=$P(t1,"^",tlen-1)
			    	.s ColumnDesc=$P(t1,"^",tlen)_"("_ColumnItem_")"
			    	.q:(ColumnDesc="")!(ColumnItem="")
			    	.q:(ColumnItem="CareDate")!(ColumnItem="CareTime")!(ColumnItem="rw")!(ColumnItem="par")!(ColumnItem="User")
			    	.do Output88
			    }
		    }
		}
	   }
	
	
 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Output88
	set Data=$lb(ColumnDesc,ColumnItem)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod SearchTemplateColumnsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchTemplateColumnsExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SearchTemplateColumnsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchTemplateColumnsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 
/// 录入界面条件列表搜索  
/// w ##class(%ResultSet).RunQuery("web.DHCNurLifeSignRelated","GetConditionsRecComm","1")
Query GetConditionsRecComm(par = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod GetConditionsRecCommExecute(ByRef qHandle As %Binary, par = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1 
 	if par=""  Set qHandle=$lb(0,repid,0)	Quit $$$OK
 	s subrw=""
 	f  s subrw=$O(^Nur.DHCNurLifeSignRelatedD(par,"ChildDHCNurLifeSignRelatedSub",subrw)) q:subrw=""  d
 	.s rowid=par_"||"_subrw
 	.s subobj=##class(Nur.DHCNurLifeSignRelatedSub).%OpenId(rowid)
 	.q:subobj=""
 	.s BaseItem2=subobj.DHCNurLifeSignBaseItemDesc
 	.s BaseVal2=subobj.DHCNurLifeSignBaseVal
 	.s Conditions2=subobj.DHCNurLifeSignConditions
 	.s RelateItem2=subobj.DHCNurLifeSignRelatedItemDesc
 	.s RelateVal2=subobj.DHCNurLifeSignRelatedVal
 	.s BaseItemId=subobj.DHCNurLifeSignBaseItem
 	.s RelateItemId=subobj.DHCNurLifeSignRelatedItem
 	.s ret="BaseItem2|"_BaseItem2_"^"_"BaseVal2|"_BaseVal2_"^"_"Conditions2|"_Conditions2_"^"_"rw|"_subrw
 	.s ret=ret_"^"_"RelateItem2|"_RelateItem2_"^"_"RelateVal2|"_RelateVal2_"^"_"BaseItemId|"_BaseItemId_"^"_"RelateItemId|"_RelateItemId
 	.do OutputListRow
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputListRow
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetConditionsRecCommFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetConditionsRecCommExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetConditionsRecCommClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetConditionsRecCommExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 
/// 配置列表搜索  
/// w ##class(%ResultSet).RunQuery("web.DHCNurLifeSignRelated","GetLifeSignRelated","")
Query GetLifeSignRelated(parr = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod GetLifeSignRelatedExecute(ByRef qHandle As %Binary, parr = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1 
 	s IfCancelStatus=parr
 	s rw=""
 	f  s rw=$O(^Nur.DHCNurLifeSignRelatedD(rw)) q:rw=""  d
 	.s obj=##class(Nur.DHCNurLifeSignRelated).%OpenId(rw)
 	.q:obj=""
 	.s EmrDesc=obj.DHCNurLifeSignEmrDesc
 	.s EmrCode=obj.DHCNurLifeSignEmrCode
 	.s LocId=obj.DHCNurLifeSignLocId
 	.i LocId'="" s LocDesc=$P($g(^CTLOC(LocId)),"^",2)
 	.e  s LocDesc=""
 	.s Status=obj.DHCNurLifeSignStatus
 	.q:(IfCancelStatus'="")&(IfCancelStatus'=Status)
 	.s par=rw
 	.s ret="EmrDesc|"_EmrDesc_"^"_"EmrCode|"_EmrCode_"^"_"Status|"_Status_"^"_"par|"_par
 	.s ret=ret_"^"_"LocDesc|"_LocDesc_"^"_"LocId|"_LocId
 	.do OutputLifeSignRelated
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputLifeSignRelated
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetLifeSignRelatedFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLifeSignRelatedExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetLifeSignRelatedClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLifeSignRelatedExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// w ##class(web.DHCNurLifeSignRelated).getSetting("27^DHCNURANHUI6^Item3^35")
ClassMethod getSetting(parr As %String) As %String
{
	s LocId=$P(parr,"^",1)
	s RecType=$P(parr,"^",2)
	s BaseItem=$P(parr,"^",3)
	s BaseVal=$P(parr,"^",4)
	q:(LocId="")!(RecType="")!(BaseItem="") ""
	s RecType=$ZCvt(RecType,"U")
	s ret=""
	s par=$O(^Nur.DHCNurLifeSignRelatedI("LocCode"," "_LocId," "_RecType,""),-1)
	q:par="" ""
	s subrw=""
 	f  s subrw=$O(^Nur.DHCNurLifeSignRelatedD(par,"ChildDHCNurLifeSignRelatedSub",subrw)) q:subrw=""  d
 	.s rowid=par_"||"_subrw
 	.s subobj=##class(Nur.DHCNurLifeSignRelatedSub).%OpenId(rowid)
 	.q:subobj=""
 	.s BaseItemId=subobj.DHCNurLifeSignBaseItem
 	.q:(BaseItemId'=BaseItem)
 	.s BaseVal2=subobj.DHCNurLifeSignBaseVal
 	.s RelateVal2=subobj.DHCNurLifeSignRelatedVal
 	.s RelateItemId=subobj.DHCNurLifeSignRelatedItem
 	.s Conditions2=subobj.DHCNurLifeSignConditions
 	.s Conditions=""
 	.i Conditions2="大于" d
 	..i BaseVal>BaseVal2 s ret=RelateItemId_"|"_RelateVal2
 	.i Conditions2="等于" d
 	..i BaseVal=BaseVal2 d
 	...i ret="" s ret=RelateItemId_"|"_RelateVal2
 	...e  s ret=ret_"^"_RelateItemId_"|"_RelateVal2
 	.i Conditions2="小于" d
 	..i BaseVal<BaseVal2 d
 	...i ret="" s ret=RelateItemId_"|"_RelateVal2
 	...e  s ret=ret_"^"_RelateItemId_"|"_RelateVal2
 	.i Conditions2="不等于" d
 	..i BaseVal'=BaseVal2 d
 	...i ret="" s ret=RelateItemId_"|"_RelateVal2
 	...e  s ret=ret_"^"_RelateItemId_"|"_RelateVal2
 	.i Conditions2="包含" d
 	..i BaseVal[BaseVal2 d
 	...i ret="" s ret=RelateItemId_"|"_RelateVal2
 	...e  s ret=ret_"^"_RelateItemId_"|"_RelateVal2
 	.i ret="" s ret=RelateItemId_"|"
 	q ret
}

}
