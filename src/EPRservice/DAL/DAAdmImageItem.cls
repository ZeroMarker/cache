/// 描述：患者就诊图片相关数据获取
/// 创建者：HouJian
/// 创建日期：2011-09-26
Class EPRservice.DAL.DAAdmImageItem Extends %RegisteredObject [ ProcedureBlock ]
{

/// Desc:	创建患者就诊图片记录
ClassMethod Create(AEAdmImageItem As EPRservice.entity.EAdmImageItem) As %String
{
	s objAdmImageItemID = "0"
	
	s objAdmImageItem = ##Class(EPRinstance.AdmImageItem).%New()
	s objAdmImageItem.EpisodeID = AEAdmImageItem.EpisodeID
	s objAdmImageItem.Name = AEAdmImageItem.Name
	s objAdmImageItem.Description = AEAdmImageItem.Description
	s objAdmImageItem.CreateDate = AEAdmImageItem.CreateDate
	s objAdmImageItem.CreateTime = AEAdmImageItem.CreateTime
	s objAdmImageItem.Status = AEAdmImageItem.Status
	s objAdmImageItem.IsPublish = AEAdmImageItem.IsPublish
	d objAdmImageItem.ImageData.CopyFrom(AEAdmImageItem.ImageData)
	d objAdmImageItem.HotSpotData.CopyFrom(AEAdmImageItem.HotSpotData)
	d objAdmImageItem.IconData.CopyFrom(AEAdmImageItem.IconData)
	if (objAdmImageItem.%Save() = "1")
	{
		s objAdmImageItemID = objAdmImageItem.%Id()
	}
	
	//销毁对象
	s objAdmImageItem = ""
	
	q objAdmImageItemID
}

/// Desc：	获取患者就诊图片实体对象
ClassMethod GetEntity(AAdmIamgeItemID As %String) As EPRservice.entity.EAdmImageItem
{
	s objAdmIamgeItem = ##Class(EPRinstance.AdmImageItem).%OpenId(AAdmIamgeItemID)
	q:(objAdmIamgeItem = "") ""
	
	s eAdmImageItem = ##Class(EPRservice.entity.EAdmImageItem).%New()
	s eAdmImageItem.ID = objAdmIamgeItem.%Id()
	s eAdmImageItem.EpisodeID = objAdmIamgeItem.EpisodeID
	s eAdmImageItem.Name = objAdmIamgeItem.Name
	s eAdmImageItem.Description = objAdmIamgeItem.Description
	s eAdmImageItem.CreateDate = objAdmIamgeItem.CreateDate
	s eAdmImageItem.CreateTime = objAdmIamgeItem.CreateTime
	s eAdmImageItem.Status = objAdmIamgeItem.Status
	s eAdmImageItem.IsPublish = objAdmIamgeItem.IsPublish
	d eAdmImageItem.ImageData.CopyFrom(objAdmIamgeItem.ImageData)
	d eAdmImageItem.HotSpotData.CopyFrom(objAdmIamgeItem.HotSpotData)
	d eAdmImageItem.IconData.CopyFrom(objAdmIamgeItem.IconData)
	
	//销毁对象
	s objAdmIamgeItem = ""
	
	q eAdmImageItem
}

/// Desc:	更新患者就诊图片记录
ClassMethod Update(AEAdmImageItem As EPRservice.entity.EAdmImageItem) As %Boolean
{
	s updateFlag = "0"
	
	q:(AEAdmImageItem.ID = "") updateFlag
	
	s objAdmImageItem = ##Class(EPRinstance.AdmImageItem).%OpenId(AEAdmImageItem.ID)
	q:(objAdmImageItem = "") updateFlag
	
	s objAdmImageItem.EpisodeID = AEAdmImageItem.EpisodeID
	s objAdmImageItem.Name = AEAdmImageItem.Name
	s objAdmImageItem.Description = AEAdmImageItem.Description
	//s objAdmImageItem.CreateDate = AEAdmImageItem.CreateDate
	//s objAdmImageItem.CreateTime = AEAdmImageItem.CreateTime
	s objAdmImageItem.Status = AEAdmImageItem.Status
	s objAdmImageItem.IsPublish = AEAdmImageItem.IsPublish
	d objAdmImageItem.ImageData.CopyFrom(AEAdmImageItem.ImageData)
	d objAdmImageItem.HotSpotData.CopyFrom(AEAdmImageItem.HotSpotData)
	d objAdmImageItem.IconData.CopyFrom(AEAdmImageItem.IconData)
	if (objAdmImageItem.%Save() = "1")
	{
		s updateFlag = "1"
	}
	
	//销毁对象
	s objAdmImageItem = ""
	
	q updateFlag
}

/// Desc:	删除患者就诊图片记录
ClassMethod Delete(AAdmImageItemID As %String) As %Boolean
{
	q:(AAdmImageItemID = "") "0"
	&sql(DELETE FROM EPRinstance.AdmImageItem WHERE ID = :AAdmImageItemID)
	q "1"
}

/// Debug:	d ##Class(%ResultSet).RunQuery("EPRservice.DAL.DAAdmImageItem","GetByEpisodeID","201871")
Query GetByEpisodeID(AEpisodeID As %String) As %SQLQuery(CONTAINID = 0, ROWSPEC = "ID:%String,Name:%String,Description:%String,CreateDate:%String,CreateTime:%String,Status:%String,IsPublish:%String")
{
	SELECT ID, Name, Description, TO_DATE(CreateDate,'YYYY-MM-DD') As CreateDate, {fn CONVERT(CreateTime,SQL_TIME)} As CreateTime,Status,IsPublish
	FROM EPRinstance.AdmImageItem
	WHERE EpisodeID = :AEpisodeID
	ORDER BY ID
}

}
