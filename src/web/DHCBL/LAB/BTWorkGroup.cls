/// 名称:标准版检验-工作组
/// 描述:包含增删改查功能
/// 编写者:基础数据平台组 -钟荣枫
/// 编写日期: 2019-11-5
Class web.DHCBL.LAB.BTWorkGroup Extends %RegisteredObject
{

/// Creator：钟荣枫		
/// CreatDate: 2019-11-5
/// Description：查询 工作组
/// Table：dbo.BT_WorkGroup
/// Input：rowid, code,desc,loc,hospital,active
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.LAB.BTWorkGroup","GetList","","","","17","","")
Query GetList(rowid As %String, code As %String, desc As %String, loc As %String, hospital As %String, active As %String) As %Query(ROWSPEC = "RowID,Code,CName,DepartmentDR,Leader,Telephone,ShowOperator,DoubleCheck,ReportTempl,RoomDR,WPath,Sequence,Active,LabType,IsCALogin,IsShowSet,LockUserSecond,IsUnacceptToClinical,LinkWorkGroupDR,HospitalDR")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, loc As %String, hospital As %String, active As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写

	if (rowid'="") //根据rowid返回该条记录
	{
		
		s RowID=rowid
		
		s Code= $lg($g(^dbo.BTWorkGroupD(RowID)),2)		//代码
		s CName= $lg($g(^dbo.BTWorkGroupD(RowID)),3)		//名称
		s DepartmentDR= $lg($g(^dbo.BTWorkGroupD(RowID)),4)		//检验科室
		
		s HospitalDR=""												//update2019-11-20 
		if (DepartmentDR'="") {
			s HospitalDR= $lg($g(^dbo.BTDepartmentD(DepartmentDR)),4)		//医院
			s DepartmentDR=$lg($g(^dbo.BTDepartmentD(DepartmentDR)),3)	//检验科室描述
		} 
		s HospitalDesc=""
		s:HospitalDR'="" HospitalDR=$lg($g(^dbo.BTHospitalD(HospitalDR)),3)	//检验科室对应医院描述
		s Leader= $lg($g(^dbo.BTWorkGroupD(RowID)),5)		//负责人
		s Telephone= $lg($g(^dbo.BTWorkGroupD(RowID)),6)		//联系电话
		s ShowOperator= $lg($g(^dbo.BTWorkGroupD(RowID)),7)	//是否显示操作者
		s:ShowOperator="" ShowOperator=0
		s DoubleCheck= $lg($g(^dbo.BTWorkGroupD(RowID)),8)	//是否双签字
		s:DoubleCheck="" DoubleCheck=0
		s ReportTempl= $lg($g(^dbo.BTWorkGroupD(RowID)),9)	//报告模版 
		s RoomDR= $lg($g(^dbo.BTWorkGroupD(RowID)),10)		//所在房间
		s:RoomDR'="" RoomDR=$lg($g(^dbo.BTRoomD(RoomDR)),3)			//所在房间描述
		s WPath= $lg($g(^dbo.BTWorkGroupD(RowID)),11)		//WHONET 导出文件路径
		s Sequence= $lg($g(^dbo.BTWorkGroupD(RowID)),12)		//序号
		s Active= $lg($g(^dbo.BTWorkGroupD(RowID)),13)		//Active 状态
		s:Active="" Active=1	//update 2019-12-17  激活为空时，设为1
		s LabType= $lg($g(^dbo.BTWorkGroupD(RowID)),14)		//实验室类型(N 常规,C 细胞学,H 组织,M 微生物,B 血库)
		s IsCALogin= $lg($g(^dbo.BTWorkGroupD(RowID)),15)	//是否开启电子签名
		s:IsCALogin="" IsCALogin=0	
		s IsShowSet= $lg($g(^dbo.BTWorkGroupD(RowID)),16)	//是否显示设置框
		s:IsShowSet="" IsShowSet=0
		s LockUserSecond= $lg($g(^dbo.BTWorkGroupD(RowID)),17)		//自动锁时间
		s IsUnacceptToClinical= $lg($g(^dbo.BTWorkGroupD(RowID)),18)	//荒诞报告临床
		s:IsUnacceptToClinical="" IsUnacceptToClinical=0		
		s LinkWorkGroupDR= $lg($g(^dbo.BTWorkGroupD(RowID)),19)	//关联工作组
		s:LinkWorkGroupDR'="" LinkWorkGroupDR=$lg($g(^dbo.BTWorkGroupD(LinkWorkGroupDR)),3)	//关联工作组描述
		d OutputRow
	}
	else
	{
		k ^tempsequencesort("dbo.BTWorkGroup")
		s RowID=0
		for 
		{
			s RowID=$o(^dbo.BTWorkGroupD(RowID))
			q:RowID=""
			s Code= $lg($g(^dbo.BTWorkGroupD(RowID)),2)		//代码
			s CName= $lg($g(^dbo.BTWorkGroupD(RowID)),3)		//名称
			s DepartmentDR= $lg($g(^dbo.BTWorkGroupD(RowID)),4)		//检验科室
			if (loc'="")
			{
				continue:loc'=DepartmentDR
			}
			s HospitalDR=""
			if (DepartmentDR'="") {
				s HospitalDR= $lg($g(^dbo.BTDepartmentD(DepartmentDR)),4)		//医院
				s DepartmentDR=$lg($g(^dbo.BTDepartmentD(DepartmentDR)),3)	//检验科室描述
			} 
			if (hospital'="")
			{
				continue:hospital'=HospitalDR
			}
			s:HospitalDR'="" HospitalDR=$lg($g(^dbo.BTHospitalD(HospitalDR)),3)	//检验科室对应医院描述
			
			s Leader= $lg($g(^dbo.BTWorkGroupD(RowID)),5)		//负责人
			s Telephone= $lg($g(^dbo.BTWorkGroupD(RowID)),6)		//联系电话
			s Telephone= $lg($g(^dbo.BTWorkGroupD(RowID)),6)		//联系电话
			s ShowOperator= $lg($g(^dbo.BTWorkGroupD(RowID)),7)	//是否显示操作者
			s:ShowOperator="" ShowOperator=0
			s DoubleCheck= $lg($g(^dbo.BTWorkGroupD(RowID)),8)	//是否双签字
			s:DoubleCheck="" DoubleCheck=0
			s ReportTempl= $lg($g(^dbo.BTWorkGroupD(RowID)),9)	//报告模版 
			s RoomDR= $lg($g(^dbo.BTWorkGroupD(RowID)),10)		//所在房间
			s:RoomDR'="" RoomDR=$lg($g(^dbo.BTRoomD(RoomDR)),3)			//所在房间描述
			s WPath= $lg($g(^dbo.BTWorkGroupD(RowID)),11)		//WHONET 导出文件路径
			s Sequence= $lg($g(^dbo.BTWorkGroupD(RowID)),12)		//序号
			s Active= $lg($g(^dbo.BTWorkGroupD(RowID)),13)		//Active 状态
			s:Active="" Active=1	//update 2019-12-17  激活为空时，设为1
			if (active'="")&&(Active'=active)
			{
				continue 
			}
			s LabType= $lg($g(^dbo.BTWorkGroupD(RowID)),14)		//实验室类型(N 常规,C 细胞学,H 组织,M 微生物,B 血库)
			s IsCALogin= $lg($g(^dbo.BTWorkGroupD(RowID)),15)	//是否开启电子签名
			s:IsCALogin="" IsCALogin=0	
			s IsShowSet= $lg($g(^dbo.BTWorkGroupD(RowID)),16)	//是否显示设置框
			s:IsShowSet="" IsShowSet=0
			s LockUserSecond= $lg($g(^dbo.BTWorkGroupD(RowID)),17)		//自动锁时间
			s IsUnacceptToClinical= $lg($g(^dbo.BTWorkGroupD(RowID)),18)	//荒诞报告临床
			s:IsUnacceptToClinical="" IsUnacceptToClinical=0		
			s LinkWorkGroupDR= $lg($g(^dbo.BTWorkGroupD(RowID)),19)	//关联工作组
			s:LinkWorkGroupDR'="" LinkWorkGroupDR=$lg($g(^dbo.BTWorkGroupD(LinkWorkGroupDR)),3)	//关联工作组描述
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
				s ^tempsequencesort("dbo.BTWorkGroup",Sequence,RowID)=RowID
			}
			
		}
		s SequenceSort=""
		for
		{
			s SequenceSort=$o(^tempsequencesort("dbo.BTWorkGroup",SequenceSort))  q:SequenceSort=""
			s RowIDSort=""
			for
			{
				s RowIDSort=$o(^tempsequencesort("dbo.BTWorkGroup",SequenceSort,RowIDSort))  q:RowIDSort=""
				s RowID=RowIDSort
				s Code= $lg($g(^dbo.BTWorkGroupD(RowID)),2)		//代码
				s CName= $lg($g(^dbo.BTWorkGroupD(RowID)),3)		//名称
				s DepartmentDR= $lg($g(^dbo.BTWorkGroupD(RowID)),4)		//检验科室
				if (loc'="")
				{
					continue:loc'=DepartmentDR
				}
				s HospitalDR=""
				if (DepartmentDR'="") {
					s HospitalDR= $lg($g(^dbo.BTDepartmentD(DepartmentDR)),4)		//医院
					s DepartmentDR=$lg($g(^dbo.BTDepartmentD(DepartmentDR)),3)	//检验科室描述
				} 
				if (hospital'="")
				{
					continue:hospital'=HospitalDR
				}
				s:HospitalDR'="" HospitalDR=$lg($g(^dbo.BTHospitalD(HospitalDR)),3)	//检验科室对应医院描述
				
				s Leader= $lg($g(^dbo.BTWorkGroupD(RowID)),5)		//负责人
				s Telephone= $lg($g(^dbo.BTWorkGroupD(RowID)),6)		//联系电话
				s Telephone= $lg($g(^dbo.BTWorkGroupD(RowID)),6)		//联系电话
				s ShowOperator= $lg($g(^dbo.BTWorkGroupD(RowID)),7)	//是否显示操作者
				s:ShowOperator="" ShowOperator=0
				s DoubleCheck= $lg($g(^dbo.BTWorkGroupD(RowID)),8)	//是否双签字
				s:DoubleCheck="" DoubleCheck=0
				s ReportTempl= $lg($g(^dbo.BTWorkGroupD(RowID)),9)	//报告模版 
				s RoomDR= $lg($g(^dbo.BTWorkGroupD(RowID)),10)		//所在房间
				s:RoomDR'="" RoomDR=$lg($g(^dbo.BTRoomD(RoomDR)),3)			//所在房间描述
				s WPath= $lg($g(^dbo.BTWorkGroupD(RowID)),11)		//WHONET 导出文件路径
				s Sequence= $lg($g(^dbo.BTWorkGroupD(RowID)),12)		//序号
				s Active= $lg($g(^dbo.BTWorkGroupD(RowID)),13)		//Active 状态
				s:Active="" Active=1	//update 2019-12-17  激活为空时，设为1
				if (active'="")&&(Active'=active)
				{
					continue 
				}
				s LabType= $lg($g(^dbo.BTWorkGroupD(RowID)),14)		//实验室类型(N 常规,C 细胞学,H 组织,M 微生物,B 血库)
				s IsCALogin= $lg($g(^dbo.BTWorkGroupD(RowID)),15)	//是否开启电子签名
				s:IsCALogin="" IsCALogin=0	
				s IsShowSet= $lg($g(^dbo.BTWorkGroupD(RowID)),16)	//是否显示设置框
				s:IsShowSet="" IsShowSet=0
				s LockUserSecond= $lg($g(^dbo.BTWorkGroupD(RowID)),17)		//自动锁时间
				s IsUnacceptToClinical= $lg($g(^dbo.BTWorkGroupD(RowID)),18)	//荒诞报告临床
				s:IsUnacceptToClinical="" IsUnacceptToClinical=0		
				s LinkWorkGroupDR= $lg($g(^dbo.BTWorkGroupD(RowID)),19)	//关联工作组
				s:LinkWorkGroupDR'="" LinkWorkGroupDR=$lg($g(^dbo.BTWorkGroupD(LinkWorkGroupDR)),3)	//关联工作组描述
				
				d OutputRow
			}
		}  
		    
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(RowID,Code,CName,DepartmentDR,Leader,Telephone,ShowOperator,DoubleCheck,ReportTempl,RoomDR,WPath,Sequence,Active,LabType,IsCALogin,IsShowSet,LockUserSecond,IsUnacceptToClinical,LinkWorkGroupDR,HospitalDR)
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
/// Description：查询 工作组 下拉框
/// Table:dbo.BT_WorkGroup
/// Input:id, code, desc,loc
/// Output:RowId,Code,Desc
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.LAB.BTWorkGroup","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String, hospital As %String) As %Query(ROWSPEC = "RowID,Code,CName")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, hospital As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	if (rowid'="") //根据rowid返回该条记录
	{
		s RowID=rowid
		s Code= $lg($g(^dbo.BTWorkGroupD(RowID)),2)		//代码
		s CName= $lg($g(^dbo.BTWorkGroupD(RowID)),3)		//名称
		d OutputRowCmb
	}
	else
	{
		
		
		k ^tempsequencecombosort("dbo.BTWorkGroup")
		s RowID=0
		for 
		{
			s RowID=$o(^dbo.BTWorkGroupD(RowID))
			q:RowID=""
			s Code= $lg($g(^dbo.BTWorkGroupD(RowID)),2)		//代码
			s CName= $lg($g(^dbo.BTWorkGroupD(RowID)),3)		//名称
			s DepartmentDR= $lg($g(^dbo.BTWorkGroupD(RowID)),4)		//检验科室
		
			s HospitalDR=""												 
			if (DepartmentDR'="") {
				s HospitalDR= $lg($g(^dbo.BTDepartmentD(DepartmentDR)),4)		//医院
			}
			continue:(HospitalDR'=hospital)&&(hospital'="")	 
			s Sequence= $lg($g(^dbo.BTWorkGroupD(RowID)),12)		//序号
			s Active= $lg($g(^dbo.BTWorkGroupD(RowID)),13)		//Active 状态
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
				s ^tempsequencecombosort("dbo.BTWorkGroup",Sequence,RowID)=RowID
			}
			
		}
		s SequenceSort=""
		for
		{
			s SequenceSort=$o(^tempsequencecombosort("dbo.BTWorkGroup",SequenceSort))  q:SequenceSort=""
			s RowIDSort=""
			for
			{
				s RowIDSort=$o(^tempsequencecombosort("dbo.BTWorkGroup",SequenceSort,RowIDSort))  q:RowIDSort=""
				s RowID=RowIDSort
				s Code= $lg($g(^dbo.BTWorkGroupD(RowID)),2)		//代码
				s CName= $lg($g(^dbo.BTWorkGroupD(RowID)),3)		//名称
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
/// CreatDate:2019-11-6
/// Description:数据重复验证方法,js调用
/// Table:dbo.BT_WorkGroup
/// Input:id, code, desc,loc
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.DHCBL.LAB.BTWorkGroup).FormValidate("27","cs1","2")
ClassMethod FormValidate(id As %String, code As %String, loc As %String) As %String
{
	s flag=0
	if (code'="")&&(loc'="")
	{
		s RowID=$o(^dbo.BTWorkGroupI("IndexCode",loc,##Class(web.DHCBL.BDP.FunLib).IndexData(code),0))
		if (RowID'="")&&(id'=RowID)
		{
			s flag=1
		}
	}
	
	q flag
}

/// Creator：钟荣枫 
/// CreatDate: 2019-11-6
/// Description：新增，修改时打开Form，根据RowId查询
/// Table：dbo.BT_WorkGroup
/// Input：RowId
/// Other: w ##class(web.DHCBL.LAB.BTWorkGroup).OpenData(15)
ClassMethod OpenData(id As %String) As %String
{
    s str = ""
	s pobj = ##class(dbo.BTWorkGroup).%OpenId(id) 
	s eobj = ##class(web.Entity.LAB.BTWorkGroup).%New() 
	s eobj.RowID = id
	s eobj.Code = pobj.Code
	s eobj.CName = pobj.CName
	s eobj.DepartmentDR=pobj.DepartmentDR
	s eobj.Leader = pobj.Leader
	s eobj.Telephone=pobj.Telephone
	s eobj.ShowOperator = pobj.ShowOperator
	s eobj.DoubleCheck = pobj.DoubleCheck
	s eobj.ReportTempl = pobj.ReportTempl
	s eobj.RoomDR=pobj.RoomDR
	s eobj.WPath = pobj.WPath
	s eobj.Sequence = pobj.Sequence
	s eobj.Active = pobj.Active
	s eobj.LabType = pobj.LabType
	s eobj.IsCALogin = pobj.IsCALogin
	s eobj.IsShowSet = pobj.IsShowSet
	s eobj.LockUserSecond = pobj.LockUserSecond
	s eobj.IsUnacceptToClinical = pobj.IsUnacceptToClinical
	s eobj.LinkWorkGroupDR=pobj.LinkWorkGroupDR
	d pobj.%Close()
	kill pobj
	s str = eobj.JsonS()
	//s str = "{list:["_str_"]}"
	q str
}

/// Creator:钟荣枫
/// CreatDate:2019-11-14
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
/// Other: w ##class(web.DHCBL.LAB.BTWorkGroup).GetRefFlag(1)
ClassMethod GetRefFlag(id As %String) As %String
{
	s return="",myInfo=""
	//dbo.BTTestSetLayout
	s TSLayoutRowID=0
	for 
	{
		s TSLayoutRowID=$o(^dbo.BTTestSetLayoutD(TSLayoutRowID))
		q:TSLayoutRowID=""
		s WorkGroupDR= $lg($g(^dbo.BTTestSetLayoutD(TSLayoutRowID)),3)	
		if (WorkGroupDR=id)
		{
			s myInfo=myInfo_"<项目组合套布局>"
			q
		}
	}
	//dbo.BTDevice
	s DeviceRowID=0
	for 
	{
		s DeviceRowID=$o(^dbo.BTDeviceD(DeviceRowID))
		q:DeviceRowID=""
		s WorkGroupDR= $lg($g(^dbo.BTDeviceD(DeviceRowID)),6)	
		if (WorkGroupDR=id)
		{
			s myInfo=myInfo_"<设备>"
			q
		}
	}
	//dbo.BTBaseTable
	s BaseTableRowID=0
	for 
	{
		s BaseTableRowID=$o(^dbo.BTBaseTableD(BaseTableRowID))
		q:BaseTableRowID=""
		s WorkGroupDR= $lg($g(^dbo.BTBaseTableD(BaseTableRowID)),9)	
		if (WorkGroupDR=id)
		{
			s myInfo=myInfo_"<基础表格>"
			q
		}
	}
	//dbo.BTWorkGroup
	s WorkGroupRowID=0
	for 
	{
		s WorkGroupRowID=$o(^dbo.BTWorkGroupD(WorkGroupRowID))
		q:WorkGroupRowID=""
		s LinkWorkGroupDR= $lg($g(^dbo.BTWorkGroupD(WorkGroupRowID)),19)	//关联工作组
		if (LinkWorkGroupDR=id)
		{
			s myInfo=myInfo_"<工作组>"
			q
		}
	}
	//dbo.BTTestSet
	s TestSetRowID=0
	for 
	{
		s TestSetRowID=$o(^dbo.BTTestSetD(TestSetRowID))
		q:TestSetRowID=""
		s WorkGroupDR= $lg($g(^dbo.BTTestSetD(TestSetRowID)),22)	//医嘱所属工作组
		if (WorkGroupDR=id)
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
		s WorkGroupDR= $lg($g(^dbo.BTWorkGroupMachineD(WorkGroupMachineRowID)),4)	
		if (WorkGroupDR=id)
		{
			s myInfo=myInfo_"<工作小组>"
			q
		}
	}
	i myInfo="" s return="0^未被引用可删除！"
	else  s return="1^在"_myInfo_"表里被引用,不能删除！"
	q return
}

/// Creator：钟荣枫 
/// CreatDate: 2019-11-7
/// Description：根据id删除 工作组
/// Table：dbo.BT_WorkGroup
/// Input：id 
/// Return：成功返回true，失败返回false和info
/// Other: w ##class(web.DHCBL.LAB.BTWorkGroup).DeleteData(1)
ClassMethod DeleteData(id) As %String
{
	s result=""
	s re=##class(web.DHCBL.LAB.BTWorkGroup).GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	if (RefFlag=0){
		s pobj = ##class(dbo.BTWorkGroup).%OpenId(id)
		s eobj = ##class(web.Entity.LAB.BTWorkGroup).%New()
		s eobj.Code = pobj.Code
		s eobj.CName = pobj.CName
		s eobj.DepartmentDR=pobj.DepartmentDR
		s eobj.Leader = pobj.Leader
		
		s eobj.Telephone=pobj.Telephone
		s eobj.ShowOperator = pobj.ShowOperator
		s eobj.DoubleCheck = pobj.DoubleCheck
		s eobj.ReportTempl = pobj.ReportTempl
		s eobj.RoomDR=pobj.RoomDR

		s eobj.WPath = pobj.WPath
		s eobj.Sequence = pobj.Sequence
		s eobj.Active = pobj.Active
		s eobj.LabType = pobj.LabType
		s eobj.IsCALogin = pobj.IsCALogin
				        
		s eobj.IsShowSet = pobj.IsShowSet
		s eobj.LockUserSecond = pobj.LockUserSecond
		s eobj.IsUnacceptToClinical = pobj.IsUnacceptToClinical
		s eobj.LinkWorkGroupDR=pobj.LinkWorkGroupDR
		
		d pobj.%Close()
		kill pobj
		Tstart
		s sc=##class(dbo.BTWorkGroup).%DeleteId(id)
		IF $$$ISOK(sc){
			Tc
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("dbo.BT_WorkGroup","dbo.BTWorkGroup","工作组",id,eobj.CName,"D",eobj)
		}
		else{
			Trollback
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("工作组","web.DHCBL.LAB.BTWorkGroup","DeleteData",eobj)
			s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		}
	}else{
		s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"	
	}
	
	
	q result
}

/// Creator:钟荣枫 
/// CreatDate: 2019-11-6
/// Description：保存 工作组
/// Input: eobj As web.Entity.LAB.BTWorkGroup
/// Table：dbo.BT_WorkGroup
/// Return:成功返回true，失败返回false
/// Other:w ##class(web.DHCBL.LAB.BTWorkGroup).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.LAB.BTWorkGroup) As %String
{
	//n (eobj,%session)
	s result=""
	if $IsObject(eobj)
	{	
		s:eobj.ShowOperator="" eobj.ShowOperator=0
		s:eobj.DoubleCheck="" eobj.DoubleCheck=0
		s:eobj.Active="" eobj.Active=0
		s:eobj.IsCALogin="" eobj.IsCALogin=0
		s:eobj.IsShowSet="" eobj.IsShowSet=0		        
		s:eobj.IsUnacceptToClinical="" eobj.IsUnacceptToClinical=0
		s flag=..FormValidate(eobj.RowID,eobj.Code,eobj.DepartmentDR)  //调用重复验证
		if (flag=1)
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		if (eobj.RowID="")
		{	
	        s obj=##class(dbo.BTWorkGroup).%New()
		}
		else
		{
			s obj=##class(dbo.BTWorkGroup).%OpenId(eobj.RowID)
			s bobj = ##class(web.Entity.LAB.BTWorkGroup).%New()
	
			s bobj.RowID = eobj.RowID
			s bobj.Code = obj.Code		
			s bobj.CName = obj.CName	
			s bobj.DepartmentDR=obj.DepartmentDR	
			s bobj.Leader = obj.Leader			
			
			s bobj.Telephone=obj.Telephone		
			s bobj.ShowOperator = obj.ShowOperator	
			s bobj.DoubleCheck = obj.DoubleCheck	
			s bobj.ReportTempl = obj.ReportTempl	
			s bobj.RoomDR=obj.RoomDR	

			s bobj.WPath = obj.WPath	
			s bobj.Sequence = obj.Sequence	
			s bobj.Active = obj.Active	
			s bobj.LabType = obj.LabType	
			s bobj.IsCALogin = obj.IsCALogin	
					        
			s bobj.IsShowSet = obj.IsShowSet	
			s bobj.LockUserSecond = obj.LockUserSecond	
			s bobj.IsUnacceptToClinical = obj.IsUnacceptToClinical	
			s bobj.LinkWorkGroupDR=obj.LinkWorkGroupDR	
		}	
		s obj.Code = eobj.Code	//代码
		s obj.CName = eobj.CName	//名称
		S obj.DepartmentDR=eobj.DepartmentDR	//检验科室
		s obj.Leader = eobj.Leader		//负责人
		
		s obj.Telephone=eobj.Telephone	//联系电话
		s obj.ShowOperator = eobj.ShowOperator	//显示操作者
		s obj.DoubleCheck = eobj.DoubleCheck	//是否双签字
		s obj.ReportTempl = eobj.ReportTempl	//报告模版
		s obj.RoomDR=eobj.RoomDR			//所在房间
		s obj.WPath = eobj.WPath			//WHONET 导出文件路径
		s obj.Sequence = eobj.Sequence		//序号
		s obj.Active = eobj.Active			//Active 状态
		s obj.LabType = eobj.LabType		//实验室类型
		s obj.IsCALogin = eobj.IsCALogin	//是否开启电子签名
		
		s obj.IsShowSet = eobj.IsShowSet		//是否显示设置框
		s obj.LockUserSecond = eobj.LockUserSecond		//自动锁时间
		s obj.IsUnacceptToClinical = eobj.IsUnacceptToClinical		//荒诞临床
		s obj.LinkWorkGroupDR=eobj.LinkWorkGroupDR		//关联工作组
		
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc){
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			d:eobj.RowID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("dbo.BT_WorkGroup","dbo.BTWorkGroup","工作组",id,eobj.CName,"A",eobj)
			d:eobj.RowID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("dbo.BT_WorkGroup","dbo.BTWorkGroup","工作组",id,eobj.CName,"U",eobj,bobj)
			
		}else{
			Trollback
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("工作组","web.DHCBL.LAB.BTWorkGroup","SaveEntity",eobj)
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
/// Description:通过工作组代码获取工作组rowid
/// w ##class(web.DHCBL.LAB.BTWorkGroup).GetRowIdByCode("")
ClassMethod GetRowIdByCode(code As %String) As %String
{
	S RowID=""
	s code=$ZCONVERT(code,"U")
	if (code'="")
	{
		s RowID=0
		for 
		{
			s RowID=$o(^dbo.BTWorkGroupD(RowID))
			q:RowID=""
			s Code= $lg($g(^dbo.BTWorkGroupD(RowID)),2)		//代码
			q:code=$ZCONVERT(Code,"U")
		}
	}
	q RowID
}

}
