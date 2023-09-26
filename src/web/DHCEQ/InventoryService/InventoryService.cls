/// web.DHCEQ.InventoryService.InventoryService
Class web.DHCEQ.InventoryService.InventoryService Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// Name of the WebService.
Parameter SERVICENAME = "InventoryService";

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://localhost/csp/websource";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://tempuri.org";

/// TODO: add arguments and implementation.
/// GetEquipInfo
ClassMethod GetEquipInfo(InventoryDR, equipno) As %String [ WebMethod ]
{
	Quit ##Class(web.DHCEQInventory).GetInfoByEquipNo(InventoryDR,equipno)
}

/// 登陆信息
ClassMethod GetLogonInfo(userName, password) As %String [ WebMethod ]
{
	Quit ##Class(web.DHCEQCommon).Logon(userName, password)
}

ClassMethod Logon(userid, locdr, group)
{
}

ClassMethod GetAffixInfo(EquipDr) As %String [ WebMethod ]
{
	Quit ##Class(web.DHCEQAffix).GetAffixsInfoByEquip(EquipDr)
}

ClassMethod GetAffix(EquipDR As %String) As %XML.DataSet [ WebMethod ]
{
	if EquipDR=$C(0) set EquipDR=""
	Set result=##class(%XML.DataSet).%New("web.DHCEQAffix:GetAffix")
	Do result.SetArgs(EquipDR,"")
	Quit result
}

ClassMethod GetEquipType(desc As %String, GroupID As %Library.String = "") As %XML.DataSet [ WebMethod ]
{
	if desc=$C(0) set desc=""
	if GroupID=$C(0) set desc=""
	Set result=##class(%XML.DataSet).%New("web.DHCEQFind:GetEquipType")
	Do result.SetArgs(desc,GroupID)
	Quit result
}

ClassMethod GetEQLoc(Type As %Library.String = "", LocDesc As %Library.String = "", GroupID As %Library.String = "", UserID As %Library.String = "", HospitalID As %Library.String = "") As %XML.DataSet [ WebMethod ]
{
	if Type=$C(0) set Type=""
	if LocDesc=$C(0) set LocDesc=""
	if GroupID=$C(0) set GroupID=""
	if UserID=$C(0) set UserID=""
	if HospitalID=$C(0) set HospitalID=""
	Set result=##class(%XML.DataSet).%New("web.DHCEQFind:GetEQLoc")
	Do result.SetArgs(Type,LocDesc,GroupID,"","",UserID,HospitalID,"") ///修改参数，否则可能没法运行QW20161208
	Quit result
}

ClassMethod LogonLocGrp(userid As %Library.String = "") As %XML.DataSet [ WebMethod ]
{
	if userid=$C(0) set userid=""
	Set result=##class(%XML.DataSet).%New("web.DHCEQCommon:LogonLocGrp")
	Do result.SetArgs(userid)
	Quit result
}

ClassMethod CheckFunction(GrpID, FunctionName) As %String [ WebMethod ]
{
	Set result= ##Class(web.DHCEQCommon).CheckFunction(GrpID, FunctionName)
	Quit result
}

ClassMethod QueryInventoryNew(BeginDate As %Library.String = "", EndDate As %Library.String = "", InventoryNo As %Library.String = "") As %XML.DataSet [ WebMethod ]
{
	if BeginDate=$C(0) set BeginDate=""
	if EndDate=$C(0) set EndDate=""
	if InventoryNo=$C(0) set InventoryNo=""
	Set result=##class(%XML.DataSet).%New("web.DHCEQInventory:QueryInventoryNew")
	Do result.SetArgs(BeginDate,EndDate,InventoryNo)
	Quit result
}

ClassMethod GetInfoByEquipNo(InventoryDR, EquipNo) As %String [ WebMethod ]
{
	if InventoryDR=$C(0) set InventoryDR=""
	if EquipNo=$C(0) set EquipNo=""
	q ##Class(web.DHCEQInventory).GetInfoByEquipNo(InventoryDR, EquipNo,"","")
}

ClassMethod AuditActerEquip(InventoryDR, StoreLocDR, UseLocDR, EquipNo, user As %String = "") As %String [ WebMethod ]
{
	if InventoryDR=$C(0) set InventoryDR=""
	if StoreLocDR=$C(0) set StoreLocDR=""
	if UseLocDR=$C(0) set UseLocDR=""
	if EquipNo=$C(0) set EquipNo=""
	if user=$C(0) set user=""
	q ##Class(web.DHCEQInventory).AuditActerEquip(InventoryDR, StoreLocDR, UseLocDR, EquipNo,user)
}

ClassMethod QueryList(InventoryDR As %String = "", StoreLocDR As %String = "", UseLocDR As %String = "", EquipTypeDR As %String = "", StatCatDR As %String = "", OriginDR As %String = "", onlyShowDiff As %String = "") As %XML.DataSet [ WebMethod ]
{
	if InventoryDR=$C(0) set InventoryDR=""
	if StoreLocDR=$C(0) set StoreLocDR=""
	if UseLocDR=$C(0) set UseLocDR=""
	if EquipTypeDR=$C(0) set EquipTypeDR=""
	if StatCatDR=$C(0) set StatCatDR=""
	if OriginDR=$C(0) set OriginDR=""
	if onlyShowDiff=$C(0) set onlyShowDiff=""
	Set result=##class(%XML.DataSet).%New("web.DHCEQInventory:QueryList")
	Do result.SetArgs(InventoryDR,StoreLocDR,UseLocDR,EquipTypeDR,StatCatDR,OriginDR,onlyShowDiff)
	Quit result
}

ClassMethod GetInventoryLoc(InventoryDR As %String = "") As %XML.DataSet [ WebMethod ]
{
	if InventoryDR=$C(0) set InventoryDR=""
	Set result=##class(%XML.DataSet).%New("web.DHCEQInventory:GetInventoryLoc")
	Do result.SetArgs(InventoryDR)
	Quit result
}

ClassMethod GetInventoryEquip(InventoryDR, LocDR As %String = "") As %XML.DataSet [ WebMethod ]
{
	if InventoryDR=$C(0) set InventoryDR=""
	if LocDR=$C(0) set LocDR=""
	Set result=##class(%XML.DataSet).%New("web.DHCEQInventory:GetEquipList")
	Do result.SetArgs(InventoryDR,LocDR)
	Quit result
}

ClassMethod QueryShortInventory(BeginDate As %String = "", EndDate As %String = "", InventoryNo As %String = "", GroupID As %String = "", HospitalID As %String = "") As %XML.DataSet [ WebMethod ]
{
	if BeginDate=$C(0) set BeginDate=""
	if EndDate=$C(0) set EndDate=""
	if InventoryNo=$C(0) set InventoryNo=""
	if GroupID=$C(0) set GroupID=""
	if HospitalID=$C(0) set HospitalID=""  ;QW20161214 分院区
	Set result=##class(%XML.DataSet).%New("web.DHCEQInventory:QueryShortInventory")
	Do result.SetArgs(BeginDate,EndDate,InventoryNo,GroupID,HospitalID)
	Quit result
}

ClassMethod EqIndex(InventoryDR) As %XML.DataSet [ WebMethod ]
{
	if InventoryDR=$C(0) set InventoryDR=""
	Set result=##class(%XML.DataSet).%New("web.DHCEQInventory:GetEquipIndex")
	Do result.SetArgs(InventoryDR)
	Quit result
}

ClassMethod GetInventoryAffix(InventoryDR, LocDR As %String = "") As %XML.DataSet [ WebMethod ]
{
	if InventoryDR=$C(0) set InventoryDR=""
	if LocDR=$C(0) set LocDR=""
	Set result=##class(%XML.DataSet).%New("web.DHCEQInventory:GetAffixList")
	Do result.SetArgs(InventoryDR,LocDR)
	Quit result
}

ClassMethod UpLoadInventoryResult(InventoryDR, StoreLocDR, UseLocDR, EquipID, EquipNo, EquipName, ReasonType As %String = "", User As %String = "", InventoryDate As %String = "", InventoryTime As %String = "") As %String [ WebMethod ]
{
	if InventoryDR=$C(0) set InventoryDR=""
	if StoreLocDR=$C(0) set StoreLocDR=""
	if UseLocDR=$C(0) set UseLocDR=""
	if EquipID=$C(0) set EquipID=""
	if EquipNo=$C(0) set EquipNo=""
	if EquipName=$C(0) set EquipName=""
	if ReasonType=$C(0) set ReasonType=""
	if User=$C(0) set User=""
	if InventoryDate=$C(0) set InventoryDate=""
	if InventoryTime=$C(0) set InventoryTime=""
	
	q ##Class(web.DHCEQInventory).UpLoadInventoryResult(InventoryDR, StoreLocDR, UseLocDR, EquipID,EquipNo,EquipName,ReasonType, User,InventoryDate,InventoryTime)
}

ClassMethod CheckLocResult(InventoryDR, LocDR) As %String [ WebMethod ]
{
	if InventoryDR=$C(0) set InventoryDR=""
	if LocDR=$C(0) set LocDR=""
	
	q ##Class(web.DHCEQInventory).CheckLocResult(InventoryDR, LocDR)
}

ClassMethod CheckEquipResult(InventoryDR, LocDR, EquipDR) As %String [ WebMethod ]
{
	if InventoryDR=$C(0) set InventoryDR=""
	if LocDR=$C(0) set LocDR=""
	if EquipDR=$C(0) set EquipDR=""
	
	q ##Class(web.DHCEQInventory).CheckEquipResult(InventoryDR, LocDR, EquipDR)
}

ClassMethod UpLoadBatchResult(InventoryDR, BillLocDR, BatchInfos) As %String [ WebMethod ]
{
	if InventoryDR=$C(0) set InventoryDR=""
	if BillLocDR=$C(0) set BillLocDR=""
	if BatchInfos=$C(0) set BatchInfos=""
	
	q ##Class(web.DHCEQInventory).UpLoadBatchResult(InventoryDR,BillLocDR,BatchInfos)
}

ClassMethod CheckBatchResult(InventoryDR, BatchInfos) As %String [ WebMethod ]
{
	if InventoryDR=$C(0) set InventoryDR=""
	if BatchInfos=$C(0) set BatchInfos=""
	
	q ##Class(web.DHCEQInventory).CheckBatchResult(InventoryDR,BatchInfos)
}

ClassMethod GetInventoryInfo(InventoryDR) As %String [ WebMethod ]
{
	Quit ##Class(web.DHCEQInventory).GetOneDetail(InventoryDR)
}

// 通过webservice上传图片

ClassMethod UpLoadIMG(pos As %String = "", filename As %String = "", FileStream As %String, PicListID As %String = "", Isover As %String = "0") As %String [ WebMethod ]
{

		
		;s byte=##class(%Library.Binary).XSDToLogical(FileStream)
		
		s ^EQPictureList(PicListID,pos)=FileStream
		s ^DHCEQQWTemp1(pos)=$P($H,",",2)
		;if pos'="0" s ^DHCEQQWTemp(pos)=$P($H,",",2)-^DHCEQQWTemp1(pos-1)
	    ;set path="E:\DTHealth\app\dthis\web\images\DHCEQPicture\"_filename
	    ;set path="\TestFtp\DHCEQPicture\"_filename
	    /*if Isover="1"
	    {
		    s ^DHCEQQWTemp2(pos)=pos
		    set path=##class(web.DHCEQCommon).GetSysInfo("990004")_filename
			//i FtpFlag'="1"
			//{
				/*Set imgfile=##class(%FileBinaryStream).%New()
				Set imgfile.Filename=filename ;path
				Do imgfile.MoveToEnd()
				d imgfile.Write(byte)
				d imgfile.SaveStream()
				d imgfile.%Close()
				Quit "ok"

			//}
			else
			{
			Set imgfileStream=##class(%FileBinaryStream).%New()
			Set ftp=##class(%Net.FtpSession).%New()
			//set server=##class(web.DHCEQCommon).GetSysInfo("990018")
			set name="admin" ;$p(server,"&",2)
			set password="admin" ;$p(server,"&",3)
			set port="21"
			;i $p(server,"&",4)'="" set port=$p(server,"&",4)
			set server= "192.168.0.156" ;$p(server,"&",1)
			If 'ftp.Connect(server,name,password,port) Write "{success:false,result:'Not connected'}",! Quit "Not connected"
			If 'ftp.Binary() Write "{success:false,result:'Can not swap to binary mode'}",! Quit "Can not swap to binary mode"
			s Length=$LISTLENGTH(EQPictureList)
			s flag= ftp.Retrieve(path,imgfileStream)
			for i=0:1:Length
			{
				If 'flag 
				{
					;Write "Failed to get file",! Quit "Failed to get file"
					d imgfileStream.Write(EQPictureList($J,PicListID,i))
					s flag='flag
				}
				else
				{
					Do imgfileStream.MoveToEnd()
					d imgfileStream.Write(EQPictureList($J,PicListID,i))
				
				}
			}
			If 'ftp.Store(path,imgfileStream) Write "{success:false,result:'Failed to save file'}",! Quit "Failed to save file"
			If 'ftp.Logout() Write "{success:false,result:'Failed to logout'}",! Quit "Failed to logout"
			d imgfileStream.Flush()
			d imgfileStream.%Close()
			k EQPictureList
			Quit "ok"
		}*/
		Quit "ok"
		//}
}

/// ip测试的同时返回一个ip地址显示状态的设置
ClassMethod Iptest() As %String [ WebMethod ]
{
	s Value="0"
	&SQL(Select SS_Value into :Value from SQLUSER.DHC_EQCSysSet where SS_Code='990047')
	Quit "ok"_"^"_Value
}

// 远程获取FTP信息，采用直接FTP上传

ClassMethod GetFtpServerInfo() As %String [ WebMethod ]
{
	set path=##class(web.DHCEQCommon).GetSysInfo("990004")
	s FtpFlag=##class(web.DHCEQCommon).GetSysInfo("990017")
	set server=##class(web.DHCEQCommon).GetSysInfo("990018")
	set $P(server,"&",3)=##class(web.DHCEQCommon).Encrypt($P(server,"&",3))
	
	Quit FtpFlag_"^"_path_"^"_server
}

// 保存图片信息，返回列表ID作为图片名称

ClassMethod SavePictureInfo(PTData, PLData) As %String [ WebMethod ]
{
	if PTData=$C(0) set PTData=""
	if PLData=$C(0) set PLData=""
	
	q ##Class(web.DHCEQ.Process.DHCEQPicture).SaveData(PTData,PLData)
}

// 获取图片列表信息

/*
ClassMethod GetPictureList(EquipDR, SourceType, SourceID, PLID) As %XML.DataSet [ WebMethod ]
{
	if EquipDR=$C(0) set EquipDR=""
	if SourceType=$C(0) set SourceType=""
	if SourceID=$C(0) set SourceID=""
	if PLID=$C(0) set PLID=""
	Set result=##class(%XML.DataSet).%New("web.DHCEQ.query.DHCEQPictureList:GetPictureList")
	Do result.SetArgs(EquipDR,SourceType,SourceID,PLID)
	Quit result
}
*/
ClassMethod GetPictureListInfo(SourceType, SourceID, PLID) As %XML.DataSet [ WebMethod ]
{
	if SourceType=$C(0) set SourceType=""
	if SourceID=$C(0) set SourceID=""
	if PLID=$C(0) set PLID=""
	Set result=##class(%XML.DataSet).%New("web.DHCEQ.Process.DHCEQPictureList:GetPictureListInfo")
	Do result.SetArgs(SourceType,SourceID,PLID)
	Quit result
}

// 获取图片列表信息

ClassMethod Updateflag(PLRowID, UploadFlag) As %String [ WebMethod ]
{
	&SQL(Update SQLUSER.DHC_EQPictureList set PL_UpLoadFlag=:UploadFlag where PL_RowID = :PLRowID)
	s rowid=$g(%ROWID)
 	if SQLCODE  q SQLCODE
 	q rowid
}

// 根据NO取得设备信息

ClassMethod GetEquipByNo(equipno) As %String [ WebMethod ]
{
	if equipno=$C(0) set equipno=""
	s ^DHCEQPDACount("equipinfo",$h)=equipno //add by zx 2016-05-17
	s rowid= ##Class(web.DHCEQM.DHCEQMaintForService).GetEquipIDByNoNew(equipno)
	//s rowid= ##Class(web.DHCEQEquip).GetEquipIDByNo(equipno)
	if rowid="" q 0
	s Result=##Class(web.DHCEQEquip).GetEquipByID("","",rowid)
	q rowid_"@"_Result  //add by zx 2016-09-07
}

/// 获取菜单数据，存入移动端
/// add by zx 2015-08-27   Bug0031
ClassMethod GetModulemenu(ModuleType As %String = "", BussType As %String = "", Name As %String = "", Caption As %String = "", MenuType As %String = "", ClientType As %String = "", ParentMenuDR As %String = "", ShortCutKey As %String = "", ShowInnewWindow As %String = "") As %XML.DataSet [ WebMethod ]
{
	if ModuleType=$C(0) set ModuleType=""
	if BussType=$C(0) set BussType=""
	if Name=$C(0) set Name=""
	if Caption=$C(0) set Caption=""
	if MenuType=$C(0) set MenuType=""
	if ClientType=$C(0) set ClientType=""
	if ParentMenuDR=$C(0) set ParentMenuDR=""
	if ShortCutKey=$C(0) set ShortCutKey=""
	if ShowInnewWindow=$C(0) set ShowInnewWindow=""
	Set result=##class(%XML.DataSet).%New("web.DHCEQCSysMenus:GetModulemenu")
	Do result.SetArgs(ModuleType, BussType, Name, Caption, MenuType, ClientType, ParentMenuDR, ShortCutKey, ShowInnewWindow)
	Quit result
}

// Ftp图片中转函数QW20160418

ClassMethod DownLoadTmp(FileName) As %String [ WebMethod ]
{
	if FileName=$C(0) set FileName=""
	s success="ok"
	set path=##class(web.DHCEQCommon).GetSysInfo("990004")_FileName
	Set ftp=##class(%Net.FtpSession).%New()
	set server=##class(web.DHCEQCommon).GetSysInfo("990018")
	set ^DHCEQTemp("jdl",1)="a"
	set name=$p(server,"&",2)
	set password=$p(server,"&",3)
	set port=$p(server,"&",4)
	if port="" set port=21
	set server=$p(server,"&",1)
	If 'ftp.Connect(server,name,password,port) s success=server_"Not connected"
	If 'ftp.Binary() s success=server_"Can not swap to binary mode"
	Set BinaryStream =##class(%Library.FileBinaryStream).%New()
	d ftp.Retrieve(path,BinaryStream)
	If 'ftp.Logout() s success=server_"Failed to logout"
	set ^DHCEQTemp("jdl",2)="b"
	//保存到临时FTP服务器 
	;在此修改临时FTP服务器 
	//set server="192.168.1.77"
	//set server="172.16.71.230"
	set server="192.168.1.152"
	set name="DHCEQ"
	set password="nanfang123!"
	set port=21

	If 'ftp.Connect(server,name,password,port) s success=server_"Not connected"
	If 'ftp.Binary() s success=server_"Can not swap to binary mode"
	If 'ftp.Store(path,BinaryStream) s success=server_"Failed to save file"
	If 'ftp.Logout()  s success=server_"Failed to logout"
	d BinaryStream.Flush()
	d BinaryStream.%Close()
	set ^DHCEQTemp("jdl",3)="c"
	//set server="172.16.71.230"
	s server="14.23.122.196"    //默认连接地址by HHM 2016-05-05 
	Quit success_"^"_server_"^"_name_"^"_password_"^"_port
}

/*************
*需求号:458989 Add by QW20170929
*设置上传方式
*************/
ClassMethod FTPMode() As %String [ WebMethod ]
{
	q "0"  ; 0:直接与ftp交互 1:需要中转
}

/// 盘盈明细上次
/// add by zx 2016-04-07   Bug0036
ClassMethod UpLoadExceptionResult(InventoryDR, BatchInfos) As %String [ WebMethod ]
{
	if InventoryDR=$C(0) set InventoryDR=""
	if BatchInfos=$C(0) set BatchInfos=""
	q ##Class(web.DHCEQInventory).UpLoadExceptionResult(InventoryDR, BatchInfos)
}

/*************
*需求号:457270 Add by QW20170928
*判断盘点单状态是否可下载上传
*************/
ClassMethod CheckInventoryStatus(InventoryDR) As %String [ WebMethod ]
{
	q ##Class(web.DHCEQInventory).CheckInventoryStatus(InventoryDR)
}

/*************
*Add By QW20180927 bug号:QW0018
*获取pc端维护的广播消息设置
*************/
ClassMethod GetBroadcast(Type) As %XML.DataSet [ WebMethod ]
{
	if Type=$C(0) set Type=""
	Set result=##class(%XML.DataSet).%New("web.DHCEQInventory:QueryPDABroadcast")
	Do result.SetArgs(Type)
	Quit result
}

/*************
*Add By QW2021 bug号:QW00
*获取供应商
*************/
ClassMethod GetVendor() As %XML.DataSet [ WebMethod ]
{
	Set result=##class(%XML.DataSet).%New("web.DHCEQ.Plat.CTVendor:GetVendor")
	Do result.SetArgs("","")
	Quit result
}

/*************
*Add By QW2021 bug号:QW00
*获取生产厂商
*************/
ClassMethod GetManuFacturer() As %XML.DataSet [ WebMethod ]
{
	Set result=##class(%XML.DataSet).%New("web.DHCEQ.Plat.LIBFind:GetManuFacturer")
	Do result.SetArgs("")
	Quit result
}

/*************
*Add By QW2021 bug号:QW00
*获取规格型号
*************/
ClassMethod GetModel() As %XML.DataSet [ WebMethod ]
{
	Set result=##class(%XML.DataSet).%New("web.DHCEQ.Plat.CTModel:GetModel")
	Do result.SetArgs("","")
	Quit result
}

/*************
*Add By QW2021 bug号:QW00
*获取存放地点
*************/
ClassMethod GetShortLocation() As %XML.DataSet [ WebMethod ]
{
	Set result=##class(%XML.DataSet).%New("web.DHCEQ.Plat.CTLocaton:GetShortLocation")
	Do result.SetArgs("")
	Quit result
}

ClassMethod GetSysInfo(code) As %String [ WebMethod ]
{
	if code=$C(0) set code=""
	q ##class(web.DHCEQCommon).GetSysInfo(code)
}

ClassMethod QueryEquipList() As %XML.DataSet [ WebMethod ]
{
	Set result=##class(%XML.DataSet).%New("web.DHCEQInventory:QueryEquipList")
	Quit result
}

ClassMethod QueryBindList() As %XML.DataSet [ WebMethod ]
{
	Set result=##class(%XML.DataSet).%New("web.DHCEQInventory:QueryBindList")
	Quit result
}

ClassMethod UpLoadBatchBind(BatchInfos) As %String [ WebMethod ]
{
	if BatchInfos=$C(0) set BatchInfos=""
	
	q ##Class(web.DHCEQInventory).UpLoadBatchBind(BatchInfos)
}

}
