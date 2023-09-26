Import sqluser

Class web.DHCST.Android.Common Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 登录调用
/// w ##class(web.DHCST.Android.Common).logon("demo","1")
ClassMethod logon(userName As %String, password As %String, logonLocType As %String = "D") As %String
{
		n (userName , password , logonLocType)
		s $zt="errorLogon"
		s userId=##class(web.SSUser).IsValidUser(userName,password)
		s json=##class(%ArrayOfDataTypes).%New()
		s userName=""
		i userId<0 d
		.s errorInfo=$s(userId="-100":"用户不存在",userId="-101":"密码不正确",userId="-102":"用户没有激活",1:"")
		e  s userName=$p(^SSU("SSUSR",userId),"^",2) //by pan
		s locJson=..getUserLoc(userId,logonLocType)
		d json.SetAt($g(errorInfo),"ErrorInfo")
		d json.SetAt($g(locJson),"Locs")
		d json.SetAt(userId,"UserID")
		d json.SetAt(userName,"UserName")
		i ($g(errorInfo)="")&&(locJson.Count()=0) d
		.s errorInfo="用户没有可登陆的病区"
		.d json.SetAt($g(errorInfo),"ErrorInfo")
		q ##class(Nur.JSON).Encode(json)
errorLogon
	s error=$ze
	s json=##class(%ArrayOfDataTypes).%New()
	d json.SetAt($g(error),"ErrorInfo")
	q ##class(Nur.JSON).Encode(json)
}

/// 2012 08 12 pengjunfu
/// 根据userID查找可以登录的病区科室
/// w ##class(Nur.Android.Common).getWardPats(20)
ClassMethod getUserLoc(userId As %String, logonLocType As %String = "D") As %ListOfDataTypes
{
		n (userId, logonLocType)
		s defLocId="",userName="",defLocType=""
		s locJson=##class(%ListOfDataTypes).%New()
		s userObj=##class(User.SSUser).%OpenId(userId,0)
		i ($IsObject(userObj)){
			s userName=userObj.SSUSRName
			s defLocObj=userObj.SSUSRDefaultDeptDR
			s defGroupObj=userObj.SSUSRGroup
			i ($IsObject(defLocObj)){
				s defLocDesc=defLocObj.CTLOCDesc
				i defLocDesc["-" s defLocDesc=$p(defLocDesc,"-",2)
				s defLocType=defLocObj.CTLOCType
				s defLocId=defLocObj.%Id()
				d defLocObj.%Close()
			}
			i ($IsObject(defGroupObj)){
				s defGroupId=defGroupObj.%Id()
				i defGroupId'="" s defGroupDesc=$p(^SSU("SSGRP",defGroupId),"^",1) //by pan 20130924
				d defGroupObj.%Close()
			}
			
			i (($g(defLocType)'="")&(logonLocType'="")&(defLocType'=logonLocType)){
				s defLocId=""
				s defLocDesc=""
				s defGroupId=""
			}
			
			d userObj.%Close()
		}
        b ;02
		i (defLocId'=""){
	
			s locChildJson=##class(%ArrayOfDataTypes).%New()
			d locChildJson.SetAt(defLocId,"LocID")
			d locChildJson.SetAt(defLocDesc_"-"_$g(defGroupDesc),"LocDesc")  //by pan 20130924
			s defWardId=1 //$o(^PAWARD(0,"WARD_LocationDR",defLocId,""))
			b
			d locChildJson.SetAt(defWardId,"WardID")
			d locChildJson.SetAt(defGroupId,"GroupID")
			B  ////VVV
			d locJson.Insert(locChildJson)
		}
		s rs=##class(%ResultSet).%New("Nur.Android.Query:logonCtloc")
		d rs.Execute(userId)
		while(rs.Next()){
			s locId=rs.GetDataByName("locId")
			s groupId=rs.GetDataByName("groupId")
			i groupId'="" s groupDesc=$p(^SSU("SSGRP",groupId),"^",1)  //by pan 20130924
			s locDesc=$p($G(^CTLOC(locId)),"^",2)
			i locDesc["-" s locDesc=$p(locDesc,"-",2)
			s locType=$p($G(^CTLOC(locId)),"^",13)
			s wardId=$o(^PAWARD(0,"WARD_LocationDR",locId,""))
			continue:locType'="D"
			s locChildJson=##class(%ArrayOfDataTypes).%New()
			d locChildJson.SetAt(locId,"LocID")
			d locChildJson.SetAt(locDesc_"-"_$g(groupDesc),"LocDesc") //by pan 20130924
			d locChildJson.SetAt(wardId,"WardID")
			d locChildJson.SetAt(groupId,"GroupID")
			d locJson.Insert(locChildJson)
		}
		q locJson
}

/// creator:yunhaibao
/// createdate:2016-09-26
/// description:获取所有科室,数据流形式
/// w ##class(web.DHCST.Android.Common).GetDeptLoc("","")
ClassMethod GetDeptLoc(Desc, AllLocFlag = "") As %GlobalCharacterStream
{
    n (Desc,AllLocFlag)
    s EmptyJson=##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0)
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "SELECT CTLOC_ROWID AS RowId, CTLOC_DESC AS Description FROM CT_Loc where CTLOC_DESC like '%"_Desc_"%' And  CTLOC_Type='D'"
    d result.Prepare(sqlStr)
    d result.Execute()
    s count = 0
    s Title="RowId^Description"
    s ListStream=##class(%GlobalCharacterStream).%New()
    While(result.Next())
    {
	    s Rowid = result.Data("RowId")
	    s ActTo=$p(^CTLOC(Rowid),"^",25)
	    ///yunhaibao,sql检索不识别横线问题
	    Continue:(ActTo'="")&&(ActTo<+$H)
	    //Continue:(SRFlag'="Y")&&(AllLocFlag'="Y")
	    s Description = result.Data("Description")
	    continue:(Desc'="")&&(Desc["-")&&($zconvert(Desc,"U")'=$e($zconvert(Description,"U"),1,$l(Desc)))  //startwith
	    s outputdata=Rowid_"^"_Description
	    s count = count+1
	    s outputjson=##class(web.DHCSTPHCMCOMMON).getJsonData(Title,outputdata)
		I count=1 d
		.d ListStream.Write(##class(web.DHCSTPHCMCOMMON).getJsonStartSign(1))
		.d ListStream.Write(outputjson)
		e  d
		.d ListStream.Write(",")
		.d ListStream.Write(outputjson)
    }
    i count>0 d ListStream.Write(##class(web.DHCSTPHCMCOMMON).getJsonEndSign())
    e  d ListStream.Write(EmptyJson)
    q ListStream
}

/// creator:yunhaibao
/// createdate:2016-09-26
/// description:获取安全组对应的科室,数据流形式
ClassMethod GetGroupDept(GroupId As %String, LocDesc As %String = "", Type As %String = "") As %GlobalCharacterStream
{
    n (GroupId,LocDesc,Type)
    //s ^yunhaibao("GetGroupDept")=GroupId_","_LocDesc_","_Type
    s EmptyJson=##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0)
    s Type=$g(Type)
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr="Select st_ctloc_dr AS RowId,st_ctloc_dr->ctloc_desc  AS Description from ss_groupstocklocations where st_parref="_GroupId_" AND (ST_ActiveFlag IS NULL OR ST_ActiveFlag='Y')"
    i Type'="" d
    .s sqlStr = sqlStr_" and st_ctloc_dr->ctloc_type="_Type
    i LocDesc'="" d
    .s LocDesc=$$ALPHAUP^SSUTIL4(LocDesc)
    .s sqlStr = sqlStr_" and %ALPHAUP(st_ctloc_dr->ctloc_desc) %STARTSWITH "_"'"_LocDesc_"'"
    s sqlStr = sqlStr_" ORDER BY st_ctloc_dr"
    d result.Prepare(sqlStr)
    d result.Execute()
    s Title="RowId^Description"
    s ListStream=##class(%GlobalCharacterStream).%New()
    s count = 0
    While(result.Next())
    {
	    s Rowid = result.Data("RowId")
	    s ActTo=$p(^CTLOC(Rowid),"^",25)
	    Continue:(ActTo'="")&&(ActTo<+$H)
	    s Description = result.Data("Description")
	    s outputdata=Rowid_"^"_Description
	    s count = count+1
	    s outputjson=##class(web.DHCSTPHCMCOMMON).getJsonData(Title,outputdata)
		I count=1 d
		.d ListStream.Write(##class(web.DHCSTPHCMCOMMON).getJsonStartSign(1))
		.d ListStream.Write(outputjson)
		e  d
		.d ListStream.Write(",")
		.d ListStream.Write(outputjson)
    }
    i count>0 d ListStream.Write(##class(web.DHCSTPHCMCOMMON).getJsonEndSign())
    e  d ListStream.Write(EmptyJson)
    q ListStream
}

/// creator:yunhaibao
/// createdate:20160926
/// description:或取类组
/// w ##class(web.DHCST.Android.Common).GetStkCatGroup("G")
ClassMethod GetStkCatGroup(Type = "") As %GlobalCharacterStream
{
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "SELECT SCG_ROWID AS RowId, SCG_DESC AS Description FROM DHC_StkCatGroup WHERE SCG_Type ='"_Type_"' ORDER BY SCG_ROWID"
    d result.Prepare(sqlStr)
    d result.Execute()
    s count = 0
    s Title="RowId^Description"
    s ListStream=##class(%GlobalCharacterStream).%New()
    While(result.Next())
    {
	    s Rowid = result.Data("RowId")
	    s Description = result.Data("Description")
	    s outputdata=Rowid_"^"_Description
	    s outputjson=##class(web.DHCSTPHCMCOMMON).getJsonData(Title,outputdata)
	    s count=count+1
		I count=1 d
		.d ListStream.Write(##class(web.DHCSTPHCMCOMMON).getJsonStartSign(1))
		.d ListStream.Write(outputjson)
		e  d
		.d ListStream.Write(",")
		.d ListStream.Write(outputjson)
    }
    s EmptyJson=##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0)
    i count>0 d ListStream.Write(##class(web.DHCSTPHCMCOMMON).getJsonEndSign())
    e  d ListStream.Write(EmptyJson)
    q ListStream
}

}
