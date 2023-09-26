Class EMRservice.InterfaceService.GlossaryTools Extends %RegisteredObject
{

/// 获取术后首次病程后连续指定天数的病程记录实例ID集合
/// Lifengbo 20200213
/// 入参：	AEpisodeID：admid 
/// 			ADocID：展现结构ID 
/// 			ATitle：标题，默认“术后首次病程记录” 
/// 			ResultLength：输出连续的文档数，默认10
/// 输出：复合条件实例ID的LIst
/// debugger:
/// s list = ##class(EMRservice.InterfaceService.GlossaryTools).GetInstanceIDAfterOper(31653076,56)
/// s list = ##class(EMRservice.InterfaceService.GlossaryTools).GetInstanceIDAfterOper(31651980,56)
ClassMethod GetInstanceIDAfterOper(AEpisodeID As %String, ADocID As %String, ATitle As %String = "术后首次病程记录", ResultLength As %String = "10") As %String
{
	s returnValue = ""
	//参数错误
	q:(AEpisodeID="") returnValue
	
	//获取文档所有实例ID集合
	
	s listInstanceData = ..GetGetInstanceIDByDocID(AEpisodeID,ADocID)
	s count=0,hasAfOperFstRecord="N"
	for i=1:1:$ll(listInstanceData)
	{
		q:(ResultLength<=count)
		
		s tmpInstanceInfo = $list(listInstanceData,i)
		s tmpTitle = $p(tmpInstanceInfo,"^",2)
		
		//找到术后首次病程记录
		continue:($replace(tmpTitle," ","")'=ATitle)&&(hasAfOperFstRecord="N")
		
		//设定标志，开始记录随后的指定书目实例ID
		s hasAfOperFstRecord="Y"
		
		s tmpInstanceID = $p(tmpInstanceInfo,"^",1)
		s returnValue = returnValue_$lb(tmpInstanceID)
		s count = +$g(count)+1
		
	}
	q returnValue
}

/// 依据传入的标题信息，获取符合条件的所有实例ID集合
/// Lifengbo 20200213
/// 入参：	AEpisodeID：admid 
/// 			ADocID：展现结构ID 
/// 			ATitle：标题，默认“” 
/// 输出：复合条件实例ID的LIst
/// debugger:
/// s list = ##class(EMRservice.InterfaceService.GlossaryTools).GetInstanceIDInfoByTitles(9076548,56,"抢救记录")
/// s list = ##class(EMRservice.InterfaceService.GlossaryTools).GetInstanceIDInfoByTitles(8740886,56,"输血记录")
ClassMethod GetInstanceIDInfoByTitles(AEpisodeID As %String, ADocID As %String, ATitle As %String = "") As %List
{
	s returnValue = ""
	q:(AEpisodeID="")||(ATitle="") returnValue
	s listInstanceData = ..GetGetInstanceIDByDocID(AEpisodeID,ADocID)
	
	for i=1:1:$ll(listInstanceData)
	{
		s tmpInstanceInfo = $list(listInstanceData,i)
		s tmpTitle = $p(tmpInstanceInfo,"^",2)
		continue:($replace(tmpTitle," ","")'=ATitle)
		s tmpInstanceID = $p(tmpInstanceInfo,"^",1)
		s returnValue = returnValue_$lb(tmpInstanceID)
	}
	q returnValue
}

/// s list = ##class(EMRservice.InterfaceService.GlossaryTools).GetGetInstanceIDByDocID(9076548,56)
ClassMethod GetGetInstanceIDByDocID(AEpisodeID As %String, ADocID As %String) As %List
{
	s returnValue=""
	q:(AEpisodeID="")||(ADocID="") returnValue
	
	s ind=$i(^CacheTemp)
	
	s TheECRecord=""
	
	s TheECRecord = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",AEpisodeID,ADocID,TheECRecord))
	q:(TheECRecord="") returnValue
	
	s objECRecord = ##class(EMRinstance.ECRecord).%OpenId(TheECRecord)
	q:(objECRecord="") returnValue
	
	
	s Instances = objECRecord.Instances
	for i=1:1:Instances.Count()
	{
		s InstanceData = Instances.GetAt(i)
		
		s status = InstanceData.Status
		continue:(status'="Save")
		
		s happenDate = InstanceData.HappenDate
		s happenTime = InstanceData.HappenTime
		s instanceID = InstanceData.%Id()
		s title = InstanceData.Title
	
		s ^CacheTemp(ind,"EMRInstance",happenDate,happenTime,instanceID) = title
	}
	
	
	s date=""
	for
	{
		s date = $o(^CacheTemp(ind,"EMRInstance",date))
		q:(date="")
		s time=""
		for
		{
			s time = $o(^CacheTemp(ind,"EMRInstance",date,time))
			q:(time="")	
			
			s tmpid=""
			for
			{
				s tmpid = $o(^CacheTemp(ind,"EMRInstance",date,time,tmpid))
				q:(tmpid="")	
				s title = ^CacheTemp(ind,"EMRInstance",date,time,tmpid)
				s returnValue=returnValue_$lb(tmpid_"^"_title)
				
			}
		}
	
	}
	k ^CacheTemp(ind,"EMRInstance")
	q returnValue
}

/// Lifengbo 20200213
/// Debugger
ClassMethod TestExp()
{
	//1.获取实例ID符合条件的List
	
	//2.逐一获取实例ID，调用术语集接口方法.<注>第三个参数，传入实例ID
	//s arr=##class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossary(admid,"HDSD00.14.02",instanceID)
	
	//3.因输血、抢救记录均在病程记录通用模板下，可使用HDSD00.14.02 日常病程记录 术语集目录下节点全部获取。
	
	//4.术后首次病程记录接口，56为documentid，不需要修改。另外2个参数默认。详见方法定义
	//s list = ##class(EMRservice.InterfaceService.GlossaryTools).GetInstanceIDAfterOper(admid,56)
	//5.抢救记录
	//s list = ##class(EMRservice.InterfaceService.GlossaryTools).GetInstanceIDInfoByTitles(admid,56,"抢救记录")
	//6.输血记录
	//s list = ##class(EMRservice.InterfaceService.GlossaryTools).GetInstanceIDInfoByTitles(admid,56,"输血记录")
}

}
