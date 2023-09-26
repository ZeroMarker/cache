/// 名称: 医嘱项医院关联
/// 描述: 业务类 
/// 编写者：基础数据平台组-sunfengchao
/// 编写日期: 2014-10-20
Class web.DHCBL.CT.ARCItemHosp Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Function: 查询医嘱项关联医院
/// Creator:  sunfengchao
/// CreateDate: 2014-10-20
/// Table: ARC_ItemHosp 
/// Input: ParRef  13397||1 
/// Output: HOSPHospitalDR
/// Debug: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.ARCItemHosp","GetList","13397||1")
Query GetList(ParRef As %String) As %Query(ROWSPEC = "HOSPRowId:%String,HOSPHospitalDR:%String,HospDr:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, ParRef As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1  ;  ^ARCIM(13397,1,"HOSP",1) = 46 

	s parref=$p(ParRef,"||",1)
	s version=$p(ParRef,"||",2)
	s childsub=0  
	f  s childsub=$o(^ARCIM(parref,version,"HOSP",childsub)) q:childsub=""  d
	.s HOSPRowId=parref_"||"_version_"||"_childsub
	.s HOSPHospitalDR=$p($g(^ARCIM(parref,version,"HOSP",childsub)),"^",1) q:(HOSPHospitalDR="")||(HOSPHospitalDR=0)
	.s:HOSPHospitalDR'="" HospDr=HOSPHospitalDR
	.s:HOSPHospitalDR="" HospDr=""
	.s:HOSPHospitalDR'="" HOSPHospitalDR=$p($g(^CT("HOSP",HOSPHospitalDR)),"^",2)
	.d OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(HOSPRowId,HOSPHospitalDR,HospDr)
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

/// Function: 删除医嘱项对应的医院数据
/// CreateDate:2014-10-20
/// Creator: sunfengchao
/// Table:  ARC_ItemHosp
/// Debug:  d ##class(web.DHCBL.CT.ARCItemHosp).DeleteData("")
ClassMethod DeleteData(rowid As %String) As %String
{
	n (rowid,%session)
	Quit:rowid="" "{success:'false',info:'未选择医嘱项医院,不能删除!'}"

	//用于保存日志
	s obj = ##class(User.ARCItemHosp).%OpenId(rowid)
	s eobj = ##class(web.Entity.CT.ARCItemHosp).%New()
	s eobj.HOSPRowId=rowid
	s eobj.HOSPParRef=$p(rowid,"||",1)_"||"_$p(rowid,"||",2)
	s:obj.HOSPHospitalDR'="" eobj.HOSPHospitalDR=obj.HOSPHospitalDR.%Id()

	Tstart
	s sc=##class(User.ARCItemHosp).%DeleteId(rowid)
	If (sc=0) 
	{
		Trollback
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医嘱项医院关联","web.DHCBL.CT.ARCItemHosp","DeleteData",eobj)
		s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		Quit "{success:'false',info:'删除失败, 请重新操作!'}"
	}
	Tc
	//删除时，日志   
	d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ARC_ItemHosp","User.ARCItemHosp","医嘱项医院关联",rowid, eobj.HOSPHospitalDR,"D",eobj)
	d eobj.%Close()
	Quit "{success:'true',info:'删除成功!'}"
}

/// Function:  新增医嘱项关联医院
/// CreateDate: 2014-10-20
/// Creator:   sunfengchao
/// Modified by CHENYING  @2017-3-2
/// Input:医嘱项rowid^医院  
/// Debug:     w ##class(web.DHCBL.CT.ARCItemHosp).AddARCItemHosp("13468||1^7")
ClassMethod AddARCItemHosp(SaveDataStr As %String) As %String
{
   ; 分割 串  
	n (%session,SaveDataStr)
	s eobj = ##class(web.Entity.CT.ARCItemHosp).%New()
	s eobj.HOSPRowId= ""
	s eobj.HOSPParRef=$p(SaveDataStr,"^",1)  
	s eobj.HOSPHospitalDR=$p(SaveDataStr,"^",2) 
	s Result=##class(web.DHCBL.CT.ARCItemHosp).SaveEntity(eobj)
	if Result["success:'true'" s Ret= "{success:'true',info:'保存成功!'}"
	else  s Ret="{success:'false',info:"_$p(Result,"errorinfo:",2)
	q Ret
}

/// Function:  修改医嘱项关联医院的数据
/// CreateDate: 2014-10-20
/// Creator:   sunfengchao
/// Modified by CHENYING  @2017-3-2
/// Input:医嘱项医院rowid^医院 
/// Debug:     w ##class(web.DHCBL.CT.ARCItemHosp).UpdateOrderARCItemHosp("13468||1||13^10")
ClassMethod UpdateOrderARCItemHosp(HospStr As %String) As %String
{
	n (%session,HospStr)
	s eobj = ##class(web.Entity.CT.ARCItemHosp).%New()
	s eobj.HOSPRowId= $p(HospStr,"^",1)
	s eobj.HOSPParRef=$p($p(HospStr,"^",1),"||",1)_"||"_$p($p(HospStr,"^",1),"||",2)
	s eobj.HOSPHospitalDR=$p(HospStr,"^",2) 
	s Result=##class(web.DHCBL.CT.ARCItemHosp).SaveEntity(eobj)
	if Result["success:'true'" s Ret= "{success:'true',info:'保存成功!'}"
	else  s Ret="{success:'false',info:"_$p(Result,"errorinfo:",2)
	q Ret
}

/// Function:  校验医嘱项关联医院
/// CreateDate: 2017-3-2
/// Creator:   陈莹
/// Other:W ##class(web.DHCBL.CT.ARCItemHosp).FormValidate("","","")
ClassMethod FormValidate(id, arcimparref, hosp) As %String
{
	n (id,hosp,arcimparref)
	s hospsub=""
	s parref=$p(arcimparref,"||",1)
  	s version=$p(arcimparref,"||",2) 
	if id'=""
	{
		s parref=$p(id,"||",1)
  		s version=$p(id,"||",2) 
		s hospsub=$p(id,"||",3) 
	}
	s flags="",flag=""
	if (hosp'="")
	{
		s sub=$o(^ARCIM(parref,version,"HOSP",0,"Hosp",hosp,0))
		s flags=$d(^ARCIM(parref,version,"HOSP",0,"Hosp",hosp))
		
		if id=""
		{
			if (flags>0) s flag=1
			else  s flag=0
		}
		else
		{
			if (sub'="")&(sub'=hospsub) s flag=1
			else  s flag=0	
		}	
	}  
	q flag
}

/// Function:  保存医嘱项关联医院的数据
/// CreateDate: 2017-3-2
/// Creator:   陈莹
/// Debug:     w ##class(web.DHCBL.CT.ARCItemHosp).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.CT.ARCItemHosp) As %String
{
	n (%session,eobj)
	if (eobj.HOSPHospitalDR="")
	{
		q "{success:'false',errorinfo:'医院不能为空!'}" 
		
	}
	s flag= ##class(web.DHCBL.CT.ARCItemHosp).FormValidate(eobj.HOSPRowId,eobj.HOSPParRef,eobj.HOSPHospitalDR)
	if flag=1 q "{success:'false',errorinfo:'该数据已存在!'}" 
	if (eobj.HOSPRowId="")
	{
		s obj=##class(User.ARCItemHosp).%New(eobj.HOSPParRef) 
	}
	else
	{
		s obj=##class(User.ARCItemHosp).%OpenId(eobj.HOSPRowId)
		s bobj = ##class(web.Entity.CT.ARCItemHosp).%New()
		s bobj.HOSPParRef=$p(eobj.HOSPRowId,"||",1)_"||"_$p(eobj.HOSPRowId,"||",2)
		s:obj.HOSPHospitalDR'="" bobj.HOSPHospitalDR=obj.HOSPHospitalDR.%Id() 
	}
	d obj.HOSPParRefSetObjectId(eobj.HOSPParRef)
	d obj.HOSPHospitalDRSetObjectId(eobj.HOSPHospitalDR)
	Set HOSPDesc=""
	Set:eobj.HOSPHospitalDR'="" HOSPDesc=$p($g(^CT("HOSP",eobj.HOSPHospitalDR)),"^",2)


	Tstart
	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc)
	{
		Tc
		s id = obj.%Id()
		s result = "{success:'true',id:'"_id_"'}"
		d:eobj.HOSPRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ARC_ItemHosp","User.ARCItemHosp","医嘱项医院关联",id,HOSPDesc,"A",eobj)
		d:eobj.HOSPRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ARC_ItemHosp","User.ARCItemHosp","医嘱项医院关联",id,HOSPDesc,"U",eobj,bobj)	
	}
	else
	{
		Trollback
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医嘱项医院关联","web.DHCBL.CT.ARCItemHosp","SaveEntity",eobj)
		s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
	}
	q result
}

/// Function: 批量添加 医院信息 
/// Crretaor: 基础数据平台组 sunfengcchao
/// CreateDate: 2014-12-26
/// Debugs:   w ##class(web.DHCBL.CT.ARCItemHosp).MultiAddHosp("","")
/// rowid (医嘱项rowid)
ClassMethod MultiAddHosp(rowid As %String, HospitalAddStr As %String) As %String
{
	n (%session,HospitalAddStr,rowid)
	q:HospitalAddStr="" "{success:'true'}"
	s flag=0,result=""
	if (HospitalAddStr)
	{
		Set HOSPHospitalDR=%session.Get("LOGON.HOSPID")           ; 医院
		s arcimdr=rowid
		s Hosplength=$length(HospitalAddStr,"*")
		for i=1:1:Hosplength 
		{
			s StrAddOrdHosp=$p(HospitalAddStr,"*",i)
			if (StrAddOrdHosp'=HOSPHospitalDR) 
			{
				s result= ##class(web.DHCBL.CT.ARCItemHosp).AddARCItemHosp(arcimdr_"^"_StrAddOrdHosp)
			} 
			if result["success:'false'" s flag=1
		}
	}
	if (flag=0)
	{
		s result= "{success:'true',info:'医嘱项添加成功! 关联医院成功!'}"
	}
	else
	{
		s result= "{success:'false',info:'医嘱项添加成功! 关联医院失败!'}"	
	}
	q result
}

/// 描述：根据医嘱项ID  返回医嘱项对应的医院代码
/// 编写人：基础数据-likefan
/// 日期：2021-10-29
/// input: 医嘱项ID
/// output: 所有关联医院的代码，用 "^" 拼接
/// debug: w ##class(web.DHCBL.CT.ARCItemHosp).GetARCItemHospCodeByID("")
ClassMethod GetARCItemHospCodeByID(id As %String) As %String
{
	n (id)
	s parref=$p(id,"||",1)
	s version=$p(id,"||",2)
	q:parref="" ""
	q:parref="" ""
	s HospCode=""	//定义返回值
	s childsub=0
	for
	{
		s childsub=$o(^ARCIM(parref,version,"HOSP",childsub)) q:childsub=""
		s HOSPHospitalDR=$p($g(^ARCIM(parref,version,"HOSP",childsub)),"^",1)
		if (HOSPHospitalDR'="")
		{
			s:HospCode'="" HospCode=HospCode_"^"_$p($g(^CT("HOSP",HOSPHospitalDR)),"^",1)	//医院代码
			s:HospCode="" HospCode=$p($g(^CT("HOSP",HOSPHospitalDR)),"^",1)	//医院代码
		}
	}
	q HospCode
}

}
