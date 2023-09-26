/// Creator：陈莹
/// CreatDate: 2014-12-10
/// Description：安全组与押金类型配置web.UDHCJFSSGrpDepTypeSet.cls
Class web.DHCBL.CT.SSGrpDepTypeSet Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：      CHENYING
/// CreatDate：    2015-3-16
/// 查询安全组与押金类型配置 
/// d ##class(%ResultSet).RunQuery("web.UDHCJFSSGrpDepTypeSet","FindGrpDepType","")  
/// Input:UserGrp  安全组id
Query FindGrpDepType(UserGrp As %String) As %Query(ROWSPEC = "rowid:%String,grp:%String,DepType:%String,Default:%String")
{
}

ClassMethod FindGrpDepTypeExecute(ByRef qHandle As %Binary, UserGrp As %String) As %Status
{
  S repid=$I(^CacheTemp)
  s ind=1,grpIn=""
  s GrpRowId=0,num=0
  i UserGrp="" d
  .f  s GrpRowId=$o(^DHCJFSSGRPDEPTYPECONFIG(GrpRowId)) q:GrpRowId=""  d 
  ..s drpDr=$p(^DHCJFSSGRPDEPTYPECONFIG(GrpRowId),"^",1)
  ..s drpTypeDr=$p(^DHCJFSSGRPDEPTYPECONFIG(GrpRowId),"^",2)
  ..s rowid=GrpRowId
  ..s:drpDr'="" grp=$P($g(^SSU("SSGRP",drpDr)),"^",1)   ///modified by chenying 2014-12-10
  ..s DepType=""
  ..s:drpTypeDr'="" DepType=$P($g(^ARC("ARCDT",drpTypeDr)),"^",2)
  ..s Default=$p(^DHCJFSSGRPDEPTYPECONFIG(GrpRowId),"^",3)
  ..do OutPut2
  e  d
  .s GrpRowId=""
  .f  s GrpRowId=$o(^DHCJFSSGRPDEPTYPECONFIG(0,"Grp",UserGrp,GrpRowId)) q:GrpRowId=""  d 
  ..s rowid=GrpRowId   ///modified by chenying ,2014-12-10
  ..s drpDr=$p(^DHCJFSSGRPDEPTYPECONFIG(GrpRowId),"^",1)
  ..s drpTypeDr=$p(^DHCJFSSGRPDEPTYPECONFIG(GrpRowId),"^",2)
  ..s:drpDr'="" grp=$P($g(^SSU("SSGRP",drpDr)),"^",1)   ///modified by chenying 2014-12-10
  ..s DepType=""
  ..s:drpTypeDr'="" DepType=$P($g(^ARC("ARCDT",drpTypeDr)),"^",2)
  ..s Default=$p(^DHCJFSSGRPDEPTYPECONFIG(GrpRowId),"^",3)
  ..do OutPut2
	  
  S qHandle=$lb(0,repid,0)
  Q $$$OK
OutPut2 
    s Data=$lb(rowid,grp,DepType,Default)
 	S ^CacheTemp(repid,ind)=Data
 	S ind=ind+1
	q
}

ClassMethod FindGrpDepTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindGrpDepTypeExecute ]
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

ClassMethod FindGrpDepTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindGrpDepTypeExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator：      CHENYING
/// CreatDate：    2015-3-16
/// Description:： 更新表DHC_JFSSGrpDepTypeConfig
/// Table：        DHC_JFSSGrpDepTypeConfig
/// Input：        ObjRoeId:DHC_JFSSGrpDepTypeConfig表rowid,grp:安全组desc，DepType:押金类型desc，default:默认值  
/// Return：       SQLCODE
ClassMethod SaveInfo(rowid As %Library.String, Grp As %Library.String, DepType As %Library.String, Default As %Library.String)
{
	 s result=""
	s:Default="" Default="N"
	
	s eobj = ##class(web.Entity.CT.DHCJFSSGrpDepTypeConfig).%New()
	s eobj.GrpRowId = rowid
	s eobj.GrpDr=Grp
	s eobj.GrpDepTypeDr=DepType
	s eobj.GrpDefault=Default
	
	if (rowid="") //如果RowId未赋值则增加
	{
	       
		s obj=##class(User.DHCJFSSGrpDepTypeConfig).%New()
	    d obj.GrpDrSetObjectId(Grp)
	    d obj.GrpDepTypeDrSetObjectId(DepType)
	    s obj.GrpDefault=Default
	   
		s deptypedesc=""
		s:DepType'="" deptypedesc=$P($g(^ARC("ARCDT",DepType)),"^",2) 	
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc){
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_JFSSGrpDepTypeConfig","User.DHCJFSSGrpDepTypeConfig","安全组与押金类型配置",id,deptypedesc,"A",eobj)
		}else{
			Trollback
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("安全组与押金类型配置","web.DHCBL.CT.SSGrpDepTypeSet","SaveInfo",eobj)
	   		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
		}				
			
	}
	else //如果RowId已赋值则修改
	{
		s obj=##class(User.DHCJFSSGrpDepTypeConfig).%OpenId(rowid)	
		s bobj = ##class(web.Entity.CT.DHCJFSSGrpDepTypeConfig).%New()
		s bobj.GrpRowId = rowid
		if $IsObject(obj.GrpDr){
			s bobj.GrpDr = obj.GrpDr.%Id() 
		}
		if $IsObject(obj.GrpDepTypeDr){
			s bobj.GrpDepTypeDr = obj.GrpDepTypeDr.%Id() 
		}
	    s bobj.GrpDefault=obj.GrpDefault
		
		
	    d obj.GrpDrSetObjectId(Grp)
	    d obj.GrpDepTypeDrSetObjectId(DepType)
	    s obj.GrpDefault=Default
	   
		s deptypedesc=""
		s:DepType'="" deptypedesc=$P($g(^ARC("ARCDT",DepType)),"^",2) 	 	
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc){
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_JFSSGrpDepTypeConfig","User.DHCJFSSGrpDepTypeConfig","安全组与押金类型配置",id,deptypedesc,"U",eobj,bobj)
		}else{
			Trollback
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("安全组与押金类型配置","web.DHCBL.CT.SSGrpDepTypeSet","SaveInfo",eobj)
	   		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
		}
	}	
	q result
}

/// Other:d ##class(web.DHCBL.CT.SSGrpBillPatTypeSet).DelInfo("1")
ClassMethod DelInfo(rowid As %String) As %String
{
	/// Import SQLUser &sql(delete from  DHC_JFSSGrpDepTypeConfig where Grp_RowId=:rowid)
	s result=""
	
	s pobj = ##class(User.DHCJFSSGrpDepTypeConfig).%OpenId(rowid)
	s eobj = ##class(web.Entity.CT.DHCJFSSGrpDepTypeConfig).%New()
	s eobj.GrpRowId = rowid
	s eobj.GrpDefault = pobj.GrpDefault
	if $IsObject(pobj.GrpDr){
		s eobj.GrpDr = pobj.GrpDr.%Id() 
		}
	if $IsObject(pobj.GrpDepTypeDr){
		s eobj.GrpDepTypeDr = pobj.GrpDepTypeDr.%Id() 
		}
		
	s deptypedesc=""
	s:eobj.GrpDepTypeDr'="" deptypedesc=$P($g(^ARC("ARCDT",eobj.GrpDepTypeDr)),"^",2) 	
			 
	d pobj.%Close()
	k pobj
	Tstart
	s sc=##class(User.DHCJFSSGrpDepTypeConfig).%DeleteId(rowid)
	if $$$ISOK(sc){
		Tcommit
		s result="{success:'true',info:'删除成功！'}"
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_JFSSGrpDepTypeConfig","User.DHCJFSSGrpDepTypeConfig","安全组与押金类型配置",rowid,deptypedesc,"D",eobj)
	}
	else{
		Trollback
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("安全组与押金类型配置","web.DHCBL.CT.SSGrpDepTypeSet","DelInfo",eobj)
	   	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	}
	
	q result
}

ClassMethod OpenData(rowid) As %String
{
	s str ="",grp="",DepType="",Default=""
	s GrpRowId=rowid
  	s drpDr=$p($g(^DHCJFSSGRPDEPTYPECONFIG(GrpRowId)),"^",1)
 	s depTypeDr=$p($g(^DHCJFSSGRPDEPTYPECONFIG(GrpRowId)),"^",2)
 	s:drpDr'="" grp=$P($g(^SSU("SSGRP",drpDr)),"^",1)
 	s DepType=""
  	s:depTypeDr'="" DepType=$P($g(^ARC("ARCDT",depTypeDr)),"^",2)
 	s Default=$p($g(^DHCJFSSGRPDEPTYPECONFIG(GrpRowId)),"^",3)
 	s:Default="Y" Default="true"
 	
	s str="{rowid:"""_GrpRowId_""",grp:"""_grp_""",DepType:"""_depTypeDr_""",Default:"""_Default_"""}"
	s str = "{list:["_str_"]}"
	q str
}

/// Creator：      陈莹
/// CreatDate：    2014-12-15
/// Description:： 验证所赠记录是否存在
/// Table：        DHC_JFSSGrpDepTypeConfig
/// Input：        grp:安全组ID，patType:病人类型ID，default:默认值      
/// Return：       存在返回1，不存在返回0
/// w ##class(web.DHCBL.CT.SSGrpDepTypeSet).CheckInfo(2,7,1,31)
ClassMethod CheckInfo(grp As %Library.String, deptype As %Library.String, default As %Library.String, rowid)
{
	
	;w ##class(web.DHCBL.CT.SSGrpDepTypeSet).CheckInfo("1","1","","")
  	n (grp,deptype,default,rowid) 
 	S rst1=0,rst2=0
 	if (default="true")||(default=1) S default="Y"

	//判断记录是否存在
	//判断是否已存在默认
	s ID=0
	for
	{
 		s ID=$o(^DHCJFSSGRPDEPTYPECONFIG(ID)) q:(ID="")
 		s GrpID=$p(^DHCJFSSGRPDEPTYPECONFIG(ID),"^",1)
 		s DepID=$p(^DHCJFSSGRPDEPTYPECONFIG(ID),"^",2)
		i (GrpID=grp)&(DepID=deptype)&&(((ID'=rowid)&(rowid'=""))||(rowid=""))
		{
			s rst1=1
		}
		i ((rst1'=1)&(default="Y"))
		{
 			i (GrpID=grp)
 			{
	 			s def=$p(^DHCJFSSGRPDEPTYPECONFIG(ID),"^",3)
 				i (def="Y")&&(((ID'=rowid)&(rowid'=""))||(rowid="")) s rst2=1
 			}
		}
	}
  	
	q rst1_"^"_rst2
}

}
