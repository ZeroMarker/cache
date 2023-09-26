Import SQLUSER

Class web.DHCAPPTestStatus Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：      sufan
/// CreatDate：    2017-07-06
/// Description：  保存病理申请状态字典表
/// Table：        DHC_AppTestStatus
/// Input：		   状态表ID^状态代码^状态描述^医院ID^是否可用标识^状态说明
/// Output：       0:成功 ,其他:失败
/// Others：       w ##Class(web.DHCAPPTestStatus).SaveTestStatus("^22^22^65^Y^dsds")
ClassMethod SaveTestStatus(params As %String) As %String
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
	..s Err=..UpdateTestStatus(ListData)  /// 更新
	.e  d
	..s Err=..InsertTestStatus(ListData)  /// 插入
	i Err'=0 tro
	q:Err'=0 Err
	TC
	q Err
}

/// Creator：      sufan
/// CreatDate：    2017-07-06
/// Description：  保存病理申请状态字典表
/// Table：        DHC_AppTestStatus
/// Input：		   状态表ID^状态代码^状态描述^医院ID^是否可用标识^状态说明
/// Output：       0:成功 ,其他:失败
/// Others：       w ##Class(web.DHCAPPTestStatus).InsertTestStatus("^33^33^65^Y^dsdfsdfs")
ClassMethod InsertTestStatus(ListData As %String) As %String
{
	n (ListData)
	s APSCode=$p(ListData,"^",2)     /// 状态代码
	s APSDesc=$p(ListData,"^",3)	 /// 状态描述
	s APSHospID=$p(ListData,"^",4)   /// 医院ID
	s APSFlag=$p(ListData,"^",5)	 /// 可用标识
	s APSNotes=$p(ListData,"^",6)    /// 状态说明
	&SQL(Insert into DHC_AppTestStatus (APS_Code,APS_Desc,APS_Hosp_Dr,APS_ActiveFlag,APS_Notes) values 
	(:APSCode,:APSDesc,:APSHospID,:APSFlag,:APSNotes))
	q SQLCODE
}

/// Creator：      sufan
/// CreatDate：    2017-07-06
/// Description：  更新病理申请状态字典表
/// Table：        DHC_AppTestStatus
/// Input：		   状态表ID^状态代码^状态描述^医院ID^是否可用标识^状态说明
/// Output：       0:成功 ,其他:失败
/// Others：       w ##Class(web.DHCAPPTestStatus).UpdateTestStatus()
ClassMethod UpdateTestStatus(ListData As %String) As %String
{
	n (ListData)
	s APSRowID=$p(ListData,"^",1)		/// 状态表ID
	s APSCode=$p(ListData,"^",2)		/// 状态代码
	s APSDesc=$p(ListData,"^",3)		/// 状态描述
	s APSHospID=$p(ListData,"^",4)		/// 医院ID
	s APSFlag=$p(ListData,"^",5)		/// 可用标识
	s APSNotes=$p(ListData,"^",6)		/// 状态说明
	&SQL(Update DHC_AppTestStatus Set APS_Code=:APSCode,APS_Desc=:APSDesc,APS_Hosp_Dr=:APSHospID,APS_ActiveFlag=:APSFlag,APS_Notes=:APSNotes Where APS_RowID =:APSRowID)
	q SQLCODE
}

/// Creator：      sufan
/// CreatDate：    2017-07-06
/// Description：  删除病理申请状态字典表
/// Table：        DHC_AppTestStatus
/// Input：		   状态表ID
/// Output：       0:成功 ,其他:失败
/// Others：       w ##Class(web.DHCAPPTestStatus).InsertTestPack()
ClassMethod DeleteTestStatus(APSRowID As %String) As %String
{
	n (APSRowID)
	&sql(delete from DHC_AppTestStatus where APS_RowID=:APSRowID)
	q SQLCODE
}

/// Creator：  sufan
/// CreatDate: 2017-07-06
/// Descript:  检查代码、描述是否重复
/// Table：    DHC_AppTestStatus
/// Others：   w ##class(web.DHCAPPTestStatus).CheckRepeat("^RGE^1^2^Y^dd")
ClassMethod CheckRepeat(ItmTempStr As %String) As %String
{
	n (ItmTempStr)
	s ret=0
	s ID=$p(ItmTempStr,"^",1)   	///ID
	s APSCode=$p(ItmTempStr,"^",2)  ///代码
	s APSDesc=$p(ItmTempStr,"^",3)  ///描述
	s HospID=$p(ItmTempStr,"^",4)	///医院ID
	/// 新记录
	if ID=""  d
	.i $d(^DHCAPPTST(0,"Code",$$ALPHAUP^SSUTIL4((APSCode))))   d
	..s APSID=""
	..for  s APSID=$o(^DHCAPPTST(0,"Code",$$ALPHAUP^SSUTIL4(APSCode),APSID)) q:(APSID="")||(ret'=0)  d
	...s HospDr=$p(^DHCAPPTST(APSID),"^",3)
	...q:HospDr'=HospID
	...s ret=-1
	..
	.
	.i $d(^DHCAPPTST(0,"Desc",$$ALPHAUP^SSUTIL4(APSDesc)))  d
	..s APSID=""
	..f  s APSID=$o(^DHCAPPTST(0,"Desc",$$ALPHAUP^SSUTIL4(APSDesc),APSID))  q:(APSID="")||(ret'=0)  d
	...s HospDr=$p(^DHCAPPTST(APSID),"^",3)
	...q:HospDr'=HospID
	...s ret=-2
	..
	.
	/// 修改记录
	else  d
	.s Code=$p($g(^DHCAPPTST(ID)),"^",1)    //代码
	.s Desc=$p($g(^DHCAPPTST(ID)),"^",2)    //描述
	.i (Code'=APSCode)&($d(^DHCAPPTST(0,"Code",$$ALPHAUP^SSUTIL4(APSCode))))  d
	..s APSID=""
	..f  s APSID=$o(^DHCAPPTST(0,"Code",$$ALPHAUP^SSUTIL4(APSCode),APSID)) q:(APSID="")||(ret'=0)  d
	...s HospDr=$p(^DHCAPPTST(APSID),"^",3)
	...q:HospDr'=HospID
	...s ret=-3
	..
	.
	.i (Desc'=APSDesc)&($d(^DHCAPPTST(0,"Desc",$$ALPHAUP^SSUTIL4(APSDesc))))  d
	..s APSID=""
	..f  s APSID=$o(^DHCAPPTST(0,"Desc",$$ALPHAUP^SSUTIL4(APSDesc),APSID)) q:(APSID="")||(ret'=0)  d
	...s HospDr=$p(^DHCAPPTST(APSID),"^",3)
	...q:HospDr'=HospID
	...s ret=-4
	..
	.
	q ret
}

/// Creator：      sufan
/// CreatDate：    2017-07-06
/// Description：  查询病理申请状态字典表
/// Table：        DHC_AppTestStatus
/// Input：		   params:"状态代码^状态描述",HospID:医院ID
/// Output：       病理检测项目套餐信息
/// Others：       w ##Class(web.DHCAPPTestStatus).QueryTestStatus(10,1,"","65")
ClassMethod QueryTestStatus(rows As %String, page As %String, params As %String, HospID As %String) As %String
{
	n (rows,page,params,HospID)
	s End=page*rows
	s Start=(page-1)*rows+1
	s pid=##Class(web.DHCAPPExaRepCom).NewPid()	
	d ..killTmpGlobal(pid)     // k掉临时global
	s Code=$p(params,"^",1)    // 在串params中取值
	s Desc=$p(params,"^",2)
	s h=0,count=0
	s APSRowID=""
	for  s APSRowID=$o(^DHCAPPTST(APSRowID)) q:APSRowID=""  d  // 查询表DHC_AppTestStatus
	.q:APSRowID=0
	.s APSCode=$p(^DHCAPPTST(APSRowID),"^",1)      		// 状态代码
	.s APSDesc=$p(^DHCAPPTST(APSRowID),"^",2)	  		// 状态描述
	.s HospDr=+$p(^DHCAPPTST(APSRowID),"^",3)	  		// 医院ID
	.s HospDesc=""
	.s:HospDr'=0 HospDesc=$p(^CT("HOSP",HospDr),"^",2)	// 医院描述
	.s APSFlag=$p(^DHCAPPTST(APSRowID),"^",4)			// 是否可用标识
	.s FlagCode=APSFlag
	.s APSFlag=$s(APSFlag="Y":"是",APSFlag="N":"否",1:"")
	.s APSNotes=$p(^DHCAPPTST(APSRowID),"^",5)			// 状态说明
	.q:(Code'="")&(APSCode'[Code)						// 代码过滤
	.q:(Desc'="")&(APSDesc'[Desc)						// 描述过滤
	.;q:HospID'=HospDr									// 医院过滤
	.s h=h+1
	.s tempstr=APSRowID_"^"_APSCode_"^"_APSDesc_"^"_HospDr_"^"_HospDesc_"^"_APSFlag_"^"_FlagCode_"^"_APSNotes
	.s ^TMP("DHCAPP","web.DHCAPPTestStatus","QueryTestStatus",pid,h)=tempstr     // 数据存储
	
	q:h=0 ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) 	// 输出json结尾符
	
	///转换数据为Json格式
	s title="APSRowID^APSCode^APSDesc^HospDr^HospDesc^APSFlag^FlagCode^APSNotes" // 列title 
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(h) 		//  输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCAPP","web.DHCAPPTestStatus","QueryTestStatus",pid,index)) q:index=""  d
	.s mdate=$g(^TMP("DHCAPP","web.DHCAPPTestStatus","QueryTestStatus",pid,index))
	.s count = count+1
	.q:(count<Start)||(count>End)
	.i count=Start d
	..w ##class(web.DHCAPPJsonCommon).getJsonData(title,mdate)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData(title,mdate)
	w ##class(web.DHCAPPJsonCommon).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	n (pid)
	k ^TMP("DHCAPP","web.DHCAPPTestStatus","QueryTestStatus",pid)
}

}
