Import SQLUSER

Class web.DHCCKBDicLinkAttr Extends %Library.RegisteredObject [ ClassType = "", NoExtent, Not ProcedureBlock ]
{

/// Creator：      sufan
/// CreatDate：    2018-12-27
/// Description:： 实体与属性、关系、前提条件  查询
/// Table：        DHC_CKBCommonDiction,DHC_CKBCommonAttr
/// Input:		   实体ID^属性类型
/// Others：       w ##class(web.DHCCKBDicLinkAttr).QueryDicLinkAttr("10","1","4072^2860^5282")
ClassMethod QueryDicLinkAttr(rows As %String = 100, page As %String = 1, params As %String) As %String
{
	n (rows,page,params)

	s end=page*rows
	s start=(page-1)*rows+1
	s pid=##Class(web.DHCCKBCommonUtil).NewPid()	
	d ..killTmpGlobal(pid)    		//k掉临时global
	s dicId=$p(params,"^",1)  		//实体Id
	//s Type=$p(params,"^",2)			//N:属性,R:关系,C:前提条件
	s h=0,count=0
	s linkRowId=""
	f  s linkRowId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDic",dicId,linkRowId)) q:linkRowId=""  d  //查询表CT_CKB_PDSS.DicLinkAttr
	.q:linkRowId=0
	.s attrCodeDr=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(linkRowId)),3)	// 属性ID
	.s attrValueDr=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(linkRowId)),4)	// 属性值ID
	.s attrResult=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(linkRowId)),5)	// 内容
	.s attrCodeDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(attrCodeDr)),3)
	.i attrValueDr'="" s attrValue=$lg($g(^CT.CKB.PDSS.CommonDictionD(attrValueDr)),3)	
	.s h=h+1
	.s tempstr=linkRowId_"^"_attrCodeDr_"^"_attrCodeDesc_"^"_attrValueDr_"^"_$g(attrValue)_"^"_attrResult
	.s ^TMP("DHCCKB","web.DHCCKBDicLinkAttr","QueryDicLinkAttr",pid,h)=tempstr
	
	q:h=0 ##class(web.DHCEMJsonCommon).getJsonEmptySign(h) //输出json结尾符
	
	///转换数据为Json格式
	s title="linkRowId^attrCodeDr^attrCodeDesc^attrValueDr^attrValue^attrResult"
	w ##class(web.DHCEMJsonCommon).getJsonStartSign(h) //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCCKB","web.DHCCKBDicLinkAttr","QueryDicLinkAttr",pid,index)) q:index=""  d
	.s mdata=$g(^TMP("DHCCKB","web.DHCCKBDicLinkAttr","QueryDicLinkAttr",pid,index))
	.s count = count+1
	.q:(count<start)||(count>end)
	.i count=start d
	..w ##class(web.DHCEMJsonCommon).getJsonData(title,mdata)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(title,mdata)
	w ##class(web.DHCEMJsonCommon).getJsonEndSign() //输出json结尾符
	
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// Creator：      kemaolin
/// CreatDate：    2020-01-20
/// Description:： 根据实体与属性查询
/// Table：        DHC_CKBCommonDiction,DHC_CKBCommonAttr
/// Input:		   实体ID^属性
/// Others：       w ##class(web.DHCCKBDicLinkAttr).QueryDatagridDicLinkAttr("30","1","75369^49535")
ClassMethod QueryDatagridDicLinkAttr(rows As %String = 100, page As %String = 1, params As %String) As %String
{
	n (rows,page,params)
	s ^temptest("rows")=$lb(rows,page,params)
	s end=page*rows
	s start=(page-1)*rows+1
	s pid=##Class(web.DHCCKBCommonUtil).NewPid()	
	d ..killTmpGlobal(pid)    			//k掉临时global
	s dicId=$p(params,"^",1)  			//实体Id
	s attrId=$p(params,"^",2)			//N:属性,R:关系,C:前提条件
	s h=0,count=0
	Q:+dicId=0 ##class(web.DHCEMJsonCommon).getJsonEmptySign(h) 		//输出json结尾符
	s OrdNumAttrId=##class(web.DHCCKBCommon).GetOrdNumId()				//顺序号属性 sufan 20200518
	s linkRowId=""
	f  s linkRowId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",+dicId,+attrId,linkRowId)) q:linkRowId=""  d  //查询表CT_CKB_PDSS.DicLinkAttr
	.q:linkRowId=0
	.s attrCodeDr=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(linkRowId)),3)	// 属性ID
	.s attrValueDr=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(linkRowId)),4)	// 属性值ID
	.s attrResult=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(linkRowId)),5)	// 内容
	.s attrCodeDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(attrCodeDr)),3)
	.i attrValueDr'="" s attrValue=$lg($g(^CT.CKB.PDSS.CommonDictionD(attrValueDr)),3)
	.s LinkId=$lg($g(^CT.CKB.PDSS.CommonDictionD(attrValueDr)),"^",4)
	.i (LinkId'="")&&(attrValue="")	s attrValue=$lg($g(^CT.CKB.PDSS.CommonDictionD(LinkId)),3)			//sufan 2020-04-22 link关系的为空处理
	.s h=h+1
	.i $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",attrValueDr,OrdNumAttrId))  d
	..s AttrId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",attrValueDr,OrdNumAttrId,""))
	..s OrdNum=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(AttrId)),5)*10000+h
	..s OrdNum=##class(web.DHCCKBDiction).GetOrdNum(OrdNum)
	.e  d
	..s OrdNum=90000000
	..s OrdNum=##class(web.DHCCKBDiction).GetOrdNum(OrdNum)+h
	..s OrdNum=##class(web.DHCCKBDiction).GetOrdNum(OrdNum)
	.s tempstr=linkRowId_"^"_attrCodeDr_"^"_attrCodeDesc_"^"_attrValueDr_"^"_$g(attrValue)_"^"_attrResult
	.s ^TMP("DHCCKB","web.DHCCKBDicLinkAttr","QueryDicLinkAttr",pid,OrdNum,h)=tempstr
	
	q:h=0 ##class(web.DHCEMJsonCommon).getJsonEmptySign(h) //输出json结尾符
	
	///转换数据为Json格式
	s title="linkRowId^attrCodeDr^attrCodeDesc^attrValueDr^attrValue^attrResult"
	w ##class(web.DHCEMJsonCommon).getJsonStartSign(h) //输出json前缀串
	s Ord=""
	f  s Ord=$o(^TMP("DHCCKB","web.DHCCKBDicLinkAttr","QueryDicLinkAttr",pid,Ord)) q:Ord=""  d
	.s index=""
	.for  s index=$o(^TMP("DHCCKB","web.DHCCKBDicLinkAttr","QueryDicLinkAttr",pid,Ord,index)) q:index=""  d
	..s mdata=$g(^TMP("DHCCKB","web.DHCCKBDicLinkAttr","QueryDicLinkAttr",pid,Ord,index))
	..s count = count+1
	..q:(count<start)||(count>end)
	..i count=start d
	...w ##class(web.DHCEMJsonCommon).getJsonData(title,mdata)
	..e  d
	...w ","_##class(web.DHCEMJsonCommon).getJsonData(title,mdata)
	w ##class(web.DHCEMJsonCommon).getJsonEndSign() //输出json结尾符
	
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// Creator：      sufan
/// CreatDate：     2019-12-27
/// Description:： 保存实体属性关联
/// Table：        CT_CKB_PDSS.DicLinkAttr 
/// w ##class(web.DHCCKBDicLinkAttr).SaveDicAttr("31810[next]1[next]8[next]ssttest[next]")
ClassMethod SaveDicAttr(ListData As %String) As %String
{
	n (ListData)
  	s Err=0
	s len=$L(ListData,"&&")
	f i=1:1:len q:Err'=0  d
	.s tmpstr=$p(ListData,"&&",i)
	.q:Err'=0
	.i $p(tmpstr,"^",1)'="" q:Err'=0  d
	..s Err=..UpdDicAttr(tmpstr)
	.e  d
	..s Err=..AddDicAttr(tmpstr)
	q Err
}

/// Creator：      sufan
/// CreatDate：    2018-12-27
/// Description:： 保存实体属性关联
/// Table：        CT_CKB_PDSS.DicLinkAttr 
/// Others：       w ##class(web.DHCCKBDicLinkAttr).AddDicAttr("^005^ds^CT")
ClassMethod AddDicAttr(ListData As %String) As %String
{
	n (ListData)
	s DicId=$p(ListData,"^",2)     	   /// 实体ID
	s AttrCodeDr=$p(ListData,"^",3)	   /// 属性ID
	s AttrResult=$p(ListData,"^",4)	   /// 属性ID
	s AttrValueDr=$p(ListData,"^",5)   /// 属性ID
	&sql(insert into CT_CKB_PDSS.DicLinkAttr (DLA_Dic_Dr,DLA_AttrCode,DLA_Result,DLA_Attr_Dr) values (:DicId,:AttrCodeDr,:AttrResult,:AttrValueDr))
	q SQLCODE
}

/// Creator：      sufan
/// CreatDate：    2018-12-27
/// Description:： 保存实体属性关联
/// Table：        CT_CKB_PDSS.DicLinkAttr 
/// Others：       w ##class(web.DHCCKBDicLinkAttr).UpdDicAttr("1^001^ds^普通床位")
ClassMethod UpdDicAttr(ListData As %String) As %String
{
	n (ListData)
	s DLArowId=$p(ListData,"^",1)		/// 关联表ID
	s DicId=$p(ListData,"^",2)		    /// 实体ID
	s AttrCodeDr=$p(ListData,"^",3)		    /// 属性ID
	s AttrResult=$p(ListData,"^",4)		/// 属性ID
	s AttrValueDr=$p(ListData,"^",5)	/// 属性ID

	&sql(update CT_CKB_PDSS.DicLinkAttr set DLA_Dic_Dr=:DicId,DLA_AttrCode=:AttrCodeDr,DLA_Result=:AttrResult,DLA_Attr_Dr=:AttrValueDr where DLA_RowID=:DLArowId )
	q SQLCODE
}

/// Creator：      sufan
/// CreatDate：    2018-12-27
/// Description:： 删除实体属性关联
/// Table：        CT_CKB_PDSS.DicLinkAttr 
/// thers：       w ##class(web.DHCCKBDicLinkAttr).DelDicAttr("")
ClassMethod DelDicAttr(linkRowID As %String, type = "") As %String
{
	n (linkRowID,type)
	&sql(delete from CT_CKB_PDSS.DicLinkAttr where DLA_RowID=:linkRowID)
	q:type="ROWID" %ROWID
	q SQLCODE
}

/// Creator：      sufan
/// CreatDate：    2018-12-27
/// Description:： 属性下拉框
/// Table：        CT_CKB_PDSS.DicLinkAttr 
/// thers：       w ##class(web.DHCCKBDicLinkAttr).QueryAttr()
ClassMethod QueryAttr(Type)
{
	n (Type)
	s count=0
	w "["
	s AttrId="0"
	for  s AttrId=$o(^DHCCKBCA(AttrId))  Q:AttrId=""  d
	.s AttrDesc=$p(^DHCCKBCA(AttrId),"^",2)		//属性描述
	.s AttrType=$p(^DHCCKBCA(AttrId),"^",3)		//属性类型
	.Q:(Type'="")&&(AttrType'[Type)
	.s tmp=AttrId_"^"_AttrDesc
	.s count = count+1
	.i count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData("value^text",tmp)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData("value^text",tmp)
	w "]"
	q ""
}

/// Creator：      sufan
/// CreatDate：    2018-12-27
/// Description:： 查询
/// Table：        DHC_CKBCommonDiction
/// Input:		   
/// Others：       w ##class(web.DHCCKBDicLinkAttr).QueryDic("10","1","")
ClassMethod QueryDic(rows As %String, page As %String, input As %String) As %String
{
	n (rows,page,input)

	s end=page*rows
	s start=(page-1)*rows+1
	s pid=##Class(web.DHCCKBCommonUtil).NewPid()	
	d ..killTmpGlobal(pid)    //k掉临时global
	s h=0,count=0
	s DicRowId=""
	f  s DicRowId=$o(^CT.CKB.PDSS.CommonDictionD(DicRowId)) Q:DicRowId=""  d  //查询表DHC_CKBCommonDiction
	.q:DicRowId=0
	.s DicDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(DicRowId)),3)				//属性描述
	.Q:(input'="")&&(DicDesc'[input)
	.s h=h+1
	.s tempstr=DicRowId_"^"_DicDesc
	.s ^TMP("DHCCKB","QueryDicLinkAttr","QueryDic",pid,h)=tempstr
	
	q:h=0 ##class(web.DHCEMJsonCommon).getJsonEmptySign(h) //输出json结尾符
	
	///转换数据为Json格式
	s title="DicRowId^DicDesc"
	w ##class(web.DHCEMJsonCommon).getJsonStartSign(h) 	//输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCCKB","QueryDicLinkAttr","QueryDic",pid,index)) q:index=""  d
	.s mdate=$g(^TMP("DHCCKB","QueryDicLinkAttr","QueryDic",pid,index))
	.s count = count+1
	.q:(count<start)||(count>end)
	.i count=start d
	..w ##class(web.DHCEMJsonCommon).getJsonData(title,mdate)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(title,mdate)
	w ##class(web.DHCEMJsonCommon).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// Creator：      qunianpeng
/// CreatDate：    2019-05-27
/// Description:： 关联属性查询
/// Table：        DHC_CKBCommonDiction,DHC_CKBCommonAttr
/// Input:		   关联属性表id
/// Others：       w ##class(web.DHCCKBDicLinkAttr).QueryLinKAttrValue(1)
ClassMethod QueryLinKAttrValue(linkRowID As %String) As %String
{
	n (linkRowID)

	s linkDicID=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(linkRowID)),2)		// 实体id
	s linkAttrCode=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(linkRowID)),3)		// 属性
	s linkAttrCodeDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(linkAttrCode)),3)
	s linkAttrValueDr=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(linkRowID)),4)		// 属性值
	i linkAttrValueDr'="" s linkAttrDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(linkAttrValueDr)),3)
	s linkAttrContent=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(linkRowID)),5)	// 内容
	
	s mdata=linkDicID_"^"_linkAttrCode_"^"_linkAttrCodeDesc_"^"_linkAttrValueDr_"^"_$g(linkAttrDesc)_"^"_linkAttrContent
	s title="linkDicID^linkAttrCode^linkAttrCodeDesc^linkAttrValue^linkAttrDesc^linkAttrContent"
	w ##class(web.DHCEMJsonCommon).getJsonData(title,mdata)
	
	q ""
}

/// /////////////////////////////////////////////////////////////////////////////////////
/// /////////////////////////////////////////////////////////////////////////////////////
/// /////////////////////////////////////////////////////////////////////////////////////
/// Creator：      qunianpeng
/// CreatDate：    2019-05-27
/// Description:： 关联属性查询(用)
/// Table：        CT_CKB_PDSS.DicLinkAttr,DHC_CKBCommonAttr
/// Input:		   关联属性表id
/// Others：       w ##class(web.DHCCKBDicLinkAttr).SaveDicAttrNew(1)
ClassMethod SaveDicAttrNew(listData As %String) As %String
{
	n (listData)
	
	s dicID=$p(listData,"^",2)     	   /// 实体ID
	s attrCodeDr=$p(listData,"^",3)	   /// 属性ID
	s attrValueDr=$p(listData,"^",4)   /// 属性ID
	s attrResult=$p(listData,"^",5)	   /// 属性值
	s group=$p(listData,"^",6)		   /// 组号	
	&sql(insert into CT_CKB_PDSS.DicLinkAttr (DLA_Dic_Dr,DLA_AttrCode,DLA_Attr_Dr,DLA_Result,DLA_GroupFlag) values (:dicID,:attrCodeDr,:attrValueDr,:attrResult,:group))
	
	q SQLCODE
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	n (pid)
	k ^TMP("DHCCKB","web.DHCCKBDicLinkAttr","QueryDicLinkAttr",pid)
	k ^TMP("DHCCKB","QueryDicLinkAttr","QueryDic",pid)
	k ^TMP("DHCCKB","web.DHCCKBDicLinkAttr","QueryEntyAttr",pid)
}

/// Creator：      sufan
/// CreatDate：    2019-11-18
/// Description:： 根据类型存储数据
/// Table：        CT_CKB_PDSS.DicLinkAttr,DHC_CKBCommonDiction
/// Others：       w ##class(web.DHCCKBDicLinkAttr).saveDicAttrByType("0^104884^26961^^&&^104884^26961^测试^OtherNameProp^0^","datagrid","12018^9^1^289^2","113.140.81.66")
ClassMethod saveDicAttrByType(ListData, Type, LoginInfo, ClientIPAddress)
{
	n (ListData,Type,LoginInfo,ClientIPAddress)
	s ^temptest("ld","web.DHCCKBDicLinkAttr","saveDicAttrByType") = $lb(ListData,Type,LoginInfo,ClientIPAddress)
	s LgUserID=$p(LoginInfo,"^",1)
	s LgHospID=$p(LoginInfo,"^",5)

	s pid=##class(web.DHCCKBCommonUtil).NewPid()

	s ListData=##class(web.DHCCKBDicLinkAttr).dealListData(pid,ListData,Type)
	
	TS
	s Err=0
	i Type="datagrid"  d
	.s Err=..saveGridData(ListData,LgUserID,LgHospID,ClientIPAddress,Type)
	e  i Type="tree"  d
	.s Err=..saveTreeData(ListData,LgUserID,LgHospID,ClientIPAddress,Type)
	e  d
	.s Err=..saveTextData(ListData,LgUserID,LgHospID,ClientIPAddress,Type)
	i Err'=0 tro
	Q:Err'=0 Err
	TC
	Q Err
}

ClassMethod saveTreeData(ListData, LgUserID, LgHospID, ClientIPAddress, Type)
{
	
	n (ListData, LgUserID, LgHospID, ClientIPAddress, Type)
	s Err=0
	TS
	s Err=..DelDrugcls(ListData)
	i Err'=0 tro
	Q:Err'=0 Err
	
	s Err=..saveGridData(ListData,LgUserID,LgHospID,ClientIPAddress,Type)
	i Err'=0 tro
	Q:Err'=0 Err
	
	TC
	Q Err
}

/// 删除掉药学分类的数据
ClassMethod DelDrugcls(ListData)
{
	n (ListData)		
	s DrugId=$p(ListData,"^",2)			//药品Id
	s DrugclsId=$p(ListData,"^",3)		//药学分类Id
	Q:'$d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",DrugId,DrugclsId)) 0
	&sql(delete from CT_CKB_PDSS.DicLinkAttr where DLA_Dic_Dr=:DrugId and DLA_AttrCode=:DrugclsId)
	Q SQLCODE
}

/// Creator：      sufan
/// CreatDate：    2019-11-18
/// Description:： 根据类型存储数据
/// Table：        CT_CKB_PDSS.DicLinkAttr,DHC_CKBCommonDiction 
/// Input:			(repeatFlag:属性是否可以重复保存,默认是0,不可以。 拆分模板保存时允许重复保存)
/// Others:		   w ##class(web.DHCCKBDicLinkAttr).saveGridData("0^24512^49535^28^","11863","2","113.140.81.66","tree")
ClassMethod saveGridData(ListData, LgUserID = "", LgHospID = "", ClientIPAddress = "", Type = "", repeatFlag = 0)
{
	n (ListData,LgUserID,LgHospID,ClientIPAddress,Type,repeatFlag)
	s Err=0
	s LogIDList=""
	s EntyId=""
	s AttrCodeId=""
	;s ^shy("web.DHCCKBDicLinkAttr","saveGridData")=LgUserID_"^"_"shy"_ListData
	TS
	s Len=$l(ListData,"&&")
	s ^kmltest=ListData
	for i=1:1:Len  q:Err<0  d
	.s TempList=$p(ListData,"&&",i)
	.;s AttrId=##class(web.DHCCKBDicLinkAttr).GetDicAttrId(TempList,i)
	.q:+$p(TempList,"^",2)=0
	.q:+$p(TempList,"^",3)=0
	.q:(repeatFlag=0)&&(..IsExistAttrValueId(TempList)) //kml 2020-01-20 属性值是否存在
	.s AttrId=$p(TempList,"^",1)
	.s EntyId=$p(TempList,"^",2)
	.s AttrCodeId=$p(TempList,"^",3)
	.Q:Err<0
	.i +AttrId="0" d
	..s Err=..InsDicAttr(TempList)				//保存
	..s DicAttrId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",EntyId,AttrCodeId,""),-1)
	..i LgUserID'=""  d
	...s ret=##class(web.DHCCKBWriteLog).InsertDicLogMain("DHC_CKBDicLinkAttr", DicAttrId, "add", LgUserID, "", "", "D", LgHospID, ClientIPAddress,"log",.LogIDList) ///ld  2022-8-17  返回主表ID
	...///s ret=##class(web.DHCCKBWriteLog).InsertDicDataLog(LogID,EntyId,AttrCodeId,TempList,"lastdicdatalog",Type)  ///ld  2022-8-17  日志保存子表
	
	.e  d
	..s Err=..UpdateDicAttr(AttrId,TempList)		//更新
	..i LgUserID'=""  d
	...s ret=##class(web.DHCCKBWriteLog).InsertDicLogMain("DHC_CKBDicLinkAttr", AttrId, "edit", LgUserID, "", "", "D", LgHospID, ClientIPAddress,"log",.LogIDList) ///ld  2022-8-17  返回主表ID
	...///s ret=##class(web.DHCCKBWriteLog).InsertDicDataLog(LogID,EntyId,AttrCodeId,TempList,"lastdicdatalog",Type) ///ld  2022-8-17  日志保存子表
	
	.//d ##class(web.PredictModel).AddOtherName(TempList)	 //kml 2020-07-01 添加别名更新词库
	i ((EntyId'="")&&(AttrCodeId'=""))  d
	.d ##class(web.DHCCKBWriteLog).InsertDicDataLog(LogIDList,EntyId,AttrCodeId,ListData,"lastdicdatalog",Type,Len)
	i Err'=0 tro 
	q:Err'=0 Err
	TC
	Q Err
}

/// Creator：      kemaolin
/// CreatDate：    2020-01-20
/// Description:： 判断datagrid属性值Id是否已经存在
/// Return:        0 不存在，1 存在
/// Table：        CT_CKB_PDSS.DicLinkAttr
/// Others:		   w ##class(web.DHCCKBDicLinkAttr).IsExistAttrValueId("0^142^21333^^^3479897^")
ClassMethod IsExistAttrValueId(TempList)
{
	n (TempList)
	
	s EntyId=$p(TempList,"^",2)  //实体ID
	s EntyAttrId=$p(TempList,"^",3)  //属性ID
	s AttrValueId=$p(TempList,"^",4) //属性值id
	s Result=$p(TempList,"^",5)
	s GroupNum=$p(TempList,"^",6) 	//组号
	s GroupFlag=""
	i $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",EntyId,EntyAttrId))  d
	.s AttrID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",EntyId,EntyAttrId,""))
	.s GroupFlag=$lg(^CT.CKB.PDSS.DicLinkAttrD(AttrID),6)
	Q:(Result="")&&(AttrValueId="")&&($d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",EntyId,EntyAttrId)))&&(GroupFlag=GroupNum) 1
	s tempId=""
	i (AttrValueId'="")&&(GroupNum="") d
	.f  s tempId =$o(^CT.CKB.PDSS.DicLinkAttrI("DicAttr",EntyId,EntyAttrId,tempId)) q:(tempId="")||(tempId=AttrValueId)  d
	q (AttrValueId'="")&&(tempId=AttrValueId)
}

/// Creator：      sufan
/// CreatDate：    2019-11-18
/// Description:： 根据类型存储数据
/// Table：        CT_CKB_PDSS.DicLinkAttr,DHC_CKBCommonDiction
/// &&0^152^42^4048^
/// Others:		   w ##class(web.DHCCKBDicLinkAttr).GetDicAttrId("0^152^42^^",1)
ClassMethod GetDicAttrId(ListData, num)
{
	n (ListData,num)
	s AttrDicId=$p(ListData,"^",2)
	s AttrCodeId=$p(ListData,"^",3)
	s LinkAttrId=$p(ListData,"^",4)
	s GroupFlag=$p(ListData,"^",7)
	s AtrrId=""
	i (LinkAttrId'="")&&(num<3)   d		//这里暂且判断第二条，及别名或者药品的成分，对单位不做判断
	.s:($d(^CT.CKB.PDSS.DicLinkAttrI("DicAttr",AttrDicId,AttrCodeId,LinkAttrId)))&&(GroupFlag="") AtrrId="-1"
	Q:AtrrId'="" AtrrId
	s ItmId=""
	for  s ItmId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",AttrDicId,AttrCodeId,ItmId)) Q:(ItmId="")||(AtrrId'="")  d
	.s linkId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(ItmId)),4)
	.Q:(LinkAttrId'="")&&(linkId'=LinkAttrId)
	.s GroupNum=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(ItmId)),6)
	.Q:GroupFlag'=GroupNum
	.s AtrrId=ItmId
	Q AtrrId
}

/// Creator：      sufan
/// CreatDate：    2019-11-18
/// Description:： 根据类型存储数据
/// Table：        CT_CKB_PDSS.DicLinkAttr,DHC_CKBCommonDiction
/// Others:		   w ##class(web.DHCCKBDicLinkAttr).InsDicAttr("0^70889^26961^^羟甲戊二酰辅酶A还原酶抑制剂")
ClassMethod InsDicAttr(ListData)
{
	n (ListData)
	s Err=0
	TS
	
	///取是否需要存储字典
	s PropId=$p(ListData,"^",3)				//属性Id 如别名等
	s IsSaveDicId=##class(web.DHCCKBCommon).GetIsSaveDic()
	s LinkId=$lg($g(^CT.CKB.PDSS.CommonDictionD(PropId)),5)
	s DicionFlag=""
	i $d(^CT.CKB.PDSS.DicLinkAttrI("DicAttr",PropId,IsSaveDicId))  d
	.s DicionFlag=$o(^CT.CKB.PDSS.DicLinkAttrI("DicAttr",PropId,IsSaveDicId,""))
	i (DicionFlag="")&&(LinkId'="")&&($d(^CT.CKB.PDSS.DicLinkAttrI("DicAttr",LinkId,IsSaveDicId)))  d
	.s DicionFlag=$o(^CT.CKB.PDSS.DicLinkAttrI("DicAttr",LinkId,IsSaveDicId,""))

	
	///保存元素
	i DicionFlag'=""  d
	.s DicCode=$p(ListData,"^",5)
	.s DicId=##class(web.DHCCKBRuleImport).CheckDictionExist(DicCode,DicCode,DicionFlag) //kml 重复判断
	.i +DicId=0  d ;i DicId=""  d  kml
	..s $p(ListData,"^",4)=DicionFlag
	..s Err=..InsDic(ListData)
	.e  d
	..s Err=##class(web.DHCCKBDiction).UdpDiction(DicId,DicionFlag)
	..s:Err=0 Err=DicId
	.i Err<0 tro
	.s DicId=Err
	.s $p(ListData,"^",4)=DicId
	.s $p(ListData,"^",5)=""
	q:Err<0 Err
	
	///保存元素属性
	s Err = ..InsAttr(ListData)
	i Err'=0 tro
	q:Err'=0 "-10"
	TC
	Q Err
}

/// Creator：      sufan
/// CreatDate：    2019-11-18
/// Description:： 保存别名
ClassMethod InsDic(ListData)
{
	n (ListData)
	s DicId=$p(ListData,"^",1)   		//元素ID
	s EntyId=$p(ListData,"^",2)			//实例ID
	s AttrId=$p(ListData,"^",3)			//属性ID
	s DictionId=$p(ListData,"^",4)
	s DicCode=$p(ListData,"^",5) 		//元素code
	s DicDesc=$p(ListData,"^",5) 		//元素code
	;Q:$d(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4(DicCode))) "-1" kml 2020-03-09 重复性判断
	q:+##class(web.DHCCKBDiction).CheckDictionRepeat("",DicCode,DicDesc,DictionId)'=0 "-1" //kml
	&sql(insert into CT_CKB_PDSS.CommonDiction (CD_Code,CD_Desc,CD_Parref_Dr)
	     values (:DicCode,:DicCode,:DictionId))
	Q %ROWID
}

/// Creator：      sufan
/// CreatDate：    2019-11-18
/// Description:： 保存实例别名关联
ClassMethod InsAttr(ListData)
{
	n (ListData)
	s EntyId=$p(ListData,"^",2)			//实例ID
	s AttrCode=$p(ListData,"^",3)		//属性Code
	s AttrId=$p(ListData,"^",4) 		//属性ID
	s Result=$p(ListData,"^",5) 		//备注
	s GroupFlag=$p(ListData,"^",6) 		//同组标识
	&sql(insert into CT_CKB_PDSS.DicLinkAttr (DLA_Dic_Dr,DLA_AttrCode,DLA_Attr_Dr,DLA_Result,DLA_GroupFlag)
	     values (:EntyId,:AttrCode,:AttrId,:Result,:GroupFlag))
	Q SQLCODE
}

/// Creator：      sufan
/// CreatDate：    2019-11-18
/// Description:： 更新字典及关联关系
ClassMethod UpdateDicAttr(AttrId, ListData)
{
	n (AttrId,ListData)
	s Err=0
	TS
	///取是否需要存储字典
	s PropId=$p(ListData,"^",3)				//属性Id 如别名等	
	s IsSaveDicId=##class(web.DHCCKBCommon).GetIsSaveDic()
	s LinkId="",Flag=""
	
	i $d(^CT.CKB.PDSS.DicLinkAttrI("DicAttr",PropId,IsSaveDicId))  d
	.s LinkId=$o(^CT.CKB.PDSS.DicLinkAttrI("DicAttr",PropId,IsSaveDicId,""))
	s:LinkId'="" Flag=$lg($g(^CT.CKB.PDSS.CommonDictionD(LinkId)),2)
	
	///保存元素
	i Flag="Y"  d
	.s DicCode=$p(ListData,"^",5)
	.s UpDicId=$o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4(DicCode),""))
	.s OtherNameId=##class(web.DHCCKBCommon).GetOtherNameId()	//kml
	.i PropId=OtherNameId  d //kml 2020-03-09 别名进行字典级别的重复性判断
	..s DictionId=##class(web.DHCCKBCommon).GetOtherName() //kml
	..s UpDicId=##class(web.DHCCKBRuleImport).CheckDictionExist(DicCode,DicCode,DictionId) //kml
	.s DicId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(AttrId)),4)
	.i +UpDicId=0  d  ;i UpDicId=""  d kml
	..s Err=..UpdateDic(DicId,ListData)
	..s $p(ListData,"^",4)=DicId
	.e  s $p(ListData,"^",4)=UpDicId
	.i Err<0 tro
	.s $p(ListData,"^",5)=""
	q:Err<0 Err
	
	
	///保存元素属性
	s Err = ..UpdateAttr(AttrId,ListData)
	i Err'=0 tro
	q:Err'=0 "-10"
	TC
	Q Err
}

/// Creator：      sufan
/// CreatDate：    2019-11-18
/// Description:： 更新字典
/// Table：        CT_CKB_PDSS.DicLinkAttr,DHC_CKBCommonDiction
ClassMethod UpdateDic(DicId, ListData)
{
	n (DicId,ListData)
	s DicCode=$p(ListData,"^",5)
	Q:$d(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4(DicCode))) "-1"
	&sql(update CT_CKB_PDSS.CommonDiction set CD_Code=:DicCode,CD_Desc=:DicCode where CD_RowID=:DicId)
	Q SQLCODE
}

/// Creator：      sufan
/// CreatDate：    2019-11-18
/// Description:： 根据类型存储数据
/// Table：        CT_CKB_PDSS.DicLinkAttr,DHC_CKBCommonDiction
ClassMethod UpdateAttr(AttrId, ListData)
{
	n (AttrId,ListData)
	s EntyId=$p(ListData,"^",2)			//实例ID
	s AttrCodeId=$p(ListData,"^",3)		//属性ID
	s LinkAttrId=$p(ListData,"^",4) 	//元素code
	s ResText=$p(ListData,"^",5) 		//元素code	
	&sql(update CT_CKB_PDSS.DicLinkAttr set DLA_Dic_Dr=:EntyId,DLA_AttrCode=:AttrCodeId,DLA_Attr_Dr=:LinkAttrId,DLA_Result=:ResText where DLA_RowID=:AttrId)
	Q SQLCODE
}

/// Creator：      sufan
/// CreatDate：    2019-11-18
/// Description:： 查询datagrid数据
/// Table：        CT_CKB_PDSS.DicLinkAttr,DHC_CKBCommonDiction
/// Others:		   w ##class(web.DHCCKBDicLinkAttr).QueryEntyAttr("30","1","142^40","datagrid","")
ClassMethod QueryEntyAttr(rows = 10, page = 1, params As %String, Type = "", dicCode = "")
{
	n (rows,page,params,Type,dicCode)

	i params = "" q ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)	
	//s ^temptest("147")=$lb(rows,page,params,Type,dicCode)
	s End = page*rows
	s Start=(page-1)*rows+1
	s EndPage=page*rows  //结束行
	s StPage=((page-1)*rows)+1     //开始行
	s pid=##Class(web.DHCCKBCommonUtil).NewPid()	
	d ..killTmpGlobal(pid)  
	s EntyId=$p(params,"^",1)
	s Attrcode=$p(params,"^",2)
	s LinkId=$lg($g(^CT.CKB.PDSS.CommonDictionD(Attrcode)),5)
	s count=0,num=0
	s h=0
	s LinkPropId=##class(web.DHCCKBCommon).GetLinkProp()
	if Type="datagrid"  d
	.if $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",Attrcode,LinkPropId)) d
	..s LinkAttrId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",Attrcode,LinkPropId,""))
	..s ParrPorpId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(LinkAttrId)),4)
	..s subId=""
	..for  s subId=$o(^CT.CKB.PDSS.CommonDictionI("Parref",ParrPorpId,subId))  Q:subId=""  d
	...s dlaRowId=""
	...for  s dlaRowId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",EntyId,subId,dlaRowId))  Q:dlaRowId=""  d
	....s dicAttrCode=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(dlaRowId)),3)	//知识类别 
	....s dicAttrId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(dlaRowId)),4)			//属性ID
	....s dicRes=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(dlaRowId)),5)				//备注
	....s dicGroupFlag=+$lg($g(^CT.CKB.PDSS.DicLinkAttrD(dlaRowId)),6)		//成组标识
	....i dicAttrId'="" s ListData=dicAttrId_"^"_$lg($g(^CT.CKB.PDSS.CommonDictionD(dicAttrId)),3)
	....e  s ListData="^"_dicRes
	....i $d(^TMP("DHCCKB","web.DHCCKBDicLinkAttr","QueryEntyAttr",pid,dicGroupFlag))  d
	.....s ^TMP("DHCCKB","web.DHCCKBDicLinkAttr","QueryEntyAttr",pid,dicGroupFlag)=^TMP("DHCCKB","web.DHCCKBDicLinkAttr","QueryEntyAttr",pid,dicGroupFlag)_"^"_ListData
	.....s $p(^TMP("DHCCKB","web.DHCCKBDicLinkAttr","QueryEntyAttr",pid,dicGroupFlag),"^",1)=$p(^TMP("DHCCKB","web.DHCCKBDicLinkAttr","QueryEntyAttr",pid,dicGroupFlag),"^",1)_"&"_dlaRowId
	....e  d
	.....s ^TMP("DHCCKB","web.DHCCKBDicLinkAttr","QueryEntyAttr",pid,dicGroupFlag)=dlaRowId_"^"_ListData
	....s h=h+1
	.e  if (LinkId'="")&&($d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",LinkId,LinkPropId))) d
	..s LinkAttrId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",LinkId,LinkPropId,""))
	..s ParrPorpId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(LinkAttrId)),4)
	..s subId=""
	..for  s subId=$o(^CT.CKB.PDSS.CommonDictionI("Parref",ParrPorpId,subId))  Q:subId=""  d
	...s dlaRowId=""
	...for  s dlaRowId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",EntyId,subId,dlaRowId))  Q:dlaRowId=""  d
	....s dicAttrCode=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(dlaRowId)),3)		//知识类别 
	....s dicAttrId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(dlaRowId)),4)			//属性ID
	....s dicRes=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(dlaRowId)),5)				//备注
	....s dicGroupFlag=+$lg($g(^CT.CKB.PDSS.DicLinkAttrD(dlaRowId)),6)		//成组标识
	....i dicAttrId'="" s ListData=dicAttrId_"^"_$lg($g(^CT.CKB.PDSS.CommonDictionD(dicAttrId)),3)
	....e  s ListData="^"_dicRes
	....i $d(^TMP("DHCCKB","web.DHCCKBDicLinkAttr","QueryEntyAttr",pid,dicGroupFlag))  d
	.....s ^TMP("DHCCKB","web.DHCCKBDicLinkAttr","QueryEntyAttr",pid,dicGroupFlag)=^TMP("DHCCKB","web.DHCCKBDicLinkAttr","QueryEntyAttr",pid,dicGroupFlag)_"^"_ListData
	.....s $p(^TMP("DHCCKB","web.DHCCKBDicLinkAttr","QueryEntyAttr",pid,dicGroupFlag),"^",1)=$p(^TMP("DHCCKB","web.DHCCKBDicLinkAttr","QueryEntyAttr",pid,dicGroupFlag),"^",1)_"&"_dlaRowId
	....e  d
	.....s ^TMP("DHCCKB","web.DHCCKBDicLinkAttr","QueryEntyAttr",pid,dicGroupFlag)=dlaRowId_"^"_ListData
	....s h=h+1
	.e  d			//未关联属性的
	..s dlaRowId=""
	..for  s dlaRowId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",EntyId,Attrcode,dlaRowId))  Q:dlaRowId=""  d
	...s dicAttrCode=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(dlaRowId)),3)		//知识类别 
	...s dicAttrId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(dlaRowId)),4)		//属性ID
	...s dicRes=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(dlaRowId)),5)			//备注
	...s dicGroupFlag=+$lg($g(^CT.CKB.PDSS.DicLinkAttrD(dlaRowId)),6)	//成组标识
	...i +dicAttrId'="0" s ListData=dicAttrId_"^"_$lg($g(^CT.CKB.PDSS.CommonDictionD(dicAttrId)),3)
	...e  s ListData=dicAttrId_"^"_dicRes
	...s num=num+1
	...s ^TMP("DHCCKB","web.DHCCKBDicLinkAttr","QueryEntyAttr",pid,num)=dlaRowId_"^"_ListData
	...s h=h+1
	e  d
	.s AttrId=""
	.for  s AttrId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",EntyId,Attrcode,AttrId))  Q:AttrId=""  d
	..s dicAttrCode=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(AttrId)),3)
	..s dicAttrId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(AttrId)),4)
	..s dicRes=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(AttrId)),5)
	..s dicGroupFlag=+$lg($g(^CT.CKB.PDSS.DicLinkAttrD(AttrId)),6)
	..i dicAttrId'="" s ListData=dicAttrId_"^"_$lg($g(^CT.CKB.PDSS.CommonDictionD(dicAttrId)),3)
	..e  s ListData=dicAttrId_"^"_dicRes
	..s h=h+1
	..s ^TMP("DHCCKB","web.DHCCKBDicLinkAttr","QueryEntyAttr",pid,h)=AttrId_"^"_ListData
	q:h=0 ##class(web.DHCEMJsonCommon).getJsonEmptySign(h) //输出json结尾符
	
	///转换数据为Json格式
	w "["
	if $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",Attrcode,LinkPropId))  d
	.s title="Id^"_##class(web.DHCCKBDicLinkAttr).getTileList(Attrcode)_"^dicGroupFlag"
	e  i (LinkId'="")&&($d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",LinkId,LinkPropId)))  d
	.s title="Id^"_##class(web.DHCCKBDicLinkAttr).getTileList(LinkId)_"^dicGroupFlag"
	e  d
	.s title="Id^"_##class(web.DHCCKBDicLinkAttr).getTileList(Attrcode)_"^dicGroupFlag"
	;b   //11
	
	s index=""
	for  s index=$o(^TMP("DHCCKB","web.DHCCKBDicLinkAttr","QueryEntyAttr",pid,index)) q:index=""  d
	.s mdata=$g(^TMP("DHCCKB","web.DHCCKBDicLinkAttr","QueryEntyAttr",pid,index))_"^"_index
	.s count = count+1
	.q:(count<Start)||(count>End)
	.i count=Start d
	..w ##class(web.DHCEMJsonCommon).getJsonData(title,mdata)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(title,mdata)
	w "]"
	d ..killTmpGlobal(pid)  
	q ""
}

/// Description:获取动态输出列标题
/// Others:		   w ##class(web.DHCCKBDicLinkAttr).getTileList(26961)
ClassMethod getTileList(Attrcode)
{
	n (Attrcode)
	s titleList=""
	s LinkPropId=##class(web.DHCCKBCommon).GetLinkProp()
	if $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",Attrcode,LinkPropId))  d			//按照属性关联取数据
	.s LinkAttrId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",Attrcode,LinkPropId,""))
	.s ParrPorpId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(LinkAttrId)),4)
	.s subId=""
	.for  s subId=$o(^CT.CKB.PDSS.CommonDictionI("Parref",ParrPorpId,subId))  Q:subId=""  d
	..s title=$lg($g(^CT.CKB.PDSS.CommonDictionD(subId)),2)
	..s linkId = $lg($g(^CT.CKB.PDSS.CommonDictionD(subId)),5)
	..s:(title="")&&(linkId'="") title=$lg($g(^CT.CKB.PDSS.CommonDictionD(linkId)),2)
	..s dataType=##class(web.DHCCKBRangeCat).GetAddAttrCode(subId,"DataTypeProp")
	..i titleList="" s titleList=title_"Id"_"^"_title
	..e  s titleList=titleList_"^"_title_"Id"_"^"_title
	e  d
	.s LinkId=$lg($g(^CT.CKB.PDSS.CommonDictionD(Attrcode)),5)
	.s:LinkId'="" Attrcode=LinkId
	.s title=$lg($g(^CT.CKB.PDSS.CommonDictionD(Attrcode)),2)
	.s titleList=title_"Id"
	.i titleList="" s titleList=title_"Id"_"^"_title
	.e  s titleList=titleList_"^"_title
	
	Q titleList
}

/// Creator：      sufan
/// CreatDate：    2019-11-18
/// Description:： 查询datagrid数据
/// Table：        CT_CKB_PDSS.DicLinkAttr,DHC_CKBCommonDiction
/// Others:		   w ##class(web.DHCCKBDicLinkAttr).QueryGridData(10,1,"77^91")
ClassMethod QueryTextData(params)
{
	n (params)
	s EntyId=$p(params,"^",1)
	s Attrcode=$p(params,"^",2)
	s attrID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",EntyId,Attrcode,""))
	s Result=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(attrID)),5)
	Q Result
}

/// Creator：      sufan
/// CreatDate：    2019-11-18
/// Description:： 按类型删除数据
/// Table：        CT_CKB_PDSS.DicLinkAttr,CT_CKB_PDSS.CommonDiction
/// Others:		   w ##class(web.DHCCKBDicLinkAttr).DelData(10,1,"77^91")
ClassMethod DelData(params)
{
	n (params)
	s Len=$l(params,"&")
	s Err=0
	for i=1:1:Len  q:Err'=0  d
	.s Id=$p(params,"&",i)
	.&sql(delete from CT_CKB_PDSS.DicLinkAttr where DLA_RowID=:Id)
	.s Err=SQLCODE
	.Q:Err'=0
	Q Err
}

/// Creator：      sufan
/// CreatDate：    2019-11-18
/// Description:： 保存文本数据
/// Table：        CT_CKB_PDSS.DicLinkAttr,DHC_CKBCommonDiction
/// Others:		   w ##class(web.DHCCKBDicLinkAttr).saveTextData("0^109163^78015^^国药准字H61022860","11864","2","113.140.81.66","text")
ClassMethod saveTextData(ListData, LgUserID, LgHospID, ClientIPAddress, Type)
{
	n (ListData,LgUserID,LgHospID,ClientIPAddress,Type)
	s LogIDList=""
	s EntyId=""
	s AttrCodeId=""
	;s ^TMP("shy")=ListData  ;$lb(ListData,LgUserID,LgHospID,ClientIPAddress,Type)_"@@"_"Yes"
	TS
	s Err=0
	s Len=$l(ListData,"&&")
	for i=1:1:Len  Q:Err'=0  d
	.s tempList=$p(ListData,"&&",i)
	.s EntyId=$p(tempList,"^",2)
	.s AttrCodeId=$p(tempList,"^",3)
	.s AttrValue = $p(tempList,"^",5)
	.q:EntyId="" 
	.s DicAttrId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",EntyId,AttrCodeId,""))
	.i +DicAttrId="0"  d
	..s Err=..InsTreeText(tempList)
	..s DicAttrId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",EntyId,AttrCodeId,""))
	..i LgUserID'=""  d
	...s ret=##class(web.DHCCKBWriteLog).InsertDicLogMain("DHC_CKBDicLinkAttr", DicAttrId, "add", LgUserID, "", "", "D", LgHospID, ClientIPAddress,"log",.LogIDList)  ///ld  2022-8-17 返回主表ID 
	...///s ret=##class(web.DHCCKBWriteLog).InsertDicDataLog(logID,EntyId,AttrCodeId,tempList,"lastdicdatalog",Type)   ///ld  2022-8-17 日志保存子表
	.e  d
	..s Err=..UpdText(DicAttrId,ListData)
	..i LgUserID'=""  d
	...s ret=##class(web.DHCCKBWriteLog).InsertDicLogMain("DHC_CKBDicLinkAttr", DicAttrId, "edit", LgUserID, "", "", "D", LgHospID, ClientIPAddress,"log",.LogIDList)  ///ld  2022-8-17 返回主表ID 
	...///s ret=##class(web.DHCCKBWriteLog).InsertDicDataLog(logID,EntyId,AttrCodeId,tempList,"lastdicdatalog",Type)  ///ld  2022-8-17  日志保存子表
	i ((EntyId'="")&&(AttrCodeId'=""))  d
	.d ##class(web.DHCCKBWriteLog).InsertDicDataLog(LogIDList,EntyId,AttrCodeId,ListData,"lastdicdatalog",Type,Len)
	i Err'=0 tro
	Q:Err'=0 Err
	TC
	Q Err
}

/// Creator：      sufan
/// CreatDate：    2019-11-18
/// Description:： 保存文本数据
/// Table：        CT_CKB_PDSS.DicLinkAttr,DHC_CKBCommonDiction
/// Others:		   w ##class(web.DHCCKBDicLinkAttr).InsTreeText("130^104^3333")
ClassMethod InsTreeText(ListData)
{
	n (ListData)
	s Err=0
	TS
	
	///保存元素
	;s NodeId=$p(ListData,"^",5)
	;i NodeId'="" d
	;.s Err=..DelTree(ListData)
	;i Err<0 tro
	;q:Err<0 Err
	
	///保存元素属性
	s Err = ..InsText(ListData)
	i Err'=0 tro
	q:Err'=0 Err
	TC
	Q Err
}

/// Creator：      sufan
/// CreatDate：    2019-11-18
/// Description:： 保存前先删除之前选择的内容
/// Table：        CT_CKB_PDSS.DicLinkAttr,CT_CKB_PDSS.CommonDiction
/// Others:		   w ##class(web.DHCCKBDicLinkAttr).InsText("130^104^3333")
ClassMethod DelTree(ListData)
{
	n (ListData)
	s EntyId=$p(ListData,"^",2)			//实例ID
	s AttrId=$p(ListData,"^",3)			//属性ID
	&sql(delete from CT_CKB_PDSS.DicLinkAttr where DLA_Dic_Dr=:EntyId and DLA_AttrCode=:AttrId)
	Q SQLCODE
}

/// Creator：      sufan
/// CreatDate：    2021-04-06
/// Description:： 批量关联药品分类
/// Table：        CT_CKB_PDSS.DicLinkAttr,DHC_CKBCommonDiction
/// Others:		   w ##class(web.DHCCKBDicLinkAttr).InsMulPhacla("^78331^38^858^","11871^8^1^289^2","111.19.92.206")
ClassMethod InsMulPhacla(listData, loginInfo, ClientIP)
{
	n (listData,loginInfo,ClientIP)
	s userID = $p(loginInfo,"^",1)
	s hospID = $p(loginInfo,"^",5)
	s ^temptest("5678")=$lb(listData,loginInfo,ClientIP)
	s len = $l(listData,"&&")
	s err = 0,existFlag = 0

	TS
	for i=1:1:len  Q:err<0   d
	.s tempList = $p(listData,"&&",i)
	.s EntyId = $p(tempList,"^",2)				//实例ID
	.s AttrCode = $p(tempList,"^",3)			//属性ID
	.s AttrId = $p(tempList,"^",4)	
	.Q:$d(^CT.CKB.PDSS.DicLinkAttrI("DicAttr",EntyId,AttrCode,AttrId))
	.s err = ..InsText(tempList,"ROWID")
	.Q:err<0 
	.s ret=##class(web.DHCCKBWriteLog).InsertDicLog("DHC_CKBDicLinkAttr", err, "add", userID, "", "", "D", hospID, ClientIP,"log") // 增加日志 qnp 2021/5/13
	
	i err<0 TRO
	Q:err<0 err
	TC
	Q 0
}

/// Creator：      sufan
/// CreatDate：    2019-11-18
/// Description:： 保存文本数据
/// Table：        CT_CKB_PDSS.DicLinkAttr,DHC_CKBCommonDiction
/// Others:		   w ##class(web.DHCCKBDicLinkAttr).InsText("130^104^3333")
ClassMethod InsText(ListData, type = "")
{
	n (ListData,type)
	s EntyId=$p(ListData,"^",2)				//实例ID
	s AttrCode=$p(ListData,"^",3)			//属性ID
	s AttrId=$p(ListData,"^",4)				//属性ID
	s TextContent=$p(ListData,"^",5)		//值域
	s Html = $p(ListData,"^",6)				//带html标签的值
	&sql(insert into CT_CKB_PDSS.DicLinkAttr (DLA_Dic_Dr,DLA_AttrCode,DLA_Attr_Dr,DLA_Result,DLA_TinyTag)
		values(:EntyId,:AttrCode,:AttrId,:TextContent,:Html))
	
	q:type="ROWID" %ROWID	// 增加type,用于获取新增的id qnp 2021/5/13
	
	Q SQLCODE
}

/// Creator：      sufan
/// CreatDate：    2019-11-18
/// Description:： 保存文本数据
/// Table：        CT_CKB_PDSS.DicLinkAttr,DHC_CKBCommonDiction
/// Others:		   w ##class(web.DHCCKBDicLinkAttr).InsText(854565,"0^81646^125313^^测试阿萨德")
ClassMethod UpdText(DicAttrId, ListData)
{
	n (DicAttrId,ListData)
	s ^TMP("ld","web.DHCCKBDicLinkAttr","InsText")=$lb(DicAttrId, ListData)
	s EntyId=$p(ListData,"^",2)			//实例ID
	s AttrCode=$p(ListData,"^",3)			//属性ID
	s AttrId=$p(ListData,"^",4)	
	s TextContent=$p(ListData,"^",5)	//值域
	s Html = $p(ListData,"^",6)			//带html标签的值
	i Html=""  d
	.s Html=$replace(TextContent," ","&nbsp")
	.s Html=$replace(Html,"	","&nbsp&nbsp&nbsp&nbsp")
	.s Html=$replace(Html,$c(10),"<br>")
	.s Html=$replace(Html,$c(10,10),"<br><br>")
	&sql(update CT_CKB_PDSS.DicLinkAttr set DLA_Attr_Dr=:AttrId,DLA_Result=:TextContent,DLA_TinyTag=:Html where DLA_RowID=:DicAttrId)
	Q SQLCODE
}

/// Creator：      sufan
/// CreatDate：    2019-11-18
/// Description:： 取已经保存的实体属性
/// Table：        CT_CKB_PDSS.DicLinkAttr,DHC_CKBCommonDiction
/// Others:		   w ##class(web.DHCCKBDicLinkAttr).QueryEntyLinkAttr(98,85)
ClassMethod QueryEntyLinkAttr(EntyId, AttrCode)
{
	n (EntyId,AttrCode)

	s LinkAttrId="",ArrrList=""
	for  s LinkAttrId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",EntyId,AttrCode,LinkAttrId))  Q:LinkAttrId=""  d
	.s AttrId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(LinkAttrId)),4)
	.i ArrrList="" s ArrrList=AttrId
	.e  s ArrrList=ArrrList_","_AttrId
	Q ArrrList
}

/// Creator：      sufan
/// CreatDate：    2019-11-22
/// Description:： 取指定属性的数据源
/// Input:		   属性ID
/// Return:		   数据源ID
/// Table：        CT_CKB_PDSS.DicLinkAttr,DHC_CKBCommonDiction
/// Others:		   w ##class(web.DHCCKBDicLinkAttr).GetDataSource(81224)
ClassMethod GetDataSource(AttrId)
{
	n (AttrId)
	s DatasouId=##class(web.DHCCKBCommon).GetDataSource()    //数据源ID
	s DataTypeId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",AttrId,DatasouId,""))
	Q:DataTypeId="" ""
	Q DataTypeId
}

/// Creator：      sufan
/// CreatDate：    2019-11-27
/// Description:： 取配置的datagrid列
/// Input:		   属性代码
/// Return:		   配置的datagrid列
/// Table：        CT_CKB_PDSS.DicLinkAttr,CT_CKB_PDSS.CommonDiction
/// w ##class(web.DHCCKBDicLinkAttr).GetColumnsByDicCode("","GenerNameFDAProp")
ClassMethod GetColumnsByDicCode(AttrcodeId, DicCode)
{
	n (AttrcodeId,DicCode)
	//先判断属性关联，若未关联属性，取本身
	//取属性关联数据
	i AttrcodeId="" s AttrcodeId=$o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4(DicCode),""))
	Q:AttrcodeId="" ""
	s LinkPropId=##class(web.DHCCKBCommon).GetLinkProp()

	if $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",AttrcodeId,LinkPropId))  d
	.s dlaRowId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",AttrcodeId,LinkPropId,""))
	.s AttrId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(dlaRowId)),4)
	.d ..QueryCloByLink(AttrId)
	e  d
	.s AttrId=AttrcodeId
	.d ..QueryCloByDic(AttrId)
	Q ""
}

/// 取属性关联的列数据
ClassMethod QueryCloByLink(AttrId)
{
	n (AttrId)
	s count=1
	w "{""rows"":["
	s tmpObj={}
	//初始化Id串
	d tmpObj.%Set("Code","Id") d tmpObj.%Set("Desc","Id") d tmpObj.%Set("hidden","true") d tmpObj.%Set("edtstr","") d tmpObj.%Set("datatype","") 
	w tmpObj.%ToJSON()
	s DicId=""
	for  s DicId=$o(^CT.CKB.PDSS.CommonDictionI("Parref",AttrId,DicId))  Q:DicId=""  d
	.s Code=$lg($g(^CT.CKB.PDSS.CommonDictionD(DicId)),2)
	.s Desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(DicId)),3)
	.s LinkId=$lg($g(^CT.CKB.PDSS.CommonDictionD(DicId)),5)
	.s:(Code="")&&(LinkId'="") Code=$lg($g(^CT.CKB.PDSS.CommonDictionD(LinkId)),2)
	.s:(Desc="")&&(LinkId'="") Desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(LinkId)),3)
	.s hidden="false"
	.//取数据源
	.s Datasource=##class(web.DHCCKBRangeCat).GetAddAttrSource(DicId,"DataSource")
	.s Datatype=##class(web.DHCCKBRangeCat).GetAddAttrCode(DicId,"DataTypeProp")
	.s edtstr=..GeteditData(Datasource,Datatype)
	.s count=count+1
	.w $case(count,1:",",:",")
	.i (Datatype="combobox")  d
	..d tmpObj.%Set("Code",Code_"Id") 
	..d tmpObj.%Set("Desc",Code_"Id") 
	..d tmpObj.%Set("hidden","true") 
	..d tmpObj.%Set("edtstr","") 
	..d tmpObj.%Set("datatype","")
	..w tmpObj.%ToJSON()
	..w ","
	..s count=count+1
	.s tmpObj.Code=Code
	.s tmpObj.Desc=Desc
	.s tmpObj.hidden="false"
	.s tmpObj.edtstr=edtstr
	.s tmpObj.datatype=Datatype
	.w tmpObj.%ToJSON()
	
	///输出组表示
	w ","
	s tmpObj.Code="dicGroupFlag"
	s tmpObj.Desc="dicGroupFlag"
	s tmpObj.hidden="false"
	s tmpObj.edtstr=""
	s tmpObj.datatype=""
	w tmpObj.%ToJSON()
	s count=count+1 
	w "],""total"":"_count_"}"
}

/// 取本身列数据
ClassMethod QueryCloByDic(AttrId)
{
	n (AttrId)
	w "{""rows"":["
	s count=1
	s tmpObj={}
	//初始化Id串
	d tmpObj.%Set("Code","Id") d tmpObj.%Set("Desc","Id") d tmpObj.%Set("hidden","true") d tmpObj.%Set("edtstr","") d tmpObj.%Set("datatype","") 
	w tmpObj.%ToJSON()
	s Code=$lg($g(^CT.CKB.PDSS.CommonDictionD(AttrId)),2)
	s Desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(AttrId)),3)
	s hidden="false"
	//取数据源
	w ","
	s Datasource=##class(web.DHCCKBRangeCat).GetAddAttrSource(AttrId,"DataSource")
	s Datatype=##class(web.DHCCKBRangeCat).GetAddAttrCode(AttrId,"DataTypeProp")
	s:Datasource'="" Datatype="combobox"    //对于没有属性关联的,若维护了数据源，按照下拉框格式走
	s edtstr=..GeteditData(Datasource,Datatype)
	i (Datatype="combobox")  d
	.d tmpObj.%Set("Code",Code_"Id") 
	.d tmpObj.%Set("Desc",Code_"Id") 
	.d tmpObj.%Set("hidden","true") 
	.d tmpObj.%Set("edtstr","") 
	.d tmpObj.%Set("datatype","")
	.w tmpObj.%ToJSON()
	.s count=count+1
	.w ","
	s tmpObj.Code=Code
	s tmpObj.Desc=Desc
	s tmpObj.hidden="false"
	s tmpObj.edtstr=edtstr
	s tmpObj.datatype=Datatype
	w tmpObj.%ToJSON()
	s count=count+1
	///输出组表示
	w ","
	s tmpObj.Code="dicGroupFlag"
	s tmpObj.Desc="dicGroupFlag"
	s tmpObj.hidden="false"
	s tmpObj.edtstr=""
	s tmpObj.datatype=""
	w tmpObj.%ToJSON()
	s count=count+1
	w "],""total"":"_count_"}"
}

/// Creator：      sufan
/// CreatDate：    2019-11-27
/// Description:： 每列的数据类型
/// Input:		   属性代码
/// Return:		   配置的datagrid列
/// Table：        CT_CKB_PDSS.DicLinkAttr,DHC_CKBCommonDiction
/// w ##class(web.DHCCKBDicLinkAttr).GeteditData(7,"OtherName")
ClassMethod GeteditData(Datasource, Datatype)
{
	n (Datasource,Datatype)
	Q ""
	s str=""
	i Datasource'=""  d
	.s type=Datatype
	.s valueField="value"
	.s textField="text"
	.s editable="false"
	.s panelHeight="160"
	.s url="ClassName=web.DHCCKBDicLinkAttr&MethodName=GetDataCombo&DataSource="_Datasource
	.s str=type_"@"_valueField_"@"_textField_"@"_editable_"@"_panelHeight_"@"_url
	Q str
}

/// Creator：      sufan
/// CreatDate：    2019-11-27
/// Description:： 取数据源下的所有数据
/// Input:		   属性代码
/// Return:		   配置的datagrid列
/// Table：        CT_CKB_PDSS.DicLinkAttr,CT_CKB_PDSS.CommonDiction
/// w ##class(web.DHCCKBDicLinkAttr).GetDataCombo("131753","","")
ClassMethod GetDataCombo(DataSource, filed = "", q = "")
{
	n (DataSource,filed,q)
	s ^temptest("333")=$lb(DataSource,filed,q)
	s q=$zcvt(q,"U")
	s count=0
	w "["
	
	f k=1:1:$l(DataSource,",") d
	.s TmpDataSource = $p(DataSource,",",k)
	.s AttrID=""
	.for  s AttrID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",TmpDataSource,AttrID)) Q:AttrID=""  d
	..s Desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(AttrID)),3)
	..s Alias=""
	..i q'="" d
	...s Alias=##class(web.DHCCKBRuleIndex).GetDrugAlias(AttrID,q)
	..i Alias'="" s Desc=Desc_"("_Alias_")"
	..s QueDesc=$zcvt(Desc,"U")
	..s QueCode="" //##class(web.DHCCKBCommonUtil).GetPYCODE(Desc)	// qunianpeng 取拼音码导致前台查询慢,暂时注释 2020-04-28
	..s QueCode=QueDesc_QueCode
	..Q:(q'="")&&(QueCode'[q)
	..s tmp=AttrID_"^"_Desc_"^"_filed
	..s count = count+1
	..Q:(q="")&&(count>200)
	..i count=1 d
	...w ##class(web.DHCEMJsonCommon).getJsonData("value^text^filed",tmp)
	..e  d
	...w ","_##class(web.DHCEMJsonCommon).getJsonData("value^text^filed",tmp)
	w "]"
	Q ""
}

/// Creator:    sufan
/// CreateDate: 2019-11-27
/// Descript:	获取数据源或者数据类型的code
/// Input：     实体ID,属性关联CODE
/// Return:		各个数据的类型
/// w ##class(web.DHCCKBDicLinkAttr).GetAddAttrCode("IngredientCode","","DataTypeProp","")
ClassMethod GetAddAttrCode(queryCode = "", queryDicID = "", AttrLinkCode, AttrId = "")
{
	n (queryCode,queryDicID,AttrLinkCode,AttrId)
	
	i queryDicID="" s queryDicID=$o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4(queryCode),""))
	Q:queryDicID="" ""
	s queryId=""
	i AttrId'=""  d
	.s queryId=##class(web.DHCCKBRangeCat).GetFirstLev(AttrId)
	Q:(queryId'="")&&($lg($g(^CT.CKB.PDSS.CommonDictionD(queryId)),2)["ExtraProp") ""
	s TypeList=""
	s DatetypeId=$o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4(AttrLinkCode),""))
	s LinkId=""
	for  s LinkId=$o(^CT.CKB.PDSS.DicLinkAttrI("DicAttr",queryDicID,DatetypeId,LinkId))  Q:LinkId=""  d
	.Q:LinkId=""
	.s TypeCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(LinkId)),2)
	.i TypeList="" s TypeList=TypeCode
	.e  s TypeList=TypeList_"^"_TypeCode
	Q TypeList
}

/// Description：获取各列的编辑格式
/// w ##class(web.DHCCKBDicLinkAttr).getEditors("Id&&IngredientCodeId&&IngredientCode&&IngredientMete&&IngredientUnitId&&IngredientUnit&&dicGroupFlag")
ClassMethod getEditors(FiledList)
{
	n (FiledList)

	s columns=[]
	s Len=$l(FiledList,"&&")
	for i=1:1:Len  d
	.s Filed=$p(FiledList,"&&",i)
	.s editors=..GetAddAttrCode(Filed,"","DataTypeProp")
	.s column={}
	.s source=##class(web.DHCCKBRangeCat).GetAddAttrSource("","DataSource","",Filed)  
	.s column.source=source
	.s column.Filed=Filed
	.s:source'="" editors="combobox"   //这里指定数据源不为空的为下拉框格式，因为不走属性关联的，默认取本身，本身的格式和实际列的格式不一致
	.s column.editors=editors
	.d columns.%Push(column)
	w columns.%ToJSON()
	Q ""
}

/// Creator:    sufan
/// CreateDate: 2019-12-02
/// Descript:	保存之前重新组织数据
/// Input：     
/// Return:	
/// w ##class(web.DHCCKBDicLinkAttr).dealListData(1,"0^196^42^^&&^196^42^4023^GenerNamePropId^0^","datagrid")	
ClassMethod dealListData(pid, ListData, Type)
{
	n (pid,ListData,Type)
	s Len=$l(ListData,"&&")
	s QuitList=""
	s EntyId=$p($p(ListData,"&&",1),"^",2)    //实体ID	 具体药品，阿莫西林等
	s AttrId=$p($p(ListData,"&&",1),"^",3)    //属性ID   如成分，别名等
	s LinkPropId=##class(web.DHCCKBCommon).GetLinkProp()
	
	if Type="datagrid"  d   //grid数据处理
	.s LinkId=$lg($g(^CT.CKB.PDSS.CommonDictionD(AttrId)),5)
	.if $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",AttrId,LinkPropId)) d
	..for i=1:1:Len  d
	...Q:i<=1
	...s TempStr=$p(ListData,"&&",i)
	...s Idstr=$p(TempStr,"^",1)	//id
	...i +Idstr'=0  d
	....s Id=$p(Idstr,"&",i-1)
	...e   s Id=+Idstr		 
	...s AttrValueId=$p(TempStr,"^",4)		 //值
	...s AttrCode=$p(TempStr,"^",5)			 //值title
	...s ResText=""							 //备注
	...i $e(AttrCode,$l(AttrCode)-1,$l(AttrCode))="Id" s AttrCode=$e(AttrCode,1,$l(AttrCode)-2)
	...s DataType=##class(web.DHCCKBDicLinkAttr).GetAddAttrCode(AttrCode,"","DataTypeProp")
	...s source=##class(web.DHCCKBRangeCat).GetAddAttrSource("","DataSource","",AttrCode)
	...s:source'="" DataType="combobox"
	...i DataType'="combobox"  d
	....s ResText=AttrValueId				//文本
	....s AttrValueId=""
	...s AttrDicId=##class(web.DHCCKBDicLinkAttr).GetTempAttrId(AttrId,AttrCode)		//$o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4(AttrCode),""))
	...s GroupNum=$p(TempStr,"^",6)
	...s GroupFlag=$p(TempStr,"^",7)
	...s params=Id_"^"_EntyId_"^"_AttrDicId_"^"_AttrValueId_"^"_ResText_"^"_(pid+GroupNum)_"^"_GroupFlag
	...i QuitList="" s QuitList=Id_"^"_EntyId_"^"_AttrId_"^^^^"_"&&"_params
	...e  s QuitList=QuitList_"&&"_params
	.e  if (LinkId'="")&&($d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",LinkId,LinkPropId))) d
	..for i=1:1:Len  d
	...Q:i<=1
	...s TempStr=$p(ListData,"&&",i)
	...s Idstr=$p(TempStr,"^",1)	//id
	...i +Idstr'=0  d
	....s Id=$p(Idstr,"&",i-1)
	...e   s Id=+Idstr				 
	...s AttrValueId=$p(TempStr,"^",4)		 //值
	...s AttrCode=$p(TempStr,"^",5)			 //值title
	...s ResText=""							 //备注
	...i $e(AttrCode,$l(AttrCode)-1,$l(AttrCode))="Id" s AttrCode=$e(AttrCode,1,$l(AttrCode)-2)
	...s DataType=##class(web.DHCCKBDicLinkAttr).GetAddAttrCode(AttrCode,"","DataTypeProp")
	...s source=##class(web.DHCCKBRangeCat).GetAddAttrSource("","DataSource","",AttrCode)
	...s:source'="" DataType="combobox"
	...i DataType'="combobox"  d
	....s ResText=AttrValueId				//文本
	....s AttrValueId=""
	...s AttrDicId=$o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4(AttrCode),""))
	...s GroupNum=$p(TempStr,"^",6)
	...s GroupFlag=$p(TempStr,"^",7)
	...s params=Id_"^"_EntyId_"^"_AttrDicId_"^"_AttrValueId_"^"_ResText_"^"_(pid+GroupNum)_"^"_GroupFlag
	...i QuitList="" s QuitList=Id_"^"_EntyId_"^"_AttrId_"^^^^"_"&&"_params
	...e  s QuitList=QuitList_"&&"_params
	.e  d							  //组织数据串 实体属性直接关联
	..for i=1:1:Len  d
	...Q:i<=1
	...s TempStr=$p(ListData,"&&",i)
	...s Idstr=$p(TempStr,"^",1)	//id
	...i +Idstr'=0  d
	....s Id=$p(Idstr,"&",i-1)
	...e   s Id=+Idstr	
	...s AttrValueId=$p(TempStr,"^",4)
	...s AttrCode=$p(TempStr,"^",5)			 //值title
	...s ResText=""							 //备注
	...i $e(AttrCode,$l(AttrCode)-1,$l(AttrCode))="Id" s AttrCode=$e(AttrCode,1,$l(AttrCode)-2)
	...s DataType=##class(web.DHCCKBDicLinkAttr).GetAddAttrCode(AttrCode,"","DataTypeProp")
	...s source=##class(web.DHCCKBRangeCat).GetAddAttrSource("","DataSource","",AttrCode)
	...s:source'="" DataType="combobox"
	...i (DataType'="combobox") d
	....s ResText=AttrValueId				//文本
	....s AttrValueId=""
	...s params=Id_"^"_EntyId_"^"_AttrId_"^"_AttrValueId_"^"_ResText
	...i QuitList="" s QuitList=params
	...e  s QuitList=QuitList_"&&"_params
	e  d			//其他数据处理
	.for i=1:1:Len  d
	..
	..s TempStr=$p(ListData,"&&",i)
	..s Id=+$p(TempStr,"^",1)
	..s AttrValueId=$p(TempStr,"^",4)
	..s ResText=$p(TempStr,"^",5)								 //备注
	
	..s html = $p(TempStr,"^",8)
	..s params=Id_"^"_EntyId_"^"_AttrId_"^"_AttrValueId_"^"_ResText_"^"_html
	..i QuitList="" s QuitList=params
	..e  s QuitList=QuitList_"&&"_params						
	
	Q QuitList
}

/// 取对应属性的模板id
/// w ##class(web.DHCCKBDicLinkAttr).GetTempAttrId(236611,"DrugPreMet")
ClassMethod GetTempAttrId(attrId, attrCode)
{
	n (attrId,attrCode)
	s LinkPropId=##class(web.DHCCKBCommon).GetLinkProp()
	s retId = ""
	s parAttrId = $o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",attrId,LinkPropId,""))
	s parTempId = $lg($g(^CT.CKB.PDSS.DicLinkAttrD(parAttrId)),4)
	s dicId = ""
	for  s dicId = $o(^CT.CKB.PDSS.CommonDictionI("Parref",parTempId,dicId))  Q:dicId=""  d
	.s code = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicId)),2)
	.s linkId = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicId)),5)
	.i linkId'="" s code = $lg($g(^CT.CKB.PDSS.CommonDictionD(linkId)),2)
	.Q:attrCode'=code
	.s retId = dicId
	Q retId
}

}
