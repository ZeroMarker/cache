/// Function: 组织部门
/// CreateDate:2023-2-2
/// Creator:钟荣枫
Class web.DHCBL.CT.HOSDepartment Extends %RegisteredObject [ ProcedureBlock ]
{

/// Function：  组织部门信息查询
/// Creator:    钟荣枫
/// CreatDate:  2023-2-2
/// Table：     CT_BDP_CT.HOS_Department   
/// Other:      d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSDepartment","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID,DEPTCode,DEPTDesc,DEPTAbbrev,DEPTIntro,DEPTDeptCode,DEPTORGCode,DEPTORGACCode,DEPTAddress,DEPTTel,DEPTFax,DEPTEmail,DEPTFoundDate,DEPTCancelDate,DEPTActivity,DEPTStartDate,DEPTEndDate,DEPTSeqNo,DEPTPYCode,DEPTWBCode,DEPTMark")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    s AuStr=##class(web.DHCBL.Authorize.HOSDepartment).DHCGetDataByDefaultSession()
	s AuFlag=0
	s DeptAuFlag=0	
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1
	if (AuStr="")||(AuStr["limited:0") s DeptAuFlag=1
	
	s OrgAuStr=##class(web.DHCBL.Authorize.HOSOrganization).DHCGetDataByDefaultSession()
	s OrgAuFlag=0	
	if (OrgAuStr="")||(OrgAuStr["limited:0") s OrgAuFlag=1
	
	s AdminTypeAuStr=##class(web.DHCBL.Authorize.HOSOrgAdminType).DHCGetDataByDefaultSession()
	s AdminTypeAuFlag=0	
	if (AdminTypeAuStr="")||(AdminTypeAuStr["limited:0") s AdminTypeAuFlag=1
	
	
    if (rowid'="") //根据rowid返回该条记录
    { 
        s ID=rowid


	    s DEPTCode=$listget($g(^CT.BDP.CT.HOSDepartmentD(ID)),2)	//部门代码
	    s DEPTDesc=$listget($g(^CT.BDP.CT.HOSDepartmentD(ID)),3)	//部门名称
		s DEPTAbbrev=$listget($g(^CT.BDP.CT.HOSDepartmentD(ID)),4)		//部门简称
		s DEPTIntro=$listget($g(^CT.BDP.CT.HOSDepartmentD(ID)),5)		//部门简介
		
		
		s DEPTDeptCode =$listget($g(^CT.BDP.CT.HOSDepartmentD(ID)),6) 	//上级部门
		s:DEPTDeptCode'="" DEPTDeptCode=$listget($g(^CT.BDP.CT.HOSDepartmentD(DEPTDeptCode)),3)
		s DEPTORGCode =$listget($g(^CT.BDP.CT.HOSDepartmentD(ID)),7) 	//所属机构
		s:DEPTORGCode'="" DEPTORGCode=$listget($g(^CT.BDP.CT.HOSOrganizationD(DEPTORGCode)),3)
		s DEPTORGACCode =$listget($g(^CT.BDP.CT.HOSDepartmentD(ID)),8) 	//行政类型
		s:DEPTORGACCode'="" DEPTORGACCode=$listget($g(^CT.BDP.CT.HOSOrgAdminTypeD(DEPTORGACCode)),3)
		
		s DEPTAddress=$listget($g(^CT.BDP.CT.HOSDepartmentD(ID)),9) 		//部门地址（位置）
		s DEPTTel=$listget($g(^CT.BDP.CT.HOSDepartmentD(ID)),10) 		//联系电话
		s DEPTFax=$listget($g(^CT.BDP.CT.HOSDepartmentD(ID)),11) 		//传真
		s DEPTEmail=$listget($g(^CT.BDP.CT.HOSDepartmentD(ID)),12) 		//邮件
		s DEPTFoundDate=$listget($g(^CT.BDP.CT.HOSDepartmentD(ID)),13) 		//建立日期
		s:DEPTFoundDate'="" DEPTFoundDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(DEPTFoundDate)
		s DEPTCancelDate=$listget($g(^CT.BDP.CT.HOSDepartmentD(ID)),14) 		//注销日期
		s:DEPTCancelDate'="" DEPTCancelDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(DEPTCancelDate)
				
	    
		s DEPTActivity=$listget($g(^CT.BDP.CT.HOSDepartmentD(ID)),15)	//是否有效(Y/N)
		s DEPTStartDate=$listget($g(^CT.BDP.CT.HOSDepartmentD(ID)),16)		//开始日期
		s:DEPTStartDate'="" DEPTStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(DEPTStartDate) 
		s DEPTEndDate=$listget($g(^CT.BDP.CT.HOSDepartmentD(ID)),17)		//结束日期
		s:DEPTEndDate'="" DEPTEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(DEPTEndDate) 
		s DEPTSeqNo=$listget($g(^CT.BDP.CT.HOSDepartmentD(ID)),21)		//系统排序号
		
		s DEPTPYCode=$listget($g(^CT.BDP.CT.HOSDepartmentD(ID)),25)		//拼音码
		s DEPTWBCode=$listget($g(^CT.BDP.CT.HOSDepartmentD(ID)),26)		//五笔码
		s DEPTMark=$listget($g(^CT.BDP.CT.HOSDepartmentD(ID)),27)		//备注

		
        d OutputRow
    }
    else
    {  
        s ID=0
        for 
        {
            s ID=$o(^CT.BDP.CT.HOSDepartmentD(ID))
            q:ID="" 
            s DEPTDeptCode =$listget($g(^CT.BDP.CT.HOSDepartmentD(ID)),6) 	//上级部门
            s DEPTORGCode =$listget($g(^CT.BDP.CT.HOSDepartmentD(ID)),7) 	//所属机构
            s DEPTORGACCode =$listget($g(^CT.BDP.CT.HOSDepartmentD(ID)),8) 	//行政类型
            
            s strRowId = "{ID:"_ID_"}"
            s DeptCodestrRowId="",ORGCodestrRowId="",ORGACCodestrRowId=""
            s:DEPTDeptCode'="" DeptCodestrRowId = "{ID:"_DEPTDeptCode_"}"
            s:DEPTORGCode'="" ORGCodestrRowId = "{ID:"_DEPTORGCode_"}"
            s:DEPTORGACCode'="" ORGACCodestrRowId = "{ID:"_DEPTORGACCode_"}"
			i ((AuStr[strRowId)||(AuFlag=1))&&((AuStr[DeptCodestrRowId)||(DeptAuFlag=1))&&((OrgAuStr[ORGCodestrRowId)||(OrgAuFlag=1))&&((AdminTypeAuStr[ORGACCodestrRowId)||(AdminTypeAuFlag=1)) ;用来筛选授权数据，如果未授权情况下筛选无效
			{
	            s DEPTCode=$listget($g(^CT.BDP.CT.HOSDepartmentD(ID)),2)	//部门代码
			    s DEPTDesc=$listget($g(^CT.BDP.CT.HOSDepartmentD(ID)),3)	//部门名称
				s DEPTAbbrev=$listget($g(^CT.BDP.CT.HOSDepartmentD(ID)),4)		//部门简称
				s DEPTIntro=$listget($g(^CT.BDP.CT.HOSDepartmentD(ID)),5)		//部门简介
				
				
				s:DEPTDeptCode'="" DEPTDeptCode=$listget($g(^CT.BDP.CT.HOSDepartmentD(DEPTDeptCode)),3)
				
				s:DEPTORGCode'="" DEPTORGCode=$listget($g(^CT.BDP.CT.HOSOrganizationD(DEPTORGCode)),3)
				
				s:DEPTORGACCode'="" DEPTORGACCode=$listget($g(^CT.BDP.CT.HOSOrgAdminTypeD(DEPTORGACCode)),3)
				
				s DEPTAddress=$listget($g(^CT.BDP.CT.HOSDepartmentD(ID)),9) 		//部门地址（位置）
				s DEPTTel=$listget($g(^CT.BDP.CT.HOSDepartmentD(ID)),10) 		//联系电话
				s DEPTFax=$listget($g(^CT.BDP.CT.HOSDepartmentD(ID)),11) 		//传真
				s DEPTEmail=$listget($g(^CT.BDP.CT.HOSDepartmentD(ID)),12) 		//邮件
				s DEPTFoundDate=$listget($g(^CT.BDP.CT.HOSDepartmentD(ID)),13) 		//建立日期
				s:DEPTFoundDate'="" DEPTFoundDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(DEPTFoundDate)
				s DEPTCancelDate=$listget($g(^CT.BDP.CT.HOSDepartmentD(ID)),14) 		//注销日期
				s:DEPTCancelDate'="" DEPTCancelDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(DEPTCancelDate)		
			    
				s DEPTActivity=$listget($g(^CT.BDP.CT.HOSDepartmentD(ID)),15)	//是否有效(Y/N)
				s DEPTStartDate=$listget($g(^CT.BDP.CT.HOSDepartmentD(ID)),16)		//开始日期
				s:DEPTStartDate'="" DEPTStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(DEPTStartDate) 
				s DEPTEndDate=$listget($g(^CT.BDP.CT.HOSDepartmentD(ID)),17)		//结束日期
				s:DEPTEndDate'="" DEPTEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(DEPTEndDate) 
				s DEPTSeqNo=$listget($g(^CT.BDP.CT.HOSDepartmentD(ID)),21)		//系统排序号
				
				s DEPTPYCode=$listget($g(^CT.BDP.CT.HOSDepartmentD(ID)),25)		//拼音码
				s DEPTWBCode=$listget($g(^CT.BDP.CT.HOSDepartmentD(ID)),26)		//五笔码
				s DEPTMark=$listget($g(^CT.BDP.CT.HOSDepartmentD(ID)),27)		//备注
	            if (($zcvt(DEPTCode,"U")[$zcvt(code,"U"))||(code=""))&(($zcvt(DEPTDesc,"U")[$zcvt(desc,"U"))||($zcvt(DEPTPYCode,"U")[$zcvt(desc,"U"))||(desc=""))
	            {
	                d OutputRow
	            }  
			}
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow  
    set Data=$lb(ID,DEPTCode,DEPTDesc,DEPTAbbrev,DEPTIntro,DEPTDeptCode,DEPTORGCode,DEPTORGACCode,DEPTAddress,DEPTTel,DEPTFax,DEPTEmail,DEPTFoundDate,DEPTCancelDate,DEPTActivity,DEPTStartDate,DEPTEndDate,DEPTSeqNo,DEPTPYCode,DEPTWBCode,DEPTMark)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
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
    If ind=""
    {
        //if there are no more rows,finish fetching...
        Set AtEnd=1
        Set Row=""
    }
    Else
    {
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

/// Function: combox查询提供接口 
/// Creator:  钟荣枫
/// CreatDate:2023-2-2
/// Tables: CT_BDP_CT.HOS_Department
/// Input:  code,desc  
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSDepartment", "GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID:%String,DEPTCode,DEPTDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	
  	Set repid=$I(^CacheTemp)
  	s ind=1
  	s AuStr=##class(web.DHCBL.Authorize.HOSDepartment).DHCGetDataByDefaultSession()
	s AuFlag=0
	s DeptAuFlag=0	
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1
	if (AuStr="")||(AuStr["limited:0") s DeptAuFlag=1
	
	s OrgAuStr=##class(web.DHCBL.Authorize.HOSOrganization).DHCGetDataByDefaultSession()
	s OrgAuFlag=0	
	if (OrgAuStr="")||(OrgAuStr["limited:0") s OrgAuFlag=1
	
	s AdminTypeAuStr=##class(web.DHCBL.Authorize.HOSOrgAdminType).DHCGetDataByDefaultSession()
	s AdminTypeAuFlag=0	
	if (AdminTypeAuStr="")||(AdminTypeAuStr["limited:0") s AdminTypeAuFlag=1
	
	 
  	if (rowid'="")  
  	{
	  	s ID=rowid
	  	s DEPTCode=$listget($g(^CT.BDP.CT.HOSDepartmentD(ID)),2)	//部门代码
    	s DEPTDesc= $listget($g(^CT.BDP.CT.HOSDepartmentD(ID)),3)	//部门名称
    	d OutputRowCmb
  	}
  	else
  	{
    	s ID=0
    	for 
    	{
       		s ID=$o(^CT.BDP.CT.HOSDepartmentD(ID))
       		q:ID="" 
       		s DEPTDeptCode =$listget($g(^CT.BDP.CT.HOSDepartmentD(ID)),6) 	//上级部门
            s DEPTORGCode =$listget($g(^CT.BDP.CT.HOSDepartmentD(ID)),7) 	//所属机构
            s DEPTORGACCode =$listget($g(^CT.BDP.CT.HOSDepartmentD(ID)),8) 	//行政类型
            
            s strRowId = "{ID:"_ID_"}"
            s DeptCodestrRowId="",ORGCodestrRowId="",ORGACCodestrRowId=""
            s:DEPTDeptCode'="" DeptCodestrRowId = "{ID:"_DEPTDeptCode_"}"
            s:DEPTORGCode'="" ORGCodestrRowId = "{ID:"_DEPTORGCode_"}"
            s:DEPTORGACCode'="" ORGACCodestrRowId = "{ID:"_DEPTORGACCode_"}"
			i ((AuStr[strRowId)||(AuFlag=1))&&((AuStr[DeptCodestrRowId)||(DeptAuFlag=1))&&((OrgAuStr[ORGCodestrRowId)||(OrgAuFlag=1))&&((AdminTypeAuStr[ORGACCodestrRowId)||(AdminTypeAuFlag=1)) ;用来筛选授权数据，如果未授权情况下筛选无效
			{				
	       		s DEPTCode=$listget($g(^CT.BDP.CT.HOSDepartmentD(ID)),2)	//部门代码
		    	s DEPTDesc= $listget($g(^CT.BDP.CT.HOSDepartmentD(ID)),3)	//部门名称
		    	
		    	s DEPTActivity=$listget($g(^CT.BDP.CT.HOSDepartmentD(ID)),15)	//是否有效(Y/N)
				continue:DEPTActivity="N"
				s DEPTStartDate=$listget($g(^CT.BDP.CT.HOSDepartmentD(ID)),16)		//开始日期
				continue:((DEPTStartDate'="")&&(DEPTStartDate>+$h)) 
				s DEPTEndDate=$listget($g(^CT.BDP.CT.HOSDepartmentD(ID)),17)		//结束日期
				continue:((DEPTEndDate'="")&&(DEPTEndDate<+$h))
				s DEPTPYCode=$listget($g(^CT.BDP.CT.HOSDepartmentD(ID)),25)		//拼音码 			
				  		
				if (($zcvt(DEPTCode,"U")[$zcvt(code,"U"))||(code=""))&(($zcvt(DEPTDesc,"U")[$zcvt(desc,"U"))||($zcvt(DEPTPYCode,"U")[$zcvt(desc,"U"))||(desc=""))
	            {
		        	d OutputRowCmb
		    	}
			}
    	}
  	} 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb   
 set Data=$lb(ID,DEPTCode,DEPTDesc)
  Set ^CacheTemp(repid,ind)=Data
  Set ind=ind+1
  q
}

ClassMethod GetDataForCmb1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
 Set repid=$LIST(qHandle,2)
  Kill ^CacheTemp(repid)  
  Quit $$$OK
}

ClassMethod GetDataForCmb1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
 
  Set AtEnd=$LIST(qHandle,1)
  Set repid=$LIST(qHandle,2)
  Set ind=$LIST(qHandle,3)
  Set ind=$o(^CacheTemp(repid,ind))
  If ind="" {    // if there are no more rows, finish fetching
   Set AtEnd=1
   Set Row=""
  }
  Else      {    // fetch row
   Set Row=^CacheTemp(repid,ind)
  }
  s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

/// Function： 修改时打开的数据
/// Creator:   钟荣枫
/// CreatDate: 2020-07-08
/// Input：    id    
/// Other:     w ##class(web.DHCBL.CT.HOSDepartment).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.CT.HOSDepartment).%New()
    s pobj = ##class(CT.BDP.CT.HOSDepartment).%OpenId(id)
    s eobj.ID=id
    s eobj.DEPTCode=pobj.DEPTCode	//部门代码
    s eobj.DEPTDesc= pobj.DEPTDesc	//部门名称
	s eobj.DEPTAbbrev=pobj.DEPTAbbrev		//部门简称
	s eobj.DEPTIntro=pobj.DEPTIntro		//部门简介

	if $IsObject(pobj.DEPTDeptCode){
		s eobj.DEPTDeptCode = pobj.DEPTDeptCode.%Id() 	//上级部门
	}
	if $IsObject(pobj.DEPTORGCode){
		s eobj.DEPTORGCode = pobj.DEPTORGCode.%Id() 	//所属机构
	}
	if $IsObject(pobj.DEPTORGACCode){
		s eobj.DEPTORGACCode = pobj.DEPTORGACCode.%Id() 	//行政类型
	}
	
	s eobj.DEPTAddress=pobj.DEPTAddress		//部门地址（位置）
	s eobj.DEPTTel=pobj.DEPTTel		//联系电话
	s eobj.DEPTFax=pobj.DEPTFax		//传真
	s eobj.DEPTEmail=pobj.DEPTEmail		//邮件
	s eobj.DEPTFoundDate=pobj.DEPTFoundDate		//建立日期
	s eobj.DEPTCancelDate=pobj.DEPTCancelDate		//注销日期
	
	s eobj.DEPTActivity=pobj.DEPTActivity	//是否有效(Y/N)
	s eobj.DEPTStartDate=pobj.DEPTStartDate		//开始日期
	s:eobj.DEPTStartDate'="" eobj.DEPTStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.DEPTStartDate) 
	s eobj.DEPTEndDate=pobj.DEPTEndDate		//结束日期
	s:eobj.DEPTEndDate'="" eobj.DEPTEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.DEPTEndDate) 
	
	s eobj.DEPTSeqNo=pobj.DEPTSeqNo		//系统排序号
	
	s eobj.DEPTPYCode=pobj.DEPTPYCode		//拼音码
	s eobj.DEPTWBCode=pobj.DEPTWBCode		//五笔码
	s eobj.DEPTMark=pobj.DEPTMark		//备注
		
    s str = eobj.JsonS()    
    d eobj.%Close()
    d pobj.%Close()
    q str
}

/// Function：数据重复验证方法 
/// Creator:  钟荣枫
/// CreatDate:2023-2-2
/// Table：   CT.BDP.CT.HOSDepartment
/// Input：   id-rowid, code-代码,desc-描述
/// Return：  "1"(数据重复),"0"(数据不重复)
/// Other:    d ##class(web.DHCBL.CT.HOSDepartment).FormValidate("","","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String, DeptCode) As %String
{
    s flag=0
    s:DeptCode="" DeptCode="-100000000000000"
    if (code'="")
    {
	    s idc=$o(^CT.BDP.CT.HOSDepartmentI("IndexLevelCode",DeptCode,code,0))
	    if (idc'="")&&(idc'=id)
	    {
		 	s flag=1   
	    }
    }
    if (desc'="")
    {
	    
		s idd=$o(^CT.BDP.CT.HOSDepartmentI("IndexLevelDesc",DeptCode,desc,0)) 
		if (idd'="")&&(idd'=id)
	    {
		 	s flag=1   
	    }
    }
    
    q flag
}

/// Function    保存组织部门内容
/// Creator:    钟荣枫
/// CreatDate:  2023-2-2
/// Table：     CT.BDP.CT.HOSDepartment
/// Input：     web.Entity.CT.HOSDepartment  
/// Return：    成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other:      d ##class(web.DHCBL.CT.HOSDepartment).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.CT.HOSDepartment) As %String
{
 
    s result="" 
    s UserID=""
    if ($d(%session)>0)
    {
	 	s UserID=$g(%session.Data("LOGON.USERID"))  
    } 
	s eobj.DEPTDesc=$Zstrip(eobj.DEPTDesc,"<>W")	//去除前后空格
    s:eobj.DEPTStartDate'="" eobj.DEPTStartDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.DEPTStartDate) 
    s:eobj.DEPTEndDate'="" eobj.DEPTEndDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.DEPTEndDate)
    s:eobj.DEPTStartDate="" eobj.DEPTStartDate=+$h
    s:eobj.DEPTLastUpdateDate="" eobj.DEPTLastUpdateDate=+$h		//系统最后更新日期
    s:eobj.DEPTLastUpdateTime="" eobj.DEPTLastUpdateTime=$p($h,",",2)		//系统最后更新时间
    s:eobj.DEPTLastUpdateUser="" eobj.DEPTLastUpdateUser=UserID	//系统最新更新人
    s:eobj.DEPTActivity="" eobj.DEPTActivity="N"		//是否有效
    s flag=  ..FormValidate(eobj.ID,eobj.DEPTCode,eobj.DEPTDesc,eobj.DEPTDeptCode)  //调用重复验证
    if (flag=1)
    {
        s result = "{success:'false',errorinfo:'该记录已经存在！'}"
    }
    else
    {
        if (eobj.ID="")  
        {
            s obj=##class(CT.BDP.CT.HOSDepartment).%New()
            //s eobj.DEPTSeqNo=..GetSeqNo()
            s:eobj.DEPTCreateDate="" eobj.DEPTCreateDate=+$h	//系统创建日期默认当前日期
		    s:eobj.DEPTCreateTime="" eobj.DEPTCreateTime=$p($h,",",2)	//系统创建时间默认当前时间
		    s:eobj.DEPTCreateUser="" eobj.DEPTCreateUser= UserID		//系统创建人默认当前登录人员
		    s obj.DEPTCreateDate=eobj.DEPTCreateDate		//系统创建日期
			s obj.DEPTCreateTime=eobj.DEPTCreateTime		//系统创建时间
			d obj.DEPTCreateUserSetObjectId(eobj.DEPTCreateUser)	//系统创建人
        }
        else              
        {
            s obj=##class(CT.BDP.CT.HOSDepartment).%OpenId(eobj.ID)
            s bobj=##class(web.Entity.CT.HOSDepartment).%New()
            s bobj.ID=eobj.ID 
            s bobj.DEPTCode=obj.DEPTCode	//部门代码
            s bobj.DEPTDesc= obj.DEPTDesc	//部门名称
			s bobj.DEPTAbbrev=obj.DEPTAbbrev		//部门简称
			s bobj.DEPTIntro=obj.DEPTIntro		//部门简介

			if $IsObject(obj.DEPTDeptCode){
				s bobj.DEPTDeptCode = obj.DEPTDeptCode.%Id() 	//上级部门
			}
			if $IsObject(obj.DEPTORGCode){
				s bobj.DEPTORGCode = obj.DEPTORGCode.%Id() 	//所属机构
			}
			if $IsObject(obj.DEPTORGACCode){
				s bobj.DEPTORGACCode = obj.DEPTORGACCode.%Id() 	//行政类型
			}
			
			s bobj.DEPTAddress=obj.DEPTAddress		//部门地址（位置）
			s bobj.DEPTTel=obj.DEPTTel		//联系电话
			s bobj.DEPTFax=obj.DEPTFax		//传真
			s bobj.DEPTEmail=obj.DEPTEmail		//邮件
			s bobj.DEPTFoundDate=obj.DEPTFoundDate		//建立日期
			s bobj.DEPTCancelDate=obj.DEPTCancelDate		//注销日期
			
			s bobj.DEPTActivity=obj.DEPTActivity	//是否有效(Y/N)
			s bobj.DEPTStartDate=obj.DEPTStartDate		//开始日期
			s bobj.DEPTEndDate=obj.DEPTEndDate		//结束日期
			s bobj.DEPTCreateDate=obj.DEPTCreateDate		//系统创建日期
			s bobj.DEPTCreateTime=obj.DEPTCreateTime		//系统创建时间
			if $IsObject(obj.DEPTCreateUser){
				s bobj.DEPTCreateUser = obj.DEPTCreateUser.%Id() 	//系统创建人
			}
			s bobj.DEPTSeqNo=obj.DEPTSeqNo		//系统排序号
			s bobj.DEPTLastUpdateDate=obj.DEPTLastUpdateDate		//系统最后更新日期
			s bobj.DEPTLastUpdateTime=obj.DEPTLastUpdateTime		//系统最后更新时间
			if $IsObject(obj.DEPTLastUpdateUser){
				s bobj.DEPTLastUpdateUser = obj.DEPTLastUpdateUser.%Id() 	//系统最新更新人
			}
			s bobj.DEPTPYCode=obj.DEPTPYCode		//拼音码
			s bobj.DEPTWBCode=obj.DEPTWBCode		//五笔码
			s bobj.DEPTMark=obj.DEPTMark		//备注
        }
        
        s obj.DEPTCode=eobj.DEPTCode	//部门代码
        s obj.DEPTDesc= eobj.DEPTDesc	//部门名称
		s obj.DEPTAbbrev=eobj.DEPTAbbrev		//组织简称
		s obj.DEPTIntro=eobj.DEPTIntro		//部门简介
		
		
		d obj.DEPTDeptCodeSetObjectId(eobj.DEPTDeptCode) 	//上级部门
		d obj.DEPTORGCodeSetObjectId(eobj.DEPTORGCode) 	//所属机构
		d obj.DEPTORGACCodeSetObjectId(eobj.DEPTORGACCode) 	//行政类型
		
		
		s obj.DEPTAddress=eobj.DEPTAddress		//部门地址
		s obj.DEPTTel=eobj.DEPTTel		//联系电话
		s obj.DEPTFax=eobj.DEPTFax		//传真
		s obj.DEPTEmail=eobj.DEPTEmail		//邮件
		s obj.DEPTFoundDate=eobj.DEPTFoundDate		//建立日期
		s obj.DEPTCancelDate=eobj.DEPTCancelDate		//注销日期
		
		s obj.DEPTActivity=eobj.DEPTActivity	//是否有效(Y/N)
		s obj.DEPTStartDate=eobj.DEPTStartDate		//开始日期
		s obj.DEPTEndDate=eobj.DEPTEndDate		//结束日期

		s obj.DEPTSeqNo=eobj.DEPTSeqNo		//系统排序号
		s obj.DEPTLastUpdateDate=eobj.DEPTLastUpdateDate		//系统最后更新日期
		s obj.DEPTLastUpdateTime=eobj.DEPTLastUpdateTime		//系统最后更新时间
		d obj.DEPTLastUpdateUserSetObjectId(eobj.DEPTLastUpdateUser) 	//系统最新更新人
		s:eobj.DEPTPYCode="" eobj.DEPTPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE(eobj.DEPTDesc)
		s obj.DEPTPYCode=eobj.DEPTPYCode		//拼音码
		s:eobj.DEPTWBCode="" eobj.DEPTWBCode=##class(web.DHCBL.BDP.FunLib).GetSWBCODE(eobj.DEPTDesc,1)
		s obj.DEPTWBCode=eobj.DEPTWBCode		//五笔码
		s obj.DEPTMark=eobj.DEPTMark		//备注

		
        TSTART 
        s sc=obj.%Save()
        d obj.%Close()
        If $$$ISOK(sc)
        {
            TCOMMIT
            s id = obj.%Id()
            s result = "{success:'true',id:'"_id_"'}"  //返回RowId  
            d:eobj.ID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_Department","CT.BDP.CT.HOSDepartment","组织部门",id,eobj.DEPTDesc,"A",eobj)
            d:eobj.ID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_Department","CT.BDP.CT.HOSDepartment","组织部门",eobj.ID,eobj.DEPTDesc,"U",eobj,bobj)
        }
        else
        {
            Trollback
            s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
            s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("组织部门","web.DHCBL.CT.HOSDepartment","SaveEntity",eobj)
            s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
        }
    }  
     q result
}

/// Creator:钟荣枫
/// CreatDate:2023-2-2
/// Description：新增时获取顺序号
/// Table：CT.BDP.CT.HOSDepartment
/// Input：
/// Return：seq
/// Other:w ##class(web.DHCBL.CT.HOSDepartment).GetSeqNo()
ClassMethod GetSeqNo()
{
	s seq=""
	s seq=$o(^CT.BDP.CT.HOSDepartmentI("IndexSeqNo",""),-1)
	if (seq="")
	{
		s seq=1
	}
	else
	{
		s seq=seq+1
	}
	q seq
}

/// Creator:钟荣枫
/// CreatDate:2023-2-2
/// Description：删除限制
/// Table：CT.BDP.CT.HOSPost
/// Input：id
/// Return:1-被引用不可删除,0-未被引用可删除
/// Other:w ##class(web.DHCBL.CT.HOSDepartment).GetRefFlag("7")
ClassMethod GetRefFlag(id As %String) As %String
{
    s return="",myInfo=""
    if $d(^CTLOC(0,"DeptCode",id)){
        s myInfo=myInfo_"<组织业务单元>"
    }
    
    if $d(^CT.BDP.CT.HOSPositionI("IndexDeptCode",id)){
        s myInfo=myInfo_"<组织职位>"
    }
    if $d(^CT.BDP.CT.HOSDepartmentI("IndexDeptCode",id)){
        s myInfo=myInfo_"<组织部门>"
    }
    if $d(^CT.BDP.CT.HOSEmpPostionI("IndexDeptCode",id)){
        s myInfo=myInfo_"<人员职位>"
    }
    if $d(^CT.BDP.CT.HOSEmpProfTitleI("IndexDeptCode",id)){
        s myInfo=myInfo_"<人员职务>"
    }
    if $d(^CT.BDP.CT.HOSEmpPostI("IndexDeptCode",id)){
        s myInfo=myInfo_"<人员岗位>"
    }
    
    i myInfo="" s return="0^未被引用可删除！"
    else  s return="1^在"_myInfo_"表里被引用,不能删除！"
    
    q return
}

/// Creator:钟荣枫
/// CreatDate:2023-2-2
/// Description：根据ID删除组织部门的内容
/// Table：CT.BDP.CT.HOSDepartment
/// Input：id-知识库标识字典的rowid
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.CT.HOSDepartment).DeleteData("7")
ClassMethod DeleteData(id As %String) As %String
{
    s result="" 
    s re=..GetRefFlag(id)
    s RefFlag=$p(re,"^",1)
    if (RefFlag=0){
        
	    //new Entity对象，用于保存日志
	    s pobj = ##class(CT.BDP.CT.HOSDepartment).%OpenId(id)
	    s eobj = ##class(web.Entity.CT.HOSDepartment).%New()
	    s eobj.ID = id
	    s eobj.DEPTCode=pobj.DEPTCode	//部门代码
	    s eobj.DEPTDesc= pobj.DEPTDesc	//部门名称
		s eobj.DEPTAbbrev=pobj.DEPTAbbrev		//部门简称
		s eobj.DEPTIntro=pobj.DEPTIntro		//部门简介

		if $IsObject(pobj.DEPTDeptCode){
			s eobj.DEPTDeptCode = pobj.DEPTDeptCode.%Id() 	//上级部门
		}
		if $IsObject(pobj.DEPTORGCode){
			s eobj.DEPTORGCode = pobj.DEPTORGCode.%Id() 	//所属机构
		}
		if $IsObject(pobj.DEPTORGACCode){
			s eobj.DEPTORGACCode = pobj.DEPTORGACCode.%Id() 	//行政类型
		}
		
		s eobj.DEPTAddress=pobj.DEPTAddress		//部门地址（位置）
		s eobj.DEPTTel=pobj.DEPTTel		//联系电话
		s eobj.DEPTFax=pobj.DEPTFax		//传真
		s eobj.DEPTEmail=pobj.DEPTEmail		//邮件
		s eobj.DEPTFoundDate=pobj.DEPTFoundDate		//建立日期
		s eobj.DEPTCancelDate=pobj.DEPTCancelDate		//注销日期
		
		s eobj.DEPTActivity=pobj.DEPTActivity	//是否有效(Y/N)
		s eobj.DEPTStartDate=pobj.DEPTStartDate		//开始日期
		s eobj.DEPTEndDate=pobj.DEPTEndDate		//结束日期
		
		s eobj.DEPTSeqNo=pobj.DEPTSeqNo		//系统排序号
		
		s eobj.DEPTPYCode=pobj.DEPTPYCode		//拼音码
		s eobj.DEPTWBCode=pobj.DEPTWBCode		//五笔码
		s eobj.DEPTMark=pobj.DEPTMark		//备注

	    d pobj.%Close()
	    k pobj
	    Tstart
	    s sc=##class(CT.BDP.CT.HOSDepartment).%DeleteId(id)
	    if $$$ISOK(sc)
	    {
	        Tcommit
	        s result = "{success:'true',info:'删除成功！'}" 
	        //保存日志
	        d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_Department","CT.BDP.CT.HOSDepartment","组织部门",id,eobj.DEPTDesc,"D",eobj)
	        d eobj.%Close()
	        
	    }
	    else 
	    {
	        Trollback
	        s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	        s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("组织部门","web.DHCBL.CT.HOSDepartment","DeleteData",eobj)
	        s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
	    } 
        
    }
    else{
        s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
    }
    q result
}

/// Creator:钟荣枫
/// CreatDate:2023-2-7
/// Description：删除相关的global
/// Return：ok
/// Other:w ##class(web.DHCBL.CT.HOSDepartment).KillRelatedGlobal()
ClassMethod KillRelatedGlobal()
{
	//组织机构
	k ^CT.BDP.CT.HOSOrganizationD
	k ^CT.BDP.CT.HOSOrganizationI
	k ^CT.BDP.CT.HOSOrganizationC
	//职位字典
	k ^CT.BDP.CT.HOSPositionDictD
	k ^CT.BDP.CT.HOSPositionDictI
	//组织职位
	k ^CT.BDP.CT.HOSPositionD
	k ^CT.BDP.CT.HOSPositionI
	//业务岗位
	k ^CT.BDP.CT.HOSPostD
	k ^CT.BDP.CT.HOSPostI
	//岗位字典
	k ^CT.BDP.CT.HOSPostDictD
	k ^CT.BDP.CT.HOSPostDictI
	//组织机构行业分类字典
	k ^CT.BDP.CT.HOSOrgInduCategoryD
	k ^CT.BDP.CT.HOSOrgInduCategoryI	
	//组织机构专业分类字典
	k ^CT.BDP.CT.HOSOrgSpecCategoryD
	k ^CT.BDP.CT.HOSOrgSpecCategoryI
	//组织机构自主属性字典
	k ^CT.BDP.CT.HOSOrgIndepenTypeD
	k ^CT.BDP.CT.HOSOrgIndepenTypeI
	//组织级次字典
	k ^CT.BDP.CT.HOSORGHierarchyD
	k ^CT.BDP.CT.HOSORGHierarchyI
	
	
	
	q "ok"
}

/// Creator:钟荣枫
/// CreatDate:2023-5-22
/// Description：批处理组织部门的描述，去除前后空格
/// Return：
/// Other:w ##class(web.DHCBL.CT.HOSDepartment).HandleDesc()
ClassMethod HandleDesc()
{
	s result=""
	s errorflag=0
	ts
	s ID=0
    for 
    {
        s ID=$o(^CT.BDP.CT.HOSDepartmentD(ID))
        q:ID=""
        q:errorflag=1
        s DEPTDesc=$listget($g(^CT.BDP.CT.HOSDepartmentD(ID)),3)	//部门名称
        s desc=$Zstrip(DEPTDesc,"<>W")
        if (DEPTDesc'=desc)
        {
	        s obj=##class(CT.BDP.CT.HOSDepartment).%OpenId(ID)
	        s obj.DEPTDesc= desc	//部门名称
	        s sc=obj.%Save()
        	d obj.%Close()
        	s:sc'=1 errorflag=1
        }
    }
    if (errorflag=1)
    {
	 	s result="false"
	 	tro   
    }
    else
    {	
	    s result="true"
	    tc
    }
    q result
}

}
