Class dhc.pa.comm.TestuAdjustMethod Extends %RegisteredObject
{

ClassMethod RunTestuAdujst(RequestCode As %String, Parms As %String) As %String
{
	s retStr=""
	s count=0
	s parm1=""
	s parm2=""
	s parm3=""
	s parm11=""
	s parm12=""
	s parm13=""
	s parm14=""	
	s resultString=""
	s start=0
	s limit = 20
	s end=start+limit-1
	i Parms'="" s Parms="<Request><parm1>13</parm1><parm2>""</parm2><parm3>""</parm3><parm11>rowid</parm11><parm12>DESC</parm12><parm13>0</parm13><parm14>10</parm14></Request>"
    s Parms=$TR(Parms,$C(10))
    s Parms=$TR(Parms,$C(0))
    s reader=##class(%XML.Reader).%New()
    s sc=reader.OpenString(Parms)
    d reader.Correlate("Request","dhc.pa.Parms")
    
    s json=##class(herp.comm.JsonObj).%New()
	s jsonTitle="parm1^parm2^parm3^parm11^parm12^parm13^parm14"
	While reader.Next(.request,.sc)
	{
	   s parm1=request.parm1
	   s parm2=request.parm2
	   s parm3=request.parm3
	   s parm11=request.parm11
	   s parm12=request.parm12
	   s parm13=request.parm13
	   s parm14=request.parm14
	   
	}
	s ^suohatmp= parm1_"^"_parm11_"^"_parm2_"^"_parm1
	;s resultString = ##class(dhc.pa.udata.uAdjust).ListRec(parm1,parm2,parm3,"rowid",parm12,parm13,parm14)
	s resultString = ##class(dhc.pa.udata.uAdjust).ListRec(parm1,"","","rowid","DESC",parm13,parm14)
	
	q resultString
}

}
