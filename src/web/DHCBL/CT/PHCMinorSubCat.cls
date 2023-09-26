Import SQLUser

/// 名称:药学 6.1.1药理学小子分类
/// 描述:药理学小子分类维护，包含增删改查功能
/// 编写者：基础数据平台组 - 陈莹 
/// 编写日期: 2012-8-30
Class web.DHCBL.CT.PHCMinorSubCat Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator:陈莹
/// CreatDate:2013-5-17
/// Description:查询 药理学小子分类
/// Table:User.PHCMinorSubCat
/// Input:minparref(父表id,7||1),rowid
/// Return:MINRowId,MINParRef,MINCode,MINDesc
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PHCMinorSubCat","GetList","7||2","")
Query GetList(minparref As %String, rowid As %String) As %Query(ROWSPEC = "MINRowId:%String,MINParRef:%String,MINCode:%String,MINDesc:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, minparref As %String, rowid As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	if (rowid'="")
	{
		s PHCCRowId=$p(rowid,"||",1)
		s PHCSCChildSub=$p(rowid,"||",2)
		s MINChildsub=$p(rowid,"||",3)
		s MINRowId=PHCCRowId_"||"_PHCSCChildSub_"||"_MINChildsub
		s MINParRef=PHCCRowId_"||"_PHCSCChildSub
		s MINCode=$p($g(^PHCC(PHCCRowId,"SC",PHCSCChildSub,"MIN",MINChildsub)),"^",1)
		s MINDesc=$p($g(^PHCC(PHCCRowId,"SC",PHCSCChildSub,"MIN",MINChildsub)),"^",2)
		d OutputRow
	}
	else
	{
		if (minparref)
		{
		s MINParRef=minparref
		s PHCCRowId=$p(minparref,"||",1)
		s PHCSCChildSub=$p(minparref,"||",2)
		s MINChildsub=0
		for
		{
			s MINChildsub=$o(^PHCC(PHCCRowId,"SC",PHCSCChildSub,"MIN",MINChildsub)) q:MINChildsub=""
			s MINRowId=PHCCRowId_"||"_PHCSCChildSub_"||"_MINChildsub
			s MINCode=$p($g(^PHCC(PHCCRowId,"SC",PHCSCChildSub,"MIN",MINChildsub)),"^",1)
			s MINDesc=$p($g(^PHCC(PHCCRowId,"SC",PHCSCChildSub,"MIN",MINChildsub)),"^",2)
			i (MINChildsub>0)
			{
				d OutputRow
			}
		}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(MINRowId,MINParRef,MINCode,MINDesc)
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
/// Other:d ##class(web.DHCBL.CT.PHCMinorSubCat).OpenData("7||1||1")
ClassMethod OpenData(id As %String) As %String
{
	s str=""
	s pobj = ##class(User.PHCMinorSubCat).%OpenId(id)
	s eobj = ##class(web.Entity.CT.PHCMinorSubCat).%New()
	s eobj.MINRowId = id
	s eobj.MINParRef = $p(id,"||",1)_"||"_$p(id,"||",2)
	s eobj.MINChildsub=$p(id,"||",3)
	s eobj.MINCode=pobj.MINCode
	s eobj.MINDesc=pobj.MINDesc
	d pobj.%Close()
	k pobj
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

/// 用作调试增改功能
ClassMethod SaveTest()
{
	;d ##class(web.DHCBL.CT.PHCMinorSubCat).SaveTest()
	s obj = ##class(web.Entity.CT.PHCMinorSubCat).%New()
	s obj.MINParRef="7||2"
	s obj.MINCode="H010121"
	s obj.MINDesc="苯二氮卓类药1111"
	d ..SaveEntity(obj)
}

/// Creator：陈莹 
/// CreatDate: 2012-8-3
/// Description：添加/修改 药理学小子分类
/// Table：User.PHCMinorSubCat
ClassMethod SaveEntity(eobj As web.Entity.CT.PHCMinorSubCat) As %String
{
	s $zt="ERROR"
	s result=""
	if $IsObject(eobj)
	{
		//如果RowId未赋值则增加
		if (eobj.MINRowId="")       
		{
			//前台js已添加空值判断allowblank
		
			s PHCCRowId=$p(eobj.MINParRef,"||",1)
			s PHCSCChildSub=$p(eobj.MINParRef,"||",2)
			s MINChildsub=$p(eobj.MINParRef,"||",3)
			
			s TempMINCode=$$ALPHAUP^SSUTIL4(eobj.MINCode)   //$$ALPHAUP^SSUTIL4(eobj.MINCode)
			s TempCode=$d(^PHCC("MIN_Code",TempMINCode,PHCCRowId,PHCSCChildSub))	
			if (TempCode=0)  //判断Code是否重复
			{
				s TempMINDesc=$$ALPHAUP^SSUTIL4(eobj.MINDesc)
				s TempDesc=$d(^PHCC("MIN_Desc",TempMINDesc,PHCCRowId,PHCSCChildSub))
				if (TempDesc=0) //判断Desc是否重复
				{
					s obj=##class(User.PHCMinorSubCat).%New(eobj.MINParRef)
					d obj.MINParRefSetObjectId(eobj.MINParRef)
					s obj.MINCode = eobj.MINCode
					s obj.MINDesc = eobj.MINDesc
					Tstart
					s sc=obj.%Save()
					do obj.%Close()
					if $$$ISOK(sc){
						Tcommit
						s id = obj.%Id()
						s result = "{success:'true',id:'"_id_"'}"
						d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PHC_MinorSubCat","User.PHCMinorSubCat","药理学小子分类",id,eobj.MINDesc,"A",eobj)
					}else{
						Trollback
						s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("药理学小子分类","web.DHCBL.CT.PHCMinorSubCat","SaveEntity",eobj)
	    				s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
						s result = "{success:'false',errorinfo:'"_$zconvert(sc,"O","JS")_"'}"    //返回错误信息
					}
				}
				else  //如果Desc重复
				{
					s result="{success:'false',errorinfo:'该描述已经存在，请重新填写！'}"
				}
			}
			else //如果Code重复
			{
				s result="{success:'false',errorinfo:'该代码已经存在，请重新填写！'}"
			}
			
		}
		//如果RowId已赋值则修改
		else                           
		{	
			//前台js已添加空值判断allowblank
			
			s PHCCRowId=$p(eobj.MINRowId,"||",1)
			s PHCSCChildSub=$p(eobj.MINRowId,"||",2)
			s MINChildsub=$p(eobj.MINRowId,"||",3)
			
			s TempMINCode=$$ALPHAUP^SSUTIL4(eobj.MINCode)   //$$ALPHAUP^SSUTIL4(eobj.MINCode)
			s TempCode=$d(^PHCC("MIN_Code",TempMINCode,PHCCRowId,PHCSCChildSub))
			s TempChildSub=$o(^PHCC("MIN_Code",TempMINCode,PHCCRowId,PHCSCChildSub,0))
			if ((TempCode=0)||((TempCode'=0)&(TempChildSub=MINChildsub))) //判断Code是否重复
			{
				s TempMINDesc=$$ALPHAUP^SSUTIL4(eobj.MINDesc)
				s TempDesc=$d(^PHCC("MIN_Desc",TempMINDesc,PHCCRowId,PHCSCChildSub))
				s TempChildSubD=$o(^PHCC("MIN_Desc",TempMINDesc,PHCCRowId,PHCSCChildSub,0))
				if ((TempDesc=0)||((TempDesc'=0)&(TempChildSubD=MINChildsub))) //判断Desc是否重复
				{
					s obj=##class(User.PHCMinorSubCat).%OpenId(eobj.MINRowId)
					s bobj = ##class(web.Entity.CT.PHCMinorSubCat).%New()
					s bobj.MINRowId = eobj.MINRowId
					s bobj.MINParRef = $p(eobj.MINRowId,"||",1)
					s bobj.MINCode = obj.MINCode
					s bobj.MINDesc = obj.MINDesc
					
					d obj.MINParRefSetObjectId(eobj.MINParRef)
					s obj.MINCode = eobj.MINCode
					s obj.MINDesc = eobj.MINDesc
					Tstart
					s sc=obj.%Save()
					do obj.%Close()
					if $$$ISOK(sc){
						Tcommit
						s id = obj.%Id()
						s result = "{success:'true',id:'"_id_"'}"
						d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PHC_MinorSubCat","User.PHCMinorSubCat","药理学小子分类",id,eobj.MINDesc,"U",eobj,bobj)
					}else{
						Trollback
						s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("药理学小子分类","web.DHCBL.CT.PHCMinorSubCat","SaveEntity",eobj)
	    				s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
						s result = "{success:'false',errorinfo:'"_$zconvert(sc,"O","JS")_"'}"    //返回错误信息
					}	
				}
				else  //如果Desc重复
				{
					s result="{success:'false',errorinfo:'该描述已经存在，请重新填写！'}"
				}
			}
			else //如果Code重复
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
	s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("药理学小子分类","web.DHCBL.CT.PHCMinorSubCat","SaveEntity",eobj)
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
	s PHCDRowId=0,flag=0
	for
	{
		s PHCDRowId=$o(^PHCD(PHCDRowId)) q:(PHCDRowId="")||(flag=1)
		s PHCDMinSubCatDR=$p($g(^PHCD(PHCDRowId,1)),"^",6)
		i PHCDMinSubCatDR=id
		{
			s flag=1
			s myInfo=myInfo_"<药学项>"
		}
	}
	i myInfo="" s return="0^未被引用可删除！"
	else  s return="1^在"_myInfo_"表里被引用,不能删除！"
	q return
}

/// Creator：陈莹 
/// CreatDate: 2012-8-30
/// Modified By 陈莹,2013-7-3
/// Description：根据id删除 药理学小子分类
/// Table：User.PHCMinorSubCat
/// Input：id 
/// Return：成功返回true和info，失败返回false和info
/// w ##class(web.DHCBL.CT.PHCMinorSubCat).DeleteData("12||2||3")
ClassMethod DeleteData(id) As %String
{
	s result=""
	
	s re=##class(web.DHCBL.CT.PHCMinorSubCat).GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	if (RefFlag=0){
		s pobj = ##class(User.PHCMinorSubCat).%OpenId(id)
		s eobj = ##class(web.Entity.CT.PHCMinorSubCat).%New()
		s eobj.MINRowId = id
		s eobj.MINCode = pobj.MINCode
		s eobj.MINDesc = pobj.MINDesc
		s eobj.MINParRef = $p(id,"||",1)_"||"_$p(id,"||",2)
		
		d pobj.%Close()
		k pobj
		Tstart
		s sc=##class(User.PHCMinorSubCat).%DeleteId(id)
		IF $$$ISOK(sc){
			Tc
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PHC_MinorSubCat","User.PHCMinorSubCat","药理学小子分类",id,eobj.MINDesc,"D",eobj)
		}
		else{
			Trollback
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("药理学小子分类","web.DHCBL.CT.PHCMinorSubCat","DeleteData",eobj)
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
