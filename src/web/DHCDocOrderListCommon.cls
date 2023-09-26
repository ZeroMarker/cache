Import SQLUser

Class web.DHCDocOrderListCommon Extends DHCDoc.Util.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod GetOrderListSetClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOrderListSetExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetOrderListSetExecute(ByRef qHandle As %Binary, DOGRowId As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s desc="",rowid="",mrdesc=""
	i DOGRowId="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s OPRowId=$p(DOGRowId,"||",1)
	s child=$p(DOGRowId,"||",2)
	s Rowid=0
 	f  s Rowid=$o(^DHCDocOLS(OPRowId,child,Rowid)) q:Rowid=""  d
 	.s Code=$p($g(^DHCDocOLS(OPRowId,child,Rowid)),"^",1)
 	.s Desc=$p($g(^DHCDocOLS(OPRowId,child,Rowid)),"^",2)
 	.s Desc=##class(websys.Translation).Get("oeorder.oplistcustom.new.csp",Desc)
 	.s expression=$p($g(^DHCDocOLS(OPRowId,child,Rowid)),"^",3)
 	.s colwidth=$p($g(^DHCDocOLS(OPRowId,child,Rowid)),"^",4)
 	.s hidden=$p($g(^DHCDocOLS(OPRowId,child,Rowid)),"^",5)
 	.d OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(OPRowId_"||"_child_"||"_Rowid,Code,Desc,expression,colwidth,hidden)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod GetOrderListSetFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOrderListSetExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {			// if there are no more rows, finish fetching
	 Set AtEnd=1
	 Set Row=""
	}
	Else {				// fetch row
	 Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCDocOrderListCommon","GetOrderListSet")
Query GetOrderListSet(DOGRowId) As %Library.Query(CONTAINID = 0, ROWSPEC = "rowid:%String,code:%String,desc:%String,expression:%String,colwidth:%String,hidden:%String") [ SqlProc ]
{
}

ClassMethod GetOrderPageClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOrderPageExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetOrderPageExecute(ByRef qHandle As %Binary, FindCode, FindDesc) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s desc="",rowid="",mrdesc=""
	s Rowid=0
 	f  s Rowid=$o(^DHCDocOP(Rowid)) q:Rowid=""  d
 	.s Code=$p($g(^DHCDocOP(Rowid)),"^",1)
 	.q:$ZCVT(Code,"U")'[$ZCVT(FindCode,"U")
 	.s Desc=$p($g(^DHCDocOP(Rowid)),"^",2)
 	.q:$ZCVT(Desc,"U")'[$ZCVT(FindDesc,"U")
 	.s DOPProductLine=$p($g(^DHCDocOP(Rowid)),"^",3)
 	.Q:DOPProductLine'=""
 	.s Desc=##class(websys.Translation).Get("oeorder.oplistcustom.new.csp",Desc)
 	.d OutputRow1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(Rowid,Code,Desc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod GetOrderPageFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOrderPageExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {			// if there are no more rows, finish fetching
	 Set AtEnd=1
	 Set Row=""
	}
	Else {				// fetch row
	 Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCDocOrderListCommon","GetOrderPage")
Query GetOrderPage(FindCode, FindDesc) As %Library.Query(CONTAINID = 0, ROWSPEC = "rowid:%String,code:%String,desc:%String") [ SqlProc ]
{
}

// d ##class()

ClassMethod Add(DOGRowId As %String, code As %String, desc As %String, colwidth As %String, hidden As %String, expression As %String) As %String
{
	q:DOGRowId="" "-1^未选择页面"
	q:$d(^DHCDocOLSi("Code",0,code,+DOGRowId,$p(DOGRowId,"||",2))) "-1^已经存在相同代码"
	&sql(insert into SQLUser.DHC_DocOrderListSet (OLS_DOG_ParRef,OLS_Code,OLS_Desc,OLS_Expression,OLS_ColWidth,OLS_Hidden) values (:DOGRowId,:code,:desc,:expression,:colwidth,:hidden))
	q SQLCODE
}

// w ##class(web.DHCDocOrderListCommon).Del(2)

ClassMethod Del(IDs As %String) As %String
{
	s ^zzy("Del")=IDs
	q:IDs="" 0
	s ret=0
	f i=1:1:$length(IDs){
		s RowId=$p(IDs,"^",i)
		if (RowId'=""){
			&sql(delete from SQLUser.DHC_DocOrderListSet where OLS_RowID=:RowId)
		}
		s ret=ret+SQLCODE
	}
	q ret
}

ClassMethod Update(RowId As %String, code As %String, desc As %String, colwidth As %String, hidden As %String, expression As %String) As %String
{
	;s ^zzy("Del")=IDs
	q:RowId="" 0
	;判断是否需要更新
	q:$p(^DHCDocOLS(+RowId,$p(RowId,"||",2),$p(RowId,"||",3)),"^",1,5)=code_"^"_desc_"^"_colwidth_"^"_expression_"^"_hidden 0
	q:RowId="" 1
	&sql(update  SQLUser.DHC_DocOrderListSet set OLS_Code=:code,OLS_Desc=:desc,OLS_Expression=:expression,OLS_ColWidth=:colwidth,OLS_Hidden=:hidden where OLS_RowID=:RowId)
	q SQLCODE
}

/// creator:郭荣勇
/// date:	2014-03-31
/// input:	
/// return:	
/// desc:   根据列头设置得到医嘱录入的表格配置对象
/// d ##class(web.DHCDocOrderListCommon).ReadListColSet()
ClassMethod ReadListColSet(classname As %String, classmethod As %String, ByRef colNames As %String, ByRef colModelAry As %String, ByRef ParamAry As %String, context As %String) As %String
{
	q:(classname="")||(classmethod="") ""
	n (%session,classname,classmethod,colNames,colModelAry,ParamAry,context)
	;s LookupListComponetId = $o(^websys.ComponentI("UniqueNameIndex","WEBSYSLOOKUPLIST",0))
	s context="K"_classname_"."_classmethod_"."_context
	
	s SessionStr=""
	
	i %session,$d(%session.Data) {
		s SessionStr=%session.Get("LOGON.SITECODE")_"^"_%session.Get("LOGON.USERID")
		s SessionStr=SessionStr_"^"_%session.Get("LOGON.GROUPID")_"^"_%session.Get("LOGON.CTLOCID")
		s SessionStr=SessionStr_"^"_%session.Get("CONTEXT")_"^"_%session.Get("LOGON.WARDID")
		s SessionStr=SessionStr_"^"_%session.Get("LOGON.HOSPID")_"^"_%session.Get("LOGON.LANGID")
	}
	
	k ConfigAry
	d ##class(web.DHCDocOrderListCommon).GetListColSet(.ConfigAry)
	k SortQueue			
	s uSet=""
	if (($g(%session)'="")&&($g(%session.Data("LOGON.USERID"))'="")) d
	.;s uSet=##class(websys.Preferences).GetDataExLE(1,1,"","",context,"COLUMNS","websys.LookUp.List",.app,.appid,.activecontext,"","")
	.s uSet=##Class(websys.Preferences).GetDataExLE($g(%session.Data("LOGON.USERID")),$g(%session.Data("LOGON.GROUPID")),$g(%session.Data("LOGON.HOSPID")),$g(%session.Data("LOGON.SITECODE")),context,"COLUMNS","websys.LookUp.List",.app,.appid,.activecontext,$g(%session.Data("LOGON.TRUSTID")),$g(%session.Data("LOGON.REGION")))
	.;不能改顺序,影响前台取值
	.f idx=1:1:$l(uSet,"|") d
	..s uSetItem = $p(uSet,"|",idx)
	..s myIdx = $p(uSetItem,",",1)		;col-index,width,sort|
	..s:myIdx>0 SortQueue(myIdx,idx)=1,hiddenPlist(myIdx)=1,hiddenPlist(myIdx,2)=$p(uSetItem,",",2),hiddenPlist(myIdx,3)=$p(uSetItem,",",3)	
	.s rowsSet=##Class(websys.Preferences).GetDataExLE($g(%session.Data("LOGON.USERID")),$g(%session.Data("LOGON.GROUPID")),$g(%session.Data("LOGON.HOSPID")),$g(%session.Data("LOGON.SITECODE")),context,"ROWS","websys.LookUp.List",.app,.appid,.activecontext,$g(%session.Data("LOGON.TRUSTID")),$g(%session.Data("LOGON.REGION")))
	.s pageSize=$lg(rowsSet,1)
	s ^tmphiddenPlist=uSet
	;排序,所有隐藏列排在后面,显示列按设置显示
	;SortConfigAry为临时排序数组,Loop为原ConfigAry数组计数器,不会重复;所以只要取到Loop可以直接使用ConfigAry(Loop)取值
	k SortConfigAry
	i uSet'="" {
		s Loop=0
		for {
			s Loop=$O(ConfigAry(Loop)) Q:Loop=""
			i $g(hiddenPlist(Loop))="" {
				//2014-04-15
				s SortConfigAry(999,Loop)=$g(ConfigAry(Loop))
			}else{
				s SortNum=$o(SortQueue(Loop,0))
				s SortConfigAry(+SortNum,Loop)=$g(ConfigAry(Loop))
			} 
		}
	}
	s SortNum=""
	for {
		s SortNum=$O(SortConfigAry(SortNum)) Q:SortNum=""
		s Loop=0
		for {
			s Loop=$O(SortConfigAry(SortNum,Loop)) Q:Loop=""
			s OneItem=$g(ConfigAry(Loop))
			s name=$p(OneItem,"^",1)
			s cap=$p(OneItem,"^",2)
			s col=$p(OneItem,"^",3)
			s wid=$p(OneItem,"^",4)
			s isHidden=$p(OneItem,"^",5)
			i (isHidden="Y")||(cap="") s cap=name
			s sort=$p(OneItem,"^",6)
			s expression=$p(OneItem,"^",7)
			i '$d(colNames) {
				s colNames=cap
			}else{
				s colNames=colNames_","_cap
			}
			i (uSet'=""),$g(hiddenPlist(Loop))="" s isHidden="Y"
		
			;转换
			i isHidden="Y" s isHidden="true"
			e  s isHidden="false"
			;多语言转换
			/*s CurLangID=$p(SessionStr,"^",8)
			i CurLangID'="",$p($g(^SS("LAN",CurLangID)),"^",2)'="Chinese" {
				s cap=##class(web.DHCDocUtil).GetTranslatedStr(CurLangID,cap)
			}*/
		
			k ColCFAry
			s ColCFAry("name")=name
			s ColCFAry("cap")=cap
			s ColCFAry("col")=col
			s ColCFAry("wid")=wid
			s ColCFAry("isHidden")=isHidden
			s ColCFAry("sort")=sort
			s ClassName=$p(expression,".",1,$l(expression,".")-1)
			s MethodName=$p(expression,".",$l(expression,"."))
			s colModelAry(cap)="{}"
			s ExpStr=""
			i $d(ParamAry(name)) s ExpStr=$g(ParamAry(name))
			i ClassName'="" {
				
				;判断方法是否存在
				s CLSObj=##class(%Dictionary.ClassDefinition).%OpenId(ClassName)
				if $IsObject(CLSObj) {
					s ^peng("111")=333
					if $d(^oddDEF(CLSObj.%Id(),"m",MethodName)) {
						s colModelAry(cap)=$CLASSMETHOD(ClassName,MethodName,SessionStr,.ColCFAry,ExpStr)
					}
				}
			}
		}
	}

	q
}

/// creator:郭荣勇
/// date:	2014-04-01
/// input:	需要返回的数组指针
/// return:	数组指针
/// desc:   获取医嘱录入列设置,提供给双击列多弹出的设置页面
/// d ##class(web.DHCDocOrderListCommon).GetListColSet()
ClassMethod GetListColSet(ByRef ConfigAry As %String)
{
	n (ConfigAry,%session)
	s Count=0
	s DOGRowId=""
	s child=""
	s DOPRowID=$o(^DHCDocOGi("Code","UDHCOEOrderListCustom",0))
	i DOPRowID'="" s child=$o(^DHCDocOGi("Code","UDHCOEOrderListCustom",DOPRowID,0))
	i child'="" s DOGRowId=DOPRowID_"||"_child
	Set rset=##Class(%ResultSet).%New("web.DHCDocOrderListCommon:GetOrderListSet")
	If rset.QueryIsValid() { 
		Set Status=rset.Execute(DOGRowId)
		If 'Status Quit
		While (rset.Next()) {
			s rowid=rset.GetDataByName("rowid")
		    s code=rset.GetDataByName("code")
		    s desc=rset.GetDataByName("desc")
		    s expression=rset.GetDataByName("expression")
		    s colwidth=rset.GetDataByName("colwidth")
		    s hidden=rset.GetDataByName("hidden")
		    s sort=0
		    s Count=Count+1
		    s ConfigAry(Count)=code_"^"_desc_"^"_Count_"^"_colwidth_"^"_hidden_"^"_sort_"^"_expression
		    ;w ConfigAry(Count),!
		}
		d rset.Close()
	}
	q
}

/// creator:郭荣勇
/// date:	2014-05-08
/// input:	页面名称
/// return:	
/// desc:   初始化页面提示消息数组
/// d ##class(web.DHCDocOrderListCommon).GetMessageArray("oeorder.oplistcustom.new.csp",1)
ClassMethod GetMessageArray(PageName As %String, CurLangID As %String)
{
	q:PageName=""
	s PageNameRowId=$O(^DHCDocOPi("Code",0,PageName,0))
	;兼容不带后缀的
	i (PageNameRowId="") s PageNameRowId=$O(^DHCDocOPi("Code",0,$p(PageName,".csp",1,$l(PageName,".csp")-1),0))
	q:PageNameRowId=""
	i CurLangID="" s CurLangID=%session.Get("LOGON.LANGID")
	w "var t=new Array();",!
	s RowID=0
	for {
		s RowID=$O(^DHCDocOM(PageNameRowId,RowID)) Q:RowID=""
		s Code=$p($g(^DHCDocOM(PageNameRowId,RowID)),"^",1)
		q:Code=""
		s Desc=$p($g(^DHCDocOM(PageNameRowId,RowID)),"^",2)
		s OtherDesc=$p($g(^DHCDocOM(PageNameRowId,RowID)),"^",3)
		s LanCode=$p($g(^SS("LAN",CurLangID)),"^",1)
		if LanCode="EN" {
			i OtherDesc'="" w "t['"_Code_"']='"_OtherDesc_"';"
			e  w "t['"_Code_"']='"_##class(web.DHCDocUtil).GetTranslatedStr(CurLangID,Desc)_"';",!
		}else{
			w "t['"_Code_"']='"_##class(web.DHCDocUtil).GetTranslatedStr(CurLangID,Desc)_"';",!
		}
	}
	q
}

/// creater:zzy 
/// date:2014-04-23
/// desc:修改页面
ClassMethod UpdatePage(id As %String, code As %String, desc As %String) As %String
{
	;s ^zzy("Add")=code_"^"_desc_"^"_colwidth_"^"_hidden_"^"_expression
    q:((id="")&&($d(^DHCDocOPi("Code",0,code)))) "-1^已经存在相同代码"
	i id="" {
	  &sql(insert into SQLUser.DHC_DocOrderPage set DOP_Code=:code,DOP_Desc=:desc)
	}else {
		&sql(Update  SQLUser.DHC_DocOrderPage  set DOP_Code=:code,DOP_Desc=:desc where DOP_RowId=:id)
	}
	q SQLCODE
}

/// creater:zzy 
/// date:2014-04-23
/// desc:删除页面
ClassMethod DelPage(IDs As %String) As %String
{
	q:IDs="" 0
	s ret=0
	f i=1:1:$length(IDs){
		s RowId=$p(IDs,"^",i)
		if (RowId'=""){
			&sql(delete from SQLUser.DHC_DocOrderPage where DOP_RowID=:RowId)
		}
		s ret=ret+SQLCODE
	}
	q ret
}

ClassMethod GetOrderGridClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOrderGridExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetOrderGridExecute(ByRef qHandle As %Binary, DOPRowId) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s desc="",rowid="",mrdesc=""
	i DOPRowId="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s Rowid=0
 	f  s Rowid=$o(^DHCDocOG(DOPRowId,Rowid)) q:Rowid=""  d
 	.s Code=$p($g(^DHCDocOG(DOPRowId,Rowid)),"^",1)
 	.s Desc=$p($g(^DHCDocOG(DOPRowId,Rowid)),"^",2)
 	.s type=$p($g(^DHCDocOG(DOPRowId,Rowid)),"^",3)
 	.d OutputRow2
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow2
	set Data=$lb(DOPRowId_"||"_Rowid,Code,Desc,type)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod GetOrderGridFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOrderGridExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {			// if there are no more rows, finish fetching
	 Set AtEnd=1
	 Set Row=""
	}
	Else {				// fetch row
	 Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCDocOrderListCommon","GetOrderGrid",1)
Query GetOrderGrid(DOPRowId) As %Library.Query(CONTAINID = 0, ROWSPEC = "rowid:%String,code:%String,desc:%String,type:%String") [ SqlProc ]
{
}

ClassMethod GetOrderMessageClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOrderMessageExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetOrderMessageExecute(ByRef qHandle As %Binary, DOPRowId) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s desc="",rowid="",mrdesc=""
	i DOPRowId="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s Rowid=0
 	f  s Rowid=$o(^DHCDocOM(DOPRowId,Rowid)) q:Rowid=""  d
 	.s Code=$p($g(^DHCDocOM(DOPRowId,Rowid)),"^",1)
 	.s Desc=$p($g(^DHCDocOM(DOPRowId,Rowid)),"^",2)
 	.s type=$p($g(^DHCDocOM(DOPRowId,Rowid)),"^",3)
 	.d OutputRow4
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow4
	set Data=$lb(DOPRowId_"||"_Rowid,Code,Desc,type)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod GetOrderMessageFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOrderMessageExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {			// if there are no more rows, finish fetching
	 Set AtEnd=1
	 Set Row=""
	}
	Else {				// fetch row
	 Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCDocOrderListCommon","GetOrderMessage",1)
Query GetOrderMessage(DOPRowId) As %Library.Query(CONTAINID = 0, ROWSPEC = "rowid:%String,code:%String,desc:%String,otherdesc:%String") [ SqlProc ]
{
}

ClassMethod UpdateMessage(ID As %String, DOPRowId As %String, Code As %String, Desc As %String, OtherDesc As %String) As %String
{
	s ^zzy("Add")=ID_"^"_DOPRowId_"^"_Code_"^"_Desc_"^"_OtherDesc
	q:DOPRowId="" "-1^未选择行"
	s rowid=$o(^DHCDocOMi("Code",0,Code,DOPRowId,""))
	Q:((ID="")&&(rowid'=""))||((ID'="")&&(rowid'="")&&(rowid'=$p(ID,"||",2))) "-1^已经存在相同代码"
    //q:((ID="")&&($d(^DHCDocOMi("Code",0,Code,DOPRowId)))) "-1^已经存在相同代码"
    
	i ID="" {
	  &sql(insert into SQLUser.DHC_DocOrderMessage(DOM_DOP_ParRef,DOM_Code,DOM_Desc,DOM_OtherDesc) values (:DOPRowId,:Code,:Desc,:OtherDesc))
	}else {
	&sql(Update  SQLUser.DHC_DocOrderMessage  set DOM_Code=:Code,DOM_Desc=:Desc,DOM_OtherDesc=:OtherDesc where DOM_RowId=:ID)
	}
	q SQLCODE
}

ClassMethod DelMessage(IDs As %String) As %String
{
	q:IDs="" 0
	s ret=0
	f i=1:1:$length(IDs){
		s RowId=$p(IDs,"^",i)
		if (RowId'=""){
			&sql(delete from SQLUser.DHC_DocOrderMessage where DOM_RowID=:RowId)
		}
		s ret=ret+SQLCODE
	}
	q ret
}

ClassMethod UpdateGrid(ID As %String, DOPRowId As %String, Code As %String, Desc As %String, Type As %String) As %String
{
   q:DOPRowId="" "-1^未选择行"
    q:((ID="")&&($d(^DHCDocOGi("Code",Code,DOPRowId)))) "-1^已经存在相同代码"
    
	i ID="" {
	  &sql(insert into SQLUser.DHC_DocOrderGrid(DOG_DOP_ParRef,DOG_Code,DOG_Desc,DOG_Type) values (:DOPRowId,:Code,:Desc,:Type))
	}else {
	&sql(Update  SQLUser.DHC_DocOrderGrid  set DOG_Code=:Code,DOG_Desc=:Desc,DOG_Type=:Type where DOG_RowId=:ID)
	}
	q SQLCODE
}

ClassMethod DelGrid(IDs As %String) As %String
{
	q:IDs="" 0
	s ret=0
	f i=1:1:$length(IDs){
		s RowId=$p(IDs,"^",i)
		if (RowId'=""){
			&sql(delete from SQLUser.DHC_DocOrderGrid where DOG_RowID=:RowId)
		}
		s ret=ret+SQLCODE
	}
	q ret
}

// d ##class(web.DHCDocOrderListCommon).CopyData()

/*ClassMethod CopyData(){
	s Rowid=0
 	f  s Rowid=$o(^DHCDocZZY(Rowid)) q:Rowid=""  d
 	.s Code=$p($g(^DHCDocZZY(Rowid)),"^",1)
 	.q:Code=""
 	.s Desc=$p($g(^DHCDocZZY(Rowid)),"^",2)
 	.s expression=$p($g(^DHCDocZZY(Rowid)),"^",3)
 	.s colwidth=$p($g(^DHCDocZZY(Rowid)),"^",4)
 	.s hidden=$p($g(^DHCDocZZY(Rowid)),"^",5)
 	.&sql(insert into SQLUser.DHC_DocOrderListSet (OLS_DOG_ParRef,OLS_Code,OLS_Desc,OLS_Expression,OLS_ColWidth,OLS_Hidden) values ("1||1",:Code,:Desc,:expression,:colwidth,:hidden))
	
	
}*/
/// creator:郭荣勇
/// date:	2015-01-30
/// input:	用户RowId
/// return:	
/// desc:   得到医嘱录入框架布局
/// w ##class(web.DHCDocOrderListCommon).GetEntryLayout(1)
ClassMethod GetEntryLayout(UserID As %String, PAAdmType As %String, GroupId As %String = "") As %String
{
	n (UserID,PAAdmType,GroupId,%session)
	;默认为医嘱单在下的模式
	//s EntryLayout=1
	//2016-05-09 默认为医嘱单在上的模式
	s EntryLayout=2
	;非住院只能启用默认模式,门诊不需要医嘱单的显示
	//i PAAdmType'="I" Q EntryLayout
	i PAAdmType'="I" Q 1
	
	s layoutConfig=..%GetConfig1("layoutConfig",UserID)
 	i layoutConfig="" {
	 	if (GroupId'=""){
	 		s layoutConfig=..%GetConfig1("layoutConfig_Group",GroupId)
	 		q:layoutConfig="" EntryLayout
	 		s EntryLayout=layoutConfig
	 	}else{
		 	Q EntryLayout
		}
 	}else{
	 	s EntryLayout=layoutConfig
 	}
 	Q EntryLayout
}

// 全局隐藏元素/Custom 非列元素

ClassMethod ComonItemWinte(EpisodeID As %String = "") As %String
{
   	;Custom
   	s AdmType=""
   	i EpisodeID'="" s AdmType=$p($g(^PAADM(EpisodeID)),"^",2)
   	i AdmType'="I" d ##class(web.UDHCCardCommLinkRegister).GetCardHardJSFunction()
    //新版检查申请单打印
    d ##Class(web.DHCBillPrint).InvBillPrintCLSID()
    ;d ##Class(web.DHCBillPrint).AccPWDCLSID()
    
    ;Item
	s ReadXML=##Class(websys.Page).Encrypt($lb("web.DHCXMLIO.ReadXML"))
	w "<input id='XMLObject' name='XMLObject' type='hidden' value='"_ReadXML_"'>",$c(13,10)
	w "<input id='InvPrintEncrypt' name='InvPrintEncrypt' type='hidden' value='"_ReadXML_"'>",$c(13,10)
	
	s ReadAccExpEncrypt=##Class(websys.Page).Encrypt($lb("web.UDHCAccManageCLSIF.getaccinfofromcardno"))
	w "<input id='ReadAccExpEncrypt' name='ReadAccExpEncrypt' type='hidden' value='"_ReadAccExpEncrypt_"'>",$c(13,10)
	
	;必须元素
	s PatientID=$p(^PAADM(EpisodeID),"^",1)
	s CardBillCardTypeValue=##class(web.DHCOPAdmReg).GetCardBillCardTypeValue(PatientID)
	//s CardBillCardTypeValue=##Class(web.UDHCOPOtherLB).getDefaultCardType()
	w "<input id='CardBillCardTypeValue' name='CardBillCardTypeValue' type='hidden' value='"_CardBillCardTypeValue_"'>",$c(13,10)
}

/// desc 新医嘱录入 获取医保分类
/// input 医嘱项ID 费别
ClassMethod GetArcimInsurCat(Arcim As %String, AdmReason As %String, LogonHospDr As %String) As %String
{
	//Q "01"_$C(1)_"受限医保"_$C(2)_"02"_$C(1)_"受限地方"_$C(2)_"03"_$C(1)_"受限自费"
	n (Arcim,AdmReason,LogonHospDr,%session)
	s ^lxz("GetArcimInsurCat")=Arcim_","_AdmReason
	s $ZT="ErrorGetInsurCat"
	Set langid=..%LanguageID()
	s RtnInsuCatStr=""
   	Set rset=##Class(%ResultSet).%New("web.DHCDocOrderCommon:LookupArcimInsurCat")
	If rset.QueryIsValid() { 
		Set Status=rset.Execute(Arcim,AdmReason,LogonHospDr)
		If 'Status Quit
		Set columns = rset.GetColumnCount()
		While (rset.Next()) {
			s HisCode=rset.Data("HisCode")
			s Desc=rset.Data("Desc")
			s TarType=rset.Data("TarType")
			s Note=rset.Data("Note")
			s InsurCat=rset.Data("InsurCat")
			Set InsurCat= ##class(User.INSUDicData).GetTranByDesc("INDIDDicDesc",InsurCat,langid)
			if RtnInsuCatStr="" s RtnInsuCatStr=TarType_$C(1)_InsurCat
			else  s RtnInsuCatStr=RtnInsuCatStr_$C(2)_TarType_$C(1)_InsurCat	
		}
		d rset.Close()
	}
	q RtnInsuCatStr
ErrorGetInsurCat
  q ""
}

/// d ##class(%ResultSet).RunQuery("web.DHCDocOrderListCommon","GetOrderMessage",1)
Query GetShortcutKey(DOPRowId) As %Library.Query(CONTAINID = 0, ROWSPEC = "rowid:%String,ItemID:%String,ShortcutKey:%String,callBackFun:%String") [ SqlProc ]
{
}

ClassMethod GetShortcutKeyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetShortcutKeyExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetShortcutKeyExecute(ByRef qHandle As %Binary, DOPRowId) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s desc="",rowid="",mrdesc=""
	i DOPRowId="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s Rowid=0
 	f  s Rowid=$o(^DHCDocSCK(DOPRowId,Rowid)) q:Rowid=""  d
 	.s ItemID=$p($g(^DHCDocSCK(DOPRowId,Rowid)),"^",1)
 	.s ShortcutKey=$p($g(^DHCDocSCK(DOPRowId,Rowid)),"^",2)
 	.s callBackFun=$p($g(^DHCDocSCK(DOPRowId,Rowid)),"^",3)
 	.d OutputRow5
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow5
	set Data=$lb(DOPRowId_"||"_Rowid,ItemID,ShortcutKey,callBackFun)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod GetShortcutKeyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetShortcutKeyExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {			// if there are no more rows, finish fetching
	 Set AtEnd=1
	 Set Row=""
	}
	Else {				// fetch row
	 Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod DelShortcutKey(IDs As %String) As %String
{
	q:IDs="" 0
	s ret=0
	f i=1:1:$length(IDs){
		s RowId=$p(IDs,"^",i)
		if (RowId'=""){
			&sql(delete from SQLUser.DHC_DocShortCutKey where DSK_RowID=:RowId)
		}
		s ret=ret+SQLCODE
	}
	q ret
}

ClassMethod updateShortcutKey(ID As %String, DOPRowId As %String, ItemID As %String, ItemShortcutKey As %String, ShortcutKeyCallFun As %String) As %String
{
	q:DOPRowId="" "-1^未选择行"
	s ItemShortcutKey=$zcvt(ItemShortcutKey,"U")
	q:'(("^F1^F2^F3^F4^F5^F6^F7^F8^F9^F10^F11^F12^")[("^"_ItemShortcutKey_"^")) "-2^快捷键只能是F1~F12"
	s repeat=0
    s Rowid=0
 	f  s Rowid=$o(^DHCDocSCK(DOPRowId,Rowid)) q:(Rowid="")||(repeat=1)  d
 	.s itemid=$p($g(^DHCDocSCK(DOPRowId,Rowid)),"^",1)
 	.s shortcutkey=$p($g(^DHCDocSCK(DOPRowId,Rowid)),"^",2)
 	.if ((itemid=ItemID)||(ItemShortcutKey=shortcutkey))&&(ID'=(DOPRowId_"||"_Rowid)) s repeat=1
 	Q:repeat=1 "-1^已经存在相同元素ID/快捷键"
	i ID="" {
	  	&sql(insert into SQLUser.DHC_DocShortCutKey(DSK_DOP_ParRef,DSK_ItemID,DSK_ShortCutKey,DSK_CallBackFun) values (:DOPRowId,:ItemID,:ItemShortcutKey,:ShortcutKeyCallFun))
	}else {
		&sql(Update  SQLUser.DHC_DocShortCutKey  set DSK_ItemID=:ItemID,DSK_ShortCutKey=:ItemShortcutKey,DSK_CallBackFun=:ShortcutKeyCallFun where DSK_RowId=:ID)
	}
	q SQLCODE
}

}
