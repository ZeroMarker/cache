Import SQLUser

/// 名称: 基础数据平台数据授权
/// 描述: 基础数据平台数据授权(组织结构显示)
/// 编写者：BDP-Caihaozhe
/// 编写日期: 2013-5-8
Class web.DHCBL.Authorize.BaseData Extends web.BDP.sys.PreferencesSubKey
{

/// d ##class(web.DHCBL.Authorize.BaseData).DHCSaveDataToServer("G","1","[{ID:1},{ID:2}]","CT_UOM")
/// w ##class(web.DHCBL.Authorize.BaseData).DHCGetDataByReference("G","1","CT_UOM")
Parameter ParaAppKey = "BD";

//Parameter ParaAppSubKey = "Menu";

Parameter EntityClassName;

Parameter DataSplitString = "JSON";

ClassMethod GetTreeJson(ParentID As %String, ObjectType As %String, ObjectReference As %String) As %String
{
	if (ParentID="menuTreeRoot") s ParentID=-100000000000000
	;q:ObjectReference="" ""
	s mySMRowID=0
	s myMenuCount=0
	s mySMSeq=0
	k myMenuArray
	
	//生成菜单索引数组
	s mySMSeq=0
	s n=0
	for { 					;q:(+mySMRowID>0)
		s mySMSeq=$o(^User.BDPMenuI("ParSeqIdx",ParentID,mySMSeq))
		q:(mySMSeq="")
		s n=n+1
		s a(n)= $p(mySMSeq," ",2)
	}
	set left=1,right=n
	d:$d(a) ##class(web.DHCBL.Authorize.Menu).QuickSort(.a,left,right) //排序
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
		;q:(+myMenuSeq>1)
		s myMenuSeq=$o(myMenuArray(myMenuSeq))
		q:(myMenuSeq="")
		s mySMRowID=$g(myMenuArray(myMenuSeq))
		q:mySMRowID=1 //屏蔽菜单:"系统配置"
		
		s myMenuObj=##Class(User.BDPMenu).%OpenId(mySMRowID,0)
		if $IsObject(myMenuObj){
			s myCode = myMenuObj.Code
			s myCaption = myMenuObj.Caption
			s myLinkUrl = myMenuObj.LinkUrl
			s myImage = myMenuObj.Image
			s:myImage'="" myImage= "../scripts/bdp/Framework/BdpIconsLib/"_myMenuObj.Image
			s myActiveFlag = myMenuObj.ActiveFlag
			continue:(myActiveFlag'="")&&('$p(myActiveFlag,"^",3)) //查看该菜单是否被激活
			
			//判断是否有子菜单
			if ((myLinkUrl="")) s myChildFlag=1
			else  s myChildFlag=0
			
			if (myLinkUrl'=""){             //BY CHZ 2017 7-16 改由从BDAJavaScriptFile获取
				s mobj = ##class(User.BDPMenu).%OpenId(mySMRowID)
				s BDAJavaScriptFile = mobj.LinkFuntionDR.BDAJavaScriptFile
				s mycode = mobj.LinkFuntionDR.Code
				d mobj.%Close()
				s urlJS= BDAJavaScriptFile
				//s myLinkUrl=myLinkUrl_"?extfilename=/"_urlJS  2014-9-15注释  解决其他产品组基础数据授权菜单显示不正确
				s myLinkUrl="dhc.bdp.ext.default.csp?extfilename=/"_urlJS 
			}
			
			//if (myLinkUrl'=""){
			//	s mobj = ##class(User.BDPMenu).%OpenId(mySMRowID)
			//	s JavaScriptFile = mobj.LinkFuntionDR.JavaScriptFile
			//	d mobj.%Close()
			//	s urlJS=$p(JavaScriptFile,"App/",2)
			//	//s urlJS=##class(web.BDP.util.String).Replace(urlJS,"_","")
			//	s myLinkUrl=myLinkUrl_"?extfilename=App/BDPSystem/Aut/"_urlJS
			//}
			
			s:(myJsonStr'="") myJsonStr=myJsonStr_","
			s myJsonStr=myJsonStr_"{"
			s myJsonStr=myJsonStr_"""id"":"""_""_mySMRowID_""",""text"":"""_myCaption_""","
			s myJsonStr=myJsonStr_"""icon"":"""_""_myImage_""","
			
			if (+myChildFlag'=0){
				s myJsonStr=myJsonStr_"""leaf"":false"
			}else{
				s myJsonStr=myJsonStr_"""myhref"":"""_""_myLinkUrl_""","
				s myJsonStr=myJsonStr_"""mycode"":"""_""_mycode_""","           //caihz 2014.8.18修改  增加页面代码传值
				s myJsonStr=myJsonStr_"""leaf"":true"
			}
			s myJsonStr=myJsonStr_"}"
			
			d myMenuObj.%Close()
		}
	}
	
	k myMenuArray
	s myJsonStr="["_myJsonStr_"]"
	
	q myJsonStr
}

/// 按照需求获取安全组的JSON串
/// ParentID： 父ID
/// ObjectType: 需要显示的优先级类别
/// ObjectReference： 在界面上 选择的 Group或者User或者CTLoc(登录科室)
ClassMethod GetGroupTreeJson(ParentID As %String, ObjectType As %String, ObjectReference As %String) As %String
{
	if (ParentID="groupTreeRoot") s ParentID=-100000000000000
	;q:ObjectReference=""
	//b		
	//输出菜单JSON串
	s GroupRowID=0
	//s myMenuSeq=0
	s myJsonStr=""
	s myImage=""

	//获取授权JSON
	//s GroupAStr=##class(web.DHCBL.Authorize.BaseData).DHCGetDataByReference(ObjectType,ObjectReference,"Group")				
	s SSGRPRowId=0
	//s ^TMPcai=GroupAStr
	;b ;1
	f{ 		
		s SSGRPRowId=$o(^SSU("SSGRP",SSGRPRowId)) q:SSGRPRowId=""
		;b ;21
		s SSGRPDesc=$p($g(^SSU("SSGRP",SSGRPRowId)),"^",1)			
		//判断菜单是否已授权,有则checked:true
		s strGroup="{ID:"_SSGRPRowId_"}"	
		s:(myJsonStr'="") myJsonStr=myJsonStr_","
		s myJsonStr=myJsonStr_"{"
		s myJsonStr=myJsonStr_"""id"":"""_""_SSGRPRowId_""",""text"":"""_SSGRPDesc_""","
		s myJsonStr=myJsonStr_"""icon"":"""_""_myImage_""","
		s myJsonStr=myJsonStr_"""checked"":false,"
		s myJsonStr=myJsonStr_"""leaf"":true"
		s myJsonStr=myJsonStr_"}"
	}

	s myJsonStr="["_myJsonStr_"]"
	
	q myJsonStr
}

ClassMethod GetLogonLocTreeJson(ParentID As %String, ObjectType As %String, ObjectReference As %String) As %String
{
	if (ParentID="LogonLocTreeRoot") s ParentID=-100000000000000
	
	//输出菜单JSON串
	//s myMenuSeq=0
	//#dim myJsonStr As web.BDP.sys.String
	s myJsonStr=""
	s myImage=""

	//获取授权JSON
	s LogonLocAStr=##class(web.DHCBL.Authorize.BaseData).DHCGetDataByReference(ObjectType,ObjectReference,"LogonLoc")				
	;b
	s CTLOCRowID=0
	s ^TMPcai1=LogonLocAStr
	;b ;1
	f{ 		
		s CTLOCRowID=$o(^CTLOC(CTLOCRowID)) q:CTLOCRowID=""  
		s CTLOCDesc=$p(^CTLOC(CTLOCRowID),"^",2)       //科室名			
		//判断菜单是否已授权,有则checked:true
		//s strLogonLoc="{ID:"_CTLOCRowID_"}"
		s:(myJsonStr'="") myJsonStr=myJsonStr_","
		s myJsonStr=myJsonStr_"{"
		s myJsonStr=myJsonStr_"""id"":"""_""_CTLOCRowID_""",""text"":"""_CTLOCDesc_""","
		s myJsonStr=myJsonStr_"""icon"":"""_""_myImage_""","
		s myJsonStr=myJsonStr_"""checked"":false,"
		s myJsonStr=myJsonStr_"""leaf"":true"
		s myJsonStr=myJsonStr_"}"
		if (CTLOCRowID=300) q
	}
	;w
	s myJsonStr="["_myJsonStr_"]"
	
	q myJsonStr
}

/// 保存安全组授权的JSON
/// ObjectType As %String, ObjectReference As %String, Data As %String, SubKey As %String
ClassMethod SaveAuthorizeBaseDataJson(ObjectType As %String, ObjectReference As %String, Data As %String, SubKey As %String) As %String
{
	;q "1212"
	s EntityClassName="web.Entity.Authorize.Menu"
	s flag = ##class(web.DHCBL.Authorize.BaseData).DHCSaveDataToServer(ObjectType,ObjectReference,Data,SubKey)
	if (flag=0){
		s result = "{msg:"_flag_"}"
	}else{
		s result = "{msg"_flag_"}"
	}
	q result
}

/// 保存登录科室授权的JSON
/// ObjectType As %String, ObjectReference As %String, Data As %String, SubKey As %String
ClassMethod SaveAuthorizeLogonLocDataJson(ObjectType As %String, ObjectReference As %String, Data As %String, SubKey As %String) As %String
{
	;q "1212"
	s EntityClassName="web.Entity.Authorize.Menu"
	s flag = ##class(web.DHCBL.Authorize.BaseData).DHCSaveDataToServer(ObjectType,ObjectReference,Data,SubKey)
	if (flag=0){
		s result = "{msg:"_flag_"}"
	}else{
		s result = "{msg"_flag_"}"
	}
	q result
}

/// Creator：蔡昊哲
/// CreatDate: 2013-5-14
/// Description 用户维护 获取安全组授权数据
/// Table：User.SSGroup
/// Input：query
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.Authorize.BaseData","GetGroupList","")
Query GetGroupList(query) As %Query(ROWSPEC = "SSGRPRowId,SSGRPDesc")
{
}

ClassMethod GetGroupListExecute(ByRef qHandle As %Binary, query) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1

	//获取授权JSON
	s GroupAStr=##class(web.DHCBL.Authorize.BaseData).DHCGetDataByDefaultSession("Group")
	s list=##class(web.DHCBL.Authorize.BDPAuthorize).ListFromJSON(GroupAStr)
	for i=1:1:list.Count() {			
	    s SSGRPRowId = list.GetAt(i)
	    s SSGRPDesc = $p($g(^SSU("SSGRP",SSGRPRowId)),"^",1)
		s:query'="" query=$ZCONVERT(query,"U")
		s SSGRPDescB=$ZCONVERT(SSGRPDesc,"U")
		i (SSGRPDescB[query)
		{
			d OutputRow
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(SSGRPRowId,SSGRPDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetGroupListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetGroupListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetGroupListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetGroupListExecute ]
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

/// Creator：蔡昊哲
/// CreatDate: 2013-5-7
/// Description：获取科室列表
/// Table：User.CTLoc
/// Input：RowId1, Code, Desc, CTPCPCarPrvTpDR, ActiveFlag, InternalType
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.Authorize.BDPAuthorize","GetLocList","","")
Query GetLocList(query) As %Query(ROWSPEC = "CTLOCRowID,CTLOCDesc")
{
}

ClassMethod GetLocListExecute(ByRef qHandle As %Binary, query) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	s:query'="" query=$ZCONVERT(query,"U")
	//获取授权JSON
	s GroupAStr=##class(web.DHCBL.Authorize.BaseData).DHCGetDataByDefaultSession("LogonLoc")
	;s GroupAStr="[{ID:19},{ID:20},{ID:21},{ID:24},{ID:25},{ID:26},{ID:27},{ID:28},{ID:29},{ID:30},{ID:31}]"
	s list=##class(web.DHCBL.Authorize.BDPAuthorize).ListFromJSON(GroupAStr)
	for i=1:1:list.Count() {			
	    s CTLOCRowID = list.GetAt(i)
	    s CTLOCDesc = $p($g(^CTLOC(CTLOCRowID)),"^",2)
		
		s CTLOCDescB=$ZCONVERT(CTLOCDesc,"U")
		i (CTLOCDescB[query)
		{
			d OutputRow
		}
	}	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(CTLOCRowID,CTLOCDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetLocListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLocListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetLocListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLocListExecute ]
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

/// 获取授权的Data
ClassMethod AutJson(ObjectType As %String, ObjectReference As %String, subkey As %String) As %String
{
	s strAutJson=##class(web.DHCBL.Authorize.BaseData).DHCGetDataByReference(ObjectType,ObjectReference,subkey)
	q strAutJson
}

}
