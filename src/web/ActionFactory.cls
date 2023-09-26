/// Class Description: 
/// 					Action工厂类,产生Action实例
/// Creator:      	wwh
/// CreatDate:    	20100919
Class web.ActionFactory Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right, Not ProcedureBlock ]
{

/// Creator:      	wwh
/// CreatDate:    	20100919
/// Description: 	获取一个Action处理类的实例
/// Table:        	无
/// Input:        	Action的ID号
/// Output:       	无
/// Return:       	成功:指向Action实例的引用,失败:空引用
/// Others:       	Action的ID号格式为:ProjectID.ModuleID.SubID,例如:BLD.AppForm.Save
ClassMethod GetActionHandler(actionID As %String) As %ObjectHandle
{
	S ret=$$$NULLOREF
	//错误捕获
	S $ZTRAP = "ClassNotExist"

	S clsName=..GetActionHandlerName(actionID)
	Q:'$l(clsName) ret
	S clsMethod="%New"
	S ret=$ZOBJCLASSMETHOD(clsName,clsMethod)
	
	//S clsType=ret.%ClassName(1)
	//判断此类是否为LabService.IActionHandler接口的实现类
	S:'ret.%Extends("web.IActionHandler") ret=$$$NULLOREF

	Q ret
ClassNotExist
	S $ZTRAP = ""
	S ret=$$$NULLOREF
	//W $$$ERROR($$$GeneralError,"Error in GetActionHandler(): "_$ZError)
	Q ret
}

/// Creator:      	wwh
/// CreatDate:    	20100919
/// Description: 	获取一个Action处理类名称
/// Table:        	^DHCLabAction
/// Input:        	Action的ID号
/// Output:       	无
/// Return:       	成功:Action处理类名称,失败:空
/// Others:       	Action的ID号格式为:ProjectID.ModuleID.SubID,例如:BLOOD.AppForm.Save
ClassMethod GetActionHandlerName(actionID As %String) As %String
{
	S ret="",tDeli=$C(2)
	S actionProjectID=$P(actionID,".",1)
	S actionModuleID=$P(actionID,".",2)
	S actionSubID=$P(actionID,".",3)
	Q:('$l(actionProjectID))||('$l(actionModuleID))||('$l(actionSubID)) ret
	
	S dFlag=$D(^DHCLabAction(actionProjectID,actionModuleID,actionSubID))
	Q:dFlag=0 ret
	S clsName=$P($g(^DHCLabAction(actionProjectID,actionModuleID,actionSubID)),tDeli,1)
	Q clsName
}

/// Creator:      	wwh
/// CreatDate:    	20100919
/// Description: 	增加一个Action处理
/// Table:        	^DHCLabAction
/// Input:        	actionID:Action的ID号,clsName:类名,actionDesc:描述,remark:备注
/// Output:       	无
/// Return:       	成功:1,失败:0
/// Others:       	Action的ID号格式为:ProjectID.ModuleID.SubID,例如:BLOOD.AppForm.Save
ClassMethod SaveActionHandler(actionID As %String, clsName As %String, actionDesc As %String, remark As %String, user As %String) As %Boolean
{
	S ret=0,tDeli=$C(2)
	S actionProjectID=$ZCVT($P(actionID,".",1),"U")
	S actionModuleID=$ZCVT($P(actionID,".",2),"U")
	S actionSubID=$ZCVT($P(actionID,".",3),"U")
	Q:('$l(actionProjectID))||('$l(actionModuleID))||('$l(actionSubID)) ret
	
	S dFlag=$D(^DHCLabAction(actionProjectID,actionModuleID,actionSubID))
	Q:dFlag'=0 ret
	S version=""
	S $P(^DHCLabAction(actionProjectID,actionModuleID,actionSubID),tDeli,1)=clsName			//类名
	S $P(^DHCLabAction(actionProjectID,actionModuleID,actionSubID),tDeli,2)=version			//版本
	S $P(^DHCLabAction(actionProjectID,actionModuleID,actionSubID),tDeli,3)=actionDesc		//描述
	S $P(^DHCLabAction(actionProjectID,actionModuleID,actionSubID),tDeli,4)=remark			//备注
	S $P(^DHCLabAction(actionProjectID,actionModuleID,actionSubID),tDeli,5)=$P($h,",",1)	//最后更新日期
	S $P(^DHCLabAction(actionProjectID,actionModuleID,actionSubID),tDeli,6)=$P($h,",",2)	//最后更新时间
	S $P(^DHCLabAction(actionProjectID,actionModuleID,actionSubID),tDeli,7)=user			//用户
    
	S ret=1
	Q ret
}

/// Creator:      	wwh
/// CreatDate:    	20100919
/// Description: 	删除一个Action处理
/// Table:        	^DHCLabAction
/// Input:        	actionID:Action的ID号
/// Output:       	无
/// Return:       	成功:1,失败:0
/// Others:       	Action的ID号格式为:ProjectID.ModuleID.SubID,例如:BLOOD.AppForm.Save
ClassMethod DeleteActionHandler(actionID As %String) As %Boolean
{
	S ret=0,tDeli=$C(2)
	S actionProjectID=$P(actionID,".",1)
	S actionModuleID=$P(actionID,".",2)
	S actionSubID=$P(actionID,".",3)
	Q:('$l(actionProjectID))||('$l(actionModuleID))||('$l(actionSubID)) ret
	S ret=1
	K ^DHCLabAction(actionProjectID,actionModuleID,actionSubID)
	
	Q ret
}

/// Creator:      	wwh
/// CreatDate:    	20100919
/// Description: 	获取所有Action
/// Table:        	^DHCLabAction
/// Input:        	无
/// Output:       	无
/// Return:       	成功:1,失败:0
/// Others:       	无
ClassMethod GetAllActionHandler() As %Integer
{
	S ret=0,tDeli=$C(2)
	K PLIST
	
	S actPrjID="",num=1
	F {
		S actPrjID=$O(^DHCLabAction(actPrjID))
		Q:actPrjID=""
		
		S actMdlID=""
		F {
			S actMdlID=$O(^DHCLabAction(actPrjID,actMdlID))
			Q:actMdlID=""
			
			S actSubID=""
			F {
				S actSubID=$O(^DHCLabAction(actPrjID,actMdlID,actSubID))
				Q:actSubID=""
				
				S actionID=actPrjID_"."_actMdlID_"."_actSubID
				S tData=$g(^DHCLabAction(actPrjID,actMdlID,actSubID))
				
				S clsName=$P(tData,tDeli,1)
				S version=$P(tData,tDeli,2)
				S actionDesc=$P(tData,tDeli,3)
				S remark=$P(tData,tDeli,4)
				S updateDate=$P(tData,tDeli,5)
				S:$l(updateDate) updateDate=$ZD(updateDate,3)
				S updateTime=$P(tData,tDeli,6)
				S:$l(updateTime) updateTime=$ZT(updateTime,2)
				S user=$P(tData,tDeli,7)
				
				S PLIST(num)=actionID_tDeli_actPrjID_tDeli_actMdlID_tDeli_actSubID_tDeli_clsName_tDeli_version_tDeli
				S PLIST(num)=PLIST(num)_actionDesc_tDeli_remark_tDeli_updateDate_tDeli_updateTime_tDeli_user_tDeli
				S num=num+1
				}
			}		
		}
	
	
	S PLIST=$O(PLIST(""),-1)
	S ret=num-1
	
	Q ret
}

}
