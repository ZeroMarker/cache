Class web.DHCLabReportPrint Extends %Persistent
{

Query QueryPrintData(TSRowIDs As %String(MAXLEN=32767), UserCode As %String, Param As %String(MAXLEN=32767)) As %Query(ROWSPEC = "PrintType,PrintX,PrintY,PrintFont,PrintFontSize,PrintFontStyle,PrintLength,PrintWidth,PrintHeight,PrintText,DataField,PrintFlag,PrintAlignment,PrintImageFile") [ SqlProc ]
{
}

/// TSRowIDs:"100160||A028||1^100151||A028||1"
/// UserCode:用户代码
/// Param:预留参数串 "0^Merge^DOUBLE^CHECKPAPER^PrinterName^"
///                   Merge:是否合并不同样本的报告
///                   DOUBLE:A4纸张1页打印两份报告 CHECKPAPER:可按报告定义设置打印纸张,缺省必须一次打印一个TSROWID
///                   PrinterName指定打印机^PaperSource:指打印机纸盒来源(数值)
/// PrintType="PAGE" 表示需要换页  tResultLineSpacing:结果换行
/// d ##Class(%ResultSet).RunQuery("web.DHCLabReportPrint","QueryPrintData","D63074001||D001||1","demo",0)
ClassMethod QueryPrintDataExecute(ByRef qHandle As %Binary, TSRowIDs As %String(MAXLEN=32767), UserCode As %String(MAXLEN=32767), Param As %String(MAXLEN=32767)) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1

	Set Config=##Class(websys.Configuration).%OpenId(1)
	Set LABDATA=Config.LabDataNamespace
	If '$Length(LABDATA) Set LABDATA="LABDATA"

	s TSRowIDs=$g(TSRowIDs),UserCode=$g(UserCode),Param=$g(Param)
 	k ^TMP("web.DHCLabReportPrint",$j)
	s ^TMP("web.DHCLabReportPrint","PARAM","QueryPrintDataExecute")=TSRowIDs_","_UserCode_","_Param
	
	s lfcr=$c(10,13)
	s ReportMerge=$p(Param,"^",2)
	s A4Double=$p(Param,"^",3),CheckPaper=$p(Param,"^",4),PrinterName=$p(Param,"^",5)
	s PaperSource=+$p(Param,"^",6)  ///打印机送纸来源
	//s CheckPaper="CHECKPAPER"  ///选择详细纸张设置打印
	
	//s A4Double="A4Double"
	//s A4Double="ContinuousPrint"
	s DoublePage=0,DoublePrintY=0

	
 	///结果Rowid合并	
	i ReportMerge="Merge" d ##Class(web.DHCLabReportPrint).MergeLabRowid(TSRowIDs)
	e  d ##Class(web.DHCLabReportPrint).TakeTSRowID(TSRowIDs)
		
	s ord="" f  s ord=$O(^TMP("web.DHCLabReportPrint",$j,"TSList",ord)) q:ord=""  d
	. s TSRowIDList=$g(^TMP("web.DHCLabReportPrint",$j,"TSList",ord))
	. s TSRowID=$p(TSRowIDList,"#",1)
	. s labno=$p(TSRowID,"||",1),ts=$p(TSRowID,"||",2),tscnt=$p(TSRowID,"||",3)
	. ///病人信息
	. s ReportInfo=##Class(web.DHCLabReportPrint).GetReportInfo(TSRowIDList)
	. i '$l(ReportInfo) q
	. ///结果列表
	. k ^TMP("web.DHCLabReportPrint",$j,"Result")
	. s TSSumResult=##Class(web.DHCLabReportPrint).GetTSResult(TSRowIDList,LABDATA) ///结果总数
	. i '$d(^TMP("web.DHCLabReportPrint",$j,"Result")) q
	. //获取关联报告
 	. s reportCode=..GetReportCodeByTSRowIDs(TSRowIDList,LABDATA)  ///获取关连医嘱套报告模板
	. i '$l(reportCode) s reportCode=$o(^[LABDATA]DHCReportPrintDefine("DEP",$e(ts),""))
	. i '$l(reportCode) q
	. //Set reportCode=..CheckTSANT(TSRowIDList,LABDATA,reportCode)   ;add by mcr  针对微生物需要区别药敏模板和一般结果模板
	. 
	. s gReportData=$g(^[LABDATA]DHCReportPrint(reportCode))
	. s ReportPage=$p(gReportData,"\",2)
	. s resultLineSpacing=+$p(gReportData,"\",3)   ///结果行间距
	. s resultRows=$p(gReportData,"\",4)           ///结果行数
	. s resultCols=$p(gReportData,"\",5)           ///结果列数 1,2
	. s HospCode=$p(gReportData,"\",6)
	. s ReportLayout=$p(gReportData,"\",7)
	. s micResultLineSpacing=+$p(gReportData,"\",12)
	. s micResultRows=$p(gReportData,"\",13)
	. s micResultCols=$p(gReportData,"\",14)
	. s archivesMargin=+$p(gReportData,"\",15)  ///报告存档 右移
	. s fixedReport=$p(gReportData,"\",16)     ///是否固定报告尾部 
	. s doubleColFillType=$p(gReportData,"\",17) ///双列结果打印填充类型 
	. s FixedSpacing=0
	. ///计算总页数------>
	. i resultCols=1 s TRows=resultRows
	. i resultCols=2 s TRows=resultRows*2
	. s TotalPage=((TSSumResult-1)\TRows)+1
	. ///微生物页数
	. s micSeq="" f  s micSeq=$o(^TMP("web.DHCLabReportPrint",$j,"Result",micSeq)) q:micSeq=""  d
	. .s tcDataList=$g(^TMP("web.DHCLabReportPrint",$j,"Result",micSeq))
	. .s tc=$p(tcDataList,$c(2),1)
	. .s tcType=$p($g(^TTAB("TC",tc)),"\",3)
	. .//i '$d(^TEPI(labno,1,ts,tscnt,"DATA",tc,"ANT")) s tcType="VN"   ///无抗生素结果是否换页
	. .i tcType="V",micSeq>1 s TotalPage=TotalPage+1
	. s ^TMP("web.DHCLabReportPrint",$j,"TotalPage",ord)=TotalPage
	. ///--------------------<
	. i fixedReport="N" d  ///计算尾部起始位置
	. .i resultCols=2 s FixedSpacing=+((resultRows-(TSSumResult/2))*resultLineSpacing)
	. .e  s FixedSpacing=+((resultRows-TSSumResult)*resultLineSpacing)  
	. ///输出报告格式用于打印机自动设置纸张类型，纸张方向，送纸来源，当前打印机
	. i CheckPaper="CHECKPAPER",$l(ReportPage),$l(HospCode),$d(^[LABDATA]DHCReportPrintPaper(HospCode,ReportPage)) d
	. .s (PrintFontSize,PrintFontStyle,PrintText,DataField,PrintFlag,PrintAlignment,PrintImageFile)=""
	. .s PrintType="PRINTER",(PrintFont,PrintX,PrintY,PrintLength,PrintWidth,PrintHeight)=0
	. .s DataField=$p(^[LABDATA]DHCReportPrintPaper(HospCode,ReportPage),"\",1)   ///纸张名称        
	. .s PrintWidth=$p(^[LABDATA]DHCReportPrintPaper(HospCode,ReportPage),"\",2)
	. .s PrintHeight=$p(^[LABDATA]DHCReportPrintPaper(HospCode,ReportPage),"\",3)
	. .s PrintAlignment=ReportLayout  ///纸张方向
	. .//s PrinterName="HP LaserJet 5000 Series PCL6"
	. .i $l(PrinterName) s PrintFlag=PrinterName    ///指定打印机打印
	. .s PrintFont=PaperSource  ///打印机送纸来源
	. .d OutputData
	. ///新页
	. i (ord>1) d
	. .s PrintType="PAGE"
	. .s (PrintX,PrintY,PrintFont,PrintFontSize,PrintFontStyle,PrintLength,PrintWidth,PrintHeight,PrintText,DataField,PrintFlag,PrintAlignment,PrintImageFile)=""
	. .d OutputData
	.
	. ///标签
	. d GetLabelData
	. ///数据
	. d GetDataData
	. ///线
	. d GetLineData
	. ///结果
	. d GetResultData
	. ///图形
	. d GetGraphData("END")
	
	///连续打印
	i A4Double="ContinuousPrint" d
	.s NewPage=0,NewPrintY=0,CurPrintY=0,iPage=0
	.s ord="" f  s ord=$o(^TMP("web.DHCLabReportPrint",$j,"CTPrint",ord)) q:ord=""  d
	..s NewPage=NewPage+1
	..i NewPage>1 s NewPrintY=CurPrintY+20
	..s PrintY="" f  s PrintY=$o(^TMP("web.DHCLabReportPrint",$j,"CTPrint",ord,PrintY)) q:PrintY=""  d
	...i (NewPrintY+PrintY+10)>1110 d 
	....s NewPage=1,NewPrintY=-PrintY
 	....///页码
 	....s iPage=iPage+1
 	....s PrintText="第"_iPage_"页" ///D:701:1078:宋体:9:Regular:0:101:20:demo:审核者:1:Left::
 	....s ^CacheTemp(repid,ind)=$lb("D","360","1150","宋体","9","Regular","0","110","20",PrintText,"","","","")
 	....s ind=ind+1
 	....//换页
	....s PrintType="PAGE"
 	....s ^CacheTemp(repid,ind)=$lb(PrintType,"","","","","","","","","","","","","")
 	....s ind=ind+1
 	...//重新输出
	...s CurPrintY=NewPrintY+PrintY
	...s PrintX="" f  s PrintX=$o(^TMP("web.DHCLabReportPrint",$j,"CTPrint",ord,PrintY,PrintX)) q:PrintX=""  d
	....s Data=$g(^TMP("web.DHCLabReportPrint",$j,"CTPrint",ord,PrintY,PrintX))
	....s $li(Data,3)=CurPrintY
 	....s ^CacheTemp(repid,ind)=Data
 	....s ind=ind+1	
	.///打印最后一页页码
	.i iPage>0 d
	..s iPage=iPage+1
 	..s PrintText="第"_iPage_"页" ///D:701:1078:宋体:9:Regular:0:101:20:demo:审核者:1:Left::
 	..s ^CacheTemp(repid,ind)=$lb("D","360","1150","宋体","9","Regular","0","110","20",PrintText,"","","","")
 	..s ind=ind+1	
	 
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputData
	s PrintX=archivesMargin+PrintX ///报告存档 右移

	///连续打印
	i A4Double="ContinuousPrint" d
	.i PrintType'="PAGE" d
	..s Data=$lb(PrintType,PrintX,PrintY,PrintFont,PrintFontSize,PrintFontStyle,PrintLength,PrintWidth,PrintHeight,PrintText,DataField,PrintFlag,PrintAlignment,PrintImageFile)
	..s ^TMP("web.DHCLabReportPrint",$j,"CTPrint",ord,PrintY,PrintX)=Data
	i A4Double="ContinuousPrint" Quit
	
	///A4双页打印
	i A4Double="A4Double",PrintType="PAGE" d 
	.i DoublePage=0 d
	..s DoublePage=1
	.e  d 
	..s DoublePage=0
	..s DoublePrintY=0
	i A4Double="A4Double",PrintType="PAGE",DoublePage=1 Quit
	i A4Double="A4Double",DoublePage=0,PrintY>DoublePrintY s DoublePrintY=PrintY
	i A4Double="A4Double",DoublePage=1 s PrintY=DoublePrintY+PrintY+10
	
	///普通打印
	set Data=$lb(PrintType,PrintX,PrintY,PrintFont,PrintFontSize,PrintFontStyle,PrintLength,PrintWidth,PrintHeight,PrintText,DataField,PrintFlag,PrintAlignment,PrintImageFile)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
	

GetResultData ///结果数据  
	s PrintNo=0,SumRows=0,tResultLineSpacing=0,tColsFlag=0,tMicNewPage=0
	s seq="" f  s seq=$o(^TMP("web.DHCLabReportPrint",$j,"Result",seq)) q:seq=""  d
	.s tcDataList=$g(^TMP("web.DHCLabReportPrint",$j,"Result",seq))
	.s tc=$p(tcDataList,$c(2),1)
	.s tcLabelList=$p(tcDataList,$c(2),2)
	.s SumRows=SumRows+1,iMultiRow=0
	.//报告换页处理--------->
	.s tNewPage=0
	.i resultCols=1 d
	..s iPage=(SumRows-1)/resultRows
	..i iPage>0,$E(iPage)=1 s tNewPage=1 
	.i resultCols=2 d
	..s iPage=(SumRows-1)/(resultRows*2)
	..i iPage>0,$E(iPage)=1 s tNewPage=1,SumRows=1
    .//微生物多细菌换页--->
    .s tcType=$p($g(^TTAB("TC",tc)),"\",3)
    .//i '$d(^TEPI(labno,1,ts,tscnt,"DATA",tc,"ANT")) s tcType="VN"   ///无抗生素结果是否换页
    .i tMicNewPage>0,$l(tc),tcType="V" s tNewPage=1,tMicNewPage=0
	.i tNewPage=1 d
	..d GetGraphData("0")  //补充图形LOGON
	..s PrintType="PAGE"
	..s (PrintX,PrintY,PrintFont,PrintFontSize,PrintFontStyle,PrintLength,PrintWidth,PrintHeight,PrintText,DataField,PrintFlag,PrintAlignment,PrintImageFile)=""
	..d OutputData
	..///换页重新获取报告信息
	..d GetLabelData
	..d GetDataData
	..d GetLineData
	..s tResultLineSpacing=0,tColsFlag=0  ///重新设置结果开始行
	.//---------------------<
	.i $l(tc) s PrintNo=PrintNo+1
	.i (SumRows>1),(tNewPage=0) s tResultLineSpacing=tResultLineSpacing+resultLineSpacing
	.f ik=1:1:11 d
	..s tCol="1"
	..i (doubleColFillType="Left") d
	...i (SumRows>resultRows),(resultCols=2) s tCol="2",tColsFlag=tColsFlag+1  ///双列左填充打印
	..e  d
	...i (SumRows>((TSSumResult\2)+(TSSumResult#2))),(resultCols=2) s tCol="2",tColsFlag=tColsFlag+1  ///双列平均打印
	..i resultCols=2,tc="L",$p(tcLabelList,"@",2)="Y" s tCol="2",tColsFlag=1,SumRows=resultRows     ///项目标签换列
	..i tColsFlag=1 s tResultLineSpacing=0 ///双列打印从头计算
	..i ik=1 s ItemField="序号"_tCol
	..i ik=2 s ItemField="项目名称"_tCol
	..i ik=3 s ItemField="缩写"_tCol
	..i ik=4 s ItemField="结果"_tCol
	..i ik=5 s ItemField="标志"_tCol
	..i ik=6 s ItemField="单位"_tCol
	..i ik=7 s ItemField="参考范围"_tCol
	..i ik=8 s ItemField="实验方法"_tCol
	..i ik=9 s ItemField="结果二"_tCol
	..i ik=10 s ItemField="结果三"_tCol
	..i ik=11 s ItemField="结果四"_tCol
	..s ItemCode=$o(^[LABDATA]DHCReportPrint(reportCode,"FIELD","R",ItemField,""))
	..i $l(ItemCode) d
	...s ItemData=$g(^[LABDATA]DHCReportPrint(reportCode,"ITEM",ItemCode))
	...s PrintType=$p(ItemData,"\",1)
	...s PrintX=$p(ItemData,"\",2)
	...s PrintY=$p(ItemData,"\",3)+tResultLineSpacing ///结果间距
	...s PrintFont=$p(ItemData,"\",4)
	...s PrintFontSize=$p(ItemData,"\",5)
	...s PrintFontStyle=$p(ItemData,"\",6)
	...s PrintLength=+$p(ItemData,"\",7)
	...s PrintWidth=$p(ItemData,"\",8)
	...s PrintHeight=$p(ItemData,"\",9)
	...s PrintText=$p(ItemData,"\",10)
	...s DataField=$p(ItemData,"\",11)
	...s PrintFlag=$p(ItemData,"\",12)
	...s PrintAlignment=$p(ItemData,"\",13)
	...s PrintImageFile=""
	...i ik=1 s PrintText=PrintNo
	...i ik=2 s PrintText=$p(tcDataList,$c(2),2)
	...i ik=3 s PrintText=$p(tcDataList,$c(2),3)
	...i ik=4 s PrintText=$p(tcDataList,$c(2),4)
	...i ik=5 s PrintText=$p(tcDataList,$c(2),5)
	...i ik=6 s PrintText=$p(tcDataList,$c(2),6)
	...i ik=7 s PrintText=$p(tcDataList,$c(2),7)
	...i ik=8 s PrintText=$p(tcDataList,$c(2),8)
	...i ik=9 s PrintText=$p(tcDataList,$c(2),9)
	...i ik=10 s PrintText=$p(tcDataList,$c(2),10)
	...i ik=11 s PrintText=$p(tcDataList,$c(2),11)
	...s TxtLen=$L(PrintText)
	...i PrintLength=0 s PrintLength=40  ///设置缺省换行长度
	...///打印项目标签处理---->L@Y@干化学@宋体@12@Bold
	...i tc="L",ik=2 d
	....s PrintText=$p(tcLabelList,"@",3)
	....s tPrintFont=$p(tcLabelList,"@",4)
	....s tPrintFontSize=$p(tcLabelList,"@",5)
	....s tPrintFontStyle=$p(tcLabelList,"@",6)
	....i $l(tPrintFont) s PrintFont=tPrintFont
	....i $l(tPrintFontSize) s PrintFontSize=tPrintFontSize
	....i $l(tPrintFontStyle) s PrintFontStyle=tPrintFontStyle
	...///--------------------<
	...i $l(PrintText,lfcr)>1 d  ///包含$c(10,13)换行处理
	....s tPrintText=PrintText,tPrintY=PrintY
	....f il=1:1:$l(tPrintText,lfcr) d
	.....s iMultiRow=iMultiRow+1
	.....s PrintText=$p(tPrintText,lfcr,il)
	.....i '$l(PrintText) q
	.....s PrintY=tPrintY+(resultLineSpacing*(iMultiRow-1))
	.....d OutputData
	...e  d
	....i TxtLen>PrintLength d    ///字符超长度换行处理
	.....s tPrintText=PrintText,tPrintY=PrintY
	.....f il=1:PrintLength:$l(tPrintText) d
	......s it=PrintLength+il-1
	......s iMultiRow=iMultiRow+1
	......s PrintText=$e(tPrintText,il,it)
	......i '$l(PrintText) q
	......s PrintY=tPrintY+(resultLineSpacing*(iMultiRow-1))
	......d OutputData
	....e  d OutputData
	.///计算换行
	.i iMultiRow>0 s tResultLineSpacing=tResultLineSpacing+(resultLineSpacing*(iMultiRow-1))
	.///微生物数据
	.s micPrintY=0,bPrintMIC=0
	.i $l(tc),$p($g(^TTAB("TC",tc)),"\",3)="V" s micPrintY=PrintY+resultLineSpacing
	.d GetMicroData
	.i bPrintMIC>0 s tResultLineSpacing=tResultLineSpacing+(bPrintMIC-micPrintY)+resultLineSpacing
	q
	
GetMicroData
  ///获取药敏数据
  s num=+##Class(web.DHCLabReportPrint).GetAntData(labno,ts,tscnt,tc)
  i num=0 q
  ///微生物打印数据 
  s tMicStartPrintY=micPrintY,tAbsoluteY=0,TCSumAnts=num
  ///微生物数据标签,线
  s iMicRows=0
  s ItemCode="" f  s ItemCode=$o(^[LABDATA]DHCReportPrint(reportCode,"FLAG","MIC",ItemCode)) q:ItemCode=""  d
	.s ItemData=$g(^[LABDATA]DHCReportPrint(reportCode,"ITEM",ItemCode))
	.s PrintType=$p(ItemData,"\",1)
	.s PrintX=$p(ItemData,"\",2)
	.s PrintY=$p(ItemData,"\",3)
	.s iMicRows=iMicRows+1
	.i iMicRows=1 s tAbsoluteY=PrintY,PrintY=tMicStartPrintY
	.e  s PrintY=(PrintY-tAbsoluteY)+tMicStartPrintY
	.s PrintFont=$p(ItemData,"\",4)
	.s PrintFontSize=$p(ItemData,"\",5)
	.s PrintFontStyle=$p(ItemData,"\",6)
	.s PrintLength=$p(ItemData,"\",7)
	.s PrintWidth=$p(ItemData,"\",8)
	.s PrintHeight=$p(ItemData,"\",9)
	.s PrintText=$p(ItemData,"\",10)
	.s DataField=$p(ItemData,"\",11)
	.s PrintFlag=$p(ItemData,"\",12)
	.s PrintAlignment=$p(ItemData,"\",13)
	.s PrintImageFile=""
	.d OutputData
	.i PrintY>bPrintMIC s bPrintMIC=PrintY
  ///微生物结果
  s iMicRows=0,tMicColsFlag=0,iNewLine=0
  s nums="" f  s nums=$o(^TMP("web.DHCLabReportPrint",$j,"ANTDATA",nums)) q:nums=""  d
  .s tmpListData=$g(^TMP("web.DHCLabReportPrint",$j,"ANTDATA",nums))
  .s iMicRows=iMicRows+1
  .f ik=1:1:5 d
  ..s tCol="1"
  ..i doubleColFillType="Left",micResultCols=2 d
  ...i (nums>micResultRows) s tCol="2",tMicColsFlag=tMicColsFlag+1  ///双列左填充打印
  ..e  d
  ...i (nums>((TCSumAnts\2)+(TCSumAnts#2))) s tCol="2",tMicColsFlag=tMicColsFlag+1  ///双列平均打印
  ..i tMicColsFlag=1 s iNewLine=0,iMicRows=1  ///双列换行从头计算
  ..i ik=1 s ItemField="抗生素序号"_tCol
  ..i ik=2 s ItemField="抗生素名"_tCol
  ..i ik=3 s ItemField="MM"_tCol
  ..i ik=4 s ItemField="MIC"_tCol
  ..i ik=5 s ItemField="敏感度"_tCol
  ..s ItemCode=$o(^[LABDATA]DHCReportPrint(reportCode,"FIELD","M",ItemField,""))
  ..i $l(ItemCode) d
	...s ItemData=$g(^[LABDATA]DHCReportPrint(reportCode,"ITEM",ItemCode))
	...s PrintType=$p(ItemData,"\",1)
	...s PrintX=$p(ItemData,"\",2)
	...s PrintY=$p(ItemData,"\",3) 
	...i iMicRows=1 s PrintY=(PrintY-tAbsoluteY)+tMicStartPrintY
	...e  s PrintY=(PrintY-tAbsoluteY)+tMicStartPrintY+(micResultLineSpacing*(iMicRows-1))+iNewLine
	...s PrintFont=$p(ItemData,"\",4)
	...s PrintFontSize=$p(ItemData,"\",5)
	...s PrintFontStyle=$p(ItemData,"\",6)
	...s PrintLength=+$p(ItemData,"\",7)
	...s PrintWidth=$p(ItemData,"\",8)
	...s PrintHeight=$p(ItemData,"\",9)
	...s PrintText=$p(ItemData,"\",10)
	...s DataField=$p(ItemData,"\",11)
	...s PrintFlag=$p(ItemData,"\",12)
	...s PrintAlignment=$p(ItemData,"\",13)
	...s PrintImageFile=""
	...///add by mcr 药敏分组,此处可根据实际需要在做格式的调整 20140122
	...I $p(tmpListData,$c(2))="ANTCLASS" S PrintFontSize=PrintFontSize+1,PrintFontStyle="Bold"
	...i ik=1 s PrintText=nums
	...i ik=2 s PrintText=$p(tmpListData,$c(2),2)
	...i ik=3 s PrintText=$p(tmpListData,$c(2),3)
	...i ik=4 s PrintText=$p(tmpListData,$c(2),4)
	...i ik=5 s PrintText=$p(tmpListData,$c(2),5)
	...s TxtLen=$L(PrintText)
	...i PrintLength=0 s PrintLength=40  ///设置缺省换行长度
	...i TxtLen>PrintLength d    ///换行处理
	....s tPrintText=PrintText,tPrintY=PrintY
	....f il=1:PrintLength:$l(tPrintText) d
	.....s it=PrintLength+il-1
	.....s PrintText=$e(tPrintText,il,it)
	.....i '$l(PrintText) q
	.....d OutputData
	.....i PrintY>bPrintMIC s bPrintMIC=PrintY
	.....s iNewLine=iNewLine+micResultLineSpacing
	.....s PrintY=tPrintY+iNewLine
	...e  d  
	....d OutputData
	....i PrintY>bPrintMIC s bPrintMIC=PrintY
	i bPrintMIC>0 s tMicNewPage=tMicNewPage+1  ///定义微生物结果位置
	q	
	
GetLabelData  ///标签数据
	s ItemCode="" f  s ItemCode=$o(^[LABDATA]DHCReportPrint(reportCode,"TYPE","L",ItemCode)) q:ItemCode=""  d
	.s ItemData=$g(^[LABDATA]DHCReportPrint(reportCode,"ITEM",ItemCode))
	.s PrintType=$p(ItemData,"\",1)
	.s PrintX=$p(ItemData,"\",2)
	.s PrintY=$p(ItemData,"\",3)
	.s PrintFont=$p(ItemData,"\",4)
	.s PrintFontSize=$p(ItemData,"\",5)
	.s PrintFontStyle=$p(ItemData,"\",6)
	.s PrintLength=$p(ItemData,"\",7)
	.s PrintWidth=$p(ItemData,"\",8)
	.s PrintHeight=$p(ItemData,"\",9)
	.s PrintText=$p(ItemData,"\",10)
	.s DataField=$p(ItemData,"\",11)
	.s PrintFlag=$p(ItemData,"\",12)
	.s PrintAlignment=$p(ItemData,"\",13)
	.i PrintFlag="MIC" q ///微生物数据单独获取
	.s PrintImageFile=""
	.///活动报告尾部处理
	.s PrintFixedItem=$p(ItemData,"\",15)
	.i fixedReport="N",PrintFixedItem="N" s PrintY=PrintY-FixedSpacing 
	.d OutputData
	q
GetDataData ///数据
	s ItemCode="" f  s ItemCode=$o(^[LABDATA]DHCReportPrint(reportCode,"TYPE","D",ItemCode)) q:ItemCode=""  d
	.s ItemData=$g(^[LABDATA]DHCReportPrint(reportCode,"ITEM",ItemCode))
	.s PrintType=$p(ItemData,"\",1)
	.s PrintX=$p(ItemData,"\",2)
	.s PrintY=$p(ItemData,"\",3)
	.s PrintFont=$p(ItemData,"\",4)
	.s PrintFontSize=$p(ItemData,"\",5)
	.s PrintFontStyle=$p(ItemData,"\",6)
	.s PrintLength=$p(ItemData,"\",7)
	.s PrintWidth=$p(ItemData,"\",8)
	.s PrintHeight=$p(ItemData,"\",9)
	.s PrintText=""
	.s DataField=$p(ItemData,"\",11)
	.s PrintFlag=$p(ItemData,"\",12)
	.s PrintAlignment=$p(ItemData,"\",13)
	.s PrintImageFile=""
	.///活动报告尾部处理
	.s PrintFixedItem=$p(ItemData,"\",15)
	.i fixedReport="N",PrintFixedItem="N" s PrintY=PrintY-FixedSpacing 
	.i $l(DataField),$d(^[LABDATA]DHCPatReportOrder("D",DataField)) s PrintText=$p(ReportInfo,$c(2),+$g(^[LABDATA]DHCPatReportOrder("D",DataField)))
	.///用户图形签名处理
	.i PrintFlag="D" d ///(DataField="接收者")||(DataField="操作者")||(DataField="审核者") d
	..s usrName=$p(ReportInfo,$c(2),+$g(^[LABDATA]DHCPatReportOrder("D",DataField)))
	..s usrName=$$ALPHAUP^SSUTIL4(usrName),usrCode=""
	..i $l(usrName) s usrCode=$o(^[LABDATA]SSU("SSUSR","Name",usrName,""))
	..i $l(usrCode),$d(^["DHCLABDATA"]DHCLAB.DHCReportPrintGraphD(usrCode)) d
	...s sttDate=$o(^["DHCLABDATA"]DHCLAB.DHCReportPrintGraphD(usrCode,""),-1)
	...i $l(sttDate) s DataField=usrCode_"||"_sttDate,PrintType="G",PrintFlag="D"
	.i PrintFlag="MIC" q  ///微生物数据单独获取
	.///页码数据输出
	.i DataField="页码" d
	..i '$d(^TMP("web.DHCLabReportPrint",$j,"PageNum",ord)) s ^TMP("web.DHCLabReportPrint",$j,"PageNum",ord)=1
	..e  s ^TMP("web.DHCLabReportPrint",$j,"PageNum",ord)=+$g(^TMP("web.DHCLabReportPrint",$j,"PageNum",ord))+1
	..s iPage=+$g(^TMP("web.DHCLabReportPrint",$j,"PageNum",ord))
	..s TotalPage=$g(^TMP("web.DHCLabReportPrint",$j,"TotalPage",ord))
	..s PrintText="第"_iPage_"页,共"_TotalPage_"页"
	.d OutputData
	q
GetLineData  ///线
	s ItemCode="" f  s ItemCode=$o(^[LABDATA]DHCReportPrint(reportCode,"TYPE","I",ItemCode)) q:ItemCode=""  d
	.s ItemData=$g(^[LABDATA]DHCReportPrint(reportCode,"ITEM",ItemCode))
	.s PrintType=$p(ItemData,"\",1)
	.s PrintX=$p(ItemData,"\",2)
	.s PrintY=$p(ItemData,"\",3)
	.s PrintFont=$p(ItemData,"\",4)
	.s PrintFontSize=$p(ItemData,"\",5)
	.s PrintFontStyle=$p(ItemData,"\",6)
	.s PrintLength=$p(ItemData,"\",7)
	.s PrintWidth=$p(ItemData,"\",8)
	.s PrintHeight=$p(ItemData,"\",9)
	.s PrintText=$p(ItemData,"\",10)
	.s DataField=$p(ItemData,"\",11)
	.s PrintFlag=$p(ItemData,"\",12)
	.s PrintAlignment=$p(ItemData,"\",13)
	.i PrintFlag="MIC" q  ///微生物数据单独获取
	.s PrintImageFile=""
	.///活动报告尾部处理
	.s PrintFixedItem=$p(ItemData,"\",15)
	.i fixedReport="N",PrintFixedItem="N" s PrintY=PrintY-FixedSpacing 
	.d OutputData	
	q

GetGraphData(gFlag)  ///图形
	s ItemCode="" f  s ItemCode=$o(^[LABDATA]DHCReportPrint(reportCode,"TYPE","G",ItemCode)) q:ItemCode=""  d
	.s ItemData=$g(^[LABDATA]DHCReportPrint(reportCode,"ITEM",ItemCode))
	.s PrintType=$p(ItemData,"\",1)
	.s PrintX=$p(ItemData,"\",2)
	.s PrintY=$p(ItemData,"\",3)
	.s PrintFont=$p(ItemData,"\",4)
	.s PrintFontSize=$p(ItemData,"\",5)
	.s PrintFontStyle=$p(ItemData,"\",6)
	.s PrintLength=$p(ItemData,"\",7)
	.s PrintWidth=$p(ItemData,"\",8)
	.s PrintHeight=$p(ItemData,"\",9)
	.s PrintText=$p(ItemData,"\",10)
	.s DataField=$tr($p(ItemData,"\",11)," ")
	.s tDataField=DataField
	.i (gFlag="END"),$l(DataField),$d(^TMP("web.DHCLabReportPrint",$j,"Graph",labno,DataField)) d
	..s DataField=$g(^TMP("web.DHCLabReportPrint",$j,"Graph",labno,DataField))  ///图形RowID
	.s PrintFlag=$p(ItemData,"\",12)
	.s PrintAlignment=$p(ItemData,"\",13)
	.s PrintImageFile=$p(ItemData,"\",14)
	.///获取医院Logo图形打印 数据暂时放入用户图形签名
	.i $l(tDataField),(PrintFlag="D") d
	..i $d(^["DHCLABDATA"]DHCLAB.DHCReportPrintGraphD(tDataField)) d
	...s sttDate=$o(^["DHCLABDATA"]DHCLAB.DHCReportPrintGraphD(tDataField,""),-1)
	...i $l(sttDate) s DataField=tDataField_"||"_sttDate
	.d OutputData	
	q
}

ClassMethod QueryPrintDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryPrintDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryPrintDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryPrintDataExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

ClassMethod CheckSum(x) As %Integer
{
  s z=0 
  f y=1:1:$l(x) d
  .s t=$e(x,y)
  .i $a(t)>128 s z=z+2
  .e  s z=z+1 
  q z
}

/// 获取病人信息
ClassMethod GetReportInfo(TSRowIDList As %String) As %String
{
	s TSRowIDList=$g(TSRowIDList)
	Set Config=##Class(websys.Configuration).%OpenId(1)
	Set LABDATA=Config.LabDataNamespace
	If '$Length(LABDATA) Set LABDATA="LABDATA"
	
	s TSRowId=$p(TSRowIDList,"#",1)
	
	s labno=$p(TSRowId,"||",1),ts=$p(TSRowId,"||",2),tscnt=$p(TSRowId,"||",3)
	s RetStr=""
	i '$d(^TEPI(labno,1,ts,tscnt)) q RetStr
	s resstatus=$p(^TEPI(labno,1,ts,tscnt),"\",31)
	//i resstatus'="A" q RetStr  //是否是审核报告 for 微生物报告预览
    s gName=$p(^TEPI(labno),"\",1)
    s sName=$p(^TEPI(labno),"\",2)
    s patName=gName_" "_sName
    i gName=sName s patName=gName
    s patSex=""				;性别
    s spcode=$p(^TEPI(labno),"\",3)
    i spcode'="",$d(^TTAB("SP",spcode)) s patSex=$p(^TTAB("SP",spcode),"\",1)
    s patDOB=$p(^TEPI(labno),"\",4)
    i $l(patDOB) s patDOB=$zd(patDOB,3)
    s patAge=##Class(web.DHCLabReportPrint).GetPatAge(patDOB,labno)
    //
    s patDebtor=$p(^TEPI(labno),"\",18) ;登记号
    s specode=$p(^TEPI(labno,1,ts,tscnt),"\",46) ;标本类型
    
    s tsName=$p(^TTAB("TS",ts),"\",1)
    f tcount=2:1:$l(TSRowIDList,"#") d
    .s tempts=$p($p(TSRowIDList,"#",tcount),"||",2)
    .i '$l(tempts) q
    .s tsName=tsName_"+"_$p(^TTAB("TS",tempts),"\",1)
    s tsSpecimen=""
    i specode'="",$d(^TTAB("SPEC",specode)) s tsSpecimen=$p(^TTAB("SPEC",specode),"\",1)
    i $l(tsSpecimen,"(")>1 s tsSpecimen=$p(tsSpecimen,"(",1)
    //
    s patLoc=""					   ;科室
    s loccode=$p(^TEPI(labno),"\",36) 
    i loccode'="",$d(^TTAB("USLOC",loccode)) s patLoc=$p($g(^TTAB("USLOC",loccode)),"\",1)
    s patloc1=$p(patLoc,"-",1),patloc2=$p(patLoc,"-",2)
    i $l(patloc2)  d
    .s patLoc=patloc2
    e  d
    .s patLoc=patloc1 

    s (patPhone,patAddress,room,bed,bloodGroup,patWard)=""
 	//病区
	s tempatwarddr=$p(^TEPI(labno),"\",20)
	i $l(tempatwarddr),$d(^TTAB("RH",tempatwarddr)) s patWard=$p(^TTAB("RH",tempatwarddr),"\",1)
	i $l(patWard,"-")>1 s patWard=$p(patWard,"-",2)

    i $d(^TEPI(labno,0)) d
	.s patPhone=$p(^TEPI(labno,0),"\",12)
	.s patAddress=$p(^TEPI(labno,0),"\",1)
    .s room=$p(^TEPI(labno,0),"\",28)  ;房间号
    .s bed=$p(^TEPI(labno,0),"\",29)	 ;床号
	//血型
	i $l(patDebtor),$d(^TDEB(patDebtor)) d
	.s bloodGroup=$p(^TDEB(patDebtor),"\",4)
	.i bloodGroup'="",$d(^TTAB("BB-BG",bloodGroup)) s bloodGroup=$p(^TTAB("BB-BG",bloodGroup),"\",1)

    //申请日期
    s requestDate=$p(^TEPI(labno),"\",12) 
    i $l(requestDate) s requestDate=$zd(requestDate,3) 
	s requestTime=$p(^TEPI(labno),"\",50)
	i $l(requestTime) s requestTime=$zt(requestTime,2)
    ///接收
    s recdate1=$p(^TEPI(labno,1,ts,tscnt),"\",21)
    s rectime1=$p(^TEPI(labno,1,ts,tscnt),"\",22)
    s recusr1=$p(^TEPI(labno,1,ts,tscnt),"\",36)
    
    ///统一接收  20140710
    s prerecdate1=$p(^TEPI(labno,1,ts,tscnt),"\",57)
    s prerectime1=$p(^TEPI(labno,1,ts,tscnt),"\",58)
    s prerecusr1=$p(^TEPI(labno,1,ts,tscnt),"\",67)
    i $l(prerecdate1) d
    .s tdate=prerecdate1
    .s prerecdate1=recdate1
    .s recdate1=tdate
    i $l(prerectime1) d
    .s ttime=prerectime1/60
    .s prerectime1=rectime1
    .s rectime1=ttime
       
    s entrydate1=$p(^TEPI(labno,1,ts,tscnt),"\",1)
    s entrytime1=$p(^TEPI(labno,1,ts,tscnt),"\",2)
    s entryusr1=$p(^TEPI(labno,1,ts,tscnt),"\",3)
    s authdate1=$p(^TEPI(labno,1,ts,tscnt),"\",4)
    s authtime1=$p(^TEPI(labno,1,ts,tscnt),"\",5)
    s authusr1=$p(^TEPI(labno,1,ts,tscnt),"\",6) 
    //				
    s (colDate,colTime,machine)=""
    s specode=$p(^TEPI(labno,1,ts,tscnt),"\",46) ;标本类型
    s machdr=$p(^TEPI(labno,1,ts,tscnt),"\",27)
    i machdr'="",$d(^TMIF(machdr)) s machine=$p(^TMIF(machdr),"\",1)
    s flowNo=$p(^TEPI(labno,1,ts,tscnt),"\",12)
  
    s coldate1=$p(^TEPI(labno,1,ts,tscnt),"\",44)
    i coldate1'="" s colDate=$zd(coldate1,3)
    s coltime1=$p(^TEPI(labno,1,ts,tscnt),"\",45)
    i coltime1'="" s colTime=$zt(coltime1,2)
    //
    s docName=""					;医生
    s doccode=$p(^TEPI(labno),"\",13)
    i doccode'="",$d(^TTAB("DR",doccode)) s docName=$p(^TTAB("DR",doccode),"\",1)
    i $l(docName,"(") s docName=$p(docName,"(",1)  
    //
    s (recDate,recTime,recUser,entryDate,entryTime,entryUser,authDate,authTime,authUser)=""
    i recdate1'="" s recDate=$zd(recdate1,3)  ;接收日期
    i rectime1'="" s recTime=$zt(rectime1*60,2)  ;接收时间
    i recusr1'="",$d(^[LABDATA]SSU("SSUSR",1,recusr1)) s recUser=$p(^[LABDATA]SSU("SSUSR",1,recusr1),"^",2)
    i entrydate1'="" s entryDate=$zd(entrydate1,3) ;录入日期
    i entrytime1'="" s entryTime=$zt(entrytime1*60,2) ;录入时间
    i entryusr1'="",$d(^[LABDATA]SSU("SSUSR",1,entryusr1)) s entryUser=$p(^[LABDATA]SSU("SSUSR",1,entryusr1),"^",2)
    i authdate1'="" s authDate=$zd(authdate1,3) ;核实日期
    i authtime1'="" s authTime=$zt(authtime1*60,2) ;核实时间
    i authusr1'="",$d(^[LABDATA]SSU("SSUSR",1,authusr1)) s authUser=$p(^[LABDATA]SSU("SSUSR",1,authusr1),"^",2)
    
    s (prerecdate,prerectime,prerecusr)=""
    i $l(prerecdate1) s prerecdate=$zd(prerecdate1,3)
    i $l(prerectime1) s prerectime=$zt(prerectime1*60,2)
    i $l(prerecusr1) s prerecusr=$p($g(^[LABDATA]SSU("SSUSR",1,prerecusr1)),"^",2)
    
    //预置条码
    s SecondLabno=##Class(web.DHCLabReportPrint).GetSndLabNo(labno,LABDATA)
    //诊断
    s patDiag=""
    i $d(^TEPI(labno,8)) s patDiag=$p(^TEPI(labno,8),"\",15)
    s printDateTime=$zd(+$h,3)_" "_$zt($p($h,",",2))
    s departName=$p($g(^TTAB("DEP",$E(ts))),"\",1)  
    s departPhone=$p($p($g(^TTAB("DEP",$E(ts))),"\",2),"#",2)
    s hospNo=##Class(web.DHCLabReportPrint).GetHospnoByDebno(patDebtor,labno)
	//检验备注 取相应科室的9999项目结果 在项目中不打印
	s labMemo=""
	i $d(^TEPI(labno,1,ts,tscnt,"DATA",$e(ts)_"9999")) d
	.s labMemo=$tr($p(^TEPI(labno,1,ts,tscnt,"DATA",$e(ts)_"9999"),"\",1),$c(13,10)," ")

    //1登记号,2姓名,3性别,4年龄,5出生日期,6医嘱名称,7标本,8诊断,9仪器名称,10流水号
    //11病案号,12科室,13病区,14病房,15床号,16血型,17电话,18地址
    //19申请医生,20申请日期,21申请时间,22采集日期,23采集时间,24接收者,25接收日期,26接收时间
    //27操作者,28操作日期,29操作时间,30审核者,31审核日期,32审核时间,33检验号
    //34打印日期,35检验科室,36科室电话,37医嘱备注
    //38集中接收日期,39集中接收时间,40集中接收用户
    s RetStr=patDebtor_$c(2)_patName_$c(2)_patSex_$c(2)_patAge_$c(2)_patDOB_$c(2)_tsName_$c(2)_tsSpecimen_$c(2)_patDiag_$c(2)_machine_$c(2)_flowNo
    s RetStr=RetStr_$c(2)_hospNo_$c(2)_patLoc_$c(2)_patWard_$c(2)_room_$c(2)_bed_$c(2)_bloodGroup_$c(2)_patPhone_$c(2)_patAddress
    s RetStr=RetStr_$c(2)_docName_$c(2)_requestDate_$c(2)_requestTime_$c(2)_colDate_$c(2)_colTime_$c(2)_recUser_$c(2)_recDate_$c(2)_recTime
    s RetStr=RetStr_$c(2)_entryUser_$c(2)_entryDate_$c(2)_entryTime_$c(2)_authUser_$c(2)_authDate_$c(2)_authTime_$c(2)_SecondLabno
  	s RetStr=RetStr_$c(2)_printDateTime_$c(2)_departName_$c(2)_departPhone_$c(2)_labMemo
  	s RetStr=RetStr_$c(2)_prerecdate_$c(2)_prerectime_$c(2)_prerecusr
  	q RetStr
}

/// 根据检验号取得预置条码号
ClassMethod GetSndLabNo(Labno, Labdata) As %String
{
   s SndLabNo=""
   i $p(^[Labdata]CF("LAB",1),"^",60)="Y" d
   .i $d(^[Labdata]DHCSecondLabNo(Labno))>0 s SndLabNo=$o(^[Labdata]DHCSecondLabNo(Labno,""))
   e  d
   .s SndLabNo=Labno 
   i '$l(SndLabNo) d
   .i $p(^[Labdata]CF("LAB",1),"^",60)="Y",$d(^[Labdata]DHCSndLabNo(Labno)) s SndLabNo=$p(^[Labdata]DHCSndLabNo(Labno),"\",1)
   .e  s SndLabNo=Labno
   q SndLabNo
}

ClassMethod GetPatAge(dob, labno) As %String
{
  //n (dob,labno)
  s dob=$g(dob),labno=$g(labno)
  //s age=$p(^TEPI(labno),"\",25)
  i '$l(dob) s dob=$p(^TEPI(labno),"\",4)
  s InAge=$$GetAge(dob,labno)
  s ret=""
  s PatAge=$p(InAge,$c(1),1),AgeType=$p(InAge,$c(1),2)
  i $l(PatAge),$p(PatAge,".",1)="" s PatAge="0"_PatAge
  i '$l(PatAge) q ret
  i AgeType="0" s ret=PatAge_"岁"
  i AgeType="1" s ret=PatAge_"月"
  i AgeType="2" s ret=PatAge_"天"
  i AgeType="3" s ret=PatAge_"小时"
  q ret 
GetAge(dob,labno)   ///n (dob,labno)
  s dob=$g(dob),labno=$g(labno)
  //年龄不空
  s age=$p(^TEPI(labno),"\",25)
  i age="0" s age=""
  s temageunit=""
  //年龄单位  6.3->6.4
  i $d(^TEPI(labno,8)) s temageunit=$p(^TEPI(labno,8),"\",17)   ;6.4
  s (ret1,ret2)=""
  i $l(temageunit) d
  .i temageunit="0" s ret1=age
  .i temageunit="1",$l(age) s ret1=(age*1000)/30
  .i temageunit="2",$l(age) s ret1=age*1000
  .i temageunit="3",$l(age) s ret1=age*100000
  .i temageunit="4",$l(age) s ret1=age*10000000
  .s ret2=temageunit
  e  d
  .i $l(age) d
  ..i age'<1 d
  ...s ret1=age
  ...s ret2="0"
  ..e  d
  ...s ret1=age*1000
  ...i ret1'<1  d
  ....s ret2="2"
  ...e  d
  ....s ret1=ret1*100
  ....s ret2="3"
  s InAge=""
  i $l(ret1) s InAge=ret1_$c(1)_ret2
  //判断小时 DaiYi 2012-12-02
  if ret2=3,ret1<1 Do
  .Set ret1=0.2*60
  .Set ret2=4
  .Set InAge=ret1_$c(1)_ret2
  i $l(InAge) q InAge
  ;i '$l(labno) 
  s curdate=+$h
  s temage="",ageunit=0
  i dob d
  .s temstr=$$CalAge(dob,curdate)
  .s temage=$p(temstr,"|",12),temmon=$p(temstr,"|",13),temday=$p(temstr,"|",14)
  .i temage s EPA25=temage q
  .i temmon s EPA25=temmon*30/1000,temage=temmon,ageunit="1" q    //wwh 2010-10-28
  .i temday s EPA25=temday/1000,temage=temday,ageunit="2"         //wwh 2010-10-28
  //判断小时 DaiYi 2012-12-02
  if ageunit=3,temage<1 Do
  .Set temage=0.2*60
  .Set ageunit=4
  q temage_$c(1)_ageunit 
  
CalAge(IBirth,IToday,EstMth,EstYr,EstStamp) 
 ; pass in date of birth in internal format
 ;
 ///n XBirth,XToday,AgeDay,AgeMth,AgeYear,CurrMth,CurrYear,AgeYr,UseDOB
 ;
 s IBirth=$g(IBirth),IToday=$g(IToday)
 //---------------------------------------wwh 2010-10-28
 I IBirth?1.4N1"-"1.2N1"-"1.2N D
 .S IBirth=$ZDH(IBirth,3)
 //---------------------------------------
 ;hack of date of birth
 i IBirth>2980000 s IBirth=""
 i IBirth<0 s IBirth=""
 q:'$G(IBirth) ""
 ;
 s XBirth=$ZD(IBirth)
 s XToday=$ZD(IToday)
 s AgeMth=XToday-XBirth
 s AgeDay=$p(XToday,"/",2)-$p(XBirth,"/",2)
 s CurrYear=$p(XToday,"/",3) s:CurrYear<100 CurrYear=CurrYear+1900
 s BirthYear=$p(XBirth,"/",3) s:BirthYear<100 BirthYear=BirthYear+1900
 s AgeYear=CurrYear-BirthYear
 ;
 i AgeDay<0 d
 . s AgeMth=AgeMth-1
 . s AgeDay=AgeDay+$p("31,31,28,31,30,31,30,31,31,30,31,30,31",",",+XToday)
 . q:XToday'=2
 . s:((CurrYear#4)=0)&(((CurrYear#100)'=0)!((CurrYear#400)=0)) AgeDay=AgeDay+1
 i AgeMth<0 s AgeMth=AgeMth+12,AgeYear=AgeYear-1
 ;
 s $P(AgeYr,"|",12)=AgeYear
 q AgeYr_"|"_AgeMth_"|"_AgeDay
}

ClassMethod GetHospnoByDebno(debno, labno) As %String
{
    s debno=$g(debno),labno=$g(labno)
    i '$l(labno) q ""
    s type=$p($g(^TEPI(labno)),"\",48)
    //根据检验号得到病案号
    s hospno=""
    i type="GP" d
    .s hospno=$o(^TDEBi(debno,"HOSPITAL",""),-1)
    e  d
    .s hospno=$p($g(^TEPI(labno)),"\",6)
    .i type=$e(hospno) s hospno=$e(hospno,2,$l(hospno))
    q hospno
}

/// 报告RowID合并  
ClassMethod TakeTSRowID(TSRowIDs As %String)
{
	s ^TMP("web.DHCLabReportPrint","PARAM","TakeTSRowID")=TSRowIDs
	k ^TMP("web.DHCLabReportPrint",$j,"RowID")
	f temi=1:1:$L(TSRowIDs,"^") d
 	.s tRowIDs=$p(TSRowIDs,"^",temi)
 	.q:'$l(tRowIDs)
	.f temj=1:1:$l(tRowIDs,"#") d
	..s tRowID=$p(tRowIDs,"#",temj)
	..q:'$l(tRowID)
	..s labno=$p(tRowID,"||",1),ts=$p(tRowID,"||",2),tscnt=$p(tRowID,"||",3)
	..i $l(ts),$d(^TTAB("TS",ts,"XM")) q  ///配血实验结果暂时不打印
 	..s mi=$p(^TEPI(labno,1,ts,tscnt),"\",27)
  	..i '$l(mi) s mi=$e(ts,1)  //仪器为空设置为科室缺省仪器 
	..s epis=$p(^TEPI(labno,1,ts,tscnt),"\",12)
	..i '$l(epis) s epis="ZNULL"
	..s authdate=$p(^TEPI(labno,1,ts,tscnt),"\",4)
	..i '$l(authdate) s authdate=$p(^TEPI(labno,1,ts,tscnt),"\",21)
	..i $d(^TMP("web.DHCLabReportPrint",$j,"RowID",mi,epis,authdate,labno)) d
	...s ^TMP("web.DHCLabReportPrint",$j,"RowID",mi,epis,authdate,labno)=$g(^TMP("web.DHCLabReportPrint",$j,"RowID",mi,epis,authdate,labno))_"#"_tRowID
	..e  d
	...s ^TMP("web.DHCLabReportPrint",$j,"RowID",mi,epis,authdate,labno)=tRowID
	s temi=0
	s mi="" f  s mi=$o(^TMP("web.DHCLabReportPrint",$j,"RowID",mi)) q:mi=""  d
	.s epis="" f  s epis=$o(^TMP("web.DHCLabReportPrint",$j,"RowID",mi,epis)) q:epis=""  d
	..s date="" f  s date=$o(^TMP("web.DHCLabReportPrint",$j,"RowID",mi,epis,date)) q:date=""  d
	...s labno="" f  s labno=$o(^TMP("web.DHCLabReportPrint",$j,"RowID",mi,epis,date,labno)) q:labno=""  d
	....s temi=temi+1
	....s ^TMP("web.DHCLabReportPrint",$j,"TSList",temi)=$g(^TMP("web.DHCLabReportPrint",$j,"RowID",mi,epis,date,labno))
	k ^TMP("web.DHCLabReportPrint",$j,"RowID")
	q
}

/// 不同样本合并报告打印 
ClassMethod MergeLabRowid(TSRowIDs)
{
  s TSRowIDs=$g(TSRowIDs)
  k ^TMP("web.DHCLabReportPrint",$j,"RowID")
  f temi=1:1:$L(TSRowIDs,"^") d
  .s tRowIDs=$p(TSRowIDs,"^",temi)
  .q:'$l(tRowIDs)
  .f temk=1:1:$l(tRowIDs,"#") d
  ..s TSRowID=$p(tRowIDs,"#",temk)
  ..q:'$l(TSRowID)
  ..s temlabno=$p(TSRowID,"||",1),temts=$p(TSRowID,"||",2),temtscnt=$p(TSRowID,"||",3)
  ..s authdate=$p(^TEPI(temlabno,1,temts,temtscnt),"\",4)
  ..s debtor=$p(^TEPI(temlabno),"\",18) ;登记号
  ..i '$l(authdate) s authdate=+$h
  ..i $d(^TMP("web.DHCLabReportPrint",$j,"RowID",authdate,debtor)) d
  ...s ^TMP("web.DHCLabReportPrint",$j,"RowID",authdate,debtor)=$g(^TMP("web.DHCLabReportPrint",$j,"RowID",authdate,debtor))_"#"_TSRowID
  ..e  d
  ...s ^TMP("web.DHCLabReportPrint",$j,"RowID",authdate,debtor)=TSRowID
  s num=0
  s date="" f  s date=$o(^TMP("web.DHCLabReportPrint",$j,"RowID",date)) q:date=""  d
  .s debtor="" f  s debtor=$o(^TMP("web.DHCLabReportPrint",$j,"RowID",date,debtor)) q:debtor=""  d
  ..s num=num+1
  ..s ^TMP("web.DHCLabReportPrint",$j,"TSList",num)=$g(^TMP("web.DHCLabReportPrint",$j,"RowID",date,debtor))
  k ^TMP("web.DHCLabReportPrint",$j,"RowID")
  q
}

/// 获取检验结果
ClassMethod GetTSResult(TSRowIDList As %String, LABDATA As %String) As %Integer
{
	s TSRowIDList=$g(TSRowIDList),LABDATA=$g(LABDATA)
	i '$l(LABDATA) s LABDATA="LABDATA"
	k ^TMP("web.DHCLabReportPrint",$j,"TCResult")
	k ^TMP("web.DHCLabReportPrint",$j,"ResultData")
	f k=1:1:$l(TSRowIDList,"#") d
	.s TSRowID=$p(TSRowIDList,"#",k)
	.Q:'$l(TSRowID)
	.s labno=$p(TSRowID,"||",1),ts=$p(TSRowID,"||",2),tscnt=$p(TSRowID,"||",3)
	.//---获取图形结果ID--->
	.s imgCode="" f  s imgCode=$o(^["DHCLABDATA"]DHCLAB.DHCLabResultGraphD(labno,ts,tscnt,imgCode)) q:imgCode=""  d
	..s imgSeq="" f  s imgSeq=$o(^["DHCLABDATA"]DHCLAB.DHCLabResultGraphD(labno,ts,tscnt,imgCode,imgSeq)) q:imgSeq=""  d
	...s ^TMP("web.DHCLabReportPrint",$j,"Graph",labno,imgCode)=labno_"||"_ts_"||"_tscnt_"||"_imgCode_"||"_imgSeq  ///图形RowID
	.//-------------<
 	.Set tc="" For  Set tc=$Order(^TEPI(labno,1,ts,tscnt,"DATA",tc)) Quit:tc=""  Do
 	..If $D(^TMP("web.DHCLabReportPrint",$j,"TCResult",tc)) Quit ///判断合并医嘱存在相同项目处理
 	..Set ^TMP("web.DHCLabReportPrint",$j,"TCResult",tc)=""
 	..i $e(tc,2,5)="9999" Q        ///结果为9999的备注不在结果中打印
 	..Set resStr=$Piece($g(^TEPI(labno,1,ts,tscnt,"DATA",tc)),"\",1)
 	..If '$l(resStr) Quit
 	..Set RecDate=$P(^TEPI(labno,1,ts,tscnt),"\",21)
 	..Set temres=##Class(web.DHCLabTestCode).GetTestCodeResult(labno,tc,resStr,RecDate)
 	..Set tcDesc=$Piece(temres,$Char(2),2)
 	..Set tcSyn=$Piece(temres,$Char(2),7)
 	..Set tcResult=$Piece(temres,$Char(2),3)
 	..Set tcUnit=$Piece(temres,$Char(2),4)
 	..Set tcFlag=$Piece(temres,$Char(2),5)
 	..Set tcRanges=$Piece(temres,$Char(2),6)
 	..Set WarnFlag=$Piece(temres,$Char(2),8)
 	..Set MethodDesc=$Piece(temres,$Char(2),9)
 	..i '$d(^TTAB("TC",tc,1,ts)) q
 	..Set Order1=$p(^TTAB("TC",tc,1,ts),"\",1)
 	..Set LayOrder=$p(^TTAB("TC",tc,1,ts),"\",2)
 	..Set Order=$p(^TTAB("TS",ts,LayOrder,Order1),"\",15)
 	..Set Report=$p(^TTAB("TS",ts,LayOrder,Order1),"\",13)
 	..If Report'="Y" Quit
	..s mi=$p(^TEPI(labno,1,ts,tscnt),"\",27)
	..i '$l(mi) s mi=$e(ts)   ///
    ..i $l(mi),$l(tc),$d(^[LABDATA]DHCMachinePara(mi,"TC",tc)) s Order=$g(^[LABDATA]DHCMachinePara(mi,"TC",tc))
	..s (tcResultDsec2,tcResultDsec3,tcResultDsec4)=""
	..if $d(^TEPI(labno,1,ts,tscnt,"DATA",tc,"DHC")) d  ///获取已经保存数据
 	...s tcUnit=$p(^TEPI(labno,1,ts,tscnt,"DATA",tc,"DHC"),"\",1)
 	...s MethodDesc=$p(^TEPI(labno,1,ts,tscnt,"DATA",tc,"DHC"),"\",2)
	...s tcResultDsec2=$p(^TEPI(labno,1,ts,tscnt,"DATA",tc,"DHC"),"\",3)
	...s tcResultDsec3=$p(^TEPI(labno,1,ts,tscnt,"DATA",tc,"DHC"),"\",4)
	...s tcResultDsec4=$p(^TEPI(labno,1,ts,tscnt,"DATA",tc,"DHC"),"\",5)
 	...s tcRanges=$g(^TEPI(labno,1,ts,tscnt,"DATA",tc,"Ranges"))
 	...s tcFlag=$p($g(^TEPI(labno,1,ts,tscnt,"DATA",tc)),"\",2)
 	...s WarnFlag=tcFlag
 	...s Order2=$p($g(^TEPI(labno,1,ts,tscnt,"DATA",tc)),"\",9)
 	...i $l(Order2) s Order=Order2
    ..i $d(^TMP("web.DHCLabReportPrint",$j,"ResultData",Order)) s Order=ts_Order  ///判断医嘱合并没有维护仪器项目顺序出现序号相同处理
	..i $l(tcResult)>20 s tcDesc=tcDesc_":"_tcResult,tcResult=""   ///长字符串单独处理 合并到项目名称 
    ..i WarnFlag="U" s tcFlag=tcFlag_"☆"  //警告标记
    ..i WarnFlag="P" s tcFlag=tcFlag_"☆"  //警告标记
    ..i WarnFlag="M" s tcFlag=tcFlag_"★"  //荒诞标记
    ..i WarnFlag="N" s tcFlag=""  //正常标记
    ..i WarnFlag="H" s tcFlag="↑"  //偏高标记 
    ..i WarnFlag="L" s tcFlag="↓"  //偏低标记
    ..i WarnFlag="A" s tcFlag="*"  //备注异常标记    
 	..s ^TMP("web.DHCLabReportPrint",$j,"ResultData",Order)=tc_$c(2)_tcDesc_$c(2)_tcSyn_$c(2)_tcResult_$c(2)_tcFlag_$c(2)_tcUnit_$c(2)_tcRanges_$c(2)_MethodDesc_$c(2)_tcResultDsec2_$c(2)_tcResultDsec3_$c(2)_tcResultDsec4
	//输出结果
	k ^TMP("web.DHCLabReportPrint",$j,"Result")
	s TSSumResult=0
	s Order="" f  s Order=$o(^TMP("web.DHCLabReportPrint",$j,"ResultData",Order)) q:Order=""  d
	.///打印标签输出
	.s tc=$p($g(^TMP("web.DHCLabReportPrint",$j,"ResultData",Order)),$c(2),1)
	.i $l(tc) s tcLabelList=$p($g(^TTAB("TC",tc)),"\",26)
	.i $e(tcLabelList)="L" d
	..s TSSumResult=TSSumResult+1
	..s ^TMP("web.DHCLabReportPrint",$j,"Result",TSSumResult)="L"_$c(2)_tcLabelList_$c(2)_$c(2)_$c(2)_$c(2)_$c(2)_$c(2)_$c(2)_$c(2)_$c(2)
	.s TSSumResult=TSSumResult+1
	.s ^TMP("web.DHCLabReportPrint",$j,"Result",TSSumResult)=$g(^TMP("web.DHCLabReportPrint",$j,"ResultData",Order))
	q TSSumResult
}

/// 获取细菌药敏结果
ClassMethod GetAntData(labno As %String, ts As %String, tscnt As %String, tc As %String) As %Integer
{
  Set Config=##Class(websys.Configuration).%OpenId(1)
  Set LABDATA=Config.LabDataNamespace
  If '$Length(LABDATA) Set LABDATA="LABDATA"

  k ^TMP("web.DHCLabReportPrint",$j,"ANT")
  k ^TMP("web.DHCLabReportPrint",$j,"AntClsCode")
  i '$l(tc) q 0
  i '$l(labno) q 0
  i '$l(ts) q 0
  i '$l(tscnt) q 0
  s (RulesAntList,BugsMemoList,RuleMicList)=""
  i '$d(^TEPI(labno,1,ts,tscnt,"DATA",tc,"ANT")) q 0
  s num=0
  ;---------耐药规则------------>
  s RulesAnt="" f  s RulesAnt=$o(^TEPI(labno,1,ts,tscnt,"DATA",tc,"RuleAnt",RulesAnt)) q:RulesAnt=""  d
  .s temstr=^(RulesAnt)
  .s RulesAntList=RulesAntList_$p(temstr,"\",3)_";"
  ;-----------------------------<
  ;---------备注------------>
  s BugsMemo="" f  s BugsMemo=$o(^TEPI(labno,1,ts,tscnt,"DATA",tc,"BugsMemo",BugsMemo)) q:BugsMemo=""  d
  .s temstr=^(BugsMemo)
  .s BugsMemoList=BugsMemoList_$G(temstr)_$c(28)
  ;-----------------------------<
  ;---------专家规则------------>
  s RuleMic="" f  s RuleMic=$o(^TEPI(labno,1,ts,tscnt,"DATA",tc,"RuleMic",RuleMic)) q:RuleMic=""  d
  .s temstr=^(RuleMic)
  .s RuleMicList=RuleMicList_$p(temstr,"\",2)_$c(28)
  ;-----------------------------<
  s ant="" f  s ant=$o(^TEPI(labno,1,ts,tscnt,"DATA",tc,"ANT",ant)) q:ant=""  d
  .s temstr=^(ant)
  .s antname="",(AntClass,AntClssName,ClsSeq)=""    //定义抗生素类代码 
  .i $d(^TTAB("ANT",ant)) s antname=$p($G(^TTAB("ANT",ant)),"\",1)
  .s antEname=""
  .i $d(^[LABDATA]DHCANTIBIOTICS(ant)) s antEname=$p(^[LABDATA]DHCANTIBIOTICS(ant),"\",1)
  .///i $l(antEname) s antname=antname_"("_antEname_")" ///英文
  .i $d(^[LABDATA]DHCPharmicCategoryi("ANT",ant)) s AntClass=$o(^[LABDATA]DHCPharmicCategoryi("ANT",ant,AntClass))  //抗生素类
  .i AntClass'="" s AntClssName=$p(^[LABDATA]DHCPharmicCategory(AntClass),"\",1),ClsSeq=$p(^[LABDATA]DHCPharmicCategory(AntClass),"\",3)  //抗生素类名 
  .i AntClass="" s AntClass="ZOTHERS",AntClssName="其它"   
  .s temres1=$p(temstr,"\",1)
  .s temreport=$p(temstr,"\",2)
  .s temmic=$p(temstr,"\",3)
  .i $e(temmic,1)="." s temmic="0"_temmic
  .s temmm=$p(temstr,"\",4)
  .i $e(temmm,1)="." s temmm="0"_temmm
  .s tmpres=""
  .i $l(temres1) d
  ..s temres=""
  ..i $l(temres1),$d(^TTAB("SENS",temres1)) s temres=$p(^TTAB("SENS",temres1),"\",1)
  ..i temres1="S" s temres=temres_" *"
  ..s (CLSIR,CLSIS,BugsGroup,GPAntSeq)=""
  ..s num=num+1
  ..s ^TMP("web.DHCLabReportPrint",$j,"ANT",ClsSeq_AntClass_GPAntSeq,num)=ant_$c(2)_antname_$c(2)_temmm_$c(2)_temmic_$c(2)_temres_$c(2)_temreport_$c(2)_AntClssName_$c(2)_CLSIR_$c(2)_CLSIS
  //排序
  k ^TMP("web.DHCLabReportPrint",$j,"ANTDATA")
  s num=0
  s AntClsCode="" f  s AntClsCode=$o(^TMP("web.DHCLabReportPrint",$j,"ANT",AntClsCode)) q:AntClsCode=""  d
  .s nums="" f  s nums=$o(^TMP("web.DHCLabReportPrint",$j,"ANT",AntClsCode,nums)) q:nums=""  d
  ..s num=num+1
  ..I '$D(^TMP("web.DHCLabReportPrint",$j,"AntClsCode",AntClsCode)) D    ;add by mcr 药敏分类特殊处理 20140122
  ...S ^TMP("web.DHCLabReportPrint",$j,"AntClsCode",AntClsCode)=$G(^TMP("web.DHCLabReportPrint",$j,"ANT",AntClsCode))
  ...S AntClssName=$P(^TMP("web.DHCLabReportPrint",$j,"ANT",AntClsCode,nums),$C(2),7)
  ...s ^TMP("web.DHCLabReportPrint",$j,"ANTDATA",num)="ANTCLASS"_$C(2)_AntClssName_$C(2)_""_$C(2)_""_$C(2)_""_$C(2)_""_$C(2)_AntClssName_$C(2)_""_$C(2)_""
  ...s num=num+1
  ...s ^TMP("web.DHCLabReportPrint",$j,"ANTDATA",num)=$g(^TMP("web.DHCLabReportPrint",$j,"ANT",AntClsCode,nums))
  ..E  D
  ...s ^TMP("web.DHCLabReportPrint",$j,"ANTDATA",num)=$g(^TMP("web.DHCLabReportPrint",$j,"ANT",AntClsCode,nums))
  q num
}

ClassMethod SetTSPrintFlag(TSRowIDs As %String(MAXLEN=32767), param As %String, user As %String) As %String
{
    s TSRowIDs=$g(TSRowIDs),param=$g(param),user=$g(user)
    s TSRowIDs=$tr(TSRowIDs,"^","#")
	Set Config=##Class(websys.Configuration).%OpenId(1)
	Set LABDATA=Config.LabDataNamespace
	Set WebNS=$ZUTIL(5)
	If '$Length(LABDATA) Set LABDATA="LABDATA"
    zn LABDATA
    s ret=$$SetTSPrint^DHCLtkDoPrint(TSRowIDs,param,user)  
    zn WebNS
	q 0
}

ClassMethod GetReportCodeByTSRowIDs(TSRowIDLists As %String, LABDATA As %String) As %String
{
	s TSRowIDLists=$g(TSRowIDLists),LABDATA=$g(LABDATA)
	i '$l(LABDATA) s LABDATA="LABDATA"
	s reportCode=""
	f k=1:1:$l(TSRowIDLists,"#") {
	  s TSRowID=$p(TSRowIDLists,"#",k)
	  s ts=$p(TSRowID,"||",2)
	  i $l(ts) s reportCode=$o(^[LABDATA]DHCReportPrintDefine("TS",ts,""))
	  i $l(reportCode) q
	}
	q reportCode
}

/// add by mcr  20130811
/// 判断微生物的结果是否含有药敏结果^TEPI("0000296492",1,"D556",1,"DATA","D5560","ANT","
/// W ##class(web.DHCLabReportPrint).CheckTSANT("0000293172||D564||1","LABDATA")
/// Output: 1:有药敏  0:无药敏
ClassMethod CheckTSANT(TSRowIDList As %String, LABDATA As %String, reportCode As %String) As %Integer
{
	 Set TSRowIDList=$G(TSRowIDList),LABDATA=$G(LABDATA)
	 Set RetRepCode=reportCode
	 Set res=0,temres=""
     F k=1:1:$L(TSRowIDList,"#") D
     .Set TSRowID=$P(TSRowIDList,"#",k)
     .Q:'$L(TSRowID)
     .Q:res=1
     .Set labno=$P(TSRowID,"||",1),ts=$P(TSRowID,"||",2),tscnt=$P(TSRowID,"||",3)
     .Set tscnt="" F  Set tscnt=$o(^[LABDATA]TEPI(labno,1,ts,1,"DATA",tscnt)) Q:(tscnt="")!(res=1)  d
     ..Set ant="" F  Set ant=$o(^[LABDATA]TEPI(labno,1,ts,1,"DATA",tscnt,"ANT",ant)) Q:(ant="")!(res=1)  d
     ...S:ant="" res=""
     ...Set temres=$o(^[LABDATA]TEPI(labno,1,ts,1,"DATA",tscnt,"ANT",""))
     ...I $L(temres) Set res=1
     i res=1 s RetRepCode="HDocument1" //药敏结果模板
     Q RetRepCode
}

Storage Default
{
<Data name="DHCLabReportPrintDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCLabReportPrintD</DataLocation>
<DefaultData>DHCLabReportPrintDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCLabReportPrintD</IdLocation>
<IndexLocation>^web.DHCLabReportPrintI</IndexLocation>
<StreamLocation>^web.DHCLabReportPrintS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
