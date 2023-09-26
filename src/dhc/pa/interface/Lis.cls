Class dhc.pa.interface.Lis Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Others:w ##class(dhc.pa.interface.Lis).ExportJCDate("201401")
ClassMethod ExportJCDate(yearmonth)
{
	
 ///Description：1医嘱日期^2审核日期^3接受科室id^4接受科室名称^5医嘱项code^6医嘱rowid^7集中接受日期/登记日期^8病人类型^9接受日期^10报告人
 ///             输出10个字段值插入绩效中间表dhc_pa_data.DHCCJXPALisPacsDataA
 ///InPut:Sdate,Edate
 ///OutPut:stdate_" "_sttime_"^"_GetVerifyDate_" "_GetVerifyTime_"^"_reloc_"^"_relocname_"^"_arcimcode_"^"_OeoriRowid_"^"_GetstrRegDate_" "_GetstrRegTime_"^"_admtype_"^"_GetRptDate_" "_GetRptTime_"^"_GetRptDocName
 ///Table: Oe_Order,Oe_Orditem, Arc_Itmmast, DHCRB_Report,dhc_pa_data.DHCCJXPALisPacsDataA
 ///Creator:
 ///d ExportJCDate^Export("2014-01-01","2014-01-01")
 ;s file="/tmp/JCDatetime201406.txt"
 ;o file:"WNS"
 ;u file
 
 ;w "检查科室id^检查科室^检查项目^报告医生^医嘱日期^登记日期^报告日期^审核日期"
 ;w "1医嘱日期^2审核日期^3接受科室id^4接受科室名称^5医嘱项code^6医嘱rowid^7集中接受日期/登记日期^8病人类型^9接受日期^10报告人"
 n (yearmonth)
 s Sdate=$E(yearmonth,1,4)_"-"_$E(yearmonth,5,6)_"-"_"01"
 s month=$E(yearmonth,5,6)+1
 s month="0"_month
 s endyearmonth=$E(yearmonth,1,4)_"-"_month_"-"_"01"
 s endyearmonth=$zdateh(endyearmonth,3)-1
 s Edate=$zdate(endyearmonth,3)
 ;w "yearmonth->"_yearmonth_"->"_" startyearmonth->"_startyearmonth_" endyearmonth->"_endyearmonth,!
 s i=0
 s date1=0
 s Sdate=$zdh(Sdate,3),Edate=$zdh(Edate,3)
 f date1=Sdate:1:Edate d
 .s oeitmid=""
 .f  s oeitmid=$o(^OEORDi(0,"ItemDate",date1,oeitmid)) q:oeitmid=""  d
 ..s admid=$p(^OEORD(oeitmid),"^",1)
 ..s admtype=$p(^PAADM(admid),"^",2)
 ..;q:admtype="H"
 ..s oeitmsub=""
 ..f  s oeitmsub=$o(^OEORDi(0,"ItemDate",date1,oeitmid,oeitmsub)) q:oeitmsub=""  d
 ...s OeoriRowid=oeitmid_"||"_oeitmsub
 ...s arcitm=$p(^OEORD(oeitmid,"I",oeitmsub,1),"^",2)
 ...s stdate=$p(^OEORD(oeitmid,"I",oeitmsub,1),"^",9)
 ...i stdate'="" s stdate1=$zd(stdate,3)                  //开医嘱日期
 ...s sttime=$p(^OEORD(oeitmid,"I",oeitmsub,1),"^",10)
 ...i sttime'="" s sttime1=$zt(sttime,1)                  //开医嘱时间
 ...s arcid=$p(^OEORD(oeitmid,"I",oeitmsub,1),"^",2)
 ...i arcid'=""  s arcdesc=$p(^ARCIM(+arcid,$p(arcid,"||",2),1),"^",2)
 ...s reloc=$p(^OEORD(oeitmid,"I",oeitmsub,3),"^",6)
 ...s relocname=$p(^CTLOC(reloc),"^",1)                  //接收科室
 ...s arcid=$p(arcitm,"||",1),arcsub=$p(arcitm,"||",2)
 ...s arcservice=$p(^ARCIM(arcid,arcsub,7),"^",6)
 ...s arcimcode=$p(^ARCIM(arcid,arcsub,1),"^",1)         //医嘱项code
 ...q:arcservice'="S"
 ...;b ;1
 ...s ExamOrder=oeitmid_"||"_oeitmsub
 ...s RegInfo=##class(web.DHCRisCommFunctionEx).GetRegInfo(ExamOrder)
 ...s GetStudyNo=$p(RegInfo,"^",1)
 ...i GetStudyNo'="" d
 ....s GetPatientStatusCode="I"
 ....s GetstrRegDate=$p(RegInfo,"^",2)
 ....s GetstrRegDate1=$zdh(GetstrRegDate,3)        //登记日期
 ....s GetstrRegTime=$p(RegInfo,"^",3)
 ....s GetstrRegTime1=$zth(GetstrRegTime,3)        //登记时间
 ....s GetImgcount=0
 ....s Imrowid=0 f  s Imrowid=$o(^DHCRBStudyi("StudyNo-Images",GetStudyNo,Imrowid)) q:Imrowid=""  d
 .....s GetPatientStatusCode="E"    ;正在检查
 .....s ExtName=$p($g(^DHCRBStudy(0,"StudyImages",Imrowid)),"^",2)
 .....i ((ExtName="avi")!(ExtName="dcm")!(ExtName="normal")!(ExtName="dsa"))  d
 ......s GetImgcount=GetImgcount+1
 ......s GetReportStatusCode="I"             ;图象已经采集
 ....s sReportStuatCode="VS"
 ....s Rptrowid=0  f  s Rptrowid=$o(^DHCRBStudyi("Report","StudyNo",GetStudyNo,Rptrowid)) q:Rptrowid=""  d
 .....s GetRptID=$p(^DHCRBStudy("Report",Rptrowid),"^",2)
 .....s GetRptVersion=$p(^DHCRBStudy("Report",Rptrowid),"^",3)
 .....s GetRptStatusDR=$p(^DHCRBStudy("Report",Rptrowid),"^",4)
 .....i GetRptStatusDR'="" d
 ......;b ;3
 ......s GetReportStatusCode=$p(^DHCRBCStatus("ReportStatus",GetRptStatusDR),"^",1)
 ......i sReportStuatCode[GetReportStatusCode d
 .......s GetPatientStatusCode="O"
 ......e  d
 .......s GetPatientStatusCode="E"
 ......s GetRptDocDR=$p($g(^DHCRBStudy("Report",Rptrowid)),"^",8)     //报告医生
 ......i GetRptDocDR'="" s GetRptDocName=$p(^SSU("SSUSR",GetRptDocDR),"^",2)
 ......;b ;6666
 ......s GetRptDate=$p(^DHCRBStudy("Report",Rptrowid),"^",9)
 ......i GetRptDate'="" s GetRptDate=$zd(GetRptDate,3)
 ......s GetRptTime=$p(^DHCRBStudy("Report",Rptrowid),"^",10)
 ......i GetRptTime'="" s GetRptTime=$zt(GetRptTime,1)
 ......s GetVerifyDocDR=$p(^DHCRBStudy("Report",Rptrowid),"^",11)     //审核医生
 ......i GetVerifyDocDR'="" s GetVerifyDocName=$p(^SSU("SSUSR",GetVerifyDocDR),"^",2)
 ......s GetVerifyDate=$p(^DHCRBStudy("Report",Rptrowid),"^",12)
 ......i GetVerifyDate'="" s GetVerifyDate1=$zd(GetVerifyDate,3)
 ......s GetVerifyTime=$p(^DHCRBStudy("Report",Rptrowid),"^",13)
 ......i GetVerifyTime'="" s GetVerifyTime1=$zt(GetVerifyTime,1)
 ......s WaitDate=($g(GetstrRegDate1)-$g(stdate))*24                  //预约等待日期
 ......s WaitTime=($g(GetstrRegTime1)-$g(sttime))/3600                //预约等待时间
 ......s Wait1=$g(WaitDate)+$g(WaitTime)
 ......s Wait=$fn(Wait1,"",2)
 ......s WaitReportDate=($g(GetVerifyDate1)-$g(GetstrRegDate))*24     //出报告日期
 ......s WaitReportTime=($g(GetVerifyTime1)-$g(GetstrRegTime))/3600    //出报告时间
 ......s Wait2=$g(WaitReportDate)+$g(WaitReportTime)
 ......s WaitReport=$fn(Wait2,"",2)
 ......k PLIST 
 ......s PLIST(2)=stdate1_" "_sttime1                  //医嘱日期                插入 ApplyTime
 ......s PLIST(3)=GetVerifyDate1_" "_GetVerifyTime1     //审核日期                插入 AuditTime
 ......s PLIST(4)=reloc                                //接收科室id              插入 DeptID 
 ......s PLIST(5)=relocname                            //接收科室名称            插入 DeptName
 ......s PLIST(6)=arcimcode                            //医嘱项code              插入 DoctorAdviceID 
 ......s PLIST(7)=OeoriRowid                           //医嘱rowid               插入 DoctorAdviceNo
 ......s PLIST(8)=GetstrRegDate_" "_GetstrRegTime      //登记日期/集中接受日期   插入 LisReceiveOrPacsCheckRegTime
 ......s PLIST(9)=admtype                              //病人类型                插入 PatientType
 ......s PLIST(10)=GetRptDate_" "_GetRptTime           //接收日期                插入 ReceiveTime
 ......s PLIST(11)=$g(GetRptDocName)                   //报告医生                插入 Reportor
 ......s PLIST(12)=Wait                                //预约等待时间            插入 DateWaitTime
 ......s PLIST(13)=WaitReport                          //出报告时间              插入 ReportTime
 ......&SQL(insert into dhc_pa_data.DHCCJXPALisPacsDataA Values PLIST()) 
 ......;i SQLCODE q
 ......;w !,stdate_" "_sttime_"^"_GetVerifyDate_" "_GetVerifyTime_"^"_reloc_"^"_relocname_"^"_arcimcode_"^"_OeoriRowid_"^"_GetstrRegDate_" "_GetstrRegTime_"^"_admtype_"^"_GetRptDate_" "_GetRptTime_"^"_GetRptDocName
 ......s i=i+1
 ;c file
 q i
}

/// Others:w ##class(dhc.pa.interface.Lis).ExportLisTime("201402")
ClassMethod ExportLisTime(yearmonth)
{
	///Description：1医嘱日期^2审核日期^3接受科室id^4接受科室名称^5医嘱项code^6医嘱rowid^7集中接受日期/登记日期^8病人类型^9接受日期^10报告人
   ///             输出10个字段值插入绩效中间表dhc_pa_data.DHCCJXPALisPacsDataA
   ///InPut:Sdate,Edate
   ///OutPut:ReqDate_" "_ReqTime_"^"_AuthDate_" "_AuthTime_"^"_reloc_"^"_relocname_"^"_ArcimCode_"^"_OrdRowId_"^"_recdate1_" "_rectime1_"^"_Admtype_"^"_RecDate_" "_RecTime_"^"_AuthUserDesc
   ///Table: Oe_Order,Oe_Orditem, Arc_Itmmast, DHCRB_Report,dhc_pa_data.DHCCJXPALisPacsDataA
   ///Creator:
   ///d ExportLisTime^Export("2014-01-01","2014-01-01")
   ;s file="/tmp/LISDatetime201406.txt"
   ;o file:"WNS"
   ;u file
 
 ;w "医嘱号^医嘱名^接收科室^患者类型^申请时间^集中接收时间^接收^审核"
 ;w "1医嘱日期^2审核日期^3接受科室id^4接受科室名称^5医嘱项code^6医嘱rowid^7集中接受日期/登记日期^8病人类型^9接受日期^10报告人"
 
  n (yearmonth)
 s Sdate=$E(yearmonth,1,4)_"-"_$E(yearmonth,5,6)_"-"_"01"
 s month=$E(yearmonth,5,6)+1
 s month="0"_month
 s endyearmonth=$E(yearmonth,1,4)_"-"_month_"-"_"01"
 s endyearmonth=$zdateh(endyearmonth,3)-1
 s Edate=$zdate(endyearmonth,3)
 Set Config=##Class(websys.Configuration).%OpenId(1)
 Set LABDATA=Config.LabDataNamespace
 If '$Length(LABDATA) Set LABDATA="LABDATA"
 
 s i=0
 s date1=0
 s Sdate=$zdh(Sdate,3),Edate=$zdh(Edate,3)
 f{
      s date1=Sdate
      s Sdate=Sdate+1
      ;b ;date1
      q:date1>Edate
      s OrdId=""
      f {
           s OrdId=$o(^OEORDi(0,"ItemDate",date1,OrdId))
           q:OrdId=""
           s SubId=""
           f {
                s SubId=$o(^OEORDi(0,"ItemDate",date1,OrdId,SubId))
                q:SubId=""
                s OrdRowId=OrdId_"||"_SubId                                  //医嘱rowid
                s reloc=$p(^OEORD(OrdId,"I",SubId,3),"^",6)
                s relocname=$p(^CTLOC(reloc),"^",1)                          //接收科室
                s admid=$p(^OEORD(OrdId),"^",1)
                s Admtype=$p(^PAADM(admid),"^",2)                            //就诊类型
                s OrdStr1=$g(^OEORD(OrdId,"I",SubId,1))
                s OrdStr3=$g(^OEORD(OrdId,"I",SubId,3))
                s ItmMastDr=$p(OrdStr1,"^",2)
                s arcid=$p(ItmMastDr,"||",1),arcsub=$p(ItmMastDr,"||",2)
                s ArcimCode=$p(^ARCIM(arcid,arcsub,1),"^",1)                 //医嘱项code
                i $l(ItmMastDr),##class(web.DHCLabOrder).isLabTS(ItmMastDr){
                     s OrdName=""
                     i $l(ItmMastDr),$d(^ARCIM(+ItmMastDr,$p(ItmMastDr,"||",2),1)){
                          s OrdName=$p(^ARCIM(+ItmMastDr,$p(ItmMastDr,"||",2),1),"^",2)
                     }
                     //申请日期时间
                     s ReqTime=$p(OrdStr1,"^",17)
                     i $l(ReqTime) s ReqTime1=$zt(ReqTime,1)
                     s ReqDate=$p(OrdStr3,"^",7)
                     //比较日期
                     s flag="N"
                     i $l(ReqDate){
                          ;i $l(FromDate),ReqDate-FromDate<0 s flag="Y"
                          ;i flag="N",$l(ToDate),ReqDate-ToDate>0 s flag="Y"
                     }
                     //比较科室
                     //i flag="N",$l(
                     i $l(ReqDate) s ReqDate1=$zd(ReqDate,3)
                     //检验号
                     s LabEpisode=$p(OrdStr3,"^",20)
 
                     //b 20
                     //报告ID
                     s LabTestSetRow=$p(OrdStr3,"^",35)
                     s ReportStus="N"
                     s (RecDate,RecTime,AuthDate,AuthTime,TransComm,TSResultAnomaly,TSMemo)=""
                     s ReportFlag="N"  //预报告
                     //标本提示
                     s TSMemo=##class(web.DHCLabResultStatus).checkTSMemo(OrdRowId,LabEpisode)
                     i '$l(TSMemo) s TSMemo="【未接收】"
                     i flag="N"{
                          i $l(LabTestSetRow){
                               //b 100
                               s LabNo=$p(LabTestSetRow,"||",1)
                               s TS=$p(LabTestSetRow,"||",2)
                               s TSCnt=$p(LabTestSetRow,"||",3)
                               i $l(LabNo),$l(TS),$l(TSCnt),$d(^TEPI(LabNo,1,TS,TSCnt)){
                                    i $p(^TEPI(LabNo,1,TS,TSCnt),"\",31)="A" s ReportStus="Y"
                                    //i ('$l(AuthFlag))!('((ReportStus="N")&(AuthFlag="Y")))
                                    ;i AuthFlag="Y" {
                                         ;i ReportStus'="Y" s flag="Y"
                                    ;}
                                    ;i AuthFlag="N" {
                                    ;     i ReportStus="Y" s flag="Y"
                                    ;}
                                    i flag="N"{
                                    s recdate1="",rectime1=""
                                    zn "labdata_p8"
                                    if $d(^DHCSpecimenRegister(LabNo)){
                                    s recdate=$P(^DHCSpecimenRegister(LabNo),"\",4)
                                    s recdate1=$zd(recdate,3)
                                    s rectime=$P(^DHCSpecimenRegister(LabNo),"\",5)
                                    s rectime1=$zt(rectime,1)}
                                    zn "dhc-app"
                                         //b 200
                                         //接收日期时间
                                         s RecDate=$p(^TEPI(LabNo,1,TS,TSCnt),"\",21)
                                         i $l(RecDate) s RecDate=$zd(RecDate,3)
                                         s RecTime=$p(^TEPI(LabNo,1,TS,TSCnt),"\",22)
                                         i $l(RecTime) s RecTime=$zt(RecTime*60,1)
                                         //审核日期时间
                                         s AuthDate=$p(^TEPI(LabNo,1,TS,TSCnt),"\",4)
                                         i $l(AuthDate) s AuthDate1=$zd(AuthDate,3)
                                         ;b ;eeeee
                                         s AuthTime=$p(^TEPI(LabNo,1,TS,TSCnt),"\",5)
                                         i $l(AuthTime) s AuthTime1=$zt(AuthTime*60,1) 
                                         s AuthTime=$zt(AuthTime1,1)
                                         //报告医生
                                         s AuthUser=$p(^TEPI(LabNo,1,TS,TSCnt),"\",6)               //报告医生
                                         ;b ;8888
                                         i AuthUser'="" s AuthUserDesc=$p($g(^[LABDATA]SSU("SSUSR",1,AuthUser)),"^",2)
                                         ;b ;9999
                                         //是否有预报告
                                         ;i $p(^TEPI(LabNo,1,TS,TSCnt),"\",31)'="A",$d(^["LABDATA"]DHCPreReport(LabNo,TS,TSCnt)) s ReportFlag="Y"
                                         //危急提示
                                         s TransComm=##Class(web.DHCLabCommon).GetWarnComment(LabNo,TS,TSCnt)
                                         //结果异常标志
                                         s TSResultAnomaly=##class(web.DHCLabResultStatus).checkTSResultStatus(LabTestSetRow)
                                         //结果
                                         i $p(^TEPI(LabNo,1,TS,TSCnt),"\",31)="A" s TSMemo="【已报告】"
                                         i $p(^TEPI(LabNo,1,TS,TSCnt),"\",31)="E" s TSMemo="【正在化验】"
                                         i $p(^TEPI(LabNo,1,TS,TSCnt),"\",31)="C" s TSMemo="【已接收】"
                                         s RtnValue=1
                                    }
                               } else{
                                    ;i AuthFlag="Y" s flag="Y"
                               }
                          } else {
                               ;i AuthFlag="Y" s flag="Y"
                          }    
                     }    
                     i flag="N"{              
                          //标本OE_OrdSpecimen
                          s SpecDr=$o(^OEORD(OrdId,"I",SubId,"SPEC",""),-1)
                          s (SpecCode,SpecName)=""
                          i $l(SpecDr) s SpecCode=$p(^OEORD(OrdId,"I",SubId,"SPEC",SpecDr),"^",1)
                          i $l(SpecCode),$d(^TTAB("SPEC",SpecCode)){
                               s SpecName=$p(^TTAB("SPEC",SpecCode),"\",1)
                          }
                          //采集日期时间Collection
                          s (SpecDate,SpecTime)=""
                          s OrdExecId=$o(^DHCOrdExec(0,"DHCOEORI",OrdRowId,""),-1)
                          i $l(OrdExecId){
                               s SpecDate=$p(^DHCOrdExec(OrdExecId),"^",13)
                               i $l(SpecDate) s SpecDate=$zd(SpecDate,3)
                               s SpecTime=$p(^DHCOrdExec(OrdExecId),"^",14)
                               i $l(SpecTime) s SpecTime=$zt(SpecTime,1)
                          }
                          ;set Data=$lb(OrdRowId,OrdName,ReqDate,ReqTime,ReportStus,LabEpisode,LabTestSetRow,SpecName,SpecDate,SpecTime,RecDate,RecTime,AuthDate,AuthTime,ReportFlag,TransComm,TSResultAnomaly,TSMemo)
                          ;w !,OrdRowId_"^"_OrdName_"^"_relocname_"^"_admtype_"^"_ReqDate_" "_ReqTime_"^"_recdate1_" "_rectime1_"^"_RecDate_" "_RecTime_"^"_AuthDate_" "_AuthTime
                          
                          s WaitDate=($g(recdate)-$g(ReqDate))*24                       //预约等待日期
                          s WaitTime=($g(rectime)-$g(ReqTime))/3600                     //预约等待时间
                          s Wait1=$g(WaitDate)+$g(WaitTime)
                          s Wait=$fn(Wait1,"",2)
                          
                          i recdate1'=""&rectime1'=""{
                          s WaitReportDate=($g(AuthDate1)-$g(recdate1))*24                 //出报告日期
                          s WaitReportTime=($g(AuthTime1)-$g(rectime1))/3600              //出报告时间
                          } else{
	                      s WaitReportDate=($g(AuthDate1)-$g(RecDate))*24                 //出报告日期
                          s WaitReportTime=($g(AuthTime1)-$g(RecTime))/3600              //出报告时间    
	                          
	                          }
                          s Wait2=$g(WaitReportDate)+$g(WaitReportTime)
                          s WaitReport=$fn(Wait2,"",2)
                          ;b ;00000
                          
                          k PLIST
                          s PLIST(2)=ReqDate1_" "_ReqTime1              //医嘱日期                插入 ApplyTime
                          s PLIST(3)=AuthDate1_" "_AuthTime1            //审核日期                插入 AuditTime
                          s PLIST(4)=reloc                              //接收科室id              插入 DeptID 
                          s PLIST(5)=relocname                          //接收科室名称            插入 DeptName
                          s PLIST(6)=ArcimCode                          //医嘱项code              插入 DoctorAdviceID 
                          s PLIST(7)=OrdRowId                           //医嘱rowid               插入 DoctorAdviceNo
                          s PLIST(8)=recdate1_" "_rectime1              //登记日期/集中接受日期   插入 LisReceiveOrPacsCheckRegTime
                          s PLIST(9)=Admtype                            //病人类型                插入 PatientType
                          s PLIST(10)=RecDate_" "_RecTime               //接收日期                插入 ReceiveTime
                          s PLIST(11)=AuthUserDesc                      //报告医生                插入 Reportor
                          s PLIST(12)=Wait                              //预约等待时间            插入 DateWaitTime
                          s PLIST(13)=WaitReport                        //出报告时间              插入 ReportTime
                          &SQL(INSERT INTO dhc_pa_data.DHCCJXPALisPacsDataA VALUES PLIST())
                          s i=i+1
                     }
                     //d OutputRow
                }
           }
      }
 }
 ;c file
 q i
}

Storage Default
{
<StreamLocation>^dhc.pa.interface.LisS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
