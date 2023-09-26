/// 名称:EMRservice.BL.BLEMRNavigationScheme
/// 描述:患者完整病历内容的组织方案定义服务
/// 编写者：yejian
/// 编写日期: 2016-5-17
Class EMRservice.BL.BLEMRNavigationScheme Extends (%RegisteredObject, %XML.Adaptor)
{

/// d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLEMRNavigationScheme","SelectALL")
Query SelectALL() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,SchemeCode:%String,SchemeName:%String,SchemSeq:%Integer,CreateUserID:%String,CreateDate:%Date,CreateTime:%Time,modifyUser:%String,ModifyDate:%Date,ModifyTime:%Time", SELECTMODE = "RUNTIME") [ SqlName = SP_EMRNavigationScheme_SelectAll, SqlProc ]
{
	SELECT c.ID,c.SchemeCode,c.SchemeName,c.SchemSeq,c.CreateUserID,c.CreateDate,c.CreateTime,c.modifyUser,c.ModifyDate,c.ModifyTime
	FROM EMRmeta.EMRNavigationScheme c ORDER BY c.SchemSeq
}

/// 得到最大code编号
ClassMethod CheckCode(aCode As %String) As %String
{
	&sql(select max(id) into :IdexCode from EMRmeta.EMRNavigationScheme where SchemeCode = :aCode)
	s:(IdexCode="") IdexCode=0
	q IdexCode
}

/// 创建一个项目
ClassMethod CreateOrganScheme(aOrganScheme As EMRservice.entity.EEMRNavigationScheme) As %String
{
	/// b "s"	
	s objNavigationScheme=##class(EMRmeta.EMRNavigationScheme).%New()
	q:(objNavigationScheme="") ""
	s strReslt = ""	
	s objNavigationScheme.SchemeCode= $case(aOrganScheme.SchemeCode,$c(0):"",:aOrganScheme.SchemeCode)
	s objNavigationScheme.SchemeName=$case(aOrganScheme.SchemeName,$c(0):"",:aOrganScheme.SchemeName)
	s objNavigationScheme.CreateUserID=$case(aOrganScheme.CreateUserID,$c(0):"",:aOrganScheme.CreateUserID)
	s objNavigationScheme.CreateDate= $ZDATEH(aOrganScheme.CreateDate,8)
	s objNavigationScheme.CreateTime=$ZTIMEH(aOrganScheme.CreateTime)
	s objNavigationScheme.modifyUser = $case(aOrganScheme.modifyUser,$c(0):"",:aOrganScheme.modifyUser)
	s objNavigationScheme.ModifyDate=$ZDATEH(aOrganScheme.ModifyDate,8)
	s objNavigationScheme.ModifyTime=$ZTIMEH(aOrganScheme.ModifyTime)
	s objNavigationScheme.SchemSeq=aOrganScheme.SchemSeq
	s sc = objNavigationScheme.%Save()
	s ^globCreateorganscheme = aOrganScheme.SchemSeq
	if ($$$ISOK(sc))
	{
		s strReslt = objNavigationScheme.%Id()
	}
	else
	{
		s strReslt = "-1"
	}
	q strReslt
}

/// 更新一个项目
ClassMethod UpdateOrganScheme(aOrganScheme As EMRservice.entity.EEMRNavigationScheme) As %String
{
	/// b "s"	
	set objNavigationScheme=##class(EMRmeta.EMRNavigationScheme).%OpenId(aOrganScheme.ID)
	q:(objNavigationScheme="") ""	
	s strReslt = ""		
	s objNavigationScheme.SchemeCode= $case(aOrganScheme.SchemeCode,$c(0):"",:aOrganScheme.SchemeCode)
	s objNavigationScheme.SchemeName=$case(aOrganScheme.SchemeName,$c(0):"",:aOrganScheme.SchemeName)
	s objNavigationScheme.modifyUser = $case(aOrganScheme.modifyUser,$c(0):"",:aOrganScheme.modifyUser)
	s objNavigationScheme.ModifyDate=$ZDATEH(aOrganScheme.ModifyDate,8)
	s objNavigationScheme.ModifyTime=$ZTIMEH(aOrganScheme.ModifyTime)
	s objNavigationScheme.SchemSeq=aOrganScheme.SchemSeq
	s sc = objNavigationScheme.%Save()
	if ($$$ISOK(sc))
	{
		s strReslt = objNavigationScheme.%Id()
	
	}
	else
	{
		s strReslt = "-1"
	}
	q strReslt
}

/// 更新一个数据元范畴
ClassMethod UpdateSequences(argStr As %String) As %String
{
	 S IDCount =$L(argStr,",")
	 S strMrk= 1
	 TSTART 
	 For I=1:1:IDCount
	 {
		B
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
		s objEntity=##class(EMRmeta.EMRNavigationScheme).%OpenId(argID)
		if (objEntity ="")
		{
			TROLLBACK
			s strMrk = 0
			quit
		}	
		s objEntity.SchemSeq=argSeq
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
ClassMethod DeleteOrganSchemeByID(aOrganSchemeId As %String) As %String
{
    q:(aOrganSchemeId ="") "-1"
    b
    s objNavigationScheme = ##Class(EMRmeta.EMRNavigationScheme).%OpenId(aOrganSchemeId)
	q:(objNavigationScheme="") "-1"
	s sc = ##class(EMRmeta.EMRNavigationScheme).%DeleteId(aOrganSchemeId)
	if ($$$ISOK(sc))
	{	
	   q "0"
    }
    else
    {
		q "-1"
	}
}

/// d ##Class(EMRservice.BL.BLEMRNavigationScheme).InitTest()
ClassMethod InitTest()
{
	
	s objScheme=##Class(EMRmeta.EMRNavigationScheme).%New()
	s objScheme.SchemeCode="01"
	s objScheme.SchemeName="住院病历(书写顺序)"
	s objScheme.CreateDate=+$h
	s objScheme.CreateTime=$p($h,",",2)
	s objScheme.CreateUserID="105"
	s objScheme.SchemSeq=1
	d objScheme.%Save()
	s RowID=objScheme.%Id()
	
	s objDetails=##Class(EMRmeta.EMRNavigationSchemeItem).%New()
	s objDetails.ParSchemeType=objSchemeType
	s objDetails.ItemCode="01"
	s objDetails.ItemName="体温单"
	s objDetails.ItemDr=""
	s objDetails.ItemSeq=1
	d objDetails.%Save()
	
	s objDetails=##Class(EMRmeta.EMRNavigationSchemeItem).%New()
	s objDetails.ParSchemeType=objSchemeType
	s objDetails.ItemCode="02"
	s objDetails.ItemName="诊断列表"
	s objDetails.ItemDr=""
	s objDetails.ItemSeq=2
	Do objDetails.%Save()

	s objDetails=##Class(EMRmeta.EMRNavigationSchemeItem).%New()
	s objDetails.ParSchemeType=objSchemeType
	s objDetails.ItemCode="03"
	s objDetails.ItemName="医嘱单"
	s objDetails.ItemDr=""
	s objDetails.ItemSeq=3
	Do objDetails.%Save()

	s objDetails=##Class(EMRmeta.EMRNavigationSchemeItem).%New()
	s objDetails.ParSchemeType=objSchemeType
	s objDetails.ItemCode="04"
	s objDetails.ItemName="病历书写"
	s objDetails.ItemDr=""
	s objDetails.ItemSeq=4
	Do objDetails.%Save()
	
	s objDetails=##Class(EMRmeta.EMRNavigationSchemeItem).%New()
	s objDetails.ParSchemeType=objSchemeType
	s objDetails.ItemCode="05"
	s objDetails.ItemName="病历书写"
	s objDetails.ItemDr=""
	s objDetails.ItemSeq=5
	Do objDetails.%Save()
	
	s objDetails=##Class(EMRmeta.EMRNavigationSchemeItem).%New()
	s objDetails.ParSchemeType=objSchemeType
	s objDetails.ItemCode="05"
	s objDetails.ItemName="病历书写"
	s objDetails.ItemDr=""
	s objDetails.ItemSeq=6
	Do objDetails.%Save()
}

/// 删除一个数据元范畴
/// d ##Class(EMRservice.BL.BLEMRNavigationScheme).test()
ClassMethod test() As %String
{
	s objNavigationScheme = ##Class(EMRservice.entity.EEMRNavigationScheme).%New()
	s objNavigationScheme.SchemeCode= "2"
	s objNavigationScheme.SchemeName="方案1"
	S objNavigationScheme.ID = "1"
	s objNavigationScheme.CreateUserID="admin"
	s objNavigationScheme.CreateDate= "2014-9-2"
	s objNavigationScheme.CreateTime="21:07"
	s objNavigationScheme.modifyUser="admin1"
	s objNavigationScheme.ModifyDate="2014-9-2"
	s objNavigationScheme.ModifyTime="21:07"
	s objNavigationScheme.SchemSeq=objNavigationScheme.SchemeCode
	d ..CreateOrganScheme(objNavigationScheme)
}

}
