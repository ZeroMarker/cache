Class DHCWL.DM.Core.DQLParser Extends %RegisteredObject
{

Property Status As %Status;

Property ParserForest As %ListOfObjects;

Property RSN2IRPStruct [ MultiDimensional ];

// d ##class(DHCWL.DM.Core.DQLParser).Test()

ClassMethod Test()
{
	s parser=##class(DQLParser).%New()
	s dql="rs1:{"_
            "from: /workload2.t,"_
            "pros : RecDep,RecDep->Hospital hosDr,RecDep->Hospital->Name as hospitalName,PatDep->Code patCode,AdmType,PatDoc->Name,"_
            "filter: OrdDate DateRange('2013-01-01','2013-01-02') && (AdmType = ('E') || AdmType = ('O'))"_
          "};"_
          "rs2:{"_
            "from: /workload2.t,"_
            "pros:RecDep->Hospital->Name as hospitalName,PatDep->Code patCode,AdmType,PatDoc->Name,"_
            "filter: OrdDate DateRange('2013-01-03','2013-01-04')&&(AdmType = ('E') || AdmType = ('O'))"_
          "};"
    s status=parser.Parse(dql)
    w status,!
}

Method %OnNew() As %Status [ Private, ServerOnly = 1 ]
{
	s ..ParserForest=##class(%ListOfObjects).%New()
	q $$$OK
}

Method Parse(dqlExpression As %String(MAXLEN=60840)) As %Status
{
	k SWResult,CQLJSONMAP
	s status=$$$OK
    s len=$l(dqlExpression)
	s stack=##class(DHCWL.DM.Util.Stack).%New()
	s rsE=0,braceS="{",braceE="}",str1="'",str2="""",proVS=":"
	s resultSetName="",from="",pros="",filter="",sort=""
	s prePro="",preProV="",preProSI=0
	f i=1:1:len {
	  s char=$e(dqlExpression,i)
	  if ((char=proVS) && (stack.Size()=0)){
		d searchWord(i-1)
		s resultSetName=SWResult("NAME")
	  }elseif ((char=braceS) && ((stack.Size()=0))){
		k CQLJSONMAP
		d stack.Push(char)
	  }elseif ((char=braceE) && (stack.Peek()=braceS)){
		d stack.Pop()
		if stack.Size()'=0 {
		  continue
		}
		if ((prePro'="") && (preProV="")){
		  f j=i-1:-1:preProSI{
			s char2=$e(dqlExpression,j)
			if (##class(DHCWL.DM.Util.StringUtil).IsSpace(char2))||(char2=","){
			}else{
			  q	
			}
		  }
		  s preProV=##class(DHCWL.DM.Util.StringUtil).Trim($e(dqlExpression,preProSI,j))
		  s CQLJSONMAP(prePro)=preProV
		}
		;w "resultSetName:"_resultSetName,!
		;zw CQLJSONMAP
		s status= ..ParseOneDQL(resultSetName,.CQLJSONMAP)
		
	  }elseif ( (char=proVS) && (stack.Size()=1) && (stack.Peek()=braceS)){
		d searchWord(i-1)
		s pro=$zcvt(SWResult("NAME"),"U")
		if prePro=""{
		  s prePro=pro,preProSI=i+1
		}else{
		  f j=SWResult("NS")-1:-1:preProSI{
			s char2=$e(dqlExpression,j)
			if (##class(DHCWL.DM.Util.StringUtil).IsSpace(char2))||(char2=","){
			}else{
			  q	
			}
		  }
		  s preProV=##class(DHCWL.DM.Util.StringUtil).Trim( $e(dqlExpression,preProSI,j) )
		  s CQLJSONMAP(prePro)=preProV
		  
		  s prePro=pro,preProSI=i+1,preProV=""
		}
		
	  }elseif ((char=str1) && (stack.Peek()'=str1)){
		 d stack.Push(char) 
	  }elseif ((char=str1) && (stack.Peek()=str1)){
		 d stack.Pop()
	  }
	}
	if ($g(CQLJSONMAP("FROM"),"")="") || ($g(CQLJSONMAP("PROS"),"")="") {
	  s status=$$$ERROR("The grammar is invalid:from or pros can't null!")	
	}
	q:status'=$$$OK status
	if stack.Size()'=0{
	  s status=$$$ERROR("The grammar is invalid:"_dqlExpression)
	}
	q status
searchWord(we)
    s j=we,initSearch=1
    f j=we:-1:1{
	  s char2=$e(dqlExpression,j)
	  if '##class(DHCWL.DM.Util.StringUtil).IsSpace(char2) q
    }
    s we=j
    f j=we:-1:1{
	  s char2=$e(dqlExpression,j)
	  if ##class(DHCWL.DM.Util.StringUtil).IsLetter(char2){
		  
	  }else{
		s j=j+1
		q  
	  }
    }
    s SWResult("NAME")=$e(dqlExpression,j,we)
    s SWResult("NS")=j
    s SWResult("NE")=we
    q
}

Method ParseOneDQL(name, ByRef defStruct) As %Status
{
	s from=defStruct("FROM")
	s len=..ParserForest.Count()
	s irp=""
	f i=1:1:len {
	  s irp=##class(DHCWL.DM.Core.DQLIRParser).SearchDown(..ParserForest.GetAt(i),from)
	  q:irp'=""
	}
	if irp=""{
	  s dimBase=##class(DHCWL.DM.T.DimBase).GetByPath(from)
	  q:dimBase="" $$$ERROR("Can't load dimBase with path "_from)
      s nirp=##class(DQLIRParser).%New(name,"",dimBase,.defStruct)
	}else{
	  s nirp=##class(DQLIRParser).%New(name,irp,"",.defStruct)
	}
	s status=nirp.Parse()
	q:status'=$$$OK status
	s ..RSN2IRPStruct(name)=nirp
	q status
}

}
