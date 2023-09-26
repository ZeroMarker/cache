/// Desc：         导出病历队列
/// Creator：       Candy
/// CreateDate：2015-4-29
Class EMRservice.BL.BLExportQueue Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:       插入对队列信息
/// Creator:    Candy
/// CreateDate: 2015-4-29
/// Input:      APatientID 病人ID
///            	AEpisodeID 就诊ID
///            	AInstanceID 病历ID
///            	APluginType 编辑器类型grid编辑器"GRID"，word编辑器"DOC"
///            	AChartItemType 病历类型 可重复模板"Multiple"还是唯一模板"Single"
///            	AClientIP  客户端Ip
/// Output:     result 0失败  1成功
ClassMethod SetData(APatientID As %String, AEpisodeID As %String, AInstanceID As %String, AClientIP As %String, AType As %String = "IMAGE") As %String
{
	s result = "0"
	q:(APatientID = "")||(AEpisodeID = "")||(AInstanceID = "")||(AType = "") result
	s result = "1"
	s admType = $p($g(^PAADM(AEpisodeID)),"^",2)
	q:($d(^DHCEMRI.Export.QueueI("IdxTyQueue"," "_AType," "_APatientID," "_AEpisodeID," "_AInstanceID))>0) result

	if (AType = "IMAGE")
	{
		s NoExportConfig = ##class(EMRservice.BL.BLSysOption).GetOptionValueByName2("ImageNoExport","^")
		q:((admType '= "")&&(NoExportConfig [ ("^"_admType_"^"))) result
		q:(..CheckInstanceIDIsExit(APatientID,AEpisodeID,AInstanceID,"Wait",AType)>0) result
	}
	elseif(AType = "HTML")
	{
		s NoExportConfig = ##class(EMRservice.BL.BLSysOption).GetOptionValueByName2("HTMLNoExport","^")
		q:((admType '= "")&&(NoExportConfig [ ("^"_admType_"^"))) result
	}
	
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceID)
	q:(objInstance = "") result
	s PluginType = objInstance.TheECRecord.DocumentType
	s ChartItemType = objInstance.TheECRecord.ChartItemType
	k objInstance
	//插入队列
	s obj = ##Class(EMRinstance.Export.Queue).%New()
	s obj.PatientID = APatientID
	s obj.EpisodeID = AEpisodeID
	s obj.InstanceID = AInstanceID
	s obj.ECRecordID = $p(AInstanceID,"||",1)
	s obj.PluginType = PluginType
	s obj.ChartItemType = ChartItemType
	s obj.ClientIP = AClientIP
	s obj.Type = AType
	s obj.HappenDate = $p($h,",",1)
	s obj.HappenTime = $p($h,",",2)
	s obj.AdmType = admType
	s sc = obj.%Save()
	s:($$$ISERR(sc)) result = "0"
	q result
}

/// Desc:       类似病程记录连续显示的病历，只要队列中有一条即可
///             Candy 2018-12-14 修改了这个方法，增加了EcrecordID的存储,去掉其他判断，只判断等待队列
/// Modify:     Candy
/// ModifyDate: 2018-12-14
/// Input:      APatientID 患者ID
///            
/// Debug:      w ##Class(EMRservice.BL.BLExportQueue).CheckInstanceIDIsExit("9","58","24||109","Wait")
ClassMethod CheckInstanceIDIsExit(APatientID As %String, AEpisodeID As %String, AInstanceID As %String, AQueueType As %String, AOutType As %String) As %String
{
	s result = "0"
	s GetInstanceID = ""
	s ecrecordId = $p(AInstanceID,"||",1)
	if (AQueueType="Wait")
	{
		s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceID)
		q:(objInstance.TheECRecord.DocumentCharacteristic '= 1) result
		k objInstance
		s:($d(^DHCEMRI.Export.QueueI("IdxTyECRecord"," "_AOutType," "_APatientID," "_AEpisodeID,ecrecordId))>0) result = "1"
	}	
	elseif (AQueueType="Exe")
	{		
		if (AOutType ="XML")||(AOutType = "HTML")
		{
			s rowId = $o(^DHCEMRI.Export.ExeI("IdxTyQueue"," "_AOutType, " "_APatientID, " "_AEpisodeID," "_AInstanceID,""),-1)			
			s result=$case(rowId,"":result,:rowId)
			q result
		}
		else
		{
			for 
			{		   
				s GetInstanceID =  $o(^DHCEMRI.Export.ExeI("IdxTyQueue"," "_AOutType," "_APatientID," "_AEpisodeID,GetInstanceID))
				q:(GetInstanceID="")		
				s FirstID=$p($p(GetInstanceID," ",2),"||",1)	
				continue:(FirstID'=ecrecordId)
				s rowId = $o(^DHCEMRI.Export.ExeI("IdxTyQueue"," "_AOutType, " "_APatientID, " "_AEpisodeID,GetInstanceID,""),-1)			
				s result=rowId
				q
			}
		}	
	}
	elseif (AQueueType="Succed")
	{
		if (AOutType ="XML")||(AOutType = "HTML")
		{
			s rowId = $o(^DHCEMRI.Export.SucceedI("IdxTyQueue"," "_AOutType, " "_APatientID, " "_AEpisodeID," "_AInstanceID,""),-1)			
			s result=$case(rowId,"":result,:rowId)
			q result
		}
		else
		{
			for 
			{		   
				s GetInstanceID =  $o(^DHCEMRI.Export.SucceedI("IdxTyQueue"," "_AOutType," "_APatientID," "_AEpisodeID,GetInstanceID))
				q:(GetInstanceID="")				
				s FirstID=$p($p(GetInstanceID," ",2),"||",1)
				continue:(FirstID'=ecrecordId)			    
			    s rowId = $o(^DHCEMRI.Export.SucceedI("IdxTyQueue"," "_AOutType, " "_APatientID, " "_AEpisodeID,GetInstanceID,""),-1)			
				s result=rowId
				q			
			}
		}	
	}
	elseif (AQueueType="Failure")
	{
		if (AOutType ="XML")||(AOutType = "HTML")
		{
			s rowId = $o(^DHCEMRI.Export.FailureI("IdxTyQueue"," "_AOutType, " "_APatientID, " "_AEpisodeID," "_AInstanceID,""),-1)			
			s result=$case(rowId,"":result,:rowId)
			q result
		}
		else
		{
			for 
			{		   
				s GetInstanceID =  $o(^DHCEMRI.Export.FailureI("IdxTyQueue"," "_AOutType," "_APatientID," "_AEpisodeID,GetInstanceID))
				q:(GetInstanceID="")				
				s FirstID=$p($p(GetInstanceID," ",2),"||",1)
				continue:(FirstID'=ecrecordId)			    
			    s rowId = $o(^DHCEMRI.Export.FailureI("IdxTyQueue"," "_AOutType, " "_APatientID, " "_AEpisodeID,GetInstanceID,""),-1)			
				s result=rowId
				q			
			}
		}	
	}
	q result
}

/// w ##Class(EMRservice.BL.BLExportQueue).TEST()
ClassMethod TEST() As %String
{
	s Len=20
	for inti=1:1:Len 
	{
		w ##Class(EMRservice.BL.BLExportQueue).GRIDTEST()
		w ##Class(EMRservice.BL.BLExportQueue).DOCTEST()		
	}
}

ClassMethod GRIDTEST() As %String
{
	s obj = ##Class(EMRinstance.Export.Queue).%New()	
	//s obj = ##Class(EMRinstance.Export.Exe).%New()
	//s obj = ##Class(EMRinstance.Export.Succeed).%New()
	s obj.PatientID = "9"
	s obj.EpisodeID = "58"
	s obj.InstanceID = "21||5"
	s obj.PluginType = "GRID"
	s obj.ChartItemType = "Single"
	s obj.ClientIP = "127.0.0.1"
	s obj.HappenDate = $p($h,",",1)
	s obj.HappenTime = $p($h,",",2)
	s obj.PageCount = "3"
	s obj.StartPage = "1"
	s obj.EndPage = "3"
	s obj.Type = "IMAGE"
	s obj.FileType = "jpg"
	s obj.TaskIP = "127.0.0.1"
	s obj.TaskDate = $p($h,",",1)
	s obj.TaskTime = $p($h,",",2)
	s status = obj.%Save()
	if ($$$ISOK(status))
	{
		q obj.%Id()
	}
	else
	{
		q ""
	}
}

/// w ##Class(EMRservice.BL.BLExportQueue).DOCTEST()
ClassMethod DOCTEST() As %String
{
	s obj = ##Class(EMRinstance.Export.Queue).%New()	
	//s obj = ##Class(EMRinstance.Export.Exe).%New()
	//s obj = ##Class(EMRinstance.Export.Succeed).%New()
	s obj.PatientID = "9"
	s obj.EpisodeID = "58"
	s obj.InstanceID = "24||109"
	s obj.PluginType = "DOC"
	s obj.ChartItemType = "Multiple"
	s obj.ClientIP = "127.0.0.1"
	s obj.HappenDate = $p($h,",",1)
	s obj.HappenTime = $p($h,",",2)
	s obj.PageCount = "3"
	s obj.StartPage = "1"
	s obj.EndPage = "3"
	s obj.Type = "IAMGE"
	s obj.FileType = "jpg"
	s obj.TaskIP = "127.0.0.1"
	s obj.TaskDate = $p($h,",",1)
	s obj.TaskTime = $p($h,",",2)
	s status = obj.%Save()
	if ($$$ISOK(status))
	{
		q obj.%Id()
	}
	else
	{
		q ""
	}
}

/// /判断记录ID是否在所设置科室中
/// w ##Class(EMRservice.BL.BLExportQueue).IdIsExitLocID("6","6^7^8")
ClassMethod IdIsExitLocID(LocID As %String, ListLocID As %String) As %String
{
	s ret=-1
	s Count=$l(ListLocID,"^")
	for i=1:1:Count
	{
		s tempID=$P(ListLocID,"^",i)
		if (tempID=LocID)
		{
			s ret=1
			q:ret
		}
	}
	q ret
}

/// /根据Locid从等待队列中取一条数据
/// w ##Class(EMRservice.BL.BLExportQueue).GetWaitIdByLocID("6^7^8")
ClassMethod GetWaitIdByLocID(ListLocID As %String) As %String
{
	
	s GetID=""
	s date=""
	for {
		    q:(GetID'="")
			s date =  $o(^DHCEMRI.Export.QueueI("IdxHappenDateTime", date),-1)
			q:(date="")			
			s time = ""
			for {
				q:(GetID'="")
				s time =  $o(^DHCEMRI.Export.QueueI("IdxHappenDateTime", date, time),-1)
				continue:(time = "")
				s rowID = ""
				for {
					s rowID = $o(^DHCEMRI.Export.QueueI("IdxHappenDateTime", date, time, rowID))
					continue:(rowID = "")				
					s obj = ##Class(EMRinstance.Export.Queue).%OpenId(rowID)
	                continue:(obj="")
	                s curLocID=..DisDept(obj.EpisodeID)
	                s IsExit=..IdIsExitLocID(curLocID,ListLocID)
	                if (IsExit="1")
	                {
		              s GetID=rowID
	                  q:(GetID'="")
	                }
				}
			}
		}
	q GetID
}

/// /根据Locid从等待队列中取一条数据
/// w ##Class(EMRservice.BL.BLExportQueue).GetWaitIdByLocID("6^7^8")
ClassMethod GetWaitIdByLocIDType(ListLocID As %String, OutType As %String) As %String
{
	
	s GetID=""
	s date=""
	for {
		    q:(GetID'="")
			s date =  $o(^DHCEMRI.Export.QueueI("IdxOTypeHappenDT"," "_outType, date),-1)
			q:(date="")			
			s time = ""
			for {
				q:(GetID'="")
				s time =  $o(^DHCEMRI.Export.QueueI("IdxOTypeHappenDT"," "_outType, date, time),-1)
				continue:(time = "")
				s rowID = ""
				for {
					s rowID = $o(^DHCEMRI.Export.QueueI("IdxOTypeHappenDT"," "_outType, date, time, rowID))
					continue:(rowID = "")				
					s obj = ##Class(EMRinstance.Export.Queue).%OpenId(rowID)
	                continue:(obj="")
	                s curLocID=..DisDept(obj.EpisodeID)
	                s IsExit=..IdIsExitLocID(curLocID,ListLocID)
	                if (IsExit="1")
	                {
		              s GetID=rowID
	                  q:(GetID'="")
	                }
				}
			}
		}
	q GetID
}

/// /根据Locid从等待队列中取一条数据
/// w ##Class(EMRservice.BL.BLExportQueue).GetWaitIdByLocID("6^7^8")
ClassMethod GetWaitIdByLocIDAdmType(ListLocID As %String, OutType As %String, AdmType As %String) As %String
{
	
	s GetID=""
	s date=""
	for {
		    q:(GetID'="")
			s date =  $o(^DHCEMRI.Export.QueueI("IdxAdOTypeHappenDT"," "_AdmType," "_OutType, date),-1)
			q:(date="")			
			s time = ""
			for {
				q:(GetID'="")
				s time =  $o(^DHCEMRI.Export.QueueI("IdxAdOTypeHappenDT"," "_AdmType," "_OutType, date, time),-1)
				continue:(time = "")
				s rowID = ""
				for {
					s rowID = $o(^DHCEMRI.Export.QueueI("IdxAdOTypeHappenDT"," "_AdmType," "_OutType, date, time, rowID))
					continue:(rowID = "")				
					s obj = ##Class(EMRinstance.Export.Queue).%OpenId(rowID)
	                continue:(obj="")
	                s curLocID=..DisDept(obj.EpisodeID)
	                s IsExit=..IdIsExitLocID(curLocID,ListLocID)
	                if (IsExit="1")
	                {
		              s GetID=rowID
	                  q:(GetID'="")
	                }
				}
			}
		}
	q GetID
}

/// /根据Locid从等待队列中取一条数据
/// w ##Class(EMRservice.BL.BLExportQueue).GetWaitIdByLocID("6^7^8")
ClassMethod GetWaitIdByTypeLocID(ListLocID As %String, docType As %String, AdmType As %String) As %String
{
	
	s GetID=""
	s date=""
	for {
		    q:(GetID'="")
			s date =  $o(^DHCEMRI.Export.QueueI("IdxHappenPTDateTime"," "_docType, date),-1)
			q:(date="")			
			s time = ""
			for {
				q:(GetID'="")
				s time =  $o(^DHCEMRI.Export.QueueI("IdxHappenPTDateTime"," "_docType, date, time),-1)
				continue:(time = "")
				s rowID = ""
				for {
					s rowID = $o(^DHCEMRI.Export.QueueI("IdxHappenPTDateTime"," "_docType, date, time, rowID))
					continue:(rowID = "")				
					s obj = ##Class(EMRinstance.Export.Queue).%OpenId(rowID)
	                continue:(obj="")
	                s curLocID=..DisDept(obj.EpisodeID)
	                s IsExit=..IdIsExitLocID(curLocID,ListLocID)
	                if (IsExit="1")
	                {
		              s GetID=rowID
	                  q:(GetID'="")
	                }
				}
			}
		}
	q GetID
}

/// /根据Locid从执行队列中取一条数据
/// w ##Class(EMRservice.BL.BLExportQueue).GetExeIdByLocID("6^7^8")
ClassMethod GetExeIdByLocID(ListLocID As %String) As %String
{
	s GetID=""
	s date=""
	for {
		    q:(GetID'="")
			s date =  $o(^DHCEMRI.Export.ExeI("IdxHappenDateTime", date),-1)
			q:(date="")				
			s time = ""
			for {
				q:(GetID'="")
				s time =  $o(^DHCEMRI.Export.ExeI("IdxHappenDateTime", date, time),-1)
				continue:(time = "")
				s rowID = ""
				for {
					s rowID = $o(^DHCEMRI.Export.ExeI("IdxHappenDateTime", date, time, rowID))
					continue:(rowID = "")				
					s obj = ##Class(EMRinstance.Export.Exe).%OpenId(rowID)
	                continue:(obj="")
	                s curLocID=..DisDept(obj.EpisodeID)
	                s IsExit=..IdIsExitLocID(curLocID,ListLocID)
	                if (IsExit="1")
	                {
		              s GetID=rowID
	                  q:(GetID'="")
	                }
				}
			}
		}
	q GetID
}

/// /根据Locid从执行队列中取一条数据
/// w ##Class(EMRservice.BL.BLExportQueue).GetExeIdByLocID("6^7^8")
ClassMethod GetExeIdByLocIDType(ListLocID As %String, outType As %String) As %String
{
	s GetID=""
	s date=""
	for {
		    q:(GetID'="")
			s date =  $o(^DHCEMRI.Export.ExeI("IdxOTypeHappenDT"," "_outType, date),-1)
			q:(date="")				
			s time = ""
			for {
				q:(GetID'="")
				s time =  $o(^DHCEMRI.Export.ExeI("IdxOTypeHappenDT"," "_outType, date, time),-1)
				continue:(time = "")
				s rowID = ""
				for {
					s rowID = $o(^DHCEMRI.Export.ExeI("IdxOTypeHappenDT"," "_outType, date, time, rowID))
					continue:(rowID = "")				
					s obj = ##Class(EMRinstance.Export.Exe).%OpenId(rowID)
	                continue:(obj="")
	                s curLocID=..DisDept(obj.EpisodeID)
	                s IsExit=..IdIsExitLocID(curLocID,ListLocID)
	                if (IsExit="1")
	                {
		              s GetID=rowID
	                  q:(GetID'="")
	                }
				}
			}
		}
	q GetID
}

/// /根据Locid从执行队列中取一条数据
/// w ##Class(EMRservice.BL.BLExportQueue).GetExeIdByLocID("6^7^8")
ClassMethod GetExeIdByLocIDAdmType(ListLocID As %String, outType As %String, AdmType As %String) As %String
{
	s GetID=""
	s date=""
	for {
		    q:(GetID'="")
			s date =  $o(^DHCEMRI.Export.ExeI("IdxAdOTypeHappenDT"," "_AdmType," "_outType, date),-1)
			q:(date="")				
			s time = ""
			for {
				q:(GetID'="")
				s time =  $o(^DHCEMRI.Export.ExeI("IdxAdOTypeHappenDT"," "_AdmType," "_outType, date, time),-1)
				continue:(time = "")
				s rowID = ""
				for {
					s rowID = $o(^DHCEMRI.Export.ExeI("IdxAdOTypeHappenDT"," "_AdmType," "_outType, date, time, rowID))
					continue:(rowID = "")				
					s obj = ##Class(EMRinstance.Export.Exe).%OpenId(rowID)
	                continue:(obj="")
	                s curLocID=..DisDept(obj.EpisodeID)
	                s IsExit=..IdIsExitLocID(curLocID,ListLocID)
	                if (IsExit="1")
	                {
		              s GetID=rowID
	                  q:(GetID'="")
	                }
				}
			}
		}
	q GetID
}

/// /根据Locid从执行队列中取一条数据
/// w ##Class(EMRservice.BL.BLExportQueue).GetExeIdByLocID("6^7^8")
ClassMethod GetExeIdByTypeLocID(ListLocID As %String, docType As %String) As %String
{
	s GetID=""
	s date=""
	for {
		    q:(GetID'="")
			s date =  $o(^DHCEMRI.Export.ExeI("IdxHappenPTDateTime"," "_docType ,date),-1)
			q:(date="")				
			s time = ""
			for {
				q:(GetID'="")
				s time =  $o(^DHCEMRI.Export.ExeI("IdxHappenPTDateTime"," "_docType, date, time),-1)
				continue:(time = "")
				s rowID = ""
				for {
					s rowID = $o(^DHCEMRI.Export.ExeI("IdxHappenPTDateTime"," "_docType, date, time, rowID))
					continue:(rowID = "")				
					s obj = ##Class(EMRinstance.Export.Exe).%OpenId(rowID)
	                continue:(obj="")
	                s curLocID=..DisDept(obj.EpisodeID)
	                s IsExit=..IdIsExitLocID(curLocID,ListLocID)
	                if (IsExit="1")
	                {
		              s GetID=rowID
	                  q:(GetID'="")
	                }
				}
			}
		}
	q GetID
}

/// 判断实例病历ID是否删除了，删除等待或者执行队列中的数据，如果成功队列中有该数据删除
/// w ##Class(EMRservice.BL.BLExportQueue).CheckInstanceIDIsDelete("2","Exe")
ClassMethod CheckInstanceIDIsDelete(ID As %String, Type As %String) As %String
{
	
    q:(ID="") 0
	s obj=""
	if (Type="Wait")
	{
		s obj = ##Class(EMRinstance.Export.Queue).%OpenId(ID)
	}
	elseif (Type="Exe")
	{
	    s obj = ##Class(EMRinstance.Export.Exe).%OpenId(ID)	
	}
	elseif (Type="Succed")
	{
	    s obj = ##Class(EMRinstance.Export.Succeed).%OpenId(ID)	   	
	}
	elseif (Type="Failure")
	{
	    s obj = ##Class(EMRinstance.Export.Failure).%OpenId(ID)	   	
	}
	
	q:(obj="") 0	
	s objInstanceData = ##class(EMRinstance.InstanceData).%OpenId(obj.InstanceID)
	q:(objInstanceData="") 0
	if (objInstanceData.Status'="Save")
	{
		if (Type="Wait")
		{ 
		   Set sc = ##Class(EMRinstance.Export.Queue).%DeleteId(ID)
	       if ($$$ISOK(sc))
	       {	
	          q 1	         
		   }
		   else
	       {
			  q 0
		   }
		}
		
		if (Type="Exe")
		{		  
		   Set sc = ##Class(EMRinstance.Export.Exe).%DeleteId(ID)
	       if ($$$ISOK(sc))
	       {	
	          q 1	         
		   }
		   else
	       {
			  q 0
		   }		 
		}
		
		if (Type="Failure")
		{		  
		   Set sc = ##Class(EMRinstance.Export.Failure).%DeleteId(ID)
	       if ($$$ISOK(sc))
	       {	
	          q 1	         
		   }
		   else
	       {
			  q 0
		   }		 
		}							
	}
	q 0
}

/// 等待队列移动到执行队列
/// w ##Class(EMRservice.BL.BLExportQueue).WaitMoveToExe("260")
ClassMethod WaitMoveToExe(ID As %String, OutType As %String) As %String
{
	
	q:(ID="") 0
	s obj = ##Class(EMRinstance.Export.Queue).%OpenId(ID)	
	q:(obj="") 0	
	s Exeobj=""
	TStart
	
	s sID = $o(^DHCEMRI.Export.ExeI("IdxTyQueue"," "_OutType, " "_obj.PatientID, " "_obj.EpisodeID," "_obj.InstanceID,""),-1)
	if (sID="")
	{
	s Exeobj = ##Class(EMRinstance.Export.Exe).%New()
	s Exeobj.ChartItemType =obj.ChartItemType
	s Exeobj.ClientIP =obj.ClientIP
	s Exeobj.EndPage =obj.EndPage
	s Exeobj.EpisodeID =obj.EpisodeID
	s Exeobj.HappenDate =obj.HappenDate
	s Exeobj.HappenTime =obj.HappenTime
	s Exeobj.InstanceID =obj.InstanceID
	s Exeobj.PageCount =obj.PageCount
	s Exeobj.PatientID =obj.PatientID
	s Exeobj.PluginType =obj.PluginType
	s Exeobj.Priority =obj.Priority
	s Exeobj.StartPage =obj.StartPage
	s Exeobj.TaskIP =obj.TaskIP
	s Exeobj.TaskRemark =obj.TaskRemark
	//s Exeobj.TaskDate =obj.TaskDate
	//s Exeobj.TaskTime =obj.TaskTime
	s Exeobj.TaskDate = $p($h,",",1)
	s Exeobj.TaskTime = $p($h,",",2)
	s Exeobj.Type =obj.Type	
	s Exeobj.FileType =obj.FileType
	}
	else
	{
	s Exeobj = ##Class(EMRinstance.Export.Exe).%OpenId(sID)
	s Exeobj.ChartItemType =obj.ChartItemType
	s Exeobj.ClientIP =obj.ClientIP
	s Exeobj.EndPage =obj.EndPage
	s Exeobj.EpisodeID =obj.EpisodeID
	s Exeobj.HappenDate =obj.HappenDate
	s Exeobj.HappenTime =obj.HappenTime
	s Exeobj.InstanceID =obj.InstanceID
	s Exeobj.PageCount =obj.PageCount
	s Exeobj.PatientID =obj.PatientID
	s Exeobj.PluginType =obj.PluginType
	s Exeobj.Priority =obj.Priority
	s Exeobj.StartPage =obj.StartPage
	s Exeobj.TaskIP =obj.TaskIP
	s Exeobj.TaskRemark =obj.TaskRemark
	//s Exeobj.TaskDate =obj.TaskDate
	//s Exeobj.TaskTime =obj.TaskTime
	s Exeobj.TaskDate = $p($h,",",1)
	s Exeobj.TaskTime = $p($h,",",2)
	s Exeobj.Type =obj.Type
	s Exeobj.FileType =obj.FileType
	}
	s status = Exeobj.%Save()
	if ($$$ISOK(status))
	{
		Set sc = ##Class(EMRinstance.Export.Queue).%DeleteId(ID)
	    if ($$$ISOK(sc))
	    {
		    TCommit	
		    q Exeobj.%Id()    
		}
		else
		{
			TRollback
			q 0
		}	
	}
	else
	{
		TRollback
		q 0
	}
}

/// 删除执行队列中一条数据
/// w ##Class(EMRservice.BL.BLExportQueue).DeleteExeByID("1")
ClassMethod DeleteExeByID(ID As %String) As %String
{
	q:(ID="") 0
	s obj = ##Class(EMRinstance.Export.Exe).%OpenId(ID)
	q:(obj="") 0
	Set sc = ##Class(EMRinstance.Export.Exe).%DeleteId(ID)
	if ($$$ISOK(sc))
	    {
		    q ID    
		}
	else
		{
			q 0
		}
}

/// 执行队列移动到完成队列
/// w ##Class(EMRservice.BL.BLExportQueue).ExeMoveToSucced("1924")
ClassMethod ExeMoveToSucced(ID As %String, OutType As %String) As %String
{
	
	q:(ID="") 0
	s obj = ##Class(EMRinstance.Export.Exe).%OpenId(ID)
	q:(obj="")	
	s Succedobj=""
	TStart
	
	s sID =..CheckInstanceIDIsExit(obj.PatientID,obj.EpisodeID,obj.InstanceID,"Succed",OutType)
	//如果该实例ID不存在则新建，否则更新
	if (sID>0)
	{		
	s Succedobj = ##Class(EMRinstance.Export.Succeed).%OpenId(sID)
	s Succedobj.ChartItemType =obj.ChartItemType
	s Succedobj.ClientIP =obj.ClientIP
	s Succedobj.EndPage =obj.EndPage
	s Succedobj.EpisodeID =obj.EpisodeID
	s Succedobj.HappenDate =obj.HappenDate
	s Succedobj.HappenTime =obj.HappenTime
	s Succedobj.InstanceID =obj.InstanceID
	s Succedobj.PageCount =obj.PageCount
	s Succedobj.PatientID =obj.PatientID
	s Succedobj.PluginType =obj.PluginType
	s Succedobj.Priority =obj.Priority
	s Succedobj.StartPage =obj.StartPage
	s Succedobj.TaskDate =obj.TaskDate
	s Succedobj.TaskIP =obj.TaskIP
	s Succedobj.TaskRemark =obj.TaskRemark
	s Succedobj.TaskTime =obj.TaskTime
	s Succedobj.Type =obj.Type
	s Succedobj.FileType =obj.FileType			
	}
	else
	{
	s Succedobj = ##Class(EMRinstance.Export.Succeed).%New()
	s Succedobj.ChartItemType =obj.ChartItemType
	s Succedobj.ClientIP =obj.ClientIP
	s Succedobj.EndPage =obj.EndPage
	s Succedobj.EpisodeID =obj.EpisodeID
	s Succedobj.HappenDate =obj.HappenDate
	s Succedobj.HappenTime =obj.HappenTime
	s Succedobj.InstanceID =obj.InstanceID
	s Succedobj.PageCount =obj.PageCount
	s Succedobj.PatientID =obj.PatientID
	s Succedobj.PluginType =obj.PluginType
	s Succedobj.Priority =obj.Priority
	s Succedobj.StartPage =obj.StartPage
	s Succedobj.TaskDate =obj.TaskDate
	s Succedobj.TaskIP =obj.TaskIP
	s Succedobj.TaskRemark =obj.TaskRemark
	s Succedobj.TaskTime =obj.TaskTime
	s Succedobj.Type =obj.Type	
	s Succedobj.FileType =obj.FileType	
	}
	s status = Succedobj.%Save()
	if ($$$ISOK(status))
	{
		Set sc = ##Class(EMRinstance.Export.Exe).%DeleteId(ID)
	    if ($$$ISOK(sc))
	    {
		    TCommit	
		    q Succedobj.%Id()      
		}
		else
		{
			TRollback
			q 0
		}	
	}
	else
	{
		TRollback
		q 0
	}
}

/// 更新完成队列信息
/// w ##Class(EMRservice.BL.BLExportQueue).UpdateSucced("22")
ClassMethod UpdateSucced(ID As %String, SuccedObj As EMRservice.entity.EQueue) As %String [ WebMethod ]
{
	q:(ID="") 0
	s obj = ##Class(EMRinstance.Export.Succeed).%OpenId(ID)
	q:(obj="")
	s obj.Type =SuccedObj.Type
	s obj.FileType = SuccedObj.FileType
	s obj.PageCount =SuccedObj.PageCount
	s obj.StartPage =SuccedObj.StartPage
	s obj.EndPage =SuccedObj.EndPage	
	s obj.TaskDate = $p($h,",",1)
	s obj.TaskTime = $p($h,",",2)
	s obj.TaskIP =SuccedObj.TaskIP	
	s status = obj.%Save()
	if ($$$ISOK(status))
	{
		q ID
	}
	else
	{
		q 0
	}
}

/// 获取队列信息
/// w ##Class(EMRservice.BL.BLExportQueue).GetQueueByID("19","Exe")
ClassMethod GetQueueByID(ID As %String, Type As %String) As EMRservice.entity.EQueue [ WebMethod ]
{
   
	q:(ID="") ""
	s obj=""
	set Result = ##class(EMRservice.entity.EQueue).%New()
	if (Type="Wait")
	{
		s obj = ##Class(EMRinstance.Export.Queue).%OpenId(ID)
	}
	elseif (Type="Exe")
	{
	    s obj = ##Class(EMRinstance.Export.Exe).%OpenId(ID)	
	}
	elseif (Type="Succed")
	{
	    s obj = ##Class(EMRinstance.Export.Succeed).%OpenId(ID)	   	
	}
	elseif (Type="Failure")
	{
	    s obj = ##Class(EMRinstance.Export.Failure).%OpenId(ID)	   	
	}
	
	q:(obj="") ""
	
	
	s Result.ChartItemType =obj.ChartItemType
	s Result.ClientIP =obj.ClientIP
	s Result.EndPage =obj.EndPage
	s Result.EpisodeID =obj.EpisodeID
	s Result.HappenDate =obj.HappenDate
	s Result.HappenTime =obj.HappenTime
	s Result.InstanceID =obj.InstanceID
	s Result.PageCount =obj.PageCount
	s Result.PatientID =obj.PatientID
	s Result.PluginType =obj.PluginType
	s Result.Priority =obj.Priority
	s Result.StartPage =obj.StartPage
	s Result.TaskDate =obj.TaskDate
	s Result.TaskIP =obj.TaskIP
	s Result.TaskRemark =obj.TaskRemark
	s Result.TaskTime =obj.TaskTime
	s Result.Type =obj.Type   
	s Result.FileType =obj.FileType
	q Result
}

/// 获取完成队列信息
/// w ##Class(EMRservice.BL.BLExportQueue).GetMaxQueue("Exe","6^7^8")
ClassMethod GetMaxQueue(Type As %String, ListLocID As %String) As %String
{
	s rowID="0"
	if (Type="Wait")
	{
		if (ListLocID="ALL")
		{
		   s date =  $o(^DHCEMRI.Export.QueueI("IdxHappenDateTime", ""),-1)
	       q:(date="") 0
	       s time =  $o(^DHCEMRI.Export.QueueI("IdxHappenDateTime", date, ""),-1)
	       q:(time="") 0
	       s rowID = $o(^DHCEMRI.Export.QueueI("IdxHappenDateTime", date, time, ""))
	       q:(rowID="") 0
		}
		else
		{
		   s rowID=..GetWaitIdByLocID(ListLocID)
		   q:(rowID="") 0
		}
	   
	}
	elseif (Type="Exe")
	{
		if (ListLocID="ALL")
		{
			s date =  $o(^DHCEMRI.Export.ExeI("IdxHappenDateTime", ""),-1)
	        q:(date="") 0
	        s time =  $o(^DHCEMRI.Export.ExeI("IdxHappenDateTime", date, ""),-1)
	        q:(time="") 0
	        s rowID = $o(^DHCEMRI.Export.ExeI("IdxHappenDateTime", date, time, ""))
	        q:(rowID="") 0
		}
		else
		{
			s rowID=..GetExeIdByLocID(ListLocID)
		    q:(rowID="") 0
		}
	}
	elseif (Type="Succed")
	{
	    s date =  $o(^DHCEMRI.Export.SucceedI("IdxHappenDateTime", ""),-1)
	    q:(date="") 0
	    s time =  $o(^DHCEMRI.Export.SucceedI("IdxHappenDateTime", date, ""),-1)
	    q:(time="") 0
	    s rowID = $o(^DHCEMRI.Export.SucceedI("IdxHappenDateTime", date, time, ""))
	    q:(rowID="") 0
	}
	elseif (Type="Failure")
	{
	    s date =  $o(^DHCEMRI.Export.FailureI("IdxHappenDateTime", ""),-1)
	    q:(date="") 0
	    s time =  $o(^DHCEMRI.Export.FailureI("IdxHappenDateTime", date, ""),-1)
	    q:(time="") 0
	    s rowID = $o(^DHCEMRI.Export.FailureI("IdxHappenDateTime", date, time, ""))
	    q:(rowID="") 0
	}
	q rowID
}

/// 获取完成队列信息
/// w ##Class(EMRservice.BL.BLExportQueue).GetMaxQueue("Exe","6^7^8")
ClassMethod GetMaxTypeQueue(Type As %String, ListLocID As %String, docType As %String) As %String
{
	s rowID="0"
	if (Type="Wait")
	{
		if (ListLocID="ALL")
		{
		   s date =  $o(^DHCEMRI.Export.QueueI("IdxHappenPTDateTime"," "_docType, ""),-1)
	       q:(date="") 0
	       s time =  $o(^DHCEMRI.Export.QueueI("IdxHappenPTDateTime"," "_docType, date, ""),-1)
	       q:(time="") 0
	       s rowID = $o(^DHCEMRI.Export.QueueI("IdxHappenPTDateTime"," "_docType, date, time, ""))
	       q:(rowID="") 0
		}
		else
		{
		   s rowID=..GetWaitIdByTypeLocID(ListLocID)
		   q:(rowID="") 0
		}
	   
	}
	elseif (Type="Exe")
	{
		if (ListLocID="ALL")
		{
			s date =  $o(^DHCEMRI.Export.ExeI("IdxHappenPTDateTime"," "_docType, ""),-1)
	        q:(date="") 0
	        s time =  $o(^DHCEMRI.Export.ExeI("IdxHappenPTDateTime"," "_docType, date, ""),-1)
	        q:(time="") 0
	        s rowID = $o(^DHCEMRI.Export.ExeI("IdxHappenPTDateTime"," "_docType, date, time, ""))
	        q:(rowID="") 0
		}
		else
		{
			s rowID=..GetExeIdByTypeLocID(ListLocID)
		    q:(rowID="") 0
		}
	}
	elseif (Type="Succed")
	{
	    s date =  $o(^DHCEMRI.Export.SucceedI("IdxHappenDateTime", ""),-1)
	    q:(date="") 0
	    s time =  $o(^DHCEMRI.Export.SucceedI("IdxHappenDateTime", date, ""),-1)
	    q:(time="") 0
	    s rowID = $o(^DHCEMRI.Export.SucceedI("IdxHappenDateTime", date, time, ""))
	    q:(rowID="") 0
	}
	elseif (Type="Failure")
	{
	    s date =  $o(^DHCEMRI.Export.FailureI("IdxHappenDateTime", ""),-1)
	    q:(date="") 0
	    s time =  $o(^DHCEMRI.Export.FailureI("IdxHappenDateTime", date, ""),-1)
	    q:(time="") 0
	    s rowID = $o(^DHCEMRI.Export.FailureI("IdxHappenDateTime", date, time, ""))
	    q:(rowID="") 0
	}
	q rowID
}

/// 获取完成队列信息
/// w ##Class(EMRservice.BL.BLExportQueue).GetMaxQueue("Wait","ALL","XML","")
ClassMethod GetMaxQueueByType(Type As %String, ListLocID As %String, outType As %String, AdmType As %String) As %String
{
	s rowID="0"
	s ^GetMaxQueueByType = AdmType
	if ((outType="")||(outType=$c(0)))&&((AdmType="")||(AdmType=$c(0)))
	{
		s rowID = ##Class(EMRservice.BL.BLExportQueue).GetMaxQueue(Type,ListLocID)
	}
	else
	{
		if ((AdmType="")||(AdmType=$c(0)))
		{
			s rowID = ##Class(EMRservice.BL.BLExportQueue).GetMaxQueueByOutType(Type,ListLocID,outType)
		}
		else
		{
			s rowID = ##Class(EMRservice.BL.BLExportQueue).GetMaxQueueByAdmOutType(Type,ListLocID,outType,AdmType)
		}
	}
	

	
	q rowID
}

/// 获取完成队列信息
/// w ##Class(EMRservice.BL.BLExportQueue).GetMaxQueue("Exe","6^7^8")
ClassMethod GetMaxQueueByOutType(Type As %String, ListLocID As %String, outType As %String) As %String
{
	s rowID="0"
	if (Type="Wait")
	{
		if (ListLocID="ALL")
		{
		   s date =  $o(^DHCEMRI.Export.QueueI("IdxOTypeHappenDT"," "_outType, ""),-1)
	       q:(date="") 0
	       s time =  $o(^DHCEMRI.Export.QueueI("IdxOTypeHappenDT"," "_outType,  date, ""),-1)
	       q:(time="") 0
	       s rowID = $o(^DHCEMRI.Export.QueueI("IdxOTypeHappenDT"," "_outType,  date, time, ""))
	       q:(rowID="") 0
		}
		else
		{
		   s rowID=..GetWaitIdByLocIDType(ListLocID,outType)
		   q:(rowID="") 0
		}
	   
	}
	elseif (Type="Exe")
	{
		if (ListLocID="ALL")
		{
			s date =  $o(^DHCEMRI.Export.ExeI("IdxOTypeHappenDT"," "_outType, ""),-1)
	        q:(date="") 0
	        s time =  $o(^DHCEMRI.Export.ExeI("IdxOTypeHappenDT"," "_outType, date, ""),-1)
	        q:(time="") 0
	        s rowID = $o(^DHCEMRI.Export.ExeI("IdxOTypeHappenDT"," "_outType, date, time, ""))
	        q:(rowID="") 0
		}
		else
		{
			s rowID=..GetExeIdByLocIDType(ListLocID,outType)
		    q:(rowID="") 0
		}
	}
	elseif (Type="Succed")
	{
	    s date =  $o(^DHCEMRI.Export.SucceedI("IdxOTypeHappenDT"," "_outType, ""),-1)
	    q:(date="") 0
	    s time =  $o(^DHCEMRI.Export.SucceedI("IdxOTypeHappenDT"," "_outType, date, ""),-1)
	    q:(time="") 0
	    s rowID = $o(^DHCEMRI.Export.SucceedI("IdxOTypeHappenDT"," "_outType, date, time, ""))
	    q:(rowID="") 0
	}
	elseif (Type="Failure")
	{
	    s date =  $o(^DHCEMRI.Export.FailureI("IdxOTypeHappenDT"," "_outType, ""),-1)
	    q:(date="") 0
	    s time =  $o(^DHCEMRI.Export.FailureI("IdxOTypeHappenDT"," "_outType, date, ""),-1)
	    q:(time="") 0
	    s rowID = $o(^DHCEMRI.Export.FailureI("IdxOTypeHappenDT"," "_outType, date, time, ""))
	    q:(rowID="") 0
	}
	q rowID
}

/// 获取完成队列信息
/// w ##Class(EMRservice.BL.BLExportQueue).GetMaxQueue("Exe","6^7^8")
ClassMethod GetMaxQueueByAdmOutType(Type As %String, ListLocID As %String, outType As %String, AdmType As %String) As %String
{
	s rowID="0"
	if (Type="Wait")
	{
		if (ListLocID="ALL")
		{
		   s date =  $o(^DHCEMRI.Export.QueueI("IdxAdOTypeHappenDT"," "_AdmType," "_outType, ""),-1)
	       q:(date="") 0
	       s time =  $o(^DHCEMRI.Export.QueueI("IdxAdOTypeHappenDT"," "_AdmType," "_outType,  date, ""),-1)
	       q:(time="") 0
	       s rowID = $o(^DHCEMRI.Export.QueueI("IdxAdOTypeHappenDT"," "_AdmType," "_outType,  date, time, ""))
	       q:(rowID="") 0
		}
		else
		{
		   s rowID=..GetWaitIdByLocIDAdmType(ListLocID,outType,AdmType)
		   q:(rowID="") 0
		}
	   
	}
	elseif (Type="Exe")
	{
		if (ListLocID="ALL")
		{
			s date =  $o(^DHCEMRI.Export.ExeI("IdxAdOTypeHappenDT"," "_AdmType," "_outType, ""),-1)
	        q:(date="") 0
	        s time =  $o(^DHCEMRI.Export.ExeI("IdxAdOTypeHappenDT"," "_AdmType," "_outType, date, ""),-1)
	        q:(time="") 0
	        s rowID = $o(^DHCEMRI.Export.ExeI("IdxAdOTypeHappenDT"," "_AdmType," "_outType, date, time, ""))
	        q:(rowID="") 0
		}
		else
		{
			s rowID=..GetExeIdByLocIDAdmType(ListLocID,outType,AdmType)
		    q:(rowID="") 0
		}
	}
	elseif (Type="Succed")
	{
	    s date =  $o(^DHCEMRI.Export.SucceedI("IdxAdOTypeHappenDT"," "_AdmType," "_outType, ""),-1)
	    q:(date="") 0
	    s time =  $o(^DHCEMRI.Export.SucceedI("IdxAdOTypeHappenDT"," "_AdmType," "_outType, date, ""),-1)
	    q:(time="") 0
	    s rowID = $o(^DHCEMRI.Export.SucceedI("IdxAdOTypeHappenDT"," "_AdmType," "_outType, date, time, ""))
	    q:(rowID="") 0
	}
	elseif (Type="Failure")
	{
	    s date =  $o(^DHCEMRI.Export.FailureI("IdxAdOTypeHappenDT"," "_AdmType," "_outType, ""),-1)
	    q:(date="") 0
	    s time =  $o(^DHCEMRI.Export.FailureI("IdxAdOTypeHappenDT"," "_AdmType," "_outType, date, ""),-1)
	    q:(time="") 0
	    s rowID = $o(^DHCEMRI.Export.FailureI("IdxAdOTypeHappenDT"," "_AdmType," "_outType, date, time, ""))
	    q:(rowID="") 0
	}
	q rowID
}

/// 获取待执行队列列表
/// Debug: do ##class(%ResultSet).RunQuery("EMRservice.BL.BLExportQueue","GetExprtQueueList","2015-04-06","2015-05-30")
Query GetExprtQueueList(AStartDate As %String, AEndDate As %String, outType As %String) As %Query(ROWSPEC = "ID:%String,PatientID:%String,EpisodeID:%String,InstanceID:%String,pluginType:%String,chartItemType:%String,ClientIP:%String,HappenDate:%String,HappenTime:%String,Priority:%String")
{
}

ClassMethod GetExprtQueueListExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String, outType As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
    
    q:(AStartDate = "") $$$OK
    q:(AEndDate = "") $$$OK
	s startDate = $zdh(AStartDate,3)
	s endDate = $zdh(AEndDate,3)
	s date = endDate+1
	
	for {
			s date =  $o(^DHCEMRI.Export.QueueI("IdxOTypeHappenDT"," "_outType, date),-1)
			//b "s"
			q:(date = "")
			q:(date<startDate)
			s time = ""

			for {
				s time =  $o(^DHCEMRI.Export.QueueI("IdxOTypeHappenDT"," "_outType, date, time),-1)
				q:(time = "")

				s rowID = ""
				for {
					s rowID = $o(^DHCEMRI.Export.QueueI("IdxOTypeHappenDT"," "_outType, date, time, rowID))
					q:(rowID = "")
					s obj = ##class(EMRinstance.Export.Queue).%OpenId(rowID)
					d OutPutRow
				}
			}
		}
		//ID:%String,PatientID:%String,EpisodeID:%String,InstanceID:%String,pluginType:%String,chartItemType:%String,ClientIP:%String,HappenDate:%String,HappenTime:%String,Priority:%String
	Quit $$$OK
OutPutRow
	s ID = rowID
	s PatientID = obj.PatientID
	s EpisodeID = obj.EpisodeID
	s InstanceID = obj.InstanceID
	s PluginType = obj.PluginType
	s ChartItemType = obj.ChartItemType
	s ClientIP = obj.ClientIP	
	s Priority = obj.Priority
	s HappenDate = $zd(obj.HappenDate,3)
	s HappenTime = $zt(obj.HappenTime,1)
	
	 
 	s data = $lb(ID,PatientID,EpisodeID,InstanceID,PluginType,ChartItemType,ClientIP,HappenDate,HappenTime,Priority)
	s ^CacheTemp(repid,ind)=data
	s ind=ind+1 
	q
}

ClassMethod GetExprtQueueListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetExprtQueueListExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetExprtQueueListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetExprtQueueListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

/// 获取执行队列列表
/// Debug: do ##class(%ResultSet).RunQuery("EMRservice.BL.BLExportQueue","GetExeExprtQueueList","2015-04-06","2015-05-30")
Query GetExeExprtQueueList(AStartDate As %String, AEndDate As %String, outType As %String) As %Query(ROWSPEC = "ID:%String,PatientID:%String,EpisodeID:%String,InstanceID:%String,pluginType:%String,chartItemType:%String,ClientIP:%String,HappenDate:%String,HappenTime:%String,Priority:%String")
{
}

ClassMethod GetExeExprtQueueListExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String, outType As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
    
    q:(AStartDate = "") $$$OK
    q:(AEndDate = "") $$$OK
	s startDate = $zdh(AStartDate,3)
	s endDate = $zdh(AEndDate,3)
	s date = endDate+1
	
	for {
			s date =  $o(^DHCEMRI.Export.ExeI("IdxOTypeHappenDT"," "_outType, date),-1)
			//b "s"
			q:(date = "")
			q:(date<startDate)
			s time = ""

			for {
				s time =  $o(^DHCEMRI.Export.ExeI("IdxOTypeHappenDT"," "_outType, date, time),-1)
				q:(time = "")

				s rowID = ""
				for {
					s rowID = $o(^DHCEMRI.Export.ExeI("IdxOTypeHappenDT"," "_outType, date, time, rowID))
					q:(rowID = "")
					s obj = ##class(EMRinstance.Export.Exe).%OpenId(rowID)
					d OutPutRow
				}
			}
		}
		//ID:%String,PatientID:%String,EpisodeID:%String,InstanceID:%String,pluginType:%String,chartItemType:%String,ClientIP:%String,HappenDate:%String,HappenTime:%String,Priority:%String
	Quit $$$OK
OutPutRow
	s ID = rowID
	s PatientID = obj.PatientID
	s EpisodeID = obj.EpisodeID
	s InstanceID = obj.InstanceID
	s PluginType = obj.PluginType
	s ChartItemType = obj.ChartItemType
	s ClientIP = obj.ClientIP	
	s Priority = obj.Priority
	s HappenDate = $zd(obj.HappenDate,3)
	s HappenTime = $zt(obj.HappenTime,1)
	
	 
 	s data = $lb(ID,PatientID,EpisodeID,InstanceID,PluginType,ChartItemType,ClientIP,HappenDate,HappenTime,Priority)
	s ^CacheTemp(repid,ind)=data
	s ind=ind+1 
	q
}

ClassMethod GetExeExprtQueueListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetExeExprtQueueListExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetExeExprtQueueListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetExeExprtQueueListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

/// 获取完成队列列表
/// Debug: do ##class(%ResultSet).RunQuery("EMRservice.BL.BLExportQueue","GetSuccedExprtQueueList","2015-04-06","2015-05-30")
Query GetSuccedExprtQueueList(AStartDate As %String, AEndDate As %String, outType As %String) As %Query(ROWSPEC = "ID:%String,PatientID:%String,EpisodeID:%String,InstanceID:%String,pluginType:%String,chartItemType:%String,ClientIP:%String,HappenDate:%String,HappenTime:%String,Priority:%String,PageCount:%String,StartPage:%String,EndPage:%String,Type:%String,FileType:%String,TaskIP:%String,TaskDate:%String,TaskTime:%String")
{
}

ClassMethod GetSuccedExprtQueueListExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String, outType As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
    
    q:(AStartDate = "") $$$OK
    q:(AEndDate = "") $$$OK
	s startDate = $zdh(AStartDate,3)
	s endDate = $zdh(AEndDate,3)
	s date = endDate+1
	
	for {
			s date =  $o(^DHCEMRI.Export.SucceedI("IdxTyTaskDateTime"," "_outType, date),-1)
			//b "s"
			q:(date = "")
			q:(date<startDate)
			s time = ""

			for {
				s time =  $o(^DHCEMRI.Export.SucceedI("IdxTyTaskDateTime"," "_outType, date, time),-1)
				q:(time = "")

				s rowID = ""
				for {
					s rowID = $o(^DHCEMRI.Export.SucceedI("IdxTyTaskDateTime"," "_outType, date, time, rowID))
					q:(rowID = "")
					s obj = ##class(EMRinstance.Export.Succeed).%OpenId(rowID)
					d OutPutRow
				}
			}
		}
		//ID:%String,PatientID:%String,EpisodeID:%String,InstanceID:%String,pluginType:%String,chartItemType:%String,ClientIP:%String,HappenDate:%String,HappenTime:%String,Priority:%String
		//PageCount:%String,StartPage:%String,EndPage:%String,Type:%String,TaskDate:%String,TaskTime:%String
	Quit $$$OK
OutPutRow
	s ID = rowID
	s PatientID = obj.PatientID
	s EpisodeID = obj.EpisodeID
	s InstanceID = obj.InstanceID
	s PluginType = obj.PluginType
	s ChartItemType = obj.ChartItemType
	s ClientIP = obj.ClientIP	
	s Priority = obj.Priority
	s HappenDate = $zd(obj.HappenDate,3)
	s HappenTime = $zt(obj.HappenTime,1)
	s PageCount = obj.PageCount
	s StartPage = obj.StartPage
	s EndPage = obj.EndPage	
	s Type = obj.Type
	s FileType = obj.FileType
	s TaskIP = obj.TaskIP
	s TaskDate = $zd(obj.TaskDate,3)
	s TaskTime = $zt(obj.TaskTime,1)	
	 
 	s data = $lb(ID,PatientID,EpisodeID,InstanceID,PluginType,ChartItemType,ClientIP,HappenDate,HappenTime,Priority,PageCount,StartPage,EndPage,Type,FileType,TaskIP,TaskDate,TaskTime)
	s ^CacheTemp(repid,ind)=data
	s ind=ind+1 
	q
}

ClassMethod GetSuccedExprtQueueListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSuccedExprtQueueListExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetSuccedExprtQueueListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSuccedExprtQueueListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

/// w ##Class(EMRservice.BL.BLExportQueue).GetImageCount("67","51")
ClassMethod GetImageCount(aEpisodeID As %String, aDocIDs As %String, OutType As %String = "") As %String
{
	q:((aEpisodeID="")||(aDocIDs="")) "0"
	
	s patientId=$P($G(^PAADM(aEpisodeID)),"^",1)	
	s imageCountList = ""
	s totCount = 0

	s idCount = $L(aDocIDs,"^")
	s rowid = ""
	for i=1:1:idCount 
	{
		s docId = $p($g(aDocIDs),"^",i)		
		
		s aInstanceID="",aTemplateID="",getMInstanceID=""
		for {
			  if ((OutType'="")&&(OutType'=$c(0)))
			  {
					s aInstanceID = $o(^DHCEMRI.Export.SucceedI("IdxTyQueue"," "_OutType, " "_patientId, " "_aEpisodeID,aInstanceID))
			  }
			  else
			  {
				  s aInstanceID = $o(^DHCEMRI.Export.SucceedI("IdxQueue"," "_patientId, " "_aEpisodeID,aInstanceID))
			  }
			  q:(aInstanceID="")			
			 
			  s sInstanceID=$p(aInstanceID," ",2) 
			  
			  s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(sInstanceID)  
	          q:(objInstance = "")
			  continue:(objInstance.Status'="Save")
			 
			  /*
			  S aLikeInID = $tr(tempMInstanceID," ","")_"||%"
			  s aMaxInID=""
		      &sql(SELECT InstanceID into :aMaxInID FROM EMRinstance_Export.Succeed WHERE ID =(SELECT max(ID) FROM EMRinstance_Export.Succeed s WHERE EpisodeID = :aEpisodeID AND s.InstanceID LIKE :aLikeInID))	
			  if (aMaxInID'="")
			  {
			  	s sInstanceID = aMaxInID
			  }
			  */
			 

			  ///过滤重复可重复的实例ID
			  s tempMInstanceID=$p(aInstanceID,"||",1) 
			  s strMInstanceID = ""
			  s strMListNo = ""
			  if ((objInstance.TheECRecord.ChartItemType ="Multiple")&&(getMInstanceID'=tempMInstanceID))
			  {
				s strInstanceIDM=tempMInstanceID_"||1"
				for {
					if ((OutType'="")&&(OutType'=$c(0)))
					{
						s strInstanceIDM = $o(^DHCEMRI.Export.SucceedI("IdxTyQueue"," "_OutType, " "_patientId, " "_aEpisodeID,strInstanceIDM))
					}
					else
					{
						s strInstanceIDM = $o(^DHCEMRI.Export.SucceedI("IdxQueue"," "_patientId, " "_aEpisodeID,strInstanceIDM))
					}
					q:(strInstanceIDM="")			
			 		s strListMNo = $p(strInstanceIDM,"||",2) 
			  		s sEcrecordIDM=$p(strInstanceIDM,"||",1) 
			  		if ((tempMInstanceID=sEcrecordIDM)&&(strListMNo>strMListNo))
			  		{
				  		s strMListNo = strListMNo
				  		s strMInstanceID = strInstanceIDM
			  		}
				}
				if (strMInstanceID'="")
				{
					s sInstanceID =$p(strMInstanceID," ",2) 
				}
			  }
			  
			  s strCharacteristic = ..GetCharacteristicByID($tr(aInstanceID," "))
			  if (((OutType="")||(OutType=$c(0))||(OutType="IMAGE"))&&(strCharacteristic="1"))
			  {
			  	continue:(getMInstanceID=tempMInstanceID)	
			  }		  
			  s getMInstanceID=tempMInstanceID

			 
	          s strDocID = objInstance.TheECRecord.ChartItemID
	          continue:(strDocID'=docId)
	          s strECRid = objInstance.TheECRecord.%Id()
			  s strCount =""
	          &sql(SELECT count(*) into :strCount FROM emrinstance.instancedata WHERE TheECRecord = :strECRid AND Status = 'Save')
			  continue:((strCount="")||(strCount=0))
			  s aTemplateID = objInstance.TemplateID
	          continue:(aTemplateID="")
	          
	          s aID=""
		      &sql(select ID into :aID from EMRmeta.EMRTemplate
			      where CategoryID = :docId and BindTemplateID = :aTemplateID)	
			  continue:(aID="")
			  
			  s sID=""
			  if ((OutType'="")&&(OutType'=$c(0)))
			  {
				  s sID = $o(^DHCEMRI.Export.SucceedI("IdxTyQueue"," "_OutType, " "_patientId, " "_aEpisodeID," "_sInstanceID,""),-1)
			  }
			  else
			  {
				  s sID = $o(^DHCEMRI.Export.SucceedI("IdxQueue"," "_patientId, " "_aEpisodeID," "_sInstanceID,""),-1)
			  }
			  continue:(sID="")
			  
			  s obj = ##Class(EMRinstance.Export.Succeed).%OpenId(sID)
			  continue:(obj="")
	          s pageCount =obj.PageCount
	          s Type=obj.Type
	          //兼容以前接口，为空排除XML类型数据
	          if ((OutType="")||(OutType=$c(0)))
			  {
				  continue:(Type="XML")
			  }	         
			  s printType=obj.FileType
			  s InstanceID=sInstanceID
			  if (((OutType="")||(OutType=$c(0))||(OutType="IMAGE"))&&((strCharacteristic=1)||(obj.ChartItemType ="Single")))
			  {
			  	  s InstanceID=$p(sInstanceID,"||",1)  
			  }
			  else
			  {
				  s InstanceID=$p(sInstanceID,"||",1) _"/"_$p(sInstanceID,"||",2)  
				  
			  }
			  
			  
			  if imageCountList=""
		       {	s imageCountList = docId_"^"_InstanceID_"^"_printType_"^"_pageCount }
		      else
		       {	s imageCountList = imageCountList_"#"_docId_"^"_InstanceID_"^"_printType_"^"_pageCount }
		      s totCount = totCount + pageCount		
		    }	
		
	}
	q totCount_"$"_imageCountList
}

/// Desc: 	出院科室(即当前科室)【RowId^Code^Desc】
/// Output：RowId^Code^Desc
/// Others: not different from hospitals
/// W ##class(EMRservice.BL.BLExportQueue).DisDept("58")
ClassMethod DisDept(argAdmId As %String, argHospital As %String = "") As %String
{
	q:($d(argAdmId)=0)||(argAdmId="") ""
	
	s DeptCode="",DeptDesc="",dischgDeptDR="",dischgDept=""
	
	s dischgDeptDR=$P($g(^PAADM(argAdmId)),"^",4)
	if dischgDeptDR'="" 
	{	
		s DeptDesc=$p($g(^CTLOC(dischgDeptDR)),"^",2)
		s DeptCode=$p($g(^CTLOC(dischgDeptDR)),"^",1)
		if $l(DeptDesc,"-")>1 {s DeptDesc=$p($g(DeptDesc),"-",2)}
		s dischgDept=dischgDeptDR_"^"_DeptCode_"^"_DeptDesc
	}

	q dischgDeptDR
}

/// 根据就诊号获取保存的实例ID
/// W ##class(EMRservice.BL.BLExportQueue).GetAllInstanceIDByEpisodeID("58")
ClassMethod GetAllInstanceIDByEpisodeID(AEpisodeId As %String) As %String
{
	
   	/*
	s InstanceID=""
	s AStatus = " SAVE"
	s date = ""
	for
	{
		s date = $o(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime"," "_AEpisodeId,AStatus,date))
		q:(date = "")
		s time = ""
		for
		{
			s time = $o(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime"," "_AEpisodeId,AStatus,date,time))
			q:(time = "")
			s parentId = ""
			for
			{
				s parentId = $o(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime"," "_AEpisodeId,AStatus,date,time,parentId))
				q:(parentId = "")
				s subId = ""
				for
				{
					s subId = $o(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime"," "_AEpisodeId,AStatus,date,time,parentId,subId))
					q:(subId = "")
				    s tempInstanceID=parentId_"||"_subId
				    if (InstanceID'="")
				    {
				       s InstanceID=InstanceID_","_tempInstanceID
				    }
				    else
				    {
					   s InstanceID=tempInstanceID
					}
				}
			}
		}
	}
   q InstanceID

      */
   

   s InstanceID = ""
   s AStatus = " SAVE"
   s chartID = ""
   for {
	   s chartID= $O(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID"," "_AEpisodeId, chartID))
	   q:(chartID = "")
	   
	   s ecRecordID= $O(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID"," "_AEpisodeId, chartID, ""))
	   
	   s childsub = ""
	   s date = ""
	   for{
		s date = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ecRecordID,AStatus,date))
		q:(date = "")
		
		s time = ""
		for{
			s time = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ecRecordID,AStatus,date,time))
			q:(time = "")
			
			s childsub = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ecRecordID,AStatus,date,time,""))
			q:(childsub '= "")	
		}
		
		q:(childsub '= "")
	  }
	  
	  if (childsub '= "")
	  {
		 if (InstanceID'="")
	    {
	       s InstanceID=InstanceID_","_ecRecordID_"||"_childsub
	    }
	    else
	    {
		   s InstanceID=ecRecordID_"||"_childsub
		}
	  }
   }

   q InstanceID
}

/// 根据病历实例ID获取相关信息
/// W ##class(EMRservice.BL.BLExportQueue).GetQueueByInstanceID("20||190")
ClassMethod GetQueueByInstanceID(InstanceID As %String, OutType As %String) As EMRservice.entity.EQueue [ WebMethod ]
{
    
	q:(InstanceID="") ""	
	
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(InstanceID)  
	q:(objInstance = "") ""			  
	s BindTemplateID = objInstance.TemplateID
	s aTemplateID=""
	s aTemplateID =  $o(^DHCEMRM.EMRTemplateI("IdxBindTemplateID"," "_BindTemplateID,aTemplateID))
	q:(aTemplateID = "") ""
	
	s objEMRTemplate = ##class(EMRmeta.EMRTemplate).%OpenId(aTemplateID)
	q:(objEMRTemplate = "") ""
	s AdocID=objEMRTemplate.CategoryID
	q:(AdocID = "") ""
	
	s objTemplate = ##Class(EMRservice.BL.BLTemplate).GetTemplateByEMRTmpCateID(AdocID)
	q:(objTemplate = "") ""
	set Result = ##class(EMRservice.entity.EQueue).%New()
	s Result.ChartItemType =objTemplate.ChartItemType	
	s Result.EpisodeID =objInstance.EpisodeID
	s Result.HappenDate =objInstance.HappenDate
	s Result.HappenTime =objInstance.HappenTime
	s Result.InstanceID =InstanceID
	s Result.PatientID =$P($G(^PAADM(objInstance.EpisodeID)),"^",1)
	s Result.PluginType =objTemplate.DocumentType
	if (OutType ="IMAGE")
	{
		s Result.FileType ="jpg"  
	}
	elseif (OutType ="XML")
	{
		s Result.FileType ="xml"  
	}
	s Result.Type =OutType
	q Result
}

/// 向成功队列中插入信息
/// W ##class(EMRservice.BL.BLExportQueue).InsertSucced(obj)
ClassMethod InsertSucced(obj As EMRservice.entity.EQueue) As %String [ WebMethod ]
{
	s aEpisodeID=obj.EpisodeID
	s patientId=$P($G(^PAADM(aEpisodeID)),"^",1)
	s aInstanceID=obj.InstanceID	
	s RowID=""
	s RowID = $o(^DHCEMRI.Export.SucceedI("IdxTyQueue"," "_obj.Type, " "_patientId, " "_aEpisodeID," "_aInstanceID,RowID))
	if (RowID="")
	{
	s Succedobj = ##Class(EMRinstance.Export.Succeed).%New()
	s Succedobj.ChartItemType =obj.ChartItemType
	s Succedobj.ClientIP =obj.ClientIP
	s Succedobj.EndPage =obj.EndPage
	s Succedobj.EpisodeID =obj.EpisodeID
	s Succedobj.HappenDate =obj.HappenDate
	s Succedobj.HappenTime =obj.HappenTime
	s Succedobj.InstanceID =obj.InstanceID
	s Succedobj.PageCount =obj.PageCount
	s Succedobj.PatientID =obj.PatientID
	s Succedobj.PluginType =obj.PluginType
	s Succedobj.Priority =obj.Priority
	s Succedobj.StartPage =obj.StartPage
	s Succedobj.TaskDate = $p($h,",",1)
	s Succedobj.TaskTime = $p($h,",",2)
	s Succedobj.TaskIP =obj.TaskIP
	s Succedobj.TaskRemark =obj.TaskRemark	
	s Succedobj.Type =obj.Type		
	s Succedobj.FileType =obj.FileType
	s status = Succedobj.%Save()
	if ($$$ISOK(status))
	  {
		 q Succedobj.%Id()      
	  }
	  else
	  {
		 q 0
	  }	
   }
   else
   {
	s Succedobj = ##Class(EMRinstance.Export.Succeed).%OpenId(RowID)
	q:(Succedobj="")
	s Succedobj.Type =obj.Type
	s Succedobj.FileType =obj.FileType
	s Succedobj.PageCount =obj.PageCount
	s Succedobj.StartPage =obj.StartPage
	s Succedobj.EndPage =obj.EndPage	
	s Succedobj.TaskDate = $p($h,",",1)
	s Succedobj.TaskTime = $p($h,",",2)
	s Succedobj.TaskIP =obj.TaskIP	
	s status = Succedobj.%Save()
	if ($$$ISOK(status))
	  {
		 q Succedobj.%Id()      
	  }
	  else
	  {
		 q 0
	  }	
   }
}

/// 根据日期获取保存的实例ID
/// W ##class(EMRservice.BL.BLExportQueue).GetAllInstanceIDByDate("2015-05-01","2015-07-01")
ClassMethod GetAllInstanceIDByDate(AStartDate As %String, AEndDate As %String) As %String
{
	s InstanceID=""
	q:(AStartDate = "") $$$OK
    q:(AEndDate = "") $$$OK
	s startDate = $zdh(AStartDate,3)
	s endDate = $zdh(AEndDate,3)
	s date = endDate+1
	s sdate=startDate

	for {
			s sdate =  $o(^DHCEMRI.InstanceDataI("IdxModifyDate", sdate))			
			q:(sdate = "")
			q:(sdate>date)
			s parentId = ""
			for
			{
				s parentId = $o(^DHCEMRI.InstanceDataI("IdxModifyDate",sdate,parentId))
				q:(parentId = "")
				s subId = ""
				for
				{
					s subId = $o(^DHCEMRI.InstanceDataI("IdxModifyDate",sdate,parentId,subId))
					q:(subId = "")
				    s tempInstanceID=parentId_"||"_subId
				    s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(tempInstanceID)  
	                q:(objInstance = "")
	                continue:(objInstance.Status'="Save")
	               
				    if (InstanceID'="")
				    {
				       s InstanceID=InstanceID_","_tempInstanceID
				    }
				    else
				    {
					   s InstanceID=tempInstanceID
					}
				}
			}					    
	   }
   q InstanceID
}

/// do ##class(%ResultSet).RunQuery("EMRservice.BL.BLExportQueue","GetAllInstanceIDQueryByDate","2015-07-18","2016-07-18","")
Query GetAllInstanceIDQueryByDate(AStartDate As %String, AEndDate As %String) As %Query(ROWSPEC = "InstanceID:%String")
{
}

ClassMethod GetAllInstanceIDQueryByDateExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String, AInstanceID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1,Count=300
 	
 	s InstanceID=""
	q:(AStartDate = "") $$$OK
    q:(AEndDate = "") $$$OK
	s startDate = $zdh(AStartDate,3)
	s endDate = $zdh(AEndDate,3)	
	s sdate=startDate-1
	s startOutDate="",startOutTime="",startInDate="",startIntTime=""
	
	if (AInstanceID'="")
	{
		s objOutInstance = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceID) 
		if (objOutInstance'="")  
		{
			s startDate = objOutInstance.CreateDate			
			s startOutDate = objOutInstance.CreateDate
			s startOutTime = objOutInstance.CreateTime
			s sdate=startDate-1
		}
	}
  
    s TheECRecord=""
	for {	
	        q:(ind>Count)
	        s sdate=$o(^DHCEMRI.EMRLogsI("IdxCreateDateTime",sdate))
	        q:(sdate = "")
			q:(sdate>endDate)			
			s stime=""			
			for
			  {   
			      q:(ind>Count)
				  s stime = $o(^DHCEMRI.EMRLogsI("IdxCreateDateTime",sdate,stime))
		          q:(stime = "")		         
		          s EpisodeID=""
		          for
		             {
			             q:(ind>Count)
			             s EpisodeID = $o(^DHCEMRI.EMRLogsI("IdxCreateDateTime",sdate,stime,EpisodeID))		                
		                 q:(EpisodeID = "")		                
		                 s EpisodeID=$tr(EpisodeID," ","")			                	                
		                 s InstanceID=..GetInstanceID(sdate,stime,EpisodeID)
		                 q:(InstanceID="")
				         s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(InstanceID)  
	                     q:(objInstance = "")
	                     q:(objInstance.Status'="Save")
	                     s startInDate=objInstance.CreateDate
	                     s startIntTime=objInstance.CreateTime
	                     q:((startOutDate>startInDate)||((startOutDate=startInDate)&&(startOutTime>=startIntTime))) 
	                               
				         s ^CacheTemp(repid,ind) = $lb(InstanceID)
	                     s ind=ind+1
	                     q		
		             }
			  }	
	   }
  
   Quit $$$OK
}

ClassMethod GetAllInstanceIDQueryByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllInstanceIDQueryByDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAllInstanceIDQueryByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAllInstanceIDQueryByDateExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

/// do ##class(%ResultSet).RunQuery("EMRservice.BL.BLExportQueue","GetAllInstanceIDByAdmitDate","2014-07-18","2016-07-18")
Query GetAllInstanceIDByAdmitDate(AStartDate As %String, AEndDate As %String) As %Query(ROWSPEC = "InstanceID:%String")
{
}

ClassMethod GetAllInstanceIDByAdmitDateExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1,Count=300
 	
 	s InstanceID=""
	q:(AStartDate = "") $$$OK
    q:(AEndDate = "") $$$OK
	s startDate = $zdh(AStartDate,3)
	s endDate = $zdh(AEndDate,3)	
	  	
	for Adate = startDate:1:endDate
	{
		s AEpisodeId = ""
		for {
			s AEpisodeId = $O(^PAADMi("PAADM_AdmDate",Adate,AEpisodeId))
			q:(AEpisodeId = "")
			s InstanceID=""
			s AStatus = " SAVE"
			s date = ""
			for
			{
				s date = $o(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime"," "_AEpisodeId,AStatus,date))
				q:(date = "")
				s time = ""
				for
				{
					s time = $o(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime"," "_AEpisodeId,AStatus,date,time))
					q:(time = "")
					s parentId = ""
					for
					{
						s parentId = $o(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime"," "_AEpisodeId,AStatus,date,time,parentId))
						q:(parentId = "")
						s subId = ""
						for
						{
							s subId = $o(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime"," "_AEpisodeId,AStatus,date,time,parentId,subId))
							q:(subId = "")
						    s InstanceID=parentId_"||"_subId
						    s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(InstanceID)  
			                q:(objInstance = "")
			                continue:(objInstance.Status'="Save")
						    s ^CacheTemp(repid,ind) = $lb(InstanceID)
			                s ind=ind+1		
						}
					}
				}
			}
		}
	}
  
   Quit $$$OK
}

ClassMethod GetAllInstanceIDByAdmitDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllInstanceIDByAdmitDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAllInstanceIDByAdmitDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAllInstanceIDByAdmitDateExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

/// do ##class(%ResultSet).RunQuery("EMRservice.BL.BLExportQueue","GetRepairInstanceIDs","58")
Query GetAllInstanceIDQueryByEpisodeID(AEpisodeId As %String) As %Query(ROWSPEC = "InstanceID:%String")
{
}

ClassMethod GetAllInstanceIDQueryByEpisodeIDExecute(ByRef qHandle As %Binary, AEpisodeId As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	 	/*
 	s InstanceID=""
	s AStatus = " SAVE"
	s date = ""
	for
	{
		s date = $o(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime"," "_AEpisodeId,AStatus,date))
		q:(date = "")
		s time = ""
		for
		{
			s time = $o(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime"," "_AEpisodeId,AStatus,date,time))
			q:(time = "")
			s parentId = ""
			for
			{
				s parentId = $o(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime"," "_AEpisodeId,AStatus,date,time,parentId))
				q:(parentId = "")
				s subId = ""
				for
				{
					s subId = $o(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime"," "_AEpisodeId,AStatus,date,time,parentId,subId))
					q:(subId = "")
				    s InstanceID=parentId_"||"_subId
				    s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(InstanceID)  
	                q:(objInstance = "")
	                continue:(objInstance.Status'="Save")
				    s ^CacheTemp(repid,ind) = $lb(InstanceID)
	                s ind=ind+1		
				}
			}
		}
	} 	
 	
 	  */

  s InstanceID = ""
   s AStatus = " SAVE"
   s chartID = ""
   for {
	   s chartID= $O(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID"," "_AEpisodeId, chartID))
	   q:(chartID = "")
	   
	   s ecRecordID= $O(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID"," "_AEpisodeId, chartID, ""))
	   
	   s childsub = ""
	   s date = ""
	   for{
		s date = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ecRecordID,AStatus,date))
		q:(date = "")
		
		s time = ""
		for{
			s time = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ecRecordID,AStatus,date,time))
			q:(time = "")
			
			s childsub = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ecRecordID,AStatus,date,time,""))
			s InstanceID = ecRecordID_"||"_childsub
		 	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(InstanceID) 
		 	s objEcrecord= objInstance.TheECRecord
		 	if ((objEcrecord.ChartItemType = "Multiple")&&(objEcrecord.DocumentCharacteristic ="1"))
			{ 
			  	q:(childsub '= "")
			}
			elseif((objEcrecord.ChartItemType = "Multiple")&&(objEcrecord.DocumentCharacteristic ="0"))
			{
				s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(InstanceID)  
		     	continue:(objInstance = "")
		     	continue:(objInstance.Status'="Save")  
				s ^CacheTemp(repid,ind) = $lb(InstanceID)
				s ind=ind+1
			}
				
		}
		if (childsub '= "")
		{
			 s InstanceID = ecRecordID_"||"_childsub
			 s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(InstanceID)  
		     continue:(objInstance = "")
		     continue:(objInstance.Status'="Save")
		     s objEcrecord= objInstance.TheECRecord
			 continue:((objEcrecord.ChartItemType = "Multiple")&&(objEcrecord.DocumentCharacteristic ="0"))
 
			s ^CacheTemp(repid,ind) = $lb(InstanceID)
		    s ind=ind+1
		    s objEcrecord= objInstance.TheECRecord
		 	if ((objEcrecord.ChartItemType = "Multiple")&&(objEcrecord.DocumentCharacteristic ="1"))
			{ 
		   	 	q:(childsub '= "")
			}
		}
		
	  }
	  

   }
 
   Quit $$$OK
}

ClassMethod GetAllInstanceIDQueryByEpisodeIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllInstanceIDQueryByEpisodeIDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAllInstanceIDQueryByEpisodeIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAllInstanceIDQueryByEpisodeIDExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

/// 执行队列失败移动到失败队列
/// w ##Class(EMRservice.BL.BLExportQueue).ExeMoveToFailure("1924")
ClassMethod ExeMoveToFailure(ID As %String, OutType As %String) As %String
{
	
	q:(ID="") 0
	s obj = ##Class(EMRinstance.Export.Exe).%OpenId(ID)
	q:(obj="")	
	s Succedobj=""
	TStart
	
	s sID =..CheckInstanceIDIsExit(obj.PatientID,obj.EpisodeID,obj.InstanceID,"Failure",OutType)
	//如果该实例ID不存在则新建，否则更新
	if (sID>0)
	{		
	s Succedobj = ##Class(EMRinstance.Export.Failure).%OpenId(sID)
	s Succedobj.ChartItemType =obj.ChartItemType
	s Succedobj.ClientIP =obj.ClientIP
	s Succedobj.EndPage =obj.EndPage
	s Succedobj.EpisodeID =obj.EpisodeID
	s Succedobj.HappenDate =obj.HappenDate
	s Succedobj.HappenTime =obj.HappenTime
	s Succedobj.InstanceID =obj.InstanceID
	s Succedobj.PageCount =obj.PageCount
	s Succedobj.PatientID =obj.PatientID
	s Succedobj.PluginType =obj.PluginType
	s Succedobj.Priority =obj.Priority
	s Succedobj.StartPage =obj.StartPage
	s Succedobj.TaskDate =obj.TaskDate
	s Succedobj.TaskIP =obj.TaskIP
	s Succedobj.TaskRemark =obj.TaskRemark
	s Succedobj.TaskTime =obj.TaskTime
	s Succedobj.Type =obj.Type	
	s Succedobj.FileType =obj.FileType		
	}
	else
	{
	s Succedobj = ##Class(EMRinstance.Export.Failure).%New()
	s Succedobj.ChartItemType =obj.ChartItemType
	s Succedobj.ClientIP =obj.ClientIP
	s Succedobj.EndPage =obj.EndPage
	s Succedobj.EpisodeID =obj.EpisodeID
	s Succedobj.HappenDate =obj.HappenDate
	s Succedobj.HappenTime =obj.HappenTime
	s Succedobj.InstanceID =obj.InstanceID
	s Succedobj.PageCount =obj.PageCount
	s Succedobj.PatientID =obj.PatientID
	s Succedobj.PluginType =obj.PluginType
	s Succedobj.Priority =obj.Priority
	s Succedobj.StartPage =obj.StartPage
	s Succedobj.TaskDate =obj.TaskDate
	s Succedobj.TaskIP =obj.TaskIP
	s Succedobj.TaskRemark =obj.TaskRemark
	s Succedobj.TaskTime =obj.TaskTime
	s Succedobj.Type =obj.Type	
	s Succedobj.FileType =obj.FileType	
	}
	s status = Succedobj.%Save()
	if ($$$ISOK(status))
	{
		Set sc = ##Class(EMRinstance.Export.Exe).%DeleteId(ID)
	    if ($$$ISOK(sc))
	    {
		    TCommit	
		    q Succedobj.%Id()      
		}
		else
		{
			TRollback
			q 0
		}	
	}
	else
	{
		TRollback
		q 0
	}
}

/// 失败队列移动到执行队列
/// w ##Class(EMRservice.BL.BLExportQueue).FailureMoveToExe("260")
ClassMethod FailureMoveToExe(ID As %String, OutType As %String) As %String
{
	
	q:(ID="") 0
	s obj = ##Class(EMRinstance.Export.Failure).%OpenId(ID)	
	q:(obj="") 0	
	s Exeobj=""
	TStart
	
	s sID = $o(^DHCEMRI.Export.ExeI("IdxTyQueue"," "_OutType, " "_obj.PatientID, " "_obj.EpisodeID," "_obj.InstanceID,""),-1)
	if (sID="")
	{
	s Exeobj = ##Class(EMRinstance.Export.Exe).%New()
	s Exeobj.ChartItemType =obj.ChartItemType
	s Exeobj.ClientIP =obj.ClientIP
	s Exeobj.EndPage =obj.EndPage
	s Exeobj.EpisodeID =obj.EpisodeID
	s Exeobj.HappenDate =obj.HappenDate
	s Exeobj.HappenTime =obj.HappenTime
	s Exeobj.InstanceID =obj.InstanceID
	s Exeobj.PageCount =obj.PageCount
	s Exeobj.PatientID =obj.PatientID
	s Exeobj.PluginType =obj.PluginType
	s Exeobj.Priority =obj.Priority
	s Exeobj.StartPage =obj.StartPage
	s Exeobj.TaskIP =obj.TaskIP
	s Exeobj.TaskRemark =obj.TaskRemark
	//s Exeobj.TaskDate =obj.TaskDate
	//s Exeobj.TaskTime =obj.TaskTime
	s Exeobj.TaskDate = $p($h,",",1)
	s Exeobj.TaskTime = $p($h,",",2)
	s Exeobj.Type =obj.Type	
	s Exeobj.FileType =obj.FileType
	}
	else
	{
	s Exeobj = ##Class(EMRinstance.Export.Exe).%OpenId(sID)
	s Exeobj.ChartItemType =obj.ChartItemType
	s Exeobj.ClientIP =obj.ClientIP
	s Exeobj.EndPage =obj.EndPage
	s Exeobj.EpisodeID =obj.EpisodeID
	s Exeobj.HappenDate =obj.HappenDate
	s Exeobj.HappenTime =obj.HappenTime
	s Exeobj.InstanceID =obj.InstanceID
	s Exeobj.PageCount =obj.PageCount
	s Exeobj.PatientID =obj.PatientID
	s Exeobj.PluginType =obj.PluginType
	s Exeobj.Priority =obj.Priority
	s Exeobj.StartPage =obj.StartPage
	s Exeobj.TaskIP =obj.TaskIP
	s Exeobj.TaskRemark =obj.TaskRemark
	//s Exeobj.TaskDate =obj.TaskDate
	//s Exeobj.TaskTime =obj.TaskTime
	s Exeobj.TaskDate = $p($h,",",1)
	s Exeobj.TaskTime = $p($h,",",2)
	s Exeobj.Type =obj.Type
	s Exeobj.FileType =obj.FileType
	}
	s status = Exeobj.%Save()
	if ($$$ISOK(status))
	{
		Set sc = ##Class(EMRinstance.Export.Failure).%DeleteId(ID)
	    if ($$$ISOK(sc))
	    {
		    TCommit	
		    q Exeobj.%Id()    
		}
		else
		{
			TRollback
			q 0
		}	
	}
	else
	{
		TRollback
		q 0
	}
}

/// 更新失败队列信息
/// w ##Class(EMRservice.BL.BLExportQueue).UpdateFailure("22")
ClassMethod UpdateFailure(ID As %String, FailureObj As EMRservice.entity.EQueue) As %String [ WebMethod ]
{
	q:(ID="") 0
	s obj = ##Class(EMRinstance.Export.Failure).%OpenId(ID)
	q:(obj="")
	s obj.Type =FailureObj.Type
	s obj.FileType =FailureObj.FileType
	s obj.PageCount =FailureObj.PageCount
	s obj.StartPage =FailureObj.StartPage
	s obj.EndPage =FailureObj.EndPage	
	s obj.TaskDate = $p($h,",",1)
	s obj.TaskTime = $p($h,",",2)
	s obj.TaskIP =FailureObj.TaskIP	
	s status = obj.%Save()
	if ($$$ISOK(status))
	{
		q ID
	}
	else
	{
		q 0
	}
}

/// 获取失败队列列表
/// Debug: do ##class(%ResultSet).RunQuery("EMRservice.BL.BLExportQueue","GetExprtQueueList","2015-04-06","2015-05-30")
Query GetExprtFailureList(AStartDate As %String, AEndDate As %String, outType As %String) As %Query(ROWSPEC = "ID:%String,PatientID:%String,EpisodeID:%String,InstanceID:%String,pluginType:%String,chartItemType:%String,ClientIP:%String,HappenDate:%String,HappenTime:%String,Priority:%String")
{
}

ClassMethod GetExprtFailureListExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String, outType As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
    
    q:(AStartDate = "") $$$OK
    q:(AEndDate = "") $$$OK
	s startDate = $zdh(AStartDate,3)
	s endDate = $zdh(AEndDate,3)
	s date = endDate+1
	
	for {
			s date =  $o(^DHCEMRI.Export.FailureI("IdxOTypeHappenDT"," "_outType, date),-1)
			//b "s"
			q:(date = "")
			q:(date<startDate)
			s time = ""

			for {
				s time =  $o(^DHCEMRI.Export.FailureI("IdxOTypeHappenDT"," "_outType, date, time),-1)
				q:(time = "")

				s rowID = ""
				for {
					s rowID = $o(^DHCEMRI.Export.FailureI("IdxOTypeHappenDT"," "_outType, date, time, rowID))
					q:(rowID = "")
					s obj = ##class(EMRinstance.Export.Failure).%OpenId(rowID)
					d OutPutRow
				}
			}
		}
		//ID:%String,PatientID:%String,EpisodeID:%String,InstanceID:%String,pluginType:%String,chartItemType:%String,ClientIP:%String,HappenDate:%String,HappenTime:%String,Priority:%String
	Quit $$$OK
OutPutRow
	s ID = rowID
	s PatientID = obj.PatientID
	s EpisodeID = obj.EpisodeID
	s InstanceID = obj.InstanceID
	s PluginType = obj.PluginType
	s ChartItemType = obj.ChartItemType
	s ClientIP = obj.ClientIP	
	s Priority = obj.Priority
	s HappenDate = $zd(obj.HappenDate,3)
	s HappenTime = $zt(obj.HappenTime,1)
	
	 
 	s data = $lb(ID,PatientID,EpisodeID,InstanceID,PluginType,ChartItemType,ClientIP,HappenDate,HappenTime,Priority)
	s ^CacheTemp(repid,ind)=data
	s ind=ind+1 
	q
}

ClassMethod GetExprtFailureListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetExprtFailureListExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetExprtFailureListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetExprtFailureListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

// w ##Class(EMRservice.BL.BLExportQueue).GetInstanceID(64113,39048,54)

ClassMethod GetInstanceID(aCreateDate As %String, aCreateTime As %String, aEpisodeID As %String)
{
	
	s InstanceID=""
	&SQL(Select ID into :InstanceID From EMRinstance.InstanceData Where CreateDate=:aCreateDate and CreateTime=:aCreateTime and EpisodeID=:aEpisodeID)
	q InstanceID
}

// w ##Class(EMRservice.BL.BLExportQueue).UpdateAdmType()

ClassMethod UpdateAdmType() As %String
{
	//迁移病种知识库规则
	s totQCount = 0
	s totECount = 0
	s totFCount = 0
	s totSCount = 0
	s rowID = ""
	for {
		s rowID = $o(^DHCEMRI.Export.QueueD(rowID))
		q:(rowID="")
		s objQueue = ##class(EMRinstance.Export.Queue).%OpenId(rowID)
		q:(objQueue="")
		continue:((objQueue.AdmType'="")&&(objQueue.AdmType'=$c(0))&&(objQueue.Type'=""))
		s AEpisodeID = objQueue.EpisodeID
		s admType = $p($g(^PAADM(AEpisodeID)),"^",2)
		s objQueue.AdmType = admType
		if (objQueue.Type ="")
		{
			s objQueue.Type = "IMAGE"
		}
		s sc = objQueue.%Save()
		if (sc)
		{
			s totQCount = totQCount+1
		}
	}
	s rowFID = ""
	for {
		s rowFID = $o(^DHCEMRI.Export.FailureD(rowFID))
		q:(rowFID="")
		s objQueue = ##class(EMRinstance.Export.Failure).%OpenId(rowFID)
		q:(objQueue="")
		continue:((objQueue.AdmType'="")&&(objQueue.AdmType'=$c(0))&&(objQueue.Type'=""))
		s AEpisodeID = objQueue.EpisodeID
		s admType = $p($g(^PAADM(AEpisodeID)),"^",2)
		s objQueue.AdmType = admType
		if (objQueue.Type ="")
		{
			s objQueue.Type = "IMAGE"
		}
		s sc = objQueue.%Save()
		if (sc)
		{
			s totFCount = totFCount+1
		}
	}
	s rowEID = ""
	for {
		s rowEID = $o(^DHCEMRI.Export.ExeD(rowEID))
		q:(rowEID="")
		s objQueue = ##class(EMRinstance.Export.Exe).%OpenId(rowEID)
		q:(objQueue="")
		continue:((objQueue.AdmType'="")&&(objQueue.AdmType'=$c(0))&&(objQueue.Type'=""))
		s AEpisodeID = objQueue.EpisodeID
		s admType = $p($g(^PAADM(AEpisodeID)),"^",2)
		s objQueue.AdmType = admType
		if (objQueue.Type ="")
		{
			s objQueue.Type = "IMAGE"
		}
		s sc = objQueue.%Save()
		if (sc)
		{
			s totECount = totECount+1
		}
	}
	s rowSID = ""
	for {
		s rowSID = $o(^DHCEMRI.Export.SucceedD(rowSID))
		q:(rowSID="")
		s objQueue = ##class(EMRinstance.Export.Succeed).%OpenId(rowSID)
		q:(objQueue="")
		//continue:((objQueue.AdmType'="")&&(objQueue.AdmType'=$c(0))&&(objQueue.Type'=""))
		s AEpisodeID = objQueue.EpisodeID
		s admType = $p($g(^PAADM(AEpisodeID)),"^",2)
		s objQueue.AdmType = admType
		s objQueue.FileType  = objQueue.Type
		if (objQueue.Type ["xml")
		{
			s objQueue.Type = "XML"
		}
		else
		{
			s objQueue.Type = "IMAGE"
		}
		s sc = objQueue.%Save()
		if (sc)
		{
			s totSCount = totSCount+1
		}
	}
	q "Queue: "_totQCount_"  exe: "_totECount_"  Failure: "_totFCount_"  Succeed: "_totSCount
}

/// 上传CdaXml数据
/// w ##Class(EMRservice.BL.BLExportQueue).UploadCDAXmlFileList(35370109)
ClassMethod UploadCDAXmlFileList(aEQueue As EMRservice.entity.EQueue) As %String
{
	s result ="1"
	
	s InstanceID = aEQueue.InstanceID
	s patientId = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(aEQueue.EpisodeID)
    s patientNo = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiNo(patientId)
	s UpdateDate = $ZD($P($H,",",1),3)
	s UpdateTime = $ZT($P($H,",",2))
	
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(InstanceID)
	s UpdateUserCode = objInstance.CreateUser
	
	s paramxml = "<Request><Header><SourceSystem></SourceSystem><MessageID></MessageID></Header><Body><RegisterDocumentRt><BusinessFieldCode>00001</BusinessFieldCode><HospitalCode/><OrganizationCode></OrganizationCode>"
	s paramxml = paramxml_"<PATPatientID>"_patientNo_"</PATPatientID>"	
	s paramxml = paramxml_"<PAADMVisitNumber>"_aEQueue.EpisodeID_"</PAADMVisitNumber><SpecimenID></SpecimenID>"
	s paramxml = paramxml_"<DocumentType>60</DocumentType><DocumentID>"_InstanceID_"</DocumentID><HOSD_PatientName/><DocumentPath/><UpdateUserCode>"_UpdateUserCode_"</UpdateUserCode><UpdateDate>"_UpdateDate_"</UpdateDate><UpdateTime>"_UpdateTime_"</UpdateTime><DocumentContent>"
	
	s paramStream = ##Class(%GlobalCharacterStream).%New()
	d paramStream.Write(paramxml)
	
	s strXml = $ZSTRIP(aEQueue.CdaXml.Read(),"*C")
	//s ^Tempykk("UploadCDAXmlFileList") = strXml
	
	s DocumentContent = $ZCVT(strXml,"O","UTF8")
	s DocumentContent = $ZSTRIP($SYSTEM.Encryption.Base64Encode(DocumentContent),"*C")
	//s ^Tempykk("UploadCDAXmlFileList1") = DocumentContent
	
	D paramStream.MoveToEnd()
	d paramStream.Write(DocumentContent)
	s paramxmlN = "</DocumentContent></RegisterDocumentRt></Body></Request>"
	d paramStream.Write(paramxmlN)
	d paramStream.SaveStream()
	
	w ##class(web.DHCENS.EnsHISServiceNew).DHCHisInterface("S00000070",paramStream)
	
	/*
	s AStream=##Class(%FileBinaryStream).%New()
	s AStream.Filename="d:\upload_cda.xml"
	d AStream.CopyFrom(paramStream)
	d AStream.SaveStream()
	d AStream.%Close()
	s ^UploadCDAXmlFileList("1")="3"
	*/
	q result
}

/// 根据ID获取文档特性
ClassMethod GetCharacteristicByID(aInstanceID As %String) As %String
{
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(aInstanceID)
	s DocumentCharacteristic = objInstance.TheECRecord.DocumentCharacteristic
	q DocumentCharacteristic
}

/// 获取所有需要补充的图片
/// do ##class(%ResultSet).RunQuery("EMRservice.BL.BLExportQueue","GetRepairInstanceIDs","2014-07-18","2016-07-18")
Query GetRepairInstanceIDs(AStartDate As %String, AEndDate As %String) As %Query(ROWSPEC = "InstanceID:%String")
{
}

ClassMethod GetRepairInstanceIDsExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1,Count=300
 	
 	s InstanceID=""
	q:(AStartDate = "") $$$OK
    q:(AEndDate = "") $$$OK
	s startDate = $zdh(AStartDate,3)
	s endDate = $zdh(AEndDate,3)	
	  	
	for Adate = startDate:1:endDate
	{
		s AEpisodeId = ""
		for {
			s AEpisodeId = $O(^PAADMi("PAADM_AdmDate",Adate,AEpisodeId))
			q:(AEpisodeId = "")
			s InstanceID=""
			s AStatus = " SAVE"
			s ChartItemID = ""
			s ChartItemID = ""
			for
			{
				s ChartItemID = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID"," "_AEpisodeId,ChartItemID))
				q:(ChartItemID = "")
				s eRowid = ""
				for
				{
					s eRowid = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID"," "_AEpisodeId,ChartItemID,eRowid))
					q:(eRowid = "")
					s objEcreord = ##Class(EMRinstance.ECRecord).%OpenId(eRowid)
					//只取重复的非连续加载病历
					continue:((objEcreord.ChartItemType '= "Multiple")||(objEcreord.DocumentCharacteristic '="0"))
					
					Set key = ""
					do
					{ 
				    	S objInstanceData = objEcreord.Instances.GetNext(.key)
					    if (objInstanceData '= "")
				     	{ 
					     	continue:(objInstanceData.Status'="Save")
						    s ^CacheTemp(repid,ind) = $lb(objInstanceData.%Id())
			                s ind=ind+1		
					  	} 
			 		 } 
			 		 while (key '="" )
				}
			}
		}
	}
  
   Quit $$$OK
}

ClassMethod GetRepairInstanceIDsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRepairInstanceIDsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetRepairInstanceIDsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRepairInstanceIDsExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

/// Desc:       将正在执行的超时数据批量迁移到失败队列中
/// Creator:    yejian	
/// CreateDate: 2020-6-10	
/// Input:      ATimeOutInterval 超时时间（毫秒） 20分钟 20*60*1000=1200000
/// Output:     moveCount:科室模板代码,
/// debug 		w ##Class(EMRservice.BL.BLExportQueue).MoveExeErrorDataTaskExec("1200000","IMAGE")
ClassMethod MoveExeErrorDataTaskExec(ATimeOutInterval As %String, OutType As %String) As %String
{
	
	s moveCount = "0"
	s ATimeOutInterval = 3600000
	s:(OutType="") OutType = "IMAGE"
	s moveErrorIDs =""
	s TaskDate = ""
	for {
		s TaskDate = $O(^DHCEMRI.Export.ExeI("IdxTyTaskDateTime"," "_OutType,TaskDate))
		q:(TaskDate="")

		s TaskTime = ""
		for {
			s TaskTime = $O(^DHCEMRI.Export.ExeI("IdxTyTaskDateTime"," "_OutType,TaskDate,TaskTime))
			q:(TaskTime="")

			s rowID = ""
			for {
				s rowID = $O(^DHCEMRI.Export.ExeI("IdxTyTaskDateTime"," "_OutType,TaskDate,TaskTime,rowID))
				q:(rowID="")

				s objAdmTaskExec = ##Class(EMRinstance.Export.Exe).%OpenId(rowID)
				q:(objAdmTaskExec="")
				
				s timeInterval = (($p($h,",",1) - objAdmTaskExec.TaskDate)*24*3600 + ($p($h,",",2) - objAdmTaskExec.TaskTime))*1000
			
				//未超时，还在生成中，跳过
				continue:(timeInterval < +ATimeOutInterval)
				
				//使用最大生成次数来控制是否可以继续尝试错误生成处理
				//continue:(objAdmTaskExec.CreateCount > ErrorMaxCreateCount)

				s moveID = ##Class(EMRservice.BL.BLExportQueue).ExeMoveToFailure(rowID,OutType)
				if (moveID>0)
				{
					s moveErrorIDs = moveErrorIDs_"^"_moveID
					s moveCount = moveCount+1
				}
			}
		}
	}
	//输出迁移的所有超时数据
	//w moveCount_":"_moveErrorIDs
	//迁移的超时总数
	q moveCount
}

}
