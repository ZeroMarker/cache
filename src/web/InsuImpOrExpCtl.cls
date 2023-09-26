/// EXCEL导入导出共通的逻辑处理类
Class web.InsuImpOrExpCtl Extends %RegisteredObject
{

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
	s ^TMPEInv("ExcelImportAjax")=ImportClass_","_ImportMethod_","_RowIndex_","_RowDataInfo_","_UserDr_","_GlobalDataFlg_","_ExtStr
	
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
/// w ##class(insuqc.service.com.ImportOrExportCtl).CheckClassAndMethod("insuqc.service.com.ImportOrExportCtl","ExcelImportAjax")
ClassMethod CheckClassAndMethod(ClassName As %String, MethodName As %String) As %String
{
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
/// w ##class(insuqc.service.com.ImportOrExportCtl).ErrDataReImport(ClassName, MethodName,"1","3505990105^RBBX")
ClassMethod ErrDataReImport(ClassName As %String, MethodName As %String, UserDr As %String, ExtStr As %String) As %String
{
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

}
