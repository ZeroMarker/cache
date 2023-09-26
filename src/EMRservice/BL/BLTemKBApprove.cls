Class EMRservice.BL.BLTemKBApprove Extends (%RegisteredObject, %XML.Adaptor)
{

Query SELECTALL() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,UserID:%String,Remark:%String,RelationID:%String,Type:%String,Status:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_EMR_TEMKBA_SELECTALL, SqlProc ]
{
	SELECT ID,UserID,Remark,RelationID,Type,Status
	FROM EMRmeta.TemKBApprove
}

Query SelectByID(aID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,UserID:%String,Remark:%String,RelationID:%String,Type:%String,Status:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_EMR_TEMKBA_SELECTBYID, SqlProc ]
{
	SELECT ID,UserID,Remark,RelationID,Type,Status
	FROM EMRmeta.TemKBApprove
	WHERE ID =:aID
}

/// 创建一个备注
ClassMethod CreateTemKB(aTemKBApprove As EMRservice.entity.ETemKBApprove) As %String
{
	set objTemKBApprove=##class(EMRmeta.TemKBApprove).%New()
	quit:(objTemKBApprove="") ""
	
	set objTemKBApprove.Type=aTemKBApprove.Type
	set objTemKBApprove.RelationID=aTemKBApprove.RelationID
	set objTemKBApprove.Remark=aTemKBApprove.Remark
	set objTemKBApprove.Status=aTemKBApprove.Status
	set objTemKBApprove.UserID=aTemKBApprove.UserID
	s sc = objTemKBApprove.%Save()
	if ($$$ISOK(sc))
	{
		quit objTemKBApprove.%Id()
	}
	else
	{
		 quit "-1"
	}
}

/// 删除一个备注
ClassMethod DeleteTemKBByID(aTemKBId As %String) As %String [ WebMethod ]
{
	q:(aTemKBId ="") "-1"
	s objaTemKBId = ##Class(EMRmeta.TemKBApprove).%OpenId(aTemKBId)
	q:(objaTemKBId="") "-1"
	s sc = ##class(EMRmeta.TemKBApprove).%DeleteId(aTemKBId)
	if ($$$ISOK(sc))
	{
		q (+sc)
	}
	else
	{
		q "-1"
	}
}

/// 更新一个备注
ClassMethod UpdateTemKB(aTemKBApprove As EMRservice.entity.ETemKBApprove) As %String
{
	set objTemKBApprove=##class(EMRmeta.TemKBApprove).%OpenId(aTemKBApprove.ID)
	quit:(objTemKBApprove="") "0"

	
	set objTemKBApprove.Type=aTemKBApprove.Type
	set objTemKBApprove.RelationID=aTemKBApprove.RelationID
	set objTemKBApprove.Remark=aTemKBApprove.Remark
	s ^globUpdateTemKB = aTemKBApprove.Status
	set objTemKBApprove.Status=aTemKBApprove.Status
	set objTemKBApprove.UserID=aTemKBApprove.UserID
	s sc = objTemKBApprove.%Save()
	if ($$$ISOK(sc))
	{

		q (objTemKBApprove.%Id())
	}
	else
	{

		 quit "-1"
	}
}

/// d ##Class(EMRservice.BL.BLTemKBApprove).TemPublishVersion("^71")
ClassMethod TemPublishVersion(AVerionIDS As %String) As %String
{
	s Result = "-1"
	q:(AVerionIDS="") Result
	S IDCount =$L(AVerionIDS,"^")
	TSTART 
	For I=1:1:IDCount
	{
		s AVerionID = $p(AVerionIDS,"^",I)
		continue:(AVerionID="")
		s objTemplateVersion = ##class(EMRmeta.TemplateVersion).%OpenId(AVerionID)
		s objTemplateVersion.Status = 2
		s objTemplateVersion.PublicationDate =$ZDATEH($ZDATE($HOROLOG))
		s objTemplateVersion.PublicationTime = $ZTIMEH($ZTIME($PIECE($HOROLOG,",",2),1))
		s objTemplateVersion.LastSaveDate = $ZDATEH($ZDATE($HOROLOG))
		s objTemplateVersion.LastSaveTime = $ZTIMEH($ZTIME($PIECE($HOROLOG,",",2),1))
		s objTemplate = ##class(EMRmeta.Template).%OpenId(objTemplateVersion.TemplateID)
		s objTemplate.PublishVersion = objTemplateVersion.VersionNumber
		if '(objTemplate.%Save())
		{
			TROLLBACK
			s Result = 0
			q 
		}
		if '(objTemplateVersion.%Save())
		{
			TROLLBACK
			s Result = 0
			q 
		} 
	}
	if (Result = 0)
	{
		 TROLLBACK
		 quit 0
	}
	TCOMMIT
	s Result = "1"
	Quit Result
}

/// d ##Class(EMRservice.BL.BLTemKBApprove).KBPublish("^71")
ClassMethod KBPublish(AKBNodeIDS As %String) As %String
{
	s Result = "-1"
	q:(AKBNodeIDS="") Result
	S IDCount =$L(AKBNodeIDS,"^")
	TSTART 
	For I=1:1:IDCount
	{
		s AKBNodeID = $p(AKBNodeIDS,"^",I)
		continue:(AKBNodeID="")
		s objKBNode = ##Class(EMRmeta.KBNode).%OpenId(AKBNodeID)
		if (objKBNode = "")
		{
			TROLLBACK
			s Result = 0
			q 
		}
		s objKBNode.IsInUse = "Y"
		if '(objKBNode.%Save())
		{
			TROLLBACK
			s Result = 0
			q 
		}
	}
	if (Result = 0)
	{
		 TROLLBACK
		 quit 0
	}
	TCOMMIT
	s Result = "1"
	Quit Result
}

/*
Query SelectTemData() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,TemplateID:%String,VersionNumber:%String,Author:%String,Name:%String,Status:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_EMR_TEMKBA_SELECTTEMDATA, SqlProc ]
{
	SELECT v.ID, v.TemplateID,v.VersionNumber,v.Author,t.Name,V.Status
	from EMRmeta.TemplateVersion v JOIN EMRmeta.Template t
	ON v.TemplateID = t.ID  WHERE v.Status = 1
}
*/
/// Creator:	yejian
/// CreatDate:  2015-9-7
/// Desc:		获取所有未发布模板信息
/// Input：		
/// Return：	dataset
/// Debug:		d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLTemKBApprove","SelectTemData")
Query SelectTemData() As %Query(ROWSPEC = "ID:%Integer,TemplateID:%String,VersionNumber:%String,Author:%String,Name:%String,DocumentType:%String,path:%String,temKBID:%Integer,Remark:%String,temKBStatus:%String")
{
}

ClassMethod SelectTemDataExecute(ByRef qHandle As %Binary) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	s strTemID = ""
	for {
		s strTemID = $o(^DHCEMRM.TemplateVersionI("IndexTemplateVersion",strTemID))
		q:(strTemID = "")	
		s strVerNum = ""
		for {
			s strVerNum = $o(^DHCEMRM.TemplateVersionI("IndexTemplateVersion",strTemID,strVerNum))
			q:(strVerNum = "")
			s arowID = ""
			for {
				s arowID = $o(^DHCEMRM.TemplateVersionI("IndexTemplateVersion",strTemID,strVerNum,arowID))
				q:(arowID = "")
				s objTemVersioin = ##Class(EMRmeta.TemplateVersion).%OpenId(arowID)
				continue:((objTemVersioin = "") ||(objTemVersioin.Status '= "1"))
				s objTemplate = ##Class(EMRmeta.Template).%OpenId(objTemVersioin.TemplateID)
				q:(objTemplate = "")
				s ID = arowID
				s TemplateID = objTemVersioin.TemplateID
				s VersionNumber = $tr(strVerNum," ")
				s Author = objTemVersioin.Author
				s Name = objTemplate.Name
				S DocumentType = objTemplate.DocumentType
				s path = Name				
				Set key = objTemplate.TemplateCategoryID
	 			do
	 			{ 
					s objTemplateCate = ##Class(EMRmeta.TemplateCategory).%OpenId(key)
					q:(objTemplateCate = "")
					s key = objTemplateCate.ParentID
					s path = objTemplateCate.Name _"/"_path
	 			} 
	 			while (key '="0" )
	 			
	 			s temKBID = ""
	 			s Remark = ""
	 			s temKBStatus = ""
	 			s aTemKBrowID = ""
	 			s aTemKBrowID = $o(^DHCEMRM.TemKBApproveI("IdxTypeReID"," TEMPLATE"," "_ID,aTemKBrowID))
				if (aTemKBrowID '= "")
	 			{
		 			s aTemKBrowID = $tr(aTemKBrowID," ")
	 				s objTemKB= ##Class(EMRmeta.TemKBApprove).%OpenId(aTemKBrowID)
	 				s temKBID = aTemKBrowID
	 				s Remark = objTemKB.Remark
	 				s temKBStatus = objTemKB.Status
	 			}
				s Data = $lb(ID,TemplateID,VersionNumber,Author,Name,DocumentType,path,temKBID,Remark,temKBStatus)
				s ^CacheTemp(repid,ind) = Data
				s ind = ind + 1
			}
		}
	}
	q $$$OK
}

ClassMethod SelectTemDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectTemDataExecute ]
{
	s AtEnd=$list(qHandle,1)
 	s repid=$list(qHandle,2)
 	s ind=$list(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	if ind="" {	
 		s AtEnd=1
 		s Row=""
 		k ^CacheTemp(repid)
 	} else {
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod SelectTemDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectTemDataExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/*
Query SelectKBData() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,KnowledgeBaseID:%String,KBTreeID:%String,UserID:%String,Name:%String,IsInUse:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_EMR_TEMKBA_SELECTKBDATA, SqlProc ]
{
	SELECT k.ID,k.KnowledgeBaseID,k.KBTreeID,k.UserID,k.Name,k.IsInUse 
	FROM EMRmeta.KBNode k 
	WHERE k.IsInUse = 'N'
}
*/
/// Creator:	yejian
/// CreatDate:  2015-9-7
/// Desc:		获取所有未使用知识库信息
/// Input：		
/// Return：	dataset
/// Debug:		d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLTemKBApprove","SelectKBData")
Query SelectKBData() As %Query(ROWSPEC = "ID:%Integer,KnowledgeBaseID:%String,KBTreeID:%String,UserID:%String,Name:%String,path:%String,temKBID:%String,Remark:%String,temKBStatus:%String")
{
}

ClassMethod SelectKBDataExecute(ByRef qHandle As %Binary) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	s strKBBaseID = ""
	for {
		s strKBBaseID = $o(^DHCEMRM.KBNodeI("IdxKBKnowledgeBaseID",strKBBaseID))
		q:(strKBBaseID = "")	
		s arowID = ""
		for {
			s arowID = $o(^DHCEMRM.KBNodeI("IdxKBKnowledgeBaseID",strKBBaseID,arowID))
			q:(arowID = "")
			s objKBNode = ##Class(EMRmeta.KBNode).%OpenId(arowID)
			continue:((objKBNode = "") ||(objKBNode.IsInUse = "Y"))
			s ID = arowID
			s KnowledgeBaseID = $tr(strKBBaseID," ")
			s KBTreeID = objKBNode.KBTreeID
			s UserID = objKBNode.UserID
			s Name = objKBNode.Name
			s path = Name				
			Set key = objKBNode.KBTreeID
 			do
 			{ 
				s objKBTree = ##Class(EMRmeta.KBTree).%OpenId(key)
				q:(objKBTree = "")
				s key = objKBTree.ParentID
				s strName = $case(objKBTree.Name,$c(0):" ",:objKBTree.Name)
				s path = strName _"/"_path
 			} 
 			while (key '="0" )
 			
 			s objKBBase = ##Class(EMRmeta.KnowledgeBase).%OpenId(KnowledgeBaseID)
			q:(objKBBase = "")
			s path = objKBBase.Name _"/"_path
 			Set keyBC = objKBBase.KBCategoryID
 			do
 			{ 
				s objKBCate = ##Class(EMRmeta.KBCategory).%OpenId(keyBC)
				q:(objKBCate = "")
				s keyBC = objKBCate.ParentID
				s strName = $case(objKBCate.Name,$c(0):" ",:objKBCate.Name)
				s path =strName _"/"_path
 			} 
 			while (keyBC '="0" )
 			
 			s temKBID = ""
 			s Remark = ""
 			s temKBStatus = ""
 			s aTemKBrowID = ""
 			s aTemKBrowID = $o(^DHCEMRM.TemKBApproveI("IdxTypeReID"," KB"," "_ID,aTemKBrowID))
			if (aTemKBrowID '= "")
 			{
	 			s aTemKBrowID = $tr(aTemKBrowID," ")
 				s objTemKB= ##Class(EMRmeta.TemKBApprove).%OpenId(aTemKBrowID)
 				s temKBID = aTemKBrowID
 				s Remark = objTemKB.Remark
 				s temKBStatus = objTemKB.Status
 			}
 			
			s Data = $lb(ID,KnowledgeBaseID,KBTreeID,UserID,Name,path,temKBID,Remark,temKBStatus)
			s ^CacheTemp(repid,ind) = Data
			s ind = ind + 1
		}
		
	}
	q $$$OK
}

ClassMethod SelectKBDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectKBDataExecute ]
{
	s AtEnd=$list(qHandle,1)
 	s repid=$list(qHandle,2)
 	s ind=$list(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	if ind="" {	
 		s AtEnd=1
 		s Row=""
 		k ^CacheTemp(repid)
 	} else {
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod SelectKBDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectKBDataExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

}
