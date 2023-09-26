/// 名称：		EMRservice.BL.BLEMRTemplateGroupItem
/// 描述：		病历分组BL层
/// 编写者：	yejian
/// 编写时间：	2016-5-17
Class EMRservice.BL.BLEMRTemplateGroupItem Extends (%RegisteredObject, %XML.Adaptor)
{

/// d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLEMRTemplateGroupItem","SelectALLGroup")
Query SelectALLGroup() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,TemplateGroupCode:%String,TemplateGroupName:%String,TemplateSeq:%Integer,CreateUserID:%String,CreateDate:%Date,CreateTime:%Time,ModifyUser:%String,ModifyDate:%Date,ModifyTime:%Time", SELECTMODE = "RUNTIME") [ SqlName = SP_SelectALLGroup_SelectAll, SqlProc ]
{
	SELECT c.ID,c.TemplateGroupCode,c.TemplateGroupName,c.TemplateSeq,c.CreateUserID,c.CreateDate,c.CreateTime,c.ModifyUser,c.ModifyDate,c.ModifyTime
	FROM EMRmeta.EMRTemplateGroup c ORDER BY c.TemplateSeq
}

/// d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLEMRTemplateGroupItem","SelectAllDetails","12||1")
Query SelectAllItem(aTemplateGroupCode As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,TemplateGroupCode:%String,EMRTemplateID:%String,EMRTemplateName:%String,TemplateSeq:%String,TemplateType:%String,UserTemplateCode:%String,TitleCode:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_EMRITEMS_SelectAllItem, SqlProc ]
{
    SELECT t.ID,t.TemplateGroupCode,t.EMRTemplateID,t.EMRTemplateName,t.TemplateSeq,t.TemplateType,t.UserTemplateCode,t.TitleCode
    FROM EMRmeta.EMRTemplateItem t
    WHERE t.TemplateGroupCode = :aTemplateGroupCode
    ORDER BY t.TemplateSeq
}

/// 得到最大code编号
ClassMethod CheckCode(aCode As %String) As %String
{
	&sql(select max(id) into :IdexCode from EMRmeta.EMRTemplateGroup where TemplateGroupCode = :aCode)
	s:(IdexCode="") IdexCode=0
	q IdexCode
}

/// 创建一个项目
ClassMethod CreateTemplateGroup(aTemplateGroup As EMRservice.entity.EEMRTemplateGroup) As %String
{
	/// b "s"	
	s objTemplateGroup=##class(EMRmeta.EMRTemplateGroup).%New()
	q:(objTemplateGroup="") ""
	s strReslt = ""	
	s objTemplateGroup.TemplateGroupCode= $case(aTemplateGroup.TemplateGroupCode,$c(0):"",:aTemplateGroup.TemplateGroupCode)
	s objTemplateGroup.TemplateGroupName=$case(aTemplateGroup.TemplateGroupName,$c(0):"",:aTemplateGroup.TemplateGroupName)
	s objTemplateGroup.CreateUserID=$case(aTemplateGroup.CreateUserID,$c(0):"",:aTemplateGroup.CreateUserID)
	s objTemplateGroup.CreateDate= $ZDATEH(aTemplateGroup.CreateDate,8)
	s objTemplateGroup.CreateTime=$ZTIMEH(aTemplateGroup.CreateTime)
	s objTemplateGroup.ModifyUser = $case(aTemplateGroup.ModifyUser,$c(0):"",:aTemplateGroup.ModifyUser)
	s objTemplateGroup.ModifyDate=$ZDATEH(aTemplateGroup.ModifyDate,8)
	s objTemplateGroup.ModifyTime=$ZTIMEH(aTemplateGroup.ModifyTime)
	
	s sc = objTemplateGroup.%Save()
	if ($$$ISOK(sc))
	{
		s strReslt = objTemplateGroup.%Id()
		s objTemplateGroup.TemplateSeq=strReslt
		d objTemplateGroup.%Save()
	}
	else
	{
		s strReslt = "-1"
	}
	q strReslt
}

/// 更新一个项目
ClassMethod UpdateTemplateGroup(aTemplateGroup As EMRservice.entity.EEMRTemplateGroup) As %String
{
	/// b "s"	
	set objTemplateGroup=##class(EMRmeta.EMRTemplateGroup).%OpenId(aTemplateGroup.ID)
	q:(objTemplateGroup="") ""	
	s strReslt = ""		
	s objTemplateGroup.TemplateGroupCode= $case(aTemplateGroup.TemplateGroupCode,$c(0):"",:aTemplateGroup.TemplateGroupCode)
	s objTemplateGroup.TemplateGroupName=$case(aTemplateGroup.TemplateGroupName,$c(0):"",:aTemplateGroup.TemplateGroupName)
	s objTemplateGroup.ModifyUser = $case(aTemplateGroup.ModifyUser,$c(0):"",:aTemplateGroup.ModifyUser)
	s objTemplateGroup.ModifyDate=$ZDATEH(aTemplateGroup.ModifyDate,8)
	s objTemplateGroup.ModifyTime=$ZTIMEH(aTemplateGroup.ModifyTime)
	//s objTemplateGroup.TemplateSeq=aTemplateGroup.TemplateSeq
	s sc = objTemplateGroup.%Save()
	if ($$$ISOK(sc))
	{
		s strReslt = objTemplateGroup.%Id()
	
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
		s objEntity=##class(EMRmeta.EMRTemplateGroup).%OpenId(argID)
		if (objEntity ="")
		{
			TROLLBACK
			s strMrk = 0
			quit
		}	
		s objEntity.TemplateSeq=argSeq
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
/// debug w ##class(EMRservice.BL.BLEMRTemplateGroupItem).DeleteTemplateGroupByID("003")
ClassMethod DeleteTemplateGroupByID(aTemplateGroupId As %String) As %String
{
	s strRes = "-1"
    q:(aTemplateGroupId ="") strRes
    TSTART
   	s strMark = "1"
    s objTemplateGroup = ##Class(EMRmeta.EMRTemplateGroup).%OpenId(aTemplateGroupId)
	q:(objTemplateGroup="") "-1"
	s strGroupCode = objTemplateGroup.TemplateGroupCode
	s strLocID =""
	for{
		s strLocID = $o(^DHCEMRM.EMRTemplateGroupLocI("IdxCodeCTLocID", " "_$zcvt(strGroupCode,"U"), strLocID))
		q:(strLocID="")
		s strLocRowID = ""
		for{
			s strLocRowID = $o(^DHCEMRM.EMRTemplateGroupLocI("IdxCodeCTLocID", " "_$zcvt(strGroupCode,"U"),strLocID,strLocRowID))
			q:(strLocRowID="")
			s sc = ##class(EMRmeta.EMRTemplateGroupLoc).%DeleteId(strLocRowID)
			if '($$$ISOK(sc))
			{	
				s strMark ="-1"
			}
		}
	}
	s strTemID =""
	for{
		s strTemID = $o(^DHCEMRM.EMRTemplateItemI("IdxItemCode", " "_$zcvt(strGroupCode,"U"), strTemID))
		q:(strTemID="")
		s strTemRowID = ""
		for{
			s strTemRowID = $o(^DHCEMRM.EMRTemplateItemI("IdxItemCode", " "_$zcvt(strGroupCode,"U"),strTemID,strTemRowID))
			q:(strTemRowID="")
			s sc = ##class(EMRmeta.EMRTemplateItem).%DeleteId(strTemRowID)
			if '($$$ISOK(sc))
			{	
				s strMark ="-1"
			}
		}
	}
	s sc = ##class(EMRmeta.EMRTemplateGroup).%DeleteId(aTemplateGroupId)
	if '($$$ISOK(sc))
	{	
		s strMark ="-1"
    }
    if (strMark="-1")
    {
	    TROLLBACK
		q strRes
    }
    else
    {
	    TCOMMIT
	    q "0"
	}
}

/// 得到最大code编号
ClassMethod GetMaxCode() As %String
{
	&sql(select max(id) into :IdexCode from EMRmeta.EMRTemplateItem)
	s:(IdexCode="") IdexCode=0
	q IdexCode
}

/// 创建一个项目
ClassMethod CreateTemplateItem(aTemplateItem As EMRservice.entity.EEMRTemplateItem) As %String
{
	/// b "s"
	s strReslt = "-1"	
	
	s objTemplateItem = ##Class(EMRmeta.EMRTemplateItem).%New()
	S objTemplateItem.TemplateGroupCode = $case(aTemplateItem.TemplateGroupCode,$c(0):"",:aTemplateItem.TemplateGroupCode)
	s objTemplateItem.EMRTemplateID = $case(aTemplateItem.EMRTemplateID,$c(0):"",:aTemplateItem.EMRTemplateID)
	s objTemplateItem.EMRTemplateName = $case(aTemplateItem.EMRTemplateName,$c(0):"",:aTemplateItem.EMRTemplateName)
	;s objTemplateItem.TemplateSeq = $case(aTemplateItem.TemplateSeq,$c(0):"",:aTemplateItem.TemplateSeq)
	s objTemplateItem.TemplateType = $case(aTemplateItem.TemplateType,$c(0):"",:aTemplateItem.TemplateType)
	s objTemplateItem.UserTemplateCode = $case(aTemplateItem.UserTemplateCode,$c(0):"",:aTemplateItem.UserTemplateCode)
	s objTemplateItem.TitleCode =$case(aTemplateItem.TitleCode,$c(0):"",:aTemplateItem.TitleCode)
	s sc = objTemplateItem.%Save()
	if ($$$ISOK(sc))
	{
	   s strReslt = objTemplateItem.%Id()
	   s objTemplateItem.TemplateSeq =strReslt
	   d objTemplateItem.%Save()
	}
	else
	{
		s strReslt = "-1"	
	}
	q strReslt
}

/// 更新一个项目
ClassMethod UpdateTemplateItem(aTemplateItem As EMRservice.entity.EEMRTemplateItem) As %String
{
	/// b "s"	
	s strReslt = "-1"
	set objTemplateItem=##class(EMRmeta.EMRTemplateItem).%OpenId(aTemplateItem.ID)
	q:(objTemplateItem="") ""	
	s objTemplateItem.EMRTemplateID = $case(aTemplateItem.EMRTemplateID,$c(0):"",:aTemplateItem.EMRTemplateID)
	s objTemplateItem.EMRTemplateName = $case(aTemplateItem.EMRTemplateName,$c(0):"",:aTemplateItem.EMRTemplateName)
	;s objTemplateItem.TemplateSeq = $case(aTemplateItem.TemplateSeq,$c(0):0,:aTemplateItem.TemplateSeq)
	
	s sc = objTemplateItem.%Save()
	if ($$$ISOK(sc))
	{
	   s strReslt = objTemplateItem.%Id()
	}
	else
	{
		s strReslt = "-1"	
	}
	q strReslt
}

/// 更新一个数据元范畴
/// w ##Class(EMRservice.BL.BLEMRTemplateItem).UpdateTemplateSequences("13||1||24^2,13||1||27^24")
ClassMethod UpdateTemplateSequences(argStr As %String) As %String
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
		s objEntity=##class(EMRmeta.EMRTemplateItem).%OpenId(argID)
		if (objEntity ="")
		{
			TROLLBACK
			s strMrk = 0
			quit
		}	
		s objEntity.TemplateSeq=argSeq
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
ClassMethod DeleteTemplateItemByID(aTemplateItemId As %String) As %String
{
    q:(aTemplateItemId ="") "-1"
    b
    s objTemplateItem = ##Class(EMRmeta.EMRTemplateItem).%OpenId(aTemplateItemId)
	q:(objTemplateItem="") "-1"
	s sc = ##class(EMRmeta.EMRTemplateItem).%DeleteId(aTemplateItemId)
	if ($$$ISOK(sc))
	{	
	   q "0"
    }
    else
    {
		q "-1"
	}
}

/// d ##Class(EMRservice.BL.BLEMRTemplateGroupItem).InitTest()
ClassMethod InitTest()
{
	
	s objScheme=##Class(EMRmeta.EMRTemplateGroup).%New()
	s objScheme.TemplateGroupCode="01"
	s objScheme.TemplateGroupName="住院病历(书写顺序)"
	s objScheme.CreateDate=+$h
	s objScheme.CreateTime=$p($h,",",2)
	s objScheme.CreateUserID="105"
	s objScheme.TemplateSeq=1
	d objScheme.%Save()
	s RowID=objScheme.%Id()
	
	s objDetails=##Class(EMRmeta.EMRTemplateGroupItem).%New()
	s objDetails.ParSchemeType=objSchemeType
	s objDetails.EMRTemplateID="01"
	s objDetails.EMRTemplateName="体温单"
	s objDetails.TemplateSeq=1
	d objDetails.%Save()
	
	s objDetails=##Class(EMRmeta.EMRTemplateGroupItem).%New()
	s objDetails.ParSchemeType=objSchemeType
	s objDetails.EMRTemplateID="02"
	s objDetails.EMRTemplateName="诊断列表"
	s objDetails.ItemDr=""
	s objDetails.TemplateSeq=2
	Do objDetails.%Save()

	s objDetails=##Class(EMRmeta.EMRTemplateGroupItem).%New()
	s objDetails.ParSchemeType=objSchemeType
	s objDetails.EMRTemplateID="03"
	s objDetails.EMRTemplateName="医嘱单"
	s objDetails.TemplateSeq=3
	Do objDetails.%Save()

	s objDetails=##Class(EMRmeta.EMRTemplateGroupItem).%New()
	s objDetails.ParSchemeType=objSchemeType
	s objDetails.EMRTemplateID="04"
	s objDetails.EMRTemplateName="病历书写"
	s objDetails.TemplateSeq=4
	Do objDetails.%Save()
	
	s objDetails=##Class(EMRmeta.EMRTemplateGroupItem).%New()
	s objDetails.ParSchemeType=objSchemeType
	s objDetails.EMRTemplateID="05"
	s objDetails.EMRTemplateName="病历书写"
	s objDetails.TemplateSeq=5
	Do objDetails.%Save()
	
	s objDetails=##Class(EMRmeta.EMRTemplateGroupItem).%New()
	s objDetails.ParSchemeType=objSchemeType
	s objDetails.EMRTemplateID="05"
	s objDetails.EMRTemplateName="病历书写"
	s objDetails.TemplateSeq=6
	Do objDetails.%Save()
}

}
