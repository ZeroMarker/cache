/*
Creater：nk
CreateDate：2022-09-13
FileName：OEOrder.Common.Control.js
Description：对于涉及医嘱插入后或前的前端接口，考虑统一封装一层js（用独立的js）
为实现，这些业务能调用统一的js函数，后续运维修改也只修改一次即可，不用修改多个应用程序

* Update 2023-02-03 jm
* 重新设计封装中间层,独立出对外方法+内部方法
* 封装方法,统一管理第三方接口调用,参照医生站配置->外部接口测试->对外接口接入管理下的关联开启数据

调用说明:
	● InterfaceArr：第三方接口对象，此数组会在加载各接口层JS的时候填充
		接口层示例：Common_ControlObj.InterfaceArr.push(MKHLYYObj)
	● Init：界面初始化，只加载一次
		外层调用方式：Common_ControlObj.Init();
	● xhrRefresh：患者切换初始化
		外层调用方式：Common_ControlObj.xhrRefresh(argObj);
	● BeforeUpdate：医嘱录入审核前调用
		外层调用方式：Common_ControlObj.BeforeUpdate("Interface",myInputObj,resolve);
		入参说明：f:调用的BeforeUpdateFuncs对象中的方法名称(为了解决接口方法内部存在Promise调用后this对象指向被覆盖)
					其余为隐式入参，按具体接口方法传值，一般为(对象格式数据,回调方法)
	● BeforeUpdateFuncs：医嘱录入审核前的验证
		内部调用
		CASignCheck			CA验证接口
		Interface			第三方接口（合理用药、国家医保相关）
		CDSSCheck			CDSS事前预警接口
		CPWCheck			临床路径检查，路径外医嘱填写变异
		ApplyReport			检查检验申请单
		CureApplyReport		治疗申请单
		InsuOrderRules      医保控费
	● AfterUpdate：医嘱录入审核后调用
		外层调用方式：Common_ControlObj.AfterUpdate("Interface",myInputObj,resolve);
		入参说明：f:调用的AfterUpdateFuncs对象中的方法名称(为了解决接口方法内部存在Promise调用后this对象指向被覆盖)
					其余为隐式入参，按具体接口方法传值，一般为(对象格式数据,回调方法)
	● AfterUpdateFuncs：医嘱录入审核后的方法调用
		内部调用
		SynData				数据同步接口（包含医嘱CA认证保存，CDSS医嘱同步、置到达等）
		PrintData 			数据单据打印接口（主要是自动打印检查、病理单据）
		Interface			第三方接口（合理用药、国家医保相关）
		DoOther				其他接口调用
		ExamAutoBook		检查预约接口
		OpenSelectDia		处方关联诊断接口
		SaveOrderToEMR		同步医嘱数据至电子病历
		UpdateInsuRules     医保控费保存后调用医保接口
	● Interface：其他业务调用，比如相互作用、说明书等
		外层调用方式：Common_ControlObj.Interface("XHZY",argObj);
		外层调用方式：Common_ControlObj.Interface("YDTS",argObj);	
	● UtilFuns：工具类
		内部调用
		FormatOrderStr		格式化医嘱审核的医嘱信息串(目前暂未处理)
		ReturnErrData		进行错误信息的提示，并根据提示进行回调是继续审核还是取消审核(合理用药、CDSS、临床路径检查)
		ReturnData			对象返回值(CA验证接口){PassFlag:boolean,Obj:obj}
		AnalysisArg			解析方法入参变量名,并从传入数据中获取到匹配的数据
							入参：回调函数,对象格式业务数据,方法体；出参：按照方法体入参顺序组织的数组				
		AlertErrData		仅进行错误信息的提示
	● LibPhaFunc：临床知识库,因基础数据平台放弃了临床知识库的产品线,后续弃用此方法
		外层调用方式：Common_ControlObj.LibPhaFunc.CheckLibPhaFunction(argObj,CreaterTooltip);
		CheckLibPhaFunction		知识库验证接口
		LinkMesageZSQ			知识库说明书
		CreaterTooltip			创建悬浮框

依赖的js(若需要使用对应封装的接口方法)：
	1、CDSS预警：scripts/dhcdoc/DHCDSS.js
	3、CA验证：scripts/dhcdoc/DHCDoc.CASign.js
	4、治疗申请：scripts/dhcdoc/dhcdoccure_hui/common.service.js
*/
//接口函数封装
var Common_ControlObj=(function(){
	//接口方法,此数组会在加载各接口层JS的时候填充
	var InterfaceArr=new Array();
	//全局初始化
	function Init(){
		$.each(this.InterfaceArr,function(i,obj){
			if ((typeof obj=="object")&&(typeof obj.OEOrd=="object")&&(typeof obj.OEOrd.Init=="function")) {
				obj.OEOrd.Init();
			}
		});
	};
	//局部初始化
	function xhrRefresh(argObj){
		$.each(this.InterfaceArr,function(i,obj){
			if ((typeof obj=="object")&&(typeof obj.OEOrd=="object")&&(typeof obj.OEOrd.xhrRefresh=="function")) {
				var funcName=obj.OEOrd.xhrRefresh.toString();
				var argList=UtilFuns.AnalysisArg("",argObj,funcName)
				if (argList.length==0) {
					obj.OEOrd.xhrRefresh();
				}else{
					obj.OEOrd.xhrRefresh.apply(null,argList);
				}
			}
		});
	};
	//医嘱录入-审核前
	function BeforeUpdate(f){
		var DoFunName=eval("("+"BeforeUpdateFuncs."+f+")");
		var thisCallBack="";
		var argAry=[];
		for(var i=1;i < arguments.length; i++){
			if(typeof arguments[i] == 'function'){
				thisCallBack=arguments[i];
			}
			argAry.push(arguments[i]);
		}
		if(typeof DoFunName == "undefined"){
			for(key in this){
				if(typeof this[key]	=="object"){
					DoFunName=eval("("+"this[key]."+f+")");	
					if(typeof DoFunName != "undefined"){
						break;
					}
				}
			}
		}
		if(typeof DoFunName == "undefined"){
			return UtilFuns.ReturnErrData("接口方法"+f+"不存在.",thisCallBack);
		}
		return DoFunName.apply(this,argAry);	
	};
	var BeforeUpdateFuncs={
		//检查医嘱锁
		checkOrderLock:function(argObj,callBackFun){
			var iArgObj={
				orderRow:"",
				EpisodeID:"",
				EmConsultItm:"",
				SessionStr:""
			}
			$.extend(iArgObj,argObj);
			if(iArgObj.orderRow=="" && iArgObj.EpisodeID==""){
				$.messager.alert("提示", "获取就诊信息错误.","warning");
				callBackFun(false);	
			}
			var ExpStr=iArgObj.EmConsultItm+"^"+iArgObj.EpisodeID;
			$.cm({
				ClassName:"web.DHCDocOrderCommon",
				MethodName:"OrderLock",
				orderrow:iArgObj.orderRow,
				SessionStr:iArgObj.SessionStr,
				LockType:"User.OEOrder",
				ExpStr:ExpStr,
				dataType:"text"
			},function(warning){
				if (warning!=""){
					$.messager.alert("提示", warning,"warning");
					callBackFun(false);
				}else{
					callBackFun(true);
				}
			})
		},
		//CA验证
		CASignCheck:function(argObj,callBackFun) {
			/*argObj={
				callType:调用类型
				isHeaderMenuOpen:是否在头菜单打开签名窗口. 默认true
			}*/
			var iArgObj={
				callType:"OrderSave",
				isHeaderMenuOpen:true	
			}
			$.extend(iArgObj,argObj)
		    new Promise(function(resolve,rejected){
			    var CAObj = {
					"caIsPass": "0"
				}
				if(typeof CASignObj != "undefined"){
					CASignObj.CASignLogin(resolve,iArgObj.callType,iArgObj.isHeaderMenuOpen);
				}else{
					resolve(CAObj);	
				}
			}).then(function(CAObj){
				var myArgObj={};
		    	if (CAObj == false) {
			    	myArgObj = {
				    	PassFlag:false
			    	}
		    	}else{
		    		myArgObj = {
			    		PassFlag:true,
			    		CAObj:CAObj
		    		};
		    	}
		    	return UtilFuns.ReturnData(myArgObj,callBackFun);
			})
		},
		//对外接口
		Interface:function(argObj,callBackFun) {
			var that=this;
			try {
				var ReturnObj={SuccessFlag:true};
				new Promise(function (resolve, rejected) {
					(function (callBackFunExec) {
						function loop(j) {
							new Promise(function (resolve, rejected) {
								var obj=that.InterfaceArr[j];
								if ((typeof obj == "object")&&(typeof obj.OEOrd == "object")&&(typeof obj.OEOrd.BeforeUpdate == "function")) {
									var funcName=obj.OEOrd.BeforeUpdate.toString();
									$.extend(argObj, { CallBackFunc: resolve});
									var argList=UtilFuns.AnalysisArg("",argObj,funcName)
									if (argList.length==0) {
										obj.OEOrd.BeforeUpdate()
									}else{
										obj.OEOrd.BeforeUpdate.apply(null,argList);
									}
								}else{
									resolve(true);
								}
							}).then(function (ret) {
								return new Promise(function (resolve, rejected) {
									if (ret==false || ret.SuccessFlag==false) {
										callBackFun(ret); //方法调用时传入的callBackFun回调方法
								        return false;
									}
									//各个接口如果存在返回值需处理,建议以对象方式返回
									if(typeof(ret)=="object"){
										$.extend(ReturnObj, ret);	
										$.extend(argObj, ret); //前一个接口可能存在更新初始入参的情况（比如医嘱串），下一个接口需用使用更新后的医嘱串
									}
									resolve();
								})
							}).then(function () {
								j++;
								if (j < that.InterfaceArr.length) {
									loop(j);
								} else {
									callBackFunExec();//loop循环调用时传入的resolve方法
								}
							})
						}
						loop(0)
					})(resolve);
				}).then(function () {
					callBackFun(ReturnObj);
				})
			} catch (e) {
				UtilFuns.ReturnErrData("审核前接口异常:"+e.message,callBackFun)
			}
		},
		CDSSCheck:function(argObj,callBackFun) {//CDSS事前预警
			/*argObj={
				OrderItemStr:医嘱信息串
				EpisodeID:就诊ID
			}*/
			try{
				if (typeof CDSSObj=='object'){	
					CDSSObj.CheckOrder(argObj.EpisodeID,argObj.OrderItemStr,callBackFun);
				}else{
					callBackFun(true);	
				}
			}catch(e){
				UtilFuns.ReturnErrData("CDSS事前预警接口调用异常:"+e.message,callBackFun);
			}
		},
		//临床路径检查，路径外医嘱填写变异
		CPWCheck:function(argObj,callBackFun) {
			/*argObj={
				ArcimIDs:医嘱项ID 多个以^分隔
				EpisodeID:就诊ID
			}*/
			try{
				checkOrdItemToVar(argObj.EpisodeID,argObj.ArcimIDs,callBackFun);
			}catch(e){
				UtilFuns.ReturnErrData("临床路径检查接口调用异常:"+e.message,callBackFun);
			}
		},
		//检查检验病历申请单
		ApplyReport:function(argObj,NeedMatchAry,callBackFun) {
			/*argObj={
				OrderItemStr:医嘱信息串
				EpisodeID:就诊ID
				DoctorID:医护人员ID
				LocID:登录科室ID
			}*/
			var UpdateOrderItemStr="",result="",AutoGenARCIMStr="";
			var EpisodeID=argObj.EpisodeID;
			var OrderItemStr=argObj.OrderItemStr;
			var ARCIMStrInfo=$.cm({
				ClassName:"web.DHCDocOrderCommon",
			    MethodName:"GetItemServiceARCIMStrMethod",
			    EpisodeID:EpisodeID,
			    OrderItemStr:OrderItemStr,
			    DoctorID:argObj.DoctorID,
			    LocID:argObj.LocID,
			    dataType:"text"
			},false);
			if (ARCIMStrInfo!=""){
			    new Promise(function(resolve,rejected){
			        var ARCIMStr=mPiece(ARCIMStrInfo,String.fromCharCode(2),0);
			        AutoGenARCIMStr=mPiece(ARCIMStrInfo,String.fromCharCode(2),1);
			        if (ARCIMStr!="") {
			            var lnk=encodeURI("dhcapp.docpopwin.csp?ARCIMStr="+ARCIMStr+"&EpisodeID="+EpisodeID); 
			            websys_showModal({
							url:lnk,
							iconCls:'icon-w-paper',
							title:$g('检查检验申请'),
							width:"95%",height:"95%",
							closable:false,
							CallBackFunc:function(rtnStr){
								websys_showModal("close");
								if (typeof rtnStr=="undefined"){
									rtnStr="";
								}
								if (rtnStr=="") {
									$.messager.alert("提示","检查未填写申请单,请再次点击【审核医嘱】申请或删除检查医嘱.","info",function(){
										callBackFun("");
									});  
								}else{
									result=rtnStr;
									resolve();
								}
							}
						});
			        }else{
				       resolve();
				    }
				}).then(function(){
					return new Promise(function(resolve,rejected){
						//自动生成申请单
				        if (AutoGenARCIMStr!="") {
				            var AutoGenresult=$.cm({
								ClassName:"web.DHCAPPInterface",
							    MethodName:"InsExaReqNo",
							    ListData:AutoGenARCIMStr,
							    dataType:"text"
							},false);
				            if (AutoGenresult!="") {
				                if (result=="") result=AutoGenresult;
				                else result=result+'@'+AutoGenresult;
				            } 
				        }
				        resolve();
			        })
				}).then(function(){
					if (result!="") {
						var UpdateOrderItemStr="";
						//需要重新组织未审核医嘱字符串,拼接上检查申请记录子表Rowid
			            //出参:申请记录子表RowId^医嘱项ID^记录唯一标识@申请记录子表RowId^医嘱项ID^记录唯一标识@申请记录子表RowId^医嘱项ID^记录唯一标识
			            var resultAry=result.split('@');
			            for (var i=0;i<resultAry.length;i++) {
			                var oneResultAry=resultAry[i].split('^');
			                var ApplyArcId=oneResultAry[0];
			                var OrderSeqNo=oneResultAry[2];
			                NeedMatchAry[OrderSeqNo]=ApplyArcId;
			            }
			            var OrderItemAry=OrderItemStr.split(String.fromCharCode(1));
			            for (var i=0;i<OrderItemAry.length;i++) {
			                var oneOrderItemAry=OrderItemAry[i].split('^');
			                var ArcimId=oneOrderItemAry[0];
			                var OrderSeqNo=oneOrderItemAry[19];
			                if (NeedMatchAry[OrderSeqNo]) {
			                    oneOrderItemAry[58]=NeedMatchAry[OrderSeqNo];
			                }
			                var oneOrderItemStr=oneOrderItemAry.join('^');
			                if (UpdateOrderItemStr=="") {UpdateOrderItemStr=oneOrderItemStr;}else{UpdateOrderItemStr=UpdateOrderItemStr+String.fromCharCode(1)+oneOrderItemStr}
			            }
						callBackFun(UpdateOrderItemStr);
					}else{
						callBackFun(OrderItemStr);
					}
				})
		    }else{
		        callBackFun(OrderItemStr);
		    }
		},
		//治疗申请单
		CureApplyReport:function(argObj,CureNeedMatchAry,callBackFun) {
			DHCDocCure_Service.CureApplyReport(argObj,CureNeedMatchAry,callBackFun)
		},
		InsuOrderRules:function(argObj,callBackFun){
			var UpdateOrderItemStr="",result="",AutoGenARCIMStr="";
			var EpisodeID=argObj.EpisodeID;
			var OrderItemStr=argObj.OrderItemStr;
			var OrderList=$.cm({
				ClassName:"DHCDoc.Order.InsuOrderRules",
			    MethodName:"GetAllBeforeOrderInfos",
				OrdItemStr :OrderItemStr, 
				LogonUserId:argObj.UserID, 
				LogonDep:argObj.LocID,
			    dataType:"text"
			},false);
			if ((OrderList!="")&&(argObj.InsuOrderRulesFlag=="Y")){
	                new Promise(function (resolve, rejected) {
		            (function (callBackFunExec) {
              			  new Promise(function (resolve, rejected) {
		            if(argObj.PAAdmType== "I"){ExpressionType="22"}else{ExpressionType="12"} 
	                    CheckOrderByRules(EpisodeID,OrderList,ExpressionType,"1",OrderItemStr,resolve,"")
	                }).then(function (rtnjson) {
		                var OrderItemStr=rtnjson.OldOrderItemStr
		                var OrdItmList=rtnjson.OrdItmList
	                    var Status=rtnjson.Status
						if(Status=="-1"){
							callBackFun(UpdateOrderItemStr);
							return;
					
					   }else if(Status=="0"){
						var InsuOrderItemStr=""
						var NeedMatchAry=new Array();
						for (var k=0;k<rtnjson.OrderList.length;k++) {
							var ArcimCode=rtnjson.OrderList[k].ArcItmCode
							var OrdNum= rtnjson.OrderList[k].OrdNum
							var IsCon=rtnjson.OrderList[k].AuditCate
							var InsuRemark=rtnjson.OrderList[k].OrderCommon
							var DataUID=rtnjson.OrderList[k].DataUID
							NeedMatchAry[OrdNum]= ArcimCode+"^"+ OrdNum  +"^"+ IsCon  +"^"+ InsuRemark  +"^"+ DataUID;
							var OneOrder= ArcimCode+"^"+ OrdNum  +"^"+ IsCon  +"^"+ InsuRemark  +"^"+ DataUID     
						}
						var OrderItemAry=OrderItemStr.split(String.fromCharCode(1));
			            for (var i=0;i<OrderItemAry.length;i++) {
			                var oneOrderItemAry=OrderItemAry[i].split('^');
			                var ArcimId=oneOrderItemAry[0];
			                var OrderSeqNo=oneOrderItemAry[19];
			                if (NeedMatchAry[OrderSeqNo]) {
				                var OneMarginAry=NeedMatchAry[OrderSeqNo].split("^")
				                if (OneMarginAry[2]=="0") continue;
				                if (OneMarginAry[2]=="2"){
					                oneOrderItemAry[22]="N";
					                }
					            if (OneMarginAry[3]!=""){
						            oneOrderItemAry[10]=oneOrderItemAry[10]+","+OneMarginAry[3];
						           }
						        if (OneMarginAry[4]!=""){
							        oneOrderItemAry[95]=OneMarginAry[3];
							        }
			                }
			                var oneOrderItemStr=oneOrderItemAry.join('^');
			                if (UpdateOrderItemStr=="") {UpdateOrderItemStr=oneOrderItemStr;}else{UpdateOrderItemStr=UpdateOrderItemStr+String.fromCharCode(1)+oneOrderItemStr}
			            }		
						}else if(Status=="1"){
							UpdateOrderItemStr=rtnjson.OldOrderItemStr
							}
						callBackFun(UpdateOrderItemStr);
						})
					})(resolve)
	                })
			}else{
				callBackFun(OrderItemStr);	
				}
		}
	};
	//医嘱录入-审核后
	function AfterUpdate(f){
		var DoFunName=eval("("+"AfterUpdateFuncs."+f+")");
		var thisCallBack="";
		var argAry=[];
		for(var i=1;i < arguments.length; i++){
			if(typeof arguments[i] == 'function'){
				thisCallBack=arguments[i];
			}
			argAry.push(arguments[i]);
		}
		if(typeof DoFunName == "undefined"){
			return UtilFuns.AlertErrData("审核后接口方法:"+f+"不存在。",thisCallBack);
		}
		return DoFunName.apply(this,argAry);	
	};
	var AfterUpdateFuncs={
		SynData:function(argObj) {	//数据同步
			if (argObj.caIsPass==1) CASignObj.SaveCASign(argObj.CAObj, argObj.OEOrdItemIDs, "A");
			if(typeof CDSSObj=='object') CDSSObj.SynOrder(argObj.EpisodeID,argObj.OEOrdItemIDs);
			
			//录入医嘱的时候判断到达状态;若未到达则置为到达
		    if ((argObj.LogonDoctorID != "") && (argObj.SetArriveByOrder == 1)) {
		        var ret=$.cm({
					ClassName:"web.DHCDocOrderEntry",
				    MethodName:"SetArrivedStatus",
				    Adm:argObj.EpisodeID,
				    DocDr:argObj.LogonDoctorID,
				    LocId:session['LOGON.CTLOCID'],
				    UserId:session['LOGON.USERID'],
				    dataType:"text"
				},false);
		    }
		},
		PrintData:function(argObj){	//数据单据打印
			var ApplyOrdIdAllStr="";
	        var TempIDs = argObj.OEOrdItemIDs.split("^");
	        var IDsLen = TempIDs.length;
	        for (var k = 0; k < IDsLen; k++) {
	            var TempNewOrdDR = TempIDs[k].split("*");
	            //if (TempNewOrdDR.length < 2) continue;
	            var newOrdIdDR = TempNewOrdDR[1];
	            if (ApplyOrdIdAllStr == "") ApplyOrdIdAllStr = newOrdIdDR;
	            else ApplyOrdIdAllStr = ApplyOrdIdAllStr + "^" + newOrdIdDR;
	        }
	        if (ApplyOrdIdAllStr!=""){
		        Commonprint(ApplyOrdIdAllStr);
	        }
		},
		Interface:function(argObj,callBackFun){	//对外接口
			$.each(this.InterfaceArr,function(i,obj){
				if ((typeof obj == "object")&&(typeof obj.OEOrd == "object")&&(typeof obj.OEOrd.AfterUpdate == "function")) {
					var funcName=obj.OEOrd.AfterUpdate.toString();
					var argList=UtilFuns.AnalysisArg("",argObj,funcName)
					if (argList.length==0) {
						obj.OEOrd.AfterUpdate();
					}else{
						obj.OEOrd.AfterUpdate.apply(null,argList);
					}
				}
			});
		},
		DoOther:function(argObj){	//其他方法调用
			if (typeof window.parent.objControlArry != "undefined") {
		        window.parent.objControlArry['FormNewWin'].objFormShow.formShowData("", 0);
		    } else if (typeof window.parent.parent.objControlArry != "undefined") {
		        window.parent.parent.objControlArry['FormNewWin'].objFormShow.formShowData("", 0);
		    }
		},
		ExamAutoBook:function(argObj,callBakcFun){ //检查预约
			callBakcFun();
			//自动弹出检查资源预约界面 新版为第三方接口存在延时，目前只支持小时钟预约
			/*var ExamItemBookFlag=$.cm({
				ClassName:"web.DHCDocOrderEntry",
			    MethodName:"GetExamItemBook",
			    OrdItemStr:argObj.OEOrdItemIDs,
			    dataType:"text"
			},false);
    		if (ExamItemBookFlag == "1") {
	    		var lnk=$.cm({
					ClassName:"web.DHCDocOrderEntry",
					MethodName:"GetExamItemBookUrl",
					OrdItemStr:argObj.OEOrdItemIDs,
					EpisodeID:argObj.EpisodeID,
					HospId:session['LOGON.HOSPID'],
					dataType:"text"
				},false);
	    		websys_showModal({
					url:maintablis,
					title:'检查预约资源',
					width:1000,height:630,
					onClose: function() {
						callBakcFun();
					}
				});
	    	}else{
		    	callBakcFun();
		    }*/
		},
		OpenSelectDia:function(argObj){ //处方关联诊断
			var EpisodeID=argObj.EpisodeID;
			var OEOrdItemIDs=argObj.OEOrdItemIDs;
			var precnum=tkMakeServerCall("web.DHCDocDiagLinkToPrse","getAllCheckDiaPrce",EpisodeID,session['LOGON.USERID'],OEOrdItemIDs) 
		  	if (precnum!=""){
				//若诊断数量为1,则直接进行诊断与处方关联
				var GridData=$.cm({
					ClassName:"web.DHCDocDiagLinkToPrse",
					QueryName:"GetDiaQuery",
					Adm:EpisodeID,
					Type:"ALL",
					rows:99999
				},false);
				var total=GridData['total'];
				if (total==1){
					var rtn=$.cm({
						ClassName:"web.DHCDocDiagLinkToPrse",
						MethodName:"Insert",
						dataType:"text",
						PrescNoStr:precnum,
						DiagIdStr:GridData['rows'][0]['diaid'],
						UserDr:session['LOGON.USERID'],
					},false);
				}else{
					if (total==0) return;
					var url="dhcdocdiagnoseselect.hui.csp?EpisodeID="+EpisodeID+"&PrescNoStr="+precnum; //+"&ExitFlag="+"Y"
					var winName="SelectDia"; 
					var awidth=screen.availWidth/6*5; 
					var aheight=screen.availHeight/5*4; 
					var atop=(screen.availHeight - aheight)/2;
					var aleft=(screen.availWidth - awidth)/2;
					websys_showModal({
						iconCls:'icon-w-list',
						url:url,
						title:$g('处方关联诊断'),
                        //width:awidth,height:aheight
                        width:"95%",height:"95%"
					})
				}
			}
		},
		SaveOrderToEMR:function(argObj){ //同步医嘱数据至电子病历
			if (argObj.PAAdmType == "I") {
		        return true;
		    }
		    var EpisodeID=argObj.EpisodeID;
		    var OrdList = tkMakeServerCall("EMRservice.BL.opInterface", "getOeordXH", EpisodeID)
			if ((typeof(parent.invokeChartFun) === 'function')||(typeof(parent.parent.invokeChartFun) === 'function')) {
			    if (typeof(parent.invokeChartFun) === 'function'){
				    parent.invokeChartFun('门诊病历', 'updateEMRInstanceData', "oeord", OrdList, "", EpisodeID);
				    parent.invokeChartFun('门急诊病历记录', 'updateEMRInstanceData', "oeord", OrdList, "", EpisodeID);
				}else{
					parent.parent.invokeChartFun('门诊病历', 'updateEMRInstanceData', "oeord", OrdList, "", EpisodeID);
					parent.parent.invokeChartFun('门急诊病历记录', 'updateEMRInstanceData', "oeord", OrdList, "", EpisodeID);
				}
			}
		    return OrdList;
		},
		UpdateInsuRules:function(argObj){
			var OEOrdItemIDs=argObj.OEOrdItemIDs;
			var EpisodeID=argObj.EpisodeID;
			var GridData=$.cm({
					ClassName:"DHCDoc.Order.InsuOrderRules",
					QueryName:"UpdateInsuRules",
					OrderStr:OEOrdItemIDs,
					Adm:EpisodeID,
					rows:99999
				},false);
			return true;
			}
	};
	//统一其它接口调用,比如相互作用,说明书等
	function Interface(func,argObj,callBackFun){
		try {
	    	$.each(this.InterfaceArr,function(i,obj){
				if ((typeof obj == "object")&&(typeof obj.Funcs == "object")&&(typeof obj.Funcs[func] == "function")) {
					var funcName=obj.Funcs[func].toString();
					var argList=UtilFuns.AnalysisArg("",argObj,funcName)
					if (argList.length==0) {
						obj.Funcs[func]();
					}else{
						obj.Funcs[func].apply(null,argList);
					}
				}
			})
		} catch (e) {
			UtilFuns.AlertErrData("对外接口-"+func+"异常:"+e.message,callBackFun)
		}
	};
	var UtilFuns={
		FormatOrderStr:function(argObj){
			//格式化医嘱审核的医嘱信息串
			//目前暂未处理
			/*argObj{
				DataType:需要的数据类型	
				OrderItemStr:初始的医嘱信息串
			}*/
			var FormatOrderData="";
			var DataType=argObj.DataType;
			var OrderItemStr=argObj.OrderItemStr;
			FormatOrderData=OrderItemStr;
			return FormatOrderData;
		},
		ReturnErrData:function(ErrMsg,callBackFun){
			$.messager.confirm('确认对话框', ErrMsg+"<br/>请联系信息科!若确认审核医嘱请点击【确定】", function(r){
				if(typeof callBackFun == 'function'){
					callBackFun(r);
				}else{
					return r;	
				}
			})
		},
		AlertErrData:function(ErrMsg,callBackFun){
			$.messager.alert('警告', ErrMsg+"<br/>请联系信息科!", "info", function(){
				if(typeof callBackFun == 'function'){
					callBackFun(false);
				}else{
					return false;	
				}
			});
		},
		ReturnData:function(argObj,callBackFun){
			var ReturnObj={
				PassFlag:true
			}
			$.extend(ReturnObj, argObj);
			if(typeof callBackFun=="function"){
		    	callBackFun(ReturnObj);
	    	}
	    	return ReturnObj;
		},
		AnalysisArg:function(callBackFun,dataObj,funcName) {
			var argList=[];
			var argStr=funcName.split(")")[0].split("(")[1];
			if (argStr!="") {
				var argArr=argStr.split(",");
				$.each(argArr, function(i,argName){
					var argValue=dataObj[argName];
					if (typeof argValue == "undefined") argValue="";
					argList.push(argValue);
				});
			}
			if(typeof callBackFun == 'function'){
				callBackFun(argList);
			}else{
				return argList;	
			}
		},
		///加载Promise所需文件
		LoadJS:function (){
			$("script").each(function(i,e){
				if(e.src.indexOf("bluebird.min.js")>=0){
					var bluebirdFlag=true;
				}
			});
			if(!bluebirdFlag){
				if (websys_isIE==true) {
					 var script = document.createElement('script');
					 script.type = 'text/javaScript';
					 script.src = '../scripts/dhcdoc/tools/bluebird.min.js';  // bluebird 文件地址
					 document.getElementsByTagName('head')[0].appendChild(script);
				}
			}
		}
	};
	//临床知识库
	var LibPhaFunc={
		ZSKOpenFlag:"N", //是否开启知识库，取代原医嘱录入csp中的ZSKOpen
		Init:function(){
			if(this.ZSKOpenFlag=="Y"){
				/**
				*兼容原来医嘱录入csp中代码
				*if ZSKOpen=1  d
 				*.w "<DIV id='dd'></DIV>"
 				*/
				$("body").append("<DIV id='dd'></DIV>");	
			}
		},
		CheckLibPhaFunction:function(argObj,callBackFun){ //知识库验证
			if(this.ZSKOpenFlag!="Y"){return true;}
			var Type = "";
			var RowIn=argObj.RowIn;
			var Active=argObj.Active;
			var EpisodeID=argObj.EpisodeID;
			var Update=argObj.Update;
			var dialogName=argObj.dialogName;
			var OrderMesage=argObj.OrderMesage;
			//OrderMesage:OrderStr1+ String.fromCharCode(2) + OrderStr2
			//OrderStr:   OrderARCIMRowid + "^" + OrderInstrRowid + "^" + OrderFreqRowid + "^" + OrderDoseQty + "^" + OrderDoseUOMRowid + "^" + OrderPackQty + "^" + OrderPackUOMDr + "^" + OrderDurRowid + "^" + MasterSeqNo + "^" + OrderLabSpecRowid + "^" + OrderOrderBodyPart + "^" + OrderRecDepRowid
		    if ((OrderMesage == "") && (Active != "A")) { return true; }

		    var UserInfo = session['LOGON.USERID'] + "^" + session['LOGON.CTLOCID'] + "^" + session['LOGON.GROUPID'];
		    var OrderItem = "";
		    if (Active == "C") {
		        OrderItem = $.cm({
					ClassName:"web.DHCDocService",
				    MethodName:"GetAdmOrdStr",
				    AdmID:EpisodeID,
				    dataType:"text"  
				},false)
		    }
		    var ReturnStr = $.cm({
				ClassName:"web.DHCDocService",
			    MethodName:"CheckLibPha",
			    AdmID:EpisodeID,
			    ActiveType:Active,
			    OrdIDStr:OrderItem,
			    OrdMesage:OrderMesage,
			    UserInfo:UserInfo,
			    dataType:"text"  
			},false)
		    var ReturnStrArry = ReturnStr.split("^")
		    if (Active=="C"){
		       	var rtn = "0"; //通过 0 1 空
		       	var ControlLev = ""; //限制级别 0 1 空
		      	var Mesage = "";
				if (ReturnStrArry[0]!=""){
					var rtnObj=eval("("+ReturnStrArry[0]+")");
					if (typeof rtnObj=="object"){
					    var rtn=rtnObj[0].passFlag;
					    var ControlLev=rtnObj[0].manLevel;
					    var Mesage=rtnObj[0].retMsg;
					    var tmpMesageStr="";
					    if (Mesage.length>0){
					        for (var i=0;i<Mesage.length;i++){
					            var tmpMesage="";
					            var geneDesc=Mesage[i].geneDesc;
					            var arci=Mesage[i].arci;
					            var seqNo=Mesage[i].seqNo;
					            var oeori=Mesage[i].oeori;
					            var MonitorLogId=Mesage[i].PhMRId; //日志表id，一条问题医嘱一个id
					            var alertMsg="",ZSKLinkItemStr="";
					            for (var j=0;j<Mesage[i].chlidren.length;j++){
					                var onealertMsg=Mesage[i].chlidren[j].alertMsg;
					                var labelDesc=Mesage[i].chlidren[j].labelDesc;
					                if (alertMsg=="") alertMsg=labelDesc+"@"+onealertMsg;
					                else  alertMsg=alertMsg+"!"+labelDesc+"@"+onealertMsg; //
					                
					                var onelinkArci=Mesage[i].chlidren[j].linkArci;
					                var onelinkOeori=Mesage[i].chlidren[j].linkOeori;
					                if (ZSKLinkItemStr="") ZSKLinkItemStr=onelinkArci+String.fromCharCode(13)+onelinkOeori;
					                else ZSKLinkItemStr=ZSKLinkItemStr+String.fromCharCode(14)+onelinkArci+String.fromCharCode(13)+onelinkOeori;
					            }
					            MonitorLogId=MonitorLogId+String.fromCharCode(15)+ZSKLinkItemStr;
					            if(typeof SetCellData=="function"){
						            SetCellData(seqNo,"OrderMonitorId",MonitorLogId);
					            }
					            var tmpMesage=geneDesc+"："+alertMsg; 
					            var blank="&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp"
					            if (tmpMesageStr=="") tmpMesageStr=blank+tmpMesage
					            else tmpMesageStr=tmpMesageStr+"!<br/>"+blank+tmpMesage;
					        }
					        Mesage=tmpMesageStr;
					    }
					}
		      	}
		    }else{
		        var rtn = ReturnStrArry[0]; //通过 0 1 空
		        var ControlLev = ReturnStrArry[1]; //限制级别 0 1 空
		        var Mesage = ReturnStrArry[2];
		    }
		    if (Mesage != "") {
		        Mesage = this.ChangeMesage(Mesage)
		    }
		    //验证
		    if ((rtn != 1) && (Active == "C")) {
			    if ((Update=="Y")&&(ControlLev=="C")&&(rtn=="0")){
		            if (Mesage == "") { 
		               $.messager.alert("警告", "知识库验证限制!"); 
		               return false; 
		            } else { 
		            	var myObj={
				            Row:"",
				            ContenStr:Mesage,
				            timeOut:3,
				            Type:1,
				            dialogName:dialogName
				        }
		               	this.CreaterTooltip(myObj,callBackFun);
		               	return false; 
		            }
		        }
		        if (Update != "Y") {
		            //通过验证但是有警示的在审核的时候不提示
		            if (Mesage != "") {
			            var myObj={
				            Row:"",
				            ContenStr:Mesage,
				            timeOut:2,
				            Type:1,
				            dialogName:dialogName
				        }
			            this.CreaterTooltip(myObj,callBackFun);
			            return true;
			        }
		        }
		    }
		    //查询
		    else if ((Active == "Q") && (RowIn != "")) {
			    var myObj={
		            Row:RowIn,
		            ContenStr:"",
		            timeOut:"",
		            dialogName:dialogName
		        }
		        if (Mesage != "") {
			        $.extend(myObj,{
				       	ContenStr:ReturnStrArry[2],
			            Type:2
				    })
			    }else {
					$.extend(myObj,{
			            Type:4
				    })
				}
				this.CreaterTooltip(myObj,callBackFun);
		    }
		    //建议医嘱
		    else if (Active == "A") {
		        if (Mesage != "") {
		            //AdviceOrderShow(ReturnStrArry[2])
		            var myObj={
			            Row:"",
			            ContenStr:ReturnStrArry[2],
			            timeOut:"",
			            Type:3,
			            dialogName:dialogName
			        }
		            this.CreaterTooltip(myObj,callBackFun)
		        } else {
		            $.messager.alert("警告", '没有建议医嘱!')
		        }
		    }
		    return true;
		},
		LinkMesageZSQ:function(argObj){
			if(this.ZSKOpenFlag!="Y"){return true;}
			
			var OrderARCIMRowid=argObj.OrderARCIMRowid;
			var ExtStr=argObj.OrderItemRowid+"^"+argObj.OrderLabSpecRowid+"^"+argObj.OrderBodyPartID;
			$cm({
				ClassName:"web.DHCDocService",
				MethodName:"GetLinkMesageZSQ",
				OrderARCIMRowid:OrderARCIMRowid,
				ExtStr:ExtStr,
				dataType:"text"
			},function(Data){
				var DataArr=Data.split("^");
				if (DataArr[0]!="0"){
					$.messager.alert("警告",DataArr[1]);
	                return false;
				}else{
					var Url=DataArr[2];
					websys_showModal({
						url:Url,
						title:'说明书',
						width:screen.availWidth-200,height:screen.availHeight-200
					});
				}
			});
		},
		CreaterTooltip:function(argObj,callBackFun){//显示信息
			/*
			argObj:{
				Row:医嘱录入行ID
				ContenStr:知识库信息
				timeOut:可自动隐的信息提示
				Type:提示类型，Type=2 or 3 传入回调方法在各自界面做特殊处理
				dialogName:建议医嘱时需显示dialog的div元素ID名称，默认为"dd"
			}
			*/
			//Type=1：$.messager.show 的提示框
			//Type=3：建议医嘱，需在各自界面加div元素并传入ID名称（dialogName）
			//Type=2：医嘱录入行 浮动窗口显示知识库说明书信息（接口未封装，传入回调方法在各自界面实现）
			//Type=4：销毁医嘱录入行上的tooltip（接口未封装，传入回调方法在各自界面实现）
			var Row=argObj.Row;
			var ContenStr=argObj.ContenStr;
			var timeOut=argObj.timeOut; 
			var Type=argObj.Type;
			var dialogName=argObj.dialogName;
			var pageFromType=argObj.pageFromType;
			if(dialogName=="" || typeof dialogName == 'undefined'){
				dialogName="dd";	
			}
			if (Type == 1) {
		        if (ContenStr == "") return;
		        //显示左上角可自动隐的信息提示 timeOut 定义时间 不能自动匹配宽度 left:0,
		        timeOut = (timeOut * 1000)
		        $.messager.show({
		            title: $g('知识库检测信息'),
		            msg: ContenStr,
		            showType: 'show',
		            width: 650,
					height:'auto',
		            top: 0,
		            maximizable: true,
		            timeout: timeOut,
		            style: {
		                right: '',
		                top: window.document.body.scrollTop + window.document.documentElement.scrollTop,
		                bottom: ''
		            },
		            disabled: false
		        });
		    }else if (Type == 3) {
		        if (ContenStr == "") return;
		        var Len = Math.ceil(ContenStr.length / 1000);
		        var tempContentIndex = Math.random();
		        for (var i = 0; i < Len; i++) {
		            var SplitItemStr = ContenStr.substr(i * 1000, 1000)
		            var ret = tkMakeServerCall('web.DHCDocService', 'SettempContentIndex', tempContentIndex, session['LOGON.USERID'], i + 1, SplitItemStr);
		        }
		        tempContentIndex = session['LOGON.USERID'] + "^" + tempContentIndex;
		        var url = "dhcdoczsk.csp?Mesage=" + "" + "&MesageType=3" + "&tempContentIndex=" + tempContentIndex;
		        $('#'+dialogName).dialog({
		            title: $g('建议医嘱'),
		            width: 600,
		            height: 400,
		            maximizable: true,
		            closed: false,
		            cache: false,
		            href: url,
		            modal: false
		        })
		    }else{ //各个界面处理方式不同，自行处理
				// Row 行
				// ContenStr信息
				// timeOut 停留时间
				// Type 显示模式 =2、3时需特殊处理
				callBackFun(Row, ContenStr, timeOut, Type)
		    }
		},
		ChangeMesage:function(InMesage){ //获取知识库验证医嘱信息
			if (InMesage==undefined){
				return "";
			}
		    InMesage = InMesage.replace(String.fromCharCode(1), '。 ');
		    var MesageArry = InMesage.split("!");
		    var MesageLen = MesageArry.length;
		    var Mesage = "";
		    for (var LenMes = 0; LenMes < MesageLen; LenMes++) {
		        if (MesageArry[LenMes].indexOf("@") >= 0) {
		            var MesageTitle = MesageArry[LenMes].split("@")[0];
		            var MesageTxt = MesageArry[LenMes].split("@")[1];
		            if (MesageTxt == "") continue;
		            if (Mesage == "") {
		                Mesage = MesageTitle + "——" + MesageTxt;
		            } else {
		                Mesage = Mesage + "。" + MesageTitle + "——" + MesageTxt;
		            }
		        }
		    }
		    return Mesage
		}
	}
	return {
		"Init":Init,
		"xhrRefresh":xhrRefresh,
		"BeforeUpdate":BeforeUpdate,
		"AfterUpdate":AfterUpdate,
		"Interface":Interface,
		"InterfaceArr":InterfaceArr,
		"LibPhaFunc":LibPhaFunc
	};
})()
Common_ControlObj.LibPhaFunc.Init();
