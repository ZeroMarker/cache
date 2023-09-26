/// 名称:科室用户同步接口类
/// 描述:用于同步科室、用户及关联关系
/// 编写者:基础数据平台 - xuwenhu
/// 编写日期:2021-04-22
Class web.CDSS.MachineLearning.UserAndDeptSynchronized Extends %RegisteredObject
{

/// Creator:xuwenhu
/// CreatDate:2021-04-22
/// Description:第三方调用数据接口(后台调用)，护理接口
/// Table:
/// Input: action: 服务编号 message：请求流传给改参数
/// Return:
/// Others:w ##class(web.CDSS.MachineLearning.UserAndDeptSynchronized).DHCServerInterface(action,message)
ClassMethod DHCServerInterface(action As %String, message As %Stream.GlobalCharacter) As %String
{
	d message.Rewind()
	s str=""
    while 'message.AtEnd
    {
        s str=str_message.ReadLine()
    }
 	s SaveDict={}
 	s XMLObj=##class(web.CDSS.Public.XML).FromXML(str)
 	q:XMLObj=""
 	if (action="DEPARTMENT_DICTIONARY_SYNCHRONIZATION")   //科室信息
 	{
	 	s body=XMLObj.Get("DeptDictInfo")  //body下可能有多条数据
 		/******************遍历body下的多条数据********************/
 		while body.Next(.nodeName, .nodeVal) 
 		{
	 		s Content=nodeVal
	 		d SaveDict.%Set("DeptCode",Content.Get("DeptCode"))  					//科室编码
	 		d SaveDict.%Set("DeptOldCode",Content.Get("OldCode"))					//旧代码
	 		d SaveDict.%Set("DeptName",Content.Get("DeptName"))  					//科室名称
	 		d SaveDict.%Set("FatherCode",Content.Get("FatherCode"))  				//父级科室
	 		d SaveDict.%Set("DeptClass",Content.Get("DeptClass"))  					//科室分类
	 		d SaveDict.%Set("UseFlag",Content.Get("UseFlag"))  						//使用标记
        	d SaveDict.%Set("CreateDate",Content.Get("CreateDate"))  				//维护时间
        	d SaveDict.%Set("CreateUserID",Content.Get("CreateUserID"))  			//维护人员
        	d SaveDict.%Set("Remarks",Content.Get("Remarks"))  						//备注
        	d SaveDict.%Set("HospAreaDR",Content.Get("HospAreaDR"))  				//院区指针
        	d SaveDict.%Set("HISDeptID",Content.Get("HISDeptID"))  					//His科室的id
        	s SaveDict=SaveDict.%ToJSON()
 		}
 		try
    	{
        	d ..SaveDeptDictInfo(SaveDict)
    	}
    	catch e
    	{
	    	if ($d(^TMPCDSSXWHERROR(1))=0)
	    	{
		    	s number=1
	    	}
	    	else
	    	{
        		s number=$o(^TMPCDSSXWHERROR(""),-1)+1
	    	}
        	s ^TMPCDSSXWHERROR(number)=SaveDict_"&&"_e.Name
    	}
 		q "success" 	
	}
	if (action="USER_DICTIONARY_SYNCHRONIZATION")   //用户信息
 	{
	 	s body=XMLObj.Get("UserDictInfo")  //body下可能有多条数据
 		/******************遍历body下的多条数据********************/
 		while body.Next(.nodeName, .nodeVal) 
 		{
	 		s Content=nodeVal
	 		d SaveDict.%Set("UserCode",Content.Get("UserCode"))  				//用户编码
	 		d SaveDict.%Set("UserOldCode",Content.Get("OldCode"))  				//旧编码
	 		d SaveDict.%Set("UserName",Content.Get("UserName"))  				//用户名称
	 		d SaveDict.%Set("FatherCode",Content.Get("FatherCode"))  			//登录名
	 		d SaveDict.%Set("LoginName",Content.Get("LoginName"))  				//登录密码
	 		d SaveDict.%Set("UserRoles",Content.Get("UserRoles"))  				//用户角色
        	d SaveDict.%Set("UserJobTitle",Content.Get("UserJobTitle"))  		//用户职称
        	d SaveDict.%Set("CreateDate",Content.Get("CreateDate"))  			//维护时间
        	d SaveDict.%Set("CreateUser",Content.Get("CreateUser"))  			//维护人员
        	d SaveDict.%Set("UseFlag",Content.Get("UseFlag"))  					//使用标志
        	d SaveDict.%Set("Remarks",Content.Get("Remarks"))  					//备注
        	d SaveDict.%Set("UserJoinDept",Content.Get("UserJoinDept"))			//关联科室
        	d SaveDict.%Set("UserJoinDeptSeq",Content.Get("UserJoinDeptSeq"))	//所属科室顺序号
        	d SaveDict.%Set("StartTime",Content.Get("StartTime"))				//开始时间
        	d SaveDict.%Set("EndTime",Content.Get("EndTime"))					//结束时间
        	
        	s SaveDict=SaveDict.%ToJSON()
 		}
 		try
    	{
        	d ..SaveUserDictInfo(SaveDict)
    	}
    	catch e
    	{
	    	if ($d(^TMPCDSSXWHERROR(1))=0)
	    	{
		    	s number=1
	    	}
	    	else
	    	{
        		s number=$o(^TMPCDSSXWHERROR(""),-1)+1
	    	}
        	s ^TMPCDSSXWHERROR(number)=SaveDict_"&&"_e.Name
    	}
 		q "success" 	
	}
	if (action="USERJOINDEPT_DICTIONARY_SYNCHRONIZATION")   //科室及用户关联关系
 	{
	 	s body=XMLObj.Get("UserJoinDeptInfo")  //body下可能有多条数据
 		/******************遍历body下的多条数据********************/
 		while body.Next(.nodeName, .nodeVal) 
 		{
	 		s Content=nodeVal
	 		d SaveDict.%Set("UserCode",Content.Get("UserCode"))  				//用户编码
	 		d SaveDict.%Set("UserJoinDeptSeq",Content.Get("UserJoinDeptSeq"))  	//所属科室顺序号
	 		d SaveDict.%Set("FatherCode",Content.Get("FatherCode"))  			//用户名称
	 		d SaveDict.%Set("StartTime",Content.Get("StartTime"))				//开始时间
        	d SaveDict.%Set("EndTime",Content.Get("EndTime"))					//结束时间
        	d SaveDict.%Set("CreateDate",Content.Get("CreateDate"))  			//维护时间
        	d SaveDict.%Set("CreateUser",Content.Get("CreateUser"))  			//维护人员
        	d SaveDict.%Set("UseFlag",Content.Get("UseFlag"))  					//使用标志
        	d SaveDict.%Set("Remarks",Content.Get("Remarks"))  					//备注
        	
        	s SaveDict=SaveDict.%ToJSON()
 		}
 		try
    	{
        	d ..SaveUserJoinDeptInfo(SaveDict)
    	}
    	catch e
    	{
	    	if ($d(^TMPCDSSXWHERROR(1))=0)
	    	{
		    	s number=1
	    	}
	    	else
	    	{
        		s number=$o(^TMPCDSSXWHERROR(""),-1)+1
	    	}
        	s ^TMPCDSSXWHERROR(number)=SaveDict_"&&"_e.Name
    	}
 		q "success" 	
	}
	q "消息代码不存在"
}

/// Creator:xuwenhu
/// CreatDate:2021-04-22
/// Description：用于同步医院科室信息
/// Input：json
/// Output: 
/// w ##class(web.CDSS.MachineLearning.InteplatformService).SaveDeptDictInfo()
ClassMethod SaveDeptDictInfo(json As %String) As %String
{
    s json=[].%FromJSON(json)
    //获得推送内容
    s DeptCode=json.%Get("DeptCode")
    s DeptOldCode=json.%Get("DeptOldCode")
    s DeptName=json.%Get("DeptName")
    s FatherCode=json.%Get("FatherCode")
    s DeptClass=json.%Get("DeptClass")
    s UseFlag=json.%Get("UseFlag")
    s CreateDate=json.%Get("CreateDate")
    s CreateUserID=json.%Get("CreateUserID")
    s Remarks=json.%Get("Remarks")
    s HospAreaDR=json.%Get("HospAreaDR")
    s HISDeptID=json.%Get("HISDeptID")
    s DictHosp=$lg($g(^User.MKBConfigD(14)),3)
	s HospAreaDR=$o(^CT.WDT.CDSS.CustomerHospAreaI("DescIndex",DictHosp,HospAreaDR,0))
	s:HospAreaDR'="" HospArea=DictHosp_"||"_HospAreaDR
	s:HospAreaDR="" HospArea=""
    if (DeptOldCode'="")
    {
		s DeptID=$o(^CF.WDT.CDSS.DeptDictI("CodeIndex"," "_$ZCONVERT(DeptOldCode,"U"),0))    
	}
    else
    {
		s DeptID=$o(^CF.WDT.CDSS.DeptDictI("CodeIndex"," "_$ZCONVERT(DeptCode,"U"),0))
    }
    if (DeptID'="")		//修改
    {
		s Deptobj = ##class(CF.WDT.CDSS.DeptDict).%OpenId(DeptID)
	}
	else		//新增
	{
    	s Deptobj = ##class(CF.WDT.CDSS.DeptDict).%New()
	}
	s Deptobj.DeptCode=DeptCode
	s Deptobj.DeptName=DeptName
	d Deptobj.FatherCodeSetObjectId(FatherCode)
	s Deptobj.DeptClass=DeptClass
	s Deptobj.UseFlag=UseFlag
	s Deptobj.CreateDate=CreateDate
	s Deptobj.CreateUser=CreateUserID
	s Deptobj.Remarks=Remarks 
	d Deptobj.HospAreaDRSetObjectId(HospArea)
	s Deptobj.HISDeptID=HISDeptID 
	
    s sc=Deptobj.%Save()
    q ""
}

/// Creator:xuwenhu
/// CreaDate:2021-04-22
/// Description：用于同步医院用户信息
/// Input：json
/// Output: 
/// w ##class(web.CDSS.MachineLearning.InteplatformService).SaveUserDictInfo()
ClassMethod SaveUserDictInfo(json As %String) As %String
{
    s json=[].%FromJSON(json)
    //获得推送内容
    s UserCode=json.%Get("UserCode")
    s UserOldCode=json.%Get("UserOldCode")
    s UserName=json.%Get("UserName")
    s FatherCode=json.%Get("FatherCode")
    s LoginName=json.%Get("LoginName")
    s UserRoles=json.%Get("UserRoles")
    s UserJobTitle=json.%Get("UserJobTitle")
    s CreateDate=json.%Get("CreateDate")
    s CreateUser=json.%Get("CreateUser")
    s UseFlag=json.%Get("UseFlag")
    s Remarks=json.%Get("Remarks")
    if (UserOldCode'="")		//判断是否修改了UserCode
    {
	    s UserID=$o(^CF.WDT.CDSS.UserDictI("CodeIndex"," "_$ZCONVERT(UserOldCode,"U"),0))
	}
	else
	{
		s UserID=$o(^CF.WDT.CDSS.UserDictI("CodeIndex"," "_$ZCONVERT(UserCode,"U"),0))	
	}
    if (UserID'="")		//修改
    {
	    s Userobj = ##class(CF.WDT.CDSS.UserDict).%OpenId(UserID)
	}
	else		//新增
	{
		s Userobj = ##class(CF.WDT.CDSS.UserDict).%New()
	}
	s Userobj.UserCode=UserCode
	s Userobj.UserName=UserName
	s Userobj.FatherCode=FatherCode
	s Userobj.LoginName=LoginName
	s Userobj.UserRoles=UserRoles
	s Userobj.UserJobTitle=UserJobTitle
	s Userobj.CreateDate=CreateDate
	s Userobj.CreateUser=CreateUser
	s Userobj.UseFlag=UseFlag
	s Userobj.Remarks=Remarks

    s sc=Userobj.%Save()
    q ""
}

/// Creator:xuwenhu
/// CreaDate:2021-04-22
/// Description：用于保存用户科室关联关系
/// Input：json
/// Output: 
/// w ##class(web.CDSS.MachineLearning.InteplatformService).SaveUserJoinDeptInfo()
ClassMethod SaveUserJoinDeptInfo(json As %String) As %String
{
	s json=[].%FromJSON(json)
	s UserCode=json.%Get("UserCode")
	s UserJoinDeptSeq=json.%Get("UserJoinDeptSeq")
	s FatherCode=json.%Get("FatherCode")
	s StartTime=json.%Get("StartTime")
    s EndTime=json.%Get("EndTime")
	s CreateDate=json.%Get("CreateDate")
    s CreateUser=json.%Get("CreateUser")
    s UseFlag=json.%Get("UseFlag")
    s Remarks=json.%Get("Remarks")
    
    s UserID=$o(^CF.WDT.CDSS.UserDictI("CodeIndex"," "_$ZCONVERT(UserCode,"U"),0))
	s DeptID=$o(^CF.WDT.CDSS.DeptDictI("CodeIndex"," "_$ZCONVERT(FatherCode,"U"),0))
	s UserJoinDeptID=$o(^CF.WDT.CDSS.UserJoinDeptI("UserDeptIndex",UserID,DeptID,0))
	
	if (UserJoinDeptID'="")		//修改
	{
		s:UserJoinDeptSeq="" UserJoinDeptSeq=$o(^CF.WDT.CDSS.UserJoinDeptI("NumIndex",UserID,""),-1)
		s obj=##class(CF.WDT.CDSS.UserJoinDept).%OpenId(UserJoinDeptID)
	}
	else
	{
		s UserJoinDeptSeq=$o(^CF.WDT.CDSS.UserJoinDeptI("NumIndex",UserID,""),-1)+1
		s obj=##class(CF.WDT.CDSS.UserJoinDept).%New()
	}
	d obj.UserCodeDRSetObjectId(UserID)
	s obj.UserJoinDeptSeq=UserJoinDeptSeq
	d obj.FatherCodeDRSetObjectId(DeptID)
	s obj.StartTime=StartTime
	s obj.EndTime=EndTime
	s obj.CreateDate=CreateDate
	s obj.CreateUser=CreateUser
	s obj.UseFlag=UseFlag
	s obj.Remarks=Remarks
	
	s sc=obj.%Save()
	q ""
}

}
