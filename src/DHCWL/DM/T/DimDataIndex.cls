/// Created by lihaihong on 2017/3/17.
/// 作为DimDStruct的数据索引表使用
Class DHCWL.DM.T.DimDataIndex Extends %Persistent
{

Property DimBase As DimBase [ Required ];

Property DimPro As DimProperty [ Required ];

Property DimValue As %String [ Required ];

// dim rowKey

Property DDSId As %String [ Required ];

Index MainI On (DimBase, DimPro, DimValue As EXACT);

// Index IDKEY On (DimBase,DDSId)[ Idkey ] ;

ClassMethod InsertBuildIndex(list) As %Status
{
	s db=$list(list,1),dp=$list(list,2),dv=$list(list,3),ddsid=$list(list,4)
	;if ( ($d(^DHCWL.DM.T.DimDataIndexD(db))) && ($d(^DHCWL.DM.T.DimDataIndexD(db,ddsid)))) d
	;.s id=db_"||"_ddsid
	;.&sql(UPDATE DHCWL_DM_T.DimDataIndex set DimValue=:dv,DDSId=:ddsid where ID=:id)
	;if ( ( $d(^DHCWL.DM.T.DimDataIndexI("MainI",db)) ) && ( $d(^DHCWL.DM.T.DimDataIndexI("MainI",db,dp)) ) && ( $d(^DHCWL.DM.T.DimDataIndexI("MainI",db,dp,dv)) ) ) d
	;if ( ( $d(^DHCWL.DM.T.DimDataIndexD(db)) ) && ( $d(^DHCWL.DM.T.DimDataIndexD(db,dp)) ) && ( $d(^DHCWL.DM.T.DimDataIndexD(db,dp,dv)) ) ) d
	;.s id=db_"||"_dp_"||"_dv ;$o( ^DHCWL.DM.T.DimDataIndexI("MainI",dp,dv,ddsid,"") )
	;.&sql(UPDATE DHCWL_DM_T.DimDataIndex set DimValue=:dv,DDSId=:ddsid where ID=:id)
	;.w "update:SQLCODE="_SQLCODE
	;e  d
	;.&sql(INSERT INTO DHCWL_DM_T.DimDataIndex(DimBase,DimPro,DimValue,DDSId) values (:db,:dp,:dv,:ddsid))
	;.w "insert:SQLCODE="_SQLCODE
	&sql(INSERT INTO DHCWL_DM_T.DimDataIndex(DimBase,DimPro,DimValue,DDSId) values (:db,:dp,:dv,:ddsid))
	i SQLCODE=0 q $$$OK
	q $$$ERROR("SQLCODE="_SQLCODE)
}

ClassMethod UpdateBuildIndex(list, oldDv) As %Status
{
	s db=$list(list,1),dp=$list(list,2),dv=$list(list,3),ddsid=$list(list,4)
	if ( (oldDv'="")&&( $d(^DHCWL.DM.T.DimDataIndexI("MainI",db)) ) && ( $d(^DHCWL.DM.T.DimDataIndexI("MainI",db,dp)) ) && ( $d(^DHCWL.DM.T.DimDataIndexI("MainI",db,dp,oldDv)) ) ) d
	.s id=$o( ^DHCWL.DM.T.DimDataIndexI("MainI",db,dp,oldDv,"") )
	.&sql(UPDATE DHCWL_DM_T.DimDataIndex set DimValue=:dv,DDSId=:ddsid where ID=:id)
	;.w "update:SQLCODE="_SQLCODE
	;e  d
	;.&sql(INSERT INTO DHCWL_DM_T.DimDataIndex(DimBase,DimPro,DimValue,DDSId) values (:db,:dp,:dv,:ddsid))
	;.w "insert:SQLCODE="_SQLCODE
	e  d
	.&sql(INSERT INTO DHCWL_DM_T.DimDataIndex(DimBase,DimPro,DimValue,DDSId) values (:db,:dp,:dv,:ddsid))
	i SQLCODE=0 q $$$OK
	q $$$ERROR("SQLCODE="_SQLCODE)
}

ClassMethod DeleteDimIndex(dimId) As %Status
{
	&sql(DELETE DHCWL_DM_T.DimDataIndex where DimBase=:dimId)
	i SQLCODE=0 q $$$OK
	q $$$ERROR("SQLCODE="_SQLCODE)
}

ClassMethod BacksteppingFromeFilter(node As DHCWL.DM.Util.FilterTree, funCall As DHCWL.DM.Util.FunctionCall, ByRef targetDims As %List, ByRef proFunStruct, isDim As %Boolean = 0) As %Status
{
	k targetDims
	s status=$$$OK
	s SQLF("=")="in",SQLF("NE")="!=",SQLF(">")=">",SQLF(">=")=">=",SQLF("<")="<",SQLF("<=")="<=",SQLF("'=")="!=",SQLF("[")="LIKE"
	s SQLF("notnull")="IS NOT NULL",SQLF("isnull")="IS NULL",SQLF("like")="LIKE"
	s dimStructList=node.DimStruct
	s function=node.FilterFunction
	s params=node.Params
	s proFunStruIndex=node.proFunStructIndex
	s len=$ll(dimStructList)
	s dimId=$lg(dimStructList,len-3)
	s proId=$lg(dimStructList,len-2)
	s sn=$lg(dimStructList,len-1)
	s dtype=$lg(dimStructList,len,"")
	s funType="MO"
	s:'$d(SQLF(function)) funType=funCall.FunctionConfig.SubType
	s proFunIndex=len\4
	i (len#4)>0 s proFunIndex=proFunIndex+1
	s count=0
	if funType="MO" && $d(SQLF(function)){
	  s funType="SQL"
	}
	k map
	s targetDims=$lb()
	i (funType="I"){
	  s count=0
	  if dtype [ "#"{
	    s ssid="" f{
			  s ssid=$o(^DHCWL.DM.T.DimDStructD(dimId,ssid))
			  q:ssid=""
			  s v=$$proFunFilter()
			  i funCall.Call($lb(v)) {
				  s map(v)=""  //s map(ssid)=""
			    ;s count=count+1 
			    ;s $list(targetDims,count)=v ;ssid
			  }
	    } 
	  }else{
			if $d(^DHCWL.DM.T.DimDataIndexI("MainI",dimId,proId)){
			  s v="" f {
			    s v=$o(^DHCWL.DM.T.DimDataIndexI("MainI",dimId,proId,v))
			    q:v=""
			    i funCall.Call($lb(v)) {
			      ;s count=count+1
			      s id=$o(^DHCWL.DM.T.DimDataIndexI("MainI",dimId,proId,v,""))
			      s ssid=$lg(^DHCWL.DM.T.DimDataIndexD(id),5)
			      ;s $list(targetDims,count)=v ;ssid
			      s map(v)=""
			    }
			  }
	    }
	  }
	  
	}elseif (funType="C"){
	  s tdl=0
	  if dtype [ "#"{
			s canChoiceList=funCall.Call()
			s ccll=$ll(canChoiceList)
			k choiceMap
			f ccli=1:1:ccll {
			  s v=$lg(canChoiceList,i)
			  s:v'="" choiceMap(v)=""
			}
			s ssid="" f{
				s ssid=$o(^DHCWL.DM.T.DimDStructD(dimId,ssid))
				q:ssid=""
				s v=$$proFunFilter()
				i $d(choiceMap(v)) {
					s map(v)=""
					;s count=count+1 
					;s $list(targetDims,count)=v ;ssid
				}
		  } 
	  }elseif $d(^DHCWL.DM.T.DimDataIndexI("MainI",dimId,proId)){
			s canChoiceList=funCall.Call()
	    s ccll=$ll(canChoiceList)
	    f ccli=1:1:ccll {
		  	s v=$lg(canChoiceList,i)
		  	if $d(^DHCWL.DM.T.DimDataIndexI("MainI",dimId,proId,v)) {	
		  		s id=$o(^DHCWL.DM.T.DimDataIndexI("MainI",dimId,proId,v,""))
		  		s ssid=$lg(^DHCWL.DM.T.DimDataIndexD(id),5)
		  		s map(v)=""
		  		;s tdl=tdl+1
		  		;s $list(targetDims,tdl)=v ;ssid
		  	}
	    }
	  }
	  
	}elseif (funType="SQL"){
	  if ((dtype [ "#")&&( $d(SQLF(function)))){
			s paramValue=$lg(params,1)
	    s ssid="" f{
			  s ssid=$o(^DHCWL.DM.T.DimDStructD(dimId,ssid))
			  q:ssid=""
			  s v=$$proFunFilter()
			  s flag=""
			  s exeStr="s out=v1"_function_"v2"
			  x ("(v1,v2,out)"_exeStr,v,paramValue,.flag)
			  i flag {
			    ;s count=count+1 
			    ;s $list(targetDims,count)=v ;ssid
			    s map(v)=""
			  }
	    } 
	  }elseif $d(SQLF(function)) {
	    s result=##class(%ResultSet).%New("%DynamicQuery:SQL")
	    s paramValue=$lg(params,1)
	    if ($e(paramValue,1)="'") && ($e(paramValue,$l(paramValue))="'"){
			  s paramValue=$e(paramValue,2,$l(paramValue)-1)
	    }
	    i function="[" {
	      s paramValue="%"_paramValue_"%"
	    }
	    s dt=+$lg(dimStructList,len,12)
	    if dt=12 {
			  s paramValue="'"_paramValue_"'"
	    }
	    if SQLF(function)="in"{
		    f paraind=1:1:$ll(params){
			    s paramValue=$lg(params,paraind)
			    if dt=12 {
				    if ($e(paramValue,1)'="'") && ($e(paramValue,$l(paramValue))'="'"){
					    s paramValue="'"_paramValue_"'"
				    }
			    }
			    s $list(params,paraind)=paramValue
		    }
		    s paramValue="("_$lts(params,",",1)_")"
	    }
	    s sql="SELECT DDSId,DimValue FROM DHCWL_DM_T.DimDataIndex WHERE DimBase="_dimId_" and DimPro="_proId_" and DimValue "_SQLF(function)_" "_paramValue
	    ;b ;1
	    if (function="notnull")||(function="isnull"){
		    s sql="SELECT DDSId,DimValue FROM DHCWL_DM_T.DimDataIndex WHERE DimBase="_dimId_" and DimPro="_proId_" and DimValue "_SQLF(function)
	    }
	    s sc=result.Prepare(sql)
	    i $$$ISERR(sc) {
	      Do DisplayError^%apiOBJ(sc)
	      w !,"Error sql:"_sql,!
	      s status=sc
	      q status
	    }
	    s sc=result.Execute() 
	    i $$$ISERR(sc) {
	      s status=sc
	      q status
	    }
	    s list=$lb()
	    while ( result.Next(.sc) ) {
	      If $$$ISERR(sc) Quit
	      s map(result.Data("DimValue"))=""
	    }
	    /*s id="",i=1 f  {
	      s id=$o(map(id)) 
	      q:id=""
	      s $list(list,i)=id
	      s i=i+1
	    }
	    s targetDims=list*/
	  }
	}elseif (funType="MO"){
		if function="between"{
			b ;1
			s stvalue=$lg(params,1,"")
			s edvalue=$lg(params,2,"")
			if (stvalue'="")&&(edvalue'=""){
				if (dtype=91){
					s stvalue=$zdh(stvalue,3)
					s edvalue=$zdh(edvalue,3)
				}
				s v=$o(^DHCWL.DM.T.DimDataIndexI("MainI",dimId,proId,stvalue),-1)
				s ved=$o(^DHCWL.DM.T.DimDataIndexI("MainI",dimId,proId,edvalue))
				;s i=1,list=$lb()
				f{
					s v=$o(^DHCWL.DM.T.DimDataIndexI("MainI",dimId,proId,v))
					q:(v="")||(v=ved)
					s id=""
					s id=$o(^DHCWL.DM.T.DimDataIndexI("MainI",dimId,proId,v,id))
					if id'=""{
						;s $list(list,i)=v
						;s i=i+1
						s map(v)=""
					}
					/*
					s id="" f{
						s id=$o(^DHCWL.DM.T.DimDataIndexI("MainI",dimId,proId,v,id))
						q:id=""
						s $list(list,i)=v
						s i=i+1
					}*/
				}
				;s targetDims=list
			}
		}
	}
	s v="",i=1 f  {
		s v=$o(map(v)) 
		q:v=""
		s $list(targetDims,i)=v
		s i=i+1
	}
  if len >4 {
	  //s targetDims=##class(DimDStruct).BacksteppingId(targetDims,$list(dimStructList,1,len-4),.proFunStruct,proFunStruIndex,"F",isDim)
	  s targetDims=##class(DimDStruct).BacksteppingId(targetDims,dimStructList,.proFunStruct,proFunStruIndex,"F",isDim)
	}
	q status
proFunFilter()
	q ##class(DimDStruct).ResolveProFun(ssid,proFunStruIndex,proFunIndex,.proFunStruct,"F")
}

Storage Default
{
<Data name="DimDataIndexDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DimBase</Value>
</Value>
<Value name="3">
<Value>DimPro</Value>
</Value>
<Value name="4">
<Value>DimValue</Value>
</Value>
<Value name="5">
<Value>DDSId</Value>
</Value>
</Data>
<DataLocation>^DHCWL.DM.T.DimDataIndexD</DataLocation>
<DefaultData>DimDataIndexDefaultData</DefaultData>
<IdLocation>^DHCWL.DM.T.DimDataIndexD</IdLocation>
<IndexLocation>^DHCWL.DM.T.DimDataIndexI</IndexLocation>
<StreamLocation>^DHCWL.DM.T.DimDataIndexS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
