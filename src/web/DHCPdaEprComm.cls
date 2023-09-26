Class web.DHCPdaEprComm Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod SaveData(AEInstanceData As EPRservice.entity.EInstanceData) As EPRservice.entity.EInstanceData [ WebMethod ]
{
 k ^CacheTempDHCEPRDebug("EPRservice.BOInstanceData","SaveData")
 S ^CacheTempDHCEPRDebug("EPRservice.BOInstanceData","SaveData","Status") = AEInstanceData.Status
 s ^CacheTempDHCEPRDebug("EPRservice.BOInstanceData","SaveData","ID") =  AEInstanceData.ID
 s ^CacheTempDHCEPRDebug("EPRservice.BOInstanceData","SaveData","InstanceData") =  AEInstanceData.InstanceData.Read(10000)
 s ^CacheTempDHCEPRDebug("EPRservice.BOInstanceData","SaveData","TT")=AEInstanceData.InstanceData

 if (AEInstanceData.Status '= "UnSave") //= "Save") ;gjb 2008-03-26
 {
 Set AModifyDate = $ZDATEH($ZDATE($HOROLOG))

 //set objInstanceData.ModifyTime = $ZTIMEH($ZTIME($PIECE($HOROLOG,",",2),1))
 Set AModifyTime = $ZTIMEH($ZTIME($PIECE($HOROLOG,",",2),1))

 Set AStatusState = AEInstanceData.Status //"Save" ;gjb 2008-03-26
 
 set AEInstanceData.ListNo=  $PIECE(AEInstanceData.ID,"||",2) 
 Set InstanceDataStream = ##class(%GlobalCharacterStream).%New() 
 d InstanceDataStream.CopyFrom(AEInstanceData.InstanceData)
 Do InstanceDataStream.SaveStream()

 Set %qstrhandle(1,InstanceDataStream) = InstanceDataStream
 Set InstanceDataStream = InstanceDataStream_""

 &SQL(UPDATE EPRinstance.InstanceData
 Set EPRinstance.InstanceData.ListNo =:AEInstanceData.ListNo
 , EPRinstance.InstanceData.Title = :AEInstanceData.Title
 , EPRinstance.InstanceData.TemplateVersion = :AEInstanceData.TemplateVersion
 , EPRinstance.InstanceData.ModifyDate = :AModifyDate
 , EPRinstance.InstanceData.ModifyTime = :AModifyTime
 , EPRinstance.InstanceData.HappenDate = :AEInstanceData.HappenDate
 , EPRinstance.InstanceData.HappenTime = :AEInstanceData.HappenTime
 , EPRinstance.InstanceData.TemplateID = :AEInstanceData.TemplateID
 , EPRinstance.InstanceData.ModifyUser = :AEInstanceData.ModifyUser
 WHERE EPRinstance.InstanceData.ID = :AEInstanceData.ID)
 //, EPRinstance.InstanceData.Status = :AEInstanceData.Status
 //, EPRinstance.InstanceData.InstanceData = :InstanceDataStream
 Set obj = ##class(EPRinstance.InstanceData).%OpenId(AEInstanceData.ID)
 s TmpStrText="",StrText=""
 d AEInstanceData.InstanceData.Rewind()
 While (AEInstanceData.InstanceData.AtEnd = 0) 
	{
		Set len = 1024
		set TmpStrText= AEInstanceData.InstanceData.Read(len)
		set StrText= StrText_TmpStrText  
	}
	s ^CacheTemp("TmpStream")=StrText
 d obj.InstanceData.Write(StrText)
 d obj.%Save()
 d obj.%Close()
 s ^AAA("SAVE")="OK"
 Do ##class(EPRinstance.InstanceData).UpdateIndexByAutomaton(AEInstanceData)
	
 //added on 2008/06/10, by houjian@dhcc.com.cn
 //删除 InstanceDataStream 的持久化流数据
 do %qstrhandle(1,InstanceDataStream).Clear()
 	
 Kill %qstrhandle(1,InstanceDataStream)

 //set AEInstanceData.Status = "Save" ;gjb commented on 2008-03-26
 
 //////////////////////////////////////////////////////////////
 ///add for 安徽省立医院，by houjian@dhcc.com.cn, on 2007/11/08
 s paraRecRoom=""
 &sql(select OptionValue into :paraRecRoom
	 from EPRmeta.SysOption where Name='ParaRecordRoom2')
 quit:paraRecRoom="" AEInstanceData
 set templateId=$p(paraRecRoom,"^",1)            ///id of "病案室专用二"
 if AEInstanceData.TemplateID = templateId {
	 s itemCodeDisDeptBA=$p(paraRecRoom,"^",2)   ///simple item code of "病案室出院科室" （病案室专用二）
	 s itemCodeDisYear=$p(paraRecRoom,"^",3)     ///simple item code of "病案室出院年份" （病案室专用二）
	 s itemCodeDiagICDCode=$p(paraRecRoom,"^",4) ///simple item code of "病案室主诊断ICD码" （病案室专用二）
	 s itemCodeDiseaseNo=$p(paraRecRoom,"^",5)   ///simple item code of "病案室疾病顺序号" （病案室专用二） 
	 do ##class(EPRinstance.CaseRecordNo).CaseRecordNoService(AEInstanceData.EpisodeID,templateId,itemCodeDisDeptBA,itemCodeDisYear,itemCodeDiagICDCode,itemCodeDiseaseNo) 
 }
 ///end of code add by houjian@dhcc.com.cn, on 2007/11/08
 /////////////////////////////////////////////////////////////
 
 Quit AEInstanceData
 } 
 elseif (AEInstanceData.Status = "UnSave")
 {
	   
 Set InstanceDataStream = ##class(%GlobalCharacterStream).%New() 
 d InstanceDataStream.CopyFrom(AEInstanceData.InstanceData)
 Do InstanceDataStream.SaveStream()

 Set %qstrhandle(1,InstanceDataStream) = InstanceDataStream
 Set InstanceDataStream = InstanceDataStream_""
 
 set AEInstanceData.ListNo=  $PIECE(AEInstanceData.ID,"||",2)  
 set AModifyDate = $ZDATEH($ZDATE($HOROLOG)) 
 set ACreateTime = $ZTIMEH($ZTIME($PIECE($HOROLOG,",",2),1))
 set ACreateDate = $ZDATEH($ZDATE($HOROLOG))
 set AModifyTime = $ZTIMEH($ZTIME($PIECE($HOROLOG,",",2),1))

 ///gjb: the status here is always "Save". 2008-03-26
 ///control should be added in front side to limit that user can't print and commit patient record.
 s AEInstanceData.Status = "Save" 

 &SQL(UPDATE EPRinstance.InstanceData 
 Set ListNo =:AEInstanceData.ListNo
 , Title = :AEInstanceData.Title
	  , TemplateID = :AEInstanceData.TemplateID      
 ,TemplateVersion = :AEInstanceData.TemplateVersion
 , EPRinstance.InstanceData.CreateDate = :ACreateDate
 , EPRinstance.InstanceData.CreateTime = :ACreateTime
 , EPRinstance.InstanceData.CreateUser = :AEInstanceData.CreateUser
 , EPRinstance.InstanceData.ModifyDate = :AModifyDate
 , EPRinstance.InstanceData.ModifyTime = :AModifyTime
 , EPRinstance.InstanceData.ModifyUser = :AEInstanceData.ModifyUser      
 , EPRinstance.InstanceData.HappenDate = :AEInstanceData.HappenDate
 , EPRinstance.InstanceData.HappenTime = :AEInstanceData.HappenTime
 WHERE ID = :AEInstanceData.ID)
 //, EPRinstance.InstanceData.Status = :AEInstanceData.Status
 //, EPRinstance.InstanceData.InstanceData = :InstanceDataStream      
 Set obj = ##class(EPRinstance.InstanceData).%OpenId(AEInstanceData.ID)
 s TmpStrText="",StrText=""
 d AEInstanceData.InstanceData.Rewind()
 While (AEInstanceData.InstanceData.AtEnd = 0) 
	{
		Set len = 1024
		set TmpStrText= AEInstanceData.InstanceData.Read(len)
		set StrText= StrText_TmpStrText  
	}
	s ^CacheTemp("TmpStream")=StrText
 d obj.InstanceData.Write(StrText)
 d obj.%Save()
 d obj.%Close()
 //added on 2008/06/10, by houjian@dhcc.com.cn
 //删除 InstanceDataStream 的持久化流数据
 do %qstrhandle(1,InstanceDataStream).Clear()
 
 Kill %qstrhandle(1,InstanceDataStream)      	  

 set AEInstanceData.CreateDate = ACreateDate //AEInstanceData.CreateDate
 set AEInstanceData.CreateTime = ACreateTime //objInstanceData.CreateTime
 set AEInstanceData.ModifyDate = AModifyDate
 set AEInstanceData.ModifyTime = AModifyTime
 s ^AAA("UnSave")="OK"
 Do ##class(EPRinstance.InstanceData).UpdateIndexByAutomaton(AEInstanceData)
 
 
 //////////////////////////////////////////////////////////////
 ///add for 安徽省立医院，by houjian@dhcc.com.cn, on 2007/11/08
 s paraRecRoom=""
 &sql(select OptionValue into :paraRecRoom
	 from EPRmeta.SysOption where Name='ParaRecordRoom2')
 quit:paraRecRoom="" AEInstanceData
 set templateId=$p(paraRecRoom,"^",1)            ///id of "病案室专用二"
 if AEInstanceData.TemplateID = templateId {
	 s itemCodeDisDeptBA=$p(paraRecRoom,"^",2)   ///simple item code of "病案室出院科室" （病案室专用二）
	 s itemCodeDisYear=$p(paraRecRoom,"^",3)     ///simple item code of "病案室出院年份" （病案室专用二）
	 s itemCodeDiagICDCode=$p(paraRecRoom,"^",4) ///simple item code of "病案室主诊断ICD码" （病案室专用二）
	 s itemCodeDiseaseNo=$p(paraRecRoom,"^",5)   ///simple item code of "病案室疾病顺序号" （病案室专用二）
	 do ##class(EPRinstance.CaseRecordNo).CaseRecordNoService(AEInstanceData.EpisodeID,templateId,itemCodeDisDeptBA,itemCodeDisYear,itemCodeDiagICDCode,itemCodeDiseaseNo) 
 }
 ///end of code add by houjian@dhcc.com.cn, on 2007/11/08
 ////////////////////////////////////////////////////////////
 
 Quit AEInstanceData
 }
}

}
