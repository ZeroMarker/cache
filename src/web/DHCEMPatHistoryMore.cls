Import SQLUSER

Class web.DHCEMPatHistoryMore Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：      sufan
/// CreatDate：    2018-07-27
/// Description：  保存急诊毒性物质字典表
/// Table：        User.DHCEmPatHistoryMore
/// Input：		   表ID^代码^描述^医院ID^是否可用标识
/// Output：       0:成功 ,其他:失败
/// Others：       w ##Class(web.DHCEMPatHistoryMore).SavePatHisMore("^1^5^2^Y")
ClassMethod SavePatHisMore(params As %String) As %String
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
	..s Err=..UpdatePatHisMore(ListData)  /// 更新
	.e  d
	..s Err=..InsertPatHisMore(ListData)  /// 插入
	i Err'=0 tro
	q:Err'=0 Err
	TC
	q Err
}

/// Creator：      sufan
/// CreatDate：    2018-07-27
/// Description：  保存急诊毒性物质字典表
/// Table：        User.DHCEmPatHistoryMore
/// Input：		   表ID^代码^描述^医院ID^是否可用标识
/// Output：       0:成功 ,其他:失败
/// Others：       w ##Class(web.DHCEMPatHistoryMore).InsertPatHisMore("^1^1^2^Y")
ClassMethod InsertPatHisMore(ListData As %String) As %String
{
	n (ListData)
	s PHIMCode=$p(ListData,"^",2)     /// 状态代码
	s PHIMDesc=$p(ListData,"^",3)	  /// 状态描述
	s PHIMHospID=$p(ListData,"^",4)   /// 医院ID
	s PHIMFlag=$p(ListData,"^",5)	  /// 可用标识
	s PHIMType=$p(ListData,"^",6)	  /// 类型 hxy 2019-11-15
	&SQL(Insert into DHC_EmPatHistoryMore (PHIM_Code,PHIM_Desc,PHIM_ActiveFlag,PHIM_Hosp_Dr,PHIM_Type) values 
	(:PHIMCode,:PHIMDesc,:PHIMFlag,:PHIMHospID,:PHIMType))
	q SQLCODE
}

/// Creator：      sufan
/// CreatDate：    2018-07-27
/// Description：  保存急诊毒性物质字典表
/// Table：        User.DHCEmPatHistoryMore
/// Input：		   表ID^代码^描述^医院ID^是否可用标识
/// Output：       0:成功 ,其他:失败
/// Others：       w ##Class(web.DHCEMPatHistoryMore).UpdatePatHisMore()
ClassMethod UpdatePatHisMore(ListData As %String) As %String
{
	n (ListData)
	s PHIMRowID=$p(ListData,"^",1)		/// 状态表ID
	s PHIMCode=$p(ListData,"^",2)		/// 状态代码
	s PHIMDesc=$p(ListData,"^",3)		/// 状态描述
	s PHIMHospID=$p(ListData,"^",4)		/// 医院ID
	s PHIMFlag=$p(ListData,"^",5)		/// 可用标识
	s PHIMType=$p(ListData,"^",6)	  /// 类型 hxy 2019-11-15
	&SQL(Update DHC_EmPatHistoryMore Set PHIM_Code=:PHIMCode,PHIM_Desc=:PHIMDesc,PHIM_Hosp_Dr=:PHIMHospID,PHIM_ActiveFlag=:PHIMFlag,PHIM_Type=:PHIMType Where PHIM_RowId =:PHIMRowID)
	q SQLCODE
}

/// Creator：      sufan
/// CreatDate：    2018-07-27
/// Description：  保存急诊毒性物质字典表
/// Table：        User.DHCEmPatHistoryMore
/// Input：		   表ID
/// Output：       0:成功 ,其他:失败
/// Others：       w ##Class(web.DHCEMPatHistoryMore).DeletePatHisMore()
ClassMethod DeletePatHisMore(PHIMRowID As %String) As %String
{
	n (PHIMRowID)
	&sql(delete from DHC_EmPatHistoryMore where PHIM_RowId=:PHIMRowID)
	q SQLCODE
}

/// Creator：  sufan
/// CreatDate: 2018-07-27
/// Descript:  检查代码、描述是否重复
/// Table：    User.DHCEmPatHistoryMore
/// Others：   w ##class(web.DHCEMPatHistoryMore).CheckRepeat("^1^5^2^Y")
ClassMethod CheckRepeat(ItmTempStr As %String) As %String
{
	n (ItmTempStr)
	s ret=0
	s ID=$p(ItmTempStr,"^",1)   	///ID
	s PHIMCode=$p(ItmTempStr,"^",2)  ///代码
	s PHIMDesc=$p(ItmTempStr,"^",3)  ///描述
	s HospID=$p(ItmTempStr,"^",4)	///医院ID
	/// 新记录
	if ID=""  d
	.i $d(^DHCEMPHIM(0,"Code",$$ALPHAUP^SSUTIL4((PHIMCode))))   d
	..s PHIMID=""
	..for  s PHIMID=$o(^DHCEMPHIM(0,"Code",$$ALPHAUP^SSUTIL4(PHIMCode),PHIMID)) q:(PHIMID="")||(ret'=0)  d
	...s HospDr=$p(^DHCEMPHIM(PHIMID),"^",4)
	...;q:HospDr'=HospID //hxy 2023-02-01注释 私有数据医院组间代码不能重复
	...s ret=-1
	..
	.
	.i $d(^DHCEMPHIM(0,"Desc",$$ALPHAUP^SSUTIL4(PHIMDesc)))  d
	..s PHIMID=""
	..f  s PHIMID=$o(^DHCEMPHIM(0,"Desc",$$ALPHAUP^SSUTIL4(PHIMDesc),PHIMID))  q:(PHIMID="")||(ret'=0)  d
	...s HospDr=$p(^DHCEMPHIM(PHIMID),"^",4)
	...q:HospDr'=HospID
	...s ret=-2
	..
	.
	/// 修改记录
	else  d
	.s Code=$p($g(^DHCEMPHIM(ID)),"^",1)    //代码
	.s Desc=$p($g(^DHCEMPHIM(ID)),"^",2)    //描述
	.i (Code'=PHIMCode)&($d(^DHCEMPHIM(0,"Code",$$ALPHAUP^SSUTIL4(PHIMCode))))  d
	..s PHIMID=""
	..f  s PHIMID=$o(^DHCEMPHIM(0,"Code",$$ALPHAUP^SSUTIL4(PHIMCode),PHIMID)) q:(PHIMID="")||(ret'=0)  d
	...s HospDr=$p(^DHCEMPHIM(PHIMID),"^",4)
	...;q:HospDr'=HospID //hxy 2023-02-01注释 私有数据医院组间代码不能重复
	...s ret=-3
	..
	.
	.i (Desc'=PHIMDesc)&($d(^DHCEMPHIM(0,"Desc",$$ALPHAUP^SSUTIL4(PHIMDesc))))  d
	..s PHIMID=""
	..f  s PHIMID=$o(^DHCEMPHIM(0,"Desc",$$ALPHAUP^SSUTIL4(PHIMDesc),PHIMID)) q:(PHIMID="")||(ret'=0)  d
	...s HospDr=$p(^DHCEMPHIM(PHIMID),"^",4)
	...q:HospDr'=HospID
	...s ret=-4
	..
	.
	q ret
}

/// Creator：      sufan
/// CreatDate：    2017-07-06
/// Description：  查询急诊毒性物质字典表
/// Table：        User.DHCEmPatHistoryMore
/// Input：		   params:"代码^描述",HospID:医院ID
/// Output：       毒性物质数据
/// Others：       w ##Class(web.DHCEMPatHistoryMore).QueryPatHisMore(10,1,"","2")
ClassMethod QueryPatHisMore(rows As %String, page As %String, params As %String) As %String
{
	n (rows,page,params)
	s End=page*rows
	s Start=(page-1)*rows+1
	s pid=##Class(web.DHCAPPExaRepCom).NewPid()	
	d ..killTmpGlobal(pid)     // k掉临时global
	s Code=$p(params,"^",1)    // 在串params中取值
	s Desc=$p(params,"^",2)
	s InHospID=$p(params,"^",3)
	s h=0,count=0
	s PHIMRowID=""
	for  s PHIMRowID=$o(^DHCEMPHIM(PHIMRowID)) q:PHIMRowID=""  d  // 查询表DHC_AppTestStatus
	.q:PHIMRowID=0
	.s PHIMICode=$p(^DHCEMPHIM(PHIMRowID),"^",1)      		// 状态代码
	.s PHIMIDesc=$p(^DHCEMPHIM(PHIMRowID),"^",2)	  		// 状态描述
	.s HospDr=+$p(^DHCEMPHIM(PHIMRowID),"^",4)	  			// 医院ID
	.s HospDesc=""
	.s:HospDr'=0 HospDesc=$p(^CT("HOSP",HospDr),"^",2)		// 医院描述
	.s PHIMIFlag=$p(^DHCEMPHIM(PHIMRowID),"^",3)			// 是否可用标识
	.s FlagCode=PHIMIFlag
	.q:(Code'="")&(PHIMICode'[Code)							// 代码过滤
	.q:(Desc'="")&(PHIMIDesc'[Desc)							// 描述过滤
	.q:(InHospID'="")&&(InHospID'=HospDr)					// 医院过滤
	.s Type=$p(^DHCEMPHIM(PHIMRowID),"^",5) //hxy 2019-11-15 类型
	.s h=h+1
	.s tempstr=PHIMRowID_"^"_PHIMICode_"^"_PHIMIDesc_"^"_HospDr_"^"_HospDesc_"^"_PHIMIFlag_"^"_FlagCode_"^"_Type
	.s ^TMP("DHCEM","web.DHCEMPatHistoryMore","QueryPatHisMore",pid,h)=tempstr     // 数据存储
	
	q:h=0 ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) 	// 输出json结尾符
	
	///转换数据为Json格式
	s title="PHIMRowID^PHIMICode^PHIMIDesc^HospDr^HospDesc^PHIMIFlag^FlagCode^Type" // 列title 
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(h) 		//  输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCEM","web.DHCEMPatHistoryMore","QueryPatHisMore",pid,index)) q:index=""  d
	.s mdate=$g(^TMP("DHCEM","web.DHCEMPatHistoryMore","QueryPatHisMore",pid,index))
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

/// Creator：      qunianpeng
/// CreatDate：    2018-09-17
/// Description：  通过医院id获取救治中心
/// Table：        User.DHCEmPatHistoryMore
/// Input：		   params:"代码^描述",HospID:医院ID
/// Output：       救治中心数据	
/// W ##Class(web.DHCEMPatHistoryMore).GetTreatCenter("2")
ClassMethod GetTreatCenter(HospID As %String) As %String
{
	n (HospID)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT PHIM_RowId ,PHIM_Desc FROM DHC_EmPatHistoryMore Where"
	s:+HospID'=0 sqlStr = sqlStr_"  PHIM_Hosp_Dr='"_HospID_"'  And"
	s sqlStr = sqlStr_"  PHIM_ActiveFlag='Y'"
    d result.Prepare(sqlStr)
	d result.Execute()
	s ListTitle="ID^Desc"
	s count = 0
	w "["
	While(result.Next())
	{	
		s PatSpecID = result.Data("PHIM_RowId")
		s PatSpecDesc = result.Data("PHIM_Desc")
		s ListData=PatSpecID_"^"_PatSpecDesc
		s count = count+1
		I count=1 d
		.w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
		e  d
		.W ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	}
	w "]"
	q ""
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	n (pid)
	k ^TMP("DHCEM","web.DHCEMPatHistoryMore","QueryTestStatus",pid)
}

}
