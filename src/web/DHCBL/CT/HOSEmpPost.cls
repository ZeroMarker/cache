/// Function: HOS 人员岗位表
/// CreateDate:2022-11-15
/// Creator:gaoshanshan
Class web.DHCBL.CT.HOSEmpPost Extends %RegisteredObject [ ProcedureBlock ]
{

/// Function：  人员岗位查询
/// Creator:    gaoshanshan
/// CreatDate:  2022-11-15
/// Table：     CT.BDP.CT.HOSEmpPost   
/// Other:      d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSEmpPost","GetList","","2","")
Query GetList(rowid As %String, personid As %String, deptcode As %String, postcode As %String) As %Query(ROWSPEC = "ID,EMPPOSTPAPersonDesc,EMPPOSTORGDesc,EMPPOSTPOSTDesc,EMPPOSTBeginDate,EMPPOSTRemoveDate,EMPPOSTStatus,EMPPOSTDefaultFlag,EMPPOSTActivity,EMPPOSTStartDate,EMPPOSTEndDate,EMPPOSTSeqNo,EMPPOSTPYCode,EMPPOSTWBCode,EMPPOSTMark")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, personid As %String, deptcode As %String, postcode As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    if (rowid'="") //根据rowid返回该条记录
    { 
      	s ID=rowid
      	s EMPPOSTPAPersonDesc="",EMPPOSTORGDesc="",EMPPOSTPOSTDesc=""
      	s EMPPOSTPAPersonID =$listget($g(^CT.BDP.CT.HOSEmpPostD(ID)),2) /// 人员唯一标识码
      	s:EMPPOSTPAPersonID'="" EMPPOSTPAPersonDesc=$listget($g(^CT.BDP.CT.HOSPersonD(EMPPOSTPAPersonID)),3)
      	s EMPPOSTDeptCode =$listget($g(^CT.BDP.CT.HOSEmpPostD(ID)),3) /// 组织部门代码
      	s:EMPPOSTDeptCode'="" EMPPOSTORGDesc=$listget($g(^CT.BDP.CT.HOSDepartmentD(EMPPOSTDeptCode)),3)
        s EMPPOSTPOSTCode =$listget($g(^CT.BDP.CT.HOSEmpPostD(ID)),4) /// 岗位代码
        s:EMPPOSTPOSTCode'="" EMPPOSTPOSTDesc=$listget($g(^CT.BDP.CT.HOSPostD(EMPPOSTPOSTCode)),3)
        s EMPPOSTBeginDate =$listget($g(^CT.BDP.CT.HOSEmpPostD(ID)),5) /// 上岗日期
        s:EMPPOSTBeginDate'="" EMPPOSTBeginDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(EMPPOSTBeginDate)
        s EMPPOSTRemoveDate =$listget($g(^CT.BDP.CT.HOSEmpPostD(ID)),6) /// 下岗日期
        s:EMPPOSTRemoveDate'="" EMPPOSTRemoveDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(EMPPOSTRemoveDate)
        s EMPPOSTStatus =$listget($g(^CT.BDP.CT.HOSEmpPostD(ID)),7) /// 状态   外键？？
        s EMPPOSTDefaultFlag =$listget($g(^CT.BDP.CT.HOSEmpPostD(ID)),8) /// 是否默认岗位
        s EMPPOSTActivity =$listget($g(^CT.BDP.CT.HOSEmpPostD(ID)),9) /// 是否有效(Y/N)
        s EMPPOSTStartDate =$listget($g(^CT.BDP.CT.HOSEmpPostD(ID)),10) /// 开始日期
        s:EMPPOSTStartDate'="" EMPPOSTStartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(EMPPOSTStartDate)
        s EMPPOSTEndDate =$listget($g(^CT.BDP.CT.HOSEmpPostD(ID)),11) /// 结束日期
        s:EMPPOSTEndDate'="" EMPPOSTEndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(EMPPOSTEndDate)
        s EMPPOSTSeqNo =$listget($g(^CT.BDP.CT.HOSEmpPostD(ID)),15) /// 系统排序号
        s EMPPOSTPYCode =$listget($g(^CT.BDP.CT.HOSEmpPostD(ID)),19) /// 拼音码
        s EMPPOSTWBCode =$listget($g(^CT.BDP.CT.HOSEmpPostD(ID)),20) /// 五笔码
        s EMPPOSTMark =$listget($g(^CT.BDP.CT.HOSEmpPostD(ID)),21) /// 备注
        
    	d OutputRow
    }
    else
    {  
        s ID=0
        for 
        {
            s ID=$o(^CT.BDP.CT.HOSEmpPostI("IndexPAPersonID",personid,ID)) q:ID="" 

	      	s EMPPOSTPAPersonDesc="",EMPPOSTORGDesc="",EMPPOSTPOSTDesc=""
	      	s EMPPOSTPAPersonID =$listget($g(^CT.BDP.CT.HOSEmpPostD(ID)),2) /// 人员唯一标识码
	      	s:EMPPOSTPAPersonID'="" EMPPOSTPAPersonDesc=$listget($g(^CT.BDP.CT.HOSPersonD(EMPPOSTPAPersonID)),3)
	      	s EMPPOSTDeptCode =$listget($g(^CT.BDP.CT.HOSEmpPostD(ID)),3) /// 组织部门代码
	      	s:EMPPOSTDeptCode'="" EMPPOSTORGDesc=$listget($g(^CT.BDP.CT.HOSDepartmentD(EMPPOSTDeptCode)),3)
	        s EMPPOSTPOSTCode =$listget($g(^CT.BDP.CT.HOSEmpPostD(ID)),4) /// 岗位代码
	        s:EMPPOSTPOSTCode'="" EMPPOSTPOSTDesc=$listget($g(^CT.BDP.CT.HOSPostD(EMPPOSTPOSTCode)),3)
	        s EMPPOSTBeginDate =$listget($g(^CT.BDP.CT.HOSEmpPostD(ID)),5) /// 上岗日期
	        s:EMPPOSTBeginDate'="" EMPPOSTBeginDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(EMPPOSTBeginDate)
	        s EMPPOSTRemoveDate =$listget($g(^CT.BDP.CT.HOSEmpPostD(ID)),6) /// 下岗日期
	        s:EMPPOSTRemoveDate'="" EMPPOSTRemoveDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(EMPPOSTRemoveDate)
	        s EMPPOSTStatus =$listget($g(^CT.BDP.CT.HOSEmpPostD(ID)),7) /// 状态   外键？？
	        s EMPPOSTDefaultFlag =$listget($g(^CT.BDP.CT.HOSEmpPostD(ID)),8) /// 是否默认岗位
	        s EMPPOSTActivity =$listget($g(^CT.BDP.CT.HOSEmpPostD(ID)),9) /// 是否有效(Y/N)
	        s EMPPOSTStartDate =$listget($g(^CT.BDP.CT.HOSEmpPostD(ID)),10) /// 开始日期
	        s:EMPPOSTStartDate'="" EMPPOSTStartDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(EMPPOSTStartDate)
	        s EMPPOSTEndDate =$listget($g(^CT.BDP.CT.HOSEmpPostD(ID)),11) /// 结束日期
	        s:EMPPOSTEndDate'="" EMPPOSTEndDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(EMPPOSTEndDate)
	        s EMPPOSTSeqNo =$listget($g(^CT.BDP.CT.HOSEmpPostD(ID)),15) /// 系统排序号
	        s EMPPOSTPYCode =$listget($g(^CT.BDP.CT.HOSEmpPostD(ID)),19) /// 拼音码
	        s EMPPOSTWBCode =$listget($g(^CT.BDP.CT.HOSEmpPostD(ID)),20) /// 五笔码
	        s EMPPOSTMark =$listget($g(^CT.BDP.CT.HOSEmpPostD(ID)),21) /// 备注
	        
            if (((EMPPOSTDeptCode=deptcode)||(deptcode=""))&((EMPPOSTPOSTCode=postcode)||(postcode="")))
            {
                d OutputRow
            }  
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow  
    set Data=$lb(ID,EMPPOSTPAPersonDesc,EMPPOSTORGDesc,EMPPOSTPOSTDesc,EMPPOSTBeginDate,EMPPOSTRemoveDate,EMPPOSTStatus,EMPPOSTDefaultFlag,EMPPOSTActivity,EMPPOSTStartDate,EMPPOSTEndDate,EMPPOSTSeqNo,EMPPOSTPYCode,EMPPOSTWBCode,EMPPOSTMark)
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
/// Creator:  gaoshanshan
/// CreatDate:2022-12-14
/// Tables: CT_BDP_CT.HOS_EmpPost
/// Input:  persondr,code,desc  
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.HOSEmpPost", "GetDataForCmb1","","1","","")
Query GetDataForCmb1(rowid As %String, personid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID:%String,POSTCode,POSTDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, personid As %String, code As %String, desc As %String) As %Status
{
	
  	Set repid=$I(^CacheTemp)
  	s ind=1
  	s:code'="" code=$zcvt(code,"U")  
  	s:desc'="" desc=$zcvt(desc,"U")  
  	if (rowid'="")  
  	{
	  	s ID=rowid
	  	s POSTCode=$listget($g(^CT.BDP.CT.HOSPostD(ID)),2)	//岗位代码
    	s POSTDesc= $listget($g(^CT.BDP.CT.HOSPostD(ID)),3)	//岗位名称
    	d OutputRowCmb
  	}
  	else
  	{
	  	if (personid=""){ //如果没选择人员就取所有岗位数据
			s ID=0
	    	for 
	    	{	
	       		s ID=$o(^CT.BDP.CT.HOSPostD(ID))
	       		q:ID="" 
	       		s POSTCode=$listget($g(^CT.BDP.CT.HOSPostD(ID)),2)	//业务岗位代码
		    	s POSTDesc= $listget($g(^CT.BDP.CT.HOSPostD(ID)),3)	//业务岗位名称
		    
				s POSTActivity=$listget($g(^CT.BDP.CT.HOSPostD(ID)),6) 	//是否有效(Y/N)
				continue:POSTActivity="N"
		    	s POSTStartDate=$listget($g(^CT.BDP.CT.HOSPostD(ID)),7) 		//开始日期
		    	continue:(POSTStartDate'="")&&(POSTStartDate>+$h)
				s POSTEndDate=$listget($g(^CT.BDP.CT.HOSPostD(ID)),8) 		//结束日期
		  		continue:(POSTEndDate'="")&&(POSTEndDate<+$h)
				s POSTPYCode=$listget($g(^CT.BDP.CT.HOSPostD(ID)),16) 		//拼音码
				
	       		if (($zcvt(POSTCode,"U")[code))&(($zcvt(POSTDesc,"U")[desc)||($zcvt(POSTPYCode,"U")[desc))
	            {
		        	d OutputRowCmb
		    	}
	    	}
	  	}
	  	else //如果选择了人员 限制取这个人所属岗位
	  	{
		  	s EPId=0
	        for 
	        {
	            s EPId=$o(^CT.BDP.CT.HOSEmpPostI("IndexPAPersonID",personid,EPId))
	            q:EPId="" 
		        s EMPPOSTPOSTCode =$listget($g(^CT.BDP.CT.HOSEmpPostD(EPId)),4) /// 岗位DR
	    		s EMPPOSTActivity =$listget($g(^CT.BDP.CT.HOSEmpPostD(EPId)),9) /// 是否有效(Y/N)
	    		continue:EMPPOSTActivity="N"
		        s EMPPOSTStartDate =$listget($g(^CT.BDP.CT.HOSEmpPostD(EPId)),10) /// 开始日期
		        continue:(EMPPOSTStartDate'="")&&(EMPPOSTStartDate>+$h)
		        s EMPPOSTEndDate =$listget($g(^CT.BDP.CT.HOSEmpPostD(EPId)),11) /// 结束日期
		        continue:(EMPPOSTEndDate'="")&&(EMPPOSTEndDate<+$h)
		        
		        s arrPost(EMPPOSTPOSTCode)="" //去重
			}
		  	
		  	s ID=""
		  	for {
			  	s ID=$o(arrPost(ID)) q:ID=""
			  	s POSTCode=$listget($g(^CT.BDP.CT.HOSPostD(ID)),2)	//岗位代码
		    	s POSTDesc= $listget($g(^CT.BDP.CT.HOSPostD(ID)),3)	//岗位名称
		    	s POSTPYCode=$listget($g(^CT.BDP.CT.HOSPostD(ID)),16) 		//拼音码
		    	if ((($ZCONVERT(POSTDesc,"U")[desc)||($zcvt(POSTPYCode,"U")[desc))&&($ZCONVERT(POSTCode,"U")[code)) 
		    	{
		        	d OutputRowCmb
		    	}
			}
		}	
  	} 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb   
 set Data=$lb(ID,POSTCode,POSTDesc)
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
/// Creator:   gaoshanshan
/// CreatDate: 2022-11-15
/// Input：    id    
/// Other:     w ##class(web.DHCBL.CT.HOSEmpPost).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.CT.HOSEmpPost).%New()
    s obj = ##class(CT.BDP.CT.HOSEmpPost).%OpenId(id)
    s eobj.ID=id
    s:$IsObject(obj.EMPPOSTPAPersonID) eobj.EMPPOSTPAPersonID = obj.EMPPOSTPAPersonID.%Id()
    s:$IsObject(obj.EMPPOSTDeptCode) eobj.EMPPOSTDeptCode = obj.EMPPOSTDeptCode.%Id()
    s:$IsObject(obj.EMPPOSTPOSTCode) eobj.EMPPOSTPOSTCode = obj.EMPPOSTPOSTCode.%Id()
    s:obj.EMPPOSTBeginDate'="" eobj.EMPPOSTBeginDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.EMPPOSTBeginDate) 
    s:obj.EMPPOSTRemoveDate'="" eobj.EMPPOSTRemoveDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.EMPPOSTRemoveDate) 
    s eobj.EMPPOSTStatus = obj.EMPPOSTStatus 
    s eobj.EMPPOSTStatus=##class(web.DHCBL.BDP.FunLib).Util(eobj.EMPPOSTStatus)
    s eobj.EMPPOSTDefaultFlag= obj.EMPPOSTDefaultFlag
    s eobj.EMPPOSTActivity = obj.EMPPOSTActivity 
    s:obj.EMPPOSTStartDate'="" eobj.EMPPOSTStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.EMPPOSTStartDate) 
    s:obj.EMPPOSTEndDate'="" eobj.EMPPOSTEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.EMPPOSTEndDate) 
    s eobj.EMPPOSTSeqNo= obj.EMPPOSTSeqNo
    s eobj.EMPPOSTPYCode= obj.EMPPOSTPYCode
    s eobj.EMPPOSTWBCode= obj.EMPPOSTWBCode
    s eobj.EMPPOSTMark= obj.EMPPOSTMark
    
    s str = eobj.JsonS()    
    d eobj.%Close()
    d obj.%Close()
    q str
}

/// Function：数据重复验证方法 
/// Creator:  gaoshanshan
/// CreatDate:2022-11-15
/// Table：   CT.BDP.CT.HOSEmpPost
/// Input：   id-rowid, code-代码,desc-描述
/// Return：  "1"(数据重复),"0"(数据不重复)
/// Other:    d ##class(web.DHCBL.CT.HOSEmpPost).FormValidate("2||2","2","1")
ClassMethod FormValidate(id As %String, PAPersonID As %String, DeptCode As %String, POSTCode As %String) As %String
{
    s flag=0
    if ((PAPersonID'="")&(DeptCode'="")&(POSTCode'="")){
	    s idc=$o(^CT.BDP.CT.HOSEmpPostI("IndexCode",PAPersonID,DeptCode,POSTCode,0)) 
		if ((id="")||((id'="")&&(idc'=id)))&&(idc>0) s flag=1  //返回重复标志
	}
    q flag
}

/// Function    保存内容
/// Creator:    gaoshanshan
/// CreatDate:  2022-11-15
/// Table：     CT.BDP.CT.HOSEmpPost
/// Input：     web.Entity.CT.HOSEmpPost  
/// Return：    成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other:      d ##class(web.DHCBL.CT.HOSEmpPost).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.CT.HOSEmpPost) As %String
{
 
    s result="" 
    s:eobj.EMPPOSTBeginDate'="" eobj.EMPPOSTBeginDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.EMPPOSTBeginDate) 
    s:eobj.EMPPOSTRemoveDate'="" eobj.EMPPOSTRemoveDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.EMPPOSTRemoveDate) 
    s:eobj.EMPPOSTStartDate'="" eobj.EMPPOSTStartDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.EMPPOSTStartDate) 
    s:eobj.EMPPOSTEndDate'="" eobj.EMPPOSTEndDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.EMPPOSTEndDate) 
    s:eobj.EMPPOSTStartDate="" eobj.EMPPOSTStartDate=+$h
    
    s USERID=""
    s:$d(%session) USERID=$g(%session.Data("LOGON.USERID")) 
    s eobj.EMPPOSTLastUpdateDate=+$h  ///系统最后更新日期
    s eobj.EMPPOSTLastUpdateTime=$p($h,",",2)  ///系统最后更新时间
    if (eobj.EMPPOSTLastUpdateUser="") s eobj.EMPPOSTLastUpdateUser=USERID  ///系统最新更新人
    s:eobj.EMPPOSTActivity="" eobj.EMPPOSTActivity="N"		//是否有效
    
    s flag=  ..FormValidate(eobj.ID,eobj.EMPPOSTPAPersonID,eobj.EMPPOSTDeptCode,eobj.EMPPOSTPOSTCode)  //调用重复验证
    if (flag=1)
    {
        s result = "{success:'false',errorinfo:'该记录已经存在！'}"
    }
    else
    {
        if (eobj.ID="")  
        {
            s obj=##class(CT.BDP.CT.HOSEmpPost).%New()
            s eobj.EMPPOSTCreateDate=+$h  ///系统创建日期
            s eobj.EMPPOSTCreateTime=$p($h,",",2)  ///系统创建时间
            s:eobj.EMPPOSTCreateUser="" eobj.EMPPOSTCreateUser=USERID   ///系统创建人
            s obj.EMPPOSTCreateDate=eobj.EMPPOSTCreateDate
            s obj.EMPPOSTCreateTime=eobj.EMPPOSTCreateTime
            d obj.EMPPOSTCreateUserSetObjectId(eobj.EMPPOSTCreateUser)
        }
        else              
        {
            s obj=##class(CT.BDP.CT.HOSEmpPost).%OpenId(eobj.ID)
            s bobj=##class(web.Entity.CT.HOSEmpPost).%New()
            s bobj.ID=eobj.ID 
		    s:$IsObject(obj.EMPPOSTPAPersonID) bobj.EMPPOSTPAPersonID = obj.EMPPOSTPAPersonID.%Id()
		    s:$IsObject(obj.EMPPOSTDeptCode) bobj.EMPPOSTDeptCode = obj.EMPPOSTDeptCode.%Id()
		    s:$IsObject(obj.EMPPOSTPOSTCode) bobj.EMPPOSTPOSTCode = obj.EMPPOSTPOSTCode.%Id()
		    s:obj.EMPPOSTBeginDate'="" bobj.EMPPOSTBeginDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.EMPPOSTBeginDate) 
		    s:obj.EMPPOSTRemoveDate'="" bobj.EMPPOSTRemoveDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.EMPPOSTRemoveDate) 
		    s bobj.EMPPOSTStatus = obj.EMPPOSTStatus 
		    s bobj.EMPPOSTDefaultFlag= obj.EMPPOSTDefaultFlag
		    s bobj.EMPPOSTActivity = obj.EMPPOSTActivity 
		    s:obj.EMPPOSTStartDate'="" bobj.EMPPOSTStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.EMPPOSTStartDate) 
		    s:obj.EMPPOSTEndDate'="" bobj.EMPPOSTEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.EMPPOSTEndDate) 
		    s:obj.EMPPOSTCreateDate'="" bobj.EMPPOSTCreateDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.EMPPOSTCreateDate) 
		    s:obj.EMPPOSTCreateTime'="" bobj.EMPPOSTCreateTime= ##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(obj.EMPPOSTCreateTime) 
		    s:$IsObject(obj.EMPPOSTCreateUser) bobj.EMPPOSTCreateUser= obj.EMPPOSTCreateUser.%Id()
		    s bobj.EMPPOSTSeqNo= obj.EMPPOSTSeqNo
		    s:obj.EMPPOSTLastUpdateDate'="" bobj.EMPPOSTLastUpdateDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.EMPPOSTLastUpdateDate) 
		    s bobj.EMPPOSTLastUpdateTime= obj.EMPPOSTLastUpdateTime
		    s:$IsObject(obj.EMPPOSTLastUpdateUser) bobj.EMPPOSTLastUpdateUser= obj.EMPPOSTLastUpdateUser.%Id()
		    s bobj.EMPPOSTPYCode= obj.EMPPOSTPYCode
		    s bobj.EMPPOSTWBCode= obj.EMPPOSTWBCode
		    s bobj.EMPPOSTMark= obj.EMPPOSTMark
        }
       
	    d:eobj.EMPPOSTPAPersonID'="" obj.EMPPOSTPAPersonIDSetObjectId(eobj.EMPPOSTPAPersonID)
	    d:eobj.EMPPOSTDeptCode'="" obj.EMPPOSTDeptCodeSetObjectId(eobj.EMPPOSTDeptCode)
	    d:eobj.EMPPOSTPOSTCode'="" obj.EMPPOSTPOSTCodeSetObjectId(eobj.EMPPOSTPOSTCode)
	    s obj.EMPPOSTBeginDate = eobj.EMPPOSTBeginDate 
	    s obj.EMPPOSTRemoveDate = eobj.EMPPOSTRemoveDate 
	    s eobj.EMPPOSTStatus=##class(web.DHCBL.BDP.FunLib).Util(eobj.EMPPOSTStatus)
	    s obj.EMPPOSTStatus = eobj.EMPPOSTStatus 
	    s obj.EMPPOSTDefaultFlag= eobj.EMPPOSTDefaultFlag 
	    s obj.EMPPOSTActivity = eobj.EMPPOSTActivity 
	    s obj.EMPPOSTStartDate= eobj.EMPPOSTStartDate
	    s obj.EMPPOSTEndDate= eobj.EMPPOSTEndDate
	    s obj.EMPPOSTSeqNo= eobj.EMPPOSTSeqNo
	    s obj.EMPPOSTLastUpdateDate= eobj.EMPPOSTLastUpdateDate
	    s obj.EMPPOSTLastUpdateTime= eobj.EMPPOSTLastUpdateTime
	    d obj.EMPPOSTLastUpdateUserSetObjectId(eobj.EMPPOSTLastUpdateUser)
	    s obj.EMPPOSTPYCode= eobj.EMPPOSTPYCode
	    s obj.EMPPOSTWBCode= eobj.EMPPOSTWBCode
	    s obj.EMPPOSTMark= eobj.EMPPOSTMark 
	    
	    
        TSTART 
        s sc=obj.%Save()
        d obj.%Close()
        If $$$ISOK(sc)
        {
            TCOMMIT
            s id = obj.%Id()
            s result = "{success:'true',id:'"_id_"'}"  //返回RowId  
            d:eobj.ID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_EmpPost","CT.BDP.CT.HOSEmpPost","人员岗位",id,eobj.EMPPOSTPOSTCode,"A",eobj)
            d:eobj.ID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_EmpPost","CT.BDP.CT.HOSEmpPost","人员岗位",eobj.ID,eobj.EMPPOSTPOSTCode,"U",eobj,bobj)
        }
        else
        {
            Trollback
            s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
            s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("人员岗位","web.DHCBL.CT.HOSEmpPost","SaveData",eobj)
            s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
        }
    }  
     q result
}

/// Creator:gaoshanshan
/// CreatDate:2022-11-15
/// Description：根据ID删除内容
/// Table：CT.BDP.CT.HOSEmpPost
/// Input：id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.CT.HOSEmpPost).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
    s result="" 
    //new Entity对象，用于保存日志
    s pobj = ##class(CT.BDP.CT.HOSEmpPost).%OpenId(id)
    s eobj = ##class(web.Entity.CT.HOSEmpPost).%New()
    s eobj.ID = id
    s:$IsObject(pobj.EMPPOSTPAPersonID) eobj.EMPPOSTPAPersonID = pobj.EMPPOSTPAPersonID.%Id()
    s:$IsObject(pobj.EMPPOSTDeptCode) eobj.EMPPOSTDeptCode = pobj.EMPPOSTDeptCode.%Id()
    s:$IsObject(pobj.EMPPOSTPOSTCode) eobj.EMPPOSTPOSTCode = pobj.EMPPOSTPOSTCode.%Id()
    s:pobj.EMPPOSTBeginDate'="" eobj.EMPPOSTBeginDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.EMPPOSTBeginDate) 
    s:pobj.EMPPOSTRemoveDate'="" eobj.EMPPOSTRemoveDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.EMPPOSTRemoveDate) 
    s eobj.EMPPOSTStatus = pobj.EMPPOSTStatus 
    s eobj.EMPPOSTDefaultFlag= pobj.EMPPOSTDefaultFlag
    s eobj.EMPPOSTActivity = pobj.EMPPOSTActivity 
    s:pobj.EMPPOSTStartDate'="" eobj.EMPPOSTStartDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.EMPPOSTStartDate) 
    s:pobj.EMPPOSTEndDate'="" eobj.EMPPOSTEndDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.EMPPOSTEndDate) 
    s:pobj.EMPPOSTCreateDate'="" eobj.EMPPOSTCreateDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.EMPPOSTCreateDate) 
    s eobj.EMPPOSTCreateTime= pobj.EMPPOSTCreateTime
    s:$IsObject(pobj.EMPPOSTCreateUser) eobj.EMPPOSTCreateUser= pobj.EMPPOSTCreateUser.%Id()
    s eobj.EMPPOSTSeqNo= pobj.EMPPOSTSeqNo
    s:pobj.EMPPOSTLastUpdateDate'="" eobj.EMPPOSTLastUpdateDate= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.EMPPOSTLastUpdateDate) 
    s eobj.EMPPOSTLastUpdateTime= pobj.EMPPOSTLastUpdateTime
    s:$IsObject(pobj.EMPPOSTLastUpdateUser) eobj.EMPPOSTLastUpdateUser= pobj.EMPPOSTLastUpdateUser.%Id()
    s eobj.EMPPOSTPYCode= pobj.EMPPOSTPYCode
    s eobj.EMPPOSTWBCode= pobj.EMPPOSTWBCode
    s eobj.EMPPOSTMark= pobj.EMPPOSTMark
    
    d pobj.%Close()
    k pobj
    Tstart
    s sc=##class(CT.BDP.CT.HOSEmpPost).%DeleteId(id)
    if $$$ISOK(sc)
    {
        Tcommit
        s result = "{success:'true',info:'删除成功！'}"  
        //保存日志
        d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.HOS_EmpPost","CT.BDP.CT.HOSEmpPost","人员岗位",id,eobj.EMPPOSTPOSTCode,"D",eobj)
        d eobj.%Close()
    }
    else 
    {
        Trollback
        s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
        s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("人员岗位","web.DHCBL.CT.HOSEmpPost","DeleteData",eobj)
        s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
    } 
    q result
}

}
