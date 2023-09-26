/// 挂号树目录选择业务类
Class web.DHCOPAdmRegTree Extends (%RegisteredObject, %XML.Adaptor)
{

/// 得到医院的数组串,用于挂号目录树的显示
ClassMethod GetHospitalData(LogHosId As %String = "")
{
	s HospitalData=""
	s CTHospitalStr=##class(DHCDoc.Util.Base).GetCTHospitalStr()
	for i=1:1:$l(CTHospitalStr,$c(1)) {
		s OneHosp=$p(CTHospitalStr,$c(1),i)
		s OneHospId=$p(OneHosp,"^",1)
		s OneHospDesc=$p(OneHosp,"^",3)
		continue:(LogHosId'="")&&(OneHospId'=LogHosId)
		i HospitalData="" s HospitalData="["_OneHospId_","""_OneHospDesc_"""]"
		e  s HospitalData=HospitalData_","_"["_OneHospId_","""_OneHospDesc_"""]"
	}
	s HospitalData="["_HospitalData_"]"
	
	q HospitalData
}

ClassMethod GetTreeGroupStr(GroupDesc)
{
	s ^GetTreeLocStrCustom=GroupDesc
	s OneStr="{'id': 'GroupID','text':'LocDesc','leaf':TrueOrFalse,'checked':undefined}"
	s (RetStr,GroupID)=""
		f  s GroupID=$o(^SSU("SSGRP",GroupID)) q:GroupID=""  d		
		.s Desc=$P(^SSU("SSGRP",GroupID),"^",1)
		.s Str=..Replace(OneStr,"GroupID",GroupID)
		.s Str=..Replace(Str,"LocDesc",Desc)
		.s Str=..Replace(Str,"TrueOrFalse","true")
		.i ^SSU("SSGRP","NIGHT")[("^"_GroupID_"^") d
		..s Str=..Replace(Str,"undefined","true")		
		..i RetStr="" d
		...s RetStr=Str
		..e  d
		...s RetStr=RetStr_","_Str
		f  s GroupID=$o(^SSU("SSGRP",GroupID)) q:GroupID=""  d		
		.s Desc=$P(^SSU("SSGRP",GroupID),"^",1)
		.s Str=..Replace(OneStr,"GroupID",GroupID)
		.s Str=..Replace(Str,"LocDesc",Desc)
		.s Str=..Replace(Str,"TrueOrFalse","true")
		.i ^SSU("SSGRP","NIGHT")'[("^"_GroupID_"^") d
		..s Str=..Replace(Str,"undefined","false")		
		..i RetStr="" d
		...s RetStr=Str
		..e  d
		...s RetStr=RetStr_","_Str
	

	i RetStr'="" s RetStr="["_RetStr_"]"
	q RetStr
}

// w ##class(web.DHCOPAdmRegTree).GetTreeLocStrCustom("0^0",2,"")

ClassMethod GetTreeLocStrCustom(LocID, hospitalId, AdmDate As %String = "", GroupID)
{
	;s ^GetTreeLocStrCustom=LocID_","_hospitalId_","_$g(AdmDate)
	
	s OneStr="{'id': 'LocID','text':'LocDesc','leaf':TrueOrFalse}"
	s RetStr=""
	s ID=$P(LocID,"^",1)
	s Type=$P(LocID,"^",2)
	//一级科室
	i Type=0{
		s id=0
		s seq=""
		//f  s seq=$o(^DHCCTLoc(0,"Sequence",seq)) q:seq=""  d
		f  s id=$O(^DHCCTLoc(id)) q:id=""  d
		.s StartDate=$p(^DHCCTLoc(id),"^",3)
		.s EndDate=$p(^DHCCTLoc(id),"^",4)
		.;挂号的树目录一级目录需要考虑
		.q:(StartDate'="")&&(StartDate>+$h)
		.q:(EndDate'="")&&(EndDate<+$h)
		.q:$o(^DHCCTLoc(id,"MINOR",0))=""
		.q:$$CheckMajorLocHospital(id)=0
		.s Desc=$P(^DHCCTLoc(id),"^",1)
		.s Str=..Replace(OneStr,"LocID",id_"^1")
		.s Str=..Replace(Str,"LocDesc",Desc)
		.s Str=..Replace(Str,"TrueOrFalse","false")
		.i RetStr="" d
		..s RetStr=Str
		.e  d
		..s RetStr=RetStr_","_Str
	}
	//二级科室 东西院过滤
	i Type=1{
		s Sub=0
		f  s Sub=$O(^DHCCTLoc(ID,"MINOR",Sub)) q:Sub=""  d
		.s id=$P(^DHCCTLoc(ID,"MINOR",Sub),"^",1)
		.s ActiveFlag=$P(^DHCCTLoc(ID,"MINOR",Sub),"^",2)
		.;挂号的树目录不考虑激活情况,自助需要考虑 20170209 增加控制
		.q:ActiveFlag'=1
		.s Flag="false"
		.s curHospital=$P(^CTLOC(id),"^",22)
		.q:curHospital'=hospitalId
		.s FilterLoc=##class(web.DHCOPRegConfig).CheckLocAuthority(id,GroupID)
		.q:FilterLoc=0
		.s Desc=$P(^CTLOC(id),"^",2)
		.//s Length=$L(Desc,"-")
		.//s Desc=$P(Desc,"-",2,Length)
		.s Desc=##class(web.DHCOPAdmReg).LocDescFormate(Desc)
		.s Str=..Replace(OneStr,"LocID",id_"^2")
		.s Str=..Replace(Str,"LocDesc",Desc)
		.s Str=..Replace(Str,"TrueOrFalse",Flag)
		.i RetStr="" d
		..s RetStr=Str
		.e  d
		..s RetStr=RetStr_","_Str
	}
	//医生
	i Type=2{	
	     //按照科室过滤医生
	     s:AdmDate["-" AdmDate=$zd($zdh(AdmDate,3),4)
	     s DocStr=##class(web.DHCRBResSession).GetResDocBroker(ID,"",AdmDate)
	     b ;DocStr
	     f m=1:1:$L(DocStr,"^") d
	     .s DocMessage=$p(DocStr,"^",m)
	     .s DocID=$p(DocMessage,$C(1),1)
	     .q:DocID=""
	     .s DocDesc=$p(DocMessage,$C(1),2)
	     .s DocDesc=$p(DocDesc," ",1)
	     .s:DocDesc["-" DocDesc=$p(DocDesc,"-",1)
	     .q:$d(^RB("RES",0,"CTPCP",DocID,ID))=0
	     .s RESRowID=$o(^RB("RES",0,"CTPCP",DocID,ID,""))
	     .q:RESRowID=""
	     .s Str=..Replace(OneStr,"LocID",ID_"^"_3_"^"_DocID)
	     .s Str=..Replace(Str,"LocDesc",DocDesc)
		 .s Str=..Replace(Str,"TrueOrFalse","true")
		 .i RetStr="" d
		 ..s RetStr=Str
		 .e  d
		 ..s RetStr=RetStr_","_Str
		
	}
	i RetStr'="" s RetStr="["_RetStr_"]"
	q RetStr
CheckMajorLocHospital(ID)
		s Sub=0
		s counter=0
		s FilterLoc=1
		f  s Sub=$O(^DHCCTLoc(ID,"MINOR",Sub)) q:Sub=""  d
		.s ctlocid=$P(^DHCCTLoc(ID,"MINOR",Sub),"^",1)
		.s curHospital=$P(^CTLOC(ctlocid),"^",22)
		.q:curHospital'=hospitalId
		.s FilterLoc=##class(web.DHCOPRegConfig).CheckLocAuthority(ctlocid,GroupID)
		.q:FilterLoc=0
		.s counter=counter+1
		q counter
}

ClassMethod SaveTreeSequence(str)
{
	 s $zt="error"
	 s length=$L(str,",,,")
	 f m=1:1:length d
	 .s temp=$p(str,",,,",m)
	 .s ID=$p(temp,"^",1)
	 .s seq=$p(temp,"^",2)
	 .q:ID=""
	 .s majorLoc=^DHCCTLoc(ID)
	 .s ^DHCCTLoc(0,"Sequence",seq,ID)=""
	 q ""
error
   s ^ylerror=$ze
   q ""
}

ClassMethod GetLocTree()
{
	s OneStr="{'id': 'LocID','text':'LocDesc','leaf':TrueOrFalse,'checked':undefined}"		
	s RetStr=""
	s id=0
        s CTLocID=""
	 	f  s CTLocID=$o(^RB("RES",0,"CTLOC",CTLocID))	q:CTLocID=""  d	  
		.s Desc=$P(^CTLOC(CTLocID),"^",2)
		.s ActiveFlag=$P(^CTLOC(CTLocID),"^",14)
		.q:ActiveFlag'="Y"
		.q:($d(^PAC("ADMLOC",0,"AdmType","O",CTLocID))'=10)&&($d(^PAC("ADMLOC",0,"AdmType","E",CTLocID))'=10)
		.//s:Desc["-" Desc=$p(Desc,"-",2)
		.s Desc=##class(web.DHCOPAdmReg).LocDescFormate(Desc)
		.s Str=..Replace(OneStr,"LocID",CTLocID)
		.s Str=..Replace(Str,"LocDesc",Desc)
		.s Str=..Replace(Str,"TrueOrFalse","true")
		.i $d(^NightLoc("NIGHT")) d
		..i ^NightLoc("NIGHT")'[("^"_CTLocID_"^") d
		...s Str=..Replace(Str,"undefined","false")
		..e  d
		...s Str=..Replace(Str,"undefined","true")
		.e  d
		..s Str=..Replace(Str,"undefined","false")
		.i RetStr="" d
		..s RetStr=Str
		.e  d
		..s RetStr=RetStr_","_Str
	

	i RetStr'="" s RetStr="["_RetStr_"]"
	q RetStr
}

ClassMethod Replace(Strings, Str, Rep) As %String [ Language = basic ]
{
	return Replace(Strings,Str,Rep)
}

}
