/// 名称：		EMRservice.BL.BLUserTemplateKBConfig
/// 描述：		知识关联用户模板BL层
/// 编写者：	yejian
/// 编写时间：	2016-8-2
Class EMRservice.BL.BLUserTemplateKBNode Extends (%RegisteredObject, %XML.Adaptor)
{

/// w ##Class(EMRservice.BL.BLUserTemplateKBNode).GetTreeIDByBaseIDCtLocID("1","1")
ClassMethod GetTreeIDByBaseIDCtLocID(aKBBaseID As %String, aCTLocID As %String) As %String
{
	s ret = ""
	q:(aKBBaseID = "")||(aCTLocID = "") ret
	s arowID = ""
	for {
		s arowID = $o(^DHCEMRM.KBTreeI("IdxKnowledgeBaseID"," "_aKBBaseID,arowID))
		q:(arowID = "")	
		s objKBTree = ##Class(EMRmeta.KBTree).%OpenId(arowID)
		q:(objKBTree = "")
		s alocRowID = ""
		s alocRowID = $o(^DHCEMRM.KBTreeCTLocI("IdxKBTreeCTLocID"," "_arowID," "_aCTLocID,alocRowID))
		continue:(alocRowID = "")	
		
		s objKBTreeCT = ##Class(EMRmeta.KBTreeCTLoc).%OpenId(alocRowID)
		q:(objKBTreeCT = "")
		s ret = arowID
		q
		
    }
	q ret
}

/// 根据科室ID获取用户模板
/// /////////用户模板科室////////////
/// Debug:	d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLUserTemplateKBNode","GetKBNodeSByUserTempCode","1")
Query GetKBNodeSByUserTempCode(aCode As %String) As %Query(ROWSPEC = "ID:%Integer,Code:%String,SectionCode:%String,CompositeCode:%String,KbBaseID:%String,KBNodeID:%String,ActiveFlag:%String")
{
}

ClassMethod GetKBNodeSByUserTempCodeExecute(ByRef qHandle As %Binary, aCode As %String) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	q:(($g(aCode) = "")||(aCode=$c(0))) $$$OK
	s rowID = ""
	for {
		s rowID = $o(^DHCEMRM.UserTemplateKBNodeI("IdxCode"," "_$zcvt(aCode,"U"),rowID))
		q:(rowID = "")
		s objUserTempKB = ##Class(EMRmeta.UserTemplateKBNode).%OpenId(rowID)
		continue:(objUserTempKB = "")
	
		s Code = objUserTempKB.Code
		s SectionCode = objUserTempKB.SectionCode
		s CompositeCode = objUserTempKB.CompositeCode
		s KbBaseID = objUserTempKB.KbBaseID
		s KBNodeID = objUserTempKB.KBNodeID
		s ActiveFlag = objUserTempKB.ActiveFlag
	
		s Data = $lb(rowID,Code,SectionCode,CompositeCode,KbBaseID,KBNodeID,ActiveFlag)
		s ^CacheTemp(repid,ind) = Data
		s ind = ind + 1	
		
	}
	
	q $$$OK
}

ClassMethod GetKBNodeSByUserTempCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetKBNodeSByUserTempCodeExecute ]
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

ClassMethod GetKBNodeSByUserTempCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetKBNodeSByUserTempCodeExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// 添加用户模板科室
ClassMethod AddUserTemplateKBNode(AUserTemplateKB As EMRservice.entity.EUserTemplateKBNode) As %String
{
	TStart
	s ret = 1

	s objUserTemKBNode = ##Class(EMRmeta.UserTemplateKBNode).%New()
	s objUserTemKBNode.Code =AUserTemplateKB.Code
	s objUserTemKBNode.SectionCode =AUserTemplateKB.SectionCode
	s objUserTemKBNode.CompositeCode =AUserTemplateKB.CompositeCode
	s objUserTemKBNode.KbBaseID =AUserTemplateKB.KbBaseID
	s objUserTemKBNode.KBNodeID =AUserTemplateKB.KBNodeID
	s objUserTemKBNode.ActiveFlag =AUserTemplateKB.ActiveFlag
	if (objUserTemKBNode.%Save())
	{
	    s ret=objUserTemKBNode.%Id()
	    TCommit
	}
	else
	{
	   TRollback
	   s ret=0
	}		

	d objUserTemKBNode.%Close()
	q ret
}

/// 修改用户模板科室
ClassMethod ModUserTemplateKBNode(AUserTemplateKB As EMRservice.entity.EUserTemplateKBNode) As %String
{
	TStart
	s ret = 1

	s objUserTemKBNode = ##Class(EMRmeta.UserTemplateKBNode).%OpenId(AUserTemplateKB.ID)
	;s objUserTemKBNode.Code =AUserTemplateKB.Code
	;s objUserTemKBNode.SectionCode =AUserTemplateKB.SectionCode
	s objUserTemKBNode.KbBaseID =AUserTemplateKB.KbBaseID
	s objUserTemKBNode.KBNodeID =AUserTemplateKB.KBNodeID
	s objUserTemKBNode.ActiveFlag =AUserTemplateKB.ActiveFlag
	if (objUserTemKBNode.%Save())
	{
	    s ret=objUserTemKBNode.%Id()
	    TCommit
	}
	else
	{
	   TRollback
	   s ret=0
	}		

	d objUserTemKBNode.%Close()
	q ret
}

/// 设为无效
ClassMethod Delete(RowID As %String) As %String
{
	s ret = 1
	q:(RowID="") ret
	//原有数据进行“删除”,将数据ActiveFlag设置为0
	s obj = ##class(EMRmeta.UserTemplateKBNode).%OpenId(RowID)
	s obj.ActiveFlag = 0
	
	if '(obj.%Save())
	{
		s ret = 0	
	}
	d obj.%Close()
	
	q ret
}

/// Desc:       保存知识库用户模板数据
/// Creator:    yejian
/// Createdate: 2017-11-18
/// Input:      argInData 模板文件流
///             TemplateVersionId   
/// Output:     result 1成功,-1失败 
/// w ##Class(EMRservice.BL.BLUserTemplateKBNode).SaveUserComposite()
ClassMethod SaveUserComposite(argInData As %GlobalBinaryStream, UserTemplateID As %String, SectionCode As %String, BindKBBaseID As %String, CompositeCode As %String, CompositeCodeList As %String, userID As %String, SectionName As %String, aKey As %String) As %String
{
	TStart
	s res = "-1"		
    q:((argInData = "")||(UserTemplateID = "")||(SectionCode = "")||(BindKBBaseID = "")||(aKey="")) result 
        
    s objUserTem = ##Class(EMRmeta.UserTemplate).%OpenId(UserTemplateID)
    q:(objUserTem="") res
    s Code = objUserTem.Code
    s rowCTID = ""
	s rowCTID = $o(^DHCEMRM.UserTemplateCTLocI("IdxCode"," "_$g(Code),rowCTID))
	s objUserTemCT = ##Class(EMRmeta.UserTemplateCTLoc).%OpenId(rowCTID)
	s CTLocID = objUserTemCT.CTLocID
	q:(CTLocID="") res
	//根据basei和科室ID获取kbtreeID
    s kbTreeID= ##Class(EMRservice.BL.BLUserTemplateKBNode).GetTreeIDByBaseIDCtLocID(BindKBBaseID,CTLocID)
    s KBNodeID =""
    if (kbTreeID="") 
    {
	    //如果kbtreeID为空，则新建一个并关联科室
	    /*
	   	s objKBTree = ##class(EMRmeta.KBTree).%New()
	 	s objKBTree.Name = SectionCode
	 	s objKBTree.ParentID = "0"
	 	s objKBTree.Description = SectionCode
	 	s objKBTree.KnowledgeBaseID = BindKBBaseID
	 	s objKBTree.ResChildCount = 0
		s objKBTree.IsActive = "0"
	 	if ('objKBTree.%Save())
	 	{
		   TRollback
		   s res="-1"
		}
		s kbTreeID = objKBTree.%Id()
	 	d ##class(EMRservice.BOKBTree).SaveSequence(kbTreeID)
	 	
		s objKBTreeCT = ##class(EMRmeta.KBTreeCTLoc).%New()
	 	s objKBTreeCT.KBTreeID = kbTreeID
	 	s objKBTreeCT.CTLocID = CTLocID
	 	s objKBTreeCT.ActiveFlag = "1"
	 	if ('objKBTreeCT.%Save())
	 	{
		   TRollback
		   s res="-1"
		}
	    */
    }
    //章节第一次处理时，把不包含在CompositeCodeList知识库节点和关系设为不可用,排序全设置为0
    d ..SetUserTemplateKBNode(UserTemplateID,Code,SectionCode,CompositeCodeList,aKey)
    
    s intSequence = 0
	&SQL(select max(Sequence) into :intSequence from EMRmeta.UserTemplateKBNode where Code =:Code AND SectionCode =:SectionCode)
    s intSequence = intSequence + 1
    s rowKBID = ""
    if (CompositeCode '="")
    {
    	s rowKBID = $o(^DHCEMRM.UserTemplateKBNodeI("IdxCodeSectionComposite"," "_$zcvt(Code,"U")," "_$zcvt(SectionCode,"U")," "_$zcvt(CompositeCode,"U") ,rowKBID)) 
    }
	if (rowKBID ="")
	{
		S objEKBNode = ##Class(EMRservice.entity.EKBNode).%New()
		s objEKBNode.Name =Code_"^"_SectionCode_"^"_intSequence
        s objEKBNode.KnowledgeBaseID = BindKBBaseID
        s objEKBNode.KBTreeID = kbTreeID
        s objEKBNode.IsCommon = "N"
        s objEKBNode.IsInUse = "Y"
        s objEKBNode.IsUserKBNode = "1"
		s KBNodeID = ##Class(EMRservice.BL.BLKBNode).CreateKBNode(objEKBNode)
		s objUserTemKBNode = ##Class(EMRmeta.UserTemplateKBNode).%New()
		s objUserTemKBNode.Code =Code
		s objUserTemKBNode.SectionCode =SectionCode
		s objUserTemKBNode.CompositeCode =CompositeCode
		s objUserTemKBNode.KbBaseID =BindKBBaseID
		s objUserTemKBNode.KBNodeID =KBNodeID
		s objUserTemKBNode.Sequence = intSequence
		s objUserTemKBNode.ActiveFlag ="1"
		if ('objUserTemKBNode.%Save())
		{
			TRollback
		   	s res="-1"
		}
	}
	else
	{
		s objUserTemKB = ##Class(EMRmeta.UserTemplateKBNode).%OpenId(rowKBID)
		S KBNodeID = objUserTemKB.KBNodeID
		s objUserTemKB.Sequence = intSequence
		if ('objUserTemKB.%Save())
		{
			TRollback
		   	s res="-1"
		}
	}
	if (KBNodeID'="")
	{
    	s res = ##Class(EMRservice.BL.BLKBNode).SaveComposite(argInData,KBNodeID,userID)
    	if (res'="-1")
    	{
	    	TCommit
    	}
	}
    q res
}

/// 章节第一次处理时，把不包含在CompositeCodeList知识库节点和关系设为不可用
/// Debug: s ret = ##Class(EMRservice.BL.BLUserTemplateKBConfig).SetUserTemplateKBNode(1)
ClassMethod SetUserTemplateKBNode(AUserTemID As %String, Code As %String, SectionCode As %String, CompositeCodeList As %String, aKey As %String) As %String
{
	s ret = ""
	q:((CompositeCodeList = "")||(Code = "")||(aKey ="")) ret
	s strSecs = $g(^CacheTempEMRUserTemKB(aKey,AUserTemID))
	q:(strSecs = SectionCode) ret
	s ^CacheTempEMRUserTemKB(aKey,AUserTemID) = SectionCode
	
	s CompositeCodeList= "^"_CompositeCodeList_"^"
	s rowID = ""
	for {
		s rowID = $o(^DHCEMRM.UserTemplateKBNodeI("IdxCodeSection"," "_$zcvt(Code,"U")," "_$zcvt(SectionCode,"U"),rowID))
		q:(rowID = "")
		s objUserTempKB = ##Class(EMRmeta.UserTemplateKBNode).%OpenId(rowID)
		continue:(objUserTempKB = "")
		
		s Code = objUserTempKB.Code
		s CompositeCode = objUserTempKB.CompositeCode
		s KBNodeID =objUserTempKB.KBNodeID
		s curComCode = "^"_CompositeCode_"^"
		//纯文本或者不包含在知识库编码字符集中
		if ((CompositeCode ="")||'(CompositeCodeList [ curComCode))
		{
			d ##Class(EMRservice.BL.BLKBNode).StopOrStartKBNode(KBNodeID,"N")
			s objUserTempKB.ActiveFlag = "0"
			s objUserTempKB.Sequence = 0
			d objUserTempKB.%Save()
		}
		else //把排序设置为0
		{
			s objUserTempKB.Sequence = 0
			d objUserTempKB.%Save()
		}
	}
	q ret
}

/// 清理临时global
ClassMethod ClearUserTemKBGlobal(aUserTemID As %String, aUserTKey As %String)
{
	k ^CacheTempEMRUserTemKB(aUserTKey,aUserTemID)
}

}
