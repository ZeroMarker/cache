Class CHSSWeb.PersonHealthDiagnoseService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// Creator: wangbo
/// CreatDate：2009—05-11
/// Description:检索个人暴露史
/// Table：PersonHealthRecordMain
/// Input:CommunityCode , start, limit ,sort
/// Output：
/// Return：
/// Others：
ClassMethod ListPage(Start As %Integer, Limit As %Integer, PersonRowIdParref As %Integer, ItemdCode As %String) As %String
{
		set ItemdCode = " "_ItemdCode
		set ItemCode = ""
		Set start=$G(Start)
		Set limit=$G(Limit)
		Set sort=$G(sort)
		Set count=0
		Set resultString = ""
		Set end = start+limit
		Set json = ##class(Code.JsonObj).%New()
		set DiagnoseRowId = 0
		For  Set DiagnoseRowId=$O(^CHSS.PersonHealthDiagnoseI("PersonAndCodeIndex",PersonRowIdParref, ItemdCode, DiagnoseRowId)) q:DiagnoseRowId=""  d
		.s tempObj=##class(CHSS.PersonHealthDiagnose).%OpenId(DiagnoseRowId)
		.s DetailRowId = tempObj.DetailRowId
		.s ItemName = tempObj.ItemName
		.s ItemCode = tempObj.ItemdCode
		.s ItemAssortCode = tempObj.ItemAssortCode
		.s ItemAssortName = tempObj.ItemAssortName
		.s DiagnoseResult = tempObj.DiagnoseResult
		.s ICDCode = tempObj.ICDCode
		.set DateOfStart = tempObj.DateOfStart
		.i DateOfStart '= "" d
		..s DateOfStart = $zd(DateOfStart,3)
		.set DateOfEnd = tempObj.DateOfEnd
		.i DateOfEnd '= "" d
		..s DateOfEnd = $zd(DateOfEnd,3)
		.s MainPart = tempObj.MainPart
		.s MainReason = tempObj.MainReason
		.s MainDiagnose = tempObj.MainDiagnose
		.s SequenceCode = tempObj.SequenceCode
		.S tmp= DiagnoseRowId_"^"_DetailRowId_"^"_ItemName_"^"_ItemCode_"^"_ItemAssortCode_"^"_ItemAssortName_"^"_DiagnoseResult_"^"_ICDCode_"^"_DateOfStart_"^"_DateOfEnd_"^"_MainPart_"^"_MainReason_"^"_MainDiagnose_"^"_SequenceCode
	    .S count=count+1
	    .I (count>start)&(count<=end) d
		..d json.InsertRowData(tmp)
	    S resultString = json.getJsonData("DiagnoseRowId^DetailRowId^ItemName^ItemdCode^ItemAssortCode^ItemAssortName^DiagnoseResult^ICDCode^DateOfStart^DateOfEnd^MainPart^MainReason^MainDiagnose^SequenceCode",count)
	 	k json
		w resultString
		q ""
}

/// add by haiwenbo 2011-07-04
ClassMethod PageList(Start As %Integer, Limit As %Integer, PersonRowIdParref As %Integer, ItemdCode As %String, RecordRowIdDR As %Integer) As %String
{
		set ItemdCode = " "_ItemdCode
		set ItemCode = ""
		Set start=$G(Start)
		Set limit=$G(Limit)
		Set sort=$G(sort)
		Set count=0
		Set resultString = ""
		Set end = start+limit
		Set json = ##class(Code.JsonObj).%New()
		set DiagnoseRowId = 0
		For  Set DiagnoseRowId=$O(^CHSS.PersonHealthDiagnoseI("PersonCheckCodeIndex",PersonRowIdParref, ItemdCode, RecordRowIdDR, DiagnoseRowId)) q:DiagnoseRowId=""  d
		.s tempObj=##class(CHSS.PersonHealthDiagnose).%OpenId(DiagnoseRowId)
		.s DetailRowId = tempObj.DetailRowId
		.s ItemName = tempObj.ItemName
		.s ItemCode = tempObj.ItemdCode
		.s ItemAssortCode = tempObj.ItemAssortCode
		.s ItemAssortName = tempObj.ItemAssortName
		.s DiagnoseResult = tempObj.DiagnoseResult
		.s ICDCode = tempObj.ICDCode
		.set DateOfStart = tempObj.DateOfStart
		.i DateOfStart '= "" d
		..s DateOfStart = $zd(DateOfStart,3)
		.set DateOfEnd = tempObj.DateOfEnd
		.i DateOfEnd '= "" d
		..s DateOfEnd = $zd(DateOfEnd,3)
		.s MainPart = tempObj.MainPart
		.s MainReason = tempObj.MainReason
		.s MainDiagnose = tempObj.MainDiagnose
		.s SequenceCode = tempObj.SequenceCode
		.S tmp= DiagnoseRowId_"^"_DetailRowId_"^"_ItemName_"^"_ItemCode_"^"_ItemAssortCode_"^"_ItemAssortName_"^"_DiagnoseResult_"^"_ICDCode_"^"_DateOfStart_"^"_DateOfEnd_"^"_MainPart_"^"_MainReason_"^"_MainDiagnose_"^"_SequenceCode
	    .S count=count+1
	    .I (count>start)&(count<=end) d
		..d json.InsertRowData(tmp)
	    S resultString = json.getJsonData("DiagnoseRowId^DetailRowId^ItemName^ItemdCode^ItemAssortCode^ItemAssortName^DiagnoseResult^ICDCode^DateOfStart^DateOfEnd^MainPart^MainReason^MainDiagnose^SequenceCode",count)
	 	k json
		w resultString
		q ""
}

/// add by haiwenbo 2011-07-04
ClassMethod ShowInfoList(Start As %Integer, Limit As %Integer, PersonRowIdParref As %Integer, ItemdCode As %String, RecordRowIdDR As %Integer) As %String
{
		set ItemdCode = " "_ItemdCode
		set ItemCode = ""
		Set start=$G(Start)
		Set limit=$G(Limit)
		Set sort=$G(sort)
		Set count=0
		Set resultString = ""
		Set end = start+limit
		set tmp = ""
		set startStr = "'"
		Set json = ##class(Code.JsonObj).%New()
		set DiagnoseRowId = 0
		For  Set DiagnoseRowId=$O(^CHSS.PersonHealthDiagnoseI("PersonCheckCodeIndex",PersonRowIdParref, ItemdCode, RecordRowIdDR, DiagnoseRowId)) q:DiagnoseRowId=""  d
		.s tempObj=##class(CHSS.PersonHealthDiagnose).%OpenId(DiagnoseRowId)
		.s DetailRowId = tempObj.DetailRowId
		.s ItemName = tempObj.ItemName
		.//s ItemCode = tempObj.ItemdCode
		.s ItemAssortCode = tempObj.ItemAssortCode
		.s ItemAssortName = tempObj.ItemAssortName
		.s DiagnoseResult = tempObj.DiagnoseResult
		.s ICDCode = tempObj.ICDCode
		.set DateOfStart = tempObj.DateOfStart
		.i DateOfStart '= "" d
		..s DateOfStart = $zd(DateOfStart,3)
		.set DateOfEnd = tempObj.DateOfEnd
		.i DateOfEnd '= "" d
		..s DateOfEnd = $zd(DateOfEnd,3)
		.s MainPart = tempObj.MainPart
		.s MainReason = tempObj.MainReason
		.s MainDiagnose = tempObj.MainDiagnose
		.s SequenceCode = tempObj.SequenceCode
		.S count=count+1
		.
		.
		.i ItemdCode = " 1" d  //ABO血型
		..s tmp = tmp_startStr_DiagnoseResult
		.e  i ItemdCode = " 2" d  //RH血型
		..s tmp = tmp_startStr_DiagnoseResult
		.e  i ItemdCode = " 3" d  //药物过敏史
		..s tmp = tmp_startStr_ItemAssortName
		.e  i ItemdCode = " 4" d  //暴露史
		..s tmp = tmp_startStr_ItemAssortName_":"_DiagnoseResult
		.e  i ItemdCode = " 5" d  //疾病史
		..s tmp = tmp_startStr_ItemAssortName
		.e  i ItemdCode = " 51" d  //外伤
		..s tmp = tmp_startStr_ItemAssortName
		.e  i ItemdCode = " 6" d  //手术史
		..s tmp = tmp_startStr_ItemAssortName
		.e  i ItemdCode = " 7" d  //输血情况
		..s tmp = tmp_startStr_DiagnoseResult
		.e  i ItemdCode = " 8" d  //家族疾病史-父亲
		..s tmp = tmp_startStr_ItemAssortName
		.e  i ItemdCode = " 9" d  //家族疾病史-母亲
		..s tmp = tmp_startStr_ItemAssortName
		.e  i ItemdCode = " 10" d  //家族疾病史-兄弟姐妹
		..s tmp = tmp_startStr_ItemAssortName
		.e  i ItemdCode = " 11" d  //家族疾病史-子女
		..s tmp = tmp_startStr_ItemAssortName
		.e  i ItemdCode = " 12" d  //家族遗传病史
		..s tmp = tmp_startStr_ItemAssortName
		.e  i ItemdCode = " 13" d  //精神疾病情况
		..s tmp = tmp_startStr_ItemAssortName
		.e  i ItemdCode = " 14" d  //残疾状况
		..s tmp = tmp_startStr_ItemAssortName
		.e  i ItemdCode = " 15" d  //免疫接种类别
		..s tmp = tmp_startStr_ItemAssortName
		.e  i ItemdCode = " 16" d  //并发症
		..i DateOfStart '= "" d
		...s DateOfStart =  $p(DateOfStart,"-",1,1)
		...s tmp = tmp_startStr_ItemAssortName_":"_DateOfStart_"年"
		..e  d
		...s tmp = tmp_startStr_ItemAssortName
		.e  i ItemdCode = " 18" d  //有创医疗操作
		..s tmp = tmp_startStr_ItemAssortName
		.e  i ItemdCode = " 19" d  //体征
		..s tmp = tmp_startStr_ItemAssortName
		.e  i ItemdCode = " 20" d  //传染病接触史
		..s tmp = tmp_startStr_ItemAssortName
		.e  i ItemdCode = " 21" d //X线检查结果
		..s tmp = tmp_startStr_ItemAssortName_DiagnoseResult_ItemAssortCode
		.e  i ItemdCode = " 22" d  //慢性病
		..s tmp = tmp_startStr_ItemAssortName
		.e  i ItemdCode = " 23" d  //家族疾病史-祖辈
		..s tmp = tmp_startStr_ItemAssortName
		.e  i ItemdCode = " 24" d  //中医体质辨识
		..s tmp = tmp_startStr_ItemAssortName_":"_DiagnoseResult
		.e  i ItemdCode = " 25" d  //现存主要健康问题
		..s tmp = tmp_startStr_DiagnoseResult
		.e  i ItemdCode = " 26" d  //住院史
		..s tmp = tmp_startStr_ItemAssortName_":"_DiagnoseResult
		.e  i ItemdCode = " 27" d  //家庭病床史
		..s tmp = tmp_startStr_ItemAssortName_":"_DiagnoseResult
		.e  i ItemdCode = " 28" d  //主要用药情况
		..s tmp = tmp_startStr_ItemAssortName
		.e  i ItemdCode = " 29" d  //妇科疾病
		..s tmp = tmp_startStr_ItemAssortName
		.s startStr = "、"
		i tmp '= "" d
		.s tmp = tmp_"'"
		.
		e  d
	    .s tmp = """"""
		w "{""success"":""true"",""info"":"_tmp_"}"
		q ""
}

ClassMethod ShowInfo(Start As %Integer, Limit As %Integer, PersonRowIdParref As %Integer, ItemdCode As %String) As %String
{
		set ItemdCode = " "_ItemdCode
		set ItemCode = ""
		Set start=$G(Start)
		Set limit=$G(Limit)
		Set sort=$G(sort)
		Set count=0
		Set resultString = ""
		Set end = start+limit
		set tmp = ""
		set startStr = "'"
		Set json = ##class(Code.JsonObj).%New()
		set DiagnoseRowId = 0
		For  Set DiagnoseRowId=$O(^CHSS.PersonHealthDiagnoseI("PersonAndCodeIndex",PersonRowIdParref, ItemdCode, DiagnoseRowId)) q:DiagnoseRowId=""  d
		.s tempObj=##class(CHSS.PersonHealthDiagnose).%OpenId(DiagnoseRowId)
		.s DetailRowId = tempObj.DetailRowId
		.s ItemName = tempObj.ItemName
		.//s ItemCode = tempObj.ItemdCode
		.s ItemAssortCode = tempObj.ItemAssortCode
		.s ItemAssortName = tempObj.ItemAssortName
		.s DiagnoseResult = tempObj.DiagnoseResult
		.s ICDCode = tempObj.ICDCode
		.set DateOfStart = tempObj.DateOfStart
		.i DateOfStart '= "" d
		..s DateOfStart = $zd(DateOfStart,3)
		.set DateOfEnd = tempObj.DateOfEnd
		.i DateOfEnd '= "" d
		..s DateOfEnd = $zd(DateOfEnd,3)
		.s MainPart = tempObj.MainPart
		.s MainReason = tempObj.MainReason
		.s MainDiagnose = tempObj.MainDiagnose
		.s SequenceCode = tempObj.SequenceCode
		.S count=count+1
		.
		.
		.i ItemdCode = " 1" d  //ABO血型
		..s tmp = tmp_startStr_DiagnoseResult
		.e  i ItemdCode = " 2" d  //RH血型
		..s tmp = tmp_startStr_DiagnoseResult
		.e  i ItemdCode = " 3" d  //药物过敏史
		..s tmp = tmp_startStr_ItemAssortName
		.e  i ItemdCode = " 4" d  //暴露史
		..s tmp = tmp_startStr_ItemAssortName_":"_DiagnoseResult
		.e  i ItemdCode = " 5" d  //疾病史
		..s tmp = tmp_startStr_ItemAssortName
		.e  i ItemdCode = " 51" d  //外伤
		..s tmp = tmp_startStr_ItemAssortName
		.e  i ItemdCode = " 6" d  //手术史
		..s tmp = tmp_startStr_ItemAssortName
		.e  i ItemdCode = " 7" d  //输血情况
		..s tmp = tmp_startStr_DiagnoseResult
		.e  i ItemdCode = " 8" d  //家族疾病史-父亲
		..s tmp = tmp_startStr_ItemAssortName
		.e  i ItemdCode = " 9" d  //家族疾病史-母亲
		..s tmp = tmp_startStr_ItemAssortName
		.e  i ItemdCode = " 10" d  //家族疾病史-兄弟姐妹
		..s tmp = tmp_startStr_ItemAssortName
		.e  i ItemdCode = " 11" d  //家族疾病史-子女
		..s tmp = tmp_startStr_ItemAssortName
		.e  i ItemdCode = " 12" d  //家族遗传病史
		..s tmp = tmp_startStr_ItemAssortName
		.e  i ItemdCode = " 13" d  //精神疾病情况
		..s tmp = tmp_startStr_ItemAssortName
		.e  i ItemdCode = " 14" d  //残疾状况
		..s tmp = tmp_startStr_ItemAssortName
		.e  i ItemdCode = " 15" d  //免疫接种类别
		..s tmp = tmp_startStr_ItemAssortName
		.e  i ItemdCode = " 16" d  //并发症
		..i DateOfStart '= "" d
		...s DateOfStart =  $p(DateOfStart,"-",1,1)
		...s tmp = tmp_startStr_ItemAssortName_":"_DateOfStart_"年"
		..e  d
		...s tmp = tmp_startStr_ItemAssortName
		.e  i ItemdCode = " 18" d  //有创医疗操作
		..s tmp = tmp_startStr_ItemAssortName
		.e  i ItemdCode = " 19" d  //体征
		..s tmp = tmp_startStr_ItemAssortName
		.e  i ItemdCode = " 20" d  //传染病接触史
		..s tmp = tmp_startStr_ItemAssortName
		.e  i ItemdCode = " 21" d //X线检查结果
		..s tmp = tmp_startStr_ItemAssortName_DiagnoseResult_ItemAssortCode
		.e  i ItemdCode = " 22" d  //慢性病
		..s tmp = tmp_startStr_ItemAssortName
		.e  i ItemdCode = " 23" d  //家族疾病史-祖辈
		..s tmp = tmp_startStr_ItemAssortName
		.e  i ItemdCode = " 24" d  //中医体质辨识
		..s tmp = tmp_startStr_ItemAssortName_":"_DiagnoseResult
		.e  i ItemdCode = " 25" d  //现存主要健康问题
		..s tmp = tmp_startStr_DiagnoseResult
		.e  i ItemdCode = " 26" d  //住院史
		..s tmp = tmp_startStr_ItemAssortName_":"_DiagnoseResult
		.e  i ItemdCode = " 27" d  //家庭病床史
		..s tmp = tmp_startStr_ItemAssortName_":"_DiagnoseResult
		.e  i ItemdCode = " 28" d  //主要用药情况
		..s tmp = tmp_startStr_ItemAssortName
		.e  i ItemdCode = " 29" d  //妇科疾病
		..s tmp = tmp_startStr_ItemAssortName
		.s startStr = "、"
		i tmp '= "" d
		.s tmp = tmp_"'"
		.
		e  d
	    .s tmp = """"""
		w "{""success"":""true"",""info"":"_tmp_"}"
		q ""
}

ClassMethod ShowInfoForReport(Start As %Integer, Limit As %Integer, PersonRowIdParref As %Integer, ItemdCode As %String) As %String
{
		set ItemdCode = " "_ItemdCode
		set ItemCode = ""
		Set start=$G(Start)
		Set limit=$G(Limit)
		Set sort=$G(sort)
		Set count=0
		Set resultString = ""
		Set end = start+limit
		set tmp = ""
		set startStr = ""
		Set json = ##class(Code.JsonObj).%New()
		set DiagnoseRowId = 0
		For  Set DiagnoseRowId=$O(^CHSS.PersonHealthDiagnoseI("PersonAndCodeIndex",PersonRowIdParref, ItemdCode,DiagnoseRowId)) q:DiagnoseRowId=""  d
		.s tempObj=##class(CHSS.PersonHealthDiagnose).%OpenId(DiagnoseRowId)
		.s DetailRowId = tempObj.DetailRowId
		.s ItemName = tempObj.ItemName
		.//s ItemCode = tempObj.ItemdCode
		.s ItemAssortCode = tempObj.ItemAssortCode
		.s ItemAssortName = tempObj.ItemAssortName
		.s DiagnoseResult = tempObj.DiagnoseResult
		.s ICDCode = tempObj.ICDCode
		.set DateOfStart = tempObj.DateOfStart
		.i DateOfStart '= "" d
		..s DateOfStart = $zd(DateOfStart,3)
		.set DateOfEnd = tempObj.DateOfEnd
		.i DateOfEnd '= "" d
		..s DateOfEnd = $zd(DateOfEnd,3)
		.s MainPart = tempObj.MainPart
		.s MainReason = tempObj.MainReason
		.s MainDiagnose = tempObj.MainDiagnose
		.s SequenceCode = tempObj.SequenceCode
		.S count=count+1
		.
		.
		.i ItemdCode = " 1" d  //ABO血型
		..s tmp = tmp_startStr_DiagnoseResult
		.e  i ItemdCode = " 2" d  //RH血型
		..s tmp = tmp_startStr_DiagnoseResult
		.e  i ItemdCode = " 3" d  //药物过敏史
		..s tmp = tmp_startStr_ItemAssortName
		.e  i ItemdCode = " 4" d  //暴露史
		..s tmp = tmp_startStr_DiagnoseResult
		.e  i ItemdCode = " 5" d  //疾病史
		..s tmp = tmp_startStr_ItemAssortName
		.e  i ItemdCode = " 51" d  //外伤
		..s tmp = tmp_startStr_ItemAssortName
		.e  i ItemdCode = " 6" d  //手术史
		..s tmp = tmp_startStr_ItemAssortName
		.e  i ItemdCode = " 7" d  //输血情况
		..s tmp = tmp_startStr_DiagnoseResult
		.e  i ItemdCode = " 8" d  //家族疾病史-父亲
		..s tmp = tmp_startStr_ItemAssortName
		.e  i ItemdCode = " 9" d  //家族疾病史-母亲
		..s tmp = tmp_startStr_ItemAssortName
		.e  i ItemdCode = " 10" d  //家族疾病史-兄弟姐妹
		..s tmp = tmp_startStr_ItemAssortName
		.e  i ItemdCode = " 11" d  //家族疾病史-子女
		..s tmp = tmp_startStr_ItemAssortName
		.e  i ItemdCode = " 12" d  //家族遗传病史
		..s tmp = tmp_startStr_ItemAssortName
		.e  i ItemdCode = " 13" d  //精神疾病情况
		..s tmp = tmp_startStr_ItemAssortName
		.e  i ItemdCode = " 14" d  //残疾状况
		..s tmp = tmp_startStr_ItemAssortName
		.e  i ItemdCode = " 15" d  //免疫接种类别
		..s tmp = tmp_startStr_ItemAssortName
		.e  i ItemdCode = " 16" d  //并发症
		..i DateOfStart '= "" d
		...s DateOfStart =  $p(DateOfStart,"-",1,1)
		...s tmp = tmp_startStr_ItemAssortName_":"_DateOfStart_"年"
		..e  d
		...s tmp = tmp_startStr_ItemAssortName
		.e  i ItemdCode = " 18" d  //有创医疗操作
		..s tmp = tmp_startStr_ItemAssortName
		.e  i ItemdCode = " 19" d  //体征
		..s tmp = tmp_startStr_ItemAssortName
		.e  i ItemdCode = " 20" d  //传染病接触史
		..s tmp = tmp_startStr_ItemAssortName
		.e  i ItemdCode = " 21" d //X线检查结果
		..s tmp = tmp_startStr_ItemAssortName_DiagnoseResult_ItemAssortCode
		.e  i ItemdCode = " 22" d  //慢性病
		..s tmp = tmp_startStr_ItemAssortName
		.e  i ItemdCode = " 23" d  //家族疾病史-祖辈
		..s tmp = tmp_startStr_ItemAssortName
		.e  i ItemdCode = " 24" d  //中医体质辨识
		..s tmp = tmp_startStr_ItemAssortName
		.e  i ItemdCode = " 25" d  //现存主要健康问题
		..s tmp = tmp_startStr_ItemAssortName
		.e  i ItemdCode = " 26" d  //住院史
		..s tmp = tmp_startStr_ItemAssortName
		.e  i ItemdCode = " 27" d  //家庭病床史
		..s tmp = tmp_startStr_ItemAssortName
		.e  i ItemdCode = " 28" d  //主要用药情况
		..s tmp = tmp_startStr_ItemAssortName
		.e  i ItemdCode = " 29" d  //妇科疾病
		..s tmp = tmp_startStr_ItemAssortName
		.s startStr = "  "
		
		q tmp
}

/// add by haiwenbo 2011-07-04
ClassMethod insertList(DetailRowId As %Integer, PersonRowIdParref As %Integer, ItemName As %String, ItemdCode As %String, ItemAssortCode As %String, ItemAssortName As %String, DiagnoseResult As %String, ICDCode As %String, DateOfStart As %Date, DateOfEnd As %Date, MainPart As %Integer, MainReason As %Integer, MainDiagnose As %Integer, SequenceCode As %Integer, TableType As %String, RecordRowIdDR As %Integer) As %String
{
	q:PersonRowIdParref="" "个人档案号不允许为空，保存出错！"
	//s rowId=..rName(Description)
	//q:rowId'="" "name-rep"
	
	//i (active'="Y")||(active'="N") s active="Y"
	i DateOfStart '= "" d
	.s DateOfStart=$zdh(DateOfStart,3)
	i DateOfEnd '= "" d
	.s DateOfEnd=$zdh(DateOfEnd,3)
	&sql(insert into CHSS.PersonHealthDiagnose (DetailRowId, PersonRowIdParref, ItemName, ItemdCode, ItemAssortCode, ItemAssortName,DiagnoseResult,ICDCode,DateOfStart,DateOfEnd,MainPart,MainReason,MainDiagnose,SequenceCode,TableName,RecordRowIdDR) 
	values(:DetailRowId, :PersonRowIdParref, :ItemName, :ItemdCode, :ItemAssortCode, :ItemAssortName,:DiagnoseResult,:ICDCode,:DateOfStart,:DateOfEnd,:MainPart,:MainReason,:MainDiagnose,:SequenceCode,:TableType,:RecordRowIdDR))
	q SQLCODE
}

ClassMethod insert(DetailRowId As %Integer, PersonRowIdParref As %Integer, ItemName As %String, ItemdCode As %String, ItemAssortCode As %String, ItemAssortName As %String, DiagnoseResult As %String, ICDCode As %String, DateOfStart As %Date, DateOfEnd As %Date, MainPart As %Integer, MainReason As %Integer, MainDiagnose As %Integer, SequenceCode As %Integer, TableType As %String) As %String
{
	q:PersonRowIdParref="" "个人档案号不允许为空，保存出错！"
	//s rowId=..rName(Description)
	//q:rowId'="" "name-rep"
	
	//i (active'="Y")||(active'="N") s active="Y"
	i DateOfStart '= "" d
	.s DateOfStart=$zdh(DateOfStart,3)
	i DateOfEnd '= "" d
	.s DateOfEnd=$zdh(DateOfEnd,3)
	&sql(insert into CHSS.PersonHealthDiagnose (DetailRowId, PersonRowIdParref, ItemName, ItemdCode, ItemAssortCode, ItemAssortName,DiagnoseResult,ICDCode,DateOfStart,DateOfEnd,MainPart,MainReason,MainDiagnose,SequenceCode,TableName) 
	values(:DetailRowId, :PersonRowIdParref, :ItemName, :ItemdCode, :ItemAssortCode, :ItemAssortName,:DiagnoseResult,:ICDCode,:DateOfStart,:DateOfEnd,:MainPart,:MainReason,:MainDiagnose,:SequenceCode,:TableType))
	q SQLCODE
}

ClassMethod update(DiagnoseRowId As %Integer, DetailRowId As %Integer, PersonRowIdParref As %Integer, ItemName As %String, ItemdCode As %String, ItemAssortCode As %String, ItemAssortName As %String, DiagnoseResult As %String, ICDCode As %String, DateOfStart As %Date, DateOfEnd As %Date, MainPart As %Integer, MainReason As %Integer, MainDiagnose As %Integer, SequenceCode As %Integer) As %String
{
	q:(PersonRowIdParref="") "code-rep"
	i DateOfStart '= "" d
	.s DateOfStart=$zdh(DateOfStart,3)
	i DateOfEnd '= "" d
	.s DateOfEnd=$zdh(DateOfEnd,3)
	
	&sql(update CHSS.PersonHealthDiagnose set DetailRowId=:DetailRowId,ItemName=:ItemName,ItemdCode=:ItemdCode,ItemAssortCode=:ItemAssortCode,ItemAssortName=:ItemAssortName,DiagnoseResult=:DiagnoseResult,ICDCode=:ICDCode,DateOfStart=:DateOfStart,DateOfEnd=:DateOfEnd,MainPart=:MainPart,MainReason=:MainReason,MainDiagnose=:MainDiagnose,SequenceCode=:SequenceCode where %ID=:DiagnoseRowId)
	q SQLCODE
}

//删除一条数据库中已经存在的记录

ClassMethod delete(RowId) As %String
{
	&sql(delete from CHSS.PersonHealthDiagnose where %ID=:RowId)
	q SQLCODE
}

/// Creator: wangbo
/// CreatDate：2009—05-11
/// Description:更新个人档案基本信息
/// (注意：对于表字段多的情况采用这种对类赋值的方式，如果字段较少，可以直接采用SQL语句)
/// Table：PersonHealthRecordMain
/// Input:personRowId,PersonHealthRecordMain
/// Output：
/// Return：
/// Others：
/// 
ClassMethod UpdatePersonHealthInfo(PersonRowId As %Integer, HaveDeformityCertificate As %String, DeformityCode As %String) As %String
{
	q:($d(PersonRowId)=0)||(PersonRowId="")

	
	s tempPerson="",result=""
	s tempPerson=##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowId)
	q:(tempPerson="") ""

	s tempPerson.HaveDeformityCertificate = HaveDeformityCertificate
	s tempPerson.DeformityCode = DeformityCode
	
	s result=""
	s result=tempPerson.%Save()
	i result = "1" d
	.w "{""success"":""true"",""info"":"_PersonRowId_"}"
    .
    e  d
    .w "{""success"":""false"",""info"":""数据保存出错!""}"
    .
    q ""
}

Storage Default
{
<Data name="PersonHealthDiagnoseServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.PersonHealthAC8D</DataLocation>
<DefaultData>PersonHealthDiagnoseServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.PersonHealthAC8D</IdLocation>
<IndexLocation>^CHSSWeb.PersonHealthAC8I</IndexLocation>
<StreamLocation>^CHSSWeb.PersonHealthAC8S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
