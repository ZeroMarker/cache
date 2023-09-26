Import SQLUser

/// UpdateDate:2013-07-16
/// UpdateBy:基础数据平台 蔡昊哲
/// Function:其他登录科室 
Class web.DHCBL.CT.SSUserOtherLogonLoc Extends %RegisteredObject [ ProcedureBlock ]
{

/// Function:进行数据的模糊查询检索，查询其他登录科室的信息
/// CreateDate:2013-07-16
/// Creator:基础数据平台公共产品组 chz
/// Tables:  SS_UserOtherLogonLoc
/// Input: rowid, ParRef 
/// Output: OTHLL_ParRef	OTHLL_RowId	OTHLL_Childsub	OTHLL_CTLOC_DR	OTHLL_UserGroup_DR	OTHLL_Hospital_DR,SyncRBFlag（同步资源表)
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.SSUserOtherLogonLoc", "GetList","","16","","") 
Query GetList(rowid As %String, OTHLLParRef As %String, group As %String, ctloc As %String) As %Query(ROWSPEC = "OTHLLRowId:%String,CTLOCDesc:%String,SSGRPDesc:%String,HOSPDesc:%String,OTHLLCTLOCDR:%String,OTHLLUserGroupDR:%String,OTHLLHospitalDR:%String,OTHLLStartDate:%String,OTHLLEndDate:%String,SyncRBFlag:%String")
{
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod GetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
{
	
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, OTHLLParRef As %String, group As %String, ctloc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	i rowid '="" 
	{
		s OTHLLRowId=rowid
		s ChildSub=$p($g(rowid),"||",2) ///判断为第几个孩子
		s ParRef=$p($g(rowid),"||",1)  
		s OTHLLCTLOCDR=$p($g(^SSU("SSUSR",ParRef,"OTHLL",ChildSub)),"^",1)
		s OTHLLUserGroupDR=$p($g(^SSU("SSUSR",ParRef,"OTHLL",ChildSub)),"^",2)
		s OTHLLHospitalDR=$p($g(^SSU("SSUSR",ParRef,"OTHLL",ChildSub)),"^",3)
		s OTHLLStartDate=$p($g(^SSU("SSUSR",ParRef,"OTHLL",ChildSub)),"^",4)
		s OTHLLEndDate=$p($g(^SSU("SSUSR",ParRef,"OTHLL",ChildSub)),"^",5)
		s OTHLLStartDate = ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(OTHLLStartDate)
		s OTHLLEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(OTHLLEndDate)
		s CTLOCDesc="",SSGRPDesc="",HOSPDesc=""
		s:OTHLLCTLOCDR'="" CTLOCDesc=$p($g(^CTLOC(OTHLLCTLOCDR)),"^",2)
		s:OTHLLUserGroupDR'="" SSGRPDesc=$p($g(^SSU("SSGRP",OTHLLUserGroupDR)),"^",1)
		s:OTHLLHospitalDR'="" HOSPDesc =$p($g(^CT("HOSP",OTHLLHospitalDR)),"^",2)
		s SyncRBFlag="N"
		if OTHLLCTLOCDR'=""
		{
			s SSUSRCareProvDR=$p($g(^SSU("SSUSR",OTHLLParRef)),"^",14)
			if SSUSRCareProvDR'=""
			{
				if $d(^RB("RES",0,"CTPCP",SSUSRCareProvDR,OTHLLCTLOCDR)) s SyncRBFlag="Y"
			}
		}
		d Build1
	}
	else  
	{	 
		//获取医院级授权
		s AuHospStr=##class(web.DHCBL.Authorize.BDPHospitalAut).GetHospAutFlag()
		if OTHLLParRef'=""
		{
			s ChildSub =0
			for 
			{
				s ChildSub=$o(^SSU("SSUSR",OTHLLParRef,"OTHLL",ChildSub)) q:ChildSub=""  
				s OTHLLRowId=OTHLLParRef_"||"_ChildSub
		  		s OTHLLHospitalDR=$p($g(^SSU("SSUSR",OTHLLParRef,"OTHLL",ChildSub)),"^",3)
		  		//s strHospitalID = "{ID:"_OTHLLHospitalDR_"}"
		  		//if ((AuHospStr[strHospitalID)||(AuHospStr=1)||(AuHospStr="off")) 
		  		///{
			  		s OTHLLCTLOCDR=$p($g(^SSU("SSUSR",OTHLLParRef,"OTHLL",ChildSub)),"^",1)
		  			s OTHLLUserGroupDR=$p($g(^SSU("SSUSR",OTHLLParRef,"OTHLL",ChildSub)),"^",2)
		  			s OTHLLHospitalDR=$p($g(^SSU("SSUSR",OTHLLParRef,"OTHLL",ChildSub)),"^",3)
		  			s OTHLLStartDate=$p($g(^SSU("SSUSR",OTHLLParRef,"OTHLL",ChildSub)),"^",4)
					s OTHLLEndDate=$p($g(^SSU("SSUSR",OTHLLParRef,"OTHLL",ChildSub)),"^",5)
					s CTLOCDesc="",SSGRPDesc="",HOSPDesc=""
		  			s:OTHLLCTLOCDR'="" CTLOCDesc=$p($g(^CTLOC(OTHLLCTLOCDR)),"^",2)
		  			s:OTHLLUserGroupDR'="" SSGRPDesc=$p($g(^SSU("SSGRP",OTHLLUserGroupDR)),"^",1)
		  			s:OTHLLHospitalDR'="" HOSPDesc =$p($g(^CT("HOSP",OTHLLHospitalDR)),"^",2)
		  			s OTHLLStartDate = ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(OTHLLStartDate)
					s OTHLLEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(OTHLLEndDate)
					s SyncRBFlag="N"
					if OTHLLCTLOCDR'=""
					{
						s SSUSRCareProvDR=$p($g(^SSU("SSUSR",OTHLLParRef)),"^",14)
						if SSUSRCareProvDR'=""
						{
							if $d(^RB("RES",0,"CTPCP",SSUSRCareProvDR,OTHLLCTLOCDR)) s SyncRBFlag="Y"
						}
					}
					if ((OTHLLUserGroupDR=group)||(group=""))&&((OTHLLCTLOCDR=ctloc)||(ctloc=""))
					{
						
		  				d Build1
					}	
		  		//}
			}
			
		}
	 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
Build1 
   
	set Data=$lb(OTHLLRowId,CTLOCDesc,SSGRPDesc,HOSPDesc,OTHLLCTLOCDR,OTHLLUserGroupDR,OTHLLHospitalDR,OTHLLStartDate,OTHLLEndDate,SyncRBFlag)
 	set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

/// Function:用于实现数据校验功能的方法
/// Creator:基础数据平台组 蔡昊哲 
/// CreateDate:2013-4-20    
/// update by chenynig 20190627
/// d ##class(web.DHCBL.CT.SSUserOtherLogonLoc).FormValidate("939","939||1","2","7","66666","")
ClassMethod FormValidate(ParRef As %String, OTHLLRowId As %String, LocDR As %String, GroupDR As %String, startdate As %String, enddate As %String) As %String
{
	s flag=0
	q:ParRef="" 0
	s ChildSub=0
	for 
	{
		set ChildSub=$o(^SSU("SSUSR",ParRef,"OTHLL",ChildSub)) q:ChildSub=""
		s OTHLLCTLOCDR=$p($g(^SSU("SSUSR",ParRef,"OTHLL",ChildSub)),"^",1)
		s OTHLLUserGroupDR=$p($g(^SSU("SSUSR",ParRef,"OTHLL",ChildSub)),"^",2)
		s Rowid=ParRef_"||"_ChildSub
		if ((OTHLLRowId="")||((OTHLLRowId'="")&&(Rowid'=OTHLLRowId)))&&(OTHLLCTLOCDR=LocDR)&(OTHLLUserGroupDR=GroupDR)
		{
			s OTHLLStartDate=$p($g(^SSU("SSUSR",ParRef,"OTHLL",ChildSub)),"^",4)
			s OTHLLEndDate=$p($g(^SSU("SSUSR",ParRef,"OTHLL",ChildSub)),"^",5)
			if (startdate'="")&&(OTHLLStartDate'="")
			{
				if ((OTHLLEndDate="")&&(enddate=""))||((OTHLLEndDate'="")&&(startdate<=OTHLLEndDate))||((enddate'="")&&(OTHLLStartDate<=enddate))
				{
					s flag=1  //返回重复标志
				}
				
			}
		}
	}
	q flag
}

/// Creator：蔡昊哲
/// CreatDate: 2013-4-25
/// Description：保存修改
ClassMethod SaveData(eobj As web.Entity.CT.SSUserOtherLogonLoc, SyncRBFlag As %String = "Y") As %String
{
	s Flag=..IsHaveUpdateAut(eobj.OTHLLRowId)
	if Flag="N" 
	{
		s result = "{success:'false',info:'已开启医院级授权，您没有操作这条数据的权限'}"
	}
	s result=""
	;s:eobj.OTHLLStartDate'="" eobj.OTHLLStartDate=$zdh(eobj.OTHLLStartDate,15) 
	;s:eobj.OTHLLEndDate'="" eobj.OTHLLEndDate=$zdh(eobj.OTHLLEndDate,15)     
	s:eobj.OTHLLStartDate'="" eobj.OTHLLStartDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.OTHLLStartDate)
	s:eobj.OTHLLEndDate'="" eobj.OTHLLEndDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.OTHLLEndDate)   
	s:eobj.OTHLLStartDate="" eobj.OTHLLStartDate=+$h
	if eobj.OTHLLCTLOCDR'="" s eobj.OTHLLHospitalDR=$p($g(^CTLOC(eobj.OTHLLCTLOCDR)),"^",22)
	if eobj.OTHLLParRef="" s eobj.OTHLLParRef=$p(eobj.OTHLLRowId,"||",1)
	s flag=..FormValidate(eobj.OTHLLParRef,eobj.OTHLLRowId,eobj.OTHLLCTLOCDR,eobj.OTHLLUserGroupDR,eobj.OTHLLStartDate,eobj.OTHLLEndDate)  //调用重复验证
	if (flag=1)
	{
		q "{success:'false',errorinfo:'存在重复数据！'}"
	}
	if (eobj.OTHLLRowId="")
	{	
		s obj=##class(User.SSUserOtherLogonLoc).%New(eobj.OTHLLParRef)
	}
	else   //修改
	{
    	s obj=##class(User.SSUserOtherLogonLoc).%OpenId(eobj.OTHLLRowId)
    	s bobj=##class(web.Entity.CT.SSUserOtherLogonLoc).%New()
    	s bobj.OTHLLRowId = eobj.OTHLLRowId
    	s bobj.OTHLLParRef = $p(eobj.OTHLLRowId,"||",1)
		s:obj.OTHLLCTLOCDR'="" bobj.OTHLLCTLOCDR = obj.OTHLLCTLOCDR.%Id()
		s:obj.OTHLLUserGroupDR'="" bobj.OTHLLUserGroupDR = obj.OTHLLUserGroupDR.%Id()	
		s:obj.OTHLLHospitalDR'="" bobj.OTHLLHospitalDR = obj.OTHLLHospitalDR.%Id()	
		s bobj.OTHLLStartDate = obj.OTHLLStartDate
		s bobj.OTHLLEndDate = obj.OTHLLEndDate
	}
	d obj.OTHLLParRefSetObjectId(eobj.OTHLLParRef)
	d obj.OTHLLCTLOCDRSetObjectId(eobj.OTHLLCTLOCDR)
	d obj.OTHLLUserGroupDRSetObjectId(eobj.OTHLLUserGroupDR)
	s obj.OTHLLStartDate = eobj.OTHLLStartDate
	s obj.OTHLLEndDate = eobj.OTHLLEndDate
	d obj.OTHLLHospitalDRSetObjectId(eobj.OTHLLHospitalDR)	
	
  	
	Ts
	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc){
		Tc
		s id = obj.%Id()
		
		s:eobj.OTHLLCTLOCDR'="" CTLOCDesc=$p($g(^CTLOC(eobj.OTHLLCTLOCDR)),"^",2)
  		s:eobj.OTHLLCTLOCDR="" CTLOCDesc=""
		d:eobj.OTHLLRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("SS_UserOtherLogonLoc","User.SSUserOtherLogonLoc","其他登录科室",id,CTLOCDesc,"A",eobj,"",eobj.OTHLLParRef)
		d:eobj.OTHLLRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("SS_UserOtherLogonLoc","User.SSUserOtherLogonLoc","其他登录科室",eobj.OTHLLRowId,CTLOCDesc,"U",eobj,bobj,eobj.OTHLLParRef)	
		
		//同时保存医护人员医院关联 20200521 likefan
		s SSUSRRowId=eobj.OTHLLParRef
		s SSUSRCareProvDR=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",14)      //医护人员DR
		if (SSUSRCareProvDR'="")
		{
			s hospeobj=##class(web.Entity.CT.CTCareProvHospitals).%New()
			s hospeobj.HOSPRowId=""
			s hospeobj.HOSPParRef=SSUSRCareProvDR
			s hospeobj.HOSPHospitalDR=eobj.OTHLLHospitalDR
			if hospeobj.HOSPHospitalDR'=""
			{
				d ##class(web.DHCBL.CT.CTCareProvHospitals).SaveEntity(hospeobj)
			}
		}
		
  		;同时指定科室
  		if SyncRBFlag="Y"
  		{
	  		s SSUSRCareProvDR=$p($g(^SSU("SSUSR",$p(id,"||",1))),"^",14)
			if SSUSRCareProvDR'=""
			{
				if (eobj.OTHLLRowId="")
				{
					if (eobj.OTHLLCTLOCDR'="")
					{
						D ##class(web.DHCBL.CT.CTCareProv).UpdateRBData(SSUSRCareProvDR,eobj.OTHLLCTLOCDR,"Add",eobj.OTHLLStartDate,eobj.OTHLLEndDate,id)	
					}
				}
				else
				{
					if ((bobj.OTHLLCTLOCDR'="")&(eobj.OTHLLCTLOCDR'=bobj.OTHLLCTLOCDR))
					{
						D ##class(web.DHCBL.CT.CTCareProv).UpdateRBData(SSUSRCareProvDR,bobj.OTHLLCTLOCDR,"Update",eobj.OTHLLStartDate,+$h)
						D ##class(web.DHCBL.CT.CTCareProv).UpdateRBData(SSUSRCareProvDR,eobj.OTHLLCTLOCDR,"Add",eobj.OTHLLStartDate,eobj.OTHLLEndDate)											
					}
					if (eobj.OTHLLEndDate'=bobj.OTHLLEndDate)
					{
						D ##class(web.DHCBL.CT.CTCareProv).UpdateRBData(SSUSRCareProvDR,eobj.OTHLLCTLOCDR,"Update",eobj.OTHLLStartDate,eobj.OTHLLEndDate)											
					}
		  		}
			}
  		}
		s result = "{success:'true',id:'"_id_"'}"        //返回RowId
	}else{
		Trollback
		s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
		s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("其他登录科室","web.DHCBL.CT.SSUserOtherLogonLoc","SaveData",eobj)
		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
	q result
}

/// Function:保存多条其他登录科室数据
/// CreateDate:2013-07-16
/// Creator:基础数据平台公共产品组 chz
/// Tables:  SS_UserOtherLogonLoc
/// d ##class(web.DHCBL.CT.SSUserOtherLogonLoc).SaveAll("4499","^7^^2019-06-10^^*4^1^2^2019-06-10^^4499||3*25^3^2^2019-06-10^^4499||2")
ClassMethod SaveAll(ssusrrowid As %String, locstr As %String) As %String
{
	s result=""
	if (locstr'="")
	{
		s loclength=$Length(locstr,"*")
		for i=1:1:loclength
		{
			s eobj=##class(web.Entity.CT.SSUserOtherLogonLoc).%New()
			s str=$p(locstr,"*",i)
			s eobj.OTHLLParRef = ssusrrowid
			s eobj.OTHLLRowId = $p(str,"^",1)
			s Flag=..IsHaveUpdateAut($p(str,"^",1))
			if Flag="N" 
			{
				s result = "{success:'false',errorinfo:'已开启医院级授权，您没有操作这条数据的权限'}"
				q
			}
			else
			{
				s eobj.OTHLLCTLOCDR = $p(str,"^",2)
				s eobj.OTHLLUserGroupDR = $p(str,"^",3)
				s:eobj.OTHLLCTLOCDR'="" eobj.OTHLLHospitalDR=$p($g(^CTLOC(eobj.OTHLLCTLOCDR)),"^",22)
				s eobj.OTHLLStartDate = $p(str,"^",4)
				s eobj.OTHLLEndDate = $p(str,"^",5)
				s SyncRBFlag = $p(str,"^",6)
				
				s result= ##class(web.DHCBL.CT.SSUserOtherLogonLoc).SaveData(eobj,SyncRBFlag)
			}
				
		}
		//update by程鹏 新增项目现在用的同步程序，用户新增安全组，同步角色到portal
		//update start
		s PortalFlag=##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPUsePortal")
		if (PortalFlag="Y"){
			s myobj=##class(%Dictionary.CompiledMethod).%OpenId("DtPortal.Configure.DataSync||SyncUserSoap")
			i $IsObject(myobj)
			{
				d ##class(DtPortal.Configure.DataSync).SyncUserSoap(ssusrrowid,1)	
			}
		}
		//update end	
	}
	q result
}

/// Function:删除其他登录科室数据
/// CreateDate:2013-07-16
/// Creator:基础数据平台公共产品组 chz
/// Tables:  SS_UserOtherLogonLoc
/// d ##class(web.DHCBL.CT.SSUserOtherLogonLoc).DeleteData("1077||15")  
ClassMethod DeleteData(id) As %String
{
	s result=""
	if (id'="")
	{
		s Flag=..IsHaveUpdateAut(id)
		if Flag="N" 
		{
			s result = "{success:'false',info:'已开启医院级授权，您没有操作这条数据的权限'}"
		}
		s eobj = ##class(web.Entity.CT.SSUserOtherLogonLoc).%New()
		s obj=##class(User.SSUserOtherLogonLoc).%OpenId(id)		
		s eobj.OTHLLRowId = id
		s ChildSub=$p($g(id),"||",2) ///判断为第几个孩子
		s ParRef=$p($g(id),"||",1)  
		s OTHLLRowId=id
		s:ParRef'="" SSUSRName=$p($g(^SSU("SSUSR",ParRef)),"^",2)       //用户名
		s OTHLLCTLOCDR=$p($g(^SSU("SSUSR",ParRef,"OTHLL",ChildSub)),"^",1)
		s OTHLLUserGroupDR=$p($g(^SSU("SSUSR",ParRef,"OTHLL",ChildSub)),"^",2)
		s OTHLLHospitalDR=$p($g(^SSU("SSUSR",ParRef,"OTHLL",ChildSub)),"^",3)
		s:OTHLLCTLOCDR'="" CTLOCDesc=$p($g(^CTLOC(OTHLLCTLOCDR)),"^",2)
		s:OTHLLCTLOCDR="" CTLOCDesc=""
		s:obj.OTHLLCTLOCDR'="" eobj.OTHLLCTLOCDR = obj.OTHLLCTLOCDR.%Id()	
		s:obj.OTHLLUserGroupDR'="" eobj.OTHLLUserGroupDR = obj.OTHLLUserGroupDR.%Id()
		s:obj.OTHLLHospitalDR'="" eobj.OTHLLHospitalDR = obj.OTHLLHospitalDR.%Id()
		s eobj.OTHLLStartDate = obj.OTHLLStartDate
		s eobj.OTHLLEndDate = obj.OTHLLEndDate
		s sc = ##class(User.SSUserOtherLogonLoc).%DeleteId(id)
		if $$$ISOK(sc)
		{
			
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("SS_UserOtherLogonLoc","User.SSUserOtherLogonLoc","其他登录科室",id,CTLOCDesc,"D",eobj,"",ParRef)
			s result = "{success:'true',info:'删除成功！'}"    
			
			;指定科室截止关联
			s SSUSRCareProvDR=$p($g(^SSU("SSUSR",ParRef)),"^",14) 
			if (SSUSRCareProvDR'="")&&(OTHLLCTLOCDR'="")
			{
				D ##class(web.DHCBL.CT.CTCareProv).UpdateRBData(SSUSRCareProvDR,OTHLLCTLOCDR,"Update","",+$h)
			}
		}
		else 
		{
			s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("其他登录科室","web.DHCBL.CT.SSUserOtherLogonLoc","DeleteData",eobj)
			s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	else{
		s result = "{success:'false',info:'该对象还未保存！'}"  //返回错误信息   
	}
	q result
}

/// Creator:陈莹
/// CreatDate:2020-04-08
/// Description:判断开启医院级授权后。前台这个用户是否有删除和修改数据的权限
/// Table:User.SSUserOtherLogonLoc
/// Input:OTHLLRowId(其他登录科室的rowid)
/// Return:Y有权限，N无权限
ClassMethod IsHaveUpdateAut(OTHLLRowId As %String) As %String
{
	q:OTHLLRowId="" "Y"
	s flag = ##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPHospAut")  //获取平台配置是否开启医院级别授权
	if flag = "N" Q "Y"						//如果没开启医院级别授权  则没有任何限制
	
	s ParRef=$p(OTHLLRowId,"||",1)  
	s ChildSub=$p(OTHLLRowId,"||",2)
	s OTHLLCTLOCDR=$p($g(^SSU("SSUSR",ParRef,"OTHLL",ChildSub)),"^",1)
	if OTHLLCTLOCDR'=""
	{
		s AuHospStr=##class(web.DHCBL.Authorize.BDPHospitalAut).GetHospAutFlag()
		s CTLOCHospitalDR=$p($g(^CTLOC(OTHLLCTLOCDR)),"^",22)     //医院
		s strHospitalID = "{ID:"_CTLOCHospitalDR_"}"
		if ((AuHospStr[strHospitalID)||(AuHospStr=1)||(AuHospStr="off")) 
		{
			s flag= "Y"
		}
		else
		{
			s flag= "N"
		}
	}
	q flag
}

/// Creator: likefan
/// CreatDate: 2021-03-16
/// Description: 删除某个用户的所有其他登录科室数据
/// Input: 其他登录科室rowid串
/// Return: 1
ClassMethod DeleteSelections(idstr As %String) As %String
{
	q:idstr="" ""
	for i=1:1:$l(idstr,"^")
	{
		s id=$p(idstr,"^",i)
		s re=..DeleteData(id)
	}
	q 1
}

/// 处理其他登录科室数据计数器错误的问题
/// likefan 2022-12-07
/// w ##class(web.DHCBL.CT.SSUserOtherLogonLoc).ProcessingData()
ClassMethod ProcessingData() As %String
{
	s count=0
	s UserId=0
	for  
	{
		s UserId=$o(^SSU("SSUSR",UserId)) q:UserId=""
		s Last=$o(^SSU("SSUSR",UserId,"OTHLL",""),-1)	//最后一个id
		if (Last'="")&&(Last'=0)
		{
			s CountNum=^SSU("SSUSR",UserId,"OTHLL",0)	//计数器
			if (CountNum'=Last)
			{
				s count=count+1
				w "RowId: "_UserId_" CountId: "_CountNum_" LastId: "_Last,!
				s ^SSU("SSUSR",UserId,"OTHLL",0)=Last
			}
		}
	}
	q "total: "_count
}

}
