/// 名称：		EMRservice.BL.BLKBTreeTitlesRule
/// 描述：		标题知识库树节点关联BL层
/// 编写者：	yejian
/// 编写时间：	2014-4-5
Class EMRservice.BL.BLKBTreeTitlesRule Extends (%RegisteredObject, %XML.Adaptor)
{

Query SELECTALLBYKBTreeID(aKBTreeID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,KBTreeID:%String,TitlesCode:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_EMR_KBTREETITLES_SELECTALLBYKBTREEID, SqlProc ]
{
	SELECT ID,KBTreeID,TitlesCode
	FROM EMRmeta.KBTreeTitlesRule
	WHERE KBTreeID = :aKBTreeID
}

/// 创建一个数据元范畴
ClassMethod CreateKBTreeTitleRule(aEKBTreeTitleInfo As EMRservice.entity.EKBTreeTitlesRule) As %String [ WebMethod ]
{
	s objKBTreeTitle=##class(EMRmeta.KBTreeTitlesRule).%New()
	quit:(objKBTreeTitle="") ""
	
	s objKBTreeTitle.KBTreeID=aEKBTreeTitleInfo.KBTreeID
	s objKBTreeTitle.TitlesCode=aEKBTreeTitleInfo.TitlesCode
	s sc = objKBTreeTitle.%Save()
	if ($$$ISOK(sc))
	{
		quit objKBTreeTitle.%Id()
	}
	else
	{
		 quit "-1"
	}
}

/// 删除一个数据元范畴
ClassMethod DeleteKBTreeTitleRuleByID(aKBTreeTitlesRuleId As %String) As %String [ WebMethod ]
{
	q:(aKBTreeTitlesRuleId ="") "-1"
	s objKBTreeTitle = ##Class(EMRmeta.KBTreeTitlesRule).%OpenId(aKBTreeTitlesRuleId)
	q:(objKBTreeTitle="") "-1"
	s sc = ##class(EMRmeta.KBTreeTitlesRule).%DeleteId(aKBTreeTitlesRuleId)
	if ($$$ISOK(sc))
	{
		q (+sc)
	}
	else
	{
		q "-1"
	}
}

/// 更新一个数据元范畴
ClassMethod UpdateKBTreeTitleRule(aEKBTreeTitleInfo As EMRservice.entity.EKBTreeTitlesRule) As %String [ WebMethod ]
{
	s objKBTreeTitle=##class(EMRmeta.KBTreeTitlesRule).%OpenId(aEKBTreeTitleInfo.ID)
	quit:(objKBTreeTitle="") "0"

	
	s objKBTreeTitle.KBTreeID=aEKBTreeTitleInfo.KBTreeID
	s objKBTreeTitle.TitlesCode=aEKBTreeTitleInfo.TitlesCode
	s sc = objKBTreeTitle.%Save()
	if ($$$ISOK(sc))
	{

		q (objKBTreeTitle.%Id())
	}
	else
	{

		 quit "-1"
	}
}

/// Creator:yejian
/// CreatDate:2010-08-25
/// Description:检查知识库节点是否在库中存在记录
/// Input:AKBTreeID-知识库节点ID
/// Output:
/// Return:1-该知识库节点在库中已经存在 0-该知识库节点在库中不存在
/// Debug: ##Class(EMRservice.BL.BLKBTreeTitlesRule).CheckKBTreeIDExist(AKBTreeID)
ClassMethod CheckKBTreeIDExist(AKBTreeID As %String) As %Integer
{
	s ret = 0
	q:(AKBTreeID="") ret
	
	s RowID = $o(^DHCEMRM.KBTreeTitlesRuleI("IdxKBTreeID"," "_AKBTreeID,""))
	if (+RowID>0)
	{
		s ret = 1
	}
	q ret
}

/// Creator:yejan
/// Table:EMRmeta.KBTreeCTLoc
/// Output:
/// Return:1-保存成功 0-保存失败
/// Others:保存操作存在三种可能:1、新增操作:原先库里不存在该知识库节点的记录,直接插入数据
/// 	   2、更新操作:原先库里已经存在该知识库节点的记录,但该记录为失效状态,即ActiveFlag为0,更新数据,将ActiveFlag设置为1
/// 	   3、删除操作:原先库里已经存在该知识库节点的记录,且该记录为有效状态,即ActiveFlag为1,更新数据,将ActiveFlag设置为0
/// Debug:w ##class(EMRservice.BOEMRKbConfig).SaveBindLoc(10,"8^13^17")
ClassMethod SaveBindTitle(KbTreeID As %String, TitleCodeStr As %String) As %String [ WebMethod ]
{
	//b "s"
	s ret = 0, status = 1
	q:(KbTreeID="") ret
	
	TStart
	
	//检查该知识库节点是否已存在
	s KbTreeIDExist = ##Class(EMRservice.BL.BLKBTreeTitlesRule).CheckKBTreeIDExist(KbTreeID)
	if (KbTreeIDExist = 0)
	{
		if (TitleCodeStr '= "")&&(TitleCodeStr'=$c(0))
		{
			// 不存在，直接将TitleCodeStr中的数据插入
			for i = 1:1:$l(TitleCodeStr,"^")
			{
				s TitleCode = $p(TitleCodeStr,"^",i)
				continue:(TitleCode="")
				s EKBTreeTitleInfo = ##Class(EMRservice.entity.EKBTreeTitlesRule).%New()
				s EKBTreeTitleInfo.KBTreeID = KbTreeID
				s EKBTreeTitleInfo.TitlesCode = TitleCode
				s Flag = ..CreateKBTreeTitleRule(EKBTreeTitleInfo)
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
		s TitleCodeID = ""
		s DeleteIDs = "", UpdateIDs = ""
		for {
			s TitleCodeID = $o(^DHCEMRM.KBTreeTitlesRuleI("IdxIDCode"," "_KbTreeID,TitleCodeID))
			q:(TitleCodeID="")

			s RowID = $o(^DHCEMRM.KBTreeTitlesRuleI("IdxIDCode"," "_KbTreeID,TitleCodeID,""))
			continue:(RowID="")
			
			//对TitleCodeID去空格
			s strTitleCodeID = $e(TitleCodeID,2,$l(TitleCodeID))
			
			//配置的科室串为空,即将原先库中已有的记录状态设置为失效
			if (TitleCodeStr="")||(TitleCodeStr=$C(0))
			{
				s DeleteIDs = DeleteIDs_$lb(RowID)
				continue	
			}
			else
			{
				//配置的科室串不为空,依次判断原先库中存在的该节点挂接的科室串中是否存在新增的科室ID
				If $f("^"_TitleCodeStr_"^", "^"_strTitleCodeID_"^")<1
				{
					// 原先配置LocID不在新配置TitleCodeStr串中，将此关联的RowID记录到DeleteIDs列表中
					s DeleteIDs = DeleteIDs_$lb(RowID)	
				}
				else
				{
					//原先配置LocID在新配置TitleCodeStr串中，将此关联的RowID记录到UpdateIDs列表中
					s UpdateIDs = UpdateIDs_$lb(RowID)
					
					//b "s"
					//将TitleCodeStr进行处理，去掉已经找到的LocID			
					s tmpTitleCodeStr = ""
					s strLength = $l(TitleCodeStr,"^")
					for i=1:1:strLength
					{
						s tmp = $p(TitleCodeStr,"^",i)
						continue:(tmp="")
						
						continue:(tmp = strTitleCodeID) 
						
						If tmpTitleCodeStr=""
						{
							s tmpTitleCodeStr = tmp
						}
						Else
						{
							s tmpTitleCodeStr = tmpTitleCodeStr_"^"_tmp
						}
					}
					
					s TitleCodeStr = tmpTitleCodeStr
					
				}
			}
		}
				
		if (DeleteIDs'="")
		{
			for Ind=1:1:$listlength(DeleteIDs)
			{
				s DeleteID = $listget(DeleteIDs,Ind)
				continue:(DeleteID="")
				
				s Flag = ..DeleteKBTreeTitleRuleByID(DeleteID)
				if (Flag = 0)
				{
					s status = 0
					q	
				}
			}	
		}
		/*
		if (UpdateIDs'="")
		{
			for Ind=1:1:$listlength(UpdateIDs)
			{
				s UpdateID = $listget(UpdateIDs,Ind)
				continue:(UpdateID="")
				
				s Flag = ..UpdateKBTreeTitleRule(UpdateID)
				if (Flag = 0)
				{
					s status = 0
					q	
				}
			}
		}
		*/
		//插入新数据
		if (TitleCodeStr '= "")&&(TitleCodeStr'=$c(0))
		{
			s strLength = $l(TitleCodeStr,"^")
			for i=1:1:strLength
			{
				//insert,create new data
				s TitleCodeID = $p(TitleCodeStr,"^",i)
				continue:(TitleCodeID="")
				s EKBTreeTitleInfo = ##Class(EMRservice.entity.EKBTreeTitlesRule).%New()
				s EKBTreeTitleInfo.KBTreeID = KbTreeID
				s EKBTreeTitleInfo.TitlesCode = TitleCodeID
				s Flag = ..CreateKBTreeTitleRule(EKBTreeTitleInfo)
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

}
