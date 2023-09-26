Import SQLUser

/// Creator: 		bianshuai
/// CreateDate: 	2017-12-12
/// Descript: 		不良事件表单元素对照界面业务类
Class web.DHCADVFormDicContrast Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:	不良事件表单元素对照
/// w ##class(web.DHCADVFormDicContrast).saveContrast("8^000003^测试000003^N^65")
ClassMethod saveContrast(mListData As %String) As %String
{
	n (mListData)
	s Len=$L(mListData,"$$")
	s Err=0
	F i=1:1:Len Q:Err'=0  D
	.s mdata=$p(mListData,"$$",i)
	.s Err=..CheckRepeat(mdata)   /// 重复性判断
	.q:Err'=0
	.i $p(mdata,"^",1) ="" d
	..s Err=..insert(mdata)
	.e  d
	..s Err=..update(mdata)
	Q Err
}

/// Descript:	增加 不良事件表单元素对照
/// w ##class(web.DHCADVFormDicContrast).insert("")
ClassMethod insert(ItmTempStr As %String) As %String
{
	N (ItmTempStr)
	S FieldID=$p(ItmTempStr,"^",2)   	/// 字段代码
	S FormDicCode=$p(ItmTempStr,"^",3)    /// 表单元素Code
	S FormNameCode=$p(ItmTempStr,"^",4)       /// 表单Code
 	&SQL(INSERT INTO DHC_AdvFormDicContrast(AF_Field_Dr, AF_FormDicCode, AF_FormNameCode) VALUES(:FieldID,:FormDicCode,:FormNameCode))
 	Q SQLCODE
}

/// Descript:	更新 不良事件表单元素对照
/// w ##class(web.DHCADVFormDicContrast).update("")
ClassMethod update(ItmTempStr As %String) As %String
{
	n (ItmTempStr)
	s ID=$p(ItmTempStr,"^",1)   		/// ID
	S FieldID=$p(ItmTempStr,"^",2)   	/// 字段代码
	S FormDicCode=$p(ItmTempStr,"^",3)    /// 表单元素Code
	S FormNameCode=$p(ItmTempStr,"^",4)       /// 表单Code
	&SQL(Update DHC_AdvFormDicContrast Set AF_Field_Dr=:FieldID,AF_FormDicCode=:FormDicCode, AF_FormNameCode=:FormNameCode WHERE AF_RowID=:ID)  ;AF_Field_Dr=:FieldID, AF_FormDic_Dr=:FormDicID,AF_Form_Dr=:FormID
 	q SQLCODE
}

/// Descript:	删除 不良事件表单元素对照关系
/// w ##class(web.DHCADVFormDicContrast).delContrast("1")
ClassMethod delContrast(ID As %String) As %String
{
	N (ID)
	&SQL(Delete From DHC_AdvFormDicContrast Where AF_RowID=:ID)
	Q SQLCODE
}

/// Descript:检查代码、描述是否重复
ClassMethod CheckRepeat(ItmTempStr As %String) As %String
{
	N (ItmTempStr)
	s ID=$p(ItmTempStr,"^",1)   		/// ID
	S FieldID=$p(ItmTempStr,"^",2)   	/// 字段ID
	S FormDicCode=$p(ItmTempStr,"^",3)    /// 表单元素Code
	S FormNameCode=$p(ItmTempStr,"^",4)       /// 表单Code
	S ContrastID="",flag=0
	S:(ID="")&&($d(^DHCADVFDC(0,"FormNameDic",FormNameCode,FormDicCode))) flag=-1
	S:(ID="")&&($d(^DHCADVFDC(0,"FieldFormName",FieldID,FormNameCode))) flag=-1

	I ID'=""  D
	.S FDCFieldID=$p(^DHCADVFDC(ID),"^",1)          /// 字段ID
	.S FDCFormNameCode =$p(^DHCADVFDC(ID),"^",5)        /// 表单代码
	.S FDCFormDicCode =$p(^DHCADVFDC(ID),"^",4)
	.I (FDCFormNameCode'=FormNameCode)||(FDCFormDicCode'=FormDicCode) D
	..S:$d(^DHCADVFDC(0,"FormNameDic",FormNameCode,FormDicCode)) flag=-2
	.I (FDCFormNameCode'=FormNameCode)||(FDCFieldID'=FieldID) D
	..S:$d(^DHCADVFDC(0,"FieldFormName",FieldID,FormNameCode)) flag=-2	
	.
	q flag
}

/// Descript:	查询 [不良事件表单元素对照关系]
/// w ##class(web.DHCADVFormDicContrast).QryDicContrast("40","1","^^994")
ClassMethod QryDicContrast(rows As %String, page As %String, params As %String) As %String
{
	N (rows,page,params)
	s End = page*rows
	s Start=(page-1)*rows+1
	
    s pid=##Class(web.DHCADVCOMMON).NewPid()
    d ..killTmpGlobal(pid) //k掉临时global
	s Code=$p(params,"^",1)
	s Desc=$p(params,"^",2)
	s Formname=$p(params,"^",3)
	s h=0,count=0
	s ID="0"
	F  s ID=$o(^DHCADVFDC(ID)) Q:ID=""  D
	.Q:ID=0
	.s FieldID=$p(^DHCADVFDC(ID),"^",1)          /// 字段ID
	.s FieldCode=$p(^DHCADVFF(FieldID),"^",1)    /// 字段代码
	.s FieldDesc=$p(^DHCADVFF(FieldID),"^",2)    /// 字段描述
	.s FormDicCode =$p(^DHCADVFDC(ID),"^",4)        /// 元素代码
	.S FormDicID=$o(^User.DHCAdvFormDicI("IndexField",##class(web.DHCADVAction).ALPHAUP(FormDicCode),""))  
	.Q:FormDicID=""
	.s FormDicData=^User.DHCAdvFormDicD(FormDicID)
	.s FormDicDesc=$LIST(FormDicData,4)          /// 元素描述
	.s:FormDicDesc["<span" FormDicDesc=$p(FormDicDesc,"<span",1)
	.s:FormDicDesc["&nbsp" FormDicDesc=$p(FormDicDesc,"&nbsp",1)
	.s FormNameCode =$p(^DHCADVFDC(ID),"^",5)        /// 表单代码
	.s FormNameID=$o(^User.DHCAdvFormNameI("IndexCode",$$ALPHAUP^SSUTIL4(FormNameCode),""))   /// 表单ID
	.Q:FormNameID=""
	.s FormNameData=^User.DHCAdvFormNameD(FormNameID)
  	.s FormNameDesc=$List(FormNameData,3)
  	.Q:(Formname'="")&&(FormNameID'=Formname)
  	.Q:(##class(web.DHCADVAction).ALPHAUP(Code)'="")&&(##class(web.DHCADVAction).ALPHAUP(FieldCode)'[##class(web.DHCADVAction).ALPHAUP(Code))
  	.Q:(Desc'="")&&(FieldDesc'[Desc)
	.s h=h+1
	.s ListData=ID_"^"_FieldID_"^"_FieldCode_"^"_FieldDesc_"^"_FormDicID_"^"_FormDicCode_"^"_FormDicDesc_"^"_FormNameID_"^"_FormNameDesc_"^"_FormNameCode
	.s ^TMP("DHCADV","web.DHCADVFormDicContrast","QryDicContrast",pid,h)=ListData
	i h=0 w ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(h) //输出json结尾符
	Q:h=0 ""
	
	///转换数据为Json格式
	S ListTitle="ID^FieldID^FieldCode^FieldDesc^FormDicID^FormDicCode^FormDicDesc^FormNameID^FormNameDesc^FormNameCode"
	w ##class(web.DHCADVJSONCOMMON).getJsonStartSign(h) //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCADV","web.DHCADVFormDicContrast","QryDicContrast",pid,index)) q:index=""  d
	.s ListData=$g(^TMP("DHCADV","web.DHCADVFormDicContrast","QryDicContrast",pid,index))
	.s count = count+1
	.q:(count<Start)||(count>End)
	.I count=Start d
	..w ##class(web.DHCADVJSONCOMMON).getJsonData(ListTitle,ListData)
	.e  d
	..w ","_##class(web.DHCADVJSONCOMMON).getJsonData(ListTitle,ListData)
	
	w ##class(web.DHCADVJSONCOMMON).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// Descript:  查询表单
/// w ##class(web.DHCADVFormDicContrast).jsonForm("")
ClassMethod jsonForm(HospID As %String) As %String
{
	n (HospID)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT ID, code,name,active FROM DHC_AdvFormName" 
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s RowID = result.Data("ID")
		s Code = result.Data("code")
		s Desc = result.Data("name")
		s activeflag = result.Data("active")
		s tmp=RowID_"^"_Code_"^"_Desc
		continue:activeflag'="Y"
		s count = count+1
		I count=1 d
		.W ##class(web.DHCADVJSONCOMMON).getJsonData("value^code^text",tmp)
		e  d
		.W ","_##class(web.DHCADVJSONCOMMON).getJsonData("value^code^text",tmp)
	}
	w "]"
	Q ""
}

/// Descript:  查询表单对应元素
/// w ##class(web.DHCADVFormDicContrast).jsonFormDic("1020")
ClassMethod jsonFormDic(FormID As %String) As %String
{
	n (FormID)
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
	.s count = count+1
	.I count=1 d
	..W ##class(web.DHCADVJSONCOMMON).getJsonData("value^text^code",tmp)
	.e  d
	..W ","_##class(web.DHCADVJSONCOMMON).getJsonData("value^text^code",tmp)
	w "]"
	Q ""
}

/// Descript:  查询表字段维护
/// w ##class(web.DHCADVFormDicContrast).jsonFormField("")
ClassMethod jsonFormField(HospID As %String) As %String
{
	n (HospID)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT AF_RowID, AF_FieldCode, AF_FieldDesc FROM DHC_AdvFormField" 
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s RowID = result.Data("AF_RowID")
		Continue:RowID=0
		s Code = result.Data("AF_FieldCode")
		s Desc = result.Data("AF_FieldDesc")
		s tmp=RowID_"^"_Desc_"^"_Code
		s count = count+1
		I count=1 d
		.W ##class(web.DHCADVJSONCOMMON).getJsonData("value^text^code",tmp)
		e  d
		.W ","_##class(web.DHCADVJSONCOMMON).getJsonData("value^text^code",tmp)
	}
	w "]"
	Q ""
}

/// Descript:   取表单元素值
/// InPut:      RecordId-表单记录ID，FormId-表单元素ID，FieldCode-存储表字段代码
/// w ##class(web.DHCADVFormDicContrast).GetFormDicVal("147","829","CellOrder")
ClassMethod GetFormDicVal(RecordId As %String, FormId As %String, FieldCode As %String) As %String
{
	n (RecordId, FormId, FieldCode)
	Q:(RecordId="")||(FormId="") -1
	s FieldID=$o(^DHCADVFF(0,"Code",$$ALPHAUP^SSUTIL4(FieldCode),""))
	Q:FieldID="" -2
	s ID=$o(^DHCADVFDC(0,"FieldCode",FieldID,FormId,""))  /// 对照关系ID
	Q:ID="" -3
	s FormDicID=$p(^DHCADVFDC(ID),"^",3)    /// 元素ID
	Q:FormDicID="" -4
	s itmID="",itmValue=""
	f  s itmID=$o(^User.DHCAdvFormRecordItmI("IndexFormRecord",RecordId,itmID))	Q:(itmID="")||(itmValue'="")  D
	.s itmData=^User.DHCAdvFormRecordItmD(itmID)
	.Q:$LIST(itmData,3)'=FormDicID
	.s itmValue=$LIST(itmData,4)  			   /// 元素值
    Q itmValue
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	N (pid)
	k ^TMP("DHCADV","web.DHCADVFormDicContrast","QryDicContrast",pid)
	q ""
}

/// Descript:	修改 [不良事件表单元素对照关系] 将元素代码与表单代码存入表中 运行此方法需修改 update方法
/// w ##class(web.DHCADVFormDicContrast).UpdateDicContrast()
ClassMethod UpdateDicContrast() As %String
{
	s ID="0",Err=0
	F  s ID=$o(^DHCADVFDC(ID)) Q:ID=""  D
	.s FieldID=$p(^DHCADVFDC(ID),"^",1)          /// 字段ID
	.s FormDicID=$p(^DHCADVFDC(ID),"^",2)        /// 元素ID
	.s FormDicData=^User.DHCAdvFormDicD(FormDicID)
	.s FormDicCode=$LIST(FormDicData,2)          /// 元素代码
	.s FormDicDesc=$LIST(FormDicData,4)          /// 元素描述
	.s FormID=$p(^DHCADVFDC(ID),"^",3)           /// 表单ID
	.s FormData=^User.DHCAdvFormNameD(FormID)
  	.s FormCode=$List(FormData,2)
  	.S List=ID_"^"_FieldID_"^"_FormDicCode_"^"_FormCode
  	.s Err=..update(List)
	q Err
}

/// Descript:  查询表单对应元素
/// Creator:     yuliping
/// CreateDate:  2020-04-03
/// Input:  	 FormID
/// Return: 	表单元素id
/// w ##class(web.DHCADVFormDicContrast).jsonFormDicNew("992")
ClassMethod jsonFormDicNew(FormID As %String) As %String
{
	n (FormID)

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
	.Q:$LIST(FormDicData,3)="panel"  /// 元素类型
	.Q:($LIST(FormDicData,3)="textarea")
	.i ($LIST(FormDicData,3)="select-change") d ..getSelectForm(FormDicId,count)
	.q:(itmCode["(")&(itmCode[")")    //过滤
	.s itmTitle=$LIST(FormDicData,4)    /// 元素描述
	.s:itmTitle["<span" itmTitle=$p(itmTitle,"<span",1)
	.s:itmTitle["&nbsp" itmTitle=$p(itmTitle,"&nbsp",1)
	.s tmp=FormDicId_"^"_itmTitle_"^"_itmCode
	
	.s count = count+1
	.I count=1 d
	..W ##class(web.DHCADVJSONCOMMON).getJsonData("value^text^code",tmp)
	.e  d
	..W ","_##class(web.DHCADVJSONCOMMON).getJsonData("value^text^code",tmp)
	w "]"
	Q ""
}

/// Descript:  表单内嵌form类型，再取该form下的元素
/// Creator:     yuliping
/// CreateDate:  2020-04-07
/// Input:  	 FormID
/// Return: 	表单元素id
/// w ##class(web.DHCADVFormDicContrast).getSelectForm("98357",0)
ClassMethod getSelectForm(formId, count)
{
	n (formId,count)
	s child=""
	f  s child=$o(^User.DHCAdvFormDicI("IndexParef"," "_formId,child)) q:child=""  d
	.s childC=""
	.f  s childC=$o(^User.DHCAdvFormDicI("IndexParef"," "_child,childC)) q:childC=""  d
	..q:$LIST(^User.DHCAdvFormDicD(childC),3)'="form"  /// 元素类型
	..d ..getFormDicId($LIST(^User.DHCAdvFormDicD(childC),7), count)
	
	q ""
}

/// Descript:  表单内嵌form类型查询表单对应元素
/// Creator:     yuliping
/// CreateDate:  2020-04-03
/// Input:  	 FormID
/// Return: 	表单元素id
ClassMethod getFormDicId(FormName, count)
{
	
	n (FormName,count)
	
	s FormID=$o(^User.DHCAdvFormNameI("IndexCode",$$ALPHAUP^SSUTIL4(FormName),""))
	q:FormID="" ""
	s version=$o(^User.DHCAdvFormI("IndexNameVersion",FormID,""),-1)
	Q:version="" ""
	s ID=""
	F  s ID=$o(^User.DHCAdvFormI("IndexNameVersion",FormID,version,ID)) Q:ID=""  D
	.s itmData=^User.DHCAdvFormD(ID)
	.s FormDicId=$LIST(itmData,4)
	.Q:FormDicId=""
	.Q:'$d(^User.DHCAdvFormDicD(FormDicId))
	.s FormDicData=^User.DHCAdvFormDicD(FormDicId)
	.s itmCode=$LIST(FormDicData,2)     /// 元素代码
	.Q:$LIST(FormDicData,3)="fieldset"  /// 元素类型
	.Q:$LIST(FormDicData,3)="panel"  /// 元素类型
	.Q:($LIST(FormDicData,3)="textarea")
	.q:(itmCode["(")&(itmCode[")")    //过滤
	.s itmTitle=$LIST(FormDicData,4)    /// 元素描述
	.s:itmTitle["<span" itmTitle=$p(itmTitle,"<span",1)
	.s:itmTitle["&nbsp" itmTitle=$p(itmTitle,"&nbsp",1)
	.s tmp=FormDicId_"^"_itmTitle_"^"_itmCode
	
	.s count = count+1
	.I count=1 d
	..W ##class(web.DHCADVJSONCOMMON).getJsonData("value^text^code",tmp)
	.e  d
	..W ","_##class(web.DHCADVJSONCOMMON).getJsonData("value^text^code",tmp)


	q ""
}

}
