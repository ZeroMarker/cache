/// CTOR: QP
/// DATE: 2021-08-26
/// DESC: 医生站交班本业务类
Class DHCDoc.PW.BS.NSubExt Extends %RegisteredObject [ ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2021-08-26
/// DESC: 保存明细扩展
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.BS.NSubExt).Save("","1||1086","")
ClassMethod Save(ID, NID, SID, InPara = "", Type = "") As %String
{
	s CDate=+$h
	s CTime=$P($H,",",2)
	s ZLPlan=$P(InPara,$C(1),1)
	s Question=$P(InPara,$C(1),2)
	s MainAction=$P(InPara,$C(1),3)
	S SUB=$P(SID,"||",2)
	s AdmID=$lg(^User.DHCDocPassWorkNMainD(NID,"ChildSub",SUB),3)
	i ID="" {
		s ID=$O(^User.DHCDocPassWorkNSubExtI("ESID",SID,""))
	}
	i (Type="Add")&&(ID'="") {
		Q 1_"^"	//已经存在不新增
	}
	i ID = "" s SaveOBJ = ##class(User.DHCDocPassWorkNSubExt).%New()
	e  s SaveOBJ = ##class(User.DHCDocPassWorkNSubExt).%OpenId(ID)
	d SaveOBJ.ESIDSetObjectId(SID)
	d SaveOBJ.ENIDSetObjectId(NID)
	i $d(^||BS.PW.NSub.Sync("HasSubmit",AdmID,"Ext")) {
		s EDATA=$g(^||BS.PW.NSub.Sync("HasSubmit",AdmID,"Ext"))
		s SaveOBJ.EMainAction=$lg(EDATA,6)
		s SaveOBJ.EQuestion=$lg(EDATA,5)
		s SaveOBJ.EZLPlan=$lg(EDATA,4)
	} else {
		s SaveOBJ.EMainAction=MainAction
		s SaveOBJ.EQuestion=Question
		s SaveOBJ.EZLPlan=ZLPlan
	}
	
	s sc = SaveOBJ.%Save()
	If $$$ISERR(sc) {
		//d $system.OBJ.DisplayError(sc)
		Quit "-1^保存明细扩展失败！"
	}
	
	Q 1_"^"
}

/// CTOR: QP
/// DATE: 2021-08-26
/// DESC: 保存明细扩展
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.BS.NSubExt).GetEID("4||1152")
ClassMethod GetEID(SID) As %String
{
	Q:SID="" ""
	s EID=$O(^User.DHCDocPassWorkNSubExtI("ESID",SID,""))
	Q EID
}

/// CTOR: QP
/// DATE: 2021-08-26
/// DESC: 修改交班内容
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.BS.NSubExt).EditContentGzthSpecial("1","OutWardNum^2^110^^这是一个测试^4634^")
ClassMethod EditContent(Type = "", UserId = "", SID = "", BCNote = "", AcceptNote = "", ZLPlan = "", EMainAction = "", EQuestion = "") As %String
{
	s mRtn=0
	Q:(SID="")||(UserId="") "-1^参数为空"
	s CurDate=$p($h,",",1),CurTime=$p($h,",",2)
	&SQL(UPDATE SQLUser.DHCDocPassWorkNSub(S_Content,S_SubmitUser,S_SubmitDate,S_SubmitTime,S_FDate,S_FTime,S_FUser,S_AcceptContent,S_AccpetUser,S_AcceptDate,S_AcceptTime) 
				VALUES(:BCNote,:UserId,:CurDate,:CurTime,:CurDate,:CurTime,:UserId,:AcceptNote,:UserId,:CurDate,:CurTime)
				WHERE ID=:SID)
	i SQLCODE {
		Q "-1^保存失败，SQLCODE为："_SQLCODE
	}
	
	s EID=##class(DHCDoc.PW.BS.NSubExt).GetEID(SID)
	;扩展
	s (Plan,Question,MainAction)=""
	i EID'="" {
		s Plan=$lg(^User.DHCDocPassWorkNSubExtD(EID),4)
		s Question=$lg(^User.DHCDocPassWorkNSubExtD(EID),5)
		s MainAction=$lg(^User.DHCDocPassWorkNSubExtD(EID),6)
	}
	i Type="special"  {
		s EMainAction=MainAction
		s EQuestion=Question
	}
	i Type="critical" s ZLPlan=Plan
	&SQL(UPDATE SQLUser.DHCDocPassWorkNSubExt(E_ZLPlan,EQuestion,E_MainAction) 
		VALUES(:ZLPlan,:EQuestion,:EMainAction)
		WHERE E_SID=:SID)
	i SQLCODE {
		Q "-1^保存明细扩展失败，SQLCODE为："_SQLCODE
	}	
		
	Q 1_"^"
}

/// CTOR: QP
/// DATE: 2021-09-07
/// DESC: 删除Sub记录
/// IN  : 
/// OUT : =0成功，其余失败
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.BS.NSubExt).DeleteNSubExt(1)
ClassMethod DeleteNSubExt(NID) As %String
{
	Q:NID="" "-1^参数为空！" 
	&SQL(DELETE FROM SQLUser.DHCDocPassWorkNSubExt WHERE E_NID=:NID)
	Q:SQLCODE'=0 "-1^删除子表扩展记录失败！"
	
	Q SQLCODE
}

}
