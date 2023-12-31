/// Created By HZY 2011-10-11 HZY0013
/// Desc: 将 web.DHCEQInStock.cls 中的函数 GetChangeStock , GetParSourceID , ChangeTypeList 移到了本类中 .
/// ----------------------------------------------------
Class web.DHCEQChangeStock Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "CS_RowID";

Parameter SQLDESCRIPTION = "CS_RowID";

Parameter SQLROWID = "CS_RowID";

/// -------------------------------
/// Modified By HZY 2011-10-08 HZY0013
/// 描述:1,增加参数 ToLocDR .
/// 	 2,增加设备编号的信息输出 .
/// -------------------------------
/// 修改：zy 2009-11-20   ZY0017
/// 描述:保存查询的信息到临时Global中,为保存导出提供数据
/// -------------------------------
Query GetChangeStock(StoreLocDR, ToLocDR, EquipDR, EquipTypeDR, ChangeType, SubChangeType, StartDate, EndDate, QXType) As %Query(ROWSPEC = "TRowID:%String,TEquipDR:%String,TStoreLocDR:%String,TFromToLoc:%String,TSourceID:%String,TChangeType:%String,TChangeDate:%String,TAuditUserDR:%String,TAuditDate:%String,TEquip:%String,TStoreLoc:%String,TAuditUser:%String,TChangeTypeDR:%String,TParSourceID:%String,TBillChangeDate:%String,TJob:%String,TEquipNo:%String,TEquipType:%String,TEquipTypeDR:%String,TModelDR:%String,TModel:%String,TOriginalFee:%String,TSubChangeTypeDR:%String,TRequestNo:%String,TRow:%String")
{
}

ClassMethod GetChangeStockExecute(ByRef qHandle As %Binary, StoreLocDR, ToLocDR, EquipDR, EquipTypeDR, ChangeType, SubChangeType, StartDate, EndDate, QXType) As %Status
{
	
 	new repid, index,rowid,PNum,quitflag  //Modified By ZY 2009-11-18 ZY0017
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	k ^DHCEQTemp("ChangeStock",+$H,$J)
 	d ##Class(web.DHCEQCommon).KillTempGlobal("ChangeStock")  //Modified By ZY 2009-11-18 ZY0017
	s PNum=1                    //Modified By ZY 2009-11-18 ZY0017
	s index=1
	s TRow=0
	s rowid=0
	s quitflag=0	//退出标志，0 不退出 ，1 退出 .  Add By HZY 2011-10-10 HZY0013
	s TJob=$J
	d BuildDataGetChangeStock
	Quit $$$OK
BuildDataGetChangeStock
	f  s rowid=$o(^DHCEQChangeStock(rowid))  quit:rowid=""  d
	.d ResetVariablesGetChangeStock
	.s quitflag=0	//设置退出标志为0 .Add By HZY 2011-10-08 HZY0013
	.s TRowID = rowid
	.s TEquipDR = $p($g(^DHCEQChangeStock(rowid)),"^",1)
	.q:(EquipDR'="")&&(TEquipDR'=EquipDR)
	.i TEquipDR '=""  d
	..s TEquip = $p($g(^DHCEQEquip(TEquipDR)),"^",1)
	.. // Start Modified By HZY 2011-10-08 HZY0013
	..s TEquipNo=$p($g(^DHCEQEquip(TEquipDR)),"^",71)
	.s InvalidFlag=$p($g(^DHCEQEquip(TEquipDR)),"^",59)   //add by czf 需求号：349883
	.q:InvalidFlag'="N"
	.s TEquipTypeDR=$p($g(^DHCEQEquip(TEquipDR)),"^",63)
	.q:(EquipTypeDR'="")&&(EquipTypeDR'=TEquipTypeDR)
	.s TEquipType=""
	.i TEquipTypeDR'="" s TEquipType=$p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
	.s TModelDR=$p($g(^DHCEQEquip(TEquipDR)),"^",3)
	.s TModel=""
	.i TModelDR'="" s TModel=$p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	.s TOriginalFee=$p($g(^DHCEQEquip(TEquipDR)),"^",27)	//Add By HZY 2011-10-08 HZY0013
	.s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber(TOriginalFee,"",2)
	.s TStoreLocDR = $p($g(^DHCEQChangeStock(rowid)),"^",2)
	.q:(StoreLocDR'="")&&(TStoreLocDR'=StoreLocDR)
	.i TStoreLocDR '=""  d
	..s TStoreLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TStoreLocDR)
	.s TChangeType = $p($g(^DHCEQChangeStock(rowid)),"^",5)
	.s TFromToLocDR = $p($g(^DHCEQChangeStock(rowid)),"^",3)	//入库库房
	.q:(ToLocDR'="")&&(ToLocDR'=TFromToLocDR)		//Add By HZY 2011-10-08 HZY0013
	.i TFromToLocDR'="" s TFromToLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",$p($g(^DHCEQChangeStock(rowid)),"^",3)) ;modified by csj 20190125
	.i (TStoreLocDR '="")&&(TFromToLocDR'="")  d
	..q:(1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,TStoreLocDR)))&&(1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,TFromToLocDR)))	//安全组访问库房判断.StoreLocDR, ToLocDR
	.i (TStoreLocDR '="")&&(TFromToLocDR="")  d
	..q:(1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,TStoreLocDR)))
	.i (TStoreLocDR ="")&&(TFromToLocDR'="")  d
	..q:(1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,TFromToLocDR)))
	.
	.s TSourceID = $p($g(^DHCEQChangeStock(rowid)),"^",4)
	.q:(ChangeType'="")&&(TChangeType'=ChangeType)
	.s TParSourceID=..GetParSourceID(TChangeType,TSourceID)
	.s TRequestNo=""
	.s TSubChangeTypeDR=SubChangeType
	.s TSubChangeType=""
	.i +TChangeType=0  d 	//新增入库
	..s TRequestNo=$p($g(^DHCEQInStock(TParSourceID)),"^",14)
	.i +TChangeType=1  d   //转移
	..i ((SubChangeType'="")&&(SubChangeType'=$p($g(^DHCEQStoreMove(TParSourceID)),"^",12))||($p($g(^DHCEQStoreMove(TParSourceID)),"^",27)="Y")) s quitflag=1   //过滤已作废的转移 modified by wy 2020-1-9 1170863
	..s TSubChangeType=$CASE($p($g(^DHCEQStoreMove(TParSourceID)),"^",12),"0":"库房分配","1":"科室调配","3":"科室退库","4":"库房调配",:"")
	..s TRequestNo=$p($g(^DHCEQStoreMove(TParSourceID)),"^",1)
	.i +TChangeType=2  d   //退货
	..i (SubChangeType'="")&&(SubChangeType'=$p($g(^DHCEQReturn(TParSourceID)),"^",17)) s quitflag=1
	..s TRequestNo=$p($g(^DHCEQReturn(TParSourceID)),"^",1)
	.i +TChangeType=3  d 	//减少
	..i (SubChangeType'="")&&(SubChangeType'=$p($g(^DHCEQReturn(TParSourceID)),"^",17)) s quitflag=1
	..s TSubChangeType=$CASE($p($g(^DHCEQReturn(TParSourceID)),"^",17),"3":"调拨","4":"盘亏","5":"出售","6":"投资转出","7":"其他",:"")
	..s TRequestNo=$p($g(^DHCEQReturn(TParSourceID)),"^",1)
	.q:(quitflag=1)
	.s TChangeTypeDR=TChangeType
	.s TChangeType = $CASE(TChangeType,"0":"新增入库","1":"转移","2":"退货","3":"减少","4":"转让出库",:"没有定义") // add by zx 2019-01-10 801671
	.s TChangeType =TChangeType_"/"_TSubChangeType
	. //End Modified By HZY 2011-10-09 HZY0013
	.s StartDate=##Class(web.DHCEQCommon).TransValueFromPage(StartDate,"date")  ;hisui改造 modified by kdf 2018-08-30 日期格式修改
	.s EndDate=##Class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")  ;hisui改造 modified by kdf 日期格式修改
	.i StartDate="" s StartDate=0
	.i EndDate="" s EndDate=+$h
	.q:($p($g(^DHCEQChangeStock(rowid)),"^",6)>EndDate)||($p($g(^DHCEQChangeStock(rowid)),"^",6)<StartDate)
	.s TChangeDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQChangeStock(rowid)),"^",6),"date")
	.s TAuditUserDR = $p($g(^DHCEQChangeStock(rowid)),"^",7)
	.i TAuditUserDR '=""  d
	..s TAuditUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TAuditUserDR)
	.s TAuditDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQChangeStock(rowid)),"^",8),"date")
	.s TBillChangeDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQChangeStock(rowid)),"^",9),"date")
	.s TRow=TRow+1
	.d OutputRowGetChangeStock
	quit
OutputRowGetChangeStock
	s Data=$lb(TRowID,TEquipDR,TStoreLocDR,TFromToLoc,TSourceID,TChangeType,TChangeDate,TAuditUserDR,TAuditDate,TEquip,TStoreLoc,TAuditUser,TChangeTypeDR,TParSourceID,TBillChangeDate,TJob,TEquipNo,TEquipType,TEquipTypeDR,TModelDR,TModel,TOriginalFee,TSubChangeTypeDR,TRequestNo,TRow)
	Set ^CacheTemp(repid,index)=Data
	//Add By ZY 2009-11-18 ZY0017                 0           1              2               3              4            5                 6               7                8           9           10            11               12               13              14                  15          16              17               18          19        20            21                    22            
	Set ^DHCEQTemp("ChangeStock",+$H,TJob,PNum)=TRowID_"^"_TEquipDR_"^"_TStoreLocDR_"^"_TFromToLoc_"^"_TSourceID_"^"_TChangeType_"^"_TChangeDate_"^"_TAuditUserDR_"^"_TAuditDate_"^"_TEquip_"^"_TStoreLoc_"^"_TAuditUser_"^"_TChangeTypeDR_"^"_TParSourceID_"^"_TBillChangeDate_"^"_TEquipNo_"^"_TEquipType_"^"_TEquipTypeDR_"^"_TModelDR_"^"_TModel_"^"_TOriginalFee_"^"_TSubChangeTypeDR_"^"_TRequestNo
	Set PNum=PNum+1
	//End By ZY 2009-11-18 ZY0017
	Set index=index+1
	quit
ResetVariablesGetChangeStock
	s (TRowID,TEquipDR,TStoreLocDR,TFromToLoc,TSourceID,TChangeType,TChangeDate,TAuditUserDR,TAuditDate,TEquip,TStoreLoc,TAuditUser,TChangeTypeDR,TParSourceID,TBillChangeDate,TEquipNo,TEquipType,TEquipTypeDR,TModelDR,TModel,TOriginalFee,TSubChangeTypeDR,TRequestNo)=""
	quit
}

ClassMethod GetChangeStockFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetChangeStockExecute ]
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

ClassMethod GetChangeStockClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetChangeStockExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Modified By HZY 2011-10-09 HZY0013
/// Desc:增加‘减少’这种变动类型.
ClassMethod GetParSourceID(Type, SourceID)
{
	if (Type=""||SourceID="") q ""
	if Type="0" 	 //新增入库
	{
		if $g(^DHCEQInStockList(SourceID))="" q ""
		q $P(^DHCEQInStockList(SourceID),"^",1)
	}
	if Type="1" 	//转移
	{
		if $g(^DHCEQStoreMoveList(SourceID))="" q ""
		q $P(^DHCEQStoreMoveList(SourceID),"^",1)
	}
	if Type="2" 	//退货
	{	if $g(^DHCEQReturnList(SourceID))="" q ""
		q $P(^DHCEQReturnList(SourceID),"^",1)
	}
	if Type="3"		//减少. Add By zx 2019-01-10 改为DHC_EQReturnList表
	{
		if $g(^DHCEQReturnList(SourceID))="" q ""
		q $P(^DHCEQReturnList(SourceID),"^",1)
	}
}

/// Modified By HZY 2011-10-08 HZY0013
/// Desc:屏蔽‘调拨出库’和‘转让出库’,暂时没有这两个选项.
ClassMethod ChangeTypeList(name, width) As %String
{
	;;下拉列表
	w ##class(web.DHCEQCommon).GetDefaultStyle(name,"")   //by kdf
	;w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	w "<option value=></option>"
	w "<option value=0>新增入库</option>"
	w "<option value=1>转移</option>"
	w "<option value=2>退货</option>"
	w "<option value=3>减少</option>"
	w "</select>",!
}

/// Add By HZY 2011-10-08 HZY0013
/// Desc:'变动子类型'下拉列表 .
ClassMethod SubChangeTypeList(MainType As %String = "", SubChangeType As %String = "", SubWidth As %String = "") As %String
{
	
	if (+MainType=1)	//转移
	{
		d ##Class(web.DHCEQStoreMoveNew).MoveTypeList(SubChangeType,SubWidth)
	}
	elseif (+MainType=3)	//减少 DHC_EQCOutType
	{
		new rowid,InvalidFlag,option
		w ##class(web.DHCEQCommon).GetDefaultStyle(SubChangeType,"")   //by kdf
		;w "<select name='"_SubChangeType_"' id='"_SubChangeType_"' style='width:"_SubWidth_"' HEIGHT=0>"
		w "<option value=></option>"
		s rowid=2
		f  s rowid=$o(^DHCEQCCode("DHCEQCOutType",rowid)) q:rowid=""  d
		.s InvalidFlag=$p($g(^DHCEQCCode("DHCEQCOutType",rowid)),"^",4)
		.q:(InvalidFlag="Y")
		.s option=$p($g(^DHCEQCCode("DHCEQCOutType",rowid)),"^",2)
		.w "<option value="_rowid_">"_option_"</option>"		
		
		w "</select>",!
	}
	else	//新增入库、退货、无
	{
		w ##class(web.DHCEQCommon).GetDefaultStyle(SubChangeType,"")   //by kdf
		;w "<select name='"_SubChangeType_"' id='"_SubChangeType_"' style='width:"_SubWidth_"' HEIGHT=0>"
		w "<option value=></option>"
		w "</select>",!
	}
}

/// Add By HZY 2011-10-08 HZY0013
/// Desc:当"设备出入库变动"功能界面上的选项‘变动主类型’变化时，调用本函数 使‘变动子类型’随之变化 .
ClassMethod GetSubChangeTypeListHtml(type, subType, width) As %String
{
	s HtmlStr=""
	if (+type=1)	//转移
	{
		;d ##Class(web.DHCEQStoreMoveNew).MoveTypeList(subType,width)
		s HtmlStr="<select class='hisui-combobox combobox-f combo-f' name='"_subType_"' id='"_subType_"' style='width:"_width_"' HEIGHT=0>"
		s HtmlStr=HtmlStr_"<option value=""""></option>"
		s HtmlStr=HtmlStr_"<option value=""0"">库房分配</option>"
		s HtmlStr=HtmlStr_"<option value=""1"">科室调配</option>"
		s HtmlStr=HtmlStr_"<option value=""3"">科室退库</option>"
		s HtmlStr=HtmlStr_"<option value=""4"">库房调配</option>" 
		s HtmlStr=HtmlStr_"</select>"
	}
	elseif (+type=3)	//减少 DHC_EQCOutType
	{
		s HtmlStr="<select name='"_subType_"' id='"_subType_"' style='width:"_width_"' HEIGHT=0>"
		s HtmlStr=HtmlStr_"<OPTION value=""""></OPTION>"
		s rowid=2
		f  s rowid=$o(^DHCEQCCode("DHCEQCOutType",rowid)) q:rowid=""  d
		.s InvalidFlag=$p($g(^DHCEQCCode("DHCEQCOutType",rowid)),"^",4)
		.q:(InvalidFlag="Y")
		.s option=$p($g(^DHCEQCCode("DHCEQCOutType",rowid)),"^",2)
		.s HtmlStr=HtmlStr_"<OPTION value="""_rowid_""">"_option_"</OPTION>"
		
		s HtmlStr=HtmlStr_"</select>"
	
	}
	else	//新增入库、退货、无
	{
		s HtmlStr="<select name='"_subType_"' id='"_subType_"' style='width:"_width_"' HEIGHT=0>"
		s HtmlStr=HtmlStr_"<OPTION value=""""></OPTION>"
		s HtmlStr=HtmlStr_"</select>"
	}
	q HtmlStr
}

/// add by sjh 2020-06-04 SJH0024  begin   增加导出列设置需要的方法，获取界面行数
ClassMethod GetOneChangeStock(PNum, job)
{
	i PNum=0 q $o(^DHCEQTemp("ChangeStock",+$H,job,""),-1)
	q $g(^DHCEQTemp("ChangeStock",+$H,job,PNum))
}

ClassMethod GetNum(node As %Library.String = "", job)
{
	q ..GetOneChangeStock(0,job)
}

ClassMethod GetList(node As %Library.String = "", job, gnum)
{
	q ..GetOneChangeStock(gnum,job)
}

/// add by sjh 2020-06-04 SJH0024  end

}
