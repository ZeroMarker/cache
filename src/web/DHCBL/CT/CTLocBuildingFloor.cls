/// 医院楼层表-医院楼的子表，包含增删改查
/// 基础数据平台-李可凡
/// User.CTLocBuildingFloor
/// 2020年8月31日
Class web.DHCBL.CT.CTLocBuildingFloor Extends %RegisteredObject
{

/// Creator：李可凡
/// CreatDate: 2020年8月31日
/// Description：提供医院楼层下拉列表
/// Table：User.CTLocBuildingFloor
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTLocBuildingFloor","GetDataForCmb1","","")
Query GetDataForCmb1(rowid, desc, hospid) As %Query(ROWSPEC = "CTLBFRowId,CTLBFFloor")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid, desc, hospid) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	s:desc'="" desc=$ZCONVERT(desc,"U")
	if (rowid'="") //根据rowid返回该条记录
	{
		s CTLBFRowId=rowid
		s CTLBFParRef=$p(rowid,"||",1)
		s CTLBFChildsub=$p(rowid,"||",2)
		s CTLBDesc=$p($g(^CT("CTLB",CTLBFParRef)),"^",2)	//医院楼描述
		s CTLBFFloor=$p($g(^CT("CTLB",CTLBFParRef,"Floor",CTLBFChildsub)),"^",1)  //楼层
		s CTLBFFloor=CTLBDesc_"-"_CTLBFFloor
		d OutputCmb1
	}
	else
	{
		s CTLBFParRef=0
	 	for
	 	{
		 	s CTLBFParRef=$o(^CT("CTLB",CTLBFParRef)) q:CTLBFParRef=""
		 	s CTLBDesc=$p($g(^CT("CTLB",CTLBFParRef)),"^",2)	//医院楼描述
		 	s CTLBDateFrom=$p($g(^CT("CTLB",CTLBFParRef)),"^",3)	//开始日期
		 	s CTLBDateTo=$p($g(^CT("CTLB",CTLBFParRef)),"^",4)	//结束日期
		 	s CTLBHospitalDR=$p($g(^CT("CTLB",CTLBFParRef)),"^",6)	//医院DR
			continue:CTLBHospitalDR'=hospid
		 	continue:(CTLBDateFrom'="")&&(CTLBDateFrom>+$h)
		 	continue:(CTLBDateTo'="")&&(CTLBDateTo<+$h)
	 		s CTLBFChildsub=0
	 		for
	 		{
		 		s CTLBFChildsub=$o(^CT("CTLB",CTLBFParRef,"Floor",CTLBFChildsub)) q:CTLBFChildsub=""
		 		s CTLBFRowId=CTLBFParRef_"||"_CTLBFChildsub
		 		s CTLBFFloor=$p($g(^CT("CTLB",CTLBFParRef,"Floor",CTLBFChildsub)),"^",1)  //楼层
		 		s CTLBFDateFrom=$p($g(^CT("CTLB",CTLBFParRef,"Floor",CTLBFChildsub)),"^",2)  //开始日期
		 		s CTLBFDateTo=$p($g(^CT("CTLB",CTLBFParRef,"Floor",CTLBFChildsub)),"^",3)  //结束日期
		 		continue:(CTLBFDateFrom'="")&&(CTLBFDateFrom>+$h)
		 		continue:(CTLBFDateTo'="")&&(CTLBFDateTo<+$h)
		 		s CTLBFFloor=CTLBDesc_"-"_CTLBFFloor
		 		s PINYIN=""
				s:CTLBFFloor'="" PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(CTLBFFloor)
				if (($ZCONVERT(CTLBFFloor,"U")[desc)||(PINYIN[desc))
				{
					d OutputCmb1
				}
		 	}
	 	}
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputCmb1
    set Data=$lb(CTLBFRowId,CTLBFFloor)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCmb1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDataForCmb1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
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

/// Creator：李可凡
/// CreatDate: 2020年8月31日
/// Description：查询医院楼层表
/// Table：User.CTLocBuildingFloor
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTLocBuildingFloor","GetList","","","")
Query GetList(parref As %String, rowid As %String, desc As %String) As %Query(ROWSPEC = "CTLBFParRef,CTLBFRowId,CTLBFChildsub,CTLBFFloor,CTLBFDateFrom,CTLBFDateTo,CTLBFMark")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, parref As %String, rowid As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	s:desc'="" desc=$ZCONVERT(desc,"U")
	if (rowid'="") //根据rowid返回该条记录
	{
		s CTLBFRowId=rowid
		s CTLBFParRef=$p(rowid,"||",1)
		s CTLBFChildsub=$p(rowid,"||",2)
		s CTLBDesc=$p($g(^CT("CTLB",CTLBFParRef)),"^",2)	//医院楼描述
		s CTLBFFloor=$p($g(^CT("CTLB",CTLBFParRef,"Floor",CTLBFChildsub)),"^",1)  //楼层
		s CTLBFDateFrom=$p($g(^CT("CTLB",CTLBFParRef,"Floor",CTLBFChildsub)),"^",2)  //开始日期
		s CTLBFDateTo=$p($g(^CT("CTLB",CTLBFParRef,"Floor",CTLBFChildsub)),"^",3)  //结束日期
		s:CTLBFDateFrom'="" CTLBFDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(CTLBFDateFrom)	//转换日期格式
		s:CTLBFDateTo'="" CTLBFDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(CTLBFDateTo)	//转换日期格式
		s CTLBFMark=$p($g(^CT("CTLB",CTLBFParRef,"Floor",CTLBFChildsub)),"^",4)  //备注
		//s CTLBFFloor=CTLBDesc_"-"_CTLBFFloor
		d OutputRow
	}
	else
	{
		if (parref'="")
		{
			s CTLBFParRef=parref
			s CTLBDesc=$p($g(^CT("CTLB",CTLBFParRef)),"^",2)	//医院楼描述
	 		s CTLBFChildsub=0
	 		for
	 		{
		 		s CTLBFChildsub=$o(^CT("CTLB",CTLBFParRef,"Floor",CTLBFChildsub)) q:CTLBFChildsub=""
		 		s CTLBFRowId=CTLBFParRef_"||"_CTLBFChildsub
		 		s CTLBFFloor=$p($g(^CT("CTLB",CTLBFParRef,"Floor",CTLBFChildsub)),"^",1)  //楼层
		 		s CTLBFDateFrom=$p($g(^CT("CTLB",CTLBFParRef,"Floor",CTLBFChildsub)),"^",2)  //开始日期
				s CTLBFDateTo=$p($g(^CT("CTLB",CTLBFParRef,"Floor",CTLBFChildsub)),"^",3)  //结束日期
				s:CTLBFDateFrom'="" CTLBFDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(CTLBFDateFrom)	//转换日期格式
				s:CTLBFDateTo'="" CTLBFDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(CTLBFDateTo)	//转换日期格式
				s CTLBFMark=$p($g(^CT("CTLB",CTLBFParRef,"Floor",CTLBFChildsub)),"^",4)  //备注
		 		//s CTLBFFloor=CTLBDesc_"-"_CTLBFFloor
		 		s PINYIN=""
				s:CTLBFFloor'="" PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(CTLBFFloor)
				if (($ZCONVERT(CTLBFFloor,"U")[desc)||(PINYIN[desc))
				{
					d OutputRow
				}
		 	}
		}
		else
		{
			s CTLBFParRef=0
		 	for
		 	{
			 	s CTLBFParRef=$o(^CT("CTLB",CTLBFParRef)) q:CTLBFParRef=""
			 	s CTLBDesc=$p($g(^CT("CTLB",CTLBFParRef)),"^",2)	//医院楼描述
		 		s CTLBFChildsub=0
		 		for
		 		{
			 		s CTLBFChildsub=$o(^CT("CTLB",CTLBFParRef,"Floor",CTLBFChildsub)) q:CTLBFChildsub=""
			 		s CTLBFRowId=CTLBFParRef_"||"_CTLBFChildsub
			 		s CTLBFFloor=$p($g(^CT("CTLB",CTLBFParRef,"Floor",CTLBFChildsub)),"^",1)  //楼层
			 		s CTLBFDateFrom=$p($g(^CT("CTLB",CTLBFParRef,"Floor",CTLBFChildsub)),"^",2)  //开始日期
					s CTLBFDateTo=$p($g(^CT("CTLB",CTLBFParRef,"Floor",CTLBFChildsub)),"^",3)  //结束日期
					s:CTLBFDateFrom'="" CTLBFDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(CTLBFDateFrom)	//转换日期格式
					s:CTLBFDateTo'="" CTLBFDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(CTLBFDateTo)	//转换日期格式
					s CTLBFMark=$p($g(^CT("CTLB",CTLBFParRef,"Floor",CTLBFChildsub)),"^",4)  //备注
			 		//s CTLBFFloor=CTLBDesc_"-"_CTLBFFloor
			 		s PINYIN=""
					s:CTLBFFloor'="" PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(CTLBFFloor)
					if (($ZCONVERT(CTLBFFloor,"U")[desc)||(PINYIN[desc))
					{
						d OutputRow
					}
			 	}
		 	}
		}
	}
		
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(CTLBFParRef,CTLBFRowId,CTLBFChildsub,CTLBFFloor,CTLBFDateFrom,CTLBFDateTo,CTLBFMark)
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

/// Function:数据校验功能
/// Creator:基础数据平台-李可凡
/// CreateDate:2020年1月30日  
/// 0 不重复；1 重复
/// w ##class(web.DHCBL.CT.CTLocBuildingFloor).FormValidate("","","")
ClassMethod FormValidate(parref As %String, rowid As %String, floor As %String) As %String
{
	s flag=0
	if (parref'="")
	{
		s CTLBFChildsub=0
		for
		{
			s CTLBFChildsub=$o(^CT("CTLB",parref,"Floor",CTLBFChildsub)) q:CTLBFChildsub=""
			s CTLBFRowId=parref_"||"_CTLBFChildsub
			s CTLBFFloor=$p($g(^CT("CTLB",parref,"Floor",CTLBFChildsub)),"^",1)  //楼层
			if (CTLBFFloor=floor)&&(CTLBFRowId'=rowid)
			{
				s flag=1
				q
			}
		}
	}
	q flag
}

/// Creator:基础数据平台-李可凡
/// CreatDate:2020年1月30日
/// Other:w ##class(web.DHCBL.CT.CTLocBuildingFloor).OpenData("")
ClassMethod OpenData(id As %String) As %String
{
	s str=""
	s pobj = ##class(User.CTLocBuildingFloor).%OpenId(id)
	s eobj = ##class(web.Entity.CT.CTLocBuildingFloor).%New()
	if (pobj)
	{
		s eobj.CTLBFRowId=id
		s eobj.CTLBFParRef=pobj.CTLBFParRef.%Id()
		s eobj.CTLBFChildsub=pobj.CTLBFChildsub
		s eobj.CTLBFFloor=pobj.CTLBFFloor
		s:pobj.CTLBFDateFrom'="" eobj.CTLBFDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.CTLBFDateFrom)
		s:pobj.CTLBFDateTo'="" eobj.CTLBFDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.CTLBFDateTo)
		s eobj.CTLBFMark=pobj.CTLBFMark
		d pobj.%Close()
		k pobj
		s str = eobj.JsonS()
	}
	s str = "{list:["_str_"]}"
	q str
}

/// Creator：基础数据平台-李可凡
/// CreatDate: 2020年8月31日
/// Description：删除医院楼层
/// Table：User.CTLocBuildingFloor
/// Other: w ##class(web.DHCBL.CT.CTLocBuildingFloor).DeleteData("")
ClassMethod DeleteData(id) As %String
{
	s result=""
	s re=..GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	s reason=$p(re,"^",2)
	if (RefFlag=0)
	{
		s pobj=##class(web.Entity.CT.CTLocBuildingFloor).%New()
		s obj=##class(User.CTLocBuildingFloor).%OpenId(id)
		S pobj.CTLBFRowId=id
		s pobj.CTLBFParRef=obj.CTLBFParRef.%Id()
		s pobj.CTLBFChildsub=obj.CTLBFChildsub
		s pobj.CTLBFFloor=obj.CTLBFFloor
		s pobj.CTLBFDateFrom=obj.CTLBFDateFrom
		s pobj.CTLBFDateTo=obj.CTLBFDateTo
		s pobj.CTLBFMark=obj.CTLBFMark
		TS
		s sc=##class(User.CTLocBuildingFloor).%DeleteId(id)
		if $$$ISOK(sc)
		{
			TC
			s result="{success:'true',info:'删除成功！'}"
			s CTLBDesc=$p($g(^CT("CTLB",pobj.CTLBFParRef)),"^",2)
			s CTLBFFloor=CTLBDesc_"-"_pobj.CTLBFFloor
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CTLoc_BuildingFloor","User.CTLocBuildingFloor","医院楼层",id,CTLBFFloor,"D",pobj)
		}
		else 
		{
			TROLLBACK
			s result="{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
			s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医院楼层","web.DHCBL.CT.CTLocBuildingFloor","DeleteData",pobj)
			s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	else
	{
		s result= "{success:'false',info:'"_reason_"'}"	
	}
	q result
}

/// Creator：基础数据平台-李可凡
/// CreatDate: 2020年8月31日
/// function：删除校验
/// debug：d ##class(web.DHCBL.CT.CTLocBuildingFloor).GetRefFleg("")
ClassMethod GetRefFlag(id As %String) As %String
{
	s result=""
	s myInfo=""
	
	//User.CTLoc
	s CTLOCRowID=0
	for 
	{
		s CTLOCRowID=$o(^CTLOC(CTLOCRowID)) q:CTLOCRowID=""
		s CTLOCFloor=$p($g(^CTLOC(CTLOCRowID)),"^",16)      //楼层
		if (CTLOCFloor=id)
		{
			s myInfo=myInfo_"<科室病区>"
			q
		}
	}
	
	//User.PACRoom
	s ROOMRowID=0
	for 
	{
		s ROOMRowID=$o(^PAROOM(ROOMRowID)) q:ROOMRowID=""
		s ROOMFloorDR=$p($g(^PAROOM(ROOMRowID)),"^",11)
		if (ROOMFloorDR=id)
		{
			s myInfo=myInfo_"<房间>"
			q
		}
	}
	
	s:myInfo="" result="0^未被引用可删除！"
	s:myInfo'="" result="1^在"_myInfo_"表里被引用,不能删除！"
	q result
}

/// Creator：基础数据平台-李可凡
/// CreatDate: 2020年8月31日
/// Description：保存医院楼层表
/// Table：User.CTLocBuildingFloor
ClassMethod SaveEntity(eobj As web.Entity.CT.CTLocBuildingFloor) As %String
{
	s result=""
	s:eobj.CTLBFRowId'="" eobj.CTLBFParRef=$p(eobj.CTLBFRowId,"||",1)
	s:eobj.CTLBFDateFrom'="" eobj.CTLBFDateFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.CTLBFDateFrom)
	s:eobj.CTLBFDateTo'="" eobj.CTLBFDateTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.CTLBFDateTo)
	s:eobj.CTLBFDateFrom="" eobj.CTLBFDateFrom=+$h
	s flag=..FormValidate(eobj.CTLBFParRef,eobj.CTLBFRowId,eobj.CTLBFFloor)  //调用重复验证
	if (flag=1)
	{
		s result = "{success:'false',errorinfo:'该记录已经存在！'}"
	}
	else
	{
		if (eobj.CTLBFRowId="")  //如果RowId未赋值则增加
		{
			s obj=##class(User.CTLocBuildingFloor).%New(eobj.CTLBFParRef)
		}
		else                  //如果RowId已赋值则修改
		{
			s obj=##class(User.CTLocBuildingFloor).%OpenId(eobj.CTLBFRowId)
			s bobj=##class(web.Entity.CT.CTLocBuildingFloor).%New()
			s bobj.CTLBFRowId=eobj.CTLBFRowId
			s bobj.CTLBFParRef=obj.CTLBFParRef.%Id()
			s bobj.CTLBFFloor=obj.CTLBFFloor
			s bobj.CTLBFDateFrom=obj.CTLBFDateFrom
			s bobj.CTLBFDateTo=obj.CTLBFDateTo
			s bobj.CTLBFMark=obj.CTLBFMark
		}
		d obj.CTLBFParRefSetObjectId(eobj.CTLBFParRef)
		s obj.CTLBFFloor=eobj.CTLBFFloor
		s obj.CTLBFDateFrom=eobj.CTLBFDateFrom
		s obj.CTLBFDateTo=eobj.CTLBFDateTo
		s obj.CTLBFMark=eobj.CTLBFMark
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result= "{success:'true',id:'"_id_"'}"
			s CTLBDesc=$p($g(^CT("CTLB",eobj.CTLBFParRef)),"^",2)
			s CTLBFFloor=CTLBDesc_"-"_eobj.CTLBFFloor
			d:eobj.CTLBFRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CTLoc_BuildingFloor","User.CTLocBuildingFloor","医院楼层",id,CTLBFFloor,"U",eobj,bobj)
			d:eobj.CTLBFRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CTLoc_BuildingFloor","User.CTLocBuildingFloor","医院楼层",id,CTLBFFloor,"A",eobj)
		}
		else
		{
			Trollback
			s result= "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
			s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医院楼层","web.DHCBL.CT.CTLocBuildingFloor","SaveEntity",eobj)
			s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)  
		}
	}
	q result
}

/// 描述：根据床位ID返回楼层信息
/// 如果床位所属房间有定义楼层，返回房间楼层(楼-楼层)；如果没定义，返回病区对应科室的楼层(房间楼层优先级>科室楼层)
/// 基础数据平台-李可凡
/// 2020年9月1日
/// input：床位ID
/// output：楼层
/// w ##class(web.DHCBL.CT.CTLocBuildingFloor).GetFloorByBedID("1||1")
ClassMethod GetFloorByBedID(id)
{
	s parref=$p(id,"||",1)
	s childsub=$p(id,"||",2)
	q:(parref="")||(childsub="") ""
	s CTLBFFloor=""
	s BEDRoomDR=$p($g(^PAWARD(parref,"BED",childsub)),"^",3)
	if (BEDRoomDR'="")
	{
		s ROOMFloorDR=$p($g(^PAROOM(BEDRoomDR)),"^",11)	//房间的楼层DR
		s CTLBFParRef=$p(ROOMFloorDR,"||",1)
		s CTLBFChildsub=$p(ROOMFloorDR,"||",2)
		if (CTLBFParRef'="")&&(CTLBFChildsub'="")	//房间有定义楼层
		{
			s CTLBDesc=$p($g(^CT("CTLB",CTLBFParRef)),"^",2)		//医院楼描述
			s CTLBFFloor=$p($g(^CT("CTLB",CTLBFParRef,"Floor",CTLBFChildsub)),"^",1)  //楼层
			s CTLBFFloor=CTLBDesc_"-"_CTLBFFloor
			q CTLBFFloor
		}
	}
	if (CTLBFFloor="")	//返回病区所在科室的楼层
	{
		s WARDLocationDR=$p($g(^PAWARD(parref)),"^",5)	//科室
		s CTLOCFloor=$p($g(^CTLOC(WARDLocationDR)),"^",16)      //楼层DR
		s CTLBFParRef=$p(CTLOCFloor,"||",1)
		s CTLBFChildsub=$p(CTLOCFloor,"||",2)
		if (CTLBFParRef'="")&&(CTLBFChildsub'="")	//科室有定义楼层
		{
			s CTLBDesc=$p($g(^CT("CTLB",CTLBFParRef)),"^",2)		//医院楼描述
			s CTLBFFloor=$p($g(^CT("CTLB",CTLBFParRef,"Floor",CTLBFChildsub)),"^",1)  //楼层
			s CTLBFFloor=CTLBDesc_"-"_CTLBFFloor
			q CTLBFFloor
		}
	}
	q CTLBFFloor
}

/// 描述：根据医院楼-楼层描述返回医院楼层id
/// 基础数据平台-likefan
/// 2020-12-02
/// input：医院楼-楼层描述，医院id
/// output：医院楼层id，找不到就返回空
/// w ##class(web.DHCBL.CT.CTLocBuildingFloor).GetFloorIDByDesc("测试楼-2楼","2")
ClassMethod GetFloorIDByDesc(floordesc As %String, hospid As %String) As %String
{
	s result=""
	s CTLBDesc=$p(floordesc,"-",1)	//取医院楼
	s CTLBFDesc=$p(floordesc,"-",2)	//取楼层
	if (CTLBDesc'="")&&(CTLBFDesc'="")&&(hospid'="")
	{
		s CTLBRowId=$o(^CT("CTLB",0,"Desc",$$ALPHAUP^SSUTIL4(CTLBDesc),hospid,0))
		if (CTLBRowId'="")
		{
			s CTLBFChildsub=0
	 		for
	 		{
		 		s CTLBFChildsub=$o(^CT("CTLB",CTLBRowId,"Floor",CTLBFChildsub)) q:CTLBFChildsub=""
		 		s CTLBFFloor=$p($g(^CT("CTLB",CTLBRowId,"Floor",CTLBFChildsub)),"^",1)  //楼层
		 		if (CTLBFFloor=CTLBFDesc)
		 		{
		 			s result=CTLBRowId_"||"_CTLBFChildsub
		 			q
		 		}
	 		}
		}
	}
	q result
}

}
