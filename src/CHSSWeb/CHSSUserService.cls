Class CHSSWeb.CHSSUserService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

//计算总用户数

ClassMethod ListNum(HosDr) As %String
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select count(*) as num from SS_User where SSUSR_Hospital_DR="_HosDr_""
	
	d result.Prepare(sqlStr)
	d result.Execute()
	s rowcount=""
	s resultString = ""

	While(result.Next()){
	s rowcount=result.Data("num")
		}
    d result.Close()
	q rowcount
}

//根据机构查找出 HospitalDR

ClassMethod searchDr(CommunityCode)
{
}

//列出所有用户

ClassMethod list(Start, Limit, CommunityCode)
{
    Set start=$G(Start)
	Set limit=$G(Limit)
	Set count=0
	Set resultString = ""
	Set end = start+limit
	Set json = ##class(Code.JsonObj).%New()
	s result = ##class(%Library.ResultSet).%New()
	s HosDr=""
	&sql(select HospitalDR into HosDr from  CHSS.DictHospital where CommunityCode = :CommunityCode )
	
	s sqlStr = "select SSUSR_Rowid as rowid from SS_User where SSUSR_Hospital_DR="_HosDr_""
    
    s rowcount=..ListNum(HosDr)
	d result.Prepare(sqlStr)
	d result.Execute()
	q:(result="") "[]"
	s resultString = ""
	s json = ##class(Code.JsonObj).%New()
	While(result.Next())
	{
	s Rowid = result.Data("rowid")
	s tempChild = ##class(User.SSUser).%OpenId(Rowid)
	
	s SSUSRInitials =tempChild.SSUSRInitials
	s SSUSRName =tempChild.SSUSRName
	s SSUSRPassword=tempChild.SSUSRPassword
	
	s SSUSRGroup=""
	s SSUSRGroupName=""
	i tempChild.SSUSRGroup'="" d
	.s SSUSRGroup=tempChild.SSUSRGroup.%Id()
	.s SSUSRGroupName=tempChild.SSUSRGroup.SSGRPDesc
	
	s SSUSRHospitalDR=""
	S SSUSRHospitalName=""
	i tempChild.SSUSRHospitalDR'="" d
	.s SSUSRHospitalDR=tempChild.SSUSRHospitalDR.%Id()
	
	.S SSUSRHospitalName=tempChild.SSUSRHospitalDR.HOSPDesc
	
	
	
	S SSUSRDefaultDeptDR=""
	s SSUSRDefaultDeptName=""
	i tempChild.SSUSRDefaultDeptDR'="" d
	.s SSUSRDefaultDeptDR=tempChild.SSUSRDefaultDeptDR.%Id()
	.s SSUSRDefaultDeptName=tempChild.SSUSRDefaultDeptDR.CTLOCDesc
	
	i tempChild.SSUSRActive="Y" d
	.S SSUSRActive="true"
	e  d
	.s SSUSRActive="false"
	s tmp=""
	s tmp=Rowid_"^"_SSUSRInitials_"^"_SSUSRName_"^"_SSUSRPassword_"^"_SSUSRGroup_"^"_SSUSRGroupName_"^"_SSUSRHospitalDR_"^"_SSUSRHospitalName_"^"_SSUSRDefaultDeptDR_"^"_SSUSRDefaultDeptName_"^"_SSUSRActive
	s count=count+1
	i (count>start)&(count<=end) d
    .d json.InsertRowData(tmp)
   
    q:(end<count)
	}
	s resultString = json.getJsonData("Rowid^SSUSRInitials^SSUSRName^SSUSRPassword^SSUSRGroup^SSUSRGroupName^SSUSRHospitalDR^SSUSRHospitalName^SSUSRDefaultDeptDR^SSUSRDefaultDeptName^SSUSRActive",rowcount)
	k json	
	Quit resultString
}

ClassMethod search(Start, Limit, userid, CommunityCode)
{
	 Set start=$G(Start)
	Set limit=$G(Limit)
	Set count=0
	Set resultString = ""
	Set end = start+limit
	s HosDr=""
	&sql(select HospitalDR into HosDr from  CHSS.DictHospital where CommunityCode = :CommunityCode )
	
	Set json = ##class(Code.JsonObj).%New()
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select SSUSR_Rowid as rowid from SS_User where SSUSR_Initials like '%"_userid_"%' and SSUSR_Hospital_DR="_HosDr_""

	d result.Prepare(sqlStr)
	d result.Execute()
	q:(result="") "[]"
	s resultString = ""
	s json = ##class(Code.JsonObj).%New()
	While(result.Next())
	{
	s Rowid = result.Data("rowid")
	s tempChild = ##class(User.SSUser).%OpenId(Rowid)
	
	s SSUSRInitials =tempChild.SSUSRInitials
	s SSUSRName =tempChild.SSUSRName
	s SSUSRPassword=tempChild.SSUSRPassword
	
	s SSUSRGroup=""
	s SSUSRGroupName=""
	i tempChild.SSUSRGroup'="" d
	.s SSUSRGroup=tempChild.SSUSRGroup.%Id()
	.s SSUSRGroupName=tempChild.SSUSRGroup.SSGRPDesc
	
	s SSUSRHospitalDR=""
	s SSUSRHospitalName=""
	i tempChild.SSUSRHospitalDR'="" d
	.s SSUSRHospitalDR=tempChild.SSUSRHospitalDR.%Id()
	.S SSUSRHospitalName=tempChild.SSUSRHospitalDR.HOSPDesc
	
	
	S SSUSRDefaultDeptDR=""
	s SSUSRDefaultDeptName=""
	i tempChild.SSUSRDefaultDeptDR'="" d
	.s SSUSRDefaultDeptDR=tempChild.SSUSRDefaultDeptDR.%Id()
	.s SSUSRDefaultDeptName=tempChild.SSUSRDefaultDeptDR.CTLOCDesc
	
	i tempChild.SSUSRActive="Y" d
	.S SSUSRActive="true"
	e  d
	.s SSUSRActive="false"
	
	s tmp=""
	s tmp=Rowid_"^"_SSUSRInitials_"^"_SSUSRName_"^"_SSUSRPassword_"^"_SSUSRGroup_"^"_SSUSRGroupName_"^"_SSUSRHospitalDR_"^"_SSUSRHospitalName_"^"_SSUSRDefaultDeptDR_"^"_SSUSRDefaultDeptName_"^"_SSUSRActive
	s count=count+1
	i (count>start)&(count<=end) d
    .d json.InsertRowData(tmp)
	}
	s resultString = json.getJsonData("Rowid^SSUSRInitials^SSUSRName^SSUSRPassword^SSUSRGroup^SSUSRGroupName^SSUSRHospitalDR^SSUSRHospitalName^SSUSRDefaultDeptDR^SSUSRDefaultDeptName^SSUSRActive",count)
	k json	
	Quit resultString
}

ClassMethod insert(ssInitials, ssName, ssPassword, ssGroup, ssHosp, ssDepart, ssActive)
{
	s ctname=""
	s tempChild = ""
	s tempChild =##class(User.SSUser).%New()
	
	
	s tempChild.SSUSRInitials=ssInitials
	s tempChild.SSUSRName=ssName
	s tempChild.SSUSRPassword="U&dDF1,""7k7k"
	s tempChild.SSUSRPin="U&dDF1,""7k7k"
	s tempChild.SSUSRPasswordChanged="N"
	
	i ssGroup'="" d
	.s ssGroupObject=##class(User.SSGroup).%OpenId(ssGroup)
    .s tempChild.SSUSRGroup=ssGroupObject
    
    i ssHosp'="" d
    .s ssHospObj=##class(User.CTHospital).%OpenId(ssHosp)
    .s tempChild.SSUSRHospitalDR=ssHospObj
    .s ctname=ssHospObj.HOSPDesc
    
    &sql(select ctloc_rowid into:ctid from sqluser.CT_Loc where ctloc_desc=:ctname)
	;s OperateDate=$zdh(OperateDate,3)
	;s tempChild.OperateDate=OperateDate
    ;SSUSR_PasswordDate
    
    
   
    s ssDepartObj=##class(User.CTLoc).%OpenId(ctid)
    s tempChild.SSUSRDefaultDeptDR=ssDepartObj

    s tempChild.SSUSRActive="Y"
     s result=""
    s result=tempChild.%Save()
    Set resultString = ""
    i result = "1" d
    .s resultString = "{""success"":""true"",""info"":"_tempChild.%Id()_"}"
    e  d
    .s resultString = "{""success"":""false"",""info"":""用户名已存在抑或其他原因!""}"
    q resultString
}

ClassMethod edit(rowid, ssInitials, ssName, ssPassword, ssGroup, ssHosp, ssDepart, ssActive)
{
	s ctname=""
	s tempChild = ""
	i rowid'="" d
	.s tempChild =##class(User.SSUser).%OpenId(rowid)
	
	
	s tempChild.SSUSRInitials=ssInitials
	s tempChild.SSUSRName=ssName
	s tempChild.SSUSRPasswordChanged="N"
	
	i ssGroup'="" d
	.s ssGroupObject=##class(User.SSGroup).%OpenId(ssGroup)
    .s tempChild.SSUSRGroup=ssGroupObject
    
    i ssHosp'="" d
    .s ssHospObj=##class(User.CTHospital).%OpenId(ssHosp)
    .s tempChild.SSUSRHospitalDR=ssHospObj
    .s ctname=ssHospObj.HOSPDesc
    
    &sql(select ctloc_rowid into:ctid from sqluser.CT_Loc where ctloc_desc=:ctname)
	
	;s OperateDate=$zdh(OperateDate,3)
	;s tempChild.OperateDate=OperateDate
    ;SSUSR_PasswordDate
    
    
   ; i ssDepart'="" d
    s ssDepartObj=##class(User.CTLoc).%OpenId(ctid)
    s tempChild.SSUSRDefaultDeptDR=ssDepartObj

    s tempChild.SSUSRActive="Y"
     s result=""
    s result=tempChild.%Save()
    Set resultString = ""
    i result = "1" d
    .s resultString = "{""success"":""true"",""info"":"_tempChild.%Id()_"}"
    e  d
    .s resultString = "{""success"":""false"",""info"":""用户名已存在抑或其他原因!""}"
    q resultString
}

Storage Default
{
<Data name="CHSSUserServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.CHSSUserServiceD</DataLocation>
<DefaultData>CHSSUserServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.CHSSUserServiceD</IdLocation>
<IndexLocation>^CHSSWeb.CHSSUserServiceI</IndexLocation>
<StreamLocation>^CHSSWeb.CHSSUserServiceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
