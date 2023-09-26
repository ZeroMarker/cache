/// 名称:EMRservice.BL.BLEMROrganizationScheme
/// 描述:患者完整病历内容的组织方案定义服务
/// 编写者：yejian
/// 编写日期: 2014-8-16
Class EMRservice.BL.BLEMROrganizationScheme Extends (%RegisteredObject, %XML.Adaptor)
{

/// d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLEMROrganizationScheme","SelectALL")
Query SelectALL() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,SchemeCode:%String,SchemeName:%String,SchemSeq:%Integer,CreateUserID:%String,CreateDate:%Date,CreateTime:%Time,ModifyDate:%Date,ModifyTime:%Time,SchemType:%String,typeID:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_EMROrganScheme_SelectAll, SqlProc ]
{
	SELECT c.ID,c.SchemeCode,c.SchemeName,c.SchemSeq,c.CreateUserID,c.CreateDate,c.CreateTime,c.ModifyDate,c.ModifyTime,t.SchemType,t.ID as typeID
	FROM EMRmeta.EMROrganizationScheme c left join EMRmeta.EMROrganizationSchemeType t
	on c.ID = t.ParScheme ORDER BY SchemSeq
}

/// 得到最大code编号
ClassMethod GetMaxCode() As %String
{
	&sql(select max(id) into :IdexCode from EMRmeta.EMROrganizationScheme)
	s:(IdexCode="") IdexCode=0
	q IdexCode
}

/// 创建一个项目
ClassMethod CreateOrganScheme(aOrganScheme As EMRservice.entity.EEMROrganizationScheme) As %String
{
	/// b "s"	
	TSTART
	s objOrganScheme=##class(EMRmeta.EMROrganizationScheme).%New()
	q:(objOrganScheme="") ""
	s strReslt = ""	
	s objOrganScheme.SchemeCode= $case(aOrganScheme.SchemeCode,$c(0):"",:aOrganScheme.SchemeCode)
	s objOrganScheme.SchemeName=$case(aOrganScheme.SchemeName,$c(0):"",:aOrganScheme.SchemeName)
	s objOrganScheme.CreateUserID=$case(aOrganScheme.CreateUserID,$c(0):"",:aOrganScheme.CreateUserID)
	s objOrganScheme.CreateDate= $ZDATEH(aOrganScheme.CreateDate,8)
	s objOrganScheme.CreateTime=$ZTIMEH(aOrganScheme.CreateTime)
	s objOrganScheme.ModifyDate=$ZDATEH(aOrganScheme.ModifyDate,8)
	s objOrganScheme.ModifyTime=$ZTIMEH(aOrganScheme.ModifyTime)
	s objOrganScheme.SchemSeq=objOrganScheme.SchemeCode
	s sc = objOrganScheme.%Save()
	if ($$$ISOK(sc))
	{
		s strReslt = objOrganScheme.%Id()
		Set key = ""			
		do
		{ 			   
			S aOrganSchemeType = aOrganScheme.SchemType.GetNext(.key)
			q:(aOrganSchemeType="")
			s objOrganSchemeType = ##Class(EMRmeta.EMROrganizationSchemeType).%New()
			s objOrganSchemeType.SchemType = $case(aOrganSchemeType.SchemType,$c(0):"",:aOrganSchemeType.SchemType)
			s objOrganSchemeType.ParScheme = objOrganScheme
			s sc = objOrganSchemeType.%Save()
			if ('$$$ISOK(sc))
			{
			 	s strReslt = "-1"
			}
		} 
		while (key '="" )	
	}
	else
	{
		s strReslt = "-1"
	}
	if (strReslt ="-1")
	{
		 TROLLBACK
		 quit "-1"
	}
	else
	{
		TCOMMIT
		q strReslt
	}
}

/// 创建一个项目
ClassMethod CreateOrganTypeScheme(aOrganScheme As EMRservice.entity.EEMROrganizationScheme) As %String
{
	/// b "s"	
	TSTART
	s objOrganScheme=##class(EMRmeta.EMROrganizationScheme).%OpenId(aOrganScheme.ID)
	q:(objOrganScheme="") ""
	s strReslt = ""	
	s sc = objOrganScheme.%Save()
	if ($$$ISOK(sc))
	{
		s strReslt = objOrganScheme.%Id()
		Set key = ""			
		do
		{ 			   
			S aOrganSchemeType = aOrganScheme.SchemType.GetNext(.key)
			q:(aOrganSchemeType="")
			s objOrganSchemeType = ##Class(EMRmeta.EMROrganizationSchemeType).%New()
			s objOrganSchemeType.SchemType = $case(aOrganSchemeType.SchemType,$c(0):"",:aOrganSchemeType.SchemType)
			s objOrganSchemeType.ParScheme = objOrganScheme
			s sc = objOrganSchemeType.%Save()
			if ('$$$ISOK(sc))
			{
			 	s strReslt = "-1"
			}
		} 
		while (key '="" )	
	}
	else
	{
		s strReslt = "-1"
	}
	if (strReslt ="-1")
	{
		 TROLLBACK
		 quit "-1"
	}
	else
	{
		TCOMMIT
		q strReslt
	}
}

/// 更新一个项目
ClassMethod UpdateOrganScheme(aOrganScheme As EMRservice.entity.EEMROrganizationScheme) As %String
{
	/// b "s"	
	TSTART
	set objOrganScheme=##class(EMRmeta.EMROrganizationScheme).%OpenId(aOrganScheme.ID)
	q:(objOrganScheme="") ""	
	s strReslt = ""		
	s objOrganScheme.SchemeName=$case(aOrganScheme.SchemeName,$c(0):"",:aOrganScheme.SchemeName)
	s objOrganScheme.CreateUserID=$case(aOrganScheme.CreateUserID,$c(0):"",:aOrganScheme.CreateUserID)
	s objOrganScheme.ModifyDate=$ZDATEH(aOrganScheme.ModifyDate,8)
	s objOrganScheme.ModifyTime=$ZTIMEH(aOrganScheme.ModifyTime)
	s sc = objOrganScheme.%Save()
	if ($$$ISOK(sc))
	{
		s strReslt = objOrganScheme.%Id()
		Set key = ""			
		do
		{ 			   
			S aOrganSchemeType = aOrganScheme.SchemType.GetNext(.key)
			S strSchemeTypeId = aOrganScheme.ID _"||"_key
			q:(aOrganSchemeType="")
			s objOrganSchemeType = ##Class(EMRmeta.EMROrganizationSchemeType).%OpenId(strSchemeTypeId)
			s objOrganSchemeType.SchemType = $case(aOrganSchemeType.SchemType,$c(0):"",:aOrganSchemeType.SchemType)
			s objOrganSchemeType.ParScheme = objOrganScheme
			s sc = objOrganSchemeType.%Save()
			if ('$$$ISOK(sc))
			{
			 	s strReslt = "-1"
			}
		} 
		while (key '="" )	
	}
	else
	{
		s strReslt = "-1"
	}
	if (strReslt ="-1")
	{
		 TROLLBACK
		 quit "-1"
	}
	else
	{
		TCOMMIT
		q strReslt
	}
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
		s objEntity=##class(EMRmeta.EMROrganizationScheme).%OpenId(argID)
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
    s objOrganScheme = ##Class(EMRmeta.EMROrganizationScheme).%OpenId(aOrganSchemeId)
	q:(objOrganScheme="") "-1"
	s sc = ##class(EMRmeta.EMROrganizationScheme).%DeleteId(aOrganSchemeId)
	if ($$$ISOK(sc))
	{	
	   q "0"
    }
    else
    {
		q "-1"
	}
}

/// 删除一个项目
ClassMethod DeleteOrganSchemeTypeByID(aOrganSchemeId As %String) As %String
{
    q:(aOrganSchemeId ="") "-1"
    b
    s objOrganScheme = ##Class(EMRmeta.EMROrganizationSchemeType).%OpenId(aOrganSchemeId)
	q:(objOrganScheme="") "-1"
	s sc = ##class(EMRmeta.EMROrganizationSchemeType).%DeleteId(aOrganSchemeId)
	if ($$$ISOK(sc))
	{	
	   q "0"
    }
    else
    {
		q "-1"
	}
}

/// d ##Class(EMRservice.BL.BLEMROrganizationScheme).InitTest()
ClassMethod InitTest()
{
	
	s objScheme=##Class(EMRmeta.EMROrganizationScheme).%New()
	s objScheme.SchemeCode="01"
	s objScheme.SchemeName="住院病历(书写顺序)"
	s objScheme.CreateDate=+$h
	s objScheme.CreateTime=$p($h,",",2)
	s objScheme.CreateUserID="105"
	s objScheme.SchemSeq=1
	d objScheme.%Save()
	s objSchemeType=##Class(EMRmeta.EMROrganizationSchemeType).%New()
	s objSchemeType.SchemType="Running"
	s objSchemeType.ParScheme=objScheme
	d objSchemeType.%Save()
	s RowID=objScheme.%Id()
	
	s objDetails=##Class(EMRmeta.EMROrganizationSchemeDetails).%New()
	s objDetails.ParSchemeType=objSchemeType
	s objDetails.ItemCode="01"
	s objDetails.ItemName="体温单"
	s objDetails.ItemDr=""
	s objDetails.ItemSeq=1
	d objDetails.%Save()
	
	s objDetails=##Class(EMRmeta.EMROrganizationSchemeDetails).%New()
	s objDetails.ParSchemeType=objSchemeType
	s objDetails.ItemCode="02"
	s objDetails.ItemName="诊断列表"
	s objDetails.ItemDr=""
	s objDetails.ItemSeq=2
	Do objDetails.%Save()

	s objDetails=##Class(EMRmeta.EMROrganizationSchemeDetails).%New()
	s objDetails.ParSchemeType=objSchemeType
	s objDetails.ItemCode="03"
	s objDetails.ItemName="医嘱单"
	s objDetails.ItemDr=""
	s objDetails.ItemSeq=3
	Do objDetails.%Save()

	s objDetails=##Class(EMRmeta.EMROrganizationSchemeDetails).%New()
	s objDetails.ParSchemeType=objSchemeType
	s objDetails.ItemCode="04"
	s objDetails.ItemName="病历书写"
	s objDetails.ItemDr=""
	s objDetails.ItemSeq=4
	Do objDetails.%Save()
	
	s objDetails=##Class(EMRmeta.EMROrganizationSchemeDetails).%New()
	s objDetails.ParSchemeType=objSchemeType
	s objDetails.ItemCode="05"
	s objDetails.ItemName="病历书写"
	s objDetails.ItemDr=""
	s objDetails.ItemSeq=5
	Do objDetails.%Save()
	
	s objDetails=##Class(EMRmeta.EMROrganizationSchemeDetails).%New()
	s objDetails.ParSchemeType=objSchemeType
	s objDetails.ItemCode="05"
	s objDetails.ItemName="病历书写"
	s objDetails.ItemDr=""
	s objDetails.ItemSeq=6
	Do objDetails.%Save()
}

/// 删除一个数据元范畴
/// d ##Class(EMRservice.BL.BLEMROrganizationScheme).test()
ClassMethod test() As %String
{
	s OrganScheme = ##Class(EMRservice.entity.EEMROrganizationScheme).%New()
	s OrganScheme.SchemeCode= "2"
	s OrganScheme.SchemeName="方案1"
	S OrganScheme.ID = "1"
	s OrganScheme.CreateUserID="admin"
	s OrganScheme.CreateDate= "2014-9-2"
	s OrganScheme.CreateTime="21:07"
	s OrganScheme.ModifyDate="2014-9-2"
	s OrganScheme.ModifyTime="21:07"
	s OrganScheme.SchemSeq=objOrganScheme.SchemeCode
	s SchemeType = ##Class(EMRservice.entity.EEMROrganizationSchemeType).%New()
	s SchemeType.SchemType = "Running"
	s SchemeType.ParScheme = OrganScheme
	d ..CreateOrganScheme(OrganScheme)
}

}
