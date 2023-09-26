Class EMRservice.BOPrivCTLocUser Extends (%RegisteredObject, %SOAP.WebService) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://127.0.0.1/trakcarelive/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "Privilege.PrivCTLocUser";

/// Creator：      Jiangew
/// CreatDate：    2012-11-15
/// Description:   加载科室人员列表
/// Test:          d ##Class(EMRservice.BOPrivCTLocUser).GetCTLocUserDS()
ClassMethod GetCTLocUserDS() As EMRservice.dataset.EPrivCTLocUserDataset [ WebMethod ]
{
    q ##Class(EMRservice.BL.BLPrivCTLocUser).GetCTLocUserList()
}

/// d ##Class(EMRservice.BOPrivCTLocUser).GetCTLocUser("bjek-保健二科","")
/// added by Jiangew on 2012-11-20
ClassMethod GetCTLocUser(CTLocName As %String, CTLocUser As %String) As %XML.DataSet [ WebMethod ]
{
	Set result=##Class(%XML.DataSet).%New()
	
	//both 2 parameters are empty
	if (($d(CTLocName)=0)||(CTLocName=""))&&(($d(CTLocUser)=0)||(CTLocUser="")) 
	{
		Set result=##Class(%XML.DataSet).%New("EMRservice.BL.BLPrivCTLocUser:SelectCTLocUser")
		Do result.SetArgs()
	}
	
	//CTLocName is not empty
	elseif (($d(CTLocName)=1)&&(CTLocName'=""))&&(($d(CTLocUser)=0)||(CTLocUser="")) 
	{
		b 
		Set result=##Class(%XML.DataSet).%New("EMRservice.BL.BLPrivCTLocUser:SelectCTLocUserByCTLocName")
		Do result.SetArgs(CTLocName)		
	}
	//CTLocUser is not empty
	elseif (($d(CTLocName)=0)||(CTLocName=""))&&(($d(CTLocUser)=1)||(CTLocUser'="")) {
		Set result=##Class(%XML.DataSet).%New("EMRservice.BL.BLPrivCTLocUser:SelectCTLocUserByUserName")
		Do result.SetArgs(CTLocUser)

	}
	//both 2 parameters are not empty
	else {
		Set result=##Class(%XML.DataSet).%New("EMRservice.BL.BLPrivCTLocUser:SelectCTLocUserByName")
		Do result.SetArgs(CTLocName,CTLocUser)
	}
	
	Quit result
}

/// added by Jiangew on 2012-11-21
ClassMethod GetCTLocUserSub(CTLocName As %String, CTLocUser As %String) As %XML.DataSet [ WebMethod ]
{
	Set result=##Class(%XML.DataSet).%New()
	
	//both 2 parameters are empty
	if (($d(CTLocName)=0)||(CTLocName=""))&&(($d(CTLocUser)=0)||(CTLocUser="")) 
	{
		Set result=##Class(%XML.DataSet).%New("EMRservice.BL.BLPrivCTLocUser:SelectCTLocUserSub")
		Do result.SetArgs()
	}
	
	//CTLocName is not empty
	elseif (($d(CTLocName)=1)&&(CTLocName'=""))&&(($d(CTLocUser)=0)||(CTLocUser="")) 
	{
		b 
		Set result=##Class(%XML.DataSet).%New("EMRservice.BL.BLPrivCTLocUser:SelectCTLocUserSubByCTLocName")
		Do result.SetArgs(CTLocName)		
	}
	//CTLocUser is not empty
	elseif (($d(CTLocName)=0)||(CTLocName=""))&&(($d(CTLocUser)=1)||(CTLocUser'="")) {
		Set result=##Class(%XML.DataSet).%New("EMRservice.BL.BLPrivCTLocUser:SelectCTLocUserSubByUserName")
		Do result.SetArgs(CTLocUser)

	}
	//both 2 parameters are not empty
	else {
		Set result=##Class(%XML.DataSet).%New("EMRservice.BL.BLPrivCTLocUser:SelectCTLocUserSubByName")
		Do result.SetArgs(CTLocName,CTLocUser)
	}
	
	Quit result
}

}
