Class web.DHCBldAppFormTake Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

Query QueryTakeList(AppNo As %String) As %Query(ROWSPEC = "CreateDT :%String,CreateUser:%String,TakeNo:%String,Location:%String, TakeInfo:%String,Remark:%String,PrintDT:%String,PrintUser:%String,ABO:%String,RH:%String,Name:%String,Debtor:%String")
{
}

ClassMethod QueryTakeListExecute(ByRef qHandle As %Binary, AppNo As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s Debtor=$p($g(^DHCBLDAPPFORM(AppNo,"P")),"\",15)
	s Name=$p($g(^DHCBLDAPPFORM(AppNo,"P")),"\",2)
	s AppABO=$p($g(^DHCBLDAPPFORM(AppNo,"P")),"\",26)
	s AppRH=$p($g(^DHCBLDAPPFORM(AppNo,"P")),"\",27)
    s curWardDr=$p($g(^DHCBLDAPPFORM(AppNo,"P")),"\",13)
    i $l(curWardDr) S patWardDesc=$P($g(^PAWARD(curWardDr)),"^",2)

    ///
    s TakeNo="" f  s TakeNo=$o(^DHCBldTakePack(0,"APPNO",AppNo,TakeNo)) q:TakeNo=""  d
    .s str=$g(^DHCBldTakePack(TakeNo))
    .i '$l(str) q
    .s Loc=$p(str,"\",2)
    .s Location=""
    .i $l(Loc),$d(^CTLOC(Loc)) s Location=$p(^CTLOC(Loc),"^",2)
    .s Location=$g(patWardDesc)
    .S:Location["-" Location=$P(Location,"-",2)
    .s CreateDate=$p(str,"\",3)
    .s CreateTime=$p(str,"\",4)
    .s CrtUserId=$p(str,"\",5)
    .s PrnDate=$p(str,"\",6)
    .s PrnTime=$p(str,"\",7)
    .s PrnUserId=$p(str,"\",8)
    .s CreateDT=""
    .i $l(CreateDate) s CreateDate=$zd(CreateDate,3)
    .i $l(CreateTime) s CreateTime=$zt(CreateTime,2)
    .s CreateDT=CreateDate_" "_CreateTime
    .s CreateUser=""
    .i $l(CrtUserId),$d(^SSU("SSUSR",1,CrtUserId)) s CreateUser=$p(^SSU("SSUSR",1,CrtUserId),"^",2)
    .s PrnDT=""
    .i $l(PrnDate) s PrnDate=$zd(PrnDate,3)
    .i $l(PrnTime) s PrnTime=$zt(PrnTime,2)
    .s PrnDT=PrnDate_" "_PrnTime
    .s PrnUser=""
    .i $l(PrnUserId),$d(^SSU("SSUSR",1,PrnUserId)) s PrnUser=$p(^SSU("SSUSR",1,PrnUserId),"^",2)
    .s Remark=$p(str,"\",9)
    .s ABO=$p(str,"\",10)
    .i '$l(ABO) s ABO=AppABO
    .s RH=$p(str,"\",11)
    .i '$l(RH) s RH=AppRH
    .s OrdList=""
    .s OrdId="" f  s OrdId=$o(^DHCBldTakePack(TakeNo,"ORDER",OrdId)) q:OrdId=""  d
    ..s OrdDesc=$p(^DHCBldTakePack(TakeNo,"ORDER",OrdId),"\",1)
    ..s Amount=$p(^DHCBldTakePack(TakeNo,"ORDER",OrdId),"\",2)
    ..s Unit=$p(^DHCBldTakePack(TakeNo,"ORDER",OrdId),"\",3)
    ..s OrdList=OrdList_OrdDesc_" "_Amount_" "_Unit_";"
    .d OutputRow
    ///
	Set qHandle=$lb(0,repid,0)
	k TMP($zn,$j)
	Quit $$$OK
OutputRow
 	Set ^CacheTemp(repid,ind)=$lb(CreateDT,CreateUser,TakeNo,Location,OrdList,Remark,PrnDT,PrnUser,ABO,RH,Name,Debtor)
 	Set ind=ind+1
	quit
}

ClassMethod QueryTakeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryTakeListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryTakeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryTakeListExecute ]
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

Query QueryAppDetails(AppNo As %String, TakePackNo As %String) As %Query(ROWSPEC = "OrderRowID:%String,OrderDesc:%String,Unit:%String,AppValue:%String,Sequence:%String,Amount:%String")
{
}

ClassMethod QueryAppDetailsExecute(ByRef qHandle As %Binary, AppNo As %String, TakePackNo As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s AppNo=$g(AppNo),TakePackNo=$g(TakePackNo)
	s ^TMPAppDetails=AppNo_","_TakePackNo
	i '$l(AppNo) Set qHandle=$lb(0,repid,0) Quit $$$OK
	k ^TMP($zn,$j)
	i $l(TakePackNo) d GetDetailsByTakeNo(AppNo,TakePackNo)
	e  d GetDetailsByAppNo(AppNo)
    ///
    s num=0
    s seq="" f  s seq=$o(^TMP($zn,$j,"SEQ",seq)) q:seq=""  d
    .s ord="" f  s ord=$o(^TMP($zn,$j,"SEQ",seq,ord)) q:ord=""  d
    ..s str=^(ord)
    ..s OrdId=$p(ord,"-",1)
    ..s OrdSub=$p(ord,"-",2)
    ..s Desc=""
    ..s ArcimId=""
    ..i $l(OrdId),$l(OrdSub) s ArcimId=$p($g(^OEORD(OrdId,"I",OrdSub,1)),"^",2)
    ..i $l(ArcimId) s Desc=$p(^ARCIM($p(ArcimId,"||",1),$p(ArcimId,"||",2),1),"^",3)
    ..//s Desc=$p(str,"^",1)
    ..s Unit=$p(str,"^",2)
    ..s Value=$p(str,"^",3)
    ..s Amount=$p(str,"^",4)
    ..s num=num+1
    ..d OutputData
    k ^TMP($zn,$j)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
GetDetailsByAppNo(AppNo)
    ///^DHCBLDAPPFORM(20111107004,"ORDER","76937-34")
    s ord="" f  s ord=$o(^DHCBLDAPPFORM(AppNo,"ORDER",ord)) q:ord=""  d
    .s str=$g(^(ord))
    .i '$l(str) q
    .s Desc=$p(str,"\",2)
    .s AppValue=$p(str,"\",6)
    .s Unit=$p(str,"\",7)
    .s seq=$p(str,"\",12)
    .i '$l(seq) s seq=999
    .s ^TMP($zn,$j,"SEQ",seq,ord)=Desc_"^"_Unit_"^"_AppValue_"^"
    q
GetDetailsByTakeNo(AppNo,TakeNo)
	///^DHCBldTakePack(20111230001,"ORDER","50594-1413") = "申请B型全血\300\ml\1" 
	s ord="" f  s ord=$o(^DHCBldTakePack(TakeNo,"ORDER",ord)) q:ord=""  d
	.s str=$g(^(ord))
	.i '$l(str) 
	.s Desc=$p(str,"\",1)
	.s AppValue=$p(^DHCBLDAPPFORM(AppNo,"ORDER",ord),"\",6)
	.s Amount=$p(str,"\",2)
	.s Unit=$p(str,"\",3)
	.s seq=$p(str,"\",4)
	.i '$l(seq) s seq=999
	.s ^TMP($zn,$j,"SEQ",seq,ord)=Desc_"^"_Unit_"^"_AppValue_"^"_Amount
	q   	
OutputData
 	Set ^CacheTemp(repid,ind)=$lb(ord,Desc,Unit,Value,num,Amount)
 	Set ind=ind+1
	quit
}

ClassMethod QueryAppDetailsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryAppDetailsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryAppDetailsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryAppDetailsExecute ]
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

ClassMethod GetTakePackListBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", AppNo As %Library.String = "")
{
  s ^TMPPACKLIST(10)=AppNo
  q:AppNo="" ""
  s retStr=""
  s num=1
  s TakeNo="" f  s TakeNo=$o(^DHCBldTakePack(0,"APPNO",AppNo,TakeNo)) q:TakeNo=""  d
  .s str=$g(^DHCBldTakePack(TakeNo))
  .i '$l(str) q
  .s Loc=$p(str,"\",2)
  .s CreateDate=$p(str,"\",3)
  .s CreateTime=$p(str,"\",4)
  .s CreateDT=""
  .i $l(CreateDate) s CreateDate=$zd(CreateDate,3)
  .i $l(CreateTime) s CreateTime=$zt(CreateTime,2)
  .s CreateDT=CreateDate_" "_CreateTime
  .s Remark=$p(str,"\",9)
  .s OrdList=""
  .s OrdId="" f  s OrdId=$o(^DHCBldTakePack(TakeNo,"ORDER",OrdId)) q:OrdId=""  d
  ..s OrdDesc=$p(^DHCBldTakePack(TakeNo,"ORDER",OrdId),"\",1)
  ..s Amount=$p(^DHCBldTakePack(TakeNo,"ORDER",OrdId),"\",2)
  ..s Unit=$p(^DHCBldTakePack(TakeNo,"ORDER",OrdId),"\",3)
  ..s OrdList=OrdList_OrdDesc_" "_Amount_Unit_";"
  .s retStr=retStr_num_":"_TakeNo_":"_CreateDT_","_OrdList_" "_Remark_"^"
  .s num=num+1
  s retStr=$p(retStr,"^",1,$l(retStr,"^")-1)
   s ^TMPPACKLIST(11)=retStr
  ///
  s retval=itmjs_"('"_$ZCVT(retStr,"O","JS")_"');"
  &javascript<#(retval)#>
  q retStr
}

/// 得到取血单基本信息
ClassMethod GetPatInfoBroker(itmjs As %Library.String = "", AppNo As %Library.String = "", TakePackNo As %Library.String = "")
{
  q:AppNo="" ""
  s ^TMPPACKLIST(1)=AppNo
  s PatName=$p(^DHCBLDAPPFORM(AppNo,"P"),"\",2)
  s ABO=$p(^DHCBLDAPPFORM(AppNo,"P"),"\",26)
  s RH=$p(^DHCBLDAPPFORM(AppNo,"P"),"\",27)
  //取血单上科室
  s Loc=$p(^DHCBLDAPPFORM(AppNo,"P"),"\",22)
  s Location=""
  i $l(Loc),$d(^CTLOC(Loc)) s Location=$p(^CTLOC(Loc),"^",2)
  s Debtor=$p(^DHCBLDAPPFORM(AppNo,"P"),"\",15)
    s BAH=$p(^DHCBLDAPPFORM(AppNo,"P"),"\",29)
    s Debtor=BAH
    s curWardDr=$p(^DHCBLDAPPFORM(AppNo,"P"),"\",13)
    i $l(curWardDr) S patWardDesc=$P($g(^PAWARD(curWardDr)),"^",2)
    s Location=$g(patWardDesc)
    S:Location["-" Location=$P(Location,"-",2)

  s Remark=""
  i $l(TakePackNo),$d(^DHCBldTakePack(TakePackNo)) s Remark=$p(^DHCBldTakePack(TakePackNo),"\",9)
  s retStr=Debtor_"^"_PatName_"^"_ABO_"^"_RH_"^"_Location_"^"_Loc_"^"_Remark
  //
  s retval=itmjs_"('"_$ZCVT(retStr,"O","JS")_"');"
  &javascript<#(retval)#>
  q retStr
}

/// 保存取血单基本信息
ClassMethod SaveTakePackBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", TakePackNo As %Library.String = "", User As %Library.String = "", PatStr As %Library.String = "", OrderStr As %Library.String = "")
{
 
  s ^TMPPACKLIST(1)=TakePackNo
  s ^TMPPACKLIST(2)=User
  s ^TMPPACKLIST(3)=PatStr
  s ^TMPPACKLIST(4)=OrderStr
 Set Config=##Class(websys.Configuration).%OpenId(1)
 Set MEDDATA=Config.DataNamespace
 Set LABDATA=Config.LabDataNamespace
 Set CurrentNS=$ZNSPACE
 Set Ret="",retStr=""
 ZN MEDDATA
 Set Ret=$$Save^DHCBldTakePack(TakePackNo,User,PatStr,OrderStr)
 ZN CurrentNS
 s retval=itmjs_"('"_$ZCVT(Ret,"O","JS")_"');"
 i itmjsex '="""" s retval=retval_itmjsex_"('"_$ZCVT(Ret,"O","JS")_"');"
 &javascript<#(retval)#>
  q Ret
}

}
