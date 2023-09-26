Class EMRservice.BL.BLKBTree Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator:	yejian
/// CreatDate:  2016-10-9
/// Desc:		获取所有知识库数据
/// Input：		
/// Return：	dataset
/// Debug:		d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLKBTree","SELECTALL","1")
Query SELECTALL(AKnowledgeBaseID As %String) As %Query(ROWSPEC = "ID:%Integer,Name:%String,ParentID:%String,KnowledgeBaseID:%String,Description:%String,ResChildCount:%Integer,PersonalKBUserID:%String,Sequence:%Integer,IsActive:%String")
{
}

ClassMethod SELECTALLExecute(ByRef qHandle As %Binary, AKnowledgeBaseID As %String) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	s arowID = ""
	for {
		s arowID = $o(^DHCEMRM.KBTreeI("IdxKnowledgeBaseID"," "_AKnowledgeBaseID,arowID))
		q:(arowID = "")	

		s objKBTree = ##Class(EMRmeta.KBTree).%OpenId(arowID)
		
		s Name = objKBTree.Name
		s ParentID = objKBTree.ParentID
		s KnowledgeBaseID = objKBTree.KnowledgeBaseID
		s Description = objKBTree.Description
		s ResChildCount = objKBTree.ResChildCount
		s PersonalKBUserID = objKBTree.PersonalKBUserID
		s Sequence=objKBTree.Sequence
		s IsActive = objKBTree.IsActive

		s Data = $lb(arowID,Name,ParentID,KnowledgeBaseID,Description,ResChildCount,PersonalKBUserID,Sequence,IsActive)
		s ^CacheTemp(repid,ind) = Data
		s ind = ind + 1
	}
	q $$$OK
}

ClassMethod SELECTALLFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SELECTALLExecute ]
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

ClassMethod SELECTALLClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SELECTALLExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// Creator:	yejian
/// CreatDate:  2016-10-9
/// Desc:		获取目录下所有知识库数据
/// Input：		
/// Return：	dataset
/// Debug:		d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLKBTree","SELECTBYPARANTID","1")
Query SELECTBYPARANTID(ParentID As %String = "") As %Query(ROWSPEC = "ID:%Integer,Name:%String,ParentID:%String,KnowledgeBaseID:%String,Description:%String,ResChildCount:%Integer,PersonalKBUserID:%String,Sequence:%String,IsActive:%String")
{
}

ClassMethod SELECTBYPARANTIDExecute(ByRef qHandle As %Binary, ParentID As %String) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	s arowID = ""
	for {
		s arowID = $o(^DHCEMRM.KBTreeI("IdxParentID"," "_ParentID,arowID))
		q:(arowID = "")	

		s objKBTree = ##Class(EMRmeta.KBTree).%OpenId(arowID)
		
		s Name = objKBTree.Name
		//s ParentID = objKBTree.ParentID
		s KnowledgeBaseID = objKBTree.KnowledgeBaseID
		s Description = objKBTree.Description
		s ResChildCount = objKBTree.ResChildCount
		s PersonalKBUserID = objKBTree.PersonalKBUserID
		s Sequence=objKBTree.Sequence
		s IsActive = objKBTree.IsActive

		s Data = $lb(arowID,Name,ParentID,KnowledgeBaseID,Description,ResChildCount,PersonalKBUserID,Sequence,IsActive)
		s ^CacheTemp(repid,ind) = Data
		s ind = ind + 1
	}
	q $$$OK
}

ClassMethod SELECTBYPARANTIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SELECTBYPARANTIDExecute ]
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

ClassMethod SELECTBYPARANTIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SELECTBYPARANTIDExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// Desc:        创建知识tree节点
/// Creator:     Cnadyxu
/// CreateDate:  2014-6-5
/// Input:       AEKBTree
ClassMethod CreateKBTree(AEKBTree As EMRservice.entity.EKBTree) As %String
{
	s objKBTree = ##class(EMRmeta.KBTree).%New()
 	s objKBTree.Name = AEKBTree.Name
 	s objKBTree.ParentID = AEKBTree.ParentID
 	s objKBTree.Description = AEKBTree.Description
 	s objKBTree.KnowledgeBaseID = AEKBTree.KnowledgeBaseID
 	s objKBTree.ResChildCount = 0
 	s objKBTree.PersonalKBUserID = AEKBTree.PersonalKBUserID
	s objKBTree.IsActive = AEKBTree.IsActive
 	s sc = objKBTree.%Save()
 	q:($$$ISERR(sc)) "0"
 	d ..SaveSequence(objKBTree.%Id())
	q objKBTree.%Id()
}

/// creator:     Candy xu 
/// CreatDate:   2014-06-05
/// Description: 存储顺序号
/// Table:       EMRservice.BOKBTree
/// Input:       树结点ID
/// debug:       d ##class(EMRservice.BOKBTree).SaveSequence("56")")
ClassMethod SaveSequence(RowID As %String)
{
	s objTree= ##class(EMRmeta.KBTree).%OpenId(RowID)
	q:(objTree = "")
	s objTree.Sequence=objTree.%Id()
	d objTree.%Save()
	d objTree.%Close()	
	k objTree
}

/// creator:      Candy xu 
/// CreatDate:    2014-06-05
/// Description:  修改树节点排序顺序号
/// Table:        EMRservice.BOKBTree
/// Input:        KBTreeID1树节点1，KBTreeID2树节点2
/// Output:       无
/// Return:       result是否操作成功
/// debug:        do ##class(EMRservice.BL.BLKBTree).SwapSequence("1","2")
ClassMethod SwapSequence(KBtreeID1 As %String, KBtreeID2 As %String) As %Boolean
{
	s result = 0
	s objNextTree = ##class(EMRmeta.KBTree).%OpenId(KBtreeID1)
	s objSelectTree = ##class(EMRmeta.KBTree).%OpenId(KBtreeID2)
	q:((objNextTree = "")||(objSelectTree = "")) result
	
	s TempSequence = objNextTree.Sequence
	s objNextTree.Sequence = objSelectTree.Sequence
	s objSelectTree.Sequence = TempSequence
	
	s $zt = "SwapErrorHandler"
	Tstart
	s scResult=objNextTree.%Save() 
	if $$$ISERR(scResult)
	{
		Trollback
		quit result
	}
	s scResultSele=objSelectTree.%Save() 
	if $$$ISERR(objSelectTree)
	{
		Trollback
		quit result
	}
	TCOMMIT
	 d objSelectTree.%Close()
	 d objNextTree.%Close()
	 s objSelectTree = ""
	 s objNextTree = ""
	 s result = 1
	 q result
	 
SwapErrorHandler
     q 0
}

/// creator:     Candy xu 
/// CreatDate:   2014-06-06
/// Description: 修改树节点
/// Table:       EMRservice.BOKBTree
/// Input:       EMRservice.entity.EKBTree
/// debug:       d ##class(EMRservice.BL.BLKBTree).UpdateKBTreeName("56")")
ClassMethod UpdateKBTreeName(AId As %String, AName As %String) As %String
{
	s result = 0
	s objKBTree = ##class(EMRmeta.KBTree).%OpenId(AId)
	q:(objKBTree = "") result
	s objKBTree.Name = AName
	s sc = objKBTree.%Save()
	if ($$$ISOK(sc)) s result = 1
	q result
}

/// Desc:		停用个人知识库目录
/// Creaotr:	董璐璐
/// CreateDate:	2015-12-21
/// Input:		AKBTreeID 知识库目录ID
/// 				AIsActive  (Y 启用,N 停用)
/// OutPut:     result 0失败 1成功
ClassMethod StopOrStartKBTree(AKBTreeID As %String, AIsActive As %String) As %String
{
	s result = "0"
	s objKBTree = ##Class(EMRmeta.KBTree).%OpenId(AKBTreeID)
	q:(objKBTree = "") result
	s objKBTree.IsActive = AIsActive
	s sc = objKBTree.%Save()
	if $$$ISOK(sc)
	{
		s result = "1"	
	}
	q result
}

/// creator:     liuyunfei
/// CreatDate:   2019-11-11
/// Description: 记录知识库目录树名称修改日志
/// Input:       userId: 操作人id
///              userName：当前操作人用户名
///              ipAddress:当前操作人ip
/// 				 Id：目录树的id
/// 				 nameOld、nameNew：修改前/后的名字
///              actionType：产品类型 
/// debug:       d ##class(EMRservice.BL.BLKBTree).UpdateKBTreeNameEventLog("10209","医生01","192.168.0.171","47775","321","32","EMR.OP.Knowledge.Update")
ClassMethod UpdateKBTreeNameEventLog(userId As %String, userName As %String, ipAddress As %String, Id As %String, nameOld As %String, nameNew As %String, actionType As %String) As %String
{
	s Condition = ""
	
	s Condition = Condition_"{""userId"":"""_userId_""","
	s Condition = Condition_"""userName"":"""_userName_""","
	s Condition = Condition_"""ipAddress"":"""_ipAddress_""","
	s Condition = Condition_"""id"":"""_Id_""","
	s Condition = Condition_"""nameOld"":"""_nameOld_""","
	s Condition = Condition_"""nameNew"":"""_nameNew_""","
	s Condition = Condition_"""nodeNameOld"":""—"","
	s Condition = Condition_"""nodeNameNew"":""—"","
	s Condition = Condition_"""textDataOld"":""—"","
	s Condition = Condition_"""textDataNew"":""—""}"
	d ##Class(EMRservice.Ajax.SetDataToEventLog).SetDataToEventLog(actionType,Condition,"")
	w ""
}

/// creator:     liuyunfei
/// CreatDate:   2019-11-12
/// Description: 记录知识库目录树文件夹删除日志
/// Input:       userId: 操作人id
///              userName：当前操作人用户名
///              ipAddress:当前操作人ip
/// 			 information：id^name^nodeName(节点id^文件夹名称^节点名称)
///              actionType：产品类型 
/// debug:       d ##class(EMRservice.BL.BLKBTree).DeleteKBTreeNameEventLog("10209","医生01","192.168.0.171","567^测试01^测试02^ 测试11^ 测试12","EMR.Knowledge.Delete")
ClassMethod DeleteKBTreeNameEventLog(userId As %String, userName As %String, ipAddress As %String, information As %String, actionType As %String) As %String
{
	s Condition = ""
	
	s Condition = Condition_"{""userId"":"""_userId_""","
	s Condition = Condition_"""userName"":"""_userName_""","
	s Condition = Condition_"""ipAddress"":"""_ipAddress_""","
	s Condition = Condition_"""id"":"""_$p(information,"^",1)_""","
	s Condition = Condition_"""name"":"""_$p(information,"^",2)_""","
	s Condition = Condition_"""nodeName"":"""_$p(information,"^",3)_"""}"
	d ##Class(EMRservice.Ajax.SetDataToEventLog).SetDataToEventLog(actionType,Condition,"")
	w ""
}

}
