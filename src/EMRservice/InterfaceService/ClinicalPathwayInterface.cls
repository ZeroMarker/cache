/// 名称:	EMRservice.InterfaceService.ClinicalPathwayInterface
/// 描述:	提供灵床路径相应接口服务(医政)
/// 编写者：yejian
/// 编写日期: 2022-5-27
/// 产品组：电子病历产品组
Class EMRservice.InterfaceService.ClinicalPathwayInterface Extends (%RegisteredObject, %XML.Adaptor)
{

/*
/// d ##Class(%ResultSet).RunQuery("EMRservice.InterfaceService.ClinicalPathwayInterface","SelectEMRStructureData")
Query GetEMRSData() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,StructType:%String,Description:%String,Code:%String,Name:%String,ParentID:%String,GlossaryInternalID:%String", SELECTMODE = "RUNTIME") [ SqlProc ]
{
	SELECT ID,StructType,Description,Code,Name,ParentID,GlossaryInternalID
	FROM EMRmeta.EMRStructure
	WHERE StructType='Category' OR StructType='Document'
}
*/
/// Description: 获取病历文档结构
/// Creator：    yejian
/// CreatDate：  2022-5-31
/// Input：      aCode 编码(空查所有)
/// Output:      ID rowid、
/// 			 Code 业务活动记录分类编码或业务活动记录编码
/// 			 Name 业务活动记录分类或业务活动记录
/// 			 GlossaryInternalID 术语集内部标识符
/// 		     ParentID 目录ID
/// 		     StructType 类型
/// Return：     函数返回值的说明
/// Others：     其它说明
/// Debug: 		d ##Class(%ResultSet).RunQuery("EMRservice.InterfaceService.ClinicalPathwayInterface","SelectEMRSData","EMR01")
Query SelectEMRSData(aCode As %String = "") As %Query(ROWSPEC = "ID,Code,Name,GlossaryInternalID,ParentID,StructType")
{
}

ClassMethod SelectEMRSDataExecute(ByRef qHandle As %Binary, aCode As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
	if (aCode'="")
	{
		s strRowID=$o(^DHCEMRM.EMRStructureI("IdxCode"," "_$zcvt(aCode,"U"),""))
		q:(strRowID="") $$$OK
		s objItem =##class(EMRmeta.EMRStructure).%OpenId(strRowID)
		q:(objItem="") $$$OK
		q:((objItem.StructType'="Category")&&(objItem.StructType'="Document")) $$$OK
		
		s Code = objItem.Code
	 	s Name = objItem.Name
	 	s GlossaryInternalID = objItem.GlossaryInternalID
	 	s ParentID = objItem.ParentID
	 	s StructType = objItem.StructType
	 	s ^CacheTemp(repid,ind) = $lb(strRowID,Code,Name,GlossaryInternalID,ParentID,StructType)
		s ind=ind+1
	}
	else
	{
	 	s strCode=""
		for {
			s strCode=$o(^DHCEMRM.EMRStructureI("IdxCode",strCode))
			q:(strCode = "")
			s strRowID=""
			for {
			    s strRowID=$o(^DHCEMRM.EMRStructureI("IdxCode",strCode,strRowID))
			    q:(strRowID = "")
				s objItem =##class(EMRmeta.EMRStructure).%OpenId(strRowID)
				q:(objItem="")
				continue:((objItem.StructType'="Category")&&(objItem.StructType'="Document"))
				
				s Code = objItem.Code
			 	s Name = objItem.Name
			 	s GlossaryInternalID = objItem.GlossaryInternalID
			 	s ParentID = objItem.ParentID
			 	s StructType =objItem.StructType

			 	s ^CacheTemp(repid,ind) = $lb(strRowID,Code,Name,GlossaryInternalID,ParentID,StructType)
				s ind=ind+1
			}		
		}
	}
   Quit $$$OK
}

ClassMethod SelectEMRSDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectEMRSDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod SelectEMRSDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectEMRSDataExecute ]
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

/// Description: 获取术语集结构
/// Creator：    yejian
/// CreatDate：  2022-5-31
/// Input：      aCode 业务活动记录编码
/// 			 aGCode 术语目录内部标识符
/// Output:      ID rowid
/// 			 InternalID 术语内部标识符
/// 			 Name 术语名称
/// Return：     函数返回值的说明
/// Others：     其它说明
/// Debug: d ##Class(%ResultSet).RunQuery("EMRservice.InterfaceService.ClinicalPathwayInterface","SelectGlossaryByCode","EMR090001","HDSD00.13.01")
Query SelectGlossaryByCode(aCode As %String, aGCode As %String = "") As %Query(ROWSPEC = "ID,InternalID,Name")
{
}

ClassMethod SelectGlossaryByCodeExecute(ByRef qHandle As %Binary, aCode As %String, aGCode As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
	q:(aCode="") $$$OK
	
 	if (aGCode ="")
	{
		s strRowID=$o(^DHCEMRM.EMRStructureI("IdxCode"," "_$zcvt(aCode,"U"),""))
		q:(strRowID="") $$$OK
		s objSItem =##class(EMRmeta.EMRStructure).%OpenId(strRowID)
		q:(objSItem="") $$$OK
		s aGCode = objSItem.GlossaryInternalID
	}
	q:(aGCode="") $$$OK
	
 	s strCGid=$o(^DHCEPRM.GlossaryCategoryI("IdxOnInternalID"," "_$zcvt(aGCode,"U"),""))
 	q:(strCGid="") $$$OK
	s strGid = ""
	for {
	    s strGid=$o(^DHCEPRM.GlossaryI("IdxCategoryID"," "_strCGid,strGid))
	    q:(strGid = "")
		s objItem =##class(EPRmeta.Glossary).%OpenId(strGid)
		q:(objItem="")
		s InternalID = objItem.InternalID
	 	s Name = $tr(objItem.Name,InternalID,"")
		s Name = $tr(Name," ","")
	 	s ^CacheTemp(repid,ind) = $lb(strGid,InternalID,Name)
		s ind=ind+1
	}		
	
   Quit $$$OK
}

ClassMethod SelectGlossaryByCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectGlossaryByCodeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod SelectGlossaryByCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectGlossaryByCodeExecute ]
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

/// Description: 获取术语集结构
/// Creator：    yejian
/// CreatDate：  2022-5-31
/// Input：      aEpisodeID 就诊号
/// 			 aCode 业务活动记录编码
/// 			 aGCode 术语目录内部标识符
/// Output:      ID 实例ID
/// 			 Status （0：未填写；1：已保存；2：已签名）
/// 			 CreateUserID 创建者ID
/// 			 Title 文档标题名称
/// 			 CreateDate 创建时间
/// 			 CreateTime 创建日期
/// Return：     函数返回值的说明
/// Others：     其它说明
/// Debug: d ##Class(%ResultSet).RunQuery("EMRservice.InterfaceService.ClinicalPathwayInterface","SelectInstanceStatue","67","EMR090001")
Query SelectInstanceStatue(aEpisodeID As %String, aCode As %String, aGCode As %String = "") As %Query(ROWSPEC = "ID,Status,CreateUserID,Title,CreateDate,CreateTime")
{
}

ClassMethod SelectInstanceStatueExecute(ByRef qHandle As %Binary, aEpisodeID As %String, aCode As %String, aGCode As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	q:(aCode = "")||(aEpisodeID = "") $$$OK
 	s ACategoryInternalID=""
 	s ACategoryInternalID = aGCode
 	if (aGCode="")
 	{
		s strRowID=$o(^DHCEMRM.EMRStructureI("IdxCode"," "_$zcvt(aCode,"U"),""))
		q:(strRowID="") $$$OK
		s objSItem =##class(EMRmeta.EMRStructure).%OpenId(strRowID)
		q:(objSItem="") $$$OK
		s ACategoryInternalID = objSItem.GlossaryInternalID
		q:(ACategoryInternalID="") $$$OK
 	}
	s glossaryCategoryID = $O(^DHCEPRM.GlossaryCategoryI("IdxOnInternalID"," "_ACategoryInternalID,""))
	q:(glossaryCategoryID="") $$$OK
	//通过术语集目录获取关联的模板ID
	s objGlossaryCategory =  ##Class(EPRmeta.GlossaryCategory).%OpenId(glossaryCategoryID)
	q:(objGlossaryCategory="") $$$OK
	s templateCategoryID =##class(EMRservice.BL.BLScatterData).GetGlossaryTemplateIDS(ACategoryInternalID)
	if (templateCategoryID="")
	{
		s templateCategoryID = objGlossaryCategory.TemplateCategroyID
	}
	q:(templateCategoryID="") $$$OK
	//获取InstanceID集合
	s InstanceIDS = ##class(EMRservice.BL.BLScatterData).GetInstanceIDByTInterID(aEpisodeID,templateCategoryID,ACategoryInternalID,"")
	s intInsCount = $ll(InstanceIDS)
	q:(intInsCount = 0) $$$OK
	for i = 1:1:intInsCount
	{
		s AInstanceID = $lg(InstanceIDS,i)
		continue:(AInstanceID="")
		s objItem  = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceID,0)
		q:(objItem="")
		//0：未填写；1：已保存；2：已签名
		s strStatus = "0"
		s strStatus= $case(objItem.Status,"Save":1,:0)
		//是否有有效签名，1：有效，0：无效
	    s resState = ##Class(EMRservice.BOPrivAssist).HasValidSign(AInstanceID)
		s:(resState=1) strStatus= 2
		s CreateDate = $zd(objItem.CreateDate,3)
		s CreateTime = $zt(objItem.CreateTime,1)
		s CreateUserID = objItem.CreateUser  
		s Title = objItem.Title  
		k objItem
		s ^CacheTemp(repid,ind) = $lb(AInstanceID,strStatus,CreateUserID,Title,CreateDate,CreateTime)
		s ind=ind+1
	 }	
    Quit $$$OK
}

ClassMethod SelectInstanceStatueClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectInstanceStatueExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod SelectInstanceStatueFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectInstanceStatueExecute ]
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

/// Description:获取术语集值
/// Creator：   yejian
/// CreatDate： 2022-5-31
/// Input：      aEpisodeID 就诊号
/// 			 aCode 业务活动记录编码
/// 			 aGCode 术语目录内部标识符
/// Output:     值集合
/// Debug:		w ##Class(EMRservice.InterfaceService.ClinicalPathwayInterface).GetNewDataByGlossaryCategory("67","EMR090001","HDSD00.13.01")
ClassMethod GetNewDataByGlossaryCategory(aEpisodeID As %String, aCode As %String, aGCode As %String = "") As %ArrayOfDataTypes
{
	s ret = ##Class(%ArrayOfDataTypes).%New()
	q:(aCode = "")||(aEpisodeID = "") ret
	s strInternalID = aGCode
 	if (aGCode="")
 	{
		s strRowID=$o(^DHCEMRM.EMRStructureI("IdxCode"," "_$zcvt(aCode,"U"),""))
		q:(strRowID="") ret
		s objSItem =##class(EMRmeta.EMRStructure).%OpenId(strRowID)
		q:(objSItem="") ret
		s strInternalID = objSItem.GlossaryInternalID
		q:(ACategoryInternalID="") ret
 	}
	s ret = ##Class(EMRservice.BL.BLScatterData).GetNewDataByGlossaryCategory(aEpisodeID,strInternalID)
  	q ret
}

}
