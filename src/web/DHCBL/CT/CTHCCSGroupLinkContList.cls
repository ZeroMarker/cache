/// 名称:群组关联个人通讯录维护
/// 描述:
/// 编写者:基础数据平台组 -杨帆
/// 编写日期: 2020-12-24
Class web.DHCBL.CT.CTHCCSGroupLinkContList Extends %RegisteredObject
{

/// update2020-12-29
Parameter SQLTableName = "CT_HCCSGroupLinkContList";

/// Creator：基础数据平台-杨帆
/// Editor:丁亚男
/// CreatDate: 2020-12-25
/// function:根据个人通讯录id,群组id，判断该群组和个人通讯录是否关联      //+
/// input:hccsclid(个人通讯录rowid),groupid(群组rowid)
/// Output:返回关联标志（true/false）以及关联rowid
/// w ##class(web.DHCBL.CT.CTHCCSGroupLinkContList).GetCheckFlag("1","1")
ClassMethod GetCheckFlagInfo(hccsclid, groupid As %String) As %String
{
	s flag="false^"
	if (hccsclid'="")&&(groupid'="")
	{
		if ($d(^CT("HCCSGROUP",0,"ContactList",groupid,hccsclid))) 
		{
			s GROUPRowId=$o(^CT("HCCSGROUP",0,"ContactList",groupid,hccsclid,""))
			s flag="true^"_GROUPRowId
		}	
	}
	q flag
}

/// Creator：基础数据平台-杨帆
/// Editor:丁亚男
/// CreatDate: 2020-12-25
/// function:根据个人通讯录id,群组id，判断该群组和个人通讯录是否关联      //+
/// input:hccsclid(个人通讯录rowid),groupid(群组rowid)
/// Output:返回关联标志（true/false）
/// w ##class(web.DHCBL.CT.CTHCCSGroupLinkContList).GetCheckFlag("1","1")
ClassMethod GetCheckFlag(hccsclid, groupid As %String) As %String
{
	s flag="false"
	if (hccsclid'="")&&(groupid'="")
	{
		if ($d(^CT("HCCSGROUP",0,"ContactList",groupid,hccsclid))) 
		{
			s flag="true"
		}	
	}
	q flag
}

/// Creator：基础数据平台-杨帆
/// CreatDate: 2020-12-25
/// Description：数据重复校验
/// Table：CT_HCCSGroupLinkContList
/// Input:id,hccsclid(个人通讯录rowid),groupid(群组rowid)
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.DHCBL.CT.CTHCCSGroupLinkContList).FormValidate("1||1","1","1")
ClassMethod FormValidate(id As %String, hccsclid As %String, groupid As %String) As %String
{
	s flag=0
	if (hccsclid'="")&&(groupid'="")
	{
		s GROUPRowId=0
		for
		{
			s GROUPRowId=$o(^CT("HCCSGROUP",groupid,"CL",GROUPRowId)) q:GROUPRowId=""
			s CGCLContactListDR=$p($g(^CT("HCCSGROUP",groupid,"CL",GROUPRowId)),"^",1) //个人通讯录
			if (CGCLContactListDR=hccsclid)&&(id=GROUPRowId)
			{
				s flag=1
				q
			}
		}
	}
	q flag
}

/// Creator:杨帆 
/// CreatDate: 2020-12-25
/// Description：保存 群组关联个人通讯录维护表
/// Input: eobj As web.Entity.CT.CTHCCSGroupLinkContList
/// Table：CT_HCCSGroupLinkContList
/// Return:成功返回true，失败返回false
/// Other:w ##class(web.DHCBL.CT.CTHCCSGroupLinkContList).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.CT.CTHCCSGroupLinkContList) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		
		s flag= ..FormValidate(eobj.CGCLRowId,eobj.CGCLContactListDR,eobj.CGCLParRef)  //调用重复验证
		if (flag=1)
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		if (eobj.CGCLRowId="")
		{
			s obj=##class(User.CTHCCSGroupLinkContList).%New(eobj.CGCLParRef) 
		}
		else
		{
			s obj=##class(User.CTHCCSGroupLinkContList).%OpenId(eobj.CGCLRowId)
			s bobj=##class(web.Entity.CT.CTHCCSGroupLinkContList).%New()
			if $IsObject(obj.CGCLContactListDR)
			{
				s bobj.CGCLContactListDR = obj.CGCLContactListDR.%Id()  //关联用户
			}
		}
		d obj.CGCLParRefSetObjectId(eobj.CGCLParRef)  //群组id
		d obj.CGCLContactListDRSetObjectId(eobj.CGCLContactListDR)   //关联用户
		TSTART
		s sc=obj.%Save()
		if (sc=1)
		{
			TCOMMIT
			s id=obj.%Id()
			s result="{success:'true',id:'"_id_"'}"
			s (HCCSCLUserCode,GROUPDesc)=""
			s HCCSCLUserCode=$p($g(^CT("HCCSCL",eobj.CGCLContactListDR)),"^",1)     //用户代码
			s GROUPDesc= $p($g(^CT("HCCSGROUP",eobj.CGCLParRef)),"^",2)		//群组名称
			d:eobj.CGCLRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_HCCSGroupLinkContList","User.CTHCCSGroupLinkContList","群组关联个人通讯录维护",eobj.CGCLRowId,GROUPDesc_"-"_HCCSCLUserCode,"U",eobj,bobj)
    		d:eobj.CGCLRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_HCCSGroupLinkContList","User.CTHCCSGroupLinkContList","群组关联个人通讯录维护",id,GROUPDesc_"-"_HCCSCLUserCode,"A",eobj)
			//保存授权关系 当用户属于改群组时，则保存授权
			if ('$d(^CT("HCCSPRE",0,"CL",eobj.CGCLContactListDR,"G",eobj.CGCLParRef)))  //不存在
			{
				s preeobj=##class(web.Entity.CT.CTHCCSPreferences).%New()
				s preeobj.PREAuthorizeData=	eobj.CGCLParRef
				s preeobj.PREAuthorizeType=	"G"
				s preeobj.PREContactListDR=	eobj.CGCLContactListDR
				s preresult=##class(web.DHCBL.CT.CTHCCSPreferences).SaveEntity(preeobj)
			}
			
		}
		else
		{
			TROLLBACK
			s result="{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
			s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("群组关联个人通讯录维护","web.DHCBL.CT.CTHCCSGroupLinkContList","SaveEntity",eobj)
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
/// Description：根据id删除 群组关联个人通讯录
/// Table：CT_HCCSGroupLinkContList
/// Input：id 
/// Return：成功返回true，失败返回false和info
/// Other: w ##class(web.DHCBL.CT.CTHCCSGroupLinkContList).DeleteData("5||1")
ClassMethod DeleteData(id As %String) As %String
{
	s result=""
	//s re=##class(web.DHCBL.CT.CTHCCSGroupLinkContList).GetRefFlag(id)
	s RefFlag=0 //$p(re,"^",1)
	s CGCLParRef=$p(id,"||",1)
	if (RefFlag=0)
	{
		s eobj = ##class(User.CTHCCSGroupLinkContList).%OpenId(id)
		s pobj = ##class(web.Entity.CT.CTHCCSGroupLinkContList).%New()
		s:eobj.CGCLContactListDR'="" pobj.CGCLContactListDR=eobj.CGCLContactListDR.%Id()		//关联用户
		
		d eobj.%Close()
		kill eobj
		Tstart
		s sc=##class(User.CTHCCSGroupLinkContList).%DeleteId(id)
		IF $$$ISOK(sc)
		{
			Tc
			s result="{success:'true',info:'删除成功！'}"
			s (HCCSCLUserCode,GROUPDesc)=""
			s GROUPRowId=$p(id,"||",1)
			s CGCLChildsub=$p(id,"||",2)
			s GROUPDesc= $p($g(^CT("HCCSGROUP",GROUPRowId)),"^",2)		//群组名称
			s CGCLContactListDR=$p($g(^CT("HCCSGROUP",GROUPRowId,"CL",CGCLChildsub)),"^",1) //个人通讯录
			s HCCSCLUserCode=$p($g(^CT("HCCSCL",pobj.CGCLContactListDR)),"^",1)     //用户代码
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_HCCSGroupLinkContList","User.CTHCCSGroupLinkContList","群组关联个人通讯录维护",id,GROUPDesc_"-"_HCCSCLUserCode,"D",pobj)
		
			//同步删除授权关系 
			if ($d(^CT("HCCSPRE",0,"CL",pobj.CGCLContactListDR,"G",GROUPRowId)))  //存在
			{
				s PreRowId=$O(^CT("HCCSPRE",0,"CL",pobj.CGCLContactListDR,"G",GROUPRowId,""))
				
				s preresult=##class(web.DHCBL.CT.CTHCCSPreferences).DeleteData(PreRowId)
			}
		}
		else
		{
			Trollback
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("群组关联个人通讯录维护","web.DHCBL.CT.CTHCCSGroupLinkContList","DeleteData",pobj)
			s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		}
	}
	else
	{
		s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"	
	}
	
	
	q result
}

/// Creator：杨帆
/// Editor:丁亚男
/// CreatDate: 2020-12-25
/// Description：右侧个人通讯录统一保存方法  
/// Table：CT_HCCSGroupLinkContList
/// Input：groupid(群组rowid),checkstr (选中行对应的个人通讯录id拼串),uncheckstr (选中行对应的个人通讯录id拼串)
/// Return：
/// Other: w ##class(web.DHCBL.CT.CTHCCSGroupLinkContList).SaveGroupLinkList("1","8")
ClassMethod SaveGroupLinkList(groupid As %String, ChangeIDstr As %String) As %String
{
	s result=""
	// 变化的id串
	if (ChangeIDstr'="")
	{
		Ts
		s Changelen=$Length(ChangeIDstr,"^")
		//保存
		for j=1:1:Changelen
		{
		    
		    s HCCSCLRowId=$p(ChangeIDstr,"^",j)
		    if ('$d(^CT("HCCSGROUP",0,"ContactList",groupid,HCCSCLRowId))) //判断是否存在,不存在增加
		    {
			   s eobj=##class(web.Entity.CT.CTHCCSGroupLinkContList).%New()
			   s eobj.CGCLParRef=groupid
			   s eobj.CGCLContactListDR=HCCSCLRowId
			   s resultstr=..SaveEntity(eobj) 
			} 
			else  //存在删除
			{
				
				s CGCLRowId=$o(^CT("HCCSGROUP",0,"ContactList",groupid,HCCSCLRowId,""))
				s id=groupid_"||"_CGCLRowId
				s resultstr=..DeleteData(id)
			} 
			
		 
		}
		s:result'="" result=result_","_resultstr
		s:result="" result=resultstr
	}
	if (result["false")
	{
		tro
		s result="{success:'false',info:'保存失败！'}"
	}
	else
	{
		tc
		s result= "{success:'true',info:'保存成功！'}"
	}
	
	q result
}

}
