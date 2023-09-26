Class web.MgPerService Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

Parameter SERVICENAME = "MgPerService";

Parameter LOCATION = "http://192.168.160.10/TrakCare/web";

//} ##class(web.MgPerService).GetSystTime

/// http://192.168.1.101/trakcare/trak/web/web.QseService.cls
/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/clinc";

ClassMethod saveimg(img As Person.Image) As Person.Image [ WebMethod ]
{
	 s imgid=$O(^User.DHCMGPersonImageI("Person",img.PersonDR,""))
	 if imgid'="" s a=##class(User.DHCMGPersonImage).%OpenId(imgid)
	 e  s a=##class(User.DHCMGPersonImage).%New()
	 s per=##class(User.DHCMGPersons).%OpenId(img.PersonDR)
	 s a.PersonDR=per
	 if (img.SignName.Read(1)'="")
	 {
	   d a.SignName.CopyFromAndSave(img.SignName)
	 }
	 if (img.DocPrint.Read(1)'="")
	 {
	    d a.DocPrint.CopyFromAndSave(img.DocPrint)
	 }
	 if (img.Certifcate.Read(1)'="")
	 {
	    d a.Certifcate.CopyFromAndSave(img.Certifcate)
	  // s ^TMimg=img.Certifcate.Read(1000)
	 }

	 d a.%Save()
	 q img
}

ClassMethod getimg(perid As %String) As Person.Image [ WebMethod ]
{
	
	 s b=##class(Person.Image).%New()
     s imgid=$O(^User.DHCMGPersonImageI("Person",perid,""))
	 if (imgid'="")
	 {
		 s a=##class(User.DHCMGPersonImage).%OpenId(imgid)
		 
		 s b.DocPrint=a.DocPrint
		 s b.Certifcate=a.Certifcate
		 s b.SignName=a.SignName
	 }else
	 {
     }
     b
	 q b
}

ClassMethod GetSystTime() As %String [ WebMethod ]
{
	s date=$ZD(+$H,3)
	s week=$ZD(+$H,10)
	s tim=$P($H,",",2)
	s tim=$ZT(tim)
 q date_"^"_week_"^"_tim
}

ClassMethod GetUserGrp(user As %String, logloc As %String) As %String [ WebMethod ]
{
  //根据登陆科室求安全组//2008-11-11 qse
    s grp=""
    s chl=""  f  s chl=$O(^SSU("SSUSR",user,"OTHLL",chl)) q:chl=""  d
    .s loc=$P(^SSU("SSUSR",user,"OTHLL",chl),"^",1)
    .q:loc'=logloc
    .s grp=$P(^SSU("SSUSR",user,"OTHLL",chl),"^",2)
    q grp
}

ClassMethod Logon(userid, pinnumber) As %String [ WebMethod ]
{
    s ^TMP("Hospital")="JST"
    s oldnamespace=$ZNSPACE
	s datanamespace=$LIST(^websys.ConfigurationD(1),12)
	zn datanamespace
  	s User=$O(^SSU("SSUSR",0,"SSUSR_Initials",$ZCVT(userid,"U"),""))
  	s ssgrp=$p(^SSU("SSUSR",User),"^",5)
  	b
  	if User=""{
	  	 zn oldnamespace
         q "-3"
	  	} 
  	s pin=$$ENCR^SSUTIL2(pinnumber)
  	b
  	if pin=""{
	  	 zn oldnamespace
         q "-4"
	  	} 
	i pin'=$p(^SSU("SSUSR",User),"^",3) {
	  	 zn oldnamespace
	  	 b //
		q "-4"
	}
	s DefLoc=$p(^SSU("SSUSR",User),"^",4)
	s UserName=$p(^SSU("SSUSR",User),"^",2)
	s UserID=$p(^SSU("SSUSR",User),"^")
	s DefLocDes=$p($G(^CTLOC(DefLoc)),"^",2)
	s DocID=$p(^SSU("SSUSR",User),"^",14)
   	zn oldnamespace 
   // d ##class(DHCPdaComm).Init(User)
	s LogonDep=##class(web.DHCNURPDAQUEXCUTE).Getlogonctloc(User)
	if LogonDep="-1"{
		s LogonDep="logonctloc&LocDesc&rowid&$"_DefLocDes_"^"_DefLoc_"^&"
		}else{
			s LogonDep=LogonDep_DefLocDes_"^"_DefLoc_"^&"
			}
	q User_"^"_DefLoc_"^"_ssgrp_"^"_UserName_"^"_UserID_"^"_DocID_"@"_LogonDep
}

}
