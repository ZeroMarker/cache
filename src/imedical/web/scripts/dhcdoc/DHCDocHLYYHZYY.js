/**!
* 日期:   2020-12-24
* 杭州逸曜合理用药js【新版医嘱录入使用】
* 
* V1.0
* Update 2021-12-24
* jm
* 封装合理用药系统方法，防止变量污染;修正该方法可以被医嘱录入和草药录入同时引用
*/

var HZYYLogicObj = {
    ExpStr:session['LOGON.USERID']+"^"+session['LOGON.CTLOCID']
}
if (websys_isIE==true) {
	 var script = document.createElement('script');
	 script.type = 'text/javaScript';
	 script.src = '../scripts/dhcdoc/tools/bluebird.min.js';  // bluebird 文件地址
	 document.getElementsByTagName('head')[0].appendChild(script);
}

///审查方法
function HYLLUpdateClick_HLYY(CallBackFunc,OrderItemStr,Mode){
	if (Mode=="Check") {	//干预
		var rtn=HYLLUpdateClick_Check(CallBackFunc,OrderItemStr);
	}
	if (Mode=="Save") {		//保存
		var rtn=HYLLUpdateClick_Save(CallBackFunc,OrderItemStr);
	}
	if (Mode=="Exam") {		//审方
		var rtn=HYLLUpdateClick_Exam(OrderItemStr);
	}
	if (Mode=="Limit") {	//门诊调用审方后弹框
		var rtn=HYLLUpdateClick_Limit(OrderItemStr);
	}
	return;
}

function HYLLUpdateClick_Check(CallBackFunc,OrderItemStr) {
	var HLYYInfo=$.cm({
		ClassName:"web.DHCDocHLYYHZYY",
		MethodName:"CheckHLYYInfo",
		dataType:"text",
		EpisodeID:GlobalObj.EpisodeID,
		OrderItemStr:OrderItemStr,
		HLYYLayOut:GlobalObj.HLYYLayOut,
		ExpStr:HZYYLogicObj.ExpStr
	},false);
	//var HLYYInfo=tkMakeServerCall("web.DHCDocHLYYHZYY","CheckHLYYInfo",GlobalObj.EpisodeID,OrderItemStr,GlobalObj.HLYYLayOut,HZYYLogicObj.ExpStr);
	if ((HLYYInfo=="")||(HLYYInfo==null)||(typeof HLYYInfo=="undefined")) {
		//不需要调用合理用药或者程序异常
		//return true;
		CallBackFunc(true);
		return;
	}
	var HLYYArr=HLYYInfo.split("^");
	if (HLYYArr[0]==0){
		//错误等级<8
		if (HLYYArr[1]!="") {
			//存在问题提示是否修改
			/*HLYYArr[1]=HLYYArr[1].replace(/\<br>/g, "\n")
			var rtn=dhcsys_confirm("合理用药提示:"+"\n"+HLYYArr[1]+"\n"+"是否继续审核?","","","","500");
			if (rtn) {return true;}else{return false;}*/
			$.messager.confirm('确认对话框',"合理用药提示:"+"<br>"+HLYYArr[1]+"<br>"+"是否继续审核?", function(r){
				if (r) {CallBackFunc(true);}else{CallBackFunc(false);}
			});
		}else{
			//不存在问题
			//return true;
			CallBackFunc(true);
		}
	}else if (HLYYArr[0]==-1){
		//错误等级>=8
		//dhcsys_alert("合理用药提示:"+"<br>"+HLYYArr[1]+"<br>"+"请返回修改","500");
		//return false;
		$.messager.alert("提示", "合理用药提示:"+"<br>"+HLYYArr[1]+"<br>"+"请返回修改", "info",function(){
			CallBackFunc(false);
		});
	}else{
		//var rtn=dhcsys_confirm("合理用药干预系统异常:"+"\n"+HLYYArr[1]+"\n"+"请联系信息科!若确认审核医嘱请点击【确定】","","","","500");
		//if (rtn) {return true;}else{return false;}
		$.messager.confirm('确认对话框',"合理用药干预系统异常:"+"<br>"+HLYYArr[1]+"<br>"+"请联系信息科!若确认审核医嘱请点击【确定】", function(r){
			if (r) {CallBackFunc(true);}else{CallBackFunc(false);}
		});
	}
	return;
}

function HYLLUpdateClick_Save(CallBackFunc,OrderItemStr) {
	var HLYYInfo=$.cm({
		ClassName:"web.DHCDocHLYYHZYY",
		MethodName:"SaveHLYYInfo",
		dataType:"text",
		EpisodeID:GlobalObj.EpisodeID,
		OrderStr:OrderItemStr,
		ExpStr:HZYYLogicObj.ExpStr
	},false);
	//var HLYYInfo=tkMakeServerCall("web.DHCDocHLYYHZYY","SaveHLYYInfo",GlobalObj.EpisodeID,OrderItemStr,HZYYLogicObj.ExpStr);
	//不需要调用合理用药或者程序异常
	if ((HLYYInfo=="")||(HLYYInfo==null)||(typeof HLYYInfo=="undefined")) {
		//return true;
		CallBackFunc(true);
		return;
	}
	var HLYYArr=HLYYInfo.split("^");
	if (HLYYArr[0]!=0){
		//dhcsys_alert("合理用药保存系统异常:"+"<br>"+HLYYArr[1]+"<br>"+"请联系信息科!","500");
		$.messager.alert("提示","合理用药保存系统异常:"+"<br>"+HLYYArr[1]+"<br>"+"请联系信息科!", "info",function(){
			CallBackFunc(true);
		});
	}
	return;
}

function HYLLUpdateClick_Exam(OrderItemStr) {
	var HLYYInfo = $.cm({
		ClassName:"web.DHCDocHLYYHZYY",
		MethodName:"ExamHLYYInfo",
		dataType:"text",
		EpisodeID:GlobalObj.EpisodeID,
		OrderStr:OrderItemStr,
		ExpStr:HZYYLogicObj.ExpStr
	},false);
	//var HLYYInfo=tkMakeServerCall("web.DHCDocHLYYHZYY","ExamHLYYInfo",GlobalObj.EpisodeID,OrderItemStr,HZYYLogicObj.ExpStr);
	if ((HLYYInfo=="")||(HLYYInfo==null)||(typeof HLYYInfo=="undefined")) {		//不需要调用合理用药或者程序异常
		return true;
	}
	var HLYYArr=HLYYInfo.split("^");
	if (HLYYArr[0]!=0){
		dhcsys_alert("合理用药审方接口调用失败:"+"<br>"+HLYYArr[1]+"<br>"+"请联系信息科!","500");
		return false;
		/*$.messager.alert("提示","合理用药审方接口调用失败:"+"<br>"+HLYYArr[1]+"<br>"+"请联系信息科!", "info",function(){
			return false;
		});*/
	}
	if (GlobalObj.PAAdmType=="I") {
		//dhcsys_alert("合理用药审方接口调用成功,请切换对应界面查看结果");
	}
	return true;
}

//说明书
function HLYYYDTS_Click(rowid){
	if (GlobalObj.HLYYLayOut=="OEOrd"){
		//选中一行
		if(!rowid){
			var ids =$('#Order_DataGrid').jqGrid("getGridParam", "selarrrow");
			if(!ids.length){
				$.messager.alert("警告","请选择一条医嘱");  
				return;
			}
			rowid=ids[0];
		}
		var OrderARCIMRowid = GetCellData(rowid, "OrderARCIMRowid");
	}else{
		var OrderARCIMRowid=$("#"+FocusRowIndex+"_OrderARCIMID"+FocusGroupIndex+"").val();
	}
	if (typeof OrderARCIMRowid=="undefined" || OrderARCIMRowid==null || OrderARCIMRowid==""){
		$.messager.alert("警告","请选择一条医嘱");  
		return;  
	}
	var ArcimInfo=tkMakeServerCall("web.DHCDocHLYYInterface","GetArcimInfo",OrderARCIMRowid);
	var OrderARCIMCode=mPiece(ArcimInfo,"^",0);
	var OrderName=mPiece(ArcimInfo,"^",1);
	var linkUrl="http://192.170.206.201:8080/zlcx/data_detail.action?webHisId="+OrderARCIMCode;
	//window.open(linkurl,"","status=1,scrollbars=1,top=100,left=100,width=760,height=420");
	websys_showModal({
		url:linkUrl,
		title:'药品说明书',
		width:screen.availWidth-200,height:screen.availHeight-200
	});
}

function HYLLUpdateClick_Limit(OrderItemStr) {
	if (GlobalObj.PAAdmType=="I") {
		return true;
	}
	var PrescNoStr=$.cm({
		ClassName:"web.DHCDocHLYYHZYY",
		MethodName:"GetPrescNoStrByOrder",
		dataType:"text",
		OrderStr:OrderItemStr
	},false);
	//var PrescNoStr=tkMakeServerCall("web.DHCDocHLYYHZYY","GetPrescNoStrByOrder",OrderItemStr);
	if (PrescNoStr=="") {
		return true;
	}
	//判断是否已经自动通过
	var rtn=$.m({
	    ClassName:"web.DHCDocHLYYHZYY",
	    MethodName:"CheckBeforeUse",
	    EpisodeID:GlobalObj.EpisodeID,
		PrescNoStr:PrescNoStr
	},false);
	//var rtn=tkMakeServerCall("web.DHCDocHLYYHZYY","CheckBeforeUse",GlobalObj.EpisodeID,"",PrescNoStr);
	var rtnArr=rtn.split("^");
	if (rtnArr[0]=="0") {
		return true;
	}
	var width=screen.availWidth-400;
	var height=screen.availHeight-200;
	var src="dhcdoc.hlyyhzyy.opexamresult.csp?EpisodeID="+GlobalObj.EpisodeID+"&PrescNoStr="+PrescNoStr;
 	websys_showModal({
		url:src,
		title:'审方结果',
		width:width,
		height:height,
		closable:false,
		CloseWin:function(rtnStr){
			websys_showModal("close");
		},
		HYLLStopOrd:function(PrescNo,CallBackFun){
			new Promise(function(resolve,rejected){
				HYLLStopOrd(PrescNo,resolve);
			}).then(function(){
				if (GlobalObj.HLYYLayOut=="OEOrd"){
					ReloadGrid("StopOrd");
					OrderMsgChange();
				}
			    SaveOrderToEMR();
			    CallBackFun(true);
			})
		}
	});
	return true;
}

function HYLLStopOrd(PrescNo,callBackFun) {
	//电子签名
	var ContainerName = "";
	var caIsPass = 0;
	UpdateObj={};
   	new Promise(function(resolve,rejected){
		//电子签名
		CASignObj.CASignLogin(resolve,"OrderStop",true)
	}).then(function(CAObj){
		return new Promise(function(resolve,rejected){
			if (CAObj == false) {
				DisableBtn("Insert_Order_btn",false);
				return websys_cancel();
			} else{
				$.extend(UpdateObj, CAObj);
				resolve(true);
			}
		})
	}).then(function(){
		var ExistInfo=$.m({
		    ClassName:"web.DHCDocHLYYHZYY",
		    MethodName:"CheckPrescExistOrder",
		    dataType:"text",
		    PrescNo:PrescNo
		},false);
		var ExistArr=ExistInfo.split("!");
		if (ExistArr[0]=="0") {
			$.messager.alert("提示","不存在需要停止的医嘱");
			return false;
		}
		var OrdListStr = tkMakeServerCall("web.DHCOEOrdItem", "GetOrdList", ExistArr[1]);
		var rtn=$.m({
		    ClassName:"web.DHCDocInPatPortalCommon",
		    MethodName:"CheckMulOrdDealPermission",
		    OrderItemStr:OrdListStr.replace(/&/g, String.fromCharCode(1)),
		    date:"",
		    time:"",
		    type:"C",
		    ExpStr:session['LOGON.USERID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.GROUPID']+"^^"
		},false);
	    if (rtn!=0){
		   $.messager.alert("提示",rtn);
		   return false;
	    }
		if (GlobalObj.HLYYLayOut=="OEOrd"){
			var rtn = cspRunServerMethod(GlobalObj.StopOrderMethod,"","",OrdListStr,session['LOGON.USERID'],"","N");
	    }else{
			var rtn = tkMakeServerCall("web.UDHCPrescript", "StopPrescNo", PrescNo,session['LOGON.USERID'],session['LOGON.CTLOCID']);
		}
		var flag=rtn.split("^")[0];
		if (flag!=0){
			$.messager.alert("提示","停止失败！"+rtn.split("^")[1]);
			return false;
		}
	    if (flag == "0") {
			$.m({
				ClassName:"web.DHCDocHLYYHZYY",
				MethodName:"SignHLYYInfo",
				EpisodeID:GlobalObj.EpisodeID,
				DataStr:PrescNo,
				SignNotes:"",
				UserID:session['LOGON.USERID'],
				OperType:"U"
			},function(val){
				//
			});
	    }
		if ((flag == "0") && (UpdateObj.caIsPass == 1)) var ret = CASignObj.SaveCASign(UpdateObj.CAObj, OrdList, "S");
		if((flag == "0")&&(typeof CDSSObj=='object')) CDSSObj.SynOrder(GlobalObj.EpisodeID,OrdList);
	    callBackFun(flag + "###" + OrdListStr);
	})
}

function XHZYClickHandler_HLYY() {
	return true;
}

function HLYYY_Init() {
	return true;
	//如果门急诊存在未处理的处方,此处自动弹出 项目决定是否启用
	if (GlobalObj.PAAdmType=="I") return true;
	var PrescNoStr=$.cm({
		ClassName:"web.DHCDocHLYYHZYY",
		MethodName:"GetPrescNoStrByAdm",
		dataType:"text",
		EpisodeID:GlobalObj.EpisodeID
	},false);
	if (PrescNoStr=="")  return true;
	var src="dhcdoc.hlyyhzyy.opexamresult.csp?EpisodeID="+GlobalObj.EpisodeID+"&PrescNoStr="+PrescNoStr;
 	websys_showModal({
		url:src,
		title:'审方结果',
		width:screen.availWidth-400,
		height:screen.availHeight-200,
		closable:false,
		CloseWin:function(rtnStr){
			websys_showModal("close");
		},
		HYLLStopOrd:function(PrescNo,CallBackFun){
			new Promise(function(resolve,rejected){
				HYLLStopOrd(PrescNo,resolve);
			}).then(function(){
				if (GlobalObj.HLYYLayOut=="OEOrd"){
					ReloadGrid("StopOrd");
					OrderMsgChange();
				}
			    SaveOrderToEMR();
			    CallBackFun(true);
			})
		}
	});
	return;
}
