Class ext.websys.QueryBroker Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Query执行
/// 1. 分页功能  				pStart, pPageCount
///    需要传入 当前页  和每页多少行
/// 2. 排序功能(传入排序的列)	列名:Desc,列名:Asc
/// 3. 日期格式转换问题
ClassMethod CQPExecute(classname As %String, classquery As %String) As %String
{
	n rs, myrtn
	s $ZT="Error"

	s rs=""
	s myrtn=""
	i ((classname="")||(classquery="")){
		q myrtn
	}
	
	s myIsVal=##class(websys.Conversions).IsValidClassName(classname)
	q:('myIsVal) myrtn
	s myIsVal=##class(websys.Conversions).IsValidQueryName(classname,classquery)
	q:('myIsVal) myrtn
	
	s rs=##class(%Library.ResultSet).%New(classname_":"_classquery)
	s paramcnt=rs.GetParamCount()
	n x,ival
	s x="s execstatus=$$InvokeMethod^%apiOBJ(""%ResultSet"",rs,""Execute"""
	f j=1:1:paramcnt {
		s paramname=rs.GetParamName(j)
		s val=$g(%request.Data(("P"_j),1))
		i $l(val,"""")>1 s val="" f ival=1:1:$l($g(%request.Data(paramname,1)),"""") s $p(val,"""""",ival)=$p(%request.Data(paramname,1),"""",ival)
		;i val'="",val'?1n.n i ##class(%Library.Collation).Upper(paramname)["DATE" s val=##class(websys.Conversions).DateHtmlToLogical(val)
		;i val'="",val'?1n.n i ##class(%Library.Collation).Upper(paramname)["TIME" s val=##class(websys.Conversions).TimeHtmlToLogical(val)
		s x=x_","""_val_""""
	}
 	s x=x_")"
	x x
	s ^TMPExtRequest("QueryBroker.CQPExecute")=x
	s myjsonstr=""
	;
	;判断返回是否ResultSet
	s myIsVal=##class(websys.Conversions).IsValidResultSet(rs)
	i myIsVal{
		if ($g(%request.Data("GetTotal",1))=1){
			w ..GetTotal(rs)
		}else{		
			d ..GetRSJsonData(rs)
		}
		d rs.%Close()
	}
	q myjsonstr
Error
	;s ErrorMsg=$ZE
	;s ^TempLookUpError($i(^TempLookUpError),classname,classquery)=ErrorMsg
	q "100"_"^"_$ZE
}

ClassMethod CQExecute(classname As %String, classquery As %String) As %String
{
	n rs, myrtn, mypageflag,mypagecount
	
	;默认分页
	s mypageflag=1
	s mypagecount=20
	s rs=""
	s myrtn=""
	i ((classname="")||(classquery="")){
		q myrtn
	}
	s myIsVal=##class(websys.Conversions).IsValidClassName(classname)
	q:('myIsVal) myrtn
	s myIsVal=##class(websys.Conversions).IsValidQueryName(classname,classquery)
	q:('myIsVal) myrtn
	
	s rs=##class(%Library.ResultSet).%New(classname_":"_classquery)
	s paramcnt=rs.GetParamCount()
	n x,ival
	s x="s execstatus=$$InvokeMethod^%apiOBJ(""%ResultSet"",rs,""Execute"""
	f j=1:1:paramcnt {
		s paramname=rs.GetParamName(j)
		s val=$g(%request.Data(paramname,1))
		i $l(val,"""")>1 s val="" f ival=1:1:$l($g(%request.Data(paramname,1)),"""") s $p(val,"""""",ival)=$p(%request.Data(paramname,1),"""",ival)
		;i val'="",val'?1n.n i ##class(%Library.Collation).Upper(paramname)["DATE" s val=##class(websys.Conversions).DateHtmlToLogical(val)
		;i val'="",val'?1n.n i ##class(%Library.Collation).Upper(paramname)["TIME" s val=##class(websys.Conversions).TimeHtmlToLogical(val)
		s x=x_","""_val_""""
	}
 	s x=x_")"
	x x
	s ^TMPExtRequest("QueryBroker.CQExecute")=x
	s myjsonstr=""
	;
	;判断返回是否ResultSet
	s myIsVal=##class(websys.Conversions).IsValidResultSet(rs)
	i myIsVal{
		d ..GetRSJsonData(rs)
		d rs.%Close()
	}
	
	q myjsonstr
}

ClassMethod GetRSXMLData(rs As %Library.ResultSet) As %String
{
}

ClassMethod GetRSJsonData(rs As %Library.ResultSet) As %String
{
	;s mygridobj=##class(ext.entity.GridData).%New()
	s cnt=0
	s displayRows=0
	s rowData=""
	w "{""record"":[",!
	s columns=rs.GetColumnCount()
	s start = +$g(%request.Data("start",1))
	s limit = +$g(%request.Data("limit",1))
	;
	;ext默认的开始是0
	s startRecordNo=start+1
	s limitRecordCnt=limit
	
	f  q:rs.Next()=0  d
	.s cnt=cnt+1
	.i ((cnt'<startRecordNo)&&(displayRows<limitRecordCnt))!(startRecordNo="")!(limitRecordCnt=0)  d
	..w:displayRows>0 ","
	..w "{"
	..s rowData=""
	..f i=1:1:columns  d
	...s:i>1 rowData=rowData_","
	...s myColName=rs.GetColumnName(i)
	...s:($ZCVT(myColName,"U")=..#LookupHidden) myColName=..#LookupHidden_i
	...s rowData=rowData_""""_myColName_""":"		;;rs.GetColumnName(i)
	...s tmpData=rs.GetData(i)	
	...s tmpData=##class(ext.util.String).EvalJSON(tmpData)
	...s rowData=rowData_""""_tmpData_""""
	..w rowData
	..w "}",!
	..s displayRows=displayRows+1
	
	w "],""total"" : "_cnt_"}"
	
	;d mygridobj.%Close()
}

/// 自动获取一个RS的输出列表 
/// 返回Json格式
/// 
ClassMethod ReadRS(classname As %String, classquery As %String) As %String
{
	;w ##class(ext.websys.QueryBroker).ReadRS("web.DHCPE.PreGADM","SearchPreGADMShort")
	;w ##class(ext.websys.QueryBroker).ReadRS("web.DHCSTDISPSTAT2","GroupLoc")
	;w ##class(ext.websys.QueryBroker).ReadRS("web.SSLanguage","LookUp")
	n (%request,%session,classname,classquery)
	s t = ""
	if (%request),(%session){
		set langid=+$g(%session.Data("LOGON.LANGID"))
		set page=%request.PageName
		if langid>0,page'=""{
			m t = ^websys.TranslationD("PAGE",langid,page)
		}
	}
	s myjosnstr=""
	s myOutStr=##class(DHCCPMWeb.CPMBL.DHCBLCommFunLib).GetQOutParaList(classname,classquery,"")	
	
	s mycms=##class(ext.entity.GridModal).%New()
	s myColLen=$l(myOutStr, ",")
	s:(myOutStr="") myColLen=""
	f myIdx=1:1:myColLen {
		s myColStr=$p(myOutStr,",",myIdx)
		s myColumnName=$TR($p(myColStr,":",1)," ","")
		s myColumnType=$p(myColStr,":",2)
		s myColumnCaption=$p(myColStr,":",3)
		
		s mycm=##class(ext.entity.ColumnModel).%New()
		if (($zconvert(myColumnName,"U"))'=..#LookupHidden){
			;wanghc 国际化 2017-8-4
			d ..AddTranslation(langid,page,.t,myColumnName,myColumnCaption)
			s mycm.header = t(myColumnName) 	;$s(myColumnCaption'="":myColumnCaption,1:myColumnName)
			;s mycm.header=$s(myColumnCaption'="":"$g('"_myColumnCaption_"')",1: "$g('"_myColumnName_"')") ;"$g('"_myColumnName_"')" ;
			s mycm.dataIndex=myColumnName
			;s mycm.width=100
		}else{
			s mycm.header=..#LookupHidden_myIdx		;$s(myColumnCaption'="":myColumnCaption,1: myColumnName)
			s mycm.dataIndex=..#LookupHidden_myIdx
			s mycm.hidden="true"
		}
		d mycms.cms.Insert(mycm)
		
		s myfn=##class(ext.entity.Field).%New()
		; wanghc 2015-11-25 列类型,
		s myfn.type = $Case(myColumnType,"%Date":"date","%Integer":"int","%Float":"float",:"string")
		s myfn.name=mycm.dataIndex		;;myColumnName
		d mycms.fns.Insert(myfn)
	}
	
	s myjosnstr=mycms.GetJosnData()
	
	q myjosnstr
}

/// @date: 2011/11/11
/// @author:	 wanghc 
/// 能自定义列头,	列宽, 行数, 隐藏,字体
/// query定义HIDDEN:%String:ARowId  -->        {header:hidden1, dataindex:hidden1}
/// 列编辑定义 ARowId:%String:行标 是hidden  -->	{header:'行标', dataindex:ARowId, hidden:true}
/// Query 是定义为HIDDEN列一定是hidden的且cm名为HIDDEN_Ind, 列定义的隐藏不改变cm名称
ClassMethod ReadRSNew(classname As %String, classquery As %String) As %String
{
	q:(classname="")||(classquery="") ""
	n (%request,%session,classname,classquery)
	s t = ""
	if (%request),(%session){
		set langid=+$g(%session.Data("LOGON.LANGID"))
		set page=%request.PageName
		if langid>0,page'=""{
			m t = ^websys.TranslationD("PAGE",langid,page)
		}
	}
	;s LookupListComponetId = $o(^websys.ComponentI("UniqueNameIndex","WEBSYSLOOKUPLIST",0))
	s context="K"_classname_":"_classquery
	s myjosnstr=""
	
	s myOutStr=##class(DHCCPMWeb.CPMBL.DHCBLCommFunLib).GetQOutParaList(classname,classquery,"")	
	s mycms=##class(ext.entity.GridModal).%New()	
	s myColLen=$l(myOutStr, ",")	
	s uSet="",fontSize=15,pageSize=15
	if (($g(%session)'="")&&($g(%session.Data("LOGON.USERID"))'="")) d
	.;s uSet=##class(websys.Preferences).GetDataExLE(1,1,"","",context,"COLUMNS","websys.LookUp.List",.app,.appid,.activecontext,"","")
	.s uSet=##Class(websys.Preferences).GetDataExLE($g(%session.Data("LOGON.USERID")),$g(%session.Data("LOGON.GROUPID")),$g(%session.Data("LOGON.HOSPID")),$g(%session.Data("LOGON.SITECODE")),context,"COLUMNS","websys.LookUp.List",.app,.appid,.activecontext,$g(%session.Data("LOGON.TRUSTID")),$g(%session.Data("LOGON.REGION")))
	.i activecontext'=context set uSet="" ;查询出的不是放大镜的列布局
	.;不能改顺序,影响前台取值
	.f idx=1:1:$l(uSet,"|") d
	..s uSetItem = $p(uSet,"|",idx)
	..s myIdx = $p(uSetItem,",",1)		;col-index,width,sort|
	..s:myIdx>0 hiddenPlist(myIdx)=1,hiddenPlist(myIdx,2)=$p(uSetItem,",",2),hiddenPlist(myIdx,3)=$p(uSetItem,",",3)	
	.s rowsSet=##Class(websys.Preferences).GetDataExLE($g(%session.Data("LOGON.USERID")),$g(%session.Data("LOGON.GROUPID")),$g(%session.Data("LOGON.HOSPID")),$g(%session.Data("LOGON.SITECODE")),context,"ROWS","websys.LookUp.List",.app,.appid,.activecontext,$g(%session.Data("LOGON.TRUSTID")),$g(%session.Data("LOGON.REGION")))
	.s pageSize=$lg(rowsSet,1),fontSize=$lg(rowsSet,11)
	
	f myIdx=1:1:myColLen {
		s myColStr=$p(myOutStr,",",myIdx)
		s myColumnName=$TR($p(myColStr,":",1)," ","")
		s myColumnType=$p(myColStr,":",2)
		s myColumnCaption=$p(myColStr,":",3)
		s myColumnWidth = $p(myColumnCaption,"^",2)
		s myColumnCaption = $p(myColumnCaption,"^",1)
		s mycm=##class(ext.entity.ColumnModel).%New()
		if ($zcvt(myColumnName,"U")=..#LookupHidden){
			s mycm.header=..#LookupHidden_myIdx		;$s(myColumnCaption'="":myColumnCaption,1: myColumnName)
			s mycm.dataIndex=..#LookupHidden_myIdx
			s mycm.hidden="true"
		}else{
			;wanghc 国际化 2017-8-4
			d ..AddTranslation(langid,page,.t,myColumnName,myColumnCaption)
			s mycm.header = t(myColumnName) ;$s(myColumnCaption'="":myColumnCaption,1:myColumnName)
			;s mycm.header=$s(myColumnCaption'="":"$g('"_myColumnCaption_"')",1: "$g('"_myColumnName_"')") ;"$g('"_myColumnName_"')" ;
			s mycm.dataIndex=myColumnName
			i (uSet'=""),$g(hiddenPlist(myIdx))="" s mycm.hidden="true"
			i +myColumnWidth>0	s mycm.width=+myColumnWidth
			i ($g(hiddenPlist(myIdx))=1),$g(hiddenPlist(myIdx,2))'="" s mycm.width=hiddenPlist(myIdx,2)	
		}		
		d mycms.cms.Insert(mycm)		
		s myfn=##class(ext.entity.Field).%New()
		; wanghc 2015-11-25 列类型,
		s myfn.type = $Case(myColumnType,"%Date":"date","%Integer":"int","%Float":"float",:"string")
		s myfn.name=mycm.dataIndex		;;myColumnName
		d mycms.fns.Insert(myfn)
	}
	s myjosnstr =mycms.GetJosnData()
	i $g(pageSize)'="" s myjosnstr = $e(mycms.GetJosnData(),1,$l(mycms.GetJosnData())-1)_",""pageSize"":"_pageSize_",""fontSize"":"""_fontSize_"""}"

	q myjosnstr
}

/// @date: 		2011/11/11
/// @author:	 wanghc 
/// 能自定义列头,	列宽, 行数, 隐藏,顺序
/// query定义HIDDEN:%String:ARowId  -->        {header:hidden1, dataindex:hidden1}
/// 列编辑定义 ARowId:%String:行标 是hidden  -->	{header:'行标', dataindex:ARowId, hidden:true}
/// Query 是定义为HIDDEN列一定是hidden的且cm名为HIDDEN_Ind, 列定义的隐藏不改变cm名称
/// cm走顺序, fn走query的顺序, 就算放大镜也不影响
ClassMethod ReadRSNew2(classname As %String, classquery As %String) As %String
{
	q:(classname="")||(classquery="") ""
	n (%request,%session,classname,classquery)
	s t = ""
	if (%request),(%session){
		set langid=+$g(%session.Data("LOGON.LANGID"))
		set page=%request.PageName
		if langid>0,page'=""{
			m t = ^websys.TranslationD("PAGE",langid,page)
		}
	}
	k ^||MyColTempList
	s context="K"_classname_":"_classquery
	s myjosnstr=""
	s myOutStr=##class(DHCCPMWeb.CPMBL.DHCBLCommFunLib).GetQOutParaList(classname,classquery,"")	
	s mycms=##class(ext.entity.GridModal).%New()
	s mycmsNew=##class(ext.entity.GridModal).%New()	
	s myColLen=$l(myOutStr, ",")	
	s uSet=""
	if (($g(%session)'="")&&($g(%session.Data("LOGON.USERID"))'="")) d
	.;s uSet=##class(websys.Preferences).GetDataExLE(1,1,"","",context,"COLUMNS","websys.LookUp.List",.app,.appid,.activecontext,"","")
	.s uSet=##Class(websys.Preferences).GetDataExLE($g(%session.Data("LOGON.USERID")),$g(%session.Data("LOGON.GROUPID")),$g(%session.Data("LOGON.HOSPID")),$g(%session.Data("LOGON.SITECODE")),context,"COLUMNS","websys.LookUp.List",.app,.appid,.activecontext,$g(%session.Data("LOGON.TRUSTID")),$g(%session.Data("LOGON.REGION")))
	.i activecontext'=context set uSet="" ;查询出的不是放大镜的列布局
	.i uSet=",," Set uSet=""
	.;不能改顺序,影响前台取值
	.f idx=1:1:$l(uSet,"|") d
	..s uSetItem = $p(uSet,"|",idx)
	..s myIdx = $p(uSetItem,",",1)		;col-index,width,sort|
	..s:myIdx>0 hiddenPlist(myIdx)=1,hiddenPlist(myIdx,2)=$p(uSetItem,",",2),hiddenPlist(myIdx,3)=$p(uSetItem,",",3)	
	.s rowsSet=##Class(websys.Preferences).GetDataExLE($g(%session.Data("LOGON.USERID")),$g(%session.Data("LOGON.GROUPID")),$g(%session.Data("LOGON.HOSPID")),$g(%session.Data("LOGON.SITECODE")),context,"ROWS","websys.LookUp.List",.app,.appid,.activecontext,$g(%session.Data("LOGON.TRUSTID")),$g(%session.Data("LOGON.REGION")))
	.s pageSize=$lg(rowsSet,1)
	if $G(pageSize)="" set pageSize=15
	f myIdx=1:1:myColLen {
		s myColStr=$p(myOutStr,",",myIdx)
		s myColumnName=$TR($p(myColStr,":",1)," ","")
		s myColumnType=$p(myColStr,":",2)
		s myColumnCaption=$p(myColStr,":",3)
		s myColumnWidth = $p(myColumnCaption,"^",2)
		s myColumnCaption = $p(myColumnCaption,"^",1)
		s mycm=##class(ext.entity.ColumnModel).%New()
		if ($zcvt(myColumnName,"U")=..#LookupHidden){
			s mycm.header=..#LookupHidden_myIdx
			s mycm.dataIndex=..#LookupHidden_myIdx
			s mycm.hidden="true"
		}else{
			;wanghc 国际化 2017-8-4 多个放大镜都包含Code
			d ..AddTranslation(langid,page,.t,myColumnName,myColumnCaption)
			s mycm.header = t(myColumnName) ;$s(myColumnCaption'="":myColumnCaption,1:myColumnName)
			;s mycm.header=$s(myColumnCaption'="":"$g('"_myColumnCaption_"')",1: "$g('"_myColumnName_"')") ;"$g('"_myColumnName_"')" ;
			s mycm.dataIndex=myColumnName
			i (uSet'=""),$g(hiddenPlist(myIdx))="" s mycm.hidden="true"
			i +myColumnWidth>0	s mycm.width=+myColumnWidth
			i ($g(hiddenPlist(myIdx))=1),$g(hiddenPlist(myIdx,2))'="" s mycm.width=hiddenPlist(myIdx,2)	
		}		
		d mycms.cms.Insert(mycm)
		s myfn=##class(ext.entity.Field).%New()
		; wanghc 2015-11-25 列类型,
		s myfn.type = $Case(myColumnType,"%Date":"date","%Integer":"int","%Float":"float",:"string")
		s myfn.name=mycm.dataIndex		;;myColumnName
		;d mycms.fns.Insert(myfn)
		d mycmsNew.fns.Insert(myfn)
		s ^||MyColTempList(myIdx)=1
	}
	;把显示的顺序弄好
	i uSet'="" d
	.f idx=1:1:$l(uSet,"|") d
	..s uSetItem = $p(uSet,"|",idx)
	..s myIdx = $p(uSetItem,",",1)		; col-index,width,sort|
	..q:+myIdx=0
	..q:myIdx>myColLen	;如果保存列编辑后,query出参列减少
	..d mycmsNew.cms.Insert(mycms.cms.GetAt(myIdx))
	..;d mycmsNew.fns.Insert(mycms.fns.GetAt(myIdx))
	..k ^||MyColTempList(myIdx)
	;把最后面隐藏的加上
	s idx="" f  s idx = $o(^||MyColTempList(idx)) q:idx=""  d
	.d mycmsNew.cms.Insert(mycms.cms.GetAt(idx))
	.;d mycmsNew.fns.Insert(mycms.fns.GetAt(idx))
	d mycms.cms.%Close()
	d mycms.fns.%Close()
	s mycms.cms = ""
	s mycms.fns = ""
	d mycms.%Close() 
	s mycms=""
	s myjosnstr =mycmsNew.GetJosnData()
	i $g(pageSize)'="" s myjosnstr = $e(myjosnstr,1,$l(myjosnstr)-1)_",pageSize:"_pageSize_"}"
	q myjosnstr
}

ClassMethod AddTranslation(langid, page, ByRef t, key, value)
{
	n (langid,page,t,key,value)
	Quit:key="" ""
	if (langid>0)&&(page'=""){  				// 界面进入
		if ( 0=$d(t(key)) ) {    		// 没有翻译过
			if ($P(^SS("LAN",langid),"^")="CH")&&(value'="") { 					// 通过Query出参,自动翻译成中文
				s ^websys.TranslationD("PAGE",langid,page,key)=value
			}else{    																		 // 其它语言直接翻译成column name  
				s ^websys.TranslationD("PAGE",langid,page,key)=key
			}
		}
		if (value'=""){
			s ^websys.TranslationD("PAGE",langid,page,key)=value
		}
		set t(key) = ^websys.TranslationD("PAGE",langid,page,key)
	}else{ 
		s t(key)=$s(value'="":value,1:key)
	}
}

/// 拿query的总行数,query的参数是%request.Data("P1",1),%request.Data("P2",1)...
ClassMethod GetTotal(rs) As %String
{
	s cnt=0 
	s myIsVal=##class(websys.Conversions).IsValidResultSet(rs)
	i myIsVal{
		f  q:rs.Next()=0  s cnt=cnt+1
	}
	q cnt
}

/// trak lookup的特殊约定
Parameter LookupHidden = "HIDDEN";

}
