/// 名称:标准版检验-标准码
/// 描述:包含增删改查功能
/// 编写者:基础数据平台组 -钟荣枫
/// 编写日期: 2020-3-6
Class web.DHCBL.LAB.BTTestCodeSCode Extends %RegisteredObject
{

/// Creator：钟荣枫 		
/// CreatDate: 2019-11-15
/// Description：查询 标准码 
/// Table:dbo.BTTestCodeSCode
/// Input:id, code, desc,
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.LAB.BTTestCodeSCode","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "RowID,SCode,TCName,SpecimenType,Sequence,Active")
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
		;RowID,SCode,TCName,SpecimenType,Sequence,Active
		s RowID=rowid
		s SCode= $lg($g(^dbo.BTTestCodeSCodeD(RowID)),2)		//代码
		s TCName= $lg($g(^dbo.BTTestCodeSCodeD(RowID)),3)		//名称
		s SpecimenType= $lg($g(^dbo.BTTestCodeSCodeD(RowID)),4)		//类型
		s Sequence=$lg($g(^dbo.BTTestCodeSCodeD(RowID)),5)		//序号
		s Active=$lg($g(^dbo.BTTestCodeSCodeD(RowID)),6)		//激活
		s:Active="" Active=1		
		d OutputRow
	}
	else
	{
		k ^tempsequencesort("dbo.BTTestCodeSCode")
		s RowID=0
		for 
		{
			s RowID=$o(^dbo.BTTestCodeSCodeD(RowID))
			q:RowID=""
			s SCode= $lg($g(^dbo.BTTestCodeSCodeD(RowID)),2)		//代码
			s TCName= $lg($g(^dbo.BTTestCodeSCodeD(RowID)),3)		//名称
			s SpecimenType= $lg($g(^dbo.BTTestCodeSCodeD(RowID)),4)		//类型
			s Sequence=$lg($g(^dbo.BTTestCodeSCodeD(RowID)),5)		//序号
			s Active=$lg($g(^dbo.BTTestCodeSCodeD(RowID)),6)		//激活
			s:Active="" Active=1		
			if (desc'="")           
			{
				;需要对描述或者别名进行检索 
				s AliasFlag=0     
				s PINYINFlag=""
				s PINYINCODE=""   
		        s PINYINFlag=##class(web.DHCBL.BDP.BDPAlias).GetPINYINFlag(desc) /// 是拼音 才去转换拼音码
		        if (PINYINFlag=1)
		        {
		          s PINYINCODE=##class(web.DHCBL.BDP.FunLib).GetPYCODE(TCName) 
		        }
				if (($ZCONVERT(TCName,"U")[desc)||(PINYINCODE[desc))  
				{
					s AliasFlag= 1	
				} 
			}
			else
			{
				s AliasFlag= 1
			} 
			i ($ZCONVERT(SCode,"U")[code)&&(AliasFlag=1) //包含)
			{
				s:Sequence="" Sequence=" "_Sequence
				s ^tempsequencesort("dbo.BTTestCodeSCode",Sequence,RowID)=RowID
			}
			
		}
		s SequenceSort=""
		for
		{
			s SequenceSort=$o(^tempsequencesort("dbo.BTTestCodeSCode",SequenceSort))  q:SequenceSort=""
			s RowIDSort=""
			for
			{
				s RowIDSort=$o(^tempsequencesort("dbo.BTTestCodeSCode",SequenceSort,RowIDSort))  q:RowIDSort=""
				s RowID=RowIDSort
				s SCode= $lg($g(^dbo.BTTestCodeSCodeD(RowID)),2)		//代码
				s TCName= $lg($g(^dbo.BTTestCodeSCodeD(RowID)),3)		//名称
				s SpecimenType= $lg($g(^dbo.BTTestCodeSCodeD(RowID)),4)		//医院
				s Sequence=$lg($g(^dbo.BTTestCodeSCodeD(RowID)),5)		//序号
				s Active=$lg($g(^dbo.BTTestCodeSCodeD(RowID)),6)		//激活
				s:Active="" Active=1		
				d OutputRow
			}
		} 				
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(RowID,SCode,TCName,SpecimenType,Sequence,Active)
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

/// Creator：钟荣枫 		
/// CreatDate: 2020-3-9
/// Description：查询 标准码 下拉框
/// Table:dbo.BTTestCodeSCode
/// Input:id, code, desc
/// Output:RowId,Code,Desc
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.LAB.BTTestCodeSCode","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "RowID,SCode,TCName")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s RowID=rowid
		s SCode= $lg($g(^dbo.BTTestCodeSCodeD(RowID)),2)		//代码
		s TCName= $lg($g(^dbo.BTTestCodeSCodeD(RowID)),3)		//名称
		s TCName=SCode_"--"_TCName
		d OutputRowCmb
	}
	else
	{
		k ^tempsequencecombosort("dbo.BTTestCodeSCode")
		s:code'="" code=$ZCONVERT(code,"U") //转换成大写
		s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
		s RowID=0
		for 
		{
			s RowID=$o(^dbo.BTTestCodeSCodeD(RowID))
			q:RowID=""
			s SCode= $lg($g(^dbo.BTTestCodeSCodeD(RowID)),2)		//代码
			s TCName= $lg($g(^dbo.BTTestCodeSCodeD(RowID)),3)		//名称
			s Sequence=$lg($g(^dbo.BTTestCodeSCodeD(RowID)),5)		//序号
			s Active=$lg($g(^dbo.BTTestCodeSCodeD(RowID)),6)		//激活
			continue:Active=0				//过滤未激活状态数据
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
				if (($ZCONVERT(TCName,"U")[desc)||(PINYINCODE[desc)) 
				{
					s AliasFlag= 1	
				} 
			}
			else
			{
				s AliasFlag= 1
			} 
			i ($ZCONVERT(SCode,"U")[code)&&(AliasFlag=1) //包含
			{
				s:Sequence="" Sequence=" "_Sequence
				s ^tempsequencecombosort("dbo.BTTestCodeSCode",Sequence,RowID)=RowID
			}
			
		}
		s SequenceSort=""
		for
		{
			s SequenceSort=$o(^tempsequencecombosort("dbo.BTTestCodeSCode",SequenceSort))  q:SequenceSort=""
			s RowIDSort=""
			for
			{
				s RowIDSort=$o(^tempsequencecombosort("dbo.BTTestCodeSCode",SequenceSort,RowIDSort))  q:RowIDSort=""
				s RowID=RowIDSort
				s SCode= $lg($g(^dbo.BTTestCodeSCodeD(RowID)),2)		//代码
				s TCName= $lg($g(^dbo.BTTestCodeSCodeD(RowID)),3)		//名称
				s TCName=SCode_"--"_TCName
				d OutputRowCmb
			}
		}
		
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(RowID,SCode,TCName)
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

/// Creator:钟荣枫 
/// CreatDate:2020-3-9
/// Description:数据重复验证方法,js调用
/// Table:dbo.BTTestCodeSCode
/// Input:id, code, desc,hosp
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.DHCBL.LAB.BTTestCodeSCode).FormValidate("4","s001")
ClassMethod FormValidate(id As %String, code As %String) As %String
{
	
	s flag=0
	if code'=""
	{
		s RowID=$o(^dbo.BTTestCodeSCodeI("IndexSCode",##Class(web.DHCBL.BDP.FunLib).IndexData(code),0))
		if (RowID'="")&&(id'=RowID)
		{
			s flag=1
		}
	}
	
	q flag
}

/// Creator：钟荣枫 
/// CreatDate: 2020-3-9
/// Description：新增，修改时打开Form，根据RowId查询
/// Table：dbo.BTTestCodeSCode
/// Input：id
/// Other: w ##class(web.DHCBL.LAB.BTTestCodeSCode).OpenData(1,"")
/// RetFlag=""时，用于EXT, =JSON时，用于HISUI，不输出 "{list:["_str_"]}"
ClassMethod OpenData(id As %String, RetFlag As %String = "") As %String
{
	;RowID,SCode,TCName,SpecimenType,Sequence,Active
    s str = ""
	s pobj = ##class(dbo.BTTestCodeSCode).%OpenId(id) 
	s eobj = ##class(web.Entity.LAB.BTTestCodeSCode).%New() 
	s eobj.RowID = id
	s eobj.SCode = pobj.SCode		//代码
	s eobj.TCName = pobj.TCName		//描述
	s eobj.SpecimenType=pobj.SpecimenType	//类型
	s eobj.Sequence = pobj.Sequence			//序号
	s eobj.Active=pobj.Active				//激活
	d pobj.%Close()
	kill pobj
	s str = eobj.JsonS()
	if (RetFlag'="JSON")
	{
		s str = "{list:["_str_"]}"
	}
	q str
}

/// Creator:钟荣枫
/// CreatDate:2020-3-9
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
/// Other: w ##class(web.DHCBL.LAB.BTTestCodeSCode).GetRefFlag(2)
ClassMethod GetRefFlag(id As %String) As %String
{
	s return="",myInfo=""
	//dbo.BTTestCode
	s TestCodeRowID=0
	for 
	{
		s TestCodeRowID=$o(^dbo.BTTestCodeD(TestCodeRowID))
		q:TestCodeRowID=""
		s SCode= $lg($g(^dbo.BTTestCodeD(TestCodeRowID)),14)	
		if (SCode=id)
		{
			s myInfo=myInfo_"<检测项目>"
			q
		}
	}
	//dbo.BTDiseaseType
	s DYRowID=0
	for 
	{
		s DYRowID=$o(^dbo.BTDiseaseTypeD(DYRowID))
		q:DYRowID=""
		s SCode= $lg($g(^dbo.BTDiseaseTypeD(DYRowID)),5)	
		if (SCode=id)
		{
			s myInfo=myInfo_"<病种>"
			q
		}
	}
	
	i myInfo="" s return="0^未被引用可删除！"
	else  s return="1^在"_myInfo_"表里被引用,不能删除！"
	q return
}

/// Creator：钟荣枫 
/// CreatDate: 2020-3-9
/// Description：根据id删除 标准码
/// Table：dbo.BTTestCodeSCode
/// Input：id 
/// Return：成功返回true，失败返回false和info
/// Other: w ##class(web.DHCBL.LAB.BTTestCodeSCode).DeleteData(1)
ClassMethod DeleteData(id) As %String
{
	s result=""
	s re=##class(web.DHCBL.LAB.BTTestCodeSCode).GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	if (RefFlag=0){
		
		s pobj = ##class(dbo.BTTestCodeSCode).%OpenId(id)
		s eobj = ##class(web.Entity.LAB.BTTestCodeSCode).%New()
		s eobj.SCode = pobj.SCode
		s eobj.TCName = pobj.TCName
		s eobj.SpecimenType=pobj.SpecimenType
		s eobj.Sequence = pobj.Sequence
		s eobj.Active=pobj.Active
		
		d pobj.%Close()
		kill pobj
		Tstart
		s sc=##class(dbo.BTTestCodeSCode).%DeleteId(id)
		IF $$$ISOK(sc){
			Tc
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("dbo.BT_TestCodeSCode","dbo.BTTestCodeSCode","标准码",id,eobj.TCName,"D",eobj)
		}
		else{
			Trollback
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("标准码","web.DHCBL.LAB.BTTestCodeSCode","DeleteData",eobj)
			s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		}
	}else{
		s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"	
	}
	
	
	q result
}

/// Creator:钟荣枫 
/// CreatDate: 2020-3-9
/// Description：保存 标准码
/// Input: eobj As web.Entity.LAB.BTTestCodeSCode
/// Table：dbo.BTTestCodeSCode
/// Return:成功返回true，失败返回false
/// Other:w ##class(web.DHCBL.LAB.BTTestCodeSCode).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.LAB.BTTestCodeSCode) As %String
{
	s result=""
	if $IsObject(eobj)
	{	
		s:eobj.Active="" eobj.Active=0	//激活为空时，设为0
		s flag=..FormValidate(eobj.RowID,eobj.SCode)  //调用重复验证
		if (flag=1)
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		if (eobj.RowID="")
		{	
	        s obj=##class(dbo.BTTestCodeSCode).%New()
		}
		else
		{
			s obj=##class(dbo.BTTestCodeSCode).%OpenId(eobj.RowID)
			s bobj = ##class(web.Entity.LAB.BTTestCodeSCode).%New()
			s bobj.RowID = eobj.RowID
			s bobj.SCode = obj.SCode
			s bobj.TCName = obj.TCName
			s bobj.SpecimenType=obj.SpecimenType
			s bobj.Sequence = obj.Sequence
			s bobj.Active=obj.Active
			
		}
		s obj.SCode = eobj.SCode		//代码
		s obj.TCName = eobj.TCName		//描述
		S obj.SpecimenType=eobj.SpecimenType	//类型
		s obj.Sequence = eobj.Sequence		//序号
		s obj.Active=eobj.Active		//激活
		
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc){
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			d:eobj.RowID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("dbo.BT_TestCodeSCode","dbo.BTTestCodeSCode","标准码",id,eobj.TCName,"A",eobj)
			d:eobj.RowID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("dbo.BT_TestCodeSCode","dbo.BTTestCodeSCode","标准码",id,eobj.TCName,"U",eobj,bobj)
			
		}else{
			Trollback
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("标准码","web.DHCBL.LAB.BTTestCodeSCode","SaveEntity",eobj)
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

/// Creator:钟荣枫
/// CreatDate:2020-3-9
/// Description:通过代码获取标准码rowid
/// w ##class(web.DHCBL.LAB.BTTestCodeSCode).GetRowIdByCode("")
ClassMethod GetRowIdByCode(code As %String) As %String
{
	S RowID=""
	s code=$ZCONVERT(code,"U")
	if (code'="")
	{
		s RowID=0
		for 
		{
			s RowID=$o(^dbo.BTTestCodeSCodeD(RowID))
			q:RowID=""
			s SCode= $lg($g(^dbo.BTTestCodeSCodeD(RowID)),2)		//代码
			q:code=$ZCONVERT(SCode,"U")
		}
		
	}
	q RowID
}

}
