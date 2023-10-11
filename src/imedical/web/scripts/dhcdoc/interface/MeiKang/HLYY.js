/*
Creater:	jm
CreateDate��2023-01-30
Description:����������ҩͳһ��װJS
*/
$(function(){
	if (typeof Common_ControlObj!="object") return;
	if (typeof Common_ControlObj.InterfaceArr!="object") return;
	//
	var McRecipeDataList="";
	var MKHLYYObj = {
		Name:"MeiKang_HLYY",
		//ҽ��¼��
		OEOrd:{
			//��ʼ��
			Init:function() {
				PassFuncs.PASSIM_INIT();
			},
			//���ǰ
			BeforeUpdate:function(CallBackFunc,EpisodeID,OrderItemStr) {
				PassFuncs.BeforeUpdate(CallBackFunc,EpisodeID,OrderItemStr,"OEOrd");
			}
		},
		//�в�ҩ¼��
		CMOEOrd:{
			//��ʼ��
			Init:function() {
				PassFuncs.PASSIM_INIT();
			},
			//���ǰ
			BeforeUpdate:function(CallBackFunc,EpisodeID,OrderItemStr) {
				PassFuncs.BeforeUpdate(CallBackFunc,EpisodeID,OrderItemStr,"CMOEOrd");
			}
		},
		Funcs:{
			//�໥����(���ڵ���໥���ð�ťʱ����)
			XHZY:function(EpisodeID) {
				var e = window.event || e;
				if (!e) return;
				if (!e.currentTarget) return;
				if (e.currentTarget.id!="XHZY") return;
				PassFuncs.XHZY(EpisodeID);
			},
			//˵����
			YDTS:function(ARCIMRowid) {
				try{
					PassFuncs.YDTS(ARCIMRowid);
				}catch(e){
					$.messager.alert("����","����������ҩ˵�����쳣:"+e.message,"error");
				}	
			},
			//�Ҽ�����
			RightClick:function(rowid) {
				try{
				PassFuncs.RightClick(rowid);
				}catch(e){
					$.messager.alert("����","����������ҩ�Ҽ��쳣:"+e.message);
				}
			}
	    }
	}
	Common_ControlObj.InterfaceArr.push(MKHLYYObj)
	//
	var PassFuncs={
		//��ʼ������ͨѶ����
		PASSIM_INIT:function(){
			if (typeof Params_MC_PASSIM_In !="undefined"){
				var im=new Params_MC_PASSIM_In()
				im.hiscode="0"
				im.doctor=session['LOGON.USERCODE'];
				im.Init()
			}
		},
		BeforeUpdate:function(CallBackFunc,EpisodeID,OrderItemStr,HLYYLayOut){
			//��������ֻ֧���첽������
			new Promise(function (resolve, rejected) {
				try{
					PassFuncs.MKXHZYNoView(resolve,EpisodeID,OrderItemStr,HLYYLayOut);
				}catch(e){
					$.messager.alert("��ʾ", "������ҩ�Զ���֤ͨ��:"+e.message, "info",function(){
						resolve(true);
					});
				}
			}).then(function (Para) {
				if (Para===true){
					CallBackFunc(true);
					return;
				}
				//https�޷���������JS,ֱ�ӷ���
				if (typeof MDC_GetSysPrStatus!="function") {
					CallBackFunc(true);
					return;
				}
				//Para: 4-��ע���Ƶƣ�3-���ã��ȵƣ�2-���أ���ƣ� 1-���ɣ��ڵƣ�0-û���⣨���ƣ�
				//is_pass: 1 ͨ����0 δͨ�� -1 ����(δ��������) 
				var is_pass = MDC_GetSysPrStatus('', '');
				if ((null == is_pass) || (undefined == is_pass)){
					$.messager.alert("��ʾ", "������ҩ�Զ�ͨ����֤", "info",function(){
						CallBackFunc(true);
					});
				}else if ((0 == is_pass) || (-1 == is_pass)){
					CallBackFunc(false);
				}else if (1 == is_pass){		//ҩʦ��ͨ��
					if (parseInt(Para)==1){
						CallBackFunc(false);
					}else if(parseInt(Para)>1){		//�о�ʾ��Ϣ����ҽ���Ƿ񱣴�
						$.messager.confirm('ȷ�϶Ի���',"������ҩ��鷢�����⣬�Ƿ��������ҽ����", function(r){
							if (r) {CallBackFunc(true)}else{CallBackFunc(false);}
						});
					}else{
						CallBackFunc(true);
					}
				}else{
					CallBackFunc(true);
				}
			})
		},
		//���ҽ��(�ϲ�ҽ��¼��/�в�ҩ¼��,��̨�������)
		MKXHZYNoView:function (callBackFunc,EpisodeID,OrderItemStr,HLYYLayOut){
			this.MCInit();
			this.HisScreenData(EpisodeID,OrderItemStr,HLYYLayOut);
			if (McRecipeDataList=="") {
				callBackFunc(true);
				return false;
			}
			MDC_DoCheck(callBackFunc,1);
		},
		//�໥����
		XHZY:function (EpisodeID){
			new Promise(function(resolve,rejected){
				GetOrderDataOnAdd(resolve);
			}).then(function(OrderItemStr){
				if (OrderItemStr=="") {
					$.messager.alert("��ʾ","û���¿�ҽ��");
					return false;
				}
				var HLYYLayOut=GlobalObj.HLYYLayOut;
	    		PassFuncs.MKXHZY(EpisodeID,OrderItemStr,HLYYLayOut);
			})
		},
		//�໥����
		MKXHZY:function (EpisodeID,OrderItemStr,HLYYLayOut){
			this.MCInit();
			this.HisScreenData(EpisodeID,OrderItemStr,HLYYLayOut);
			if (McRecipeDataList=="") return false;
			MDC_DoCheck("",1);
		},
		YDTS:function (ARCIMRowid){
			if ((typeof ARCIMRowid=="undefined")||(ARCIMRowid==null)||(ARCIMRowid=="")) {
				$.messager.alert("����","��ѡ��һ��ҽ��");  
				return;  
			}
			var ArcimInfo=tkMakeServerCall("web.DHCDocHLYYInterface","GetArcimInfo",ARCIMRowid);
			var ArcimInfoAry=ArcimInfo.split("^");
			var OrderARCIMCode=ArcimInfoAry[0];
			var OrderName=ArcimInfoAry[1];
			var RefCode=51;
			if (GlobalObj.HLYYLayOut=="OEOrd"){
				RefCode=11;
			}else if (GlobalObj.HLYYLayOut=="CMOEOrd"){
				RefCode=24;
			}
			PassFuncs.MKYDTS(OrderARCIMCode,OrderName,RefCode);
		},
		//˵����(11-ҩƷ˵����,51-��Ҫ��Ϣ(��������),24-��ҩ��ר��)
		MKYDTS:function(OrderARCIMCode,OrderName,RefCode){
			this.MCInit();
			this.HisQueryData(OrderARCIMCode,OrderName);
			MDC_DoRefDrug(RefCode);
		},
		MCInit:function(){
			var pass = new Params_MC_PASSclient_In();
			pass.HospID = session['LOGON.HOSPID'];  
			pass.UserID =session['LOGON.USERCODE'];
			pass.UserName = session['LOGON.USERNAME'];
			pass.DeptID = GlobalObj.LogLocCode;
			pass.DeptName = GlobalObj.LogLocDesc;
			pass.CheckMode =(GlobalObj.PAAdmType=="I"?"zy":"mz");
			MCPASSclient = pass;
		},
		HisScreenData:function (EpisodeID,OrderItemStr,HLYYLayOut){
			McRecipeDataList="";
			//�û�id^����id^Ժ��id^ϵͳģʽ(�������ֻ�����ҽԺ,ǰ̨¼���Ϊ��)
			var ExpStr=session['LOGON.USERID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']+"^"+"";
			var PrescJSON=tkMakeServerCall("web.DHCDocHLYYMK","GetPrescInfo",EpisodeID,OrderItemStr,HLYYLayOut,ExpStr);
			var PrescObj=$.parseJSON(PrescJSON);
			//console.log(PrescJSON)
			if (PrescObj.ResultCode=="-1") {
				$.messager.alert("��ʾ",PrescObj.ResultContent);
				return;
			}
			//���벡�˻�����Ϣ
			MCpatientInfo = PrescObj.Patient;
			//���벡�˹�����Ϣ
			McAllergenArray = PrescObj.ScreenAllergenList.ScreenAllergens;
			//���벡�������Ϣ
			McMedCondArray = PrescObj.ScreenMedCondList.ScreenMedConds;
			//���벡��������Ϣ
			McOperationArray = new Array();
			//���벡��ҩƷ��Ϣ
			McDrugsArray = PrescObj.ScreenDrugList.ScreenDrugs;
			McRecipeDataList = PrescObj.ScreenDrugList.ScreenDrugs;
			//���벡�˼�����Ϣ
			McLabArray = PrescObj.ScreenLabList.ScreenLabs;
			//���벡�˼����Ϣ
			McExamArray = PrescObj.ScreenExamList.ScreenExams;
		},
		HisQueryData:function (OrderARCIMCode,OrderName) {
		 	var drug = new Params_MC_queryDrug_In();
		    drug.ReferenceCode = OrderARCIMCode;	//ҩƷ���
		    drug.CodeName = OrderName;				//ҩƷ����
		    MC_global_queryDrug = drug;
		},
		RightClick:function (rowid){
			if (GlobalObj.HLYYLayOut!="OEOrd") return;
			var OrderType=GetCellData(rowid,"OrderType");
			if (OrderType!="R") return;
			var OrderARCIMRowid=GetCellData(rowid,"OrderARCIMRowid");
			if (OrderARCIMRowid=="") return;
			var ArcimInfo=tkMakeServerCall("web.DHCDocHLYYInterface","GetArcimInfo",OrderARCIMRowid);
			var OrderARCIMCode=mPiece(ArcimInfo,"^",0);
			var OrderName=mPiece(ArcimInfo,"^",1);
			//
			PassFuncs.MCInit();
			PassFuncs.HisQueryData(OrderARCIMCode,OrderName);
			McPASS.McRightMenu();
			//
			var rowids=GetAllRowId();
			for(var i=0;i<rowids.length;i++){
				if($("#jqg_Order_DataGrid_"+rowids[i]).attr("checked")=="checked"){
					$("#Order_DataGrid").setSelection(rowids[i],false);
				}				
			}
			if($("#jqg_Order_DataGrid_"+rowids[i]).attr("checked")!="checked"){
				$("#Order_DataGrid").setSelection(rowid,true);
			}
		}
	}
})
