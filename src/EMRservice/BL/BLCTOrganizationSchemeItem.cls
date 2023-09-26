/// 名称：		EMRservice.BL.BLCTOrganizationSchemeItem
/// 描述：		方案项目BL层
/// 编写者：	yejian
/// 编写时间：	2014-8-28
Class EMRservice.BL.BLCTOrganizationSchemeItem Extends (%RegisteredObject, %XML.Adaptor)
{

/// 	获取所有项目
Query SelectALL() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,ItemCode:%String,ItemName:%String,EMRTemplateCategoryID:%String,ItemTitle:%String,ItemURL:%String,ItemParas:%String,StartDate:%Date,StartTime:%Time,EndDate:%Date,EndTime:%Time,imagePath:%String,ItemType:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_EMR_CTOrgan_SelectAll, SqlProc ]
{
	select ID,ItemCode,ItemName,EMRTemplateCategoryID,ItemTitle,ItemURL,ItemParas,StartDate,StartTime,EndDate,EndTime,imagePath,ItemType
	from EMRmeta.CTOrganizationSchemeItem
}

/// 	获取所有项目类型
Query SelectALLType() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,TypeName:%String,TypeDescription:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_EMR_CTOrgan_SelectALLType, SqlProc ]
{
	select ID,TypeName,TypeDescription
	from EMRmeta.CTOrganizationItemTypes
}

/// 得到最大code编号
ClassMethod GetMaxCode() As %String
{
	//s IdexCode=0
	&sql(select max(id) into :IdexCode   from EMRmeta.CTOrganizationSchemeItem)
	s:(IdexCode="") IdexCode=0
	q IdexCode
}

/// 创建一个项目
ClassMethod CreateItem(aECTOrganItem As EMRservice.entity.ECTOrganizationSchemeItem) As %String
{
	/// b "s"	
	s objItem=##class(EMRmeta.CTOrganizationSchemeItem).%New()
	q:(objItem="") ""	
	s objItem.ItemCode=$case(aECTOrganItem.ItemCode,$c(0):"",:aECTOrganItem.ItemCode)
	s objItem.ItemName=$case(aECTOrganItem.ItemName,$c(0):"",:aECTOrganItem.ItemName)
	s objItem.EMRTemplateCategoryID=$case(aECTOrganItem.EMRTemplateCategoryID,$c(0):"",:aECTOrganItem.EMRTemplateCategoryID)
	s objItem.ItemTitle=$case(aECTOrganItem.ItemTitle,$c(0):"",:aECTOrganItem.ItemTitle)
	s objItem.ItemURL=$case(aECTOrganItem.ItemURL,$c(0):"",:aECTOrganItem.ItemURL)
	s objItem.ItemParas=$case(aECTOrganItem.ItemParas,$c(0):"",:aECTOrganItem.ItemParas)
	if (aECTOrganItem.StartDate ="")||(aECTOrganItem.StartDate=$c(0))
	{
		s objItem.StartDate = $P($h,",",1)
	}
	else
	{
		s objItem.StartDate= $ZDATEH(aECTOrganItem.StartDate,8)
	}
	if (aECTOrganItem.StartTime ="")||(aECTOrganItem.StartTime=$c(0))
	{
		s objItem.StartTime = $P($h,",",2)
	}
	else
	{
		s objItem.StartTime= $ZTIMEH(aECTOrganItem.StartTime)
	}
	if (aECTOrganItem.EndDate ="")||(aECTOrganItem.EndDate=$c(0))
	{
		s objItem.EndDate = $P($h,",",1)
	}
	else
	{
		s objItem.EndDate=$ZDATEH(aECTOrganItem.EndDate,8)
	}
	if (aECTOrganItem.EndTime ="")||(aECTOrganItem.EndTime=$c(0))
	{
		s objItem.EndTime = $P($h,",",2)
	}
	else
	{
		s objItem.EndTime=$ZTIMEH(aECTOrganItem.EndTime)
	}
	s objItem.imagePath=$case(aECTOrganItem.imagePath,$c(0):"",:aECTOrganItem.imagePath)
	s objItem.ItemType=$case(aECTOrganItem.ItemType,$c(0):"",:aECTOrganItem.ItemType)
	s sc = objItem.%Save()
	if ($$$ISOK(sc))
	{		
		 q objItem.%Id()
	}
	else
	{
		 q "-1"	
	}
}

/// 更新一个项目
ClassMethod UpdateItem(aECTOrganItem As EMRservice.entity.ECTOrganizationSchemeItem) As %String
{
	/// b "s"	
	set objItem=##class(EMRmeta.CTOrganizationSchemeItem).%OpenId(aECTOrganItem.ID)
	q:(objItem="") ""	
	s objItem.ItemCode=$case(aECTOrganItem.ItemCode,$c(0):"",:aECTOrganItem.ItemCode)
	s objItem.ItemName=$case(aECTOrganItem.ItemName,$c(0):"",:aECTOrganItem.ItemName)
	s objItem.EMRTemplateCategoryID=$case(aECTOrganItem.EMRTemplateCategoryID,$c(0):"",:aECTOrganItem.EMRTemplateCategoryID)
	s objItem.ItemTitle=$case(aECTOrganItem.ItemTitle,$c(0):"",:aECTOrganItem.ItemTitle)
	s objItem.ItemURL=$case(aECTOrganItem.ItemURL,$c(0):"",:aECTOrganItem.ItemURL)
	s objItem.ItemParas=$case(aECTOrganItem.ItemParas,$c(0):"",:aECTOrganItem.ItemParas)
	if (aECTOrganItem.EndDate ="")||(aECTOrganItem.EndDate=$c(0))
	{
		s objItem.EndDate = $P($h,",",1)
	}
	else
	{
		s objItem.EndDate=$ZDATEH(aECTOrganItem.EndDate,8)
	}
	if (aECTOrganItem.EndTime ="")||(aECTOrganItem.EndTime=$c(0))
	{
		s objItem.EndTime = $P($h,",",2)
	}
	else
	{
		s objItem.EndTime=$ZTIMEH(aECTOrganItem.EndTime)
	}
	s objItem.imagePath=$case(aECTOrganItem.imagePath,$c(0):"",:aECTOrganItem.imagePath)
	s objItem.ItemType=$case(aECTOrganItem.ItemType,$c(0):"",:aECTOrganItem.ItemType)
	s sc = objItem.%Save()
	if ($$$ISOK(sc))
	{		
		 q objItem.%Id()
	}
	else
	{
		 q "-1"	
	}
}

/// 删除一个项目
ClassMethod DeleteItemByID(aECTOrganItemId As %String) As %String
{
    q:(aECTOrganItemId ="") "-1"
    b
    s objItem = ##Class(EMRmeta.CTOrganizationSchemeItem).%OpenId(aECTOrganItemId)
	q:(objItem="") "-1"
	s sc = ##class(EMRmeta.CTOrganizationSchemeItem).%DeleteId(aECTOrganItemId)
	if ($$$ISOK(sc))
	{	
	   q "0"
    }
    else
    {
		q "-1"
	}
}

/// d ##Class(EMRservice.BL.BLCTOrganizationSchemeItem).IniData()
ClassMethod IniData()
{
	&sql(delete from EMRmeta.CTOrganizationItemTypes)
 
	s obj=##Class(EMRmeta.CTOrganizationItemTypes).%New()
	s obj.TypeName="EMR",obj.TypeDescription="EMR"
    d obj.%Save()    	
   
    s obj=##Class(EMRmeta.CTOrganizationItemTypes).%New()
	s obj.TypeName="HIS",obj.TypeDescription="HIS"
    d obj.%Save()
}

/// d ##Class(EMRservice.BL.BLCTOrganizationSchemeItem).Test()
ClassMethod Test()
{
	s objItem = ##Class(EMRservice.entity.ECTOrganizationSchemeItem).%New()
	s objItem.ID="16"
	s objItem.ItemCode="4"
	s objItem.ItemName="诊断"
	s objItem.EMRTemplateCategoryID= ""
	s objItem.ItemTitle="诊断"
	s objItem.ItemURL="websys.csp"
	s objItem.ItemParas="PatientID=[patientID]&EpisodeID=[episodeID]&EpisodeIDs=&mradm=[mradm]&ChartID=137&PAAdmTransactionID=&OperRoomID=&DischID=&CurrDischID=&DischEpisodes=&doctype=&TWKFL=50086&TWKFLI=&copyOeoris=&copyTo="
	s objItem.StartDate=""
	s objItem.StartTime="11:57:00"
	s objItem.EndDate="2014-8-30"
	s objItem.EndTime="10:42"
	s objItem.imagePath= ""
	d ##Class(EMRservice.BL.BLCTOrganizationSchemeItem).CreateItem(objItem)
}

}
