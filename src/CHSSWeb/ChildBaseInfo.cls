Class CHSSWeb.ChildBaseInfo Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

//归档列表

ClassMethod ListFinish(CommunityCode, Start, Limit)
{
	Set CommunityCode=$G(CommunityCode)

	Set start=$G(Start)
	Set limit=$G(Limit)
	Set count=0
	Set resultString = ""
	Set end = start+limit
	Set json = ##class(Code.JsonObj).%New()
	set ChildRowId = 0
	
     s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select ChildRowId from CHSS.ChildBaseInfo where communitycode="_CommunityCode

	d result.Prepare(sqlStr)
	d result.Execute()
	q:(result="") "[]"
	s resultString = ""
	s json = ##class(Code.JsonObj).%New()
	While(result.Next())
	{
	
	s ChildRowId = result.Data("ChildRowId")
	s tempChild = ##class(CHSS.ChildBaseInfo).%OpenId(ChildRowId)
		
	s PersonRowId=""
	i tempChild.PersonRowId'="" d
	.s PersonRowId=tempChild.PersonRowId.%Id()
	
	s Name=tempChild.Name
	s HelpCode=tempChild.HelpCode
	
	s Sex=""
	s SexName=""
	i tempChild.Sex'="" d
	.s Sex=tempChild.Sex.%Id()
	s SexName=tempChild.Sex.CTSEXDesc
	s ChildHandBookCode=tempChild.ChildHandBookCode
	s BcCode=tempChild.BcCode
	s VaccinateHandbookCode=tempChild.VaccinateHandbookCode
	s PregHealthCode=tempChild.PregHealthCode
	s CopyDataRes=tempChild.CopyDataRes
	s CardCode=tempChild.CardCode
	s CardType=tempChild.CardType.Description
	
	s ChildBirth = tempChild.Birth
	i ChildBirth '= "" d
	.s ChildBirth = $zd(ChildBirth,3)
	
	s Weight=tempChild.Weight
	s HandbookAdd=tempChild.HandbookAdd
	s Address=tempChild.Address
	s PostCode=tempChild.PostCode
	s FatherName=tempChild.FatherName
	s FMobTele=tempChild.FMobTele
	s FatherTele=tempChild.FatherTele
	s FatherPH=tempChild.FatherPH
	s FatherAllergies=tempChild.FatherAllergies
	s MotherName=tempChild.MotherName
	s MMobTele=tempChild.MMobTele
	s MotherTele=tempChild.MotherTele
	s MotherPH=tempChild.MotherPH
	s MotherAllergies=tempChild.MotherAllergies
	s GestationalAge=tempChild.GestationalAge
	s RenalDiseases=tempChild.RenalDiseases
	s ChildBirthPlace=tempChild.BirthPlace
	s BirthSituation=tempChild.BirthSituation
	s FosterMother=tempChild.FosterMother

	s FosterMotherTele=tempChild.FosterMotherTele
	
	s MobTele=tempChild.MobTele
	s Email=tempChild.Email
	s bNeonScreen=tempChild.bNeonScreen
	s BornWeight=tempChild.BornWeight
	s BornHeight=tempChild.BornHeight
	s NetPassword=tempChild.NetPassword
	s InputUnit=tempChild.InputUnit
	s FinishTable=tempChild.FinishTable
	set OperatorName = ""
    set Operator = ""
    i tempChild.Operator '= "" d
    .s Operator = tempChild.Operator.%Id()
    .s OperatorName = tempChild.Operator.SSUSRName

	
	s OperateDate=tempChild.OperateDate
	i OperateDate'="" d
	.s OperateDate=$zd(OperateDate,3)
		
	s FillDate=tempChild.FillDate
	i FillDate'="" d
	.s FillDate=$zd(FillDate,3)
	
	s FinishTableName=tempChild.FinishTableName
	s InputUnitName=tempChild.InputUnitName
	s ChildDisease=tempChild.ChildDisease
	
	s FinishIdentifier=tempChild.FinishIdentifier
	i FinishIdentifier=1 d
	.s guidang="<font color=green><b>已归档</b></font>"
	else  d
	.s guidang="<font color=red><b>未归档</b></font>"
	s tmp=""
	s tmp=ChildRowId_"^"_PersonRowId_"^"_Name_"^"_HelpCode_"^"_Sex_"^"_SexName_"^"_ChildHandBookCode_"^"_BcCode_"^"_VaccinateHandbookCode_"^"_PregHealthCode_"^"_CopyDataRes_"^"_CardCode_"^"_CardType_"^"_ChildBirth_"^"_Weight_"^"_HandbookAdd_"^"_Address_"^"_PostCode_"^"_FatherName_"^"_FMobTele_"^"_FatherTele_"^"_FatherPH_"^"_FatherAllergies_"^"_MotherName_"^"_MMobTele_"^"_MotherTele_"^"_MotherPH_"^"_MotherAllergies_"^"_GestationalAge_"^"_RenalDiseases_"^"_ChildBirthPlace_"^"_BirthSituation_"^"_FosterMother_"^"_FosterMotherTele_"^"_MobTele_"^"_Email_"^"_bNeonScreen_"^"_BornWeight_"^"_BornHeight_"^"_NetPassword_"^"_InputUnit_"^"_FinishTable_"^"_Operator_"^"_OperateDate_"^"_FillDate_"^"_FinishTableName_"^"_InputUnitName_"^"_OperatorName_"^"_ChildDisease_"^"_guidang
	s count=count+1
	i (count>start)&(count<=end) d
    .d json.InsertRowData(tmp)
	}
	s resultString = json.getJsonData("ChildRowId^PersonRowId^Name^HelpCode^Sex^SexName^ChildHandBookCode^BcCode^VaccinateHandbookCode^PregHealthCode^CopyDataRes^CardCode^CardType^ChildBirth^Weight^HandbookAdd^ChildAddress^PostCode^ChildFatherName^FMobTele^FatherTele^FatherPH^FatherAllergies^ChildMotherName^MMobTele^MotherTele^MotherPH^MotherAllergies^GestationalAge^RenalDiseases^ChildBirthPlace^BirthSituation^FosterMother^FosterMotherTele^MobTele^Email^bNeonScreen^BornWeight^BornHeight^NetPassword^InputUnit^FinishTable^Operator^OperateDate^FillDate^FinishTableName^InputUnitName^OperatorName^ChildDisease^guidang",count)
	k json	
	Quit resultString
}

//按姓名检索归档数据

ClassMethod finishsearch(CommunityCode, serachname, Start, Limit)
{
	Set CommunityCode=$G(CommunityCode)
	Set serachname=$G(serachname)
	Set start=$G(Start)
	Set limit=$G(Limit)
	Set count=0
	Set resultString = ""
	Set end = start+limit
	Set json = ##class(Code.JsonObj).%New()
	set ChildRowId = 0
	
     s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select ChildRowId from CHSS.ChildBaseInfo where communitycode='"_CommunityCode_"' and name  like '%"_serachname_"%'"
	d result.Prepare(sqlStr)
	
	d result.Execute()
	q:(result="") "[]"
	s resultString = ""
	s json = ##class(Code.JsonObj).%New()
	While(result.Next())
	{
	
	s ChildRowId = result.Data("ChildRowId")
	s tempChild = ##class(CHSS.ChildBaseInfo).%OpenId(ChildRowId)
		
	s PersonRowId=""
	i tempChild.PersonRowId'="" d
	.s PersonRowId=tempChild.PersonRowId.%Id()
	
	s Name=tempChild.Name
	s HelpCode=tempChild.HelpCode
	
	s Sex=""
	s SexName=""
	i tempChild.Sex'="" d
	.s Sex=tempChild.Sex.%Id()
	s SexName=tempChild.Sex.CTSEXDesc
	s ChildHandBookCode=tempChild.ChildHandBookCode
	s BcCode=tempChild.BcCode
	s VaccinateHandbookCode=tempChild.VaccinateHandbookCode
	s PregHealthCode=tempChild.PregHealthCode
	s CopyDataRes=tempChild.CopyDataRes
	s CardCode=tempChild.CardCode
	s CardType=tempChild.CardType.Description
	
	s ChildBirth = tempChild.Birth
	i ChildBirth '= "" d
	.s ChildBirth = $zd(ChildBirth,3)
	
	s Weight=tempChild.Weight
	s HandbookAdd=tempChild.HandbookAdd
	s Address=tempChild.Address
	s PostCode=tempChild.PostCode
	s FatherName=tempChild.FatherName
	s FMobTele=tempChild.FMobTele
	s FatherTele=tempChild.FatherTele
	s FatherPH=tempChild.FatherPH
	s FatherAllergies=tempChild.FatherAllergies
	s MotherName=tempChild.MotherName
	s MMobTele=tempChild.MMobTele
	s MotherTele=tempChild.MotherTele
	s MotherPH=tempChild.MotherPH
	s MotherAllergies=tempChild.MotherAllergies
	s GestationalAge=tempChild.GestationalAge
	s RenalDiseases=tempChild.RenalDiseases
	s ChildBirthPlace=tempChild.BirthPlace
	s BirthSituation=tempChild.BirthSituation
	s FosterMother=tempChild.FosterMother

	s FosterMotherTele=tempChild.FosterMotherTele
	
	s MobTele=tempChild.MobTele
	s Email=tempChild.Email
	s bNeonScreen=tempChild.bNeonScreen
	s BornWeight=tempChild.BornWeight
	s BornHeight=tempChild.BornHeight
	s NetPassword=tempChild.NetPassword
	s InputUnit=tempChild.InputUnit
	s FinishTable=tempChild.FinishTable
	set OperatorName = ""
    set Operator = ""
    i tempChild.Operator '= "" d
    .s Operator = tempChild.Operator.%Id()
    .s OperatorName = tempChild.Operator.SSUSRName

	
	s OperateDate=tempChild.OperateDate
	i OperateDate'="" d
	.s OperateDate=$zd(OperateDate,3)
		
	s FillDate=tempChild.FillDate
	i FillDate'="" d
	.s FillDate=$zd(FillDate,3)
	
	s FinishTableName=tempChild.FinishTableName
	s InputUnitName=tempChild.InputUnitName
	s ChildDisease=tempChild.ChildDisease
	
	s FinishIdentifier=tempChild.FinishIdentifier
	i FinishIdentifier=1 d
	.s guidang="<font color=green><b>已归档</b></font>"
	else  d
	.s guidang="<font color=red><b>未归档</b></font>"
	s tmp=""
	s tmp=ChildRowId_"^"_PersonRowId_"^"_Name_"^"_HelpCode_"^"_Sex_"^"_SexName_"^"_ChildHandBookCode_"^"_BcCode_"^"_VaccinateHandbookCode_"^"_PregHealthCode_"^"_CopyDataRes_"^"_CardCode_"^"_CardType_"^"_ChildBirth_"^"_Weight_"^"_HandbookAdd_"^"_Address_"^"_PostCode_"^"_FatherName_"^"_FMobTele_"^"_FatherTele_"^"_FatherPH_"^"_FatherAllergies_"^"_MotherName_"^"_MMobTele_"^"_MotherTele_"^"_MotherPH_"^"_MotherAllergies_"^"_GestationalAge_"^"_RenalDiseases_"^"_ChildBirthPlace_"^"_BirthSituation_"^"_FosterMother_"^"_FosterMotherTele_"^"_MobTele_"^"_Email_"^"_bNeonScreen_"^"_BornWeight_"^"_BornHeight_"^"_NetPassword_"^"_InputUnit_"^"_FinishTable_"^"_Operator_"^"_OperateDate_"^"_FillDate_"^"_FinishTableName_"^"_InputUnitName_"^"_OperatorName_"^"_ChildDisease_"^"_guidang
	s count=count+1
	i (count>start)&(count<=end) d
    .d json.InsertRowData(tmp)
	}
	s resultString = json.getJsonData("ChildRowId^PersonRowId^Name^HelpCode^Sex^SexName^ChildHandBookCode^BcCode^VaccinateHandbookCode^PregHealthCode^CopyDataRes^CardCode^CardType^ChildBirth^Weight^HandbookAdd^ChildAddress^PostCode^ChildFatherName^FMobTele^FatherTele^FatherPH^FatherAllergies^ChildMotherName^MMobTele^MotherTele^MotherPH^MotherAllergies^GestationalAge^RenalDiseases^ChildBirthPlace^BirthSituation^FosterMother^FosterMotherTele^MobTele^Email^bNeonScreen^BornWeight^BornHeight^NetPassword^InputUnit^FinishTable^Operator^OperateDate^FillDate^FinishTableName^InputUnitName^OperatorName^ChildDisease^guidang",count)
	k json	
	Quit resultString
}

//检索

ClassMethod ListSearch(sql, Start, Limit)
{
	Set CommunityCode=$G(CommunityCode)

	Set start=$G(Start)
	Set limit=$G(Limit)
	Set count=0
	Set resultString = ""
	Set end = start+limit
	Set json = ##class(Code.JsonObj).%New()
	set ChildRowId = 0
	
     s result = ##class(%Library.ResultSet).%New()
	s sqlStr = sql_"and FinishIdentifier is null"
	d result.Prepare(sqlStr)
	d result.Execute()
	q:(result="") "[]"
	s resultString = ""
	s json = ##class(Code.JsonObj).%New()
	While(result.Next())
	{
	
	s ChildRowId = result.Data("ChildRowId")
	s tempChild = ##class(CHSS.ChildBaseInfo).%OpenId(ChildRowId)
		
	s PersonRowId=""
	i tempChild.PersonRowId'="" d
	.s PersonRowId=tempChild.PersonRowId.%Id()
	
	s Name=tempChild.Name
	s HelpCode=tempChild.HelpCode
	
	s Sex=""
	s SexName=""
	i tempChild.Sex'="" d
	.s Sex=tempChild.Sex.%Id()
	s SexName=tempChild.Sex.CTSEXDesc
	s ChildHandBookCode=tempChild.ChildHandBookCode
	s BcCode=tempChild.BcCode
	s VaccinateHandbookCode=tempChild.VaccinateHandbookCode
	s PregHealthCode=tempChild.PregHealthCode
	s CopyDataRes=tempChild.CopyDataRes
	s CardCode=tempChild.CardCode
	s CardType=tempChild.CardType.Description
	
	s ChildBirth = tempChild.Birth
	i ChildBirth '= "" d
	.s ChildBirth = $zd(ChildBirth,3)
	
	s Weight=tempChild.Weight
	s HandbookAdd=tempChild.HandbookAdd
	s Address=tempChild.Address
	s PostCode=tempChild.PostCode
	s FatherName=tempChild.FatherName
	s FMobTele=tempChild.FMobTele
	s FatherTele=tempChild.FatherTele
	s FatherPH=tempChild.FatherPH
	s FatherAllergies=tempChild.FatherAllergies
	s MotherName=tempChild.MotherName
	s MMobTele=tempChild.MMobTele
	s MotherTele=tempChild.MotherTele
	s MotherPH=tempChild.MotherPH
	s MotherAllergies=tempChild.MotherAllergies
	s GestationalAge=tempChild.GestationalAge
	s RenalDiseases=tempChild.RenalDiseases
	s ChildBirthPlace=tempChild.BirthPlace
	s BirthSituation=tempChild.BirthSituation
	s FosterMother=tempChild.FosterMother

	s FosterMotherTele=tempChild.FosterMotherTele
	
	s MobTele=tempChild.MobTele
	s Email=tempChild.Email
	s bNeonScreen=tempChild.bNeonScreen
	s BornWeight=tempChild.BornWeight
	s BornHeight=tempChild.BornHeight
	s NetPassword=tempChild.NetPassword
	s InputUnit=tempChild.InputUnit
	s FinishTable=tempChild.FinishTable
	set OperatorName = ""
    set Operator = ""
    i tempChild.Operator '= "" d
    .s Operator = tempChild.Operator.%Id()
    .s OperatorName = tempChild.Operator.SSUSRName

	
	s OperateDate=tempChild.OperateDate
	i OperateDate'="" d
	.s OperateDate=$zd(OperateDate,3)
		
	s FillDate=tempChild.FillDate
	i FillDate'="" d
	.s FillDate=$zd(FillDate,3)
	
	s FinishTableName=tempChild.FinishTableName
	s InputUnitName=tempChild.InputUnitName
	s ChildDisease=tempChild.ChildDisease
	
	s tmp=""
	s tmp=ChildRowId_"^"_PersonRowId_"^"_Name_"^"_HelpCode_"^"_Sex_"^"_SexName_"^"_ChildHandBookCode_"^"_BcCode_"^"_VaccinateHandbookCode_"^"_PregHealthCode_"^"_CopyDataRes_"^"_CardCode_"^"_CardType_"^"_ChildBirth_"^"_Weight_"^"_HandbookAdd_"^"_Address_"^"_PostCode_"^"_FatherName_"^"_FMobTele_"^"_FatherTele_"^"_FatherPH_"^"_FatherAllergies_"^"_MotherName_"^"_MMobTele_"^"_MotherTele_"^"_MotherPH_"^"_MotherAllergies_"^"_GestationalAge_"^"_RenalDiseases_"^"_ChildBirthPlace_"^"_BirthSituation_"^"_FosterMother_"^"_FosterMotherTele_"^"_MobTele_"^"_Email_"^"_bNeonScreen_"^"_BornWeight_"^"_BornHeight_"^"_NetPassword_"^"_InputUnit_"^"_FinishTable_"^"_Operator_"^"_OperateDate_"^"_FillDate_"^"_FinishTableName_"^"_InputUnitName_"^"_OperatorName_"^"_ChildDisease
	s count=count+1
	i (count>start)&(count<=end) d
    .d json.InsertRowData(tmp)
	}
	s resultString = json.getJsonData("ChildRowId^PersonRowId^Name^HelpCode^Sex^SexName^ChildHandBookCode^BcCode^VaccinateHandbookCode^PregHealthCode^CopyDataRes^CardCode^CardType^ChildBirth^Weight^HandbookAdd^ChildAddress^PostCode^ChildFatherName^FMobTele^FatherTele^FatherPH^FatherAllergies^ChildMotherName^MMobTele^MotherTele^MotherPH^MotherAllergies^GestationalAge^RenalDiseases^ChildBirthPlace^BirthSituation^FosterMother^FosterMotherTele^MobTele^Email^bNeonScreen^BornWeight^BornHeight^NetPassword^InputUnit^FinishTable^Operator^OperateDate^FillDate^FinishTableName^InputUnitName^OperatorName^ChildDisease",count)
	k json	
	Quit resultString
}

//根据儿童姓名检索

ClassMethod ChildNameSearch(name, Start, Limit, CommunityCode)
{
	Set CommunityCode=$G(CommunityCode)
    Set name=$G(name)
	Set start=$G(Start)
	Set limit=$G(Limit)
	Set count=0
	Set resultString = ""
	Set end = start+limit
	Set json = ##class(Code.JsonObj).%New()
	set ChildRowId = 0
	
     s result = ##class(%Library.ResultSet).%New()
	s sqlStr ="select * from chss.childbaseinfo where communitycode="_CommunityCode_" and name like '%"_name_"%' and FinishIdentifier is null"
	;w sqlStr,!
	d result.Prepare(sqlStr)
	d result.Execute()
	q:(result="") "[]"
	s resultString = ""
	s json = ##class(Code.JsonObj).%New()
	While(result.Next())
	{
	
	s ChildRowId = result.Data("ChildRowId")
	s tempChild = ##class(CHSS.ChildBaseInfo).%OpenId(ChildRowId)
		
	s PersonRowId=""
	i tempChild.PersonRowId'="" d
	.s PersonRowId=tempChild.PersonRowId.%Id()
	
	s Name=tempChild.Name
	s HelpCode=tempChild.HelpCode
	
	s Sex=""
	s SexName=""
	i tempChild.Sex'="" d
	.s Sex=tempChild.Sex.%Id()
	s SexName=tempChild.Sex.CTSEXDesc
	s ChildHandBookCode=tempChild.ChildHandBookCode
	s BcCode=tempChild.BcCode
	s VaccinateHandbookCode=tempChild.VaccinateHandbookCode
	s PregHealthCode=tempChild.PregHealthCode
	s CopyDataRes=tempChild.CopyDataRes
	s CardCode=tempChild.CardCode
	s CardType=tempChild.CardType.Description
	
	s ChildBirth = tempChild.Birth
	i ChildBirth '= "" d
	.s ChildBirth = $zd(ChildBirth,3)
	
	s Weight=tempChild.Weight
	s HandbookAdd=tempChild.HandbookAdd
	s Address=tempChild.Address
	s PostCode=tempChild.PostCode
	s FatherName=tempChild.FatherName
	s FMobTele=tempChild.FMobTele
	s FatherTele=tempChild.FatherTele
	s FatherPH=tempChild.FatherPH
	s FatherAllergies=tempChild.FatherAllergies
	s MotherName=tempChild.MotherName
	s MMobTele=tempChild.MMobTele
	s MotherTele=tempChild.MotherTele
	s MotherPH=tempChild.MotherPH
	s MotherAllergies=tempChild.MotherAllergies
	s GestationalAge=tempChild.GestationalAge
	s RenalDiseases=tempChild.RenalDiseases
	s ChildBirthPlace=tempChild.BirthPlace
	s BirthSituation=tempChild.BirthSituation
	s FosterMother=tempChild.FosterMother

	s FosterMotherTele=tempChild.FosterMotherTele
	
	s MobTele=tempChild.MobTele
	s Email=tempChild.Email
	s bNeonScreen=tempChild.bNeonScreen
	s BornWeight=tempChild.BornWeight
	s BornHeight=tempChild.BornHeight
	s NetPassword=tempChild.NetPassword
	s InputUnit=tempChild.InputUnit
	s FinishTable=tempChild.FinishTable
	set OperatorName = ""
    set Operator = ""
    i tempChild.Operator '= "" d
    .s Operator = tempChild.Operator.%Id()
    .s OperatorName = tempChild.Operator.SSUSRName

	
	s OperateDate=tempChild.OperateDate
	i OperateDate'="" d
	.s OperateDate=$zd(OperateDate,3)
		
	s FillDate=tempChild.FillDate
	i FillDate'="" d
	.s FillDate=$zd(FillDate,3)
	
	s FinishTableName=tempChild.FinishTableName
	s InputUnitName=tempChild.InputUnitName
	s ChildDisease=tempChild.ChildDisease
	
	s tmp=""
	s tmp=ChildRowId_"^"_PersonRowId_"^"_Name_"^"_HelpCode_"^"_Sex_"^"_SexName_"^"_ChildHandBookCode_"^"_BcCode_"^"_VaccinateHandbookCode_"^"_PregHealthCode_"^"_CopyDataRes_"^"_CardCode_"^"_CardType_"^"_ChildBirth_"^"_Weight_"^"_HandbookAdd_"^"_Address_"^"_PostCode_"^"_FatherName_"^"_FMobTele_"^"_FatherTele_"^"_FatherPH_"^"_FatherAllergies_"^"_MotherName_"^"_MMobTele_"^"_MotherTele_"^"_MotherPH_"^"_MotherAllergies_"^"_GestationalAge_"^"_RenalDiseases_"^"_ChildBirthPlace_"^"_BirthSituation_"^"_FosterMother_"^"_FosterMotherTele_"^"_MobTele_"^"_Email_"^"_bNeonScreen_"^"_BornWeight_"^"_BornHeight_"^"_NetPassword_"^"_InputUnit_"^"_FinishTable_"^"_Operator_"^"_OperateDate_"^"_FillDate_"^"_FinishTableName_"^"_InputUnitName_"^"_OperatorName_"^"_ChildDisease
	s count=count+1
	i (count>start)&(count<=end) d
    .d json.InsertRowData(tmp)
	}
	s resultString = json.getJsonData("ChildRowId^PersonRowId^Name^HelpCode^Sex^SexName^ChildHandBookCode^BcCode^VaccinateHandbookCode^PregHealthCode^CopyDataRes^CardCode^CardType^ChildBirth^Weight^HandbookAdd^ChildAddress^PostCode^ChildFatherName^FMobTele^FatherTele^FatherPH^FatherAllergies^ChildMotherName^MMobTele^MotherTele^MotherPH^MotherAllergies^GestationalAge^RenalDiseases^ChildBirthPlace^BirthSituation^FosterMother^FosterMotherTele^MobTele^Email^bNeonScreen^BornWeight^BornHeight^NetPassword^InputUnit^FinishTable^Operator^OperateDate^FillDate^FinishTableName^InputUnitName^OperatorName^ChildDisease",count)
	k json	
	Quit resultString
}

ClassMethod List(CommunityCode, Start, Limit)
{
	Set CommunityCode=$G(CommunityCode)

	Set start=$G(Start)
	Set limit=$G(Limit)
	Set count=0
	Set resultString = ""
	Set end = start+limit
	Set json = ##class(Code.JsonObj).%New()
	set ChildRowId = 0
	
     s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select ChildRowId from CHSS.ChildBaseInfo where communitycode="_CommunityCode_" and FinishIdentifier is null"
	d result.Prepare(sqlStr)
	d result.Execute()
	q:(result="") "[]"
	s resultString = ""
	s json = ##class(Code.JsonObj).%New()
	While(result.Next())
	{
	
	s ChildRowId = result.Data("ChildRowId")
	s tempChild = ##class(CHSS.ChildBaseInfo).%OpenId(ChildRowId)
		
	s PersonRowId=""
	i tempChild.PersonRowId'="" d
	.s PersonRowId=tempChild.PersonRowId.%Id()
	
	s Name=tempChild.Name
	s HelpCode=tempChild.HelpCode
	
	s Sex=""
	s SexName=""
	i tempChild.Sex'="" d
	.s Sex=tempChild.Sex.%Id()
	s SexName=tempChild.Sex.CTSEXDesc
	s ChildHandBookCode=tempChild.ChildHandBookCode
	s BcCode=tempChild.BcCode
	s VaccinateHandbookCode=tempChild.VaccinateHandbookCode
	s PregHealthCode=tempChild.PregHealthCode
	s CopyDataRes=tempChild.CopyDataRes
	s CardCode=tempChild.CardCode
	s CardType=tempChild.CardType.Description
	
	s ChildBirth = tempChild.Birth
	i ChildBirth '= "" d
	.s ChildBirth = $zd(ChildBirth,3)
	
	s Weight=tempChild.Weight
	s HandbookAdd=tempChild.HandbookAdd
	s Address=tempChild.Address
	s PostCode=tempChild.PostCode
	s FatherName=tempChild.FatherName
	s FMobTele=tempChild.FMobTele
	s FatherTele=tempChild.FatherTele
	s FatherPH=tempChild.FatherPH
	s FatherAllergies=tempChild.FatherAllergies
	s MotherName=tempChild.MotherName
	s MMobTele=tempChild.MMobTele
	s MotherTele=tempChild.MotherTele
	s MotherPH=tempChild.MotherPH
	s MotherAllergies=tempChild.MotherAllergies
	s GestationalAge=tempChild.GestationalAge
	s RenalDiseases=tempChild.RenalDiseases
	s ChildBirthPlace=tempChild.BirthPlace
	s BirthSituation=tempChild.BirthSituation
	s FosterMother=tempChild.FosterMother

	s FosterMotherTele=tempChild.FosterMotherTele
	
	s MobTele=tempChild.MobTele
	s Email=tempChild.Email
	s bNeonScreen=tempChild.bNeonScreen
	s BornWeight=tempChild.BornWeight
	s BornHeight=tempChild.BornHeight
	s NetPassword=tempChild.NetPassword
	s InputUnit=tempChild.InputUnit
	s FinishTable=tempChild.FinishTable
	set OperatorName = ""
    set Operator = ""
    i tempChild.Operator '= "" d
    .s Operator = tempChild.Operator.%Id()
    .s OperatorName = tempChild.Operator.SSUSRName

	
	s OperateDate=tempChild.OperateDate
	i OperateDate'="" d
	.s OperateDate=$zd(OperateDate,3)
		
	s FillDate=tempChild.FillDate
	i FillDate'="" d
	.s FillDate=$zd(FillDate,3)
	
	s FinishTableName=tempChild.FinishTableName
	s InputUnitName=tempChild.InputUnitName
	s ChildDisease=tempChild.ChildDisease
	
	s tmp=""
	s tmp=ChildRowId_"^"_PersonRowId_"^"_Name_"^"_HelpCode_"^"_Sex_"^"_SexName_"^"_ChildHandBookCode_"^"_BcCode_"^"_VaccinateHandbookCode_"^"_PregHealthCode_"^"_CopyDataRes_"^"_CardCode_"^"_CardType_"^"_ChildBirth_"^"_Weight_"^"_HandbookAdd_"^"_Address_"^"_PostCode_"^"_FatherName_"^"_FMobTele_"^"_FatherTele_"^"_FatherPH_"^"_FatherAllergies_"^"_MotherName_"^"_MMobTele_"^"_MotherTele_"^"_MotherPH_"^"_MotherAllergies_"^"_GestationalAge_"^"_RenalDiseases_"^"_ChildBirthPlace_"^"_BirthSituation_"^"_FosterMother_"^"_FosterMotherTele_"^"_MobTele_"^"_Email_"^"_bNeonScreen_"^"_BornWeight_"^"_BornHeight_"^"_NetPassword_"^"_InputUnit_"^"_FinishTable_"^"_Operator_"^"_OperateDate_"^"_FillDate_"^"_FinishTableName_"^"_InputUnitName_"^"_OperatorName_"^"_ChildDisease
	s count=count+1
	i (count>start)&(count<=end) d
    .d json.InsertRowData(tmp)
	}
	s resultString = json.getJsonData("ChildRowId^PersonRowId^Name^HelpCode^Sex^SexName^ChildHandBookCode^BcCode^VaccinateHandbookCode^PregHealthCode^CopyDataRes^CardCode^CardType^ChildBirth^Weight^HandbookAdd^ChildAddress^PostCode^ChildFatherName^FMobTele^FatherTele^FatherPH^FatherAllergies^ChildMotherName^MMobTele^MotherTele^MotherPH^MotherAllergies^GestationalAge^RenalDiseases^ChildBirthPlace^BirthSituation^FosterMother^FosterMotherTele^MobTele^Email^bNeonScreen^BornWeight^BornHeight^NetPassword^InputUnit^FinishTable^Operator^OperateDate^FillDate^FinishTableName^InputUnitName^OperatorName^ChildDisease",count)
	k json	
	Quit resultString
}

//在树中

ClassMethod List2(PersonRowId, Start, Limit)
{
	Set PersonRowId=$G(PersonRowId)

	Set start=$G(Start)
	Set limit=$G(Limit)
	Set count=0
	Set resultString = ""
	Set end = start+limit
	Set json = ##class(Code.JsonObj).%New()
	set ChildRowId = 0
	
     s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select ChildRowId from CHSS.ChildBaseInfo where PersonRowId="_PersonRowId_""
	d result.Prepare(sqlStr)
	d result.Execute()
	q:(result="") "[]"
	s resultString = ""
	s json = ##class(Code.JsonObj).%New()
	While(result.Next())
	{
	
	s ChildRowId = result.Data("ChildRowId")
	s tempChild = ##class(CHSS.ChildBaseInfo).%OpenId(ChildRowId)
		
	s PersonRowId=""
	i tempChild.PersonRowId'="" d
	.s PersonRowId=tempChild.PersonRowId.%Id()
	
	s Name=tempChild.Name
	s HelpCode=tempChild.HelpCode
	
	s Sex=""
	s SexName=""
	i tempChild.Sex'="" d
	.s Sex=tempChild.Sex.%Id()
	s SexName=tempChild.Sex.CTSEXDesc
	s ChildHandBookCode=tempChild.ChildHandBookCode
	s BcCode=tempChild.BcCode
	s VaccinateHandbookCode=tempChild.VaccinateHandbookCode
	s PregHealthCode=tempChild.PregHealthCode
	s CopyDataRes=tempChild.CopyDataRes
	s CardCode=tempChild.CardCode
	s CardType=tempChild.CardType.Description
	
	s ChildBirth = tempChild.Birth
	i ChildBirth '= "" d
	.s ChildBirth = $zd(ChildBirth,3)
	
	s Weight=tempChild.Weight
	s HandbookAdd=tempChild.HandbookAdd
	s Address=tempChild.Address
	s PostCode=tempChild.PostCode
	s FatherName=tempChild.FatherName
	s FMobTele=tempChild.FMobTele
	s FatherTele=tempChild.FatherTele
	s FatherPH=tempChild.FatherPH
	s FatherAllergies=tempChild.FatherAllergies
	s MotherName=tempChild.MotherName
	s MMobTele=tempChild.MMobTele
	s MotherTele=tempChild.MotherTele
	s MotherPH=tempChild.MotherPH
	s MotherAllergies=tempChild.MotherAllergies
	s GestationalAge=tempChild.GestationalAge
	s RenalDiseases=tempChild.RenalDiseases
	s ChildBirthPlace=tempChild.BirthPlace
	s BirthSituation=tempChild.BirthSituation
	s FosterMother=tempChild.FosterMother

	s FosterMotherTele=tempChild.FosterMotherTele
	
	s MobTele=tempChild.MobTele
	s Email=tempChild.Email
	s bNeonScreen=tempChild.bNeonScreen
	s BornWeight=tempChild.BornWeight
	s BornHeight=tempChild.BornHeight
	s NetPassword=tempChild.NetPassword
	s InputUnit=tempChild.InputUnit
	s FinishTable=tempChild.FinishTable
	set OperatorName = ""
    set Operator = ""
    i tempChild.Operator '= "" d
    .s Operator = tempChild.Operator.%Id()
    .s OperatorName = tempChild.Operator.SSUSRName

	
	s OperateDate=tempChild.OperateDate
	i OperateDate'="" d
	.s OperateDate=$zd(OperateDate,3)
		
	s FillDate=tempChild.FillDate
	i FillDate'="" d
	.s FillDate=$zd(FillDate,3)
	
	s FinishTableName=tempChild.FinishTableName
	s InputUnitName=tempChild.InputUnitName
	s ChildDisease=tempChild.ChildDisease
	
	s tmp=""
	s tmp=ChildRowId_"^"_PersonRowId_"^"_Name_"^"_HelpCode_"^"_Sex_"^"_SexName_"^"_ChildHandBookCode_"^"_BcCode_"^"_VaccinateHandbookCode_"^"_PregHealthCode_"^"_CopyDataRes_"^"_CardCode_"^"_CardType_"^"_ChildBirth_"^"_Weight_"^"_HandbookAdd_"^"_Address_"^"_PostCode_"^"_FatherName_"^"_FMobTele_"^"_FatherTele_"^"_FatherPH_"^"_FatherAllergies_"^"_MotherName_"^"_MMobTele_"^"_MotherTele_"^"_MotherPH_"^"_MotherAllergies_"^"_GestationalAge_"^"_RenalDiseases_"^"_ChildBirthPlace_"^"_BirthSituation_"^"_FosterMother_"^"_FosterMotherTele_"^"_MobTele_"^"_Email_"^"_bNeonScreen_"^"_BornWeight_"^"_BornHeight_"^"_NetPassword_"^"_InputUnit_"^"_FinishTable_"^"_Operator_"^"_OperateDate_"^"_FillDate_"^"_FinishTableName_"^"_InputUnitName_"^"_OperatorName_"^"_ChildDisease
	s count=count+1
	i (count>start)&(count<=end) d
    .d json.InsertRowData(tmp)
	}
	s resultString = json.getJsonData("ChildRowId^PersonRowId^Name^HelpCode^Sex^SexName^ChildHandBookCode^BcCode^VaccinateHandbookCode^PregHealthCode^CopyDataRes^CardCode^CardType^ChildBirth^Weight^HandbookAdd^ChildAddress^PostCode^ChildFatherName^FMobTele^FatherTele^FatherPH^FatherAllergies^ChildMotherName^MMobTele^MotherTele^MotherPH^MotherAllergies^GestationalAge^RenalDiseases^ChildBirthPlace^BirthSituation^FosterMother^FosterMotherTele^MobTele^Email^bNeonScreen^BornWeight^BornHeight^NetPassword^InputUnit^FinishTable^Operator^OperateDate^FillDate^FinishTableName^InputUnitName^OperatorName^ChildDisease",count)
	k json	
	Quit resultString
}

//添加

ClassMethod insert(PersonRowId, Name, HelpCode, Sex, ChildHandBookCode, BcCode, VaccinateHandbookCode, PregHealthCode, CopyDataRes, CardCode, CardType, Birth, Weight, HandbookAdd, Address, PostCode, FatherName, FMobTele, FatherTele, FatherPH, FatherAllergies, MotherName, MMobTele, MotherTele, MotherPH, MotherAllergies, GestationalAge, RenalDiseases, BirthPlace, BirthSituation, FosterMother, FosterMotherTele, MobTele, Email, bNeonScreen, BornWeight, BornHeight, NetPassword, InputUnit, FinishTable, Operator, OperateDate, CommunityCode, FillDate, FinishTableName, InputUnitName, OperatorName, ChildDisease)
{
	s tempChild = ""
	s tempChild =##class(CHSS.ChildBaseInfo).%New()
	
	i PersonRowId '= "" d
	.s tempChild.PersonRowId = ##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowId)
	
	s tempChild.Name=Name
	s tempChild.HelpCode=HelpCode
	
	i Sex'="" d
	.s tempChild.Sex=##class(User.CTSex).%OpenId(Sex)
	
	s tempChild.ChildHandBookCode=ChildHandBookCode
	s tempChild.BcCode=BcCode
	s tempChild.VaccinateHandbookCode=VaccinateHandbookCode
	s tempChild.PregHealthCode=PregHealthCode
	s tempChild.CopyDataRes=CopyDataRes
	s tempChild.CardCode=CardCode
	s tempChild.CardType=CardType
	
	i Birth'="" d
	.s Birth=$zdh(Birth,3)
	.s tempChild.Birth=Birth
	
	s tempChild.Weight=Weight
	s tempChild.HandbookAdd=HandbookAdd
	s tempChild.Address=Address
	s tempChild.PostCode=PostCode
	s tempChild.FatherName=FatherName
	s tempChild.FMobTele=FMobTele
	s tempChild.FatherTele=FatherTele
	s tempChild.FatherPH=FatherPH
	s tempChild.FatherAllergies=FatherAllergies
	s tempChild.MotherName=MotherName
	s tempChild.MMobTele=MMobTele
	s tempChild.MotherTele=MotherTele
	s tempChild.MotherPH=MotherPH
	s tempChild.MotherAllergies=MotherAllergies
	s tempChild.GestationalAge=GestationalAge
	s tempChild.RenalDiseases=RenalDiseases
	s tempChild.BirthPlace=BirthPlace
	s tempChild.BirthSituation=BirthSituation
	s tempChild.FosterMother=FosterMother
	s tempChild.FosterMotherTele=FosterMotherTele
	s tempChild.MobTele=MobTele
	s tempChild.Email=Email
	s tempChild.bNeonScreen=bNeonScreen
	s tempChild.BornWeight=BornWeight
	s tempChild.BornHeight=BornHeight
	s tempChild.NetPassword=NetPassword
	s tempChild.InputUnit=InputUnit
	s tempChild.FinishTable=FinishTable
    i Operator '= "" d
    .s Operatorobj=##class(User.SSUser).%OpenId(Operator)
    .s tempChild.Operator=Operatorobj
	
	i OperateDate'="" d
	.s OperateDate=$zdh(OperateDate,3)
	.s tempChild.OperateDate=OperateDate
	
	s tempChild.CommunityCode=CommunityCode
	i FillDate'="" d
	.s tempChild.FillDate=$zdh(FillDate,3)
	
	s tempChild.FinishTableName=FinishTableName
	s tempChild.InputUnitName=InputUnitName
	s tempChild.OperatorName=OperatorName
	s tempChild.ChildDisease=ChildDisease
	
    s result=""
    s result=tempChild.%Save()
    Set resultString = ""
    i result = "1" d
    .i $Find(ChildDisease,"体弱")'=0 d
    ..&sql(insert into chss.childweakregister(PersonRowid) values (:PersonRowId))
    .s resultString = "{""success"":""true"",""info"":"_tempChild.%Id()_"}"
    e  d
    .s resultString = "{""success"":""false"",""info"":""数据保存出错!""}"
    q resultString
}

//修改

ClassMethod updata(ChildRowId, PersonRowId, Name, HelpCode, Sex, ChildHandBookCode, BcCode, VaccinateHandbookCode, PregHealthCode, CopyDataRes, CardCode, CardType, Birth, Weight, HandbookAdd, Address, PostCode, FatherName, FMobTele, FatherTele, FatherPH, FatherAllergies, MotherName, MMobTele, MotherTele, MotherPH, MotherAllergies, GestationalAge, RenalDiseases, BirthPlace, BirthSituation, FosterMother, FosterMotherTele, MobTele, Email, bNeonScreen, BornWeight, BornHeight, NetPassword, InputUnit, FinishTable, Operator, OperateDate, CommunityCode, FillDate, FinishTableName, InputUnitName, OperatorName, ChildDisease)
{
	 q:($d(ChildRowId)=0)||(ChildRowId="")
      
     s tempChild="",result=""
     s tempChild=##class(CHSS.ChildBaseInfo).%OpenId(ChildRowId)
     q:(tempChild="") 0	
      
     i PersonRowId '= "" d
	.s tempChild.PersonRowId = ##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowId)
	
	s tempChild.Name=Name
	s tempChild.HelpCode=HelpCode
	
	i Sex'="" d
	.s tempChild.Sex=##class(User.CTSex).%OpenId(Sex)
	
	s tempChild.ChildHandBookCode=ChildHandBookCode
	s tempChild.BcCode=BcCode
	s tempChild.VaccinateHandbookCode=VaccinateHandbookCode
	s tempChild.PregHealthCode=PregHealthCode
	s tempChild.CopyDataRes=CopyDataRes
	s tempChild.CardCode=CardCode
	s tempChild.CardType=CardType
	
	i Birth'="" d
	.s Birth=$zdh(Birth,3)
	.s tempChild.Birth=Birth
	
	s tempChild.Weight=Weight
	s tempChild.HandbookAdd=HandbookAdd
	s tempChild.Address=Address
	s tempChild.PostCode=PostCode
	s tempChild.FatherName=FatherName
	s tempChild.FMobTele=FMobTele
	s tempChild.FatherTele=FatherTele
	s tempChild.FatherPH=FatherPH
	s tempChild.FatherAllergies=FatherAllergies
	s tempChild.MotherName=MotherName
	s tempChild.MMobTele=MMobTele
	s tempChild.MotherTele=MotherTele
	s tempChild.MotherPH=MotherPH
	s tempChild.MotherAllergies=MotherAllergies
	s tempChild.GestationalAge=GestationalAge
	s tempChild.RenalDiseases=RenalDiseases
	s tempChild.BirthPlace=BirthPlace
	s tempChild.BirthSituation=BirthSituation
	s tempChild.FosterMother=FosterMother
	s tempChild.FosterMotherTele=FosterMotherTele
	s tempChild.MobTele=MobTele
	s tempChild.Email=Email
	s tempChild.bNeonScreen=bNeonScreen
	s tempChild.BornWeight=BornWeight
	s tempChild.BornHeight=BornHeight
	s tempChild.NetPassword=NetPassword
	s tempChild.InputUnit=InputUnit
	s tempChild.FinishTable=FinishTable
	
	i Operator '= "" d
    .s Operatorobj=##class(User.SSUser).%OpenId(Operator)
    .s tempChild.Operator=Operatorobj
    .//s tempChild.OperatorName=##class(User.SSUser).SSUSRName
	
	i OperateDate'="" d
	.s OperateDate=$zdh(OperateDate,3)
	.s tempChild.OperateDate=OperateDate
	
	s tempChild.CommunityCode=CommunityCode
	i FillDate'="" d
	.s tempChild.FillDate=$zdh(FillDate,3)
	
	s tempChild.FinishTableName=FinishTableName
	s tempChild.InputUnitName=InputUnitName
	s tempChild.OperatorName=OperatorName
	s tempChild.ChildDisease=ChildDisease
	 
    s result=""
    s result=tempChild.%Save()
    Set resultString = ""
    i result = "1" d
    .i $Find(ChildDisease,"体弱")'=0 d
    ..i (..exitWeakRecord(PersonRowId)=0) d 
    ...&sql(insert into chss.childweakregister(PersonRowid) values (:PersonRowId))

    
    
    .s resultString = "{""success"":""true"",""info"":""数据保存成功！""}"
    e  d
    .s resultString = "{""success"":""false"",""info"":""数据保存出错!""}"
    q resultString
}

//判断体弱儿童表中是否已经存在该儿童的记录

ClassMethod exitWeakRecord(personrowid)
{
	s count=0
	&sql(select count(*) into :count from chss.childweakregister where personrowid =:personrowid)
	q count
}

//归档

ClassMethod guidang(childid)
{

	&sql(update chss.childbaseinfo set FinishIdentifier=1 where ChildRowId=:childid)
	i SQLCODE ="0" d

    .s resultString = "{""success"":""true"",""info"":""归档成功!""}"
    e  d
    .s resultString = "{""success"":""false"",""info"":""归档出错!""}"
    q resultString
}

//统计各个年龄段的男女人数

ClassMethod statisticsAge(childcode, childagedate)
{
	s count=0
    Set json = ##class(Code.JsonObj).%New()
    s result = ##class(%Library.ResultSet).%New()
    s datenum =$zdh(childagedate,3)
	s sqlStr = "select sum(rowid) as roid,name as age,sum(man) as man,sum(woman) as woman from (select rowid,name,man,woman from  Chss.Agesample as aa union all select 0 as rowid,case when DATEDIFF('mm',Birth,GETDATE())<3 then '0-3月' else case when DATEDIFF('mm',Birth,GETDATE())>=3 and DATEDIFF('mm',Birth,GETDATE())<6 then '3-6月' else case when DATEDIFF('mm',Birth,GETDATE())>=6 and DATEDIFF('mm',Birth,GETDATE())<9 then '6-9月' else case when DATEDIFF('mm',Birth,GETDATE())>=9 and DATEDIFF('mm',Birth,GETDATE())<12 then '9-12月' else case when DATEDIFF('mm',Birth,GETDATE())>=12 and DATEDIFF('mm',Birth,GETDATE())<24 then '1-2岁' else case when DATEDIFF('mm',Birth,GETDATE())>=24 and DATEDIFF('mm',Birth,GETDATE())<36 then '2-3岁' else case when DATEDIFF('mm',Birth,GETDATE())>=36 and DATEDIFF('mm',Birth,GETDATE())<48 then '3-4岁' else case when DATEDIFF('mm',Birth,GETDATE())>=48 and DATEDIFF('mm',Birth,GETDATE())<60 then '4-5岁' else case when DATEDIFF('mm',Birth,GETDATE())>=60 and DATEDIFF('mm',Birth,GETDATE())<72 then '5-6岁' else case when DATEDIFF('mm',Birth,GETDATE())>=72 and DATEDIFF('mm',Birth,GETDATE())<84 then  '6-7岁' else '其他'  end end end end end end end end end end as name,case when sex=1 then 1 else 0 end as man,case when sex=2 then 1 else 0 end as woman from Chss.childbaseinfo where CommunityCode='"_childcode_"' and OperateDate<="_datenum_") as T group by T.name order by roid"
	d result.Prepare(sqlStr)
	d result.Execute()
	q:(result="") "[]"
	s resultString = ""
	s json = ##class(Code.JsonObj).%New()
	
	While(result.Next())
	{
		s count=count+1
		s name=result.Data("age")
		s man=result.Data("man")
		s woman=result.Data("woman")
		s tmp=name_"^"_man_"^"_woman
		d json.InsertRowData(tmp)
		
    }
   	d result.Close()
	s resultString = json.getJsonData("name^man^woman",count)
    k json
	q resultString
}

//医生工作量统计

ClassMethod statisticsWork(code, startdate, enddate)
{
	s count=0
    Set json = ##class(Code.JsonObj).%New()
    s result = ##class(%Library.ResultSet).%New()
    s sdate =$zdh(startdate,3)
    s enddate=$zdh(enddate,3)
   
    s sqlStr="select FinishTable as FinishTable,Sum(shoucenum) as shoucenum,Sum(ChildNum) as ChildNum, Sum(CheckNum) as CheckNum from (select FinishTable as FinishTable,count(*) as shoucenum,0 as ChildNum,0 as CheckNum from chss.childbaseinfo   where CommunityCode='"_code_"' and   OperateDate between "_sdate_" and "_enddate_" group by FinishTable union select doctor as FinishTable, 0 as shoucenum, count(*) as ChildNum, count(*) as CheckNum from chss.ChildFirstCheck  where DateOfCheck between "_sdate_" and "_enddate_" group by doctor union select doctor as FinishTable,0 as shoucenum,count(*) as ChildNum,count(*) as CheckNum from chss.ChildCheckRecord  where DateOfCheck between "_sdate_" and "_enddate_" group by doctor union select doctor as FinishTable,0 as shoucenum,count(*) as ChildNum,count(*) as CheckNum from chss.Child36CheckRecord where DateOfCheck between "_sdate_" and "_enddate_" group by doctor)group by FinishTable"
 
    d result.Prepare(sqlStr)
	
	d result.Execute()
	q:(result="") "[]"
	s resultString = ""
	s json = ##class(Code.JsonObj).%New()
	
	While(result.Next())
	{   
	    
		s count=count+1
		s FinishTable=result.Data("FinishTable")
		s renci=result.Data("CheckNum")
		s dangan=result.Data("shoucenum")
		s renshu=result.Data("ChildNum")
	 
		s tmp=FinishTable_"^"_renshu_"^"_dangan_"^"_renci
		d json.InsertRowData(tmp)
    }
   	d result.Close()
	s resultString = json.getJsonData("FinishTable^renshu^dangan^renci",count)
    k json
	q resultString
}

Storage Default
{
<Data name="ChildBaseInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.ChildBaseInfoD</DataLocation>
<DefaultData>ChildBaseInfoDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.ChildBaseInfoD</IdLocation>
<IndexLocation>^CHSSWeb.ChildBaseInfoI</IndexLocation>
<StreamLocation>^CHSSWeb.ChildBaseInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
