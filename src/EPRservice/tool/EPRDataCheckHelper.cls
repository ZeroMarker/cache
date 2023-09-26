Class EPRservice.tool.EPRDataCheckHelper Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Desc: 检查实例数据存储位置是否正确
/// Input: startId: 开始检查的id
/// 		totCount: 检查数目
/// w ##class(EPRservice.tool.EPRDataCheckHelper).FilterIntanceDataWithLocError("0","10000")
ClassMethod FilterIntanceDataWithLocError(startId As %String, totCount As %String)
{
	
	s repid = $I(^DHCEPRInstanceDataLocError)
	k ^DHCEPRInstanceDataLocError(repid)
	
	s count = 0
	s errcount = 0
	s tmpcount = 0
	
	s ECRecordID = startId
	for {
		s ECRecordID = $O(^DHCEPRI.InstanceDataI("IdxECRecord",ECRecordID))
		q:(ECRecordID="")
		
		//控制检查数量
		s count = count + 1
		q:(count > totCount)
		
		//提示信息
		s tmpcount = tmpcount + 1
		if tmpcount > 1000
		{
			s tmpcount =0
			w !,"Filter to: "_ECRecordID
		}
			
		s ChildSub = ""
		for {
			s ChildSub = $O(^DHCEPRI.InstanceDataI("IdxECRecord",ECRecordID,ChildSub))
			q:(ChildSub="")
			
			s InstanceID = ECRecordID_"||"_ChildSub
			
			s obj = ##class(EPRinstance.InstanceData).%OpenId(InstanceID)
			continue:(obj = "")
			
			//若原InstanceData的流数据存在^CacheStream中
			s streamId = obj.InstanceData.GetStreamId()
			if ($find(streamId,"^CacheStream")||$find(streamId,"^CacheTemp"))
			{
				//b
				s errcount = errcount + 1
				s ^DHCEPRInstanceDataLocError(repid,errcount) = InstanceID
				w !,"Error InstanceData: "_InstanceID
			}
		}
	}
	
	w !,"Total ECRecord Checked: "_count
	w !,"Total InstanceData With Loc Error: "_errcount
	w !,"Error info in ^DHCEPRInstanceDataLocError("_repid_")"
	
	s ^DHCEPRInstanceDataLocError(repid, "CountTotal") = count
	s ^DHCEPRInstanceDataLocError(repid, "CountError") = errcount
	
	quit
}

/// Desc: 检查基础数据存储位置是否正确
/// Debug: w ##class(EPRservice.tool.EPRDataCheckHelper).FilterBaseData()
ClassMethod FilterBaseData()
{
	s repid = $I(^DHCEPRBaseDataDataLocError)
	k ^DHCEPRBaseDataDataLocError(repid)
	
	//知识库节点
	w !,"check KBNode"
	s errcount = 0
	s totcount = 0
	s id = ""
	for {
		s id = $O(^DHCEPRM.KBNodeD(id))
		q:(id="")
		
		s totcount = totcount + 1
		
		w !, "check: "_id
		s obj = ##class(EPRmeta.KBNode).%OpenId(id)
		continue:(id = "")
		
		s streamId = obj.S1InstanceData.GetStreamId()
		if ($find(streamId,"^CacheStream")||$find(streamId,"^CacheTemp"))
		{
			s errcount = errcount + 1
			s ^DHCEPRBaseDataDataLocError(repid,"kbnode", errcount) = id
			w !,"Error KBNode "_id
			continue
		}
		s streamId = obj.S2InstanceData.GetStreamId()
		if ($find(streamId,"^CacheStream")||$find(streamId,"^CacheTemp"))
		{
			s errcount = errcount + 1
			s ^DHCEPRBaseDataDataLocError(repid,"kbnode", errcount) = id
			w !,"Error KBNode "_id
			continue
		}
		s streamId = obj.S3InstanceData.GetStreamId()
		if ($find(streamId,"^CacheStream")||$find(streamId,"^CacheTemp"))
		{
			s errcount = errcount + 1
			s ^DHCEPRBaseDataDataLocError(repid,"kbnode", errcount) = id
			w !,"Error KBNode "_id
			continue
		}
		s streamId = obj.S1MetaData.GetStreamId()
		if ($find(streamId,"^CacheStream")||$find(streamId,"^CacheTemp"))
		{
			s errcount = errcount + 1
			s ^DHCEPRBaseDataDataLocError(repid,"kbnode", errcount) = id
			w !,"Error KBNode "_id
			continue
		}
		s streamId = obj.S2MetaData.GetStreamId()
		if ($find(streamId,"^CacheStream")||$find(streamId,"^CacheTemp"))
		{
			s errcount = errcount + 1
			s ^DHCEPRBaseDataDataLocError(repid,"kbnode", errcount) = id
			w !,"Error KBNode "_id
			continue
		}
		s streamId = obj.S3MetaData.GetStreamId()
		if ($find(streamId,"^CacheStream")||$find(streamId,"^CacheTemp"))
		{
			s errcount = errcount + 1
			s ^DHCEPRBaseDataDataLocError(repid,"kbnode", errcount) = id
			w !,"Error KBNode "_id
			continue
		}
	}
	s ^DHCEPRBaseDataDataLocError(repid,"kbnode", "CountTotal") = totcount
	s ^DHCEPRBaseDataDataLocError(repid,"kbnode", "CountError") = errcount
	
	//打印模板版本
	w !,"check PrintTemplateVersion"
	s errcount = 0
	s totcount = 0
	s id = ""
	for {
		s id = $O(^DHCEPRM.PrintTemplateVersionD(id))
		q:(id="")
		
		s totcount = totcount + 1
		
		w !, "check: "_id
		s obj = ##class(EPRmeta.PrintTemplateVersion).%OpenId(id)
		continue:(obj="")
		
		s streamId = obj.Data.GetStreamId()
		if ($find(streamId,"^CacheStream")||$find(streamId,"^CacheTemp"))
		{
			s errcount = errcount + 1
			s ^DHCEPRBaseDataDataLocError(repid,"printversion", errcount) = id
			w !,"Error PrintTemplateVersion: "_id
		} 
	}
	s ^DHCEPRBaseDataDataLocError(repid,"printversion", "CountTotal") = totcount
	s ^DHCEPRBaseDataDataLocError(repid,"printversion", "CountError") = errcount
	
	//界面模板版本
	w !,"check TemplateVersion"
	s errcount = 0
	s totcount = 0
	s id = ""
	for {
		s id = $O(^DHCEPRM.TemplateVersionD(id))
		q:(id="")
		
		s totcount = totcount + 1
		
		s obj = ##class(EPRmeta.TemplateVersion).%OpenId(id)
		continue:(obj="")
		
		w !, "check: "_id
		s streamId = obj.InitialData.GetStreamId()
		if ($find(streamId,"^CacheStream")||$find(streamId,"^CacheTemp"))
		{
			s errcount = errcount + 1
			s ^DHCEPRBaseDataDataLocError(repid,"templateversion", errcount) = id
			w !,"Error TemplateVersion: "_id
			continue
		} 
		s streamId = obj.MetaData.GetStreamId()
		if ($find(streamId,"^CacheStream")||$find(streamId,"^CacheTemp"))
		{
			s errcount = errcount + 1
			s ^DHCEPRBaseDataDataLocError(repid,"templateversion", errcount) = id
			w !,"Error TemplateVersion: "_id
			continue
		}
		s streamId = obj.PresentationData.GetStreamId()
		if ($find(streamId,"^CacheStream")||$find(streamId,"^CacheTemp"))
		{
			s errcount = errcount + 1
			s ^DHCEPRBaseDataDataLocError(repid,"templateversion", errcount) = id
			w !,"Error TemplateVersion: "_id
			continue
		}
		
	}
	s ^DHCEPRBaseDataDataLocError(repid,"templateversion", "CountTotal") = totcount
	s ^DHCEPRBaseDataDataLocError(repid,"templateversion", "CountError") = errcount
	
	w !, "--------------"
	w !, "Check result: "
	
	w !, "KBNode: TotalCount:"_^DHCEPRBaseDataDataLocError(repid,"kbnode", "CountTotal")
	w ", ErrorCount:"_^DHCEPRBaseDataDataLocError(repid,"kbnode", "CountError")
	
	w !, "PrintTemplateVersion: TotalCount:"_^DHCEPRBaseDataDataLocError(repid,"printversion", "CountTotal")
	w ", ErrorCount:"_^DHCEPRBaseDataDataLocError(repid,"printversion", "CountError")
	
	w !, "TemplateVersion: TotalCount:"_^DHCEPRBaseDataDataLocError(repid,"templateversion", "CountTotal")
	w ", ErrorCount:"_^DHCEPRBaseDataDataLocError(repid,"templateversion", "CountError")
	
	w !, "ErrorInfo in :  ^DHCEPRBaseDataDataLocError("_repid_")"
}

}
