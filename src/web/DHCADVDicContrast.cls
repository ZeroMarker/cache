Import SQLUser

/// Descript:	 统计接口元素对照
/// CreaDate：   2020-02-20
Class web.DHCADVDicContrast Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:	 取表单元素
/// Creator:	 sufan
/// CreaDate：   2020-02-20
/// Input:  	 
/// Return: 	 元素信息
/// Others:		 w ##class(web.DHCADVDicContrast).QueryAllFormItem("30","1","",0)
ClassMethod QueryAllFormItem(rows As %String, page As %String, q As %String = "", type = "", HospDr = "")
{
	n (rows,page,q,type,HospDr)
	;s ^temptest("32323")=$lb(rows,page,q,type)
	S End = page*rows
	S Start=(page-1)*rows+1
	S EndPage=page*rows  //结束行
	S StPage=((page-1)*rows)+1     //开始行
	Q:type="" "{""rows"":[],""total"":0}"
	s count=0
	w "{""rows"":["
	i type=0  d
	.s DicId=""
	.for  s DicId=$o(^User.DHCAdvFormDicI("IndexParef"," 0",DicId)) q:DicId=""  d
	..s data=^User.DHCAdvFormDicD(DicId)
	..s DicField=$ListGet(data,2)
	..s Style=$ListGet(data,3)
	..s DicDesc=$ListGet(data,4)
	..s QuitList=DicField_DicDesc
	..Q:(q'="")&&(QuitList'[q)
  	..s cat=$ListGet(data,14)
  	..q:(+cat'=0)&&($ListGet(^User.DHCAdvFormNameD(cat),8)'="Y")
	..s count=count+1
	..q:count<Start
	..q:count>End
	..w $case(count,Start:"",:",")
	..s tmpObj={}
	..s tmpObj.DicField=DicField
	..s tmpObj.DicDesc=DicDesc
	..w tmpObj.%ToJSON()
	e   d
	.s DicId="0"
	.for  s DicId=$o(^DHCADVAFC(DicId)) q:DicId=""  d
	..s DicField=$p(^DHCADVAFC(DicId),"^",1)
	..s DicDesc=$p(^DHCADVAFC(DicId),"^",2)
	..s DicHospDr=$p(^DHCADVAFC(DicId),"^",4)
	..q:(DicHospDr'="")&&(HospDr'="")&&(DicHospDr'=HospDr)
	..s QuitList=DicField_DicDesc
	..Q:(q'="")&&(QuitList'[q)
	..s count=count+1
	..q:count<Start
	..q:count>End
	..w $case(count,Start:"",:",")
	..s tmpObj={}
	..s tmpObj.DicField=DicField
	..s tmpObj.DicDesc=DicDesc
	..w tmpObj.%ToJSON()
	w "],""total"":"_count_"}"
	q ""
}

/// Descript:  查询表单
/// w ##class(web.DHCADVDicContrast).jsonForm("")
ClassMethod jsonForm(HospID As %String = "", q) As %String
{
	n (HospID,q)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT ID, code,name,hospdr FROM DHC_AdvFormName" 
	s sqlStr = sqlStr_" where type='Y' and active='Y' and name like '%"_q_"%'"
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s RowID = result.Data("ID")
		s Code = result.Data("code")
		s Desc = result.Data("name")
		s hospdr = result.Data("hospdr")
		continue:##class(web.DHCADVFormName).CheckFormName(Code,HospID)=0
		s tmp=RowID_"^"_Code_"^"_Desc
		s count = count+1
		I count=1 d
		.W ##class(web.DHCAPPJsonCommon).getJsonData("value^code^text",tmp)
		e  d
		.W ","_##class(web.DHCAPPJsonCommon).getJsonData("value^code^text",tmp)
	}
	w "]"
	Q ""
}

/// Descript:  查询表单对应元素
/// w ##class(web.DHCADVDicContrast).jsonFormDic("1020")
ClassMethod jsonFormDic(FormID As %String, q = "") As %String
{
	n (FormID,q)
	s version=$o(^User.DHCAdvFormI("IndexNameVersion",FormID,""),-1)
	Q:version="" ""
	s count = 0
	w "["
	s ID=""
	F  s ID=$o(^User.DHCAdvFormI("IndexNameVersion",FormID,version,ID)) Q:ID=""  D
	.s itmData=^User.DHCAdvFormD(ID)
	.s FormDicId=$LIST(itmData,4)
	.Q:FormDicId=""
	.Q:'$d(^User.DHCAdvFormDicD(FormDicId))
	.s FormDicData=^User.DHCAdvFormDicD(FormDicId)
	.s itmCode=$LIST(FormDicData,2)     /// 元素代码
	.Q:$LIST(FormDicData,3)="fieldset"  /// 元素类型
	.;Q:$LIST(FormDicData,3)="label"  /// 元素类型
	.Q:($LIST(FormDicData,3)="label")&&('$d(^User.DHCAdvFormDicI("IndexParef"," "_FormDicId)))
	.s itmTitle=$LIST(FormDicData,4)    /// 元素描述
	.s:itmTitle["<span" itmTitle=$p(itmTitle,"<span",1)
	.s:itmTitle["&nbsp" itmTitle=$p(itmTitle,"&nbsp",1)
	.s tmp=FormDicId_"^"_itmTitle_"^"_itmCode
	.s QuitList=itmCode_itmTitle
	.Q:(q'="")&&(QuitList'[q)
	.s count = count+1
	.I count=1 d
	..W ##class(web.DHCAPPJsonCommon).getJsonData("value^text^code",tmp)
	.e  d
	..W ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text^code",tmp)
	w "]"
	Q ""
}

/// Descript:	 保存对照
/// Creator:	 sufan
/// CreaDate：   2020-02-20
/// Input:  	 
/// Return: 	 元素信息
/// Others:		 w ##class(web.DHCADVDicContrast).saveDicContrast("^PatName^advPipeOff^DisMedThingPatName^0")
ClassMethod saveDicContrast(ListData)
{
	n (ListData)
	s Len=$l(ListData,"$$")
	s Err=0
	TS
	for i=1:1:Len  Q:Err'=0  d
	.s TempList=$p(ListData,"$$",i)
	.s Err=..CheckRepeat(TempList)
	.Q:Err'=0
	.s ConId=$p(TempList,"^",1)
	.i ConId=""  d
	..s Err=..InsDicContrast(TempList)
	.e  d
	..s Err=..UpdDicContrast(TempList)
	i Err'=0 tro
	Q:Err'=0 Err
	TC
	Q Err
}

/// Descript:	 保存对照
/// Creator:	 sufan
/// CreaDate：   2020-02-20
/// Input:  	 
/// Return: 	 元素信息
/// Others:		 w ##class(web.DHCADVDicContrast).InsDicContrast("30","1","")
ClassMethod InsDicContrast(ListData)
{
	n (ListData)
	s ConId=$p(ListData,"^",1)				//ID
	s FieldCode=$p(ListData,"^",2)			//统计/接口code
	s FormNameCode=$p(ListData,"^",3)		//表单code
	s FormFieldCode=$p(ListData,"^",4)		//表单元素code
	s ConFlag=$p(ListData,"^",5)			//统计/接口标识
	s ConHospDr=$p(ListData,"^",6)			// 医院id
	&sql(insert into DHC_AdvDicContrast (AD_FromDicCode,AD_ToDicCode,AD_ToFormNameCode,AD_ContrastFlag,AD_HospDr) 
		 values (:FieldCode,:FormFieldCode,:FormNameCode,:ConFlag,:ConHospDr))
	Q SQLCODE
}

/// Descript:	 保存对照
/// Creator:	 sufan
/// CreaDate：   2020-02-20
/// Input:  	 
/// Return: 	 元素信息
/// Others:		 w ##class(web.DHCADVDicContrast).UpdDicContrast("30","1","")
ClassMethod UpdDicContrast(ListData)
{
	n (ListData)
	s ConId=$p(ListData,"^",1)				//ID
	s FieldCode=$p(ListData,"^",2)			//统计/接口code
	s FormNameCode=$p(ListData,"^",3)		//表单code
	s FormFieldCode=$p(ListData,"^",4)		//表单元素code
	s ConFlag=$p(ListData,"^",5)			//统计/接口标识
	s ConHospDr=$p(ListData,"^",6)			// 医院id
	&sql(update DHC_AdvDicContrast set AD_FromDicCode=:FieldCode,AD_ToDicCode=:FormFieldCode,AD_ToFormNameCode=:FormNameCode,AD_ContrastFlag=:ConFlag,AD_HospDr=:ConHospDr where AD_ROWID=:ConId)
	Q SQLCODE
}

/// Descript:	 保存对照
/// Creator:	 sufan
/// CreaDate：   2020-02-20
/// Input:  	 
/// Return: 	 元素信息
/// Others:		 w ##class(web.DHCADVDicContrast).CheckRepeat("^PatName^advPipeOff^DisMedThingPatName^0")
ClassMethod CheckRepeat(ListData)
{
	n (ListData)
	s Err=0
	s ConId=$p(ListData,"^",1)
	s FieldCode=$p(ListData,"^",2)			//统计/接口code
	s FormNameCode=$p(ListData,"^",3)		//表单code
	s FormFieldCode=$p(ListData,"^",4)		//表单元素code
	s ConFlag=$p(ListData,"^",5)			//统计/接口标识
	Q:$d(^DHCADVDC(0,"FromCode",ConFlag,FieldCode,FormNameCode,FormFieldCode)) -1
	Q Err
}

/// Descript:	 删除
ClassMethod DelContrast(ConId)
{
	n (ConId)
	&sql(delete from DHC_AdvDicContrast where AD_RowID=:ConId)
	Q SQLCODE
}

/// Descript:	 查询
/// Creator:	 sufan
/// CreaDate：   2020-02-20
/// Input:  	 
/// Return: 	 元素信息
/// Others:		 w ##class(web.DHCADVDicContrast).QueryDicContrast("30","1","^^983")
ClassMethod QueryDicContrast(rows, page, param, HospDr = "")
{
	n (rows, page, param,HospDr)
	s ^temptest("223")=$lb(rows, page, param)
	S End = page*rows
	S Start=(page-1)*rows+1
	S EndPage=page*rows  //结束行
	S StPage=((page-1)*rows)+1     //开始行
	s DicCode=$p(param,"^",1)
	s DicDesc=$p(param,"^",2)
	s FormNameId=$p(param,"^",3)
	s FormCode=""
	s:FormNameId'="" FormCode=$LG(^User.DHCAdvFormNameD(FormNameId),2)
	s count=0
	w "{""rows"":["
	s ConId="0"
	for  s ConId=$o(^DHCADVDC(ConId)) q:ConId=""  d
	.s ConHsopDr=$p(^DHCADVDC(ConId),"^",5)
	.q:(ConHsopDr'="")&&(HospDr'="")&&(HospDr'=ConHsopDr)
	.s ConFlagCode=$p(^DHCADVDC(ConId),"^",4)
	.s ConFlag=$s(ConFlagCode="0":"统计",ConFlagCode="1":"接口",1:"")
	.s FieldCode=$p(^DHCADVDC(ConId),"^",1)
	.s FieldId="",FieldDesc="",FieldFHospDr=""
	.s:ConFlagCode="0" FieldId=$o(^User.DHCAdvFormDicI("IndexField",$$ALPHAUP^SSUTIL4(FieldCode),""))  ; 接口  取表单元素数据
	.s:(ConFlagCode="0")&&(FieldId'="") FieldDesc=$LG(^User.DHCAdvFormDicD(FieldId),4)
	.I ConFlagCode="1" D
	..s FieldId=$o(^DHCADVAFC(0,"Code",$$ALPHAUP^SSUTIL4(FieldCode),""))    ; 统计  取接口维护列数据
	..s:(FieldId'="") FieldDesc=$p(^DHCADVAFC(FieldId),"^",2)
	..s:(FieldId'="") FieldFHospDr=$p(^DHCADVAFC(FieldId),"^",4)  ;获取统计元素的医院id
	.q:(FieldFHospDr'="")&&(HospDr'="")&&(HospDr'=FieldFHospDr)
	.s FormNameCode=$p(^DHCADVDC(ConId),"^",3)
	.q:##class(web.DHCADVFormName).CheckFormName(FormNameCode,HospDr)'=1  ; 判断表单是否符合当前医院
	.s FormId=$o(^User.DHCAdvFormNameI("IndexCode",$$ALPHAUP^SSUTIL4(FormNameCode),""))
	.s FormNameDesc=""
	.i FormId'="" s FormNameDesc=$LG(^User.DHCAdvFormNameD(FormId),3)
	.s FormFieldCode=$p(^DHCADVDC(ConId),"^",2)
	.s FormFieldId=$o(^User.DHCAdvFormDicI("IndexField",$$ALPHAUP^SSUTIL4(FormFieldCode),""))
	.s FormFieldDesc=""
	.i FormFieldId'="" s FormFieldDesc=$LG(^User.DHCAdvFormDicD(FormFieldId),4)
	.Q:(DicCode'="")&&(FieldCode'[DicCode)
	.Q:(DicDesc'="")&&(FieldDesc'[DicDesc)
	.Q:(FormCode'="")&&(FormNameCode'[FormCode)
	.s count=count+1
	.q:count<Start
	.q:count>End
	.w $case(count,Start:"",:",")
	.s tmpObj={}
	.s tmpObj.ID=ConId
	.s tmpObj.FieldCode=FieldCode
	.s tmpObj.FieldDesc=FieldDesc
	.s tmpObj.FormNameCode=FormNameCode
	.s tmpObj.FormNameDesc=FormNameDesc
	.s tmpObj.FormFieldCode=FormFieldCode
	.s tmpObj.FormFieldDesc=FormFieldDesc
	.s tmpObj.ConFlagCode=ConFlagCode
	.s tmpObj.ConFlag=ConFlag
	.s tmpObj.ConHsopDr=ConHsopDr
	.w tmpObj.%ToJSON()
	w "],""total"":"_count_"}"
	q ""
}

}
