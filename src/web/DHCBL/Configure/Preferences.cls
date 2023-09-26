/// /  组件名称前缀 DHCCON.
Class web.DHCBL.Configure.Preferences Extends (%RegisteredObject, %XML.Adaptor) [ Abstract, ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter ParaAppKey;

Parameter ParaAppSubKey;

Parameter EntityClassName;

Parameter EntityClassNameDisplay;

/// 删除 此应用的所有设置, 慎用
ClassMethod DHCDeleteAll() As %String
{
}

ClassMethod DHCDeleteData(ObjectType As %String, ObjectReference As %String) As %String
{
	s myrtn=0
	
	s myPRowID=..DHCGetRowID(ObjectType, ObjectReference)
	
	q:(myPRowID="") myrtn
	s myrtn=..DHCDeleteByRowID(myPRowID)
	
	q myrtn
}

///  保存基本信息, 包换 Add Update
/// 保存信息 By XML
ClassMethod DHCSaveInfoByXml(ObjPref As web.DHCEntity.Configure.ObjectPreferrences) As %String
{
	s myrtn=0
	s myPRowID=..DHCGetRowID(ObjPref.ObjectType, ObjPref.ObjectReference)
	i myPRowID="" d
	.s myobj=##class(User.DHCPreferences).%New()
	e  d
	.s myobj=##class(User.DHCPreferences).%OpenId(myPRowID)
	
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
	
	q myrtn
}

ClassMethod DHCSaveDataToServer(ObjectType As %String, ObjectReference As %String, XmlData As %String) As %String
{
	; 反序列化
	; w ##class(web.DHCBL.Configure.PatEnroll).DHCSaveDataToServer("G",125,^TMPXmlData)
	; 生成 web.DHCEntity.Configure.ObjectPreferrences 对象
	
	s ^TMPXmlData=XmlData
	
	s myrtn=0
	
	Set myDataObj = $System.OBJ.New(..#EntityClassName)
	d myDataObj.XMLDeserialize(.myDataObj, XmlData)
	d myDataObj.XMLExportToString(.mySaveXmlData)
	
	s myPreObj=##class(web.DHCEntity.Configure.ObjectPreferrences).%New()
	
	s myPreObj.AppKey=..#ParaAppKey
	s myPreObj.AppSubKey=..#ParaAppSubKey
	s myPreObj.Data=mySaveXmlData
	s myPreObj.CorrespondingClass=..#EntityClassName
	s myPreObj.DataSplitString="XML"
	s myPreObj.ObjectReference=ObjectReference
	s myPreObj.ObjectType =ObjectType
	
	s myrtn=..DHCSaveInfoByXml(myPreObj)
	
	d myDataObj.%Close()
	d myPreObj.%Close()
	
	q myrtn
}

/// 保存信息 ^ 等
ClassMethod DHCSaveInfoBySplit(ObjPref As web.DHCEntity.Configure.ObjectPreferrences) As %String
{
	s myrtn=0
	
	s myPRowID=..DHCGetRowID(ObjPref.ObjectType, ObjPref.ObjectReference)
	i myPRowID="" d
	.s myobj=##class(User.DHCPreferences).%New()
	e  d
	.s myobj=##class(User.DHCPreferences).%OpenId(myPRowID)
	
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
	q ##class(User.DHCPreferences).%DeleteId(RowID)
}

/// 获取对应的值 ReadDataByReference
ClassMethod DHCGetDataByReference(ObjectType As %String, ObjectReference As %String) As %String
{
	;w ##class(web.DHCBL.Configure.Preferences).GetData(ObjectType, ObjectReference, AppKey, AppSubKey)
	
	s myPRowID=..DHCGetRowID(ObjectType, ObjectReference)
	s myData=""
	q:(myPRowID="") myData
	s myObj=##class(User.DHCPreferences).%OpenId(myPRowID)
	s myData=myObj.Data
	
	d myObj.%Close()
	
	q myData
}

ClassMethod DHCGetObjectByReference(ObjectType As %String, ObjectReference As %String) As %ObjectHandle
{
	s myPRowID=..DHCGetRowID(ObjectType, ObjectReference)
	s myPreObj=""
	i myPRowID'=""{
		b	;GetObject
		s myPreObj=..DHCGetDataObjectByRowID(myPRowID)
	}
	
	q myPreObj
}

/// / 为了现实配置界面
ClassMethod DHCGetDataForDisplay(ObjectType As %String, ObjectReference As %String) As %String
{
	;w ##class(web.DHCBL.Configure.Preferences).GetData(ObjectType, ObjectReference, AppKey, AppSubKey)
	;w ##class(web.DHCBL.Configure.PatEnroll).DHCGetDataForDisplay("U", 6)
	s myPRowID=..DHCGetRowID(ObjectType, ObjectReference)
	s myData=""
	q:(myPRowID="") myData
	s myDataObj=..DHCGetDataObjectByRowID(myPRowID)
	
	s myOutObj=..DTOTransObjForDisplay(myDataObj)
	
	s myOutXmlData=""
	if $IsObject(myOutObj){
		d myOutObj.XMLExportToString(.myOutXmlData)
		d myOutObj.%Close()
	}
	
	d myDataObj.%Close()
	
	q myOutXmlData
}

ClassMethod DTOTransObjForDisplay(DTObj As %ObjectHandle) As %ObjectHandle
{
	q ""
}

ClassMethod DHCGetDataObjectBySession(SessionStr As %String) As %ObjectHandle
{
	;IP, UserID, LocID, GroupID, User.CTHospital SiteCode
	;s obj=##class(web.DHCBL.Configure.PatEnroll).DHCGetDataObjectBySession("^^1^^^^")
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
	
	s myobj=..DHCGetDataObject(myIP, myUserID, myLocID, myGroupID, myHospitalID, mySiteCODE, context)
	q myobj
}

ClassMethod DHCGetDOByDefaultSession() As %ObjectHandle
{
	;IP, UserID, LocID, GroupID, User.CTHospital SiteCode
	;s obj=##class(web.DHCBL.Configure.PatEnroll).DHCGetDOByDefaultSession()
	m ^TMPSSSSS=%session.Data
	;%session.Get("")
	s mySessionStr=..DHCGetDefaultSystemSession()
	
	s myobj=..DHCGetDataObjectBySession(mySessionStr)
	
	q myobj
}

ClassMethod DHCGetDefaultSystemSession() As %String
{
	;s obj=##class(web.DHCBL.Configure.PatEnroll).DHCGetDefaultSystemSession()
	s myIP=$g(%session.Data("REMOTE_ADDR"))		;$g(%session.Get(""))
	s myUserID=$g(%session.Data("LOGON.USERID"))
	s myLocID=$g(%session.Data("LOGON.CTLOCID"))
	s myGroupID=$g(%session.Data("LOGON.GROUPID"))
	s myHospitalID=$g(%session.Data("LOGON.HOSPID"))		;$g(%session.Get(""))
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
ClassMethod DHCGetDataObject(IP As %Library.String, UserID As %Library.String, LocID As %String = "", GroupID As %Library.String, HospitalID As %String, SiteCODE As %Library.String, context As %Library.String = "") As %ObjectHandle
{
	s IP=$g(IP)
	
	s myPreObj=""
	s myPRowID=""
	;1. IP
	s myPRowID=..DHCGetRowID("IP", IP)
	
	;2. User
	if (myPRowID=""){
		s myPRowID=..DHCGetRowID("U", UserID)
		
	}
	
	;3. LocID
	i myPRowID=""{
		s myPRowID=..DHCGetRowID("L", LocID)
		
	}
	
	;4. GroupID
	i myPRowID=""{
		s myPRowID=..DHCGetRowID("G", GroupID)
	}
	
	;5. Hospital
	i myPRowID=""{
		;HospitalCode
		s myPRowID=..DHCGetRowID("H", HospitalID)
	}
	
	;6. SiteCODE
	i myPRowID=""{
		s myPRowID=..DHCGetRowID("S", SiteCODE)
	}
	
	i myPRowID'=""{
		
		s myPreObj=..DHCGetDataObjectByRowID(myPRowID)
	}
	
	q myPreObj
}

/// 通过RowID 获取Object
ClassMethod DHCGetDataObjectByRowID(PRowID As %String) As %ObjectHandle
{
	s myDataObj=""
	
	s myObj=##class(User.DHCPreferences).%OpenId(PRowID)
	s myData=myObj.Data
	s myDataSplitString = myObj.DataSplitString
	s myCorrespondingClass=myObj.CorrespondingClass
	
	i $System.OBJ.IsValidClassname(myCorrespondingClass){
	
		Set myDataObj = $System.OBJ.New(myCorrespondingClass)
		;b	;;Desc
		;反序列化
		d myDataObj.XMLDeserialize(.myDataObj, myData)
	}
	
	d myObj.%Close()
	
	q myDataObj
}

ClassMethod DHCGetRowID(ObjectType As %String, ObjectReference As %String) As %String
{
	;^User.DHCPreferencesI("UqIndex"," U"," 12"," E"," CARD",1)=
	s myRowID=""
	;UqIndex
	q:(ObjectType="") myRowID
	q:(ObjectReference="") myRowID
	q:(..#ParaAppKey="") myRowID
	q:(..#ParaAppSubKey="") myRowID
	
	s myObjectType=" "_$ZConvert(ObjectType,"U")
	s myObjectReference=" "_$ZConvert(ObjectReference,"U")
	s myParaAppKey=" "_$ZConvert(..#ParaAppKey,"U")
	s myParaAppSubKey=" "_$ZConvert(..#ParaAppSubKey,"U")
	s myRowID=$o(^User.DHCPreferencesI("UqIndex", myObjectType, myObjectReference, myParaAppKey, myParaAppSubKey, 0))
	q myRowID
}

ClassMethod Test() As %String
{
	w ..#EntityClassName
}

ClassMethod DHCSaveDataToServerNew(RowId As %String, ObjectType As %String, ObjectReference As %String, XmlData As %String) As %String
{
	
	; 反序列化
	; w ##class(web.DHCBL.Configure.PatEnroll).DHCSaveDataToServer("L",2,^TMPXmlData)
	; 生成 web.DHCEntity.Configure.ObjectPreferrences 对象
	s ^dhcDHCSaveDataToServer=ObjectType_","_ObjectReference
	s ^TMPXmlData=XmlData
	
	s id=..DHCGetRowID(ObjectType,ObjectReference)
	if (RowId="")&&(id'=""){
		Quit "-1"
	}
	s myrtn=0
	
	Set myDataObj = $System.OBJ.New(..#EntityClassName)
	d myDataObj.XMLDeserialize(.myDataObj, XmlData)
	d myDataObj.XMLExportToString(.mySaveXmlData)
	
	s myPreObj=##class(web.DHCEntity.Configure.ObjectPreferrences).%New()
	
	s myPreObj.AppKey=..#ParaAppKey
	s myPreObj.AppSubKey=..#ParaAppSubKey
	s myPreObj.Data=mySaveXmlData
	s myPreObj.CorrespondingClass=..#EntityClassName
	s myPreObj.DataSplitString="XML"
	s myPreObj.ObjectReference=ObjectReference
	s myPreObj.ObjectType =ObjectType
	
	s myrtn=..DHCSaveInfoByXmlNew(RowId,myPreObj)
	
	d myDataObj.%Close()
	d myPreObj.%Close()
	
	q myrtn
}

///  保存基本信息, 包换 Add Update
/// 保存信息 By XML
ClassMethod DHCSaveInfoByXmlNew(RowId As %String, ObjPref As web.DHCEntity.Configure.ObjectPreferrences) As %String
{
	s myrtn=0
	s myPRowID=RowId
	i myPRowID="" d
	.s myobj=##class(User.DHCPreferences).%New()
	e  d
	.s myobj=##class(User.DHCPreferences).%OpenId(myPRowID)
	
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
	
	q myrtn
}

}
