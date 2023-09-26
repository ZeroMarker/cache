Class User.DHCConSultationNew Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Relationship SubRecord As User.DHCConSultationNewSub [ Cardinality = children, Inverse = Parref ];

Property Adm As %String(TRUNCATE = 1);

// 医师级别

Property AppDep As %String(TRUNCATE = 1);

Property AppDate As %Library.Date(FORMAT = 1);

Property AppTime As %Library.Time;

Property AppDoc As %String(TRUNCATE = 1);

/// /Property ConsultDoc As %String(TRUNCATE = 1); //会诊科室
Property ConType As %Library.String(DISPLAYLIST = ",Emergency,Common,MultiLoc", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",E,C,M");

Property InOut As %Library.String(DISPLAYLIST = ",In,Out", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",I,O");

Property ConDestination As %String(COLLATION = "Exact", MAXLEN = 5000, TRUNCATE = 0);

Property Status As %Library.String(DISPLAYLIST = ",Verify,Excute,Cancel,Finish,Refuse,Wait", MAXLEN = 6, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",V,E,C,F,R,W");

/// /Property RelOrder As %String(TRUNCATE = 1);
Property RecUser As %String(TRUNCATE = 1);

Property Specordid As %String(TRUNCATE = 1);

// 特殊抗菌药医嘱id

/// Property MoreLoc As %String(TRUNCATE = 1);
Property attitudetsy As %String(TRUNCATE = 1);

/// 诊断
Property Diag As %String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0);

/// 会诊申请医嘱 --请什么科室会诊
Property ConSultApplyOrder As User.OEOrdItem;

/// /是否是急会诊
Property EmergenCon As %Library.String(DISPLAYLIST = ",Emergency", MAXLEN = 6, SELECTIVITY = "50.0000%", TRUNCATE = 1, VALUELIST = ",E");

/// 会诊目的、需解决的问题
Property ConDestinationtwo As %String(COLLATION = "Exact", MAXLEN = 5000, TRUNCATE = 0);

/// /多科会诊地点
Property MoreConPlace As %String(TRUNCATE = 1);

/// /多科会诊要求会诊时间
Property MoreConTime As %String(TRUNCATE = 1);

Index Specordid On Specordid;

Index ArcimAdm On (Specordid, Adm);

Index Adm On Adm;

Index AppDep On (AppDate, AppDep);

Index ConSultApplyOrder On ConSultApplyOrder;

ClassMethod Save(parr, InsertOrdFlag) As %String
{
	;s ^sctmpv1("saveNew") = parr_"-,-"_ InsertOrdFlag
	////q 0
  TS
  s result=""
	s l=$L(parr,"^")
	for i=1:1:l
	{
		s itm=$P(parr,"^",i)
		if itm="" continue
		s name=$P(itm,"|")
		s val=$P(itm,"|",2)
		s tmp(name)=val
	}
	s obj=##class(User.DHCConSultationNew).%New()
	if $D(tmp("EpisdeID")) s obj.Adm=tmp("EpisdeID")
	if $D(tmp("AppDep")) s obj.AppDep=tmp("AppDep")
	if $D(tmp("AppDate"))
	{
		if $G(tmp("AppDate"))'="" s obj.AppDate=##class(websys.Conversions).DateHtmlToLogical(tmp("AppDate"))
		//if $G(tmp("AppDate"))'="" s obj.AppDate=$ZDH(tmp("AppDate"),3)
		else  s obj.AppDate=""
	}
	if $D(tmp("AppTime"))
	{
		if $G(tmp("AppTime"))'="" s obj.AppTime=$ZTH(tmp("AppTime"))
		else  s obj.AppTime=""
	}
	if $D(tmp("AppDoc")) s obj.AppDoc=tmp("AppDoc")
	if $D(tmp("ConType")) s obj.ConType=tmp("ConType")
	if $D(tmp("InOut")) s obj.InOut=tmp("InOut")
	if $D(tmp("ConDestination")) s obj.ConDestination=tmp("ConDestination")
	if $D(tmp("ConDestinationtwo")) s obj.ConDestinationtwo=tmp("ConDestinationtwo")
	if $D(tmp("MoreConPlace")) s obj.MoreConPlace=tmp("MoreConPlace")
	if $D(tmp("MoreConTime")) s obj.MoreConTime=tmp("MoreConTime")
	if $D(tmp("Status")) s obj.Status=tmp("Status")
	if $D(tmp("AppDoc")) s obj.RecUser=tmp("AppDoc")
	if $D(tmp("Diag")) s obj.Diag=tmp("Diag")
	if $D(tmp("EmergenCon")) s obj.EmergenCon=tmp("EmergenCon")
	////if $D(tmp("MoreLoc")) s a.MoreLoc=tmp("MoreLoc")  //多科会诊
	
	d obj.%Save()
	//d obj.%Close()
	
	s Parref=obj.%Id()
	
	s length=$l(tmp("ConsultDep"),"!")
	f i=1:1:length
	{
	s objsub=##class(User.DHCConSultationNewSub).%New()
	s objsub.Parref=Parref
	s resultdep=$p(tmp("ConsultDep"),"!",i)
	s objsub.ConsultDep=$p(resultdep,"#",1)      //$p(tmp("ConsultDep"),"!",i)
	s objsub.ItmConsultDep=$p(resultdep,"#",2)
	//s objsub.ConsultDep=$p(tmp("ConsultDep"),"!",i)
	s objsub.DocGrade=""
	//s objsub.RequestConDoc=""
	d obj.SubRecord.Insert(objsub)
	s sc=objsub.%Save()
	If $$$ISERR(sc) {
	 s result="1"
    // Do $System.Status.DisplayError(sc)
     //TRO      //
    }
	d objsub.%Save()
	d objsub.%Close()	
		}
		
	d obj.%Close()
	//s Parref=obj.%Id()
	//s ret=##class(User.DHCConSultationNewSub).Save(Parref,tmp("ConsultDep")
	if result="1"
	{
		TRO
		q "error"
		}
	TC
	//obj.%Id()
	q 0_"^"_obj.%Id()
}

// 判断时间格式，返回1表示正确的时间格式，0不合法格式

ClassMethod istime(str)
{
	s len=$l(str,":")
	s match=$s(len=3:str?1.2N1":"1.2N1":"1.2N,len=2:str?1.2N1":"1.2N,1:0)
	q:match=0 0
	q:($p(str,":")>24)!($p(str,":",2)>60)!($p(str,":",3)>60) 0
	q match
}

// 返回1表示合法的日期格式,否则不合法

ClassMethod isdate(str)
{
	s match=$s(str["/"=1:str?1.2N1"/"2N1"/"4N,str["-"=1:str?4N1"-"1.2N1"-"1.2N,1:0)
	q:match=0 0
	i str["-" d
	.s year=$p(str,"-")
	.s month=$p(str,"-",2)
	.i (month>12)!(month<1) s match=0 q
	.d getdays(year,month)
	.i ($p(str,"-",3)<1)!($p(str,"-",3)>days) s match=0 q
	i str["/" d
	.s year=$p(str,"/",3)
	.s month=$p(str,"/",2)
	.i (month>12)!(month<1) s match=0 q
	.d getdays(year,month)
	.i ($p(str,"/")<1)!($p(str,"/")>days) s match=0 q
	q match
getdays(year,month)
    s calmonth="31;28;31;30;31;30;31;31;30;31;30;31"
 	s days=+$p(calmonth,";",+month)
 	if (+month=2)&(year#4=0)&((year#100'=0)!(year#400=0)) s days=29 
 	q days
}

/// W ##CLASS(User.DHCConSultationNew).Audit("1^76^1!2^1494^2!","1","eerew","12323",366,2)
ClassMethod Audit(parr, id, Conplace, ConTime, userId = "", count) As %String
{
	s result=""   
	i userId="" s userId=%session.Data("LOGON.USERID")  //获取登陆人员
	;s ^sctmpv1("Audit")=parr_","_id_","_Conplace_","_ConTime_","_userId _","_ count
	b ;s aa = bentddfd
	TS
	s length=$l(parr,"!")
	s obj=##class(User.DHCConSultationNew).%OpenId(id)
	
	if $ISObject(obj)
	{
	if (obj.Status="E")!(obj.Status="F")
	{
		d obj.%Close()
		TRO
		q "会诊已确认过"
	}
	s Adm=obj.Adm
	s AppDep=obj.AppDep
	s AppDate=obj.AppDate
	s AppDoc=obj.AppDoc
	s AppTime=obj.AppTime	
	s Diag=obj.Diag	
	s ConType=obj.ConType
	s InOut=obj.InOut
	s ConDestination=obj.ConDestination	
	s obj.MoreConPlace=Conplace
	s obj.MoreConTime=ConTime
	s DocGrade=""
	s Parref=obj.%Id()
	s obj.Status="E"
	}
	Set sc = obj.%Save()
	If $$$ISERR(sc) {
	TRO
	q "error"	
	}
	d obj.%Close()
	b ;s ConDepID="881"     //写死科室 --北京同仁医院
	f i=1:1:length-1
	{
	 s res=$p(parr,"!",i)
	  s requstdep=$p(res,"^",1)  //要求会诊科室
	  s requstdoc=$p(res,"^",2)  //医生
	  s ItmConsultDep=$p(res,"^",3)     ///要求会诊的子科室
	  s requstdep=$replace(requstdep," ","") 
	   s acConsultDoc=requstdoc //要求会诊医生
	   s CTCareTp=""
	   i acConsultDoc'=""
	   {
		   ;B ;1
	 b ;s CTCareDr=$p(^SSU("SSUSR",acConsultDoc),"^",14)  //
	 ;i CTCareDr'="" 
	 s CTCareTp=$p(^CTPCP(acConsultDoc,1),"^",4)
	 e  s CTCareTp=""
	 }
	 s DocGrade= CTCareTp ;$s(CTCareTp="1":"D",CTCareTp="2":"A",CTCareTp="3":"C",CTCareTp="4":"P",CTCareTp="5":"E",1:"")   //获取医护人员医师级别
	  s objcon=##class(User.DHCConsultation).%New()
	  s objcon.Adm=Adm
	  s objcon.AppDep=AppDep
	  s objcon.AppDate=AppDate
	  s objcon.AppDoc=AppDoc
	  s objcon.AppTime=AppTime
	  s objcon.RecDate=AppDate
	  s objcon.RecTime=AppTime
	  s objcon.RecUser=AppDoc
	  
	  s objcon.Diag=Diag
	  s objcon.ConType=ConType
	  s objcon.InOut=InOut
	  s objcon.ConDestination=ConDestination
	  //s objcon.DocGrade="A"    //先不考虑医师级别
	  s objcon.DocGrade=DocGrade
	  s objcon.ConsultDep=requstdep
	  s objcon.RequestConDoc=requstdoc
	  s objcon.Status="V"  //申请状态
	  s objcon.MoreConPlace=Conplace
	  s objcon.MoreConTime=ConTime
	  s objcon.ConSultPontDr=##class(User.DHCConSultationNew).%OpenId(Parref)             //Parref
	  s objcon.ItmConDep=ItmConsultDep
	  s info=AppDate_"^"_AppDoc _"^"_Diag _"^"_ ConType _"^"_ InOut _"^"_ ConDestination _"^"_DocGrade _"^"_requstdep _"^"_requstdoc _"^"_ Conplace _"^"_ConTime _"^"_Parref
	  b ;objcon.%Save()
	  Set sc = objcon.%Save()
 	  If $$$ISERR(sc) {
	  	s result="1"
	  	//s error=$System.Status.GetErrorText(sc)  ///错误文本信息
     	// Do $System.Status.DisplayError(sc)
     	//TRO 
 	  }

	  d objcon.%Save()
	  d objcon.%Close()
	//*************拆分插入
	s ConAppID=objcon.%Id()
	s ConAppIDS(i)=ConAppID
	;s acConsultDoc=requstdoc //要求会诊医生
	 ;s CTCareDr=$p(^SSU("SSUSR",acConsultDoc),"^",14)  //
	 ;i CTCareDr'="" 
	 s CTCareTp=$p(^CTPCP(requstdoc,1),"^",4)
	 e  s CTCareTp=""
	 s DocGrade= CTCareTp ;$s(CTCareTp="1":"D",CTCareTp="2":"A",CTCareTp="3":"C",CTCareTp="4":"P",CTCareTp="5":"E",1:"")   //获取医护人员医师级别
	//发送消息
	 	;S ^scv1("sendM")=AppDoc_","_Adm_","_requstdoc_","_requstdep
	 	d ##class(User.DHCConsultation).Sendmessage(AppDoc,Adm,requstdoc,requstdep,ConAppID)
	}
	f j=1:1:length-1
	{
	 s res=$p(parr,"!",j)
	  s requstdep=$p(res,"^",1)  //要求会诊科室
	  s requstdoc=$p(res,"^",2)
	  s ItmConsultDep=$p(res,"^",3)     ///要求会诊的子科室
	  s requstdep=$replace(requstdep," ","") 
	  s acConsultDoc=requstdoc //要求会诊医生
	  s idSub=$o(^User.DHCConSultationNewSubI("ConsultDep",id," "_requstdep,""))
	  i idSub'=""
	  {
		  s idSubobj=##class(User.DHCConSultationNewSub).%OpenId(id_"||"_idSub)
		  if $ISObject(idSubobj)
		  {
			  s idSubobj.RequestConDoc=requstdoc
			  s idSubobj.ItmConsultDep=ItmConsultDep
			  //d obj.SubRecord.Insert(idSubobj)
			  s rs=idSubobj.%Save()
			  If $$$ISERR(rs) {
			  s result="1"
			  }
			  
			 }
	  }
	  i (idSub="")&&(requstdep'=""){
			s objsub=##class(User.DHCConSultationNewSub).%New()
			s objsub.Parref=id
			s objsub.ConsultDep=requstdep  
			s objsub.RequestConDoc=requstdoc 
			s objsub.ItmConsultDep=ItmConsultDep			
			s objsub.DocGrade=""
			d obj.SubRecord.Insert(objsub)
			s sc=objsub.%Save()
			If $$$ISERR(sc) {
			 s result="1"
		    }
			d objsub.%Close()	
	  }
	  b //审核多科会诊申请时插入医嘱SC20161228
	  s rtn=##class(web.DHCConsult).InsertConsultOrder(AppDoc,AppDep,Adm,requstdep,ConAppIDS(j),InOut,DocGrade,"A")
	}
	if result="1"
	{
		TRO
		q "插入错误"
		}
	//TC
	s type="V"
	s SendInfo=0 ;##class(web.DHCConsultNew).SendConsultApply(id,type)
	i count>1 s SendInfo="0"    ;多科会诊不用发电子病历	
	i SendInfo'="0"
	{
		TRO
		q "给电子病历发送消息失败!"_"^"_id_"^"_SendInfo
	}
	TC
	q 0
}

/**/
/// / s ConDepID="881"     //写死科室 --北京同仁医院  这句写死的
/// W ##CLASS(User.DHCConSultationNew).Audit("1^62^1!2^66^2!3^1304^3!,14,对方答复,12-27,,3")
ClassMethod AuditBAK(parr, id, Conplace, ConTime, userId = "", count) As %String
{
	;s ^sctmpv1("Audit")=parr_","_id_","_Conplace_","_ConTime_","_userId _","_ count
	s result=""   
	i userId="" s userId=%session.Data("LOGON.USERID")  //获取登陆人员
	TS
	s length=$l(parr,"!")
	s obj=##class(User.DHCConSultationNew).%OpenId(id)
	
	if $ISObject(obj)
	{
	if (obj.Status="E")!(obj.Status="F")
	{
		d obj.%Close()
		TRO
		q "会诊已确认过"
		
		}
	s Adm=obj.Adm
	s AppDep=obj.AppDep
	s AppDate=obj.AppDate
	s AppDoc=obj.AppDoc
	s AppTime=obj.AppTime	
	s Diag=obj.Diag	
	s ConType=obj.ConType
	s InOut=obj.InOut
	s ConDestination=obj.ConDestination	
	s obj.MoreConPlace=Conplace
	s obj.MoreConTime=ConTime
	s DocGrade=""
	s Parref=obj.%Id()
	s obj.Status="E"
	}
	Set sc = obj.%Save()
	If $$$ISERR(sc) {
	TRO
	q "error"	
	}
	d obj.%Close()
	s ConDepID="881"     //写死科室 --北京同仁医院
	f i=1:1:length-1
	{
	 s res=$p(parr,"!",i)
	  s requstdep=$p(res,"^",1)  //要求会诊科室
	  s requstdoc=$p(res,"^",2)
	  s ItmConsultDep=$p(res,"^",3)     ///要求会诊的子科室
	  s requstdep=$replace(requstdep," ","") 
	   s acConsultDoc=requstdoc //要求会诊医生
	   s CTCareTp=""
	   i acConsultDoc'=""
	   {
	 s CTCareDr=$p(^SSU("SSUSR",acConsultDoc),"^",14)  //
	 i CTCareDr'="" s CTCareTp=$p(^CTPCP(CTCareDr,1),"^",4)
	 e  s CTCareTp=""
	 }
	 s DocGrade=$s(CTCareTp="1":"D",CTCareTp="2":"A",CTCareTp="3":"C",CTCareTp="4":"P",CTCareTp="5":"E",1:"")   //获取医护人员医师级别
	
	 
	  s objcon=##class(User.DHCConsultation).%New()
	  s objcon.Adm=Adm
	  s objcon.AppDep=AppDep
	  s objcon.AppDate=AppDate
	  s objcon.AppDoc=AppDoc
	  s objcon.AppTime=AppTime
	  s objcon.RecDate=AppDate
	  s objcon.RecTime=AppTime
	  s objcon.RecUser=AppDoc
	  
	  s objcon.Diag=Diag
	  s objcon.ConType=ConType
	  s objcon.InOut=InOut
	  s objcon.ConDestination=ConDestination
	  //s objcon.DocGrade="A"    //先不考虑医师级别
	  s objcon.DocGrade=DocGrade
	  s objcon.ConsultDep=requstdep
	  s objcon.RequestConDoc=requstdoc
	  s objcon.Status="V"  //申请状态
	  s objcon.MoreConPlace=Conplace
	  s objcon.MoreConTime=ConTime
	  s objcon.ConSultPontDr=##class(User.DHCConSultationNew).%OpenId(Parref)             //Parref
	  s objcon.ItmConDep=ItmConsultDep
	  s info=AppDate_"^"_AppDoc _"^"_Diag _"^"_ ConType _"^"_ InOut _"^"_ ConDestination _"^"_DocGrade _"^"_requstdep _"^"_requstdoc _"^"_ Conplace _"^"_ConTime _"^"_Parref
	  Set sc = objcon.%Save()
 If $$$ISERR(sc) {
	 s result="1"
	  //s error=$System.Status.GetErrorText(sc)  ///错误文本信息
     // Do $System.Status.DisplayError(sc)
     //TRO 
 	}

	  d objcon.%Save()
	  d objcon.%Close()
	//*************拆分插入
	s ConAppID=objcon.%Id()
	s acConsultDoc=requstdoc //要求会诊医生
	 s CTCareDr=$p(^SSU("SSUSR",acConsultDoc),"^",14)  //
	 i CTCareDr'="" s CTCareTp=$p(^CTPCP(CTCareDr,1),"^",4)
	 e  s CTCareTp=""
	 s DocGrade=$s(CTCareTp="1":"D",CTCareTp="2":"A",CTCareTp="3":"C",CTCareTp="4":"P",CTCareTp="5":"E",1:"")   //获取医护人员医师级别
	//**************************  
	}
	f j=1:1:length-1
	{
	 s res=$p(parr,"!",j)
	  s requstdep=$p(res,"^",1)  //要求会诊科室
	  s requstdoc=$p(res,"^",2)
	  s ItmConsultDep=$p(res,"^",3)     ///要求会诊的子科室
	  s requstdep=$replace(requstdep," ","") 
	  s acConsultDoc=requstdoc //要求会诊医生
	  s idSub=$o(^User.DHCConSultationNewSubI("ConsultDep",id," "_requstdep,""))
	  i idSub'=""
	  {
		  s idSubobj=##class(User.DHCConSultationNewSub).%OpenId(id_"||"_idSub)
		  if $ISObject(idSubobj)
		  {
			  s idSubobj.RequestConDoc=requstdoc
			  s idSubobj.ItmConsultDep=ItmConsultDep
			  //d obj.SubRecord.Insert(idSubobj)
			  s rs=idSubobj.%Save()
			  If $$$ISERR(rs) {
			  s result="1"
			  }
			  
			  }
		  
		  }
	}
	if result="1"
	{
		TRO
		q "插入错误"
		}
	//TC
	s type="V"
	s SendInfo=##class(web.DHCConsultNew).SendConsultApply(id,type)
	i count>1 s SendInfo="0"    ;多科会诊不用发电子病历	
	i SendInfo'="0"
	{
		TRO
		q "给电子病历发送消息失败!"_"^"_id_"^"_SendInfo
		}
    TC
	q 0
}

ClassMethod Refuse(id) As %String
{
	s result=""   
	TS
	;s length=$l(parr,"!")
	s obj=##class(User.DHCConSultationNew).%OpenId(id)
	
	if $ISObject(obj)
	{
	if (obj.Status="E")!(obj.Status="F")
	{
		d obj.%Close()
		TRO
		q "会诊已确认过"
	}
	
	s obj.Status="R"
	}
	Set sc = obj.%Save()
	If $$$ISERR(sc) {
	TRO
	s error = $System.Status.GetErrorText(sc)
	q error	
	}
	d obj.%Close()
	TC
	q 0
}

// 单条会诊申请直接插入会诊表

ClassMethod SaveSingle(parr, InsertOrdFlag) As %String
{
  TS
	s l=$L(parr,"^") 
	for i=1:1:l
	{
		s itm=$P(parr,"^",i)
		if itm="" continue
		s name=$P(itm,"|")
		s val=$P(itm,"|",2)
		s tmp(name)=val
	}
	s obj=##class(User.DHCConsultation).%New()
	if $D(tmp("EpisdeID")) s obj.Adm=tmp("EpisdeID")
	if $D(tmp("AppDep")) s obj.AppDep=tmp("AppDep")
	if $D(tmp("AppDate"))
	{
		if $G(tmp("AppDate"))'=""  s obj.AppDate=$ZDH(tmp("AppDate"),3)
		else  s obj.AppDate=""
	}
	if $D(tmp("AppTime"))
	{
		if $G(tmp("AppTime"))'="" s obj.AppTime=$ZTH(tmp("AppTime"))
		else  s obj.AppTime=""
		
	}
	if $D(tmp("AppDoc")) 
	{
		s obj.AppDoc=tmp("AppDoc")
	    s obj.RecUser=tmp("AppDoc")	
	}
	s obj.RecDate=+$H
	s obj.RecTime=$P($H,",",2)
	if $D(tmp("ConType")) s obj.ConType=tmp("ConType")
	if $D(tmp("InOut")) s obj.InOut=tmp("InOut")
	if $D(tmp("ConDestination")) s obj.ConDestination=tmp("ConDestination")
	if $D(tmp("ConDestinationtwo")) s obj.ConDestinationtwo=tmp("ConDestinationtwo")
	if $D(tmp("Status")) s obj.Status=tmp("Status")
	if $D(tmp("AppDoc")) s obj.RecUser=tmp("AppDoc")
	if $D(tmp("Diag")) s obj.Diag=tmp("Diag")
	////if $D(tmp("MoreLoc")) s a.MoreLoc=tmp("MoreLoc")  //多科会诊
	if $D(tmp("ConsultDep")) s obj.ConsultDep=$p(tmp("ConsultDep"),"#",1) //会诊科室 
	Set sc = obj.%Save()
	If $$$ISERR(sc) {
	 
     s error=$System.Status.GetErrorText(sc)
     TRO      //回滚
     q "201^"_error
 }

	TC
	//s ^SingleConSult(obj.%Id())=+$h_"^"_$p($h,",",2)
	q 0_"^"_obj.%Id()
}

Storage Default
{
<Data name="DHCConSultationNewDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Adm</Value>
</Value>
<Value name="3">
<Value>AppDate</Value>
</Value>
<Value name="4">
<Value>AppTime</Value>
</Value>
<Value name="5">
<Value>AppDep</Value>
</Value>
<Value name="6">
<Value>AppDoc</Value>
</Value>
<Value name="7">
<Value>ConType</Value>
</Value>
<Value name="8">
<Value>InOut</Value>
</Value>
<Value name="9">
<Value>ConDestination</Value>
</Value>
<Value name="10">
<Value>Status</Value>
</Value>
<Value name="11">
<Value>RecUser</Value>
</Value>
<Value name="12">
<Value>Specordid</Value>
</Value>
<Value name="13">
<Value>attitudetsy</Value>
</Value>
<Value name="14">
<Value>Diag</Value>
</Value>
<Value name="15">
<Value>ConSultApplyOrder</Value>
</Value>
<Value name="16">
<Value>EmergenCon</Value>
</Value>
<Value name="17">
<Value>ConDestinationtwo</Value>
</Value>
<Value name="18">
<Value>MoreConPlace</Value>
</Value>
<Value name="19">
<Value>MoreConTime</Value>
</Value>
</Data>
<DataLocation>^User.DHCConSultationNewD</DataLocation>
<DefaultData>DHCConSultationNewDefaultData</DefaultData>
<IdLocation>^User.DHCConSultationNewD</IdLocation>
<IndexLocation>^User.DHCConSultationNewI</IndexLocation>
<StreamLocation>^User.DHCConSultationNewS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
