/// 名称:系统管理-安全组
/// 描述:包含增删改查功能
/// 编写者:基础数据平台组 -陈莹
/// 编写日期:2013-7-5
Class web.DHCBL.CT.SSGroupOrderCategoryItems Extends %RegisteredObject
{

/// Creator:陈莹
/// CreatDate:2013-7-5
/// Description:查询 医嘱子类明细授权
/// Table:User.web.DHCBL.CT.SSGroupOrderCategoryItems
/// Input:itmrowid,ssordrowid,arcimdr
/// Return:ITMParRef,ITMRowId,ITMARCIMDR,ITMUnverifOrder,ITMIncludeExclude
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.SSGroupOrderCategoryItems","GetList","1||42","","")
Query GetList(ssordrowid As %String, itmrowid As %String, arcimdr As %String) As %Query(ROWSPEC = "ITMParRef:%String,ITMRowId:%String,ARCIMDR:%String,ITMARCIMDR:%String,ITMUnverifOrder:%String,ITMIncludeExclude:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, ssordrowid As %String, itmrowid As %String, arcimdr As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	
	if (itmrowid'="")
	{
		s SSGRPRowId=$p(itmrowid,"||",1)
		s SSORDChildsub=$p(itmrowid,"||",2)
		s ITMChildsub=$p(itmrowid,"||",3)
		s ITMRowId=itmrowid
		s ITMParRef=SSGRPRowId_"||"_SSORDChildsub
		s ARCIMDR=$p($g(^SSU("SSGRP",SSGRPRowId,"SSORD",SSORDChildsub,"ITM",ITMChildsub)),"^",1)
		i ARCIMDR'="" {
			s ARCIMSubscript=$p(ARCIMDR,"||",1),ARCIMVersion=$p(ARCIMDR,"||",2)
			s ITMARCIMDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)
		}
		else {
			s ITMARCIMDR=""
		}
		
		s ITMUnverifOrder=$P($g(^SSU("SSGRP",SSGRPRowId,"SSORD",SSORDChildsub,"ITM",ITMChildsub)),"^",2)
		s ITMIncludeExclude=$P($g(^SSU("SSGRP",SSGRPRowId,"SSORD",SSORDChildsub,"ITM",ITMChildsub)),"^",3)
		d OutputRow
	}
	else
	{
		if (ssordrowid)
		{
		//查找时itmrowid,ssordrowid至少有一个不为空
		s ITMChildsub=0,SSGRPRowId=$p(ssordrowid,"||",1),SSORDChildsub=$p(ssordrowid,"||",2)
		for
		{
			s ITMChildsub=$o(^SSU("SSGRP",SSGRPRowId,"SSORD",SSORDChildsub,"ITM",ITMChildsub)) q:ITMChildsub=""
			s ITMRowId=SSGRPRowId_"||"_SSORDChildsub_"||"_ITMChildsub
			s ITMParRef=ssordrowid
			s ARCIMDR=$P($g(^SSU("SSGRP",SSGRPRowId,"SSORD",SSORDChildsub,"ITM",ITMChildsub)),"^",1)
			i ARCIMDR'="" {
			s ARCIMSubscript=$p(ARCIMDR,"||",1),ARCIMVersion=$p(ARCIMDR,"||",2)
			s ITMARCIMDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)
			}
			else {
				s ITMARCIMDR=""
			}
			s ITMUnverifOrder=$P($g(^SSU("SSGRP",SSGRPRowId,"SSORD",SSORDChildsub,"ITM",ITMChildsub)),"^",2)
			s ITMIncludeExclude=$P($g(^SSU("SSGRP",SSGRPRowId,"SSORD",SSORDChildsub,"ITM",ITMChildsub)),"^",3)
			i ((ARCIMDR=arcimdr)||(arcimdr=""))&(ITMChildsub>0)
			{
				d OutputRow
			}
		}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(ITMParRef,ITMRowId,ARCIMDR,ITMARCIMDR,ITMUnverifOrder,ITMIncludeExclude)
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

/// ITMARCIMDR->ARC_ItmMast
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.ORCOperation","GetARCIMDR","","")
/// 一键Include或Exclude功能
/// IncludeALL(IE="I"),ExcludeALL(IE="E")
ClassMethod IEAll(ssordrowid, IE) As %String
{
	if (IE="E") //ExlcudeALL
	{
		s ssgrprowid=$p(ssordrowid,"||",1)
		s ssordchildsub=$p(ssordrowid,"||",2)
		s itmchildsub=0
		for
		{
			s itmchildsub=$o(^SSU("SSGRP",ssgrprowid,"SSORD",ssordchildsub,"ITM",itmchildsub)) q:itmchildsub=""
			s $p(^SSU("SSGRP",ssgrprowid,"SSORD",ssordchildsub,"ITM",itmchildsub),"^",3)="E"
		}
		s result = "{success:'true'}" 
	}
	else //IncludeALL
	{ 
		s ssgrprowid=$p(ssordrowid,"||",1)
		s ssordchildsub=$p(ssordrowid,"||",2)
		s itmchildsub=0
		for
		{
			s itmchildsub=$o(^SSU("SSGRP",ssgrprowid,"SSORD",ssordchildsub,"ITM",itmchildsub)) q:itmchildsub=""
			s $p(^SSU("SSGRP",ssgrprowid,"SSORD",ssordchildsub,"ITM",itmchildsub),"^",3)="I"
		}
		s result = "{success:'true'}" 
	} 
	
	q result
}

/// 用作调试增改功能
ClassMethod SaveTest()
{
	;d ##class(web.DHCBL.CT.SSGroupOrderCategoryItems).SaveTest()
	s eobj = ##class(web.Entity.CT.SSGroupOrderCategoryItems).%New()
	s eobj.ITMARCIMDR="10470||1"   //te级护理
	s eobj.ITMRowId="1||4||23"
	s eobj.ITMParRef="1||4"
	s eobj.ITMUnverifOrder="Y"
	s eobj.ITMIncludeExclude="E"
	d ..SaveEntity(eobj)
}

/// Creator:陈莹
/// CreatDate:2013-7-5
/// Description:增加/修改 医嘱子类明细授权
/// Table:User.SSGroupOrderCategoryItems
/// Input:web.Entity.CT.SSGroupOrderCategoryItems
/// Return:成功返回success:'true'和id;失败返回success:'false'和errorinfo
ClassMethod SaveEntity(eobj As web.Entity.CT.SSGroupOrderCategoryItems) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		if (eobj.ITMRowId="")
		{
			s SSGRPRowId=$p(eobj.ITMParRef,"||",1)
			s SSORDChildsub=$p(eobj.ITMParRef,"||",2)
			s ITMARCIMDR=$d(^SSU("SSGRP",SSGRPRowId,"SSORD",SSORDChildsub,"ITM",0,"ARCIM",eobj.ITMARCIMDR))
			if (ITMARCIMDR=0) {
				s flag=0
				s ITMChildsub=0,IncludeExclude="I"
				s ITMChildsub=$o(^SSU("SSGRP",SSGRPRowId,"SSORD",SSORDChildsub,"ITM",ITMChildsub))
				if (ITMChildsub'="") {
					s IncludeExclude=$P($g(^SSU("SSGRP",SSGRPRowId,"SSORD",SSORDChildsub,"ITM",ITMChildsub)),"^",3)
					i eobj.ITMIncludeExclude'=IncludeExclude {
						s flag=1
					}
				}
				else { // 之前未有数据
					s flag=0
				}
				i (flag=0)	
				{
					s obj = ##class(User.SSGroupOrderCategoryItems).%New(eobj.ITMParRef)
				}
				else{
					s ITMChildsub=$o(^SSU("SSGRP",SSGRPRowId,"SSORD",SSORDChildsub,"ITM",0))
					s IncludeExclude=$P($g(^SSU("SSGRP",SSGRPRowId,"SSORD",SSORDChildsub,"ITM",ITMChildsub)),"^",3)
					i (IncludeExclude="I") s IncludeExclude="Include"
					else  s IncludeExclude="Exclude"
					q "{success:'false',errorinfo:'"_"Include/Exclude要与之前数据统一为"_IncludeExclude_"'}"	
				}
				
			}
			else{
				q "{success:'false',errorinfo:'该记录已经存在！'}"
			}
		}
		else           
		{
			s SSGRPRowId=$p(eobj.ITMRowId,"||",1),SSORDChildsub=$p(eobj.ITMRowId,"||",2),ITMChildsub=$p(eobj.ITMRowId,"||",3)
			s TempARCIMDR=$d(^SSU("SSGRP",SSGRPRowId,"SSORD",SSORDChildsub,"ITM",0,"ARCIM",eobj.ITMARCIMDR))
			s TempChildsub=$o(^SSU("SSGRP",SSGRPRowId,"SSORD",SSORDChildsub,"ITM",0,"ARCIM",eobj.ITMARCIMDR,0))
			if (TempARCIMDR=0)||((TempARCIMDR'=0)&(ITMChildsub=TempChildsub))
			{
				s flag=0
				s ITMChildsub=0,IncludeExclude="I",i=0
				for
				{
					s ITMChildsub=$o(^SSU("SSGRP",SSGRPRowId,"SSORD",SSORDChildsub,"ITM",ITMChildsub)) q:ITMChildsub=""
					s IncludeExclude=$P($g(^SSU("SSGRP",SSGRPRowId,"SSORD",SSORDChildsub,"ITM",ITMChildsub)),"^",3)
					s i=i+1
					i eobj.ITMIncludeExclude'=IncludeExclude {
						s flag=1
					}
				}
				i (flag=0)||((i=1)&(flag=1)) //修改唯有的一条数据时特殊
				{
					s obj = ##class(User.SSGroupOrderCategoryItems).%OpenId(eobj.ITMRowId)
			
					s bobj = ##class(web.Entity.CT.SSGroupOrderCategoryItems).%New()
					s bobj.ITMRowId=eobj.ITMRowId
					s bobj.ITMParRef=$p(eobj.ITMRowId ,"||",1)
					if $IsObject(obj.ITMARCIMDR){
						s bobj.ITMARCIMDR = obj.ITMARCIMDR.%Id() 
					}
					s bobj.ITMUnverifOrder=obj.ITMUnverifOrder
					s bobj.ITMIncludeExclude=obj.ITMIncludeExclude	
					
					
				}
				else{
					s ITMChildsub=$o(^SSU("SSGRP",SSGRPRowId,"SSORD",SSORDChildsub,"ITM",0))
					s IncludeExclude=$P($g(^SSU("SSGRP",SSGRPRowId,"SSORD",SSORDChildsub,"ITM",ITMChildsub)),"^",3)
					i (IncludeExclude="I") s IncludeExclude="Include"
					else  s IncludeExclude="Exclude"
					q "{success:'false',errorinfo:'"_"Include/Exclude要与之前数据统一为"_IncludeExclude_"'}"	
				}
			}
			else{
				q "{success:'false',errorinfo:'该记录已经存在！'}"
			}	
		}
		
			d obj.ITMParRefSetObjectId(eobj.ITMParRef)
			d obj.ITMARCIMDRSetObjectId(eobj.ITMARCIMDR)
			s obj.ITMUnverifOrder=eobj.ITMUnverifOrder
			s obj.ITMIncludeExclude=eobj.ITMIncludeExclude	
		
			s SSORDOrdSubCategory=$P($g(^SSU("SSGRP",SSGRPRowId,"SSORD",SSORDChildsub)),"^",5)
			s ARCICDesc=$p($g(^ARC("IC",SSORDOrdSubCategory)),"^",2)
			s ARCIMSubscript=$p(eobj.ITMARCIMDR,"||",1),ARCIMVersion=$p(eobj.ITMARCIMDR,"||",2)
			s ARCIMDesc=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)
			Tstart
			s sc=obj.%Save()
			do obj.%Close()
			if $$$ISOK(sc){
				Tcommit
				s id = obj.%Id()
				s result = "{success:'true',id:'"_id_"'}"
				d:eobj.ITMRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("SS_GroupOrderCategoryItems","User.SSGroupOrderCategoryItems","安全组-医嘱子类明细",id,ARCICDesc_"->"_ARCIMDesc,"A",eobj)
				d:eobj.ITMRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("SS_GroupOrderCategoryItems","User.SSGroupOrderCategoryItems","安全组-医嘱子类明细",id,ARCICDesc_"->"_ARCIMDesc,"U",eobj,bobj)
			}else{
				Trollback
				s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("安全组-医嘱子类明细","web.DHCBL.CT.SSGroupOrderCategoryItems","SaveEntity",eobj)
				s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
				s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
			}	
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
ERROR
	s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("安全组-医嘱子类明细","web.DHCBL.CT.SSGroupOrderCategoryItems","SaveEntity",eobj)
	s ^ERRORLOGINFO(logid)=$ze
	q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Creator:陈莹
/// CreatDate:2012-9-10
/// Description:双击修改时,从后台取数据
/// Table:User.SSGroupOrderCategoryItems
/// Input:id
/// Return:Json格式的字符串str={list:[...]}
/// Other:w ##class(web.DHCBL.CT.SSGroupOrderCategoryItems).OpenData("1||42||10")
ClassMethod OpenData(id As %String) As %String
{
	s str=""
	s pobj = ##class(User.SSGroupOrderCategoryItems).%OpenId(id)
	s eobj = ##class(web.Entity.CT.SSGroupOrderCategoryItems).%New()
	s eobj.ITMRowId = id
	s eobj.ITMParRef =$p(id,"||",1)_"||"_$p(id,"||",2)
	if $IsObject(pobj.ITMARCIMDR){
		s eobj.ITMARCIMDR = pobj.ITMARCIMDR.%Id() 
		}
	S eobj.ITMUnverifOrder=pobj.ITMUnverifOrder
	s eobj.ITMIncludeExclude=pobj.ITMIncludeExclude
	d pobj.%Close()
	k pobj
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

/// Creator：陈莹
/// CreatDate: 2013-7-5
/// Description：根据id删除 医嘱子类明细授权
/// Table：User.SSGroupOrderCategoryItems
/// Input：id 
/// Return：成功返回true和info，失败返回false和info
ClassMethod DeleteData(id As %String) As %String
{
	s result=""
	s pobj = ##class(User.SSGroupOrderCategoryItems).%OpenId(id)
	s eobj = ##class(web.Entity.CT.SSGroupOrderCategoryItems).%New()
	s eobj.ITMRowId = id
	s eobj.ITMParRef =$p(id,"||",1)_"||"_$p(id,"||",2)
	if $IsObject(pobj.ITMARCIMDR){
		s eobj.ITMARCIMDR = pobj.ITMARCIMDR.%Id() 
		}
	S eobj.ITMUnverifOrder=pobj.ITMUnverifOrder
	S eobj.ITMIncludeExclude=pobj.ITMIncludeExclude
	d pobj.%Close()
	k pobj
	s SSGRPRowId=$p(id,"||",1),SSORDChildsub=$p(id,"||",2)
	s SSORDOrdSubCategory=$P($g(^SSU("SSGRP",SSGRPRowId,"SSORD",SSORDChildsub)),"^",5)
	s ARCICDesc=$p($g(^ARC("IC",SSORDOrdSubCategory)),"^",2)
	s ARCIMSubscript=$p(eobj.ITMARCIMDR,"||",1),ARCIMVersion=$p(eobj.ITMARCIMDR,"||",2)
	s ARCIMDesc=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)
	Tstart
	s sc=##class(User.SSGroupOrderCategoryItems).%DeleteId(id)
	IF $$$ISOK(sc){
		Tc
		s result="{success:'true',info:'删除成功！'}"
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("SS_GroupOrderCategoryItems","User.SSGroupOrderCategoryItems","安全组-医嘱子类明细",id,ARCICDesc_"->"_ARCIMDesc,"D",eobj)
	}
	else{
		Trollback
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("安全组-医嘱子类明细","web.DHCBL.CT.SSGroupOrderCategoryItems","DeleteData",eobj)
	   	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
	}
	q result
}

ClassMethod ChangeOrdSub(ssordrowid As %String) As %String
{
	s result=""
	s ITMChildsub=0,SSGRPRowId=$p(ssordrowid,"||",1),SSORDChildsub=$p(ssordrowid,"||",2)
	for
	{
		s ITMChildsub=$o(^SSU("SSGRP",SSGRPRowId,"SSORD",SSORDChildsub,"ITM",ITMChildsub)) q:ITMChildsub=""
		s ITMRowId=SSGRPRowId_"||"_SSORDChildsub_"||"_ITMChildsub
		s ITMParRef=ssordrowid
		s result=##class(web.DHCBL.CT.SSGroupOrderCategoryItems).DeleteData(ITMRowId)
	}
}

/// 当修改医嘱子类时，查询其有没有对应 医嘱子类明细，如果有，返回true;如果没有，返回false
/// Other:d ##class(web.DHCBL.CT.SSGroupOrderCategoryItems).QueryForItems("29||1")
ClassMethod QueryForItems(ssordrowid As %String) As %String
{
	
	s result=""
	s ITMChildsub=0,SSGRPRowId=$p(ssordrowid,"||",1),SSORDChildsub=$p(ssordrowid,"||",2)
	s ITMChildsub=$o(^SSU("SSGRP",SSGRPRowId,"SSORD",SSORDChildsub,"ITM",0))
	if (ITMChildsub'="") {
		s result="{success:'true',info:'有数据！'}"
	}
	else {
		s result= "{success:'false',info:'无数据！'}"
	}
	q result
}

}
