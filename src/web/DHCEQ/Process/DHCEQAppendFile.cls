Class web.DHCEQ.Process.DHCEQAppendFile Extends %Library.RegisteredObject [ Not ProcedureBlock ]
{

/// GetAppendFile
/// w ##Class(%ResultSet).RunQuery("web.DHCEQ.Process.DHCEQAppendFile","GetAppendFile",52,1)
Query GetAppendFile(CurrentSourceType As %String, CurrentSourceID As %String, vData As %String = "") As %Query(ROWSPEC = "TRowID:%String,TSourceType:%String,TSourceTypeDesc:%String,TSourceID:%String,TAppendFileTypeDR:%String,TAppendFileTypeDesc:%String,TDocName:%String,TFileName:%String,TFilePath:%String,TFileType:%String,TRemark:%String,TToSwfFlag:%String,TFtpStreamSrc:%String")
{
}

ClassMethod GetAppendFileExecute(ByRef qHandle As %Binary, CurrentSourceType As %String, CurrentSourceID As %String, vData As %String = "") As %Status
{
	new repid, index
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
 	s DocName=$p($G(vData),"^",3)
	d BuildDataGetAppendFile
	
	Quit $$$OK
		
AppendFileSourceTypeAccessable
	//0：无 11:开箱验收 12:安装调试验收 21:入库、22:转移 23:减少 31:维修、32保养、33检查、34报废、35折旧、41使用记录、51设备调帐,52 设备 61工程管理 62科研课题 91采购申请 92采购计划 93采购招标 94采购合同  67公告

	//如果从台帐界面进，想要看到保养相关图片 就s DHCEQSourceTypeAccess(52,32)=1
	s DHCEQSourceTypeAccess(52,52)=1
	s DHCEQSourceTypeAccess(52,11)=1
	s DHCEQSourceTypeAccess(52,31)=1
	s DHCEQSourceTypeAccess(52,32)=1
	s DHCEQSourceTypeAccess(52,33)=1
	s DHCEQSourceTypeAccess(11,11)=1
	s DHCEQSourceTypeAccess(31,31)=1
	s DHCEQSourceTypeAccess(32,32)=1
	s DHCEQSourceTypeAccess(33,33)=1
	s DHCEQSourceTypeAccess(67,67)=1   //add by lmm 2019-10-12
	s DHCEQSourceTypeAccess(51,51)=1  //Add By QW20210629 BUG:QW0129
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
	...;add by lmm 2019-10-12
	...s TSourceTypeDesc=$CASE(TSourceType,0:"无",11:"开箱验收",12:"安装调试验收",21:"入库",22:"转移",23:"减少",31:"维修",32:"保养",33:"检查",34:"报废",35:"折旧",41:"使用记录",51:"设备调帐",52:"设备",61:"工程管理",62:"科研课题",67:"公告",91:"采购申请",92:"采购计划",93:"采购招标",94:"采购合同",:"")
	...s TAppendFileTypeDR=$p($g(^DHCEQAppendFile(TRowID)),"^",3)
	...i TAppendFileTypeDR'=""  s TAppendFileTypeDesc=$p($g(^DHCEQCCode("DHCEQCAppendFileType",TAppendFileTypeDR)),"^",2)
	...s TDocName=$p($g(^DHCEQAppendFile(TRowID)),"^",4)
	...q:(DocName'="")&&(TDocName'[DocName)
	...s TFileName=$p($g(^DHCEQAppendFile(TRowID)),"^",5)
	...s TFilePath=$p($g(^DHCEQAppendFile(TRowID)),"^",6)
	...s TFileType=$p($g(^DHCEQAppendFile(TRowID)),"^",7)
	...s TRemark=$p($g(^DHCEQAppendFile(TRowID)),"^",8)
	...q:$p($g(^DHCEQAppendFile(TRowID)),"^",19)="Y" //AF_InvalidFlag
	...s TToSwfFlag=$p($g(^DHCEQAppendFile(TRowID)),"^",20) //Y office在线预览功能，文件已转化为swf格式置Y
	...s TFtpStreamSrc=..GetFtpStreamSrcByAFRowID(TRowID)
	...d OutputRowGetAppendFile
	quit
OutputRowGetAppendFile
	s Data=$lb(TRowID,TSourceType,TSourceTypeDesc,TSourceID,TAppendFileTypeDR,TAppendFileTypeDesc,TDocName,TFileName,TFilePath,TFileType,TRemark,TToSwfFlag,TFtpStreamSrc)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetAppendFile
	s (TSourceTypeDesc,TAppendFileTypeDR,TAppendFileTypeDesc,TDocName,TFileName,TFilePath,TFileType,TRemark,TToSwfFlag,TFtpStreamSrc)=""
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

/// w ##Class(web.DHCEQ.Process.DHCEQAppendFile).SaveAppendFile()
ClassMethod SaveAppendFile(AFData As %String = "")
{
	new AFList
	Set AFRowID=$p($G(AFData),"^",1)
 	Set AFList(2)=$p($G(AFData),"^",2)
 	Set AFList(3)=$p($G(AFData),"^",3)
 	Set AFList(4)=$p($G(AFData),"^",4)
 	Set AFList(5)=$p($G(AFData),"^",5)	
 	i $p($G(AFData),"^",6)'="" s AFList(6)=$p($G(AFData),"^",6) //允许不更新AF_FileName，保留上次值
 	i $p($G(AFData),"^",7)'="" s AFList(7)=$p($G(AFData),"^",7)
 	i $p($G(AFData),"^",8)'="" s AFList(8)=$p($G(AFData),"^",8) //AF_FileType
 	Set AFList(9)=$p($G(AFData),"^",9)
 	s AFList(21)=$p($G(AFData),"^",21)
 	i $p($G(AFData),"^",8)'="" s AFList(21)="N"  //N office在线预览功能，文件尚未转化为swf格式时置N
 	
	//Set AFList(10)=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	Set AFList(10)=1
	Set AFList(11)=+$H
	Set AFList(12)=$P($H,",",2)
	if AFRowID=""
	{
		s AFList(19)=0
		s AFList(20)="N"
 		&SQL(Insert into SQLUSER.DHC_EQAppendFile values :AFList()) 
 		s rowid=$g(%ROWID)
 		if SQLCODE
		{
	   		q -6
	 	}
	}
	else
	{ 	
	 	if ((AFList(2)'="")&&(AFList(3)'="")) //可编辑表格，防止无意义的主表更新
	 	{
 			&SQL(Update SQLUSER.DHC_EQAppendFile values :AFList() where AF_RowID = :AFRowID)
 			s rowid=$g(%ROWID)
 			if SQLCODE
			{
				b
	   			q -9
	 		}
	 	}
	}
 	q:rowid'="" rowid
 	q PTRowID
}

/// w ##Class(web.DHCEQ.Process.DHCEQAppendFile).SaveAppendFile()
ClassMethod DeleteAppendFile(RowID As %String = "")
{
	&SQL(Update SQLUSER.DHC_EQAppendFile set AF_InvalidFlag='Y' where AF_RowID = :RowID)
	q SQLCODE
}

ClassMethod UploadByFtpStream(Path, Stream As %Stream.Object)
{
		;采用Ftp上传方式
		Set ftp=##class(%Net.FtpSession).%New()
		//Modefied by zc0107 2021-11-14 上传修改 begin
		i (##class(web.DHCEQCommon).GetSysInfo("990086")=1) Set ftp.SSLConfiguration="FTPS"   ////Modefied by zc0107 2021-11-22  将系统参数990026改成990086
		//Set ftp.SSLConfiguration="FTPS"  //Add By QW20210705 BUG:QW0137 FTPS修正
		//Modefied by zc0107 2021-11-14 上传修改 end
		set server=##class(web.DHCEQCommon).GetSysInfo("990018")
		set name=$p(server,"&",2)
		//Moidefied by zc0069  密码解密 begin
		//set password=$p(server,"&",3)
		set password=##Class(web.Util.Encryption).SimpleDecrypt($p(server,"&",3),"DHCEQ")
		//Moidefied by zc0069  密码解密 end
		set port=21
		i $p(server,"&",4)'="" set port=$p(server,"&",4)
		set server=$p(server,"&",1)
		If 'ftp.Connect(server,name,password,port) Quit -1				//Not connected 
		If 'ftp.Binary() Quit -2										//Can not swap to binary mode
		If 'ftp.Store(Path,Stream) Quit -3	//Failed to save file文件无法访问？缓存文件无法访问？缓存：权限受限
		If 'ftp.Logout() Quit -4										//Failed to logout
		Quit 0
}

/// 通过明细表rowid获取url值
ClassMethod GetFtpStreamSrcByAFRowID(AFRowID)
{
	i AFRowID="" q 0
	i $G(^DHCEQTemp("Cache","ID"))="" s ^DHCEQTemp("Cache","ID")=0	//页面刷新后向不同图片路径请求，防止客户端缓存当前图片
	q "web.DHCEQ.Lib.DHCEQAppendFileStreamServer.cls?APPENDFILEROWID="_(##Class(websys.Page).Encrypt(AFRowID))_"&CacheID="_$I(^DHCEQTemp("Cache","ID"))
}

/// w ##Class(web.DHCEQ.Process.DHCEQPicture).GetSourceIDs(0,8,1) 查找设备rowid为8的设备对应的所有保养记录rowid
/// 注意w ##Class(web.DHCEQ.Process.DHCEQPicture).GetSourceIDs(1,10,1) 保养业务rowid为10数据，查找保养记录将只能返回本条保养记录的rowid（无法查到这台设备其他保养信息rowid）
/// 20151125 后台已处理11验收31维修32保养33检查52台帐业务互取过程
ClassMethod GetSourceIDs(CurrentSourceType As %String, CurrentSourceID As %String, SourceType = "")
{
	i SourceType="" q CurrentSourceID
	;在自身业务类型中,只看到当前业务对应图片
	i SourceType=CurrentSourceType  q CurrentSourceID
	
	
	
	//有设备DR业务先获取设备DR，
	s EquipDR=$CASE(CurrentSourceType,52:CurrentSourceID,31:$p($G(^DHCEQMaintRequest(CurrentSourceID)),"^",1),32:$p($G(^DHCEQMaint(CurrentSourceID)),"^",1),33:$p($G(^DHCEQMaint(CurrentSourceID)),"^",1),:"")
	i EquipDR="" q ""
	
	New TSourceIDs,TempSourceID,Type
	//然后通过设备DR取相应业务rowid
	s TSourceIDs=""
	s TempSourceID=""
	i SourceType=52 s TSourceIDs=EquipDR
	;SourceType=1 保养 SourceType=2检查
	i (SourceType=32)||(SourceType=33) d
	.i SourceType=32 s Type=1
	.i SourceType=33 s Type=2
	.for  s TempSourceID=$o(^DHCEQMaint(0,"Equip",Type,EquipDR,TempSourceID)) q:TempSourceID=""  d
	..i TSourceIDs="" s TSourceIDs=TempSourceID 
	..e  s TSourceIDs=TSourceIDs_","_TempSourceID
	i SourceType=31 d
	.for  s TempSourceID=$o(^DHCEQMaintRequest(0,"Equip",EquipDR,TempSourceID)) q:TempSourceID=""  d
	..i TSourceIDs="" s TSourceIDs=TempSourceID 
	..e  s TSourceIDs=TSourceIDs_","_TempSourceID
	i SourceType=11 d
	.s TSourceIDs=$p(^DHCEQEquip(EquipDR),"^",77)
	i SourceType=94 d
	.s TContractListID=$p(^DHCEQEquip(EquipDR),"^",32)
	.s TContractNo=$p(^DHCEQEquip(EquipDR),"^",76)
	.i TContractNo'="" s TSourceIDs=$o(^DHCEQContract(0,"ContractNo",TContractNo,""))
	.i (TSourceIDs="")&&(TContractListID'="") s TSourceIDs=$p(^DHCEQContractList(TContractListID),"^",1)
	
	q TSourceIDs
}

/// add by lmm 2020-02-29
/// modified by czf 2022-04-07 增加入参AppendFileTypeDR和DocName
/// 描述：根据业务及业务id获取电子资料id
/// w ##Class(web.DHCEQ.Process.DHCEQAppendFile).GetAppenfFileIDBySource(67,5)
ClassMethod GetAppenfFileIDBySource(SourceType As %String, SourceID As %String, AppendFileTypeDR As %String = "", DocName As %String = "")
{
	s FindAFID=""
	s AppendFileID=""
	f  s AppendFileID=$o(^DHCEQAppendFile(0,"SourceType",SourceType,SourceID,AppendFileID)) q:((AppendFileID="")||(FindAFID'=""))  d
	.s AFFileType=$p($g(^DHCEQAppendFile(AppendFileID)),"^",3)
	.s AFDocName=$p($g(^DHCEQAppendFile(AppendFileID)),"^",4)
	.q:$p($g(^DHCEQAppendFile(AppendFileID)),"^",19)
	.q:(AppendFileTypeDR'="")&&(AFFileType'="")&&(AppendFileTypeDR'=AFFileType)
	.q:(DocName'="")&&(AFDocName'="")&&(AFDocName'=DocName)
	.s FindAFID=AppendFileID
	q FindAFID
}

}
