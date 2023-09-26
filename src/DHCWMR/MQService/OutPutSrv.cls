/// 名称: DHCWMR.MQService.OutPutSrv
/// 描述: 病案综合查询
/// 编写者：zhufei
/// 编写日期: 2014-12-26
Class DHCWMR.MQService.OutPutSrv Extends DHCWMR.Abstract [ Not ProcedureBlock ]
{

///  Creator：     liyi
///  CreatDate：   2016-04-07
///  Description:  综合查询导出进度
///  Input：	   itmjs:"fillxlSheet"
/// 	 		   aDataIndex:后台唯一标示(客户端MAC地址)
/// 				   SysExportFlg:系统导出标志(0:通过前台进入方法 1:前台递归调用方法)
/// 				   aViewFields:前台显示列
/// 				   total:需导出总数
///  Return：      Josn:"{fillxlCode:'',RadioNum:'',BarText:'',ExportStop:'',SysExportFl:'',err:''}"
/// 	 d ##class(DHCWMR.MQService.OutPutSrv).ExportProcess("fillxlSheet","00:50:56:C0:00:08","1","item1"_$c(1)_"item2"_$c(1)_"item3"_$c(1)_"item4"_$c(1)_"item5"_$c(1)_"item6"_$c(1)_"item7"_$c(1)_"item8"_$c(1)_"item9"_$c(1)_"item10"_$c(1)_"item11"_$c(1)_"item12"_$c(1)_"item13"_$c(1)_"item14"_$c(1)_"item15"_$c(1)_"item16"_$c(1)_"item17"_$c(1)_"item18"_$c(1)_"item19"_$c(1)_"item20"_$c(1)_"item21"_$c(1)_"item22"_$c(1)_"item23"_$c(1)_"item24"_$c(1)_"item25"_$c(1)_"item26"_$c(1)_"item27"_$c(1)_"item28"_$c(1)_"item29"_$c(1)_"item30"_$c(1)_"item31"_$c(1)_"item32"_$c(1)_"item33"_$c(1)_"item34"_$c(1)_"item35"_$c(1)_"item36"_$c(1)_"item37"_$c(1)_"item38"_$c(1)_"item39"_$c(1)_"item40"_$c(1)_"item41"_$c(1)_"item42"_$c(1)_"item43"_$c(1)_"item44"_$c(1)_"item45"_$c(1)_"item46"_$c(1)_"item47"_$c(1)_"item48","835")
ClassMethod ExportProcess(itmjs As %String, aDataIndex As %String, SysExportFlg As %String, aViewFields As %String, total As %String)
{
	New (itmjs,aDataIndex,SysExportFlg,aViewFields,total)
	
	Set aDataIndex=$tr(aDataIndex,":","")	//获取临时Global进程号
	If (aDataIndex="")||(aViewFields="")||(SysExportFlg="")||(total=""){
		Set RadioNum=0,BarText="",ExportStop=1,Err="参数错误!"
		Do WriteExJson
		Quit
	}
	Set Repid=aDataIndex
	Set $ZT="ExportProcessErr"
	If (SysExportFlg=0){
		M ^CacheTemp("MRQ","TmpExportMaster",Repid) = ^CacheTemp("MRQ","ExportMaster",Repid)	//复制首次前台调用时应该导出的数据
	}
	if $d(^CacheTemp("MRQ","ExportMaster",Repid)){
		Set json="{fillxlCode:"_""""
		Write json
		set Row=(+$g(^CacheTemp("MRQ",Repid,"ExportCnt")))+2
		Set Properties=##class(DHCWMR.SSService.ExcelSrv).GetQryProperties("DHCWMR.MQService.OutPutSrv","QryOutMaster")
		Set MasterID = ""
		Set json=""
		For {
			Set MasterID = $o(^CacheTemp("MRQ","ExportMaster",Repid,MasterID))
			Quit:MasterID=""
			Set objDataMaster = ##class(DHCWMR.MQ.DataMaster).GetObjById(MasterID)
			Continue:'$isobject(objDataMaster)
		
			Set rs=##Class(%Library.ResultSet).%New("DHCWMR.MQService.OutPutSrv:QryOutMaster")
			Do rs.Execute(MasterID,Repid)
			Set retval=""
			while(rs.Next()){
				set RowData=""
				for Col=1:1:$length(aViewFields,$c(1)) {
					set Field=$p(aViewFields,$c(1),Col)
					set:$zcvt(Field,"U")="CHECKED" Field=""
					if Field'="" {
						if ($ListFind(Properties,Field)>0) {
							set FieldVal=rs.Data(Field)
						}else{
							if Field="RowNumberer" {
								set FieldVal=count+1
							} else {
								set FieldVal=""
							}
						}
					}else{
						set FieldVal=""
					}
					set RowData=RowData_$c(1)_FieldVal
				}
				continue:RowData=""
				set RowData=$e(RowData,2,$l(RowData))
				Set retval=itmjs_"(xlSheet,'"_$ZCVT(RowData,"O","JS")_"',"_Row_","_1_");"
				set Row=Row+1
			}
			do rs.Close()
			Kill:retval="" ^CacheTemp("MRQ","ExportMaster",Repid,MasterID) 	//清除临时数据
			Continue:retval=""
			Set retvalLength = $l(retval)
			Set jsonLength = $l(json)
			Quit:(retvalLength+jsonLength)>=32765	//超过字符串最大长度退出
			Kill ^CacheTemp("MRQ","ExportMaster",Repid,MasterID)	//清除临时数据
			Set json=json_retval
			Set ^CacheTemp("MRQ",Repid,"ExportCnt") = (+$g(^CacheTemp("MRQ",Repid,"ExportCnt")))+1
		}
		Write:json'="" json_""""
		Set ExportCnt=+$g(^CacheTemp("MRQ",Repid,"ExportCnt"))
		Set RadioNum=$fn(ExportCnt/total,"",4)
		Set Bartext=RadioNum*100
		Set:Bartext<1 Bartext="0"_Bartext
		Set Bartext="导出数据进度("_Bartext_"%"_")...共导出"_total_"条数据！"
		Set json = ",RadioNum:'"_RadioNum_"',BarText:'"_Bartext_"',ExportStop:'0',SysExportFlg:'1',err:''}"
		Write json,!
		Quit
	}
	Set RadioNum=1,BarText="导出数据完成...",ExportStop=1,SysExportFlg=1,Err=""
	Do WriteExJson
	//清除所有临时数据
	Kill ^CacheTemp("MRQ",Repid,"ExportCnt")
	//Kill ^CacheTemp("MRQ","OutCol",Repid)			//暂不清除，二次导出调用
	M ^CacheTemp("MRQ","ExportMaster",Repid) = ^CacheTemp("MRQ","TmpExportMaster",Repid)
	Kill ^CacheTemp("MRQ","TmpExportMaster",Repid)	//清除临时数据
	Quit
	
ExportProcessErr
	Kill ^CacheTemp("MRQ",Repid)	//清空临时Global节点
	Kill ^CacheTemp("MRQ","OutCol",Repid)
	Set json="{fillxlCode:'',RadioNum:'0',BarText:'',ExportStop:'1',SysExportFlg:'1',err:'系统错误:"_$ZError_"'}"
	Write json,!
	Quit
	
WriteExJson
	Set json="{fillxlCode:'',RadioNum:'"_RadioNum_"',BarText:'"_BarText_"',ExportStop:'"_ExportStop_"',SysExportFlg:'"_SysExportFlg_"',err:'"_Err_"'}"
	Write json,!
	Quit
}

///  Creator：     liyi
///  CreatDate：   2016-04-07
///  Description:  综合查询查询进度
///  Input：	   aCondID:条件样式ID
/// 	 		   aDataIndex:后台唯一标示(客户端MAC地址)
/// 				   aDateTypeID:日期类型ID
/// 				   aDateFrom:检索开始日期
/// 				   aDateTo:检索结束日期
/// 				   SysQryFlag:系统查询标志(0:通过前台进入方法 1:前台递归调用方法)
///  Return：      Josn:"{record:[],RadioNum:'',BarText:'',taskStop:'',SysQryFlag:'',err:''}"
/// d ##class(DHCWMR.MQService.OutPutSrv).Process(1,"005056C00008",151,"2013-01-13","2013-01-13",0)
ClassMethod Process(aCondID As %String, aDataIndex As %String, aDateTypeID As %String, aDateFrom As %String, aDateTo As %String, SysQryFlag As %String)
{
	New (aCondID,aDataIndex,aDateFrom,aDateTo,aDateTypeID,SysQryFlag)
		
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateFrom["/" aDateFrom=$zdh(aDateFrom,4)
	Set aDateFrom=+aDateFrom
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set:aDateTo["/" aDateTo=$zdh(aDateTo,4)
	Set aDateTo=+aDateTo
	Set objDateType = ##class(DHCWMR.SS.Dictionary).GetObjById(aDateTypeID)
	If '$isobject(objDateType){
		Set Err="日期类型错误!",RadioNum=0,BarText="",taskStop=1
		DO WriteJson
		Quit
	}
	Set DateType = objDateType.SDCode
	Set aDataIndex=$tr(aDataIndex,":","")		//获取临时Global进程号
	Set Repid=aDataIndex
	If (aDataIndex="")||(DateType="")||(aCondID="")||(aDateFrom=0)||(aDateTo=0)||(aDateFrom>aDateTo)||(aDateTypeID="")||(SysQryFlag=""){
		Set Err="查询条件错误!",RadioNum=0,BarText="",taskStop=1
		DO WriteJson
		Quit
	}
	
	Set MQQuerySet=##class(DHCWMR.SSService.ConfigSrv).GetValueByKeyHosp("MQQuerySet","")
	Set ScreennNum = $p(MQQuerySet,"^",1)		//筛查条数限制
	Set LoadNum = $p(MQQuerySet,"^",2)			//输出条数限制
	If (+ScreennNum=0)||(+LoadNum=0){
		Set Err="系统筛查、输出条件设置错误!",RadioNum=0,BarText="",taskStop=1
		DO WriteJson
		Quit
	}
	If (SysQryFlag=0) {
		Kill ^CacheTemp("MRQ",Repid)					//点击前台按钮进入方法清除临时数据
		Kill ^CacheTemp("MRQ","ExportMaster",Repid)		//清除导出节点
		Kill ^CacheTemp("MRQ","TmpExportMaster",Repid)	//清除导出临时节点
		Kill ^CacheTemp("MRQ","OutCol",Repid)			//清除输出临时数据
	}
	
	Set $ZT="ProcessErr"
	
	//步骤1：清空之前查询临时Global,获取查询条件
	if +$g(^CacheTemp("MRQ",Repid,"CurrStep"))=0{
		Kill ^CacheTemp("MRQ",Repid)
		Set flg=..GetInputItem(Repid,aCondID)
		If flg'="OK" {
			Kill ^CacheTemp("MRQ",Repid)
			Set Err="获取查询条件错误!",RadioNum=0,BarText="",taskStop=1
			DO WriteJson
			Quit
		}
		Set ^CacheTemp("MRQ",Repid,"CurrStep")=1
		Set Err="",RadioNum=0,BarText="查询条件准备就绪...",taskStop=0,SysQryFlag=1
		DO WriteJson
		Quit
	}
	//步骤2：获取输出列
	if +$g(^CacheTemp("MRQ",Repid,"CurrStep"))=1{
		Kill ^CacheTemp("MRQ","OutCol",Repid)
		Set flg=..GetOutCol(Repid,aCondID)
		If flg'="OK" {
			Kill ^CacheTemp("MRQ","OutCol",Repid)
			Set Err="获取输出列错误!",RadioNum=0,BarText="",taskStop=1
			DO WriteJson
			Quit
		}
		Set ^CacheTemp("MRQ",Repid,"CurrStep")=2
		Set Err="",RadioNum=0,BarText="输出条件准备就绪...",taskStop=0,SysQryFlag=1
		DO WriteJson
		Quit
	}
	
	//步骤3：获取应查询病历数
	if +$g(^CacheTemp("MRQ",Repid,"CurrStep"))=2{
		Kill ^CacheTemp("MRQ",Repid,"Master")
		Set flg=..GetAdmList(Repid,DateType,aDateFrom,aDateTo)
		If flg'="OK" {
			Kill ^CacheTemp("MRQ",Repid,"Master")
			Kill ^CacheTemp("MRQ",Repid,"MasterCnt")
			Set Err="获取应查询病历数错误!"
			DO WriteJson
			Quit
		}
		Set ^CacheTemp("MRQ",Repid,"CurrStep")=3
		Set Err="",RadioNum=0,BarText="应查病历准备就绪...",taskStop=0,SysQryFlag=1
		DO WriteJson
		Quit
	}
	
	//步骤4：筛查符合条件病历
	if +$g(^CacheTemp("MRQ",Repid,"CurrStep"))=3{
		Set ComplitFlg = $d(^CacheTemp("MRQ",Repid,"Master"))		//是否还有病历需要筛查
		if (ComplitFlg=0){
			Set ^CacheTemp("MRQ",Repid,"CurrStep")=4
			Set Err="",RadioNum=1,BarText="筛查完成...",taskStop=0,SysQryFlag=1
			DO WriteJson
			Quit
		}
		Set MasterID="",Count=0
		For {
			Set MasterID=$o(^CacheTemp("MRQ",Repid,"Master",MasterID))
			Quit:MasterID=""
			Quit:Count>ScreennNum  //超过筛查设置条数
			
			Kill ^CacheTemp("MRQ",Repid,"Master",MasterID)
			Set flg = ..CheckMaster(Repid,MasterID)
			If flg'="OK" {
				Kill ^CacheTemp("MRQ",Repid,"TmpMaster",MasterID)
				Set Err="筛查病历错误!",RadioNum=0,BarText="",taskStop=1,SysQryFlag=1
				DO WriteJson
				Quit
			}
			Set Count=Count+1
		}
		Set MasterCnt=+$g(^CacheTemp("MRQ",Repid,"MasterCnt"))
		Set MatchMsterCnt=+$g(^CacheTemp("MRQ",Repid,"MatchMsterCnt"))
		Set RadioNum=$fn(MatchMsterCnt/MasterCnt,"",4)
		Set BarText=RadioNum*100
		Set:BarText<1 BarText="0"_BarText
		Set BarText="筛查进度("_BarText_"%"_")...共筛查"_MasterCnt_"份病历！"
		Set Err="",taskStop=0,SysQryFlag=1
		DO WriteJson
		Quit
	}
	//步骤5：映射导出所需节点
	if +$g(^CacheTemp("MRQ",Repid,"CurrStep"))=4{
		M ^CacheTemp("MRQ","ExportMaster",Repid) = ^CacheTemp("MRQ",Repid,"TmpMaster")	//任务进行完后不清除,下次查询清除/导出完成后清除
		Set ^CacheTemp("MRQ",Repid,"CurrStep")=5
		Set Err="",RadioNum=0,BarText="映射导出数据...",taskStop=0,SysQryFlag=1
		DO WriteJson
		Quit
	}
	
	//步骤6：组织输出数据
	if +$g(^CacheTemp("MRQ",Repid,"CurrStep"))=5{
		Set ComplitFlg = $d(^CacheTemp("MRQ",Repid,"TmpMaster"))		//是否还有病历需要输出
		if (ComplitFlg=0){
			Set ^CacheTemp("MRQ",Repid,"CurrStep")=6
			Set Err="",RadioNum=1,BarText="读取数据完成...",taskStop=0,SysQryFlag=1
			DO WriteJson
			Quit
		}
		Set json="{record:["
		Write json,!
		Set MasterID="",Count=0,NotNullCount=0
		For {
			Set MasterID=$o(^CacheTemp("MRQ",Repid,"TmpMaster",MasterID))
			Quit:MasterID=""
			Quit:Count>LoadNum		//超过输出设置条数
			Set json=""
			Kill ^CacheTemp("MRQ",Repid,"TmpMaster",MasterID)
			Set objDataMaster = ##class(DHCWMR.MQ.DataMaster).GetObjById(MasterID)
			Continue:'$isobject(objDataMaster)
			Set rs=##Class(%Library.ResultSet).%New("DHCWMR.MQService.OutPutSrv:QryOutMaster")
			Do rs.Execute(MasterID,Repid)
			while(rs.Next()){
				Set EpisodeID=rs.Data("EpisodeID") 
				Set json = "{EpisodeID:"_"'"_EpisodeID_"'"
				For i=2:1:rs.GetColumnCount(){
					Set json = json_","_rs.GetColumnName(i)_":"_"'"_rs.GetData(i)_"'"
				}
				Set json = json_"}"
			}
			Set Count=Count+1
			do rs.Close()
			Set ^CacheTemp("MRQ",Repid,"OutMasterCnt")=(+$g(^CacheTemp("MRQ",Repid,"OutMasterCnt")))+1
			Continue:json=""		//输出列没有数据退出
			Set NotNullCount=NotNullCount+1
			Set:NotNullCount>1 json=","_json
			Write:json'="" json,!
		}
		Set MatchMsterCnt=+$g(^CacheTemp("MRQ",Repid,"MatchMsterCnt"))
		Set OutMasterCnt=+$g(^CacheTemp("MRQ",Repid,"OutMasterCnt"))
		Set RadioNum=$fn(OutMasterCnt/MatchMsterCnt,"",4)
		Set BarText=RadioNum*100
		Set:BarText<1 BarText="0"_BarText
		Set BarText="读取数据进度("_BarText_"%"_")...共读取"_MatchMsterCnt_"条数据！"
		Set json="],RadioNum:'"_RadioNum_"',BarText:'"_BarText_"',taskStop:'0',SysQryFlag:'1',err:''}"	
		Write json,!
		Quit
	}
	Kill ^CacheTemp("MRQ",Repid)	//清空临时Global节点
	Set Err="",RadioNum=1,BarText="读取数据完成...",taskStop=1,SysQryFlag=1
	DO WriteJson
	Quit
	
ProcessErr
	Kill ^CacheTemp("MRQ",Repid)	//清空临时Global节点
	Set json="{record:[],RadioNum:'0',BarText:'',taskStop:'1',SysQryFlag:'',err:'系统错误:"_$ZError_"'}"
	Write json,!
	Quit
	
WriteJson
	Set json="{record:[],RadioNum:'"_RadioNum_"',BarText:'"_BarText_"',taskStop:'"_taskStop_"',SysQryFlag:'"_SysQryFlag_"',err:'"_Err_"'}"
	Write json,!
	Quit
}

///  Creator：     liyi
///  CreatDate：   2016-04-03
///  Description:  Query单个记录输出数据
///  Input：	   aMasterID： DHCWMR.MQ.DataMaster.ID
/// 	 		   Repid：	   进程标示ID
///  Return：      返回Query
///  d ##class(%ResultSet).RunQuery("DHCWMR.MQService.OutPutSrv","QryOutMaster",2,"005056C00008")
Query QryOutMaster(aMasterID As %String, Repid As %String) As %Query(ROWSPEC = "EpisodeID:%String,item1:%String,item2:%String,item3:%String,item4:%String,item5:%String,item6:%String,item7:%String,item8:%String,item9:%String,item10:%String,item11:%String,item12:%String,item13:%String,item14:%String,item15:%String,item16:%String,item17:%String,item18:%String,item19:%String,item20:%String,item21:%String,item22:%String,item23:%String,item24:%String,item25:%String,item26:%String,item27:%String,item28:%String,item29:%String,item30:%String,item31:%String,item32:%String,item33:%String,item34:%String,item35:%String,item36:%String,item37:%String,item38:%String,item39:%String,item40:%String,item41:%String,item42:%String,item43:%String,item44:%String,item45:%String,item46:%String,item47:%String,item48:%String,item49:%String,item50:%String")
{
}

ClassMethod QryOutMasterExecute(ByRef qHandle As %Binary, MasterID As %String, Repid As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	Quit:(MasterID="")||(Repid="") $$$OK
	
	Set objDataMaster = ##class(DHCWMR.MQ.DataMaster).GetObjById(MasterID)
	Quit:'$isobject(objDataMaster) $$$OK
	
	Set EpisodeID = objDataMaster.EpisodeID
	Quit:'$d(^CacheTemp("MRQ","OutCol",Repid)) $$$OK	//没有输出列
	//初始化输出变量
	For i=1:1:50{
		Set ExpItem="Set item"_i_"="_""""_""""
		x ExpItem
	}
	//组织输出
	Set indCol=""
	For {
		Set indCol = $o(^CacheTemp("MRQ","OutCol",Repid,indCol))
		Quit:indCol=""
		
		Set tmpColumn=$g(^CacheTemp("MRQ","OutCol",Repid,indCol))
		Continue:tmpColumn=""
		
		Set OutType = $list(tmpColumn,1)
		Set OutID = $list(tmpColumn,2)
		Set OutDesc = $list(tmpColumn,3)
		//输出整个子类数据项
		Set Exp="",OutValue=""
		if OutType="DataSubCat"{
			Set SubCatID = OutID
			Set xDataItemID="",xDataItemCount=0
			For {
				Set xDataItemID = $o(^DHCWMR.MQ.DataItemsI("IndexItemSubCat",SubCatID,xDataItemID))
				Quit:xDataItemID=""
				Continue:'$d(^DHCWMR.MQ.DataMasterI("DataRecord","IndexParRefItem",MasterID,xDataItemID))		//同步没有值
	
				Set objItem = ##class(DHCWMR.MQ.DataItems).GetObjById(xDataItemID)
				Continue:'$isobject(objItem)
				Set xDataItemCount = xDataItemCount+1
				Set RecordID = $o(^DHCWMR.MQ.DataMasterI("DataRecord","IndexParRefItem",MasterID,xDataItemID,""))
				Set objRecord = ##class(DHCWMR.MQ.DataRecord).GetObjById(MasterID_"||"_RecordID)
				Continue:'$isobject(objRecord)
				
				Set ItemDesc = objItem.MRItemDesc
				Set ItemValue = objRecord.ItemValue
				Set ValueType=objRecord.ValType
				//存储值转换为有意义的值
				Set ItemValue=..ChangeValToDisplay(ItemValue,ValueType)
				//Set OutValue = OutValue_"#"_ItemDesc_":"_ItemValue
				Set OutValue = OutValue_" "_ItemValue
			}
			Set OutValue=$e(OutValue,2,$l(OutValue))
			Set:xDataItemCount=1 OutValue=ItemValue			//子类下只有一个数据项
			Set Exp="Set item"_indCol_"="_""""_OutValue_""""
		}
		//输出单个数据项
		if OutType="DataItem"{
			Set DataItemID =OutID
			Continue:'$d(^DHCWMR.MQ.DataMasterI("DataRecord","IndexParRefItem",MasterID,DataItemID))		//同步没有值
			
			Set objItem = ##class(DHCWMR.MQ.DataItems).GetObjById(DataItemID)
			Continue:'$isobject(objItem)

			Set RecordID = $o(^DHCWMR.MQ.DataMasterI("DataRecord","IndexParRefItem",MasterID,DataItemID,""))
			Set objRecord = ##class(DHCWMR.MQ.DataRecord).GetObjById(MasterID_"||"_RecordID)
			Continue:'$isobject(objRecord)
			Set ValueType=objRecord.ValType
			Set ItemValue = objRecord.ItemValue
			//存储值转换为有意义的值
			Set ItemValue=..ChangeValToDisplay(ItemValue,ValueType)
			Set Exp="Set item"_indCol_"="_""""_ItemValue_""""
		}
		x Exp
	}
	Set CheckNullFfalg=1
	Set Data = $lb(EpisodeID)
	For i=1:1:50{
		Set ExpCheckNull = "Set CheckNullFfalg=CheckNullFfalg&&(item"_i_"="_""""_""""_")"
		Set ExpData = "Set Data=Data_$lb(item"_i_")"
		x ExpCheckNull
		x ExpData
	}
	Quit:CheckNullFfalg $$$OK //如果输出列全部为空不输出(没有数据显示)
	
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	
	Quit $$$OK
}

ClassMethod QryOutMasterClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOutMasterExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryOutMasterFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOutMasterExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	
	Quit $$$OK
}

/// Creator：     liyi
/// CreatDate：   2016-04-03
/// Description:  单个病人信息是否符合一个条件
/// Input：       aMasterID：主表ID
/// 				  aInput : 单个查询条件
/// Return：      1：符合 0：不符合
/// w ##class(DHCWMR.MQService.OutPutSrv).CheckRecordInput()
ClassMethod CheckRecordInput(aMasterID As %String, aInput As %List) As %Boolean
{
	New (aInput,aMasterID)
	Set return = 0
	Quit:(aInput="")||(aMasterID="") return
	Set QryType 	= $list(aInput,1)
	Set QryID 		= $list(aInput,2)
	Set OperCode 	= $list(aInput,3)
	Set CompVal 	= $list(aInput,4)
	Set LogicalCode = $list(aInput,5)
	Quit:(QryType="")||(QryID="")||(OperCode="")||(CompVal="") return
	
	//比较项为子类
	If QryType="DataSubCat"{
		//比较子类下所有数据项
		Set SubCatID = QryID
		Set xDataItemID=""
		For {
			Set xDataItemID = $o(^DHCWMR.MQ.DataItemsI("IndexItemSubCat",SubCatID,xDataItemID))
			Quit:xDataItemID=""
			Continue:'$d(^DHCWMR.MQ.DataMasterI("DataRecord","IndexParRefItem",aMasterID,xDataItemID))		//同步没有值
			
			Set objItem = ##class(DHCWMR.MQ.DataItems).GetObjById(xDataItemID)
			Continue:'$isobject(objItem)
			Set RecordID = $o(^DHCWMR.MQ.DataMasterI("DataRecord","IndexParRefItem",aMasterID,xDataItemID,""))
			Set objRecord = ##class(DHCWMR.MQ.DataRecord).GetObjById(aMasterID_"||"_RecordID)
			Continue:'$isobject(objRecord)
			Set ItemValue = objRecord.ItemValue
			Set ItemValueType = objRecord.ValType	//存储值类型
			Set DataType=objItem.DataType			//数据项类型
			//转换为统一格式、输入值转换为存储值类型
			Set CompVal=..ChangeValType(CompVal,ItemValueType)
			//比较
			Set flg=..Compare(ItemValue,OperCode,CompVal,ItemValueType) 
			Continue:flg<1
			Set return=1 //符合查询条件
		}
	}
	//比较项为数据项
	If QryType="DataItem"{
		Set DataItemID=QryID
		Quit:'$d(^DHCWMR.MQ.DataMasterI("DataRecord","IndexParRefItem",aMasterID,DataItemID)) return	//同步没有值
			
		Set objItem = ##class(DHCWMR.MQ.DataItems).GetObjById(DataItemID)
		Quit:'$isobject(objItem) return
		
		Set RecordID = $o(^DHCWMR.MQ.DataMasterI("DataRecord","IndexParRefItem",aMasterID,DataItemID,""))
		Set objRecord = ##class(DHCWMR.MQ.DataRecord).GetObjById(aMasterID_"||"_RecordID)
		Quit:'$isobject(objRecord) return
		
		Set ItemValue = objRecord.ItemValue
		Set ItemValueType = objRecord.ValType
		Set DataType=objItem.DataType
		//转换为统一格式、输入值转换为存储值类型
		Set CompVal=..ChangeValType(CompVal,ItemValueType)
		//比较
		Set flg=..Compare(ItemValue,OperCode,CompVal,ItemValueType)
		Quit:flg<1 return
		Set return=1 //符合查询条件
	}
	Quit return
}

///  Creator：     liyi
///  CreatDate：   2016-04-06
///  Description:  筛查单个病历是否满足条件
///  Input：	   Repid:后台唯一标示(客户端MAC地址)
/// 	 		   MasterID:主表ID
///  Return：      空:不满足条件
/// 				   "OK":满足条件并记录主表ID
/// w ##class(DHCWMR.MQService.OutPutSrv).CheckMaster()
ClassMethod CheckMaster(Repid As %String, MasterID As %String)
{
	New (MasterID,Repid)
	Set return=""
	Quit:(MasterID="")||(Repid="") return
	
	Set $ZT="CheckMasterErr"	
	Set objDataMaster = ##class(DHCWMR.MQ.DataMaster).GetObjById(MasterID)
	Quit:'$isobject(objDataMaster) return
	if $d(^CacheTemp("MRQ",Repid,"InputItem")){  //匹配查询条件
		Set LogicalExp = ""		//多个条件组合表达式
		Set xInputID = ""
		For {
			Set xInputID = $o(^CacheTemp("MRQ",Repid,"InputItem",xInputID))
			Quit:xInputID=""
			Set tmpInput=$g(^CacheTemp("MRQ",Repid,"InputItem",xInputID))
			Continue:tmpInput=""
			Set LogicalCode = $list(tmpInput,5)
			Set flg =..CheckRecordInput(MasterID,tmpInput)	//单个条件是否匹配
			Set LogicalExp=$s(LogicalCode="":flg,LogicalCode'="":LogicalExp_LogicalCode_flg)	//查询条件大于一条进行逻辑匹配
		}
		Set flg=..ExamExp(LogicalExp)
		Quit:(LogicalExp'="")&&(flg'=1) "OK"
	}
	Set ^CacheTemp("MRQ",Repid,"TmpMaster",MasterID)=""	//没有条件也可查询
	Set ^CacheTemp("MRQ",Repid,"MatchMsterCnt")=+$g(^CacheTemp("MRQ",Repid,"MatchMsterCnt"))+1
	Quit "OK"
	
CheckMasterErr
	Kill ^CacheTemp("MRQ",Repid,"TmpMaster")
	Kill ^CacheTemp("MRQ",Repid,"MatchMsterCnt")
	Quit $ZError
}

///  Creator：     liyi
///  CreatDate：   2016-04-06
///  Description:  获取查询任务时间段内应查询人数
///  Input：	   Repid:后台唯一标示(客户端MAC地址)
/// 	 		   DateType:日期类型（编目/出院）
/// 				   DateFrom:开始日期
/// 				   DateTo:结束日期
///  Return：      空:参数错误
/// 				   "OK":满足条件并记录主表ID
/// w ##class(DHCWMR.MQService.OutPutSrv).GetAdmList()
ClassMethod GetAdmList(Repid As %String, DateType As %String, DateFrom As %String, DateTo As %String)
{
	New (DateType,Repid,DateFrom,DateTo)
	Set return=""
	
	Set $ZT="GetAdmListErr"
	Set:DateFrom["-" DateFrom=$zdh(DateFrom,3)
	Set:DateFrom["/" DateFrom=$zdh(DateFrom,4)
	Set DateFrom=+DateFrom
	Set:DateTo["-" DateTo=$zdh(DateTo,3)
	Set:DateTo["/" DateTo=$zdh(DateTo,4)
	Set DateTo=+DateTo
	Quit:(DateType="")||(Repid="")||(DateFrom="")||(DateTo="") return
	
	Set DateIndex=$s(DateType=1:"IndexDischDate",1:"IndexFPDate")
	Set Count = 0
	For xDate = DateFrom:1:DateTo{
		Set xMasterID=0
		For {
			Set xMasterID=$o(^DHCWMR.MQ.DataMasterI(DateIndex,xDate,xMasterID))
			Quit:xMasterID=""
			
			Set objDataMaster = ##class(DHCWMR.MQ.DataMaster).GetObjById(xMasterID)
			Continue:'$isobject(objDataMaster)
			Set Paadm = objDataMaster.EpisodeID
			Set Count = Count+1
			Set ^CacheTemp("MRQ",Repid,"Master",xMasterID)=""
		}
	}
	Set ^CacheTemp("MRQ",Repid,"MasterCnt")=Count
	Quit "OK"
	
GetAdmListErr
	Kill ^CacheTemp("MRQ",Repid,"Master")
	Kill ^CacheTemp("MRQ",Repid,"MasterCnt")
	Quit $ZError
}

///  Creator：     liyi
///  CreatDate：   2016-04-06
///  Description:  获取并记录输出列
///  Input：	   Repid:后台唯一标示(客户端MAC地址)
/// 	 		   CondID:条件样式ID
///  Return：      空:参数错误
/// 				   "OK":条件记录成功
/// w ##class(DHCWMR.MQService.OutPutSrv).GetOutCol()
ClassMethod GetOutCol(Repid As %String, CondID As %String)
{
	New (CondID,Repid)
	Set return=""
	Quit:(Repid="")||(CondID="") return
	
	Set $ZT="GetOutColErr"
	Set objCond = ##class(DHCWMR.MQ.CondConfig).GetObjById(CondID)
	Quit:'$isobject(objCond) return

	For indCol=1:1:objCond.ChildCol.Count() {
		Set objCol=objCond.ChildCol.GetAt(indCol)
		Continue:'$IsObject(objCol)
		Set objSubCat=objCol.ColSubCat
		Set objDataItem=objCol.ColDataItem
		Continue:(objDataItem="")&&(objSubCat="")
		if $isobject(objSubCat){
			Set ID = objSubCat.%Id()
			Set Desc = objSubCat.DSCDesc
			Set OutType = "DataSubCat"
		}
		if $isobject(objDataItem){
			Set ID = objDataItem.%Id()
			Set Desc = objDataItem.MRItemDesc
			Set OutType = "DataItem"
		}
		Set ^CacheTemp("MRQ","OutCol",Repid,indCol)=$lb(OutType,ID,Desc)
	}
	Quit "OK"
	
GetOutColErr
	Kill ^CacheTemp("MRQ","OutCol",Repid)
	Quit $ZError
}

///  Creator：     liyi
///  CreatDate：   2016-04-06
///  Description:  获取并记录查询条件
///  Input：	   Repid:后台唯一标示(客户端MAC地址)
/// 	 		   CondID:条件样式ID
///  Return：      空:参数错误
/// 				   "OK":条件记录成功
/// w ##class(DHCWMR.MQService.OutPutSrv).GetInputItem()
ClassMethod GetInputItem(Repid As %String, CondID As %String)
{
	New (CondID,Repid)
	Set return=""
	Quit:(Repid="")||(CondID="") return
	
	Set $ZT="GetInputItemErr"
	Set objCond = ##class(DHCWMR.MQ.CondConfig).GetObjById(CondID)
	Quit:'$isobject(objCond) return
	
	Set InputStr = objCond.CCInputStr	//查询条件
	For indInput=1:1:$l(InputStr,$c(1)) {
		Set tmpInput=$p(InputStr,$c(1),indInput)
		Continue:tmpInput=""
	
		Set QryType = $p($p(tmpInput,$c(2),1),$c(3),1)			//类型"DataSubCat"、"DataItem"
		Set QryID = $p($p(tmpInput,$c(2),1),$c(3),2)		
		Set OperID = $p(tmpInput,$c(2),2)
		Set CompVal = $p(tmpInput,$c(2),3)
		Continue:(QryID="")||(OperID="")||(CompVal="")

		Set LogicalID = $p(tmpInput,$c(2),4)
		Set objOperDic = ##class(DHCWMR.SS.Dictionary).GetObjById(OperID)
		Continue:'$isobject(objOperDic)
	
		Set OperDesc = objOperDic.SDDesc
		Set OperCode=##class(DHCWMR.MQService.ConditionSrv).ChangeOperCode(OperDesc)
		Set LogicalDesc=""
		Set objLogicalDic = ##class(DHCWMR.SS.Dictionary).GetObjById(LogicalID)
		if $isobject(objLogicalDic)
		{	
			Set LogicalDesc = objLogicalDic.SDDesc
		}
		Set LogicalCode = ##class(DHCWMR.MQService.ConditionSrv).ChangeLogicalCode(LogicalDesc)
		Set ^CacheTemp("MRQ",Repid,"InputItem",indInput)=$lb(QryType,QryID,OperCode,CompVal,LogicalCode)
	}
	Quit "OK"	
GetInputItemErr
	Kill ^CacheTemp("MRQ",Repid,"InputItem")
	Quit $ZError
}

/// Creator：     liyi
/// CreatDate：   2016-04-09
/// Description:  标准化数据为输出格式,如果输出有特殊字符一并处理
/// Input：       aValue:数据值
/// 			  aToType:转换后数据类型
/// Return：      转换后的数据值
/// w ##class(DHCWMR.MQService.OutPutSrv).ChangeValToDisplay("糖尿病"_$C(34),"TEXT")
ClassMethod ChangeValToDisplay(aValue As %String, aValType As %String) As %String
{
	New (aValType,aValue)
	Set return=""
	Quit:(aValType="")||(aValue="") return
	//处理特殊字符
	Set aValue = $tr(aValue,"'","‘")	//防止单引号影响输出json
	Set aValue = $tr(aValue,$c(34),"”")	//防止双引号影响输出json
	For cIndex = 1:1:33{		//替换特殊字符
		Set exp = "Set aValue=$tr(aValue,$c("_cIndex_"),"_""""_""""_")"
		x exp
	}
	//处理最后一个字符不能为"\"
	If $e(aValue,$l(aValue),$l(aValue))="\"{
		Set aValue=$e(aValue,1,$l(aValue)-1)
	}

	//转换类型
	If (aValType="DATETIME") {
		If aValue'="" {
			Set tmpDate=$p(aValue,",",1)
			Set tmpTime=$p(aValue,",",2)
			Set:tmpDate'="" tmpDate=$zd(aValue,3)
			Set:tmpTime'="" tmpTime=$zt(aValue,1)
			Set aValue=tmpDate_" "_tmpTime
		}
	} 
	If (aValType="NUMBER"){
		Set:+aValue'=0 aValue=+aValue
	}
	If (aValType="DATE"){
		Set:+aValue'=0 aValue=$zd(aValue,3)
	}
	If (aValType="TIME"){
		Set:+aValue'=0 aValue=$zt(aValue,1)
	}
	If (aValType="TEXT"){}
	Set return=aValue 
	
	Quit return
}

/// Creator：     LiYang
/// CreatDate：   2015-03-13
/// Description:  转换数据类型
/// Input：       aItemValue:数据值
/// 			  aFromType:转换前数据类型
/// 			  aToType:转换后数据类型
/// Return：      转换后的数据值
/// w ##class(DHCWMR.MQService.OutPutSrv).ChangeValType(63280,"DATE","DATE")
ClassMethod ChangeValType(aItemValue As %String, aToType As %String) As %String
{
	New (aItemValue,aToType)
	Set return=""
	Quit:(aItemValue="")||(aToType="") return
	If aToType="DATETIME" {
		Set return=##Class(DHCWMR.SSService.CommonSrv).GetCacheDateTime(aItemValue)
	} ElseIf aToType="DATE" {
		Set return=##class(DHCWMR.SSService.CommonSrv).GetCacheDate(aItemValue)
		Set return=$p(return,",",1)
	} ElseIf aToType="TIME" {
		Set return=##class(DHCWMR.SSService.CommonSrv).GetCacheTime(aItemValue)
		Set return=$p(return,",",2)
	} ElseIf aToType="NUMBER" {
		Set return=aItemValue
		Set:return'="" return=+aItemValue
	} Else {	//TEXT
		Set return=aItemValue
	}
	Quit return
}

/// Creator：     LiYang
/// CreatDate：   2015-03-13
/// Description:  对字符串的比较需要单独写逻辑
/// Input：       aItemValue：源值
/// 			  aOperCode：比较符		//等于 大于 小于 大于等于 小于等于 包含
/// 			  aOperVal：比较值
/// 			  aDataType：数据类型
/// Return：      真假
/// w ##class(DHCWMR.MQService.OutPutSrv).Compare(63280,"==","2014-04-03","DATE")
ClassMethod Compare(aItemValue As %String, aOperCode As %String, aOperVal As %String, aDataType) As %String
{
	
	New (aItemValue,aOperCode,aOperVal,aDataType)
	Set return=0
	Set:aOperCode=">" return=(aItemValue>aOperVal)
	Set:aOperCode=">=" return=(aItemValue>=aOperVal)
	Set:aOperCode="<" return=(aItemValue<aOperVal)
	Set:aOperCode="<=" return=(aItemValue<=aOperVal)
	Set:aOperCode="==" return=(aItemValue=aOperVal)
	Set:aOperCode="!=" return=(aItemValue'=aOperVal)
	//对字符串比较需要单独写逻辑进行
	if (aDataType="TEXT") {
		Set t=..CompareString(aItemValue,aOperVal)
		Set:aOperCode=">" return=(t>0)
		Set:aOperCode=">=" return=(t>=0)
		Set:aOperCode="<" return=(t<0)
		Set:aOperCode="<=" return=(t<=0)
		Set:aOperCode="==" return=(t=0)
		Set:aOperCode="!=" return=(t'=0)
	}
	If (aOperCode="LIKE"){
		If ($e(aOperVal,1,2)="%")&&($e(aOperVal,$l(aOperVal),$l(aOperVal))'="%") {
			Set return=($e(aItemValue,$l(aItemValue)-$l(aOperVal)+1,$l(aItemValue))=aOperVal)
		} ElseIf ($e(aOperVal,1,2)'="%")&&($e(aOperVal,$l(aOperVal),$l(aOperVal))="%") {
			Set return=($e(aItemValue,1,$l(aOperVal))=aOperVal)
		} Else {
			Set return=(aItemValue[aOperVal)
		}
	}
	Quit return
}

/// 用于比较两个字符串
/// 参数：
///    str1:待比较的第一个字符串
///    str2:待比较的第二个字符串
/// 返回值：
///    1:第一个字符大于第二个字符，0：第一个字符等于第二个字符，-1：第一个字符小于第二个字符
/// w ##class(DHCWMR.MQService.OutPutSrv).CompareString("ABC","ABD")
ClassMethod CompareString(str1, str2) As %Integer
{
	n (str1,str2)
	Set l1=$l(str1)
	Set l2=$l(str2)
	Set ln=$s(l1>l2:l1,1:l2)
	Set t1="",t2=""
	Set ret=0
	For i=1:1:ln {
		Set t1=$a(str1,i)
		Set t2=$a(str2,i)
		if (t1>t2)
		{
			Set ret=1
			Quit
		}
		if (t1<t2)
		{
			Set ret=-1
			Quit
		}
	}
	Quit ret
}

/// Description:  执行逻辑
/// Input：       表达式
/// Return:		  真假
/// w ##class(DHCWMR.MQService.OutPutSrv).ExamExp("1||1")
ClassMethod ExamExp(aExp As %String) As %String
{
	New (aExp)
	Set return=0
	Quit:aExp="" return
	Set $ZT="ExamLogicalExpErr"
	Set aExp="Set flg=("_aExp_")"
	X aExp
	Quit flg
ExamLogicalExpErr
	Quit "-1^"_$ZError
}

/// 插入测试数据
/// d ##class(DHCWMR.MQService.OutPutSrv).InsertTestData()
ClassMethod InsertTestData()
{
	Set DateFrom = "2015-09-13"
	Set DateTo = "2015-09-13"
	Set:DateFrom["-" DateFrom=$zdh(DateFrom,3)
	Set:DateFrom["/" DateFrom=$zdh(DateFrom,4)
	Set DateFrom=+DateFrom
	Set:DateTo["-" DateTo=$zdh(DateTo,3)
	Set:DateTo["/" DateTo=$zdh(DateTo,4)
	Set DateTo=+DateTo
	
	Set EpisodeID = 50036    //就诊ID开始
	Set PatientID = 50036	//病人ID开始
	
	Set DigList = $lb("艾滋病","霍乱","心肌梗塞","不稳定性心绞痛","剖宫产","高血压","脑卒中","恶性肿瘤","肺气肿","青光眼","食道癌")
	
	Set Count = 0
	For xDate=DateFrom:1:DateTo{
		For xNum = 1:1:DataNum{
			Quit:Count>10
			Set EpisodeID=EpisodeID+1
			Set PatientID=PatientID+1
			Set DischDate = xDate
			Set DischTime = 65314
			Set InputStr=EpisodeID
			Set InputStr=InputStr_"^"_PatientID
			Set InputStr=InputStr_"^"_"D"
			Set InputStr=InputStr_"^"_DischDate
			Set InputStr=InputStr_"^"_DischTime
			Set InputStr=InputStr_"^"_""
			Set InputStr=InputStr_"^"_""
			Set InputStr=InputStr_"^"_1
			Set InputStr=InputStr_"^"_""
			Set flg=##class(DHCWMR.MQ.DataMaster).Update(InputStr,"^")
			Set Count = Count+1
			Set MasterID=flg
			
			//插入实例数据
			Set xElCode=""
			For {
				Set xElCode=$o(^DHCWMR.MQ.DataItemsI("IndexDataSrcEleCode"," EPR",xElCode))
				Quit:xElCode=""
		
				Set xItemID=$o(^DHCWMR.MQ.DataItemsI("IndexDataSrcEleCode"," EPR",xElCode,0))
				Continue:xItemID=""
				Set objItem=##class(DHCWMR.MQ.DataItems).GetObjById(xItemID)
				Continue:'$IsObject(objItem)
				Continue:objItem.IsActive'=1
				Set DataType=objItem.DataType
				Set ElementCode=objItem.ElementCode
				Continue:ElementCode=""
				Continue:ElementCode["-"
				if (DataType="NUMBER"){
					Set ItemValue = $r(100)
				}elseif (DataType="TEXT"){
					Set ItemValue = "脑卒中"
				}elseif (DataType="DATE"){
					Set ItemValue = "2016-04-04"
				}elseif (DataType="TIME"){
					Set ItemValue = "21:01:01"
				}elseif (DataType="DATETIME"){
					Set ItemValue = "2016-04-04 21:01:01"
				}
				Set ItemValue=##class(DHCWMR.MQService.RecordSrv).ChangeValType(ItemValue,DataType)
				Set InputStr=MasterID
				Set InputStr=InputStr_"^"_xItemID
				Set InputStr=InputStr_"^"_ItemValue
				Set InputStr=InputStr_"^"_DataType
				Set InputStr=InputStr_"^"_1
				Set flg=##class(DHCWMR.MQ.DataRecord).Update(InputStr,"^")
			}
			w EpisodeID,!
		}
	}
	w "EpisodeID:"_EpisodeID_"^"_"DateFrom:"_$zd(xDate,3)_"^"_"DateTo:"_$zd(DateTo,3)
}

}
