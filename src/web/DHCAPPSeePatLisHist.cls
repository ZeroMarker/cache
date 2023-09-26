Import SQLUSER

Class web.DHCAPPSeePatLisHist Extends %Persistent [ ClassType = "", Not ProcedureBlock ]
{

/// w ##class(web.DHCAPPSeePatLisHist).JsonGetLisHis("144||145,144||147")
ClassMethod JsonGetLisHis(OEORIID)
{
	n (OEORIID)
	q:OEORIID="" ""
	s AdmDr = $p(^OEORD(+OEORIID),"^",1)
	s PatID = $p(^PAADM(AdmDr),"^",1)
	s AdmStr = ##class(web.MyInterfaceMethod).GetAdmStrByPatID(PatID,"","","")
	s ArcimID =$p($g(^OEORD(+OEORIID,"I",$p($p(OEORIID,",",1),"||",2),1)),"^",2)  //医嘱项ID
	s OEORIStr=""
	
	b ;1
	s Pid = ##Class(web.DHCAPPExaRepCom).NewPid()
	k ^TMP("DHCEM","web.DHCAPPSeePatLisHist","JsonGetLisHis")
	//获取历次改病人检验信息
	s Len = $l(AdmStr,"^"),ColumnNum=0   //列数目
	f i=1:1:Len d
	.s AdmID = $P(AdmStr,"^",i)
	.s Ord=0
	.f  s Ord = $o(^OEORD(0,"Adm",AdmID,Ord)) q:Ord=""  d
	..s Itm=0
	..f  s Itm = $o(^OEORD(Ord,"I",Itm)) q:Itm=""  d
	...q:ArcimID'=$p($g(^OEORD(Ord,"I",Itm,1)),"^",2)  //获取历次就诊包含
	...s OEORIID = Ord_"||"_Itm //有可能多个医嘱并管子,这里过滤第一个
	...s ReportID = ##class(web.MyInterfaceMethod).GetLisReportID(Ord,Itm)   //获取报告ID,报告ID为空标示没有,修改这个东东:最好调用Lis的接口
	...q:ReportID=""
	...s VisitNumDr = ##class(web.MyInterfaceMethod).GetLisVisitNumID(Ord,Itm)
	...q:VisitNumDr="" 
	...s LisNo = $p($g(^OEORD(Ord,"I",Itm,3)),"^",20)
	...s RecDate = $lg($g(^dbo.RPVisitNumberD(VisitNumDr)),66)
	...s:RecDate'="" RecDate=$e(RecDate,1,4)_"-"_$e(RecDate,5,6)_"-"_$e(RecDate,7,8)
	...s RecDate = $zdh(RecDate,3)
	...s ^TMP("DHCEM","web.DHCAPPSeePatLisHist","JsonGetLisHis",Pid,"Date",RecDate,LisNo)=ReportID   //接受时间排序
	...s ColumnNum=ColumnNum+1   
	s ColumnNum=ColumnNum+1
	;949742
	b ;data
	
	s ^TMP("DHCEM","web.DHCAPPSeePatLisHist","JsonGetLisHis",Pid,"Number")="检验号^接收日期"
	s ^TMP("DHCEM","web.DHCAPPSeePatLisHist","JsonGetLisHis",Pid,"Data","接收日期")="接收日期"
	s ^TMP("DHCEM","web.DHCAPPSeePatLisHist","JsonGetLisHis",Pid,"Data","检验号")="检验号"
	
	s Num=0
	s RecDate=""
	f  s RecDate = $o(^TMP("DHCEM","web.DHCAPPSeePatLisHist","JsonGetLisHis",Pid,"Date",RecDate)) q:RecDate=""  d
	.s LisNo=""
	.f  s LisNo = $o(^TMP("DHCEM","web.DHCAPPSeePatLisHist","JsonGetLisHis",Pid,"Date",RecDate,LisNo)) q:LisNo=""  d
	..s ReportID = ^TMP("DHCEM","web.DHCAPPSeePatLisHist","JsonGetLisHis",Pid,"Date",RecDate,LisNo)
	..d SetData
	
	q Pid_"^"_ColumnNum
	
SetData

    s ^TMP("DHCEM","web.DHCAPPSeePatLisHist","JsonGetLisHis",Pid,"Data","接收日期")=^TMP("DHCEM","web.DHCAPPSeePatLisHist","JsonGetLisHis",Pid,"Data","接收日期")_"^"_$zd(RecDate,3)
    s ^TMP("DHCEM","web.DHCAPPSeePatLisHist","JsonGetLisHis",Pid,"Data","检验号")=^TMP("DHCEM","web.DHCAPPSeePatLisHist","JsonGetLisHis",Pid,"Data","检验号")_"^"_LisNo
	Set result=##class(%Library.ResultSet).%New("LIS.WS.BLL.DHCRPVisitNumberReportResult:QryTSInfo")
	Set sc=result.Execute(ReportID)
	If $$$ISERR(sc) Quit ""
	
	Set colNum=result.GetColumnCount() //列数
	Set count = 0
	Set del=""""
	Set tmp=""
	Set EmPatLevTotal=0,EmPatLevCnt1=0,EmPatLevCnt2=0,EmPatLevCnt3=0,EmPatLevNotCnt=0
	
	While(result.Next())
	{ 
		Set ret=""
		For i=1:1:colNum Do
		.If ret="" Set ret=del_result.GetColumnName(i)_del_":"_del_$P(result.%GetData(i),$C(13,10))_del
		.Else   Set ret=ret_","_del_result.GetColumnName(i)_del_":"_del_$P(result.%GetData(i),$C(13,10))_del
		s retObj = ##class(%DynamicAbstractObject).%FromJSON("{"_ret_"}")
		s HasFlag = $d(^TMP("DHCEM","web.DHCAPPSeePatLisHist","JsonGetLisHis",Pid,"Data",retObj.TestCodeName))
		s:HasFlag=0 ^TMP("DHCEM","web.DHCAPPSeePatLisHist","JsonGetLisHis",Pid,"Data",retObj.TestCodeName)= retObj.TestCodeName
		s TmpData = retObj.Result_"#"_retObj.AbFlag
		s ^TMP("DHCEM","web.DHCAPPSeePatLisHist","JsonGetLisHis",Pid,"Data",retObj.TestCodeName)= ^TMP("DHCEM","web.DHCAPPSeePatLisHist","JsonGetLisHis",Pid,"Data",retObj.TestCodeName)_"^"_TmpData
		continue:$g(^TMP("DHCEM","web.DHCAPPSeePatLisHist","JsonGetLisHis",Pid,"Number"))[retObj.TestCodeName
		s:$d(^TMP("DHCEM","web.DHCAPPSeePatLisHist","JsonGetLisHis",Pid,"Number"))'=0 ^TMP("DHCEM","web.DHCAPPSeePatLisHist","JsonGetLisHis",Pid,"Number")=^TMP("DHCEM","web.DHCAPPSeePatLisHist","JsonGetLisHis",Pid,"Number")_"^"_retObj.TestCodeName
	 	s:$d(^TMP("DHCEM","web.DHCAPPSeePatLisHist","JsonGetLisHis",Pid,"Number"))=0 ^TMP("DHCEM","web.DHCAPPSeePatLisHist","JsonGetLisHis",Pid,"Number")=retObj.TestCodeName
	 }
}

/// w ##class(web.DHCAPPSeePatLisHist).GetDataGrid("87560^2")
ClassMethod GetDataGrid(Params)
{
	n (Params)
	s Pid = $p(Params,"^",1)
	s ColumnNum = $p(Params,"^",2)
	
	s RsStr = ""
	f i=1:1:ColumnNum d
	.s:RsStr'="" RsStr=RsStr_"^field"_i
	.s:RsStr="" RsStr="field"_i
	
	w ##class(web.DHCAPPJsonCommon).getJsonStartNoTotal()
	
	s Number = ^TMP("DHCEM","web.DHCAPPSeePatLisHist","JsonGetLisHis",Pid,"Number")
	s Len = $l(Number,"^")
	s Count=0
	f i=1:1:Len d
	.s TestCodeName = $p(Number,"^",i)
	.s Data = ^TMP("DHCEM","web.DHCAPPSeePatLisHist","JsonGetLisHis",Pid,"Data",TestCodeName)
	.w $case(Count,0:"",:",")
	.s Count=Count+1
	.w ##class(web.DHCAPPJsonCommon).getJsonData(RsStr,Data)
	w ##class(web.DHCAPPJsonCommon).getJsonEndConTotal(Count)
	q ""
}

}
