Import SQLUser

/// 门急诊量运营
/// by wuqk 2007-08
Class web.DHCMedRMOPAdm Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 98;

ClassMethod GetRMOPAdm(ctloc As %String, power As %String)
{
	n (ctloc,power)
	s ret="-1"
	s retString=""
	
	s Time=+$g(^DHCMedRMOPAdm(0,"Time"))
    s TimeFrom=+$g(^DHCMedRMOPAdm(0,"TimeFrom"))
    s TimeTo=+$g(^DHCMedRMOPAdm(0,"TimeTo"))
    q:(Time'>0)!(TimeFrom'>0)!(TimeTo'>0) ret
    q:(TimeFrom>TimeTo) ret
    
    ;s currDate=+$h
    s currDate=60572
    s currTime=+$p($h,",",2)
    s:'$d(^DHCMedRMOPAdmission(currDate,"Time")) ^DHCMedRMOPAdmission(currDate,"Time")=Time
    i '$d(^DHCMedRMOPAdmission(currDate,ctloc)) d
    .s ctime=TimeFrom
    e  d
    .s ctime=$o(^DHCMedRMOPAdmission(currDate,ctloc,""),-1)
    
    ;Build
    i +power>0 d
    .s Line=0
    .f  s Line=$o(^DHCMedRMOPAdm(Line)) q:Line=""  d
    ..s:Line=1 ret1=..Build1(ctloc,Time,TimeFrom,TimeTo,currDate,currTime,ctime)
    ..;s:Line=2 ret1=..Build2(ctloc,Time,TimeFrom,TimeTo,currDate,currTime,ctime)
        
    s ret=0
    ;Get
    s sTimeString=..GetTimeStr(currDate,ctloc)
    q:sTimeString="" ret
    
    s retstring=sTimeString,tmpReturn=""
    s Line=0,iLines=0
    f  s Line=$o(^DHCMedRMOPAdm(Line)) q:Line=""  d
    .s tmpReturn=""
    .;s Caption=$g(^DHCMedRMOPAdm(Line))
    .s:Line=1 tmpReturn=..GetLine1(currDate,ctloc)
    .q:tmpReturn=""
    .;s sLine=$g(Line)_$c(2)_Caption_$c(2)_tmpReturn
    .;s sLine=Caption_$c(3)_tmpReturn
    .s sLine=tmpReturn
    .s retstring=retstring_$c(1)_sLine
    .s iLines=iLines+1
    
    s ret=iLines_$c(1)_retstring
    
	q ret
}

//*****************************************

//构造数据

//*****************************************

//line1：门急诊量

ClassMethod Build1(ctloc, Time, TimeFrom, TimeTo, currDate, currTime, ctime)
{
	n (ctloc,Time,TimeFrom,TimeTo,currDate,currTime,ctime)
    /*
    s ^DHCMedRMOPAdm(1)="#004D00,1,1,3,门诊急挂号数量"
    date loc time Line= data
    s ^DHCMedRMOPAdmission($h,+loc,52839,1)=4128
    ;s ^DHCMedRMOPAdmission($h,+loc,52839,1,"paadm")=555239
    s ^DHCMedRMOPAdmission($h,+loc,52839,1,"Abort")=39
    */
    s line=1
    s Ret=0
    
    i '$d(^DHCMedRMOPAdmission(currDate,ctloc,ctime,line)) d
    .;Build first data
    .s COUNT=0
    .s ABORT=0
    .s tmpTime=0
    .f  s tmpTime=$o(^PAADMi("PAADM_DateTime",currDate,tmpTime)) q:(tmpTime="")!(tmpTime'<ctime)  d
    ..s paadm=0
    ..f  s paadm=$o(^PAADMi("PAADM_DateTime",currDate,tmpTime,paadm)) q:paadm=""  d
    ...s tmp=$g(^PAADM(+paadm))
    ...;s AdmType=$p(tmp,"^",2)
    ...;q:(AdmType'="O")&(AdmType'="E")
    ...s tmpLoc=+$p(tmp,"^",4)
    ...q:(ctloc'=tmpLoc)&(ctloc'=0)
    ...s VisitStatus=$p(tmp,"^",20)
    ...i VisitStatus="C" d
    ....s ABORT=ABORT+1
    ...e  d
    ....s COUNT=COUNT+1
    .s ALL=COUNT+ABORT
    .s ^DHCMedRMOPAdmission(currDate,ctloc,ctime,line)=COUNT
    .;s ^DHCMedRMOPAdmission(currDate,ctloc,ctime,line,"Abort")=ABORT
    .s ^DHCMedRMOPAdmission(currDate,ctloc,ctime,line,"ALL")=ALL
    e  d
    .;Get pre data
    .s COUNT=+$g(^DHCMedRMOPAdmission(currDate,ctloc,ctime,line))
    .;s ABORT=+$g(^DHCMedRMOPAdmission(currDate,ctloc,ctime,line,"Abort"))
    .s ALL=+$g(^DHCMedRMOPAdmission(currDate,ctloc,ctime,line,"ALL"))
    .s ABORT=ALL-COUNT
    
    s oldXTime=ctime
    s tmpTime=ctime-1,LastPaadm=0
    f  s tmpTime=$o(^PAADMi("PAADM_DateTime",currDate,tmpTime)) q:(tmpTime'<TimeTo)!(tmpTime="")!(currTime<((Time*60)+oldXTime))  d
    .
    .f  q:(tmpTime<((Time*60)+oldXTime))  d
    ..s tmpABORT=$$GetOPABORT(ctloc,currDate,0,LastPaadm)
    ..s:tmpABORT=0 ABORT=tmpABORT
    ..s COUNT=ALL-ABORT
    ..s oldXTime=((Time*60)+oldXTime)
    ..s ^DHCMedRMOPAdmission(currDate,ctloc,oldXTime,line)=COUNT
    ..s ^DHCMedRMOPAdmission(currDate,ctloc,oldXTime,line,"ALL")=ALL
    .;s tmpALL=ALL
    .s paadm=0
    .f  s paadm=$o(^PAADMi("PAADM_DateTime",currDate,tmpTime,paadm)) q:paadm=""  d
    ..s LastPaadm=paadm
    ..s tmp=$g(^PAADM(+paadm))
    ..;s AdmType=$p(tmp,"^",2)
    ..;q:(AdmType'="O")&(AdmType'="E")
    ..s tmpLoc=+$p(tmp,"^",4)
    ..q:(ctloc'=tmpLoc)&(ctloc'=0)
    ..s ALL=ALL+1
    
    q Ret
GetOPABORT(ctloc, currDate, firstPaadm, LastPaadm)
	n (ctloc,currDate,firstPaadm,LastPaadm)
	s ABORT=0
	i firstPaadm=0 d
	.i $d(^PAADMi("PAADM_AdmDate",currDate)) d
	..s firstPaadm=$o(^PAADMi("PAADM_AdmDate",currDate,""))
	
	q:firstPaadm=0 ABORT
	q:firstPaadm'<LastPaadm ABORT
	
	s tmpAdm=firstPaadm-1
	f  s tmpAdm=$o(^PAADM(tmpAdm)) q:(tmpAdm="")!(tmpAdm>LastPaadm)  d
	.s tmp=$g(^PAADM(+tmpAdm))
    .;s AdmType=$p(tmp,"^",2)
    .;q:(AdmType'="O")&(AdmType'="E")
    .s tmpLoc=+$p(tmp,"^",4)
    .q:(ctloc'=tmpLoc)&(ctloc'=0)
    .s VisitStatus=$p(tmp,"^",20)
    .s:VisitStatus="C" ABORT=ABORT+1
	
	q ABORT
}

//*****************************************

//输出数据

//*****************************************

ClassMethod GetTimeStr(currDate, ctloc)
{
	n (currDate,ctloc)
	s ret=""
	q:'$d(^DHCMedRMOPAdmission(currDate,ctloc)) 
	
	s ctime=$o(^DHCMedRMOPAdmission(currDate,ctloc,""))
	s ret=$zt(ctime,2)
    f  s ctime=$o(^DHCMedRMOPAdmission(currDate,ctloc,ctime)) q:ctime=""  d
    .s ret=ret_$c(3)_$zt(ctime,2)
	
	q ret
}

//line1：门急诊量

ClassMethod GetLine1(currDate, ctloc)
{
	n (currDate,ctloc)
	s line=1
	s ret=""
	s Caption=$g(^DHCMedRMOPAdm(1))
	;s $p(Caption,",",5)=..GetUnicode($p(Caption,",",5))
	s ret=Caption
	s ctime=0
	f  s ctime=$o(^DHCMedRMOPAdmission(currDate,ctloc,ctime)) q:ctime=""  d
	.s ret=ret_$c(3)_+$g(^DHCMedRMOPAdmission(currDate,ctloc,ctime,line))
	
	q ret
}

ClassMethod ddd(x)
{
  n (x)
   ;Get YMax
   s MaxData=x
	s YMax=0
	i MaxData<10 d
	.s:MaxData>4 YMax=10
	.s:MaxData'>4 YMax=5
	e  d
	.s YMaxLen=$l(MaxData)
	.s Max1=$e(MaxData,1,1)
	.s Max2=$e(MaxData,2,2)
	.i Max2>4 d
	..s Max1=Max1+1
	..s Max2=0
	.e  d
	..s Max2=5
	.s YMax=Max1_Max2
	.f i=3:1:YMaxLen d
	..s YMax=YMax_"0"
	s YMax=+YMax
	w YMax
	q
}

ClassMethod GetUnicode(str)
{
   n (str)
   s ret=""
   FOR i=1:1:$LENGTH(str) {
    SET ret=ret_"&#x"_$zh($ASCII(str,i))_";"
    }

   q ret
}

//**/

//

ClassMethod Build2(ctloc, Time, TimeFrom, TimeTo, currDate, currTime, ctime)
{
	n (ctloc,Time,TimeFrom,TimeTo,currDate,currTime,ctime)
    /*
    s ^DHCMedRMOPAdm(2)="#0000FF,1,1,1,已就诊人数"
    date loc time Line= data
    s ^DHCMedRMOPAdmission($h,+loc,52839,1)=4128
    ;s ^DHCMedRMOPAdmission($h,+loc,52839,1,"paadm")=555239
    s ^DHCMedRMOPAdmission($h,+loc,52839,1,"Abort")=39
    */
    s line=2
    s Ret=0
    
    i '$d(^DHCMedRMOPAdmission(currDate,ctloc,ctime,line)) d
    .;Build first data
    .s COUNT=0
    .s ABORT=0
    .s tmpTime=0
    .f  s tmpTime=$o(^PAADMi("PAADM_DateTime",currDate,tmpTime)) q:(tmpTime="")!(tmpTime'<ctime)  d
    ..s paadm=0
    ..f  s paadm=$o(^PAADMi("PAADM_DateTime",currDate,tmpTime,paadm)) q:paadm=""  d
    ...s tmp=$g(^PAADM(+paadm))
    ...;s AdmType=$p(tmp,"^",2)
    ...;q:(AdmType'="O")&(AdmType'="E")
    ...s tmpLoc=+$p(tmp,"^",4)
    ...q:(ctloc'=tmpLoc)&(ctloc'=0)
    ...s VisitStatus=$p(tmp,"^",20)
    ...i VisitStatus="C" d
    ....s ABORT=ABORT+1
    ...e  d
    ....s COUNT=COUNT+1
    .s ALL=COUNT+ABORT
    .s ^DHCMedRMOPAdmission(currDate,ctloc,ctime,line)=COUNT
    .;s ^DHCMedRMOPAdmission(currDate,ctloc,ctime,line,"Abort")=ABORT
    .s ^DHCMedRMOPAdmission(currDate,ctloc,ctime,line,"ALL")=ALL
    e  d
    .;Get pre data
    .s COUNT=+$g(^DHCMedRMOPAdmission(currDate,ctloc,ctime,line))
    .;s ABORT=+$g(^DHCMedRMOPAdmission(currDate,ctloc,ctime,line,"Abort"))
    .s ALL=+$g(^DHCMedRMOPAdmission(currDate,ctloc,ctime,line,"ALL"))
    .s ABORT=ALL-COUNT
    
    s oldXTime=ctime
    s tmpTime=ctime-1,LastPaadm=0
    f  s tmpTime=$o(^PAADMi("PAADM_DateTime",currDate,tmpTime)) q:(tmpTime'<TimeTo)!(tmpTime="")!(currTime<((Time*60)+oldXTime))  d
    .
    .f  q:(tmpTime<((Time*60)+oldXTime))  d
    ..;s tmpABORT=$$GetOPABORT(ctloc,currDate,0,LastPaadm)
    ..s:tmpABORT=0 ABORT=tmpABORT
    ..s COUNT=ALL-ABORT
    ..s oldXTime=((Time*60)+oldXTime)
    ..s ^DHCMedRMOPAdmission(currDate,ctloc,oldXTime,line)=COUNT
    ..s ^DHCMedRMOPAdmission(currDate,ctloc,oldXTime,line,"ALL")=ALL
    .;s tmpALL=ALL
    .s paadm=0
    .f  s paadm=$o(^PAADMi("PAADM_DateTime",currDate,tmpTime,paadm)) q:paadm=""  d
    ..s LastPaadm=paadm
    ..s tmp=$g(^PAADM(+paadm))
    ..;s AdmType=$p(tmp,"^",2)
    ..;q:(AdmType'="O")&(AdmType'="E")
    ..s tmpLoc=+$p(tmp,"^",4)
    ..q:(ctloc'=tmpLoc)&(ctloc'=0)
    ..s ALL=ALL+1
    
    q Ret
}

}
