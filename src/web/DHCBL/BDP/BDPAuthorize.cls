Import SQLUser

/// 名称: 功能元素授权
/// 描述: 功能元素授权
/// 编写者：基础数据平台组-杨本庆
/// 编写日期: 2018-5-5
Class web.DHCBL.BDP.BDPAuthorize Extends %RegisteredObject [ ProcedureBlock ]
{

/// 快速排序
ClassMethod QuickSort(ByRef a As %String, left As %String, right As %String) As %String
{
	s m=a(left),temp=0
	s i=left,j=right
	
	while (i<j)
	{
		for
		{
			if ((i<j)&(a(j)>=m))  s j=j-1        //a(j)>=m ,不加=号的话，当输入相等的数时会报错
 			else  s temp=m,a(i)=a(j),a(j)=temp 
 			quit:a(j)=m
		}
 		for
		{
 			if ((i<j)&(a(i)<=m)) s i=i+1         //a(i)<=m ,不加=号的话，当输入相等的数时会报错
 			else  s temp=m,a(j)=a(i),a(i)=temp
 			quit:a(i)=m 
		}
	}
 	s a(i)=m
 	if ((i-left)> 1)
    {
 		d ..QuickSort(.a,left,i-1)
	}
 	if ((right-i)> 1)  
	{
 		d ..QuickSort(.a,i+1,right)
	}
    quit i
}

/// 获取功能JSON串new
/// 分级
/// w ##class(web.DHCBL.BDP.BDPAuthorize).GetExecutableTreeJsonNew("")
ClassMethod GetExecutableTreeJsonNew(ParentID As %String) As %String
{
	if (ParentID="") s ParentID=-100000000000000
	s mySMRowID=0
	s myMenuCount=0
	s mySMSeq=0
	k myMenuArray
	
	//生成菜单索引数组
	s mySMSeq=0
	s n=0
	for {
		s mySMSeq=$o(^User.BDPMenuI("ParSeqIdx",ParentID,mySMSeq))
		q:(mySMSeq="")
		s n=n+1
		s a(n)= $p(mySMSeq," ",2)
	}
	set left=1,right=n
	d:$d(a) ..QuickSort(.a,left,right) //排序
	s mySMRowID=0
	s n=0
	s mySMSeq=0
	for {
		s n=$o(a(n))
		q:(n="")
		s mySMSeq=$g(a(n))
		for {
			s mySMRowID=$o(^User.BDPMenuI("ParSeqIdx",ParentID," "_mySMSeq,mySMRowID))
			q:(mySMRowID="")
			s myMenuCount=myMenuCount+1
			s myMenuArray(myMenuCount)=mySMRowID
			;w !,mySMRowID
		}
	}
	
	//输出菜单JSON串
	s mySMRowID=0
	s myMenuSeq=0
	s myJsonStr=""
	
	for {
		s myMenuSeq=$o(myMenuArray(myMenuSeq))
		q:(myMenuSeq="")
		s mySMRowID=$g(myMenuArray(myMenuSeq))
		continue:mySMRowID=1 //屏蔽菜单:"系统配置"
		;continue:mySMRowID=282 //屏蔽菜单:"产品组配置"
		
		s myMenuObj=##Class(User.BDPMenu).%OpenId(mySMRowID,0)
		if $IsObject(myMenuObj) {
			s myCode = myMenuObj.Code
			s myCaption = myMenuObj.Caption
			s myLinkUrl = myMenuObj.LinkUrl
			s myImage = myMenuObj.Image
			s:myImage'="" myImage= "../scripts/bdp/Framework/BdpIconsLib/"_myMenuObj.Image
			s myFuntionDR = myMenuObj.LinkFuntionDR
			s myExeCode = myMenuObj.LinkFuntionDR.Code
			s myActiveFlag = myMenuObj.ActiveFlag
			continue:(myActiveFlag'="")&&('$p(myActiveFlag,"^",2)) //查看该菜单是否被激活
			
			//判断是否有子菜单
			if (myLinkUrl="") s myChildFlag=1
			else  s myChildFlag=0
			
			s:(myJsonStr'="") myJsonStr=myJsonStr_","
			s myJsonStr=myJsonStr_"{"
			s myJsonStr=myJsonStr_"""id"":"""_""_mySMRowID_""",""text"":"""_myCaption_""","
			s myJsonStr=myJsonStr_"""state"":""open"""
			if (myChildFlag'=0) {
				//获取子菜单
				s myJsonStr=myJsonStr_",""children"":"_..GetExecutableTreeJsonNew(mySMRowID)
			}
			s myJsonStr=myJsonStr_"}"
			
			d myMenuObj.%Close()
		}
	}
	
	k myMenuArray
	s myJsonStr="["_myJsonStr_"]"
	
	q myJsonStr
}

/// w ##class(web.DHCBL.BDP.BDPAuthorize).GetIndexcsp(1502)
ClassMethod GetIndexcsp(id As %String) As %ListOfDataTypes
{
	s rtn=""
	s:id'="" rtn=$lg(^User.BDPMenuD(id),5) 
	q rtn
}

/// w ##class(web.DHCBL.BDP.BDPAuthorize).GetAuthorizeData("G",2,"1502")
ClassMethod GetAuthorizeData(ObjectType As %String, ObjectReference As %String, id As %String) As %String
{
	s rtn=""
	s myPRowID=..DHCGetRowIDNew(ObjectType,ObjectReference,id)
	s:myPRowID'="" rtn=$lg(^User.BDPAuthorizeD(myPRowID),7) 
	q rtn
}

/// w ##class(web.DHCBL.BDP.BDPAuthorize).DHCGetRowIDNew("G",2,"1")
ClassMethod DHCGetRowIDNew(ObjectType As %String, ObjectReference As %String, id As %String) As %String
{
	;^User.BDPAuthorizeI("UqIndex"," U"," 12"," E"," CARD",1)=
	s myRowID=""
	;UqIndex
	q:(ObjectType="") myRowID
	q:(ObjectReference="") myRowID
	//q:(..#ParaAppKey="") myRowID
	q:(id="") myRowID
	
	s myObjectType=" "_$ZConvert(ObjectType,"U")
	s myObjectReference=" "_$ZConvert(ObjectReference,"U")
	s myParaAppKey=" "_"E" //$ZConvert(..#ParaAppKey,"U")
	s myParaAppid=" "_$ZConvert(id,"U")
	
	s myRowID=$o(^User.BDPAuthorizeI("UqIndex", myObjectType, myObjectReference, myParaAppKey, myParaAppid, 0))
	
	q myRowID
}

/// / 
ClassMethod DHCSaveDataToServerNew(ObjectType As %String, ObjectReference As %String, Data As %String, id As %String) As %String
{
	; w ##class(web.BDP.sys.PatEnroll).DHCSaveDataToServer("G",125,^TMPXmlData)
	; 生成 web.DHCEntity.Configure.ObjectPreferences 对象
	
	s ^TMPXmlData=Data
	
	s myrtn=0
	
	s mySaveXmlData = Data
	s myPreObj=##class(web.Entity.BDP.ObjectPreferences).%New()
	
	s myPreObj.AppKey="E"
	s myPreObj.AppSubKey = id
	s myPreObj.Data=mySaveXmlData
	s myPreObj.CorrespondingClass="web.Entity.Authorize.Executables"
	s myPreObj.DataSplitString = "JSON"
	s myPreObj.ObjectReference=ObjectReference
	s myPreObj.ObjectType =ObjectType
	b
	s myrtn=..DHCSaveInfoNew(myPreObj)
	
	d myPreObj.%Close()
	k myPreObj
	
	q myrtn
}

///  保存基本信息, 包换 Add Update
/// 保存信息 By XML
/// web.Entity.BDP.ObjectPreferences
/// web.DHCEntity.Configure.ObjectPreferences
ClassMethod DHCSaveInfoNew(ObjPref As web.Entity.BDP.ObjectPreferences) As %String
{
	s myrtn=0
	s myPRowID=..DHCGetRowIDNew(ObjPref.ObjectType, ObjPref.ObjectReference, ObjPref.AppSubKey)
	i myPRowID="" d
	.s myobj=##class(User.BDPAuthorize).%New()
	e  d
	.s myobj=##class(User.BDPAuthorize).%OpenId(myPRowID)
	.s JsonStrU="{RowId:"_$c(34)_myPRowID_$c(34)_",AppKey:"_$c(34)_myobj.AppKey_$c(34)_",AppSubKey:"_$c(34)_myobj.AppSubKey_$c(34)_",CorrespondingClass:"_$c(34)_myobj.CorrespondingClass_$c(34)_",Data:"_$c(34)_myobj.Data_$c(34)_",DataSplitString:"_$c(34)_myobj.DataSplitString_$c(34)_",ObjectReference:"_$c(34)_myobj.ObjectReference_$c(34)_",ObjectType:"_$c(34)_myobj.ObjectType_$c(34)_"}"
	
	
	s myobj.AppKey = ObjPref.AppKey
	s myobj.AppSubKey = ObjPref.AppSubKey
	s myobj.CorrespondingClass = ObjPref.CorrespondingClass
	//s:ObjPref.Data'="" myobj.Data = myobj.Data_"^"_ObjPref.Data
	if (ObjPref.Data'="")
	{
		if (myobj.Data[$p(ObjPref.Data,":",1))
		{
			s len=$L(myobj.Data,"^")
			s i=1
			for
			{
				s Data=$p(myobj.Data,"^",i)
				q:i>len
				if Data[$p(ObjPref.Data,":",1) 
				{
					s myobjData=myobj.Data
					s $p(myobjData,"^",i)=ObjPref.Data
					s myobj.Data=myobjData
				}
				s i=i+1
			}
		}
		else
		{
			s:myobj.Data'="" myobj.Data = myobj.Data_"^"_ObjPref.Data
			s:myobj.Data="" myobj.Data = ObjPref.Data
		}
	}
	
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
	b
	d myobj.%Close()
	
	s JsonStr="{RowId:"_$c(34)_myPRowID_$c(34)_",AppKey:"_$c(34)_myobj.AppKey_$c(34)_",AppSubKey:"_$c(34)_myobj.AppSubKey_$c(34)_",CorrespondingClass:"_$c(34)_myobj.CorrespondingClass_$c(34)_",Data:"_$c(34)_myobj.Data_$c(34)_",DataSplitString:"_$c(34)_myobj.DataSplitString_$c(34)_",ObjectReference:"_$c(34)_myobj.ObjectReference_$c(34)_",ObjectType:"_$c(34)_myobj.ObjectType_$c(34)_"}"
	if (myPRowID'="")
	{
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("BDP_Preferences","User.BDPAuthorize","授权功能",myPRowID,myobj.ObjectType_"->"_myobj.ObjectReference,"U",JsonStr,JsonStrU)
	}
	else
	{
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("BDP_Preferences","User.BDPAuthorize","授权功能",myobj.%Id(),myobj.ObjectType_"->"_myobj.ObjectReference,"A",JsonStr)
	}
	q myrtn
}

/// w ##class(web.DHCBL.Authorize.Executables).SaveAuthorizeDataNew("G",1,"{add_btn:ensable}","1502")
ClassMethod SaveAuthorizeDataNew(ObjectType As %String, ObjectReference As %String, Data As %String, id As %String) As %String
{
	s flag=""
	s flag = ..DHCSaveDataToServerNew(ObjectType,ObjectReference,Data,id)
	if (flag=0){
		s result = "{success:'true',info:'保存成功'}"
	}else{
		s result = "{success:'false',errorinfo:'保存失败'}"
	}
	q result
}

/// d ##class(web.DHCBL.BDP.BDPAuthorize).BuildAryByCodeNew("")
/// 2018-5-4 by ybq
ClassMethod BuildAryByCodeNew(id As %String, ObjectType As %String, ObjectReference As %String) As %String
{
 //s code = $ZCONVERT(code,"U")
 //s rowid = $o(^User.BDPExecutablesI("CodeIndex"," "_code,""))
 //q:rowid=""
 //s ItemStr=##class(web.DHCBL.Authorize.Executables).DHCGetDataByDefaultSession(code)
 	if (ObjectType="") s ItemStr=..DHCGetDataByDefaultSessionNew(id) 
 	if (ObjectType'="") s ItemStr= ##class(web.DHCBL.BDP.BDPAuthorize).GetAuthorizeData(ObjectType,ObjectReference,id) 
 	s falg = ##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPDisableDel") //判断是否默认禁用删除按钮
 	s ^tmp(1)=falg
 	w !
 	w !,"<script type=""text/javascript"">",!
  	w "BDPFunLibDisableArray = new Array();",!
  	s num=1
  	for
  	{
	  	s len=$l(ItemStr,"^")
	  	q:num>len
	  	s disdata=$p(ItemStr,"^",num)
	  	if (disdata["del_btn")&(falg="Y")
	  	{
		  	s $p(disdata,":",2)="disable"
		}
		if ($p(disdata,":",2)="disable")
		{
			w !,"BDPFunLibDisableArray["""_$p(disdata,":",1)_"""]="""_$p(disdata,":",2)_""";"
		}
	  	s num=num+1
	  	
	
	}
  	w !,"</script>"
  	w !
}

/// 根据Session获取Data数据
ClassMethod DHCGetDataByDefaultSessionNew(id As %String) As %String
{
	;IP, UserID, LocID, GroupID, User.CTHospital SiteCode
	;s obj=##class(web.BDP.sys.PatEnroll).DHCGetDOByDefaultSession()
	;m ^TMPSSSSS=%session.Data
	;%session.Get("")
	s mySessionStr=##class(web.BDP.sys.PreferencesSubKey).DHCGetDefaultSystemSession()
	
	s myData = ""
	s myobj=..DHCGetDataObjectBySessionNew(mySessionStr, id)
	if ($IsObject(myobj)){
		s myData = myobj.Data
	}
	
	k myobj
	
	q myData
}

ClassMethod DHCGetDataObjectBySessionNew(SessionStr As %String, id As %String) As %ObjectHandle
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
	
	s myobj=..DHCGetDataObjectNew(myIP, myUserID, myLocID, myGroupID, myHospitalID, mySiteCODE, context, id)
	q myobj
}

ClassMethod DHCGetDataObjectNew(IP As %Library.String, UserID As %Library.String, LocID As %String = "", GroupID As %Library.String, HospitalID As %String, SiteCODE As %Library.String, context As %Library.String = "", id As %String) As %ObjectHandle
{
	s IP=$g(IP)
	
	s myPreObj=""
	s myPRowID=""
	;1. IP
	s myPRowID=..DHCGetRowIDNew("IP", IP, id)
	
	;2. User
	if (myPRowID=""){
		s myPRowID=..DHCGetRowIDNew("U", UserID, id)
		
	}
	
	;3. LocID
	i myPRowID=""{
		s myPRowID=..DHCGetRowIDNew("L", LocID, id)
		
	}
	
	;4. GroupID
	i myPRowID=""{
		s myPRowID=..DHCGetRowIDNew("G", GroupID, id)
	}
	
	;5. Hospital
	i myPRowID=""{
		;HospitalCode
		s myPRowID=..DHCGetRowIDNew("H", HospitalID, id)
	}
	
	;6. SiteCODE
	i myPRowID=""{
		s myPRowID=..DHCGetRowIDNew("S", SiteCODE, id)
	}
	
	i myPRowID'=""{
		
		s myPreObj=..DHCGetDataObjectByRowIDNew(myPRowID)
	}
	
	q myPreObj
}

/// 通过RowID 获取Object==User.BDPAuthorize
ClassMethod DHCGetDataObjectByRowIDNew(PRowID As %String) As %ObjectHandle
{
	s myDataObj=""
	
	s myObj=##class(User.BDPAuthorize).%OpenId(PRowID)
	
	q myObj
}

// w ##class(web.DHCBL.BDP.BDPAuthorize).GetMenuId("G",1)

ClassMethod GetMenuId(ObjectType As %String, ObjectReference As %String) As %ObjectHandle
{
	s MenuId=0,str="",itemid="",ItemStr=""
	for
	{
		s flag=0
		s MenuId=$o(^User.BDPAuthorizeI("UqIndex"," "_ObjectType," "_ObjectReference," E",MenuId))
		q:MenuId=""
		s itemid=$o(^User.BDPAuthorizeI("UqIndex"," "_ObjectType," "_ObjectReference," E",MenuId,0))
		s:itemid'="" ItemStr=$lg(^User.BDPAuthorizeD(itemid),7)
		s num=1
	  	for
	  	{
		  	s len=$l(ItemStr,"^")
		  	q:num>len
		  	s disdata=$p(ItemStr,"^",num)
		  	
			if ($p(disdata,":",2)="disable")
			{
				s flag=1
				q
			}
		  	s num=num+1
		  	
		
		}
		if (flag=1){
			s:str'="" str=str_"^"_MenuId
			s:str="" str=MenuId
		}
			
	}
	q str
}

}
