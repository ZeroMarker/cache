Import sqluser

Class web.DHCST.PublicBidding Extends %RegisteredObject [ Not ProcedureBlock ]
{

Parameter AppTable [ Final ] = "DHC_PublicBiddingList";

/// 获取招标名称
/// w ##class(web.DHCST.PublicBidding).GetPublicBidding(0,30,"")
ClassMethod GetPublicBidding(Start, Limit, Name, HospId = "") As %Library.String
{
	n (Start,Limit,Name,HospId)
	s $zt="ErrorGetPublicBidding"
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "Select DHCPBL_Rowid As RowID,DHCPBL_Code As Code,DHCPBL_Desc As Name,DHCPBL_Tenderee As Tenderee,DHCPBL_Date As PBLDate,DHCPBL_EfficDateFrom As EfficDateFrom,DHCPBL_EfficDateTo As EfficDateTo,DHCPBL_Type As Type,DHCPBL_Remark As Remark,DHCPBL_ActiveFlag As ActiveFlag,DHCPBL_Level As PBLLevel From DHC_PublicBiddingList"
	d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	s resultString = ""
	s end = Start+Limit
	s json = ##class(Code.JsonObj).%New()
	While(result.Next())
	{
		s Rowid = result.Data("RowID")
		s Code = result.Data("Code")
		s Desc = result.Data("Name")
		continue:(Name'="")&('$f(Desc,Name))		
        s flag =##class(PHA.FACE.IN.Com).GetShowDataFlag(..#AppTable,Rowid,HospId) //医院级别授权
        continue:flag="N"
		s Tenderee = result.Data("Tenderee")
		s Date = result.Data("PBLDate")
		s EfficDateFrom =result.Data("EfficDateFrom")
		s EfficDateTo = result.Data("EfficDateTo")
		s Date=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(Date,"ST")
	    s EfficDateFrom=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(EfficDateFrom,"ST")
	    s EfficDateTo=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(EfficDateTo,"ST")
		s Type =result.Data("Type")
		continue:(Type'="G")&&(Type'="")
		s Remark = result.Data("Remark")
		s ActiveFlag = result.Data("ActiveFlag")
		s Level = result.Data("PBLLevel")
		s tmp=Rowid_"^"_Code_"^"_Desc_"^"_Tenderee_"^"_Date_"^"_EfficDateFrom_"^"_EfficDateTo_"^"_Type_"^"_Remark_"^"_ActiveFlag_"^"_Level
		s count = count+1
		i (count>Start)&(count<=end) d
		.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("RowID^Code^Desc^Tenderee^Date^EfficDateFrom^EfficDateTo^Type^Remark^ActiveFlag^Level",count)
	k json
	Q resultString
ErrorGetPublicBidding
	s Error=$$Error^DHCSTERROR()
	q "{Error:'"_Error_"'}"
}

/// 保存招标名称
/// w ##class(web.DHCST.PublicBidding).SavePublicBidding("^BJZB^XXX^北京^^2022-07-11^^^^^",2)
ClassMethod SavePublicBidding(ListData, HospId = "")
{
	N (ListData,HospId,%session)
	s $zt="Error^DHCSTERROR"
	//s ^PHATMP("MYQ", $this, "SavePublicBidding") = $lb(ListData, HospId)
	s errInfo=""
	S Len=$L(ListData,"#")
	S flag=0
	TS
	F i=1:1:Len  Q:+errInfo'=0  d
	.S mdata=$p(ListData,"#",i)
	.S RowID=$p(mdata,"^",1)
	.S Code=$p(mdata,"^",2)
	.S Desc=$p(mdata,"^",3)
	.S Tenderee=$p(mdata,"^",4)
	.S Date=$p(mdata,"^",5)
	.S EfficDateFrom=$p(mdata,"^",6)
	.S EfficDateTo=$p(mdata,"^",7)
	.S Date=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(Date)
	.S EfficDateFrom=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EfficDateFrom)
	.S EfficDateTo=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EfficDateTo)
	.S Type="G"
	.S Remark=$p(mdata,"^",9)
	.S ActiveFlag=$p(mdata,"^",10)
	.S Level=$p(mdata,"^",11)
	.s chkCodeId=..CheckPBCode(Code,RowID,HospId)
	.s chkDescId=..CheckPBDesc(Desc,RowID,HospId)
	.i (chkCodeId>0)||(chkDescId>0) d
	..i (chkCodeId>0)&&(RowID="") s errInfo="-1^"_Code_",代码重复"
	..i (chkDescId>0)&&(RowID="") s errInfo="-1^"_Desc_",名称重复"
	..i (chkCodeId>0)&&(RowID'="")&&(chkCodeId'=RowID) s errInfo="-1^"_Code_",代码重复"
	..i (chkDescId>0)&&(RowID'="")&&(chkDescId'=RowID) s errInfo="-1^"_Desc_",名称重复"
	.q:+errInfo<0
	.If RowID="" D
	..S flag=..InsertPublicBidding(Code,Desc,Tenderee,Date,EfficDateFrom,EfficDateTo,Type,Remark,ActiveFlag,Level,HospId)
	..i flag'=0 s errInfo="-1^插入招标名称记录失败,错误代码:"_flag
	.Else  D
	..S flag=..UpdPublicBidding(RowID,Code,Desc,Tenderee,Date,EfficDateFrom,EfficDateTo,Type,Remark,ActiveFlag,Level) 
	..i flag'=0 s errInfo="-1^更新招标名称记录失败,错误代码:"_flag
	If +errInfo'=0  TRO
	Q:+errInfo'=0 errInfo
 	TC
 	Q 0
}

ClassMethod InsertPublicBidding(Code, Desc, Tenderee, Date, EfficDateFrom, EfficDateTo, Type, Remark, ActiveFlag, Level, HospId = "") As %String
{
	N (Code,Desc,Tenderee,Date,EfficDateFrom,EfficDateTo,Type,Remark,ActiveFlag,Level,HospId)
	k PLIST
	S PLIST(2)=Code
	S PLIST(3)=Desc
	S PLIST(4)=Tenderee
	S PLIST(5)=Date
	S PLIST(6)=EfficDateFrom
	S PLIST(7)=EfficDateTo
	S PLIST(8)=Type
	S PLIST(9)=Remark
	S PLIST(10)=ActiveFlag
	S PLIST(11)=Level
	&SQL(Insert Into DHC_PublicBiddingList values :PLIST())
	i SQLCODE'=0 d
    .s rett=$$ErrorRecord^DHCSTERROR("InsertPublicBidding","",SQLCODE_":"_%msg)
    e  d
    .s Rowid=$p(%ROWID,$c(1))
    .d ##class(PHA.FACE.IN.Com).SaveBasicDataHosp(..#AppTable,Rowid,HospId)
	Q SQLCODE
}

ClassMethod UpdPublicBidding(RowID, Code, Desc, Tenderee, Date, EfficDateFrom, EfficDateTo, Type, Remark, ActiveFlag, Level) As %String
{
	N (RowID,Code,Desc,Tenderee,Date,EfficDateFrom,EfficDateTo,Type,Remark,ActiveFlag,Level)
	k PLIST
	S PLIST(2)=Code
	S PLIST(3)=Desc
	S PLIST(4)=Tenderee
	S PLIST(5)=Date
	S PLIST(6)=EfficDateFrom
	S PLIST(7)=EfficDateTo
	S PLIST(8)=Type
	S PLIST(9)=Remark
	S PLIST(10)=ActiveFlag
	S PLIST(11)=Level
	&SQL(Update DHC_PublicBiddingList values :PLIST() where DHCPBL_Rowid=:RowID )	
	i SQLCODE'=0 d
    .s rett=$$ErrorRecord^DHCSTERROR("UpdPublicBidding","",SQLCODE_":"_%msg)
	Q SQLCODE
}

/// /w ##class(web.DHCST.PublicBidding).DelPublicBidding(15,2)
ClassMethod DelPublicBidding(RowID, HospId = "") As %String
{
	N (RowID, HospId)
	&SQL(Delete DHC_PublicBiddingList where DHCPBL_Rowid=:RowID )
	i SQLCODE=0 d
    .d ##class(PHA.FACE.IN.Com).DeleteBasicDataHosp("DHC_MarkRule",RowID,HospId)
	Q SQLCODE
}

/// w ##class(web.DHCST.PublicBidding).CheckPBCode("BJZB", "2")
ClassMethod CheckPBCode(code, PBRowID, HospId = "")
{
	n (code,PBRowID,HospId,%session)
	s RetRowID=""
	//s code=$$ALPHAUP^SSUTIL4(code) //^DHCITMPBL(0,"Code",code,Rowid)
	s BDPHospAut=##class(PHA.FACE.IN.Com).GetHospAut() //医院级别授权
    s Rowid=0
	f  s Rowid=$o(^DHCPBLIST(0,"TYPE","G",Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	.s flag="Y"
	.s pbCode = $p(^DHCPBLIST(Rowid), "^", 1)
	.q:(code '= pbCode)
	.q:(code = pbCode)&&(PBRowID '= "")&&(PBRowID = Rowid)
	.i BDPHospAut="Y" d
	..i HospId="" s flag="N",RetRowID="-1^入参HospId为空"
	..e  s flag =##class(PHA.FACE.IN.Com).GetShowDataFlag(..#AppTable,Rowid,HospId) //医院级别授权
	.q:flag="N"
	.s RetRowID=Rowid
	q $g(RetRowID)
}

ClassMethod CheckPBDesc(desc, PBRowID, HospId = "")
{
	n (desc,PBRowID,HospId,%session)
	s RetRowID=""
	//s desc=$$ALPHAUP^SSUTIL4(desc) //^DHCITMPBL(0,"Desc",desc,Rowid)
	s BDPHospAut=##class(PHA.FACE.IN.Com).GetHospAut() //医院级别授权
    s Rowid=0
	f  s Rowid=$o(^DHCPBLIST(0,"TYPE","G",Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	.s flag="Y"
	.s pbDesc = $p(^DHCPBLIST(Rowid), "^", 2)
	.q:(desc '= pbDesc)
	.q:((desc = pbDesc)&&(PBRowID '= "")&&(PBRowID = Rowid))
	.i BDPHospAut="Y" d
	..i HospId="" s flag="N",RetRowID="-1^入参HospId为空"
	..e  s flag =##class(PHA.FACE.IN.Com).GetShowDataFlag(..#AppTable,Rowid,HospId) //医院级别授权
	.q:flag="N"
	.s RetRowID=Rowid
	q $g(RetRowID)
}

/// w ##class(web.DHCST.PublicBidding).CheckCode("BJZB", "2")
ClassMethod CheckCode(code, HospId = "")
{
	n (code,HospId,%session)
	s RetRowID=""
	s code=$$ALPHAUP^SSUTIL4(code) //^DHCITMPBL(0,"Code",code,Rowid)
	s BDPHospAut=##class(PHA.FACE.IN.Com).GetHospAut() //医院级别授权
    s Rowid=0
	f  s Rowid=$o(^DHCITMPBL(0,"Code",code,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	.s flag="Y"
	.i BDPHospAut="Y" d
	..i HospId="" s flag="N",RetRowID="-1^入参HospId为空"
	..e  s flag =##class(PHA.FACE.IN.Com).GetShowDataFlag(..#AppTable,Rowid,HospId) //医院级别授权
	.q:flag="N"
	.s RetRowID=Rowid
	q $g(RetRowID)
}

ClassMethod CheckDesc(desc, HospId = "")
{
	n (desc,HospId,%session)
	s RetRowID=""
	s desc=$$ALPHAUP^SSUTIL4(desc) //^DHCITMPBL(0,"Desc",desc,Rowid)
	s BDPHospAut=##class(PHA.FACE.IN.Com).GetHospAut() //医院级别授权
    s Rowid=0
	f  s Rowid=$o(^DHCITMPBL(0,"Desc",desc,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	.s flag="Y"
	.i BDPHospAut="Y" d
	..i HospId="" s flag="N",RetRowID="-1^入参HospId为空"
	..e  s flag =##class(PHA.FACE.IN.Com).GetShowDataFlag(..#AppTable,Rowid,HospId) //医院级别授权
	.q:flag="N"
	.s RetRowID=Rowid
	q $g(RetRowID)
}

}
