/// 名称：		EMRservice.BL.BLDiagnosConfig
/// 描述：		病种BL层
/// 编写者：	yejian
/// 编写时间：	2015-12-17
Class EMRservice.BL.BLDiagnosConfig Extends (%RegisteredObject, %XML.Adaptor)
{

/// 获取科室列表
Query SelectAllLoc() As %SQLQuery(CONTAINID = 0, ROWSPEC = "RowId:%String,Code:%String,Des:%String")
{
	SELECT CTLOC_RowId,CTLOC_CODE,upper(CTLOC_Desc) From SQLUser.CT_Loc Where CTLOC_Type='E' or CTLOC_Type='OP' or CTLOC_Type='OR' or CTLOC_Type='EM'  Order By CTLOC_Desc,CTLOC_RowId
}

/// 获取所有病种分组
Query GetDiagnosCategory() As %SQLQuery(CONTAINID = 0, ROWSPEC = "ID:%Integer,CategoryCode:%String,CategoryName:%String,ParentID:%String,Sequence:%Integer")
{
	SELECT ID,CategoryCode,CategoryName,ParentID,Sequence From EMRmeta.DiagnosCategory Order By ID
}

/// 根据ID获取病种
ClassMethod GetDiagnosCategoryByID(ARowID As %String) As EMRservice.entity.EDiagnosCategory
{
	s objDiagnosC = ##Class(EMRmeta.DiagnosCategory).%OpenId(ARowID)
	q:(objDiagnosC = "") ""
	
	s Result = ##Class(EMRservice.entity.EDiagnosCategory).%New()
	s Result.ID = objDiagnosC.%Id()
	s Result.CategoryCode = objDiagnosC.CategoryCode
	s Result.CategoryName = objDiagnosC.CategoryName
	s Result.ParentID = objDiagnosC.ParentID
	s Result.Sequence = objDiagnosC.Sequence

	q Result
}

/// 检查病种分组
ClassMethod CheckDiagnosCategory(CategoryCode As %String) As %String
{
	s rowID = ""
    s rowID = $o(^DHCEMRM.DiagnosCategoryI("IdxCategoryCode"," "_$zcvt(CategoryCode,"U"),rowID))
	q rowID
}

/// 添加病种分组
ClassMethod AddDiagnosCategory(ADiagnosC As EMRservice.entity.EDiagnosCategory) As %String
{
	TStart
	s ret = 1
	s objDiagnosC = ##Class(EMRmeta.DiagnosCategory).%New()
	s objDiagnosC.CategoryCode = ADiagnosC.CategoryCode
	s objDiagnosC.CategoryName = ADiagnosC.CategoryName
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
ClassMethod ModDiagnosCategory(ADiagnosC As EMRservice.entity.EDiagnosCategory) As %Boolean
{
	
	TStart
	s ret = 1
	s objDiagnosC = ##Class(EMRmeta.DiagnosCategory).%OpenId(ADiagnosC.ID)
	s CateCodeOld = objDiagnosC.CategoryCode
	s objDiagnosC.CategoryCode = ADiagnosC.CategoryCode
	s objDiagnosC.CategoryName = ADiagnosC.CategoryName
	///修改所有病种分组编码和名称
	s DiagnosRowID = ""
	s diagnosCode = ""
	for {
		s diagnosCode = $o(^DHCEMRM.DiagnosI("IdxCategoryCodeAndDiagnosCode"," "_$zcvt(CateCodeOld,"U"),diagnosCode))
		q:(diagnosCode = "")
		s DiagnosRowID = $o(^DHCEMRM.DiagnosI("IdxCategoryCodeAndDiagnosCode"," "_$zcvt(CateCodeOld,"U"),$zcvt(diagnosCode,"U"),DiagnosRowID))
		q:(DiagnosRowID = "")
		
		s objDiagnos = ##Class(EMRmeta.Diagnos).%OpenId(DiagnosRowID)
		s objDiagnos.CategoryCode = objDiagnosC.CategoryCode
		s objDiagnos.CategoryName = objDiagnosC.CategoryName
		if '(objDiagnos.%Save())
		{
			TROLLBACK
			s ret = 0
			q
		}
		d objDiagnos.%Close()
	}
	
	if ((ret=1)&&(objDiagnosC.%Save()))
	{		   
		TCommit
	}
	else
	{
		TRollback
		s ret=0
	}	
	d objDiagnosC.%Close()
	q ret
}

/// creator:yejian
/// CreatDate:2016-8-9
/// Description:修改树节点排序顺序号
/// Return: result是否操作成功
/// do ##class(EMRservice.BL.BLDiagnosConfig).SwapDiagnosCatSeq("1","2")
ClassMethod SwapDiagnosCatSeq(DiagnosCID1 As %String, DiagnosCID2 As %String) As %Boolean
{
	set result = 0
	set objNextTree = ##class(EMRmeta.DiagnosCategory).%OpenId(DiagnosCID1)
	set objSelectTree = ##class(EMRmeta.DiagnosCategory).%OpenId(DiagnosCID2)
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
ClassMethod DelDiagnosCategory(ADiagnosCID As %String) As %String
{
	
	s ret = 0
	q:($g(ADiagnosCID) = "") ret
	s ret = "1"
	s objDiagnosC = ##Class(EMRmeta.DiagnosCategory).%OpenId(ADiagnosCID)
	s strCategoryCode = objDiagnosC.CategoryCode
	if ($d(^DHCEMRM.DiagnosI("IdxCategoryCodeAndDiagnosCode"," "_$zcvt(objDiagnosC.CategoryCode,"U"))) || $d(^DHCEMRM.DiagnosCategoryI("IdxParentID"," "_ADiagnosCID)))
	{
        s ret = "2"
	}
	else
	{
		if ('objDiagnosC.%DeleteId(ADiagnosCID))
		{
			s ret = 0
		}
	}
	
	q ret
}

/// 获取所有病种
Query GetAllDiagnos() As %SQLQuery(CONTAINID = 0, ROWSPEC = "ID:%Integer,DiagnosCode:%String,DiagnosName:%String,CategoryCode:%String,CategoryName:%String,UserID:%String,CreateDate:%String,Sequence:%Integer,Status:%String")
{
	SELECT ID,DiagnosCode,DiagnosName,CategoryCode,CategoryName,UserID,CreateDate,Sequence,Status From EMRmeta.Diagnos Order By ID
}

/// 根据ID获取病种
ClassMethod GetDiagnosByID(ARowID As %String) As EMRservice.entity.EDiagnos
{
	s objDiagnos = ##Class(EMRmeta.Diagnos).%OpenId(ARowID)
	q:(objDiagnos = "") ""
	
	s Result = ##Class(EMRservice.entity.EDiagnos).%New()
	s Result.ID = objDiagnos.%Id()
	s Result.DiagnosCode = objDiagnos.DiagnosCode
	s Result.DiagnosName = objDiagnos.DiagnosName
	s Result.CategoryCode = objDiagnos.CategoryCode
	s Result.CategoryName = objDiagnos.CategoryName
	s Result.UserID = objDiagnos.UserID	
	s Result.CreateDate = $zd(objDiagnos.CreateDate,3)
	s Result.Status = objDiagnos.Status
	s Result.Sequence = objDiagnos.Sequence
	
	q Result
}

/// 根据Code获取病种
ClassMethod GetDiagnosByCode(ACode As %String) As EMRservice.entity.EDiagnos
{
	s ARowID = ""
	s ARowID = $o(^DHCEMRM.DiagnosI("IdxDiagnosCode"," "_$zcvt(ACode,"U"),ARowID))
	q:(ARowID = "") ""
	s objDiagnos = ##Class(EMRmeta.Diagnos).%OpenId(ARowID)
	q:(objDiagnos = "") ""
	
	s Result = ##Class(EMRservice.entity.EDiagnos).%New()
	s Result.ID = objDiagnos.%Id()
	s Result.DiagnosCode = objDiagnos.DiagnosCode
	s Result.DiagnosName = objDiagnos.DiagnosName
	s Result.CategoryCode = objDiagnos.CategoryCode
	s Result.CategoryName = objDiagnos.CategoryName
	s Result.UserID = objDiagnos.UserID	
	s Result.CreateDate = $zd(objDiagnos.CreateDate,3)
	s Result.Status = objDiagnos.Status
	s Result.Sequence = objDiagnos.Sequence
	
	q Result
}

/// 检查病种
ClassMethod CheckDiagnos(Code As %String) As %String
{
	s rowID = ""
    s rowID = $o(^DHCEMRM.DiagnosI("IdxDiagnosCode"," "_$zcvt(Code,"U"),rowID))
	q rowID
}

/// 添加病种
ClassMethod AddDiagnos(ADiagnos As EMRservice.entity.EDiagnos) As %String
{
	TStart
	s ret = 1
	s objDiagnos = ##Class(EMRmeta.Diagnos).%New()
	s objDiagnos.DiagnosCode = ADiagnos.DiagnosCode
	s objDiagnos.DiagnosName = ADiagnos.DiagnosName
	s objDiagnos.CategoryCode = ADiagnos.CategoryCode
	s objDiagnos.CategoryName = ADiagnos.CategoryName
	s objDiagnos.UserID = ADiagnos.UserID
	s objDiagnos.Status = ADiagnos.Status
	s objDiagnos.CreateDate = $p($h,",",1)	
	if (objDiagnos.%Save())
	{
		s ret=objDiagnos.%Id()
		s objDiagnos.Sequence=ret
		if (objDiagnos.%Save())
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
	
	d objDiagnos.%Close()
	k objDiagnos
	q ret
}

/// 修改病种
ClassMethod ModDiagnosCat(AIds As %String, ADiagnosC As EMRservice.entity.EDiagnosCategory) As %Boolean
{
	s ret = 0
	q:($g(AIds) = "") ret
	TStart
	s ret = 1
	s strIds = $l(AIds,"^")
	for i=1:1:strIds
	{
		s strID = $p(AIds,"^",i)
		s objDiagnos = ##Class(EMRmeta.Diagnos).%OpenId(strID)
		continue:(objDiagnos ="")
		s objDiagnos.CategoryCode = ADiagnosC.CategoryCode
		s objDiagnos.CategoryName = ADiagnosC.CategoryName
		if ('objDiagnos.%Save())
		{		   
			TRollback
			s ret=0
		}
	}	
	if (ret=1)
	{		   
		TCommit
	}
	q ret
}

/// 修改病种
ClassMethod ModDiagnos(ADiagnos As EMRservice.entity.EDiagnos) As %Boolean
{
	
	TStart
	s ret = 1
	s objDiagnos = ##Class(EMRmeta.Diagnos).%OpenId(ADiagnos.ID)
	s strDiagnosCodeO =objDiagnos.DiagnosCode 
	s objDiagnos.DiagnosCode = ADiagnos.DiagnosCode
	s objDiagnos.DiagnosName = ADiagnos.DiagnosName
	s objDiagnos.CategoryCode = ADiagnos.CategoryCode
	s objDiagnos.CategoryName = ADiagnos.CategoryName
	s objDiagnos.UserID = ADiagnos.UserID
	s objDiagnos.Sequence = ADiagnos.Sequence
	s objDiagnos.Status = ADiagnos.Status
	
	///修改所有分组科室关联
	s DiagnosCTRowID = ""
	for {
		s DiagnosCTRowID = $o(^DHCEMRM.DiagnosCTLocI("IdxDiagnosCode"," "_$zcvt(strDiagnosCodeO,"U"),DiagnosCTRowID))
		q:(DiagnosCTRowID = "")
	
		s objDiagnosCT = ##Class(EMRmeta.DiagnosCTLoc).%OpenId(DiagnosCTRowID)
		
		s objDiagnosCT.DiagnosCode = objDiagnos.DiagnosCode
		s objDiagnosCT.DiagnosName = objDiagnos.DiagnosName
		if '(objDiagnosCT.%Save())
		{
			TROLLBACK
			s ret = 0
			q
		}
		d objDiagnosCT.%Close()
	}
	///修改所有病种疾病关联
	s DiagnosDRowID = ""
	for {
		s DiagnosDRowID = $o(^DHCEMRM.DiagnosDiseaseI("IdxDiagnosCode"," "_$zcvt(strDiagnosCodeO,"U"),DiagnosDRowID))
		q:(DiagnosDRowID = "")
		
		s objDiagnosD = ##Class(EMRmeta.DiagnosDisease).%OpenId(DiagnosDRowID)
		s objDiagnosD.DiagnosCode = objDiagnos.DiagnosCode
		s objDiagnosD.DiagnosName = objDiagnos.DiagnosName
		if '(objDiagnosD.%Save())
		{
			TROLLBACK
			s ret = 0
			q
		}
		d objDiagnosD.%Close()
	}
	///修改所有病种知识库关联
	s DiagnosKRowID = ""
	for {
		s DiagnosKRowID = $o(^DHCEMRM.DiagnosKBNodeI("IdxDiagnosCode"," "_$zcvt(strDiagnosCodeO,"U"),DiagnosKRowID))
		q:(DiagnosKRowID = "")
		
		s objDiagnosK = ##Class(EMRmeta.DiagnosKBNode).%OpenId(DiagnosKRowID)
		s objDiagnosK.DiagnosCode = objDiagnos.DiagnosCode
		if '(objDiagnosK.%Save())
		{
			TROLLBACK
			s ret = 0
			q
		}
		d objDiagnosK.%Close()
	}
	if ((ret=1)&&(objDiagnos.%Save()))
	{		   
		TCommit
	}
	else
	{
		TRollback
		s ret=0
	}	
	d objDiagnos.%Close()
	q ret
}

/// creator:yejian
/// CreatDate:2016-8-9
/// Description:修改树节点排序顺序号
/// Return: result是否操作成功
/// do ##class(EMRservice.BL.BLDiagnosConfig).SwapSequence("1","2")
ClassMethod SwapDiagnosSeq(DiagnosID1 As %String, DiagnosID2 As %String) As %Boolean
{
	set result = 0
	set objNextTree = ##class(EMRmeta.Diagnos).%OpenId(DiagnosID1)
	set objSelectTree = ##class(EMRmeta.Diagnos).%OpenId(DiagnosID2)
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

/// 删除病种
/// do ##class(EMRservice.BL.BLDiagnosConfig).DelDiagnos("BINZ004")
ClassMethod DelDiagnos(ADiagnosCode As %String) As %Boolean
{
	s ret = 0
	q:($g(ADiagnosCode) = "") ret

	s flag = 1
	s diagnosID = $g(ADiagnosCode)
	
	TSTART
	s diagnosID = $o(^DHCEMRM.DiagnosI("IdxDiagnosCode"," "_$zcvt(ADiagnosCode,"U"),""))
	q:($g(diagnosID) = "") ret
	
	///删除所有病种科室关联
	s DiagnosCTRowID = ""
	for {
		s DiagnosCTRowID = $o(^DHCEMRM.DiagnosCTLocI("IdxDiagnosCode"," "_$zcvt(ADiagnosCode,"U"),DiagnosCTRowID))
		q:(DiagnosCTRowID = "")
	
		s objDiagnosCT = ##Class(EMRmeta.DiagnosCTLoc).%OpenId(DiagnosCTRowID)
		if '(objDiagnosCT.%DeleteId(DiagnosCTRowID))
		{
			TROLLBACK
			s ret = 0
			q
		}
	}
	
	///删除所有病种诊断关联
	s DiagnosDisRowID = ""
	for {
		s DiagnosDisRowID = $o(^DHCEMRM.DiagnosDiseaseI("IdxDiagnosCode"," "_$zcvt(ADiagnosCode,"U"),DiagnosDisRowID))
		q:(DiagnosDisRowID = "")
		
		s objDiagnosDis = ##Class(EMRmeta.DiagnosDisease).%OpenId(DiagnosDisRowID)
		if '(objDiagnosDis.%DeleteId(DiagnosDisRowID))
		{
			TROLLBACK
			s flag = 0
			q
		}
	}
	///删除知识库节点关联
	s DiagnoskbID = ""
	for {
		s DiagnoskbID = $o(^DHCEMRM.DiagnosKBNodeI("IdxDiagnosCode"," "_$zcvt(ADiagnosCode,"U"),DiagnoskbID))
		q:(DiagnoskbID = "")
		
		s objDiagnosKB = ##Class(EMRmeta.DiagnosKBNode).%OpenId(DiagnoskbID)
		
		///删除知识库节点规则
		s DiagnosKBRuleID = ""
		for {
			s DiagnosKBRuleID = $o(^DHCEMRM.DiagnosKBNodeRuleI("IdxDiagnosKBNodeID",DiagnoskbID,DiagnosKBRuleID))
			q:(DiagnosKBRuleID = "")
	
			s objDiagnosKBRule = ##Class(EMRmeta.DiagnosKBNodeRule).%OpenId(DiagnosKBRuleID)
	
			if '(objDiagnosKBRule.%DeleteId(DiagnosKBRuleID))
			{
				TROLLBACK
				s flag = 0
				q
			}
		}
		if '(objDiagnosKB.%DeleteId(DiagnoskbID))
		{
			TROLLBACK
			s flag = 0
			q
		}
	}
	
	s objDiagnos = ##Class(EMRmeta.Diagnos).%OpenId(diagnosID)
	if '(objDiagnos.%DeleteId(diagnosID))
	{
		TROLLBACK
		s flag = 0
	}
	else
	{
		 TCommit
		 s flag = 1
	}
	
	s ret = flag
	q ret
}

/// 根据科室ID获取病种
/// /////////病种科室////////////
/// Debug:	d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLDiagnosConfig","GetDiagnosByCtLocIDOrCode","","GROUP01")
Query GetDiagnosByCtLocIDOrCode(ACtLocID As %String, aDiagnosCode As %String) As %Query(ROWSPEC = "ID,DiagnosCode,DiagnosName,CTLocID,CTLocName")
{
}

ClassMethod GetDiagnosByCtLocIDOrCodeExecute(ByRef qHandle As %Binary, ACtLocID As %String, aDiagnosCode As %String) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	q:((($g(ACtLocID) = "")||(ACtLocID=$c(0)))&&(($g(aDiagnosCode)="")||(aDiagnosCode=$c(0)))) $$$OK
	s rowID = ""
	for {
		if ((ACtLocID '="")&&(ACtLocID'=$c(0)))
		{
			s rowID = $o(^DHCEMRM.DiagnosCTLocI("IdxCTLocID"," "_$g(ACtLocID),rowID))
		}
		elseif ((aDiagnosCode'="")&&(aDiagnosCode'=$c(0)))
		{
			s rowID = $o(^DHCEMRM.DiagnosCTLocI("IdxDiagnosCode"," "_$zcvt(aDiagnosCode,"U"),rowID))
		}
		q:(rowID = "")
		s objDiagnosCT = ##Class(EMRmeta.DiagnosCTLoc).%OpenId(rowID)
		continue:(objDiagnosCT = "")
	
		s DiagnosCode = objDiagnosCT.DiagnosCode
		s DiagnosName = objDiagnosCT.DiagnosName
		s CTLocID = objDiagnosCT.CTLocID
		s CTLocName = objDiagnosCT.CTLocName

	
		s Data = $lb(rowID,DiagnosCode,DiagnosName,CTLocID,CTLocName)
		s ^CacheTemp(repid,ind) = Data
		s ind = ind + 1	
	}
	
	q $$$OK
}

ClassMethod GetDiagnosByCtLocIDOrCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDiagnosByCtLocIDOrCodeExecute ]
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

ClassMethod GetDiagnosByCtLocIDOrCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDiagnosByCtLocIDOrCodeExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// 检查病种科室
ClassMethod CheckDiagnosCTLocCode(DiagnosCode As %String, CTLocID As %String) As %String
{
	s rowID = ""	
    s rowID = $o(^DHCEMRM.DiagnosCTLocI("IdxCTLocIDAndDiagnosCode"," "_$zcvt(CTLocID,"U")," "_$zcvt(DiagnosCode,"U"),rowID))
	q rowID
}

/// 添加病种科室
ClassMethod AddDiagnosCTLoc(ADiagnosCTLoc As EMRservice.entity.EDiagnosCTLoc) As %String
{
	s ret = 1
	
	s rowID= ##Class(EMRservice.BL.BLDiagnosConfig).CheckDiagnosCTLocCode(ADiagnosCTLoc.CTLocID,ADiagnosCTLoc.DiagnosCode)
	q:(rowID'="") ret
	s objDiagnosCTLoc = ##Class(EMRmeta.DiagnosCTLoc).%New()
	s objDiagnosCTLoc.DiagnosCode =ADiagnosCTLoc.DiagnosCode
	s objDiagnosCTLoc.DiagnosName =ADiagnosCTLoc.DiagnosName
	s objDiagnosCTLoc.CTLocID =ADiagnosCTLoc.CTLocID
	s objDiagnosCTLoc.CTLocName =ADiagnosCTLoc.CTLocName
	if (objDiagnosCTLoc.%Save())
	{
	    s ret=objDiagnosCTLoc.%Id()
	}
	else
	{
	   s ret=0
	}		

	d objDiagnosCTLoc.%Close()
	q ret
}

/// 删除病种科室
ClassMethod DelDiagnosCTLoc(AID As %String) As %Boolean
{
	&SQL(DELETE FROM EMRmeta.DiagnosCTLoc WHERE ID=:AID)
	q SQLCODE
}

/// 根据病种ID获取病种关联
/// /////////病种诊断/////////////
/// Debug:	d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLDiagnosConfig","GetDiagnosByICDIDOrDiagnosCode","BINZ001","")
Query GetDiagnosByICDIDOrDiagnosCode(aDiagnosCode As %String, aICDID As %String) As %Query(ROWSPEC = "ID,DiagnosCode,DiagnosName,ICDID,ICDCode,ICDName")
{
}

ClassMethod GetDiagnosByICDIDOrDiagnosCodeExecute(ByRef qHandle As %Binary, aDiagnosCode As %String, aICDID As %String) As %Status
{
	
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	q:((($g(aICDID) = "")||(aICDID=$c(0)))&&(($g(aDiagnosCode)="")||(aDiagnosCode=$c(0)))) $$$OK
	
	///开始查询
	s rowid = 0
	for {
		if ((aICDID '="")&&(aICDID'=$c(0)))
		{
			s rowid = $o(^DHCEMRM.DiagnosDiseaseI("IdxICDID",$g(aICDID),rowid))
		}
		elseif ((aDiagnosCode '="")&&(aDiagnosCode'=$c(0)))
		{
			s rowid = $o(^DHCEMRM.DiagnosDiseaseI("IdxDiagnosCode"," "_$zcvt(aDiagnosCode,"U"),rowid))
		}
		quit:(rowid = "")			
			
		s objDiagnosDis = ##Class(EMRmeta.DiagnosDisease).%OpenId(rowid)
		s DiagnosCode=objDiagnosDis.DiagnosCode
		s DiagnosName=objDiagnosDis.DiagnosName
		s ICDID=objDiagnosDis.ICDID
		s ICDCode=objDiagnosDis.ICDCode
		s ICDName=objDiagnosDis.ICDName
		
		s Data = $LB(rowid,DiagnosCode,DiagnosName,ICDID,ICDCode,ICDName)
		s ^CacheTemp(repid,ind) = Data
		s ind = ind + 1			
	}		
	
	q $$$OK
}

ClassMethod GetDiagnosByICDIDOrDiagnosCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDiagnosByICDIDOrDiagnosCodeExecute ]
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

ClassMethod GetDiagnosByICDIDOrDiagnosCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDiagnosByICDIDOrDiagnosCodeExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// 检查病种诊断
ClassMethod CheckDiagnosDiseaseCode(DiagnosCode As %String, ICDCode As %String) As %String
{
	
	s rowID = ""	
    s rowID = $o(^DHCEMRM.DiagnosDiseaseI("IdxDiagnosCodeAndICDCode"," "_$zcvt(DiagnosCode,"U")," "_$zcvt(ICDCode,"U"),rowID))
	q rowID
}

/// 添加病种诊断
ClassMethod AddDiagnosDisease(ADiagnosDisease As EMRservice.entity.EDiagnosDisease) As %String
{
	s ret = 1
	
	s rowID= ##Class(EMRservice.BL.BLDiagnosConfig).CheckDiagnosDiseaseCode(ADiagnosDisease.DiagnosCode,ADiagnosDisease.ICDCode)
	q:(rowID'="") ret
	s objDiagnosDisease = ##Class(EMRmeta.DiagnosDisease).%New()
	s objDiagnosDisease.DiagnosCode =ADiagnosDisease.DiagnosCode
	s objDiagnosDisease.DiagnosName =ADiagnosDisease.DiagnosName
	s objDiagnosDisease.ICDID =ADiagnosDisease.ICDID
	s objDiagnosDisease.ICDCode =ADiagnosDisease.ICDCode	
	s objDiagnosDisease.ICDName =ADiagnosDisease.ICDName
	if (objDiagnosDisease.%Save())
	{
	    s ret=objDiagnosDisease.%Id()
	}
	else
	{
	   s ret=0
	}		

	d objDiagnosDisease.%Close()
	q ret
}

/// 删除病种诊断
ClassMethod DelDiagnosDisease(AID As %String) As %Boolean
{
	&SQL(DELETE FROM EMRmeta.DiagnosDisease WHERE ID=:AID)
	q SQLCODE
}

ClassMethod Test()
{
    /*
    s obj = ##class(EMRservice.entity.EDiagnos).%New()
	s obj.CTLocID="106"
	s obj.Description="1"
	s obj.ID="91"
	s obj.Diagnos="aaa"
	s obj.GroupName="sdfsdaf"
	s obj.Name="sdfsdaf"
	s obj.GroupDescription="sdfsdaf"
	*/
	
	s objre = ##class(EMRservice.entity.EDiagnosCategory).%New()
	s objre.ID = 3
	s objre.GroupCode = "ces02"
	s objre.GroupName = "Ces02"
	w ..ModDiagnosCategory(objre)
	q 1
}

}
