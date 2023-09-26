/// 名称: web.DHCEQM.DHCEQSharingPlatform
/// 描述: 经验分享平台
/// 编写者：李苗苗 
/// 编写日期:2015-12-28
Class web.DHCEQM.DHCEQSharingPlatform Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// s val="^1^AA^QQQQ^1^Y^Y^AAAA^19^21/12/2012^04:04^1^1^1^1^1"
/// SharingPlatformListInfo="^1^30&^2^30&^3^30"
/// d ##Class(web.DHCEQM.DHCEQSharingPlatform).SaveSharingPlatform(val)
/// d ##Class(web.DHCEQM.DHCEQSharingPlatform).SaveSharingPlatform("^1^bb^ccc^0^N^N^AAAA^62^21/12/2012^04:40^1^1^1^1^1")
/// Creator： 李苗苗 
/// CreatDate： 2015-12-28 
/// Description:： 添加数据
ClassMethod AddSharingPlatform(val)
{
	n RowID
	k PLIST
	s PLIST(1)=$P(val,"^",1)  	//SP_RowID
	s PLIST(4)=$p(val,"^",4)	//SP_Type
	s PLIST(2)=$p(val,"^",2)	//SP_Title
	s PLIST(3)=$p(val,"^",3)	//SP_Content
	s PLIST(5)=0	//SPStatus
	s PLIST(6)="N"	//SP_InvalidFlag
	s PLIST(7)=$p(val,"^",5)	//SP_AnonymousFlag 
	s PLIST(8)=0	//SP_Rate
	s PLIST(9)=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))	//SP_UpdateUserDR
	s Time=##Class(web.DHCEQCommon).GetCurTime("",1)
	s Date=##Class(web.DHCEQCommon).GetCurTime(4,"")
	s PLIST(10)=##Class(web.DHCEQCommon).TransValueFromPage(Date,"date")	//SP_UpdateDate需要转换成具体天数
	s PLIST(11)=##Class(web.DHCEQCommon).TransValueFromPage(Time,"time")	//SP_UpdateTime
	s PLIST(12)=""	//SP_Hold1
	s PLIST(13)=""	//SP_Hold2
	s PLIST(14)=""	//SP_Hold3
	s PLIST(15)=""	//SP_Hold4
	s PLIST(16)=""  //SP_Hold5
	if PLIST(1)=""  d
	.&SQL(insert into sqluser.DHC_EQSharingPlatform Values :PLIST())
	q SQLCODE
}

/// Creator： 李苗苗 
/// CreatDate： 2015-12-28 
/// Description:： 更新数据
ClassMethod SaveSharingPlatform(val)
{
	s RowID=$P(val,"^",1)  	                //SP_RowID
	s Type=..GetTypeDescH($p(val,"^",4))	//SP_Type
	s Title=$p(val,"^",2)	                //SP_Title
	s Content=$p(val,"^",3)	                //SP_Content
	s AnonymousFlag=$p(val,"^",5)	        //SP_AnonymousFlag 
	&SQL(update sqluser.DHC_EQSharingPlatform set SP_Type=:Type,SP_Title=:Title,SP_Content=:Content,SP_AnonymousFlag=:AnonymousFlag where SP_RowID=:RowID)
	q SQLCODE
}

/// Creator： 李苗苗 
/// CreatDate： 2015-12-28 
/// Description:： 通过无效标记进行删除
/// d ##Class(web.DHCEQM.DHCEQSharingPlatform).DeleteSharingPlatform()
ClassMethod DeleteSharingPlatform(RowID)
{
	&SQL(update sqluser.DHC_EQSharingPlatform set SP_InvalidFlag='Y' where SP_RowID=:RowID)
	q SQLCODE
}

/// Creator： 李苗苗 
/// CreatDate： 2015-12-28 
/// Description:： 提交数据
ClassMethod Submit(RowID)
{
	&SQL(update sqluser.DHC_EQSharingPlatform set SP_Status=1 where SP_RowID=:RowID)
	q SQLCODE
}

/// Creator： 李苗苗 
/// CreatDate： 2015-12-28 
/// Description:： 审核
ClassMethod Aduit(RowID)
{
	&SQL(update sqluser.DHC_EQSharingPlatform set SP_Status=2 where SP_RowID=:RowID)
	q SQLCODE
}

/// Creator： 李苗苗 
/// CreatDate： 2015-12-28 
/// Description:： 取消提交
ClassMethod UnSubmit(RowID)
{
	&SQL(update sqluser.DHC_EQSharingPlatform set SP_Status=0 where SP_RowID=:RowID)
	q SQLCODE
}

/// Creator： 李苗苗 
/// CreatDate： 2015-12-28 
/// Description:： 确定发帖人与登陆人是否相同
ClassMethod DetermineUser(UpdateUserDR)
{
	s CurUser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
     if (UpdateUserDR=CurUser) 
    {
    	s flag=1
    }
    else  
    {
    	s flag=0
    }
    q flag
}

/// Creator： 李苗苗 
/// CreatDate： 2015-12-28 
/// Description:： 获取数据。通过状态，发帖人，标题进行查询
/// do ##Class(%ResultSet).RunQuery("web.DHCEQM.DHCEQSharingPlatform","GetSharingPlatforms","","","")
Query GetSharingPlatforms(Status As %String = "", UName As %String = "", Title As %String = "") As %Query(ROWSPEC = "RowID:%String,Type:%String,Title:%String,Content:%String,Status:%String,AnonymousFlag:%String,Rate:%String,UpdateUserDR:%String,UpdateUserName:%String,SPUpdateDate:%String,SPUpdateTime:%String")
{
}

ClassMethod GetSharingPlatformsExecute(ByRef qHandle As %Binary, Status As %String = "", UName As %String = "", Title As %String = "") As %Status
{
	n repid,index,rowid
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s index=1
	if ($g(Status)'="")
	{
		s SStatus=Status
	    s SPRowID=0
	    f  s SPRowID=$o(^DHCEQSharingPlatform(0,"Status",SStatus,SPRowID)) q:(SPRowID="")  d
  	    .s val=$g(^DHCEQSharingPlatform(SPRowID))
  	    .d Setval
	}
	elseif($g(UName)'="")
	{
	    s UpdateUserDR=0
	    f  s UpdateUserDR=$O(^SSU("SSUSR",0,"SSUSR_Name",UName,UpdateUserDR)) q:(UpdateUserDR="")  d
	    .s SPRowID=0
	    .f  s SPRowID=$o(^DHCEQSharingPlatform(0,"UpdateUserDR",UpdateUserDR,SPRowID)) q:(SPRowID="")  d
	    ..s val=$g(^DHCEQSharingPlatform(SPRowID))
	    ..d Setval
	    
	}
	elseif($g(Title)'="")
	{
         s SPRowID=0
	     f  s SPRowID=$O(^DHCEQSharingPlatform(SPRowID)) Quit:SPRowID=""  d
	     .s SPTitle=$p($g(^DHCEQSharingPlatform(SPRowID)),"^",2)
	     .q:((Title'="")&&(SPTitle'[Title))
	     .s val=$g(^DHCEQSharingPlatform(SPRowID))
  	     .d Setval
	}
     else
		{
			s SPRowID=0
			f  s SPRowID=$O(^DHCEQSharingPlatform(SPRowID)) Quit:SPRowID=""  d
			.s val=^DHCEQSharingPlatform(SPRowID)
  	        .d Setval
		}
    	Quit $$$OK
	
Outputval
	s Data=$lb(RowID,SPType,SPTitle,SPContent,SPStatus,SPAnonymousFlag,SPRate,SPUpdateUserDR,SPUpdateUserName,SPUpdateDate,SPUpdateTime)
	s ^CacheTemp(repid,index)=Data
	s index=index+1
	quit
	
Setval
    s RowID=SPRowID
    s SPType=..GetTypeDesc($p(val,"^",1))
    s SPTitle=$p(val,"^",2)
    s SPContent=$p(val,"^",3)
    s SPStatus=..GetStatusDesc($p(val,"^",4))
    s SPInvalidFlag=$p(val,"^",5)
    s SPAnonymousFlag=$p(val,"^",6)
    s SPRate=$p(val,"^",7)
    s SPUpdateUserDR=$p(val,"^",8)
    if (SPAnonymousFlag'="Y")
    {
   		s SPUpdateUserName=##Class(web.DHCEQCommon).GetUser(SPUpdateUserDR)
    	s SPUpdateUserName=$p(SPUpdateUserName,"^",1)
    }
    else  
    {
    	s SPUpdateUserName="匿名"
    }
    s SPUpdateDate=##Class(web.DHCEQCommon).TransValueToPage($p(val,"^",9),"date")
    s SPUpdateTime=##Class(web.DHCEQCommon).TransValueToPage($p(val,"^",10),"time")
    s flag=..DetermineUser(SPUpdateUserDR)
    i (SPInvalidFlag="N")
    {
		if (flag=1)
		{ 
			d Outputval
		}
		elseif(SPStatus'="新增")
		{
	    	d Outputval
	    }
    }
    quit
}

ClassMethod GetSharingPlatformsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDHCEQSharingPlatformsExecute ]
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

ClassMethod GetSharingPlatformsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDHCEQSharingPlatformsExecute ]
{
 	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetTypeDesc(Type As %Library.String) As %String
{
	i Type="" q ""
	i Type="1" q "维修"
	q "未定义"
}

ClassMethod GetTypeDescH(Type As %Library.String) As %String
{
	i Type="" q ""
	i Type="维修" q 1
	i Type=1 q 1
}

ClassMethod GetStatusDesc(Status As %Library.String) As %String
{
	i Status="" q ""
	i Status=0 q "新增"
	i Status=1 q "提交"
	i Status=2 q "审核"
	q "未定义"
}

ClassMethod GetStatusDescH(Status As %Library.String) As %String
{
	i Status="" q ""
	i Status="新增" q 0
	i Status="提交" q 1
	i Status="审核" q 2
    i Status=0 q 0
	i Status=1 q 1
	i Status=2 q 2
}

}
