Import Sqluser

Class web.PMPPermission Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod insertPermission(level As %String, levelName As %String, ProDRHidden As %String, SHENEHQKID As %String, XQNetShenheid As %String, XQbxsh As %String) As %String
{
	set Date = +$h
	set Time = $p($h,",",2)
	set object=##class(User.PMPPermission).%New()
	set object.PERLevel = level
	set object.PERDesc = levelName
	set object1=##class(User.PMPProject).%OpenId(ProDRHidden)
	set object.PERProjectDR = object1
	//set object.PERSpare2 = youxiao
	set object.PERDate = Date
	set object.PERTime = Time
	set object.PERSpare2 = "Y" //有效标识 Y 为有效   N为无效
	set object.PERSpare3=SHENEHQKID
	set object.PERSpare4=XQNetShenheid
	set object.PERSpare5=XQbxsh
	set object.PERSpare6="N"	//权限等级争执节点  （是否到此节点判断权限争执与否，是为Y 否为N）
	set sc=object.%Save()
 	quit object.%Id()
}

ClassMethod delPermission(Rowid As %String) As %String
{
	s ret=""
	
	if (Rowid '="") {
		TSTART
		set object=##class(User.PMPPermission).%OpenId(Rowid)
		set object.PERSpare2="N"
		set sc=object.%Save()
 		
 		s ss=##class(web.PMPPermisBusiness).delByPermissDR(Rowid)
 		i ss'="1" TROLLBACK
 		
 		
 		TCOMMIT  
 		s ret=object.%Id() 
 		}
 	q ret
}

ClassMethod updatePermission(Rowid As %String, levelName As %String, ProDRHidden As %String, SHENEHQKID As %String, XQNetShenheid As %String, XQbxsh As %String, Shjd As %String = "") As %String
{
	if (Rowid '="") {
		set object=##class(User.PMPPermission).%OpenId(Rowid)
		set object.PERDesc = levelName
		set object1=##class(User.PMPProject).%OpenId(ProDRHidden)
		set object.PERProjectDR = object1
	    set object.PERSpare3=SHENEHQKID
	    set object.PERSpare4=XQNetShenheid
	    set object.PERSpare5=XQbxsh
	    set object.PERBY1=Shjd
		set sc=object.%Save()
 		quit object.%Id()
	}
}

//d ##class(%ResultSet).RunQuery("web.PMPPermission","QueryPermission","","","")

Query QueryPermission(level As %String, ProDRHidden As %String, ProDR As %String) As %Query(ROWSPEC = "TRowid:%String,Tlevel:%String,TlevelName:%String,TProDR:%String,TProDRName:%String,TDate:%String,TTime:%String,TUser:%String,TSHENHEJK:%String,TNetShenheid:%String,TNetShenhe:%String,Tbxsh:%String,Tbxshid:%String,TShjd:%String")
{
}

ClassMethod QueryPermissionExecute(ByRef qHandle As %Binary, level As %String, ProDRHidden As %String, ProDR As %String) As %Status
{
	Set repid=$I(^CacheTemp)
    s ind=1 
    s ^zzp("QueryPermission")=level_"^"_ProDRHidden_"^"_ProDR
    k ^zzppmppuser($j)
    if (ProDR=""){s ProDRHidden=""}
  	s Rowid=""  f  s Rowid=$o(^PMPPermission(Rowid)) q:(Rowid="")  d 
    .q:$p(^PMPPermission(Rowid),"^",5)="N" //删除操作的隐藏元素
    .if level'="" q:$p(^PMPPermission(Rowid),"^",3)'=level  //不为空的时候如果不同quit
    .if ProDRHidden'="" q:$p(^PMPPermission(Rowid),"^",4)'=ProDRHidden  //不为空的时候如果不同quit
    .//level:%String,levelName:%String,ProDR:%String,ProDRName:%String,Date:%String,Time:%String
    .s Tlevel = $p(^PMPPermission(Rowid),"^",3)
    .s TShjd = $p(^PMPPermission(Rowid),"^",9)	//权限争执节点  1.30 by shenbo
    .s TlevelName = $p(^PMPPermission(Rowid),"^",2)
    .s TProDRHidden = $p(^PMPPermission(Rowid),"^",4)  
    .s TProDRHiddenName = ""
    .s TUser=""
    .s childsub=0
    .if $d(^PMPPermisBusiness(Rowid,"E")) d
	..s childsub=0 f  s childsub=$o(^PMPPermisBusiness(Rowid,"E",childsub)) q:(childsub="")  d 
    ...q:$p(^PMPPermisBusiness(Rowid,"E",childsub),"^",3)="N"
    ...s PermisBusiness = ^PMPPermisBusiness(Rowid,"E",childsub)
    ...q:$d(^zzppmppuser($j,Rowid,$p(^SSU("SSUSR",$p(PermisBusiness,"^",4)),"^",2)))
    ...s ^zzppmppuser($j,Rowid,$p(^SSU("SSUSR",$p(PermisBusiness,"^",4)),"^",2))=""
    ...if TUser="" d  s TUser=$p(^SSU("SSUSR",$p(PermisBusiness,"^",4)),"^",2)
    ...e  d  s TUser=TUser_","_$p(^SSU("SSUSR",$p(PermisBusiness,"^",4)),"^",2) 
	.if $d(^PMPProject(TProDRHidden))'=0 s TProDRHiddenName = $p(^PMPProject(TProDRHidden),"^",2) //项目描述
    .s TDate = $zd($p(^PMPPermission(Rowid),"^",1),3)
    .s TTime = $zt($p(^PMPPermission(Rowid),"^",10))
    .s TRowid = Rowid
    .;s ^TMPPermission(Tlevel,TRowid)=^PMPPermission(Rowid)
    .s PERSpare2=$p(^PMPPermission(Rowid),"^",6)
    .s TSHENHEJK=""
    .i PERSpare2'="" s TSHENHEJK=$p(^PMPDictionary(PERSpare2),"^",2)
    .s TNetShenheid=$p(^PMPPermission(Rowid),"^",7)
    .s TNetShenhe="" 
    .i TNetShenheid'="" s TNetShenhe=$p(^PMPPermission(TNetShenheid),"^",2)
    .s Tbxshid=$p(^PMPPermission(Rowid),"^",8)
    .s Tbxsh=""
    .i Tbxshid="Y" s Tbxsh="必须审核"
    .i Tbxshid="N" s Tbxsh="非必须审核"
    .i Tbxshid="F" s Tbxsh="需求分配"
    .i Tbxshid="E" s Tbxsh="院长审核"
    .d OutputRow
    
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(TRowid,Tlevel,TlevelName,TProDRHidden,TProDRHiddenName,TDate,TTime,TUser,TSHENHEJK,TNetShenheid,TNetShenhe,Tbxsh,Tbxshid,TShjd)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit $$$OK
}

ClassMethod QueryPermissionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryPermissionExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

ClassMethod QueryPermissionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryPermissionExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod getMaxLevel(ProDR)
{
	s maxNum = ""
	&sql(SELECT max(PER_Level) into :maxNum FROM SQLUser.PMP_Permission WHERE PER_Project_DR =:ProDR AND PER_Spare2 = "Y")
	q maxNum+1
}

//获取项目放大镜

Query LookUpPJTDesc(ProDR As %String) As %Library.SQLQuery(CONTAINID = 2, ROWSPEC = "PJT_Rowid:%String,PJT_Desc:%String")
{
SELECT PJT_Rowid,PJT_Desc
 FROM	SQLUser.PMP_Project
 WHERE	((%ALPHAUP PJT_Desc [ %ALPHAUP :ProDR) OR (:ProDR IS NULL)) 
 AND	(PJT_Status = 'Y')
}

Query LookUpPermission(SHENHEQK As %String) As %Query(ROWSPEC = "PERDes:%String,PERRowid:%String")
{
}

//张枕平 2015-01-06

//获取审核下拉列表

//d ##class(%ResultSet).RunQuery("web.PMPPermission","LookUpPermission","")

ClassMethod LookUpPermissionExecute(ByRef qHandle As %Binary, SHENHEQK As %String) As %Status
{
	Set repid=$I(^CacheTemp)
    s ind=1 
    s DTYRowid="" f  s DTYRowid=$o(^PMPDictionary(DTYRowid)) q:DTYRowid=""  d
    .q:(DTYRowid="FLAG")||(DTYRowid="flagdesc")
    .s DTYflag=$p(^PMPDictionary(DTYRowid),"^",3)
    .q:DTYflag'="Improvement"
    .s DTYdesc=$p(^PMPDictionary(DTYRowid),"^",2)
    .q:(DTYdesc="保存")||(DTYdesc="提交")
    .Q:(SHENHEQK'="")&(DTYdesc'[SHENHEQK)
    .d OutputRow1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(DTYdesc,DTYRowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit $$$OK
}

ClassMethod LookUpPermissionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpPermissionExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod LookUpPermissionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpPermissionExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

Query SelectTXSH(level As %String) As %Query(ROWSPEC = "ID:%String,Desc:%String")
{
}

//张枕平 2015-01-13

//获取审核下拉列表

//d ##class(%ResultSet).RunQuery("web.PMPPermission","SelectTXSH","1")

ClassMethod SelectTXSHExecute(ByRef qHandle As %Binary, level As %String) As %Status
{
	Set repid=$I(^CacheTemp)
    s ind=1 
    s Rowid=""  f  s Rowid=$o(^PMPPermission(Rowid)) q:(Rowid="")  d 
    .s levelid=$p(^PMPPermission(Rowid),"^",3)
    .q:$p(^PMPPermission(Rowid),"^",5)="N"
    .q:levelid<=level
    .s ID=Rowid
    .s Desc=$p(^PMPPermission(Rowid),"^",2)
    .d OutputRow2
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow2
	set Data=$lb(ID,Desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit $$$OK
}

ClassMethod SelectTXSHClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectTXSHExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod SelectTXSHFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectTXSHExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

//s bbb=##class(web.PMPPermission).Shenheid("审核1")

//张枕平 2015-01-13

ClassMethod Shenheid(input As %String) As %String
{
	s ret=""
	q:input="" ret
	s ret=$o(^PMPDictionary(0,"DTY_Desc",input,""))
	q ret
}

/// Creat  zzp  
/// date:2015-05-05
/// description: 检索权限列表
/// input: 
/// output: String 
/// others:d ##class(%ResultSet).RunQuery("web.PMPPermission","PermisQuery","","","")
/// PermisRowid,PermisLiveName,PermisLive,PermisPerName,PermisPerId,PermisCreatDate,PermisCreatTime,PermisUserName,PermisAudit,PermisAuditId,PermisTAudit,PermisTAuditId,PermisMustAu,PermisMustAuId
/// 记录id,        级别名称       级别        项目名称   项目id          创建日期        创建时间         权限用户  审核结果     审核结果id    提醒审核       提醒审核id     必须审核    必须审核id
Query PermisQuery(PerName As %String, PerSName As %String, PerLive) As %Query(ROWSPEC = "PermisRowid:%String,PermisLiveName:%String,PermisLive:%String,PermisPerName:%String,PermisPerId:%String,PermisCreatDate:%String,PermisCreatTime:%String,PermisUserName:%String,PermisAudit:%String,PermisAuditId:%String,PermisTAudit:%String,PermisTAuditId:%String,PermisMustAu:%String,PermisMustAuId:%String") [ SqlProc ]
{
}

ClassMethod PermisQueryExecute(ByRef qHandle As %Binary, PerName As %String, PerSName As %String, PerLive) As %Status
{
	s ^zzp("1234")="12"
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
    s ind=1
    k ^CacheTemp("PermisQueryUser",$j)
    i PerName'="" s PerName=##class(web.DHCINSUPort).GetCNCODE($tr(PerName," "),4,"")  //项目名称
    i PerSName'="" s PerSName=##class(web.DHCINSUPort).GetCNCODE($tr(PerSName," "),4,"")  //权限名称
    i PerLive'="" s PerLive=##class(web.DHCINSUPort).GetCNCODE($tr(PerLive," "),4,"")  //权限级别
    s PermisRowid=""  f  s PermisRowid=$o(^PMPPermission(PermisRowid)) q:(PermisRowid="")  d
    .s (PermisLiveName,PermisLive,PermisPerName,PermisPerId,PermisCreatDate,PermisCreatTime,PermisUserName,PermisAudit,PermisAuditId,PermisTAudit,PermisTAuditId,PermisMustAu,PermisMustAuId)=""
    .q:$p(^PMPPermission(PermisRowid),"^",5)'="Y" //删除操作的隐藏元素
    .s PermisLiveName=$p(^PMPPermission(PermisRowid),"^",2)
    .q:PermisLiveName=""
    .s PerDescStr=##class(web.DHCINSUPort).GetCNCODE($tr(PermisLiveName," "),4,"")_PermisLiveName
    .q:(PerSName'="")&(PerDescStr'[PerSName)
    .s PermisLive=$p(^PMPPermission(PermisRowid),"^",3)
    .q:(PerLive'="")&(PermisLive'[PerLive)
    .s PermisPerId=$p(^PMPPermission(PermisRowid),"^",4)
    .i PermisPerId'="" s PermisPerName=$p(^PMPProject(PermisPerId),"^",2) //项目描述
    .s PermisCreatDate=$p(^PMPPermission(PermisRowid),"^",1)
    .i PermisCreatDate'="" s PermisCreatDate=$zd(PermisCreatDate,3)
    .s PermisCreatTime=$p(^PMPPermission(PermisRowid),"^",10)
    .i PermisCreatTime'="" s PermisCreatTime=$zt(PermisCreatTime)
    .s PerSub="" f  s PerSub=$o(^PMPPermisBusiness(PermisRowid,"E",PerSub)) q:PerSub=""  d
    ..q:$p(^PMPPermisBusiness(PermisRowid,"E",PerSub),"^",3)'="Y"
    ..S UserId=$p(^PMPPermisBusiness(PermisRowid,"E",PerSub),"^",4)
    ..q:UserId=""
    ..s UserName=$p(^SSU("SSUSR",UserId),"^",2)
    ..i '$d(^CacheTemp("PermisQueryUser",$j,UserId))   d
    ...s ^CacheTemp("PermisQueryUser",$j,UserId)=""
    ...i PermisUserName'="" s PermisUserName=PermisUserName_","_UserName
    ...i PermisUserName="" s PermisUserName=UserName
    .s PermisAuditId=$p(^PMPPermission(PermisRowid),"^",6)
    .i PermisAuditId'="" s PermisAudit=$p(^PMPDictionary(PermisAuditId),"^",2)
    .s PermisTAuditId=$p(^PMPPermission(PermisRowid),"^",7)
    .i PermisTAuditId'="" s PermisTAudit=$p(^PMPPermission(PermisTAuditId),"^",2)
    .s PermisMustAuId=$p(^PMPPermission(PermisRowid),"^",8)
    .i PermisMustAuId'="" s PermisMustAu=$SELECT(PermisMustAuId="Y":"必须审核",PermisMustAuId="N":"非必须审核",PermisMustAuId="F":"需求分配",PermisMustAuId="E":"院长审核")
    .d OutputRowPermisQuery
    k ^CacheTemp("PermisQueryUser",$j)
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowPermisQuery
    s Data=$lb(PermisRowid,PermisLiveName,PermisLive,PermisPerName,PermisPerId,PermisCreatDate,PermisCreatTime,PermisUserName,PermisAudit,PermisAuditId,PermisTAudit,PermisTAuditId,PermisMustAu,PermisMustAuId)
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
    Quit
}

ClassMethod PermisQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PermisQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod PermisQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PermisQueryExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

}
