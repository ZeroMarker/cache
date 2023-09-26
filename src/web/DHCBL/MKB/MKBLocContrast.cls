Class web.DHCBL.MKB.MKBLocContrast Extends %RegisteredObject
{

/// Creator：石萧伟
/// CreatDate: 2018-06-18
/// Description：获取科室列表
/// Table：User.CTLoc
/// Input：RowId1, Code, Desc, CTPCPCarPrvTpDR, ActiveFlag, InternalType
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBLocContrast","GetList","","")
Query GetList(rowid, desc) As %Query(ROWSPEC = "CTLOCRowID,CTLOCCode,CTLOCDesc,MKBLocDescs")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid, desc) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	if (rowid'="") //根据rowid返回该条记录
	{
		s CTLOCRowID=rowid
		s CTLOCDesc=$p($g(^CTLOC(CTLOCRowID)),"^",2)       //科室名
		s CTLOCCode=$p($g(^CTLOC(CTLOCRowID)),"^",1) 		//科室Code
		d OutputRow
	}
	else
	{
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s CTLOCRowID=0
		for
		{
			s CTLOCRowID=$o(^CTLOC(CTLOCRowID)) q:CTLOCRowID=""
			s CTLOCDesc=$p($g(^CTLOC(CTLOCRowID)),"^",2)       //科室名
			s CTLOCDescB=$ZCONVERT(CTLOCDesc,"U")
			s CTLOCCode=$p($g(^CTLOC(CTLOCRowID)),"^",1) 		//科室Code
			s CTLOCCodeB=$ZCONVERT(CTLOCCode,"U")
			
			s MKBLocDr = 0
			s MKBLocDescs = ""
			for
			{
			    s MKBLocDr=$o(^User.MKBLocContrastI("MKBCTLocIndex",CTLOCRowID,MKBLocDr))
				q:MKBLocDr=""
				s MKBTDesc=$LISTGET($G(^User.MKBTermD(MKBLocDr)),3) 
				s:MKBLocDescs'="" MKBLocDescs=MKBLocDescs_","_MKBTDesc
				s:MKBLocDescs="" MKBLocDescs=MKBTDesc
				
				
			}			
			
			
			s PINYIN=""
			s:desc'="" PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(CTLOCDesc)  
			if (desc'="")
			{
				if ((CTLOCDescB[desc) || (PINYIN[desc))
				{
					d OutputRow
				}
			}
			else
			{
				d OutputRow
			}


		}
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(CTLOCRowID,CTLOCCode,CTLOCDesc,MKBLocDescs)
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

/// Creator:石萧伟
/// CreatDate: 2018-06-19
/// Description：对照
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// d ##class(web.DHCBL.MKB.MKBLocContrast).SaveData("8^9")
ClassMethod SaveData(ids As %String) As %String
{
	s result = ""
	s rowid=$p(ids,"^",1) //医用知识库id
    s hisrowid=$p(ids,"^",2) //基础数据平台id
	s desc=$lg($g(^User.MKBTermD(rowid)),3)	
	Ts
	s obj=##class(User.MKBLocContrast).%New()
	d:rowid'="" obj.MKBLocDrSetObjectId(rowid)
	d:hisrowid'="" obj.MKBCTLocDrSetObjectId(hisrowid)
	s logJson="{MKBLocDr:"_$c(34)_rowid_$c(34)_",MKBCTLocDr:"_$c(34)_hisrowid_$c(34)_"}"
	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc){	
		Tc		
		s id = obj.%Id()
		s result = "{success:'true',id:'"_id_"'}" //返回RowId
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("MKB_LocContrast","User.MKBLocContrast","科室对照",id,desc,"A",logJson)
	}else{
		Trollback
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   //返回错误信息
		s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("科室对照","web.DHCBL.MKB.MKBLocContrast","SaveData",logJson)
        s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
	q result
}

/// 判断是否有重复对照
/// shixiaowei
/// w ##class(web.DHCBL.MKB.MKBLocContrast).JustData("17224^1")
ClassMethod JustData(ids)
{
	s rowid=$p(ids,"^",1) //医用知识库id
    s hisrowid=$p(ids,"^",2) //基础数据平台id
	//判断是否已经对照
	s flag="" 
	s flagQ=""
	s flag=$d(^User.MKBLocContrastI("LocIndex",hisrowid,rowid))
	if (flag>0)
	{
		s flagQ="Y"
	}
	else
	{
		s flagQ="N"
	}
	q flagQ
}

/// Creator:删除
/// CreatDate: 2018-06-20
/// 石萧伟
/// Description：删除
/// W ##class(web.DHCBL.MKB.MKBLocContrast).DeleteData("1")
ClassMethod DeleteData(id As %String)
{
  s result=""

  s eobj=##class(web.Entity.MKB.MKBLocContrast).%New()
  s eobj.MKBLCRowId=id
  s eobj.MKBLocDr=$LISTGET($G(^User.MKBLocContrastD(id)),2)
  s eobj.MKBCTLocDr=$LISTGET($G(^User.MKBLocContrastD(id)),3)
  Tstart
  s sc=##class(User.MKBLocContrast).%DeleteId(id)
  IF $$$ISOK(sc) {
   Tc
   s result="{success:'true',info:'删除成功'}"
   //保存日志
   s base=""
   d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_LocContrast","User.MKBLocContrast","科室对照",id,eobj.MKBLCRowId,"D",eobj)
   d ##class(web.DHCBL.BDP.BDPDataHistory).DeleteAll("User.MKBTermLoc"_eobj.MKBCTLocDr)
   d eobj.%Close()
  }
  else 
  {
     Trollback
     s result = "{success:'false',errorinfo:'"_$SYSTEM.Status.GetErrorText(sc)_"'}"
  }
 q result
}

/// Creator：石萧伟
/// CreatDate: 2018-06-20
/// Description：查询已对照内容
/// Input：rowid医用知识库的id
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBLocContrast","GetContrastList","")
Query GetContrastList(id) As %Query(ROWSPEC = "MKBLCRowId,MKBTDesc,MKBTCode,MKBHisLocCode,MKBHisLocDesc")
{
}

ClassMethod GetContrastListExecute(ByRef qHandle As %Binary, id) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	s MKBCTLocDr=0
	for  
	{	
		s MKBCTLocDr=$o(^User.MKBLocContrastI("MKBLocIndex",id,MKBCTLocDr)) 
		q:MKBCTLocDr="" 

		s MKBTDesc=$LISTGET($G(^User.MKBTermD(id)),3)   ///医用知识库科室名称
		s MKBTCode=$LISTGET($G(^User.MKBTermD(id)),2) ///医用知识库科室代码
		s MKBHisLocCode=$p($g(^CTLOC(MKBCTLocDr)),"^",1) 		//科室Code
		s MKBHisLocDesc=$p($g(^CTLOC(MKBCTLocDr)),"^",2) 		//科室Code
		
		s MKBLCRowId=0
		s MKBLCRowId = $o(^User.MKBLocContrastI("MKBLocIndex",id,MKBCTLocDr,MKBLCRowId))
		q:MKBLCRowId=""
		d OutputRow
		
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(MKBLCRowId,MKBTDesc,MKBTCode,MKBHisLocCode,MKBHisLocDesc)
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

/// 李欣
/// 判断科室对照界面是否引用科室
/// w ##class(web.DHCBL.MKB.MKBLocContrast).DeleteJust("17213")
ClassMethod DeleteJust(TermId)
{
	s result=""
	if (TermId'="")
	{
		if ($D(^User.MKBLocContrastI("MKBLocIndex",TermId))'=0)
		{
			s result="该术语已被科室对照引用"	
		}	
	}
	q result
}

/// Creator：石萧伟
/// CreatDate: 2018-07-02
/// Description:根据知识库名称获取id
/// Table：User.MKBTerm
/// Other: w ##class(web.DHCBL.MKB.MKBLocContrast).getTermId("诊断_深圳地区术语")
ClassMethod getTermId(desc)
{
	s Desc=$zcvt(desc,"U")
	s id=""
	s id=$o(^User.MKBTermBaseI("FlagIndex"," "_Desc,0))
	q id
}

}
