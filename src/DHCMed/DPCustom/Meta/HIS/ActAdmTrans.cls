/// 创建者：李阳
/// 创建日期：2013-12-04
/// 功能：对转科记录进行抽取
Class DHCMed.DPCustom.Meta.HIS.ActAdmTrans Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod ExtractData(FromDate As %Date, ToDate As %Date) As %Integer
{
	n (FromDate, ToDate)
	Set ret=0
	For tmpDate=FromDate:1:ToDate {
		Set tmpTime=""
		For {
			Set tmpTime=$o(^PAADMi("TransDateTime",tmpDate,tmpTime))
			Quit:tmpTime=""
			Set Paadm=""
			For {
				Set Paadm=$o(^PAADMi("TransDateTime",tmpDate,tmpTime,Paadm))
				Quit:Paadm=""
				Set ChildSub=""
				For {
					Set ChildSub=$o(^PAADMi("TransDateTime",tmpDate,tmpTime,Paadm,ChildSub))
					Quit:ChildSub=""
					Set id=$$SaveData(Paadm,ChildSub)
					Set:id>0 ret=ret+1
				}
			}
		}
	}
	
	Quit ret
	
SaveData(Paadm,ChildSub)
	n (Paadm,ChildSub)
	Set tmpData=$g(^PAADM(Paadm,"TRANS",ChildSub))
	Quit:tmpData="" -1
	
	Set DeptCode=""
	Set CtlocID=$p(tmpData,"^",6)
	Set objCtloc=##class(DHCMed.Base.Ctloc).GetObjById(CtlocID)
	if ($IsObject(objCtloc)) {
		Set DeptCode=objCtloc.Code
		Do objCtloc.%Close()
	}
	Set WardCode=""
	Set WardID=$p(tmpData,"^",9)
	Set objWard=##class(DHCMed.Base.PacWard).GetObjById(WardID)
	if ($IsObject(objWard)) {
		Set WardCode=objWard.Code
		Do objWard.%Close()
	}	
	
	Set strArg=""
	Set $p(strArg,"^",2)=Paadm_"||"_ChildSub // 转科记录指针
	Set $p(strArg,"^",3)=##class(DHCMed.DPCustom.Meta.HIS.DIC).GetDicMapping("SYS-Dept",DeptCode) // 科室代码
	Set $p(strArg,"^",4)=##class(DHCMed.DPCustom.Meta.HIS.DIC).GetDicMapping("SYS-Ward",WardCode) // 病区代码
	Set $p(strArg,"^",5)="" // 入科来源
	Set $p(strArg,"^",6)="" //出科去向
	Set $p(strArg,"^",7)=$p(tmpData,"^",1) // 转入时间/入院时间
	Set $p(strArg,"^",8)=$p(tmpData,"^",2) // 转出时间/出院时间
	Set $p(strArg,"^",9)="" //入科诊断
	Set ret=##class(DHCMed.DP.Meta.ActAdmTrans).Update(strArg,"^")
	quit ret
}

Storage Default
{
<Data name="ActAdmTransDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^DHCMed.DPServi817D.ActAdmTransD</DataLocation>
<DefaultData>ActAdmTransDefaultData</DefaultData>
<IdLocation>^DHCMed.DPServi817D.ActAdmTransD</IdLocation>
<IndexLocation>^DHCMed.DPServi817D.ActAdmTransI</IndexLocation>
<StreamLocation>^DHCMed.DPServi817D.ActAdmTransS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
