Import SQLUSER

Class web.DHCAPPTestPack Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：      sufan
/// CreatDate：    2017-07-06
/// Description：  保存病理检测项目套餐字典表
/// Table：        DHC_AppTestPack
/// Input：		   套餐表ID^套餐代码^套餐描述^医院ID^是否可用标识^检查分类ID
/// Output：       0:成功 ,其他:失败
/// Others：       w ##Class(web.DHCAPPTestPack).SaveTestPack("^1^1^65^Y^1")
ClassMethod SaveTestPack(params As %String) As %String
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
	..s Err=..UpdateTestPack(ListData)  /// 更新
	.e  d
	..s Err=..InsertTestPack(ListData)  /// 插入
	i Err'=0 tro
	q:Err'=0 Err
	TC
	q Err
}

/// Creator：      sufan
/// CreatDate：    2017-07-06
/// Description：  保存病理检测项目套餐字典表
/// Table：        DHC_AppTestPack
/// Input：		   套餐表ID^套餐代码^套餐描述^医院ID^是否可用标识^检查分类ID
/// Output：       0:成功 ,其他:失败
/// Others：       w ##Class(web.DHCAPPTestPack).InsertTestPack()
ClassMethod InsertTestPack(ListData As %String) As %String
{
	n (ListData)
	s ATPCode=$p(ListData,"^",2)     /// 套餐代码
	s ATPDesc=$p(ListData,"^",3)	 /// 套餐描述
	s ATPHospID=$p(ListData,"^",4)   /// 医院ID
	s ATPFlag=$p(ListData,"^",5)	 /// 可用标识
	s ATPCatID=$p(ListData,"^",6)    /// 检查分类ID
	&SQL(Insert into DHC_AppTestPack (ATP_Code,ATP_Desc,ATP_Hosp_Dr,ATP_ActiveFlag,ATP_TesCat_Dr) values 
	(:ATPCode,:ATPDesc,:ATPHospID,:ATPFlag,:ATPCatID))
	q SQLCODE
}

/// Creator：      sufan
/// CreatDate：    2017-07-06
/// Description：  更新病理检测项目套餐字典表
/// Table：        DHC_AppTestPack
/// Input：		   套餐表ID^套餐代码^套餐描述^医院ID^是否可用标识^检查分类ID
/// Output：       0:成功 ,其他:失败
/// Others：       w ##Class(web.DHCAPPTestPack).InsertTestPack()
ClassMethod UpdateTestPack(ListData As %String) As %String
{
	n (ListData)
	s ATPRowID=$p(ListData,"^",1)		/// 套餐表ID
	s ATPCode=$p(ListData,"^",2)		/// 套餐代码
	s ATPDesc=$p(ListData,"^",3)		/// 套餐描述
	s ATPHospID=$p(ListData,"^",4)		/// 医院ID
	s ATPFlag=$p(ListData,"^",5)		/// 可用标识
	s ATPCatID=$p(ListData,"^",6)		/// 检查分类ID
	&SQL(Update DHC_AppTestPack Set ATP_Code=:ATPCode,ATP_Desc=:ATPDesc,ATP_Hosp_Dr=:ATPHospID,ATP_ActiveFlag=:ATPFlag,ATP_TesCat_Dr=:ATPCatID Where ATP_RowID =:ATPRowID)
	q SQLCODE
}

/// Creator：      sufan
/// CreatDate：    2017-07-06
/// Description：  删除病理检测项目套餐字典表
/// Table：        DHC_AppTestPack
/// Input：		   套餐表ID^套餐代码^套餐描述^医院ID^是否可用标识^检查分类ID
/// Output：       0:成功 ,其他:失败
/// Others：       w ##Class(web.DHCAPPTestPack).InsertTestPack()
ClassMethod DeleteTestPack(ATPRowID As %String) As %String
{
	n (ATPRowID)
	&sql(delete from DHC_AppTestPack where ATP_RowID=:ATPRowID)
	q SQLCODE
}

/// Creator：  sufan
/// CreatDate: 2017-07-06
/// Descript:  检查代码、描述是否重复
/// Table：    DHC_AppTestPack
/// Others：   w ##class(web.DHCAPPTestPack).CheckRepeat("^1^1^65^Y^1")
ClassMethod CheckRepeat(ItmTempStr As %String) As %String
{
	n (ItmTempStr)
	s ret=0
	s ID=$p(ItmTempStr,"^",1)   	///ID
	s ATPCode=$p(ItmTempStr,"^",2)  ///代码
	s ATPDesc=$p(ItmTempStr,"^",3)  ///描述
	s HospID=$p(ItmTempStr,"^",4)	///医院ID
	/// 新记录
	if ID=""  d
	.i $d(^DHCAPPTP(0,"Code",$$ALPHAUP^SSUTIL4((ATPCode))))   d
	..s ATPID=""
	..for  s ATPID=$o(^DHCAPPTP(0,"Code",$$ALPHAUP^SSUTIL4(ATPCode),ATPID)) q:(ATPID="")||(ret'=0)  d
	...s HospDr=$p(^DHCAPPTP(ATPID),"^",3)
	...q:HospDr'=HospID
	...s ret=-1
	..
	.
	.i $d(^DHCAPPTP(0,"Desc",$$ALPHAUP^SSUTIL4(ATPDesc)))  d
	..s ATPID=""
	..f  s ATPID=$o(^DHCAPPTP(0,"Desc",$$ALPHAUP^SSUTIL4(ATPDesc),ATPID))  q:(ATPID="")||(ret'=0)  d
	...s HospDr=$p(^DHCAPPTP(ATPID),"^",3)
	...q:HospDr'=HospID
	...s ret=-2
	..
	.
	/// 修改记录
	else  d
	.s Code=$p($g(^DHCAPPTP(ID)),"^",1)    //代码
	.s Desc=$p($g(^DHCAPPTP(ID)),"^",2)    //描述
	.i (Code'=ATPCode)&($d(^DHCAPPTP(0,"Code",$$ALPHAUP^SSUTIL4(ATPCode))))  d
	..s ATPID=""
	..f  s ATPID=$o(^DHCAPPTP(0,"Code",$$ALPHAUP^SSUTIL4(ATPCode),ATPID)) q:(ATPID="")||(ret'=0)  d
	...s HospDr=$p(^DHCAPPTP(ATPID),"^",3)
	...q:HospDr'=HospID
	...s ret=-3
	..
	.
	.i (Desc'=ATPDesc)&($d(^DHCAPPTP(0,"Desc",$$ALPHAUP^SSUTIL4(ATPDesc))))  d
	..s ATPID=""
	..f  s ATPID=$o(^DHCAPPTP(0,"Desc",$$ALPHAUP^SSUTIL4(ATPDesc),ATPID)) q:(ATPID="")||(ret'=0)  d
	...s HospDr=$p(^DHCAPPTP(ATPID),"^",3)
	...q:HospDr'=HospID
	...s ret=-4
	..
	.
	q ret
}

/// Creator：      sufan
/// CreatDate：    2017-07-06
/// Description：  查询病理检测项目套餐字典表
/// Table：        DHC_AppTestPack
/// Input：		   params:"套餐代码^套餐描述",HospID:医院ID
/// Output：       病理检测项目套餐信息
/// Others：       w ##Class(web.DHCAPPTestPack).QueryTestPack(10,1,"","2")
ClassMethod QueryTestPack(rows As %String, page As %String, params As %String, HospID As %String) As %String
{
	n (rows,page,params,HospID)
	s End=page*rows
	s Start=(page-1)*rows+1
	s pid=##Class(web.DHCAPPExaRepCom).NewPid()	
	d ..killTmpGlobal(pid)     // k掉临时global
	s Code=$p(params,"^",1)    // 在串params中取值
	s Desc=$p(params,"^",2)
	s h=0,count=0
	s ATPRowID=""
	for  s ATPRowID=$o(^DHCAPPTP(ATPRowID)) q:ATPRowID=""  d  // 查询表DHC_APPTestPack
	.q:ATPRowID=0
	.s ATPCode=$p(^DHCAPPTP(ATPRowID),"^",1)      		// 检测项目套餐代码
	.s ATPDesc=$p(^DHCAPPTP(ATPRowID),"^",2)	  		// 检测项目套餐描述
	.s HospDr=+$p(^DHCAPPTP(ATPRowID),"^",3)	  		// 医院ID
	.s HospDesc=""
	.s:HospDr'=0 HospDesc=$p(^CT("HOSP",HospDr),"^",2)	// 医院描述
	.s ATPFlag=$p(^DHCAPPTP(ATPRowID),"^",4)			// 是否可用标识
	.s FlagCode=ATPFlag
	.s CatID=+$p(^DHCAPPTP(ATPRowID),"^",6)				// 检查分类ID
	.s CatDesc=""
	.s:CatID'=0 CatDesc=$p(^DHCAPPTC(CatID),"^",2)		// 检查分类描述
	.q:(Code'="")&(ATPCode'[Code)						// 代码过滤
	.q:(Desc'="")&(ATPDesc'[Desc)						// 描述过滤
	.;q:HospID'=HospDr									// 医院过滤
	.s h=h+1
	.s tempstr=ATPRowID_"^"_ATPCode_"^"_ATPDesc_"^"_HospDr_"^"_HospDesc_"^"_ATPFlag_"^"_FlagCode_"^"_CatID_"^"_CatDesc
	.s ^TMP("DHCAPP","web.DHCAPPTestPack","QueryTestPack",pid,h)=tempstr     // 数据存储
	
	q:h=0 ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) 	// 输出json结尾符
	
	///转换数据为Json格式
	s title="ATPRowID^ATPCode^ATPDesc^HospDr^HospDesc^ATPFlag^FlagCode^CatID^CatDesc" // 列title 
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(h) 		//  输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCAPP","web.DHCAPPTestPack","QueryTestPack",pid,index)) q:index=""  d
	.s mdate=$g(^TMP("DHCAPP","web.DHCAPPTestPack","QueryTestPack",pid,index))
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

/// Descript:  保存检测套餐项目子表
/// w ##class(web.DHCAPPTestPack).InsTesItm("9||1^9^重组牛碱性成纤维细胞生长因眼凝胶(贝复舒)[21000IU:5G]^16||1^3")
ClassMethod InsTesItm(params As %String) As %String
{
	n (params)
  	s Err=0
  	TS
	s Len=$L(params,"$$")
	for i=1:1:Len d
	.s ListData=$p(params,"$$",i)
	.i $p(ListData,"^",1)'="" q:Err'=0  d
	..s Err=..UpdTesPackItm(ListData)
	.e  d
	..s Err=..isExistSameItem(ListData)
	..q:Err'=0
	..s Err=..InsTesPackItm(ListData)
	i Err'=0 tro
	q:Err'=0 Err
	TC
	q Err
}

/// Descript:  插入检测项目子表
ClassMethod InsTesPackItm(ListData As %String) As %String
{
	n (ListData)
	s TestPackID=$p(ListData,"^",2)		/// 分类ID
	s TestID=$p(ListData,"^",4)		    /// 检测项目ID
	s TestQty=$p(ListData,"^",5)		/// 数量
	i +TestQty=0 s TestQty=1
	s ChildSub=$o(^DHCAPPTP(TestPackID,"I",""),-1)+1
	&SQL(Insert into DHC_AppTestPackItm(ATPI_ATP_ParRef,ATPI_ChildSub,ATPI_Arc_Dr,ATPI_Qty) values(:TestPackID,:ChildSub,:TestID,:TestQty))
	q SQLCODE
}

/// Descript:  更新检测项目子表
ClassMethod UpdTesPackItm(ListData As %String) As %String
{
	n (ListData)
	s TestPackItmID=$p(ListData,"^",1)	/// 明细表ID
	s TestID=$p(ListData,"^",4)		    /// 检测项目ID
	s TestQty=$p(ListData,"^",5)		/// 数量
	i +TestQty=0 s TestQty=1
	&SQL(Update DHC_AppTestPackItm Set ATPI_Arc_Dr=:TestID,ATPI_Qty=:TestQty Where ATP_RowID =:TestPackItmID)
	q SQLCODE
}

/*
/// Creator：      sufan
/// CreatDate：    2017-07-06
/// Description：  保存病理检测项目套餐明细表
/// Table：        DHC_AppTestPackItm
/// Input：		   params:"套餐明细表ID^套餐表ID^检测项目ID"
/// Output：       0:成功 ,其他:失败
/// Others：       w ##Class(web.DHCAPPTestPack).SaveTestPackItm("^1^测试2^4")
ClassMethod SaveTestPackItm(params As %String) As %String
{
	n (params)
  	s Err=0
  	TS
	s Len=$L(params,"$$")
	for i=1:1:Len d
	.s ListData=$p(params,"$$",i)
	.s Err=..isExistSameItem(ListData)
	.q:Err'=0
	.i $p(ListData,"^",1)'="" q:Err'=0  d
	..s Err=..UpdateTestPackItm(ListData)
	.e  d
	..s Err=..InsertTestPackItm(ListData)
	i Err'=0 tro
	q:Err'=0 Err
	TC
	q Err
}


/// Creator：      sufan
/// CreatDate：    2017-07-06
/// Description：  保存病理检测项目套餐明细表
/// Table：        DHC_AppTestPackItm
/// Input：		   params:"套餐明细表ID^套餐表ID^检测项目描述^检测项目ID"
/// Output：       0:成功 ,其他:失败
/// Others：       w ##Class(web.DHCAPPTestPack).InsertTestPackItm()
ClassMethod InsertTestPackItm(ListData As %String) As %String
{
	n (ListData)
	s TestPackID=$p(ListData,"^",2)		/// 分类ID
	s TestItemID=$p(ListData,"^",4)		/// 检测项目ID
	s ChildSub=$o(^DHCAPPTP(TestPackID,"I",""),-1)+1
	&SQL(Insert into DHC_AppTestPackItm(ATPI_ATP_ParRef,ATPI_ChildSub,ATPI_Itm_Dr) values(:TestPackID,:ChildSub,:TestItemID))
	q SQLCODE
}

/// Creator：      sufan
/// CreatDate：    2017-07-06
/// Description：  更新病理检测项目套餐明细表
/// Table：        DHC_AppTestPackItm
/// Input：		   params:"套餐明细表ID^套餐表ID^检测项目描述^检测项目ID"
/// Output：       0:成功 ,其他:失败
/// Others：       w ##Class(web.DHCAPPTestPack).InsertTestPackItm()
ClassMethod UpdateTestPackItm(ListData As %String) As %String
{
	n (ListData)
	s TestPackItmID=$p(ListData,"^",1)	/// 明细表ID
	s TestPackID=$p(ListData,"^",2)		/// 套餐表ID
	s TestItemID=$p(ListData,"^",4)		/// 检测项目ID
	&SQL(Update DHC_AppTestPackItm Set ATPI_ATP_ParRef=:TestPackID,ATPI_Itm_Dr=:TestItemID Where ATP_RowID =:TestPackItmID)
	q SQLCODE
}
*/
/// Creator：      sufan
/// CreatDate：    2017-07-06
/// Description：  删除病理检测项目套餐明细表
/// Table：        DHC_AppTestPackItm
/// Input：		   套餐明细表ID
/// Output：       0:成功 ,其他:失败
/// Others：       w ##Class(web.DHCAPPTestPack).InsertTestPack()
ClassMethod DeleteTestPackItm(PackItmRowID As %String) As %String
{
	n (PackItmRowID)
	&sql(delete from DHC_AppTestPackItm where ATP_RowID=:PackItmRowID)
	q SQLCODE
}

/// Creator    : sufan
/// CreatDate  : 2017-07-06
/// Descript   : 套餐明细表ID^套餐表ID^检测项目描述^检测项目ID
/// Table      : DHC_AppTestPack,DHC_AppTestPackItm
/// Input      : 套餐明细表ID^套餐表ID^检测项目描述^检测项目ID
/// Return     : 0:不存在 ，其他：存在
/// Others     ：w ##class(web.DHCAPPTestPack).isExistSameItem("^1^测试2^4")
ClassMethod isExistSameItem(ListData As %String) As %String
{
	n (ListData)
	s ret=0
	s TestPackID=$p(ListData,"^",2)	 	/// 套餐表ID
	s TestItemID=$p(ListData,"^",4)		/// 检测项目ID
	s Qty=$p(ListData,"^",5)			/// 数量
	s ChildSub=""
	f  s ChildSub=$o(^DHCAPPTP(TestPackID,"I",ChildSub)) q:(ChildSub="")||(ret'=0)  d
	.s ItemID=$p(^DHCAPPTP(TestPackID,"I",ChildSub),"^",1)  /// 检测项目ID
	.q:TestItemID'=ItemID
	.s ret="-11"
	q ret
}

/// Creator：      sufan
/// CreatDate：    2017-07-06
/// Description：  查询病理检测项目套餐字典表
/// Table：        DHC_AppTestPack,DHC_AppTestPackItm
/// Input：		   套餐表ID
/// Output：       病理检测项目套餐信息
/// Others：       w ##Class(web.DHCAPPTestPack).QueryTestPackItm(10,1,"测",5)
ClassMethod QueryTestPackItm(rows, page, ItemDesc, TestPackID) As %String
{
	n (rows,page,ItemDesc,TestPackID)
	s End=page*rows
	s Start=(page-1)*rows+1
	s pid=##Class(web.DHCAPPExaRepCom).NewPid()		
	d ..killTmpGlobal(pid)    //k掉临时global
	s h=0,count=0
	s ChildSub=""
	f  s ChildSub=$o(^DHCAPPTP(TestPackID,"I",ChildSub)) q:ChildSub=""  d
	.s arcimid=$p(^DHCAPPTP(TestPackID,"I",ChildSub),"^",1)   		/// 检测项目ID
	.s itmmastid=+arcimid,itmmastver=$p(arcimid,"||",2)
	.s arcitmdesc=$p(^ARCIM(itmmastid,itmmastver,1),"^",2) 			/// 医嘱项名称
	.q:(ItemDesc'="")&(arcitmdesc'[ItemDesc)
	.s TestPackItmID=TestPackID_"||"_ChildSub					  		/// 明细表ID
	.s TestQty=+$p(^DHCAPPTP(TestPackID,"I",ChildSub),"^",2)   		/// 检测项目ID
	.s h=h+1
	.s tempstr=TestPackItmID_"^"_arcitmdesc_"^"_arcimid_"^"_TestQty
	.s ^TMP("DHCAPP","web.DHCAPPTestPack","QueryTestPackItm",pid,h)=tempstr  /// 存储数据
	
	q:h=0 ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) 	//输出json结尾符
	
	///转换数据为Json格式
	s title="TestPackItmID^TestDesc^TestID^TestQty"
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(h) 	//输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCAPP","web.DHCAPPTestPack","QueryTestPackItm",pid,index)) q:index=""  d
	.s mdate=$g(^TMP("DHCAPP","web.DHCAPPTestPack","QueryTestPackItm",pid,index))
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

/// Creator：      sufan
/// CreatDate：    2017-07-06
/// Description：  获取检测项目
/// Table：        DHC_AppTestItem
/// Input：		   医院ID
/// Output：       检测项目信息
/// Others：       w ##Class(web.DHCAPPTestPack).GetTestItem()
ClassMethod GetTestItem(HospID As %String) As %String
{
	n (HospID)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT ATI_RowID ,ATI_Desc FROM DHC_AppTestItem"
	s sqlStr = sqlStr_" Where ATI_Hosp_Dr='"_HospID_"'"_" And ATI_ActiveFlag='Y'"
    d result.Prepare(sqlStr)
	d result.Execute()
	s ListTitle="value^text"
	s count = 0
	w "["
	While(result.Next())
	{	

		s ATIItemID = result.Data("ATI_RowID")
		continue:ATIItemID=0
		s ATIItemDesc = result.Data("ATI_Desc")
		s ListData=ATIItemID_"^"_ATIItemDesc
		s count = count+1
		I count=1 d
		.w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
		e  d
		.W ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	}
	w "]"
	q ""
}

/// Descript:	检查方法
/// W ##Class(web.DHCAPPTestPack).GetArcCat("")
ClassMethod GetArcCat(HospID As %String) As %String
{
	n (HospID)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT AC_RowID ,AC_Desc FROM DHC_AppTestCat"
	s sqlStr = sqlStr_" Where AC_Hosp_Dr='"_HospID_"'"
    d result.Prepare(sqlStr)
	d result.Execute()
	s ListTitle="value^text"
	s count = 0
	w "["
	While(result.Next())
	{	

		s ACID = result.Data("AC_RowID")
		continue:ACID=0
		s ACDesc = result.Data("AC_Desc")
		s ListData=ACID_"^"_ACDesc
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
	k ^TMP("DHCAPP","web.DHCAPPTestPack","QueryTestPack",pid)
	k ^TMP("DHCAPP","web.DHCAPPTestPack","QueryTestPackItm",pid)
}

}
