Class web.DHCQCLotInformation Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// Creator：      DaiYi
/// CreatDate：    20120720
/// Description:： 查询项目类型
/// Table：        CT_TestCode
/// Input：        TCCode:项目代码
/// Output：       日期及结果
/// Return：       结果字符串
/// Others：       日期^结果|
/// d ##class(web.DHCQCLotInformation).QueryTestCodeType("A0340")
ClassMethod QueryTestCodeType(TCCode As %String) As %String
{
	Set TCCode=$Get(TCCode)
	Set Ret=""
	If '$Length(TCCode) Quit Ret
	Set Ret=$E($Piece($Get(^TTAB("TC",TCCode)),"\",3),1)
	Quit Ret
}

/// Creator：      DaiYi
/// CreatDate：    20120330
/// Description:： 查询批号信息
/// Table：        DHCQC_TestCode:质控项目设置,CT_TestCode:项目表,DHCQC_TCMethod:项目使用方法
/// Input：        MatCode:质控物,LotCode:质控批号,TCCode:项目代码,LevelNo:浓度
/// Output：       仪器结果。  数据特殊处理。方便前台处理。需要改为其他方法。
/// Return：       0
/// Others：       修改记录：增加仪器唯一编码号。根据15189认证，每个仪器按照要求增加一个唯一标示。
/// w ##class(web.DHCQCLotInformation).QueryLotInfmation("CA1500","CA1500","A1130","2","2015-3-1","2015-3-31")
ClassMethod QueryLotInfmation(MatCode As %String, LotCode As %String, TCCode As %String, LevelNo As %String, StartDate As %String, EndDate As %String) As %String
{
  //Set MatCode="BBioRad",LotCode="1",TCCode="B2570",LevelNo="1"
  Set MatCode=$Get(MatCode),TCCode=$Get(TCCode),LevelNo=$Get(LevelNo),StartDate=$Get(StartDate),EndDate=$Get(EndDate)
  Set Ret=""
  Set QCDate=StartDate
  If LotCode="" Quit 0
  If TCCode="" Quit 1
  //取校正液批号，失效日期，实验方法,质控规则,设定和计算靶值等信息。
  Set LevelNum=0,TCName="",MachineCodeId="",MatName=""
  //增加批次名称
  s LotName=""
  If LevelNo="" Set LevelNo=1
  Set StartDate=$ZDH(StartDate,3),EndDate=$ZDH(EndDate,3)
  If $Data(^DHCQCMAT(MatCode)) Do
  .Set LevelNum=$Piece(^DHCQCMAT(MatCode),"^",8)
  .Set MachineCodeId=$Piece(^DHCQCMAT(MatCode),"^",5)
  .s MachineCode=$Piece(^DHCQCMAT(MatCode),"^",3)
  .s MatName=$Piece($g(^DHCQCMAT(MatCode)),"^",2)
  If $Data(^DHCQCLOT(MatCode,LotCode)) Do
  .Set LotStr=$Get(^DHCQCLOT(MatCode,LotCode))
  .Set AmendId=$Piece(LotStr,"^",7)
  .Set LoseDate=$ZD($Piece(LotStr,"^",6),3)
  .s LotName=$Piece(LotStr,"^",12)
  .//试剂批次选择
  .Set ReagLotNo=$p($Piece(LotStr,"^",9),$C(13))
  .//实验方法查询
  .Set RuleName=""
  .If $Data(^DHCQCMATRL(MatCode)) Do
  ..Set RuleCode="" For  Set RuleCode=$Order(^DHCQCMATRL(MatCode,RuleCode)) Quit:RuleCode=""  Do
  ...Set CurRuleName=$Piece($Get(^DHCQCRL(RuleCode)),"^",2)
  ...//禁止规则不显示
  ...i $Piece($Get(^DHCQCMATRL(MatCode,RuleCode)),"^",1)="Disable" q
  ...If RuleName="" Set RuleName=CurRuleName
  ...Else  Set RuleName=RuleName_","_CurRuleName
  .//实验方法
  .Set TCUnit=$Piece($Get(^TTAB("TC",TCCode)),"\",2)
  .Set TCName=$Piece($Get(^TTAB("TC",TCCode)),"\",1)
  .Set TCMethodCode=$Piece($Get(^TTAB("TC",TCCode)),"\",11)
  .Set TCMethodName=""
  .s TCMethodName=##class(web.DHCQCLotInformation).QueryMethod(TCCode,MachineCode,StartDate)
  .If (TCMethodCode'=""),'$l(TCMethodName) Set TCMethodName=$Get(^TTAB("METHOD",TCMethodCode))
  .//项目设定值与计算值
  .Set TCSetUpStr=""
  .For Num=0:1:LevelNum Do
  ..If LevelNo'=Num Quit
  ..Set TCSetUpStr=TCSetUpStr_"||||||^" 
  .Set ParRef=MatCode_"||"_LotCode
  .If $Data(^DHCQCTC(ParRef,TCCode)) Do
  ..Set TCSetUpStr=""
  ..Set CurLev="" For  Set CurLev=$Order(^DHCQCTC(ParRef,TCCode,CurLev)) Quit:CurLev=""  Do
  ...//If LevelNo'=CurLev Quit
  ...Set CurData=$Get(^DHCQCTC(ParRef,TCCode,CurLev))
  ...s LotNameLevel=$p(CurData,"^",5)
  ...i LotNameLevel="" s LotNameLevel=LotName
  ...s SetUpXString=##class(web.DHCQCMachineDataView).QuerySetUpXSD(ParRef,TCCode,CurLev, StartDate)
  ...Set CalDecimal=+$Tr($Piece(CurData,"^",8)," ")
  ...If CalDecimal="" Set CalDecimal=2
  ...Set SetUpX=$p(SetUpXString,"^",1)   //$Tr($Fn(+$Piece(CurData,"^",6),",",CalDecimal),",")
  ...Set CurSetUpX=SetUpX
  ...Set SetUpSD=$p(SetUpXString,"^",2)   //$Tr($Fn(+$Piece(CurData,"^",7),",",CalDecimal),",")
  ...Set CurSetUpSD=SetUpSD
  ...i SetUpSD="0"||SetUpSD="" s SetUpSD=0.0000001
  ...Set SetUpCV=0.0000001,CurSetUpCV=0.0000001
  ...If +SetUpX'=0 Set SetUpCV=$p(SetUpXString,"^",6)   //$Fn((SetUpSD/SetUpX)*100,",",CalDecimal)
  ...Set CurSetUpCV=SetUpCV
  ...//计算的靶值标准差 DaiYi 不取之前的设置靶值标准差的值。
  ...Set CalStr=..CalTCStatXSD(MatCode,LotCode,TCCode,CurLev,StartDate,EndDate)
  ...Set CalX=$Piece(CalStr,"^",1),CalSD=$Piece(CalStr,"^",2),CalCV=$Piece(CalStr,"^",3)
  ...//当前批次所有值的计算靶值标准差 DaiYi 2015-04-10 
  ...//Set CalX=$Fn($Piece(CurData,"^",9),",",CalDecimal) 
  ...//s CalX=$Piece(CurData,"^",9)
  ...//If CalX="0" Set CalX=0.0000001
  ...//i CalX'=".0000001" Set CalX=$Fn(CalX,"",CalDecimal)
  ...//Set CalSD=$Fn($Piece(CurData,"^",10),",",CalDecimal) //当前批次所有值的计算靶值标准差
  ...//s CalSD=$Piece(CurData,"^",10)
  ...//If CalSD="0" Set CalSD=0.0000001
  ...//i CalSD'=".0000001" Set CalSD=$Fn(CalSD,"",CalDecimal)
  ...//s CalCV="0.000001"
  ...//s CalCV=$Piece(CurData,"^",11)                    //当前批次所有值的计算靶值标准差
  ...//If CalCV="0" Set CalCV=0.0000001
  ...//If CalX'=".0000001" Set CalX=$Fn(CalX,"",CalDecimal)
  ...//If CalSD'=".0000001" Set CalSD=$Fn(CalSD,"",CalDecimal)
  ...//If CalCV'=".0000001" Set CalCV=$Fn(CalCV,"",CalDecimal)
  ...Set XSDFlag="N"
  ...Set XSDFlag=$Piece(CurData,"^",12)
  ...If XSDFlag="Y" Do
  ....Set SetUpX=CalX
  ....Set SetUpSD=CalSD
  ....Set SetUpCV=CalCV
  ...//DaiYi 2013-05-30 增加按照月份计算靶值,标准差绘图.
  ...Set MouthXSDFlag=$Piece(CurData,"^",13)
  ...If MouthXSDFlag="Y",$Length(QCDate)>0 Do
  ....Set AccRowId=ParRef_"||"_TCCode_"||"_CurLev
  ....Set AccYear=$Piece(QCDate,"-",1)
  ....Set AccMouth=$Piece(QCDate,"-",2),SetUpCV=""
  ....Set AccMouthRet=##class(web.DHCQCLotInformation).QueryAccXSD(AccRowId,AccYear,AccMouth)
  ....Set SetUpX=$Piece(AccMouthRet,"^",1)
  ....s CurSetUpX=SetUpX
  ....Set SetUpSD=$Piece(AccMouthRet,"^",2),CurSetUpSD=SetUpSD,SetUpCV=0.0000001
  ....i SetUpX'=0.0000001 Set SetUpCV=+$tr($Fn((SetUpSD/SetUpX)*100,",",CalDecimal),","),CurSetUpCV=SetUpCV
  ...Set TCSetUpStr=TCSetUpStr_SetUpX_"|"_SetUpSD_"|"_SetUpCV_"|"_CalX_"|"_CalSD_"|"_CalCV_"|"_XSDFlag_"|"_CurSetUpX_"|"_CurSetUpSD_"|"_CurSetUpCV_"|"_LotNameLevel_"^"
  
  Set MatCode=""
  //试剂批次使用MatCode传出。
  Set MatCode=ReagLotNo
  If TCName'="" Do
  .Set Ret=MatCode_"^"_TCName_"^"_AmendId_"^"_LoseDate_"^"_RuleName_"^"_TCUnit_"^"_TCMethodName_"^"_MachineCodeId_"^"_TCSetUpStr
  Else  Do  Set Ret=MatCode_"^^^^^^^^||||||^"
  Quit Ret
}

/// Creator：      DaiYi
/// CreatDate：    20130530
/// Description:： 按照日期查询当月或者上个月的计算值
/// Table：        lab.DHCQC_AccTotal
/// Input：        RowId:,QCYear:年,QCMouth:月
/// Output：       日期及结果
/// Return：       结果字符串
/// Others：       日期^结果|
/// d ##class(web.DHCQCLotInformation).QueryAccXSD("ABC-5180||09120752||A2010||1","2013","5")
ClassMethod QueryAccXSD(RowId As %String, QCYear As %String, QCMouth As %String) As %String
{
	Set RowId=$Get(RowId),QCYear=$Get(QCYear),QCMouth=$Get(QCMouth)
	Set AccRet="^^"
	Set CurQCYear=QCYear,CurQCMouth=""
	//使用上一个月的靶值,标准差
	If QCMouth=1 Do
	.Set CurQCMouth=12,CurQCYear=CurQCYear-1
	Else  Do
	.Set CurQCMouth=QCMouth-1,CurQCYear=QCYear
	If $Data(^DHCQCAT(RowId,CurQCYear,CurQCMouth)) Do
	.Set StrAccData=$Get(^DHCQCAT(RowId,CurQCYear,CurQCMouth))
	.i $Piece(StrAccData,"^",4)'="" Set AccRet=$Piece(StrAccData,"^",4)_"^"_$Piece(StrAccData,"^",5)
	.e  s AccRet=0.0000001_"^"_0.0000001
	Else  Do
	.Set StrAccData=$Get(^DHCQCAT(RowId,QCYear,QCMouth))
	.i $Piece(StrAccData,"^",4)'="" Set AccRet=$Piece(StrAccData,"^",4)_"^"_$Piece(StrAccData,"^",5)
	.e  s AccRet=0.0000001_"^"_0.0000001
	Quit AccRet
}

/// Creator：      DaiYi
/// CreatDate：    20131119
/// Description:： 计算一段时间内批次质控物的靶值标准差
/// Table：        DHCQC_TestCode:质控项目,CT_TestCode:项目表,DHCQC_MachineQC:质控连接,DHCQC_ItemValue:质控项目结果
/// Input：        MatCode:质控物,LotCode:质控批号,TCCode:项目代码,epis:流水号,StartDate:开始日期，EndDate:结束日期
/// Output：       质控物的靶值标准差.
/// Return：       
/// Others：       
/// d ##class(web.DHCQCSTATTCXSD).CalTCStatXSD("ACA5301","548136","A0490","1","2013-02-1")
ClassMethod CalTCStatXSD(MatCode As %String, LotCode As %String, TCCode As %String, epis As %String, StartDate As %String, EndDate As %String) As %String
{
  Set MatCode=$Get(MatCode),LotCode=$Get(LotCode),StartDate=$Get(StartDate),EndDate=$Get(EndDate)
  Set TCCode=$Get(TCCode),epis=$Get(epis)
  Set Ret=""
  If MatCode="" Quit ""
  If LotCode="" Quit ""
  If TCCode="" Quit ""
  If epis="" Quit ""
  Set MachineCode=$Piece($Get(^DHCQCMAT(MatCode)),"^",3)
  If MachineCode="" Quit ""
  Kill ^TMP("TCSTATXSD",$Job)
  //批号使用日期判断
  Set (LotStartDate,LotEndDate,CurLotFlag)=""
  If $Data(^DHCQCLOT(MatCode,LotCode)) Do
  .Set str=$Get(^DHCQCLOT(MatCode,LotCode))
  .Set CurLotFlag=$Piece($Get(^DHCQCLOT(MatCode,LotCode)),"^",10)
  //取此项目的小数点位
  Set MatLotRowId=MatCode_"||"_LotCode
  Set TCLevel=epis
  If $Data(^DHCQCTC(MatLotRowId,TCCode,TCLevel)) Do
  .Set TCDecimal=$Piece($Get(^DHCQCTC(MatLotRowId,TCCode,TCLevel)),"^",8)
  //项目结果之和,SD定义。
  Set TCTotalResult=0,TCCALResult=0,TCCALSD="",TCCALCV="",TCNum=0
  //查询当前批号内的数据。由于没有保存批号和质控物到业务表。只能通过条件判断。
  If $Data(^DHCQCIVi(MachineCode)) Do
  .Set CurDate="" For  Set CurDate=$Order(^DHCQCIVi(MachineCode,CurDate)) Quit:CurDate=""  Do
  ..If CurDate<StartDate Quit
  ..If CurDate>EndDate Quit 
  ..Set CurEpis="" For  Set CurEpis=$Order(^DHCQCIVi(MachineCode,CurDate,CurEpis)) Quit:CurEpis=""  Do
  ...Set CurTCCode="" For  Set CurTCCode=$Order(^DHCQCIVi(MachineCode,CurDate,CurEpis,CurTCCode)) Quit:CurTCCode=""  Do
  ....If CurTCCode'=TCCode Quit 
  ....Set OrdId="" For  Set OrdId=$Order(^DHCQCIVi(MachineCode,CurDate,CurEpis,CurTCCode,OrdId)) Quit:OrdId=""  Do
  .....Set RowId="" For  Set RowId=$Order(^DHCQCIVi(MachineCode,CurDate,CurEpis,CurTCCode,OrdId,RowId)) Quit:RowId=""  Do
  ......Set OrdData=$Get(^DHCQCIV(RowId,CurDate,OrdId))
  ......Set TCResult=$tR($Piece(OrdData,"^",3),",")
  ......Set ParRef=$Piece(OrdData,"^",6)
  ......Set TestRemoveData=$Piece($Get(OrdData),"^",12)
  ......If TestRemoveData=2 Quit
  ......If $Length(MatCode),MatCode'=$Piece(ParRef,"||",1) Quit
  ......If $Length(LotCode),LotCode'=$Piece(ParRef,"||",2) Quit
  ......If $Length(TCLevel),TCLevel'=$Piece(ParRef,"||",3) Quit
  ......Set TCTotalResult=TCTotalResult+TCResult
  ......Set TCNum=TCNum+1
  ......Set ^TMP("TCSTATXSD",$Job,TCCode,TCNum)=TCResult
  Set TCCALResult="0.0000001",TCCALSD="0.0000001",TCCALCV="0.0000001"
  If TCNum>1 Do
  .Set TCCALResult=$Tr($FNUMBER(TCTotalResult/TCNum,"",TCDecimal),",")
  .Set TCEquData=0
  .//计算SD
  .Set CurNum="" For  Set CurNum=$Order(^TMP("TCSTATXSD",$Job,TCCode,CurNum)) Quit:CurNum=""  Do
  ..Set CurResult=$tR($Get(^TMP("TCSTATXSD",$Job,TCCode,CurNum)),",")
  ..Set TCEquData=TCEquData+((TCCALResult-CurResult)*(TCCALResult-CurResult))
  .Set TCCALSD=$FNUMBER($ZSQR(TCEquData/(TCNum-1)),"",TCDecimal)
  .If TCCALResult>0 Set TCCALCV=$FNUMBER((TCCALSD/TCCALResult)*100,",",TCDecimal)
  Kill ^TMP("TCSTATXSD",$Job)
  Set Ret=$Tr(TCCALResult,",")_"^"_$Tr(TCCALSD,",")_"^"_TCCALCV
  Quit Ret
}

/// Creator：      DaiYi
/// CreatDate：    20120530
/// Description:： 按照日期查询结果
/// Table：        DHCQC_ItemValue:质控项目结果,CT_TestCode:项目表,DHCQC_TCMethod:项目使用方法
/// Input：        StartDate:开始日期,EndDate:结束日期,MatCode:质控物,LotCode:质控批号,TCCode:项目代码,LevelNo:浓度
/// Output：       日期及结果
/// Return：       结果字符串
/// Others：       日期^结果|
/// d ##class(web.DHCQCLotInformation).QueryQCDateResult("BSKBIO","2013-01-01","2013-01-13","B2570","1")
ClassMethod QueryQCDateResult(MatCode As %String, StartDate As %String, EndDate As %String, TCCode As %String, LevelNo As %String) As %String
{
  Set MatCode=$Get(MatCode),StartDate=$Get(StartDate),EndDate=$Get(EndDate)
  Set TCCode=$Get(TCCode),LevelNo=$Get(LevelNo)
  Set StartDate=$ZDH(StartDate,3),EndDate=$ZDH(EndDate,3)
  Set Ret=""
  If MatCode="" Quit 0
  If TCCode="" Quit 1
  Set LevelNum=0
  Set Num=0
  If $Data(^DHCQCIVi(MatCode)) Do
  .For CurDate=StartDate:1:EndDate Do
  ..Set Num=Num+1
  ..Set RetValue(Num)=$ZD(CurDate,3)_"!"
  ..If $Data(^DHCQCIVi(MatCode,CurDate)) Do
  ...Set QCId="" For  Set QCId=$Order(^DHCQCIVi(MatCode,CurDate,QCId)) Quit:QCId=""  Do
  ....//If $Length(LevelNo),LevelNo'[QCId Quit
  ....Set Ret=##class(web.DHCQCMaterialQuery).MachineLevelNo(MatCode,QCId,$ZD(CurDate,3))
  ....If Ret="" Quit
  ....If LevelNo'[Ret Quit
  ....Set CurTCCode="" For  Set CurTCCode=$Order(^DHCQCIVi(MatCode,CurDate,QCId,CurTCCode)) Quit:CurTCCode=""  Do
  .....If CurTCCode'=TCCode Quit
  .....Set QCCount="" For  Set QCCount=$Order(^DHCQCIVi(MatCode,CurDate,QCId,CurTCCode,QCCount)) Quit:QCCount=""  Do
  ......Set RowId=$Order(^DHCQCIVi(MatCode,CurDate,QCId,CurTCCode,QCCount,""))
  ......Set ResultByDate=$Piece(^DHCQCIV(RowId,CurDate,QCCount),"^",3)
  ......Set ResultByEnter=$Piece(^DHCQCIV(RowId,CurDate,QCCount),"^",10)
  ......//_"@"_ResultByEnter_
  ......Set RetValue(Num)=RetValue(Num)_ResultByDate_"|"
  ..Else  Do 
  ...Set RetValue(Num)=RetValue(Num)_"|"
  Set Ret=""
  For iNum=1:1:Num Do
  .Set Ret=Ret_RetValue(iNum)_"^"
  Quit Ret
}

/// Creator：      DaiYi
/// CreatDate：    20130314
/// Description:： 返回LJ图日期数组
/// Table：        
/// Input：        TCCode:项目代码,Type:2
/// Output：       日期天数
/// Return：       
/// Others：       不是在一个进程执行,进程号变了
/// d ##class(web.DHCQCLotInformation).QueryResultOrderByLJ("2")
ClassMethod QueryResultOrderByLJ(TCCode, Type) As %String
{
	Set Ret=$Get(^DHCQCNum(TCCode,Type))
	Kill ^DHCQCNum(TCCode,Type)
	Quit Ret
}

/// Creator：      DaiYi
/// CreatDate：    20120530
/// Description:： L-J图按照日期查询结果
/// Table：        DHCQC_ItemValue:质控项目结果,CT_TestCode:项目表,DHCQC_TCMethod:项目使用方法
/// Input：        StartDate:开始日期,EndDate:结束日期,MatCode:质控物,LotCode:质控批号,TCCode:项目代码,LevelNo:浓度,PointType:点类型,PointRange:点范围,PointY:纵向点类型
/// Output：       日期及结果
/// Return：       结果字符串
/// Others：       日期^结果|
/// d ##class(web.DHCQCLotInformation).QueryResultByEnterPerson("AHL750","AHL750","886000","2013-7-1","2013-7-31","A0020","2","3","1","1","^A^B^C")
ClassMethod QueryResultByEnterPerson(MachineCode As %String, MatCode As %String, LotCode As %String, StartDate As %String, EndDate As %String, TCCode As %String, LevelNo As %String, PointType As %String, PointRange As %String, PointY As %String, RuleCode As %String) As %String
{
  Set MachineCode=$Get(MachineCode),MatCode=$Get(MatCode),StartDate=$Get(StartDate),EndDate=$Get(EndDate)
  Set TCCode=$Get(TCCode),LevelNo=$Get(LevelNo)
  Set StartDate=$ZDH(StartDate,3),EndDate=$ZDH(EndDate,3)
  Set PointType=$Get(PointType),PointRange=$Get(PointRange),PointY=$Get(PointY)
  Set Ret=""
  If MachineCode="" Quit 0
  If MatCode="" Quit 0
  If TCCode="" Quit 1
  Kill ^LJRetValue
  Set LevelNum=0
  Set Num=0
  Set ResultFlag=0,PointNum=0
  Kill ^DHCQCNum($Job,2),RetValue
  If PointY=1 Do
  .If $Data(^DHCQCIVi(MachineCode)) Do
  ..For CurDate=StartDate:1:EndDate Do
  ...//增加取日期判断。
  ...If EndDate-StartDate>40 Set ^DHCQCNum(TCCode,2)=$Get(^DHCQCNum(TCCode,2))_$Piece($ZD(CurDate,3),"-",2,3)_"!"
  ...If EndDate-StartDate<41 Set ^DHCQCNum(TCCode,2)=$Get(^DHCQCNum(TCCode,2))_$Piece($ZD(CurDate,3),"-",3)_"!"
  ...If $Data(^DHCQCIVi(MachineCode,CurDate)) Do
  ....Set Num=0
  ....If ResultFlag=Num,ResultFlag'=0 Set Num=Num+1
  ....Set ^LJRetValue(CurDate,Num)=$ZD(CurDate,3)_"!"_"@@@@@@|"
  ....Set QCId="" For  Set QCId=$Order(^DHCQCIVi(MachineCode,CurDate,QCId)) Quit:QCId=""  Do
  .....Set CurTCCode="" For  Set CurTCCode=$Order(^DHCQCIVi(MachineCode,CurDate,QCId,CurTCCode)) Quit:CurTCCode=""  Do
  ......If CurTCCode'=TCCode Quit
  ......If (PointType=3) Do
  .......//就直接执行此处生成数据
  .......Set Ret=..QueryResultByDateAvg(MachineCode,CurDate,QCId,CurTCCode,MatCode,LotCode,LevelNo,Num)
  .......//If $Length(Ret)>1 Set QCCount=$Piece(Ret,"^",1),Num=$Piece(Ret,"^",2),RetValue(Num)=$Piece(Ret,"^",3)
  .......w Ret
  .......If $Length(Ret)>1 Do
  ........Set QCCount=$Piece(Ret,"^",1),RetValue(Num)=$Piece(Ret,"^",3)
  ........Set ^LJRetValue(CurDate,Num)=$ZD(CurDate,3)_"!"_$Piece($Piece(Ret,"!",2),"@",1)_"@@@@@@|"
  ......If (PointType=3) Quit
  ......Set QCCount="" For  Set QCCount=$Order(^DHCQCIVi(MachineCode,CurDate,QCId,CurTCCode,QCCount)) Quit:QCCount=""  Do
  .......Set RowId=$Order(^DHCQCIVi(MachineCode,CurDate,QCId,CurTCCode,QCCount,""))
  .......//结果取系统默认。
  .......Set StrData=$Get(^DHCQCIV(RowId,CurDate,QCCount))
  .......Set LevelNum=$Piece($Piece(StrData,"^",6),"||",3)
  .......If LevelNo'=LevelNum Quit
  .......If $Length(LotCode),LotCode'=$Piece($Piece(StrData,"^",6),"||",2) Quit
  .......If $Length(MatCode),MatCode'=$Piece($Piece(StrData,"^",6),"||",1) Quit
  .......Set ResultDecimal=""
  .......Set ResultDecimal=$Piece($Get(^DHCQCTC(MatCode_"||"_LotCode,CurTCCode,LevelNo)),"^",8)
  .......If ResultDecimal="" Set ResultDecimal=2
  .......Set ResultByDate=$Fn($Piece(StrData,"^",3),",",ResultDecimal)
  .......//增加定性结果的显示,对于定性结果，定量结果的显示不要求小数点位
  .......Set ResultString=$Piece(StrData,"^",4)
  .......If ResultString'="" Set ResultByDate=$Piece(StrData,"^",3)
  .......//----------------------------------
  .......Set ResultByEnter=$Piece(StrData,"^",10)
  .......Set QCRul=$Piece(StrData,"^",15)
  .......Set QCRulColor=""
  .......Set QCRulStatus=$Piece(StrData,"^",16)
  .......If (PointType=1),$Length(QCRul) Quit
  .......If $Length(RuleCode),$Length(QCRul),RuleCode'[QCRul Quit
  .......Set TestRemoveData=$Piece(StrData,"^",12)
  .......If TestRemoveData=2 Quit
  .......If (PointRange=2),(TestRemoveData=1) Quit
  .......Set QCRulName=""
  .......If QCRul'="" Set QCRulName=$Piece($Get(^DHCQCRL(QCRul)),"^",2),QCRulColor=$Piece($Get(^DHCQCRL(QCRul)),"^",5)
  .......Set ^LJRetValue(CurDate,Num)=$ZD(CurDate,3)_"!"_ResultByDate_"@"_ResultByEnter_"@"_QCCount_"@"_QCRulName_"@"_QCRulColor_"@"_QCRulStatus_"@"_ResultString_"|"
  .......If (PointRange=3) Set QCCount=$Order(^DHCQCIVi(MachineCode,CurDate,QCId,CurTCCode,""),-1)
  .......Set Num=Num+1
  .......Set ResultFlag=Num-1
  ...Else  Do 
  ....Set ^LJRetValue(CurDate,Num)=$ZD(CurDate,3)_"!"_"@@@@@@|"
  ....Set Num=Num+1
  //按照日期连续显示
   If PointY=2 Do
  .If $Data(^DHCQCIVi(MachineCode)) Do
  ..For CurDate=StartDate:1:EndDate Do
  ...If $Data(^DHCQCIVi(MachineCode,CurDate)) Do
  ....Set QCId="" For  Set QCId=$Order(^DHCQCIVi(MachineCode,CurDate,QCId)) Quit:QCId=""  Do
  .....Set CurTCCode="" For  Set CurTCCode=$Order(^DHCQCIVi(MachineCode,CurDate,QCId,CurTCCode)) Quit:CurTCCode=""  Do
  ......If CurTCCode'=TCCode Quit
  ......Set QCCount="" For  Set QCCount=$Order(^DHCQCIVi(MachineCode,CurDate,QCId,CurTCCode,QCCount)) Quit:QCCount=""  Do
  .......Set RowId=$Order(^DHCQCIVi(MachineCode,CurDate,QCId,CurTCCode,QCCount,""))
  .......//结果取系统默认。
  .......Set StrData=$Get(^DHCQCIV(RowId,CurDate,QCCount))
  .......Set TestRemoveData=$Piece(StrData,"^",12)
  .......If TestRemoveData=2 Quit
  .......If (PointRange=2),(TestRemoveData=1) Quit
  .......Set LevelNum=$Piece($Piece(StrData,"^",6),"||",3)
  .......If LevelNo'=LevelNum Quit
  .......If $Length(LotCode),LotCode'=$Piece($Piece(StrData,"^",6),"||",2) Quit
  .......If $Length(MatCode),MatCode'=$Piece($Piece(StrData,"^",6),"||",1) Quit
  .......Set ResultDecimal=""
  .......Set ResultDecimal=$Piece($Get(^DHCQCTC(MatCode_"||"_LotCode,CurTCCode,LevelNo)),"^",8)
  .......If ResultDecimal="" Set ResultDecimal=2
  .......Set ResultByDate=$Fn($Piece(StrData,"^",3),",",ResultDecimal)
  .......//增加定性结果的显示,对于定性结果，定量结果的显示不要求小数点位
  .......Set ResultString=$Piece(StrData,"^",4)
  .......If ResultString'="" Set ResultByDate=$Piece(StrData,"^",3)
  .......//----------------------------------
  .......Set ResultByEnter=$Piece(StrData,"^",10)
  .......Set QCRul=$Piece(StrData,"^",15)
  .......Set QCRulColor=""
  .......Set QCRulStatus=$Piece(StrData,"^",16)
  .......//If (PointRange=2),$Length(QCRul),(QCRulStatus="R") Quit
  .......If (PointType=1),$Length(QCRul) Quit
  .......If $Length(RuleCode),$Length(QCRul),RuleCode'[QCRul Quit
  .......Set QCRulName=""
  .......If QCRul'="" Set QCRulName=$Piece($Get(^DHCQCRL(QCRul)),"^",2),QCRulColor=$Piece($Get(^DHCQCRL(QCRul)),"^",5)
  .......Set RetValue(Num)=$ZD(CurDate,3)_"!"_ResultByDate_"@"_ResultByEnter_"@"_QCCount_"@"_QCRulName_"@"_QCRulColor_"@"_QCRulStatus_"@"_ResultString_"|"
  .......Set Num=Num+1
  .......If (PointRange=3) Set QCCount=$Order(^DHCQCIVi(MachineCode,CurDate,QCId,CurTCCode,""),-1)
  Set Ret=""
  If PointY=1 Do
  .For CurDate=StartDate:1:EndDate Do
  ..Set iNum="" For  Set iNum=$Order(^LJRetValue(CurDate,iNum)) Quit:iNum=""  Do
  ...Set Ret=Ret_^LJRetValue(CurDate,iNum)_"^"
  If PointY=2 Do
  .For iNum=0:1:Num-1 Do
  ..Set Ret=Ret_RetValue(iNum)_"^"
  Kill ^LJRetValue
  Quit Ret
}

/// Creator：      DaiYi
/// CreatDate：    20130315
/// Description:： 按照计算值进行绘图
/// Table：        DHCQC_ItemValue:质控项目结果,CT_TestCode:项目表
/// Input：        MachineCode:仪器代码,CurDate:日期,QCId:标示号,CurTCCode:项目代码,MatCode:质控物,LotCode:批号,LevelNo:浓度
/// Output：       标本个数
/// Return：       
/// Others：       
/// d ##class(web.DHCQCLotInformation).QueryResultByDateAvg("")
ClassMethod QueryResultByDateAvg(MachineCode, CurDate, QCId, CurTCCode, MatCode, LotCode, LevelNo, Num) As %String
{
	Set AvgResult=0
	Set iNum=0
	Set Id="",ResultRet="^"
	Set Ret=""
	Set QCOrdId="" For  Set QCOrdId=$Order(^DHCQCIVi(MachineCode,CurDate,QCId,CurTCCode,QCOrdId)) Quit:QCOrdId=""  Do
	.Set RowId=$Order(^DHCQCIVi(MachineCode,CurDate,QCId,CurTCCode,QCOrdId,""))
	.Set StrData=$Get(^DHCQCIV(RowId,CurDate,QCOrdId))
	.Set TestRemoveData=$Piece(StrData,"^",12)
    .If TestRemoveData=2 Quit
	.Set LevelNum=$Piece($Piece(StrData,"^",6),"||",3)
    .If LevelNo'=LevelNum Quit
    .If $Length(LotCode),LotCode'=$Piece($Piece(StrData,"^",6),"||",2) Quit
    .If $Length(MatCode),MatCode'=$Piece($Piece(StrData,"^",6),"||",1) Quit
    .Set ResultByDate=$Piece(StrData,"^",3)
    .Set AvgResult=AvgResult+ResultByDate
    .Set iNum=iNum+1,Id=QCOrdId
    If iNum>0 Do
    .Set ResultDecimal=""
    .Set ResultDecimal=$Piece($Get(^DHCQCTC(MatCode_"||"_LotCode,CurTCCode,LevelNo)),"^",8)
    .If ResultDecimal="" Set ResultDecimal=2
    .Set AvgResult=$Fn((AvgResult/iNum),",",ResultDecimal)
    .Set ResultByEnter=$Piece(StrData,"^",10)
    .Set RetValue(Num)=$ZD(CurDate,3)_"!"_AvgResult_"@"_ResultByEnter_"@"_Id_"@"_""_"@"_""_"@"_""_"|"
    .Set Ret=Id_"^"_Num_"^"_RetValue(Num)
	Quit Ret
}

/// Creator：      DaiYi
/// CreatDate：    20120602
/// Description:： z分图按照日期查询结果
/// Table：        DHCQC_ItemValue:质控项目结果,CT_TestCode:项目表,DHCQC_TCMethod:项目使用方法
/// Input：        StartDate:开始日期,EndDate:结束日期,MatCode:质控物,LotCode:质控批号,TCCode:项目代码,LevelNo:浓度,PointType:点类型
/// Output：       日期及结果
/// Return：       结果字符串
/// Others：       日期^结果|
/// d ##class(web.DHCQCLotInformation).QueryResultOrderByZ("AH800","3","2","2013-11-1","2013-11-31","A0310","1,2,3","0")
ClassMethod QueryResultOrderByZ(MachineCode As %String, MatCode As %String, LotCode As %String, StartDate As %String, EndDate As %String, TCCode As %String, LevelNo As %String, PointType As %String) As %String
{
 
  Set MachineCode=$Get(MachineCode),MatCode=$Get(MatCode),StartDate=$Get(StartDate),EndDate=$Get(EndDate)
  Set TCCode=$Get(TCCode),LevelNo=$Get(LevelNo),LotCode=$Get(LotCode)
  Set StartDate=$ZDH(StartDate,3),EndDate=$ZDH(EndDate,3),PointType=$Get(PointType)
  Set Ret=""
  If MatCode="" Quit 0
  If TCCode="" Quit 1
  If LotCode="" Quit 0
  Set LevelNum=0
  Set Num=0
  //浓度为空，退出。
  If $Length(LevelNo)<1 Quit
  //初始化数组
  Set DateString=""
  For i=1:1:$Length(LevelNo) Do
  .Set QCId=$Piece(LevelNo,",",i)
  .If QCId="" Quit
  .Set Num=0
  .For CurDate=StartDate:1:EndDate Do
  ..If i=1 Set DateString=DateString_$Piece($ZD(CurDate,3),"-",3)_"|"
  ..//If i=1,(EndDate-StartDate>40) Set DateString=DateString_$Piece($ZD(CurDate,2,3),"-",3)_"|"
  ..Set Ret=QCId
  ..Set ^QCRetValue($Job,Ret,CurDate,0)=Ret_"!"_$ZD(CurDate,3)_"!"
  ..Set Num=Num+1
  Kill ^DHCQCNum(MachineCode,1)
  Set ^DHCQCNum(MachineCode,1)=0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_Num_"^"_DateString
  Set iNum=0
  Set QueryCurDate="",QueryQCId=""
  //先不考虑取数据的效率。按浓度取，一个一个过滤。
  If $Data(^DHCQCIVi(MachineCode)) Do
  .For CurDate=StartDate:1:EndDate Do
  ..Set iNum=0
  ..If $Data(^DHCQCIVi(MachineCode,CurDate)) Do
  ...Set QCId="" For  Set QCId=$Order(^DHCQCIVi(MachineCode,CurDate,QCId)) Quit:QCId=""  Do 
  ....Set iNum=0 
  ....Set CurTCCode="" For  Set CurTCCode=$Order(^DHCQCIVi(MachineCode,CurDate,QCId,CurTCCode)) Quit:CurTCCode=""  Do
  .....If CurTCCode'=TCCode Quit
  .....Set QCCount="" For  Set QCCount=$Order(^DHCQCIVi(MachineCode,CurDate,QCId,CurTCCode,QCCount),-1) Quit:QCCount=""  Do
  ......Set RowId=$Order(^DHCQCIVi(MachineCode,CurDate,QCId,CurTCCode,QCCount,""),-1)
  ......If iNum>0,PointType=0,QueryCurDate=CurDate,QueryQCId=QCId Quit
  ......Set OrdData=$Get(^DHCQCIV(RowId,CurDate,QCCount))
  ......Set ParRef=$Piece(OrdData,"^",6)
  ......Set TestRemoveData=$Piece($Get(OrdData),"^",12)
  ......If TestRemoveData=2 Quit
  ......If TestRemoveData=1 Quit
  ......If $Length(MatCode),MatCode'=$Piece(ParRef,"||",1) Quit
  ......If $Length(LotCode),LotCode'=$Piece(ParRef,"||",2) Quit
  ......Set CurQCId=$Piece(ParRef,"||",3) 
  ......If LevelNo'[CurQCId  Quit
  ......//结果取系统默认
  ......Set ResultDecimal=""
  ......If $Data(^DHCQCTC(MatCode_"||"_LotCode,CurTCCode,CurQCId)) Do
  .......Set ResultDecimal=$Piece($Get(^DHCQCTC(MatCode_"||"_LotCode,TCCode,CurQCId)),"^",8)
  ......If ResultDecimal="" Set ResultDecimal=2
  ......Set ResultByDate=$Fn($Piece(OrdData,"^",3),",",ResultDecimal)
  ......//增加定性结果的显示,对于定性结果，定量结果的显示不要求小数点位
  ......Set ResultString=$Piece(OrdData,"^",4)
  ......If ResultString'="" Set ResultByDate=$Piece(OrdData,"^",3)
  ......//----------------------------------
  ......If ResultByDate="" Quit
  ......Set ResultByEnter=$Piece(OrdData,"^",10)
  ......Set QCRul=$Piece(OrdData,"^",15)
  ......Set QCRulName=""
  ......If QCRul'="" Set QCRulName=$Piece($Get(^DHCQCRL(QCRul)),"^",2)
  ......Set QCStatus=$Piece(OrdData,"^",16)
  ......Set QCRulColor=""
  ......//质控规则颜色
  ......If QCRul'="" Set QCRulColor=$Piece($Get(^DHCQCRL(QCRul)),"^",5)
  ......b ;22
  ......//If QCStatus="R" Quit
  ......Set ^QCRetValue($Job,CurQCId,CurDate,iNum)=CurQCId_"!"_$ZD(CurDate,3)_"!"_ResultByDate_"@"_ResultByEnter_"@"_QCCount_"@"_QCRulName_"@"_ResultString_"@"_QCRulColor_"@"_QCStatus_"|"
  ......Set iNum=iNum+1
  ......Set QueryCurDate=CurDate,QueryQCId=QCId
  Set Ret=""
  Set iNum=0
  For i=1:1:$Length(LevelNo) Do
  .Set QCId=$Piece(LevelNo,",",i)
  .If QCId="" Quit
  .Set iNum=0
  .For CurDate=StartDate:1:EndDate Do
  ..Set QCNum="" For  Set QCNum=$Order(^QCRetValue($Job,QCId,CurDate,QCNum)) Quit:QCNum=""  Do
  ...Set Ret=Ret_$Get(^QCRetValue($Job,QCId,CurDate,QCNum))_"^"
  ...Set iNum=iNum+1
  .Set $Piece(^DHCQCNum(MachineCode,1),"^",QCId)=iNum
  Kill ^QCRetValue($Job)
  Quit Ret
}

/// Creator：      DaiYi
/// CreatDate：    20140929
/// Description:： 查询试验方法
/// Table：        DHCQC_TCMethod
/// Input：        TcCode：项目代码，MachCode:仪器代码,QcDate:质控时间
/// Output：       方法名
/// Return：       
/// Others：       
/// d ##class(web.DHCQCLotInformation).QueryMethod("A1130","AC1500",63459)
ClassMethod QueryMethod(TcCode, MachCode, QcDate) As %String
{
	s TcCode=$g(TcCode),MachCode=$g(MachCode),QcDate=$g(QcDate)
	s ^TMP("dhcc")=TcCode_","_MachCode_","_QcDate
	s Ret=""
	i $d(^DHCQCTM(TcCode)) d
	.s OrdId="" f  s OrdId=$o(^DHCQCTM(TcCode,OrdId)) q:OrdId=""  d
	..s StrData=$g(^DHCQCTM(TcCode,OrdId))
	..i QcDate>$p(StrData,"^",5) q 
	..i QcDate<$p(StrData,"^",4) q 
	..i $l(MachCode),MachCode'=$p(StrData,"^",8) q
	..s Ret=$p(StrData,"^",3)
	Quit Ret
}

/// Creator：      DaiYi
/// CreatDate：    20130314
/// Description:： 返回Z分图数组个数
/// Table：        
/// Input：        Type:个数
/// Output：       标本个数
/// Return：       
/// Others：       
/// d ##class(web.DHCQCLotInformation).QueryResultOrderByZNum("")
/// 修改按照仪器取数组
ClassMethod QueryResultOrderByZNum(MachCode, Type) As %String
{
	//Set Ret=$Get(^DHCQCNum($Job,Type))
	//Kill ^DHCQCNum($Job,Type)
	i MachCode="" q 0
	Set Ret=$Get(^DHCQCNum(MachCode,Type))
	i Ret="" s Ret=0
	Kill ^DHCQCNum(MachCode,Type)
	Quit Ret
}

/// Creator：      DaiYi
/// CreatDate：    20120602
/// Description:： z分图按照日期查询结果,显示连线的结果.
/// Table：        DHCQC_ItemValue:质控项目结果,CT_TestCode:项目表,DHCQC_TCMethod:项目使用方法
/// Input：        StartDate:开始日期,EndDate:结束日期,MatCode:质控物,LotCode:质控批号,TCCode:项目代码,LevelNo:浓度,PointType:点类型
/// Output：       日期及结果
/// Return：       结果字符串
/// Others：       日期^结果|
/// d ##class(web.DHCQCLotInformation).QueryResultOrderByZ("ASCA15","ACA1500","548129","2013-3-1","2013-3-31","A1260","1,2,3,4",1)
ClassMethod QueryResultOrderByZData(MachineCode As %String, MatCode As %String, LotCode As %String, StartDate As %String, EndDate As %String, TCCode As %String, LevelNo As %String, PointType As %String) As %String
{
 
  Set MachineCode=$Get(MachineCode),MatCode=$Get(MatCode),StartDate=$Get(StartDate),EndDate=$Get(EndDate)
  Set TCCode=$Get(TCCode),LevelNo=$Get(LevelNo),LotCode=$Get(LotCode)
  Set StartDate=$ZDH(StartDate,3),EndDate=$ZDH(EndDate,3),PointType=$Get(PointType)
  Set Ret=""
  If MatCode="" Quit 0
  If TCCode="" Quit 1
  If LotCode="" Quit 0
  Set LevelNum=0
  Set Num=0
  Set NumDays=EndDate-StartDate
  //浓度为空，退出。
  If $Length(LevelNo)<1 Quit
  //初始化数组
  Set DateString=""
  For i=1:1:$Length(LevelNo) Do
  .Set QCId=$Piece(LevelNo,",",i)
  .If QCId="" Quit
  .Set Num=0
  .For CurDate=StartDate:1:EndDate Do
  ..If i=1,NumDays<41 Set DateString=DateString_$Piece($ZD(CurDate,3),"-",3)_"|"
  ..If i=1,NumDays>40 Set DateString=DateString_$Piece($ZD(CurDate,3),"-",2,3)_"|"
  ..Set Ret=QCId
  ..Set ^QCRetValue($Job,Ret,CurDate,0)=Ret_"!"_$ZD(CurDate,3)_"!"
  ..Set Num=Num+1
  Set iNum=0
  Set QueryCurDate="",QueryQCId=""
  //先不考虑取数据的效率。按浓度取，一个一个过滤。
  If $Data(^DHCQCIVi(MachineCode)) Do
  .For CurDate=StartDate:1:EndDate Do
  ..Set iNum=0
  ..If $Data(^DHCQCIVi(MachineCode,CurDate)) Do
  ...Set QCId="" For  Set QCId=$Order(^DHCQCIVi(MachineCode,CurDate,QCId)) Quit:QCId=""  Do 
  ....Set CurTCCode="" For  Set CurTCCode=$Order(^DHCQCIVi(MachineCode,CurDate,QCId,CurTCCode)) Quit:CurTCCode=""  Do
  .....If CurTCCode'=TCCode Quit
  .....Set QCCount="" For  Set QCCount=$Order(^DHCQCIVi(MachineCode,CurDate,QCId,CurTCCode,QCCount)) Quit:QCCount=""  Do
  ......Set RowId=$Order(^DHCQCIVi(MachineCode,CurDate,QCId,CurTCCode,QCCount,""))
  ......If iNum>0,PointType=0,QueryCurDate=CurDate,QueryQCId=QCId Quit
  ......If iNum>0 Quit
  ......Set OrdData=$Get(^DHCQCIV(RowId,CurDate,QCCount))
  ......Set ParRef=$Piece(OrdData,"^",6)
  ......Set TestRemoveData=$Piece($Get(OrdData),"^",12)
  ......If TestRemoveData=2 Quit
  ......If TestRemoveData=1 Quit
  ......If $Length(MatCode),MatCode'=$Piece(ParRef,"||",1) Quit
  ......If $Length(LotCode),LotCode'=$Piece(ParRef,"||",2) Quit
  ......Set CurQCId=$Piece(ParRef,"||",3) 
  ......If LevelNo'[CurQCId  Quit
  ......//结果取系统默认
  ......Set ResultDecimal=""
  ......If $Data(^DHCQCTC(MatCode_"||"_LotCode,CurTCCode,CurQCId)) Do
  .......Set ResultDecimal=$Piece($Get(^DHCQCTC(MatCode_"||"_LotCode,TCCode,CurQCId)),"^",8)
  ......If ResultDecimal="" Set ResultDecimal=2
  ......Set ResultByDate=$Fn($Piece(OrdData,"^",3),",",ResultDecimal)
  ......If ResultByDate="" Quit
  ......Set ResultByEnter=$Piece(OrdData,"^",10)
  ......Set QCRul=$Piece(OrdData,"^",15)
  ......Set QCRulName=""
  ......If QCRul'="" Set QCRulName=$Piece($Get(^DHCQCRL(QCRul)),"^",2)
  ......Set QCStatus=$Piece(OrdData,"^",16)
  ......//If QCStatus="R" Quit
  ......Set ^QCRetValue($Job,CurQCId,CurDate,iNum)=CurQCId_"!"_$ZD(CurDate,3)_"!"_ResultByDate_"@"_ResultByEnter_"@"_QCCount_"@"_QCRulName_"@"_"|"
  ......Set iNum=iNum+1
  ......Set QueryCurDate=CurDate,QueryQCId=QCId
  Set Ret=""
  For i=1:1:$Length(LevelNo) Do
  .Set QCId=$Piece(LevelNo,",",i)
  .If QCId="" Quit
  .For CurDate=StartDate:1:EndDate Do
  ..Set QCNum="" For  Set QCNum=$Order(^QCRetValue($Job,QCId,CurDate,QCNum)) Quit:QCNum=""  Do
  ...Set Ret=Ret_$Get(^QCRetValue($Job,QCId,CurDate,QCNum))_"^"
  Quit Ret
}

/// d ##class(web.DHCQCLotInformation).UpdateMatLot("ASCA15","")
ClassMethod UpdateMatLot(MatCode As %String, LotCode As %String) As %String
{
	Set MatCode=$Get(MatCode),LotCode=$Get(LotCode)
	If $Data(^DHCQCIVi(MatCode)) Do
	.Set QCDate="" For  Set QCDate=$Order(^DHCQCIVi(MatCode,QCDate)) Quit:QCDate=""  Do
	..Set LeveNo="" For  Set LeveNo=$Order(^DHCQCIVi(MatCode,QCDate,LeveNo)) Quit:LeveNo=""  Do
	...Set TCCode="" For  Set TCCode=$Order(^DHCQCIVi(MatCode,QCDate,LeveNo,TCCode)) Quit:TCCode=""  Do
	....Set TCCount="" For  Set TCCount=$Order(^DHCQCIVi(MatCode,QCDate,LeveNo,TCCode,TCCount)) Quit:TCCount=""  Do
	.....Set RowId="" For  Set RowId=$Order(^DHCQCIVi(MatCode,QCDate,LeveNo,TCCode,TCCount,RowId)) Quit:RowId=""  Do
	......Set StrData=$Get(^DHCQCIV(RowId,QCDate,TCCount))
	......If QCDate>62897 Quit
	......//If $Piece(^DHCQCIV(RowId,QCDate,TCCount),"^",6)'="" Quit
	......If LeveNo=901 Do
	.......Set $Piece(^DHCQCIV(RowId,QCDate,TCCount),"^",6)="ACA1500||528117||1"
	......If LeveNo=902 Do
	.......//Set $Piece(^DHCQCIV(RowId,QCDate,TCCount),"^",6)="AXT1800i||09120752||1"
	......If LeveNo=903 Do
	.......//Set $Piece(^DHCQCIV(RowId,QCDate,TCCount),"^",6)="Ci2000||js40263H||"_3
	b ;12
	Quit 0
}

Storage Default
{
<Data name="DHCQCLotInformationDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCQCLotInformationD</DataLocation>
<DefaultData>DHCQCLotInformationDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCQCLotInformationD</IdLocation>
<IndexLocation>^web.DHCQCLotInformationI</IndexLocation>
<StreamLocation>^web.DHCQCLotInformationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
