Class web.DHCHM.GetComboxInfo Extends web.DHCHM.Abstract [ ClassType = "", Not ProcedureBlock ]
{

//w ##class(web.DHCHM.GetComboxInfo).GetCCodeTable("10010001","Y")

//Flag是看是否显示无效的 Y显示

ClassMethod GetCCodeTable(Type, Flag As %String = "")
{
	
	//d ##class(User.DHCHMCCodeTable).%BuildIndices()
	n (Type,Flag)
	s char1=$C(1)
	s char2=$C(2)
	s str=""
	s id=0
	f  s id=$O(^User.DHCHMCCodeTableI("Type"," "_Type,id)) q:id=""  d
	.s obj=##class(User.DHCHMCCodeTable).GetObj(id)
	.s active=obj.CTActive
	.q:(Flag'="Y")&&(active="N")
	.s desc=obj.CTDesc
	.s oneStr=id_char2_desc
	.i str="" d
	..s str=oneStr
	.e  d
	..s str=str_char1_oneStr
	s str=##class(web.DHCHM.Tools).ChangeToArrStr(str,char1,char2)
	q str
}

ClassMethod GetCPlainness(Type, Flag As %String = "")
{
	n (Type,Flag)
	s char1=$C(1)
	s char2=$C(2)
	s str=""
	s id=0
	f  s id=$O(^User.DHCHMCPlainnessI("PTypeIndex"," "_Type,id)) q:id=""  d
	.s obj=##class(User.DHCHMCPlainness).GetObj(id)
	.s active=obj.PActive
	.q:(Flag'="Y")&&(active="N")
	.s desc=obj.PDesc
	.s oneStr=id_char2_desc
	.i str="" d
	..s str=oneStr
	.e  d
	..s str=str_char1_oneStr
	s str=##class(web.DHCHM.Tools).ChangeToArrStr(str,char1,char2)
	q str
}

ClassMethod GetCClassLevel(Type, Flag As %String = "")
{
	n (Type,Flag)
	s char1=$C(1)
	s char2=$C(2)
	s str=""
	s id=0
	f  s id=$O(^User.DHCHMCClassLevelI("CLTypeIndex"," "_Type,id)) q:id=""  d
	.s obj=##class(User.DHCHMCClassLevel).GetObj(id)
	.s active=obj.CLActive
	.q:(Flag'="Y")&&(active="N")
	.s desc=obj.CLDesc
	.s oneStr=id_char2_desc
	.i str="" d
	..s str=oneStr
	.e  d
	..s str=str_char1_oneStr
	s str=##class(web.DHCHM.Tools).ChangeToArrStr(str,char1,char2)
	q str
}

ClassMethod GetCHumanClass(Type, Flag As %String = "")
{
	n (Type,Flag)
	s char1=$C(1)
	s char2=$C(2)
	s str=""
	s id=0
	f  s id=$O(^User.DHCHMCHumanClassI("HCTypeIndex"," "_Type,id)) q:id=""  d
	.s obj=##class(User.DHCHMCHumanClass).GetObj(id)
	.s active=obj.HCActive
	.q:(Flag'="Y")&&(active="N")
	.s desc=obj.HCDesc
	.s oneStr=id_char2_desc
	.i str="" d
	..s str=oneStr
	.e  d
	..s str=str_char1_oneStr
	s str=##class(web.DHCHM.Tools).ChangeToArrStr(str,char1,char2)
	q str
}

ClassMethod GetUser()
{
	s char1=$C(1)
	s char2=$C(2)
	s str=""
	s id=0
	s i=0
	f  s id=$o(^SSU("SSUSR",id)) q:id=""  d
	.s Initials=$p(^SSU("SSUSR",id),"^",11)
	.s i=i+1
	.s name=$p(^SSU("SSUSR",id),"^",2)
	.s oneStr=id_char2_Initials_name
	.i str="" d
	..s str=oneStr
	.e  d
	..s str=str_char1_oneStr
	s str=##class(web.DHCHM.Tools).ChangeToArrStr(str,char1,char2)
	q str
}

ClassMethod GetCServiceClass(Flag)
{
	n (Flag)
	s char1=$C(1)
	s char2=$C(2)
	s str=""
	s id=0
	f  s id=$O(^User.DHCHMCServiceClassD(id)) q:id=""  d
	.s obj=##class(User.DHCHMCServiceClass).GetObj(id)
	.s active=obj.SCActive
	.q:(Flag'="Y")&&(active="N")
	.s desc=obj.SCDesc
	.s oneStr=id_char2_desc
	.i str="" d
	..s str=oneStr
	.e  d
	..s str=str_char1_oneStr
	s str=##class(web.DHCHM.Tools).ChangeToArrStr(str,char1,char2)
	q str
}

/// 得到中医评估下拉选择框  type 1:平和质   0：非平和质
ClassMethod GetZYHabitus(type)
{
	s char1=$C(1)
	s char2=$C(2)
	s str=""
	s desc="倾向是"
	i type=1
	{
		s desc="基本是"
	}
	s str="2"_char2_"是"_char1_"1"_char2_desc_char1_"0"_char2_"不是"
	s str=##class(web.DHCHM.Tools).ChangeToArrStr(str,char1,char2)
	q str
}

/// 得到BMI：1，2，3，4
ClassMethod GetCDC1(type)
{
	s char1=$C(1)
	s char2=$C(2)
	s str=""
	
	s str="1"_char2_"体重过低"_char1_"2"_char2_"体重正常"_char1_"3"_char2_"超重"_char1_"4"_char2_"肥胖"
	s str=##class(web.DHCHM.Tools).ChangeToArrStr(str,char1,char2)
	q str
}

/// 得到 腰围 1 正常 2 不正常
ClassMethod GetCDC2(type)
{
	s char1=$C(1)
	s char2=$C(2)
	s str=""
	
	s str="1"_char2_"正常"_char1_"2"_char2_"不正常"
	s str=##class(web.DHCHM.Tools).ChangeToArrStr(str,char1,char2)
	q str
}

/// 得到血压 1,2,3
ClassMethod GetCDC3(type)
{
	s char1=$C(1)
	s char2=$C(2)
	s str=""
	
	s str="1"_char2_"正常血压"_char1_"2"_char2_"正常高值血压"_char1_"3"_char2_"高血压"
	s str=##class(web.DHCHM.Tools).ChangeToArrStr(str,char1,char2)
	q str
}

/// 血糖 3，2，1
ClassMethod GetCDC4(type)
{
	s char1=$C(1)
	s char2=$C(2)
	s str=""
	
	s str="1"_char2_"正常"_char1_"2"_char2_"空腹血糖受损"_char1_"3"_char2_"糖尿病"
	s str=##class(web.DHCHM.Tools).ChangeToArrStr(str,char1,char2)
	q str
}

/// 得到血脂：1，2，3，4
ClassMethod GetCDC5(type)
{
	s char1=$C(1)
	s char2=$C(2)
	s str=""
	
	s str="1"_char2_"合适范围"_char1_"2"_char2_"边缘升高"_char1_"3"_char2_"升高"_char1_"4"_char2_"降低"
	s str=##class(web.DHCHM.Tools).ChangeToArrStr(str,char1,char2)
	q str
}

/// 得到高血压患者分级：1，2，3，4
ClassMethod GetCDC6(type)
{
	s char1=$C(1)
	s char2=$C(2)
	s str=""
	
	s str="0"_char2_"未患高血压"_char1_"1"_char2_"1 级高血压（轻度）"_char1_"2"_char2_"2 级高血压（中度）"_char1_"3"_char2_"3 级高血压（重度）"
	s str=##class(web.DHCHM.Tools).ChangeToArrStr(str,char1,char2)
	q str
}

/// 得到人群分级：1，2，3
ClassMethod GetCDC0(type)
{
	s char1=$C(1)
	s char2=$C(2)
	s str=""
	
	s str="1"_char2_"慢病患者"_char1_"2"_char2_"慢病高危人群"_char1_"3"_char2_"一般人群"
	s str=##class(web.DHCHM.Tools).ChangeToArrStr(str,char1,char2)
	q str
}

//w ##class(web.DHCHM.GetComboxInfo).GetMagazine("")

/// 得到健康杂志 cxr
ClassMethod GetMagazine(type)
{
	s char1=$C(1)
	s char2=$C(2)
	s str=""
	s id=0
	s i=0
	f  s id=$o(^User.DHCHMCMagazineD(id)) q:id=""  d
	.s obj=##class(User.DHCHMCMagazine).GetObj(id)
	.s theid=id
	.s thename=obj.MDesc
	.s str=str_char1_theid_char2_thename
	s str=##class(web.DHCHM.Tools).ChangeToArrStr(str,char1,char2)
	q str
}

//得到健康管理师列表

//w ##class(web.DHCHM.GetComboxInfo).GetDoctor("责任医生")

//w ##class(web.DHCHM.GetComboxInfo).GetDoctor("")

ClassMethod GetDoctor(type)
{
	s char1=$C(1)
	s char2=$C(2)
	s str=""
	s id=0
	s i=0
	f  s id=$o(^User.DHCHMDoctorD(id)) q:id=""  d
	.s obj=##class(User.DHCHMDoctor).GetObj(id)
	.if type'="" {q:obj.Dtype'=type}
	.q:obj.DActive'="Y"
	.s theid=obj.DCode.%Id()
	.s thename=obj.DCode.SSUSRName
	.s str=str_char1_theid_char2_thename
	s str=##class(web.DHCHM.Tools).ChangeToArrStr(str,char1,char2)
	q str
}

}
