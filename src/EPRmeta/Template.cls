Class EPRmeta.Template Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

Index TplGuidIdx On GUID [ Unique ];

Property BindPrintName As %String(TRUNCATE = 1);

Property BindPrintTemplateID As %String(TRUNCATE = 1);

Property ChartItemType As %String(TRUNCATE = 1);

Property Description As %String(MAXLEN = 200, TRUNCATE = 1);

Property GUID As %String(MAXLEN = 36, TRUNCATE = 1);

/// 最后保存版本
Property LastVersion As %Integer;

Property Name As %String(MAXLEN = 200, TRUNCATE = 1);

/// 发布版本
Property PublishVersion As %Integer;

Property TemplateCategoryID As %String(TRUNCATE = 1);

/// the GroupName from EPRmeta.TemplatePriv.TemplateGroup
/// one template can be only set to one template group
/// see method TemplateGroupNameGet()
Property TemplateGroupName As %String(TRUNCATE = 1) [ Calculated, ReadOnly ];

Property TemplateProperty As %String(TRUNCATE = 1);

Index IndexCategoryId On TemplateCategoryID;

ClassMethod GetIDBYCATEGORY(ACategoryID As %String, AEpisodeType As %String) As %String
{
 new Result	 
 New NumCount
 &sql(SELECT Count(ID)
 into :NumCount
 FROM EPRmeta.Template
 WHERE TemplateCategoryID = :ACategoryID
 And TemplateProperty = :AEpisodeType )
 if ('NumCount=0)
 {
 &sql(SELECT ID
 into :Result
 FROM EPRmeta.Template
 WHERE TemplateCategoryID = :ACategoryID
 And TemplateProperty = :AEpisodeType) 
 QUIT Result	  
	  }
 elseif (NumCount=0)
 {
	Quit "" 	 }
}

ClassMethod GetReplaceIDBYCATEGORY(ACategoryID As %String, AName As %String) As %String
{
 new Result	 
 New NumCount
 &sql(SELECT Count(ID)
 into :NumCount
 FROM EPRmeta.Template
 WHERE TemplateCategoryID = :ACategoryID
 And Name =:AName
 )
 if ('NumCount=0)
 {
 &sql(SELECT ID
 into :Result
 FROM EPRmeta.Template
 WHERE TemplateCategoryID = :ACategoryID
 And Name =:AName ) 
 QUIT Result
	  
	  }
 elseif (NumCount=0)
 {
	Quit "" 	 }
}

ClassMethod GetTitleBYID(AID As %String) As %String
{
 new Result	 
 &sql(SELECT Name
 into :Result 
 FROM EPRmeta.Template
 WHERE ID = :AID)
 QUIT Result
}

ClassMethod GetVersionBYID(AID As %String) As %Integer
{
 new Result	 
 &sql(SELECT PublishVersion
 into :Result 
 FROM EPRmeta.Template
 WHERE ID = :AID)
 QUIT Result
}

ClassMethod SELECTBYGUID(AGUID As %String) As %String
{
 new Result	 
 &sql(SELECT ID
 into :Result 
 FROM EPRmeta.Template
 WHERE GUID = :AGUID)
 QUIT Result
}

Method TemplateGroupNameGet() As %String
{
	q ##class(EPRservice.TemplatePriv.BOTemplateGroup).GetGroupNameByTemplateID(##this.%Id())
}

Query SELECTALLByCategoryID(ACategoryID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,Name:%String,GUID:%String,TemplateCategoryID:%String,Description:%String,PublishVersion:%Integer,LastVersion:%Integer,ChartItemType:%String,BindPrintTemplateID:%String,BindPrintName:%String,TemplateProperty:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_Template_SELECTALLByCategoryID, SqlProc ]
{
SELECT ID, Name, GUID,TemplateCategoryID, Description,PublishVersion,LastVersion,ChartItemType,BindPrintTemplateID,BindPrintName,TemplateProperty
 FROM EPRmeta.Template
 WHERE TemplateCategoryID = :ACategoryID 
 ORDER BY ID
}

Query SelectForSltByCId(ACategoryID As %String, AEpisodeID As %String) As %Query(ROWSPEC = "ID:%String,Name:%String,GUID:%String,TemplateCategoryID:%String,Description:%String,PublishVersion:%String,LastVersion:%String,ChartItemType:%String,BindPrintTemplateID:%String,BindPrintName:%String,TemplateProperty:%String")
{
}

ClassMethod SelectForSltByCIdExecute(ByRef qHandle As %Binary, ACategoryID As %String, AEpisodeID As %String) As %Status
{
	//b "s"
	
	Set repid=$I(^CacheTemp)
	s ind=1
	s qHandle=""
 	s checkResult=""
 	s TemplateId="0"
 	s RowList="" 	
 	s TPrivActivity = ##class(EPRservice.TPrivLogic.PrivLogic).CheckTPrivActivity()
	i TPrivActivity'="N"  d
 	.f  s TemplateId=$o(^DHCEPRM.TemplateI("IndexCategoryId"," "_ACategoryID,TemplateId))  q:TemplateId=""  d
 	..s checkResult = ##class(EPRservice.TPrivLogic.PrivLogic).CheckTempValid(AEpisodeID,"",TemplateId)
 	..q:checkResult'=1  d
 	..s objTemplate=##Class(EPRmeta.Template).%OpenId(TemplateId)
 	..s Name=objTemplate.Name
 	..s GUID = objTemplate.GUID 
 	..s TemplateCategoryID =objTemplate.TemplateCategoryID
 	..s Description = objTemplate.Description
 	..s PublishVersion =objTemplate.PublishVersion
 	..s LastVersion =objTemplate.LastVersion
 	..s ChartItemType =objTemplate.ChartItemType
 	..s BindPrintTemplateID =objTemplate.BindPrintTemplateID
 	..s BindPrintName =objTemplate.BindPrintName
 	..s TemplateProperty =objTemplate.TemplateProperty
 	..s Data = $lb(TemplateId,Name,GUID,TemplateCategoryID,Description,PublishVersion,LastVersion,ChartItemType,BindPrintTemplateID,BindPrintName,TemplateProperty)
    ..S ^CacheTemp(repid,ind)=Data	
    ..S ind=ind+1
 	e  d
 	.f  s TemplateId=$o(^DHCEPRM.TemplateI("IndexCategoryId"," "_ACategoryID,TemplateId))  q:TemplateId=""  d
 	..s objTemplate=##Class(EPRmeta.Template).%OpenId(TemplateId)
 	..s Name=objTemplate.Name
 	..s GUID =objTemplate.GUID 
 	..s TemplateCategoryID =objTemplate.TemplateCategoryID
 	..s Description = objTemplate.Description
 	..s PublishVersion =objTemplate.PublishVersion
 	..s LastVersion =objTemplate.LastVersion
 	..s ChartItemType =objTemplate.ChartItemType
 	..s BindPrintTemplateID =objTemplate.BindPrintTemplateID
 	..s BindPrintName =objTemplate.BindPrintName
 	..s TemplateProperty =objTemplate.TemplateProperty
 	..s Data = $lb(TemplateId,Name,GUID,TemplateCategoryID,Description,PublishVersion,LastVersion,ChartItemType,BindPrintTemplateID,BindPrintName,TemplateProperty)
    ..S ^CacheTemp(repid,ind)=Data	
    ..S ind=ind+1
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod SelectForSltByCIdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectForSltByCIdExecute ]
{
	s qHandle="" 
	Quit $$$OK
}

ClassMethod SelectForSltByCIdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectForSltByCIdExecute ]
{
 Set AtEnd=$li(qHandle,1)
 Set repid=$li(qHandle,2)
 Set ind=$li(qHandle,3)

 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {	// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {	// fetch row
 Set Row=^CacheTemp(repid,ind)
 }

 // Save QHandle
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

/*
Query SelectForSltByCId(ACategoryID As %String, AEpisodeID As %String) As %Query(ROWSPEC = "ID:%Integer,Name:%String,GUID:%String,TemplateCategoryID:%String,Description:%String,PublishVersion:%Integer,LastVersion:%Integer,ChartItemType:%String,BindPrintTemplateID:%String,BindPrintName:%String,TemplateProperty:%String") [ SqlName = SP_Template_SelectForSltByCID, SqlProc ]
{


}

ClassMethod SelectForSltByCIdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectForSltByCIdExecute ]
{
    s qHandle="" 
	Quit $$$OK
}

ClassMethod SelectForSltByCIdExecute(ByRef qHandle As %Binary, ACategoryID As %String, AEpisodeID As %String) As %Status
{
	S result = ##class(%Library.ResultSet).%New()
    S sql = "SELECT ? as EpisodeID,ID as TId, Name, GUID,TemplateCategoryID, Description,PublishVersion,LastVersion,ChartItemType,BindPrintTemplateID,BindPrintName,TemplateProperty FROM EPRmeta.Template WHERE TemplateCategoryID = ? ORDER BY TId"
    d result.Prepare(sql)
    d result.Execute(AEpisodeID,ACategoryID)
    
    s qHandle=result
    s qHandle("AEpisodeID")=AEpisodeID
    Quit $$$OK
}

ClassMethod SelectForSltByCIdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectForSltByCIdExecute ]
{
	//之所在在此处使用While的形式，主要是当某一TemplateId没有权限时，没有返回Row，同时AtEnd可能不为1，所以此时不能直接退出该函数
	s IsEnd = 'qHandle.Next()
	while (IsEnd '= 1)
	{
		s EpisodeID = qHandle.Data("EpisodeID") //即为SelectForSltByCIdExecute中的AEpisodeID
    s ID = qHandle.Data("TId")
		s Name = qHandle.Data("Name")
		s GUID = qHandle.Data("GUID")
		s TemplateCategoryID = qHandle.Data("TemplateCategoryID")
		s Description = qHandle.Data("Description")
		s PublishVersion = qHandle.Data("PublishVersion")
		s LastVersion = qHandle.Data("LastVersion")
		s ChartItemType = qHandle.Data("ChartItemType")
		s BindPrintTemplateID = qHandle.Data("BindPrintTemplateID")
		s BindPrintName = qHandle.Data("BindPrintName")
		s TemplateProperty = qHandle.Data("TemplateProperty")
		
		s TPrivActivity = ##class(EPRservice.TPrivLogic.PrivLogic).CheckTPrivActivity()
		if TPrivActivity = "N"
		{
			s checkResult = 1
		}
		else
		{
			s checkResult = ##class(EPRservice.TPrivLogic.PrivLogic).CheckTempValid(EpisodeID,"",ID)
		}
		if checkResult = 1
	    {
			s RowList = $lb(ID,Name,GUID,TemplateCategoryID,Description)
			s RowList = RowList_$lb(PublishVersion,LastVersion,ChartItemType)
			s RowList = RowList_$lb(BindPrintTemplateID,BindPrintName,TemplateProperty)
			
			s Row=RowList
			
			q
		}
		else
		{
			s IsEnd = 'qHandle.Next()	
		}
		
	}
	
	
	if (IsEnd = 1)
	{
		d qHandle.Close()
		s qHandle = ""
		s Row = ""
		s AtEnd=1
	}
	
	Quit $$$OK
}
*/

/*
Query SELECTALLWithGroupByCategoryID(ACategoryID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,Name:%String,GUID:%String,TemplateCategoryID:%String,Description:%String,PublishVersion:%Integer,LastVersion:%Integer,ChartItemType:%String,BindPrintTemplateID:%String,BindPrintName:%String,TemplateProperty:%String,GroupId:%String,GroupName:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_Template_SELECTALLWithGroupByCategoryID, SqlProc ]
{
SELECT t.ID, t.Name, t.GUID,t.TemplateCategoryID, t.Description,t.PublishVersion,t.LastVersion,t.ChartItemType,t.BindPrintTemplateID,t.BindPrintName,t.TemplateProperty,g.TemplateGroup,g.TemplateGroup->GroupName
 FROM EPRmeta.Template t
 left join EPRmeta_TemplatePriv.TemplatesInGroup g on (t.ID = g.template) where t.TemplateCategoryID = :ACategoryID
 ORDER BY t.ID
}
*/
/// delete related records in EPRmeta.TemplatePriv.TemplateGroup
/// OID: An object identifier for the object being deleted
ClassMethod %OnDelete(OID As %ObjectIdentity) As %Status
{
	s id=""
	s id=$lg(OID,1)
	q:(id="") 0
	q ##class(EPRmeta.TemplatePriv.TemplatesInGroup).DeleteByTemplateId($lg(OID,1))
}

Storage Default
{
<Data name="TemplateDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>GUID</Value>
</Value>
<Value name="4">
<Value>LastVersion</Value>
</Value>
<Value name="5">
<Value>Name</Value>
</Value>
<Value name="6">
<Value>PublishVersion</Value>
</Value>
<Value name="7">
<Value>TemplateCategoryID</Value>
</Value>
<Value name="8">
<Value>BindPrintTemplateID</Value>
</Value>
<Value name="9">
<Value>ChartItemType</Value>
</Value>
<Value name="10">
<Value>BindPrintName</Value>
</Value>
<Value name="11">
<Value>TemplateProperty</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.TemplateD</DataLocation>
<DefaultData>TemplateDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.TemplateD</IdLocation>
<IndexLocation>^DHCEPRM.TemplateI</IndexLocation>
<StreamLocation>^DHCEPRM.TemplateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
