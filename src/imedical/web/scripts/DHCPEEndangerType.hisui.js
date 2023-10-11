//
//名称	DHCPEEndangerType.hisui.js
//功能	危害因素维护
//创建	2019.06.13
//创建人  xy

var WIDTH = $(document).width();
$("#Endanger").css("width", WIDTH*0.5);

$(function(){

	InitCombobox();
	
	InitEndangerTypeGrid();
	
	InitEndangerGrid();
     
    // 修改(危害因素分类维护)
	$("#update_btn").click(function() {	
		BUpdate_click();		
    });
        
    // 新增(危害因素分类维护)
	$("#add_btn").click(function() {	
		BAdd_click();		
    });  
    
    
    // 清屏(危害因素分类维护)
	$("#BClear").click(function() {	
		BClear_click();		
    });
    
    // 修改(危害因素维护)
	$("#ENupdate_btn").click(function() {	
		BENUpdate_click();		
    });
        
    // 新增(危害因素维护)
	$("#ENadd_btn").click(function() {	
		BENAdd_click();		
    });  
    
    
    // 清屏(危害因素维护)
	$("#BENClear").click(function() {	
		BENClear_click();		
    });
   
    // 目标疾病(危害因素维护)
	$("#ENIllness_btn").click(function() {	
		ENIllness_click();		
    });
    
    // 检查周期(危害因素维护)
	$("#ENCheckCycle_btn").click(function() {	
		ENCheckCycle_click();		
    });
    
    // 诊断标准(危害因素维护)
    $("#ENCriteria_btn").click(function() {	
		ENCriteria_click();
    });
        
    // 检查项目(危害因素维护)
	$("#ENItem_btn").click(function() {	
		ENItem_click();		
    });
});

/*******************************************危害因素分类维护界面***************************/
//新增
function BAdd_click() {
	BSave_click("0");
}

//修改
function BUpdate_click() {
	BSave_click("1");
}

function BSave_click(Type) {
	if(Type=="1"){
		var ID=$("#ID").val();
		if(ID==""){
			$.messager.alert("提示","请选择待修改的记录","info");
			return false;
		}
	}
	
	if(Type=="0"){
	    if($("#ID").val()!=""){
		    	$.messager.alert("提示","新增数据不能选中记录,请点击清屏后进行新增","info");
		    	return false;
		    }
	}
	
	var Code=$("#Code").val();
	if (""==Code) {
		$("#Code").focus();
		var valbox = $HUI.validatebox("#Code", {
			required: true,
	    });
		$.messager.alert("提示","代码不能为空","info");
		return false;
	}
	var Desc=$("#Desc").val();
	if (""==Desc) {
		$("#Desc").focus();
		var valbox = $HUI.validatebox("#Desc", {
			required: true,
	    });
		$.messager.alert("提示","描述不能为空","info");
		return false;
	}
	
	var VIPLevel=$("#VIPLevel").combobox('getValue');
	if (($("#VIPLevel").combobox('getValue')==undefined)||($("#VIPLevel").combobox('getValue')=="")){var VIPLevel="";}
	if (""==VIPLevel) {
		var valbox = $HUI.combobox("#VIPLevel", {
			required: true,
	    });
		$.messager.alert("提示","VIP等级不能为空","info");
		return false;
	}
	
	var ExpInfo=$("#ExpInfo").val();
	var Remark=$("#Remark").val();
	var ID=$("#ID").val();
	
	var iActive="N";
	var Active=$("#Active").checkbox('getValue');
	if(Active) iActive="Y";
	var Str=Code+"^"+Desc+"^"+iActive+"^"+VIPLevel+"^"+ExpInfo+"^"+Remark;
	//alert(Str)
	var rtn=tkMakeServerCall("web.DHCPE.Endanger","UpdateEndangerType",ID,Str);
	var Arr=rtn.split("^");
	if (rtn.split("^")[0]=="-1"){
		if(rtn.split("^")[1].indexOf("Code")>0){
			$.messager.alert("提示","代码不唯一","error");
		}
		if(rtn.split("^")[1].indexOf("Desc")>0){
			$.messager.alert("提示","描述不唯一","error");
		}	
		
	}else{
		BClear_click();
		if(Type=="1"){$.messager.alert("提示","修改成功","success");}
		if(Type=="0"){$.messager.alert("提示","新增成功","success");}
		
	}
}

//清屏
function BClear_click() {
	$("#ID,#Code,#Desc,#ExpInfo,#Remark").val("");
	$("#Active").checkbox('setValue',true);
	$(".hisui-combobox").combobox('setValue',"");
	var valbox = $HUI.validatebox("#Code,#Desc", {
			required: false,
	    });
	var valbox = $HUI.combobox("#VIPLevel", {
			required: false,
	    });
	$("#EndangerTypeGrid").datagrid('load',{
			ClassName:"web.DHCPE.Endanger",
			QueryName:"SearchEndangerType",
	});
	LoadEndangerList("");
}

function InitCombobox() {	

	   var LocID=session['LOGON.CTLOCID']
	
	// VIP等级	
	var VIPObj = $HUI.combobox("#VIPLevel",{
		url:$URL+"?ClassName=web.DHCPE.CT.HISUICommon&QueryName=FindVIP&ResultSetType=array&LocID="+LocID+"&Desc="+escape("职业病"),
		valueField:'id',
		textField:'desc',
		editable:false,
		onLoadSuccess:function(){
			
			//设置默认值
			var Data=$('#VIPLevel').combobox('getData');
			if(Data){
				$('#VIPLevel').combobox('setValue',Data[0].id)
			}
			
		}

	});

}

function InitEndangerTypeGrid() {
	$HUI.datagrid("#EndangerTypeGrid",{
		url:$URL,
		fit : true,
		border : false,
		striped : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		singleSelect: true,
		selectOnCheck: true,
		queryParams:{
			ClassName:"web.DHCPE.Endanger",
			QueryName:"SearchEndangerType",
		},
		columns:[[
	
		    {field:'TID',title:'ID',hidden: true},
			{field:'TCode',width:100,title:'代码'},
			{field:'TDesc',width:150,title:'描述'},
			{field:'TActive',width:40,title:'激活'},
			{field:'TVIPLevel',width:100,title:'VIP等级'},
			{field:'TExpInfo',width:100,title:'扩展信息'},
			{field:'TRemark',width:100,title:'备注'},
			
			
		]],
		onSelect: function (rowIndex, rowData) {
			   
				$("#ID").val(rowData.TID);
				$("#Desc").val(rowData.TDesc);
				$("#Code").val(rowData.TCode);
				$("#VIPLevel").combobox('setValue',rowData.TVIPLevelDR);
				$("#ExpInfo").val(rowData.TExpInfo);
				$("#Remark").val(rowData.TRemark);
				if(rowData.TActive=="否"){
					$("#Active").checkbox('setValue',false);
				}if(rowData.TActive=="是"){
					$("#Active").checkbox('setValue',true);
				};
				$('#EndangerGrid').datagrid('loadData', {
				total: 0,
				rows: []
			});
			LoadEndangerList(rowData);		
												
		}
	})
}

/**************************************危害因素维护*******************************************************/
//目标疾病
function ENIllness_click() {
	var record = $("#EndangerGrid").datagrid("getSelected"); 

	if (!(record)) {
		$.messager.alert('提示','请选择待维护的记录!',"warning");
		return;
	} else {  
		var RowId=record.TID
		var Desc=record.TDesc
		/*
		$("#myWinIllness").show();  
		var myWinGuideImage = $HUI.window("#myWinIllness",{
			resizable:true,
			collapsible:false,
			minimizable:false,
			iconCls:'icon-w-paper',
			title:"目标疾病维护-"+Desc,
			modal:true,
			content:'<iframe id="timeline" frameborder="0" src="dhcpeedillness.hisui.csp?selectrow='+RowId+'+" width="100%" height="99%" ></iframe>'
		});	
		*/
		lnk="dhcpeedillness.hisui.csp"+"?selectrow="+RowId;	
		websys_lu(lnk,false,'width=870,height=600,hisui=true,title=目标疾病维护-'+Desc);
	}
}

//检查周期
function ENCheckCycle_click() {
	
	var record = $("#EndangerGrid").datagrid("getSelected"); 
	
	if (!(record)) {
		$.messager.alert('提示','请选择待维护的记录!',"warning");
		return;
	} else {  
		var RowId=record.TID
		var Desc=record.TDesc
		/*
		$("#myWinIllness").show();  
		var myWinGuideImage = $HUI.window("#myWinIllness",{
			resizable:true,
			collapsible:false,
			minimizable:false,
			iconCls:'icon-w-paper',
			title:"检查周期维护-"+Desc,
			modal:true,
			content:'<iframe id="timeline" frameborder="0" src="dhcpeedcheckcycle.hisui.csp?selectrow='+RowId+'+" width="100%" height="99%" ></iframe>'
		
		});	
		*/
		lnk="dhcpeedcheckcycle.hisui.csp"+"?selectrow="+RowId;	
		websys_lu(lnk,false,'width=927,height=600,hisui=true,title=检查周期维护-'+Desc);
	}
}

// 诊断标准
function ENCriteria_click() {
	var record = $("#EndangerGrid").datagrid("getSelected"); 
	
	if (!(record)) {
		$.messager.alert('提示','请选择待维护的记录!',"warning");
		return;
	} else {  
		var RowId=record.TID
		var Desc=record.TDesc
		/*
		$("#myWinIllness").show();  
		var myWinGuideImage = $HUI.window("#myWinIllness",{
			resizable:true,
			collapsible:false,
			minimizable:false,
			iconCls:'icon-w-paper',
			title:"检查周期维护-"+Desc,
			modal:true,
			content:'<iframe id="timeline" frameborder="0" src="dhcpeedcheckcycle.hisui.csp?selectrow='+RowId+'+" width="100%" height="99%" ></iframe>'
		
		});	
		*/
		lnk="dhcpeedcheckcriteria.hisui.csp"+"?selectrow="+RowId;	
		websys_lu(lnk,false,'width=927,height=600,hisui=true,title=诊断标准维护-'+Desc);
	}
}

// 检查项目
function ENItem_click(){
	var record = $("#EndangerGrid").datagrid("getSelected"); 
	
	if (!(record)) {
		$.messager.alert('提示','请选择待维护的记录!',"warning");
		return;
	} else {  
		var RowId=record.TID
		var Desc=record.TDesc
		/*
		$("#myWinEDItem").show();  
		var myWinGuideImage = $HUI.window("#myWinEDItem",{
			resizable:true,
			collapsible:false,
			minimizable:false,
			iconCls:'icon-w-paper',
			title:"检查项目维护-"+Desc,
			modal:true,
			content:'<iframe id="timeline" frameborder="0" src="dhcpeeditem.hisui.csp?selectrow='+RowId+'+" width="100%" height="99%" ></iframe>'
		});	
		*/
		lnk="dhcpe.ct.endangeritem.csp"+"?selectrow="+RowId;
		websys_lu(lnk,false,'width=1355,height=600,hisui=true,title=检查项目维护-'+Desc);
	}
}

//新增
function BENAdd_click(){
	BENSave_click("0");
}

//修改
function BENUpdate_click(){
	BENSave_click("1");
}

function BENSave_click(Type) {
	if(Type=="1"){
		var ID=$("#ENID").val();
		if(ID==""){
			$.messager.alert("提示","请选择待修改的记录","info");
			return false;
		}
	}
	
	if(Type=="0"){
	    if($("#ENID").val()!=""){
		    	$.messager.alert("提示","新增数据不能选中记录,请点击清屏后进行新增","info");
		    	return false;
		    }
	}
	
	var ENCode=$("#ENCode").val();
	if (""==ENCode) {
		$("#ENCode").focus();
		var valbox = $HUI.validatebox("#ENCode", {
			required: true,
	    });
		$.messager.alert("提示","代码不能为空","info");
		return false;
	}
	var ENDesc=$("#ENDesc").val();
	if (""==ENDesc) {
		$("#ENDesc").focus();
		var valbox = $HUI.validatebox("#ENDesc", {
			required: true,
	    });
		$.messager.alert("提示","描述不能为空","info");
		return false;
	}
	
	var ENExpInfo=$("#ENExpInfo").val();
	var ENRemark=$("#ENRemark").val();
	var ID=$("#ENID").val();
	
	var iENActive="N";
	var ENActive=$("#ENActive").checkbox('getValue');
	if(ENActive) iENActive="Y";
	
	var EDTypeDR=$("#ID").val();
	var Str=ENCode+"^"+ENDesc+"^"+iENActive+"^"+EDTypeDR+"^"+ENExpInfo+"^"+ENRemark;

	var rtn=tkMakeServerCall("web.DHCPE.Endanger","UpdateEndanger",ID,Str);
	var Arr=rtn.split("^");
	if (rtn.split("^")[0]=="-1"){
		if(rtn.split("^")[1].indexOf("Code")>0){
			$.messager.alert("提示","代码不唯一","error");
		}
		if(rtn.split("^")[1].indexOf("Desc")>0){
			$.messager.alert("提示","描述不唯一","error");
		}	
		
	}else{
		BENClear_click();
		if(Type=="1"){$.messager.alert("提示","修改成功","success");}
		if(Type=="0"){$.messager.alert("提示","新增成功","success");}
		
	}
}

//清屏
function BENClear_click(){
	$("#ENID,#ENCode,#ENDesc,#ENExpInfo,#ENRemark").val("");
	$("#ENActive").checkbox('setValue',true);
	var valbox = $HUI.validatebox("#ENCode,#ENDesc", {
			required: false,
	});
	
	$("#EndangerGrid").datagrid('load',{
			ClassName:"web.DHCPE.Endanger",
			QueryName:"SearchEndanger",
			EDEDTypeDR:$('#ID').val(),
	});
}

function LoadEndangerList(rowData) {
	if(rowData!="") $('#ID').val(rowData.TID);
	$("#ENID,#ENCode,#ENDesc,#ENExpInfo,#ENRemark").val("");
	$('#EndangerGrid').datagrid('load', {
		ClassName:"web.DHCPE.Endanger",
		QueryName:"SearchEndanger",
		EDEDTypeDR:$('#ID').val(),
	});
}

function InitEndangerGrid(){
	$HUI.datagrid("#EndangerGrid",{
		url:$URL,
		fit : true,
		border : false,
		striped : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		singleSelect: true,
		selectOnCheck: true,
		queryParams:{
			ClassName:"web.DHCPE.Endanger",
			QueryName:"SearchEndanger",
			
		},
		columns:[[
	
		    {field:'TID',title:'ID',hidden: true},
			{field:'TCode',width:100,title:'代码'},
			{field:'TDesc',width:200,title:'描述'},
			{field:'TActive',width:40,title:'激活'},
			{field:'TExpInfo',width:150,title:'扩展信息'},
			{field:'TRemark',width:150,title:'备注'},
			
			
		]],
		onSelect: function (rowIndex, rowData) {
			   
			$("#ENID").val(rowData.TID);
			$("#ENDesc").val(rowData.TDesc);
			$("#ENCode").val(rowData.TCode);
			$("#ENExpInfo").val(rowData.TExpInfo);
			$("#ENRemark").val(rowData.TRemark);
			if(rowData.TActive=="否"){
				$("#ENActive").checkbox('setValue',false);
			}if(rowData.TActive=="是"){
				$("#ENActive").checkbox('setValue',true);
			};
		}
	})
}