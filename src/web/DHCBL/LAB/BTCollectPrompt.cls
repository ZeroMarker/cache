/// 名称:标准版检验-采集提示
/// 描述:包含
/// 编写者:基础数据平台组 -钟荣枫
/// 编写日期: 2019-11-7
Class web.DHCBL.LAB.BTCollectPrompt Extends %RegisteredObject
{

/// Creator：钟荣枫 		
/// CreatDate: 2019-11-7
/// Description：查询 采集提示 下拉框
/// Table:dbo.BT_CollectPrompt
/// Input:id, code, desc
/// Output:RowId,Code,Desc
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.LAB.BTCollectPrompt","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String, hospital As %String) As %Query(ROWSPEC = "RowID,Code,CName")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, hospital As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s RowID=rowid
		//^dbo.BTCollectPromptD(1)=$lb("","1","采集后20分钟内送检",1,1,1)
		s Code= $lg($g(^dbo.BTCollectPromptD(RowID)),2)		//代码
		s CName= $lg($g(^dbo.BTCollectPromptD(RowID)),3)		//名称
		d OutputRowCmb
	}
	else
	{
		
		s:code'="" code=$ZCONVERT(code,"U") //转换成大写
		s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
		s RowID=0
		for 
		{
			s RowID=$o(^dbo.BTCollectPromptD(RowID))
			q:RowID=""
			s Code= $lg($g(^dbo.BTCollectPromptD(RowID)),2)		//代码
			s CName= $lg($g(^dbo.BTCollectPromptD(RowID)),3)		//名称
			s HospitalDR = $lg($g(^dbo.BTCollectPromptD(RowID)),4)  //医院DR
			continue:(HospitalDR'=hospital)&&(hospital'="")
			s Active= $lg($g(^dbo.BTCollectPromptD(RowID)),6)
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
				if (($ZCONVERT(CName,"U")[desc)||(PINYINCODE[desc)) 
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
/// CreatDate: 2019-11-27
/// Description：查询采集提示表的内容
/// Table：dbo.BT_CollectPrompt
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.LAB.BTCollectPrompt","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String, hospitaldr As %String) As %Query(ROWSPEC = "RowID:%String,Code:%String,CName:%String,HospitalDR:%String,Sequence:%String,Active:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, hospitaldr As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s RowID = rowid
		s Code= $lg($g(^dbo.BTCollectPromptD(RowID)),2)		//代码
		s CName= $lg($g(^dbo.BTCollectPromptD(RowID)),3)		//描述
		s HospitalDR = $lg($g(^dbo.BTCollectPromptD(RowID)),4)  //医院DR
		s:HospitalDR'="" HospitalDR=$lg($g(^dbo.BTHospitalD(HospitalDR)),3)	//医院描述
		s Sequence = $lg($g(^dbo.BTCollectPromptD(RowID)),5)   //序号
		s Active = $lg($g(^dbo.BTCollectPromptD(RowID)),6)   //激活
		s Active=$CASE(Active,"1":"Y",:"N")
		
		d OutputRow
	}
	else
	{
		k ^tempsequencesort("dbo.BTCollectPrompt")
		s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	    s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	    s RowID=0
	 	for
	 	{
		 	s RowID=$o(^dbo.BTCollectPromptD(RowID))
		 	q:RowID=""
		 	s Code = $lg($g(^dbo.BTCollectPromptD(RowID)),2)		//代码
			s CName = $lg($g(^dbo.BTCollectPromptD(RowID)),3)		//描述
			s HospitalDR = $lg($g(^dbo.BTCollectPromptD(RowID)),4)  //医院DR
			s Sequence = $lg($g(^dbo.BTCollectPromptD(RowID)),5)    //序号
		 	s PINYIN=""
		 	s:desc'="" PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(CName)
		 	if ($ZCONVERT(Code,"U")[code)&&(($ZCONVERT(CName,"U")[desc)||(PINYIN[desc))&&((HospitalDR=hospitaldr)||(hospitaldr=""))
		 	{
			 	s:Sequence="" Sequence=" "
			 	s ^tempsequencesort("dbo.BTCollectPrompt",Sequence,RowID)=""
			}
		}
		s Sort=""
		for
		{
			s Sort=$o(^tempsequencesort("dbo.BTCollectPrompt",Sort)) q:Sort=""
			s RowID=0
			for 
			{
				s RowID=$o(^tempsequencesort("dbo.BTCollectPrompt",Sort,RowID))  q:RowID=""
				s Code = $lg($g(^dbo.BTCollectPromptD(RowID)),2)		//代码
				s CName = $lg($g(^dbo.BTCollectPromptD(RowID)),3)		//描述
				s HospitalDR = $lg($g(^dbo.BTCollectPromptD(RowID)),4)  //医院DR
				s:HospitalDR'="" HospitalDR=$lg($g(^dbo.BTHospitalD(HospitalDR)),3)	//医院描述
				s Sequence = $lg($g(^dbo.BTCollectPromptD(RowID)),5)   //序号
				s Active = $lg($g(^dbo.BTCollectPromptD(RowID)),6)   //激活
				s Active=$CASE(Active,"1":"Y",:"N")
				d OutputRow
			}
			
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(RowID,Code,CName,HospitalDR,Sequence,Active)
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
/// CreatDate:2019-11-27
/// Description:数据重复验证方法,js调用
/// Table:dbo.BT_CollectPrompt
/// Input:id, code, desc
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.DHCBL.LAB.BTCollectPrompt).FormValidate("1","1","1")
ClassMethod FormValidate(id As %String, code As %String, Hospital As %String) As %String
{
	s flag=0
	if ((code'="")&&(Hospital'=""))
	{
		s RowID=$o(^dbo.BTCollectPromptI("IndexCode",Hospital,##Class(web.DHCBL.BDP.FunLib).IndexData(code),0))
		if (RowID'="")&&(id'=RowID) s flag=1
	}
	
	q flag
}

/// Creator:杨帆 
/// CreatDate: 2019-11-25
/// Description：保存 性别
/// Input: eobj As web.Entity.LAB.BTCollectPrompt
/// Table：dbo.BT_CollectPrompt
/// Return:成功返回true，失败返回false
/// Other:w ##class(web.DHCBL.LAB.BTCollectPrompt).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.LAB.BTCollectPrompt) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		s:eobj.Active="" eobj.Active="0"
		s flag=..FormValidate(eobj.RowID,eobj.Code,eobj.HospitalDR)  //调用重复验证
		if (flag=1)
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		if (eobj.RowID="")
		{
			s obj=##class(dbo.BTCollectPrompt).%New()
		}
		else
		{
			s obj=##class(dbo.BTCollectPrompt).%OpenId(eobj.RowID)
			s bobj=##class(web.Entity.LAB.BTCollectPrompt).%New()
			s bobj.RowID = eobj.RowID		  //RowID
			s bobj.Code = obj.Code		      //代码
			s bobj.CName = obj.CName		  //描述
			s bobj.HospitalDR=obj.HospitalDR  //医院DR
			s bobj.Sequence = obj.Sequence    //序号
			s bobj.Active=obj.Active          //激活
		}
		s obj.Code = eobj.Code		      //代码
		s obj.CName = eobj.CName		  //描述
		S obj.HospitalDR=eobj.HospitalDR  //医院DR
		s obj.Sequence = eobj.Sequence    //序号
		s obj.Active=eobj.Active          //激活
		TSTART
		s sc=obj.%Save()
		if (sc=1)
		{
			TCOMMIT
			s id=obj.%Id()
			s result="{success:'true',id:'"_id_"'}"
			d:eobj.RowID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("dbo.BT_CollectPrompt","dbo.BTCollectPrompt","采集提示",eobj.RowID,eobj.CName,"U",eobj,bobj)
			d:eobj.RowID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("dbo.BT_CollectPrompt","dbo.BTCollectPrompt","采集提示",id,eobj.CName,"A",eobj)
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

/// Creator：杨帆 
/// CreatDate: 2019-11-25
/// Description：新增，修改时打开Form，根据RowId查询
/// Table：dbo.BT_CollectPrompt
/// Input：RowId
/// Other: w ##class(web.DHCBL.LAB.BTCollectPrompt).OpenData(7)
ClassMethod OpenData(id As %String) As %String
{
    s str = ""
	s pobj = ##class(dbo.BTCollectPrompt).%OpenId(id) 
	s eobj = ##class(web.Entity.LAB.BTCollectPrompt).%New() 
	s eobj.RowID = id
	s eobj.Code = pobj.Code
	s eobj.CName = pobj.CName
	s eobj.HospitalDR=pobj.HospitalDR
	s eobj.Sequence = pobj.Sequence
	s eobj.Active=pobj.Active
	d pobj.%Close()
	kill pobj
	s str = eobj.JsonS()
	//s str = "{list:["_str_"]}"
	q str
}

/// Creator:杨帆
/// CreatDate:2019-11-27
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
/// Other: w ##class(web.DHCBL.LAB.BTCollectPrompt).GetRefFlag(1)
ClassMethod GetRefFlag(id As %String) As %String
{
	s return="",myInfo=""
	//dbo.BTTestSet
	s TestSetRowID=0
	for 
	{
		s TestSetRowID=$o(^dbo.BTTestSetD(TestSetRowID))
		q:TestSetRowID=""
		s HospitalDR= $lg($g(^dbo.BTTestSetD(TestSetRowID)),4)	//医嘱所属工作组
		if (HospitalDR=id)
		{
			s myInfo=myInfo_"<项目组合套表>"
			q
		}
	}
	
	i myInfo="" s return="0^未被引用可删除！"
	else  s return="1^在"_myInfo_"表里被引用,不能删除！"
	q return
}

/// Creator：杨帆
/// CreatDate: 2019-11-27
/// Description：根据id删除 性别
/// Table：dbo.BT_CollectPrompt
/// Input：id 
/// Return：成功返回true，失败返回false和info
/// Other: w ##class(web.DHCBL.LAB.BTCollectPrompt).DeleteData(1)
ClassMethod DeleteData(id) As %String
{
	s result=""
	s re=##class(web.DHCBL.LAB.BTCollectPrompt).GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	if (RefFlag=0){
		s pobj = ##class(dbo.BTCollectPrompt).%OpenId(id)
		s eobj = ##class(web.Entity.LAB.BTCollectPrompt).%New()
		s eobj.Code = pobj.Code		  //代码
		s eobj.CName = pobj.CName		  //描述
		s eobj.HospitalDR=pobj.HospitalDR		  //关联医院
		s eobj.Sequence = pobj.Sequence		  //序号
		s eobj.Active=pobj.Active		  //激活
		
		d pobj.%Close()
		kill pobj
		Tstart
		s sc=##class(dbo.BTCollectPrompt).%DeleteId(id)
		IF $$$ISOK(sc){
			Tc
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("dbo.BT_CollectPrompt","dbo.BTCollectPrompt","描述",id,eobj.CName,"D",eobj)
		}
		else{
			Trollback
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("描述","web.DHCBL.LAB.BTCollectPrompt","DeleteData",eobj)
			s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		}
	}else{
		s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"	
	}
	
	
	q result
}

/// Creator:钟荣枫
/// CreatDate:2020-1-17
/// Description:通过采集提示代码获取采集提示rowid
/// w ##class(web.DHCBL.LAB.BTCollectPrompt).GetRowIdByCode("")
ClassMethod GetRowIdByCode(code As %String) As %String
{
	S RowID=""
	s code=$ZCONVERT(code,"U")
	if code'=""
	{
		s RowID=0
		for 
		{
			s RowID=$o(^dbo.BTCollectPromptD(RowID))
			q:RowID=""
			s Code= $lg($g(^dbo.BTCollectPromptD(RowID)),2)		//代码
			q:code=$ZCONVERT(Code,"U")
		}
	}
	q RowID
}

}
