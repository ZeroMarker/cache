/// 名称:EMRservice.BL.BLEMRNavigationSchemeItem
/// 描述:患者完整病历内容的组织方案明细服务
/// 编写者：yejian
/// 编写日期: 2016-5-17
Class EMRservice.BL.BLEMRNavigationSchemeItem Extends (%RegisteredObject, %XML.Adaptor)
{

/// d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLEMRNavigationSchemeItem","SelectAllDetails","12||1")
Query SelectAllDetails(aSchemeCode As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,SchemeCode:%String,ItemDr:%String,ItemCode:%String,ItemName:%String,ItemSeq:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_EMRITEMS_SelectALLDetails, SqlProc ]
{
    SELECT t.ID,t.SchemeCode,t.ItemDr,t.ItemCode,t.ItemName,t.ItemSeq
    FROM EMRmeta.EMRNavigationSchemeItem t
    WHERE t.SchemeCode = :aSchemeCode
    ORDER BY t.ItemSeq
}

/// 得到最大code编号
ClassMethod GetMaxCode() As %String
{
	&sql(select max(id) into :IdexCode from EMRmeta.EMRNavigationSchemeItem)
	s:(IdexCode="") IdexCode=0
	q IdexCode
}

/// 创建一个项目
ClassMethod CreateSchemeDetails(aOrganSchemeDetails As EMRservice.entity.EEMRNavigationSchemeItem) As %String
{
	/// b "s"
	s strReslt = "-1"	
	
	s objSchemeDetails = ##Class(EMRmeta.EMRNavigationSchemeItem).%New()
	S objSchemeDetails.SchemeCode = $case(aOrganSchemeDetails.SchemeCode,$c(0):"",:aOrganSchemeDetails.SchemeCode)
	s objSchemeDetails.ItemDr = $case(aOrganSchemeDetails.ItemDr,$c(0):"",:aOrganSchemeDetails.ItemDr)
	s objSchemeDetails.ItemCode = $case(aOrganSchemeDetails.ItemCode,$c(0):"",:aOrganSchemeDetails.ItemCode)
	s objSchemeDetails.ItemName = $case(aOrganSchemeDetails.ItemName,$c(0):"",:aOrganSchemeDetails.ItemName)
	s objSchemeDetails.ItemSeq = $case(aOrganSchemeDetails.ItemSeq,$c(0):"",:aOrganSchemeDetails.ItemSeq)
	s sc = objSchemeDetails.%Save()
	if ($$$ISOK(sc))
	{
	   s strReslt = objSchemeDetails.%Id()
	   s sc = ##Class(EMRservice.BL.BLEMRNavigationSchemeItemSeq).CreateSchemeItemSeq(strReslt)
	}
	else
	{
		s strReslt = "-1"	
	}
	q strReslt
}

/// 更新一个项目
ClassMethod UpdateSchemeDetails(aOrganSchemeDetails As EMRservice.entity.EEMRNavigationSchemeItem) As %String
{
	/// b "s"	
	s strReslt = "-1"
	set objSchemeDetails=##class(EMRmeta.EMRNavigationSchemeItem).%OpenId(aOrganSchemeDetails.ID)
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
		s objEntity=##class(EMRmeta.EMRNavigationSchemeItem).%OpenId(argID)
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
    s objSchemeDetails = ##Class(EMRmeta.EMRNavigationSchemeItem).%OpenId(aSchemeDetailsId)
	q:(objSchemeDetails="") "-1"
	s sc = ##class(EMRmeta.EMRNavigationSchemeItem).%DeleteId(aSchemeDetailsId)
	if ($$$ISOK(sc))
	{	
	   s sc = ##class(EMRservice.BL.BLEMRNavigationSchemeItemSeq).DeleteSchemeItemSeqByID(aSchemeDetailsId)
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
	
	s OrganScheme = ##Class(EMRservice.entity.EEMRNavigationSchemeItem).%New()
	s OrganScheme.ItemDr= 32
	s OrganScheme.ItemCode="32"
	S OrganScheme.ItemName = "检验报告"
	s OrganScheme.ItemSeq=32
	d ..CreateSchemeDetails("12||1",OrganScheme)
}

}
