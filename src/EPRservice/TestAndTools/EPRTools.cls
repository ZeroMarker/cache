Class EPRservice.TestAndTools.EPRTools Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// **************************************************************************
/// Creator:		Houj    [Update:lwp]
/// CreatDate:	2009-01-01  [2009-03-04]
/// Description:	解决切换组模板引起的流数据存储错误 造成的同步异常(所有同步异常)
/// Table:		/
/// Input:		/
/// Output:		/
/// Return:		/
/// Others:		/
/// Example:		d ##Class(EPRservice.TestAndTools.EPRTools).CorrectIntanceDataAll()
/// **************************************************************************
ClassMethod CorrectIntanceDataAll()
{
	s stream = ##class(%GlobalCharacterStream).%New()
	//若InstanceData在修改过程中有问题，立即停止，
	//请根据出错信息手工修改相关InstanceData
	s flag = "SUCCEED"
	s count = 0
	
	s ECRecordID = ""
	s ECRecordID = $O(^DHCEPRI.InstanceDataI("IdxECRecord",ECRecordID))
	while ECRecordID '= ""
	{
		s ChildSub = ""
		s ChildSub = $O(^DHCEPRI.InstanceDataI("IdxECRecord",ECRecordID,ChildSub))
		while ChildSub '= ""
		{
			s InstanceID = ECRecordID_"||"_ChildSub
			s obj = ##class(EPRinstance.InstanceData).%OpenId(InstanceID)
			//若原InstanceData的流数据存在^CacheStream中
			if (obj '= "")&&($find(obj.InstanceData.GetStreamId(),"^CacheStream"))
			{
				w InstanceID,!
				s count = count + 1
				
				//可以先注释掉下面内容，看一下共有多少InstanceData有问题
				//然后再放开下面的注释，修改有问题的InstanceData
				;/*注释开始
				TSTART
		
				s stream = obj.InstanceData
				s tmpobj = ##class(EPRinstance.InstanceData).%New()
		
				//使原InstanceData中的流数据Location变为^DHCEPRI.InstanceDataS
				s obj.InstanceData = tmpobj.InstanceData
				//取原InstanceData中的流数据内容
				d obj.InstanceData.CopyFrom(stream)
		
				if obj.%Save()
				{	
					d stream.Clear()
					TCOMMIT
					w "Succeed: "_InstanceID,!
				}
				else
				{
					TRollBack
					w "failed: "_InstanceID
					s flag = "FAILED"
					quit 
				}
				;注释结束*/
			}
			
			s ChildSub = $O(^DHCEPRI.InstanceDataI("IdxECRecord",ECRecordID,ChildSub))
		}
		
		quit:(flag = "FAILED")
		s ECRecordID = $O(^DHCEPRI.InstanceDataI("IdxECRecord",ECRecordID))
	}
	
	w "total InstanceData with problem: "_count
	
	quit
}

/// **************************************************************************
/// Creator:		Houj    [Update:lwp]
/// CreatDate:	2009-01-01  [2009-03-04]
/// Description:	解决切换组模板引起的流数据存储错误 造成的同步异常
/// Table:		/
/// Input:		InstanceData表ID
/// Output:		/
/// Return:		/
/// Others:		/
/// Example:		d ##Class(EPRservice.TestAndTools.EPRTools).CorrectIntanceData(aInstanceID)
/// **************************************************************************
ClassMethod CorrectIntanceData(aInstanceID As %String)
{
	s stream = ##class(%GlobalCharacterStream).%New()	
	s obj = ##class(EPRinstance.InstanceData).%OpenId(aInstanceID)
	
	//若原InstanceData的流数据存在^CacheStream中
	if (obj '= "")&&($find(obj.InstanceData.GetStreamId(),"^CacheStream"))
	{
		TSTART
		
		s stream = obj.InstanceData
		s tmpobj = ##class(EPRinstance.InstanceData).%New()
		
		//使原InstanceData中的流数据Location变为^DHCEPRI.InstanceDataS
		s obj.InstanceData = tmpobj.InstanceData
		//取原InstanceData中的流数据内容
		d obj.InstanceData.CopyFrom(stream)
		
		if obj.%Save()
		{	
			d stream.Clear()
			TCOMMIT
		}
		else
		{
			TRollBack 
			quit "failed !!!"
		}
	}
}

/// **************************************************************************
/// Creator:		Wangwt  [Update:lwp]
/// CreatDate:	2009-01-16  [2009-03-04]
/// Description:	统一修改Global存储位置
/// Table:		/
/// Input:		/
/// Output:		/
/// Return:		/
/// Others:		/
/// Example:		d ##Class(EPRservice.TestAndTools.EPRTools).MergeEPRGobal()
/// **************************************************************************
ClassMethod MergeEPRGobal()
{
  // /*
  merge ^DHCEPRM.PatientTypeD=^EPRmeta.PatientTypeD
  merge ^DHCEPRM.PatientTypeI=^EPRmeta.PatientTypeI
  merge ^DHCEPRM.PatientTypeS=^EPRmeta.PatientTypeS

  merge ^DHCEPRM.PrivRuleD=^EPRmeta.PrivRuleD
  merge ^DHCEPRM.PrivRuleI=^EPRmeta.PrivRuleI
  merge ^DHCEPRM.PrivRuleS=^EPRmeta.PrivRuleS

  merge ^DHCEPRM.PowerUserD=^DHCEPRmeta.PowerUserD
  merge ^DHCEPRM.PowerUserI=^DHCEPRmeta.PowerUserI
  merge ^DHCEPRM.PowerUserS=^DHCEPRmeta.PowerUserS

  merge ^DHCEPRM.PowerRoleD=^DHCEPRmeta.PowerRoleD
  merge ^DHCEPRM.PowerRoleI=^DHCEPRmeta.PowerRoleI
  merge ^DHCEPRM.PowerRoleS=^DHCEPRmeta.PowerRoleS

  merge ^DHCEPRM.PowerActionD=^DHCEPRmeta.PowerActionD
  merge ^DHCEPRM.PowerActionI=^DHCEPRmeta.PowerActionI
  merge ^DHCEPRM.PowerActionS=^DHCEPRmeta.PowerActionS

  merge ^DHCEPRM.EPRStatusD=^DHCEPRmeta.EPRStatusD
  merge ^DHCEPRM.EPRStatusI=^DHCEPRmeta.EPRStatusI
  merge ^DHCEPRM.EPRStatusS=^DHCEPRmeta.EPRStatusS

  merge ^DHCEPRM.CodeTable.CodeTableD=^EPRmeta.CodeTable.CodeTableD
  merge ^DHCEPRM.CodeTable.CodeTableI=^EPRmeta.CodeTable.CodeTableI
  merge ^DHCEPRM.CodeTable.CodeTableS=^EPRmeta.CodeTable.CodeTableS

  merge ^DHCEPRM.CodeTable.CTLocD=^EPRmeta.CodeTable.CTLocD
  merge ^DHCEPRM.CodeTable.CTLocI=^EPRmeta.CodeTable.CTLocI
  merge ^DHCEPRM.CodeTable.CTLocS=^EPRmeta.CodeTable.CTLocS

  merge ^DHCEPRM.SuperUserD=^EPRmeta.SuperUserD
  merge ^DHCEPRM.SuperUserI=^EPRmeta.SuperUserI
  merge ^DHCEPRM.SuperUserS=^EPRmeta.SuperUserS

  merge ^DHCEPRM.CustomQueryD=^EPRmeta.CustomQueryD
  merge ^DHCEPRM.CustomQueryI=^EPRmeta.CustomQueryI
  merge ^DHCEPRM.CustomQueryS=^EPRmeta.CustomQueryS

  merge ^DHCEPRM.CustomParameterD=^EPRmeta.CustomParameterD
  merge ^DHCEPRM.CustomParameterI=^EPRmeta.CustomParameterI
  merge ^DHCEPRM.CustomParameterS=^EPRmeta.CustomParameterS

  merge ^DHCEPRM.CustomDictionaryD=^EPRmeta.CustomDictionaryD
  merge ^DHCEPRM.CustomDictionaryI=^EPRmeta.CustomDictionaryI
  merge ^DHCEPRM.CustomDictionaryS=^EPRmeta.CustomDictionaryS

  merge ^DHCEPRI.CaseRecordNoD=^EPRinstance.CaseRecordNoD
  merge ^DHCEPRI.CaseRecordNoI=^EPRinstance.CaseRecordNoI
  merge ^DHCEPRI.CaseRecordNoS=^EPRinstance.CaseRecordNoS

  merge ^DHCEPRM.Priv.RuleDetailsD=^EPRmeta.Priv.RuleDetailsD
  merge ^DHCEPRM.Priv.RuleDetailsI=^EPRmeta.Priv.RuleDetailsI
  merge ^DHCEPRM.Priv.RuleDetailsS=^EPRmeta.Priv.RuleDetailsS

  merge ^DHCEPRM.Priv.TemplateGroupD=^EPRmeta.Priv.TemplateGroupD
  merge ^DHCEPRM.Priv.TemplateGroupI=^EPRmeta.Priv.TemplateGroupI
  merge ^DHCEPRM.Priv.TemplateGroupS=^EPRmeta.Priv.TemplateGroupS

  merge ^DHCEPRM.Priv.TemplatesRuleC=^EPRmeta.Priv.TemplatesRuleC
  merge ^DHCEPRM.Priv.TemplatesRuleD=^EPRmeta.Priv.TemplatesRuleD
  merge ^DHCEPRM.Priv.TemplatesRuleI=^EPRmeta.Priv.TemplatesRuleI
  merge ^DHCEPRM.Priv.TemplatesRuleS=^EPRmeta.Priv.TemplatesRuleS

  merge ^DHCEPRM.Priv.TempsInGroupD=^EPRmeta.Priv.TempsInGroupD
  merge ^DHCEPRM.Priv.TempsInGroupI=^EPRmeta.Priv.TempsInGroupI
  merge ^DHCEPRM.Priv.TempsInGroupS=^EPRmeta.Priv.TempsInGroupS
  // */

  
 /*
  merge ^DHCEPRM.FPI.ExportTableD=^EPRmeta.FPInter6E3.ExportTableD
  merge ^DHCEPRM.FPI.ExportTableI=^EPRmeta.FPInter6E3.ExportTableI
  merge ^DHCEPRM.FPI.ExportTableS=^EPRmeta.FPInter6E3.ExportTableS

  merge ^DHCEPRM.FPI.ExpTabColumnD=^EPRmeta.FPI6E3.ExpTabColumn8E3D
  merge ^DHCEPRM.FPI.ExpTabColumnI=^EPRmeta.FPI6E3.ExpTabColumn8E3I
  merge ^DHCEPRM.FPI.ExpTabColumnS=^EPRmeta.FPI6E3.ExpTabColumn8E3S
  */
}

/// **************************************************************************
/// Creator:		Houj   [Update:lwp]
/// CreatDate:	2008-09-22 [2009-03-04]
/// Description:	删除EpisodeID所有ISegment和ITextDesc中的错误格式信息
/// 				解决前端出现历次病程打印报错-N不是Value的有效值问题
/// Table:		/
/// Input：		EpisodeID 病人就诊号
/// 			ErrorNum  打印时报错信息的数字，如-2，-3等	
/// Output:		/
/// Return:		/
/// Others:		/
/// Example:		w ##Class(EPRservice.TestAndTools.EPRTools).DelErrScatterFormateInfo("58","-4")
/// **************************************************************************
ClassMethod DelErrScatterFormateInfo(AEpisodeID As %String, AErrorNum As %String) As %String
{
	quit:((AEpisodeID="")||(AErrorNum="")) "EpisodeID or ErrorNum is null !!!"
	
	s blankeid = " "_AEpisodeID
	
	//清除ISegment中的错误格式信息
	s tid = $O(^DHCEPRI.ISegmentI("IdxForLink",blankeid,""))
	while tid '= ""
	{
		s scode =  $O(^DHCEPRI.ISegmentI("IdxForLink",blankeid,tid,""))
		while scode '= ""
		{
			s iid = $O(^DHCEPRI.ISegmentI("IdxForLink",blankeid,tid,scode,""))
			while iid '= ""
			{
				s rowid = $O(^DHCEPRI.ISegmentI("IdxForLink",blankeid,tid,scode,iid,""))
				if rowid '= ""
				{
					do ..DelScaErrFormateInfoById("EPRinstance.ISegment",rowid,AErrorNum)
				}
				
				s iid = $O(^DHCEPRI.ISegmentI("IdxForLink",blankeid,tid,scode,iid))
			}
			
			s scode =  $O(^DHCEPRI.ISegmentI("IdxForLink",blankeid,tid,scode))
		}
		
		s tid = $O(^DHCEPRI.ISegmentI("IdxForLink",blankeid,tid))
	}
	
	//清除ITextDesc中的错误格式信息
	s tid = $O(^DHCEPRI.ITextDescI("IdxForLink",blankeid,""))
	while tid '= ""
	{
		s tcode =  $O(^DHCEPRI.ITextDescI("IdxForLink",blankeid,tid,""))
		while tcode '= ""
		{
			s iid = $O(^DHCEPRI.ITextDescI("IdxForLink",blankeid,tid,tcode,""))
			while iid '= ""
			{
				s rowid = $O(^DHCEPRI.ITextDescI("IdxForLink",blankeid,tid,tcode,iid,""))
				if rowid '= ""
				{
					do ..DelScaErrFormateInfoById("EPRinstance.ITextDesc",rowid,AErrorNum)
				}
				
				s iid = $O(^DHCEPRI.ITextDescI("IdxForLink",blankeid,tid,tcode,iid))
			}
			
			s tcode =  $O(^DHCEPRI.ITextDescI("IdxForLink",blankeid,tid,tcode))
		}
		
		s tid = $O(^DHCEPRI.ITextDescI("IdxForLink",blankeid,tid))
	}
	
	quit "Succeed !!!"
}

/// **************************************************************************
/// Creator:		Houj    [Update:lwp]
/// CreatDate:	2008-09-22  [2009-03-04]
/// Description:	删除EpisodeID下某个ISegment和ITextDesc中的错误格式信息
/// Table:		/
/// Input:		AClassName 类名
///             ARowId
///             ErrorNum   打印时报错信息的数字，如-2，-3等		
/// Output:		/
/// Return:		/
/// Others:		ReferCalss DelErrScatterFormateInfo
/// **************************************************************************
ClassMethod DelScaErrFormateInfoById(AClassName As %String, ARowId As %String, AErrorNum As %String)
{
	quit:((AClassName=0)||(ARowId="")||(AErrorNum="")) "0"
	
	//错误的格式信息标志
	s tag = "</StartPos><EndPos>"_AErrorNum_"</EndPos><FontStruct>"
		
	s obj = $zobjclassmethod(AClassName,"%OpenId",ARowId)
	if obj '= ""
	{
		//备份流数据
		s len = 32000
		s ^DHCEPRBackupScatterData(AClassName,ARowId) = obj.FormateInfo.Read(.len)
		while (len '= -1)
		{
			s ^DHCEPRBackupScatterData(AClassName,ARowId) = ^DHCEPRBackupScatterData(AClassName,ARowId)_obj.FormateInfo.Read(.len)
		} 
		
		s strTot = ^DHCEPRBackupScatterData(AClassName,ARowId)
		s count = $Length(strTot,"<FormatRange>")
		if (count > 1)   //包含格式信息
		{
			s modifiedStr = ""
			for I = 1:1:count
			{
				s str = $p(strTot,"<FormatRange>",I)
				if $find(str,tag)
				{	s modifiedStr = modifiedStr_$p(str,"</FormatRange>",2)}
				else
				{	
					if I = 1
					{ s modifiedStr = str}
					else
					{ s modifiedStr = modifiedStr_"<FormatRange>"_str}	
				}
			}
			do obj.FormateInfo.Clear()
			do obj.FormateInfo.Write(modifiedStr)
			do obj.%Save()
			w AClassName_" "_ARowId_" Succeed!!!",!		
		}	
	}
	
	quit
}

/// **************************************************************
/// EPR Wangwt 2009-01-16 PM
/// 解决：P8 重新编译后，模板权限无效问题。
/// 测试：d ##Class(EPRservice.TestAndTools.EPRTools).TPrivTest(2)
/// **************************************************************
ClassMethod TPrivTest(arga As %String)
{
	Set rset = ##class(%ResultSet).%New("EPRinstance.InstanceData:SELECTGroupList")
	Set sc = rset.Execute(arga)
	
	While (rset.Next()) {
		s InstanceId=rset.Get("ID")
		w InstanceId,!
		s Instance=##class(EPRinstance.InstanceData).%OpenId(InstanceId)
		q:(Instance="")
		if Instance.Status="UnSave" {
			w Instance.GroupItemName,!}
		if Instance.Status="Save" {
			w Instance.GroupItemName,!}
		if Instance.Status="Commit" {
			w Instance.GroupItemName,!}	
		if Instance.Status="Print" {
			w Instance.GroupItemName,!}									
	}
	Do rset.Close()
}

ClassMethod test(cid, adm)
{
	//d ##Class(EPRservice.TestAndTools.EPRTools).test(37,63570)
 // Create a Result object for the Sample.Person:ByName query
 Set rset = ##class(%ResultSet).%New("EPRmeta.Template:SelectForSltByCId")
 Set columns = rset.GetColumnCount()

 // Execute the query
 Set sc = rset.Execute(cid,adm)

 // Now fetch the results
 While (rset.Next()) {
 Write "------------------------",!
 For col = 1:1:columns {
 Write rset.GetColumnName(col),": "
 Write rset.GetData(col),!
 }
 Write "------------------------"
 }
 Do rset.Close()
}

/// 检查知识库表中，Rowid和InstanceData中的KBNodeId节点值是否一致，如不一致，说明该知识库有问题
/// 参数：argMaxKBId，知识库表中最大的Rowid
/// 输出：会列出所有有问题的知识库的Rowid和有问题的部分：S1InstanceData、S2InstanceData或S3InstanceData
/// 最后会输出有问题的知识库的总数
/// 调用方法：d ##class(EPRservice.TestAndTools.EPRTools）.CheckKB(10000)
/// gaojb 20090427
ClassMethod CheckKB(argMaxKBId As %String)
{
	s id="1"
	s sum=0 //计数器
	do
	{
		set kb=""
		set kb=##class(EPRmeta.KBNode).%OpenId(id)
		;b
		if (kb="") {
			s id=id+1
			continue}
		
		s notEqual=0 //是否有不一致数据的标志
		
		d kb.S1InstanceData.Rewind()
		s tmpStr= ""
		s tmpStr= kb.S1InstanceData.Read(100)
		if (tmpStr'="") {
			s idStart=$f(tmpStr,"<KBNodeID>")
			s idEnd=$f(tmpStr,"</KBNodeID>")-12
			s idStr=$e(tmpStr,idStart,idEnd)
			if (idStr'=id) {
				s notEqual=1
				w id_" S1InstanceData not equal!",!
			}
		}
		
		d kb.S2InstanceData.Rewind()
		s tmpStr= ""
		s tmpStr= kb.S2InstanceData.Read(100)
		if (tmpStr'="") {
			s idStart=$f(tmpStr,"<KBNodeID>")
			s idEnd=$f(tmpStr,"</KBNodeID>")-12
			s idStr=$e(tmpStr,idStart,idEnd)
			if (idStr'=id) {
				s notEqual=1
				w id_" S2InstanceData not equal!",!
			}
		}

		d kb.S3InstanceData.Rewind()
		s tmpStr= ""
		s tmpStr= kb.S3InstanceData.Read(100)
		if (tmpStr'="") {
			s idStart=$f(tmpStr,"<KBNodeID>")
			s idEnd=$f(tmpStr,"</KBNodeID>")-12
			s idStr=$e(tmpStr,idStart,idEnd)
			if (idStr'=id) {
				s notEqual=1
				w id_" S3InstanceData not equal!",!
			}
		}

		if (notEqual=1) {s sum=sum+1}
		s id=id+1
	}
	while (id<argMaxKBId)
	
	w !,sum,!
}

/// **************************************************************
/// EPR Wangwt 2009-08-03 PM
/// 解决：升级程序后，模板权限失效调试
/// 测试：d ##Class(EPRservice.TestAndTools.EPRTools).TPrivDebug(2)
/// **************************************************************
ClassMethod TPrivDebug(ATheECRecord As %String, AEpisodeID As %String)
{
	Set rset = ##class(%ResultSet).%New("EPRinstance.InstanceData:SELECTGroupListNew")
	Set sc = rset.Execute(ATheECRecord,AEpisodeID)
	
	While (rset.Next()) {
		s InstanceId=rset.Get("ID")
		w InstanceId,!
		s Instance=##class(EPRinstance.InstanceData).%OpenId(InstanceId)
		q:(Instance="")
		if Instance.Status="UnSave" {
			w Instance.GroupItemName,!}
		if Instance.Status="Save" {
			w Instance.GroupItemName,!}
		if Instance.Status="Commit" {
			w Instance.GroupItemName,!}	
		if Instance.Status="Print" {
			w Instance.GroupItemName,!}									
	}
	Do rset.Close()
}

/// w ##class(EPRservice.TestAndTools.EPRTools).UploadData()
/// w ##class(EPRservice.TestAndTools.EPRTools).UploadData()
ClassMethod UploadData()
{
	S $zt = "ErrorHandler"
	
	TSTART
	/*
	&sql(insert INTO EPRmeta.EPRAction(ActionCode, ActionName) VALUES ('save', '保存'))
	&sql(insert INTO EPRmeta.EPRAction(ActionCode, ActionName) VALUES ('commit', '提交')) 
	&sql(insert INTO EPRmeta.EPRAction(ActionCode, ActionName) VALUES ('print', '打印') )
	&sql(insert INTO EPRmeta.EPRAction(ActionCode, ActionName) VALUES ('switch', '切换模板')) 
	&sql(insert INTO EPRmeta.EPRAction(ActionCode, ActionName) VALUES ('attendingCheck', '主治医师审核')) 
	&sql(insert INTO EPRmeta.EPRAction(ActionCode, ActionName) VALUES ('chiefCheck', '主任医师审核'))
	&sql(insert INTO EPRmeta.EPRAction(ActionCode, ActionName) VALUES ('complete', '完成')) 
	&sql(insert INTO EPRmeta.EPRAction(ActionCode, ActionName) VALUES ('refreshNecessary', '刷新必填界面模板'))
	&sql(insert INTO EPRmeta.EPRAction(ActionCode, ActionName) VALUES ('refreshUnnecessary', '刷新非必填界面模板'))
 
	
	w "Suceed of upload EPRmeta.EPRAction !!!",!
	
	&sql(insert INTO EPRmeta.EPRStatus(StatusCode, StatusName) VALUES ('unfinished', '未完成'))
	&sql(insert INTO EPRmeta.EPRStatus(StatusCode, StatusName) VALUES ('finished', '完成'))
	&sql(insert INTO EPRmeta.EPRStatus(StatusCode, StatusName) VALUES ('commited', '已提交'))
	&sql(insert INTO EPRmeta.EPRStatus(StatusCode, StatusName) VALUES ('attendingChecked', '主治医师审核'))
	&sql(insert INTO EPRmeta.EPRStatus(StatusCode, StatusName) VALUES ('chiefChecked', '主任医师审核'))
	&sql(insert INTO EPRmeta.EPRStatus(StatusCode, StatusName) VALUES ('archieved', '已归档'))
	
	w "Suceed of upload EPRmeta.EPRStatus !!!",!
	*/
	&sql(insert into EPRmeta.EPRActStatusCfg (EPRAction, PreStatus, PostStatus) values ('save', 'unfinished', 'unfinished'))
	&sql(insert into EPRmeta.EPRActStatusCfg (EPRAction, PreStatus, PostStatus) values ('complete', 'unfinished', 'finished'))
	&sql(insert into EPRmeta.EPRActStatusCfg (EPRAction, PreStatus, PostStatus) values ('switch', 'unfinished', 'unfinished'))
	&sql(insert into EPRmeta.EPRActStatusCfg (EPRAction, PreStatus, PostStatus) values ('complete', 'finished', 'finished'))
	&sql(insert into EPRmeta.EPRActStatusCfg (EPRAction, PreStatus, PostStatus) values ('commit', 'finished', 'commited'))
	&sql(insert into EPRmeta.EPRActStatusCfg (EPRAction, PreStatus, PostStatus) values ('print', 'finished', 'finished'))
	&sql(insert into EPRmeta.EPRActStatusCfg (EPRAction, PreStatus, PostStatus) values ('switch', 'finished', 'unfinished'))
	&sql(insert into EPRmeta.EPRActStatusCfg (EPRAction, PreStatus, PostStatus) values ('complete', 'commited', 'commited'))
	&sql(insert into EPRmeta.EPRActStatusCfg (EPRAction, PreStatus, PostStatus) values ('print', 'commited', 'commited'))
	&sql(insert into EPRmeta.EPRActStatusCfg (EPRAction, PreStatus, PostStatus) values ('switch', 'commited', 'unfinished'))
	&sql(insert into EPRmeta.EPRActStatusCfg (EPRAction, PreStatus, PostStatus) values ('AttendingCheck', 'commited', 'attendingChecked'))
	&sql(insert into EPRmeta.EPRActStatusCfg (EPRAction, PreStatus, PostStatus) values ('ChiefCheck', 'commited', 'chiefChecked'))
	&sql(insert into EPRmeta.EPRActStatusCfg (EPRAction, PreStatus, PostStatus) values ('complete', 'attendingChecked', 'attendingChecked'))
	&sql(insert into EPRmeta.EPRActStatusCfg (EPRAction, PreStatus, PostStatus) values ('print', 'attendingChecked', 'attendingChecked'))
	&sql(insert into EPRmeta.EPRActStatusCfg (EPRAction, PreStatus, PostStatus) values ('ChiefCheck', 'attendingChecked', 'chiefChecked'))
	&sql(insert into EPRmeta.EPRActStatusCfg (EPRAction, PreStatus, PostStatus) values ('complete', 'chiefChecked', 'chiefChecked'))
	&sql(insert into EPRmeta.EPRActStatusCfg (EPRAction, PreStatus, PostStatus) values ('print', 'chiefChecked', 'chiefChecked'))
	&sql(insert into EPRmeta.EPRActStatusCfg (EPRAction, PreStatus, PostStatus) values ('print', 'archieved', 'archieved'))
	&sql(insert into EPRmeta.EPRActStatusCfg (EPRAction, PreStatus, PostStatus) values ('save', ' ', 'unfinished'))
	&sql(insert into EPRmeta.EPRActStatusCfg (EPRAction, PreStatus, PostStatus) values ('complete', ' ', 'finished'))
	&sql(insert into EPRmeta.EPRActStatusCfg (EPRAction, PreStatus, PostStatus) values ('save', 'finished', 'finished'))
	&sql(insert into EPRmeta.EPRActStatusCfg (EPRAction, PreStatus, PostStatus) values ('refreshNecessary', 'unfinished', 'unfinished'))
	&sql(insert into EPRmeta.EPRActStatusCfg (EPRAction, PreStatus, PostStatus) values ('refreshNecessary',	'finished', 'unfinished'))
	&sql(insert into EPRmeta.EPRActStatusCfg (EPRAction, PreStatus, PostStatus) values ('refreshNecessary',	'commited', 'unfinished'))
	&sql(insert into EPRmeta.EPRActStatusCfg (EPRAction, PreStatus, PostStatus) values ('refreshUnnecessary', 'unfinished', 'unfinished'))
	&sql(insert into EPRmeta.EPRActStatusCfg (EPRAction, PreStatus, PostStatus) values ('refreshUnnecessary', 'finished', 'finished'))	
	&sql(insert into EPRmeta.EPRActStatusCfg (EPRAction, PreStatus, PostStatus) values ('refreshUnnecessary', 'commited', 'commited'))
	&sql(insert into EPRmeta.EPRActStatusCfg (EPRAction, PreStatus, PostStatus) values ('refreshNecessary', ' ', 'unfinished'))
	&sql(insert into EPRmeta.EPRActStatusCfg (EPRAction, PreStatus, PostStatus) values ('refreshUnnecessary', ' ', 'unfinished'))
	&sql(insert into EPRmeta.EPRActStatusCfg (EPRAction, PreStatus, PostStatus) values ('save', 'commited', 'commited'))
	
	w "Suceed of upload EPRmeta.EPRActStatusCfg !!!",!
	
	TCOMMIT
	
	quit
	
ErrorHandler
	w "Error occured in upload data!!!"
	TROLLBACK
}

/// 	Desc:	与用户交互，确认要操作的病人病历信息
/// 	Input:	argAdmId: 病人就诊rowid
/// 			argChartItemId:可选参数，病历的ChartItemID，即网页源文件上的PorfileID，
ClassMethod ConfirmInfomation(argAdmId As %String, argChartItemId As %String = "") As %String
{
	q:(argAdmId="") "0"
	
	s className="EPRservice.HISInterface.PatientInfoAssist"
	
	//若有其它病人基本信息需要添加，请获取输出即可
	s PapmiDR = $ZOBJCLASSMETHOD(className,"GetPapmiDR",argAdmId) 
	s regno = $P($g(^PAPER(PapmiDR,"PAT",1)),"^",1)  
	s name = $ZOBJCLASSMETHOD(className,"Name",PapmiDR)
	s gender = $ZOBJCLASSMETHOD(className,"Gender",PapmiDR,"DiTan")
	s curDept = $P($ZOBJCLASSMETHOD(className,"CurrentDept",argAdmId),"^",2)
	s admDate = $P($ZOBJCLASSMETHOD(className,"AdmDateTime",argAdmId,"DiTan"),",",1)
	s admDate = $zd(admDate,3)
	
	w "病人基本信息如下:",!
	w "住院号: "_regno,!
	w "姓名: "_name,!
	w "性别: "_gender,!
	w "入院日期:"_admDate,!
	w "当前科室:"_curDept,!
	s recordDesc = ""
	if argChartItemId '= ""
	{
		&sql(select PPDesc into :recordDesc from sqluser.epr.ctprofileparams where ID = :argChartItemId)
		w "要删除的病历为: "_recordDesc
	}
	
	//与用户交互，确认病人的基本信息
	Read !, "确认请输入:y, 错误请输入:n    ", isConfirm
	if $zcvt(isConfirm,"U")="Y"
	{	q "1"}
	else
	{	q "0"}
}

/// Desc: 		通过 AdmId 清空病人所有数据(兼容新框架)
/// Intput：	argAdmId, argChartItemID
/// d ##class(EPRservice.TestAndTools.EPRTools).DelInstAndSimpByADMID("65")
ClassMethod DelInstAndSimpByADMID(argAdmId As %String, argChartItemID As %String) As %String
{
	
	if ($d(argAdmId)=0)||(argAdmId="")
	{
		w "病人就诊rowid不存在!",!
		q "删除失败!"
	}
	
	s isOK = ..ConfirmInfomation(argAdmId)
	if isOK="0" quit
	
	w "开始删除病人打散数据:",!
	
	///////////////////////////////////////////////////////////////////////////////
	//删除病人的主表数据
	k SQLCODE
	if (($d(argChartItemID)=0)||(argChartItemID="")) {
		&SQL(delete from EPRinstance.ECRecord where EpisodeID = :argAdmId )
	}
	else {
		&SQL(delete from EPRinstance.ECRecord where EpisodeID = :argAdmId and ChartItemID=:argChartItemID)
	}
	if SQLCODE=100 { s SQLCODE=SQLCODE_"没有数据"}
	elseif SQLCODE=0 { s SQLCODE=SQLCODE_"数据删除成功"}
	W "删除ECRecord表数据:"_SQLCODE,!
	
	
	///////////////////////////////////////////////////////////////////////////////
	//删除病人的打散数据
	k SQLCODE
	if (($d(argChartItemID)=0)||(argChartItemID="")) {
		&SQL(delete from EPRinstance.ISimple where EpisodeID = :argAdmId )
	}
	else {
		&SQL(delete from EPRinstance.ISimple where EpisodeID = :argAdmId and ChartItemID=:argChartItemID)
	}
	if SQLCODE=100 { s SQLCODE=SQLCODE_"没有数据"}
	elseif SQLCODE=0 { s SQLCODE=SQLCODE_"数据删除成功"}
	W "删除ISimple表数据:"_SQLCODE,!
	
	k SQLCODE
	if (($d(argChartItemID)=0)||(argChartItemID="")) {
		&SQL(delete from EPRinstance.ISegment where EpisodeID = :argAdmId )
	}
	else {
		&SQL(delete from EPRinstance.ISegment where EpisodeID = :argAdmId and ChartItemID=:argChartItemID)
	}
	if SQLCODE=100 { s SQLCODE=SQLCODE_"没有数据"}
	elseif SQLCODE=0 { s SQLCODE=SQLCODE_"数据删除成功"}
	W "删除ISegment表数据:"_SQLCODE,!

	k SQLCODE
	if (($d(argChartItemID)=0)||(argChartItemID="")) {
		&SQL(delete from EPRinstance.ISegmentSimple where EpisodeID = :argAdmId )
		}
	else {
		&SQL(delete from EPRinstance.ISegmentSimple where EpisodeID = :argAdmId and ChartItemID=:argChartItemID)
	}
	if SQLCODE=100 { s SQLCODE=SQLCODE_"没有数据"}
	elseif SQLCODE=0 { s SQLCODE=SQLCODE_"数据删除成功"}
	W "删除ISegmentSimple表数据:"_SQLCODE,!
	
	k SQLCODE
	if (($d(argChartItemID)=0)||(argChartItemID="")) {
		&SQL(delete from EPRinstance.ITextDesc where EpisodeID = :argAdmId )
		}
	else {
		&SQL(delete from EPRinstance.ITextDesc where EpisodeID = :argAdmId and ChartItemID=:argChartItemID)
	}
	if SQLCODE=100 { s SQLCODE=SQLCODE_"没有数据"}
	elseif SQLCODE=0 { s SQLCODE=SQLCODE_"数据删除成功"}
	W "删除ITextDesc表数据:"_SQLCODE,!
	
	k SQLCODE
	if (($d(argChartItemID)=0)||(argChartItemID="")) {
		&SQL(delete from EPRinstance.ITextDescSimple where EpisodeID = :argAdmId )
		}
	else {
		&SQL(delete from EPRinstance.ITextDescSimple where EpisodeID = :argAdmId and ChartItemID=:argChartItemID)
	}
	if SQLCODE=100 { s SQLCODE=SQLCODE_"没有数据"}
	elseif SQLCODE=0 { s SQLCODE=SQLCODE_"数据删除成功"}
	W "删除ITextDescSimple表数据:"_SQLCODE,!
	
	k SQLCODE
	if (($d(argChartItemID)=0)||(argChartItemID="")) {
		&SQL(delete from EPRinstance.ITableSimple where EpisodeID = :argAdmId )
		}
	else {
		&SQL(delete from EPRinstance.ITableSimple where EpisodeID = :argAdmId and ChartItemID=:argChartItemID)
	}
	if SQLCODE=100 { s SQLCODE=SQLCODE_"没有数据"}
	elseif SQLCODE=0 { s SQLCODE=SQLCODE_"数据删除成功"}
	W "删除ITableSimple表数据:"_SQLCODE,!
	
	k SQLCODE
	if (($d(argChartItemID)=0)||(argChartItemID="")) {
		&SQL(delete from EPRinstance.IAnnotate where EpisodeID = :argAdmId )
		}
	else {
		&SQL(delete from EPRinstance.IAnnotate where EpisodeID = :argAdmId and ChartItemID=:argChartItemID)
	}
	if SQLCODE=100 { s SQLCODE=SQLCODE_"没有数据"}
	elseif SQLCODE=0 { s SQLCODE=SQLCODE_"数据删除成功"}
	W "删除IAnnotate表数据:"_SQLCODE,!
	
	k SQLCODE
	if (($d(argChartItemID)=0)||(argChartItemID="")) {
		&SQL(delete from EPRinstance.IFigure where EpisodeID = :argAdmId )
		}
	else {
		&SQL(delete from EPRinstance.IFigure where EpisodeID = :argAdmId and ChartItemID=:argChartItemID)
	}
	if SQLCODE=100 { s SQLCODE=SQLCODE_"没有数据"}
	elseif SQLCODE=0 { s SQLCODE=SQLCODE_"数据删除成功"}
	W "删除IFigure表数据:"_SQLCODE,!
	
	//q
	///////////////////////////////////////////////////////////////////////////////
	//删除病人的打印日志数据
	k SQLCODE
	&SQL(delete from EPRinstance.InstancePrintRecord 
			where  EpisodePrintRecordID in (select distinct ID from EPRinstance.EpisodePrintRecord where EpisodeID = :argAdmId )  )
	if SQLCODE=100 { s SQLCODE=SQLCODE_"没有数据"}
	elseif SQLCODE=0 { s SQLCODE=SQLCODE_"数据删除成功"}
	W "删除InstancePrintRecord表数据:"_SQLCODE,!

	k SQLCODE
	&SQL(delete from EPRinstance.EpisodePrintRecord where EpisodeID = :argAdmId )
	if SQLCODE=100 { s SQLCODE=SQLCODE_"没有数据"}
	elseif SQLCODE=0 { s SQLCODE=SQLCODE_"数据删除成功"}
	W "删除EpisodePrintRecord表数据:"_SQLCODE,!
	
	///////////////////////////////////////////////////////////////////////////////
	//删除病人的新框架数据
	
	k SQLCODE
	&SQL(delete from EPRinstance.AdmPatType where EpisodeID = :argAdmId )
	if SQLCODE=100 { s SQLCODE=SQLCODE_"没有数据"}
	elseif SQLCODE=0 { s SQLCODE=SQLCODE_"数据删除成功"}
	W "删除AdmPatType表数据:"_SQLCODE,!
	
	k SQLCODE
	&SQL(delete from EPRinstance.EPImagePage 
			where  EPImageID in (select distinct ID from EPRinstance.EPImage where EpisodeID = :argAdmId )  )
	if SQLCODE=100 { s SQLCODE=SQLCODE_"没有数据"}
	elseif SQLCODE=0 { s SQLCODE=SQLCODE_"数据删除成功"}
	W "删除EPImagePage表数据:"_SQLCODE,!

	k SQLCODE
	&SQL(delete from EPRinstance.EPImage where EpisodeID = :argAdmId )
	if SQLCODE=100 { s SQLCODE=SQLCODE_"没有数据"}
	elseif SQLCODE=0 { s SQLCODE=SQLCODE_"数据删除成功"}
	W "删除EPImage表数据:"_SQLCODE,!
	
	k SQLCODE
	&SQL(delete from EPRinstance.EPRDept where EpisodeID = :argAdmId )
	if SQLCODE=100 { s SQLCODE=SQLCODE_"没有数据"}
	elseif SQLCODE=0 { s SQLCODE=SQLCODE_"数据删除成功"}
	W "删除EPRDept表数据:"_SQLCODE,!
	
	k SQLCODE
	&SQL(delete from EPRinstance.EPRLogs where EpisodeID = :argAdmId )
	if SQLCODE=100 { s SQLCODE=SQLCODE_"没有数据"}
	elseif SQLCODE=0 { s SQLCODE=SQLCODE_"数据删除成功"}
	W "删除EPRLogs表数据:"_SQLCODE,!
	
	//s isOK = ..ConfirmInfomation(argAdmId)
	//if isOK="0" quit
}

ClassMethod CheckTemplateInfoNewFrame(argTemplateName As %String) As %String
{
}

}
