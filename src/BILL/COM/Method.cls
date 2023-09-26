/// 名称: BILL.COM.Method.cls
/// 描述: 计费组公共方法相关类
/// 编写者: ZhYW
/// 编写日期: 2021-07-29
Class BILL.COM.Method Extends BILL.COM.Abstract
{

/// Creator: ZhYW
/// CreatDate: 2021-07-29
/// Description: 根据身份证号获取其对应的信息
/// Input: pId:身份证号, hospId:CT_Hospital.RowId
/// Return: 
/// Debug: w ##class(BILL.COM.Method).GetInfoByFromIDNo("620524199012034676",2)
ClassMethod GetInfoByFromIDNo(pId As %String, hospId As %String, langId As %String = "") As %String
{
	if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
	set json={}
	if (" 15 18 "'[(" "_$l(pId)_" ")) {
		set json.success=-1
		set json.msg="身份证位数错误"
		quit json.%ToJSON()
	}
	if ($l(pId)=15) {
		set pId=##class(DHCDoc.Util.Base).ID15to18(pId)    //身份证号15位转18位
	}
	set divisionCode=$e(pId,1,6)     //行政区划代码
	set provCode=$e(divisionCode,1,2)_"0000"
	set cityCode=$e(divisionCode,1,4)_"00"
	set cityAreaCode=$e(divisionCode,1,6)
	set provId=$o(^CT("PROV",0,"Code",$$ALPHAUP^SSUTIL4(provCode),0))
	set prov=$p(^CT("PROV",provId),"^",2)
	set cityId=$o(^CT("CIT",0,"Code",$$ALPHAUP^SSUTIL4(cityCode),0))
	set city=$p(^CT("CIT",cityId),"^",2)
	set cityAreaId=$o(^CT("CITAREA",0,"Code",$$ALPHAUP^SSUTIL4(cityAreaCode),0))
	set cityArea=$p(^CT("CITAREA",cityAreaId),"^",2)
	
	set birthDate=$e(pId,7,14)       //出生日期
	set birthDate=##class(websys.Conversions).DateLogicalToHtml($zdh(birthDate,8))
	set ageStr=##class(web.UDHCJFCOMMON).DispPatAge(birthDate, "", "", "", hospId)
	set age=$p(ageStr,"||",1)
	
	set seqCode=$e(pId,15,17)        //顺序码
	set sexCode=$case((seqCode#2),1:1,:2)   //奇数为"男",偶数为"女"
	set sexId=$o(^CT("SEX",0,"Code",$$ALPHAUP^SSUTIL4(sexCode),0))
	set sex=$s((+sexId'=0):$p($g(^CT("SEX",sexId)),"^",2),1:"")
	set sex=##class(User.CTSex).GetTranByDesc("CTSEXDesc", sex, langId)
	
	set json.success=0
	set json.msg="获取身份证信息成功"
	set json.provId=provId
	set json.prov=prov
	set json.cityId=cityId
	set json.city=city
	set json.cityAreaId=cityAreaId
	set json.cityArea=cityArea
	set json.birthDate=birthDate
	set json.age=age
	set json.sexId=sexId
	set json.sex=sex
	quit json.%ToJSON()
}

}
