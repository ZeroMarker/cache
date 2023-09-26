/// creat by zhouli
/// 体检医嘱在报告上的排列顺序
/// 设置^DHCPECTDataEx("DHCPEStationOrder","Sequence")存放数据
/// 2008-03-10
Class web.DHCPE.ItemSequence Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod SaveNew(InString As %String = "")
{
 
   s itemid=$p(InString,"^",1)
   s sequence=$p(InString,"^",2)
   S itemname=$p(^ARCIM($P(itemid,"||",1),$P(itemid,"||",2),1),"^",2)
   S itemcode=$p(^ARCIM($P(itemid,"||",1),$P(itemid,"||",2),1),"^",1)
   s flag=0
   s seq=0
   f  s seq=$o(^DHCPECTDataEx("DHCPEStationOrder","Sequence",seq))  q:seq=""  d
   .s id=0
   .f  s id=$o(^DHCPECTDataEx("DHCPEStationOrder","Sequence",seq,id))  q:id=""  d
   ..s info=$g(^DHCPECTDataEx("DHCPEStationOrder","Sequence",seq,id))             //通过遍历取^DHCPEDataEx已存数据
   ..s ItemID=$P(info,"^",1)
   ..s seq=$p(info,"^",4)
   ..q:ItemID'=itemid                                      //循环判断界面传入的医嘱是否已存在，
   ..s flag=1                                                //医嘱存在则设置flag=1
   ..s Sequence=seq

    i flag=1  s ReturnFlag=..Update(Sequence,itemid,itemcode,itemname,sequence)   //当医嘱存在则进行更新操作
    else  s ReturnFlag=..Insert(itemid,itemcode,itemname,sequence)                 //不存在则直接将新数据插入^DHCPEDataEx
    q 0
}

ClassMethod Save(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{
   s itemid=$p(InString,"^",1)
   s itemcode=$p(InString,"^",2)
   s itemname=$p(InString,"^",3)
   s sequence=$p(InString,"^",4)
   s flag=0
   s seq=0
   f  s seq=$o(^DHCPECTDataEx("DHCPEStationOrder","Sequence",seq))  q:seq=""  d
   .s id=0
   .f  s id=$o(^DHCPECTDataEx("DHCPEStationOrder","Sequence",seq,id))  q:id=""  d
   ..s info=$g(^DHCPECTDataEx("DHCPEStationOrder","Sequence",seq,id))             //通过遍历取^DHCPEDataEx已存数据
   ..s ItemID=$P(info,"^",1)
   ..s seq=$p(info,"^",4)
   ..q:ItemID'=itemid                                      //循环判断界面传入的医嘱是否已存在，
   ..s flag=1                                                //医嘱存在则设置flag=1
   ..s Sequence=seq

    i flag=1  s ReturnFlag=..Update(Sequence,itemid,itemcode,itemname,sequence)   //当医嘱存在则进行更新操作
    else  s ReturnFlag=..Insert(itemid,itemcode,itemname,sequence)                 //不存在则直接将新数据插入^DHCPEDataEx
    q 0
}

// 从临时^DHCPEDataEx中取出数据，通过Query显示在界面Table列表中

ClassMethod Insert(itemid As %Library.String = "", itemcode As %Library.String = "", itemname As %Library.String = "", sequence As %Library.String = "")
{
    s ^DHCPECTDataEx("DHCPEStationOrder","Sequence",itemid)=sequence         //报告打印时调用
	s ^DHCPECTDataEx("DHCPEStationOrder","Sequence",sequence,itemid)=itemid_"^"_itemcode_"^"_itemname_"^"_sequence
	q 0
}

ClassMethod Update(Sequence As %Library.String = "", itemid As %Library.String = "", itemcode As %Library.String = "", itemname As %Library.String = "", sequence As %Library.String = "")
{
    k ^DHCPECTDataEx("DHCPEStationOrder","Sequence",Sequence,itemid)               //删掉旧记录                  
    s ^DHCPECTDataEx("DHCPEStationOrder","Sequence",itemid)=sequence           
    s ^DHCPECTDataEx("DHCPEStationOrder","Sequence",sequence,itemid)=itemid_"^"_itemcode_"^"_itemname_"^"_sequence
	q 0
}

ClassMethod SearchItemSeqInfoExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s Sequence=0
    f  s Sequence=$o(^DHCPECTDataEx("DHCPEStationOrder","Sequence",Sequence))  q:Sequence=""  d
    .s ARCIMDR=0
    .f  s ARCIMDR=$o(^DHCPECTDataEx("DHCPEStationOrder","Sequence",Sequence,ARCIMDR))  q:ARCIMDR=""  d
    ..s Info=$g(^DHCPECTDataEx("DHCPEStationOrder","Sequence",Sequence,ARCIMDR))
    ..s itemid=$p(Info,"^",1)
    ..s itemcode=$p(Info,"^",2)
    ..s itemname=$p(Info,"^",3)
    ..s itemsequence=$p(Info,"^",4)
 	..d SearchOut
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
SearchOut      
	set Data=$lb(itemid,itemcode,itemname,itemsequence)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SearchItemSeqInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchItemSeqInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	//
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

Query SearchItemSeqInfo() As %Query(ROWSPEC = "TItemID:%String,TItemCode:%String,TItemName:%String,TItemSequence:%String")
{
}

ClassMethod SearchItemSeqInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchItemSeqInfoExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod Delete(string)
{
   s id=$p(string,"^",1)
    s sequence=$p(string,"^",2)
	K ^DHCPECTDataEx("DHCPEStationOrder","Sequence",sequence,id)
	K ^DHCPECTDataEx("DHCPEStationOrder","Sequence",id)
	q 0
}

ClassMethod IfItemIdExist(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{
  s ItemRowId=$p(InString,"^",1)
  s seq=0
  s ret=0
  f  s seq=$o(^DHCPECTDataEx("DHCPEStationOrder","Sequence",seq))  q:seq=""  d
  .s id=0
  .f  s id=$o(^DHCPECTDataEx("DHCPEStationOrder","Sequence",seq,id))  q:id=""  d
  ..s info=$g(^DHCPECTDataEx("DHCPEStationOrder","Sequence",seq,id))                 //通过遍历取^DHCPEDataEx已存数据
  ..s ItemID=$P(info,"^",1)
  ..i ItemID=ItemRowId  s ret=ret+1
  
   q ret
            //返回一个值：如果为0则说明此ID没有添加过，否则则是添加过的
}

ClassMethod Save1(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{
   s SignOrderID=$p($g(InString),"^",1)
   s SignOrderName=$p($g(InString),"^",2)
   s ^DHCPECTDataEx("DHCPEStationOrder","Sign",SignOrderID)=SignOrderName
   q 0
}

ClassMethod SearchSignOrderExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s SignOrderID=0
    f  s SignOrderID=$o(^DHCPECTDataEx("DHCPEStationOrder","Sign",SignOrderID))  q:SignOrderID=""  d
    .s SignOrderName=$G(^DHCPECTDataEx("DHCPEStationOrder","Sign",SignOrderID))

 	.d SearchOut
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
SearchOut      
	set Data=$lb(SignOrderID,SignOrderName)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SearchSignOrderFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchSignOrderExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	//
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

Query SearchSignOrder() As %Query(ROWSPEC = "TOrderID:%String,TOrderName:%String")
{
}

ClassMethod SearchSignOrderClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchSignOrderExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod Delete1(string)
{
    s SignOrderID=$p(string,"^",1)
  
	K ^DHCPECTDataEx("DHCPEStationOrder","Sign",SignOrderID)

	q 0
}

}
