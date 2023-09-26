/// CTOR: QP
/// DATE: 2021-07-13
/// DESC: 医生站交班本业务类
Class DHCDoc.PW.BS.NMainItem Extends %RegisteredObject [ ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2021-07-14
/// DESC: 保存
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.BS.NMainItem).Save("","1^1")
ClassMethod Save(ID, NID, InPara) As %String
{
	s Code=$P(InPara,"^",1)
	s LocID=$P(InPara,"^",2)
	s Type=$P(InPara,"^",3)
	s BCDate=$P(InPara,"^",4)
	s BCDate=##class(websys.Conversions).DateHtmlToLogical(BCDate)
	s HasFlag=..IsAdd(ID,SID,InPara)
	Q:+HasFlag<0 1_"^"	//已存在就退出
	i ID = "" s SaveOBJ = ##class(User.DHCDocPassWorkNSubType).%New(SID)
	e  s SaveOBJ = ##class(User.DHCDocPassWorkNSubType).%OpenId(ID)
	d SaveOBJ.TParRefSetObjectId(SID)
	d SaveOBJ.TAdmIDSetObjectId(AdmID)
	d SaveOBJ.TLocIDSetObjectId(LocID)
	s SaveOBJ.TBCDate=BCDate
	s SaveOBJ.TType=Type
	
	s sc = SaveOBJ.%Save()
	If $$$ISERR(sc) {
		d $system.OBJ.DisplayError(sc)
		B ;0090 
		Quit "-1^保存类型失败！"
	}
		
	q 1_"^"
}

/// CTOR: QP
/// DATE: 2021-07-08
/// DESC: 判断能否添加
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.CFG.BCLoc).Save("","1^1")
ClassMethod IsAdd(ID, SID, InPara) As %String
{
	s AdmID=$P(InPara,"^",1)
	s Type=$P(InPara,"^",3)
	
	i ID="" {
		i $d(^User.DHCDocPassWorkNSubTypeI("TAdmType",AdmID,Type)) {
			Q "-1^类型已存在！"
		}
	} else {
		s NID=$p(SID,"||",1)
		s sub=$p(SID,"||",2)
		s oldLoc=$lg(^User.DHCDocPassWorkBCMainD(MID,"ChildLoc",sub),2)
		i $d(^User.DHCDocPassWorkBCLocI("BLLoc",LocID,MID)) {
			i oldLoc'=LocID {
				Q "-1^类型已存在！"
			}
		}
	}
	
	Q 0
}

}
