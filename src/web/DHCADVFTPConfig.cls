Import SQLUSER

Class web.DHCADVFTPConfig Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：      wangxuejian
/// CreatDate：    2020-03-17
/// Description：  查询FTP地址表
/// Table：        User.DHCAdvFTPConfig
/// Input：		   params:"FTP代码^FTP描述"
/// Output：       FTP地址维护信息
/// Others：       w ##Class(web.DHCADVFTPConfig).QueryFTPConfig("20","1","^","")
ClassMethod QueryFTPConfig(rows As %String, page As %String, params As %String, HospID As %String) As %String
{
	n (rows,page,params,HospID)

	s End=page*rows
	s Start=(page-1)*rows+1
	s pid=##class(web.DHCADVCOMMON).NewPid()	
	d ..killTmpGlobal(pid)     // k掉临时global
	s Code=$p(params,"^",1)    // 在串params中取值
	s Desc=$p(params,"^",2)
	s h=0,count=0
	s FTPRowID=""
	for  s FTPRowID=$o(^DHCADVFTPC(FTPRowID)) q:FTPRowID=""  d  // 查询表DHC_AdvFTPConfig
	.q:FTPRowID=0
	.s FTPCode=$p(^DHCADVFTPC(FTPRowID),"^",1)      	// FTP代码
	.s FTPDesc=$p(^DHCADVFTPC(FTPRowID),"^",2)	  		// FTP描述
	.s FTPAddressIP=$p(^DHCADVFTPC(FTPRowID),"^",3)	  	// FTP地址
	.s FTPUserName=$p(^DHCADVFTPC(FTPRowID),"^",4)		// 用户名
	.s FTPPassWord=$p(^DHCADVFTPC(FTPRowID),"^",5)		// 密码
	.s FTPPassWord=##Class(web.DHCADVCOMMON).DeCode(FTPPassWord) /// 2021-06-15 cy 密码 解密
	.s FTPPort=$p(^DHCADVFTPC(FTPRowID),"^",6)		    // 端口
	.s FTPHospDr=$p(^DHCADVFTPC(FTPRowID),"^",7)		    // 医院id
	.q:(Code'="")&(FTPCode'[Code)						// 代码过滤
	.q:(Desc'="")&(FTPDesc'[Desc)						// 描述过滤
	.q:(HospID'="")&(FTPHospDr'=HospID)
	.s ftpHosp=""
	.s:FTPHospDr'="" ftpHosp=$p(^CT("HOSP",FTPHospDr),"^",2)
	.s h=h+1
	.s tempstr=FTPRowID_"^"_FTPCode_"^"_FTPDesc_"^"_FTPAddressIP_"^"_FTPUserName_"^"_FTPPassWord_"^"_FTPPort_"^"_ftpHosp_"^"_FTPHospDr
	.s ^TMP("DHCADV","web.DHCADVFTPConfig","QueryFTPConfig",pid,h)=tempstr     // 数据存储
	
	q:h=0 ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(h) 	// 输出json结尾符
	
	///转换数据为Json格式
	s title="FTPRowID^FTPCode^FTPDesc^FTPAddressIP^FTPUserName^FTPPassWord^FTPPort^hospDr^hospDrID" // 列title 
	w ##class(web.DHCADVJSONCOMMON).getJsonStartSign(h) 		//  输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCADV","web.DHCADVFTPConfig","QueryFTPConfig",pid,index)) q:index=""  d
	.s mdate=$g(^TMP("DHCADV","web.DHCADVFTPConfig","QueryFTPConfig",pid,index))
	.s count = count+1
	.q:(count<Start)||(count>End)
	.i count=Start d
	..w ##class(web.DHCADVJSONCOMMON).getJsonData(title,mdate)
	.e  d
	..w ","_##class(web.DHCADVJSONCOMMON).getJsonData(title,mdate)
	w ##class(web.DHCADVJSONCOMMON).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// Creator：      wangxuejian
/// CreatDate：    2020-03-17
/// Description：  保存ftp地址
/// Table：        DHC_AdvFTPConfig
/// Input：		   FTPRowID^FTPCode^FTPDesc^FTPAddressIP^FTPPort^FTPUserName^FTPPassWord^FTPHospDr
/// Output：       0:成功 ,其他:失败
/// Others：       w ##Class(web.DHCADVFTPConfig).SaveFTPConfig("^DHCADV^不良事件^127.0.0.1^111^administration^123^2")
ClassMethod SaveFTPConfig(params As %String) As %String
{
	n (params)
	s Err=0
	TS
	s Len=$l(params,"$$")
	for i=1:1:Len  d
	.s ListData=$p(params,"$$",i)
	.s Err=..CheckRepeat(ListData)   	/// 重复性判断
	.q:Err'=0
	.i $p(ListData,"^",1)'=""  q:Err'=0  d
	..s Err=..UpdateFTPConfig(ListData)  /// 更新
	.e  d
	..s Err=..InsertFTPConfig(ListData)  /// 插入
	i Err'=0 tro
	q:Err'=0 Err
	TC
	q Err
}

/// Creator：   wangxuejian
/// CreatDate: 2020-03-17
/// Descript:  检查代码、描述是否重复
/// Table：    DHC_AdvFTPConfig
/// Others：   w ##class(web.DHCADVFTPConfig).CheckRepeat("^DHCADV^不良事件^127.0.0.1^111^administration^123^2")
ClassMethod CheckRepeat(ItmTempStr As %String) As %String
{
	n (ItmTempStr)
	s ret=0
	s ID=$p(ItmTempStr,"^",1)   	///ID
	s FTPCode=$p(ItmTempStr,"^",2)  ///代码
	s FTPDesc=$p(ItmTempStr,"^",3)  ///描述
	/// 新记录
	if ID=""  d
	.i $d(^DHCADVFTPC(0,"Code",$$ALPHAUP^SSUTIL4((FTPCode))))   d
	..s ret=-1
	/// 修改记录
	else  d
	.s Code=$p($g(^DHCADVFTPC(ID)),"^",1)    //代码
	.i (Code'=FTPCode)&($d(^DHCPHFTPC(0,"Code",$$ALPHAUP^SSUTIL4(FTPCode))))  d
	..s ret=-2
	q ret
}

/// Creator：      wangxuejian
/// CreatDate：    2020-03-17
/// Description：  保存FTP地址表
/// Table：        DHC_AdvFTPConfig
/// Input：		   FTPRowID^FTPCode^FTPDesc^FTPAddressIP^FTPPort^FTPUserName^FTPPassWord^FTPHospDr
/// Output：       0:成功 ,其他:失败
/// Others：       w ##Class(web.DHCADVFTPConfig).InsertFTPConfig()
ClassMethod InsertFTPConfig(ListData As %String) As %String
{
	n (ListData)
	s FTPCode=$p(ListData,"^",2)     	/// FTP代码
	s FTPDesc=$p(ListData,"^",3)	 	/// FTP描述
	s FTPAddressIP=$p(ListData,"^",4)   /// FTP地址
	s FTPPort=$p(ListData,"^",5)        /// 端口
	s FTPUserName=$p(ListData,"^",6)	/// 用户名
	s FTPPassWord=$p(ListData,"^",7)    /// 密码
	s FTPPassWord=##Class(web.DHCADVCOMMON).EnCode(FTPPassWord) /// 2021-06-15 cy 密码 加密
	s FTPHospDr=$p(ListData,"^",8)     /// 医院ID
	&SQL(Insert into DHC_AdvFTPConfig (FTP_Code,FTP_Desc,FTP_AddressIP,FTP_UserName,FTP_PassWord,FTP_Port,FTP_Hosp_Dr) values 
	(:FTPCode,:FTPDesc,:FTPAddressIP,:FTPUserName,:FTPPassWord,:FTPPort,:FTPHospDr))
	q SQLCODE
}

/// Creator：      wangxuejian
/// CreatDate：    2020-03-17
/// Description：  更新FTP地址表
/// Table：        DHC_AdvFTPConfig
/// Input：		   FTPRowID^FTPCode^FTPDesc^FTPAddressIP^FTPPort^FTPUserName^FTPPassWord^FTPHospDr
/// Output：       0:成功 ,其他:失败
/// Others：       w ##Class(web.DHCADVFTPConfig).UpdateFTPConfig()
ClassMethod UpdateFTPConfig(ListData As %String) As %String
{
	n (ListData)
	s FTPRowID=$p(ListData,"^",1)		/// FTP表ID
	s FTPCode=$p(ListData,"^",2)     	/// FTP代码
	s FTPDesc=$p(ListData,"^",3)	 	/// FTP描述
	s FTPAddressIP=$p(ListData,"^",4)   /// FTP地址
	s FTPPort=$p(ListData,"^",5)    	/// 端口
	s FTPUserName=$p(ListData,"^",6)	/// 用户名
	s FTPPassWord=$p(ListData,"^",7)    /// 密码
	s FTPPassWord=##Class(web.DHCADVCOMMON).EnCode(FTPPassWord) /// 2021-06-15 cy 密码 加密
	s FTPHospDr=$p(ListData,"^",8)    /// 医院ID
	&SQL(Update DHC_AdvFTPConfig Set FTP_Code=:FTPCode,FTP_Desc=:FTPDesc,FTP_AddressIP=:FTPAddressIP,FTP_UserName=:FTPUserName,FTP_PassWord=:FTPPassWord,FTP_Port=:FTPPort,FTP_Hosp_Dr=:FTPHospDr Where FTP_RowID =:FTPRowID)
	q SQLCODE
}

/// Creator：      wangxuejian
/// CreatDate：    2020-03-17
/// Description：  删除FTP地址表
/// Table：        DHC_AdvFTPConfig
/// Input：		   FTPRowID
/// Output：       0:成功 ,其他:失败
/// Others：       w ##Class(web.DHCADVFTPConfig).DeleteFTPConfig()
ClassMethod DeleteFTPConfig(FTPRowID As %String) As %String
{
	n (FTPRowID)
	&sql(delete from DHC_AdvFTPConfig where FTP_RowID=:FTPRowID)
	q SQLCODE
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	n (pid)
	k ^TMP("DHCADV","web.DHCADVFTPConfig","QueryFTPConfig",pid)
}

}
