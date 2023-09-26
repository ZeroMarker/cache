/// 名称: 排斥项目
/// 编写者：xy
/// 编写日期: 2021-08-16
Class web.DHCPE.CT.ExcludeArcItem Extends %RegisteredObject
{

/// Creator：     xy 
/// CreatDate：   20210816
/// Description:  查询排斥项目
/// Table：       排斥项目表 DHC_PE_ExcludeArcItem
/// Debug: d ##class(%ResultSet).RunQuery("web.DHCPE.CT.ExcludeArcItem","FindExcludeArcItem","3650||1","1","DHC_PE_ExcludeArcItem")
Query FindExcludeArcItem(ARCIMID As %Library.String = "", LocID As %String = "", tableName As %String = "") As websys.Query(ROWSPEC = "TID:%String,TArcItemDR:%String,TArcItemDesc:%String,TExArcItemDR:%String,TExArcItemDesc:%String,TUpdateDate,TUpdateTime,TUpdateUser,TEmpower,TEffPowerFlag")
{
}

ClassMethod FindExcludeArcItemExecute(ByRef qHandle As %Binary, ARCIMID As %Library.String = "", LocID As %String = "", tableName As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 
    s ^tempdhcpe("FindExcludeArcItem")=$lb(ARCIMID,LocID,tableName)
    if (ARCIMID="")&&(LocID="")&&(tableName=""){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
    
    s id=0
    f  s id=$O(^User.DHCPEExcludeArcItemI("EAArcItemIndex",ARCIMID,id)) q:id=""  d
    .s ArcItemDR=$LG($G(^User.DHCPEExcludeArcItemD(id)),2)
    .s ArcItemDRDesc="" 
    .i ArcItemDR'="" s ArcItemDRDesc=$p($g(^ARCIM($p(ArcItemDR,"||",1),$p(ArcItemDR,"||",2),1)),"^",2)
    .s ExArcItemDR=$LG($G(^User.DHCPEExcludeArcItemD(id)),3)
    .s ExArcItemDRDesc="" 
    .i ExArcItemDR'="" s ExArcItemDRDesc=$p($g(^ARCIM($p(ExArcItemDR,"||",1),$p(ExArcItemDR,"||",2),1)),"^",2)
    .s UpdateDate=$LG($G(^User.DHCPEExcludeArcItemD(id)),4)
    .i UpdateDate'="" s UpdateDate=##class(websys.Conversions).DateLogicalToHtml(UpdateDate)
    .s UpdateTime=$LG($G(^User.DHCPEExcludeArcItemD(id)),5)
    .i UpdateTime'="" s UpdateTime=##class(websys.Conversions).TimeLogicalToHtml(UpdateTime)
    .s UpdateUserDR=$LG($G(^User.DHCPEExcludeArcItemD(id)),6)
    .s UpdateUser=""  
	.i UpdateUserDR'="" s UpdateUser=$p($g(^SSU("SSUSR",UpdateUserDR)),"^",2)
	.s LocShowDFlag=##class(User.DHCPEExcludeArcItem).GetLocShowDataFlag(id,LocID)
    .q:LocShowDFlag="N"
    .s EmpowerStr=##class(User.DHCPEExcludeArcItem).GetEmpowerFlag(id,LocID)
    .s Empower=$p(EmpowerStr,"^",2)
    .s EffPowerFlag=$s(LocShowDFlag="Y":"Y",1:"N")
    .;d TranslateFindExcludeArcItem
    .s ^CacheTemp(repid,ind)=$lb(id,ArcItemDR,ArcItemDRDesc,ExArcItemDR,ExArcItemDRDesc,UpdateDate,UpdateTime,UpdateUser,Empower,EffPowerFlag)
    .s ind=ind+1
   
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
TranslateFindExcludeArcItem
	s ArcItemDRDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.ARCItmMast",ArcItemDRDesc,"ARCIMDesc","cls")
	s ExArcItemDRDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.ARCItmMast",ExArcItemDRDesc,"ARCIMDesc","cls")
	s UpdateUser=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.SSUser",UpdateUser,"SSUSRName","cls")
}

/// Creator：	  xy 
/// CreatDate：	  20210816
/// Description:  是否存在排斥项目
/// Table：		  排斥项目表 DHC_PE_ExcludeArcItem
/// Input: 		  ARCIMID(项目ID), EXARCIMID(排斥项目ID)
/// Return：
/// Debug:w ##class(web.DHCPE.CT.ExcludeArcItem).IsExcludeArcItem("3130||1","3646||1")
ClassMethod IsExcludeArcItem(ARCIMID As %String = "", EXARCIMID As %String = "", LocID As %String = "")
{
	k ^tempdhcpe("IsExcludeArcItem")
	s ^tempdhcpe("IsExcludeArcItem")=ARCIMID_"^"_EXARCIMID_"^"_LocID
	s flag=0
	s id=0
    f  s id=$O(^User.DHCPEExcludeArcItemI("EAArcItemIndex",ARCIMID,id)) q:(id="")||(flag=1)  d
    .s ExArcItemDR=$LG($G(^User.DHCPEExcludeArcItemD(id)),3)
    .s LocShowDFlag=##class(User.DHCPEExcludeArcItem).GetLocShowDataFlag(id,LocID)
    .q:LocShowDFlag'="Y"
    .i ExArcItemDR=EXARCIMID s flag=1
    Q:flag=1 flag
   	s id=0
    f  s id=$O(^User.DHCPEExcludeArcItemI("EAExArcItemIndex",ARCIMID,id)) q:(id="")||(flag=1)  d
    .s ArcItemDR=$LG($G(^User.DHCPEExcludeArcItemD(id)),2)
    .s LocShowDFlag=##class(User.DHCPEExcludeArcItem).GetLocShowDataFlag(id,LocID)
    .q:LocShowDFlag'="Y"
    .i ArcItemDR=EXARCIMID s flag=1
    q flag
}

/// Creator：	 xy 
/// CreatDate：	 20210816
/// Description: 保存排斥项目
/// Table：      排斥项目表 DHC_PE_ExcludeArcItem
/// Input:       ID(数据ID), ARCIMID(项目ID),EXARCIMID(排斥项目ID)
/// Return：
/// Debug: w ##class(web.DHCPE.CT.ExcludeArcItem).SaveExcludeArcItem()
ClassMethod SaveExcludeArcItem(InfoStr As %String = "", tableName As %String = "")
{
	
	s $ZT="SaveExcludeArcItem"
    s result=1
    
	s ID=$P(InfoStr ,"^",1)
	s ARCIMID=$P(InfoStr ,"^",2)
	s EXARCIMID=$P(InfoStr ,"^",3)
	s Empower=$P(InfoStr ,"^",4)
	s LocID=$P(InfoStr ,"^",5)
	s UserID=$P(InfoStr ,"^",6)
	s Date=$p($h,",",1)
	s Time=$p($h,",",2)
	
	if ID="" d
	.s obj=##class(User.DHCPEExcludeArcItem).%New()
	e  d
	.s OldRecord=$g(^User.DHCPEExcludeArcItemD(ID))
	.s obj=##class(User.DHCPEExcludeArcItem).%OpenId(ID)
	
	d obj.EAArcItemDRSetObjectId(ARCIMID)
	d obj.EAExArcItemDRSetObjectId(EXARCIMID)
	s obj.EAUpdateDate=Date
	s obj.EAUpdateTime=Time
	s obj.EAUpdateUserDR=UserID
	
	TSTART
	s sc=obj.%Save()
	d obj.%Close()
	
	If ($System.Status.IsError(sc))	 
     { 
        s result="-1^保存排斥项目表失败"
        goto SaveExcludeArcItem
		
      }else{
   			s RowID=obj.%Id()
   			b ;tableName,RowID,LocID,UserID
   			s ret=##class(User.DHCPEExcludeArcItem).SaveDataToPowerControl(RowID,LocID,UserID,Empower)
   			//表记录授权插入数据失败
    		If ($p(ret,"^",1)="-1")	 
    		{ 
        		s result="-1^插入记录授权表失败"
        		goto SaveExcludeArcItem
		
   			 } 
   		if (ID=""){	
   	    	s OldRecord=""
   	    	s NewRecord=$g(^User.DHCPEExcludeArcItemD(RowID))
   	    	s Logret=##class(web.DHCPE.CT.BaseLog).InsertRecordLog("DHC_PE_ExcludeArcItem",RowID,"I",OldRecord,NewRecord,UserID)
   	    
			if ($p(Logret,"^",1)="-1"){
				s result="-1^插入新增数据日志失败"_$p(Logret,"^",2)
        		goto SaveExcludeArcItem
			}
   	    }else{
   	    	s NewRecord=$g(^User.DHCPEExcludeArcItemD(RowID))
   	    	if (OldRecord'=NewRecord) {
   	    		s Logret=##class(web.DHCPE.CT.BaseLog).InsertRecordLog("DHC_PE_ExcludeArcItem",RowID,"U",OldRecord,NewRecord,UserID)
				if ($p(Logret,"^",1)="-1"){
					s result="-1^插入更新数据日志失败"_$p(Logret,"^",2)
        			goto SaveExcludeArcItem
				}
   	    	}
   	    }   	
   		
   	}
	 
	TCommit
        s result="0^保存成功"
        q result  
SaveExcludeArcItem
	
	TROLLBACK 
	//q $ZE
    q result
}

/// Creator：    xy 
/// CreatDate：  20210816
/// Description: 删除排斥项目
/// Table：      排斥项目表 DHC_PE_ExcludeArcItem
/// Input:       ID（数据ID）
/// Return：
/// Debug:w ##class(web.DHCPE.CT.ExcludeArcItem).DeleteExcludeArcItem()
ClassMethod DeleteExcludeArcItem(ID)
{
	s $ZT="DeleteExcludeArcItemErr"
    s result=1
	TSTART
	s obj=##class(User.DHCPEExcludeArcItem).%New()
	s OldRecord=$g(^User.DHCPEExcludeArcItemD(ID))
	s sc=obj.%DeleteId(ID)
	d obj.%Close()
	
	If ($System.Status.IsError(sc))	
	{
		s result="-1^删除项目排斥表数据失败"
        goto DeleteExcludeArcItemErr
		
	}else{
		s NewRecord=""
   	    s Logret=##class(web.DHCPE.CT.BaseLog).InsertRecordLog("DHC_PE_ExcludeArcItem",ID,"D",OldRecord,NewRecord,UserID)
		if ($p(Logret,"^",1)="-1"){
			s result="-1^插入删除数据日志失败"_$p(Logret,"^",2)
        	goto DeleteExcludeArcItemErr
		}
	}
	TCommit
        s result="0^删除项目排斥表数据成功"
        q result  
DeleteExcludeArcItemErr
	TROLLBACK 
	//q $ZE
    q result
}

}
