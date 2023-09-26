Import SQLUSER

Class web.DHCPHFTPConfig Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：      sufan
/// CreatDate：    2017-08-21
/// Description：  保存病理检测项目套餐字典表
/// Table：        DHC_PHFTPConfig
/// Input：		   FTPRowID^FTPCode^FTPDesc^FTPAddressIP^FTPUserName^FTPPassWord^FTPPort
/// Output：       0:成功 ,其他:失败
/// Others：       w ##Class(web.DHCPHFTPConfig).SaveFTPConfig("^1^1^65^Y^1")
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

/// Creator：      sufan
/// CreatDate：    2017-08-21
/// Description：  保存FTP地址表
/// Table：        DHC_PHFTPConfig
/// Input：		   FTPRowID^FTPCode^FTPDesc^FTPAddressIP^FTPUserName^FTPPassWord^FTPPort
/// Output：       0:成功 ,其他:失败
/// Others：       w ##Class(web.DHCPHFTPConfig).InsertFTPConfig()
ClassMethod InsertFTPConfig(ListData As %String) As %String
{
	n (ListData)
	s FTPCode=$p(ListData,"^",2)     	/// FTP代码
	s FTPDesc=$p(ListData,"^",3)	 	/// FTP描述
	s FTPAddressIP=$p(ListData,"^",4)   /// FTP地址
	s FTPUserName=$p(ListData,"^",5)	/// 用户名
	s FTPPassWord=$p(ListData,"^",6)    /// 密码
	s FTPPort=$p(ListData,"^",7)        /// 端口
	&SQL(Insert into DHC_PHFTPConfig (FTP_Code,FTP_Desc,FTP_AddressIP,FTP_UserName,FTP_PassWord,FTP_Port) values 
	(:FTPCode,:FTPDesc,:FTPAddressIP,:FTPUserName,:FTPPassWord,:FTPPort))
	q SQLCODE
}

/// Creator：      sufan
/// CreatDate：    2017-08-21
/// Description：  更新FTP地址表
/// Table：        DHC_PHFTPConfig
/// Input：		   FTPRowID^FTPCode^FTPDesc^FTPAddressIP^FTPUserName^FTPPassWord^FTPPort
/// Output：       0:成功 ,其他:失败
/// Others：       w ##Class(web.DHCPHFTPConfig).UpdateFTPConfig()
ClassMethod UpdateFTPConfig(ListData As %String) As %String
{
	n (ListData)
	s FTPRowID=$p(ListData,"^",1)		/// FTP表ID
	s FTPCode=$p(ListData,"^",2)     	/// FTP代码
	s FTPDesc=$p(ListData,"^",3)	 	/// FTP描述
	s FTPAddressIP=$p(ListData,"^",4)   /// FTP地址
	s FTPUserName=$p(ListData,"^",5)	/// 用户名
	s FTPPassWord=$p(ListData,"^",6)    /// 密码
	s FTPPort=$p(ListData,"^",7)    	/// 端口
	&SQL(Update DHC_PHFTPConfig Set FTP_Code=:FTPCode,FTP_Desc=:FTPDesc,FTP_AddressIP=:FTPAddressIP,FTP_UserName=:FTPUserName,FTP_PassWord=:FTPPassWord,FTP_Port=:FTPPort Where FTP_RowID =:FTPRowID)
	q SQLCODE
}

/// Creator：      sufan
/// CreatDate：    2017-08-21
/// Description：  删除FTP地址表
/// Table：        DHC_PHFTPConfig
/// Input：		   FTPRowID
/// Output：       0:成功 ,其他:失败
/// Others：       w ##Class(web.DHCPHFTPConfig).DeleteTestPack()
ClassMethod DeleteFTPConfig(FTPRowID As %String) As %String
{
	n (FTPRowID)
	&sql(delete from DHC_PHFTPConfig where FTP_RowID=:FTPRowID)
	q SQLCODE
}

/// Creator：  sufan
/// CreatDate: 2017-07-06
/// Descript:  检查代码、描述是否重复
/// Table：    User.DHCPHFTPConfig
/// Others：   w ##class(web.DHCPHFTPConfig).CheckRepeat("^1^1^4^4^1")
ClassMethod CheckRepeat(ItmTempStr As %String) As %String
{
	n (ItmTempStr)
	s ret=0
	s ID=$p(ItmTempStr,"^",1)   	///ID
	s FTPCode=$p(ItmTempStr,"^",2)  ///代码
	s FTPDesc=$p(ItmTempStr,"^",3)  ///描述
	/// 新记录
	if ID=""  d
	.i $d(^DHCPHFTPC(0,"Code",$$ALPHAUP^SSUTIL4((FTPCode))))   d
	..s ret=-1
	/// 修改记录
	else  d
	.s Code=$p($g(^DHCPHFTPC(ID)),"^",1)    //代码
	.i (Code'=FTPCode)&($d(^DHCPHFTPC(0,"Code",$$ALPHAUP^SSUTIL4(FTPCode))))  d
	..s ret=-2
	q ret
}

/// Creator：      sufan
/// CreatDate：    2017-08-21
/// Description：  查询FTP地址表
/// Table：        User.DHCPHFTPConfig
/// Input：		   params:"FTP代码^FTP描述"
/// Output：       FTP地址维护信息
/// Others：       w ##Class(web.DHCPHFTPConfig).QueryFTPConfig(10,1,"")
ClassMethod QueryFTPConfig(rows As %String, page As %String, params As %String) As %String
{
	n (rows,page,params,HospID)
	s End=page*rows
	s Start=(page-1)*rows+1
	s pid=..NewPid()	
	d ..killTmpGlobal(pid)     // k掉临时global
	s Code=$p(params,"^",1)    // 在串params中取值
	s Desc=$p(params,"^",2)
	s h=0,count=0
	s FTPRowID=""
	for  s FTPRowID=$o(^DHCPHFTPC(FTPRowID)) q:FTPRowID=""  d  // 查询表DHC_PHFTPConfig
	.q:FTPRowID=0
	.s FTPCode=$p(^DHCPHFTPC(FTPRowID),"^",1)      		// FTP代码
	.s FTPDesc=$p(^DHCPHFTPC(FTPRowID),"^",2)	  		// FTP描述
	.s FTPAddressIP=$p(^DHCPHFTPC(FTPRowID),"^",3)	  	// FTP地址
	.s FTPUserName=$p(^DHCPHFTPC(FTPRowID),"^",4)		// 用户名
	.s FTPPassWord=$p(^DHCPHFTPC(FTPRowID),"^",5)		// 密码
	.s FTPPort=$p(^DHCPHFTPC(FTPRowID),"^",6)		    // 端口
	.q:(Code'="")&(FTPCode'[Code)						// 代码过滤
	.q:(Desc'="")&(FTPDesc'[Desc)						// 描述过滤
	.s h=h+1
	.s tempstr=FTPRowID_"^"_FTPCode_"^"_FTPDesc_"^"_FTPAddressIP_"^"_FTPUserName_"^"_FTPPassWord_"^"_FTPPort
	.s ^TMP("DHCST","web.DHCPHFTPConfig","QueryFTPConfig",pid,h)=tempstr     // 数据存储
	
	q:h=0 ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(h) 	// 输出json结尾符
	
	///转换数据为Json格式
	s title="FTPRowID^FTPCode^FTPDesc^FTPAddressIP^FTPUserName^FTPPassWord^FTPPort" // 列title 
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(h) 		//  输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCPHFTPConfig","QueryFTPConfig",pid,index)) q:index=""  d
	.s mdate=$g(^TMP("DHCST","web.DHCPHFTPConfig","QueryFTPConfig",pid,index))
	.s count = count+1
	.q:(count<Start)||(count>End)
	.i count=Start d
	..w ##class(web.DHCSTPHCMCOMMON).getJsonData(title,mdate)
	.e  d
	..w ","_##class(web.DHCSTPHCMCOMMON).getJsonData(title,mdate)
	w ##class(web.DHCSTPHCMCOMMON).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	n (pid)
	k ^TMP("DHCST","web.DHCPHFTPConfig","QueryFTPConfig",pid)
}

/// Descript:计数器
ClassMethod NewPid() As %String
{
	Q $I(^TMP("DHCST"))
}

}
