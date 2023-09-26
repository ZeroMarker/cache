/// 名称: web.BDP.sys.PreferencesSubKey
/// 描述: 基础数据平台 全授权基类方法
/// 编写者：zhaocz
/// 编写日期: 2013-03-26
Class web.BDP.sys.PreferencesSubKey Extends (%RegisteredObject, %XML.Adaptor) [ Abstract, ClassType = "", ProcedureBlock ]
{

Parameter ParaAppKey;

Parameter EntityClassName;

Parameter EntityClassNameDisplay;

Parameter DataSplitString = "JSON";

/// 删除 此应用的所有设置, 慎用
ClassMethod DHCDeleteAll() As %String
{
}

ClassMethod DHCDeleteData(ObjectType As %String, ObjectReference As %String, SubKey As %String) As %String
{
	s myrtn=0
	
	s myPRowID=..DHCGetRowID(ObjectType, ObjectReference, SubKey)
	
	q:(myPRowID="") myrtn
	s myrtn=..DHCDeleteByRowID(myPRowID)
	
	q myrtn
}

///  保存基本信息, 包换 Add Update
/// 保存信息 By XML
/// web.Entity.BDP.ObjectPreferences
/// web.DHCEntity.Configure.ObjectPreferences
ClassMethod DHCSaveInfo(ObjPref As web.Entity.BDP.ObjectPreferences) As %String
{
	s myrtn=0
	s myPRowID=..DHCGetRowID(ObjPref.ObjectType, ObjPref.ObjectReference, ObjPref.AppSubKey)
	i myPRowID="" d
	.s myobj=##class(User.BDPPreferences).%New()
	e  d
	.s myobj=##class(User.BDPPreferences).%OpenId(myPRowID)
	.s JsonStrU="{RowId:"_$c(34)_myPRowID_$c(34)_",AppKey:"_$c(34)_myobj.AppKey_$c(34)_",AppSubKey:"_$c(34)_myobj.AppSubKey_$c(34)_",CorrespondingClass:"_$c(34)_myobj.CorrespondingClass_$c(34)_",Data:"_$c(34)_myobj.Data_$c(34)_",DataSplitString:"_$c(34)_myobj.DataSplitString_$c(34)_",ObjectReference:"_$c(34)_myobj.ObjectReference_$c(34)_",ObjectType:"_$c(34)_myobj.ObjectType_$c(34)_"}"
	
	
	s myobj.AppKey = ObjPref.AppKey
	s myobj.AppSubKey = ObjPref.AppSubKey
	s myobj.CorrespondingClass = ObjPref.CorrespondingClass
	s myobj.Data = ObjPref.Data
	s myobj.DataMapMode = ObjPref.DataMapMode
	s myobj.DataSplitString = ObjPref.DataSplitString
	s myobj.ObjectReference = ObjPref.ObjectReference
	s myobj.ObjectType = ObjPref.ObjectType
	
	s sc=myobj.%Save()
	If ($System.Status.IsError(sc))
	{
		Do $System.Status.DisplayError(sc)
		Set myrtn = "-101"	;卡状态信息保存失败
	}
	d myobj.%Close()
	
	s JsonStr="{RowId:"_$c(34)_myPRowID_$c(34)_",AppKey:"_$c(34)_myobj.AppKey_$c(34)_",AppSubKey:"_$c(34)_myobj.AppSubKey_$c(34)_",CorrespondingClass:"_$c(34)_myobj.CorrespondingClass_$c(34)_",Data:"_$c(34)_myobj.Data_$c(34)_",DataSplitString:"_$c(34)_myobj.DataSplitString_$c(34)_",ObjectReference:"_$c(34)_myobj.ObjectReference_$c(34)_",ObjectType:"_$c(34)_myobj.ObjectType_$c(34)_"}"
	if (myPRowID'="")
	{
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("BDP_Preferences","User.BDPPreferences","授权功能",myPRowID,myobj.ObjectType_"->"_myobj.ObjectReference,"U",JsonStr,JsonStrU)
	}
	else
	{
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("BDP_Preferences","User.BDPPreferences","授权功能",myobj.%Id(),myobj.ObjectType_"->"_myobj.ObjectReference,"A",JsonStr)
	}
	
	
	q myrtn
}

/// / 
ClassMethod DHCSaveDataToServer(ObjectType As %String, ObjectReference As %String, Data As %String, SubKey As %String) As %String
{
	; w ##class(web.BDP.sys.PatEnroll).DHCSaveDataToServer("G",125,^TMPXmlData)
	; 生成 web.DHCEntity.Configure.ObjectPreferences 对象
	
	s ^TMPXmlData=Data
	
	s myrtn=0
	
	s mySaveXmlData = Data
	
	s myPreObj=##class(web.Entity.BDP.ObjectPreferences).%New()
	
	s myPreObj.AppKey=..#ParaAppKey
	s myPreObj.AppSubKey = SubKey
	s myPreObj.Data=mySaveXmlData
	s myPreObj.CorrespondingClass=..#EntityClassName
	s myPreObj.DataSplitString = ..#DataSplitString
	s myPreObj.ObjectReference=ObjectReference
	s myPreObj.ObjectType =ObjectType
	
	s myrtn=..DHCSaveInfo(myPreObj)
	
	d myPreObj.%Close()
	k myPreObj
	
	q myrtn
}

/// 保存信息 ^ 等
ClassMethod DHCSaveInfoBySplit(ObjPref As web.Entity.BDP.ObjectPreferences) As %String
{
	s myrtn=0
	
	s myPRowID=..DHCGetRowID(ObjPref.ObjectType, ObjPref.ObjectReference)
	i myPRowID="" d
	.s myobj=##class(User.BDPPreferences).%New()
	e  d
	.s myobj=##class(User.BDPPreferences).%OpenId(myPRowID)
	
	s myobj.AppKey = ObjPref.AppKey
	s myobj.AppSubKey = ObjPref.AppSubKey
	s myobj.CorrespondingClass = ObjPref.CorrespondingClass
	s myobj.DataMapMode = ObjPref.DataMapMode
	s myobj.DataSplitString = ObjPref.DataSplitString
	s myobj.ObjectReference = ObjPref.ObjectReference
	s myobj.ObjectType = ObjPref.ObjectType
	
	d myobj.%Save()
	If ($System.Status.IsError(sc))
	{
		Do $System.Status.DisplayError(sc)
		Set myrtn = "-101"	;卡状态信息保存失败
	}
	
	d myobj.%Close()
	
	q myrtn
}

ClassMethod DHCDeleteByRowID(RowID As %String) As %String
{
	d ##class(User.BDPPreferences).%DeleteId(RowID)
}

/// 获取对应的值 ReadDataByReference
ClassMethod DHCGetDataByReference(ObjectType As %String, ObjectReference As %String, SubKey As %String) As %String
{
	;w ##class(web.BDP.sys.Preferences).GetData(ObjectType, ObjectReference, AppKey, AppSubKey)
	
	s myPRowID=..DHCGetRowID(ObjectType, ObjectReference, SubKey)
	s myData=""
	q:(myPRowID="") myData
	s myObj=##class(User.BDPPreferences).%OpenId(myPRowID)
	s myData=myObj.Data
	
	d myObj.%Close()
	
	q myData
}

ClassMethod DHCGetObjectByReference(ObjectType As %String, ObjectReference As %String, SubKey As %String) As %ObjectHandle
{
	s myPRowID=..DHCGetRowID(ObjectType, ObjectReference, SubKey)
	s myPreObj=""
	i myPRowID'=""{
		
		s myPreObj=..DHCGetDataObjectByRowID(myPRowID)
	}
	
	q myPreObj
}

ClassMethod DHCGetDataObjectBySession(SessionStr As %String, SubKey As %String) As %ObjectHandle
{
	;IP, UserID, LocID, GroupID, User.CTHospital SiteCode
	;s obj=##class(web.BDP.sys.PatEnroll).DHCGetDataObjectBySession("^^1^^^^")
	s ^TMPSessionStr=SessionStr
	i SessionStr=""{
		;s SessionStr=..DHCGetDefaultSystemSession()
	}
	s myIP=$p(SessionStr,"^",1)
	s myUserID=$p(SessionStr,"^",2)
	s myLocID=$p(SessionStr,"^",3)
	s myGroupID=$p(SessionStr,"^",4)
	s myHospitalID=$p(SessionStr,"^",5)
	s mySiteCODE=$p(SessionStr,"^",6)
	s context=""
	
	s myobj=..DHCGetDataObject(myIP, myUserID, myLocID, myGroupID, myHospitalID, mySiteCODE, context, SubKey)
	q myobj
}

ClassMethod DHCGetDOByDefaultSession(SubKey As %String) As %ObjectHandle
{
	;IP, UserID, LocID, GroupID, User.CTHospital SiteCode
	;s obj=##class(web.BDP.sys.PatEnroll).DHCGetDOByDefaultSession()
	;%session.Get("")
	s mySessionStr=..DHCGetDefaultSystemSession()
	
	s myobj=..DHCGetDataObjectBySession(mySessionStr, SubKey)
	
	q myobj
}

/// 根据Session获取Data数据
ClassMethod DHCGetDataByDefaultSession(SubKey As %String) As %String
{
	;IP, UserID, LocID, GroupID, User.CTHospital SiteCode
	;s obj=##class(web.BDP.sys.PatEnroll).DHCGetDOByDefaultSession()
	;m ^TMPSSSSS=%session.Data
	;%session.Get("")
	s mySessionStr=..DHCGetDefaultSystemSession()
	
	s myData = ""
	s myobj=..DHCGetDataObjectBySession(mySessionStr, SubKey)
	if ($IsObject(myobj)){
		s myData = myobj.Data
	}
	
	k myobj
	
	q myData
}

ClassMethod DHCGetDefaultSystemSession() As %String
{
	;s obj=##class(web.BDP.sys.PatEnroll).DHCGetDefaultSystemSession()
	s myIP=$g(%session.Data("REMOTE_ADDR"))		;$g(%session.Get(""))
	s myUserID=$g(%session.Data("LOGON.USERID"))
	s myLocID=$g(%session.Data("LOGON.CTLOCID"))
	s myGroupID=$g(%session.Data("LOGON.GROUPID"))
	s myHospitalID=""		;$g(%session.Get(""))
	s mySiteCODE=$g(%session.Data("LOGON.SITECODE"))
	s context=""
	
	s mystr=myIP_"^"_myUserID_"^"_myLocID_"^"_myGroupID_"^"_myHospitalID_"^"_mySiteCODE_"^"_context
	q mystr
}

/// IP As %Library.String, 
/// UserID As %Library.String, 
/// GroupID As %Library.String, 
/// SiteCODE As %Library.String, 
/// context As %Library.String, 
/// ByRef app As %Library.String, 
/// key As %Library.String, 
/// subkey As %Library.String, 
/// LocID As %String = ""
/// 
/// prior List
/// IP, UserID, LocID, GroupID, User.CTHospital SiteCode
/// IP, U, L, G, H, S
ClassMethod DHCGetDataObject(IP As %Library.String, UserID As %Library.String, LocID As %String = "", GroupID As %Library.String, HospitalID As %String, SiteCODE As %Library.String, context As %Library.String = "", SubKey As %String) As %ObjectHandle
{
	s IP=$g(IP)
	
	s myPreObj=""
	s myPRowID=""
	;1. IP
	s myPRowID=..DHCGetRowID("IP", IP, SubKey)
	
	;2. User
	if (myPRowID=""){
		s myPRowID=..DHCGetRowID("U", UserID, SubKey)
		
	}
	
	;3. LocID
	i myPRowID=""{
		s myPRowID=..DHCGetRowID("L", LocID, SubKey)
		
	}
	
	;4. GroupID
	i myPRowID=""{
		s myPRowID=..DHCGetRowID("G", GroupID, SubKey)
	}
	
	;5. Hospital
	i myPRowID=""{
		;HospitalCode
		s myPRowID=..DHCGetRowID("H", HospitalID, SubKey)
	}
	
	;6. SiteCODE
	i myPRowID=""{
		s myPRowID=..DHCGetRowID("S", SiteCODE, SubKey)
	}
	
	i myPRowID'=""{
		
		s myPreObj=..DHCGetDataObjectByRowID(myPRowID)
	}
	
	q myPreObj
}

/// 通过RowID 获取Object==User.DBPPreferrences
ClassMethod DHCGetDataObjectByRowID(PRowID As %String) As %ObjectHandle
{
	s myDataObj=""
	
	s myObj=##class(User.BDPPreferences).%OpenId(PRowID)
	
	q myObj
}

ClassMethod DHCGetRowID(ObjectType As %String, ObjectReference As %String, SubKey As %String) As %String
{
	;^User.BDPPreferencesI("UqIndex"," U"," 12"," E"," CARD",1)=
	s myRowID=""
	;UqIndex
	q:(ObjectType="") myRowID
	q:(ObjectReference="") myRowID
	q:(..#ParaAppKey="") myRowID
	q:(SubKey="") myRowID
	
	s myObjectType=" "_$ZConvert(ObjectType,"U")
	s myObjectReference=" "_$ZConvert(ObjectReference,"U")
	s myParaAppKey=" "_$ZConvert(..#ParaAppKey,"U")
	s myParaAppSubKey=" "_$ZConvert(SubKey,"U")
	
	s myRowID=$o(^User.BDPPreferencesI("UqIndex", myObjectType, myObjectReference, myParaAppKey, myParaAppSubKey, 0))
	
	q myRowID
}

}
