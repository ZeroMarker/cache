Class DHCLIS.DHCBTData Extends %RegisteredObject
{

/// Creator：      liuzf
/// CreatDate：    20170730
/// Description:： 获取医院
/// d ##Class(%ResultSet).RunQuery("DHCLIS.DHCBTData","QryHospital","","","","","","","","","","","14","","","","")
Query QryHospital(P0, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %Query(ROWSPEC = "RowID,Code,CName,Sequence")
{
}

ClassMethod QryHospitalExecute(ByRef qHandle As %Binary, P0, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
	s RowCount=0
	s RowID="" f  s RowID=$o(^dbo.BTHospitalD(RowID)) q:RowID=""  d
	.s RowCount=RowCount+1
	.s Code=$lg(^dbo.BTHospitalD(RowID),2)
	.s CName=$lg(^dbo.BTHospitalD(RowID),3)
	.s Sequence=$lg(^dbo.BTHospitalD(RowID),10)
	.s Data=$lb(RowID,Code,CName,Sequence)
	.d Output
 	s qHandle=$lb(0,repid,0)
	q $$$OK 

Output
	set ColFields="RowID,Code,CName,Sequence"
 	Set ^CacheTemp(repid,ind)=##Class(LIS.Util.Common).TransListNull(Data,ColFields)
 	Set ind=ind+1
	Quit
}

ClassMethod QryHospitalFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryHospitalExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {
 		s AtEnd=1
 		s Row=""
 	}
 	else {
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod QryHospitalClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryHospitalExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// 删除医院
ClassMethod DelBTHospital(RowID As %String) As %String
{
	s RowID=$g(RowID)
	s RetValue=0
	i '$l(RowID) q 0
	s sc=##Class(dbo.BTHospital).%DeleteId(RowID)
 	If ($SYSTEM.Status.IsOK(sc)) {
	 	s RetValue=1
 	}
 	else {
	 	s RetValue=$SYSTEM.Status.GetErrorText(sc)
	}

	Quit RetValue
}

/// 更新医院
ClassMethod UpdBTHospital(RowID, Code, CName, Sequence) As %String
{
	s RowID=$g(RowID),Code=$tr($g(Code)," "),CName=$tr($g(CName)," "),Sequence=+$g(Sequence)
	s RetValue=0
	i '$l(Code) q 0
	i '$l(CName) q 0
	i $l(RowID) {
		s obj=##Class(dbo.BTHospital).%OpenId(RowID)
	}else{
		s obj=##Class(dbo.BTHospital).%New()
	}
	If '$IsObject(obj) q 100
	s obj.Code=Code
	s obj.CName=CName
	s obj.Sequence=Sequence
	s obj.Active=1
	s sc=obj.%Save()
 	If ($SYSTEM.Status.IsOK(sc)) {
	 	s RetValue=1
 	}
 	else {
	 	s RetValue=$SYSTEM.Status.GetErrorText(sc)
	}

	Quit RetValue
}

/// Creator：      liuzf
/// CreatDate：    20170730
/// Description:： 获取检验科室
/// d ##Class(%ResultSet).RunQuery("DHCLIS.DHCBTData","QryDepartment","","","","","","","","","","","14","","","","")
Query QryDepartment(P0, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %Query(ROWSPEC = "RowID,Code,CName,HospCode,HospName,Sequence")
{
}

ClassMethod QryDepartmentExecute(ByRef qHandle As %Binary, P0, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
	s RowCount=0
	s RowID="" f  s RowID=$o(^dbo.BTDepartmentD(RowID)) q:RowID=""  d
	.s RowCount=RowCount+1
	.s Code=$lg(^dbo.BTDepartmentD(RowID),2)
	.s CName=$lg(^dbo.BTDepartmentD(RowID),3)
	.s HospitalDR=$lg(^dbo.BTDepartmentD(RowID),4)
	.s HospCode=$lg(^dbo.BTHospitalD(HospitalDR),2)
	.s HospName=$lg(^dbo.BTHospitalD(HospitalDR),3)
	.s Sequence=$lg(^dbo.BTDepartmentD(RowID),5)
	.s Data=$lb(RowID,Code,CName,HospCode,HospName,Sequence)
	.d Output
 	s qHandle=$lb(0,repid,0)
	q $$$OK 

Output
	set ColFields="RowID,Code,CName,HospCode,HospName,Sequence"
 	Set ^CacheTemp(repid,ind)=##Class(LIS.Util.Common).TransListNull(Data,ColFields)
 	Set ind=ind+1
	Quit
}

ClassMethod QryDepartmentFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDepartmentExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {
 		s AtEnd=1
 		s Row=""
 	}
 	else {
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod QryDepartmentClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDepartmentExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// 删除检验科室
ClassMethod DelBTDepartment(RowID As %String) As %String
{
	s RowID=$g(RowID)
	s RetValue=0
	i '$l(RowID) q 0
	s sc=##Class(dbo.BTDepartment).%DeleteId(RowID)
 	If ($SYSTEM.Status.IsOK(sc)) {
	 	s RetValue=1
 	}
 	else {
	 	s RetValue=$SYSTEM.Status.GetErrorText(sc)
	}

	Quit RetValue
}

/// 更新检验科室
ClassMethod UpdBTDepartment(RowID, Code, CName, Sequence, HospCode) As %String
{
	s RowID=$g(RowID),Code=$tr($g(Code)," "),CName=$tr($g(CName)," "),Sequence=+$g(Sequence),HospCode=$g(HospCode)
	s RetValue=0
	i '$l(Code) q 0
	i '$l(CName) q 0
	
	s HospitalDR=""
	i $l(HospCode) s HospitalDR=$o(^dbo.BTHospitalI("IndexCode",##Class(LIS.Util.Common).IndexData(HospCode),""))
	i '$l(HospitalDR) s HospitalDR=1  //默认1主医院
	
	s Code=$zcvt(Code,"U")
	i $l(Code),'$l(RowID) s RowID=$o(^dbo.BTDepartmentI("IndexCode",HospitalDR,##Class(LIS.Util.Common).IndexData(Code),""))
	
	i $l(RowID) {
		s obj=##Class(dbo.BTDepartment).%OpenId(RowID)
	}else{
		s obj=##Class(dbo.BTDepartment).%New()
	}
	If '$IsObject(obj) q 100
	s obj.Code=Code
	s obj.CName=CName
	s obj.Sequence=Sequence
	s obj.HospitalDR=HospitalDR  
	s obj.Active=1
	s sc=obj.%Save()
 	If ($SYSTEM.Status.IsOK(sc)) {
	 	s RetValue=1
 	}
 	else {
	 	s RetValue=$SYSTEM.Status.GetErrorText(sc)
	}

	Quit RetValue
}

/// Creator：      liuzf
/// CreatDate：    20170730
/// Description:： 获取工作组
/// d ##Class(%ResultSet).RunQuery("DHCLIS.DHCBTData","QryWorkGroup","","","","","","","","","","","14","","","","")
Query QryWorkGroup(P0, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %Query(ROWSPEC = "RowID,Code,CName,DepartmentDR,DepartmentCode,DepartmentName,Sequence")
{
}

ClassMethod QryWorkGroupExecute(ByRef qHandle As %Binary, P0, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
	s RowCount=0
	s RowID="" f  s RowID=$o(^dbo.BTWorkGroupD(RowID)) q:RowID=""  d
	.s RowCount=RowCount+1
	.s Code=$lg(^dbo.BTWorkGroupD(RowID),2)
	.s CName=$lg(^dbo.BTWorkGroupD(RowID),3)
	.s DepartmentDR=$lg(^dbo.BTWorkGroupD(RowID),4)
	.s DepartmentName="",DepartmentCode=""
	.i $l(DepartmentDR) s DepartmentCode=$lg(^dbo.BTDepartmentD(DepartmentDR),2)
	.i $l(DepartmentDR) s DepartmentName=$lg(^dbo.BTDepartmentD(DepartmentDR),3)
	.s Sequence=$lg(^dbo.BTWorkGroupD(RowID),12)
	.s Data=$lb(RowID,Code,CName,DepartmentDR,DepartmentCode,DepartmentName,Sequence)
	.d Output
 	s qHandle=$lb(0,repid,0)
	q $$$OK 

Output
	set ColFields="RowID,Code,CName,DepartmentDR,DepartmentCode,DepartmentName,Sequence"
 	Set ^CacheTemp(repid,ind)=##Class(LIS.Util.Common).TransListNull(Data,ColFields)
 	Set ind=ind+1
	Quit
}

ClassMethod QryWorkGroupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryWorkGroupExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {
 		s AtEnd=1
 		s Row=""
 	}
 	else {
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod QryWorkGroupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryWorkGroupExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// 删除工作组
ClassMethod DelBTWorkGroup(RowID As %String) As %String
{
	s RowID=$g(RowID)
	s RetValue=0
	i '$l(RowID) q 0
	s sc=##Class(dbo.BTWorkGroup).%DeleteId(RowID)
 	If ($SYSTEM.Status.IsOK(sc)) {
	 	s RetValue=1
 	}
 	else {
	 	s RetValue=$SYSTEM.Status.GetErrorText(sc)
	}

	Quit RetValue
}

/// 更新工作组
ClassMethod UpdBTWorkGroup(RowID, Code, CName, DepartmentDR, Sequence, DepartmentCode) As %String
{
	s RowID=$g(RowID),Code=$tr($g(Code)," "),CName=$tr($g(CName)," "),DepartmentDR=$g(DepartmentDR),Sequence=+$g(Sequence)
	s DepartmentCode=$g(DepartmentCode)
	s RetValue=0
	i '$l(Code) q 0
	i '$l(CName) q 0
	//s HospitalDR=1  //默认1主医院
	i '$L(DepartmentDR),$l(DepartmentCode) {
		Set rset = ##class(%ResultSet).%New()
		s sql="SELECT RowID FROM dbo.BT_Department WHERE Code='"_DepartmentCode_"'"
		Do rset.Prepare(sql)
		Do rset.Execute()
		While (rset.Next(.sc)) 
		{
			If ($SYSTEM.Status.IsOK(sc)) 
    		{
	    		s DepartmentDR=rset.Data("RowID")
    		}
		}
    	s ret=rset.Close()
	}
	i '$l(DepartmentDR) q "关联检验科室不能为空！"
	i $l(RowID) {
		s obj=##Class(dbo.BTWorkGroup).%OpenId(RowID)
	}else{
		s obj=##Class(dbo.BTWorkGroup).%New()
	}
	If '$IsObject(obj) q 100
	s obj.Code=Code
	s obj.CName=CName
	s obj.DepartmentDR=DepartmentDR
	s obj.Sequence=Sequence
	s obj.Active=1
	s sc=obj.%Save()
 	If ($SYSTEM.Status.IsOK(sc)) {
	 	s RetValue=1
 	}
 	else {
	 	s RetValue=$SYSTEM.Status.GetErrorText(sc)
	}

	Quit RetValue
}

/// Creator：      liuzf
/// CreatDate：    20170730
/// Description:： 获取工作小组
/// d ##Class(%ResultSet).RunQuery("DHCLIS.DHCBTData","QryWGMachine","","","","","","","","","","","","","","","")
Query QryWGMachine(P0, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %Query(ROWSPEC = "RowID,Code,CName,WorkGroupDR,WorkGroupCode,WorkGroupName,Sequence")
{
}

ClassMethod QryWGMachineExecute(ByRef qHandle As %Binary, P0, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
	s RowCount=0

	s RowID="" f  s RowID=$o(^dbo.BTWorkGroupMachineD(RowID)) q:RowID=""  d
	.s RowCount=RowCount+1
	.s Code=$lg(^dbo.BTWorkGroupMachineD(RowID),2)
	.s CName=$lg(^dbo.BTWorkGroupMachineD(RowID),3)
	.s WorkGroupDR=$lg(^dbo.BTWorkGroupMachineD(RowID),4)
	.s WorkGroupName="",WorkGroupCode=""
	.i $l(WorkGroupDR) s WorkGroupCode=$lg(^dbo.BTWorkGroupD(WorkGroupDR),2)
	.i $l(WorkGroupDR) s WorkGroupName=$lg(^dbo.BTWorkGroupD(WorkGroupDR),3)
	.s Sequence=$lg(^dbo.BTWorkGroupMachineD(RowID),9)
	.s Data=$lb(RowID,Code,CName,WorkGroupDR,WorkGroupCode,WorkGroupName,Sequence)
	.d Output
 	s qHandle=$lb(0,repid,0)
	q $$$OK 

Output
	set ColFields="RowID,Code,CName,WorkGroupDR,WorkGroupCode,WorkGroupName,Sequence"
 	Set ^CacheTemp(repid,ind)=##Class(LIS.Util.Common).TransListNull(Data,ColFields)
 	Set ind=ind+1
	Quit
}

ClassMethod QryWGMachineFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryWGMachineExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {
 		s AtEnd=1
 		s Row=""
 	}
 	else {
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod QryWGMachineClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryWGMachineExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// 删除工作小组
ClassMethod DelBTWGMachine(RowID As %String) As %String
{
	s RowID=$g(RowID)
	s RetValue=0
	i '$l(RowID) q 0
	s sc=##Class(dbo.BTWorkGroupMachine).%DeleteId(RowID)
 	If ($SYSTEM.Status.IsOK(sc)) {
	 	s RetValue=1
 	}
 	else {
	 	s RetValue=$SYSTEM.Status.GetErrorText(sc)
	}

	Quit RetValue
}

/// 更新工作小组
ClassMethod UpdBTWGMachine(RowID, Code, CName, WorkGroupDR, Sequence, WorkGroupCode) As %String
{
	s RowID=$g(RowID),Code=$tr($g(Code)," "),CName=$tr($g(CName)," "),WorkGroupDR=$g(WorkGroupDR),Sequence=+$g(Sequence)
	s WorkGroupCode=$g(WorkGroupCode)
	s RetValue=0
	i '$l(Code) q 0
	i '$l(CName) q 0
	i '$l(WorkGroupDR),$l(WorkGroupCode) {
		Set rset = ##class(%ResultSet).%New()
		s sql="SELECT RowID FROM dbo.BT_WorkGroup WHERE Code='"_WorkGroupCode_"'"
		Do rset.Prepare(sql)
		Do rset.Execute()
		While (rset.Next(.sc)) 
		{
			If ($SYSTEM.Status.IsOK(sc)) 
    		{
	    		s WorkGroupDR=rset.Data("RowID")
    		}
		}
    	s ret=rset.Close()
	}
	i '$l(WorkGroupDR) q "关联工作组不能为空！"
	i $l(RowID) {
		s obj=##Class(dbo.BTWorkGroupMachine).%OpenId(RowID)
	}else{
		s obj=##Class(dbo.BTWorkGroupMachine).%New()
	}
	If '$IsObject(obj) q 100
	s obj.Code=Code
	s obj.CName=CName
	s obj.WorkGroupDR=WorkGroupDR
	s obj.Sequence=Sequence
	s obj.Active=1
	s sc=obj.%Save()
 	If ($SYSTEM.Status.IsOK(sc)) {
	 	s RetValue=1
 	}
 	else {
	 	s RetValue=$SYSTEM.Status.GetErrorText(sc)
	}

	Quit RetValue
}

/// Creator：      liuzf
/// CreatDate：    20170730
/// Description:： 获取标本类型
/// d ##Class(%ResultSet).RunQuery("DHCLIS.DHCBTData","QrySpecimen","","","","","","","","","","","14","","","","")
Query QrySpecimen(P0, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %Query(ROWSPEC = "RowID,Code,IName,Sequence,WCode,HospCode,HospName")
{
}

ClassMethod QrySpecimenExecute(ByRef qHandle As %Binary, P0, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
	s RowCount=0
	s RowID="" f  s RowID=$o(^dbo.BTSpecimenD(RowID)) q:RowID=""  d
	.s RowCount=RowCount+1
	.s Code=$lg(^dbo.BTSpecimenD(RowID),2)
	.s IName=$lg(^dbo.BTSpecimenD(RowID),3)
	.s Sequence=$lg(^dbo.BTSpecimenD(RowID),10)
	.s WCode=$lg(^dbo.BTSpecimenD(RowID),8)
	.s HospitalDR=$lg(^dbo.BTSpecimenD(RowID),6)
	.s HospCode=$lg(^dbo.BTHospitalD(HospitalDR),2)
	.s HospName=$lg(^dbo.BTHospitalD(HospitalDR),3)	
	.s Data=$lb(RowID,Code,IName,Sequence,WCode,HospCode,HospName)
	.d Output
 	s qHandle=$lb(0,repid,0)
	q $$$OK 

Output
	set ColFields="RowID,Code,IName,Sequence,WCode,HospCode,HospName"
 	Set ^CacheTemp(repid,ind)=##Class(LIS.Util.Common).TransListNull(Data,ColFields)
 	Set ind=ind+1
	Quit
}

ClassMethod QrySpecimenFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySpecimenExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {
 		s AtEnd=1
 		s Row=""
 	}
 	else {
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod QrySpecimenClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySpecimenExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// 删除标本类型
ClassMethod DelBTSpecimen(RowID As %String) As %String
{
	s RowID=$g(RowID)
	s RetValue=0
	i '$l(RowID) q 0
	s sc=##Class(dbo.BTSpecimen).%DeleteId(RowID)
 	If ($SYSTEM.Status.IsOK(sc)) {
	 	s RetValue=1
 	}
 	else {
	 	s RetValue=$SYSTEM.Status.GetErrorText(sc)
	}

	Quit RetValue
}

/// 更新标本类型
ClassMethod UpdBTSpecimen(RowID, Code, IName, Sequence, WCode, HospCode) As %String
{
	s RowID=$g(RowID),Code=$tr($g(Code)," "),IName=$tr($g(IName)," "),Sequence=+$g(Sequence),WCode=$g(WCode),HospCode=$g(HospCode)
	s RetValue=0
	i '$l(Code) q 0
	i '$l(IName) q 0

	s HospitalDR=""
	i $l(HospCode) s HospitalDR=$o(^dbo.BTHospitalI("IndexCode",##Class(LIS.Util.Common).IndexData(HospCode),""))
	i '$l(HospitalDR) s HospitalDR=1  //默认1主医院
	
	s Code=$zcvt(Code,"U")
	i '$l(Code) q "-1^代码不能为空"
	i $l(Code),'$l(RowID) s RowID=$o(^dbo.BTSpecimenI("IndexCode",HospitalDR,##Class(LIS.Util.Common).IndexData(Code),""))
	i $l(RowID) {
		s obj=##Class(dbo.BTSpecimen).%OpenId(RowID)
	}else{
		s obj=##Class(dbo.BTSpecimen).%New()
	}
	If '$IsObject(obj) q 100
	s obj.Code=Code
	s obj.IName=IName
	s obj.XName=IName
	s obj.WCode=WCode
	s obj.Sequence=Sequence
	s obj.HospitalDR=HospitalDR  
	s obj.Active=1
	s sc=obj.%Save()
 	If ($SYSTEM.Status.IsOK(sc)) {
	 	s RetValue=1
 	}
 	else {
	 	s RetValue=$SYSTEM.Status.GetErrorText(sc)
	}

	Quit RetValue
}

/// Creator：      liuzf
/// CreatDate：    20170730
/// Description:： 获取采集容器
/// d ##Class(%ResultSet).RunQuery("DHCLIS.DHCBTData","QryContainer","","","","","","","","","","","14","","","","")
Query QryContainer(P0, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %Query(ROWSPEC = "RowID,Code,CName,Sequence,Volumn,Color,Remark,HospCode,HospName")
{
}

ClassMethod QryContainerExecute(ByRef qHandle As %Binary, P0, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
	s RowCount=0
	s RowID="" f  s RowID=$o(^dbo.BTContainerD(RowID)) q:RowID=""  d
	.s RowCount=RowCount+1
	.s Code=$lg(^dbo.BTContainerD(RowID),2)
	.s CName=$lg(^dbo.BTContainerD(RowID),3)
	.s Sequence=$lg(^dbo.BTContainerD(RowID),8)
	.s Volumn=$lg(^dbo.BTContainerD(RowID),5)
	.s Color=$lg(^dbo.BTContainerD(RowID),6)
	.s Remark=$lg(^dbo.BTContainerD(RowID),7)
	.s HospitalDR=$lg(^dbo.BTContainerD(RowID),4)
	.s HospCode=$lg(^dbo.BTHospitalD(HospitalDR),2)
	.s HospName=$lg(^dbo.BTHospitalD(HospitalDR),3)		
	.s Data=$lb(RowID,Code,CName,Sequence,Volumn,Color,Remark,HospCode,HospName)
	.d Output
 	s qHandle=$lb(0,repid,0)
	q $$$OK 

Output
	set ColFields="RowID,Code,CName,Sequence,Volumn,Color,Remark,HospCode,HospName"
 	Set ^CacheTemp(repid,ind)=##Class(LIS.Util.Common).TransListNull(Data,ColFields)
 	Set ind=ind+1
	Quit
}

ClassMethod QryContainerFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryContainerExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {
 		s AtEnd=1
 		s Row=""
 	}
 	else {
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod QryContainerClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryContainerExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// 删除采集容器
ClassMethod DelBTContainer(RowID As %String) As %String
{
	s RowID=$g(RowID)
	s RetValue=0
	i '$l(RowID) q 0
	s sc=##Class(dbo.BTContainer).%DeleteId(RowID)
 	If ($SYSTEM.Status.IsOK(sc)) {
	 	s RetValue=1
 	}
 	else {
	 	s RetValue=$SYSTEM.Status.GetErrorText(sc)
	}

	Quit RetValue
}

/// 更新采集容器
ClassMethod UpdBTContainer(RowID, Code, CName, Sequence, Volumn, Color, Remark, HospCode) As %String
{
	s RowID=$g(RowID),Code=$tr($g(Code)," "),CName=$tr($g(CName)," "),Sequence=+$g(Sequence)
	s Volumn=$g(Volumn),Color=$g(Color),Remark=$g(Remark),HospCode=$g(HospCode)
	s RetValue=0
	i '$l(Code) q 0
	i '$l(CName) q 0
	
	i Color="红色" s Color="#ff0000"
	i Color="紫色" s Color="#8e7cc3"
	i Color="黄色" s Color="#ffff00"
	i Color="黑色" s Color="#000000"
	i Color="绿色" s Color="#00ff00"
	i Color="橙色" s Color="#ff9900"
	i Color="蓝色" s Color="#0000ff"
	i Color="" s Color="#ffffff"
	
	s HospitalDR=""
	i $l(HospCode) s HospitalDR=$o(^dbo.BTHospitalI("IndexCode",##Class(LIS.Util.Common).IndexData(HospCode),""))
	i '$l(HospitalDR) s HospitalDR=1  //默认1主医院
	
	s Code=$zcvt(Code,"U")
	i $l(Code),'$l(RowID) s RowID=$o(^dbo.BTContainerI("IndexCode",HospitalDR,##Class(LIS.Util.Common).IndexData(Code),""))
	i $l(RowID) {
		s obj=##Class(dbo.BTContainer).%OpenId(RowID)
	}else{
		s obj=##Class(dbo.BTContainer).%New()
	}
	If '$IsObject(obj) q 100
	s obj.Code=Code
	s obj.CName=CName
	s obj.Volumn=Volumn
	s obj.Color=Color
	s obj.Remark=Remark
	s obj.Sequence=Sequence
	s obj.HospitalDR=HospitalDR  
	s obj.Active=1
	s sc=obj.%Save()
 	If ($SYSTEM.Status.IsOK(sc)) {
	 	s RetValue=1
 	}
 	else {
	 	s RetValue=$SYSTEM.Status.GetErrorText(sc)
	}

	Quit RetValue
}

/// Creator：      liuzf
/// CreatDate：    20170730
/// Description:： 获取检测项目
/// d ##Class(%ResultSet).RunQuery("DHCLIS.DHCBTData","QryTestCode","","","","","","","","","","","14","","","","")
Query QryTestCode(P0, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %Query(ROWSPEC = "RowID,Code,CName,Synonym,Units,Precision,ResultFormat,RefRanges,SCode,Sequence,HospCode,HospName")
{
}

ClassMethod QryTestCodeExecute(ByRef qHandle As %Binary, P0, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
	s RowCount=0
	s RowID="" f  s RowID=$o(^dbo.BTTestCodeD(RowID)) q:RowID=""  d
	.s RowCount=RowCount+1
	.s Code=$lg(^dbo.BTTestCodeD(RowID),2)
	.s CName=$lg(^dbo.BTTestCodeD(RowID),3)
	.s Synonym=$lg(^dbo.BTTestCodeD(RowID),7)
	.s Units=$lg(^dbo.BTTestCodeD(RowID),8)
	.s Precision=$lg(^dbo.BTTestCodeD(RowID),10)
	.s ResultFormat=$lg(^dbo.BTTestCodeD(RowID),9)
	.s RefRanges=$lg(^dbo.BTTestCodeD(RowID),27)
	.s SCode=$lg(^dbo.BTTestCodeD(RowID),14)
	.s Sequence=$lg(^dbo.BTTestCodeD(RowID),24)
	.s HospitalDR=$lg(^dbo.BTTestCodeD(RowID),4)
	.s HospCode=$lg(^dbo.BTHospitalD(HospitalDR),2)
	.s HospName=$lg(^dbo.BTHospitalD(HospitalDR),3)		
	.s Data=$lb(RowID,Code,CName,Synonym,Units,Precision,ResultFormat,RefRanges,SCode,Sequence,HospCode,HospName)
	.d Output
 	s qHandle=$lb(0,repid,0)
	q $$$OK 

Output
	set ColFields="RowID,Code,CName,Synonym,Units,Precision,ResultFormat,RefRanges,SCode,Sequence,HospCode,HospName"
 	Set ^CacheTemp(repid,ind)=##Class(LIS.Util.Common).TransListNull(Data,ColFields)
 	Set ind=ind+1
	Quit
}

ClassMethod QryTestCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryTestCodeExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {
 		s AtEnd=1
 		s Row=""
 	}
 	else {
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod QryTestCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryTestCodeExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// 删除检测项目
ClassMethod DelBTTestCode(RowID As %String) As %String
{
	s RowID=$g(RowID)
	s RetValue=0
	i '$l(RowID) q 0
	s sc=##Class(dbo.BTTestCode).%DeleteId(RowID)
 	If ($SYSTEM.Status.IsOK(sc)) {
	 	s RetValue=1
 	}
 	else {
	 	s RetValue=$SYSTEM.Status.GetErrorText(sc)
	}

	Quit RetValue
}

/// 更新检测项目
ClassMethod UpdBTTestCode(RowID, Code, CName, Synonym, Units, Precision, ResultFormat, RefRanges, SCode, Sequence, HospCode) As %String
{
	s RowID=$g(RowID),Code=$tr($g(Code)," "),CName=$tr($g(CName)," "),Sequence=+$g(Sequence)
	s Synonym=$g(Synonym),Units=$g(Units),Precision=$g(Precision),ResultFormat=$g(ResultFormat),RefRanges=$g(RefRanges)
	s SCode=$g(SCode),HospCode=$g(HospCode)
	s RetValue=0
	i '$l(Code) q 0
	i '$l(CName) q 0
	
	s HospitalDR=""
	i $l(HospCode) s HospitalDR=$o(^dbo.BTHospitalI("IndexCode",##Class(LIS.Util.Common).IndexData(HospCode),""))
	i '$l(HospitalDR) s HospitalDR=1  //默认1主医院
	
	s Code=$zcvt(Code,"U")
	i $l(Code),'$l(RowID) s RowID=$o(^dbo.BTTestCodeI("IndexCode",HospitalDR,##Class(LIS.Util.Common).IndexData(Code),""))
	i $l(RowID) {
		s obj=##Class(dbo.BTTestCode).%OpenId(RowID)
	}else{
		s obj=##Class(dbo.BTTestCode).%New()
	}
	If '$IsObject(obj) q 100
	s obj.Code=Code
	s obj.CName=CName
	s obj.Synonym=Synonym
	s obj.Units=Units
	s obj.Precision=Precision
	s obj.ResultFormat=ResultFormat
	s obj.RefRanges=RefRanges
	s obj.SCode=SCode
	s obj.Sequence=Sequence
	s obj.HospitalDR=HospitalDR  
	s obj.Active=1
	s sc=obj.%Save()
 	If ($SYSTEM.Status.IsOK(sc)) {
	 	s RetValue=1
 	}
 	else {
	 	s RetValue=$SYSTEM.Status.GetErrorText(sc)
	}

	Quit RetValue
}

/// Creator：      liuzf
/// CreatDate：    20170730
/// Description:： 获取检测项目范围
/// d ##Class(%ResultSet).RunQuery("DHCLIS.DHCBTData","QryTestCodeRanges","","","","","","","","","","","14","","","","")
Query QryTestCodeRanges(P0, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %Query(ROWSPEC = "RowID,Code,CName,Species,AgeLow,AgeHigh,ValueLow,ValueHigh,PanicLow,PanicHigh,OrderNo,HospCode,HospName")
{
}

ClassMethod QryTestCodeRangesExecute(ByRef qHandle As %Binary, P0, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
	s RowCount=0
	s RowID="" f  s RowID=$o(^dbo.BTTestCodeRangesD(RowID)) q:RowID=""  d
	.s RowCount=RowCount+1
	.s TestCodeDR=$lg(^dbo.BTTestCodeRangesD(RowID),2)
	.s OrderNo=$lg(^dbo.BTTestCodeRangesD(RowID),3)
	.s Code=$lg(^dbo.BTTestCodeD(TestCodeDR),2)
	.s CName=$lg(^dbo.BTTestCodeD(TestCodeDR),3)
	.s SpeciesDR=$lg(^dbo.BTTestCodeRangesD(RowID),4)
	.s Species=""
	.i $l(SpeciesDR) s Species=$lg(^dbo.BTSpeciesD(SpeciesDR),3)
	.s AgeLow=$lg(^dbo.BTTestCodeRangesD(RowID),5)
	.s AgeHigh=$lg(^dbo.BTTestCodeRangesD(RowID),6)
	.s ValueLow=$lg(^dbo.BTTestCodeRangesD(RowID),10)
	.s ValueHigh=$lg(^dbo.BTTestCodeRangesD(RowID),11)
	.s PanicLow=$lg(^dbo.BTTestCodeRangesD(RowID),12)
	.s PanicHigh=$lg(^dbo.BTTestCodeRangesD(RowID),13)
	.s HospitalDR=$lg(^dbo.BTTestCodeD(TestCodeDR),4)
	.s HospCode=$lg(^dbo.BTHospitalD(HospitalDR),2)
	.s HospName=$lg(^dbo.BTHospitalD(HospitalDR),3)			
	.s Data=$lb(RowID,Code,CName,Species,AgeLow,AgeHigh,ValueLow,ValueHigh,PanicLow,PanicHigh,OrderNo,HospCode,HospName)
	.d Output
 	s qHandle=$lb(0,repid,0)
	q $$$OK 

Output
	set ColFields="RowID,Code,CName,Species,AgeLow,AgeHigh,ValueLow,ValueHigh,PanicLow,PanicHigh,OrderNo"
 	Set ^CacheTemp(repid,ind)=##Class(LIS.Util.Common).TransListNull(Data,ColFields)
 	Set ind=ind+1
	Quit
}

ClassMethod QryTestCodeRangesFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryTestCodeRangesExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {
 		s AtEnd=1
 		s Row=""
 	}
 	else {
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod QryTestCodeRangesClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryTestCodeRangesExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// 删除检测项目范围
ClassMethod DelBTTestCodeRanges(RowID As %String) As %String
{
	s RowID=$g(RowID)
	s RetValue=0
	i '$l(RowID) q 0
	s sc=##Class(dbo.BTTestCodeRanges).%DeleteId(RowID)
 	If ($SYSTEM.Status.IsOK(sc)) {
	 	s RetValue=1
 	}
 	else {
	 	s RetValue=$SYSTEM.Status.GetErrorText(sc)
	}

	Quit RetValue
}

/// 更新检测项目范围
ClassMethod UpdBTTestCodeRanges(RowID, Code, Species, AgeLow, AgeHigh, ValueLow, ValueHigh, PanicLow, PanicHigh, OrderNo, HospCode) As %String
{
	s RowID=$g(RowID),Code=$tr($g(Code)," "),Species=$tr($g(Species)," "),AgeLow=+$g(AgeLow)
	s AgeHigh=+$g(AgeHigh),ValueLow=$g(ValueLow),ValueHigh=$g(ValueHigh),PanicLow=$g(PanicLow),PanicHigh=$g(PanicHigh),OrderNo=$g(OrderNo)
	s HospCode=$g(HospCode)
	i '$l(Code) q 0
	
	s HospitalDR=""
	i $l(HospCode) s HospitalDR=$o(^dbo.BTHospitalI("IndexCode",##Class(LIS.Util.Common).IndexData(HospCode),""))
	i '$l(HospitalDR) s HospitalDR=1  //默认1主医院
	
	s Code=$zcvt(Code,"U")
	i $l(Code) s TestCodeDR=$o(^dbo.BTTestCodeI("IndexCode",HospitalDR,##Class(LIS.Util.Common).IndexData(Code),""))
	i '$l(TestCodeDR) q "没找到相应检验项目代码"
	s SpeciesDR=""
	i Species="男" s Species="M"
	i Species="女" s Species="F"
	i $l(Species) s SpeciesDR=$o(^dbo.BTSpeciesI("IndexCode",##Class(LIS.Util.Common).IndexData(Species),""))
	i AgeHigh=0 s AgeHigh=200
	//s SpeciesID=SpeciesDR
	//i SpeciesDR="" s SpeciesID="-100000000000000"
	//i '$l(RowID) s RowID=$o(^dbo.BTTestCodeRangesI("IndexTestCodeSex",TestCodeDR,SpeciesID,""))
	
	i $l(RowID) {
		s obj=##Class(dbo.BTTestCodeRanges).%OpenId(RowID)
	}else{
		s obj=##Class(dbo.BTTestCodeRanges).%New()
	}
	If '$IsObject(obj) q 100
	s obj.TestCodeDR=TestCodeDR
	s obj.SpeciesDR=SpeciesDR
	s obj.AgeLow=AgeLow
	s obj.AgeHigh=AgeHigh
	s obj.ValueLow=ValueLow
	s obj.ValueHigh=ValueHigh
	s obj.PanicLow=PanicLow
	s obj.PanicHigh=PanicHigh
	s obj.OrderNo=OrderNo
	s sc=obj.%Save()
 	If ($SYSTEM.Status.IsOK(sc)) {
	 	s RetValue=1
 	}
 	else {
	 	s RetValue=$SYSTEM.Status.GetErrorText(sc)
	}

	Quit RetValue
}

/// Creator：      liuzf
/// CreatDate：    20170730
/// Description:： 获取检测项目备注
/// d ##Class(%ResultSet).RunQuery("DHCLIS.DHCBTData","QryTestCodeComments","","","","","","","","","","","14","","","","")
Query QryTestCodeComments(P0, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %Query(ROWSPEC = "RowID,Code,CName,AbFlag,Sequence,TestCode,TestName,HospCode,HospName")
{
}

ClassMethod QryTestCodeCommentsExecute(ByRef qHandle As %Binary, P0, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
	s RowCount=0
	s RowID="" f  s RowID=$o(^dbo.BTTestCodeCommentsD(RowID)) q:RowID=""  d
	.s RowCount=RowCount+1
	.s TestCodeDR=$lg(^dbo.BTTestCodeCommentsD(RowID),2)
	.s TestCode=$lg(^dbo.BTTestCodeD(TestCodeDR),2)
	.s TestName=$lg(^dbo.BTTestCodeD(TestCodeDR),3)
	.s Code=$lg(^dbo.BTTestCodeCommentsD(RowID),3)
	.s CName=$lg(^dbo.BTTestCodeCommentsD(RowID),4)
	.s AbFlag=$lg(^dbo.BTTestCodeCommentsD(RowID),5)	
	.s Sequence=$lg(^dbo.BTTestCodeCommentsD(RowID),6)	
	.s HospitalDR=$lg(^dbo.BTTestCodeD(TestCodeDR),4)
	.s HospCode=$lg(^dbo.BTHospitalD(HospitalDR),2)
	.s HospName=$lg(^dbo.BTHospitalD(HospitalDR),3)		
	.s Data=$lb(RowID,Code,CName,AbFlag,Sequence,TestCode,TestName,HospCode,HospName)
	.d Output
 	s qHandle=$lb(0,repid,0)
	q $$$OK 

Output
	set ColFields="RowID,Code,CName,AbFlag,Sequence,TestCode,TestName"
 	Set ^CacheTemp(repid,ind)=##Class(LIS.Util.Common).TransListNull(Data,ColFields)
 	Set ind=ind+1
	Quit
}

ClassMethod QryTestCodeCommentsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryTestCodeCommentsExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {
 		s AtEnd=1
 		s Row=""
 	}
 	else {
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod QryTestCodeCommentsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryTestCodeCommentsExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// 删除检测项目备注
ClassMethod DelBTTestCodeComments(RowID As %String) As %String
{
	s RowID=$g(RowID)
	s RetValue=0
	i '$l(RowID) q 0
	s sc=##Class(dbo.BTTestCodeComments).%DeleteId(RowID)
 	If ($SYSTEM.Status.IsOK(sc)) {
	 	s RetValue=1
 	}
 	else {
	 	s RetValue=$SYSTEM.Status.GetErrorText(sc)
	}

	Quit RetValue
}

/// 更新检测项目备注
ClassMethod UpdBTTestCodeComments(RowID, Code, CName, AbFlag, Sequence, TestCode, HospCode) As %String
{
	s RowID=$g(RowID),Code=$tr($g(Code)," "),CName=$tr($g(CName)," "),AbFlag=$g(AbFlag),TestCode=$g(TestCode),Sequence=+$g(Sequence)
	s HospCode=$g(HospCode)
	i '$l(Code) q 0

	s HospitalDR=""
	i $l(HospCode) s HospitalDR=$o(^dbo.BTHospitalI("IndexCode",##Class(LIS.Util.Common).IndexData(HospCode),""))
	i '$l(HospitalDR) s HospitalDR=1  //默认1主医院
	
	s TestCode=$zcvt(TestCode,"U")
	s TestCodeDR=$o(^dbo.BTTestCodeI("IndexCode",HospitalDR,##Class(LIS.Util.Common).IndexData(TestCode),""))
	i '$l(TestCodeDR) q "没找到相应检验项目代码"
	
	i $l(RowID) {
		s obj=##Class(dbo.BTTestCodeComments).%OpenId(RowID)
	}else{
		s obj=##Class(dbo.BTTestCodeComments).%New()
	}
	If '$IsObject(obj) q 100
	s obj.TestCodeDR=TestCodeDR
	s obj.Code=Code
	s obj.CName=CName
	s obj.AbFlag=AbFlag
	s obj.Active=1
	s obj.Sequence=Sequence
	s sc=obj.%Save()
 	If ($SYSTEM.Status.IsOK(sc)) {
	 	s RetValue=1
 	}
 	else {
	 	s RetValue=$SYSTEM.Status.GetErrorText(sc)
	}

	Quit RetValue
}

/// Creator：      liuzf
/// CreatDate：    20170730
/// Description:： 获取检验医嘱套
/// d ##Class(%ResultSet).RunQuery("DHCLIS.DHCBTData","QryTestSet","","","","","","","","","","","14","","","","")
Query QryTestSet(P0, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %Query(ROWSPEC = "RowID,Code,CName,WorkGroupMachineCode,WorkGroupMachineName,SpecimenCode,SpecimenName,ContainerCode,ContainerName,HISCode,Sequence,HospCode,HospName")
{
}

ClassMethod QryTestSetExecute(ByRef qHandle As %Binary, P0, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
	s RowCount=0
	s RowID="" f  s RowID=$o(^dbo.BTTestSetD(RowID)) q:RowID=""  d
	.s RowCount=RowCount+1
	.s Code=$lg(^dbo.BTTestSetD(RowID),2)
	.s CName=$lg(^dbo.BTTestSetD(RowID),3)
	.s SpecimenDR=$lg(^dbo.BTTestSetD(RowID),10)
	.s (SpecimenCode,SpecimenName)=""
	.i $l(SpecimenDR) s SpecimenCode=$lg(^dbo.BTSpecimenD(SpecimenDR),2)
	.i $l(SpecimenDR) s SpecimenName=$lg(^dbo.BTSpecimenD(SpecimenDR),3)
	.s (ContainerCode,ContainerName)=""
	.s ContainerDR=$lg(^dbo.BTTestSetD(RowID),11)
	.i $l(ContainerDR) s ContainerCode=$lg(^dbo.BTContainerD(ContainerDR),2)
	.i $l(ContainerDR) s ContainerName=$lg(^dbo.BTContainerD(ContainerDR),3)
	.s (WorkGroupMachineCode,WorkGroupMachineName)=""
	.s WorkGroupMachineDR=$lg(^dbo.BTTestSetD(RowID),13)
	.i $l(WorkGroupMachineDR) s WorkGroupMachineCode=$lg(^dbo.BTWorkGroupMachineD(WorkGroupMachineDR),2)
	.i $l(WorkGroupMachineDR) s WorkGroupMachineName=$lg(^dbo.BTWorkGroupMachineD(WorkGroupMachineDR),3)
	.s HISCode=$lg(^dbo.BTTestSetD(RowID),7)
	.s Sequence=$lg(^dbo.BTTestSetD(RowID),17)
	.s HospitalDR=$lg(^dbo.BTTestSetD(RowID),4)
	.s HospCode=$lg(^dbo.BTHospitalD(HospitalDR),2)
	.s HospName=$lg(^dbo.BTHospitalD(HospitalDR),3)		
	.s Data=$lb(RowID,Code,CName,WorkGroupMachineCode,WorkGroupMachineName,SpecimenCode,SpecimenName,ContainerCode,ContainerName,HISCode,Sequence,HospCode,HospName)
	.d Output
 	s qHandle=$lb(0,repid,0)
	q $$$OK 

Output
	set ColFields="RowID,Code,CName,WorkGroupMachineCode,WorkGroupMachineName,SpecimenCode,SpecimenName,ContainerCode,ContainerName,HISCode,Sequence,HospCode,HospName"
 	Set ^CacheTemp(repid,ind)=##Class(LIS.Util.Common).TransListNull(Data,ColFields)
 	Set ind=ind+1
	Quit
}

ClassMethod QryTestSetFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryTestSetExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {
 		s AtEnd=1
 		s Row=""
 	}
 	else {
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod QryTestSetClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryTestSetExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// 删除检验医嘱套
ClassMethod DelBTTestSet(RowID As %String) As %String
{
	s RowID=$g(RowID)
	s RetValue=0
	i '$l(RowID) q 0
	s sc=##Class(dbo.BTTestSet).%DeleteId(RowID)
 	If ($SYSTEM.Status.IsOK(sc)) {
	 	s RetValue=1
 	}
 	else {
	 	s RetValue=$SYSTEM.Status.GetErrorText(sc)
	}

	Quit RetValue
}

/// 更新检验医嘱套
ClassMethod UpdBTTestSet(RowID, Code, CName, WorkGroupMachineCode, SpecimenCode, ContainerCode, HISCode, Sequence, HospCode) As %String
{
	s RowID=$g(RowID),Code=$tr($g(Code)," "),CName=$tr($g(CName)," "),Sequence=+$g(Sequence),HospCode=$g(HospCode)
	s WorkGroupMachineCode=$g(WorkGroupMachineCode),SpecimenCode=$g(SpecimenCode),ContainerCode=$g(ContainerCode),HISCode=$g(HISCode)
	s RetValue=0
	i '$l(Code) q 0
	i '$l(CName) q 0
	
	s HospitalDR=""
	i $l(HospCode) s HospitalDR=$o(^dbo.BTHospitalI("IndexCode",##Class(LIS.Util.Common).IndexData(HospCode),""))
	i '$l(HospitalDR) s HospitalDR=1  //默认1主医院
	
	s Code=$zcvt(Code,"U")
	i $l(Code),'$l(RowID) s RowID=$o(^dbo.BTTestSetI("IndexCode",HospitalDR,##Class(LIS.Util.Common).IndexData(Code),""))
	
	s WorkGroupMachineDR=""
	//获取默认工作小组
	s WGMICode=$p(WorkGroupMachineCode,",",1)
	i $l(WGMICode){
		Set rset = ##class(%ResultSet).%New()
		s sql="SELECT RowID FROM dbo.BT_WorkGroupMachine WHERE Code='"_WGMICode_"'"
		Do rset.Prepare(sql)
		Do rset.Execute()
		While (rset.Next(.sc)) 
		{
			If ($SYSTEM.Status.IsOK(sc)) 
    		{
	    		s WorkGroupMachineDR=rset.Data("RowID")
    		}
		}
    	s ret=rset.Close()
	}
	
	s SpecimenDR=""
	i $l(SpecimenCode) s SpecimenDR=$o(^dbo.BTSpecimenI("IndexCode",HospitalDR,##Class(LIS.Util.Common).IndexData(SpecimenCode),""))
	s ContainerDR=""
	i $l(ContainerCode) s ContainerDR=$o(^dbo.BTContainerI("IndexCode",HospitalDR,##Class(LIS.Util.Common).IndexData(ContainerCode),""))
	
	i $l(RowID) {
		s obj=##Class(dbo.BTTestSet).%OpenId(RowID)
	}else{
		s obj=##Class(dbo.BTTestSet).%New()
	}
	If '$IsObject(obj) q 100
	s obj.Code=Code
	s obj.CName=CName
	s obj.WorkGroupMachineDR=WorkGroupMachineDR
	s obj.SpecimenDR=SpecimenDR
	s obj.ContainerDR=ContainerDR
	s obj.HISCode=HISCode
	s obj.Sequence=Sequence
	s obj.HospitalDR=HospitalDR  
	s obj.Active=1
	s sc=obj.%Save()
 	If ($SYSTEM.Status.IsOK(sc)) {
	 	s RetValue=1
	 	s TestSetDR=obj.RowID
	 	//标本类型关联表 dbo.BTTestSetSpecimen
	 	s IsDefault=1
	 	s ret=##Class(DHCLIS.DHCBTData).UpdBTTestSetSpecimen(TestSetDR,SpecimenDR,ContainerDR,"",IsDefault,"","",HospCode)
		//保存关联工作小组
		f k=1:1:$l(WorkGroupMachineCode,",")
		{
			s WGMICode=$p(WorkGroupMachineCode,",",k)
			i $l(WGMICode){
				Set rset = ##class(%ResultSet).%New()
				s sql="SELECT RowID FROM dbo.BT_WorkGroupMachine WHERE Code='"_WGMICode_"'"
				Do rset.Prepare(sql)
				Do rset.Execute()
				While (rset.Next(.sc)) 
				{
					If ($SYSTEM.Status.IsOK(sc)) 
		    		{
			    		s WorkGroupMachineDR=rset.Data("RowID")
			    		i $d(^dbo.BTTestSetWorkGroupMachineI("IndexMaster",TestSetDR,WorkGroupMachineDR)) {
				    		s BGMIRowID=$o(^dbo.BTTestSetWorkGroupMachineI("IndexMaster",TestSetDR,WorkGroupMachineDR,""))
				    		s objWGMI=##Class(dbo.BTTestSetWorkGroupMachine).%OpenId(BGMIRowID)
				    	}else{
					    	s objWGMI=##Class(dbo.BTTestSetWorkGroupMachine).%New()
					    }
			    		s objWGMI.TestSetDR=TestSetDR
			    		s objWGMI.WorkGroupMachineDR=WorkGroupMachineDR
			    		s objWGMI.Active=1
			    		i k=1 s objWGMI.IsDefault=1
			    		s objWGMI.Sequence=k
			    		s sc=objWGMI.%Save()
			    		If '($SYSTEM.Status.IsOK(sc)) s RetValue=$SYSTEM.Status.GetErrorText(sc) 
		    		}
				}
		    	s ret=rset.Close()
			}
		}
	 	
 	}
 	else {
	 	s RetValue=$SYSTEM.Status.GetErrorText(sc)
	}

	Quit RetValue
}

/// 更新关联医嘱表标本类型
ClassMethod UpdBTTestSetSpecimen(Code, SpecimenCode, ContainerCode, MergeType, IsDefault, Sequence, RowID, HospCode) As %String
{
	s TestSetDR=$g(Code),SpecimenDR=$g(SpecimenCode),ContainerDR=$g(ContainerCode)
	s MergeType=+$g(MergeType),IsDefault=$g(IsDefault),Sequence=$g(Sequence),RowID=$g(RowID)
	s HospCode=$g(HospCode)
	
	s HospitalDR=""
	i $l(HospCode) s HospitalDR=$o(^dbo.BTHospitalI("IndexCode",##Class(LIS.Util.Common).IndexData(HospCode),""))
	i '$l(HospitalDR) s HospitalDR=1  //默认1主医院
	
	i '$l(TestSetDR) q "-1^未找到医嘱"
	i '$l(SpecimenDR) q "-1^未找到标本"
	i IsDefault'=1 s IsDefault=0
	i MergeType=0 s MergeType=""
	i Sequence=0 s Sequence=1
	
	i '$d(^dbo.BTTestSetD(TestSetDR))
	{
		s Code=$zcvt(TestSetDR,"U")
		s TestSetDR=$o(^dbo.BTTestSetI("IndexCode",HospitalDR,##Class(LIS.Util.Common).IndexData(Code),""))
		i '$l(TestSetDR) q "-1^未找到医嘱!"
	}

	i '$d(^dbo.BTSpecimenD(SpecimenDR)){
		s SpecimenCode=$zcvt(SpecimenDR,"U")
		s SpecimenDR=$o(^dbo.BTSpecimenI("IndexCode",HospitalDR,##Class(LIS.Util.Common).IndexData(SpecimenCode),""))
		i '$l(SpecimenDR) q "-1^未找到标本"
	}
	i $l(ContainerDR),'$d(^dbo.BTContainerD(ContainerDR)){
		s ContainerCode=$zcvt(ContainerDR,"U")
		s ContainerDR=$o(^dbo.BTContainerI("IndexCode",HospitalDR,##Class(LIS.Util.Common).IndexData(ContainerCode),""))
		i '$l(ContainerDR) q "-1^未找到容器"
	}
	
	i '$l(RowID) s RowID=$o(^dbo.BTTestSetSpecimenI("IndexMaster",TestSetDR,SpecimenDR,""))
	i $l(RowID) {
		s obj=##Class(dbo.BTTestSetSpecimen).%OpenId(RowID)
	}else{
		s obj=##Class(dbo.BTTestSetSpecimen).%New()
	}
	s obj.TestSetDR=TestSetDR
	s obj.SpecimenDR=SpecimenDR
	s obj.ContainerDR=ContainerDR
	s obj.MergeType=MergeType
	s obj.IsDefault=IsDefault
	s obj.Sequence=+Sequence
	s sc=obj.%Save()
	If '($SYSTEM.Status.IsOK(sc)) q $SYSTEM.Status.GetErrorText(sc) 
	q sc
}

/// Creator：      liuzf
/// CreatDate：    20170730
/// Description:： 获取医嘱套布局
/// d ##Class(%ResultSet).RunQuery("DHCLIS.DHCBTData","QryTestSetLayout","","","","","","","","","","","14","","","","")
Query QryTestSetLayout(P0, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %Query(ROWSPEC = "RowID,WorkGroupCode,WorkGroupName,TestSetCode,TestSetName,TestCode,TestName,HospCode,HospName")
{
}

ClassMethod QryTestSetLayoutExecute(ByRef qHandle As %Binary, P0, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
	s RowCount=0
	s RowID="" f  s RowID=$o(^dbo.BTTestSetLayoutD(RowID)) q:RowID=""  d
	.s RowCount=RowCount+1
	.s TestSetDR=$lg(^dbo.BTTestSetLayoutD(RowID),2)
	.s TestSetCode=$lg(^dbo.BTTestSetD(TestSetDR),2)
	.s TestSetName=$lg(^dbo.BTTestSetD(TestSetDR),3)
	.s WorkGroupDR=$lg(^dbo.BTTestSetLayoutD(RowID),3)
	.s WorkGroupName="",WorkGroupCode=""
	.i $l(WorkGroupDR) s WorkGroupCode=$lg(^dbo.BTWorkGroupD(WorkGroupDR),2)
	.i $l(WorkGroupDR) s WorkGroupName=$lg(^dbo.BTWorkGroupD(WorkGroupDR),3)
	.s TestCodeDR=$lg(^dbo.BTTestSetLayoutD(RowID),4)
	.s TestCode=$lg(^dbo.BTTestCodeD(TestCodeDR),2)
	.s TestName=$lg(^dbo.BTTestCodeD(TestCodeDR),3)
	.s HospitalDR=$lg(^dbo.BTTestSetD(TestSetDR),4)
	.s HospCode=$lg(^dbo.BTHospitalD(HospitalDR),2)
	.s HospName=$lg(^dbo.BTHospitalD(HospitalDR),3)		
	.s Data=$lb(RowID,WorkGroupCode,WorkGroupName,TestSetCode,TestSetName,TestCode,TestName,HospCode,HospName)
	.d Output
 	s qHandle=$lb(0,repid,0)
	q $$$OK 

Output
	set ColFields="RowID,WorkGroupCode,WorkGroupName,TestSetCode,TestSetName,TestCode,TestName,HospCode,HospName"
 	Set ^CacheTemp(repid,ind)=##Class(LIS.Util.Common).TransListNull(Data,ColFields)
 	Set ind=ind+1
	Quit
}

ClassMethod QryTestSetLayoutFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryTestSetLayoutExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {
 		s AtEnd=1
 		s Row=""
 	}
 	else {
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod QryTestSetLayoutClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryTestSetLayoutExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// 删除医嘱套布局
ClassMethod DelBTTestSetLayout(RowID As %String) As %String
{
	s RowID=$g(RowID)
	s RetValue=0
	i '$l(RowID) q 0
	s sc=##Class(dbo.BTTestSetLayout).%DeleteId(RowID)
 	If ($SYSTEM.Status.IsOK(sc)) {
	 	s RetValue=1
 	}
 	else {
	 	s RetValue=$SYSTEM.Status.GetErrorText(sc)
	}

	Quit RetValue
}

/// 更新医嘱套布局 
ClassMethod UpdBTTestSetLayout(RowID, WorkGroupCode, TestSetCode, TestCode, WorkGroupMachineCode, HospCode) As %String
{
	s RowID=$g(RowID),WorkGroupCode=$tr($g(WorkGroupCode)," "),TestSetCode=$tr($g(TestSetCode)," "),TestCode=$g(TestCode)
	s WorkGroupMachineCode=$g(WorkGroupMachineCode),HospCode=$g(HospCode)
	k TSWGLayoutLists  //多工作组更新列表
	s HospitalDR=""
	i $l(HospCode) s HospitalDR=$o(^dbo.BTHospitalI("IndexCode",##Class(LIS.Util.Common).IndexData(HospCode),""))
	i '$l(HospitalDR) s HospitalDR=1  //默认1主医院
	
	s WorkGroupDR=""
	i $l(WorkGroupCode) {
		Set rset = ##class(%ResultSet).%New()
		s sql="SELECT RowID FROM dbo.BT_WorkGroup WHERE Code='"_WorkGroupCode_"'"
		Do rset.Prepare(sql)
		Do rset.Execute()
		While (rset.Next(.sc)) 
		{
			If ($SYSTEM.Status.IsOK(sc)) 
    		{
	    		s WorkGroupDR=rset.Data("RowID")
	    		s TSWGLayoutLists(WorkGroupDR)=""
    		}
		}
    	s ret=rset.Close()
	}else{
		//导入工作小组 布局
		f k=1:1:$l(WorkGroupMachineCode,",")
		{
			s WGMICode=$p(WorkGroupMachineCode,",",k)
			i $l(WGMICode){
				Set rset = ##class(%ResultSet).%New()
				s sql="SELECT WorkGroupDR FROM dbo.BT_WorkGroupMachine WHERE Code='"_WGMICode_"'"
				Do rset.Prepare(sql)
				Do rset.Execute()
				While (rset.Next(.sc)) 
				{
					If ($SYSTEM.Status.IsOK(sc)) 
		    		{
			    		s WorkGroupDR=rset.Data("WorkGroupDR")
	    				s TSWGLayoutLists(WorkGroupDR)=""
		    		}
				}
		    	s ret=rset.Close()
			}
		}
	}
	i '$l(WorkGroupDR) q "关联工作组不能为空！"	
	s TestSetDR=$o(^dbo.BTTestSetI("IndexCode",HospitalDR,##Class(LIS.Util.Common).IndexData(TestSetCode),""))
	i '$l(TestSetDR) q "检验医嘱不能为空"
	s TestCodeDR=$o(^dbo.BTTestCodeI("IndexCode",HospitalDR,##Class(LIS.Util.Common).IndexData(TestCode),""))
	i '$l(TestCodeDR) q "没找到相应检验项目代码"

	s WorkGroupDR=""
	for {
		s WorkGroupDR = $o(TSWGLayoutLists(WorkGroupDR))
		q:WorkGroupDR=""
		
		i '$l(RowID) s RowID=$O(^dbo.BTTestSetLayoutI("IndexMaster",TestSetDR, WorkGroupDR, TestCodeDR,""))
		i $l(RowID) {
			s obj=##Class(dbo.BTTestSetLayout).%OpenId(RowID)
		}else{
			s obj=##Class(dbo.BTTestSetLayout).%New()
		}
		If '$IsObject(obj) q
		s obj.TestCodeDR=TestCodeDR
		s obj.TestSetDR=TestSetDR
		s obj.WorkGroupDR=WorkGroupDR
		s obj.IsMandatory=1
		s sc=obj.%Save()
	 	If ($SYSTEM.Status.IsOK(sc)) {
		 	s RetValue=1
	 	}
	 	else {
		 	s RetValue=$SYSTEM.Status.GetErrorText(sc)
		}
	}
	Quit RetValue
}

/// Creator：      liuzf
/// CreatDate：    20170730
/// Description:： 获取用户
/// d ##Class(%ResultSet).RunQuery("DHCLIS.DHCBTData","QrySYSUser","","","","","","","","","","","14","","","","")
Query QrySYSUser(P0, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %Query(ROWSPEC = "RowID,Code,CName,Password,GroupCode,WorkGroupCode,WorkGroupName,Sequence,HospCode,HospName")
{
}

ClassMethod QrySYSUserExecute(ByRef qHandle As %Binary, P0, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
	s RowCount=0
	s RowID="" f  s RowID=$o(^dbo.SYSUserD(RowID)) q:RowID=""  d
	.s RowCount=RowCount+1
	.s Code=$lg(^dbo.SYSUserD(RowID),2)
	.s CName=$lg(^dbo.SYSUserD(RowID),3)
	.s Password=$lg(^dbo.SYSUserD(RowID),4)
	.s (WorkGroupCode,WorkGroupName,GroupCode)=""
	.s WorkGroupDR="" f  s WorkGroupDR=$o(^dbo.SYSUserGroupI("IndexMaster",RowID,WorkGroupDR)) q:WorkGroupDR=""  d
	..s UserGroupDR=$o(^dbo.SYSUserGroupI("IndexMaster",RowID,WorkGroupDR,""))
	..s GroupDR=$lg(^dbo.SYSUserGroupD(UserGroupDR),4)
	..s tGroupCode=""
	..i $l(GroupDR) s tGroupCode=$lg($g(^dbo.SYSGroupD(GroupDR)),2)
	..s tWGCode=$lg(^dbo.BTWorkGroupD(WorkGroupDR),2)
	..s tWGName=$lg(^dbo.BTWorkGroupD(WorkGroupDR),3)
	..i $l(WorkGroupCode) d
	...s WorkGroupCode=WorkGroupCode_","_tWGCode
	...s WorkGroupName=WorkGroupName_","_tWGName
	...s GroupCode=GroupCode_","_tGroupCode
	..e  d
	...s WorkGroupCode=tWGCode
	...s WorkGroupName=tWGName
	...s GroupCode=tGroupCode
	.s Sequence=$lg(^dbo.SYSUserD(RowID),10)
	.s HospitalDR=$lg(^dbo.SYSUserD(RowID),5)
	.s HospCode=$lg(^dbo.BTHospitalD(HospitalDR),2)
	.s HospName=$lg(^dbo.BTHospitalD(HospitalDR),3)		
	.s Data=$lb(RowID,Code,CName,Password,GroupCode,WorkGroupCode,WorkGroupName,Sequence,HospCode,HospName)
	.d Output
 	s qHandle=$lb(0,repid,0)
	q $$$OK 

Output
	set ColFields="RowID,Code,CName,Password,GroupCode,WorkGroupCode,WorkGroupName,Sequence,HospCode,HospName"
 	Set ^CacheTemp(repid,ind)=##Class(LIS.Util.Common).TransListNull(Data,ColFields)
 	Set ind=ind+1
	Quit
}

ClassMethod QrySYSUserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySYSUserExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {
 		s AtEnd=1
 		s Row=""
 	}
 	else {
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod QrySYSUserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySYSUserExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// 删除用户
ClassMethod DelSYSUser(RowID As %String) As %String
{
	s RowID=$g(RowID)
	s RetValue=0
	i '$l(RowID) q 0
	s sc=##Class(dbo.SYSUser).%DeleteId(RowID)
 	If ($SYSTEM.Status.IsOK(sc)) {
	 	s RetValue=1
 	}
 	else {
	 	s RetValue=$SYSTEM.Status.GetErrorText(sc)
	}

	Quit RetValue
}

/// 更新用户
///  w ##Class(DHCLIS.DHCBTData).UpdSYSUser("114","LIS01","检验","06D49632C9DC9BCB62AEAEF99612BA6B",1,"LIS01","A")
ClassMethod UpdSYSUser(RowID, Code, CName, Password, Sequence, GroupCode, WorkGroupCode, HospCode) As %String
{
	s RowID=$g(RowID),Code=$tr($g(Code)," "),CName=$tr($g(CName)," "),Sequence=+$g(Sequence)
	s GroupCode=$g(GroupCode),WorkGroupCode=$g(WorkGroupCode),Password=$g(Password),HospCode=$g(HospCode)
	
	s RetValue=0
	i '$l(Code) q 0
	i '$l(CName) q 0
	s HospitalDR=""
	i $l(HospCode) s HospitalDR=$o(^dbo.BTHospitalI("IndexCode",##Class(LIS.Util.Common).IndexData(HospCode),""))
	i '$l(HospitalDR) s HospitalDR=1  //默认1主医院
	
	i '$l(Password) s Password="06D49632C9DC9BCB62AEAEF99612BA6B"
	s Code=$zcvt(Code,"U")
	i $l(Code),'$l(RowID) s RowID=$o(^dbo.SYSUserI("IndexCode",##Class(LIS.Util.Common).IndexData(Code),""))
	i $l(RowID) {
		s obj=##Class(dbo.SYSUser).%OpenId(RowID)
	}else{
		s obj=##Class(dbo.SYSUser).%New()
	}
	If '$IsObject(obj) q 100
	s obj.Code=Code
	s obj.CName=CName
	s obj.Password=Password
	s obj.PIN=Password   //审核密码
	s obj.Sequence=Sequence
	s obj.HospitalDR=HospitalDR  
	s obj.Active=1
	s sc=obj.%Save()
 	If ($SYSTEM.Status.IsOK(sc)) {
	 	s RetValue=1
	 	s UserDR=obj.RowID
	 	//更新安全组和访问科室
	 	i $l(GroupCode),$l(WorkGroupCode)  {
			f k=1:1:$l(WorkGroupCode,",")
			{
				s GPCode=$p(GroupCode,",",k)
	 			i '$l(GPCode) s GPCode=$p(GroupCode,",",1)
	 			s GPCode=$zcvt(GroupCode,"U")
	 			s GroupDR=$o(^dbo.SYSGroupI("IndexCode",##Class(LIS.Util.Common).IndexData(GPCode),""))
				s WGCode=$p(WorkGroupCode,",",k)
				i $l(WGCode),$l(GroupDR){
					Set rset = ##class(%ResultSet).%New()
					s sql="SELECT RowID FROM dbo.BT_WorkGroup WHERE Code='"_WGCode_"'"
					Do rset.Prepare(sql)
					Do rset.Execute()
					While (rset.Next(.sc1)) 
					{
						If ($SYSTEM.Status.IsOK(sc1)) 
			    		{
				    		s WorkGroupDR=rset.Data("RowID")
				    		i $l(WorkGroupDR)
				    		{
					    		s UserGroupDR=$o(^dbo.SYSUserGroupI("IndexMaster",UserDR,WorkGroupDR,""))
								i $l(UserGroupDR) {
									s objUG=##Class(dbo.SYSUserGroup).%OpenId(UserGroupDR)
								} else{
									s objUG=##Class(dbo.SYSUserGroup).%New()
								}
								s objUG.GroupDR=GroupDR
								s objUG.UserDR=UserDR
								s objUG.WorkGroupDR=WorkGroupDR
								s sc2=objUG.%Save()
	 							If ($SYSTEM.Status.IsOK(sc2)) {
		 						}else {s RetValue=$SYSTEM.Status.GetErrorText(sc2)}
				    		}
			    		}
					}
			    	s ret=rset.Close()
				}
			}
	 	}
 	}
 	else {
	 	s RetValue=$SYSTEM.Status.GetErrorText(sc)
	}

	Quit RetValue
}

/// Creator：      liuzf
/// CreatDate：    20170730
/// Description:： 获取检验医嘱套标本
/// d ##Class(%ResultSet).RunQuery("DHCLIS.DHCBTData","QryTestSet","","","","","","","","","","","14","","","","")
Query QryTestSetSpecimen(P0, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %Query(ROWSPEC = "RowID,Code,CName,SpecimenCode,SpecimenName,ContainerCode,ContainerName,MergeType,IsDefault,Sequence,HospCode,HospName")
{
}

ClassMethod QryTestSetSpecimenExecute(ByRef qHandle As %Binary, P0, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, Sessions, Output RowCount As %String) As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
	s RowCount=0
	s RowID="" f  s RowID=$o(^dbo.BTTestSetSpecimenD(RowID)) q:RowID=""  d
	.s RowCount=RowCount+1
	.s TestSetDR=$lg(^dbo.BTTestSetSpecimenD(RowID),2)
	.s SpecimenDR=$lg(^dbo.BTTestSetSpecimenD(RowID),3)
	.s ContainerDR=$lg(^dbo.BTTestSetSpecimenD(RowID),4)
	.s MergeType=$lg(^dbo.BTTestSetSpecimenD(RowID),5)
	.s IsDefault=$lg(^dbo.BTTestSetSpecimenD(RowID),6)
	.s Sequence=$lg(^dbo.BTTestSetSpecimenD(RowID),7)
	.s Code=$lg(^dbo.BTTestSetD(TestSetDR),2)
	.s CName=$lg(^dbo.BTTestSetD(TestSetDR),3)
	.s (SpecimenCode,SpecimenName)=""
	.i $l(SpecimenDR) s SpecimenCode=$lg(^dbo.BTSpecimenD(SpecimenDR),2)
	.i $l(SpecimenDR) s SpecimenName=$lg(^dbo.BTSpecimenD(SpecimenDR),3)
	.s (ContainerCode,ContainerName)=""
	.i $l(ContainerDR) s ContainerCode=$lg(^dbo.BTContainerD(ContainerDR),2)
	.i $l(ContainerDR) s ContainerName=$lg(^dbo.BTContainerD(ContainerDR),3)
	.s HospitalDR=$lg(^dbo.BTTestSetD(TestSetDR),4)
	.s HospCode=$lg(^dbo.BTHospitalD(HospitalDR),2)
	.s HospName=$lg(^dbo.BTHospitalD(HospitalDR),3)			
	.s Data=$lb(RowID,Code,CName,SpecimenCode,SpecimenName,ContainerCode,ContainerName,MergeType,IsDefault,Sequence,HospCode,HospName)
	.d Output
 	s qHandle=$lb(0,repid,0)
	q $$$OK 

Output
	set ColFields="RowID,Code,CName,SpecimenCode,SpecimenName,ContainerCode,ContainerName,MergeType,IsDefault,Sequence,HospCode,HospName"
 	Set ^CacheTemp(repid,ind)=##Class(LIS.Util.Common).TransListNull(Data,ColFields)
 	Set ind=ind+1
	Quit
}

ClassMethod QryTestSetSpecimenFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryTestSetSpecimenExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {
 		s AtEnd=1
 		s Row=""
 	}
 	else {
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod QryTestSetSpecimenClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryTestSetSpecimenExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// 删除检验医嘱套标本
ClassMethod DelBTTestSetSpecimen(RowID As %String) As %String
{
	s RowID=$g(RowID)
	s RetValue=0
	i '$l(RowID) q 0
	s sc=##Class(dbo.BTTestSetSpecimen).%DeleteId(RowID)
 	If ($SYSTEM.Status.IsOK(sc)) {
	 	s RetValue=1
 	}
 	else {
	 	s RetValue=$SYSTEM.Status.GetErrorText(sc)
	}

	Quit RetValue
}

}
