/// 名称: 短信模板维护
/// 编写者：xy
/// 编写日期: 2021-08-08
Class web.DHCPE.CT.MessageTemplet Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：     xy 
/// CreatDate：   20210809
/// Description:  短信模板表插入数据
/// Table：       短信模板表 User.DHCPENewMessageTemplet
/// Input:        Type（短信类别）,VIP（VIP等级）,Templet(短信内容),Active（激活）,）
///               UserID（当前登陆人员ID）,tableName（表名）,LocID(科室下拉列表值)
/// Return：
/// debug：w ##class(web.DHCPE.CT.MessageTemplet).Insert()
ClassMethod Insert(Type As %String, VIP As %String, Templet As %String, Active As %String = "Y", UserID As %String, tableName As %String, LocID As %String)
{
   s ^tempdhcpe("InsertMessageTemplet")=$lb(Type,VIP,Templet,Active,UserID,tableName,LocID)
   n (Type,VIP,Templet,Active,UserID,tableName,LocID)
   s $ZT="InsertMessageTempletErr"
   s result=1
   s Date=+$h
   s Time=$p($h,",",2) 
   s Default="0" 
 
  	//&sql(insert into DHC_PE_NewMessageTemplet(NMT_Type,NMT_Templet,NMT_Active,NMT_Default,NMT_VIPLevel,NMT_LocDR,NMT_UpdateDate,NMT_UpdateTime,NMT_UpdateUserDR)
	//values (:Type,:Templet,:Active,:Default,:VIP,:LocID,:Date,:Time,:UserID))
	s obj=##class(User.DHCPENewMessageTemplet).%New()
 	s obj.NMTLocDR=LocID
	s obj.NMTActive=Active
	s obj.NMTDefault="0"
	s obj.NMTTemplet=Templet
	s obj.NMTType=Type
    s obj.NMTVIPLevel=VIP
    s obj.NMTUpdateDate=Date
    s obj.NMTUpdateTime=Time
    s obj.NMTUpdateUserDR=UserID
    
  TSTART
    //短信模板表插入数据失败
 	s sc=obj.%Save()
	d obj.%Close()
	if ($System.Status.IsError(sc)) {
		 s result="-1^插入短信模板表失败"
         goto InsertMessageTempletErr
	} else {
   		s RowID=obj.%Id()
   		;b ;tableName,RowID,LocID,UserID
   	
   		s ret=##class(User.DHCPENewMessageTemplet).SaveDataToPowerControl(RowID,LocID,UserID)
   		//表记录授权插入数据失败
    	If ($p(ret,"^",1)="-1")	 
    	{ 
        	s result="-1^插入记录授权表失败"
        	goto InsertMessageTempletErr
		
   	    }else{
   	   		s OldRecord=""
   	   		s NewRecord=$ListToString($g(^User.DHCPENewMessageTempletD(RowID)))
   	   		s Logret=##class(web.DHCPE.CT.BaseLog).InsertRecordLog("DHC_PE_NewMessageTemplet",RowID,"I",OldRecord,NewRecord,UserID)
   	    
			if ($p(Logret,"^",1)="-1"){
				s result="-1^插入新增数据日志失败"_$p(Logret,"^",2)
        		goto InsertMessageTempletErr
			}
   
   	    }
   		
   	}
	
    
	TCommit
        s result="0^插入成功"
        q result  
InsertMessageTempletErr
	
	TROLLBACK 
	//q $ZE
    q result
}

/// Creator：     xy 
/// CreatDate：   20210809
/// Description:  更新短信模板
/// Table：       短信模板表 User.DHCPENewMessageTemplet
/// Input:        rowid(数据ID),Type(短信类别), VIP(VIP等级),Templet(短信内容), Active(激活)
///               UserID(当前登陆人员ID),tableName(表名),LocID(科室下拉列表值)
/// Return:
/// debug：w ##class(web.DHCPE.CT.MessageTemplet).Update()
ClassMethod Update(rowid As %Library.String = "", Type As %String, VIP As %String, Templet As %String, Active As %String = "Y", UserID As %String, LocID As %String)
{
   	s ^tempdhcpe("UpdateMessageTemplet")=$lb(rowid,Type,VIP,Templet,Active,UserID,LocID)
   	n (rowid,Type,VIP,Templet,Active,UserID,LocID)
   
   	s $ZT="UpdateMessageTempletErr"
   	s result=1
   
   	s Date=+$h
   	s Time=$p($h,",",2)
    s OldRecord=$ListToString($g(^User.DHCPENewMessageTempletD(rowid)))
    s obj=##class(User.DHCPENewMessageTemplet).%OpenId(rowid)
 	s obj.NMTLocDR=LocID
	s obj.NMTActive=Active
	s obj.NMTDefault="0"
	s obj.NMTTemplet=Templet
	s obj.NMTType=Type
    s obj.NMTVIPLevel=VIP
    s obj.NMTUpdateDate=Date
    s obj.NMTUpdateTime=Time
    s obj.NMTUpdateUserDR=UserID
   
   TSTART
    s sc=obj.%Save()
	d obj.%Close()
	if ($System.Status.IsError(sc)) {
		 s result="-1^更新短信模板表失败"
         goto UpdateMessageTempletErr
	} else {
		s RowID=obj.%Id()
   	   	s NewRecord=$ListToString($g(^User.DHCPENewMessageTempletD(RowID)))
   	   	s Logret=##class(web.DHCPE.CT.BaseLog).InsertRecordLog("DHC_PE_NewMessageTemplet",RowID,"U",OldRecord,NewRecord,UserID)
		if ($p(Logret,"^",1)="-1"){
			s result="-1^插入新增数据日志失败"_$p(Logret,"^",2)
        	goto UpdateMessageTempletErr
		}
	}
	
	TCommit
       s result="0^更新成功"
       q result  
UpdateMessageTempletErr
	
	TROLLBACK 
	//q $ZE
    q result
}

/// Description: 查询短信模板
/// Table：短信模板维护表 DHC_PE_NewMessageTemplet 
/// Input: 
/// Return：
/// Creator：xy 
/// CreatDate：20210808
/// d ##class(%ResultSet).RunQuery("web.DHCPE.CT.MessageTemplet","FindMessageTemplet","1","","","","Y","")
Query FindMessageTemplet(LocID As %String, VIPLevel As %String, Type As %String, Templet As %String, Active As %String = "Y", Default As %String) As %Query(ROWSPEC = "TID,TTypeID,TType,TVIPID,TVIDesc,TTemplet,TActive,TUpdateDate,TUpdateTime,TUserName")
{
}

ClassMethod FindMessageTempletExecute(ByRef qHandle As %Binary, LocID As %String, VIPLevel As %String, Type As %String, Templet As %String, Active As %String = "Y", Default As %String = "") As %Status
{
	  s ^tempdhcpe("FindMessageTemplet")=$lb(LocID,VIPLevel,Type,Templet,Active,Default)
	  Set repid=$I(^CacheTemp)
      s ind=1
      if (LocID="")
      {
	    Set qHandle=$lb(0,repid,0)
		Quit $$$OK
      }
	  s NMTType=""
	  f  s NMTType=$o(^User.DHCPENewMessageTempletI("IdxOfLocTypeVIP",LocID,NMTType)) q:NMTType=""  d
	  .s VIP=""
	  .f  s VIP=$o(^User.DHCPENewMessageTempletI("IdxOfLocTypeVIP",LocID,NMTType,VIP)) q:VIP=""  d
	  ..s ID=""
	  ..f  s ID=$o(^User.DHCPENewMessageTempletI("IdxOfLocTypeVIP",LocID,NMTType,VIP,ID)) q:ID=""  d
      ...s NMTTemplet=$lg($g(^User.DHCPENewMessageTempletD(ID)),4)
      ...q:(Templet'="")&&(NMTTemplet'[Templet)
      ...s NMTActive=$lg($g(^User.DHCPENewMessageTempletD(ID)),5)
      ...q:((""'=Active)&((NMTActive'=Active)))
      ...i NMTActive="0"  s NMTActive="N"
      ...i NMTActive="1"  s NMTActive="Y"
      ...s NMTVIPLevel=$lg($g(^User.DHCPENewMessageTempletD(ID)),6)
      ...i NMTVIPLevel'="" s VIPDesc=$lg($g(^CT.PE.VIPLevelD(NMTVIPLevel)),3)
      ...q:(VIPLevel'="")&&(VIPLevel'=NMTVIPLevel)
      ...s TType=$lg($g(^User.DHCPENewMessageTempletD(ID)),2)
      ...q:(TType'=Type)&(Type'="")
      ...s UpdateDate=$lg($g(^User.DHCPENewMessageTempletD(ID)),8)
	  ...i UpdateDate'="" s UpdateDate=##class(websys.Conversions).DateLogicalToHtml(UpdateDate)
	  ...s UpdateTime=$lg($g(^User.DHCPENewMessageTempletD(ID)),9)
	  ...i UpdateTime'="" s UpdateTime=##class(websys.Conversions).TimeLogicalToHtml(UpdateTime)
	  ...s UpdateUserDR=$lg($g(^User.DHCPENewMessageTempletD(ID)),10)
	  ...s UpdateUserName=""
	  ...i UpdateUserDR'="" s UpdateUserName=$p($g(^SSU("SSUSR",UpdateUserDR)),"^",2)
      ...Do FindBuild
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
FindBuild   
      set Data=$lb(ID,NMTType,TType,NMTVIPLevel,VIPDesc,NMTTemplet,NMTActive,UpdateDate,UpdateTime,UpdateUserName)
      
      Set ^CacheTemp(repid,ind)=Data
      Set ind=ind+1
      quit
}

ClassMethod FindMessageTempletFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindMessageTempletExecute ]
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

ClassMethod FindMessageTempletClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindMessageTempletExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
