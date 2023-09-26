Class web.DHCPE.CT.SpecialItemContral Extends %Persistent
{

/// Creator：	 xueying 
/// CreatDate：	 20211112
/// Description: 判断该科室下用户是否存在特殊项目权限
/// Table：      DHC_PE_SpecialContral（特殊项目权限维护表）
/// Input:       UserID(用户ID),LocID(科室ID)
/// Return：     1/0(存在/不存在)
/// Dubug: w ##class(web.DHCPE.CT.SpecialItemContral).IsExsistSpeItemContral("1","152") 
ClassMethod IsExsistSpeItemContral(UserID, LocID)
{
	s flag=0
	i $d(^CF.PE.SpecialContralI("IdxOfLocUserOrder"," "_LocID," "_UserID)) s flag=1
	q flag
}

/// Creator：	 xueying 
/// CreatDate：	 20211104
/// Description: 更新特殊项目权限
/// Table：      DHC_PE_SpecialContral（特殊项目权限维护表）
/// Input:       UserID(用户ID),LocID(科室ID)
/// Return：     -1:失败  0：成功
/// Dubug: w ##class(web.DHCPE.CT.SpecialItemContral).UpdateSpeItemContralActive("1","152") 
ClassMethod UpdateSpeItemContralActive(UserID, LocID)
{
	s OrderID="",flag=0,obj=""
	f  s OrderID=$o(^CF.PE.SpecialContralI("IdxOfLocUserOrder"," "_LocID," "_UserID,OrderID))  q:OrderID=""  d
	.s SItemConID=""
	.f  s SItemConID=$o(^CF.PE.SpecialContralI("IdxOfLocUserOrder"," "_LocID," "_UserID,OrderID,SItemConID))  q:SItemConID=""  d
	..s obj=##Class(User.DHCPESpecialContral).%OpenId(SItemConID)
	..;b ;SItemConID
	..s obj.SCNoActive="N"
	..s sc=obj.%Save()
	..if ($System.Status.IsError(sc)) d
	...d $system.OBJ.DisplayError(sc)
	...s flag=-1
	..else  d
	...s flag=0
	..
	i ($isobject(obj)="1"){d obj.%Close()}
	
	q flag
}

/// Creator：	 xueying 
/// CreatDate：	 20211104
/// Description: 特殊项目权限保存数据
/// Table：      DHC_PE_SpecialContral（特殊项目权限维护表）
/// Input:       UserID(用户ID),LocID(科室ID)，OrderDRStr（授权的特殊项目串:项目1^项目2^...）, SessionUser(操作人ID)
/// Return：     -1:失败  大于0：成功
/// Dubug: w ##class(web.DHCPE.CT.SpecialItemContral).SaveSpecialItemContral("13811","152","^3||2^5||2^6||2","12187")
ClassMethod SaveSpecialItemContral(UserID, LocID, OrderDRStr, SessionUser)
{
   s ^tempdhcpe("AddSpecialItemContral")=$lb(UserID, LocID, OrderDRStr, SessionUser)
   
   s $ZT="SaveSpecialItemContralErr"
   s result=1
   
   TSTART
   
   S ret=..UpdateSpeItemContralActive(UserID, LocID) //更新该科室该用户下之前所有的特殊项目为不激活状态
   if (ret'="0"){
	   s result="-1^更新该科室该用户下之前所有的特殊项目为不激活状态失败"
   	   goto SaveSpecialItemContralErr
   }

   //根据入参OrderDRStr将其选中的特殊项目更新为激活状态
   s ID=""
   for num=1:1:$length(OrderDRStr,"^") {
	    s OrderDR=$p(OrderDRStr,"^",num)
        i OrderDR=""{
			s ID=$o(^CF.PE.SpecialContralI("IdxOfLocUserOrder"," "_LocID," "_UserID,"-100000000000000",0))
		}
		else{
			s ID=$o(^CF.PE.SpecialContralI("IdxOfLocUserOrder"," "_LocID," "_UserID,OrderDR,0))
	
		}
		
		if (ID=""){
			s obj=##Class(User.DHCPESpecialContral).%New()
		}else{
			s OldRecord=$ListToString($g(^CF.PE.SpecialContralD(ID)))
			s obj=##Class(User.DHCPESpecialContral).%OpenId(ID)
		}
		s obj.SCLocDR=LocID
		s obj.SCNoActive="Y"
		s obj.SCUserDR=UserID
		continue:OrderDR=""
		d:(OrderDR'="") obj.SCOrderDRSetObjectId(OrderDR)
		s obj.SCUpdateDate=+$H
		s obj.SCUpdateTime=$p($h,",",2)
		s obj.SCUpdateUserDR=SessionUser
		s sc=obj.%Save()
		d obj.%Close()
		if $system.Status.IsError(sc) {         //检查Save是否成功
   			if (ID="") s result="-1^新增数据失败"
   			else  s result="-1^更新数据失败"
            goto SaveSpecialItemContralErr
		}else{
			s RowID=obj.%Id()
			if (ID=""){	
			 	s result="0^新增成功"
   	    		s OldRecord=""
   	    		s NewRecord=$ListToString($g(^CF.PE.SpecialContralD(RowID)))
   	    		s Logret=##class(web.DHCPE.CT.BaseLog).InsertRecordLog("DHC_PE_SpecialContral",RowID,"I",OldRecord,NewRecord,SessionUser)
   	    
				if ($p(Logret,"^",1)="-1"){
					s result="-1^插入新增数据日志失败"_$p(Logret,"^",2)
        			goto SaveSpecialItemContralErr
				}
   	    	}else{
	   	    	s result="0^修改成功"
   	    		s NewRecord=$ListToString($g(^CF.PE.SpecialContralD(RowID)))
   	    		if (OldRecord'=NewRecord) {
   	    			s Logret=##class(web.DHCPE.CT.BaseLog).InsertRecordLog("DHC_PE_SpecialContral",RowID,"U",OldRecord,NewRecord,SessionUser)
					if ($p(Logret,"^",1)="-1"){
						s result="-1^插入更新数据日志失败"_$p(Logret,"^",2)
        				goto SaveSpecialItemContralErr
					}
   	    		}	  
			}
		}
	
   }
   
	TCommit
      q result  
SaveSpecialItemContralErr
	TROLLBACK 
	//q $ZE
    q result
}

/// Creator：    sxt 
/// CreatDate：  20210816
/// Description: 特殊项目删除
/// Table：      特殊项目权限维护表 User.DHCPESpecialContral  DHC_PE_SpecialContral
/// Input:       UserID,LocID,SessionUserID
/// Return：    
/// dubug: w ##class(web.DHCPE.CT.SpecialItemContral).DelSpecialItemContralUser(11849,"304")
ClassMethod DelSpecialItemContral(UserID, LocID, SessionUserID)
{
	s ^DHCPERecord("DelSpecialItemContralUser")=$lb(UserID,LocID,SessionUserID)
	s $ZT="DelSpecialItemContralErr"
    s result=1
    if (UserID=""){
	 s result="-1^用户不能为空"
      goto DelSpecialItemContralErr
    }
    if (LocID=""){
	 s result="-1^科室不能为空"
      goto DelSpecialItemContralErr
    }
	
	TSTART
	
	s SQLCODE=0
	s ItemID=0
	for{
		 s ItemID=$o(^CF.PE.SpecialContralI("IdxOfLocUserOrder"," "_LocID," "_UserID,ItemID)) 
		 q:ItemID=""  
		 s ID=$o(^CF.PE.SpecialContralI("IdxOfLocUserOrder"," "_LocID," "_UserID,ItemID,0))
		 continue:ID=""
		 s OldRecord=$ListToString($g(^CF.PE.SpecialContralD(ID)))
	     &sql(delete from sqluser.DHC_PE_SpecialContral where ID=:ID)
	     if (SQLCODE'=0)	{ 
        	s result="-1^删除数据失败"
        	goto DelSpecialItemContralErr
		
     	}else{
 			s Logret=##class(web.DHCPE.CT.BaseLog).InsertRecordLog("DHC_PE_SpecialContral",ID,"D",OldRecord,"",SessionUserID)
			if ($p(Logret,"^",1)="-1"){
				s result="-1^插入删除数据日志失败"_$p(Logret,"^",2)
        		goto DelSpecialItemContralErr
			}
		}
	}
	TCommit
      s result="0^删除数据成功"
      q result  
DelSpecialItemContralErr	
	TROLLBACK 
    q result
}

/// Creator：	 xueying 
/// CreatDate：	 20211104
/// Description: 查询特殊项目权限
/// Table：      DHC_PE_StationOrderSet（科室站点项目扩展表）
///              DHC_PE_StationOrder（站点项目组合表）
/// 			 DHC_PE_SpecialContral（特殊项目权限维护表）
/// Input:       UserID(用户ID),LocID(科室ID)
/// Return：     Y/N
/// Dubug: d ##class(%ResultSet).RunQuery("web.DHCPE.CT.SpecialItemContral","SearchSpecialItemContral","304")
Query SearchSpecialItemContral(LocID) As %Query(ROWSPEC = "ID,UserID:%String,UserCode:%String,UserName:%String,ArcDescStr:%String,ItemIDStr")
{
}

ClassMethod SearchSpecialItemContralExecute(ByRef qHandle As %Binary, LocID) As %Status
{

	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	i (LocID="")
	{
		Set qHandle=$lb(0,repid,0) 
		Quit $$$OK
	}	

	s UserNode=""
	f  s UserNode=$o(^CF.PE.SpecialContralI("IdxOfLocUserOrder"," "_LocID,UserNode)) q:UserNode=""  d
	.s ItemID="",ArcDescStr="",ItemIDStr=""
	.f  s ItemID=$o(^CF.PE.SpecialContralI("IdxOfLocUserOrder"," "_LocID,UserNode,ItemID))  q:ItemID=""  d
	..s ID=$o(^CF.PE.SpecialContralI("IdxOfLocUserOrder"," "_LocID,UserNode,ItemID,0))
	..q:ID=""
	..s OrdExID=$o(^CF.PE.StationOrderSetI("IdxOfLocOrder"," "_LocID,ItemID,0))
	..s SpecialFlag="N"
	..i OrdExID'="" s SpecialFlag=$lg($g(^CF.PE.StationOrderSetD(OrdExID)),20)
	..q:SpecialFlag'="Y" //特殊检查
	..s ARCIMDR=$p($g(^DHCPEST($p(ItemID,"||",1),"O",$p(ItemID,"||",2))),"^",1)
	..s Active=$lg($g(^CF.PE.SpecialContralD(ID)),5)
	..q:Active'="Y"
	..i ItemIDStr="" s ItemIDStr=ItemID
	..e  s ItemIDStr=ItemIDStr_"^"_ItemID
	..s ArcDesc=##class(web.DHCPE.DHCPECommon).GetArcDesc(ARCIMDR)
	..i ArcDescStr="" s ArcDescStr=ArcDesc
	..e  s ArcDescStr=ArcDescStr_","_ArcDesc
	
	.s UserID=$replace(UserNode," ","")
	.s init=$P($G(^SSU("SSUSR",UserID)),"^",1)
	.s UserName=$P($G(^SSU("SSUSR",UserID)),"^",2)
	.d OutPutSpecItemContral	
	Set qHandle=$lb(0,repid,0) 
	Quit $$$OK
OutPutSpecItemContral	
	set Data=$lb(ID,UserID,init,UserName,ArcDescStr,ItemIDStr)  
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SearchSpecialItemContralFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchSpecialItemContralExecute ]
{
	
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else{			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind) 
	Quit $$$OK
}

ClassMethod SearchSpecialItemContralClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchSpecialItemContralExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator：	 xueying 
/// CreatDate：	 20211104
/// Description: 查询特殊项目
/// Table：      DHC_PE_StationOrderSet（科室站点项目扩展表）
///              DHC_PE_StationOrder（站点项目组合表）
/// 			 DHC_PE_SpecialContral（特殊项目权限维护表）
/// Input:       LocID(科室ID)
/// Return：     Y/N
/// Dubug:  d ##class(%ResultSet).RunQuery("web.DHCPE.CT.SpecialItemContral","SearchSpecialItem","152")
Query SearchSpecialItem(LocID As %String) As %Query(ROWSPEC = "id:%String,desc:%String")
{
}

ClassMethod SearchSpecialItemExecute(ByRef qHandle As %Binary, LocID As %String) As %Status
{

    //S ^TEMPDHCPE("LocID",LocID)=LocID
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	i (LocID="")
	{
		Set qHandle=$lb(0,repid,0) 
		Quit $$$OK
	}	
	
	s ItemID=""
	f  s ItemID=$o(^CF.PE.StationOrderSetI("IdxOfLocOrder"," "_LocID,ItemID)) q:(ItemID="")  d
	.s ARCIMDR=$p($g(^DHCPEST($p(ItemID,"||",1),"O",$p(ItemID,"||",2))),"^",1)
	.s ArcDesc=##class(web.DHCPE.DHCPECommon).GetArcDesc(ARCIMDR,"A",LocID)
	.s OrdExID=0
	.f  s OrdExID=$o(^CF.PE.StationOrderSetI("IdxOfLocOrder"," "_LocID,ItemID,OrdExID)) q:(OrdExID="")  d
	..s SpecialFlag=$lg($g(^CF.PE.StationOrderSetD(OrdExID)),20)
	..q:SpecialFlag'="Y" //特殊检查
	..d OutPutSpecialItem
	Set qHandle=$lb(0,repid,0) 
	Quit $$$OK
OutPutSpecialItem
	
	set Data=$lb(ItemID,ArcDesc)  
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SearchSpecialItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchSpecialItemExecute ]
{
	
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else{			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind) 
	Quit $$$OK
}

ClassMethod SearchSpecialItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchSpecialItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Storage Default
{
<Data name="SpecialItemContralDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCPE.CT.SpecialItem401ED</DataLocation>
<DefaultData>SpecialItemContralDefaultData</DefaultData>
<IdLocation>^web.DHCPE.CT.SpecialItem401ED</IdLocation>
<IndexLocation>^web.DHCPE.CT.SpecialItem401EI</IndexLocation>
<StreamLocation>^web.DHCPE.CT.SpecialItem401ES</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
