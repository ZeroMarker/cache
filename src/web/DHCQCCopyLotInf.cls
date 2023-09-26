/// Creator：      DaiYi
/// CreatDate：    20140621
/// Description:： 复制批次信息
/// Table：        DHCQC_Lot,DHCQC_TestCode
Class web.DHCQCCopyLotInf Extends %Persistent
{

/// Parameter EXTENTSIZE = 250;
/// Creator：      DaiYi
/// CreatDate：    20140621
/// Description:： 复制批次信息,需要使用事务保证数据完整性
/// Table：        DHCQC_Lot,DHCQC_TestCode
/// Input：        MatCode:质控物批次,OldLotCode:复制的批次代码,NewLotCode:新的质控代码 
/// Output：       SQLCODE
/// Return：       0
/// Others：
/// d ##class(web.DHCQCCopyLotInf).CopyLotInf("CA1500","CA1500","C8")
ClassMethod CopyLotInf(MatCode As %String, OldLotCode As %String, NewLotCode As %String) As %String
{
	S MatCode=$g(MatCode),OldLotCode=$g(OldLotCode),NewLotCode=$g(NewLotCode)
	i '$d(^DHCQCLOT(MatCode,OldLotCode)) q "此批次不存在,请重新核对!"
	s StrData=$g(^DHCQCLOT(MatCode,OldLotCode))
	s NewRowId=MatCode_"||"_NewLotCode
	s OldRowId=MatCode_"||"_OldLotCode
	s RetValue=0
	Set $ZTrap = "ErrorHandle"
	TSTART
	//s objQcLot=##class(lab.DHCQCLot).%New()
	//s objQcLot.DQCLParRef=MatCode
	//s objQcLot.DQCLOrder=NewLotCode
	//s objQcLot.DQCLLotDesc=NewLotCode
	//s objQcLot.DQCLStartDate=$p(StrData,"^",3)
	//s objQcLot.DQCLEndDate=$p(StrData,"^",4)
	//s objQcLot.DQCLProductDate=$p(StrData,"^",5)
	//s objQcLot.DQCLExpiryDate=$p(StrData,"^",6)
	//s objQcLot.DQCLComments=$p(StrData,"^",7)
	//s objQcLot.DQCLVisible=$p(StrData,"^",8)
	//s objQcLot.DQCLProductDr=$p(StrData,"^",9)
	//s objQcLot.DQCLCurLot=$p(StrData,"^",10)
	//s objQcLot.DQCITime=$p(StrData,"^",11)
	//s objQcLot.DTCLAlias=$p(StrData,"^",12)
	//s err=objQcLot.%Save()
	k PLIST
	s PLIST(2)=MatCode,PLIST(3)=NewLotCode,PLIST(4)=NewLotCode,PLIST(5)=$p(StrData,"^",3)
	s PLIST(6)=$p(StrData,"^",4),PLIST(7)=$p(StrData,"^",5),PLIST(8)=$p(StrData,"^",6),PLIST(9)=$p(StrData,"^",7)
	s PLIST(10)=$p(StrData,"^",8),PLIST(11)=$p(StrData,"^",9),PLIST(12)=$p(StrData,"^",10),PLIST(13)=$p(StrData,"^",11)
	S PLIST(14)=$p(StrData,"^",12)
	&SQL(Insert Into lab.DHCQC_Lot Values :PLIST())
	i SQLCODE=0 d
	.If $D(^DHCQCTC(OldRowId)) d
	..s TcCode="" f  s TcCode=$o(^DHCQCTC(OldRowId,TcCode)) q:TcCode=""  d
	...s LevelNo="" f  s LevelNo=$o(^DHCQCTC(OldRowId,TcCode,LevelNo)) q:LevelNo=""  d
	....s StrData=$g(^DHCQCTC(OldRowId,TcCode,LevelNo))
	....s PLIST(2)=NewRowId,PLIST(3)=TcCode,PLIST(4)=$p(StrData,"^",2),PLIST(5)=$p(StrData,"^",3)
	....s PLIST(6)=$p(StrData,"^",4),PLIST(7)=$p(StrData,"^",5),PLIST(8)=$p(StrData,"^",6),PLIST(9)=$p(StrData,"^",7)
	....s PLIST(10)=$p(StrData,"^",8),PLIST(11)="",PLIST(12)="",PLIST(13)=""
	....s PLIST(14)=$p(StrData,"^",12),PLIST(15)="",PLIST(16)="",PLIST(17)=""
	....s PLIST(18)=""
	....&SQL(Insert Into lab.DHCQC_TestCode Values :PLIST())
	....b ;232
	....i SQLCODE=0 s ret="0^复制成功"
	....e  d ErrorHandle  
	e  TROLLBACK  s ret="-1^参数错误,保存失败！错误代码为："_SQLCODE q ret
	i RetValue=1 TROLLBACK  q ret
	TCOMMIT
	q ret
	
	//保存项目激活信息和相关参数
	//i $e(err)'=0 d
	//.If $D(^DHCQCTC(OldRowId)) d
	//..s TcCode="" f  s TcCode=$o(^DHCQCTC(OldRowId,TcCode)) q:TcCode=""  d
	//...s LevelNo="" f  s LevelNo=$o(^DHCQCTC(OldRowId,TcCode,LevelNo)) q:LevelNo=""  d
	//....s StrData=$g(^DHCQCTC(OldRowId,TcCode,LevelNo))
	//....s objTC=##class(lab.DHCQCTestCode).%New()
	//....s objTC.DQCIParRef=NewRowId
	//....s objTC.DQCITestCodeDR=TcCode
	//....s objTC.DQCIDilutes=$p(StrData,"^",2)
	//....s objTC.DQCIVisible=$p(StrData,"^",3)
	//....s objTC.DQCIDisplaySequence=$p(StrData,"^",4)
	//....s objTC.DTCLTargetDesc=$p(StrData,"^",5)
	//....s objTC.DTCLTargetValue=$p(StrData,"^",6)
	//....s objTC.DTCLTargetSD=$p(StrData,"^",7)
	//....s objTC.DTCLDecimal=$p(StrData,"^",8)
	//....s objTC.DTCLCALCMean=""
	//....s objTC.DTCLCALCSD=""
	//....s objTC.DQCICalcCV=""
	//....s objTC.DTCLMeanType=$p(StrData,"^",12)
	//....s objTC.DQCIComments=""
	//....s objTC.DTATACTCSum=""
	//....s objTC.DTATACTCMean=""
	//....s objTC.DTATACSD=""
	//....s err=objTC.%Save()
	//....i $e(err)'=0 s ret="0^复制成功"
	//....e  d ErrorHandle  
	//e  TROLLBACK  s ret="-1^参数错误,保存失败！"_$SYSTEM.Status.GetErrorText(err) q ret
	//i RetValue=1 TROLLBACK  q ret
	//TCOMMIT
	//q ret
	
ErrorHandle
    s RetValue=1
	TROLLBACK
	s ret="-1^参数错误,保存失败！错误代码为："_SQLCODE_"!"_$SYSTEM.Status.GetErrorText(err)
    Quit ret
}

/// Creator：      DaiYi
/// CreatDate：    20140621
/// Description:： 复制批次信息,需要使用事务保证数据完整性
/// Table：        DHCQC_Lot,DHCQC_TestCode
/// Input：        MatCode:质控物批次,OldLotCode:复制的批次代码,NewLotCode:新的质控代码 
/// Output：       SQLCODE
/// Return：       0
/// Others：
/// d ##class(web.DHCQCCopyLotInf).UpdateLotInf("1||2||A0010||2","123","213","","","","","")
ClassMethod UpdateLotInf(RowId As %String, Dilutes As %String, TargetDesc As %String, TargetValue As %Float, TargetSD As %Float, Decimal As %Float, MeanType As %String, Comments As %String) As %String
{
	s ret=100
	s objLotTC=##class(lab.DHCQCTestCode).%OpenId(RowId)
	s objLotTC.DQCIDilutes=Dilutes
	s objLotTC.DTCLTargetDesc=TargetDesc
	s objLotTC.DTCLTargetValue=TargetValue
	s objLotTC.DTCLTargetSD=TargetSD
	s objLotTC.DTCLDecimal=Decimal
	s objLotTC.DTCLCALCMean=MeanType
	s objLotTC.DQCIComments=Comments
	s err=objLotTC.%Save()
    i err'="0" s ret=$SYSTEM.Status.GetErrorText(err)
    e  s ret=$SYSTEM.Status.GetErrorText(err)
	q ret
}

ClassMethod UpdateItemValue()
{
	//&sql(Update lab.DHCQC_ItemValue set DQIV_TestResult=11.28 where DHCQC_RowID='AC1500||61381||9001||A1130||1||61381||1')
	&sql(Update lab.DHCQC_ItemValue set DQIV_TestResult=11.28 where DQIV_ParRef='AC1500||61381||9001||A1130||1') 
	B ;1
	//q SQLCODE
	
	s ret=100
	S RowId="AC1500||61381||9001||A1130||1||61381||1"
	s objLotTC=##class(lab.DHCQCItemValue).%OpenId(RowId)
	B ;12
	s objLotTC.DQIVTestResult="11.28"
	B ;11
	s err=objLotTC.%Save()
    i err'="0" s ret=$SYSTEM.Status.GetErrorText(err)_"!"_$SYSTEM.Status.GetErrorText(err)
    e  s ret=$SYSTEM.Status.GetErrorText(err)_"!"_$SYSTEM.Status.GetErrorText(err)
    B ;23
	q ret
}

Storage Default
{
<Data name="DHCQCCopyLotInfDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCQCCopyLotInfD</DataLocation>
<DefaultData>DHCQCCopyLotInfDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCQCCopyLotInfD</IdLocation>
<IndexLocation>^web.DHCQCCopyLotInfI</IndexLocation>
<StreamLocation>^web.DHCQCCopyLotInfS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
