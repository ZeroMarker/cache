/**!
* ����:   2020-12-24
* �������׺�����ҩjs���°�ҽ��¼��ʹ�á�
* 
* V1.0
* Update 2021-12-24
* jm
* ��װ������ҩϵͳ��������ֹ������Ⱦ;�����÷������Ա�ҽ��¼��Ͳ�ҩ¼��ͬʱ����
*/

var HZYYLogicObj = {
    ExpStr:session['LOGON.USERID']+"^"+session['LOGON.CTLOCID']
}
if (websys_isIE==true) {
	 var script = document.createElement('script');
	 script.type = 'text/javaScript';
	 script.src = '../scripts/dhcdoc/tools/bluebird.min.js';  // bluebird �ļ���ַ
	 document.getElementsByTagName('head')[0].appendChild(script);
}

///��鷽��
function HYLLUpdateClick_HLYY(CallBackFunc,OrderItemStr,Mode){
	if (Mode=="Check") {	//��Ԥ
		var rtn=HYLLUpdateClick_Check(CallBackFunc,OrderItemStr);
	}
	if (Mode=="Save") {		//����
		var rtn=HYLLUpdateClick_Save(CallBackFunc,OrderItemStr);
	}
	if (Mode=="Exam") {		//��
		var rtn=HYLLUpdateClick_Exam(OrderItemStr);
	}
	if (Mode=="Limit") {	//��������󷽺󵯿�
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
		//����Ҫ���ú�����ҩ���߳����쳣
		//return true;
		CallBackFunc(true);
		return;
	}
	var HLYYArr=HLYYInfo.split("^");
	if (HLYYArr[0]==0){
		//����ȼ�<8
		if (HLYYArr[1]!="") {
			//����������ʾ�Ƿ��޸�
			/*HLYYArr[1]=HLYYArr[1].replace(/\<br>/g, "\n")
			var rtn=dhcsys_confirm("������ҩ��ʾ:"+"\n"+HLYYArr[1]+"\n"+"�Ƿ�������?","","","","500");
			if (rtn) {return true;}else{return false;}*/
			$.messager.confirm('ȷ�϶Ի���',"������ҩ��ʾ:"+"<br>"+HLYYArr[1]+"<br>"+"�Ƿ�������?", function(r){
				if (r) {CallBackFunc(true);}else{CallBackFunc(false);}
			});
		}else{
			//����������
			//return true;
			CallBackFunc(true);
		}
	}else if (HLYYArr[0]==-1){
		//����ȼ�>=8
		//dhcsys_alert("������ҩ��ʾ:"+"<br>"+HLYYArr[1]+"<br>"+"�뷵���޸�","500");
		//return false;
		$.messager.alert("��ʾ", "������ҩ��ʾ:"+"<br>"+HLYYArr[1]+"<br>"+"�뷵���޸�", "info",function(){
			CallBackFunc(false);
		});
	}else{
		//var rtn=dhcsys_confirm("������ҩ��Ԥϵͳ�쳣:"+"\n"+HLYYArr[1]+"\n"+"����ϵ��Ϣ��!��ȷ�����ҽ��������ȷ����","","","","500");
		//if (rtn) {return true;}else{return false;}
		$.messager.confirm('ȷ�϶Ի���',"������ҩ��Ԥϵͳ�쳣:"+"<br>"+HLYYArr[1]+"<br>"+"����ϵ��Ϣ��!��ȷ�����ҽ��������ȷ����", function(r){
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
	//����Ҫ���ú�����ҩ���߳����쳣
	if ((HLYYInfo=="")||(HLYYInfo==null)||(typeof HLYYInfo=="undefined")) {
		//return true;
		CallBackFunc(true);
		return;
	}
	var HLYYArr=HLYYInfo.split("^");
	if (HLYYArr[0]!=0){
		//dhcsys_alert("������ҩ����ϵͳ�쳣:"+"<br>"+HLYYArr[1]+"<br>"+"����ϵ��Ϣ��!","500");
		$.messager.alert("��ʾ","������ҩ����ϵͳ�쳣:"+"<br>"+HLYYArr[1]+"<br>"+"����ϵ��Ϣ��!", "info",function(){
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
	if ((HLYYInfo=="")||(HLYYInfo==null)||(typeof HLYYInfo=="undefined")) {		//����Ҫ���ú�����ҩ���߳����쳣
		return true;
	}
	var HLYYArr=HLYYInfo.split("^");
	if (HLYYArr[0]!=0){
		dhcsys_alert("������ҩ�󷽽ӿڵ���ʧ��:"+"<br>"+HLYYArr[1]+"<br>"+"����ϵ��Ϣ��!","500");
		return false;
		/*$.messager.alert("��ʾ","������ҩ�󷽽ӿڵ���ʧ��:"+"<br>"+HLYYArr[1]+"<br>"+"����ϵ��Ϣ��!", "info",function(){
			return false;
		});*/
	}
	if (GlobalObj.PAAdmType=="I") {
		//dhcsys_alert("������ҩ�󷽽ӿڵ��óɹ�,���л���Ӧ����鿴���");
	}
	return true;
}

//˵����
function HLYYYDTS_Click(rowid){
	if (GlobalObj.HLYYLayOut=="OEOrd"){
		//ѡ��һ��
		if(!rowid){
			var ids =$('#Order_DataGrid').jqGrid("getGridParam", "selarrrow");
			if(!ids.length){
				$.messager.alert("����","��ѡ��һ��ҽ��");  
				return;
			}
			rowid=ids[0];
		}
		var OrderARCIMRowid = GetCellData(rowid, "OrderARCIMRowid");
	}else{
		var OrderARCIMRowid=$("#"+FocusRowIndex+"_OrderARCIMID"+FocusGroupIndex+"").val();
	}
	if (typeof OrderARCIMRowid=="undefined" || OrderARCIMRowid==null || OrderARCIMRowid==""){
		$.messager.alert("����","��ѡ��һ��ҽ��");  
		return;  
	}
	var ArcimInfo=tkMakeServerCall("web.DHCDocHLYYInterface","GetArcimInfo",OrderARCIMRowid);
	var OrderARCIMCode=mPiece(ArcimInfo,"^",0);
	var OrderName=mPiece(ArcimInfo,"^",1);
	var linkUrl="http://192.170.206.201:8080/zlcx/data_detail.action?webHisId="+OrderARCIMCode;
	//window.open(linkurl,"","status=1,scrollbars=1,top=100,left=100,width=760,height=420");
	websys_showModal({
		url:linkUrl,
		title:'ҩƷ˵����',
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
	//�ж��Ƿ��Ѿ��Զ�ͨ��
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
		title:'�󷽽��',
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
	//����ǩ��
	var ContainerName = "";
	var caIsPass = 0;
	UpdateObj={};
   	new Promise(function(resolve,rejected){
		//����ǩ��
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
			$.messager.alert("��ʾ","��������Ҫֹͣ��ҽ��");
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
		   $.messager.alert("��ʾ",rtn);
		   return false;
	    }
		if (GlobalObj.HLYYLayOut=="OEOrd"){
			var rtn = cspRunServerMethod(GlobalObj.StopOrderMethod,"","",OrdListStr,session['LOGON.USERID'],"","N");
	    }else{
			var rtn = tkMakeServerCall("web.UDHCPrescript", "StopPrescNo", PrescNo,session['LOGON.USERID'],session['LOGON.CTLOCID']);
		}
		var flag=rtn.split("^")[0];
		if (flag!=0){
			$.messager.alert("��ʾ","ֹͣʧ�ܣ�"+rtn.split("^")[1]);
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
	//����ż������δ����Ĵ���,�˴��Զ����� ��Ŀ�����Ƿ�����
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
		title:'�󷽽��',
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
