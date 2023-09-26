/// 名称:标准版检验-取报告提示
/// 描述:包含
/// 编写者:基础数据平台组 -钟荣枫
/// 编写日期: 2019-11-7
Class web.DHCBL.LAB.BTReportPrompt Extends %RegisteredObject
{

/// Creator：钟荣枫 		
/// CreatDate: 2019-11-18
/// Description：查询 取报告提示 
/// Table:dbo.BT_ReportPrompt
/// Input:id, code, desc,
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.LAB.BTReportPrompt","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String, hospital As %String) As %Query(ROWSPEC = "RowID,Code,CName,HospitalDR,PmtDT,Place,Remark,Sequence,Active")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, hospital As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	if (rowid'="") //根据rowid返回该条记录
	{
		
		s RowID=rowid
		;RowID,Code,CName,HospitalDR,PmtDT,Place,Remark,Sequence,Active
		
		s Code= $lg($g(^dbo.BTReportPromptD(RowID)),2)		//代码
		s CName= $lg($g(^dbo.BTReportPromptD(RowID)),3)		//名称
		s HospitalDR= $lg($g(^dbo.BTReportPromptD(RowID)),4)		//医院
		s:HospitalDR'="" HospitalDR= $lg($g(^dbo.BTHospitalD(HospitalDR)),3)
		s PmtDT=$lg($g(^dbo.BTReportPromptD(RowID)),5)		//提示详情
		s Place=$lg($g(^dbo.BTReportPromptD(RowID)),6)		//地点
		s Remark=$lg($g(^dbo.BTReportPromptD(RowID)),7)		//备注
		s Sequence=$lg($g(^dbo.BTReportPromptD(RowID)),8)		//序号
		s Active=$lg($g(^dbo.BTReportPromptD(RowID)),9)		//激活
		s:Active="" Active=1		//update 2019-12-17  激活为空时，设为1
		d OutputRow
	}
	else
	{
		k ^tempsequencesort("dbo.BTReportPrompt")
		s RowID=0
		for 
		{
			s RowID=$o(^dbo.BTReportPromptD(RowID))
			q:RowID=""
			s Code= $lg($g(^dbo.BTReportPromptD(RowID)),2)		//代码
			s CName= $lg($g(^dbo.BTReportPromptD(RowID)),3)		//名称
			s HospitalDR= $lg($g(^dbo.BTReportPromptD(RowID)),4)	
			continue:(HospitalDR'=hospital)&&(hospital'="")	
			s:HospitalDR'="" HospitalDR= $lg($g(^dbo.BTHospitalD(HospitalDR)),3)		//医院
			s PmtDT=$lg($g(^dbo.BTReportPromptD(RowID)),5)		//提示详情
			s Place=$lg($g(^dbo.BTReportPromptD(RowID)),6)		//地点
			s Remark=$lg($g(^dbo.BTReportPromptD(RowID)),7)		//备注
			s Sequence=$lg($g(^dbo.BTReportPromptD(RowID)),8)		//序号
			s Active=$lg($g(^dbo.BTReportPromptD(RowID)),9)		//激活
			s:Active="" Active=1				//update 2019-12-17  激活为空时，设为1

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
			i ($ZCONVERT(Code,"U")[code)&&(AliasFlag=1) //包含)
			{
				s:Sequence="" Sequence=" "_Sequence
				s ^tempsequencesort("dbo.BTReportPrompt",Sequence,RowID)=RowID
				;d OutputRow
			}
		}
		s SequenceSort=""
		for
		{
			s SequenceSort=$o(^tempsequencesort("dbo.BTReportPrompt",SequenceSort))  q:SequenceSort=""
			s RowIDSort=""
			for
			{
				s RowIDSort=$o(^tempsequencesort("dbo.BTReportPrompt",SequenceSort,RowIDSort))  q:RowIDSort=""
				s RowID=RowIDSort
				s Code= $lg($g(^dbo.BTReportPromptD(RowID)),2)		//代码
				s CName= $lg($g(^dbo.BTReportPromptD(RowID)),3)		//名称
				s HospitalDR= $lg($g(^dbo.BTReportPromptD(RowID)),4)		//医院
				s:HospitalDR'="" HospitalDR= $lg($g(^dbo.BTHospitalD(HospitalDR)),3)
				s PmtDT=$lg($g(^dbo.BTReportPromptD(RowID)),5)		//提示详情
				s Place=$lg($g(^dbo.BTReportPromptD(RowID)),6)		//地点
				s Remark=$lg($g(^dbo.BTReportPromptD(RowID)),7)		//备注
				s Sequence=$lg($g(^dbo.BTReportPromptD(RowID)),8)		//序号
				s Active=$lg($g(^dbo.BTReportPromptD(RowID)),9)		//激活
				s:Active="" Active=1		//update 2019-12-17  激活为空时，设为1
				d OutputRow
			}
		} 
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(RowID,Code,CName,HospitalDR,PmtDT,Place,Remark,Sequence,Active)
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
/// CreatDate: 2019-11-7
/// Description：查询 取报告提示 下拉框
/// Table:dbo.BT_ReportPrompt
/// Input:id, code, desc
/// Output:RowId,Code,Desc
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.LAB.BTReportPrompt","GetDataForCmb1","","","")
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
		//^dbo.BTReportPromptD
		s Code= $lg($g(^dbo.BTReportPromptD(RowID)),2)		//代码
		s CName= $lg($g(^dbo.BTReportPromptD(RowID)),3)		//名称
		d OutputRowCmb
	}
	else
	{
		k ^tempsequencecombosort("dbo.BTReportPrompt")
		s:code'="" code=$ZCONVERT(code,"U") //转换成大写
		s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
		s RowID=0
		for 
		{
			s RowID=$o(^dbo.BTReportPromptD(RowID))
			q:RowID=""
			s Code= $lg($g(^dbo.BTReportPromptD(RowID)),2)		//代码
			s CName= $lg($g(^dbo.BTReportPromptD(RowID)),3)		//名称
			s HospitalDR= $lg($g(^dbo.BTReportPromptD(RowID)),4)	
			continue:(HospitalDR'=hospital)&&(hospital'="")	
			s Sequence=$lg($g(^dbo.BTReportPromptD(RowID)),8)		//序号
			s Active=$lg($g(^dbo.BTReportPromptD(RowID)),9)		//激活
			continue:Active=0			//过滤未激活状态数据
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
				
				s:Sequence="" Sequence=" "_Sequence
				s ^tempsequencecombosort("dbo.BTReportPrompt",Sequence,RowID)=RowID
				;d OutputRow
			}
		}
		s SequenceSort=""
		for
		{
			s SequenceSort=$o(^tempsequencecombosort("dbo.BTReportPrompt",SequenceSort))  q:SequenceSort=""
			s RowIDSort=""
			for
			{
				s RowIDSort=$o(^tempsequencecombosort("dbo.BTReportPrompt",SequenceSort,RowIDSort))  q:RowIDSort=""
				s RowID=RowIDSort
				s Code= $lg($g(^dbo.BTReportPromptD(RowID)),2)		//代码
				s CName= $lg($g(^dbo.BTReportPromptD(RowID)),3)		//名称
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

/// Creator:钟荣枫 
/// CreatDate:2019-11-18
/// Description:数据重复验证方法,js调用
/// Table:dbo.BT_ReportPrompt
/// Input:id, code, desc,hosp
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.DHCBL.LAB.BTReportPrompt).FormValidate("27","cs1","2")
ClassMethod FormValidate(id As %String, code As %String, hosp As %String) As %String
{
	//HospitalDR, Code
	s flag=0
	if (code'="")&&(hosp'="")
	{
		s RowID=$o(^dbo.BTReportPromptI("IndexCode",hosp,##Class(web.DHCBL.BDP.FunLib).IndexData(code),0))
		if (RowID'="")&&(id'=RowID)
		{
			s flag=1
		}
	}
	
	q flag
}

/// Creator：钟荣枫 
/// CreatDate: 2019-11-18
/// Description：新增，修改时打开Form，根据RowId查询
/// Table：dbo.BT_ReportPrompt
/// Input：RowId
/// Other: w ##class(web.DHCBL.LAB.BTReportPrompt).OpenData(26)
ClassMethod OpenData(id As %String) As %String
{
    s str = ""
	s pobj = ##class(dbo.BTReportPrompt).%OpenId(id) 
	s eobj = ##class(web.Entity.LAB.BTReportPrompt).%New() 
	s eobj.RowID = id
	s eobj.Code = pobj.Code
	s eobj.CName = pobj.CName
	s eobj.HospitalDR=pobj.HospitalDR
	s eobj.PmtDT=pobj.PmtDT
	s eobj.Place=pobj.Place
	s eobj.Remark=pobj.Remark
	s eobj.Sequence = pobj.Sequence
	s eobj.Active=pobj.Active
	d pobj.%Close()
	kill pobj
	s str = eobj.JsonS()
	//s str = "{list:["_str_"]}"
	q str
}

/// Creator:钟荣枫
/// CreatDate:2019-11-18
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
/// Other: w ##class(web.DHCBL.LAB.BTReportPrompt).GetRefFlag(2)
ClassMethod GetRefFlag(id As %String) As %String
{
	s return="",myInfo=""
	//dbo.BTTestSet
	s BTTestSetRowID=0
	for 
	{
		s BTTestSetRowID=$o(^dbo.BTTestSetD(BTTestSetRowID))
		q:BTTestSetRowID=""
		s ReportPromptDR= $lg($g(^dbo.BTTestSetD(BTTestSetRowID)),16)	
		if (ReportPromptDR=id)
		{
			s myInfo=myInfo_"<项目组合套>"
			q
		}
	}
	i myInfo="" s return="0^未被引用可删除！"
	else  s return="1^在"_myInfo_"表里被引用,不能删除！"
	q return
}

/// Creator：钟荣枫 
/// CreatDate: 2019-11-18
/// Description：根据id删除 取报告提示
/// Table：dbo.BT_ReportPrompt
/// Input：id 
/// Return：成功返回true，失败返回false和info
/// Other: w ##class(web.DHCBL.LAB.BTReportPrompt).DeleteData(1)
ClassMethod DeleteData(id) As %String
{
	s result=""
	s re=##class(web.DHCBL.LAB.BTReportPrompt).GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	if (RefFlag=0){
		s pobj = ##class(dbo.BTReportPrompt).%OpenId(id)
		s eobj = ##class(web.Entity.LAB.BTReportPrompt).%New()
		s eobj.Code = pobj.Code
		s eobj.CName = pobj.CName
		s eobj.HospitalDR=pobj.HospitalDR
		s eobj.PmtDT=pobj.PmtDT
		s eobj.Place=pobj.Place
		s eobj.Remark=pobj.Remark
		s eobj.Sequence = pobj.Sequence
		s eobj.Active=pobj.Active
		
		d pobj.%Close()
		kill pobj
		Tstart
		s sc=##class(dbo.BTReportPrompt).%DeleteId(id)
		IF $$$ISOK(sc){
			Tc
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("dbo.BT_ReportPrompt","dbo.BTReportPrompt","取报告提示",id,eobj.CName,"D",eobj)
		}
		else{
			Trollback
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("取报告提示","web.DHCBL.LAB.BTReportPrompt","DeleteData",eobj)
			s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		}
	}else{
		s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"	
	}
	
	
	q result
}

/// Creator:钟荣枫 
/// CreatDate: 2019-11-18
/// Description：保存 取报告提示
/// Input: eobj As web.Entity.LAB.BTReportPrompt
/// Table：dbo.BT_ReportPrompt
/// Return:成功返回true，失败返回false
/// Other:w ##class(web.DHCBL.LAB.BTReportPrompt).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.LAB.BTReportPrompt) As %String
{
	//n (eobj,%session)

	s result=""
	if $IsObject(eobj)
	{	
		s:eobj.Active="" eobj.Active=0		//update 2019-11-19  激活为空时，设为0
		s flag=..FormValidate(eobj.RowID,eobj.Code,eobj.HospitalDR)  //调用重复验证
		if (flag=1)
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		if (eobj.RowID="")
		{	
	        s obj=##class(dbo.BTReportPrompt).%New()
		}
		else
		{
			s obj=##class(dbo.BTReportPrompt).%OpenId(eobj.RowID)
			s bobj = ##class(web.Entity.LAB.BTReportPrompt).%New()
			s bobj.RowID = eobj.RowID
			s bobj.Code = obj.Code	
			s bobj.CName = obj.CName	
			s bobj.HospitalDR=obj.HospitalDR	
			s bobj.PmtDT=obj.PmtDT	
			s bobj.Place=obj.Place	
			s bobj.Remark=obj.Remark	
			s bobj.Sequence = obj.Sequence	
			s bobj.Active=obj.Active	
		}
		s obj.Code = eobj.Code	//代码
		s obj.CName = eobj.CName	//名称
		s obj.HospitalDR=eobj.HospitalDR	//医院
		s obj.PmtDT=eobj.PmtDT		//提示详情
		s obj.Place=eobj.Place		//地点
		s obj.Remark=eobj.Remark	//备注
		s obj.Sequence = eobj.Sequence		//序号
		s obj.Active=eobj.Active		//激活
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc){
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			d:eobj.RowID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("dbo.BT_ReportPrompt","dbo.BTReportPrompt","取报告提示",id,eobj.CName,"A",eobj)
			d:eobj.RowID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("dbo.BT_ReportPrompt","dbo.BTReportPrompt","取报告提示",id,eobj.CName,"U",eobj,bobj)
			
		}else{
			Trollback
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("取报告提示","web.DHCBL.LAB.BTReportPrompt","SaveEntity",eobj)
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
/// CreatDate:2020-1-17
/// Description:通过取报告提示代码获取取报告提示rowid
/// w ##class(web.DHCBL.LAB.BTReportPrompt).GetRowIdByCode("")
ClassMethod GetRowIdByCode(code As %String) As %String
{
	S ROWID=""
	s code=$ZCONVERT(code,"U")
	if (code'="")
	{
		s ROWID=0
		for
		{
			s ROWID=$o(^dbo.BTReportPromptD(ROWID)) q:ROWID=""
			s Code=$lg($g(^dbo.BTReportPromptD(ROWID)),2)
			q:code=$ZCONVERT(Code,"U")
		}
	}
	q ROWID
}

}
