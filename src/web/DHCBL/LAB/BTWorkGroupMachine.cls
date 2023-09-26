/// 名称:标准版检验维护界面-工作小组
/// 描述:包含增删改查等功能
/// 编写者:基础数据平台-李可凡
/// 编写日期: 2019年11月22日
Class web.DHCBL.LAB.BTWorkGroupMachine Extends %RegisteredObject
{

/// Creator：钟荣枫 		
/// CreatDate: 2019-11-7
/// Description：查询 工作小组 下拉框
/// Table:dbo.BT_WorkGroupMachine
/// Input:id, code, desc
/// Output:RowId,Code,Desc
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.LAB.BTWorkGroupMachine","GetDataForCmb1","","","")
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
		s Code= $lg($g(^dbo.BTWorkGroupMachineD(RowID)),2)		//代码
		s CName= $lg($g(^dbo.BTWorkGroupMachineD(RowID)),3)		//名称
		d OutputRowCmb
	}
	else
	{
		k ^combosort("dbo.BTWorkGroupMachine")
		s:code'="" code=$ZCONVERT(code,"U") //转换成大写
		s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
		s RowID=0
		for 
		{
			s RowID=$o(^dbo.BTWorkGroupMachineD(RowID))
			q:RowID=""
			s Code= $lg($g(^dbo.BTWorkGroupMachineD(RowID)),2)		//代码
			s CName= $lg($g(^dbo.BTWorkGroupMachineD(RowID)),3)		//名称
			s WorkGroupDR= $lg($g(^dbo.BTWorkGroupMachineD(RowID)),4)	//工作组DR
			
			s DepartmentDR=""
			s HospitalDR=""
			s:WorkGroupDR'="" DepartmentDR= $lg($g(^dbo.BTWorkGroupD(WorkGroupDR)),4)		//检验科室
			s:DepartmentDR'="" HospitalDR= $lg($g(^dbo.BTDepartmentD(DepartmentDR)),4)		//医院
			
			continue:(HospitalDR'=hospital)&&(hospital'="")
			s Active= $lg($g(^dbo.BTWorkGroupMachineD(RowID)),10)		//激活标识
			s Sequence= $lg($g(^dbo.BTWorkGroupMachineD(RowID)),9)		//序号,排序用
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
			 	s ^combosort("dbo.BTWorkGroupMachine",Sequence,RowID)=""
				//d OutputRowCmb
			}
		}
		//按照排序输出
		s Sort=""
		for
		{
			s Sort=$o(^combosort("dbo.BTWorkGroupMachine",Sort)) q:Sort=""
			s RowID=""
			for
			{
				s RowID=$o(^combosort("dbo.BTWorkGroupMachine",Sort,RowID))  q:RowID=""
				s Code= $lg($g(^dbo.BTWorkGroupMachineD(RowID)),2)		//代码
				s CName= $lg($g(^dbo.BTWorkGroupMachineD(RowID)),3)		//名称
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
/// CreatDate: 2019年11月14日
/// Description：查询工作小组表
/// Table：dbo.BT_WorkGroupMachine
/// d ##class(%ResultSet).RunQuery("web.DHCBL.LAB.BTWorkGroupMachine","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String, workgroupdr As %String) As %Query(ROWSPEC = "RowID,Code,CName,WorkGroupDR,Leader,Telephone,ReportTempl,RoomDR,Sequence,Active,CommDirection,OwnWorkGroupMachineDR")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, workgroupdr As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	
 	if (rowid'="")
 	{
		s RowID=rowid
		s Code= $lg($g(^dbo.BTWorkGroupMachineD(RowID)),2)		//代码
		s CName= $lg($g(^dbo.BTWorkGroupMachineD(RowID)),3)		//名称
		s WorkGroupDR= $lg($g(^dbo.BTWorkGroupMachineD(RowID)),4)	//工作组DR
		s:WorkGroupDR'="" WorkGroupDR=$lg($g(^dbo.BTWorkGroupD(WorkGroupDR)),3)	//工作组描述
		s Leader= $lg($g(^dbo.BTWorkGroupMachineD(RowID)),5)		//负责人
		s Telephone= $lg($g(^dbo.BTWorkGroupMachineD(RowID)),6)		//联系电话
		s ReportTempl= $lg($g(^dbo.BTWorkGroupMachineD(RowID)),7)	//报告模板
		s RoomDR= $lg($g(^dbo.BTWorkGroupMachineD(RowID)),8)		//所在房间DR
		s:RoomDR'="" RoomDR= $lg($g(^dbo.BTRoomD(RoomDR)),3)		//所在房间描述
		s Sequence= $lg($g(^dbo.BTWorkGroupMachineD(RowID)),9)		//序号
		s Active= $lg($g(^dbo.BTWorkGroupMachineD(RowID)),10)		//激活标识
		s Active=$CASE(Active,"1":"Y",:"N")
		s CommDirection= $lg($g(^dbo.BTWorkGroupMachineD(RowID)),11)		//通讯方式
		s CommDirection=$CASE(CommDirection,"UI":"单向通讯","BI":"双向通讯","LS":"装载列表","UP":"主动上传",:"")
		s OwnWorkGroupMachineDR= $lg($g(^dbo.BTWorkGroupMachineD(RowID)),15)		//所属小组DR
		s:OwnWorkGroupMachineDR'="" OwnWorkGroupMachineDR=$lg($g(^dbo.BTWorkGroupMachineD(OwnWorkGroupMachineDR)),3)	//所属小组描述
		d OutputRow
	 }
	 else
	 {
		k ^tempsequencesort("dbo.BTWorkGroupMachine")
		s:code'="" code=$ZCONVERT(code,"U")
		s:desc'="" desc=$ZCONVERT(desc,"U")	 
	 	s RowID=0
	 	for
	 	{
		 	s RowID=$o(^dbo.BTWorkGroupMachineD(RowID))
		 	q:RowID=""
		 	s Code= $lg($g(^dbo.BTWorkGroupMachineD(RowID)),2)		//代码
			s CName= $lg($g(^dbo.BTWorkGroupMachineD(RowID)),3)		//名称
			s WorkGroupDR= $lg($g(^dbo.BTWorkGroupMachineD(RowID)),4)		//工作组DR
			s Sequence= $lg($g(^dbo.BTWorkGroupMachineD(RowID)),9)		//序号
		 	s PINYIN=""
		 	s:desc'="" PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(CName)
		 	if ($ZCONVERT(Code,"U")[code)&&(($ZCONVERT(CName,"U")[desc)||(PINYIN[desc))&&((WorkGroupDR=workgroupdr)||(workgroupdr=""))
		 	{
			 	s:Sequence="" Sequence=" "
			 	s ^tempsequencesort("dbo.BTWorkGroupMachine",Sequence,RowID)=""
			}
		}
		s Sort=""
		for
		{
			s Sort=$o(^tempsequencesort("dbo.BTWorkGroupMachine",Sort)) q:Sort=""
			s RowID=""
			for
			{
				s RowID=$o(^tempsequencesort("dbo.BTWorkGroupMachine",Sort,RowID))  q:RowID=""
				s Code= $lg($g(^dbo.BTWorkGroupMachineD(RowID)),2)		//代码
				s CName= $lg($g(^dbo.BTWorkGroupMachineD(RowID)),3)		//名称
				s WorkGroupDR= $lg($g(^dbo.BTWorkGroupMachineD(RowID)),4)	//工作组DR
				s:WorkGroupDR'="" WorkGroupDR=$lg($g(^dbo.BTWorkGroupD(WorkGroupDR)),3)	//工作组描述
				s Leader= $lg($g(^dbo.BTWorkGroupMachineD(RowID)),5)		//负责人
				s Telephone= $lg($g(^dbo.BTWorkGroupMachineD(RowID)),6)		//联系电话
				s ReportTempl= $lg($g(^dbo.BTWorkGroupMachineD(RowID)),7)	//报告模板
				s RoomDR= $lg($g(^dbo.BTWorkGroupMachineD(RowID)),8)		//所在房间DR
				s:RoomDR'="" RoomDR= $lg($g(^dbo.BTRoomD(RoomDR)),3)		//所在房间描述
				s Sequence= $lg($g(^dbo.BTWorkGroupMachineD(RowID)),9)		//序号
				s Active= $lg($g(^dbo.BTWorkGroupMachineD(RowID)),10)		//激活标识
				s Active=$CASE(Active,"1":"Y",:"N")
				s CommDirection= $lg($g(^dbo.BTWorkGroupMachineD(RowID)),11)		//通讯方式
				s CommDirection=$CASE(CommDirection,"UI":"单向通讯","BI":"双向通讯","LS":"装载列表","UP":"主动上传",:"")
				s OwnWorkGroupMachineDR= $lg($g(^dbo.BTWorkGroupMachineD(RowID)),15)		//所属小组DR
				s:OwnWorkGroupMachineDR'="" OwnWorkGroupMachineDR=$lg($g(^dbo.BTWorkGroupMachineD(OwnWorkGroupMachineDR)),3)	//所属小组描述
				d OutputRow
			}
		} 	
	 }
 	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(RowID,Code,CName,WorkGroupDR,Leader,Telephone,ReportTempl,RoomDR,Sequence,Active,CommDirection,OwnWorkGroupMachineDR)
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
/// CreatDate: 2019年11月14日
/// function：数据重复校验
/// Table：dbo.BT_WorkGroupMachine
/// Input：id
/// Return："1"(数据重复),"0"(数据不重复)
/// Other：w ##class(web.DHCBL.LAB.BTWorkGroupMachine).FormValidate("","shb","1")
ClassMethod FormValidate(id As %String, code As %String, loc As %String) As %String
{
	s flag=0
	if ((code'="")&&(loc'=""))
	{
		s RowID=$o(^dbo.BTWorkGroupMachineI("IndexCode",loc,##Class(web.DHCBL.BDP.FunLib).IndexData(code),0))
		if (RowID'="")&&(id'=RowID) s flag=1
	}
	
	q flag
}

/// Creator：基础数据平台-李可凡
/// CreatDate: 2019年11月14日
/// function：工作小组Form表单数据加载
/// Input：id
/// Table：dbo.BT_WorkGroupMachine
/// Others：w ##class(web.DHCBL.LAB.BTWorkGroupMachine).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
	 s str=""
	 s obj = ##class(dbo.BTWorkGroupMachine).%OpenId(id)
	 s eobj = ##class(web.Entity.LAB.BTWorkGroupMachine).%New()
	 s eobj.RowID = id				// RowID
	 s eobj.Code=obj.Code			// 代码
	 s eobj.CName= obj.CName		// 名称
	 s eobj.WorkGroupDR=obj.WorkGroupDR		// 工作组
	 s eobj.Leader=obj.Leader				// 负责人
	 s eobj.Telephone=obj.Telephone			// 联系电话
	 s eobj.ReportTempl=obj.ReportTempl		// 报告模板
	 s eobj.RoomDR=obj.RoomDR				// 所在房间
	 s eobj.CommDirection=obj.CommDirection			// 通讯方式
	 s eobj.OwnWorkGroupMachineDR=obj.OwnWorkGroupMachineDR		// 所属小组
	 s eobj.Sequence=obj.Sequence		// 序号
	 s eobj.Active=obj.Active			// 状态
	 d obj.%Close()
	 k obj
	 s str = eobj.JsonS()
	 //s str = "{list:["_str_"]}"
	 q str
}

/// Creator：基础数据平台-李可凡
/// CreatDate: 2019年11月14日
/// function:工作小组删除
/// Table：dbo.BT_WorkGroupMachine
/// w ##class(web.DHCBL.LAB.BTWorkGroupMachine).DeleteData(8)
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
			s obj = ##class(dbo.BTWorkGroupMachine).%OpenId(id)
			s pobj = ##class(web.Entity.LAB.BTWorkGroupMachine).%New()
			s pobj.RowID = id				// RowID
			s pobj.Code=obj.Code			// 代码
			s pobj.CName= obj.CName		// 名称
			s pobj.WorkGroupDR=obj.WorkGroupDR		// 工作组
			s pobj.Leader=obj.Leader				// 负责人
			s pobj.Telephone=obj.Telephone			// 联系电话
			s pobj.ReportTempl=obj.ReportTempl		// 报告模板
			s pobj.RoomDR=obj.RoomDR				// 所在房间
			s pobj.CommDirection=obj.CommDirection			// 通讯方式
			s pobj.OwnWorkGroupMachineDR=obj.OwnWorkGroupMachineDR		// 所属小组
			s pobj.Sequence=obj.Sequence		// 序号
			s pobj.Active=obj.Active			// 状态
			TSTART
			s sc=##class(dbo.BTWorkGroupMachine).%DeleteId(id)
			if (sc=1)
			{
				TCOMMIT
				s result="{success:'true',info:'删除成功！'}"
				d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("dbo.BT_WorkGroupMachine","dbo.BTWorkGroupMachine","工作小组",id,pobj.CName,"D",pobj)
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
/// CreatDate: 2019年11月14日
/// function:工作小组表的新增修改
/// Table：dbo.BT_WorkGroupMachine
ClassMethod SaveEntity(eobj As web.Entity.LAB.BTWorkGroupMachine) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		s:eobj.Active="" eobj.Active="0"
		s flag=..FormValidate(eobj.RowID,eobj.Code,eobj.WorkGroupDR)  //调用重复验证
		if (flag=1)
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		if (eobj.RowID="")
		{
			s obj=##class(dbo.BTWorkGroupMachine).%New()
		}
		else
		{
			s obj=##class(dbo.BTWorkGroupMachine).%OpenId(eobj.RowID)
			s bobj=##class(web.Entity.LAB.BTWorkGroupMachine).%New()
		    s bobj.RowID=eobj.RowID		// RowID
		    s bobj.Code=obj.Code		// 代码
			s bobj.CName= obj.CName		// 名称
			s bobj.WorkGroupDR=obj.WorkGroupDR		// 工作组
			s bobj.Leader=obj.Leader				// 负责人
			s bobj.Telephone=obj.Telephone			// 联系电话
			s bobj.ReportTempl=obj.ReportTempl		// 报告模板
			s bobj.RoomDR=obj.RoomDR				// 所在房间
			s bobj.CommDirection=obj.CommDirection			// 通讯方式
			s bobj.OwnWorkGroupMachineDR=obj.OwnWorkGroupMachineDR		// 所属小组
			s bobj.Sequence=obj.Sequence		// 序号
			s bobj.Active=obj.Active			// 状态
		}
		s obj.Code=eobj.Code		// 代码
		s obj.CName= eobj.CName		// 名称
		s obj.WorkGroupDR=eobj.WorkGroupDR		// 工作组
		s obj.Leader=eobj.Leader				// 负责人
		s obj.Telephone=eobj.Telephone			// 联系电话
		s obj.ReportTempl=eobj.ReportTempl		// 报告模板
		s obj.RoomDR=eobj.RoomDR				// 所在房间
		s obj.CommDirection=eobj.CommDirection			// 通讯方式
		s obj.OwnWorkGroupMachineDR=eobj.OwnWorkGroupMachineDR		// 所属小组
		s obj.Sequence=eobj.Sequence		// 序号
		s obj.Active=eobj.Active			// 状态
		TSTART
		s sc=obj.%Save()
		if (sc=1)
		{
			TCOMMIT
			s id=obj.%Id()
			s result="{success:'true',id:'"_id_"'}"
			d:eobj.RowID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("dbo.BT_WorkGroupMachine","dbo.BTWorkGroupMachine","工作小组",eobj.RowID,eobj.CName,"U",eobj,bobj)
    		d:eobj.RowID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("dbo.BT_WorkGroupMachine","dbo.BTWorkGroupMachine","工作小组",id,eobj.CName,"A",eobj)
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
/// Debug：w ##class(web.DHCBL.LAB.BTWorkGroupMachine).GetRefFlag(1)
ClassMethod GetRefFlag(id As %String) As %String
{
	s return=""
	s myInfo=""
	
	//dbo.BTTestSet
	s TestSetRowID=0
	for 
	{
		s TestSetRowID=$o(^dbo.BTTestSetD(TestSetRowID))
		q:TestSetRowID=""
		s WorkGroupMachineDR=$lg($g(^dbo.BTTestSetD(TestSetRowID)),13)
		if (WorkGroupMachineDR=id)
		{
			s myInfo=myInfo_"<项目组合套>"
			q
		}
	}
	
	//dbo.BTWorkGroupMachine
	s WorkGroupMachineRowID=0
	for 
	{
		s WorkGroupMachineRowID=$o(^dbo.BTWorkGroupMachineD(WorkGroupMachineRowID))
		q:WorkGroupMachineRowID=""
		s OwnWorkGroupMachineDR=$lg($g(^dbo.BTWorkGroupMachineD(WorkGroupMachineRowID)),15)
		if (OwnWorkGroupMachineDR=id)
		{
			s myInfo=myInfo_"<工作小组>"
			q
		}
	}
	
	//dbo.BTCheckValidWGMachine
	s CheckValidWGMachineRowID=0
	for 
	{
		s CheckValidWGMachineRowID=$o(^dbo.BTCheckValidWGMachineD(CheckValidWGMachineRowID))
		q:CheckValidWGMachineRowID=""
		s WorkGroupMachineDR=$lg($g(^dbo.BTCheckValidWGMachineD(CheckValidWGMachineRowID)),3)
		if (WorkGroupMachineDR=id)
		{
			s myInfo=myInfo_"<dbo.BTCheckValidWGMachine>"
			q
		}
	}
	
	s:myInfo="" return="0^未被引用可删除！"
	s:myInfo'="" return="1^在"_myInfo_"表里被引用,不能删除！"
	q return
}

/// Creator:钟荣枫
/// CreatDate:2020-1-17
/// Description:通过工作小组代码获取工作小组rowid
/// w ##class(web.DHCBL.LAB.BTWorkGroupMachine).GetRowIdByCode("SHA02")
ClassMethod GetRowIdByCode(code As %String) As %String
{
	S RowID=""
	s code=$ZCONVERT(code,"U")
	if (code'="")
	{
		s RowID=0
		for 
		{
			s RowID=$o(^dbo.BTWorkGroupMachineD(RowID))
			q:RowID=""
			s Code= $lg($g(^dbo.BTWorkGroupMachineD(RowID)),2)		//代码
			q:code=$ZCONVERT(Code,"U")
		}
	}
	q RowID
}

}
