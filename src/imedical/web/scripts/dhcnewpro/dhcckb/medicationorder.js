//===========================================================================================
// Author：      yuliping
// Date:		 2021-06-01
// Description:	 药嘱单录入
//===========================================================================================
/// 页面初始化函数
var medOrderID =""
var EpisodeID = ""
function initPageDefault(){
	
	InitPatInfo();		// 按钮响应事件初始化
	setCombox()			// 药嘱单字典内容
	initMedOrder()
}

function InitPatInfo(){
	if ((medOrderID=="")){
		var frm = dhcadvdhcsys_getmenuform();
	
		if (frm) {
	        var adm = frm.EpisodeID.value;
	       
		    EpisodeID=adm;
	        setPatInfo(adm);//获取病人信息
		}
	}

	}
//获取病人信息
function setPatInfo(EpisodeID){
	if(EpisodeID==""){return;}
	runClassMethod("web.DHCCKBMedicationOrder","GetPatInfoJson",{'PatNo':'','EpisodeID':EpisodeID},
	function(Data){ 
      	$("#PatName").val(Data.PatName);				// 患者姓名
       	$("#PatNo").val(Data.PatNo);					// 登记号
       	$("#PatSex").val(Data.PatSex);					// 性别
       	$("#PatAge").val(Data.PatAge);					// 年龄
      	$("#AdmDate").datebox("setValue",Data.AdmDate);    //就诊日期
      	$("#AdmLoc").val(Data.AdmLoc);
      	$("#Doctor").val(Data.AdmDoctor);
      	$("#Diagnosis").val(Data.PatDiag);
      	$("#IDCard").val(Data.IDCard);
      	$("#PatBDay").datebox("setValue",Data.Birthday);
      	$("#Adress").val(Data.Address);
      	$("#Phone").val(Data.PatTelH);
	},"json",false);

	
}

//初始化下拉框
function setCombox(){
	//煎煮器具
	initCombox("DecoctingVessel","MedOrdCookCistern")
	
	//浸泡加水量
	initCombox("SoakingWater","MedOrdSoakWaterVol")
	
	//浸泡时间
	initCombox("SoakingTime","MedOrdSoakTime")

	//煎煮次数
	initCombox("DecoctingTimes","MedOrdCookNum")

	//煎煮时间
	initCombox("DecoctionTime","MedOrdCookTime")
	
	//煎煮温度
	initCombox("DecoctingTemperature","MedOrdCookTemper")
	
	//特殊煎煮方法
	initCombox("DecoctingMethod","MedOrdCookWay")
	
	//服药温度
	initCombox("MedicationTemperature","MedOrdUseTemper")
	
	//服药时间
	initCombox("MedicationTime","MedOrdUseTime")
	
	//服药次数
	initCombox("MedicationTimes","MedOrdUseNum")
	
	//服药剂量
	initCombox("Dosage","MedOrdUseDose")
	
	//服药食忌
	initCombox("foodTaboo","MedOrdTaboo")

	//药后护理
	initCombox("PostDrugCare","MedOrdNursing")
	
	//存储方法
	initCombox("StorageMethod","MedOrdStorageWay")
	if(hideFlag==1){
		$("#btnList").hide()
		}
	}
	
function initCombox(id,desc){
	$('#'+id).combogrid({ 
		idField:'value',
	    textField:'text',
	    fitColumns:true,
	    fit: true,//自动大小  
		pagination : true,
		panelWidth:1000,								
		mode:'remote', 	
		enterNullValueClear:false,
		url:'dhcapp.broker.csp?ClassName=web.DHCCKBMedicationOrder&MethodName=jsonMedical&desc='+desc,
		columns:[[
				{field:'text',title:'类别',width:50},
				{field:'value',title:'描述',width:200},	
				]]   
	}); 
}


function SaveData(){
	EpisodeID=3
	//就诊号^处方号^备注
	var listData = EpisodeID+"^"+$("#PrescriptionNumber").val()+"^"+$("#Remarks").val();
	
	//煎煮器皿^浸泡水量^浸泡时间^煎煮次数
	listData = listData+"^"+$("#DecoctingVessel").combogrid("getText")+"^"+$("#SoakingWater").combogrid("getText")+"^"+$("#SoakingTime").combogrid("getText") +"^"+$("#DecoctingTimes").combogrid("getText");
	
	//煎煮时间^煎煮温度^特殊煎煮方法
	listData = listData+"^"+$("#DecoctionTime").combogrid("getText")+"^"+$("#DecoctingTemperature").combogrid("getText")+"^"+$("#DecoctingMethod").combogrid("getText");
	
	//第一煎^第二煎
	listData = listData+"^"+$("#DecoctingMethodFirst").val()+"^"+$("#DecoctingMethodSecond").val();
	
	//服药温度^服药时间^服药次数^服药剂量
	listData = listData+"^"+$("#MedicationTemperature").combogrid("getText")+"^"+$("#MedicationTime").combogrid("getText")+"^"+$("#MedicationTimes").combogrid("getText")+"^"+$("#Dosage").combogrid("getText");
	
	//服药食忌^药后护理^用药告知^储存方法^	
	listData = listData+"^"+$("#foodTaboo").combogrid("getText")+"^"+$("#PostDrugCare").combogrid("getText")+"^"+$("#MedicationNotification").val()+"^"+$("#StorageMethod").combogrid("getText")+"^"+$("#SpecialObey").val()
	
	runClassMethod("web.DHCCKBMedicationOrder","saveOrUpdateMedOrder",{ID:medOrderID, DataList:listData},function(ret){
		
		if(ret>0){
			$.messager.alert("提示","保存成功")
			medOrderID = ret;
			}else{
			$.messager.alert("提示","保存失败，错误代码："+ret)
				}
		},"text",false)
	}
	
//加载药嘱单内容
function initMedOrder(){
	if(medOrderID!=""){
		
		runClassMethod("web.DHCCKBMedicationOrder","getMedOrder",{ID:medOrderID},function(Data){
			
			$("#PatName").val(Data.PatName);				// 患者姓名
	       	$("#PatNo").val(Data.PatNo);					// 登记号
	       	$("#PatSex").val(Data.PatSex);					// 性别
	       	$("#PatAge").val(Data.PatAge);					// 年龄
	      	$("#AdmDate").datebox("setValue",Data.AdmDate);    //就诊日期
	      	$("#AdmLoc").val(Data.AdmLoc);
	      	$("#Doctor").val(Data.AdmDoctor);
	      	$("#Diagnosis").val(Data.PatDiag);
	      	$("#IDCard").val(Data.IDCard);
	      	$("#PatBDay").datebox("setValue",Data.Birthday);
	      	$("#Adress").val(Data.Address);
	      	$("#Phone").val(Data.PatTelH);
	      	$("#Number").val(Data.MOSysNo);											//系统编号
			$("#PrescriptionNumber").val(Data.MOPrescripNo);  						//处方号
			$("#Remarks").val(Data.MORemarks);   									//备注
			$("#DecoctingVessel").combogrid("setValue",Data.MODecVessel);   		//煎煮器皿
			$("#SoakingWater").combogrid("setValue",Data.MOSoakWater);  			//浸泡水量
			$("#SoakingTime").combogrid("setValue",Data.MOSoakTime);  				//浸泡时间
			$("#DecoctingTimes").combogrid("setValue",Data.MODecTimes);  			//煎煮次数
			$("#DecoctionTime").combogrid("setValue",Data.MODecTime);   			//煎煮时间
			$("#DecoctingTemperature").combogrid("setValue",Data.MODecTemp);   		//煎煮温度
			$("#DecoctingMethod").combogrid("setValue",Data.MODecMethod);   		//特殊煎煮方法
			$("#DecoctingMethodFirst").val(Data.MODecFirFried);   					//第一煎
			$("#DecoctingMethodSecond").val(Data.MODecSecFried);   					//第二煎
			$("#MedicationTemperature").combogrid("setValue",Data.MOMedTemp);   	//服药温度
			$("#MedicationTime").combogrid("setValue",Data.MOMedTime);   			//服药时间
			$("#MedicationTimes").combogrid("setValue",Data.MOMedTimes);  			//服药次数
			$("#Dosage").combogrid("setValue",Data.MODosage);   					//服药剂量
			$("#foodTaboo").combogrid("setValue",Data.MOFoodTaboo);   				//服药食忌
			$("#PostDrugCare").combogrid("setValue",Data.MOPostDrugCare);   		//药后护理
			$("#MedicationNotification").val(Data.MOMedNotify);   					//用药告知
			$("#StorageMethod").combogrid("setValue",Data.MOStorageMethod);   		//储存方法
			$("#SpecialObey").val(Data.MOSpecialObey); 								//特殊服法
			
			},"json",false)
		}
	}

//打印
function PrintData(){
	var url="dhcckb.printmedicationorder.csp?medOrderID="+medOrderID
	window.open(url,"_blank");

}
/// 添加获取病人菜单信息方法
function dhcadvdhcsys_getmenuform(){
	var frm = null;
	try{
		var win=top.frames['eprmenu'];
		if (win) {
			frm = win.document.forms['fEPRMENU'];
			if(frm) return frm;
		}
		//在新窗口打开的界面
		win = opener;
		if (win) {
			frm = win.document.forms['fEPRMENU'];
			if (frm) return frm;
		}
		win = parent.frames[0];
		if (win){
			frm = win.document.forms["fEPRMENU"];
			if (frm) return frm;
		}
		if (top){
			frm =top.document.forms["fEPRMENU"];
			if(frm) return frm
		}
	}catch(e){}
	return frm;
}
function ListData(){
	var url="dhcckb.querymedorder.csp"
	window.open(url,"_blank");

	}
/// JQuery 初始化页面
$(function(){ initPageDefault(); })