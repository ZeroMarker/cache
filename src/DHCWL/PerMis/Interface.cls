Class DHCWL.PerMis.Interface Extends %RegisteredObject
{

/// Creator：      王峥
/// CreatDate：    2017-12
/// Description:：  根据用户ID返回该用户所有能访问的表信息
/// Table：       DHCWL_PerMis.Member,DHCWL_PerMis.Rpt,DHCWL_PerMis.Grp
/// Input：       RptTypeName：报表类型名称，比如：收入报表配置；UserID：用户ID
/// Output：      
/// Return：       报表ID。
/// Others：
/// s rpts=##class(DHCWL.PerMis.Interface).GetRptByUser("收入报表配置",userID)
ClassMethod GetRptByUser(RptTypeName As %String, UserID As %String) As %String
{
	s ret=""
		
	s rptTypeID=$o(^DHCWL.PerMis.RptTypeI("InxTypeName",RptTypeName,""))
	if $g(rptTypeID)="" q "无此产品类型"
	
	s sql="SELECT DISTINCT t1.RptID FROM DHCWL_PerMis.Rpt t1,"
	s sql=sql_" (SELECT DISTINCT GrpCode FROM DHCWL_PerMis.Member WHERE UserID='"_UserID_"' ) AS t2 "
	s sql=sql_" WHERE t1.GrpCode=t2.GrpCode AND t1.RptType='"_rptTypeID_"'"

	
	s rs=##class(%Library.ResultSet).%New()
	s rs.RuntimeMode=1	//ODBC显示模式
	s st=rs.Prepare(sql) 
	
	if ($$$ISERR(st)) {
		s ret=$System.Status.GetErrorText(st)
		goto SQLErr
	}
	s st=rs.Execute() 
	if ($$$ISERR(st)) {
		s ret=$System.Status.GetErrorText(st)
		goto SQLErr
	}
	while(rs.Next()) {
		s rptID=rs.Data("RptID")
		if ret="" s ret=rptID 
		else  s ret=ret_"^"_rptID
	}

	d rs.Close()
	//自己可以先返回测试数据
	q ret
	
SQLErr
	//if $d(rs) d rs.Close()
	q ret
}

/// Creator：      王峥
/// CreatDate：    2017-12
/// Description:：  根据用户ID返回该用户所有能访问的表信息
/// Table：       DHCWL_PerMis.Member,DHCWL_PerMis.Rpt,DHCWL_PerMis.Grp
/// Input：       RptTypeName：报表类型名称，比如：收入报表配置；UserID：用户ID
/// Output：      typeName:报表类型名称 ,rptID:报表标识 ,RptDesc:报表描述 ,grpCodes:权限组编码
/// Return：       
/// Others：        
/// d ##class(%ResultSet).RunQuery("DHCWL.PerMis.Interface","QryRptByUser","收入报表配置",981)
Query QryRptByUser(RptTypeName As %String, UserID As %String) As %Query(ROWSPEC = "typeName:%String ,rptID:%String ,rptDesc:%String ,grpCodes:%String ") [ SqlProc ]
{
}

ClassMethod QryRptByUserExecute(ByRef qHandle As %Binary, RptTypeName As %String, UserID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	k ^||TEMPDHCWL
	//s $zt="SQLErr"

	//1、得到所有的产品类型
	s rptTypeID=""
	f {
		s rptTypeID=$o(^DHCWL.PerMis.RptTypeD(rptTypeID))
		q:$g(rptTypeID)=""
		s typeName=$lg(^DHCWL.PerMis.RptTypeD(rptTypeID),2)
		s excCode=$lg(^DHCWL.PerMis.RptTypeD(rptTypeID),3)
		s ^||TEMPDHCWL("rptType",rptTypeID)=typeName
		
		//2、得到所有产品的报表及描述
		s rs=##class(%Library.ResultSet).%New(excCode)
		d rs.Prepare()
		d rs.Execute()
	
		While(rs.Next()){
			s identifier=rs.Data("identifier")
			s descript=rs.Data("descript")
			s ^||TEMPDHCWL("rptType",rptTypeID,identifier)=descript		
		}
		
		
		d rs.Close()
	}
	
	//2、生成sql
	s sql=""
	if $g(UserID)'="" {
		s sql="SELECT RptType,RptID,XMLAGG(Code || ',') AS GrpCodes FROM (SELECT t2.RptType,t2.RptID,t3.Code,t3.Descript FROM DHCWL_PerMis.Member t1,DHCWL_PerMis.Rpt t2,DHCWL_PerMis.Grp t3 "
		s sql=sql_"WHERE t1.GrpCode=t3.Code AND t2.GrpCode=t3.Code AND t1.UserID='"_UserID_"') "
		s sql=sql_"GROUP BY RptID"
	}
	
	s rs=##class(%Library.ResultSet).%New()
	s rs.RuntimeMode=1	//ODBC显示模式
	s st=rs.Prepare(sql) 
	
	if ($$$ISERR(st)) {
		s ret=$System.Status.GetErrorText(st)
		goto SQLErr
	}
	s st=rs.Execute() 
	if ($$$ISERR(st)) {
		s ret=$System.Status.GetErrorText(st)
		goto SQLErr
	}
	
	//3、循环输出
	while(rs.Next()) {
		s rptID=rs.Data("RptID")
		s rptType=rs.Data("RptType")
		s grpCodes=rs.Data("GrpCodes")
		if $E(grpCodes,*)="," s grpCodes=$E(grpCodes,1,*-1)
		s typeName=^||TEMPDHCWL("rptType",rptType)
		continue:($g(RptTypeName)'="" && (RptTypeName'[typeName))
		s RptDesc=^||TEMPDHCWL("rptType",rptType,rptID)
		//continue:(searchV'="" && (rptID'[searchV) && (grpCodes'[searchV) && (typeName'[searchV) && (RptDesc'[searchV) )
		s Data=$lb(typeName,rptID,RptDesc,grpCodes)
		Do OutRow3
	}

	d rs.Close()
	
	k ^||TEMPDHCWL
    Set qHandle=$lb(0,repid,0)
    k ^TEMPDHCWL($j)
 	Quit $$$OK
OutRow3
    //s LocDesc=$p(^CTLOC(locdr),"^",2)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
SQLErr
	if $d(rs) d rs.Close()
	q ret
}

ClassMethod QryRptByUserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryRptByUserExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryRptByUserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryRptByUserExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

/// Creator：      王峥
/// CreatDate：    2018-8
/// Description:：  根据用户ID返回该用户所有能访问的表信息
/// Table：       DHCWL_PerMis.Member,DHCWL_PerMis.Rpt,DHCWL_PerMis.Grp
/// Input：       rptTool：cdq,bdq,kdq,odq;UserID：用户ID
/// Output：      
/// Return：       报表ID。
/// Others：
/// d ##class(%ResultSet).RunQuery("DHCWL.PerMis.Interface","GetRptSummaryByUrer","bdq",1)
Query GetRptSummaryByUrer(rptTool As %String, userID As %String, searchV As %String) As %Query(ROWSPEC = "toolName:%String,ID:%String,name:%String,descript:%String,title:%String,author:%String,businessType:%String,code:%String")
{
}

ClassMethod GetRptSummaryByUrerExecute(ByRef qHandle As %Binary, rptTool As %String, userID As %String, searchV As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	k ^||TEMPDHCWL
	//最近使用报表
	//获取权限
	s bdqIds=..GetRptIDByUser("bdq",userID)
	if bdqIds'="" {
		s ids=bdqIds
		s len=$l(ids,"^")
		f i=1:1:len {
			s ID=$p(ids,"^",i)	
			s ^||TEMPDHCWL("bdq",ID)=""
		}
	}
	
	s cdqIds=..GetRptIDByUser("cdq",userID)
	if cdqIds'="" {
		s ids=cdqIds
		s len=$l(ids,"^")
		f i=1:1:len {
			s ID=$p(ids,"^",i)	
			s ^||TEMPDHCWL("cdq",ID)=""
		}
	}
		
	s visitDate=""
	s recentCnt=0	//计数，到10个就退出
	f {
		s visitDate=$o(^DHCWL.BaseDataQuery.RecentLTI("InxDateTime",userID,visitDate),-1)
		q:visitDate=""
		
		s visitTime=""
		f {
			s visitTime=$o(^DHCWL.BaseDataQuery.RecentLTI("InxDateTime",userID,visitDate,visitTime),-1)
			q:visitTime=""
			
			s ID=$O(^DHCWL.BaseDataQuery.RecentLTI("InxDateTime",userID,visitDate,visitTime,""))
			s recentListObj=##class(DHCWL.BaseDataQuery.RecentLT).%OpenId(ID)
			/// 报表ID
			s rptID=recentListObj.RptID
			/// 业务类型，包括：收入，挂号，手术等等
			s tool=recentListObj.RptTool
			continue:'$d(^||TEMPDHCWL(tool,rptID))
			if tool="bdq" {
				s rptObj=##class(DHCWL.BaseDataQuery.Rpt).%OpenId(rptID)
				continue:('$ISOBJECT(rptObj))
				s name=rptObj.Name
				s descript=rptObj.Descript
				s title=name
				s businessType="最近访问报表"
				s creator=rptObj.Creator
				s userObj=##class(User.SSUser).%OpenId(creator)
				s author=""
				if $ISOBJECT(userObj) s author=userObj.SSUSRName
				s code=rptObj.Code
				//s searchV=$ZCVT(searchV,"U")
				//最近列表不进行过滤
				//if searchV'="" && ($ZCVT(name,"U")'[searchV) && ($ZCVT(descript,"U")'[searchV) && ($ZCVT(author,"U")'[searchV) && ($ZCVT(businessType,"U")'[searchV) && ($ZCVT(code,"U")'[searchV)  continue
				s Data=$lb("bdq",rptID,name,descript,title,author,businessType,code)
				Do OutRow
				s recentCnt=recentCnt+1
				q:recentCnt>=10				
			}elseif tool="cdq" {
				s rptObj=##class(DHCWL.CommonDataQry.RptCfg).%OpenId(rptID)
				continue:('$ISOBJECT(rptObj))
				//ID:%String,
				s name=rptObj.RptName
				s descript=rptObj.Descript
				s title=name
				s businessType="最近访问报表"
				s author=rptObj.UserDr.SSUSRName
				s code=rptObj.Code
				
				//最近列表不进行过滤
				if searchV'="" && ($ZCVT(name,"U")'[searchV) && ($ZCVT(descript,"U")'[searchV) && ($ZCVT(author,"U")'[searchV) && ($ZCVT(businessType,"U")'[searchV) && ($ZCVT(code,"U")'[searchV)  continue
				s Data=$lb("cdq",rptID,name,descript,title,author,businessType,code)
				Do OutRow
				s recentCnt=recentCnt+1
				q:recentCnt>=10				
			}
			q:recentCnt>=10
		}
		q:recentCnt>=10
	}
	
	if rptTool="bdq" || (rptTool="all") {
		s toolName="bdq"
		s ids=bdqIds
		if ids'="" {
			s len=$l(ids,"^")
			f i=1:1:len {
				s ID=$p(ids,"^",i)
				s rptObj=##class(DHCWL.BaseDataQuery.Rpt).%OpenId(ID)
				continue:('$ISOBJECT(rptObj))
				//ID:%String,
				s name=rptObj.Name
				s descript=rptObj.Descript
				s title=name
				s businessType=rptObj.BusinessType
				s creator=rptObj.Creator
				s userObj=##class(User.SSUser).%OpenId(creator)
				s author=""
				if $ISOBJECT(userObj) s author=userObj.SSUSRName
				s code=rptObj.Code
				s searchV=$ZCVT(searchV,"U")
				if searchV'="" && ($ZCVT(name,"U")'[searchV) && ($ZCVT(descript,"U")'[searchV) && ($ZCVT(author,"U")'[searchV) && ($ZCVT(businessType,"U")'[searchV) && ($ZCVT(code,"U")'[searchV)  continue
				s Data=$lb(toolName,ID,name,descript,title,author,businessType,code)
				Do OutRow
			}
		}
	}
	if rptTool="cdq" || (rptTool="all") {
		s toolName="cdq"
		s ids=cdqIds
		if ids'="" {
			s len=$l(ids,"^")
			f i=1:1:len {
				s ID=$p(ids,"^",i)
				s rptObj=##class(DHCWL.CommonDataQry.RptCfg).%OpenId(ID)
				continue:('$ISOBJECT(rptObj))
				//ID:%String,
				s name=rptObj.RptName
				s descript=rptObj.Descript
				s title=name
				s businessType=rptObj.PdtType
				s author=rptObj.UserDr.SSUSRName
				s code=rptObj.Code
				s searchV=$ZCVT(searchV,"U")
				if searchV'="" && ($ZCVT(name,"U")'[searchV) && ($ZCVT(descript,"U")'[searchV) && ($ZCVT(author,"U")'[searchV) && ($ZCVT(businessType,"U")'[searchV) && ($ZCVT(code,"U")'[searchV)  continue
				s Data=$lb(toolName,ID,name,descript,title,author,businessType,code)
				Do OutRow
			}
		}		
	}

	if rptTool="kdq" || (rptTool="all") {
		
		
		
	}
	if rptTool="odq" || (rptTool="all") {
		
		
		
	}

    Set qHandle=$lb(0,repid,0)
    k ^TEMPDHCWL($j)
 	Quit $$$OK
OutRow
    //s LocDesc=$p(^CTLOC(locdr),"^",2)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
SQLErr
	if $d(rs) d rs.Close()
	q ret
}

ClassMethod GetRptSummaryByUrerClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRptSummaryByUrerExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetRptSummaryByUrerFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRptSummaryByUrerExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

ClassMethod GetRptIDByUser(rptTool As %String, userID As %String) As %String
{
	s ret=""
	s sql="SELECT DISTINCT t1.RptID AS rptID FROM DHCWL_PerMis.RGMAP t1,DHCWL_PerMis.GMMAP t2 "
	s sql=sql_"WHERE t1.GrpDr=t2.GrpDr AND t2.UserDr='"_userID_"' AND t1.RptTool='"_rptTool_"' "
	
	s rs=##class(%Library.ResultSet).%New()
	s rs.RuntimeMode=1	//ODBC显示模式
	s st=rs.Prepare(sql) 

	if ($$$ISERR(st)) {
		s ret=$System.Status.GetErrorText(st)
		goto SQLErr
	}
	s st=rs.Execute() 
	if ($$$ISERR(st)) {
		s ret=$System.Status.GetErrorText(st)
		goto SQLErr
	}
	while(rs.Next()) {
		s rptID=rs.Data("rptID")
		if ret="" s ret=rptID 
		else  s ret=ret_"^"_rptID
	}

	d rs.Close()
	//自己可以先返回测试数据
	q ret
	
SQLErr
	
	q ret
}

}
