/// 名称:检验标本维护 - 标本组
/// 编写者:基础平台组 - 谢海睿
/// 编写日期:2019-11-15
Class web.DHCBL.LAB.BTSpecimenGroup Extends %RegisteredObject
{

/// Creator 谢海睿		
/// CreatDate: 2019-11-15
/// Description：查询 标本组 下拉框
/// Table:dbo.BTSpecimenGroup
/// Input:id, code, cname
/// Output:RowID,Code,CName
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.LAB.BTSpecimenGroup","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, cname As %String) As %Query(ROWSPEC = "RowID,Code,CName")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, cname As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	s:cname'="" cname=$ZCONVERT(cname,"U") //转换成大写
	if (rowid'="") //根据rowid返回该条记录
	{
		s RowID=rowid
		s Code= $lg($g(^dbo.BTSpecimenGroupD(RowID)),2)		//代码
		s CName= $lg($g(^dbo.BTSpecimenGroupD(RowID)),3)		//名称
		
		d OutputRowCmb	
	}
	else
	{
		k ^tempsequencecombosort("dbo.BTSpecimenGroup")
		s RowID=0
		for 
		{
			s RowID=$o(^dbo.BTSpecimenGroupD(RowID))
			q:RowID=""
			s Code= $lg($g(^dbo.BTSpecimenGroupD(RowID)),2)	//代码
			s CName= $lg($g(^dbo.BTSpecimenGroupD(RowID)),3)		//名称
			s Sequence= $lg($g(^dbo.BTSpecimenGroupD(RowID)),5)    // 序号
			s Active= $lg($g(^dbo.BTSpecimenGroupD(RowID)),6)		//激活
			continue:Active=0			//过滤未激活状态数据
			if (cname'="")           
			{
				;需要对描述或者别名进行检索 
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
				s ^tempsequencesort("dbo.BTSpecimenGroup",Sequence,RowID)=RowID
				;d OutputRowCmb
			}
		}
		s SequenceSort=""
		for
		{
			s SequenceSort=$o(^tempsequencesort("dbo.BTSpecimenGroup",SequenceSort))  q:SequenceSort=""
			s RowIDSort=""
			for
			{
				s RowIDSort=$o(^tempsequencesort("dbo.BTSpecimenGroup",SequenceSort,RowIDSort))  q:RowIDSort=""
				s RowID=RowIDSort
				s Code= $lg($g(^dbo.BTSpecimenGroupD(RowID)),2)		//代码
				s CName= $lg($g(^dbo.BTSpecimenGroupD(RowID)),3)		//名称
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
/// CreatDate: 2019-11-27
/// Description：查询 标本组
/// Table:dbo.BTSpecimenGroup
/// Input:rowid,code,cname
/// Output:RowID,Code,CName,HospitalDR,Sequence,Active
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.LAB.BTSpecimenGroup","GetList","","","无菌试管","")
Query GetList(rowid As %String, code As %String, cname As %String, hospital As %String) As %Query(ROWSPEC = "RowID,Code,CName,HospitalDR,Sequence,Active")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, cname As %String, hospital As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s:code'="" code=$$ALPHAUP^SSUTIL4(code)   //$ZCONVERT(code,"U")
	s:cname'="" cname=$$ALPHAUP^SSUTIL4(cname) //$ZCONVERT(IName,"U")
	if (rowid'="") //根据rowid返回该条记录
	{
		s RowID=rowid
		s Code= $lg($g(^dbo.BTSpecimenGroupD(RowID)),2)		//代码
		s CName= $lg($g(^dbo.BTSpecimenGroupD(RowID)),3)		// 名称
		s HospitalDR = $lg($g(^dbo.BTSpecimenGroupD(RowID)),4)	// 医院
		s:HospitalDR'="" HospitalDR=$lg($g(^dbo.BTHospitalD(HospitalDR)),3)	//检验科室对应医院描述
		s Sequence= $lg($g(^dbo.BTSpecimenGroupD(RowID)),5)    // 序号
		s Active= $lg($g(^dbo.BTSpecimenGroupD(RowID)),6)       //激活
		s:Active="" Active=1		//update 2019-12-17  激活为空时，设为1
		d OutputRow
	}
	else
	{
		k ^tempsequencesort("dbo.BTSpecimenGroup")
		s RowID=0
		for
		{
			s RowID=$o(^dbo.BTSpecimenGroupD(RowID)) q:RowID=""
			s Code=$lg($g(^dbo.BTSpecimenGroupD(RowID)),2)	
			s CName=$lg($g(^dbo.BTSpecimenGroupD(RowID)),3) 	
			s HospitalDR = $lg($g(^dbo.BTSpecimenGroupD(RowID)),4)	// 医院
			if (hospital'="")
			{
				if (HospitalDR'=hospital)
				{
					continue
				}
			}
			s:HospitalDR'="" HospitalDR=$lg($g(^dbo.BTHospitalD(HospitalDR)),3)	//检验科室对应医院描述
			s Sequence= $lg($g(^dbo.BTSpecimenGroupD(RowID)),5)    // 序号
			s Active= $lg($g(^dbo.BTSpecimenGroupD(RowID)),6)       //激活
			s:Active="" Active=1		//update 2019-12-17  激活为空时，设为1
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
				  if (($ZCONVERT(CName,"U")[cname)||(PINYINCODE[cname)) 
				  {
					s AliasFlag=1	
				  }
			 }
			else
			{
				s AliasFlag= 1
			} 
			i ($ZCONVERT(Code,"U")[code)&&(AliasFlag=1) //包含
			{
				s:Sequence="" Sequence=" "_Sequence
				s ^tempsequencesort("dbo.BTSpecimenGroup",Sequence,RowID)=RowID
				;d OutputRow
			}
		}
		s SequenceSort=""
		for
		{
			s SequenceSort=$o(^tempsequencesort("dbo.BTSpecimenGroup",SequenceSort))  q:SequenceSort=""
			s RowIDSort=""
			for
			{
				s RowIDSort=$o(^tempsequencesort("dbo.BTSpecimenGroup",SequenceSort,RowIDSort))  q:RowIDSort=""
				s RowID=RowIDSort
				s Code= $lg($g(^dbo.BTSpecimenGroupD(RowID)),2)		//代码
				s CName= $lg($g(^dbo.BTSpecimenGroupD(RowID)),3)		//名称
				s HospitalDR= $lg($g(^dbo.BTSpecimenGroupD(RowID)),4)		//医院
				s:HospitalDR'="" HospitalDR= $lg($g(^dbo.BTHospitalD(HospitalDR)),3)
				s Sequence=$lg($g(^dbo.BTSpecimenGroupD(RowID)),5)		//序号
				s Active=$lg($g(^dbo.BTSpecimenGroupD(RowID)),6)		//激活
				s:Active="" Active=1		//update 2019-12-17  激活为空时，设为1
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

/// Creator：谢海睿
/// CreatDate: 2019-11-27
/// Description：根据id删除 标本组
/// Table：dbo.BTSpecimenGroup
/// Input：RowID 
/// Return：成功返回true，失败返回false和info
/// Other: w ##class(web.DHCBL.LAB.BTSpecimenGroup).DeleteData(6)
ClassMethod DeleteData(id) As %String
{

	s result=""
	
	s flag=..GetRefFlag(id)  //删除限制
	s RefFlag = $p(flag,"^",1)
	if (RefFlag=0)
	{
		s pobj = ##class(dbo.BTSpecimenGroup).%OpenId(id)
		s eobj = ##class(web.Entity.LAB.BTSpecimenGroup).%New()
		s eobj.Code = pobj.Code					//代码
		s eobj.CName = pobj.CName				//名称
		s eobj.HospitalDR = pobj.HospitalDR 	//医院
		s eobj.Sequence = pobj.Sequence			//序号
		s eobj.Active = pobj.Active				//激活
		d pobj.%Close()
		kill pobj
	
		Tstart
		s sc=##class(dbo.BTSpecimenGroup).%DeleteId(id)
		IF $$$ISOK(sc){
			Tc
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("dbo.BT_SpecimenGroup","dbo.BTSpecimenGroup","标本组",id,eobj.CName,"D",eobj)
		}
		else{
			Trollback
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("标本组","web.DHCBL.LAB.BTSpecimenGroup","DeleteData",eobj)
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
/// CreatDate: 2019-11-27
/// Description：新增，修改时打开Form，根据RowID查询
/// Table：dbo.BTSpecimenGroup
/// Input：RowID
/// Other: w ##class(web.DHCBL.LAB.BTSpecimenGroup).OpenData(2)
ClassMethod OpenData(id As %String) As %String
{
	
    s str = ""
	s pobj = ##class(dbo.BTSpecimenGroup).%OpenId(id) 
	s eobj = ##class(web.Entity.LAB.BTSpecimenGroup).%New() 
	s eobj.RowID = id
	s eobj.Code = pobj.Code                  //代码
	s eobj.CName = pobj.CName  				 //名称
	s eobj.HospitalDR=pobj.HospitalDR		 //医院
	s eobj.Sequence = pobj.Sequence		     //序号
	s eobj.Active = pobj.Active				 //激活
	d pobj.%Close()
	kill pobj
	s str = eobj.JsonS()
	q str
}

/// Creator:谢海睿
/// CreatDate:2019-11-15
/// Description:数据重复验证方法
/// Table:dbo.BTSpecimenGroup
/// Input:RowID, code, hosp
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.DHCBL.LAB.BTSpecimenGroup).FormValidate("","test","13")
ClassMethod FormValidate(id As %String, code As %String, hosp As %String) As %String
{
	s flag = 0
	if (code'="") && (hosp'="")
	{
		s RowID = $o(^dbo.BTSpecimenGroupI("IndexCode",hosp,##Class(web.DHCBL.BDP.FunLib).IndexData(code),0))
		if (RowID'="")&&(id'=RowID)
		{
			s flag=1
		}
	}
	q flag
}

/// Creator:谢海睿
/// CreatDate: 2019-11-15
/// Description：保存 标本组
/// Input: eobj As web.Entity.LAB.BTSpecimenGroup
/// Table：dbo.BTSpecimenGroup
/// Return:成功返回true，失败返回false
/// Other:w ##class(web.DHCBL.LAB.BTSpecimenGroup).SaveEntity()
ClassMethod SaveEntity(eobj As web.Entity.LAB.BTSpecimenGroup) As %String
{
	s result=""
	if $IsObject(eobj)
	{	
		s:eobj.Active="" eobj.Active=0
		s flag=..FormValidate(eobj.RowID,eobj.Code,eobj.HospitalDR)  //调用重复验证
		if (flag=1)
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		if (eobj.RowID="")
		{	
			
			s obj=##class(dbo.BTSpecimenGroup).%New()
		}
		else
		{
			s obj=##class(dbo.BTSpecimenGroup).%OpenId(eobj.RowID)
			s bobj = ##class(web.Entity.LAB.BTSpecimenGroup).%New()
			s bobj.RowID = eobj.RowID
			s bobj.Code = obj.Code
			s bobj.CName = obj.CName
		    s bobj.HospitalDR=obj.HospitalDR
			s bobj.Sequence = obj.Sequence
			s bobj.Active = obj.Active
		}
		s obj.Code = eobj.Code				//代码
		s obj.CName  = eobj.CName 			//名称
		s obj.HospitalDR=eobj.HospitalDR	//医院	        
		s obj.Sequence = eobj.Sequence		//排序
		s obj.Active = eobj.Active			//激活      
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc){
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			d:eobj.RowID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("dbo.BT_SpecimenGroup","dbo.BTSpecimenGroup","标本组",id,eobj.CName,"A",eobj)
			d:eobj.RowID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("dbo.BT_SpecimenGroup","dbo.BTSpecimenGroup","标本组",id,eobj.CName,"U",eobj,bobj)
			
		}else{
			Trollback
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("标本组","web.DHCBL.LAB.BTSpecimenGroup","SaveEntity",eobj)
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
/// Input：RowID
/// Other：w ##class(web.DHCBL.LAB.BTSpecimenGroup).GetRefFlag(6)
ClassMethod GetRefFlag(id As %String) As %String
{
	s return = "",myInfo=""
	s RowID=0
	for
	{
		 s RowID = $o(^dbo.BTSpecimenD(RowID)) q:RowID=""
		 s SpecimenGroupDR = $lg($g(^dbo.BTSpecimenD(RowID)),9)
		 if (SpecimenGroupDR=id)
		 {
			 s myInfo=myInfo_"<标本类型>"
			 q
		 }
	}
	s LinksRowID=0
	for
	{
		 
		 s LinksRowID = $o(^dbo.BTSpecimenGroupLinksD(LinksRowID)) q:LinksRowID=""
		 s SpecimenGroupDR = $lg($g(^dbo.BTSpecimenGroupLinksD(LinksRowID)),2)
		  if (SpecimenGroupDR=id)
		 {
			 s myInfo=myInfo_"<标本组关联标本>"
			 q
		 }
	}
	i (myInfo="") s return="0^未被引用可删除！"	
	else  s return="1^在"_myInfo_"表里被引用,不能删除！"
	q return
}

/// Creator:谢海睿
/// CreatDate:2020-2-27
/// Description:通过标本组代码获取房间rowid
/// w ##class(web.DHCBL.LAB.BTSpecimenGroup).GetRowIdByCode("")
ClassMethod GetRowIdByCode(code As %String) As %String
{
	S RowID=""
	s code=$ZCONVERT(code,"U")
	if (code'="")
	{
		s RowID=0
		for 
		{
			s RowID=$o(^dbo.BTSpecimenGroupD(RowID))
			q:RowID=""
			s Code= $lg($g(^dbo.BTSpecimenGroupD(RowID)),2)		//代码
			q:code=$ZCONVERT(Code,"U")
		}
		
	}
	q RowID
}

}
