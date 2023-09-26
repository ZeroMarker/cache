/// 名称: DHCHAI.IR.INFRepExt
/// 描述: 医院感染报告 扩展表
/// 编写者：zhufei
/// 编写日期: 2017-10-19
Class DHCHAI.IR.INFRepExt Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCHAI.IR.INFReport [ Cardinality = parent, Inverse = ChildExt ];

/// 关联代码
Property IRDataType As %String(TRUNCATE = 1) [ Required ];

/// 关联对象
Property IRObjectID As %String(TRUNCATE = 1) [ Required ];

/// 更新日期
Property IRActDate As %Date;

/// 更新时间
Property IRActTime As %Time;

/// 更新人
Property IRActUserDr As DHCHAI.BT.SysUser;

/// 关联历史对象ID
Property IRHistoryObjID As %String(TRUNCATE = 1);

Index IndexTypeObjectID On (IRDataType, IRObjectID);

Index IndexDataType On IRDataType;

Index IndexObjectID On IRObjectID;

Index IndexHisObjectID On (IRDataType, IRHistoryObjID);

/// Creator：     zhoubo
/// CreatDate：   2018-03-21
/// Description:  根据历史报告ID获取关联对象ID
/// Table：       DHCHAI.IR.INFRepExt
/// Input：       DHCHAI.IR.INFRepExt.IRDataType
///               DHCHAI.IR.INFRepExt.IRHistoryObjID
/// Return：      返回String
/// w ##class(DHCHAI.IR.INFRepExt).GetObjIDByHisID("DHCHAI.IR.INFReport","4200")
ClassMethod GetObjIDByHisID(aDataType As %String, aHistoryObjID As %String) As %String
{
	New (aDataType,aHistoryObjID)
	Set return=""
	Quit:(aDataType="")||(aHistoryObjID="") return
	
	Set xRepID=0
	For {
		Set xRepID=$o(^DHCHAI.IR.INFReportI("EXT","IndexHisObjectID"," "_$zcvt(aDataType,"U")," "_$zcvt(aHistoryObjID,"U"),xRepID))
		Quit:xRepID=""
		
		Set objRep=##class(DHCHAI.IR.INFReport).GetObjById(xRepID)
		Continue:'$IsObject(objRep)
		// 关联对象
		Set xSub=0
		For {
			Set xSub=$o(^DHCHAI.IR.INFReportI("EXT","IndexHisObjectID"," "_$zcvt(aDataType,"U")," "_$zcvt(aHistoryObjID,"U"),xRepID,xSub))
			Quit:xSub=""
			Set RepExtID=xRepID_"||"_xSub
			Set obj=##class(DHCHAI.IR.INFRepExt).GetObjById(RepExtID)
			Continue:'$IsObject(obj)
			Set ObjectID=obj.IRObjectID
			Continue:ObjectID=""
			Set return=ObjectID
		}
	}
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-10-19
/// Description:  获取报告信息
/// Table：       DHCHAI.IR.INFRepExt
/// Input：       DHCHAI.IR.INFRepExt.IRDataType
///               DHCHAI.IR.INFRepExt.IRObjectID
/// Return：      返回List
/// w ##class(DHCHAI.IR.INFRepExt).GetINFReports()
ClassMethod GetINFReports(aDataType As %String, aObjectID As %String) As %ListOfDataTypes
{
	New (aDataType,aObjectID)
	Set return=##Class(%ListOfDataTypes).%New()
	Quit:(aDataType="")||(aObjectID="") return
	
	Set xRepID=0
	For {
		Set xRepID=$o(^DHCHAI.IR.INFReportI("EXT","IndexTypeObjectID"," "_$zcvt(aDataType,"U")," "_$zcvt(aObjectID,"U"),xRepID))
		Quit:xRepID=""
		
		Set objRep=##class(DHCHAI.IR.INFReport).GetObjById(xRepID)
		Continue:'$IsObject(objRep)
		Continue:'$IsObject(objRep.IRStatusDr)
		Set StatusCode=objRep.IRStatusDr.BTCode
		Continue:StatusCode=4 //4作废
		Do return.Insert(objRep)
	}
	Quit return
}

/// Creator：     zhaoyj
/// CreatDate：   2022-06-14
/// Description:  获取报告信息
/// Table：       DHCHAI.IR.INFRepExt
/// Input：       DHCHAI.IR.INFRepExt.IRDataType
///               DHCHAI.IR.INFRepExt.IRObjectID
/// Return：      返回List
/// w ##class(DHCHAI.IR.INFRepExt).GetINFReportsAddID("dfd",3)
ClassMethod GetINFReportsAddID(aDataType As %String, aObjectID As %String) As %ListOfDataTypes
{
	New (aDataType,aObjectID)
	Set return=##Class(%ListOfDataTypes).%New()
	Quit:(aDataType="")||(aObjectID="") return
	
	Set xRepID=0
	For {
		Set xRepID=$o(^DHCHAI.IR.INFReportI("EXT","IndexTypeObjectID"," "_$zcvt(aDataType,"U")," "_$zcvt(aObjectID,"U"),xRepID))
		Quit:xRepID=""
		
		Set RepData=$g(^DHCHAI.IR.INFReportD(xRepID))
		Continue:RepData=""
		Set IRStatusDr=$lg(RepData,8)
		Continue:IRStatusDr=""
		Set StatusCode=$lg($g(^DHCHAI.BT.DictionaryD(IRStatusDr)),2)
		Continue:StatusCode=4 //4作废
		Set $List(RepData,1)=xRepID
		Set tmpRepData=RepData_$lb(xRepID)
		Do return.Insert(tmpRepData)
	}
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-10-19
/// Description:  获取报告扩展信息
/// Table：       DHCHAI.IR.INFRepExt
/// Input：       DHCHAI.IR.INFRepExt.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IR.INFRepExt).GetObjById("1||3")
ClassMethod GetObjById(aId As %String) As DHCHAI.IR.INFRepExt
{
	New (aId)
	Set obj=##Class(DHCHAI.IR.INFRepExt).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2017-10-19
/// Description:  保存报告扩展信息
/// Table：       DHCHAI.IR.INFRepExt
/// Input：       aDateType  : 数据类型
///               aObjectIDs : 数据指针（多值“,”号分割）
/// Return：      返回obj
/// w ##class(DHCHAI.IR.INFRepExt).SaveRepExt(2,"AAA","1,2,4","")
ClassMethod SaveRepExt(aReportID As %String, aDataType As %String, aObjectIDs As %String, aActInfo As %String) As %String
{
	New (aReportID,aDataType,aObjectIDs,aActInfo)
	Set return=0
	Quit:(aReportID="")||(aDataType="") return
	
	Set IsError=0
	Set ObjectList=##class(DHCHAI.Utils.CommonSrv).ListFromString(aObjectIDs,",")
	Set ObjectList2=""
	Set xSub=0
	For {
		Set xSub=$o(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt(aDataType,"U"),aReportID,xSub))
		Quit:xSub=""
		
		Set RepExtID=aReportID_"||"_xSub
		Set obj=##class(DHCHAI.IR.INFRepExt).GetObjById(RepExtID)
		Continue:'$IsObject(obj)
		Set ObjectID=obj.IRObjectID
		If $listfind(ObjectList,ObjectID)>0 {
			Set ObjectList2=ObjectList2_$lb(ObjectID)
		} Else {
			Set flg=..DeleteById(RepExtID)
			If (+flg)<0 {
				Set IsError=1
			}
		}
	}
	
	Set ActDate=$p(aActInfo,"^",1)
	Set ActTime=$p(aActInfo,"^",2)
	Set ActUserDr=$p(aActInfo,"^",3)
	For indOL=1:1:$listlength(ObjectList) {
		Set ObjectID=$listget(ObjectList,indOL)
		Continue:ObjectID=""
		Continue:$listfind(ObjectList2,ObjectID)>0
		Set InputStr=aReportID_"^^"_aDataType_"^"_ObjectID_"^"_ActDate_"^"_ActTime_"^"_ActUserDr
		Set flg=..Update(InputStr,"^")
		If (+flg)<0 {
			Set IsError=1
		}
	}
	
	Set:IsError=0 return=1
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2018-03-22
/// Description:  根据报告ID+类型删除报告扩展信息以及删除该类型表的数据
/// Table：       DHCHAI.IR.INFRepExt
/// Input：       aReportID  : 报告ID
///               aDataType  : 数据类型
/// Return：      返回%String 
/// w ##class(DHCHAI.IR.INFRepExt).DelRepExtInfo(1425,"DHCHAI.IR.INFInvOper")
ClassMethod DelRepExtInfo(aReportID As %String, aDataType As %String) As %String
{
	New (aReportID,aDataType)
	Set return=0
	Quit:(aReportID="")||(aDataType="") return
	
	Set xSub=0
	For {
		Set xSub=$o(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt(aDataType,"U"),aReportID,xSub))
		Quit:xSub=""
		
		Set RepExtID=aReportID_"||"_xSub
		Set obj=##class(DHCHAI.IR.INFRepExt).GetObjById(RepExtID)
		Continue:'$IsObject(obj)
		// 关联报告ID
		Set ObjectID = obj.IRObjectID
		Set flg=..DeleteById(RepExtID)
		If (+flg)>=0 {
			Set return=1
			Set Expression = "Do ##Class("_aDataType_").DeleteById(ObjectID)"
			X Expression
		}
	}
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-10-19
/// Description:  保存报告扩展信息
/// Table：       DHCHAI.IR.INFRepExt
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCHAI.IR.INFRepExt).Update("","")
ClassMethod Update(aInput As %String, aSeparate As %String = "^") As %String
{
	New (aInput,aSeparate)
	Set return=""
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Quit:(aSeparete="") return
	
	Set Parref       = $p(aInput,aSeparete,1)
	Set ChildSub     = $p(aInput,aSeparete,2)
	Set DataType     = $p(aInput,aSeparete,3)
	Set ObjectID     = $p(aInput,aSeparete,4)
	Set ActDate      = $p(aInput,aSeparete,5)
	Set ActTime      = $p(aInput,aSeparete,6)
	Set ActUser      = $p(aInput,aSeparete,7)
	Set HistoryObjID = $g(^TMP($j,"SyncInfRep",DataType,ObjectID))
	
	Quit:(Parref="")||(DataType="")||(ObjectID="") return
	
	Set objParref=##class(DHCHAI.IR.INFReport).GetObjById(Parref)
	Quit:'$IsObject(objParref) return
	Set objActUser=##class(DHCHAI.BT.SysUser).GetObjById(ActUser)
	
	Set:ActDate'="" ActDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(ActDate)
	Set:ActTime[":" ActTime = $zth(ActTime,1)
	Set:ActDate="" ActDate=+$h
	Set:ActTime="" ActTime=$p($h,",",2)
	
	Set tID=$o(^DHCHAI.IR.INFReportI("EXT","IndexTypeObjectID"," "_$zcvt(DataType,"U")," "_$zcvt(ObjectID,"U"),Parref,0))
	Quit:(tID'="")&(ChildSub'=tID) -2
	
	If ChildSub="" {
		Set obj=##class(DHCHAI.IR.INFRepExt).%New()
	}Else{
		Set obj=##class(DHCHAI.IR.INFRepExt).%OpenId(Parref_"||"_ChildSub)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Parref         = objParref
	Set obj.IRDataType     = DataType
	Set obj.IRObjectID     = ObjectID
	Set obj.IRActDate      = ActDate	
	Set obj.IRActTime      = ActTime 
	Set obj.IRActUserDr    = objActUser	
	Set obj.IRHistoryObjID = HistoryObjID
	
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-10-19
/// Description:  删除报告扩展信息
/// Table：       DHCHAI.IR.INFRepExt
/// Input：       aId : DHCHAI.IR.INFRepExt.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.IR.INFRepExt).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.IR.INFRepExt).%DeleteId(aId)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=0
	}
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2020-08-13
/// Description:  修改历史ICU调查登记报告保存DHCHAI.IR.INFRepExt结果错误问题
/// Table：       DHCHAI.IR.INFRepExt
/// Return：      返回处理份数
/// w ##class(DHCHAI.IR.INFRepExt).UpdateRepExt()
ClassMethod UpdateRepExt() As %String
{
	Set return=""
    
    Set Count=0
    Set xReportID=""
    For {
		Set xReportID=$o(^DHCHAI.IR.INFReportD(xReportID))
	   	Quit:xReportID=""
	   	
	   	Set objRep = ##class(DHCHAI.IR.INFReport).GetObjById(xReportID)
	   	Continue:'$IsObject(objRep)
		Continue:'$IsObject(objRep.IRStatusDr)
		Continue:'$IsObject(objRep.IREpisodeDr)
	   	Continue:(objRep.IRRepType'=3)  //只处理ICU调查登记表
	   	Set EpisodeDr = objRep.IREpisodeDr.%Id()
	    //删除多余的 DHCHAI.IR.INFPreFactor 记录
	    Set Flg =##class(DHCHAI.IR.INFRepExt).DelRepExtInfo(xReportID,"DHCHAI.IR.INFPreFactor")
	    
	   	Set xUCID = ""     //导尿管
	   	For {
		   	Set xUCID = $o(^DHCHAI.IR.INFICUUCI("IdxofIREpisodeDr",EpisodeDr,xUCID))	
		   	Quit:xUCID=""
		   	Set objUC = ##class(DHCHAI.IR.INFICUUC).GetObjById(xUCID)
			Continue:'$Isobject(objUC)
			//处理导尿管扩展
			Set flg=##class(DHCHAI.IR.INFRepExt).SaveRepExt(xReportID,"DHCHAI.IR.INFICUUC",xUCID,"")
	   	}
	   	Set xVAPID = ""    //呼吸机
	   	For {
		   	Set xVAPID = $o(^DHCHAI.IR.INFICUVAPI("IdxofIREpisodeDr",EpisodeDr,xVAPID))	
		   	Quit:xVAPID=""
		   	
		   	Set objVAP = ##class(DHCHAI.IR.INFICUVAP).GetObjById(xVAPID)
			Continue:'$Isobject(objVAP)
			//处理呼吸机扩展
			Set flg=##class(DHCHAI.IR.INFRepExt).SaveRepExt(xReportID,"DHCHAI.IR.INFICUVAP",xVAPID,"")

	   	}
	   		 
	   	Set xPICCID = ""   //中心静脉置管
	   	For {
		   	Set xPICCID = $o(^DHCHAI.IR.INFICUPICCI("IdxofIREpisodeDr",EpisodeDr,xPICCID))	
		   	Quit:xPICCID=""
		   	
		   	Set objPICC = ##class(DHCHAI.IR.INFICUPICC).GetObjById(xPICCID)
			Continue:'$Isobject(objPICC)
			//处理中心静脉置管扩展
			Set flg=##class(DHCHAI.IR.INFRepExt).SaveRepExt(xReportID,"DHCHAI.IR.INFICUPICC",xPICCID,"")
	   	}
	   	
	  	Set Count=Count+1		
    }
    Set return = Count

	Quit return
}

Storage Default
{
<Data name="INFRepExtDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IRDataType</Value>
</Value>
<Value name="3">
<Value>IRObjectID</Value>
</Value>
<Value name="4">
<Value>IRActDate</Value>
</Value>
<Value name="5">
<Value>IRActTime</Value>
</Value>
<Value name="6">
<Value>IRActUserDr</Value>
</Value>
<Value name="7">
<Value>IRHistoryObjID</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("EXT")</DataLocation>
<DefaultData>INFRepExtDefaultData</DefaultData>
<IdLocation>{%%PARENT}("EXT")</IdLocation>
<IndexLocation>^DHCHAI.IR.INFReportI("EXT")</IndexLocation>
<StreamLocation>^DHCHAI.IR.INFRepExtS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
