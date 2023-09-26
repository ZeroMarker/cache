Class web.DHCBPCEquipUser Extends %RegisteredObject
{

/// 查询设备相关人员
/// creater: liyinuo
/// date: 20141021
/// input: equipId-设备id; userType-人员类型
/// output: 输出设备相关人员信息.
/// d ##class(%ResultSet).RunQuery("web.DHCBPCEquipUser","FindEquipUser","")
Query FindEquipUser(equipId, userType = "") As %Query(ROWSPEC = "tRowId:%String,EquipDr:%String,UserType:%String,userDr:%String,inUserName:%String,outUserName:%String,BPCEUDate:%String,BPCEUTime:%String")
{
}

ClassMethod FindEquipUserExecute(ByRef qHandle As %Binary, equipId, userType = "") As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 	 //将人员类型转换大写形式，I 是安装人员;K 是保管人员
 	i userType '="" s userType=$$ALPHAUP^SSUTIL4(userType)
 	
	i (equipId = "")  d
	.s tRowId=0
	.for  s tRowId=$o(^DHCBPCEquipUser(tRowId)) q:tRowId=""  d
	..s BPCEUBPCEDr=$lg(^DHCBPCEquipUser(tRowId),1)
	..s tUserType=$lg(^DHCBPCEquipUser(tRowId),2) //人员类型
	..i ((userType="")!((userType=tUserType)&&(userType="I"))) s quipFlagI=0
	..e  d  s quipFlagI=1
	..i ((userType="")!((userType=tUserType)&&(userType="K"))) s quipFlagK=0
	..e  d  s quipFlagK=1
	..q:(quipFlagI=1)&&(quipFlagK=1)
	..s userDr=$lg(^DHCBPCEquipUser(tRowId),3)
	..s inUserName=$p(^SSU("SSUSR",userDr),"^",2) //院内人员
	..s outUserName=$lg(^DHCBPCEquipUser(tRowId),4) //院外人员
	..s userDate=$lg(^DHCBPCEquipUser(tRowId),5)
	..s userDate=##class(web.DHCANOPCom).ConvertToDate(userDate)
	..s userTime=$lg(^DHCBPCEquipUser(tRowId),6)
	..s userTime=##class(web.DHCANOPCom).ConvertToTime(userTime)
	..d OutputRow1
	e  d
	.s tRowId=0
	.for  s tRowId=$o(^DHCBPCEquipUser(0,"Equip",equipId,tRowId)) q:tRowId=""  d
	..s BPCEUBPCEDr=$lg(^DHCBPCEquipUser(tRowId),1)
	..s tUserType=$lg(^DHCBPCEquipUser(tRowId),2) //人员类型
	..i ((userType="")!((userType=tUserType)&&(userType="I"))) s quipFlagI=0
	..e  d  s quipFlagI=1
	..i ((userType="")!((userType=tUserType)&&(userType="K"))) s quipFlagK=0
	..e  d  s quipFlagK=1
	..q:(quipFlagI=1)&&(quipFlagK=1)
	..s userDr=$lg(^DHCBPCEquipUser(tRowId),3)
	..s inUserName=$p(^SSU("SSUSR",userDr),"^",2) //院内人员
	..s outUserName=$lg(^DHCBPCEquipUser(tRowId),4) //院外人员
	..s userDate=$lg(^DHCBPCEquipUser(tRowId),5)
	..s userDate=##class(web.DHCANOPCom).ConvertToDate(userDate)
	..s userTime=$lg(^DHCBPCEquipUser(tRowId),6)
	..s userTime=##class(web.DHCANOPCom).ConvertToTime(userTime)
	..d OutputRow1
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
OutputRow1
	s Data=$lb(tRowId,BPCEUBPCEDr,tUserType,userDr,inUserName,outUserName,userDate,userTime)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindEquipUserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindEquipUserExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
	//
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {				// fetch row
 		s Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindEquipUserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindEquipUserExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// 描述：根据 设备id和人员类型查找所有相关的院内人员
/// creater: liyinuo
/// input:equipId-设备id; userType-人员类型 ['I':安装人员; 'K': 保管人员]
/// output: 院内人员的ID串和人员名字串，形式为：“id1,id2.._^_name1,name2..”
/// W ##class(web.DHCBPCEquipUser).GetEquipInUserInfo("1","I")
ClassMethod GetEquipInUserInfo(EquipId, UserType) As %String
{
	i UserType '="" s UserType=$$ALPHAUP^SSUTIL4(UserType)
	s userIdList="" //id串
	s userNameList="" //姓名串
 	
	i (EquipId '= "")  d
	.s tRowId=0
	.for  s tRowId=$o(^DHCBPCEquipUser(0,"Equip",EquipId,tRowId)) q:tRowId=""  d
	..s tUserType=$lg($g(^DHCBPCEquipUser(tRowId)),2) //人员类型
	..s userDr=$lg($g(^DHCBPCEquipUser(tRowId)),3)
	..q:(userDr="")!(userDr=$c(0))
	..s inUserName=$p($g(^SSU("SSUSR",userDr)),"^",2) //院内人员
	..
	..i (UserType="K")&&(UserType=tUserType) d //保管人员判断
	...i userIdList = "" s userIdList= userDr
	...e  d  s userIdList=userIdList_","_userDr
	...i userNameList="" s userNameList=inUserName
	...e  d  s userNameList=userNameList_","_inUserName
	..i (UserType="I")&&(UserType=tUserType) d //安装人员判断
	...i userIdList = "" s userIdList= userDr
	...e  d  s userIdList=userIdList_","_userDr
	...i userNameList="" s userNameList=inUserName
	...e  d  s userNameList=userNameList_","_inUserName
	q userIdList_"^"_userNameList
}

/// 描述：根据 设备id和人员类型查找所有院外
/// creater: liyinuo
/// input:equipId-设备id;
/// output: 
/// W ##class(web.DHCBPCEquipUser).GetEquipOutUserInfo("1")
ClassMethod GetEquipOutUserInfo(EquipId) As %String
{
	//i UserType '="" s UserType=$$ALPHAUP^SSUTIL4(UserType)
	s userNameList="" //姓名串
 	s userDr=""
	i (EquipId '= "")  d
	.s tRowId=""
	.for  s tRowId=$o(^DHCBPCEquipUser(0,"Equip",EquipId,tRowId)) q:tRowId=""  d
	..s tUserType=$lg($g(^DHCBPCEquipUser(tRowId)),2) //人员类型
	..q:(tUserType'="I")&&(tUserType'="")
	..s userDr=$lg($g(^DHCBPCEquipUser(tRowId)),3)
	..;b
	..q:'((userDr=$c(0))!(userDr=""))
	..s outUserName=$lg($g(^DHCBPCEquipUser(tRowId)),4) //院外人员
	..i userNameList="" s userNameList=outUserName
	..e  d  
	...i '((outUserName="")!(outUserName=$c(0))) 
	....s userNameList=userNameList_","_outUserName
	q userNameList
}

}
