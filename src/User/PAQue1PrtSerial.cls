Class User.PAQue1PrtSerial Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, ProcedureBlock, SqlTableName = PA_Que1PrtSerial, StorageStrategy = SQLStorage ]
{

/// Des Ref to OEORD
Relationship PAPSPAParRef As PAQue1 [ Cardinality = parent, Inverse = ChildPAPS, Required, SqlFieldName = PAPS_PA_ParRef ];

/// OEORI Child Sub (New Key)
Property PAPSChildsub As %Numeric(SCALE = 0) [ InitialExpression = {$i(^PAQUE1($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"Prt",0))}, Required, SqlColumnNumber = 2, SqlFieldName = PAPS_Childsub ];

Index RowIDBasedIDKeyIndex On PAPSChildsub [ IdKey, PrimaryKey, Unique ];

/// 流水号
Property PAPSSerialNumber As %String [ Required, SqlColumnNumber = 3, SqlFieldName = PAPS_SerialNumber ];

/// 医嘱日期，防止出现打印非当日处方的情况
Property PAPSDate As %Date [ Required, SqlColumnNumber = 4, SqlFieldName = PAPS_Date ];

Property PAPSPrtTimeS As %Float [ SqlColumnNumber = 5, SqlFieldName = PAPS_PrtTimeS ];

Property PAPSCreatUser As User.SSUser [ SqlColumnNumber = 6, SqlFieldName = PAPS_CreatUser ];

Property PAPSCreatDate As %Date [ SqlColumnNumber = 7, SqlFieldName = PAPS_CreatDate ];

Property PAPSCreatTime As %Time [ SqlColumnNumber = 8, SqlFieldName = PAPS_CreatTime ];

Property PAPSLastUpdateUser As User.SSUser [ SqlColumnNumber = 9, SqlFieldName = PAPS_LastUpdateUser ];

Property PAPSLastUpdateDate As %Date [ SqlColumnNumber = 10, SqlFieldName = PAPS_LastUpdateDate ];

Property PAPSLastUpdateTime As %Time [ SqlColumnNumber = 11, SqlFieldName = PAPS_LastUpdateTime ];

/// 获取打印流水号
/// inpuit:处方号;打印日期:防止出现今天打印昨天的情况，前台先不实现，默认都是按当日处理
/// w ##Class(User.PAQue1PrtSerial).GetPrtSerial(486)
ClassMethod GetPrtSerial(PrescNo As %String, PrtDate As %String = "") As %String
{
	q:(PrescNo="") ""
	s PAQueRowID=$O(^PAQUE1(0,"PrescNo",PrescNo,""),-1)
	q:(PAQueRowID="") ""
	q:'$D(^PAQUE1(PAQueRowID)) ""
	s PrtDate=##class(websys.Conversions).DateHtmlToLogical(PrtDate)
	i PrtDate="" s PrtDate=+$H
	s ord=$o(^OEORD(0,"PrescNo",PrescNo,""),-1)
	s OrdSub=$o(^OEORD(0,"PrescNo",PrescNo,ord,""),-1)
	s PriorityDR=$p(^OEORD(+ord,"I",OrdSub,1),"^",8)
    s Priority=$p(^OECPR(PriorityDR),"^",2)
    s ISLongOrderPrior=##class(appcom.OEOrdItem).ISLongOrderPrior(PriorityDR)
    s SerialNumber=""
	s PAPSChildsub=0
	for {
		s PAPSChildsub=$O(^PAQUE1(PAQueRowID,"Prt",PAPSChildsub))
		q:((PAPSChildsub="")||(SerialNumber'=""))
		s Val=^(PAPSChildsub)
		s Date=$P(Val,"^",2)
		continue:((ISLongOrderPrior="1")&&(Date'=PrtDate))
		s SerialNumber=$P(Val,"^",1)
	}
	q SerialNumber
}

/// 当获取不到流水号时，根据处方号生成流水号,打印到处方上面
/// w ##Class(User.PAQue1PrtSerial).InsertPrtSerial("O170727000009","","1")
ClassMethod InsertPrtSerial(PrescNo As %String, PrtDate As %String, UserID As %String) As %String
{
	s PrtDate=##class(websys.Conversions).DateHtmlToLogical(PrtDate)
	i PrtDate="" s PrtDate=+$H
	s SerialNumber=..GetPrtSerial(PrescNo,PrtDate)
	if (SerialNumber'="") {q ""}
	s PAQueRowID=$O(^PAQUE1(0,"PrescNo",PrescNo,""),-1)
	s ord=$o(^OEORD(0,"PrescNo",PrescNo,""),-1)
	s OrdSub=$o(^OEORD(0,"PrescNo",PrescNo,ord,""),-1)
	s ExpandOrdInfo=##Class(web.DHCDocPrescript).GetLinkOrdInfo(ord_"||"_OrdSub)
	s PHPrescType=$P(ExpandOrdInfo,"^",3)
	s DMJFlag=0
	//i ("^6^8^")[("^"_PHPrescType_"^") s DMJFlag=1
	s SplitPrescTypeDetails=$P(ExpandOrdInfo,$C(1),3)
	s DMJFlag=$P(SplitPrescTypeDetails,"^",5)
	
	TS
	if (DMJFlag=1){
		s SerialNumber=$I(^PRESC("MJPrt",PrtDate))
	}else{
		s SerialNumber=$I(^PRESC("Prt",PrtDate))
	}
	s dt1=$zd(PrtDate),mm=+dt1,yy=$p(dt1,"/",3)
	s yy1=$e(yy,3,4)
	s dt=$e($tr(dt1,"/"),1,4)
	s SerialNumber=yy1_dt_$e(1000000+SerialNumber,3,7)
	if (DMJFlag=1){
		//为防止与真正的处方号冲突，以MS开头
		s SerialNumber="MS"_SerialNumber
	}else{
		s SerialNumber="PT"_SerialNumber
	}
	kill PLIST
	s PLIST(0)=PAQueRowID
	s PLIST(3)=SerialNumber
	s PLIST(4)=PrtDate
	s PLIST(6)=UserID
	s PLIST(7)=+$H
	s PLIST(8)=$P($H,",",2)
	&sql(INSERT INTO SQLUser.PA_Que1PrtSerial VALUES :PLIST())
	s err=SQLCODE
	i err {
		TRO
		q ""
	}
	TC
	
	q SerialNumber
}

/// 根据流水号，保存打印记录
/// w ##Class(User.PAQue1PrtSerial).SavePrintLog("17072700003","1")
ClassMethod SavePrintLog(SerialNumber As %String, UserID As %String) As %String
{
	q:((SerialNumber="")||(UserID="")) -100
	s PAQueRowID=$O(^PAQUE1(0,"Prt",0,"SerialNum",SerialNumber,""),-1)
	q:(PAQueRowID="") -200
	s PAPSChildsub=$O(^PAQUE1(0,"Prt",0,"SerialNum",SerialNumber,PAQueRowID,""),-1)
	q:(PAPSChildsub="") -300
	
	s obj=##Class(User.PAQue1PrtSerial).%OpenId(PAQueRowID_"||"_PAPSChildsub)
	if '$IsObject(obj) Quit -400
	
	TS
	s obj.PAPSPrtTimeS=obj.PAPSPrtTimeS+1
	d obj.PAPSLastUpdateUserSetObjectId(UserID)
	s obj.PAPSLastUpdateDate=+$H
	s obj.PAPSLastUpdateTime=$P($H,",",2)
	
	s sc=obj.%Save()
	If $$$ISERR(sc) {
		Trollback
		Quit -500
	}
	TC
	
	q 0
}

Storage SQLStorage
{
<SQLMap name="DataBase">
<Data name="PAPS_CreatDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PAPS_CreatTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PAPS_CreatUser">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PAPS_Date">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PAPS_LastUpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PAPS_LastUpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PAPS_LastUpdateUser">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PAPS_PrtTimeS">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PAPS_SerialNumber">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^PAQUE1</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_Que1.QUE1_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PAPS_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PA_Que1.QUE1_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Prt"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PAPS_Childsub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexSerialNum">
<Global>^PAQUE1</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>PA_Que1.QUE1_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>PAPS_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Prt"</Expression>
</Subscript>
<Subscript name="3">
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<Expression>"SerialNum"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PAPS_SerialNumber}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PA_Que1.QUE1_RowID}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{PAPS_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.PAQue1PrtSerialS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
