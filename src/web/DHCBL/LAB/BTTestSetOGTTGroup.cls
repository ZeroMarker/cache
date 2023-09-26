/// 名称:标准版检验-合报告分组
/// 描述:对合报告分组信息的增删改查
/// 编写者:基础数据平台组 -钟荣枫
/// 编写日期: 2020-4-16
Class web.DHCBL.LAB.BTTestSetOGTTGroup Extends %RegisteredObject
{

/// Creator：钟荣枫		
/// CreatDate: 2020-4-16
/// Description：用于列表查询
/// Table:dbo.BTTestSetOGTTGroup	合报告分组
/// Input:id,code 代码,cname 描述,testset 主组合套，hospital 医院
/// Output:RowID,Code,CName,MainTestSetDR,HospitalDR,Sequence,Active 如 2:cs01:测试1:血脂四项:标准版数字化医院[总院]:1:1:
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.LAB.BTTestSetOGTTGroup","GetList","","","","","")
Query GetList(rowid As %String, code As %String, cname As %String, testset As %String, hospital As %String) As %Query(ROWSPEC = "RowID,Code,CName,MainTestSetDR,HospitalDR,Sequence,Active,MainTestSetDesc")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, cname As %String, testset As %String, hospital As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	s:code'="" code=$ZCONVERT(code,"U")   
	s:cname'="" cname=$ZCONVERT(cname,"U") 
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s RowID=rowid
		s Code= $lg($g(^dbo.BTTestSetOGTTGroupD(RowID)),2)		//代码
		s CName= $lg($g(^dbo.BTTestSetOGTTGroupD(RowID)),3)		// 名称
		s MainTestSetDR=$lg($g(^dbo.BTTestSetOGTTGroupD(RowID)),4)	//主组合套
		s MainTestSetDesc=""
		s:MainTestSetDR'="" MainTestSetDesc=$lg($g(^dbo.BTTestSetD(MainTestSetDR)),3)	//主组合套描述
		s HospitalDR = $lg($g(^dbo.BTTestSetOGTTGroupD(RowID)),5)	// 医院
		s:HospitalDR'="" HospitalDR=$lg($g(^dbo.BTHospitalD(HospitalDR)),3)	//医院
		s Sequence= $lg($g(^dbo.BTTestSetOGTTGroupD(RowID)),6)    // 序号
		s Active= $lg($g(^dbo.BTTestSetOGTTGroupD(RowID)),7)       //激活
		s:Active="" Active=1		//  激活为空时，设为1
		d OutputRow
	}
	else
	{
		k ^tempsequencesort("dbo.BTTestSetOGTTGroup")
		s RowID=0
		for
		{
			s RowID=$o(^dbo.BTTestSetOGTTGroupD(RowID)) q:RowID=""
			s Code= $lg($g(^dbo.BTTestSetOGTTGroupD(RowID)),2)		//代码
			s CName= $lg($g(^dbo.BTTestSetOGTTGroupD(RowID)),3)		// 名称
			s MainTestSetDR=$lg($g(^dbo.BTTestSetOGTTGroupD(RowID)),4)	//主组合套
			s MainTestSetDesc=""
			if (testset'="")&&(MainTestSetDR'=testset)	//过滤主组合套
			{
				continue
			}
			s HospitalDR = $lg($g(^dbo.BTTestSetOGTTGroupD(RowID)),5)	// 医院
			if (hospital'="")&&(HospitalDR'=hospital)	//过滤医院
			{
				continue
			}
			s Sequence= $lg($g(^dbo.BTTestSetOGTTGroupD(RowID)),6)    // 序号
			
			
			if (cname'="")
			{
				s AliasFlag=0
			  	s PINYINFlag=""  
			 	s PINYINCODE=""
			  	s PINYINFlag=##class(web.DHCBL.BDP.BDPAlias).GetPINYINFlag(cname) 
			  	if (PINYINFlag=1)		// 是拼音 才去转换拼音码
    		  	{
     		 		s PINYINCODE=##class(web.DHCBL.BDP.FunLib).GetPYCODE(CName) 
    		  	}	
				if (($ZCONVERT(CName,"U")[cname)||(PINYINCODE[cname)) //过滤描述
			 	{
					s AliasFlag=1	
			 	}
			 }
			 else
			 {
				s AliasFlag= 1
			 } 
		   	 if ($ZCONVERT(Code,"U")[code)&&(AliasFlag=1) //过滤代码
			 {
				s:Sequence="" Sequence=" "_Sequence
				s ^tempsequencesort("dbo.BTTestSetOGTTGroup",Sequence,RowID)=RowID
			 }
		}
	
		s SequenceSort=""
		for
		{
			s SequenceSort=$o(^tempsequencesort("dbo.BTTestSetOGTTGroup",SequenceSort))  q:SequenceSort=""
			s RowIDSort=""
			for
			{
				s RowIDSort=$o(^tempsequencesort("dbo.BTTestSetOGTTGroup",SequenceSort,RowIDSort))  q:RowIDSort=""
				s RowID=RowIDSort
				s Code= $lg($g(^dbo.BTTestSetOGTTGroupD(RowID)),2)		//代码
				s CName= $lg($g(^dbo.BTTestSetOGTTGroupD(RowID)),3)		// 名称
				s MainTestSetDR=$lg($g(^dbo.BTTestSetOGTTGroupD(RowID)),4)	//主组合套
				s MainTestSetDesc=""
				s:MainTestSetDR'="" MainTestSetDesc=$lg($g(^dbo.BTTestSetD(MainTestSetDR)),3)	//主组合套描述
				s HospitalDR = $lg($g(^dbo.BTTestSetOGTTGroupD(RowID)),5)	// 医院
				s:HospitalDR'="" HospitalDR=$lg($g(^dbo.BTHospitalD(HospitalDR)),3)	//医院
				s Sequence= $lg($g(^dbo.BTTestSetOGTTGroupD(RowID)),6)    // 序号
				s Active= $lg($g(^dbo.BTTestSetOGTTGroupD(RowID)),7)       //激活
				s:Active="" Active=1		//  激活为空时，设为1
				d OutputRow
			}
		} 
		
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(RowID,Code,CName,MainTestSetDR,HospitalDR,Sequence,Active,MainTestSetDesc)
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
/// CreatDate: 2020-4-16
/// Description：查询 合报告分组 下拉框
/// Table：dbo.BTTestSetOGTTGroup  合报告分组
/// Input：RowID, cname
/// Output:: RowID,Code 代码,CName 描述
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.LAB.BTTestSetOGTTGroup","GetDataForCmb1","","","")
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
		s Code= $lg($g(^dbo.BTTestSetOGTTGroupD(RowID)),2)		//代码
		s CName= $lg($g(^dbo.BTTestSetOGTTGroupD(RowID)),3)		//名称
		d OutputRowCmb	
	}
	else
	{
		k ^tempsequencecombosort("dbo.BTTestSetOGTTGroup")
		s RowID=0
		for 
		{
			s RowID=$o(^dbo.BTTestSetOGTTGroupD(RowID))
			q:RowID=""
			s Code= $lg($g(^dbo.BTTestSetOGTTGroupD(RowID)),2)	//代码
			s CName= $lg($g(^dbo.BTTestSetOGTTGroupD(RowID)),3)		//名称
			s Sequence= $lg($g(^dbo.BTTestSetOGTTGroupD(RowID)),6)    // 序号
			s Active= $lg($g(^dbo.BTTestSetOGTTGroupD(RowID)),7)		//激活
			continue:Active=0			//过滤未激活状态数据
			if (cname'="")		//描述不为空
			{
				s AliasFlag=0
			  	s PINYINFlag=""  
			 	s PINYINCODE=""
			  	s PINYINFlag=##class(web.DHCBL.BDP.BDPAlias).GetPINYINFlag(cname) 
			  	if (PINYINFlag=1)	// 是拼音 才去转换拼音码
    		  	{
     		 		s PINYINCODE=##class(web.DHCBL.BDP.FunLib).GetPYCODE(CName) 
    		  	}	
				if (($ZCONVERT(CName,"U")[cname)||(PINYINCODE[cname)) //过滤描述
			 	{
					s AliasFlag=1	
			 	}
			 }
			 else
			 {
				s AliasFlag= 1
			 }
			 if ($ZCONVERT(Code,"U")[code)&&(AliasFlag=1) //过滤代码
			 {
				s:Sequence="" Sequence=" "_Sequence
				s ^tempsequencecombosort("dbo.BTTestSetOGTTGroup",Sequence,RowID)=RowID
			}
		}
		s SequenceSort=""
		for
		{
			s SequenceSort=$o(^tempsequencecombosort("dbo.BTTestSetOGTTGroup",SequenceSort))  q:SequenceSort=""
			s RowIDSort=""
			for
			{
				s RowIDSort=$o(^tempsequencecombosort("dbo.BTTestSetOGTTGroup",SequenceSort,RowIDSort))  q:RowIDSort=""
				s RowID=RowIDSort
				s Code= $lg($g(^dbo.BTTestSetOGTTGroupD(RowID)),2)		//代码
				s CName= $lg($g(^dbo.BTTestSetOGTTGroupD(RowID)),3)		//名称
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

/// Creator：钟荣枫
/// CreatDate: 2020-4-16
/// Description：根据id删除 合报告分组
/// Table：dbo.BTTestSetOGTTGroup 合报告分组
/// Input：id 
/// Return:成功返回true，失败返回false和info
/// Other: w ##class(web.DHCBL.LAB.BTTestSetOGTTGroup).DeleteData(1)
ClassMethod DeleteData(id) As %String
{

	s result=""
	s flag=..GetRefFlag(id)  //删除限制
	s RefFlag = $p(flag,"^",1)
	if (RefFlag=0)	//未被引用
	{
		s pobj = ##class(dbo.BTTestSetOGTTGroup).%OpenId(id)
		s eobj = ##class(web.Entity.LAB.BTTestSetOGTTGroup).%New()
		s eobj.Code = pobj.Code             //代码
		s eobj.CName = pobj.CName			//名称
		s eobj.MainTestSetDR=pobj.MainTestSetDR		//主组合套
		s eobj.HospitalDR = pobj.HospitalDR //医院
		s eobj.Sequence = pobj.Sequence			//排序
		s eobj.Active = pobj.Active			//激活
		d pobj.%Close()
		kill pobj
	
		Tstart
		s sc=##class(dbo.BTTestSetOGTTGroup).%DeleteId(id)
		IF $$$ISOK(sc)		//删除成功
		{
			Tc
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("dbo.BT_TestSetOGTTGroup","dbo.BTTestSetOGTTGroup","合报告分组",id,eobj.CName,"D",eobj)
		}
		else		//删除失败
		{
			Trollback
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("合报告分组","web.DHCBL.LAB.BTTestSetOGTTGroup","DeleteData",eobj)
			s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		}
	
	}
	else	//被引用
	{
		s result="{success:'false',info:'"_$p(flag,"^",2)_"'}"
	}
	 q result
}

/// Creator：钟荣枫
/// CreatDate: 2020-4-16
/// Description：新增，修改时打开Form，根据RowID查询
/// Table：dbo.BTTestSetOGTTGroup  合报告分组
/// Input：id
/// Return:JSON字符串 如 {list:[{"Active":"1","CName":"测试1","Code":"cs01","HospitalDR":"1","MainTestSet  DR":"1","RowID":"2","Sequence":"1"}]}
/// Other: w ##class(web.DHCBL.LAB.BTTestSetOGTTGroup).OpenData(2)
ClassMethod OpenData(id As %String, RetFlag As %String = "") As %String
{
    s str = ""
	s pobj = ##class(dbo.BTTestSetOGTTGroup).%OpenId(id) 
	s eobj = ##class(web.Entity.LAB.BTTestSetOGTTGroup).%New() 
	s eobj.RowID = id
	s eobj.Code = pobj.Code					//代码
	s eobj.CName = pobj.CName				//名称
	s eobj.MainTestSetDR=pobj.MainTestSetDR		//主组合套
	s eobj.HospitalDR=pobj.HospitalDR		//医院
	s eobj.Sequence = pobj.Sequence				//排序
	s eobj.Active = pobj.Active				//激活
	s str = eobj.JsonS()
	d eobj.%Close()
	if (RetFlag'="JSON")	//RetFlag=""时，用于EXT, =JSON时，用于HISUI，不输出 "{list:["_str_"]}"
	{
		s str = "{list:["_str_"]}"
	}
	q str
}

/// Creator:钟荣枫
/// CreatDate:2020-4-16
/// Description:数据重复验证方法
/// Table:dbo.BTTestSetOGTTGroup
/// Input:id, code 代码, hosp 医院
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.DHCBL.LAB.BTTestSetOGTTGroup).FormValidate("","","")
ClassMethod FormValidate(id As %String, code As %String, hosp As %String) As %String
{
	s flag = 0
	if (code'="") && (hosp'="")		//代码、医院均不为空
	{
		s RowID = $o(^dbo.BTTestSetOGTTGroupI("IndexCode",hosp,##Class(web.DHCBL.BDP.FunLib).IndexData(code),0))
		if (RowID'="")&&(id'=RowID)		//数据修改
		{
			s flag=1
		}
	}
	q flag
}

/// Creator:钟荣枫
/// CreatDate: 2020-4-16
/// Description：保存 合报告分组
/// Input: eobj As web.Entity.LAB.BTTestSetOGTTGroup
/// Table：dbo.BTTestSetOGTTGroup
/// Return:成功返回true，失败返回false
/// Other:w ##class(web.DHCBL.LAB.BTTestSetOGTTGroup).SaveEntity()
ClassMethod SaveEntity(eobj As web.Entity.LAB.BTTestSetOGTTGroup) As %String
{
	s result=""
	if $IsObject(eobj)		//对象存在
	{	s:eobj.Active="" eobj.Active=0
		s flag=..FormValidate(eobj.RowID,eobj.Code,eobj.HospitalDR)  //调用重复验证
		if (flag=1)	//数据重复
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		if (eobj.RowID="")	//新增
		{	
			
			s obj=##class(dbo.BTTestSetOGTTGroup).%New()
		}	
		else	//修改
		{
			s obj=##class(dbo.BTTestSetOGTTGroup).%OpenId(eobj.RowID)
			s bobj = ##class(web.Entity.LAB.BTTestSetOGTTGroup).%New()
			s bobj.RowID = eobj.RowID		//代码
			s bobj.Code = obj.Code			//名称
			s bobj.CName = obj.CName
			s bobj.MainTestSetDR=obj.MainTestSetDR		//主组合套
		    s bobj.HospitalDR=obj.HospitalDR		//医院
			s bobj.Sequence = obj.Sequence		//排序
			s bobj.Active = obj.Active		//激活	
		}
		
		s obj.Code = eobj.Code				//代码
		s obj.CName  = eobj.CName 			//名称
		s obj.MainTestSetDR=eobj.MainTestSetDR		//主组合套
		s obj.HospitalDR=eobj.HospitalDR	//医院		        
		s obj.Sequence = eobj.Sequence			//排序
		s obj.Active = eobj.Active			//激活	        
		
		
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc){
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			d:eobj.RowID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("dbo.BT_TestSetOGTTGroup","dbo.BTTestSetOGTTGroup","合报告分组",id,eobj.CName,"A",eobj)
			d:eobj.RowID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("dbo.BT_TestSetOGTTGroup","dbo.BTTestSetOGTTGroup","合报告分组",id,eobj.CName,"U",eobj,bobj)
			
		}else{
			Trollback
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("合报告分组","web.DHCBL.LAB.BTTestSetOGTTGroup","SaveEntity",eobj)
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
/// CreatDate: 2020-4-16
/// Description：删除限制
/// Input: id
/// Return:1-被引用不可删除，0-未被引用可删除
/// Other：w ##class(web.DHCBL.LAB.BTTestSetOGTTGroup).GetRefFlag()
ClassMethod GetRefFlag(id As %String) As %String
{
	s return = "" ,myInfo=""
	//BT_TestSetOGTTGroupLinks 合报告分组关联
	s RowID=0
	for
	{
		 s RowID = $o(^dbo.BTTestSetOGTTGroupLinksD(RowID)) q:RowID=""
		 s TestSetOGTTGroupDR = $lg($g(^dbo.BTTestSetOGTTGroupLinksD(RowID)),2)
		 if (TestSetOGTTGroupDR=id)		//被引用
		 {
			 s myInfo=myInfo_"<合报告分组关联>"
			 q
		 }
	}
	if myInfo="" s return="0^未被引用可删除！"
	else  s return="1^在"_myInfo_"表里被引用，不能删除！"
	q return
}

/// Creator:钟荣枫
/// CreatDate: 2020-4-16
/// Description：通过合报告分组代码获取合报告分组rowid
/// Input: code
/// Return:rowid
/// Others: w ##class(web.DHCBL.LAB.BTTestSetOGTTGroup).GetRowIdByCode("")
ClassMethod GetRowIdByCode(code As %String) As %String
{
	S RowID=""
	s code=$ZCONVERT(code,"U")
	if (code'="")	//代码不为空
	{
		s RowID=0
		for 
		{
			s RowID=$o(^dbo.BTTestSetOGTTGroupD(RowID))
			q:RowID=""
			s Code= $lg($g(^dbo.BTTestSetOGTTGroupD(RowID)),2)		//代码
			q:code=$ZCONVERT(Code,"U")
		}
		
	}
	q RowID
}

}
