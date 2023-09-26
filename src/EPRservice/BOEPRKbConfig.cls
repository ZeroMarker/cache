/// 名称:EPRservice.BOEPRKbConfig
/// 描述:新框架知识库挂接科室
/// 编写者:loo
/// 编写日期:2010-08-25
Class EPRservice.BOEPRKbConfig Extends %SOAP.WebService [ ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://localhost/trakcarelive/trak/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService. 
Parameter SERVICENAME = "KbConfigInfo";

/// Debug: ##class(EPRservice.BOEPRKbConfig).GetAllLoc()
ClassMethod GetAllLoc() As %XML.DataSet [ WebMethod ]
{
	Set result=##class(%XML.DataSet).%New("EPRservice.BOEPRKbConfig:SelectAllLoc")
	Quit result
}

/// modify by 牛才才 for Bug#1764  2012-05-10
Query SelectAllLoc() As %SQLQuery(CONTAINID = 0, ROWSPEC = "RowId:%String,Code:%String,Des:%String")
{
	SELECT CTLOC_RowId,CTLOC_CODE,upper(CTLOC_Desc) From SQLUser.CT_Loc Where CTLOC_Type='E' or CTLOC_Type='OP' or CTLOC_Type='OR' or CTLOC_Type='EM'  Order By CTLOC_Desc,CTLOC_RowId
}

/// Creator:loo
/// CreatDate:2010-08-25
/// Description:根据KBTreeID返回已经绑定了该节点的科室列表
/// Table:EPRmeta.KBTreeCTLoc
/// Input:KbTreeID-知识库节点ID
/// Output:
/// Return:返回字符串,返回格式:locID1^locID2^locID3^..
/// Others:
/// Debug:w ##class(EPRservice.BOEPRKbConfig).GetBindLocByID(1)
ClassMethod GetBindLocByID(KbTreeID As %String) As %String [ WebMethod ]
{
	s LocIDStr = ""
	s curLocID = ""
	for {
		s curLocID = $o(^DHCEPRM.KBTreeCTLocI("IdxKBTreeCTLocID"," "_KbTreeID,curLocID))
		q:(curLocID="")
		
		If (LocIDStr = "")
		{
			s RowID = ""
			s RowID = $o(^DHCEPRM.KBTreeCTLocI("IdxKBTreeCTLocID"," "_KbTreeID,curLocID,RowID))
			s obj = ##class(EPRmeta.KBTreeCTLoc).%OpenId(RowID)
			If (obj.ActiveFlag = 0)
			{
				d obj.%Close()
				continue
			}
			
			d obj.%Close()
			s LocIDStr = $e(curLocID,2,$l(curLocID))
		}
		else
		{
			s RowID = ""
			s RowID = $o(^DHCEPRM.KBTreeCTLocI("IdxKBTreeCTLocID"," "_KbTreeID,curLocID,RowID))
			s obj = ##class(EPRmeta.KBTreeCTLoc).%OpenId(RowID)
			If (obj.ActiveFlag = 0)
			{
				d obj.%Close()
				continue
			}
			
			d obj.%Close()
			s LocIDStr = LocIDStr_"^"_$e(curLocID,2,$l(curLocID))
		}
	}
	quit LocIDStr
}

/// Creator:loo
/// CreatDate:2010-08-25
/// Description:
/// Table:EPRmeta.KBTreeCTLoc
/// Input:KbTreeID-知识库节点ID,LocIDStr-挂接科室拼成的字符串,格式为:locID1^locID2
/// Output:
/// Return:1-保存成功 0-保存失败
/// Others:保存操作存在三种可能:1、新增操作:原先库里不存在该知识库节点的记录,直接插入数据
/// 	   2、更新操作:原先库里已经存在该知识库节点的记录,但该记录为失效状态,即ActiveFlag为0,更新数据,将ActiveFlag设置为1
/// 	   3、删除操作:原先库里已经存在该知识库节点的记录,且该记录为有效状态,即ActiveFlag为1,更新数据,将ActiveFlag设置为0
/// Debug:w ##class(EPRservice.BOEPRKbConfig).SaveBindLoc(10,"8^13^17")
ClassMethod SaveBindLoc(KbTreeID As %String, LocIDStr As %String) As %String [ WebMethod ]
{
	//b "s"
	s ret = 0, status = 1
	q:(KbTreeID="") ret
	
	TStart
	
	//检查该知识库节点是否已存在
	s KbTreeIDExist = ..CheckKBTreeIDExist(KbTreeID)
	if (KbTreeIDExist = 0)
	{
		if (LocIDStr '= "")&&(LocIDStr'=$c(0))
		{
			// 不存在，直接将LocIDStr中的数据插入
			for i = 1:1:$l(LocIDStr,"^")
			{
				s CtLocID = $p(LocIDStr,"^",i)
				continue:(CtLocID="")
				
				s Flag = ..Add(KbTreeID,CtLocID)
				if (Flag = 0)
				{
					s status = 0
					q	
				}
			}	
		}
	}
	else
	{	
		s curLocID = ""
		s DeleteIDs = "", UpdateIDs = ""
		for {
			s curLocID = $o(^DHCEPRM.KBTreeCTLocI("IdxKBTreeCTLocID"," "_KbTreeID,curLocID))
			q:(curLocID="")

			s RowID = $o(^DHCEPRM.KBTreeCTLocI("IdxKBTreeCTLocID"," "_KbTreeID,curLocID,""))
			continue:(RowID="")
			
			//对curLocID去空格
			s tmpLocID = $e(curLocID,2,$l(curLocID))
			
			//配置的科室串为空,即将原先库中已有的记录状态设置为失效
			if (LocIDStr="")||(LocIDStr=$C(0))
			{
				s DeleteIDs = DeleteIDs_$lb(RowID)
				continue	
			}
			else
			{
				//配置的科室串不为空,依次判断原先库中存在的该节点挂接的科室串中是否存在新增的科室ID
				If $f("^"_LocIDStr_"^", "^"_tmpLocID_"^")<1
				{
					// 原先配置LocID不在新配置LocIDStr串中，将此关联的RowID记录到DeleteIDs列表中
					s DeleteIDs = DeleteIDs_$lb(RowID)	
				}
				else
				{
					//原先配置LocID在新配置LocIDStr串中，将此关联的RowID记录到UpdateIDs列表中
					s UpdateIDs = UpdateIDs_$lb(RowID)
					
					//b "s"
					//将LocIDStr进行处理，去掉已经找到的LocID			
					s tmpLocIDStr = ""
					s strLength = $l(LocIDStr,"^")
					for i=1:1:strLength
					{
						s tmp = $p(LocIDStr,"^",i)
						continue:(tmp="")
						
						continue:(tmp = tmpLocID) 
						
						If tmpLocIDStr=""
						{
							s tmpLocIDStr = tmp
						}
						Else
						{
							s tmpLocIDStr = tmpLocIDStr_"^"_tmp
						}
					}
					
					s LocIDStr = tmpLocIDStr
					
				}
			}
		}
				
		if (DeleteIDs'="")
		{
			for Ind=1:1:$listlength(DeleteIDs)
			{
				s DeleteID = $listget(DeleteIDs,Ind)
				continue:(DeleteID="")
				
				s Flag = ..Delete(DeleteID)
				if (Flag = 0)
				{
					s status = 0
					q	
				}
			}	
		}
		if (UpdateIDs'="")
		{
			for Ind=1:1:$listlength(UpdateIDs)
			{
				s UpdateID = $listget(UpdateIDs,Ind)
				continue:(UpdateID="")
				
				s Flag = ..Update(UpdateID)
				if (Flag = 0)
				{
					s status = 0
					q	
				}
			}
		}
		
		//插入新数据
		if (LocIDStr '= "")&&(LocIDStr'=$c(0))
		{
			s strLength = $l(LocIDStr,"^")
			for i=1:1:strLength
			{
				//insert,create new data
				s curLocID = $p(LocIDStr,"^",i)
				continue:(curLocID="")
				
				s Flag = ..Add(KbTreeID,curLocID)
				if (Flag = 0)
				{
					s status = 0
					q	
				}
			}
		}
	}
	
	if (status = 1)
	{
		TCommit
		s ret = 1
	}
	else
	{
		TRollBack	
	}
	
	q ret
}

ClassMethod Add(KbTreeID As %String, LocID As %String) As %Integer
{
	s ret = 1
	//创建新数据
	s obj = ##class(EPRmeta.KBTreeCTLoc).%New()
	s obj.KBTreeID = KbTreeID
	s obj.CTLocID = LocID
	s obj.ActiveFlag = 1
	if '(obj.%Save())
	{
		s ret = 0	
	}
	d obj.%Close()
	q ret
}

ClassMethod Update(RowID As %String) As %Integer
{
	s ret = 1
	q:(RowID="") ret
	
	//原有数据进行更新,将数据ActiveFlag设置为1
	s obj = ##class(EPRmeta.KBTreeCTLoc).%OpenId(RowID)
	
	s obj.ActiveFlag = 1
	
	if '(obj.%Save())
	{
		s ret = 0	
	}
	
	d obj.%Close()
	
	q ret
}

ClassMethod Delete(RowID As %String) As %Integer
{
	s ret = 1
	q:(RowID="") ret
	
	//原有数据进行“删除”,将数据ActiveFlag设置为0
	s obj = ##class(EPRmeta.KBTreeCTLoc).%OpenId(RowID)
	s obj.ActiveFlag = 0
	
	if '(obj.%Save())
	{
		s ret = 0	
	}
	
	d obj.%Close()
	
	q ret
}

/// Creator:loo
/// CreatDate:2010-08-25
/// Description:检查知识库节点是否在库中存在记录
/// Table:EPRmeta.KBTreeCTLoc
/// Input:AKBTreeID-知识库节点ID
/// Output:
/// Return:1-该知识库节点在库中已经存在 0-该知识库节点在库中不存在
/// Others:
/// Debug: ##Class(EPRservice.BOEPRKbConfig).CheckKBTreeIDExist(AKBTreeID)
ClassMethod CheckKBTreeIDExist(AKBTreeID As %String) As %Integer
{
	s ret = 0
	q:(AKBTreeID="") ret
	
	s RowID = $o(^DHCEPRM.KBTreeCTLocI("IdxKBTreeID"," "_AKBTreeID,""))
	if (+RowID>0)
	{
		s ret = 1
	}
	q ret
}

/// Creator:loo
/// CreatDate:2010-08-25
/// Description:根据科室取得相对应的知识库节点
/// Table:EPRmeta.KBTreeCTLoc
/// Input:ALocID-科室ID
/// Output:
/// Return:返回一个字符串,格式为(KBTreeID1,KBTreeID2)
/// Others:
/// Debug: ##Class(EPRservice.BOEPRKbConfig).GetKBTreeByLoc()
ClassMethod GetKBTreeByLoc(ALocID As %String) As %String [ WebMethod ]
{
	s KBTreeIDListStr = ""
	s curKBTreeID = ""
	s i = 0
	for {
		s i = i+1
		s curKBTreeID = $o(^DHCEPRM.KBTreeCTLocI("IdxCTLocKBTreeID"," "_ALocID,curKBTreeID))
		q:(curKBTreeID="")
		
		s tmpKBTreeID = $e(curKBTreeID,2,$l(curKBTreeID))
		
		s RowID = ""
		s RowID = $o(^DHCEPRM.KBTreeCTLocI("IdxCTLocKBTreeID"," "_ALocID,curKBTreeID,RowID))
		s obj = ##class(EPRmeta.KBTreeCTLoc).%OpenId(RowID)
		//ActiveFlag=0,退出当次循环
		continue:(obj.ActiveFlag = 0)
		
		If (KBTreeIDListStr = "")
		{
			s KBTreeIDListStr = "('"_tmpKBTreeID_"'"
		}
		Else
		{
			s KBTreeIDListStr = KBTreeIDListStr_",'"_tmpKBTreeID_"'"
		}
	}
	
	If (KBTreeIDListStr '= "")
	{
		s KBTreeIDListStr = KBTreeIDListStr_")"
	}

	if (KBTreeIDListStr = "") s KBTreeIDListStr = "('0')"
	quit KBTreeIDListStr
}

}
