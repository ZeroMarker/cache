/// CTOR: QP
/// DATE: 2020-09-08
/// DESC: 公共方法
Class DHCDoc.GCPSW.COM.Func Extends %RegisteredObject [ ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2020-09-08
/// DESC: 
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.GCPSW.COM.Func).DateLogicalToHtml("")
ClassMethod DateLogicalToHtml(h As %String)
{
	s mRtn=##class(websys.Conversions).DateLogicalToHtml(h)
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-09-08
/// DESC: 
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.GCPSW.COM.Func).DateHtmlToLogical("")
ClassMethod DateHtmlToLogical(h As %String)
{
	s mRtn=##class(websys.Conversions).DateHtmlToLogical(h)
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-09-08
/// DESC: 
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.GCPSW.COM.Func).GetPapmiAge("1")
ClassMethod GetPapmiAge(PatientID = "", admid = "", HospId = "")
{
	//i HospId = "" s HospId=%session.Get("LOGON.HOSPID")
	s mRtn=##class(web.DHCBillInterface).GetPapmiAge(PatientID,admid,HospId)
	//s mRtn=##class(web.DHCSTKUTIL).GetAge(PatientID)
	i mRtn'["岁" s mRtn=1	;
	Q +mRtn
}

/// CTOR: QP
/// DATE: 2020-09-08
/// DESC: 
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.GCPSW.COM.Func).LocDescFormate("1")
ClassMethod LocDescFormate(desc) As %String
{
	q:desc="" desc
	i desc["-",$p(desc,"-",2)'="" s desc=$p(desc,"-",2)
	q desc
}

/// CTOR: QP
/// DATE: 2020-09-17
/// DESC: 工具方法，判断数值包含
/// IN  : 
/// OUT : 
/// 
/// EXEC: w ##class(DHCDoc.GCPSW.COM.Func).InArray("1-3-5",1,"-")
ClassMethod InArray(kssarray As %String, docId As %String, sp = "") As %String
{
	s rtn=0,data=""
	i sp="" s sp=","
	s multiLen=$l(kssarray,sp)
	f len=1:1:multiLen {
		s data=$p(kssarray,sp,len)
		q:data="" 
		i data=docId{
			s rtn=1	
			q
		}
		
	}
	q rtn
}

/// CTOR: QP
/// DATE: 2020-09-21
/// DESC: 判断患者是否包含指定的检验
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.GCPSW.COM.Func).HasLis("")
ClassMethod HasLis(RID, PatientID = "", InArcim = "")
{
	Q:'$d(^BS.DOC.GCPSW.ResultI("ResultAdm","Arcim",RID,InArcim)) 0

	Q 1
}

/// CTOR: QP
/// DATE: 2020-09-21
/// DESC: 判断患者是否包含指定的检验子项
/// IN  : 
/// OUT : 1：满足，0不满足
/// EXEC: w ##class(DHCDoc.GCPSW.COM.Func).HasLisItemNew("","","","")
ClassMethod HasLisItemNew(RID, PatientID = "", arcim = "", ByRef MDList)
{
	/*
	s RID = 477991
	s PatientID = 67054
	s arcim = "21918||1"
	
	s MDList("21206||1","e-J6028")=",1.8^FULL^1"
	s MDList("21206||1","s-J6028")=",1.8^FULL^1"
	s MDList("21541||1","e-J6028")=",1.8^FULL^1"
	s MDList("21541||1","s-J6028")=",1.8^FULL^1"
	s MDList("21646||1","e-J6028")=",1.8^FULL^1"
	s MDList("21646||1","s-J6028")=",1.8^FULL^1"
	s MDList("21912||1","e-J6028")=",1.8^FULL^1"
	s MDList("21912||1","s-J6028")=",1.8^FULL^1"
	s MDList("21918||1","e-J6028")=",1.8^FULL^1"
	s MDList("21918||1","s-J6028")=",1.8^FULL^1"
	s MDList("22018||1","e-J6028")=",1.8^FULL^1"
	s MDList("22018||1","s-J6028")=",1.8^FULL^1"
	*/
	// zw ^BS.DOC.GCPSW.ResultI("ResultLis","ArcimCode",477991)
	//B ;002
	s mRtn=0
	s mcode=""
	f  s mcode=$o(MDList(arcim,mcode)) q:(mcode="")||(mRtn=1)  d
	.s val=$p($g(MDList(arcim,mcode)),"^",1)
	.s SVal=$p(val,",",1)
	.s EVal=$p(val,",",2)
	.s code=mcode
	.i mcode["-" s code=$p(mcode,"-",2)
	.s rule=$p($g(MDList(arcim,mcode)),"^",2)
	.i rule="" s rule="FULL"
	.s section=$p($g(MDList(arcim,mcode)),"^",3)
	.s tempFlag=1
	.i '$D(^BS.DOC.GCPSW.ResultI("ResultLis","ArcimCode",RID,arcim,code)) d
	..i $D(^BS.DOC.GCPSW.ResultI("ResultLis","ArcimCode",RID,arcim,arcim)) s tempFlag=0	;处理bug 问题
	.e  d
	..s tempFlag=0
	.q:tempFlag=1
	.;b ;000
	.s PLID=$O(^BS.DOC.GCPSW.ResultI("ResultLis","ArcimCode",RID,arcim,code,""))
	.i PLID="" s PLID=$O(^BS.DOC.GCPSW.ResultI("ResultLis","ArcimCode",RID,arcim,arcim,""))	;处理bug 问题
	.Q:PLID=""
	.s PAVal=$P(^BS.DOC.GCPSW.ResultD(RID,"L",PLID),"^",3)
	.s isEixt=1
	.;b ;0011
	.i section=1 d
	..i SVal<=PAVal d
	...i EVal>=PAVal s isEixt=0
	.e  d
	..i rule="LIKE" d
	...i PAVal[val s isEixt=0
	..e  d
	...i PAVal=val s isEixt=0
	.Q:isEixt=1
	.s mRtn=1
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-09-21
/// DESC: 判断患者是否包含指定的检验子项
/// IN  : 
/// OUT : 1：满足，0不满足
/// EXEC: w ##class(DHCDoc.GCPSW.COM.Func).HasLis("")
ClassMethod HasLisItem(RID, PatientID = "", arcim = "", ByRef MDList)
{
	s mRtn=0
	s itemFlag="",code=""
	f  s code=$o(MDList(arcim,code)) q:(code="")||(itemFlag=0)  d
	.s val=$p($g(MDList(arcim,code)),"^",1)
	.s rule=$p($g(MDList(arcim,code)),"^",2)
	.s itemFlag=..InLisVal(RID,arcim,code,val,MDList,rule)
	.q:itemFlag=0	//只要有一个条件不满足就退出了
	
	i itemFlag=1 s mRtn=1
	e  s mRtn=0
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-09-21
/// DESC: 根据医嘱项，和子项code，判断时候满足检验要求
/// IN  : 
/// OUT : 1满足，0不满足
/// EXEC: w ##class(DHCDoc.GCPSW.COM.Func).HasLis("")
ClassMethod InLisVal(RID, arcim, code, val, ByRef MDList, rule = "")
{
	
	s codeNew=code
	i code["-" s codeNew=$p(code,"-",2)
	s mRtn=0
	s id=""
	f  s id=$o(^BS.DOC.GCPSW.ResultI("ResultAdm","Arcim",RID,arcim,id)) q:(id="")||(mRtn=1)  d
	.s oeori=$P(^BS.DOC.GCPSW.ResultD(RID,"A",id),"^",2)
	.k LisArr
	.s LisArr=""
	.d ..GetLisArrByOeori(oeori,.LisArr)
	.i $d(LisArr(codeNew)) d
	..s cVal=$g(LisArr(codeNew))
	..i code["s-" d
	...s codeEnd="e-"_codeNew
	...i $d(MDList(arcim,codeEnd)) d
	....s valEnd=$g(MDList(arcim,codeEnd))
	....i (cVal>=val)&&(cVal<=valEnd) s mRtn=1
	...e  d
	....i (cVal>=val) s mRtn=1
	..e  i code["e-" d
	...s codeEnd="s-"_codeNew
	...i $d(MDList(arcim,codeEnd)) d
	....s valEnd=$g(MDList(arcim,codeEnd))
	....i (cVal<=val)&&(cVal>=valEnd) s mRtn=1
	...e  d
	....i (cVal<=val) s mRtn=1
	..e  d
	...i rule="LIKE" d
	....i cVal[val s mRtn=1
	...e  d
	....i cVal=val s mRtn=1
	//w code_": "_val_": "_rule_":"_mRtn
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-09-21
/// DESC: 根据医嘱ID得到LisArr
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.GCPSW.COM.Func).HasLis("")
ClassMethod GetLisArrByOeori(oeori, ByRef LisArr)
{
	s rset=##Class(%ResultSet).%New("LabService.TSResult:GetResultByOrderId")
	i rset.QueryIsValid() { 
		s Status=rset.Execute(oeori)
		i 'Status Quit 0
		While (rset.Next()) {
			s Code=rset.GetDataByName("Code")
			s Result=rset.GetDataByName("Result")
			s LisArr(Code)=Result
		}
		
		d rset.Close()
	}
	
	Q 1
}

/// CTOR: QP
/// DATE: 2020-09-21
/// DESC: 获取患者最近的身高和体重
/// IN  : 
/// OUT : 身高^体重
/// EXEC: w ##class(DHCDoc.GCPSW.COM.Func).GetLastHeightAndWeigh("48")
ClassMethod GetLastHeightAndWeigh(PatientID = "")
{
	s mRtn=""
	Q:PatientID="" mRtn
	
	s type="I"
	s height=0,weight=0
	s episodeId=""
	f{
		s episodeId=$o(^PAPERdr(PatientID,"ADM",type,episodeId),-1)
		q:(episodeId="")||((height'=0)&&(weight'=0))
		s height=+##class(web.DHCDoc.OP.AjaxInterface).GetPatHeight(episodeId)  
		s weight=+##class(web.DHCDoc.OP.AjaxInterface).GetPatWeight(episodeId)
	}
	q height_"^"_weight
}

/// CTOR: QP
/// DATE: 2021-08-06
/// DESC: 获取患者BMI
/// IN  : 身高(CM)^体重(KG)
/// OUT : 
/// EXEC: w ##class(DHCDoc.GCPSW.COM.Func).GetPatBMI(173,62) 
ClassMethod GetPatBMI(Height, Weight) As %String
{
	//计算公式为：BMI=体重（千克）除以身高（米）的平方。
	Q:+Weight=0 ""
	Q:+Height=0 ""
	s BMI=Weight/((Height/100)*(Height/100))
	s BMI=$fn(BMI,"",1)
	Q BMI
}

/// CTOR: QP
/// DATE: 2020-09-21
/// DESC: 获取患者最近的身高和体重
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.GCPSW.COM.Func).GetBMI(0,72)
ClassMethod GetBMI(PH = "", PW = "")
{
	s mRtn=""
	Q:(PH="")||(PW="")||(PH=0) mRtn
	S PH=(PH/100)
	Q:PH=0 mRtn	//协和的库不支持(PH="")||(PW="")||(PH=0) 该写法，只能单独过滤
	s mRtn=(PW)/(PH*PH)
	s mRtn=$num(mRtn,2)
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-09-27
/// DESC: 获取有血常规患者的ID，找到一个就退出
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.GCPSW.COM.Func).GetBloodPatient(1,2,"21485||1","2019-01-01")
ClassMethod GetBloodPatient(PID, MaxNum = "", InArcim = "", InMinDate = "")
{
	s InMinDate=$zdh(InMinDate,3)
	i MaxNum="" s MaxNum=2
	s mRtn="",count=0
	s id=""
 	f  s id=$o(^BS.DOC.GCPSW.ResultI("RPrj",PID,id)) Q:id=""  d
 	.s findFlag=0
 	.q:MaxNum<=count
 	.s PAPMI=$P(^BS.DOC.GCPSW.ResultD(id),"^",2)
 	.s AdmType=""
	.f  s AdmType=$O(^PAPERdr(PAPMI,"ADM",AdmType)) Quit:(AdmType="")||(findFlag=1)  Do
	..s PAAdm=""
	..f  s PAAdm=$O(^PAPERdr(PAPMI,"ADM",AdmType,PAAdm)) Quit:(PAAdm="")||(findFlag=1)   Do
	...s admDate=$p(^PAADM(PAAdm),"^",6)
	...Q:admDate<InMinDate
	...s ord=0
	...f  s ord=$o(^OEORD(0,"Adm",PAAdm,ord)) q:(ord="")||(findFlag=1)   d 
	....s ch=0
	....f  s ch=$o(^OEORD(ord,"I",ch)) q:(ch="")||(findFlag=1)   d
	.....s arcim=$p(^OEORD(ord,"I",ch,1),"^",2)
	.....s oeori=ord_"||"_ch
	.....i arcim=InArcim d
	......s findFlag=1
	......s count=count+1
	......i mRtn="" s mRtn=PAPMI_"^"_oeori_"^"_PAAdm
	......e  s mRtn=mRtn_","_PAPMI_"^"_oeori_"^"_PAAdm
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-11-03
/// DESC: 是否为项目参与者
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.GCPSW.COM.Func).IsPITeam(1,17,1)
ClassMethod IsPITeam(UserID, PPRowID, TeamView = "", addUser = "")
{
	s mRtn=0
	//超级用户自定义设置,多个用逗号拼接
	s superUser=..GetSuperUser()
	s IsSuperUser=..InArray(superUser,UserID,",")
	q:IsSuperUser=1 1
	Q:(UserID="")||(PPRowID="") mRtn
	i TeamView'=1 {
		i addUser=UserID {
			s mRtn=1	
		}
		/*s id=$o(^DHCDocPPC("JoinUserDr",0,UserID,PPRowID,""))
		Q:id="" mRtn
		s mRtn=1*/
	} else {
		i addUser=UserID {
			s mRtn=1	
		}
		//团队可见
		s id=""
		f  s id=$o(^DHCDocPPC(PPRowID,id)) q:(id="")||(mRtn=1)  d
		.s isContact=$p(^DHCDocPPC(PPRowID,id),"^",10)
		.s Tel=$p(^DHCDocPPC(PPRowID,id),"^",11)
		.S joninUser=$p(^DHCDocPPC(PPRowID,id),"^",1)
		.i UserID=joninUser s mRtn=1
		
	}
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2021-01-08
/// DESC: 是否可以编辑
/// IN  : 
/// OUT : 1有权限，0无权限
/// EXEC: w ##class(DHCDoc.GCPSW.COM.Func).IsEdit(3901,11)
ClassMethod IsEdit(UserID, addUser = "")
{
	s OK=1,NO=0
	Q:UserID=addUser OK
	//超级用户自定义设置,多个用逗号拼接
	s superUser=..GetSuperUser()
	s IsSuperUser=..InArray(superUser,UserID,",")
	Q:IsSuperUser=1 OK
	
	Q NO
}

/// CTOR: QP
/// DATE: 2021-01-08
/// DESC: 获取超级管理员
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.GCPSW.COM.Func).GetSuperUser()
ClassMethod GetSuperUser(UserID, addUser = "")
{
	//超级用户自定义设置,多个用逗号拼接
	s mCode="demo"
	s mRtn=""
	f i=1:1:$l(mCode,",") {
		s code=$p(mCode,"^",i)
		s code=$zcvt(code,"U")
		s id=$o(^SSU("SSUSR",0,"SSUSR_Initials",code,""))
		i mRtn="" s mRtn=id
		e  s mRtn=mRtn_","_id	
	}
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-11-12
/// DESC: 根据医嘱项获取药学分类
/// IN  : 
/// OUT : 药学大类ID^大类描述^大类代码^药学子分类ID^药学子分类描述^子分类代码
/// EXEC: w ##class(DHCDoc.GCPSW.COM.Func).GetPhcatByarc("7188||1")
ClassMethod GetPhcatByarc(arcim) As %Library.String
{
	s mRtn=""
	q:arcim="" mRtn
	s mRtn=##class(web.DHCSTINTERFACE).GetPhcatByarc(arcim)
	
    q mRtn
}

}
