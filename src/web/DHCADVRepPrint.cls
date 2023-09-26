Class web.DHCADVRepPrint Extends %Persistent [ ClassType = "", Not ProcedureBlock ]
{

/// Description: 获取打印数据
/// Creator:sufan
/// Return: 	 json数据
/// Input: 		 AdvMaster ID,打印人ID,医院ID
/// w ##class(web.DHCADVRepPrint).GetPrintData("8","10209","2")
/// w ##class(web.DHCADVRepPrint).GetPrintData("75","10211","2")
ClassMethod GetPrintData(AdvMasterDr, PrintUserId, LgHospID)
{
	n (AdvMasterDr,PrintUserId,LgHospID)
	s repid=$i(^CacheTemp)
	k ^TMP("DHCADV","web.DHCADVRepPrint","GetPrintData")
	s PrintUser=$p(^SSU("SSUSR",PrintUserId),"^",2)
	s PrintDate=$zd(+$h,3) ;2020-03-15 cy 不良事件打印显示 日期格式固定 ##class(web.DHCADVCOMMON).DateLogicalToHtml(+$h)
	s HospDesc=$p(^CT("HOSP",LgHospID),"^",2)
	q:AdvMasterDr="" ""
	S RepLocDr=$p(^DHCADVMASTER(AdvMasterDr),"^",7)
	S:RepLocDr'="" RepLoc=$p(^CTLOC(RepLocDr),"^",2)
	S:RepLoc["-" RepLoc=$p(RepLoc,"-",2)
	S LocDep=##class(web.DHCADVCOMMONPART).GetSecuGroupDesc(RepLocDr)
	s ADVFormRecDr = $p(^DHCADVMASTER(AdvMasterDr),"^",1)
	S DataList=..GetPrintDataList(AdvMasterDr,ADVFormRecDr,RepLoc,LocDep,PrintUser,PrintDate,HospDesc)
	q DataList
}

/// Description: 	获取打印数据
/// Creator:sufan
/// Return: 		json数据
/// Input: 			AdvMaster ID,表单记录ID,申请科室，科室描述，打印人，打印日期，医院
/// w ##class(web.DHCADVCOMMONPRINT).GetPrintDataList(15,"","")
ClassMethod GetPrintDataList(AdvMasterDr, ADVFormRecDr, RepLoc, LocDep, PrintUser, PrintDate, HospDesc)
{
	n (AdvMasterDr,ADVFormRecDr,RepLoc,LocDep,PrintUser,PrintDate,HospDesc)
	s repid=$i(^CacheTemp)
	k ^TMP("DHCADV","web.DHCADVRepPrint","GetPrintData")
	q:ADVFormRecDr="" ""
	///获取表单记录ID串
	s ReportDate=$p(^DHCADVMASTER(AdvMasterDr),"^",4)
	s:ReportDate'="" ReportDate=$zd(ReportDate,3)
	s ReportTime=$p(^DHCADVMASTER(AdvMasterDr),"^",5)
	s:ReportTime'="" ReportTime=$zt(ReportTime,2)
	s RsDate="",RsString="",tableName=""
	s recordIdList=..QueryFormIdList(ADVFormRecDr)
	b  //22
	s Len=$l(recordIdList,"^")
	k TempKey,ChkItmKey
	for i=1:1:Len  d
	.s recordId=$p(recordIdList,"^",i)
	.Q:recordId=""
	.s ADVFormRecItmDr=""
	.f  s ADVFormRecItmDr = $o(^User.DHCAdvFormRecordItmI("IndexFormRecord",recordId,ADVFormRecItmDr))  q:ADVFormRecItmDr=""  d
	..s ADVFormDicID = $lg(^User.DHCAdvFormRecordItmD(ADVFormRecItmDr),3)  	//元素ID
	..s Style=$LG(^User.DHCAdvFormDicD(ADVFormDicID),3)
	..i (Style="radio")||(Style="checkbox")||(Style="radio-input")||(Style="checkbox-input") s ChkItmKey(ADVFormDicID)=ADVFormDicID_"^"_ADVFormRecItmDr
	..s ParrefId=$lg(^User.DHCAdvFormRecordItmD(ADVFormRecItmDr),8)   													//取表单元素上级ID
	..i ((Style="radio")||(Style="checkbox")||(Style="radio-input")||(Style="checkbox-input"))&&(+ParrefId'=0)&&('$d(TempKey(ParrefId)))   d
	...s TempKey(ParrefId)=ParrefId_"^"_recordId
	..s FormDicTitle=$list(^User.DHCAdvFormDicD(ADVFormDicID),4)
	..s ItmValue = $lg(^User.DHCAdvFormRecordItmD(ADVFormRecItmDr),4)  	//值
	..s ItmValue=$tr(ItmValue,"[","【") //hxy 2020-03-23 st
	..s ItmValue=$tr(ItmValue,"]","】") //ed
	..s ItmValue=$replace(ItmValue,$c(10),"</br>")
	..s ItmValue=$replace(ItmValue,$c(9,9,9),"&nbsp;&nbsp;")
	..s ItmValue=$replace(ItmValue,$c(10,10),"</br></br>")
	..s ItmID = $lg(^User.DHCAdvFormDicD(ADVFormDicID),2)       			//元素唯一标示，对应界面的ID
	..s:(ItmValue'="")&&(ItmValue'="title")&&(Style["-input") ItmID=ItmID_"-input"
	..s:(ItmValue="title")&&(Style["-input") ItmValue=FormDicTitle
	..s DataRowKey = $lg(^User.DHCAdvFormRecordItmD(ADVFormRecItmDr),7)  	//Key 只有table才有的标识
	..s:DataRowKey ^TMP("DHCADV","web.DHCADVRepPrint","GetPrintData",repid,recordId,$p(ItmID,"-",1))=""		//存储table
	..q:DataRowKey'=""     													//table 数据单独写
	..q:(ItmValue="title")&&(Style["-input")
	..;这个下面是获取数据内容：RsString 返回json数据的title  RsDate：返回数据的data串
	..s:RsDate'="" RsDate = RsDate_"#"_ItmValue
	..s:RsString'="" RsString = RsString_"#"_ItmID
	..s:RsDate="" RsDate = RepLoc_"#"_LocDep_"#"_PrintUser_"#"_PrintDate_"#"_HospDesc_"#"_ReportDate_"#"_ReportTime_"#"_ItmValue
	..s:RsString="" RsString = "RepLoc"_"#"_"LocDep"_"#"_"PrintUser"_"#"_"PrintDate"_"#"_"HospDesc"_"#"_"ReportDate"_"#"_"ReportTime"_"#"_ItmID

	///单独取父元素
	s ParentId=""
	for  s ParentId=$o(TempKey(ParentId))  Q:ParentId=""   d
	.s recordId=$p(TempKey(ParentId),"^",2)
	.s ItmCode=$List(^User.DHCAdvFormDicD(ParentId),2)						//元素唯一标示，对应界面的ID
	.s Itmtitle=$List(^User.DHCAdvFormDicD(ParentId),4)
	.s Itmtitle=$p(Itmtitle,"<",1)
	.s ItmValue=..QueryDataInfo(recordId,Itmtitle,ItmCode,repid)					//
	.s FormDicFiled=$list(^User.DHCAdvFormDicD(ParentId),4)
	.s RsDate=RsDate_"#"_ItmValue
	.s RsString=RsString_"#"_ItmCode
	
	///checkbox 内容
	s ret=..QueryChkItmContent()
	s RsString=RsString_"#"_"CheckItem"
	s RsDate=RsDate_"#"_ret
	
	///此处取医疗不良事件评估表数据 ，单独拼串和获取内容，此部分内容非制作表单内容
	s RsString=RsString_"#"_$p(..QueryAssData(AdvMasterDr),"^",1)
	s RsDate=RsDate_"#"_$p(..QueryAssData(AdvMasterDr),"^",2)
	
	
	///取table数据
	s recordIdTb="",TableName=""
	for  s recordIdTb=$o(^TMP("DHCADV","web.DHCADVRepPrint","GetPrintData",repid,recordIdTb)) q:recordIdTb=""  d
	.f  s TableName =$o(^TMP("DHCADV","web.DHCADVRepPrint","GetPrintData",repid,recordIdTb,TableName)) q:TableName=""  d
	..s:RsDate'="" RsDate = RsDate_"#"_##class(web.DHCADVRepPrint).GetDatagridData(recordIdTb,TableName)
	..s:RsString'="" RsString = RsString_"#"_TableName
	..s:RsDate="" RsDate = ##class(web.DHCADVRepPrint).GetDatagridData(recordIdTb,TableName)
	..s:RsString="" RsString = TableName 
	
	q ##class(web.DHCADVJSONCOMMON).getJsonDataPort(RsString,RsDate,"#")
}

/// Descript:取checkbox内容串
/// Creator:sufan
/// w ##class(web.DHCADVRepPrint).QueryChkItmContent(2,"UlcerPart","UlcerPart-95158-95163")
ClassMethod QueryChkItmContent()
{
	;s ret="["
	s Itmtitle="",ItmValList=""
	s ChkItmId=""
	for  s ChkItmId=$o(ChkItmKey(ChkItmId))  Q:ChkItmId=""   d
	.s RecordItmId=$p(ChkItmKey(ChkItmId),"^",2)
	.s ItmCode=$List(^User.DHCAdvFormDicD(ChkItmId),2)						//元素唯一标示，对应界面的ID
	.s ItmDesc=$List(^User.DHCAdvFormDicD(ChkItmId),4)
	.s ItmValue = $lg(^User.DHCAdvFormRecordItmD(RecordItmId),4)  	//值
	.i Itmtitle="" s Itmtitle=ItmCode
	.e  s Itmtitle=Itmtitle_","_ItmCode
	.;i ItmValList="" s ItmValList=ItmValue
	.;e  s ItmValList=ItmValList_"#"_ItmValue
	;s ret=ret_##class(web.DHCADVJSONCOMMON).getJsonDataPort(Itmtitle,ItmValList,"#")
	;s ret=ret_"]"
	q Itmtitle
}

/// Descript:	取table数据
/// Creator:sufan
/// Input: 		报告主表ID,table唯一标识，指定列元素code
/// w ##class(web.DHCADVRepPrint).GetTableData(2,"UlcerPart","UlcerPart-95158-95163")
ClassMethod GetTableData(AdvMasterDr, TableParrefCode, SelItmID)
{
	n (AdvMasterDr,TableParrefCode,SelItmID)
	s Count=0
	s repid=$i(^CacheTemp)
	k ^TMP("DHCADV","web.DHCADVRepPrint","GetTableData")
	q:AdvMasterDr="" ""
	s RsDate="",RsString=""
	s ADVFormRecDr = $p(^DHCADVMASTER(AdvMasterDr),"^",1)
	s ADVFormRecItmDr=""
	f  s ADVFormRecItmDr = $o(^User.DHCAdvFormRecordItmI("IndexFormRecord",ADVFormRecDr,ADVFormRecItmDr))  q:ADVFormRecItmDr=""  d
	.s ADVFormDicID = $lg(^User.DHCAdvFormRecordItmD(ADVFormRecItmDr),3)  		//元素ID
	.s ItmValue = $lg(^User.DHCAdvFormRecordItmD(ADVFormRecItmDr),4)  			//值
	.s ItmID = $lg(^User.DHCAdvFormDicD(ADVFormDicID),2)        				//元素唯一标示，对应界面的ID
	.q:ItmID'[TableParrefCode         											//只保留表格数据
	.q:ItmValue="title"
	.s DataRowKey = $lg(^User.DHCAdvFormRecordItmD(ADVFormRecItmDr),7)  		//Key
	.q:DataRowKey=""
	.s ^TMP("DHCADV","web.DHCADVRepPrint","GetTableData",repid,DataRowKey,ItmID) = ItmValue
	
	s Ret=""
	s DataRowKey="" 
	f  s DataRowKey = $o(^TMP("DHCADV","web.DHCADVRepPrint","GetTableData",repid,DataRowKey)) q:DataRowKey=""  d
	.s HasData="",AreaDesc=""
	.s ItmID= SelItmID
	.f  s ItmID = $o(^TMP("DHCADV","web.DHCADVRepPrint","GetTableData",repid,DataRowKey,ItmID)) q:ItmID=""  d
	..q:ItmID'[SelItmID
	..s Data = $g(^TMP("DHCADV","web.DHCADVRepPrint","GetTableData",repid,DataRowKey,ItmID))
	..i SelItmID'="UlcerPart-95158-95189" d
	...s HasData=1
	...i $l(ItmID,"-")=5 d
	....s:Ret'="" Ret=Ret_"("_Data_")"
	....s:Ret="" Ret=Data
	...i $l(ItmID,"-")'=5 d
	....s:Ret'="" Ret=Ret_","_Data
	....s:Ret="" Ret=Data
	..i SelItmID="UlcerPart-95158-95189" d
	...s HasData=1
	...s:AreaDesc'="" AreaDesc=AreaDesc_"*"_Data
	...s:AreaDesc="" AreaDesc=Data
	.i SelItmID="UlcerPart-95158-95189" d
	..q:+AreaDesc=0
	..s:Ret'="" Ret=Ret_","_AreaDesc
	..s:Ret="" Ret=AreaDesc
	.i HasData="" d
	..s:Ret'="" Ret=Ret_",无"
	..s:Ret="" Ret="无"
	
	q Ret
}

/// Descript:	根据元素id取上级ID
/// Creator:sufan
/// Input:		元素ID,对比的元素ID
/// w ##class(web.DHCADVRepPrint).GetParref(98279,98287)
ClassMethod GetParref(FormDicId, MiddKey = "")
{
	n (FormDicId,MiddKey)
	s ret=""
	s ParrefId=+$List(^User.DHCAdvFormDicD(FormDicId),6)
	i (ParrefId=0)||(MiddKey="") Q FormDicId
	i (MiddKey'="")&&(ParrefId=MiddKey)  Q FormDicId
	e  s FormDicId=..GetParref(ParrefId,MiddKey)
	Q FormDicId
}

/// Descript:	通过父元素取子元素数据
/// Creator:sufan
/// Input:		表单记录ID,lable描述,label code
/// Return:		内容串
/// w ##class(web.DHCADVRepPrint).QueryDataInfo(511,"文化程度","FallDownType")
ClassMethod QueryDataInfo1(record As %String, title As %String, code As %String)
{
	n (record,title,code)
	S RecordItmvalue="",RecordItmID="",QuitList=""
	Q:title="" ""
	s FormDicID=""
	for  s FormDicID=$o(^User.DHCAdvFormDicI("IndexField",$$ALPHAUP^SSUTIL4(code),FormDicID))  Q:FormDicID=""  d
	.Q:FormDicID=""
	.s FormCode=$lg(^User.DHCAdvFormDicD(FormDicID),2)
	.s Dicfiled=$List(^User.DHCAdvFormDicD(FormDicID),2)
	.Q:(Dicfiled'="")&&(code'=Dicfiled)
	.F  S RecordItmID=$o(^User.DHCAdvFormRecordItmI("IndexFormRecord",record,RecordItmID)) Q:RecordItmID=""  D
	..s RecFormDicId=$lg(^User.DHCAdvFormRecordItmD(RecordItmID),3)  	//元素ID
	..s RecFormDicCode=$lg(^User.DHCAdvFormDicD(RecFormDicId),2)  
	..Q:(FormCode'="")&&(RecFormDicCode'[FormCode)
	..S RecordItmvalue=$lg(^User.DHCAdvFormRecordItmD(RecordItmID),4)
	..Q:RecordItmvalue="title"
	..i QuitList="" s QuitList=RecordItmvalue  ;  2020-03-15 cy 注释 不需要拼接_":"
	..e  s QuitList=QuitList_","_RecordItmvalue
	q QuitList
}

/// Descript:	取table的的json数据，输出json key为table的第一行code
/// Creator:sufan
/// Input:		表单记录表ID,table 的code
/// w ##class(web.DHCADVRepPrint).GetDatagridData(510,"BloodGiveList")
/// w ##class(web.DHCADVRepPrint).GetDatagridData(511,"quadruglist")
ClassMethod GetDatagridData(ADVFormRecDr, TableParrefCode)
{
	n (ADVFormRecDr,TableParrefCode)
	s Count=0
	s repid=$i(^CacheTemp)
	k ^TMP("DHCADV","web.DHCADVRepPrint","GetDatagridData")
	s FormDicId=$o(^User.DHCAdvFormDicI("IndexField",$zcvt(TableParrefCode,"U"),""))
	s Style=$lg(^User.DHCAdvFormDicD(FormDicId),3)
	s title=..getTableKeyCol(1,TableParrefCode)								//json数据key
	
	q:ADVFormRecDr="" ""
	s RsDate="",RsString=""
	s ADVFormRecItmDr=""
	f  s ADVFormRecItmDr = $o(^User.DHCAdvFormRecordItmI("IndexFormRecord",ADVFormRecDr,ADVFormRecItmDr))  q:ADVFormRecItmDr=""  d
	.s ADVFormDicID = $lg(^User.DHCAdvFormRecordItmD(ADVFormRecItmDr),3)  	//元素ID
	.s ItmValue = $lg(^User.DHCAdvFormRecordItmD(ADVFormRecItmDr),4)  		//值
	.s ItmID = $lg(^User.DHCAdvFormDicD(ADVFormDicID),2)        			//元素唯一标示，对应界面的ID
	.q:ItmID'[TableParrefCode         										//只保留表格数据
	.q:(ItmValue="title")&&(Style["-input")
	.s:(ItmValue'="")&&(ItmValue'="title")&&(Style["-input") ItmID=ItmID_"-input"
	.s:(ItmValue="title")&&(Style["-input") ItmValue=$lg(^User.DHCAdvFormDicD(FormDicId),4)
	.s DataRowKey = $lg(^User.DHCAdvFormRecordItmD(ADVFormRecItmDr),7)			//Key
	.q:DataRowKey=""
	.s Count=Count+1
	.s ListData=ItmID_"^"_ItmValue
	.Q:+ADVFormDicID=0
	.s:Style="table" MiddId=..getNumSecCode(ADVFormDicID,TableParrefCode)
	.s:Style="datagrid" MiddId=ADVFormDicID
	.i $d(^TMP("DHCADV","web.DHCADVRepPrint","GetDatagridData",repid,DataRowKey,MiddId)) d
	..s $p(^TMP("DHCADV","web.DHCADVRepPrint","GetDatagridData",repid,DataRowKey,MiddId),"^",2)=$p(^TMP("DHCADV","web.DHCADVRepPrint","GetDatagridData",repid,DataRowKey,MiddId),"^",2)_","_ItmValue
	.e  s ^TMP("DHCADV","web.DHCADVRepPrint","GetDatagridData",repid,DataRowKey,MiddId)=ListData
	s Num=0,ret=""
	s ret = "["
	s DataRowKey=0
	f  s DataRowKey = $o(^TMP("DHCADV","web.DHCADVRepPrint","GetDatagridData",repid,DataRowKey)) q:DataRowKey=""  d
	.s Count=0,RsData="",ListTitle=""
	.f  s Count = $o(^TMP("DHCADV","web.DHCADVRepPrint","GetDatagridData",repid,DataRowKey,Count)) q:Count=""  d
	..s Data = ^TMP("DHCADV","web.DHCADVRepPrint","GetDatagridData",repid,DataRowKey,Count)
	..s:RsData'="" RsData = RsData_"^"_$p(Data,"^",2)
	..s:RsData="" RsData= $p(Data,"^",2)
	..s:ListTitle'="" ListTitle = ListTitle_"^"_$lg(^User.DHCAdvFormDicD(Count),2)
	..s:ListTitle="" ListTitle = $lg(^User.DHCAdvFormDicD(Count),2)
	.s ret=ret_$case(Num,0:"",:",")
	.s Num=Num+1
	.s ret=ret_##class(web.DHCADVJSONCOMMON).getJsonDataPort(ListTitle,RsData)
	s ret=ret_"]"
	q ret
}

/// Descript:根据行取table的每列code
/// Creator:sufan
/// Input:table 行号，table 的code
/// w ##class(web.DHCADVRepPrint).getTableKeyCol(1,"BloodGiveList")
ClassMethod getTableKeyCol(Colnum, TableKye)
{
	n (Colnum,TableKye)
	s FormDicId=$o(^User.DHCAdvFormDicI("IndexField",$zcvt(TableKye,"U"),""))
	s Style=$lg(^User.DHCAdvFormDicD(FormDicId),3)
	s Colnum=" "_Colnum
	s ColnumId=""
	s QuitStr="",QuitId=""    //定义返回的code串，定义对应行号的元素ID
	i Style="table"  d		//datagrid 取key
	.for  s ColnumId=$o(^User.DHCAdvFormDicI("IndexTitle",Colnum,ColnumId)) Q:ColnumId=""  d
	..s Filed=$List(^User.DHCAdvFormDicD(ColnumId),2)
	..Q:Filed'[TableKye
	..s QuitId=ColnumId
	e  d
	.s QuitId=FormDicId
	Q:QuitId="" ""
	///循环取table每列的code
	s FormDicId=""
	for  s FormDicId=$o(^User.DHCAdvFormDicI("IndexParef"," "_QuitId,FormDicId))  Q:FormDicId=""  d
	.s Filed=$List(^User.DHCAdvFormDicD(FormDicId),2)
	.i QuitStr="" s QuitStr=Filed
	.e  s QuitStr=QuitStr_"^"_Filed
	Q QuitStr
}

/// Descript:通过元素ID取table第二行元素的code
/// Creator:sufan
/// Input:元素code,table code
/// w ##class(web.DHCADVRepPrint).getNumSecCode(94438,"BloodGiveList")
ClassMethod getNumSecCode(DicId, TableCode)
{
	n (DicId,TableCode)
	s QuitStr=""
	s TableCode=$$ALPHAUP^SSUTIL4(TableCode)
	s TableId=$o(^User.DHCAdvFormDicI("IndexField",TableCode,""))
	s TableDicId=$o(^User.DHCAdvFormDicI("IndexParef"," "_TableId,""),-1)
	
	s QuitId=..GetParref(DicId,TableDicId)
	Q QuitId
}

/// Descript:	获取评价表表单ID串
/// Creator:sufan
/// Input:		表单ID
/// Return:		表单ID+评价表单ID	
/// w ##class(web.DHCADVRepPrint).QueryFormIdList(574)
ClassMethod QueryFormIdList(recordId)
{
	n (recordId)
	s recorIdList=""
	s HeadNurId="",LocHeadNurId="",NurDepId=""
	s recorIdList=recordId
	//s FormNameId=$List(^User.DHCAdvFormRecordD(recordId),2)
	//s FormCode=$List(^User.DHCAdvFormNameD(FormNameId),2)
	//i FormCode="advAccidentFill"  d			//意外
	//.s HeadNurId=##class(web.DHCADVCOMMONPART).GetRecordId(recordId,"AccidentHeaNurEvaluate")
	//i FormCode="advSkinUlcer"  d			//压疮
	//.s HeadNurId=##class(web.DHCADVCOMMONPART).GetRecordId(recordId,"UlcerHeaNurEvaluate")
	//.s HeadNurId=##class(web.DHCADVCOMMONPART).GetRecordId(recordId,"UlcOutHeaNurEvaluate")
	//i FormCode="advDrugUseErr"  d			//药品
	//.s HeadNurId=##class(web.DHCADVCOMMONPART).GetRecordId(recordId,"DrugHeaNurEvaluate")
	//i FormCode="advFallDownFill"  d			//跌倒
	//.s HeadNurId=##class(web.DHCADVCOMMONPART).GetRecordId(recordId,"FDHeaNurEvaluate")
	//i FormCode="advPipeOff"  d				//管路
	//.s HeadNurId=##class(web.DHCADVCOMMONPART).GetRecordId(recordId,"POHeaNurEvaluate")
	//s LocHeadNurId=##class(web.DHCADVCOMMONPART).GetRecordId(recordId,"LocHeaNurEvaluate")
	//s NurDepId=##class(web.DHCADVCOMMONPART).GetRecordId(recordId,"NurDepEvaluate")
	//s recorIdList=recordId_"^"_HeadNurId_"^"_LocHeadNurId_"^"_NurDepId
	s LinkId=""
	for  s LinkId=$o(^User.DHCAdvFormRecordI("IndexLink",recordId,LinkId))  Q:LinkId=""  d
	.i recorIdList="" s recorIdList=LinkId
	.e  s recorIdList=recorIdList_"^"_LinkId
	Q recorIdList
}

/// Descript:获取医疗不良事件评估单数据
/// Creator:sufan
/// Input:报告ID 
/// Table:DHC_AdvRepManage
/// Output:title串，data串
/// w ##class(web.DHCADVRepPrint).QueryAssData(69)
ClassMethod QueryAssData(MasterId)
{
	n (MasterId)
	Q:MasterId="" ""
	s QuitStr="AsseLevel#AsseDealW#AsseImpW#AsseStaOpin#AsseConimpmea",QuitData=""
	s AssId=$o(^DHCADVREPMAN(0,"Pointer",MasterId,""))
	Q:AssId="" ""
	s LevId=$p(^DHCADVREPMAN(AssId),"^",3) 					//评估级别
	s AsseLevel=$s(LevId=0:"非不良事件",LevId=1:"Ⅰ级警告事件(非预期死亡或永久功能丧失)",LevId=2:"Ⅱ级不良后果事件(诊疗造成机体功能损害)",LevId=3:"Ⅲ级未造成后果事件(错误事实有,但未损害)",LevId=4:"Ⅳ级隐患事件(及时发现错误,未形成事实)",1:"")
	s AsseDealId=$p(^DHCADVREPMAN(AssId),"^",5)				//评估处理措施
	s AsseDealW=""
	s:AsseDealId'="" AsseDealW=$p(^DHCADVDEMED(AsseDealId),"^",2)
	s AsseImpId=$p(^DHCADVREPMAN(AssId),"^",6)				//改进措施
	s AsseImpW=""
	s:AsseImpId'="" AsseImpW=$p(^DHCADVIMPMED(AsseImpId),"^",2)
	s AsseStaOpin=$p(^DHCADVREPMAN(AssId),"^",7)			//主管部门意见陈述
	s AsseConimpmea=$p(^DHCADVREPMAN(AssId),"^",8)
	s QuitData=AsseLevel_"#"_AsseDealW_"#"_AsseImpW_"#"_AsseStaOpin_"#"_AsseConimpmea
	Q QuitStr_"^"_QuitData
}

/// Descript:取多级chekbox值
/// Creator:sufan
/// Input:报告ID 
/// Output:title串，data串
/// w ##class(web.DHCADVRepPrint).QueryDataInfo(572,"","RenderService",1)
ClassMethod QueryDataInfo(RecordId, title, code, pid)
{
	n (RecordId,title,code,pid)
	s ConDicId=$o(^User.DHCAdvFormDicI("IndexField",$$ALPHAUP^SSUTIL4(code),""))
	s RetValue=""
	s Ret=0
	k ^TMP("DHCADV","web.DHCADVRepPrint","GetSubItem",pid)
	s Ret= ..GetSubItem(ConDicId, pid)			//存数据
	Q:Ret'=0 "-1"
	s RetValue=..QueryItemValue(RecordId, ConDicId, pid,RetValue)		//取数据
	k ^TMP("DHCADV","web.DHCADVRepPrint","GetSubItem",pid)
	s RetData=""
	Q:RetValue'["-" RetValue
	s Len=$l(RetValue,"-")
	for i=1:1:Len  d
	.s TempList=$p(RetValue,"-",i)
	.;i TempList["," s TempList=$e(TempList,2,$l(TempList))
	.i (TempList[",")&&($e(TempList,1)=",") s TempList=$e(TempList,2,$l(TempList))  ; 2021-07-29 cy  以逗号开始的数据进行摘取（否则会出现勾选元素内容少第一个字的情况）
	.i RetData="" s RetData=TempList
	.e  s RetData=RetData_"-"_TempList
	Q RetData
}

/// Descript:取多级chekbox值
/// Creator:sufan
/// Input:报告ID 
/// Output:title串，data串
/// w ##class(web.DHCADVRepPrint).QueryItemValue(49,93492,1,"")
ClassMethod QueryItemValue(RecordId, ConDicId, pid, RetValue)
{
	n (RecordId, ConDicId, pid,RetValue)
	
	
	s ret=""
	s Index="",Pfalg=0
	for  s Index=$o(^TMP("DHCADV","web.DHCADVRepPrint","GetSubItem",pid,ConDicId,Index))  Q:Index=""  d
	.s RecordItm=+$o(^User.DHCAdvFormRecordItmI("IndexDic",RecordId,Index,""))
	.Q:RecordItm=0
	.s RecordItmValue=""
	.s:RecordItm'=0 RecordItmValue=$LG(^User.DHCAdvFormRecordItmD(RecordItm),4)
	.i (RecordItm=0)&&($d(^TMP("DHCADV","web.DHCADVRepPrint","GetSubItem",pid,Index))) d
	..i RetValue="" s RetValue=$lg(^User.DHCAdvFormDicD(Index),4)
	..e  s RetValue=RetValue_""_$lg(^User.DHCAdvFormDicD(Index),4)
	.i RetValue=""  d
	..i RecordItmValue'="" s RetValue=RecordItmValue
	.e   d
	..i (RecordItmValue'="") s RetValue=RetValue_","_RecordItmValue
	.; 2021-08-06 st cy -input类型元素 value值拼接 元素描述(input值)
	.s ADVFormDicID="",FormDicTitle="",FormDicStyle=""
	.s:RecordItm'=0 ADVFormDicID = $lg(^User.DHCAdvFormRecordItmD(RecordItm),3)  	//元素ID
	.s:ADVFormDicID'="" FormDicStyle=$LG(^User.DHCAdvFormDicD(ADVFormDicID),3)
	.s:ADVFormDicID'="" FormDicTitle=$list(^User.DHCAdvFormDicD(ADVFormDicID),4)
	.s:(RetValue'="title")&&(FormDicStyle["-input") RetValue=FormDicTitle_"("_RetValue_")"
	.; 2021-08-06 end
	.s sunFlag=0
	.i $d(^TMP("DHCADV","web.DHCADVRepPrint","GetSubItem",pid,Index))  d
	..s Pfalg=1
	..s RetValue=RetValue_"-"
	..d ..QueryItemValue(RecordId,Index,pid,.RetValue)
	Q RetValue
}

/// Descript:取多级chekbox值
/// Creator:sufan
/// Input:报告ID 
/// Output:title串，data串
ClassMethod GetSubItem(ConDicId, pid)
{
	n (ConDicId,pid)
	s RetValue=""
	
	s Ret=0
	s SubId=""
	for  s SubId=$o(^User.DHCAdvFormDicI("IndexParef"," "_ConDicId,SubId)) Q:SubId=""  d
	.s ^TMP("DHCADV","web.DHCADVRepPrint","GetSubItem",pid,ConDicId,SubId)=SubId
	.i $d(^User.DHCAdvFormDicI("IndexParef",""_SubId))  d
	.s Ret=..GetSubItem(SubId,pid)
	
	Q Ret
}

/// Descript:	取多级元素数据html串
/// Creator:	congyue
/// Input:		父级元素code 
/// Output:		html串
/// w ##class(web.DHCADVRepPrint).listHtml("advMedicalReportType-label")
ClassMethod listHtml(code)
{
  
  n (code)
  s id = $o(^User.DHCAdvFormDicI("IndexField",$$ALPHAUP^SSUTIL4(code),""))
  // <input type="checkbox" id="HappenPlace-96400" name="215175.94653" value="急诊">急诊
  s dic="",count=0
  f  s dic=$o(^User.DHCAdvFormDicI("IndexParef"," "_id,dic)) q:dic=""  d
  .s dicData=^User.DHCAdvFormDicD(dic)
  .s field=$lg(dicData,2)
  .s Style=$lg(dicData,3)
  .s name=$lg(dicData,4)
  .s newline=$lg(dicData,8)
  .w:newline="Y" "<br/>"
  .i Style'="input" d
  ..w "<input "
  ..w "type="""_$p(Style,"-",1)_""" "
  ..w "id="""_field_""" "
  ..w "name="""_code_""" "
  ..w "value="""_name_""">"_name
  .i Style["-input" d
  ..w "["_field_"-input"_"]"
  .i Style="input" d
  ..w "["_field_"]"
  .d ..listSubHtml(dic,field)
  q ""
}

ClassMethod listSubHtml(id, code)
{
	n (id,code)
	s subId=$o(^User.DHCAdvFormDicI("IndexParef"," "_id,""))
	q:+subId=0
	s subId="",i=0
	f  s subId=$o(^User.DHCAdvFormDicI("IndexParef"," "_id,subId)) q:subId=""  d
	.s subdicData=^User.DHCAdvFormDicD(subId)
	.s subfield=$lg(subdicData,2)
	.s subStyle=$lg(subdicData,3)
	.s subname=$lg(subdicData,4)
	.s subnewline=$lg(subdicData,8)
  	.w:subnewline="Y" "<br/>"
	.i subStyle'="input" d
	..w "<input "
	..w "type="""_$p(subStyle,"-",1)_""" "
	..w "id="""_subfield_""" "
	..w "name="""_code_""" "
	..w "value="""_subname_""">"_subname
	.i subStyle["-input" d
	..w "["_subfield_"-input"_"]"
	.i subStyle="input" d
	..w "["_subfield_"]"
	.d ..listSubHtml(subId,subfield)
	q ""
}

}
