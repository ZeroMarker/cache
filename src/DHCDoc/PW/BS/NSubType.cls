/// CTOR: QP
/// DATE: 2021-07-14
/// DESC: 医生站交班本业务类
Class DHCDoc.PW.BS.NSubType Extends %RegisteredObject [ ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2021-07-14
/// DESC: 保存
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.BS.NSubType).Save("","1^1")
ClassMethod Save(ID, SID, InPara) As %String
{
	s AdmID=$P(InPara,"^",1)
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
	s NID=+SID
	i '$d(^||BS.PW.NMain.Sync(NID,Type)) s ^||BS.PW.NMain.Sync(NID,Type)=1
	e  s ^||BS.PW.NMain.Sync(NID,Type)=^||BS.PW.NMain.Sync(NID,Type)+1
	
		
	q 1_"^"
}

/// CTOR: QP
/// DATE: 2020-09-03
/// DESC: 删除
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.PW.BS.NSubType).Delete("")
ClassMethod DeleteByCode(SID As %String, Code)
{
	s NID=+SID,SUB=$P(SID,"||",2)
	s CH=$o(^User.DHCDocPassWorkNSubTypeI("TType",Code,NID,SUB,""))
	Q:CH="" 0
	S ID=SID_"||"_CH
	&SQL(DELETE FROM SQLUser.DHCDocPassWorkNSubType WHERE ID=:ID)
	//w ID_": "_SQLCODE,!
	Q:SQLCODE'=0 -102
	
	Q 0
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
	s NID=+SID,SUB=$P(SID,"||",2)
	i ID="" {
		i $d(^User.DHCDocPassWorkNSubTypeI("TAdmType",AdmID,Type,NID,SUB)) {
			Q "-1^类型已存在！"
		}
	} else {
		s NID=$p(ID,"||",1)
		s SUB=$p(ID,"||",2)
		s CH=$p(ID,"||",3)
		s oldType=$lg(^User.DHCDocPassWorkNMainD(NID,"ChildSub",SUB,"ChildType",CH),3)
		i $d(^User.DHCDocPassWorkNSubTypeI("TAdmType",AdmID,Type,NID,SUB)) {
			i oldType'=Type {
				Q "-1^类型已存在！"
			}
		}
	}
	
	Q 0
}

}
