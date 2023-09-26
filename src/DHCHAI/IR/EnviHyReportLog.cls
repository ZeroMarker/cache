/// 名称: DHCHAI.IR.EnviHyReportLog
/// 描述: 环境卫生学监测报告日志
/// 编写者：liyi
/// 编写日期: 2018-01-15
Class DHCHAI.IR.EnviHyReportLog Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCHAI.IR.EnviHyReport [ Cardinality = parent, Inverse = ChildLog ];

/// 更新科室
Property EHUpdateLocDr As DHCHAI.BT.Location;

/// 更新人员
Property EHUpdateUserDr As DHCHAI.BT.SysUser;

/// 更新日期
Property EHUpdateDate As %Date [ Required ];

/// 更新时间
Property EHUpdateTime As %Time [ Required ];

/// 更新状态 EHRepStatus
Property EHUpdateStatusDr As DHCHAI.BT.Dictionary [ Required ];

/// 标本条码
Property EHSpenBarCode As %String(TRUNCATE = 1);

/// [新增]批次号（格式：年月日+8位顺序号 20190900000001）
Property EHBatchNumber As %String(MAXLEN = 100, TRUNCATE = 1);

/// [新增]是否有效（主要用于撤销操作）
Property EHIsActive As %Boolean;

/// [新增]撤销日期
Property EHUpdoDate As %Date;

/// [新增]撤销时间
Property EHUpdoTime As %Time;

/// [新增]撤销操作人
Property EHUpdoUserDr As DHCHAI.BT.SysUser;

/// 标本条码 索引
Index IndexOnSpenBarCode On EHSpenBarCode As Exact;

/// 标本条码+更新状态 索引
Index IndexOnSpenBarCodeStatus On (EHSpenBarCode As Exact, EHUpdateStatusDr As Exact);

/// [新增]批次号 索引
Index IndexBatchNumber On (EHBatchNumber As Exact, EHUpdateStatusDr);

/// [新增]报告+状态 索引
Index IndexReportStatus On (Parref, EHUpdateStatusDr);

/// Creator：     liyi
/// CreatDate：   2018-01-15
/// Description:  报告日志
/// Table：       DHCHAI.IR.EnviHyReportLog
/// Input：       DHCHAI.IR.EnviHyReportLog.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IR.EnviHyReportLog).GetObjById("1||3")
ClassMethod GetObjById(aId As %String) As DHCHAI.IR.EnviHyReportLog
{
	New (aId)
	Set obj=##Class(DHCHAI.IR.EnviHyReportLog).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     liyi
/// CreatDate：   2018-01-15
/// Description:  更新报告日志
/// Table：       DHCHAI.IR.EnviHyReportLog
/// Input：       "^"分隔
/// 1 Parref 2 IRStatusDr 3 IROpinion 4 IRUpdateUserDr
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCHAI.IR.EnviHyReportLog).Update("22^2^9^360","^")
ClassMethod Update(aInput As %String, aSeparate As %String = "^") As %String
{
	New (aInput,aSeparate)
	Set return=""
	
	Set:$g(aSeparate)="" aSeparate=..#SEPARATE
	Quit:(aSeparate="") return
	Set Parref        = $p(aInput,aSeparate,1)
	Set UpdateLocDr   = $p(aInput,aSeparate,2)
	Set UpdateUserDr  = $p(aInput,aSeparate,3)
	Set StatusCode    = $p(aInput,aSeparate,4)
	Set SpecBarcode   = $p(aInput,aSeparate,5)
	Set BactNumber    = $p(aInput,aSeparate,6)
	Set IsActive      = +$p(aInput,aSeparate,7)
	Quit:(Parref="")||(StatusCode="") return
	
	Set objParref=##class(DHCHAI.IR.EnviHyReport).GetObjById(Parref)
	Quit:'$IsObject(objParref) return
	Set objStatus=##class(DHCHAI.BT.Dictionary).GetObjByCode("EHRepStatus",StatusCode)
	Quit:'$IsObject(objStatus) return
	
	Set obj=##Class(DHCHAI.IR.EnviHyReportLog).%New()   //每次都是新增
	Set obj.Parref          = objParref
	Set obj.EHUpdateLocDr   = ##class(DHCHAI.BT.Location).GetObjById(UpdateLocDr)
	Set obj.EHUpdateUserDr  = ##class(DHCHAI.BT.SysUser).GetObjById(UpdateUserDr)
	Set obj.EHUpdateDate    = +$h
	Set obj.EHUpdateTime    = $p($h,",",2)
	Set obj.EHUpdateStatusDr= objStatus
	Set obj.EHSpenBarCode   = SpecBarcode
	Set obj.EHBatchNumber   = BactNumber
	Set obj.EHIsActive      = IsActive
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2019-09-20
/// Description:  获取操作批次号
/// Table：       DHCHAI.IR.EnviHyReportLog
/// Input：       DHCHAI.IR.EnviHyReportLog.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IR.EnviHyReportLog).GetBactNumber()
ClassMethod GetBactNumber()
{
	New
	Set Date=$tr($zd(+$h,3),"-","")
	Set BactNumber=$i(^DHCHAI.IR.EnviHyReportC(Date))
	If $l(BactNumber)<8 {
		Set BactNumber="00000000"_BactNumber
		Set BactNumber=Date_$e(BactNumber,*-7,*)
	} Else {
		Set BactNumber=Date_BactNumber
	}
	Quit BactNumber
}

/// 判断当前操作是否完成
/// w ##class(DHCHAI.IR.EnviHyReportLog).ChecktIsAllDone(128,4)
ClassMethod ChecktIsAllDone(aReportID As %String, aStatusCode As %String) As %String
{
	New (aReportID,aStatusCode)
	Set return=0
	Quit:(aReportID="")||(aStatusCode="") return
	
	Set objStatus=##class(DHCHAI.BT.Dictionary).GetObjByCode("EHRepStatus",aStatusCode)
	Quit:'$IsObject(objStatus) return
	Set StatusDr=objStatus.%Id()
	
	Set objRep=##class(DHCHAI.IR.EnviHyReport).GetObjById(aReportID)
	Quit:'$IsObject(objRep) return
	Quit:'$IsObject(objRep.EHEnterTypeDr) return
	Set ReportID=objRep.%Id()
	Set SpecimenNum=objRep.EHSpecimenNum           //标本数量
	Set ReferToNum=objRep.EHReferToNum             //参照点个数
	
	Set OperaType=..GetOperaType(objRep,aStatusCode)
	If (OperaType=2) {  //按标本
		Set isFinish=0
		Set BarcodeList=""
		For indBar=1:1:SpecimenNum {
			Set SpecBarCode=##class(DHCHAI.IR.EnviHyReport).GetSpenBarCode(ReportID,indBar)
			Continue:SpecBarCode=""
			Set BarcodeList=BarcodeList_$lb(SpecBarCode)
		}
		Set BarcodeList2=""
		Set xSubID=0
		For {
			Set xSubID=$o(^DHCHAI.IR.EnviHyReportI("Log","IndexReportStatus",ReportID,StatusDr,xSubID))
			Quit:xSubID=""
			Set objLog=..GetObjById(ReportID_"||"_xSubID)
			Continue:'$IsObject(objLog)
			Continue:objLog.EHIsActive'=1
			Set Barcode=objLog.EHSpenBarCode
			If Barcode="" {
				Set isFinish=1
				Quit
			} Else {
				Continue:$listfind(BarcodeList,Barcode)<1   //表示条码有效
				Continue:$listfind(BarcodeList2,Barcode)>0  //去除重复执行记录
				Set BarcodeList2=BarcodeList2_$lb(Barcode)
			}
		}
		If isFinish<1 {
			Set:$ll(BarcodeList)=$ll(BarcodeList2) isFinish=1
		}
	} Else {  //按项目
		Set isFinish=0
		Set xSubID=0
		For {
			Set xSubID=$o(^DHCHAI.IR.EnviHyReportI("Log","IndexReportStatus",ReportID,StatusDr,xSubID))
			Quit:xSubID=""
			Set objLog=..GetObjById(ReportID_"||"_xSubID)
			Continue:'$IsObject(objLog)
			Continue:objLog.EHIsActive'=1
			Set isFinish=1
			Quit
		}
	}
	Set return=isFinish
	Quit return
}

/// 获取操作方式(1按项目、2按标本)
ClassMethod GetOperaType(objRep As DHCHAI.IR.EnviHyReport, aStatusCode As %String) As %String
{
	New (objRep,aStatusCode)
	Set return=1
	Quit:'$IsObject(objRep) return
	Quit:'$IsObject(objRep.EHEnterTypeDr) return
	Quit:aStatusCode="" return
	
	Set EnterTypeCode=objRep.EHEnterTypeDr.BTCode  //录入方式
	If ((aStatusCode=3)||(aStatusCode=4))&&(EnterTypeCode=2) {  //接收标本||录入结果、按标本
		Set return=2
	} Else {
		Set return=1
	}
	Quit return
}

Storage Default
{
<Data name="EnviHyReportLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EHUpdateLocDr</Value>
</Value>
<Value name="3">
<Value>EHUpdateUserDr</Value>
</Value>
<Value name="4">
<Value>EHUpdateDate</Value>
</Value>
<Value name="5">
<Value>EHUpdateTIme</Value>
</Value>
<Value name="6">
<Value>EHUpdateStatusDr</Value>
</Value>
<Value name="7">
<Value>EHUpdateTime</Value>
</Value>
<Value name="8">
<Value>EHSpenBarCode</Value>
</Value>
<Value name="9">
<Value>EHBatchNumber</Value>
</Value>
<Value name="10">
<Value>EHIsActive</Value>
</Value>
<Value name="11">
<Value>EHUpdoDate</Value>
</Value>
<Value name="12">
<Value>EHUpdoTime</Value>
</Value>
<Value name="13">
<Value>EHUpdoUserDr</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("Log")</DataLocation>
<DefaultData>EnviHyReportLogDefaultData</DefaultData>
<IdLocation>{%%PARENT}("Log")</IdLocation>
<IndexLocation>^DHCHAI.IR.EnviHyReportI("Log")</IndexLocation>
<StreamLocation>^DHCHAI.IR.EnviHyReportLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
