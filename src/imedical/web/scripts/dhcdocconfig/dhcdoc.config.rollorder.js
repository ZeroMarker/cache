//var IPCheckFeeRowId="";
//var IPSeasonAddFeeRowId="";
var arrayObj1=new Array(
	new Array("Check_EnableAir","EnableAir"),
	new Array("Check_EnableHeat","EnableHeat")
);
$(function(){
	InitHospList();
	$("#BSave").click(SaveRollOrderSet);
})
function InitHospList()
{
	var hospComp = GenHospComp("Doc_BaseConfig_RollOrder");
	hospComp.jdata.options.onSelect = function(e,t){
		/*InitCombo("SSDBCombo_IPCheckFee");
		InitCombo("SSDBCombo_SeasonAddFee");
		InitPrior("SSDBCombo_RollItemPrior","RollItemPrior");
		LoadRollOrderSet();*/
		//所有的checkbox radio元素初始化 
		for( var i=0;i<arrayObj1.length;i++) {
		   var param1=arrayObj1[i][0];
		   var param2=arrayObj1[i][1];
	       LoadCheckData(param1,param2);	    
		}
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		/*InitCombo("SSDBCombo_IPCheckFee");
		InitCombo("SSDBCombo_SeasonAddFee");
		InitPrior("SSDBCombo_RollItemPrior","RollItemPrior");
		LoadRollOrderSet();*/
		//所有的checkbox radio元素初始化 
		for( var i=0;i<arrayObj1.length;i++) {
		   var param1=arrayObj1[i][0];
		   var param2=arrayObj1[i][1];
	       LoadCheckData(param1,param2);	    
		}
	}
}
function LoadCheckData(param1,param2)
{
	var value=$.m({
		 ClassName:"web.DHCDocConfig",
		 MethodName:"GetConfigNode",
		 Node:param2,
		 HospId:$HUI.combogrid('#_HospList').getValue()
	},false);
	if (value=="Y") {
		$("#"+param1+"").checkbox('check');
	}else{
		$("#"+param1+"").checkbox('uncheck');
	}
}
function InitCombo(param1)
{
	$("#"+param1+"").combogrid({
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
			var selected = $("#"+param1+"").combogrid('grid').datagrid('getSelected');  
			if (selected) { 
			  $("#"+param1+"").combogrid("options").value=selected.ArcimRowID;
			  if (param1=="SSDBCombo_IPCheckFee") {
				  IPCheckFeeRowId=selected.ArcimRowID;
			  }else{
				  IPSeasonAddFeeRowId=selected.ArcimRowID;
			  }
			}
		},
		onBeforeLoad:function(param){
	         var desc=param['q'];
	         param = $.extend(param,{Alias:param["q"]});
	     }
	});
}
function InitPrior(param1,param2)
{
	$("#"+param1+"").combobox({      
    	valueField:'OECPRRowId',   
    	textField:'OECPRDesc',
    	url:"./dhcdoc.cure.query.combo.easyui.csp",
    	onBeforeLoad:function(param){
			param.ClassName = 'DHCDoc.DHCDocConfig.RollOrder';
			param.QueryName = 'FindPrior';
			param.Arg1 =param2;
			param.ArgCnt =1;
		}  
	});
}
function LoadRollOrderSet()
{
	var value=$.m({
		 ClassName:"web.DHCDocConfig",
		 MethodName:"GetConfigNode",
		 Node:"RollNotUseNewConfig"
	},false);
	if(value==1) $("#Check_RollNotUseNewConfig").checkbox('check');
	//住院诊疗费
	var objScope=$.m({
		 ClassName:"DHCDoc.DHCDocConfig.RollOrder",
		 MethodName:"getRollIPCheckFee",
		 value:"RollIPCheckFee"
	},false);
	objScope=eval("(" + objScope + ")");
	if(objScope.result.split("^")[0]!=""){
		$('#SSDBCombo_IPCheckFee').combogrid('setValue',objScope.result.split("^")[3]);
		$('#SSDBCombo_IPCheckFee').combogrid("options").value=objScope.result.split("^")[0];
		$("#DTP_IPCheckStartDate").datebox("setValue", objScope.result.split("^")[1]);
		IPCheckFeeRowId=objScope.result.split("^")[0];
	}
	//空调费 取暖费
	var objScope=$.m({
		 ClassName:"DHCDoc.DHCDocConfig.RollOrder",
		 MethodName:"getRollSeasonAddFee",
		 value:"RollSeasonAddFee"
	},false);
	objScope=eval("(" + objScope + ")");
	if(objScope.result.split("^")[0]!=""){
		$('#SSDBCombo_SeasonAddFee').combogrid('setValue',objScope.result.split("^")[3]);
		$('#SSDBCombo_SeasonAddFee').combogrid("options").value=objScope.result.split("^")[0];
		$("#DTP_ReasonFeeStartDate").datebox("setValue", objScope.result.split("^")[1]);
		$("#DTP_ReasonFeeEndDate").datebox("setValue", objScope.result.split("^")[2]);	
		IPSeasonAddFeeRowId=objScope.result.split("^")[0];			
	}
}
function SaveRollOrderSet()
{
	var Data="";
	/*var RollIPCheckFeeStr="";
	var RollIPCheckFeeRowid = IPCheckFeeRowId;
	if ($("#SSDBCombo_IPCheckFee").combogrid('getText')=="")RollIPCheckFeeRowid="", IPCheckFeeRowId="";
	if(RollIPCheckFeeRowid!=""){
		var IPCheckStartDate=$('#DTP_IPCheckStartDate').datebox('getValue'); 
		 RollIPCheckFeeStr=RollIPCheckFeeRowid+"^"+IPCheckStartDate+"^"+"";
	}
	Data="RollIPCheckFee"+String.fromCharCode(1)+RollIPCheckFeeStr;
	var RollSeasonAddFeeStr="";
	var RollSeasonAddFeeRowid = IPSeasonAddFeeRowId;
	if ($("#SSDBCombo_SeasonAddFee").combogrid('getText')=="")RollSeasonAddFeeRowid="", IPSeasonAddFeeRowId="";
	if(RollSeasonAddFeeRowid!=""){
		var ReasonFeeStartDate=$('#DTP_ReasonFeeStartDate').datebox('getValue'); 
		var ReasonFeeEndDate=$('#DTP_ReasonFeeEndDate').datebox('getValue');
		RollSeasonAddFeeStr=RollSeasonAddFeeRowid+"^"+ReasonFeeStartDate+"^"+ReasonFeeEndDate;
	}
	if(Data==""){
		Data="RollSeasonAddFee"+String.fromCharCode(1)+RollIPCheckFeeStr;
	}else{
		Data=Data+String.fromCharCode(2)+"RollSeasonAddFee"+String.fromCharCode(1)+RollSeasonAddFeeStr;
	}
	var RollItemPrior=$("#SSDBCombo_RollItemPrior").combobox("getValue");
	
	if(Data==""){
			Data="RollItemPrior"+String.fromCharCode(1)+RollItemPrior;
	}else{
			Data=Data+String.fromCharCode(2)+"RollItemPrior"+String.fromCharCode(1)+RollItemPrior;
	}*/
	for( var i=0;i<arrayObj1.length;i++) {
	   var param1=arrayObj1[i][0];
	   var param2=arrayObj1[i][1];
       var value=$("#"+param1).checkbox('getValue')?"Y":"N";
       if (Data=="") {
	       Data=param2+String.fromCharCode(1)+value;
	   }else{
		   Data=Data+String.fromCharCode(2)+param2+String.fromCharCode(1)+value;
	   }    
	}
	var RollNotUseNewConfig=$("#Check_RollNotUseNewConfig").checkbox('getValue')?1:0;
	Data=Data+String.fromCharCode(2)+"RollNotUseNewConfig"+String.fromCharCode(1)+RollNotUseNewConfig;
	var value=$.m({
		 ClassName:"web.DHCDocConfig",
		 MethodName:"SaveConfig",
		 Coninfo:Data,
		 HospId:$HUI.combogrid('#_HospList').getValue()
	},false);
	if(value==0){
		$.messager.popover({msg:"保存成功!",type:'success'});
	}	        
}