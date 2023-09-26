Class DHCDoc.Util.QueryToJSON Extends %CSP.Page
{

Property rs As %ResultSet;

Property colCnt As %Integer;

ClassMethod OnPreHTTP() As %Boolean
{
    d ##Class(websys.SessionEvents).SessionExpired()
	Q 1
}

ClassMethod OnPage() As %Status [ ProcedureBlock = 0 ]
{
	s ClassName=$g(%request.Data("ClassName",1))
	s QueryName=$g(%request.Data("QueryName",1))
	s JSONTYPE=$g(%request.Data("JSONTYPE",1))
	s rows=$g(%request.Data("rows",1))
   	s page=$g(%request.Data("page",1))
   	k %request.Data("rows"),%request.Data("page")
   	s rs=##class(%ResultSet).%New(ClassName_":"_QueryName)
	for i=1:1:rs.GetParamCount(){
		s Args($I(Args))=$G(%request.Data(rs.GetParamName(i),1))
	}
	s obj=##class(DHCDoc.Util.QueryToJSON).%New(ClassName,QueryName,Args...)
	s retObj=""
	if JSONTYPE="Grid"{
		s retObj=obj.ToGrid(page,rows)
	}elseif(JSONTYPE="Combo"){
		s retObj=obj.ToArray()
	}elseif(JSONTYPE="Tree"){
		s TreeFieldStr=$g(%request.Data("TreeFieldStr",1))
		s idFieldStr=$g(%request.Data("idFieldStr",1))
		s iconClsStr=$g(%request.Data("iconClsStr",1))
		s ClosedStr=$g(%request.Data("ClosedStr",1))
		s retObj=obj.ToTree(TreeFieldStr,idFieldStr,iconClsStr,ClosedStr)
	}elseif(JSONTYPE="JQGRID"){
		s retObj=obj.ToJQGrid()
	}
	if $IsObject(retObj){
		s stream=##class(%Stream.GlobalCharacter).%New()
		d retObj.%ToJSON(.stream)
		d stream.OutputToDevice()
	}
	Quit $$$OK
}

Method %OnNew(ClassName, QueryName, arg...)
{
	s $this.rs=##class(%ResultSet).%New(ClassName_":"_QueryName)
	s $this.colCnt=$this.rs.GetColumnCount()
	d $this.rs.Execute(arg...)
	Q $this
}

Method GetRowData() As %DynamicObject
{
	s row={}
	for i=1:1:$this.colCnt{
		s field=$this.rs.GetColumnName(i)
		s data=$this.rs.GetData(i)
		s rsType=$this.rs.GetColumnType(i)
		s type=..GetType(rsType)
		d row.%Set(field,data,type)
	}
	Q row
}

/// 1.BINARY 2.DATE 3.DOUBLE 4.HANDLE 5.INTEGER 6.LIST 7.LONGVARCHAR 8.TIME 9.TIMESTAMP 10.VARCHAR 
/// 11.STATUS 12.BINARYSTREAM 13.CHARACTERSTREAM 14.NUMERIC 15.CURRENCY 16.BOOLEAN 17.OID 18.BIGINT 19.FDATE 20.FTIMESTAMP
Method GetType(rsType)
{
	Q:rsType=16 "boolean"
	Q:(rsType=3)||(rsType=14)||(rsType=18) "number"
	Q "string"
}

Method ToGrid(page = "", rows = "") As %DynamicObject
{
	s SttIndex="",EndIndex=""
	if (rows="")&&$D(%request) s rows=$G(%request.Data("rows",1))
	if (page="")&&$D(%request) s page=$G(%request.Data("page",1))
   	if (rows>0)&&(page>0){
		s SttIndex=rows*(page-1)+1
		s EndIndex=rows*page
	}
	s retObj={"rows":[],"total":0}
	Q:'$IsObject($this.rs) retObj
	while $this.rs.Next(){
		s retObj.total=retObj.total+1
		continue:((SttIndex'="")&&(retObj.total<SttIndex))||((EndIndex'="")&&(retObj.total>EndIndex))
		s row=..GetRowData()
		d retObj.rows.%Push(row)
	}
	Q retObj
}

Method ToJQGrid() As %DynamicObject
{
	s retObj={"page":1,"total":0,"records":0,"rows":[]}
	Q:'$IsObject($this.rs) retObj
	while $this.rs.Next(){
		s retObj.total=retObj.total+1
		s retObj.records=retObj.records+1
		s row=..GetRowData()
		d retObj.rows.%Push(row)
	}
	Q retObj
}

Method ToArray() As %DynamicArray
{
	s retObj=[]
	Q:'$IsObject($this.rs) retObj
	while $this.rs.Next(){
		s row=..GetRowData()
		d retObj.%Push(row)
	}
	Q retObj
}

Method ToTree(TreeFieldStr, idFieldStr, iconClsStr = "", ClosedStr = "") As %DynamicArray [ ProcedureBlock = 0 ]
{
	Q:'$IsObject($this.rs) []
	k TreeList
	s idFieldLen=$L(idFieldStr,"^")
	while $this.rs.Next(){
		s NodeStr="",idFieldValue=""
		f i=1:1:idFieldLen{
			s obj={}
			s idField=$P(idFieldStr,"^",i),TreeField=$P(TreeFieldStr,"^",i)
			s iconCls=$P(iconClsStr,"^",i),Closed=$P(ClosedStr,"^",i)
			s idVale=$this.rs.GetDataByName(idField)
			s TreeFieldValue=$this.rs.GetDataByName(TreeField)
			s $P(idFieldValue,"_",i)=idVale
			s obj.id=idFieldValue,obj.text=TreeFieldValue
			if iconCls'="" s obj.iconCls=iconCls
			i NodeStr="" s NodeStr=""""_idVale_""""
			e  s NodeStr=NodeStr_","""_idVale_""""
			if i<idFieldLen{
				i Closed s obj.state="closed"
			}else{
				s obj=..GetRowData()
			}
			x "s TreeList("_NodeStr_")=obj"
		}
	}
	Q ..ListToTreeJson(.TreeList)
}

ClassMethod ListToTreeJson(TreeList) As %DynamicArray
{
	s retObj=[]
	s SelfNod=$O(TreeList(""))
	if SelfNod'=""{
		m ParList=TreeList
		m ChildList=TreeList(SelfNod)
		s retObj=..RecurTreeJSON(.ChildList,SelfNod,.ParList)
	}
	Q retObj
}

ClassMethod RecurTreeJSON(ChildList, SelfNod, ParList) As %DynamicArray
{
	s retObj=[]
	Q:SelfNod="" retObj
 	s selfObj=$G(ParList(SelfNod))
 	s nod=$O(ChildList(""))	
 	i nod'="" d		
 	.m self=ChildList(nod)
 	.s selfObj.children=..RecurTreeJSON(.self,nod,.ChildList)
 	i $IsObject(selfObj) d retObj.%Push(selfObj)
 	
 	s nod=$O(ParList(SelfNod))	
 	i nod'="" d
 	.k self
 	.m self=ParList(nod)
 	.s broRet=..RecurTreeJSON(.self,nod,.ParList)
 	.f i=1:1:broRet.%Size() d retObj.%Push(broRet.%Get(i-1))
 	Q retObj
}

}
