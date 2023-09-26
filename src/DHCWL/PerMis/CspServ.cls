Class DHCWL.PerMis.CspServ Extends %RegisteredObject
{

Query QryNotInRptByGrp(args As %String) As %Query(ROWSPEC = "rptID:%String,rptDesc:%String")
{
}

ClassMethod QryNotInRptByGrpExecute(ByRef qHandle As %Binary, args As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	k ^||TEMPDHCWL
	
	s grpCode=$p(args,$C(2),1)
	s rptTypeID=$p(args,$C(2),2)
	s searchV=$p(args,$C(2),3)
	
	s excCode=""
	&sql(select ExcCode into :excCode from DHCWL_PerMis.RptType where ID=:rptTypeID )
	
	
	s rs=##class(%Library.ResultSet).%New(excCode)
	d rs.Prepare()
	d rs.Execute()
	
	While(rs.Next()){
		s identifier=rs.Data("identifier")
		s isSame=0
		s rptID=""
		f {
			s rptID=$o(^DHCWL.PerMis.RptI("InxGrpTypeId",grpCode,rptTypeID,rptID))
			q:rptID=""
			if rptID=identifier {
				s isSame=1
				q
			}
		}		
		
		continue:isSame=1
		s descript=rs.Data("descript")
		continue:($g(searchV)'="" && ('##class(DHCWL.CommonUtil.FilterUtil).LikeCase(identifier,searchV)) && ('##class(DHCWL.CommonUtil.FilterUtil).LikeCase(descript,searchV)))
		s Data=$lb(identifier, descript)
		Do OutRow
		
	}

	k ^||TEMPDHCWL
    Set qHandle=$lb(0,repid,0)
    k ^TEMPDHCWL($j)
 	Quit $$$OK
OutRow
    //s LocDesc=$p(^CTLOC(locdr),"^",2)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod QryNotInRptByGrpClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryRptByGrpExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryNotInRptByGrpFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryRptByGrpExecute ]
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

Query QryRptByGrp(args As %String) As %Query(ROWSPEC = "ID:%String,grpCode:%String,RptType:%String,TypeName:%String,RptID:%String,RptDesc:%String")
{
}

ClassMethod QryRptByGrpExecute(ByRef qHandle As %Binary, args As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	k ^||TEMPDHCWL
	//s $zt="SQLErr"
	s grpCode=$p(args,$C(2),1)
	s searchV=$p(args,$C(2),2)
	
	
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
	
	//如果是超级权限组，直接返回所有表
	if grpCode="Admin" {
		s rptTypeID=""
		f {
			s rptTypeID=$o(^||TEMPDHCWL("rptType",rptTypeID))
			q:rptTypeID=""
			s identifier=""
			f {
				s identifier=$o(^||TEMPDHCWL("rptType",rptTypeID,identifier))
				q:identifier=""
				s descript=^||TEMPDHCWL("rptType",rptTypeID,identifier)

			
				continue:(searchV'="" && (descript'[searchV) && (identifier'[searchV)  )
				s rptID=""
				s Data=$lb("", grpCode,rptTypeID,typeName,identifier,descript)
				Do OutRow2
			}
		}
	}else{
	
	
		//3、得到用户配置的报表
		//InxGrpTypeId On (GrpCode, RptType, RptID);
		s rptType=""
		f {
			s rptType=$o(^DHCWL.PerMis.RptI("InxGrpTypeId",grpCode,rptType))
			q:$g(rptType)=""
			s rptID=""
			f {
				s rptID=$o(^DHCWL.PerMis.RptI("InxGrpTypeId",grpCode,rptType,rptID))
				q:$g(rptID)=""
				s ID=""
				f {
					s ID=$o(^DHCWL.PerMis.RptI("InxGrpTypeId",grpCode,rptType,rptID,ID))
					q:$g(ID)=""
				
					s typeName=^||TEMPDHCWL("rptType",rptType)
					s rptDesc=^||TEMPDHCWL("rptType",rptType,rptID)
					continue:(searchV'="" && (rptDesc'[searchV) && (typeName'[searchV)  )
					s Data=$lb(ID, grpCode,rptType,typeName,rptID,rptDesc)
					Do OutRow2
				}				
			}
		
		}
	}
	
	k ^||TEMPDHCWL
    Set qHandle=$lb(0,repid,0)
    k ^TEMPDHCWL($j)
 	Quit $$$OK
OutRow2
    //s LocDesc=$p(^CTLOC(locdr),"^",2)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
SQLErr
	if $d(rs) d rs.Close()
	q ret
}

ClassMethod QryRptByGrpClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryRptByGrpExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryRptByGrpFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryRptByGrpExecute ]
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

Query QryRM(args As %String) As %Query(ROWSPEC = "UserID:%String,UserDescript:%String,TypeName:%String,RptID:%String,RptDesc:%String")
{
}

ClassMethod QryRMExecute(ByRef qHandle As %Binary, args As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	k ^||TEMPDHCWL
	//s $zt="SQLErr"
	//w !,args
	s RptType=$p(args,$C(2),1)
	s RptID=$p(args,$C(2),2)
	s UserID=$p(args,$C(2),3)
	s searchV=$p(args,$C(2),4)
	s inGrpCode=$p(args,$C(2),5)
	
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
	
	//
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
	
	/*
	while(rs.Next()) {
		s rptID=rs.Data("RptID")
		s rptType=rs.Data("RptType")
		s grpCodes=rs.Data("GrpCodes")
		if $E(grpCodes,*)="," s grpCodes=$E(grpCodes,1,*-1)
		s typeName=^||TEMPDHCWL("rptType",rptType)
		s RptDesc=^||TEMPDHCWL("rptType",rptType,rptID)
		continue:(searchV'="" && (rptID'[searchV) && (grpCodes'[searchV) && (typeName'[searchV) && (RptDesc'[searchV) )
		s Data=$lb(typeName,rptID,RptDesc,grpCodes)
		Do OutRow3
	}
	*/
	
	
	while(rs.Next()) {
		s rptID=rs.Data("RptID")
		s rptType=rs.Data("RptType")
		s grpCodes=rs.Data("GrpCodes")
		//if $E(grpCodes,*)="," s grpCodes=$E(grpCodes,1,*-1)
		s typeName=^||TEMPDHCWL("rptType",rptType)
		s RptDesc=^||TEMPDHCWL("rptType",rptType,rptID)
		continue:(searchV'="" && (rptID'[searchV) && (grpCodes'[searchV) && (typeName'[searchV) && (RptDesc'[searchV) )
		s ^||TEMPDHCWL("RSByUserID",rptType,rptID)=grpCodes_"^"_typeName_"^"_RptDesc
	}
	s cnt=0
	&sql(SELECT count(id) into :cnt FROM DHCWL_PerMis.Member WHERE UserID=:UserID AND GrpCode='Admin' )
	if cnt>0 s inGrpCode="Admin"
	
	
	if inGrpCode="Admin" {
		s rptType=""
		f {
			s rptType=$o(^||TEMPDHCWL("rptType",rptType))
			q:rptType=""
			s typeName=^||TEMPDHCWL("rptType",rptType)
			s rptID=""
			f {
				s rptID=$o(^||TEMPDHCWL("rptType",rptType,rptID))
				q:rptID=""
				s RptDesc=^||TEMPDHCWL("rptType",rptType,rptID)
				//s grpCodes
				if $d(^||TEMPDHCWL("RSByUserID",rptType,rptID)) s grpCodes=$p(^||TEMPDHCWL("RSByUserID",rptType,rptID),"^",1)_"Admin"
				else  s grpCodes="Admin"
				s Data=$lb(typeName,rptID,RptDesc,grpCodes)
				Do OutRow3			
			}		
		}
	}else{
		s rptType=""
		f {
			s rptType=$o(^||TEMPDHCWL("RSByUserID",rptType))
			q:$g(rptType)=""
			s rptID=""
			f {
				s rptID=$o(^||TEMPDHCWL("RSByUserID",rptType,rptID))	
				q:rptID=""
				s grpCodes=$p(^||TEMPDHCWL("RSByUserID",rptType,rptID),"^",1)
				s typeName=$p(^||TEMPDHCWL("RSByUserID",rptType,rptID),"^",2)
				s RptDesc=$p(^||TEMPDHCWL("RSByUserID",rptType,rptID),"^",3)
				if $E(grpCodes,*)="," s grpCodes=$E(grpCodes,1,*-1)
				s Data=$lb(typeName,rptID,RptDesc,grpCodes)
				
				
				Do OutRow3
			}
		}
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

ClassMethod QryRMClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryRMExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryRMFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryRMExecute ]
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

}
