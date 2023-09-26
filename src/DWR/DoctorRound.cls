/// DWR.DoctorRound   QSE-20111004
Class DWR.DoctorRound Extends %SOAP.WebService [ ClassType = "", Not ProcedureBlock ]
{

/// Name of the WebService.
Parameter SERVICENAME = "DocServComm";

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://dhcc.com.cn";

// 续打-生成打印信息

Method SaveHC(adm, code, head, parr, compare, last) As %String [ WebMethod ]
{
	q ##class(Nur.DHCNurHCRecPrint).SaveHC(adm,code,head,parr,compare,last)
}

// 续打 --设置打印标记

Method SaveDB(parr, adm, code) As %String [ WebMethod ]
{
	q ##class(Nur.DHCNurHCRecPrint).setprnflag(parr, adm, code)
}

// 续打

Method Saveprinted(parr, data As %GlobalCharacterStream) As %String [ WebMethod ]
{
	d data.Rewind()
	q ##class(Nur.DHCNursehlblprinted).Saveprinted(parr,data)
}

// 续打

Method Save(adm, code, parr) As %String [ WebMethod ]
{
	q ##class(Nur.DHCNurRecPrint).Save(adm,code,parr)
}

// 生成图片 获取图片存储路径

Method GetPictureFilePath(adm, code) As %String [ WebMethod ]
{
	     q ##class(Nur.DHCNurHLBLPictureFilePath).GetFilePath(adm,code)
}

// 生成图片 图片根据模板id取模板名

Method GetCodeName(code) As %String [ WebMethod ]
{
	      q ##class(Nur.DHCNurHLBLPictureFilePath).GetKCodeName(code)
}

// 生成图片  某人某个模板有几页

Method GetPatCodePages(adm, code) As %String [ WebMethod ]
{
	      q ##class(Nur.DHCNurHLBLPictureFilePath).GetPatCodePages(adm,code)
}

// 生成图片  存储路径

Method SavePictureFilePath(adm, code, page) As %String [ WebMethod ]
{
	     q ##class(Nur.DHCNurHLBLPictureFilePath).Save(adm,code,page)
}

// 生成图片  存储生成过得记录

Method MakePictureHistory(adm, code, parr) As %String [ WebMethod ]
{
	     q ##class(Nur.DHCNurMakePictureHistory).Save(adm,code,parr)
}

// 存储每条记录的打印信息

Method MakePictureRecorder(adm, code, parr) As %String [ WebMethod ]
{
	    q ##class(NurEmr.DHCNurRecorderPrintinfo).SaveRecorderInfo(adm,code,parr)
}

// 生成图片  存储

Method SaveNurPage(nurid, adm, code, page, nurpage) As %String [ WebMethod ]
{
	     q ##class(Nur.DHCNurMakePictureHistory).SaveNur(nurid,adm,code,page,nurpage)
}

// 生成图片  获取页码

Method GetNurPage(nurid, adm, code) As %String [ WebMethod ]
{
	    q ##class(Nur.DHCNurMakePictureHistory).GetNur(nurid,adm,code)
}

/// TODO: add arguments and implementation.
/// Test
ClassMethod GetQueryData(QueryName, parrm) As %XML.DataSet [ WebMethod ]
{
  //web.DHCNurIpComm s a= ##class(DWR.DoctorRound).GetQueryData()
    // s QueryName="web.DHCNurHCRecPrint.GetCareRecComm"
    // s parrm="337862!!!!!DHCNUR6!1_9"

     //s ^TMP("queryName")=QueryName_"^"_parrm
     // s QueryName=$P(^TMP("queryName"),"^")
     // s parrm=$P(^TMP("queryName"),"^",2)
     // s parrm=""
      //s parrm="337862!!!!!DHCNUR6!1_9"
      //s QueryName=^TMP("pp")
     // s parrm=^TMP("pp",1)
      
  	  s l=$L(parrm,"!")
	  s pp=""
	  if QueryName'="web.DHCPDADocOrdEntry.LookUpItem"
	  {
		  f i=1:1:l
		  {
		    s itm=$P(parrm,"!",i)
		    if $ZC(itm)=0 continue
		    s p=$P(itm,":",1)
		    s v=$P(itm,":",2)
		    s @p=v
		    b
	       if pp'="" s pp=pp_","_p
	       e  s pp=p 
			    
		    b
		  }
	  }
  
  Set result=##class(%XML.DataSet).%New()
  //s ^TMP("aa")=pp
	//both 2 parameters are empty
  Set result=##class(%XML.DataSet).%New(QueryName)
  if QueryName="web.DHCPDADocOrdEntry.LookUpItem"
  {
	   s Arcim=$P(parrm,"!")
	   s Grp=$P(parrm,"!",2)
	   s EpisodeId=$P(parrm,"!",3)
	   Do result.SetArgs(Arcim,Grp,"","","","",EpisodeId,"","","","","","","")
  }else
  {
   i pp'="" Do result.SetArgs(@pp)
   e  Do result.SetArgs()
  }
  Quit result
}

ClassMethod GetDataB(mth As %String, parrm As %String, del As %String) As %String [ WebMethod ]
{

   s mth="##class("_$P(mth,":")_")."_$P(mth,":",2)
   s l=$L(parrm,del)

   s pp=""
   
   
   for i=1:1:l
   {
     s itm=$P(parrm,del,i)
     if itm="" continue
     s mth=mth_""""_itm_""""
     i i'=l s mth=mth_","
   }
   s mth=mth_")"
    s c="a="_mth
   	set @c
   	s b="a"
   	s aa=@b
   	
	s a=$TR(aa,$C(1),"@")
	s a=$TR(a,$C(2),"!")
	s a=$TR(a,$C(3),"$")
	q a
}

ClassMethod GetQueryDataB(QueryName, parrm, del) As %XML.DataSet [ WebMethod ]
{
	  //s a= ##class(DWR.DoctorRound).GetQueryData()
	  //s QueryName="web.DHCNurNeedMeasureTempPat.GetNeedMeaserBP1"
     //s parrm="112!2012-03-31!00:00!23:59"
   // s ^TMP("query")=
     // s del="!"
	
   s l=$L(parrm,del)
   Set result=##class(%XML.DataSet).%New(QueryName)
   b
   s ex="Do result.SetArgs("

   for i=1:1:l
   {
     s itm=$P(parrm,del,i)
     if itm="" continue
     s ex=ex_""""_itm_""""
     i i'=l s ex=ex_","
   }
   s ex=ex_")"
   x ex
   Quit result
 //s x="s ret=##class(Nur.QueryBroker)."_type_"Excute("""_className_""","""_methodName_""")"
}

/*
ClassMethod QueryExcute(className As %String, classQuery As %String) As %String
{
	//d ##class(Nur.QueryBroker).QueryExcute("web.DHCNurCom","FindMasterItem")
	s rs=##class(%Library.ResultSet).%New(className_":"_classQuery)
	s x="d rs.Execute("
	s parametersNum=rs.GetParamCount()
	f i=1:1:parametersNum{
	s parameterName=rs.GetParamName(i)
	s parameterVal=$g(%request.Data(parameterName,1))
	s x=x_""""_parameterVal_""""
	i i'=parametersNum s x=x_","
	}
	s x=x_")"
	x x
	d ..GetQueryData(rs)
	q ""
}
*/
ClassMethod GetQueryDataX(QueryName, parrm, del) As %XML.DataSet [ WebMethod ]
{
  //web.DHCNurIpComm s a= ##class(DWR.DoctorRound).GetQueryDataX()
     //s QueryName="web.DHCNurNeedMeasureTempPat.GetNeedMeaserBP1"
     //s parrm="parr:112!2012-03-31!00:00!23:59"
   // s ^TMP("query")=
    // s del="^"
    //  s QueryName="web.DHCNurseRecordPrint.GetCareRecComm"
 //s parrm="parr:1!!!!!DHCNURXH22^"
   // s del="^"

    // s ^TMP("queryName")=QueryName_"^"_parrm
     // s QueryName=$P(^TMP("queryName"),"^")
     // s parrm=$P(^TMP("queryName"),"^",2)
     // s parrm=""
      //s parrm="337862!!!!!DHCNUR6!1_9"
      //s QueryName=^TMP("pp")
     // s parrm=^TMP("pp",1)
      
  	  s l=$L(parrm,del)
	  s pp=""
	  if QueryName'="web.DHCPDADocOrdEntry.LookUpItem"
	  {
		  f i=1:1:l
		  {
		    s itm=$P(parrm,del,i)
		    //if $ZC(itm)=0 continue
		    s p=$P(itm,":",1)
		    s v=$P(itm,":",2)
		    s @p=v
		    b
	       if pp'="" s pp=pp_","_p
	       e  s pp=p 
			    
		    b
		  }
	  }
  
  Set result=##class(%XML.DataSet).%New()
  //s ^TMP("aa")=pp
	//both 2 parameters are empty
  Set result=##class(%XML.DataSet).%New(QueryName)
  if QueryName="web.DHCPDADocOrdEntry.LookUpItem"
  {
	   s Arcim=$P(parrm,"!")
	   s Grp=$P(parrm,"!",2)
	   s EpisodeId=$P(parrm,"!",3)
	   Do result.SetArgs(Arcim,Grp,"","","","",EpisodeId,"","","","","","","")
  }else
  {
   i pp'="" Do result.SetArgs(@pp)
   e  Do result.SetArgs()
  }
  Quit result
}

ClassMethod GetQueryDataA(QueryName, parrm, del) As %XML.DataSet [ WebMethod ]
{
  //web.DHCNurIpComm s a= ##class(DWR.DoctorRound).GetQueryData()
    //s QueryName="web.DHCLONGTIMEORD.GetLongOrd"
    //s parrm="65^^^^1^3879^2^^^^^^"
    s del="^"
     for i=1:1:16
     {
       s tm(i)=""
     }
  	  s l=$L(parrm,del)
	  f i=1:1:l
	  {
	    s itm=$P(parrm,del,i)
	    //if $ZC(itm)=0 continue
	   s tm(i)=itm
		    
	  }
	  b   ////4444
  Set result=##class(%XML.DataSet).%New(QueryName)
  d result.SetArgs(tm(1),tm(2),tm(3),tm(4),tm(5),tm(6),tm(7),tm(8),tm(9),tm(10),tm(11))
 
  Quit result
}

ClassMethod GetQueryDataA1(QueryName, parrm, del) As %XML.DataSet [ WebMethod ]
{
  //web.DHCNurIpComm s a= ##class(DWR.DoctorRound).GetQueryData()
    //s QueryName="web.DHCLONGTIMEORD.GetLongOrd"
   //s parrm="65^^^^1^3879^2^^^^^^"
    // s del="^"
    // s ^TMP("queryName")=QueryName_"^"_parrm
     // s QueryName=$P(^TMP("queryName"),"^")
     // s parrm=$P(^TMP("queryName"),"^",2)
     // s parrm=""
      //s parrm="337862!!!!!DHCNUR6!1_9"
      //s QueryName=^TMP("pp")
     // s parrm=^TMP("pp",1)
      
  	  s l=$L(parrm,del)
	  s pp=""
	  if QueryName'="web.DHCPDADocOrdEntry.LookUpItem"
	  {
		  f i=1:1:l
		  {
		    s itm=$P(parrm,del,i)
		    if $ZC(itm)=0 continue
		    s p="p"_i
		    s v=itm
		    s @p=v
		    b
	       if pp'="" s pp=pp_","_p
	       e  s pp=p 
			    
		    b
		  }
	  }
  
  Set result=##class(%XML.DataSet).%New()
  //s ^TMP("aa")=pp
	//both 2 parameters are empty
  Set result=##class(%XML.DataSet).%New(QueryName)
  if QueryName="web.DHCPDADocOrdEntry.LookUpItem"
  {
	   s Arcim=$P(parrm,"!")
	   s Grp=$P(parrm,"!",2)
	   s EpisodeId=$P(parrm,"!",3)
	   Do result.SetArgs(Arcim,Grp,"","","","",EpisodeId,"","","","","","","")
  }else
  {
   i pp'="" Do result.SetArgs(@pp)
   e  Do result.SetArgs()
  }
  Quit result
}

ClassMethod GetData(mth As %String, parrm As %String) As %String [ WebMethod ]
{
  //s a=##class(DWR.DoctorRound).GetData()
 // s mth="Nur.DHCNurCopyDiagnos:GetNurDiagnos"
  //s parrm="par:8^"
   //mth="##class(web.DHCMGNurComm).GetLoc"
  // q 1
  // s parrm=^TMP("qse")
  s ^TMP("qse")=mth_"^"_parrm
   //s mth="web.DHCPdaComm:GetEPARCIMDetail"  ,parrm="EpisodeID:77126^InsType:^OrderDepRowid:^ArcimRowid:9746||1"
   s mth="##class("_$P(mth,":")_")."_$P(mth,":",2)
   s l=$L(parrm,"^")

   s pp=""

   if $F(parrm,"^")'=0
   {
	   f i=1:1:l
	   {
	     s itm=$P(parrm,"^",i)
	     if itm="" continue
	     	 //  s ^TMP("aa")="ffff"

	     s p=$P(itm,":",1)
	     s v=$P(itm,":",2)
	     s @p=v
	     if pp'="" s pp=pp_","_p
	     e  s pp=p 
	     b //
	   }
   }
   	s mth=mth_"("_pp_")"
   	b
   	s c="a="_mth
   	set @c
   	s b="a"
   	s aa=@b
   	
	s a=$TR(aa,$C(1),"@")
	s a=$TR(a,$C(2),"!")
	s a=$TR(a,$C(3),"$")
	q a
}

ClassMethod GetDataX(mth As %String, parrm As %String, del As %String) As %String [ WebMethod ]
{
  //s a=##class(DWR.DoctorRound).GetDataX()
   //mth="##class(web.DHCMGNurComm).GetLoc"
  // q 1
   //s parrm=""
   //s =
  // s parrm=^TMP("qse")_"!"
  // s mth=^TMP("mth")
  // s del=^TMP("del")
  // s ^TMP("qse")=parrm
  // s ^TMP("mth")=mth
  // s ^TMP("del")=del
   //s mth="web.DHCPdaComm:GetEPARCIMDetail"  //,parrm="EpisodeID:77126^InsType:^OrderDepRowid:^ArcimRowid:9746||1"
  
  s mth="##class("_$P(mth,":")_")."_$P(mth,":",2)
   s l=$L(parrm,del)

   s pp=""
   b  ///
   if $F(parrm,del)'=0
   {
	   f i=1:1:l
	   {
	     s itm=$P(parrm,del,i)
	     if itm="" continue
	     	 //  s ^TMP("aa")="ffff"

	     s p=$P(itm,":",1)
	     s v=$P(itm,":",2)
	     s v2=$P(itm,":",3)
	     if v2'="" s v=v_":"_v2
	     s @p=v
	     if pp'="" s pp=pp_","_p
	     e  s pp=p 
	     b //
	   }
   }
   	s mth=mth_"("_pp_")"
   	
   	s c="a="_mth
   	set @c
   	s b="a"
   	s aa=@b
   	
	s a=$TR(aa,$C(1),"@")
	s a=$TR(a,$C(2),"!")
	s a=$TR(a,$C(3),"$")
	q a
}

// "##class(NurEmr.NurEmrSub).GetStream^parr:DHCNURMouldccsb_glht!^!"

// "##class(web.DHCNUREMR).GetPrintData^parr:DHCNURMouldPFBPrn^^^Nur.DHCMoudDataSub:getVal1&parr:178_5!flag:!^!

// web.DHCNUREMR:GetPrintData

// d ##class(DWR.DoctorRound).GetEmrData("web.DHCNUREMR:GetPrintData","parr:DHCNURMouldPFBPrn^^^Nur.DHCMoudDataSub:getVal1&parr:178_5!flag:!","!")

// "##class(web.DHCNUREMR).GetPrintData^parr:DHCNURMouldPFBPrn^^^Nur.DHCMoudDataSub:getVal1&parr:178_5!flag:!^!" 

// d 

// d ##class(DWR.DoctorRound).GetEmrData("web.DHCNUREMR:GetPrintData","parr:DHCNURMouldPGDPrn^^^web.DHCNurMouldDataComm:GetPrnValComm&parr:@151@DHCNURXHPGD","!")

ClassMethod GetEmrData(mth, parrm, del) As DWR.DHCTranStream [ WebMethod ]
{
	//s a=##class(DWR.DoctorRound).GetEmrData()
 //s ^TMP1("aaa1")=$Lb(mth,parrm,del)
 //  s mth=$List(^TMP1("aaa1"),1)
 //s mth=$List(^TMP1("aaa1"),1)
 //s parrm=$List(^TMP1("aaa1"),2)
 // s del=$List(^TMP1("aaa1"),3)
 //	s parrm="parr:DHCNurPrnMould6^^^!"
	
	//s mth="web.DHCNUREMR:GetPrintData"
	//s del="!"
	 s ^niewei(33)=mth_"^"_parrm_"^"_del
	s mth="##class("_$P(mth,":")_")."_$P(mth,":",2)
	s l=$L(parrm,del)
	 s ^objcyf41=mth_"^"_parrm_"^"_del
	 b ;0009
	if ((mth="##class(web.DHCNUREMR).GetPrintData")||(mth="##class(web.DHCNUREMR).GetPrintDataPGD"))
	{
		s mth=mth_"("""_$E(parrm,6,$L(parrm))_""")"
		b ;333333
		s c="a="_mth
		set @c
		s b="a"
		s aa=@b
		s transtr=##class(DWR.DHCTranStream).%New()
		s transtr.CommString=aa
		b ;223
		q transtr	
	
	}
	
	s pp=""
	b  ///
	if $F(parrm,del)'=0
	{
	   f i=1:1:l
	   {
	     s itm=$P(parrm,del,i)
	     if itm="" continue
	     	 //  s ^TMP("aa")="ffff"

	     s p=$P(itm,":",1)
	     s v=$P(itm,":",2)
	     s v2=$P(itm,":",3)
	     if v2'="" s v=v_":"_v2
	     s @p=v
	     if pp'="" s pp=pp_","_p
	     e  s pp=p 
	     b //
	   }
	}
	b ;222333
	s mth=mth_"("_pp_")"
	b  ;999
	s c="a="_mth
	set @c
	s b="a"
	s aa=@b
	s transtr=##class(DWR.DHCTranStream).%New()
	s transtr.CommString=aa
	q transtr
}

ClassMethod GetEmrData1(mth, parrm, del) As DWR.DHCTranStream [ WebMethod ]
{
	//s a=##class(DWR.DoctorRound).GetEmrData()

	///s parrm="parr:DHCNurPrnMould6^^^!"
	//s mth="web.DHCNUREMR:GetPrintData"
	//s del="!"
	s mth="##class("_$P(mth,":")_")."_$P(mth,":",2)
	s l=$L(parrm,del)
	
	s pp=""
	b  ///
	if $F(parrm,del)'=0
	{
	   f i=1:1:l
	   {
	     s itm=$P(parrm,del,i)
	     if itm="" continue
	     	 //  s ^TMP("aa")="ffff"

	     s p=$P(itm,":",1)
	     s v=$P(itm,":",2)
	     s v2=$P(itm,":",3)
	     if v2'="" s v=v_":"_v2
	     s @p=v
	     if pp'="" s pp=pp_","_p
	     e  s pp=p 
	     b //
	   }
	}
	s mth=mth_"("_pp_")"
	
	s c="a="_mth
	set @c
	s b="a"
	s aa=@b
	s transtr=##class(DWR.DHCTranStream).%New()
	s transtr.CommString=aa
	q transtr
}

ClassMethod SaveStream(streamitm As DWR.DHCTranStream, itm) As %String
{
   d itm.EmrSubData.CopyFromAndSave(streamitm.CommString)
   q 0
}

/*
ClassMethod SaveCase(EpisodeId, emrcode, fieldCode, RecRw, dt As DWR.DHCTranStream) As %String [ WebMethod ]
{
 //w ##class(DWR.DoctorRound).SaveCase()
   //s EpisodeId=337862,emrcode="DHCNUR6",fieldCode="CaseMeasureXm",RecRw=""
   //s dt=##class(DWR.DHCTranStream).%New()
   //d dt.CommString.Write("ddddddddddddddddd")
   s a=##class(Nur.DHCNurEmrXml).SaveCase(EpisodeId, emrcode, fieldCode, RecRw,dt)
   q a
}
*/
}
