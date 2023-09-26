Import dbo

/// 名称:标准版检验-性别
/// 描述:
/// 编写者:基础数据平台组 -钟荣枫
/// 编写日期: 2019-11-5
Class web.DHCBL.LAB.BTSpecies Extends %RegisteredObject
{

/// Creator：钟荣枫 		
/// CreatDate: 2019-11-7
/// Description：查询 性别下拉框
/// Table:dbo.BT_Species
/// Input:id, code, desc
/// Output:RowId,Code,Desc
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.LAB.BTSpecies","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "RowID,Code,CName")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s RowID=rowid
		
		//^dbo.BTSpeciesD(1)=$lb("","M","男",0,"","")
		s Code= $lg($g(^dbo.BTSpeciesD(RowID)),2)		//代码
		s CName= $lg($g(^dbo.BTSpeciesD(RowID)),3)		//名称
		d OutputRowCmb
	}
	else
	{
		
		s:code'="" code=$ZCONVERT(code,"U") //转换成大写
		s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
		s RowID=0
		for 
		{
			s RowID=$o(^dbo.BTSpeciesD(RowID))
			q:RowID=""
			s Code= $lg($g(^dbo.BTSpeciesD(RowID)),2)		//代码
			s CName= $lg($g(^dbo.BTSpeciesD(RowID)),3)		//名称
			if (desc'="")           
			{
				;需要对描述或者别名进行检索 
				s AliasFlag=0     
				s PINYINFlag=""
				s PINYINCODE=""   
		        s PINYINFlag=##class(web.DHCBL.BDP.BDPAlias).GetPINYINFlag(desc) /// 是拼音 才去转换拼音码
		        if (PINYINFlag=1)
		        {
		          s PINYINCODE=##class(web.DHCBL.BDP.FunLib).GetPYCODE(CName) 
		        }
				if ((CName[desc)||(PINYINCODE[desc)) 
				{
					s AliasFlag= 1	
				} 
			}
			else
			{
				s AliasFlag= 1
			} 
			i ($ZCONVERT(Code,"U")[code)&&(AliasFlag=1) //包含
			{
				d OutputRowCmb
			}
		}
			
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(RowID,Code,CName)
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

/// Creator：杨帆
/// CreatDate: 2019-11-25
/// Description：查询性别表的内容
/// Table：dbo.BT_Species
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.LAB.BTSpecies","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "RowID:%String,Code:%String,CName:%String,Pregnant:%String,HISCode:%String,STDCode:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s RowID = rowid
		s Code= $lg($g(^dbo.BTSpeciesD(RowID)),2)		//代码
		s CName= $lg($g(^dbo.BTSpeciesD(RowID)),3)		//名称
		s Pregnant = $lg($g(^dbo.BTSpeciesD(RowID)),4)  //是否怀孕
        s Pregnant=$CASE(Pregnant,"1":"Y",:"N")
		s HISCode = $lg($g(^dbo.BTSpeciesD(RowID)),5)   //HIS代码
		s STDCode = $lg($g(^dbo.BTSpeciesD(RowID)),6)   //STD代码
		
		d OutputRow
	}
	else
	{
		s RowID=0
		for 
		{
			s RowID=$o(^dbo.BTSpeciesD(RowID)) q:RowID=""
			s Code = $lg($g(^dbo.BTSpeciesD(RowID)),2)		//代码
			s CName = $lg($g(^dbo.BTSpeciesD(RowID)),3)		//名称
			s Pregnant = $lg($g(^dbo.BTSpeciesD(RowID)),4)  //是否怀孕
   			s Pregnant=$CASE(Pregnant,"1":"Y",:"N")
			s HISCode = $lg($g(^dbo.BTSpeciesD(RowID)),5)   //HIS代码
			s STDCode = $lg($g(^dbo.BTSpeciesD(RowID)),6)   //STD代码
			if (desc'="")           
			{
				;需要对描述或者别名进行检索 
				s AliasFlag=0     
				s PINYINFlag=""
				s PINYINCODE=""   
		        s PINYINFlag=##class(web.DHCBL.BDP.BDPAlias).GetPINYINFlag(desc) /// 是拼音 才去转换拼音码
		        if (PINYINFlag=1)
		        {
		          s PINYINCODE=##class(web.DHCBL.BDP.FunLib).GetPYCODE(CName) 
		        }
				if ((CName[desc)||(PINYINCODE[desc))  
				{
					s AliasFlag= 1	
				} 
			}
			else
			{
				s AliasFlag= 1
			} 
			i ($ZCONVERT(Code,"U")[code)&&(AliasFlag=1) //包含)
			{
				d OutputRow
			}
			
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(RowID,Code,CName,Pregnant,HISCode,STDCode)
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

/// Creator:杨帆 
/// CreatDate:2019-11-25
/// Description:数据重复验证方法,js调用
/// Table:dbo.BT_Species
/// Input:id, code, desc
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.DHCBL.LAB.BTSpecies).FormValidate("","M")
ClassMethod FormValidate(id As %String, code As %String) As %String
{
	s flag=0
	if (code'="")
	{
		s RowID=$o(^dbo.BTSpeciesI("IndexCode",##Class(web.DHCBL.BDP.FunLib).IndexData(code),0))
		if (RowID'="")&&(id'=RowID) s flag=1
	}
	
	q flag
}

/// Creator：杨帆 
/// CreatDate: 2019-11-25
/// Description：新增，修改时打开Form，根据RowId查询
/// Table：dbo.BT_Species
/// Input：RowId
/// Other: w ##class(web.DHCBL.LAB.BTSpecies).OpenData(2)
ClassMethod OpenData(id As %String) As %String
{
    s str = ""
	s pobj = ##class(dbo.BTSpecies).%OpenId(id) 
	s eobj = ##class(web.Entity.LAB.BTSpecies).%New() 
	s eobj.RowID = id
	s eobj.Code = pobj.Code
	s eobj.CName = pobj.CName
	s eobj.Pregnant=pobj.Pregnant
	s eobj.HISCode = pobj.HISCode
	s eobj.HISCode = ##class(web.DHCBL.BDP.FunLib).EvalJSON(eobj.HISCode)
	s eobj.STDCode=pobj.STDCode
	s eobj.STDCode = ##class(web.DHCBL.BDP.FunLib).EvalJSON(eobj.STDCode)
	d pobj.%Close()
	kill pobj
	s str = eobj.JsonS()
	//s str = "{list:["_str_"]}"
	q str
}

/// Creator:杨帆 
/// CreatDate: 2019-11-25
/// Description：保存 性别
/// Input: eobj As web.Entity.LAB.BTSpecies
/// Table：dbo.BT_Species
/// Return:成功返回true，失败返回false
/// Other:w ##class(web.DHCBL.LAB.BTSpecies).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.LAB.BTSpecies) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		s:eobj.Pregnant="" eobj.Pregnant="0"
		s flag=..FormValidate(eobj.RowID,eobj.Code)  //调用重复验证
		if (flag=1)
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		if (eobj.RowID="")
		{
			s obj=##class(dbo.BTSpecies).%New()
		}
		else
		{
			s obj=##class(dbo.BTSpecies).%OpenId(eobj.RowID)
			s bobj=##class(web.Entity.LAB.BTSpecies).%New()
			s bobj.RowID = eobj.RowID		//RowID
			s bobj.Code = obj.Code		    //代码
			s bobj.CName = obj.CName		//性别
			s bobj.Pregnant=obj.Pregnant	//是否怀孕
			s bobj.HISCode = obj.HISCode	//HIS代码
			s bobj.STDCode=obj.STDCode		//STD代码
		}
		s obj.Code = eobj.Code		    //代码
		s obj.CName = eobj.CName		//性别
		S obj.Pregnant=eobj.Pregnant	//是否怀孕
		s obj.HISCode = eobj.HISCode	//HIS代码
		s obj.STDCode=eobj.STDCode		//STD代码
		TSTART
		s sc=obj.%Save()
		if (sc=1)
		{
			TCOMMIT
			s id=obj.%Id()
			s result="{success:'true',id:'"_id_"'}"
			d:eobj.RowID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("dbo.BT_Species","dbo.BTSpecies","性别",eobj.RowID,eobj.CName,"U",eobj,bobj)
    		d:eobj.RowID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("dbo.BT_Species","dbo.BTSpecies","性别",id,eobj.CName,"A",eobj)
		}
		else
		{
			TROLLBACK
			s result="{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
		}
		
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

/// Creator:杨帆
/// CreatDate:2019-11-25
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
/// Other: w ##class(web.DHCBL.LAB.BTSpecies).GetRefFlag(1)
ClassMethod GetRefFlag(id As %String) As %String
{
	s return="",myInfo=""
	//dbo.BTTestSet
	s TestSetRowID=0
	for 
	{
		s TestSetRowID=$o(^dbo.BTTestSetD(TestSetRowID))
		q:TestSetRowID=""
		s SpeciesDR= $lg($g(^dbo.BTTestSetD(TestSetRowID)),8)
		if (SpeciesDR=id)
		{
			s myInfo=myInfo_"<项目组合套表>"
			q
		}
	}
	//dbo.RPVisitNumber
	s VisitNumberRowID=0
	for 
	{
		s VisitNumberRowID=$o(^dbo.RPVisitNumberD(VisitNumberRowID))
		q:VisitNumberRowID=""
		s SpeciesDR=$lg($g(^dbo.RPVisitNumberD(VisitNumberRowID)),15)
		if (SpeciesDR=id)
		{
			s myInfo=myInfo_"<参观人员>"
			q
		}
	}
	//dbo.BDAgreeForm
	s AgreeFormRowID=0
	for 
	{
		s AgreeFormRowID=$o(^dbo.BDAgreeFormD(AgreeFormRowID))
		q:AgreeFormRowID=""
		s SpeciesDR=$lg($g(^dbo.BDAgreeFormD(AgreeFormRowID)),11)
		if (SpeciesDR=id)
		{
			s myInfo=myInfo_"<同意书>"
			q
		}
	}
	
	i myInfo="" s return="0^未被引用可删除！"
	else  s return="1^在"_myInfo_"表里被引用,不能删除！"
	q return
}

/// Creator：杨帆
/// CreatDate: 2019-11-25
/// Description：根据id删除 性别
/// Table：dbo.BT_Species
/// Input：id 
/// Return：成功返回true，失败返回false和info
/// Other: w ##class(web.DHCBL.LAB.BTSpecies).DeleteData(1)
ClassMethod DeleteData(id) As %String
{
	s result=""
	s re=##class(web.DHCBL.LAB.BTSpecies).GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	if (RefFlag=0){
		s pobj = ##class(dbo.BTSpecies).%OpenId(id)
		s eobj = ##class(web.Entity.LAB.BTSpecies).%New()
		s eobj.Code = pobj.Code
		s eobj.CName = pobj.CName
		s eobj.Pregnant=pobj.Pregnant
		s eobj.HISCode = pobj.HISCode
		s eobj.STDCode=pobj.STDCode
		
		d pobj.%Close()
		kill pobj
		Tstart
		s sc=##class(dbo.BTSpecies).%DeleteId(id)
		IF $$$ISOK(sc){
			Tc
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("dbo.BT_Species","dbo.BTSpecies","性别",id,eobj.CName,"D",eobj)
		}
		else{
			Trollback
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("性别","web.DHCBL.LAB.BTSpecies","DeleteData",eobj)
			s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		}
	}else{
		s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"	
	}
	
	
	q result
}

/// Creator:钟荣枫
/// CreatDate:2020-1-21
/// Description:通过性别代码获取性别rowid
/// w ##class(web.DHCBL.LAB.BTSpecies).GetRowIdByCode("M")
ClassMethod GetRowIdByCode(code As %String) As %String
{
	S ROWID=""
	if (code'="")
	{
		s ROWID=$O(^dbo.BTSpeciesI("IndexCode",##Class(web.DHCBL.BDP.FunLib).IndexData(code),0))
	}
	q ROWID
}

}
