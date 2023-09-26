Import SQLUSER

Class web.DHCAPPTreMet Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：      sufan
/// CreatDate：    2018-01-04
/// Description：  保存病理治疗方法典表
/// Table：        User.DHCAppTreMet
/// Input：		   治疗方法表ID^治疗方法代码^治疗方法描述^医院ID^是否可用标识
/// Output：       0:成功 ,其他:失败
/// Others：       w ##Class(web.DHCAPPTreMet).SaveTreMet("^22^22^65^Y^dsds")
ClassMethod SaveTreMet(params As %String) As %String
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
	..s Err=..UpdateTreMet(ListData)  /// 更新
	.e  d
	..s Err=..InsertTreMet(ListData)  /// 插入
	i Err'=0 tro
	q:Err'=0 Err
	TC
	q Err
}

/// Creator：      sufan
/// CreatDate：    2018-01-04
/// Description：  保存病理治疗方法典表
/// Table：        User.DHCAppTreMet
/// Input：		   治疗方法表ID^治疗方法代码^治疗方法描述^医院ID^是否可用标识
/// Output：       0:成功 ,其他:失败
/// Others：       w ##Class(web.DHCAPPTreMet).InsertTreMet("^33^33^65^Y")
ClassMethod InsertTreMet(ListData As %String) As %String
{
	n (ListData)
	s ATCode=$p(ListData,"^",2)     	/// 治疗方法代码
	s ATDesc=$p(ListData,"^",3)	 		/// 治疗方法描述
	s ATHospID=$p(ListData,"^",4)   	/// 医院ID
	s ATFlag=$p(ListData,"^",5)	 		/// 可用标识
	&SQL(Insert into DHC_AppTreMet (AT_Code,AT_Desc,AT_Hosp_Dr,AT_ActiveFlag) values 
	(:ATCode,:ATDesc,:ATHospID,:ATFlag))
	q SQLCODE
}

/// Creator：      sufan
/// CreatDate：    2018-01-04
/// Description：  保存病理治疗方法典表
/// Table：        User.DHCAppTreMet
/// Input：		   治疗方法表ID^治疗方法代码^治疗方法描述^医院ID^是否可用标识
/// Output：       0:成功 ,其他:失败
/// Others：       w ##Class(web.DHCAPPTreMet).UpdateTreMet()
ClassMethod UpdateTreMet(ListData As %String) As %String
{
	n (ListData)
	s ATRowID=$p(ListData,"^",1)		/// 治疗方法表ID
	s ATCode=$p(ListData,"^",2)			/// 治疗方法代码
	s ATDesc=$p(ListData,"^",3)			/// 治疗方法描述
	s ATHospID=$p(ListData,"^",4)		/// 医院ID
	s ATFlag=$p(ListData,"^",5)			/// 可用标识
	&SQL(Update DHC_AppTreMet Set AT_Code=:ATCode,AT_Desc=:ATDesc,AT_Hosp_Dr=:ATHospID,AT_ActiveFlag=:ATFlag Where AT_RowID =:ATRowID)
	q SQLCODE
}

/// Creator：      sufan
/// CreatDate：    2018-01-04
/// Description：  删除病理治疗方法典表
/// Table：        User.DHCAppTreMet
/// Input：		   治疗方法表ID
/// Output：       0:成功 ,其他:失败
/// Others：       w ##Class(web.DHCAPPTreMet).DeleteTreMet()
ClassMethod DeleteTreMet(ATRowID As %String) As %String
{
	n (ATRowID)
	&sql(delete from DHC_AppTreMet where AT_RowID=:ATRowID)
	q SQLCODE
}

/// Creator：  sufan
/// CreatDate: 2017-07-06
/// Descript:  检查代码、描述是否重复
/// Table：    User.DHCAppTreMet
/// Others：   w ##class(web.DHCAPPTreMet).CheckRepeat("^11^11^65^Y")
ClassMethod CheckRepeat(ItmTempStr As %String) As %String
{
	n (ItmTempStr)
	s ret=0
	s ID=$p(ItmTempStr,"^",1)   	 ///ID
	s ATCode=$p(ItmTempStr,"^",2)  	 ///代码
	s ATDesc=$p(ItmTempStr,"^",3) 	 ///描述
	s HospID=$p(ItmTempStr,"^",4)	 ///医院ID
	/// 新记录
	if ID=""  d
	.i $d(^DHCAPPTM(0,"Code",$$ALPHAUP^SSUTIL4((ATCode))))   d
	..s ATID=""
	..for  s ATID=$o(^DHCAPPTM(0,"Code",$$ALPHAUP^SSUTIL4(ATCode),ATID)) q:(ATID="")||(ret'=0)  d
	...s HospDr=$p(^DHCAPPTM(ATID),"^",3)
	...q:HospDr'=HospID
	...s ret=-1
	..
	.
	.i $d(^DHCAPPTM(0,"Desc",$$ALPHAUP^SSUTIL4(ATDesc)))  d
	..s ATID=""
	..f  s ATID=$o(^DHCAPPTM(0,"Desc",$$ALPHAUP^SSUTIL4(ATDesc),ATID))  q:(ATID="")||(ret'=0)  d
	...s HospDr=$p(^DHCAPPTM(ATID),"^",3)
	...q:HospDr'=HospID
	...s ret=-2
	..
	.
	/// 修改记录
	else  d
	.s Code=$p($g(^DHCAPPTM(ID)),"^",1)    //代码
	.s Desc=$p($g(^DHCAPPTM(ID)),"^",2)    //描述
	.i (Code'=ATCode)&($d(^DHCAPPTM(0,"Code",$$ALPHAUP^SSUTIL4(ATCode))))  d
	..s ATID=""
	..f  s ATID=$o(^DHCAPPTM(0,"Code",$$ALPHAUP^SSUTIL4(ATCode),ATID)) q:(ATID="")||(ret'=0)  d
	...s HospDr=$p(^DHCAPPTM(ATID),"^",3)
	...q:HospDr'=HospID
	...s ret=-3
	..
	.
	.i (Desc'=ATDesc)&($d(^DHCAPPTM(0,"Desc",$$ALPHAUP^SSUTIL4(ATDesc))))  d
	..s ATID=""
	..f  s ATID=$o(^DHCAPPTM(0,"Desc",$$ALPHAUP^SSUTIL4(ATDesc),ATID)) q:(ATID="")||(ret'=0)  d
	...s HospDr=$p(^DHCAPPTM(ATID),"^",3)
	...q:HospDr'=HospID
	...s ret=-4
	..
	.
	q ret
}

/// Creator：      sufan
/// CreatDate：    2017-07-06
/// Description：  查询病理治疗方法典表
/// Table：        User.DHCAppTreMet
/// Input：		   params:"代码^描述",HospID:医院ID
/// Output：       病理检测方法典表信息
/// Others：       w ##Class(web.DHCAPPTreMet).QueryTreMet(10,1,"","65")
ClassMethod QueryTreMet(rows As %String, page As %String, params As %String, HospID As %String) As %String
{
	n (rows,page,params,HospID)
	s End=page*rows
	s Start=(page-1)*rows+1
	s pid=##Class(web.DHCAPPExaRepCom).NewPid()	
	d ..killTmpGlobal(pid)     // k掉临时global
	s Code=$p(params,"^",1)    // 在串params中取值
	s Desc=$p(params,"^",2)
	s h=0,count=0
	s ATRowID=""
	for  s ATRowID=$o(^DHCAPPTM(ATRowID)) q:ATRowID=""  d  // 查询表User.DHCAppTreMet
	.q:ATRowID=0
	.s ATCode=$p(^DHCAPPTM(ATRowID),"^",1)      			// 治疗方法代码
	.s ATDesc=$p(^DHCAPPTM(ATRowID),"^",2)	  				// 治疗方法描述
	.s HospDr=+$p(^DHCAPPTM(ATRowID),"^",3)	  				// 医院ID
	.s HospDesc=""
	.s:HospDr'=0 HospDesc=$p(^CT("HOSP",HospDr),"^",2)		// 医院描述
	.s ATFlag=$p(^DHCAPPTM(ATRowID),"^",4)					// 是否可用标识
	.s FlagCode=ATFlag
	.s ATFlag=$s(ATFlag="Y":"是",ATFlag="N":"否",1:"")
	.q:(Code'="")&(ATCode'[Code)							// 代码过滤
	.q:(Desc'="")&(ATDesc'[Desc)							// 描述过滤
	.;q:HospID'=HospDr										// 医院过滤
	.s h=h+1
	.s tempstr=ATRowID_"^"_ATCode_"^"_ATDesc_"^"_HospDr_"^"_HospDesc_"^"_ATFlag_"^"_FlagCode
	.s ^TMP("DHCAPP","web.DHCAPPTreMet","QueryTreMet",pid,h)=tempstr     // 数据存储
	
	q:h=0 ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) 	// 输出json结尾符
	///转换数据为Json格式
	s title="ATRowID^ATCode^ATDesc^HospDr^HospDesc^ATFlag^FlagCode" // 列title 
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(h) 		//  输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCAPP","web.DHCAPPTreMet","QueryTreMet",pid,index)) q:index=""  d
	.s mdate=$g(^TMP("DHCAPP","web.DHCAPPTreMet","QueryTreMet",pid,index))
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
	k ^TMP("DHCAPP","web.DHCAPPTreMet","QueryTreMet",pid)
}

}
