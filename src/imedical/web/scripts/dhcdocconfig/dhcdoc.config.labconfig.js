var arrayObj1=new Array(
     // new Array("Check_AlertAddBoodFeeItem","AlertAddBoodFeeItem"),
      new Array("Check_UseHospSepLabConfig","UseHospSepLabConfig"),
      new Array("Check_NotCheckSameLabSpecItem","NotCheckSameLabSpecItem")
);
$(function(){
	InitHospital();
	$("#Combo_Hospital").combobox({
       onChange: function (o) {	
		   LoadLabConfig();
       }
   })
   $("#Check_UseHospSepLabConfig").click(function(){
	      var UseHospSepLabConfig=$("#Check_UseHospSepLabConfig").checkbox('getValue')?1:0;
		  var str="UseHospSepLabConfig"+String.fromCharCode(1)+UseHospSepLabConfig;
		  var value=$.m({
			ClassName:"web.DHCDocConfig",
			MethodName:"SaveConfig",
		   	Coninfo:str
		  },false);
	      if(value=="0"){
			 LoadLabConfig();
		  }
    });
    InitComboBloodFee();
	LoadLabConfig();
	$("#BSave").click(SaveLabConfig);
})
function LoadLabConfig()
{
	for( var i=0;i<arrayObj1.length;i++) {
		   var param1=arrayObj1[i][0];
		   var param2=arrayObj1[i][1];
	       LoadLabCheckConfig(param1,param2);	    
    };
    LoadLabSttTime("DTPicker_LabSttTime","LabSttTime");
	datadefault();
}
function InitHospital()
{
	$("#Combo_Hospital").combobox({      
    	valueField:'HOSPRowId',   
    	textField:'HOSPDesc',
    	url:"./dhcdoc.cure.query.combo.easyui.csp",
    	onBeforeLoad:function(param){
			param.ClassName = 'DHCDoc.DHCDocConfig.InstrArcim';
			param.QueryName = 'GetHos';
			param.ArgCnt =0;
		}  
	});
}
function InitComboBloodFee()
{
	InitCombo("Combo_BloodFee");
	InitCombo("Combo_BloodFeeArtery");
	InitCombo("Combo_BloodFeePeripheral");
}

function InitCombo(id){
	$('#'+id).combogrid({
		panelWidth:500,
		panelHeight:400,
		delay: 500,    
		mode: 'remote',    
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.ArcItemConfig&QueryName=FindAllItem",
		fitColumns: true,   
		striped: true,   
		editable:true,   
		pagination : true,//是否分页   
		rownumbers:true,//序号   
		collapsible:false,//是否可折叠的   
		fit: true,//自动大小   
		pageSize: 10,//每页显示的记录条数，默认为10   
		pageList: [10],//可以设置每页记录条数的列表   
		method:'post', 
		idField: 'ArcimRowID',    
		textField: 'ArcimDesc',    
		columns: [[    
			{field:'ArcimDesc',title:'名称',width:400,sortable:true},
			{field:'ArcimRowID',title:'ID',width:120,sortable:true},
			{field:'selected',title:'ID',width:120,sortable:true,hidden:true}
		]],
		onSelect: function (){
			var selected = $('#'+id).combogrid('grid').datagrid('getSelected');  
			if (selected) { 
			  $('#'+id).combogrid("options").value=selected.ArcimRowID;
			}
		},
		onBeforeLoad:function(param){
			if (param['q']) {
				var desc=param['q'];
			}else{
				var desc="";
			}
			param = $.extend(param,{Alias:desc});
		},
		onChange:function(newValue,oldValue){
			if ((newValue=="")||(!newValue)) {
				$(this).combogrid('setValue','');
				$('#Combo_BloodFeePeripheral').combogrid("options").value="";
			}
		}
	});
}
function LoadLabSttTime(param1,param2)
{
	var Hospital="";
	var UseHospSepLabConfig=$("#Check_UseHospSepLabConfig").is(":checked");
	if (UseHospSepLabConfig) {
		 Hospital=$("#Combo_Hospital").combobox("getValue");
	}
	var objScope=$.m({
		ClassName:"DHCDoc.DHCDocConfig.DocConfig",
		MethodName:"getLabSttTime",
	   	value:param2,
	   	HospId:Hospital
	},false);
	objScope=eval("(" + objScope + ")");
	if (objScope.result==""){
		objScope.result="00:00:00";
	}
	$("#"+param1+"").timespinner('setValue',objScope.result);
}
function LoadLabCheckConfig(param1,param2)
{
	if (param2=="NotCheckSameLabSpecItem"){
		var UseHospSepLabConfig=$("#Check_UseHospSepLabConfig").checkbox('getValue')?1:0
		LoadLabOtherCheck(param1,param2,UseHospSepLabConfig)
	}else{
		var value=$.m({
			ClassName:"web.DHCDocConfig",
			MethodName:"GetConfigNode",
		   	Node:param2
		},false);
		if (value==1){
			$("#"+param1+"").checkbox('check');
		}else{
			$("#"+param1+"").checkbox('uncheck');
		}
	}
};
function LoadLabOtherCheck(param1,param2,UseHospSepLabConfig)
{
	var Hospital="";
	var UseHospSepLabConfig=$("#Check_UseHospSepLabConfig").checkbox("getValue")?1:0;
	var value=$.m({
		ClassName:"DHCDoc.DHCDocConfig.DocConfig",
		MethodName:"GetLabOtherCheck",
	   	Node:param2,
	   	HospId:Hospital
	},false);
	if (value==1){
		$("#"+param1+"").checkbox('check');
	}else{
		$("#"+param1+"").checkbox('uncheck');
	}
}
function datadefault(){
	var Hospital="";
	var UseHospSepLabConfig=$("#Check_UseHospSepLabConfig").checkbox("getValue")?1:0;
	if (UseHospSepLabConfig=="1"){
		Hospital=$("#Combo_Hospital").combobox("getValue");
	}
	var objScope=$.m({
		ClassName:"DHCDoc.DHCDocConfig.ArcItemConfig",
		MethodName:"getLabBloodFeeData",
	   	value:"BloodFeeItem",
	   	HospId:Hospital
	},false);
	objScope=eval("(" + objScope + ")");
	$('#Combo_BloodFee').combogrid('setValue',objScope.result.split("^")[1])
	$('#Combo_BloodFee').combogrid("options").value=objScope.result.split("^")[0];
			
	var objScope=$.m({
		ClassName:"DHCDoc.DHCDocConfig.ArcItemConfig",
		MethodName:"getLabBloodFeeData",
	   value:"BloodFeeArtery",
	   	HospId:Hospital
	},false);
	objScope=eval("(" + objScope + ")");
	$('#Combo_BloodFeeArtery').combogrid('setValue',objScope.result.split("^")[1])
	$('#Combo_BloodFeeArtery').combogrid("options").value=objScope.result.split("^")[0];
			
	var objScope=$.m({
		ClassName:"DHCDoc.DHCDocConfig.ArcItemConfig",
		MethodName:"getLabBloodFeeData",
	   	value:"BloodFeePeripheral",
	   	HospId:Hospital
	},false);
	objScope=eval("(" + objScope + ")");
	$('#Combo_BloodFeePeripheral').combogrid('setValue',objScope.result.split("^")[1])
	$('#Combo_BloodFeePeripheral').combogrid("options").value=objScope.result.split("^")[0];
}
function SaveLabConfig()
{
	  var Hospital="";
	  var UseHospSepLabConfig=$("#Check_UseHospSepLabConfig").checkbox("getValue");
	  if (UseHospSepLabConfig) {
		 Hospital=$("#Combo_Hospital").combobox("getValue");
		 if(Hospital==""){
			 $.messager.alert("提示", "请选择医院");
			 return false;
		 }
	 }
	 var ArcimRowid=$('#Combo_BloodFee').combogrid('getValue');
     if(ArcimRowid!="") ArcimRowid=$('#Combo_BloodFee').combogrid("options").value
	 if (ArcimRowid.indexOf("||")<=0) {ArcimRowid="";}
	 var Data="BloodFeeItem"+String.fromCharCode(1)+ArcimRowid+String.fromCharCode(1)+Hospital;
	 var ArcimRowid=$('#Combo_BloodFeeArtery').combogrid('getValue');
     if(ArcimRowid!="") ArcimRowid=$('#Combo_BloodFeeArtery').combogrid("options").value
     if (ArcimRowid.indexOf("||")<=0) {ArcimRowid="";}
	 var Data=Data+String.fromCharCode(2)+"BloodFeeArtery"+String.fromCharCode(1)+ArcimRowid+String.fromCharCode(1)+Hospital;
	 var ArcimRowid=$('#Combo_BloodFeePeripheral').combogrid('getValue');
     if(ArcimRowid!="") ArcimRowid=$('#Combo_BloodFeePeripheral').combogrid("options").value
	 if (ArcimRowid.indexOf("||")<=0) {ArcimRowid="";}
	 var Data=Data+String.fromCharCode(2)+"BloodFeePeripheral"+String.fromCharCode(1)+ArcimRowid+String.fromCharCode(1)+Hospital;
	/*var AlertAddBoodFeeItem=0;
	if ($("#Check_AlertAddBoodFeeItem").is(":checked")) {
		AlertAddBoodFeeItem=1
	};
	Data=Data+String.fromCharCode(2)+"AlertAddBoodFeeItem"+String.fromCharCode(1)+AlertAddBoodFeeItem;*/
	var NotCheckSameLabSpecItem=$("#Check_NotCheckSameLabSpecItem").checkbox("getValue")?1:0;
	Data=Data+String.fromCharCode(2)+"NotCheckSameLabSpecItem"+String.fromCharCode(1)+NotCheckSameLabSpecItem+String.fromCharCode(1)+Hospital;
	var LabSttTime=$('#DTPicker_LabSttTime').val();
	var time= /^([0-1]?[0-9]|2[0-3]):([0-5][0-9]):([0-5][0-9])$/;
	if (time.test(LabSttTime) != true) {
		    $.messager.alert("提示", "住院检验开始时间点时间格式不正确", "error");
			return false;
	}
	if(LabSttTime=="00:00:00") LabSttTime="";
	Data=Data+String.fromCharCode(2)+"LabSttTime"+String.fromCharCode(1)+LabSttTime+String.fromCharCode(1)+Hospital;
	if (UseHospSepLabConfig){
		var value=$.m({
			ClassName:"web.DHCDocConfig",
			MethodName:"SaveConfig1New",
		   	Coninfo:Data
		},false);
       	if(value=="0"){
			 $.messager.popover({msg: '保存成功!',type:'success'});
			 return false;
		}
	    Data="UseHospSepLabConfig"+String.fromCharCode(1)+"1";
	    var value=$.m({
			ClassName:"web.DHCDocConfig",
			MethodName:"SaveConfig",
		   	Coninfo:Data
		},false);
	}else{
		Data=Data+String.fromCharCode(2)+"UseHospSepLabConfig"+String.fromCharCode(1)+"0";
		var value=$.m({
			ClassName:"web.DHCDocConfig",
			MethodName:"SaveConfig",
		   	Coninfo:Data
		},false);
       	if(value=="0"){
			 $.messager.popover({msg: '保存成功!',type:'success'});	
			 return false;
		}
	}
	
}