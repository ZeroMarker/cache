var _GV={
	ClassName:"Nur.NIS.Service.Base.PatStatusConfig",
	WardJson:"", //所有病区json
	ApplyPersonTypeJson:"", //适用人群
	selRowId:"", //评估对问题选中行rowid
	ItemCode:"", //记录项目代码选择后的编码@名称
	PSCTypeJson:"",
	TemplateCode:""
}
$(window).load(function() {
	$("#Loading").hide();
});
$(function(){ 
	InitHospList();
	InitEvent();
});
function InitEvent(){
 	$("#BFind").click(function(){
	 	$("#tabPatStatusList").datagrid("load");
	});
 	$("#searchName").keydown(searchNameOnKeyDown);
	$("#BSave").click(SaveClick);
 	$("#BCancel").click(function(){
	 	$("#PatStatusEditWin").window('close');
	});
}
function InitHospList(){
	var hospComp = GenHospComp("Nur_IP_PatStatusConfig");
	hospComp.jdata.options.onSelect = function(e,t){
		$("#searchName").val("");
		$.extend(_GV, {ItemCode:"",selRowId:""});
		InitWardJson();
		$("#tabPatStatusList").datagrid("load");
		InitPatStatusEditWin();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		Init();
	}
}
function Init(){
	// 类型
	InitPSCTypeJson();
	InitStatus();
	InitSearchType();
	//初始化列表
	InitPatStatusListDataGrid();
	//病区 
	InitWardJson();
	//适用人群
	InitApplyPersonTypeJson();
	InitEditWindow();
	InitPatStatusEditWin();
	InitTip();
}
function InitSearchType(){
	$('#searchType').combobox({
		valueField:'value',
		textField:'text',
		mode: "local",
		editable:false,
		multiple:true,
		rowStyle:'checkbox',
		data:_GV.PSCTypeJson,
		onChange:function(newValue, oldValue){
			$("#tabPatStatusList").datagrid("load");
		}
	});
}
function InitPatStatusListDataGrid(){
	var ToolBar = [{
            text: '新增',
            iconCls: 'icon-add',
            handler: function() {
				_GV.selRowId="";        
	            $("#PatStatusEditWin").window({
		            title:"新增患者状态配置",
		            iconCls:"icon-w-add"
		        });
				$("#PatStatusEditWin").window('open');
	            $("#PSCCode").focus();
            }
        },{
            text: '修改',
            iconCls: 'icon-write-order',
            handler: function() {
	            var selected = $("#tabPatStatusList").datagrid("getSelected");
				if (!selected) {
					$.messager.alert("提示","请选择需要修改的记录！");
					return false;
				}
				SetPatStatusRowData(selected);
				$("#PatStatusEditWin").window({
		            title:"修改患者状态配置",
		            iconCls:"icon-w-edit"
		        });
				$("#PatStatusEditWin").window('open');
				$("#PSCCode").focus();
            }
        },{
            text: '删除',
            iconCls: 'icon-cancel',
            handler: function() {
                var selected = $("#tabPatStatusList").datagrid("getSelected");
				if (!selected) {
					$.messager.alert("提示","请选择要删除的记录！");
					return false;
				}
				$.messager.confirm('确认对话框', "确定要删除该记录吗？", function(r){
					if (r) {
						var rowId=selected.rowId;
						if (rowId) {
							var rtn=$.m({
								ClassName:_GV.ClassName,
								MethodName:"DeletePatStatus",
								rowId:rowId
							},false)
							if (rtn !=0) {
								$.messager.popover({msg:'删除失败！',type:'error'});
								return false;
							}else{
								$.messager.popover({msg:'删除成功！',type:'success'});
							}
							$('#tabPatStatusList').datagrid('reload');
						}
					}
				});
            }
        },{
	        text: '翻译',
	        iconCls: 'icon-translate-word',
	        handler: function() {
	            Translate("tabPatStatusList","CF.NUR.NIS.PatStatusConfig","PSCName","PSCName")	
	        }
	    }];
	
	var Columns=[[  
		{ field: 'PSCCode',title:'数据编码',width:100},
		{ field: 'PSCType',title:'类型',width:90,
			formatter: function(module,row,index){
				var index=$.hisui.indexOfArray(_GV.PSCTypeJson,"value",module);
				if (index >=0) {
					return _GV.PSCTypeJson[index].text;
				}
			}
		},
		{ field: 'PSCName',title:'名称',width:100},
		{ field: 'PSCEMRTemplate',title:'模板名称',width:200},
		{ field: 'PSCItem', title: '项目代码',width:200},
		{ field: 'PSCValidExpression', title: '生效公式',width:150},
		{ field: 'PSCValidDays', title: '有效天数',width:150},
		{ field: 'PSCApplyPersonType', title: '适用人群',width:150,
			formatter: function(applyPersonTypes,row,index){
				var value="";
				if ((applyPersonTypes)&&(applyPersonTypes.split("@").length >0)) {
					for (var i=0;i<applyPersonTypes.split("@").length;i++){
						var index=$.hisui.indexOfArray(_GV.ApplyPersonTypeJson.rows,"id",applyPersonTypes.split("@")[i]);
						if (index >=0) {
							if (value) value=value+","+_GV.ApplyPersonTypeJson.rows[index].type;
							else  value=_GV.ApplyPersonTypeJson.rows[index].type;
						}
					}	
				}
				if (value) {
					return value;
				}else{
					return _GV.ApplyPersonTypeJson.rows[0].type;
				}
			}
		},
		{ field: 'PSCValidLocs', title: '适用范围',width:150,
			formatter: function(validLocs,row,index){
				var value="";
				if ((validLocs)&&(validLocs.split("@").length >0)) {
					for (var i=0;i<validLocs.split("@").length;i++){
						var index=$.hisui.indexOfArray(_GV.WardJson.rows,"wardid",validLocs.split("@")[i]);
						if (index >=0) {
							if (value) value=value+","+_GV.WardJson.rows[index].warddesc;
							else  value=_GV.WardJson.rows[index].warddesc;
						}
					}
					return value;
				}
				if (value) {
					return value;
				}else{
					return "全院";
				}
			}
		},
		{ field: 'PSCInvalidLocs', title: '不适用范围',width:150,
			formatter: function(invalidLocs,row,index){
				var value="";
				if ((invalidLocs)&&(invalidLocs.split("@").length >0)) {
					for (var i=0;i<invalidLocs.split("@").length;i++){
						var index=$.hisui.indexOfArray(_GV.WardJson.rows,"wardid",invalidLocs.split("@")[i]);
						if (index >=0) {
							if (value) value=value+","+_GV.WardJson.rows[index].warddesc;
							else  value=_GV.WardJson.rows[index].warddesc;
						}
					}
				}
				return value;
			}
		},
		{ field: 'PSCActive', title: '状态',width:70,
			styler: function(value,row,index){
				if (value =="1"){
					return "color:#3FBD79;"
				}else{
					return "color:#F16E57;"
				}
			},
			formatter: function(value,row,index){
				if (value =="1"){
					return "启用"
				}else{
					return "停用"
				}
			}
		}
    ]];
	$('#tabPatStatusList').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		loadMsg : '加载中..',  
		pagination : true, 
		rownumbers : true,
		idField:"rowId",
		pageSize: 15,
		pageList : [15,50,100,200],
		columns :Columns,
		toolbar :ToolBar,
		autoRowHeight:true,
		nowrap:false,  /*此处为false*/
		url : $URL+"?ClassName="+_GV.ClassName+"&QueryName=getPatStatusConfigList",
		onBeforeLoad:function(param){
			_GV.m_selRowId="";
			$('#tabPatStatusList').datagrid("unselectAll");
			var status=$("#active").combobox('getValues').join(",");
			if (status.split(",").length !=1){
				status="";
			}
			var searchType=$("#searchType").combobox('getValues').join(",");
			param = $.extend(param,{
				nameDesc:$("#searchName").val(),
				status:status,
				searchType:searchType,
				hospId:$HUI.combogrid('#_HospList').getValue()
			});
		},
		onLoadSuccess:function(data){ // 给停用问题单元格设置背景色
			var trs = $(this).prev().find('div.datagrid-body').find('tr');
			//行
			for(var i=0;i<trs.length;i++){
			  //行内单元格
			  for(var j=1;j<trs[i].cells.length;j++){
				  var row_html = trs[i].cells[j];
				  var cell_field=$(row_html).attr('field');
				  var cell_value=$(row_html).find('div').html();
				  if(cell_field == 'haveStopQue' && cell_value == "1"){
					  // 设置问题列 背景色
					  trs[i].cells[4].title = "问题数据异常（停用或删除）"
				  }
			  }
			}
		}
	})
}
function SetPatStatusRowData(row){
	$("#PSCCode").val(row.PSCCode);
	$("#PSCType").combobox("select",row.PSCType);
	$("#PSCEMRTemplate").removeAttr("disabled");
	if (row.PSCType!=1 && row.PSCType!=3){
		$("#PSCEMRTemplate").attr("disabled","disabled");
	}
	$("#PSCName").val(row.PSCName);
	$("#PSCEMRTemplate").val(row.PSCEMRTemplate);
	$("#PSCItem").val(row.PSCItem);
	$("#PSCValidExpression").val(row.PSCValidExpression);
	$("#PSCValidDays").numberbox("setValue",row.PSCValidDays);
	var applyPersonType=row.PSCApplyPersonType.split("@");
	if (applyPersonType.length==0) {
		applyPersonType=[""];
	}
	$("#PSCApplyPersonType").combobox("setValues",applyPersonType);
	var validLocs=row.PSCValidLocs.split("@");
	if (validLocs.length==0) {
		validLocs=""
	}
	$("#PSCValidLocs").combobox("setValues",validLocs);
	var invalidLocs=row.PSCInvalidLocs.split("@");
	if (invalidLocs.length==0) {
		invalidLocs=""
	}
	$("#PSCInvalidLocs").combobox("setValues",invalidLocs);
	$("#PSCActive").switchbox("setValue",row.PSCActive==1?true:false);
	_GV.selRowId=row.rowId;
	_GV.TemplateCode=row.TemplateCode;
	_GV.ItemCode=row.PSCItem;
}
function InitStatus(){
	$("#active").combobox({
		valueField:'id',
		textField:'text',
		mode: "local",
		multiple:true,
		rowStyle:'checkbox', //显示成勾选行形式
		data:[{"id":"1","text":"启用"},{"id":"0","text":"停用"}],
		onSelect:function(rec){
			if (rec) {
				$("#tabPatStatusList").datagrid("load");
			}
		},
		onChange:function(newValue, oldValue){
			if (!newValue) {
				$("#tabPatStatusList").datagrid("load");
		    }
		}
	});
}
function InitPatStatusEditWin(){
	// 类型
	InitPSCType();
	// 适用人群
	InitPSCApplyPersonType();
	// 适用范围 不适用范围
	InitValidLocs();
	// 项目代码
	InitPSCItemLookUp();
}
function InitValidLocs(){
	$("#PSCValidLocs,#PSCInvalidLocs").combobox({
		mode: "local",
		valueField:'wardid',
		textField:'warddesc',
		mode: "local",
		multiple:true,
		data:_GV.WardJson.rows
	});
}
function InitPSCApplyPersonType(){
	$('#PSCApplyPersonType').combobox({
		mode: "local",
		valueField:'id',
		textField:'type',
		mode: "local",
		multiple:true,
		data:_GV.ApplyPersonTypeJson.rows,
		onSelect:function(rec){
			if ((rec)&&(!rec.id)){
				$('#PSCApplyPersonType').combobox("setValues",[""]);
			}else{
				$('#PSCApplyPersonType').combobox("unselect","");
			}
		}
	});
}
function InitPSCItemLookUp(){
	var PSCType=$("#PSCType").combobox("getValue");
	if (PSCType=="3"){
		if (_GV.TemplateCode=="Arcim"){
			var queryParams={ClassName: 'Nur.NIS.Service.Base.Assess',QueryName: 'GetItemCodeList'};
		}else{
			var queryParams={ClassName: 'Nur.NIS.Service.Base.PatStatusConfig',QueryName: 'GetItemCodeList'};
		}
	}else{
		var queryParams={ClassName: 'Nur.NIS.Service.Base.Assess',QueryName: 'GetItemCodeList'};
	}
	$("#PSCItem").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
		idField:'id',
		textField:'name',
		nowrap:false,
        columns:[[
			{field:'name',title:'名称',width:150,sortable:true},
			{field:'code',title:'Code',width:120,sortable:true},
			{field:'text',title:'描述',width:150,sortable:true}
        ]],
		enableNumberEvent:true,
        pagination:true,
        rownumbers:true,
        panelWidth:490,
        panelHeight:300,
        isCombo:true,
        minQueryLen:2,
        delay:'200',
        queryOnSameQueryString:true,
        queryParams:queryParams,
        onBeforeLoad:function(param){
	        if (param['q']) {
				var desc=param['q'];
			}
			param = $.extend(param,{DataSource:$("#PSCType").combobox("getValue"),Alias:desc,HospId:$HUI.combogrid('#_HospList').getValue()});
			param = $.extend(param,{emrCode:_GV.TemplateCode});
	    },onSelect:function(ind,item){
			_GV.m_ItemCode=item.code+"@"+item.name;
			$("#PSCItem").lookup("setText",_GV.m_ItemCode);
		}
    });
    initPSCEMRTemplate();
}
function InitPSCType(){
	$('#PSCType').combobox({
		valueField:'value',
		textField:'text',
		mode: "local",
		editable:false,
		data:_GV.PSCTypeJson,
		onSelect:function(rec){
			if (rec) {
				_GV.TemplateCode="";
				$("#PSCItem").val("");
				_GV.ItemCode="";
				$("#PSCEMRTemplate").lookup("setText",_GV.m_ItemCode);
				$("#PSCEMRTemplate").removeAttr("disabled");
				if (rec.value ==1) {
					$("#PSCEMRTemplate").val("");
					initPSCEMRTemplate();
				}else if(rec.value ==3){
					$("#PSCEMRTemplate").val("");
					initPSCEMRTemplate();
				}else{
					$("#PSCEMRTemplate").val("").attr("disabled","disabled");
				}
				$("#PSCName").focus();
			}
		}
	});
}
function initPSCEMRTemplate(){
	var PSCType=$('#PSCType').combobox("getValue");
	if (PSCType==1) {
		var queryParams={ClassName: 'Nur.NIS.Service.Base.Assess',QueryName: 'GetTemplateCodeList'};
	}else if(PSCType==3){
		var queryParams={ClassName: 'Nur.NIS.Service.Base.PatStatusConfig',QueryName: 'GetTemplateCodeList'};
	}
	$("#PSCEMRTemplate").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
		idField:'id',
		textField:'name',
        columns:[[
			{field:'name',title:'名称',width:230,sortable:true},
			{field:'code',title:'Code',width:200,sortable:true}
        ]],
		enableNumberEvent:true,
        pagination:true,
        rownumbers:true,
        isCombo:true,
        panelWidth:560,
        panelHeight:300,
        minQueryLen:2,
        delay:'200',
        queryOnSameQueryString:true,
        queryParams:queryParams,
        onBeforeLoad:function(param){
	        if (param['q']) {
				var desc=param['q'];
			}
			param = $.extend(param,{DataSource:$("#PSCType").combobox("getValue"),Alias:desc,HospId:$HUI.combogrid('#_HospList').getValue()});
	    },onSelect:function(ind,item){
		    _GV.ItemCode="";
		    $("#PSCItem").val("");
		    _GV.TemplateCode=item.code;
			$("#PSCEMRTemplate").lookup("setText",item.name+"("+item.code+")");
			InitPSCItemLookUp();
		}
    });
}
function InitPSCTypeJson(){
	var data=$.cm({
		ClassName:"Nur.NIS.Common.QueryBrokerNew",
		MethodName:"GetOptionOfProperty",
		className:"CF.NUR.NIS.PatStatusConfig",
		propertyName:"PSCType"
	},false)
	var newData=new Array();
	for (var i=0;i<data.length;i++){
		var value=data[i].value;
		var text=data[i].text;
		newData.push({
			"value":value.toString(),
			"text":text
		});
	}
	_GV.PSCTypeJson=newData;
}
function InitEditWindow(){
    $("#PatStatusEditWin" ).window({
	   modal: true,
	   collapsible:false,
	   collapsible:false,
	   minimizable:false,
	   maximizable:false,
	   closed:true,
	   onClose:function(){
		   ClearPatStatusEditWinData();
	   }
	});
}
function ClearPatStatusEditWinData(){
	$("#PSCCode,#PSCName,#PSCEMRTemplate,#PSCItem,#PSCValidExpression,#PSCValidDays").val("");
	$("#PSCType").combobox("setValue","");
	$("#PSCApplyPersonType,#PSCValidLocs,#PSCInvalidLocs").combobox("setValues","");
	$("#PSCActive").switchbox("setValue",true);
	$.extend(_GV, {ItemCode:"",selRowId:""});
}
function InitTip(){
	var _content="<p>类型是护理病历，输入病历元素item值、病历元素名称，以@间隔，如：item11@总分；</p>"
	_content += "<p>类型为生命体征，选择体征项自动带入；</p>"
	_content += "<p>类型为医嘱，选择医嘱项自动带入；</p>"
	_content += "<p>类型为诊断，选择诊断自动带入；</p>"
	$("#PSCItem_tip").popover({
		trigger:'hover',
		content:_content,
		style:'inverse'
	});
	$("#PSCValidDays_tip").popover({
		trigger:'hover',
		content:"<p>配置0/空：判断范围从患者入院至今；</p><p>配置N(N>=1)：判断范围为N天内；</p>",
		style:'inverse'
	});
}
function InitWardJson(){
	_GV.WardJson=$.cm({
		ClassName:"Nur.NIS.Service.Base.Ward",
		QueryName:"GetallWardNew",
		desc:"",
		hospid:$HUI.combogrid('#_HospList').getValue(),
		bizTable:"Nur_IP_QLAssess",
		rows:99999
	},false)
}
function InitApplyPersonTypeJson(){
	_GV.ApplyPersonTypeJson=$.cm({
		ClassName:"Nur.NIS.Service.Base.Assess",
		QueryName:"GetApplyPersonType"
	},false)
}
function searchNameOnKeyDown(){
	var key=websys_getKey(e);
	if (key==13){
		$("#tabPatStatusList").datagrid("load");
	}
}
function SaveClick(){
	var code=$.trim($("#PSCCode").val());
	if (!code) {
		$.messager.popover({msg:'请输入数据编码!',type:'error'});
		$("#PSCCode").focus();
		return false;
	}
	var type=$("#PSCType").combobox("getValue");
	if (!type) {
		$.messager.popover({msg:'请选择类型！',type:'error'});
		$("#PSCType").next('span').find('input').focus();
		return false;
	}
	var name=$.trim($("#PSCName").val());
	if (!name) {
		$.messager.popover({msg:'请输入名称!',type:'error'});
		$("#PSCName").focus();
		return false;
	}
	var Template=$.trim($("#PSCEMRTemplate").val())
	if (((type ==1)||(type ==3))&&(!Template)) {
		$.messager.popover({msg:'请选择来源！',type:'error'});
		$("#TemplCode").focus();
		return false;
	}
	TemplCode=_GV.ItemCode;
	var ItemCode=$.trim($("#PSCItem").val());
	if (!ItemCode) {
		$.messager.popover({msg:'请输入项目代码',type:'error'});
		$("#PSCItem").focus();
		return false;
	}
	var validExpression=$.trim($("#PSCValidExpression").val());
	var validDays=$.trim($("#PSCValidDays").numberbox("getValue"));
	var applyPersonType=$("#PSCApplyPersonType").combobox("getValues");
	if (!applyPersonType) {
		$.messager.popover({msg:'请选择使用人群！',type:'error'});
		$("#PSCApplyPersonType").next('span').find('input').focus();
		return false;
	}
	var validLocs=$("#PSCValidLocs").combobox("getValues");
	var invalidLocs=$("#PSCInvalidLocs").combobox("getValues");
	if ((validLocs.length>0)&&(invalidLocs.length>0)){
		var  newArr = [];
		for (var i = 0; i < invalidLocs.length; i++) {
		      for (var j = 0; j < validLocs.length; j++) {
		      	if(validLocs[j] === invalidLocs[i]){		            
					var index=$.hisui.indexOfArray(_GV.WardJson.rows,"wardid",validLocs[j]);
					if (index >=0) {
						newArr.push(_GV.WardJson.rows[index].warddesc);
					}
		        }
		    }
		}
		if (newArr.length>0){
			$.messager.popover({msg:newArr.join("、")+" 同时存在于适用范围和不适用范围中,请核实！",type:'error'});
			return false;
		}
	}
	var active=$("#PSCActive").switchbox("getValue")?1:0;
	var itemJson=new Array();
	var saveDataObj={
		"rowId":_GV.selRowId,
		"PSCCode":code,
		"PSCType":type,
		"PSCName":name,
		"PSCEMRTemplate":_GV.TemplateCode,
		"PSCItem":ItemCode,
		"PSCApplyPersonType":applyPersonType.join("@"),
		"PSCValidLocs":validLocs.join("@"),
		"PSCInvalidLocs":invalidLocs.join("@"),
		"PSCValidExpression":validExpression,
		"PSCValidDays":validDays,
		"PSCActive":active,
		"PSCHospDR":$HUI.combogrid('#_HospList').getValue()
	}
	itemJson.push(saveDataObj);
	$.m({
		ClassName:_GV.ClassName,
		MethodName:"SavePatStatus",
		itemJson:JSON.stringify(itemJson)
	},function (rtn){
		if(rtn == 0) {
			$.messager.popover({msg:'保存成功！',type:'success'});
			$("#PatStatusEditWin").window('close');
			$("#tabPatStatusList").datagrid("reload");
		} else {
			$.messager.alert('提示','保存失败！'+ rtn , "info");
			return false;
		}
	})
}
// 翻译
function Translate(tableId,className,fieldName,key){
	var selectedRow=$("#"+tableId).datagrid("getSelections");
	if(selectedRow.length>0){
		CreatTranLate(className,fieldName,selectedRow[0][key]);
	}else{
		$.messager.popover({msg:'请选择要翻译的数据！',type:'alert'});
	}		
}