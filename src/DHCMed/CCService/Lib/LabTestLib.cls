/// 检验操作类
/// 创建者：刘宇辉
/// 创建日期：2010-10-15
Class DHCMed.CCService.Lib.LabTestLib Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liuyh
/// CreatDate：   2010-10-15
/// Description:  判断检验结果是否与传入结果相同
/// Table：       MR_Adm、MR_Diagnos
/// Input：       MRCID
/// Return：      ret=1:下了该诊断
/// w ##class(DHCMed.CCService.Lib.LabTestLib).CompareLab("诊断||D0190|大于|12||描述")
ClassMethod CompareLab(LabExp As %String) As %String
{
	n (LabExp, %PAADM, %ExtraData, %ExtraDataCnt)
	s LabExp=$p(LabExp,"||",2)
	s LabDesc=$p(LabExp,"||",3)
	s ret=0
	q:LabExp="" ret
	Set Config=##Class(websys.Configuration).%OpenId(1)
	Set MEDDATA=Config.DataNamespace
	Set LABDATA=Config.LabDataNamespace
	Set CurrentNS=$ZNSPACE
	d Config.%Close()
	
	s Papmi=$p($g(^PAADM(%PAADM)),"^",1)
	s papmino=$p(^PAPER(Papmi,"PAT",1),"^",1)
	s PatNo=$$RegNoCon(papmino)	//格式化登记号，格式化成8位或者10位
	s date=$p($g(^PAADM(%PAADM)),"^",6)
    s time=$p($g(^PAADM(%PAADM)),"^",7)
    s cDateFrom=date
    s cDateTo=$p($h,",",1)
    zn LABDATA
    s num=0
    s testCode=$p(LabExp,"|",1)
    zn:'$d(^TDHCOldResult("1",PatNo,testCode)) CurrentNS
    s type=$p($g(^TTAB("TC",testCode)),"\",3)
    s date=cDateFrom-1
    f  s date=$o(^TDHCOldResult("1",PatNo,testCode,date)) q:(date="")!(date>cDateTo)  d
    .s time=""
    .f  s time=$o(^TDHCOldResult("1",PatNo,testCode,date,time)) q:time=""  d
    ..s VisitNumber=""
    ..f  s VisitNumber=$o(^TDHCOldResult("1",PatNo,testCode,date,time,VisitNumber)) q:VisitNumber=""  d
    ...s TestSetDR="" 
    ...f  s TestSetDR=$o(^TDHCOldResult("1",PatNo,testCode,date,time,VisitNumber,TestSetDR)) q:TestSetDR=""  d
    ....s TestSetCounter="" 
    ....f  s TestSetCounter=$o(^TDHCOldResult("1",PatNo,testCode,date,time,VisitNumber,TestSetDR,TestSetCounter)) q:TestSetCounter=""  d
    .....zn CurrentNS
    .....s Result=$$GetResult(VisitNumber,TestSetDR,TestSetCounter,testCode,type)
    .....zn LABDATA
    .....;s Data=VisitNumber_"^"_TestSetCounter_"^"_Result_"^"_"name"_"^"_date_"^"_time
    .....s Data=testCode_"^"_VisitNumber_"^"_Result_"^"_"name"_"^"_date_"^"_time	//VisitNumber 标本号
    .....s ^TMP($j,"DATA",testCode,num)=Data
    .....s num=num+1
    i num<1 d
    .zn CurrentNS
   	q:num<1 ret
    s Operation=$p(LabExp,"|",2)
    s QueryResult=$p(LabExp,"|",3)
    s ResNum=0		//满足检验表达式的个数
    s index="" f  s index=$o(^TMP($j,"DATA",testCode,index)) q:index=""  d
    .s Data=$g(^TMP($j,"DATA",testCode,index))
    .s ResultOr=$p($p(Data,"^",3),"||",1)
    .zn CurrentNS
    .s rt=$$ComResult(type,ResultOr,Operation,QueryResult)
    .zn LABDATA
    .i rt=0 d
    ..s ResNum=ResNum+1
   	..s ^TMP($j,"OR",testCode,ResNum)=Data
    ..s sPLIST(ResNum)=Data
    ..s rt=1
    
    zn CurrentNS
    f i=1:1:ResNum d
    .s ret=1
    .s tmp=""
	.s tmp=testCode
	.s tmp=tmp_"^"_VisitNumber		
	.s tmp=tmp_"^"_Result 
	.s tmp=tmp_"^"_date  
	.s tmp=tmp_"^"_time	
	.s tmp=tmp_"^"_LabDesc	
	.s %ExtraDataCnt=%ExtraDataCnt+1
	.s Rst="L"_$C(1)_tmp
	.s $li(%ExtraData,%ExtraDataCnt)=$$BuildCompareLabResult(1) //格式化输出
    q ret
    

ComResult(type,Result,Opertion,QueryResult)
     s return=1
     i $e(type,1)="N" d
     .i Opertion="等于",Result=QueryResult d
     ..s return=0
     .i Opertion="大于",Result>QueryResult d
     ..s return=0
     .i Opertion="小于",Result<QueryResult d
     ..s return=0
     .i Opertion="不等于",Result'=QueryResult d
     ..s return=0
     .i Opertion="不包含",Result'[QueryResult d
     ..s return=0
     e  d
     .i Opertion="等于",Result=QueryResult d
     ..s return=0
     .i Opertion="包含",Result[QueryResult d
     ..s return=0
     .i Opertion="]",Result]QueryResult d
     ..s return=0
     .i Opertion="不等于",Result'=QueryResult d
     ..s return=0
     .i Opertion="不包含",Result'[QueryResult d
     ..s return=0
     q return
         
GetResult(VisitNumber,TestSetDR,TestSetCounter,TestCode,type)   ;取备注值
   s VisitNumber=$g(VisitNumber),TestSetDR=$g(TestSetDR),TestSetCounter=$g(TestSetCounter),TestCode=$g(TestCode),type=$g(type)
   s Res="",Comm=""
   i (type["N")!(type="X") d
   .i $d(^TEPI(VisitNumber,1,TestSetDR,TestSetCounter,"DATA",TestCode)) d
   ..s Res=$p(^TEPI(VisitNumber,1,TestSetDR,TestSetCounter,"DATA",TestCode),"\",1)
   e  i type="S" d
   .i $d(^TEPI(VisitNumber,1,TestSetDR,TestSetCounter,"DATA",TestCode)) d 
   ..s Res=$p(^TEPI(VisitNumber,1,TestSetDR,TestSetCounter,"DATA",TestCode),"\",1)
   ..i $d(^TTAB("TC",TestCode,2,Res,0)) d 
   ...s Comm=^TTAB("TC",TestCode,2,Res,^TTAB("TC",TestCode,2,Res,0))
   e  i type="V" d
   .s Res=$p(^TEPI(VisitNumber,1,TestSetDR,TestSetCounter,"DATA",TestCode),"\",1)
   .s Comm=$P($g(^TTAB("BUG",Res)),"\",1)
   q Res_"||"_Comm
	
RegNoCon(PAPMINo)
    n (PAPMINo)
    q:PAPMINo="" PAPMINo
	s len=8
	s PATCFid=$o(^CF("PATCF",""))
	i PATCFid'="" s len=$p($g(^CF("PATCF",PATCFid,3)),"^",5)
	if $l(PAPMINo)<len d
	.s prelen=len-$l(PAPMINo)
	.for i=1:1:prelen s PAPMINo="0"_PAPMINo
	Q PAPMINo
BuildCompareLabResult(arg0) //Add By LiYang 2012-06-20
	Set tmpDesc=Rst
	//ExtraData=$lb(Summary,ActDate,ActTime,DataValue,ObjectID,UserID,Parameters)
	Set tmp=""
	Set $p(tmp,$c(3),1)=tmpDesc
	Set $p(tmp,$c(3),2)=date
	Set $p(tmp,$c(3),3)=time
	Set $p(tmp,$c(3),4)=LabDesc
	Set $p(tmp,$c(3),5)=VisitNumber
	Set $p(tmp,$c(3),6)=0
	Set $p(tmp,$c(3),7)="LabExp"_LabExp
	Quit tmp
}

ClassMethod GetDetails(Str As %String) As %String
{
	n (Str)
	s ret=""
	s ret="检查项目:"_$p(Str,"^",6)
	s ret=ret_"  ||检查时间:"_$p(Str,"^",4)_" "_$p(Str,"^",5)
	s ret=ret_"  ||检查结果:"_$p(Str,"^",3)
	q ret
}

}
