/// d ##class(DHCWL.BaseDataQuery.RptItem).%BuildIndices()
Class DHCWL.BaseDataQuery.RptItem Extends %Persistent
{

/// 报表引用
Property RptDr As Rpt;

/// 编码
Property Code As %String(COLLATION = "EXACT");

/// 名称
Property Name As %String(COLLATION = "EXACT");

/// 描述
Property Descript As %String(COLLATION = "EXACT");

/// 类型，包括：col:报表列;row:报表列;filter:过滤;order:排序queryconf:查询条件;
Property Type As %String(COLLATION = "EXACT");

/// 表达式，用于保存过滤和排序
Property Exp As %String(COLLATION = "EXACT", MAXLEN = 150);

// Property QryItemDr As QryItem;

Index InxType On (RptDr, Type);

Index InxRpt On RptDr;

/// 查询项引用
ClassMethod Insert(ByRef inParam, ByRef outParam) As %String
{
	s $zt="SQLErr"
	s ret=""	
	s RptObj=##class(Rpt).GetById(inParam("ROWID"))
	
	s aryItems("col")=inParam("colStr")
	//s aryItems("row")=inParam("filterStr")
	s aryItems("filter")=inParam("filterStr")
	s aryItems("order")=inParam("orderStr")
	s aryItems("queryconf")=inParam("querycondStr")
	s aryItems("row")=inParam("rowStr")
	s aryItems("cross")=inParam("crossStr")	
	s itemType=""
	f {
		s itemType=$o(aryItems(itemType))
		q:itemType=""
		s items=aryItems(itemType)
		if items="" continue
		s recordCnt=$l(items,$C(2))
		f i=1:1:recordCnt {
			s rec=$p(items,$C(2),i)
			s fieldCnt=$l(rec,"^")
			if fieldCnt="" continue
			k ^||DHCWLTEMP("RPTITEM","field")
			f j=1:1:fieldCnt {
				s field=$p(rec,"^",j)
				s fName=$p(field,":",1)
				s fValue=$p(field,":",2)
				S ^||DHCWLTEMP("RPTITEM","field",fName)=fValue
			}
			if $d(^||DHCWLTEMP("RPTITEM","field")) {
				s ItemObj=##class(RptItem).%New()
				s ItemObj.RptDr=RptObj
				s ItemObj.Code=^||DHCWLTEMP("RPTITEM","field","Code")
				s ItemObj.Name=^||DHCWLTEMP("RPTITEM","field","Name")
				s ItemObj.Descript=$g(^||DHCWLTEMP("RPTITEM","field","Descript"))
				s ItemObj.Type=itemType
				if itemType="filter" {
					s ItemObj.Exp="logical:"_^||DHCWLTEMP("RPTITEM","field","logical")_"^Relational:"_^||DHCWLTEMP("RPTITEM","field","Relational")
					s ItemObj.Exp=ItemObj.Exp_"^V1:"_^||DHCWLTEMP("RPTITEM","field","V1")_"^V2:"_^||DHCWLTEMP("RPTITEM","field","V2")
				}elseif itemType="order" {
					s ItemObj.Exp="Type:"_^||DHCWLTEMP("RPTITEM","field","Type")
				}
				s sc=ItemObj.%Save()
				If $$$ISERR(sc) {
					s ret="新建报表项失败:"_$System.Status.GetErrorText(sc)
					q
			 	}
			 	
			 	//插入显示格式
			 	if itemType="cross" || (itemType="col") {
				 	if $d(^||DHCWLTEMP("RPTITEM","field","Format")) && (^||DHCWLTEMP("RPTITEM","field","Format")'="") {
						s formatObj=##class(RItemFm).%New()
						s formatObj.ItemDr=ItemObj
						s formatObj.Format=^||DHCWLTEMP("RPTITEM","field","Format")
						s sc=formatObj.%Save()
						If $$$ISERR(sc) {
							s ret="新建显示格式失败:"_$System.Status.GetErrorText(sc)
							q
					 	}
					 	d formatObj.%Close()				 	
					 }
				}
				
			 	d ItemObj.%Close()
			}
			
		}
		
	}

	q ret

SQLErr
	if ret="" s ret="新建报表项失败:"_$ZERROR
	q ret
}

ClassMethod DelByRptID(rptID As %String) As %String
{
	s $zt="SQLErr"
	s ret=""	

	&sql(DELETE FROM DHCWL_BaseDataQuery.RptItem WHERE RptDr=:rptID)
	
	if SQLCODE'=0 && (SQLCODE'=100) s ret="删除报表项失败，SQLCODE DESC="_$SYSTEM.SQL.SQLCODE(SQLCODE)
	q ret

SQLErr
	if ret="" s ret="新建报表项失败:"_$ZERROR
	q ret
}

/// s list=##class(DHCWL.BaseDataQuery.QryItem).GetItemss(1,"col")
/// Index InxType On (RptDr, Type);
ClassMethod GetItemsByType(RptID As %String, type As %String) As %ListOfObjects
{
	s list=##class(%ListOfObjects).%New()
	
	q:RptID="" list
	q:'$d(^DHCWL.BaseDataQuery.RptItemI("InxType",RptID)) list
	q:'$d(^DHCWL.BaseDataQuery.RptItemI("InxType",RptID,type)) list
	s id=""
	f{
	  s id=$o(^DHCWL.BaseDataQuery.RptItemI("InxType",RptID,type,id))
	  q:id=""
	  s obj=##class(RptItem).%OpenId(id)
	  continue:obj=""
	  d list.Insert(obj)
	}	
	q list
}

ClassMethod GetItems(RptID As %String) As %ListOfObjects
{
	s list=##class(%ListOfObjects).%New()
	
	q:RptID="" list
	q:'$d(^DHCWL.BaseDataQuery.RptItemI("InxRpt",RptID)) list

	s id=""
	f{
	  s id=$o(^DHCWL.BaseDataQuery.RptItemI("InxRpt",RptID,id))
	  q:id=""
	  s obj=##class(RptItem).%OpenId(id)
	  continue:obj=""
	  d list.Insert(obj)
	}	
	q list
}

Trigger DelFormat [ Event = DELETE, Time = AFTER ]
{
	s itemID={ID}
	&sql(delete from DHCWL_BaseDataQuery.RItemFm where ItemDr=:itemID )
}

Storage Default
{
<Data name="RptItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RptDr</Value>
</Value>
<Value name="3">
<Value>Code</Value>
</Value>
<Value name="4">
<Value>Name</Value>
</Value>
<Value name="5">
<Value>Descript</Value>
</Value>
<Value name="6">
<Value>QryItemDr</Value>
</Value>
<Value name="7">
<Value>Type</Value>
</Value>
<Value name="8">
<Value>Exp</Value>
</Value>
</Data>
<DataLocation>^DHCWL.BaseDataQuery.RptItemD</DataLocation>
<DefaultData>RptItemDefaultData</DefaultData>
<IdLocation>^DHCWL.BaseDataQuery.RptItemD</IdLocation>
<IndexLocation>^DHCWL.BaseDataQuery.RptItemI</IndexLocation>
<StreamLocation>^DHCWL.BaseDataQuery.RptItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
