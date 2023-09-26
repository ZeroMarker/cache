Import SQLUser

Class web.DHCRisExamScheSet Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 查询名称：QueryExamSortGroup
/// 功能：查询检查项目组
/// 参数：itmMastDr^itemcatDR
/// 返回： 
/// 作者：wangfeng
/// 日期：2014-12-24
/// d ##class(%ResultSet).RunQuery("web.DHCRisExamScheSet","QueryExamSortGroup","")
Query QueryExamSortGroup(param As %String) As %Query(ROWSPEC = "Rowid:%String,GroupName:%String,GroupCode:%String,GroupDesc:%String")
{
}

ClassMethod QueryExamSortGroupExecute(ByRef qHandle As %Binary, param As %String) As %Status
{
 s ind=1
 Set repid=$I(^CacheTemp)
 s ^DHCRisTemp("QueryExamSortGroup")=param
 s Rowid="" f  s Rowid=$o(^User.DHCRBExamSortGroupD(Rowid)) q:(Rowid="")  d
 .s (GroupCode,GroupName,GroupDesc)=""
 .s GroupCode=$lg(^User.DHCRBExamSortGroupD(Rowid),2)
 .s GroupDesc=$lg(^User.DHCRBExamSortGroupD(Rowid),3)
 .s GroupName=$lg(^User.DHCRBExamSortGroupD(Rowid),4)
 .Do QueryExamSortGroup
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK 
QueryExamSortGroup
 set Data=$lb(Rowid,GroupName,GroupCode,GroupDesc)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1 
 quit
}

ClassMethod QueryExamSortGroupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryExamSortGroupExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
	 // if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod QueryExamSortGroupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryExamSortGroupExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

// d ##class(web.DHCRisExamScheSet).OperatetExamSortGroup(^DHCRisTemp("InsertExamGroup"))

ClassMethod OperatetExamSortGroup(Info As %String, Code As %String) As %String
{
 s ^DHCRisTemp("InsertExamGroup")=Info_"*"_Code
 s SQLCODE="100"
 s rowid=$p(Info,"^",1)
 s name=$p(Info,"^",2)
 s code=$p(Info,"^",3)
 s desc=$p(Info,"^",4)
 
 
 if ( Code = "A")
 {
 	if (code'="")
 	{
 		&sql(insert into DHCRB_ExamSortGroup(GroupCode,GroupDesc,GroupName)values 
 		          (:code,:desc,:name))
 	}
 }
 elseif( Code= "M")
 {
	 if (rowid '="")
	 {
		if (code'="")
 	{
 		&sql(update DHCRB_ExamSortGroup(GroupCode,GroupDesc,GroupName)values 
 		          (:code,:desc,:name) where ID=:rowid)
 	}
	 }
	 
 }
 elseif (Code= "D")
 {
	 //查询是否有用的这个组的
	 if (rowid '="")
	 {
		 &sql(delete from DHCRB_ExamSortGroup where ID=:rowid)
	 }
	 
 }
 q SQLCODE
}

/// 查询名称：QueryExamSortProperty
/// 功能：
/// 参数：
/// 返回： 
/// 作者：wangfeng
/// 日期：2014-12-24
/// d ##class(%ResultSet).RunQuery("web.DHCRisExamScheSet","QueryExamSortProperty","")
Query QueryExamSortProperty(OrdSubCatId As %String, InputOrdName As %String = "", GroupDrCondition As %String = "") As %Query(ROWSPEC = "PropertyID:%String,ItmMastRowid:%String,ItemDesc:%String,ExamSortGroupID:%String,ExamSortGroupName:%String,IsSort:%String,StartDate:%String,EndDate:%String,ExamTime:%String,IsAutoSendAppbill:%String")
{
}

ClassMethod QueryExamSortPropertyExecute(ByRef qHandle As %Binary, OrdSubCatId As %String, InputOrdName As %String = "", GroupDrCondition As %String = "") As %Status
{
 s ind=1
 Set repid=$I(^CacheTemp)
 s ^DHCRisTemp("QueryExamSortProperty")=OrdSubCatId_"^"_InputOrdName_"^"_GroupDrCondition
 i OrdSubCatId'="" d
 .s Subscrip="" f  s Subscrip=$O(^ARCIM(0,"ARCIC_DR",OrdSubCatId,Subscrip)) q:(Subscrip="")  d
 ..s Version="" f  s Version=$o(^ARCIM(0,"ARCIC_DR",OrdSubCatId,Subscrip,Version)) q:(Version="")  d
 ...s ItemRowid=Subscrip_"||"_Version
 ...s ItemDesc=$p(^ARCIM(Subscrip,Version,1),"^",2)
 ...s StarDay=$p(^ARCIM(Subscrip,Version,1),"^",13)
 ...s StarDate=$p(StarDay,"Z",1)
 ...Q:(StarDate>CurrentDate)
 ...s EffDateTo=$p(^ARCIM(Subscrip,Version,7),"^",1)
 ...q:((EffDateTo'="")&&(EffDateTo<CurrentDate))   ;;判断医嘱截止日期是否填了，有截止日期的也需要过滤
 ...;s itemCode=$p(^ARCIM(Subscrip,Version,1),"^",1)
 ...;w !,ItemDesc_"*"_itemCode
 ...q:(InputOrdName'="")&&(ItemDesc'[InputOrdName) 
 ...q:($p(^ARCIM(Subscrip,Version,7),"^",6)'="S")
 ...Do QueryExamSortPropertyByItmCat
 e  i GroupDrCondition'="" d
 .s examPropertyID=0 f  s examPropertyID=$o(^User.DHCRBExamSortPropertyI("SortGroupIndex",GroupDrCondition,examPropertyID)) q:(examPropertyID="")  d
 ..s (ItemRowid,ItemDesc)=""
 ..s ItemRowid=$lg(^User.DHCRBExamSortPropertyD(examPropertyID),5)
 ..s ItemDesc=$p(^ARCIM($p(ItemRowid,"||",1),$p(ItemRowid,"||",2),1),"^",2)
 ..q:(InputOrdName'="")&&(ItemDesc'[InputOrdName)
 ..Do QueryExamSortProperty
 e  d
 .s examPropertyID=0 f  s examPropertyID=$o(^User.DHCRBExamSortPropertyD(examPropertyID)) q:(examPropertyID="")  d
 ..s (ItemRowid,ItemDesc)=""
 ..s ItemRowid=$lg(^User.DHCRBExamSortPropertyD(examPropertyID),5)
 ..s ItemDesc=$p(^ARCIM($p(ItemRowid,"||",1),$p(ItemRowid,"||",2),1),"^",2)
 ..q:(InputOrdName'="")&&(ItemDesc'[InputOrdName)
 ..Do QueryExamSortProperty
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK 
QueryExamSortPropertyByItmCat
 s (ExamSortGroupID,ExamSortGroupName,isSort,StartDate,EndDate,ExamTime,IsAutoSendAppbill)=""
 s examSortPropertyID=""
 s examSortPropertyID=$o(^User.DHCRBExamSortPropertyI("ItmMastIndex",ItemRowid,examSortPropertyID))
 if (examSortPropertyID'="")
 {
	 s ExamSortGroupID=$lg(^User.DHCRBExamSortPropertyD(examSortPropertyID),6)
	 if (ExamSortGroupID'="")
	 {
		 s ExamSortGroupName=$lg($g(^User.DHCRBExamSortGroupD(ExamSortGroupID)),4)
	 }
	 s isSort=$lg(^User.DHCRBExamSortPropertyD(examSortPropertyID),4)
	 s StartDate=$lg(^User.DHCRBExamSortPropertyD(examSortPropertyID),7)
	 i StartDate'="" s StartDate=$zd(StartDate,3)
	 s EndDate=$lg(^User.DHCRBExamSortPropertyD(examSortPropertyID),2)
	 i EndDate'="" s EndDate=$zd(EndDate,3)
	 s ExamTime=$lg(^User.DHCRBExamSortPropertyD(examSortPropertyID),3)
	 s IsAutoSendAppbill=$lg(^User.DHCRBExamSortPropertyD(examSortPropertyID),8)
 }
 set Data=$lb(examSortPropertyID,ItemRowid,ItemDesc,ExamSortGroupID,ExamSortGroupName,isSort,StartDate,EndDate,ExamTime,IsAutoSendAppbill)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1 
 quit
 
QueryExamSortProperty
 s (ExamSortGroupID,ExamSortGroupName,isSort,StartDate,EndDate,ExamTime,IsAutoSendAppbill)=""
 s ExamSortGroupID=$lg(^User.DHCRBExamSortPropertyD(examPropertyID),6)
 if (ExamSortGroupID'="")
 {
	s ExamSortGroupName=$lg($g(^User.DHCRBExamSortGroupD(ExamSortGroupID)),4)
 }
 s isSort=$lg(^User.DHCRBExamSortPropertyD(examPropertyID),4)
 s StartDate=$lg(^User.DHCRBExamSortPropertyD(examPropertyID),7)
 i StartDate'="" s StartDate=$zd(StartDate,3)
 s EndDate=$lg(^User.DHCRBExamSortPropertyD(examPropertyID),2)
 i EndDate'="" s EndDate=$zd(EndDate,3)
 s ExamTime=$lg(^User.DHCRBExamSortPropertyD(examPropertyID),3)
 s IsAutoSendAppbill=$lg(^User.DHCRBExamSortPropertyD(examPropertyID),8)
 
 set Data=$lb(examPropertyID,ItemRowid,ItemDesc,ExamSortGroupID,ExamSortGroupName,isSort,StartDate,EndDate,ExamTime,IsAutoSendAppbill)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1 
 quit
}

ClassMethod QueryExamSortPropertyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryExamSortPropertyExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
	 // if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod QueryExamSortPropertyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryExamSortPropertyExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

// d ##class(web.DHCRisExamScheSet).OperatetExamSortProperty()

ClassMethod OperatetExamSortProperty(Info As %String, Code As %String) As %String
{
 s ^DHCRisTemp("OperatetExamSortProperty")=Info_"*"_Code
 s SQLCODE="100"
 s propertyID=$p(Info,"^",1)
 s itmMastDr=$p(Info,"^",2)
 s sortGroupId=$p(Info,"^",3)
 s isSort=$p(Info,"^",4)
 s examTime=$p(Info,"^",5)
 s startDate=$p(Info,"^",6)
 s endDate=$p(Info,"^",7)
 s isAuto=$p(Info,"^",8)
 
 if (startDate '="") s startDate=##class(websys.Conversions).DateHtmlToLogical(startDate)
 if (endDate '="") s endDate=##class(websys.Conversions).DateHtmlToLogical(endDate)
 /*
 if ( Code = "A")
 {
 	if (code'="")
 	{
 		&sql(insert into DHCRB_ExamSortGroup(GroupCode,GroupDesc,GroupName)values 
 		          (:code,:desc,:name))
 	}
 }
 */
 if ( Code= "M")
 {
	 if (propertyID ="")
	 {
		&sql(insert into DHCRB_ExamSortProperty(ItmMastDr,ExamSortGroupId,IsSort,ExamTime,StartDate,EndDate,IsAutoSendAppBill) values
			(:itmMastDr,:sortGroupId,:isSort,:examTime,:startDate,:endDate,:isAuto))
	 }
	 else
	 {
		 
 		&sql(update DHCRB_ExamSortProperty(ExamSortGroupId,IsSort,ExamTime,StartDate,EndDate,IsAutoSendAppBill) values
			(:sortGroupId,:isSort,:examTime,:startDate,:endDate,:isAuto) where ItmMastDr=:itmMastDr)
 		
	 }
	 
 }
 elseif (Code= "D")
 {
	 //查询是否有用的这个组的
	 if (propertyID '="")
	 {
		 &sql(delete from DHCRB_ExamSortProperty  where ItmMastDr=:itmMastDr)
	 }
	 
 }
 q SQLCODE
}

/// 查询名称：QueryExamRejectItem
/// 功能：查询检查项目组
/// 参数：itmMastDr^itemcatDR
/// 返回： 
/// 作者：wangfeng
/// 日期：2014-12-24
/// d ##class(%ResultSet).RunQuery("web.DHCRisExamScheSet","QueryExamRejectItem","")
Query QueryExamRejectItem(InItmMastDR As %String) As %Query(ROWSPEC = "RejectItemID:%String,ExamGroupID:%String,ExamGroupName:%String,ItmMastDr:%String,ItmMastDesc:%String,Time:%String,TimeUnit:%String")
{
}

ClassMethod QueryExamRejectItemExecute(ByRef qHandle As %Binary, InItmMastDR As %String) As %Status
{
 s ind=1
 Set repid=$I(^CacheTemp)
 s ^DHCRisTemp("QueryExamRejectItem")=InItmMastDR
 i InItmMastDR'="" d
 .s RejectItemDr="" f  s RejectItemDr=$o(^User.DHCRBExamRejectItemI("ItmMastIndex"," "_InItmMastDR,RejectItemDr)) q:(RejectItemDr="")  d
 ..s (itmMastDr,itmMastDesc,examGroupID,examGroupName,rejectTime,timeUnit)=""
 ..s examGroupID=$lg(^User.DHCRBExamRejectItemD(RejectItemDr),2)
 ..if examGroupID'="" d
 ...s examGroupName=$p($g(^DHCRBExamGroup(examGroupID)),"^",1)
 ..s itmMastDr=$lg(^User.DHCRBExamRejectItemD(RejectItemDr),4)
 ..i itmMastDr'="" d
 ...s itmMastDesc=$p(^ARCIM($p(itmMastDr,"||",1),$p(itmMastDr,"||",2),1),"^",2)
 ..s rejectTime=$lg(^User.DHCRBExamRejectItemD(RejectItemDr),5)
 ..s timeUnit=$lg(^User.DHCRBExamRejectItemD(RejectItemDr),6)
 ..Do QueryExamRejectItem
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK 
QueryExamRejectItem
 
 set Data=$lb(RejectItemDr,examGroupID,examGroupName,itmMastDr,itmMastDesc,rejectTime,timeUnit)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1 
 quit
}

ClassMethod QueryExamRejectItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryExamRejectItemExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
	 // if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod QueryExamRejectItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryExamRejectItemExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// w ##class(web.DHCRisExamScheSet).OperatetExamRejectItem("^25735||1^11^^2^天","A")
ClassMethod OperatetExamRejectItem(Info As %String, Code As %String) As %String
{
 s ^DHCRisTemp("OperatetExamRejectItem")=Info_"*"_Code
 s SQLCODE="100"
 s rejectItemID=$p(Info,"^",1)
 s inItemMastDr=$p(Info,"^",2)
 s examGroupID=$p(Info,"^",3)
 s rejectItmMastDr=$p(Info,"^",4)
 s rejectTime=$p(Info,"^",5)
 s timeUnit=$p(Info,"^",6)

 if ( Code = "A")
 {
 	if (inItemMastDr'="")
 	{
 		&sql(insert into DHCRB_ExamRejectItem(ItmMastDR,ExamGroupID,RejectItmMastDR,RejectTime,TimeUnit )values 
 		          (:inItemMastDr,:examGroupID,:rejectItmMastDr,:rejectTime,:timeUnit))
 	}
 }
 elseif( Code= "M")
 {
	 if (rejectItemID'="")
	 {
		 
 		&sql(update DHCRB_ExamRejectItem(ItmMastDR,ExamGroupID,RejectItmMastDR,RejectTime,TimeUnit )values 
 		          (:inItemMastDr,:examGroupID,:rejectItmMastDr,:rejectTime,:timeUnit) where ID=:rejectItemID)
 		
	 }
	 
 }
 elseif (Code= "D")
 {
	 //查询是否有用的这个组的
	 if (rejectItemID '="")
	 {
		 &sql(delete from DHCRB_ExamRejectItem  where ID=:rejectItemID)
	 }
	 
 }
 q SQLCODE
}

/// do ##class(web.DHCRisExamScheSet).GetTimeUnit()
ClassMethod GetTimeUnit() As %String
{
	s ret="天"_$c(1)_"天"_"^"_"小时"_$c(1)_"小时"
	q ret
}

/// 查询名称：QueryExamPrepositionItem
/// 功能：查询检查项目组
/// 参数：itmMastDr^itemcatDR
/// 返回： 
/// 作者：wangfeng
/// 日期：2014-12-24
/// d ##class(%ResultSet).RunQuery("web.DHCRisExamScheSet","QueryExamPrepositionItem","")
Query QueryExamPrepositionItem(InItmMastDR As %String) As %Query(ROWSPEC = "PrepositionItemID:%String,ExamGroupID:%String,ExamGroupName:%String,ItmMastDr:%String,ItmMastDesc:%String,Time:%String,TimeUnit:%String")
{
}

ClassMethod QueryExamPrepositionItemExecute(ByRef qHandle As %Binary, InItmMastDR As %String) As %Status
{
 s ind=1
 Set repid=$I(^CacheTemp)
 s ^DHCRisTemp("QueryExamPrepositionItem")=InItmMastDR
 i InItmMastDR'="" d
 .s PrepositionItemDr="" f  s PrepositionItemDr=$o(^User.DHCRBExamPrepositionItemI("ItmMastIndex"," "_InItmMastDR,PrepositionItemDr)) q:(PrepositionItemDr="")  d
 ..s (itmMastDr,itmMastDesc,examGroupID,examGroupName,prepositionTime,timeUnit)=""
 ..s examGroupID=$lg(^User.DHCRBExamPrepositionItemD(PrepositionItemDr),2)
 ..if examGroupID'="" d
 ...s examGroupName=$p($g(^DHCRBExamGroup(examGroupID)),"^",1)
 ..s itmMastDr=$lg(^User.DHCRBExamPrepositionItemD(PrepositionItemDr),5)
 ..i itmMastDr'="" d
 ...s itmMastDesc=$p(^ARCIM($p(itmMastDr,"||",1),$p(itmMastDr,"||",2),1),"^",2)
 ..s prepositionTime=$lg(^User.DHCRBExamPrepositionItemD(PrepositionItemDr),4)
 ..s timeUnit=$lg(^User.DHCRBExamPrepositionItemD(PrepositionItemDr),6)
 ..Do QueryExamPrepositionItem
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK 
QueryExamPrepositionItem
 
 set Data=$lb(PrepositionItemDr,examGroupID,examGroupName,itmMastDr,itmMastDesc,prepositionTime,timeUnit)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1 
 quit
}

ClassMethod QueryExamPrepositionItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryExamPrepositionItemExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
	 // if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod QueryExamPrepositionItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryExamPrepositionItemExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

// d ##class(web.DHCRisExamScheSet).OperatetExamRejectItem()

ClassMethod OperatetExamPrepositionItem(Info As %String, Code As %String) As %String
{
 s ^DHCRisTemp("OperatetExamPrepositionItem")=Info_"*"_Code
 s SQLCODE="100"
 s prepositionItemID=$p(Info,"^",1)
 s inItemMastDr=$p(Info,"^",2)
 s examGroupID=$p(Info,"^",3)
 s prepositionItmMastDr=$p(Info,"^",4)
 s prepositionTime=$p(Info,"^",5)
 s timeUnit=$p(Info,"^",6)

 if ( Code = "A")
 {
 	if (inItemMastDr'="")
 	{
 		&sql(insert into DHCRB_ExamPrepositionItem(ItmMastDR,ExamGroupID,PrepositonItmMastDR,PreTime,TimeUnit )values 
 		          (:inItemMastDr,:examGroupID,:prepositionItmMastDr,:prepositionTime,:timeUnit))
 	}
 }
 elseif( Code= "M")
 {
	 if (prepositionItemID'="")
	 {
		 
 		&sql(update DHCRB_ExamPrepositionItem(ItmMastDR,ExamGroupID,PrepositonItmMastDR,PreTime,TimeUnit )values 
 		          (:inItemMastDr,:examGroupID,:prepositionItmMastDr,:prepositionTime,:timeUnit) where ID=:prepositionItemID)
 		
	 }
	 
 }
 elseif (Code= "D")
 {
	 //查询是否有用的这个组的
	 if (prepositionItemID '="")
	 {
		 &sql(delete from DHCRB_ExamPrepositionItem  where ID=:prepositionItemID)
	 }
	 
 }
 q SQLCODE
}

// d ##class(web.DHCRisExamScheSet).InsertExamSortProperty()

ClassMethod InsertExamSortProperty(Info As %String) As %String
{
 s ^DHCRisTemp("InsertExamSortProperty")=Info
 s SQLCODE="100"
 s arcItemCode=$p(Info,"^",1)
 s arcItemDesc=$p(Info,"^",2)
 s sortGroupCode=$p(Info,"^",3)
 s isSort=$p(Info,"^",4)
 s examTime=$p(Info,"^",5)
 s startDate=$p(Info,"^",6)
 s endDate=$p(Info,"^",7)
 s isAuto=$p(Info,"^",8)
 
 if (startDate '="") s startDate=$zdh(startDate,3)
 if (endDate '="") s endDate=$zdh(endDate,3)
 
 s (SubscriptID,VersionID,arcItemRowid)=""
 s (sortGroupId,sortPropertyId)=0
 i arcItemCode'="" 
 {
     s SubscriptID=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(arcItemCode),0))
     i SubscriptID'="" 
     {
     	s VersionID=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(arcItemCode),SubscriptID,0))
     	i VersionID'="" s arcItemRowid=SubscriptID_"||"_VersionID
     }
 }
 
 if (sortGroupCode'="")
 {
	 s sortGroupId=0
	 s sortGroupId=$o(^User.DHCRBExamSortGroupI("CodeIndex",$$ALPHAUP^SSUTIL4(sortGroupCode),sortGroupId))
 }
 
 if (arcItemRowid'="") 
 {
 	s sortPropertyId=$o(^User.DHCRBExamSortPropertyI("ItmMastIndex",arcItemRowid,sortPropertyId))
 	if ( sortPropertyId'="")
 	{
	 	&sql(update DHCRB_ExamSortProperty(ItmMastDr,ExamSortGroupId,IsSort,ExamTime,StartDate,EndDate,IsAutoSendAppBill) values
			(:arcItemRowid,:sortGroupId,:isSort,:examTime,:startDate,:endDate,:isAuto) where ID=:sortPropertyId)
 	}
 	else
 	{
	 	&sql(insert into DHCRB_ExamSortProperty(ItmMastDr,ExamSortGroupId,IsSort,ExamTime,StartDate,EndDate,IsAutoSendAppBill) values
			(:arcItemRowid,:sortGroupId,:isSort,:examTime,:startDate,:endDate,:isAuto))
 	}

 }

 q SQLCODE
}

// d ##class(web.DHCRisExamScheSet).IsCanDeleGroup("01")

ClassMethod IsCanDeleGroup(IntoExamGroupID) As %String
{
	s ret="N"
	q:(IntoExamGroupID="") "Y" 
	s num=0
	&sql(select count(*) into :num from DHCRB_ExamSortProperty WHERE ExamSortGroupId=:IntoExamGroupID)
	if num'=0 s ret="Y"
	q ret
}

}
