/// Class Name:		EMRservice.Observer.PaPatMas
/// Description:	更新患者基本信息表中的单独数据项
/// Creator:		Lina
/// Create Date:	2015-09-17
Class EMRservice.Observer.PaPatMas Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Description:	更新患者姓名
/// Creator:		Lina
/// Create Date:	2015-09-17
/// Return:         1:更新成功   -1：保存失败   -2：缺少参数
/// Debug:          w ##class(EMRservice.Observer.PaPatMas).UpdateName(292,"TUTU")
ClassMethod UpdateName(argPapmiDr As %String, argValue As %String) As %String
{
	q:($d(argPapmiDr)="") -2
	s ReturnValue = 0
	s Name = argValue
	s PAPatMasobj = ##class(User.PAPatMas).%OpenId(argPapmiDr)
	s PAPatMasobj.PAPMIName = Name
	
	s sc = PAPatMasobj.%Save()
	
	if $system.Status.IsError(sc) 		//检查Save是否成功
	{                               
   		d $system.OBJ.DisplayError(sc) 
   		set ReturnValue = -1
	}
	else
	{
		set ReturnValue = 1
	}
	d PAPatMasobj.%Close()
	
	quit ReturnValue
}

/// Description:	更新患者现住址省份
/// Creator:		Lina
/// Create Date:	2016-01-27
/// Return:         1:更新成功   -1：保存失败   -2：缺少参数
/// Debug:          w ##class(EMRservice.Observer.PaPatMas).UpdateAddressProvice(292,"210000")
ClassMethod UpdateAddressProvice(argPapmiDr As %String, argCodeValue As %String) As %String
{
	q:($d(argPapmiDr)="") -2
	s ReturnValue = 0
	//现住址省份
	s PAPersonobj = ##class(User.PAPerson).%OpenId(argPapmiDr)
	s ProvinceDR = $o(^CT("PROV",0,"Code",argCodeValue,""))
	if (ProvinceDR '= ""){
		do PAPersonobj.PAPERCTProvinceDRSetObjectId(ProvinceDR)
	}
	
	s sc = PAPersonobj.%Save()
	
	if $system.Status.IsError(sc) 		//检查Save是否成功
	{                               
   		d $system.OBJ.DisplayError(sc) 
   		set ReturnValue = -1
	}
	else
	{
		set ReturnValue = 1
	}
	d PAPersonobj.%Close()
	
	//s PAPersonobj = ""
	quit ReturnValue
}

/// Description:	更新患者现住址城市
/// Creator:		Lina
/// Create Date:	2016-01-27
/// Return:         1:更新成功   -1：保存失败   -2：缺少参数
/// Debug:          w ##class(EMRservice.Observer.PaPatMas).UpdateAddressCity(292,"130100")
ClassMethod UpdateAddressCity(argPapmiDr As %String, argCodeValue As %String) As %String
{
	q:($d(argPapmiDr)="") -2
	s ReturnValue = 0
	//现住址城市
	s PAPersonobj = ##class(User.PAPerson).%OpenId(argPapmiDr)
	s CityCodeDR = $o(^CT("CIT",0,"Code",argCodeValue,""))
	if (CityCodeDR '= ""){
		do PAPersonobj.PAPERCityCodeDRSetObjectId(CityCodeDR)
	}
	
	s sc = PAPersonobj.%Save()
	
	if $system.Status.IsError(sc) 		//检查Save是否成功
	{                               
   		d $system.OBJ.DisplayError(sc) 
   		set ReturnValue = -1
	}
	else
	{
		set ReturnValue = 1
	}
	d PAPersonobj.%Close()
	
	quit ReturnValue
}

/// Description:	更新患者现住址区县
/// Creator:		Lina
/// Create Date:	2016-01-27
/// Return:         1:更新成功   -1：保存失败   -2：缺少参数
/// Debug:          w ##class(EMRservice.Observer.PaPatMas).UpdateAddressCounty(292,"130703")
ClassMethod UpdateAddressCounty(argPapmiDr As %String, argCodeValue As %String) As %String
{
	q:($d(argPapmiDr)="") -2
	s ReturnValue = 0
	//现住址区县
	s PAPersonobj = ##class(User.PAPerson).%OpenId(argPapmiDr)
	s CityAreaDR = $o(^CT("CITAREA",0,"Code",argCodeValue,""))
	if (CityAreaDR '= ""){
		do PAPersonobj.PAPERCityAreaDRSetObjectId(CityAreaDR)
	}
	
	s sc = PAPersonobj.%Save()
	
	if $system.Status.IsError(sc) 		//检查Save是否成功
	{                               
   		d $system.OBJ.DisplayError(sc) 
   		set ReturnValue = -1
	}
	else
	{
		set ReturnValue = 1
	}
	d PAPersonobj.%Close()
	
	quit ReturnValue
}

/// Description:	更新患者现住址街号
/// Creator:		Lina
/// Create Date:	2016-01-27
/// Return:         1:更新成功   -1：保存失败   -2：缺少参数
/// Debug:          w ##class(EMRservice.Observer.PaPatMas).UpdateAddressStreet(292,"华苑路53号")
ClassMethod UpdateAddressStreet(argPapmiDr As %String, argValue As %String) As %String
{
	q:($d(argPapmiDr)="") -2
	s ReturnValue = 0
	s AddressStreet = argValue
	//现住址街号
	s PAPersonobj = ##class(User.PAPerson).%OpenId(argPapmiDr)
	d PAPersonobj.PAPERStName.Clear() 
	d PAPersonobj.PAPERStName.Insert(AddressStreet)
	
	s sc = PAPersonobj.%Save()
	
	if $system.Status.IsError(sc) 		//检查Save是否成功
	{                               
   		d $system.OBJ.DisplayError(sc) 
   		set ReturnValue = -1
	}
	else
	{
		set ReturnValue = 1
	}
	d PAPersonobj.%Close()
    
    quit ReturnValue
}

/// Description:    更新患者现住址电话
/// Table：         PA_Person.PAPER_MobPhone
/// Creator:        Lina
/// Create Date:    2020-07-01
/// Return:         1:更新成功   -1：保存失败   -2：缺少参数
/// Debug:          w ##class(EMRservice.Observer.PaPatMas).UpdateMobilePhone(265,"13365417890")
ClassMethod UpdateMobilePhone(argPapmiDr As %String, argValue As %String)
{
    q:($d(argPapmiDr)="") -2
    s ReturnValue = 0
    s MobilePhone = argValue
    //现住址电话 手机
    s PAPersonobj = ##class(User.PAPerson).%OpenId(argPapmiDr)
    s PAPersonobj.PAPERMobPhone = MobilePhone
    
    s sc = PAPersonobj.%Save()
    
    if $system.Status.IsError(sc)       //检查Save是否成功
    {                               
        d $system.OBJ.DisplayError(sc) 
        set ReturnValue = -1
    }
    else
    {
        set ReturnValue = 1
    }
    d PAPersonobj.%Close()
	quit ReturnValue
}

/// Description:	更新患者工作电话
/// Table：			PA_Person.PAPER_TelO
/// Creator:		Lina
/// Create Date:	2016-08-05
/// Return:         1:更新成功   -1：保存失败   -2：缺少参数
/// Debug:          w ##class(EMRservice.Observer.PaPatMas).UpdateWorkPhone(265,"13365417890")
ClassMethod UpdateWorkPhone(argPapmiDr As %String, argValue As %String)
{
	q:($d(argPapmiDr)="") -2
	s ReturnValue = 0
	s WorkPhone = argValue
	//工作电话
	s PAPersonobj = ##class(User.PAPerson).%OpenId(argPapmiDr)
	s PAPersonobj.PAPERTelO = WorkPhone
	
	s sc = PAPersonobj.%Save()
	
	if $system.Status.IsError(sc) 		//检查Save是否成功
	{                               
   		d $system.OBJ.DisplayError(sc) 
   		set ReturnValue = -1
	}
	else
	{
		set ReturnValue = 1
	}
	d PAPersonobj.%Close()
	
	quit ReturnValue
}

/// Description:	更新患者身份证号,同步更新患者的出生日期、年龄(系统自动更新)和证件号
/// Table：			PA_Person.PAPER_ID
///                 PA_Person.PAPER_Dob
///                 PA_PatMas.PAPMI_DVAnumber
/// Creator:		Lina
/// Create Date:	2016-08-16
/// Return:         1:更新成功   -1：保存失败   -2：缺少参数
/// Debug:          w ##class(EMRservice.Observer.PaPatMas).UpdateIDCard(265,"133654189010058957")
ClassMethod UpdateIDCard(argPapmiDr As %String, argValue As %String)
{
	q:($d(argPapmiDr)="") -2
	s ReturnValue = 0
	s IDCard = argValue
	s PAPersonobj = ##class(User.PAPerson).%OpenId(argPapmiDr)
	//身份证号
	s PAPersonobj.PAPERID = IDCard
	//出生日期
	s:(IDCard'="") BrithDate = $zdh($e(IDCard,11,12)_"/"_$e(IDCard,13,14)_"/"_$e(IDCard,7,10))
	s PAPersonobj.PAPERDob = BrithDate
	
	//证件号PA_PatMas.PAPMI_DVAnumber
	s PAPatMasobj = ##class(User.PAPatMas).%OpenId(argPapmiDr)
	s PAPatMasobj.PAPMIDVAnumber = IDCard
	s scPAPatMasobj = PAPatMasobj.%Save()
	
	s sc = PAPersonobj.%Save()
	
	if $system.Status.IsError(sc) 		//检查Save是否成功
	{                               
   		d $system.OBJ.DisplayError(sc) 
   		set ReturnValue = -1
	}
	else
	{
		set ReturnValue = 1
	}
	d PAPersonobj.%Close()
	d PAPatMasobj.%Close()
    
    quit ReturnValue
}

/// Description:    更新患者联系人姓名
/// Table：         PA_Person.PAPER_ForeignId
/// Creator:        Lina
/// Create Date:    2020-07-01
/// Return:         1:更新成功   -1：保存失败   -2：缺少参数
/// Debug:          w ##class(EMRservice.Observer.PaPatMas).UpdateLinkName(265,"TUTU")
ClassMethod UpdateLinkName(argPapmiDr As %String, argValue As %String)
{
    q:($d(argPapmiDr)="") -2
    s ReturnValue = 0
    s LinkName = argValue
    //联系人姓名
    s PAPersonobj = ##class(User.PAPerson).%OpenId(argPapmiDr)
    s PAPersonobj.PAPERForeignId = LinkName
    
    s sc = PAPersonobj.%Save()
    
    if $system.Status.IsError(sc)       //检查Save是否成功
    {                               
        d $system.OBJ.DisplayError(sc) 
        set ReturnValue = -1
    }
    else
    {
        set ReturnValue = 1
    }
    d PAPersonobj.%Close()
    
	quit ReturnValue
}

/// Description:    更新患者联系人电话
/// Table：         PA_Person.PAPER_ForeignPhone
/// Creator:        Lina
/// Create Date:    2020-07-01
/// Return:         1:更新成功   -1：保存失败   -2：缺少参数
/// Debug:          w ##class(EMRservice.Observer.PaPatMas).UpdateLinkPhone(265,"13365417890")
ClassMethod UpdateLinkPhone(argPapmiDr As %String, argValue As %String)
{
    q:($d(argPapmiDr)="") -2
    s ReturnValue = 0
    s LinkPhone = argValue
    //联系人电话
    s PAPersonobj = ##class(User.PAPerson).%OpenId(argPapmiDr)
    s PAPersonobj.PAPERForeignPhone = LinkPhone
    
    s sc = PAPersonobj.%Save()
    
    if $system.Status.IsError(sc)       //检查Save是否成功
    {                               
        d $system.OBJ.DisplayError(sc) 
        set ReturnValue = -1
    }
    else
    {
        set ReturnValue = 1
    }
    d PAPersonobj.%Close()
    
    quit ReturnValue
}

/// Description:    更新患者民族
/// Table：         PA_Person.PAPER_Nation_DR
/// Creator:        Lina
/// Create Date:    2020-07-13
/// Return:         1:更新成功   -1：保存失败   -2：缺少参数
/// Debug:          w ##class(EMRservice.Observer.PaPatMas).UpdateNation(265,"01")
ClassMethod UpdateNation(argPapmiDr As %String, argCodeValue As %String)
{
    q:($d(argPapmiDr)="") -2
    s ReturnValue = 0
    //患者民族
    s PAPersonobj = ##class(User.PAPerson).%OpenId(argPapmiDr)
    s NationDR = $o(^CT("NAT",0,"Code",argCodeValue,""))
    if (NationDR '= ""){
        do PAPersonobj.PAPERNationDRSetObjectId(NationDR)
    }
    
    s sc = PAPersonobj.%Save()
    
    if $system.Status.IsError(sc)       //检查Save是否成功
    {                               
        d $system.OBJ.DisplayError(sc) 
        set ReturnValue = -1
    }
    else
    {
        set ReturnValue = 1
    }
    d PAPersonobj.%Close()
    
    quit ReturnValue
}

/// Description:    更新患者婚姻
/// Table：         PA_Person.PAPER_Marital_DR
/// Creator:        Lina
/// Create Date:    2020-07-13
/// Return:         1:更新成功   -1：保存失败   -2：缺少参数
/// Debug:          w ##class(EMRservice.Observer.PaPatMas).UpdateMarriage(265,"10")
ClassMethod UpdateMarriage(argPapmiDr As %String, argCodeValue As %String)
{
    q:($d(argPapmiDr)="") -2
    s ReturnValue = 0
    //患者婚姻
    s PAPersonobj = ##class(User.PAPerson).%OpenId(argPapmiDr)
    s MaritalDR = $o(^CT("MAR",0,"Code",argCodeValue,""))
    if (MaritalDR '= ""){
        do PAPersonobj.PAPERMaritalDRSetObjectId(MaritalDR)
    }
    
    s sc = PAPersonobj.%Save()
    
    if $system.Status.IsError(sc)       //检查Save是否成功
    {                               
        d $system.OBJ.DisplayError(sc) 
        set ReturnValue = -1
    }
    else
    {
        set ReturnValue = 1
    }
    d PAPersonobj.%Close()
    
    quit ReturnValue
}

/// Description:    更新患者职业
/// Table：         PA_Person.PAPER_Occupation_DR
/// Creator:        Lina
/// Create Date:    2020-07-13
/// Return:         1:更新成功   -1：保存失败   -2：缺少参数
/// Debug:          w ##class(EMRservice.Observer.PaPatMas).UpdateOccupation(265,"316")
ClassMethod UpdateOccupation(argPapmiDr As %String, argCodeValue As %String)
{
    q:($d(argPapmiDr)="") -2
    s ReturnValue = 0
    //患者职业
    s PAPersonobj = ##class(User.PAPerson).%OpenId(argPapmiDr)
    s OccupationDR = $o(^CT("OCC",0,"Code",argCodeValue,""))
    if (OccupationDR '= ""){
        do PAPersonobj.PAPEROccupationDRSetObjectId(OccupationDR)
    }
    
    s sc = PAPersonobj.%Save()
    
    if $system.Status.IsError(sc)       //检查Save是否成功
    {                               
        d $system.OBJ.DisplayError(sc) 
        set ReturnValue = -1
    }
    else
    {
        set ReturnValue = 1
    }
    d PAPersonobj.%Close()
    
    quit ReturnValue
}

/// Description:    更新患者户口地址
/// Table：         PA_Person.PAPER_StName
/// Creator:        Lina
/// Create Date:    2020-07-13
/// Return:         1:更新成功   -1：保存失败   -2：缺少参数
/// Debug:          w ##class(EMRservice.Observer.PaPatMas).UpdateHuKouAddress(265,"北京市市辖区东城区东华门街道")
ClassMethod UpdateHuKouAddress(argPapmiDr As %String, argValue As %String)
{
    q:($d(argPapmiDr)="") -2
    s ReturnValue = 0
    s HuKouAddress = argValue
    //患者户口地址
    s PAPersonobj = ##class(User.PAPerson).%OpenId(argPapmiDr)
    d PAPersonobj.PAPERStName.Clear() 
    d PAPersonobj.PAPERStName.Insert(HuKouAddress)
    
    s sc = PAPersonobj.%Save()
    
    if $system.Status.IsError(sc)       //检查Save是否成功
    {                               
        d $system.OBJ.DisplayError(sc) 
        set ReturnValue = -1
    }
    else
    {
        set ReturnValue = 1
    }
    d PAPersonobj.%Close()
    
    quit ReturnValue
}

}
