///Creator:hxy
///Date:2020-02-27
///patchksign.js
var SignNormalObj={}; ///������������ֵ
$(function(){	
	cleanPlanWin();			/// ��մ�������
	
	initInputEvent(); //hxy 2020-03-11
	
	initSignNormalValue();   ///��ȡ����������ʼ������ֵ 
	
	$('#SetPlanWin').tabs({    
	    border:false,
	    fit:true, 
	    onSelect:function(title){
		    $("#EmPcsTempAgain").focus();
	        var tab = $('#SetPlanWin').tabs('getSelected'); 		 		/// ��ȡѡ������
	        var tbId = tab.attr("id");
	        var maintab="";	 
	        if (tbId == 'medhistroy'){
		       InitRecord();  //��ʼ����Ԥ��¼ 
		    }
		    
	    }
	});   
		       
	$('#SetPlanWin').tabs('select','��Ԥ��ʩ'); //Ĭ��ѡ����
	$("#EmPcsTempAgain").focus();
})

///�ߺ�̨����:��ȡ������������ֵ
function initSignNormalValue(){
	runClassMethod("web.DHCEMPatCheckLevQuery","GetSignNoralList",{},
	function(jsonString){
		SignNormalObj = jsonString;
	},'json',false)
}

//ע��input���¼�
function initInputEvent(){
	
	//�س���������һԪ�� 
	var $inp = $('.enter');//input:text
	$inp.bind('keydown', function (e) {
		var key = e.keyCode;
		if (key == 13) {
			//�ĵ�ֵ��֤
			valiAbsValueBoolean();
			var nxtIdx = $inp.index(this) + 1;
			$(".enter:eq(" + nxtIdx + ")").focus();
		}
	});
	
	///  ��������
	$('input[name="EmPcsAgain"]').bind("blur",valiAbsValueBoolean);
}

function valiAbsValueBoolean(){
	if(!valiAbsValueAgain()){}
}
///ȡ�����жϻĵ�ֵ
function valiAbsValueAgain(){
	if(Object.keys(SignNormalObj).length>0){
		var itmInfo = "";
		var itmMinVal="";
		var itmMaxVal="";
		var EmPcsSBP = $("#EmPcsSBPAgain").val();  ///����ѹ
		EmPcsSBP = parseInt(EmPcsSBP);
		itmInfo = SignNormalObj.sysPressure;
		if(itmInfo!=undefined){
			itmMinVal = itmInfo.split("@")[2];
			itmMaxVal = itmInfo.split("@")[3];
			if((EmPcsSBP!="")&&(itmMinVal!="")&&(EmPcsSBP<itmMinVal)){
				$.messager.alert("��ʾ","����ѹֵ�ĵ�,��Χ"+itmMinVal+"-"+itmMaxVal+"!");
				$("#EmPcsSBPAgain").val("");
				return false;
			}
			
			if((EmPcsSBP!="")&&(itmMaxVal!="")&&(EmPcsSBP>itmMaxVal)){
				$.messager.alert("��ʾ","����ѹֵ�ĵ�,��Χ"+itmMinVal+"-"+itmMaxVal+"!");
				$("#EmPcsSBPAgain").val("");
				return false;
			}
		}
		
		var EmPcsDBP =  $("#EmPcsDBPAgain").val();  ///����ѹ
		EmPcsDBP = parseInt(EmPcsDBP);
		if(itmInfo!=undefined){
			itmMinVal = itmInfo.split("@")[2];
			itmMaxVal = itmInfo.split("@")[3];
			if((EmPcsDBP!="")&&(itmMinVal!="")&&(EmPcsDBP<itmMinVal)){
				$.messager.alert("��ʾ","����ѹֵ�ĵ�,��Χ"+itmMinVal+"-"+itmMaxVal+"!");
				$("#EmPcsDBPAgain").val("");
				return false;
			}
			
			if((EmPcsDBP!="")&&(itmMaxVal!="")&&(EmPcsDBP>itmMaxVal)){
				$.messager.alert("��ʾ","����ѹֵ�ĵ�,��Χ"+itmMinVal+"-"+itmMaxVal+"!");
				$("#EmPcsDBPAgain").val("");
				return false;
			}
		}
		
		
		var EmPcsSoP2 =  $("#EmPcsSoP2Again").val();  ///Ѫ������Ũ��
		EmPcsSoP2 = parseInt(EmPcsSoP2);
		itmInfo = SignNormalObj.degrBlood;  
		if(itmInfo!=undefined){
			itmMinVal = itmInfo.split("@")[2];
			itmMaxVal = itmInfo.split("@")[3];
			if((EmPcsSoP2!="")&&(itmMinVal!="")&&(EmPcsSoP2<itmMinVal)){
				$.messager.alert("��ʾ","Ѫ������Ũ��ֵ�ĵ�,��Χ"+itmMinVal+"-"+itmMaxVal+"!");
				$("#EmPcsSoP2Again").val("");
				return false; 
			}
			
			if((EmPcsSoP2!="")&&(itmMaxVal!="")&&(EmPcsSoP2>itmMaxVal)){
				$.messager.alert("��ʾ","Ѫ������Ũ��ֵ�ĵ�,��Χ"+itmMinVal+"-"+itmMaxVal+"!");
				$("#EmPcsSoP2Again").val("");
				return false;
			}
		}
		
		
		var EmPcsBreath =  $("#EmPcsBreathAgain").val();  ///����Ƶ��
		EmPcsBreath = parseInt(EmPcsBreath);
		itmInfo = SignNormalObj.breath;  
		if(itmInfo!=undefined){
			itmMinVal = itmInfo.split("@")[2];
			itmMaxVal = itmInfo.split("@")[3];
			if((EmPcsBreath!="")&&(itmMinVal!="")&&(EmPcsBreath<itmMinVal)){
				$.messager.alert("��ʾ","����Ƶ��ֵ�ĵ�,��Χ"+itmMinVal+"-"+itmMaxVal+"!");
				$("#EmPcsBreathAgain").val("");
				return false;
			}
			
			if((EmPcsBreath!="")&&(itmMaxVal!="")&&(EmPcsBreath>itmMaxVal)){
				$.messager.alert("��ʾ","����Ƶ��ֵ�ĵ�,��Χ"+itmMinVal+"-"+itmMaxVal+"!");
				$("#EmPcsBreathAgain").val("");
				return false;
			}
		}
		
		var EmPcsTemp =  $("#EmPcsTempAgain").val();  ///����
		EmPcsTemp = parseInt(EmPcsTemp);
		itmInfo = SignNormalObj.temperature;  
		if(itmInfo!=undefined){
			itmMinVal = itmInfo.split("@")[2];
			itmMaxVal = itmInfo.split("@")[3];
			if((EmPcsTemp!="")&&(itmMinVal!="")&&(EmPcsTemp<itmMinVal)){
				$.messager.alert("��ʾ","����ֵ�ĵ�,��Χ"+itmMinVal+"-"+itmMaxVal+"!");
				$("#EmPcsTempAgain").val("");
				return false;
			}
			
			if((EmPcsTemp!="")&&(itmMaxVal!="")&&(EmPcsTemp>itmMaxVal)){
				$.messager.alert("��ʾ","����ֵ�ĵ�,��Χ"+itmMinVal+"-"+itmMaxVal+"!");
				$("#EmPcsTempAgain").val("");
				return false;
			}
		}
		
		var EmPcsHeart =  $("#EmPcsHeartAgain").val();  ///����
		EmPcsHeart = parseInt(EmPcsHeart);
		itmInfo = SignNormalObj.heartbeat; 
		if(itmInfo!=undefined){
			itmMinVal = itmInfo.split("@")[2];
			itmMaxVal = itmInfo.split("@")[3];
			if((EmPcsHeart!="")&&(itmMinVal!="")&&(EmPcsHeart<itmMinVal)){
				$.messager.alert("��ʾ","����ֵ�ĵ�,��Χ"+itmMinVal+"-"+itmMaxVal+"!");
				$("#EmPcsHeartAgain").val("");
				return false;
			}
			
			if((EmPcsHeart!="")&&(itmMaxVal!="")&&(EmPcsHeart>itmMaxVal)){
				$.messager.alert("��ʾ","����ֵ�ĵ�,��Χ"+itmMinVal+"-"+itmMaxVal+"!");
				$("#EmPcsHeartAgain").val("");
				return false;
			}
		}
		
		var EmPcsPulse =  $("#EmPcsPulseAgain").val();  ///����
		EmPcsPulse = parseInt(EmPcsPulse);
		itmInfo = SignNormalObj.pulse; //hxy 2020-03-27 ԭ��heartbeat
		if(itmInfo!=undefined){
			itmMinVal = itmInfo.split("@")[2];
			itmMaxVal = itmInfo.split("@")[3];
			if((EmPcsPulse!="")&&(itmMinVal!="")&&(EmPcsPulse<itmMinVal)){
				$.messager.alert("��ʾ","����ֵ�ĵ�,��Χ"+itmMinVal+"-"+itmMaxVal+"!");
				$("#EmPcsPulseAgain").val("");
				return false;
			}
			
			if((EmPcsPulse!="")&&(itmMaxVal!="")&&(EmPcsPulse>itmMaxVal)){
				$.messager.alert("��ʾ","����ֵ�ĵ�,��Χ"+itmMinVal+"-"+itmMaxVal+"!");
				$("#EmPcsPulseAgain").val("");
				return false;
			}
		}
		
		var EmPcsGlu =  $("#EmPcsGluAgain").val();  ///Ѫ�� //hxy 2020-03-27 st
		EmPcsGlu = parseInt(EmPcsGlu);
		itmInfo = SignNormalObj.BLOODSUGAR;  
		if(itmInfo!=undefined){
			itmMinVal = itmInfo.split("@")[2];
			itmMaxVal = itmInfo.split("@")[3];
			if((EmPcsGlu!="")&&(itmMinVal!="")&&(EmPcsGlu<itmMinVal)){
				$.messager.alert("��ʾ","Ѫ��ֵ�ĵ�,��Χ"+itmMinVal+"-"+itmMaxVal+"!");
				$("#EmPcsGluAgain").val("");
				return false;
			}
			
			if((EmPcsGlu!="")&&(itmMaxVal!="")&&(EmPcsGlu>itmMaxVal)){
				$.messager.alert("��ʾ","Ѫ��ֵ�ĵ�,��Χ"+itmMinVal+"-"+itmMaxVal+"!");
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
				$.messager.alert("��ʾ","SoP2ֵ�ĵ�,��Χ"+itmMinVal+"-"+itmMaxVal+"!");
				$("#EmPcsSoP2Again").val("");
				return false;
			}
			
			if((EmPcsSoP!="")&&(itmMaxVal!="")&&(EmPcsSoP>itmMaxVal)){
				$.messager.alert("��ʾ","SoP2ֵ�ĵ�,��Χ"+itmMinVal+"-"+itmMaxVal+"!");
				$("#EmPcsSoP2Again").val("");
				return false;
			}
		}//ed
		
		return true;
		
	}
		
}


//-----------2019-9-24  handong   ��Ԥ����  �ӹ���ҽ���Ժ����-------start--------------//

/*// �½���Ԥ��ʩ����
function newConsult(emPCLvID){

	tmpEmPCLVID = emPCLvID;	
	EmPCLvIDSave=emPCLvID
	
	// �ж���ľ��id
	if ((emPCLvID == "")||(emPCLvID == undefined)){
		$.messager.alert('��ʾ',"����ѡ����Ҫ��Ԥ�Ļ���!","warning");
		return;
	}
	
	cleanPlanWin();			/// ��մ�������
	OpenPlanWin();  		/// �½���Ԥ��ʩ����

}*/

function InitRecord(){
   
   	var columngz=[[
		{field:'EmPcsDateAgain',title:'����',width:100,align:'center'}, 
		{field:'EmPcsTimeAgain',title:'ʱ��',width:100,align:'center'},
		{field:'EmPcsTempAgain',title:'����(��)',width:80,align:'center',formatter:function(value,row,index){
			return value;
		}},
		{field:'EmPcsPulseAgain',title:'����(��/��)',width:90,align:'center'},
		{field:'EmPcsHeartAgain',title:'����(��/��)',width:90,align:'center',},
		{field:'EmPcsBreathAgain',title:'����(��/��)',width:90,align:'center'},
		{field:'EmPcsSBPAgain',title:'SBP(mmHg)',width:95,align:'center'},
		{field:'EmPcsDBPAgain',title:'DBP(mmHg)',width:95,align:'center'},
		{field:'EmPcsSoP2Again',title:'SPO2(%)',width:90,align:'center'},
		{field:'EmPcsGluAgain',title:'Ѫ��(mmol/L)',width:100,align:'center'},
	]];
	
	$('#IntRecord').datagrid({
		url:'dhcapp.broker.csp?ClassName=web.DHCEMPatCheckLevQuery&MethodName=InitMedHistory&EmPCLvID='+EmPCLvIDSave,
		fit:true,
		pageSize:40,        // ÿҳ��ʾ�ļ�¼����
		pageList:[40,80],   // ��������ÿҳ��¼�������б�
		rownumbers:true,
		border:false,
		columns:columngz,		
	    singleSelect:true,
		loadMsg:'���ڼ�����Ϣ...',
		pagination:true,
	});
}

/// ��ո�Ԥ��ʩ��������
function cleanPlanWin(){
	$("#EmPcsTimeAgain").datetimebox('setText',""); 		///  ʱ��
	$("#EmPcsTempAgain").val("");		///  ����
	$("#EmPcsPulseAgain").val("");		///  ����
	$("#EmPcsHeartAgain").val("");		///  ����
	$("#EmPcsBreathAgain").val("");   	///  ����Ƶ��
	$("#EmPcsSBPAgain").val("");      	///  Ѫѹ(BP)����ѹ
	$("#EmPcsDBPAgain").val("");       	///  ����ѹ
	$("#EmPcsSoP2Again").val("");     	///  Ѫ�����϶�SPO2
	$("#EmPcsGluAgain").val(""); 		///	 Ѫ��  
}

/*// ��Ԥ��ʩ����
function OpenPlanWin(){
	
	//if($('#SetPlanWin').is(":visible")){return;}  
	$('#SetPlanWin').window({
		title:'��Ԥ��ʩ',
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
	        var tab = $('#SetPlanWin').tabs('getSelected'); 		 		/// ��ȡѡ������
	        var tbId = tab.attr("id");
	        var maintab="";	 
	        if (tbId == 'medhistroy'){
		        //alert("��Ԥ")
		       InitRecord();  //��ʼ����Ԥ��¼ 
		    }
		    
	    }
	});   
		       
	$('#SetPlanWin').tabs('select','��Ԥ��ʩ'); //Ĭ��ѡ����
	$('#SetPlanWin').window('open');
	$("#EmPcsTempAgain").focus();
	initkeypress();
}*/

function saveMedItm(){
	var EmPcsTimeAgain="" //ʱ��
	var EmPcsTempAgain=$("#EmPcsTempAgain").val();  //����
	var EmPcsPulseAgain=$("#EmPcsPulseAgain").val(); //����
	var EmPcsHeartAgain=$("#EmPcsHeartAgain").val(); //����
	var EmPcsBreathAgain=$("#EmPcsBreathAgain").val(); //����
	var EmPcsSBPAgain=$("#EmPcsSBPAgain").val(); //SBP����ѹ
	var EmPcsDBPAgain=$("#EmPcsDBPAgain").val(); //DBP����ѹ
	var EmPcsSoP2Again=$("#EmPcsSoP2Again").val(); //SPO2
	var EmPcsGluAgain=$("#EmPcsGluAgain").val(); //Ѫ��
	
	if((EmPcsTempAgain=="")&(EmPcsPulseAgain=="")&(EmPcsHeartAgain=="")&(EmPcsBreathAgain=="")&(EmPcsSBPAgain=="")&(EmPcsDBPAgain=="")&(EmPcsSoP2Again=="")&(EmPcsGluAgain=="")){
		$.messager.alert('��ʾ','������д�ٱ���!','info');
		return;
	} //2020-03-17
	
	//alert(EmPcsHeartAgain+EmPcsPulseAgain+EmPcsPulseAgain)
	var ListData=EmPcsTimeAgain+"^"+EmPcsTempAgain+"^"+EmPcsPulseAgain+"^"+EmPcsHeartAgain;
	ListData=ListData+"^"+EmPcsBreathAgain+"^"+EmPcsSBPAgain+"^"+EmPcsDBPAgain;
	ListData=ListData+"^"+EmPcsSoP2Again+"^"+EmPcsGluAgain;
	ListData=ListData+"^"+EmPCLvIDSave;
	
	runClassMethod("web.DHCEMPatCheckLevQuery","MultSaveVitSigns",{'ListData':ListData},function(data){
		if(data==0){
			$.messager.alert('��ʾ','����ɹ���','info');
			cleanPlanWin(); //2020-03-17
		}else{
			$.messager.alert('��ʾ','����ʧ�ܣ�','info');
		}
	});	
}
//-----------------------------------------------------------------------------------end----------------//

function clearNoNum(obj){ 
    obj.value = obj.value.replace(/[^\d.]/g,"");  //��������֡��͡�.��������ַ�  
    obj.value = obj.value.replace(/\.{2,}/g,"."); //ֻ������һ��. ��������  
    obj.value = obj.value.replace(".","$#$").replace(/\./g,"").replace("$#$","."); 
    obj.value = obj.value.replace(/^(\-)*(\d+)\.(\d\d).*$/,'$1$2.$3');//ֻ����������С��  
    if(obj.value.indexOf(".")< 0 && obj.value !=""){//�����Ѿ����ˣ��˴����Ƶ������û��С���㣬��λ����Ϊ������ 01��02�Ľ�� 
        obj.value= parseFloat(obj.value); 
    } 
}
