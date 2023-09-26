Class web.DHCMicStatPositiveRate Extends %Persistent
{

/// 细菌分离统计
Parameter BUILD = 60;

ClassMethod QuerySampleStatisticsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QuerySampleStatisticsExecute ]
{
	S repid=$LIST(qHandle,2)
 	K ^CacheTemp(repid)
	Q $$$OK
}

/// Query的执行方法
/// D ##class(%ResultSet).RunQuery("web.类名","query名称","参数1","参数2",参数……
/// D ##class(%ResultSet).RunQuery("web.DHCMicStatBugIsolate","QuerySampleStatistics","2013-04-01","2013-05-15","","","","","","")
ClassMethod QuerySampleStatisticsExecute(ByRef qHandle As %Binary, DateS As %String, DateE As %String) As %Status
{
  S repid=$I(^CacheTemp)
  I $G(ind)="" S ind=1
  S sLabNameSpace="LABDATA"	
  S sMedNameSpace="DHC-DATA"	
  I '$L(sLabNameSpace) S sLabNameSpace="LABDATA"
  I '$L(sMedNameSpace) S sMedNameSpace="DHC-DATA"
  S HospCode=$O(^TTABi("CC",1,""))
  S DateS=$G(DateS),DateE=$G(DateE)
  S DateS=$ZDH(DateS,3),DateE=$ZDH(DateE,3)
  S DepCode=""
  I $D(^TTABi("DEP",60)) S DepCode=$O(^TTABi("DEP",60,""))
  Set BugStr=$Get(BugStr),RoomCode=$Get(RoomCode),CurDepCode=$Get(CurDepCode)
   S BugType=$Get(BugType),CurSampCode=$Get(CurSampCode),BugFlag=$Get(BugFlag)
   Set Num=1,vbTab=$Char(9)
   If BugType=0 Do
   .Set PLIST(1)=vbTab_"细菌代码"_vbTab_"细菌名称"_vbTab_"株数"_vbTab_"细菌百分比(%)"_vbTab_vbTab
   .Set PLIST(2)="350^1500^2500^1500^2500^1500^1500^1500^1500^2300^1200^900^2300^900^1200"
   If BugType=1 Do
   .Set PLIST(1)=vbTab_"科室代码"_vbTab_"临床科室"_vbTab_"细菌代码"_vbTab_"细菌名称"_vbTab_"株数"_vbTab_"细菌百分比(%)"_vbTab_vbTab
   .Set PLIST(2)="350^1500^2000^1500^2500^1500^1500^1500^1500^2300^1200^900^2300^900^1200^1200^900^2300^900^1200^1200^900^2300^900^1200"
   If BugType=2 Do
   .Set PLIST(1)=vbTab_"标本代码"_vbTab_"标本名称"_vbTab_"细菌代码"_vbTab_"细菌名称"_vbTab_"株数"_vbTab_"细菌百分比(%)"_vbTab_vbTab
   .Set PLIST(2)="350^1500^1500^1500^2500^1500^1500^1500^1500^2300^1200^900^2300^900^1200"
   //按菌属统计,按照细菌组来设置
   If BugType=3 Do
   .If BugFlag=1 Do
   ..Set PLIST(1)=vbTab_"菌属名称"_vbTab_"细菌名称"_vbTab_"株数"_vbTab_"菌属百分比(%)"_vbTab_vbTab
   ..Set PLIST(2)="350^2500^2500^2500^2500^2500^2500^2500^2500^2500^2500^2500^2500^2500^2200"
   .Else  Do
   ..Set PLIST(1)=vbTab_"菌属名称"_vbTab_""_vbTab_"株数"_vbTab_"菌属百分比(%)"_vbTab_vbTab
   ..Set PLIST(2)="350^2500^0^2500^2500^2500^2500^2500^2500^2500^2500^900^2300^900^1200"
   //按照科室，标本统计
   If BugType=4 Do
   .Set PLIST(1)=vbTab_"科室名称"_vbTab_"标本名称"_vbTab_"细菌代码"_vbTab_"细菌名称"_vbTab_"株数"_vbTab_"细菌百分比(%)"_vbTab_vbTab
   .Set PLIST(2)="350^2500^2500^1500^2500^1500^1500^1500^1500^2300^1200^900^2300^900^1200"
   Kill ^TMP($ZName,$Job)
   For Date=SttDate:1:EndDate Do 
   .Do ByCurDate(Date)
   Set i=1
   Set P0=""
   If Num>1 Do
   .//无条件
   .If BugType=0 Do
   ..Set iBugCode="" For  Set iBugCode=$Order(^TMP($ZName,$Job,iBugCode)) Quit:iBugCode=""  Do
   ...Set BugName=""
   ...If $Data(^TTAB("BUG",iBugCode))  Set BugName=$Piece(^TTAB("BUG",iBugCode),"\",1)  
   ...Set BugNum=0
   ...Set RowId="" For  Set RowId=$Order(^TMP($ZName,$Job,iBugCode,RowId)) Quit:RowId=""  Do
   ....Set BugNum=BugNum+1
   ....Kill ^TMP($ZName,$Job,iBugCode,RowId)
   ...Set ^TMP($ZName,$Job,i)=i_vbTab_iBugCode_vbTab_BugName_vbTab_BugNum_vbTab_$FNUMBER((BugNum/(Num-1))*100,",",2)
   ...Set i=i+1
   .//--------处理科室------------
   .//按照科室横向显示
   .If (BugType=1)&(BugFlag=0) Do
   ..Set iDep=""  For  Set iDep=$Order(^TMP($ZName,$Job,iDep)) Quit:iDep=""  Do
   ...Set DeptName="" 
   ...If $Data(^TTAB("USLOC",iDep)) Set DeptName=$Piece(^TTAB("USLOC",iDep),"\",1)
   ...Set iBugCode="" For  Set iBugCode=$Order(^TMP($ZName,$Job,iDep,iBugCode)) Quit:iBugCode=""  Do
   ....Set BugName=""
   ....If $Data(^TTAB("BUG",iBugCode))  Set BugName=$Piece(^TTAB("BUG",iBugCode),"\",1)  
   ....Set BugNum=0
   ....Set RowId="" For  Set RowId=$Order(^TMP($ZName,$Job,iDep,iBugCode,RowId)) Quit:RowId=""  Do
   .....Set BugNum=BugNum+1
   .....Kill ^TMP($ZName,$Job,iDep,iBugCode,RowId)
   ....Set ^TMP($ZName,$Job,i)=i_vbTab_iDep_vbTab_DeptName_vbTab_iBugCode_vbTab_BugName_vbTab_BugNum_vbTab_$FNUMBER((BugNum/(Num-1))*100,",",2)_vbTab
   ....Set i=i+1
   .//按照科室纵向显示
   .If (BugType=1)&(BugFlag=1) Do
   ..Set (DepCodeStr,DepNameStr)=""
   ..Set iDepCode="" For  Set iDepCode=$Order(^TMP($ZName,$Job,"DeptCode",iDepCode)) Quit:iDepCode=""  Do
   ...Set iDepName="不详"
   ...If $Data(^TTAB("USLOC",iDepCode)) Set iDepName=$Piece(^TTAB("USLOC",iDepCode),"\",1)
   ...Set DepCodeStr=DepCodeStr_vbTab_iDepCode
   ...Set DepNameStr=DepNameStr_vbTab_iDepName
   ..Kill ^TMP($ZName,$Job,"DeptCode")
   ..//重新定义抬头
   ..Set PLIST(1)=vbTab_DepNameStr_vbTab
   ..Set PLIST(2)="500^3500^1500^1500^1500^1500^1500^1500^1500^1500^1500^1500^1500^1500^1500^1500^1500^1500^1500^1500^1500^1500^1500^1500^1500^1500^1500^1500^1500^1500^1500^1500^1500^1500^1500^1500^1500^1500^1500^1500^1500^1500^1500^1500^1500^1500^1500"
   ..Set iBugCode="" For  Set iBugCode=$Order(^TMP($ZName,$Job,"BUG",iBugCode)) Quit:iBugCode=""  Do
   ...Set BugName=""
   ...If $Data(^TTAB("BUG",iBugCode))  Set BugName=$Piece(^TTAB("BUG",iBugCode),"\",1)
   ...Set BugStr=""
   ...For iDep=2:1:$Length(DepCodeStr,vbTab) Do
   ....Set BugsTotal=0
   ....Set iDepCode=$Piece(DepCodeStr,vbTab,iDep)
   ....If $Data(^TMP($ZName,$Job,"BUG",iBugCode,iDepCode)) Do
   .....Set RowId="" For  Set RowId=$Order(^TMP($ZName,$Job,"BUG",iBugCode,iDepCode,RowId)) Quit:RowId=""  Do 
   ......Set BugsTotal=BugsTotal+1
   ......Kill ^TMP($ZName,$Job,"BUG",iBugCode,iDepCode,RowId)
   ....//取出个数。
   ....If BugsTotal=0 Do
   .....Set BugStr=BugStr_vbTab_""
   ....Else  Do
   .....Set BugStr=BugStr_vbTab_BugsTotal
   ...Set ^TMP($ZName,$Job,i)=i_vbTab_BugName_BugStr
   ...Set i=i+1
   ..Set Num=""
   .//------------------处理标本--------------------
   .//按照标本横向显示
   .If (BugType=2)&(BugFlag=0) Do
   ..Set iSampCode="" For  Set iSampCode=$Order(^TMP($ZName,$Job,iSampCode)) Quit:iSampCode=""  Do
   ...Set SampName=""
   ...If $Data(^TTAB("SPEC",iSampCode)) Set SampName=$Piece(^TTAB("SPEC",iSampCode),"\",1)
   ...Set iBugCode="" For  Set iBugCode=$Order(^TMP($ZName,$Job,iSampCode,iBugCode)) Quit:iBugCode=""  Do
   ....Set BugName=""
   ....If $Data(^TTAB("BUG",iBugCode))  Set BugName=$Piece(^TTAB("BUG",iBugCode),"\",1)  
   ....Set BugNum=0
   ....Set RowId="" For  Set RowId=$Order(^TMP($ZName,$Job,iSampCode,iBugCode,RowId)) Quit:RowId=""  Do
   .....Set BugNum=BugNum+1
   .....Kill ^TMP($ZName,$Job,iSampCode,iBugCode,RowId)
   ....Set ^TMP($ZName,$Job,i)=i_vbTab_iSampCode_vbTab_SampName_vbTab_iBugCode_vbTab_BugName_vbTab_BugNum_vbTab_$FNUMBER((BugNum/(Num-1))*100,",",2)
   ....Set i=i+1
   .//按照标本纵向显示
   .If (BugType=2)&(BugFlag=1) Do
   ..Set (SampCodeStr,SampNameStr)=""
   ..Set iSampCode="" For  Set iSampCode=$Order(^TMP($ZName,$Job,"SampCode",iSampCode)) Quit:iSampCode=""  Do
   ...If $Length(CurSampCode)&(CurSampCode'=iSampCode) Quit
   ...Set SampName="不详"
   ...If $Data(^TTAB("SPEC",iSampCode)) Set SampName=$Piece(^TTAB("SPEC",iSampCode),"\",1)
   ...Set SampCodeStr=SampCodeStr_vbTab_iSampCode
   ...Set SampNameStr=SampNameStr_vbTab_SampName
   ..Kill ^TMP($ZName,$Job,"SampCode")
   ..//重新定义抬头
   ..Set PLIST(1)=vbTab_SampNameStr_vbTab
   ..Set PLIST(2)="500^3500^1500^1500^1500^1500^1500^1500^1500^1500^1500^1500^1500^1500^1500^1500^1500^1500^1500^1500^1500^1500^1500^1500^1500^1500^1500^1500^1500^1500^1500^1500^1500^1500^1500^1500^1500^1500^1500^1500^1500^1500^1500^1500^1500^1500^1500"
   ..Set iBugCode="" For  Set iBugCode=$Order(^TMP($ZName,$Job,"BUG",iBugCode)) Quit:iBugCode=""  Do
   ...Set BugName=""
   ...If $Data(^TTAB("BUG",iBugCode))  Set BugName=$Piece(^TTAB("BUG",iBugCode),"\",1)
   ...Set BugStr=""
   ...For iSamp=2:1:$Length(SampCodeStr,vbTab) Do
   ....Set BugsTotal=0
   ....Set iSampCode=$Piece(SampCodeStr,vbTab,iSamp)
   ....If $Data(^TMP($ZName,$Job,"BUG",iBugCode,iSampCode)) Do
   .....Set RowId="" For  Set RowId=$Order(^TMP($ZName,$Job,"BUG",iBugCode,iSampCode,RowId)) Quit:RowId=""  Do 
   ......Set BugsTotal=BugsTotal+1
   ......Kill ^TMP($ZName,$Job,"BUG",iBugCode,iSampCode,RowId)
   ....//取出个数。
   ....If BugsTotal=0 Do
   .....Set BugStr=BugStr_vbTab_""
   ....Else  Do
   .....Set BugStr=BugStr_vbTab_BugsTotal
   ...Set ^TMP($ZName,$Job,i)=i_vbTab_BugName_BugStr
   ...Set i=i+1
   ..Set Num=""
   .//-----------处理菌属--------------
   .If BugType=3 Do
   ..Set iBugGroup="" For  Set iBugGroup=$Order(^TMP($ZName,$Job,"BUGGROUP",iBugGroup)) Quit:iBugGroup=""  Do
   ...Set BugGroupName=""
   ...If $Data(^TTAB("BUG-GROUP",iBugGroup)) Set BugGroupName=$Piece(^TTAB("BUG-GROUP",iBugGroup),"\",1)
   ...Set BugGroupNum=0
   ...Set RowId="" For  Set RowId=$Order(^TMP($ZName,$Job,"BUGGROUP",iBugGroup,RowId)) Quit:RowId=""  Do
   ....Set BugGroupNum=BugGroupNum+1
   ....Kill ^TMP($ZName,$Job,iBugGroup,RowId)
   ...Set ^TMP($ZName,$Job,i)=""_vbTab_BugGroupName_vbTab_""_vbTab_BugGroupNum_vbTab_$FNUMBER((BugGroupNum/(Num-1))*100,",",2)_vbTab
   ...Set i=i+1
   ...If BugFlag=0 Quit
   ...//增加对明细的显示。
   ...Set iBugCode="" For  Set iBugCode=$Order(^TMP($ZName,$Job,"BUG",iBugGroup,iBugCode)) Quit:iBugCode=""  Do
   ....Set BugName="",BugNum=0
   ....If $Data(^TTAB("BUG",iBugCode))  Set BugName=$Piece(^TTAB("BUG",iBugCode),"\",1)  
   ....Set RowId="" For  Set RowId=$Order(^TMP($ZName,$Job,"BUG",iBugGroup,iBugCode,RowId)) Quit:RowId=""  Do
   .....Set BugNum=BugNum+1
   .....Kill ^TMP($ZName,$Job,iBugGroup,iBugCode,RowId)
   ....Set ^TMP($ZName,$Job,i)=""_vbTab_""_vbTab_BugName_vbTab_BugNum_vbTab_$FNUMBER((BugNum/(Num-1))*100,",",2)_vbTab
   ....Set i=i+1
   .//--------处理科室,标本统计-------------
   .If BugType=4 Do
   ..Set iDepCode="" For  Set iDepCode=$Order(^TMP($ZName,$Job,"DEPSAMP",iDepCode)) Quit:iDepCode=""  Do
   ...Set iDepName="不详"
   ...If $Data(^TTAB("USLOC",iDepCode)) Set iDepName=$Piece(^TTAB("USLOC",iDepCode),"\",1)
   ...Set iSampCode="" For  Set iSampCode=$Order(^TMP($ZName,$Job,"DEPSAMP",iDepCode,iSampCode)) Quit:iSampCode=""  Do
   ....Set SampName="不详"
   ....If $Data(^TTAB("SPEC",iSampCode)) Set SampName=$Piece(^TTAB("SPEC",iSampCode),"\",1)
   ....Set iBugCode="" For  Set iBugCode=$Order(^TMP($ZName,$Job,"DEPSAMP",iDepCode,iSampCode,iBugCode)) Quit:iBugCode=""  Do
   .....Set BugName="",BugNum=0
   .....If $Data(^TTAB("BUG",iBugCode))  Set BugName=$Piece(^TTAB("BUG",iBugCode),"\",1)
   .....Set RowId=""  For  Set RowId=$Order(^TMP($ZName,$Job,"DEPSAMP",iDepCode,iSampCode,iBugCode,RowId)) Quit:RowId=""  Do
   ......B ;3
   ......Set BugNum=BugNum+1
   ......Kill ^TMP($ZName,$Job,iDepCode,iSampCode,iBugCode,RowId)
   .....Set ^TMP($ZName,$Job,i)=i_vbTab_iDepName_vbTab_SampName_vbTab_iBugCode_vbTab_BugName_vbTab_BugNum_vbTab_$FNUMBER((BugNum/(Num-1))*100,",",2)
   .....Set i=i+1
   .If i>1 Do
   ..Set P0="总株数:【"_(Num-1)_"】"
   Quit i 
   
ByCurDate(Date)
  Set Date=$Get(Date)
  //Set labno="" For  Set labno=$Order(^TEPIi("AUTHORISED",Date,labno)) Quit:labno=""  Do
  s labno="" f  s labno=$o(^TEPIi("DEPART",Date,RoomCode,labno)) q:labno=""  d
  .;//医院代码控制?----DaiYi----
  .Set CurHospitalCode=$Piece(^TEPI(labno),"\",26)
  .If $Length(HospCode),$l(CurHospitalCode),HospCode'[CurHospitalCode Quit
  .//If CurHospitalCode="" Quit
  .Set ts="" For  Set ts=$Order(^TEPIi("AUTHORISED",Date,labno,ts)) Quit:ts=""  Do
  ..//If $Length(RoomCode),$Extract(ts)'=RoomCode Quit
  ..Set tscnt="" For  Set tscnt=$Order(^TEPIi("AUTHORISED",Date,labno,ts,tscnt)) Quit:tscnt=""  Do
  ...If $Length($Piece(^TEPI(labno,1,ts,tscnt),"\",52)) Quit  //标本异常处理
  ...Set TestCode="" For  Set TestCode=$Order(^TEPI(labno,1,ts,tscnt,"DATA",TestCode)) Quit:TestCode=""  Do
  ....If $Data(^TTAB("TC",TestCode)),$Piece(^TTAB("TC",TestCode),"\",3)'="V" Quit  //只查细菌类型
  ....//取细菌的值,如果非细菌，就退出
  ....Set BugCode=$Piece(^TEPI(labno,1,ts,tscnt,"DATA",TestCode),"\",1)
  ....If $Length(BugStr)&(BugStr'=BugCode) Quit
  ....//判断标本
  ....Set SampCode=$Piece(^TEPI(labno,1,ts,tscnt),"\",46)
  ....If SampCode="" Set SampCode="无标本"
  ....If $Length(CurSampCode)&(CurSampCode'=SampCode) Quit
  ....//科室判断
  ....Set LDeptCode=$Piece(^TEPI(labno),"\",36)
  ....If $Length(CurDepCode)&(LDeptCode'=CurDepCode) Quit
  ....If LDeptCode="" Set LDeptCode="无科室"
  ....If $Data(^TTAB("BUG",BugCode)) Do
  .....//---取菌属-2010-07-02---
  .....Set BugGroup=$Piece(^TTAB("BUG",BugCode),"\",7)
  .....If $Data(^TTABMicRelDri(BugCode)) Set BugGroup=$Order(^TTABMicRelDri(BugCode,""))
  .....If BugType=0 Do
  ......//判断阴阳性
  ......Set BugSyn=$Piece(^TTAB("BUG",BugCode),"\",8)
  ......If (BugFlag=1)&((BugSyn="xxx")||(BugSyn="XXX")||(BugSyn="")) Quit
  ......Set ^TMP($ZName,$Job,BugCode,labno_"||"_ts_"||"_tscnt,Num)=""
  ......Set Num=Num+1
  .....//科室统计
  .....If BugType=1 Do
  ......If BugFlag=0 Do
  .......Set ^TMP($ZName,$Job,LDeptCode,BugCode,labno_"||"_ts_"||"_tscnt)=""
  .......Set Num=Num+1
  ......Else  Do
  .......Set ^TMP($ZName,$Job,"DeptCode",LDeptCode)=""
  .......Set ^TMP($ZName,$Job,"BUG",BugCode,LDeptCode,labno_"||"_ts_"||"_tscnt)=""
  .......Set Num=Num+1
  .....//按标本统计.
  .....If BugType=2 Do
  ......If BugFlag=0 Do
  .......Set ^TMP($ZName,$Job,SampCode,BugCode,labno_"||"_ts_"||"_tscnt)=""
  .......Set Num=Num+1
  ......Else  Do 
  .......Set ^TMP($ZName,$Job,"SampCode",SampCode)=""
  .......Set ^TMP($ZName,$Job,"BUG",BugCode,SampCode,labno_"||"_ts_"||"_tscnt)=""
  .......Set Num=Num+1
  .....//按照菌属统计。
  .....If BugType=3 Do
  ......If BugGroup="" Set BugGroup="未定义"
  ......Set ^TMP($ZName,$Job,"BUGGROUP",BugGroup,labno_"||"_ts_"||"_tscnt)=""
  ......Set ^TMP($ZName,$Job,"BUG",BugGroup,BugCode,labno_"||"_ts_"||"_tscnt)=""
  ......Set Num=Num+1
  .....//按照科室标本统计
  .....If BugType=4 Do
  ......Set ^TMP($ZName,$Job,"DEPSAMP",LDeptCode,SampCode,BugCode,labno_"||"_ts_"||"_tscnt)=""
  ......Set Num=Num+1
  Quit
 
Output
    S Data=$lb(Num,labno,SampleNo,SurName,SpeciesName,Age,Debtor,HospNo,PatLoc,patWardname,Bed,SpeName,BugsName,BugsType,authDate)
 	S ^CacheTemp(repid,ind)=Data
 	S ind=ind+1
	Q
}

ClassMethod QuerySampleStatisticsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QuerySampleStatisticsExecute ]
{
 	S AtEnd=$LIST(qHandle,1)
 	S repid=$LIST(qHandle,2)
 	S ind=$LIST(qHandle,3)
 	S ind=$O(^CacheTemp(repid,ind))
 	I ind="" 
 	{				// if there are no more rows, finish fetching
 		S AtEnd=1
 		S Row=""
 	}
 	Else      
 	{	// fetch row
 		S Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	S qHandle=$lb(AtEnd,repid,ind)
	Q $$$OK
}

/// Creator：      Qiuxianfu
/// CreatDate：    20140331
/// Description:： 样本数统计
/// Table：        
/// Input：        DateS:起始日期,DateE:结束日期，DepCode：检验科科室代码,MachCode仪器代码为空全部检索，MachTG：仪器组代码为空全部检索，CliCode：医生申请科室代码为空全部检索，DocCode:医生工号为空全部检索，PatientType：病人类型为空默认检索全部类型(N:门诊,Y：住院,P：急诊,O：体检,GP：手工未上线病人")
/// Output：       Debtor:登记号,PatName：病人姓名,SpeName：性别,PatAge：年龄,CliDepName：申请科室,Labno：检验号,TestName：医嘱名称,ColectDateTime:采集时间,RecevieDateTime:接收时间,AuthorDateTime:审核时间
/// Return：       无
/// Others：
/// D ##class(%ResultSet).RunQuery("web.DHCMicStatBugIsolate","QuerySampleStatistics","2014-09-24","2014-10-24")
Query QuerySampleStatistics(DateS As %String, DateE As %String) As %Query(ROWSPEC = "Num:%String,labno:%String,SampleNo:%String,SurName:%String,SpeciesName:%String,Age:%String,Debtor:%String,HospNo:%String,PatLoc:%String,patWardname:%String,Bed:%String,SpeName:%String,BugsName:%String,BugsType:%String,authDate:%String") [ SqlProc ]
{
}

Storage Default
{
<Data name="DHCMicStatPositiveRateDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCMicStatPositiveRateD</DataLocation>
<DefaultData>DHCMicStatPositiveRateDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCMicStatPositiveRateD</IdLocation>
<IndexLocation>^web.DHCMicStatPositiveRateI</IndexLocation>
<StreamLocation>^web.DHCMicStatPositiveRateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
