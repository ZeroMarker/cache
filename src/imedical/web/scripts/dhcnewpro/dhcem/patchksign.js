///Creator:hxy
///Date:2020-02-27
///patchksign.js
var SignNormalObj={}; ///生命体征正常值
$(function(){	
	cleanPlanWin();			/// 清空窗口内容
	
	initInputEvent(); //hxy 2020-03-11
	
	initSignNormalValue();   ///获取生命体征初始化正常值 
	
	$('#SetPlanWin').tabs({    
	    border:false,
	    fit:true, 
	    onSelect:function(title){
		    $("#EmPcsTempAgain").focus();
	        var tab = $('#SetPlanWin').tabs('getSelected'); 		 		/// 获取选择的面板
	        var tbId = tab.attr("id");
	        var maintab="";	 
	        if (tbId == 'medhistroy'){
		       InitRecord();  //初始化干预记录 
		    }
		    
	    }
	});   
		       
	$('#SetPlanWin').tabs('select','干预措施'); //默认选中项
	$("#EmPcsTempAgain").focus();
})

///走后台方法:获取生命体征正常值
function initSignNormalValue(){
	runClassMethod("web.DHCEMPatCheckLevQuery","GetSignNoralList",{},
	function(jsonString){
		SignNormalObj = jsonString;
	},'json',false)
}

//注册input的事件
function initInputEvent(){
	
	//回车键跳入下一元素 
	var $inp = $('.enter');//input:text
	$inp.bind('keydown', function (e) {
		var key = e.keyCode;
		if (key == 13) {
			//荒诞值验证
			valiAbsValueBoolean();
			var nxtIdx = $inp.index(this) + 1;
			$(".enter:eq(" + nxtIdx + ")").focus();
		}
	});
	
	///  生命体征
	$('input[name="EmPcsAgain"]').bind("blur",valiAbsValueBoolean);
}

function valiAbsValueBoolean(){
	if(!valiAbsValueAgain()){}
}
///取配置判断荒诞值
function valiAbsValueAgain(){
	if(Object.keys(SignNormalObj).length>0){
		var itmInfo = "";
		var itmMinVal="";
		var itmMaxVal="";
		var EmPcsSBP = $("#EmPcsSBPAgain").val();  ///收缩压
		EmPcsSBP = parseInt(EmPcsSBP);
		itmInfo = SignNormalObj.sysPressure;
		if(itmInfo!=undefined){
			itmMinVal = itmInfo.split("@")[2];
			itmMaxVal = itmInfo.split("@")[3];
			if((EmPcsSBP!="")&&(itmMinVal!="")&&(EmPcsSBP<itmMinVal)){
				$.messager.alert("提示","收缩压值荒诞,范围"+itmMinVal+"-"+itmMaxVal+"!");
				$("#EmPcsSBPAgain").val("");
				return false;
			}
			
			if((EmPcsSBP!="")&&(itmMaxVal!="")&&(EmPcsSBP>itmMaxVal)){
				$.messager.alert("提示","收缩压值荒诞,范围"+itmMinVal+"-"+itmMaxVal+"!");
				$("#EmPcsSBPAgain").val("");
				return false;
			}
		}
		
		var EmPcsDBP =  $("#EmPcsDBPAgain").val();  ///舒张压
		EmPcsDBP = parseInt(EmPcsDBP);
		if(itmInfo!=undefined){
			itmMinVal = itmInfo.split("@")[2];
			itmMaxVal = itmInfo.split("@")[3];
			if((EmPcsDBP!="")&&(itmMinVal!="")&&(EmPcsDBP<itmMinVal)){
				$.messager.alert("提示","舒张压值荒诞,范围"+itmMinVal+"-"+itmMaxVal+"!");
				$("#EmPcsDBPAgain").val("");
				return false;
			}
			
			if((EmPcsDBP!="")&&(itmMaxVal!="")&&(EmPcsDBP>itmMaxVal)){
				$.messager.alert("提示","舒张压值荒诞,范围"+itmMinVal+"-"+itmMaxVal+"!");
				$("#EmPcsDBPAgain").val("");
				return false;
			}
		}
		
		
		var EmPcsSoP2 =  $("#EmPcsSoP2Again").val();  ///血氧饱和浓度
		EmPcsSoP2 = parseInt(EmPcsSoP2);
		itmInfo = SignNormalObj.degrBlood;  
		if(itmInfo!=undefined){
			itmMinVal = itmInfo.split("@")[2];
			itmMaxVal = itmInfo.split("@")[3];
			if((EmPcsSoP2!="")&&(itmMinVal!="")&&(EmPcsSoP2<itmMinVal)){
				$.messager.alert("提示","血氧饱和浓度值荒诞,范围"+itmMinVal+"-"+itmMaxVal+"!");
				$("#EmPcsSoP2Again").val("");
				return false; 
			}
			
			if((EmPcsSoP2!="")&&(itmMaxVal!="")&&(EmPcsSoP2>itmMaxVal)){
				$.messager.alert("提示","血氧饱和浓度值荒诞,范围"+itmMinVal+"-"+itmMaxVal+"!");
				$("#EmPcsSoP2Again").val("");
				return false;
			}
		}
		
		
		var EmPcsBreath =  $("#EmPcsBreathAgain").val();  ///呼吸频率
		EmPcsBreath = parseInt(EmPcsBreath);
		itmInfo = SignNormalObj.breath;  
		if(itmInfo!=undefined){
			itmMinVal = itmInfo.split("@")[2];
			itmMaxVal = itmInfo.split("@")[3];
			if((EmPcsBreath!="")&&(itmMinVal!="")&&(EmPcsBreath<itmMinVal)){
				$.messager.alert("提示","呼吸频率值荒诞,范围"+itmMinVal+"-"+itmMaxVal+"!");
				$("#EmPcsBreathAgain").val("");
				return false;
			}
			
			if((EmPcsBreath!="")&&(itmMaxVal!="")&&(EmPcsBreath>itmMaxVal)){
				$.messager.alert("提示","呼吸频率值荒诞,范围"+itmMinVal+"-"+itmMaxVal+"!");
				$("#EmPcsBreathAgain").val("");
				return false;
			}
		}
		
		var EmPcsTemp =  $("#EmPcsTempAgain").val();  ///体温
		EmPcsTemp = parseInt(EmPcsTemp);
		itmInfo = SignNormalObj.temperature;  
		if(itmInfo!=undefined){
			itmMinVal = itmInfo.split("@")[2];
			itmMaxVal = itmInfo.split("@")[3];
			if((EmPcsTemp!="")&&(itmMinVal!="")&&(EmPcsTemp<itmMinVal)){
				$.messager.alert("提示","体温值荒诞,范围"+itmMinVal+"-"+itmMaxVal+"!");
				$("#EmPcsTempAgain").val("");
				return false;
			}
			
			if((EmPcsTemp!="")&&(itmMaxVal!="")&&(EmPcsTemp>itmMaxVal)){
				$.messager.alert("提示","体温值荒诞,范围"+itmMinVal+"-"+itmMaxVal+"!");
				$("#EmPcsTempAgain").val("");
				return false;
			}
		}
		
		var EmPcsHeart =  $("#EmPcsHeartAgain").val();  ///心律
		EmPcsHeart = parseInt(EmPcsHeart);
		itmInfo = SignNormalObj.heartbeat; 
		if(itmInfo!=undefined){
			itmMinVal = itmInfo.split("@")[2];
			itmMaxVal = itmInfo.split("@")[3];
			if((EmPcsHeart!="")&&(itmMinVal!="")&&(EmPcsHeart<itmMinVal)){
				$.messager.alert("提示","心率值荒诞,范围"+itmMinVal+"-"+itmMaxVal+"!");
				$("#EmPcsHeartAgain").val("");
				return false;
			}
			
			if((EmPcsHeart!="")&&(itmMaxVal!="")&&(EmPcsHeart>itmMaxVal)){
				$.messager.alert("提示","心率值荒诞,范围"+itmMinVal+"-"+itmMaxVal+"!");
				$("#EmPcsHeartAgain").val("");
				return false;
			}
		}
		
		var EmPcsPulse =  $("#EmPcsPulseAgain").val();  ///脉搏
		EmPcsPulse = parseInt(EmPcsPulse);
		itmInfo = SignNormalObj.pulse; //hxy 2020-03-27 原：heartbeat
		if(itmInfo!=undefined){
			itmMinVal = itmInfo.split("@")[2];
			itmMaxVal = itmInfo.split("@")[3];
			if((EmPcsPulse!="")&&(itmMinVal!="")&&(EmPcsPulse<itmMinVal)){
				$.messager.alert("提示","脉搏值荒诞,范围"+itmMinVal+"-"+itmMaxVal+"!");
				$("#EmPcsPulseAgain").val("");
				return false;
			}
			
			if((EmPcsPulse!="")&&(itmMaxVal!="")&&(EmPcsPulse>itmMaxVal)){
				$.messager.alert("提示","脉搏值荒诞,范围"+itmMinVal+"-"+itmMaxVal+"!");
				$("#EmPcsPulseAgain").val("");
				return false;
			}
		}
		
		var EmPcsGlu =  $("#EmPcsGluAgain").val();  ///血糖 //hxy 2020-03-27 st
		EmPcsGlu = parseInt(EmPcsGlu);
		itmInfo = SignNormalObj.BLOODSUGAR;  
		if(itmInfo!=undefined){
			itmMinVal = itmInfo.split("@")[2];
			itmMaxVal = itmInfo.split("@")[3];
			if((EmPcsGlu!="")&&(itmMinVal!="")&&(EmPcsGlu<itmMinVal)){
				$.messager.alert("提示","血糖值荒诞,范围"+itmMinVal+"-"+itmMaxVal+"!");
				$("#EmPcsGluAgain").val("");
				return false;
			}
			
			if((EmPcsGlu!="")&&(itmMaxVal!="")&&(EmPcsGlu>itmMaxVal)){
				$.messager.alert("提示","血糖值荒诞,范围"+itmMinVal+"-"+itmMaxVal+"!");
				$("#EmPcsGluAgain").val("");
				return false;
			}
		}//ed
		
		var EmPcsSoP =  $("#EmPcsSoP2Again").val();  ///SoP2 //hxy 2020-03-27 st
		EmPcsSoP = parseInt(EmPcsSoP);
		itmInfo = SignNormalObj.SoP2;  
		if(itmInfo!=undefined){
			itmMinVal = itmInfo.split("@")[2];
			itmMaxVal = itmInfo.split("@")[3];
			if((EmPcsSoP!="")&&(itmMinVal!="")&&(EmPcsSoP<itmMinVal)){
				$.messager.alert("提示","SoP2值荒诞,范围"+itmMinVal+"-"+itmMaxVal+"!");
				$("#EmPcsSoP2Again").val("");
				return false;
			}
			
			if((EmPcsSoP!="")&&(itmMaxVal!="")&&(EmPcsSoP>itmMaxVal)){
				$.messager.alert("提示","SoP2值荒诞,范围"+itmMinVal+"-"+itmMaxVal+"!");
				$("#EmPcsSoP2Again").val("");
				return false;
			}
		}//ed
		
		return true;
		
	}
		
}


//-----------2019-9-24  handong   干预窗口  从广西医大二院复制-------start--------------//

/*// 新建干预措施窗口
function newConsult(emPCLvID){

	tmpEmPCLVID = emPCLvID;	
	EmPCLvIDSave=emPCLvID
	
	// 判断有木有id
	if ((emPCLvID == "")||(emPCLvID == undefined)){
		$.messager.alert('提示',"请先选择需要干预的患者!","warning");
		return;
	}
	
	cleanPlanWin();			/// 清空窗口内容
	OpenPlanWin();  		/// 新建干预措施窗口

}*/

function InitRecord(){
   
   	var columngz=[[
		{field:'EmPcsDateAgain',title:'日期',width:100,align:'center'}, 
		{field:'EmPcsTimeAgain',title:'时间',width:100,align:'center'},
		{field:'EmPcsTempAgain',title:'体温(℃)',width:80,align:'center',formatter:function(value,row,index){
			return value;
		}},
		{field:'EmPcsPulseAgain',title:'脉搏(次/分)',width:90,align:'center'},
		{field:'EmPcsHeartAgain',title:'心率(次/分)',width:90,align:'center',},
		{field:'EmPcsBreathAgain',title:'呼吸(次/分)',width:90,align:'center'},
		{field:'EmPcsSBPAgain',title:'SBP(mmHg)',width:95,align:'center'},
		{field:'EmPcsDBPAgain',title:'DBP(mmHg)',width:95,align:'center'},
		{field:'EmPcsSoP2Again',title:'SPO2(%)',width:90,align:'center'},
		{field:'EmPcsGluAgain',title:'血糖(mmol/L)',width:100,align:'center'},
	]];
	
	$('#IntRecord').datagrid({
		url:'dhcapp.broker.csp?ClassName=web.DHCEMPatCheckLevQuery&MethodName=InitMedHistory&EmPCLvID='+EmPCLvIDSave,
		fit:true,
		pageSize:40,        // 每页显示的记录条数
		pageList:[40,80],   // 可以设置每页记录条数的列表
		rownumbers:true,
		border:false,
		columns:columngz,		
	    singleSelect:true,
		loadMsg:'正在加载信息...',
		pagination:true,
	});
}

/// 清空干预措施界面内容
function cleanPlanWin(){
	$("#EmPcsTimeAgain").datetimebox('setText',""); 		///  时间
	$("#EmPcsTempAgain").val("");		///  体温
	$("#EmPcsPulseAgain").val("");		///  脉搏
	$("#EmPcsHeartAgain").val("");		///  心率
	$("#EmPcsBreathAgain").val("");   	///  呼吸频率
	$("#EmPcsSBPAgain").val("");      	///  血压(BP)收缩压
	$("#EmPcsDBPAgain").val("");       	///  舒张压
	$("#EmPcsSoP2Again").val("");     	///  血氧饱合度SPO2
	$("#EmPcsGluAgain").val(""); 		///	 血糖  
}

/*// 干预措施窗口
function OpenPlanWin(){
	
	//if($('#SetPlanWin').is(":visible")){return;}  
	$('#SetPlanWin').window({
		title:'干预措施',
		collapsible:true,
		border:true,
		closed:"true",
		width:1000,
		height:500,	
		modal:true,
		minimizable:false
	}); 
	$('#SetPlanWin').tabs({    
	    border:false,
	    fit:true, 
	    onSelect:function(title){
		    $("#EmPcsTempAgain").focus();
	        var tab = $('#SetPlanWin').tabs('getSelected'); 		 		/// 获取选择的面板
	        var tbId = tab.attr("id");
	        var maintab="";	 
	        if (tbId == 'medhistroy'){
		        //alert("干预")
		       InitRecord();  //初始化干预记录 
		    }
		    
	    }
	});   
		       
	$('#SetPlanWin').tabs('select','干预措施'); //默认选中项
	$('#SetPlanWin').window('open');
	$("#EmPcsTempAgain").focus();
	initkeypress();
}*/

function saveMedItm(){
	var EmPcsTimeAgain="" //时间
	var EmPcsTempAgain=$("#EmPcsTempAgain").val();  //体温
	var EmPcsPulseAgain=$("#EmPcsPulseAgain").val(); //脉搏
	var EmPcsHeartAgain=$("#EmPcsHeartAgain").val(); //心率
	var EmPcsBreathAgain=$("#EmPcsBreathAgain").val(); //呼吸
	var EmPcsSBPAgain=$("#EmPcsSBPAgain").val(); //SBP收缩压
	var EmPcsDBPAgain=$("#EmPcsDBPAgain").val(); //DBP舒张压
	var EmPcsSoP2Again=$("#EmPcsSoP2Again").val(); //SPO2
	var EmPcsGluAgain=$("#EmPcsGluAgain").val(); //血糖
	
	if((EmPcsTempAgain=="")&(EmPcsPulseAgain=="")&(EmPcsHeartAgain=="")&(EmPcsBreathAgain=="")&(EmPcsSBPAgain=="")&(EmPcsDBPAgain=="")&(EmPcsSoP2Again=="")&(EmPcsGluAgain=="")){
		$.messager.alert('提示','请先填写再保存!','info');
		return;
	} //2020-03-17
	
	//alert(EmPcsHeartAgain+EmPcsPulseAgain+EmPcsPulseAgain)
	var ListData=EmPcsTimeAgain+"^"+EmPcsTempAgain+"^"+EmPcsPulseAgain+"^"+EmPcsHeartAgain;
	ListData=ListData+"^"+EmPcsBreathAgain+"^"+EmPcsSBPAgain+"^"+EmPcsDBPAgain;
	ListData=ListData+"^"+EmPcsSoP2Again+"^"+EmPcsGluAgain;
	ListData=ListData+"^"+EmPCLvIDSave;
	
	runClassMethod("web.DHCEMPatCheckLevQuery","MultSaveVitSigns",{'ListData':ListData},function(data){
		if(data==0){
			$.messager.alert('提示','保存成功！','info');
			cleanPlanWin(); //2020-03-17
		}else{
			$.messager.alert('提示','保存失败！','info');
		}
	});	
}
//-----------------------------------------------------------------------------------end----------------//

function clearNoNum(obj){ 
    obj.value = obj.value.replace(/[^\d.]/g,"");  //清除“数字”和“.”以外的字符  
    obj.value = obj.value.replace(/\.{2,}/g,"."); //只保留第一个. 清除多余的  
    obj.value = obj.value.replace(".","$#$").replace(/\./g,"").replace("$#$","."); 
    obj.value = obj.value.replace(/^(\-)*(\d+)\.(\d\d).*$/,'$1$2.$3');//只能输入两个小数  
    if(obj.value.indexOf(".")< 0 && obj.value !=""){//以上已经过滤，此处控制的是如果没有小数点，首位不能为类似于 01、02的金额 
        obj.value= parseFloat(obj.value); 
    } 
}
