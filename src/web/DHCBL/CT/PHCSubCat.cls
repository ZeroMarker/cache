Import SQLUser

/// 名称:药学 6.1药理学子分类
/// 描述:药理学子分类维护，包含增删改查功能
/// 编写者：基础数据平台组 - 陈莹 
/// 编写日期: 2012-8-30
Class web.DHCBL.CT.PHCSubCat Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator:陈莹
/// CreatDate:2013-5-17
/// Description:查询 药理学子分类
/// Table:User.PHCSubCat
/// Input: phcscparref(父表id),rowid
/// Return:PHCSCRowId,PHCSCPHCCParRef,PHCSCCode,PHCSCDesc
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PHCSubCat","GetList","7","")
Query GetList(phcscparref As %String, rowid As %String) As %Query(ROWSPEC = "PHCSCRowId:%String,PHCSCPHCCParRef:%String,PHCSCCode:%String,PHCSCDesc:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, phcscparref As %String, rowid As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	if (rowid'="")
	{
		s PHCSCRowId=rowid
		s PHCCRowId=$p(rowid,"||",1)
		s PHCSCPHCCParRef=$p($g(^PHCC(PHCCRowId)),"^",2)  //取desc
		s PHCCRowId=$p(rowid,"||",1)
		s PHCSCChildSub=$p(rowid,"||",2)
		s PHCSCCode=$p($g(^PHCC(PHCCRowId,"SC",PHCSCChildSub)),"^",1)
		s PHCSCDesc=$p($g(^PHCC(PHCCRowId,"SC",PHCSCChildSub)),"^",2)
		d OutputRow
	}
	else
	{
		if (phcscparref)
		{
		s PHCCRowId=phcscparref
		s PHCSCPHCCParRef=$p($g(^PHCC(phcscparref)),"^",2)  //取desc
		s PHCSCChildSub=0 
		for
		{
			s PHCSCChildSub=$o(^PHCC(PHCCRowId,"SC",PHCSCChildSub)) q:PHCSCChildSub=""
			s PHCSCRowId=PHCCRowId_"||"_PHCSCChildSub
			s PHCSCCode=$p($g(^PHCC(PHCCRowId,"SC",PHCSCChildSub)),"^",1)
			s PHCSCDesc=$p($g(^PHCC(PHCCRowId,"SC",PHCSCChildSub)),"^",2)
			i (PHCSCChildSub>0)
			{
				d OutputRow
			}
		}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(PHCSCRowId,PHCSCPHCCParRef,PHCSCCode,PHCSCDesc)
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
/// CreatDate:2013-8-15
/// Other:d ##class(web.DHCBL.CT.PHCSubCat).OpenData("7||1")
ClassMethod OpenData(id As %String) As %String
{
	s str=""
	s pobj = ##class(User.PHCSubCat).%OpenId(id)
	s eobj = ##class(web.Entity.CT.PHCSubCat).%New()
	s eobj.PHCSCRowId = id
	s eobj.PHCSCChildSub=$p(id,"||",2)
	s eobj.PHCSCPHCCParRef = $p(id,"||",1)
	s eobj.PHCSCCode=pobj.PHCSCCode
	s eobj.PHCSCDesc=pobj.PHCSCDesc
	d pobj.%Close()
	k pobj
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

/// 用作调试增改功能
ClassMethod SaveTest()
{
	;d ##class(web.DHCBL.CT.PHCSubCat).SaveTest()
	s obj = ##class(web.Entity.CT.PHCSubCat).%New()
	s obj.PHCSCPHCCParRef=1
	s obj.PHCSCCode="bbb"
	s obj.PHCSCDesc="bba"
	d ..SaveEntity(obj)
}

/// Creator：陈莹 
/// CreatDate: 2012-8-3
/// Description:添加/修改 药理学子分类
/// Table：User.PHCSubCat
ClassMethod SaveEntity(eobj As web.Entity.CT.PHCSubCat) As %String
{
	s $zt="ERROR"
	s result=""
	if $IsObject(eobj)
	{	
		//如果RowId未赋值则增加
		if (eobj.PHCSCRowId="")       
		{
			//前台js已添加空值判断allowblank
			
			s TempPHCSCCode=$$ALPHAUP^SSUTIL4(eobj.PHCSCCode)   //$$ALPHAUP^SSUTIL4(eobj.PHCSCCode)
			s TempCode=$d(^PHCC("SC_Code",TempPHCSCCode,eobj.PHCSCPHCCParRef))	
			if (TempCode=0)  //判断Code是否重复
			{
				s TempPHCSCDesc=$$ALPHAUP^SSUTIL4(eobj.PHCSCDesc)
				s TempDesc=$d(^PHCC("SC_Desc",TempPHCSCDesc,eobj.PHCSCPHCCParRef))
				if (TempDesc=0) //判断Desc是否重复
				{
					s obj=##class(User.PHCSubCat).%New(eobj.PHCSCPHCCParRef)
					d obj.PHCSCPHCCParRefSetObjectId(eobj.PHCSCPHCCParRef)
					s obj.PHCSCCode = eobj.PHCSCCode
					s obj.PHCSCDesc = eobj.PHCSCDesc
					Tstart
					s sc=obj.%Save()
					do obj.%Close()
					if $$$ISOK(sc){
						Tcommit
						s id = obj.%Id()
						s result = "{success:'true',id:'"_id_"'}"
						d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PHC_SubCat","User.PHCSubCat","药理学子分类",id,eobj.PHCSCDesc,"A",eobj)
					}else{
						Trollback
						s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("药理学子分类","web.DHCBL.CT.PHCSubCat","SaveEntity",eobj)
	    				s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
						s result = "{success:'false',errorinfo:'"_$zconvert(sc,"O","JS")_"'}"    //返回错误信息
					}	
				}
				else  //Desc重复
				{
					s result="{success:'false',errorinfo:'该描述已经存在，请重新填写！'}"
				}
			}
			else //Code重复
			{
				s result="{success:'false',errorinfo:'该代码已经存在，请重新填写！'}"
			}
			
		}
		//如果RowId已赋值则修改
		else                           
		{
			//判断空值,前台js也已添加空值判断allowblank
		
			s TempPHCSCCode=$$ALPHAUP^SSUTIL4(eobj.PHCSCCode)   //$$ALPHAUP^SSUTIL4(eobj.PHCSCCode)
			s TempCode=$d(^PHCC("SC_Code",TempPHCSCCode,eobj.PHCSCPHCCParRef))
			s PHCSCChildSub=$p(eobj.PHCSCRowId,"||",2)
			s TempChildSub=$o(^PHCC("SC_Code",TempPHCSCCode,eobj.PHCSCPHCCParRef,0))
			if ((TempCode=0)||((TempCode'=0)&(TempChildSub=PHCSCChildSub))) //判断Code是否重复
			{
				s TempPHCSCDesc=$$ALPHAUP^SSUTIL4(eobj.PHCSCDesc)
				s TempDesc=$d(^PHCC("SC_Desc",TempPHCSCDesc,eobj.PHCSCPHCCParRef))
				s TempChildSubD=$o(^PHCC("SC_Desc",TempPHCSCDesc,eobj.PHCSCPHCCParRef,0))
				if ((TempDesc=0)||((TempDesc'=0)&(TempChildSubD=PHCSCChildSub))) //判断Desc是否重复
				{
					s obj=##class(User.PHCSubCat).%OpenId(eobj.PHCSCRowId)
					s bobj = ##class(web.Entity.CT.PHCSubCat).%New()
					s bobj.PHCSCRowId = eobj.PHCSCRowId
					s bobj.PHCSCPHCCParRef = $p(eobj.PHCSCRowId,"||",1)
					s bobj.PHCSCCode = obj.PHCSCCode
					s bobj.PHCSCDesc = obj.PHCSCDesc
					
					d obj.PHCSCPHCCParRefSetObjectId(eobj.PHCSCPHCCParRef)
					s obj.PHCSCCode = eobj.PHCSCCode
					s obj.PHCSCDesc = eobj.PHCSCDesc
					Tstart
					s sc=obj.%Save()
					do obj.%Close()
					if $$$ISOK(sc){
						Tcommit
						s id = obj.%Id()
						s result = "{success:'true',id:'"_id_"'}"
						d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PHC_SubCat","User.PHCSubCat","药理学子分类",id,eobj.PHCSCDesc,"U",eobj,bobj)
					}else{
						Trollback
						s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("药理学子分类","web.DHCBL.CT.PHCSubCat","SaveEntity",eobj)
	    				s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
						s result = "{success:'false',errorinfo:'"_$zconvert(sc,"O","JS")_"'}"    //返回错误信息
					}	
				}
				else  //Desc重复
				{
					s result="{success:'false',errorinfo:'该描述已经存在，请重新填写！'}"
				}
			}
			else //Code重复
			{
				s result="{success:'false',errorinfo:'该代码已经存在，请重新填写！'}"
			}	
		
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
ERROR
	s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("药理学子分类","web.DHCBL.CT.PHCSubCat","SaveEntity",eobj)
	s ^ERRORLOGINFO(logid)=$ze
	q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Creator:陈莹
/// CreatDate:2013-8-22
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
ClassMethod GetRefFlag(id As %String) As %String
{
	s return="",myInfo=""
	
	s MINChildsub=0,flag=0
	s PHCCRowId=$p(id,"||",1),PHCSCChildSub=$p(id,"||",2)
	for
	{
		s MINChildsub=$o(^PHCC(PHCCRowId,"SC",PHCSCChildSub,"MIN",MINChildsub)) q:(MINChildsub="")||(flag=1)
		s MINRowId=PHCCRowId_"||"_PHCSCChildSub_"||"_MINChildsub
		s PHCDRowId=0
		for{
			s PHCDRowId=$o(^PHCD(PHCDRowId)) q:(PHCDRowId="")||(flag=1)
			s PHCDMinSubCatDR=$p($g(^PHCD(PHCDRowId,1)),"^",6)
			i PHCDMinSubCatDR=MINRowId
			{
				s flag=1
				s myInfo=myInfo_"<其小子分类在药学项>"
			}
			
			s PHCDPHCSCDR=$p($g(^PHCD(PHCDRowId,1)),"^",3)
			i PHCDPHCSCDR=id
			{
				s flag=1
				s myInfo=myInfo_"<药学项>"
			}
		}
	}
	i myInfo="" s return="0^未被引用可删除！"
	else  s return="1^在"_myInfo_"表里被引用,不能删除！"
	q return
}

/// Creator：陈莹 
/// CreatDate: 2012-8-30
/// Modified By 陈莹,2013-7-3
/// Description：根据id删除 药理学子分类
/// Table：User.PHCSubCat
/// Input：id 
/// Return：成功返回true，失败返回false和失败原因
/// Other: w ##class(web.DHCBL.CT.PHCSubCat).DeleteData("12||2")
ClassMethod DeleteData(id) As %String
{
	s result=""
	s re=##class(web.DHCBL.CT.PHCSubCat).GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	if (RefFlag=0){
		s pobj = ##class(User.PHCSubCat).%OpenId(id)
		s eobj = ##class(web.Entity.CT.PHCSubCat).%New()
		s eobj.PHCSCRowId = id
		s eobj.PHCSCCode = pobj.PHCSCCode
		s eobj.PHCSCDesc = pobj.PHCSCDesc
		s eobj.PHCSCPHCCParRef = $p(id,"||",1)
		d pobj.%Close()
		k pobj
		Tstart
		s sc=##class(User.PHCSubCat).%DeleteId(id)
		IF $$$ISOK(sc){
			Tc
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PHC_SubCat","User.PHCSubCat","药理学子分类",id,eobj.PHCSCDesc,"D",eobj) 
		}
		else{
			Trollback
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("药理学子分类","web.DHCBL.CT.PHCSubCat","DeleteData",eobj)
	    	s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
			s result= "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"  //返回错误信息
		}
	}
	else{
		s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
	}
	q result
}

}
