Import SQLUSER

/// 富文本保存
Class web.TinySave Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator:qqa
/// Descript:打印模板保存
/// w ##class(web.TinySave).SaveTinysNew(150,"{""attrCode"":""RuleUsage"",""attrDesc"":""用法用量"",""AttrValue"":""<span style=\""background-color: rgb(230, 126, 35); color: rgb(224, 62, 45);\"" data-mce-style=\""background-color: #e67e23; color: #e03e2d;\"">阿萨德阿萨德<br><br><br>阿萨德阿萨德</span>""}")
ClassMethod SaveTinysNew(TinyRowID, Html = "")
{
	n (TinyRowID,Html)
	s StreamObject="",StreamId=""
	&sql(
	select Tiny_RowID into:TinyRowIDs from DHC_CKBTinySave
	where Parref_ID =:TinyRowID
	)
	b ; //1
	s:TinyRowIDs'="" StreamId=$lg(^CT.CKB.PDSS.TinySaveD(TinyRowIDs),1)
	
	i ($l(StreamId)<100)&&(StreamId'=""){
		s StreamId=##Class(ext.util.String).Replace(StreamId,"$c(94)", "^")
		s StreamObject=##class(%GlobalCharacterStream).%Open(StreamId)
	}
	i ('$IsObject(StreamObject)){
		s StreamObject=##class(%GlobalCharacterStream).%New()
	}
	
	i ('$IsObject(Html)){
		d StreamObject.Write(Html)
	}
	i ($IsObject(Html)){
		while('Html.AtEnd){
			s ItmHtml=Html.Read()
			d StreamObject.Write(ItmHtml)
		}
	}
	b ; //2
	ts
	s Ret=StreamObject.%Save()
	tro:Ret'=1
	q:Ret'=1 "保存流数据错误!"
	
	s StreamId=StreamObject.GetStreamId()
	s StreamId=##Class(ext.util.String).Replace(StreamId,"^", "$c(94)")
	
	&sql(UPDATE DHC_CKBTinySave SET Tiny_Text=:StreamId WHERE Tiny_RowID=:TinyRowIDs)
	tro:SQLCODE'=0
	q:SQLCODE'=0 "保存主表数据错误!"
	
	
	b ; //3
	tc
	q 0
}

/// 流的存储
/// w ##class(web.TinySave).SaveStream(150,"{""attrCode"":""RuleUsage"",""attrDesc"":""用法用量"",""AttrValue"":""<span style=\""background-color: rgb(230, 126, 35); color: rgb(224, 62, 45);\"" data-mce-style=\""background-color: #e67e23; color: #e03e2d;\"">阿萨德阿萨德<br><br><br>阿萨德阿萨德</span>""}")
/// w ##class(web.TinySave).SaveStream("disi")
ClassMethod SaveStream(TinyRowID, Html)
{
	n (TinyRowID,Html)
	s StreamObject="",StreamId=""
	s StreamObject=##class(%GlobalCharacterStream).%New()
	d StreamObject.Write(Html)
	
 	ts
	
	s Ret=StreamObject.%Save()
	tro:Ret'=1
	q:Ret'=1 "保存流数据错误!"
	
	s StreamId=StreamObject.GetStreamId()
	s StreamId=##Class(ext.util.String).Replace(StreamId,"^", "$c(94)")
	
	&SQL(Insert into DHC_CKBTinySave (Tiny_Text,Parref_ID) values 
	(:StreamId,:TinyRowID))
	tro:SQLCODE'=0
	q:SQLCODE'=0 "保存主表数据错误!"
	
	tc
	q 0
}

// w ##class(web.TinySave).Save(50,"{""attrCode"":""RuleUsage"",""attrDesc"":""用法用量"",""AttrValue"":""<span style=\""background-color: rgb(230, 126, 35); color: rgb(224, 62, 45);\"" data-mce-style=\""background-color: #e67e23; color: #e03e2d;\"">阿萨德阿萨德<br><br><br>阿萨德阿萨德</span>""}")

ClassMethod Save(TinyRowID, Html)
{
	n (TinyRowID,Html)
	s Ret = 0
	ts
	
	i $d(^CT.CKB.PDSS.TinySaveI("Parref",TinyRowID))=0  d
	.s Ret= ##class(web.TinySave).SaveStream(TinyRowID,Html)
	.tro:Ret'=0
	.i Ret'=0
	..q  Ret
	
	i $d(^CT.CKB.PDSS.TinySaveI("Parref",TinyRowID))=10  d
	.s Ret =  ##class(web.TinySave).SaveTinysNew(TinyRowID,Html)
	.tro:Ret'=0
	.i Ret'=0
	..q  Ret
	tc
	q Ret
}

/// Creator:qqa
/// Descript:打印模板获取
/// w ##class(web.TinySave).GetTmpDatasNew(153)
ClassMethod GetTmpDatasNew(TinyRowID)
{
	n (TinyRowID)
	&sql(
	select Tiny_RowID into:TinyRowIDs from DHC_CKBTinySave
	where Parref_ID =:TinyRowID
	)
	q:TinyRowIDs="" ""
	
	
	s StreamId=$lg(^CT.CKB.PDSS.TinySaveD(TinyRowIDs),1)
		
	s ItmData = ""	
	
	i (StreamId'=""){
		s StreamId=##Class(ext.util.String).Replace(StreamId,"$c(94)", "^")
		s StreamObject=##class(%GlobalCharacterStream).%Open(StreamId)
		while ('StreamObject.AtEnd){
			s a = StreamObject.Read()
		}
	}
	q a
}

/// Creator:qqa
/// Descript:打印模板获取
/// w ##class(web.TinySave).GetTmpDatasNew(150)
ClassMethod GetDefaultData(TinyRowID)
{
	n (TinyRowID)
	s StreamId=$lg(^CT.CKB.PDSS.TinySaveD(TinyRowID),1)
	i (StreamId'=""){
		s StreamId=##Class(ext.util.String).Replace(StreamId,"$c(94)", "^")
		s StreamObject=##class(%GlobalCharacterStream).%Open(StreamId)
		while ('StreamObject.AtEnd){
			s a = StreamObject.Read()
		}
	}
	q a
}

/// Creator:qqa
/// Descript:打印模板获取
/// w ##class(web.TinySave).TinyDeal("[{""ID"":""150"",""attrID"":""125313"",""valueText"":"""",""valueHtml"":"""",""Type"":""datagrid""},{""ID"":""150"",""attrID"":""74532"",""valueText"":"""",""valueHtml"":"""",""Type"":""datagrid"",""datagridvalue"":""78331""},{""ID"":""150"",""attrID"":""43"",""valueText"":"""",""valueHtml"":"""",""Type"":""datagrid"",""datagridvalue"":""78331""},{""ID"":""150"",""attrID"":""41"",""valueText"":"""",""valueHtml"":"""",""Type"":""datagrid"",""datagridvalue"":""78331""},{""ID"":""150"",""attrID"":""78005"",""valueText"":"""",""valueHtml"":"""",""Type"":""datagrid"",""datagridvalue"":""78331""},{""ID"":""150"",""attrID"":""42"",""valueText"":"""",""valueHtml"":"""",""Type"":""datagrid"",""datagridvalue"":""78331""},{""ID"":""150"",""attrID"":""39"",""valueText"":"""",""valueHtml"":"""",""Type"":""datagrid"",""datagridvalue"":""3924""},{""ID"":""150"",""attrID"":""47"",""valueText"":"""",""valueHtml"":"""",""Type"":""datagrid"",""datagridvalue"":""78331""},{""ID"":""150"",""attrID"":""78006"",""valueText"":"""",""valueHtml"":"""",""Type"":""datagrid"",""datagridvalue"":""78331""},{""ID"":""150"",""attrID"":""3909"",""valueText"":"""",""valueHtml"":"""",""Type"":""datagrid"",""datagridvalue"":""78331""},{""ID"":""150"",""attrID"":""77980"",""valueText"":"""",""valueHtml"":"""",""Type"":""datagrid"",""datagridvalue"":""78331""},{""ID"":""150"",""attrID"":""125315"",""valueText"":"""",""valueHtml"":"""",""Type"":""datagrid"",""datagridvalue"":""78331""},{""ID"":""150"",""attrID"":""3920"",""valueText"":"""",""valueHtml"":"""",""Type"":""datagrid"",""datagridvalue"":""78331""},{""ID"":""150"",""attrID"":""3934"",""valueText"":"""",""valueHtml"":"""",""Type"":""datagrid"",""datagridvalue"":""78331""},{""ID"":""150"",""attrID"":""4004"",""valueText"":"""",""valueHtml"":"""",""Type"":""datagrid"",""datagridvalue"":""78331""},{""ID"":""150"",""attrID"":""4126"",""valueText"":"""",""valueHtml"":"""",""Type"":""datagrid"",""datagridvalue"":""78331""},{""ID"":""150"",""attrID"":""4009"",""valueText"":"""",""valueHtml"":"""",""Type"":""datagrid"",""datagridvalue"":""78331""},{""ID"":""150"",""attrID"":""3941"",""valueText"":"""",""valueHtml"":"""",""Type"":""datagrid"",""datagridvalue"":""78331""},{""ID"":""150"",""attrID"":""78007"",""valueText"":"""",""valueHtml"":"""",""Type"":""datagrid"",""datagridvalue"":""78331""},{""ID"":""150"",""attrID"":""78008"",""valueText"":"""",""valueHtml"":"""",""Type"":""datagrid"",""datagridvalue"":""78331""},{""ID"":""150"",""attrID"":""78009"",""valueText"":"""",""valueHtml"":"""",""Type"":""datagrid"",""datagridvalue"":""78331""},{""ID"":""150"",""attrID"":""4134"",""valueText"":"""",""valueHtml"":"""",""Type"":""datagrid"",""datagridvalue"":""78331""},{""ID"":""150"",""attrID"":""3948"",""valueText"":"""",""valueHtml"":"""",""Type"":""datagrid"",""datagridvalue"":""78331""},{""ID"":""150"",""attrID"":""78010"",""valueText"":"""",""valueHtml"":"""",""Type"":""datagrid"",""datagridvalue"":""78331""},{""ID"":""150"",""attrID"":""14424"",""valueText"":"""",""valueHtml"":"""",""Type"":""datagrid"",""datagridvalue"":""78331""},{""ID"":""150"",""attrID"":""78004"",""valueText"":"""",""valueHtml"":"""",""Type"":""datagrid"",""datagridvalue"":""78331""},{""ID"":""150"",""attrID"":""77981"",""valueText"":"""",""valueHtml"":"""",""Type"":""datagrid"",""datagridvalue"":""78331""},{""ID"":""150"",""attrID"":""78011"",""valueText"":"""",""valueHtml"":"""",""Type"":""datagrid"",""datagridvalue"":""78331""},{""ID"":""150"",""attrID"":""26955"",""valueText"":"""",""valueHtml"":"""",""Type"":""datagrid"",""datagridvalue"":""78331""},{""ID"":""150"",""attrID"":""78012"",""valueText"":"""",""valueHtml"":"""",""Type"":""datagrid"",""datagridvalue"":""78331""},{""ID"":""150"",""attrID"":""78013"",""valueText"":"""",""valueHtml"":"""",""Type"":""datagrid"",""datagridvalue"":""78331""},{""ID"":""150"",""attrID"":""78014"",""valueText"":"""",""valueHtml"":"""",""Type"":""datagrid"",""datagridvalue"":""78331""},{""ID"":""150"",""attrID"":""78015"",""valueText"":"""",""valueHtml"":"""",""Type"":""datagrid"",""datagridvalue"":""78331""},{""ID"":""150"",""attrID"":""78206"",""valueText"":"""",""valueHtml"":"""",""Type"":""datagrid"",""datagridvalue"":""78331""},{""ID"":""150"",""attrID"":""78306"",""valueText"":"""",""valueHtml"":"""",""Type"":""datagrid"",""datagridvalue"":""78331""},{""ID"":""150"",""attrID"":""44"",""valueText"":"""",""valueHtml"":"""",""Type"":""datagrid"",""datagridvalue"":""78331""},{""ID"":""150"",""attrID"":""38"",""valueText"":"""",""valueHtml"":"""",""Type"":""datagrid"",""datagridvalue"":""78331""},{""ID"":""150"",""attrID"":""40"",""valueText"":"""",""valueHtml"":"""",""Type"":""datagrid"",""datagridvalue"":""78331""},{""ID"":""150"",""attrID"":""7879"",""valueText"":"""",""valueHtml"":"""",""Type"":""datagrid"",""datagridvalue"":""78331""},{""ID"":""150"",""attrID"":""8146"",""valueText"":"""",""valueHtml"":"""",""Type"":""datagrid"",""datagridvalue"":""78331""},{""ID"":""150"",""attrID"":""74527"",""valueText"":"""",""valueHtml"":"""",""Type"":""datagrid"",""datagridvalue"":""101356""},{""ID"":""150"",""attrID"":""81577"",""valueText"":"""",""valueHtml"":"""",""Type"":""datagrid"",""datagridvalue"":""101356""},{""ID"":""150"",""attrID"":""89777"",""valueText"":"""",""valueHtml"":"""",""Type"":""datagrid"",""datagridvalue"":""101356""},{""ID"":""150"",""attrID"":""94752"",""valueText"":"""",""valueHtml"":"""",""Type"":""datagrid"",""datagridvalue"":""101356""},{""ID"":""150"",""attrID"":""96119"",""valueText"":"""",""valueHtml"":"""",""Type"":""datagrid"",""datagridvalue"":""101356""},{""ID"":""150"",""attrID"":""96183"",""valueText"":"""",""valueHtml"":"""",""Type"":""datagrid"",""datagridvalue"":""101356""},{""ID"":""150"",""attrID"":""106661"",""valueText"":"""",""valueHtml"":"""",""Type"":""datagrid"",""datagridvalue"":""78331""},{""ID"":""150"",""attrID"":""110581"",""valueText"":"""",""valueHtml"":"""",""Type"":""datagrid"",""datagridvalue"":""78331""},{""ID"":""150"",""attrID"":""111062"",""valueText"":"""",""valueHtml"":"""",""Type"":""datagrid"",""datagridvalue"":""78331""},{""ID"":""150"",""attrID"":""111255"",""valueText"":"""",""valueHtml"":"""",""Type"":""datagrid"",""datagridvalue"":""78331""},{""ID"":""150"",""attrID"":""111366"",""valueText"":"""",""valueHtml"":"""",""Type"":""datagrid"",""datagridvalue"":""78331""},{""ID"":""150"",""attrID"":""111631"",""valueText"":"""",""valueHtml"":"""",""Type"":""datagrid"",""datagridvalue"":""78331""},{""ID"":""150"",""attrID"":""111632"",""valueText"":"""",""valueHtml"":"""",""Type"":""datagrid"",""datagridvalue"":""78331""},{""ID"":""150"",""attrID"":""119093"",""valueText"":"""",""valueHtml"":"""",""Type"":""datagrid"",""datagridvalue"":""78331""},{""ID"":""150"",""attrID"":""122922"",""valueText"":"""",""valueHtml"":"""",""Type"":""datagrid"",""datagridvalue"":""78331""},{""ID"":""150"",""attrID"":""123767"",""valueText"":"""",""valueHtml"":"""",""Type"":""datagrid"",""datagridvalue"":""78331""},{""ID"":""150"",""attrID"":""126574"",""valueText"":"""",""valueHtml"":"""",""Type"":""datagrid"",""datagridvalue"":""78331""},{""ID"":""150"",""attrID"":""126576"",""valueText"":"""",""valueHtml"":"""",""Type"":""datagrid"",""datagridvalue"":""78331""},{""ID"":""150"",""attrID"":""126734"",""valueText"":"""",""valueHtml"":"""",""Type"":""datagrid"",""datagridvalue"":""78331""},{""ID"":""150"",""attrID"":""130544"",""valueText"":"""",""valueHtml"":"""",""Type"":""datagrid"",""datagridvalue"":""78331""},{""ID"":""150"",""attrID"":""130545"",""valueText"":"""",""valueHtml"":"""",""Type"":""datagrid"",""datagridvalue"":""78331""},{""ID"":""150"",""attrID"":""130606"",""valueText"":"""",""valueHtml"":"""",""Type"":""datagrid"",""datagridvalue"":""78331""},{""ID"":""150"",""attrID"":""131753"",""valueText"":"""",""valueHtml"":"""",""Type"":""datagrid"",""datagridvalue"":""78331""},{""ID"":""150"",""attrID"":""134868"",""valueText"":"""",""valueHtml"":"""",""Type"":""datagrid"",""datagridvalue"":""78331""}]","","11863^6^1^291^2","222.132.155.206")
ClassMethod TinyDeal(ListData, Type, LoginInfo, ClientIPAddress)
{
	n (ListData,Type,LoginInfo,ClientIPAddress)
	s ^Tmpli=$lb(ListData,Type,LoginInfo,ClientIPAddress)
	s Err=0
	s json = ##class(%Library.DynamicObject).%FromJSON(ListData)
	;s ^shy=json
	s len = json.%Size()
	b ; //1
	f k=0:1:(len-1) d
	.s params = json.%Get(k).%ToJSON()
	.s obj = ##class(%Library.DynamicObject).%FromJSON(params)
	.s ID = obj.ID
	.s attrID = obj.attrID
	.s valueText = obj.valueText
	.s valueHtml = obj.valueHtml
	.s datagridvalue=obj.datagridvalue
	.s groupData=obj.groupData
	.s Type=obj.Type
	.s DicAttrId=""
	.s:Type="datagrid" DicAttrId=$o(^DHCCKBDLA(0,"LinkDicAttrCode",ID,attrID,""))
	.s list = DicAttrId_"^"_ ID _"^"_ attrID _"^"_ datagridvalue _"^"_ valueText _"^"_ "" _"^"_ "" _"^"_ valueHtml
	.i (attrID=39)||(attrID=74527)  d
	..s list=groupData
	.b ; //3
	.q:Err'=0
	.s Err= ##class(web.DHCCKBDicLinkAttr).saveDicAttrByType(list, Type, LoginInfo, ClientIPAddress)
	q Err
}

}
