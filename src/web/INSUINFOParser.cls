Class web.INSUINFOParser Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator: 詹明超
/// Description:根据模版和对象生成单条要上传的信息串,调用前要先调用GetIDLIST函数完成初始化
/// Input:type：生成数据串格式(XML,STR),subnode:子节点名称,objoe:对象,ExpStr:扩展参数
/// 返回对应的串
ClassMethod GetINSUUPLOADINFTO(type As %String, subnode As %String, objoe, ExpStr As %String) As %String
{
	s rtnStr=""
	s:type="XML" rtnStr=..GetINSUUPLOADINFTOXML(subnode,0,"",0,objoe,"")
	s:type="STR" rtnStr=..GetINSUUPLOADINFTOSTR(subnode,0,"",0,objoe,"")
	s:type="JSON" rtnStr=##class(web.INSUCacheJSON).Encode(..GetINSUUPLOADINFTOOBJ(subnode,0,"",0,objoe,"",""))
	q rtnStr
}

/// Creator: 詹明超
/// Description:根据模版和对象生成单条要上传的XML信息串,调用前要先调用GetIDLIST函数完成初始化
/// Input:subnode:子节点名称,qRowid:表的rowid,lstr:对照的代码,i:行数,objoe:对象,itplCode:XML节点名称
/// 返回XML串
ClassMethod GetINSUUPLOADINFTOXML(subnode As %String, qRowid As %Integer = 0, lstr As %String, i As %Integer, objoe, itplCode) As %String [ Internal ]
{
	s rtnXML=""
	i i<0 {
		s Rowid="",qlFlag=0,tmpoelistobj="",tlistind=1,tmpconCode=""
		s tmplobjval=^||INSUOEORDINFTOXML(subnode,qRowid)
		s lOEORDCode=..AutoBase64Decode($p(tmplobjval,"^",5))
		;s tmpoelistobj=$PROPERTY(objoe,$p(lOEORDCode,":",1)) //..GetPROPERTY(tmplistsubval,$p(OEORDCode,":",tmpind))
		s llOEORDCode=""
		s tlistind=$l(lstr,":")
		;s llOEORDCode=lOEORDCode
		s tmpconCode=lOEORDCode
		;s $p(tmpconCode,":",$l(tmpconCode,":"))=""
		;s tmpconCode=$e(tmpconCode,0,$l(tmpconCode)-1)
		f tmpi=1:1:tlistind d
		.s:llOEORDCode'="" llOEORDCode=llOEORDCode_":"_$p(lOEORDCode,":",tmpi)
		.s:llOEORDCode="" llOEORDCode=$p(lOEORDCode,":",tmpi)
		s tmpoelistobj=..GetPROPERTY(objoe,llOEORDCode,lstr,1)
		
		i $IsObject(tmpoelistobj)=0 d
		.s rtnXML="<"_itplCode_">"_..GetINSUUPLOADINFTOXML(subnode,qRowid,lstr,1,objoe,"")_"</"_itplCode_">"
		e  d
		.s tmpcnt=0
		.s:tmpoelistobj.%ClassName()["List" tmpcnt=tmpoelistobj.Count()
		.s:tmpcnt=0 rtnXML="<"_itplCode_">"_..GetINSUUPLOADINFTOXML(subnode,qRowid,lstr,1,objoe,"")_"</"_itplCode_">"
		.q:tmpcnt=0
		.f j=1:1:tmpcnt d
		..s $p(lstr,":",tlistind)=j
		..i tlistind<$l(lOEORDCode,":") d
		...s llOEORDCode=llOEORDCode_":"_$p(lOEORDCode,":",tlistind+1)
		...s tmpoelistobj=..GetPROPERTY(objoe,llOEORDCode,lstr,1)
		...s tmpcnt2=0
		...s:tmpoelistobj.%ClassName()["List" tmpcnt2=tmpoelistobj.Count()
		...s:tmpcnt2=0 rtnXML="<"_itplCode_">"_..GetINSUUPLOADINFTOXML(subnode,qRowid,lstr,1,objoe,"")_"</"_itplCode_">"
		...f jj=1:1:tmpcnt2 d
		....s $p(lstr,":",tlistind+1)=jj
		....s rtnXML=rtnXML_"<"_itplCode_">"_..GetINSUUPLOADINFTOXML(subnode,qRowid,lstr,0,objoe,"")_"</"_itplCode_">"
		..e  s rtnXML=rtnXML_"<"_itplCode_">"_..GetINSUUPLOADINFTOXML(subnode,qRowid,lstr,0,objoe,"")_"</"_itplCode_">"
		
		..;s lRowid=""
		..;f  s Rowid=$o(^||INSUOEORDINFTOXML(subnode,lRowid)) q:lRowid=""  d
		..;s tmplobjval=^||INSUOEORDINFTOXML(subnode,lRowid)
		..;q:$p(tmplobjval,"^",2)'=qRowid
		..;k ^||INSUOEORDINFTOXML(subnode,Rowid)
		..;k ^||INSUOEORDINFTOXML(subnode,qRowid)
		q rtnXML
	}else{
		s Rowid=""
		f  s Rowid=$o(^||INSUOEORDINFTOXML(subnode,Rowid)) q:Rowid=""  d
		.s subxml=""
		.s objxval=^||INSUOEORDINFTOXML(subnode,Rowid)
		.s PropType=$p(objxval,"^",1)
		.s ParRowid=+$p(objxval,"^",2)
		.s tplCode=$p(objxval,"^",3)
		.q:tplCode=""
		.s OEORDCode=..AutoBase64Decode($p(objxval,"^",5))
		.s defaultval=$p(objxval,"^",9)
		.q:(qRowid'=0)&(qRowid'=ParRowid)
		.q:(qRowid=0)&(ParRowid'=0)
		.s parType=""
		.s:ParRowid'=0 parType=$p(^||INSUOEORDINFTOXML(subnode,ParRowid),"^",1)
		.i ..hasChildNODE(subnode,Rowid) d
		..s tmplstr=1
		..i PropType="LIST" d
		...s tmplstr=""
		...i lstr="" d
		....s tmplstr=1
		...e  s tmplstr=lstr_":"_1
		..s rtnXML=rtnXML_..GetINSUUPLOADINFTOXML(subnode,Rowid,tmplstr,-1,objoe,tplCode)
		.e  d
		..s tmpvalue=..GetPROPERTY(objoe,OEORDCode,lstr,"")
		..s rtnXML=rtnXML_..BuildXMLNODE(tplCode,tmpvalue,defaultval)

		..;k:((parType'="LIST")&(i=1)) ^||INSUOEORDINFTOXML(subnode,Rowid)
		..;i (qRowid=0) d
		..;k ^||INSUOEORDINFTOXML(subnode,Rowid)
	}
	q rtnXML
}

/// Creator: 詹明超
/// Description:根据模版和对象生成单条要上传的字符串
/// Input:subnode:子节点名称,qRowid:表的rowid,lstr:对照的代码,i:行数,objoe:对象,itplCode:传空
/// 返回字符串
ClassMethod GetINSUUPLOADINFTOSTR(subnode As %String, qRowid As %Integer = 0, lstr As %String, i As %Integer, objoe, itplCode) As %String [ Internal ]
{
	s rtnStr=""
	i i<0 {
		s Rowid="",qlFlag=0,tmpoelistobj="",tlistind=1,tmpconCode=""
		s tmplobjval=^||INSUOEORDINFTOXML(subnode,qRowid)
		s lOEORDCode=..AutoBase64Decode($p(tmplobjval,"^",5))
		;s tmpoelistobj=$PROPERTY(objoe,$p(lOEORDCode,":",1)) //..GetPROPERTY(tmplistsubval,$p(OEORDCode,":",tmpind))
		s llOEORDCode=""
		s tlistind=$l(lstr,":")
		;s llOEORDCode=lOEORDCode
		s tmpconCode=lOEORDCode
		;s $p(tmpconCode,":",$l(tmpconCode,":"))=""
		;s tmpconCode=$e(tmpconCode,0,$l(tmpconCode)-1)
		f tmpi=1:1:tlistind d
		.s:llOEORDCode'="" llOEORDCode=llOEORDCode_":"_$p(lOEORDCode,":",tmpi)
		.s:llOEORDCode="" llOEORDCode=$p(lOEORDCode,":",tmpi)
		s tmpoelistobj=..GetPROPERTY(objoe,llOEORDCode,lstr,1)
		i $IsObject(tmpoelistobj)=0 d
		.s rtnStr=..GetINSUUPLOADINFTOSTR(subnode,qRowid,lstr,1,objoe,"")
		e  d
		.;b ;tmpcnt
		.s tmpcnt=0
		.s:tmpoelistobj.%ClassName()["List" tmpcnt=tmpoelistobj.Count()
		.s:tmpcnt=0 rtnStr=..GetINSUUPLOADINFTOSTR(subnode,qRowid,lstr,1,objoe,"")
		.q:tmpcnt=0
		.f j=1:1:tmpcnt d
		..s $p(lstr,":",tlistind)=j
		..i tlistind<$l(lOEORDCode,":") d
		...s llOEORDCode=llOEORDCode_":"_$p(lOEORDCode,":",tlistind+1)
		...s tmpoelistobj=..GetPROPERTY(objoe,llOEORDCode,lstr,1)
		...;b ;tmpcnt2
		...s tmpcnt2=0
		...s:tmpoelistobj.%ClassName()["List" tmpcnt2=tmpoelistobj.Count()
		...s:tmpcnt2=0 rtnStr=..GetINSUUPLOADINFTOSTR(subnode,qRowid,lstr,1,objoe,"")
		...f jj=1:1:tmpcnt2 d
		....s $p(lstr,":",tlistind+1)=jj
		....s rtnStr=rtnStr_"$"_..GetINSUUPLOADINFTOSTR(subnode,qRowid,lstr,0,objoe,"")
		..e  s rtnStr=rtnStr_"$"_..GetINSUUPLOADINFTOSTR(subnode,qRowid,lstr,0,objoe,"")

		q rtnStr
	}else{
		s Rowid=""
		f  s Rowid=$o(^||INSUOEORDINFTOXML(subnode,Rowid)) q:Rowid=""  d
		.s subxml=""
		.s objxval=^||INSUOEORDINFTOXML(subnode,Rowid)
		.s PropType=$p(objxval,"^",1)
		.s ParRowid=+$p(objxval,"^",2)
		.s tplCode=$p(objxval,"^",3)
		.q:tplCode=""
		.s OEORDCode=..AutoBase64Decode($p(objxval,"^",5))
		.s defaultval=$p(objxval,"^",9)
		.q:(qRowid'=0)&(qRowid'=ParRowid)
		.q:(qRowid=0)&(ParRowid'=0)
		.s parType=""
		.s:ParRowid'=0 parType=$p(^||INSUOEORDINFTOXML(subnode,ParRowid),"^",1)
		.i ..hasChildNODE(subnode,Rowid) d
		..s tmplstr=1
		..i PropType="LIST" d
		...s tmplstr=""
		...i lstr="" d
		....s tmplstr=1
		...e  s tmplstr=lstr_":"_1
		..s rtnStr=rtnStr_"|"_..GetINSUUPLOADINFTOSTR(subnode,Rowid,tmplstr,-1,objoe,tplCode)
		.e  d
		..s tmpvalue=..GetPROPERTY(objoe,OEORDCode,lstr,"")
		..s rtnStr=rtnStr_"|"_..BuildNODE(tplCode,tmpvalue,defaultval)

	}
	q rtnStr
}

/// / Creator: 詹明超
/// Description:根据模版和对象生成单条要上传的JSON信息串,调用前要先调用GetIDLIST函数完成初始化
/// Input:subnode:子节点名称,qRowid:表的rowid,lstr:对照的代码,i:行数,objoe:对象,itplCode:XML节点名称
/// 返回对象
ClassMethod GetINSUUPLOADINFTOOBJOld(subnode As %String, qRowid As %Integer = 0, lstr As %String, i As %Integer, objoe, itplCode, inObj) As %ArrayOfDataTypes [ Internal ]
{
	s rtnObj=##class(%ArrayOfDataTypes).%New() 
	i $IsObject(inObj) d
	.s rtnObj=inObj
	s tmpObjSub="",lFlag=0
	s Rowid=""
	f  s Rowid=$o(^||INSUOEORDINFTOXML(subnode,Rowid)) q:Rowid=""  d
	.s subxml=""
	.s objxval=^||INSUOEORDINFTOXML(subnode,Rowid)
	.s PropType=$p(objxval,"^",1)
	.s ParRowid=+$p(objxval,"^",2)
	.s tplCode=$p(objxval,"^",3)
	.q:tplCode=""
	.s OEORDCode=..AutoBase64Decode($p(objxval,"^",5))
	.s defaultval=$p(objxval,"^",9)
	.q:(qRowid'=0)&(qRowid'=ParRowid)
	.q:(qRowid=0)&(ParRowid'=0)
	.;s parType=""
	.;s:ParRowid'=0 parType=$p(^||INSUOEORDINFTOXML(subnode,ParRowid),"^",1)
	.i ..hasChildNODE(subnode,Rowid) d
	..s tmpObj=##class(%ArrayOfDataTypes).%New() 
	..s tmplstr=1
	..i PropType="LIST" d
	...s tmpObj=##class(%ListOfDataTypes).%New() 
	...s tmplstr=""
	...i lstr="" d
	....s tmplstr=1
	...e  s tmplstr=lstr_":"_1
	...;b ;zhan 2 bug,多于2个子集合时有问题,待解决
	...s llOEORDCode=""
	...s tlistind=$l(lstr,":")
	...s lOEORDCode=OEORDCode
	...f tmpi=1:1:tlistind d
	....s:llOEORDCode'="" llOEORDCode=llOEORDCode_":"_$p(lOEORDCode,":",tmpi)
	....s:llOEORDCode="" llOEORDCode=$p(lOEORDCode,":",tmpi)
	...s tmpoelistobj=..GetPROPERTY(objoe,llOEORDCode,lstr,1)
	...i $IsObject(tmpoelistobj)=0 d
	....d rtnObj.SetAt(..GetINSUUPLOADINFTOOBJ(subnode,Rowid,tmplstr,1,objoe,tplCode,tmpObj),tplCode)
	...e  d
	....s tmpcnt=0
	....s:tmpoelistobj.%ClassName()["List" tmpcnt=tmpoelistobj.Count()
	....d:tmpcnt=0 rtnObj.SetAt(..GetINSUUPLOADINFTOOBJ(subnode,Rowid,tmplstr,1,objoe,tplCode,tmpObj),tplCode)
	....q:tmpcnt=0
	....f j=1:1:tmpcnt d
	.....s $p(lstr,":",tlistind)=j
	.....i tlistind<$l(lOEORDCode,":") d
	......s llOEORDCode=llOEORDCode_":"_$p(lOEORDCode,":",tlistind+1)
	......s tmpoelistobj=..GetPROPERTY(objoe,llOEORDCode,lstr,1)
	......s tmpcnt2=0
	......s:tmpoelistobj.%ClassName()["List" tmpcnt2=tmpoelistobj.Count()
	......d:tmpcnt2=0 rtnObj.SetAt(..GetINSUUPLOADINFTOOBJ(subnode,Rowid,tmplstr,1,objoe,tplCode,tmpObj),tplCode)
	......f jj=1:1:tmpcnt2 d
	.......s $p(lstr,":",tlistind+1)=jj
	.......d rtnObj.SetAt(..GetINSUUPLOADINFTOOBJ(subnode,Rowid,tmplstr,1,objoe,tplCode,tmpObj),tplCode)
	.....e  d rtnObj.SetAt(..GetINSUUPLOADINFTOOBJ(subnode,Rowid,tmplstr,1,objoe,tplCode,tmpObj),tplCode)
	..;d rtnObj.SetAt(..GetINSUUPLOADINFTOOBJ(subnode,Rowid,tmplstr,1,objoe,tplCode,tmpObj),tplCode)
	..e  d rtnObj.SetAt(..GetINSUUPLOADINFTOOBJ(subnode,Rowid,tmplstr,1,objoe,tplCode,tmpObj),tplCode)
	.e  d
	..s tmpvalue=..GetPROPERTY(objoe,OEORDCode,lstr,"")
	..s typeData=rtnObj.%ClassName()
	..i typeData="%ListOfDataTypes" d
	...s lFlag=1
	...i rtnObj.Count()=0 d
	....i $IsObject(tmpObjSub)=0 d
	.....s tmpObjSub=##class(%ArrayOfDataTypes).%New() 
	...e  s tmpObjSub=rtnObj.GetAt(i)
	...d tmpObjSub.SetAt(..BuildValue(tmpvalue,defaultval),tplCode)
	...;d rtnObj.Insert(tmpObjSub)
	..e  d rtnObj.SetAt(..BuildValue(tmpvalue,defaultval),tplCode)
	i (lFlag=1)&($IsObject(tmpObjSub)) d
	.d rtnObj.Insert(tmpObjSub)
	q rtnObj
}

/// Creator: 詹明超
/// Description:根据模版和对象生成单条要上传的JSON信息串,调用前要先调用GetIDLIST函数完成初始化
/// Input:subnode:子节点名称,qRowid:表的rowid,lstr:对照的代码,i:行数,objoe:对象,itplCode:XML节点名称
/// 返回对象
ClassMethod GetINSUUPLOADINFTOOBJ(subnode As %String, qRowid As %Integer = 0, lstr As %String, i As %Integer, objoe, itplCode, ByRef inObj) As %ArrayOfDataTypes [ Internal ]
{
	s rtnObj=##class(%ArrayOfDataTypes).%New() 
	i $IsObject(inObj) d
	.s rtnObj=inObj
	s tmpObjSub="",lFlag=0,ii=i
	s:ii=0 ii=1
	s Rowid=""
	f  s Rowid=$o(^||INSUOEORDINFTOXML(subnode,Rowid)) q:Rowid=""  d
	.s subxml=""
	.s objxval=^||INSUOEORDINFTOXML(subnode,Rowid)
	.s PropType=$p(objxval,"^",1)
	.s ParRowid=+$p(objxval,"^",2)
	.s tplCode=$p(objxval,"^",3)
	.q:tplCode=""
	.s OEORDCode=..AutoBase64Decode($p(objxval,"^",5))
	.s defaultval=$p(objxval,"^",9)
	.q:(qRowid'=0)&(qRowid'=ParRowid)
	.q:(qRowid=0)&(ParRowid'=0)
	.s typeData=rtnObj.%ClassName()
	.i ..hasChildNODE(subnode,Rowid) d
	..s tmpObj=##class(%ArrayOfDataTypes).%New() 
	..s tmplstr=1
	..i PropType="LIST" d
	...s tmpObj=##class(%ListOfDataTypes).%New() 
	...s tmplstr=""
	...i lstr="" d
	....s tmplstr=1
	...e  s tmplstr=lstr_":"_1
	...;b ;zhan 2 bug,多于2个子集合时有问题,待解决
	...s llOEORDCode=""
	...s tlistind=$l(tmplstr,":")
	...s lOEORDCode=OEORDCode
	...f tmpi=1:1:tlistind d
	....s:llOEORDCode'="" llOEORDCode=llOEORDCode_":"_$p(lOEORDCode,":",tmpi)
	....s:llOEORDCode="" llOEORDCode=$p(lOEORDCode,":",tmpi)
	...s tmpoelistobj=..GetPROPERTY(objoe,llOEORDCode,tmplstr,1)
	...i $IsObject(tmpoelistobj)=0 d
	....i typeData="%ListOfDataTypes" d
	.....d rtnObj.GetAt(ii).SetAt(..GetINSUUPLOADINFTOOBJ(subnode,Rowid,tmplstr,1,objoe,tplCode,.tmpObj),tplCode)
	....e  d rtnObj.SetAt(..GetINSUUPLOADINFTOOBJ(subnode,Rowid,tmplstr,1,objoe,tplCode,.tmpObj),tplCode)
	...e  d
	....s tmpcnt=0
	....s:tmpoelistobj.%ClassName()["List" tmpcnt=tmpoelistobj.Count()
	....i tmpcnt=0 d
	.....i typeData="%ListOfDataTypes" d
	......d rtnObj.GetAt(ii).SetAt(..GetINSUUPLOADINFTOOBJ(subnode,Rowid,tmplstr,1,objoe,tplCode,.tmpObj),tplCode)
	.....e  d rtnObj.SetAt(..GetINSUUPLOADINFTOOBJ(subnode,Rowid,tmplstr,1,objoe,tplCode,.tmpObj),tplCode)
	....q:tmpcnt=0
	....f j=1:1:tmpcnt d
	.....s $p(tmplstr,":",tlistind)=j
	.....i tlistind<$l(lOEORDCode,":") d
	......s llOEORDCode=llOEORDCode_":"_$p(lOEORDCode,":",tlistind+1)
	......s tmpoelistobj=..GetPROPERTY(objoe,llOEORDCode,tmplstr,1)
	......s tmpcnt2=0
	......i $IsObject(tmpoelistobj) d
	.......s:tmpoelistobj.%ClassName()["List" tmpcnt2=tmpoelistobj.Count()
	......i tmpcnt2=0 d
	.......i typeData="%ListOfDataTypes" d
	........d rtnObj.GetAt(ii).SetAt(..GetINSUUPLOADINFTOOBJ(subnode,Rowid,tmplstr,j,objoe,tplCode,.tmpObj),tplCode)
	.......e  d rtnObj.SetAt(..GetINSUUPLOADINFTOOBJ(subnode,Rowid,tmplstr,j,objoe,tplCode,.tmpObj),tplCode)
	......f jj=1:1:tmpcnt2 d
	.......s $p(tmplstr,":",tlistind+1)=jj
	.......i typeData="%ListOfDataTypes" d 
	........d rtnObj.GetAt(ii).SetAt(..GetINSUUPLOADINFTOOBJ(subnode,Rowid,tmplstr,jj,objoe,tplCode,.tmpObj),tplCode)
	.......e  d rtnObj.SetAt(..GetINSUUPLOADINFTOOBJ(subnode,Rowid,tmplstr,jj,objoe,tplCode,.tmpObj),tplCode)
	.....e  d 
	......i typeData="%ListOfDataTypes" d 
	.......d rtnObj.GetAt(ii).SetAt(..GetINSUUPLOADINFTOOBJ(subnode,Rowid,tmplstr,j,objoe,tplCode,.tmpObj),tplCode)
	......e  d rtnObj.SetAt(..GetINSUUPLOADINFTOOBJ(subnode,Rowid,tmplstr,j,objoe,tplCode,.tmpObj),tplCode)
	..e  d 
	...i typeData="%ListOfDataTypes" d 
	....d rtnObj.GetAt(ii).SetAt(..GetINSUUPLOADINFTOOBJ(subnode,Rowid,tmplstr,1,objoe,tplCode,.tmpObj),tplCode)
	...e  d rtnObj.SetAt(..GetINSUUPLOADINFTOOBJ(subnode,Rowid,tmplstr,1,objoe,tplCode,.tmpObj),tplCode)
	.e  d
	..s tmpvalue=..GetPROPERTY(objoe,OEORDCode,lstr,i)
	..i typeData="%ListOfDataTypes" d
	...s lFlag=1
	...i (rtnObj.Count()=0)||(rtnObj.Count()<i) d
	....i $IsObject(tmpObjSub)=0 d
	.....s tmpObjSub=##class(%ArrayOfDataTypes).%New() 
	....d rtnObj.Insert(tmpObjSub)
	...d rtnObj.GetAt(i).SetAt(..BuildValue(tmpvalue,defaultval),tplCode)
	..e  d rtnObj.SetAt(..BuildValue(tmpvalue,defaultval),tplCode)
	;i (lFlag=1)&($IsObject(tmpObjSub)) d
	.;d rtnObj.Insert(tmpObjSub)
	;b ;zhan end
	q rtnObj
}

// -----------------------------------------------------------------------

/// Creator: 詹明超
/// Description:生成节点XML串
/// Input: NODE:节点名称,value：节点值,dftvalstr:扩展串(默认值|最大值|默认值类型)
ClassMethod BuildXMLNODE(NODE As %String, value, dftvalstr As %String) As %String [ Internal ]
{
	s xmlnode=""
	q:NODE="" ""
	s cnt=0
	s value=$tr(value,"<","")
	s value=$tr(value,">","")
	i $l(dftvalstr,"|")>2 {
		s tmpval=$$ALPHAUP^SSUTIL4(value)
		s defval=$p(dftvalstr,"|",1)
		s deflen=+$p(dftvalstr,"|",2)
		s deftype=$$ALPHAUP^SSUTIL4($p(dftvalstr,"|",3))
		;s:((value="")||(value=" "))&((deftype["CHAR")||(deftype["STRING")) value=""
		;s:((value="")||(value=" "))&((deftype["INT")||(deftype["NUM")) value=0
		s:((tmpval="")||(tmpval=" ")||(tmpval="NULL")||(tmpval="UNDEFINED")) value=defval
		s:((deftype["INT")||(deftype["NUM")) value=+value
		s:($l(tmpval)>deflen)&(deflen>0) value=$e(tmpval,1,deflen)
	}
	;s:value'="" xmlnode="<"_NODE_">"_value_"</"_NODE_">"
	s xmlnode="<"_NODE_">"_value_"</"_NODE_">"
	q xmlnode
}

/// Creator: 詹明超
/// Description:生成节点字符串
/// Input: NODE:节点名称,value：节点值,dftvalstr:扩展串(默认值|最大值|默认值类型)
ClassMethod BuildNODE(NODE As %String, value, dftvalstr As %String) As %String [ Internal ]
{
	s strnode=""
	q:NODE="" ""
	s cnt=0
	s value=$tr(value,"<","")
	s value=$tr(value,">","")
	i $l(dftvalstr,"|")>2 {
		s tmpval=$$ALPHAUP^SSUTIL4(value)
		s defval=$p(dftvalstr,"|",1)
		s deflen=+$p(dftvalstr,"|",2)
		s deftype=$$ALPHAUP^SSUTIL4($p(dftvalstr,"|",3))
		s:((tmpval="")||(tmpval=" ")||(tmpval="NULL")||(tmpval="UNDEFINED")) value=defval
		s:((deftype["INT")||(deftype["NUM")) value=+value
		s:($l(tmpval)>deflen)&(deflen>0) value=$e(tmpval,1,deflen)
	}
	s:value'="" strnode=$tr(value,"|","")
	q strnode
}

/// Creator: 詹明超
/// Description:生成节点JSON串
/// Input: value：节点值,dftvalstr:扩展串(默认值|最大值|默认值类型)
ClassMethod BuildValue(value As %String, dftvalstr As %String) As %String [ Internal ]
{
	;q:value="" ""
	s value=$tr(value,"{","")
	s value=$tr(value,"}","")
	i $l(dftvalstr,"|")>2 {
		s tmpval=$$ALPHAUP^SSUTIL4(value)
		s defval=$p(dftvalstr,"|",1)
		s deflen=+$p(dftvalstr,"|",2)
		s deftype=$$ALPHAUP^SSUTIL4($p(dftvalstr,"|",3))
		;s:((value="")||(value=" "))&((deftype["CHAR")||(deftype["STRING")) value=""
		;s:((value="")||(value=" "))&((deftype["INT")||(deftype["NUM")) value=0
		s:((tmpval="")||(tmpval=" ")||(tmpval="NULL")||(tmpval="UNDEFINED")) value=defval
		s:((deftype["INT")||(deftype["NUM")) value=+value
		i deftype="DATE" d
		.i value["年" d
		..s value=$tr($p(value,"日",1),"年","-")
		..s value=$tr(value,"月","-")
		..s:$l($p(value,"-",2))=1 $p(value,"-",2)=0_$p(value,"-",2)
		..s:$l($p(value,"-",3))=1 $p(value,"-",3)=0_$p(value,"-",3)
		s:($l(tmpval)>deflen)&(deflen>0) value=$e(tmpval,1,deflen)
	}
	q value
}

/// Creator: 詹明超
/// Description:判断模版中一个节点是否有子节点,如果就返回子节点rowid,内部调用
/// Input:subnode:节点名称,qRowid：表的rowid
ClassMethod hasChildNODE(subnode As %String, qRowid As %Integer) As %Integer [ Internal ]
{
	q:$d(^||INSUOEORDINFTOXMLOLE(subnode,qRowid))=0 0
	q $p(^||INSUOEORDINFTOXMLOLE(subnode,qRowid),"^",7)	//子节点rowid
}

/// Creator: 詹明超
/// Description:判断模版中一个节点是否有子节点,返回1时说明有子节点,内部调用
/// Input:]qRowid：表的rowid
ClassMethod hasChildNODENew(qRowid As %Integer) As %Integer [ Internal ]
{
	/*
	s hasChildn=0
	s IdxGlobaln=$g(^oddCOM("User.INSUUploadInfoCon","s","Default",24))
	s Rowidn=""
	f  s Rowidn=$o(@IdxGlobaln@(Rowidn)) q:(Rowidn="")||(hasChildn=1)  d
	.q:##class(User.INSUUploadInfoCon).%ExistsId(Rowidn)=0
	.s objn=##class(User.INSUUploadInfoCon).%OpenId(Rowidn)
	.s ParRowidn=+objn.ParRowid
	.q:ParRowidn=0
	.q:ParRowidn'=qRowid
	.s hasChildn=1
	*/
	s hasChildn=1
	q:$d(^User.INSUUploadInfoConI("IndexOfParId",qRowid))=0 0
	q hasChildn
}

/// Creator: 詹明超
/// Description:base64解密
ClassMethod AutoBase64Decode(inStr As %String) As %String [ Internal ]
{
	q:inStr="" ""
	q $ZCONVERT(##class(%SYSTEM.Encryption).Base64Decode(inStr),"I","UTF8")
}

/// Creator: 詹明超
/// Description:根据对象和属性名称取属性的值
/// Input:iobj:对象,Ainnode:节点名称或类方法,StrInd:对照的属性串,gFlag:行取值标志
/// 返回字符串
ClassMethod GetPROPERTYBak(iobj, Ainnode As %String, StrInd As %String, gFlag As %String) As %String [ Internal ]
{
	s rtnval=""
	q:Ainnode="" rtnval
	;s $ZTrap = "GetPROPERTYEx"	//如果老库不支持try,就用$ZTrap
	try{
	    ;s:$l(node)>20 node=##class(%SYSTEM.Encryption).Base64Decode(node) ;DingSH 加密节点或函数表达式解密
		;s node=##class(%SYSTEM.Encryption).Base64Decode(innode)
		;s node=$p(Ainnode,":",StrInd)
		s node=Ainnode
		i (node["||")||(node["&")||(node["{")||(node["#")||(node["^") {
			s exStr=""
			i node["{" {
				f i=1:1:($l(node,"{")-1) d
				.s tmpspsval=""
				.s tmpsps1=$p(node,"}",i)
				.s tmpsps2=$p(node,"}",i+1)
				.s tmpsps=$p(tmpsps1,"{",2)
				.i tmpsps[":" d
				..s tmpspsval=..PropertyList(iobj,tmpsps)
				.e  s:tmpsps'="" tmpspsval=$zobjproperty(iobj,tmpsps)
				.i exStr=""  d
				..s exStr=$p(tmpsps1,"{",1)_""""_tmpspsval_""""_$P(tmpsps2,"{",1)
				.e  d
				..s exStr=exStr_""""_tmpspsval_""""_$P(tmpsps2,"{",1)
				i exStr["||" {
					f i=1:1:$l(exStr,"||") d
					.s tmpspsval=""
					.s tmpsps=exStr ;$p(exStr,"||",i)
					.s:($l(tmpsps,"#")>1)||($l(tmpsps,"^")>1) tmpspsval=$$XECUTEN^INSUFUN(tmpsps)
					.i tmpspsval'="" d
					..s rtnval=tmpspsval
					.e  s rtnval=tmpsps
				e  i exStr["&"  d
					.f i=1:1:$l(exStr,"&") d
					..s tmpspsval=""
					..s tmpsps=$p(exStr,"&",i)
					..s:($l(tmpsps,"#")>1)||($l(tmpsps,"^")>1) tmpspsval=$$XECUTEN^INSUFUN(tmpsps)
					..i rtnval="" d
					...s rtnval=tmpspsval
					..e  s rtnval=rtnval_tmpspsval	
				}else{
					s:($l(exStr,"#")>1)||($l(exStr,"^")>1) rtnval=$$XECUTEN^INSUFUN(exStr)
				}
			}else{
				s:($l(node,"#")>1)||($l(node,"^")>1) rtnval=$$XECUTEN^INSUFUN(node)
			}
		}else{
			s tmply=$l(Ainnode,":")
			s tmpobj=iobj
			f li=1:1:tmply {
				s node=$p(Ainnode,":",li)
				s tmpobj=$zobjPROPERTY(tmpobj,node)	;//新库用$PROPERTY
				i $IsObject(tmpobj) {
					i (tmpobj.%ClassName()["List") {
						s tmpind=+$p(StrInd,":",li)
						i tmpind=0{
							s:gFlag'=1 tmpobj=tmpobj.GetAt(1)
						}else{
							s:(li'=tmply) tmpobj=tmpobj.GetAt(tmpind)
						}
					}
				}
			}
			s rtnval=tmpobj
		}
	}catch bs64err{
		;w bs64err.Location_","_bs64err.Data_" is "_bs64err.Name_",Ainnode:"_Ainnode,",StrInd:"_StrInd,!
		s rtnval=Ainnode
		s:$l(rtnval,":")>1 rtnval=""
	}
	;------如果项目不支持try则放开------->
	;GetPROPERTYEx	
	;s rtnval=Ainnode_""_$ze
	;s:$l(rtnval,":")>1 rtnval=""	
	;<-----------------------------------//
	q rtnval
}

ClassMethod GetPROPERTY(iobj, Ainnode As %String, StrInd As %String, gFlag As %String) As %String [ Internal ]
{
	s rtnval=""
	q:Ainnode="" rtnval
	s $ZTrap = "GetPROPERTYEx"
	s node=Ainnode
	i (node["||")||(node["&")||(node["{")||(node["#")||(node["^") {
		s exStr=""
		i node["{" {
			f i=1:1:($l(node,"{")-1) d
			.s tmpspsval=""
			.s tmpsps1=$p(node,"}",i)
			.s tmpsps2=$p(node,"}",i+1)
			.s tmpsps=$p(tmpsps1,"{",2)
			.i tmpsps[":" d
			..s tmpspsval=..PropertyList(iobj,tmpsps)
			.e  s:tmpsps'="" tmpspsval=$zobjproperty(iobj,tmpsps)	;$property
			.i tmpspsval["||" d
			..s tmpspsval=$replace(tmpspsval,"||","`@`")	;
			.i exStr=""  d
			..s exStr=$p(tmpsps1,"{",1)_""""_tmpspsval_""""_$P(tmpsps2,"{",1)
			.e  d
			..s exStr=exStr_""""_tmpspsval_""""_$P(tmpsps2,"{",1)
			s exStr=$replace(exStr,"`@`","||")	;
			i exStr["||"  d
			.f i=1:1:$l(exStr,"||") d
			..s tmpspsval=""
			..s tmpsps=$p(exStr,"||",i)	;exStr
			..;s:($l(tmpsps,"#")>1)||($l(tmpsps,"^")>1) tmpspsval=$$XECUTEN^INSUFUN(tmpsps)
			..i ($l(tmpsps,"#")>1)||($l(tmpsps,"^")>1)||($l(node,"$")>1) d
			...s tmpspsval=$$XECUTEN^INSUFUN(tmpsps)
			..e  d
			...i tmpsps[$c(34) d
			....s tmpspsval=tmpsps
			...e  s tmpspsval=$zobjproperty(iobj,tmpsps)
			..i tmpspsval'="" d
			...s rtnval=tmpspsval
			..;e  s rtnval=tmpsps	;
			e  i exStr["&"  d
			.f i=1:1:$l(exStr,"&") d
			..s tmpspsval=""
			..s tmpsps=$p(exStr,"&",i)
			..;s:($l(tmpsps,"#")>1)||($l(tmpsps,"^")>1) tmpspsval=$$XECUTEN^INSUFUN(tmpsps)
			..i ($l(tmpsps,"#")>1)||($l(tmpsps,"^")>1)||($l(node,"$")>1)  d
			...s tmpspsval=$$XECUTEN^INSUFUN(tmpsps)
			..e  d
			...i tmpsps[$c(34) d
			....s tmpspsval=$replace(tmpsps,$c(34),"")
			...e  s tmpspsval=$zobjproperty(iobj,tmpsps)
			..i rtnval="" d
			...s rtnval=tmpspsval
			..e  s rtnval=rtnval_tmpspsval	
			e  d
			.s:($l(exStr,"#")>1)||($l(exStr,"^")>1)||($l(node,"$")>1) rtnval=$$XECUTEN^INSUFUN(exStr)
		}else{
			i ($l(node,"#")>1)||($l(node,"^")>1) d
			.s rtnval=$$XECUTEN^INSUFUN(node)
			e  d
			.s exStr=node
			.i exStr["||"  d
			..f i=1:1:$l(exStr,"||") d
			...s tmpspsval=""
			...s tmpsps=$p(exStr,"||",i)	;exStr
			...;s tmpspsval=$zobjproperty(iobj,tmpsps)			
			...i tmpsps[$c(34) d
			....s tmpspsval=$replace(tmpsps,$c(34),"")
			...e  s tmpspsval=$zobjproperty(iobj,tmpsps)			
			...i tmpspsval'="" d
			....s rtnval=tmpspsval
			...;e  s rtnval=tmpsps	;
			.e  i exStr["&"  d
			..f i=1:1:$l(exStr,"&") d
			...s tmpspsval=""
			...s tmpsps=$p(exStr,"&",i)
			...i tmpsps[$c(34) d
			....s tmpspsval=$replace(tmpsps,$c(34),"")
			...e  s tmpspsval=$zobjproperty(iobj,tmpsps)
			...i rtnval="" d
			....s rtnval=tmpspsval
			...e  s rtnval=rtnval_tmpspsval	
		}
	}else{
		s tmply=$l(Ainnode,":")
		s tmpobj=iobj
		f li=1:1:tmply {
			s node=$p(Ainnode,":",li)
			s tmpobj=$zobjproperty(tmpobj,node)	;$property
			i $IsObject(tmpobj) {
				i (tmpobj.%ClassName()["List") {
					s tmpind=+$p(StrInd,":",li)
					i tmpind=0{
						s:gFlag'=1 tmpobj=tmpobj.GetAt(1)
					}else{
						s:(li'=tmply) tmpobj=tmpobj.GetAt(tmpind)
					}
				}
			}
		}
		s rtnval=tmpobj
	}
	q rtnval
GetPROPERTYEx	
	s rtnval=Ainnode_""_$ze
	s:$l(rtnval,":")>1 rtnval=""	
	q rtnval
}

/// Creator: 詹明超
/// Description:生成模版临时GLOBAL,内部用
/// Input:insutype:医保类型,bsytype:业务类型
/// 返回临时global根节点
ClassMethod GetIDLISTBak(insutype As %String, bsytype As %String, hospDr As %String) As %String [ Internal ]
{
	s subnode=$i(^||INSUOEORDINFTOXML)
	s IdxGlobal=$g(^oddCOM("User.INSUUploadInfoCon","s","Default",24))
	s Rowid=""
	f  s Rowid=$o(@IdxGlobal@(Rowid)) q:Rowid=""  d
	.q:##class(User.INSUUploadInfoCon).%ExistsId(Rowid)=0
	.s GetIDLIST=##class(User.INSUUploadInfoCon).%OpenId(Rowid)
	.q:(GetIDLIST.BSYType'=bsytype)&(bsytype'="")
	.q:(GetIDLIST.InsuType'=insutype)&(insutype'="")
	.q:(GetIDLIST.Hospital'=hospDr)&(hospDr'="")	//ZHAN 20200401增加院区
	.s hassubnodeflag=..hasChildNODENew(Rowid)
	.s ^||INSUOEORDINFTOXML(subnode,Rowid)=GetIDLIST.PropType_"^"_GetIDLIST.ParRowid_"^"_GetIDLIST.tplCode_"^"_GetIDLIST.tplDesc_"^"_GetIDLIST.ConCode_"^"_GetIDLIST.ConDesc_"^"_hassubnodeflag_"^"_GetIDLIST.BSYType_"^"_GetIDLIST.ExtStr1
	m ^||INSUOEORDINFTOXMLOLE=^||INSUOEORDINFTOXML
	q subnode
}

/// ZHAN 20200401增加院区,改为直接global取数据提高效率[ Internal ]
ClassMethod GetIDLIST(insutype As %String, bsytype As %String, hospDr As %String) As %String
{
	s subnode=$i(^||INSUOEORDINFTOXML)
	s IdxGlobal=$g(^oddCOM("User.INSUUploadInfoCon","s","Default",25))
	s CheckHosipitalGroup=##class(web.DHCBILLINSUCloudCommon).GetINSUGroupDefaultHospId("INSU_UploadInfoCon",hospDr)
	q:CheckHosipitalGroup="" subnode
	s Rowid=""
	;f  s Rowid=$o(@IdxGlobal@("IDataHosInsuBSY",CheckHosipitalGroup,insutype,bsytype,Rowid)) q:Rowid=""  d
	f  s Rowid=$o(@IdxGlobal@("IndexOfBSY",CheckHosipitalGroup,insutype,bsytype,Rowid)) q:Rowid=""  d ;DingSH 20210517 修改
	.q:'$d(^User.INSUUploadInfoConD(Rowid))
	.;s GetIDLIST=##class(User.INSUUploadInfoCon).%OpenId(Rowid)
	.s GetIDLB=^User.INSUUploadInfoConD(Rowid)
	.q:($list(GetIDLB,3)'=bsytype)&(bsytype'="")
	.q:($list(GetIDLB,2)'=insutype)&(insutype'="")
	.q:$list(GetIDLB,15)=""
	.;s TemphosGrp=##class(web.DHCBILLINSUCloudCommon).GetINSUGroupDefaultHospId("INSU_UploadInfoCon1",$list(GetIDLB,15))
	.;q:TemphosGrp'=CheckHosipitalGroup
	.s conCode=$list(GetIDLB,8)
	.s conDesc=$list(GetIDLB,9)
	.;s TemphosGrpCon=##class(web.DHCBILLINSUCloudCommon).GetINSUGroupDefaultHospId("INSU_UploadInfoCon",$list(GetIDLB,15))
	.;i TemphosGrpCon'=CheckHosipitalGroup d
	..;s conCode=""
	..;s conDesc=""
	.s hassubnodeflag=..hasChildNODENew(Rowid)
	.s ^||INSUOEORDINFTOXML(subnode,Rowid)=$list(GetIDLB,4)_"^"_$list(GetIDLB,5)_"^"_$list(GetIDLB,6)_"^"_$list(GetIDLB,7)_"^"_conCode_"^"_conDesc_"^"_hassubnodeflag_"^"_$list(GetIDLB,3)_"^"_$list(GetIDLB,10)
	m ^||INSUOEORDINFTOXMLOLE=^||INSUOEORDINFTOXML
	q subnode
}

/// Creator: 詹明超
/// Description:根据配置的属性串取对象的值,内部用
/// Input:iobj:对象,tmpsps:配置的属性串
ClassMethod PropertyList(iobj, tmpsps As %String) As %String [ Internal ]
{
	s iobjList=$zobjPROPERTY(iobj,$p(tmpsps,":",1))	;//新库可用$PROPERTY
	i tmpsps[":" d
	.i iobjList.%ClassName()["List" d
	..s tmpspsval=..PropertyList(iobjList.GetAt(1),$p(tmpsps,":",2))
	.e  d  s tmpspsval=..PropertyList(iobjList,$p(tmpsps,":",2))
	.s iobjList=tmpspsval
	q iobjList
}

}
