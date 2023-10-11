/*
Creater:	jm
CreateDate：2023-02-01
Description:杭州逸曜合理用药统一封装JS
*********************************************
* 1.接口对接模式:不固定ID+不打通
* 2.医嘱审核前调用审查接口,医嘱审核后调用审方接口
	 门诊直接弹出审方界面(dhcdoc.hlyyhzyy.opexam.csp),医生等待审方结果
	 住院单独挂菜单(dhcdoc.hlyyhzyy.ipexam.csp),医生后续自行查看审方界面;同时支持实时审方,下方157行屏蔽即可
* 3.提供给第三方用于审方数据回写的方法,入参是XML格式
	 ##class(DHCDoc.Interface.Outside.HLYYHZYY.Methods).SaveExamResult
*/
$(function(){
	if (typeof Common_ControlObj!="object") return;
	if (typeof Common_ControlObj.InterfaceArr!="object") return;
	//
	var HZYYHLYYObj = {
		Name:"HangZhouYiYao_HLYY",
		//医嘱录入
		OEOrd:{
			//初始化
			xhrRefresh:function(EpisodeID,PAAdmType) {
				PassFuncs.xhrRefresh(EpisodeID,PAAdmType);
			},
			//医嘱录入-审核前
			BeforeUpdate:function(CallBackFunc,EpisodeID,OrderItemStr) {
				PassFuncs.BeforeUpdate(CallBackFunc,EpisodeID,OrderItemStr,"OEOrd");
			},
			//医嘱录入-审核后
			AfterUpdate:function(EpisodeID,PAAdmType,OEOrdItemIDs) {
				PassFuncs.AfterUpdate(EpisodeID,PAAdmType,OEOrdItemIDs);
			}
		},
		CMOEOrd:{
			//中草药录入-审核前
			BeforeUpdate:function(CallBackFunc,EpisodeID,OrderItemStr) {
				PassFuncs.BeforeUpdate(CallBackFunc,EpisodeID,OrderItemStr,"CMOEOrd");
			},
			//中草药录入-审核后
			AfterUpdate:function(EpisodeID,PAAdmType,OEOrdItemIDs) {
				PassFuncs.AfterUpdate(EpisodeID,PAAdmType,OEOrdItemIDs);
			}
		},
		Funcs:{
			//说明书
			YDTS:function(rowid) {
				PassFuncs.YDTS(rowid);
			}
	    }
	}
	Common_ControlObj.InterfaceArr.push(HZYYHLYYObj)
	//
	var PassFuncs={
		LoginInfo:session['LOGON.USERID']+"^"+session['LOGON.CTLOCID'],
		//初始化
		xhrRefresh:function(EpisodeID,PAAdmType) {
			//如果门急诊存在未处理的处方,此处自动弹出 项目决定是否启用
			if (PAAdmType=="I") return;
			var PrescNoStr=$.cm({
				ClassName:"web.DHCDocHLYYHZYY",
				MethodName:"GetPrescNoStrByAdm",
				dataType:"text",
				EpisodeID:EpisodeID
			},false);
			if (PrescNoStr=="")  return;
			PassFuncs.ShowExamResult(EpisodeID,PAAdmType,PrescNoStr);
		},
		BeforeUpdate:function(CallBackFunc,EpisodeID,OrderItemStr,HLYYLayOut){
			try{
				var HLYYInfo=$.cm({
					ClassName:"web.DHCDocHLYYHZYY",
					MethodName:"CheckHLYYInfo",
					dataType:"text",
					EpisodeID:EpisodeID,
					OrderItemStr:OrderItemStr,
					HLYYLayOut:HLYYLayOut,
					ExpStr:PassFuncs.LoginInfo
				},false);
				//不需要调用合理用药或者程序异常
				if ((HLYYInfo=="")||(HLYYInfo==null)||(typeof HLYYInfo=="undefined")) {
					CallBackFunc(true);
					return;
				}
				var HLYYArr=HLYYInfo.split("^");
				if (HLYYArr[0]==0){		//错误等级<8
					if (HLYYArr[1]!="") {
						$.messager.confirm('确认对话框',"合理用药提示:"+"<br>"+HLYYArr[1]+"<br>"+"是否继续审核?", function(r){
							if (r) {CallBackFunc(true);}else{CallBackFunc(false);}
						});
					}else{
						CallBackFunc(true);
					}
				}else if (HLYYArr[0]=="-1"){	//错误等级>=8
					$.messager.alert("提示","合理用药提示:"+"<br>"+HLYYArr[1]+"<br>"+"请返回修改","info",function(){
						CallBackFunc(false);
					});
				}else{
					$.messager.confirm('确认对话框',"合理用药干预系统异常:"+"<br>"+HLYYArr[1]+"<br>"+"请联系信息科!若确认审核医嘱请点击【确定】", function(r){
						if (r) {CallBackFunc(true);}else{CallBackFunc(false);}
					});
				}
				return;
			}catch(e){
				$.messager.alert("提示","合理用药自动验证通过:"+e.message,"info",function(){
					CallBackFunc(true);
				});
			}
		},
		AfterUpdate:function(EpisodeID,PAAdmType,OEOrdItemIDs){
			try{
				var HLYYInfo=$.cm({
					ClassName:"web.DHCDocHLYYHZYY",
					MethodName:"SaveHLYYInfo",
					dataType:"text",
					EpisodeID:EpisodeID,
					OrderStr:OEOrdItemIDs,
					ExpStr:PassFuncs.LoginInfo
				},false);
				//不需要调用合理用药或者程序异常
				if ((HLYYInfo=="")||(HLYYInfo==null)||(typeof HLYYInfo=="undefined")) return;
				//
				var HLYYArr=HLYYInfo.split("^");
				if (HLYYArr[0]!=0){
					$.messager.alert("提示","合理用药保存接口调用失败:"+"<br>"+HLYYArr[1]+"<br>"+"请联系信息科!");
					return false;
				}
				//进入审方系统-不使用可屏蔽
				PassFuncs.Exam(EpisodeID,PAAdmType,OEOrdItemIDs);
			}catch(e){
				$.messager.alert("提示","合理用药系统异常:"+e.message);
				return false;
			}
		},
		Exam:function(EpisodeID,PAAdmType,OEOrdItemIDs){
			var HLYYInfo=$.cm({
				ClassName:"web.DHCDocHLYYHZYY",
				MethodName:"ExamHLYYInfo",
				dataType:"text",
				EpisodeID:EpisodeID,
				OrderStr:OEOrdItemIDs,
				ExpStr:PassFuncs.LoginInfo
			},false);
			//不需要调用合理用药或者程序异常
			if ((HLYYInfo=="")||(HLYYInfo==null)||(typeof HLYYInfo=="undefined")) return;
			//
			var HLYYArr=HLYYInfo.split("^");
			if (HLYYArr[0]!=0){
				$.messager.alert("提示","合理用药审方接口调用失败:"+"<br>"+HLYYArr[1]+"<br>"+"请联系信息科!");
				return false;
			}
			//处理审方结果
			PassFuncs.Limit(EpisodeID,PAAdmType,OEOrdItemIDs);
		},
		Limit:function(EpisodeID,PAAdmType,OEOrdItemIDs){
			if (PAAdmType=="I"){
				//dhcsys_alert("合理用药审方接口调用成功,请切换对应界面查看结果");
				return false;
				var OrderItemStr=$.m({
				    ClassName:"web.DHCDocHLYYHZYY",
				    MethodName:"GetOrderItemStr",
				    OEOrdItemIDs:OEOrdItemIDs,
				},false);
				var PrescNoStr="";
			}else{
				var OrderItemStr="";
				var PrescNoStr=$.cm({
					ClassName:"web.DHCDocHLYYHZYY",
					MethodName:"GetPrescNoStrByOrder",
					dataType:"text",
					OrderStr:OEOrdItemIDs
				},false);
			}
			//判断是否已经自动通过
			var rtn=$.m({
			    ClassName:"web.DHCDocHLYYHZYY",
			    MethodName:"CheckBeforeUse",
			    EpisodeID:EpisodeID,
			    OEORIRowIdStr:OrderItemStr,
				PrescNoStr:PrescNoStr
			},false);
			if (rtn.split("^")[0]=="0") return;
			PassFuncs.ShowExamResult(EpisodeID,PAAdmType,PrescNoStr,OrderItemStr);
		},
		//展示审方结果
		ShowExamResult:function(EpisodeID,PAAdmType,PrescNoStr,OrderItemStr){
			var src="dhcdoc.hlyyhzyy.opexam.csp?EpisodeID="+EpisodeID+"&PrescNoStr="+PrescNoStr;
			if (PAAdmType=="I") {
				src="dhcdoc.hlyyhzyy.ipexam.csp?EpisodeID="+EpisodeID+"&OrderItemStr="+OrderItemStr;
			}
		 	websys_showModal({
				url:src,
				title:'门诊审方',
				width:screen.availWidth-400,
				height:screen.availHeight-200,
				closable:false,
				HYLLStopOrd:function(EpisodeID,PrescNo,CallBackFun){
					new Promise(function(resolve,rejected){
						var rtn=$.m({
						    ClassName:"web.DHCDocHLYYHZYY",
						    MethodName:"CheckPrescExistOrder",
						    PrescNo:PrescNo
						},false);
						if (rtn.split("!")[0]=="1") {
							if (typeof StopPrescList == "function") {
								StopPrescList(PrescNo,resolve)
							}else{
								StopOrd([],resolve,rtn.split("!")[1]);
							}
						}else{
							CallBackFun(true);
							return;
						}
					}).then(function(){
						//界面同步
						if (typeof ReloadGrid == "function") { ReloadGrid("StopOrd"); }
						if (typeof SetScreenSum == "function") { SetScreenSum(); }
						if (typeof OrderMsgChange == "function") { OrderMsgChange(); }
						if (typeof SaveOrderToEMR == "function") { SaveOrderToEMR(); }
					    //合理用药通知
						$.m({
							ClassName:"web.DHCDocHLYYHZYY",
							MethodName:"SignHLYYInfo",
							EpisodeID:EpisodeID,DataStr:PrescNo,SignNotes:"",
							UserID:session['LOGON.USERID'],OperType:"U"
						},function(val){
							//
						});
					    CallBackFun(true);
					})
				}
			});
		},
		//说明书
		YDTS:function(rowid){
			if (GlobalObj.HLYYLayOut=="OEOrd"){
				if(!rowid){
					var ids=$('#Order_DataGrid').jqGrid("getGridParam","selarrrow");
					if(!ids.length){
						$.messager.alert("警告","请选择一条医嘱");  
						return;
					}
					rowid=ids[0];
				}
				var OrderARCIMRowid=GetCellData(rowid,"OrderARCIMRowid");
			}else{
				var OrderARCIMRowid=$("#"+FocusRowIndex+"_OrderARCIMID"+FocusGroupIndex+"").val();
			}
			if ((typeof OrderARCIMRowid=="undefined")||(OrderARCIMRowid==null)||(OrderARCIMRowid=="")) {
				$.messager.alert("警告","请选择一条医嘱");  
				return;  
			}
			var ArcimInfo=tkMakeServerCall("web.DHCDocHLYYInterface","GetArcimInfo",OrderARCIMRowid);
			var OrderARCIMCode=mPiece(ArcimInfo,"^",0);
			var OrderName=mPiece(ArcimInfo,"^",1);
			var linkUrl="http://10.0.20.127:9999/pages/zlcx/data-detail.html?webHisId="+OrderARCIMCode+"&hospitalCode=HBZSYZXYY"
			websys_showModal({
				url:linkUrl,
				title:'药品说明书',
				width:screen.availWidth-200,height:screen.availHeight-200
			});
		}
	}
})
