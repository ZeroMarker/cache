Import SQLUser

/// 名称:系统管理  - 安全组子表 医院
/// 描述:包含增删改查功能
/// 编写者:基础数据平台组 -陈莹
/// 编写日期:2014-3-13
Class web.DHCBL.CT.SSGroupHospitals Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator:陈莹
/// CreatDate:2014-3-13
/// Description:查询 医院
/// Table:User.web.DHCBL.CT.SSGroupHospitals
/// Input:ssgrprowid(父表SSGroup的id),rowid
/// Return:HOSPParRef,HOSPRowId,HOSPHospitalDR
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.SSGroupHospitals","GetList","1","","")
Query GetList(ssgrprowid As %String, rowid As %String, cthospital As %String) As %Query(ROWSPEC = "HOSPParRef:%String,HOSPRowId:%String,HOSPHospitalDR:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, ssgrprowid As %String, rowid As %String, cthospital As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	
	if (rowid'="")
	{
		s SSGRPRowId=$p(rowid,"||",1)
		s HOSPChildsub=$p(rowid,"||",2)
		s HOSPRowId=rowid
		s HOSPParRef=SSGRPRowId
		s CTHospitalDR=$P($g(^SSU("SSGRP",SSGRPRowId,"HOSP",HOSPChildsub)),"^",1)
		i CTHospitalDR'="" {
			s HOSPHospitalDR=$p($g(^CT("HOSP",CTHospitalDR)),"^",2)
		}
		else {
			s HOSPHospitalDR=""
		}
		d OutputRow
	}
	else
	{
		if (ssgrprowid)
		{
		s SSGRPRowId=ssgrprowid,HOSPChildsub=0
		for
		{
			s HOSPChildsub=$o(^SSU("SSGRP",SSGRPRowId,"HOSP",HOSPChildsub)) q:HOSPChildsub=""
			s HOSPRowId=SSGRPRowId_"||"_HOSPChildsub
			s HOSPParRef=ssgrprowid
			s CTHospitalDR=$P($g(^SSU("SSGRP",SSGRPRowId,"HOSP",HOSPChildsub)),"^",1)
			i CTHospitalDR'="" {
				s HOSPHospitalDR=$p($g(^CT("HOSP",CTHospitalDR)),"^",2)
			}
			else {
				s HOSPHospitalDR=""
			}
			i (HOSPChildsub>0)&((CTHospitalDR=cthospital)||(cthospital="")) 
			{
				d OutputRow
			}
		}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(HOSPParRef,HOSPRowId,HOSPHospitalDR)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
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

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:陈莹
/// CreatDate:2014-3-13
/// Description:双击修改时,从后台取数据
/// Table:User.SSGroupHospitals
/// Input:id
/// Return:Json格式的字符串str={list:[HOSPParRef,HOSPRowId,HOSPHospitalDR]}
/// Other:w ##class(web.DHCBL.CT.SSGroupHospitals).OpenData("1||7")
ClassMethod OpenData(id As %String) As %String
{
	s str=""
	s pobj = ##class(User.SSGroupHospitals).%OpenId(id)
	s eobj = ##class(web.Entity.CT.SSGroupHospitals).%New()
	s eobj.HOSPRowId = id
	s eobj.HOSPParRef = $p(id,"||",1)
	//if $IsObject(pobj.HOSPHospitalDR){
	//	s eobj.HOSPHospitalDR = pobj.HOSPHospitalDR.%Id() 
	//	}
	s eobj.HOSPHospitalDR=$P($g(^SSU("SSGRP",$p(id,"||",1),"HOSP",$p(id,"||",2))),"^",1)
	d pobj.%Close()
	k pobj
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

/// 用作调试增改功能
ClassMethod SaveTest() As %String
{
	;W ##class(web.DHCBL.CT.SSGroupHospitals).SaveTest()
	s eobj = ##class(web.Entity.CT.SSGroupHospitals).%New()
	s eobj.HOSPParRef="1"
	s eobj.HOSPRowId="1||2"
	s eobj.HOSPHospitalDR="3"
	s M="SSS"
	S M=..SaveEntity(eobj)
	Q M
}

/// Creator:陈莹
/// CreatDate:2014-3-13
/// Description:增加/修改 医院
/// Table:User.SSGroupHospitals
/// Input:web.Entity.CT.SSGroupHospitals
/// Return:成功返回success:'true'和id;失败返回success:'false'和errorinfo
ClassMethod SaveEntity(eobj As web.Entity.CT.SSGroupHospitals) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		
		s flag=..FormValidate(eobj.HOSPRowId,eobj.HOSPParRef,eobj.HOSPHospitalDR)
		if (flag=1)
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		//如果RowId未赋值则增加
		if (eobj.HOSPRowId="")
		{
			s obj = ##class(User.SSGroupHospitals).%New(eobj.HOSPParRef)
		}
		else     //如果RowId已赋值则修改       
		{
			
			s obj = ##class(User.SSGroupHospitals).%OpenId(eobj.HOSPRowId)
			s bobj = ##class(web.Entity.CT.SSGroupHospitals).%New()
			s bobj.HOSPRowId = eobj.HOSPRowId  
			s bobj.HOSPParRef=$p(eobj.HOSPRowId ,"||",1)
			//if $IsObject(obj.HOSPHospitalDR){
			//	s bobj.HOSPHospitalDR = obj.HOSPHospitalDR.%Id() 
			//}
			s bobj.HOSPHospitalDR=$P($g(^SSU("SSGRP",$p(eobj.HOSPRowId,"||",1),"HOSP",$p(eobj.HOSPRowId,"||",2))),"^",1)
		}
		
				
		d obj.HOSPParRefSetObjectId(eobj.HOSPParRef)
		d obj.HOSPHospitalDRSetObjectId(eobj.HOSPHospitalDR)
		s SSGRPDesc="",HOSPDesc=""
		s:eobj.HOSPParRef'="" SSGRPDesc=$p($g(^SSU("SSGRP",eobj.HOSPParRef)),"^",1)
		s:eobj.HOSPHospitalDR'="" HOSPDesc=$p($g(^CT("HOSP",eobj.HOSPHospitalDR)),"^",2)
		
		Tstart
		s sc=obj.%Save()
		do obj.%Close()
		if $$$ISOK(sc){
			Tcommit
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			d:eobj.HOSPRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("SS_GroupHospitals","User.SSGroupHospitals","安全组-医院",id,SSGRPDesc_"->"_HOSPDesc,"A",eobj)
			d:eobj.HOSPRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("SS_GroupHospitals","User.SSGroupHospitals","安全组-医院",id,SSGRPDesc_"->"_HOSPDesc,"U",eobj,bobj)
		}else{
			Trollback
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("安全组-医院","web.DHCBL.CT.SSGroupHospitals","SaveEntity",eobj)
			s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
		}	
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

/// Creator：陈莹
/// CreatDate: 2014-3-13
/// Description：根据id删除 医院
/// Table：User.SSGroup
/// Input：id 
/// Return：成功返回true和info，失败返回false和info
ClassMethod DeleteData(id As %String) As %String
{
	s result=""
	s pobj = ##class(User.SSGroupHospitals).%OpenId(id)
	s eobj = ##class(web.Entity.CT.SSGroupHospitals).%New()
	s eobj.HOSPRowId = id
	s eobj.HOSPParRef = $p(id,"||",1)
	s eobj.HOSPHospitalDR=$P($g(^SSU("SSGRP",$p(id,"||",1),"HOSP",$p(id,"||",2))),"^",1)
	//if $IsObject(pobj.HOSPHospitalDR){
	//	s eobj.HOSPHospitalDR = pobj.HOSPHospitalDR.%Id() 
	//}
	s SSGRPDesc=$p($g(^SSU("SSGRP",eobj.HOSPParRef)),"^",1)
	S HOSPDesc=""
	s:eobj.HOSPHospitalDR="" HOSPDesc=$p($g(^CT("HOSP",eobj.HOSPHospitalDR)),"^",2)
	d pobj.%Close()
	k pobj
	Tstart
	s sc=##class(User.SSGroupHospitals).%DeleteId(id)
	IF $$$ISOK(sc){
		Tc
		s result="{success:'true',info:'删除成功！'}"
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("SS_GroupHospitals","User.SSGroupHospitals","安全组-医院",id,SSGRPDesc_"->"_HOSPDesc,"D",eobj)
	}
	else{
		Trollback
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("安全组-医院","web.DHCBL.CT.SSGroupHospitals","DeleteData",eobj)
	   	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	}
	q result
}

/// Function:用于实现数据校验功能的方法
/// Creator:基础数据平台组 陈莹
/// CreateDate:2023-04-19
/// w ##class(web.DHCBL.CT.SSGroupHospitals).FormValidate("","","")
ClassMethod FormValidate(id As %String, parref As %String, hospitaldr As %String) As %String
{
	s flag=0
	if hospitaldr'=""
	{
		if id'="" s parref=$p(id,"||",1)
		q:parref="" 0
		s sub=$o(^SSU("SSGRP",parref,"HOSP",0,"Hosp",hospitaldr,0))
		if (sub'="")&&(sub'=$p(id,"||",2))
		{
			s flag=1
		}
	}
	q flag
}

}
