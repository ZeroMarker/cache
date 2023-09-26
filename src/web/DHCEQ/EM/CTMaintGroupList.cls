Class web.DHCEQ.EM.CTMaintGroupList Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.CTMaintGroupList","GetMaintGroupList","","","","")
Query GetMaintGroupList(MemberUser As %String = "", MGroupDR As %String = "", MFlag As %String = "", CurUserID As %String = "") As %Query(ROWSPEC = "TRowID:%String,TUserdr:%String,TUser:%String,TMaintGroupDR:%String,TManagerFlag:%String,TInvalidFlag:%String,TInitials:%String,TMaintGroup:%String")
{
}

ClassMethod GetMaintGroupListExecute(ByRef qHandle As %Binary, MemberUser As %String = "", MGroupDR As %String = "", MFlag As %String = "", CurUserID As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s MemberUser=$ZCONVERT(MemberUser,"U")
 	//add by zx 2016-11-28 根据当前人员取维修组 begin ZX0036
	i (CurUserID'="")&&(MGroupDR="") d
	.s curRowid=$o(^DHCEQCCode("DHCEQMCMaintGroupList",0,"MaintMember","N",CurUserID,0))
	.i curRowid'="" d
	..s MGroupDR=$P($G(^DHCEQCCode("DHCEQMCMaintGroupList",curRowid)),"^",1)
	//add by zx 2016-11-28 根据当前人员取维修组 end
	
	s index=1
	s rowid=0
	f  s rowid=$o(^DHCEQCCode("DHCEQMCMaintGroupList",rowid))  quit:rowid=""  d
	.d ResetVariablesGetMaintGroupList
    .s TRowID=rowid
	.s TInvalidFlag =$P($G(^DHCEQCCode("DHCEQMCMaintGroupList",rowid)),"^",6) //无效判断
	.q:TInvalidFlag="Y"
    .s TUserdr=$P($G(^DHCEQCCode("DHCEQMCMaintGroupList",rowid)),"^",2)
	.i TUserdr'="" d
	..s TInitials=$P($G(^DHCEQCCode("DHCEQCUser",TUserdr)),"^",1) 
	..s TUser=##Class(web.DHCEQCommon).GetTrakNameByID("user", TUserdr)
	.s TMaintGroupDR=$P($G(^DHCEQCCode("DHCEQMCMaintGroupList",rowid)),"^",1)
	.q:(MemberUser'="")&($ZCONVERT(TUser,"U")'[MemberUser)
	.q:(MGroupDR'="")&&(TMaintGroupDR'=MGroupDR)
	.s MGInvalidFlag="N"
	.i TMaintGroupDR'=""  d
	..s TMaintGroup=$p($g(^DHCEQCCode("DHCEQMCMaintGroup",TMaintGroupDR)),"^",2)
	..s MGInvalidFlag=$p($g(^DHCEQCCode("DHCEQMCMaintGroup",TMaintGroupDR)),"^",9)	// Mozy		2019-10-18
	.q:MGInvalidFlag="Y"
    .s TManagerFlag=$P($G(^DHCEQCCode("DHCEQMCMaintGroupList",rowid)),"^",5)
    .q:(MFlag="true")&&(TManagerFlag'="Y")	;//需求号:264283		Mozy	2016-10-13
	.d OutputRowGetMaintGroupList
	quit $$$OK
OutputRowGetMaintGroupList
	s Data=$lb(TRowID,TUserdr,TUser,TMaintGroupDR,TManagerFlag,TInvalidFlag,TInitials,TMaintGroup)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetMaintGroupList
	s (TRowID,TUserdr,TUser,TMaintGroupDR,TManagerFlag,TInvalidFlag,TInitials,TMaintGroup)=""
	quit
}

ClassMethod GetMaintGroupListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMaintGroupListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 		}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetMaintGroupListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMaintGroupListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// add by zx 2022-8-21
/// 珠海人民--移动端维修组选择框数据
/// w ##Class(web.DHCEQ.EM.CTMaintGroupList).MaintGroupList("","","","","347")
ClassMethod MaintGroupList(MemberUser As %String = "", MGroupDR As %String = "", MFlag As %String = "", CurUserID As %String = "", GroupID As %String = "")
{
	i GroupID="" s GroupID=%session.Get("LOGON.GROUPID")  
 	s MemberUser=$ZCONVERT(MemberUser ,"U")
	s root=##class(%Library.DynamicObject).%New()		//json对象
 	s List=##class(%Library.DynamicArray).%New()
	s rowid=0 
	f  s rowid=$o(^DHCEQCCode("DHCEQMCMaintGroup",rowid))  quit:rowid=""  d
	.q:$p($g(^DHCEQCCode("DHCEQMCMaintGroup",rowid)),"^",9)="Y"
	.s MGDesc=$p($g(^DHCEQCCode("DHCEQMCMaintGroup",rowid)),"^",2)
	.s MGCode=$p($g(^DHCEQCCode("DHCEQMCMaintGroup",rowid)),"^",3)
	.s EquipType=$p($g(^DHCEQCCode("DHCEQMCMaintGroup",rowid)),"^",12)  //add by wy 2023-4-18 增加权限过滤,维修组做区分
	.q:(EquipType'="")&&(##Class(web.DHCEQCommon).EquipTypeIsIn(EquipType,GroupID,"","2")'=0)  
	.s Data=##class(%Library.DynamicObject).%New()		//json对象
 	.d Data.%Set("MGRowID",rowid)
 	.d Data.%Set("MGDesc",MGDesc)
 	.d Data.%Set("MGCode",MGCode)
 	.s Arr=##class(%Library.DynamicArray).%New()			//json数组
 	.s (MGLRowID,MGLUserName,MGLMemberUserDR,MGLUserTel)=""
 	.s MGLUserName="不限定"
 	.d SetGroupListUseObj
	.s MGLRowID=0
	.f  s MGLRowID=$o(^DHCEQCCode("DHCEQMCMaintGroupList",0,"MaintGroup",rowid,MGLRowID))  quit:MGLRowID=""  d
	..s MGLInvalidFlag=$p($g(^DHCEQCCode("DHCEQMCMaintGroupList",MGLRowID)),"^",6)
	..q:MGLInvalidFlag="Y"
	..s MGLMemberUserDR=$p($g(^DHCEQCCode("DHCEQMCMaintGroupList",MGLRowID)),"^",2)
	..s MGLUserName=##Class(web.DHCEQCommon).GetTrakNameByID("user", MGLMemberUserDR)
	..s MGLUserTel=##Class(web.DHCEQ.EM.CTMaintGroupList).GetWChatUserTel(MGLMemberUserDR)
	..;s UseObj=##class(%Library.DynamicObject).%New()	//json对象
 	..;d UseObj.%Set("MGLRowID",MGLRowID)
 	..;d UseObj.%Set("MGLUserName",MGLUserName)
 	..;d UseObj.%Set("MGLMemberUserDR",MGLMemberUserDR)
 	..;d UseObj.%Set("MGLUserTel",MGLUserTel)
 	..;d UseObj.%Set("MGLGroupDesc",MGDesc)
 	..;d UseObj.%Set("MGLGroupID",rowid)
 	..;d Arr.%Push(UseObj)
 	..d SetGroupListUseObj
 	.d Data.%Set("MaintGroupList",Arr)
 	.d List.%Push(Data)
	d root.%Set("MaintGroup",List)     //json对象作为外层json对象的属性data
	q root.%ToJSON()
	
SetGroupListUseObj
	s UseObj=##class(%Library.DynamicObject).%New()	//json对象
 	d UseObj.%Set("MGLRowID",MGLRowID)
 	d UseObj.%Set("MGLUserName",MGLUserName)
 	d UseObj.%Set("MGLMemberUserDR",MGLMemberUserDR)
 	d UseObj.%Set("MGLUserTel",MGLUserTel)
 	d UseObj.%Set("MGLGroupDesc",MGDesc)
 	d UseObj.%Set("MGLGroupID",rowid)
 	d Arr.%Push(UseObj)
 	
 	quit
}

/// add by zx 2021-05-07 BUG ZX0133 
/// 根据HIS用户ID获取微信绑定电话号码
/// w ##Class(web.DHCEQ.EM.CTMaintGroupList).GetWChatUserTel("2873")
ClassMethod GetWChatUserTel(ToUserID)
{
    new result,WChatUserID
    i ToUserID="" q ""
    s result=""
    s WChatUserID=0
    f  s WChatUserID=$o(^DHCEQWChatUser(0,"User",ToUserID,WChatUserID)) q:(WChatUserID="")||(result'="")  d
    .s result=$p($g(^DHCEQWChatUser(WChatUserID)),"^",10)
    
    q result
}

}
