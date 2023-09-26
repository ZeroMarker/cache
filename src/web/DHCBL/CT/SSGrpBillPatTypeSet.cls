/// Creator：      陈莹
/// CreatDate：    2014-12-15
/// Description:： 安全组与病人类型配置
Class web.DHCBL.CT.SSGrpBillPatTypeSet Extends %RegisteredObject [ Not ProcedureBlock ]
{

//2009-8-4 add drpDr,drpTypeDr web.DHCIPBillPatTypeSet

/// web.DHCIPBillPatTypeSet.cls
/// Creator：      Lid
/// CreatDate：    2008-10-30
/// Description:   查询结果
/// Table：        DHC_JFSSGrpAdmReasonConfig，SS_Group，PAC_AdmReason
/// Input：        UserGrp:安全组ID     
/// Return：       rowid:RowID,grp:安全组,PatType:病人费用类型,Default:默认值
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.SSGrpBillPatTypeSet","FindGrpPatType","1")
Query FindGrpPatType(UserGrp As %String) As %Query(ROWSPEC = "rowid:%String,grp:%String,PatType:%String,Default:%String,billNotPrintFlag:%String")
{
}

ClassMethod FindGrpPatTypeExecute(ByRef qHandle As %Binary, UserGrp As %String) As %Status
{
	;w ##class(%ResultSet).RunQuery("web.DHCIPBillPatTypeSet","FindGrpPatType","1")
	S repid=$I(^CacheTemp)
	s ind=1,grpIn=""
	s GrpRowId=0,num=0
	i UserGrp=""
	{
		for  
		{
			s GrpRowId=$o(^DHCJFSSGRPADMREASONCONFIG(GrpRowId)) q:GrpRowId=""
			s drpDr=$p(^DHCJFSSGRPADMREASONCONFIG(GrpRowId),"^",1)
			s patTypeDr=$p(^DHCJFSSGRPADMREASONCONFIG(GrpRowId),"^",2)
			s rowid=GrpRowId
			s grp=$P($g(^SSU("SSGRP",drpDr)),"^",1)
			s PatType=""
			s:patTypeDr'="" PatType=$P($g(^PAC("ADMREA",patTypeDr)),"^",2)
			s Default=$p(^DHCJFSSGRPADMREASONCONFIG(GrpRowId),"^",3)
			s billNotPrintFlag=$p(^DHCJFSSGRPADMREASONCONFIG(GrpRowId),"^",4)
			do OutPut2
		}
	}
	else
	{
		s GrpRowId=""
		for
		{
			s GrpRowId=$o(^DHCJFSSGRPADMREASONCONFIG(GrpRowId),-1) q:(GrpRowId="")
			i ($p(^DHCJFSSGRPADMREASONCONFIG(GrpRowId),"^",1)=UserGrp)
			{
				s drpDr=$p(^DHCJFSSGRPADMREASONCONFIG(GrpRowId),"^",1)
				s patTypeDr=$p(^DHCJFSSGRPADMREASONCONFIG(GrpRowId),"^",2)
				s rowid=GrpRowId
				s grp=$P($g(^SSU("SSGRP",drpDr)),"^",1)
				s PatType=""
				s:patTypeDr'="" PatType=$P($g(^PAC("ADMREA",patTypeDr)),"^",2)
				s Default=$p(^DHCJFSSGRPADMREASONCONFIG(GrpRowId),"^",3)
				s billNotPrintFlag=$p(^DHCJFSSGRPADMREASONCONFIG(GrpRowId),"^",4)
				do OutPut2
			}
		}
	}

	S qHandle=$lb(0,repid,0)
	Q $$$OK
OutPut2
	// 2009-8-4 add drpDr,patTypeDr 
	s Data=$lb(rowid,grp,PatType,Default,billNotPrintFlag)
	S ^CacheTemp(repid,ind)=Data
	S ind=ind+1
	q
}

ClassMethod FindGrpPatTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindGrpPatTypeExecute ]
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

ClassMethod FindGrpPatTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindGrpPatTypeExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator：      陈莹
/// CreatDate：    2014-12-15
/// Description:： 验证所赠记录是否存在
/// Table：        DHC_JFSSGrpAdmReasonConfig
/// Input：        grp:安全组ID，patType:病人类型ID，default:默认值      
/// Return：       rst1 存在返回0，不存在返回1;rst2 是否已经存在默认值
ClassMethod CheckInfo(grp As %Library.String, pattype As %Library.String, default As %Library.String, rowid)
{
	
	;w ##class(web.DHCBL.CT.SSGrpBillPatTypeSet).CheckInfo("1","1","","")
	n (grp,pattype,default,rowid) 
	if (default="true")||(default=1) S default="Y"
	if (default="false") S default="N"
	s rst1=0,rst2=0
	//判断记录是否存在
	//判断是否已存在默认
	s ID=0
	for
	{
		s ID=$o(^DHCJFSSGRPADMREASONCONFIG(ID)) q:(ID="")
		s GrpID=$p(^DHCJFSSGRPADMREASONCONFIG(ID),"^",1)
		S PatID=$p(^DHCJFSSGRPADMREASONCONFIG(ID),"^",2)
		i (GrpID=grp)&&(PatID=pattype)&&(((ID'=rowid)&(rowid'=""))||(rowid=""))
		{
			s rst1=1
		}
		
		i ((rst1'=1)&(default="Y"))
		{
			i (GrpID=grp)
			{
				s def=$p(^DHCJFSSGRPADMREASONCONFIG(ID),"^",3)
				i (def="Y")&&(((ID'=rowid)&(rowid'=""))||(rowid=""))  s rst2=1
			}
		}
	}
	q rst1_"^"_rst2
}

/// Creator：      CHENYING
/// CreatDate：    2015-3-16
/// Description:： 更新表DHC_JFSSGrpAdmReasonConfig
/// Table：        DHC_JFSSGrpAdmReasonConfig
/// Input：        ObjRoeId:DHC_JFSSGrpAdmReasonConfig表rowid,grp:安全组desc，patType:病人类型desc，default:默认值,billNotPrintFlag:不打印标志     
/// Return：       SQLCODE
ClassMethod SaveInfo(rowid As %Library.String, Grp As %Library.String, PatType As %Library.String, Default As %Library.String, billNotPrintFlag As %Library.String)
{
   //&sql(update DHC_JFSSGrpAdmReasonConfig set GrpRea_SSGrp_Dr=:Grp,GrpRea_AdmReason_Dr=:PatType,GrpRea_DefaultAdmReason=:Default,GrpRea_Comment1=:billNotPrintFlag where GrpRea_RowId=:rowid)
	s result=""
	s:Default="" Default="N"
	s:billNotPrintFlag="" billNotPrintFlag="N"
	
	s eobj = ##class(web.Entity.CT.DHCJFSSGrpAdmReasonConfig).%New()
	s eobj.GrpReaRowId = rowid
	s eobj.GrpReaSSGrpDr=Grp
	s eobj.GrpReaAdmReasonDr=PatType
	s eobj.GrpReaDefaultAdmReason=Default
	s eobj.GrpReaComment1=billNotPrintFlag
	
	if (rowid="") //如果RowId未赋值则增加
	{
	       
		s obj=##class(User.DHCJFSSGrpAdmReasonConfig).%New()
	    
	}
	ELSE
	{
		s obj=##class(User.DHCJFSSGrpAdmReasonConfig).%OpenId(rowid)	
		s bobj = ##class(web.Entity.CT.DHCJFSSGrpAdmReasonConfig).%New()
		s bobj.GrpReaRowId = rowid
		if $IsObject(obj.GrpReaSSGrpDr){
			s bobj.GrpReaSSGrpDr = obj.GrpReaSSGrpDr.%Id() 
		}
		if $IsObject(obj.GrpReaAdmReasonDr){
			s bobj.GrpReaAdmReasonDr = obj.GrpReaAdmReasonDr.%Id() 
		}
	    s bobj.GrpReaDefaultAdmReason=obj.GrpReaDefaultAdmReason
	    s bobj.GrpReaComment1=obj.GrpReaComment1
		
	} 
    d obj.GrpReaSSGrpDrSetObjectId(Grp)
    d obj.GrpReaAdmReasonDrSetObjectId(PatType)
    s obj.GrpReaDefaultAdmReason=Default
    s obj.GrpReaComment1=billNotPrintFlag
   
	s pattypedesc=""
	s:PatType'="" pattypedesc=$P($g(^PAC("ADMREA",PatType)),"^",2)	  	
	Ts
	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc){
		Tc
		s id = obj.%Id()
		s result = "{success:'true',id:'"_id_"'}"
		d:rowid="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_JFSSGrpAdmReasonConfig","User.DHCJFSSGrpAdmReasonConfig","安全组与病人类型配置",id,pattypedesc,"A",eobj)
		d:rowid'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_JFSSGrpAdmReasonConfig","User.DHCJFSSGrpAdmReasonConfig","安全组与病人类型配置",id,pattypedesc,"U",eobj,bobj)
	
	}else{
		Trollback
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("安全组与病人类型配置","web.DHCBL.CT.SSGrpBillPatTypeSet","SaveInfo",eobj)
   		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
	}				
			
	
	q result
}

/// Other:d ##class(web.DHCBL.CT.SSGrpBillPatTypeSet).DelInfo("1")
ClassMethod DelInfo(rowid As %String) As %String
{
	/// Import SQLUser &sql(delete from  DHC_JFSSGrpAdmReasonConfig where GrpRea_RowId=:rowid)
	s result=""
	
	s pobj = ##class(User.DHCJFSSGrpAdmReasonConfig).%OpenId(rowid)
	s eobj = ##class(web.Entity.CT.DHCJFSSGrpAdmReasonConfig).%New()
	s eobj.GrpReaRowId = rowid
	s eobj.GrpReaDefaultAdmReason = pobj.GrpReaDefaultAdmReason
	s eobj.GrpReaComment1 = pobj.GrpReaComment1
	if $IsObject(pobj.GrpReaSSGrpDr){
		s eobj.GrpReaSSGrpDr = pobj.GrpReaSSGrpDr.%Id() 
		}
	if $IsObject(pobj.GrpReaAdmReasonDr){
		s eobj.GrpReaAdmReasonDr = pobj.GrpReaAdmReasonDr.%Id() 
		}
		
	s pattypedesc=""
	s:pobj.GrpReaAdmReasonDr'="" pattypedesc=$P($g(^PAC("ADMREA",eobj.GrpReaAdmReasonDr)),"^",2)	 
	d pobj.%Close()
	k pobj
	Tstart
	s sc=##class(User.DHCJFSSGrpAdmReasonConfig).%DeleteId(rowid)
	if $$$ISOK(sc){
		Tcommit
		s result="{success:'true',info:'删除成功！'}"
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_JFSSGrpAdmReasonConfig","User.DHCJFSSGrpAdmReasonConfig","安全组与病人类型配置",rowid,pattypedesc,"D",eobj)
	}
	else{
		Trollback
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("安全组与病人类型配置","web.DHCBL.CT.SSGrpBillPatTypeSet","DelInfo",eobj)
	   	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	}
	
	q result
}

ClassMethod OpenData(rowid) As %String
{
	s str ="",grp="",PatType="",Default=""
	s GrpRowId=rowid
	
	s drpDr=$p(^DHCJFSSGRPADMREASONCONFIG(GrpRowId),"^",1)
	s:drpDr'="" grp=$P($g(^SSU("SSGRP",drpDr)),"^",1)
  	s patTypeDr=$p(^DHCJFSSGRPADMREASONCONFIG(GrpRowId),"^",2)
  	s Default=$p(^DHCJFSSGRPADMREASONCONFIG(GrpRowId),"^",3)
  	s billNotPrintFlag=$p(^DHCJFSSGRPADMREASONCONFIG(GrpRowId),"^",4)
	s:Default="Y" Default="true"
	s:billNotPrintFlag="Y" billNotPrintFlag="true"
	s str="{rowid:"""_GrpRowId_""",grp:"""_grp_""",PatType:"""_patTypeDr_""",billNotPrintFlag:"""_billNotPrintFlag_""",Default:"""_Default_"""}"
	s str = "{list:["_str_"]}"
	q str
}

}
