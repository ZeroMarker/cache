Class EMRservice.BOPowerUser Extends (%RegisteredObject, %SOAP.WebService) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://10.10.141.113/trakcarejst/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "Privilege.BOPowerUser";

ClassMethod Add(argPowerUser As EMRservice.entity.EPowerUser) As %String [ WebMethod ]
{

	q ##Class(EMRservice.BL.BLPowerUser).Add(argPowerUser)
}

/// not in use
ClassMethod Delete(argPowerUserID As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLPowerUser).Delete(argPowerUserID)
}

ClassMethod Update(argPowerUser As EMRservice.entity.EPowerUser, argSkipColumn As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLPowerUser).Update(argPowerUser,argSkipColumn)
}

ClassMethod GetById(argPowerUserID As %String) As EMRservice.entity.EPowerUser [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLPowerUser).GetById(argPowerUserID)
}

/// Not Really Used(has been referenced in MaintainApp)
ClassMethod SelectBySSGroupAndLevel(argSSGroupID As %String, argLevel As %String) As %String [ WebMethod ]
{
	q ##class(EMRservice.BL.BLPowerUser).SelectBySSGroupAndLevel(argSSGroupID,argLevel)
}

/// argSkipColumn: because edit user level and child users both change the BOPowerUser table,
/// so when edit one property(column) should not influence the other. this argument shows which one should be kept.
ClassMethod AddOrUpdate(argPowerUser As EMRservice.entity.EPowerUser, argSkipColumn As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLPowerUser).AddOrUpdate(argPowerUser,argSkipColumn)
}

ClassMethod GetSSUserN(argGroupName As %String) As %XML.DataSet
{
   Set result=##class(%XML.DataSet).%New("EMRservice.BL.BLPowerUser:GetSSUser")
   Do result.SetArgs(argGroupName)
   q result
}

ClassMethod getSSUser(argGroupName As %String, argUserName As %String) As %XML.DataSet [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLPowerUser).getSSUser(argGroupName,argUserName)
}

ClassMethod getSSUserSub(argGroupName As %String, argUserName As %String) As %XML.DataSet [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLPowerUser).getSSUserSub(argGroupName,argUserName)
}

ClassMethod getUserLevel() As EMRservice.dataset.EUserLevelDataset [ WebMethod ]
{
	Set result=##class(EMRservice.dataset.EUserLevelDataset).%New()
    Quit result
}

ClassMethod getUserPost() As EMRservice.dataset.EUserPostDataset [ WebMethod ]
{
	Set result=##class(EMRservice.dataset.EUserPostDataset).%New()
    Quit result
}

/// not in use
ClassMethod UpdateOld(argPowerUserID As %String, argPowerUser As EMRservice.entity.EPowerUser) As %String
{
	q ##Class(EMRservice.BL.BLPowerUser).UpdateOld(argPowerUserID,argPowerUser)
}

/// get a user's ssgroup name and user's name by it's id
/// return: groupname^username
/// w ##Class(EMRservice.BOPowerUser).GetSSGroupIDNamesByUserIDS("46^53^380")
ClassMethod GetSSGroupIDNamesByUserIDS(argUserIDs As %String) As %String [ WebMethod ]
{
	q:(($d(argUserIDs)=0)||(argUserIDs="")) ""
	s user="",result="",groupName="",userName=""
	s result = ""
	s strSize = $L(argUserIDs,"^")
	for i=1:1:strSize
	{
		s argUserID = $p(argUserIDs,"^",i)
		s user=##class(User.SSUser).%OpenId(argUserID)
		q:(user="")
		if ($e(user.SSUSRGroup))
		{
			s result = result _"^"_argUserID_"|"_user.SSUSRGroup.%Id()
		}
		else
		{
			s result = result _"^"_argUserID_"|"_""
		}
		
	}
	s result = $e(result,2,$L(result))
	q result
}

ClassMethod testadd()
{
	s a=##class(EMRservice.entity.EPowerUser).%New()
	
	
	;s a.ControlByGroup=0
	;s a.IsValid=1
	;s a.UserLevel="chief"
	s a.ID = "300"
	s a.SSGroupID="107"
	s a.UserID="2"
	s a.ChildUsers="48^50^52^55^758"
	s a.SubUserIDGroupID = "48|100^50|100^52|100^55|100^758|100"


	w ##class(EMRservice.BL.BLPowerUser).AddOrUpdate(a,"UserLevel")
	q
}

///      ************* 测试代码 ************

}
