Class DHCMGNUR.GSSGRPLAYOUT Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Relationship ChildSub As DHCMGNUR.GSSGRPLAYOUTSUB [ Cardinality = children, Inverse = layparref ];

Property layGrp As DHCMGNUR.SSGROUP;

Property SSGrp As %String(TRUNCATE = 1);

//系统安全组

Property WardLoc As %String(TRUNCATE = 1);

Property laytitle As %String(TRUNCATE = 1);

Property layPos As %String(TRUNCATE = 1);

Property layflag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",Y,N");

Index grp On (layGrp, laytitle);

Index ssgrp On (SSGrp, laytitle);

Index loc On (WardLoc, laytitle);

ClassMethod getssgrpcheck(ssgrp As %String, mouldcode As %String) As %String
{
  //
   s ^TMP("aaa")=$LB(ssgrp,mouldcode)
 //w ##class(DHCMGNUR.GSSGRPLAYOUT)getssgrpcheck()
	   s mouldcode= $ZConvert(mouldcode,"U")
	   s mouldid=$O(^DHCMGNUR.MouldI("Code"," "_mouldcode,""))
       if mouldid="" q ""
   	   s ret=""
   	   s rw="" f  s rw=$O(^DHCMGNUR.GSSGRPLAYOUTI("ssgrp"," "_ssgrp," "_mouldid,rw)) q:rw=""  d
   	   .s a=##class(DHCMGNUR.GSSGRPLAYOUT).%OpenId(rw)
   	   .s m=##class(DHCMGNUR.Mould).%OpenId(a.laytitle)
   	   .s chl=""  f  s chl=$O(^DHCMGNUR.GSSGRPLAYOUTD(rw,"ChildSub",chl)) q:chl=""  d
   	   ..s bb=##class(DHCMGNUR.GSSGRPLAYOUTSUB).%OpenId(rw_"||"_chl)
   	   ..if ret'="" s ret=ret_"|"
   	   ..if ret=""  s ret=bb.laysubmoud.MenuCode
   	   ..e  s ret=ret_bb.laysubmoud.MenuCode
   	   ..s itm=..getitm(bb.laysubitem,bb.laysubmoud.MenuCode)
   	   ..if itm'=""  s ret=ret_"|"_itm
   q ret
	   //
}

ClassMethod gettest(par...) As %String
{
   w !,par(1),"-",par(2)
   q $G(par,0)
}

ClassMethod getitm(itms, menucode) As %String
{
  	//s ^TMP("bb")=$Lb(itms, menucode)
  	 s l=$L(itms,"^")
  	 s ret=""
  	 f i=1:1:l 
  	 {
	   s parw=$P(itms,"^",i)
	   if parw="" continue
	   s a=##class(DHCMGNUR.MenuSystemSub).%OpenId(parw)
	   if a="" continue
	   if ret'="" s ret=ret_"|"_menucode_"^"_a.ItemCode
	   e  s ret=menucode_"^"_a.ItemCode
	   b //ss
	 }
	 q ret
}

ClassMethod deleteall(rw) As %String
{
   		   s chl=""  f  s chl=$O(^DHCMGNUR.GSSGRPLAYOUTD(rw,"ChildSub",chl)) q:chl=""  d
		   .s bb=##class(DHCMGNUR.GSSGRPLAYOUTSUB).%DeleteId(rw_"||"_chl)
		   b //del
      q 0
}

ClassMethod Save(laygrp, ssgrp, loc, parr) As %String
{
  // s l=$L(parr,"|")
  //s a=##class(DHCMGNUR.GSSGRPLAYOUT).Save()
   s ^TMP("ssgrp")=$LB(laygrp,ssgrp,loc,parr)
   //s laygrp=$list(^TMP("ssgrp"),1)
   //s ssgrp=$list(^TMP("ssgrp"),2)
   //s loc=$list(^TMP("ssgrp"),3)
   //s parr=$list(^TMP("ssgrp"),4)
   s mouldcode= $ZConvert($P(parr,"|"),"U")
   s menuitm=$p(parr,"|",2)
   s l=$L(menuitm,"^")
   s mouldid=$O(^DHCMGNUR.MouldI("Code"," "_mouldcode,""))
   if mouldid="" q 0

   if (laygrp'="") //护理安全组
   {
	   s rw=$O(^DHCMGNUR.GSSGRPLAYOUTI("grp"," "_laygrp," "_mouldid,""))
	   if rw="" 
	   {
	     s a=##class(DHCMGNUR.GSSGRPLAYOUT).%New()
	   }else {
		   
		   s a=##class(DHCMGNUR.GSSGRPLAYOUT).%OpenId(rw)
		   s bb=..deleteall(rw)
		   }
	  s a.layGrp=laygrp
   }
   if (ssgrp'="")  //his 系统安全组
   {
	   s rw=$O(^DHCMGNUR.GSSGRPLAYOUTI("ssgrp"," "_ssgrp," "_mouldid,""))
	   if rw="" 
	   {
	     s a=##class(DHCMGNUR.GSSGRPLAYOUT).%New()
	   }else {
		   
		   s a=##class(DHCMGNUR.GSSGRPLAYOUT).%OpenId(rw)
		   s bb=..deleteall(rw)

		   }
      s a.SSGrp=ssgrp
   }
   if (loc'="")  //病区科室
   {
	   s rw=$O(^DHCMGNUR.GSSGRPLAYOUTI("loc"," "_loc," "_mouldid,""))
	   if rw="" 
	   {
	     s a=##class(DHCMGNUR.GSSGRPLAYOUT).%New()
	   }else {
		 s a=##class(DHCMGNUR.GSSGRPLAYOUT).%OpenId(rw)
		 s bb=..deleteall(rw)
	   }
      s a.WardLoc=loc
   }
   s a.laytitle=mouldid
   s len=$L(menuitm,",")
   s TMP=""
   for i=1:1:len
   {
     s itm=$P(menuitm,",",i)
     s paritm=$P(itm,"^")
     s paritm=$ZConvert(paritm,"U")
     s menuid=$O(^DHCMGNUR.MenuSystemI("MenuCode"," "_paritm,""))
     if menuid="" continue
     s subitm=$P(itm,"^",2)
     s subitm=$ZConvert(subitm,"U")
     if subitm'="" 
     {
	     if '$D(^DHCMGNUR.MenuSystemSubI("ItemCode"," "_subitm)) continue
	     s subitmid=$O(^DHCMGNUR.MenuSystemSubI("ItemCode"," "_subitm,menuid,""))
	     
	     if '$D(TMP(menuid)) s TMP(menuid)=menuid_"||"_subitmid
	     e  s $P(TMP(menuid),"^",($L(TMP(menuid),"^"))+1)=menuid_"||"_subitmid
     }else{
	     s TMP(menuid)=""
	      b //ss
	     }  
	 b  //aaa   
   }
   b //menu
   s menu="" 
   f  s menu=$O(TMP(menu)) q:menu=""  d
   .s b=##class(DHCMGNUR.GSSGRPLAYOUTSUB).%New()
   .s b.layparref=a
   .s b.laysubmoud=##class(DHCMGNUR.MenuSystem).%OpenId(menu)
   .s b.laysubitem=TMP(menu)
   .d b.%Save()
   q 0
}

Storage Default
{
<Data name="GSSGRPLAYOUTDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SSGrp</Value>
</Value>
<Value name="3">
<Value>WardLoc</Value>
</Value>
<Value name="4">
<Value>layGrp</Value>
</Value>
<Value name="5">
<Value>layPos</Value>
</Value>
<Value name="6">
<Value>layflag</Value>
</Value>
<Value name="7">
<Value>laytitle</Value>
</Value>
</Data>
<DataLocation>^DHCMGNUR.GSSGRPLAYOUTD</DataLocation>
<DefaultData>GSSGRPLAYOUTDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMGNUR.GSSGRPLAYOUTD</IdLocation>
<IndexLocation>^DHCMGNUR.GSSGRPLAYOUTI</IndexLocation>
<StreamLocation>^DHCMGNUR.GSSGRPLAYOUTS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
