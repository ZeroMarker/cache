///  名称：		EMRservice.BL.BLKBShareApprove
///  描述：		个人知识库分享审核BL层
///  编写者：	yejian
///  编写时间：	2019-6-19
Class EMRservice.BL.BLKBShareApprove Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator:	yejian
/// CreatDate:  2015-9-7
/// Desc:		获取所有未使用知识库信息
/// Input：		
/// Return：	dataset
/// Debug:		d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLKBShareApprove","SelectKBData")
Query SelectKBData() As %Query(ROWSPEC = "ID:%Integer,KnowledgeBaseID:%String,KBNodeID:%String,UserID:%String,Name:%String,path:%String,Status:%String,Remark:%String,AuditID:%String,AuditDate:%String")
{
}

ClassMethod SelectKBDataExecute(ByRef qHandle As %Binary) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	s strKBNodeID = ""
	for {
		s strKBNodeID = $o(^DHCEMRM.KBNodeShareI("IdxKBNodeID",strKBNodeID))
		q:(strKBNodeID = "")	
		s arowID = ""
		for {
			s arowID = $o(^DHCEMRM.KBNodeShareI("IdxKBNodeID",strKBNodeID,arowID))
			q:(arowID = "")
			s objKBNodeShare= ##Class(EMRmeta.KBNodeShare).%OpenId(arowID)
			q:((objKBNodeShare = ""))
			s objKBNode= ##Class(EMRmeta.KBNode).%OpenId(objKBNodeShare.KBNodeID)
			q:((objKBNode = ""))
			s ID = arowID
			s KnowledgeBaseID = objKBNode.KnowledgeBaseID
			s KBNodeID = objKBNodeShare.KBNodeID
			s Status = objKBNodeShare.Status
 			s Remark = objKBNodeShare.Remark
 			s AuditID = objKBNodeShare.AuditID
 			s AuditDate = objKBNodeShare.AuditDate
 			s aKBTree = ##Class(EMRmeta.KBTree).%OpenId(objKBNode.KBTreeID)
 			s userName = "",objUser=""
 			if (aKBTree '="")
 			{
 				s UserID = aKBTree.PersonalKBUserID
 				s:(UserID'="") objUser = ##class(User.SSUser).%OpenId(UserID)
				s:(objUser'="") userName =  $tr(objUser.SSUSRName,$c(13)_$c(10),"")_"("_UserID_")"
 			}
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
 			
 		
 			
			s Data = $lb(ID,KnowledgeBaseID,KBNodeID,userName,Name,path,Status,Remark,AuditID,AuditDate)
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

/// 修改个人知识库分享审核状态
/// do ##class(EMRservice.BL.BLUserTemplate).UpdateKBShareStatus("1","-1")
ClassMethod UpdateKBShareStatus(AKBNodeShareIDS As %String, AStatus As %String, aAuditID As %String, Remark As %String = "") As %String
{
	s Result = "-1"
	q:($g(AKBNodeShareIDS) = "") Result
	S IDCount =$L(AKBNodeShareIDS,"^")
	TSTART 
	For I=1:1:IDCount
	{
		s AKBNodeShareID = $p(AKBNodeShareIDS,"^",I)
		continue:(AKBNodeShareID="")
		s objKBNodeShare = ##Class(EMRmeta.KBNodeShare).%OpenId(AKBNodeShareID)
		q:(objKBNodeShare = "")
		s objKBNodeShare.Status =AStatus
		if ((Remark'="")&&(Remark'=$C(0)))
		{
			s objKBNodeShare.Remark =Remark
		}
		if ((aAuditID'="")&&(aAuditID'=$C(0)))
		{
			s objKBNodeShare.AuditID = aAuditID
			s objKBNodeShare.AuditDate =  $ZDATE($h,3)_" "_ $ZTIME($PIECE($H,",",2),1)
		}
		if (AStatus="-1")
		{
			s sc = ##class(EMRmeta.KBNodeShare).%DeleteId(AKBNodeShareID)
			if '($$$ISOK(sc)) 
			{
				TROLLBACK
				s Result = 0
				q 
			}
		}
		else
		{
			if '(objKBNodeShare.%Save())
			{
				TROLLBACK
				s Result = 0
				q 
			}
		}
	}
	if (Result = 0)
	{
		 TROLLBACK
		 quit 0
	}
	TCOMMIT
	s Result = "1"
	q Result
}

/// 更新一个备注
ClassMethod UpdateKBShare(aKBNodeShare As EMRservice.entity.EKBNodeShare) As %String
{
	set objKBNodeShare=##class(EMRmeta.KBNodeShare).%OpenId(aKBNodeShare.ID)
	quit:(objKBNodeShare="") "0"

	s objKBNodeShare.Remark=aKBNodeShare.Remark
	s objKBNodeShare.Status=aKBNodeShare.Status
	s objKBNodeShare.AuditID = aKBNodeShare.AuditID
	s objKBNodeShare.AuditDate =  $ZDATE($h,3)_" "_ $ZTIME($PIECE($H,",",2),1)
	if ($$$ISOK(sc))
	{
		s Result = "1"
	}
	else
	{
		s Result = "-1"
	}
	q Result
}

}
