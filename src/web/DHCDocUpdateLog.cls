Class web.DHCDocUpdateLog Extends DHCDoc.Util.RegisteredObject [ Not ProcedureBlock ]
{

// d ##class(%ResultSet).RunQuery("web.DHCBL.Patient.DHCPatientUpdateLog","SelectProperty","User.PAPerson")

Query SelectProperty(ClassName As %String) As %Query(ROWSPEC = "propertyName:%String,propertyType:%String,propertyField:%String")
{
}

ClassMethod SelectPropertyExecute(ByRef qHandle As %Binary, ClassName As %String) As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1	
	i (ClassName="") Set qHandle=$lb(0,repid,0) Quit $$$OK
	k ^TMP("PatientLogSetSelectProperty")
	Set rsltSt = ##class(%ResultSet).%New("%Dictionary.PropertyDefinition:Summary")
	do rsltSt.Execute(ClassName)
	While(rsltSt.Next()) {
		set propertyName=rsltSt.Data("Name")
		set propertyId=ClassName_"||"_propertyName
		set propObj=##class(%Dictionary.PropertyDefinition).%OpenId(propertyId)
		set propertyType=propObj.Type
		if ($l(propertyType,".")=1)&&($l(propertyType,"%")=1) s propertyType="User."_propertyType
		set propertyField=propObj.SqlFieldName
		if (+propObj.Relationship=1) continue
		s ^TMP("PatientLogSetSelectProperty",propertyName)=$lb($g(propertyName),$g(propertyType),$g(propertyField))
	}
	s propertyName="" for  s propertyName=$o(^TMP("PatientLogSetSelectProperty",propertyName)) q:propertyName=""  d
	.set Data=^TMP("PatientLogSetSelectProperty",propertyName)
 	.Set ^CacheTemp(repid,ind)=Data
 	.set ind=ind+1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod SelectPropertyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectPropertyExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod SelectPropertyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectPropertyExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

ClassMethod SelectPropertyBroker(JSFunName As %String = "", ListName As %String = "", ClassName As %String) As %String
{
	;w ##class(web.DHCBL.Patient.DHCPatientUpdateLog).SelectPropertyBroker("","","","",1)
	s n=0
	Set rset=##Class(%ResultSet).%New("web.DHCBL.Patient.DHCPatientUpdateLog:SelectProperty")
	If rset.QueryIsValid() { 
		Set Status=rset.Execute(ClassName)
		If 'Status Quit
		Set columns = rset.GetColumnCount()
		s myIdx=0
		While (rset.Next()) { 
			  s propertyName=rset.GetDataByName("propertyName")  
	          s rtnval=JSFunName_"('"_ListName_"','"_$ZCVT($g(propertyName),"O","JS")_"','"_$ZCVT($g(propertyName),"O","JS")_"','"_$ZCVT($g(myIdx),"O","JS")_"');"
		  &javascript<#(rtnval)#>
		  s myIdx=myIdx+1
		}
		d rset.Close()
	}
	Q n
}

// d ##class(%ResultSet).RunQuery("web.DHCBL.Patient.DHCPatientUpdateLog","SelectProperty","User.PAPerson")

Query UPLSClassList() As %Query(ROWSPEC = "ClassName:%String,ClassName:%String")
{
}

ClassMethod UPLSClassListExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1	
	s ClassName=""
	for 
		{
			s ClassName = $o(^User.DHCDOCUPDATELS(0,"Class", ClassName))
			q:(ClassName="")
			d OutputRowUPLSClassList
		}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowUPLSClassList
	set Data=$lb($g(ClassName),$g(ClassName))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
}

ClassMethod UPLSClassListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = UPLSClassListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod UPLSClassListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = UPLSClassListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

Query UPLSClassPropertyList() As %Query(ROWSPEC = "UPLSClassProperty:%String,UPLSClassPropertyIndex:%String,UPLSRowId:%String")
{
}

ClassMethod UPLSClassPropertyListExecute(ByRef qHandle As %Binary, ClassName As %String) As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1	
	i (ClassName="") Set qHandle=$lb(0,repid,0) Quit $$$OK
	s PropertyIndex=0
	for 
	{
		s PropertyIndex = $o(^User.DHCDOCUPDATELS(0,"Class", ClassName, PropertyIndex))
		q:(PropertyIndex="")
		s UPLSRowId = $o(^User.DHCDOCUPDATELS(0,"Class", ClassName, PropertyIndex, ""))
		if UPLSRowId="" continue
		s LogSetObj = ##class(User.DHCDocUpLogSet).%OpenId(UPLSRowId)
		s UPLSClassProperty="",UPLSClassPropertyIndex=""
		if $IsObject(LogSetObj)
		{
			s UPLSClassProperty = LogSetObj.UPLSClassProperty
			s UPLSClassPropertyIndex = LogSetObj.UPLSClassPropertyIndex		
		}
		d LogSetObj.%Close()
		d OutputRowUPLSClassPropertyList					
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowUPLSClassPropertyList
	set Data=$lb($g(UPLSClassProperty),$g(UPLSClassPropertyIndex),$g(UPLSRowId))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
}

ClassMethod UPLSClassPropertyListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = UPLSClassPropertyListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod UPLSClassPropertyListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = UPLSClassPropertyListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

ClassMethod SelectUPLSPropertyBroker(JSFunName As %String = "", ListName As %String = "", ClassName As %String) As %String
{
	;w ##class(web.DHCBL.Patient.DHCPatientUpdateLog).SelectUPLSPropertyBroker("","","User.PAPerson")
	s n=0
	Set rset=##Class(%ResultSet).%New("web.DHCBL.Patient.DHCPatientUpdateLog:UPLSClassPropertyList")
	If rset.QueryIsValid() { 
		Set Status=rset.Execute(ClassName)
		If 'Status Quit
		Set columns = rset.GetColumnCount()
		s myIdx=0
		While (rset.Next()) { 
			  s UPLSClassProperty=rset.GetDataByName("UPLSClassProperty")
			  s UPLSRowId=rset.GetDataByName("UPLSRowId")    
	          s rtnval=JSFunName_"('"_ListName_"','"_$ZCVT($g(UPLSClassProperty),"O","JS")_"','"_$ZCVT($g(UPLSRowId),"O","JS")_"','"_$ZCVT($g(myIdx),"O","JS")_"');"
		  &javascript<#(rtnval)#>
		  s myIdx=myIdx+1
		}
		d rset.Close()
	}
	Q n
}

/// 删除记录日志的字段信息
ClassMethod DeleteUPLSProperty(UPLSRowId As %String) As %String
{
	q:UPLSRowId="" 100
	&sql(delete from SQLUser.DHCDocUpLogSet where UPLS_RowId=:UPLSRowId)
	Q SQLCODE
}

/// 取得记录日志的字段说明
ClassMethod GetUPLSPropertyDescription(UPLSRowId As %String) As %String
{
	q:UPLSRowId="" ""
	&sql(select UPLS_ClassPropertyDescription into:Description  from SQLUser.DHCDocUpLogSet where UPLS_RowId=:UPLSRowId)
	Q $g(Description)
}

/// 更新记录日志的字段说明
ClassMethod UpdateUPLSPropertyDescription(UPLSRowId As %String, Description As %String = "") As %String
{
	q:UPLSRowId="" 100
	&sql(update SQLUser.DHCDocUpLogSet set UPLS_ClassPropertyDescription=:Description where UPLS_RowId=:UPLSRowId)
	Q SQLCODE
}

/// 添加记录日志的字段
ClassMethod AddUPLSProperty(ClassName As %String, ClassProperty As %String) As %String
{
	Q:(ClassName="")||(ClassProperty="") 0
	s PropertyIndex = $o(^User.DHCDOCUPDATELS(0,"Class", ClassName, ""),-1)
	s PropertyIndex=+PropertyIndex+1
	&sql(select count(*) into:count  from SQLUser.DHCDocUpLogSet where UPLS_ClassName=:ClassName and UPLS_ClassProperty=:ClassProperty)
	Q:+$g(count)>0 "-100"
	&sql(insert SQLUser.DHCDocUpLogSet(UPLS_ClassName,UPLS_ClassProperty,UPLS_ClassPropertyIndex) values (:ClassName,:ClassProperty,:PropertyIndex))
	Q %ROWID
}

/// 修改记录日志的字段的顺序
ClassMethod ChangeUPLSClassPropertyIndex(UPLSRowId As %String, ChangeUPLSRowId As %String) As %String
{
	Q:(UPLSRowId="")||(ChangeUPLSRowId="") 100
	s UPLSIndex="",ChangeUPLSIndex=""
	&sql(select UPLS_ClassPropertyIndex into:UPLSIndex  from SQLUser.DHCDocUpLogSet where UPLS_RowId=:UPLSRowId)
	&sql(select UPLS_ClassPropertyIndex into:ChangeUPLSIndex  from SQLUser.DHCDocUpLogSet where UPLS_RowId=:ChangeUPLSRowId)
	if (UPLSIndex'="")&&(ChangeUPLSIndex'="")
	{
		&sql(update SQLUser.DHCDocUpLogSet set UPLS_ClassPropertyIndex=:ChangeUPLSIndex where UPLS_RowId=:UPLSRowId)
		&sql(update SQLUser.DHCDocUpLogSet set UPLS_ClassPropertyIndex=:UPLSIndex where UPLS_RowId=:ChangeUPLSRowId)
	}
	Q SQLCODE
}

/// desc 日志记录如果记录的表是带有指针的字段Name DHCDocUpLogSet中加入指针描述项来获得相关Value值
/// input ClassRowID所修改的记录的ID 修改的表名 修改的字段名  值
/// w ##class(web.DHCBL.Patient.DHCPatientUpdateLog).SetChangeValue(4,"User.PAPerson","PAPERSexDR",1)
ClassMethod SetChangeValue(TableRowID, UPDClassName, UPDClassProperty, InValue) As %String
{
	s ^TempzongHHHH=TableRowID_","_UPDClassName_","_UPDClassProperty_","_InValue
	s OutValue=InValue
	s $ZT="Error"
	;应该做日志的表记录ID数据为空返回原值
	Q:(TableRowID="")||(UPDClassName="")||(UPDClassProperty="")||(InValue="") OutValue
	s PropertyLink=""
	s sub1 =0
	f  s sub1 = $o(^User.DHCDOCUPDATELS(0,"Class", UPDClassName, sub1)) Q:(sub1="")||(PropertyLink'="")  d
	.s sub2=0 
	.f  s sub2 = $o(^User.DHCDOCUPDATELS(0,"Class", UPDClassName,sub1, sub2)) Q:(sub2="")||(PropertyLink'="")  d
	..s SubProperty=$P(^User.DHCDOCUPDATELS(sub2),"^",2)
	..Q:SubProperty'=UPDClassProperty
	..s PropertyLink=$P(^User.DHCDOCUPDATELS(sub2),"^",5)
	;非指针项目或者没有描述字段设定的返回原值
	Q:PropertyLink="" OutValue
	if (UPDClassName'="")&&(UPDClassProperty'="")
	{
		s ClassObj=$ZOBJCLASSMETHOD(UPDClassName,"%OpenId",TableRowID)
		if $IsObject(ClassObj)
		{
			s ValObj=$ZOBJPROPERTY(ClassObj,UPDClassProperty)
			;判断字段是否是索引结构
			if $IsObject(ValObj)
			{	s ClasSubName=$P(ValObj,"@",2)
				if ClasSubName'=""{
					s ClassObjSub=$ZOBJCLASSMETHOD(ClasSubName,"%OpenId",InValue)
					s OutValue=$ZOBJPROPERTY(ClassObjSub,PropertyLink)
				}
				 
			}	
		}	
	}
	Q OutValue
Error
	Q OutValue
}

/// 获取已做日志类属性的索引指针字段的表名和已有的字段名
/// w ##class(web.DHCBL.Patient.DHCPatientUpdateLog).PropertyLinkClassName(11)
ClassMethod PropertyLinkClassName(UPLSRowId As %String) As %String
{
	s $ZT="ErrorGetLink"
	s ReturnClassName=""
	Q:UPLSRowId="" ""
	s ClassName=$P($G(^User.DHCDOCUPDATELS(UPLSRowId)),"^",1)
	s SubProperty=$P($G(^User.DHCDOCUPDATELS(UPLSRowId)),"^",2)
	Q:(ClassName="")||(SubProperty="") ""
	Set rsltSt = ##class(%ResultSet).%New("%Dictionary.PropertyDefinition:Summary")
	do rsltSt.Execute(ClassName)
	While(rsltSt.Next()) {
		set propertyName=rsltSt.Data("Name")
		continue:SubProperty'=propertyName
		set propertyId=ClassName_"||"_propertyName
		set propObj=##class(%Dictionary.PropertyDefinition).%OpenId(propertyId)
		set propertyType=propObj.Type
		if ($l(propertyType,".")=1)&&($l(propertyType,"%")=1) {
			s propertyType="User."_propertyType
			s ReturnClassName=propertyType
		}	
	}
	q ReturnClassName
ErrorGetLink
  q ""
}

/// 获取已做日志类属性的索引指针字段的限定描述项字段名
/// w ##class(web.DHCBL.Patient.DHCPatientUpdateLog).PropertyLinkClassName(11)
ClassMethod GetPropertyLink(UPLSRowId As %String) As %String
{
	s PropertyLink=$P($G(^User.DHCDOCUPDATELS(UPLSRowId)),"^",5)
	Q PropertyLink
}

/// 保存已做日志类属性的索引指针字段的限定描述项字段名
ClassMethod SavePropertyLink(UPLSRowId As %String, PropertyLink As %String) As %String
{
	&sql(update SQLUser.DHCDocUpLogSet set UPLS_ClassPropertyLink=:PropertyLink where UPLS_RowId=:UPLSRowId)
	Q "0"
}

Query FindUPLSClassProperty(ClsName As %String) As %Query(ROWSPEC = "ID:%String,ClassName:%String,ClassProperty:%String,ClassPropertyDesc:%String,ClassPropertyIndex:%String,PropertyLinkName:%String")
{
}

ClassMethod FindUPLSClassPropertyExecute(ByRef qHandle As %Binary, ClsName As %String) As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1	
	s ClassName=0
	for {
		s ClassName=$o(^User.DHCDOCUPDATELS(0,"Class",ClassName))
		Quit:ClassName=""	
		continue:(ClsName'="")&&(ClsName'=ClassName)
		s PropertyIndex=0
	
		for 
		{
			s PropertyIndex = $o(^User.DHCDOCUPDATELS(0,"Class", ClassName, PropertyIndex))
			q:(PropertyIndex="")
			s UPLSRowId = $o(^User.DHCDOCUPDATELS(0,"Class", ClassName, PropertyIndex, ""))
			if UPLSRowId="" continue
			s LogSetObj = ##class(User.DHCDocUpLogSet).%OpenId(UPLSRowId)
			s ClassProperty="",ClassPropertyIndex="",PropertyLinkName="",ClassPropertyDesc=""
			if $IsObject(LogSetObj)
			{
				s ClassProperty = LogSetObj.UPLSClassProperty
				s ClassPropertyIndex = LogSetObj.UPLSClassPropertyIndex	
				s ClassPropertyDesc=LogSetObj.UPLSClassPropertyDescription
				s PropertyLinkName=LogSetObj.UPLSClassPropertyLink
			}
			d LogSetObj.%Close()
			d OutputRow				
		}
	}
	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(UPLSRowId,ClassName,ClassProperty,ClassPropertyDesc,ClassPropertyIndex,PropertyLinkName)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
}

ClassMethod FindUPLSClassPropertyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindUPLSClassPropertyExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindUPLSClassPropertyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindUPLSClassPropertyExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

Query FindClass(ClsName As %String) As %Query(ROWSPEC = "ClassName:%String")
{
}

ClassMethod FindClassExecute(ByRef qHandle As %Binary, ClsName As %String) As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1	
	i (ClsName="") Set qHandle=$lb(0,repid,0) Quit $$$OK
	s ClsName=$ZCVT(ClsName,"U")
	s ClassName=0
	for{
		s ClassName=$o(^oddDEF(ClassName))
		Quit:ClassName=""
		//continue:ClassName'["User."
		continue:ClassName["%"
		continue:($ZCVT(ClassName,"U")'[ClsName)
		do OutputRow1	
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(ClassName)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
}

ClassMethod FindClassClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindClassExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindClassFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindClassExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

Query SelectPropertyNew(ClsName As %String, Desc As %String) As %Query(ROWSPEC = "propertyName:%String,propertyType:%String,propertyField:%String")
{
}

/// do ##class(%ResultSet).RunQuery("web.DHCDocUpdateLog","SelectPropertyNew","websys.Preferences","")
ClassMethod SelectPropertyNewExecute(ByRef qHandle As %Binary, ClsName As %String, Desc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1	
	i (ClsName="") Set qHandle=$lb(0,repid,0) Quit $$$OK
	k ^TMP("PatientLogSetSelectProperty")
	s Desc=$ZCVT(Desc,"U")
	Set rsltSt = ##class(%ResultSet).%New("%Dictionary.PropertyDefinition:Summary")
	do rsltSt.Execute(ClsName)
	While(rsltSt.Next()) {
		set propertyName=rsltSt.Data("Name")
	
		continue:($ZCVT(propertyName,"U")'[Desc)&&(Desc'="")
		set propertyId=ClsName_"||"_propertyName
		set propObj=##class(%Dictionary.PropertyDefinition).%OpenId(propertyId)
		set propertyType=propObj.Type
		if ($l(propertyType,".")=1)&&($l(propertyType,"%")=1) s propertyType="User."_propertyType
		set propertyField=propObj.SqlFieldName
		i propertyField="" s propertyField=propertyName
		if (+propObj.Relationship=1) continue
		s ^TMP("PatientLogSetSelectProperty",propertyName)=$lb($g(propertyName),$g(propertyType),$g(propertyField))
	}
	s propertyName="" for  s propertyName=$o(^TMP("PatientLogSetSelectProperty",propertyName)) q:propertyName=""  d
	.set Data=^TMP("PatientLogSetSelectProperty",propertyName)
 	.Set ^CacheTemp(repid,ind)=Data
 	.set ind=ind+1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod SelectPropertyNewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectPropertyNewExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod SelectPropertyNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectPropertyNewExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

/// Creater lxz
/// 获取已做日志类属性的索引指针字段的表名和已有的字段名
/// w ##class(web.DHCDocUpdateLog).PropertyLinkClassNameNew("User.DHCRBApptSchedule","AS_ClinicGroup_DR")
ClassMethod PropertyLinkClassNameNew(ClassName As %String, SubProperty As %String) As %String
{
	s $ZT="ErrorGetLink1"
	s SubProperty=$tr(SubProperty,"_","")
	s ReturnClassName=""
	Q:(ClassName="")||(SubProperty="") ""
	Set rsltSt = ##class(%ResultSet).%New("%Dictionary.PropertyDefinition:Summary")
	do rsltSt.Execute(ClassName)
	While(rsltSt.Next()) {
		set propertyName=rsltSt.Data("Name")
		continue:SubProperty'=propertyName
		set propertyId=ClassName_"||"_propertyName
		set propObj=##class(%Dictionary.PropertyDefinition).%OpenId(propertyId)
		set propertyType=propObj.Type
		if (propertyType["User."){
			s ReturnClassName=propertyType
		}
		if ($l(propertyType,".")=1)&&($l(propertyType,"%")=1) {
			s propertyType="User."_propertyType
			s ReturnClassName=propertyType
		}	
	}
	q ReturnClassName
ErrorGetLink1
  q ""
}

ClassMethod SaveByJson(RowId As %String, JsonStr As %String)
{
	s ^dhcInsertByJson=JsonStr
	s jsonObj={}
	s jsonObj=jsonObj.%FromJSON(JsonStr)
	s ClassName=jsonObj.UPLSClassName
	s ClassProperty=jsonObj.UPLSClassProperty
	s PropertyIndex = $o(^User.DHCDOCUPDATELS(0,"Class", jsonObj.UPLSClassName, ""),-1)
	s jsonObj.UPLSClassPropertyIndex=+PropertyIndex+1
	
	if RowId=""{
		&sql(select count(*) into:count  from SQLUser.DHCDocUpLogSet where UPLS_ClassName=:ClassName and UPLS_ClassProperty=:ClassProperty)
	}else{
		&sql(select count(*) into:count  from SQLUser.DHCDocUpLogSet where UPLS_ClassName=:ClassName and UPLS_ClassProperty=:ClassProperty and UPLS_RowId<>:RowId)	
	}
	Q:+$g(count)>0 "-100"
	
	s myobj=##class(%Dictionary.CompiledClass).%OpenId("User.DHCDocUpLogSet")
	s myCount = myobj.Properties.Count()
	k PLIST
	s myParList=""
	f i=1:1:myCount {
		s mypropobj=myobj.Properties.GetAt(i)
		s PropertyName=mypropobj.Name
		continue:jsonObj.%GetTypeOf(PropertyName)="unassigned" 
		s val=jsonObj.%Get(PropertyName)
		s dataType=mypropobj.Type
		if dataType="%Library.Date"{
			s val=..%ZDH(val)	
		}
		s sqlNum=mypropobj.SqlColumnNumber
		s PLIST(sqlNum)=val
	}
	
	if '$d(PLIST) Quit -1
	if RowId=""{
		&sql(insert into SQLUSER.DHCDocUpLogSet values :PLIST())
	}else{
		&sql(update SQLUSER.DHCDocUpLogSet values :PLIST() where UPLS_RowId=:RowId)
	}
	Quit SQLCODE
}

/// w ##class(web.DHCBL.CARD.CardHardComManager).GetDataJson(13,^dhcGetCardTypeDataJson)
ClassMethod GetDataJson(RowId As %String, jsonFiledStr As %String)
{
	s ^dhcGetCardTypeDataJson=jsonFiledStr
	&sql(select * into :PLIST() from SQLUSER.DHCDocUpLogSet where UPLS_RowId=:RowId)
	if SQLCODE'=0 Quit ""
	s jsonFiled=##class(%Library.DynamicObject).%FromJSON(jsonFiledStr)
	s jsonData={}
	s myobj=##class(%Dictionary.CompiledClass).%OpenId("User.DHCDocUpLogSet")
	s myCount = myobj.Properties.Count()
	//k PLIST
	s myParList=""
	f i=1:1:myCount {
		s mypropobj=myobj.Properties.GetAt(i)
		s PropertyName=mypropobj.Name
		s dataType=mypropobj.Type
		continue:jsonFiled.%GetTypeOf(PropertyName)="unassigned" 
		s sqlNum=mypropobj.SqlColumnNumber
		continue:sqlNum=""
		s val=$g(PLIST(sqlNum))
		if dataType="%Library.Date"{
			s val=..%ZD(val)
		}
		
		s filedName=jsonFiled.%Get(PropertyName)
		do jsonData.%Set(filedName,val)
	}
	
	Quit jsonData.%ToJSON()
}

}
