/// Class Name:		EPRservice.Observer.PaPatMas
/// Description:	更新患者基本信息表中的单独数据项
/// Creator:	    YHY
/// Create Date:	2012-10-28
Class EPRservice.Observer.PaPatMas Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// 北京安贞医院
Parameter HospitalBJAZYY = "BJAZYY";

/// 01 北京积水潭医院 ok
Parameter HospitalBJJSTYY = "BJJSTYY";

/// 02 粤北人民医院 ok
Parameter HospitalYBRMYY = "YBRMYY";

/// 03 安徽省立医院
Parameter HospitalAHSLYY = "AHSLYY";

/// 04 西安交大口腔医院
Parameter HospitalXAJDKQYY = "XAJDKQYY";

/// 05 北京地坛医院
Parameter HospitalBJDTYY = "BJDTYY";

/// 06 宁医一附院
Parameter HospitalNYYFY = "NYYFY";

/// 07 厦门翔鹭体检中心
Parameter HospitalXMXLTJZX = "XMXLTJZX";

/// 08 上海华山东院
Parameter HospitalSHHSDY = "SHHSDY";

/// 09 宁波明洲医院
Parameter HospitalNBMZYY = "NBMZYY";

/// 10 华西二院
Parameter HospitalHXEY = "HXEY";

/// 11 华西医院
Parameter HospitalHXYY = "HXYY";

/// 12 中国医大一附院
Parameter HospitalZGYDYFY = "ZGYDYFY";

/// 13 北京中医医院
Parameter HospitalBJZYYY = "BJZYYY";

/// 14 北京妇产医院
Parameter HospitalBJFCYY = "BJFCYY";

/// 15 衢州人民医院
Parameter HospitalQZRMYY = "QZRMYY";

/// 16 潍坊市人民医院
Parameter HospitalWFSRMYY = "WFSRMYY";

/// 17 深圳中医医院
Parameter HospitalSZZYYY = "SZZYYY";

/// 18 长春妇产医院
Parameter HospitalCCFCYY = "CCFCYY";

/// 19 长春吉大三院
Parameter HospitalCCJDSY = "CCJDSY";

/// 20 医科院肿瘤医院
Parameter HospitalYKYZLYY = "YKYZLYY";

/// 21 上海东方医院
Parameter HospitalSHDFYY = "SHDFYY";

/// 22 大同三院
Parameter HospitalDTSY = "DTSY";

/// 23 南通通大附院
Parameter HospitalNTDXFY = "NTDXFY";

/// 24 安徽心脑心血医院
Parameter HospitalAHXNXGYY = "AHXNXGYY";

/// 25 中国石油中心医院
Parameter HospitalZGSYZXYY = "ZGSYZXYY";

/// 26 徐州市中心医院
Parameter HospitalXZSZXYY = "XZSZXYY";

/// 27 兰州大学第二医院
Parameter HospitalLZDXDEYY = "LZDXDEYY";

/// 28 武汉儿童医院
Parameter HospitalWHETYY = "WHETYY";

/// 29 武汉第一医院
Parameter HospitalWHDYYY = "WHDYYY";

/// Description:	更新患者姓名
/// Creator:	    YHY
/// Create Date:	2012-10-28
/// Return:         1:更新成功   -1：保存失败   -2：缺少参数
/// Debug:          w ##class(EPRservice.Observer.PaPatMas).UpdateName("9","TUTU")
ClassMethod UpdateName(argPapmiDr As %String, argValue As %String, argHospital As %String = "") As %String
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
	s PAPatMasobj = ""
	quit ReturnValue
}

/// Description:	更新患者身份证号
/// Author:	        YHY
/// Create Date:	2012-10-28
/// Return:         1:更新成功   -1：保存失败   -2：缺少参数
/// Debug:          w ##class(EPRservice.Observer.PaPatMas).UpdateIDCard("9","12345")
ClassMethod UpdateIDCard(argPapmiDr As %String, argValue As %String, argHospital As %String = "") As %String
{
	q:($d(argPapmiDr)="") -2
	s ReturnValue = 0
	s IDCard = argValue
	s PAPatMasobj = ##class(User.PAPatMas).%OpenId(argPapmiDr)
	/*
	if argHospital=..#HospitalBJJSTYY	//北京积水潭
	{
		s PAPatMasobj.PAPMIName2 = IDCard
	}
	else
	{
		s PAPatMasobj.PAPMIID = IDCard
	}
	*/
		
	s PAPatMasobj.PAPMIID = IDCard
	
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
	s PAPatMasobj = ""
	
	quit ReturnValue
}

}
