Class web.DHCSTIPQUERYBROKER Extends %RegisteredObject [ Not ProcedureBlock ]
{

ClassMethod RecQueryExcute(className As %String, classQuery As %String) As %String
{
	s $zt="err"
	//d ##class(Nur.QueryBroker).QueryExcute("web.DHCNurHCRecComm","GetCareRecComm")
	s rs=##class(%Library.ResultSet).%New(className_":"_classQuery)
	//s ^TMP("abc")=$G(%request.Data("sid",1))
	s x="d rs.Execute("
	//s parr="337862^2011-03-11^00:00^2012-04-12^00:00^DHCNUR6^false^1_9"
   // s parr="337862^2011-04-16^00:00^2012-04-17^00:00^DHCNUR6^false^1_9"
	s parametersNum=rs.GetParamCount()
	f i=1:1:parametersNum {
		s parameterName=rs.GetParamName(i)
		s parameterVal=$g(%request.Data(parameterName,1))
		//s ^TMP("par",parameterName)=%request.Data("parr",1)
		s x=x_""""_parameterVal_""""
		i i'=parametersNum s x=x_","
	}
	s x=x_")"
	x x
	d ..GetQueryDataA(rs)
	q ""
err
	s ^pjf(1)=$ze
}

ClassMethod QueryExcute(className As %String, classQuery As %String) As %String
{
	//d ##class(Nur.QueryBroker).QueryExcute("web.DHCNurCom","FindMasterItem")
	s rs=##class(%Library.ResultSet).%New(className_":"_classQuery)
	s x="d rs.Execute("
	s parametersNum=rs.GetParamCount()
	f i=1:1:parametersNum {
		s parameterName=rs.GetParamName(i)
		s parameterVal=$g(%request.Data(parameterName,1))
		s x=x_""""_parameterVal_""""
		i i'=parametersNum s x=x_","
	}
	s x=x_")"
	s ^TMP("q")=x
	x x
	d ..GetQueryData(rs)
	q ""
}

ClassMethod QueryExcute1(className As %String, classQuery As %String) As %String
{
	//d ##class(Nur.QueryBroker).QueryExcute1("web.DHCDocOrderEntry","LookUpItem")
	s rs=##class(%Library.ResultSet).%New(className_":"_classQuery)
	s x="d rs.Execute("
	s parametersNum=rs.GetParamCount()
	f i=1:1:parametersNum {
		s parameterName=rs.GetParamName(i)
		s parameterVal="" //$g(%request.Data(parameterName,1))
		s x=x_""""_parameterVal_""""
		i i'=parametersNum s x=x_","
	}
	s x=x_")"
	s ^TMP("q")=x
	x x
	d ..GetQueryData(rs)
	q ""
}

ClassMethod MethodExcute(className As %String, methodName As %String) As %String
{
	//d ##class(Nur.Android.QueryBroker).MethodExcute("web.DHCNurCom","FindMasterItem")
	//d ##class(Nur.Android.QueryBroker).MethodExcute("Nur.Iphone.Common","logon")
	s x="s ret=##class("_className_")."_methodName_"("
	s parametersNum=..GetParamCount(className,methodName)
	
	f i=1:1:parametersNum{
		s parameterName=..GetParamName(className,methodName,i)
		
		s parameterVal=$g(%request.Data(parameterName,1))
		s x=x_""""_parameterVal_""""
		i i'=parametersNum s x=x_","
	}
	s x=x_")"

	s ^TMP("para")=x
	x x
	w ret
	q ""
}

ClassMethod RMethodExcute(className As %String, methodName As %String) As %String
{
	//d ##class(Nur.QueryBroker).MethodExcute("web.DHCNurCom","FindMasterItem")
	s x="s ret=##class("_className_")."_methodName_"("
	s parametersNum=..GetParamCount(className,methodName)
	f i=1:1:parametersNum{
		s parameterName=..GetParamName(className,methodName,i)
		s parameterVal=$g(%request.Data(parameterName,1))
		s x=x_""""_parameterVal_""""
		i i'=parametersNum s x=x_","
	}
	s x=x_")"
	x x
	s i=0

   

	q ""
}

ClassMethod MethodoldExcute(className As %String, methodName As %String) As %String
{
	//d ##class(Nur.QueryBroker).MethodExcute("web.DHCNurCom","FindMasterItem")
	s x="d ##class("_className_")."_methodName_"("
	s parametersNum=..GetParamCount(className,methodName)
	f i=1:1:parametersNum {
		s parameterName=..GetParamName(className,methodName,i)
		s parameterVal=$g(%request.Data(parameterName,1))
		s x=x_""""_parameterVal_""""
		i i'=parametersNum s x=x_","
	}
	s x=x_")"
	x x
	q ""
}

ClassMethod GetTree(ctlocDr As %String) As %String
{
	q:ctlocDr="" ""
	s WardID=$o(^PAWARD(0,"WARD_LocationDR",ctlocDr,""))
	q:WardID="" ""
	s curRoomId=0 f  s curRoomId=$o(^PAADMi("CurrWard",WardID,curRoomId)) q:curRoomId=""  d
	.s EpisodeID=0 f  s EpisodeID=$o(^PAADMi("CurrWard",WardID,curRoomId,EpisodeID)) q:EpisodeID=""  d
	..s pavisit=$p($g(^PAADM(EpisodeID)),"^",20)
    ..i pavisit'="A" q
	..s PatientID=$p($g(^PAADM(EpisodeID)),"^",1)
	..s patRegNo=$p($g(^PAPER(PatientID,"PAT",1)),"^",1)
	..s patName=$p($g(^PAPER(PatientID,"ALL")),"^",1)
	..s bedSub=$p($g(^PAADM(EpisodeID)),"^",73)
	..q:bedSub=""
	..s curWardId=$P(bedSub,"||",1)
	..s curBedSub=$P(bedSub,"||",2)
	..q:(curWardId="")!(curBedSub="")
	..s bedCode=$p($g(^PAWARD(curWardId,"BED",curBedSub)),"^",1)
 	..q:bedCode=""
 	..i bedCode'["婴儿" s bedCode=+bedCode
 	..s motherAdm=$p($g(^PAADM(EpisodeID)),"^",75)
 	..i motherAdm'="" d 
 	...s motherBedSub=$p($g(^PAADM(motherAdm)),"^",73)
 	...i motherBedSub=""
 	...s motherCurWardId=$P(motherBedSub,"||",1)
	...s motherCurBedSub=$P(motherBedSub,"||",2)
	...i (motherCurWardId="")!(motherCurBedSub="") s tmpBedSort(bedCode)=patRegNo_"^"_patName_"^"_bedCode_"^"_EpisodeID
	...e  d 
	....s motherBedCode=$p($g(^PAWARD(motherCurWardId,"BED",motherCurBedSub)),"^",1)
	....i motherBedCode'["婴儿" s motherBedCode=+motherBedCode
	....s tmpBedSort(motherBedCode,bedCode)=patRegNo_"^"_patName_"^"_bedCode_"^"_EpisodeID
    ..e  s tmpBedSort(bedCode)=patRegNo_"^"_patName_"^"_bedCode_"^"_EpisodeID
	s sortMotherbedCode=""
	W "["
	s num=0
	f  s sortMotherbedCode=$o(tmpBedSort(sortMotherbedCode)) q:sortMotherbedCode=""  d
	.s patRegNo=$P(tmpBedSort(sortMotherbedCode),"^",1)
	.s patName=$P(tmpBedSort(sortMotherbedCode),"^",2)
	.s bedCode=$P(tmpBedSort(sortMotherbedCode),"^",3)
	.s EpisodeID=$P(tmpBedSort(sortMotherbedCode),"^",4)
	.s sortBedCode=""
	.s dot=","
	.i num=0 s dot="" 
	.s patName=$zcvt(patName,"O","JS")
	.s EpisodeID=$zcvt(EpisodeID,"O","JS")
	.W dot_"{text:'"_bedCode_"床 "_patName_"',id:'"_EpisodeID_"',checked:false,leaf:true}"
	.s num=num+1
	.f  s sortBedCode=$o(tmpBedSort(sortMotherbedCode,sortBedCode)) q:sortBedCode=""  d
	..s patRegNo=$P(tmpBedSort(sortMotherbedCode,sortBedCode),"^",1)
	..s patName=$P(tmpBedSort(sortMotherbedCode,sortBedCode),"^",2)
	..s bedCode=$P(tmpBedSort(sortMotherbedCode,sortBedCode),"^",3)
	..s EpisodeID=$P(tmpBedSort(sortMotherbedCode,sortBedCode),"^",4)
	w "]"
	q ""
}

ClassMethod GenerateMetaData(className As %String, classQuery As %String) As %String
{
	s rs=##class(%Library.ResultSet).%New(className_":"_classQuery)
	s columnNum=rs.GetColumnCount()
	s ret="{root:'rows',totalProperty:'results',fields:["
	f i=1:1:columnNum {
		s columnName=rs.GetColumnHeader(i)
		s ret=ret_"{'name':'"_columnName_"','mapping':'"_columnName_"'}"
		i i'=columnNum s ret=ret_","
	}
	s ret=ret_"]}"
	q ret
}

ClassMethod GetQueryDataA(rset As %Library.ResultSet) As %String
{
	s $zt="errr"
	w "{rows:["
	s results=0
	s start=$G(%request.Data("start",1))
	s limit=$G(%request.Data("limit",1))
	if start="" s start=0
	if limit=""  s limit=100

	s outResults=0
	while rset.Next()'=0{
		i (results>=+start)&(results<+(start+limit)){
			i outResults'=0 w ","
			s columns=rs.GetColumnCount()
			 For col = 1:1:columns {
			   s aa=rset.GetData(col)
		       s l=$L(aa,"^")
		       s va=$P(aa,"^",l)
		       w "{"
		       for i=1:1:l
		       {
			     s vv=$P(aa,"^",i)
			     
			     if vv="" 
			     {
				     continue
			     }
			     s na=$P(vv,"|",1)
			     s nv=$P(vv,"|",2)
			     w "'"_na_"':'"_$ZCVT(nv,"O","JS")_"'"
			     // s ^TMP("aa",outResults,i)="'"_na_"':'"_$ZCVT(nv,"O","JS")_"'"
                 if va=""
                 {
			     if i'=(l-1) w ","
                 }
                 if va'=""
                 {
			     if i'=(l) w ","
                 }
			   }
	           w "}"
			 }
			
			s outResults=outResults+1
		}
		s results=results+1
		
	}
	w "],results:"_results_"}"
	q ""
errr
	s ^pjf(1)=$ze
}

ClassMethod GetQueryData(rs As %Library.ResultSet) As %String
{
	w "{rows:["
	s results=0
	s start=$G(%request.Data("start",1))
	s limit=$G(%request.Data("limit",1))
	if start="" s start=0
	if limit=""  s limit=100
	//s ^TMP("101")=start_"|"_limit

	s outResults=0
	while rs.Next()'=0{
		i (results>=+start)&(results<+(start+limit)){
			i outResults'=0 w ","
			s columnNum=rs.GetColumnCount()
			w "{"
			f i=1:1:columnNum {
				s columnName=rs.GetColumnHeader(i)
				if (columnName="HIDDEN")
		        {
			       s columnName=columnName_i
		        }

				s columnValue=rs.GetData(i)
				s columnValue=$zcvt(columnValue,"O","JS")
				//s columnValue=columnValue_results
				w "'"_columnName_"':'"_columnValue_"'"
				i i'=columnNum w ","
			}
			w "}"
			s outResults=outResults+1
		}
		s results=results+1
		
	}
	w "],results:"_results_"}"
	q ""
}

ClassMethod GetParamName(className As %String, classMethod As %String, n As %Integer)
{
	n (className,classMethod,n)
	s methodParameter=^oddCOM(className,"m",classMethod,60)
	s parameterNum=$ll(methodParameter)
	s parameter=$li(methodParameter,n)
	s parameterName=$li(parameter,1)
	q parameterName
}

ClassMethod GetParamCount(className As %String, classMethod As %String)
{
	n (className,classMethod)
	s methodParameter=$G(^oddCOM(className,"m",classMethod,60))
	s parameterNum=$ll(methodParameter)
	q parameterNum
}

ClassMethod JsonMethodExcute(className As %String, methodName As %String) As %String
{
	
	s x="s ret=##class("_className_")."_methodName_"("
	s parametersNum=..GetParamCount(className,methodName)
	
	f i=1:1:parametersNum{
		s parameterName=..GetParamName(className,methodName,i)
		
		s parameterVal=$g(%request.Data(parameterName,1))
		s x=x_""""_parameterVal_""""
		i i'=parametersNum s x=x_","
	}
	s x=x_")"

	s ^TMP("para")=x
	x x
	w ret
	q ""
}

}
