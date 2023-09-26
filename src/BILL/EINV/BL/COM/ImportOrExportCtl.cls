Class BILL.EINV.BL.COM.ImportOrExportCtl Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// 删除导入错误时保存的临时数据
/// 	修改日期: 	2022年4月1日
/// 入参说明：	ClassDesc 	--> 导入类名
/// 			MethodDesc	--> 导入方法名
/// 返 回 值：1：成功；-1：失败
/// w ##class("BILL.EINV.BL.COM.ImportOrExportCtl").ExcelErrDel("insuqc.service.dic.INSUQCDicStrategyCateCtl","ImportStrategyCateData")
ClassMethod ExcelErrDel(ClassDesc As %String, MethodDesc As %String) As %String
{
	;s ^TMPINSUQC("ExcelImportErrData",ClassName,MethodName,GlobalDataKey,RowIndex)=RowDataInfo_"||"_info
	s rtn="-1"
	q:(ClassDesc="")||(MethodDesc="") rtn
	k ^TMPINSUQC("ExcelImportErrData",ClassDesc,MethodDesc)
	q 1
}

/// 功能说明：查询导入时发生错误的数据
/// 入参说明：	ClassDesc 	--> 导入类名
/// 			MethodDesc	--> 导入方法名
/// 返 回 值：	ClassDesc:MethodDesc:GlobalDataKey:RowIndex:RowDataInfo:info
/// 			导入类名:导入方法名:GlobalDataKey:错误行号:错误数据:错误原因
/// d ##class(%ResultSet).RunQuery("BILL.EINV.BL.COM.ImportOrExportCtl","ExcelErrorQuery",$lg(^TempExcelErrorQueryExecute,1),$lg(^TempExcelErrorQueryExecute,2))
Query ExcelErrorQuery(ClassDesc As %String, MethodDesc As %String) As %Query(ROWSPEC = "ClassDesc:%String,MethodDesc:%String,GlobalDataKey:%String,RowIndex:%String,RowDataInfo:%String,info:%String")
{
}

ClassMethod ExcelErrorQueryExecute(ByRef qHandle As %Binary, ClassDesc As %String, MethodDesc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
    s ind=1
    //-------------------------------------------------//
  	s ^TempExcelErrorQueryExecute=$lb(ClassDesc,MethodDesc)
    ;zw ^TMPINSUQC("ExcelImportErrData","insuqc.service.chronic.INSUQCChronicConfig","ImportDiagDic") ; 慢特病导入
    ;zw ^TMPINSUQC("ExcelImportErrData","insuqc.service.dictool.ItmStrategyEditCtl","ImportItmConSateByExcel") ; 知识库导入
    ;zw ^TMPINSUQC("ExcelImportErrData","insuqc.service.dic.INSUQCDictionaryStrategyCtl","ImportStrategyByExcell") ; 规则导入
 	;zw ^TMPINSUQC("ExcelImportErrData","insuqc.service.dic.INSUQCDicStrategyCateCtl","ImportStrategyCateData") ; 规则大分类
	s rtn="-1"
	;s ^TMPINSUQC("ExcelImportErrData",ClassName,MethodName,GlobalDataKey,RowIndex)=RowDataInfo_"||"_info
	s Check=..CheckClassAndMethod(ClassDesc,MethodDesc) ; 判断类名及方法是否存在
	q:Check="0"
	;s ^TMPINSUQC(ClassName,MethodName,UserDr,"ErrData",RowIndex)=RowDataInfo_"||"_info ; 错误记录
	s GlobalDataKey=""
	f {
		s GlobalDataKey=$o(^TMPINSUQC("ExcelImportErrData",ClassDesc,MethodDesc,GlobalDataKey))
		q:GlobalDataKey=""
		s RowIndex=""
		f {
			s RowIndex=$o(^TMPINSUQC("ExcelImportErrData",ClassDesc,MethodDesc,GlobalDataKey,RowIndex))
			q:RowIndex=""
			s ErrorData=^TMPINSUQC("ExcelImportErrData",ClassDesc,MethodDesc,GlobalDataKey,RowIndex)
			s RowDataInfo=$p(ErrorData,"||",1)
			s info=$p(ErrorData,"||",2)
			d OutputRow
		}
	}	
    //--------------------------------------------------//

    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
		
OutputRow
	set Data=$lb(ClassDesc,MethodDesc,GlobalDataKey,RowIndex,RowDataInfo,info)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod ExcelErrorQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ExcelErrorQueryExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod ExcelErrorQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ExcelErrorQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 功能说明：Excel导入的共通处理方法
/// 入参说明：ClassName     --> 导入处理的类名
///           MethodName    --> 导入处理的方法名
///           RowIndex      --> 当前导入的行数
///           RowDataInfo   --> 行数据的内容字符串
///           UserDr        --> 操作员
///           GlobalDataFlg --> 保存到临时global中的标志
///           ExtStr        --> 备用字符串(医院编码^医保类型)
/// 返 回 值：保存成功与否的json结果
/// 修改履历：董科锋  2019 05 07 新做成
/// s ClassName="BILL.EINV.BL.COM.DicDataCtl"
/// s MethodName="ImportDicdataByExcel"
/// s RowDataInfo="SYS^EInvFarctoryList^电子票据开发商列表^1^2^3^4^5^6^7^8"
/// s RowDataInfo=="SYS^Adm_Exception_Mode^就诊异常模型列表^^^^^^^^"
/// w ##class(BILL.EINV.BL.COM.ImportOrExportCtl).ExcelImportAjax(ClassName, MethodName, 2, RowDataInfo, "1", "0", "3505990105^RBBX")
/// w ##class(BILL.EINV.BL.COM.ImportOrExportCtl).ExcelImportAjax("","",2,"fsfsfsfsd","1","1", "")
ClassMethod ExcelImportAjax(ImportClass As %String, ImportMethod As %String, RowIndex As %String, RowDataInfo As %String, UserDr As %String, GlobalDataFlg As %String, ExtStr As %String) As %String
{
	n (ClassName, MethodName, RowIndex, RowDataInfo, UserDr, GlobalDataFlg, ExtStr)
	s status="-1"
	s info=""
	s BeginIndex="2"   ;开始行
	s:UserDr="" UserDr="system"
	
	if (GlobalDataFlg="1"){
		k:RowIndex=BeginIndex ^TMPINSUQC("INSUQC","TMPGlobalData")
		
		s ^TMPINSUQC("INSUQC", "TMPGlobalData", RowIndex)=RowDataInfo
		s status="1"
		
	}else{
		s checkRtn=..CheckClassAndMethod(ImportClass, ImportMethod)
		if (checkRtn="1"){
			 k:RowIndex=BeginIndex ^TMPINSUQC(ImportClass,ImportMethod, UserDr)
			 ;s ^TMPINSUQC(ClassName,MethodName, UserDr, "BaseData", RowIndex)=RowDataInfo    ;原始记录
			 
			 s status=$zobjclassmethod(ImportClass, ImportMethod, RowDataInfo, UserDr, .info, ExtStr)   ;执行导入方法
			 i status<=0  d
			 .s ^TMPINSUQC(ImportClass,ImportMethod, UserDr, "ErrData", RowIndex)=RowDataInfo_"||"_info    ;错误记录
			 e  d      //是否有重复数据
			 .//在导入第三方的就诊信息和结算信息的时候，需要判断下是否有重复的数据
			 .i (((ImportClass="insuqc.service.com.AdmInfoCtl")&&(ImportMethod="ImportAdmByExcel"))||((ImportClass="insuqc.service.rep.DivideInfoCtl")||(ImportMethod="ImportDivideByExcel"))) d
	         ..i $d(^TMPINSUQC(ImportClass,ImportMethod, UserDr, "SucData", status))=0  d
			 ...s ^TMPINSUQC(ImportClass,ImportMethod, UserDr, "SucData", status)=RowIndex
			 ..e  d
			 ...s tmpIndexStr=$g(^TMPINSUQC(ImportClass,ImportMethod, UserDr, "SucData", status))
			 ...s outIndexStr=tmpIndexStr_"^"_RowIndex
			 ...s ^TMPINSUQC(ImportClass,ImportMethod, UserDr, "SucData", status)=outIndexStr
			 ...s ^TMPINSUQC(ImportClass,ImportMethod, UserDr, "MutiData", status)=outIndexStr
			
		}else{
			s info="指定的处理类名["_ImportClass_"]或方法名["_ImportMethod_"]不存在。"
		}
	}
	
	
	s ImportResultArr=##class(%ArrayOfDataTypes).%New()
	d ImportResultArr.SetAt(status, "status")
	d ImportResultArr.SetAt(info, "info")
	d ImportResultArr.SetAt(RowIndex, "rowIndex")	
	;d ##class(insuqc.utility.EncodeJson).Encode(ImportResultArr)
	;ext.util.JsonObject
	w ##class(ext.util.JsonObject).ObjToJson(ImportResultArr)
	q ""
}

/// 功能说明：判断制定的类和方法是否存在
/// 入参说明：ClassName   --> 类名
///           MethodName  --> 方法名
/// 返 回 值：1 存在 0 不存在
/// w ##class(BILL.EINV.BL.COM.ImportOrExportCtl).CheckClassAndMethod("BILL.EINV.BL.COM.ImportOrExportCtl","ExcelImportAjax")
ClassMethod CheckClassAndMethod(ClassName As %String, MethodName As %String) As %String
{
	n (ClassName, MethodName)
	
	s rtn="0"
	q:((ClassName="")||(MethodName="")) rtn
	
	s haveMethodFlg=##class(websys.Conversions).IsValidMethodName(ClassName, MethodName)
	i haveMethodFlg="1" d
	.s rtn="1"
	
	q rtn
}

/// 功能说明：导入失败的数据查找原因后再次导入把失败记录重新导入
///           可以用来调试查找导入失败的原因，找到后利用这个方法
/// s ClassName="insuqc.service.base.TarItmInfoCtl"
/// s MethodName="ImportTarItmByExcel"
/// w ##class(BILL.EINV.BL.COM.ImportOrExportCtl).ErrDataReImport(ClassName, MethodName,"1","3505990105^RBBX")
ClassMethod ErrDataReImport(ClassName As %String, MethodName As %String, UserDr As %String, ExtStr As %String) As %String
{
	n (ClassName, MethodName, UserDr, ExtStr)
	;s ^TempErrDataReImport=$lb(ClassName, MethodName, UserDr, ExtStr)
	s SucNum=0
	s ErrNum=0
	q:((ClassName="")||(MethodName="")||(UserDr="")) SucNum_"^"_ErrNum
	
	s errIndex=""
	f  s errIndex=$o(^TMPINSUQC(ClassName, MethodName, UserDr,"ErrData",errIndex)) q:errIndex=""  d
	.s checkRtn=..CheckClassAndMethod(ClassName, MethodName)
	.i checkRtn="1" d
	..s ErrDataInfo=$g(^TMPINSUQC(ClassName, MethodName, UserDr,"ErrData",errIndex))
	..s RowDataInfo=$p(ErrDataInfo, "||", 1)
	..s info=""
	..s status=$zobjclassmethod(ClassName, MethodName, RowDataInfo, UserDr, .info, ExtStr)   ;执行导入方法
	..i status<=0  d
	...s ErrNum=ErrNum+1
	..e  d
	...s SucNum=SucNum+1
	...k ^TMPINSUQC(ClassName, MethodName, UserDr,"ErrData",errIndex)   ;导入成功后 把失败记录清空
	.e  d
	..s ErrNum=ErrNum+1
	
	q SucNum_"^"_ErrNum
}

/// 功能说明：Excel导出的共通处理方法
/// 入参说明：ClassName     --> 导入处理的类名
///           MethodName    --> 导入处理的方法名
///           rows         --> 导出条数
///           pages         --> 导出页数
///           ExtStr        --> 备用字段(可用于筛选数据条件)
/// 返 回 值：获取成功与否的json结果
/// 修改履历：宋怀义  2021-01-07 新做成
/// s ClassName="insuqc.service.com.AdmInfoCtl"
/// s MethodName="ImportAdmByExcel"
/// s RowDataInfo="1^3505990105^04959788^2016-06-24^165400^正常^00956684^3***0196909023517^C00839815^蔡*山^男^普通住院^普通住院^胃癌^心内1(18) ^2016/6/15 10:52^2016-06-24 16:53:00^9007.0900^4523.8500^0.0000^4483.2400^0.0000^0.0000^0.0000^0.0000^0.0000^0.0000^0.0000^207.6100^成年人^有效^出院^住院"
/// w ##class(BILL.EINV.BL.COM.ImportOrExportCtl).ExcelExportAjax(ClassName, MethodName, 2, RowDataInfo, "1", "0", "3505990105^RBBX")
/// w ##class(BILL.EINV.BL.COM.ImportOrExportCtl).ExcelExportAjax("insuqc.service.base.HospitalInfoCtl","ExportInsuTypeData",100,"1","")
ClassMethod ExcelExportAjax(ClassName As %String, MethodName As %String, rows As %String, pages As %String, ExtStr As %String = "") As %String
{
	n (ClassName, MethodName, rows, pages, ExtStr)

		s checkRtn=..CheckClassAndMethod(ClassName, MethodName)
		if (checkRtn="1"){
			 s info=$zobjclassmethod(ClassName, MethodName, rows, pages,ExtStr)   ;获取数据
			 if +info<0 s status="-1"
			 else  s status=1
		}else{
			s info="指定的处理类名["_ClassName_"]或方法名["_MethodName_"]不存在。"
			s status="-9999"
		}
	s ImportResultArr=##class(%ArrayOfDataTypes).%New()
	d ImportResultArr.SetAt(info, "info")
	d ImportResultArr.SetAt(status, "status")
	d ##class(insuqc.utility.EncodeJson).Encode(ImportResultArr)
	q ""
}

/// 功能说明：Excel导入的共通处理方法
/// 入参说明：ClassName     --> 导入处理的类名
///           MethodName    --> 导入处理的方法名
///           RowIndex      --> 当前导入的行数
///           RowDataInfo   --> 行数据的内容字符串
///           UserDr        --> 操作员
///           GlobalDataFlg --> 保存到临时global中的标志
///           ExtStr        --> 备用字符串(医院编码^医保类型)
/// 返 回 值：保存成功与否的json结果
/// 修改履历：董科锋  2021 01 21 新做成
/// w ##class(BILL.EINV.BL.COM.ImportOrExportCtl).ExcelImportAjaxN("BILL.CFG.COM.DictionaryCtl","ImportDicdataByExcel","69","CPDataViewType^textbox^textbox^textbox^^^^^^^","1","0","","2")
ClassMethod ExcelImportAjaxN(ImportClass As %String, ImportMethod As %String, RowIndex As %String, RowDataInfo As %String, UserDr As %String, GlobalDataFlg As %String, ExtStr As %String, GlobalDataKey As %String) As %String
{
	n (ImportClass, ImportMethod, RowIndex, RowDataInfo, UserDr, GlobalDataFlg, ExtStr, GlobalDataKey)
	
	s ^TMPINSUQC("ExcelImportAjaxN")=$lb(ImportClass, ImportMethod, RowIndex, RowDataInfo, UserDr, GlobalDataFlg, ExtStr, GlobalDataKey)

	set $ZT="ExcelImportAjaxNET"
	s status="-1"
	s info=""
	s:UserDr="" UserDr="system"
	
	// 空数据处理
	set emptyFlag = 0
	set:($tr(RowDataInfo,"^","") = "") emptyFlag = 1
	
	if ((GlobalDataFlg="1") && (emptyFlag = 0)){
		k:GlobalDataKey="" ^TMPINSUQC("INSUQC","TMPGlobalData")     
		
		s ^TMPINSUQC("INSUQC", "TMPGlobalData", RowIndex)=RowDataInfo    //临时global存储数据 始终只能一个终端来存储数据 不支持多终端存储数据
		s status="1"
		s GlobalDataKey="TMPGlobalData"
		
	}elseif (emptyFlag = 0){
		s checkRtn=..CheckClassAndMethod(ImportClass, ImportMethod)
		if (checkRtn="1"){
			if (GlobalDataKey="") {
				s GlobalDataKey=$i(^TMPINSUQC("ExcelImportErrData",ImportClass,ImportMethod))
				k ^TMPINSUQC("ExcelImportErrData",ImportClass,ImportMethod, GlobalDataKey)
			}
			b ;1
			s status=$zobjclassmethod(ImportClass, ImportMethod, RowDataInfo, UserDr, .info, ExtStr)   ;执行导入方法
			i status<=0  d
			.s ^TMPINSUQC("ExcelImportErrData",ImportClass, ImportMethod, GlobalDataKey, RowIndex)=RowDataInfo_"||"_info    ;错误记录
			.b ; GlobalDataKey
			;e  d      //是否有重复数据
			;.//在导入第三方的就诊信息和结算信息的时候，需要判断下是否有重复的数据
			;.i (((ClassName="insuqc.service.com.AdmInfoCtl")&&(MethodName="ImportAdmByExcel"))||((ClassName="insuqc.service.rep.DivideInfoCtl")&&(MethodName="ImportDivideByExcel"))) d
			;..i $d(^TMPINSUQC(ClassName,MethodName, UserDr, "SucData", status))=0  d
			;...s ^TMPINSUQC(ClassName,MethodName, UserDr, "SucData", status)=RowIndex
			;..e  d
			;...s tmpIndexStr=$g(^TMPINSUQC(ClassName,MethodName, UserDr, "SucData", status))
			;...s outIndexStr=tmpIndexStr_"^"_RowIndex
			;...s ^TMPINSUQC(ClassName,MethodName, UserDr, "SucData", status)=outIndexStr
			;...s ^TMPINSUQC(ClassName,MethodName, UserDr, "MutiData", status)=outIndexStr
			
		}else{
			s status="-100"
			s info="指定的处理类名["_ImportClass_"]或方法名["_ImportMethod_"]不存在。"
		}
	}else{
		s status = "EMPTY"
		s info = ""
		if (GlobalDataKey="") {
			s GlobalDataKey=$i(^TMPINSUQC("ExcelImportErrData",ImportClass,ImportMethod))
			k ^TMPINSUQC("ExcelImportErrData",ImportClass,ImportMethod, GlobalDataKey)
		}
	}
	
	
	s ImportResultArr=##class(%ArrayOfDataTypes).%New()
	d ImportResultArr.SetAt(status, "Status")
	d ImportResultArr.SetAt(info, "ErrMsg")
	d ImportResultArr.SetAt(GlobalDataKey, "GlobalDataKey")	
	d ##class(insuqc.utility.EncodeJson).Encode(ImportResultArr)
	
	q ""
	
ExcelImportAjaxNET
	b
	set $ZT=""
	s ImportResultArr=##class(%ArrayOfDataTypes).%New()
	d ImportResultArr.SetAt("-100", "Status")
	d ImportResultArr.SetAt("导入时发生异常", "ErrMsg")
	d ImportResultArr.SetAt("", "GlobalDataKey")	
	d ##class(insuqc.utility.EncodeJson).Encode(ImportResultArr)
}

/// 功能说明：动态调用导出数据查询数据方法
/// 入参说明：DataSourceType  --> 查询数据源类型(0 query查询结果 1 列表数据 2 ^分割的数据 )
///           ClassName       --> 查询数据的类名称
///           MethodName      --> 查询数据的方法名称或者query名称
///           InputPam        --> 方法的或者query的参数拼串(按照方法执行的参数顺序拼串 用","号分割分割各个参数)
/// w ##class(BILL.EINV.BL.COM.ImportOrExportCtl).ExcelExportAjaxN("1","insuqc.service.dictool.ItmAndRuleRepCtl","CreateRuleDetailTest","2020-12-01,2020-12-31,,1")
/// w ##class(BILL.EINV.BL.COM.ImportOrExportCtl).ExcelExportAjaxN("0","web.DHCDocDiagnosNew","Find","182")
/// 修改履历：董科锋  2021-01-18  新做成 
ClassMethod ExcelExportAjaxN(DataSourceType As %String, ClassName As %String, MethodName As %String, InputPam As %String) As %String
{
	n (ClassName, MethodName, DataSourceType, InputPam)
	
	set $ZT="ExcelExportAjaxNET"
	s Status="1"
	s DataRtnInfo=""
	s InfoMsg=""
	s ErrMsg=""
	
	s InputPam=..RestArgPam(InputPam)     //参数转换成值动态调用	
	//query的查询结果
	if (DataSourceType="0"){
		//判断是否为query,如果是query 确定query的参数有多少个
		s QueryObj=##class(%Dictionary.CompiledQuery).%OpenId(ClassName_"||"_MethodName,0)
		if ($IsObject(QueryObj)){
			s QueryFlg="1"
			s InArgList=QueryObj.FormalSpecParsed      ;方法变量名称列表
			s ArgLen=$ll(InArgList)  //参数个数	
			s QueryObj=""
			s InArgList=""
			
			s QueryClsAndName=ClassName_":"_MethodName
			Set obj=##class(%ResultSet).%New(QueryClsAndName)        ;例:Set obj=##class(%ResultSet).%New("web.DHCDocDiagnosNew:Find")
			s:ArgLen=0 DoQueryStr="obj.Execute()"                    ;无参数
			s:ArgLen'=0 DoQueryStr="obj.Execute("_InputPam_")"       ;有参数
			d @DoQueryStr                                            ;动态执行query方法
			
			
			s ExcelExportDataId=$i(^TMPINSUQC("ExcelExportData"))
			k ^TMPINSUQC("ExcelExportData", ExcelExportDataId)
			s RowIndex=0
			
			For  Quit:'obj.Next()  Do
			.s colNums=obj.GetColumnCount()   ;query的列数目
			.q:colNums<0
			.s rowTitle=""       ;列名称行
			.s rowdata=""        ;数据行
			.f colIndex=1:1:colNums d
			..s colName=obj.GetColumnName(colIndex)       ;列名称
			..s colValue=obj.Data(colName)               ;列取值  方式1
			..;s colValue=obj.GetData(colIndex)          ;列取值  方式2
			..s rowdata=rowdata_$lb(colValue)
			..i RowIndex=0 s colName=obj.GetColumnHeader(colIndex)  //取第一次取query的列名称  shy 
			..s:RowIndex=0 rowTitle=rowTitle_$lb(colName) ;组织列标题
			
			.i RowIndex=0 d   ;query标题输出
			..;s RowIndex=RowIndex+1
			..;s ^TMPINSUQC("ExcelExportData", ExcelExportDataId, RowIndex)=rowTitle
			..s ^TMPINSUQC("ExcelExportData", ExcelExportDataId, "title")=rowTitle
			
			.s RowIndex=RowIndex+1
			.s ^TMPINSUQC("ExcelExportData", ExcelExportDataId, RowIndex)=rowdata
			
			s DataRtnInfo=RowIndex_"^"_ExcelExportDataId_"^TMPINSUQC(""ExcelExportData"""
		}else{
			s Status="-1"
			s ErrMsg="Query不存在("_ClassName_":"_MethodName_")"
		}
	}
	
	//查询结果存储在临时global中的方法  注意；这里的方法返回值格式必须是：数据条数^数据ID^global名称及前缀节点(例:TMPINSUQC(""RuleLocGrpInfo"")
	if (DataSourceType="1")||(DataSourceType="2") {
		set methodObj=##class(%Dictionary.CompiledMethod).%OpenId(ClassName_"||"_MethodName,0)
		if ($IsObject(methodObj)){ 
			s InArgList=methodObj.FormalSpecParsed      ;方法变量名称列表
			s ArgLen=$ll(InArgList)  //参数个数
			s methodObj=""
			s InArgList=""
		
			//构造执行方法
			s DoMethodStr="$classmethod(ClassName,MethodName"   ;获取所有入参，然后实现动态调度
			s:ArgLen=0 DoMethodStr=DoMethodStr_")"                   ;无参数方法
			s:ArgLen'=0 DoMethodStr=DoMethodStr_","_InputPam_")"      ;有参数方法
		
			s ExpAndRtn="RtnInfo="_DoMethodStr
			s @ExpAndRtn
			
			if ($l(RtnInfo, "^")<3){
				s Status="-1"
				s ErrMsg="类方法的返回值格式不正确:("_RtnInfo_"),\n正确格式:数据数量^数据key^global名称及前缀 例:1^3^TMPINSUQC(""ExcelExportData"""
			}else{
				s DataRtnInfo=RtnInfo
			}
		}else{
			s Status="-1"
			s ErrMsg="类方法不存在("_ClassName_":"_MethodName_")"
		}
	}
	
	i DataRtnInfo'="" d
	.s RowNums=$p(DataRtnInfo, "^", 1)   ;数据数量
	.s InfoMsg="导出数据整理完毕,共计["_RowNums_"]条."
	
	s Result("Status")=Status
	s Result("DataRtnInfo")=DataRtnInfo
	s Result("InfoMsg")=InfoMsg
	s Result("ErrMsg")=ErrMsg
	s rtn=##class(insuqc.utility.EncodeJson).Encode(.Result)
	q ""
	
ExcelExportAjaxNET
	s $ZT=""
	s Result("Status")="-1"
	s Result("DataRtnInfo")=""
	s Result("ErrMsg")="执行导出数据的查询时,发生异常"
	s rtn=##class(insuqc.utility.EncodeJson).Encode(.Result)
	q ""
}

/// 功能说明: 按照分页获取需要导出的数据
/// 入参说明: rows      --> 一页显示的数据行数
///           page      --> 当前页序号
///           DataType  --> 查询数据源类型(0 query查询结果 1 列表数据 2 ^分割的数据 )
///           ALLSize   --> 导出数据总行数
///           ExportDataID   --> 数据ID
///           DataGlobalName --> 临时global名称
/// 修改履历：董科锋  2021-01-18  新做成 
/// w ##class(BILL.EINV.BL.COM.ImportOrExportCtl).GetExportRowData("100","1","1","10","56","TMPINSUQC(""RuleLocGrpInfo""")
/// w ##class(BILL.EINV.BL.COM.ImportOrExportCtl).GetExportRowData("100","1","0","1","19","TMPINSUQC(""ExcelExportData""")
ClassMethod GetExportRowData(rows As %String, page As %String, DataType As %String, ALLSize As %String, ExportDataID As %String, DataGlobalName As %String) As %String
{
	n (rows, page, DataType, ALLSize, ExportDataID,DataGlobalName)
	
	s ^TMPINSUQC("GetExportRowData")=$lb(rows, page, DataType, ALLSize, ExportDataID,DataGlobalName)
	s RowsArr=""
	s EndPageFlg="0"   ;最后一页标志
	set $ZT="GetExportRowDataET"
	
	s RowsArrVal=""
	;s Data=##class(%ListOfDataTypes).%New()
	s startRow=(page-1)*rows+1
	s maxrow=startRow-1 + rows
	i maxrow>ALLSize d
	.s maxrow = ALLSize
	i startRow<=maxrow d
	.f i=startRow:1:maxrow d
	..//在第一页输出标题
	..i i=1 d
	...s GetGlobalDataStr="RowDataTitle=$g(^"_DataGlobalName_","_ExportDataID_",""title""))"
	...s @GetGlobalDataStr        ;执行获取方法
	...q:RowDataTitle=""
	...s RowInfo=..RowDtaToJsonArr(DataType, RowDataTitle)   ;转换为json数组格式
	...s RowsArrVal=RowInfo
	
	..s GetGlobalDataStr="RowDataInfo=$g(^"_DataGlobalName_","_ExportDataID_","_i_"))"
	..s @GetGlobalDataStr        ;执行获取方法
	..s RowInfo=..RowDtaToJsonArr(DataType, RowDataInfo)   ;转换为json数组格式
	..i RowsArrVal="" d
	...s RowsArrVal=RowInfo
	..e  d
	...s RowsArrVal=RowsArrVal_","_RowInfo
	
	
	;s RowsArr="["_RowsArrVal_"]"
	s RowsArr=RowsArrVal
	i maxrow=ALLSize  d          ;导出最后一行数据后 清理掉global
	.s EndPageFlg="1"
	.s killGlobalDataStr="^"_DataGlobalName_","_ExportDataID_")"
	.k @killGlobalDataStr
	
	
	s Result("Status")="1"
	s Result("RowsArr")=RowsArr
	s Result("EndPageFlg")=EndPageFlg
	s Result("InfoMsg")="本次共计导出数据["_ALLSize_"]条,第["_startRow_"~"_maxrow_"]条数据导出完毕."
	s Result("ErrMsg")=""
	s rtn=##class(insuqc.utility.EncodeJson).Encode(.Result)
	q ""
	
GetExportRowDataET
	set $ZT=""
	s Result("Status")="-1"
	s Result("RowsArr")=""
	s Result("ErrMsg")="执行导出数据的获取明细方法时,发生异常"
	s rtn=##class(insuqc.utility.EncodeJson).Encode(.Result)
	q ""
}

/// 功能说明: 行数据转换为json数组格式
/// 入参说明：DataType    --> 查询数据源类型(0 query查询结果 1 列表数据 2 ^分割的数据 )
///           RowDataInfo --> 行数据信息
/// 返 回 值：转化给格式后的行数据
/// 修改履历：董科锋  2021-01-18  新做成 
ClassMethod RowDtaToJsonArr(DataType As %String, RowDataInfo As %String) As %String
{
	n (DataType, RowDataInfo)
	
	s RtnJsonArr=""
	
	s ColNums=0
	if ((DataType="0")||(DataType="1")) {   //行数据为列表数据
		s ColNums=$ll(RowDataInfo)
	}
	
	if (DataType="2") {                     //行数据为"^"分割的数据时
		s ColNums=$l(RowDataInfo, "^")
	}
	q:ColNums=0 RtnJsonArr
	
	s JsonArrVal=""
	f ColIndex=1:1:ColNums  d
	.s ColVal=""
	.i ((DataType="0")||(DataType="1")) d     ;行数据为列表数据
	..s ColVal=$lg(RowDataInfo, ColIndex)
	.i (DataType="2") d                       ;行数据为"^"分割的数据时
	..s ColVal=$p(RowDataInfo, "^", ColIndex)
	
	.;b //组织数据内容
	.i ColIndex=1 d
	..s JsonArrVal=""""_$ZCVT(ColVal,"O","JS")_""""
	.e  d
	..s JsonArrVal=JsonArrVal_","""_$ZCVT(ColVal,"O","JS")_""""
	b ;2
	
	s RtnJsonArr="["_JsonArrVal_"]"
	q RtnJsonArr
}

/// 功能说明:判断query是否存在
/// w ##class(BILL.EINV.BL.COM.ImportOrExportCtl).CheckClassAndQuery("web.DHCDocDiagnosNew","Find")
ClassMethod CheckClassAndQuery(classname, querydname) As %String
{
	n (classname, querydname)
	s $ZT="ERROR^DHCSSERR"
	
	q:((classname="")||(querydname="")) 0
	
	;
	s myobj=##class(%Dictionary.CompiledQuery).%OpenId(classname_"||"_querydname,0)
	s myrtn=0
	
	i ($IsObject(myobj)){
		s myobj=""
		s myrtn = 1
	}
	
	q myrtn
}

/// 功能说明:参数转换为值 动态调用
/// w ##class(BILL.EINV.BL.COM.ImportOrExportCtl).RestArgPam("2,3,4,5")
ClassMethod RestArgPam(InputPam) As %String
{
	n (InputPam)
	
	s RtnPam=""
	
	s PamLen=$l(InputPam, ",")
	q:PamLen<1 RtnPam
	
	f ArgIndex=1:1:PamLen  d
	.s TmpArgVal=$p(InputPam, ",", ArgIndex)
	.s TmpArgVal=""""_TmpArgVal_""""
	.i RtnPam="" d
	..s RtnPam=TmpArgVal
	.e  d
	..s RtnPam=RtnPam_","_TmpArgVal
	
	q RtnPam
}

}
