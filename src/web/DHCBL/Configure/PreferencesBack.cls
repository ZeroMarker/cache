Class web.DHCBL.Configure.PreferencesBack Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter ParaAppKey;

Parameter ParaAppSubKey;

Parameter EntityClassName;

ClassMethod DeleteData(AppKey As %String, AppSubKey As %String, ObjectType As %String, ObjectReference As %String) As %String
{
	s myrtn=0
	
	s myPRowID=..GetRowID(ObjectType, ObjectReference, AppKey, AppSubKey)
	
	q:(myPRowID="") myrtn
	s myrtn=..DeleteByRowID(myPRowID)
	
	q myrtn
}

///  保存基本信息, 包换 Add Update
/// 保存信息 By XML
ClassMethod SaveInfoByXml(ObjPref As web.DHCEntity.Configure.ObjectPreferrences) As %String
{
	s myrtn=0
	s myPRowID=..GetRowID(ObjectType, ObjectReference, AppKey, AppSubKey)
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
	
	d myobj.%Close()
	
	q myrtn
}

/// 保存信息 ^ 等
ClassMethod SaveInfoBySplit(ObjPref As web.DHCEntity.Configure.ObjectPreferrences) As %String
{
	s myrtn=0
	
	s myPRowID=..GetRowID(ObjectType, ObjectReference, AppKey, AppSubKey)
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
	
	d myobj.%Close()
	
	q myrtn
}

ClassMethod DeleteByRowID(RowID As %String) As %String
{
	d ##class(User.DHCPreferences).%DeleteId(RowID)
}

/// 获取对应的值
ClassMethod GetData(ObjectType As %String, ObjectReference As %String, AppKey As %String, AppSubKey As %String) As %String
{
	;w ##class(web.DHCBL.Configure.Preferences).GetData(ObjectType, ObjectReference, AppKey, AppSubKey)
	
	s myPRowID=..GetRowID(ObjectType, ObjectReference, AppKey, AppSubKey)
	s myData=""
	q:(myPRowID="") myData
	s myObj=##class(User.DHCPreferences).%OpenId(myPRowID)
	s myData=myObj.Data
	
	d myObj.%Close()
	
	q myData
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
ClassMethod GetDataObject(AppKey As %String, AppSubKey As %String, IP As %Library.String, UserID As %Library.String, LocID As %String = "", GroupID As %Library.String, HospitalID As %String, SiteCODE As %Library.String, context As %Library.String = "") As %ObjectHandle
{
	s IP=$g(IP)
	
	s myPreObj=""
	s myPRowID=""
	;1. IP
	s myPRowID=..GetRowID("IP", IP, AppKey, AppSubKey)
	
	;2. User
	if (myPRowID=""){
		s myPRowID=..GetRowID("U", UserID, AppKey, AppSubKey)
	}
	
	;3. LocID
	i myPRowID=""{
		s myPRowID=..GetRowID("G", LocID, AppKey, AppSubKey)
	}
	
	;4. GroupID
	i myPRowID=""{
		s myPRowID=..GetRowID("G", GroupID, AppKey, AppSubKey)
	}
	
	;5. Hospital
	i myPRowID=""{
		;HospitalCode
		s myPRowID=..GetRowID("H", HospitalID, AppKey, AppSubKey)
	}
	
	;6. SiteCODE
	i myPRowID=""{
		s myPRowID=..GetRowID("S", SiteCODE, AppKey, AppSubKey)
	}
	
	i myPRowID'=""{
		s myPreObj=..GetDataObjectByRowID(myPRowID)
	}
	
	q myPreObj
}

/// 通过RowID 获取Object
ClassMethod GetDataObjectByRowID(PRowID As %String) As %ObjectHandle
{
	s myObj=##class(User.DHCPreferences).%OpenId(PRowID)
	s myData=myObj.Data
	s myDataSplitString = myObj.DataSplitString
	s myCorrespondingClass=myObj.CorrespondingClass
	
	Set myDataObj = $System.OBJ.New(myCorrespondingClass)
	
	;反序列化
	d myDataObj.XMLDeserialize(myDataObj, myData)
	
	d myObj.%Close()
	
	q myDataObj
}

ClassMethod GetRowID(ObjectType As %String, ObjectReference As %String, AppKey As %String, AppSubKey As %String) As %String
{
	s myRowID=""
	;UqIndex
	q:(ObjectType="") myRowID
	q:(ObjectReference="") myRowID
	q:(AppKey="") myRowID
	q:(AppSubKey="") myRowID
	
	s myRowID=$o(^User.DHCPreferencesI("UqIndex",ObjectType, ObjectReference, AppKey, AppSubKey, 0))
	
	q myRowID
}

ClassMethod Test() As %String
{
	w ..#EntityClassName
}

}
