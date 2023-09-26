Class web.DHCQCCreatData Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// Creator：      DaiYi
/// CreatDate：    20110524
/// Description:： 手工导入数据
/// Table：        DHCQC_TmpResult
/// Input：        仪器结果 
/// Output：       仪器结果。
/// Return：       0
/// Others：
/// d ##class(web.DHCQCCreatData).AddMachineQCData()
ClassMethod AddMachineQCData() As %String
{
	//Set MachineCode="ACA530",QcDate=$Piece($H,",",1),QcTime=$Piece($H,",",2)-100
	//Set CurDate=$Piece($H,",",1),CurTime=$Piece($H,",",2)
	//Set SampleID="QC1",DisplaySequence="1",QcTestCode="A0510",TestValue=4.35,TestFlag="*"
	Set MachineCode=PLIST(1)
	Set QcDate=PLIST(2)
	Set QcTime=PLIST(3)
	Set CurDate=$Piece($H,",",1),CurTime=$Piece($H,",",2)
	Set SampleID=PLIST(4)
	Set DisplaySequence=PLIST(5)
	Set QcTestCode=PLIST(6)
	Set QcTestCode=PLIST(7)
	Set TestFlag=PLIST(8)
	If SampleID="" Quit 0
	//If $Data(^DHCQCTR(MachineCode,QcDate,SampleID,QcTestCode,DisplaySequence)) Do
	//.&sql(update lab.DHCQC_TmpResult set DQCT_Machine_DR=:MachineCode,DQCT_Date=:QcDate,Visible=:Active where ID=:id)
	//.Else  Do
	&sql(insert into lab.DHCQC_TmpResult(DQCT_Machine_DR,DQCT_Date,DQCT_Time,DQCT_CurDate,DQCT_CurTime,DQCT_SampleID,DQCI_DisplaySequence,DQCI_TestCode_DR,DQIV_TestValue,DQIV_TestFlag) 
	values(:MachineCode,:QcDate,:QcTime,:CurDate,:CurTime,:SampleID,:DisplaySequence,:QcTestCode,:TestValue,:TestFlag))
	Quit "0"
}

/// Creator：      DaiYi
/// CreatDate：    20110530
/// Description:： 取系统的日期和时间
/// Table：        无
/// Input：        无 
/// Output：       日期和时间：2011-05-30 09:30:30
/// Return：       日期和时间
/// Others：
/// d ##class(web.DHCQCCreatData).QuerySerDateTime()
ClassMethod QuerySerDateTime() As %String
{
     Set ServerDate=$ZD($Piece($H,",",1),3)
     Set ServerTime=$ZT($Piece($H,",",2))
     Quit:ServerDate_" "_ServerTime
}

/// Creator：      DaiYi
/// CreatDate：    20110530
/// Description:： 取系统的日期
/// Table：        无
/// Input：        无 
/// Output：       日期：2011-05-30
/// Return：       日期
/// Others：
/// d ##class(web.DHCQCCreatData).QuerySerDate()
ClassMethod QuerySerDate() As %String
{
     Set ServerDate=$ZD($Piece($H,",",1),3)
     Quit:ServerDate
}

/// Creator：      DaiYi
/// CreatDate：    20110530
/// Description:： 取系统的时间
/// Table：        无
/// Input：        无 
/// Output：       时间：09:30:30
/// Return：       时间
/// Others：
/// d ##class(web.DHCQCCreatData).QuerySerTime()
ClassMethod QuerySerTime() As %String
{
     Set ServerTime=$ZT($Piece($H,",",2))
     Quit:ServerTime
}

/// Creator：      DaiYi
/// CreatDate：    20130301
/// Description:： 手工生成索引数据
/// Table：        DHCQC_itemvalue
/// Input：        ""
/// Output：       ""
/// Return：       0
/// Others：
/// d ##class(web.DHCQCCreatData).AddIndexForItemValue()
ClassMethod AddIndexForItemValue() As %String
{
	Set Num=0
	Set MachinCode="" For  Set MachinCode=$Order(^DHCQCIVi(MachinCode)) Quit:MachinCode=""  Do
	.Set MachDate="" For  Set MachDate=$Order(^DHCQCIVi(MachinCode,MachDate)) Quit:MachDate=""  Do
	..Set LevelNo="" For  Set LevelNo=$Order(^DHCQCIVi(MachinCode,MachDate,LevelNo)) Quit:LevelNo=""  Do
	...Set TCCode="" For  Set TCCode=$Order(^DHCQCIVi(MachinCode,MachDate,LevelNo,TCCode)) Quit:TCCode=""  Do
	....Set QCOrdId="" For  Set QCOrdId=$Order(^DHCQCIVi(MachinCode,MachDate,LevelNo,TCCode,QCOrdId)) Quit:QCOrdId=""  Do
	.....Set RowId="" For  Set RowId=$Order(^DHCQCIVi(MachinCode,MachDate,LevelNo,TCCode,QCOrdId,RowId)) Quit:RowId=""  Do
	......Set CurDate="" For  Set CurDate=$Order(^DHCQCIVi(MachinCode,MachDate,LevelNo,TCCode,QCOrdId,RowId,CurDate)) Quit:CurDate=""  Do
	.......Set OrdId="" For  Set OrdId=$Order(^DHCQCIVi(MachinCode,MachDate,LevelNo,TCCode,QCOrdId,RowId,CurDate,OrdId)) Quit:OrdId=""  Do
	........Set ^DHCQCIVTCi(MachinCode,TCCode,MachDate,LevelNo,QCOrdId,RowId,CurDate,OrdId)=""
	........Set Num=Num+1
	b ;123
	Quit Num
}

Storage Default
{
<Data name="DHCQCCreatDataDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCQCCreatDataD</DataLocation>
<DefaultData>DHCQCCreatDataDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCQCCreatDataD</IdLocation>
<IndexLocation>^web.DHCQCCreatDataI</IndexLocation>
<StreamLocation>^web.DHCQCCreatDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
