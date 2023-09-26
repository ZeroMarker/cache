Import SQLUSER

Class web.DHCAPPPatRec Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：      sufan
/// CreatDate：    2018-01-04
/// Description：  保存病理病人病例字典表
/// Table：        User.DHCAppPatRec
/// Input：		   病例表ID^病例代码^病例描述^医院ID^是否可用标识
/// Output：       0:成功 ,其他:失败
/// Others：       w ##Class(web.DHCAPPPatRec).SavePatRec("^22^22^65^Y^dsds")
ClassMethod SavePatRec(params As %String) As %String
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
	..s Err=..UpdatePatRec(ListData)  /// 更新
	.e  d
	..s Err=..InsertPatRec(ListData)  /// 插入
	i Err'=0 tro
	q:Err'=0 Err
	TC
	q Err
}

/// Creator：      sufan
/// CreatDate：    2018-01-04
/// Description：  保存病理病人病例字典表
/// Table：        User.DHCAppPatRec
/// Input：		   病例表ID^病例代码^病例描述^医院ID^是否可用标识
/// Output：       0:成功 ,其他:失败
/// Others：       w ##Class(web.DHCAPPPatRec).InsertPatRec("^33^33^65^Y")
ClassMethod InsertPatRec(ListData As %String) As %String
{
	n (ListData)
	s APCode=$p(ListData,"^",2)     	/// 病例代码
	s APDesc=$p(ListData,"^",3)	 		/// 病例描述
	s APHospID=$p(ListData,"^",4)   	/// 医院ID
	s APFlag=$p(ListData,"^",5)	 		/// 可用标识
	&SQL(Insert into DHC_AppPatRec (AP_Code,AP_Desc,AP_Hosp_Dr,AP_ActiveFlag) values 
	(:APCode,:APDesc,:APHospID,:APFlag))
	q SQLCODE
}

/// Creator：      sufan
/// CreatDate：    2018-01-04
/// Description：  保存病理病人病例字典表
/// Table：        User.DHCAppPatRec
/// Input：		   病例表ID^病例代码^病例描述^医院ID^是否可用标识
/// Output：       0:成功 ,其他:失败
/// Others：       w ##Class(web.DHCAPPPatRec).UpdatePatRec()
ClassMethod UpdatePatRec(ListData As %String) As %String
{
	n (ListData)
	s APRowID=$p(ListData,"^",1)		/// 病例表ID
	s APCode=$p(ListData,"^",2)			/// 病例代码
	s APDesc=$p(ListData,"^",3)			/// 病例描述
	s APHospID=$p(ListData,"^",4)		/// 医院ID
	s APFlag=$p(ListData,"^",5)			/// 可用标识
	&SQL(Update DHC_AppPatRec Set AP_Code=:APCode,AP_Desc=:APDesc,AP_Hosp_Dr=:APHospID,AP_ActiveFlag=:APFlag Where AP_RowID =:APRowID)
	q SQLCODE
}

/// Creator：      sufan
/// CreatDate：    2018-01-04
/// Description：  删除病理病人病例字典表
/// Table：        User.DHCAppPatRec
/// Input：		   病例表ID
/// Output：       0:成功 ,其他:失败
/// Others：       w ##Class(web.DHCAPPPatRec).DeletePatRec()
ClassMethod DeletePatRec(APRowID As %String) As %String
{
	n (APRowID)
	&sql(delete from DHC_AppPatRec where AP_RowID=:APRowID)
	q SQLCODE
}

/// Creator：  sufan
/// CreatDate: 2017-07-06
/// Descript:  检查代码、描述是否重复
/// Table：    User.DHCAppPatRec
/// Others：   w ##class(web.DHCAPPPatRec).CheckRepeat("^11^11^65^Y")
ClassMethod CheckRepeat(ItmTempStr As %String) As %String
{
	n (ItmTempStr)
	s ret=0
	s ID=$p(ItmTempStr,"^",1)   	 ///ID
	s APCode=$p(ItmTempStr,"^",2)  	 ///代码
	s APDesc=$p(ItmTempStr,"^",3) 	 ///描述
	s HospID=$p(ItmTempStr,"^",4)	 ///医院ID
	/// 新记录
	if ID=""  d
	.i $d(^DHCAPPPR(0,"Code",$$ALPHAUP^SSUTIL4((APCode))))   d
	..s APID=""
	..for  s APID=$o(^DHCAPPPR(0,"Code",$$ALPHAUP^SSUTIL4(APCode),APID)) q:(APID="")||(ret'=0)  d
	...s HospDr=$p(^DHCAPPPR(APID),"^",3)
	...q:HospDr'=HospID
	...s ret=-1
	..
	.
	.i $d(^DHCAPPPR(0,"Desc",$$ALPHAUP^SSUTIL4(APDesc)))  d
	..s APID=""
	..f  s APID=$o(^DHCAPPPR(0,"Desc",$$ALPHAUP^SSUTIL4(APDesc),APID))  q:(APID="")||(ret'=0)  d
	...s HospDr=$p(^DHCAPPPR(APID),"^",3)
	...q:HospDr'=HospID
	...s ret=-2
	..
	.
	/// 修改记录
	else  d
	.s Code=$p($g(^DHCAPPPR(ID)),"^",1)    //代码
	.s Desc=$p($g(^DHCAPPPR(ID)),"^",2)    //描述
	.i (Code'=APCode)&($d(^DHCAPPPR(0,"Code",$$ALPHAUP^SSUTIL4(APCode))))  d
	..s APID=""
	..f  s APID=$o(^DHCAPPPR(0,"Code",$$ALPHAUP^SSUTIL4(APCode),APID)) q:(APID="")||(ret'=0)  d
	...s HospDr=$p(^DHCAPPPR(APID),"^",3)
	...q:HospDr'=HospID
	...s ret=-3
	..
	.
	.i (Desc'=APDesc)&($d(^DHCAPPPR(0,"Desc",$$ALPHAUP^SSUTIL4(APDesc))))  d
	..s APID=""
	..f  s APID=$o(^DHCAPPPR(0,"Desc",$$ALPHAUP^SSUTIL4(APDesc),APID)) q:(APID="")||(ret'=0)  d
	...s HospDr=$p(^DHCAPPPR(APID),"^",3)
	...q:HospDr'=HospID
	...s ret=-4
	..
	.
	q ret
}

/// Creator：      sufan
/// CreatDate：    2017-07-06
/// Description：  查询病理病人病例字典表
/// Table：        User.DHCAppPatRec
/// Input：		   params:"代码^描述",HospID:医院ID
/// Output：       病人病例字典表信息
/// Others：       w ##Class(web.DHCAPPPatRec).QueryPatRec(10,1,"","65")
ClassMethod QueryPatRec(rows As %String, page As %String, params As %String, HospID As %String) As %String
{
	n (rows,page,params,HospID)
	s End=page*rows
	s Start=(page-1)*rows+1
	s pid=##Class(web.DHCAPPExaRepCom).NewPid()	
	d ..killTmpGlobal(pid)     // k掉临时global
	s Code=$p(params,"^",1)    // 在串params中取值
	s Desc=$p(params,"^",2)
	s h=0,count=0
	s APRowID=""
	for  s APRowID=$o(^DHCAPPPR(APRowID)) q:APRowID=""  d  // 查询表User.DHCAppTreMet
	.q:APRowID=0
	.s APCode=$p(^DHCAPPPR(APRowID),"^",1)      			// 病例代码
	.s APDesc=$p(^DHCAPPPR(APRowID),"^",2)	  				// 病例描述
	.s HospDr=+$p(^DHCAPPPR(APRowID),"^",3)	  				// 医院ID
	.s HospDesc=""
	.s:HospDr'=0 HospDesc=$p(^CT("HOSP",HospDr),"^",2)		// 医院描述
	.s APFlag=$p(^DHCAPPPR(APRowID),"^",4)					// 是否可用标识
	.s FlagCode=APFlag
	.s APFlag=$s(APFlag="Y":"是",APFlag="N":"否",1:"")
	.q:(Code'="")&(APCode'[Code)							// 代码过滤
	.q:(Desc'="")&(APDesc'[Desc)							// 描述过滤
	.;q:HospID'=HospDr										// 医院过滤
	.s h=h+1
	.s tempstr=APRowID_"^"_APCode_"^"_APDesc_"^"_HospDr_"^"_HospDesc_"^"_APFlag_"^"_FlagCode
	.s ^TMP("DHCAPP","web.DHCAPPPatRec","QueryPatRec",pid,h)=tempstr     // 数据存储
	
	q:h=0 ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) 	// 输出json结尾符
	///转换数据为Json格式
	s title="APRowID^APCode^APDesc^HospDr^HospDesc^APFlag^FlagCode" // 列title 
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(h) 		//  输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCAPP","web.DHCAPPPatRec","QueryPatRec",pid,index)) q:index=""  d
	.s mdate=$g(^TMP("DHCAPP","web.DHCAPPPatRec","QueryPatRec",pid,index))
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
	k ^TMP("DHCAPP","web.DHCAPPPatRec","QueryPatRec",pid)
}

}
