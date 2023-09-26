Class web.DHCSTPHCMGuiScope Extends %RegisteredObject
{

/// Creator:    yuliping
/// CreateDate: 2017-01-20
/// Descript:   鑾峰彇鎸囧鑼冨洿鐖惰妭鐐广?佸瓙鑺傜偣
/// w ##class(web.DHCSTPHCMGuiScope).getGuiScopePatCode("EDU","N","")
ClassMethod getGuiScopePatCode(ModType, SubModType, PatCode)
{
	s PhgsId="",str=""
	q:((ModType="")||(SubModType="")) str
	f  s PhgsId=$o(^DHCPHGS(0,"ModType",ModType,SubModType,PhgsId))  q:PhgsId=""  d
	.q:PhgsId=0
	.s code="",desc=""
	.s code=$p($g(^DHCPHGS(PhgsId)),"^",1)
	.q:((PatCode="")&&(code[".")) 					//PatCode涓虹┖锛屽彧鏌ヨ鐖惰妭鐐?
	.s firCode=""
	.i code["." s firCode=$p(code,".",1)
	.q:((firCode'=PatCode)&&(PatCode'=""))          //PatCode涓嶄负绌猴紝鍙煡璇㈠瓙鑺傜偣
	.s desc=$p($g(^DHCPHGS(PhgsId)),"^",2)
	.s desc=##class(PHA.FACE.IN.Com).GetTransDesc("User.DHCPHGuiScope","PHGSDesc","",desc)
	.i str="" d
	..s str=code_"^"_desc_"^"_PhgsId
	.e  d
	..s str=str_"!"_code_"^"_desc_"^"_PhgsId
	q str
}

}
