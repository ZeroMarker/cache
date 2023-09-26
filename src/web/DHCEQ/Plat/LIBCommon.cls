Class web.DHCEQ.Plat.LIBCommon Extends %Library.RegisteredObject [ Not ProcedureBlock ]
{

/// Add By DJ 2018-07-04
/// 描述:获取Json格式单表记录.格式为:{字段名1:字段值1,字段名2:字段值2}
/// 入参:vTableRecordObj 表记录对象
/// 返回值:单表记录Json格式串
ClassMethod GetJsonTableRecord(vTableRecordObj As %String = "")
{
	n (vTableRecordObj,vPrefix)
	i vTableRecordObj="" q ""
	s Result=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	s ColumnsInfo = ##class(%Dictionary.ClassDefinition).%OpenId(vTableRecordObj.%ClassName(1))
	s CurColumn=0
	f CurColumn=1:1:ColumnsInfo.Properties.Count()  d
	.s ColumnName=ColumnsInfo.Properties.GetAt(CurColumn).Name
	.s ColumnType=ColumnsInfo.Properties.GetAt(CurColumn).Type
	.s DisPlayList=ColumnsInfo.Properties.GetAt(CurColumn).Parameters.GetAt("DISPLAYLIST")
	.s ColumnValue=$ZOBJPROPERTY(vTableRecordObj,ColumnName)
	.i (ColumnType="%Library.Date")||(ColumnType="%Date") s ColumnValue=##Class(web.DHCEQCommon).TransValueToPage(ColumnValue,"date")
	.i (ColumnType="%Library.Time")||(ColumnType="%Time") s ColumnValue=##Class(web.DHCEQCommon).TransValueToPage(ColumnValue,"time")
	.i (ColumnType="%Library.Float")||(ColumnType="%Float") s ColumnValue=##Class(web.DHCEQCommon).FormatNumber(ColumnValue,"",2)
	.i (DisPlayList=",Yes,No") s ColumnValue=##Class(web.DHCEQCommon).TransValueToPage(ColumnValue,"bool")
	.i (ColumnType["User.")&&(ColumnValue'="") s ColumnValue=ColumnValue.%Id()
	.s ColumnValue=##class(web.DHCEQCommon).Replace(ColumnValue,$C(13,10),"\n")
	.d Result.%Set(ColumnName,ColumnValue)
	q Result
}

/// Add By DJ 2018-07-06
/// 描述:生成类方法JSON统一返回值格式
/// 入参:vSQLCODE 错误代码
/// 		vData 错误信息
/// 		RtnType:返回值类型 空或其他：json字符串 1：json对象
/// 返回值:JSON格式串{"SQLCODE":错误代码,"Data":错误信息}
ClassMethod ReturnJson(vSQLCODE As %String = "", vData As %String = "", RtnType As %String = "")
{
	n ReturnInfo,ReturnData,RtnStr
	s ReturnInfo=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	s ReturnData=vData
	i vSQLCODE'=0  d
	.s RtnStr=##Class(web.DHCEQ.Plat.LIBCommon).GetPromptByCode(vSQLCODE)
	.i RtnStr="" s RtnStr="错误代码:"_vSQLCODE
	.s ReturnData=RtnStr
	.i vData'="" s ReturnData=vData	//_"[详细:"_vData_"]"
	d ReturnInfo.%Set("SQLCODE",vSQLCODE)
	d ReturnInfo.%Set("Data",ReturnData)
	i RtnType="1" q ReturnInfo		//czf 2014955 2021-07-28 返回json对象
	q ReturnInfo.%ToJSON()
}

/// Add By DJ 2018-07-30
/// 描述:获取错误代码描述
/// 入参:vCode 错误代码
/// 返回值:错误代码描述
ClassMethod GetPromptByCode(vCode As %String = "")
{
	n PIRowID,Return
	s Return=""
	i vCode="" q ""
	s PIRowID=$o(^DHCEQCCode("DHCEQCPromptInfo",0,"Code",vCode,0))
	i PIRowID'="" s Return=$p($g(^DHCEQCCode("DHCEQCPromptInfo",PIRowID)),"^",5)
	q Return
}

/// modified by ZY0215  2020-04-01
/// 增加Source=5 tooltip处理
/// Add By DJ 2018-07-30
/// 描述:获取JS业务及JS通用消息
/// 入参:vBuss 业务名称,为空时输出所有JS业务及JS通用消息,不为空输出对应js业务及通用消息	modified by csj 20191128
/// 返回值:JS业务及JS通用消息JSON串 格式{代码1:描述1,代码2:描述2,....,代码n:描述n}
/// w ##Class(web.DHCEQ.Plat.LIBCommon).GetPromptInfo("mmaintrequest")
ClassMethod GetPromptInfo(vBuss As %String = "")
{
	s PromptInfo=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	s PISource=0
	f  s PISource=$o(^DHCEQCCode("DHCEQCPromptInfo",0,"Source",1,PISource)) q:PISource=""  d
	.q:((PISource'=3)&&(PISource'=4)&&(PISource'=5))		//3JS业务 4JS通用 5tooltip
	.s PIBuss=""
	.f  s PIBuss=$o(^DHCEQCCode("DHCEQCPromptInfo",0,"Source",1,PISource,PIBuss))  q:PIBuss=""  d
	..q:((PISource=3)&&(vBuss'="")&&(PIBuss'=(" "_vBuss)))
	..s PIRowID=0
	..f  s PIRowID=$o(^DHCEQCCode("DHCEQCPromptInfo",0,"Source",1,PISource,PIBuss,PIRowID))  q:PIRowID=""  d
	...s PICode=$p($g(^DHCEQCCode("DHCEQCPromptInfo",PIRowID)),"^",4)
	...s PIDesc=$p($g(^DHCEQCCode("DHCEQCPromptInfo",PIRowID)),"^",5)
	...d PromptInfo.%Set(PICode,PIDesc)
	
	s PIRowID=$o(^DHCEQCCode("DHCEQCPromptInfo",0,"Code",0,0))
	i PIRowID'=""  d
	.s PIDesc=$p($g(^DHCEQCCode("DHCEQCPromptInfo",PIRowID)),"^",5)
	.d PromptInfo.%Set(0,PIDesc)
	
	q PromptInfo.%ToJSON()
}

/// Add By DJ 2018-07-30
/// Modified by CSJ 2019-10-12 添加EQCompFlag组件列定义标志
/// 描述:获取组件元素Caption描述信息
/// 入参:compid 组件ID
/// 	 valname 组件元素名
/// 	 EQCompFlag 组件列定义标志
/// 返回值:元素Caption的JSON格式串  格式:{"SQLCODE":成功失败代码,"Data":名称}
/// w ##Class(web.DHCEQ.Plat.LIBCommon).GetColumnCaption("116","BPLPriceFee","1")
ClassMethod GetColumnCaption(compid, valname, EQCompFlag As %String = "")
{
	n (compid, valname,EQCompFlag)
	i compid="" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,"")
	i valname="" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,"")
	s valname=##Class(web.DHCEQCommon).Trim(valname)
	s caption=""
	i EQCompFlag=""
	{
		s valname=$ZConvert(valname,"U")
		s valname=" "_valname
		s sub=$o(^websys.ComponentTableItemsI("Name",compid,valname,0))
		i sub'=""  d
		.s id=compid_"||"_sub
		.s tableItem=##class(websys.ComponentTableItems).%OpenId(id)
		.s caption=tableItem.Caption
	}
	else
	{
		i compid'="" d
		.s compItemId=""
		.f  s compItemId = $o(^DHCEQCCode("DHCEQCComponentItem",0,"Component",compid,compItemId)) q:compItemId=""  d
		..s ciName = $P($g(^DHCEQCCode("DHCEQCComponentItem",compItemId)),"^",2)
		..q:(valname'="")&&(valname'=ciName)
		..s caption = $P($g(^DHCEQCCode("DHCEQCComponentItem",compItemId)),"^",3)
	}
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,caption)
}

/// Add By DJ 2018-07-30
/// 描述:取消字符串左右空格
/// 入参:expression 原字符串
/// 返回值:取消左右空格后的字符串
ClassMethod Trim(expression As %String) As %String [ Language = basic ]
{
	return Trim(expression)
}

/// Add By DJ 2018-07-30
/// 描述:字符串替换
/// 入参:expression 原字符串
/// 		find 原字符串需替换字符串
/// 		replacewith 替换字符串
/// 返回值:被替换后字符串
ClassMethod Replace(expression As %String, find As %String, replacewith As %String) As %String [ Language = basic ]
{
	return Replace(expression,find,replacewith)
}

/// Add By DJ 2018-09-14
/// 描述:获取业务审批进度
/// w ##Class(web.DHCEQ.Plat.LIBCommon).GetApproveSchedule("25",188)
ClassMethod GetApproveSchedule(vApproveTypeCode As %String = "", vSourceID As %String = "")
{
	;n ApproveSchedule,ApproveTypeDR,ApproveSetDR,ApproveInfoDR,AIStatus,NextStep,FirstStep
	;n AFLastFlag,ApproveFlowIDs,AFStep,AFRowID,NextToFlowDR,CurFlowID,AFRoleDR,AFActionDR,AFAction,AFRole,ScheduleFlag
	
	s ApproveSchedule="申请=0^提交=0^审核=0"
	i ((vApproveTypeCode="")||(vSourceID="")) q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,ApproveSchedule)
	s ApproveSchedule="申请=1^提交=0^审核=0"
	s ApproveTypeDR=##Class(web.DHCEQApproveList).GetApproveType(vApproveTypeCode)
	s ApproveSetDR=##Class(web.DHCEQApproveList).GetApproveSet(vApproveTypeCode,vSourceID)
	i ApproveSetDR="" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,ApproveSchedule)
	s ApproveInfoDR=$o(^DHCEQApproveInfo(0,"SourceID",ApproveTypeDR,vSourceID,0))
	s AIStatus=""
	s NextStep=""
	i ApproveInfoDR'=""
	{
		s NextStep=$p($g(^DHCEQApproveInfo(ApproveInfoDR)),"^",5)
		s AIStatus=$p($g(^DHCEQApproveInfo(ApproveInfoDR)),"^",8)
	}
	s FirstStep=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveStep",ApproveSetDR,0))
	i FirstStep=""
	{
		//未配置审批流
		i ApproveInfoDR="" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,ApproveSchedule)
		i AIStatus=0 q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,ApproveSchedule)
		i AIStatus=1 q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,"申请=1^提交=1^审核=0")
		i AIStatus=2 q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,"申请=1^提交=1^审核=1")
	}
	s ApproveSchedule="申请=1"
	i +AIStatus=0 s ApproveSchedule=ApproveSchedule_"^提交=0"
	i +AIStatus>=1 s ApproveSchedule=ApproveSchedule_"^提交=1"
	s AFLastFlag=""
	s ApproveFlowIDs=""
	s AFStep=0
	f  s AFStep=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveStep",ApproveSetDR,AFStep))  q:(AFStep="")||(AFLastFlag="Y")  d
	.s AFRowID=0
	.f  s AFRowID=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveStep",ApproveSetDR,AFStep,AFRowID))  q:(AFRowID="")||(AFLastFlag="Y")  d
	..q:(ApproveFlowIDs'="")&&((ApproveFlowIDs_",")[(","_AFRowID_","))
	..s AFLastFlag=$p($g(^DHCEQCCode("DHCEQCApproveFlow",AFRowID)),"^",4)
	..s NextToFlowDR=$p($g(^DHCEQCCode("DHCEQCApproveFlow",AFRowID)),"^",12)
	..s ApproveFlowIDs=ApproveFlowIDs_","_AFRowID
	..i (AFLastFlag'="Y")&&(NextToFlowDR'="")  d
	...s ApproveFlowIDs=ApproveFlowIDs_","_NextToFlowDR
	
	s CurFlowID=0
	f CurFlowID=2:1:$L(ApproveFlowIDs,",")
	{
		s AFRowID=$p(ApproveFlowIDs,",",CurFlowID)
		s AFRoleDR=$p($g(^DHCEQCCode("DHCEQCApproveFlow",AFRowID)),"^",2)
		s AFStep=$p($g(^DHCEQCCode("DHCEQCApproveFlow",AFRowID)),"^",3)
		s AFActionDR=$p($g(^DHCEQCCode("DHCEQCApproveFlow",AFRowID)),"^",9)
		s AFAction=""
		s AFRole=""
		i AFActionDR'="" s AFAction=$p($g(^DHCEQCCode("DHCEQCAction",AFActionDR)),"^",2)
		i AFRoleDR'="" s AFRole=$p($g(^DHCEQCCode("DHCEQCApproveRole",AFRoleDR)),"^",2)
		s ScheduleFlag=0
		i NextStep=AFStep s ApproveSchedule=##Class(web.DHCEQ.Plat.LIBCommon).Replace(ApproveSchedule,"=0","=1")
		i AIStatus=2 s ScheduleFlag=1
		i AFAction=""  d
		.s ApproveSchedule=ApproveSchedule_"^"_AFRole_"="_ScheduleFlag
		e  d
		.s ApproveSchedule=ApproveSchedule_"^"_AFAction_"="_ScheduleFlag
	}
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,ApproveSchedule)
}

/// Creator：      ZX
/// CreatDate：    2018-09-07
/// Description:   字符串转json
/// Input：        StringData:前台获取字符串 field:value,filed:vale
/// Return：       json数据返回
/// zx 2018-12-12  修复逗号等符号造成分割出错 修复 '"','\' 等转义字符处理错误
/// modify by wl 2020-06-19 WL0068 转义等字符处理以及','{','}','\u0000','\n'处理
/// w ##class(web.DHCEQ.Plat.LIBCommon).StringToJson("{""ECode"":""\06"",""EDesc"":""业务数据模板"",""EHold1"":"":"",""EHold2"":"","",""EHold3"":"""",""EHold4"":"""",""EHold5"":"","",""EInvalidFlag"":""0"",""ERemark"":""\u0000""}")
ClassMethod StringToJson(StringData)
{
	n StringLen,ITERATOR,ItemInfo,ItemKey,ItemValue
	s (StringLen,ITERATOR,ItemInfo,ItemKey,ItemValue)=""
	s ReturnInfo=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	i (StringData="{}")||(StringData="") q ReturnInfo	//czf 20210126 1750654
	i (StringData[""":"","",""")  s StringData=##Class(web.DHCEQ.Plat.LIBCommon).Replace(StringData,""":"","",""",""":""temppoint"",""") //保留,
	i (StringData[""":"",""}")    s StringData=##Class(web.DHCEQ.Plat.LIBCommon).Replace(StringData,""":"",""}",""":""temppoint""}") //保留,
	s StringData=##Class(web.DHCEQ.Plat.LIBCommon).Replace(StringData,""",""",$CHAR(3)) //双层引号 '"",""' 转化为$CHAR(3)方块
	s StringData=##Class(web.DHCEQ.Plat.LIBCommon).Replace(StringData,""":""",$CHAR(4)) //双层引号 '"":""' 转化为$CHAR(3)方块
	s StringData=##Class(web.DHCEQ.Plat.LIBCommon).Replace(StringData,"\""",$CHAR(1)) //引号转义 '\""' 转化为$CHAR(1)
	s StringData=##Class(web.DHCEQ.Plat.LIBCommon).Replace(StringData,",""",$CHAR(3)) //双层引号 ',""' 转化为$CHAR(3)
	s StringData=##Class(web.DHCEQ.Plat.LIBCommon).Replace(StringData,""":",$CHAR(4)) //双层引号 '"":' 转化为$CHAR(4)
	s StringData=##Class(web.DHCEQ.Plat.LIBCommon).Replace(StringData,"""","")
	s StringData=##Class(web.DHCEQ.Plat.LIBCommon).Replace(StringData,"\u0000",$CHAR(0))
	s StringData=##Class(web.DHCEQ.Plat.LIBCommon).Replace(StringData,"\n",$CHAR(10))
	i $e(StringData)="{"   s StringData=$e(StringData,2,$l(StringData))
	i $e(StringData,*)="}" s StringData=$e(StringData,1,$l(StringData)-1)
	s StringLen=$l(StringData,$CHAR(3))
	f ITERATOR=1:1:StringLen  d
	.s ItemInfo=$p(StringData,$CHAR(3),ITERATOR)
	.s ItemKey=$p(ItemInfo,$CHAR(4),1)
	.s ItemValue=$p(ItemInfo,$CHAR(4),2)
	.i ItemValue="temppoint" s ItemValue=","
	.s ItemValue=##Class(web.DHCEQ.Plat.LIBCommon).Replace(ItemValue,$CHAR(1),"""") //引号转义处理
	.s ItemValue=##Class(web.DHCEQ.Plat.LIBCommon).Replace(ItemValue,"\\","\") //斜杠转义处理
	.d ReturnInfo.%Set(ItemKey,ItemValue)
	q ReturnInfo
}

/// Creator：      ZX
/// CreatDate：    2018-09-13
/// Description:   保存数据的json转化为plist
/// Input：        ObjEquip:实体类对象 Jsondata:保存所需json数据 List:保存数据所需plist
/// Return：       "0" 表示转化成功
ClassMethod JsonToPlist(TableName, JsonData, List)
{
	n ColumnsInfo,ColumnsLength,Iterator,CurColumn,ColumnType,DisPlayList,val
	s ColumnsInfo = ##class(%Dictionary.ClassDefinition).%OpenId(TableName)
	s ColumnsLength=ColumnsInfo.Properties.Count()
	s key=""
	For
	{
		s val=JsonData.GetNext(.key)
		q:key=""
		f CurColumn=1:1:ColumnsLength  d
		.i ColumnsInfo.Properties.GetAt(CurColumn).Name=key d
		..s SqlColumnNumber=ColumnsInfo.Properties.GetAt(CurColumn).SqlColumnNumber
		..s ColumnType=ColumnsInfo.Properties.GetAt(CurColumn).Type
		..s DisPlayList=ColumnsInfo.Properties.GetAt(CurColumn).Parameters.GetAt("DISPLAYLIST")
		..if (ColumnType="%Library.Date")||(ColumnType="%Date") d
		...s val=##Class(web.DHCEQCommon).TransValueFromPage(val,"date")
		..else  if (ColumnType="%Library.Time")||(ColumnType="%Time") d
		...s val=##Class(web.DHCEQCommon).TransValueFromPage(val,"time")
		..if (DisPlayList=",Yes,No") d
		...s val=##Class(web.DHCEQCommon).TransValueFromPage(val,"bool")
		..s List(SqlColumnNumber)=val
	}
	/*
	s Iterator = JsonData.%GetIterator()
    //json遍历
    while Iterator.%GetNext(.key,.val) 
    {
	    f CurColumn=1:1:ColumnsLength  d
		.i ColumnsInfo.Properties.GetAt(CurColumn).Name=key d
		..s SqlColumnNumber=ColumnsInfo.Properties.GetAt(CurColumn).SqlColumnNumber
		..s ColumnType=ColumnsInfo.Properties.GetAt(CurColumn).Type
		..s DisPlayList=ColumnsInfo.Properties.GetAt(CurColumn).Parameters.GetAt("DISPLAYLIST")
		..if (ColumnType="%Library.Date")||(ColumnType="%Date") d
		...s val=##Class(web.DHCEQCommon).TransValueFromPage(val,"date")
		..else  if (ColumnType="%Library.Time")||(ColumnType="%Time") d
		...s val=##Class(web.DHCEQCommon).TransValueFromPage(val,"time")
		..if (DisPlayList=",Yes,No") d
		...s val=##Class(web.DHCEQCommon).TransValueFromPage(val,"bool")
		..s List(SqlColumnNumber)=val
	}
	*/
	q 0
}

/// w ##Class(web.DHCEQ.Plat.LIBCommon).GetMapIDBySource("4674","2")
ClassMethod GetMapIDBySource(UserID As %Library.String = "", LocID As %Library.String = "", HospitalID As %Library.String = "")
{
	s ReturnInfo=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	s (MapUserID,MapUserCode,MapUserName,MapLocID,MapLocCode,MapLocName)=""
	if (UserID'="")
	{
		s MapUserID=$o(^DHCEQCCode("DHCEQCUser",0,"ExID","Y",UserID,""))
		//start by csj 2020-03-16 同步人员信息
		i MapUserID'=""
		{
			s MapUserCode=$p($g(^DHCEQCCode("DHCEQCUser",MapUserID)),"^",1)
			s MapUserName=$p($g(^DHCEQCCode("DHCEQCUser",MapUserID)),"^",4)
			s SSInfo = $g(^SSU("SSUSR",UserID))
			s SSLoginName=$p(SSInfo,"^",1)
			s SSName=$p(SSInfo,"^",2)
			i (MapUserCode'=SSLoginName)||(MapUserName'=SSName)  {
				d ReturnInfo.%Set("SyncFlag","Y") //是否同步标志
			}
		}
		else	//新增用户直接同步人员信息
		{
			//s Rtn = ##class(%DynamicAbstractObject).%FromJSON(##class("web.DHCEQ.Plat.CTUser").SyncUserSingle(UserID))	//modified by czf 2021-01-20 json对象改造
			s Rtn = ##class(web.DHCEQ.Plat.JsonObject).FromJSON(##class("web.DHCEQ.Plat.CTUser").SyncUserSingle(UserID))
			i Rtn.SQLCODE=0 d
			.s MapUserCode=$p($g(^DHCEQCCode("DHCEQCUser",Rtn.Data)),"^",1)
			.s MapUserName=$p($g(^DHCEQCCode("DHCEQCUser",Rtn.Data)),"^",4)

		}
		//end by csj 2020-03-16
		
	}
	if (LocID'="")
	{
		s MapLocID=$o(^DHCEQCCode("DHCEQCDepartment","0","ExID","Y","1",LocID,""))
		i MapLocID'="" d
		.s MapLocCode=$p($g(^DHCEQCCode("DHCEQCDepartment",MapLocID)),"^",1)
		.s MapLocName=$p($g(^DHCEQCCode("DHCEQCDepartment",MapLocID)),"^",2)
	}
	//add by lmm 2018-10-24 begin
	if (HospitalID'="")
	{
		s SSHospitalCode=$P($g(^CT("HOSP",HospitalID)),"^",1)
		s SSHospitalName=$P($g(^CT("HOSP",HospitalID)),"^",2)
	}
	//add by lmm 2018-10-24 end
	d ReturnInfo.%Set("MapUserID",MapUserID)
	d ReturnInfo.%Set("MapUserCode",MapUserCode)
	d ReturnInfo.%Set("MapUserName",MapUserName)
	d ReturnInfo.%Set("MapLocID",MapLocID)
	d ReturnInfo.%Set("MapLocCode",MapLocCode)
	d ReturnInfo.%Set("MapLocName",MapLocName)
	//add by lmm 2018-10-24 begin
	d ReturnInfo.%Set("SSHospitalCode",SSHospitalCode)
	d ReturnInfo.%Set("SSHospitalName",SSHospitalName)
	//add by lmm 2018-10-24 end
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,ReturnInfo)
}

/// Creator：      JYP
/// CreatDate：    2019-10-17
/// Description:   根据DepartmentID取对应的HospitalID
/// Return：       HospitalDRByDepartmentID
/// w ##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(100)
ClassMethod GetHospitalByDeptID(DepartmentID)
{
	s HospitalDRByDepartmentID=""
	if DepartmentID'=""
	{	
		s ExType=$p($g(^DHCEQCCode("DHCEQCDepartment",DepartmentID)),"^",10)
		if ExType=1
		{
			s EXID=$p($g(^DHCEQCCode("DHCEQCDepartment",DepartmentID)),"^",11)
			s HospitalDRByDepartmentID=$p($g(^CTLOC(EXID)),"^",22)
		}		
		else
		{
			s OrganizeType=$p($g(^DHCEQCCode("DHCEQCDepartment",DepartmentID)),"^",7)
			i OrganizeType=1 s HospitalDRByDepartmentID=$p($g(^DHCEQCCode("DHCEQCDepartment",DepartmentID)),"^",8)	
		}
	}
	q HospitalDRByDepartmentID
}

/// Creator:czf
/// CreatDate:2020-08-16
/// Description:保存数据修改日志
/// Table:User.DHCEQDataChangeLog
/// Input:TableName:表名; ClassName:User类 ;BussID:表RowID; OperateType:操作类型(A,U,D-添加,删除,修改); 
/// 	  NewValue:变动值Json串; OldValue:变动前完整Json串; UserId:变动人DHCEQCUser的ID
/// 	  DCRRowID:变动申请表ID
/// OutPut:0:成功 其他:失败
/// Command:d ##class(web.DHCEQ.Plat.LIBCommon).SaveDataChangeLog("","","","U","{}","{}","1132")
ClassMethod SaveDataChangeLog(TableName As %String, ClassName As %String, BussID As %String, OperateType As %String, NewValue As %String, OldValue As %String = "", UserId As %String = "", DCRID As %Library.String = "") As %String
{
	n (TableName,ClassName,BussID,OperateType,NewValue,OldValue,UserId,DCRID,%session)	//czf 20210-01-30 1759177 
 	i UserId="" s UserId=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
 	s result=0
 	i (TableName="") q -9201
 	i (ClassName="")  q -9201
 	i (BussID="") q -9201
 	i (OperateType="") q -9201

    i ($d(%session)) s IPAddress=$Get(%session.Data("REMOTE_ADDR")) 
    e  s IPAddress=""
    
    s DCLObj=##class(User.DHCEQDataChangeLog).%New()
    s DCLObj.DCLTableName = TableName
    s DCLObj.DCLClassName = ClassName
    s DCLObj.DCLBussID = BussID
    s DCLObj.DCLUpdateUserDR=UserId
    s DCLObj.DCLOperateType = OperateType
    s DCLObj.DCLNewValue = NewValue
    s DCLObj.DCLOldValue = OldValue
    s DCLObj.DCLIpAddress = IPAddress
    s DCLObj.DCLDataChangeRegDR = DCRID
    
    s sc=DCLObj.%Save()
    If $$$ISERR(sc) q sc
    //s id=DCLObj.%Id()
    d DCLObj.%Close()
    
    q result
}

/// Description:获取服务器IP
/// Creator:  czf
/// CreateDate: 2020-08-16
ClassMethod ServerIP()
{
    n (%request)
    Set SERVER=""
    if $d(%request)&&(%request.CgiEnvs("LOCAL_ADDR")){
        Set SERVER = %request.CgiEnvs("LOCAL_ADDR") ;%request.CgiEnvs("SERVER_ADDR")
    }else{
        Set SERVER = $p($zu(54,13,$zu(54,0)),",")
    }
    Quit SERVER
}

/// MZY0076	2021-05-25
/// d ##Class(%ResultSet).RunQuery("web.DHCEQ.Lib.Common","GetAppendFileAndPic",32,1,"")
Query GetAppendFileAndPic(SourceType As %String = "", SourceID As %String = "") As %Query(ROWSPEC = "TRowID:%String,TSourceType:%String,TSourceID:%String:%String,TPicTypeDR:%String,TPicType:%String,TName:%String,TFtpStreamSrc:%String,TFileType:%String,TToSwfFlag:%String,TFlag:%String")
{
}

ClassMethod GetAppendFileAndPicExecute(ByRef qHandle As %Binary, SourceType As %String = "", SourceID As %String = "") As %Status
{
	new repid, index
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
	i (SourceType="")||(SourceID="") Quit $$$OK
	d BuildDataGetAppendFileAndPic
	
	Quit $$$OK
		
BuildDataGetAppendFileAndPic

	s ARowID=0
	f  s ARowID=$o(^DHCEQAppendFile(0,"SourceType",SourceType,SourceID,ARowID)) q:ARowID=""  d
	.d ResetVariablesGetAppendFileAndPic
	.q:$p($g(^DHCEQAppendFile(ARowID)),"^",19)="Y" //AF_InvalidFlag
	.s TPicTypeDR=$p($g(^DHCEQAppendFile(ARowID)),"^",3)
	.q:##Class(web.DHCEQ.Lib.Common).PicTypeIsIn(TPicTypeDR)=1   //Moidefied by zc0071 安全组可访问的文件类型
	.i TPicTypeDR'=""  d
	..s TPicType=$p($g(^DHCEQCCode("DHCEQCPicType",TPicTypeDR)),"^",2)_"(文件)"
	.s TName=$p($g(^DHCEQAppendFile(ARowID)),"^",4)
	.s TFilePath=$p($g(^DHCEQAppendFile(ARowID)),"^",6)
	.s TFileType=$p($g(^DHCEQAppendFile(ARowID)),"^",7)
	.s TToSwfFlag=$p($g(^DHCEQAppendFile(ARowID)),"^",20) //Y office在线预览功能，文件已转化为swf格式置Y
	.s TFtpStreamSrc=##Class(web.DHCEQ.Plat.CTAppendFile).GetFtpStreamSrcByAFRowID(ARowID)
	.s TRowID=ARowID
	.s TFlag="File"
	.d OutputRowGetAppendFileAndPic
	
	s PRowID=0
	f  s PRowID=$o(^DHCEQPicture(0,"Source",SourceType,SourceID,PRowID)) q:PRowID=""  d
	.d ResetVariablesGetAppendFileAndPic
	.q:$p($g(^DHCEQPicture(PRowID)),"^",7)=2
	.s TPicTypeDR=$p($g(^DHCEQPicture(PRowID)),"^",5)
	.q:##Class(web.DHCEQ.Lib.Common).PicTypeIsIn(TPicTypeDR)=1   //Moidefied by zc0071 安全组可访问的文件类型
	.i TPicTypeDR'=""  d
	..s TPicType=$p($g(^DHCEQCCode("DHCEQCPicType",TPicTypeDR)),"^",2)_"(图片)"
	.s TName=$p($g(^DHCEQPicture(PRowID)),"^",13)
	.s PLRowID=""
	.for  s PLRowID=$o(^DHCEQPictureList(0,"Picture",PRowID,PLRowID)) q:(PLRowID="")  d
	..q:$p($g(^DHCEQPictureList(PLRowID)),"^",12)="Y"
	.s TRowID=PRowID
	.s TFlag="Pic"
	.d OutputRowGetAppendFileAndPic
	
	quit
OutputRowGetAppendFileAndPic
	s Data=$lb(TRowID,SourceType,SourceID,TPicTypeDR,TPicType,TName,TFtpStreamSrc,TFileType,TToSwfFlag,TFlag)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetAppendFileAndPic
	s (TRowID,TPicTypeDR,TPicType,TName,TFtpStreamSrc,TFileType,TToSwfFlag,TFlag)=""
	quit
}

ClassMethod GetAppendFileAndPicClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAppendFileAndPicExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAppendFileAndPicFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAppendFileAndPicExecute ]
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

/// Add By ZY0304 20220616
/// 描述:半角转全角
/// 入参:str  字符串
/// 返回值:result
/// w ##class(web.DHCEQ.Plat.LIBCommon).fullChar2halfChar("((ABCc）")
ClassMethod fullChar2halfChar(str)
{
	s result =""
	s StringLen=$L(str)
	f i=1:1:StringLen
	{
		s curStr=$e(str,i)
		s code =$ASCII(curStr)	//获取当前字符的unicode编码
		if (code >= 65281) && (code <= 65373)	//在这个unicode编码范围中的是所有的英文字母已经各种字符
		{
			s result =result_$CHAR(code - 65248)	//把全角字符的unicode编码转换为对应半角字符的unicode码
		}elseif (code=12288)	//空格
		{
			s result =result_$CHAR(code - 12288 + 32)
		}else
		{
			s result =result_curStr
		}
	}
	q result
}

/// Add By ZY0304 20220616
/// 描述:全角转半角
/// 入参:str  字符串
/// 返回值:result
/// w ##class(web.DHCEQ.Plat.LIBCommon).halfChar2fullChar("(,,,,")
ClassMethod halfChar2fullChar(str)
{
	s result =""
	s StringLen=$L(str)
	f i=1:1:StringLen
	{
		s curStr=$e(str,i)
		s code =$ASCII(curStr)	//获取当前字符的unicode编码
		if (code >= 33 ) && ( code <= 126)	//在这个unicode编码范围中的是所有的英文字母已经各种字符
		{
			s result =result_$CHAR(code + 65248)	//把全角字符的unicode编码转换为对应半角字符的unicode码
		}elseif (code=32)	//空格
		{
			s result =result_$CHAR(code + 12288 + 32)
		}else
		{
			s result =result_curStr
		}
	}
	q result
}

/// Add By ZY0304 20220616
/// 描述:判断双符号(（[{'是否完整
/// 入参:str  字符串
/// 返回值:1/0   1 :合规  0  ：不合规
/// w ##class(web.DHCEQ.Plat.LIBCommon).bracketMatch("(,,,,")
ClassMethod bracketMatch(str)
{
	i str="" q ""
	s StringLen=$L(str)
    s stack = ""	 // 借助数组模拟栈
    s leftBracket = "(（[{'"	// 定义左括号
    s rightBracket = ")）]}'"	// 定义右括号
    f i=1:1:StringLen
    {
		s right=$e(str,i)
		if (leftBracket[right) 
		{
	        // 如果出现左括号，压栈
	        s stack=stack_right
      	} elseif (rightBracket[right) 
      	{
	        // 如果出现右括号，需要判断栈顶元素与之是否匹配，是否需要出栈
	        s left=$e(stack,$L(stack))  // 栈顶元素
	        // 左右括号是否匹配  // 出栈，注意这儿没有压栈操作
		    if ((left= "{") && (right = "}")) 
		    {
		      s stack=$e(stack,1,($L(stack)-1))
		    } elseif (left = "（") && (right = "）") 
		    {
		      s stack=$e(stack,1,($L(stack)-1))
		    } elseif (left = "[") && (right ="]") 
		    {
		      s stack=$e(stack,1,($L(stack)-1))
		    } elseif (left = "(") && ( right = ")") 
		    {
		      s stack=$e(stack,1,($L(stack)-1))
		    } elseif (left = "'") && (right = "'") 
		    {
		      s stack=$e(stack,1,($L(stack)-1))
		    }
      	}
    }
    // 长度为 0 代表括号匹配
    if $l(stack)=0 q 1
    q 0
}

/// Add By ZY0304 20220616
/// 描述:判断双符号(（[{'是否完整
/// 入参:str  字符串
/// 返回值:1/0   1 :合规  0  ：不合规
/// w ##class(web.DHCEQ.Plat.LIBCommon).checkCode()
ClassMethod checkCode()
{
	s TableName=0
	f  s TableName=$o(^DHCEQCCode(TableName)) q:TableName=""  d
	.q:(TableName'="DHCEQCMasterItem")&&(TableName'="DHCEQCModel")&&(TableName'="DHCEQCLocation")&&(TableName'="DHCEQCEquipType")&&(TableName'="DHCEQCStatCat")&&(TableName'="DHCEQCDepartment")
	.s ID=0
	.f  s ID=$o(^DHCEQCCode(TableName,ID)) q:ID=""  d
	..s DataList=$g(^DHCEQCCode(TableName,ID))
	..s str=$p(DataList,"^",1,2)
	..i ##class(web.DHCEQ.Plat.LIBCommon).bracketMatch(str)=0  d
	...w TableName_"有不合规字符:"_str,!
	q ""
}

/// Add By ZY20220928
/// 描述:清除临时数据
/// 入参:Node  字符串：web.DHCEQStoreMoveList.GetStoreMoveStat
///      Job   进程号 $J
///      User  当前 User
/// 返回值:无
/// d ##class(web.DHCEQ.Plat.LIBCommon).ClearTempGlobal()
ClassMethod ClearTempGlobal(Node, Job As %String = "", User As %String = "")
{
    new PreDate,Date
    i Job="" s Job=$J
    i User="" s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
    s CurDate=+$H
    k ^TempDHCEQ(Node,CurDate,Job,User)
    i $p($H,",",2)>18000 s CurDate=CurDate-1     ///凌晨5点前执行时保留前一天数据
    s Date=0
    f  s Date=$o(^TempDHCEQ(Node,Date)) q:Date=""  d
    .i Date<CurDate d
    .. k ^TempDHCEQ(Node,Date)
}

/// Add By ZY20220928
/// 描述:清除临时数据
/// 入参:Node  字符串：web.DHCEQStoreMoveList.GetStoreMoveStat
///      Date  日期
///      Job   进程号 $J
///      User  当前 User
///      Index 记录的ID
///      Value 当前数据值
/// 返回值:无
/// d ##class(web.DHCEQ.Plat.LIBCommon).SetTempGlobal()
ClassMethod SetTempGlobal(Node, Date, Job As %String = "", User As %String = "", Index, Value As %String = "")
{
    i Date="" s Date=+$H
    i Job="" s Job=$J
    i User="" s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
    s ^TempDHCEQ(Node,Date,Job,User,Index)=Value
}

/// Add By ZY20220928
/// 描述：根据Index值返回临时数据总条数、一条记录、rows条记录
/// 访问表:无
/// 入参:Node  字符串：web.DHCEQStoreMoveList.GetStoreMoveStat
///      Date  日期
///      Job   进程号 $J
///      User  当前 User
///      Index 记录的ID
///      rows  Index后面多少条记录
/// 输出：result Index=0  临时数据最大的ID值  
///              Index> 0 临时数据字符串 
///              Index> 0&&rows'="" row行临时数据字符串
/// 备注：
/// d ##class(web.DHCEQ.Plat.LIBCommon).GetTempGlobalData()
ClassMethod GetTempGlobalData(Node, Date, Job As %String = "", User As %String = "", Index As %String = "0", rows As %String = "")
{
    n result
    i Date="" s Date=+$H
    i Job="" s Job=$J
    i User="" s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
    i '$Data(^TempDHCEQ(Node,Date,Job,User)) q ""
    s result=""
    i Index=0
    {
        s result=$Order(^TempDHCEQ(Node,Date,Job,User,""),-1)
    }
    else
    {
        s result = $g(^TempDHCEQ(Node,Date,Job,User,Index))
        if rows'=""
        {
            for i=1:1:rows-1
            {
                s result=result_$c(2)_^TempDHCEQ(Node,Date,Job,User,Index+i)
            }
        }
    }
    Quit result
}

/// Add By ZY20220928
/// 描述：返回临时数据合计信息
/// 访问表:无
/// 入参:Node  字符串：web.DHCEQStoreMoveList.GetStoreMoveStat
///      Date  日期
///      Job   进程号 $J
///      User  当前 User
/// 输出：TotalInfo  合计信息字符串
/// 备注：
/// w ##class(web.DHCEQ.Plat.LIBCommon).GetTempGlobalTotalInfo("EquipList",66429,9440,1,"")
/// w ##class(web.DHCEQ.Plat.LIBCommon).GetTempGlobalTotalInfo("ReturnDetail",66417,8212,36)
/// w ##class(web.DHCEQ.Plat.LIBCommon).GetTempGlobalTotalInfo("InventoryList","",8324,"",1)
ClassMethod GetTempGlobalTotalInfo(Node, Date, Job As %String = "", User As %String = "", vType As %String = "")
{
    n Count,TotalFee,TotalNetFee,TotalDepreFee,TotalInfo,Index
    i Date="" s Date=+$H
    i Job="" s Job=$J
    i User="" s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
    i '$Data(^TempDHCEQ(Node,Date,Job,User)) q ""
    
    s TotalInfo=""
    s (Count,TotalFee,TotalNetFee,TotalDepreFee,ConfigCount)=0
    s Index=0
    f  s Index=$o(^TempDHCEQ(Node,Date,Job,User,Index)) q:Index=""  d
    .s (DataList)=""
    .s (OriginalFee,NetFee,DepreTotalFee,Quantity)=0
    .s DataList=$g(^TempDHCEQ(Node,Date,Job,User,Index))
    .i Node="StoreMoveStat"  d			// MZY0144	3074976		2022-11-24
    ..q:$p(DataList,"^",1)="" ;TRowID   //合计行不加入统计
    ..s OriginalFee=$p(DataList,"^",16)
    ..s Quantity=$p(DataList,"^",17)
    ..s Count=Count+Quantity
    ..
    .e  i Node="EquipList"  d
    ..q:$p(DataList,"^",64)="" ;TRowID   //合计行不加入统计
    ..i $p(DataList,"^",87)="Y"  d
    ...s ConfigCount=ConfigCount+1
    ..e  d
    ...s Count=Count+1
    ..s OriginalFee=$Number($p(DataList,"^",22),"")
    ..s NetFee=$Number($p(DataList,"^",23),"")
    ..s DepreTotalFee=$Number($p(DataList,"^",29),"")
    ..s Quantity=1
    .e  i Node="CheckDetail"  d     //web.DHCEQOpenCheckRequest
    ..q:$p(DataList,"^",1)="" ;TRowID   //合计行不加入统计
    ..s OriginalFee=$p(DataList,"^",46)
    ..s Quantity=$p(DataList,"^",51)
    ..s Count=Count+Quantity
    ..
    .e  i Node="InStockDetail"  d     //web.DHCEQInStockList
    ..q:$p(DataList,"^",1)="" ;TRowID   //合计行不加入统计
    ..s OriginalFee=$p(DataList,"^",16)
    ..s Quantity=$p(DataList,"^",17)
    ..s Count=Count+Quantity
    .e  i Node="ReturnDetail"  d
    ..q:$p(DataList,"^",1)="" 		//TISRowID   合计行不加入统计
    ..s OriginalFee=$p(DataList,"^",16)
    ..s Quantity=$p(DataList,"^",17)
    ..s Count=Count+Quantity
    .e  i Node="OCREquipDelete"  d
    ..q:$p(DataList,"^",1)="" 		//TRowID   合计行不加入统计
    ..s OriginalFee=$p(DataList,"^",16)
    ..s Quantity=$p(DataList,"^",17)
    ..s Count=Count+Quantity
    .e  i Node="InventoryList"  d	// MZY0151	2023-02-01
    ..s OriginalFee=$p(DataList,"^",9)
    ..s Quantity=1
    ..s Count=Count+Quantity
    .
    .s OriginalFee=$TRANSLATE(OriginalFee,",","")
    .s NetFee=$TRANSLATE(NetFee,",","")
    .s DepreTotalFee=$TRANSLATE(DepreTotalFee,",","")
    .s TotalFee=TotalFee+(Quantity*OriginalFee)
    .s TotalNetFee=TotalNetFee+(Quantity*NetFee)
    .s TotalDepreFee=TotalDepreFee+(Quantity*DepreTotalFee)
    
    s TotalFee=##Class(web.DHCEQCommon).FormatNumber(TotalFee,"")
    s TotalNetFee=##Class(web.DHCEQCommon).FormatNumber(TotalNetFee,"")
    s TotalDepreFee=##Class(web.DHCEQCommon).FormatNumber(TotalDepreFee,"")
    if Node="EquipList"
    {
        s TotalInfo="合计&nbsp;&nbsp;数量:"_Count_"&nbsp;&nbsp;&nbsp;原值:"_TotalFee_"&nbsp;&nbsp;&nbsp;净值:"_TotalNetFee_"&nbsp;&nbsp;&nbsp;累计折旧:"_TotalDepreFee
        i ##class(web.DHCEQCommon).GetSysInfo("990079")=1 s TotalInfo=TotalInfo_"&nbsp;&nbsp;&nbsp;附属:"_ConfigCount       // Mozy003002   2020-03-18  附属设备统计信息
        
        if vType=1 s TotalInfo="合计&nbsp;&nbsp;数量:"_Count_"&nbsp;&nbsp;&nbsp;原值:"_TotalFee
    }
    else
    {
        s TotalInfo="合计&nbsp;&nbsp;数量:"_Count_"&nbsp;&nbsp;&nbsp;总金额:"_TotalFee
    
    }    
    q TotalInfo
}

}
