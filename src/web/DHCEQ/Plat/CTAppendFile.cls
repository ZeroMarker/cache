/// 名称: web.DHCEQ.Plat.CTAppendFile
/// 描述: 文件上传
/// 编写者：ZC
/// 编写日期: 2020-03-27
/// 产品组：设备管理
Class web.DHCEQ.Plat.CTAppendFile Extends %Library.RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：      ZC
/// CreatDate：    2020-03-27
/// Description:   文件查找所需Query
/// Table：        DHC_EQAppendFile,DHC_EQCPicType
/// Input：        CurrentSourceType:当前业务类型
/// 				 CurrentSourceID:当前业务ID	
/// 				         DocName:资料名称	
/// d ##Class(%ResultSet).RunQuery("web.DHCEQ.Plat.CTAppendFile","GetAppendFile","94","2","")
Query GetAppendFile(CurrentSourceType As %String, CurrentSourceID As %String, DocName As %String = "") As %Query(ROWSPEC = "TRowID:%String,TSourceType:%String,TSourceTypeDesc:%String,TSourceID:%String,TAppendFileTypeDR:%String,TAppendFileTypeDesc:%String,TDocName:%String,TFileName:%String,TFilePath:%String,TFileType:%String,TRemark:%String,TToSwfFlag:%String,TFtpStreamSrc:%String,TDocType:%String,TFileNum:%String,TFileListID:%String")
{
}

ClassMethod GetAppendFileExecute(ByRef qHandle As %Binary, CurrentSourceType As %String, CurrentSourceID As %String, DocName As %String = "") As %Status
{
	new repid, index
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1

	d BuildDataGetAppendFile
	
	Quit $$$OK
		
AppendFileSourceTypeAccessable
	//0：无 11:开箱验收 12:安装调试验收 21:入库、22:转移 23:减少 31:维修、32保养、33检查、34报废、35折旧、41使用记录、51设备调帐,52 设备 61工程管理 62科研课题 67公告 91采购申请 92采购计划 93采购招标 94采购合同   //Modefied by zc0063 20200407 添加公告业务类型

	//如果从台帐界面进，想要看到相关文件 就s DHCEQSourceTypeAccess(52,32)=1
	s DHCEQSourceTypeAccess(52,52)=1
	s DHCEQSourceTypeAccess(52,11)=1
	s DHCEQSourceTypeAccess(52,31)=1
	s DHCEQSourceTypeAccess(52,32)=1
	s DHCEQSourceTypeAccess(52,33)=1
	s DHCEQSourceTypeAccess(52,94)=1	//台账可访问合同信息
	s DHCEQSourceTypeAccess(11,11)=1
	s DHCEQSourceTypeAccess(11,94)=1	//czf 2022-09-27
	s DHCEQSourceTypeAccess(31,31)=1
	s DHCEQSourceTypeAccess(32,32)=1
	s DHCEQSourceTypeAccess(33,33)=1
	s DHCEQSourceTypeAccess(34,34)=1
	s DHCEQSourceTypeAccess(51,51)=1
	s DHCEQSourceTypeAccess(67,67)=1   //Modefied by zc0063 20200407 添加公告业务类型
	s DHCEQSourceTypeAccess(94,94)=1	//czf 2022-09-27
	s DHCEQSourceTypeAccess(95,95)=1	// MZY0153	3224977		2023-02-20
	Quit 
BuildDataGetAppendFile
	d AppendFileSourceTypeAccessable //权限验证放在这里，最优化验证过程的开销
	s TSourceType=""
	for  s TSourceType=$o(DHCEQSourceTypeAccess(CurrentSourceType,TSourceType)) q:TSourceType=""  d
	.s SourceIDs=##Class(web.DHCEQ.Process.DHCEQAppendFile).GetSourceIDs(CurrentSourceType,CurrentSourceID,TSourceType) 
	.q:SourceIDs=""  
	.Set len=$L(SourceIDs,",") //SourceIDs形式为 "SourceID1,SourceID2,SourceID3"
	.for i=1:1:len d
	..s TSourceID=$PIECE(SourceIDs,",",i)
	..s TRowID=0
	..f  s TRowID=$o(^DHCEQAppendFile(0,"SourceType",TSourceType,TSourceID,TRowID)) q:TRowID=""  d
	...d ResetVariablesGetAppendFile
	...s TSourceTypeDesc=$CASE(TSourceType,0:"无",11:"开箱验收",12:"安装调试验收",21:"入库",22:"转移",23:"减少",31:"维修",32:"保养",33:"检查",34:"报废",35:"折旧",41:"使用记录",51:"设备调帐",52:"设备",61:"工程管理",62:"科研课题",67:"公告",91:"采购申请",92:"采购计划",93:"采购招标",94:"采购合同",95:"协议合同",:"")	// MZY0153	3224977		2023-02-20
	...s TAppendFileTypeDR=$p($g(^DHCEQAppendFile(TRowID)),"^",3)
	...;q:##Class(web.DHCEQ.Lib.Common).PicTypeIsIn(TAppendFileTypeDR)=1   //Moidefied by zc0071 安全组可访问的文件类型
	...i TAppendFileTypeDR'=""  s TAppendFileTypeDesc=$p($g(^DHCEQCCode("DHCEQCPicType",TAppendFileTypeDR)),"^",2)
	...s TDocName=$p($g(^DHCEQAppendFile(TRowID)),"^",4)
	...q:(DocName'="")&&(TDocName'[DocName)
	...s TFileName=$p($g(^DHCEQAppendFile(TRowID)),"^",5)
	...s TFilePath=$p($g(^DHCEQAppendFile(TRowID)),"^",6)
	...s TFileType=$p($g(^DHCEQAppendFile(TRowID)),"^",7)
	...s TRemark=$p($g(^DHCEQAppendFile(TRowID)),"^",8)
	...q:$p($g(^DHCEQAppendFile(TRowID)),"^",19)="Y" //AF_InvalidFlag
	...s TToSwfFlag=$p($g(^DHCEQAppendFile(TRowID)),"^",20) //Y office在线预览功能，文件已转化为swf格式置Y
	...s TFtpStreamSrc=##Class(web.DHCEQ.Plat.CTAppendFile).GetFtpStreamSrcByAFRowID(TRowID)
	...s TDocType=1
	...s TDocType="文件"
	...s TFileNum="1份"
	...d OutputRowGetAppendFile
	//Add by zc0125 2022-12-8 先去掉图片显示后期统一处理 begin
	/*..;图片
	..s TRowID=0
	..f  s TRowID=$o(^DHCEQPicture(0,"Source",TSourceType,TSourceID,TRowID)) q:TRowID=""  d
	...d ResetVariablesGetAppendFile
	...s TInvalidFlag=$p($g(^DHCEQPicture(TRowID)),"^",7)
	...q:(2=TInvalidFlag)
	...s TSourceTypeDesc=$CASE(TSourceType,0:"无",11:"开箱验收",12:"安装调试验收",21:"入库",22:"转移",23:"减少",31:"维修",32:"保养",33:"检查",34:"报废",35:"折旧",41:"使用记录",51:"设备调帐",52:"设备",61:"工程管理",62:"科研课题",67:"公告",91:"采购申请",92:"采购计划",93:"采购招标",94:"采购合同",95:"协议合同",:"")	// MZY0153	3224977		2023-02-20
	...s TAppendFileTypeDR=$p($g(^DHCEQPicture(TRowID)),"^",5)
	...i TAppendFileTypeDR'=""  s TAppendFileTypeDesc=$p($g(^DHCEQCCode("DHCEQCPicType",TAppendFileTypeDR)),"^",2)
	...s TDocName=$p($g(^DHCEQPicture(TRowID)),"^",13)
	...q:(DocName'="")&&(TDocName'[DocName)
	...s TFileName=""
	...s TFilePath=$p($g(^DHCEQPicture(TRowID)),"^",4)
	...s TRemark=$p($g(^DHCEQPicture(TRowID)),"^",3)
	...s TDocType=0
	...s TDocType="图片"
	...s TPLRowID=""
	...for  s TPLRowID=$o(^DHCEQPictureList(0,"Picture",TRowID,TPLRowID)) q:(TPLRowID="")  d
	....q:$p(^DHCEQPictureList(TPLRowID),"^",12)="Y"
	....s TFileType=$p(^DHCEQPictureList(TPLRowID),"^",3)
	....s TFileNum=TFileNum+1
	....s:TFileListID'="" TFileListID=TFileListID_","
	....s TFileListID=TFileListID_TPLRowID
	...s TFileNum=+TFileNum_"张"
	...d OutputRowGetAppendFile*/
	//Add by zc0125 2022-12-8 先去掉图片显示后期统一处理 begin
	quit
OutputRowGetAppendFile
	s Data=$lb(TRowID,TSourceType,TSourceTypeDesc,TSourceID,TAppendFileTypeDR,TAppendFileTypeDesc,TDocName,TFileName,TFilePath,TFileType,TRemark,TToSwfFlag,TFtpStreamSrc,TDocType,TFileNum,TFileListID)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetAppendFile
	s (TSourceTypeDesc,TAppendFileTypeDR,TAppendFileTypeDesc,TDocName,TFileName,TFilePath,TFileType,TRemark,TToSwfFlag,TFtpStreamSrc,TDocType,TFileNum,TFileListID)=""
	quit
}

ClassMethod GetAppendFileClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAppendFileExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAppendFileFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAppendFileExecute ]
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

/// 通过明细表rowid获取url值
ClassMethod GetFtpStreamSrcByAFRowID(AFRowID)
{
	i AFRowID="" q 0
	i $G(^DHCEQTemp("Cache","ID"))="" s ^DHCEQTemp("Cache","ID")=0	//页面刷新后向不同图片路径请求，防止客户端缓存当前图片
	q "web.DHCEQ.Lib.DHCEQAppendFileStreamServer.cls?APPENDFILEROWID="_(##Class(websys.Page).Encrypt(AFRowID))_"&CacheID="_$I(^DHCEQTemp("Cache","ID"))
}

}
