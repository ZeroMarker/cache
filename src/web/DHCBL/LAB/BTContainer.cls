/// 名称:标准版检验-采集容器
/// 描述:增删改查
/// 编写者:基础数据平台组 -谢海睿
/// 编写日期: 2019-11-13
Class web.DHCBL.LAB.BTContainer Extends %RegisteredObject
{

/// Creator：谢海睿		
/// CreatDate: 2019-11-13
/// Description：查询
/// Table:dbo.BT_Container
/// Input:id,code,cname,hospital
/// Output:RowID,Code,CName,HospitalDR,Volumn,Color,Remark,Sequence,Active,Photo,ConType
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.LAB.BTContainer","GetList","","5","")
Query GetList(rowid As %String, code As %String, cname As %String, hospital As %String) As %Query(ROWSPEC = "RowID,Code,CName,HospitalDR,Volumn,Color,Remark,Sequence,Active,Photo,ConType")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, cname As %String, hospital As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	s:code'="" code=$$ALPHAUP^SSUTIL4(code)   
	s:cname'="" cname=$$ALPHAUP^SSUTIL4(cname) 
	if (rowid'="") //根据rowid返回该条记录
	{
		s RowID=rowid
		s Code= $lg($g(^dbo.BTContainerD(RowID)),2)		//代码
		s CName= $lg($g(^dbo.BTContainerD(RowID)),3)		// 名称
		s HospitalDR = $lg($g(^dbo.BTContainerD(RowID)),4)	// 医院
		s:HospitalDR'="" HospitalDR=$lg($g(^dbo.BTHospitalD(HospitalDR)),3)	//检验科室对应医院描述
		s Volumn= $lg($g(^dbo.BTContainerD(RowID)),5)    // 容量
		s Color= $lg($g(^dbo.BTContainerD(RowID)),6)       //颜色
		s Remark= $lg($g(^dbo.BTContainerD(RowID)),7)       // 说明
		s Sequence= $lg($g(^dbo.BTContainerD(RowID)),8)    // 序号
		s Active= $lg($g(^dbo.BTContainerD(RowID)),9)      // 激活
		s Photo= $lg($g(^dbo.BTContainerD(RowID)),10)  // 容器图片
		s ConType= $lg($g(^dbo.BTContainerD(RowID)),11) //容器类型
		d OutputRow
	
	}
	else
	{
		k ^tempsequencesort("dbo.BTContainer")
		s RowID=0
		for
		{
			s RowID=$o(^dbo.BTContainerD(RowID)) q:RowID=""
			s Code=$lg($g(^dbo.BTContainerD(RowID)),2)	
			s CName=$lg($g(^dbo.BTContainerD(RowID)),3) 	
			s HospitalDR = $lg($g(^dbo.BTContainerD(RowID)),4)	// 医院
			if (hospital'="")
			{
				if (HospitalDR'=hospital)
				{
					continue
				}
			}
			s:HospitalDR'="" HospitalDR=$lg($g(^dbo.BTHospitalD(HospitalDR)),3)	//检验科室对应医院描述
		
			s Volumn= $lg($g(^dbo.BTContainerD(RowID)),5)    // 容量
			s Color= $lg($g(^dbo.BTContainerD(RowID)),6)       //颜色
			s Remark= $lg($g(^dbo.BTContainerD(RowID)),7)       // 说明
			s Sequence= $lg($g(^dbo.BTContainerD(RowID)),8)    // 序号
			s Active= $lg($g(^dbo.BTContainerD(RowID)),9)      // 激活
			s Photo= $lg($g(^dbo.BTContainerD(RowID)),10)  // 容器图片
			s ConType= $lg($g(^dbo.BTContainerD(RowID)),11) //容器类型
			if (cname'="")           
			{
				s AliasFlag = 0
				s PINYINFlag=""
				s PINYINCODE=""
			    s PINYINFlag=##class(web.DHCBL.BDP.BDPAlias).GetPINYINFlag(cname) /// 是拼音 才去转换拼音码
			  	if (PINYINFlag=1)
        		{
         		 	s PINYINCODE=##class(web.DHCBL.BDP.FunLib).GetPYCODE(CName) 
        		}
        		if (($ZCONVERT(CName,"U")[cname)||(PINYINCODE[cname)) 
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
				s ^tempsequencesort("dbo.BTContainer",Sequence,RowID)=RowID
			}	
		}
		s SequenceSort=""
		for
		{
			s SequenceSort=$o(^tempsequencesort("dbo.BTContainer",SequenceSort))  q:SequenceSort=""
			s RowIDSort=""
			for
			{
				s RowIDSort=$o(^tempsequencesort("dbo.BTContainer",SequenceSort,RowIDSort))  q:RowIDSort=""
				s RowID=RowIDSort
				s Code=$lg($g(^dbo.BTContainerD(RowID)),2)	//代码
				s CName=$lg($g(^dbo.BTContainerD(RowID)),3) 	//名称
				s HospitalDR = $lg($g(^dbo.BTContainerD(RowID)),4)	// 医院
				s:HospitalDR'="" HospitalDR=$lg($g(^dbo.BTHospitalD(HospitalDR)),3)	//检验科室对应医院描述
				s Volumn= $lg($g(^dbo.BTContainerD(RowID)),5)    // 容量
				s Color= $lg($g(^dbo.BTContainerD(RowID)),6)       //颜色
				s Remark= $lg($g(^dbo.BTContainerD(RowID)),7)       // 说明
				s Sequence= $lg($g(^dbo.BTContainerD(RowID)),8)    // 序号
				s Active= $lg($g(^dbo.BTContainerD(RowID)),9)      // 激活
				s:Active="" Active=1		//update 2019-12-17  激活为空时，设为1
				s Photo= $lg($g(^dbo.BTContainerD(RowID)),10)  // 容器图片
				s ConType= $lg($g(^dbo.BTContainerD(RowID)),11) //容器类型
				d OutputRow
			}
		} 
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(RowID,Code,CName,HospitalDR,Volumn,Color,Remark,Sequence,Active,Photo,ConType)
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
/// Description：查询 容器 下拉框
/// Table:dbo.BT_Container
/// Input:id, code, desc
/// Output:RowId,Code,Desc
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.LAB.BTContainer","GetDataForCmb1","","","")
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
		s Code= $lg($g(^dbo.BTContainerD(RowID)),2)		//代码
		s CName= $lg($g(^dbo.BTContainerD(RowID)),3)		//名称
		d OutputRowCmb
	}
	else
	{
		k ^tempsequencecombosort("dbo.BTContainer")
		s:code'="" code=$ZCONVERT(code,"U") //转换成大写
		s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
		s RowID=0
		for 
		{
			s RowID=$o(^dbo.BTContainerD(RowID))
			q:RowID=""
			s Code= $lg($g(^dbo.BTContainerD(RowID)),2)		//代码
			s CName= $lg($g(^dbo.BTContainerD(RowID)),3)		//名称
			s HospitalDR = $lg($g(^dbo.BTContainerD(RowID)),4)	// 医院
			continue:(HospitalDR'=hospital)&&(hospital'="")
			s Sequence= $lg($g(^dbo.BTContainerD(RowID)),8)    // 序号
			s Active= $lg($g(^dbo.BTContainerD(RowID)),9)		//激活
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
				s:Sequence="" Sequence=" "_Sequence
				s ^tempsequencecombosort("dbo.BTContainer",Sequence,RowID)=RowID
			}
		}
		s SequenceSort=""
		for
		{
			s SequenceSort=$o(^tempsequencecombosort("dbo.BTContainer",SequenceSort))  q:SequenceSort=""
			s RowIDSort=""
			for
			{
				s RowIDSort=$o(^tempsequencecombosort("dbo.BTContainer",SequenceSort,RowIDSort))  q:RowIDSort=""
				s RowID=RowIDSort
				s Code= $lg($g(^dbo.BTContainerD(RowID)),2)		//代码
				s CName= $lg($g(^dbo.BTContainerD(RowID)),3)		//名称
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
/// CreatDate: 2019-11-13
/// Description：根据id删除 采集容器
/// Table：dbo.BTContainer
/// Input：id 
/// Return：成功返回true，失败返回false和info
/// Other: w ##class(web.DHCBL.LAB.BTContainer).DeleteData(1)
ClassMethod DeleteData(id) As %String
{

	s result=""
	s flag=..GetRefFlag(id)  //删除限制
	s RefFlag = $p(flag,"^",1)
	if (RefFlag=0)
	{
		s pobj = ##class(dbo.BTContainer).%OpenId(id)
		s eobj = ##class(web.Entity.LAB.BTContainer).%New()
		s eobj.Code = pobj.Code                 //代码
		s eobj.CName = pobj.CName				//名称
		s eobj.HospitalDR = pobj.HospitalDR		//医院
		s eobj.Volumn = pobj.Volumn				//容量
		s eobj.Color=pobj.Color					//颜色
		s eobj.Remark = pobj.Remark				//说明
		s eobj.Sequence = pobj.Sequence			//序号
		s eobj.Active = pobj.Active				//激活
		s eobj.Photo = pobj.Photo				//图片
		s eobj.ConType = pobj.ConType			//容器类型

		d pobj.%Close()
		kill pobj
	
		Tstart
		s sc=##class(dbo.BTContainer).%DeleteId(id)
		IF $$$ISOK(sc){
			Tc
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("dbo.BT_Container","dbo.BTContainer","采集容器",id,eobj.CName,"D",eobj)
		}
		else{
			Trollback
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("采集容器","web.DHCBL.LAB.BTContainer","DeleteData",eobj)
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
/// CreatDate: 2019-11-13
/// Description：新增，修改时打开Form，根据RowID查询
/// Table：dbo.BTContainer
/// Input：RowId
/// Other: w ##class(web.DHCBL.LAB.BTContainer).OpenData(1)
ClassMethod OpenData(id As %String) As %String
{
    s str = ""
	s pobj = ##class(dbo.BTContainer).%OpenId(id) 
	s eobj = ##class(web.Entity.LAB.BTContainer).%New() 
	s eobj.RowID = id
	s eobj.Code = pobj.Code          		//代码
	s eobj.CName = pobj.CName				//名称
	s eobj.HospitalDR=pobj.HospitalDR		//医院
	s eobj.Volumn = pobj.Volumn				//容量
	s eobj.Color=pobj.Color					//颜色
	s eobj.Remark = pobj.Remark				//说明
	s eobj.Sequence = pobj.Sequence			//序号
	s eobj.Active = pobj.Active				//激活
	s eobj.Photo = pobj.Photo				//图片
	s eobj.ConType = pobj.ConType        //容器类型
	d pobj.%Close()
	kill pobj
	s str = eobj.JsonS()
	q str
}

/// Creator:谢海睿
/// CreatDate:2019-11-13
/// Description:数据重复验证方法
/// Table:dbo.BTContainer
/// Input:id, Code, hosp
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.DHCBL.LAB.BTContainer).FormValidate("","","")
ClassMethod FormValidate(id As %String, code As %String, hosp As %String) As %String
{
	s flag = 0
	if (code'="") && (hosp'="")
	{
		s RowID = $o(^dbo.BTContainerI("IndexCode",hosp,##Class(web.DHCBL.BDP.FunLib).IndexData(code),0))
		if (RowID'="")&&(id'=RowID)
		{
			s flag=1
		}
	}
	q flag
}

/// Creator:谢海睿
/// CreatDate: 2019-11-13
/// Description：保存 采集容器
/// Input: eobj As web.Entity.LAB.BTContainer
/// Table：dbo.BTContainer
/// Return:成功返回true，失败返回false
/// Other:w ##class(web.DHCBL.LAB.BTContainer).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.LAB.BTContainer) As %String
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
			
			s obj=##class(dbo.BTContainer).%New()
		}
		else
		{
			s obj=##class(dbo.BTContainer).%OpenId(eobj.RowID)
			s bobj = ##class(web.Entity.LAB.BTContainer).%New()
			s bobj.RowID = eobj.RowID
			s bobj.Code = obj.Code
			s bobj.CName = obj.CName
			s bobj.Volumn = obj.Volumn
			s bobj.Color = obj.Color
			s bobj.HospitalDR=obj.HospitalDR
			s bobj.Remark = obj.Remark
			s bobj.Photo = obj.Photo
		    s bobj.Sequence = obj.Sequence
			s bobj.Active = obj.Active
			s:bobj.Active="" bobj.Active=0
			s bobj.ConType = obj.ConType
		}
		
		s obj.Code = eobj.Code						//代码
		s obj.CName  = eobj.CName 					//名称
		s obj.Volumn = eobj.Volumn					//容量
		s obj.Color = eobj.Color					//颜色
		s obj.HospitalDR=eobj.HospitalDR			//医院
		s obj.Remark = eobj.Remark					//说明
		s obj.Photo = eobj.Photo		        	//图片
		s obj.Sequence = eobj.Sequence				//序号
		s obj.Active = eobj.Active					//激活
		s obj.ConType = eobj.ConType	        	//容器类型
		
		
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc){
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" 
			d:eobj.RowID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("dbo.BT_Container","dbo.BTContainer","采集容器",id,eobj.CName,"A",eobj)
			d:eobj.RowID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("dbo.BT_Container","dbo.BTContainer","采集容器",id,eobj.CName,"U",eobj,bobj)
			
		}else{
			Trollback
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("采集容器","web.DHCBL.LAB.BTContainer","SaveEntity",eobj)
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

/// Description：删除限制
/// Return: 1-被引用不可删除，0-未被引用可删除
/// Other：w ##class(web.DHCBL.LAB.BTContainer).GetRefFlag(1)
ClassMethod GetRefFlag(id As %String) As %String
{
	s return="",myInfo=""
	s RowID=0
	for
	{
		 s RowID = $o(^dbo.BTTestSetD(RowID)) q:RowID=""
		 s ContainerDR= $lg($g(^dbo.BTTestSetD(RowID)),11)
		 if (ContainerDR=id)
		 {
			 s myInfo=myInfo_"<项目组合套>"
			 q
		 }
		 
	}
	s SpecimenRowID=0
	for
	{
		 s SpecimenRowID = $o(^dbo.BTTestSetSpecimenD(SpecimenRowID)) q:SpecimenRowID=""
		 s ContainerDR= $lg($g(^dbo.BTTestSetSpecimenD(SpecimenRowID)),4)
		  if (ContainerDR=id)
		 {
			 s myInfo=myInfo_"<项目组合套关联标本>"
			 q
		 }
		 
	}
	i myInfo=""  s return="0^未被引用可删除！"
	else  s return="1^在"_myInfo_"表里被引用,不能删除！"
	q return
}

/// Creator:谢海睿
/// CreatDate:2020-2-27
/// Description:通过采集容器代码获取房间rowid
/// w ##class(web.DHCBL.LAB.BTContainer).GetRowIdByCode("")
ClassMethod GetRowIdByCode(code As %String) As %String
{
	S RowID=""
	s code=$ZCONVERT(code,"U")
	if (code'="")
	{
		s RowID=0
		for 
		{
			s RowID=$o(^dbo.BTContainerD(RowID))
			q:RowID=""
			s Code= $lg($g(^dbo.BTContainerD(RowID)),2)		//代码
			q:code=$ZCONVERT(Code,"U")
		}
		
	}
	q RowID
}

}
