/// 信访系统接口
Class DHCMed.CCService.Lib.Letter Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

//w ##class(DHCMed.CCService.Lib.Letter).Test()

ClassMethod Test()
{
	New
	
	Set %EpisodeID=345
	Set %PatientID=181
	Set %ExtraData=$lb("")
	Set %ErrorData=$lb("")
	Set %AutoRunFlag=1
	Set %CurrentDate=+$h		
	Set return=..IsCurrentLetterPatient(2337)
	Write "%ExtraData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ExtraData,"///"),!
	Write "%ErrorData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ErrorData,"///"),!
	Write "return="_return,!

	
	Quit "Over"
}

/// 当前就诊是否有信访事件
ClassMethod IsCurrentLetterPatient(Type As %String)
{
		New (%EpisodeID,%ExtraData,%ErrorData,Type)
		Set RowID=""
		Set Rst=""
		Set ret=0
		For {
			Set RowID=$o(^DHCMed.LetterI("Letter","IndexPaadm",%EpisodeID,RowID))
			Quit:RowID=""
			Set obj=##class(DHCMed.Letter.Letter).GetObjById(RowID)
			Continue:$IsObject(obj)=0
			Do obj.%Close()
			Continue:obj.Type'=Type
			Set Rst=..FormatLetterInfo(RowID)
			Set Rst=$$BuildIsCurrentLetterPatientResult(1)  //格式化输出
			Set %ExtraData=%ExtraData_$lb(Rst)
			Set ret=ret+1
		}
		Quit ret
BuildIsCurrentLetterPatientResult(arg0) //Add By LiYang 2012-06-20
	Set tmpDesc=Rst
	//ExtraData=$lb(Summary,ActDate,ActTime,DataValue,ObjectID,UserID,Parameters)
	Set tmp=""
	Set $p(tmp,$c(3),1)=tmpDesc
	Set $p(tmp,$c(3),2)=obj.UpdateDate
	Set $p(tmp,$c(3),3)=obj.UpdateTime
	Set $p(tmp,$c(3),4)=obj.Reason
	Set $p(tmp,$c(3),5)=+obj.%Id()
	Set $p(tmp,$c(3),6)=+obj.UpdateUser
	Set $p(tmp,$c(3),7)="Type"_Type
	Quit tmp
}

/// 历史上是否有信访事件
ClassMethod IsHistoryLetterPatient(Type As %String)
{
		New (%EpisodeID,%ExtraData,%ErrorData,Type,%PatientID)
		Set RowID=""
		Set Rst=""
		Set ret=0
		For {
			Set RowID=$o(^DHCMed.LetterI("Letter","IndexPatientID",%PatientID,RowID))
			Quit:RowID=""
			Set obj=##class(DHCMed.Letter.Letter).GetObjById(RowID)
			Continue:$IsObject(obj)=0
			Continue:obj.Paadm=%EpisodeID
			Do obj.%Close()
			Continue:obj.Type'=Type
			Set Rst=..FormatLetterInfo(RowID)
			Set Rst=$$BuildIsCurrentLetterPatientResult(1)  //格式化输出
			Set %ExtraData=%ExtraData_$lb(Rst)
			Set ret=ret+1
		}
		Quit ret
}

ClassMethod FormatLetterInfo(RowID)
{
		n (RowID)
		Set ret=""
		Set obj=##class(DHCMed.Letter.Letter).GetObjById(RowID)
		Quit:$IsObject(obj)=0 ret
		Set strKind=""
		Set KindID=""
		For {
			Set KindID=$o(^DHCMed.LetterI("LetterKind","MainIDIndex",RowID,KindID))
			Quit:KindID=""
			Set objKind=##class(DHCMed.Letter.LetterKind).%OpenId(KindID)
			Continue:$IsObject(objKind)=0
			Do objKind.%Close()
			Set:strKind'="" strKind=strKind_","
			Set strKind=strKind_$$GetReportSearchDicDescription(objKind.Kind)
		}
		Set ret="记录日期:"_$zd(obj.RecordDate,3)
		Set ret=ret_"  类别:"_$$GetReportSearchDicDescription(obj.RecType)
		Set ret=ret_"  性质:"_strKind
		Set ret=ret_"  程度:"_$$GetReportSearchDicDescription(obj.LetterLevel)
		Set ret=ret_"  原由:"_obj.Reason
		;Set ret=ret_"<BR/><A target='_blank' href='dhcmed.letter.edit.csp?RowID="_obj.%Id()_"'>详情</A>"
		
		Quit ret
	
GetReportSearchDicDescription(ID)
	n (ID)
	Set objDic=##class(DHCMed.SS.Dictionary).GetObjById(ID)
	Set:$IsObject(objDic)=0 objDic=##class(DHCMed.SS.Dictionary).%New()
	Do objDic.%Close()
	Set ret=objDic.Description
	Set objDic=""
	Kill objDic
	Quit ret
}

}
