/// 名称:EMRservice.BL.BLTemplateUserAccess
/// 描述:模板用户模板权限控制BL层
/// 编写者：yejian
/// 编写日期: 2018-12-13
Class EMRservice.BL.BLTemplateUserAccess Extends (%RegisteredObject, %XML.Adaptor)
{

/// 获取所有数据
Query SelectAllData(aSupUserID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,SupUserID:%String,SupUserName:%String,TemType:%String,TemCID:%String,TempCName:%String") [ SqlName = SPM_TemUserAccess_SELECTALL, SqlProc ]
{
	SELECT t.ID,t.SupUserID,t.SupUserName,t.TemType,t.TemCID,t.TempCName 
	FROM EMRmeta.TemplateUserAccess t where SupUserID =:aSupUserID
}

Query SELECTALL() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,IsAdmin:%String,SupCode:%String,SupPassWord:%String,SupUserID:%String,SupUserName:%String,RoleID:%String,RoleName:%String,RoleDesc:%String") [ SqlName = SPM_TemUserAccess_SELECTALLUser, SqlProc ]
{
SELECT A.%ID AS ID,IsAdmin,SupCode,SupPassWord,SupUserID,SupUserName, RoleID, B.RoleName AS RoleName, B.RoleDesc AS RoleDesc
 	FROM EMRmeta.SuperUser A JOIN EMRmeta.MainRole B
 	ON A.RoleID = B.ID  AND A.RoleID ='3'
	ORDER BY A.SupUserID
}

/// 添加模板用户数据
ClassMethod CheckCodeIdExist(aSupUserID As %String, aTemType As %String, aTemCID As %String) As %String
{
	s res = "0"
	q:(aSupUserID = ""||aTemType=""||aTemCID ="") res
	
	s res = $d(^DHCEMRM.TemplateUserAccessI("IdxSupUserTypeTemID"," "_aSupUserID," "_aTemType," "_aTemCID))
	q res
}

/// 删除模板用户数据
ClassMethod CreateUserAccess(aTemUserAccess As EMRservice.entity.ETemplateUserAccess) As %String [ WebMethod ]
{
	S objUserAccess = ##class(EMRmeta.TemplateUserAccess).%New()
 	
 	S UniqueFlag=##Class(EMRservice.BL.BLTemplateUserAccess).CheckCodeIdExist(aTemUserAccess.SupUserID,aTemUserAccess.TemType,aTemUserAccess.TemCID)
 	S ^CreateUserAccess("123") = UniqueFlag
 	if '(UniqueFlag=0)
 	{ 
 		Q "-1"
 	} 
 	
	s objUserAccess.SupUserID = aTemUserAccess.SupUserID
	s objUserAccess.SupUserName = aTemUserAccess.SupUserName
	s objUserAccess.TemType = aTemUserAccess.TemType
	s objUserAccess.TemCID = aTemUserAccess.TemCID
	s objUserAccess.TempCName = aTemUserAccess.TempCName
	
 	if '(objUserAccess.%Save())
 	{
		Q "0" 
	}
	
 	Q objUserAccess.%Id()
}

ClassMethod DeleteUserAccess(AIDs As %String) As %Boolean
{
	s res = "1"
	q:(AIDs="") res
	//删除未选中的科室
	s delCount = $l(AIDs,"^")
	s i = 1
	WHILE (i <= delCount) 
	{
		s aRowID = $p(AIDs, "^", i)
		if (aRowID '= "")
		{
			s itemRowID = ^DHCEMRM.TemplateUserAccessD(aRowID)
			//如果有,则删除; 没有则不处理
			if (itemRowID '= "")
			{
				d ##class(EMRmeta.TemplateUserAccess).%DeleteId(aRowID)
			}
		}
		s i = i + 1
	}
	q res
}

}
