Class web.DHCEMSysItmAut Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：      huaxiaoying
/// CreatDate：    2016-06-08
/// Description:   保存或者新增  产品功能授权表
/// Table：        DHC_EmSysItmAut
/// Input：	       SAType：类型
///                SAPointer：指针
///                SAValue:值         
///                SYHospDr:医院id
///                SAParRefDr:父表id
/// 			   ID：rowid 
/// Return：       保存成功 0，其他 失败
ClassMethod SaveOrUpdate(str)
{
        
  		 s SAParRefDr=$p(str,"^",1)
  		 s SAPointerID=$p(str,"^",2)
 		 s SAType=$p(str,"^",3)
		 s SAPointer=$p(str,"^",4)
		 s SAValue=$p(str,"^",5)
		 s SAHospDr=$p(str,"^",6)
		 s SAHospDrID=$p(str,"^",7)
		 s ID=$p(str,"^",8)
         i SAPointerID=0 q 2
        
         s ParRef=$p(SAParRefDr,"||",1)
         s ParRefDr=$p(SAParRefDr,"||",2)
         
		 i +ID=0 
		 {
			s obj=##class(User.DHCEmSysItmAut).%New()
			Q:$d(^DHCEMS(0,"TypePointerHosp",SAType,SAPointerID,SAHospDr,ParRef,ParRefDr)) 1
			;Q:$d(^DHCEMS(0,"TypePointer",SAType,SAPointerID,ParRef,ParRefDr)) 1
			   
			s SAChlidSub=$o(^DHCEMS(ParRef,"I",ParRefDr,"A",""),-1)+1
		 	s obj.SAParRefDr=##class(User.DHCEmSysItm).%OpenId(SAParRefDr,0)
		 	s obj.SAChlidSub=SAChlidSub	 
			s obj.SAHospDr=##class(User.CTHospital).%OpenId(SAHospDrID,0)   ; 2021-02-08 cy SAHospDr值为医院描述  SAHospDrID值为医院ID
			
		 }else{
			 s obj=##class(User.DHCEmSysItmAut).%OpenId(ID)
			 
			 s isIN=0 
			 
			 i +SAHospDr=0 d
			 .s obj.SAHospDr=##class(User.CTHospital).%OpenId(SAHospDrID,0)
			 .i $d(^DHCEMS(0,"TypePointerHosp",SAType,SAPointerID,SAHospDrID,ParRef,ParRefDr)) d
			 ..s PHIDUP=$O(^DHCEMS(0,"TypePointerHosp",SAType,SAPointerID,SAHospDrID,ParRef,ParRefDr,""))
			 ..q:SAParRefDr_"||"_PHIDUP=ID
			 ..s isIN=1
			 e  d
			 .s obj.SAHospDr=##class(User.CTHospital).%OpenId(SAHospDrID,0) ; 2021-02-08 cy SAHospDr值为医院描述  SAHospDrID值为医院ID
			 .i $d(^DHCEMS(0,"TypePointerHosp",SAType,SAPointerID,SAHospDrID,ParRef,ParRefDr)) d ; 2021-02-08 cy SAHospDr值为医院描述  SAHospDrID值为医院ID
			 ..s PHIDUP=$O(^DHCEMS(0,"TypePointerHosp",SAType,SAPointerID,SAHospDr,ParRef,ParRefDr,""))
			 ..q:SAParRefDr_"||"_PHIDUP=ID
			 ..s isIN=1
			 
			 ;s isIN=0   //hxy 2016-10-19
			 ;i $d(^DHCEMS(0,"TypePointer",SAType,SAPointerID,ParRef,ParRefDr)) d
			 .;s PHIDUP=$O(^DHCEMS(0,"TypePointer",SAType,SAPointerID,SAHospDrID,ParRef,ParRefDr,""))
			 .;q:SAParRefDr_"||"_PHIDUP=ID
			 .;s isIN=1
			 q:isIN=1 1
			 }
		    
           
		 s obj.SAType=SAType
		 s obj.SAPointer=SAPointerID
		 s obj.SAValue=SAValue
		 ;s obj.SAHospDr=##class(User.CTHospital).%OpenId(%session.Get("LOGON.HOSPID"))
		 	 
	     s sc=obj.%Save()   
		 ;i $$$ISERR(sc) q -2
		 q 0
}

/// Descript:0:不存在重复数据,1:数据重复,2:数据冲突
/// w ##class(web.DHCEMSysItmAut).HasThisData("5||7^175^G^急诊输液护士^1^东华标准版数字化医院[总院]^2^0")
ClassMethod HasThisData(str)
{
	s SAParRefDr=$p(str,"^",1)
	s SAPointerID=$p(str,"^",2)
	s SAType=$p(str,"^",3)
	s SAPointer=$p(str,"^",4)
	s SAValue=$p(str,"^",5)
	s SAHospDr=$p(str,"^",6)
	s SAHospDrID=$p(str,"^",7)
	s SAID=$p(str,"^",8)
	
	s IsHas=0,Id=+SAParRefDr,Itm=$p(SAParRefDr,"||",2),Sub=0
	f  s Sub=$o(^DHCEMS(Id,"I",Itm,"A",Sub)) q:(Sub="")||(IsHas=1)  d
	.q:SAID=(Id_"||"_Itm_"||"_Sub)
	.s ItmData=^DHCEMS(Id,"I",Itm,"A",Sub)
	.s ItmDataSAType=$p(ItmData,"^",1)
	.s ItmDataSAPointer=$p(ItmData,"^",2)
	.s ItmDataSAValue=$p(ItmData,"^",3)
	.s ItmDataSAHospDr=$p(ItmData,"^",4)
	.s:(ItmDataSAType=SAType)&&(ItmDataSAPointer=SAPointerID)&&(ItmDataSAValue=SAValue)&&(ItmDataSAHospDr=SAHospDrID) IsHas=1
	.s:(ItmDataSAType=SAType)&&(ItmDataSAPointer=SAPointerID)&&(ItmDataSAValue'=SAValue)&&(ItmDataSAHospDr=SAHospDrID) IsHas=2
	q IsHas
}

/// w ##class(web.DHCEMSysItmAut).SaveSysItmAut("24||17^DHC^D^DHC^Ij9IQGzV1111^东华标准版数字化医院[总院]^2^24||17||1")
ClassMethod SaveSysItmAut(params)
{
	
	s $Zt="Err"
  	TStart
  	s ret=0
  	s len=$l(params,"$$")
  	for i=1:1:len d
  	.q:ret'=0
  	.s str=$p(params,"$$",i)
  	.s parRefDr=$p(str,"^",1)
	.s value=$p(str,"^",5)
  	.s phCode=$p(^DHCEMS(+parRefDr,"I",$p(parRefDr,"||",2)),"^",1)
  	.i (phCode="DEFOPENACCHOUR")!(phCode="DEFOPENACCORDHOUR")!(phCode="OPENACCDEFHOUR")!(phCode="OPENACCORDDEFHOUR") d
  	..s:(value["-")!(value[".") ret=3
    	.s:phCode["PASSWORD" value=##Class(web.Util.Encryption).SimpleEncrypt(value,phCode)	;密码加密
    	.s $p(str,"^",5)=value
   
  	.s hasThisData=..HasThisData(str)
  	.s:hasThisData'=0 ret=1
  	.q:ret'=0
  	.s ret=..SaveOrUpdate(str)
	i ret<0 TRollback
	TCOMMIT
	q ret
Err
	TRollback
	q -1
}

/// Creator：      huaxiaoying
/// CreatDate：    2016-05-11
/// Description：  分页显示产品功能授权表
/// Table：        DHC_EmSysItmAut
/// Input：	      page：当前页数
///               rows：每页条数
/// Return：       
/// d ##class(web.DHCEMSysItmAut).ListSysItmAut(,,"","","","")
ClassMethod ListSysItmAut(page = 1, rows = 10, SAType, SAPointer, SAItmId, SAHospDrID = "", q)
{
	    s start=(page-1)*rows+1
	    s end=page*rows
	    s count=0
	    s jsonObj=##class(web.DHCAPPJsonObject).%New()
	    w "{""rows"":["
		s phId=""
		f  s phId=$o(^DHCEMS(phId)) q:phId=""  d
		.q:phId=0
		.s child=""
		.f  s child=$o(^DHCEMS(phId,"I",child)) quit:child=""  d 
		..s phCode=$p(^DHCEMS(phId,"I",child),"^",1)
		..s isPass=""
		..s:phCode["PASSWORD" isPass=1
		..s childsub=""
		..f  s childsub=$o(^DHCEMS(phId,"I",child,"A",childsub)) quit:childsub=""  d 
		...s code=$p(^DHCEMS(phId,"I",child,"A",childsub),"^",1)
		...s Pointerid=$p(^DHCEMS(phId,"I",child,"A",childsub),"^",2)
		...s SAValue=$p(^DHCEMS(phId,"I",child,"A",childsub),"^",3)
		...s SAHospDr=$p(^DHCEMS(phId,"I",child,"A",childsub),"^",4)
		...s SAHospDesc=$P($g(^CT("HOSP",+SAHospDr)),"^",2)
		...q:(SAType'="")&(SAType'=code)
		...q:(SAPointer'="")&(SAPointer'=Pointerid)
		...q:(SAHospDrID'="")&(SAHospDrID'=SAHospDr) //hxy 2019-07-18
		...q:(q'="")&(Pointerid'[q)
		...s Id=phId_"||"_child_"||"_childsub
		...s SysItmID=phId_"||"_child
		...q:SysItmID'=SAItmId&SAItmId'=0
		...s count=count+1
		...q:count<start
		...q:count>end
		...i code="G" d
		....s PointerDesc=$P(^SSU("SSGRP",Pointerid),"^",1)
		...i code="L" d
		....s PointerDesc=$P(^CTLOC(Pointerid),"^",2)
		...i code="U" d
		....s PointerDesc=$P(^SSU("SSUSR",Pointerid),"^",1)
		....s PointerDescTwo=$P(^SSU("SSUSR",Pointerid),"^",2)
		....s PointerDesc=PointerDescTwo_" ("_PointerDesc_")"
		...i code="D" d
		....s PointerDesc="DHC"
		...s tmp=Id_"^"_code_"^"_Pointerid_"^"_PointerDesc_"^"_SAValue_"^"_SAHospDesc_"^"_phId_"||"_child_"^"_SAHospDr_"^"_isPass
	    ...w $case(count,start:"",:",") 
	    ...w ##class(web.DHCAPPJsonCommon).getJsonData("ID^SAType^SAPointer^PointerDesc^SAValue^SAHospDr^SAParRefDr^SAHospDrID^isPass",tmp)
		w "],""total"":"_count_"}"
		q ""
}

/// Creator：      huaxiaoying
/// CreatDate：    2016-08-11
/// Description：  分页显示空产品功能(授权)表
/// Table：        DHC_EmSysItmAut
/// Input：	      page：当前页数
///               rows：每页条数
/// Return：       
/// d ##class(web.DHCEMSysItmAut).ListSysItmAutNull()
ClassMethod ListSysItmAutNull()
{
	w "{""rows"":["
	w "],""total"":"_0_"}"
	q ""
}

/// Creator：      huaxiaoying
/// CreatDate：    2016-06-07
/// Description：  删除 产品功能授权表
/// Table：        DHC_EmSysItmAut
/// Input：	      Id：rowid
/// /Return：      操作成功 0，其他 失败
ClassMethod RemoveSysItmAut(Id)
{
	  q:+Id=0 -1
	  s obj=##class(User.DHCEmSysItmAut).%DeleteId(Id)
	  q 0
}

/// Creator：      liyarong
/// CreatDate：    2017-04-05
/// Description：  查询授权类型
/// Return
/// d ##class(web.DHCEMSysItmAut).QuerySecFlag("6||3")
ClassMethod QuerySecFlag(SID)
{
    s syId=$p(SID,"||",1)
    s sub=$p(SID,"||",2)
    q:'$d(^DHCEMS(syId,"I",sub))
    s secflags=$p(^DHCEMS(syId,"I",sub),"^",4)
    q:secflags=""
    s ListData=secflags 
    s ListTitle="secflags"
    w ##class(web.DHCSTPHCMCOMMON).getJsonData(ListTitle,ListData)
    q ""
}

/// Creator：      huaxiaoying
/// CreatDate：    2016-06-08
/// Description：  下拉列表显示Y/N
/// Return
/// d ##class(web.DHCEMSysItmAut).ListIsWhich("6||3")
ClassMethod ListIsWhich(SID)
{
    s syId=$p(SID,"||",1)
    s sub=$p(SID,"||",2)
    q:'$d(^DHCEMS(syId,"I",sub)) "[]"
    s secflags=$p(^DHCEMS(syId,"I",sub),"^",4)
    q:secflags="" "[]"
    s jsonObj=##class(web.DHCAPPJsonObject).%New()
    s listObj=##class(%ListOfObjects).%New()
    s len=$l(secflags,"#")
    f i=1:1:len d
      .s secflag=$p(secflags,"#",i)
      .i secflag="G" d
      ..d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","G").Put("text","安全组"))
      .i secflag="L" d
      ..d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","L").Put("text","科室"))
      .i secflag="U" d
      ..d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","U").Put("text","人员"))
	  .i secflag="D" d
	  ..d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","D").Put("text","全院"))
	 w jsonObj.ListToJson(listObj)	
	 q ""
}

/// Creator：      huaxiaoying
/// CreatDate：    2016-06-08
/// Description：  下拉列表显示
/// Table：        SS_Group
/// Return
/// d ##class(web.DHCEMSysItmAut).ListGroup("L",1,10,"","","")
ClassMethod ListGroup(type, page = 1, rows = 10, text, HospDr, q)
{
     
     i type="" w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(0)
     Q:type="" ""
	 s start=(page-1)*rows+1
	 s end=page*rows
	 if (type="G")
	 {
		 w "{""rows"":["
		 s count=0
		 s phId=0
		 /*
	     f  s phId=$o(^SSU("SSGRP",phId)) q:phId=""  d
	     .i $d(^SSU("SSGRP",phId,"HOSP")) d
	     ..i $d(^SSU("SSGRP",phId,"HOSP",0,"Hosp",HospDr)) d
	     ...s SAHospDesc=$P(^SSU("SSGRP",phId),"^",1)
		 ...s tmp=phId_"^"_SAHospDesc
	 	 ...q:(text'="")&(text'=SAHospDesc)
		 ...q:(q'="")&(SAHospDesc'[q)
		 ...s count = count+1
		 ...q:count<start
	 	 ...q:count>end
	 	 ...w $case(count,start:"",:",") 
	 	 ...w ##class(web.DHCAPPJsonCommon).getJsonData("id^text",tmp)
	     .else  d
	     .i '$d(^SSU("SSGRP",phId,"HOSP",0,"Hosp")) d
		 ..s SAHospDesc=$P(^SSU("SSGRP",phId),"^",1)
		 ..s tmp=phId_"^"_SAHospDesc
	 	 ..q:(text'="")&(text'=SAHospDesc)
		 ..q:(q'="")&(SAHospDesc'[q)
		 ..s count = count+1
		 ..q:count<start
	 	 ..q:count>end
	 	 ..w $case(count,start:"",:",") 
	 	 ..w ##class(web.DHCAPPJsonCommon).getJsonData("id^text",tmp)
	 	 */
	 	 
	 	 f  s phId=$o(^SSU("SSGRP",phId)) q:phId=""  d
	 	 .s showFlag=##Class(web.DHCEMCommonUtil).GetHospShowDataFlag("SS_Group",phId,HospDr)
		 .q:showFlag'="Y"
	     .;i $d(^SSU("SSGRP",phId,"HOSP")) d
	     .;i $d(^SSU("SSGRP",phId,"HOSP",0,"Hosp",HospDr)) d
	     .s SAHospDesc=$P(^SSU("SSGRP",phId),"^",1)
		 .s tmp=phId_"^"_SAHospDesc
	 	 .q:(text'="")&(text'=SAHospDesc)
		 .q:(q'="")&(SAHospDesc'[q)
		 .s active=$P(^SSU("SSGRP",phId),"^",151)
		 .q:active'="Y"
		 .s count = count+1
		 .q:count<start
	 	 .q:count>end
	 	 .w $case(count,start:"",:",") 
	 	 .w ##class(web.DHCAPPJsonCommon).getJsonData("id^text",tmp)

		 w "],""total"":"_count_"}"
	 }elseif (type="L")
	 {
		s str=..ListLoc(page , rows ,text,HospDr, q)	 
     }elseif(type="U")
     {
	    s str=..ListUser(page , rows ,text,HospDr, q)	
	 }else
	 {
		s str=..ListDHC()
	 }
	
	 q ""
}

/// Creator：      huaxiaoying
/// CreatDate：    2016-06-08
/// Description：  下拉列表显示
/// Table：        CT_Loc
/// Return
/// d ##class(web.DHCEMSysItmAut).ListLoc(1,10,"",2,"")
ClassMethod ListLoc(page = 1, rows = 10, text, HospDr, q)
{
	 
	 s q=$ZCONVERT(q,"U")
	 s start=(page-1)*rows+1
	 s end=page*rows
	 s jsonObj=##class(web.DHCAPPJsonObject).%New()
	 w "{""rows"":["
	 s count=0
	 s phId=0
     f  s phId=$o(^CTLOC(phId)) q:phId=""  d
	 .s Code=$P(^CTLOC(phId),"^",1)
	 .s LocDesc = $P(^CTLOC(phId),"^",2)
	 .s LocActive=$P(^CTLOC(phId),"^",14)
	 .q:(LocActive'="")&&(LocActive'="Y")
	 .s CTLOCHosDR=$P(^CTLOC(phId),"^",22)
	 .s ContactName=$p(^CTLOC(phId),"^",43)
	 .s ContactName = $ZCONVERT(ContactName,"U")
	 .i (CTLOCHosDR=HospDr)!(CTLOCHosDR="")  d
	 ..s tmp=phId_"^"_LocDesc
	 ..;q:(text'="")&(text'=Code)
	 ..;q:(q'="")&(Code'[q)
	 ..Q:(LocDesc'[q)&&(ContactName'[q)
	 ..s stDate = $p(^CTLOC(phId),"^",24)
	 ..s endDate = $p(^CTLOC(phId),"^",25)
	 ..q:(stDate'="")&&(+$h<stDate)
	 ..q:(endDate'="")&&(+$h>endDate)
	 ..s count = count+1
	 ..q:count<start
	 ..q:count>end
	 ..w $case(count,start:"",:",") 
	 ..w ##class(web.DHCAPPJsonCommon).getJsonData("id^text",tmp)
	 w "],""total"":"_count_"}"
	 q ""
}

/// Creator：      huaxiaoying
/// CreatDate：    2016-06-08
/// Description：  下拉列表显示
/// Table：        SS_User
/// Return
/// d ##class(web.DHCEMSysItmAut).ListUser()
ClassMethod ListUser(page = 1, rows = 10, text, HospDr, q)
{
	 s start=(page-1)*rows+1
	 s end=page*rows
	 w "{""rows"":["
	 s count=0
	 s phId=0
     f  s phId=$o(^SSU("SSUSR",phId)) q:phId=""  d
     .s Code=$P(^SSU("SSUSR",phId),"^",1)
     .s SSUSRHosDR=$P(^SSU("SSUSR",phId),"^",98)
     .i (SSUSRHosDR=HospDr)!(SSUSRHosDR="")  d
	 ..s Codename=$P(^SSU("SSUSR",phId),"^",2)
	 ..s Code=Codename_" ("_Code_")"
	 ..s tmp=phId_"^"_Code
	 ..q:(text'="")&(text'=Code)
	 ..q:(q'="")&(Code'[q)
	 ..s StDate=$p(^SSU("SSUSR",phId),"^",96)
	 ..s EndDate=$p(^SSU("SSUSR",phId),"^",97)
	 ..q:(StDate'="")&&(+$h<StDate)
	 ..q:(EndDate'="")&&(+$h>EndDate)
	 ..s count = count+1
	 ..q:count<start
 	 ..q:count>end
 	 ..w $case(count,start:"",:",") 
	 ..w ##class(web.DHCAPPJsonCommon).getJsonData("id^text",tmp)
	 w "],""total"":"_count_"}"
	 q ""
}

/// Creator：      huaxiaoying
/// CreatDate：    2016-06-08
/// Description：  下拉列表显示
/// Table：        
/// Return
/// d ##class(web.DHCEMSysItmAut).ListD()
ClassMethod ListDHC()
{
	
	 s count=1
	 w "{""rows"":["
	 w "{"
	 w """id"":"_""""_"DHC"_""""_","
	 w """text"":"_""""_"DHC"_""""
	 w "}"
	 w "],""total"":"_count_"}"
	 q ""
}

/// Creator：      zhanghailong
/// CreatDate：    2016-10-12
/// Description：  创伤评分维护获取Y/N
/// Return
/// w ##class(web.DHCEMSysItmAut).GetAISInfo(2)
ClassMethod GetAISInfo(LgHospID)
{
	
	s phId="0"
	f  s phId=$o(^DHCEMS(phId)) q:phId=""  d
	.if $p(^DHCEMS(phId),"^",3)="DHCEM1"  d
	..s child=""
	..f  s child=$o(^DHCEMS(phId,"I",child)) quit:child=""  d 
	...if $p(^DHCEMS(phId,"I",child),"^",1)="AISscore"  d
	....s childsub=""
	....f  s childsub=$o(^DHCEMS(phId,"I",child,"A",childsub)) quit:childsub=""  d 
	.....s HospID=$p(^DHCEMS(phId,"I",child,"A",childsub),"^",4)
	.....i HospID=LgHospID d
	......s trFlag=$p(^DHCEMS(phId,"I",child,"A",childsub),"^",3)
  //s trFlag=$p(^DHCEMS(1,"I",7,"A",1),"^",3)
  q trFlag
}

/// Creator：      zhanghailong
/// CreatDate：    2016-10-12
/// Description：  格拉斯哥获取Y/N
/// Return
/// w ##class(web.DHCEMSysItmAut).GetGlsInfo(2)
ClassMethod GetGlsInfo(LgHospID)
{
	s phId="0"
	f  s phId=$o(^DHCEMS(phId)) q:phId=""  d
	.if $p(^DHCEMS(phId),"^",3)="DHCEM1"  d
	..s child=""
	..f  s child=$o(^DHCEMS(phId,"I",child)) quit:child=""  d 
	...if $p(^DHCEMS(phId,"I",child),"^",1)="Glsscore"  d
	....s childsub=""
	....f  s childsub=$o(^DHCEMS(phId,"I",child,"A",childsub)) quit:childsub=""  d 
	.....s HospID=$p(^DHCEMS(phId,"I",child,"A",childsub),"^",4)
	.....i HospID=LgHospID d
	......s trglsFlag=$p(^DHCEMS(phId,"I",child,"A",childsub),"^",3)
  //s trglsFlag=$p(^DHCEMS(1,"I",8,"A",1),"^",3)
  q trglsFlag
}

}
