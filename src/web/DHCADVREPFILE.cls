Import sqluser

/// 不良事件归档
Class web.DHCADVREPFILE Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Description: 判断用户密码是否正确(判断用户是否对报告有归档权限)
/// Creator:     CongYue (原始wangxinlei)
/// CreateDate:  2018-01-22  
/// Table:	     SS_User,CT_CareProv,CT_CarPrvTp
/// Input:  	 userCode: 用户登陆名 passWord: 用户密码
/// Output:   	 成功返回 0^用户ID 失败返回 密码错误
/// Others:		 w ##class(web.DHCADVREPFILE).ConfirmPassWord("4796","1","advDrugUseErr")
ClassMethod ConfirmPassWord(userCode As %String, passWord As %String, RepTypeCode As %String, LgParam As %String) As %String
{
	n (userCode,passWord,RepTypeCode,LgParam)
	s retStr=0
	i userCode="" s userId=%session.Data("LOGON.USERID")
	e  s userId=$O(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(userCode),""))
	q:userId="" "用户有误"
	s userCode=$p($g(^SSU("SSUSR",userId)),"^",1)
	s groupflag=..GetIfGroupUser(userId,RepTypeCode,LgParam)  ;cy 备注判断用户是否对报告有归档权限
	q:groupflag=0 "该用户无归档权限"
	s retStr=##class(web.SSUser).IsValidUser(userCode,passWord)
	s retStr=$p(retStr,"^",2)
	s retStr=$s(retStr="UserNotFindErr ":"用户不存在",retStr="UnActiveErr ":"未激活",retStr="DateFromScopeErr ":"未到用户开启日",retStr="DateToScopeErr":"用户有效期已过",retStr="PasswordErr":"密码错误",retStr="":0,1:"验证失败")
	i retStr=0 s retStr=0_"^"_userId
	q retStr
}

/// Description: 判断人员是否有护理部安全组权限
/// Creator:     CongYue
/// CreateDate:  2018-01-22  
/// Table:	     SS_UserOtherLogonLoc 
/// Input:  	 人员id
/// Output:   	 flag 0 无权限， 1 有权限
/// Others:		 w ##class(web.DHCADVREPFILE).GetIfGroupUser("6")
ClassMethod GetIfGroupUser(UserID As %String, RepTypeCode As %String, LgParam As %String) As %String
{
	N (UserID,RepTypeCode,LgParam)
	S Othflag=0,groupflag=0,flag=0
	S groupdr=$p(^SSU("SSUSR",UserID),"^",5)
	Q:groupdr="" flag
	S LocID=$p(^SSU("SSUSR",UserID),"^",4)
	Q:LocID="" flag
	S params=UserID_"^"_LocID_"^"_groupdr_"^"_RepTypeCode
	S Fileflag=##class(web.DHCADVCOMMON).GetOperSecFlag(RepTypeCode,LgParam,9)
	S:Fileflag="Y" groupflag=1
	S Sub=""
	F  S Sub=$o(^SSU("SSUSR",UserID,"OTHLL",Sub)) Q:Sub=""  D
	.Q:Sub=0
	.S OthLogLocID=$p(^SSU("SSUSR",UserID,"OTHLL",Sub),"^",1)
	.S OthLogGroupID=$p(^SSU("SSUSR",UserID,"OTHLL",Sub),"^",2)
	.S params=UserID_"^"_OthLogLocID_"^"_OthLogGroupID_"^"_RepTypeCode
	.S Fileflag=##class(web.DHCADVCOMMON).GetOperSecFlag(RepTypeCode,LgParam,9)
	.S:Fileflag="Y" groupflag=1
	S:(groupflag=1)||(Othflag=1) flag=1
	
	Q flag
}

/// Description: 保存[归档数据 撤销操作与操作人必须是同一人，再次操作人可以与原操作人不一致] 
/// Creator:     CongYue
/// CreateDate:  2018-01-22  
/// Table:	     DHC_AdvRepFile 
/// Input:  	
/// return: 	 保存成功 0，保存失败 非0
/// Others:		 w ##class(web.DHCADVREPFILE).SaveRepFile("2^2018-01-16^归档")
ClassMethod SaveRepFile(RepID, RepTypeDr, DataList As %String) As %String
{
	N (RepID,RepTypeDr,DataList)
	S FILERowID=$o(^DHCADVFILE(0,"RepDrType",RepID,RepTypeDr,""))

	S FileId=$p(DataList,"^",6)
	
	i FileId=""  D
	.S Err=..InsRepFile(RepID,RepTypeDr,DataList)
	E  D
	.S Err=..UpdRepFile(FileId,RepID,RepTypeDr,DataList)
	Q Err
}

/// Description: 增加[归档数据维护] 
/// Creator:     CongYue
/// CreateDate:  2018-01-22  
/// Table:	     DHC_AdvRepFile 
/// Input:  	 DataList:以字符"^"分割,格式为: id^日期^标志
/// return: 	 保存成功 0，保存失败 非0
/// Others:		 w ##class(web.DHCADVREPFILE).InsRepFile("")
ClassMethod InsRepFile(RepID, RepTypeDr, DataList As %String) As %String
{
	N (RepID,RepTypeDr,DataList)
	S FILEIfFile=$p(DataList,"^",3)
	S FILEAuditUser=$p(DataList,"^",4) ;归档人
	S FILEChecker=$p(DataList,"^",5) ;复核人
	S FILEDate=+$h  ;归档日期
	S FILETime=$p($h,",",2)  ;归档时间
	
 	&SQL(INSERT INTO DHC_AdvRepFile(FILE_RepDr,FILE_RepType,FILE_IfFile,FILE_AuditUser,FILE_Checker,FILE_Date,FILE_Time) 
 		VALUES(:RepID,:RepTypeDr,:FILEIfFile,:FILEAuditUser,:FILEChecker,:FILEDate,:FILETime))
 	Q SQLCODE
}

/// Description: 修改[归档数据维护] 
/// Creator:     CongYue
/// CreateDate:  2018-01-22  
/// Table:	     DHC_AdvRepFile 
/// Input:  	 DataList: 以字符"^"分割,格式为: id^日期^标志
/// return: 	 保存成功 0，保存失败 非0  撤销操作人与操作人不符合 返回-1
/// Others:		 w ##class(web.DHCADVREPFILE).UpdRepFile("2^2018-01-16^归档")
ClassMethod UpdRepFile(FILERowID, RepID, RepTypeDr, DataList As %String) As %String
{
	N (FILERowID,RepID,RepTypeDr,DataList)
	S Flag=0
	S AuitUserId=$p(^DHCADVFILE(FILERowID),"^",4)
	S FILEIfFile=$p(DataList,"^",3)
	I (FILEIfFile="01")||(FILEIfFile="02") D
	.S FILEAuditUser=$p(DataList,"^",4) ;归档人
	.S FILEChecker=$p(DataList,"^",5) ;复核人
	.S FILEDate=+$h  ;归档日期
	.S FILETime=$p($h,",",2)  ;归档时间
	.&SQL(Update DHC_AdvRepFile Set FILE_IfFile=:FILEIfFile,FILE_AuditUser=:FILEAuditUser,FILE_Checker=:FILEChecker,FILE_Date=:FILEDate,FILE_Time=:FILETime WHERE FILE_RowID=:FILERowID)
 	Q:+$g(SQLCODE)'=0 SQLCODE
	I (FILEIfFile="11")||(FILEIfFile="12") D
	.S FILERevFileuser=$p(DataList,"^",4) ;撤销人
	.S:(AuitUserId'=FILERevFileuser) Flag="-1"
	.Q:Flag'=0
	.S FILERevDate=+$h   ;撤销归档日期
	.S FILERevTime=$p($h,",",2)   ;撤销归档时间
	.&SQL(Update DHC_AdvRepFile Set FILE_IfFile=:FILEIfFile,FILE_RevFileuser=:FILERevFileuser,FILE_RevDate=:FILERevDate,FILE_RevTime=:FILERevTime WHERE FILE_RowID=:FILERowID)
 	Q:+$g(SQLCODE)'=0 SQLCODE
 	
 	Q Flag
}

}
