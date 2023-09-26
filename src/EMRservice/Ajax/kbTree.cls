Class EMRservice.Ajax.kbTree Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s $zt = "ErrorHandler"
	
    s action = $Get(%request.Data("ACTION",1),"")
    s episodeID =  $Get(%request.Data("EpisodeID",1),"")
    s nodeBaseID = $Get(%request.Data("nodeBaseID",1),"")
    s diseaseID = $Get(%request.Data("diseaseID",1),"")
    s userLocID = $Get(%request.Data("UserLocID",1),"")
    s titleCode = $Get(%request.Data("titleCode",1),"")
    s actionType = $Get(%request.Data("actionType",1),"")
    s ipAddress = $Get(%request.Data("ipAddress",1),"")
    s userId = $Get(%request.Data("userID",1),"")
    s userName = $Get(%request.Data("userName",1),"")
    if (action = "GetBindKBNode")
    {
	    s objKBBase = ##Class(EMRmeta.KnowledgeBase).%OpenId(nodeBaseID)
	    s:objKBBase'="" kbBaseName = ##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(objKBBase.Name)
	    s:objKBBase'="" ^objTemp = objKBBase.%Id()_"^"_kbBaseName
	    d objKBBase.%Close()
	    s result = ##Class(EMRservice.BL.BLKBNode).GetBindKBNode(nodeBaseID,userLocID,diseaseID,episodeID,userId,titleCode)    
    	//s:(result '= "") result = "["_result_"]"
    	//w result
    	while (result.AtEnd = 0)
            {
                w $ZSTRIP(result.Read(32000),"*C",,$c(1)_$c(2))
            }
    	//调用记录日志方法
    	d ##class(EMRservice.BL.BLKBNode).ViewKBNodeNameEventLog(userId,userName,ipAddress,^objTemp,actionType)
		k ^objTemp
    }
    elseif (action = "UpdateKBNode")
    {
		s objEKBNode = ##Class(EMRservice.entity.EKBNode).%New()
		s objEKBNode.ID = $Get(%request.Data("ID",1),"")
		s objEKBNode.Description = ##Class(EMRservice.Tools.Tool).UnEscape($Get(%request.Data("Description",1),""))
		s objEKBNode.Name = ##Class(EMRservice.Tools.Tool).UnEscape($Get(%request.Data("Name",1),""))
		s objEKBNode.IsCommon = $Get(%request.Data("IsCommon",1),"")
		s objEKBNode.IsInUse = $Get(%request.Data("IsInUse",1),"")
		//新增知识库文本内容字段 add by Lina 2016-11-07
		s objEKBNode.TextData = $Get(%request.Data("TextData",1),"")
		s:objEKBNode.ID'="" objKBTreeTemp = ##Class(EMRmeta.KBNode).%OpenId(objEKBNode.ID)
		s:objKBTreeTemp'="" ^objTemp = objEKBNode.ID_"^"_objKBTreeTemp.Name_"^"_objEKBNode.Name_"^"_objKBTreeTemp.TextData_"^"_objEKBNode.TextData
		d objKBTreeTemp.%Close()
		w ##Class(EMRservice.BL.BLKBNode).UpdateKBNode(objEKBNode)
		//调用记录日志方法
		d ##class(EMRservice.BL.BLKBNode).UpdateKBNodeNameEventLog(userId,userName,ipAddress,^objTemp,actionType)
		k ^objTemp
		k objEKBNode
	}
    elseif (action = "CreateKBTree")
    {
	    s UserName = ##class(EMRservice.BL.BLPowerUser).GetUserName(userId)_"的个人知识库"
		s KnowledgeBaseID = $Get(%request.Data("KnowledgeBaseID",1),"")
		s ParentID = $Get(%request.Data("ParentID",1),"")
		w ..CreateKBTree(userId,KnowledgeBaseID,ParentID,UserName,userName,ipAddress,actionType)
	}
	elseif (action = "CreateKBNode")
	{
		s KnowLedgeBaseID = $Get(%request.Data("KnowledgeBaseID",1),"")
		s KBTreeID = $Get(%request.Data("KBTreeID",1),"")
		w ..CreateKBNode(KnowLedgeBaseID,KBTreeID,userId,userName,ipAddress,actionType)
	}
	elseif (action = "UpdateKBTree")
	{
		s Id = $Get(%request.Data("KBTreeID",1),"")
		s Name = $Get(%request.Data("Name",1),"")
        s objKBTreeTemp = ##class(EMRmeta.KBTree).%OpenId(Id) 
		s:objKBTreeTemp'="" nameOld = objKBTreeTemp.Name
		d objKBTreeTemp.%Close()
        s result = ##Class(EMRservice.BL.BLKBTree).UpdateKBTreeName(Id,Name)
        w result
        //调用记录日志方法
		d ##class(EMRservice.BL.BLKBTree).UpdateKBTreeNameEventLog(userId,userName,ipAddress,Id,nameOld,Name,actionType)
	}
	elseif (action = "StopOrStartKBNode")
	{
		s Id = $Get(%request.Data("KBTreeID",1),"")
		s IsInUse = $Get(%request.Data("IsInUse",1),"")
		s objKBNodeTemp = ##Class(EMRmeta.KBNode).%OpenId(Id)
		s:objKBNodeTemp'="" ^objTemp=Id_"^"_"—"_"^"_objKBNodeTemp.Name
		d objKBNodeTemp.%Close()
		s result = ##Class(EMRservice.BL.BLKBNode).StopOrStartKBNode(Id,IsInUse)
		w result
		//调用记录日志方法
		d ##class(EMRservice.BL.BLKBNode).DeleteKBNodeNameEventLog(userId,userName,ipAddress,^objTemp,actionType)
		k ^objTemp
	}
	elseif (action = "StopOrStartKBTree")
	{
		s Id = $Get(%request.Data("KBTreeID",1),"")
		s IsInUse = $Get(%request.Data("IsInUse",1),"")
		s objKBTreeTemp = ##Class(EMRmeta.KBTree).%OpenId(Id)
		s:objKBTreeTemp'="" ^objTemp=Id_"^"_objKBTreeTemp.Name_"^"_"—"
		d objKBTreeTemp.%Close()
		s result = ##Class(EMRservice.BL.BLKBTree).StopOrStartKBTree(Id,IsInUse)
		w result
		//调用记录日志方法
		d ##class(EMRservice.BL.BLKBTree).DeleteKBTreeNameEventLog(userId,userName,ipAddress,^objTemp,actionType)
		k ^objTemp
	}elseif (action = "CreateKBTreeNodeByKBNode")
	{
		s UserName = ##class(EMRservice.BL.BLPowerUser).GetUserName(userId)_"的个人知识库"
		s KnowledgeBaseID = $Get(%request.Data("KnowledgeBaseID",1),"")
		s ParentID = $Get(%request.Data("ParentID",1),"")
		s KBTreeID = $Get(%request.Data("KBTreeID",1),"")
		s KBNodeID = $Get(%request.Data("KBNodeID",1),"")
		w ..CreateKBTreeNodeByKBNode(userId,KnowledgeBaseID,ParentID,KBTreeID,KBNodeID,UserName,userName,ipAddress,actionType)
	}
	Quit $$$OK
	
ErrorHandler
   w ""
   Quit $$$OK
}

/// Desc: 		创建知识库目录
/// Creator:		Candy
/// CreateDate:	2014-10-20
/// Input:		AUserID 用户ID
/// 				AKnowLedgeBaseID 知识BaseID
/// 				AParentID Tree上级节点
/// 				ATreeName Tree名称
/// 				AuserName  用户名
/// Output:		result 知识库TreeNode
/// Debug:       w ##Class(EMRservice.Ajax.kbTree).CreateKBTree(105,96,1,"gesr")
ClassMethod CreateKBTree(AUserID As %String, AKnowledgeBaseID As %String, AParentID As %String, ATreeName As %String, AuserName As %String = "", ipAddress As %String = "", actionType As %String = "") As %String
{
	s json = ""
	q:(AKnowledgeBaseID = "")||(AParentID = "") json
    s objEKBTree = ##Class(EMRservice.entity.EKBTree).%New()
    s objEKBTree.Name = ATreeName
    s objEKBTree.KnowledgeBaseID = AKnowledgeBaseID
    s objEKBTree.ParentID = AParentID
    s objEKBTree.PersonalKBUserID = AUserID
    s objEKBTree.ResChildCount = 0
	s objEKBTree.IsActive = "Y" 
    s result = ##Class(EMRservice.BL.BLKBTree).CreateKBTree(objEKBTree)
    //调用记录日志方法
    s ^InformationStr = result_"^"_ATreeName_"^"_"—"
    d ..CreateKBTreeNameEventLog(AUserID,AuserName,ipAddress,^InformationStr,actionType)
    k ^InformationStr
    q:(result = 0) json
    s children = ..CreateKBNode(AKnowledgeBaseID,result,AUserID,AuserName,ipAddress,actionType) 
    if (children '= "")
    {
    	s json = "{'id':'"_result_"','text':'"_objEKBTree.Name_"',state:'open','attributes':{'type':'PersonalKBTree','personalKBUserID':'"_AUserID_"'},'children':["_children_"]}"
    }
    else
    {
    	s json = "{'id':'"_result_"','text':'"_objEKBTree.Name_"',state:'open','attributes':{'type':'PersonalKBTree','personalKBUserID':'"_AUserID_"'},'children':[]}"	    
	}	
	q json
}

/// Desc: 		创建知识库节点
/// Creator:		Candy
/// CreateDate:	2014-10-20
/// Input:		AKnowLedgeBaseID 知识BaseID
/// 				AKBTreeID 知识库TreeID
/// Output:		result 知识库Node
ClassMethod CreateKBNode(AKnowLedgeBaseID As %String, AKBTreeID As %String, AUserID As %String = "", AuserName As %String = "", ipAddress As %String = "", actionType As %String = "") As %String
{
	s json = ""
	q:((AKnowLedgeBaseID = "")||(AKBTreeID = "")) json
	s objEKBNode = ##Class(EMRservice.entity.EKBNode).%New()
	s objEKBNode.Name = "新建节点"
	s objEKBNode.KnowledgeBaseID = AKnowLedgeBaseID 
	s objEKBNode.KBTreeID =  AKBTreeID
	s objEKBNode.IsCommon = "Y"
	s objEKBNode.IsInUse = "Y"
	s result = ##Class(EMRservice.BL.BLKBNode).CreateKBNode(objEKBNode)
	//调用记录日志方法
	s ^InformationStr = result_"^"_"—"_"^"_"新建节点"
	d ..CreateKBTreeNameEventLog(AUserID,AuserName,ipAddress,^InformationStr,actionType)
    k ^InformationStr
    s:( result '= 0) json = "{'id':'"_result_"','text':'"_objEKBNode.Name_"','attributes':{'type':'KBNode','desc':'','isCommon':'Y','isInUse':'Y','isEmpty':'Y'}}" 
    q json
}

/// creator:     liuyunfei
/// CreatDate:   2019-11-12
/// Description: 记录知识库目录树节点创建日志
/// Input:       userId: 操作人id
///              userName：当前操作人用户名
///              ipAddress:当前操作人ip
/// 			 information：ID^Name^NodeName^(节点id^个人文件夹名^节点名)
///              actionType：产品类型 
/// debug:       d ##class(EMRservice.Ajax.kbTree).CreateKBTreeNameEventLog("10209","医生01","192.168.0.171","576^—^新建节点","EMR.Knowledge.Create")
ClassMethod CreateKBTreeNameEventLog(userId As %String, userName As %String, ipAddress As %String, information As %String, actionType As %String) As %String
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

/// Desc: 		将共享的个人知识库节点另存为个人知识库
/// Creator:	lina
/// CreateDate:	2022-4-14
/// Input:		AUserID 用户ID
/// 			AKnowLedgeBaseID 知识BaseID
/// 			AParentID  Tree上级节点
/// 			AKBTreeID  KBTree节点ID
/// 			AKBNodeID  KBNode节点ID
/// 			ATreeName  Tree名称
/// 			AuserName  用户名
/// 			ipAddress  当前操作人ip
/// 			actionType 产品类型
/// Output:		result 知识库TreeNode
/// Debug:       w ##Class(EMRservice.Ajax.kbTree).CreateKBTreeNodeByKBNode(10209,2,177,47768,559,"个人知识库")
ClassMethod CreateKBTreeNodeByKBNode(AUserID As %String, AKnowledgeBaseID As %String, AParentID As %String, AKBTreeID As %String, AKBNodeID As %String, ATreeName As %String, AuserName As %String = "", ipAddress As %String = "", actionType As %String = "") As %String
{
	s json = ""
	q:(AKnowledgeBaseID = "")||(AKBNodeID = "") json
	s KBTreeID = AKBTreeID
	if (AParentID '= ""){
		s objEKBTree = ##Class(EMRservice.entity.EKBTree).%New()
	    s objEKBTree.Name = ATreeName
	    s objEKBTree.KnowledgeBaseID = AKnowledgeBaseID
	    s objEKBTree.ParentID = AParentID
	    s objEKBTree.PersonalKBUserID = AUserID
	    s objEKBTree.ResChildCount = 0
		s objEKBTree.IsActive = "Y" 
	    s KBTreeID = ##Class(EMRservice.BL.BLKBTree).CreateKBTree(objEKBTree)
	    //调用记录日志方法
	    s ^InformationStr = KBTreeID_"^"_ATreeName_"^"_"—"
	    d ..CreateKBTreeNameEventLog(AUserID,AuserName,ipAddress,^InformationStr,actionType)
	    k ^InformationStr
    	q:(KBTreeID = 0) json
	}elseif (KBTreeID = ""){
		q json
	}
    s objEKBNode = ##Class(EMRservice.entity.EKBNode).%New()
	s objEKBNode.KnowledgeBaseID = AKnowledgeBaseID
	s objEKBNode.KBTreeID =  KBTreeID
	s objEKBNode.IsCommon = "Y"
	s objEKBNode.IsInUse = "Y"
	s objKBNode = ##Class(EMRmeta.KBNode).%OpenId(AKBNodeID)
    q:(objKBNode = "") json
	s objEKBNode.Name = objKBNode.Name
    d objEKBNode.MetaData.CopyFrom(objKBNode.MetaData)
    d objEKBNode.ScriptData.CopyFrom(objKBNode.ScriptData)
    d objEKBNode.MediasData.CopyFrom(objKBNode.MediasData)
    d objEKBNode.InitialData.CopyFrom(objKBNode.InitialData)
	d objEKBNode.PresentationData.CopyFrom(objKBNode.PresentationData)
	s objEKBNode.TextData = objKBNode.TextData
	s result = ##Class(EMRservice.BL.BLKBNode).CreateKBNode(objEKBNode)
	//调用记录日志方法
	s ^InformationStr = result_"^"_"—"_"^"_objKBNode.Name
	d ..CreateKBTreeNameEventLog(AUserID,AuserName,ipAddress,^InformationStr,actionType)
    k ^InformationStr
    s children= ""
    s isEmpty = $case(objEKBNode.MetaData.Size,0:"Y",:"N")
    s:(result '= 0) children = "{'id':'"_result_"','text':'"_objEKBNode.Name_"','attributes':{'type':'KBNode','desc':'','isCommon':'Y','isInUse':'Y','isEmpty':'"_isEmpty_"'}}" 
    if (AParentID = ""){
	    q children
	}
    if (children '= "")
    {
    	s json = "{'id':'"_result_"','text':'"_objEKBTree.Name_"',state:'open','attributes':{'type':'PersonalKBTree','personalKBUserID':'"_AUserID_"'},'children':["_children_"]}"
    }
    else
    {
    	s json = "{'id':'"_result_"','text':'"_objEKBTree.Name_"',state:'open','attributes':{'type':'PersonalKBTree','personalKBUserID':'"_AUserID_"'},'children':[]}"	    
	}
	q json
}

}
