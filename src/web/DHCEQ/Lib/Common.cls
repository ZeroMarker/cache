Class web.DHCEQ.Lib.Common Extends %Library.RegisteredObject [ Not ProcedureBlock ]
{

/// Add By DJ 2018-07-04
/// 描述:获取Json格式单表记录.格式为:{字段名1:字段值1,字段名2:字段值2}
/// 入参:vTableRecordObj 表记录对象
/// 返回值:单表记录Json格式串
/// d ##Class(web.DHCEQ.Lib.Common).GetJsonTableRecord(##Class(User.DHCEQChangeAccount).%OpenId(1)).%ToJSON()
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
	.i ((ColumnType="%Library.Float")||(ColumnType="%Float"))&&(ColumnValue'="") s ColumnValue=##Class(web.DHCEQCommon).FormatNumber(ColumnValue,"",2)
	.i (DisPlayList=",Yes,No") s ColumnValue=##Class(web.DHCEQCommon).TransValueToPage(ColumnValue,"bool")
	.i ((ColumnType["User.")||((ColumnType'["%")))&&(ColumnValue'="") s ColumnValue=ColumnValue.%Id()    //modify by wl 2020-06-18 WL0068引用User持久类可能没有写user.导致id无法赋值
	.s ColumnValue=##class(web.DHCEQCommon).Replace(ColumnValue,$C(13,10),"\n")
	.d Result.%Set(ColumnName,ColumnValue)
	q Result
}

/// Add By DJ 2018-07-06
/// 描述:生成类方法JSON统一返回值格式
/// 入参:vSQLCODE 错误代码
/// 		vData 错误信息
/// 返回值:JSON格式串{"SQLCODE":错误代码,"Data":错误信息}
ClassMethod ReturnJson(vSQLCODE As %String = "", vData As %String = "")
{
	s ReturnInfo=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	s ReturnData=vData
	i vSQLCODE'=0  d
	.s ReturnData=vSQLCODE_##Class(web.DHCEQ.Lib.Common).GetPromptByCode(vSQLCODE)
	.i vData'="" s ReturnData=ReturnData_"[详细:"_vData_"]"
	d ReturnInfo.%Set("SQLCODE",vSQLCODE)
	d ReturnInfo.%Set("Data",ReturnData)
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

/// Add By DJ 2018-07-30
/// 描述:获取JS业务及JS通用消息
/// 入参:vBuss 业务名称
/// 返回值:JS业务及JS通用消息JSON串 格式{代码1:描述1,代码2:描述2,....,代码n:描述n}
/// w ##Class(web.DHCEQ.Lib.Common).GetPromptInfo("mmaintrequest")
ClassMethod GetPromptInfo(vBuss As %String = "")
{
	s PromptInfo=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	s PISource=0
	f  s PISource=$o(^DHCEQCCode("DHCEQCPromptInfo",0,"Source",1,PISource)) q:PISource=""  d
	.q:((PISource'=3)&&(PISource'=4))		//3JS业务 4JS通用
	.s PIBuss=""
	.f  s PIBuss=$o(^DHCEQCCode("DHCEQCPromptInfo",0,"Source",1,PISource,PIBuss))  q:PIBuss=""  d
	..q:((PISource=3)&&(vBuss'="")&&(PIBuss'=vBuss))
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
/// 描述:获取组件元素Caption描述信息
/// 入参:compid 组件ID
/// 		valname 组件元素名
/// 返回值:元素Caption的JSON格式串  格式:{"SQLCODE":成功失败代码,"Data":名称}
ClassMethod GetColumnCaption(compid, valname)
{
	n (compid, valname)
	i compid="" q ##Class(web.DHCEQ.Lib.Common).ReturnJson(0,"")
	i valname="" q ##Class(web.DHCEQ.Lib.Common).ReturnJson(0,"")
	s valname=##Class(web.DHCEQCommon).Trim(valname)
	s valname=$ZConvert(valname,"U")
	s valname=" "_valname
	s caption=""
	s sub=$o(^websys.ComponentTableItemsI("Name",compid,valname,0))
	i sub'=""  d
	.s id=compid_"||"_sub
	.s tableItem=##class(websys.ComponentTableItems).%OpenId(id)
	.s caption=tableItem.Caption
	q ##Class(web.DHCEQ.Lib.Common).ReturnJson(0,caption)
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

/// Add By ZC0071 2020-04-30
/// 描述:判断安全组是否可以查看图片与文件
/// 入参:vPicType 图片与文件类型ID
/// 		CurGroupID 安全组  默认为空
/// 返回值:Flag 0 可操作 1 不可操作
/// w ##Class(web.DHCEQ.Lib.Common).PicTypeIsIn("1",85)
ClassMethod PicTypeIsIn(vPicType As %String = "", CurGroupID As %String = "")
{
	new GroupID,Flag,GPTypeDR
	set GroupID=CurGroupID
	if GroupID="" s GroupID=%session.Get("LOGON.GROUPID")
	s Flag=1
	////Modefied by zc0093 2021-01-07  图片权限索引处理处理 begin
	; MZY0023	1306895		2020-05-08	修正过滤安全组设置图片类型处理
	;s GPTypeDR=""
	;For  Set GPTypeDR=$Order(^DHCEQCCode("DHCEQCGroupPicType",0,"GPTGroupDR",GroupID,GPTypeDR)) Quit:(GPTypeDR="")||(Flag=0)  Do
	;.i $p($g(^DHCEQCCode("DHCEQCGroupPicType",GPTypeDR)),"^",2)=vPicType s Flag=0
	i $d(^DHCEQCCode("DHCEQCGroupPicType",0,"GPTGroupDR",GroupID,vPicType)) s Flag=0 
	////Modefied by zc0093 2021-01-07  图片权限索引处理处理 end
	q Flag
}

/// Add By ZC0096 2021-01-18
/// 描述:根据业务类型与业务ID获取对应视频与音频信息
/// 入参:vSourceType 业务类型
/// 		vSourceID 业务ID
/// 返回值:VideoInfo_"^"_AudioInfo 视频信息与音频信息
/// 命令：w ##Class(web.DHCEQ.Lib.Common).GetVideoAndAudioInfo("31","1")
ClassMethod GetVideoAndAudioInfo(vSourceType As %String = "", vSourceID As %String = "")
{
	i (vSourceType="")||(vSourceID="") q ""
	s (VideoInfo,AudioInfo)="^"
	s AVFRowID=0
	f  s AVFRowID=$o(^DHCEQAppendFile(0,"SourceType",vSourceType, vSourceID,AVFRowID))  quit:AVFRowID=""  d
	.s AVppendFileTypeDR=$p($g(^DHCEQAppendFile(AVFRowID)),"^",3)	
	.q:$P($G(^DHCEQCCode("DHCEQCPicType",AVppendFileTypeDR)),"^",3)'=1
	.s VideoInfo=AVFRowID_"^"_$p($g(^DHCEQAppendFile(AVFRowID)),"^",5)		
	s AFRowID=0
	f  s AFRowID=$o(^DHCEQAppendFile(0,"SourceType",vSourceType, vSourceID,AFRowID))  quit:AFRowID=""  d
	.s AppendFileTypeDR=$p($g(^DHCEQAppendFile(AFRowID)),"^",3)	
	.q:$P($G(^DHCEQCCode("DHCEQCPicType",AppendFileTypeDR)),"^",3)'=2
	.s AudioInfo=AFRowID_"^"_$p($g(^DHCEQAppendFile(AFRowID)),"^",5)	
	q VideoInfo_"^"_AudioInfo
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
	
	Quit $$$OK
OutputRowGetAppendFileAndPic
	s Data=$lb(TRowID,SourceType,SourceID,TPicTypeDR,TPicType,TName,TFtpStreamSrc,TFileType,TToSwfFlag,TFlag)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetAppendFileAndPic
	s (TRowID,TPicTypeDR,TPicType,TName,TFtpStreamSrc,TFileType,TToSwfFlag,TFlag)=""
	quit
}

ClassMethod GetAppendFileAndPicFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAppendFileAndPicExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetAppendFileAndPicClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAppendFileAndPicExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
