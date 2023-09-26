Class web.DHCQCMachine Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// 查询检验科室对应的设备信息！
ClassMethod GetAllClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Query的执行方法
/// d ##class(%ResultSet).RunQuery("web.类名","query名称","参数1","参数2",参数……
/// d ##class(%ResultSet).RunQuery("web.DHCQCMachine","GetAll","B","","")
ClassMethod GetAllExecute(ByRef qHandle As %Binary, DepCode As %String, MachineName As %String, HospCode As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set DepCode=$Get(DepCode),MachineName=$Get(MachineName)
	If $Get(ind)="" Set ind=1
	Set NameSpace="LABDATA"
	Set code="" For  Set code=$Order(^[NameSpace]TMIF(code)) Quit:code=""  Do
	.Set name=$Piece($Get(^[NameSpace]TMIF(code)),"\",1)
	.If $Length(MachineName),name'[MachineName Quit
	.//Set machineDept=$$CT013^at178(code)
	.//先不做大小写处理
	.Set CurHospCode=$Piece($Get(^[NameSpace]DHCMachinePara(code)),"\",7)
	.Set machineDept=$Piece($Get(^[NameSpace]DHCMachinePara(code)),"\",1)
	.If $Length(HospCode),HospCode'=CurHospCode Quit
	.If machineDept[DepCode d
	..Do OutputMachines
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK	
	
OutputMachines
	set Data=$lb(code,name)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetAllFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAllExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" 
 	{				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      
 	{	// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：      DaiYi
/// CreatDate：    20101026
/// Description:： 查询科室仪器
/// Table：        DHCQC_TmpResult
/// Input：        DepCode:科室代码,MachName:仪器名称,HospCode:医院代码
/// Output：       仪器集合
/// Return：       0:无,1:有
/// Others：
Query GetAll(DepCode As %String, MachName As %String, HospCode As %String) As %Query(ROWSPEC = "Code:%String,Name:%String") [ SqlProc ]
{
}

/// 查询仪器对应的检验结果数据
/// 
ClassMethod GetAllMachineQCClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Query的执行方法
/// d ##class(%ResultSet).RunQuery("web.类名","query名称","参数1","参数2",参数……
/// d ##class(%ResultSet).RunQuery("web.DHCQCMachine","GetAllMachineQC","ACA530","","")
ClassMethod GetAllMachineQCExecute(ByRef qHandle As %Binary, MachCode As %String, StatDate As %String, EndDate As %String) As %Status
{
	//Set MachCode="ACA530",StatDate="2012-03-1",EndDate="2012-03-26"
	Set repid=$I(^CacheTemp)
	If $Get(ind)="" Set ind=1
	If MachCode="" Quit $$$OK
	Set StatDate=$Get(StatDate),EndDate=$Get(EndDate)
	Set StatDate=$ZDh(StatDate,3),EndDate=$ZDh(EndDate,3)
	Set Num=1
	If $Data(^DHCQCTR(MachCode)) Do
	.For QcDate=StatDate:1:EndDate Do
	..//Set QcDate="" For  Set QcDate=$Order(^DHCQCTR(MachCode,QcDate)) Quit:QcDate=""  Do
	..//If QcDate>=StatDate,QcDate<=EndDate Do
	..If $Data(^DHCQCTR(MachCode,QcDate)) Do
	...w !,QcDate
	...Set QcId="" For  Set QcId=$Order(^DHCQCTR(MachCode,QcDate,QcId)) Quit:QcId=""  Do
	....Set TestCode="" For  Set TestCode=$Order(^DHCQCTR(MachCode,QcDate,QcId,TestCode)) Quit:TestCode=""  Do
	.....Set TestName=$Piece($Get(^TTAB("TC",TestCode)),"\",1)
	.....Set SeqNum="" For  Set SeqNum=$Order(^DHCQCTR(MachCode,QcDate,QcId,TestCode,SeqNum)) Quit:SeqNum=""  Do
	......Set str=$Get(^DHCQCTR(MachCode,QcDate,QcId,TestCode,SeqNum))
	......Set Result=$Piece(str,"^",9)
	......Set ResultFlag=$Piece(str,"^",10)
	......Set MatLotRowId=$Piece(str,"^",11)
	......Set ResultNote=""
	......Set ResultQcDate=$ZD($Piece(str,"^",2),3)
	......Set ResultQcTime=$ZT($Piece(str,"^",3))
	......Set RowId=MachCode_"||"_QcDate_"||"_QcId_"||"_TestCode_"||"_SeqNum
	......Do OutputMachineQC
	......Set Num=Num+1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK	
	
OutputMachineQC
	set Data=$lb(Num,QcId,TestCode,TestName,SeqNum,Result,ResultFlag,ResultNote,ResultQcDate,ResultQcTime,RowId,MatLotRowId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetAllMachineQCFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAllExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" 
 	{				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      
 	{	
 	    // fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	    // Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：      DaiYi
/// CreatDate：    20110526
/// Description:： 检验仪器数据查询
/// Table：        DHCQC_TmpResult
/// Input：        MachCode:仪器代码,StatDate:开始日期,EndDate：结束日期
/// Output：       仪器质控数据集合
/// Return：       0:无,1:有
/// Others：
Query GetAllMachineQC(MachCode As %String, StatDate As %String, EndDate As %String) As %Query(ROWSPEC = "SeqNum:%String,QcId:%String,TestCode:%String,TestName:%String,TestTimes:%String,Result:%String,ResultFlag:%String,ResultNote:%String,TestDate:%String,TestTime:%String,RowId:%String,MatLotRowId:%String") [ SqlProc ]
{
}

/// Creator：      DaiYi
/// CreatDate：    20101021
/// Description:： 检验仪器对应的相关项目查询
/// Table：        
/// Input：        DepCode：科室代码,MachineCode:仪器代码
/// Output：       所有项目集合
/// Return：       
/// Others：
ClassMethod GetMachineTCClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMachineTCExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Query的执行方法
/// d ##class(%ResultSet).RunQuery("web.类名","query名称","参数1","参数2",参数……
/// d ##class(%ResultSet).RunQuery("web.DHCQCMachine","GetMachineTC","A","AXE200")
ClassMethod GetMachineTCExecute(ByRef qHandle As %Binary, DepCode As %String, MachineCode As %String, TestName As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $Get(ind)="" Set ind=1
	//Set (TCCode,name)="",Visable="N" Do OutputMachineTC
    i $l(MachineCode),$d(^TMIF(MachineCode,2)) d
	.Set TCCode="" For  Set TCCode=$Order(^TMIF(MachineCode,2,TCCode)) Quit:TCCode=""  Do
	..Set name=$Piece(^TTAB("TC",TCCode),"\",1)
	..//未配通道号的去除
	..If $Piece($Get(^TMIF(MachineCode,2,TCCode)),"\",1)="" Quit
	..//非数据类型去除
	..Set TCType=$Piece(^TTAB("TC",TCCode),"\",3)
	..//If TCType'["N" Quit
	..If $Length(TestName),name'[TestName Quit
	..Set Visable="false"
	..If TCCode["9999" Quit
	..Do OutputMachineTC
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputMachineTC
	set Data=$lb(TCCode,name,Visable)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetMachineTCFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMachineTCExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query GetMachineTC(DepCode As %String, MachineCode As %String, TestName As %String) As %Query(ROWSPEC = "Code:%String,Name:%String,Visible:%String") [ SqlProc ]
{
}

/// Creator：      DaiYi
/// CreatDate：    20101104
/// Description:： 质控批次对应的检验项目信息查询
/// Table：        
/// Input：        DepCode：科室代码,MachineCode:仪器代码 ,MetCode:质控物代码,LotCode:批次代码
/// Output：       所有项目集合
/// Return：       
/// Others：
ClassMethod GetMetLotTCClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMetLotTCExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Query的执行方法
/// d ##class(%ResultSet).RunQuery("web.类名","query名称","参数1","参数2",参数……
/// d ##class(%ResultSet).RunQuery("web.DHCQCMachine","GetMetLotTC","A","ACA530","ACA530","ACA530-1")
ClassMethod GetMetLotTCExecute(ByRef qHandle As %Binary, DepCode As %String, MachineCode As %String, MetCode As %String, LotCode As %String, TCName As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $Get(ind)="" Set ind=1
	Set TCCode="" For  Set TCCode=$Order(^TMIF(MachineCode,2,TCCode)) Quit:TCCode=""  Do
	.Set name=$Piece(^TTAB("TC",TCCode),"\",1)
	.If name'[TCName Quit
	.Set TCType=$Piece(^TTAB("TC",TCCode),"\",3)
	.//2013-05-15 DaiYi.不限定N类型
	.//If TCType'["N" Quit
	.Set Visable="false"
	.Set metLotCode=MetCode_"||"_LotCode
	.//未配通道号的去除
	.If $Piece($Get(^TMIF(MachineCode,2,TCCode)),"\",1)="" Quit
	.If $Data(^DHCQCTCi(metLotCode)) Do
	..If $Data(^DHCQCTCi(metLotCode,TCCode)) Do
	...Set Visable=$Order(^DHCQCTCi(metLotCode,TCCode,""))
	...i Visable="Y" Set Visable="true"
	...e  s Visable="false"
	.If TCCode["9999" Quit
	.Do OutMetLotTC
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutMetLotTC
	set Data=$lb(TCCode,name,Visable)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetMetLotTCFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMetLotTCExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" 
 	{				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else     
 	{				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query GetMetLotTC(DepCode As %String, MachineCode As %String, MetCode As %String, LotCode As %String, TCName As %String) As %Query(ROWSPEC = "Code:%String,Name:%String,Visible:%String") [ SqlProc ]
{
}

/// Creator：      DaiYi
/// CreatDate：    20110514
/// Description:： 查询仪器对应的质控批次
/// Table：        
/// Input：        DepCode：科室代码,MachineCode:仪器代码
/// Output：       所有项目集合
/// Return：       
/// Others：
Query QueryMachMat(MachCode As %String) As %Query(ROWSPEC = "MachMatCode:%String,MachMatName:%String") [ SqlProc ]
{
}

ClassMethod QueryMachMatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Query的执行方法
/// d ##class(%ResultSet).RunQuery("web.类名","query名称","参数1","参数2",参数……
/// d ##class(%ResultSet).RunQuery("web.DHCQCMachine","QueryMachMat","ACA530")
ClassMethod QueryMachMatExecute(ByRef qHandle As %Binary, MachCode As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $Get(ind)="" Set ind=1
    Set MachCode=$Get(MachCode)
    Set num=0,machMatName=""
    If MachCode="" Quit
    Set machMat="" For  Set machMat=$Order(^DHCQCLOT(MachCode,machMat)) Quit:machMat=""  Do 
    .Set machMatName=$Piece(^DHCQCLOT(MachCode,machMat),"^",2)
    .If $Piece(^DHCQCLOT(MachCode,machMat),"^",8)'="Y" Quit 
    .Do OutputMachMatRow
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK	
		
OutputMachMatRow
	set Data=$lb(machMat,machMatName)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod QueryMachMatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAllExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" 
 	{	
 	    // if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      
 	{	
 	    // fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	    // Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Query的执行方法
/// d ##class(%ResultSet).RunQuery("web.DHCQCMachine","GetMachineTC","A","AXE200")
ClassMethod GetMetLotTCByMachineExecute(ByRef qHandle As %Binary, MatCode As %String, LotCode As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $Get(ind)="" Set ind=1
	Set MatCode=$Get(MatCode),LotCode=$Get(LotCode)
	Set RowId=MatCode_"||"_LotCode
	Set (TCCode,name,Visible,MatName,LotName)="" 
	//If RowId=""  Do OutputMetLotTC
	i $l(MatCode) d 
	.s MatName=$p($g(^DHCQCMAT(MatCode)),"^",2)
	.s CurMachCode=$p($g(^DHCQCMAT(MatCode)),"^",3)
	i $l(LotCode) s LotName=$Piece($Get(^DHCQCLOT(MatCode,LotCode)),"^",12)
	If $Data(^DHCQCTC(RowId)) Do
	.Set TCCode="" For  Set TCCode=$Order(^DHCQCTC(RowId,TCCode)) Quit:TCCode=""  Do
	..Set name=$Piece(^TTAB("TC",TCCode),"\",1)
	..If $p($g(^DHCQCTC(RowId,TCCode,1)),"^",3)'="Y" q
    ..Set Visible="false"
	..Do OutputMetLotTC
	Else  Do
	..//Do OutputMetLotTC
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputMetLotTC
	set Data=$lb(TCCode,name,Visible,MatCode,MatName,LotCode,LotName,CurMachCode)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetMetLotTCByMachineFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMachineTCExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind=""
 	{	
 	    // if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      
 	{	// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query GetMetLotTCByMachine(MatCode As %String, LotCode As %String) As %Query(ROWSPEC = "TCCode:%String,Name:%String,Visible:%String,MatCode,MatName,LotCode,LotName,CurMachCode") [ SqlProc ]
{
}

/// Creator：      DaiYi
/// CreatDate：    20120216
/// Description:： 根据质控批号查询仪器项目。
/// Table：        
/// Input：        MatCode：质控物,LotCode:质控批号 
/// Output：       所有项目集合
/// Return：       
/// Others：
ClassMethod GetMetLotTCByMachineClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMetLotTCExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 查询仪器设备的原始数据。
ClassMethod GetMachineDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMachineDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Query的执行方法
/// d ##class(%ResultSet).RunQuery("web.类名","query名称","参数1","参数2",参数……
/// d ##class(%ResultSet).RunQuery("web.DHCQCMachine","GetAll","A","AU")
ClassMethod GetMachineDataExecute(ByRef qHandle As %Binary, DepCode As %String, MachineName As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	Set DepCode=$Get(DepCode),MachineName=$Get(MachineName)
	If $Get(ind)="" Set ind=1
	Set code="" For  Set code=$Order(^TMIF(code)) Quit:code=""  Do
	.Set name=$Piece($Get(^TMIF(code)),"\",1)
	.If $Length(MachineName),name'[MachineName Quit
	.ZN "LABDATA"
	.Set machineDept=$$CT013^at178(code)
	.ZN "websrc"
	.If machineDept=DepCode d
	..Do OutputMachines1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK	
	
OutputMachines1
	set Data=$lb(code,name)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetMachineDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAllExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" 
 	{				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      
 	{	// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：      DaiYi
/// CreatDate：    20101026
/// Description:： 查询科室仪器
/// Table：        DHCQC_TmpResult
/// Input：        DepCode:科室代码,MachName:仪器名称
/// Output：       仪器集合
/// Return：       0:无,1:有
/// Others：
Query GetMachineData(DepCode As %String, MachName As %String) As %Query(ROWSPEC = "code:%String,name:%String") [ SqlProc ]
{
}

/// 查询所有医院的设备信息。按照医院信息显示出来
ClassMethod GetAllByHospClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllByHospExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Query的执行方法
/// d ##class(%ResultSet).RunQuery("web.类名","query名称","参数1","参数2",参数……
/// d ##class(%ResultSet).RunQuery("web.DHCQCMachine","GetAllByHosp","A","","","LABDATA")
ClassMethod GetAllByHospExecute(ByRef qHandle As %Binary, DepCode As %String, MachineName As %String, HospCode As %String, sLabNameSpace As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set DepCode=$Get(DepCode),MachineName=$Get(MachineName),sLabNameSpace=$Get(sLabNameSpace),HospCode=$Get(HospCode)
	If $Get(ind)="" Set ind=1
	Set code="" For  Set code=$Order(^TMIF(code)) Quit:code=""  Do
	.Set name=$Piece($Get(^TMIF(code)),"\",1)
	.If $Length(MachineName),name'[MachineName Quit
	.//Set machineDept=$$CT013^at178(code)
	.//Set machineDept=code
	.Set (CurHospCode,CurHospName)=""
	.Set CurHospCode=$Piece($Get(^[sLabNameSpace]DHCMachinePara(code)),"\",7)
	.Set machineDept=$Piece($Get(^[sLabNameSpace]DHCMachinePara(code)),"\",1)
	.If $Length(CurHospCode),$Data(^[sLabNameSpace]TTAB("CC",CurHospCode)) Set CurHospName=$Piece($Get(^[sLabNameSpace]TTAB("CC",CurHospCode)),"\",1)
	.If $Length(HospCode),HospCode'=CurHospCode Quit
	.If machineDept[DepCode d
	..Do OutputMachinesByHosp
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK	
	
OutputMachinesByHosp
	set Data=$lb(code,name,CurHospCode,CurHospName)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetAllByHospFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAllByHospExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" 
 	{				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      
 	{	// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：      DaiYi
/// CreatDate：    20121113
/// Description:： 按照科室查询所有设备归属医院
/// Table：        DHC_Machine
/// Input：        DepCode:科室代码,MachName:仪器名称,HospCode:医院代码
/// Output：       仪器集合
/// Return：       0:无,1:有
/// Others：
Query GetAllByHosp(DepCode As %String, MachName As %String, HospCode As %String, sLabNameSpace As %String) As %Query(ROWSPEC = "code:%String,name:%String,HospCode:%String,HospName:%String") [ SqlProc ]
{
}

/// Creator：      DaiYi
/// CreatDate：    20121113
/// Description:： 更新仪器归属医院
/// Table：        DHC_Machine
/// Input：        MachCode:仪器代码,HospCode:医院代码
/// Output：       仪器集合
/// Return：       0:无,1:有
/// Others：
ClassMethod UpdateHospCode(MachCode As %String, HospCode As %String, sNameSpace As %String, LabNameSpace As %String) As %String
{
	Set MachCode=$Get(MachCode),HospCode=$Get(HospCode),sNameSpace=$Get(sNameSpace),LabNameSpace=$Get(LabNameSpace)
	ZN LabNameSpace
	Kill PLIST
	Set PLIST(2)=MachCode,PLIST(9)=HospCode
	Set Ret=$$update^DHCLVBMachine(MachCode)
	ZN sNameSpace
	Quit Ret
}

/// Creator：      DaiYi
/// CreatDate：    20121113
/// Description:： 查询仪器数据中间表是否已经保存记录
/// Table：        DHCQC_TmpResult
/// Input：        MachCode:仪器代码，RunDate:质控日期,Epis:质控编号,TCCode:项目编号,SeqCode:序号
/// Output：       仪器集合
/// Return：       0:无,1:有
/// Others：
ClassMethod QueryTmpQCData(MachCode As %String, RunDate As %String, Epis As %String, TCCode As %String, SeqCode As %String) As %String
{
	Set MachCode=$Get(MachCode),RunDate=$Get(RunDate),Epis=$Get(Epis),TCCode=$Get(TCCode),SeqCode=$Get(SeqCode)
	Set Ret=0
	If MachCode="" Quit 0
	If RunDate="" Quit 0
	If Epis="" Quit 0
	If TCCode="" Quit 0
	If SeqCode="" Quit 0
	If $Data(^DHCQCTR(MachCode,RunDate,Epis,TCCode,SeqCode)) Do
	.Set Ret=1
	Quit Ret
}

/// Creator：      DaiYi
/// CreatDate：    20121113
/// Description:： 查询质控业务表是否存在数据
/// Table：        DHCQC_TmpResult
/// Input：        RowId:唯一代码,RunDate:执行日期,SeqCode:序号
/// Output：       仪器集合
/// Return：       0:无,1:有
/// Others：
ClassMethod QueryQCData(RowId As %String, RunDate As %String, SeqCode As %String) As %String
{
	Set RowId=$Get(RowId),RunDate=$Get(RunDate),SeqCode=$Get(SeqCode)
	Set Ret=0
	If RowId="" Quit 0
	If RunDate="" Quit 0
	If SeqCode="" Quit 0
	If $Data(^DHCQCIV(RowId,RunDate,SeqCode)) Do
	.Set Ret=1
	Quit Ret
}

ClassMethod QueryTCByDeptClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryTCByDeptExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Query的执行方法
/// d ##class(%ResultSet).RunQuery("web.类名","query名称","参数1","参数2",参数……
/// d ##class(%ResultSet).RunQuery("web.DHCQCMachine","QueryTCByDept","A","","K01","2014-07-01","2014-07-31","","","LABDATA")
ClassMethod QueryTCByDeptExecute(ByRef qHandle As %Binary, DepCode, MachCode, HospCode, StartDate, EndDate, MatCode1, LotCode1, NameSpace) As %Status
{
	Set repid=$I(^CacheTemp)
	Set DepCode=$Get(DepCode),MachCode=$Get(MachCode),HospCode=$g(HospCode),StartDate=$g(StartDate)
	s EndDate=$g(EndDate),MatCode1=$g(MatCode1),LotCode1=$g(LotCode1)
	s StartDate=$ZDH(StartDate,3),EndDate=$ZDH(EndDate,3)

	If $Get(ind)="" Set ind=1
	i $l(DepCode),$d(^DHCQCMATi("DEP",DepCode)) d
	.s CurMachCode="" f  s CurMachCode=$o(^DHCQCMATi("DEP",DepCode,CurMachCode))  q:CurMachCode=""  d
	..s CurHospCode=$p($g(^[NameSpace]DHCMachinePara(CurMachCode)),"\",7)
	..i $l(MachCode),MachCode'=CurMachCode Q
	..i $l(HospCode),HospCode'=CurHospCode q
	..s MatCode="" f  s MatCode=$o(^DHCQCMATi("DEP",DepCode,CurMachCode,MatCode))  q:MatCode=""  d
	...i $l(MatCode1),MatCode1'=MatCode q
	...s MatName=$p($g(^DHCQCMAT(MatCode)),"^",2)
	...i $p($g(^DHCQCMAT(MatCode)),"^",7)="N" q
	...s LotCode="" f  s LotCode=$o(^DHCQCLOT(MatCode,LotCode)) q:LotCode=""  d
	....i $l(LotCode1),LotCode'=LotCode1 q
	....s LotName=$Piece($Get(^DHCQCLOT(MatCode,LotCode)),"^",12)
	....i $p($g(^DHCQCLOT(MatCode,LotCode)),"^",10)'="Y" q
	....s EndDateSetUp=$p($g(^DHCQCLOT(MatCode,LotCode)),"^",4)
	....s MatStartDate=$p($g(^DHCQCLOT(MatCode,LotCode)),"^",3)
	....i (StartDate>EndDateSetUp)||(StartDate<MatStartDate) q
	....i (EndDate<MatStartDate)||(EndDate>EndDateSetUp) q
	....//取项目信息
	....s RowId=MatCode_"||"_LotCode
	....s TCCode="" f  s TCCode=$o(^DHCQCTC(RowId,TCCode)) q:TCCode=""  d
	.....s name=$p(^TTAB("TC",TCCode),"\",1)
	.....i $p($g(^DHCQCTC(RowId,TCCode,1)),"^",3)'="Y" q
    .....s Visible="false"
    .....Set QCID=""
	.....Set LevNo="" For  Set LevNo=$Order(^DHCQCTC(RowId,TCCode,LevNo)) Quit:LevNo=""  Do
	......If QCID'="" Do
	.......Set QCID=QCID_","_LevNo
	......Else  Do
	.......Set QCID=LevNo
    .....d OutputTCByOther
    
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK	
	
OutputTCByOther
	set Data=$lb(TCCode,name,Visible,MatCode,MatName,LotCode,LotName,CurMachCode,QCID)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod QueryTCByDeptFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryTCByDeptExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" 
 	{				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      
 	{	// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：      DaiYi
/// CreatDate：    20140709
/// Description:： 根据科室,仪器查询当前范围内的项目和批次
/// Table：        
/// Input：        DepCode, MachCode, HospCode,StartDate,EndDate,MatCode1,LotCode1,NameSpace
/// Output：       仪器集合
/// Return：       0:无,1:有
/// Others：
Query QueryTCByDept(DepCode, MachCode, HospCode, StartDate, EndDate, MatCode1, LotCode1, NameSpace) As %Query(ROWSPEC = "TCCode,name,Visible,MatCode,MatName,LotCode,LotName,CurMachCode,QCID") [ SqlProc ]
{
}

}
