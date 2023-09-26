Class dhc.qm.udata.uPatInfo Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// Creator:     wang ying
/// CreateDate:  2015-8-5
/// Description: 根据病人信息列表插入或更新到病人信息表和科室质量管理主表、子表
/// Table:       DHC_AN_Oparrange,麻醉表、手术表、DHCANCSiteProphyAntibiotics,ORC_BladeType(代码为"I","II","III","IV")
/// Input:       检查项目id
/// Return:      手术病人信息，json格式
/// Others:  w ##class(dhc.qm.udata.uPatInfo).InsertInfo("<Request><deptGroupDr>20</deptGroupDr><wardDr>43</wardDr><period>201501</period><planDr>1</planDr><qmschemDr>1</qmschemDr><admNo>10682847</admNo><patName>杨素斌</patName><inPatCode>2115321</inPatCode><Indoccode>04670</Indoccode><IndocName>吴文铭</IndocName><operatorcode>主刀医师code</operatorcode><operdocname>廖泉</operdocname><operatorID> 219430</operatorID><operator>胰十二指肠切除术</operator> <operatordate>2015-03-17</operatordate><status>0</status></Request>")
/// w ##class(dhc.qm.udata.uPatInfo).InsertInfo("<Request><operatorcode>898</operatorcode><admNo>10682847</admNo><operatorID>221263</operatorID><IndocName>吴文铭</IndocName><Indoccode>04670</Indoccode><planDr>3</planDr><status>0</status><inPatCode>2115321</inPatCode><period>201502</period><operator>开腹探查止血术</operator><operdocname>廖泉</operdocname><operatordate>2015-06-27</operatordate><wardDr>43</wardDr><qmschemDr>9</qmschemDr><patName>杨素斌</patName><deptGroupDr>20</deptGroupDr></Request>")
///  w ##class(dhc.qm.udata.uPatInfo).InsertInfo("<Request><wardDr>43</wardDr><planDr>3</planDr><period>201502</period><qmschemDr>7</qmschemDr><deptGroupDr>20</deptGroupDr></Request>")
///  w ##class(dhc.qm.udata.uPatInfo).InsertInfo("<Request><admNo>9489138</admNo><decedate>2015-03-20</decedate><IndocName></IndocName><Indoccode>5821</Indoccode><wardDr>33</wardDr><planDr>3</planDr><status>0</status><inPatCode>2100248</inPatCode><qmschemDr>6</qmschemDr><patName>林配敏</patName><deadNum>3</deadNum><period>201502</period><deptGroupDr>18</deptGroupDr></Request>")
/// w ##class(dhc.qm.udata.uPatInfo).InsertInfo("<Request><planDr>3</planDr><period>201502</period><qmschemDr>7</qmschemDr><deptGroupDr>20</deptGroupDr></Request>")
/// w ##class(dhc.qm.udata.uPatInfo).InsertInfo("<Request><admNo>10970214</admNo><OperationID>26627||1</OperationID><IndocName></IndocName><Indoccode>4801</Indoccode><planDr>3</planDr><status>0</status><inPatCode>2117892</inPatCode><Operationdate>2015-07-07</Operationdate><OperationName>骨髓穿刺</OperationName><period>201502</period><wardDr>33</wardDr><qmschemDr>3</qmschemDr><patName>谢松林</patName><deptGroupDr>18</deptGroupDr></Request>") 
/// w ##class(dhc.qm.udata.uPatInfo).InsertInfo("<Request><planDr>1</planDr><period>201503</period><qmschemDr>6</qmschemDr><deptGroupDr>20</deptGroupDr></Request>")
/// w ##class(dhc.qm.udata.uPatInfo).InsertInfo("<Request><admNo>2134939</admNo><applydate>2016-12-03</applydate><planDr>5</planDr><status>0</status><consultdepart>31</consultdepart><period>201601</period><qmschemDr>4</qmschemDr><consultdate>2016-12-03</consultdate><deptGroupDr>10</deptGroupDr></Request>")
ClassMethod InsertInfo(Param As %String) As %String
{
	;n (Param)
	;s ^ssasassda=Param
	i Param="" s Param="<Request><deptGroupDr>20</deptGroupDr><wardDr>43</wardDr><period>201501</period><planDr>1</planDr><qmschemDr>1</qmschemDr><admNo>10682847</admNo><patName>杨素斌</patName><inPatCode>2115321</inPatCode><Indoccode>04670</Indoccode><IndocName>吴文铭</IndocName><operatorcode>主刀医师code</operatorcode><operdocname>廖泉</operdocname><operatorID> 219430</operatorID><operator>胰十二指肠切除术</operator><operatordate>2015-01-17</operatordate><status>0</status></Request>"
    s Param=$TR(Param,$C(10))
    s Param=$TR(Param,$C(0))
    ;s ^syyyysyywww=Param
    s period="",planDr="",dept="",ward="",qmschemDr="",admNo="",patName="",inPatCode="",Indoccode="",IndocName="",operatorcode=""
	s operdocname="",operatorID="",operator="",operatordate="",status="",OperationID="",OperationName="",Operationdate=""
	s consultID="",consultdepart="",consultdoccode="",consultdoc="",operdocname="",applydate="",consultdate=""
	s decedate="",deadNum="",PicLink="",actValue="",txtValue=""
	s reader=##class(%XML.Reader).%New()
    s sc=reader.OpenString(Param)
    // s sc=reader.OpenStream(objStream)
    d reader.Correlate("Request","dhc.qm.data.Request")
    //Do reader.Rewind()
	While reader.Next(.request,.sc)
	{
	  s period=request.period
	  s planDr=request.planDr
	  s dept=request.deptGroupDr
	  s ward=request.wardDr
	  s qmschemDr=request.qmschemDr
	  s admNo=request.admNo
	  s patName=request.patName
	  s inPatCode=request.inPatCode
	  s Indoccode=request.Indoccode
	  s IndocName=request.IndocName
	  s operatorcode=request.operatorcode
	  s operdocname=request.operdocname
	  s operatorID=request.operatorID
	  s operator=request.operator
	  s operatordate=request.operatordate
	  s status=request.status
	  s OperationID=request.OperationID
	  s OperationName=request.OperationName
	  s Operationdate=request.Operationdate
	  s consultID=request.consultID
	  s consultdepart=request.consultdepart
	  w consultdepart,!
	  s consultdoccode=request.consultdoccode
	  s consultdoc=request.consultdoc
	  s operdocname=request.operdocname
	  s applydate=request.applydate
	  s consultdate=request.consultdate
	  s decedate=request.decedate
	  s deadNum=request.deadNum
	  s txtValue=request.txtValue
	  s actValue=request.actValue
	  s PicLink=request.PicLink
	  s patRowid=request.patRowid
	}
	 s resultString="",SQLCODE=0
	 ;q:admNo="" "NoadmNo"
	 q:period="" "Noperiod"
	 q:dept="" "Nodept"
	 ;q:ward="" "Noward"
	 q:planDr="" "NoplanDr"
	 q:qmschemDr="" "NoqmschemDr"
	 s qmschemCode=""
	
	 ;q:inPatCode="" "NoinPatCode"
	 ;s ^TMPDHCCJXQMWY(i)=i
	 s data=period_"^"_planDr_"^"_dept_"^"_ward_"^"_qmschemDr_"^"_admNo_"^"_patName_"^"_inPatCode_"^"_Indoccode_"^"_IndocName_"^"_operatorcode
	        _"^"_operdocname_"^"_operatorID_"^"_operator_"^"_operatordate_"^"_status_"^"_OperationID_"^"_OperationName_"^"_Operationdate
	        _"^"_consultID_"^"_consultdepart_"^"_consultdoccode_"^"_consultdoc_"^"_operdocname_"^"_applydate_"^"_consultdate
			_"^"_decedate_"^"_deadNum_"^"_txtValue_"^"_actValue_"^"_PicLink_"^"_patRowid
	 s SQLCODE=..Insert(data)
	
	 i SQLCODE = 0 d
	 .s resultString="{success:'true',info:''}"
	 e  d
	 .s resultString= "{success:'false',info:'"_SQLCODE_"'}"
	 
	 q resultString
}

/// Creator:     wang ying
/// CreateDate:  2015-8-5
/// Description: 根据检查项目获取病人信息,手术开始日期、结束日期
/// Table:       DHC_AN_Oparrange,麻醉表、手术表、DHCANCSiteProphyAntibiotics,ORC_BladeType(代码为"I","II","III","IV")
/// Input:       检查项目id
/// Return:      手术病人信息，json格式
/// Others:  w ##class(dhc.qm.udata.uPatInfo).GetOperPatList("<Request><startDate>2015-06-05</startDate><wardDr>43</wardDr><endDate>2015-06-30</endDate><deptGroupDr>20</deptGroupDr><qmschemDr>1</qmschemDr></Request>")
/// Others:  w ##class(dhc.qm.udata.uPatInfo).GetOperPatList("<Request><startDate>2015-06-05</startDate><wardDr>43</wardDr><endDate>2015-06-30</endDate><period>201502</period><deptGroupDr>20</deptGroupDr><qmschemDr>8</qmschemDr></Request>")
/// Others:  w ##class(dhc.qm.udata.uPatInfo).GetOperPatList("<Request><startDate>2015-06-05</startDate><wardDr>43</wardDr><endDate>2015-06-30</endDate><period>201502</period><deptGroupDr>20</deptGroupDr><qmschemDr>1</qmschemDr></Request>")
ClassMethod GetOperPatList(Param As %String) As %String
{
	;n (Param)
	i Param="" s Param="<Request><period>201502</period><qmschemDr>8</qmschemDr><startDate>2015-6-01</startDate><endDate>2015-06-30</endDate><deptGroupDr>20</deptGroupDr><wardDr>43</wardDr></Request>"
    s Param=$TR(Param,$C(10))
    s Param=$TR(Param,$C(0))
    s planDr=""
	s reader=##class(%XML.Reader).%New()
    s sc=reader.OpenString(Param)
    // s sc=reader.OpenStream(objStream)
    d reader.Correlate("Request","dhc.qm.data.Request")
    //Do reader.Rewind()
	While reader.Next(.request,.sc)
	{
	  s stdate=request.startDate
	  s enddate=request.endDate
	  s dept=request.deptGroupDr
	  s ward=request.wardDr
	  s qmschemDr = request.qmschemDr
	  s period = request.period
	}
	 s resultString=""
	 q:stdate="" "Nostdate"
	 q:enddate="" "Noenddate"
	 q:dept="" "Nodept"
	 q:ward="" "Noward"
	 
	 s resultString=..OperPatList(stdate,enddate,dept,ward,qmschemDr,period)
	 q resultString
}

/// Creator:     wang ying
/// CreateDate:  2015-7-30
/// Description: 根据检查项目获取病人信息,手术开始日期、结束日期
/// Table:       DHC_AN_Oparrange,麻醉表、手术表、DHCANCSiteProphyAntibiotics,ORC_BladeType(代码为"I","II","III","IV")
/// Input:       检查项目id
/// Return:      手术病人信息，json格式
/// Others:  w ##class(dhc.qm.udata.uPatInfo).OperPatList("2015-06-01","2015-08-31",20,43,1,"201503")
ClassMethod OperPatList(stdate As %String, enddate As %String, dept As %String, ward As %String, qmschemDr As %String, period As %String) As %String
{
	 ;n (stdate,enddate,dept,ward)
	 s count=0
	 s resultString=""
	 q:stdate="" "Nostdate"
	 q:enddate="" "Noenddate"
	 q:dept="" "Nodept"
	 q:ward="" "Noward"
	 q:qmschemDr="" "NoqmschemDr"
	 q:period="" "Noperiod"
	 ;s stdate=$zdh(stdate,3)
	 ;s enddate=$zdh(enddate,3)
	 
	 s json=##class(dhc.pa.comm.JsonObj).%New()
	 s jsonTitle="patRowid^admNo^patName^inPatCode^Indoccode^IndocName^operatorcode^operdocname^operatorID^operator^operatordate"
	 s RoomDR=""
	 f  s RoomDR=$O(^PAADMi("CurrWard",ward,RoomDR)) q:RoomDR=""  d
	 .s adm=""
	 .f  s adm=$O(^PAADMi("CurrWard",ward,RoomDR,adm)) q:adm=""  d
	 ..s ret=##class(web.DHCANAdaptor).GetANOperation(stdate,enddate,adm,"","F","","") 
	 ..Set reader = ##class(%XML.Reader).%New()
	 ..Do reader.OpenStream(ret)
	 ..Do reader.Correlate("PatInfo","web.DHCANInterface")
	   
	 ..While (reader.Next(.object,.sc)) {
      
       
        ..;b 
		..s patDept=object.OPAPatDeptDr
		
		..&sql(SELECT DEP_RowId into :deptDr FROM SQLUser.CT_Loc,SQLUser.RBC_DepartmentGroup 
          WHERE CTLOC_Dep_DR=DEP_RowId AND CTLOC_RowID=:patDept)
		
	    ..&sql(SELECT PAADM_CurrentRoom_DR,PAADM_AdmDocCodeDR->CTPCP_Code,PAADM_AdmDocCodeDR-> CTPCP_Desc into:wardDr,:Indoccode,:IndocName FROM SQLUser.PA_Adm WHERE PAADM_RowID=:adm)
	    ..q:dept'=deptDr
	    ..s date=$zdh(object.OpDate,3)
	    ..i (date>=$zdh(stdate,3))&&(date<=$zdh(enddate,3)) d
	    ...s patRowid=0,mainID=0,detailRowid=0,flag=0
	    ...i (Indoccode'="")&&(object.EpisodeID'="")&&(object.OpaId'="")&&(object.ANAOPSurgeonDR'="") d
	    ....s patRowid=$o(^DHCCJXQMJXPatI("JXPatoperator",object.EpisodeID,Indoccode,object.ANAOPSurgeonDR,object.OpaId,patRowid))
	    ...i (Indoccode="")&&(object.EpisodeID'="")&&(object.OpaId'="")&&(object.ANAOPSurgeonDR'="") d
	    ....s patRowid=$o(^DHCCJXQMJXPatI("JXPatoperator",object.EpisodeID,1,object.ANAOPSurgeonDR,object.OpaId,patRowid))
	    ...;i ((patRowid=0)||(patRowid="")) d
		....;s tmp="^"_object.EpisodeID_"^"_object.PatName_"^"_object.MedCareNo_"^"_Indoccode_"^"_IndocName_"^"_object.ANAOPSurgeonDR_"^"_object.ANAOPSurgeon_"^"_object.OpaId_"^"_object.OpName_"^"_object.OpDate
		....;d json.InsertRowData(tmp)
		....;s count=count+1
		...;e  d
		...;w patRowid,!
		...s flag=..repPatList(dept,ward,qmschemDr,period,patRowid)
		...i flag=0 d
		....s tmp="^"_object.EpisodeID_"^"_object.PatName_"^"_object.MedCareNo_"^"_Indoccode_"^"_IndocName_"^"_object.ANAOPSurgeonDR_"^"_object.ANAOPSurgeon_"^"_object.OpaId_"^"_object.OpName_"^"_object.OpDate
		....s ^TEMPDHCCJXQMOperPatList($j,object.OpDate,object.OpaId)=tmp
		....;d json.InsertRowData(tmp)
		....;s count=count+1
		
		
	 ..}
	
	 s PatName=""
	 f  s PatName=$o(^TEMPDHCCJXQMOperPatList($j,PatName))  q:PatName=""  d
	 .s OpaId=""
	 .f  s OpaId=$o(^TEMPDHCCJXQMOperPatList($j,PatName,OpaId)) q:OpaId=""  d
	 ..s patInfo=$g(^TEMPDHCCJXQMOperPatList($j,PatName,OpaId))
	 ..i patInfo'=""  d
	 ..d json.InsertRowData(patInfo)
	 ..s count=count+1
	
	 s resultString = json.getJsonData(jsonTitle,count)
	 // If error found during processing, show it
	 If $system.Status.IsError(sc) do $system.OBJ.DisplayError(sc)
	 k json,^TEMPDHCCJXQMOperPatList($j)
	 q resultString
}

/// Creator:     wang ying
/// CreateDate:  2015-8-5
/// Description: 根据病人信息列表插入或更新到病人信息表和科室质量管理主表、子表
/// Table:       DHC_AN_Oparrange,麻醉表、手术表、DHCANCSiteProphyAntibiotics,ORC_BladeType(代码为"I","II","III","IV")
/// Input:       检查项目id
/// Return:      手术病人信息，json格式
/// Others:  w ##class(dhc.qm.udata.uPatInfo).Insert("<Request><admNo>10219958</admNo><decedate>2015-07-01</decedate><IndocName></IndocName><Indoccode>1</Indoccode><wardDr>33</wardDr><planDr>1</planDr><status>0</status><inPatCode>2030246</inPatCode><qmschemDr>6</qmschemDr><patName>彭天舒</patName><deadNum>6</deadNum><period>201503</period><deptGroupDr>18</deptGroupDr></Request>")
ClassMethod Insert(data As %String) As %String
{
	;n (Param)
	  q:data="" "Nodata"
	  
	  s SQLCODE=0
	  k PLIST
	  s period=$p(data,"^",1)
	  s planDr=$p(data,"^",2)
	  s dept=$p(data,"^",3)
	  s ward=$p(data,"^",4)
	  s qmschemDr=$p(data,"^",5)
	  s admNo=$p(data,"^",6)
	  s patName=$p(data,"^",7)
	  s inPatCode=$p(data,"^",8)
	  s Indoccode=$p(data,"^",9)
	  s IndocName=$p(data,"^",10)
	  s operatorcode=$p(data,"^",11)
	  s operdocname=$p(data,"^",12)
	  s operatorID=$p(data,"^",13)
	  s operator=$p(data,"^",14)
	  s operatordate=$p(data,"^",15)
	  i operatordate'="" s operatordate=$zdh(operatordate,3)
	  s operatordateT = ""
	  s status=$p(data,"^",16)
	  s OperationID=$p(data,"^",17)
	  s OperationName=$p(data,"^",18)
	  s Operationdate=$p(data,"^",19)
	  i Operationdate'=""  s Operationdate=$zdh(Operationdate,3)
	  s consultID=$p(data,"^",20)
	  s consultdepart=$p(data,"^",21)
	  s consultdoccode=$p(data,"^",22)
	  s consultdoc=$p(data,"^",23)
	  s operdocname=$p(data,"^",24)
	  s applydate=$p(data,"^",25)
	  s consultdate=$p(data,"^",26)
	  s decedate=$p(data,"^",27)
	  i decedate'=""  s decedate=$zdh($p(data,"^",27),3)
	  s deadNum=$p(data,"^",28)
	  s txtValue=$p(data,"^",29)
	  s actValue=$p(data,"^",30)
	  s PicLink=$p(data,"^",31)
	  s patRowid=$p(data,"^",32)
	  i admNo'=""  s PLIST(2)=admNo
	  i patName'=""  s PLIST(4)=patName
	  i inPatCode'="" s PLIST(3)=inPatCode
	  i Indoccode'="" s PLIST(5)=Indoccode
	  i IndocName'="" s PLIST(6)=IndocName
	  i operatorcode'="" s PLIST(9)=operatorcode
	  i operdocname'=""  s PLIST(10)=operdocname
	  i operatorID'=""   s PLIST(20)=operatorID
	  i operator'="" s PLIST(7)=operator
	  i operatordate'="" s PLIST(8)=operatordate
	  ;s status=$p(data,"^",16)
	  i OperationID'="" s PLIST(22)=OperationID
	  i OperationName'="" s PLIST(16)=OperationName
	  i Operationdate'="" s PLIST(17)=Operationdate
	  i consultID'="" s PLIST(21)=consultID
	  i consultdepart'="" s PLIST(12)=consultdepart
	  i consultdoccode'="" s PLIST(13)=consultdoccode
	  i consultdoc'="" s PLIST(14)=consultdoc
	  i applydate'="" s PLIST(11)=applydate
	  i consultdate'="" s PLIST(18)=consultdate
	  i decedate'=""  s PLIST(15)=decedate
	  s rowid=0
	  ;w decedate,!
	  ;s ^sssdata = admNo_","_Indoccode_","_operatorcode_","_operatorID_","_rowid
	  i (Indoccode'="")&&(admNo'="")&&(operatorID'="")&&(operatorcode'="") d
	  .s rowid=$o(^DHCCJXQMJXPatI("JXPatoperator",admNo,Indoccode,operatorcode,operatorID,rowid))
	  i (Indoccode'="")&&(admNo'="")&&(OperationID'="") d
	  .s rowid=$o(^DHCCJXQMJXPatI("JXPatOperation",admNo,Indoccode," "_OperationID,rowid))
	  i (admNo'="")&&(decedate'="") d
	  .s rowid=$o(^DHCCJXQMJXPatI("JXPatdecedate",admNo,decedate,rowid))
	  i (admNo'="")&&(consultID'="") d
	  .s rowid=$o(^DHCCJXQMJXPatI("JXPatconsult",admNo," "_consultID,rowid))
	  ;b
	  i (rowid'="") d
	  .&sql(UPDATE dhc_qm_data.JXPat VALUES PLIST() where %ID=:rowid)
	  e  d	  
	  .&sql(INSERT INTO dhc_qm_data.JXPat VALUES PLIST())
	  .s rowid=%ROWID
	  s mainData=period_"^"_planDr_"^"_dept_"^"_ward_"^"_qmschemDr_"^"_status_"^"_txtValue_"^"_actValue_"^"_PicLink
	  
	  s SQLCODE=..InsertLocUnitResult(mainData,rowid)
	  
	  ;w SQLCODE,!
	  i SQLCODE'=0 d
	  .d ##class(dhc.pa.udata.uPALogger).Insert("MInsertLocUnitResult",mainData_"^"_rowid,SQLCODE,"")
	 
	  q SQLCODE
}

/// Creator:     wang ying
/// CreateDate:  2015-8-5
/// Description: 根据科室id、病房id、检查项目id，计划id到科室质量管理主表、子表
/// Table:       DHC_AN_Oparrange,麻醉表、手术表、DHCANCSiteProphyAntibiotics,ORC_BladeType(代码为"I","II","III","IV")
/// Input:       检查项目id
/// Return:      手术病人信息，json格式
/// Others:  w ##class(dhc.qm.udata.uPatInfo).GetOperPatList("<Request><qmschemDr>1</qmschemDr><startDate>2015-6-01</startDate><endDate>2015-06-30</endDate><deptGroupDr>20</deptGroupDr><wardDr>43</wardDr></Request>")
ClassMethod InsertLocUnitResult(data, rowid) As %String
{
	;n (Param)
	  q:data="" "Nodata"
	  
	  s SQLCODE=0,mainID=""
	  k PLIST
	  s period=$p(data,"^",1)
	  s planDr=$p(data,"^",2)
	  s dept=$p(data,"^",3)
	  s ward=$p(data,"^",4)
	  s qmschemDr=$p(data,"^",5)
	  s status=$p(data,"^",6)
	  s txtValue=$p(data,"^",7)
	  s actValue=$p(data,"^",8)
	  s PicLink=$p(data,"^",9)
	  s qmschemCode=""
	  i period'=""  s PLIST(5)=period
	  i planDr'=""  s PLIST(2)=planDr
	  i dept'="" s PLIST(4)=dept
	  i ward'="" s PLIST(6)=ward
	  i qmschemDr'="" s PLIST(3)=qmschemDr
	  s detailData=txtValue_"^"_actValue_"^"_PicLink
	  s mainID=0
	  i ward="" d
	  .i (period'="")&&(dept'="")&&(qmschemDr'="") d
	  ..s mainID=$o(^DHCCJXQMLocResultMainI("periodQMSchemDrDepartDr",period,qmschemDr,dept,mainID))
	  e  d
	  .i (period'="")&&(dept'="")&&(qmschemDr'="") d
	  ..s mainID=$o(^DHCCJXQMLocResultMainI("periodQMSchemDrDepartDrWard",period,qmschemDr,dept,ward,mainID))
	 
	  i (mainID'="")&&(mainID'=0) d
	  .&sql(UPDATE dhc_qm_data.LocResultMain VALUES PLIST() where %ID=:mainID)
	  e  d	  
	  .&sql(INSERT INTO dhc_qm_data.LocResultMain VALUES PLIST())
	  .s mainID=%ROWID
	  ;b
	  ;w mainID_"^"_rowid,!
	  i SQLCODE'=0 d
	  .d ##class(dhc.pa.udata.uPALogger).Insert("InsertLocUnitResult",period_"^"_planDr_"^"_dept_"^"_ward_"^"_qmschemDr,SQLCODE,"")
	  s SQLCODE=..InsertLocUnitResultDetail(status,qmschemDr,planDr,mainID,rowid,detailData)
	  i SQLCODE'=0 d
	  .d ##class(dhc.pa.udata.uPALogger).Insert("MInsertLocUnitResultDetail",period_"^"_planDr_"^"_dept_"^"_ward_"^"_qmschemDr,SQLCODE,"")
	  q SQLCODE
}

/// Creator:     wang ying
/// CreateDate:  2015-8-5
/// Description: 根据科室id、病房id、检查项目id，计划id到科室质量管理子表
/// Table:       
/// Input:       检查项目id
/// Return:      手术病人信息，json格式
/// Others:  w ##class(dhc.qm.udata.uPatInfo).InsertLocUnitResultDetail("0","6","1","49","19","")
ClassMethod InsertLocUnitResultDetail(status, qmschemDr, planDr, mainID, rowid, detailData) As %String
{
 
	  ;n (Param)
	  ;s ^huigygbvfgh = status_"^"_qmschemDr_"^"_planDr_"^"_mainID_"rowid^"_rowid_"^>"_detailData
	  q:qmschemDr="" "NoqmschemDr"
	  ;q:planDr="" "NoplanDr"
	  q:mainID="" "NomainID"
	  s SQLCODE=0,qmschemCode=""
	  k PLIST
	  s PicLink="",actValue="",txtValue=""
	  i qmschemDr'="" s qmschemCode=$LIST(^DHCCJXQMQMSchemD(qmschemDr),2)
	  s txtValue=$p(detailData,"^",1)
	  s actValue=$p(detailData,"^",2)
	  s PicLink=$p(detailData,"^",3)
	  i mainID'=""  s PLIST(2)=mainID
	 
	  i status'="" s PLIST(14)=status
	  i txtValue'=""  s PLIST(8)=txtValue
	  i actValue'=""  s PLIST(7)=actValue
	  i PicLink'="" s PLIST(9)=PicLink

	  i qmschemDr'="" d
	  .s checkDr=0
	  .f  s checkDr=$o(^DHCCJXQMQMSchemDetailI("QMSchemDrCheckDr",qmschemDr,checkDr)) q:checkDr=""  d
	  ..s schemDetail=0
	  ..f  s schemDetail=$o(^DHCCJXQMQMSchemDetailI("QMSchemDrCheckDr",qmschemDr,checkDr,schemDetail)) q:schemDetail=""  d
	  ...s PLIST(3)=schemDetail
	  ...s PLIST(5)=checkDr
	  ...s checkCode=""
	  ...s flag=0
	  ...i ((rowid'="")&&(rowid'=0)) s flag=1
	  ...i checkDr'="" s checkCode=$List($g(^DHCCJXQMCheckD(checkDr)),7)
	  ...i ((checkCode="016")||(checkCode="017"))  s flag=0
	  ...s detailRowid=0
	  ...i (((rowid'="")&&(rowid'=0))&&(flag'=0)) d
	  ....s detailRowid=$o(^DHCCJXQMLocResultdetailI("QMLRMPatCheckDr",mainID,rowid,checkDr,detailRowid))
	  ...e  d
	  ....s detailRowid=$o(^DHCCJXQMLocResultdetailI("QMLRMCheckDr",mainID,checkDr,detailRowid))
	  ...i ((rowid'="")&&(rowid'="0")) d
	  ....s PLIST(4)=rowid
	  ...i flag=0  s PLIST(4)=0
	  ...;b
	  ...i detailRowid'="" d
	  ....&sql(UPDATE dhc_qm_data.LocResultdetail VALUES PLIST() where %ID=:detailRowid)
	  ...e  d
	  ....&sql(INSERT INTO dhc_qm_data.LocResultdetail VALUES PLIST())

	  ...i SQLCODE'=0 d

	  ....d ##class(dhc.pa.udata.uPALogger).Insert("InsertLocUnitResultDetail",mainID_"^"_patID_"^"_checkDr_"^"_detailRowid,SQLCODE,"")
	  q SQLCODE
}

/// Creator:     wang ying
/// CreateDate:  2015-8-5
/// Description: 根据调查信息更新科室质量管理子表信息
/// Table:       DHC_AN_Oparrange,麻醉表、手术表、DHCANCSiteProphyAntibiotics,ORC_BladeType(代码为"I","II","III","IV")
/// Input:       检查项目id
/// Return:      手术病人信息，json格式
/// Others:  w ##class(dhc.qm.udata.uPatInfo).InserChecktInfo("<Request><deptGroupDr>20</deptGroupDr><wardDr>43</wardDr><period>201501</period><planDr>1</planDr><qmschemDr>1</qmschemDr><patRowid>1</patRowid><checkDr>1</checkDr><txtValue>备注信息</txtValue><actValue>Y</actValue><PicLink>http://192.168.10.11/dhcc/image</PicLink><status>1</status></Request>")
/// /        w ##class(dhc.qm.udata.uPatInfo).InserChecktInfo("<Request><actValue>否</actValue><patRowid>17</patRowid><wardDr>45</wardDr><planDr>1</planDr><status>1</status><checkDr>4</checkDr><qmschemDr>2</qmschemDr><PicLink>http://10.160.16.30:8081/VideoShare/files2015/11/27/09/00379b18-28cb-450e-94b5-d15825299122.jpg@http://10.160.16.30:8081/VideoShare/files2015/11/27/09/e86e89e8-8323-4df2-8486-0fe1019f38e5.jpg@http://10.160.16.30:8081/VideoShare/files2015/11/27/09/4c59d48e-5b08-440b-9acc-84eaa5b1dedd.jpg@http://10.160.16.30:8081/VideoShare/files2015/11/27/09/ae63213e-9fcc-472c-bbb1-ee411cef282b.jpg@http://10.160.16.30:8081/VideoShare/files2015/11/27/13/527e0d8b-3ffd-4b46-b94a-ad87a868a1b0.jpg@http://10.160.16.30:8081/VideoShare/files2015/11/27/13/1f982f80-e6da-41e1-ae7e-0a32622d9ae5.jpg</PicLink><period>201503</period><deptGroupDr>20</deptGroupDr><txtValue></txtValue></Request>")
/// w ##class(dhc.qm.udata.uPatInfo).InserChecktInfo("<Request><actValue>是</actValue><patRowid>17</patRowid><wardDr>45</wardDr><planDr>1</planDr><status>1</status><checkDr>1</checkDr><qmschemDr>2</qmschemDr><PicLink>http://10.160.16.30:8081/VideoShare/files2015/11/27/13/27e74898-a454-4a55-a166-99ae63e8e3e3.jpg</PicLink><period>201503</period><deptGroupDr>20</deptGroupDr><txtValue></txtValue></Request>")
ClassMethod InserChecktInfo(Param As %String) As %String
{
	;n (Param)
	i Param="" s Param="<Request><deptGroupDr>20</deptGroupDr><wardDr>43</wardDr><period>201501</period><planDr>1</planDr><qmschemDr>1</qmschemDr><patRowid>1</patRowid><checkDr>1</checkDr><txtValue>备注信息</txtValue><actValue>Y</actValue><PicLink>http://192.168.10.11/dhcc/image</PicLink><status>1</status></Request>"
    s Param=$TR(Param,$C(10))
    s Param=$TR(Param,$C(0))
    s period="",planDr="",dept="",ward="",qmschemDr="",admNo="",patName="",inPatCode="",Indoccode="",IndocName="",operatorcode=""
	s operdocname="",operatorID="",operator="",operatordate="",status="",OperationID="",OperationName="",Operationdate=""
	s consultID="",consultdepart="",consultdoccode="",consultdoc="",operdocname="",applydate="",consultdate=""
	s decedate="",deadNum="",PicLink="",actValue="",txtValue=""
	s reader=##class(%XML.Reader).%New()
    s sc=reader.OpenString(Param)
    // s sc=reader.OpenStream(objStream)
    d reader.Correlate("Request","dhc.qm.data.Request")
    //Do reader.Rewind()
	While reader.Next(.request,.sc)
	{
	  s period=request.period
	  s planDr=request.planDr
	  s dept=request.deptGroupDr
	  s ward=request.wardDr
	  s qmschemDr=request.qmschemDr
	  s txtValue=request.txtValue
	  s actValue=request.actValue
	  s PicLink=request.PicLink
	  s patRowid=request.patRowid
	  s checkDr=request.checkDr
	  s status=request.status
	}
	 ;w "period="_period_"^"_PicLink_"^"_checkDr,!
	 s resultString="",SQLCODE=0
	 q:period="" "Noperiod"
	 q:dept="" "Nodept"
	 ;q:ward="" "Noward"
	 q:planDr="" "NoplanDr"
	 q:qmschemDr="" "NoqmschemDr"

	 s data=period_"^"_planDr_"^"_dept_"^"_ward_"^"_qmschemDr_"^"_patRowid_"^"_checkDr_"^"_txtValue_"^"_actValue_"^"_PicLink_"^"_status
	 ;w "data-->"_data,!
	 s SQLCODE=..updateLocUnitResultDetail(data)
	 s qmSchemCoe="",patNum=0
	 i qmschemDr'="" d
	 .s qmSchemCoe=$LIST(^DHCCJXQMQMSchemD(qmschemDr),2)
	 i qmSchemCoe="0060302" d
	 .s checkInfoDr=0
	 .s checkInfoDr=$o(^DHCCJXQMCheckI("CheckCode","017",checkInfoDr))
	 .&sql(SELECT count(LocResultdetail_JXPatDr) into:patNum FROM dhc_qm_data.LocResultdetail WHERE LocResultdetail_checkDr->Check_code='018'
		    AND LocResultdetail_parRef->LocResultMain_schemDr='006' AND LocResultdetail_actValue='Y'
			 AND LocResultdetail_parRef->LocResultMain_departDr=:dept AND LocResultdetail_parRef->LocResultMain_wardDr=:ward
			 AND LocResultdetail_parRef->LocResultMain_Plandr=:planDr 
			 group by LocResultdetail_parRef->LocResultMain_Plandr,LocResultdetail_parRef,LocResultdetail_parRef->LocResultMain_departDr,LocResultdetail_parRef->LocResultMain_wardDr)
	 .s data=period_"^"_planDr_"^"_dept_"^"_ward_"^"_qmschemDr_"^"_patRowid_"^"_checkInfoDr_"^"_txtValue_"^"_patNum_"^"_PicLink_"^"_status
	 .s SQLCODE=..updateLocUnitResultDetail(data)
	 ;w SQLCODE,!
	 i SQLCODE = 0 d
	 .s resultString="{success:'true',info:''}"
	 e  d
	 .s resultString= "{success:'false',info:'"_SQLCODE_"'}"
	 
	 q resultString
}

/// Creator:     wang ying
/// CreateDate:  2015-8-5
/// Description: 根据科室id、病房id、检查项目id，计划id到科室质量管理子表
/// Table:       
/// Input:       检查项目id
/// Return:      手术病人信息，json格式
/// Others:  w ##class(dhc.qm.udata.uPatInfo).GetOperPatList("<Request><qmschemDr>1</qmschemDr><startDate>2015-6-01</startDate><endDate>2015-06-30</endDate><deptGroupDr>20</deptGroupDr><wardDr>43</wardDr></Request>")
ClassMethod updateLocUnitResultDetail(data) As %String
{
	  ;n (Param)
	  s PicLink="",actValue="",txtValue=""
	  s period=$p(data,"^",1)
	  s planDr=$p(data,"^",2)
	  s dept=$p(data,"^",3)
	  s ward=$p(data,"^",4)
	  s qmschemDr=$p(data,"^",5)
	  s patRowid=$p(data,"^",6)
	  s checkDr=$p(data,"^",7)
	  s txtValue=$p(data,"^",8)
	  s actValue=$p(data,"^",9)
	  i actValue ="是"  s actValue ="Y"
	  i actValue ="否"  s actValue ="N"
	  s PicLink=$p(data,"^",10)
	  s status=$p(data,"^",11)
	  ;w patRowid_"^"_actValue_"^"_PicLink,!
	  
	  q:qmschemDr="" "NoqmschemDr"
	  q:dept="" "Nodept"
	  q:ward="" "Noward"
	  q:period="" "Noperiod"
	  ;q:checkDr="" "NocheckDr"
	  
	  s SQLCODE=0
	  k PLIST
	  
	  
	  
	  ;s txtValue=$p(detailData,"^",1)
	  ;s actValue=$p(detailData,"^",2)
	  ;s PicLink=$p(detailData,"^",3)
	  
	  ;i mainID'=""  s PLIST(2)=mainID
	  i patRowid'=""  s PLIST(4)=patRowid
	  i status'="" s PLIST(14)=status
	  i txtValue'=""  s PLIST(8)=txtValue
	  i actValue'=""  s PLIST(7)=actValue
	  i PicLink'="" s PLIST(9)=PicLink
	  ;w PicLink,!
	  &sql(SELECT Plan_CheckUser into:saveUser FROM  dhc_qm_data.Plan WHERE Plan_rowid=:planDr)
	  i saveUser'="" s Plist(10) =saveUser
	  
	  s Plist(11) =$p($h,",",1)
	  s mainID=0
	  i (ward="") d
	  .i (period'="")&&(planDr'="")&&(dept'="")&&(qmschemDr'="") d
	  ..s mainID=$o(^DHCCJXQMLocResultMainI("periodQMSchemDrDepartDr",period,qmschemDr,dept,mainID))
	  e  d
	  .i (period'="")&&(planDr'="")&&(dept'="")&&(qmschemDr'="") d
	  ..s mainID=$o(^DHCCJXQMLocResultMainI("periodQMSchemDrDepartDrWard",period,qmschemDr,dept,ward,mainID))
	  ..;w mainID,!
	  i mainID'=""  s PLIST(2)=mainID
	   ;s mainID=0
	   ;s mainID=$o(^DHCCJXQMLocResultMainI("periodQMSchemDrDepartDr",period,qmschemDr,dept,mainID))
	  s schemDetail=0
	  i (((patRowid'="")&&(patRowid'=0))) d
	  .s schemDetail=$o(^DHCCJXQMLocResultdetailI("QMLRMPatCheckDr",mainID,patRowid,checkDr,schemDetail))
	  e  d
	  .s schemDetail=$o(^DHCCJXQMLocResultdetailI("QMLRMCheckDr",mainID,checkDr,schemDetail))
	  .;w schemDetail,!
	  &sql(UPDATE dhc_qm_data.LocResultdetail VALUES PLIST() where %ID=:schemDetail)
	  i SQLCODE'=0 d
	  .d ##class(dhc.pa.udata.uPALogger).Insert("InsertLocUnitResultDetail",mainID_"^"_patRowid_"^"_checkDr_"^"_schemDetail,SQLCODE,"")
	
	  q SQLCODE
}

/// Creator:     ban
/// CreateDate:  2015-08-12
/// Description: 死亡病例信息
/// Table:       SS_User
/// Input:       qmschemDr 检查项，wardDr 病区 ，startDate开始日期，endDate 结束日期，deptGroupDr 科室
/// /             <Request><startDate>2015-03-01</startDate><endDate>2015-03-31</endDate><wardDr>33</wardDr><deptGroupDr>18</deptGroupDr><qmschemDr>6</qmschemDr></Request>
/// Return:      计划信息，json格式
/// Others:  w ##class(dhc.qm.udata.uPatInfo).GetDifficult("<Request><startDate>2015-03-01</startDate><endDate>2015-03-31</endDate><wardDr>33</wardDr><deptGroupDr>18</deptGroupDr><qmschemDr>6</qmschemDr></Request>")
/// Others:  w ##class(dhc.qm.udata.uPatInfo).GetDifficult("<Request><planDr>6</planDr><startDate>2015-03-01</startDate><endDate>2015-05-31</endDate><wardDr>1</wardDr><qmschemDr>6</qmschemDr><period>201502</period><deptGroupDr>27</deptGroupDr></Request>")
/// Others:  w ##class(dhc.qm.udata.uPatInfo).GetDifficult("<Request><planDr>6</planDr><startDate>2015-03-01</startDate><endDate>2015-05-31</endDate><wardDr>43</wardDr><qmschemDr>6</qmschemDr><period>201502</period><deptGroupDr>20</deptGroupDr></Request>")
ClassMethod GetDifficult(Param As %String) As %String
{
	;n (Param)
	i Param="" s Param="<Request><startDate>2015-03-01</startDate><endDate>2015-03-31</endDate><wardDr>33</wardDr><deptGroupDr>18</deptGroupDr><qmschemDr>6</qmschemDr></Request>"
    s Param=$TR(Param,$C(10))
    s Param=$TR(Param,$C(0))
	 
	s reader=##class(%XML.Reader).%New()
    s sc=reader.OpenString(Param)
    d reader.Correlate("Request","dhc.qm.data.Request")
	While reader.Next(.request,.sc)
	{
	   s startDate=request.startDate
	   s endDate=request.endDate
	   s wardDr=request.wardDr
	   s deptGroupDr=request.deptGroupDr
	   s qmschemDr=request.qmschemDr
	   s period = request.period
	   s planDr=request.planDr
	   
	}
	 s resultString=""
	 q:wardDr="" "NowardDr"
	 q:deptGroupDr="" "NodeptGroupDr"
	 q:qmschemDr="" "NoqmschemDr"
	 q:planDr="" "NoplanDr"
	 ;s ^hhiujh ="sjjjjjjj"
	 ;w qmschemDr_"^"_startDate_"^"_endDate_"^"_deptGroupDr_"^->"_wardDr,!
	 s resultString=##class(dhc.qm.udata.uPatInfo).GetDifficult1(qmschemDr,startDate,endDate,deptGroupDr,wardDr,period,planDr)
	 q resultString
}

/// Creator:     ban
/// CreateDate:  2015-08-12
/// Description: 根据登陆的信息获取登陆人的id
/// Table:       SS_User
/// Input:       qmschemDr 检查项，wardDr 病区 ，startDate开始日期，endDate 结束日期，deptGroupDr 科室
/// /             <Request><startDate>2015-03-20</startDate><endDate>2015-03-31</endDate><wardDr>43</wardDr><deptGroupDr>20</deptGroupDr><qmschemDr>6</qmschemDr></Request>
/// Return:      计划信息，json格式
/// others:w ##class(dhc.qm.udata.uPatInfo).GetDifficultList("6","2015-03-01","2015-03-31","20","43")
/// others:w ##class(dhc.qm.udata.uPatInfo).GetDifficultList("6","2015-06-01","2015-08-31","18","33","201503","1")
ClassMethod GetDifficultList(qmschemDr, startDate, endDate, deptGroupDr, wardDr, period, planDr)
{
	
	w "1="_$h,!
	s resultString="",deadCouNum=0,deadNum=0
	;s deadCouNum=..GetDifficultNum(qmschemDr, deptGroupDr, wardDr, planDr)
	s json=##class(dhc.pa.comm.JsonObj).%New()
	s jsonTitle="patRowid^admNo^patName^inPatCode^Indoccode^IndocName^decedate^deadNum"
	s deadNum=0
	s startDate=$zdh(startDate,3),endDate=$zdh(endDate,3)
	f DisDate=startDate:1:endDate  d
	.s Adm="",Indoc=""
	.f  s Adm=$O(^PAADMi("DischDate",DisDate,Adm)) q:Adm=""  d  //Adm
	..s WardDr=$P(^PAADM(Adm),"^",70) 
	..q:(WardDr'=wardDr)&&(wardDr'="")
	..s Indoc=$P(^PAADM(Adm),"^",9)  //管床医生Indoccode
	..s patRowid=$P(^PAADM(Adm),"^",1)   //patRowid
	..s IndocName="",Indoccode=""
	..i Indoc'="" d
	...;s IndocName=$p(^SSU("SSUSR",Indoccode),"^",2)
	...s Indoccode=$p(^CTPCP(Indoc,1),"^",1)  //管床code
	...s IndocName=$p(^CTPCP(Indoc,1),"^",2)  //管床医生IndocName
	..S Deceased=$P(^PAPER(patRowid,"ALL"),"^",12)
	..;w "Deceased="_Deceased,!
	..q:Deceased'="Y"
	..;b ;Deceased
	..s decedate=$P(^PAPER(patRowid,"ALL"),"^",13)   //死亡日期decedate
	..;w decedate,!
	..i ((decedate>=startDate)&&(decedate<=endDate)) d
	...s inPatCode=$P(^PAPER(patRowid,"PAT",1),"^",22)    //病案号inPatCode
	...s PatName=$P(^PAPER(patRowid,"ALL"),"^",1)   //patName
	...s deadNum=deadNum+1     //deadNum
	...s ret="^"_Adm_"^"_PatName_"^"_inPatCode_"^"_Indoccode_"^"_IndocName_"^"_$zd(decedate,3)_"^"_deadNum
	...i (Adm'="")&&(decedate'="") d
	....s rowid=""
	....s rowid=$o(^DHCCJXQMJXPatI("JXPatdecedate",Adm,decedate,rowid))
	....s flag=..repPatList(deptGroupDr,wardDr,qmschemDr, period, rowid)
	....i flag=0  d 
	.....d json.InsertRowData(ret)
	
	s resultString = json.getJsonData(jsonTitle,deadNum)
 	k json
 	
 	w "2="_$h,!
	q resultString
}

/// Creator:     wang ying
/// CreateDate:  2015-11-6
/// Description: 死亡病例讨论数量
/// Table:       
/// Input:       qmschemDr 检查项，wardDr 病区 ，startDate开始日期，endDate 结束日期，deptGroupDr 科室
/// /             <Request><startDate>2015-03-01</startDate><endDate>2015-03-31</endDate><wardDr>33</wardDr><deptGroupDr>18</deptGroupDr><qmschemDr>6</qmschemDr></Request>
/// Return:      计划信息，json格式
/// Others:  w ##class(dhc.qm.udata.uPatInfo).GetDifficult("<Request><startDate>2015-03-01</startDate><endDate>2015-03-31</endDate><wardDr>33</wardDr><deptGroupDr>18</deptGroupDr><qmschemDr>6</qmschemDr></Request>")
/// Others:  w ##class(dhc.qm.udata.uPatInfo).GetDifficultNumList("<Request><deptGroupDr>18</deptGroupDr><qmschemDr>6</qmschemDr><wardDr>33</wardDr><planDr>1</planDr></Request>")
ClassMethod GetDifficultNumList(Param As %String) As %String
{
	;n (Param)
	i Param="" s Param="<Request><startDate>2015-03-01</startDate><endDate>2015-03-31</endDate><wardDr>33</wardDr><deptGroupDr>18</deptGroupDr><qmschemDr>6</qmschemDr></Request>"
    s Param=$TR(Param,$C(10))
    s Param=$TR(Param,$C(0))
	 
	s reader=##class(%XML.Reader).%New()
    s sc=reader.OpenString(Param)
    d reader.Correlate("Request","dhc.qm.data.Request")
	While reader.Next(.request,.sc)
	{
	   s startDate=request.startDate
	   s endDate=request.endDate
	   s wardDr=request.wardDr
	   s deptGroupDr=request.deptGroupDr
	   s qmschemDr=request.qmschemDr
	   s period = request.period
	   s planDr=request.planDr
	}
	 s resultString=""
	 q:wardDr="" "NowardDr"
	 q:deptGroupDr="" "NodeptGroupDr"
	 q:qmschemDr="" "NoqmschemDr"
	 q:planDr="" "NoplanDr"
	 ;w qmschemDr_"^"_startDate_"^"_endDate_"^"_deptGroupDr_"^->"_wardDr,!
	 s resultString=##class(dhc.qm.udata.uPatInfo).GetDifficultNum(qmschemDr,deptGroupDr,wardDr,planDr)
	 q resultString
}

/// Creator:     wang ying
/// CreateDate:  2015-11-5
/// Description: 统计死亡统计数量
/// Table:       
/// Input:       qmschemDr 检查项，wardDr 病区 ，startDate开始日期，endDate 结束日期，deptGroupDr 科室
/// /           
/// Return:      计划信息，字符串
/// others:w ##class(dhc.qm.udata.uPatInfo).GetDifficultNum("6","18","33",1)
ClassMethod GetDifficultNum(qmschemDr, deptGroupDr, wardDr, planDr)
{
	
	q:qmschemDr="" "NoqmschemDr"
	q:deptGroupDr="" "NodeptGroupDr"
	q:wardDr="" "NowardDr"
	q:planDr="" "NoplanDr"
	s sqlStr="SELECT count(LocResultdetail_JXPatDr) as patNum,LocResultdetail_parRef FROM dhc_qm_data.LocResultdetail WHERE LocResultdetail_checkDr->Check_code='018'"
			_" AND LocResultdetail_parRef->LocResultMain_schemDr='006' AND LocResultdetail_actValue='Y'"
			_" AND LocResultdetail_parRef->LocResultMain_departDr='"_deptGroupDr_"' AND LocResultdetail_parRef->LocResultMain_wardDr='"_wardDr_"'"
			_" AND LocResultdetail_parRef->LocResultMain_Plandr='"_planDr_"'"
			_" group by LocResultdetail_parRef->LocResultMain_Plandr,LocResultdetail_parRef,LocResultdetail_parRef->LocResultMain_departDr,LocResultdetail_parRef->LocResultMain_wardDr"
	
    ;w sqlStr,!
    
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s json=##class(dhc.pa.comm.JsonObj).%New()
	s jsonTitle="Rowid^PatNum"
	s count=0
	s resultString=""
	While(result.Next())
	{   
		
		s Rowid= result.Data("LocResultdetail_parRef")
		s PatNum= result.Data("patNum")
		s sqlcode=0
		s tmp=Rowid_"^"_PatNum
	    i ((PatNum'="")&&(Rowid'="")) d
	    .&sql(update dhc_qm_data.LocResultdetail set LocResultdetail_actValue=:PatNum where LocResultdetail_parRef=:Rowid 
	          and LocResultdetail_checkDr->Check_code='017' and LocResultdetail_parRef->LocResultMain_schemDr='006')
	    i sqlcode'=0 d
	    .d ##class(dhc.pa.udata.uPALogger).Insert("GetDifficultNum",Rowid_"^"_PatNum_"^017^006",sqlcode,"")
		d json.InsertRowData(tmp)
		s count=count+1
		
	}
    s resultString=json.getJsonData(jsonTitle,count)
	i count=0 s resultString="{results:0,rows:[{Rowid:'',PatNum:'0'}]}"
	d result.Close()
	k json
	q resultString
}

/// Creator:     wang ying
/// CreateDate:  2015-7-30
/// Description: 判断记录是否重复
/// Table:       JXPat,LocResultMain,LocResultdetail
/// Input:       
/// Return:      1-记录重复,0-不重复
/// Others:  w ##class(dhc.qm.udata.uPatInfo).repPatList(20,43,2,201503,"56")
ClassMethod repPatList(dept As %String, ward As %String, qmschemDr As %String, period As %String, patRowid As %String, planDr As %String) As %String
{
	s flag=0
	q:dept="" "Nodept"
	q:ward="" "Noward"
	q:qmschemDr="" "NoqmschemDr"
	q:period="" "Noperiod"
	q:planDr="" "NOplanDr"
	
	s detailRowid=0,mainID=0
	i (period'="")&&(dept'="")&&(qmschemDr'="")&&(ward'="")&&(planDr'="") d
	
	.s mainID=$o(^DHCCJXQMLocResultMainI("periodQMSchemDrDepartDrWard",period,qmschemDr,dept,ward,mainID))
	.;s mainID=$o(^DHCCJXQMLocResultMainI("periodQMSDWP",planDr,period,qmschemDr,dept,ward,mainID))
	i ((patRowid'=0)&&(patRowid'=""))&&((mainID'="")&&(mainID'=0)) d
	.i $d(^DHCCJXQMLocResultdetailI("QMLRMPatCheckDr",mainID,patRowid)) s flag=1
	q flag
}

/// Creator:     ban
/// CreateDate:  2015-08-20
/// Description: 操作知情同意业务的病人信息列表
/// Table:       OE_Order  医嘱表，OE_OrdItem，pa_adm就诊表  
/// Input:       qmschemDr 检查项，wardDr 病区 ，startDate开始日期，endDate 结束日期，deptGroupDr 科室
/// /             <Request><startDate>2015-03-01</startDate><endDate>2015-05-31</endDate><wardDr>33</wardDr><deptGroupDr>18</deptGroupDr><qmschemDr>2</qmschemDr></Request>
/// Return:      计划信息，json格式
/// Others:  w ##class(dhc.qm.udata.uPatInfo).GetOperList("<Request><startDate>2015-06-05</startDate><endDate>2015-06-30</endDate><wardDr>33</wardDr><period>201502</period><deptGroupDr>18</deptGroupDr><qmschemDr>2</qmschemDr></Request>")
ClassMethod GetOperList(Param As %String) As %String
{
	;n (Param)
	i Param="" s Param="<Request><startDate>2015-03-01</startDate><endDate>2015-03-31</endDate><wardDr>33</wardDr><deptGroupDr>18</deptGroupDr><qmschemDr>2</qmschemDr></Request>"
    s Param=$TR(Param,$C(10))
    s Param=$TR(Param,$C(0))
	 
	s reader=##class(%XML.Reader).%New()
    s sc=reader.OpenString(Param)
    d reader.Correlate("Request","dhc.qm.data.Request")
	While reader.Next(.request,.sc)
	{
	   s startDate=request.startDate
	   s endDate=request.endDate
	   s wardDr=request.wardDr
	   s deptGroupDr=request.deptGroupDr
	   s qmschemDr=request.qmschemDr
	   s period = request.period
	}
	 s resultString=""
	 q:wardDr="" "NowardDr"
	 q:deptGroupDr="" "NodeptGroupDr"
	 q:qmschemDr="" "NoqmschemDr"
	 ;w qmschemDr_"^"_startDate_"^"_endDate_"^"_deptGroupDr_"^->"_wardDr,!
	 s resultString=##class(dhc.qm.udata.uPatInfo).GetList(qmschemDr,startDate,endDate,deptGroupDr,wardDr,period)
	 q resultString
}

/// Creator:     ban
/// CreateDate:  2015-08-20
/// Description: 操作知情同意业务的病人信息列表
/// Table:       OE_Order  医嘱表，OE_OrdItem，pa_adm就诊表  
/// Input:       qmschemDr 检查项，wardDr 病区 ，startDate开始日期，endDate 结束日期，deptGroupDr 科室
/// /             <Request><startDate>2015-03-01</startDate><endDate>2015-05-31</endDate><wardDr>33</wardDr><deptGroupDr>18</deptGroupDr><qmschemDr>2</qmschemDr></Request>
/// Return:      计划信息，json格式
/// <Request><startDate>2015-06-05</startDate><endDate>2015-06-30</endDate><wardDr>33</wardDr><period>201502</period><deptGroupDr>18</deptGroupDr><qmschemDr>2</qmschemDr></Request>
/// others:w ##class(dhc.qm.udata.uPatInfo).GetList("3","2015-06-01","2015-08-31","20","43","201503")
ClassMethod GetList(qmschemDr, startDate, endDate, deptGroupDr, wardDr, period)
{
	s resultString=""
	s json=##class(dhc.pa.comm.JsonObj).%New()
	s jsonTitle="patRowid^admNo^patName^inPatCode^Indoccode^IndocName^OperationID^OperationName^Operationdate"
	s arcitem =##class(dhc.qm.udata.uPatInfo).GetOperationID(qmschemDr)
	s Num=0
	;w arcitem,!
	s arcitemlen = $l(arcitem,",")
	f item = 1:1:arcitemlen  d
	.s arcitems = $p(arcitem,",",item)
	.s ret = ##class(dhc.qm.udata.uPatInfo).GetAdminfobyOrdexDate(startDate,endDate,wardDr,arcitems)
	.s patRowid="",Indoccode="",adm="",opertionID="",flag=0
	.s Indoccode=$p(ret,"^",5)
	.s exOrdDate=$p(ret,"^",9)
	.s adm=$p(ret,"^",2)
	.s opertionID=$p(ret,"^",7)
	.i (Indoccode'="")&&(adm'="")&&(opertionID'="") d
	..s patRowid=$o(^DHCCJXQMJXPatI("JXPatOperation",adm,Indoccode," "_opertionID,patRowid))
	..i ((patRowid=0)||(patRowid="")) d
	...s ^TEMPDHCCJXQMOperList($j,exOrdDate,opertionID)=ret
	...;d json.InsertRowData(ret)
	...;s Num=Num+1
	..e  d
	...s flag=..repPatList(deptGroupDr,wardDr,qmschemDr,period,patRowid)
	...;w flag_"^"_deptGroupDr_"^"_wardDr_"^"_qmschemDr_"^"_period_"^"_patRowid,!
	...i flag=0 d
	....s ^TEMPDHCCJXQMOperList($j,exOrdDate,opertionID)=ret
	....;d json.InsertRowData(ret)
	....;s Num=Num+1
	
	s exOrdDate=""
	f  s exOrdDate=$o(^TEMPDHCCJXQMOperList($j,exOrdDate)) q:exOrdDate=""  d
	.;b
	.s opertionID=""
	.f  s opertionID=$O(^TEMPDHCCJXQMOperList($j,exOrdDate,opertionID)) q:opertionID=""  d
	..s operInfo=$g(^TEMPDHCCJXQMOperList($j,exOrdDate,opertionID))
	..i operInfo'="" d
	...d json.InsertRowData(operInfo)
	...s Num=Num+1
	s resultString = json.getJsonData(jsonTitle,Num)
 	k json,^TEMPDHCCJXQMOperList($j)
	q resultString
}

/// Creator:     ban
/// CreateDate:  2015-08-25
/// Description: 操作知情同意业务的病人信息列表
/// Table:       OE_Order  医嘱表，OE_OrdItem，pa_adm就诊表  
/// Input:       wardDr 病区 ，startDate开始日期，endDate 结束日期  arcitem 医嘱id
/// 按医嘱日期查询病区病人信息
/// w ##class(dhc.qm.udata.uPatInfo).GetAdminfobyOrdexDate("2015-06-01","2015-08-31","124","18710||1")
ClassMethod GetAdminfobyOrdexDate(StDate, EnDate, Wardid, arcitem)
{
	s RoomDR="",resultString=""
	f  s RoomDR=$O(^PAADMi("CurrWard",Wardid,RoomDR)) q:RoomDR=""  d
	.s adm=""
	.s WardDr=""
	.f  s adm=$O(^PAADMi("CurrWard",Wardid,RoomDR,adm)) q:adm=""  d
	..s WardDr=$P(^PAADM(adm),"^",70)
	..s Indoc=""
	..s Indoc=$P(^PAADM(adm),"^",9)  //管床医生ID
	..s patRowid=$P(^PAADM(adm),"^",1)   //patRowid
	..s IndocName=""
	..s Indoccode=""
	..i Indoc'="" d
	...s IndocName=$p(^CTPCP(Indoc,1),"^",2)  //管床医生IndocName
	...s Indoccode=$p(^CTPCP(Indoc,1),"^",1)  //管床医生code
	..;w Indoccode_"^"_IndocName,!
	..s inPatCode=$P(^PAPER(patRowid,"PAT",1),"^",22)    //病案号inPatCode
	..s PatName=$P(^PAPER(patRowid,"ALL"),"^",1)   //patName
	..s OperationName =##class(dhc.qm.udata.uPatInfo).GetARCIMDesc(arcitem)   //执行医嘱名称
	..s ORDId=""
	..f  s ORDId=$O(^OEORD(0,"Adm",adm,ORDId)) q:ORDId=""  d
	...s SttDate=""
	...f  s SttDate=$O(^OEORDi(0,"ARCIM",ORDId,arcitem,SttDate))  q:SttDate=""  d
	....s OrdSub=""
	....f  s OrdSub=$O(^OEORDi(0,"ARCIM",ORDId,arcitem,SttDate,OrdSub)) q:OrdSub=""  d
	.....s OrdExsub=""
	.....;w "ORDId"_"->"_ORDId_"^"_OrdSub,!
	.....f  s OrdExsub=$O(^OEORD(ORDId,"I",OrdSub,"X",OrdExsub)) q:OrdExsub=""  d
	......s OrdExDate=$P(^OEORD(ORDId,"I",OrdSub,"X",OrdExsub),"^",19)  //执行医嘱日期
	......i (OrdExDate>=$zdh(StDate,3))&&(OrdExDate<=$zdh(EnDate,3)) d
	.......s ExStDate=$zd($P(^OEORD(ORDId,"I",OrdSub,"X",OrdExsub),"^",1),3)  //开医嘱时间
	.......s Papmidr=$P(^PAADM(adm),"^",1)
	.......;w !,patRowid_"^"_adm_"^"_PatName_"^"_inPatCode_"^"_Indoccode_"^"_IndocName_"^"_arcitem_"^"_OperationName_"^"_ExStDate
    .......s resultString = ""_"^"_adm_"^"_PatName_"^"_inPatCode_"^"_Indoccode_"^"_IndocName_"^"_arcitem_"^"_OperationName_"^"_$zd(OrdExDate,3)
    q resultString
}

/// Creator：ban
/// CreatDate：2015-08-21
/// Description: 根据id获取操作名称
/// Table：ARC_ItmMast
/// Input：OEORIItmMastDR  操作人id
/// Output：
/// Return：
/// Others：w ##class(dhc.qm.udata.uPatInfo).GetARCIMDesc("26610||1")
ClassMethod GetARCIMDesc(OEORIItmMastDR)
{
	;n (OEORIItmMastDR)
	s ARCIMDesc=""
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select ARCIM_Desc from ARC_ItmMast"
	s whereStr=""
	i OEORIItmMastDR '="" s whereStr="  where ARCIM_RowId  = '"_OEORIItmMastDR_"'" 
	s sqlStr=sqlStr_whereStr
	;w sqlStr,!
	d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next()){
		s ARCIMDesc = result.Data("ARCIM_Desc")
	}
	d result.Close()
	q ARCIMDesc
}

/// Creator：ban
/// CreatDate：2015-08-21
/// Description: 根据检查项id获取操作id
/// Table：dhc_qm_data.QMSchem
/// Input：qmschemDr  检查项id
/// Output：
/// Return：
/// Others：w ##class(dhc.qm.udata.uPatInfo).GetOperationID(2)
ClassMethod GetOperationID(qmschemDr)
{
	;n (OEORIItmMastDR)
	s OperationID=""
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select QMSchem_Arcitem from dhc_qm_data.QMSchem"
	s whereStr=""
	i qmschemDr '="" s whereStr="  where QMSchem_RowID  = '"_qmschemDr_"'" 
	s sqlStr=sqlStr_whereStr
	;w sqlStr,!
	d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next()){
		s OperationID = result.Data("QMSchem_Arcitem")
	}
	d result.Close()
	q OperationID
}

/// Creator:     ban
/// CreateDate:  2015-09-01
/// Description: 1.6.会诊制度（只考虑单科会诊）
/// Table:       OE_Order  医嘱表，OE_OrdItem，pa_adm就诊表  
/// Input:       qmschemDr 检查项，wardDr 病区 ，startDate开始日期，endDate 结束日期，deptGroupDr 科室  period期间
/// /             <Request><Request><startDate>2015-06-05</startDate><endDate>2015-06-30</endDate><wardDr>43</wardDr><period>201502</period><deptGroupDr>20</deptGroupDr><qmschemDr>4</qmschemDr></Request></Request>
/// Return:      计划信息，json格式
/// Others:  w ##class(dhc.qm.udata.uPatInfo).GetConsult("<Request><startDate>2015-06-05</startDate><endDate>2015-06-30</endDate><wardDr>43</wardDr><period>201502</period><deptGroupDr>20</deptGroupDr><qmschemDr>4</qmschemDr></Request>")
/// Others:  w ##class(dhc.qm.udata.uPatInfo).GetConsult("<Request><startDate>2015-03-01</startDate><wardDr>43</wardDr><endDate>2015-05-31</endDate><qmschemDr>4</qmschemDr><period>201502</period><deptGroupDr>20</deptGroupDr></Request>")
ClassMethod GetConsult(Param As %String) As %String
{
	;n (Param)
	i Param="" s Param="<Request><startDate>2015-06-05</startDate><endDate>2015-06-30</endDate><wardDr>43</wardDr><period>201502</period><deptGroupDr>20</deptGroupDr><qmschemDr>4</qmschemDr></Request>"
    s Param=$TR(Param,$C(10))
    s Param=$TR(Param,$C(0))
	;s ^tempxhabc(1)=Param 
	s reader=##class(%XML.Reader).%New()
    s sc=reader.OpenString(Param)
    d reader.Correlate("Request","dhc.qm.data.Request")
	While reader.Next(.request,.sc)
	{
	   s startDate=request.startDate
	   s endDate=request.endDate
	   s wardDr=request.wardDr
	   s deptGroupDr=request.deptGroupDr
	   s qmschemDr=request.qmschemDr
	   s period = request.period
	}
	 s resultString=""
	 q:wardDr="" "NowardDr"
	 q:deptGroupDr="" "NodeptGroupDr"
	 q:qmschemDr="" "NoqmschemDr"
	 q:period="" "Noperiod"
	 ;w qmschemDr_"^"_startDate_"^"_endDate_"^"_deptGroupDr_"^->"_wardDr,!
	 s resultString=##class(dhc.qm.udata.uPatInfo).GetConsultList(qmschemDr,startDate,endDate,deptGroupDr,wardDr)
	 ;s ^tempxhabc=resultString
	 q resultString
}

/// Creator:     ban
/// CreateDate:  2015-09-01
/// Description: 1.6.会诊制度（只考虑单科会诊）
/// Table:       SS_User
/// Input:       qmschemDr 检查项，wardDr 病区 ，startDate开始日期，endDate 结束日期，deptGroupDr 科室
/// /             <Request><startDate>2015-03-20</startDate><endDate>2015-03-31</endDate><wardDr>43</wardDr><deptGroupDr>20</deptGroupDr><qmschemDr>6</qmschemDr></Request>
/// Return:      计划信息，json格式
/// others:w ##class(dhc.qm.udata.uPatInfo).GetConsultList("4","2016-03-13","2016-03-31","20","45","201502")
ClassMethod GetConsultList(qmschemDr, startDate, endDate, deptGroupDr, wardDr, period)
{
	
	;s ^shghhgtemp = wardDr
	s resultString=""
	s json=##class(dhc.pa.comm.JsonObj).%New()
	s jsonTitle="patRowid^admNo^inPatCode^patName^Indoccode^IndocName^consultID^consultdepart^consultdepartName^consultdoccode^consultdoc^applydate^consultdate^applyloc"
	s Num=0,ret="",retData="",consultdepartdr="",N=0
	s startDate=$zdh(startDate,3),endDate=$zdh(endDate,3)
	f ConsultDate=startDate:1:endDate  d
	.s ConsultDates = $zd(ConsultDate,3)
	.s ret=##class(web.DHCConsult).getwardconsultinfo(ConsultDates,wardDr)
	.s IndocName=""
	.f retNum=1:1:$l(ret,"$") d
	..s retString = $p(ret,"$",retNum)
	..s admNo = $p(retString,"^",1)      //就诊号admNo
	..q:admNo=""
	..s inPatCode = $p(retString,"^",2)
	..s patName = $p(retString,"^",3)
	..s Indoccode= $p(retString,"^",5) //$P(^PAADM(admNo),"^",9)  //管床医生Indoccode
	..s IndocName= $p(retString,"^",6)
	..s applyloc = $p(retString,"^",7)
	..;q:deptGroupDr'=applyloc 
	..s applyDesc = $p(retString,"^",8)
	..s consultID = $p(retString,"^",11)
	..s consultdepartDr = $p(retString,"^",10)
	..;w consultdepartDr,!
	..i consultdepartDr'="" d
	...s consultdepart=$p(^CTLOC(consultdepartDr),"^",19)
	...s consultdepartName =""
	...i consultdepart'="" d
	....s consultdepartName = $p(^RBC("DEP",consultdepart),"^",2) 
	..;s consultdepartName = $p(retString,"^",12)
	..s consultdoccode = $p(retString,"^",5)
	..s consultdoc = $p(retString,"^",6)
	..s applydate = $p(retString,"^",9)
	..s consultdate = $p(retString,"^",13)
	..s retData=""_"^"_admNo_"^"_inPatCode_"^"_patName_"^"_Indoccode_"^"_IndocName_"^"_consultID_"^"_consultdepart_"^"_consultdepartName_"^"_consultdoccode_"^"_consultdoc_"^"_applydate_"^"_consultdate_"^"_applyDesc
	..s Depdr=$p(^CTLOC(applyloc),"^",19)
	..i Depdr=deptGroupDr   d
	...s rowId=""
	...i (admNo'="")&&(consultID'="") d
	
	....s rowId=$o(^DHCCJXQMJXPatI("JXPatconsult",admNo," "_consultID,rowId))
	....i ((rowId=0)||(rowId="")) d
	.....S N=N+1
	.....;s ^tempXHWY(N)=admNo_","_" "_consultID
	.....s ^TEMPDHCCJXQMGetConsultList($j,applydate,consultID)=retData
	
	s applydate="" 
	f  s applydate=$o(^TEMPDHCCJXQMGetConsultList($j,applydate)) q:applydate=""  d
	.s consultID="" 
	.f  s consultID=$o(^TEMPDHCCJXQMGetConsultList($j,applydate,consultID))  q:consultID=""  d
	..s consult=$g(^TEMPDHCCJXQMGetConsultList($j,applydate,consultID))
	..i consult'="" d
	...d json.InsertRowData(consult)
	...s Num=Num+1 
	
	s resultString = json.getJsonData(jsonTitle,Num)
 	k json,^TEMPDHCCJXQMGetConsultList($j)
	q resultString
}

/// Creator:     ban
/// CreateDate:  2015-10-26
/// Description: 从已检或者未检界面删除病人到病人信息界面中
/// Table:       DHC_AN_Oparrange,麻醉表、手术表、DHCANCSiteProphyAntibiotics,ORC_BladeType(代码为"I","II","III","IV")
/// Input:       病人信息id
/// Return:      
/// Others:  w ##class(dhc.qm.udata.uPatInfo).DeleteInfoFromCheck("<Request><patRowid>1</patRowid><wardDr>45</wardDr><planDr>1</planDr><period>201503</period><status>1</status><qmschemDr>1</qmschemDr><deptGroupDr>20</deptGroupDr></Request>")
ClassMethod DeleteInfoFromCheck(Param As %String) As %String
{
	;n (Param)
	i Param="" s Param="<Request><patRowid>11004969</patRowid><wardDr>43</wardDr><planDr>9</planDr><period>201503</period><status>1</status><qmschemDr>1</qmschemDr><deptGroupDr>20</deptGroupDr></Request>"
    s Param=$TR(Param,$C(10))
    s Param=$TR(Param,$C(0))
	 
	s reader=##class(%XML.Reader).%New()
    s sc=reader.OpenString(Param)
    // s sc=reader.OpenStream(objStream)
    d reader.Correlate("Request","dhc.qm.data.Request")
    //Do reader.Rewind()
	While reader.Next(.request,.sc)
	{
	   s patRowid=request.patRowid
	   s planDr=request.planDr
	   s period=request.period
	   s wardDr=request.wardDr
	   s deptGroupDr=request.deptGroupDr
	   s status=request.status
	   s qmschemDr=request.qmschemDr
	}
	 s resultString=""
	 q:patRowid="" "NopatRowid"
	 q:planDr="" "NoplanDr"
	 q:period="" "Noperiod"
	 q:wardDr="" "NowardDr"
	 q:deptGroupDr="" "NodeptGroupDr"
	 q:qmschemDr="" "NoqmschemDr"
	 q:status="" "NoStatus"
	 
	 s resultString=##class(dhc.qm.udata.uPatInfo).deleteFromCheck(patRowid,planDr,period,wardDr,deptGroupDr,qmschemDr,status)
	 i resultString=0  s resultString="{success:'true',info:'删除成功！'}"
	 e   s resultString="{success:'false',info:'删除失败！'}"

	 q resultString
}

/// Creator：ban
/// CreatDate：2015-11-03
/// Description: 删除记录
/// Table： dhc_qm_data.LocResultdetail
/// Input: patRowid, planDr, period, wardDr, deptGroupDr, qmschemDr, status
/// Output：
/// Return：否则返回执行更新语句后的SQLCODE
/// Others：w ##class(dhc.qm.udata.uPatInfo).deleteFromCheck(117,9,201503,15,22,1,0)
ClassMethod deleteFromCheck(patRowid, planDr, period, wardDr, deptGroupDr, qmschemDr, status) As %String
{
	;n (patRowid,planDr,period,wardDr,deptGroupDr,qmschemDr,status)
	s mainId =..SelectMainID(planDr,period,wardDr,deptGroupDr,qmschemDr)
	&SQL(delete from dhc_qm_data.LocResultdetail where LocResultdetail_JXPatDr = :patRowid and LocResultdetail_parRef = :mainId and LocResultdetail_saveStatus =:status)
	q SQLCODE
}

/// Creator:ban
/// CreatDate:2015-11-03
/// Description:根据planDr,period,wardDr,deptGroupDr,qmschemDr获取主表的id
/// Table:dhc_qm_data.LocResultMain
/// Output:
/// Return:MainID
/// Others:w ##class(dhc.qm.udata.uPatInfo).SelectMainID("9","201503","15","22","1") 
ClassMethod SelectMainID(planDr, period, wardDr, deptGroupDr, qmschemDr) As %String
{
	;n (planDr,period,wardDr,deptGroupDr,qmschemDr)	
		
	s sqlStr="select LocResultMain_rowid from dhc_qm_data.LocResultMain where %ID>'0'"
	i planDr'="" s sqlStr=sqlStr_"  and LocResultMain_Plandr ='"_planDr_"'"
	i wardDr'="" s sqlStr=sqlStr_"  and LocResultMain_wardDr ='"_wardDr_"'"
	i deptGroupDr'="" s sqlStr=sqlStr_"  and LocResultMain_departDr ='"_deptGroupDr_"'"
	i qmschemDr'="" s sqlStr=sqlStr_"  and LocResultMain_schemDr ='"_qmschemDr_"'"
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr) 
	d result.Execute()
	s grouName=""
	while(result.Next())
	{
		s MainID=result.Data("LocResultMain_rowid")
		
	}
	d result.Close()
	
	q MainID
}

/// Creator:     wang ying
/// CreateDate:  2015-11-26
/// Description: 根据登陆的信息获取登陆人的id
/// Table:       SS_User
/// Input:       qmschemDr 检查项，wardDr 病区 ，startDate开始日期，endDate 结束日期，deptGroupDr 科室
/// /             <Request><startDate>2015-03-20</startDate><endDate>2015-03-31</endDate><wardDr>43</wardDr><deptGroupDr>20</deptGroupDr><qmschemDr>6</qmschemDr></Request>
/// Return:      用sql语句查询死亡病人信息，json格式
/// others:w ##class(dhc.qm.udata.uPatInfo).GetDifficultList("6","2014-03-01","2014-05-31","18","33","201402","1")
/// others:w ##class(dhc.qm.udata.uPatInfo).GetDifficult1("6","2015-06-01","2015-08-31","18","33","201503","1")
ClassMethod GetDifficult1(qmschemDr, startDate, endDate, deptGroupDr, wardDr, period, planDr)
{
	
	;w "1="_$h,!
	s deadCouNum=0
	;s deadCouNum=..GetDifficultNum(qmschemDr, deptGroupDr, wardDr, planDr)
	s json=##class(dhc.pa.comm.JsonObj).%New()
	s jsonTitle="patRowid^admNo^patName^inPatCode^Indoccode^IndocName^decedate^deadNum"

	s startDate=$zdh(startDate,3),endDate=$zdh(endDate,3)
	s sqlStr="SELECT count(*) as deadNum,PAADM_AdmDocCodeDR,PAADM_AdmDocCodeDR->CTPCP_Code,PAADM_AdmDocCodeDR->CTPCP_Desc,PAADM_RowID,PAPER_Deceased,PAPER_Deceased_Date,PA_Person.PAPER_Name,PAADM_DischgDate,PAPMI_Medicare FROM PA_Adm,PA_Person,PA_PatMas"
	         _" WHERE PAADM_DischgDate>='"_startDate_"' AND PAADM_DischgDate<='"_endDate_"'" 
			 _" AND PAADM_CurrentWard_DR='"_wardDr_"'" 
			 _" AND PAADM_PAPMI_DR=PAPER_RowId AND PAADM_PAPMI_DR=PAPMI_RowId"
			 _" AND PAPER_Deceased='Y'"
			 _" AND PAPER_Deceased_Date>='"_startDate_"' AND PAPER_Deceased_Date<='"_endDate_"'"
	         _" ORDER BY PAPER_Deceased_Date"
	s result=##class(%Library.ResultSet).%New()
	;w sqlStr,!
	d result.Prepare(sqlStr) 
	d result.Execute()
	s resultString=""
	s deadNum=0
	s i=0
	;b
	while(result.Next())
	{
		
		s Adm=result.Data("PAADM_RowID")
		s PatName=result.Data("PAPER_Name")
		s inPatCode=result.Data("PAPMI_Medicare")
		s Indoccode=result.Data("CTPCP_Code")
		s IndocName=result.Data("CTPCP_Desc")
		s decedate=result.Data("PAPER_Deceased_Date")
		s deadNums=result.Data("deadNum")
		s i=i+1
		;w "ssssss   "_deadNums_"ssss  "_i,!
		s ret="^"_Adm_"^"_PatName_"^"_inPatCode_"^"_Indoccode_"^"_IndocName_"^"_$zd(decedate,3)_"^"_deadNums
		;w ret,!
		s rowid=""
	    s rowid=$o(^DHCCJXQMJXPatI("JXPatdecedate",Adm,decedate,rowid))
	    
	    s flag=..repPatList(deptGroupDr,wardDr,qmschemDr, period, rowid,planDr)
	    i flag=0  d 
	    .d json.InsertRowData(ret)
	    .s deadNum=deadNum+1
	}
	d result.Close()
	
	s resultString = json.getJsonData(jsonTitle,deadNums)
 	k json
 	
 	;w "2="_$h,!
	q resultString
}

}
