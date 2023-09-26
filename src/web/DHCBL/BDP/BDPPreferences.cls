/// 名称:系统配置 - 6 授权浏览
/// 描述:包含查询、删除功能
/// 编写者:基础数据平台组 - 陈莹
/// 编写日期:2014-1-25
Class web.DHCBL.BDP.BDPPreferences Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：陈莹
/// CreatDate: 2014-1-25
/// Description：查询授权
/// Table：User.BDPPreferences
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.BDP.BDPPreferences","GetList","","G","1","","BD")
Query GetList(rowid As %String, objecttype As %String, objectreference As %String, appsubkey As %String, appkey As %String) As %Query(ROWSPEC = "ID:%String,ObjectType:%String,ObjectReference:%String,AppKey:%String,AppSubKey:%String,AppKey1:%String,AppSubKey1:%String,Data:%String,Data1:%String,DataSplitString:%String,CorrespondingClass:%String,DataMapMode:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, objecttype As %String, objectreference As %String, appsubkey As %String, appkey As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		
		s AppKey1="",AppSubKey1="",Data1="",Data2=""
		s ID=rowid
		s AppKey=$LISTGET($G(^User.BDPPreferencesD(rowid)),1)
		s AppSubKey=$LISTGET($G(^User.BDPPreferencesD(rowid)),2)
		s Data=$LISTGET($G(^User.BDPPreferencesD(rowid)),7)
		s DataSplitString=$LISTGET($G(^User.BDPPreferencesD(rowid)),5)
		s ObjectType1=$LISTGET($G(^User.BDPPreferencesD(rowid)),3)
		s ObjectReference1=$LISTGET($G(^User.BDPPreferencesD(rowid)),4)
		s CorrespondingClass=$LISTGET($G(^User.BDPPreferencesD(rowid)),6)
		s DataMapMode=$LISTGET($G(^User.BDPPreferencesD(rowid)),8)
		if (ObjectType1="G")
		{
			s ObjectType="安全组"
			s ObjectReference=$p($g(^SSU("SSGRP",ObjectReference1)),"^",1)
		}
		elseif(ObjectType1="L")
		{
			s ObjectType="科室"
			s ObjectReference=$p($g(^CTLOC(ObjectReference1)),"^",2)
		}
		elseif(ObjectType1="U")
		{
			s ObjectType="用户"
			s ObjectReference=$p($g(^SSU("SSUSR",ObjectReference1)),"^",2)
		}
		
		if (AppKey="SYS")
		{
			s AppKey1="系统级别授权"
			if (AppSubKey="Menu"){
				s AppSubKey1="菜单授权"
				s Data1=##class(web.DHCBL.BDP.BDPPreferences).GetMenuAutData(Data)
			}
			elseif (AppSubKey="LocNewsAut"){
				s AppSubKey1="科室接收消息授权"
				s Data1=##class(web.DHCBL.BDP.BDPPreferences).GetLocNewsAutData(Data)
				
				s ObjectType=""
				s ObjectReference=""
			}
			elseif (AppSubKey="Log"){
				s AppSubKey1="基础数据管理日志授权"
				s Data1=##class(web.DHCBL.BDP.BDPPreferences).GetLogAutData(Data)
				
			
			}
		}
		elseif(AppKey="BD")
		{
			s AppKey1="基础数据授权"
			if (AppSubKey="HospPre"){
				s AppSubKey1="医院级授权"
				s Data1=##class(web.DHCBL.BDP.BDPPreferences).GetHOSPAutData(Data)		
			}
			else{
				s AppSubKey1= ##class(web.DHCBL.BDP.BDPExecutables).GetExtCaptionByCode(AppSubKey)
				if (DataSplitString="BITMAP")&(AppSubKey="ARC_ItmMast")
				{
					s Data=$p(Data,"#",1)
					s Data1=##class(web.DHCBL.BDP.BDPPreferences).GetARCItmMastData(Data)
				}
				elseif (DataSplitString="BITMAP")&(AppSubKey="MRC_ICDDx")
				{
					s Data1=##class(web.DHCBL.BDP.BDPPreferences).GetICDDxData(Data)
				}
				else
				{
					;w ##class(web.DHCBL.BDP.BDPPreferences).GetBDAutData("CT_City","{limited:1,IDS:[{ID:1},{ID:2}]}")
					s Data1=##class(web.DHCBL.BDP.BDPPreferences).GetBDAutData(AppSubKey,Data)
				}
			}
		}
		elseif(AppKey="E")
		{
			s AppKey1="功能元素授权"
			s haveflag=##class(web.DHCBL.CT.FunctionalElement).HaveItems(AppSubKey)
			if (haveflag="Y")
			{
				s AppSubKey1=$LISTGET($G(^User.BDPMenuD(AppSubKey)),3)
				s Data1=##class(web.DHCBL.BDP.BDPPreferences).GetItemAutData(Data,1)
			}
			else
			{
				s AppSubKey1= ##class(web.DHCBL.BDP.BDPExecutables).GetExtCaptionByCode(AppSubKey)
				s Data1=##class(web.DHCBL.BDP.BDPPreferences).GetItemAutData(Data)
			}
			
		
		}
		elseif(AppKey="T")
		{
			s AppKey1="数据翻译"
			s AppSubKey1= ##class(web.DHCBL.BDP.BDPExecutables).GetExtCaptionByCode($p(AppSubKey,"^",1))
			s Data1=##class(web.DHCBL.BDP.BDPPreferences).GetTableListData(Data)			
		}
		d OutputRow
	}
	else
	{
		s ID=""
		
		for
		{
			s AppKey1="",AppSubKey1="",Data1="",Data2=""
			s ID=$o(^User.BDPPreferencesD(ID),-1) q:(ID="")||(ID=0)
			s AppKey=$LISTGET($G(^User.BDPPreferencesD(ID)),1)
			s AppSubKey=$LISTGET($G(^User.BDPPreferencesD(ID)),2)
			s Data=$LISTGET($G(^User.BDPPreferencesD(ID)),7)
			s DataSplitString=$LISTGET($G(^User.BDPPreferencesD(ID)),5)
			s ObjectType1=$LISTGET($G(^User.BDPPreferencesD(ID)),3)
			s ObjectReference1=$LISTGET($G(^User.BDPPreferencesD(ID)),4)
			s CorrespondingClass=$LISTGET($G(^User.BDPPreferencesD(ID)),6)
			s DataMapMode=$LISTGET($G(^User.BDPPreferencesD(ID)),8)
			if (ObjectType1="G")
			{
				s ObjectType="安全组"
				s ObjectReference=$p($g(^SSU("SSGRP",ObjectReference1)),"^",1)
			}
			elseif(ObjectType1="L")
			{
				s ObjectType="科室"
				s ObjectReference=$p($g(^CTLOC(ObjectReference1)),"^",2)
			}
			elseif(ObjectType1="U")
			{
				s ObjectType="用户"
				s ObjectReference=$p($g(^SSU("SSUSR",ObjectReference1)),"^",2)
			}
			
			if (AppKey="SYS")
			{
				s AppKey1="系统级别授权"
				if (AppSubKey="Menu"){
					s AppSubKey1="菜单授权"				
					s Data1=##class(web.DHCBL.BDP.BDPPreferences).GetMenuAutData(Data)
				}
				elseif (AppSubKey="LocNewsAut"){
					s AppSubKey1="科室接收消息授权"
					s Data1=##class(web.DHCBL.BDP.BDPPreferences).GetLocNewsAutData(Data)
					
					s ObjectType=""
					s ObjectReference=""
				}
				elseif (AppSubKey="Log"){
					s AppSubKey1="基础数据管理日志授权"
					s Data1=##class(web.DHCBL.BDP.BDPPreferences).GetLogAutData(Data)
					
					
				}
			}
			elseif(AppKey="BD")
			{
				s AppKey1="基础数据授权"
				if (AppSubKey="HospPre"){
					s AppSubKey1="医院级授权"
					s Data1=##class(web.DHCBL.BDP.BDPPreferences).GetHOSPAutData(Data)
				}
				else{
					s AppSubKey1= ##class(web.DHCBL.BDP.BDPExecutables).GetExtCaptionByCode(AppSubKey)
					if (DataSplitString="BITMAP")&(AppSubKey="ARC_ItmMast")
					{
						s Data=$p(Data,"#",1)
						s Data1=##class(web.DHCBL.BDP.BDPPreferences).GetARCItmMastData(Data)
					}
					elseif (DataSplitString="BITMAP")&(AppSubKey="MRC_ICDDx")
					{
						s Data=$p(Data,"#",1)
						s Data1=##class(web.DHCBL.BDP.BDPPreferences).GetICDDxData(Data)
					}
					else
					{
						s Data1=##class(web.DHCBL.BDP.BDPPreferences).GetBDAutData(AppSubKey,Data)
					}
	
				}
			}
			elseif(AppKey="E")
			{
				s AppKey1="功能元素授权"
				s haveflag=##class(web.DHCBL.CT.FunctionalElement).HaveItems(AppSubKey)
				if (haveflag="Y")
				{
					s AppSubKey1=$LISTGET($G(^User.BDPMenuD(AppSubKey)),3)
					s Data1=##class(web.DHCBL.BDP.BDPPreferences).GetItemAutData(Data,1)
				}
				else
				{
					s AppSubKey1= ##class(web.DHCBL.BDP.BDPExecutables).GetExtCaptionByCode(AppSubKey)
					s Data1=##class(web.DHCBL.BDP.BDPPreferences).GetItemAutData(Data)
				}
							
			}
			elseif(AppKey="T")
			{
				s AppKey1="数据翻译"
				s AppSubKey1= ##class(web.DHCBL.BDP.BDPExecutables).GetExtCaptionByCode($p(AppSubKey,"^",1))
				s Data1=##class(web.DHCBL.BDP.BDPPreferences).GetTableListData(Data)			
			}		
			i ((ObjectType1=objecttype)||(objecttype=""))&((ObjectReference1=objectreference)||(objectreference=""))&((AppKey=appkey)||(appkey=""))&((($ZCONVERT(AppSubKey,"U"))[($ZCONVERT(appsubkey,"U")))||(appsubkey="")||(($ZCONVERT(AppSubKey1,"U"))[($ZCONVERT(appsubkey,"U"))))
			{
				d OutputRow
			}
		
		}
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(ID,ObjectType,ObjectReference,AppKey,AppSubKey,AppKey1,AppSubKey1,Data,Data1,DataSplitString,CorrespondingClass,DataMapMode)
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

/// Creator：陈莹
/// CreatDate: 2014-2-14
/// Description：查询安全组/科室/用户
/// Table：
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.BDP.BDPPreferences","GetPre","G","")
Query GetPre(objecttype As %String, desc As %String) As %Query(ROWSPEC = "RowId:%String,Desc:%String")
{
}

ClassMethod GetPreExecute(ByRef qHandle As %Binary, objecttype As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	s:desc'="" desc=$ZCONVERT(desc,"U")
	
	if (objecttype="G")
	{
		s RowId=0
		for
		{
			s RowId=$o(^SSU("SSGRP",RowId)) q:RowId=""
			s Desc=$p($g(^SSU("SSGRP",RowId)),"^",1)
			continue:Desc["停用"
			s PINYIN=""
			if desc'="" s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(Desc)
			i ($ZCONVERT(Desc,"U")[desc)||(PINYIN[desc)
			{
				d OutputRowPre
			}
		}
	}
	elseif (objecttype="L")
	{
		s RowId=0
		for
		{
			s RowId=$o(^CTLOC(RowId)) q:RowId=""
			s Desc=$p(^CTLOC(RowId),"^",2)
			s PINYIN=""
			if desc'="" s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(Desc)
			i ($ZCONVERT(Desc,"U")[desc)||(PINYIN[desc)
			{
				d OutputRowPre
			}
		}
	}
	elseif (objecttype="U")
	{
		s RowId=0
		for
		{
			s RowId=$o(^SSU("SSUSR",RowId)) q:RowId=""
			s Initial=$p(^SSU("SSUSR",RowId),"^",1) 
			s Desc=$p(^SSU("SSUSR",RowId),"^",2)       //用户名SSUSRName
			s Desc=Initial_"-"_Desc
			s PINYIN=""
			if desc'="" s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(Desc)
			i ($ZCONVERT(Desc,"U")[desc)||(PINYIN[desc)
			{
				d OutputRowPre	
			}
		}
	}
		
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowPre
    set Data=$lb(RowId,Desc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetPreClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPreExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetPreFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPreExecute ]
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

/// Creator：陈莹
/// CreatDate: 2014-1-26
/// Description：删除授权
/// Table：User.BDPPreferences
/// Input：id 
/// Return：成功返回true，失败返回false和失败原因
/// d ##class(web.DHCBL.BDP.BDPPreferences).DeleteData("1")
ClassMethod DeleteData(id) As %String
{
	s result=""
	s eobj=##class(web.Entity.BDP.BDPPreferences).%New()
	s eobj.ID=id
	s eobj.AppKey=$LISTGET($G(^User.BDPPreferencesD(id)),1)
	s eobj.AppSubKey=$LISTGET($G(^User.BDPPreferencesD(id)),2)
	s eobj.ObjectType=$LISTGET($G(^User.BDPPreferencesD(id)),3)
	s eobj.ObjectReference=$LISTGET($G(^User.BDPPreferencesD(id)),4)
	s eobj.Data=$LISTGET($G(^User.BDPPreferencesD(id)),7)
	s eobj.DataSplitString=$LISTGET($G(^User.BDPPreferencesD(id)),5)
	s eobj.CorrespondingClass=$LISTGET($G(^User.BDPPreferencesD(id)),6)
	s eobj.DataMapMode=$LISTGET($G(^User.BDPPreferencesD(id)),8)
	Tstart
	s sc=##class(User.BDPPreferences).%DeleteId(id)
	IF $$$ISOK(sc) {
		Tc
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDP_Preferences","User.BDPPreferences","授权浏览",id,eobj.AppKey_"-"_eobj.AppSubKey,"D",eobj)			
		s result="{success:'true',info:'删除成功！'}"
	}else {
		Trollback
		s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	}
	q result
}

/// Creator：陈莹
/// CreatDate: 2016-10-13
/// Description：保留菜单授权SYS/Menu、
///              清除基础数据管理日志授权SYS/Log、科室接收消息授权SYS/LocNewsAut、非管理员用户/科室/安全组的医院级授权BD/HospPre、基础数据授权BD、功能元素授权E、翻译授权T、科室/非管理员用户的菜单授权，
/// Table：User.BDPPreferences
/// Return:提示信息
/// w ##class(web.DHCBL.BDP.BDPPreferences).MDeleteData()
ClassMethod MDeleteData() As %String
{
	s ID=""	
	for
	{
		s ID=$o(^User.BDPPreferencesD(ID),-1) q:(ID="")||(ID=0)
		s AppKey=$LISTGET($G(^User.BDPPreferencesD(ID)),1)
		s AppSubKey=$LISTGET($G(^User.BDPPreferencesD(ID)),2)
		s ObjectType=$LISTGET($G(^User.BDPPreferencesD(ID)),3)
		if ((AppKey="E")||(AppKey="T"))  //功能元素授权E  数据翻译T
		{
			d ##class(web.DHCBL.BDP.BDPPreferences).DeleteData(ID)
		} 
		if (AppKey="SYS")  
		{
			if (AppSubKey="Log") //日志授权SYS/Log
			{
				d ##class(web.DHCBL.BDP.BDPPreferences).DeleteData(ID)
			}
			if (AppSubKey="LocNewsAut") //科室接收消息授权SYS/LocNewsAut
			{
				d ##class(web.DHCBL.BDP.BDPPreferences).DeleteData(ID)
			}
			if (AppSubKey="Menu") //菜单授权 
			{
				if (ObjectType="U")  //用户
				{
					s ObjectReference=$LISTGET($G(^User.BDPPreferencesD(ID)),4)
					if ObjectReference'=""
					{
						s SSUSRAdmitted=$p($g(^SSU("SSUSR",ObjectReference)),"^",63) //管理员用户
						if SSUSRAdmitted'="Y"   //清掉非管理员用户的菜单授权
						{
							d ##class(web.DHCBL.BDP.BDPPreferences).DeleteData(ID)
						}
					}
				}
				if (ObjectType="L")  //科室  
				{
					
					d ##class(web.DHCBL.BDP.BDPPreferences).DeleteData(ID)
				}
				if (ObjectType="U")  //安全组
				{
					//安全组菜单授权不清
				}
			}
			
		}
		
		if (AppKey="BD")  //医院级授权BD/HospPre、基础数据授权BD
		{
			if (AppSubKey="HospPre")  //医院级授权
			{
				if (ObjectType="U")  //用户
				{
					s ObjectReference=$LISTGET($G(^User.BDPPreferencesD(ID)),4)
					if ObjectReference'=""
					{
						s SSUSRAdmitted=$p($g(^SSU("SSUSR",ObjectReference)),"^",63) //管理员用户
						if SSUSRAdmitted'="Y"   //清掉非管理员用户的医院级授权 ,保留dhsuper的授权
						{
							d ##class(web.DHCBL.BDP.BDPPreferences).DeleteData(ID)
						}
					}
				}
				elseif (ObjectType="G")  //安全组
				{
					//安全组医院级授权不清
				}
				elseif (ObjectType="L") //科室的医院级授权
				{
					d ##class(web.DHCBL.BDP.BDPPreferences).DeleteData(ID)
				}
				
			}
			else  //基础数据授权
			{
				d ##class(web.DHCBL.BDP.BDPPreferences).DeleteData(ID)
			}
		}
		
	}
	q "已清除基础数据平台组 日志授权、功能元素授权、翻译授权、医院级授权（授权对象为科室/非管理员用户）、基础数据授权、菜单授权（授权对象为科室/非管理员用户）、科室接收消息授权"
}

/// Creator：陈莹
/// CreatDate: 2014-11-13
/// Description：获取角色的实际 基础数据授权
/// Table：User.BDPPreferences
/// Input：objecttype, objectreference, OTHLLRowId
/// OTHLLRowId为objecttype为用户时,取的其他登陆科室里科室—安全组 数据的rowid，为空则取默认登录科室 
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.BDP.BDPPreferences","GetBaseDataAut","U","1","")
Query GetBaseDataAut(objecttype As %String, objectreference As %String, OTHLLRowId) As %Query(ROWSPEC = "ID:%String,ObjectType:%String,ObjectReference:%String,Object:%String,AppKey:%String,AppSubKey:%String,AppSubKey1:%String,Data:%String,Data1:%String")
{
}

ClassMethod GetBaseDataAutExecute(ByRef qHandle As %Binary, objecttype As %String, objectreference As %String, OTHLLRowId) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	
	k a
	if (objectreference)
	{
		if (objecttype="G")||(objecttype="L" )
		{
			s ID=""
		
			for
			{
				s AppSubKey1="",Data1=""
				s ID=$o(^User.BDPPreferencesD(ID),-1) q:(ID="")||(ID=0)
			
				s ObjectType1=$LISTGET($G(^User.BDPPreferencesD(ID)),3)
				s ObjectReference1=$LISTGET($G(^User.BDPPreferencesD(ID)),4)
				s AppKey=$LISTGET($G(^User.BDPPreferencesD(ID)),1)
				s AppSubKey=$LISTGET($G(^User.BDPPreferencesD(ID)),2)
				s Data=$LISTGET($G(^User.BDPPreferencesD(ID)),7)
				s DataSplitString=$LISTGET($G(^User.BDPPreferencesD(ID)),5)
				if (ObjectType1="G")
				{
					s ObjectType="安全组"
					s ObjectReference=$p($g(^SSU("SSGRP",ObjectReference1)),"^",1)
				}
				elseif(ObjectType1="L")
				{
					s ObjectType="科室"
					s ObjectReference=$p($g(^CTLOC(ObjectReference1)),"^",2)
				}
				s Object=ObjectType_"--"_ObjectReference
				i (ObjectType1=objecttype)&(ObjectReference1=objectreference)&(AppKey="BD")&(AppSubKey'="HospPre")
				{	
					s AppSubKey1= ##class(web.DHCBL.BDP.BDPExecutables).GetExtCaptionByCode(AppSubKey)
					if (DataSplitString="BITMAP")&(AppSubKey="ARC_ItmMast")
					{
						s Data1=##class(web.DHCBL.BDP.BDPPreferences).GetARCItmMastData(Data)
					}
					elseif (DataSplitString="BITMAP")&(AppSubKey="MRC_ICDDx")
					{
						s Data1=##class(web.DHCBL.BDP.BDPPreferences).GetICDDxData(Data)
					}
					else
					{
						s Data1=##class(web.DHCBL.BDP.BDPPreferences).GetBDAutData(AppSubKey,Data)
					}
					d OutputRowBD				
				}		
			}	
		}
		elseif(objecttype="U")
		{
			//用户自己的权限
			s ID=""	
			for
			{
				s AppSubKey1="",Data1=""
				s ID=$o(^User.BDPPreferencesD(ID),-1) q:(ID="")||(ID=0)	
				s ObjectType1=$LISTGET($G(^User.BDPPreferencesD(ID)),3)
				s ObjectReference1=$LISTGET($G(^User.BDPPreferencesD(ID)),4)
				s AppKey=$LISTGET($G(^User.BDPPreferencesD(ID)),1)
				s AppSubKey=$LISTGET($G(^User.BDPPreferencesD(ID)),2)
				s Data=$LISTGET($G(^User.BDPPreferencesD(ID)),7)
				s DataSplitString=$LISTGET($G(^User.BDPPreferencesD(ID)),5)
				s ObjectType="用户"
				s ObjectReference=$p($g(^SSU("SSUSR",ObjectReference1)),"^",2)
				
				s Object=ObjectType_"--"_ObjectReference
				i (ObjectType1=objecttype)&(ObjectReference1=objectreference)&(AppKey="BD")&(AppSubKey'="HospPre")
				{
					s AppSubKey1= ##class(web.DHCBL.BDP.BDPExecutables).GetExtCaptionByCode(AppSubKey)

					/////已授过权的表,用数组
					s a(AppSubKey)=AppSubKey1
					if (DataSplitString="BITMAP")&(AppSubKey="ARC_ItmMast")
					{
						s Data1=##class(web.DHCBL.BDP.BDPPreferences).GetARCItmMastData(Data)
					}
					elseif (DataSplitString="BITMAP")&(AppSubKey="MRC_ICDDx")
					{
						s Data1=##class(web.DHCBL.BDP.BDPPreferences).GetICDDxData(Data)
					}
					else
					{
						s Data1=##class(web.DHCBL.BDP.BDPPreferences).GetBDAutData(AppSubKey,Data)
					}
			
					d OutputRowBD
					
				}
			}	
		

			////对科室的授权	
			if (OTHLLRowId="") 
			{
				//默认登录科室
				s objecttypeL="L" 
				s objectreferenceL=$p($g(^SSU("SSUSR",objectreference)),"^",4)   ///102
				//安全组
				s objecttypeG="G" 
				s objectreferenceG=$p($g(^SSU("SSUSR",objectreference)),"^",5)   ///1
			}
			else  ///1||2
			{
				s ParRef=$p($g(OTHLLRowId),"||",1)  
				s ChildSub=$p($g(OTHLLRowId),"||",2)
				//其他登陆科室
				s objecttypeL="L"  
				s objectreferenceL=$p($g(^SSU("SSUSR",ParRef,"OTHLL",ChildSub)),"^",1)  ///131	
				//安全组
				s objecttypeG="G"  
				s objectreferenceG=$p($g(^SSU("SSUSR",ParRef,"OTHLL",ChildSub)),"^",2)  ///DEMO GROUP	
			}
			
			s ID=""	
			for
			{
				s AppSubKey1="",Data1=""
				s ID=$o(^User.BDPPreferencesD(ID),-1) q:(ID="")||(ID=0)	
				s ObjectType1=$LISTGET($G(^User.BDPPreferencesD(ID)),3)
				s ObjectReference1=$LISTGET($G(^User.BDPPreferencesD(ID)),4)
				s AppKey=$LISTGET($G(^User.BDPPreferencesD(ID)),1)
				s AppSubKey=$LISTGET($G(^User.BDPPreferencesD(ID)),2)
				s Data=$LISTGET($G(^User.BDPPreferencesD(ID)),7)	
				s DataSplitString=$LISTGET($G(^User.BDPPreferencesD(ID)),5)
				s ObjectType="科室"  
				s ObjectReference=$p($g(^CTLOC(objectreferenceL)),"^",2)  ///CWK=财务科
				
				s Object=ObjectType_"--"_ObjectReference
				i (ObjectType1=objecttypeL)&(ObjectReference1=objectreferenceL)&(AppKey="BD")&(AppSubKey'="HospPre")
				{
				
					///已授过权的表$d(a(AppSubKey))=1
					if ($d(a(AppSubKey))=0)
					{
						s AppSubKey1= ##class(web.DHCBL.BDP.BDPExecutables).GetExtCaptionByCode(AppSubKey)
						s a(AppSubKey)=AppSubKey1
						if (DataSplitString="BITMAP")&(AppSubKey="ARC_ItmMast")
						{
							s Data1=##class(web.DHCBL.BDP.BDPPreferences).GetARCItmMastData(Data)
						}
						elseif (DataSplitString="BITMAP")&(AppSubKey="MRC_ICDDx")
						{
							s Data1=##class(web.DHCBL.BDP.BDPPreferences).GetICDDxData(Data)
						}
						else
						{
							s Data1=##class(web.DHCBL.BDP.BDPPreferences).GetBDAutData(AppSubKey,Data)
			
						}
			
						d OutputRowBD
						
				
					}
				}
			}
		
			//对安全组的授权
			s ID=""	
			for
			{
				s AppSubKey1="",Data1=""
				s ID=$o(^User.BDPPreferencesD(ID),-1) q:(ID="")||(ID=0)	
				s ObjectType1=$LISTGET($G(^User.BDPPreferencesD(ID)),3)
				s ObjectReference1=$LISTGET($G(^User.BDPPreferencesD(ID)),4)
				s AppKey=$LISTGET($G(^User.BDPPreferencesD(ID)),1)
				s AppSubKey=$LISTGET($G(^User.BDPPreferencesD(ID)),2)
				s Data=$LISTGET($G(^User.BDPPreferencesD(ID)),7)
				s DataSplitString=$LISTGET($G(^User.BDPPreferencesD(ID)),5)
				s ObjectType="安全组"
				s ObjectReference=$p($g(^SSU("SSGRP",objectreferenceG)),"^",1)
						
				s Object=ObjectType_"--"_ObjectReference	
				i (ObjectType1=objecttypeG)&(ObjectReference1=objectreferenceG)&(AppKey="BD")&(AppSubKey'="HospPre")
				{
					if ($d(a(AppSubKey))=0)
					{
						s AppSubKey1= ##class(web.DHCBL.BDP.BDPExecutables).GetExtCaptionByCode(AppSubKey)
						s a(AppSubKey)=AppSubKey1
						if (DataSplitString="BITMAP")&(AppSubKey="ARC_ItmMast")
						{
							s Data1=##class(web.DHCBL.BDP.BDPPreferences).GetARCItmMastData(Data)
						}
						elseif (DataSplitString="BITMAP")&(AppSubKey="MRC_ICDDx")
						{
							s Data1=##class(web.DHCBL.BDP.BDPPreferences).GetICDDxData(Data)
						}
						else
						{
							s Data1=##class(web.DHCBL.BDP.BDPPreferences).GetBDAutData(AppSubKey,Data)
						}
						d OutputRowBD
					}
				}
			}
		}
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowBD
    set Data=$lb(ID,ObjectType,ObjectReference,Object,AppKey,AppSubKey,AppSubKey1,Data,Data1)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetBaseDataAutFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBaseDataAutExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching
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

ClassMethod GetBaseDataAutClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBaseDataAutExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Function:进行数据检索，查询其他登陆科室的信息
/// CreateDate:2014-11-15
/// Creator:基础数据平台公共产品组 陈莹
/// Tables:  SS_UserOtherLogonLoc
/// Input: OTHLLParRef 
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.BDP.BDPPreferences","GetOtherLogonLoc","","U","1")
Query GetOtherLogonLoc(desc As %String, type As %String, OTHLLParRef As %String) As %Query(ROWSPEC = "OTHLLRowId:%String,Desc:%String")
{
}

ClassMethod GetOtherLogonLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOtherLogonLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod GetOtherLogonLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOtherLogonLocExecute ]
{
	
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetOtherLogonLocExecute(ByRef qHandle As %Binary, desc As %String, type As %String, OTHLLParRef As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1

	s:desc'="" desc=$zcvt(desc,"U")
	if (OTHLLParRef)&(type="U")
	{
		s ChildSub =0
		for
		{
			s ChildSub=$o(^SSU("SSUSR",OTHLLParRef,"OTHLL",ChildSub)) q:ChildSub=""
			s OTHLLRowId=OTHLLParRef_"||"_ChildSub
	    	s OTHLLCTLOCDR=$p($g(^SSU("SSUSR",OTHLLParRef,"OTHLL",ChildSub)),"^",1)
	  		s OTHLLUserGroupDR=$p($g(^SSU("SSUSR",OTHLLParRef,"OTHLL",ChildSub)),"^",2)
	  		s CTLOCDesc=""
	  		s SSGRPDesc=""
	  		s:OTHLLCTLOCDR'="" CTLOCDesc=$p($g(^CTLOC(OTHLLCTLOCDR)),"^",2)
	  		s:OTHLLUserGroupDR'="" SSGRPDesc=$p($g(^SSU("SSGRP",OTHLLUserGroupDR)),"^",1)
	  		s Desc=CTLOCDesc_"--"_SSGRPDesc
	  		s PINYIN=""
	  		s:desc'="" PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(Desc)
	  		i ($zcvt(Desc,"U")[desc)||(PINYIN[desc)
	  		{
	  			d Build2	
	  		}
		}		
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Build2
	set Data2=$lb(OTHLLRowId,Desc)
 	Set ^CacheTemp(repid,ind)=Data2
 	Set ind=ind+1
 	q
}

/// Creator：陈莹
/// CreatDate: 2014-11-17
/// Description：获取角色的实际 功能元素授权
/// Table：User.BDPPreferences
/// Input：objecttype, objectreference, OTHLLRowId
/// OTHLLRowId为objecttype为用户时,取的其他登陆科室里科室—安全组 数据的rowid，为空则取默认登录科室 
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.BDP.BDPPreferences","GetItemAut","","","")
Query GetItemAut(objecttype As %String, objectreference As %String, OTHLLRowId) As %Query(ROWSPEC = "ID:%String,ObjectType:%String,ObjectReference:%String,Object:%String,AppKey:%String,AppSubKey:%String,AppSubKey1:%String,Data:%String,Data1:%String")
{
}

ClassMethod GetItemAutExecute(ByRef qHandle As %Binary, objecttype As %String, objectreference As %String, OTHLLRowId) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	
	
	k a
	if (objectreference)
	{
		if (objecttype="G")||(objecttype="L" )
		{
			s ID=""
			for
			{
				s AppSubKey1="",Data1=""
				s ID=$o(^User.BDPPreferencesD(ID),-1) q:(ID="")||(ID=0)
			
				s ObjectType1=$LISTGET($G(^User.BDPPreferencesD(ID)),3)
				s ObjectReference1=$LISTGET($G(^User.BDPPreferencesD(ID)),4)
				s AppKey=$LISTGET($G(^User.BDPPreferencesD(ID)),1)
				s AppSubKey=$LISTGET($G(^User.BDPPreferencesD(ID)),2)
				s Data=$LISTGET($G(^User.BDPPreferencesD(ID)),7)
				i (ObjectType1=objecttype)&(ObjectReference1=objectreference)&(AppKey="E")
				{	
					s AppSubKey1= ##class(web.DHCBL.BDP.BDPExecutables).GetExtCaptionByCode(AppSubKey)
					s Data1=##class(web.DHCBL.BDP.BDPPreferences).GetItemAutData(Data)
			
					if (ObjectType1="G")
					{
						s ObjectType="安全组"
						s ObjectReference=$p($g(^SSU("SSGRP",ObjectReference1)),"^",1)
					}
					elseif(ObjectType1="L")
					{
						s ObjectType="科室"
						s ObjectReference=$p($g(^CTLOC(ObjectReference1)),"^",2)
					}
					s Object=ObjectType_"--"_ObjectReference
			
					d OutputRowItem
				}		
			}	
		}
		elseif(objecttype="U")
		{
			//用户自己的权限
			s ID=""	
			for
			{
				s AppSubKey1="",Data1=""
				s ID=$o(^User.BDPPreferencesD(ID),-1) q:(ID="")||(ID=0)	
				s ObjectType1=$LISTGET($G(^User.BDPPreferencesD(ID)),3)
				s ObjectReference1=$LISTGET($G(^User.BDPPreferencesD(ID)),4)
				s AppKey=$LISTGET($G(^User.BDPPreferencesD(ID)),1)
				s AppSubKey=$LISTGET($G(^User.BDPPreferencesD(ID)),2)
				s Data=$LISTGET($G(^User.BDPPreferencesD(ID)),7)
			
				i (ObjectType1=objecttype)&(ObjectReference1=objectreference)&(AppKey="E")
				{				
					//s appsubstr=appsubstr_"^"_AppSubKey
				
					s AppSubKey1= ##class(web.DHCBL.BDP.BDPExecutables).GetExtCaptionByCode(AppSubKey)
					//已授过权的表
					s a(AppSubKey)=AppSubKey1
					s Data1=##class(web.DHCBL.BDP.BDPPreferences).GetItemAutData(Data)
			
					s ObjectType="用户"
					s ObjectReference=$p($g(^SSU("SSUSR",ObjectReference1)),"^",2)
				
					s Object=ObjectType_"--"_ObjectReference
			
					d OutputRowItem
				}
			}	
		

				
			if (OTHLLRowId="") 
			{
				//默认登录科室
				s objecttypeL="L" 
				s objectreferenceL=$p($g(^SSU("SSUSR",objectreference)),"^",4)   ///102
				//安全组
				s objecttypeG="G" 
				s objectreferenceG=$p($g(^SSU("SSUSR",objectreference)),"^",5)   ///1
			}
			else  ///1||2
			{
				s ParRef=$p($g(OTHLLRowId),"||",1)  
				s ChildSub=$p($g(OTHLLRowId),"||",2)
				//其他登陆科室
				s objecttypeL="L"  
				s objectreferenceL=$p($g(^SSU("SSUSR",ParRef,"OTHLL",ChildSub)),"^",1)  ///131	
				//安全组
				s objecttypeG="G"  
				s objectreferenceG=$p($g(^SSU("SSUSR",ParRef,"OTHLL",ChildSub)),"^",2)  ///DEMO GROUP	
			}
			////对科室的授权
			s ID=""	
			for
			{
				s AppSubKey1="",Data1=""
				s ID=$o(^User.BDPPreferencesD(ID),-1) q:(ID="")||(ID=0)	
				s ObjectType1=$LISTGET($G(^User.BDPPreferencesD(ID)),3)
				s ObjectReference1=$LISTGET($G(^User.BDPPreferencesD(ID)),4)
				s AppKey=$LISTGET($G(^User.BDPPreferencesD(ID)),1)
				s AppSubKey=$LISTGET($G(^User.BDPPreferencesD(ID)),2)
				s Data=$LISTGET($G(^User.BDPPreferencesD(ID)),7)	
				i (ObjectType1=objecttypeL)&(ObjectReference1=objectreferenceL)&(AppKey="E")
				{	
					//已授过权的表
					if ($d(a(AppSubKey))=0)
					{
						s AppSubKey1= ##class(web.DHCBL.BDP.BDPExecutables).GetExtCaptionByCode(AppSubKey)
				
						s a(AppSubKey)=AppSubKey1
						s Data1=##class(web.DHCBL.BDP.BDPPreferences).GetItemAutData(Data)
			
						s ObjectType="科室"  
						s ObjectReference=$p($g(^CTLOC(objectreferenceL)),"^",2)  ///CWK=财务科
				
						s Object=ObjectType_"--"_ObjectReference
			
						d OutputRowItem
					}
				}
			}
		
			//对安全组的授权
			s ID=""	
			for
			{
				s AppSubKey1="",Data1=""
				s ID=$o(^User.BDPPreferencesD(ID),-1) q:(ID="")||(ID=0)	
				s ObjectType1=$LISTGET($G(^User.BDPPreferencesD(ID)),3)
				s ObjectReference1=$LISTGET($G(^User.BDPPreferencesD(ID)),4)
				s AppKey=$LISTGET($G(^User.BDPPreferencesD(ID)),1)
				s AppSubKey=$LISTGET($G(^User.BDPPreferencesD(ID)),2)
				s Data=$LISTGET($G(^User.BDPPreferencesD(ID)),7)	
				i (ObjectType1=objecttypeG)&(ObjectReference1=objectreferenceG)&(AppKey="E")
				{	
					//已授过权的表
					if ($d(a(AppSubKey))=0)
					{
						s AppSubKey1= ##class(web.DHCBL.BDP.BDPExecutables).GetExtCaptionByCode(AppSubKey)
						s a(AppSubKey)=AppSubKey1
						s Data1=##class(web.DHCBL.BDP.BDPPreferences).GetItemAutData(Data)
			
						s ObjectType="安全组"
						s ObjectReference=$p($g(^SSU("SSGRP",objectreferenceG)),"^",1)
				
						s Object=ObjectType_"--"_ObjectReference
			
						d OutputRowItem
					}
				}
			}
		
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowItem
    set Data=$lb(ID,ObjectType,ObjectReference,Object,AppKey,AppSubKey,AppSubKey1,Data,Data1)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetItemAutFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetItemAutExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching
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

ClassMethod GetItemAutClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetItemAutExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 获取角色实际 菜单授权菜单
/// w ##class(web.DHCBL.BDP.BDPPreferences).GetMenuAut("menuTreeRoot","U","1","")
ClassMethod GetMenuAut(ParentID As %String, ObjectType As %String, ObjectReference As %String, OTHLLRowId As %String) As %String
{

	if (ParentID="menuTreeRoot") s ParentID=-100000000000000
	s strAutMenu=""
	s myJsonStr=""
	if (ObjectReference)
	{
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
	
	s demoflag=0
	
	//获取菜单授权Json串
	if (ObjectReference=1)&(ObjectType="G")  //demo安全组
	{
		s demoflag=1
	}
	else{
	s ID=""		
	for
	{
		s ID=$o(^User.BDPPreferencesD(ID),-1) q:(ID="")||(ID=0)
		s AppKey=$LISTGET($G(^User.BDPPreferencesD(ID)),1)
		s AppSubKey=$LISTGET($G(^User.BDPPreferencesD(ID)),2)
		s ObjectType1=$LISTGET($G(^User.BDPPreferencesD(ID)),3)
		s ObjectReference1=$LISTGET($G(^User.BDPPreferencesD(ID)),4)	
		if (AppKey="SYS")&(AppSubKey="Menu")&(ObjectType1=ObjectType)&(ObjectReference1=ObjectReference)
		{
			s strAutMenu=$LISTGET($G(^User.BDPPreferencesD(ID)),7)
			q	
		}
		
	}
	
	if (strAutMenu="")&&(ObjectType="U")
	{
		if (OTHLLRowId="") 
		{
			//默认登录科室
			s objecttypeL="L" 
			s objectreferenceL=$p($g(^SSU("SSUSR",ObjectReference)),"^",4)
			
			s ID=""		
			for
			{
				s ID=$o(^User.BDPPreferencesD(ID),-1) q:(ID="")||(ID=0)
				s AppKey=$LISTGET($G(^User.BDPPreferencesD(ID)),1)
				s AppSubKey=$LISTGET($G(^User.BDPPreferencesD(ID)),2)
				s ObjectType1=$LISTGET($G(^User.BDPPreferencesD(ID)),3)
				s ObjectReference1=$LISTGET($G(^User.BDPPreferencesD(ID)),4)	
				if (AppKey="SYS")&(AppSubKey="Menu")&(ObjectType1=objecttypeL)&(ObjectReference1=objectreferenceL)
				{
					s strAutMenu=$LISTGET($G(^User.BDPPreferencesD(ID)),7)
					q	
				}
		
			}
			
			//登陆科室授权为空
			if (strAutMenu=""){
				//默认安全组
				s objecttypeG="G" 
				s objectreferenceG=$p($g(^SSU("SSUSR",ObjectReference)),"^",5)
				
				if (objectreferenceG=1)   //自身和登陆科室都没授权，看是不是属于demo安全组
				{
					s demoflag=1
				}
				else
				{
					for
					{
						s ID=$o(^User.BDPPreferencesD(ID),-1) q:(ID="")||(ID=0)
						s AppKey=$LISTGET($G(^User.BDPPreferencesD(ID)),1)
						s AppSubKey=$LISTGET($G(^User.BDPPreferencesD(ID)),2)
						s ObjectType1=$LISTGET($G(^User.BDPPreferencesD(ID)),3)
						s ObjectReference1=$LISTGET($G(^User.BDPPreferencesD(ID)),4)	
						if (AppKey="SYS")&(AppSubKey="Menu")&(ObjectType1=objecttypeG)&(ObjectReference1=objectreferenceG)
						{
							s strAutMenu=$LISTGET($G(^User.BDPPreferencesD(ID)),7)
							q	
						}
		
					}
				}
			}
		
		}
		else  ///1||2
		{
			s ParRef=$p($g(OTHLLRowId),"||",1)  
			s ChildSub=$p($g(OTHLLRowId),"||",2)

			
			
			//其他登录科室
			s objecttypeL="L"  
			s objectreferenceL=$p($g(^SSU("SSUSR",ParRef,"OTHLL",ChildSub)),"^",1)	
			
			s ID=""		
			for
			{
				s ID=$o(^User.BDPPreferencesD(ID),-1) q:(ID="")||(ID=0)
				s AppKey=$LISTGET($G(^User.BDPPreferencesD(ID)),1)
				s AppSubKey=$LISTGET($G(^User.BDPPreferencesD(ID)),2)
				s ObjectType1=$LISTGET($G(^User.BDPPreferencesD(ID)),3)
				s ObjectReference1=$LISTGET($G(^User.BDPPreferencesD(ID)),4)	
				if (AppKey="SYS")&(AppSubKey="Menu")&(ObjectType1=objecttypeL)&(ObjectReference1=objectreferenceL)
				{
					s strAutMenu=$LISTGET($G(^User.BDPPreferencesD(ID)),7)
					q	
				}
		
			}
			
			//登陆科室授权为空
			if (strAutMenu=""){
				
				
				//其他登陆安全组
				s objecttypeG="G"  
				s objectreferenceG=$p($g(^SSU("SSUSR",ParRef,"OTHLL",ChildSub)),"^",2) 	
				
				if (objectreferenceG=1)   //自身和登陆科室都没授权，看是不是属于demo安全组
				{
					s demoflag=1
				}
				else
				{
					for
					{
						s ID=$o(^User.BDPPreferencesD(ID),-1) q:(ID="")||(ID=0)
						s AppKey=$LISTGET($G(^User.BDPPreferencesD(ID)),1)
						s AppSubKey=$LISTGET($G(^User.BDPPreferencesD(ID)),2)
						s ObjectType1=$LISTGET($G(^User.BDPPreferencesD(ID)),3)
						s ObjectReference1=$LISTGET($G(^User.BDPPreferencesD(ID)),4)	
						if (AppKey="SYS")&(AppSubKey="Menu")&(ObjectType1=objecttypeG)&(ObjectReference1=objectreferenceG)
						{
							s strAutMenu=$LISTGET($G(^User.BDPPreferencesD(ID)),7)
							q	
						}
		
					}
				}
			}
			
		}
	}
	
	}
	
	
	//输出菜单JSON串
	s mySMRowID=0
	s myMenuSeq=0
	
	
	for {
		;q:(+myMenuSeq>1)
		s myMenuSeq=$o(myMenuArray(myMenuSeq))
		q:(myMenuSeq="")
		s mySMRowID=$g(myMenuArray(myMenuSeq))
		
		s myMenuObj=##Class(User.BDPMenu).%OpenId(mySMRowID,0)
		if $IsObject(myMenuObj) {
			s myCode = myMenuObj.Code
			s myCaption = myMenuObj.Caption
			s myLinkUrl = myMenuObj.LinkUrl
			s myImage = myMenuObj.Image
			/*if (myImage'=""){
				s:(($e(myImage,1)="/")||($e(myImage,1)="\")) myImage=$e(myImage,2,$l(myImage))
				s myImage=$tr(myImage,"\","/")
				s myImage="../scripts/bdp/Framework/icons/"_myImage
			}*/
			
			//判断是否有子菜单
			if ((myLinkUrl="")) s myChildFlag=1
			else  s myChildFlag=0
			
			s strMenu="{ID:"_mySMRowID_"}"
			
			//判断菜单是否有权显示
			if (strAutMenu[strMenu)||(demoflag=1) s myMenuEn=1
			else  s myMenuEn=0
			
			if (+myMenuEn) {
				s:(myJsonStr'="") myJsonStr=myJsonStr_","
				s myJsonStr=myJsonStr_"{"
				s myJsonStr=myJsonStr_"""id"":"""_""_mySMRowID_""",""text"":"""_myCaption_""","
				s myJsonStr=myJsonStr_"""iconCls"":"""_""_myImage_""","
				
				if (+myChildFlag'=0) {
					s myJsonStr=myJsonStr_"""leaf"":false,"
					s myJsonStr=myJsonStr_"""expanded"":true"
					//获取子菜单
					;s myJsonStr=myJsonStr_"""expanded"":true"_""","
					;s myJsonStr=myJsonStr_"""children"":"_##class(web.DHCBL.BDP.BDPPreferences).GetMenuAut(mySMRowID,ObjectType,ObjectReference,OTHLLRowId)
				}else {
					s myJsonStr=myJsonStr_"""leaf"":true"
				}
				s myJsonStr=myJsonStr_"}"
			}
			
			d myMenuObj.%Close()
		}
	}
	
	k myMenuArray
	}
	s myJsonStr="["_myJsonStr_"]"
	
	q myJsonStr
}

/// Creator：陈莹
/// CreatDate: 2014-11-13
/// Description：获取角色的实际 获取医院级授权
/// Table：User.BDPPreferences
/// Input：objecttype, objectreference, OTHLLRowId
/// OTHLLRowId为objecttype为用户时,取的其他登陆科室里科室—安全组 数据的rowid，为空则取默认登录科室 
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.BDP.BDPPreferences","GetHospAut","U","1","")
Query GetHospAut(objecttype As %String, objectreference As %String, OTHLLRowId) As %Query(ROWSPEC = "ID:%String,ObjectType:%String,ObjectReference:%String,Object:%String,AppKey:%String,AppSubKey:%String,AppSubKey1:%String,Data:%String,Data1:%String")
{
}

ClassMethod GetHospAutExecute(ByRef qHandle As %Binary, objecttype As %String, objectreference As %String, OTHLLRowId) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	
	
	
	s Data1=""
	if (objectreference)
	{
		if (objecttype="G")||(objecttype="L" )
		{
			s ID=""
			
			for
			{
				s ID=$o(^User.BDPPreferencesD(ID),-1) q:(ID="")||(ID=0)
				s AppSubKey1=""
				s ObjectType1=$LISTGET($G(^User.BDPPreferencesD(ID)),3)
				s ObjectReference1=$LISTGET($G(^User.BDPPreferencesD(ID)),4)
				s AppKey=$LISTGET($G(^User.BDPPreferencesD(ID)),1)
				s AppSubKey=$LISTGET($G(^User.BDPPreferencesD(ID)),2)
				s Data=$LISTGET($G(^User.BDPPreferencesD(ID)),7)
				i (ObjectType1=objecttype)&(ObjectReference1=objectreference)&(AppKey="BD")&(AppSubKey="HospPre")
				{	
					s AppSubKey1="医院级授权"
					s Data1=##class(web.DHCBL.BDP.BDPPreferences).GetHOSPAutData(Data)
			
					if (ObjectType1="G")
					{
						s ObjectType="安全组"
						s ObjectReference=$p($g(^SSU("SSGRP",ObjectReference1)),"^",1)
					}
					elseif(ObjectType1="L")
					{
						s ObjectType="科室"
						s ObjectReference=$p($g(^CTLOC(ObjectReference1)),"^",2)
					}
					s Object=ObjectType_"--"_ObjectReference
			
					d OutputRowHOSP
					
				}		
			}
		}
		elseif(objecttype="U")
		{

			//用户自己的权限
			s ID=""	
			for
			{
				
				s ID=$o(^User.BDPPreferencesD(ID),-1) q:(ID="")||(ID=0)	
				s AppSubKey1=""
				s ObjectType1=$LISTGET($G(^User.BDPPreferencesD(ID)),3)
				s ObjectReference1=$LISTGET($G(^User.BDPPreferencesD(ID)),4)
				s AppKey=$LISTGET($G(^User.BDPPreferencesD(ID)),1)
				s AppSubKey=$LISTGET($G(^User.BDPPreferencesD(ID)),2)
				s Data=$LISTGET($G(^User.BDPPreferencesD(ID)),7)
				
				i (ObjectType1=objecttype)&(ObjectReference1=objectreference)&(AppKey="BD")&(AppSubKey="HospPre")
				{
					s AppSubKey1="医院级授权"
					
					s Data1=##class(web.DHCBL.BDP.BDPPreferences).GetHOSPAutData(Data)
			
			
					s ObjectType="用户"
					s ObjectReference=$p($g(^SSU("SSUSR",ObjectReference1)),"^",2)
				
					s Object=ObjectType_"--"_ObjectReference
			
					d OutputRowHOSP

				}
			}
				
			if (Data1="")
			{

				////对科室的授权	
				if (OTHLLRowId="") 
				{
					//默认登录科室
					s objecttypeL="L" 
					s objectreferenceL=$p($g(^SSU("SSUSR",objectreference)),"^",4)   ///102
					//安全组
					s objecttypeG="G" 
					s objectreferenceG=$p($g(^SSU("SSUSR",objectreference)),"^",5)   ///1
				}
				else  ///1||2
				{
					s ParRef=$p($g(OTHLLRowId),"||",1)  
					s ChildSub=$p($g(OTHLLRowId),"||",2)
					//其他登陆科室
					s objecttypeL="L"  
					s objectreferenceL=$p($g(^SSU("SSUSR",ParRef,"OTHLL",ChildSub)),"^",1)  ///131	
					//安全组
					s objecttypeG="G"  
					s objectreferenceG=$p($g(^SSU("SSUSR",ParRef,"OTHLL",ChildSub)),"^",2)  ///DEMO GROUP	
				}
			
				s ID=""	
				for
				{
					
					s ID=$o(^User.BDPPreferencesD(ID),-1) q:(ID="")||(ID=0)	
					s AppSubKey1=""
					s ObjectType1=$LISTGET($G(^User.BDPPreferencesD(ID)),3)
					s ObjectReference1=$LISTGET($G(^User.BDPPreferencesD(ID)),4)
					s AppKey=$LISTGET($G(^User.BDPPreferencesD(ID)),1)
					s AppSubKey=$LISTGET($G(^User.BDPPreferencesD(ID)),2)
					s Data=$LISTGET($G(^User.BDPPreferencesD(ID)),7)	
					i (ObjectType1=objecttypeL)&(ObjectReference1=objectreferenceL)&(AppKey="BD")&(AppSubKey="HospPre")
					{	

						s AppSubKey1="医院级授权"
						s Data1=##class(web.DHCBL.BDP.BDPPreferences).GetHOSPAutData(Data)
			
						s ObjectType="科室"  
						s ObjectReference=$p($g(^CTLOC(objectreferenceL)),"^",2)  ///CWK=财务科
				
						s Object=ObjectType_"--"_ObjectReference
			
						d OutputRowHOSP
						
					}
				}
				
				if (Data1="")
				{
					//对安全组的授权
					s ID=""	
					for
					{
						s AppSubKey1=""
						s ID=$o(^User.BDPPreferencesD(ID),-1) q:(ID="")||(ID=0)	
						s ObjectType1=$LISTGET($G(^User.BDPPreferencesD(ID)),3)
						s ObjectReference1=$LISTGET($G(^User.BDPPreferencesD(ID)),4)
						s AppKey=$LISTGET($G(^User.BDPPreferencesD(ID)),1)
						s AppSubKey=$LISTGET($G(^User.BDPPreferencesD(ID)),2)
						s Data=$LISTGET($G(^User.BDPPreferencesD(ID)),7)	
						i (ObjectType1=objecttypeG)&(ObjectReference1=objectreferenceG)&(AppKey="BD")&(AppSubKey="HospPre")
						{	
							s AppSubKey1="医院级授权"
							s Data1=##class(web.DHCBL.BDP.BDPPreferences).GetHOSPAutData(Data)
			
							s ObjectType="安全组"
							s ObjectReference=$p($g(^SSU("SSGRP",objectreferenceG)),"^",1)
				
							s Object=ObjectType_"--"_ObjectReference
			
							d OutputRowHOSP
							q
						}
					}
				}
			}
		}
	}
	

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowHOSP
    set Data=$lb(ID,ObjectType,ObjectReference,Object,AppKey,AppSubKey,AppSubKey1,Data,Data1)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetHospAutFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetHospAutExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching
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

ClassMethod GetHospAutClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetHospAutExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 获取默认安全组和登陆科室、或通过其他登陆科室获取安全组和科室
/// w ##class(web.DHCBL.BDP.BDPPreferences).GetGroupLocByOTHLL("L","1","")
ClassMethod GetGroupLocByOTHLL(objecttype As %String, objectreference As %String, othllrowid As %String) As %String
{
	s str=""
	if (objectreference)
	{
		if (objecttype="G")
		{
			s ObjectType="安全组"
			s ObjectReference=$p($g(^SSU("SSGRP",objectreference)),"^",1)
			s str=ObjectType_"："_ObjectReference
		}
		elseif(objecttype="L")
		{
			s ObjectType="科室"
			s ObjectReference=$p($g(^CTLOC(objectreference)),"^",2)
			s str=ObjectType_"："_ObjectReference
		}
		elseif(objecttype="U")
		{
			s ObjectType="用户"
			s ObjectReference=$p($g(^SSU("SSUSR",objectreference)),"^",2)
				
			if (othllrowid="") 
			{
				//默认登录科室
				s ObjectTypeL="科室" 
				s ObjectReferenceL=$p($g(^SSU("SSUSR",objectreference)),"^",4)
				s:ObjectReferenceL'="" ObjectReferenceL=$p($g(^CTLOC(ObjectReferenceL)),"^",2)
				
				//安全组
				s ObjectTypeG="安全组" 
				s ObjectReferenceG=$p($g(^SSU("SSUSR",objectreference)),"^",5)
				s:ObjectReferenceG'="" ObjectReferenceG=$p($g(^SSU("SSGRP",ObjectReferenceG)),"^",1)
				s str=ObjectType_"："_ObjectReference_"--"_ObjectTypeL_"："_ObjectReferenceL_"--"_ObjectTypeG_"："_ObjectReferenceG
			}
			else  ///1||2
			{
				s ParRef=$p($g(othllrowid),"||",1)  
				s ChildSub=$p($g(othllrowid),"||",2)
				//其他登陆科室
				s ObjectTypeL="科室"  
				s ObjectReferenceL=$p($g(^SSU("SSUSR",ParRef,"OTHLL",ChildSub)),"^",1)  ///131
				s:ObjectReferenceL'="" ObjectReferenceL=$p($g(^CTLOC(ObjectReferenceL)),"^",2)
				
				
				//安全组
				s ObjectTypeG="安全组"  
				s ObjectReferenceG=$p($g(^SSU("SSUSR",ParRef,"OTHLL",ChildSub)),"^",2)  ///DEMO GROUP
				s:ObjectReferenceG'="" ObjectReferenceG=$p($g(^SSU("SSGRP",ObjectReferenceG)),"^",1)
				
			
				s str=ObjectType_":"_ObjectReference_"--"_ObjectTypeL_":"_ObjectReferenceL_"--"_ObjectTypeG_":"_ObjectReferenceG
			
			}
		}		
	}		
	q str
}

/// 解析菜单授权数据
/// 返回s Data1=##class(web.DHCBL.BDP.BDPPreferences).GetMenuAutData(Data)
ClassMethod GetMenuAutData(Data) As %String
{
	s Data1="",str=""
	///[{ID:2},{ID:128},{ID:129},{ID:130},{ID:146},{ID:382},{ID:383}]
	if (Data="")||(Data="[]")
	{
		 s Data1=""
	}
	else
	{
		s count=$l(Data,"}")
		if count>1
		{
			s Data1="["
			for i=1:1:(count-1)
			{
				s str=$p(Data,"}",i)
				s id=$p(str,":",2)
				s Caption=$LISTGET($G(^User.BDPMenuD(id)),3)
				s Data1=Data1_Caption_","
			}
			s Data1=$e(Data1,1,*-1)
			s Data1=Data1_"]"
		}
	}
	q Data1
}

/// 解析菜单授权数据
/// 返回w ##class(web.DHCBL.BDP.BDPPreferences).GetLogAutData("{limited:1,IDS:[{ID:2},{ID:39},{ID:40},{ID:41},{ID:42}]}")
ClassMethod GetLogAutData(Data) As %String
{
	s IDStr=$p(Data,"IDS:",2)
	s IDStr=$e(IDStr,1,*-1)
	///IDStr="[{ID:2},{ID:128},{ID:129},{ID:130},{ID:146},{ID:382},{ID:383}]"
	s Data1="",str=""
	
	if (IDStr="")||(IDStr="[]")
	{
		 s Data1=""
	}
	else
	{
		s count=$l(IDStr,"}")
		if count>1
		{
			s Data1="["
		
			for i=1:1:(count-1)
			{
				s str=$p(IDStr,"}",i)
				s id=$p(str,":",2)
				s Caption=$LISTGET($G(^User.BDPMenuD(id)),3)
				s Data1=Data1_Caption_","
			}
			s Data1=$e(Data1,1,*-1)
			s Data1=Data1_"]"
		}
	}
	q Data1
}

/// 解析基础数据授权数据
/// 返回s Data1=##class(web.DHCBL.BDP.BDPPreferences).GetBDAutData(AppSubKey,Data)
/// w ##class(web.DHCBL.BDP.BDPPreferences).GetBDAutData("CT_City","{limited:1,IDS:[{ID:1},{ID:2}]}")
ClassMethod GetBDAutData(AppSubKey, Data) As %String
{
	n (AppSubKey,Data)
	s $zt="GetBDAutDataERROR"
	s strClassInfo="",classAllName="",propertyName="",descstr="",Data1="",str="",Data2=""

	s strClassInfo= ##class(web.DHCBL.BDP.BDPExecutables).GetClassInfoByCode(AppSubKey)
	s classAllName=$p(strClassInfo,"^",1)
	s propertyName=$p(strClassInfo,"^",2)
	if (classAllName="")||(propertyName="")
	{
		s Data1=""

	}
	else
	{
		
		s descstr=##class(web.DHCBL.BDP.FindTableStructure).GetProperty(classAllName,propertyName) //s desc=$p($g(^CT("COU",XROWID)),"^",2)
		s descstr1=$p(descstr,"XROWID",1)
		s descstr2=$p(descstr,"XROWID",2)
		
		
		s BDPTableListid = $o(^User.BDPTableListI("UqIndex"," "_$zcvt(classAllName,"U"),0))
		if BDPTableListid'=""
		{
			S xGlobal=$listget($g(^User.BDPTableListD(BDPTableListid)),9)  
			s DescProName=$o(^User.BDPTableListI("SubProDescIndex",classAllName,0))	
			
		}
		if (Data["limited:0")
		{
			 s Data1="不受限"
		}
		if (Data["limited:1")||(Data["2#")  //医嘱项存成了bitmap格式
		{
			//{limited:1,IDS:[{ID:2},{ID:3},{ID:4},{ID:5},{ID:28}]}
			s Data2=$p(Data,"IDS:",2)
			s count=$l(Data2,"}")
			s Data1="受限,["
			if (count>2)
			{
				for i=1:1:(count-2)
				{
					s str=$p(Data2,"}",i)
					s id=$p(str,":",2)	
					s xobjStr="s dataobj=##class("_classAllName_").%OpenId("""_id_""")"
					if classAllName="User.ARCItmMast" s xobjStr="s dataobj=##class("_classAllName_").%OpenId("""_id_"||1"_""")"  //医嘱项特殊
					x xobjStr
					if (dataobj)&&(propertyName'="")
					{
						s DescXstr="s desc=dataobj."_propertyName
						x DescXstr
						d dataobj.%Close()
						continue:desc=""
					}
					s Data1=Data1_desc_","	
				}
				s Data1=$e(Data1,1,*-1)
			}
			s Data1=Data1_"]"
		}	
	}
	q Data1
GetBDAutDataERROR
	Q Data
}

/// 解析功能元素授权数据
/// 返回s Data1=##class(web.DHCBL.BDP.BDPPreferences).GetItemAutData(Data)
ClassMethod GetItemAutData(Data, MenuItemFlag As %String = "") As %String
{
	//[{ID:117||1523},{ID:117||1512}]
	s Data1="",str=""
	if (Data="")||(Data="[]")
	{
		 s Data1=""
	}
	else
	{
		s count=$l(Data,"}")
		s Data1="["
		for i=1:1:(count-1)
		{
			s str=$p(Data,"}",i)
			s id=$p(str,":",2)
			if (MenuItemFlag="")
			{
				s BDEFName=$LISTGET($G(^User.BDPExecutablesD($p(id,"||",1),"ChildExtExecItem",$p(id,"||",2))),37)
			}
			else
			{
				s BDEFName=$lg($g(^User.BDPMenuD($p(id,"||",1),"ChildItem",$p(id,"||",2))),3)
			}

			s Data1=Data1_BDEFName_","
		}
		s Data1=$e(Data1,1,*-1)
		s Data1=Data1_"]"
	}
	
	q Data1
}

/// 解析数据翻译的授权数据
/// 返回s Data1=##class(web.DHCBL.BDP.BDPPreferences).GetTableListData(Data)
ClassMethod GetTableListData(Data) As %String
{
	//[{ID:117||1523},{ID:117||1512}]
	s Data1="",str=""
	if (Data="")||(Data="[]")
	{
		 s Data1=""
	}
	else
	{
		s count=$l(Data,"}")
		s Data1="["
		for i=1:1:(count-1)
		{
			s str=$p(Data,"}",i)
			s id=$p(str,":",2)
			s FieldDesc=$LISTGET($G(^User.BDPTableListD($p(id,"||",1),"ChildField",$p(id,"||",2))),2)
			s Data1=Data1_FieldDesc_","
		}
		s Data1=$e(Data1,1,*-1)
		s Data1=Data1_"]"
	}
	
	q Data1
}

/// 解析基础数据授权-医院级授权 数据
/// 返回s Data1=##class(web.DHCBL.BDP.BDPPreferences).GetHOSPAutData(Data)
ClassMethod GetHOSPAutData(Data) As %String
{
	s Data2="",Data1="",str=""
	if (Data["limited:2")
	{
		 s Data1="登陆角色医院"
	}
	if (Data["limited:1")
	{
		//{limited:1,IDS:[{ID:2},{ID:3}]}
	
		s Data2=$p(Data,"IDS:",2)
		s count=$l(Data2,"}")
		s Data1="自定义,["
		if (count>2)
		{
			for i=1:1:(count-2)
			{
				s str=$p(Data2,"}",i)
				s id=$p(str,":",2)
				s HOSPDesc=$p($g(^CT("HOSP",id)),"^",2)
				s Data1=Data1_HOSPDesc_","
		
			}
			s Data1=$e(Data1,1,*-1)
		}
		s Data1=Data1_"]"				
	}			
	if (Data["limited:0")
	{
		s Data1="不受限"
	}
	q Data1
}

/// 解析科室接收消息权限数据
/// 返回s Data1=##class(web.DHCBL.BDP.BDPPreferences).GetLocNewsAutData(Data)
ClassMethod GetLocNewsAutData(Data) As %String
{
	///[{ID:2},{ID:128},{ID:129},{ID:130},{ID:146},{ID:382},{ID:383}]
	s Data1="",str=""
	if (Data="")||(Data="[]")
	{
		 s Data1=""
	}
	else
	{
		s count=$l(Data,"}")
		s Data1="["
		if (count>2)
		{
			for i=1:1:(count-1)
			{
				s str=$p(Data,"}",i)
				s id=$p(str,":",2)
				s LOCDesc=$p($g(^CTLOC(id)),"^",2)
				s Data1=Data1_LOCDesc_","
		
			}
			s Data1=$e(Data1,1,*-1)
		}
		s Data1=Data1_"]"
	}
	q Data1
}

/// 解析基础数据授权-医嘱项数据
/// 返回s Data1=##class(web.DHCBL.BDP.BDPPreferences).GetARCItmMastData(Data)
ClassMethod GetARCItmMastData(Data) As %String
{
	s str="",Data1=""
	if (Data'="") 
	{
		if ($l(Data,"#")=1) {
			 s limited=0
			 s Data1="不受限"
		}
		elseif ($l(Data,"#")=2) {
			s limited=$p(Data,"#",1)   //1
			if (limited=1)
			{
				s Autstr=$p(Data,"#",2) 
				s Data1="受限"
				s arcimrowid=0
				for
				{
					s arcimrowid=$bitfind(Autstr,1,arcimrowid+1)
					q:arcimrowid=0
					s arcimdesc=$p(^ARCIM(arcimrowid,1,1),"^",2)
					//s arcimdesc =##class(web.DHCBL.BDP.FunLib).EvalJSON(arcimdesc)
					if (str'="")  s str=str_","_arcimdesc
					else  s str=arcimdesc
				}
				s Data1=Data1_",{"_str_"}"
			}
			else
			{
				 s Data1="不受限"
			}
		}
	}
	else
	{
		s Data1=""	
	}
	q Data1
}

/// 解析基础数据授权-ICD诊断代码数据
/// 返回s Data1=##class(web.DHCBL.BDP.BDPPreferences).GetICDDxData(Data)
ClassMethod GetICDDxData(Data) As %String
{
	S Data1="",str=""
	if (Data'="") 
	{
		if ($l(Data,"#")=1) {
			 s limited=0
			 s Data1="不受限"
		}
		elseif ($l(Data,"#")=2) {
			s limited=$p(Data,"#",1)   //1
			if (limited=1)
			{
				s Autstr=$p(Data,"#",2) 
				s Data1="受限"
				s mrcidrowid=0
				
				for
				{
					s mrcidrowid=$bitfind(Autstr,1,mrcidrowid+1)
					q:mrcidrowid=0
					//continue:$p($g(^MRC("ID",mrcidrowid)),"^",27)="N"
					s mrciddesc=$p(^MRC("ID",mrcidrowid),"^",2)
					//s mrciddesc =##class(web.DHCBL.BDP.FunLib).EvalJSON(mrciddesc)
					continue:(mrciddesc="-")
					if (str'="")  s str=str_","_mrciddesc
					else  s str=mrciddesc
				}
				s Data1=Data1_",{"_str_"}"
			}
			else
			{
				 s Data1="不受限"
			}
		}
	}
	else
	{
		S Data1=""
	}
	q Data1
}

}
