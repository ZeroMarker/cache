/// Creator:基础数据平台组-谷雪萍
/// CreatDate:2020-03-19
/// Description：医用知识库医为百科和医嘱对照表 增、删、改、查方法类
/// Table：User.MKBOrderContrast
Class web.DHCBL.MKB.MKBOrderContrast Extends %RegisteredObject
{

/// Creator:谷雪萍
/// CreatDate: 2020-03-19
/// Description：保存对照
/// Input:ids-知识库属性内容id^医嘱项id
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// d ##class(web.DHCBL.MKB.MKBOrderContrast).SaveData("8^9")
ClassMethod SaveData(ids As %String) As %String
{
	s result = ""
	s rowid=$p(ids,"^",1) //知识库属性内容id
    s hisrowid=$p(ids,"^",2) //医嘱项id
    q:(rowid="")||(hisrowid="") "{success:'false',info:'没有传入要对照的数据'}"   //返回错误信息
    s flag=..JustData(rowid,hisrowid)
    q:flag="Y" "{success:'false',info:'该记录已对照, 不能重复对照!'}"	
	s desc=$LISTGET($G(^User.MKBTermProDetailD(rowid)),3)
	Ts
	s obj=##class(User.MKBOrderContrast).%New()
	d:rowid'="" obj.MKBDetailDrSetObjectId(rowid)
	d:hisrowid'="" obj.MKBOrderDrSetObjectId(hisrowid)
	s MKBPropertyDr=$LISTGET($G(^User.MKBTermProDetailD(rowid)),6)
	d:MKBPropertyDr'="" obj.MKBPropertyDrSetObjectId(MKBPropertyDr)
	s logJson="{ID:"_$c(34)_$c(34)_",MKBDetailDr:"_$c(34)_rowid_$c(34)_",MKBOrderDr:"_$c(34)_hisrowid_$c(34)_",MKBPropertyDr:"_$c(34)_MKBPropertyDr_$c(34)_"}"
	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc){	
		Tc		
		s id = obj.%Id()
		s result = "{success:'true',id:'"_id_"'}" //返回RowId
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("MKBOrderContrast","User.MKBOrderContrast","医为百科和医嘱对照表",id,desc,"A",logJson)
	}else{
		Trollback
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   //返回错误信息
	}
	q result
}

/// Creator:谷雪萍
/// CreatDate: 2020-03-19
/// Description：判断重复
/// Input:ids-知识库属性内容id^医嘱项id
/// Return：Y-已经对照/N-没有对照/空-入参为空
/// w ##class(web.DHCBL.MKB.MKBOrderContrast).JustData("17224,1")
ClassMethod JustData(rowid, hisrowid)
{
    q:(rowid="")||(hisrowid="") ""
	//判断是否已经对照
	s flag=$d(^User.MKBOrderContrastI("OrderDrIndex",hisrowid,rowid))
	if (flag>0)
	{
		q "Y"
	}
	else
	{
		q "N"
	}
}

/// Creator:谷雪萍
/// CreatDate: 2020-03-19
/// Description：删除数据
/// Input:id-对照表ID
/// W ##class(web.DHCBL.MKB.MKBOrderContrast).DeleteData("1")
ClassMethod DeleteData(id As %String)
{
	s result=""
	
	s rowid=$LISTGET($G(^User.MKBOrderContrastD(id)),2)
	s hisrowid=$LISTGET($G(^User.MKBOrderContrastD(id)),3)
	s desc=$LISTGET($G(^User.MKBTermProDetailD(rowid)),3)
	s MKBPropertyDr=$LISTGET($G(^User.MKBTermProDetailD(rowid)),6)
	s logJson="{ID:"_$c(34)_id_$c(34)_",MKBDetailDr:"_$c(34)_rowid_$c(34)_",MKBOrderDr:"_$c(34)_hisrowid_$c(34)_",MKBPropertyDr:"_$c(34)_MKBPropertyDr_$c(34)_"}"
	Tstart
	s sc=##class(User.MKBOrderContrast).%DeleteId(id)
	IF $$$ISOK(sc) {
		Tc
		s result="{success:'true',info:'删除成功'}"
		//保存日志
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("MKBOrderContrast","User.MKBOrderContrast","医为百科和医嘱对照表",id,desc,"D",logJson)
	}
	else 
	{
		Trollback
		s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}" 
	}
	q result
}

/// Creator：谷雪萍
/// CreatDate: 2020-03-19
/// Description：查询已对照内容
/// Input：id-医用知识库的id
/// Output：RowId,MKBDetailDesc,ARCIMCode,ARCIMDesc,OrderType
/// Return：对照表id：属性内容描述：医嘱项代码：医嘱项描述：医嘱类型
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBOrderContrast","GetContrastList",id)
Query GetContrastList(id) As %Query(ROWSPEC = "RowId,MKBDetailDesc,ARCIMCode,ARCIMDesc,OrderType")
{
}

ClassMethod GetContrastListExecute(ByRef qHandle As %Binary, id) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (id'="")
	{
		s RowId=0
		for  
		{	
			s RowId=$o(^User.MKBOrderContrastI("DetailDrIndex",id,RowId)) 
			q:RowId="" 
			
			s MKBDetailDesc=$LISTGET($G(^User.MKBTermProDetailD(id)),3)
			s MKBOrderDr=$LISTGET($G(^User.MKBOrderContrastD(RowId)),3)	
			if (MKBOrderDr'="")
			{
				s ARCIMSubscript=$p(MKBOrderDr,"||",1)
				s ARCIMVersion=$p(MKBOrderDr,"||",2)
				if (ARCIMSubscript'="")&(ARCIMVersion'="")
				{
					s ARCIMCode =$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",1)          ; 医嘱代码
					s ARCIMDesc=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)           ; 医嘱名称
					s ItemCatRowid=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",10)      
					s OrderType=""     ;医嘱类型
					s:ItemCatRowid'="" OrderType=$P($g(^ARC("IC",ItemCatRowid)),"^",7)
				}
			}
			d OutputRow
			
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(RowId,MKBDetailDesc,ARCIMCode,ARCIMDesc,OrderType)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetContrastListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetContrastListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
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

/// Creator：谷雪萍
/// CreatDate: 2020-03-19
/// Description：下拉框显示新型冠状病毒肺炎的属性
/// Table：User.MKBTermProperty
/// Input：
/// Output：MKBTPRowId:MKBTPDesc
/// Return：属性id：属性名
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBOrderContrast","GetDataForCmb")
Query GetDataForCmb() As %Query(ROWSPEC = "MKBTPRowId:%String,MKBTPDesc:%String")
{
}

ClassMethod GetDataForCmbExecute(ByRef qHandle As %Binary) As %Status
{
	
	s repid=$I(^CacheTemp)
	s ind=1

	s base=$o(^User.MKBTermBaseI("FlagIndex"," DIAGNOSE",0))
	if (base'="")
	{	
	    s TermId=$o(^User.MKBTermI("DescIndex",base," 新型冠状病毒肺炎",0))
	    if (TermId'="")
	    {
			s MKBTPRowId=0
			for{  
			  s MKBTPRowId=$o(^User.MKBTermPropertyI("TermIndex",TermId,MKBTPRowId)) q:MKBTPRowId=""  
			  s MKBTPDesc=$LISTGET($G(^User.MKBTermPropertyD(MKBTPRowId)),3)
			  if (MKBTPDesc="诊疗_药物")||(MKBTPDesc="诊疗_检查化验")||(MKBTPDesc="诊疗_治疗手术")||(MKBTPDesc="治疗")
			  {
			  	d OutputRowCmb
			  }
			}
	    }
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(MKBTPRowId,MKBTPDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCmbFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmbExecute ]
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

ClassMethod GetDataForCmbClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmbExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:谷雪萍
/// CreatDate: 2020-03-19
/// Description：给CDSS提供接口
/// Input:propertyDesc-属性描述(诊疗_药物\诊疗_检查化验\诊疗_治疗手术\治疗)
/// Output：ARCIMRowId:ARCIMCode:ARCIMDesc:OrderType:
/// Return：医嘱项id：医嘱项代码：医嘱项描述：医嘱类型
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBOrderContrast","GetDataForCDSS","诊疗_药物")
Query GetDataForCDSS(PropertyDesc As %String) As %Query(ROWSPEC = "ARCIMRowId:%String,ARCIMCode:%String,ARCIMDesc:%String,OrderType:%String")
{
}

ClassMethod GetDataForCDSSExecute(ByRef qHandle As %Binary, PropertyDesc As %String) As %Status
{
	
	s repid=$I(^CacheTemp)
	s ind=1
	
	s hospital=##class(web.DHCBL.BDP.FunLib).GetHospId()  //获取医院ID
	s base=$o(^User.MKBTermBaseI("FlagIndex"," DIAGNOSE",0))
	if (base'="")&(PropertyDesc'="")
	{	
	    s TermId=$o(^User.MKBTermI("DescIndex",base," 新型冠状病毒肺炎",0))
	    if (TermId'="")
	    {
		    s PropertyDesc=$ZCONVERT(PropertyDesc,"U")
		    s property=$o(^User.MKBTermPropertyI("DescIndex",TermId," "_PropertyDesc,0))
		    if (property'="")
		    {
			    s ARCIMRowId=0
			    for
			    {
				    s ARCIMRowId=$o(^User.MKBOrderContrastI("PropertyDrIndex",property,ARCIMRowId))
				    q:ARCIMRowId=""
				    if (ARCIMRowId'="")
					{
						s ARCIMSubscript=$p(ARCIMRowId,"||",1)
						s ARCIMVersion=$p(ARCIMRowId,"||",2)
						if (ARCIMSubscript'="")&(ARCIMVersion'="")
						{
							//医嘱项关联医院
							s hasHospFlag=$d(^ARCIM(ARCIMSubscript,ARCIMVersion,"HOSP"))  //存在关联医院
							s isHospFlag=""
							s:hospital'="" isHospFlag=$d(^ARCIM(ARCIMSubscript,ARCIMVersion,"HOSP",0,"Hosp",hospital))  //关联医院中有当前医院
							if (hasHospFlag>0)&&(isHospFlag=0){   //如果存在关联医院且关联医院中没有当前医院
								continue
							} 
							//火神山-医嘱子分类包含关谷的话，只在关谷院区显示
							s catFlag=""
							s ARCIMItemCatDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",10)
							if (ARCIMItemCatDR'="")&&(hospital'="")
							{
								s ARCIMItemCatDRDesc=$p($g(^ARC("IC",ARCIMItemCatDR)),"^",2) 
								s HOSPDesc=$p($g(^CT("HOSP",hospital)),"^",2)
								if ((ARCIMItemCatDRDesc["(光谷)")&(HOSPDesc'["光谷"))
								{
									continue
								}
								 
							}
							s ARCIMCode =$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",1)          ; 医嘱代码
							s ARCIMDesc=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)           ; 医嘱名称
							s ItemCatRowid=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",10)      
							s OrderType=""     ;医嘱类型
							s:ItemCatRowid'="" OrderType=$P($g(^ARC("IC",ItemCatRowid)),"^",7)
							d OutputRowCDSS
						}
					}
			    }
		    }

	    }
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCDSS
    set Data=$lb(ARCIMRowId,ARCIMCode,ARCIMDesc,OrderType)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCDSSFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCDSSExecute ]
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

ClassMethod GetDataForCDSSClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCDSSExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
