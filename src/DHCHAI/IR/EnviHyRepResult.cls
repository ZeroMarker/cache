/// 名称: DHCHAI.IR.EnviHyRepResult
/// 描述: 环境卫生学监测结果
/// 编写者：liyi
/// 编写日期: 2018-01-15
Class DHCHAI.IR.EnviHyRepResult Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCHAI.IR.EnviHyReport [ Cardinality = parent, Inverse = ChildResult ];

/// 菌落数
Property EHResult As %String(MAXLEN = 100, TRUNCATE = 1);

/// 检出菌/致病菌
Property EHBactDr As DHCHAI.DP.LabBacteria;

/// [作废]标本条码
Property EHSpenBarCode As %String(TRUNCATE = 1);

/// [新增]标本顺序号（大排行）
Property EHSpecNumber As %Integer(MAXVAL = 1000) [ Required ];

/// [新增]结果类型 "EHRstType"（菌落数、大于、小于、检出菌、未检出、阴性等）
Property EHRstTypeDr As DHCHAI.BT.Dictionary;

/// 标本条码 索引
Index IndexOnSpenBarCode On EHSpenBarCode As Exact;

/// 标本顺序号 索引
Index IndexSpecNumber On (Parref, EHSpecNumber);

/// Creator：     liyi
/// CreatDate：   2018-01-15
/// Description:  根据ID取监测结果
/// Table：       DHCHAI.IR.EnviHyRepResult
/// Input：       id:    DHCHAI.IR.EnviHyRepResult.ID
/// Return：      返回Object
/// w ##class(DHCHAI.IR.EnviHyRepResult).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCHAI.IR.EnviHyRepResult
{
	New (id)
	Set return=""
	Quit:id="" return
	Quit:'##class(DHCHAI.IR.EnviHyRepResult).%ExistsId(id) return
	
	Set obj=##Class(DHCHAI.IR.EnviHyRepResult).%OpenId(id)
	Set return=obj
	Do obj.%Close()
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2018-01-15
/// Description:  更新监测结果
/// Table：       DHCHAI.IR.EnviHyRepResult
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.EnviHyRepResult).Update("")
ClassMethod Update(InStr As %String, aSeparete As %String = "^") As %String
{
	New (InStr,aSeparete)
	Set return=0
	Quit:InStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set Parref   	= $p(InStr,aSeparete,1)
	Set Childsub    = $p(InStr,aSeparete,2)
	Set Result		= $p(InStr,aSeparete,3)
	Set BactDr		= $p(InStr,aSeparete,4)
	Set SpenBarCode = $p(InStr,aSeparete,5)
	Set SpecNumber  = +$p(InStr,aSeparete,6)
	Set RstTypeID   = $p(InStr,aSeparete,7)
	Quit:(Parref="") return
	Quit:SpecNumber<1 return
	
	Set objParref = ##class(DHCHAI.IR.EnviHyReport).GetObjById(Parref)
	Quit:'$IsObject(objParref) return
	
	Set Childsub=$o(^DHCHAI.IR.EnviHyReportI("Result","IndexSpecNumber",Parref,SpecNumber,""))
	If Childsub="" {
		Set obj=##class(DHCHAI.IR.EnviHyRepResult).%New()
	} Else {
		Set obj=##class(DHCHAI.IR.EnviHyRepResult).%OpenId(Parref_"||"_Childsub)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Parref 		    = objParref
	Set obj.EHSpecNumber    = SpecNumber
	Set obj.EHRstTypeDr     = ##class(DHCHAI.BT.Dictionary).GetObjById(RstTypeID)
	Set obj.EHResult	    = Result
	Set obj.EHBactDr	    = ##class(DHCHAI.DP.LabBacteria).GetObjById(BactDr)
	Set obj.EHSpenBarCode	= SpenBarCode
	Set sc=obj.%Save()
	if $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set return=-1
	}else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// 判断结果是否全部录入、录入结果是否合格
/// w ##class(DHCHAI.IR.EnviHyRepResult).CheckStandard(3)
ClassMethod CheckStandard(aReportID As %String) As %String
{
	New (aReportID)
	Set return=""
	Quit:(aReportID="") return
	
	Set objRep=##Class(DHCHAI.IR.EnviHyReport).GetObjById(aReportID)
	Quit:'$IsObject(objRep) return
	Quit:'$IsObject(objRep.EHItemDr) return
	Quit:'$IsObject(objRep.EHEnterTypeDr) return
	Set EnterTypeCode=objRep.EHEnterTypeDr.BTCode  //录入方式
	Set SpecimenNum=objRep.EHSpecimenNum           //标本数量
	Set SpecimenNum=+SpecimenNum
	Set CenterNum=objRep.EHCenterNum               //中心点个数
	Set CenterNum=+CenterNum
	Set SurroundNum=objRep.EHSurroundNum           //周边点个数
	Set SurroundNum=+SurroundNum
	Set ReferToNum=objRep.EHReferToNum             //参照点个数
	Set ReferToNum=+ReferToNum
	Set ForMula=objRep.EHItemDr.EHForMula          //计算公式
	Set NormMax=+objRep.EHItemDr.EHNormMax	       //项目值/中心值合格上限
	Set NormMin=+objRep.EHItemDr.EHNormMin	       //周边值合格上限
	Set EHItemTypeDr=objRep.EHItemDr.EHItemTypeDr  //监测项目类型
	Set EHItemTypeDesc=EHItemTypeDr.BTDesc
	Set CenterSurrNum=CenterNum+SurroundNum

	Set ResultSpecNum = CenterSurrNum    
	Set:EnterTypeCode=1 ResultSpecNum=1   //1按项目录入 实际录入结果标本数为1 
	Set:EnterTypeCode=3 ResultSpecNum=2   //3按项目录入（中心+周边）实际录入结果标本数为2 
	Set:objRep.EHApplyDate'="" EHApplyDate=$zd(objRep.EHApplyDate,3)        //申请日期
	Set EHItemDesc=objRep.EHItemDr.EHItemDesc //监测项目名称
	Set EHApplyUserDr=objRep.EHApplyUserDr    //申请人
	Set BTXCode=EHApplyUserDr.BTXCode        //申请人HISID
    Set MsgCode = ##class(DHCHAI.BT.Config).GetValByCode("IREnviMsgCode")
	Set ResultCnt=0,ResultList=""
	Set xSpecNumber=""
	For {
		Set xSpecNumber=$o(^DHCHAI.IR.EnviHyReportI("Result","IndexSpecNumber",aReportID,xSpecNumber))
		Quit:xSpecNumber=""
		
		Set SubID=$o(^DHCHAI.IR.EnviHyReportI("Result","IndexSpecNumber",aReportID,xSpecNumber,""))
		Continue:SubID=""
		Set objResult=##class(DHCHAI.IR.EnviHyRepResult).GetObjById(aReportID_"||"_SubID)
		Continue:'$IsObject(objResult)
		Set RstTypeCode=objResult.EHRstTypeDr.BTCode  //结果类型 "EHRstType"（菌落数、大于、小于、检出菌、未检出、阴性等）
		Set RstTypeDesc=objResult.EHRstTypeDr.BTDesc
		Set Result=objResult.EHResult                 //菌落数
		Set BactID="",BactDesc=""                     //检出菌/致病菌
		If $IsObject(objResult.EHBactDr){
			Set BactID=objResult.EHBactDr.%Id()
			Set BactDesc=objResult.EHBactDr.BTBacDesc
		}
		Set SpecNumber=objResult.EHSpecNumber         //标本顺序号（大排行）
		//Continue:(Result="")&&(BactID="")  //为空也表示录入结果了
		Set ResultCnt=ResultCnt+1
		Set ResultList=ResultList_$lb($lb(RstTypeCode,RstTypeDesc,Result,BactID,BactDesc,SpecNumber))
	}
	
	//判断结果是否已全部录入
	Set IsAllResult=0
	If EnterTypeCode="2" {  //按标本，结果分次录入
		Set:ResultCnt>=SpecimenNum IsAllResult=1
	} Else {  //按标本、其他（1中心+1周边），结果一次性录入
		Set:ResultCnt>0 IsAllResult=1
	}
	
	//判断达标情况（0不合格、1合格）
	Set StandardCode=""
	If IsAllResult>0 {
		//结果已全部录入
		Set StandardCode=1
		
		//首先判断检出菌，检出菌不合格
		For indRst=1:1:$ll(ResultList){
			Quit:indRst>ResultSpecNum  //排除参照点 update 20220623 结果应该大于实际录入结果标本数
			Set tRowInfo=$lg(ResultList,indRst)
			Continue:tRowInfo=""
			
			//$lb(RstTypeCode,RstTypeDesc,Result,BactID,BactDesc,SpecNumber)
			Set tBactID=$lg(tRowInfo,4)
			Set tBactDesc=$lg(tRowInfo,5)
			Continue:(tBactID="")&&(tBactDesc="")
			Set StandardCode=0
			Quit
		}
		// 判断参照点结果阳性就为不合格
		If (ResultSpecNum<$ll(ResultList)){  // update 20220623 参照点大于实际录入结果标本数
			For indRst=(ResultSpecNum+1):1:$ll(ResultList){
				Set tRowInfo=$lg(ResultList,indRst)
				Continue:tRowInfo=""
				
				Set tRstTypeCode=$lg(tRowInfo,1)
				If ((tRstTypeCode=2)||(tRstTypeCode=5)||(tRstTypeCode=8)) {
					//阳性
					Set StandardCode=0
					Quit
				}
			}	
		}
		//其次判断结果值，根据公式计算
		Set (CenterVal,SurroundVal,SpecimenVal)=0
		For indRst=1:1:$ll(ResultList){
			Quit:indRst>ResultSpecNum  //排除参照点 update 20220623 结果应该大于实际录入结果标本数
			Set tRowInfo=$lg(ResultList,indRst)
			Continue:tRowInfo=""
			
			//$lb(RstTypeCode,RstTypeDesc,Result,BactID,BactDesc,SpecNumber)
			Set tRstTypeCode=$lg(tRowInfo,1)
			Set tResult=$lg(tRowInfo,3)
			Set tSpecNumber=$lg(tRowInfo,6)
			Continue:(tResult="")&&(tRstTypeCode'=5)&&(tRstTypeCode'=6)&&(tRstTypeCode'=8)  //无结果，表示无异常
			Continue:(tRstTypeCode=4)  //结果未检出不计入
			If (tRstTypeCode=2)||(tRstTypeCode=8) {
				//大于，表示异常
				Set StandardCode=0
				Quit
			} ElseIf tRstTypeCode=3 {
				//小于，表示无异常
				Set val=0
			}  ElseIf tRstTypeCode=5 {
				//核酸阳性
				Set StandardCode=0
				Quit
			}  ElseIf tRstTypeCode=6 {
				//核酸阴性
				Set val=0
			}  Else{
				Set val=..GetEnviHyResult(ForMula,+tResult)
			}
			If (CenterNum>0)||(SurroundNum>0){    
				If (EnterTypeCode=3){   // update 20210517 按中心+周边只存一个中心，一个周边
					If tSpecNumber=1 {
						Set CenterVal=val
					} Else {
						Set SurroundVal=val
					}
				}Else {
					If tSpecNumber<=CenterNum {
						Set CenterVal=CenterVal+val
					} Else {
						Set SurroundVal=SurroundVal+val
					}
				}
			} Else{
				Set SpecimenVal=SpecimenVal+val
			}
		}
		Set IREnviResult= ##class(DHCHAI.BT.Config).GetValByCode("IREnviResult")
		If (CenterNum>0)||(SurroundNum>0){
			If (EnterTypeCode=1) {  //1按项目录入，只比较中心值，监测项目中控制不能维护周边值标准
				If CenterSurrNum>0 {
					Set:(CenterVal/CenterSurrNum)>(+NormMax) StandardCode=0
				}
			}Else {
				If CenterNum>0 {
					If EHItemTypeDesc="紫外线监测" {
					If (IREnviResult=0){
						Set:(CenterVal/CenterNum)<NormMax StandardCode=0
						}Else{
						   Set:CenterVal<NormMax StandardCode=0
						}
					}
					Else{
						If (IREnviResult=0){
							Set:(CenterVal/CenterNum)>NormMax StandardCode=0
						}Else{
							Set:CenterVal>NormMax StandardCode=0
						 	}
						}
			}
			If SurroundNum>0 {
				If (IREnviResult=0){
						Set:(SurroundVal/SurroundNum)>NormMin StandardCode=0
					}Else{
						Set:SurroundVal>NormMin StandardCode=0
					}
				
				}
			}
		} Else{
			If SpecimenNum>0 {
				If (IREnviResult=0){
					Set:(SpecimenVal/SpecimenNum)>(+NormMax) StandardCode=0
				}Else{
					Set:SpecimenVal>(+NormMax) StandardCode=0
					}
			}
		}
	}
	If (StandardCode=0){
		//不合格进行消息发送
		Set ObjMed = ##class(DHCHAI.BT.SysUser).GetObjByUserCode("HIS01","med")
		Set Message = EHApplyDate_"申请的"_EHItemDesc_"监测项目不合格"
        Set:MsgCode="" MsgCode="2000"
		Set CSMsgDtlID = ##class(DHCHAI.IO.FromHisSrv).SendMsg(Message,MsgCode,$p(ObjMed.BTXCode,"||",2),"",$p(BTXCode,"||",2),"")

	}
	
	Quit StandardCode
}

/// 结果计算公式
ClassMethod GetEnviHyResult(aItemForMula As %String, aResult As %String, ByRef ErrMsg As %String) As %String
{
	New (aItemForMula,aResult,ErrMsg)
	Set return=""
	Quit:aResult="" return
	
	Set $ZT="GetEnviHyResultErr"
	If aItemForMula="" {
		Set return=aResult
	} Else {
		For {
			Quit:aItemForMula'["N"
			Set tmpForMula=$p(aItemForMula,"N",1)
			Set aItemForMula=tmpForMula_aResult_$e(aItemForMula,$l(tmpForMula)+2,$l(aItemForMula))
		}
		If ($e(aItemForMula,1,1)="(")&&($e(aItemForMula,$l(aItemForMula),$l(aItemForMula))=")"){
			Set aItemForMula="Set return="_aItemForMula
		} Else {
			Set aItemForMula="Set return=("_aItemForMula_")"
		}
		X aItemForMula
	}
	Quit return
	
GetEnviHyResultErr
	Set ErrMsg=$ZError
	Quit ""
}

/// Creator：     liyi
/// CreatDate：   2018-01-15
/// Description:  删除监测结果
/// Table：       DHCHAI.IR.EnviHyRepResult
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(Id)
{
	New (Id)
	Set sc = ##class(DHCHAI.IR.EnviHyRepResult).%DeleteId(Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc)
   		Set ret=-1
	}else{
		Set ret=0
	}
	Quit ret
}

Storage Default
{
<Data name="EnviHyRepResultDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EHResult</Value>
</Value>
<Value name="3">
<Value>EHBactDr</Value>
</Value>
<Value name="4">
<Value>EHSpenBarCode</Value>
</Value>
<Value name="5">
<Value>EHSpecNumber</Value>
</Value>
<Value name="6">
<Value>EHRstTypeDr</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("Result")</DataLocation>
<DefaultData>EnviHyRepResultDefaultData</DefaultData>
<IdLocation>{%%PARENT}("Result")</IdLocation>
<IndexLocation>^DHCHAI.IR.EnviHyReportI("Result")</IndexLocation>
<StreamLocation>^DHCHAI.IR.EnviHyRepResultS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
