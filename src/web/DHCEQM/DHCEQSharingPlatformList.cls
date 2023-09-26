/// 名称: web.DHCEQM.DHCEQSharingPlatformList
/// 描述: 经验分享平台明细
/// 编写者：李苗苗 
/// 编写日期:2015-12-28
Class web.DHCEQM.DHCEQSharingPlatformList Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator： 李苗苗 
/// CreatDate： 2015-12-28 
/// Description:： 添加数据
/// s val="^1^AA^N^77^5^19^^^1^1^1^1^1"
/// SharingPlatformListListInfo="^1^30&^2^30&^3^30"
/// d ##Class(web.DHCEQM.DHCEQSharingPlatformList).SaveSharingPlatformList(val)
/// d ##Class(web.DHCEQM.DHCEQSharingPlatformList).AddSharingPlatformList("1^3^N^77^5")
ClassMethod AddSharingPlatformList(val)
{
	n RowID
	k PLIST
	s PLIST(1)="" 	//SPL_RowID
	s PLIST(2)=$p(val,"^",1)	//SPL_SharingPlatformDR
	s PLIST(3)=$p(val,"^",2)	//SPL_Content
	s PLIST(4)=$p(val,"^",3)	//SPL_AnonymousFlag
	s PLIST(5)=$p(val,"^",4)	//SPL_Rate
	s PLIST(6)=$p(val,"^",5)	//SPL_Picture
	s PLIST(7)=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID")) //SPL_UpdateUserDR
	s Time=##Class(web.DHCEQCommon).GetCurTime("",1)
	s Date=##Class(web.DHCEQCommon).GetCurTime(4,"")
	s PLIST(8)=##Class(web.DHCEQCommon).TransValueFromPage(Date,"date")	//SPL_UpdateDate需要转换成具体天数
	s PLIST(9)=##Class(web.DHCEQCommon).TransValueFromPage(Time,"time")	//SPL_UpdateTime
	s PLIST(10)=""	//SPL_Hold1
	s PLIST(11)=""	//SPL_Hold2
	s PLIST(12)=""	//SPL_Hold3
	s PLIST(13)=""  //SPL_Hold4
	s PLIST(14)=""	//SPL_Hold5
	if PLIST(1)=""  d
	.&SQL(insert into sqluser.DHC_EQSharingPlatformList Values :PLIST())
	q SQLCODE
}

/// Creator： 李苗苗 
/// CreatDate： 2015-12-28 
/// Description:： 更新数据
///  d ##Class(web.DHCEQM.DHCEQSharingPlatformList).SaveSharingPlatformList("1^bcb^cbcbc^1^N")
ClassMethod SaveSharingPlatformList(val)
{
	s RowID=$P(val,"^",1)  	//SPL_RowID
	s SharingPlatformDR=$p(val,"^",2)	//SPL_SharingPlatformDR
	s Content=$p(val,"^",3)	//SPL_Content
	s AnonymousFlag=$p(val,"^",4)	//SPL_AnonymousFlag
	s Rate=($p(val,"^",5))	//SPL_Rate
	s Picture=$p(val,"^",6)	//SPL_Picture
	&SQL(update sqluser.DHC_EQSharingPlatformList set SPL_SharingPlatformDR=:SharingPlatformDR,SPL_Content=:Content,SPL_AnonymousFlag=:AnonymousFlag,SPL_Rate=:Rate,SPL_Picture=:Picture where SPL_RowID=:RowID)
	q SQLCODE
}

/// Creator： 李苗苗 
/// CreatDate： 2015-12-28 
/// Description:： 存储平均分
ClassMethod SetRate(DR)
{
	s SharingPlatformDR=DR
	s val=0
	s flag=0
	s Rate=0
	s RowID=0
	f  s RowID=$O(^DHCEQSharingPlatformList(0,"SharingPlatformDR",SharingPlatformDR,RowID)) Quit:RowID=""  d
  	.s val=val+$p($g(^DHCEQSharingPlatformList(RowID)),"^",4)
  	.s flag=flag+1
  	s Rate=val/flag
    &SQL(update sqluser.DHC_EQSharingPlatform set SP_Rate=:Rate where SP_RowID=:SharingPlatformDR)
  	q Rate
}

/// Creator： 李苗苗 
/// CreatDate： 2015-12-28 
/// Description:： 确定发帖人与登陆人是否相同
ClassMethod DetermineUser(UpdateUserDR, RowID)
{
	s val=^DHCEQSharingPlatform(RowID)
	s Status=$p(val,"^",4)
	if (Status=2)
	{
		s flag=3
	}
     elseif (UpdateUserDR'=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))) 
    {
    s flag=0
    }
    else  
    {
    	if (Status=0)
    	{
	    	s flag=1
		}
		elseif (Status=1)
		{
			s flag=2
		}
    }
    q flag
}

/// Creator： 李苗苗 
/// CreatDate： 2015-12-28 
/// Description:：通过RowID进行删除
/// d ##Class(web.DHCEQM.DHCEQSharingPlatformList).DeleteSharingPlatformList()
ClassMethod DeleteSharingPlatformList(RowID)
{
	    &SQL(delete from sqluser.DHC_EQSharingPlatformList where SPL_RowID=:RowID)
		q SQLCODE
}

/// Creator： 李苗苗 
/// CreatDate： 2015-12-28 
/// Description:：获取主题帖子信息
/// d ##Class(web.DHCEQM.DHCEQSharingPlatformList).GetContent(2)
ClassMethod GetContent(RowID)
{
	&SQL(select SP_Title,SP_Content,SP_AnonymousFlag,SP_UpdateUserDR,SP_UpdateDate,SP_UpdateTime INTO :Title,:Content,:AnonymousFlag,:UpdateUserDR,:UpdateDate,:UpdateTime from sqluser.DHC_EQSharingPlatform where SP_RowID=:RowID)
	if (AnonymousFlag="Y")  d	
	.s UpdateUserName="匿名"
	else  d
    .s UpdateUserName=##Class(web.DHCEQCommon).GetUser(UpdateUserDR)
    .s UpdateUserName=$p(UpdateUserName,"^",1)
	
	s UpdateDate=##Class(web.DHCEQCommon).TransValueToPage(UpdateDate,"date")
	s UpdateTime=##Class(web.DHCEQCommon).TransValueToPage(UpdateTime,"time")
	s info=Title_"^作者："_UpdateUserName_"^日期："_UpdateDate_"时间："_UpdateTime_"^"_Content
	q info
}

/// Creator： 李苗苗 
/// CreatDate： 2015-12-28 
/// Description:：获取数据
/// d ##Class(%ResultSet).RunQuery("web.DHCEQM.DHCEQSharingPlatformList","GetSharingPlatformLists","","")
Query GetSharingPlatformLists(UName, SharingPlatformDR) As %Query(ROWSPEC = "RowID:%String,SharingPlatformDR:%String,Content:%String,AnonymousFlag:%String,Rate:%String,Picture:%String,UpdateUserDR:%String,UpdateUserName:%String,SPLUpdateDate:%String,SPLUpdateTime:%String")
{
}

ClassMethod GetSharingPlatformListsExecute(ByRef qHandle As %Binary, UName, SharingPlatformDR) As %Status
{
	n repid,index,rowid
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s index=1

	
	if ($g(UName)'="")
	{
	    s UpdateUserDR=0
	    f  s UpdateUserDR=$O(^SSU("SSUSR",0,"SSUSR_Name",UName,UpdateUserDR)) q:(UpdateUserDR="")  d
	    .s SPLRowID=0
	    .f  s SPLRowID=$o(^DHCEQSharingPlatformList(0,"UpdateUserDR",UpdateUserDR,SPLRowID)) q:(SPLRowID="")  d
	    ..s val=$g(^DHCEQSharingPlatformList(SPLRowID))
	    ..d Setval
	    
	}
	elseif ($g(SharingPlatformDR)'="")
	{    
	     //s SharingPlatformDR=0
	     //f  s SharingPlatformDR=$o(^DHCEQSharingPlatform(SharingPlatformDR)) Q:SharingPlatformDR=""  d
         s SPLRowID=0
	     f  s SPLRowID=$O(^DHCEQSharingPlatformList(0,"SharingPlatformDR",SharingPlatformDR,SPLRowID)) Quit:SPLRowID=""  d
  	     .s val=$g(^DHCEQSharingPlatformList(SPLRowID))
  	     .d Setval
	}
     else
		{
			s SPLRowID=0
			f  s SPLRowID=$O(^DHCEQSharingPlatformList(SPLRowID)) Quit:SPLRowID=""  d
			.s val=$g(^DHCEQSharingPlatformList(SPLRowID))
  	        .d Setval
		}
		
	
    	Quit $$$OK
	
Outputval
	s Data=$lb(RowID,SPLSharingPlatformDR,SPLContent,SPLAnonymousFlag,SPLRate,SPLPicture,SPLUpdateUserDR,SPLUpdateUserName,SPLUpdateDate,SPLUpdateTime)
	s ^CacheTemp(repid,index)=Data
	s index=index+1
	quit
	
Setval 
    s RowID=SPLRowID 
    s SPLSharingPlatformDR=$p(val,"^",1)     
    s SPLContent=$p(val,"^",2)
    s SPLAnonymousFlag=$p(val,"^",3)   
    s SPLRate=$p(val,"^",4)             
    s SPLPicture=$p(val,"^",5)     
    s SPLUpdateUserDR= $p(val,"^",6)
    if (SPLAnonymousFlag'="Y") 
    {
        s SPLUpdateUserName=##Class(web.DHCEQCommon).GetUser(SPLUpdateUserDR)
        s SPLUpdateUserName=$p(SPLUpdateUserName,"^",1)

    }
    else  
    {
    s SPLUpdateUserName="匿名"
    }
    s SPLUpdateDate=##Class(web.DHCEQCommon).TransValueToPage($p(val,"^",7),"date")
    s SPLUpdateTime=##Class(web.DHCEQCommon).TransValueToPage($p(val,"^",8),"time")
                                                                                                                                                                                     
    d Outputval
    
    quit
}

ClassMethod GetSharingPlatformListsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDHCEQSharingPlatformListsExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind=""
  {				
     Set AtEnd=1
     Set Row=""
  }Else      
  {				
    Set Row=^CacheTemp(repid,ind)
  }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod GetSharingPlatformListsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDHCEQSharingPlatformListsExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

}
