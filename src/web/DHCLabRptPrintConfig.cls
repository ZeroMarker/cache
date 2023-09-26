/// Creator: Liuzf      
/// CreatDate: 20121120 
/// Description: 自定义报告打印设置处理
/// Table：DHC_ReportPrint:报告格式定义 DHC_ReportPrintItem:报告打印项目定义
Class web.DHCLabRptPrintConfig Extends %Persistent
{

/// Creator：      
/// CreatDate：    
/// Description:： 用户密码验证
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others：
ClassMethod CheckUser(user As %String, password As %String) As %String
{
	S Config=##Class(websys.Configuration).%OpenId(1)
 	S labNS=Config.LabDataNamespace
	S:'$l(labNS) labNS="LABDATA"
 	S curNS=$ZUTIL(5)
 	s retValue=""
	zn labNS
	s retValue=$$CheckUser^DHCLtkSysUser(user,password)
	zn curNS
	q retValue
}

ClassMethod GetAccDepartClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAccDepartExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAccDepartExecute(ByRef qHandle As %Binary, user As %String, para As %String) As %Status
{
	s user=$g(user),para=$g(para)
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1

	S Config=##Class(websys.Configuration).%OpenId(1)
 	S labNS=Config.LabDataNamespace
	S:'$l(labNS) labNS="LABDATA"
	
	i $d(^TTAB("UA",user)) d
	.s dep="" f  s dep=$o(^TTAB("UA",user,4,dep)) q:dep=""  d
	..s (name,UseFlag,IsDefault)=""
	..s name=$P(^TTAB("DEP",dep),"\",1)
	..i para="1",$d(^[labNS]DHCReportPrintDefine("DEP",dep)) q  ///判断报告已经关联科室
	..d OutputDep			
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputDep
	set Data=$lb(dep,name,UseFlag,IsDefault)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetAccDepartFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAccDepartExecute ]
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

/// Creator：      
/// CreatDate：    
/// Description:： 用户科室查询
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others：
Query GetAccDepart(user As %String, para As %String) As %Query(ROWSPEC = "Code:%String,Name:%String,UseFlag:%String,IsDefault:%String") [ SqlProc ]
{
}

ClassMethod GetAccHospClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAccHospExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAccHospExecute(ByRef qHandle As %Binary, user As %String) As %Status
{
	s user=$g(user),para=$g(para)
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1

	S Config=##Class(websys.Configuration).%OpenId(1)
 	S labNS=Config.LabDataNamespace
	S:'$l(labNS) labNS="LABDATA"

	S Config=##Class(websys.Configuration).%OpenId(1)
 	S labNS=Config.LabDataNamespace
	S:'$l(labNS) labNS="LABDATA"
 	S curNS=$ZUTIL(5)

	i $d(^TTAB("UA",user)) d
	.s CentreDep="" f  s CentreDep=$o(^[labNS]TTAB("UA",user,3,CentreDep)) q:CentreDep=""  d
	..s name=$P(^[labNS]TTAB("CC",CentreDep),"\",1)
	..d OutputHosp			
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputHosp
	set Data=$lb(CentreDep,name)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetAccHospFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAccHospExecute ]
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

/// Creator：      
/// CreatDate：    
/// Description:： 用户科室查询
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others：
Query GetAccHosp(user As %String) As %Query(ROWSPEC = "Code:%String,Name:%String") [ SqlProc ]
{
}

ClassMethod QueryReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryReportExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryReportExecute(ByRef qHandle As %Binary, user As %String, DepCode As %String, HospitalCode As %String) As %Status
{
	s user=$g(user),DepCode=$g(DepCode)
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1

	S Config=##Class(websys.Configuration).%OpenId(1)
 	S labNS=Config.LabDataNamespace
	S:'$l(labNS) labNS="LABDATA"
 	S curNS=$ZUTIL(5)
 	
 	i '$l(HospitalCode) s HospitalCode="0"
	s ReportCode="" f  s ReportCode=$o(^[labNS]DHCReportPrinti("HOSP",HospitalCode,ReportCode)) q:ReportCode=""  d
	.i $e(ReportCode)'=DepCode q
	.s tStrData=$g(^[labNS]DHCReportPrint(ReportCode))
	.s ReportName=$p(tStrData,"\",1)
	.s PaperCode=$p(tStrData,"\",2)
	.s ResultLineSpacing=$p(tStrData,"\",3)
	.s ResultRows=$p(tStrData,"\",4)
	.s ResultCols=$p(tStrData,"\",5)
	.d OutputData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputData
	set Data=$lb(ReportCode,ReportName,PaperCode,ResultLineSpacing,ResultRows,ResultCols)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryReportExecute ]
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

/// Creator: Liuzf   
/// CreatDate: 20121119
/// Description:报告定义查询
/// Table：       
/// Input：        
/// Output：       
/// Return：       0:无,1:有
/// Others：
Query QueryReport(user As %String, DepCode As %String, HospitalCode As %String) As %Query(ROWSPEC = "ReportCode:%String,ReportName:%String,PaperCode:%String,ResultLineSpacing:%String,ResultRows:%String,ResultCols:%String") [ SqlProc ]
{
}

/// Creator: Liuzf   
/// CreatDate: 20121119
/// Description: 返回自定义报告设置数据
/// Table：       
/// Input：        
/// Output：       
/// Return：报告设置串
/// Others：
ClassMethod GetReportData(ReportCode As %String) As %String
{
	s ReportCode=$g(ReportCode)
	i '$l(ReportCode) q ""
	
	S Config=##Class(websys.Configuration).%OpenId(1)
 	S labNS=Config.LabDataNamespace
	S:'$l(labNS) labNS="LABDATA"
 	S curNS=$ZUTIL(5)
 	
 	i '$d(^[labNS]DHCReportPrint(ReportCode)) q ""
 	s (DataLists,DataItemLists)=""
	s DataLists=$g(^[labNS]DHCReportPrint(ReportCode))
	i $L(DataLists,"\")<17 s $p(DataLists,"\",17)=""
	s SeqId="" f  s SeqId=$o(^[labNS]DHCReportPrint(ReportCode,"ITEM",SeqId)) q:SeqId=""  d
	.s DataItemLists=DataItemLists_$g(^[labNS]DHCReportPrint(ReportCode,"ITEM",SeqId))_$c(28)
	
	i '$l(DataLists) q ""
	q ReportCode_"\"_DataLists_$c(2)_DataItemLists
}

/// Creator: Liuzf   
/// CreatDate: 20121119
/// Description: 保存自定义报告设置
/// Table：DHC_ReportPrint:报告格式定义 DHC_ReportPrintItem:报告打印项目定义       
/// Input：        
/// Output：       
/// Return：0:成功 
/// Others：
ClassMethod SaveReport(DepCode As %String, ReportCode As %String, DataLists As %String, HospCode As %String) As %String
{
	s DepCode=$g(DepCode),ReportCode=$g(ReportCode),DataLists=$g(DataLists),HospCode=$g(HospCode)
	s tReportCode=DepCode_$p(DataLists,"^",1)

	S Config=##Class(websys.Configuration).%OpenId(1)
 	S labNS=Config.LabDataNamespace
	S:'$l(labNS) labNS="LABDATA"
 	S curNS=$ZUTIL(5)

	s ret=##Class(web.DHCLabRptPrintConfig).InitPatReportOrder(labNS)

 	i '$l(ReportCode),$d(^[labNS]DHCReportPrint(tReportCode)) q "-1"   ///新报告已经存在

	k ^liuzf
	s ^liuzf=tReportCode_HospCode
	
 	s retValue=""
	zn labNS
	s retValue=$$save^DHCReportPrint(tReportCode,DataLists,HospCode)
	zn curNS
	q retValue
}

/// 初始化报告打印顺序
ClassMethod InitPatReportOrder(LABDATA As %String) As %String
{
	i '$l(LABDATA) s LABDATA="LABDATA"
	s ^[LABDATA]DHCPatReportOrder("D","登记号")=1
	s ^[LABDATA]DHCPatReportOrder("D","姓名")=2
	s ^[LABDATA]DHCPatReportOrder("D","性别")=3
	s ^[LABDATA]DHCPatReportOrder("D","年龄")=4
	s ^[LABDATA]DHCPatReportOrder("D","出生日期")=5
	s ^[LABDATA]DHCPatReportOrder("D","医嘱名称")=6
	s ^[LABDATA]DHCPatReportOrder("D","标本")=7
	s ^[LABDATA]DHCPatReportOrder("D","诊断")=8
	s ^[LABDATA]DHCPatReportOrder("D","仪器名称")=9
	s ^[LABDATA]DHCPatReportOrder("D","流水号")=10
	s ^[LABDATA]DHCPatReportOrder("D","病案号")=11
	s ^[LABDATA]DHCPatReportOrder("D","科室")=12
	s ^[LABDATA]DHCPatReportOrder("D","病区")=13
	s ^[LABDATA]DHCPatReportOrder("D","病房")=14
	s ^[LABDATA]DHCPatReportOrder("D","床号")=15
	s ^[LABDATA]DHCPatReportOrder("D","血型")=16
	s ^[LABDATA]DHCPatReportOrder("D","电话")=17
	s ^[LABDATA]DHCPatReportOrder("D","地址")=18
	s ^[LABDATA]DHCPatReportOrder("D","申请医生")=19
	s ^[LABDATA]DHCPatReportOrder("D","申请日期")=20
	s ^[LABDATA]DHCPatReportOrder("D","申请时间")=21
	s ^[LABDATA]DHCPatReportOrder("D","采集日期")=22
	s ^[LABDATA]DHCPatReportOrder("D","采集时间")=23
	s ^[LABDATA]DHCPatReportOrder("D","接收者")=24
	s ^[LABDATA]DHCPatReportOrder("D","接收日期")=25
	s ^[LABDATA]DHCPatReportOrder("D","接收时间")=26
	s ^[LABDATA]DHCPatReportOrder("D","操作者")=27
	s ^[LABDATA]DHCPatReportOrder("D","操作日期")=28
	s ^[LABDATA]DHCPatReportOrder("D","操作时间")=29
	s ^[LABDATA]DHCPatReportOrder("D","审核者")=30
	s ^[LABDATA]DHCPatReportOrder("D","审核日期")=31
	s ^[LABDATA]DHCPatReportOrder("D","审核时间")=32
	s ^[LABDATA]DHCPatReportOrder("D","检验号")=33
	s ^[LABDATA]DHCPatReportOrder("D","打印时间")=34
	s ^[LABDATA]DHCPatReportOrder("D","检验科室")=35
	s ^[LABDATA]DHCPatReportOrder("D","科室电话")=36
	s ^[LABDATA]DHCPatReportOrder("D","医嘱备注")=37
	
	s ^[LABDATA]DHCPatReportOrder("D","集中接收日期")=38
	s ^[LABDATA]DHCPatReportOrder("D","集中接收时间")=39
	s ^[LABDATA]DHCPatReportOrder("D","集中接收用户")=40
	
	//结果列表1
	s ^[LABDATA]DHCPatReportOrder("R","序号1")=1
	s ^[LABDATA]DHCPatReportOrder("R","项目名称1")=2
	s ^[LABDATA]DHCPatReportOrder("R","缩写1")=3
	s ^[LABDATA]DHCPatReportOrder("R","结果1")=4
	s ^[LABDATA]DHCPatReportOrder("R","标志1")=5
	s ^[LABDATA]DHCPatReportOrder("R","单位1")=6
	s ^[LABDATA]DHCPatReportOrder("R","参考范围1")=7
	s ^[LABDATA]DHCPatReportOrder("R","实验方法1")=8
	s ^[LABDATA]DHCPatReportOrder("R","结果二1")=9
	s ^[LABDATA]DHCPatReportOrder("R","结果三1")=10
	s ^[LABDATA]DHCPatReportOrder("R","结果四1")=11
	//结果列表2
	s ^[LABDATA]DHCPatReportOrder("R","序号2")=1
	s ^[LABDATA]DHCPatReportOrder("R","项目名称2")=2
	s ^[LABDATA]DHCPatReportOrder("R","缩写2")=3
	s ^[LABDATA]DHCPatReportOrder("R","结果2")=4
	s ^[LABDATA]DHCPatReportOrder("R","标志2")=5
	s ^[LABDATA]DHCPatReportOrder("R","单位2")=6
	s ^[LABDATA]DHCPatReportOrder("R","参考范围2")=7
	s ^[LABDATA]DHCPatReportOrder("R","实验方法2")=8
	s ^[LABDATA]DHCPatReportOrder("R","结果二2")=9
	s ^[LABDATA]DHCPatReportOrder("R","结果三2")=10
	s ^[LABDATA]DHCPatReportOrder("R","结果四2")=11
	//细菌结果列表1
	s ^[LABDATA]DHCPatReportOrder("M","抗生素序号1")=1
	s ^[LABDATA]DHCPatReportOrder("M","抗生素名1")=2
	s ^[LABDATA]DHCPatReportOrder("M","MM1")=3
	s ^[LABDATA]DHCPatReportOrder("M","MIC1")=4
	s ^[LABDATA]DHCPatReportOrder("M","敏感度1")=5
	//细菌结果结果列表2
	s ^[LABDATA]DHCPatReportOrder("M","抗生素序号2")=1
	s ^[LABDATA]DHCPatReportOrder("M","抗生素名2")=2
	s ^[LABDATA]DHCPatReportOrder("M","MM2")=3
	s ^[LABDATA]DHCPatReportOrder("M","MIC2")=4
	s ^[LABDATA]DHCPatReportOrder("M","敏感度2")=5
	q 0
}

/// Creator: Liuzf   
/// CreatDate: 20121119
/// Description: 删除自定义报告设置
/// Table：DHC_ReportPrint:报告格式定义 DHC_ReportPrintItem:报告打印项目定义       
/// Input：        
/// Output：       
/// Return：0:成功 
/// Others：
ClassMethod Delete(ReportCode As %String) As %String
{
	s ReportCode=$g(ReportCode)
	i '$l(ReportCode) q ""
	S Config=##Class(websys.Configuration).%OpenId(1)
 	S labNS=Config.LabDataNamespace
	S:'$l(labNS) labNS="LABDATA"
 	S curNS=$ZUTIL(5)
	
	s retValue=""
	zn labNS
	//删除报告关联配置
	s defRowID="" f  s defRowID=$o(^[labNS]DHCReportPrintDefine("REPORT",ReportCode,defRowID)) q:defRowID=""  d
	.s retValue=$$delete^DHCReportPrintDefine(defRowID)
	//删除报告
	s retValue=$$delete^DHCReportPrint(ReportCode)
	zn curNS
	q retValue
}

Query QueryPaperSize(HospitalCode As %String) As %Query(ROWSPEC = "PaperCode:%String,PaperName:%String,PaperWidth:%String,PaperHeight:%String") [ SqlProc ]
{
}

ClassMethod QueryPaperSizeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryPaperSizeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryPaperSizeExecute(ByRef qHandle As %Binary, HospitalCode As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	S Config=##Class(websys.Configuration).%OpenId(1)
 	S labNS=Config.LabDataNamespace
	S:'$l(labNS) labNS="LABDATA"
 	S curNS=$ZUTIL(5)

	///设置缺省医院保存
	i '$l(HospitalCode) s HospitalCode="0"
	///没找到纸张,插入缺省纸张
	i '$d(^[labNS]DHCReportPrintPaper(HospitalCode,"A4")) d InsDefPager
	///查询报告
	s PaperCode="" f  s PaperCode=$o(^[labNS]DHCReportPrintPaper(HospitalCode,PaperCode)) q:PaperCode=""  d
	.s tGlobleData=$g(^[labNS]DHCReportPrintPaper(HospitalCode,PaperCode))
	.s PaperName=$p(tGlobleData,"\",1)
	.s PaperWidth=$p(tGlobleData,"\",2)
	.s PaperHeight=$p(tGlobleData,"\",3)
	.d OutputData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputData
	set Data=$lb(PaperCode,PaperName,PaperWidth,PaperHeight)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
	
InsDefPager
    zn labNS
	s ReportPaper(1)="A4^A4^827^1169"
	s ReportPaper(2)="A5^A5^827^583"
	s ReportPaper(3)="自定义1^自定义1^827^583"
	s ReportPaper(4)="自定义2^自定义2^827^583"
	s ReportPaper(5)="自定义3^自定义3^827^583"
	s ReportPaper(6)="自定义4^自定义4^827^583"
	s ReportPaper(7)="自定义5^自定义5^827^583"
	s ReportPaper(8)="自定义6^自定义6^827^583"
	f i=1:1:8 d
	.s para=ReportPaper(i)_"^"_HospitalCode
	.s ret=$$save^DHCReportPrintPaper(para)
	zn curNS
}

ClassMethod UpdatePaperSize(DataList As %String) As %String
{
	s DataList=$g(DataList)
	S Config=##Class(websys.Configuration).%OpenId(1)
 	S labNS=Config.LabDataNamespace
	S:'$l(labNS) labNS="LABDATA"
 	S curNS=$ZUTIL(5)
 	zn labNS
 	s ret=$$save^DHCReportPrintPaper(DataList)
	zn curNS
	q ret
}

ClassMethod QueryPaperSizeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryPaperSizeExecute ]
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

Query QueryReportTS(DepCode As %String, Param As %String) As %Query(ROWSPEC = "Code:%String,Name:%String") [ SqlProc ]
{
}

ClassMethod QueryReportTSExecute(ByRef qHandle As %Binary, DepCode As %String, Param As %String) As %Status
{
	s DepCode=$g(DepCode),Param=$g(Param)
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	S Config=##Class(websys.Configuration).%OpenId(1)
 	S labNS=Config.LabDataNamespace
	S:'$l(labNS) labNS="LABDATA"
	
	s TSCode="" f  s TSCode=$o(^TTAB("TS",TSCode)) q:TSCode=""  d
	.s ActiveFlag=$P(^TTAB("TS",TSCode),"\",12)
	.i ActiveFlag'="Y" Quit
	.s TSName=$P(^TTAB("TS",TSCode),"\",1)
	.i $l(DepCode),DepCode'=$e(TSCode) Quit
	.i Param="1",$d(^[labNS]DHCReportPrintDefine("TS",TSCode)) q  ///判断报告已经关联科室
	.d Output			
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Output
	set Data=$lb(TSCode,TSName)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod QueryReportTSClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryReportTSExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryReportTSFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryReportTSExecute ]
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

Query QueryReportDefine(ReportCode As %String, HospCode As %String, Param As %String) As %Query(ROWSPEC = "Code:%String,Name:%String") [ SqlProc ]
{
}

ClassMethod QueryReportDefineExecute(ByRef qHandle As %Binary, ReportCode As %String, HospCode As %String, Param As %String) As %Status
{
	s ReportCode=$g(ReportCode),HospCode=$g(HospCode),Param=$g(Param)
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	S Config=##Class(websys.Configuration).%OpenId(1)
 	S labNS=Config.LabDataNamespace
	S:'$l(labNS) labNS="LABDATA"
	
	s RowID="" f  s RowID=$o(^[labNS]DHCReportPrintDefine("REPORT",ReportCode,RowID)) q:RowID=""  d
	.s tDataList=$g(^[labNS]DHCReportPrintDefine("0",RowID))
	.s DepCode=$p(tDataList,"\",2)
	.s TSCode=$p(tDataList,"\",3)
	.i Param="DEP",$l(DepCode) d
	..s Code=DepCode
	..s Name=$p(^TTAB("DEP",DepCode),"\",1)
	..d Output
	.i Param="TS",$l(TSCode) d
	..s Code=TSCode
	..s Name=$p(^TTAB("TS",TSCode),"\",1)
	..d Output
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Output
	set Data=$lb(Code,Name)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod QueryReportDefineClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryReportDefineExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryReportDefineFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryReportDefineExecute ]
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

ClassMethod SaveReportDefine(ReportCode As %String, DepCode As %String, TSCode As %String, HospCode As %String) As %String
{
	S Config=##Class(websys.Configuration).%OpenId(1)
 	S labNS=Config.LabDataNamespace
	S:'$l(labNS) labNS="LABDATA"
 	S curNS=$ZUTIL(5)

 	s retValue=""
 	zn labNS
 	s retValue=$$save^DHCReportPrintDefine(ReportCode,DepCode,TSCode,HospCode)
 	zn curNS
	q retValue
}

ClassMethod DeleteReportDefine(ReportCode As %String, DepCode As %String, TSCode As %String, HospCode As %String) As %String
{
	S Config=##Class(websys.Configuration).%OpenId(1)
 	S labNS=Config.LabDataNamespace
	S:'$l(labNS) labNS="LABDATA"
 	S curNS=$ZUTIL(5)

 	s retValue="",RowID=""
 	i '$l(ReportCode) q retValue
 	zn labNS
 	i $l(DepCode) s RowID=$o(^[labNS]DHCReportPrintDefine("DEP",DepCode,ReportCode,""))
 	i $l(TSCode) s RowID=$o(^[labNS]DHCReportPrintDefine("TS",TSCode,ReportCode,""))
 	i $l(RowID) s retValue=$$delete^DHCReportPrintDefine(RowID)
 	zn curNS
	q retValue
}

Query QueryUser(HospCode As %String) As %Query(ROWSPEC = "Code:%String,Name:%String") [ SqlProc ]
{
}

ClassMethod QueryUserExecute(ByRef qHandle As %Binary, HospCode As %String) As %Status
{
	s HospCode=$g(HospCode)
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	S Config=##Class(websys.Configuration).%OpenId(1)
 	S labNS=Config.LabDataNamespace
	S:'$l(labNS) labNS="LABDATA"
	
	s userCode="" f  s userCode=$o(^TTAB("UA",userCode)) q:userCode=""  d
	.s Code=""
	.i $l(HospCode) d
	..i $d(^TTAB("UA",userCode,3,HospCode)) d
	...s Code=userCode
	...s Name=$p(^[labNS]SSU("SSUSR",1,Code),"^",2)
	...d Output

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Output
	set Data=$lb(Code,Name)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod QueryUserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryUserExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryUserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryUserExecute ]
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

ClassMethod SaveGraphConnectString(GraphConnString As %String) As %String
{
	s GraphCode=$g(GraphCode)
	S Config=##Class(websys.Configuration).%OpenId(1)
 	S labNS=Config.LabDataNamespace
	S:'$l(labNS) labNS="LABDATA"
 	s ^[labNS]DHCGraphConnectString("1")=GraphConnString
	q 0
}

/// 获取DHCLABDATA数据库的ODBC串
ClassMethod GetGraphConnectString(user As %String) As %String
{
    s user=$g(user)
	Set Config=##Class(websys.Configuration).%OpenId(1)
	Set labNS=Config.LabDataNamespace
	If '$Length(labNS) Set labNS="LABDATA"
    s GraphConnString=""
    s GraphConnString=$g(^[labNS]DHCGraphConnectString("1"))
	q GraphConnString
}

/// 获取DHC-APP数据库的连接串
ClassMethod GetWebConnString() As %String
{
	Set Config=##Class(websys.Configuration).%OpenId(1)
	Set labNS=Config.LabDataNamespace
	If '$Length(labNS) Set labNS="LABDATA"
    s GraphConnString=""
    s GraphConnString=$g(^[labNS]DHCGraphConnectString("1"))
	q GraphConnString
	
	/*
	S Config=##Class(websys.Configuration).%OpenId(1)
 	S WebConnString=Config.LayoutManager
	q WebConnString
	*/
}

Storage Default
{
<Data name="DHCLabRptPrintConfigDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCLabRptPrintConfigD</DataLocation>
<DefaultData>DHCLabRptPrintConfigDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCLabRptPrintConfigD</IdLocation>
<IndexLocation>^web.DHCLabRptPrintConfigI</IndexLocation>
<StreamLocation>^web.DHCLabRptPrintConfigS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
