/// 名称: 		BILL.EINV.BL.COM.InvPrtGrantCtl.cls
/// 描述: 		发票发放业务
/// 编写者：	ZhaoZW
/// 编写日期: 	2019-10-28
Class BILL.EINV.BL.COM.InvPrtGrantCtl Extends %RegisteredObject
{

/// 查询用户信息
/// d ##class(%ResultSet).RunQuery("BILL.EINV.BL.COM.InvPrtGrantCtl","QuerySSUserInfo","D")
Query QuerySSUserInfo(KeyWord As %String) As %Query(ROWSPEC = "ind,userName:%String,userID:%String")
{
}

ClassMethod QuerySSUserInfoExecute(ByRef qHandle As %Binary, KeyWord As %String) As %Status
{
	Set repid=$I(^CacheTemp)
    s ind=1
    Set qHandle=$lb(0,repid,0)
    /////以上不用动
    q:KeyWord=""
    s:KeyWord'="" KeyWord=$$ALPHAUP^SSUTIL4(KeyWord)
    s SName=""
    f  s SName=$o(^SSU("SSUSR",0,"SSUSR_Name",SName)) q:SName=""  d
    .s SRowid=""
    .f  s SRowid=$o(^SSU("SSUSR",0,"SSUSR_Name",SName,SRowid)) q:SRowid=""  d
    ..s SSUserInfo=$g(^SSU("SSUSR",SRowid))
    ..s UserCode=$p(SSUserInfo,"^",1)
    ..S userName=$p(SSUserInfo,"^",2)
    ..s:userName'="" UpuserName=$$ALPHAUP^SSUTIL4(userName)
	..q:UpuserName'[KeyWord
	..d OutputRow
    //以下不用动
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
	//需要输出的列
	set Data=$lb(ind,userName,SRowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	q
}

ClassMethod QuerySSUserInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QuerySSUserInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QuerySSUserInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QuerySSUserInfoExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 查询收费员信息
/// d ##class(%ResultSet).RunQuery("BILL.EINV.BL.COM.InvBuyApplyCtl","QuerySFUserInfo","O","D")
Query QuerySFUserInfo(Type As %String, KeyWord As %String) As %Query(ROWSPEC = "ind,userName:%String,userID:%String")
{
}

ClassMethod QuerySFUserInfoExecute(ByRef qHandle As %Binary, Type As %String, KeyWord As %String) As %Status
{
	Set repid=$I(^CacheTemp)
    s ind=1
    Set qHandle=$lb(0,repid,0)
    /////以上不用动
    q:Type="" $$$OK
    
    s ^TMPXBB("QuerySFUserInfo")=Type_"^"_KeyWord
    s Type=$case(Type,"PO":"O","PI":"I","PR":"R","PH":"O",:"O")
    
    s:KeyWord'="" KeyWord=$$ALPHAUP^SSUTIL4(KeyWord)
    s Grptype=$o(^DHCJFRcptGroupSet(0,"Type",Type,""))
    s GrpID=$o(^DHCJFRcptGroupSet(0,"Type",Type,Grptype,""))
    s GrpSub=0
    f  s GrpSub=$o(^DHCJFRcptGroupSet(GrpID,"Sub",GrpSub)) q:GrpSub=""  d
    .s UserDr=$p(^DHCJFRcptGroupSet(GrpID,"Sub",GrpSub),"^",4)
    .s SSUserInfo=$g(^SSU("SSUSR",UserDr))
    .s UserCode=$p(SSUserInfo,"^",1)
    .S userName=$p(SSUserInfo,"^",2)
    .s:userName'="" UpuserName=$$ALPHAUP^SSUTIL4(userName)
	.q:(UpuserName'[KeyWord)&&(KeyWord'="")
	.d OutputRow
    //以下不用动
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
	//需要输出的列
	set Data=$lb(ind,userName,UserDr)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	q
}

ClassMethod QuerySFUserInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QuerySFUserInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QuerySFUserInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QuerySFUserInfoExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 功能说明：导入发票发放信息
/// 入参说明：RowDataInfo  --> 导入模板的数据拼串
///           UserDr       --> 操作员Dr
///           ErrMsg       --> 错误信息(出参)
///           ExtStr       --> 备用字符串
/// s RowDataInfo="00003101^00003200^10221^2019-10-18^^00003109^Y^EO^N^^^^^^^MZ^^^^^^^^^2"
/// s ErrMsg=""
/// w ##class(BILL.EINV.BL.COM.InvPrtGrantCtl).ImportInvPrtGrantByExcel(RowDataInfo, "1", .ErrMsg, "BJDTYY^RBBX1")
ClassMethod ImportInvPrtGrantByExcel(RowDataInfo As %String, UserDr As %String, ByRef ErrMsg As %String, ExtStr As %String) As %String
{
	s ^CacheTemp("ImportInvPrtGrantByExcel")=RowDataInfo
	s RtnFlg="0"
	
	s INVStartInv=$p(RowDataInfo, "^", 1)   ;开始号码
	s:INVStartInv="" ErrMsg="开始代码不能为空。"
	q:INVStartInv="" RtnFlg
	
	s INVRowid=$o(^DHCINVOICE(0,"STNO",INVStartInv, ""))
	i INVRowid="" d
	.s objInvPrtGrant=##class(User.DHCINVOICE).%New()
	e  d
	.s objInvPrtGrant=##class(User.DHCINVOICE).%OpenId(INVRowid)
	
	s objInvPrtGrant.INVStartInv=$p(RowDataInfo,"^",1) ;开始号码
	s objInvPrtGrant.INVEndInv=$p(RowDataInfo,"^",2) ;结束号码
	d objInvPrtGrant.INVUsrSetObjectId($p(RowDataInfo,"^",3)) ;领取人指针 /// DR + SetObjectId(DR)
	s:$p(RowDataInfo,"^",4)'="" objInvPrtGrant.INVDate=$zdh($p(RowDataInfo,"^",4),3) ;日期
	s:$p(RowDataInfo,"^",5)'="" objInvPrtGrant.INVTime=$zth($p(RowDataInfo,"^",5),1) ;时间
	
	s objInvPrtGrant.INVLastNum=$p(RowDataInfo,"^",6) ;当前号码
	s objInvPrtGrant.INVFinalflag=$p(RowDataInfo,"^",7) ;发票标志
	s objInvPrtGrant.INVtype=$p(RowDataInfo,"^",8) ;票据类型
	s objInvPrtGrant.INVStatus=$p(RowDataInfo,"^",9) ;状态
	s objInvPrtGrant.INVLinkto=$p(RowDataInfo,"^",10) ;
	
	s objInvPrtGrant.INVjynum=$p(RowDataInfo,"^",11) ;
	s objInvPrtGrant.INVserialno=$p(RowDataInfo,"^",12) ;
	s objInvPrtGrant.INVUsrJynum=$p(RowDataInfo,"^",13) ;
	s objInvPrtGrant.INVUsrSerialno=$p(RowDataInfo,"^",14) ;
	s objInvPrtGrant.INVoriginaldr=$p(RowDataInfo,"^",15) ;
	
	s objInvPrtGrant.INVtitle=$p(RowDataInfo,"^",16) ;开始字母
	s objInvPrtGrant.INVcomment1=$p(RowDataInfo,"^",17) ;
	s objInvPrtGrant.INVcomment2=$p(RowDataInfo,"^",18) ;
	s objInvPrtGrant.INVconfirmflag=$p(RowDataInfo,"^",19) ;核销标志
	s objInvPrtGrant.INVconfirmdate=$p(RowDataInfo,"^",20) ;核销日期
	
	s objInvPrtGrant.INVconfirmtime=$p(RowDataInfo,"^",21) ;核销时间
	s objInvPrtGrant.INVreturnflag=$p(RowDataInfo,"^",22) ;返回标志
	s objInvPrtGrant.INVreturndate=$p(RowDataInfo,"^",23) ;返回日期
	s objInvPrtGrant.INVreturntime=$p(RowDataInfo,"^",24) ;返回时间
	s objInvPrtGrant.INVhospital=$p(RowDataInfo,"^",25) ;院区指针
	
	b ;00
    ///保存数据
    s sc=objInvPrtGrant.%Save()
    b ;01
    i $System.Status.IsError(sc) d
    .s RtnFlg="0"
    e  d
    .s RtnFlg=objInvPrtGrant.%Id()
    
    q RtnFlg
}

}
