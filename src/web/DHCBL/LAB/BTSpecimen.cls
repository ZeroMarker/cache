/// 名称:标准版检验-标本类型
/// 描述:增删改查
/// 编写者:基础数据平台组 -谢海睿
/// 编写日期: 2019-11-7
Class web.DHCBL.LAB.BTSpecimen Extends %RegisteredObject
{

/// Creator：谢海睿		
/// CreatDate: 2019-11-7
/// Description：查询
/// Table:dbo.BT_Specimen
/// Input:id,code,iname,hospital
/// Output:RowID,Code,IName,XName,EName,HospitalDR,HISCode,WCode,SpecimenGroupDR,Sequence,Active,CollectPrompt,WhonetType
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.LAB.BTSpecimen","GetList","","","","")
Query GetList(rowid As %String, code As %String, iname As %String, hospital As %String) As %Query(ROWSPEC = "RowID,Code,IName,XName,EName,HospitalDR,HISCode,WCode,SpecimenGroupDR,Sequence,Active,CollectPrompt,WhonetType")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, iname As %String, hospital As %String) As %Status
{

	s repid=$I(^CacheTemp)
	s ind=1
	
	s:code'="" code=$ZCONVERT(code,"U")  
	s:iname'="" iname=$ZCONVERT(iname,"U")
	
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s RowID=rowid
		s Code= $lg($g(^dbo.BTSpecimenD(RowID)),2)		//代码
		s IName= $lg($g(^dbo.BTSpecimenD(RowID)),3)		// 内部名称
		s XName= $lg($g(^dbo.BTSpecimenD(RowID)),4)       // 外部名称
		s EName= $lg($g(^dbo.BTSpecimenD(RowID)),5)		// 英文缩写
		s HospitalDR = $lg($g(^dbo.BTSpecimenD(RowID)),6)	// 医院
		s:HospitalDR'="" HospitalDR=$lg($g(^dbo.BTHospitalD(HospitalDR)),3)	//检验科室对应医院描述
		s HISCode= $lg($g(^dbo.BTSpecimenD(RowID)),7)    // HIS对照码
		s WCode= $lg($g(^dbo.BTSpecimenD(RowID)),8)       // whone码
		s SpecimenGroupDR= $lg($g(^dbo.BTSpecimenD(RowID)),9)  // 标本组
		s:SpecimenGroupDR'="" SpecimenGroupDR=$lg($g(^dbo.BTSpecimenGroupD(SpecimenGroupDR)),3)	//默认标本类型描述
		s Sequence= $lg($g(^dbo.BTSpecimenD(RowID)),10)    // 序号
		s Active= $lg($g(^dbo.BTSpecimenD(RowID)),11)      // 激活
		s:Active="" Active=1		//update 2019-12-17  激活为空时，设为1
		s CollectPrompt= $lg($g(^dbo.BTSpecimenD(RowID)),12)  // 采集注意事项
		s WhonetType= $lg($g(^dbo.BTSpecimenD(RowID)),13)
		d OutputRow
	
	}
	else
	{
		k ^tempsequencesort("dbo.BTSpecimen")
		s RowID=0
		for
		{
			s RowID=$o(^dbo.BTSpecimenD(RowID)) q:RowID=""
			s Code=$lg($g(^dbo.BTSpecimenD(RowID)),2)
			s IName=$lg($g(^dbo.BTSpecimenD(RowID)),3)
			s XName=$lg($g(^dbo.BTSpecimenD(RowID)),4)
			s EName= $lg($g(^dbo.BTSpecimenD(RowID)),5)		// 英文缩写
		    s HospitalDR = $lg($g(^dbo.BTSpecimenD(RowID)),6)	// 医院
			if (hospital'="")
			{
				if (HospitalDR'=hospital)
				{
					continue
				}
			}
			s:HospitalDR'="" HospitalDR=$lg($g(^dbo.BTHospitalD(HospitalDR)),3)	//检验科室对应医院描述
			s HISCode= $lg($g(^dbo.BTSpecimenD(RowID)),7)    // HIS对照码
			s WCode= $lg($g(^dbo.BTSpecimenD(RowID)),8)       // whone码
			s SpecimenGroupDR= $lg($g(^dbo.BTSpecimenD(RowID)),9)  // 标本组
			s:SpecimenGroupDR'="" SpecimenGroupDR=$lg($g(^dbo.BTSpecimenGroupD(SpecimenGroupDR)),3)	
			s Sequence= $lg($g(^dbo.BTSpecimenD(RowID)),10)    // 序号
			s Active= $lg($g(^dbo.BTSpecimenD(RowID)),11)      // 激活
			s:Active="" Active=1		//update 2019-12-17  激活为空时，设为1
			s CollectPrompt= $lg($g(^dbo.BTSpecimenD(RowID)),12)  // 采集注意事项
			s WhonetType= $lg($g(^dbo.BTSpecimenD(RowID)),13)
			if (iname'="")           
			{
				s AliasFlag = 0
				s PINYINFlag=""
				s PINYINCODE=""
			    s PINYINFlag=##class(web.DHCBL.BDP.BDPAlias).GetPINYINFlag(iname) /// 是拼音 才去转换拼音码
			  	if (PINYINFlag=1)
        		{
         		 	s PINYINCODE=##class(web.DHCBL.BDP.FunLib).GetPYCODE(IName) 
        		}
        		if (($ZCONVERT(IName,"U")[iname)||(PINYINCODE[iname))
				{
					s AliasFlag= 1
				}	  
			  	   
			}
			else
			{
				S AliasFlag=1
			}
			i ($ZCONVERT(Code,"U")[code)&&(AliasFlag=1) //包含
			{
				s:Sequence="" Sequence=" "_Sequence
				s ^tempsequencesort("dbo.BTSpecimen",Sequence,RowID)=RowID
				;d OutputRow
			}
			
		}
		s SequenceSort=""
		for
		{
			s SequenceSort=$o(^tempsequencesort("dbo.BTSpecimen",SequenceSort))  q:SequenceSort=""
			s RowIDSort=""
			for
			{
				s RowIDSort=$o(^tempsequencesort("dbo.BTSpecimen",SequenceSort,RowIDSort))  q:RowIDSort=""
				s RowID=RowIDSort
				s Code=$lg($g(^dbo.BTSpecimenD(RowID)),2)
				s IName=$lg($g(^dbo.BTSpecimenD(RowID)),3)
				s XName=$lg($g(^dbo.BTSpecimenD(RowID)),4)
				s EName= $lg($g(^dbo.BTSpecimenD(RowID)),5)		// 英文缩写
		   		s HospitalDR = $lg($g(^dbo.BTSpecimenD(RowID)),6)	// 医院
				s:HospitalDR'="" HospitalDR=$lg($g(^dbo.BTHospitalD(HospitalDR)),3)	//检验科室对应医院描述
				s HISCode= $lg($g(^dbo.BTSpecimenD(RowID)),7)    // HIS对照码
				s WCode= $lg($g(^dbo.BTSpecimenD(RowID)),8)       // whone码
				s SpecimenGroupDR= $lg($g(^dbo.BTSpecimenD(RowID)),9)  // 标本组
				s:SpecimenGroupDR'="" SpecimenGroupDR=$lg($g(^dbo.BTSpecimenGroupD(SpecimenGroupDR)),3)	
				s Sequence= $lg($g(^dbo.BTSpecimenD(RowID)),10)    // 序号
				s Active= $lg($g(^dbo.BTSpecimenD(RowID)),11)      // 激活
				s:Active="" Active=1		//update 2019-12-17  激活为空时，设为1
				s CollectPrompt= $lg($g(^dbo.BTSpecimenD(RowID)),12)  // 采集注意事项
				s WhonetType= $lg($g(^dbo.BTSpecimenD(RowID)),13)
				d OutputRow
			}
		} 
		
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(RowID,Code,IName,XName,EName,HospitalDR,HISCode,WCode,SpecimenGroupDR,Sequence,Active,CollectPrompt,WhonetType)
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

/// Creator：谢海睿		
/// CreatDate: 2019-11-7
/// Description：查询 标本类型 下拉框
/// Table:dbo.BT_Specimen
/// Input:id, code, cname
/// Output:RowId,Code,Desc
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.LAB.BTSpecimen","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, cname As %String, hospital As %String) As %Query(ROWSPEC = "RowID,Code,CName")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, cname As %String, hospital As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s RowID=rowid
		s Code= $lg($g(^dbo.BTSpecimenD(RowID)),2)		//代码
		s CName= $lg($g(^dbo.BTSpecimenD(RowID)),3)		//名称
		d OutputRowCmb
	}
	else
	{
		k ^tempsequencecombosort("dbo.BTSpecimen")
		s:code'="" code=$ZCONVERT(code,"U") //转换成大写
		s:cname'="" cname=$ZCONVERT(cname,"U") //转换成大写
		s RowID=0
		for 
		{
			s RowID=$o(^dbo.BTSpecimenD(RowID))
			q:RowID=""
			s Code= $lg($g(^dbo.BTSpecimenD(RowID)),2)		//代码
			s CName= $lg($g(^dbo.BTSpecimenD(RowID)),3)		//名称
			s HospitalDR = $lg($g(^dbo.BTSpecimenD(RowID)),6)	// 医院
			continue:(HospitalDR'=hospital)&&(hospital'="")	
			s Sequence= $lg($g(^dbo.BTSpecimenD(RowID)),10)    // 序号
			s Active= $lg($g(^dbo.BTSpecimenD(RowID)),11)      // 激活
			continue:Active=0			//过滤未激活状态数据
			if (cname'="")           
			{
				s AliasFlag=0     
				s PINYINFlag=""
				s PINYINCODE=""   
		        s PINYINFlag=##class(web.DHCBL.BDP.BDPAlias).GetPINYINFlag(cname) /// 是拼音 才去转换拼音码
		        if (PINYINFlag=1)
		        {
		          s PINYINCODE=##class(web.DHCBL.BDP.FunLib).GetPYCODE(CName) 
		        }
				if ((CName[cname)||(PINYINCODE[cname)) 
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
				s ^tempsequencecombosort("dbo.BTSpecimen",Sequence,RowID)=RowID
				;d OutputRowCmb
			}
		}
		s SequenceSort=""
		for
		{
			s SequenceSort=$o(^tempsequencecombosort("dbo.BTSpecimen",SequenceSort))  q:SequenceSort=""
			s RowIDSort=""
			for
			{
				s RowIDSort=$o(^tempsequencecombosort("dbo.BTSpecimen",SequenceSort,RowIDSort))  q:RowIDSort=""
				s RowID=RowIDSort
				s Code= $lg($g(^dbo.BTSpecimenD(RowID)),2)		//代码
				s CName= $lg($g(^dbo.BTSpecimenD(RowID)),3)		//名称
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

/// Creator：谢海睿
/// CreatDate: 2019-11-7
/// Description：根据id删除 标本类型
/// Table：dbo.BTSpecimen
/// Input：id 
/// Return：成功返回true，失败返回false和info
/// Other: w ##class(web.DHCBL.LAB.BTSpecimen).DeleteData(82)
ClassMethod DeleteData(id) As %String
{

	s result=""
	s flag=..GetRefFlag(id)  //删除限制
	s RefFlag = $p(flag,"^",1)
	if (RefFlag=0)
	{
		s pobj = ##class(dbo.BTSpecimen).%OpenId(id)
		s eobj = ##class(web.Entity.LAB.BTSpecimen).%New()
		s eobj.Code = pobj.Code
		s eobj.IName = pobj.IName
		s eobj.XName = pobj.XName
		s eobj.EName = pobj.EName
		s eobj.HospitalDR=pobj.HospitalDR
		s eobj.HISCode = pobj.HISCode
		s eobj.WCode = pobj.WCode
		s eobj.SpecimenGroupDR=pobj.SpecimenGroupDR
		s eobj.Sequence = pobj.Sequence
		s eobj.Active = pobj.Active
		s eobj.CollectPrompt = pobj.CollectPrompt
		s eobj.WhonetType = pobj.WhonetType

	 	d pobj.%Close()
		kill pobj
		Tstart
		s sc=##class(dbo.BTSpecimen).%DeleteId(id)
		IF $$$ISOK(sc){
			Tc
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("dbo.BT_Specimen","dbo.BTSpecimen","标本类型",id,eobj.IName,"D",eobj)
		}
		else{
			Trollback
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("标本类型","web.DHCBL.LAB.BTSpecimen","DeleteData",eobj)
			s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		}
	}
	else
	
	{
		s result="{success:'false',info:'"_$p(flag,"^",2)_"'}"
	}
	q result
}

/// Creator：谢海睿
/// CreatDate: 2019-11-6
/// Description：新增，修改时打开Form，根据RowID查询
/// Table：dbo.BTSpecimen
/// Input：RowId
/// Other: w ##class(web.DHCBL.LAB.BTSpecimen).OpenData(1)
ClassMethod OpenData(id As %String) As %String
{
    s str = ""
	s pobj = ##class(dbo.BTSpecimen).%OpenId(id) 
	s eobj = ##class(web.Entity.LAB.BTSpecimen).%New() 
	s eobj.RowID = id
	s eobj.Code = pobj.Code
	s eobj.IName = pobj.IName
	s eobj.XName = pobj.XName
	s eobj.EName = pobj.EName
	s eobj.HospitalDR=pobj.HospitalDR
	s eobj.HISCode = pobj.HISCode
	s eobj.WCode = pobj.WCode
	s eobj.SpecimenGroupDR=pobj.SpecimenGroupDR
	s eobj.Active = pobj.Active
	s eobj.Sequence = pobj.Sequence
	s eobj.CollectPrompt = pobj.CollectPrompt
	s eobj.WhonetType = pobj.WhonetType
	d pobj.%Close()
	kill pobj
	s str = eobj.JsonS()
	q str
}

/// Creator:谢海睿
/// CreatDate:2019-11-6
/// Description:数据重复验证方法,js调用
/// Table:dbo.BTSpecimen
/// Input:id, Code, desc
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.DHCBL.LAB.BTSpecimen).FormValidate("","","")
ClassMethod FormValidate(id As %String, code As %String, hosp As %String) As %String
{
	s flag = 0
	if (code'="") && (hosp'="")
	{
		s RowID = $o(^dbo.BTSpecimenI("IndexCode",hosp,##Class(web.DHCBL.BDP.FunLib).IndexData(code),0))
		if (RowID'="")&&(id'=RowID)
		{
			s flag=1
		}
	}
	q flag
}

/// Creator:谢海睿
/// CreatDate: 2019-11-6
/// Description：保存 标本类型
/// Input: eobj As web.Entity.LAB.BTSpecimen
/// Table：dbo.BTSpecimen
/// Return:成功返回true，失败返回false
/// Other:w ##class(web.DHCBL.LAB.BTSpecimen).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.LAB.BTSpecimen) As %String
{
	s result=""
	if $IsObject(eobj)
	{	s:eobj.Active="" eobj.Active=0
		s flag=..FormValidate(eobj.RowID,eobj.Code,eobj.HospitalDR)  //调用重复验证
		if (flag=1)
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		if (eobj.RowID="")
		{	
			
			s obj=##class(dbo.BTSpecimen).%New()
		}
		else
		{
			s obj=##class(dbo.BTSpecimen).%OpenId(eobj.RowID)
			s bobj = ##class(web.Entity.LAB.BTSpecimen).%New()
			s bobj.RowID = eobj.RowID
			s bobj.Code = obj.Code
			s bobj.IName = obj.IName
			s bobj.XName = obj.XName
			s bobj.EName = obj.EName
			s:obj.HospitalDR'="" bobj.HospitalDR=obj.HospitalDR
			s bobj.HISCode = obj.HISCode
			s bobj.WCode = obj.WCode
			s:obj.SpecimenGroupDR'="" bobj.SpecimenGroupDR=obj.SpecimenGroupDR
		    s bobj.Sequence = obj.Sequence
			s bobj.Active = obj.Active
			s bobj.CollectPrompt = obj.CollectPrompt
			s bobj.WhonetType = obj.WhonetType
		}
		
		s obj.Code = eobj.Code 					//代码
		s obj.IName = eobj.IName				//内部名称
		s obj.XName = eobj.XName				//外部名称
		s obj.EName = eobj.EName				//英文缩写
		s obj.HospitalDR=eobj.HospitalDR		//医院
		s obj.HISCode = eobj.HISCode			//HIS对照码
		s obj.WCode = eobj.WCode				//whone码
		s obj.SpecimenGroupDR=eobj.SpecimenGroupDR ///标本组
		s obj.Sequence = eobj.Sequence			//序号
		s obj.Active = eobj.Active				//激活状态
		s obj.CollectPrompt = eobj.CollectPrompt	// 采集注意事项
		s obj.WhonetType = eobj.WhonetType	        
		
		
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc){
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			d:eobj.RowID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("dbo.BT_Specimen","dbo.BTSpecimen","标本类型",id,eobj.IName,"A",eobj)
			d:eobj.RowID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("dbo.BT_Specimen","dbo.BTSpecimen","标本类型",id,eobj.IName,"U",eobj,bobj)
			
		}else{
			Trollback
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("标本类型","web.DHCBL.LAB.BTSpecimen","SaveEntity",eobj)
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

/// Creator:谢海睿
/// Description：删除限制
/// Return: 1-被引用不可删除，0-未被引用可删除
/// CreatDate: 2019-11-6
/// Other：w ##class(web.DHCBL.LAB.BTSpecimen).GetRefFlag("83")
ClassMethod GetRefFlag(id As %String) As %String
{
	s return = "",myInfo=""
	s RowID=0
	for
	{
		 s RowID = $o(^dbo.BTTestSetD(RowID)) q:RowID=""
		 s SpecimenDR= $lg($g(^dbo.BTTestSetD(RowID)),10)
		 if (SpecimenDR=id)
		 {
			 s myInfo=myInfo_"<项目组合套>"
			 q
		 }
		 
	}
	s LinksRowID=0
	for
	{
		 s LinksRowID = $o(^dbo.BTSpecimenGroupLinksD(LinksRowID)) q:LinksRowID=""
		 s SpecimenDR= $lg($g(^dbo.BTSpecimenGroupLinksD(LinksRowID)),3)
		
		  if (SpecimenDR=id)
		 {
			 s myInfo=myInfo_"<标本组关联标本>"
			 q
		 }
		 
	}
	i myInfo=""  s return="0^未被引用可删除！"
	
	else  s return="1^在"_myInfo_"表里被引用，不能删除！"
	q return
}

/// Creator:谢海睿
/// CreatDate:2020-2-27
/// Description:通过标本类型代码获取房间rowid
/// w ##class(web.DHCBL.LAB.BTSpecimen).GetRowIdByCode("")
ClassMethod GetRowIdByCode(code As %String) As %String
{
	S RowID=""
	s code=$ZCONVERT(code,"U")
	if (code'="")
	{
		s RowID=0
		for 
		{
			s RowID=$o(^dbo.BTSpecimenD(RowID))
			q:RowID=""
			s Code= $lg($g(^dbo.BTSpecimenD(RowID)),2)		//代码
			q:code=$ZCONVERT(Code,"U")
		}
		
	}
	q RowID
}

}
