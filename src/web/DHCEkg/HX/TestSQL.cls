Class web.DHCEkg.HX.TestSQL Extends %RegisteredObject
{

/*
ClassMethod GetdiagnoseInfo()
{
	w $zd(+$h,3)_" "_$zt($p($h,",",2),3)
	set snap=##class(EnsLib.SQL.Snapshot).%New()
	set pQuery="select file_name,mr_class,last_modify_date_time,PATIENT_ID,visit_id from mr_file_index"
	set sc=..ImportDiagnoseInfo(pQuery)
	w $zd(+$h,3)_" "_$zt($p($h,",",2),3)
	Quit sc
}
*/
/// w ##class(web.DHCEkg.HX.TestSQL).SqlConnection("select * from [dbo].[User]",.arrayUser)
ClassMethod SqlConnection(pQuery As %String, Output arrayResult As %DynamicArray) As %String
{
	set gc=##class(%SQLGatewayConnection).%New()
	set pDSN="DBHX"
	set usr="sa"
	set pwd="ECGecg123"	
	
	set sc=gc.Connect(pDSN,usr,pwd,0)  
	;b ; zw sc 
	set sc=gc.AllocateStatement(.hstmt)
	if sc'="1" {
		Quit "调用AllocateStatement方法失败:"_sc
	}	 
	if pQuery="" {
		Quit "查询SQL语句为空"
	}
	;set snap=##class(EnsLib.SQL.Snapshot).%New()
	set sc=gc.Prepare(hstmt,pQuery)
	if sc'="1" {
		Quit "调用Prepare方法失败:"_sc
	}	
	set sc=gc.Execute(hstmt)
	if sc'="1" {
		Quit "调用Execute方法失败:"_sc
	}	
	set sc=gc.DescribeColumns(hstmt, .columnlist)
	if sc'="1" {
		Quit "调用DescribeColumns方法失败:"_sc
	}	
	;zw columnlist
	set numcols=$listlength(columnlist)-1 	
	set colNames=""
	for colnum=2:1:numcols+1 {
		set colnumName=$listget($listget(columnlist,colnum),1)
		set colnumName=$replace(colnumName,"_","") ;去掉字段名中的下划线
		set @("cols"_colnum)=colnumName		
		set:colNames'="" colNames=colNames_","_"cols"_colnum
		set:colNames="" colNames="cols"_colnum
	}
	;zw colNames
	;B ; w cols
	if colNames="" {
		Quit "SQL语句对应表或者视图列为空"
	}
	
	set sc=gc.Fetch(hstmt)
	if sc'="1" {
		Quit "调用Fetch方法失败:"_sc
	}
	set count=0
	s exeStr="array = []" ;定义array
	s @exeStr
	while((gc.sqlcode'=100)) {
		;set exestr="snapshot=##class(EnsLib.SQL.Snapshot).%New()",@exestr
		;set exestr="tSC=snapshot.SetColNames("_colNames_")",@exestr	
		set rowInfos="",keyNameInfo=""
		;s object=##class(%DynamicObject).%New()
		s exeStr="object=##class(%DynamicObject).%New()"
		s @exeStr
		for ii=1:1:numcols {
			set sc=gc.GetData(hstmt, ii, 1, .val)
			if sc'=1 {
				continue
			}
			;b ; zw val
			set val=$zcvt(val,"I","GB18030")
			;b ; zw val
			;w val,!
			s colnum=ii+1
			s filedName=@("cols"_colnum)
			s exeStr="object."_filedName_"="""_val_""""
			;w exeStr,!
			s @exeStr
			;set @("rowN"_ii)=val
			;set:rowInfos'="" rowInfos=rowInfos_",rowN"_ii
			;set:rowInfos="" rowInfos="rowN"_ii	
		}
		s exeStr="array.%Push(object)"
		d @exeStr
		set sc=gc.Fetch(hstmt)
		;set exestr="tSC=snapshot.AddRow("_rowInfos_")",@exestr
		;set snap=@("snapshot")
		;set sc=..GetNextDiagnoseSnap(snap)
		set count=count+1
	}
	;zw array
	;b ; w @"array.%Get(0).NAME"
	s arrayResult=@"array"
	
	set sc=gc.CloseCursor(hstmt)
	if sc'="1" {
		Quit "调用CloseCursor方法失败:"_sc
	}	
	set sc=gc.Disconnect()
	if sc'="1" {
		Quit "调用Disconnect方法失败:"_sc
	}	
	;set snap=@("snapshot")
	Quit count
}

/*
ClassMethod GetNextDiagnoseSnap(Snap As EnsLib.SQL.Snapshot) As %String
{
	if Snap.Next() {
		//file_name,mr_class,last_modify_date_time
		set filename=Snap.Get("file_name") 		
		set mrclass=Snap.Get("mr_class")   
		set lastdatetime=Snap.Get("last_modify_date_time")  
		set patid=Snap.Get("PATIENT_ID") 
		set visitid=Snap.Get("visit_id") 
		
		;b ;33333

		s ^DHCENSJHEMR(" "_patid," "_visitid," "_mrclass," "_filename," "_lastdatetime)=""
		;set ^DHCENSDiagnoseInfo("DongRuan",INPATIENTNO,HAPPENNO)=$lb(INPATIENTNO,HAPPENNO,DIAGKIND,ICDCODE,DIAGNAME,DIAGDATE,DOCTCODE,DOCTNAME,OUTDATE,DIAGOUTSTATE,MAINFLAG,OPERDATE,OPERTYPE,DIAGZG)
		;w ^DHCENSDiagnoseInfo("DongRuan",INPATIENTNO,HAPPENNO),!
		;b ;??
		;set ^DHCENSFinOpbFeedetailInfo("DongRuan",number,CARDNO,"DR_"_CLINICCODE,OEORIOrderItemID,TRANSTYPE)=$lb("",OEORIOrderItemID,ITEMCODE,"NORM","V",RECIPENO,DOSEMODELCODE,DOSEONCE,DOSEUNIT,FREQUENCYCODE,USAGECODE,QTY,DOCTCODE,$p(OPERDATE," ",1),$p(OPERDATE," ",2),REGDPCD,EXECDPCD,LABTYPE,OPERCODE,"A")

	}
	Quit 1
}
*/
}
