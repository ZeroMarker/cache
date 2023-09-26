Import sqluser

/// 界面导入入口 Terminal导入
Class web.DHCSTMHUI.Tools.DataInput Extends (%RegisteredObject, web.DHCSTMHUI.StkTypeM) [ Not ProcedureBlock ]
{

/// 将数据Set到临时global,便于调试问题
ClassMethod SetGlobal(Rows)
{
	n (Rows)
	s Pid=..NewPid()
	k ^TMPDHCSTM(Pid)
	
	s Cnt=0
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Rows)
	i Sc'=0 q RtnObj.Err(-1,"","入参解析失败!").Json()
	
	while(1){
		s Row=PJObj.%Pop()
		q:Row=""
		s Cnt=Cnt+1
		s ^TMPDHCSTM(Pid,Cnt)=Row.%ToJSON()
	}
	s RtnObj.rowid=Pid
	s ^TMPDHCSTM(Pid,0)=$zdt($h,3,1)
	q RtnObj.success_"^"_RtnObj.rowid
}

/// 界面导入入口
/// w ##class(web.DHCSTMHUI.Tools.DataInput).DataInput("33341","Pur","{""gUserId"":""6423"",""gLocId"":""163"",""gGroupId"":""277"",""gHospId"":""2"",""MENUID"":""58056""}")
ClassMethod DataInput(Pid, Type, Params)
{
	n (Pid,Type,Params,%session)
	s cnt=0
	s success=0
	s Main=""
	s DataRtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	s DataRtnObj.msg=""
	i Type="" d DataRtnObj.Err(-1,"","数据类型不能为空!")
	q:DataRtnObj.success'=0 DataRtnObj.Json()
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d DataRtnObj.Err(-1,"","入参解析失败!")
	q:DataRtnObj.success'=0 DataRtnObj.Json()
	
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	s Max=$o(^TMPDHCSTM(Pid,""),-1)
	
	f i=1:1:Max {
		s RowStr=$g(^TMPDHCSTM(Pid,i))
		continue:RowStr=""
		s Sc=PJObj.%FromJSON(RowStr)
		s Row=PJObj
		q:Row=""
		s cnt=cnt+1
		ts
		i Type="ApcVendor" d
		.s RtnObj=##class(web.DHCSTMHUI.Tools.VendorInputNew).InputItm(Row)
		
		i Type="Manf" d
		.s RtnObj=##class(web.DHCSTMHUI.Tools.PhManfInputNew).InputItm(Row)
		
		i Type="Bin" d
		.s RtnObj=##class(web.DHCSTMHUI.Tools.StkBinInput).InputItm(Row)
		
		i Type="Adj" d
		.s RtnObj=##class(web.DHCSTMHUI.Tools.ADJPrice).InputItm(Row,.Main,Params)
		
		i Type="Stk" d
		.s LocDesc=Row.%Get("科室名称")
		.s VendorDesc=Row.%Get("供应商")
		.s ReqLocDesc=Row.%Get("接收科室名称")
		.s SubData=LocDesc_"^"_VendorDesc_"^"_ReqLocDesc
		.i '$d(TMPIngrGlobal(SubData)) d
		..s RtnObj=##class(web.DHCSTMHUI.Tools.StockRecInput).InputItm(Row,"",Params) //主表Id传递
		..q:RtnObj.success<0
		..s TMPIngrGlobal(SubData)=RtnObj.rowid
		.e  d
		..s RtnObj=##class(web.DHCSTMHUI.Tools.StockRecInput).InputItm(Row,TMPIngrGlobal(SubData),Params) //主表Id传递
		
		i Type="Reg" d
		.s RtnObj=##class(web.DHCSTMHUI.Tools.ItmManfCertInputNew).InputItm(Row)
		
		i Type="Pur" d
		.s RtnObj=..InputPurItm(Row)
		
		i RtnObj.success=0 d
		. tc
		.s success=success+1
		e  d
		. tro
		.s DataRtnObj.msg=DataRtnObj.msg_"<br>第"_cnt_"行"_RtnObj.msg
		.d ##class(web.DHCSTMHUI.Tools.CommonInput).SetErr(Type_"第"_cnt_"行",RtnObj.msg)
	}
	s DataRtnObj.msg="共"_cnt_"条数据,成功导入"_success_"条数据!<br>失败原因:"_DataRtnObj.msg
	q DataRtnObj.Json()
}

/// 处理一行数据
/// 物资代码^物资名称^生产厂家^注册证号^注册证效期^注册证名称^注册证发证日期^注册证延期效期标志
ClassMethod InputPurItm(RowObj) As %String
{
	n (RowObj,%session)
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	s gHospId=$p(..sssParamStr(),"^",4)
	s InciCode=RowObj.%Get("物资代码")
	s InciDesc=RowObj.%Get("物资名称")
	s PurNo=RowObj.%Get("带量编号")
	s PurDesc=RowObj.%Get("带量名称")
	s PurType=RowObj.%Get("带量类型")
	s StartDate=RowObj.%Get("起始日期")
	s EndDate=RowObj.%Get("截至日期")
	s PurQty=RowObj.%Get("任务量")
	s InciId="",IncIdByDesc="",Manf=""
	s InciId=##class(web.DHCSTMHUI.MatForBDPData).CodeDescGetId("CODE",InciCode,"INC_Itm",gHospId)
	i (InciCode'="")&&(InciId="") d RtnObj.Err(-1,"","此物资代码无效!","",0)
	q:RtnObj.success'=0 RtnObj
	s IncIdByDesc=##class(web.DHCSTMHUI.MatForBDPData).CodeDescGetId("DESC",InciDesc,"INC_Itm",gHospId)
	i InciId'=IncIdByDesc d RtnObj.Err(-1,"","此物资代码与名称不匹配","",0)
	q:RtnObj.success'=0 RtnObj
	&sql(SELECT ID INTO :PurTypeId FROM CT_HRP_MAT.ComDictValue WHERE ComDI_ValDesc = :PurType)
	i PurTypeId=""  d RtnObj.Err(-1,"","带量类型未维护!","",0)
	q:RtnObj.success'=0 RtnObj
	s Data=InciId_"^"_PurNo_"^"_PurTypeId_"^"_StartDate_"^"_EndDate_"^"_PurQty_"^"_PurDesc
	s Title="Inci^PurNo^PurType^PurStartDate^PurEndDate^PurQty^PurDesc"
	s Main=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	s RtnObj=##class(web.DHCSTMHUI.PurchaseInfo).Save(Main)	
	q RtnObj
}

/// Terminal  导入入口
/// Inci库存项、InciArc、物资（库存项 医嘱项）、ApcVendor供应商、Manf生产厂家、
/// Bin货位码、Adj调价、Stk库存(入库单）、Reg注册证
/// w ##class(web.DHCSTMHUI.Tools.DataInput).TerInput("C:\1.txt","Bin")
ClassMethod TerInput(FileName As %String, Type As %String)
{
	n (FileName,Type)
	i Type="" q "数据类型不能为空!"
	s p=$zn
	s ret=##class(web.DHCSTMHUI.Tools.LoadData).LoadData(FileName,Type,p)
	i ret'=0 q "读文件失败!"
	s Rows=""
	s Title=^TMPDHCSTMINPUT(p,Type,1)
	s i=1
	f  s i=$O(^TMPDHCSTMINPUT(p,Type,i)) q:i=""  d
	.s rowStr=$G(^TMPDHCSTMINPUT(p,Type,i))
	.s jsonStr=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(rowStr,Title)
	.i Rows=""  d
	..s Rows=jsonStr
	.e  d 
	..s Rows=Rows_","_jsonStr
	k ^TMPDHCSTMINPUT(p,Type)  //删除临时global
	s Rows="["_Rows_"]"
	s Rtn=..DataInput(Rows,Type)
	q Rtn
}

/// 批量审核所有"待审核"的入库单. 默认使用demo用户,如有需要,自行修改入参.
/// d ##class(web.DHCSTMHUI.Tools.DataInput).AuditIngr()
ClassMethod AuditIngr(UserInitial = "demo")
{
	s UserId=""
	&sql(select %id into :UserId from SqlUser.ss_user where SSUSR_Initials = :UserInitial)
	s ParamsObj={}
	d ParamsObj.%Set("gUserId",UserId)
	s Params=ParamsObj.%ToJSON()
	
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	s Count=0,SuccCount=0
	
	&sql(declare IngrCursor cursor for
		SELECT INGR_RowId, INGR_No, INGR_Loc_Dr->CTLOC_Desc
		FROM SqlUser.DHC_INGdRec
		WHERE INGR_StkType='M'
			AND INGR_Completed='Y'
			AND nvl(INGR_AuditFlag,'N')='N'
	)
	&sql(open IngrCursor)
	f  &sql(fetch IngrCursor into :IngrId, :IngrNo, :LocDesc) q:SQLCODE  d
	.s RtnObj=##class(web.DHCSTMHUI.DHCINGdRec).Audit(IngrId,Params)
	.s Count=Count+1
	.i RtnObj.success=0 s SuccCount=SuccCount+1
	.w LocDesc_"  "_IngrNo_":"_RtnObj.msg,!
	&sql(close IngrCursor)
	
	w !,"共"_Count_"个入库单, 成功"_SuccCount_"个"
}

}
