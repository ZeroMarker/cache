/// 名称:           EPRservice.dao.DUnitGlossary
/// 描述:           术语项目服务类(包括模板单元项目和知识库单元项目)
/// 编写者：        yejian
/// 编写日期:       2021-2-9
Class EPRservice.dao.DUnitGlossary Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Query SelectByItemCode(ATemplateID As %String, AItemCode As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "Name:%String,Description:%String,InternalID:%String,MetaID:%String,GID:%String,ValueType:%String")
{
	SELECT Name,Description,B.InternalID,MetaID, A.glossaryID GID,ValueType
	FROM EPRmeta.GlossaryItem A, EPRmeta.Glossary B 
	WHERE A.glossaryID = B.ID AND ItemCode = :AItemCode AND TemplateID = :ATemplateID
}

/// Creator:	yejian
/// CreatDate:  2022-2-15
/// Desc:		根据模板编码获取关联术语信息(维护端根据编码获取术语)
/// Input：		ATemplateCode：模板编码，ATemType：类型（BASE）
/// Return：	dataset
/// debug d ##Class(%ResultSet).RunQuery("EPRservice.dao.DUnitGlossary","SelectGlossaryByTemCode","EMR090001","BASE")
Query SelectGlossaryByTemCode(ATemplateCode As %String, ATemType As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,GlossaryID,ItemCode,InternalID,TemplateCode,Name,ValueType,TemplateID,TemType,ItemName")
{
	SELECT a.ID,a.GlossaryID,a.ItemCode,b.InternalID, a.TemplateCode,b.Name,a.ValueType,a.TemplateID,a.TemType,a.ItemName
	FROM EPRmeta.GlossaryItem a join EPRmeta.Glossary b on a.glossaryID = b.ID
	WHERE a.TemplateCode =:ATemplateCode AND A.TemType = :ATemType
}

/// Creator:	yejian
/// CreatDate:  2019-7-12
/// Desc:		根据模板获取关联术语信息(维护端根据编码获取术语)
/// Input：		ATemplateID：模板ID
/// Return：	dataset
/// Debug:		d ##Class(%ResultSet).RunQuery("EPRservice.dao.DUnitGlossary","SelectGlossaryByTemID","1")
Query SelectGlossaryByTemID(ATemplateID As %String) As %Query(ROWSPEC = "ID,GlossaryID,ItemCode,InternalID,TemplateCode,Name,ValueType,TemplateID,TemType,ItemName")
{
}

ClassMethod SelectGlossaryByTemIDExecute(ByRef qHandle As %Binary, ATemplateID As %String) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	q:($g(ATemplateID) = "") $$$OK
	s rowID = ""	
	for {
		s rowID = $o(^DHCEPRM.GlossaryItemI("IdxTemplateID",ATemplateID,rowID))
		q:(rowID = "")	
		s objGlossaryItem = ##Class(EPRmeta.GlossaryItem).%OpenId(rowID)
		continue:(objGlossaryItem = "")
		s objGlossary = ##Class(EPRmeta.Glossary).%OpenId(objGlossaryItem.GlossaryID)
		continue:(objGlossary = "")
		continue:(objGlossaryItem.TemType'="NEW")
		
		s GlossaryID = objGlossaryItem.GlossaryID
		s ItemCode = objGlossaryItem.ItemCode
		s InternalID = objGlossary.InternalID
		s TemplateCode = objGlossaryItem.TemplateCode
		s Name = objGlossary.Name
		s ValueType = objGlossaryItem.ValueType
		s TemplateID = objGlossaryItem.TemplateID
		s TemType = objGlossaryItem.TemType
		s ItemName = objGlossaryItem.ItemName
		s Data = $lb(rowID,GlossaryID,ItemCode,InternalID,TemplateCode,Name,ValueType,TemplateID,TemType,ItemName)
		s ^CacheTemp(repid,ind) = Data
		s ind = ind + 1
		
	}
	q $$$OK
}

ClassMethod SelectGlossaryByTemIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectGlossaryByTemIDExecute ]
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

ClassMethod SelectGlossaryByTemIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectGlossaryByTemIDExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// Creator:	yejian
/// CreatDate:  2022-1-27
/// Desc:		根据术语关联ID删除关联
/// Input：		AID：eprmeta.glossaryItem 表rowID
/// Return：	0:失败，1:成功
/// w ##Class(EPRservice.dao.DUnitGlossary).DelGlossaryItemByID(538)
ClassMethod DelGlossaryItemByID(AID As %String) As %String
{
	s strRes = "1"
	q:(AID = "") strRes
	s strID = $d(^DHCEPRM.GlossaryItemD(AID))
	q:(strID=0) strRes
	s sc= ##class(EPRmeta.GlossaryItem).%DeleteId(AID)
	s:('sc) strRes="0"
	q strRes
}

/// Creator:	yejian
/// CreatDate:  2022-2-11
/// Desc:		修改术语关联关系
/// Input：		AGlossaryItem：EPRservice.entity.EGlossaryItem
/// Return：	0:失败，1:成功,-1:关联关系已存在
/// w ##Class(EPRservice.dao.DUnitGlossary).UpGlossaryItem(538)
ClassMethod UpGlossaryItem(AGlossaryItem As EPRservice.entity.EGlossaryItem) As %String
{
	s strRes = "0"
	q:(AGlossaryItem = "")||(AGlossaryItem.ID="") strRes
	s itemID = $o(^DHCEPRM.GlossaryItemI("IdxComposite",AGlossaryItem.GlossaryID,AGlossaryItem.TemplateID," "_$zcvt(AGlossaryItem.ItemCode,"U")," "_$zcvt(AGlossaryItem.ValueType,"U"),""))
	q:(itemID'="") "-1"
	s objItem = ##class(EPRmeta.GlossaryItem).%OpenId(AGlossaryItem.ID)
	q:(objItem="") strRes
	s objItem.ItemName = AGlossaryItem.ItemName
	s objItem.ValueType = AGlossaryItem.ValueType
	s sc = objItem.%Save()
	s:(sc) strRes = "1"
	q strRes
}

/// Creator:	yejian
/// CreatDate:  2022-2-11
/// Desc:		添加术语关联关系
/// Input：		AGlossaryItem：EPRservice.entity.EGlossaryItem
/// Return：	0:失败，1:成功,-1:关联关系已存在
/// w ##Class(EPRservice.dao.DUnitGlossary).AddGlossaryItem(538)
ClassMethod AddGlossaryItem(AGlossaryItem As EPRservice.entity.EGlossaryItem) As %String
{
	s strRes = "0"
	q:(AGlossaryItem = "") strRes
	s itemID = $o(^DHCEPRM.GlossaryItemI("IdxComposite",AGlossaryItem.GlossaryID,AGlossaryItem.TemplateID," "_$zcvt(AGlossaryItem.ItemCode,"U")," "_$zcvt(AGlossaryItem.ValueType,"U"),""))
	q:(itemID'="") "-1"
	s objItem = ##Class(EPRmeta.GlossaryItem).%New()
	s objItem.GlossaryID = AGlossaryItem.GlossaryID
	s objItem.TemplateID = AGlossaryItem.TemplateID
	s objItem.ItemCode = AGlossaryItem.ItemCode
	s objItem.ItemName = AGlossaryItem.ItemName
	s objItem.ValueType = AGlossaryItem.ValueType
	s objItem.TemplateCode = AGlossaryItem.TemplateCode
	s objItem.TemType = AGlossaryItem.TemType
	s objItem.InternalID = AGlossaryItem.InternalID
	s sc= objItem.%Save()
	s:(sc) strRes = sc    
	q strRes
}

/// Creator:	yejian
/// CreatDate:  2022-2-11
/// Desc:		通过模板元素术语关系，添加元素术语关联关系
/// Input：		AGlossaryItem  模板元素信息
/// Input：		AGlossaryItemN 新增元素信息
/// Return：	失败：0，成功：返回关联rowid1^rowid2
/// w ##Class(EPRservice.dao.DUnitGlossary).AddGlossaryItemByCElement(538)
ClassMethod AddGlossaryItemByCElement(AGlossaryItem As EPRservice.entity.EGlossaryItem, AGlossaryItemN As EPRservice.entity.EGlossaryItem) As %String
{
	s strRes = "0"
	q:((AGlossaryItem = "")||(AGlossaryItem.ItemCode="")||(AGlossaryItem.TemplateCode="")) strRes
	q:((AGlossaryItemN = "")||(AGlossaryItemN.ItemCode="")||(AGlossaryItemN.TemplateID="")) strRes
	s strRowID = ""
	s strItemCode = $zcvt(AGlossaryItem.ItemCode,"U")
	s strTemCode = $zcvt(AGlossaryItem.TemplateCode,"U")
	s strRes = ""
	s result = ##class(%ResultSet).%New("EPRservice.dao.DUnitGlossary:SelectGlossaryByCodes")
	d result.Execute(strItemCode,strTemCode)
	s strResIDs=""
	While result.Next() 
	{
     	s strRowID =result.GetDataByName("ID")
		continue:(strRowID="")
		s GlossaryID=result.GetDataByName("GlossaryID")
		s ValueType=result.GetDataByName("ValueType")
		s ItemName=result.GetDataByName("ItemName")
		s InternalID=result.GetDataByName("InternalID")
		s ItemCode = $zcvt(AGlossaryItemN.ItemCode,"U")
		s itemID = $o(^DHCEPRM.GlossaryItemI("IdxComposite",GlossaryID,AGlossaryItemN.TemplateID," "_$zcvt(ItemCode,"U")," "_$zcvt(ValueType,"U"),""))
		continue:(itemID'="")
		s objItem = ##Class(EPRmeta.GlossaryItem).%New()
		s objItem.GlossaryID = GlossaryID
		s objItem.TemplateID = AGlossaryItemN.TemplateID
		s objItem.ItemCode = ItemCode
		s objItem.ItemName = ItemName
		s objItem.ValueType = ValueType
		s objItem.TemplateCode = AGlossaryItemN.TemplateCode
		s objItem.TemType = $zcvt(AGlossaryItemN.TemType,"U")
		s objItem.InternalID = InternalID
		s sc= objItem.%Save()
		s:(sc) strResIDs = $case(strResIDs,"":objItem.%Id(),:(strResIDs_"^"_objItem.%Id()))    
	}
	q strResIDs
}

/// Creator:	yejian
/// CreatDate:  2022-2-15
/// Desc:		根据模板编码获取关联术语信息(维护端根据编码获取术语)
/// Input：		ATemplateCode：模板编码，ATemType：类型（BASE）
/// Return：	dataset
/// debug d ##Class(%ResultSet).RunQuery("EPRservice.dao.DUnitGlossary","SelectGlossaryByCodes","#TYPE:ICOMPOSITESAMPLE#SCODE:S001|CSCODE:I0002","EMR090001")
Query SelectGlossaryByCodes(ItemCode As %String, TemplateCode As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,GlossaryID,ItemName,InternalID,ValueType")
{
	SELECT a.ID,a.GlossaryID,a.ItemName,a.InternalID,a.ValueType FROM EPRmeta.GlossaryItem a 
	WHERE a.ItemCode =:ItemCode AND A.TemplateCode = :TemplateCode AND a.TemType ='BASE'
}

/// Desc:       发布时清理无用的术语关联
/// Creator:    yejian
/// CreateDate: 2021-6-15
/// Input:      argArr 模板简单元素集合，aTemplateID 目录ID，aType 模板类型
/// OutPut:     返回值：成功 1，失败 -1
/// debug:		w ##class(EPRservice.dao.DUnitGlossary).ClearGlossaryItemsByCode()
ClassMethod ClearGlossaryItemsByCode(argArr As %ListOfDataTypes(ELEMENTTYPE="%String",MAXLEN="200"), aTemplateID As %String, aType As %String) As %String
{
	s strRes = "-1"
	q:($d(aTemplateID)=0)||(aTemplateID="") strRes
	s isWrite = $o(^DHCEMRI.InstanceDataI("IdxListNoTemplateIDVersion"," "_aTemplateID,""))
	q:(isWrite'="") "1"
	TSTART 
	s rowID = ""
	s strMark = 1
	for
	{
		s rowID = $o(^DHCEPRM.GlossaryItemI("IdxTemplateID",aTemplateID,rowID))
		q:(rowID="")
		s objItem = ##class(EPRmeta.GlossaryItem).%OpenId(rowID)
		s strItemCode = objItem.ItemCode
		continue:((strItemCode '["ICOMPOSITESAMPLE")||(objItem.TemType'=aType)||((objItem.TemplateCode'="")&&(objItem.TemplateCode'=$C(0))))
		s intID = argArr.Find(strItemCode,"")
		continue:((intID'="")&&($C(0)'=intID))
		s sc=##class(EPRmeta.GlossaryItem).%DeleteId(rowID)
		if '(sc)
		{
			s strMark = 0
		    q
		}
	}
	if (strMark = 0)
	{
		TROLLBACK
		q strRes
	 }
	TCOMMIT
	q "1"
}

}
