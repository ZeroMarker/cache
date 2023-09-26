Class EPRservice.BLRecInstanceData Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

//d ##Class(EPRservice.BLRecInstanceData).tst4Q("1730||1")

/// 新建一条记录，存储前台删除的病历的InstanceData。对于可重复模板若之前已经存在一条记录则返回该记录
ClassMethod DumpData(AInstanceID As %String = "", AChartItemType As %String = "")
{
	Quit:(AInstanceID="") -1

	s currInstanceData = ##class(EPRinstance.InstanceData).%OpenId(AInstanceID)
	Quit:($$$NULLOREF=currInstanceData) -1
	
	s ind = ""
	s dumpedata = ""
	if ($zcvt(AChartItemType,"U")="MULTI")
	{
		s dumpedData = ##class(EPRinstance.RecInstanceData).FetchDumpedData(AInstanceID,-1)
		if (-1=dumpedData)
		{
			s dumpedData = ##class(EPRinstance.RecInstanceData).%New(AInstanceID)
			Quit:($$$NULLOREF=dumpedData) -1
		}
		Quit:($$$NULLOREF=dumpedData) $$$NULLOREF
		
		Quit:(dumpedData.Status="Dumped") -1
	}
	else
	{
		s dumpedData = ##class(EPRinstance.RecInstanceData).%New(AInstanceID)
		Quit:($$$NULLOREF=dumpedData) -1
	}
	
	d ..Exchanger(currInstanceData,dumpedData)
	
	Quit dumpedData
}

/// 从RecInstance表中读取对应数据，恢复到Instance对应记录中，并记录操作用户。
ClassMethod RestoreData(AInstanceID As %String = "", ASeqNo As %Integer = 1, AModifyUser As %String = "")
{
	
	Quit:(AInstanceID="") -1
	
	s currInstanceData = ##class(EPRinstance.InstanceData).%OpenId(AInstanceID)
	Quit:($$$NULLOREF=currInstanceData) $$$NULLOREF
	
	s dumpedData = ##class(EPRinstance.RecInstanceData).FetchDumpedData(AInstanceID,ASeqNo)
	Quit:($$$NULLOREF=dumpedData) $$$NULLOREF
	
	Quit:(dumpedData.Status="Restored") -1
	
	d ..Exchanger(dumpedData,currInstanceData,AModifyUser)
	
	Quit "Restore succeed!"
}

/// 目标数据从源数据进行复制，用于Dump和Restore操作时的实例数据操作。
ClassMethod Exchanger(src As %Persistent, des As %Persistent, AModifyUser As %String = "")
{
	s des.ModifyDate = $p($h,",",1)
	s des.ModifyTime = $p($h,",",2)
	s des.CreateDate = src.CreateDate
	s des.CreateTime = src.CreateTime
	s des.CreateUser = src.CreateUser
	s des.GroupItemID = src.GroupItemID
	s des.GroupItemName = src.GroupItemName
	s des.HappenDate = src.HappenDate
	s des.HappenTime = src.HappenTime
 	s des.ListNo = src.ListNo
 	s des.Remark = src.Remark
	s des.Title = src.Title
	s des.TemplateID = src.TemplateID
	s des.TemplateVersion = src.TemplateVersion
	d des.InstanceData.CopyFrom(src.InstanceData)
	
	//判断数据源是Instance还是RecInstance
	s actFlag = $p(src.%Id(),"||",2)
	if (actFlag'="")
	{
		s EpisodeID=""
		s condition = $p(src.%Id(),"||",1)
		&SQL(SELECT EpisodeId
		INTO :EpisodeID
		FROM EPRinstance.ECRecord
		WHERE ID = :condition )
		
		s des.EpisodeID = EpisodeID
		s des.InstanceID = src.%Id()
		s des.ModifyUser = src.ModifyUser
		s des.Status = "Dumped"
		s des.SeqNo = ##class(EPRinstance.RecInstanceData).EndofSeq(des.InstanceID)+1
	}
	elseif(actFlag="")
	{
		if (AModifyUser="")
		{
			s des.ModifyUser = src.ModifyUser
		}
		else
		{
			s des.ModifyUser = src.ModifyUser = AModifyUser
		}
		s des.Status = "Save"
		s src.Status = "Restored"
	}
	
	s sc = des.%Save()
	if $$$ISERR(sc)
	{
		Quit -1
	}
	if (actFlag="")
	{
		s sc = src.%Save()
		if $$$ISERR(sc)
		{
			Quit -1
		}
	}
}

/// 检查可重复模板记录的Status是否有"Restored",即对CenterTabList可用的记录。
ClassMethod CheckRecordAvailable(AInstanceID) As %String
{
	s len = ##class(EPRinstance.RecInstanceData).EndofSeq(AInstanceID)
	Quit:(len=0) -1
	
	s ret =""
	for ind=1:1:len
	{
		s ret = ##class(EPRinstance.RecInstanceData).CheckStatus(AInstanceID,ind)
	    Quit:(ret="Restored")
	}
	Quit ret
}

/// 默认将记录的Status修改为"Cleaned"，Action为Erase时清除DUMP数据。
ClassMethod CleanData(AInstanceID As %String = "", ASeqNo As %Integer = 1, Action As %String = "")
{
	s ind = "" //..GetDumpedDataID(AInstanceID,ASeqNo)
	Quit:(ind=-1) ""
	
	if ($zcvt(Action,"U")="ERASE")
	{
		s sc = ##class(EPRinstance.RecInstanceData).%DeleteId(ind)
		if $$$ISERR(sc)
		{
			Quit "Failed to Erase the data!"
		}
	}
	else
	{
		s dumpedData = ##class(EPRinstance.RecInstanceData).%OpenId(ind)
		s dumpedData.Status = "Cleaned"
		s sc = dumpedData.%Save()
		if $$$ISERR(sc)
		{
			Quit "Failed to change Status!"
		}
	}
}

ClassMethod tstHandleData(AClear As %String = 0)
{
	if AClear=0
	{
		k ^DHCEPRI.RecInstanceDataD
		k ^DHCEPRI.RecInstanceDataS
		k ^DHCEPRI.RecInstanceDataI
		
		for i=1:1:100
		{
			if (i=1)!(i=3)!(i=5)!(i=7) { d ..tstDump("1723||3") }
			elseif i#2 = 0 { d ..tstDump("1712||1") }
			else { d ..tstDump() }
		}
		
		Quit $$$OK
	}
	elseif AClear=1
	{
		k ^DHCEPRI.RecInstanceDataD
		k ^DHCEPRI.RecInstanceDataS
		k ^DHCEPRI.RecInstanceDataI
		Quit $$$OK
	}
}

ClassMethod tstDump(tstInsID As %String = "")
{
	s obj = ..DumpData(tstInsID)
	w obj,!
	if obj'=0
	{
		w "InstanceID:"_obj.InstanceID,!
		w "SeqNo:"_obj.SeqNo,!
		w "#################################",!
	}
	else
	{
		w "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@",!
	}
}

ClassMethod tstFetch(tstInsID As %String = "1737||1", tstASq As %String = 3)
{
	s obj = ##class(EPRinstance.RecInstanceData).FetchDumpedData(tstInsID,tstASq)	
	w obj.ListNo,!
	w obj.HappenTime,!
	w obj.Title,!
	w obj,!
}

ClassMethod tstRestore(tstInsID)
{
	d ..RestoreData(tstInsID,1)
}

ClassMethod tst4Q()
{
	Quit:(-1=1) "Yes"
	Quit "No"
}

}
