///  名称：		EMRservice.BL.BLDiagnosGroupConfig
///  描述：		病种分组BL层
///  编写者：	yejian
///  编写时间：	2016-9-20
Class EMRservice.BL.BLDiagnosGroupConfig Extends (%RegisteredObject, %XML.Adaptor)
{

/// 根据科室ID获取所有分组
/// /////////病种科室////////////
/// Debug:	d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLDiagnosGroupConfig","GetDiagnosGroup","50")
Query GetDiagnosGroup(ACtLocID As %String) As %Query(ROWSPEC = "ID:%Integer,GroupCode:%String,GroupName:%String,CTLocID:%String,ParentID:%String,Sequence:%Integer")
{
}

ClassMethod GetDiagnosGroupExecute(ByRef qHandle As %Binary, ACtLocID As %String) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	q:((($g(ACtLocID) = "")||(ACtLocID=$c(0)))) $$$OK
	s rowID = ""
	for {
		if ((ACtLocID '="")&&(ACtLocID'=$c(0)))
		{
			s rowID = $o(^DHCEMRM.DiagnosGroupI("IdxCTLocID"," "_$g(ACtLocID),rowID))
		}
		q:(rowID = "")
		s objDiagnosGroup = ##Class(EMRmeta.DiagnosGroup).%OpenId(rowID)
		continue:(objDiagnosGroup = "")
	
		s GroupCode = objDiagnosGroup.GroupCode
		s GroupName = objDiagnosGroup.GroupName
		s CTLocID = objDiagnosGroup.CTLocID
		s ParentID = objDiagnosGroup.ParentID
		s Sequence = objDiagnosGroup.Sequence
	
		s Data = $lb(rowID,GroupCode,GroupName,CTLocID,ParentID,Sequence)
		s ^CacheTemp(repid,ind) = Data
		s ind = ind + 1	
	}
	
	q $$$OK
}

ClassMethod GetDiagnosGroupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDiagnosGroupExecute ]
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

ClassMethod GetDiagnosGroupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDiagnosGroupExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// 根据科室ID获取所有分组明细
/// /////////病种科室////////////
/// Debug:	d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLDiagnosGroupConfig","GetDiagnosGroupDetail","50")
Query GetDiagnosGroupDetail(ACtLocID As %String) As %Query(ROWSPEC = "ID:%Integer,GroupID:%String,DiagnosCode:%String,Sequence:%Integer")
{
}

ClassMethod GetDiagnosGroupDetailExecute(ByRef qHandle As %Binary, ACtLocID As %String) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	q:((($g(ACtLocID) = "")||(ACtLocID=$c(0)))) $$$OK
	s rowID = ""
	for {
		if ((ACtLocID '="")&&(ACtLocID'=$c(0)))
		{
			s rowID = $o(^DHCEMRM.DiagnosGroupI("IdxCTLocID"," "_$g(ACtLocID),rowID))
		}
		q:(rowID = "")
		s objDiagnosGroup = ##Class(EMRmeta.DiagnosGroup).%OpenId(rowID)
		continue:(objDiagnosGroup = "")
		s GroupCode = objDiagnosGroup.GroupCode
		s gdRowID = ""
		for {
			s gdRowID = $o(^DHCEMRM.DiagnosGroupDetailI("IdxGroupID"," "_$g(rowID),gdRowID))
			q:(gdRowID = "")
			s objGroupDetail = ##Class(EMRmeta.DiagnosGroupDetail).%OpenId(gdRowID)
			continue:(objGroupDetail = "")
			s GroupID = objGroupDetail.GroupID
			s DiagnosCode = objGroupDetail.DiagnosCode
			s Sequence = objGroupDetail.Sequence

			s Data = $lb(gdRowID,GroupID,DiagnosCode,Sequence)
			s ^CacheTemp(repid,ind) = Data
			s ind = ind + 1	
		}
	}
	
	q $$$OK
}

ClassMethod GetDiagnosGroupDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDiagnosGroupDetailExecute ]
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

ClassMethod GetDiagnosGroupDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDiagnosGroupDetailExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// 根据科室ID获取病种
/// /////////病种科室////////////
/// Debug:	d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLDiagnosGroupConfig","GetDiagnosByCtLocID","1")
Query GetDiagnosByCtLocID(ACtLocID As %String) As %Query(ROWSPEC = "ID:%Integer,DiagnosCode:%String,DiagnosName:%String,Status:%String,Sequence:%Integer")
{
}

ClassMethod GetDiagnosByCtLocIDExecute(ByRef qHandle As %Binary, ACtLocID As %String) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	q:((($g(ACtLocID) = "")||(ACtLocID=$c(0)))) $$$OK
	s rowID = ""
	for {
		if ((ACtLocID '="")&&(ACtLocID'=$c(0)))
		{
			s rowID = $o(^DHCEMRM.DiagnosCTLocI("IdxCTLocID"," "_$g(ACtLocID),rowID))
		}
		q:(rowID = "")
		s objDiagnosCT = ##Class(EMRmeta.DiagnosCTLoc).%OpenId(rowID)
		continue:(objDiagnosCT = "")
	
		s DiagnosCode = objDiagnosCT.DiagnosCode
		s dRowID = $o(^DHCEMRM.DiagnosI("IdxDiagnosCode"," "_$zcvt(DiagnosCode,"U"),""))
		q:(dRowID = "")
		s objDiagnos = ##Class(EMRmeta.Diagnos).%OpenId(dRowID)
		continue:(objDiagnos = "")
		s Status = objDiagnos.Status
		continue:(Status = 1)
		s DiagnosName = objDiagnos.DiagnosName
		s Sequence = objDiagnos.Sequence
		
		
		
		s Data = $lb(dRowID,DiagnosCode,DiagnosName,Status,Sequence)
		s ^CacheTemp(repid,ind) = Data
		s ind = ind + 1	
	}
	
	q $$$OK
}

ClassMethod GetDiagnosByCtLocIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDiagnosByCtLocIDExecute ]
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

ClassMethod GetDiagnosByCtLocIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDiagnosByCtLocIDExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// 得到最大code编号
ClassMethod GetMaxID() As %String
{
	//s IdexCode=0
	&sql(select max(id) into :IdexCode   from EMRmeta.DiagnosGroup)
	s:(IdexCode="") IdexCode=0
	q IdexCode
}

/// 根据ID获取病种
ClassMethod GetDiagnosGroupByID(ARowID As %String) As EMRservice.entity.EDiagnosGroup
{
	s objDiagnosC = ##Class(EMRmeta.DiagnosGroup).%OpenId(ARowID)
	q:(objDiagnosC = "") ""
	
	s Result = ##Class(EMRservice.entity.EDiagnosGroup).%New()
	s Result.ID = objDiagnosC.%Id()
	s Result.CTLocID = objDiagnosC.CTLocID
	s Result.GroupCode = objDiagnosC.GroupCode
	s Result.GroupName = objDiagnosC.GroupName
	s Result.ParentID = objDiagnosC.ParentID
	s Result.Sequence = objDiagnosC.Sequence

	q Result
}

/// 检查病种分组
ClassMethod CheckDiagnosGroup(GroupCode As %String) As %String
{
	s rowID = ""
    s rowID = $o(^DHCEMRM.DiagnosGroupI("IdxGroupCode"," "_$zcvt(GroupCode,"U"),rowID))
	q rowID
}

/// 添加病种分组
ClassMethod AddDiagnosGroup(ADiagnosC As EMRservice.entity.EDiagnosGroup) As %String
{
	TStart
	s ret = 1
	s objDiagnosC = ##Class(EMRmeta.DiagnosGroup).%New()
	s objDiagnosC.CTLocID = ADiagnosC.CTLocID
	s objDiagnosC.GroupCode = ADiagnosC.GroupCode
	s objDiagnosC.GroupName = ADiagnosC.GroupName
	s objDiagnosC.ParentID = ADiagnosC.ParentID
	if (objDiagnosC.%Save())
	{
		s ret=objDiagnosC.%Id()
		s objDiagnosC.Sequence=ret
		if (objDiagnosC.%Save())
		{
			 TCommit
		}
		else
		{
			TRollback
			s ret=0
		}
	}
	else
	{
		TRollback
		s ret=0
	}

	d objDiagnosC.%Close()	
	k objDiagnosC
	q ret
}

/// 修改病种分组
ClassMethod ModDiagnosGroup(ADiagnosC As EMRservice.entity.EDiagnosGroup) As %Boolean
{
	
	s ret = 1
	s objDiagnosC = ##Class(EMRmeta.DiagnosGroup).%OpenId(ADiagnosC.ID)
	;s CateCodeOld = objDiagnosC.GroupCode
	;s objDiagnosC.GroupCode = ADiagnosC.GroupCode
	s objDiagnosC.GroupName = ADiagnosC.GroupName
	if '(objDiagnosC.%Save())
	{
		s ret=0
	}	
	d objDiagnosC.%Close()
	q ret
}

/// 添加病种分组
ClassMethod UpDiagnosGroupDetail(aDiagnosCode As %String, oldGroupID As %String, newGroupID As %String) As %Boolean
{
	TStart
	s ret = 1
	s objGroupDetail =""
	q:(aDiagnosCode =""||oldGroupID=""||newGroupID = "") ret
	if (newGroupID =0)
	{
		s dRowID = $o(^DHCEMRM.DiagnosGroupDetailI("IdxCode"," "_$zcvt(oldGroupID,"U")," "_$zcvt(aDiagnosCode,"U"),""))
		q:(dRowID ="") ret
		s objGroupDetail = ##Class(EMRmeta.DiagnosGroupDetail).%OpenId(dRowID)
		if '(objGroupDetail.%DeleteId(dRowID))
		{
			TROLLBACK
			s ret = 0
		}
	}
	elseif (oldGroupID = 0)
	{
		s objGroupDetail = ##Class(EMRmeta.DiagnosGroupDetail).%New()
		s objGroupDetail.DiagnosCode = aDiagnosCode
		s objGroupDetail.GroupID = newGroupID
		if (objGroupDetail.%Save())
		{
			s DetID=objGroupDetail.%Id()
			s objGroupDetail.Sequence=DetID
			if '(objGroupDetail.%Save())
			{
				TRollback
				s ret=0
			}
		}
		else
		{
			TRollback
			s ret=0
		}
	}
	else
	{
		s dRowID = $o(^DHCEMRM.DiagnosGroupDetailI("IdxCode"," "_$zcvt(oldGroupID,"U")," "_$zcvt(aDiagnosCode,"U"),""))
		q:(dRowID ="") ret
		s objGroupDetail = ##Class(EMRmeta.DiagnosGroupDetail).%OpenId(dRowID)
		if '(objGroupDetail.%DeleteId(dRowID))
		{
			TROLLBACK
			s ret = 0
		}
		s objGroupDetail = ##Class(EMRmeta.DiagnosGroupDetail).%New()
		s objGroupDetail.DiagnosCode = aDiagnosCode
		s objGroupDetail.GroupID = newGroupID
		if (objGroupDetail.%Save())
		{
			s DetID=objGroupDetail.%Id()
			s objGroupDetail.Sequence=DetID
			if '(objGroupDetail.%Save())
			{
				TRollback
				s ret=0
			}
		}
		else
		{
			TRollback
			s ret=0
		}
	}
	
	if (ret=1)
	{
		TCOMMIT	
	}
	d objGroupDetail.%Close()	
	k objGroupDetail
	q ret
}

/// creator:yejian
/// CreatDate:2016-8-9
/// Description:修改树节点排序顺序号
/// Return: result是否操作成功
/// do ##class(EMRservice.BL.BLDiagnosGroupConfig).SwapDiagnosCatSeq("1","2")
ClassMethod SwapDiagnosCatSeq(DiagnosGID1 As %String, DiagnosGID2 As %String) As %Boolean
{
	set result = 0
	set objNextTree = ##class(EMRmeta.DiagnosGroup).%OpenId(DiagnosGID1)
	set objSelectTree = ##class(EMRmeta.DiagnosGroup).%OpenId(DiagnosGID2)
	quit:((objNextTree = "")||(objSelectTree = "")) result
	
	set TempSequence = objNextTree.Sequence
	set objNextTree.Sequence = objSelectTree.Sequence
	set objSelectTree.Sequence = TempSequence
	
	set $zt = "SwapErrorHandler"
	Tstart
	set scResult=objNextTree.%Save() 
	if $$$ISERR(scResult)
	{
		Trollback
		quit result
	}
	set scResultSele=objSelectTree.%Save() 
	if $$$ISERR(objSelectTree)
	{
		Trollback
		quit result
	}
	TCOMMIT
	 do objSelectTree.%Close()
	 do objNextTree.%Close()
	 set objSelectTree = ""
	 set objNextTree = ""
	 set result = 1
	 quit result
	 
SwapErrorHandler
    quit 0
}

/// creator:yejian
/// CreatDate:2016-8-9
/// Description:修改树节点排序顺序号
/// Return: result是否操作成功
/// do ##class(EMRservice.BL.BLDiagnosGroupConfig).SwapDiagnosDetailSeq("1","2")
ClassMethod SwapDiagnosDetailSeq(DiagnosGID1 As %String, DiagnosGID2 As %String) As %Boolean
{
	set result = 0
	set objNextTree = ##class(EMRmeta.DiagnosGroupDetail).%OpenId(DiagnosGID1)
	set objSelectTree = ##class(EMRmeta.DiagnosGroupDetail).%OpenId(DiagnosGID2)
	quit:((objNextTree = "")||(objSelectTree = "")) result
	
	set TempSequence = objNextTree.Sequence
	set objNextTree.Sequence = objSelectTree.Sequence
	set objSelectTree.Sequence = TempSequence
	
	set $zt = "SwapErrorHandler"
	Tstart
	set scResult=objNextTree.%Save() 
	if $$$ISERR(scResult)
	{
		Trollback
		quit result
	}
	set scResultSele=objSelectTree.%Save() 
	if $$$ISERR(objSelectTree)
	{
		Trollback
		quit result
	}
	TCOMMIT
	 do objSelectTree.%Close()
	 do objNextTree.%Close()
	 set objSelectTree = ""
	 set objNextTree = ""
	 set result = 1
	 quit result
	 
SwapErrorHandler
    quit 0
}

/// 删除病种分组
ClassMethod DelDiagnosGroup(ADiagnosCID As %String) As %String
{
	
	s ret = 0
	q:($g(ADiagnosCID) = "") ret
	TStart
	s ret = "1"
	s objDiagnosC = ##Class(EMRmeta.DiagnosGroup).%OpenId(ADiagnosCID)
	s strGroupCode = objDiagnosC.GroupCode
	///删除所有病种科室关联
	s GroupDetailRowID = ""
	for {
		s GroupDetailRowID = $o(^DHCEMRM.DiagnosGroupDetailI("IdxGroupID"," "_$zcvt(ADiagnosCID,"U"),GroupDetailRowID))
		q:(GroupDetailRowID = "")
	
		s objGroupDetal = ##Class(EMRmeta.DiagnosGroupDetail).%OpenId(GroupDetailRowID)
		if '(objGroupDetal.%DeleteId(GroupDetailRowID))
		{
			TROLLBACK
			s ret = 0
			q
		}
	}
	if ('objDiagnosC.%DeleteId(ADiagnosCID))
	{
		TROLLBACK
		s ret = 0
	}
	else
	{
		 TCommit
		 s ret = 1
	}
	
	q ret
}

}
