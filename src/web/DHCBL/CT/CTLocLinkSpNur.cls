/// 项目：重庆人民医院，添加专项护理字典维护界面
/// 描述: 对专项护理子表的增删改查
/// 表名：CTLocLinkSpNur
/// 编写者：基础数据平台组 李可凡
/// 编写日期: 2019年8月22日
Class web.DHCBL.CT.CTLocLinkSpNur Extends %RegisteredObject
{

/// Creator：李可凡
/// CreatDate: 2019年9月2日
/// Description：获取专项护理列表
/// Table：User.CTLocLinkSpNur
/// Input：parref(CTLOCRowID),spnurrowid
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTLocLinkSpNur","GetList","","2||1")
Query GetList(parref As %String, spnurrowid As %String) As %Query(ROWSPEC = "SpNurRowId,SpNurParRef,SpNurDR")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, parref As %String, spnurrowid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	if (spnurrowid'="")
	{
		s SpNurRowId=spnurrowid
		s CTLOCRowID=$p(SpNurRowId,"||",1)
		s SpNurChildsub=$p(SpNurRowId,"||",2)
		s SpNurParRef=CTLOCRowID
		s SpNurDR=$p($g(^CTLOC(CTLOCRowID,"SpNur",SpNurChildsub)),"^",1) 
		s:SpNurDR'="" SpNurDR=$lg($g(^User.CTSpecialNursingD(SpNurDR)),3)     //专项护理名
		d OutputRow
	}
	else
	{
		s CTLOCRowID=parref,SpNurChildsub=0
		for
		{
			s SpNurChildsub=$o(^CTLOC(CTLOCRowID,"SpNur",SpNurChildsub)) q:SpNurChildsub=""
			s SpNurRowId=CTLOCRowID_"||"_SpNurChildsub
			s SpNurParRef=parref
			s SpNurDR=$p($g(^CTLOC(CTLOCRowID,"SpNur",SpNurChildsub)),"^",1)
			s:SpNurDR'="" SpNurDR=$lg($g(^User.CTSpecialNursingD(SpNurDR)),3)     //专项护理名
			i (SpNurDR'="")
			{
				d OutputRow
			}
		}
	}
		
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(SpNurRowId,SpNurParRef,SpNurDR)
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

/// Function:用于实现数据校验功能的方法
/// Creator:基础数据平台组 李可凡
/// CreateDate:2019年9月3日    
/// w ##class(web.DHCBL.CT.CTLocLinkSpNur).FormValidate("1||1","1","1")
ClassMethod FormValidate(SpNurRowId As %String, SpNurParRef As %String, SpNurDR As %String) As %String
{
	s flag=0
	s sub=0
	for
	{
		s sub=$o(^CTLOC(SpNurParRef,"SpNur",sub))
		q:sub=""
		s dr=$p($g(^CTLOC(SpNurParRef,"SpNur",sub)),"^",1)
		s id=SpNurParRef_"||"_sub
		if (id'=SpNurRowId)&(dr=SpNurDR) s flag=1
	}
	q flag
}

/// Creator：李可凡
/// CreatDate: 2019年8月27日
/// function：测试对象数据存储
/// debug：d ##class(web.DHCBL.CT.CTLocLinkSpNur).Test()
ClassMethod Test()
{
	s eobj=##class(web.Entity.CT.CTLocLinkSpNur).%New()
	s eobj.SpNurParRef="3"
	s eobj.SpNurRowId=""
	//s eobj.SpNurChildsub=""
	s eobj.SpNurDR="3"
	w ..SaveEntity(eobj)
}

/// Creator：李可凡
/// CreatDate: 2019年9月2日
/// Description：保存专项护理
/// Table：User.CTLocLinkSpNur
/// Input:web.Entity.CT.CTLocLinkSpNur
/// Return:成功返回true和id,失败返回false和errorinfo
/// Other: 
ClassMethod SaveEntity(eobj As web.Entity.CT.CTLocLinkSpNur) As %String
{
	s result=""
	s flag=..FormValidate(eobj.SpNurRowId,eobj.SpNurParRef,eobj.SpNurDR)  //调用重复验证
	if (flag=1)
	{
		s result = "{success:'false',errorinfo:'该记录已经存在！'}"
	}
	else
	{
		if (eobj.SpNurRowId="")  //如果RowId未赋值则增加
		{
			s obj=##class(User.CTLocLinkSpNur).%New(eobj.SpNurParRef)
			d obj.SpNurParRefSetObjectId(eobj.SpNurParRef)
		}
		else                     //如果RowId已赋值则修改
		{
			s obj=##class(User.CTLocLinkSpNur).%OpenId(eobj.SpNurRowId)
			s bobj=##class(web.Entity.CT.CTLocLinkSpNur).%New(eobj.SpNurParRef)
			s bobj.SpNurRowId=eobj.SpNurRowId
			s bobj.SpNurDR=obj.SpNurDR
			s bobj.SpNurParRef=obj.SpNurParRef
		}
		
		d obj.SpNurDRSetObjectId(eobj.SpNurDR)
		
		
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result= "{success:'true',id:'"_id_"'}"         //返回RowId
			s CTLOCDesc=$p($g(^CTLOC(eobj.SpNurParRef)),"^",2)	
			s SpNurDesc=$lg($g(^User.CTSpecialNursingD(eobj.SpNurDR)),3)
			d:eobj.SpNurRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CTLocLinkSpNur","User.CTLocLinkSpNur","专项护理",id,CTLOCDesc_"->"_SpNurDesc,"U",eobj,bobj)
			d:eobj.SpNurRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CTLocLinkSpNur","User.CTLocLinkSpNur","专项护理",id,CTLOCDesc_"->"_SpNurDesc,"A",eobj)
		}
		else
		{
			Trollback
			s result= "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
			s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("专项护理","web.DHCBL.CT.CTLocLinkSpNur","SaveEntity",eobj)
			s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)  
		}
	}
	q result
}

/// Creator：李可凡
/// CreatDate: 2019年9月2日
/// Description：删除专项护理
/// Table：User.CTLocLinkSpNur
/// Input：id
/// Other: d ##class(web.DHCBL.CT.CTLocLinkSpNur).DeleteData("1||2")
ClassMethod DeleteData(id) As %String
{
	s result=""
	
	s eobj = ##class(web.Entity.CT.CTLocLinkSpNur).%New()
	s pobj = ##class(User.CTLocLinkSpNur).%OpenId(id)
	s ParRef=$p($g(id),"||",1)  
	s ChildSub=$p($g(id),"||",2) ///判断为第几个孩子
	s SpNurDR=$p($g(^CTLOC(ParRef,"SpNur",ChildSub)),"^",1)
	S eobj.SpNurRowId = id
	s eobj.SpNurParRef = ParRef
	s eobj.SpNurChildsub = ChildSub
	s eobj.SpNurDR = SpNurDR

	
	TSTART
	s sc = ##class(User.CTLocLinkSpNur).%DeleteId(id)
	if $$$ISOK(sc)
	{
		TCOMMIT
		s result = "{success:'true',info:'删除成功！'}"	
		s:eobj.SpNurParRef'="" CTLOCDesc=$p($g(^CTLOC(eobj.SpNurParRef)),"^",2)       //科室名
		s:eobj.SpNurDR'="" SpNurDesc=$lg($g(^User.CTSpecialNursingD(eobj.SpNurDR)),3)       //专项护理名
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CTLocLinkSpNur","User.CTLocLinkSpNur","专项护理",id,CTLOCDesc_"->"_SpNurDesc,"D",eobj)
	}
	else 
	{
		TROLLBACK
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("专项护理","web.DHCBL.CT.CTLocLinkSpNur","DeleteData",eobj)
		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
	q result
}

/// Creator:李可凡
/// CreatDate:2019年9月2日
/// Other:d ##class(web.DHCBL.CT.CTLocLinkSpNur).OpenData("1||1")
ClassMethod OpenData(id As %String) As %String
{
	s str=""
	s pobj = ##class(User.CTLocLinkSpNur).%OpenId(id)
	s eobj = ##class(web.Entity.CT.CTLocLinkSpNur).%New()
	s eobj.SpNurRowId = id
	s eobj.SpNurParRef =$p(id,"||",1)
	
	if $IsObject(pobj.SpNurDR)
	{
		s eobj.SpNurDR = pobj.SpNurDR.%Id() 
	}
	
	d pobj.%Close()
	k pobj
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

}
