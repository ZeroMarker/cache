Class web.DHCDocErrCodeRegister Extends DHCDoc.Util.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod delErrCode(rowid As %String) As %String
{
 	&sql(delete From SQLUser.DHCDoc_ErrCodeRegister where ECR_RowID=:rowid)
	Q SQLCODE
}

ClassMethod insertErrCode(className As %String, code As %String, desc As %String, notes As %String) As %String
{
	if ($d(^DHCDocErrCodeRegisterI("ERRCODE",className,code))) Q "repeat"
	k PLIST
	s PLIST(2)=className
	s PLIST(3)=code
	s PLIST(4)=desc
	s PLIST(5)=notes
 	&sql(insert into SQLUser.DHCDoc_ErrCodeRegister values :PLIST())
 	b //55
	Q SQLCODE
}

ClassMethod updateErrCode(rowid As %String, className As %String, code As %String, desc As %String, notes As %String) As %String
{
	s repeatId=$o(^DHCDocErrCodeRegisterI("ERRCODE",className,code,""))
	Q:(repeatId'="")&&(repeatId'=rowid) "repeat"
	k PLIST
	s PLIST(2)=className
	s PLIST(3)=code
	s PLIST(4)=desc
	s PLIST(5)=notes
 	&sql(update SQLUser.DHCDoc_ErrCodeRegister values :PLIST() where ECR_RowID=:rowid)
	Q SQLCODE
}

/*Query Find() As %SQLQuery(CONTAINID = 1, ROWSPEC = "TClassName:%String,TCode:%String,TDesc:%String,TNotes:%String,TRowID:%String")
{
SELECT ECR_ClassName,ECR_Code,ECR_Desc,ECR_Notes,ECR_RowID From SQLUser.DHCDoc_ErrCodeRegister
 order by ECR_ClassName
}*/
Query Find(clsName As %String, code As %String, desc As %String, notes As %String) As websys.Query(CONTAINID = 1, ROWSPEC = "TClassName:%String,TCode:%String,TDesc:%String,TNotes:%String,TRowID:%String")
{
}

ClassMethod FindExecute(ByRef qHandle As %Binary, clsName As %String, code As %String, desc As %String, notes As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	s clsName=$$ALPHAUP^SSUTIL4(clsName)
	//s code=$$ALPHAUP^SSUTIL4(code)
	s desc=$$ALPHAUP^SSUTIL4(desc)
	s notes=$$ALPHAUP^SSUTIL4(notes)
	s ECRRowID=0
	for {
		s ECRRowID=$O(^DHCDocErrCodeRegister(ECRRowID)) q:(ECRRowID="")
		s ECRClassName=$p(^DHCDocErrCodeRegister(ECRRowID),"^",1)
		continue:(clsName'="")&&(clsName'[$$ALPHAUP^SSUTIL4(ECRClassName))
		s ECRCode=$p(^DHCDocErrCodeRegister(ECRRowID),"^",2)
		continue:(code'="")&&(code'=ECRCode)
		s ECRDesc=$p(^DHCDocErrCodeRegister(ECRRowID),"^",3)
		continue:(desc'="")&&($$ALPHAUP^SSUTIL4(ECRDesc)'[desc)
		s ECRNotes=$p(^DHCDocErrCodeRegister(ECRRowID),"^",4)
		continue:(notes'="")&&($$ALPHAUP^SSUTIL4(ECRNotes)'[notes)
		d OutputRow2
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow2
	Set ^CacheTemp(repid,ind)=$LB(ECRClassName,ECRCode,ECRDesc,ECRNotes,ECRRowID)
	Set ind=ind+1
	quit
}

ClassMethod GetErrCodeMsg(className As %String, errCode As %String)
{
	Q:(className="")||(errCode="") ""
	Set langid=..%LanguageID()
	s ECRRowID=$o(^DHCDocErrCodeRegisterI("ERRCODE",className,errCode,""))
	if (ECRRowID'="") {
		s errDesc=$p($g(^DHCDocErrCodeRegister(ECRRowID)),"^",3)
		Set errDesc= ##class(User.DHCDocErrCodeRegister).GetTranByDesc("ECRDesc",errDesc,langid)
		Q errDesc
	}else{
		//自动插入记录
		d ..insertErrCode(className,errCode,"","")
		Q ""
	}
}

}
