/// 质控物信息查询
Class web.DHCQCMaterialQuery Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

ClassMethod GetAllClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Query的执行方法
/// d ##class(%ResultSet).RunQuery("web.类名","query名称","参数1","参数2",参数……
/// d ##class(%ResultSet).RunQuery("web.DHCQCMaterialQuery","GetAll","A","AC1500")
ClassMethod GetAllExecute(ByRef qHandle As %Binary, DepCode As %String, MachineCode As %String) As %Status
{
	Set DepCode=$Get(DepCode),MachineCode=$Get(MachineCode)
 	Set repid=$I(^CacheTemp)
	If $Get(ind)="" Set ind=1
	If $Data(^DHCQCMATi("DEP",DepCode,MachineCode)) Do
	.Set MetCode="" For  Set MetCode=$Order(^DHCQCMATi("DEP",DepCode,MachineCode,MetCode)) Quit:MetCode=""  Do
	..If $Data(^DHCQCMAT(MetCode))  Set str=$Get(^DHCQCMAT(MetCode))
	..If $Data(^TMIF(MachineCode)) Set MachineName=$Piece(^TMIF(MachineCode),"\",1)
	..If $Data(^TTAB("DEP",DepCode)) Set DepName=$Piece(^TTAB("DEP",DepCode),"\",1)
	..Set MatDesc=$Piece(str,"^",2)
	..Set Comments=$Piece(str,"^",5)
	..Set WaveLen=$Piece(str,"^",6)
	..Set Visible=$Piece(str,"^",7)
	..Set Levels=$Piece(str,"^",8)
	..Set Autstorage=$Piece(str,"^",9)
	..Set DisplaySeq=$Piece(str,"^",10)
	..If Visible="N" Quit
	..Do OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRow
    Set Data=$lb(DepName,MachineName,MetCode,MatDesc,Comments,WaveLen,Visible,Levels,Autstorage,DisplaySeq)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetAllFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAllExecute ]
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

/// Creator：      DaiYi
/// CreatDate：    20101028
/// Description:： 质控物查询
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others：
Query GetAll(DepCode As %String, MachineCode As %String) As %Query(ROWSPEC = "DepartmentName:%String,MachineName:%String,MatCode:%String,MatDesc:%String,Comments:%String,WaveLen:%String,Visible:%String,Levels:%String,Autstorage:%String,DisplaySeq:%String") [ SqlProc ]
{
}

/// Creator：      DaiYi
/// CreatDate：    20110615
/// Description:： 获取浓度数据
/// Table：        DHCQC_Material
/// Input：        MatCode:质控物批号。 
/// Output：       浓度个数
/// Return：       Times
/// Others：
/// d ##class(web.DHCQCMaterialQuery).QueryMatTime("ACA530")
ClassMethod QueryMatTime(MatCode As %String) As %String
{
	Set Times="0"
	Set MatCode=$Get(MatCode)
    If $Data(^DHCQCMAT(MatCode)) Do
    .Set Times=$Piece($Get(^DHCQCMAT(MatCode)),"^",8)
    Set Times=+Times
    Quit Times
}

/// Creator：      DaiYi
/// CreatDate：    20120615
/// Description:： 按照仪器浓度获取ID号
/// Table：        DHCQC_Material
/// Input：        MatCode:质控物批号。 
/// Output：       浓度个数
/// Return：       Times
/// Others：
/// d ##class(web.DHCQCMaterialQuery).QueryMatQCID("ACA530")
ClassMethod QueryMatQCID(MatCode As %String) As %String
{
	Set Times="0"
	Set MatCode=$Get(MatCode)
    If $Data(^DHCQCMAT(MatCode)) Do
    .Set Times=$Piece($Get(^DHCQCMAT(MatCode)),"^",8)
    Set Times=+Times
    Quit Times
}

/// Creator：      DaiYi
/// CreatDate：    20110615
/// Description:： 获取质控物,浓度批次信息
/// Table：        DHCQC_Material
/// Input：        MachCode:仪器代码,EndDate:判断当前批号的结束日期
/// Output：       质控物^
/// Return：       Times
/// Others：
/// d ##class(web.DHCQCMaterialQuery).QueryMatTimeStr("ALBYN6","2013-11-25")
ClassMethod QueryMatTimeStr(MachCode As %String, EndDate As %String) As %String
{
	Set Times="0"
	Set Num=0,StrMatTime=""
	Set MachCode=$Get(MachCode),EndDate=$Get(EndDate)
	If EndDate="" Do 
	.Set EndDate=+$H
	Else  Do
	.Set EndDate=$ZDH(EndDate,3)
	//质控物
    Set MatCode="" For  Set MatCode=$Order(^DHCQCMAT(MatCode)) Quit:MatCode=""  Do
    .Set CurMachCode=$Piece($Get(^DHCQCMAT(MatCode)),"^",3)
    .Set Times=$Piece($Get(^DHCQCMAT(MatCode)),"^",8)
    .//不可见即屏蔽
    .i $Piece($Get(^DHCQCMAT(MatCode)),"^",7)="N" q
    .If +Times<1 Quit
    .If CurMachCode'=MachCode Quit
    .//质控批号
    .Set LotCode="" For  Set LotCode=$Order(^DHCQCLOT(MatCode,LotCode)) Quit:LotCode=""  Do
    ..//非当前批次，不能获取
    ..If $Piece($Get(^DHCQCLOT(MatCode,LotCode)),"^",10)'="Y" Quit
    ..//不可见，不让配置
    ..i $Piece($Get(^DHCQCLOT(MatCode,LotCode)),"^",8)="N" Quit 
    ..//是否属于当前的有效范围内
    ..Set EndDateSetUp=$Piece($Get(^DHCQCLOT(MatCode,LotCode)),"^",4)
    ..If (EndDate+1)>EndDateSetUp Quit
    ..Set MatStartDate=$Piece($Get(^DHCQCLOT(MatCode,LotCode)),"^",3)
    ..Set MatEndDate=$Piece(^DHCQCLOT(MatCode,LotCode),"^",4)
    ..If EndDate<MatStartDate Quit
    ..If MatStartDate<=+$h,+$h>=MatEndDate Do
    ..For i=1:1:(+Times) Do
    ...Set QCID=""
    ...If $Data(^DHCQCMQ(MachCode_"||"_MatCode_"||"_LotCode,i)) Do
    ....Set QCID=$Piece($Get(^DHCQCMQ(MachCode_"||"_MatCode_"||"_LotCode,i)),"^",3)
    ...Set StrMatTime=StrMatTime_MatCode_"||"_LotCode_"^"_i_"^"_QCID_"!"
    Quit StrMatTime
}

/// Creator：      DaiYi
/// CreatDate：    20140625
/// Description:： 查询当前批次的浓度和标识
/// Table：        DHCQC_Material
/// Input：        MachCode:仪器代码,EndDate:判断当前批号的结束日期,LotCode:批次
/// Output：       质控物^
/// Return：       Times
/// Others：
/// d ##class(web.DHCQCMaterialQuery).QueryMatTimeStr("F001","2013-11-25","657365")
ClassMethod QueryMatLotTime(MatCode As %String, EndDate As %String, LotCode As %String) As %String
{
	Set Times="0"
	Set Num=0,StrMatTime=""
	Set MachCode=$Get(MachCode),EndDate=$Get(EndDate),LotCode=$g(LotCode)
	s EndDate=+$h
	//质控物
    //Set MatCode="" For  Set MatCode=$Order(^DHCQCMAT(MatCode)) Quit:MatCode=""  Do
    i $d(^DHCQCMAT(MatCode)) d
    .Set MachCode=$Piece($Get(^DHCQCMAT(MatCode)),"^",3)
    .Set Times=$Piece($Get(^DHCQCMAT(MatCode)),"^",8)
    .b ;122
    .If +Times<1 Quit
    .//质控批号
    .i $d(^DHCQCLOT(MatCode,LotCode)) d
    ..//非当前批次，不能获取
    ..//If $Piece($Get(^DHCQCLOT(MatCode,LotCode)),"^",10)'="Y" Quit
    ..//是否属于当前的有效范围内
    ..Set EndDateSetUp=$Piece($Get(^DHCQCLOT(MatCode,LotCode)),"^",4)
    ..//If (EndDate+1)>EndDateSetUp Quit
    ..Set MatStartDate=$Piece($Get(^DHCQCLOT(MatCode,LotCode)),"^",3)
    ..Set MatEndDate=$Piece(^DHCQCLOT(MatCode,LotCode),"^",4)
    ..//If EndDate<MatStartDate Quit
    ..//If MatStartDate<=+$h,+$h>=MatEndDate Do
    ..For i=1:1:(+Times) Do
    ...Set QCID=""
    ...If $Data(^DHCQCMQ(MachCode_"||"_MatCode_"||"_LotCode,i)) Do
    ....Set QCID=$Piece($Get(^DHCQCMQ(MachCode_"||"_MatCode_"||"_LotCode,i)),"^",3)
    ...Set StrMatTime=StrMatTime_MatCode_"||"_LotCode_"^"_i_"^"_QCID_"!"
    Quit StrMatTime
}

/// Creator：      DaiYi
/// CreatDate：    20110616
/// Description:： 按照质控标示
/// Table：        DHCQC_Material
/// Input：        MachCode:仪器代码 
/// Output：       质控物^
/// Return：       Times
/// Others：
/// d ##class(web.DHCQCMaterialQuery).SaveQCID("","","","")
ClassMethod SaveQCID(MachCode As %String, MatLotCode As %String, LevelNo As %String, QCId As %String) As %String
{
	//Set MachCode="AD10",MatLotCode="AD10||125-987",LevelNo="1",QCId=21
	Set MachCode=$Get(MachCode),MatLotCode=$Get(MatLotCode),LevelNo=$Get(LevelNo),QCId=$Get(QCId)
	Set ParRef=MachCode_"||"_MatLotCode
	SET $ZTRAP="ErrorHandle",$ECODE=""
	//TSTART  //事务开始
	If '$Data(^DHCQCMQ(ParRef,LevelNo)) Do
	.&SQL(Insert Into lab.DHCQC_MachineQC(DQMQ_ParRef,DQMQ_LevelNo,DQMQ_SampleID) Values(:ParRef,:LevelNo,:QCId) )
	Else  Do
	.Set SQLCODE=0
	.//&SQL(Update lab.DHCQC_MachineQC Set DQMQ_SampleID =:QCId  Where DQMQ_ParRef =:ParRef and DQMQ_LevelNo=:LevelNo )
	.//If SQLCODE Quit $$Rollback("更新审核信息失败:"_SQLCODE)
	.Set $Piece(^DHCQCMQ(ParRef,LevelNo),"^",3)=QCId
	.b ;12
	//TCOMMIT
	Quit SQLCODE
	
Rollback(para)
  s para=$g(para)
  TROLLBACK
  s ^TMP($zn,"error")=para
  q "1"_$c(2)_para
  //错误处理
ErrorHandle
  s RetMsg="错误信息:"_$tr($ZERROR,"^","--")_".错误代码:"_$ECODE
  q $$Rollback(RetMsg)
}

ClassMethod QueryLotClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryLotTCExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Query的执行方法
/// d ##class(%ResultSet).RunQuery("web.类名","query名称","参数1","参数2",参数……
/// d ##class(%ResultSet).RunQuery("web.DHCQCMaterialQuery","QueryLot","ACA1500","2013-03-03","2012-03-10")
ClassMethod QueryLotExecute(ByRef qHandle As %Binary, MaterialCode As %String, StartDate As %String, EndDate As %String) As %Status
{
	Set MaterialCode=$Get(MaterialCode),StartDate=$Get(StartDate),EndDate=$Get(EndDate)
 	Set repid=$I(^CacheTemp)
	If $Get(ind)="" Set ind=1
	Set (LotCode,LotName,LotRowId)=""
	If '$Length(MaterialCode) Do OutputLot
	If '$Length(StartDate) Do  
	.Set StartDate=+$H,EndDate=+$H
	Else
	.Set StartDate=$ZDH(StartDate,3),EndDate=$ZDH(EndDate,3)
	If $Data(^DHCQCLOT(MaterialCode)) Do
	.Set LotCode="" For  Set LotCode=$Order(^DHCQCLOT(MaterialCode,LotCode)) Quit:LotCode=""  Do
	..Set LotName=$Piece($Get(^DHCQCLOT(MaterialCode,LotCode)),"^",12)
	..Set CurStartDate=$Piece($Get(^DHCQCLOT(MaterialCode,LotCode)),"^",3)
	..Set CurEndDate=$Piece($Get(^DHCQCLOT(MaterialCode,LotCode)),"^",4)
	..//结束日期超过有效期还是让查询出来。只是数据不让输出。
	..//If CurStartDate>StartDate Quit
	..//If CurEndDate<StartDate Quit
	..If $Piece($Get(^DHCQCLOT(MaterialCode,LotCode)),"^",8)'="Y" Quit
	..Set LotRowId=MaterialCode_"||"_LotCode
	..Do OutputLot
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputLot
    Set Data=$lb(LotCode,LotName,LotRowId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryLotFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryLotExecute ]
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

/// Creator：      DaiYi
/// CreatDate：    20120307
/// Description:： 质控批号查询
/// Table：        DHCQC_Lot
/// Input：        MaterialCode:质控物代码，StartDate:开始日期，EndDate:结束日期
/// Output：       质控批号信息
/// Return：       0:无,1:有
/// Others：
Query QueryLot(MaterialCode As %String, StartDate As %String, EndDate As %String) As %Query(ROWSPEC = "LotCode:%String,LotName:%String,LotRowId:%String") [ SqlProc ]
{
}

ClassMethod QueryLotTCClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryLotTCExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Query的执行方法
/// d ##class(%ResultSet).RunQuery("web.类名","query名称","参数1","参数2",参数……
/// d ##class(%ResultSet).RunQuery("web.DHCQCMaterialQuery","QueryLotTC","ACA530||548136-1")
ClassMethod QueryLotTCExecute(ByRef qHandle As %Binary, LotRowId As %String) As %Status
{
	Set LotRowId=$Get(LotRowId)
 	Set repid=$I(^CacheTemp)
	If $Get(ind)="" Set ind=1
	If '$Length(LotRowId) Quit $$$OK
	If $Data(^DHCQCTC(LotRowId)) Do
	.Set TCCode="" For  Set TCCode=$Order(^DHCQCTC(LotRowId,TCCode)) Quit:TCCode=""  Do
	..Set TCName=$Piece($Get(^TTAB("TC",TCCode)),"\",1)
	..Do OutputLotTC
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputLotTC
    Set Data=$lb(TCCode,TCName,LotRowId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryLotTCFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryLotTCExecute ]
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

/// Creator：      DaiYi
/// CreatDate：    20120307
/// Description:： 质控批号查询
/// Table：        DHCQC_TestCode
/// Input：        LotRowId:：质控批号RowId
/// Output：       质控批号项目
/// Return：       0:无,1:有
/// Others：
Query QueryLotTC(LotRowId As %String) As %Query(ROWSPEC = "TestCode:%String,TestName:%String,LotRowId:%String") [ SqlProc ]
{
}

/// Creator：      DaiYi
/// CreatDate：    20120320
/// Description:： 根据质控批号查询标示
/// Table：        DHCQC_MachineQC
/// Input：        MachCode:仪器代码,MatCode:质控物代码,LotCode:批号代码
/// Output：       RowID,浓度代码,浓度标示
/// Return：       RetStr
/// Others：
/// d ##class(web.DHCQCMaterialQuery).QueryQCID("","","")
ClassMethod QueryQCID(MachCode As %String, MatCode As %String, LotCode As %String) As %String
{
	Set MachCode=$Get(MachCode),MatCode=$Get(MatCode),LotCode=$Get(LotCode)
	Set RowId=MachCode_"||"_MatCode_"||"_LotCode
	Set RetStr=""
	If $Data(^DHCQCMQ(RowId)) Do
	.Set OrderId="" For  Set OrderId=$Order(^DHCQCMQ(RowId,OrderId)) Quit:OrderId=""  Do
	..Set QCId=$Piece($Get(^DHCQCMQ(RowId,OrderId)),"^",3)
	..Set RetStr=RetStr_RowId_"!"_OrderId_"!"_QCId_"^"
	If RetStr="" Set RetStr="!!^"
	Quit RetStr
}

/// Creator：      DaiYi
/// CreatDate：    20140703
/// Description:： 判断是否可以删除质控物，如果配置了批次，就不让删除
/// Table：        DHCQC_Mat
/// Input：        MatCode:质控物代码
/// Output：       个数
/// Return：       Ret
/// Others：
/// d ##class(web.DHCQCMaterialQuery).QueryMatNum("CA1500")
ClassMethod QueryMatNum(MatCode As %String) As %String
{
	s MatCode=$g(MatCode)
	s Ret=0
	i $d(^DHCQCMAT(MatCode)) d
	.s LotCode="" f  s LotCode=$o(^DHCQCLOT(MatCode,LotCode)) q:LotCode=""  d
	..s Ret=Ret+1
	q Ret
}

/// Creator：      DaiYi
/// CreatDate：    20140703
/// Description:： 判断是否可以删除批次，如果配置了项目，就不让删除
/// Table：        DHCQC_Lot
/// Input：        MatLotRowId:批次RowID
/// Output：       个数
/// Return：       Ret
/// Others：
/// d ##class(web.DHCQCMaterialQuery).QueryMatLotNum("CA1500||C09301")
ClassMethod QueryMatLotNum(MatLotRowId As %String) As %String
{
	s MatLotRowId=$g(MatLotRowId)
	s Ret=0
	i $d(^DHCQCTC(MatLotRowId)) d
	.s TCCode="" f  s TCCode=$o(^DHCQCTC(MatLotRowId,TCCode)) q:TCCode=""  d
	..s Ret=Ret+1
	q Ret
}

/// Creator：      DaiYi
/// CreatDate：    20120320
/// Description:： 根据质控物查询质控规则
/// Table：        DHCQCMat_Rul
/// Input：        MatCode:质控物代码
/// Output：       质控规则
/// Return：       Times
/// Others：
/// d ##class(web.DHCQCMaterialQuery).QueryMatQCRule("ACA530")
ClassMethod QueryMatQCRule(MatCode As %String) As %String
{
	Set MatCode=$Get(MatCode)
	Set RetStr=""
	If $Data(^DHCQCMATRL(MatCode)) Do
	Set RuleCode="" For  Set RuleCode=$Order(^DHCQCMATRL(MatCode,RuleCode)) Quit:RuleCode=""  Do
	.Set RuleName=$Piece($Get(^DHCQCRL(RuleCode)),"^",2)
	.//禁止规则不显示
    .i $Piece($Get(^DHCQCMATRL(MatCode,RuleCode)),"^",1)="Disable" q
	.Set RetStr=RetStr_RuleCode_"|"_RuleName_"^"
	If RetStr="" Set RetStr="|^" 
	Quit RetStr
}

/// Creator：      DaiYi
/// CreatDate：    20121210
/// Description:： 判断是否为质控编号
/// Table：        DHCQC_Material
/// Input：        MachCode:仪器代码,Epis:质控编号,EndDate:判断当前批号的结束日期
/// Output：       质控物^
/// Return：       质控编号
/// Others：
/// d ##class(web.DHCQCMaterialQuery).MachineQC("ACA530",901,"")
ClassMethod MachineQC(MachCode As %String, Epis As %String, EndDate As %String) As %String
{
	Set Times="0"
	Set Num=0,StrMatTime="",Ret=""
	Set MachCode=$Get(MachCode),EndDate=$Get(EndDate)
	If MachCode="" Quit Ret
	If EndDate="" Do 
	.Set EndDate=+$H
	Else  Do
	.Set EndDate=$ZDH(EndDate,3)
	//质控物
    Set MatCode="" For  Set MatCode=$Order(^DHCQCMAT(MatCode)) Quit:MatCode=""  Do
    .Set CurMachCode=$Piece($Get(^DHCQCMAT(MatCode)),"^",3)
    .Set Times=$Piece($Get(^DHCQCMAT(MatCode)),"^",8)
    .If +Times<1 Quit
    .If CurMachCode'=MachCode Quit
    .//质控批号
    .Set LotCode="" For  Set LotCode=$Order(^DHCQCLOT(MatCode,LotCode)) Quit:LotCode=""  Do
    ..//非当前批次，不能获取
    ..If $Piece($Get(^DHCQCLOT(MatCode,LotCode)),"^",10)'="Y" Quit
    ..//是否属于当前的有效范围内
    ..Set EndDateSetUp=$Piece($Get(^DHCQCLOT(MatCode,LotCode)),"^",4)
    ..//If (EndDate+1)>EndDateSetUp Quit
    ..Set MatStartDate=$Piece($Get(^DHCQCLOT(MatCode,LotCode)),"^",3)
    ..Set MatEndDate=$Piece(^DHCQCLOT(MatCode,LotCode),"^",4)
    ..If MatStartDate<=+$h,+$h<=MatEndDate Do
    ...For i=1:1:(+Times) Do
    ....Set QCID=""
    ....If $Data(^DHCQCMQ(MachCode_"||"_MatCode_"||"_LotCode,i)) Do
    .....Set QCID=$Piece($Get(^DHCQCMQ(MachCode_"||"_MatCode_"||"_LotCode,i)),"^",3)
    .....If QCID=Epis  Set Ret=Epis
    Quit Ret
}

/// Creator：      DaiYi
/// CreatDate：    20121210
/// Description:： 返回当前的只控制和批号信息
/// Table：        DHCQC_Material
/// Input：        MachCode:仪器代码,Epis:质控编号,EndDate:判断当前批号的结束日期
/// Output：       质控物^
/// Return：       质控物和批号
/// Others：       必须要控制不能同时出现多个相同的批号进入系统
/// d ##class(web.DHCQCMaterialQuery).MachineQC("ACA530",901,"")
ClassMethod MachMatLot(MachCode As %String, Epis As %String, EndDate As %String) As %String
{
	Set Times="0"
	Set Num=0,StrMatTime="",Ret=""
	Set MachCode=$Get(MachCode),EndDate=$Get(EndDate)
	If MachCode="" Quit Ret
	If EndDate="" Do 
	.Set EndDate=+$H
	Else  Do
	.Set EndDate=$ZDH(EndDate,3)
	//质控物
    Set MatCode="" For  Set MatCode=$Order(^DHCQCMAT(MatCode)) Quit:MatCode=""  Do
    .Set CurMachCode=$Piece($Get(^DHCQCMAT(MatCode)),"^",3)
    .Set Times=$Piece($Get(^DHCQCMAT(MatCode)),"^",8)
    .If +Times<1 Quit
    .If CurMachCode'=MachCode Quit
    .//质控批号
    .Set LotCode="" For  Set LotCode=$Order(^DHCQCLOT(MatCode,LotCode)) Quit:LotCode=""  Do
    ..//非当前批次，不能获取
    ..If $Piece($Get(^DHCQCLOT(MatCode,LotCode)),"^",10)'="Y" Quit
    ..//是否属于当前的有效范围内
    ..Set EndDateSetUp=$Piece($Get(^DHCQCLOT(MatCode,LotCode)),"^",4)
    ..If EndDate>EndDateSetUp Quit
    ..Set MatStartDate=$Piece($Get(^DHCQCLOT(MatCode,LotCode)),"^",3)
    ..Set MatEndDate=$Piece(^DHCQCLOT(MatCode,LotCode),"^",4)
    ..//控制录入质控时间，为当批次时间内。时间限制太死，导致很多数据无法正常保存进来，DaiYi 2014-06-30
    ..//If MatStartDate<+EndDate+1,+EndDate<MatEndDate+1 Do
    ..For i=1:1:(+Times) Do
    ...Set QCID=""
    ...If $Data(^DHCQCMQ(MachCode_"||"_MatCode_"||"_LotCode,i)) Do
    ....Set QCID=$Piece($Get(^DHCQCMQ(MachCode_"||"_MatCode_"||"_LotCode,i)),"^",3)
    ....If QCID=Epis  Set Ret=MachCode_"||"_MatCode_"||"_LotCode_"||"_i
    Quit Ret
}

/// Creator：      DaiYi
/// CreatDate：    20121210
/// Description:： 根据编号查询浓度号
/// Table：        DHCQC_Material
/// Input：        MachCode:仪器代码,Epis:质控编号,EndDate:判断当前批号的结束日期
/// Output：       质控物^
/// Return：       质控编号
/// Others：
/// d ##class(web.DHCQCMaterialQuery).MachineLevelNo("BDXC600",902,"")
ClassMethod MachineLevelNo(MachCode As %String, Epis As %String, EndDate As %String) As %String
{
	New (MachCode,Epis,EndDate)
	Set Times="0"
	Set Num=0,StrMatTime="",Ret=""
	Set MachCode=$Get(MachCode),EndDate=$Get(EndDate)
	If MachCode="" Quit Ret
	If EndDate="" Do 
	.Set EndDate=+$H
	Else  Do
	.Set EndDate=$ZDH(EndDate,3)
	//质控物
    Set MatCode="" For  Set MatCode=$Order(^DHCQCMAT(MatCode)) Quit:MatCode=""  Do
    .Set CurMachCode=$Piece($Get(^DHCQCMAT(MatCode)),"^",3)
    .Set Times=$Piece($Get(^DHCQCMAT(MatCode)),"^",8)
    .If +Times<1 Quit
    .If CurMachCode'=MachCode Quit
    .//质控批号
    .Set LotCode="" For  Set LotCode=$Order(^DHCQCLOT(MatCode,LotCode)) Quit:LotCode=""  Do
    ..//非当前批次，不能获取
    ..If $Piece($Get(^DHCQCLOT(MatCode,LotCode)),"^",10)'="Y" Quit
    ..//是否属于当前的有效范围内
    ..Set EndDateSetUp=$Piece($Get(^DHCQCLOT(MatCode,LotCode)),"^",4)
    ..If (EndDate+1)>EndDateSetUp Quit
    ..Set MatStartDate=$Piece($Get(^DHCQCLOT(MatCode,LotCode)),"^",3)
    ..Set MatEndDate=$Piece(^DHCQCLOT(MatCode,LotCode),"^",4)
    ..If MatStartDate<=+$h,+$h<=MatEndDate Do
    ...For i=1:1:(+Times) Do
    ....Set QCID=""
    ....If $Data(^DHCQCMQ(MachCode_"||"_MatCode_"||"_LotCode,i)) Do
    .....Set QCID=$Piece($Get(^DHCQCMQ(MachCode_"||"_MatCode_"||"_LotCode,i)),"^",3)
    .....Set LevelNo=$Piece($Get(^DHCQCMQ(MachCode_"||"_MatCode_"||"_LotCode,i)),"^",2)
    .....If QCID=Epis Do
    ......Set Ret=LevelNo
    Quit Ret
}

/// Creator：      DaiYi
/// CreatDate：    20130315
/// Description:： 根据浓度查询编号
/// Table：        DHCQC_Material
/// Input：        MachCode:仪器代码,Epis:质控编号,EndDate:判断当前批号的结束日期
/// Output：       质控物^
/// Return：       质控编号
/// Others：
/// d ##class(web.DHCQCMaterialQuery).MachineLevelNo("BDXC600",902,"")
ClassMethod MachineLevelNoEpis(MachCode As %String, Epis As %String, EndDate As %String) As %String
{
	New (MachCode,Epis,EndDate)
	Set Times="0"
	Set Num=0,StrMatTime="",Ret=""
	Set MachCode=$Get(MachCode),EndDate=$Get(EndDate)
	If MachCode="" Quit Ret
	If EndDate="" Do 
	.Set EndDate=+$H
	Else  Do
	.Set EndDate=$ZDH(EndDate,3)
	//质控物
    Set MatCode="" For  Set MatCode=$Order(^DHCQCMAT(MatCode)) Quit:MatCode=""  Do
    .Set CurMachCode=$Piece($Get(^DHCQCMAT(MatCode)),"^",3)
    .Set Times=$Piece($Get(^DHCQCMAT(MatCode)),"^",8)
    .If +Times<1 Quit
    .If CurMachCode'=MachCode Quit
    .//质控批号
    .Set LotCode="" For  Set LotCode=$Order(^DHCQCLOT(MatCode,LotCode)) Quit:LotCode=""  Do
    ..//是否属于当前的有效范围内
    ..Set EndDateSetUp=$Piece($Get(^DHCQCLOT(MatCode,LotCode)),"^",4)
    ..If (EndDate+1)>EndDateSetUp Quit
    ..Set MatStartDate=$Piece($Get(^DHCQCLOT(MatCode,LotCode)),"^",3)
    ..Set MatEndDate=$Piece(^DHCQCLOT(MatCode,LotCode),"^",4)
    ..If MatStartDate<=+$h,+$h<=MatEndDate Do
    ...For i=1:1:(+Times) Do
    ....Set QCID=""
    ....If $Data(^DHCQCMQ(MachCode_"||"_MatCode_"||"_LotCode,i)) Do
    .....Set QCID=$Piece($Get(^DHCQCMQ(MachCode_"||"_MatCode_"||"_LotCode,i)),"^",3)
    .....Set LevelNo=$Piece($Get(^DHCQCMQ(MachCode_"||"_MatCode_"||"_LotCode,i)),"^",2)
    .....If LevelNo=Epis Do
    ......Set Ret=QCID
    Quit Ret
}

/// Creator：      DaiYi
/// CreatDate：    20121210
/// Description:： 根据质控物批号查询浓度
/// Table：        DHCQC_Material
/// Input：        MachineCode:仪器代码,MatCode:质控物,LotCode:批号,Epis:编号,EndDate:判断当前批号的结束日期
/// Output：       质控物^
/// Return：       质控编号
/// Others：
/// d ##class(web.DHCQCMaterialQuery).MatLotLevelNo("BSKDXC","BDXC600","1234567",902,"")
ClassMethod MatLotLevelNo(MachineCode As %String, MatCode As %String, LotCode As %String, Epis As %String, EndDate As %String) As %String
{
	New (MachineCode,MatCode,LotCode,Epis,EndDate)
	Set Times="0"
	Set Num=0,StrMatTime="",Ret=""
	Set MachineCode=$Get(MachineCode)
	Set MatCode=$Get(MatCode),LotCode=$Get(LotCode),Epis=$Get(Epis),EndDate=$Get(EndDate)
	If MatCode="" Quit Ret
	If LotCode="" Quit Ret
	If EndDate="" Do 
	.Set EndDate=+$H
	Else  Do
	.Set EndDate=$ZDH(EndDate,3)
	Set Times=$Piece($Get(^DHCQCMAT(MatCode)),"^",8)
    If +Times<1 Quit
    If $Data(^DHCQCLOT(MatCode,LotCode))  Do
    .//非当前批次，不能获取
    .If $Piece($Get(^DHCQCLOT(MatCode,LotCode)),"^",10)'="Y" Quit
    .//是否属于当前的有效范围内
    .Set EndDateSetUp=$Piece($Get(^DHCQCLOT(MatCode,LotCode)),"^",4)
    .If (EndDate+1)>EndDateSetUp Quit
    .Set MatStartDate=$Piece($Get(^DHCQCLOT(MatCode,LotCode)),"^",3)
    .Set MatEndDate=$Piece(^DHCQCLOT(MatCode,LotCode),"^",4)
    .If MatStartDate<=+$h,+$h<=MatEndDate Do
    ..For i=1:1:(+Times) Do
    ...Set QCID=""
    ...If $Data(^DHCQCMQ(MachineCode_"||"_MatCode_"||"_LotCode,i)) Do
    ....Set QCID=$Piece($Get(^DHCQCMQ(MachineCode_"||"_MatCode_"||"_LotCode,i)),"^",3)
    ....Set LevelNo=$Piece($Get(^DHCQCMQ(MachineCode_"||"_MatCode_"||"_LotCode,i)),"^",2)
    ....If QCID=Epis Do
    .....Set Ret=LevelNo
    Quit Ret
}

ClassMethod GetAllByMetClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllByMetExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Query的执行方法
/// d ##class(%ResultSet).RunQuery("web.类名","query名称","参数1","参数2",参数……
/// d ##class(%ResultSet).RunQuery("web.DHCQCMaterialQuery","GetAllByMet","B","ACA530")
ClassMethod GetAllByMetExecute(ByRef qHandle As %Binary, DepCode As %String, MachineCode As %String) As %Status
{
	Set DepCode=$Get(DepCode),MachineCode=$Get(MachineCode)
 	Set repid=$I(^CacheTemp)
	If $Get(ind)="" Set ind=1
	If $Data(^DHCQCMATi("DEP",DepCode,MachineCode)) Do
	.Set MetCode="" For  Set MetCode=$Order(^DHCQCMATi("DEP",DepCode,MachineCode,MetCode)) Quit:MetCode=""  Do
	..If $Data(^DHCQCMAT(MetCode))  Set str=$Get(^DHCQCMAT(MetCode))
	..If $Data(^TMIF(MachineCode)) Set MachineName=$Piece(^TMIF(MachineCode),"\",1)
	..If $Data(^TTAB("DEP",DepCode)) Set DepName=$Piece(^TTAB("DEP",DepCode),"\",1)
	..Set MatDesc=$Piece(str,"^",2)
	..Set Comments=$Piece(str,"^",5)
	..Set WaveLen=$Piece(str,"^",6)
	..Set Visible=$Piece(str,"^",7)
	..Set Levels=$Piece(str,"^",8)
	..Set Autstorage=$Piece(str,"^",9)
	..Set DisplaySeq=$Piece(str,"^",10)
	..//If Visible="N" Quit
	..i Visible="N" s Visible="false"
	..i Visible="Y" s Visible="true"
	..i Autstorage="N" s Autstorage="false"
	..i Autstorage="Y" s Autstorage="true" 
	..Do OutputRow1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRow1
    Set Data=$lb(DepName,MachineName,MetCode,MatDesc,Comments,WaveLen,Visible,Levels,Autstorage,DisplaySeq)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetAllByMetFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAllByMetExecute ]
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

/// Creator：      DaiYi
/// CreatDate：    20101028
/// Description:： 质控物查询
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others：
Query GetAllByMet(DepCode As %String, MachineCode As %String) As %Query(ROWSPEC = "DepartmentName:%String,MachineName:%String,MatCode:%String,MatDesc:%String,Comments:%String,WaveLen:%String,Visible:%String,Levels:%String,Autstorage:%String,DisplaySeq:%String") [ SqlProc ]
{
}

//查询质控物和批次

ClassMethod GetAllMatLotByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Query的执行方法
/// d ##class(%ResultSet).RunQuery("web.类名","query名称","参数1","参数2",参数……
/// d ##class(%ResultSet).RunQuery("web.DHCQCMaterialQuery","GetAllMatLotByDate","A","","2014-4-10","2014-4-10","LABDATA")
ClassMethod GetAllMatLotByDateExecute(ByRef qHandle As %Binary, DepCode As %String, MachCode As %String, StartDate As %String, EndDate As %String, LabNameSpace As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set DepCode=$Get(DepCode),MachCode=$Get(MachCode),StartDate=$Get(StartDate),EndDate=$Get(EndDate)
	Set LabNameSpace=$Get(LabNameSpace)
	If $Get(ind)="" Set ind=1
	Set StartDate=$ZDH(StartDate,3)
	Set EndDate=$ZDH(EndDate,3)
	//质控物
    Set MatCode="" For  Set MatCode=$Order(^DHCQCMAT(MatCode)) Quit:MatCode=""  Do
    .Set MatName=$Piece($Get(^DHCQCMAT(MatCode)),"^",2)
    .Set CurMachCode=$Piece($Get(^DHCQCMAT(MatCode)),"^",3)
    .Set MachName=$Piece($g(^[LabNameSpace]TMIF(CurMachCode)),"\",1)
    .Set CurDaptCode=$Piece($Get(^[LabNameSpace]DHCMachinePara(CurMachCode)),"\",1)
    .If $Length(CurDaptCode),$Length(DepCode),DepCode'=CurDaptCode Quit
    .If $L(MachCode),$L(CurMachCode),CurMachCode'=MachCode Quit
    .//质控批号
    .Set LotCode="" For  Set LotCode=$Order(^DHCQCLOT(MatCode,LotCode)) Quit:LotCode=""  Do
    ..Set LotName=$P($G(^DHCQCLOT(MatCode,LotCode)),"^",12)
    ..//开始日期在结束日期之后，也退出
    ..Set MatStartDate=$Piece($Get(^DHCQCLOT(MatCode,LotCode)),"^",3)
    ..Set MatEndDate=$Piece(^DHCQCLOT(MatCode,LotCode),"^",4)
    ..If EndDate<MatStartDate Quit
    ..If StartDate>MatEndDate Quit
    ..//在通过批次找项目和浓度
    ..Set MatLotRowId=MatCode_"||"_LotCode
    ..Set TcCode="" For  Set TcCode=$Order(^DHCQCTC(MatLotRowId,TcCode)) Quit:TcCode=""  Do
    ...Set TcName=$Piece($Get(^TTAB("TC",TcCode)),"\",1)
    ...Set LevelId="" For  Set LevelId=$Order(^DHCQCTC(MatLotRowId,TcCode,LevelId)) Quit:LevelId=""  Do	
	....Do OutputMachines
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK	
	
OutputMachines
	set Data=$lb(CurMachCode,MachName,MatCode,MatName,LotCode,LotName,TcCode,TcName,LevelId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetAllMatLotByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAllMatLotByDateExecute ]
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
/// CreatDate：    20140410
/// Description:： 查询一段时间内，某科室或仪器所有的质控物和批次
/// Table：        
/// Input：        DepCode:科室代码,MachCode:仪器名称,HospCode:医院代码
/// Output：       仪器集合
/// Return：       0:无,1:有
/// Others：
Query GetAllMatLotByDate(DepCode As %String, MachCode As %String, StartDate As %String, EndDate As %String, LabNameSpace As %String) As %Query(ROWSPEC = "CurMachCode,MachName,MatCode,MatName,LotCode,LotName,TcCode,TcName,LevelId") [ SqlProc ]
{
}

/// Creator：      DaiYi
/// CreatDate：    20150603
/// Description:： 更新批次下除当前批次外所有的批次为非当前批次
/// Table：        DHCQC_Lot
/// Input：        MatCode:质控物代码,LotCode:批次代码
/// Output：       SQLCODE
/// Return：       是否成功
/// Others：
/// w ##class(web.DHCQCMaterialQuery).UpdateCurLot("CA1500","CA1500")
ClassMethod UpdateCurLot(MatCode, LotCode) As %String
{
	Set Num=0
	Set MatCode=$Get(MatCode),LotCode=$g(LotCode)
	i $d(^DHCQCLOT(MatCode)) d
	.s CurLotCode="" f  s CurLotCode=$o(^DHCQCLOT(MatCode,CurLotCode)) q:CurLotCode=""  d
	..i CurLotCode=LotCode q
	..s $p(^DHCQCLOT(MatCode,CurLotCode),"^",10)="N"
	..s Num=Num+1
	q Num
}

}
