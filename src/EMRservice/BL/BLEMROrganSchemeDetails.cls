/// 名称:EMRservice.BL.BLEMROrganizationSchemeDetails
/// 描述:患者完整病历内容的组织方案明细服务
/// 编写者：yejian
/// 编写日期: 2014-9-2
Class EMRservice.BL.BLEMROrganSchemeDetails Extends (%RegisteredObject, %XML.Adaptor)
{

/// d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLEMROrganizationSchemeDetails","SelectAllDetails","12||1")
Query SelectAllDetails(aTypeID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,ItemDr:%String,ItemCode:%String,ItemName:%String,ItemSeq:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_EMRDETAILS_SelectALLDetails, SqlProc ]
{
    SELECT t.ID,t.ItemDr,t.ItemCode,t.ItemName,t.ItemSeq
    FROM EMRmeta.EMROrganizationSchemeType c right join EMRmeta.EMROrganizationSchemeDetails t
    on c.ID = t.ParSchemeType
    WHERE c.ID = :aTypeID
    ORDER BY t.ItemSeq
}

/*
/// Creator:	yejian
/// CreatDate:  2014-5-13
/// Desc:		获取所有配置信息
/// Input：		
/// Return：	dataset
/// Debug:		d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLEMROrganSchemeDetails","SelectAllDetails","12||1")
Query SelectAllDetails(aTypeID As %String) As %Query(ROWSPEC = "RowID:%String,ItemDr:%String,ItemCode:%String,ItemName:%String,ItemSeq:%Integer")
{
}

ClassMethod SelectAllDetailsExecute(ByRef qHandle As %Binary,aTypeID As %String) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	s objSchemeType = ##Class(EMRmeta.EMROrganizationSchemeType).%OpenId(aTypeID)
	q:(objSchemeType="")
	Set key = ""
	do
	{ 
		S objSchemeDetails = objSchemeType.Details.GetNext(.key)
		if (objSchemeDetails '= "")
		{

			s strID = $ZSTRIP(objSchemeDetails.%Id(),"*C")
			s strItemDr = $ZSTRIP(objSchemeDetails.ItemDr,"*C")
			s strItemCode = $ZSTRIP(objSchemeDetails.ItemCode,"*C")
			s strItemName = $ZSTRIP(objSchemeDetails.ItemName,"*C")
			s strItemSeq =$ZSTRIP(objSchemeDetails.ItemSeq,"*C")
			s Data = $lb(strID,strItemDr,strItemCode,strItemName,strItemSeq)
			s ^CacheTemp(repid,ind) = Data
			s ind = ind + 1
		}
	} 
	while (key '="" )
	q $$$OK
}

ClassMethod SelectAllDetailsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectAllDetailsExecute ]
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

ClassMethod SelectAllDetailsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectAllDetailsExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}
*/
/// 得到最大code编号
ClassMethod GetMaxCode() As %String
{
	&sql(select max(id) into :IdexCode from EMRmeta.EMROrganizationSchemeDetails)
	s:(IdexCode="") IdexCode=0
	q IdexCode
}

/// 创建一个项目
ClassMethod CreateSchemeDetails(aTypeID As %String, aOrganSchemeDetails As EMRservice.entity.EEMROrganSchemeDetails) As %String
{
	/// b "s"
	s strReslt = "-1"	
	q:(aTypeID="") strReslt	
	s objOrganSchemeType=##class(EMRmeta.EMROrganizationSchemeType).%OpenId(aTypeID)
	q:(objOrganSchemeType="") ""
	
	s objSchemeDetails = ##Class(EMRmeta.EMROrganizationSchemeDetails).%New()
	s objSchemeDetails.ItemDr = $case(aOrganSchemeDetails.ItemDr,$c(0):"",:aOrganSchemeDetails.ItemDr)
	s objSchemeDetails.ItemCode = $case(aOrganSchemeDetails.ItemCode,$c(0):"",:aOrganSchemeDetails.ItemCode)
	s objSchemeDetails.ItemName = $case(aOrganSchemeDetails.ItemName,$c(0):"",:aOrganSchemeDetails.ItemName)
	s objSchemeDetails.ItemSeq = $case(aOrganSchemeDetails.ItemSeq,$c(0):"",:aOrganSchemeDetails.ItemSeq)
	s ^CreateSchemeDetails("ItemSeq")=objSchemeDetails.ItemSeq
	s objSchemeDetails.ParSchemeType = objOrganSchemeType
	s sc = objSchemeDetails.%Save()
	if ($$$ISOK(sc))
	{
	   s strReslt = objSchemeDetails.%Id()
	}
	else
	{
		s strReslt = "-1"	
	}
	q strReslt
}

/// 更新一个项目
ClassMethod UpdateSchemeDetails(aOrganSchemeDetails As EMRservice.entity.EEMROrganSchemeDetails) As %String
{
	/// b "s"	
	s strReslt = "-1"
	set objSchemeDetails=##class(EMRmeta.EMROrganizationSchemeDetails).%OpenId(aOrganSchemeDetails.ID)
	q:(objSchemeDetails="") ""	
	s objSchemeDetails.ItemDr = $case(aOrganSchemeDetails.ItemDr,$c(0):"",:aOrganSchemeDetails.ItemDr)
	s objSchemeDetails.ItemCode = $case(aOrganSchemeDetails.ItemCode,$c(0):"",:aOrganSchemeDetails.ItemCode)
	s objSchemeDetails.ItemName = $case(aOrganSchemeDetails.ItemName,$c(0):"",:aOrganSchemeDetails.ItemName)
	s objSchemeDetails.ItemSeq = $case(aOrganSchemeDetails.ItemSeq,$c(0):0,:aOrganSchemeDetails.ItemSeq)
	
	s sc = objSchemeDetails.%Save()
	if ($$$ISOK(sc))
	{
	   s strReslt = objSchemeDetails.%Id()
	}
	else
	{
		s strReslt = "-1"	
	}
	q strReslt
}

/// 更新一个数据元范畴
/// w ##Class(EMRservice.BL.BLEMROrganSchemeDetails).UpdateSequences("13||1||24^2,13||1||27^24")
ClassMethod UpdateSequences(argStr As %String) As %String
{
	 S IDCount =$L(argStr,",")
	 S strMrk= 1
	 TSTART 
	 For I=1:1:IDCount
	 {
		S argstrItem= $P(argStr,",",I)
		S argID = $P(argstrItem,"^",1)
		S argSeq = $P(argstrItem,"^",2)
		if ($d(argID)=0)||($d(argSeq)=0)||(argID="")||(argSeq="")
		{
			TROLLBACK
			s strMrk = 0
			quit
		}
		s objEntity="",result=""
		s objEntity=##class(EMRmeta.EMROrganizationSchemeDetails).%OpenId(argID)
		if (objEntity ="")
		{
			TROLLBACK
			s strMrk = 0
			quit
		}	
		s objEntity.ItemSeq=argSeq
		s result=""
		if '(objEntity.%Save())
		{
			TROLLBACK
			s strMrk = 0
		    quit
		}
	 }
	 if (strMrk = 0)
	 {
		 TROLLBACK
		 quit 0
	 }
	TCOMMIT
	Quit 1
}

/// 删除一个项目
ClassMethod DeleteSchemeDetailsByID(aSchemeDetailsId As %String) As %String
{
    q:(aSchemeDetailsId ="") "-1"
    b
    s objSchemeDetails = ##Class(EMRmeta.EMROrganizationSchemeDetails).%OpenId(aSchemeDetailsId)
	q:(objSchemeDetails="") "-1"
	s sc = ##class(EMRmeta.EMROrganizationSchemeDetails).%DeleteId(aSchemeDetailsId)
	if ($$$ISOK(sc))
	{	
	   q "0"
    }
    else
    {
		q "-1"
	}
}

/// 删除一个数据元范畴
/// d ##Class(EMRservice.BL.BLEMROrganSchemeDetails).test()
ClassMethod test() As %String
{
	
	s OrganScheme = ##Class(EMRservice.entity.EEMROrganSchemeDetails).%New()
	s OrganScheme.ItemDr= 32
	s OrganScheme.ItemCode="32"
	S OrganScheme.ItemName = "检验报告"
	s OrganScheme.ItemSeq=32
	d ..CreateSchemeDetails("12||1",OrganScheme)
}

}
