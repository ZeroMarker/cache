/// 名称:标准版检验维护界面-医院
/// 描述:包含增删改查等功能
/// 编写者:基础数据平台-李可凡
/// 编写日期: 2019年11月22日
Class web.DHCBL.LAB.BTHospital Extends %RegisteredObject
{

/// Creator：钟荣枫 		
/// CreatDate: 2019-11-7
/// Description：查询 医院 下拉框
/// Table:dbo.BT_Hospital
/// Input:id, code, desc
/// Output:RowId,Code,Desc
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.LAB.BTHospital","GetDataForCmb1","","")
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
		s Code= $lg($g(^dbo.BTHospitalD(RowID)),2)		//代码
		s CName= $lg($g(^dbo.BTHospitalD(RowID)),3)		//名称
		
		d OutputRowCmb
	}
	else
	{
		k ^combosort("dbo.BTHospital")
		s:code'="" code=$ZCONVERT(code,"U") //转换成大写
		s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
		s RowID=0
		for 
		{
			s RowID=$o(^dbo.BTHospitalD(RowID))
			q:RowID=""
			s Code= $lg($g(^dbo.BTHospitalD(RowID)),2)		//代码
			s CName= $lg($g(^dbo.BTHospitalD(RowID)),3)		//名称
			s Active= $lg($g(^dbo.BTHospitalD(RowID)),11)		//激活标识
			s Sequence= $lg($g(^dbo.BTHospitalD(RowID)),10)		//序号,排序用
			continue:Active'=1				//过滤未激活状态数据
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
				s:Sequence="" Sequence=" "
			 	s ^combosort("dbo.BTHospital",Sequence,RowID)=""
				//d OutputRowCmb
			}
		}
		//按照排序输出
		s Sort=""
		for
		{
			s Sort=$o(^combosort("dbo.BTHospital",Sort)) q:Sort=""
			s RowID=""
			for
			{
				s RowID=$o(^combosort("dbo.BTHospital",Sort,RowID))  q:RowID=""
				s Code= $lg($g(^dbo.BTHospitalD(RowID)),2)		//代码
				s CName= $lg($g(^dbo.BTHospitalD(RowID)),3)		//名称
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

/// Creator：基础数据平台-李可凡
/// CreatDate: 2019年11月15日
/// Description：查询医院表
/// Table：dbo.BT_Hospital
/// d ##class(%ResultSet).RunQuery("web.DHCBL.LAB.BTHospital","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "RowID,Code,CName,FullDesc,Sequence,Active")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	
 	if (rowid'="")
 	{
		s RowID=rowid
		s Code= $lg($g(^dbo.BTHospitalD(RowID)),2)		//代码
		s CName= $lg($g(^dbo.BTHospitalD(RowID)),3)		//名称
		s FullDesc= $lg($g(^dbo.BTHospitalD(RowID)),4)		//全称
		s Sequence= $lg($g(^dbo.BTHospitalD(RowID)),10)		//序号
		s Active= $lg($g(^dbo.BTHospitalD(RowID)),11)		//激活标识
		s Active=$CASE(Active,"1":"Y",:"N")
		d OutputRow
	 }
	 else
	 {
		k ^tempsequencesort("dbo.BTHospital")
		s:code'="" code=$ZCONVERT(code,"U")
		s:desc'="" desc=$ZCONVERT(desc,"U")	 
	 	s RowID=0
	 	for
	 	{
		 	s RowID=$o(^dbo.BTHospitalD(RowID))
		 	q:RowID=""
		 	s Code= $lg($g(^dbo.BTHospitalD(RowID)),2)		//代码
			s CName= $lg($g(^dbo.BTHospitalD(RowID)),3)		//名称
			s Sequence= $lg($g(^dbo.BTHospitalD(RowID)),10)		//序号
		 	s PINYIN=""
		 	s:desc'="" PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(CName)
		 	if ($ZCONVERT(Code,"U")[code)&(($ZCONVERT(CName,"U")[desc)||(PINYIN[desc))
		 	{
				s:Sequence="" Sequence=" "
			 	s ^tempsequencesort("dbo.BTHospital",Sequence,RowID)=""
			}
		}
		s Sort=""
		for
		{
			s Sort=$o(^tempsequencesort("dbo.BTHospital",Sort)) q:Sort=""
			s RowID=""
			for
			{
				s RowID=$o(^tempsequencesort("dbo.BTHospital",Sort,RowID))  q:RowID=""
				s Code=$lg($g(^dbo.BTHospitalD(RowID)),2)		//代码
				s CName=$lg($g(^dbo.BTHospitalD(RowID)),3)		//名称
				s FullDesc=$lg($g(^dbo.BTHospitalD(RowID)),4)		//全称
				s Sequence=$lg($g(^dbo.BTHospitalD(RowID)),10)		//序号
				s Active=$lg($g(^dbo.BTHospitalD(RowID)),11)		//激活标识
				s Active=$CASE(Active,"1":"Y",:"N")
				d OutputRow
			}
		} 	
	 }
 	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(RowID,Code,CName,FullDesc,Sequence,Active)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
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

/// Creator：基础数据平台-李可凡
/// CreatDate: 2019年11月15日
/// Description：查询医院表
/// Table：dbo.BT_Hospital
/// Input：id
/// Others：w ##class(web.DHCBL.LAB.BTHospital).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
	 s str=""
	 s obj = ##class(dbo.BTHospital).%OpenId(id)
	 s eobj = ##class(web.Entity.LAB.BTHospital).%New()
	 s eobj.RowID = id				// RowID
	 s eobj.Code=obj.Code			// 代码
	 s eobj.CName= obj.CName		// 名称
	 s eobj.FullDesc=obj.FullDesc		// 全称
	 s eobj.Sequence=obj.Sequence		// 序号
	 s eobj.Active=obj.Active			// 状态
	 d obj.%Close()
	 k obj
	 s str = eobj.JsonS()
	 //s str = "{list:["_str_"]}"
	 q str
}

/// Creator：基础数据平台-李可凡
/// CreatDate: 2019年11月15日
/// Description：删除医院表
/// Table：dbo.BT_Hospital
/// Others：w ##class(web.DHCBL.LAB.BTHospital).DeleteData(19)
ClassMethod DeleteData(id As %String) As %String
{
	s result=""
	if (id'="")
	{
		s re=..GetRefFlag(id)
		s RefFlag=$p(re,"^",1)
		s reason=$p(re,"^",2)
		if (RefFlag=0)
		{
			s obj = ##class(dbo.BTHospital).%OpenId(id)
			s pobj = ##class(web.Entity.LAB.BTHospital).%New()
			s pobj.RowID = id				// RowID
			s pobj.Code=obj.Code			// 代码
			s pobj.CName= obj.CName		// 名称
			s pobj.FullDesc=obj.FullDesc		// 全称
			s pobj.Sequence=obj.Sequence		// 序号
			s pobj.Active=obj.Active			// 状态
			TSTART
			s sc=##class(dbo.BTHospital).%DeleteId(id)
			if (sc=1)
			{
				TCOMMIT
				s result="{success:'true',info:'删除成功！'}"
				d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("dbo.BT_Hospital","dbo.BTHospital","医院",id,pobj.CName,"D",pobj)
			}
			else
			{
				TROLLBACK
				s result="{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
			}
		}
		else
		{
			s result= "{success:'false',info:'"_reason_"'}"	
		}
	}
	else
	{
		s result="{success:'false',info:'数据不存在！'}"
	}
	q result
}

/// Creator：基础数据平台-李可凡
/// CreatDate: 2019年11月15日
/// Description：数据重复校验
/// Table：dbo.BT_Hospital
/// Input:id,code
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.DHCBL.LAB.BTHospital).FormValidate("17","CSZY")
ClassMethod FormValidate(id As %String, code As %String) As %String
{
	s flag=0
	if code'=""
	{
		s RowID=$o(^dbo.BTHospitalI("IndexCode",##Class(web.DHCBL.BDP.FunLib).IndexData(code),0))
		if (RowID'="")&&(id'=RowID) s flag=1
	}
	q flag
}

/// Creator：基础数据平台-李可凡
/// CreatDate: 2019年11月15日
/// function:医院表的新增修改
/// Table：dbo.BT_Hospital
ClassMethod SaveEntity(eobj As web.Entity.LAB.BTHospital) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		s:eobj.Active="" eobj.Active="0"
		s flag=..FormValidate(eobj.RowID,eobj.Code)  //调用重复验证
		if (flag=1)
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		if (eobj.RowID="")
		{
			s obj=##class(dbo.BTHospital).%New()
		}
		else
		{
			s obj=##class(dbo.BTHospital).%OpenId(eobj.RowID)
			s bobj=##class(web.Entity.LAB.BTHospital).%New()
		    s bobj.RowID=eobj.RowID		// RowID
		    s bobj.Code=obj.Code		// 代码
			s bobj.CName= obj.CName		// 名称
			s bobj.FullDesc=obj.FullDesc		// 全称
			s bobj.Sequence=obj.Sequence		// 序号
			s bobj.Active=obj.Active			// 状态
		}
		s obj.Code=eobj.Code		// 代码
		s obj.CName= eobj.CName		// 名称
		s obj.FullDesc= eobj.FullDesc		// 全称
		s obj.Sequence=eobj.Sequence		// 序号
		s obj.Active=eobj.Active			// 状态
		TSTART
		s sc=obj.%Save()
		if (sc=1)
		{
			TCOMMIT
			s id=obj.%Id()
			s result="{success:'true',id:'"_id_"'}"
			d:eobj.RowID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("dbo.BT_Hospital","dbo.BTHospital","医院",eobj.RowID,eobj.CName,"U",eobj,bobj)
			d:eobj.RowID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("dbo.BT_Hospital","dbo.BTHospital","医院",id,eobj.CName,"A",eobj)
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

/// Creator：基础数据平台-李可凡
/// CreatDate: 2019年11月22日
/// function：删除时验证数据是否被引用
/// Debug：w ##class(web.DHCBL.LAB.BTHospital).GetRefFlag(1)
ClassMethod GetRefFlag(id As %String) As %String
{
	s return=""
	s myInfo=""
	//dbo.BTTestSet
	if $d(^dbo.BTTestSetI("IndexCode",id)) s myInfo=myInfo_"<项目组合套>"
	//dbo.BTContainer
	if $d(^dbo.BTContainerI("IndexCode",id)) s myInfo=myInfo_"<采集容器>"
	//dbo.BTSpecimen
	if $d(^dbo.BTSpecimenI("IndexCode",id)) s myInfo=myInfo_"<标本类型>"
	//dbo.BTCollectPrompt
	if $d(^dbo.BTCollectPromptI("IndexCode",id)) s myInfo=myInfo_"<采集提示>"
	//dbo.BTReportPrompt
	if $d(^dbo.BTReportPromptI("IndexCode",id)) s myInfo=myInfo_"<取报告提示>"
	//dbo.BTRoom
	if $d(^dbo.BTRoomI("IndexCode",id)) s myInfo=myInfo_"<所在房间>"
	//dbo.BTDepartment
	if $d(^dbo.BTDepartmentI("IndexCode",id)) s myInfo=myInfo_"<科室>"
	//dbo.BTSpecimenGroup
	if $d(^dbo.BTSpecimenGroupI("IndexCode",id)) s myInfo=myInfo_"<标本组>"
	//dbo.BTTestSetGroup
	if $d(^dbo.BTTestSetGroupI("IndexCode",id)) s myInfo=myInfo_"<合管组合套分组>"
	//dbo.BBTextList
	if $d(^dbo.BBTextListI("IndexCode",id)) s myInfo=myInfo_"<dbo.BBTextList>"
	s:myInfo="" return="0^未被引用可删除！"
	s:myInfo'="" return="1^在"_myInfo_"表里被引用,不能删除！"
	q return
}

/// Creator:钟荣枫
/// CreatDate:2020-1-17
/// Description:通过医院代码获取医院rowid
/// w ##class(web.DHCBL.LAB.BTHospital).GetRowIdByCode("BJXHYY")
ClassMethod GetRowIdByCode(code As %String) As %String
{
	S ROWID=""
	if (code'="")
	{
		s ROWID=$O(^dbo.BTHospitalI("IndexCode",##Class(web.DHCBL.BDP.FunLib).IndexData(code),0))
	}
	q ROWID
}

}
