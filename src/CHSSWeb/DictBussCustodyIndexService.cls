Class CHSSWeb.DictBussCustodyIndexService Extends %Persistent [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod List(Start, Limit, id)
{
	q:(id=""||id=0) "[]"
	Set start=$G(Start)
	Set limit=$G(Limit)
	Set count=1
	Set resultString = ""
	Set end = start+limit
	 
	 
	Set json = ##class(Code.JsonObj).%New()
	 S kid =id
	 s DictRecord=##class(CHSS.DictBussCustodyIndex).%OpenId(kid)
	 
	 s RowId =DictRecord.%Id()
	 s RowIdParref =DictRecord.RowIdParref
	 s IndexCode = DictRecord.IndexCode
	 s IndexName = DictRecord.IndexName
	 s IndexProportion =DictRecord.IndexProportion
	 s IndexContent = DictRecord.IndexContent
	 s bValid = DictRecord.bValid
	 s Remark =DictRecord.Remark
     s tmp=RowId_"^"_RowIdParref_"^"_IndexCode_"^"_IndexName_"^"_IndexProportion_"^"_IndexContent_"^"_bValid_"^"_Remark
	 d json.InsertRowData(tmp)
     s resultString = json.getJsonData("RowId^RowIdParref^IndexCode^IndexName^IndexProportion^IndexContent^bValid^Remark",count)
     k json	
	 Quit resultString
}

ClassMethod Listtt(Start, Limit)
{
	
	Set start=$G(Start)
	Set limit=$G(Limit)
	Set count=0
	Set resultString = ""
	Set end = start+limit
	 
	 
	Set json = ##class(Code.JsonObj).%New()
	 S kid =0
	 For  Set kid=$O(^CHSS.DictBussCustodyIndexD(kid)) q:kid=""  d
	 .s DictRecord=##class(CHSS.DictBussCustodyIndex).%OpenId(kid) 
	 .s rowid = DictRecord.%Id()
		.s indexname=DictRecord.IndexName
		.s count=count+1
		.s par=DictRecord.RowIdParref
	    .s leaf=DictRecord.Leaf
     .s tmp=rowid_"^"_indexname_"^"_par_"^"_leaf
	 .d json.InsertRowData(tmp)
     s resultString =json.getTreeJsonData("_id^_text^_parent^_leaf",count)
     k json	
	 Quit resultString
}

ClassMethod getLeafFalse(id)
{
    s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select RowId,IndexName  from CHSS.DictBussCustodyIndex where RowIdParref="_id_" and leaf='false'"
	d result.Prepare(sqlStr)
	d result.Execute()
	q:(result="") "[]"
	s resultString = ""
	s json = ##class(Code.JsonObj).%New()
	While(result.Next())
	{
		s rowid = result.Data("RowId")
		s indexname=result.Data("IndexName")
		s tmp=rowid_"^"_indexname
		d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getTreeJsonData("id^text")
    k json
	q resultString
}

ClassMethod getChildren11(id, start, limit)
{
	
 
	if id="tge-root" d
	.s id=0
	Set start=$G(Start)
	Set limit=$G(Limit)
	Set count=0
	Set end = start+limit
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select RowId,RowIdParref,IndexName,IndexCode,IndexProportion,IndexContent,bValid,Remark,Leaf  from CHSS.DictBussCustodyIndex where RowIdParref="_id_""
	d result.Prepare(sqlStr)
	d result.Execute()
	q:(result="") "[]"
	
	
	s resultString = ""
	s json = ##class(Code.JsonObj).%New()
	While(result.Next())
	{
		s rowid = result.Data("RowId")
		s RowIdParref =result.Data("RowIdParref")
		s indexname=result.Data("IndexName")
		s IndexCode=result.Data("IndexCode")
		s IndexProportion=result.Data("IndexProportion")
		s IndexContent =result.Data("IndexContent")
		s bValid=result.Data("bValid")
		s Remark=result.Data("Remark")
		s Leaf=result.Data("Leaf")
		s checked="false"
		
	    s tmp=rowid_"^"_RowIdParref_"^"_indexname_"^"_IndexCode_"^"_IndexProportion_"^"_IndexContent_"^"_bValid_"^"_Remark_"^"_Leaf_"^"_checked
	    d json.InsertRowData(tmp)
	    s count=count+1
	}
	d result.Close()
	s resultString = json.getTreeJsonData("id^parentId^indexname^IndexCode^IndexProportion^IndexContent^bValid^Remark^leaf")
	k json
	q resultString
		 ;q "[{id:'226',parentId:'0',indexname:'123',IndexCode:'123',IndexProportion:'',IndexContent:'123',bValid:'0',Remark:'23',leaf:true,checked:false}]"
}

ClassMethod save(IndexCode, IndexName, IndexProportion, bValid, IndexContent, Remark, parentId)
{
	i parentId="tge-root" d 
	.s parentId=0
	w parentId,!
	
	s DictRecord=##class(CHSS.DictBussCustodyIndex).%OpenId(parentId)
	s tempMode=##class(CHSS.DictBussCustodyIndex).%New()
	if (DictRecord'="") d
	.s DictRecord.Leaf="false"
	.s a=DictRecord.%Save()
	
	s tempMode.Leaf="true"
	s tempMode.IndexCode=IndexCode
	s tempMode.IndexName=IndexName
	s tempMode.IndexProportion=IndexProportion
	s tempMode.bValid=bValid
	s tempMode.IndexContent=IndexContent
	s tempMode.Remark=Remark
	s tempMode.RowIdParref=parentId
	s result=""
    s result=tempMode.%Save()
  
    Set resultString = ""
    i result = "1" d
    .s resultString = "{""success"":""true"",""info"":"_tempMode.%Id()_"}"
    e  d
    .s resultString = "{""success"":""false"",""info"":""数据保存出错!""}"
    q resultString
}

ClassMethod update(iid, IndexCode, IndexName, IndexProportion, bValid, IndexContent, Remark, parentId)
{
	w iid,!
	w parentId,!
	s tempMode=##class(CHSS.DictBussCustodyIndex).%OpenId(iid)
	
	s tempMode.IndexCode=IndexCode
	s tempMode.IndexName=IndexName
	s tempMode.IndexProportion=IndexProportion
	s tempMode.bValid=bValid
	s tempMode.IndexContent=IndexContent
	s tempMode.Remark=Remark
	s result=""
    s result=tempMode.%Save()
  
    Set resultString = ""
    i result = "1" d
    .s resultString = "{""success"":""true"",""info"":"_tempMode.%Id()_"}"
    e  d
    .s resultString = "{""success"":""false"",""info"":""数据保存出错!""}"
    q resultString
}

ClassMethod Delete(RowId)
{
	s tempMode=""
	s result=""
	s resultString=""
	i RowId '="" d
	.s tempMode=##class(CHSS.DictBussCustodyIndex).%OpenId(RowId)
	.s result=tempMode.%DeleteId(RowId)
	.s pid=tempMode.RowIdParref
	.w pid,!
	.s precord =##class(CHSS.DictBussCustodyIndex).%OpenId(pid)
	.w ..getChildren11(pid,0,100),!
	.i ..getChildren11(pid,0,100)="[]" d 
	..s precord.Leaf="true"
	..s a =precord.%Save()

	i result="1" d
	. s resultString="{""success"":""true"",""info"":""数据删除成功!""}"
    e  d
    .s resultString = "{""success"":""false"",""info"":""数据删除出错!""}"
    q resultString
}

ClassMethod ListParent()
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select RowId,IndexName,leaf  from CHSS.DictBussCustodyIndex where RowIdParref is null"
	d result.Prepare(sqlStr)
	d result.Execute()
	q:(result="") "[]"
	s count = 0
	s leaf = "false"
	s resultString = ""
	s json = ##class(Code.JsonObj).%New()
	While(result.Next())
	{
		s rowid = result.Data("RowId")
		s indexname=result.Data("IndexName")
		s leaf="false"
		s tmp=rowid_"^"_indexname_"^"_leaf

	d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getTreeJsonData("id^text^leaf",count)
	k json
	q resultString
}

Storage Default
{
<Data name="DictBussCustodyIndexServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.DictBussCustAD5D</DataLocation>
<DefaultData>DictBussCustodyIndexServiceDefaultData</DefaultData>
<IdLocation>^CHSSWeb.DictBussCustAD5D</IdLocation>
<IndexLocation>^CHSSWeb.DictBussCustAD5I</IndexLocation>
<StreamLocation>^CHSSWeb.DictBussCustAD5S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
