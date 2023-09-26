Class DHCEPRRBAC.BL.BLOperationDefinition Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

//添加隐私域角色操作

ClassMethod CreateOperationDefinition(aOperationDefinition As DHCEPRRBAC.Entity.EOperationDefinition) As %String
{
		
	s obj = ##class(DHCEPRRBAC.META.OperationDefinition).%New()
	s obj.OpActive = aOperationDefinition.OpActive
	s obj.OpCode = aOperationDefinition.OpCode
	s obj.OpDesc = aOperationDefinition.OpDesc
	s obj.OpName = aOperationDefinition.OpName
	s obj.DefaultOp = aOperationDefinition.DefaultOp
	s sc = obj.%Save()
	if ($$$ISOK(sc))
	{
	   q obj.%Id()
	}
	else
	{		
		q "-1"
	}
}

//更新隐私域角色操作

ClassMethod UpdateOperationDefinition(aOperationDefinition As DHCEPRRBAC.Entity.EOperationDefinition) As %String
{
		
	s obj = ##class(DHCEPRRBAC.META.OperationDefinition).%OpenId(aOperationDefinition.ID)
	s obj.OpActive = aOperationDefinition.OpActive
	s obj.OpCode = aOperationDefinition.OpCode
	s obj.OpDesc = aOperationDefinition.OpDesc
	s obj.OpName = aOperationDefinition.OpName
	s obj.DefaultOp = aOperationDefinition.DefaultOp
	s sc = obj.%Save()
	if ($$$ISOK(sc))
	{
	   q obj.%Id()
	}
	else
	{		
		q "-1"
	}
}

//检查隐私域角色操作是否添加

ClassMethod CheckOperationDefinitionCode(aOpCode As %String) As %String
{
	 
	s rowID = ""
    s rowID = $o(^DHCEPRRBAC.META.OperDFI("IdxMain"," "_aOpCode,rowID))
	q rowID
}

//删除隐私域角色操作

ClassMethod DeleteOperationDefinition(aOperationDefinitionID As %String) As %String
{
	
	q:(aOperationDefinitionID ="") "-1"	
	s obj = ##Class(DHCEPRRBAC.META.OperationDefinition).%OpenId(aOperationDefinitionID)
	q:(obj="") "-1"
	s sc = ##class(DHCEPRRBAC.META.OperationDefinition).%DeleteId(aOperationDefinitionID)	
	if ($$$ISOK(sc))
	{
		q aOperationDefinitionID
	}
	else
	{
		q "-1"
	}
}

/// do ##class(%ResultSet).RunQuery("DHCEPRRBAC.BL.BLOperation","GetOperation")
Query GetOperation() As %Query(ROWSPEC = "ID:%String,OpName:%String,OpCode:%String,OpDesc:%String,OpActive:%String,DefaultOp:%String")
{
}

ClassMethod GetOperationExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
	
	s rowID = ""
	for	{
		s rowID = $o(^DHCEPRRBAC.META.OperDFD(rowID))
		q:(rowID = "")

		s obj = ##class(DHCEPRRBAC.META.OperationDefinition).%OpenId(rowID)
		s active = obj.OpActive
		
		//continue:((obj.OpActive '= "Y") && (obj.OpActive '= "1"))
		
		s name = obj.OpName
		s code = obj.OpCode
		s desc = obj.OpDesc
		s active = obj.OpActive
		s defaultOp = obj.DefaultOp
		
		s ^CacheTemp(repid,ind) = $lb(rowID,name,code,desc,active,defaultOp)
	    s ind=ind+1		
   }
   Quit $$$OK
}

ClassMethod GetOperationClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOperationExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetOperationFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOperationExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

}
