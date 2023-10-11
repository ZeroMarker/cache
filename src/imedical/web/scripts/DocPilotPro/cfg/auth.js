/**
 * para.js
 * 
 * Copyright (c) 2020-2090 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2020-09-02
 * 
 * 
 */
var PageLogicObj = {
	m_TypeGrid:"",
	m_Grid:"",
	v_CHosp:"",
	v_InType:""		// PageLogicObj.v_InType
}

$(function() {
	Init();
	InitEvent();
	PageHandle();
})


function Init(){
	InitHospList();
	//InitCombox();
	InitTypeGrid();
	InitGrid();
}

function InitEvent () {
	$("#Find").click(Find_Handle)
	$("#Reset").click(Reset_Handle)
	$(document.body).bind("keydown",BodykeydownHandler)
}
function PageHandle() {
	
}
function Find_Handle () {
	PageLogicObj.m_Grid.reload({
		ClassName : "DHCDoc.GCP.CFG.Auth",
		QueryName : "QryAuth",
		InHosp:GetHospValue(),
		InType:PageLogicObj.v_InType
	})
}

function FindType_Handle () {
	PageLogicObj.m_TypeGrid.reload({
		ClassName : "DHCDoc.GCP.CFG.Auth",
		QueryName : "QryType",
		InHosp:GetHospValue()
	})
}

function Reset_Handle() {
	//PageLogicObj.m_Project.clear();
	$("#PPDesc").val("");
	Find_Handle();
}

function InitCombox() {
	PageLogicObj.m_Type = $HUI.combobox("#Type", {
		url:$URL+"?ClassName=DHCDoc.GCP.CFG.Auth&QueryName=QryType&ResultSetType=array",
		valueField:'id',
		textField:'text',
		//required:true,
		blurValidValue:true
	});
}
function InitTypeGrid(){
	var toobar=[{
        text: '修改',
        iconCls: 'icon-write-order',
        handler: function() {UpdateClickHandle();}
    }
    ];
    
	var columns = [[
		{field:'text',title:'审核类型',width:200},
		{field:'active',title:'是否激活',width:80,
			formatter:function(value,row,index){
					if (value == "1") {
						return "<span class='c-ok'>是</span>"
					} else {
						return "<span class='c-no'>否</span>"
					}
				}
		},
		{field:'ac',title:'操作',width:40,
			formatter: function(value,row,index){
				var mRtn = '<a class="editcls c-blue" onclick="Set_Handler(\'' + row["id"] + '\',\''+row["text"]+'\')">设</a>';
				//mRtn = mRtn+'<a class="editcls c-red" onclick="Process_Handler(\'' + row["rowid"] + '\',\''+row["AEStatusCode"]+'\')">审</a>';
				return mRtn;
				
				
			}
		},
		{field:'id',title:'id',width:100,hidden:true}
	]]
	
	var DataGrid = $HUI.datagrid("#i-type", {
		fit : true,
		striped : true,
		border:false,
		singleSelect : true,
		//fitColumns : true,
		rownumbers:false,
		//autoRowHeight : false,
		//pagination : true,  
		//headerCls:'panel-header-gray',
		//pageSize:14,
		//pageList : [14,20,50],
		idField:'id',
		url:$URL,
		queryParams:{
			ClassName : "DHCDoc.GCP.CFG.Auth",
			QueryName : "QryType",
			InHosp:GetHospValue()
		},
		onSelect: function (rowIndex, rowData) {
			PageLogicObj.v_InType = rowData.id
			Find_Handle();
			//InitGrid();
		},
		onLoadSuccess : function (data) {
		},
		columns :columns
		//,toolbar:toobar
	});
	
	PageLogicObj.m_TypeGrid = DataGrid;
}

function InitGrid(){
	
	var columns = [[
		{field:'AValue',title:'描述',width:250,
			/*formatter:function(value,row){
				return row.AValue;
			},
			editor:{
				type:'combobox',
				options:{
					valueField:'AValueDR',
					textField:'desc',
					//method:'get',
					mode:'remote',
					url:$URL+"?ClassName=DHCDoc.GCP.CFG.Auth&QueryName=FindGroup&InHosp="+GetHospValue()+"&InType="+PageLogicObj.v_InType+"&ResultSetType=array",
					required:true
					//,blurValidValue:true
				},
				onBeforeLoad:function(param){
					param.InValue = param["q"];
				}
			}
			*/
		},
		{field:'AActive',title:'是否激活',width:100,hidden:true,
			formatter:function(value,row,index){
					if (value == "1") {
						return "<span class='c-ok'>是</span>"
					} else {
						return "<span class='c-no'>否</span>"
					}
				}
				//,editor:{type:'icheckbox',options:{on:'Y',off:'N'}}
		},
		//{field:'AAddDate',title:'添加日期',width:100},
		//{field:'AAddTime',title:'添加时间',width:100},
		{field:'id',title:'id',width:40,hidden:false}
	]]
	var toobar=[{
        text: '新增',
        iconCls: 'icon-add',
        handler: function() {AddClickHandle(); }
    }
    /*,{
        text: '修改',
        iconCls: 'icon-write-order',
        handler: function() {UpdateClickHandle();}
    }*/,{
        text: '删除',
        iconCls: 'icon-cancel',
        handler: function() {DeleteClickHandle();}
    }
    ];
	var DataGrid = $HUI.datagrid("#i-list", {
		fit : true,
		striped : true,
		border:false,
		singleSelect : true,
		fitColumns : true,
		rownumbers:false,
		//autoRowHeight : false,
		pagination : true,  
		//headerCls:'panel-header-gray',
		//pageSize:14,
		//pageList : [14,20,50],
		url:$URL,
		queryParams:{
			ClassName : "DHCDoc.GCP.CFG.Auth",
			QueryName : "QryAuth",
			InHosp:GetHospValue(),
			InType:PageLogicObj.v_InType
		},
		onSelect: function (rowIndex, rowData) {
			
		},
		onLoadSuccess : function (data) {
		},
		columns :columns,
		toolbar:toobar
	});
	
	PageLogicObj.m_Grid = DataGrid;
}

function Set_Handler(id,text) {
	$.messager.confirm("提示", "是否设置为默认审核类型？",function (r) {
			if (r) {
				$m({
					ClassName:"DHCDoc.GCP.CFG.Auth",
					MethodName:"SetCFGValue",
					InHosp:GetHospValue(),
					InCode:"SAEAuth",
					InValue:id
				}, function(result){
					if (result == 0) {
						$.messager.alert("提示", "保存成功！", "info");
						FindType_Handle();
						return true;
					} else {
						$.messager.alert("提示", "保存失败：" + result , "info");
						return false;
					}
				});
			}
		});	
}

function AddClickHandle() {
	if (PageLogicObj.v_InType=="") {
		$.messager.alert("提示","请先选择审核类型！","warning")
		return false;
	}
	
	var URL = "gcp.cfg.auth.edit.csp?InHosp="+GetHospValue()+"&InType="+PageLogicObj.v_InType
	websys_showModal({
		url:URL,
		//maximizable:true,
		iconCls: 'icon-w-add',
		title:'添加',
		width:370,height:400,
		CallBackFunc:Find_Handle
	})
	
	return 
	var BaseParamObj = {
		ID:"",
		AActive:1,
		AHospID:2,
		AType:"Group",
		AValue:"29"
	}
	var BaseParamJson=JSON.stringify(BaseParamObj);
	
	$m({
		ClassName:"DHCDoc.GCP.CFG.Auth",
		MethodName:"Save",
		BaseParamJson:BaseParamJson
	}, function(result){
		result = result.split("^")
		if (result[0]> 0) {
			$.messager.alert("提示", "保存成功！", "info", function () {
				websys_showModal("hide");
				//websys_showModal('options').CallBackFunc();
				websys_showModal("close");	
			});
		} else {
			$.messager.alert("提示", result , "warning");
			return false;
		}
	});
	
	return false;
	
	
}

function UpdateClickHandle() {
	var selected = PLObject.m_Grid.getSelected();
	if (!selected) {
		$.messager.alert("提示","请选择一行！","warning")
		return false;
	}
	var ID=selected.id;
	var URL = "docpilotpro.stagedic.edit.csp?ID="+ID;
	websys_showModal({
		url:URL,
		//maximizable:true,
		iconCls: 'icon-w-add',
		title:'添加',
		width:370,height:400,
		CallBackFunc:FindClickHandle
	})
}

function FindClickHandle () {
	var PPRowId = PageLogicObj.m_Project.getValue()||"";
		PPDesc = $("#PPDesc").val();
		
	PLObject.m_Grid.reload({
		ClassName : "web.PilotProject.Extend.Stage",
		QueryName : "QryStageDic",
		PPRowId:PPRowId,
		PPDesc:PPDesc
	})
}

function DeleteClickHandle () {
	var selected = PageLogicObj.m_Grid.getSelected();
	if (!selected) {
		$.messager.alert("提示", "请选择一行！", "info");
		return false;
	}
	
	$.messager.confirm("提示", "确认删除？",function (r) {
		if (r) {
			$m({
				ClassName:"DHCDoc.GCP.CFG.Auth",
				MethodName:"DeleteAuth",
				ID:selected.id
			}, function(result){
				if (result == 0) {
					$.messager.alert("提示", "删除成功！", "info");
					Find_Handle();
					return true;
				} else {
					$.messager.alert("提示", "删除失败：" + result , "info");
					return false;
				}
			});
		}
		
	});
}

function Up_ClickHandle () {
	var selectedOld = PLObject.m_Grid.getSelected();
	if (!selectedOld) {
		$.messager.alert('提示','请选择一条记录!', "info");
		return false;
	}
	//Index from zero
	var rowIndexOld = PLObject.m_Grid.getRowIndex(selectedOld);
	if (rowIndexOld == 0) {
		$.messager.alert('提示','已是第一条记录，无法上调!', "info");
		return false;
	}
	//console.log(selectedOld)
	var oldSeqno = selectedOld.order;
	var oldID=selectedOld.id;
	var preIndex = rowIndexOld - 1;
	var selectedPre = PLObject.m_Grid.getData().rows[preIndex];
	var preSeqno = selectedPre.order;
	var preID=selectedPre.id
	
	$m({
		ClassName:"web.PilotProject.Extend.Stage",
		MethodName:"UpOrder",
		oldID:oldID,
		oldSeqno:oldSeqno,
		preID:preID,
		preSeqno:preSeqno
	}, function(result){
		if (result == 0) {
			FindClickHandle();
			return true;
		} else {
			$.messager.alert("提示", "上调失败：" + result , "info");
			return false;
		}
	});	
}

function Down_ClickHandle () {
	var selectedOld = PLObject.m_Grid.getSelected();
	if (!selectedOld) {
		$.messager.alert('提示','请选择一条记录!', "info");
		return false;
	}
	//Index from zero
	var AllData = PLObject.m_Grid.getData();
	var totalRows = AllData.total;
	var rowIndexOld = PLObject.m_Grid.getRowIndex(selectedOld);
	if (rowIndexOld == (totalRows-1)) {
		$.messager.alert('提示','已是最后一条记录，无法下调!', "info");
		return false;
	}
	var nextIndex = rowIndexOld + 1;
	var selectedNext = AllData.rows[nextIndex];
	var oldSeqno = selectedOld.order;
	var oldID=selectedOld.id;
	var preSeqno = selectedNext.order;
	var preID=selectedNext.id
	
	$m({
		ClassName:"web.PilotProject.Extend.Stage",
		MethodName:"UpOrder",
		oldID:oldID,
		oldSeqno:oldSeqno,
		preID:preID,
		preSeqno:preSeqno
	}, function(result){
		if (result == 0) {
			FindClickHandle();
			return true;
		} else {
			$.messager.alert("提示", "下调失败：" + result , "info");
			return false;
		}
	});	
}

function BodykeydownHandler(e){
	if (window.event){
		var keyCode=window.event.keyCode;
		var type=window.event.type;
		var SrcObj=window.event.srcElement;
	}else{
		var keyCode=e.which;
		var type=e.type;
		var SrcObj=e.target;
	}
	//alert(keyCode)
	if (keyCode==13) {
		if(SrcObj && SrcObj.id.indexOf("PPDesc")>=0){
			Find_Handle();
			return false;
		}
		return true;
	}
	//浏览器中Backspace不可用  
   var keyEvent;   
   if(e.keyCode==8){   
       var d=e.srcElement||e.target;
        if(d.tagName.toUpperCase()=='INPUT'||d.tagName.toUpperCase()=='TEXTAREA'){   
            keyEvent=d.readOnly||d.disabled;   
        }else{   
            keyEvent=true;   
        }   
    }else{   
        keyEvent=false;   
    }   
    if(keyEvent){   
        e.preventDefault();   
    }   
}


function InitHospList()
{
	var hospComp = GenHospComp("Doc_BaseConfig_CNMedCode");
	hospComp.jdata.options.onSelect = function(rowIndex,data){
		PageLogicObj.v_CHosp = data.HOSPRowId;
		FindType_Handle();
		Find_Handle();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		//Init();
	}
}

function GetHospValue() {
	if (PageLogicObj.v_CHosp == "") {
		return session['LOGON.HOSPID'];
	}
	
	return PageLogicObj.v_CHosp
}

