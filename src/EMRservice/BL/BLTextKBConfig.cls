///  名称：		EMRservice.BL.BLTextKBConfig
///  描述：		专科病历BO层
///  编写者：	yejian
///  编写时间：	2018-1-12
Class EMRservice.BL.BLTextKBConfig Extends (%RegisteredObject, %XML.Adaptor)
{

/// 获取所有专科数据
/// /////////////////////
/// Debug:	d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLTextKBConfig","GetCategorys")
Query GetCategorys() As %Query(ROWSPEC = "ID:%Integer,name:%String,type:%String,ParentID:%String,IsValid:%String,Sequence:%Integer")
{
}

ClassMethod GetCategorysExecute(ByRef qHandle As %Binary) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	s rowId = ""
	for
	{
		s rowId = $o(^DHCEMRM.TextKBCategoryD(rowId))
		q:(rowId = "")
		s obj = ##Class(EMRmeta.TextKBCategory).%OpenId(rowId)
		continue:(obj = "")
		continue:(obj.IsValid = "N")
	
		s name =obj.Name
		s type =obj.Type
		s IsValid = obj.IsValid
		s ParentID = obj.ParentID
		s Sequence = obj.Sequence

		s Data = $lb(rowId,name,type,ParentID,IsValid,Sequence)
		s ^CacheTemp(repid,ind) = Data
		s ind = ind + 1	
	}
	
	q $$$OK
}

ClassMethod GetCategorysFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCategorysExecute ]
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

ClassMethod GetCategorysClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCategorysExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// 获取所有科室数据
/// ////////科室////////////
/// Debug:	d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLTextKBConfig","SelectAllLoc")
Query SelectAllLoc() As %SQLQuery(CONTAINID = 0, ROWSPEC = "RowId:%String,Code:%String,Des:%String")
{
	SELECT CTLOC_RowId,CTLOC_CODE,upper(CTLOC_Desc) From SQLUser.CT_Loc Where CTLOC_Type='E' or CTLOC_Type='OP' or CTLOC_Type='OR' or CTLOC_Type='EM'  Order By CTLOC_Desc,CTLOC_RowId
}

ClassMethod SelectCategoryBYID(AID As %String) As EMRservice.entity.ETextKBCategory [ WebMethod ]
{
	set objCateory = ##class(EMRmeta.TextKBCategory).%OpenId(AID)
	q:(objCateory="") "" 
	set Result = ##class(EMRservice.entity.ETextKBCategory).%New()
	set Result.ID = objCateory.%Id()
	set Result.Name = objCateory.Name
	set Result.ParentID = objCateory.ParentID
	set Result.Sequence = objCateory.Sequence
	set Result.Type = objCateory.Type
	set Result.IsValid = objCateory.IsValid
	Quit Result
}

/// Description:根据CategoryID返回已经绑定了该节点的科室列表
/// Return:返回字符串,返回格式:locID1^locID2^locID3^..
/// Debug:w ##class(EMRservice.BL.BLTextKBConfig).GetBindLocByID(1)
ClassMethod GetBindLocByID(CateID As %String) As %String
{
	s LocIDStr = ""
	s curLocID = ""
	for {
		s curLocID = $o(^DHCEMRM.TextKBLocI("IdxCategoryLocID",CateID,curLocID))
		q:(curLocID="")
		
		If (LocIDStr = "")
		{
			s RowID = ""
			s RowID = $o(^DHCEMRM.TextKBLocI("IdxCategoryLocID",CateID,curLocID,RowID))
			s obj = ##class(EMRmeta.TextKBLoc).%OpenId(RowID)
		
			d obj.%Close()
			s LocIDStr = curLocID
		}
		else
		{
			s RowID = ""
			s RowID = $o(^DHCEMRM.TextKBLocI("IdxCategoryLocID",CateID,curLocID,RowID))
			s obj = ##class(EMRmeta.TextKBLoc).%OpenId(RowID)

			d obj.%Close()
			s LocIDStr = LocIDStr_"^"_curLocID
		}
	}
	quit LocIDStr
}

/// Desc:        创建目录Category节点
/// Creator:     yejian
/// CreateDate:  2018-3-8
/// Input:       AECategory
ClassMethod CreateCategory(AECategory As EMRservice.entity.ETextKBCategory) As %String
{
	s objCategory = ##class(EMRmeta.TextKBCategory).%New()
 	s objCategory.Name = AECategory.Name
 	s objCategory.ParentID = AECategory.ParentID
 	s objCategory.Type = AECategory.Type
	s objCategory.IsValid = AECategory.IsValid
 	s sc = objCategory.%Save()
 	q:($$$ISERR(sc)) "0"
 	d ..SaveSequence(objCategory.%Id())
	q objCategory.%Id()
}

/// CreatDate:   2018-3-8
/// Description: 存储顺序号
/// Table:       EMRmeta.TextKBCategory
/// Input:       树结点ID
/// debug:       d ##class(EMRservice.BL.BLTextKBConfig).SaveSequence("56")")
ClassMethod SaveSequence(RowID As %String)
{
	s objCategory= ##class(EMRmeta.TextKBCategory).%OpenId(RowID)
	q:(objCategory = "")
	s objCategory.Sequence=objCategory.%Id()
	d objCategory.%Save()
	d objCategory.%Close()	
	k objCategory
}

ClassMethod DeleteCategory(AID As %String) As %Boolean
{
	set objCategory = ##class(EMRmeta.TextKBCategory).%OpenId(AID)
	q:(objCategory="") ""
	s objCategory.IsValid = "N"
	Quit objCategory.%Save()
}

ClassMethod UpdateCategory(AECategory As EMRservice.entity.ETextKBCategory) As %Boolean
{
	set objCategory = ##class(EMRmeta.TextKBCategory).%OpenId(AECategory.ID)
	set objCategory.Name = AECategory.Name
	set objCategory.Type = AECategory.Type
	set objCategory.IsValid = AECategory.IsValid
	set objCategory.ParentID = AECategory.ParentID
	Quit objCategory.%Save()
}

/// CreatDate:2018-3-8
/// Description:修改树节点排序顺序号
/// Table:EMRmeta.TextKBCategory
/// Input:CategoryID1树节点1，CategoryID2树节点2
/// Output:无
/// Return: result是否操作成功
/// do ##class(EMRmeta.TextKBCategory).SwapSequence("1","2")
ClassMethod SwapSequence(CategoryID1 As %String, CategoryID2 As %String) As %Boolean [ WebMethod ]
{
	set result = 0
	set objNextCategory = ##class(EMRmeta.TextKBCategory).%OpenId(CategoryID1)
	set objSelectCategory = ##class(EMRmeta.TextKBCategory).%OpenId(CategoryID2)
	quit:((objNextCategory = "")||(objSelectCategory = "")) result
	
	set TempSequence = objNextCategory.Sequence
	set objNextCategory.Sequence = objSelectCategory.Sequence
	set objSelectCategory.Sequence = TempSequence
	
	set $zt = "SwapErrorHandler"
	Tstart
	set scResult=objNextCategory.%Save() 
	if $$$ISERR(scResult)
	{
		Trollback
		quit result
	}
	set scResultSele=objSelectCategory.%Save() 
	if $$$ISERR(objSelectCategory)
	{
		Trollback
		quit result
	}
	TCOMMIT
	 do objSelectCategory.%Close()
	 do objNextCategory.%Close()
	 set objSelectCategory = ""
	 set objNextCategory = ""
	 set result = 1
	 quit result
	 
SwapErrorHandler
    Trollback
    quit 0
}

/// Table:EMRmeta.TextKBLoc
/// Input:目录ID,LocIDStr-挂接科室拼成的字符串,格式为:locID1^locID2
/// Return:1-保存成功 0-保存失败
/// Others:保存操作存在三种可能:1、新增操作:原先库里不存在该目录的记录,直接插入数据
/// 	   删除操作
/// Debug:w ##class(EMRservice.BL.BLTextKBConfig).SaveBindLoc(10,"8^13^17")
ClassMethod SaveBindLoc(CateID As %String, LocIDStr As %String) As %String
{
	//b "s"
	s ret = 0, status = 1
	q:(CateID="") ret
	
	TStart
	
	//检查该目录是否已存在
	s CateIDExist = ..CheckCateIDExist(CateID)
	if (CateIDExist = 0)
	{
		if (LocIDStr '= "")&&(LocIDStr'=$c(0))
		{
			// 不存在，直接将LocIDStr中的数据插入
			for i = 1:1:$l(LocIDStr,"^")
			{
				s CtLocID = $p(LocIDStr,"^",i)
				continue:(CtLocID="")
				
				s Flag = ..Add(CateID,CtLocID)
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
		s DeleteIDs = ""
		for {
			s curLocID = $o(^DHCEMRM.TextKBLocI("IdxCategoryLocID",CateID,curLocID))
			q:(curLocID="")

			s RowID = $o(^DHCEMRM.TextKBLocI("IdxCategoryLocID",CateID,curLocID,""))
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
		
		
		//插入新数据
		if (LocIDStr '= "")&&(LocIDStr'=$c(0))
		{
			s strLength = $l(LocIDStr,"^")
			for i=1:1:strLength
			{
				//insert,create new data
				s curLocID = $p(LocIDStr,"^",i)
				continue:(curLocID="")
				
				s Flag = ..Add(CateID,curLocID)
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

ClassMethod Add(CateID As %String, LocID As %String) As %Integer
{
	s ret = 1
	//创建新数据
	s obj = ##class(EMRmeta.TextKBLoc).%New()
	s obj.CategoryID = CateID
	s obj.LocID = LocID
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
	s obj = ##class(EMRmeta.TextKBLoc).%OpenId(RowID)
	
	if '(obj.%DeleteId(RowID))
	{
		s ret = 0	
	}
	
	d obj.%Close()
	
	q ret
}

/// Creator:loo
/// CreatDate:2010-08-25
/// Description:检查目录是否在库中存在记录
/// Table:EMRmeta.TextKBLoc
/// Input:ACateID-目录ID
/// Output:
/// Return:1-该目录在库中已经存在 0-该目录在库中不存在
/// Others:
/// Debug: ##Class(EMRservice.BOEMRKbConfig).CheckCateIDExist(ACateID)
ClassMethod CheckCateIDExist(ACateID As %String) As %Integer
{
	s ret = 0
	q:(ACateID="") ret
	
	s RowID = $o(^DHCEMRM.TextKBLocI("IdxCategoryLocID",ACateID,""))
	if (+RowID>0)
	{
		s ret = 1
	}
	q ret
}

/// 获取所有用户模板
/// /////////用户模板科室////////////
/// Debug:	d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLTextKBConfig","GetAllTextKBContent")
Query GetAllTextKBContent(aCTLocName As %String) As %Query(ROWSPEC = "ID:%Integer,rowID:%Integer,Name:%String,UserID:%String,UserName:%String,CreateDate:%String,AuditID:%String,AuditName:%String,AuditDate:%String,Type:%String,Sequence:%String,Status:%String,Remark:%String,path:%String")
{
}

ClassMethod GetAllTextKBContentExecute(ByRef qHandle As %Binary, aCTLocName As %String) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	s rowID = ""
	for {
		s rowID = $o(^DHCEMRM.TextKBCategoryI("IdxType"," LEAF",rowID))
		q:(rowID = "")
		s objTextKBCategory = ##Class(EMRmeta.TextKBCategory).%OpenId(rowID)
		continue:(objTextKBCategory = "")
		continue:(objTextKBCategory.IsValid = "N")
		s rowCID =""
		s rowCID = $o(^DHCEMRM.TextKBContentI("IdxCategoryID",rowID,""))
		continue:(rowCID = "")
		s objTextKBContent = ##Class(EMRmeta.TextKBContent).%OpenId(rowCID)
		continue:(objTextKBContent = "")
		s Status = objTextKBContent.Status
		continue:(Status ="-1")
		s Name = objTextKBCategory.Name
		s Type = objTextKBCategory.Type
		
		s Sequence = objTextKBCategory.Sequence
		s UserID = objTextKBContent.UserID
		s UserName =UserID
		if (UserID'="")
		{
			s SSUSRRowId = $o(^SSU("SSUSR",0,"SSUSR_Initials",UserID,""))
			if (SSUSRRowId'="") 
			{
				s UserName = $p($g(^SSU("SSUSR",SSUSRRowId)),"^",2) //书写医生姓名
			}
		}
		s CreateDate = objTextKBContent.CreateDate
		
		s AuditID = objTextKBContent.AuditID
		s AuditName =AuditID
		if (AuditID'="")
		{
			s AuditRowId = $o(^SSU("SSUSR",0,"SSUSR_Initials",AuditID,""))
			if (AuditRowId'="") 
			{
				s AuditName = $p($g(^SSU("SSUSR",AuditRowId)),"^",2) //书写医生姓名
			}
		}
		s AuditDate = objTextKBContent.AuditDate
		s Remark = objTextKBContent.Remark
		

		s path = objTextKBCategory.Name			
		Set key = objTextKBCategory.ParentID
		do
		{ 
			s objParent = ##Class(EMRmeta.TextKBCategory).%OpenId(key)
			q:(objParent = "")
			s key = objParent.ParentID
			s strName = $case(objParent.Name,$c(0):"",:objParent.Name)
			s path = strName _"/"_path
		} 
		while (key '="0" )
		
	
		s Data = $lb(rowCID,rowID,Name,UserID,UserName,CreateDate,AuditID,AuditName,AuditDate,Type,Sequence,Status,Remark,path)
		s ^CacheTemp(repid,ind) = Data
		s ind = ind + 1	
		
	}
	
	q $$$OK
}

ClassMethod GetAllTextKBContentFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAllTextKBContentExecute ]
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

ClassMethod GetAllTextKBContentClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllTextKBContentExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// Desc:       取病历内容
/// Creator:    yejian
/// CreateDate: 2018-3-8
/// Input:      ACategoryID
/// Debug: d ##Class(EMRservice.BL.BLTextKBConfig).GetContent(4)
ClassMethod GetContent(ACategoryID As %String) As EMRservice.entity.ETextKBContent
{
	s result = ##Class(EMRservice.entity.ETextKBContent).%New()
	q:(ACategoryID = "") result
	
	s rowId = $o(^DHCEMRM.TextKBContentI("IdxCategoryID",ACategoryID,""))
	q:(rowId = "") result
	s obj = ##Class(EMRmeta.TextKBContent).%OpenId(rowId)
	q:(obj = "") result
	s result.ID = rowId
	s result.CategoryID = obj.CategoryID
	s result.Status = obj.Status
	s result.Remark = obj.Remark
	s result.UserID = obj.UserID
	s result.CreateDate = obj.CreateDate
    d result.Content.CopyFrom(obj.Content)
	q result
}

/// Desc:      更新知识库内容
/// Creator:   yejian
/// CreateDate:2018-2-28
/// Input:     ACategoryID 目录ID
///            AEKBContent 
ClassMethod UpdateContent(AECategory As EMRservice.entity.ETextKBCategory, AEKBContent As EMRservice.entity.ETextKBContent) As %String
{
	TSTART
	s strReslt = ""
	q:(AECategory = "") strReslt
	set objCategory = ##class(EMRmeta.TextKBCategory).%OpenId(AECategory.ID)
	set objCategory.Name = AECategory.Name
	s sc = objCategory.%Save()

	if ($$$ISOK(sc))
	{

		s rowId = $o(^DHCEMRM.TextKBContentI("IdxCategoryID",AECategory.ID,""))
		s objContent = ""
		if (rowId = "")
		{
			s objContent = ##Class(EMRmeta.TextKBContent).%New()
		}
		else
		{
			s objContent = ##Class(EMRmeta.TextKBContent).%OpenId(rowId)
		}
		s objContent.CategoryID = AECategory.ID
		s objContent.Status = AEKBContent.Status
		s objContent.Remark = AEKBContent.Remark
		s objContent.UserID = AEKBContent.UserID
		s objContent.CreateDate = $ZDATE($h,3)_" "_ $ZTIME($PIECE($H,",",2),1)
		d objContent.Content.CopyFrom(AEKBContent.Content)
		s sc = objContent.%Save()
		
		if ('$$$ISOK(sc))
		{ 
			s strReslt = "-1"	
		}
	}
	else
	{
		s strReslt = "-1"	
	}
	if (strReslt ="-1")
	{
		 TROLLBACK
		 q "-1"
	}
	else
	{
		TCOMMIT
		q "1"
	}
}

/// 修改专科文本状态
/// do ##class(EMRservice.BL.BLUserTemplate).ModContentStatus("1","-1")
ClassMethod ModContentStatus(AContentIDS As %String, Atatus As %String, aAuditID As %String, Remark As %String = "") As %String
{
	s Result = "-1"
	q:($g(AContentIDS) = "") Result
	S IDCount =$L(AContentIDS,"^")
	TSTART 
	For I=1:1:IDCount
	{
		s AContentID = $p(AContentIDS,"^",I)
		continue:(AContentID="")
		s objContent = ##Class(EMRmeta.TextKBContent).%OpenId(AContentID)
		q:(objContent = "")
		s objContent.Status =Atatus
		if ((Remark'="")&&(Remark'=$C(0)))
		{
			s objContent.Remark =Remark
		}
		if ((aAuditID'="")&&(aAuditID'=$C(0)))
		{
			s objContent.AuditID = aAuditID
			s objContent.AuditDate =  $ZDATE($h,3)_" "_ $ZTIME($PIECE($H,",",2),1)
		}
		if '(objContent.%Save())
		{
			TROLLBACK
			s Result = 0
			q 
		}
	}
	if (Result = 0)
	{
		 TROLLBACK
		 quit 0
	}
	TCOMMIT
	s Result = "1"
	q Result
}

}
