/// 名称: DHCMed.Base.Ctloc
/// 描述: 科室表（CT_Loc）的业务封装，定义常用属性和方法
/// 编写者：wuqk
/// 编写日期: 2010-03-29
Class DHCMed.Base.SSUser Extends (%Persistent, DHCMed.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// 用户Id  SSUSR_RowID
Property Rowid As %Integer;

/// 用户代码 SSUSR_Initials
Property Code As %String(TRUNCATE = 1);

/// 用户姓名 SSUSR_Name
Property Name As %String(TRUNCATE = 1);

/// 默认科室Id SSUSR_DefaultDept_DR 指向CT_Loc
Property CtlocDr As %Integer;

/// 默认科室描述 SSUSR_DefaultDept_DR 指向CT_Loc.CTLOC_Desc
Property CtlocDesc As %String(TRUNCATE = 1);

/// 默认安全组Id SSUSR_Group  指向SS_Group
Property SSGroupDr As %Integer;

/// 默认安全组描述 SSUSR_Group  指向SS_Group.SSGRP_Desc
Property SSGroupDesc As %String(TRUNCATE = 1);

/// 对应医护人员 SSUSR_CareProv_DR  指向CT_CareProv
Property CtpcpDr As %Integer;

/// Creator：     wuqk
/// CreatDate：   2010-04-06
/// Description:  将对象格式化为字符串
/// Table：       
/// Input：       separete:指定的分隔符
/// Return：      返回各属性值，按照separete分隔
///               1:Rowid 2:Code 3:Name 4:CtlocDr 5:CtlocDesc 6:SSGroupDr 7:SSGroupDesc 8:CtpcpDr
Method ToString(separete As %String, Languages As %String = "CH") As %String
{
	if $g(separete)=""{
		set separete=..#SEPARATE
	} 
	set PatName=..Name
	set PatName=$tr(PatName,$c(0),"")
	set PatName=$tr(PatName,$c(1),"")
	set PatName=$tr(PatName,$c(10),"")
	set PatName=$tr(PatName,$c(13),"")
	Set:PatName'="" PatName = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTCareProv","CTPCPDesc",Languages,PatName)
	set return=..Rowid_separete_..Code_separete_PatName
	set return=return_separete_..CtlocDr_separete_..CtlocDesc
	set return=return_separete_..SSGroupDr_separete_..SSGroupDesc_separete_..CtpcpDr
	quit return
}

/// Creator：     wuqk
/// CreatDate：   2010-04-06
/// Description:  根据SS_User.SSUSR_RowID取用户信息
/// Table：       SS_User
/// Input：       id:    SS_User.SSUSR_RowID
/// Return：      返回obj
/// Others：   
/// w ##class(DHCMed.Base.SSUser).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.Base.SSUser
{
	new (id)
	set return=""
	quit:id="" return
	quit:'$d(^SSU("SSUSR",id)) return
	set obj=##Class(DHCMed.Base.SSUser).%New()
	set obj.Rowid=+id
	set obj.Code=$p($g(^SSU("SSUSR",id)),"^",1)   
	set obj.Name=$p($g(^SSU("SSUSR",id)),"^",2)
	set obj.CtlocDr=+$p($g(^SSU("SSUSR",id)),"^",4)
	set obj.CtlocDesc=$p($g(^CTLOC(+obj.CtlocDr)),"^",2)
	set obj.SSGroupDr=+$p($g(^SSU("SSUSR",id)),"^",5)
	set obj.SSGroupDesc=$p($g(^SSU("SSGRP",+obj.SSGroupDr)),"^",1)
	set obj.CtpcpDr=+$p($g(^SSU("SSUSR",id)),"^",14)
	set return=obj
	// 5:CtlocDesc 6:SSGroupDr 7:SSGroupDesc 8:CtpcpDr
	do obj.%Close()
	quit return
}

/// Creator：     wuqk
/// CreatDate：   2010-04-06
/// Description:  根据SS_User.SSUSR_RowID取用户信息
/// Table：       SS_User
/// Input：       id:    SS_User.SSUSR_RowID
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.Base.SSUser).GetStringById(1)
ClassMethod GetStringById(id As %String, separete As %String) As %String
{
	new (id,separete,%session)
	Set langid=20
	Set Languages = "CH"
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
		s:langid'="" Languages=$p($g(^SS("LAN",langid)),"^",1)
	}
	set return=""
	set obj=..GetObjById(id)
	if $IsObject(obj){
		set return=obj.ToString($g(separete),Languages)
	}	
	quit return
}

/// Creator：     wuqk
/// CreatDate：   2010-04-08
/// Description:  根据简写查询用户
/// Table：       SS_User
/// Input：       alias:   可以是用户代码、姓名、姓名拼音字头
/// Return：      返回列表$c(1)分隔行 ^分隔列
/// w ##class(DHCMed.Base.SSUser).GetByAlias("d")
ClassMethod GetByAlias(alias As %String) As %String
{
	new (alias)
	set ind=$I(^Cachetemp)
	kill ^CacheTemp($zn,ind)
	set return=""
	
	/*拼音没有索引，干脆全遍历
	//find by code
	set sIdByCode=..GetIdByCode(alias)
	set count=$l(sIdByCode,"^")
	for i=1:1:count {
		set tmpid=$p(sIdByCode,"^",i)
		set:tmpid'="" ^CacheTemp($zn,ind,+tmpid)=""
	}
	
	//find by name
	set sIdByName=..GetIdByName(alias)
	set count=$l(sIdByName,"^")
	for i=1:1:count {
		set tmpid=$p(sIdByName,"^",i)
		set:tmpid'="" ^CacheTemp($zn,ind,+tmpid)=""
	}
	
	//build String
	set tmpid=$o(^CacheTemp($zn,ind,""))
	while tmpid'="" {
		set sUser=..GetStringById(+tmpid)
		set:sUser'="" return=return_sUser_$c(1)
		set tmpid=$o(^CacheTemp($zn,ind,tmpid))
	}
	
	kill ^CacheTemp($zn,ind)
	*/
	
	set alias=$ZCVT(alias,"u")
	set tmpid=$o(^SSU("SSUSR",""))
	while tmpid'=""{
		set flag=0
		set code=$p($g(^SSU("SSUSR",+tmpid)),"^",1)
		set name=$p($g(^SSU("SSUSR",+tmpid)),"^",2)
		set mailName=$p($g(^SSU("SSUSR",+tmpid)),"^",11)
		set CTPCPDR=$p($g(^SSU("SSUSR",+tmpid)),"^",14)
		set aliasName=""
		set:CTPCPDR'="" aliasName=$p($g(^CTPCP(CTPCPDR,3)),"^",11)
		if ($ZCVT(code,"u")[alias){set flag=1}
		elseif ($ZCVT(name,"u")[alias){set flag=1}
		elseif ($ZCVT(mailName,"u")[alias){set flag=1}
		elseif ($ZCVT(aliasName,"u")[alias){set flag=1}
		if flag=1{
			set sUser=..GetStringById(+tmpid)
			set:sUser'="" return=return_sUser_$c(1)
		}
		set tmpid=$o(^SSU("SSUSR",tmpid))
	}	
	quit return
}

/// ^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP({SSUSR_Initials}),{SSUSR_RowId}) 
/// w ##class(DHCMed.Base.SSUser).GetIdByCode("d")
ClassMethod GetIdByCode(codeAlias As %String) As %String
{
	new (codeAlias)
	set ret=""
	set codeAlias=$ZCVT(codeAlias,"u")
	set tmpCode=codeAlias
	if $d(^SSU("SSUSR",0,"SSUSR_Initials",tmpCode)){
		set id=$o(^SSU("SSUSR",0,"SSUSR_Initials",tmpCode,""))
		set ret=ret_id_"^"
	}
	set tmpCode=$o(^SSU("SSUSR",0,"SSUSR_Initials",tmpCode))
	while ((tmpCode'="")&($e(tmpCode,1,$l(codeAlias))=codeAlias)){
		set id=$o(^SSU("SSUSR",0,"SSUSR_Initials",tmpCode,""))
		set ret=ret_id_"^"
		set tmpCode=$o(^SSU("SSUSR",0,"SSUSR_Initials",tmpCode))	
	}
	
	quit ret
}

/// ^SSU("SSUSR",0,"SSUSR_Name",$$ALPHAUP({SSUSR_Name}),{SSUSR_RowId})
/// w ##class(DHCMed.Base.SSUser).GetIdByName("d")
ClassMethod GetIdByName(nameAlias As %String) As %String
{
	new (nameAlias)
	set ret=""
	set nameAlias=$ZCVT(nameAlias,"u")
	set tmpName=nameAlias
	if $d(^SSU("SSUSR",0,"SSUSR_Name",tmpName)){
		set id=$o(^SSU("SSUSR",0,"SSUSR_Name",tmpName,""))
		set ret=ret_id_"^"
	}
	set tmpName=$o(^SSU("SSUSR",0,"SSUSR_Name",tmpName))
	while ((tmpName'="")&($e(tmpName,1,$l(nameAlias))=nameAlias)){
		set id=$o(^SSU("SSUSR",0,"SSUSR_Name",tmpName,""))
		set ret=ret_id_"^"
		set tmpName=$o(^SSU("SSUSR",0,"SSUSR_Name",tmpName))	
	}
	
	quit ret
}

ClassMethod GetIdByMail(mailAlias As %String) As %String
{
}

/// Creator：     wuqk
/// CreatDate：   2010-04-08
/// Description:  根据CT_CareProv.CTPCP_RowId取用户信息
/// Table：       SS_User
/// Input：       id:    CT_CareProv.CTPCP_RowId
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// Other：       ^SSU("SSUSR",0,"CTPCP",{SSUSR_CareProv_DR},{SSUSR_RowId})
/// w ##class(DHCMed.Base.SSUser).GetByCTPCP(2)
ClassMethod GetByCTPCP(ctpcpId As %String, separete As %String) As %String
{
	new (ctpcpId,separete)
	set return=""
	quit:ctpcpId="" return
	quit:'$d(^SSU("SSUSR",0,"CTPCP",+ctpcpId)) return
	set userId=$o(^SSU("SSUSR",0,"CTPCP",+ctpcpId,""))
	set return=..GetStringById(userId,$g(separete))
	quit return
}

/// 通过姓名/工号查询医护人员列表
/// d ##class(%Library.ResultSet).RunQuery("DHCMed.Base.SSUser","QueryByName","med","")
Query QueryByName(Name As %String, Ctloc As %String) As %Query(ROWSPEC = "UserRowid:%String,UserCode:%String,UserName:%String,UserLoc:%String")
{
}

ClassMethod QueryByNameExecute(ByRef qHandle As %Binary, Name As %String, Ctloc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	s Name=$zcvt(Name,"U")
	q:Name="" $$$OK
	
	s Rowid=0
    f  s Rowid=$o(^SSU("SSUSR",Rowid)) q:Rowid=""  d
    .q:$p($g(^SSU("SSUSR",+Rowid)),"^",19)'="Y"
    .s UserCode=$p($g(^SSU("SSUSR",+Rowid)),"^",1)
    .s UserName=$p($g(^SSU("SSUSR",+Rowid)),"^",2)
    .s UserLocRowid=+$p($g(^SSU("SSUSR",+Rowid)),"^",4)
    .s UserPinYin=$p($g(^SSU("SSUSR",+Rowid)),"^",11)
    .s tUserCode=$zcvt(UserCode,"U")
    .s tUserName=$zcvt(UserName,"U")
    .s tUserPinYin=$zcvt(UserPinYin,"U")
    .q:(Name'="")&&(tUserName'[Name)&&($e(tUserPinYin,1,$l(Name))'=Name)&&($e(tUserCode,1,$l(Name))'=Name)
    .q:(Ctloc'="")&(UserLocRowid'=Ctloc)
    .s UserLoc=""
    .s:UserLocRowid'=0 UserLoc=$p(^CTLOC(+UserLocRowid),"^",2)
    .s:UserLoc["-" UserLoc=$p(UserLoc,"-",2)
    .s Data=$lb(Rowid,UserCode,UserName,UserLoc)
    .s ^CacheTemp(repid,ind)=Data
    .s ind=ind+1
    
    Quit $$$OK
}

ClassMethod QueryByNameFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryByNameExecute ]
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
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryByNameClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryByNameExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
