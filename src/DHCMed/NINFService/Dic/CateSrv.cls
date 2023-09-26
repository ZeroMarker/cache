/// 名称: DHCMed.NINFService.Dic.CateSrv
/// 描述: 字典分类定义的常用操作
/// 编写者：zhufei
/// 编写日期: 2013-06-04
Class DHCMed.NINFService.Dic.CateSrv Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2013-06-04
/// Description:  保存抗生素字典
/// Table：       DHCMed.NINF.Dic.Cate
/// Input：       
/// Return：      
/// w ##class(DHCMed.NINFService.Dic.CateSrv).GetCateByCode("ANTCate01","1")
ClassMethod GetCateByCode(aCateCode As %String, aGroupFlag As %String = "") As DHCMed.NINF.Dic.Cate
{
	New (aCateCode,aGroupFlag)
	Set return=""
	Quit:aCateCode="" return
	
	Set $ZT="GetCateByCodeErr"
	
	If aGroupFlag=1 {
		Set xCateCode=$zcvt(aCateCode,"U")
		While (1) {
			Set xParCode=$o(^DHCMed.NINFDi("Cate",0,"IdxofTypeCode"," "_xCateCode,""))
			Quit:xParCode=""
			Set xParCode=$e(xParCode,2,$l(xParCode))
			
			Set xRootCode=$o(^DHCMed.NINFDi("Cate",0,"IdxofTypeCode"," "_xParCode,""))
			Quit:xRootCode=""
			Set xRootCode=$e(xRootCode,2,$l(xRootCode))
			
			If xRootCode="SYS" {
				Set CateID=$o(^DHCMed.NINFDi("Cate",0,"IdxofCode"," "_xCateCode,0))
				If CateID'="" {
					Set return=##class(DHCMed.NINF.Dic.Cate).GetObjById(CateID)
				}
				Quit
			} Else {
				Set xCateCode=xParCode
			}
		}
	} ElseIf aGroupFlag=2 {
		Set xCateCode=$zcvt(aCateCode,"U")
		While (1) {
			Set xParCode1=$o(^DHCMed.NINFDi("Cate",0,"IdxofTypeCode"," "_xCateCode,""))
			Quit:xParCode1=""
			Set xParCode1=$e(xParCode1,2,$l(xParCode1))
			
			Set xParCode2=$o(^DHCMed.NINFDi("Cate",0,"IdxofTypeCode"," "_xParCode1,""))
			Quit:xParCode2=""
			Set xParCode2=$e(xParCode2,2,$l(xParCode2))
			
			Set xRootCode=$o(^DHCMed.NINFDi("Cate",0,"IdxofTypeCode"," "_xParCode2,""))
			Quit:xRootCode=""
			Set xRootCode=$e(xRootCode,2,$l(xRootCode))
			
			If xRootCode="SYS" {
				Set CateID=$o(^DHCMed.NINFDi("Cate",0,"IdxofCode"," "_xCateCode,0))
				If CateID'="" {
					Set return=##class(DHCMed.NINF.Dic.Cate).GetObjById(CateID)
				}
				Quit
			} Else {
				Set xCateCode=xParCode1
			}
		}
	} Else {
		Set CateID=$o(^DHCMed.NINFDi("Cate",0,"IdxofCode"," "_$zcvt(aCateCode,"U"),0))
		If CateID'="" {
			Set return=##class(DHCMed.NINF.Dic.Cate).GetObjById(CateID)
		}
	}
	
	Quit return
	
GetCateByCodeErr
	Quit ""
}

}
