Class web.HXGYCompliedProperty Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod GetClassPropertiesClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetClassPropertiesExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetClassPropertiesExecute(ByRef qHandle As %Binary, ClassName As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1

	//insert %ID property  into First Row
	Set SqlRowIdName = $s($d(^oddCOM(ClassName,55))#2:^(55),1:$s($d(^oddDEF(ClassName,55))#2:^(55),1:$g(^%qCacheObjectKey(1,"c",55))))
	If ($d(SqlRowIdName)="")
	{
		Set Name="ID"	
		Set SqlFieldName=""
	}
	Else
	{
		Set Name = "ID"
		if (SqlRowIdName = "1")
		{
			 Set SqlRowIdName = "%ID"
		}
		else
		{
			Set SqlFieldName = $d(SqlRowIdName)
		}
	}
	Set Type = "%String"
	Set Required = "1"
	Set Transient = "0"
	Set Calculated = "0"
	Set Description = ""
	Set MaxLen = "0"
	Set MinLen = "0"
	Set DisplayList = "" 
	Set ValueList = ""
	Set IsItem = "0"
	Set IsTableItem = "0"
	Set InitialExpression = ""
	Set SqlTableName = ""
	Set PropertyType = "P"
	Set IsParent = "0"
	
	Set Data = $LB(Name,Type,Required,Transient,Calculated,Description,
		MaxLen,MinLen,DisplayList,ValueList,IsItem,IsTableItem,InitialExpression,
		SqlFieldName,SqlTableName,PropertyType,IsParent)
		Set ^CacheTemp(repid,ind) = Data
		Set ind = ind + 1
	
	//add other property
	Set property = $Order(^oddCOM(ClassName,"a",""))
	While (property '= "")
	{
		If ($p(property,"%",2) '= "")
		{
			 Set property = $Order(^oddCOM(ClassName,"a",property))
			 continue
		}
		
		Set Name = property
		Set sType = $s($d(^oddCOM(ClassName,"a",property,5))#2:^(5),$d(^oddCOM($g(^(2),ClassName),"a",property,5))#2:^(5),1:$s($d(^oddDEF($g(^(2),ClassName),"a",property,5))#2:^(5),1:$g(^%qCacheObjectKey(1,"a",5))))
		Set Type = sType	

		If ($p(sType,"%",2) '="")
		{
			If ($Length(sType,".") > 1)
			{
				Set Type = "%"_$p(sType,".",2)	
			}
		}
		
		Set Required = $s($d(^oddCOM(ClassName,"a",property,37))#2:^(37),$d(^oddCOM($g(^(2),ClassName),"a",property,37))#2:^(37),1:$s($d(^oddDEF($g(^(2),ClassName),"a",property,37))#2:^(37),1:$g(^%qCacheObjectKey(1,"a",37))))
		Set Transient = $s($d(^oddCOM(ClassName,"a",property,51))#2:^(51),$d(^oddCOM($g(^(2),ClassName),"a",property,51))#2:^(51),1:$s($d(^oddDEF($g(^(2),ClassName),"a",property,51))#2:^(51),1:$g(^%qCacheObjectKey(1,"a",51))))
		Set Calculated = $s($d(^oddCOM(ClassName,"a",property,23))#2:^(23),$d(^oddCOM($g(^(2),ClassName),"a",property,23))#2:^(23),1:$s($d(^oddDEF($g(^(2),ClassName),"a",property,23))#2:^(23),1:$g(^%qCacheObjectKey(1,"a",23))))
		Set Description = $s($d(^oddCOM(ClassName,"a",property,4))#2:^(4),$d(^oddCOM($g(^(2),ClassName),"a",property,4))#2:^(4),1:$s($d(^oddDEF($g(^(2),ClassName),"a",property,4))#2:^(4),1:$g(^%qCacheObjectKey(1,"a",4))))
		Set MaxLen = $d(^oddCOM(ClassName,"a",property,"MAXLEN"))
		Set MinLen = $d(^oddCOM(ClassName,"a",property,"MINLEN"))	
		Set DisplayList = $d(^oddCOM(ClassName,"a",property,"DISPLAYLIST"))
		Set ValueList = $d(^oddCOM(ClassName,"a",property,"VALUELIST"))
		Set IsItem = "0"
		Set IsTableItem = "0"
		Set InitialExpression = $s($d(^oddCOM(ClassName,"a",property,31))#2:^(31),$d(^oddCOM($g(^(2),ClassName),"a",property,31))#2:^(31),1:$s($d(^oddDEF($g(^(2),ClassName),"a",property,31))#2:^(31),1:$g(^%qCacheObjectKey(1,"a",31))))
		Set SqlFieldName = $s($d(^oddCOM(ClassName,"a",property,47))#2:^(47),$d(^oddCOM($g(^(2),ClassName),"a",property,47))#2:^(47),1:$s($d(^oddDEF($g(^(2),ClassName),"a",property,47))#2:^(47),1:$g(^%qCacheObjectKey(1,"a",47))))
		Set SqlTableName = $s($d(^oddCOM(ClassName,58))#2:^(58),1:$s($d(^oddDEF(ClassName,58))#2:^(58),1:$g(^%qCacheObjectKey(1,"c",58))))
		
		Set oParent = $s($d(^oddCOM(ClassName,"a",property,24))#2:^(24),$d(^oddCOM($g(^(2),ClassName),"a",property,24))#2:^(24),1:$s($d(^oddDEF($g(^(2),ClassName),"a",property,24))#2:^(24),1:$g(^%qCacheObjectKey(1,"a",24))))
		if (oParent = "children")
		{
			Set IsParent = "0"	
		}
		else
		{
			Set IsParent = "1"	
		}
		Set isRelation = $s($d(^oddCOM(ClassName,"a",property,36))#2:^(36),$d(^oddCOM($g(^(2),ClassName),"a",property,36))#2:^(36),1:$s($d(^oddDEF($g(^(2),ClassName),"a",property,36))#2:^(36),1:$g(^%qCacheObjectKey(1,"a",36))))
		if (isRelation = "1")
		{
			Set PropertyType = "R"	
		}
		elseif ($p(sType,"%",2) '= "")
		{
			Set PropertyType = "P"	
		}
		else
		{
			Set PropertyType = "O"
		}
	
		Set Data = $LB(Name,Type,Required,Transient,Calculated,Description,
		MaxLen,MinLen,DisplayList,ValueList,IsItem,IsTableItem,InitialExpression,
		SqlFieldName,SqlTableName,PropertyType,IsParent)
		Set ^CacheTemp(repid,ind) = Data
		Set ind = ind + 1
		Set property = $Order(^oddCOM(ClassName,"a",property))
	} 		
 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod GetClassPropertiesFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetClassPropertiesExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind=""
 	{				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else    
 	 {				
 		Set Row=^CacheTemp(repid,ind)
 	}

 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query GetClassProperties(ClassName As %String) As %Query(ROWSPEC = "Name:%String,Type:%String,Required:%Boolean,Transient:%Boolean,Calculated:%Boolean,Description:%String,MaxLen:%String,MinLen:%String,DisplayList:%String,ValueList:%String,IsItem:%String,IsTableItem:%String,InitialExpression:%String,SqlFieldName:%String,SqlTableName:%String,PropertyType:%String,IsParent:%String") [ SqlName = HXGYCompliedProperty_GetClassProperties, SqlProc ]
{
}

ClassMethod SPGetProperties(ClassName As %String)
{
	;d ##class(web.HXGYCompliedProperty).SPGetProperties("User.DHCCardRef")
	Set rst = ##class(%ResultSet).%New("web.HXGYCompliedProperty:GetClassProperties")
	Do rst.Execute(ClassName)
	
	While (rst.Next())
	{
		w rst.Get("Name"),"	,  ",rst.Get("Type"),"	,	",rst.Get("PropertyType"),!
	}
	
	//Quit rst
}

ClassMethod TranslateNullToEmpty(GlobalName As %String, Node As %String) [ SqlName = HXGYCompliedProperty_TranslateNullToEmpty, SqlProc ]
{
	;d ##class(web.HXGYCompliedProperty).TranslateNullToEmpty("^websys.ComponentItemsD","50555")
	Set next = $Order(@GlobalName@(Node,""))
	while (next '= "")
	{
		Set newdata = $LB("")
		Set nodedata = $Get(@GlobalName@(Node,next))
		Set len = $ListLength(nodedata)
		for i=2:1:len
		{
			If ($ListGet(nodedata,i)=$c(0))
			{
			
				Set newdata = newdata _ $LB("")
			}
			Else
			{
				if ((i=53)||(i=47)) ;LookupUserDefine
				{
					if ($ListGet(nodedata,i) = "1")	
					Set newdata= newdata _ $LB("")
				}
				else
				{
					Set newdata= newdata _ $LB($ListGet(nodedata,i))
				}
			}			
		}
		//w newdata,!
		Set @GlobalName@(Node,next) = newdata
		Set next = $Order(@GlobalName@(Node,next))
	}
}

ClassMethod ExportClass(classNames As %String) [ SqlName = HXGYCompliedProperty_ExportClass, SqlProc ]
{
	d ##class(%SYSTEM.OBJ).Export(classNames,"c:\\ClassCollection.xml","","","")
}

ClassMethod ImportClass(filename As %String, classNames As %String) [ SqlName = HXGYCompliedProperty_ImportClass, SqlProc ]
{
	d ##class(%SYSTEM.OBJ).Load(filename,"","","","","")
	d ##class(%SYSTEM.OBJ).CompileList(classNames,"","")
}

ClassMethod ComplierClass(classNames As %String) [ SqlName = HXGYCompliedProperty_ComplierClass, SqlProc ]
{
	d ##class(%SYSTEM.OBJ).CompileList(classNames,"","")
}

ClassMethod ExportComponent(componentNames As %String) [ SqlName = HXGYCompliedProperty_ExportComponent, SqlProc ]
{
	; [ SqlName = HXGYCompliedProperty_ExportComponent, SqlProc ]
	k ^DHCComponent
	;s componentNames="DHCRBCReasonNotAvail"
	s len=$Length(componentNames,",")
	
	for i=1:1:len
	{
		s componentName=$p(componentNames,",",i)
		d GetComponent^DHCComponentTrans(componentName,componentName)
	}
	;d ##class(%SYSTEM.OBJ).Export("DHCComponent.GBL","c:\\DHCComponent.gsa","","","")
}

ClassMethod ImportComponent(filename As %String, componentNames As %String) [ SqlName = HXGYCompliedProperty_ImportComponent, SqlProc ]
{
	k ^DHCComponent
	d ##class(%SYSTEM.OBJ).Load(filename,"","","","","")
	s len=$Length(componentNames,",")
	for i=1:1:len
	{
		s componentName=$p(componentNames,",",i)
		d PutComponentP7^DHCComponentTrans(componentName)
	}
}

}
