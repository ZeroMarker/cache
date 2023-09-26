/// 名称:通讯录授权
/// 描述:
/// 编写者:基础数据平台组 -杨帆
/// 编写日期: 2020-12-25
Class web.DHCBL.CT.CTHCCSPreferences Extends %RegisteredObject
{

/// update2020-12-29
Parameter SQLTableName = "CT_HCCSPreferences";

/// Creator：基础数据平台-杨帆
/// CreatDate: 2020-12-25
/// function:根据个人通讯录id,群组id，判断群组和个人通讯录授权关系     //+返回授权管理rowid  +类型入参type(授权类型G前台写死)?
/// input:群组rowid,个人通讯录rowid
/// Output:
/// w ##class(web.DHCBL.CT.CTHCCSPreferences).GetCheckFlag("6","8")
ClassMethod GetCheckFlag(authorizeid, contactlistid) As %String
{
	s flag="false"
	if (authorizeid'="")&&(contactlistid'="")
	{
		/*s PRERowId=0
		for
		{
			s PRERowId=$o(^CT("HCCSPRE",0,"CL",contactlistid,PRERowId)) q:PRERowId=""
			s PREAuthorizeData=$p($g(^CT("HCCSPRE",PRERowId)),"^",3)  //群组ID
			if (PREAuthorizeData=authorizeid)
			{
				s flag="true"
				q
			}
		}*/
		if ($d(^CT("HCCSPRE",0,"CL",contactlistid,"G",authorizeid)))  //存在
		{
			s flag="true"
		}
		
	}
	q flag
}

/// Creator：基础数据平台-杨帆
/// CreatDate: 2020-12-25
/// function:人员数据json串，提供给群组关联人员树
/// Table：CT_HCCSGroupLinkContList
/// input: 群组id
/// w ##class(web.DHCBL.CT.CTHCCSPreferences).GetJsonDataForTree("8")
ClassMethod GetJsonDataForTree(contactlistid, hospid As %String) As %String
{
	w "["
	s GROUPRowId=0
	s count=0
	for
	{
		s GROUPRowId=$o(^CT("HCCSGROUP",GROUPRowId)) q:GROUPRowId=""
		s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("CT_HCCSGroup",GROUPRowId,hospid)
		continue:showflag="N"
		s GROUPDesc= $p($g(^CT("HCCSGROUP",GROUPRowId)),"^",2)		//群组名称
		
		w:count'=0 ","
		s checked=..GetCheckFlag(GROUPRowId,contactlistid)		//是否关联	input:群组id,人员id
		s GroupLinkContListFlag=##class(web.DHCBL.CT.CTHCCSGroupLinkContList).GetCheckFlag(contactlistid,GROUPRowId)  //判断个人是否属于改群组
		w "{""id"":"""_GROUPRowId_""",""text"":"""_GROUPDesc_""",""checked"":"_checked_",""GroupLinkContListFlag"":"_GroupLinkContListFlag_"}"
		s count=count+1
	}
	w "]"
	q ""
}

/// Creator：基础数据平台-杨帆
/// CreatDate: 2020-12-25
/// Description：数据重复校验
/// Table：CT_HCCSPreferences
/// Input:id,precontactlistid
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.DHCBL.CT.CTHCCSPreferences).FormValidate("","")
ClassMethod FormValidate(id As %String, precontactlistid As %String, authorizeid As %String, type As %String) As %String
{
	s flag=0
	if ($d(^CT("HCCSPRE",0,"CL",precontactlistid,type,authorizeid)))  //存在
	{
		s flag=1
	}
	q flag
}

/// Creator:杨帆 
/// Editor:丁亚男
/// CreatDate: 2020-12-24
/// Description：保存 通讯录授权
/// Input: eobj As web.Entity.CT.CTHCCSPreferences
/// Table：CT_HCCSPreferences
/// Return:成功返回true，失败返回false
/// Other:w ##class(web.DHCBL.CT.CTHCCSPreferences).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.CT.CTHCCSPreferences) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		s flag=..FormValidate(eobj.PRERowId,eobj.PREContactListDR,eobj.PREAuthorizeData,eobj.PREAuthorizeType)    
		if (flag=1)
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		if (eobj.PRERowId="")
		{
			s obj=##class(User.CTHCCSPreferences).%New()
		}
		else
		{
			s obj=##class(User.CTHCCSPreferences).%OpenId(eobj.PRERowId)
			s bobj=##class(web.Entity.CT.CTHCCSPreferences).%New()
			s bobj.PRERowId = eobj.PRERowId		//GROUPRowId
			if $IsObject(obj.PREContactListDR)
			{
				s bobj.PREContactListDR = obj.PREContactListDR.%Id() //通讯录-指针
			}
			s bobj.PREAuthorizeType = obj.PREAuthorizeType		//授权类型（群组G）
			s bobj.PREAuthorizeData = obj.PREAuthorizeData	//授权数据（群组ID）
		}
		d obj.PREContactListDRSetObjectId(eobj.PREContactListDR) //通讯录-指针
		s obj.PREAuthorizeType = eobj.PREAuthorizeType		//授权类型（群组G）
		s obj.PREAuthorizeData=eobj.PREAuthorizeData		//授权数据（群组ID）
		TSTART
		s sc=obj.%Save()
		if (sc=1)
		{
			TCOMMIT
			s id=obj.%Id()
			s result="{success:'true',id:'"_id_"'}"
			s HCCSCLUserCode=$p($g(^CT("HCCSCL",eobj.PREContactListDR)),"^",1)     //个人通讯录用户代码
			s GROUPDesc= $p($g(^CT("HCCSGROUP",eobj.PREAuthorizeData)),"^",2)		//群组名称
			d:eobj.PRERowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_HCCSPreferences","User.CTHCCSPreferences","通讯录授权",eobj.PRERowId,HCCSCLUserCode_"-"_GROUPDesc,"U",eobj,bobj)
    		d:eobj.PRERowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_HCCSPreferences","User.CTHCCSPreferences","通讯录授权",id,HCCSCLUserCode_"-"_GROUPDesc,"A",eobj)
		}
		else
		{
			TROLLBACK
			s result="{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
			s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("通讯录授权","web.DHCBL.CT.CTHCCSPreferences","SaveEntity",eobj)
      		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
		
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

/// Creator：杨帆
/// CreatDate: 2020-12-25
/// Description：根据id删除 通讯录授权表
/// Table：CT_HCCSPreferences
/// Input：id 
/// Return：成功返回true，失败返回false和info
/// Other: w ##class(web.DHCBL.CT.CTHCCSPreferences).DeleteData(1)
ClassMethod DeleteData(id) As %String
{
	s result=""
	s pobj = ##class(User.CTHCCSPreferences).%OpenId(id)
	s eobj = ##class(web.Entity.CT.CTHCCSPreferences).%New()
	s:pobj.PREContactListDR'="" eobj.PREContactListDR=pobj.PREContactListDR.%Id()		//通讯录-指针
	s eobj.PREAuthorizeType = pobj.PREAuthorizeType		  //授权类型（群组G）
	s eobj.PREAuthorizeData = pobj.PREAuthorizeData		  //授权数据（群组ID）
	
	d pobj.%Close()
	kill pobj
	Tstart
	s sc=##class(User.CTHCCSPreferences).%DeleteId(id)
	IF $$$ISOK(sc){
		Tc
		s result="{success:'true',info:'删除成功！'}"
		s HCCSCLUserCode=$p($g(^CT("HCCSCL",eobj.PREContactListDR)),"^",1)     //个人通讯录用户代码
		s GROUPDesc= $p($g(^CT("HCCSGROUP",eobj.PREAuthorizeData)),"^",2)		//群组名称
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_HCCSPreferences","User.CTHCCSPreferences","通讯录授权",id,HCCSCLUserCode_"-"_GROUPDesc,"D",eobj)
	}
	else{
		Trollback
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("通讯录授权","web.DHCBL.CT.CTHCCSPreferences","DeleteData",eobj)
		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	}
	q result
}

/// Creator：杨帆
/// Editor:丁亚男
/// CreatDate: 2020-12-25
/// Description：界面右侧保存通讯录授权       
/// Table：CT_HCCSPreferences
/// Input：contactlistid(个人通讯录rowid),changestr (变化的群组id拼串) type 授权类型
/// Return：
/// Other: w ##class(web.DHCBL.CT.CTHCCSPreferences).SavePreferences("2","A2A","G")
ClassMethod SavePreferences(contactlistid As %String, changestr As %String, type As %String) As %String
{
	s result="true"
	if (changestr["A")
	{
		s changestr = ##class(web.BDP.util.String).Replace(changestr,"A","")
	}
	if (changestr'="")
	{
		s changelen=$Length(changestr,"^")

		Ts
		for j=1:1:changelen
		{
			
			s authorizeid=$p(changestr,"^",j)
			if authorizeid="" continue
			if ('$d(^CT("HCCSPRE",0,"CL",contactlistid,type,authorizeid)))  //不存在则增加
			{
				s eobj=##class(web.Entity.CT.CTHCCSPreferences).%New()
				s eobj.PREContactListDR=contactlistid  //通讯录-指针
				s eobj.PREAuthorizeType=type   //授权类型
				s eobj.PREAuthorizeData=authorizeid  //授权数据（群组ID）
				s resultstr=..SaveEntity(eobj)
			}
			else  //存在则删除
			{
				s id=$o(^CT("HCCSPRE",0,"CL",contactlistid,type,authorizeid,0))
				s resultstr=..DeleteData(id)
			}
			
			if (resultstr["false")
			{
				s result=result_"^0"
			}
			else
			{
				s result=result_"^1"
			}
		}
		if (result["0")
		{
			Tro
			s result="false"
		}
		else
		{
			Tc
			s result="true"
		}
		
	}
	q result
}

}
