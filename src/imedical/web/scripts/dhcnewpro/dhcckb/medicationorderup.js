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
	EpisodeID=3
	setPatInfo(EpisodeID);
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
      	$("#DiagnosisNew").val(Data.PatDiag);
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
	initCombox("SoakingWater2","MedOrdSoakWaterVol")
	
	//浸泡时间
	initCombox("SoakingTime","MedOrdSoakTime")

	//煎煮次数
	initCombox("DecoctingTimes","MedOrdCookNum")

	//煎煮时间
	initCombox("DecoctionTime","MedOrdCookTime")
	initCombox("DecoctionTime2","MedOrdCookTime")
	
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
	//initCombox("StorageMethod","MedOrdStorageWay")
	
	//特殊服法
	initCombox("SpecialObey","SpecialTakingMethod")
	
	//用药告知
	initCombox("MedicationNotification","MedicationNotification")
	
	if(hideFlag==1){
		$("#btnList").hide()
	}
	
	$("#StorageMethod").val("请将饮片置于阴凉、干燥、 通风处,煎好的药液置于冰箱冷藏室0~ 5℃范围内保存");		
		
	$HUI.radio("[name='prescType']",{
        onChecked:function(e,value){
	        initCombox("SoakingTime","MedOrdSoakTime");
	        initCombox("DecoctingTemperature","MedOrdCookTemper");
	        initCombox("DecoctionTime","MedOrdCookTime");
			initCombox("DecoctionTime2","MedOrdCookTime");
            //alert($(e.target).attr("label"));  //输出当前选中的label值
            //alert($(e.target).val());
        }
    });
	}
	
function initCombox(id,desc){
	
	var defaultValue = ""
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
				{field:'value',title:'描述',width:200}
				]],
		onLoadSuccess:function(data){
			if (data.total == 1){ // 只有一个值时默认
				defaultValue = data.rows[0].value;				
			}
			SetDefaultCombobox(id,defaultValue,data);
		}	
	}); 
	
}	


function SaveData(){

	//就诊号^处方号^备注
	var listData = EpisodeID+"^"+$("#PrescriptionNumber").val()+"^";
	
	//煎煮器皿^浸泡水量^浸泡时间^煎煮次数
	listData = listData+"^"+$("#DecoctingVessel").combogrid("getText")+"^"+$("#SoakingWater").combogrid("getText")+"^"+$("#SoakingTime").combogrid("getText") +"^"+$("#DecoctingTimes").combogrid("getText");
	
	//煎煮时间^煎煮温度^特殊煎煮方法
	listData = listData+"^"+$("#DecoctionTime").combogrid("getText")+"^"+$("#DecoctingTemperature").combogrid("getText")+"^"+$("#DecoctingMethod").combogrid("getText");
	
	//第一煎^第二煎
	//listData = listData+"^"+$("#DecoctingMethodFirst").val()+"^"+$("#DecoctingMethodSecond").val();
	listData = listData+"^"+ "" +"^"+ "";
	
	//服药温度^服药时间^服药次数^服药剂量
	listData = listData+"^"+$("#MedicationTemperature").combogrid("getText")+"^"+$("#MedicationTime").combogrid("getText")+"^"+$("#MedicationTimes").combogrid("getText")+"^"+$("#Dosage").combogrid("getText");
	
	//服药食忌^药后护理^用药告知^储存方法^特殊服法	
	listData = listData+"^"+$("#foodTaboo").combogrid("getText")+"^"+$("#PostDrugCare").combogrid("getText")+"^"+$("#MedicationNotification").val()+"^"+$("#StorageMethod").val()+"^"+$("#SpecialObey").combogrid("getText");
	
	//方剂类型^浸泡水量2(二煎)^煎煮时间2(二煎)
	var checkedRadioJObj = $("input[name='prescType']:checked");
	var checkVal = checkedRadioJObj.val();
	if ((checkVal == "")||(checkVal == undefined)){
		$.messager.alert("提示","请选择方剂类型后保存。")
		return;
	}
	listData = listData+"^"+checkVal+"^"+$("#SoakingWater").combogrid("getText")+"^"+$("#DecoctionTime").combogrid("getText");
	
	//注意事项25^证候禁忌26^饮食禁忌27
	listData = listData+"^"+$("#mattersAttention").val()+"^"+$("#SyndromeContraindication").val()+"^"+$("#DietaryTaboos").val()
	
	// 孕妇及哺乳期妇女用药28^儿童用药29^老年用药30
	listData = listData+"^"+$("#pregMedication").val()+"^"+$("#childrenMedication").val()+"^"+$("#GeriatricMedication").val()
	
	// 药物相互作用31^贮藏方法32^毒性提示33
	listData = listData+"^"+$("#DrugInteraction").val()+"^"+"^"+$("#ToxicityTips").val()
	
	//健康提示 34^处方组成 35
	listData = listData+"^"+$("#HealthTips").val()+"^"+$("#PrescCompotion").val()
	
	// 规格36^数量37
	listData = listData+"^"+$("#PrescSpec").val()+"^"+$("#PrescNum").val()

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
			//$("#StorageMethod").combogrid("setValue",Data.MOStorageMethod);   		//储存方法
			$("#StorageMethod").val(Data.MOStorageMethod);   						//储存方法
			$("#SpecialObey").val(Data.MOSpecialObey); 								//特殊服法
			$("#SoakingWater2").combogrid("setValue",Data.MOSoakWater2);  			//浸泡水量(二煎)
			$("#DecoctionTime2").combogrid("setValue",Data.MODecTime2);   			//煎煮时间(二煎)
			$HUI.radio("#"+Data.PrescType).setValue(true);							//方剂类型
			
			
			$("#mattersAttention").val(Data.MOMattersAttention);   			//【注意事项】
			$("#SyndromeContraindication").val(Data.MOSyndromeContion);   			//【证候禁忌】
			$("#DietaryTaboos").val(Data.MODietaryTaboos);   			//【饮食禁忌】 
			$("#pregMedication").val(Data.MOPregMedication);   			//【孕妇及哺乳期妇女用药】 
			$("#childrenMedication").val(Data.MOChildMedication);   			//儿童用药】 
			$("#GeriatricMedication").val(Data.MOGeriatricMedication);   			//【老年用药】 
			$("#DrugInteraction").val(Data.MODrugInteraction);   			//【药物相互作用】
			//$("#StorageMethod").val(Data.StorageMethod);   			//【贮藏方法】 
			$("#ToxicityTips").val(Data.MOToxicityTips);   			//【毒性提示】 
			$("#HealthTips").val(Data.MOHealthTips);   			//【健康提示】 
			$("#PrescCompotion").val(Data.MOPrescCompotion);   			//处方组成 
			$("#PrescSpec").val(Data.PrescSpec);   			//处方规格
			$("#PrescNum").val(Data.PrescNum);   			//处方数量 
			
			},"json",false)
		}
	}

//打印
function PrintData(){
	var url="dhcckb.printmedicationorderup.csp?medOrderID="+medOrderID
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
	var url="dhcckb.querymedorderup.csp"
	window.open(url,"_blank");

	}
	
/// 设置combobox的默认值
function SetDefaultCombobox(id,defaultValue,data){

	// 煎煮器皿,煎煮次数 默认
	// 服药温度 默认“温服”，可选择修改
	// 服药时间 默认“饭后服”可修改选择
	// 服药次数 默认“一天两次”，可修改
	// 服药剂量 默认“成人”，可修改
	// 储存方法 默认“请将饮片置于阴凉、干燥、 通风处,煎好的药液置于冰箱冷藏室0~ 5℃范围内保存”
	if (defaultValue != ""){
		$('#'+id).combogrid('setValue', defaultValue);
	};
	
	var checkedRadioJObj = $("input[name='prescType']:checked");
	var checkVal = checkedRadioJObj.val()
	var checkText = checkedRadioJObj.attr("label");
          
	switch(id){
		case "MedicationTemperature":
			$('#'+id).combogrid('setValue', "温服");
			break;
			
		case "MedicationTime":
			$('#'+id).combogrid('setValue', "饭后服");
			break;
			
		case "MedicationTimes":
			$('#'+id).combogrid('setValue', "一日两次");
			break;

		case "Dosage":
			$('#'+id).combogrid('setValue', "成人");
			break;	
		
		case "SoakingTime":
			if (checkText == "补益剂"){
				$('#'+id).combogrid('setValue', "补益类");
			}else{
				$('#'+id).combogrid('setValue', checkText);
			}			
			break;	
			
		case "DecoctingTemperature":			
			$('#'+id).combogrid('setValue', checkText);					
			break;			
			
		case "SoakingWater":
			$('#'+id).combogrid('setValue', "一煎");
			break;	
			
		case "SoakingWater2":
			$('#'+id).combogrid('setValue', "二煎");
			break;	
			
		case "DecoctionTime":
			$.each(data.rows, function(){
				if (this.value == checkText){
					if (this.text.indexOf("头煎")!=-1){
						$('#'+id).combogrid('setValue',this.text);
						return false; // = break
					}
				}
			});			
			break;	
		case "DecoctionTime2":
			$.each(data.rows, function(){
				if (this.value == checkText){
					if (this.text.indexOf("二煎")!=-1){
						$('#'+id).combogrid('setValue',this.text);
						return false; // = break
					}
				}
			});	
			break;	
			
		default:
			break;	
	}
	

}
/// JQuery 初始化页面
$(function(){ initPageDefault(); })