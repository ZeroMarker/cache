/// Import SQLUser
/// 名称:BDP数据导入
/// 编写者:基础数据平台组 - 谷雪萍、陈莹
/// 编写日期:2016-3-24
Class web.DHCBL.BDP.BDPDataImport Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：基础数据平台组 陈莹
/// CreatDate: 2017-2-22
/// Description：用于数据页面中功能项颜色区分
/// Return:需要加颜色的菜单json串
/// w ##class(web.DHCBL.BDP.BDPDataImport).GetItemPreferences()
ClassMethod GetItemPreferences() As %String
{
	s json=""
	
	s table=""
	for
	{
		s table=$o(^TMPHASIMPORT("BDPData",table)) q:table=""
		s menuID=$o(^User.BDPEIMenuI("UniqueCodeIndex"," "_$zcvt(table,"U"),0))
		if (menuID'="")
		{
			if (json'="")
			{
				s json =json_",{ID:"""_menuID_"""}"
			}
			else
			{
				s json =json_"{ID:"""_menuID_"""}"
			}
		}
	}
	
	s json="["_json_"]"
	q json
}

/// Creator:陈莹 
/// CreatDate:2016-10-1
/// Description:数据重复验证方法,js调用
/// Input:导入类型（BDPData）
/// Return:表名1 第2个节点、表名2 第3个节点、 2&%IHBI.KPITargetVal&%目标值维护
/// W ##class(web.DHCBL.BDP.BDPDataImport).GetImportGofInfo("BDPData")
ClassMethod GetImportGofInfo(type) As %String
{
	s mySysID = $s($d(%session):%session.%Id(),1:$j)
	s datainfo=""
	s i=0
	for 
	{
		s i=$o(^TMPIMPORTDATA(mySysID,type,i)) q:i=""
		s tablename=$o(^TMPIMPORTDATA(mySysID,type,i,0))
		s tablenamedesc=$o(^User.BDPIMConfigI("TableNameDescIndex",tablename,0))
		continue:tablenamedesc=""	
		if datainfo="" s datainfo=i_"&%"_tablename_"&%"_tablenamedesc
		else  s datainfo=datainfo_"#%"_i_"&%"_tablename_"&%"_tablenamedesc	
	}
	Q datainfo
}

/// Creator:陈莹 
/// CreatDate:2016-10-1
/// Description:导出“导入说明”（导出导入模版时调用）
/// Input:导入菜单对应的代码
/// Return:导出说明
/// Other:w ##class(web.DHCBL.BDP.BDPDataImport).GetExcelInstruction("CT_Province")
ClassMethod GetExcelInstruction(table) As %String
{
	q:table="" ""
	s IMCID=""
	s:table'="" table=$ZCONVERT(table,"U") //转换成大写
	s:table'="" IMCID=$o(^User.BDPIMConfigI("UniqueTableName"," "_table,0))
	q:IMCID="" ""
	s IMCText=$LISTGET($G(^User.BDPIMConfigD(IMCID)),12)  ///导入说明,add@2016-11-22
	q IMCText
}

/// Creator:陈莹 
/// CreatDate:2017-04-08
/// Description:导出模版时调用，工作簿名
/// Input:导入菜单对应的代码
/// Other:w ##class(web.DHCBL.BDP.BDPDataImport).GetTempletFieldDesc("CT_City")
/// Return:城市 （工作簿名)
ClassMethod GetMenuDesc(table) As %String
{
	n (table)
	s IMCID=""
	s:table'="" table=$ZCONVERT(table,"U") //转换成大写
	s:table'="" IMCID=$o(^User.BDPIMConfigI("UniqueTableName"," "_table,0))

	q:IMCID="" ""
	
	//s IMCTableDesc=$LISTGET($G(^User.BDPIMConfigD(IMCID)),2)  ///知识库度量定义
	S EIMenuID=$O(^User.BDPEIMenuI("UniqueCodeIndex"," "_$ZCVT(table,"U"),0))
	s IMCTableDesc=""
	s:EIMenuID'="" IMCTableDesc=$listget($g(^User.BDPEIMenuD(EIMenuID)),3)
	///工作簿名字不能超过31
	///不能为空
	/// 不能包含：\/?[]{}*等符号
	s IMCTableDesc=$tr(IMCTableDesc,"[","-")
	s IMCTableDesc=$tr(IMCTableDesc,"/","")
	s IMCTableDesc=$tr(IMCTableDesc,"\","")
	s IMCTableDesc=$tr(IMCTableDesc,"?","")
	s IMCTableDesc=$tr(IMCTableDesc,"]","")
	s IMCTableDesc=$tr(IMCTableDesc,"|","")
	s IMCTableDesc=$tr(IMCTableDesc,"*","")
	s IMCTableDesc=$tr(IMCTableDesc,":","")
	s IMCTableDesc=$tr(IMCTableDesc,"：","")
	
	q IMCTableDesc
}

/// Creator:陈莹 
/// CreatDate:2016-10-1
/// Description:导出模版时调用，工作簿名&%字段描述^字段name^是否必填0&#字段描述^字段name^是否必填1 ///按照顺序字段取字段信息，有维护顺序的排在前面，空的排在后面
/// Input:导入菜单对应的代码
/// Other:w ##class(web.DHCBL.BDP.BDPDataImport).GetTempletFieldDesc("CT_City")
/// Return:工作簿名&%字段描述1^字段name1^是否必填0&#字段描述2^字段name2^是否必填1
ClassMethod GetTempletFieldDesc(table) As %String
{
	n (table)
	s IMCID=""
	s:table'="" table=$ZCONVERT(table,"U") //转换成大写
	s:table'="" IMCID=$o(^User.BDPIMConfigI("UniqueTableName"," "_table,0))

	q:IMCID="" ""
	
	S EIMenuID=$O(^User.BDPEIMenuI("UniqueCodeIndex"," "_$ZCVT(table,"U"),0))
	s IMCTableDesc=""
	s:EIMenuID'="" IMCTableDesc=$listget($g(^User.BDPEIMenuD(EIMenuID)),3)
	s IMCTableDesc=$tr(IMCTableDesc,"/","")
	s IMCTableDesc=$tr(IMCTableDesc,"\","")
	s IMCTableDesc=$tr(IMCTableDesc,"?","")
	s IMCTableDesc=$tr(IMCTableDesc,"[","")
	s IMCTableDesc=$tr(IMCTableDesc,"]","")
	s IMCTableDesc=$tr(IMCTableDesc,"|","")
	s IMCTableDesc=$tr(IMCTableDesc,"*","")
	s IMCTableDesc=$tr(IMCTableDesc,"{","")
	s IMCTableDesc=$tr(IMCTableDesc,"}","")
	s IMCTableDesc=$tr(IMCTableDesc,":","")
	s IMCTableDesc=$tr(IMCTableDesc,"：","")
	///先排序，不导入的不排序
	k SeqArray
	s mySMSeq=0
	s n=0
	for {
		s mySMSeq=$o(^User.BDPIMFieldConfigI("ParSeqIdx",IMCID,mySMSeq))
		q:(mySMSeq="")
		s IMFCchildsub=0
		for
		{
			s IMFCchildsub=$o(^User.BDPIMFieldConfigI("ParSeqIdx",IMCID,mySMSeq,IMFCchildsub)) q:IMFCchildsub=""
			s IMFCImport=$listget($g(^User.BDPIMConfigD(IMCID,"ChildField",IMFCchildsub)),10)  ///是否导入
			continue:IMFCImport="N"
			s n=n+1
			s SeqArray(n)=IMFCchildsub
		}
	}
	///没有填写顺序的排在有顺序的后面
	if $d(^User.BDPIMFieldConfigI("ParSeqIdx",IMCID,-100000000000000))>0
	{
		s IMFCchildsub=0
		for
		{
			s IMFCchildsub=$o(^User.BDPIMFieldConfigI("ParSeqIdx",IMCID,-100000000000000,IMFCchildsub)) q:IMFCchildsub=""
			s IMFCImport=$listget($g(^User.BDPIMConfigD(IMCID,"ChildField",IMFCchildsub)),10)  ///是否导入
			continue:IMFCImport="N"
			s n=n+1
			s SeqArray(n)=IMFCchildsub
		}
	}

	s result=""
	s n=0
	for {
		s n=$o(SeqArray(n)) q:n=""
		s IMFCchildsub=$g(SeqArray(n))
		s IMFCFieldDesc=$LISTGET($G(^User.BDPIMConfigD(IMCID,"ChildField",IMFCchildsub)),2)
		s IMFCFieldName=$LISTGET($G(^User.BDPIMConfigD(IMCID,"ChildField",IMFCchildsub)),3)
		s IMFCRequired=$listget($g(^User.BDPIMConfigD(IMCID,"ChildField",IMFCchildsub)),9)
		s RFlag=0
		if (IMFCRequired="Y") s RFlag=1
		s IMFCFieldDescU=$ZCONVERT(IMFCFieldDesc,"U")
		continue:IMFCFieldDescU="ROWID"
		if (result'="")
		{
			s result=result_"&#"_IMFCFieldDesc_"^"_IMFCFieldName_"^"_RFlag
		}
		else
		{
			s result=IMFCFieldDesc_"^"_IMFCFieldName_"^"_RFlag
		}
		
	}

	q IMCTableDesc_"&%"_result
}

/// Creator:chenying
/// CreatDate:2017-2-7
/// Input:导入菜单对应的代码
/// Description:获取从第几个表格开始，到第几个表格结束，从第几行开始读取数据
/// Return:1&%1&%3
/// w ##class(web.DHCBL.BDP.BDPDataImport).GetEILinkInfo("CT_Province")
ClassMethod GetEILinkInfo(table) As %String
{
	s ID="",linkrowid=""
	s:table'="" table=$ZCONVERT(table,"U") //转换成大写
	s ID=$o(^User.BDPIMConfigI("UniqueTableName"," "_table,0))
	s:ID'="" linkrowid=$LISTGET($G(^User.BDPIMConfigD(ID)),10)
	Q:linkrowid="" ""
	s EILStartSheet=$listget($g(^User.BDPEILinkD(linkrowid)),6)
	s EILEndSheet=$listget($g(^User.BDPEILinkD(linkrowid)),7)
	s EILStartRow=$listget($g(^User.BDPEILinkD(linkrowid)),8)
	//s sheetinfo=EILStartSheet_"&%"_EILEndSheet_"&%"_EILStartRow
	//q sheetinfo
	q EILStartRow
}

/// Creator:chenying
/// CreatDate:2016-10-01
/// Description:每次导入之前先清除原来的导入信息
/// 备注：根据清空时间，每次导入把之前日期的都清掉，当天执行过导入则保留所有数据，以防多人操作时出现错误：
/// w ##class(web.DHCBL.BDP.BDPDataImport).KillImportGof()
ClassMethod KillImportGof() As %String
{
	s mySysID = $s($d(%session):%session.%Id(),1:$j)
	
	if ($g(^TMP("BDPImport","Time"))=+$h)
	{
		k ^TMPIMPORTDATA(mySysID)
	}
	else
	{
		k ^TMPIMPORTDATA
	}
	s ^TMP("BDPImport","Time")=+$h
	q ""
}

/// Creator：基础数据平台组 陈莹
/// CreatDate: 2017-3-15
/// Description：去掉字符串末尾的空格 中间的空格不处理
/// w ##class(web.DHCBL.BDP.BDPDataImport).trim(" v  dv fdfv   ")
/// 输入" v  dv fdfv   ",返回" v  dv fdfv"
ClassMethod trim(str) As %String
{
	While ($e(str,$l(str))=" ")
	{
		s str=$e(str,1,$l(str)-1)
	}
	q str
}

/// Creator：基础数据平台组 陈莹
/// CreatDate: 2016-10-08
/// Input:导入菜单对应的代码
/// Return:BDP导入导出菜单的描述
/// Description：通过BDP导入导出菜单的配置，根据代码获取描述(sheetname)
/// w ##class(web.DHCBL.BDP.BDPDataImport).GetImportTableNameDesc("CT_Loc")
ClassMethod GetImportTableNameDesc(tablename) As %String
{
	N (tablename)
	q:tablename="" ""
	//s tablename=..trim(tablename)
	//s TableNameDesc=$o(^User.BDPIMConfigI("TableNameDescIndex",tablename,0))
	S EIMenuID=$O(^User.BDPEIMenuI("UniqueCodeIndex"," "_$ZCVT(tablename,"U"),0))
	q:EIMenuID="" ""
	s TableNameDesc=$listget($g(^User.BDPEIMenuD(EIMenuID)),3)
	s TableNameDesc=$tr(TableNameDesc,"/","")
	q TableNameDesc
}

/// Creator:chenying
/// CreatDate:2017-03-24
/// return:"" 符合  ，不符合 则返回报错信息
/// Description:校验字段信息是否有配置，是否有重复的
/// w ##class(web.DHCBL.BDP.BDPDataImport).ValidatePropertyName("ARC_ItmMast","ARCIMCode&%ARCIMDesc&%ARCIMBillingUOMDR&%OLTQty&%TARICode&%TARIDesc&%TPPrice&%TARIUOM&%ARCIMAbbrev&%ALIASText&%ARCIMOEMessage&%OrdCat&%ARCIMItemCatDR&%ARCIMServMaterial&%BillGrp&%ARCIMBillSubDR&%TarCat&%TARISubCate&%InpaCat&%TARIInpatCate&%OutpaCat&%TARIOutpatCate&%EmCat&%TARIEMCCate&%AcctCat&%TARIAcctCate&%MrCat&%TARIMRCate&%MrCatNew&%TARIMCNew&%ARCIMDefPriorityDR&%ARCIMOrderOnItsOwn&%ARCIMAllowOrderWOStockCheck&%OLTBascPriceFlag&%OLTBillOnceFlag&%ARCIMSensitive&%ARCIMChgOrderPerHour&%ARCIMRestrictOP&%ARCIMRestrictIP&%ARCIMRestrictEM&%ARCIMDeceasedPatientsOnly&%ARCIMDisplayCumulative&%ARCIMUseODBCforWord&%ARCIMServiceGroupDR&%ARCIMDerFeeRulesDR&%ARCIMEffDate&%ARCIMEffDateTo&%TIAAlias&%TARIAlterPrice1&%TARIAlterPrice2&%TARIChargeBasis&%TARIActiveFlag&%TARIStartDate&%TARIEndDate&%TARISpecialFlag&%TARIExternalCode&%TARIEngName&%TARIInsuName")
ClassMethod ValidatePropertyName(table, propnameStr) As %String
{
	n (table,propnameStr)
	s return=""
	;  //KBDCode&%KBDName&%TableName
	s table=..trim(table)
	S IMCID=$O(^User.BDPIMConfigI("UniqueTableName"," "_$ZCVT(table,"U"),0))
	q:IMCID="" 1
	
	k ^TMP("BDPDataImport","FieldName")
	s childsub=0
	for 
	{
		s childsub=$o(^User.BDPIMConfigD(IMCID,"ChildField",childsub)) q:childsub=""  //
		s IMFCFieldName=$LISTGET($G(^User.BDPIMConfigD(IMCID,"ChildField",childsub)),3)  ///KBDCode
		s IMFCFieldDesc=$LISTGET($G(^User.BDPIMConfigD(IMCID,"ChildField",childsub)),2)
		s IMFCRequired=$listget($g(^User.BDPIMConfigD(IMCID,"ChildField",childsub)),9)
		if (IMFCRequired="Y") ///以空值暂时默认为不是必填项
		{
			s ^TMP("BDPDataImport","FieldName","Required",IMFCFieldName)=IMFCFieldDesc
		}
		s ^TMP("BDPDataImport","FieldName","Name",IMFCFieldName)=IMFCFieldDesc
		s ^TMP("BDPDataImport","FieldName","Desc",IMFCFieldDesc)=IMFCFieldName
		
	}
	
	///判断是否缺少必填项
	s LackField=""
	s Prpstr="&%"_propnameStr_"&%"
	s name=0
	for
	{
		s name=$o(^TMP("BDPDataImport","FieldName","Required",name)) q:name=""
		if Prpstr'[("&%"_name_"&%")
		{
			if LackField="" s LackField=name
			else  s LackField=LackField_"、"_name
		}
		
	}
	
	//校验字段描述改成校验字段名  2017-03-01
	s propStr=""
	s ErrorField=""
	
	s RepeatField="",EmptyField=""
	s le=$L(propnameStr,"&%")
	
	for i=1:1:le
	{
		s fieldname=$p(propnameStr,"&%",i)
		
		
		if fieldname=""
		{
			if EmptyField="" s EmptyField=i
			else  s EmptyField=EmptyField_","_i
			continue
		}
		else
		{
			if $d(^TMP("BDPDataImport","FieldName","Web",fieldname))=0
			{
				 s ^TMP("BDPDataImport","FieldName","Web",fieldname)=i
			}
			else
			{
				 if RepeatField="" s RepeatField=fieldname
				 else  s RepeatField=RepeatField_"、"_fieldname
			}
		
			s fielddesc=$g(^TMP("BDPDataImport","FieldName","Name",fieldname))
			if fielddesc=""
			{
				 if ErrorField="" s ErrorField=fieldname
				 else  s ErrorField=ErrorField_"、"_fieldname
			}
			
		}
			
	}
	k ^TMP("BDPDataImport","FieldName")
	if ErrorField'=""
	{
		s return= return_"导入配置里缺少"_ErrorField_"字段！"
	}
	if LackField'=""
	{
		s return=return_ "表格里缺少 "_LackField_" 必填字段！"
	}
	if RepeatField'=""
	{
		s return=return_"Excel表格里"_RepeatField_"字段有多列！"
	}
	if EmptyField'=""
	{
		s return=return_"Excel表格里第"_EmptyField_"列字段名为空！"
	}
	
	q return
}

/// Creator:chenying
/// CreatDate:2017-2-17
/// Description:导入基本信息，包括字段名，表名，表描述等信息
/// w ##class(web.DHCBL.BDP.BDPDataImport).ImportTabBaseInfo("BDPData","2","KPI指标定义","IHBI.KBaseDefine","Y","J","KBDCode&%KBDName&%TableName","KPIDR@%KPICode&%^$o(IHBI.BaseKPIDefineI("UqKPICodeIdx"," "_$ZCONVERT(KPICode,"U"),0))","ID","$o(^IHBI.KBaseDefineI("KBDCodeIndex",KBDCode,0))")
ClassMethod ImportTabBaseInfo(type, sheetnum, sheetname, tablename, propdescStr, propnameStr As %String = "") As %String
{
	n (type, sheetnum, sheetname, tablename, propdescStr, propnameStr ,%session)
	s mySysID = $s($d(%session):%session.%Id(),1:$j)
	;  //KBDCode&%KBDName&%TableName
	s tablename=..trim(tablename)
	
	s ^TMPIMPORTDATA(mySysID,type,sheetnum,tablename)=propnameStr
	s ^TMPIMPORTDATA(mySysID,type,sheetnum)="Y&%J"
	s ^TMPIMPORTDATA(mySysID,type,sheetnum,0,"TableNameDesc")=sheetname
	s ^TMPIMPORTDATA(mySysID,type,sheetnum,tablename_"FieldDesc")=propdescStr
	
	q 1
}

/// Creator:陈莹 
/// CreatDate:2016-10-0
/// w ##class(web.DHCBL.BDP.BDPDataImport).ImportIntoGlobal("BDPData","IHBI.KBaseDefine","4","InjectionDrug&%注射药品&%"PHC_Instruc&%&%&%A&%&%","Y","Y","J")
/// Description:将每条数据保存到后台并过滤特殊字符和末尾空格
/// Return:1 保存成功，0 保存失败
ClassMethod ImportIntoGlobal(type, tablename, sheetnum, row, datastr, dataflag) As %String
{
	s mySysID = $s($d(%session):%session.%Id(),1:$j)
	q:(tablename="")||(datastr="") 0
	s result=0
	
	///过滤特殊字符 总监需求  2017-03-07
	s datastr=$tr(datastr,$c(13),"")
	s datastr=$tr(datastr,$c(10),"")
	s datastr=$tr(datastr,$c(0),"")
	s datastr=$tr(datastr,"""","”")   ////2017-03-24  检查检验治疗数据中有带英文双引号的数据
	s ^TMPIMPORTDATA(mySysID,type,sheetnum,tablename,row)=datastr
	s ^TMPIMPORTDATA(mySysID,type,sheetnum,tablename,row,"dataflag")=dataflag
	
	q 1
}

/// Creator:陈莹 
/// CreatDate:2016-10-08
/// Description:修改导入类型  U 修正  J追加，N 新装数据
/// Other:w ##class(web.DHCBL.BDP.BDPDataImport).updateimporttype("","","")
ClassMethod updateimporttype(typecomboid, typecombovalue) As %String
{
	s mySysID = $s($d(%session):%session.%Id(),1:$j)
	s type=$p(typecomboid,"#",1)
	s sheetnumb=$p(typecomboid,"#",2)
	s $p(^TMPIMPORTDATA(mySysID,type,sheetnumb),"&%",2)=typecombovalue
	q 1
}

/// CreatDate:2016-12-5
/// Creator：陈莹
/// Description:预校验数据（excel、txt、gof）
/// w ##class(web.DHCBL.BDP.BDPDataImport).PreCheckValidate("BDPData")
/// 配置里是否有要导入的字段，必填项，Dr指针对应的表是否有数据，（日期格式，时间格式 后期加）
/// ^TMPIMPORTDATA
ClassMethod PreCheckValidate(type) As %String
{
	N (type,%session)
	s mySysID =$s($d(%session):%session.%Id(),1:$j)
	;清除错误信息
	k ^TMPIMPORTERROR
	k ^TMPIMPORTDATA(mySysID,type,"error")
	k ^TMP("BDPExt")     //^TMP("BDPExt","LINKCTLOCDR"),^TMP("BDPExt","PACBed")
	k ^TMP("BDPDataImport")    ///^TMP("BDPDataImport","LOCKGLOBAL"),^TMP("BDPDataImport","TREEDR"),NonConfig,NoImport
	s returnstr=""
	s sheetnum=0
	s sheetnum=$o(^TMPIMPORTDATA(mySysID,type,sheetnum))
	if sheetnum="" q "没有数据!"
	s tablenamedesc=$g(^TMPIMPORTDATA(mySysID,type,sheetnum,0,"TableNameDesc"))
	s tablename=$o(^TMPIMPORTDATA(mySysID,type,sheetnum,0))   //导入导出菜单的代码
	
	s tableListName=##class(web.DHCBL.BDP.BDPEIMenu).GetTableNameByCode(tablename) 
	s IMCID=$O(^User.BDPIMConfigI("UniqueTableName"," "_$ZCVT(tablename,"U"),0))
	if (IMCID="")
	{
		q "请先导入相关配置!"  ///没有导入配置
	}
	s treeflag=0
	s tableflag=$p($g(^TMPIMPORTDATA(mySysID,type,sheetnum)),"&%",1)
	s importtype=$p($g(^TMPIMPORTDATA(mySysID,type,sheetnum)),"&%",2)
	s Totalrowerror=""
	if (tableflag="Y")
	{
		s tablename=$o(^TMPIMPORTDATA(mySysID,type,sheetnum,0))
		S EIMenuId=$o(^User.BDPEIMenuI("UniqueCodeIndex"," "_$zcvt(tablename,"u"),0))
		s LockFlag=$LISTGET($G(^User.BDPEIMenuD(EIMenuId)),12)
		if LockFlag="Y" Q "表已锁，不能导入数据"
		///新装数据
		if (importtype="N")
		{
			////取平台配置 判断是否允许新装数据
			s configid=$o(^User.BDPConfigI("ConfigCodeI"," BDPNEWDATA",0))
			if configid="" q "请先更新平台配置数据！"
			s newdataflag=$listget($g(^User.BDPConfigD(configid)),3)
			if newdataflag'="Y" Q "请先在【平台配置】页面开启新装数据功能！"	
			s Kglobal =$LISTGET($G(^User.BDPEIMenuD(EIMenuId)),9)
			if (Kglobal'="")
			{
				///循环 已经锁了的菜单， 判断他的kgolbal是否包含这个要导入的表对应的kglbal，包含则不能清除数据
				s MenuId=0
				for
				{
					s MenuId=$o(^User.BDPEIMenuD(MenuId)) q:MenuId=""
					s Lock=$LISTGET($G(^User.BDPEIMenuD(MenuId)),12)
					if (Lock="Y")
					{
						s global=$LISTGET($G(^User.BDPEIMenuD(MenuId)),9)
					
						if (global'="")
						{
							s length=$l(global,",")
							for gi=1:1:length
							{
								s globali=$p(global,",",gi)
								if globali'="" s ^TMP("BDPDataImport","LOCKGLOBAL",globali)=MenuId
							}					
						}				
					}			
				}
				
				s klength=$l(Kglobal,",")
				s kgresult=""
				s kgi=0
				for
				{
					s kgi=kgi+1  q:(kgi>klength)||(kgresult'="")
					s kglobali=$p(Kglobal,",",kgi)
					if $d(^TMP("BDPDataImport","LOCKGLOBAL",kglobali))>0 
					{	
						s MenuId=$g(^TMP("BDPDataImport","LOCKGLOBAL",kglobali))
						s Caption=$LISTGET($G(^User.BDPEIMenuD(MenuId)),3)
						s kgresult="本次导数据涉及到的 "_kglobali_" Global已经锁定，不能进行新装数据，如果确定要新装，请先把 "_Caption_" 菜单解锁！"
					}
				}				
				q:kgresult'="" kgresult
				
			}
		}
		
		s Rowid=$LISTGET($G(^User.BDPIMConfigD(IMCID)),4)
		s ctclassname=$LISTGET($G(^User.BDPIMConfigD(IMCID)),5)
		s savemethod=$LISTGET($G(^User.BDPIMConfigD(IMCID)),6)
		s entityclassname=$LISTGET($G(^User.BDPIMConfigD(IMCID)),7)
		s neweobjstr="s Importeobj=##class("_entityclassname_").%New()"
		s Propcount=$l($g(^TMPIMPORTDATA(mySysID,type,sheetnum,tablename)),"&%")
		s saveeobjstr="s saveresult=##class("_ctclassname_")."_savemethod_"(Importeobj)"
		
		s codeIndex=$LISTGET($G(^User.BDPIMConfigD(IMCID)),8)
		s codeIndexstr="s oid="""""
		if codeIndex'="" s codeIndexstr="s oid="_codeIndex
		//s eobjRowidstr="s Importeobj."_Rowid_"="""""
		//if codeIndex'="" s eobjRowidstr="s Importeobj."_Rowid_"="_codeIndex_""
		
		s row=0
		for
		{
			s row=$o(^TMPIMPORTDATA(mySysID,type,sheetnum,tablename,row)) q:row=""
			s dataflag=$g(^TMPIMPORTDATA(mySysID,type,sheetnum,tablename,row,"dataflag"))
			i (dataflag="Y")
			{
				s datastr=$g(^TMPIMPORTDATA(mySysID,type,sheetnum,tablename,row))  ///&%
				
				s errorflag=0
				
				s KtableName =$LISTGET($G(^User.BDPEIMenuD(EIMenuId)),7)  //DKB_PositionCat,DKB_PathogenyCat
				if (KtableName'="")
				{
					s ktlength=$l(KtableName,",")
					s ktresult=""
					s kti=0
					for
					{
						s kti=kti+1  q:(kti>ktlength)||(ktresult'="")
						s ktitablename=$p(KtableName,",",kti)  ///DKB_PositionCat
						q:ktitablename=""
						
						if (ktitablename="BDP_Menu")||(ktitablename="DKB_PositionCat")||(ktitablename="DKB_PathogenyCat")  //||(ktitablename="DHC_PHCCat")
						{
							s treeflag=1
							s value=$p(datastr,"&%",1)
							continue:value=""
							s prp=$p($g(^TMPIMPORTDATA(mySysID,type,sheetnum,tablename)),"&%",1)
							continue:prp=""
							s TMPTreeDRflag="if "_value_"'="""" s ^TMP(""BDPDataImport"",""TREEDR"","""_ktitablename_""","""_value_""")="_row
							x TMPTreeDRflag
						}
						
					}
				}
				
				s AllErrorStr=""
				s i=0
				for i=1:1:Propcount
				{
					s value=$p(datastr,"&%",i)
					s value=..trim(value)  ///只过滤末尾的空格
					s prp=$p($g(^TMPIMPORTDATA(mySysID,type,sheetnum,tablename)),"&%",i)
					continue:prp=""
					s prpdesc=$p($g(^TMPIMPORTDATA(mySysID,type,sheetnum,tablename_"FieldDesc")),"&%",i) ///字段描述  //2
					if prpdesc="" s prpdesc=prp
					
					s IMFCchildsub=$o(^User.BDPIMFieldConfigI("FieldNameUniqueI"," "_$ZCVT(prp,"u"),IMCID,0))
					if IMFCchildsub=""
					{
						//通过字段名 CTCITCode&%CTCITDesc&%CTCITProvinceDR&%CTCITDateFrom&%CTCITDateTo  校验字段
						s ^TMP("BDPDataImport","NonConfig",prp)=prpdesc
						s AllErrorStr=AllErrorStr_"【"_prpdesc_"】"_"在导入配置表里没有维护，"  ///必填项为空值	
					}
					else
					{
					
						///取字段在导入配置表中的类型
						S proptype=$listget($g(^User.BDPIMConfigD(IMCID,"ChildField",IMFCchildsub)),4)
					
						////2016-11-22判断是否导入
						s IMFCImport=$listget($g(^User.BDPIMConfigD(IMCID,"ChildField",IMFCchildsub)),10)
						if (IMFCImport="N")   ///N为不导入，Y和空值为导入
						{
							s ^TMP("BDPDataImport","NoImport",prp)=IMCID_"||"_IMFCchildsub
							s propstr="s "_prp_"="_""""_value_""""
							x propstr	
						}
						else
						{
							////2016-11-22判断是否是必填项
							s IMFCRequired=$listget($g(^User.BDPIMConfigD(IMCID,"ChildField",IMFCchildsub)),9)
							if (IMFCRequired="Y")&&(value="") ///以空值暂时默认为不是必填项
							{
								s propstr="s "_prp_"="_""""_value_""""
								x propstr
								///必填项为空值， 返回报错
								s AllErrorStr=AllErrorStr_"【"_prpdesc_"】为必填项，"
							}
					
							////判断是否唯一!
							//s IMFCUnique=$listget($g(^User.BDPIMConfigD(IMCID,"ChildField",IMFCchildsub)),8)
							
							s propstr="s "_prp_"="_""""_value_""""
							x propstr
							//用户医护人员表格 医院因为是拼接的，LinkHospId取第一个医院
							if ((tablename="SS_User")&&(prp="SSUSRHospitalDR"))
							{
								s LinkHospId=$p(value,"/",1)
								if LinkHospId'="" s LinkHospId=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByDesc("CT_Hospital",LinkHospId,"")
							}
							if (proptype="DR")
							{
								
								if (value'="")
								{
									s IMFCConTable=$listget($g(^User.BDPIMConfigD(IMCID,"ChildField",IMFCchildsub)),6)
									if (treeflag=1)
									{
										//s drtoidstr=$listget($g(^User.BDPIMConfigD(IMCID,"ChildField",IMFCchildsub)),5)
										//s Propdrstr="if "_prp_"'="""" s "_prp_"="_drtoidstr
										//2019-07-05
										if drtoidstr'=""
										{
											 s Propdrstr="if "_prp_"'="""" s "_prp_"="_drtoidstr
										}
										else
										{
											
											s drtoidstr="##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByDesc(IMFCConTable,prpvalue,$g(LinkHospId))"
											/*
											if ((IMFCConTable="PH_Manufacturer")||(IMFCConTable="APC_Vendor")||(IMFCConTable="DHC_Carrier")||(IMFCConTable="DHC_STOrigin")||(IMFCConTable="INC_StkCat"))
											{
												if (tablename="PHC_DrgMastNew")
												{
													s drtoidstr="##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByDesc(IMFCConTable,prpvalue_""^G"",$g(LinkHospId))"
												}
												if (tablename="INC_Itm")
												{
													s drtoidstr="##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByDesc(IMFCConTable,prpvalue_""^M"",$g(LinkHospId))"
												}
											}
											*/
											
											x "s prpvalue="_""""_value_""""
											s Propdrstr="if "_prp_"'="""" s "_prp_"="_drtoidstr
											
										}
										X Propdrstr
										//科室，分诊区，收费项目调价，用户其他登录科室，医嘱套
										if ((tablename="CT_Loc")&&(prp="CTLOCHospitalDR"))||((tablename="DHC_TarItemPrice")&&(prp="TPHospitalDR"))||((tablename="SS_UserOtherLogonLoc")&&(prp="OTHLLHospitalDR"))||((tablename="DHCExaBorough")&&(prp="ExabHospitalDr"))||((tablename="ARC_OrdSets")&&(prp="FavUseHospDr"))
										{
											x "s LinkHospId=$g("_prp_")"
										}
							
										s drerrorflag=0
										s DRValidateflagstr="if "_prp_"="""" s drerrorflag=1"
										x DRValidateflagstr
										
										if prp="LinkHospId"
										{
											if (LinkHospId<0) s AllErrorStr=AllErrorStr_LinkHospId_"，"
											
										}
										if drerrorflag=1
										{
											s AllErrorStr=AllErrorStr_"【"_prpdesc_"】 "_value_" 在 "_IMFCConTable_" 表中没找到这一级，"
											
										}
									}
									else
									{	
										s drtoidstr=$listget($g(^User.BDPIMConfigD(IMCID,"ChildField",IMFCchildsub)),5)
										//if IMFCConTable'=""
										//{
											//if drtoidstr'="" s Propdrstr="if "_prp_"'="""" s "_prp_"="_drtoidstr
											//else  s Propdrstr="if "_prp_"'="""" s "_prp_"="""""
											//2019-07-05
											if drtoidstr'=""
											{
												 s Propdrstr="if "_prp_"'="""" s "_prp_"="_drtoidstr
											}
											else
											{
												x "s prpvalue="_""""_value_""""
												s drtoidstr="##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByDesc(IMFCConTable,prpvalue,$g(LinkHospId))"
												/*
												if ((IMFCConTable="PH_Manufacturer")||(IMFCConTable="APC_Vendor")||(IMFCConTable="DHC_Carrier")||(IMFCConTable="DHC_STOrigin")||(IMFCConTable="INC_StkCat"))
												{
													if (tablename="PHC_DrgMastNew")
													{
														s drtoidstr="##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByDesc(IMFCConTable,prpvalue_""^G"",$g(LinkHospId))"
													}
													if (tablename="INC_Itm")
													{
														s drtoidstr="##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByDesc(IMFCConTable,prpvalue_""^M"",$g(LinkHospId))"
													}
												}
												*/
												
												s Propdrstr="if "_prp_"'="""" s "_prp_"="_drtoidstr
												
											}
											X Propdrstr
											//科室，分诊区，收费项目调价，用户其他登录科室，医嘱套
											if ((tablename="CT_Loc")&&(prp="CTLOCHospitalDR"))||((tablename="DHC_TarItemPrice")&&(prp="TPHospitalDR"))||((tablename="SS_UserOtherLogonLoc")&&(prp="OTHLLHospitalDR"))||((tablename="DHCExaBorough")&&(prp="ExabHospitalDr"))||((tablename="ARC_OrdSets")&&(prp="FavUseHospDr"))
											{
												x "s LinkHospId=$g("_prp_")"
											}
								
											s drerrorflag=0
											s DRValidateflagstr="if "_prp_"="""" s drerrorflag=1"
											x DRValidateflagstr
											
											if prp="LinkHospId"
											{
												if (LinkHospId<0) s AllErrorStr=AllErrorStr_LinkHospId_"，"
												
											}
											if drerrorflag=1
											{
												s AllErrorStr=AllErrorStr_"【"_prpdesc_"】 "_value_"在 "_IMFCConTable_" 表中没找到这条数据，"
												
											}
											
											
										//}
								
									}
								}
						
							}
							elseif (proptype["Date")
							{
								if value'=""
								{
									//如果日期不包含-或者/
									if (value'["-")&&(value'["/")
									{
										s AllErrorStr=AllErrorStr_"【"_prpdesc_"】格式校验失败，"
									}
									else
									{
										s valueLogical= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(value)
										if '(valueLogical>0)
										{
											s AllErrorStr=AllErrorStr_"【"_prpdesc_"】格式校验失败，"
											
										}
									}
								}
							}
							elseif (proptype["Time")
							{
								if value'=""
								{
									//如果时间不包含:
									if (value'[":")
									{
										s AllErrorStr=AllErrorStr_"【"_prpdesc_"】格式校验失败，"
									}
									else
									{
										s valueLogical= ##class(web.DHCBL.BDP.FunLib).TimeHtmlToLogical(value,1)
										if '(valueLogical>0)
										{
											s AllErrorStr=AllErrorStr_"【"_prpdesc_"】格式校验失败，"
										}
									}
								}
							}
							elseif (proptype["Float")
							{
								if value'=""
								{
									s validateFlag=##class(web.DHCBL.BDP.FunLib).IsNonnegativeNumber(value)   ///0或正数
									if validateFlag=-1 s AllErrorStr=AllErrorStr_"【"_prpdesc_"】 "_value_" 不是有效数字，"
								}
						
							}		
							elseif (proptype["Integer")
							{
								if value'=""
								{
									s validateFlag=##class(web.DHCBL.BDP.FunLib).IsPositiveInteger(value)
									if validateFlag=-1 s AllErrorStr=AllErrorStr_"【"_prpdesc_"】 "_value_" 不是正整数，"
								}
						
							}
							elseif (proptype["Y/N")
							{
								if value'=""
								{
									s value=$tr(value," ","")
									s value=$tr(value,"　","")
									s value=$zcvt(value,"U")   ///2017-04-10  
									if value="是" s value="Y"
									if value="否" s value="N"
									if (value'="Y")&&(value'="N")&&(value'="")
									{
										s AllErrorStr=AllErrorStr_"【"_prpdesc_"】 "_value_" 不是Y/N，"
									}
									else
									{
										s propstr="s "_prp_"="_""""_value_""""
										x propstr
								
									}
								}
						
							}
						}
					}
				}
				
				if (AllErrorStr'="")	
				{
					s ^TMPIMPORTDATA(mySysID,type,"error",tablename,row)="UV"_"&&"_AllErrorStr_"请核对数据"_"&&"_datastr
					continue
				}
				
				s oid=""
				x codeIndexstr
				
				if (oid'="")
				{
					if (importtype="J") //code相同的 跳过
					{
						s ^TMPIMPORTDATA(mySysID,type,"error",tablename,row)="J"_"&&"_"只追加模式下，代码或描述数据已存在，跳过导入"_"&&"_datastr
						continue
					}
				}
				x neweobjstr
				
				for i=1:1:Propcount  //pCOUNT
				{
					s prp=$p($g(^TMPIMPORTDATA(mySysID,type,sheetnum,tablename)),"&%",i)
					continue:prp=""
					continue:$d(^TMP("BDPDataImport","NoImport",prp))>0  //不导入的数据过滤掉
					continue:$d(^TMP("BDPDataImport","NonConfig",prp))>0
					s propstr="s Importeobj."_prp_"="_prp
					try
					{
						x propstr				
					}
					catch(e)
					{
						s ^TMPIMPORTDATA(mySysID,type,"error",tablename,row)="UV"_"&&"_$ze_"请核对数据"_"&&"_datastr
						continue
					}
				}
				
				if (tablename="DHC_PHCCat")   //药理学分类
				{
					s TMPDHCLevel=1
					if (Importeobj.PHCCCat1'="") s TMPDHCLevel=1
					if (Importeobj.PHCCCat2'="") s TMPDHCLevel=2
					if (Importeobj.PHCCCat3'="") s TMPDHCLevel=3
					if (Importeobj.PHCCCat4'="") s TMPDHCLevel=4
					if (Importeobj.PHCCCat5'="") s TMPDHCLevel=5
					if (Importeobj.PHCCCat6'="") s TMPDHCLevel=6
					if (Importeobj.PHCCCat7'="") s TMPDHCLevel=7
					s ^TMPBDPPHCCAT(row)=Importeobj.PHCCCode_"^"_TMPDHCLevel
					///寻找上级分类的代码
					if (TMPDHCLevel>1)
					{
						if row>1
						{
							if $d(^TMPBDPPHCCAT(row-1))>0
							{
								s tempLevel=$p($g(^TMPBDPPHCCAT(row-1)),"^",2)
								if (TMPDHCLevel-tempLevel)>1
								{
									 s AllErrorStr=AllErrorStr_"药理学分类数据层级关系有误，"
								}
							}
							
						}
						s lastrow=row
						for
						{
							s lastrow=$o(^TMPBDPPHCCAT(lastrow),-1) q:lastrow=""
							if ($p($g(^TMPBDPPHCCAT(lastrow)),"^",2)=(TMPDHCLevel-1))
							{
								s Importeobj.PHCCParCatDrCode=$p($g(^TMPBDPPHCCAT(lastrow)),"^",1)
								q
							}
							
						}
						
					}
				}
				//x eobjRowidstr	
				s CheckResult=0
				///新装时只校验数据有效性，不校验代码和描述是否重复
				if (importtype="N") s CheckResult=##class(web.DHCBL.BDP.BDPDataImport).ValidateCheck(tablename,Importeobj,0)   //1为校验重复，0位不校验，只校验字段值是否有效
				else  s CheckResult=##class(web.DHCBL.BDP.BDPDataImport).ValidateCheck(tablename,Importeobj,1)
				if (CheckResult'="")
				{
					s ^TMPIMPORTDATA(mySysID,type,"error",tablename,row)="UV"_"&&"_CheckResult_"请核对数据"_"&&"_datastr
				}
				
						
			}
		}	
	}	
	s row=0
	s SuccessCount=0,ErrorCount=0,TotalCount=0
	for
	{
		s row=$o(^TMPIMPORTDATA(mySysID,type,"error",tablename,row)) q:row=""
		s ErrorCount=ErrorCount+1
	}
	if $d(^TMPIMPORTDATA(mySysID,type,sheetnum,tablename)) s TotalCount=$o(^TMPIMPORTDATA(mySysID,type,sheetnum,tablename,""),-1)-2
	s SuccessCount=TotalCount-ErrorCount
	s returnstr=TotalCount_"^"_SuccessCount_"^"_ErrorCount

	q returnstr
}

/// CreatDate:2018-04-26
/// Creator：陈莹
/// Description:清除表对应的国标数据
/// D ##class(web.DHCBL.BDP.BDPDataImport).ClearBDPStandardCodeData("ORC_Operation")
/// ^User.BDPStandardCodeD
ClassMethod ClearBDPStandardCodeData(tablename) As %String
{
	n (tablename)
	Q:tablename="" ""
	s DataReference=0
	for
	{
		s DataReference=$o(^User.BDPStandardCodeI("DataRef",tablename,DataReference)) q:DataReference=""
		s SID=0
		for
		{
			s SID=$o(^User.BDPStandardCodeI("DataRef",tablename,DataReference,SID)) q:SID=""
			D ##class(User.BDPStandardCode).%DeleteId(SID)
		}
	}	
	Q ""
}

/// CreatDate:2020-06-17
/// Creator：陈莹
/// Description:清除表对应的别名数据
/// D ##class(web.DHCBL.BDP.BDPDataImport).ClearAliasData("ORC_Operation")
ClassMethod ClearAliasData(tablename) As %String
{
	n (tablename)
	Q:tablename="" ""
	s refenence=0
	for
	{
		s refenence=$o(^User.BDPAliasI("DataRef",tablename,refenence)) q:refenence=""
		s aliasid=0
		for
		{
			s aliasid=$o(^User.BDPAliasI("DataRef",tablename,refenence,aliasid)) q:aliasid=""
			D ##class(User.BDPAlias).%DeleteId(aliasid)
		}
	}

	Q ""
}

/// CreatDate:2020-06-17
/// Creator：陈莹
/// Description:清除表对应的翻译数据
/// D ##class(web.DHCBL.BDP.BDPDataImport).ClearTransData("ORC_Operation")
ClassMethod ClearTransData(tablename) As %String
{
	n (tablename)
	Q:tablename="" ""
	S TableListID=$o(^User.BDPTableListI("NameIndex"," "_$zcvt(tablename,"U"),0))
	if TableListID'=""
	{
		s ClassName=$LISTGET($G(^User.BDPTableListD(TableListID)),2)
		s transid=0
		for
		{
			s transid=$o(^User.BDPTranslationI("TableIndex"," "_$zcvt(ClassName,"U"),transid)) q:transid=""
			D ##class(User.BDPTranslation).%DeleteId(transid)
		}
	}	
	Q ""
}

/// CreatDate:2020-06-20
/// Creator：陈莹
/// Description:清除表对应的基础数据日志
/// D ##class(web.DHCBL.BDP.BDPDataImport).ClearDataLogData("ORC_Operation")
ClassMethod ClearDataLogData(tablename) As %String
{
	n (tablename)
	Q:tablename="" ""
	s id=0
	for
	{
		s id=$o(^User.BDPDataChangeLogI("TableNameIndex"," "_$zcvt(tablename,"U"),id)) q:id=""
		D ##class(User.BDPDataChangeLog).%DeleteId(id)
	}
	Q ""
}

/// CreatDate:2016-11-2
/// Creator：陈莹
/// Description:保存数据（excel、txt、gof）
/// w ##class(web.DHCBL.BDP.BDPDataImport).BeforeSaveImportData("BDPData")
/// ^TMPIMPORTDATA
ClassMethod BeforeSaveImportData(type) As %String
{
	N (type,%session)
	
	s mySysID =$s($d(%session):%session.%Id(),1:$j)
	;清除错误信息
	s returnstr=""
	s sheetnum=0
	s sheetnum=$o(^TMPIMPORTDATA(mySysID,type,sheetnum))
	if sheetnum="" q "没有数据!"
	//s tablenamedesc=$g(^TMPIMPORTDATA(mySysID,type,sheetnum,0,"TableNameDesc"))
	//s IMCID=$O(^User.BDPIMConfigI("UniqueTableDesc"," "_$ZCVT(tablenamedesc,"U"),0))
	s tablenamedesc=$g(^TMPIMPORTDATA(mySysID,type,sheetnum,0,"TableNameDesc"))
	s tablename=$o(^TMPIMPORTDATA(mySysID,type,sheetnum,0))
	s IMCID=$O(^User.BDPIMConfigI("UniqueTableName"," "_$ZCVT(tablename,"U"),0))
	if (IMCID="")
	{
		q "请先导入相关配置!"  ///没有导入配置
	}
	
	if (tablename="DHC_PHCCat") k ^TMPBDPPHCCAT   //如果是药理学分类  就清除记录的上级分类临时global数据 20170905
	s tableflag=$p($g(^TMPIMPORTDATA(mySysID,type,sheetnum)),"&%",1)
	s importtype=$p($g(^TMPIMPORTDATA(mySysID,type,sheetnum)),"&%",2)
	
	s PreValidateResult=##class(web.DHCBL.BDP.BDPDataImport).PreCheckValidate(type)
	if PreValidateResult'["^" q PreValidateResult
	
	s ^TMP("BDPDataImport","ImportTime",mySysID,tablename,"BDPDataChangeLogID")=$o(^User.BDPDataChangeLogD(""),-1)
	s ^TMP("BDPDataImport","ImportTime",mySysID,tablename)=$h
	s Totalrowerror=""
	if (tableflag="Y")
	{	
		S EIMenuId=$o(^User.BDPEIMenuI("UniqueCodeIndex"," "_$zcvt(tablename,"u"),0))
		if (importtype="N") //新装数据
		{	
			///获取	导入菜单对应的表名s
			s EITableNames=$LISTGET($G(^User.BDPEIMenuD(EIMenuId)),7)
			if EITableNames'=""
			{
				for lengthi=1:1:$l(EITableNames,",")
				{
					s SQLTablename=$p(EITableNames,",",lengthi)
					continue:SQLTablename=""
					D ##class(web.DHCBL.BDP.BDPMappingHOSP).DeleteTableHospitals(SQLTablename)  //清除私有数据/管控数据和医院关联
					D ##class(web.DHCBL.BDP.BDPDataImport).ClearBDPStandardCodeData(SQLTablename) ///清除表 对照的国标数据
					D ##class(web.DHCBL.BDP.BDPDataImport).ClearAliasData(SQLTablename) ///清除表 别名
					D ##class(web.DHCBL.BDP.BDPDataImport).ClearTransData(SQLTablename) ///清除表 翻译的数据 2020-06-17
					D ##class(web.DHCBL.BDP.BDPDataImport).ClearDataLogData(SQLTablename) ///清除表 日志的数据 2020-06-20
				}
			}
			s Kglobal =$LISTGET($G(^User.BDPEIMenuD(EIMenuId)),9)
			if Kglobal["d ##class"
			{
				x Kglobal	
			}
			else
			{
				if (Kglobal'="")
				{
					if $e(Kglobal,1,3)="k ^" s kxtr=Kglobal
					else  s kxtr="k "_Kglobal
					x kxtr
				}
			}
		}
	}
	q ""
}

/// CreatDate:2016-11-2
/// Creator：陈莹
/// Description:保存数据（excel、txt、gof）
/// w ##class(web.DHCBL.BDP.BDPDataImport).SaveImportData("BDPData")
/// ^TMPIMPORTDATA
ClassMethod AfterSaveImportData(type) As %String
{
	N (type,%session)
	s mySysID =$s($d(%session):%session.%Id(),1:$j)
	;清除错误信息
	s returnstr=""
	s sheetnum=0
	s sheetnum=$o(^TMPIMPORTDATA(mySysID,type,sheetnum))
	if sheetnum="" q "没有数据!"
	//s tablenamedesc=$g(^TMPIMPORTDATA(mySysID,type,sheetnum,0,"TableNameDesc"))
	//s IMCID=$O(^User.BDPIMConfigI("UniqueTableDesc"," "_$ZCVT(tablenamedesc,"U"),0))
	s tablenamedesc=$g(^TMPIMPORTDATA(mySysID,type,sheetnum,0,"TableNameDesc"))
	s tablename=$o(^TMPIMPORTDATA(mySysID,type,sheetnum,0))
	s IMCID=$O(^User.BDPIMConfigI("UniqueTableName"," "_$ZCVT(tablename,"U"),0))
	s tableflag=$p($g(^TMPIMPORTDATA(mySysID,type,sheetnum)),"&%",1)
	s importtype=$p($g(^TMPIMPORTDATA(mySysID,type,sheetnum)),"&%",2)
	
	//s tableListName=  ##class(web.DHCBL.BDP.BDPEIMenu).GetTableNameByCode(tablename) 
	s ^TMPHASIMPORT("BDPData",tablename)=""
	s Totalrowerror=""
	if (tableflag="Y")
	{		
		if tablename="CT_Loc" 	
		{
			///科室 关联科室单独处理  2017-2-10
			if $d(^TMP("BDPExt","LINKCTLOCDR"))>0
			{
				s LocIMFCchildsub=$o(^User.BDPIMFieldConfigI("FieldNameUniqueI"," LINKCTLOCDR",IMCID,0))
				s Locpropdesc=$listget($g(^User.BDPIMConfigD(IMCID,"ChildField",LocIMFCchildsub)),2)
				
				s row1=0
				for 
				{
					s row1=$o(^TMP("BDPExt","LINKCTLOCDR",tablename,row1)) q:row1=""
					continue:$d(^TMPIMPORTDATA(mySysID,type,"error",tablename,row1))>0
					s datastr=$g(^TMPIMPORTDATA(mySysID,type,sheetnum,tablename,row1))
					s CTLOCDesc=$p($g(^TMP("BDPExt","LINKCTLOCDR",tablename,row1)),"&%",1)
					s LINKLOCDesc=$p($g(^TMP("BDPExt","LINKCTLOCDR",tablename,row1)),"&%",2)
					s LOCHospId=$p($g(^TMP("BDPExt","LINKCTLOCDR",tablename,row1)),"&%",3)
					S CTLOCRowId=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByDesc("CT_Loc",CTLOCDesc,LOCHospId)
					
					if CTLOCRowId'=""
					{
						s loclength=$l(LINKLOCDesc,"/")
						s loci=0,locerrorflag=0
						for 
						{
							s loci=loci+1 q:(loci>loclength)||(locerrorflag=1)
							s LinkLOCDesc=$p(LINKLOCDesc,"/",loci)
							if LinkLOCDesc'=""
							{
								s LinkLOC=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByDesc("CT_Loc",LinkLOCDesc,LOCHospId)
								if (LinkLOC="")
								{
									s ^TMPIMPORTDATA(mySysID,type,"error",tablename,row1)="A"_"&&关联科室添加：【"_LinkLOCDesc_"】对应的科室数据有误"_"&&"_datastr
									s locerrorflag=1
								}
								else
								{
									s newlinkobj=##class(web.Entity.CT.CTLocLinkLocation).%New()
									s newlinkobj.LINKParRef=CTLOCRowId
									s newlinkobj.LINKCTLOCDR=LinkLOC
									s Locsaveresult= ##class(web.DHCBL.CT.CTLocLinkLocation).SaveEntity(newlinkobj)
									i (Locsaveresult'["success:'true'")
									{
										s ^TMPIMPORTDATA(mySysID,type,"error",tablename,row1)="A"_"&&关联科室添加："_Locsaveresult_"&&"_datastr
										s locerrorflag=1
									}
								}
							}
						}
					}
				}
			}
			k ^TMP("BDPExt","LINKCTLOCDR")
		}
		//床位导入后重新生成坐标  2021-01-26注释掉 床位图显示按照序号来排列 不按照坐标
		//if tablename="PAC_Bed" s GeneratePosition=##class(web.BDPExt.BedBLL).SavePosition()
		
		
		///新装科室数据时，需要重置demo的科室为第一个科室  2017-04-07
		if (tablename="PHC_Duration")
		{
			///20170803 医生住院的默认疗程
			if (importtype="N")
			{
				s ^DHCDocConfig("FrequencedItemDur")=$o(^PHCDU(0,"Desc1","1天",0))
				s ^DHCDocConfig("IpDefaultDuration")=$o(^PHCDU(0,"Desc1","1天",0))
			}
			else
			{
				if $g(^DHCDocConfig("FrequencedItemDur"))="" s ^DHCDocConfig("FrequencedItemDur")=$o(^PHCDU(0,"Desc1","1天",0))
				if $g(^DHCDocConfig("IpDefaultDuration"))="" s ^DHCDocConfig("IpDefaultDuration")=$o(^PHCDU(0,"Desc1","1天",0))
			}
		
		}
		if (importtype="N")
		{ 
			
			if (tablename="CT_Loc")
			{
				
				s SSUSRRowId=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4("demo"),0))
				s firstLocID=$o(^CTLOC(0))
				if (SSUSRRowId'="")&&(firstLocID'="")
				{
					s objssuser=##class(User.SSUser).%OpenId(SSUSRRowId)
					d objssuser.SSUSRDefaultDeptDRSetObjectId(firstLocID)
					s sc=objssuser.%Save()
				}
			}
		
		}
		if ((tablename["ARC_ItmMast")||(tablename["INC_Itm")||(tablename["PHC_DrgMast")||(tablename["DHC_TarItem"))  //收费项
		{
			///收费项目和收费项目价格如果保存后，再回滚会导致存在^DHCTARI(5679,"P",0)=1的数据，属于垃圾数据，要清理
			s RowId=0
			for
			{
				s RowId=$o(^DHCTARI(RowId)) q:((RowId="")||(RowId'>0))
				IF ($D(^DHCTARI(RowId))=10) k ^DHCTARI(RowId)
			}
		}
		if ((tablename["ARC_ItmMast")||(tablename["INC_Itm")||(tablename["PHC_DrgMast")||(tablename["ARCItmMast"))  //医嘱项
		{
			s RowId=0
			for
			{
				s RowId=$o(^ARCIM(RowId)) q:((RowId="")||(RowId'>0))
				if ($D(^ARCIM(RowId,1,1))=0)&&($D(^ARCIM(RowId,1))>0) k ^ARCIM(RowId)	
			}
			
		}
		if ((tablename["INC_Itm")||(tablename["PHC_DrgMast"))  //库存项
		{
			s RowId=0
			for
			{
				s RowId=$o(^INCI(RowId)) q:((RowId="")||(RowId'>0))
				if ($D(^INCI(RowId,1))=0)&&($D(^INCI(RowId))>0) k ^INCI(RowId)	
			}
		}
		if (tablename["PHC_DrgMast")  //药学项
		{
			s RowId=0
			for
			{
				s RowId=$o(^PHCD(RowId)) q:((RowId="")||(RowId'>0))
				if ($D(^PHCD(RowId,1))=0)&&($D(^PHCD(RowId,"DF"))>0) k ^PHCD(RowId,"DF",0)
			}
		}
		
	}
	
	s row=0
	s SuccessCount=0,ErrorCount=0,TotalCount=0
	for
	{
		s row=$o(^TMPIMPORTDATA(mySysID,type,"error",tablename,row)) q:row=""
		s ErrorCount=ErrorCount+1
	}
	if $d(^TMPIMPORTDATA(mySysID,type,sheetnum,tablename)) s TotalCount=$o(^TMPIMPORTDATA(mySysID,type,sheetnum,tablename,""),-1)-2
	s SuccessCount=TotalCount-ErrorCount
	//s str="导入数据一共"_TotalCount_"条，导入成功"_SuccessCount_"条，导入失败"_ErrorCount_"条。"
	s returnstr=TotalCount_"^"_SuccessCount_"^"_ErrorCount
	s returnstr=$tr(returnstr," ","")
	q returnstr
}

/// CreatDate:2016-11-2
/// Creator：陈莹
/// Description:保存数据（excel、txt、gof）
/// w ##class(web.DHCBL.BDP.BDPDataImport).SaveImportDatai("BDPData",row)
/// ^TMPIMPORTDATA
ClassMethod SaveImportDatai(type, row) As %String
{
	N (type, row,%session)
	s mySysID =$s($d(%session):%session.%Id(),1:$j)
	;清除错误信息
	s returnstr=""
	s sheetnum=0
	s sheetnum=$o(^TMPIMPORTDATA(mySysID,type,sheetnum))
	q:sheetnum="" 0
	//s tablenamedesc=$g(^TMPIMPORTDATA(mySysID,type,sheetnum,0,"TableNameDesc"))
	//s IMCID=$O(^User.BDPIMConfigI("UniqueTableDesc"," "_$ZCVT(tablenamedesc,"U"),0))
	s tablenamedesc=$g(^TMPIMPORTDATA(mySysID,type,sheetnum,0,"TableNameDesc"))
	s tablename=$o(^TMPIMPORTDATA(mySysID,type,sheetnum,0))
	s IMCID=$O(^User.BDPIMConfigI("UniqueTableName"," "_$ZCVT(tablename,"U"),0))
	
	s tableListName=  ##class(web.DHCBL.BDP.BDPEIMenu).GetTableNameByCode(tablename) 
	s tableflag=$p($g(^TMPIMPORTDATA(mySysID,type,sheetnum)),"&%",1)
	s importtype=$p($g(^TMPIMPORTDATA(mySysID,type,sheetnum)),"&%",2)
	
	s Totalrowerror=""
	if (tableflag="Y")
	{	
		
		s Rowid=$LISTGET($G(^User.BDPIMConfigD(IMCID)),4)
		s ctclassname=$LISTGET($G(^User.BDPIMConfigD(IMCID)),5)
		s savemethod=$LISTGET($G(^User.BDPIMConfigD(IMCID)),6)
		s entityclassname=$LISTGET($G(^User.BDPIMConfigD(IMCID)),7)
		s neweobjstr="s Importeobj=##class("_entityclassname_").%New()"
		s Propcount=$l($g(^TMPIMPORTDATA(mySysID,type,sheetnum,tablename)),"&%")
		s saveeobjstr="s saveresult=##class("_ctclassname_")."_savemethod_"(Importeobj)"
		
		s codeIndex=$LISTGET($G(^User.BDPIMConfigD(IMCID)),8)
		s codeIndexstr="s oid="""""
		if codeIndex'="" s codeIndexstr="s oid="_codeIndex
		//s eobjRowidstr="s Importeobj."_Rowid_"="""""
		//if codeIndex'="" s eobjRowidstr="s Importeobj."_Rowid_"="_codeIndex_""

		///if $d(^TMPIMPORTDATA(mySysID,type,"error",tablename,row))>0 q "" //预校验不通过的不去导入。
		s dataflag=$g(^TMPIMPORTDATA(mySysID,type,sheetnum,tablename,row,"dataflag"))
		i (dataflag="Y")
		{
			s datastr=$g(^TMPIMPORTDATA(mySysID,type,sheetnum,tablename,row))  ///&%
			s AllErrorStr=""
			s errorflag=0
			s i=0
			for
			{
				s i=i+1 q:(i>Propcount)
				
				s value=$p(datastr,"&%",i)
				s value=..trim(value)  ///只过滤末尾的空格
				s prp=$p($g(^TMPIMPORTDATA(mySysID,type,sheetnum,tablename)),"&%",i)
				continue:prp=""
				s prpdesc=$p($g(^TMPIMPORTDATA(mySysID,type,sheetnum,tablename_"FieldDesc")),"&%",i) ///字段描述  //2
				if prpdesc="" s prpdesc=prp
				s IMFCchildsub=$o(^User.BDPIMFieldConfigI("FieldNameUniqueI"," "_$ZCVT(prp,"u"),IMCID,0))
				
				///取字段在导入配置表中的类型
				S proptype=$listget($g(^User.BDPIMConfigD(IMCID,"ChildField",IMFCchildsub)),4)
				
				
				if IMFCchildsub=""
				{
					//通过字段名 CTCITCode&%CTCITDesc&%CTCITProvinceDR&%CTCITDateFrom&%CTCITDateTo  校验字段
					s ^TMP("BDPDataImport","NonConfig",prp)=prpdesc
					s AllErrorStr=AllErrorStr_"【"_prpdesc_"】"_"在导入配置表里没有维护，"  ///必填项为空值	
				}
				else
				{
					s propstr="s "_prp_"="_""""_value_""""
					x propstr
					//用户医护人员表格 医院因为是拼接的，LinkHospId取第一个医院
					if ((tablename="SS_User")&&(prp="SSUSRHospitalDR"))
					{
						s LinkHospId=$p(value,"/",1)
						if LinkHospId'="" s LinkHospId=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByDesc("CT_Hospital",LinkHospId,"")
					}
					///取字段在导入配置表中的类型
					S proptype=$listget($g(^User.BDPIMConfigD(IMCID,"ChildField",IMFCchildsub)),4)
				
					////2016-11-22判断是否导入
					s IMFCImport=$listget($g(^User.BDPIMConfigD(IMCID,"ChildField",IMFCchildsub)),10)
					if (IMFCImport="N")   ///N为不导入，Y和空值为导入
					{
						s ^TMP("BDPDataImport","NoImport",prp)=IMCID_"||"_IMFCchildsub
						s propstr="s "_prp_"="_""""_value_""""
						x propstr	
					}
					else
					{
						////2016-11-22判断是否是必填项
						s IMFCRequired=$listget($g(^User.BDPIMConfigD(IMCID,"ChildField",IMFCchildsub)),9)
						if (IMFCRequired="Y")&&(value="") ///以空值暂时默认为不是必填项
						{
							s propstr="s "_prp_"="_""""_value_""""
							x propstr
							///必填项为空值， 返回报错
							s AllErrorStr=AllErrorStr_"【"_prpdesc_"】为必填项，"
						}
				
						if (proptype="DR")
						{
							if (value'="")
							{
								s IMFCConTable=$listget($g(^User.BDPIMConfigD(IMCID,"ChildField",IMFCchildsub)),6)
								//if IMFCConTable'=""
								//{
									
									s IMFCConTable=$listget($g(^User.BDPIMConfigD(IMCID,"ChildField",IMFCchildsub)),6)
									s drtoidstr=$listget($g(^User.BDPIMConfigD(IMCID,"ChildField",IMFCchildsub)),5)
									
									//s Propdrstr="if "_prp_"'="""" s "_prp_"="_drtoidstr
									//X Propdrstr	
									//2019-07-05
									if drtoidstr'=""
									{
										 s Propdrstr="if "_prp_"'="""" s "_prp_"="_drtoidstr
									}
									else
									{
										s drtoidstr="##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByDesc(IMFCConTable,prpvalue,$g(LinkHospId))"
										/*
										if ((IMFCConTable="PH_Manufacturer")||(IMFCConTable="APC_Vendor")||(IMFCConTable="DHC_Carrier")||(IMFCConTable="DHC_STOrigin")||(IMFCConTable="INC_StkCat"))
										{
											if (tablename="PHC_DrgMastNew")
											{
												s drtoidstr="##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByDesc(IMFCConTable,prpvalue_""^G"",$g(LinkHospId))"
											}
											if (tablename="INC_Itm")
											{
												s drtoidstr="##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByDesc(IMFCConTable,prpvalue_""^M"",$g(LinkHospId))"
											}
										}
										*/
										
										x "s prpvalue="_""""_value_""""
										s Propdrstr="if "_prp_"'="""" s "_prp_"="_drtoidstr
									}
									x Propdrstr
									
									//科室，分诊区，收费项目调价，用户其他登录科室，医嘱套
									if ((tablename="CT_Loc")&&(prp="CTLOCHospitalDR"))||((tablename="DHC_TarItemPrice")&&(prp="TPHospitalDR"))||((tablename="SS_UserOtherLogonLoc")&&(prp="OTHLLHospitalDR"))||((tablename="DHCExaBorough")&&(prp="ExabHospitalDr"))||((tablename="ARC_OrdSets")&&(prp="FavUseHospDr"))
									{
										x "s LinkHospId=$g("_prp_")"
									}
						
									s drerrorflag=0
									s DRValidateflagstr="if "_prp_"="""" s drerrorflag=1"
									x DRValidateflagstr
									
									if prp="LinkHospId"
									{
										if (LinkHospId<0) s AllErrorStr=AllErrorStr_LinkHospId_"，"
										
									}
									if drerrorflag=1
									{
										s AllErrorStr=AllErrorStr_"【"_prpdesc_"】 "_value_"在 "_IMFCConTable_" 表中没找到这条数据，"
										
									}
									
									
								//}
								
							}
						}
						elseif (proptype["Date")
						{
							if value'=""
							{
								//如果日期不包含-或者/
								if (value'["-")&&(value'["/")
								{
									s AllErrorStr=AllErrorStr_"【"_prpdesc_"】格式校验失败，"
								}
								else
								{
										
									s valueLogical= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(value)
									if '(valueLogical>0)
									{
										s AllErrorStr=AllErrorStr_"【"_prpdesc_"】格式有误，"
										
									}
								}
							}
						}
						elseif (proptype["Time")
						{
							if value'=""
							{
								//如果日期不包含-或者/
								if (value'[":")
								{
									s AllErrorStr=AllErrorStr_"【"_prpdesc_"】格式校验失败，"
								}
								else
								{
										
									s valueLogical= ##class(web.DHCBL.BDP.FunLib).TimeHtmlToLogical(value,1)
									if '(valueLogical>0)
									{
										s AllErrorStr=AllErrorStr_"【"_prpdesc_"】格式有误，"
										
									}
								}
							}
						}	
						elseif (proptype["Float")
						{
							if value'=""
							{
								s validateFlag=##class(web.DHCBL.BDP.FunLib).IsNonnegativeNumber(value)   ///0或正数
								if validateFlag=-1 s AllErrorStr=AllErrorStr_"【"_prpdesc_"】 "_value_" 不是有效数字，"
							}
							
						}		
						elseif (proptype["Integer")
						{
							if value'=""
							{
								s validateFlag=##class(web.DHCBL.BDP.FunLib).IsPositiveInteger(value)
								if validateFlag=-1 s AllErrorStr=AllErrorStr_"【"_prpdesc_"】 "_value_" 不是正整数，"
								
							}
							
						}
						elseif (proptype["Y/N")
						{
							if value'=""
							{
								s value=$tr(value," ","")    ///半角的空格
								s value=$tr(value,"　","")    ///全角的空格
								s value=$zcvt(value,"U")   ///2017-04-10 
								if value="是" s value="Y"
								if value="否" s value="N"
								if (value'="Y")&&(value'="N")
								{
									s AllErrorStr=AllErrorStr_"【"_prpdesc_"】 "_value_" 不是Y/N，"
								}
								else
								{
									s propstr="s "_prp_"="_""""_value_""""
									x propstr
								}
							}
							else{
								///激活字段为空时默认为Y
								if ((prpdesc["激活")||(prpdesc["有效"))&&(($zcvt(prp,"u")["ACTIVE")||($zcvt(prp,"u")["VALID"))
								{
									s propstr="s "_prp_"=""Y"""
									x propstr
								}
							}
							
						}
					}
				}
				
			}
			
			s oid=""
			x codeIndexstr
			
			
			x neweobjstr
			for i=1:1:Propcount  //pCOUNT
			{
				s prp=$p($g(^TMPIMPORTDATA(mySysID,type,sheetnum,tablename)),"&%",i)
				continue:prp=""
				continue:$d(^TMP("BDPDataImport","NoImport",prp))>0  //不导入的数据过滤掉
				continue:$d(^TMP("BDPDataImport","NonConfig",prp))>0
				s propstr="s Importeobj."_prp_"="_prp
				try
				{
					x propstr
				}
				catch(e)
				{
					s ^TMPIMPORTDATA(mySysID,type,"error",tablename,row)="UV"_"&&"_$ze_"请核对数据"_"&&"_datastr
					continue
				}						
			}
			
			if (tablename="DHC_PHCCat")   //药理学分类
			{
				s TMPDHCLevel=1
				if (Importeobj.PHCCCat1'="") s TMPDHCLevel=1
				if (Importeobj.PHCCCat2'="") s TMPDHCLevel=2
				if (Importeobj.PHCCCat3'="") s TMPDHCLevel=3
				if (Importeobj.PHCCCat4'="") s TMPDHCLevel=4
				if (Importeobj.PHCCCat5'="") s TMPDHCLevel=5
				if (Importeobj.PHCCCat6'="") s TMPDHCLevel=6
				if (Importeobj.PHCCCat7'="") s TMPDHCLevel=7
				s ^TMPBDPPHCCAT(row)=Importeobj.PHCCCode_"^"_TMPDHCLevel
				///寻找上级分类的代码
				if (TMPDHCLevel>1)
				{
					if row>1
					{
						if $d(^TMPBDPPHCCAT(row-1))>0
						{
							s tempLevel=$p($g(^TMPBDPPHCCAT(row-1)),"^",2)
							if (TMPDHCLevel-tempLevel)>1
							{
								 s AllErrorStr=AllErrorStr_"药理学分类数据层级关系有误，"
							}
						}
						
					}
					s lastrow=row
					for
					{
						s lastrow=$o(^TMPBDPPHCCAT(lastrow),-1) q:lastrow=""
						if ($p($g(^TMPBDPPHCCAT(lastrow)),"^",2)=(TMPDHCLevel-1))
						{
							s Importeobj.PHCCParCatDrCode=$p($g(^TMPBDPPHCCAT(lastrow)),"^",1)
							q
						}
						
					}
					
				}
			}
			if (oid'="")
			{
				
				///调用保存,修改
				//x eobjRowidstr    ///s Importeobj.RowId=...
				if (importtype="U") //code相同的 修改
				{
					s CheckResult=##class(web.DHCBL.BDP.BDPDataImport).ValidateCheck(tablename,Importeobj,1)
					if (AllErrorStr'="")||(CheckResult'="")
					{
						s ^TMPIMPORTDATA(mySysID,type,"error",tablename,row)="UV"_"&&"_AllErrorStr_CheckResult_"请核对数据"_"&&"_datastr
						s vflag=1
					}
					else
					{
						try
						{
							x saveeobjstr
							i (saveresult'["success:'true'")
							{
								s ^TMPIMPORTDATA(mySysID,type,"error",tablename,row)="U"_"&&修改："_saveresult_"&&"_datastr
								s vflag=1
							} 
						}
						catch myvar{
							s ^TMPIMPORTDATA(mySysID,type,"error",tablename,row)="U"_"&&修改："_$ze_"&&"_datastr  //"保存失败，程序出现未知错误，请核对数据。"
							s vflag=1
						}	
					}

				}
				elseif (importtype="J") //code相同的 跳过  追加
				{ 
					s ^TMPIMPORTDATA(mySysID,type,"error",tablename,row)="J"_"&&"_"只追加模式下，代码数据已存在，跳过导入"_"&&"_datastr
					s vflag=1
				}
				elseif (importtype="N") //code相同的 跳过  新装
				{
					s ^TMPIMPORTDATA(mySysID,type,"error",tablename,row)="N"_"&&"_"代码数据已存在，跳过导入"_"&&"_datastr
					s vflag=1
				}
			}
			else
			{
				///调用保存,新增
				s CheckResult=##class(web.DHCBL.BDP.BDPDataImport).ValidateCheck(tablename,Importeobj,1)
				if (AllErrorStr'="")||(CheckResult'="")
				{
					s ^TMPIMPORTDATA(mySysID,type,"error",tablename,row)="UV"_"&&"_AllErrorStr_CheckResult_"请核对数据"_"&&"_datastr
					s vflag=1
				}
				else
				{
					try
					{
						x saveeobjstr
					
						i (saveresult'["success:'true'")
						{
							s ^TMPIMPORTDATA(mySysID,type,"error",tablename,row)="A"_"&&添加："_saveresult_"&&"_datastr
							s vflag=1
						}
					}
					catch myvar{
						s ^TMPIMPORTDATA(mySysID,type,"error",tablename,row)="A"_"&&添加："_$ze_"&&"_datastr
						s vflag=1
					}
					
				}
			}
			
			///科室 关联科室单独处理  2017-2-10
			if (tablename="CT_Loc")
			{
				s flag=0
				s flagxstr="if LINKCTLOCDR'="""" s flag=1"
				x flagxstr
				s TMPLINKLOCxstr="if flag=1 s ^TMP(""BDPExt"",""LINKCTLOCDR"","""_tablename_""","""_row_""")="_""""_CTLOCDesc_"&%"_LINKCTLOCDR_"&%"_LinkHospId_""""
				x TMPLINKLOCxstr
			}	
						
		}
	}
	q "0"
}

/// Creator：陈莹
/// CreatDate: 2016-2-18
/// Description：判断是否有人在操作导入导出
/// Input：导入导出类型 （type）
/// Return："1"(有人正在导出/导入，不可导出),""(可以导出/导入)
/// w ##class(web.DHCBL.BDP.BDPDataImport).GetGofFlag("BDPData")
ClassMethod GetGofFlag(type) As %String
{
	s flag=$g(^TMPGOFNOF(type))  
	q flag
}

/// Creator：chenying
/// CreatDate: 2015-6-18
/// Description：从D:\文件夹下 导入知识库数据TMPBIKB.gof
/// Table：
/// Input：D:\TMPBIKB.gof
/// Others:w ##class(web.DHCBL.BDP.BDPDataImport).ImportGof("E:\TMPGOFDATA.gof","BIData")
/// Others:w ##class(web.DHCBL.BDP.BDPDataImport).ImportGof("C:\Users\AMANDA\Desktop\TMPCouGOFDATA.gof","BDPData")
ClassMethod ImportGof(path, type) As %String
{
	s mySysID =$s($d(%session):%session.%Id(),1:$j)
	if path[" " s path=$tr(path," ","")
	if path'[".gof"   q "请选择正确的gof文件"
	if (path["\") 
	{
		s filename=$p(path,"\",$l(path,"\"))
	}
		
	if (path["/")
	{
		s filename=$p(path,"/",$l(path,"/"))
	}
	s length=$l(filename)
 	s packagename=$e(path,1,$l(path)-length)

 	s ^TMPGOFNOF(type)=1
 	
 	k ^TMPGOFDATA
 	k ^TMPIMPORTDATA
	d $SYSTEM.OBJ.ImportDir(packagename, filename)
	
	
	///重新生成对应SysID的临时global
	s ^TMPIMPORTDATA(mySysID,type)=$g(^TMPGOFDATA(type))
	s inum=0
	for 
	{
		s inum=$o(^TMPGOFDATA(type,inum)) q:inum=""
		s ^TMPIMPORTDATA(mySysID,type,inum,0,"TableNameDesc")=$g(^TMPGOFDATA(type,inum,0,"TableNameDesc"))
		s ^TMPIMPORTDATA(mySysID,type,inum)=$g(^TMPGOFDATA(type,inum))
		s tablen=$o(^TMPGOFDATA(type,inum,0))
		
		s ^TMPIMPORTDATA(mySysID,type,inum,tablen)=$g(^TMPGOFDATA(type,inum,tablen))
		s ^TMPIMPORTDATA(mySysID,type,inum,tablen_"FieldDesc")=$g(^TMPGOFDATA(type,inum,tablen_"FieldDesc"))
		s rownum=0
		for 
		{
			s rownum=$o(^TMPGOFDATA(type,inum,tablen,rownum)) q:rownum=""
			
			s ^TMPIMPORTDATA(mySysID,type,inum,tablen,rownum)=$g(^TMPGOFDATA(type,inum,tablen,rownum))
			s ^TMPIMPORTDATA(mySysID,type,inum,tablen,rownum,"dataflag")="Y"
			
		}
	}
	
	///修改lock标志
	s ^TMPGOFNOF(type)=""
	Q "1"
}

/// w ##class(web.DHCBL.BDP.BDPDataImport).GetTableGridCm("BDPData",1,"IHBI.KBaseDefine")
/// 取导入的global中包含的导入字段
ClassMethod GetTableGridCm(type, igofnum, tablename) As %String
{
	s mySysID = $s($d(%session):%session.%Id(),1:$j)
	s fieldname=$g(^TMPIMPORTDATA(mySysID,type,igofnum,tablename))
	s fieldnamedesc=$g(^TMPIMPORTDATA(mySysID,type,igofnum,tablename_"FieldDesc"))
	s length=$l(fieldname,"&%")
	s fieldinfo=""
	for fi=1:1:length
	{
		s fieldn=$p(fieldname,"&%",fi)
		s fieldndesc=$p(fieldnamedesc,"&%",fi)
		if fieldinfo="" s fieldinfo=fieldn_"&%"_fieldndesc
		else  s fieldinfo=fieldinfo_"#%"_fieldn_"&%"_fieldndesc
		
	}
	q fieldinfo
}

/// w ##class(web.DHCBL.BDP.BDPDataImport).GetTableGofCount(type,igofnum,tablename)
ClassMethod GetTableGofCount(type, igofnum, tablename) As %String
{
	s mySysID = $s($d(%session):%session.%Id(),1:$j)
	s count=$o(^TMPIMPORTDATA(mySysID,type,igofnum,tablename,""),-1)
	q count
}

/// w ##class(web.DHCBL.BDP.BDPDataImport).GetTableGofCount(type,igofnum,tablename,i)
/// OralDrug&%口服药品&%PHC_Instruc
ClassMethod GetTableGofiinfo(type, igofnum, tablename, i) As %String
{
	s mySysID = $s($d(%session):%session.%Id(),1:$j)
	s:type="" type="BDPData"
	s gofiinfo=$g(^TMPIMPORTDATA(mySysID,type,igofnum,tablename,i))
	q gofiinfo
}

/// Creator：chenying
/// CreatDate: 2016-10-27
/// Description：导出错误数据信息（将错误信息显示在导入结果里时调用）
/// Input：tablename(导入菜单的代码)
/// return:返回信息为 ： 行号&%保存结果&%数据信息
/// w ##class(web.DHCBL.BDP.BDPDataImport).GetExErrorDataCount("BDPData","CT_Spec")
ClassMethod GetExErrorDataCount(type, tablename) As %String
{
	s mySysID =$s($d(%session):%session.%Id(),1:$j)
	s count=0
	K ^TMPIMPORTERROR
	s num=0
	for
	{
		s num=$o(^TMPIMPORTDATA(mySysID,type,"error",tablename,num)) q:num=""
		s count=count+1
		s ^TMPIMPORTERROR(tablename,count)=num_"&&"_$g(^TMPIMPORTDATA(mySysID,type,"error",tablename,num))
	}
	q count
}

/// Creator：chenying
/// CreatDate: 2016-3-29
/// Description：导出错误数据信息（将错误信息显示在导入结果里时调用）
/// Input：tablename(导入菜单的代码)
/// return:返回信息为 ： 行号&%保存结果&%数据信息
/// w ##class(web.DHCBL.BDP.BDPDataImport).GetErrorFieldValue("CT_Spec",1)
ClassMethod GetErrorFieldValue(tablename, counti) As %String
{
	q:tablename="" ""
	q:counti="" ""
	s str=$g(^TMPIMPORTERROR(tablename,counti))   //row_"&&"_"a"_"&&"_saveresult_"&&"_datastr
	s row=$p(str,"&&",1)
	s DataDetailStr=row_"&%"_$tr($p(str,"&&",3),"'","”")_"&%"_$p(str,"&&",4)
	q DataDetailStr
}

/// Creator：chenying
/// CreatDate: 2016-3-29
/// Description：导出错误数据信息（将错误信息导出到excel时调用）
/// Input：tablename(导入菜单的代码)
/// return:返回信息为 ： 数据信息&%行号&%保存结果
/// w ##class(web.DHCBL.BDP.BDPDataImport).GetExcelErrorFieldValue("CT_Spec",1)
ClassMethod GetExcelErrorFieldValue(tablename, counti) As %String
{
	q:tablename="" ""
	q:counti="" ""
	s str=$g(^TMPIMPORTERROR(tablename,counti))   //row_"&&"_"a"_"&&"_saveresult_"&&"_datastr
	s row=$p(str,"&&",1)
	s DataDetailStr=$p(str,"&&",4)_"&%"_row_"&%"_$tr($p(str,"&&",3),"'","”")
	q DataDetailStr
}

/// Creator：chenying
/// CreatDate: 2017-08-30
/// Description：导出所有数据行及其错误数据信息，么有错误信息的（将错误信息导出到excel时调用）
/// Input：tablename(导入菜单的代码)
/// return:返回信息为 ： 数据信息&%行号&%保存结果
/// w ##class(web.DHCBL.BDP.BDPDataImport).GetExcelErrorFieldValue("CT_Spec",1)
ClassMethod GetExcelAllErrorFieldValue(tablename, counti) As %String
{
	q:tablename="" ""
	q:counti="" ""
	s mySysID =$s($d(%session):%session.%Id(),1:$j)
	s type="BDPData"
	s sheetnum=$o(^TMPIMPORTDATA(mySysID,type,0))
	if sheetnum="" q ""
	s tablename=$o(^TMPIMPORTDATA(mySysID,type,sheetnum,0))
	s datastr=$g(^TMPIMPORTDATA(mySysID,type,sheetnum,tablename,counti))
	if $d(^TMPIMPORTDATA(mySysID,type,"error",tablename,counti))>0
	{
		s str=$g(^TMPIMPORTDATA(mySysID,type,"error",tablename,counti))
		s DataDetailStr=datastr_"&%"_counti_"&%"_$tr($p(str,"&&",2),"'","”")
	}
	else
	{
		s DataDetailStr=datastr
	}
	
	q DataDetailStr
}

/// Creator：chenying
/// CreatDate: 2017-08-30
/// Description：获取所有数据条数
/// Input：tablename(导入菜单的代码)
/// return:总条数
/// w ##class(web.DHCBL.BDP.BDPDataImport).GetAllExErrorDataCount("BDPData","CT_Spec")
ClassMethod GetAllExErrorDataCount(type, tablename) As %String
{
	s mySysID =$s($d(%session):%session.%Id(),1:$j)
	s count=0
	s sheetnum=$o(^TMPIMPORTDATA(mySysID,"BDPData",0))
	s count=$o(^TMPIMPORTDATA(mySysID,type,sheetnum,tablename,""),-1)
	q count
}

/// Creator：chenying
/// CreatDate: 2017-09-04
/// Description：导出excel 通过表名获取字段代码、字段描述、字段是否必填项 的字符串
/// Table：User.BDPIMConfig
/// Input：tablename(导入菜单的代码)
/// Other: w ##class(web.DHCBL.BDP.BDPDataImport).GetFieldInfo("DHC_TarItem")
ClassMethod GetFieldInfo(tablename) As %String
{
	q:tablename="" ""
	S mySysID =$s($d(%session):%session.%Id(),1:$j)
	s fresult=""
	///取实际导入表格里的列表头
	s tablenameU=$ZCONVERT(tablename,"U") //转换成大写
	s IMCID=$o(^User.BDPIMConfigI("UniqueTableName"," "_tablenameU,0))
	q:IMCID="" ""
	s sheetnum=$o(^TMPIMPORTDATA(mySysID,"BDPData",0))
	q:sheetnum="" ""
	s DescStr=$g(^TMPIMPORTDATA(mySysID,"BDPData",sheetnum,tablename_"FieldDesc"))
	s CodeStr=$g(^TMPIMPORTDATA(mySysID,"BDPData",sheetnum,tablename))
	
	s Length=$l(DescStr,"&%")
	for i=1:1:Length
	{
		s Desc=$p(DescStr,"&%",i)
		s Code=$p(CodeStr,"&%",i)
		S IMFCchildsub=$O(^User.BDPIMFieldConfigI("FieldNameUniqueI"," "_$zcvt(Code,"u"),IMCID,0))
		//S IMFCchildsub=$O(^User.BDPIMFieldConfigI("DescNameIndex",Desc,Code,IMCID,0))
		s RFlag=0,IMFCRequired=""
		if IMFCchildsub'="" s IMFCRequired=$listget($g(^User.BDPIMConfigD(IMCID,"ChildField",IMFCchildsub)),9)
		if (IMFCRequired="Y") s RFlag=1
		if (fresult'="")
		{
			s fresult=fresult_"&%"_Desc_"*&"_Code_"*&"_RFlag
		}
		else
		{
			s fresult=Desc_"*&"_Code_"*&"_RFlag
		}
		
	}
	q fresult
}

/// Creator：chenying
/// CreatDate: 2016-3-29
/// Description：导出excel 通过表名获取字段描述字符串
/// Table：User.BDPIMConfig
/// Input：tablename(导入菜单的代码)
/// Other: w ##class(web.DHCBL.BDP.BDPDataImport).GetFieldDesc("CT_Province")
ClassMethod GetFieldDesc(tablename) As %String
{
	q:tablename="" ""
	///取实际导入表格里的列表头
	s mySysID = $s($d(%session):%session.%Id(),1:$j)
	s sheetnum=$o(^TMPIMPORTDATA(mySysID,"BDPData",0))
	q:sheetnum="" ""
	s fresult=$g(^TMPIMPORTDATA(mySysID,"BDPData",sheetnum,tablename_"FieldDesc"))
	q fresult
}

/// ^TMPIMPORTERROR  ^TMPIMPORTDATA   ^TMPGOFNOF ^TMPGOFDATA
/// Function:   获取日志数据供查询数据导入的日志
/// CreateDate: 2016-11-1
/// Creator:    chenying
/// Input：     table(导入菜单的代码) start（日志从第几条开始显示） limit（每页显示条数）
/// Debug:      w ##class(web.DHCBL.BDP.BDPDataImport).GetDataLogOfImport("CT_City",0,10)
ClassMethod GetDataLogOfImport(table As %String, start As %String, limit As %String) As %String
{
	
	if (table="")	q strResult= "{""success"":""true"",""data"":[],"_"""total"":"""_"0"_""""_"}"
	s mySysID =$s($d(%session):%session.%Id(),1:$j)
	S lastLogId=$g(^TMP("BDPDataImport","ImportTime",mySysID,table,"BDPDataChangeLogID"))
	s BDPEIMenuRowId=$o(^User.BDPEIMenuI("UniqueCodeIndex"," "_$zcvt(table,"u"),0))
	s ClassNames=$LISTGET($G(^User.BDPEIMenuD(BDPEIMenuRowId)),8)
	s length=$l(ClassNames,",")
	K ^TMP("BDPDataImport","LOGIMPORT")
	K ^TMP("BDPDataImport","TMPLOG")
	for i=1:1:length
	{
		s classname=$p(ClassNames,",",i)
		continue:classname=""
		s ^TMP("BDPDataImport","LOGIMPORT",classname)=""
	}
	
	s ID="", strResult=""
	s:start="" start=0
	s:limit="" limit=10

	///获取导入的时间标记
	s datefrom=$p($g(^TMP("BDPDataImport","ImportTime",mySysID,table)),",",1)
	s timefrom=$p($g(^TMP("BDPDataImport","ImportTime",mySysID,table)),",",2)
	
	IF (datefrom'="")&&(timefrom'="")
	{
		///2017-2-11修改，日志正序排列
		for
		{
			s ID=$o(^User.BDPDataChangeLogD(ID),-1) q:(ID="")
			q:(lastLogId'="")&(ID<=lastLogId)
			s TableName=$LISTGET($G(^User.BDPDataChangeLogD(ID)),2)   //CT_City
			s ClassName=$LISTGET($G(^User.BDPDataChangeLogD(ID)),3)   //User.CTCity
			if (ClassName["^") s ClassName= $p(ClassName,"(",1)
			s UpdateDate=$LISTGET($G(^User.BDPDataChangeLogD(ID)),7)
			s UpdateTime=$LISTGET($G(^User.BDPDataChangeLogD(ID)),8)
			continue:('((UpdateDate>=datefrom)&&(UpdateTime>=timefrom)))
			if ($d(^TMP("BDPDataImport","LOGIMPORT",ClassName))=1)
			{
				 s ^TMP("BDPDataImport","TMPLOG",ID)=""
			}
			
		
		}
	}
	W "{""success"":""true"",""data"":["
	s count=0
	s Result=""
	for
	{
		s ID=$o(^TMP("BDPDataImport","TMPLOG",ID)) q:ID=""  
		s TableName=$LISTGET($G(^User.BDPDataChangeLogD(ID)),2)   //CT_City
		s ClassName=$LISTGET($G(^User.BDPDataChangeLogD(ID)),3)   //User.CTCity
		
		if (ClassName["^") s ClassName= $p(ClassName,"(",1)
		s UpdateDate=$LISTGET($G(^User.BDPDataChangeLogD(ID)),7)
		s UpdateTime=$LISTGET($G(^User.BDPDataChangeLogD(ID)),8)
		
		s count=count+1
		if (count<=start) continue
		if (count<=(start+limit))
		{
			s ClassName=$LISTGET($G(^User.BDPDataChangeLogD(ID)),3)
			s ClassNameDesc=$LISTGET($G(^User.BDPDataChangeLogD(ID)),11)   
			s:ClassNameDesc="社区维护" ClassNameDesc="社区"
			s:ClassNameDesc="街道维护" ClassNameDesc="街道"
			s:ClassNameDesc="地址维护" ClassNameDesc="地址"
			s:ClassName="User.BDPTableList" ClassName="User.TableList"  
			s:ClassName="User.BDPTableField" ClassName="User.TableField"
			
			s ClassNameDesc=$LISTGET($G(^User.BDPDataChangeLogD(ID)),11)   //新增类描述
			s ObjectReference=$LISTGET($G(^User.BDPDataChangeLogD(ID)),4)
			s ObjectDesc=$LISTGET($G(^User.BDPDataChangeLogD(ID)),12)   //新增对象描述
			s UpdateUserDR=$LISTGET($G(^User.BDPDataChangeLogD(ID)),5)
			s:UpdateUserDR'="" UpdateUserDR=$p($G(^SSU("SSUSR",UpdateUserDR)),"^",1) //获取用户名
			s UpdateUserName=$LISTGET($G(^User.BDPDataChangeLogD(ID)),6)

			s OperateType=$LISTGET($G(^User.BDPDataChangeLogD(ID)),9)
			s IpAddress=$LISTGET($G(^User.BDPDataChangeLogD(ID)),13)
			s NewValue=$LISTGET($G(^User.BDPDataChangeLogD(ID)),10)
			s OldValue=$LISTGET($G(^User.BDPDataChangeLogD(ID)),14)
			
			s ClassName=##class(web.DHCBL.BDP.FunLib).EvalJSON(ClassName)
			s TableName=##class(web.DHCBL.BDP.FunLib).EvalJSON(TableName)
			s NewValue=##class(web.DHCBL.BDP.FunLib).EvalJSON(NewValue)
			s OldValue=##class(web.DHCBL.BDP.FunLib).EvalJSON(OldValue)
			s ClassNameDesc=##class(web.DHCBL.BDP.FunLib).EvalJSON(ClassNameDesc)
			s ObjectReference=##class(web.DHCBL.BDP.FunLib).EvalJSON(ObjectReference)
			s ObjectDesc=##class(web.DHCBL.BDP.FunLib).EvalJSON(ObjectDesc)
			s UpdateUserDR=##class(web.DHCBL.BDP.FunLib).EvalJSON(UpdateUserDR)
			s UpdateUserName=##class(web.DHCBL.BDP.FunLib).EvalJSON(UpdateUserName)
			s UpdateDate=##class(web.DHCBL.BDP.FunLib).EvalJSON(UpdateDate)
			s UpdateTime=##class(web.DHCBL.BDP.FunLib).EvalJSON(UpdateTime)
			s:UpdateDate'="" UpdateDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(UpdateDate)
			s:UpdateTime'="" UpdateTime=##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(UpdateTime,1)
			if (count=(start+1))
			{ 
			
			}
			else
			{ 
				W ","
			}    
			W "{""ID"":"""_ID_""",""IpAddress"":"""_IpAddress_""",""TableName"":"""_TableName_""",""ClassName"":"""_ClassName_""",""ClassNameDesc"":"""_ClassNameDesc_""",""ObjectReference"":"""_ObjectReference_""",""ObjectDesc"":"""_ObjectDesc_""",""UpdateUserDR"":"""_UpdateUserDR_""",""UpdateUserName"":"""_UpdateUserName_""",""UpdateDate"":"""_UpdateDate_""",""UpdateTime"":"""_UpdateTime_""",""OperateType"":"""_OperateType_"""}" 
		}
	
	}
	W "],"_"""total"":"""_count_""""_"}"
	///s strResult= "{""success"":""true"",""data"":["_Result_"],"_"""total"":"""_count_""""_"}"
	q ""
}

/// Creator:陈莹
/// CreatDate:2017-04-01
/// Description:通过导入字段的代码获取导入字段的描述
/// Input:ID(导入配置父表的ID),FieldName(导入字段的代码)
/// Return:导入字段的描述
/// w ##class(web.DHCBL.BDP.BDPDataImport).GetFieldDescByName("1","HOSPDesc")
ClassMethod GetFieldDescByName(ID, FieldName) As %String
{
	n (ID,FieldName)
	q:(ID="")||(FieldName="") FieldName
	s FieldDesc=""
	S SUB=$O(^User.BDPIMFieldConfigI("FieldNameUniqueI"," "_$zcvt(FieldName,"U"),ID,0))
	q:SUB="" FieldName
	S FieldDesc=$LISTGET($G(^User.BDPIMConfigD(ID,"ChildField",SUB)),2)
	Q FieldDesc
}

/// Creator:陈莹
/// CreatDate:2016-10-1
/// Description:数据重复验证，和数据有效性校验
/// Input:tablecode(导入菜单的代码), Veobj（要导入的数据对象）, ImportType(0为新装导入，不校验重复性，1为追加和修正导入，校验代码重复性）
/// Return:空为有效，不为空时返回错误信息
/// Other:w ##class(web.DHCBL.BDP.BDPDataImport).ValidateCheck("ARC_BankCardType1","","1")
ClassMethod ValidateCheck(tablecode As %String, Veobj, ImportType As %String) As %String
{
	n (tablecode,Veobj,ImportType,%session)
	s flag=0,myVresult=""
	s ID=$O(^User.BDPIMConfigI("UniqueTableName"," "_$ZCVT(tablecode,"U"),0))
	q:ID="" ""
	s IMCParentDr=$LISTGET($G(^User.BDPIMConfigD(ID)),11)
	s tablename=$LISTGET($G(^User.BDPIMConfigD(ID)),2)
	///如果有扩展，判断被扩展的导入配置代码
	i IMCParentDr'="" s tablecode=$LISTGET($G(^User.BDPIMConfigD(IMCParentDr)),3) //菜单对应导入配置代码。
	
	s tablename= ##class(web.DHCBL.BDP.BDPEIMenu).GetTableNameByCode(tablecode)  //获取导入导出菜单代码对应的表结构登记的表名（代码） tableListName
	if tablename="" q "导入导出菜单里没有定义表结构登记指针，"
	if (tablecode="CT_Hospital")
	{
		s MLength=$$$comMemberArrayGet("User.CTHospital",$$$cCLASSproperty,"HOSPCode",$$$cPROPparameter,"MAXLEN")
		if $l(Veobj.HOSPCode)>MLength s myVresult="【"_..GetFieldDescByName(ID,"HOSPCode")_"】长度不能超过"_MLength_"，"
		if (ImportType=1)
		{
			s flag=##class(web.DHCBL.CT.CTHospital).FormValidate(Veobj.HOSPRowId,Veobj.HOSPCode,"")
			if flag=1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"HOSPCode")_"】已存在，"
			s flag=##class(web.DHCBL.CT.CTHospital).FormValidate(Veobj.HOSPRowId,"",Veobj.HOSPDesc)
			if flag=1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"HOSPDesc")_"】已存在，"
		}
		q myVresult
	}
	if (tablecode="SS_Group")
	{
		s MLength=$$$comMemberArrayGet("User.SSGroup",$$$cCLASSproperty,"SSGRPDesc",$$$cPROPparameter,"MAXLEN")
		if $l(Veobj.SSGRPDesc)>MLength s myVresult="【"_..GetFieldDescByName(ID,"SSGRPDesc")_"】长度不能超过"_MLength_"，"
		///2020-06-06 云HIS 校验医院
		s validStr= ##class(web.DHCBL.BDP.BDPMappingHOSP).ValidateHospId(tablename,Veobj.LinkHospId)  ///校验医院
		if (validStr'="")
		{
			s myVresult=myVresult_validStr
			q myVresult
		}
		if (ImportType=1)
		{
			s flag=##class(web.DHCBL.CT.SSGroup).FormValidate(Veobj.SSGRPRowId,Veobj.SSGRPDesc,Veobj.LinkHospId)
			if flag=1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"SSGRPDesc")_"】已存在，"
		}
		q myVresult
	}
	if (tablecode="RBC_DepartmentGroup") //科室部门组
	{
		
		s MLength=$$$comMemberArrayGet("User.RBCDepartmentGroup",$$$cCLASSproperty,"DEPCode",$$$cPROPparameter,"MAXLEN")
		if $l(Veobj.DEPCode)>MLength s myVresult="【"_..GetFieldDescByName(ID,"DEPCode")_"】长度不能超过"_MLength_"，"
		
		///2020-06-06 云HIS 校验医院
		s validStr= ##class(web.DHCBL.BDP.BDPMappingHOSP).ValidateHospId(tablename,Veobj.LinkHospId)  ///校验医院
		if (validStr'="")
		{
			s myVresult=myVresult_validStr
			q myVresult
		}
		
		if (ImportType=1)
		{
			for hospi=1:1:$l(Veobj.LinkHospId,"/")
			{
				s HospId=$p(Veobj.LinkHospId,"/",hospi)
				
				s flag=##class(web.DHCBL.CT.RBCDepartmentGroup).FormValidate(Veobj.DEPRowId,Veobj.DEPCode,"",HospId)
				if flag=1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"DEPCode")_"】已存在，"
				s flag=##class(web.DHCBL.CT.RBCDepartmentGroup).FormValidate(Veobj.DEPRowId,"",Veobj.DEPDesc,HospId)
				if flag=1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"DEPDesc")_"】已存在，"
			}
		}
		q myVresult
	}
	if (tablecode="CT_Title")
	{
		s MLength=$$$comMemberArrayGet("User.CTTitle",$$$cCLASSproperty,"TTLCode",$$$cPROPparameter,"MAXLEN")
		if $l(Veobj.TTLCode)>MLength s myVresult="【"_..GetFieldDescByName(ID,"TTLCode")_"】长度不能超过"_MLength_"，"
		if (ImportType=1)
		{
			s flag=##class(web.DHCBL.CT.CTTitle).FormValidate(Veobj.TTLRowId,Veobj.TTLCode,"")
			if flag=1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"TTLCode")_"】已存在，"
			s flag=##class(web.DHCBL.CT.CTTitle).FormValidate(Veobj.TTLRowId,"",Veobj.TTLDesc)
			if flag=1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"TTLDesc")_"】已存在，"
		}
		q myVresult
	}
	
	if (tablecode="CT_Loc")  //科室/病区
	{
		s MLength=$$$comMemberArrayGet("User.CTLoc",$$$cCLASSproperty,"CTLOCCode",$$$cPROPparameter,"MAXLEN")
		if $l(Veobj.CTLOCCode)>MLength s myVresult="【"_..GetFieldDescByName(ID,"CTLOCCode")_"】长度不能超过"_MLength_"，"
		///2020-06-06 云HIS 校验医院
		s validStr= ##class(web.DHCBL.BDP.BDPMappingHOSP).ValidateHospId(tablename,Veobj.CTLOCHospitalDR)
		if (validStr'="")
		{
			s myVresult=myVresult_validStr
			q myVresult
		}
		
		if (ImportType=1)
		{
			s HospId=Veobj.CTLOCHospitalDR
			s flag=##class(web.DHCBL.CT.CTLoc).FormValidate(Veobj.CTLOCRowID,Veobj.CTLOCCode,"",HospId)
			if flag=1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"CTLOCCode")_"】已存在，"
			s flag=##class(web.DHCBL.CT.CTLoc).FormValidate(Veobj.CTLOCRowID,"",Veobj.CTLOCDesc,HospId)
			if flag=1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"CTLOCDesc")_"】已存在，"	
		}
		s:Veobj.CTLOCType'="" Veobj.CTLOCType=$$ALPHAUP^SSUTIL4(Veobj.CTLOCType)
		if (Veobj.CTLOCType'="")&(Veobj.CTLOCType'="WARD")&(Veobj.CTLOCType'="EXECUTE")&(Veobj.CTLOCType'="DRUGINJECTION")&(Veobj.CTLOCType'="DISPENSING")&(Veobj.CTLOCType'="CASHIER")&(Veobj.CTLOCType'="OTHER")&(Veobj.CTLOCType'="OPERATINGTHEATRE")&(Veobj.CTLOCType'="EMERGENCY")&(Veobj.CTLOCType'="DAYSURGERY")&(Veobj.CTLOCType'="MEDICALRECORDS")&(Veobj.CTLOCType'="OUTPATIENTCONSULTINGROOM")&(Veobj.CTLOCType'="CLINIC")&(Veobj.CTLOCType'="ADMISSIONPOINT") s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"CTLOCType")_"】校验失败，"
		
		//S:Veobj.ADMLOCAdmType'="" Veobj.ADMLOCAdmType=$zcvt(Veobj.ADMLOCAdmType,"U")
		///只能关联一个科室分类
		//if (Veobj.ADMLOCAdmType'="")&(Veobj.ADMLOCAdmType'="门诊")&(Veobj.ADMLOCAdmType'="住院")&(Veobj.ADMLOCAdmType'="急诊")&(Veobj.ADMLOCAdmType'="体检") s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"ADMLOCAdmType")_"】校验失败，"
		//2022-07-20放开限制
		if Veobj.ADMLOCAdmType'=""
		{
			s Veobj.ADMLOCAdmType=$zcvt(Veobj.ADMLOCAdmType,"U")
			s length=$l(Veobj.ADMLOCAdmType,"/")
			for i=1:1:length
			{	
				s Type=$p(Veobj.ADMLOCAdmType,"/",i)
				if (Type'="门诊")&(Type'="住院")&(Type'="急诊")&(Type'="体检")
				{
					s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"ADMLOCAdmType")_"】校验失败，"
					q
				}
			}
		}

		if (Veobj.CTLOCAgeFrom'="")&(Veobj.CTLOCAgeTo'="")
		{
			if Veobj.CTLOCAgeFrom>Veobj.CTLOCAgeTo
			{
				s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"CTLOCAgeTo")_"】不能小于【"_..GetFieldDescByName(ID,"CTLOCAgeFrom")_"】，"
			}
		}
		if Veobj.CTLOCClinicType'=""
		{
			s Veobj.CTLOCClinicType=$zcvt(Veobj.CTLOCClinicType,"U")
			s length=$l(Veobj.CTLOCClinicType,"/")
			s errorflag=0
			for i=1:1:length
			{	
				s Type=$p(Veobj.CTLOCClinicType,"/",i)
				if (Type'="")&(Type'="门诊")&(Type'="住院")&(Type'="急诊")&(Type'="体检")
				{
					s errorflag=1
				 	q
				}
			}
			if (errorflag=1) s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"CTLOCClinicType")_"】校验失败，"	
		}
		//校验楼层 likefan 20201202
		if (Veobj.CTLOCFloor'="")
		{
			s floorid=##class(web.DHCBL.CT.CTLocBuildingFloor).GetFloorIDByDesc(Veobj.CTLOCFloor,Veobj.CTLOCHospitalDR)
			s:floorid="" myVresult=myVresult_"楼层【"_Veobj.CTLOCFloor_"】校验失败，"	
		}
		q myVresult
	}
	if (tablecode="CT_CarPrvTp")
	{
		s MLength=$$$comMemberArrayGet("User.CTCarPrvTp",$$$cCLASSproperty,"CTCPTCode",$$$cPROPparameter,"MAXLEN")
		if $l(Veobj.CTCPTCode)>MLength s myVresult="【"_..GetFieldDescByName(ID,"CTCPTCode")_"】长度不能超过"_MLength_"，"
		if (ImportType=1)
		{
			s flag=##class(web.DHCBL.CT.CTCarPrvTp).FormValidate(Veobj.CTCPTRowId,Veobj.CTCPTCode,"")
			if flag=1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"CTCPTCode")_"】已存在，"
			s flag=##class(web.DHCBL.CT.CTCarPrvTp).FormValidate(Veobj.CTCPTRowId,"",Veobj.CTCPTDesc)
			if flag=1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"CTCPTDesc")_"】已存在，"	
		}	
		if (Veobj.CTCPTInternalType'="")&(Veobj.CTCPTInternalType'="NURSE")&(Veobj.CTCPTInternalType'="DOCTOR")&(Veobj.CTCPTInternalType'="Technician")&(Veobj.CTCPTInternalType'="Pharmacist")&(Veobj.CTCPTInternalType'="Other")&(Veobj.CTCPTInternalType'="护士")&(Veobj.CTCPTInternalType'="医生")&(Veobj.CTCPTInternalType'="技师")&(Veobj.CTCPTInternalType'="药师")&(Veobj.CTCPTInternalType'="其他") s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"CTCPTInternalType")_"】 "_Veobj.CTCPTInternalType_" 校验失败，"
		q myVresult
	}
	if (tablecode="SS_User")
	{
		s myVresult=""
		s MLength=$$$comMemberArrayGet("User.SSUser",$$$cCLASSproperty,"SSUSRInitials",$$$cPROPparameter,"MAXLEN")
		if $l(Veobj.SSUSRInitials)>MLength s myVresult="【"_..GetFieldDescByName(ID,"SSUSRInitials")_"】长度不能超过"_MLength_"，"
		if (Veobj.Type'="UC")&(Veobj.Type'="U")&(Veobj.Type'="C")  s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"Type")_"】只能为UC或U，C"
		
		if (Veobj.Type["U")
		{
			if (Veobj.SSUSRGroup="") s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"SSUSRGroup")_"】为必填项，"
			if (Veobj.DeptLoc="") s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"DeptLoc")_"】为必填项，"
			
		}
		if (Veobj.Type["C")
		{
			if (Veobj.CTPCPCarPrvTpDR="") s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"CTPCPCarPrvTpDR")_"】为必填项，"
			
		}
		if (ImportType=1)
		{
			s flag=##class(web.DHCBL.CT.SSUser).FormValidate(Veobj.SSUSRRowId,Veobj.SSUSRInitials)
			if flag=1 s myVresult=myVresult_"用户【"_..GetFieldDescByName(ID,"SSUSRInitials")_"】已存在，"
			
			//s Veobj.CTPCPCode=Veobj.SSUSRInitials
			s flag=##class(web.DHCBL.CT.CTCareProv).FormValidate(Veobj.CTPCPRowId1,Veobj.SSUSRInitials)
		 	if flag=1 s myVresult=myVresult_"医护人员【"_..GetFieldDescByName(ID,"SSUSRInitials")_"】已存在，"
		}
		if (Veobj.DeptLoc'="")&&(Veobj.SSUSRGroup'="")
		{
			s hospLength=$l(Veobj.SSUSRHospitalDR,"/")
			if (($l(Veobj.DeptLoc,"/")'=$l(Veobj.SSUSRGroup,"/"))||((hospLength'=1)&&(hospLength'=$l(Veobj.SSUSRGroup,"/"))))
			{
				s myVresult=myVresult_"安全组/登录科室/医院数据不对应，"
			}
			else
			{
				
				s i=0,errorflag=0
				for i=1:1:$l(Veobj.DeptLoc,"/")
				{
					s CTLOCDesc=$p(Veobj.DeptLoc,"/",i) 
					s SSGRPDesc=$p(Veobj.SSUSRGroup,"/",i)
					if hospLength=1 s HospitalDesc=Veobj.SSUSRHospitalDR
					else  s HospitalDesc=$p(Veobj.SSUSRHospitalDR,"/",i)
					if (CTLOCDesc="")
					{
						s errorflag=1
						s myVresult=myVresult_"登录科室数据有空值，"
					}
					if (SSGRPDesc="")
					{
						s errorflag=1
						s myVresult=myVresult_"安全组数据有空值，"
					}
					if (HospitalDesc="")
					{
						s errorflag=1
						s myVresult=myVresult_"医院数据有空值，"
					}
					if (CTLOCDesc'="")&(SSGRPDesc'="")&(HospitalDesc'="")
					{
						s HospId=$o(^CT("HOSP",0,"Desc",$$ALPHAUP^SSUTIL4(HospitalDesc),0))	
						if (HospId="")&&(HospitalDesc'="") s myVresult=myVresult_"【"_HospitalDesc_"】在医院表中没找到这条数据，"
						if (HospId'="")
						{
							s LOCDR=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByDesc("CT_Loc",CTLOCDesc,HospId)
							if (LOCDR="")&&(CTLOCDesc'="") s myVresult=myVresult_"【"_CTLOCDesc_"】在科室表中没找到这条数据，"
						
							s GroupDR=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByDesc("SS_Group",SSGRPDesc,HospId)
							if (GroupDR="")&&(SSGRPDesc'="")
							{
								 s myVresult=myVresult_"【"_SSGRPDesc_"】在安全组表中没找到这条数据或者该安全组没有关联指定院区，"
							}
							if (LOCDR'="")&&(GroupDR'="")
							{
								if $d(OtherArray(LOCDR,GroupDR)) s myVresult=myVresult_"其他登录科室有重复数据，"
								else  s OtherArray(LOCDR,GroupDR)=""
							}
						}
					
					}
				}
			}
			
		}
		else
		{
			///2020-06-06 云HIS 校验医院有效性
			for i=1:1:$l(Veobj.SSUSRHospitalDR,"/")
			{
				s HospitalDesc=$p(Veobj.SSUSRHospitalDR,"/",i)
				if (HospitalDesc="")
				{
					s myVresult=myVresult_"医院数据有空值，"
				}
				else
				{
					s HospId=$o(^CT("HOSP",0,"Desc",$$ALPHAUP^SSUTIL4(HospitalDesc),0))
					if (HospId="")&&(HospitalDesc'="") s myVresult=myVresult_"【"_HospitalDesc_"】在医院表中没找到这条数据，"
				}
			}
		}
		///医护人员管制药品分类权限
		if (Veobj.CTCareProvPHCPoison'="")
		{
			s PHCPoisonLen=$l(Veobj.CTCareProvPHCPoison,"/")
			for PHCPoisoni=1:1:PHCPoisonLen
			{
				s PHCPoisonDesc=$p(Veobj.CTCareProvPHCPoison,"/",PHCPoisoni)
				continue:PHCPoisonDesc=""
				s CPPPHCPoisonDR=$o(^PHCPO(0,"Desc",$$ALPHAUP^SSUTIL4(PHCPoisonDesc),0))
				if CPPPHCPoisonDR=""
				{
					s myVresult=myVresult_"管制药品分类错误，"
					q
				}
					 
			}
		}
		///医护人员关联处方权
		if (Veobj.CTCareProvPrescriptSet'="")
		{
			s PrescriptSetLen=$l(Veobj.CTCareProvPrescriptSet,"/")
			for PrescriptSeti=1:1:PrescriptSetLen
			{
				s PrescriptSetDesc=$p(Veobj.CTCareProvPrescriptSet,"/",PrescriptSeti)
				continue:PrescriptSetDesc=""
				if (Veobj.SSUSRHospitalDR["/")	//前面多个医院
				{
					if (Veobj.CTCareProvPrescriptSet'["-")
					{
						s myVresult=myVresult_"关联处方权错误，"
						q
					}
					s PrescriptSetDR=##class(web.DHCBL.CT.CTCareProvPrescriptSet).GetPrescriptIdByDesc2(PrescriptSetDesc)
					if PrescriptSetDR=""
					{
						s myVresult=myVresult_"关联处方权错误，"
						q
					}
				}
				else	//前面单个医院
				{
					if (Veobj.CTCareProvPrescriptSet["-")	//按自己的院区-处方权
					{
						s PrescriptSetDR=##class(web.DHCBL.CT.CTCareProvPrescriptSet).GetPrescriptIdByDesc2(PrescriptSetDesc)
						if PrescriptSetDR=""
						{
							s myVresult=myVresult_"关联处方权错误，"
							q
						}
					}
					else	//按前面的院区
					{
						s HospId=$o(^CT("HOSP",0,"Desc",$$ALPHAUP^SSUTIL4(Veobj.SSUSRHospitalDR),0))	//前面已校验过医院
						s PrescriptSetDR=##class(web.DHCBL.CT.CTCareProvPrescriptSet).GetPrescriptIdByDesc(PrescriptSetDesc,HospId)
						if PrescriptSetDR=""
						{
							s myVresult=myVresult_"关联处方权错误，"
							q
						}
					}
					
				}
			}
		}
		q myVresult
	}
	
	if (tablecode="DHC_CTLoc_MedUnitCareProv")	//医疗单元及医疗单元关联医护人员
	{
		///2020-06-06 云HIS 校验医院
		s validStr= ##class(web.DHCBL.BDP.BDPMappingHOSP).ValidateHospId(tablename,Veobj.LinkHospId)  ///校验医院
		if (validStr'="")
		{
			s myVresult=myVresult_validStr
			q myVresult
		}
		s CTLOCRowId=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByDesc("CT_Loc",Veobj.CTMUCTLOCParRef,Veobj.LinkHospId)
		
		if CTLOCRowId=""
		{
			s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"CTMUCTLOCParRef")_"】对应的科室不存在，"
			
		}
		
		if Veobj.CTPCPCode=""
		{
			s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"CTPCPCode")_"】为必填项，"
		}
		else
		{
			
			S ctpcpid=$o(^CTPCP(0,"Code",$$ALPHAUP^SSUTIL4(Veobj.CTPCPCode),0))
			if ctpcpid=""
			{
				s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"CTPCPCode")_"】对应的医生不存在，"	
			}
			else
			{
				s DocName=$p($g(^CTPCP(ctpcpid,1)),"^",2)
				if DocName'=Veobj.CTPCPDesc  s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"CTPCPCode")_"】和【"_..GetFieldDescByName(ID,"CTPCPDesc")_"】不匹配，"
				
				if CTLOCRowId'=""
				{
					//s flag= ##class(web.BDPExt.DHCMarkDocBLL).CheckCTCareProvData(ctpcpid,CTLOCRowId)
					///指定科室里，人员关联了本科室或者科室的关联科室
				
					s flag=$o(^RB("RES",0,"CTPCP",ctpcpid,CTLOCRowId,0))
					if flag=""
					{
						s LINKChildsub=0
						for
						{
							s LINKChildsub=$o(^CTLOC(CTLOCRowId,"LINK",LINKChildsub)) q:LINKChildsub=""
							s LINKCTLOCDR=$p($g(^CTLOC(CTLOCRowId,"LINK",LINKChildsub)),"^",1)
							if LINKCTLOCDR'=""
							{
								s flagc=$o(^RB("RES",0,"CTPCP",ctpcpid,LINKCTLOCDR,0))
								if flagc'="" s flag=1
							}
						}
					}
					if flag="" s myVresult=myVresult_"医生未维护到此科室或此科室的关联科室，"
					if (ImportType=1)
					{
						s ret=##class(web.BDPExt.DHCCTLocMedUnitCareProvBLL).FormValidate(CTLOCRowId,Veobj.CTMUCode,Veobj.CTMUDesc)
						if $p(ret,"^",1)=1 
						{
							s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"CTMUCode")_"】或【"_..GetFieldDescByName(ID,"CTMUDesc")_"】已存在，"
						}
						else
						{
							s CTMURowId=$p(ret,"^",2)
							if CTMURowId["||"
							{
								s flag= ##class(web.DHCBL.CT.DHCCTLocMedUnitCareProv).FormValidate(CTMURowId,"",ctpcpid,Veobj.MUCPDateFrom,Veobj.MUCPDateTo)
								if $p(flag,"^",1)=0
								{
									s myVresult=myVresult_$p(flag,"^",2)_","
								}
							}
						}
					}
				}
				
			}
		}
		q myVresult
	}
	
	if (tablecode="PH_Manufacturer")	//厂商
	{
		s MLength=$$$comMemberArrayGet("User.PHManufacturer",$$$cCLASSproperty,"PHMNFCode",$$$cPROPparameter,"MAXLEN")
		if $l(Veobj.mCode)>MLength s myVresult="【"_..GetFieldDescByName(ID,"mCode")_"】长度不能超过"_MLength_"，"
		///2020-06-06 云HIS 校验医院
		s validStr= ##class(web.DHCBL.BDP.BDPMappingHOSP).ValidateHospId(tablename,Veobj.LinkHospId)  ///校验医院
		if (validStr'="")
		{
			s myVresult=myVresult_validStr
			q myVresult
		}
		
		if (ImportType=1)
		{
			///管控数据
			for hospi=1:1:$l(Veobj.LinkHospId,"/")
			{
				s HospId=$p(Veobj.LinkHospId,"/",hospi)
				s PHMNFRowId=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("PH_Manufacturer",Veobj.mCode_"^"_Veobj.mType,HospId)
				i PHMNFRowId>0
				{
					s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"mCode")_"】已存在，"
				}
				else
				{
					//如果存在代码一样的数据，提示重复 （跨院区不能重复
					if (Veobj.mCode'="")
					{
						s ValidateFlag=0
						s PHMNFRowId=0
						for
						{
							s PHMNFRowId=$o(^PHMNF(0,"Code",$$ALPHAUP^SSUTIL4(Veobj.mCode),PHMNFRowId)) Q:PHMNFRowId=""
							s MANFRowid=$o(^DHCMANF(0,"MANF",PHMNFRowId,0))  
							if MANFRowid'=""
							{
								s MANFType=$p($g(^DHCMANF(MANFRowid)),"^",7)  //生产厂商类型
								continue:MANFType'=Veobj.mType
								s PHMNFCode=$p($g(^PHMNF(PHMNFRowId)),"^",1)   //生产厂商代码
								s PHMNFName=$p($g(^PHMNF(PHMNFRowId)),"^",2)  //生产厂商名称
								if (PHMNFCode=Veobj.mCode) s ValidateFlag=1	
							}
						}
						if (ValidateFlag=1)  s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"mCode")_"】已存在，"
					}
				}
				s PHMNFRowId=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByDesc("PH_Manufacturer",Veobj.mName_"^"_Veobj.mType,HospId)
				i PHMNFRowId>0
				{
					 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"mName")_"】已存在，"
				}
				else
				{
					//如果存在名称一样的数据，提示重复
					if (Veobj.mName'="")
					{
						s ValidateFlag=0
						s PHMNFRowId=0
						for
						{
							s PHMNFRowId=$o(^PHMNF(0,"Name",$$ALPHAUP^SSUTIL4(Veobj.mName),PHMNFRowId)) Q:PHMNFRowId=""
							s MANFRowid=$o(^DHCMANF(0,"MANF",PHMNFRowId,0))  
							if MANFRowid'=""
							{
								s MANFType=$p($g(^DHCMANF(MANFRowid)),"^",7)  //生产厂商类型
								continue:MANFType'=Veobj.mType
								s PHMNFCode=$p($g(^PHMNF(PHMNFRowId)),"^",1)   //生产厂商代码
								s PHMNFName=$p($g(^PHMNF(PHMNFRowId)),"^",2)  //生产厂商名称
								if (PHMNFName=Veobj.mName) s ValidateFlag=1	
							}
						}
						if (ValidateFlag=1)  s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"mName")_"】已存在，"
					}
				}
			}
		}
		
		
		if (Veobj.mType'="M")&&(Veobj.mType'="G") s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"mType")_"】校验失败，"
		///2021-01-26 增加列的校验
		if ((Veobj.mComLicDateFrom'="")||(Veobj.mComLicDateTo'="")) //营业执照号	营业执照开始日期	营业执照截止日期
		{
			if (Veobj.mComLic="") s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"mComLic")_"】不能为空，"
			if (Veobj.mComLicDateFrom="") s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"mComLicDateFrom")_"】不能为空，"
			if (Veobj.mComLicDateTo="") s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"mComLicDateTo")_"】不能为空，"
		}
		if ((Veobj.mInsProLicDateFrom'="")||(Veobj.mInsProLicDateTo'="")) //器械生产许可号	器械生产许可起始日期	器械生产许可截止日期
		{
			if (Veobj.mInsProLic="") s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"mInsProLic")_"】不能为空，"
			if (Veobj.mInsProLicDateFrom="") s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"mInsProLicDateFrom")_"】不能为空，"
			if (Veobj.mInsProLicDateTo="") s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"mInsProLicDateTo")_"】不能为空，"
		}
		if ((Veobj.mFirstProdLicDateFrom'="")||(Veobj.mFirstProdLicDateTo'="")) //一类器械生产备案号	一类器械生产备案起始日期	一类器械生产备案截止日期
		{
			if (Veobj.mFirstProdLic="") s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"mFirstProdLic")_"】不能为空，"
			if (Veobj.mFirstProdLicDateFrom="") s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"mFirstProdLicDateFrom")_"】不能为空，"
			if (Veobj.mFirstProdLicDateTo="") s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"mFirstProdLicDateTo")_"】不能为空，"
		}
		
		q myVresult
	}
	if (tablecode="APC_Vendor")	//供应商
	{
		
		s MLength=$$$comMemberArrayGet("User.APCVendor",$$$cCLASSproperty,"APCVMCode",$$$cPROPparameter,"MAXLEN")
		if $l(Veobj.vCode)>MLength s myVresult="【"_..GetFieldDescByName(ID,"vCode")_"】长度不能超过"_MLength_"，"
		s MLength=$$$comMemberArrayGet("User.APCVendor",$$$cCLASSproperty,"APCVMName",$$$cPROPparameter,"MAXLEN")
		if $l(Veobj.vName)>MLength s myVresult="【"_..GetFieldDescByName(ID,"vName")_"】长度不能超过"_MLength_"，"
		s:Veobj.vType'="" Veobj.vType=$$ALPHAUP^SSUTIL4(Veobj.vType)
		if (Veobj.vType'="M")&&(Veobj.vType'="G") s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"vType")_"】校验失败，"
		
		///2020-06-06 云HIS 校验医院
		s validStr= ##class(web.DHCBL.BDP.BDPMappingHOSP).ValidateHospId(tablename,Veobj.LinkHospId)  ///校验医院
		if (validStr'="")
		{
			s myVresult=myVresult_validStr
			q myVresult
		}
		
		if (ImportType=1)
		{
			///管控数据
			for hospi=1:1:$l(Veobj.LinkHospId,"/")
			{
				s HospId=$p(Veobj.LinkHospId,"/",hospi)
				s APCVMRowId=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("APC_Vendor",Veobj.vCode_"^"_Veobj.vType,HospId)
				i APCVMRowId>0
				{
					s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"vCode")_"】已存在，"
				}
				else
				{
					//如果存在代码一样的数据，提示重复
					if (Veobj.vCode'="")
					{
						s ValidateFlag=0
						s APCVMRowId=0
						for
						{
							s APCVMRowId=$o(^APC("APCVM",0,"APCVM_Code",$$ALPHAUP^SSUTIL4(Veobj.vCode),APCVMRowId)) Q:APCVMRowId=""
							s APCVMType=$p($g(^APC("APCVM",APCVMRowId)),"^",9)  //供应商类型
							continue:APCVMType'=Veobj.vType
							s APCVMCode=$p($g(^APC("APCVM",APCVMRowId)),"^",2)  //供应商代码
							s APCVMName=$p($g(^APC("APCVM",APCVMRowId)),"^",3)  //供应商名称
							if (APCVMCode=Veobj.vCode) s ValidateFlag=1
						}
						if (ValidateFlag=1)  s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"vCode")_"】已存在，"
					}
				}
				s APCVMRowId=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByDesc("APC_Vendor",Veobj.vName_"^"_Veobj.vType,HospId)  //供应商有物资和药品 同名但是Type不一样的
				i APCVMRowId>0
				{
					s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"vName")_"】已存在，"
				}
				else
				{
					//如果存在名称一样的数据，提示重复
					if (Veobj.vName'="")
					{
						s ValidateFlag=0
						s APCVMRowId=0
						for
						{
							s APCVMRowId=$o(^APC("APCVM",0,"APCVM_Name",$$ALPHAUP^SSUTIL4(Veobj.vName),APCVMRowId)) Q:APCVMRowId=""
							s APCVMType=$p($g(^APC("APCVM",APCVMRowId)),"^",9)  //供应商类型
							continue:APCVMType'=Veobj.vType
							s APCVMCode=$p($g(^APC("APCVM",APCVMRowId)),"^",2)  //供应商代码
							s APCVMName=$p($g(^APC("APCVM",APCVMRowId)),"^",3)  //供应商名称
							if (APCVMName=Veobj.vName) s ValidateFlag=1
						}
						if (ValidateFlag=1)  s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"vName")_"】已存在，"
					}
				}
			}
		}
		///2021-01-26 增加列的校验
		if ((Veobj.vComLicDateFrom'="")||(Veobj.vComLicDateTo'="")) //营业执照号	营业执照开始日期	营业执照截止日期
		{
			if (Veobj.vComLic="") s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"vComLic")_"】不能为空，"
			if (Veobj.vComLicDateFrom="") s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"vComLicDateFrom")_"】不能为空，"
			if (Veobj.vComLicDateTo="") s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"vComLicDateTo")_"】不能为空，"
		}
		if ((Veobj.vInsBusLicDateFrom'="")||(Veobj.vInsBusLicDateTo'="")) //经营许可证编号	经营许可起始日期	经营许可截止日期
		{
			if (Veobj.vInsBusLic="") s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"vInsBusLic")_"】不能为空，"
			if (Veobj.vInsBusLicDateFrom="") s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"vInsBusLicDateFrom")_"】不能为空，"
			if (Veobj.vInsBusLicDateTo="") s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"vInsBusLicDateTo")_"】不能为空，"
		}
		if ((Veobj.vSecondBusLicDateFrom'="")||(Veobj.vSecondBusLicDateTo'="")) //二类经营备案号	二类经营备案起始日期	二类经营备案截止日期
		{
			if (Veobj.vSecondBusLic="") s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"vSecondBusLic")_"】不能为空，"
			if (Veobj.vSecondBusLicDateFrom="") s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"vSecondBusLicDateFrom")_"】不能为空，"
			if (Veobj.vSecondBusLicDateTo="") s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"vSecondBusLicDateTo")_"】不能为空，"
		}
		q myVresult
	}
	
	
	if (tablecode="DHC_STOrigin") //产地
	{
		s MLength=$$$comMemberArrayGet("User.DHCSTOrigin",$$$cCLASSproperty,"OrigCode",$$$cPROPparameter,"MAXLEN")
		if $l(Veobj.OrigCode)>MLength s myVresult="【"_..GetFieldDescByName(ID,"OrigCode")_"】长度不能超过"_MLength_"，"
		s MLength=$$$comMemberArrayGet("User.DHCSTOrigin",$$$cCLASSproperty,"OrigName",$$$cPROPparameter,"MAXLEN")
		if $l(Veobj.OrigName)>MLength s myVresult="【"_..GetFieldDescByName(ID,"OrigName")_"】长度不能超过"_MLength_"，"
		
		if (Veobj.OrigType'="M")&&(Veobj.OrigType'="G") s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"OrigType")_"】校验失败，"
		
		///2020-06-06 云HIS 校验医院
		s validStr= ##class(web.DHCBL.BDP.BDPMappingHOSP).ValidateHospId(tablename,Veobj.LinkHospId)  ///校验医院
		if (validStr'="")
		{
			s myVresult=myVresult_validStr
			q myVresult
		}
		
		if (ImportType=1)
		{
			//管控数据
			for hospi=1:1:$l(Veobj.LinkHospId,"/")
			{
				s HospId=$p(Veobj.LinkHospId,"/",hospi)
				s OrigRowId=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("DHC_STOrigin",Veobj.OrigCode_"^"_Veobj.OrigType,HospId)
				i OrigRowId>0
				{
					s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"OrigCode")_"】已存在，"
				}
				else
				{
					//如果存在代码一样的数据，提示重复
					if (Veobj.OrigCode'="")
					{
						s ValidateFlag=0
						s OrigRowId=0
						for
						{
							s OrigRowId=$o(^DHCSTORI(0,"Code",$$ALPHAUP^SSUTIL4(Veobj.OrigCode),OrigRowId)) Q:OrigRowId=""
							s OrigType=$p($g(^DHCSTORI(OrigRowId)),"^",3)  //类型
							continue:OrigType'=Veobj.OrigType
							s ORICode=$p($g(^DHCSTORI(OrigRowId)),"^",1)  //代码
							if (ORICode=Veobj.OrigCode) s ValidateFlag=1
						}
						if (ValidateFlag=1)  s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"OrigCode")_"】已存在，"
					}
				}
				s OrigRowId=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByDesc("DHC_STOrigin",Veobj.OrigName_"^"_Veobj.OrigType,HospId)
				i OrigRowId>0
				{
					s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"OrigName")_"】已存在，"
				}
				else
				{
					//如果存在名称一样的数据，提示重复
					if (Veobj.OrigName'="")
					{
						s ValidateFlag=0
						s OrigRowId=0
						for
						{
							s OrigRowId=$o(^DHCSTORI(0,"Code",$$ALPHAUP^SSUTIL4(Veobj.OrigName),OrigRowId)) Q:OrigRowId=""
							s OrigType=$p($g(^DHCSTORI(OrigRowId)),"^",3)  //类型
							continue:OrigType'=Veobj.OrigType
							s ORIName=$p($g(^DHCSTORI(OrigRowId)),"^",2)  //名称
							if (ORIName=Veobj.OrigName) s ValidateFlag=1
						}
						if (ValidateFlag=1)  s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"OrigName")_"】已存在，"
					}
				}
			}
		}
		q myVresult
	}
	if (tablecode="DHC_Carrier") //配送商 私有
	{
		s MLength=$$$comMemberArrayGet("User.DHCCarrier",$$$cCLASSproperty,"CACode",$$$cPROPparameter,"MAXLEN")
		if $l(Veobj.CACode)>MLength s myVresult="【"_..GetFieldDescByName(ID,"CACode")_"】长度不能超过"_MLength_"，"
		s MLength=$$$comMemberArrayGet("User.DHCCarrier",$$$cCLASSproperty,"CADesc",$$$cPROPparameter,"MAXLEN")
		if $l(Veobj.CACode)>MLength s myVresult="【"_..GetFieldDescByName(ID,"CADesc")_"】长度不能超过"_MLength_"，"
		if (Veobj.CAType'="M")&&(Veobj.CAType'="G") s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"CAType")_"】校验失败，"
		
		///2020-06-06 云HIS 校验医院
		s validStr= ##class(web.DHCBL.BDP.BDPMappingHOSP).ValidateHospId(tablename,Veobj.LinkHospId)  ///校验医院
		if (validStr'="")
		{
			s myVresult=myVresult_validStr
			q myVresult
		}
		
		if (ImportType=1)
		{
			for hospi=1:1:$l(Veobj.LinkHospId,"/")
			{
				s HospId=$p(Veobj.LinkHospId,"/",hospi)
				s CARowId=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("DHC_Carrier",Veobj.CACode_"^"_Veobj.CAType,"") //HospId 2023-01-18跨院区也不允许代码重复
				i CARowId>0 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"CACode")_"】已存在，"
				s CARowId=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByDesc("DHC_Carrier",Veobj.CADesc_"^"_Veobj.CAType,HospId)
				i CARowId>0 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"CADesc")_"】已存在，"
			}
		}
		q myVresult
	}
	
	  
	if (tablecode="ARC_BillSub")  //账单分类 2020-06-11
	{
		
		s myVresult=""
		///2020-06-06 云HIS 校验医院
		s validStr= ##class(web.DHCBL.BDP.BDPMappingHOSP).ValidateHospId(tablename,Veobj.LinkHospId)  ///校验医院
		if (validStr'="")
		{
			s myVresult=myVresult_validStr
			q myVresult
		}
		s Veobj.ARCBGDesc=Veobj.ARCBGCode  //账单大类 
		s Veobj.ARCBGAbbrev=Veobj.ARCBGDesc
		s Veobj.ARCSGDesc=Veobj.ARCSGCode      //账单子类
		s Veobj.ARCSGAbbrev=Veobj.ARCSGDesc              
	
		; 1 账单大类与账单子类
		s ARCBGRowId=""
		if (Veobj.ARCBGCode'="")&(Veobj.ARCSGCode'="")&&(Veobj.ARCBGDesc'="")&(Veobj.ARCSGDesc'="")
		{
			if (ImportType=1)
			{
				///私有数据
				s ParRef=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("ARC_BillGrp",Veobj.ARCBGCode,Veobj.LinkHospId)
				if ParRef'=""    //同一个账单组下不允许重复
				{
					s flag=##class(web.DHCBL.CT.ARCBillSub).FormValidate("",ParRef,Veobj.ARCSGCode,Veobj.ARCSGDesc,Veobj.LinkHospId)
					if (flag>0)
					{
						s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"ARCSGCode")_"】"_Veobj.ARCSGCode_"已存在，"
					}
				}
				
			}
		}
		else
		{
			if ((Veobj.ARCBGCode'="")||(Veobj.ARCSGCode'="")||(Veobj.ARCBGDesc'="")||(Veobj.ARCSGDesc'="")) s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"ARCBGCode")_"】或【"_..GetFieldDescByName(ID,"ARCSGCode")_"】有空值，"
		}
	}
	if (tablecode="ChargeCategory")  //费用分类 14个
	{
		s myVresult=""
		///2020-06-06 云HIS 校验医院
		s validStr= ##class(web.DHCBL.BDP.BDPMappingHOSP).ValidateHospId(tablename,Veobj.LinkHospId)  ///校验医院
		if (validStr'="")
		{
			s myVresult=myVresult_validStr
			q myVresult
		}
		s Veobj.TARCDesc=Veobj.TARCCode
		s Veobj.TARSCDesc=Veobj.TARSCCode
		s Veobj.TARTICDesc=Veobj.TARTICCode
		s Veobj.TARICDesc=Veobj.TARICCode
		s Veobj.TARTOCDesc=Veobj.TARTOCCode
		s Veobj.TAROCDesc=Veobj.TAROCCode
		s Veobj.TARTECDesc=Veobj.TARTECCode
		s Veobj.TARECDesc=Veobj.TARECCode 
		s Veobj.TARTACDesc=Veobj.TARTACCode
		s Veobj.TARACDesc=Veobj.TARACCode
		s Veobj.TARTMCDesc=Veobj.TARTMCCode
		s Veobj.TARMCDesc=Veobj.TARMCCode
		s Veobj.NTARTMCDesc=Veobj.NTARTMCCode
		s Veobj.NTARMCDesc=Veobj.NTARMCCode
		; 2 收费项目大类与收费项目子类
		if (Veobj.TARCCode'="")&(Veobj.TARSCCode'="")&&(Veobj.TARCDesc'="")&(Veobj.TARSCDesc'="")
		{
			if (ImportType=1)
			{
				///私有数据
				s flag=##class(web.DHCBL.CT.DHCTarSubCate).FormValidate("",Veobj.TARSCCode,Veobj.TARSCDesc,Veobj.LinkHospId)
				if (flag>0)
				{
					s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"TARSCCode")_"】"_Veobj.TARSCCode_"已存在，"
				}
			}
			///20230420 判断项目类型
			if (Veobj.TARSCType'="药品")&&(Veobj.TARSCType'="材料")&&(Veobj.TARSCType'="诊疗项目") s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"TARSCType")_"】要求只能是【药品、材料、诊疗项目】其中之一，"
			
		}
	  	else
		{
			if ((Veobj.TARCCode'="")||(Veobj.TARSCCode'="")||(Veobj.TARCDesc'="")||(Veobj.TARSCDesc'="")) s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"TARCCode")_"】或【"_..GetFieldDescByName(ID,"TARSCCode")_"】有空值，"
		}
		/// 3 住院费用大类和住院费用子类
		if (Veobj.TARTICCode'="")&(Veobj.TARICCode'="")&&(Veobj.TARTICDesc'="")&(Veobj.TARICDesc'="")
		{ 
			if (ImportType=1)
			{
				///私有数据
				s flag=##class(web.DHCBL.CT.DHCTarInpatCate).FormValidate("",Veobj.TARICCode,Veobj.TARICDesc,Veobj.LinkHospId)
				if (flag>0)
				{
					s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"TARICCode")_"】"_Veobj.TARICCode_"已存在，"
				}
			}
		}
		else
		{
			if ((Veobj.TARTICCode'="")||(Veobj.TARICCode'="")||(Veobj.TARTICDesc'="")||(Veobj.TARICDesc'="")) s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"TARICCode")_"】或【"_..GetFieldDescByName(ID,"TARICCode")_"】有空值，"
		}
		; 4 门诊费用大类 门诊费用子类
		if (Veobj.TARTOCCode'="")&(Veobj.TAROCCode'="")&&(Veobj.TARTOCDesc'="")&(Veobj.TAROCDesc'="")
		{
			if (ImportType=1)
			{
				///私有数据
				s flag=##class(web.DHCBL.CT.DHCTarOutpatCate).FormValidate("",Veobj.TAROCCode,Veobj.TAROCDesc,Veobj.LinkHospId)
				if (flag>0)
				{
					s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"TAROCCode")_"】"_Veobj.TAROCCode_"已存在，"
				}
			}
		}
		else
		{
			if ((Veobj.TARTOCCode'="")||(Veobj.TAROCCode'="")||(Veobj.TARTOCDesc'="")||(Veobj.TAROCDesc'="")) s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"TARTOCCode")_"】或【"_..GetFieldDescByName(ID,"TAROCCode")_"】有空值，"
		}

		;5 核算费用大类 核算费用子类
		if (Veobj.TARTECCode'="")&(Veobj.TARECCode'="")&&(Veobj.TARTECDesc'="")&(Veobj.TARECDesc'="")
		{
			if (ImportType=1)
			{
				///私有数据
				s flag=##class(web.DHCBL.CT.DHCTarEMCCate).FormValidate("",Veobj.TARECCode,Veobj.TARECDesc,Veobj.LinkHospId)
				if (flag>0)
				{
					s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"TARECCode")_"】"_Veobj.TARECCode_"已存在，"
				}
			}
		}
		else
		{
			if ((Veobj.TARTECCode'="")||(Veobj.TARECCode'="")||(Veobj.TARTECDesc'="")||(Veobj.TARECDesc'="")) s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"TARTECCode")_"】或【"_..GetFieldDescByName(ID,"TARECCode")_"】有空值，"
		}
		; 6 会计大类 会计子类
		if (Veobj.TARTACCode'="")&(Veobj.TARACCode'="")&&(Veobj.TARTACDesc'="")&(Veobj.TARACDesc'="")
		{
			if (ImportType=1)
			{
				///私有数据
				s flag=##class(web.DHCBL.CT.DHCTarAcctCate).FormValidate("",Veobj.TARACCode,Veobj.TARACDesc,Veobj.LinkHospId)
				if (flag>0)
				{
					s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"TARACCode")_"】"_Veobj.TARACCode_"已存在，"
				}
			}
		}
		else
		{
			if ((Veobj.TARTACCode'="")||(Veobj.TARACCode'="")||(Veobj.TARTACDesc'="")||(Veobj.TARACDesc'="")) s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"TARTACCode")_"】或【"_..GetFieldDescByName(ID,"TARACCode")_"】有空值，"
		}
		; 7 病案首页大类 病案首页子类
		if (Veobj.TARTMCCode'="")&(Veobj.TARMCCode'="")&&(Veobj.TARTMCDesc'="")&(Veobj.TARMCDesc'="")
		{
			if (ImportType=1)
			{
				///私有数据
				s flag=##class(web.DHCBL.CT.DHCTarMRCate).FormValidate("",Veobj.TARMCCode,Veobj.TARMCDesc,Veobj.LinkHospId)
				if (flag>0)
				{
					s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"TARMCCode")_"】"_Veobj.TARMCCode_"已存在，"
				}
			}
		}
		else
		{
			if ((Veobj.TARTMCCode'="")||(Veobj.TARMCCode'="")||(Veobj.TARTMCDesc'="")||(Veobj.TARMCDesc'="")) s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"TARTMCCode")_"】或【"_..GetFieldDescByName(ID,"TARMCCode")_"】有空值，"
		}
		; 8 新病案首页大类 新病案首页子类
		if (Veobj.NTARTMCCode'="")&(Veobj.NTARMCCode'="")&&(Veobj.NTARTMCDesc'="")&(Veobj.NTARMCDesc'="")
		{
			if (ImportType=1)
			{
				///私有数据
				s flag=##class(web.DHCBL.CT.DHCNewTarMRCate).FormValidate("",Veobj.NTARMCCode,Veobj.NTARMCDesc,Veobj.LinkHospId)
				if (flag>0)
				{
					s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"NTARMCCode")_"】"_Veobj.NTARMCCode_"已存在，"
				}
			}
		}
		else
		{
			if ((Veobj.NTARTMCCode'="")||(Veobj.NTARMCCode'="")||(Veobj.NTARTMCDesc'="")||(Veobj.NTARMCDesc'="")) s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"NTARTMCCode")_"】或【"_..GetFieldDescByName(ID,"NTARMCCode")_"】有空值，"
		}
	
		q myVresult
	}
	
	if (tablecode="ARC_ItmMast")  //检查检验治疗
	{
		s myVresult=""
		s MLength=$$$comMemberArrayGet("User.ARCItmMast",$$$cCLASSproperty,"ARCIMCode",$$$cPROPparameter,"MAXLEN")
		if $l(Veobj.ARCIMCode)>MLength s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"ARCIMCode")_"】长度不能超过"_MLength_"，"
		s MLength=$$$comMemberArrayGet("User.ARCItmMast",$$$cCLASSproperty,"ARCIMDesc",$$$cPROPparameter,"MAXLEN")
		if $l(Veobj.ARCIMDesc)>MLength s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"ARCIMDesc")_"】长度不能超过"_MLength_"，"
		if (Veobj.ARCIMDesc["^") s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"ARCIMDesc")_"】不能包含^，"
		s Price= ##class(web.DHCBL.BDP.FunLib).IsNonnegativeNumber(Veobj.TPPrice)
		IF Price=-1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"TPPrice")_"】有误，不是数字，"
		s OLTQty= ##class(web.DHCBL.BDP.FunLib).IsNonnegativeNumber(Veobj.OLTQty)
		IF OLTQty=-1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"OLTQty")_"】有误，不是数字，"
		//s HOSPID=$g(%session.Data("LOGON.HOSPID"))
		//s InsType= ##class(web.DHCBL.CT.DHCTarItem).GetDefPatInsType(HOSPID)
		//IF InsType="" s myVresult=myVresult_"【患者费别】没有查询到自费，"
		
		s Veobj.ARCIMEffDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(Veobj.ARCIMEffDate)
		//if (Veobj.ARCIMEffDate'="")&&(Veobj.ARCIMEffDate<+$h) s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"ARCIMEffDate")_"】不能早于今天，"
		s Veobj.TARIStartDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(Veobj.TARIStartDate)
		//if (Veobj.TARIStartDate'="")&&(Veobj.TARIStartDate<+$h) s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"TARIStartDate")_"】不能早于今天，"
		s Veobj.TPStartDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(Veobj.TPStartDate)
		//if (Veobj.TPStartDate'="")&&(Veobj.TPStartDate<+$h) s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"TPStartDate")_"】不能早于今天，"
		s Veobj.OLTStartDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(Veobj.OLTStartDate)
		//if (Veobj.OLTStartDate'="")&&(Veobj.OLTStartDate<+$h) s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"OLTStartDate")_"】不能早于今天，"
		//20170814 校验服务资源组数据有效性
		IF (Veobj.ARCIMServMaterial'="M")&&(Veobj.ARCIMServMaterial'="S")&&(Veobj.ARCIMServMaterial'="") s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"ARCIMServMaterial")_"】只能设置为S或者M或者空，"
		
		///2020-06-06 云HIS 校验医院
		s validStr= ##class(web.DHCBL.BDP.BDPMappingHOSP).ValidateHospId(tablename,Veobj.LinkHospId)  ///校验医院
		if (validStr'="")
		{
			s myVresult=myVresult_validStr
			q myVresult
		}
		if (ImportType=1)
		{
			///2021-06-07
			//s ARCIMRowId=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("ARC_ItmMast",Veobj.ARCIMCode,Veobj.LinkHospId)
			//20221101限制医嘱项不同院区的代码也不允许相同 HIS8.5.3
			s ARCIMRowId=##class(web.DHCBL.CT.ARCItmMast).GetRowIdByCode(Veobj.ARCIMCode)
			i (ARCIMRowId'="")
			{
				s Desc=$p($g(^ARCIM($p(ARCIMRowId,"||",1),$p(ARCIMRowId,"||",2),1)),"^",2)
				if (Desc'=Veobj.ARCIMDesc)
				{
					s myVresult=myVresult_"医嘱代码已存在，"
				}
			}
			else
			{
				s flag= ##class(web.DHCBL.CT.ARCItmMast).FormValidate("","",Veobj.ARCIMDesc,Veobj.LinkHospId)
				i (flag=1) s myVresult=myVresult_"医嘱名称已存在，"
				
			}
			s TARIRowId=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("DHC_TarItem",Veobj.TARICode,Veobj.LinkHospId)
			i (TARIRowId'="")
			{
				s Desc=$p($g(^DHCTARI(TARIRowId)),"^",2)
				if (Desc'=Veobj.TARIDesc)
				{
					s myVresult=myVresult_"收费代码已存在，"
				}
				if ($p($g(^DHCTARI(TARIRowId)),"^",3)'=Veobj.TARIUOM) s myVresult=myVresult_"收费项单位与数据库里的收费项单位不符"
			}
			else
			{
				s flag= ##class(web.DHCBL.CT.DHCTarItem).FormValidate("","",Veobj.TARIDesc,Veobj.LinkHospId)
				i (flag=1) s myVresult=myVresult_"收费名称已存在，"
				
			}
			
			//校验价格
			if TARIRowId'=""
			{
				s Date=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(Veobj.TPStartDate)
				s:Date="" Date=+$h
				s TPPrice=##class(web.DHCBL.BDP.BDPDataImport).GetTariPrice(TARIRowId,Veobj.LinkHospId,Date)
	   			i (+TPPrice'=+Veobj.TPPrice) s myVresult=myVresult_"收费项价格"_Veobj.TPPrice_" 与数据库里的收费项价格"_TPPrice_" 不符，"
			}
			
	
			If (ARCIMRowId'="")&&(TARIRowId'="")
			{
				s linkedflag=0
				s StartDate=0
		 		for 
		 		{
			 		s StartDate=$o(^DHCOLT(0,"ARTTA",ARCIMRowId,TARIRowId,StartDate)) q:StartDate="" 
			 		s linkid=0
			 		for
			 		{
				 		s linkid=$o(^DHCOLT(0,"ARTTA",ARCIMRowId,TARIRowId,StartDate,linkid)) q:linkid="" 
				 		s EndDate=$p($g(^DHCOLT(linkid)),"^",5)
				 		if ((EndDate>=Veobj.OLTStartDate)||(EndDate="")) s linkedflag=1
			 		}
		 		}
				if (linkedflag=1) s myVresult=myVresult_"医嘱项与该收费项目已经关联，"
				
			}
		}
		
		q myVresult
	}
	
	if (tablecode="PHC_DrgMast")
	{
		s myVresult=""
		s MLength=$$$comMemberArrayGet("User.PHCDrgMast",$$$cCLASSproperty,"PHCDCode",$$$cPROPparameter,"MAXLEN")
		if $l(Veobj.INCICode)>MLength s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"INCICode")_"】长度不能超过"_MLength_"，"
		s MLength=$$$comMemberArrayGet("User.PHCDrgMast",$$$cCLASSproperty,"PHCDName",$$$cPROPparameter,"MAXLEN")
		if $l(Veobj.INCIDesc)>MLength s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"INCIDesc")_"】长度不能超过"_MLength_"，"
		if (Veobj.INCIDesc["^") s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"INCIDesc")_"】不能包含^，"
		s Price= ##class(web.DHCBL.BDP.FunLib).IsNonnegativeNumber(Veobj.Sp)
		IF Price=-1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"Sp")_"】有误，不是数字，"
		
		s Price= ##class(web.DHCBL.BDP.FunLib).IsNonnegativeNumber(Veobj.Rp)
		IF Price=-1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"Rp")_"】有误，不是数字，"
		
		if Veobj.INFOMaxSp'=""
		{
			s Price= ##class(web.DHCBL.BDP.FunLib).IsNonnegativeNumber(Veobj.INFOMaxSp)
			IF Price=-1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"INFOMaxSp")_"】有误，不是数字，"
		}
		if Veobj.INFOPbRp'=""
		{
		
			s Price= ##class(web.DHCBL.BDP.FunLib).IsNonnegativeNumber(Veobj.INFOPbRp)
			IF Price=-1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"INFOPbRp")_"】有误，不是数字，"
		
		}
		/*if (Veobj.INFORemark'="")&&(Veobj.INFORemark'["-")
		{
			s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"INFORemark")_"】需以 - 分隔，"
		
		}*/
		if (ImportType=1)
		{
			
			///原来是一对一
			s flag=##class(web.BDPExt.YPBLL).FormValidate(Veobj.INCICode,"")
			i flag=1 s myVresult=myVresult_"代码在【药品】中已存在，"
			s flag=##class(web.BDPExt.YPBLL).FormValidate("",Veobj.INCIDesc)
			i flag=1 s myVresult=myVresult_"描述在【药品】中已存在，"	
			
			
			
			///原来是一对一
			s flag=##class(web.DHCBL.CT.ARCItmMast).FormValidate("",Veobj.INCICode,"")
			i flag=1 s myVresult=myVresult_ "代码在【医嘱项】中已存在，"
			s flag=##class(web.DHCBL.CT.ARCItmMast).FormValidate("","",Veobj.INCIDesc)
			i flag=1 s myVresult=myVresult_"描述在【医嘱项】中已存在，"	
			
			
			
			s flag=##class(web.BDPExt.WZBLL).FormValidate(Veobj.INCICode,"")
			i flag=1 s myVresult=myVresult_"代码在【库存项】中已存在，"
			s flag=##class(web.BDPExt.WZBLL).FormValidate("",Veobj.INCIDesc)
			i flag=1 s myVresult=myVresult_"描述在【库存项】中已存在，"
			
			
			
			s flag=##class(web.DHCBL.CT.DHCTarItem).FormValidate("",Veobj.INCICode,"")
			i flag=1 s myVresult=myVresult_"代码在【收费项】中已存在，"
			s flag=##class(web.DHCBL.CT.DHCTarItem).FormValidate("","",Veobj.INCIDesc)
			i flag=1 s myVresult=myVresult_"描述在【收费项】中已存在，"
		}
		i Veobj.INCICTUOMPurchDR="" s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"INCICTUOMPurchDR")_"】为必填项，"
		i Veobj.INCICTUOMDR="" s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"INCICTUOMDR")_"】为必填项，"
		i Veobj.INCICTUOMPurchFac="" s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"INCICTUOMPurchFac")_"】为必填项，"
		i (Veobj.INCICTUOMPurchFac'="")&(Veobj.INCICTUOMPurchDR'="")&(Veobj.INCICTUOMDR'="")
		{
			S FacFlag=##class(web.BDPExt.UomBLL).IsExisted(Veobj.INCICTUOMPurchDR,Veobj.INCICTUOMDR,Veobj.INCICTUOMPurchFac)
			if FacFlag=1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"INCICTUOMPurchDR")_"】和【"_..GetFieldDescByName(ID,"INCICTUOMDR")_"】转换关系不存在，"
			if FacFlag=2 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"INCICTUOMPurchFac")_"】校验失败，"		
		}
		
		
		//2018-03-26
		if (Veobj.PHCDFCHPhSpecInstr'="")
		{
			s validret=##class(web.DHCST.Tools.InputDrugBasicData).validCHPhSpecInstr(Veobj.PHCDFCHPhSpecInstr)
			i validret<0 d
			.i validret=-1 s myVresult=myVresult_"【草药备注】字典不存在，"
			.e  i validret=-2 s myVresult=myVresult_"【草药备注】"_Veobj.PHCDFCHPhSpecInstr_"不存在，"
		}
	
		i Veobj.ARCIMBillingUOMDR="" s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"ARCIMBillingUOMDR")_"】为必填项，"
		i Veobj.INCICTUOMDR="" s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"INCICTUOMDR")_"】为必填项，"
		i Veobj.ARCIMBillingUOMFac="" s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"ARCIMBillingUOMFac")_"】为必填项，"
		i (Veobj.ARCIMBillingUOMFac'="")&(Veobj.ARCIMBillingUOMDR'="")&(Veobj.INCICTUOMDR'="")
		{
			S FacFlag=##class(web.BDPExt.UomBLL).IsExisted(Veobj.ARCIMBillingUOMDR,Veobj.INCICTUOMDR,Veobj.ARCIMBillingUOMFac)
			if FacFlag=1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"ARCIMBillingUOMDR")_"】和【"_..GetFieldDescByName(ID,"INCICTUOMDR")_"】转换关系不存在，"
			if FacFlag=2 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"ARCIMBillingUOMFac")_"】校验失败，"		
		}
		///2018-04-23 增加对药理学分类的校验
		s dhcphccat=""
		s phccatstr=Veobj.DHCPHCCat1_"^"_Veobj.DHCPHCCat2_"^"_Veobj.DHCPHCCat3_"^"_Veobj.DHCPHCCat4_"^"_Veobj.DHCPHCCat5_"^"_Veobj.DHCPHCCat6_"^"_Veobj.DHCPHCCat7
		s validret=##class(web.DHCST.Tools.InputDrugBasicData).validPhcCat(phccatstr)
		i validret<0
		{
			s myVresult=myVresult_"药学"_(-validret-3200)_"级分类不存在"
		}
		///2018-05-03 增加对别名的校验
		s INCALIAS=$tr(Veobj.INCALIAS," ","")
		if (INCALIAS'="")
		{
			s Len=$l(INCALIAS,"/")
		    f i=1:1:Len
		    {
		   		s alias=$p(INCALIAS,"/",i)
		   		s MLength=$$$comMemberArrayGet("User.INCALIAS",$$$cCLASSproperty,"INCATEXT",$$$cPROPparameter,"MAXLEN")
				if $l(alias)>MLength s myVresult="【"_..GetFieldDescByName(ID,"Alias")_"】超长，"
				s MLength=$$$comMemberArrayGet("User.ARCAlias",$$$cCLASSproperty,"ALIASText",$$$cPROPparameter,"MAXLEN")
				if $l(alias)>MLength s myVresult="【"_..GetFieldDescByName(ID,"Alias")_"】超长，"
		    	if $$ALPHAUP^SSUTIL4(alias)="" 
		    	{
			    	s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"INCALIAS")_"】"_Veobj.INCALIAS_" 校验失败，"	
			    	q 
		    	}
		    }
		}
		else
		{
			s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"INCALIAS")_"】为必填项，"	
		}
		
		q myVresult
		
	}
	///收费项目 add@2017-1-2
	if (tablecode="DHC_TarItem")
	{
		s myVresult=""
		s MLength=$$$comMemberArrayGet("User.DHCTarItem",$$$cCLASSproperty,"TARICode",$$$cPROPparameter,"MAXLEN")
		if $l(Veobj.TARICode)>MLength s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"TARICode")_"】长度不能超过"_MLength_"，"
		s MLength=$$$comMemberArrayGet("User.DHCTarItem",$$$cCLASSproperty,"TARIDesc",$$$cPROPparameter,"MAXLEN")
		if $l(Veobj.TARIDesc)>MLength s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"TARIDesc")_"】长度不能超过"_MLength_"，"
		if (Veobj.TARIDesc["^") s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"TARIDesc")_"】不能包含^，"
		///2020-06-06 云HIS 校验医院
		s validStr= ##class(web.DHCBL.BDP.BDPMappingHOSP).ValidateHospId(tablename,Veobj.LinkHospId)  ///校验医院
		if (validStr'="")
		{
			s myVresult=myVresult_validStr
			q myVresult
		}
		if (ImportType=1)
		{
			s flag=##class(web.DHCBL.CT.DHCTarItem).FormValidate("",Veobj.TARICode,"",Veobj.LinkHospId)
			i flag=1 s myVresult=myVresult_"代码在【收费项】中已存在，"
			s flag=##class(web.DHCBL.CT.DHCTarItem).FormValidate("","",Veobj.TARIDesc,Veobj.LinkHospId)
			i flag=1 s myVresult=myVresult_"描述在【收费项】中已存在，"
		}
		
		//s HOSPID=$g(%session.Data("LOGON.HOSPID"))
		//s InsType= ##class(web.DHCBL.CT.DHCTarItem).GetDefPatInsType(HOSPID)
		//IF InsType="" s myVresult=myVresult_"【患者费别】没有查询到自费，"
		s:Veobj.TARIStartDate'="" Veobj.TARIStartDate = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(Veobj.TARIStartDate)
		s:Veobj.TARIEndDate'="" Veobj.TARIEndDate = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(Veobj.TARIEndDate)
		/*
		if (Veobj.TARIStartDate'="")&&(Veobj.TARIStartDate<+$h) s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"TARIStartDate")_"】不能早于今天，"
		if (Veobj.TARIEndDate'="")&&(Veobj.TARIEndDate<+$h) s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"TARIEndDate")_"】不能早于今天，"
		*/
		if (Veobj.TARIStartDate'="")&&(Veobj.TARIEndDate'="")&&(Veobj.TARIStartDate>Veobj.TARIEndDate) s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"TARIEndDate")_"】不能早于【"_..GetFieldDescByName(ID,"TARIStartDate")_"】，"
		

		s PriceFlag= ##class(web.DHCBL.BDP.FunLib).IsNonnegativeNumber(Veobj.TPPrice)
		IF PriceFlag=-1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"TPPrice")_"】有误，"
		
		s PriceFlag= ##class(web.DHCBL.BDP.FunLib).IsNonnegativeNumber(Veobj.TPAlterPrice1)
		IF PriceFlag=-1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"TPAlterPrice1")_"】有误，"
		
		s PriceFlag= ##class(web.DHCBL.BDP.FunLib).IsNonnegativeNumber(Veobj.TPAlterPrice2)
		IF PriceFlag=-1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"TPAlterPrice2")_"】有误，"	
		
	}
	///收费项目调价 add@2017-1-2
	if (tablecode="DHC_TarItemPrice")
	{
		s myVresult=""
		s MLength=$$$comMemberArrayGet("User.DHCTarItem",$$$cCLASSproperty,"TARICode",$$$cPROPparameter,"MAXLEN")
		if $l(Veobj.TARICode)>MLength s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"TARICode")_"】长度不能超过"_MLength_"，"
		s MLength=$$$comMemberArrayGet("User.DHCTarItem",$$$cCLASSproperty,"TARIDesc",$$$cPROPparameter,"MAXLEN")
		if $l(Veobj.TARIDesc)>MLength s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"TARIDesc")_"】长度不能超过"_MLength_"，"
		///2020-06-06 云HIS 校验医院
		s validStr= ##class(web.DHCBL.BDP.BDPMappingHOSP).ValidateHospId(tablename,Veobj.TPHospitalDR)  ///校验医院
		if (validStr'="")
		{
			s myVresult=myVresult_validStr
			q myVresult
		}
		//s TARIRowId=$o(^DHCTARI(0,"Code",Veobj.TARICode,0)) 
		s TARIRowId=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("DHC_TarItem",Veobj.TARICode,Veobj.TPHospitalDR)
		if TARIRowId=""
		{
			s myVresult=myVresult_"没有找到【"_..GetFieldDescByName(ID,"TARICode")_"】对应的收费项数据，"	
		}
		else
		{
			s TARIDesc=$p($g(^DHCTARI(TARIRowId)),"^",2)
			if TARIDesc'=Veobj.TARIDesc s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"TARICode")_"】与【"_..GetFieldDescByName(ID,"TARIDesc")_"】不一致，"	
			s TARIUOM=$p($g(^DHCTARI(TARIRowId)),"^",3)
			if TARIUOM'=Veobj.TARIUOM s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"TARICode")_"】与【"_..GetFieldDescByName(ID,"TARIUOM")_"】不一致，"		
		}
		s TPStartDate="",TPEndDate=""	
		s:Veobj.TPStartDate'="" Veobj.TPStartDate = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(Veobj.TPStartDate)
		s:Veobj.TPEndDate'="" Veobj.TPEndDate = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(Veobj.TPEndDate)
		
		if (Veobj.TPStartDate'="")&&(Veobj.TPStartDate<+$h) s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"TPStartDate")_"】不能早于今天，"
		if (Veobj.TPEndDate'="")&&(Veobj.TPEndDate<+$h) s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"TPEndDate")_"】不能早于今天，"
		if (Veobj.TPStartDate'="")&&(Veobj.TPEndDate'="")&&(Veobj.TPStartDate>Veobj.TPEndDate) s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"TPEndDate")_"】不能早于【"_..GetFieldDescByName(ID,"TPStartDate")_"】，"


		s PriceFlag= ##class(web.DHCBL.BDP.FunLib).IsNonnegativeNumber(Veobj.TPPrice)
		IF PriceFlag=-1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"TPPrice")_"】有误，"
		
		s PriceFlag= ##class(web.DHCBL.BDP.FunLib).IsNonnegativeNumber(Veobj.TPAlterPrice1)
		IF PriceFlag=-1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"TPAlterPrice1")_"】有误，"
		
		s PriceFlag= ##class(web.DHCBL.BDP.FunLib).IsNonnegativeNumber(Veobj.TPAlterPrice2)
		IF PriceFlag=-1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"TPAlterPrice2")_"】有误，"	
		
		q myVresult
	}
	
	
	/*
	///收费项目调价 add@2018-07-11
	if (tablecode="DHC_TarItemPriceHBCZRM")
	{
		s myVresult=""
		if (Veobj.TARIExternalCode'="")
		{
			s existflag=0
			s id=0
			for
			{
				s id=$o(^DHCTARI(0,"ASC",Veobj.TARIExternalCode,id)) q:id=""
				s existflag=existflag+1
				s tarprice=##class(web.DHCBL.BDP.BDPDataImport).GetTariPrice(id,Veobj.TPHospitalDR,"")
				if existflag=1 s ^tmpimporttari(Veobj.TARIExternalCode)=tarprice
				if existflag>1
				{
					if tarprice'=$g(^tmpimporttari(Veobj.TARIExternalCode)) s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"TARIExternalCode")_"】对应的收费项数据有多条，且价格不一致，"	
				}		
			}
			k ^tmpimporttari(Veobj.TARIExternalCode)
			if (existflag=0)
			{
				s myVresult=myVresult_"没有找到与【"_..GetFieldDescByName(ID,"TARIExternalCode")_"】对应的收费项数据，"	
			}
		}
		else
		{
			s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"TARIExternalCode")_"】不能为空，"
		}
		
		s PriceFlag= ##class(web.DHCBL.BDP.FunLib).IsNonnegativeNumber(Veobj.TPPrice)
		IF PriceFlag=-1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"TPPrice")_"】有误，不是数字，"
		s:Veobj.TPStartDate'="" Veobj.TPStartDate = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(Veobj.TPStartDate)
		if (Veobj.TPStartDate'="")&&(Veobj.TPStartDate<=+$h) s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"TPStartDate")_"】不能早于或等于今天，"
		q myVresult
	}*/
	///材料/物资 
	if ($zcvt(tablecode,"U")="INC_ITM")
	{
		s myVresult=""
		s MLength=$$$comMemberArrayGet("User.INCItm",$$$cCLASSproperty,"INCICode",$$$cPROPparameter,"MAXLEN")
		if $l(Veobj.Code)>MLength s myVresult="【"_..GetFieldDescByName(ID,"Code")_"】长度不能超过"_MLength_"，"
		s MLength=$$$comMemberArrayGet("User.INCItm",$$$cCLASSproperty,"INCIDesc",$$$cPROPparameter,"MAXLEN")
		if $l(Veobj.Desc)>MLength s myVresult="【"_..GetFieldDescByName(ID,"Desc")_"】长度不能超过"_MLength_"，"
		if (Veobj.Desc["^") s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"Desc")_"】不能包含^，"
		if ($ZCVT(Veobj.Charge,"U")'="N")&($ZCVT(Veobj.Charge,"U")'="Y")
		{
			s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"Charge")_"】需要设置为Y/N，"
		}
		
		//s HOSPID=$g(%session.Data("LOGON.HOSPID"))
		//s InsType= ##class(web.DHCBL.CT.DHCTarItem).GetDefPatInsType(HOSPID)
		//IF InsType="" s myVresult=myVresult_"【患者费别】没有查询到自费，"
		
		s Price= ##class(web.DHCBL.BDP.FunLib).IsNonnegativeNumber(Veobj.SP)
		IF Price=-1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"SP")_"】有误，不是数字，"
		
		s Price= ##class(web.DHCBL.BDP.FunLib).IsNonnegativeNumber(Veobj.RP)
		IF Price=-1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"RP")_"】有误，不是数字，"
		
		s Price= ##class(web.DHCBL.BDP.FunLib).IsNonnegativeNumber(Veobj.PbRP)
		IF Price=-1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"PbRP")_"】有误，不是数字，"
		
		///2020-06-06 云HIS 校验医院
		s validStr= ##class(web.DHCBL.BDP.BDPMappingHOSP).ValidateHospId(tablename,Veobj.LinkHospId)  ///校验医院
		if (validStr'="")
		{
			s myVresult=myVresult_validStr
			q myVresult
		}
		
		if (ImportType=1)
		{
			
			s flag=##class(web.BDPExt.WZBLL).FormValidate(Veobj.Code,Veobj.Desc,Veobj.LinkHospId)
			i (flag=1) s myVresult=myVresult_"【库存项】代码或描述已存在，"		
			
		}
		
		i Veobj.BUom="" s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"BUom")_"】为必填项，"
		i Veobj.Factor="" s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"Factor")_"】为必填项，"
		i Veobj.PUom="" s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"PUom")_"】为必填项，"
		i (Veobj.Factor'="")&(Veobj.PUom'="")&(Veobj.BUom'="")
		{
			S FacFlag=##class(web.BDPExt.UomBLL).IsExisted(Veobj.PUom,Veobj.BUom,Veobj.Factor)
			//if FacFlag=1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"PUom")_"】和【"_..GetFieldDescByName(ID,"BUom")_"】转换关系不存在，"
			if FacFlag=2 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"Factor")_"】校验失败，"		
		}
		
		if ($ZCVT(Veobj.Charge,"U")="Y")
		{
			i Veobj.ARCIMCode="" s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"ARCIMCode")_"】为必填项，"
			i Veobj.ARCIMDesc="" s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"ARCIMDesc")_"】为必填项，"
			i (Veobj.ARCIMDesc["^") s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"ARCIMDesc")_"】不能包含^，"
			i Veobj.ALIASText="" s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"ALIASText")_"】为必填项，"
			
			i Veobj.TARICode="" s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"TARICode")_"】为必填项，"
			i Veobj.TARIDesc="" s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"TARIDesc")_"】为必填项，"
			i (Veobj.TARIDesc["^") s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"TARIDesc")_"】不能包含^，"
			i Veobj.TARIALIAS="" s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"TARIALIAS")_"】为必填项，"
			i Veobj.Onitsown="" s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"Onitsown")_"】为必填项，"
			i Veobj.Wostock="" s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"Wostock")_"】为必填项，"
			i Veobj.TPPatInsType="" s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"TPPatInsType")_"】为必填项，"
			i Veobj.FeeUom="" s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"FeeUom")_"】为必填项，"
			i Veobj.OrdSubCat="" s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"OrdSubCat")_"】为必填项，"
			i Veobj.BillSubCat="" s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"BillSubCat")_"】为必填项，"
			i Veobj.TarSubCat="" s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"TarSubCat")_"】为必填项，"
			i Veobj.InpaSubCat="" s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"InpaSubCat")_"】为必填项，"
			i Veobj.OutpaSubCat="" s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"OutpaSubCat")_"】为必填项，"
			i Veobj.EmSubCat="" s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"EmSubCat")_"】为必填项，"
			i Veobj.AcctSubCat="" s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"AcctSubCat")_"】为必填项，"
			i Veobj.MrSubCat="" s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"MrSubCat")_"】为必填项，"
			i Veobj.MrSubCatNew="" s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"MrSubCatNew")_"】为必填项，"
			i Veobj.FeeUomFac="" s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"FeeUomFac")_"】为必填项，"
			i (Veobj.FeeUomFac'="")&(Veobj.FeeUom'="")&(Veobj.BUom'="")
			{
				S FacFlag=##class(web.BDPExt.UomBLL).IsExisted(Veobj.FeeUom,Veobj.BUom,Veobj.FeeUomFac)
				//if FacFlag=1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"FeeUom")_"】和【"_..GetFieldDescByName(ID,"BUom")_"】转换关系不存在，"
				if FacFlag=2 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"FeeUomFac")_"】校验失败，"		
			}
			if (ImportType=1)
			{	
				s flag=##class(web.DHCBL.CT.ARCItmMast).FormValidate("",Veobj.Code,Veobj.Desc,Veobj.LinkHospId)
				i flag=1 s myVresult=myVresult_ "【医嘱项】代码或描述已存在，"
				
				s flag=##class(web.DHCBL.CT.DHCTarItem).FormValidate("",Veobj.TARICode,Veobj.TARIDesc,Veobj.LinkHospId)
				i flag=1 s myVresult=myVresult_"【收费项】代码或描述已存在，"
			}
		}
		i Veobj.Manf'="" //厂商
		{
			 s MANFRowid=$o(^DHCMANF(0,"MANF",Veobj.Manf,0))  //2021-01-04校验类型
			if MANFRowid'=""
			{
				s MANFType=$p($g(^DHCMANF(MANFRowid)),"^",7)
				if MANFType'="M" s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"Manf")_"】类型不是M，"
				
			}
		}
		i Veobj.Vendor'=""  //供应商
		{
			s APCVMType=$p($g(^APC("APCVM",Veobj.Vendor)),"^",9)  //2021-01-04 校验类型
			if APCVMType'="M" s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"Vendor")_"】类型不是M，"
		}
		
		i Veobj.Origin'=""  //产地
		{
			s OrigType=$p($g(^DHCSTORI(Veobj.Origin)),"^",3)  //2021-01-04 校验类型
			if OrigType'="M" s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"Origin")_"】类型不是M，"
		}
		
		i Veobj.Carrier'=""  // 配送商
		{
			s CAType=$p($g(^DHCCARR(Veobj.Carrier)),"^",3)  //2021-01-04 校验类型
			if CAType'="M" s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"Carrier")_"】类型不是M，"
		}
		///2018-05-03 增加对别名的校验
		s Veobj.Alias=$tr(Veobj.Alias," ","")
		if (Veobj.Alias'="")
		{
			s Len=$l(Veobj.Alias,"/")
		    f i=1:1:Len
		    {
		   		s alias=$p(Veobj.Alias,"/",i)
		   		s MLength=$$$comMemberArrayGet("User.INCALIAS",$$$cCLASSproperty,"INCATEXT",$$$cPROPparameter,"MAXLEN")
				if $l(alias)>MLength s myVresult="【"_..GetFieldDescByName(ID,"Alias")_"】超长，"
				s MLength=$$$comMemberArrayGet("User.ARCAlias",$$$cCLASSproperty,"ALIASText",$$$cPROPparameter,"MAXLEN")
				if $l(alias)>MLength s myVresult="【"_..GetFieldDescByName(ID,"Alias")_"】超长，"
		    	if $$ALPHAUP^SSUTIL4(alias)="" 
		    	{
			    	s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"Alias")_"】"_Veobj.Alias_" 校验失败，"	
			    	q 
		    	}
		    }
		}
		else
		{
			s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"Alias")_"】为必填项，"
		}
		
		q myVresult
		
	}
	
	
	if (tablecode="CT_Country")  //国家
	{
		s MLength=$$$comMemberArrayGet("User.CTCountry",$$$cCLASSproperty,"CTCOUCode",$$$cPROPparameter,"MAXLEN")
		if $l(Veobj.CTCOUCode)>MLength s myVresult="【"_..GetFieldDescByName(ID,"CTCOUCode")_"】长度不能超过"_MLength_"，"
		if (ImportType=1)
		{
			s flag=##class(web.DHCBL.CT.CTCountry).FormValidate(Veobj.CTCOURowId,Veobj.CTCOUCode,"")
			i flag=1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"CTCOUCode")_"】已存在，"
			s flag=##class(web.DHCBL.CT.CTCountry).FormValidate(Veobj.CTCOURowId,"",Veobj.CTCOUDesc)
			i flag=1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"CTCOUDesc")_"】已存在，"
		
		}
		q myVresult
		
	}
	if (tablecode="CT_Region") //区域
	{
		s MLength=$$$comMemberArrayGet("User.CTRegion",$$$cCLASSproperty,"CTRGCode",$$$cPROPparameter,"MAXLEN")
		if $l(Veobj.CTRGCode)>MLength s myVresult="【"_..GetFieldDescByName(ID,"CTRGCode")_"】长度不能超过"_MLength_"，"
		if (ImportType=1)
		{
			s flag=##class(web.DHCBL.CT.CTRegion).FormValidate(Veobj.CTRGRowId,Veobj.CTRGCode,"")
			i flag=1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"CTRGCode")_"】已存在，"
			s flag=##class(web.DHCBL.CT.CTRegion).FormValidate(Veobj.CTRGRowId,"",Veobj.CTRGDesc)
			i flag=1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"CTRGDesc")_"】已存在，"
		}
		q myVresult
	}
	if (tablecode="CT_Province") //省
	{
		s MLength=$$$comMemberArrayGet("User.CTProvince",$$$cCLASSproperty,"PROVCode",$$$cPROPparameter,"MAXLEN")
		if $l(Veobj.PROVCode)>MLength s myVresult="【"_..GetFieldDescByName(ID,"PROVCode")_"】长度不能超过"_MLength_"，"
		if (ImportType=1)
		{
			s flag=##class(web.DHCBL.CT.CTProvince).FormValidate(Veobj.PROVRowId,Veobj.PROVCode,"")
			i flag=1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"PROVCode")_"】已存在，"
			s flag=##class(web.DHCBL.CT.CTProvince).FormValidate(Veobj.PROVRowId,"",Veobj.PROVDesc)
			i flag=1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"PROVDesc")_"】已存在，"	
		}
		q myVresult
	}
	if (tablecode="CT_City") //城市
	{
		s MLength=$$$comMemberArrayGet("User.CTCity",$$$cCLASSproperty,"CTCITCode",$$$cPROPparameter,"MAXLEN")
		if $l(Veobj.CTCITCode)>MLength s myVresult="【"_..GetFieldDescByName(ID,"CTCITCode")_"】长度不能超过"_MLength_"，"
		if (ImportType=1)
		{
			s flag=##class(web.DHCBL.CT.CTCity).FormValidate(Veobj.CTCITRowId,Veobj.CTCITCode,"")
			i flag=1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"CTCITCode")_"】已存在，"
			///20170704修改城市校验，城市描述和省份一起校验不能重复，不同省份下描述可以重复
			if Veobj.CTCITProvinceDR'=""
			{
				s flag=##class(web.DHCBL.CT.CTCity).FormValidate(Veobj.CTCITRowId,"",Veobj.CTCITDesc,Veobj.CTCITProvinceDR)
				i flag=1 s myVresult=myVresult_"同一省份下【"_..GetFieldDescByName(ID,"CTCITDesc")_"】已存在，"	
			}
		}
		q myVresult
	}
	if (tablecode="CT_CityArea")  //城市区域
	{
		s MLength=$$$comMemberArrayGet("User.CTCityArea",$$$cCLASSproperty,"CITAREACode",$$$cPROPparameter,"MAXLEN")
		if $l(Veobj.CITAREACode)>MLength s myVresult="【"_..GetFieldDescByName(ID,"CITAREACode")_"】长度不能超过"_MLength_"，"
		if (ImportType=1)
		{
			s flag=##class(web.DHCBL.CT.CTCityArea).FormValidate(Veobj.CITAREARowId,Veobj.CITAREACode,"","")
			if flag=1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"CITAREACode")_"】已存在，"
			///20170704
			if (Veobj.CITAREACityDR'="")
			{
				s flag=##class(web.DHCBL.CT.CTCityArea).FormValidate(Veobj.CITAREARowId,"",Veobj.CITAREADesc,Veobj.CITAREACityDR)
				if flag=1 s myVresult =myVresult_"同一城市下【"_..GetFieldDescByName(ID,"CITAREADesc")_"】已存在，"
			}
			
		}
		
		q myVresult
	}
	if (tablecode="CT_Zip") //邮编
	{
		s MLength=$$$comMemberArrayGet("User.CTZip",$$$cCLASSproperty,"CTZIPCode",$$$cPROPparameter,"MAXLEN")
		if $l(Veobj.CTZIPCode)>MLength s myVresult="【"_..GetFieldDescByName(ID,"CTZIPCode")_"】长度不能超过"_MLength_"，"
		if (ImportType=1)
		{			
			s flag=##class(web.DHCBL.CT.CTZip).FormValidate(Veobj.CTZIPRowId,Veobj.CTZIPCode,Veobj.CTZIPDesc)
			i flag=1 s myVresult=myVresult_"代码和描述已存在，"
		}
		q myVresult
	}
	if (tablecode="CT_LocalityType") ///街道
	{
		s MLength=$$$comMemberArrayGet("User.CTLocalityType",$$$cCLASSproperty,"LOCTYPECode",$$$cPROPparameter,"MAXLEN")
		if $l(Veobj.LOCTYPECode)>MLength s myVresult="【"_..GetFieldDescByName(ID,"LOCTYPECode")_"】长度不能超过"_MLength_"，"
		if (ImportType=1)
		{
			s flag=##class(web.DHCBL.CT.CTLocalityType).FormValidate(Veobj.LOCTYPERowId,Veobj.LOCTYPECode)
			i flag=1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"LOCTYPECode")_"】已存在，"
		}
		q myVresult
	}
	
	if (tablecode="CT_Community")  //社区
	{
		s MLength=$$$comMemberArrayGet("User.CTCommunity",$$$cCLASSproperty,"CTCMUNTCode",$$$cPROPparameter,"MAXLEN")
		if $l(Veobj.CTCMUNTCode)>MLength s myVresult="【"_..GetFieldDescByName(ID,"CTCMUNTCode")_"】长度不能超过"_MLength_"，"
		if (ImportType=1)
		{	
			s flag=##class(web.DHCBL.CT.CTCommunity).FormValidate(Veobj.CTCMUNTRowId,Veobj.CTCMUNTCode)
			i flag=1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"CTCMUNTCode")_"】已存在，"
		}
		q myVresult
	}
	if (tablecode="CT_Address")  //2
	{
		s MLength=$$$comMemberArrayGet("User.CTAddress",$$$cCLASSproperty,"CTADDCode",$$$cPROPparameter,"MAXLEN")
		if $l(Veobj.CTADDCode)>MLength s myVresult="【"_..GetFieldDescByName(ID,"CTADDCode")_"】长度不能超过"_MLength_"，"
		if (ImportType=1)
		{
			s flag=##class(web.DHCBL.CT.CTAddress).FormValidate(Veobj.CTADDRowId,Veobj.CTADDCode)
			i flag=1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"CTADDCode")_"】已存在，"
		}
		q myVresult
	}
	
	if (tablecode="CT_Occupation")
	{
		s MLength=$$$comMemberArrayGet("User.CTOccupation",$$$cCLASSproperty,"CTOCCCode",$$$cPROPparameter,"MAXLEN")
		if $l(Veobj.CTOCCCode)>MLength s myVresult="【"_..GetFieldDescByName(ID,"CTOCCCode")_"】长度不能超过"_MLength_"，"
		if (ImportType=1)
		{
			s flag=##class(web.DHCBL.CT.CTOccupation).FormValidate(Veobj.CTOCCRowId,Veobj.CTOCCCode,"")
			i flag=1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"CTOCCCode")_"】已存在，"
			s flag=##class(web.DHCBL.CT.CTOccupation).FormValidate(Veobj.CTOCCRowId,"",Veobj.CTOCCDesc)
			i flag=1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"CTOCCDesc")_"】已存在，"
		}
		q myVresult
	}
	
	if (tablecode="PHC_Form")
	{
		s MLength=$$$comMemberArrayGet("User.PHCForm",$$$cCLASSproperty,"PHCFCode",$$$cPROPparameter,"MAXLEN")
		if $l(Veobj.PHCFCode)>MLength s myVresult="【"_..GetFieldDescByName(ID,"PHCFCode")_"】长度不能超过"_MLength_"，"
		if (ImportType=1)
		{
			s flag=##class(web.DHCBL.CT.PHCForm).FormValidate(Veobj.PHCFRowId,Veobj.PHCFCode,"")
			i flag=1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"PHCFCode")_"】已存在，"
			s flag=##class(web.DHCBL.CT.PHCForm).FormValidate(Veobj.PHCFRowId,"",Veobj.PHCFDesc)
			i flag=1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"PHCFDesc")_"】已存在，"
		}
		q myVresult
	}	
	if (tablecode="Uom")
	{
		if (Veobj.CTCFFrUOM="") q "【"_..GetFieldDescByName(ID,"CTCFFrUOM")_"】为必填项，"
		IF (Veobj.CTCFToUOM)="" q "【"_..GetFieldDescByName(ID,"CTCFToUOM")_"】为必填项，"
		s MLength=$$$comMemberArrayGet("User.CTUOM",$$$cCLASSproperty,"CTUOMCode",$$$cPROPparameter,"MAXLEN")
		if $l(Veobj.CTCFFrUOM)>MLength s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"CTCFFrUOM")_"】长度不能超过"_MLength_"，"
		if $l(Veobj.CTCFToUOM)>MLength s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"CTCFToUOM")_"】长度不能超过"_MLength_"，"
		
		//单位转换 重复校验
		if (ImportType=1)
		{
			s FrRowID=$o(^CT("UOM",0,"Code",$ZCVT(Veobj.CTCFFrUOM,"u"),0))  //##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByDesc("CT_UOM",Veobj.CTCFFrUOM)    //
			s ToRowID=$o(^CT("UOM",0,"Code",$ZCVT(Veobj.CTCFToUOM,"u"),0))  //##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByDesc("CT_UOM",Veobj.CTCFToUOM)   //
			if (FrRowID'="")&(ToRowID'="")
			{
				s flag= ##class(web.DHCBL.CT.CTConFac).FormValidate(Veobj.CTCFRowId,FrRowID,ToRowID)
				if flag=1 s myVresult=myVresult_"单位转换数据已存在，"
			}
		}
		//转换系数不全是数字或者是为0时，校验失败
		if (Veobj.CTCFFactor=0)||(Veobj.CTCFFactor="")
		{
			s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"CTCFFactor")_"】不是有效数字，"
		}
		else
		{
			//2019-10-18 考虑小数 （中草药）
			//  (Veobj.CTCFFactor'?1n.n)||
			s validflag= ##class(web.BDPExt.UomBLL).FactorValidate(Veobj.CTCFFrUOM,Veobj.CTCFToUOM,Veobj.CTCFFactor)
			if validflag'=1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"CTCFFactor")_"】校验失败，"
		}
		
		q myVresult
	}
	if (tablecode="Freq")
	{
		
		s myVresult=""
		s MLength=$$$comMemberArrayGet("User.PHCFreq",$$$cCLASSproperty,"PHCFRCode",$$$cPROPparameter,"MAXLEN")
		if $l(Veobj.PHCFRCode)>MLength s myVresult="【"_..GetFieldDescByName(ID,"PHCFRCode")_"】长度不能超过"_MLength_"，"
		s myVresult=""
		if (ImportType=1)
		{
			s flag=##class(web.DHCBL.CT.PHCFreq).FormValidate(Veobj.PHCFRRowId,Veobj.PHCFRCode,"")
			i flag=1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"PHCFRCode")_"】已存在，"
			s flag=##class(web.DHCBL.CT.PHCFreq).FormValidate(Veobj.PHCFRRowId,"",Veobj.PHCFRDesc1)
			i flag=1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"PHCFRDesc1")_"】已存在，"	
		}
		if (Veobj.PHCFRFactor'="")&&((Veobj.PHCFRFactor'?1n.n)||(Veobj.PHCFRFactor=0)) s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"PHCFRFactor")_"】校验失败，"
		s Veobj.PHCFRIntervalUom=$case(Veobj.PHCFRIntervalUom,"天":"D","小时":"H",:Veobj.PHCFRIntervalUom)
		S:(Veobj.PHCFRDays'="")&&(Veobj.PHCFRIntervalUom="") Veobj.PHCFRIntervalUom="D"  //间隔时间不为空，间隔单位为空时，单位默认为天
		
		//逻辑限制 2021-12-27
		//1.ST/ONCE不要维护分发时间，除代码名称外，其他都不能维护，分发次数固定为1不能编辑
		if (($ZCVT(Veobj.PHCFRCode,"U")="ONCE")||($ZCVT(Veobj.PHCFRCode,"U")="ST"))
		{
			if (Veobj.PHCFRFactor'=1) s myVresult=myVresult_"【分发次数】要求为1，"
			if (Veobj.PHCFRDays'="") s myVresult=myVresult_"【间隔长度】要求为空，"
			if (Veobj.PHCFRIntervalUom'="") s myVresult=myVresult_"【间隔单位】要求为空，"
			if (Veobj.PHCFRWeekFlag="Y") s myVresult=myVresult_"不允许勾选【周频次】，"
			if (Veobj.PHCFRWeekFactor'="") s myVresult=myVresult_"【周频次系数】要求为空，"
			if (Veobj.PHCFRIrregularDistributTimeFlag="Y") s myVresult=myVresult_"不允许勾选【不规则分发时间标志】，"
		}
		//2.prn分发次数、分发时间、间隔天数都为空且不可编辑
		if ($ZCVT(Veobj.PHCFRCode,"U")="PRN")
		{
			if (Veobj.PHCFRFactor'="") s myVresult=myVresult_"【分发次数】要求为空，"
			if (Veobj.PHCFRDays'="") s myVresult=myVresult_"【间隔长度】要求为空，"
			if (Veobj.PHCFRIntervalUom'="") s myVresult=myVresult_"【间隔单位】要求为空，"
			if (Veobj.PHCFRWeekFlag="Y") s myVresult=myVresult_"不允许勾选【周频次】，"
			if (Veobj.PHCFRWeekFactor'="") s myVresult=myVresult_"【周频次系数】要求为空，"
			if (Veobj.PHCFRIrregularDistributTimeFlag="Y") s myVresult=myVresult_"不允许勾选【不规则分发时间标志】，"
		}
		//3.间隔单位不为空，间隔长度不能为空
		if (Veobj.PHCFRDays="")&&(Veobj.PHCFRIntervalUom'="")
		{
			s myVresult=myVresult_"间隔单位不为空时【间隔长度】必填，"
		}
		if (Veobj.PHCFRDays'="")&&(Veobj.PHCFRIntervalUom'="")
		{
			if (Veobj.PHCFRIrregularDistributTimeFlag="Y") s myVresult=myVresult_"选了间隔长度/间隔时间时不允许勾选【不规则分发时间标志】，"
		}
		//4.间隔单位维护为小时的，分发次数 24/间隔小时 向上取整
		if (Veobj.PHCFRDays'="")&&(Veobj.PHCFRIntervalUom="H")
		{
			
		}
		//6.维护周频次标记的，控制间隔长度7、单位为天且灰掉
		if (Veobj.PHCFRWeekFlag="Y")
		{
			if (+Veobj.PHCFRDays'=7) s myVresult=myVresult_"对于周频次，【间隔长度】要求为7，"
			if (Veobj.PHCFRIntervalUom'="D") s myVresult=myVresult_"对于周频次，【间隔单位】要求为天，"
		}
		
		s timeLength=$l(Veobj.PHCDTTime,"/")
		if Veobj.PHCDTTime="" s timeLength=0
		if ($zcvt(Veobj.PHCFRCode,"U")="PRN")||($zcvt(Veobj.PHCFRCode,"U")="ONCE")||($zcvt(Veobj.PHCFRCode,"U")="ST")
		{
			if (timeLength>0) s myVresult=myVresult_"ST/PRN/ONCE不需要维护分发时间，"
			
		}
		elseif((Veobj.PHCFRDays'="")&&(Veobj.PHCFRIntervalUom="H")) //维护了间隔时间和间隔单位 小时时，不允许维护分发次数和分发时间
		{
			if (timeLength>0) s myVresult=myVresult_"间隔单位为“小时”不需要维护分发时间，"
			
		}
		elseif(Veobj.PHCFRIrregularDistributTimeFlag="Y")   //勾选了【不规则分发时间标志】,分发时间描述要求必填 
		{
			s timedescLength=$l(Veobj.PHCDTTimeDesc,"/")
			if (timedescLength'=timeLength)
			{
				s myVresult=myVresult_"勾选了【不规则分发时间标志】后分发时间描述为必填项,"
			}
			
			if (timeLength<Veobj.PHCFRFactor) s myVresult=myVresult_"勾选了【不规则分发时间标志】且频次的分发次数不为空时，分发时间条数要不小于分发次数，"
			
		}
		else
		{
			 if (Veobj.PHCFRFactor="") s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"PHCFRFactor")_"】要求必填，"
			 if (timeLength<Veobj.PHCFRFactor) s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"PHCDTTime")_"】数量与"_"【"_..GetFieldDescByName(ID,"PHCFRFactor")_"】不一致，"
		}
		
		if Veobj.PHCDTTime'=""
		{
			s Veobj.PHCDTTime=$tr(Veobj.PHCDTTime,"：",":")   //2017-04-10
			
			if (timeLength>Veobj.PHCFRFactor)&&(Veobj.PHCFRIrregularDistributTimeFlag'="Y") s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"PHCDTTime")_"】超出"_"【"_..GetFieldDescByName(ID,"PHCFRFactor")_"】，"
			
			
			s errortimeflag=0
			s i=0
			for 
			{
				s i=i+1 q:(i>timeLength)||(errortimeflag=1)
				s timei=$p(Veobj.PHCDTTime,"/",i)
				try
				{
					s ti=$zth(timei,1)
				}
				catch{
					s errortimeflag=1
				}
			}
			if (errortimeflag=1) s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"PHCDTTime")_"】"_timei_"格式有误，"
			
			
			
		}
		q myVresult
	}
	if (tablecode="PHC_Instruc")
	{
		s MLength=$$$comMemberArrayGet("User.PHCInstruc",$$$cCLASSproperty,"PHCINCode",$$$cPROPparameter,"MAXLEN")
		if $l(Veobj.PHCINCode)>MLength s myVresult="【"_..GetFieldDescByName(ID,"PHCINCode")_"】长度不能超过"_MLength_"，"
		if (ImportType=1)
		{
			s flag=##class(web.DHCBL.CT.PHCInstruc).FormValidate(Veobj.PHCINRowId,Veobj.PHCINCode,Veobj.PHCINDesc1)
			if (flag'=0)
			{
				s flag=##class(web.DHCBL.CT.PHCInstruc).FormValidate(Veobj.PHCINRowId,Veobj.PHCINCode,"")
				i flag=1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"PHCINCode")_"】已存在，"
				s flag=##class(web.DHCBL.CT.PHCInstruc).FormValidate(Veobj.PHCINRowId,"",Veobj.PHCINDesc1)
				i flag=1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"PHCINDesc1")_"】已存在，"
			}
		}
		q myVresult
	}
	if (tablecode="PHC_Duration")
	{
		s MLength=$$$comMemberArrayGet("User.PHCDuration",$$$cCLASSproperty,"PHCDUCode",$$$cPROPparameter,"MAXLEN")
		if $l(Veobj.PHCDUCode)>MLength s myVresult="【"_..GetFieldDescByName(ID,"PHCDUCode")_"】长度不能超过"_MLength_"，"
		if (ImportType=1)
		{
			s flag=##class(web.DHCBL.CT.PHCDuration).FormValidate(Veobj.PHCDURowId,Veobj.PHCDUCode,Veobj.PHCDUDesc1)
			if (flag'=0)
			{
				s flag=##class(web.DHCBL.CT.PHCDuration).FormValidate(Veobj.PHCDURowId,Veobj.PHCDUCode,"")
				i flag=1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"PHCDUCode")_"】已存在，"
				s flag=##class(web.DHCBL.CT.PHCDuration).FormValidate(Veobj.PHCDURowId,"",Veobj.PHCDUDesc1)
				i flag=1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"PHCDUDesc1")_"】已存在，"
			}
		}
		q myVresult
	}
	if (tablecode="OEC_OrderCategoryGroup")
	{
		s MLength=$$$comMemberArrayGet("User.OECOrderCategoryGroup",$$$cCLASSproperty,"OCGRPCode",$$$cPROPparameter,"MAXLEN")
		if $l(Veobj.OCGRPCode)>MLength s myVresult="【"_..GetFieldDescByName(ID,"OCGRPCode")_"】长度不能超过"_MLength_"，"
		if (ImportType=1)
		{
			s flag=##class(web.DHCBL.CT.OECOrderCategoryGroup).FormValidate(Veobj.OCGRPRowId,Veobj.OCGRPCode,"")
			i flag=1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"OCGRPCode")_"】已存在，"
			s flag=##class(web.DHCBL.CT.OECOrderCategoryGroup).FormValidate(Veobj.OCGRPRowId,"",Veobj.OCGRPDesc)
			i flag=1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"OCGRPDesc")_"】已存在，"
			
		}
		q myVresult
	}	
	if (tablecode="DHC_PHCCat") //药理学分类
	{
		s PHCCLevel=0,PHCCDesc=""
		if (Veobj.PHCCCat1="")&&(Veobj.PHCCCat2="")&&(Veobj.PHCCCat3="")&&(Veobj.PHCCCat4="")&&(Veobj.PHCCCat5="")&&(Veobj.PHCCCat6="")&&(Veobj.PHCCCat7="")
		{
			Q "药理学分类不能为空，"
		}
		else
		{
			s PHCCLevel=1
			if (Veobj.PHCCCat1'="")  
			{	
				s PHCCLevel=1
				s PHCCDesc=Veobj.PHCCCat1
			}
			if (Veobj.PHCCCat2'="") 
			{
				if PHCCDesc'="" s myVresult="同一行不能有两条药理学分类数据，"
				s PHCCLevel=2
				s PHCCDesc=Veobj.PHCCCat2
			}
			if (Veobj.PHCCCat3'="") 
			{
				if PHCCDesc'="" s myVresult="同一行不能有两条药理学分类数据，"
				s PHCCLevel=3
				s PHCCDesc=Veobj.PHCCCat3
			}
			if (Veobj.PHCCCat4'="") 
			{
				if PHCCDesc'="" s myVresult="同一行不能有两条药理学分类数据，"
				s PHCCLevel=4
				s PHCCDesc=Veobj.PHCCCat4
			}
			if (Veobj.PHCCCat5'="")  
			{
				if PHCCDesc'="" s myVresult="同一行不能有两条药理学分类数据，"
				s PHCCLevel=5
				s PHCCDesc=Veobj.PHCCCat5
			}
			if (Veobj.PHCCCat6'="") 
			{
				if PHCCDesc'="" s myVresult="同一行不能有两条药理学分类数据，"
				s PHCCLevel=6
				s PHCCDesc=Veobj.PHCCCat6
			}
			if (Veobj.PHCCCat7'="")  
			{
				if PHCCDesc'="" s myVresult="同一行不能有两条药理学分类数据，"
				s PHCCLevel=7
				s PHCCDesc=Veobj.PHCCCat7
			}
		}
		if myVresult'="" q myVresult
		
					
		if (ImportType=1)
		{
			
			if Veobj.PHCCParCatDrCode'="" s Veobj.PHCCParCatDr=$o(^DHCPHCC(0,"PHCCCode",Veobj.PHCCParCatDrCode,0)) 	
			s flag=##class(web.BDPExt.DHCPHCCatBLL).FormValidate("",Veobj.PHCCCode,"",$g(PHCCLevel),Veobj.PHCCParCatDr)
			i flag=1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"PHCCCode")_"】已存在，"
			s flag=##class(web.BDPExt.DHCPHCCatBLL).FormValidate("","",PHCCDesc,$g(PHCCLevel),Veobj.PHCCParCatDr)
			i flag=1 s myVresult=myVresult_"【药理学分类描述】已存在，"
			
		}
		q myVresult
	}
	if (tablecode="PHC_Poison")
	{
		s MLength=$$$comMemberArrayGet("User.PHCPoison",$$$cCLASSproperty,"PHCPOCode",$$$cPROPparameter,"MAXLEN")
		if $l(Veobj.PHCPOCode)>MLength s myVresult="【"_..GetFieldDescByName(ID,"PHCPOCode")_"】长度不能超过"_MLength_"，"
		if (ImportType=1)
		{
			s flag=##class(web.DHCBL.CT.PHCPoison).FormValidate(Veobj.PHCPORowId,Veobj.PHCPOCode,"")
			i flag=1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"PHCPOCode")_"】已存在，"
			s flag=##class(web.DHCBL.CT.PHCPoison).FormValidate(Veobj.PHCPORowId,"",Veobj.PHCPODesc)
			i flag=1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"PHCPODesc")_"】已存在，"
		}
		q myVresult
	}
	if (tablecode="PHC_Generic")
	{
		s MLength=$$$comMemberArrayGet("User.PHCGeneric",$$$cCLASSproperty,"PHCGECode",$$$cPROPparameter,"MAXLEN")
		if $l(Veobj.PHCGECode)>MLength s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"PHCGECode")_"】长度不能超过"_MLength_"，"
		if (ImportType=1)
		{
			s flag=##class(web.DHCBL.CT.PHCGeneric).FormValidate(Veobj.PHCGERowId,Veobj.PHCGECode,"")
			i flag=1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"PHCGECode")_"】已存在，"
			s flag=##class(web.DHCBL.CT.PHCGeneric).FormValidate(Veobj.PHCGERowId,"",Veobj.PHCGEName)
			i flag=1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"PHCGEName")_"】已存在，"
		}
		q myVresult
	}
	
	if (tablecode="OrderCategory")  //医嘱分类（大类、子类）
	{
		s MLength=$$$comMemberArrayGet("User.OECOrderCategory",$$$cCLASSproperty,"ORCATCode",$$$cPROPparameter,"MAXLEN")
		if $l(Veobj.ORCATCode)>MLength s myVresult=myVresult_"【大类代码】长度不能超过"_MLength_"，"
		s MLength=$$$comMemberArrayGet("User.ARCItemCat",$$$cCLASSproperty,"ARCICCode",$$$cPROPparameter,"MAXLEN")
		if $l(Veobj.ARCICCode)>MLength s myVresult=myVresult_"【子类代码】长度不能超过"_MLength_"，"
		
		///2020-06-06 云HIS 校验医院
		s validStr= ##class(web.DHCBL.BDP.BDPMappingHOSP).ValidateHospId(tablename,Veobj.LinkHospId)  ///校验医院
		if (validStr'="")
		{
			s myVresult=myVresult_validStr
			q myVresult
		}
		
		
		if (ImportType=1)
		{
			///私有数据
			s ORCATRowId=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("OEC_OrderCategory",Veobj.ORCATCode,Veobj.LinkHospId)
			s ORCATRowId2=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByDesc("OEC_OrderCategory",Veobj.ORCATDesc,Veobj.LinkHospId)
			i (ORCATRowId'=ORCATRowId2)
			{
				s myVresult=myVresult_"【大类代码】和【大类名称】不匹配，"
			}
			s flag=##class(web.DHCBL.CT.ARCItemCat).FormValidate("",Veobj.ARCICCode,"",Veobj.LinkHospId)
			i flag=1 s myVresult=myVresult_"【医嘱子类代码】已存在，"
			s flag=##class(web.DHCBL.CT.ARCItemCat).FormValidate("","",Veobj.ARCICDesc,Veobj.LinkHospId)
			i flag=1 s myVresult=myVresult_"【医嘱子类描述】已存在，"
			
		}
		s:Veobj.ARCICOrderType'="" Veobj.ARCICOrderType=$$ALPHAUP^SSUTIL4(Veobj.ARCICOrderType)
		if (Veobj.ARCICOrderType'="")&(Veobj.ARCICOrderType'="DRUG")&(Veobj.ARCICOrderType'="DIET")&(Veobj.ARCICOrderType'="IV")&(Veobj.ARCICOrderType'="CONSULTATION")&(Veobj.ARCICOrderType'="NORMAL")&(Veobj.ARCICOrderType'="DENTAL")&(Veobj.ARCICOrderType'="LABTRAK")&(Veobj.ARCICOrderType'="REHABMEDICINE")&(Veobj.ARCICOrderType'="PRICE")&(Veobj.ARCICOrderType'="BLOODBANK")&(Veobj.ARCICOrderType'="DIETSUPPLEMENT")&(Veobj.ARCICOrderType'="HARDWARE")&(Veobj.ARCICOrderType'="DAYBOOK")&(Veobj.ARCICOrderType'="DFT")&(Veobj.ARCICOrderType'="DIETTHICKENEDFLUID")&(Veobj.ARCICOrderType'="BULKMEAL")&(Veobj.ARCICOrderType'="PROSTHETICS")&(Veobj.ARCICOrderType'="MATERIAL") s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"ARCICOrderType")_"】校验失败，"
		
		q myVresult
	}
	
	if (tablecode="MRC_ICDDx")
	{
		
		s MLength=$$$comMemberArrayGet("User.MRCICDDx",$$$cCLASSproperty,"MRCIDCode",$$$cPROPparameter,"MAXLEN")
		if $l(Veobj.MRCIDCode)>MLength s myVresult="【"_..GetFieldDescByName(ID,"MRCIDCode")_"】长度不能超过"_MLength_"，"
		
		
		///2020-06-06 云HIS 校验医院
		s validStr= ##class(web.DHCBL.BDP.BDPMappingHOSP).ValidateHospId(tablename,Veobj.LinkHospId)  ///校验医院
		if (validStr'="")
		{
			s myVresult=myVresult_validStr
			q myVresult
		}
		if (ImportType=1)
		{
			//管控数据
			for hospi=1:1:$l(Veobj.LinkHospId,"/")
			{
				s HospId=$p(Veobj.LinkHospId,"/",hospi)
				
				///2021-01-22 chenying  调用新的校验方法  代码+名称+医院+结束日期
				s flag=##class(web.DHCBL.CT.MRCICDDx).FormValidate(Veobj.MRCIDRowId,Veobj.MRCIDCode,Veobj.MRCIDDesc,HospId,Veobj.MRCIDDateActiveTo,Veobj.MRCIDVersionDictDR)
				i flag=1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"MRCIDCode")_"】和【"_..GetFieldDescByName(ID,"MRCIDDesc")_"】已存在，"
			}
			
		}
		q myVresult
	}
	if (tablecode="ORC_AnaestMethod")
	{
		s MLength=$$$comMemberArrayGet("User.ORCAnaestMethod",$$$cCLASSproperty,"ANMETCode",$$$cPROPparameter,"MAXLEN")
		if $l(Veobj.ANMETCode)>MLength s myVresult="【"_..GetFieldDescByName(ID,"ANMETCode")_"】长度不能超过"_MLength_"，"
		if (ImportType=1)
		{
			s flag=##class(web.DHCBL.CT.ORCAnaestMethod).FormValidate(Veobj.ANMETRowId,Veobj.ANMETCode,"")
			i flag=1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"ANMETCode")_"】已存在，"
			s flag=##class(web.DHCBL.CT.ORCAnaestMethod).FormValidate(Veobj.ANMETRowId,"",Veobj.ANMETDesc)
			i flag=1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"ANMETDesc")_"】已存在，"	
		}
		q myVresult
	}
	if (tablecode="ORC_Operation")	//手术
	{
		s MLength=$$$comMemberArrayGet("User.ORCOperation",$$$cCLASSproperty,"OPERCode",$$$cPROPparameter,"MAXLEN")
		if $l(Veobj.OPERCode)>MLength s myVresult="【"_..GetFieldDescByName(ID,"OPERCode")_"】长度不能超过"_MLength_"，"
		
		///2020-06-06 云HIS 校验医院
		s validStr= ##class(web.DHCBL.BDP.BDPMappingHOSP).ValidateHospId(tablename,Veobj.LinkHospId)  ///校验医院
		if (validStr'="")
		{
			s myVresult=myVresult_validStr
			q myVresult
		}
		if (ImportType=1)
		{
			//管控数据
			for hospi=1:1:$l(Veobj.LinkHospId,"/")
			{
				s HospId=$p(Veobj.LinkHospId,"/",hospi)	
				s flag=##class(web.DHCBL.CT.ORCOperation).FormValidate("",Veobj.OPERCode,Veobj.OPERDesc,HospId,Veobj.OPERActiveDateTo,Veobj.OPERVersionDictDR)
				i flag=1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"OPERCode")_"】和【"_..GetFieldDescByName(ID,"OPERDesc")_"】已存在，"
			}
		}
		
		s:Veobj.OPERType'="" Veobj.OPERType=$$ALPHAUP^SSUTIL4(Veobj.OPERType)
		if (Veobj.OPERType'="")&(Veobj.OPERType'="常规")&(Veobj.OPERType'="诊断性操作")&(Veobj.OPERType'="治疗性操作")&(Veobj.OPERType'="手术")&(Veobj.OPERType'="介入治疗")  s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"OPERType")_"】 "_Veobj.OPERType_" 校验失败，"
		s:Veobj.OPERTechnique'="" Veobj.OPERTechnique=$$ALPHAUP^SSUTIL4(Veobj.OPERTechnique)
		if (Veobj.OPERTechnique'="")&(Veobj.OPERTechnique'="常规")&(Veobj.OPERTechnique'="普通")&(Veobj.OPERTechnique'="开放")&(Veobj.OPERTechnique'="介入")&(Veobj.OPERTechnique'="内镜")&(Veobj.OPERTechnique'="腹镜")&(Veobj.OPERTechnique'="腔镜")&(Veobj.OPERTechnique'="操作") s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"OPERTechnique")_"】 "_Veobj.OPERTechnique_" 校验失败，"
		q myVresult
	}
	if (tablecode="ORC_OperPosition")
	{
		s MLength=$$$comMemberArrayGet("User.ORCOperPosition",$$$cCLASSproperty,"OPPOSCode",$$$cPROPparameter,"MAXLEN")
		if $l(Veobj.OPPOSCode)>MLength s myVresult="【"_..GetFieldDescByName(ID,"OPPOSCode")_"】长度不能超过"_MLength_"，"
		if (ImportType=1)
		{
			s flag=##class(web.DHCBL.CT.ORCOperPosition).FormValidate(Veobj.OPPOSRowId,Veobj.OPPOSCode,"")
			i flag=1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"OPPOSCode")_"】已存在，"
			s flag=##class(web.DHCBL.CT.ORCOperPosition).FormValidate(Veobj.OPPOSRowId,"",Veobj.OPPOSDesc)
			i flag=1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"OPPOSDesc")_"】已存在，"
		}
		q myVresult
	}
	if (tablecode="RoomBedType")	//房间类型、床位类型， 2020-06-13不用了
	{
		s MLength=$$$comMemberArrayGet("User.PACBedType",$$$cCLASSproperty,"BEDTPCode",$$$cPROPparameter,"MAXLEN")
		if $l(Veobj.BEDTPCode)>MLength s myVresult="【"_..GetFieldDescByName(ID,"BEDTPCode")_"】长度不能超过"_MLength_"，"
		s MLength=$$$comMemberArrayGet("User.PACRoomType",$$$cCLASSproperty,"ROOMTCode",$$$cPROPparameter,"MAXLEN")
		if $l(Veobj.ROOMTCode)>MLength s myVresult="【"_..GetFieldDescByName(ID,"ROOMTCode")_"】长度不能超过"_MLength_"，"
		if (ImportType=1)
		{
			s flag=##class(web.DHCBL.CT.PACBedType).FormValidate(Veobj.BEDTPRowId,Veobj.BEDTPCode,"")
			i flag=1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"BEDTPCode")_"】已存在，"
			s flag=##class(web.DHCBL.CT.PACBedType).FormValidate(Veobj.BEDTPRowId,"",Veobj.BEDTPDesc)
			i flag=1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"BEDTPDesc")_"】已存在，"
			
			s flag=##class(web.DHCBL.CT.PACRoomType).FormValidate(Veobj.ROOMTRowId,Veobj.ROOMTCode,"")
			i flag=1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"ROOMTCode")_"】已存在，"
			s flag=##class(web.DHCBL.CT.PACRoomType).FormValidate(Veobj.ROOMTRowId,"",Veobj.ROOMTDesc)
			i flag=1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"ROOMTDesc")_"】已存在，"
		}
		q myVresult
	}
	if (tablecode="PAC_BedType")	//床位类型 2020-06-13
	{ 
		s MLength=$$$comMemberArrayGet("User.PACBedType",$$$cCLASSproperty,"BEDTPCode",$$$cPROPparameter,"MAXLEN")
		if $l(Veobj.BEDTPCode)>MLength s myVresult="【"_..GetFieldDescByName(ID,"BEDTPCode")_"】长度不能超过"_MLength_"，"
		
		///2020-06-06 云HIS 校验医院
		s validStr= ##class(web.DHCBL.BDP.BDPMappingHOSP).ValidateHospId(tablename,Veobj.LinkHospId)  ///校验医院
		if (validStr'="")
		{
			s myVresult=myVresult_validStr
			q myVresult
		}
		if (ImportType=1)
		{
			//私有数据
			s flag=##class(web.DHCBL.CT.PACBedType).FormValidate(Veobj.BEDTPRowId,Veobj.BEDTPCode,"",Veobj.LinkHospId)
			i flag=1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"BEDTPCode")_"】已存在，"
			s flag=##class(web.DHCBL.CT.PACBedType).FormValidate(Veobj.BEDTPRowId,"",Veobj.BEDTPDesc,Veobj.LinkHospId)
			i flag=1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"BEDTPDesc")_"】已存在，"
			
		}
		q myVresult
	}
	if (tablecode="PAC_RoomType")	//房间类型 2020-06-13
	{
		s MLength=$$$comMemberArrayGet("User.PACRoomType",$$$cCLASSproperty,"ROOMTCode",$$$cPROPparameter,"MAXLEN")
		if $l(Veobj.ROOMTCode)>MLength s myVresult="【"_..GetFieldDescByName(ID,"ROOMTCode")_"】长度不能超过"_MLength_"，"
		///2020-06-06 云HIS 校验医院
		s validStr= ##class(web.DHCBL.BDP.BDPMappingHOSP).ValidateHospId(tablename,Veobj.LinkHospId)  ///校验医院
		if (validStr'="")
		{
			s myVresult=myVresult_validStr
			q myVresult
		}
		if (ImportType=1)
		{
			s flag=##class(web.DHCBL.CT.PACRoomType).FormValidate(Veobj.ROOMTRowId,Veobj.ROOMTCode,"",Veobj.LinkHospId)
			i flag=1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"ROOMTCode")_"】已存在，"
			s flag=##class(web.DHCBL.CT.PACRoomType).FormValidate(Veobj.ROOMTRowId,"",Veobj.ROOMTDesc,Veobj.LinkHospId)
			i flag=1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"ROOMTDesc")_"】已存在，"
		}
		q myVresult
	}
	if (tablecode="PAC_Bed")	//床位
	{
		s:Veobj.ROOMDifferentSexPatients'="" Veobj.ROOMDifferentSexPatients=$$ALPHAUP^SSUTIL4(Veobj.ROOMDifferentSexPatients)
		if (Veobj.ROOMDifferentSexPatients'="")&(Veobj.ROOMDifferentSexPatients'="DOESNOTMATTER")&(Veobj.ROOMDifferentSexPatients'="WARNING")&(Veobj.ROOMDifferentSexPatients'="NOTALLOWED")  s myVresult=myVresult_"【不同性别的病人在同一房间>校验失败，"
		s MLength=$$$comMemberArrayGet("User.CTLoc",$$$cCLASSproperty,"CTLOCCode",$$$cPROPparameter,"MAXLEN")
		if $l(Veobj.WARDCode)>MLength s myVresult="【"_..GetFieldDescByName(ID,"WARDCode")_"】长度不能超过"_MLength_"，"
		s MLength=$$$comMemberArrayGet("User.PACWard",$$$cCLASSproperty,"WARDCode",$$$cPROPparameter,"MAXLEN")
		if $l(Veobj.WARDCode)>MLength s myVresult="【"_..GetFieldDescByName(ID,"WARDCode")_"】长度不能超过"_MLength_"，"
		s MLength=$$$comMemberArrayGet("User.PACBed",$$$cCLASSproperty,"BEDCode",$$$cPROPparameter,"MAXLEN")
		if $l(Veobj.BEDCode)>MLength s myVresult="【"_..GetFieldDescByName(ID,"BEDCode")_"】长度不能超过"_MLength_"，"
		///2020-06-06 云HIS 校验医院
		s validStr= ##class(web.DHCBL.BDP.BDPMappingHOSP).ValidateHospId(tablename,Veobj.LinkHospId)  ///校验医院
		if (validStr'="")
		{
			s myVresult=myVresult_validStr
			q myVresult
		}
		s BEDWARDParRef=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("PAC_Ward",Veobj.WARDCode,Veobj.LinkHospId)
		if BEDWARDParRef=""
		{
			s myVresult=myVresult_"该病区不存在，"
		}
		else
		{
			s WARDDesc=$p($g(^PAWARD(BEDWARDParRef)),"^",2)
			if WARDDesc'=Veobj.WARDDesc
			{
				s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"WARDCode")_"】与【"_..GetFieldDescByName(ID,"WARDDesc")_"】不对应，"
				
			}
			else
			{
				s CTLOCRowId=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("CT_Loc",Veobj.WARDCode,Veobj.LinkHospId)
				if CTLOCRowId=""
				{
					s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"WARDCode")_"】对应科室不存在，"	
				}
				else
				{
					if Veobj.BEDCode'=""  //导床位
					{
						if (Veobj.BEDBedTypeDR="") s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"BEDBedTypeDR")_"】不能为空，"
						if (Veobj.BEDRcFlag="") s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"BEDRcFlag")_"】不能为空，"
						if (Veobj.BEDSequence="") s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"BEDSequence")_"】不能为空，"
						s CTLOCType=$p($g(^CTLOC(CTLOCRowId)),"^",13)
						///20170703 病区，手术，急诊类型的科室才可以导入床位
						if (CTLOCType'="W")&&(CTLOCType'="EM")&&(CTLOCType'="OP")
						{
							s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"WARDCode")_"】对应科室不是Ward/Operating Theatre/Emergency类型，"
						}
						else
						{
							if (ImportType=1)
							{
								s flag=##class(web.DHCBL.CT.PACBed).Validate(BEDWARDParRef,Veobj.BEDRowID,Veobj.BEDCode)
								if flag=1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"BEDCode")_"】已存在，"
							}
						}
					} 
					else  //导病区房间分配
					{
						if (ImportType=1)
						{
							i (Veobj.ROOMQuery'="")&(Veobj.ROOMQuery'="急诊等候区")&&(Veobj.ROOMQuery'="病区等候区")&&(Veobj.ROOMQuery'="多人病房")&&(Veobj.ROOMQuery'="空房") s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"ROOMQuery")_"】校验失败，"
							s ROOMRowId=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByDesc("PAC_Room",Veobj.ROOMCode,Veobj.LinkHospId)
							if ROOMRowId'=""
							{
								s flag=##class(web.DHCBL.CT.PACWardRoom).Validate(BEDWARDParRef,"",ROOMRowId)
								if flag=1 s myVresult=myVresult_"房间分配已存在，"
							}
						}
					}
				}
			}
		}
		//校验楼层 likefan 20201202
		if (Veobj.ROOMFloorDR'="")
		{
			s floorid=##class(web.DHCBL.CT.CTLocBuildingFloor).GetFloorIDByDesc(Veobj.ROOMFloorDR,Veobj.LinkHospId)
			s:floorid="" myVresult=myVresult_"楼层【"_Veobj.ROOMFloorDR_"】校验失败，"	
		}
		q myVresult
		
	}

	if (tablecode="ARC_ItemExternalCodes")	//外部代码
	{
		s myVresult=""
		
		s MLength=$$$comMemberArrayGet("User.ARCItemExternalCodes",$$$cCLASSproperty,"EXTCode",$$$cPROPparameter,"MAXLEN")
		if $l(Veobj.EXTCode)>MLength s myVresult="【"_..GetFieldDescByName(ID,"EXTCode")_"】长度不能超过"_MLength_"，"
		s MLength=$$$comMemberArrayGet("User.ARCItmMast",$$$cCLASSproperty,"ARCIMCode",$$$cPROPparameter,"MAXLEN")
		if $l(Veobj.ARCIMCode)>MLength s myVresult="【"_..GetFieldDescByName(ID,"ARCIMCode")_"】长度不能超过"_MLength_"，"
		///2020-06-06 云HIS 校验医院
		s validStr= ##class(web.DHCBL.BDP.BDPMappingHOSP).ValidateHospId(tablename,Veobj.LinkHospId)  ///校验医院
		if (validStr'="")
		{
			s myVresult=myVresult_validStr
			q myVresult
		}
		
		s EXTParRef=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("ARC_ItmMast",Veobj.ARCIMCode,Veobj.LinkHospId)
		if (EXTParRef="")
		{
			s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"ARCIMCode")_"】对应的医嘱项不存在，"	
		}
		else
		{
			s Desc=$p($g(^ARCIM($P(EXTParRef,"||",1),$P(EXTParRef,"||",2),1)),"^",2)
			if Veobj.ARCIMDesc'=Desc s myVresult=myVresult_"医嘱项代码和描述不对应，"
			if (ImportType=1)
			{
				s flag= ##class(web.DHCBL.CT.ARCItemExternalCodes).FormValidate(Veobj.EXTRowId,EXTParRef,Veobj.EXTCode,Veobj.EXTDesc)
				if flag=1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"EXTCode")_"】已存在，"
				if flag=2 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"EXTDesc")_"】已存在，"
			}
		}
		q myVresult
	}
	
	if (tablecode="INC_StkCat")	//库存分类
	{
		i (Veobj.scSet'="")&(Veobj.scSet'="医用材料")&&(Veobj.scSet'="后勤材料")&&(Veobj.scSet'="试剂")&&(Veobj.scSet'="固定资产")&&(Veobj.scSet'="西药")&&(Veobj.scSet'="中成药")&&(Veobj.scSet'="草药") s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"scSet")_"】校验失败，"
		i (Veobj.scSGStruModeFlag'="")&&(Veobj.scSGStruModeFlag'="一对多")&&(Veobj.scSGStruModeFlag'="一对一") s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"scSGStruModeFlag")_"】校验失败，"
		///2020-06-06 云HIS 校验医院
		s validStr= ##class(web.DHCBL.BDP.BDPMappingHOSP).ValidateHospId(tablename,Veobj.LinkHospId)  ///校验医院
		if (validStr'="")
		{
			s myVresult=myVresult_validStr
			q myVresult
		}
		
		
		if (ImportType=1)
		{
			s SGRowId=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("DHC_StkCatGroup",Veobj.scSGCode_"^"_Veobj.scStkType,Veobj.LinkHospId)
			if (SGRowId'="")
			{
				s scgdesc=$p($g(^DHCSCG(SGRowId)),"^",2)
				if (Veobj.scSGDesc'=scgdesc) s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"scSGCode")_"】已存在，"
			}
			else
			{
				s SGRowId=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByDesc("DHC_StkCatGroup",Veobj.scSGDesc_"^"_Veobj.scStkType,Veobj.LinkHospId)
				if (SGRowId'="") s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"scSGDesc")_"】已存在，"
			
			}
		
			///私有数据
			s flag=##class(web.BDPExt.INCStkCatBLL).FormValidate(Veobj.scSCCode,"",Veobj.LinkHospId, Veobj.scStkType)
			i flag=1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"scSCCode")_"】已存在，"
			s flag=##class(web.BDPExt.INCStkCatBLL).FormValidate("",Veobj.scSCDesc,Veobj.LinkHospId, Veobj.scStkType)
			i flag=1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"scSCCode")_"】已存在，"
			
		}
		s:Veobj.scStkType'="" Veobj.scStkType=$$ALPHAUP^SSUTIL4(Veobj.scStkType)
		if (Veobj.scStkType'="M")&&(Veobj.scStkType'="G") s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"mType")_"】校验失败，"
		q myVresult
	}
	
	if (tablecode="DHCExaBorough")	//1 分诊区
	{
		///2020-06-06 云HIS 校验医院
		/*s validStr= ##class(web.DHCBL.BDP.BDPMappingHOSP).ValidateHospId(tablename,Veobj.ExabHospitalDr)  ///校验医院
		if (validStr'="")
		{
			s myVresult=myVresult_validStr
			q myVresult
		}
		*/
		if (ImportType=1)
		{
			s flag= ##class(web.BDPExt.DHCExaBoroughBLL).FormValidate(Veobj.ExabCode,"",Veobj.ExabHospitalDr)
			if flag=1  s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"ExabCode")_"】已存在，"
			s flag= ##class(web.BDPExt.DHCExaBoroughBLL).FormValidate("",Veobj.ExabName,Veobj.ExabHospitalDr)
			if flag=1  s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"ExabName")_"】已存在，"
		}
		i (Veobj.ExabTem'="")&(Veobj.ExabTem'="Y")&(Veobj.ExabTem'="N")&(Veobj.ExabTem'="n")&(Veobj.ExabTem'="y") s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"ExabTem")_"】校验失败，"
		
		q myVresult
		
	}
	if (tablecode="DHCBorExaRoom")	//2 分诊区诊室对照
	{
		///诊区的科室类型是OutPatient Consulting Room
		///2020-06-06 云HIS 校验医院
		s validStr= ##class(web.DHCBL.BDP.BDPMappingHOSP).ValidateHospId(tablename,Veobj.LinkHospId)  ///校验医院
		if (validStr'="")
		{
			s myVresult=myVresult_validStr
			q myVresult
		}
		if Veobj.BorExaRoomDr=""
		{
			s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"BorExaRoomDr")_"】为必填项，"
		}
		else
		{
			s CTLOCType=$p($g(^CTLOC(Veobj.BorExaRoomDr)),"^",13)
			if CTLOCType'="OR"     
			{
				s CTLOCDesc=$p($g(^CTLOC(Veobj.BorExaRoomDr)),"^",2)
				s myVresult="【"_CTLOCDesc_"】不是诊室，"
			 
			}
		}
		if Veobj.BorDr=""
		{
			  s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"BorDr")_"】不存在，"
		}
		else
		{
			if (ImportType=1)
			{
				s flag=##class(web.BDPExt.DHCBorExaRoomBLL).FormValidate(Veobj.ID,Veobj.BorDr,Veobj.BorExaRoomDr)
				if flag=1  s myVresult=myVresult_"该对照已存在，"
			}
		}
		q myVresult
		
	}
	
	if (tablecode="DHCExaBorDep")	//3 分诊区科室对照
	{
		///2020-06-06 云HIS 校验医院
		s validStr= ##class(web.DHCBL.BDP.BDPMappingHOSP).ValidateHospId(tablename,Veobj.LinkHospId)  ///校验医院
		if (validStr'="")
		{
			s myVresult=myVresult_validStr
			q myVresult
		}
		///科室需要判断访问类型表里，需要维护到O、E，这两种类型
		s flag=##class(web.BDPExt.DHCMarkDocBLL).CheckCTLocData(Veobj.BordDepDr)
		if flag'=1  s myVresult=myVresult_"未将该科室的访问类型位置添加到门诊，"
		
		if Veobj.BordBorDr=""
		{
			  s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"BordBorDr")_"】不存在，"
		}
		else
		{
			if (ImportType=1)
			{
				s flag=##class(web.BDPExt.DHCExaBorDepBLL).FormValidate(Veobj.ID,Veobj.BordBorDr,Veobj.BordDepDr)
				if flag=1  s myVresult=myVresult_"该对照已存在，"
			}
		}
		q myVresult
		
	}
	
	if (tablecode="DHCMarkDoc")	//4 医生号别对照
	{
		///2020-06-06 云HIS 校验医院
		s validStr= ##class(web.DHCBL.BDP.BDPMappingHOSP).ValidateHospId(tablename,Veobj.LinkHospId)  ///校验医院
		if (validStr'="")
		{
			s myVresult=myVresult_validStr
			q myVresult
		}
		if Veobj.MarkdDocDr=""
		{
			s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"MarkdDocDr")_"】为必填项，"
		}
		else
		{
			s DocName=$p($g(^CTPCP(Veobj.MarkdDocDr,1)),"^",2)
			if DocName'=Veobj.MarkdDocDrName  s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"MarkdDocDr")_"】和【"_..GetFieldDescByName(ID,"MarkdDocDrName")_"】不匹配，"
		}
		
		if Veobj.MarkdMarkDr=""
		{
			s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"MarkdMarkDr")_"】为必填项，"
		}
		else
		{
			s Name=$p($g(^CTPCP(Veobj.MarkdMarkDr,1)),"^",2)
			if Name'=Veobj.MarkdMarkDrName  s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"MarkdMarkDr")_"】和"_"【"_..GetFieldDescByName(ID,"MarkdMarkDrName")_"】不匹配，"
		}
		
		
		s flag=##class(web.BDPExt.DHCMarkDocBLL).CheckCTLocData(Veobj.MarkddepDr)
		if flag'=1 s myVresult=myVresult_"未将该科室的访问类型位置添加到门诊，"
		
		s flag= ##class(web.BDPExt.DHCMarkDocBLL).CheckCTCareProvData(Veobj.MarkdDocDr,Veobj.MarkddepDr)
		if flag'=1 s myVresult=myVresult_"医生未维护到科室，"
		
		s flag= ##class(web.BDPExt.DHCMarkDocBLL).CheckCTCareProvData(Veobj.MarkdMarkDr,Veobj.MarkddepDr)
		if flag'=1 s myVresult=myVresult_"号别未维护到科室，"
		
		if (ImportType=1)
		{
			s flag=##class(web.BDPExt.DHCMarkDocBLL).FormValidate(Veobj.ID,Veobj.MarkddepDr,Veobj.MarkdDocDr,Veobj.MarkdMarkDr)
			if flag=1  s myVresult=myVresult_"该对照已存在，"
		}
		
		q myVresult
		
	}
	
	if (tablecode="DHCDepMark")	//分诊区号别对照
	{
		///2020-06-06 云HIS 校验医院
		s validStr= ##class(web.DHCBL.BDP.BDPMappingHOSP).ValidateHospId(tablename,Veobj.LinkHospId)  ///校验医院
		if (validStr'="")
		{
			s myVresult=myVresult_validStr
			q myVresult
		}
		if Veobj.DepmMarkDr=""
		{
			s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"DepmMarkDr")_"】为必填项，"
		}
		else
		{
			s Name=$p($g(^CTPCP(Veobj.DepmMarkDr,1)),"^",2)
			if Name'=Veobj.DepmMarkDrName  s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"DepmMarkDr")_"】和【"_..GetFieldDescByName(ID,"MarkdDocDrName")_"】不匹配，"
		}
		if Veobj.DepmBorDr=""
		{
			  s myVresult=myVresult_"【分诊区】不存在，"
		}
		else
		{
			if (ImportType=1)
			{
				s flag=##class(web.BDPExt.DHCDepMarkBLL).FormValidate(Veobj.ID,Veobj.DepmBorDr,Veobj.DepmDepDr,Veobj.DepmMarkDr)
				if flag=1  s myVresult=myVresult_"该对照已存在，"
			}
		}
		q myVresult
		
	}
	if (tablecode="DHCBorUser")	//操作员诊区对照
	{
		///2020-06-06 云HIS 校验医院
		s validStr= ##class(web.DHCBL.BDP.BDPMappingHOSP).ValidateHospId(tablename,Veobj.LinkHospId)  ///校验医院
		if (validStr'="")
		{
			s myVresult=myVresult_validStr
			q myVresult
		}
		if Veobj.BoruUseDr=""
		{
			s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"BoruUseDr")_"】为必填项，"
		}
		else
		{
			s Name=$p($g(^SSU("SSUSR",Veobj.BoruUseDr)),"^",2)
			if Name'=Veobj.BoruUseDrName  s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"BoruUseDr")_"】和【"_..GetFieldDescByName(ID,"BoruUseDrName")_"】不匹配，"
		}
		if Veobj.BoruBorDr=""
		{
			  s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"BoruBorDr")_"】不存在，"
		}
		else
		{
			if (ImportType=1)
			{
				s flag=##class(web.BDPExt.DHCBorUserBLL).FormValidate(Veobj.ID,Veobj.BoruBorDr,Veobj.BoruUseDr)
				if flag=1  s myVresult=myVresult_"该对照已存在，"
			}
		}
		q myVresult
		
	}
	
	if (tablecode="RB_ResEffDateSession") //排班模板 2018-11-25
	{
		
		///2020-06-06 云HIS 校验医院
		s validStr= ##class(web.DHCBL.BDP.BDPMappingHOSP).ValidateHospId(tablename,Veobj.LinkHospId)  ///校验医院
		if (validStr'="")
		{
			s myVresult=myVresult_validStr
			q myVresult
		}
		///诊区的科室类型是OutPatient Consulting Room
		if Veobj.RoomDesc'=""
		{
			s RoomDr=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByDesc("CT_Loc",Veobj.RoomDesc,Veobj.LinkHospId)
			if RoomDr'=""
			{
				s CTLOCType=$p($g(^CTLOC(RoomDr)),"^",13)
				if CTLOCType'="OR"     
				{
					s myVresult="【"_Veobj.RoomDesc_"】不是诊室，"
			 
				}
			}
			else{
				s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"RoomDesc")_"】"_Veobj.RoomDesc_" 不存在，"
				
			}
			
		}
		s liststr=Veobj.RSLDesc_"^"_Veobj.LocDesc_"^"_Veobj.RESCode_"^"_Veobj.RESDesc_"^"_Veobj.WeekNum
		s liststr=liststr_"^"_Veobj.TRDesc_"^"_Veobj.SessionTypeDesc_"^"_Veobj.CLGRPDesc_"^"_Veobj.RoomDesc_"^"_Veobj.SessLoad
		s liststr=liststr_"^"_Veobj.SessNoApptSlot_"^"_Veobj.AddtionMax_"^"_Veobj.SessNumberOfWeeks_"^"_Veobj.TRFlag_"^"_Veobj.TRStartTime
		s liststr=liststr_"^"_Veobj.TREndTime_"^"_Veobj.TRLength_"^"_Veobj.TTrtemName_"^"_Veobj.AppMethodStr
		
		s ExpStr=Veobj.LinkHospId //2020-03-20入参增加医院
		//s ret= ##class(DHCDoc.DHCDocCure.RBCResPlan).ValidateRBResSessData(liststr,ExpStr)
		s ret= ##class(DHCDoc.Interface.Outside.ImportData.RBASTemplate).ValidateRBResSessData(liststr,ExpStr)
		if $p(ret,"^",1)<0
		{
			s myVresult=myVresult_$p(ret,"^",2)
		}
	}
	if (tablecode="RB_ApptSchedule") //排班 2020-12-31
	{
		
		///2020-06-06 云HIS 校验医院
		s validStr= ##class(web.DHCBL.BDP.BDPMappingHOSP).ValidateHospId(tablename,Veobj.LinkHospId)  ///校验医院
		if (validStr'="")
		{
			s myVresult=myVresult_validStr
			q myVresult
		}
		
		//安全组ID1	科室名称2	号别代码3	号别名称4	出诊日期5	时段6	挂号职称7	亚专业8	诊室9	正号限额10	预约限额	加号限额	预约起始号	分时段就诊	开始时间	结束时间	间隔分钟	时段号数	预约方式信息（方式|限额|起始号）
		s liststr=Veobj.GroupID_"^"_Veobj.LocDesc_"^"_Veobj.RESCode_"^"_Veobj.RESDesc_"^"_Veobj.ScheduleDate
		s liststr=liststr_"^"_Veobj.TRDesc_"^"_Veobj.SessionTypeDesc_"^"_Veobj.CLGRPDesc_"^"_Veobj.RoomDesc_"^"_Veobj.SessLoad
		s liststr=liststr_"^"_Veobj.SessNoApptSlot_"^"_Veobj.AddtionMax_"^"_Veobj.SessNumberOfWeeks_"^"_Veobj.TRFlag_"^"_Veobj.TRStartTime
		s liststr=liststr_"^"_Veobj.TREndTime_"^"_Veobj.TRLength_"^"_Veobj.TTrtemName_"^"_Veobj.AppMethodStr
		s ExpStr=Veobj.LinkHospId 
		s ret=##Class(DHCDoc.Interface.Outside.ImportData.RBASApptSchedule).ValidateRBApptScheduleData(liststr,ExpStr)
		if $p(ret,"^",1)<0
		{
			s myVresult=myVresult_$p(ret,"^",2)
		}
	}
	if (tablecode="DHC_PHChemical") //化学通用名 2018-11-25
	{
		s myVresult=""
		//药理学分类代码描述统一校验
		S PHCCCodeDr=""
		if (Veobj.PHCCCode'="")
		{
			s PHCCCodeDr=$O(^DHCPHCC(0,"PHCCCode",Veobj.PHCCCode,0))
			if PHCCCodeDr'=""
			{
				s Desc=$p($g(^DHCPHCC(PHCCCodeDr)),"^",2)
				if Desc'=Veobj.PHCCDesc
				{
					s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"PHCCCode")_"】"_Veobj.PHCCCode_"与【"_..GetFieldDescByName(ID,"PHCCDesc")_"】"_Veobj.PHCCDesc_"不对应，"
				}
			}
			else
			{
				s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"PHCCCode")_"】"_Veobj.PHCCCode_" 不存在，"				
			}
			
		}
		
		s MLength=$$$comMemberArrayGet("User.PHCGeneric",$$$cCLASSproperty,"PHCGECode",$$$cPROPparameter,"MAXLEN")
		if $l(Veobj.PHCGECode)>MLength s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"PHCGECode")_"】长度不能超过"_MLength_"，"
		if (ImportType=1)
		{
			//化学通用名代码描述统一校验
			//^DHCPHCM ^DHCPHCMi
			if (Veobj.PHCMCode'="")&&(Veobj.PHCMDesc'="")
			{
				s PHCMRowId=$o(^DHCPHCMi("Code",Veobj.PHCMCode,0))
				if PHCMRowId'=""
				{
					s Desc=$p($g(^DHCPHCM(PHCMRowId)),"^",2)
					if Desc'=Veobj.PHCMDesc
					{
						s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"PHCMCode")_"】"_Veobj.PHCMCode_"与【"_..GetFieldDescByName(ID,"PHCMDesc")_"】"_Veobj.PHCMDesc_"不对应，"
					}
				}
				else
				{
					s PHCMRowId=$o(^DHCPHCMi("Desc",Veobj.PHCMDesc,0))
					if PHCMRowId'="" s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"PHCMDesc")_"】已存在，"				
				}
			}
			
			//处方通用名代码描述统一校验
			s flag=##class(web.DHCBL.CT.PHCGeneric).FormValidate("",Veobj.PHCGECode,"")
			i flag=1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"PHCGECode")_"】已存在，"
			s flag=##class(web.DHCBL.CT.PHCGeneric).FormValidate("","",Veobj.PHCGEName)
			i flag=1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"PHCGEName")_"】已存在，"	
		}
		
		q myVresult
		
	}
	if (tablecode="PHC_DrgMastNew") //药品 新医嘱模式 2018-11-25
	{
		s myVresult=""
		s MLength=$$$comMemberArrayGet("User.PHCDrgMast",$$$cCLASSproperty,"PHCDCode",$$$cPROPparameter,"MAXLEN")
		if $l(Veobj.ARCIMCode)>MLength s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"ARCIMCode")_"】长度不能超过"_MLength_"，"
		s MLength=$$$comMemberArrayGet("User.PHCDrgMast",$$$cCLASSproperty,"PHCDName",$$$cPROPparameter,"MAXLEN")
		if $l(Veobj.ARCIMDesc)>MLength s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"ARCIMDesc")_"】长度不能超过"_MLength_"，"
		i (Veobj.ARCIMDesc["^") s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"ARCIMDesc")_"】不能包含^，"
		/*s Veobj.ARCIMEffDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(Veobj.ARCIMEffDate)
		if (Veobj.ARCIMEffDate'="")&&(Veobj.ARCIMEffDate<+$h) s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"ARCIMEffDate")_"】不能早于今天，"
		s Veobj.INCTRStartDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(Veobj.INCTRStartDate)
		if (Veobj.INCTRStartDate'="")&&(Veobj.INCTRStartDate<+$h) s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"INCTRStartDate")_"】不能早于今天，"
		*/
		s Price= ##class(web.DHCBL.BDP.FunLib).IsNonnegativeNumber(Veobj.Sp)
		IF Price=-1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"Sp")_"】有误，不是数字，"
		
		s Price= ##class(web.DHCBL.BDP.FunLib).IsNonnegativeNumber(Veobj.Rp)
		IF Price=-1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"Rp")_"】有误，不是数字，"
		
		if Veobj.INFOMaxSp'=""
		{
			s Price= ##class(web.DHCBL.BDP.FunLib).IsNonnegativeNumber(Veobj.INFOMaxSp)
			IF Price=-1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"INFOMaxSp")_"】有误，不是数字，"
		}
		if Veobj.INFOPbRp'=""
		{
		
			s Price= ##class(web.DHCBL.BDP.FunLib).IsNonnegativeNumber(Veobj.INFOPbRp)
			IF Price=-1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"INFOPbRp")_"】有误，不是数字，"
		
		}
		/*if (Veobj.INFORemark'="")&&(Veobj.INFORemark'["-")
		{
			s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"INFORemark")_"】需以 - 分隔，"
		
		}*/
		///2020-06-06 云HIS 校验医院
		s validStr= ##class(web.DHCBL.BDP.BDPMappingHOSP).ValidateHospId(tablename,Veobj.LinkHospId)  ///校验医院
		if (validStr'="")
		{
			s myVresult=myVresult_validStr
			q myVresult
		}
		//获取自费费别
		//s InsType= ##class(web.DHCBL.CT.DHCTarItem).GetDefPatInsType(Veobj.LinkHospId)
		//IF InsType="" s myVresult=myVresult_"【患者费别】没有查询到自费，"
		///对于一对一的类组，医嘱项库存项只能一对一。
		s SCGStruModeFlag="N"
		if (Veobj.INCIINCSCDR'="")
		{
			//DHC_StkCatGroup     DHC_StkCatGrpRelations  
			s SCGRowid=$o(^DHCSCG("STKCAT",Veobj.INCIINCSCDR,0))
			if SCGRowid'=""
			{
				s SCGStruModeFlag=$p($g(^DHCSCG(SCGRowid)),"^",7)
				if (SCGStruModeFlag'="Y")
				{
					if (Veobj.ARCIMCode'=Veobj.INCICode)||(Veobj.ARCIMDesc'=Veobj.INCIDesc)
					{
						s myVresult=myVresult_"库存类组模式为一对一时药学项和库存项的代码名称要相同，"
					}
				}
			}
		}
		//2020-11-27 校验库存分类是否关联类型为药品的类组
		s validincsc=##class(web.BDPExt.CYBLL).IsDrugCat(Veobj.INCIINCSCDR)
		if validincsc["-1"
		{
			s myVresult=myVresult_$p(validincsc,"^",2)
		}
		if (ImportType=1)
		{
			if (Veobj.ARCIMCode'="")&&(Veobj.ARCIMDesc'="")
			{
				s RowId=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("PHC_DrgMast",Veobj.ARCIMCode,Veobj.LinkHospId)  //$o(^PHCD(0,"Code",$$ALPHAUP^SSUTIL4(Veobj.ARCIMCode),0))
				if RowId'=""
				{
					s Desc=$p($g(^PHCD(RowId,1)),"^",2)
					if Desc'=Veobj.ARCIMDesc
					{
						s myVresult=myVresult_"【药品代码】"_Veobj.ARCIMCode_"与【名称】"_Veobj.ARCIMDesc_"不对应，"
					}	
					else
					{
						if (SCGStruModeFlag'="Y") s myVresult=myVresult_"【药品代码/名称】已存在，"
					}
					If (Veobj.PHCDGenericDR'="")
					{
						s Generic=$p($g(^PHCD(RowId,4)),"^",1)
						if Generic'=Veobj.PHCDGenericDR
						{
							
							s myVresult=myVresult_"药学项已归属于"_$p($g(^PHCGE("GE",Veobj.PHCDGenericDR)),"^",2)_"，"
						}
					}
					
				}
				else
				{
					s RowId=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByDesc("PHC_DrgMast",Veobj.ARCIMDesc,Veobj.LinkHospId)
					if RowId'="" s myVresult=myVresult_"【药品名称】已存在，"			
				}
				
				//s RowId=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("ARC_ItmMast",Veobj.ARCIMCode,Veobj.LinkHospId)  //$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(Veobj.ARCIMCode),0))
				//20221101限制医嘱项不同院区的代码也不允许相同 HIS8.5.3
				s RowId=##class(web.DHCBL.CT.ARCItmMast).GetRowIdByCode(Veobj.ARCIMCode)
				if RowId'=""
				{
					s Desc=$p($g(^ARCIM($P(RowId,"||",1),$P(RowId,"||",2),1)),"^",2)
					if Desc'=Veobj.ARCIMDesc
					{
						s myVresult=myVresult_"【医嘱代码】"_Veobj.ARCIMCode_"与【名称】"_Veobj.ARCIMDesc_"不对应，"
					}
					else{
						
						if (SCGStruModeFlag'="Y") s myVresult=myVresult_"【医嘱代码/名称】已存在，"
					}	
				}
				else
				{
					s RowId=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByDesc("ARC_ItmMast",Veobj.ARCIMDesc,Veobj.LinkHospId)
					if (RowId'="") s myVresult=myVresult_"【医嘱名称】已存在，"
				}
			}
			
			if (Veobj.INCICode'="")&&(Veobj.INCIDesc'="")
			{
				s RowId=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("INC_Itm",Veobj.INCICode,Veobj.LinkHospId)  //$o(^INCI(0,"Code",$$ALPHAUP^SSUTIL4(Veobj.INCICode),0))
				if RowId'=""
				{
					s Desc=$p($g(^INCI(RowId,1)),"^",2)
					if Desc'=Veobj.INCIDesc
					{
						s myVresult=myVresult_"【库存项代码】"_Veobj.INCICode_"与【名称】"_Veobj.INCIDesc_"不对应，"
					}
					else
					{
						s myVresult=myVresult_"【库存项代码/名称】已存在，"
					}	
				}
				else
				{
					s RowId=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByDesc("INC_Itm",Veobj.INCIDesc,Veobj.LinkHospId)
					if (RowId'="") s myVresult=myVresult_"【库存项名称】已存在，"
				}
				
				s RowId=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("DHC_TarItem",Veobj.TARICode,Veobj.LinkHospId)
				if RowId'=""
				{
					s Desc=$p($g(^DHCTARI(RowId)),"^",2)
					if Desc'=Veobj.INCIDesc
					{
						s myVresult=myVresult_"【收费项代码】"_Veobj.TARICode_"与【名称】"_Veobj.TARIDesc_"不对应，"
					}	
					else
					{
						s myVresult=myVresult_"【收费项代码/名称】已存在，"
					}
				}
				else
				{
					s RowId=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByDesc("DHC_TarItem",Veobj.TARIDesc,Veobj.LinkHospId)
					if (RowId'="") s myVresult=myVresult_"【收费项名称】已存在，"
				}
			}
			
		}
		//入库单位和基本单位
		i (Veobj.INCICTUOMPurchFac'="")&(Veobj.INCICTUOMPurchDR'="")&(Veobj.INCICTUOMDR'="")
		{
			S FacFlag=##class(web.BDPExt.UomBLL).IsExisted(Veobj.INCICTUOMPurchDR,Veobj.INCICTUOMDR,Veobj.INCICTUOMPurchFac)
			//if FacFlag=1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"INCICTUOMPurchDR")_"】和【"_..GetFieldDescByName(ID,"INCICTUOMDR")_"】转换关系不存在，"
			if FacFlag=2 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"INCICTUOMPurchFac")_"】校验失败，"		
		}
		
		//基本单位和药学项基本单位
		i (Veobj.PHCDFCTUOMDR'="")&(Veobj.PHCDFCTUOMFac'="")&(Veobj.INCICTUOMDR'="")
		{
			S FacFlag=##class(web.BDPExt.UomBLL).IsExisted(Veobj.INCICTUOMDR,Veobj.PHCDFCTUOMDR,Veobj.PHCDFCTUOMFac)
			//if FacFlag=1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"INCICTUOMDR")_"】和【"_..GetFieldDescByName(ID,"PHCDFCTUOMDR")_"】转换关系不存在，"
			if FacFlag=2 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"PHCDFCTUOMFac")_"】校验失败，"		
		}
		//门诊发药单位和基本单位
		i (Veobj.INCICTUOMOutPatFac'="")&(Veobj.INCICTUOMOutPatDR'="")&(Veobj.INCICTUOMDR'="")
		{
			S FacFlag=##class(web.BDPExt.UomBLL).IsExisted(Veobj.INCICTUOMOutPatDR,Veobj.INCICTUOMDR,Veobj.INCICTUOMOutPatFac)
			//if FacFlag=1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"INCICTUOMOutPatDR")_"】和【"_..GetFieldDescByName(ID,"INCICTUOMDR")_"】转换关系不存在，"
			if FacFlag=2 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"INCICTUOMOutPatFac")_"】校验失败，"		
		}
		//住院发药单位和基本单位
		i (Veobj.INCICTUOMInPatFac'="")&(Veobj.INCICTUOMInPatDR'="")&(Veobj.INCICTUOMDR'="")
		{
			S FacFlag=##class(web.BDPExt.UomBLL).IsExisted(Veobj.INCICTUOMInPatDR,Veobj.INCICTUOMDR,Veobj.INCICTUOMInPatFac)
			//if FacFlag=1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"INCICTUOMInPatDR")_"】和【"_..GetFieldDescByName(ID,"INCICTUOMDR")_"】转换关系不存在，"
			if FacFlag=2 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"INCICTUOMInPatFac")_"】校验失败，"		
		}
		//等效单位1和等效单位2 2022-06-23
		i (Veobj.EQCTUOMDR1'="")&(Veobj.EQCTUOMDR2=Veobj.EQCTUOMDR1)
		{
			s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"EQCTUOMDR1")_"】和【"_..GetFieldDescByName(ID,"EQCTUOMDR2")_"】不允许相同，"
					
		}
		if (Veobj.PHCDFCHPhSpecInstr'="")
		{
			//s validret=##class(web.DHCST.Tools.InputDrugBasicData).validCHPhSpecInstr(Veobj.PHCDFCHPhSpecInstr)
			s validret=##class(PHA.TOOLS.Import.Drug).ValidCHPhSpecInstr(Veobj.PHCDFCHPhSpecInstr,Veobj.LinkHospId) //2020-12-31
			i validret<0 d
			.i validret=-1 s myVresult=myVresult_"【草药备注】字典不存在，"
			.e  i validret=-2 s myVresult=myVresult_"【草药备注】"_Veobj.PHCDFCHPhSpecInstr_"不存在，"
		}
		///校验类型是G
		i Veobj.PHCDPHMNFDR'="" //厂商
		{
			 s MANFRowid=$o(^DHCMANF(0,"MANF",Veobj.PHCDPHMNFDR,0))  //2021-01-04校验类型
			if MANFRowid'=""
			{
				s MANFType=$p($g(^DHCMANF(MANFRowid)),"^",7)
				if MANFType'="G" s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"PHCDPHMNFDR")_"】类型不是G，"
				
			}
		}
		i Veobj.INFOPbManfDR'="" //招标厂商
		{
			 s MANFRowid=$o(^DHCMANF(0,"MANF",Veobj.INFOPbManfDR,0))  //2021-01-04校验类型
			if MANFRowid'=""
			{
				s MANFType=$p($g(^DHCMANF(MANFRowid)),"^",7)
				if MANFType'="G" s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"INFOPbManfDR")_"】类型不是G，"	
			}
		}
		i Veobj.INFOPbVendorDR'=""  //招标供应商
		{
			s APCVMType=$p($g(^APC("APCVM",Veobj.INFOPbVendorDR)),"^",9)  //2021-01-04 校验类型
			if APCVMType'="G" s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"INFOPbVendorDR")_"】类型不是G，"
		}
		i Veobj.INFOPbCarrierDR'=""  // 招标配送商
		{
			s CAType=$p($g(^DHCCARR(Veobj.INFOPbCarrierDR)),"^",3)  //2021-01-04 校验类型
			if CAType'="G" s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"INFOPbCarrierDR")_"】类型不是G，"
		}
		i Veobj.INFOOrigin'=""  //产地  //2022-05-13
		{
			s OrigType=$p($g(^DHCSTORI(Veobj.INFOOrigin)),"^",3)  //校验类型
			if OrigType'="G" s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"INFOOrigin")_"】类型不是G，"
		}
		//2019-03-27库存项别名
		s INCALIAS=$tr(Veobj.INCALIAS," ","")
		if (INCALIAS'="")
		{
			s Len=$l(INCALIAS,"/")
		    f i=1:1:Len
		    {
		   		s alias=$p(INCALIAS,"/",i)
		   		///2019-03-27
		   		s MLength=$$$comMemberArrayGet("User.INCALIAS",$$$cCLASSproperty,"INCATEXT",$$$cPROPparameter,"MAXLEN")
				if $l(alias)>MLength s myVresult="【"_..GetFieldDescByName(ID,"Alias")_"】超长，"
		
		    	if $$ALPHAUP^SSUTIL4(alias)="" 
		    	{
			    	s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"INCALIAS")_"】"_Veobj.INCALIAS_" 校验失败，"	
			    	q 
		    	}
		    }
		}
		else
		{
			s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"INCALIAS")_"】为必填项，"	
		}
		
		//2020-03-06 医嘱项别名
		s ALIASText=$tr(Veobj.ALIASText," ","")
		if (ALIASText'="")
		{
			s Len=$l(ALIASText,"/")
		    f i=1:1:Len
		    {
		   		s alias=$p(ALIASText,"/",i)
		   		s MLength=$$$comMemberArrayGet("User.ARCAlias",$$$cCLASSproperty,"ALIASText",$$$cPROPparameter,"MAXLEN")
				if $l(alias)>MLength s myVresult="【"_..GetFieldDescByName(ID,"ALIASText")_"】超长，"
		    	if $$ALPHAUP^SSUTIL4(alias)="" 
		    	{
			    	s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"ALIASText")_"】 校验失败，"	
			    	q 
		    	}
		    }
		}
		else
		{
			s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"ALIASText")_"】为必填项，"	
		}
		
		//单次剂量偏好：H-偏好取半(即不足一半取半,足够一半取整), FD-偏好向下取整(即不为整数则向下取整，最小值不低于1),FU-偏好向上取整(即不为整数则向上取整),A-按实际单次剂量计算
		s Veobj.DARCIMPartialValue=$case(Veobj.DARCIMPartialValue,"偏好取半":"H","偏好向下取整":"FD","偏好向上取整":"FU","":"FU","按实际单次剂量计算":"A",:Veobj.DARCIMPartialValue)  //空时默认"偏好向上取整"
		if (Veobj.DARCIMPartialValue'="H")&&(Veobj.DARCIMPartialValue'="FD")&&(Veobj.DARCIMPartialValue'="FU")&&(Veobj.DARCIMPartialValue'="A")&&(Veobj.DARCIMPartialValue'="") s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"DARCIMPartialValue")_"】校验失败，"
		
		//高危级别(A/B/C)
		if (Veobj.PHCDFHighRisk'="A")&&(Veobj.PHCDFHighRisk'="B")&&(Veobj.PHCDFHighRisk'="C")&&(Veobj.PHCDFHighRisk'="") s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"PHCDFHighRisk")_"】要求为A/B/C，"
		
		//抗肿瘤药物级别（O - 普通级，S - 限制级）
		if (Veobj.PHCDFAntiLevSCDIDr'="O")&&(Veobj.PHCDFAntiLevSCDIDr'="S")&&(Veobj.PHCDFAntiLevSCDIDr'="") s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"PHCDFAntiLevSCDIDr")_"】要求为O/S，"
	
		q myVresult
		
		
	}
	
	//医嘱项  医改
	if (tablecode="ARCItmMast")  
	{
		s myVresult=""
		s MLength=$$$comMemberArrayGet("User.ARCItmMast",$$$cCLASSproperty,"ARCIMCode",$$$cPROPparameter,"MAXLEN")
		if $l(Veobj.ARCIMCode)>MLength s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"ARCIMCode")_"】长度不能超过"_MLength_"，"
		s MLength=$$$comMemberArrayGet("User.ARCItmMast",$$$cCLASSproperty,"ARCIMDesc",$$$cPROPparameter,"MAXLEN")
		if $l(Veobj.ARCIMDesc)>MLength s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"ARCIMDesc")_"】长度不能超过"_MLength_"，"
		//20170814 校验服务资源组数据有效性
		IF (Veobj.ARCIMServMaterial'="M")&&(Veobj.ARCIMServMaterial'="S")&&(Veobj.ARCIMServMaterial'="") s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"ARCIMServMaterial")_"】只能设置为S或者M或者空，"
		///2020-06-06 云HIS 校验医院
		s validStr= ##class(web.DHCBL.BDP.BDPMappingHOSP).ValidateHospId(tablename,Veobj.LinkHospId)  ///校验医院
		if (validStr'="")
		{
			s myVresult=myVresult_validStr
			q myVresult
		}
		if (ImportType=1)
		{
			s flag=##class(web.DHCBL.CT.ARCItmMast).FormValidate("",Veobj.ARCIMCode,"",Veobj.LinkHospId)
			i flag=1 s myVresult=myVresult_ "医嘱项代码已存在，"
			s flag=##class(web.DHCBL.CT.ARCItmMast).FormValidate("","",Veobj.ARCIMDesc,Veobj.LinkHospId)
			i flag=1 s myVresult=myVresult_"医嘱项描述已存在，"	
		}
		
		q myVresult
	}
	
	//医嘱项与收费项关联  医改 //2019-02-24
	if (tablecode="DHC_OrderLinkTar")  
	{
		///2020-06-06 云HIS 校验医院
		s validStr= ##class(web.DHCBL.BDP.BDPMappingHOSP).ValidateHospId(tablename,Veobj.LinkHospId)  ///校验医院
		if (validStr'="")
		{
			s myVresult=myVresult_validStr
			q myVresult
		}
		/*s ARCIMRowId=""
		s sub=0
		for
		{
			s sub=$O(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(Veobj.OLTARCCode),sub)) q:sub=""
			s version=0
			for
			{
				s version=$O(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(Veobj.OLTARCCode),sub,version)) q:version=""
				s Value=$p($g(^ARCIM(sub,version,1)),"^",1)
				IF (Value=Veobj.OLTARCCode)
				{
					 S ARCIMRowId=sub_"||"_version
				}
			}
		}*/
		S ARCIMRowId=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("ARC_ItmMast",Veobj.OLTARCCode,Veobj.LinkHospId)
		if ARCIMRowId=""
		{
			s myVresult=myVresult_ "医嘱项 "_Veobj.OLTARCCode_" 不存在，"
		}
		else
		{
			S Desc=$p($g(^ARCIM($p(ARCIMRowId,"||",1),$p(ARCIMRowId,"||",2),1)),"^",2)
			if (Veobj.OLTARCDesc'=Desc)
			{
				s myVresult=myVresult_ "医嘱项代码和描述不对应，"
			}	
		}
		
		//s TARIRowId=$o(^DHCTARI(0,"Code",Veobj.OLTTARCode,0)) 
		s TARIRowId=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("DHC_TarItem",Veobj.OLTTARCode,Veobj.LinkHospId)
		if (TARIRowId="")
		{
			s myVresult=myVresult_ "收费项 "_Veobj.OLTTARCode_" 不存在，"
		}
		else
		{
			S Desc=$p($g(^DHCTARI(TARIRowId)),"^",2)
			if (Veobj.OLTTARDesc'=Desc)
			{
				s myVresult=myVresult_ "收费项代码和描述不对应，"
			}	
		}
		s:Veobj.OLTStartDate'="" Veobj.OLTStartDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(Veobj.OLTStartDate)
		if (Veobj.OLTStartDate'="")&&(Veobj.OLTStartDate<+$h) s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"OLTStartDate")_"】不能早于今天，"
		If (Veobj.OLTStartDate=+$h)&&(ARCIMRowId'="")&&(TARIRowId'="")
		{
			s usernum=0
			s oeordrowid=0
			for
			{
				s oeordrowid=$o(^OEORDi(0,"ItemDate",+$h,oeordrowid)) q:(oeordrowid="")||(usernum=1)
				q:oeordrowid=0
				if $d(^OEORDi(0,"ARCIM",oeordrowid,ARCIMRowId))>0 s usernum=1	
			}
			if (usernum=1) s myVresult=myVresult_"该医嘱今日已经被使用，对照开始日期不能等于今天，"
			
		}
		If (ARCIMRowId'="")&&(TARIRowId'="")
		{
			s linkedflag=0
			s StartDate=0
	 		for 
	 		{
		 		s StartDate=$o(^DHCOLT(0,"ARTTA",ARCIMRowId,TARIRowId,StartDate)) q:StartDate="" 
		 		s linkid=0
		 		for
		 		{
			 		s linkid=$o(^DHCOLT(0,"ARTTA",ARCIMRowId,TARIRowId,StartDate,linkid)) q:linkid="" 
			 		s EndDate=$p($g(^DHCOLT(linkid)),"^",5)
			 		///if ((EndDate>+$h)||(EndDate=""))&((OLTRowId="")||((OLTRowId'="")&(linkid'=OLTRowId))) s result="医嘱项与该收费项目已经关联！"
			 		///if ((EndDate>=stdate)||(EndDate=""))&((OLTRowId="")||((OLTRowId'="")&(linkid'=OLTRowId))) s result="医嘱项与该收费项目已经关联！"
			 		if ((EndDate>=Veobj.OLTStartDate)||(EndDate="")) s linkedflag=1
		 		}
	 		}
			if (linkedflag=1) s myVresult=myVresult_"医嘱项与该收费项目已经关联，"
			
		}
		Q myVresult
			
	}
	
	if (tablecode="EndARCItmMast")  //批量废除医嘱项 2019-02-24
	{
		
		s myVresult=""
		s:Veobj.ARCIMEffDateTo'="" Veobj.ARCIMEffDateTo= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(Veobj.ARCIMEffDateTo)
		if (Veobj.ARCIMEffDateTo'="")&&(Veobj.ARCIMEffDateTo<+$h) s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"ARCIMEffDateTo")_"】不能早于今天，"
		///2020-06-06 云HIS 校验医院
		s validStr= ##class(web.DHCBL.BDP.BDPMappingHOSP).ValidateHospId(tablename,Veobj.LinkHospId)  ///校验医院
		if (validStr'="")
		{
			s myVresult=myVresult_validStr
			q myVresult
		}
		/*s ARCIMRowId=""
		s sub=0
		for
		{
			s sub=$O(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(Veobj.ARCIMCode),sub)) q:sub=""
			s version=0
			for
			{
				s version=$O(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(Veobj.ARCIMCode),sub,version)) q:version=""
				s Value=$p($g(^ARCIM(sub,version,1)),"^",1)
				IF (Value=Veobj.ARCIMCode)
				{
					 S ARCIMRowId=sub_"||"_version
				}
			}
		}*/
		S ARCIMRowId=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("ARC_ItmMast",Veobj.ARCIMCode,Veobj.LinkHospId)
		if ARCIMRowId=""
		{
			s myVresult=myVresult_"医嘱项 "_Veobj.ARCIMCode_" 不存在，"
		}
		else
		{
			S Desc=$p($g(^ARCIM($p(ARCIMRowId,"||",1),$p(ARCIMRowId,"||",2),1)),"^",2)
			if (Veobj.ARCIMDesc'=Desc)
			{
				s myVresult=myVresult_"医嘱项代码和描述不对应，"
			}
			s ARCIMEffDate=$p($g(^ARCIM($p(ARCIMRowId,"||",1),$p(ARCIMRowId,"||",2),1)),"^",13)       ; 开始日期
		  	s:ARCIMEffDate'="" ARCIMEffDate=$p(ARCIMEffDate,"Z",1)
			s:ARCIMEffDate'="" ARCIMEffDate=$p(ARCIMEffDate,",",1)
			if (Veobj.ARCIMEffDateTo<ARCIMEffDate)
			{
				s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"ARCIMEffDateTo")_"】不能早于开始日期"_##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ARCIMEffDate)_"，"
			}
			S DateTo=$p($g(^ARCIM($p(ARCIMRowId,"||",1),$p(ARCIMRowId,"||",2),7)),"^",1)
			if (DateTo'="")
			{
				if $l(DateTo<7) s myVresult=myVresult_"医嘱项已经停用到"_$zd(DateTo,3)_"，"
				else  s myVresult=myVresult_"医嘱项已经停用到"_DateTo_"，"
			}	
			
			
		}	
		Q myVresult
	}
	if (tablecode="EndDHCTarItem")  //批量废除收费项及 关联的医嘱项  2019-02-24
	{
		s myVresult=""
		s Veobj.TARIEndDate= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(Veobj.TARIEndDate)
		if (Veobj.TARIEndDate'="")&&(Veobj.TARIEndDate<+$h) s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"TARIEndDate")_"】不能早于今天，"
		///2020-06-06 云HIS 校验医院
		s validStr= ##class(web.DHCBL.BDP.BDPMappingHOSP).ValidateHospId(tablename,Veobj.LinkHospId)  ///校验医院
		if (validStr'="")
		{
			s myVresult=myVresult_validStr
			q myVresult
		}
		//s TARIRowId=$o(^DHCTARI(0,"Code",Veobj.TARICode,0)) 
		s TARIRowId=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("DHC_TarItem",Veobj.TARICode,Veobj.LinkHospId)
		if (TARIRowId="")
		{
			s myVresult=myVresult_"收费项"_Veobj.TARICode_" 不存在，"
		}
		else
		{
			s TARIStartDate=$p($g(^DHCTARI(TARIRowId)),"^",11)       ; 开始日期
		  	if (Veobj.TARIEndDate<TARIStartDate)
			{
				s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"TARIEndDate")_"】不能早于开始日期"_##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(TARIStartDate)_"，"
			}
			
			S Desc=$p($g(^DHCTARI(TARIRowId)),"^",2)
			if (Veobj.TARIDesc'=Desc)
			{
				s myVresult=myVresult_"收费项代码和描述不对应，"
			}
			
			s dateunvflag=0
			s OLTStartDate=0
			for
			{
				s OLTStartDate=$o(^DHCOLT(0,"TAR",TARIRowId,OLTStartDate)) Quit:OLTStartDate=""
				s OLTRowId=0
				for
				{
					s OLTRowId=$o(^DHCOLT(0,"TAR",TARIRowId,OLTStartDate,OLTRowId)) Quit:OLTRowId=""
					s EndDate=$p($g(^DHCOLT(OLTRowId)),"^",5)
					if (EndDate="")
					{
						if (Veobj.TARIEndDate<OLTStartDate)
						{
							s dateunvflag=1,sss=1
						}
					}
					else
					{
						if (Veobj.TARIEndDate<EndDate) s dateunvflag=1
					}
				}
			}
			if (dateunvflag=1) s myVresult=myVresult_"收费项与医嘱项的对照关系有部分已截止过，"
			
		}
		Q myVresult
	}
	
	///医嘱套 2019-04-16
	if (tablecode="ARC_OrdSets")
	{
		s myVresult=""
		s MLength=$$$comMemberArrayGet("User.ARCOrdSets",$$$cCLASSproperty,"ARCOSCode",$$$cPROPparameter,"MAXLEN")
		if $l(Veobj.ARCOSCode)>MLength s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"ARCOSCode")_"】长度不能超过"_MLength_"，"
		s MLength=$$$comMemberArrayGet("User.ARCOrdSets",$$$cCLASSproperty,"ARCOSDesc",$$$cPROPparameter,"MAXLEN")
		if $l(Veobj.ARCOSDesc)>MLength s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"ARCOSDesc")_"】长度不能超过"_MLength_"，"
		
		//s ARCOSRowId=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("ARC_OrdSets",Veobj.ARCOSCode,Veobj.FavUseHospDr)
		s ARCOSRowId=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("ARC_OrdSets",Veobj.ARCOSCode,Veobj.FavUseHospDr) //20230223 医嘱套表里调用mac限制代码要唯一
		if (ARCOSRowId="")   //新增医嘱套
		{
			
			if Veobj.Alias="" s myVresult=myVresult_"新增医嘱项别名不能为空，"
			if (Veobj.ARCOSOrdSubCatDR'="")
			{
				s ARCICOrdCatDR=$p($g(^ARC("IC",Veobj.ARCOSOrdSubCatDR)),"^",8)
				if (Veobj.ARCOSOrdCatDR'=ARCICOrdCatDR)
				{
					s myVresult=myVresult_"医嘱大类和医嘱子类不匹配，"
				}
			}
			if Veobj.FavUserDr'=""
			{
				s Desc=$p($g(^SSU("SSUSR",Veobj.FavUserDr)),"^",2)
				if (Desc'=Veobj.FavUserDrDesc)
				{
					s myVresult=myVresult_"个人工号和名称不匹配，"	
				}
				
				s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("SS_User",Veobj.FavUserDr,Veobj.FavUseHospDr)
				if showflag="N" s myVresult=myVresult_"用户ID不属于此医院，"
							
			}
		}
		else  ///已经有医嘱套，追加关联项目或者别名。
		{
			s ARCOSDesc=$p($g(^ARCOS(ARCOSRowId)),"^",2)
			if (Veobj.ARCOSDesc'=ARCOSDesc)
			{
				s myVresult=myVresult_"医嘱套代码和名称不匹配，"
			}	
			
			s ARCOSOrdCatDR=$p($g(^ARCOS(ARCOSRowId)),"^",8)
			if (Veobj.ARCOSOrdCatDR'=ARCOSOrdCatDR)
			{
				s myVresult=myVresult_ "医嘱套医嘱大类与数据库中数据不匹配，"
			}
			
			s ARCOSOrdSubCatDR=$p($g(^ARCOS(ARCOSRowId)),"^",9)
			if (Veobj.ARCOSOrdSubCatDR'=ARCOSOrdSubCatDR)
			{
				s myVresult=myVresult_ "医嘱套医嘱子类与数据库中数据不匹配，"
			}
		}
		if (Veobj.Type'="")
		{
			
			if (Veobj.Type'="医嘱项")&&(Veobj.Type'="医嘱套") s myVresult=myVresult_ "项目类型只能是‘医嘱项’或‘医嘱套’，"
			if (Veobj.Type="医嘱套")
			{
				
				IF (Veobj.ARCIMCode="")||(Veobj.ARCIMCode="")
				{
					s myVresult=myVresult_ "项目代码和名称不能为空，"
				}
				else
				{
					s arcosid=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("ARC_OrdSets",Veobj.ARCIMCode,Veobj.FavUseHospDr)
					if arcosid'=""
					{
						s Desc=$p($g(^ARCOS(arcosid)),"^",2)
						if (Desc'=Veobj.ARCIMDesc) s myVresult=myVresult_"项目代码和名称不匹配，"
						if (ImportType=1)
						{
							if (ARCOSRowId'="")
							{
								s DATEChildSub=$O(^ARCOS(ARCOSRowId,"DATE",""),-1)
								if DATEChildSub'=""
								{
									s flag=0
									s ChildSub=0
									for
									{
										s ChildSub=$o(^ARCOS(ARCOSRowId,"DATE",DATEChildSub,"OS",ChildSub)) q:ChildSub=""
										s OSOrderSetDR=$p($g(^ARCOS(ARCOSRowId,"DATE",DATEChildSub,"OS",ChildSub)),"^",1)
										if OSOrderSetDR=arcosid
										{
											s flag=1
										}
									}
									if (flag=1) s myVresult=myVresult_ "医嘱套与此医嘱套对应关系已存在，"	
								}
							}	
						}
					}
					else
					{
						s myVresult=myVresult_"项目代码不存在，"
					}
				}
				
			}
			
			if (Veobj.Type="医嘱项")
			{
				//数量
				if (Veobj.ITMQty="")
				{
					s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"ITMQty")_"】不能为空，"
				}
				else
				{
					s Flag=##class(web.DHCBL.BDP.FunLib).IsNonnegativeNumber(Veobj.ITMQty)
					IF Flag=-1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"ITMQty")_"】有误，"
				}
				///序列号
				if (Veobj.ITMSerialNo="")
				{
					s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"ITMSerialNo")_"】不能为空，"
				}
				else
				{
					s Flag=##class(web.DHCBL.BDP.FunLib).IsNonnegativeNumber(Veobj.ITMSerialNo)
					if Flag=-1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"ITMSerialNo")_"】有误，"
				}
				
				
				//剂量单位
				if (Veobj.ITMDoseQty'="")
				{
					s Flag= ##class(web.DHCBL.BDP.FunLib).IsNonnegativeNumber(Veobj.ITMDoseQty)
					IF Flag=-1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"ITMDoseQty")_"】有误，"
				}
				
				///关联
				if Veobj.ITMLinkToVisibleItem'=""
				{
					s Flag= ##class(web.DHCBL.BDP.FunLib).IsNonnegativeNumber(Veobj.ITMLinkToVisibleItem)
					IF Flag=-1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"ITMLinkToVisibleItem")_"】有误，"
				}	
				
				s Remarks1=$CASE(Veobj.Remarks,"取药医嘱":"ONE","出院带药":"OUT","PRN":"PRN","自备药":"OM","嘱托":"ZT",:"")  //附加说明
				if (Veobj.Remarks'="")&&(Remarks1="") s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"Remarks")_"】 "_Veobj.Remarks_" 校验失败，"
			
				s ITMStage1=$CASE(Veobj.ITMStage,"术前":"SQ","术中":"SZ","术后":"SH","产中":"CZ",:"")  //医嘱阶段
				if (Veobj.ITMStage'="")&&(ITMStage1="") s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"ITMStage")_"】 "_Veobj.ITMStage_" 校验失败，"
			
				if (Veobj.ARCIMCode="")||(Veobj.ARCIMCode="")
				{
					s myVresult=myVresult_ "项目代码和名称不能为空，"
				}
				else
				{
					s arcimparref=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("ARC_ItmMast",Veobj.ARCIMCode,Veobj.FavUseHospDr)
					if arcimparref=""
					{
						s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"ARCIMCode")_"】 "_"不存在，"
					}
					else
					{
						
						s Desc=$p($g(^ARCIM(+arcimparref,1,1)),"^",2)
						if (Desc'=Veobj.ARCIMDesc) s myVresult=myVresult_"医嘱项代码和描述不匹配，"
						
						if (ImportType=1)
						{
							if (ARCOSRowId'="")
							{
								s DATEChildSub=$O(^ARCOS(ARCOSRowId,"DATE",""),-1)
								if DATEChildSub'=""
								{
									s flag=0 
									s ChildSub=0
									for
									{
										s ChildSub=$o(^ARCOS(ARCOSRowId,"DATE",DATEChildSub,"ITM",ChildSub)) q:ChildSub=""
										s ARCIMDR=$p($g(^ARCOS(ARCOSRowId,"DATE",DATEChildSub,"ITM",ChildSub)),"^",1)
										if ARCIMDR=(arcimparref_"||"_1)
										{
											s flag=1
										}
									}
									if (flag=1) s myVresult=myVresult_ "医嘱套与此医嘱项对应关系已存在，"	
								}
							}
						}
					}
				}
				
			}
				
		}
		
		
	}
	
	///医嘱打包项 2019-04-28  友谊医院
	if (tablecode="INSU_ContrastSub")
	{
		s myVresult=""
		s parref=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(Veobj.INCONHisCode),0))
		if (parref'="")
		{
			s Desc=$p($g(^ARCIM(parref,1,1)),"^",2)
			if (Desc'=Veobj.INCONHisDesc) s myVresult=myVresult_"医院项目代码和描述不对应，"
		}
		else
		{
			s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"INCONHisCode")_"】 "_"不存在，"	
		}
		
		if Veobj.INCOSInsuCode'=""
		{
			s parref=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(Veobj.INCOSInsuCode),0))
			if (parref'="")
			{
				s Desc=$p($g(^ARCIM(parref,1,1)),"^",2)
				if (Desc'=Veobj.INCOSInsuDesc) s myVresult=myVresult_"医院项目代码和描述不对应，"
			}
			else
			{
				s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"INCOSInsuCode")_"】 "_"不存在，"	
			}
			
			if Veobj.INCOSQty=""
			{
				s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"INCOSQty")_"】 "_"不能为空，"				
			}	
		}
		else
		{
			if Veobj.INCONInsuCode=""
			{
				s myVresult=myVresult_"关联数据不能为空，"				
			}
			else
			{
				if Veobj.INCONInsuDesc=""
				{
					s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"INCONInsuDesc")_"】 "_"不能为空，"		
				}
				
			}	
		}
	}
	if (tablecode="dbo.BT_TestCodeSCode")	//2020-3-18 钟荣枫 检验-标准码	
	{
		s MLength=$$$comMemberArrayGet("dbo.BTTestCodeSCode",$$$cCLASSproperty,"SCode",$$$cPROPparameter,"MAXLEN")
		//代码长度
		if $l(Veobj.SCode)>MLength s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"SCode")_"】长度不能超过"_MLength_"，"
		s MLength=$$$comMemberArrayGet("dbo.BTTestCodeSCode",$$$cCLASSproperty,"SpecimenType",$$$cPROPparameter,"MAXLEN")
		//类型长度
		if $l(Veobj.SpecimenType)>MLength s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"SpecimenType")_"】长度不能超过"_MLength_"，"
		//激活
		if (Veobj.Active'="")&&(Veobj.Active'=0)&&(Veobj.Active'=1) s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"Active")_"】的值只能为0或1，"
		q myVresult
	}
	if (tablecode="dbo.BT_Hospital")	//2020-1-10 钟荣枫 检验-医院	
	{
		s MLength=$$$comMemberArrayGet("dbo.BTHospital",$$$cCLASSproperty,"Code",$$$cPROPparameter,"MAXLEN")
		//代码长度
		if $l(Veobj.Code)>MLength s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"Code")_"】长度不能超过"_MLength_"，"
		s MLength=$$$comMemberArrayGet("dbo.BTHospital",$$$cCLASSproperty,"CName",$$$cPROPparameter,"MAXLEN")
		//描述长度
		if $l(Veobj.CName)>MLength s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"CName")_"】长度不能超过"_MLength_"，"
		//激活
		if (Veobj.Active'="")&&(Veobj.Active'=0)&&(Veobj.Active'=1) s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"Active")_"】的值只能为0或1，"
		q myVresult
	}
	if (tablecode="dbo.BT_Species")	//2020-1-10 钟荣枫 检验-性别
	{
		s MLength=$$$comMemberArrayGet("dbo.BTSpecies",$$$cCLASSproperty,"Code",$$$cPROPparameter,"MAXLEN")
		//代码长度
		if $l(Veobj.Code)>MLength s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"Code")_"】长度不能超过"_MLength_"，"
		s MLength=$$$comMemberArrayGet("dbo.BTSpecies",$$$cCLASSproperty,"HISCode",$$$cPROPparameter,"MAXLEN")
		//HIS代码长度
		if $l(Veobj.HISCode)>MLength s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"HISCode")_"】长度不能超过"_MLength_"，"
		s MLength=$$$comMemberArrayGet("dbo.BTSpecies",$$$cCLASSproperty,"STDCode",$$$cPROPparameter,"MAXLEN")
		//STD代码长度
		if $l(Veobj.STDCode)>MLength s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"STDCode")_"】长度不能超过"_MLength_"，"
		q myVresult
	}
	if (tablecode="dbo.BT_Room")	//2020-1-10 钟荣枫 检验-房间
	{
		s MLength=$$$comMemberArrayGet("dbo.BTRoom",$$$cCLASSproperty,"Code",$$$cPROPparameter,"MAXLEN")
		//代码长度
		if $l(Veobj.Code)>MLength s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"Code")_"】长度不能超过"_MLength_"，"
		//激活
		if (Veobj.Active'="")&&(Veobj.Active'=0)&&(Veobj.Active'=1) s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"Active")_"】的值只能为0或1，"
		
		s HospitalDesc=$lg($g(^dbo.BTHospitalD(Veobj.HospitalDR)),3)
		if HospitalDesc'=Veobj.HospitalDesc		//医院代码和描述不匹配
		{
			s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"HospitalDesc")_"】和医院代码不匹配，"
		}
		
		q myVresult
	}
	if (tablecode="dbo.BT_Department")	//2020-1-10 钟荣枫 检验-科室
	{
		s MLength=$$$comMemberArrayGet("dbo.BTDepartment",$$$cCLASSproperty,"Code",$$$cPROPparameter,"MAXLEN")
		//代码长度
		if $l(Veobj.Code)>MLength s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"Code")_"】长度不能超过"_MLength_"，"
		//激活
		if (Veobj.Active'="")&&(Veobj.Active'=0)&&(Veobj.Active'=1) s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"Active")_"】的值只能为0或1，"
		s HospitalDesc=$lg($g(^dbo.BTHospitalD(Veobj.HospitalDR)),3)
		if HospitalDesc'=Veobj.HospitalDesc		//医院代码和描述不匹配
		{
			s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"HospitalDesc")_"】和医院代码不匹配，"
		}
			
		q myVresult
	}
	if (tablecode="dbo.BT_CollectPrompt")	//2020-1-10 钟荣枫 检验-采集提示
	{
		s MLength=$$$comMemberArrayGet("dbo.BTCollectPrompt",$$$cCLASSproperty,"Code",$$$cPROPparameter,"MAXLEN")
		//代码长度
		if $l(Veobj.Code)>MLength s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"Code")_"】长度不能超过"_MLength_"，"
		//激活
		if (Veobj.Active'="")&&(Veobj.Active'=0)&&(Veobj.Active'=1) s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"Active")_"】的值只能为0或1，"
		s HospitalDesc=$lg($g(^dbo.BTHospitalD(Veobj.HospitalDR)),3)
		if HospitalDesc'=Veobj.HospitalDesc		//医院代码和描述不匹配
		{
			s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"HospitalDesc")_"】和医院代码不匹配，"
		}
		q myVresult
	}
	if (tablecode="dbo.BT_TestCode")	//2020-3-17 杨帆 检验-检验项目
	{
		s MLength=$$$comMemberArrayGet("dbo.BTTestCode",$$$cCLASSproperty,"Code",$$$cPROPparameter,"MAXLEN")
		//代码长度
		if $l(Veobj.Code)>MLength s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"Code")_"】长度不能超过"_MLength_"，"
		
		s MLength=$$$comMemberArrayGet("dbo.BTTestCode",$$$cCLASSproperty,"SCode",$$$cPROPparameter,"MAXLEN")
		//标标准码代码长度
		if $l(Veobj.SCode)>MLength s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"SCode")_"】长度不能超过"_MLength_"，"
		//激活
		if (Veobj.Active'="")&&(Veobj.Active'=0)&&(Veobj.Active'=1) s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"Active")_"】的值只能为0或1，"
		s HospitalDesc=$lg($g(^dbo.BTHospitalD(Veobj.HospitalDR)),3)
		if HospitalDesc'=Veobj.HospitalDesc		//医院代码和描述不匹配
		{
			s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"HospitalDesc")_"】和医院代码不匹配，"
		}
		s SCodeDesc=""
		s:Veobj.SCode'="" SCodeDesc=$lg($g(^dbo.BTTestCodeSCodeD(Veobj.SCode)),3)
		if SCodeDesc'=Veobj.SCodeDesc		//标准码代码和描述不匹配
		{
			s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"SCodeDesc")_"】和标准码代码不匹配，"
		}
		q myVresult
	}
	if (tablecode="dbo.BT_ReportPrompt")	//2020-1-10 钟荣枫 检验-取报告提示
	{
		s MLength=$$$comMemberArrayGet("dbo.BTReportPrompt",$$$cCLASSproperty,"Code",$$$cPROPparameter,"MAXLEN")
		//代码长度
		if $l(Veobj.Code)>MLength s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"Code")_"】长度不能超过"_MLength_"，"
		//激活
		if (Veobj.Active'="")&&(Veobj.Active'=0)&&(Veobj.Active'=1) s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"Active")_"】的值只能为0或1，"
		s HospitalDesc=$lg($g(^dbo.BTHospitalD(Veobj.HospitalDR)),3)
		if HospitalDesc'=Veobj.HospitalDesc		//医院代码和描述不匹配
		{
			s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"HospitalDesc")_"】和医院代码不匹配，"
		}
		q myVresult
	}
	if (tablecode="dbo.BT_Container")	//2020-1-10 钟荣枫 检验-采集容器
	{
		s MLength=$$$comMemberArrayGet("dbo.BTContainer",$$$cCLASSproperty,"Code",$$$cPROPparameter,"MAXLEN")
		//代码长度
		if $l(Veobj.Code)>MLength s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"Code")_"】长度不能超过"_MLength_"，"
		//激活
		if (Veobj.Active'="")&&(Veobj.Active'=0)&&(Veobj.Active'=1) s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"Active")_"】的值只能为0或1，"
		s HospitalDesc=$lg($g(^dbo.BTHospitalD(Veobj.HospitalDR)),3)
		if HospitalDesc'=Veobj.HospitalDesc		//医院代码和描述不匹配
		{
			s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"HospitalDesc")_"】和医院代码不匹配，"
		}
		q myVresult
	}
	if (tablecode="dbo.BT_Specimen")	//2020-1-10 钟荣枫 检验-标本类型
	{
		s MLength=$$$comMemberArrayGet("dbo.BTSpecimen",$$$cCLASSproperty,"Code",$$$cPROPparameter,"MAXLEN")
		//代码长度
		if $l(Veobj.Code)>MLength s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"Code")_"】长度不能超过"_MLength_"，"
		s MLength=$$$comMemberArrayGet("dbo.BTSpecimen",$$$cCLASSproperty,"WCode",$$$cPROPparameter,"MAXLEN")
		//whonet码长度
		if $l(Veobj.WCode)>MLength s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"WCode")_"】长度不能超过"_MLength_"，"
		s MLength=$$$comMemberArrayGet("dbo.BTSpecimen",$$$cCLASSproperty,"HISCode",$$$cPROPparameter,"MAXLEN")
		//HIS对照码长度
		if $l(Veobj.HISCode)>MLength s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"HISCode")_"】长度不能超过"_MLength_"，"
		// 激活
		if (Veobj.Active'="")&&(Veobj.Active'=0)&&(Veobj.Active'=1) s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"Active")_"】的值只能为0或1，"
		s HospitalDesc=$lg($g(^dbo.BTHospitalD(Veobj.HospitalDR)),3)
		if HospitalDesc'=Veobj.HospitalDesc		//医院代码和描述不匹配
		{
			s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"HospitalDesc")_"】和医院代码不匹配，"
		}
		s SpecimenGroupDesc=""
		s:(Veobj.SpecimenGroupDR'="") SpecimenGroupDesc=$lg($g(^dbo.BTSpecimenGroupD(Veobj.SpecimenGroupDR)),3)
		
		if SpecimenGroupDesc'=Veobj.SpecimenGroupDesc	//标本组代码和描述不匹配
		{
			s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"SpecimenGroupDesc")_"】和标本组代码不匹配，"
		}
			
		q myVresult
	}
	if (tablecode="dbo.BT_SpecimenGroup")	//2020-1-10 钟荣枫 检验-标本组
	{
		s MLength=$$$comMemberArrayGet("dbo.BTSpecimenGroup",$$$cCLASSproperty,"Code",$$$cPROPparameter,"MAXLEN")
		// 代码长度
		if $l(Veobj.Code)>MLength s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"Code")_"】长度不能超过"_MLength_"，"
		// 激活
		if (Veobj.Active'="")&&(Veobj.Active'=0)&&(Veobj.Active'=1) s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"Active")_"】的值只能为0或1，"
		s HospitalDesc=$lg($g(^dbo.BTHospitalD(Veobj.HospitalDR)),3)
		if HospitalDesc'=Veobj.HospitalDesc		//医院代码和描述不匹配
		{
			s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"HospitalDesc")_"】和医院代码不匹配，"
		}
			
		q myVresult
	}
	if (tablecode="dbo.BT_CostItem")	//2020-1-10 钟荣枫 检验-收费项目
	{
		s MLength=$$$comMemberArrayGet("dbo.BTCostItem",$$$cCLASSproperty,"Code",$$$cPROPparameter,"MAXLEN")
		// 代码长度
		if $l(Veobj.Code)>MLength s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"Code")_"】长度不能超过"_MLength_"，"
		// 激活
		if (Veobj.Active'="")&&(Veobj.Active'=0)&&(Veobj.Active'=1) s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"Active")_"】的值只能为0或1，"
		q myVresult
	}
	if (tablecode="dbo.BT_WorkGroupMachine")	//2020-1-10 钟荣枫 检验-工作小组
	{
		s MLength=$$$comMemberArrayGet("dbo.BTWorkGroupMachine",$$$cCLASSproperty,"Code",$$$cPROPparameter,"MAXLEN")
		// 代码长度
		if $l(Veobj.Code)>MLength s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"Code")_"】长度不能超过"_MLength_"，"
		// 激活
		if (Veobj.Active'="")&&(Veobj.Active'=0)&&(Veobj.Active'=1) s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"Active")_"】的值只能为0或1，"
		// 通讯方式
		if (Veobj.CommDirection'="")&&(Veobj.CommDirection'="单项通讯")&&(Veobj.CommDirection'="双向通讯")&&(Veobj.CommDirection'="LS")&&(Veobj.CommDirection'="主动上传")
		{
			s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"CommDirection")_"】的值只能为单项通讯、双向通讯、装载列表和主动上传，"
		}
			
		s WorkGroupDesc=$lg($g(^dbo.BTWorkGroupD(Veobj.WorkGroupDR)),3)
		if WorkGroupDesc'=Veobj.WorkGroupDesc	//工作组代码和描述不匹配
		{
			s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"WorkGroupDesc")_"】和工作组代码不匹配，"
		}
		s RoomDesc=""
		s:Veobj.RoomDR'="" RoomDesc=$lg($g(^dbo.BTRoomD(Veobj.RoomDR)),3)
		if RoomDesc'=Veobj.RoomDesc		//房间代码和描述不匹配
		{
			s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"RoomDesc")_"】和房间代码不匹配，"
		}
		s OwnWorkGroupMachineDesc=""
		s:Veobj.OwnWorkGroupMachineDR'="" OwnWorkGroupMachineDesc=$lg($g(^dbo.BTWorkGroupMachineD(Veobj.OwnWorkGroupMachineDR)),3)
		if OwnWorkGroupMachineDesc'=Veobj.OwnWorkGroupMachineDesc	//所属小组代码和描述不匹配
		{
			s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"OwnWorkGroupMachineDesc")_"】和所属小组代码不匹配，"
		}
		
		q myVresult
	}
	if (tablecode="dbo.BT_WorkGroup")	//2020-1-10 钟荣枫 检验-工作组
	{
		s MLength=$$$comMemberArrayGet("dbo.BTWorkGroup",$$$cCLASSproperty,"Code",$$$cPROPparameter,"MAXLEN")
		//  代码长度校验
		if $l(Veobj.Code)>MLength s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"Code")_"】长度不能超过"_MLength_"，"
		//  激活校验
		if (Veobj.Active'="")&&(Veobj.Active'=0)&&(Veobj.Active'=1) s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"Active")_"】的值只能为0或1，"
		//  显示操作者校验
		if (Veobj.ShowOperator'="")&&(Veobj.ShowOperator'=0)&&(Veobj.ShowOperator'=1) s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"ShowOperator")_"】的值只能为0或1，"
		//  双签字校验
		if (Veobj.DoubleCheck'="")&&(Veobj.DoubleCheck'=0)&&(Veobj.DoubleCheck'=1) s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"DoubleCheck")_"】的值只能为0或1，"
		//  开启电子签名校验
		if (Veobj.IsCALogin'="")&&(Veobj.IsCALogin'=0)&&(Veobj.IsCALogin'=1) s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"IsCALogin")_"】的值只能为0或1，"
		//  显示设置窗校验
		if (Veobj.IsShowSet'="")&&(Veobj.IsShowSet'=0)&&(Veobj.IsShowSet'=1) s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"IsShowSet")_"】的值只能为0或1，"
		//  荒诞报告临床校验
		if (Veobj.IsUnacceptToClinical'="")&&(Veobj.IsUnacceptToClinical'=0)&&(Veobj.IsUnacceptToClinical'=1) s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"IsCALogin")_"】的值只能为0或1，"
		
		s DepartmentDesc=$lg($g(^dbo.BTDepartmentD(Veobj.DepartmentDR)),3)
		if DepartmentDesc'=Veobj.DepartmentDesc		//检验科室代码和描述不匹配
		{
			s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"DepartmentDesc")_"】和检验科室代码不匹配，"
		}
		s RoomDesc=""
		s:Veobj.RoomDR'="" RoomDesc=$lg($g(^dbo.BTRoomD(Veobj.RoomDR)),3)
		if RoomDesc'=Veobj.RoomDesc		//所在房间代码和描述不匹配
		{
			s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"RoomDesc")_"】和所在房间代码不匹配，"
		}
		s LinkWorkGroupDesc=""
		s:Veobj.LinkWorkGroupDR'="" LinkWorkGroupDesc=$lg($g(^dbo.BTWorkGroupD(Veobj.LinkWorkGroupDR)),3)
		if LinkWorkGroupDesc'=Veobj.LinkWorkGroupDesc	//关联工作组代码和描述不匹配
		{
			s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"LinkWorkGroupDesc")_"】和关联工作组代码不匹配，"
		}
			
		q myVresult
	}
	if (tablecode="dbo.BT_TestSetGroup")	//2020-1-10 钟荣枫 检验-组合套分组及关联
	{
		s MLength=$$$comMemberArrayGet("dbo.BTTestSetGroup",$$$cCLASSproperty,"Code",$$$cPROPparameter,"MAXLEN")
		// 代码长度校验
		if $l(Veobj.Code)>MLength s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"Code")_"】长度不能超过"_MLength_"，"
		// 激活校验
		if (Veobj.Active'="")&&(Veobj.Active'=0)&&(Veobj.Active'=1) s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"Active")_"】的值只能为0或1，"
		s TestSetGroupDR=##class(web.DHCBL.LAB.BTTestSetGroup).GetRowIdByCode(Veobj.Code)
		if TestSetGroupDR'=""	//组合套分组存在
		{
			s TestSetGroupDesc=$lg($g(^dbo.BTTestSetGroupD(TestSetGroupDR)),3)
			if TestSetGroupDesc'=Veobj.CName		//组合套分组代码和描述不匹配
			{
				s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"CName")_"】和组合套分组代码不匹配，"
			}
		}
		
		s HospitalDesc=$lg($g(^dbo.BTHospitalD(Veobj.HospitalDR)),3)
		if HospitalDesc'=Veobj.HospitalDesc		//医院代码和描述不匹配
		{
			s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"HospitalDesc")_"】和医院代码不匹配，"
		}
		
		s TestSetDesc=""
		s:Veobj.TestSetDR'="" TestSetDesc=$lg($g(^dbo.BTTestSetD(Veobj.TestSetDR)),3)
		if TestSetDesc'=Veobj.TestSetDesc	//项目组合套代码和描述不匹配
		{
			s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"TestSetDesc")_"】和项目组合套代码不匹配，"
		}
		
		s flag=##class(web.DHCBL.LAB.BTTestSetGroupLinks).FormValidate("",TestSetGroupDR,Veobj.TestSetDR)
		// 关联已存在
		if flag=1 s myVresult=myVresult_"【关联】已存在，"
		q myVresult
	}
	if (tablecode="dbo.BT_TestSet")	//2020-1-10 钟荣枫 检验-项目组合套
	{
		s MLength=$$$comMemberArrayGet("dbo.BTTestSet",$$$cCLASSproperty,"Code",$$$cPROPparameter,"MAXLEN")
		//	代码长度校验
		if $l(Veobj.Code)>MLength s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"Code")_"】长度不能超过"_MLength_"，"
		s MLength=$$$comMemberArrayGet("dbo.BTTestSet",$$$cCLASSproperty,"LinkType",$$$cPROPparameter,"MAXLEN")
		//	测试数长度校验
		if $l(Veobj.LinkType)>MLength s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"LinkType")_"】长度不能超过"_MLength_"，"
		s MLength=$$$comMemberArrayGet("dbo.BTTestSet",$$$cCLASSproperty,"HISCode",$$$cPROPparameter,"MAXLEN")
		//	HIS对照码长度校验
		if $l(Veobj.HISCode)>MLength s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"HISCode")_"】长度不能超过"_MLength_"，"
		//	激活校验
		if (Veobj.Active'="")&&(Veobj.Active'=0)&&(Veobj.Active'=1) s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"Active")_"】的值只能为0或1，"
		//	附加处理校验
		if (Veobj.Urgent'="")&&(Veobj.Urgent'=0)&&(Veobj.Urgent'=1) s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"Urgent")_"】的值只能为0或1，"
		//	允许急诊校验
		if (Veobj.ExtraFlag'="")&&(Veobj.ExtraFlag'=0)&&(Veobj.ExtraFlag'=1) s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"ExtraFlag")_"】的值只能为0或1，"
		//	阳性报警校验
		if (Veobj.PositiveAlarn'="")&&(Veobj.PositiveAlarn'=0)&&(Veobj.PositiveAlarn'=1) s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"PositiveAlarn")_"】的值只能为0或1，"
		//	报告模式校验
		if (Veobj.ReportType'="")&&(Veobj.ReportType'="正常")&&(Veobj.ReportType'="打印预览")&&(Veobj.ReportType'="PDF")
		{
			s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"ReportType")_"】的值只能为正常、打印预览和PDF，"
		}
		
		//	默认条码数量校验
		if (Veobj.MergeType'="")&&(Veobj.MergeType'=1)&&(Veobj.MergeType'=3)&&(Veobj.MergeType'=3)&&(Veobj.MergeType'=4)&&(Veobj.MergeType'=5) 
		{
			s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"MergeType")_"】的值只能为1、2、3、4、5，"
		}
		
		
		s HospitalDesc=$lg($g(^dbo.BTHospitalD(Veobj.HospitalDR)),3)
		if HospitalDesc'=Veobj.HospitalDesc		//医院代码和描述不匹配
		{
			s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"HospitalDesc")_"】和医院代码不匹配，"
		}
		
		s SpeciesDesc=""
		s:Veobj.SpeciesDR'="" SpeciesDesc=$lg($g(^dbo.BTSpeciesD(Veobj.SpeciesDR)),3)
		if SpeciesDesc'=Veobj.SpeciesDesc		//性别代码和描述不匹配
		{
			s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"SpeciesDesc")_"】和性别代码不匹配，"
		}
		
		s SpecimenDesc=""
		s:Veobj.SpecimenDR'="" SpecimenDesc=$lg($g(^dbo.BTSpecimenD(Veobj.SpecimenDR)),3)
		if SpecimenDesc'=Veobj.SpecimenDesc		//默认标本类型代码和描述不匹配
		{
			s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"SpecimenDesc")_"】和默认标本类型代码不匹配，"
		}
		
		s ContainerDesc=""
		s:Veobj.ContainerDR'="" ContainerDesc=$lg($g(^dbo.BTContainerD(Veobj.ContainerDR)),3)
		if ContainerDesc'=Veobj.ContainerDesc		//默认容器代码和描述不匹配
		{
			s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"ContainerDesc")_"】和默认容器代码不匹配，"
		}
		
		s WorkGroupMachineDesc=""
		s:Veobj.WorkGroupMachineDR'="" WorkGroupMachineDesc=$lg($g(^dbo.BTWorkGroupMachineD(Veobj.WorkGroupMachineDR)),3)
		if WorkGroupMachineDesc'=Veobj.WorkGroupMachineDesc		//默认工作小组代码和描述不匹配
		{
			s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"WorkGroupMachineDesc")_"】和默认工作小组代码不匹配，"
		}
		
		s CostItemDesc=""
		s:Veobj.CostItemDR'="" CostItemDesc=$lg($g(^dbo.BTCostItemD(Veobj.CostItemDR)),3)
		if CostItemDesc'=Veobj.CostItemDesc		//收费项目代码和描述不匹配
		{
			s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"CostItemDesc")_"】和收费项目代码不匹配，"
		}
		
		s CollectPromptDesc=""
		s:Veobj.CollectPromptDR'="" CollectPromptDesc=$lg($g(^dbo.BTCollectPromptD(Veobj.CollectPromptDR)),3)
		if CollectPromptDesc'=Veobj.CollectPromptDesc	//采集提示代码和描述不匹配
		{
			s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"CollectPromptDesc")_"】和采集提示代码不匹配，"
		}
		
		s ReportPromptDesc=""
		s:Veobj.ReportPromptDR'="" ReportPromptDesc=$lg($g(^dbo.BTReportPromptD(Veobj.ReportPromptDR)),3)
		if ReportPromptDesc'=Veobj.ReportPromptDesc	//取报告提示代码和描述不匹配
		{
			s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"ReportPromptDesc")_"】和取报告提示代码不匹配，"
		}
		
		s WorkGroupDesc=""
		s:Veobj.WorkGroupDR'="" WorkGroupDesc=$lg($g(^dbo.BTWorkGroupD(Veobj.WorkGroupDR)),3)
		if WorkGroupDesc'=Veobj.WorkGroupDesc	//工作组代码和描述不匹配
		{
			s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"WorkGroupDesc")_"】和工作组代码不匹配，"
		}
		q myVresult
	}
	if (tablecode="ARC_ItmRecLoc")	//2020-04-02 钟荣枫 医嘱项接收科室
	{
		///2020-06-06 云HIS 校验医院
		s validStr= ##class(web.DHCBL.BDP.BDPMappingHOSP).ValidateHospId(tablename,Veobj.LinkHospId)  ///校验医院
		if (validStr'="")
		{
			s myVresult=myVresult_validStr
			q myVresult
		}
		s ARCIMRowId=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("ARC_ItmMast",Veobj.ARCIMCode,Veobj.LinkHospId)
		if (ARCIMRowId'="")		//医嘱项存在
		{
			s ParRef=$p(ARCIMRowId,"||",1)
			s version=$p(ARCIMRowId,"||",2)
			s Desc=$p($g(^ARCIM(ParRef,version,1)),"^",2)
			if (Veobj.ARCIMDesc'=Desc)		//医嘱项代码和描述不对应
			{
				s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"ARCIMCode")_"】和医嘱项描述不对应，"	
			}
			//病人科室所属医院，要求属于医嘱项医院组
			s DefHospId= ##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("ARC_ItmMast",Veobj.ARCRLCTHospitalDR)
			if DefHospId'=Veobj.LinkHospId
			{
				s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"ARCRLCTHospitalDR")_"】不属于医嘱项医院组，"	
			}
			
			if Veobj.ARCRLOrdLocDR'="" s Veobj.ARCRLCTHospitalDR=""
			s str=Veobj.ARCRLOrderPriorityDR_"^"_Veobj.ARCRLTimeFrom_"^"_Veobj.ARCRLTimeTo_"^"_Veobj.ARCRLDateFrom_"^"_Veobj.ARCRLDateTo_"^"_Veobj.ARCRLCTHospitalDR
			s flag=##class(web.DHCBL.CT.ARCItmRecLoc).FormValidate(ParRef,"",Veobj.ARCRLOrdLocDR,Veobj.ARCRLRecLocDR,str)  //调用重复验证
			if (flag=1)		//重复
			{
				s myVresult=myVresult_"与另一条相同接收科室记录的日期时间冲突，"
			}	
		}
		else	//医嘱项不存在
		{
			s myVresult=myVresult_"医嘱项代码不存在，"
		}
		//就诊类型 O E I H N
		if (Veobj.ARCRLClinicType'="O")&&(Veobj.ARCRLClinicType'="I")&&(Veobj.ARCRLClinicType'="E")&&(Veobj.ARCRLClinicType'="H")&&(Veobj.ARCRLClinicType'="N")&&(Veobj.ARCRLClinicType'="") s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"ARCRLClinicType")_"】要求为O/E/I/H/N，"
		
		q myVresult
	}
	if (tablecode="ARC_ItemCatRecLoc")	//2020-04-02 钟荣枫 医嘱子类接收科室
	{
		///2020-06-06 云HIS 校验医院
		s validStr= ##class(web.DHCBL.BDP.BDPMappingHOSP).ValidateHospId(tablename,Veobj.LinkHospId)  ///校验医院
		if (validStr'="")
		{
			s myVresult=myVresult_validStr
			q myVresult
		}
		if (Veobj.RLFunction'="")&&(Veobj.RLFunction'="Execute")&&(Veobj.RLFunction'="Processing") s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"RLFunction")_"】的值只能为Execute或Processing，"
		s RLParRef=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("ARC_ItemCat",Veobj.ARCICCode,Veobj.LinkHospId)
		if (RLParRef'="")	//医嘱子类不存在
		{	
			s Desc=$p($g(^ARC("IC",RLParRef)),"^",2)
			
			if (Veobj.ARCICDesc'=Desc)	//医嘱子类代码和描述不对应
			{
				s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"ARCICCode")_"】和医嘱子类描述不对应，"	
			}
			s str=Veobj.RLOrderPriorityDR_"^"_Veobj.RLTimeFrom_"^"_Veobj.RLTimeTo_"^"_Veobj.RLDateFrom_"^"_Veobj.RLDateTo_"^"_Veobj.RLCTHospitalDR
			s flag=##class(web.DHCBL.CT.ARCItemCatRecLoc).FormValidate(RLParRef,"",Veobj.RLRecLocDR,Veobj.RLOrdLocDR,str)  //调用重复验证
			if (flag=1)		//重复
			{
				s myVresult=myVresult_"与另一条相同接收科室记录的日期时间冲突，"
			}
		}
		else		//医嘱子类不存在
		{
			s myVresult=myVresult_"医嘱子类代码对应的数据不存在，"	
		}
		//就诊类型 O E I H N
		if (Veobj.RLClinicType'="O")&&(Veobj.RLClinicType'="I")&&(Veobj.RLClinicType'="E")&&(Veobj.RLClinicType'="H")&&(Veobj.RLClinicType'="N")&&(Veobj.RLClinicType'="") s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"RLClinicType")_"】要求为O/E/I/H/N，"
		
		q myVresult
	}
	if (tablecode="OEC_OrdCatRecLoc")	//2020-04-02 钟荣枫 医嘱大类接收科室
	{
		///2020-06-06 云HIS 校验医院
		s validStr= ##class(web.DHCBL.BDP.BDPMappingHOSP).ValidateHospId(tablename,Veobj.LinkHospId)  ///校验医院
		if (validStr'="")
		{
			s myVresult=myVresult_validStr
			q myVresult
		}
		if (Veobj.RLFunction'="")&&(Veobj.RLFunction'="Execute")&&(Veobj.RLFunction'="Processing") s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"RLFunction")_"】的值只能为Execute或Processing，"
		s RLParRef=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("OEC_OrderCategory",Veobj.ORCATCode,Veobj.LinkHospId)		
		if (RLParRef'="")	//医嘱大类存在
		{	
			s Desc=$p($g(^OEC("ORCAT",RLParRef)),"^",2)
			
			if (Veobj.ORCATDesc'=Desc)	//医嘱大类代码和描述不对应
			{
				s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"ORCATCode")_"】和医嘱大类描述不对应，"	
			}
			s str=Veobj.RLOrderPriorityDR_"^"_Veobj.RLTimeFrom_"^"_Veobj.RLTimeTo_"^"_Veobj.RLDateFrom_"^"_Veobj.RLDateTo_"^"_Veobj.RLCTHospitalDR
			s flag=##class(web.DHCBL.CT.OECOrdCatRecLoc).FormValidate(RLParRef,"",Veobj.RLRecLocDR,Veobj.RLOrdLocDR,str)  //调用重复验证
			if (flag=1)		//重复
			{
				s myVresult=myVresult_"与另一条相同接收科室记录的日期时间冲突，"
			}
		}	
		else		//医嘱大类不存在
		{
			s myVresult=myVresult_"医嘱大类代码对应的数据不存在，"	
		}
		//就诊类型 O E I H N
		if (Veobj.RLClinicType'="O")&&(Veobj.RLClinicType'="I")&&(Veobj.RLClinicType'="E")&&(Veobj.RLClinicType'="H")&&(Veobj.RLClinicType'="N")&&(Veobj.RLClinicType'="") s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"RLClinicType")_"】要求为O/E/I/H/N，"
				
		q myVresult
	}
	if (tablecode="DHC_PHCInstrRecLoc")	//2020-04-15 钟荣枫 药品用法接收科室
	{
		///2020-06-06 云HIS 校验医院
		s validStr= ##class(web.DHCBL.BDP.BDPMappingHOSP).ValidateHospId(tablename,Veobj.LinkHospId)  ///校验医院
		if (validStr'="")
		{
			s myVresult=myVresult_validStr
			q myVresult
		}
		s ParRef=$o(^PHCIN(0,"Code",$$ALPHAUP^SSUTIL4(Veobj.PHCINCode),0))
		if (ParRef'="")	//药品用法存在
		{	
			s Desc=$p($g(^PHCIN(ParRef)),"^",2)
			if (Veobj.PHCINDesc'=Desc)	//药品用法代码和描述不匹配
			{
				s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"PHCINCode")_"】和药品用法描述不对应，"	
			}
			s InstrTimeRange=Veobj.InstrTimeRangeFrom_"||"_Veobj.InstrTimeRangeTo
			s str=Veobj.InstrOrdPrior_"^"_InstrTimeRange_"^"_Veobj.InstrHospitalDR
			s flag=##class(web.DHCBL.CT.DHCPHCInstrRecLoc).FormValidate("",ParRef,Veobj.InstrOrdDep,Veobj.InstrRecLoc,Veobj.InstrOrdSubCat,str)  //调用重复验证
			if (flag=1)		//重复
			{
				s myVresult=myVresult_"与另一条相同接收科室记录的日期时间冲突，"
			}
		}	
		else	//药品用法不存在
		{
			s myVresult=myVresult_"药品用法代码对应的数据不存在，"	
		}		
		q myVresult
	}
	if (tablecode="BDP_CTLOCCategory")	//2020-4-10 钟荣枫  科室多层分类
	{
		if (Veobj.Type'="")&&(Veobj.Type'="片区")&&(Veobj.Type'="学科")&&(Veobj.Type'="学科分类") s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"Type")_"】的值只能为片区、学科或学科分类，"
		if (ImportType=1)	//修改、追加
		{
			if (Veobj.ParentCatDr'="")	//父菜单不为空
			{ 
				s ParentCatDr=$o(^User.BDPCTLOCCategoryI("UniqueCodeIndex"," "_$ZCONVERT(Veobj.ParentCatDr,"U"),0))
				if (ParentCatDr="")	
				{
					s myVresult=myVresult_Veobj.ParentCatDr_"对应的父菜单代码不存在，"
				}
				else
				{
					s ParentCatDesc=$lg($g(^User.BDPCTLOCCategoryD(ParentCatDr)),3)
					if ParentCatDesc'=Veobj.ParentCatDesc	//父菜单代码和描述不匹配
					{
						s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"ParentCatDesc")_"】和父菜单代码不匹配，"
					}
				}
			}
		}
		q myVresult
		
	}
	/// 用户其他登录科室 2020年4月21日 李可凡
	if (tablecode="SS_UserOtherLogonLoc")
	{
		if (Veobj.OTHLLParRef'="")
		{
			s SSUSRName=$p($g(^SSU("SSUSR",Veobj.OTHLLParRef)),"^",2)		//取用户名
			s:Veobj.SSUSRName'=SSUSRName myVresult=myVresult_"人事ID与姓名不匹配，"
		}
		s:Veobj.OTHLLStartDate'="" Veobj.OTHLLStartDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(Veobj.OTHLLStartDate)
		s:Veobj.OTHLLEndDate'="" Veobj.OTHLLEndDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(Veobj.OTHLLEndDate)   
		if (Veobj.OTHLLEndDate'="")
		{
			s:Veobj.OTHLLEndDate<Veobj.OTHLLStartDate myVresult=myVresult_"结束日期不能早于开始日期，"
		}
		
		if (ImportType=1)
		{
			if (Veobj.OTHLLParRef'="")&&(Veobj.OTHLLCTLOCDR'="")&&(Veobj.OTHLLUserGroupDR'="")
			{
				s flag=##class(web.DHCBL.CT.SSUserOtherLogonLoc).FormValidate(Veobj.OTHLLParRef,"",Veobj.OTHLLCTLOCDR,Veobj.OTHLLUserGroupDR,Veobj.OTHLLStartDate,Veobj.OTHLLEndDate)  //调用重复验证
				s:flag=1 myVresult=myVresult_"存在重复数据，"
			}
		}
		q myVresult
	}
	/// HIS-Location与HR-组织关联关系表 导入 2020-07-29 李可凡
	if (tablecode="CT_DepartmentLocation")
	{
		//校验组织部门
		s:Veobj.DEPRowId'="" Veobj.DEPLDeptDR=$o(^User.CTDepartmentI("DEPRowIdRef",Veobj.DEPRowId,0))
		if (Veobj.DEPLDeptDR="")
		{
			s myVresult=myVresult_"组织部门代码错误，"
		}
		else
		{
			s DEPDesc=$lg($g(^User.CTDepartmentD(Veobj.DEPLDeptDR)),4)		// 组织部门描述
			s:DEPDesc'=Veobj.DEPDesc myVresult=myVresult_"组织部门名称【"_Veobj.DEPDesc_"】与代码不匹配，"
			//校验医疗机构
			s DEPRefClinDR=$lg($g(^User.CTDepartmentD(Veobj.DEPLDeptDR)),9)		// 医疗机构DR
			if (DEPRefClinDR'="")
			{
				s CTRFCCode=$p($g(^CT("RFC",DEPRefClinDR)),"^",1)	//医疗机构代码
				s CTRFCDesc=$p($g(^CT("RFC",DEPRefClinDR)),"^",2)	//医疗机构名称
				s:CTRFCCode'=Veobj.OrgCode myVresult=myVresult_"医疗机构代码【"_Veobj.OrgCode_"】与组织部门不匹配，"
				s:CTRFCDesc'=Veobj.OrgName myVresult=myVresult_"医疗机构名称【"_Veobj.OrgName_"】与组织部门不匹配，"
			}
		}
		//校验Location
		if (Veobj.DEPLLocSource="CT_Loc")
		{
			s:Veobj.DEPLLocCode'="" Veobj.DEPLLocID=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(Veobj.DEPLLocCode),0))
			if (Veobj.DEPLLocID="")
			{
				s myVresult=myVresult_"Location代码错误，"
			}
			else
			{
				s CTLOCDesc=$p($g(^CTLOC(Veobj.DEPLLocID)),"^",2)       //科室名
				s:CTLOCDesc'=Veobj.DEPLLocDesc myVresult=myVresult_"Location名称【"_Veobj.DEPLLocDesc_"】与代码不匹配，"
			}
		}
		//校验重复性
		if (Veobj.DEPLDeptDR'="")
		{
			s flag=##class(web.DHCBL.CT.CTDepartmentLocation).FormValidate("",Veobj.DEPLDeptDR,Veobj.DEPLLocSource,Veobj.DEPLLocID,Veobj.DEPLLocCode)  //调用重复验证
			if (flag=1)
			{
				s myVresult=myVresult_"数据已存在，"
			}
		}
		//校验上级Location
		if (Veobj.DEPLParentLocSource="CT_Loc")
		{
			s:Veobj.DEPLParentLocCode'="" Veobj.DEPLParentLocID=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(Veobj.DEPLParentLocCode),0))
			if (Veobj.DEPLParentLocID="")
			{
				s myVresult=myVresult_"上级Location代码错误，"
			}
			else
			{
				s ParentCTLOCDesc=$p($g(^CTLOC(Veobj.DEPLParentLocID)),"^",2)       //科室名
				s:ParentCTLOCDesc'=Veobj.DEPLParentLocDesc myVresult=myVresult_"上级Location名称【"_Veobj.DEPLParentLocDesc_"】与代码不匹配，"
			}
		}
		q myVresult
	}
	/// 表结构登记导入 2020年9月16日 李可凡
	if (tablecode="BDP_TableList")
	{
		if (Veobj.FieldName="")		//只导父表
		{
			s flag=##class(web.DHCBL.BDP.BDPTableList).Validate("",Veobj.TableName,Veobj.ClassName)
			s:flag=1 myVresult=myVresult_"父表存在重复数据，"
		}
		else		//导子表
		{
			s ID=$o(^User.BDPTableListI("UqIndex"," "_$ZCONVERT(Veobj.TableName,"U"),0))
			if (ID'="")		//父表已存在
			{
				s TableDesc=$LISTGET($G(^User.BDPTableListD(ID)),3)
				s ClassName=$LISTGET($G(^User.BDPTableListD(ID)),8)
				s:TableDesc'=Veobj.TableDesc myVresult=myVresult_"表中文名【"_Veobj.TableDesc_"】与类名不匹配，"
				s:ClassName'=Veobj.ClassName myVresult=myVresult_"表名（代码）【"_Veobj.ClassName_"】与类名不匹配，"
				s flag=##class(web.DHCBL.BDP.BDPTableField).Validate(ID,"",Veobj.FieldName)
				s:flag=1 myVresult=myVresult_"子表存在重复数据，"
				if (Veobj.FieldType="DR")
				{
					s flag2=1
					s:Veobj.FieldTabCode'["^" flag2=##class(web.DHCBL.BDP.FindTableStructure).ClassExistOrNot(Veobj.FieldTabCode)
					s:flag2=0 myVresult=myVresult_"实体类 "_Veobj.FieldTabCode_" 不存在，请重新填写指向表"
				}
			}
		}
		q myVresult
	}
	if (tablecode="INC_StkBin")  //2020-11-09科室货位导入（药品）
	{
		///云HIS 校验医院
		s validStr= ##class(web.DHCBL.BDP.BDPMappingHOSP).ValidateHospId(tablename,Veobj.LinkHospId)  ///校验医院
		if (validStr'="")
		{
			s myVresult=myVresult_validStr
			q myVresult
		}
		if (ImportType=1)
		{
			s listobj={
				"LinkHospId":(Veobj.LinkHospId),
				"locDesc":(Veobj.locDesc),
				"inciCode":(Veobj.inciCode),
				"inciDesc":(Veobj.inciDesc),
				"binDesc":(Veobj.binDesc)
			}
			s ret=##class(PHA.TOOLS.Import.StkBin).Check(listobj)  //校验成功：0，失败：-1^错误信息
			if (ret'=0)
			{
				s myVresult=ret
			}
		}
		q myVresult
	}
	/// 医生专长 2021-01-08 likefan
	if (tablecode="CT_Spec")
	{
		s:Veobj.CTSPCDateFrom'="" Veobj.CTSPCDateFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(Veobj.CTSPCDateFrom)
		s:Veobj.CTSPCDateTo'="" Veobj.CTSPCDateTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(Veobj.CTSPCDateTo)   
		if (Veobj.CTSPCDateTo'="")
		{
			s:Veobj.CTSPCDateTo<Veobj.CTSPCDateFrom myVresult=myVresult_"结束日期不能早于开始日期，"
		}
		if (ImportType=1)
		{
			s flag=##class(web.DHCBL.CT.CTSpec).Validate("",Veobj.CTSPCCode,Veobj.CTSPCDesc)  //调用重复验证
			s:flag=1 myVresult=myVresult_"存在重复数据，"
		}
		q myVresult
	}
	/// 单独导入用户国家医保代码字段 2021-11-03 likefan
	if (tablecode="SSUSRFreeText3")
	{
		//考虑不同院区存在同工号情况
		s SSUSRRowId=0
		for
		{
			s SSUSRRowId=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(Veobj.SSUSRInitials),SSUSRRowId))
			q:SSUSRRowId=""
			s SSUSRHospitalDR=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",98)      //医院DR
			q:(SSUSRHospitalDR=Veobj.LinkHospId)
		}
		s:SSUSRRowId="" myVresult=myVresult_"找不到用户，"
		if (SSUSRRowId'="")
		{
			s SSUSRName=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",2)       //用户名
			s:SSUSRName'=Veobj.SSUSRName myVresult=myVresult_"姓名与工号不匹配，"
		}
		q myVresult
	}
	/// 医院楼导入 2021-11-22 likefan
	if (tablecode="CT_LocBuilding")
	{
		if (ImportType=1)
		{
			if (Veobj.CTLBFFloor="")		//只导父表
			{
				s flag=##class(web.DHCBL.CT.CTLocBuilding).FormValidate("",Veobj.CTLBCode,Veobj.CTLBDesc,Veobj.CTLBHospitalDR)
				s:flag=1 myVresult=myVresult_"父表存在重复数据，"
			}
			else		//导子表
			{
				s CTLBRowId=$o(^CT("CTLB",0,"Code",$$ALPHAUP^SSUTIL4(Veobj.CTLBCode),Veobj.CTLBHospitalDR,0))
				if (CTLBRowId'="")		//父表已存在
				{
					s CTLBDesc=$p($g(^CT("CTLB",CTLBRowId)),"^",2)		//医院楼描述
					s:CTLBDesc'=Veobj.CTLBDesc myVresult=myVresult_"表描述【"_Veobj.CTLBDesc_"】与代码不匹配，"
					s flag=##class(web.DHCBL.CT.CTLocBuildingFloor).FormValidate(CTLBRowId,"",Veobj.CTLBFFloor)
					s:flag=1 myVresult=myVresult_"子表存在重复数据，"
				}
			}
		}
		q myVresult
	}
	if (tablecode="MRC_TCMTreatment")  //中医治法
	{
		if (ImportType=1)
		{
			s flag=##class(web.DHCBL.CT.MRCTCMTreatment).FormValidate("",Veobj.TCMTDesc)
			if flag=1 s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"TCMTDesc")_"】已存在，"
		}
		q myVresult
	}
	if (tablecode="CT_BDP_CT.HOS_ProfTitleDict")	//职务字典代码	likefan	2023-02-23
	{
		if (ImportType=1)
		{
			s flag=##class(web.DHCBL.CT.HOSProfTitleDict).FormValidate("",Veobj.PROFTCCode,Veobj.PROFTCDesc)
			if flag=1 s myVresult=myVresult_"代码或名称已存在，"
		}
	}
	if (tablecode="CT_BDP_CT.HOS_PostType")	//岗位类型	likefan	2023-02-23
	{
		if (ImportType=1)
		{
			s flag=##class(web.DHCBL.CT.HOSPostType).FormValidate("",Veobj.PTCode,Veobj.PTDesc)
			if flag=1 s myVresult=myVresult_"代码或名称已存在，"
		}
	}
	if (tablecode="CT_BDP_CT.HOS_PostHeadWord")	//岗位中心词	likefan	2023-02-23
	{
		if (ImportType=1)
		{
			s flag=##class(web.DHCBL.CT.HOSPostHeadWord).FormValidate("",Veobj.PHWCode,Veobj.PHWDesc)
			if flag=1 s myVresult=myVresult_"代码或名称已存在，"
		}
	}
	if (tablecode="CT_BDP_CT.HOS_FlowHeadWord")	//流程中心词	likefan	2023-02-23
	{
		if (ImportType=1)
		{
			s flag=##class(web.DHCBL.CT.HOSFlowHeadWord).FormValidate("",Veobj.FHWCode,Veobj.FHWDesc)
			if flag=1 s myVresult=myVresult_"代码或名称已存在，"
		}
	}
	if (tablecode="CT_BDP_CT.HOS_ProfTitle")	//组织职务	likefan	2023-02-23
	{
		if (ImportType=1)
		{
			s flag=##class(web.DHCBL.CT.HOSProfTitle).FormValidate("",Veobj.PROFTCode,Veobj.PROFTDesc)
			if flag=1 s myVresult=myVresult_"代码或名称已存在，"
		}
	}
	if (tablecode="CT_BDP_CT.HOS_ProcPost")	//流程岗位	likefan	2023-02-23
	{
		if (ImportType=1)
		{
			s flag=##class(web.DHCBL.CT.HOSProcPost).FormValidate("",Veobj.PPOSTCode,Veobj.PPOSTDesc)
			if flag=1 s myVresult=myVresult_"代码或名称已存在，"
		}
	}
	if (tablecode="CT_BDP_CT.HOS_ProcPostRelPost")	//流程岗位与业务岗位关系	likefan	2023-02-23
	{
		if (ImportType=1)
		{
			s flag=##class(web.DHCBL.CT.HOSPostRelBusPost).FormValidate("",Veobj.PPRPProcPostCode,Veobj.PPRPPostCode)
			if flag=1 s myVresult=myVresult_"存在重复数据，"
		}
	}
		if (tablecode="CT_BDP_CT.HOS_Degree")	//学位代码	gss	2023-02-24
	{
		if (ImportType=1)
		{
			s flag=##class(web.DHCBL.CT.HOSDegree).FormValidate("",Veobj.DEGCode,Veobj.DEGDesc)
			if flag=1 s myVresult=myVresult_"存在重复数据，"
		}
	}
	if (tablecode="CT_BDP_CT.HOS_HORGGrade")	//医院等级	gss	2023-02-24
	{
		if (ImportType=1)
		{
			s flag=##class(web.DHCBL.CT.HOSHORGGrade).FormValidate("",Veobj.HORGGCCode,Veobj.HORGGCDesc)
			if flag=1 s myVresult=myVresult_"存在重复数据，"
		}
	}
	if (tablecode="CT_BDP_CT.HOS_Person")	//人员基本信息	gss	2023-02-24
	{
		if (ImportType=1)
		{
			s flag=##class(web.DHCBL.CT.HOSPerson).FormValidate("",Veobj.PAPersonID)
			if flag=1 s myVresult=myVresult_"存在重复数据，"
		}
	}
	if (tablecode="CT_BDP_CT.HOS_ORGEmployee")	//组织人员	gss	2023-02-24
	{
		if (ImportType=1)
		{
			s flag=##class(web.DHCBL.CT.HOSORGEmployee).FormValidate("",Veobj.EMPORGCode,Veobj.EMPPAPersonID)
			if flag=1 s myVresult=myVresult_"存在重复数据，"
		}
	}
	if (tablecode="CT_BDP_CT.HOS_EmpPostion")	//人员职位	gss	2023-02-24
	{
		if (ImportType=1)
		{
			s flag=##class(web.DHCBL.CT.HOSEmpPostion).FormValidate("",Veobj.EMPPOSPAPersonID,Veobj.EMPPOSDeptCode,Veobj.EMPPOSPOSCode)
			if flag=1 s myVresult=myVresult_"存在重复数据，"
		}
	}
	if (tablecode="CT_BDP_CT.HOS_EmpProfTitle")	//人员职务	gss	2023-02-24
	{
		if (ImportType=1)
		{
			s flag=##class(web.DHCBL.CT.HOSEmpProfTitle).FormValidate("",Veobj.EMPPROFPAPersonID,Veobj.EMPPROFDeptCode,Veobj.EMPPROFPROFTCode)
			if flag=1 s myVresult=myVresult_"存在重复数据，"
		}
	}
	if (tablecode="CT_BDP_CT.HOS_EmpPost")	//人员岗位	gss	2023-02-24
	{
		if (ImportType=1)
		{
			s flag=##class(web.DHCBL.CT.HOSEmpPost).FormValidate("",Veobj.EMPPOSTPAPersonID,Veobj.EMPPOSTDeptCode,Veobj.EMPPOSTPOSTCode)
			if flag=1 s myVresult=myVresult_"存在重复数据，"
		}
	}
	if (tablecode="HOS_UserAccountPost")	//系统账户岗位	gss	2023-02-24
	{
		if (ImportType=1)
		{
			s flag=##class(web.DHCBL.CT.HOSUserAccountPost).FormValidate("",Veobj.USERPOSTParRef,Veobj.USERPOSTPostCode)
			if flag=1 s myVresult=myVresult_"存在重复数据，"
		}
	}
	if (tablecode="CT_BDP_CT.HOS_Busi_Domain")	//HOS 业务域
	{
		s:Veobj.DomainStartDate'="" Veobj.DomainStartDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(Veobj.DomainStartDate)
		s:Veobj.DomainEndDate'="" Veobj.DomainEndDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(Veobj.DomainEndDate)   
		if (Veobj.DomainEndDate'="")
		{
			s:Veobj.DomainEndDate<Veobj.DomainStartDate myVresult=myVresult_"结束日期不能早于开始日期，"
		}
		
		// 是否有效(Y/N)
		if (Veobj.DomainActivity'="")&&(Veobj.DomainActivity'="Y")&&(Veobj.DomainActivity'="N") 
		{
			s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"DomainActivity")_"】的值只能为Y或N，"
		}
		if (ImportType=1)
		{
			s flag=##class(web.DHCBL.CT.HOSBusiDomain).FormValidate("",Veobj.DomainCode,Veobj.DomainDesc,Veobj.DomainParentCode)
			s:flag=1 myVresult=myVresult_"存在重复数据，"
		}
		q myVresult
	}
	
	if (tablecode="CT_BDP_CT.HOS_Organization")	//HOS 组织机构
	{
		s:Veobj.ORGStartDate'="" Veobj.ORGStartDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(Veobj.ORGStartDate)
		s:Veobj.ORGEndDate'="" Veobj.ORGEndDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(Veobj.ORGEndDate)   
		if (Veobj.ORGEndDate'="")
		{
			s:Veobj.ORGEndDate<Veobj.ORGStartDate myVresult=myVresult_"结束日期不能早于开始日期，"
		}
		s:Veobj.ORGFoundDate'="" Veobj.ORGFoundDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(Veobj.ORGFoundDate)
		s:Veobj.ORGCancelDate'="" Veobj.ORGCancelDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(Veobj.ORGCancelDate)   
		if (Veobj.ORGCancelDate'="")
		{
			s:Veobj.ORGCancelDate<Veobj.ORGFoundDate myVresult=myVresult_"注销日期不能早于建立日期，"
		}
		// 是否有效(Y/N)
		if (Veobj.ORGActivity'="")&&(Veobj.ORGActivity'="Y")&&(Veobj.ORGActivity'="N") 
		{
			s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"ORGActivity")_"】的值只能为Y或N，"
		}
		if (ImportType=1)
		{
			s flag=##class(web.DHCBL.CT.HOSOrganization).FormValidate("",Veobj.ORGCode,Veobj.ORGDesc)
			s:flag=1 myVresult=myVresult_"存在重复数据，"
		}
		q myVresult
	}
	
	if (tablecode="CT_BDP_CT.HOS_PositionDict")	//HOS 职位字典
	{
		s:Veobj.POSCStartDate'="" Veobj.POSCStartDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(Veobj.POSCStartDate)
		s:Veobj.POSCEndDate'="" Veobj.POSCEndDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(Veobj.POSCEndDate)   
		if (Veobj.POSCEndDate'="")
		{
			s:Veobj.POSCEndDate<Veobj.POSCStartDate myVresult=myVresult_"结束日期不能早于开始日期，"
		}
		
		// 是否有效(Y/N)
		if (Veobj.POSCActivity'="")&&(Veobj.POSCActivity'="Y")&&(Veobj.POSCActivity'="N") 
		{
			s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"POSCActivity")_"】的值只能为Y或N，"
		}
		if (ImportType=1)
		{
			s flag=##class(web.DHCBL.CT.HOSPositionDict).FormValidate("",Veobj.POSCCode,Veobj.POSCDesc)
			s:flag=1 myVresult=myVresult_"存在重复数据，"
		}
		q myVresult
	}
	if (tablecode="CT_BDP_CT.HOS_PostDict")	//HOS 岗位字典
	{
		s:Veobj.POSTCStartDate'="" Veobj.POSTCStartDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(Veobj.POSTCStartDate)
		s:Veobj.POSTCEndDate'="" Veobj.POSTCEndDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(Veobj.POSTCEndDate)   
		if (Veobj.POSTCEndDate'="")
		{
			s:Veobj.POSTCEndDate<Veobj.POSTCStartDate myVresult=myVresult_"结束日期不能早于开始日期，"
		}
		
		// 是否有效(Y/N)
		if (Veobj.POSTCActivity'="")&&(Veobj.POSTCActivity'="Y")&&(Veobj.POSTCActivity'="N") 
		{
			s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"POSTCActivity")_"】的值只能为Y或N，"
		}
		if (ImportType=1)
		{
			s flag=##class(web.DHCBL.CT.HOSPostDict).FormValidate("",Veobj.POSTCCode,Veobj.POSTCDesc)
			s:flag=1 myVresult=myVresult_"存在重复数据，"
		}
		q myVresult
	}
	
	if (tablecode="CT_BDP_CT.HOS_Position")	//HOS 组织职位
	{
		s:Veobj.POSStartDate'="" Veobj.POSStartDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(Veobj.POSStartDate)
		s:Veobj.POSEndDate'="" Veobj.POSEndDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(Veobj.POSEndDate)   
		if (Veobj.POSEndDate'="")
		{
			s:Veobj.POSEndDate<Veobj.POSStartDate myVresult=myVresult_"结束日期不能早于开始日期，"
		}
		
		// 是否有效(Y/N)
		if (Veobj.POSActivity'="")&&(Veobj.POSActivity'="Y")&&(Veobj.POSActivity'="N") 
		{
			s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"POSActivity")_"】的值只能为Y或N，"
		}
		if (ImportType=1)
		{
			s flag=##class(web.DHCBL.CT.HOSPosition).FormValidate("",Veobj.POSCode,Veobj.POSDesc)
			s:flag=1 myVresult=myVresult_"存在重复数据，"
		}
		q myVresult
	}
	
	if (tablecode="CT_BDP_CT.HOS_Post")	//HOS 业务岗位
	{
		s:Veobj.POSTStartDate'="" Veobj.POSTStartDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(Veobj.POSTStartDate)
		s:Veobj.POSTEndDate'="" Veobj.POSTEndDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(Veobj.POSTEndDate)   
		if (Veobj.POSTEndDate'="")
		{
			s:Veobj.POSTEndDate<Veobj.POSTStartDate myVresult=myVresult_"结束日期不能早于开始日期，"
		}
		
		// 是否有效(Y/N)
		if (Veobj.POSTActivity'="")&&(Veobj.POSTActivity'="Y")&&(Veobj.POSTActivity'="N") 
		{
			s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"POSTActivity")_"】的值只能为Y或N，"
		}
		if (ImportType=1)
		{
			s flag=##class(web.DHCBL.CT.HOSPost).FormValidate("",Veobj.POSTCode,Veobj.POSTDesc)
			s:flag=1 myVresult=myVresult_"存在重复数据，"
		}
		q myVresult
	}
	if (tablecode="CT_BDP_CT.HOS_Department")	//HOS 组织部门
	{
		s:Veobj.DEPTStartDate'="" Veobj.DEPTStartDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(Veobj.DEPTStartDate)
		s:Veobj.DEPTEndDate'="" Veobj.DEPTEndDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(Veobj.DEPTEndDate)   
		if (Veobj.DEPTEndDate'="")
		{
			s:Veobj.DEPTEndDate<Veobj.DEPTStartDate myVresult=myVresult_"结束日期不能早于开始日期，"
		}
		
		s:Veobj.DEPTFoundDate'="" Veobj.DEPTFoundDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(Veobj.DEPTFoundDate)
		s:Veobj.DEPTCancelDate'="" Veobj.DEPTCancelDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(Veobj.DEPTCancelDate)   
		if (Veobj.DEPTCancelDate'="")
		{
			s:Veobj.DEPTCancelDate<Veobj.DEPTFoundDate myVresult=myVresult_"注销日期不能早于建立日期，"
		}
		
		// 是否有效(Y/N)
		if (Veobj.DEPTActivity'="")&&(Veobj.DEPTActivity'="Y")&&(Veobj.DEPTActivity'="N") 
		{
			s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"DEPTActivity")_"】的值只能为Y或N，"
		}
		if (ImportType=1)
		{
			s flag=##class(web.DHCBL.CT.HOSDepartment).FormValidate("",Veobj.DEPTCode,Veobj.DEPTDesc,Veobj.DEPTDeptCode)
			s:flag=1 myVresult=myVresult_"存在重复数据，"
		}
		q myVresult
	}
	
	if (tablecode="CT_BDP_CT.HOS_OrgCategory")	//HOS 组织机构大类
	{
		s:Veobj.ORGCStartDate'="" Veobj.ORGCStartDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(Veobj.ORGCStartDate)
		s:Veobj.ORGCEndDate'="" Veobj.ORGCEndDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(Veobj.ORGCEndDate)   
		if (Veobj.ORGCEndDate'="")
		{
			s:Veobj.ORGCEndDate<Veobj.ORGCStartDate myVresult=myVresult_"结束日期不能早于开始日期，"
		}
		
		
		// 是否有效(Y/N)
		if (Veobj.ORGCActivity'="")&&(Veobj.ORGCActivity'="Y")&&(Veobj.ORGCActivity'="N") 
		{
			s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"ORGCActivity")_"】的值只能为Y或N，"
		}
		if (ImportType=1)
		{
			s flag=##class(web.DHCBL.CT.HOSOrgCategory).FormValidate("",Veobj.ORGCCode,Veobj.ORGCDesc)
			s:flag=1 myVresult=myVresult_"存在重复数据，"
		}
		q myVresult
	}

	if (tablecode="CT_BDP_CT.HOS_OrgSubCategory")	//HOS 组织机构子类
	{
		s:Veobj.ORGSCStartDate'="" Veobj.ORGSCStartDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(Veobj.ORGSCStartDate)
		s:Veobj.ORGSCEndDate'="" Veobj.ORGSCEndDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(Veobj.ORGSCEndDate)   
		if (Veobj.ORGSCEndDate'="")
		{
			s:Veobj.ORGSCEndDate<Veobj.ORGSCStartDate myVresult=myVresult_"结束日期不能早于开始日期，"
		}
		
		
		// 是否有效(Y/N)
		if (Veobj.ORGSCActivity'="")&&(Veobj.ORGSCActivity'="Y")&&(Veobj.ORGSCActivity'="N") 
		{
			s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"ORGSCActivity")_"】的值只能为Y或N，"
		}
		if (ImportType=1)
		{
			s flag=##class(web.DHCBL.CT.HOSOrgSubCategory).FormValidate("",Veobj.ORGSCCode,Veobj.ORGSCDesc)
			s:flag=1 myVresult=myVresult_"存在重复数据，"
		}
		q myVresult
	}

	if (tablecode="CT_BDP_CT.HOS_OrgMinCategory")	//HOS 组织机构小类
	{
		s:Veobj.ORGMCStartDate'="" Veobj.ORGMCStartDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(Veobj.ORGMCStartDate)
		s:Veobj.ORGMCEndDate'="" Veobj.ORGMCEndDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(Veobj.ORGMCEndDate)   
		if (Veobj.ORGMCEndDate'="")
		{
			s:Veobj.ORGMCEndDate<Veobj.ORGMCStartDate myVresult=myVresult_"结束日期不能早于开始日期，"
		}
		
		
		// 是否有效(Y/N)
		if (Veobj.ORGMCActivity'="")&&(Veobj.ORGMCActivity'="Y")&&(Veobj.ORGMCActivity'="N") 
		{
			s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"ORGMCActivity")_"】的值只能为Y或N，"
		}
		if (ImportType=1)
		{
			s flag=##class(web.DHCBL.CT.HOSOrgMinCategory).FormValidate("",Veobj.ORGMCCode,Veobj.ORGMCDesc)
			s:flag=1 myVresult=myVresult_"存在重复数据，"
		}
		q myVresult
	}

	if (tablecode="CT_BDP_CT.HOS_OrgAdminType")	//HOS 组织行政属性字典
	{
		s:Veobj.ORGACStartDate'="" Veobj.ORGACStartDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(Veobj.ORGACStartDate)
		s:Veobj.ORGACEndDate'="" Veobj.ORGACEndDate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(Veobj.ORGACEndDate)   
		if (Veobj.ORGACEndDate'="")
		{
			s:Veobj.ORGACEndDate<Veobj.ORGACStartDate myVresult=myVresult_"结束日期不能早于开始日期，"
		}
		
		
		// 是否有效(Y/N)
		if (Veobj.ORGACActivity'="")&&(Veobj.ORGACActivity'="Y")&&(Veobj.ORGACActivity'="N") 
		{
			s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"ORGACActivity")_"】的值只能为Y或N，"
		}
		if (ImportType=1)
		{
			s flag=##class(web.DHCBL.CT.HOSOrgAdminType).FormValidate("",Veobj.ORGACCode,Veobj.ORGACDesc)
			s:flag=1 myVresult=myVresult_"存在重复数据，"
		}
		q myVresult
	}

	if (tablecode="DHC_PHCInstrRecLoc")	// 用法接收科室
	{
		///2020-06-06 云HIS 校验医院
		s validStr= ##class(web.DHCBL.BDP.BDPMappingHOSP).ValidateHospId(tablename,Veobj.LinkHospId)  ///校验医院
		if (validStr'="")
		{
			s myVresult=myVresult_validStr
			q myVresult
		}
		s ParRef=$o(^PHCIN(0,"Code",$$ALPHAUP^SSUTIL4(Veobj.PHCINCode),0))	//##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("ARC_ItemCat",)
		if (ParRef'="")	//用法不存在
		{	
			s Desc=$p($g(^PHCIN(ParRef)),"^",2)
			
			if (Veobj.PHCINDesc'=Desc)	//用法代码和描述不对应
			{
				s myVresult=myVresult_"【"_..GetFieldDescByName(ID,"ARCICCode")_"】和用法描述不对应，"	
			}
			s InstrTimeRange=Veobj.InstrTimeRangeFrom_"~"_Veobj.InstrTimeRangeTo
			s str=Veobj.InstrOrdPrior_"^"_InstrTimeRange_"^"_Veobj.InstrHospitalDR
			s flag=##class(web.DHCBL.CT.DHCPHCInstrRecLoc).FormValidate("",ParRef,Veobj.InstrOrdDep,Veobj.InstrRecLoc,Veobj.InstrOrdSubCat,str)  //调用重复验证
			if (flag=1)	//判断重复
			{
				s myVresult=myVresult_"与另一条相同接收科室记录的时间冲突，"
				s result = "{success:'false',errorinfo:'与另一条相同接收科室记录的时间冲突，请确认！',InstructDesc:'"_InstructDesc_"',InstrOrdSubCatDesc:'"_InstrOrdSubCatDesc_"',InstrOrdDepDesc:'"_InstrOrdDepDesc_"',InstrRecLocDesc:'"_InstrRecLocDesc_"'}"
			}
			elseif (flag=2)	//医嘱子类所在医院组和病人科室所在医院组不同
			{
				s myVresult=myVresult_"医嘱子类与病人科室不在同一个医院组，"
			}
		}
		else		//用法不存在
		{
			s myVresult=myVresult_"用法代码对应的数据不存在，"	
		}
		q myVresult
	}
	q myVresult
}

/// Creator:陈莹
/// CreatDate:2017-04-07
/// Description:校验导入密码是否正确
/// Input:password
/// Return:1（校验通过）, 0 不通过
/// Other:w ##class(web.DHCBL.BDP.BDPDataImport).ValidatePassword("bdp","J")
ClassMethod ValidatePassword(password, type) As %String
{
	n (password,type)
	S flag=0
	///在平台配置下设置   新装密码  追加和修改密码   拼音全拼
	if type="J"
	{
		if (password="zhuijia")||(password="ZHUIJIA") S flag=1
	}
	if (type="U")||(type="N")
	{
		if (password="xiuzheng")||(password="XIUZHENG") S flag=1
	}
	if (type="U")||(type="N")
	{
		if (password="xinzhuang")||(password="XINZHUANG") S flag=1
	}
	q flag
}

/// chenying 
/// add @20190702
/// 用于导入配置，根据表明、数据描述及当前登录人所在医院 获取数据的rowid
/// w ##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByDesc("DHC_TarCate","检查费[口腔]",3)
/// w ##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByDesc("OEC_OrderCategory",OrdCat)
/// w ##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByDesc("DHC_TarMRCateNew","非手术治疗项目费 ")
/// flag=0 时， 有私有数据取私有数据，没有则取共有数据。flag=1时，不取公共数据id，只取私有数据数据id
/// flag=2 无论公有还是私有，只要存在取第一个
ClassMethod GetRowIdByDesc(TableName As %String, Desc As %String, HOSPID As %String = "") As %String
{
	n (TableName,Desc,HOSPID)
	q:TableName="" ""
	s:HOSPID'="" HOSPID=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName(TableName,HOSPID) //获取医院id+表对应的默认组医院
	s hosplinkid=""
	///获取医院级授权标志
	i '$d(^||TMPBDP("BDPHospAutflag",$j))
	{
		s BDPHospAutflag = ##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPHospAut")  //获取平台配置是否开启医院级别授权
		s ^||TMPBDP("BDPHospAutflag",$j)=BDPHospAutflag
	}
	else
	{	
		s BDPHospAutflag=^||TMPBDP("BDPHospAutflag",$j)
	}
	if BDPHospAutflag="Y"
	{
		//获取数据公有私有类型
		i '$d(^||TMPBDP("DataType",TableName,$j))
		{
			s datatype=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDataType(TableName)	 //获取数据公有私有类型
			s ^||TMPBDP("DataType",TableName,$j)=datatype
		}
		else
		{	
			s datatype=^||TMPBDP("DataType",TableName,$j)
		}
		//s datatype=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDataType(TableName)
		/// flag=0 时， 有私有数据取私有数据，没有则取共有数据。flag=1时，不取公共数据id，只取私有数据数据id
		if datatype="S" s flag=1    //私有
		else  if datatype="C" s flag=1 //管控   原来是0 先按照私有来取 2020-01-06
		else  if datatype="G" s flag=2  //公有
		else  if datatype="A" s flag=1  //绝对私有
	}
	else
	{
		//不开启医院级授权
		s flag=2    /// flag=2 无论公有还是私有，只要存在取第一个
	}
	q:Desc="" ""
	s Value=Desc
	if (TableName="PH_Manufacturer") //厂商
	{
		s DataType=$p(Desc,"^",2)
		s Value=$p(Desc,"^",1)
		q:$$ALPHAUP^SSUTIL4(Value)="" ""
		s id=0
		for
		{
			s id=$o(^PHMNF(0,"Name",$$ALPHAUP^SSUTIL4(Value),id)) Q:id=""
			s PHMNFName=$p($g(^PHMNF(id)),"^",2)
			continue:(PHMNFName'=Value)
			s MANFRowid=$o(^DHCMANF(0,"MANF",id,0))  //2021-01-04校验类型
			if MANFRowid'=""
			{
				s MANFType=$p($g(^DHCMANF(MANFRowid)),"^",7)
				if DataType'="" continue:MANFType'=DataType
				if ((flag=2)||(flag=0)||(HOSPID=""))
				{
					s hosplinkid=id
					q
				}
				else
				{
					if $d(^User.BDPMappingHospI("DataRef",TableName,HOSPID,id))>0
					{
						s hosplinkid=id
						q
					}
				}
			}
			
		}
	}
	if (TableName="APC_Vendor") //供应商
	{
		s DataType=$p(Value,"^",2)
		s Value=$p(Value,"^",1)
		q:$$ALPHAUP^SSUTIL4(Value)="" ""
		s id=0
		for
		{
			s id=$o(^APC("APCVM",0,"APCVM_Name",$$ALPHAUP^SSUTIL4(Value),id)) Q:id=""
			s APCVMName=$p($g(^APC("APCVM",id)),"^",3)  //供应商名称
			if (APCVMName'=Value) continue
			s APCVMType=$p($g(^APC("APCVM",id)),"^",9)  //2021-01-04 校验类型
			if DataType'="" continue:APCVMType'=DataType
			if ((flag=2)||(flag=0)||(HOSPID=""))
			{
				s hosplinkid=id
				q
			}
			else
			{
				if $d(^User.BDPMappingHospI("DataRef",TableName,HOSPID,id))>0
				{
					s hosplinkid=id
					q
				}
			}
			
		}
	}
	if (TableName="DHC_STOrigin") //产地  管控
	{
		s DataType=$p(Value,"^",2)
		s Value=$p(Value,"^",1)
		s id=0
		for
		{
			s id=$o(^DHCSTORI(id)) q:id=""
			s ORIName=$p($g(^DHCSTORI(id)),"^",2)
			continue:(ORIName'=Value)
			s OrigType=$p($g(^DHCSTORI(id)),"^",3)  //2021-01-04 校验类型
			if DataType'="" continue:OrigType'=DataType
			if ((flag=2)||(flag=0)||(HOSPID=""))
			{
				s hosplinkid=id
				q
			}
			else
			{
				if $d(^User.BDPMappingHospI("DataRef",TableName,HOSPID,id))>0
				{
					s hosplinkid=id
					q
				}
			}
			
		}
	}
	if (TableName="DHC_Carrier") // 配送商  私有
	{
		s DataType=$p(Value,"^",2)
		s Value=$p(Value,"^",1)
		q:$$ALPHAUP^SSUTIL4(Value)="" ""
		s id=0
		for
		{
			s id=$o(^DHCCARR(0,"Desc",$$ALPHAUP^SSUTIL4(Value),id)) Q:id=""
			s CADesc=$p($g(^DHCCARR(id)),"^",2)
			continue:(CADesc'=Value)
			s CAType=$p($g(^DHCCARR(id)),"^",3)  //2021-01-04 校验类型
			if DataType'="" continue:CAType'=DataType
			if ((flag=2)||(flag=0)||(HOSPID=""))
			{
				s hosplinkid=id
				q
			}
			else
			{
				if $d(^User.BDPMappingHospI("DataRef",TableName,HOSPID,id))>0
				{
					s hosplinkid=id
					q
				}
			}
		}
	}
	if (TableName="DHCExaBorough") // 分诊区   绝对私有
	{
		s id=0
		for
		{
			s id=$o(^User.DHCExaBoroughD(id)) q:id=""
			s ExabName=$lg($g(^User.DHCExaBoroughD(id)),5)
			if (ExabName=Value)
			{
				if (flag=2)||(flag=0) s hosplinkid=id
				if (flag=2) q
				s ExabHospitalDr=$LISTGET($g(^User.DHCExaBoroughD(id)),13)
				if (ExabHospitalDr=HOSPID) //2020-04-07 判断分诊区的医院
				{
					s hosplinkid=id
					q
				}
			}
		}
	}
	if (TableName="SS_Group")  //安全组
	{
		q:$$ALPHAUP^SSUTIL4(Desc)="" ""
		s AuHospFlag=0 
		if $d(^SSU("SSGRP",0,"Desc"))  //有描述索引
		{
			s SSGRPRowId=0
			for
			{
				s SSGRPRowId=$o(^SSU("SSGRP",0,"Desc",Desc,SSGRPRowId)) q:((SSGRPRowId="")||(AuHospFlag=1))
				if (flag=2)||(flag=0) s hosplinkid=SSGRPRowId
				if (flag=2) q
				if HOSPID="" q
					
				s HOSPChildsub=0
				for
				{
					s HOSPChildsub=$o(^SSU("SSGRP",SSGRPRowId,"HOSP",HOSPChildsub)) q:(HOSPChildsub="")||(AuHospFlag=1)
					s CTHospitalDR=$p($g(^SSU("SSGRP",SSGRPRowId,"HOSP",HOSPChildsub)),"^",1)
					if (CTHospitalDR=HOSPID)
					{
						 s hosplinkid=SSGRPRowId
						 s AuHospFlag=1
						 q
					}
				}
			}
			
		}
		else
		{
			s SSGRPRowId=0
			for
			{
				s SSGRPRowId=$o(^SSU("SSGRP",SSGRPRowId)) q:((SSGRPRowId="")||(AuHospFlag=1))
				s SSGRPDesc=$p($g(^SSU("SSGRP",SSGRPRowId)),"^",1)
				if (SSGRPDesc=Desc)
				{
					if (flag=2)||(flag=0) s hosplinkid=SSGRPRowId
					if (flag=2) q
					if HOSPID="" q
						
					s HOSPChildsub=0
					for
					{
						s HOSPChildsub=$o(^SSU("SSGRP",SSGRPRowId,"HOSP",HOSPChildsub)) q:(HOSPChildsub="")||(AuHospFlag=1)
						s CTHospitalDR=$p($g(^SSU("SSGRP",SSGRPRowId,"HOSP",HOSPChildsub)),"^",1)
						if (CTHospitalDR=HOSPID)
						{
							 s hosplinkid=SSGRPRowId
							 s AuHospFlag=1
							 q
						}
					}
				}
			}
		}
	}
	if (TableName="RBC_EquipmentGroup")  //资源组
	{
		q:$$ALPHAUP^SSUTIL4(Desc)="" ""
		if (flag=2)||(flag=0) s hosplinkid=$o(^RBC("GRP",0,"Desc",$$ALPHAUP^SSUTIL4(Desc),0))
		if HOSPID="" q hosplinkid
		if (flag=2) q hosplinkid
		s id=0
		for
		{
			s id=$o(^RBC("GRP",0,"Desc",$$ALPHAUP^SSUTIL4(Desc),id)) Q:id=""
			if $d(^User.BDPMappingHospI("DataRef",TableName,HOSPID,id))>0
			{
				s hosplinkid=id
				q
			}
		}
	}
	
	if (TableName="RBC_ServiceGroup") //服务组
	{
		q:$$ALPHAUP^SSUTIL4(Desc)="" ""
		if (flag=2)||(flag=0) s hosplinkid=$o(^RBC("SG",0,"Desc",$$ALPHAUP^SSUTIL4(Desc),0))
		if HOSPID="" q hosplinkid
		if (flag=2) q hosplinkid
		s id=0
		for
		{
			s id=$o(^RBC("SG",0,"Desc",$$ALPHAUP^SSUTIL4(Desc),id)) Q:id=""
			if $d(^User.BDPMappingHospI("DataRef",TableName,HOSPID,id))>0
			{
				s hosplinkid=id
				q
			}
		}
	}
	if (TableName="ARC_ItemCat") //医嘱子类
	{
		q:$$ALPHAUP^SSUTIL4(Desc)="" ""
		if (flag=2)||(flag=0) s hosplinkid=$o(^ARC("IC",0,"Desc",$$ALPHAUP^SSUTIL4(Desc),0))
		
		if HOSPID="" q hosplinkid
		if (flag=2) q hosplinkid
		s id=0
		for
		{
			s id=$o(^ARC("IC",0,"Desc",$$ALPHAUP^SSUTIL4(Desc),id)) Q:id=""
			if $d(^User.BDPMappingHospI("DataRef",TableName,HOSPID,id))>0
			{
				s hosplinkid=id
				q
			}	
		}
	}
	
	if (TableName="OEC_OrderCategory") //医嘱大类
	{
		q:$$ALPHAUP^SSUTIL4(Desc)="" ""
		if (flag=2)||(flag=0) s hosplinkid=$o(^OEC("ORCAT",0,"Desc",$$ALPHAUP^SSUTIL4(Desc),0))
		if HOSPID="" q hosplinkid
		if (flag=2) q hosplinkid
		s id=0
		for
		{
			s id=$o(^OEC("ORCAT",0,"Desc",$$ALPHAUP^SSUTIL4(Desc),id)) Q:id=""
			if $d(^User.BDPMappingHospI("DataRef",TableName,HOSPID,id))>0
			{
				s hosplinkid=id
				q
			}
		}
	}
	if (TableName="PAC_AdmReason")  //患者费别2019-11-25
	{
		q:$$ALPHAUP^SSUTIL4(Desc)="" ""
		if (flag=2)||(flag=0) s hosplinkid=$o(^PAC("ADMREA",0,"Desc",$$ALPHAUP^SSUTIL4(Desc),0))
		
		if HOSPID="" q hosplinkid
		if (flag=2) q hosplinkid
		s id=0
		for
		{
			s id=$o(^PAC("ADMREA",0,"Desc",$$ALPHAUP^SSUTIL4(Desc),id)) Q:id=""
			if $d(^User.BDPMappingHospI("DataRef",TableName,HOSPID,id))>0
			{
				s hosplinkid=id
				q
			}	
		}
	}
	
	if (TableName="CT_SocialStatus")  //患者类别
	{
		q:$$ALPHAUP^SSUTIL4(Desc)="" ""
		if (flag=2)||(flag=0) s hosplinkid=$o(^CT("SS",0,"Desc",$$ALPHAUP^SSUTIL4(Desc),0))
		
		if HOSPID="" q hosplinkid
		if (flag=2) q hosplinkid
		s id=0
		for
		{
			s id=$o(^CT("SS",0,"Desc",$$ALPHAUP^SSUTIL4(Desc),id)) Q:id=""
			if $d(^User.BDPMappingHospI("DataRef",TableName,HOSPID,id))>0
			{
				s hosplinkid=id
				q
			}	
		}
		
	}
	if (TableName="INC_StkCat")
	{
		s DataType=$p(Desc,"^",2)
		s Desc=$p(Desc,"^",1)
		q:$$ALPHAUP^SSUTIL4(Desc)="" ""
		s id=0
		for
		{
			s id=$o(^INC("SC",0,"Desc",$$ALPHAUP^SSUTIL4(Desc),id)) Q:id=""
			s stkType = $p($g(^INC("SC", id)), "^", 3)
			continue:(DataType'="")&&(DataType '= stkType)
			if ((flag=2)||(flag=0)||(HOSPID=""))
			{
				s hosplinkid=id
				q
			}
			else
			{
				if $d(^User.BDPMappingHospI("DataRef",TableName,HOSPID,id))>0
				{
					s hosplinkid=id
					q
				}
			}
		}
	}
	
	if (TableName="DHC_StkCatGroup")  ///库存类组
	{
		s DataType=$p(Desc,"^",2)
		s Value=$p(Desc,"^",1)
		q:$$ALPHAUP^SSUTIL4(Value)="" ""
		s id=0
		for
		{
			s id=$o(^DHCSCG(id)) Q:(id="")||(id="STKCAT")
			s scgdesc=$p($g(^DHCSCG(id)),"^",2)
			s scgtype=$p($g(^DHCSCG(id)),"^",3)
			continue:(DataType'="")&&(scgtype'=DataType)
			if scgdesc=Value
			{
				if ((flag=2)||(flag=0)||(HOSPID=""))
				{
					s hosplinkid=id
					q
				}
				else
				{
					if $d(^User.BDPMappingHospI("DataRef",TableName,HOSPID,id))>0
					{
						s hosplinkid=id
						q
					}
				}
			}
		}
	}
	if (TableName="PHC_DrgMast")
	{
		q:$$ALPHAUP^SSUTIL4(Desc)="" ""
		if (flag=2)||(flag=0) s hosplinkid=$o(^PHCD(0,"Name",$$ALPHAUP^SSUTIL4(Desc),0))
		if HOSPID="" q hosplinkid
		if (flag=2) q hosplinkid
		s id=0
		for
		{
			s id=$o(^PHCD(0,"Name",$$ALPHAUP^SSUTIL4(Desc),id)) Q:id=""
			if $p($g(^PHCD(id,1)),"^",2)=Desc
			{
				if $d(^User.BDPMappingHospI("DataRef",TableName,HOSPID,id))>0
				{
					s hosplinkid=id
					q
				}
			}
		}
	}
	if (TableName="ARC_ItmMast")
	{
		q:$$ALPHAUP^SSUTIL4(Desc)="" ""
		s AuHospFlag=0 
		s subscripts=0
		for
		{
			s subscripts=$o(^ARCIM(0,"Desc",$$ALPHAUP^SSUTIL4(Desc),subscripts)) Q:(subscripts="")||(AuHospFlag=1)
			s sub=0
			for
			{
				s sub=$o(^ARCIM(0,"Desc",$$ALPHAUP^SSUTIL4(Desc),subscripts,sub)) Q:(sub="")||(AuHospFlag=1)
				if $p($g(^ARCIM(subscripts,sub,1)),"^",2)=Desc
				{
					s realid=subscripts_"||"_sub
					if (flag=2)||(flag=0) s hosplinkid=realid
					if (flag=2) q
					if HOSPID="" q
					s HospChildsub=0
					for
					{
						s HospChildsub=$o(^ARCIM(subscripts,sub,"HOSP",HospChildsub)) q:(HospChildsub="")||(AuHospFlag=1)  
						s HOSPHospitalDR=$p($g(^ARCIM(subscripts,sub,"HOSP",HospChildsub)),"^",1)  
						if (HOSPHospitalDR=HOSPID)
						{
							s AuHospFlag=1
							s hosplinkid=realid
							q
						}
					}
				}
			}
		}
	}
	if (TableName="DHC_TarItem")
	{
		if (flag=2)||(flag=0)
		{
			s id=0
			for
			{
				s id=$o(^DHCTARI(0,"Desc",Desc,id)) Q:id=""
				if $p($g(^DHCTARI(id)),"^",2)=Desc
				{
					s hosplinkid=id
					q
				}
			} 
		}
		if HOSPID="" q hosplinkid
		if (flag=2) q hosplinkid
		s id=0
		for
		{
			s id=$o(^DHCTARI(0,"Desc",Desc,id)) Q:id=""
			if $p($g(^DHCTARI(id)),"^",2)=Desc
			{
				if $d(^User.BDPMappingHospI("DataRef",TableName,HOSPID,id))>0
				{
					s hosplinkid=id
					q
				}
			}
		}
		
	}
	if (TableName="INC_Itm")
	{
		q:$$ALPHAUP^SSUTIL4(Desc)="" ""
		if (flag=2)||(flag=0)
		{
			s id=0
			for
			{
				s id=$o(^INCI(0,"Desc",$$ALPHAUP^SSUTIL4(Desc),id)) Q:id=""
				if $p($g(^INCI(id,1)),"^",2)=Desc
				{
					s hosplinkid=id
					q
				}
			}  
		}
		if HOSPID="" q hosplinkid
		if (flag=2) q hosplinkid
		s id=0
		for
		{
			s id=$o(^INCI(0,"Desc",$$ALPHAUP^SSUTIL4(Desc),id)) Q:id=""
			if $p($g(^INCI(id,1)),"^",2)=Desc
			{
				//库存项表DHC_ItmAddHosp
				if $d(^ITMADDHOP(0,"HospInc",HOSPID,id))>0
				{
					s hosplinkid=id
					q
				}
			}
		}
		
	}
	if (TableName="ARC_BillGrp")  //账单组
	{
		q:$$ALPHAUP^SSUTIL4(Desc)="" ""
		if (flag=2)||(flag=0) s hosplinkid=$o(^ARCBG(0,"DESC",$$ALPHAUP^SSUTIL4(Desc),0))
		if HOSPID="" q hosplinkid
		if (flag=2) q hosplinkid
		s id=0
		for
		{
			s id=$o(^ARCBG(0,"DESC",$$ALPHAUP^SSUTIL4(Desc),id)) Q:id=""
			if $d(^User.BDPMappingHospI("DataRef",TableName,HOSPID,id))>0
			{
				s hosplinkid=id
				q
			}	
		}
	}
	if (TableName="ARC_BillSub")  //账单子组
	{
		q:$$ALPHAUP^SSUTIL4(Desc)="" ""
		s id=0
		for
		{
			s id=$o(^ARCBG("SG_Desc",$$ALPHAUP^SSUTIL4(Desc),id)) Q:id=""
			s sub=0
			for
			{
				s sub=$o(^ARCBG("SG_Desc",$$ALPHAUP^SSUTIL4(Desc),id,sub)) Q:sub=""
				s realid=id_"||"_sub
				if (flag=2)
				{
					s hosplinkid=realid
					q	
				}
				if HOSPID="" q
				if $d(^User.BDPMappingHospI("DataRef",TableName,HOSPID,realid))>0
				{
					s hosplinkid=realid
					q
				}
			}	
		}
	}
	if (TableName="CT_Loc") //科室
	{
		q:$$ALPHAUP^SSUTIL4(Desc)="" ""
		if (flag=2)||(flag=0) s hosplinkid=$o(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(Desc),0))
		if HOSPID="" q hosplinkid
		if (flag=2) q hosplinkid
		s id=0
		for
		{
			s id=$o(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(Desc),id)) Q:id=""
			S hospitalid=$p($g(^CTLOC(id)),"^",22)
			if HOSPID=hospitalid
			{
				s hosplinkid=id
				q	
			}	
		}
	}
	if (TableName="PAC_Ward")  //病区
	{
		q:$$ALPHAUP^SSUTIL4(Desc)="" ""
		if (flag=2)||(flag=0) s hosplinkid=$o(^PAWARD(0,"WARD_Desc",$$ALPHAUP^SSUTIL4(Desc),0))
		if HOSPID="" q hosplinkid
		if (flag=2) q hosplinkid
		s id=0
		for
		{
			s id=$o(^PAWARD(0,"WARD_Desc",$$ALPHAUP^SSUTIL4(Desc),id)) Q:id=""
			s WARDLocationDR=$p($g(^PAWARD(id)),"^",5)  //病区里的科室指针
			if WARDLocationDR'=""
			{
				S hospitalid=$p($g(^CTLOC(WARDLocationDR)),"^",22)
				if HOSPID=hospitalid
				{
					s hosplinkid=id
					q	
				}
			}
		}
	}
	
	if (TableName="CT_UOM")  //单位
	{
		q:Desc="" ""
		if (flag=2)||(flag=0) s hosplinkid=$o(^CT("UOM",0,"Desc",$$UPPER^SSUTIL4(Desc),0))
		if HOSPID="" q hosplinkid
		if (flag=2) q hosplinkid
		s id=0
		for
		{
			s id=$o(^CT("UOM",0,"Desc",$$UPPER^SSUTIL4(Desc),id)) Q:id=""
			if $d(^User.BDPMappingHospI("DataRef",TableName,HOSPID,id))>0
			{
				s hosplinkid=id
				q
			}
		}
	}
	
	
	if (TableName="DHC_TarMCNew") //新病案首页大类
	{
		q:Desc="" ""
		if (flag=2)||(flag=0) s hosplinkid=$o(^DHCTARMCNEW(0,"Desc",Desc,0))
		if HOSPID="" q hosplinkid
		if (flag=2) q hosplinkid
		s id=0
		for
		{
			s id=$o(^DHCTARMCNEW(0,"Desc",Desc,id)) Q:id=""
			if $d(^User.BDPMappingHospI("DataRef",TableName,HOSPID,id))>0
			{
				s hosplinkid=id
				q
			}
		}
	}
	
	if (TableName="DHC_TarMCCateNew")  //新病案首页子类
	{
		q:Desc="" ""
		if (flag=2)||(flag=0) s hosplinkid=$o(^DHCTARMRCATENEW(0,"Desc",Desc,0))
		if HOSPID="" q hosplinkid
		if (flag=2) q hosplinkid
		s id=0
		for
		{
			s id=$o(^DHCTARMRCATENEW(0,"Desc",Desc,id)) Q:id=""
			if $d(^User.BDPMappingHospI("DataRef",TableName,HOSPID,id))>0
			{
				s hosplinkid=id
				q
			}
		}
	}
	if (TableName="DHC_TarAC")
	{
		q:Desc="" ""
		if (flag=2)||(flag=0) s hosplinkid=$o(^DHCTarC("TAC",0,"Desc",Desc,0))
		if HOSPID="" q hosplinkid
		if (flag=2) q hosplinkid
		s id=0
		for
		{
			s id=$o(^DHCTarC("TAC",0,"Desc",Desc,id)) Q:id=""
			if $d(^User.BDPMappingHospI("DataRef",TableName,HOSPID,id))>0
			{
				s hosplinkid=id
				q
			}
		}
	}
	if (TableName="DHC_TarAcctCate")
	{
		q:Desc="" ""
		if (flag=2)||(flag=0) s hosplinkid=$o(^DHCTarC("AC",0,"Desc",Desc,0))
		if HOSPID="" q hosplinkid
		if (flag=2) q hosplinkid
		s id=0
		for
		{
			s id=$o(^DHCTarC("AC",0,"Desc",Desc,id)) Q:id=""
			if $d(^User.BDPMappingHospI("DataRef",TableName,HOSPID,id))>0
			{
				s hosplinkid=id
				q
			}
		}
	}
	
	if (TableName="DHC_TarCate")
	{
		q:Desc="" ""
		if (flag=2)||(flag=0) s hosplinkid=$o(^DHCTarC("CC",0,"Desc",Desc,0))
		if HOSPID="" q hosplinkid
		if (flag=2) q hosplinkid
		s id=0
		for
		{
			s id=$o(^DHCTarC("CC",0,"Desc",Desc,id)) Q:id=""
			if $d(^User.BDPMappingHospI("DataRef",TableName,HOSPID,id))>0
			{
				s hosplinkid=id
				q
			}
		}
	}
	
	if (TableName="DHC_TarEC")
	{
		q:Desc="" ""
		if (flag=2)||(flag=0) s hosplinkid=$o(^DHCTarC("TEC",0,"Desc",Desc,0))
		if HOSPID="" q hosplinkid
		if (flag=2) q hosplinkid
		s id=0
		for
		{
			s id=$o(^DHCTarC("TEC",0,"Desc",Desc,id)) Q:id=""
			if $d(^User.BDPMappingHospI("DataRef",TableName,HOSPID,id))>0
			{
				s hosplinkid=id
				q
			}
		}
	}
	if (TableName="DHC_TarEMCCate")
	{
		q:Desc="" ""
		if (flag=2)||(flag=0) s hosplinkid=$o(^DHCTarC("EC",0,"Desc",Desc,0))
		if HOSPID="" q hosplinkid
		if (flag=2) q hosplinkid
		s id=0
		for
		{
			s id=$o(^DHCTarC("EC",0,"Desc",Desc,id)) Q:id=""
			if $d(^User.BDPMappingHospI("DataRef",TableName,HOSPID,id))>0
			{
				s hosplinkid=id
				q
			}
		}
	}
	if (TableName="DHC_TarIC")
	{
		q:Desc="" ""
		if (flag=2)||(flag=0) s hosplinkid=$o(^DHCTarC("TIC",0,"Desc",Desc,0))
		if HOSPID="" q hosplinkid
		if (flag=2) q hosplinkid
		s id=0
		for
		{
			s id=$o(^DHCTarC("TIC",0,"Desc",Desc,id)) Q:id=""
			if $d(^User.BDPMappingHospI("DataRef",TableName,HOSPID,id))>0
			{
				s hosplinkid=id
				q
			}
		}
	}
	if (TableName="DHC_TarInpatCate")
	{
		q:Desc="" ""
		if (flag=2)||(flag=0) s hosplinkid=$o(^DHCTarC("IC",0,"Desc",Desc,0))
		if HOSPID="" q hosplinkid
		if (flag=2) q hosplinkid
		s id=0
		for
		{
			s id=$o(^DHCTarC("IC",0,"Desc",Desc,id)) Q:id=""
			if $d(^User.BDPMappingHospI("DataRef",TableName,HOSPID,id))>0
			{
				s hosplinkid=id
				q
			}
		}
	}
	if (TableName="DHC_TarMC")
	{
		q:Desc="" ""
		if (flag=2)||(flag=0) s hosplinkid=$o(^DHCTarC("TMC",0,"Desc",Desc,0))
		if HOSPID="" q hosplinkid
		if (flag=2) q hosplinkid
		s id=0
		for
		{
			s id=$o(^DHCTarC("TMC",0,"Desc",Desc,id)) Q:id=""
			if $d(^User.BDPMappingHospI("DataRef",TableName,HOSPID,id))>0
			{
				s hosplinkid=id
				q
			}
		}
	}
	if (TableName="DHC_TarMRCate")
	{
		q:Desc="" ""
		if (flag=2)||(flag=0) s hosplinkid=$o(^DHCTarC("MC",0,"Desc",Desc,0))
		if HOSPID="" q hosplinkid
		if (flag=2) q hosplinkid
		s id=0
		for
		{
			s id=$o(^DHCTarC("MC",0,"Desc",Desc,id)) Q:id=""
			if $d(^User.BDPMappingHospI("DataRef",TableName,HOSPID,id))>0
			{
				s hosplinkid=id
				q
			}
		}
	}
	
	if (TableName="DHC_TarOC")
	{
		q:Desc="" ""
		if (flag=2)||(flag=0) s hosplinkid=$o(^DHCTarC("TOC",0,"Desc",Desc,0))
		if HOSPID="" q hosplinkid
		if (flag=2) q hosplinkid
		s id=0
		for
		{
			s id=$o(^DHCTarC("TOC",0,"Desc",Desc,id)) Q:id=""
			if $d(^User.BDPMappingHospI("DataRef",TableName,HOSPID,id))>0
			{
				s hosplinkid=id
				q
			}
		}
	}
	
	if (TableName="DHC_TarOutpatCate")
	{
		q:Desc="" ""
		if (flag=2)||(flag=0) s hosplinkid=$o(^DHCTarC("OC",0,"Desc",Desc,0))
		if HOSPID="" q hosplinkid
		if (flag=2) q hosplinkid
		s id=0
		for
		{
			s id=$o(^DHCTarC("OC",0,"Desc",Desc,id)) Q:id=""
			if $d(^User.BDPMappingHospI("DataRef",TableName,HOSPID,id))>0
			{
				s hosplinkid=id
				q
			}
		}
	}
	if (TableName="DHC_TarSubCate")
	{
		q:Desc="" ""
		if (flag=2)||(flag=0) s hosplinkid=$o(^DHCTarC("SC",0,"Desc",Desc,0))
		if HOSPID="" q hosplinkid
		if (flag=2) q hosplinkid
		s id=0
		for
		{
			s id=$o(^DHCTarC("SC",0,"Desc",Desc,id)) Q:id=""
			if $d(^User.BDPMappingHospI("DataRef",TableName,HOSPID,id))>0
			{
				s hosplinkid=id
				q
			}
		}
	}
	if (TableName="PAC_BedType")
	{
		q:Desc="" ""
		if (flag=2)||(flag=0) s hosplinkid=$o(^PAC("BEDTP",0,"BEDTP_Desc",$$ALPHAUP^SSUTIL4(Desc),0))
		if HOSPID="" q hosplinkid
		if (flag=2) q hosplinkid
		s id=0
		for
		{
			s id=$o(^PAC("BEDTP",0,"BEDTP_Desc",$$ALPHAUP^SSUTIL4(Desc),id)) Q:id=""
			if $d(^User.BDPMappingHospI("DataRef",TableName,HOSPID,id))>0
			{
				s hosplinkid=id
				q
			}
		}
	}
	
	if (TableName="PAC_RoomType")
	{
		q:Desc="" ""
		if (flag=2)||(flag=0) s hosplinkid=$o(^PAC("ROOMT",0,"Desc",$$ALPHAUP^SSUTIL4(Desc),0))
		if HOSPID="" q hosplinkid
		if (flag=2) q hosplinkid
		s id=0
		for
		{
			s id=$o(^PAC("ROOMT",0,"Desc",$$ALPHAUP^SSUTIL4(Desc),id)) Q:id=""
			if $d(^User.BDPMappingHospI("DataRef",TableName,HOSPID,id))>0
			{
				s hosplinkid=id
				q
			}
		}
	}
	if (TableName="PAC_Room")
	{
		q:Desc="" ""
		if (flag=2)||(flag=0) s hosplinkid=$o(^PAROOM(0,"ROOM_Desc",$$ALPHAUP^SSUTIL4(Desc),0))
		if HOSPID="" q hosplinkid
		if (flag=2) q hosplinkid
		s id=0
		for
		{
			s id=$o(^PAROOM(0,"ROOM_Desc",$$ALPHAUP^SSUTIL4(Desc),id)) Q:id=""
			if $d(^User.BDPMappingHospI("DataRef",TableName,HOSPID,id))>0
			{
				s hosplinkid=id
				q
			}
		}
	}
	if (TableName="RBC_DepartmentGroup")  ///科室部门组
	{
		q:Desc="" ""
		if (flag=2)||(flag=0) s hosplinkid=$o(^RBC("DEP",0,"Desc",$$ALPHAUP^SSUTIL4(Desc),0))
		if HOSPID="" q hosplinkid
		if (flag=2) q hosplinkid
		s id=0
		for
		{
			s id=$o(^RBC("DEP",0,"Desc",$$ALPHAUP^SSUTIL4(Desc),id)) Q:id=""
			if $d(^User.BDPMappingHospI("DataRef",TableName,HOSPID,id))>0
			{
				s hosplinkid=id
				q
			}
		}
	}
	if (TableName="CT_CarPrvTp")
	{
		q:$$ALPHAUP^SSUTIL4(Desc)="" ""
		s hosplinkid=$o(^CT("CPT",0,"Desc",$$ALPHAUP^SSUTIL4(Desc),0))		
	}
	if (TableName="CT_Hospital")
	{
		q:$$ALPHAUP^SSUTIL4(Desc)="" ""
		s hosplinkid=$o(^CT("HOSP",0,"Desc",$$ALPHAUP^SSUTIL4(Desc),0))	
	}
	if (TableName="DHC_MarkType")  //定价类型 
	{
		q:$$ALPHAUP^SSUTIL4(Desc)="" ""
		if (flag=2)||(flag=0) s hosplinkid=$o(^DHCINMT(0,"Desc",$$ALPHAUP^SSUTIL4(Desc),0))
		if HOSPID="" q hosplinkid
		if (flag=2) q hosplinkid
		s id=0
		for
		{
			s id=$o(^DHCINMT(0,"Desc",$$ALPHAUP^SSUTIL4(Desc),id)) Q:id=""
			if $d(^User.BDPMappingHospI("DataRef",TableName,HOSPID,id))>0
			{
				s hosplinkid=id
				q
			}
		}
	}
	
	if (TableName="DHCST_BookCat")  //账簿分类 2020-01-04
	{
		q:$$ALPHAUP^SSUTIL4(Desc)="" ""
		if (flag=2)||(flag=0) s hosplinkid=$o(^DHCSTBC(0,"DESC",$$ALPHAUP^SSUTIL4(Desc),0))
		if HOSPID="" q hosplinkid
		if (flag=2) q hosplinkid
		s id=0
		for
		{
			s id=$o(^DHCSTBC(0,"DESC",$$ALPHAUP^SSUTIL4(Desc),id)) Q:id=""
			if $d(^User.BDPMappingHospI("DataRef",TableName,HOSPID,id))>0
			{
				s hosplinkid=id
				q
			}
		}
	}
	
	
	q hosplinkid
}

/// chenying 
/// add @@20190702
/// 用于导入配置，根据表明、数据描述及当前登录人所在医院 获取数据的rowid
/// w ##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("ARC_BillGrp","材料费")
/// w ##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("DHC_TarItem","110100000*1")
/// flag=0 时， 有私有数据取私有数据，没有则取共有数据。flag=1时，不取公共数据id，只取私有数据数据id
/// flag=2 无论公有还是私有，只要存在取第一个
ClassMethod GetRowIdByCode(TableName As %String, Code As %String, HOSPID As %String = "") As %String
{
	n (TableName,Code,HOSPID)
	s:HOSPID'="" HOSPID=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName(TableName,HOSPID) //获取医院id+表对应的默认组医院
	s hosplinkid=""
	///获取医院级授权标志
	i '$d(^||TMPBDP("BDPHospAutflag",$j))
	{
		s BDPHospAutflag = ##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPHospAut")  //获取平台配置是否开启医院级别授权
		s ^||TMPBDP("BDPHospAutflag",$j)=BDPHospAutflag
	}
	else
	{	
		s BDPHospAutflag=^||TMPBDP("BDPHospAutflag",$j)
	}
	if BDPHospAutflag="Y"
	{
		//获取数据公有私有类型
		i '$d(^||TMPBDP("DataType",TableName,$j))
		{
			s datatype=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDataType(TableName)	 //获取数据公有私有类型
			s ^||TMPBDP("DataType",TableName,$j)=datatype
		}
		else
		{	
			s datatype=^||TMPBDP("DataType",TableName,$j)
		}
		//s datatype=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDataType(TableName)
		/// flag=0 时， 有私有数据取私有数据，没有则取共有数据。flag=1时，不取公共数据id，只取私有数据数据id
		if datatype="S" s flag=1    //私有
		else  if datatype="C" s flag=1   //管控   原来是0 先按照私有来取 2020-01-06
		else  if datatype="G" s flag=2  //公有
		else  if datatype="A" s flag=1  //绝对私有
	}
	else
	{
		//不开启医院级授权
		s flag=2
		/// flag=2 无论公有还是私有，只要存在取第一个
	}
	q:Code="" ""
	s Value=Code
	if (TableName="PH_Manufacturer") //厂商
	{
		s DataType=$p(Code,"^",2)
		s Value=$p(Code,"^",1)
		q:$$ALPHAUP^SSUTIL4(Value)="" ""
		s id=0
		for
		{
			s id=$o(^PHMNF(0,"Code",$$ALPHAUP^SSUTIL4(Value),id)) Q:id=""
			s PHMNFCode=$p($g(^PHMNF(id)),"^",1)
			continue:(PHMNFCode'=Value)
			s MANFRowid=$o(^DHCMANF(0,"MANF",id,0))  //2020-01-04校验类型
			if MANFRowid'=""
			{
				s MANFType=$p($g(^DHCMANF(MANFRowid)),"^",7)
				if DataType'="" continue:MANFType'=DataType
				if ((flag=2)||(flag=0)||(HOSPID=""))
				{
					s hosplinkid=id
					q
				}
				else
				{
					if $d(^User.BDPMappingHospI("DataRef",TableName,HOSPID,id))>0
					{
						s hosplinkid=id
						q
					}
				}
			}
			else
			{
				/// 没有类型的数据算重复
				s hosplinkid=id
				q
			}
		}
	}
	if (TableName="APC_Vendor") //供应商
	{
		s DataType=$p(Value,"^",2)
		s Value=$p(Value,"^",1)
		q:$$ALPHAUP^SSUTIL4(Value)="" ""
		s id=0
		for
		{
			s id=$o(^APC("APCVM",0,"APCVM_Code",$$ALPHAUP^SSUTIL4(Value),id)) Q:id=""
			s APCVMCode=$p($g(^APC("APCVM",id)),"^",2)  //供应商代码
			if (APCVMCode'=Value) continue
			s APCVMType=$p($g(^APC("APCVM",id)),"^",9)
			if DataType'="" continue:APCVMType'=DataType
			if ((flag=2)||(flag=0)||(HOSPID=""))
			{
				s hosplinkid=id
				q
			}
			else
			{
				if $d(^User.BDPMappingHospI("DataRef",TableName,HOSPID,id))>0
				{
					s hosplinkid=id
					q
				}
			}
		}
	}
	
	if (TableName="DHC_STOrigin") //产地  管控
	{
		s DataType=$p(Value,"^",2)
		s Value=$p(Value,"^",1)
		s id=0
		for
		{
			s id=$o(^DHCSTORI(id)) q:id=""
			s ORICode=$p($g(^DHCSTORI(id)),"^",1)
			continue:(ORICode'=Value)
			s OrigType=$p($g(^DHCSTORI(id)),"^",3)  //2021-01-04 校验类型
			if DataType'="" continue:OrigType'=DataType
			if ((flag=2)||(flag=0)||(HOSPID=""))
			{
				s hosplinkid=id
				q
			}
			else
			{
				if $d(^User.BDPMappingHospI("DataRef",TableName,HOSPID,id))>0
				{
					s hosplinkid=id
					q
				}
			}
		}
	}
	if (TableName="DHC_Carrier") // 配送商  私有
	{
		s DataType=$p(Value,"^",2)
		s Value=$p(Value,"^",1)
		q:$$ALPHAUP^SSUTIL4(Value)="" ""
		s id=0
		for
		{
			s id=$o(^DHCCARR(0,"Code",$$ALPHAUP^SSUTIL4(Value),id)) Q:id=""
			s CACode=$p($g(^DHCCARR(id)),"^",1)
			continue:(CACode'=Value)
			s CAType=$p($g(^DHCCARR(id)),"^",3)
			if DataType'="" continue:CAType'=DataType
			if ((flag=2)||(flag=0)||(HOSPID=""))
			{
				s hosplinkid=id
				q
			}
			else
			{
				if $d(^User.BDPMappingHospI("DataRef",TableName,HOSPID,id))>0
				{
					s hosplinkid=id
					q
				}
			}
		}
	}
	
	if (TableName="DHCExaBorough") // 分诊区   绝对私有
	{
		s id=0
		for
		{
			s id=$o(^User.DHCExaBoroughD(id)) q:id=""
			s ExabCode=$lg($g(^User.DHCExaBoroughD(id)),2)
			if (ExabCode=Value)
			{
				if (flag=2)||(flag=0) s hosplinkid=id
				if (flag=2) q
				s ExabHospitalDr=$LISTGET($g(^User.DHCExaBoroughD(id)),13)
				if (ExabHospitalDr=HOSPID) //2020-04-07 判断分诊区的医院
				{
					s hosplinkid=id
					q
				}
			}
		}
		
	}
	
	if (TableName="RBC_EquipmentGroup") //资源组
	{
		q:$$ALPHAUP^SSUTIL4(Value)="" ""
		if (flag=2)||(flag=0) s hosplinkid=$o(^RBC("GRP",0,"Code",$$ALPHAUP^SSUTIL4(Value),0))
		if HOSPID="" q hosplinkid
		if (flag=2) q hosplinkid
		s id=0
		for
		{
			s id=$o(^RBC("GRP",0,"Code",$$ALPHAUP^SSUTIL4(Value),id)) Q:id=""
			if $d(^User.BDPMappingHospI("DataRef",TableName,HOSPID,id))>0
			{
				s hosplinkid=id
				q
			}
		}
	}
	if (TableName="RBC_ServiceGroup")  //服务组
	{
		q:$$ALPHAUP^SSUTIL4(Value)="" ""
		if (flag=2)||(flag=0) s hosplinkid=$o(^RBC("SG",0,"Code",$$ALPHAUP^SSUTIL4(Value),0))
		if HOSPID="" q hosplinkid
		if (flag=2) q hosplinkid
		s id=0
		for
		{
			s id=$o(^RBC("SG",0,"Code",$$ALPHAUP^SSUTIL4(Value),id)) Q:id=""
			if $d(^User.BDPMappingHospI("DataRef",TableName,HOSPID,id))>0
			{
				s hosplinkid=id
				q
			}
		}
	}
	if (TableName="BDP_ItemCategory") //收费项目科目类别
	{
		q:$$ALPHAUP^SSUTIL4(Value)="" ""
		if (flag=2)||(flag=0) s hosplinkid=$o(^User.BDPItemCategoryI("UniqueCodeIndex"," "_$zcvt(Value,"U"),0))
		if HOSPID="" q hosplinkid
		if (flag=2) q hosplinkid
		s id=0
		for
		{
			s id=$o(^User.BDPItemCategoryI("UniqueCodeIndex"," "_$zcvt(Value,"U"),id)) Q:id=""
			if $d(^User.BDPMappingHospI("DataRef",TableName,HOSPID,id))>0
			{
				s hosplinkid=id
				q
			}
		}
	}
	if (TableName="ARC_ItemCat") //医嘱子类
	{
		q:$$ALPHAUP^SSUTIL4(Value)="" ""
		if (flag=2)||(flag=0) s hosplinkid=$o(^ARC("IC",0,"Code",$$ALPHAUP^SSUTIL4(Value),0))
		if HOSPID="" q hosplinkid
		if (flag=2) q hosplinkid
		s id=0
		for
		{
			s id=$o(^ARC("IC",0,"Code",$$ALPHAUP^SSUTIL4(Value),id)) Q:id=""
			if $d(^User.BDPMappingHospI("DataRef",TableName,HOSPID,id))>0
			{
				s hosplinkid=id
				q
			}
		}
	}
	if (TableName="OEC_OrderCategory") //医嘱大类
	{
		q:$$ALPHAUP^SSUTIL4(Value)="" ""
		if (flag=2)||(flag=0) s hosplinkid=$o(^OEC("ORCAT",0,"Code",$$ALPHAUP^SSUTIL4(Value),0))
		if HOSPID="" q hosplinkid
		if (flag=2) q hosplinkid
		s id=0
		for
		{
			s id=$o(^OEC("ORCAT",0,"Code",$$ALPHAUP^SSUTIL4(Value),id)) Q:id=""
			if $d(^User.BDPMappingHospI("DataRef",TableName,HOSPID,id))>0
			{
				s hosplinkid=id
				q
			}
		}
	}
	if (TableName="PAC_AdmReason")  //患者费别
	{
		q:$$ALPHAUP^SSUTIL4(Value)="" ""
		if (flag=2)||(flag=0) s hosplinkid=$o(^PAC("ADMREA",0,"Code",$$ALPHAUP^SSUTIL4(Value),0))
		
		if HOSPID="" q hosplinkid
		if (flag=2) q hosplinkid
		s id=0
		for
		{
			s id=$o(^PAC("ADMREA",0,"Code",$$ALPHAUP^SSUTIL4(Value),id)) Q:id=""
			if $d(^User.BDPMappingHospI("DataRef",TableName,HOSPID,id))>0
			{
				s hosplinkid=id
				q
			}	
		}
	}
	if (TableName="CT_SocialStatus")  //患者类别
	{
		q:$$ALPHAUP^SSUTIL4(Value)="" ""
		if (flag=2)||(flag=0) s hosplinkid=$o(^CT("SS",0,"Code",$$ALPHAUP^SSUTIL4(Value),0))
		
		if HOSPID="" q hosplinkid
		if (flag=2) q hosplinkid
		s id=0
		for
		{
			s id=$o(^CT("SS",0,"Code",$$ALPHAUP^SSUTIL4(Value),id)) Q:id=""
			if $d(^User.BDPMappingHospI("DataRef",TableName,HOSPID,id))>0
			{
				s hosplinkid=id
				q
			}	
		}
	}
	if (TableName="INC_StkCat") //库存分类
	{
		s DataType=$p(Value,"^",2)
		s Value=$p(Value,"^",1)
		q:$$ALPHAUP^SSUTIL4(Value)="" ""
		s id=0
		for
		{
			s id=$o(^INC("SC",0,"Code",$$ALPHAUP^SSUTIL4(Value),id)) Q:id=""
			s stkType = $p($g(^INC("SC", id)), "^", 3)
			continue:(DataType'="")&&(DataType '= stkType)
			if ((flag=2)||(flag=0)||(HOSPID=""))
			{
				s hosplinkid=id
				q
			}
			else
			{
				if $d(^User.BDPMappingHospI("DataRef",TableName,HOSPID,id))>0
				{
					s hosplinkid=id
					q
				}
			}
		}
	}
	
	if (TableName="DHC_StkCatGroup")  ///库存类组
	{
		s DataType=$p(Value,"^",2)
		s Value=$p(Value,"^",1)
		q:$$ALPHAUP^SSUTIL4(Value)="" ""
		s id=0
		for
		{
			s id=$o(^DHCSCG(id)) Q:(id="")||(id="STKCAT")
			s scgcode=$p($g(^DHCSCG(id)),"^",1)
			s scgtype=$p($g(^DHCSCG(id)),"^",3)
			continue:(DataType'="")&&(scgtype'=DataType)
			if scgcode=Value
			{
				if ((flag=2)||(flag=0)||(HOSPID=""))
				{
					s hosplinkid=id
					q
				}
				else
				{
					if $d(^User.BDPMappingHospI("DataRef",TableName,HOSPID,id))>0
					{
						s hosplinkid=id
						q
					}
				}
			}
		}
	}
	if (TableName="PHC_DrgMast")
	{
		q:$$ALPHAUP^SSUTIL4(Value)="" ""
		if (flag=2)||(flag=0) s hosplinkid=$o(^PHCD(0,"Code",$$ALPHAUP^SSUTIL4(Value),0))
		if HOSPID="" q hosplinkid
		if (flag=2) q hosplinkid
		s id=0
		for
		{
			s id=$o(^PHCD(0,"Code",$$ALPHAUP^SSUTIL4(Value),id)) Q:id=""
			if $p($g(^PHCD(id,1)),"^",1)=Value
			{
				if $d(^User.BDPMappingHospI("DataRef",TableName,HOSPID,id))>0
				{
					s hosplinkid=id
					q
				}
			}
		}
	}
	if (TableName="ARC_ItmMast")
	{
		q:$$ALPHAUP^SSUTIL4(Value)="" ""
		s AuHospFlag=0 
		s subscripts=0
		for
		{
			s subscripts=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(Value),subscripts)) Q:(subscripts="")||(AuHospFlag=1)
			s sub=0
			for
			{
				s sub=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(Value),subscripts,sub)) Q:(sub="")||(AuHospFlag=1)
				if $p($g(^ARCIM(subscripts,sub,1)),"^",1)=Value
				{
					s realid=subscripts_"||"_sub
					if (flag=2)||(flag=0) s hosplinkid=realid
					if (flag=2) q
					if HOSPID="" q
					s HospChildsub=0
					for
					{
						s HospChildsub=$o(^ARCIM(subscripts,sub,"HOSP",HospChildsub)) q:(HospChildsub="")||(AuHospFlag=1)  
						s HOSPHospitalDR=$p($g(^ARCIM(subscripts,sub,"HOSP",HospChildsub)),"^",1)  
						if (HOSPHospitalDR=HOSPID)
						{
							s AuHospFlag=1
							s hosplinkid=realid
							q
						}
					}
				}
			}
		}
	}
	
	if (TableName="DHC_TarItem")
	{
		q:Value=""
		if (flag=2)||(flag=0)
		{
			s id=0
			for
			{
				s id=$o(^DHCTARI(0,"Code",Value,id)) Q:id=""
				if $p($g(^DHCTARI(id)),"^",1)=Value
				{
					s hosplinkid=id
					q
				}
			}  
		}
		if HOSPID="" q hosplinkid
		if (flag=2) q hosplinkid
		s id=0
		for
		{
			s id=$o(^DHCTARI(0,"Code",Value,id)) Q:id=""
			if $p($g(^DHCTARI(id)),"^",1)=Value
			{
				if $d(^User.BDPMappingHospI("DataRef",TableName,HOSPID,id))>0
				{
					s hosplinkid=id
					q
				}
			}
		}
		
	}
	if (TableName="INC_Itm")
	{
		q:$$ALPHAUP^SSUTIL4(Value)="" ""
		if (flag=2)||(flag=0)
		{
			s id=0
			for
			{
				s id=$o(^INCI(0,"Code",$$ALPHAUP^SSUTIL4(Value),id)) Q:id=""
				if $p($g(^INCI(id,1)),"^",1)=Value
				{
					s hosplinkid=id
					q
				}
			}  
		}
		
		if HOSPID="" q hosplinkid
		if (flag=2) q hosplinkid
		s id=0
		for
		{
			s id=$o(^INCI(0,"Code",$$ALPHAUP^SSUTIL4(Value),id)) Q:id=""
			if $p($g(^INCI(id,1)),"^",1)=Value
			{
				//库存项表DHC_ItmAddHosp
				if $d(^ITMADDHOP(0,"HospInc",HOSPID,id))>0
				{
					s hosplinkid=id
					q
				}
			}
		}
		
	}
	if (TableName="ARC_BillGrp") //账单组
	{
		q:$$ALPHAUP^SSUTIL4(Value)="" ""
		if (flag=2)||(flag=0) s hosplinkid=$o(^ARCBG(0,"Code",$$ALPHAUP^SSUTIL4(Value),0))
		if HOSPID="" q hosplinkid
		if (flag=2) q hosplinkid
		s id=0
		for
		{
			s id=$o(^ARCBG(0,"Code",$$ALPHAUP^SSUTIL4(Value),id)) Q:id=""
			if $d(^User.BDPMappingHospI("DataRef",TableName,HOSPID,id))>0
			{
				s hosplinkid=id
				q
			}	
		}
	}
	if (TableName="ARC_BillSub") //账单子组
	{
		q:$$ALPHAUP^SSUTIL4(Value)="" ""
		if HOSPID="" q hosplinkid
		s id=0
		for
		{
			s id=$o(^ARCBG("SG_Code",$$ALPHAUP^SSUTIL4(Value),id)) Q:id=""
			s sub=0
			for
			{
				s sub=$o(^ARCBG("SG_Code",$$ALPHAUP^SSUTIL4(Value),id,sub)) Q:sub=""
				s realid=id_"||"_sub
				if (flag=2)
				{
					s hosplinkid=realid
					q
				}
				if HOSPID="" q
				if $d(^User.BDPMappingHospI("DataRef",TableName,HOSPID,realid))>0
				{
					s hosplinkid=realid
					q
				}
			}	
		}
	}
	if (TableName="SS_User")
	{
		q:$$ALPHAUP^SSUTIL4(Value)="" ""
		s hosplinkid=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(Value),0))
		
	}
	if (TableName="CT_CareProv")
	{
		q:$$ALPHAUP^SSUTIL4(Value)="" ""
		s hosplinkid=$o(^CTPCP(0,"Code",$$ALPHAUP^SSUTIL4(Value),0))
	}
	if (TableName="CT_Loc")
	{
		q:$$ALPHAUP^SSUTIL4(Value)="" ""
		if (flag=2)||(flag=0) s hosplinkid=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(Value),0))
		if HOSPID="" q hosplinkid
		if (flag=2) q hosplinkid
		s id=0
		for
		{
			s id=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(Value),id)) Q:id=""
			S hospitalid=$p($g(^CTLOC(id)),"^",22)
			if HOSPID=hospitalid
			{
				s hosplinkid=id
				q	
			}
		}
	}
	
	if (TableName="PAC_Ward")  //病区
	{
		q:$$ALPHAUP^SSUTIL4(Value)="" ""
		if (flag=2)||(flag=0) s hosplinkid=$o(^PAWARD(0,"WARD_Code",$$ALPHAUP^SSUTIL4(Value),0))
		if HOSPID="" q hosplinkid
		if (flag=2) q hosplinkid
		s id=0
		for
		{
			s id=$o(^PAWARD(0,"WARD_Code",$$ALPHAUP^SSUTIL4(Value),id)) Q:id=""
			s WARDLocationDR=$p($g(^PAWARD(id)),"^",5)  //病区里的科室指针
			if WARDLocationDR'=""
			{
				S hospitalid=$p($g(^CTLOC(WARDLocationDR)),"^",22)
				if HOSPID=hospitalid
				{
					s hosplinkid=id
					q	
				}
			}
		}
	}
	//2019-07-01
	if (TableName="CT_UOM")
	{
		q:Code="" ""
		if (flag=2)||(flag=0) s hosplinkid=$o(^CT("UOM",0,"Code",$$UPPER^SSUTIL4(Code),0))
		if HOSPID="" q hosplinkid
		if (flag=2) q hosplinkid
		s id=0
		for
		{
			s id=$o(^CT("UOM",0,"Code",$$UPPER^SSUTIL4(Code),id)) Q:id=""
			if $d(^User.BDPMappingHospI("DataRef",TableName,HOSPID,id))>0
			{
				s hosplinkid=id
				q
			}
		}
	}
	
	
	if (TableName="DHC_TarMCNew")
	{
		q:Code="" ""
		if (flag=2)||(flag=0) s hosplinkid=$o(^DHCTARMCNEW(0,"Code",Code,0))
		if HOSPID="" q hosplinkid
		if (flag=2) q hosplinkid
		s id=0
		for
		{
			s id=$o(^DHCTARMCNEW(0,"Code",Code,id)) Q:id=""
			if $d(^User.BDPMappingHospI("DataRef",TableName,HOSPID,id))>0
			{
				s hosplinkid=id
				q
			}
		}
	}
	
	if (TableName="DHC_TarMCCateNew")
	{
		q:Code="" ""
		if (flag=2)||(flag=0) s hosplinkid=$o(^DHCTARMRCATENEW(0,"Code",Code,0))
		if HOSPID="" q hosplinkid
		if (flag=2) q hosplinkid
		s id=0
		for
		{
			s id=$o(^DHCTARMRCATENEW(0,"Code",Code,id)) Q:id=""
			if $d(^User.BDPMappingHospI("DataRef",TableName,HOSPID,id))>0
			{
				s hosplinkid=id
				q
			}
		}
	}
	if (TableName="DHC_TarAC")
	{
		q:Code="" ""
		if (flag=2)||(flag=0) s hosplinkid=$o(^DHCTarC("TAC",0,"Code",Code,0))
		if HOSPID="" q hosplinkid
		if (flag=2) q hosplinkid
		s id=0
		for
		{
			s id=$o(^DHCTarC("TAC",0,"Code",Code,id)) Q:id=""
			if $d(^User.BDPMappingHospI("DataRef",TableName,HOSPID,id))>0
			{
				s hosplinkid=id
				q
			}
		}
	}
	if (TableName="DHC_TarAcctCate")
	{
		q:Code="" ""
		if (flag=2)||(flag=0) s hosplinkid=$o(^DHCTarC("AC",0,"Code",Code,0))
		if HOSPID="" q hosplinkid
		if (flag=2) q hosplinkid
		s id=0
		for
		{
			s id=$o(^DHCTarC("AC",0,"Code",Code,id)) Q:id=""
			if $d(^User.BDPMappingHospI("DataRef",TableName,HOSPID,id))>0
			{
				s hosplinkid=id
				q
			}
		}
	}
	
	if (TableName="DHC_TarCate")
	{
		q:Code="" ""
		if (flag=2)||(flag=0) s hosplinkid=$o(^DHCTarC("CC",0,"Code",Code,0))
		if HOSPID="" q hosplinkid
		if (flag=2) q hosplinkid
		s id=0
		for
		{
			s id=$o(^DHCTarC("CC",0,"Code",Code,id)) Q:id=""
			if $d(^User.BDPMappingHospI("DataRef",TableName,HOSPID,id))>0
			{
				s hosplinkid=id
				q
			}
		}
	}
	
	if (TableName="DHC_TarEC")
	{
		q:Code="" ""
		if (flag=2)||(flag=0) s hosplinkid=$o(^DHCTarC("TEC",0,"Code",Code,0))
		if HOSPID="" q hosplinkid
		if (flag=2) q hosplinkid
		s id=0
		for
		{
			s id=$o(^DHCTarC("TEC",0,"Code",Code,id)) Q:id=""
			if $d(^User.BDPMappingHospI("DataRef",TableName,HOSPID,id))>0
			{
				s hosplinkid=id
				q
			}
		}
	}
	if (TableName="DHC_TarEMCCate")
	{
		q:Code="" ""
		if (flag=2)||(flag=0) s hosplinkid=$o(^DHCTarC("EC",0,"Code",Code,0))
		if HOSPID="" q hosplinkid
		if (flag=2) q hosplinkid
		s id=0
		for
		{
			s id=$o(^DHCTarC("EC",0,"Code",Code,id)) Q:id=""
			if $d(^User.BDPMappingHospI("DataRef",TableName,HOSPID,id))>0
			{
				s hosplinkid=id
				q
			}
		}
	}
	if (TableName="DHC_TarIC")
	{
		q:Code="" ""
		if (flag=2)||(flag=0) s hosplinkid=$o(^DHCTarC("TIC",0,"Code",Code,0))
		if HOSPID="" q hosplinkid
		if (flag=2) q hosplinkid
		s id=0
		for
		{
			s id=$o(^DHCTarC("TIC",0,"Code",Code,id)) Q:id=""
			if $d(^User.BDPMappingHospI("DataRef",TableName,HOSPID,id))>0
			{
				s hosplinkid=id
				q
			}
		}
	}
	if (TableName="DHC_TarInpatCate")
	{
		q:Code="" ""
		if (flag=2)||(flag=0) s hosplinkid=$o(^DHCTarC("IC",0,"Code",Code,0))
		if HOSPID="" q hosplinkid
		if (flag=2) q hosplinkid
		s id=0
		for
		{
			s id=$o(^DHCTarC("IC",0,"Code",Code,id)) Q:id=""
			if $d(^User.BDPMappingHospI("DataRef",TableName,HOSPID,id))>0
			{
				s hosplinkid=id
				q
			}
		}
	}
	if (TableName="DHC_TarMC")
	{
		q:Code="" ""
		if (flag=2)||(flag=0) s hosplinkid=$o(^DHCTarC("TMC",0,"Code",Code,0))
		if HOSPID="" q hosplinkid
		if (flag=2) q hosplinkid
		s id=0
		for
		{
			s id=$o(^DHCTarC("TMC",0,"Code",Code,id)) Q:id=""
			if $d(^User.BDPMappingHospI("DataRef",TableName,HOSPID,id))>0
			{
				s hosplinkid=id
				q
			}
		}
	}
	if (TableName="DHC_TarMRCate")
	{
		q:Code="" ""
		if (flag=2)||(flag=0) s hosplinkid=$o(^DHCTarC("MC",0,"Code",Code,0))
		if HOSPID="" q hosplinkid
		if (flag=2) q hosplinkid
		s id=0
		for
		{
			s id=$o(^DHCTarC("MC",0,"Code",Code,id)) Q:id=""
			if $d(^User.BDPMappingHospI("DataRef",TableName,HOSPID,id))>0
			{
				s hosplinkid=id
				q
			}
		}
	}
	
	if (TableName="DHC_TarOC")
	{
		q:Code="" ""
		if (flag=2)||(flag=0) s hosplinkid=$o(^DHCTarC("TOC",0,"Code",Code,0))
		if HOSPID="" q hosplinkid
		if (flag=2) q hosplinkid
		s id=0
		for
		{
			s id=$o(^DHCTarC("TOC",0,"Code",Code,id)) Q:id=""
			if $d(^User.BDPMappingHospI("DataRef",TableName,HOSPID,id))>0
			{
				s hosplinkid=id
				q
			}
		}
	}
	
	if (TableName="DHC_TarOutpatCate")
	{
		q:Code="" ""
		if (flag=2)||(flag=0) s hosplinkid=$o(^DHCTarC("OC",0,"Code",Code,0))
		if HOSPID="" q hosplinkid
		if (flag=2) q hosplinkid
		s id=0
		for
		{
			s id=$o(^DHCTarC("OC",0,"Code",Code,id)) Q:id=""
			if $d(^User.BDPMappingHospI("DataRef",TableName,HOSPID,id))>0
			{
				s hosplinkid=id
				q
			}
		}
	}
	if (TableName="DHC_TarSubCate")
	{
		q:Code="" ""
		if (flag=2)||(flag=0) s hosplinkid=$o(^DHCTarC("SC",0,"Code",Code,0))
		if HOSPID="" q hosplinkid
		if (flag=2) q hosplinkid
		s id=0
		for
		{
			s id=$o(^DHCTarC("SC",0,"Code",Code,id)) Q:id=""
			if $d(^User.BDPMappingHospI("DataRef",TableName,HOSPID,id))>0
			{
				s hosplinkid=id
				q
			}
		}
	}
	if (TableName="PAC_BedType")
	{
		q:$$ALPHAUP^SSUTIL4(Value)="" ""
		if (flag=2)||(flag=0) s hosplinkid=$o(^PAC("BEDTP",0,"BEDTP_Code",$$ALPHAUP^SSUTIL4(Value),0))
		if HOSPID="" q hosplinkid
		if (flag=2) q hosplinkid
		s id=0
		for
		{
			s id=$o(^PAC("BEDTP",0,"BEDTP_Code",$$ALPHAUP^SSUTIL4(Value),id)) Q:id=""
			if $d(^User.BDPMappingHospI("DataRef",TableName,HOSPID,id))>0
			{
				s hosplinkid=id
				q
			}
		}
	}
	if (TableName="PAC_RoomType")
	{
		q:$$ALPHAUP^SSUTIL4(Value)="" ""
		if (flag=2)||(flag=0) s hosplinkid=$o(^PAC("ROOMT",0,"Code",$$ALPHAUP^SSUTIL4(Value),0))
		if HOSPID="" q hosplinkid
		if (flag=2) q hosplinkid
		s id=0
		for
		{
			s id=$o(^PAC("ROOMT",0,"Code",$$ALPHAUP^SSUTIL4(Value),id)) Q:id=""
			if $d(^User.BDPMappingHospI("DataRef",TableName,HOSPID,id))>0
			{
				s hosplinkid=id
				q
			}
		}
	}
	if (TableName="PAC_Room")
	{
		q:$$ALPHAUP^SSUTIL4(Value)="" ""
		if (flag=2)||(flag=0) s hosplinkid=$o(^PAROOM(0,"ROOM_Code",$$ALPHAUP^SSUTIL4(Value),0))
		if HOSPID="" q hosplinkid
		if (flag=2) q hosplinkid
		s id=0
		for
		{
			s id=$o(^PAROOM(0,"ROOM_Code",$$ALPHAUP^SSUTIL4(Value),id)) Q:id=""
			if $d(^User.BDPMappingHospI("DataRef",TableName,HOSPID,id))>0
			{
				s hosplinkid=id
				q
			}
		}
	}
	if (TableName="RBC_DepartmentGroup") //科室部门组
	{
		q:$$ALPHAUP^SSUTIL4(Value)="" ""
		if (flag=2)||(flag=0) s hosplinkid=$o(^RBC("DEP",0,"Code",$$ALPHAUP^SSUTIL4(Value),0))
		if HOSPID="" q hosplinkid
		if (flag=2) q hosplinkid
		s id=0
		for
		{
			s id=$o(^RBC("DEP",0,"Code",$$ALPHAUP^SSUTIL4(Value),id)) Q:id=""
			if $d(^User.BDPMappingHospI("DataRef",TableName,HOSPID,id))>0
			{
				s hosplinkid=id
				q
			}
		}
	}
	if (TableName="ARC_OrdSets") //医嘱套
	{
		q:$$ALPHAUP^SSUTIL4(Value)="" ""
		if (flag=2)||(flag=0) s hosplinkid=$o(^ARCOS(0,"Code",$$ALPHAUP^SSUTIL4(Value),0))
		if HOSPID="" q hosplinkid
		if (flag=2) q hosplinkid
		s id=0
		for
		{
			s id=$o(^ARCOS(0,"Code",$$ALPHAUP^SSUTIL4(Value),id)) Q:id=""
			
			//User.DHCUserFavItems
			s FavRowId=$o(^DHCFavItems(0,"ItemRowid",id,0))
			if FavRowId'=""
			{
				s FavUseHospDr=$p($g(^DHCFavItems(FavRowId)),"^",11)
				if (FavUseHospDr'="")&&(FavUseHospDr=HOSPID)
				{
					s hosplinkid=id
					q
				}
			}
			
		}
	}
	q hosplinkid
}

/// ^TMPIMPORTERROR  ^TMPIMPORTDATA   ^TMPGOFNOF ^TMPGOFDATA
/// Function:   获取日志数据供查询数据导入的日志
/// CreateDate: 2022-07-09
/// Creator:    chenying
/// Input：     table(导入菜单的代码) start（日志从第几条开始显示） limit（每页显示条数）
Query GetDataLogOfImport2(table As %String) As %Query(ROWSPEC = "ID,IpAddress,TableName,ClassName,ClassNameDesc,ObjectReference,ObjectDesc,UpdateUserDR,UpdateUserName,UpdateDate,UpdateTime,OperateType")
{
}

ClassMethod GetDataLogOfImport2Execute(ByRef qHandle As %Binary, table As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    if (table'="")
    {
        s mySysID =$s($d(%session):%session.%Id(),1:$j)
		S lastLogId=$g(^TMP("BDPDataImport","ImportTime",mySysID,table,"BDPDataChangeLogID"))
		s BDPEIMenuRowId=$o(^User.BDPEIMenuI("UniqueCodeIndex"," "_$zcvt(table,"u"),0))
		s ClassNames=$LISTGET($G(^User.BDPEIMenuD(BDPEIMenuRowId)),8)
		s length=$l(ClassNames,",")
		K ^TMP("BDPDataImport","LOGIMPORT")
		K ^TMP("BDPDataImport","TMPLOG")
		for i=1:1:length
		{
			s classname=$p(ClassNames,",",i)
			continue:classname=""
			s ^TMP("BDPDataImport","LOGIMPORT",classname)=""
		}
		
		s strResult=""
		///获取导入的时间标记
		s datefrom=$p($g(^TMP("BDPDataImport","ImportTime",mySysID,table)),",",1)
		s timefrom=$p($g(^TMP("BDPDataImport","ImportTime",mySysID,table)),",",2)
		
		IF (datefrom'="")&&(timefrom'="")
		{
			///2017-2-11修改，日志正序排列
			s ID=""
			for
			{
				s ID=$o(^User.BDPDataChangeLogD(ID),-1) q:(ID="")
				q:(lastLogId'="")&(ID<=lastLogId)
				s TableName=$LISTGET($G(^User.BDPDataChangeLogD(ID)),2)   //CT_City
				s ClassName=$LISTGET($G(^User.BDPDataChangeLogD(ID)),3)   //User.CTCity
				if (ClassName["^") s ClassName= $p(ClassName,"(",1)
				s UpdateDate=$LISTGET($G(^User.BDPDataChangeLogD(ID)),7)
				s UpdateTime=$LISTGET($G(^User.BDPDataChangeLogD(ID)),8)
				continue:('((UpdateDate>=datefrom)&&(UpdateTime>=timefrom)))
				if ($d(^TMP("BDPDataImport","LOGIMPORT",ClassName))=1)
				{
					 s ^TMP("BDPDataImport","TMPLOG",ID)=""
				}
			}
		}
		s Result=""
		s ID=""
		for
		{
			s ID=$o(^TMP("BDPDataImport","TMPLOG",ID)) q:ID=""  
			s TableName=$LISTGET($G(^User.BDPDataChangeLogD(ID)),2)   //CT_City
			s ClassName=$LISTGET($G(^User.BDPDataChangeLogD(ID)),3)   //User.CTCity
			
			if (ClassName["^") s ClassName= $p(ClassName,"(",1)
			s UpdateDate=$LISTGET($G(^User.BDPDataChangeLogD(ID)),7)
			s UpdateTime=$LISTGET($G(^User.BDPDataChangeLogD(ID)),8)
			
			s ClassName=$LISTGET($G(^User.BDPDataChangeLogD(ID)),3)
			s ClassNameDesc=$LISTGET($G(^User.BDPDataChangeLogD(ID)),11)   
			s:ClassNameDesc="社区维护" ClassNameDesc="社区"
			s:ClassNameDesc="街道维护" ClassNameDesc="街道"
			s:ClassNameDesc="地址维护" ClassNameDesc="地址"
			s:ClassName="User.BDPTableList" ClassName="User.TableList"  
			s:ClassName="User.BDPTableField" ClassName="User.TableField"
			
			s ClassNameDesc=$LISTGET($G(^User.BDPDataChangeLogD(ID)),11)   //新增类描述
			s ObjectReference=$LISTGET($G(^User.BDPDataChangeLogD(ID)),4)
			s ObjectDesc=$LISTGET($G(^User.BDPDataChangeLogD(ID)),12)   //新增对象描述
			s UpdateUserDR=$LISTGET($G(^User.BDPDataChangeLogD(ID)),5)
			s:UpdateUserDR'="" UpdateUserDR=$p($G(^SSU("SSUSR",UpdateUserDR)),"^",1) //获取用户名
			s UpdateUserName=$LISTGET($G(^User.BDPDataChangeLogD(ID)),6)

			s OperateType=$LISTGET($G(^User.BDPDataChangeLogD(ID)),9)
			s IpAddress=$LISTGET($G(^User.BDPDataChangeLogD(ID)),13)
			s NewValue=$LISTGET($G(^User.BDPDataChangeLogD(ID)),10)
			s OldValue=$LISTGET($G(^User.BDPDataChangeLogD(ID)),14)
			
			s ClassName=##class(web.DHCBL.BDP.FunLib).EvalJSON(ClassName)
			s TableName=##class(web.DHCBL.BDP.FunLib).EvalJSON(TableName)
			s NewValue=##class(web.DHCBL.BDP.FunLib).EvalJSON(NewValue)
			s OldValue=##class(web.DHCBL.BDP.FunLib).EvalJSON(OldValue)
			s ClassNameDesc=##class(web.DHCBL.BDP.FunLib).EvalJSON(ClassNameDesc)
			s ObjectReference=##class(web.DHCBL.BDP.FunLib).EvalJSON(ObjectReference)
			s ObjectDesc=##class(web.DHCBL.BDP.FunLib).EvalJSON(ObjectDesc)
			s UpdateUserDR=##class(web.DHCBL.BDP.FunLib).EvalJSON(UpdateUserDR)
			s UpdateUserName=##class(web.DHCBL.BDP.FunLib).EvalJSON(UpdateUserName)
			s UpdateDate=##class(web.DHCBL.BDP.FunLib).EvalJSON(UpdateDate)
			s UpdateTime=##class(web.DHCBL.BDP.FunLib).EvalJSON(UpdateTime)
			s:UpdateDate'="" UpdateDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(UpdateDate)
			s:UpdateTime'="" UpdateTime=##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(UpdateTime,1)
			d LogOutputRow
		}
    }
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
LogOutputRow
    set Data=$lb(ID,IpAddress,TableName,ClassName,ClassNameDesc,ObjectReference,ObjectDesc,UpdateUserDR,UpdateUserName,UpdateDate,UpdateTime,OperateType)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataLogOfImport2Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataLogOfImport2Execute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetDataLogOfImport2Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataLogOfImport2Execute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    
    Set ind=$o(^CacheTemp(repid,ind))
    If ind=""
    {
        //if there are no more rows,finish fetching...
        Set AtEnd=1
        Set Row=""
    }
    Else
    {
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

/// Function: 获取收费项价格
/// CreateDate:2018-11-14
/// Creator: chenying
/// Input:tarirowide(收费项rowid),HOSPtalID（角色医院）
/// Retrun:收费项价格
/// w ##class(web.DHCBL.BDP.BDPDataImport).GetTariPrice("22",2,+$h)
ClassMethod GetTariPrice(tarirowid As %String, hospid As %String = "", date As %String = "") As %String
{
	n (tarirowid,hospid,date,%session)
	s $zt="ERROR"
	q:tarirowid="" ""
	s:date="" date=+$h
	if hospid="" s hospid=$g(%session.Data("LOGON.HOSPID"))
	if $d(^DHCINCTARi("TAR",tarirowid))>0  //药品需要传医嘱项才能取到价格 20230404update
	{
		s INCIOriginalARCIMDR="",INCIRowId=""
		s INCTRRowId=$o(^DHCINCTARi("TAR",tarirowid,0))
		s:INCTRRowId'="" INCIRowId=$P($G(^DHCINCTAR(INCTRRowId)),"^",1)
		s:INCIRowId'="" INCIOriginalARCIMDR=$P($G(^INCI(INCIRowId,1)),"^",3)
		s ExpString="^^^^^"_INCIOriginalARCIMDR_"^^^^^"_INCIRowId
		s priceinfo=##class(web.UDHCJFPRICE).GetItmPrice(tarirowid,date,"","","",hospid,ExpString)
	}
	else
	{
		s priceinfo=##class(web.UDHCJFPRICE).GetItmPrice(tarirowid,date,"","","",hospid)
	}
	//s priceinfo=##class(web.UDHCJFPRICE).GetItmPrice(tarirowid,date,"","","")
	s tarprice=$p(priceinfo,"^",1)
	if $e(tarprice,1)="." s tarprice="0"_tarprice
	s tarprice=$tr(tarprice,$c(10),"")
	s tarprice=$tr(tarprice,$c(13),"")
	s tarprice=$tr(tarprice,$c(0),"")	 
	q tarprice
ERROR
	Q "ERROR"
}

}
