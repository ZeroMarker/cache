//页面全局变量
var PageLogicObj = {
	m_CompanyTabDataGrid:"",
	m_ModuleLinkTabDataGrid:"",
	m_ModuleTabDataGrid:"",
	m_ProductTabDataGrid:"",
	m_CompanyLinkTabDataGrid:"",
	m_LinkExtTabDataGrid:"",
	m_AccessSortTabDataGrid:"",
	LinkRowid:"",	//传入到扩展设定界面
	ModuleRowid:"",	//传入到选中模块,打开的关联厂家界面
	ProductRowid:""	//传入到选中业务域,打开的接入排序界面
};

$(function(){
	InitHospList();
})

function InitHospList(){
	var hospComp = GenHospComp("Doc_Interface_AccessManage");
	hospComp.jdata.options.onSelect = function(e,t){
		PageLogicObj.m_ModuleLinkTabDataGrid.datagrid("reload");
	}
	hospComp.jdata.options.onLoadSuccess=function(data){
		Init();
		InitCache();
	}
}

function Init(){
	PageLogicObj.m_CompanyTabDataGrid=InitCompanyTabDataGrid();
	PageLogicObj.m_ModuleLinkTabDataGrid=InitModuleLinkTabDataGrid();
	$('#tipInfo').height($('#tipInfo').parent().height()-$('#tipInfo').offset().top-2);
}

function InitCache(){
	var hasCache = $.DHCDoc.ConfigHasCache();
	if (hasCache!=1) {
		$.DHCDoc.CacheConfigPage();
		$.DHCDoc.storageConfigPageCache();
	}
}

function InitCompanyTabDataGrid(){
	var CompanyColumns=[[
		{field:'BaseRowid',title:'厂家id',width:1,hidden:true},
		{field:'BaseCode',title:'厂家代码',width:200},
		{field:'BaseDesc',title:'厂家名称',width:200,editor:{type:'text',options:{}}}
    ]];
	var CompanyToolBar=[{
        text: '增加',
        iconCls: 'icon-add',
        handler: function() {
			PageLogicObj.m_CompanyTabDataGrid.datagrid("insertRow", {
                index: 0,
                row: {}
            });
            PageLogicObj.m_CompanyTabDataGrid.datagrid("beginEdit", 0);
        }
	},{
		text: '删除',
		iconCls: 'icon-cancel',
		handler: function() {
			var rowData=PageLogicObj.m_CompanyTabDataGrid.datagrid("getSelected");
			if (!rowData){
				$.messager.alert("提示", "请选择需要删除的数据");
				return false;
			}
			if (rowData.BaseRowid) {
				$.messager.confirm("提示", "确定要删除厂家:"+rowData.BaseDesc+"吗?", function(r) {
	                if (r) {
	                    var rtn=$.cm({
							ClassName:"DHCDoc.Interface.AccessManage", 
							MethodName:"DeleteAccessBase",
							dataType:'text',
							BaseRowid:rowData.BaseRowid,
							BaseType:"Company"
						},false);
				        if(rtn=="0"){
					        $.messager.show({title:"提示",msg:"删除成功"});
							PageLogicObj.m_CompanyTabDataGrid.datagrid('unselectAll').datagrid('reload');
				        }else{
					       $.messager.alert('提示',"删除失败:"+rtn);
					       return false;
				        }
	                }
				});
			}else{
				var index=PageLogicObj.m_CompanyTabDataGrid.datagrid('getRowIndex',rowData);
				PageLogicObj.m_CompanyTabDataGrid.datagrid('deleteRow',index);
			}
		}
	},{
		text: '保存',
		iconCls: 'icon-save',
		handler: function() {
			var SaveRows=new Array();
			var rows=PageLogicObj.m_CompanyTabDataGrid.datagrid('getRows');
			for(var i=rows.length-1;i>=0;i--){
				var CompanyRowid=rows[i].BaseRowid;
				if (!CompanyRowid) CompanyRowid="";
				var editors=PageLogicObj.m_CompanyTabDataGrid.datagrid('getEditors',i);
				if(!editors.length) continue;
				var CompanyDesc=editors[0].target.val();
				if (!CompanyDesc) {
					$.messager.alert("提示","请填写厂家名称");
	            	return false;
				}
				var SaveRow=new Object();
				SaveRow.CompanyRowid=CompanyRowid
				SaveRow.CompanyDesc=CompanyDesc
				SaveRow.CompanyCode="";
				//
				SaveRows.push(SaveRow);
			}
			if(!SaveRows.length){
				$.messager.popover({msg:"没有需要保存的数据",type:'alert'});
				return false;
			}
			var rtn=$.cm({
				ClassName:'DHCDoc.Interface.AccessManage',
				MethodName:'SaveAccessCompany',
				dataType:'text',
				CompanyJson:JSON.stringify(SaveRows)
			},false);
			if(rtn=='0'){
				$.messager.show({title:"提示",msg:"保存成功"});
				PageLogicObj.m_CompanyTabDataGrid.datagrid('unselectAll').datagrid('reload');
			}else{
				$.messager.alert('提示','保存失败:'+rtn);
       			return false;
       		}
		}
	}/*,{
        text: '取消编辑',
        iconCls: 'icon-redo',
        handler: function() {
            PageLogicObj.m_CompanyTabDataGrid.datagrid("unselectAll").datagrid("rejectChanges");
        }
    }*/,'-',{
        text: '模块维护',
        iconCls: 'icon-edit',
        handler: function() {
            ModuleDialogOpen();
        }
    },{
        text: '业务域维护',
        iconCls: 'icon-edit',
        handler: function() {
            ProductDialogOpen();
        }
    }];
    CompanyTabDataGrid=$('#CompanyTab').datagrid({  
		fit: true,
		width: 'auto',
		border: false,
		striped: true,
		singleSelect: true,
		fitColumns: false,
		autoRowHeight: false,
		url:$URL+"?ClassName=DHCDoc.Interface.AccessManage&QueryName=QryAccessBase&BaseType=Company",
		loadMsg: '加载中..',
		pagination: true,
		rownumbers: true,
		idField: "BaseRowid",
		pageSize: 20,
		pageList: [20,50,100,200],
		columns: CompanyColumns,
		toolbar: CompanyToolBar,
		onBeforeLoad: function(queryParams){
			$(this).datagrid("unselectAll");
		},
		onClickRow: function(rowIndex, rowData){
			PageLogicObj.m_ModuleLinkTabDataGrid.datagrid("reload");
		},
		onDblClickRow: function(rowIndex, rowData){
			PageLogicObj.m_CompanyTabDataGrid.datagrid("beginEdit",rowIndex);
		}
	});
	return CompanyTabDataGrid;
}

function InitModuleLinkTabDataGrid(){
	var LinkColumns=[[
		{field:'ModuleRowid',title:'模块id',width:1,hidden:true},
		{field:'ModuleCode',title:'模块代码',width:1,hidden:true},
		{field:'ModuleDesc',title:'模块名称',width:200,
			formatter:function(v,rec){
				return '<a href="#" id='+rec.ModuleCode+' class="editcls1" onmouseover=ShowLinkInfo("'+rec.ModuleCode+'") onclick=CompanyLinkDialogOpen("'+rec.ModuleRowid+'","'+rec.ModuleDesc+'")>'+v+'</a>';
			}
		},
		//{field:'LinkClass',title:'对应后台类文件',width:400,editor:{type:'text',options:{}}},
		{field:'ReferenceJS',title:'需引入JS',width:300,editor:{type:'text',options:{}}},
		{field:'ProductDomain',title:'业务域id',width:1,hidden:true},
		{field:'ProductDomainStr',title:'业务域',width:200,
			editor:{
				type:'combobox',
				options:{
					url:"DHCDoc.Util.QueryToJSON.cls?JSONTYPE=Combo&ClassName=DHCDoc.Interface.AccessManage&QueryName=QryAccessBase&BaseType=Product",
					editable:false,
					valueField:'BaseRowid',
					textField:'BaseDesc',
					multiple:true,
					rowStyle:'checkbox',
					selectOnNavigation:false,
					panelHeight:"auto",
				}
			}
		},
		{field:'AuthLocStr',title:'授权科室id',width:1,hidden:true},
		{field:'ActiveFlag',title:'是否启用',align:'center',
			editor:{
				type:'icheckbox',
				options : {
					on : 'Y',
					off : ''
				}
			},
			styler: function(value,row,index){
				if (value=="Y"){
					return 'color:#21ba45;';
				}else{
					return 'color:#f16e57;';
				}
			},
			formatter:function(value,record){
				if (value=="Y") return "是";
				else  return "否";
			}
		}
    ]];
	var LinkToolBar=[{
        text: '保存关联数据',
        iconCls: 'icon-save',
        handler: function() {
			SaveLinkInfo("Module");
        }
	},{
        text: '科室授权',
        iconCls: 'icon-key',
        handler: function() {
            SaveAuthLocStr(PageLogicObj.m_ModuleLinkTabDataGrid);
        }
    },{
        text: '扩展设定',
        iconCls: 'icon-all-screen',
        handler: function() {
            SaveLinkExt(PageLogicObj.m_ModuleLinkTabDataGrid);
        }
    },'-',{
	    id:'tip',
	    iconCls: 'icon-help',
	    text:'使用说明',
	    handler: function(){
		    if($('#tipInfo').is(':visible')){
				$('#tipInfo').hide();
			}else{
				$('#tipInfo').show();
			}
		}
	}];
    ModuleLinkTabDataGrid=$('#ModuleLinkTab').datagrid({  
		fit: true,
		width: 'auto',
		border: false,
		striped: true,
		singleSelect: true,
		fitColumns: false,
		autoRowHeight: false,
		url:$URL+"?ClassName=DHCDoc.Interface.AccessManage&QueryName=QryAccessLink&rows=9999",
		loadMsg: '加载中..',
		pagination: false,
		idField: "ModuleRowid",
		columns: LinkColumns,
		toolbar: LinkToolBar,
		onBeforeLoad: function(queryParams){
			if (GetCompanyRowid()=="") return;
			$.extend(queryParams,{
				SearchType:"Module",
				SearchValue:GetCompanyRowid(),
				HospitalId:$HUI.combogrid('#_HospList').getValue()
			});
			$(this).datagrid("unselectAll");
			$('#tipInfo').hide();
		},
		onLoadSuccess:function(data){
			//
		},
		onBeforeSelect:function(rowIndex, rowData) {
			var CompanyRowid=GetCompanyRowid();
			if (CompanyRowid=="") {
				$.messager.alert('提示',"请先选择厂家");
		 		return false;
			}
			return true;
		},
		onDblClickRow:function(rowIndex, rowData){
			var CompanyRowid=GetCompanyRowid();
			if (CompanyRowid=="") {
				$.messager.alert('提示',"请先选择厂家");
		 		return false;
			}
			PageLogicObj.m_ModuleLinkTabDataGrid.datagrid("beginEdit",rowIndex);
			//
			var editors=PageLogicObj.m_ModuleLinkTabDataGrid.datagrid('getEditors',rowIndex);
			if (editors.length>0) {
				if (rowData.ProductDomain!="") {
					editors[1].target.combobox("setValues",rowData.ProductDomain.split("!"));
				}
			}
		}
	});
	return ModuleLinkTabDataGrid;
}

function GetCompanyRowid() {
	var CompanyRowid="";
	var rowData=PageLogicObj.m_CompanyTabDataGrid.datagrid("getSelected");
	if ((rowData)&&(rowData.BaseRowid)) {
		CompanyRowid=rowData.BaseRowid;
	}
	return CompanyRowid;
}

function SaveLinkInfo(Type,ModuleRowid){
	if (typeof ModuleRowid == "undefined") ModuleRowid="";
	//厂家id+模块id+后台类文件+业务域+是否启用+院区id+用户id
	var UserID=session['LOGON.USERID'];
	var HospitalId=$HUI.combogrid('#_HospList').getValue();
	var SaveRows=new Array();
	if (Type=="Module") {
		var CompanyRowid=GetCompanyRowid();
		if (CompanyRowid=="") {
			$.messager.alert('提示',"请先选择厂家");
	 		return false;
		}
		var rows=PageLogicObj.m_ModuleLinkTabDataGrid.datagrid('getRows');
	}else if (Type=="Company") {
		if (ModuleRowid=="") {
			$.messager.alert('提示',"请先选择模块");
	 		return false;
		}
		var rows=PageLogicObj.m_CompanyLinkTabDataGrid.datagrid('getRows');
	}
	for(var i=0;i<rows.length;i++){
		if (Type=="Module") {
			ModuleRowid=rows[i].ModuleRowid;
			var editors=PageLogicObj.m_ModuleLinkTabDataGrid.datagrid('getEditors',i);
		}else if (Type=="Company") {
			CompanyRowid=rows[i].CompanyRowid;
			var editors=PageLogicObj.m_CompanyLinkTabDataGrid.datagrid('getEditors',i);
		}
		var LinkClass="",ProductDomain="",ActiveFlag="",ReferenceJS="";
		if (editors.length>0) {
			ReferenceJS=editors[0].target.val();
			ProductDomain=editors[1].target.combobox("getValues").join("!");
			var selected=editors[2].target.is(':checked');
			if (selected) ActiveFlag="Y";
		}else{
			ReferenceJS=rows[i].ReferenceJS;
			ProductDomain=rows[i].ProductDomain;
			ActiveFlag=rows[i].ActiveFlag;
		}
		var SaveRow=new Object();
		SaveRow.CompanyRowid=CompanyRowid;
		SaveRow.ModuleRowid=ModuleRowid;
		SaveRow.LinkClass=LinkClass;
		SaveRow.ProductDomain=ProductDomain;
		SaveRow.ActiveFlag=ActiveFlag;
		SaveRow.HospitalId=HospitalId;
		SaveRow.UserID=UserID;
		SaveRow.ReferenceJS=ReferenceJS;
		//
		SaveRows.push(SaveRow);
	}
	if(!SaveRows.length){
		$.messager.popover({msg:"没有需要保存的数据",type:'alert'});
		return false;
	}
	var rtn=$.cm({
		ClassName:'DHCDoc.Interface.AccessManage',
		MethodName:'SaveAccessLink',
		dataType:'text',
		InputJson:JSON.stringify(SaveRows)
	},false);
	if(rtn.split("^")[0]=='0'){
		if (rtn.split("^")[1]=="") {
			$.messager.show({title:"提示",msg:"保存成功"});
		}else{
			$.messager.alert("提示", "保存成功，但是"+"<br>"+rtn.split("^")[1]);
		}
		if (Type=="Module") {
			PageLogicObj.m_ModuleLinkTabDataGrid.datagrid('unselectAll').datagrid('reload');
		}else if (Type=="Company") {
			PageLogicObj.m_CompanyLinkTabDataGrid.datagrid('unselectAll').datagrid('reload');
			PageLogicObj.m_ModuleLinkTabDataGrid.datagrid('unselectAll').datagrid('reload');
		}
	}else{
		$.messager.alert('提示',rtn.split("^")[1]);
		return false;
	}
}

function ModuleDialogOpen(){
	$("#Module-dialog").dialog("open");
	if (PageLogicObj.m_ModuleTabDataGrid=="") {
		PageLogicObj.m_ModuleTabDataGrid=InitModuleTabDataGrid();
	}else{
		PageLogicObj.m_ModuleTabDataGrid.datagrid("reload");
	}
}

function InitModuleTabDataGrid(){
	var ModuleColumns=[[
		{field:'BaseRowid',title:'模块id',width:1,hidden:true},
		{field:'BaseCode',title:'模块代码',width:200,editor:{type:'text',options:{}}},
		{field:'BaseDesc',title:'模块名称',width:200,editor:{type:'text',options:{}}}
    ]];
	var ModuleToolBar=[{
        text: '增加',
        iconCls: 'icon-add',
        handler: function() {
			PageLogicObj.m_ModuleTabDataGrid.datagrid("insertRow", {
                index: 0,
                row: {}
            });
            PageLogicObj.m_ModuleTabDataGrid.datagrid("beginEdit", 0);
        }
	},{
		text: '删除',
		iconCls: 'icon-cancel',
		handler: function() {
			var rowData=PageLogicObj.m_ModuleTabDataGrid.datagrid("getSelected");
			if (!rowData){
				$.messager.alert("提示", "请选择需要删除的数据");
				return false;
			}
			if (rowData.BaseRowid) {
				$.messager.confirm("提示", "确定要删除模块:"+rowData.BaseDesc+"吗?", function(r) {
	                if (r) {
	                    var rtn=$.cm({
							ClassName:"DHCDoc.Interface.AccessManage", 
							MethodName:"DeleteAccessBase",
							dataType:'text',
							BaseRowid:rowData.BaseRowid,
							BaseType:"Module"
						},false);
				        if(rtn=="0"){
					        $.messager.show({title:"提示",msg:"删除成功"});
							PageLogicObj.m_ModuleTabDataGrid.datagrid('unselectAll').datagrid('reload');
				        	PageLogicObj.m_ModuleLinkTabDataGrid.datagrid("reload");
				        }else{
					       $.messager.alert('提示',"删除失败:"+rtn);
					       return false;
				        }
	                }
				});
			}else{
				var index=PageLogicObj.m_ModuleTabDataGrid.datagrid('getRowIndex',rowData);
				PageLogicObj.m_ModuleTabDataGrid.datagrid('deleteRow',index);
			}
		}
	},{
		text: '保存',
		iconCls: 'icon-save',
		handler: function() {
			var SaveRows=new Array();
			var rows=PageLogicObj.m_ModuleTabDataGrid.datagrid('getRows');
			for(var i=rows.length-1;i>=0;i--){
				var ModuleRowid=rows[i].BaseRowid;
				if (!ModuleRowid) ModuleRowid="";
				var editors=PageLogicObj.m_ModuleTabDataGrid.datagrid('getEditors',i);
				if(!editors.length) continue;
				var ModuleCode=editors[0].target.val();
				if (!ModuleCode) {
					$.messager.alert("提示","请填写模块代码");
	            	return false;
				}
				var ModuleDesc=editors[1].target.val();
				if (!ModuleDesc) {
					$.messager.alert("提示","请填写模块名称");
	            	return false;
				}
				var SaveRow=new Object();
				SaveRow.ModuleRowid=ModuleRowid;
				SaveRow.ModuleCode=ModuleCode;
				SaveRow.ModuleDesc=ModuleDesc;
				//
				SaveRows.push(SaveRow);
			}
			if(!SaveRows.length){
				$.messager.popover({msg:"没有需要保存的数据",type:'alert'});
				return false;
			}
			var rtn=$.cm({
				ClassName:'DHCDoc.Interface.AccessManage',
				MethodName:'SaveAccessModule',
				dataType:'text',
				ModuleJson:JSON.stringify(SaveRows)
			},false);
			if(rtn=='0'){
				$.messager.show({title:"提示",msg:"保存成功"});
				PageLogicObj.m_ModuleTabDataGrid.datagrid('unselectAll').datagrid('reload');
				PageLogicObj.m_ModuleLinkTabDataGrid.datagrid("reload");
			}else{
				$.messager.alert('提示','保存失败:'+rtn);
       			return false;
       		}
		}
	},{
        text: '取消编辑',
        iconCls: 'icon-redo',
        handler: function() {
            PageLogicObj.m_ModuleTabDataGrid.datagrid("unselectAll").datagrid("rejectChanges");
        }
    }];
    ModuleTabDataGrid=$('#ModuleTab').datagrid({  
		fit: true,
		width: 'auto',
		border: false,
		striped: true,
		singleSelect: true,
		fitColumns: false,
		autoRowHeight: false,
		url:$URL+"?ClassName=DHCDoc.Interface.AccessManage&QueryName=QryAccessBase&BaseType=Module",
		loadMsg: '加载中..',
		pagination: true,
		rownumbers: true,
		idField: "BaseRowid",
		pageSize: 20,
		pageList: [20,50,100,200],
		columns: ModuleColumns,
		toolbar: ModuleToolBar,
		onBeforeLoad: function(queryParams){
			$(this).datagrid("unselectAll");
		},
		onDblClickRow: function(rowIndex, rowData){
			PageLogicObj.m_ModuleTabDataGrid.datagrid("beginEdit",rowIndex);
		}
	});
	return ModuleTabDataGrid;
}

function ProductDialogOpen(){
	$("#Product-dialog").dialog("open");
	if (PageLogicObj.m_ProductTabDataGrid=="") {
		PageLogicObj.m_ProductTabDataGrid=InitProductTabDataGrid();
	}else{
		PageLogicObj.m_ProductTabDataGrid.datagrid("reload");
	}
}

function InitProductTabDataGrid(){
	var ProductColumns=[[
		{field:'BaseRowid',title:'业务域id',width:1,hidden:true},
		{field:'BaseCode',title:'业务域代码',width:150,editor:{type:'text',options:{}}},
		{field:'BaseDesc',title:'业务域名称',width:150,editor:{type:'text',options:{}}},
		{field:'ReferenceJS',title:'需引入JS',width:290,showTip:true,editor:{type:'text',options:{}}}
    ]];
	var ProductToolBar=[{
        text: '增加',
        iconCls: 'icon-add',
        handler: function() {
			PageLogicObj.m_ProductTabDataGrid.datagrid("insertRow", {
                index: 0,
                row: {}
            });
            PageLogicObj.m_ProductTabDataGrid.datagrid("beginEdit", 0);
        }
	}/*,{
		text: '删除',
		iconCls: 'icon-cancel',
		handler: function() {
			var rowData=PageLogicObj.m_ProductTabDataGrid.datagrid("getSelected");
			if (!rowData){
				$.messager.alert("提示", "请选择需要删除的数据");
				return false;
			}
			if (rowData.BaseRowid) {
				$.messager.confirm("提示", "确定要删除此业务域（同时会删除关联数据中的此业务域）："+rowData.BaseDesc+"吗?", function(r) {
	                if (r) {
	                    var rtn=$.cm({
							ClassName:"DHCDoc.Interface.AccessManage", 
							MethodName:"DeleteAccessBase",
							dataType:'text',
							BaseRowid:rowData.BaseRowid,
							BaseType:"Product"
						},false);
				        if(rtn=="0"){
					        $.messager.show({title:"提示",msg:"删除成功"});
							PageLogicObj.m_ProductTabDataGrid.datagrid('unselectAll').datagrid('reload');
				        	PageLogicObj.m_ModuleLinkTabDataGrid.datagrid("reload");
				        }else{
					       $.messager.alert('提示',"删除失败:"+rtn);
					       return false;
				        }
	                }
				});
			}else{
				var index=PageLogicObj.m_ProductTabDataGrid.datagrid('getRowIndex',rowData);
				PageLogicObj.m_ProductTabDataGrid.datagrid('deleteRow',index);
			}
		}
	}*/,{
		text: '保存',
		iconCls: 'icon-save',
		handler: function() {
			var SaveRows=new Array();
			var rows=PageLogicObj.m_ProductTabDataGrid.datagrid('getRows');
			for(var i=rows.length-1;i>=0;i--){
				var ProductRowid=rows[i].BaseRowid;
				if (!ProductRowid) ProductRowid="";
				var editors=PageLogicObj.m_ProductTabDataGrid.datagrid('getEditors',i);
				if(!editors.length) continue;
				var ProductCode=editors[0].target.val();
				if (!ProductCode) {
					$.messager.alert("提示","请填写业务域代码");
	            	return false;
				}
				var ProductDesc=editors[1].target.val();
				if (!ProductDesc) {
					$.messager.alert("提示","请填写业务域名称");
	            	return false;
				}
				var ReferenceJS=editors[2].target.val();
				
				var SaveRow=new Object();
				SaveRow.ProductRowid=ProductRowid;
				SaveRow.ProductCode=ProductCode;
				SaveRow.ProductDesc=ProductDesc;
				SaveRow.ReferenceJS=ReferenceJS;
				//
				SaveRows.push(SaveRow);
			}
			if(!SaveRows.length){
				$.messager.popover({msg:"没有需要保存的数据",type:'alert'});
				return false;
			}
			var rtn=$.cm({
				ClassName:'DHCDoc.Interface.AccessManage',
				MethodName:'SaveAccessProduct',
				dataType:'text',
				ProductJson:JSON.stringify(SaveRows)
			},false);
			if(rtn=='0'){
				$.messager.show({title:"提示",msg:"保存成功"});
				PageLogicObj.m_ProductTabDataGrid.datagrid('unselectAll').datagrid('reload');
			}else{
				$.messager.alert('提示','保存失败:'+rtn);
       			return false;
       		}
		}
	},{
        text: '取消编辑',
        iconCls: 'icon-redo',
        handler: function() {
            PageLogicObj.m_ProductTabDataGrid.datagrid("unselectAll").datagrid("rejectChanges");
        }
    },{
        text: '接入排序',
        iconCls: 'icon-sort',
		handler: function() {
            AccessSortOpen();
        }
    }];
    ProductTabDataGrid=$('#ProductTab').datagrid({  
		fit: true,
		width: 'auto',
		border: false,
		striped: true,
		singleSelect: true,
		fitColumns: false,
		autoRowHeight: false,
		url:$URL+"?ClassName=DHCDoc.Interface.AccessManage&QueryName=QryAccessBase&BaseType=Product",
		loadMsg: '加载中..',
		pagination: true,
		rownumbers: true,
		idField: "BaseRowid",
		pageSize: 20,
		pageList: [20,50,100,200],
		columns: ProductColumns,
		toolbar: ProductToolBar,
		onBeforeLoad: function(queryParams){
			$(this).datagrid("unselectAll");
		},
		onDblClickRow: function(rowIndex, rowData){
			//PageLogicObj.m_ProductTabDataGrid.datagrid("beginEdit",rowIndex);
			$.messager.alert("提示","业务域修改可能会影响正常业务界面的使用，请联系开发操作!");
			return false;
		}
	});
	return ProductTabDataGrid;
}
function ShowLinkInfo(ModuleCode){
	var LinkInfo=$.cm({
		ClassName:"DHCDoc.Interface.AccessManage",
		MethodName:"GetAccessLinkInfo",
		dataType:"text",
		SearchType:"Company",
		SearchCode:ModuleCode,
		HospitalId:$HUI.combogrid('#_HospList').getValue()
	},false);
	if (LinkInfo=="") return false;
	var content="";
	var LinkObj=eval("("+LinkInfo+")");
	$.each(LinkObj,function(i,obj){
		if (content=="") {
			content=obj.CompanyDesc;
		}else{
			content=content+"<br>"+obj.CompanyDesc;
		}
	});
	if (content=="") return false;
	$("#"+ModuleCode).webuiPopover({
		title:'',
		content:content,
		trigger:'hover',
		placement:'right',
		style:'inverse',
		height:'auto',
		width:'auto'
	});
	$("#"+ModuleCode).webuiPopover('show');
}

function CompanyLinkDialogOpen(ModuleRowid,ModuleDesc) {
	PageLogicObj.ModuleRowid=ModuleRowid;
	$("#CompanyLink-dialog").dialog("open").dialog("setTitle","关联厂家-模块:"+ModuleDesc);
	if (PageLogicObj.m_CompanyLinkTabDataGrid=="") {
		PageLogicObj.m_CompanyLinkTabDataGrid=InitCompanyLinkTabDataGrid();
	}else{
		PageLogicObj.m_CompanyLinkTabDataGrid.datagrid("reload");
	}
}

function InitCompanyLinkTabDataGrid(){
	if(typeof PageLogicObj.ModuleRowid == "undefined") {
		PageLogicObj.ModuleRowid = "";
	}
	var LinkColumns=[[
		{field:'CompanyRowid',title:'厂家id',width:1,hidden:true},
		{field:'CompanyCode',title:'厂家代码',width:1,hidden:true},
		{field:'CompanyDesc',title:'厂家名称',width:200},
		//{field:'LinkClass',title:'对应后台类文件',width:400,editor:{type:'text',options:{}}},
		{field:'ReferenceJS',title:'需引入JS',width:400,editor:{type:'text',options:{}}},
		{field:'ProductDomain',title:'业务域id',width:1,hidden:true},
		{field:'ProductDomainStr',title:'业务域',width:200,
			editor:{
				type:'combobox',
				options:{
					url:"DHCDoc.Util.QueryToJSON.cls?JSONTYPE=Combo&ClassName=DHCDoc.Interface.AccessManage&QueryName=QryAccessBase&BaseType=Product",
					editable:true,
					valueField:'BaseRowid',
					textField:'BaseDesc',
					multiple:true,
					rowStyle:'checkbox',
					selectOnNavigation:false,
					panelHeight:"auto"
				}
			}
		},
		{field:'AuthLocStr',title:'授权科室id',width:1,hidden:true},
		{field:'ActiveFlag',title:'是否启用',align:'center',
			editor:{
				type:'icheckbox',
				options : {
					on : 'Y',
					off : ''
				}
			},
			styler: function(value,row,index){
				if (value=="Y"){
					return 'color:#21ba45;';
				}else{
					return 'color:#f16e57;';
				}
			},
			formatter:function(value,record){
				if (value=="Y") return "是";
				else  return "否";
			}
		}
    ]];
	var LinkToolBar=[{
        text: '保存关联数据',
        iconCls: 'icon-save',
        handler: function() {
			SaveLinkInfo("Company",PageLogicObj.ModuleRowid);
        }
	},{
        text: '科室授权',
        iconCls: 'icon-key',
        handler: function() {
            SaveAuthLocStr(PageLogicObj.m_CompanyLinkTabDataGrid);
        }
    },{
        text: '扩展设定',
        iconCls: 'icon-all-screen',
        handler: function() {
            SaveLinkExt(PageLogicObj.m_CompanyLinkTabDataGrid);
        }
    }];
    CompanyLinkTabDataGrid=$('#CompanyLinkTab').datagrid({  
		fit: true,
		width: 'auto',
		border: false,
		striped: true,
		singleSelect: true,
		fitColumns: false,
		autoRowHeight: false,
		url:$URL+"?ClassName=DHCDoc.Interface.AccessManage&QueryName=QryAccessLink&rows=9999",
		loadMsg: '加载中..',
		pagination: false,
		idField: "CompanyRowid",
		columns: LinkColumns,
		toolbar: LinkToolBar,
		onBeforeLoad: function(queryParams){
			$.extend(queryParams,{
				SearchType:"Company",
				SearchValue:PageLogicObj.ModuleRowid,
				HospitalId:$HUI.combogrid('#_HospList').getValue()
			});
			$(this).datagrid("unselectAll");
		},
		onLoadSuccess:function(data){
			//
		},
		onDblClickRow: function(rowIndex, rowData){
			if (PageLogicObj.ModuleRowid=="") {
				$.messager.alert('提示',"请先选择模块");
		 		return false;
			}
			PageLogicObj.m_CompanyLinkTabDataGrid.datagrid("beginEdit",rowIndex);
			//
				var editors=PageLogicObj.m_CompanyLinkTabDataGrid.datagrid('getEditors',rowIndex);
				if (editors.length>0) {
				if (rowData.ProductDomain!="") {
					editors[1].target.combobox("setValues",rowData.ProductDomain.split("!"));
				}
			}
		}
	});
	return CompanyLinkTabDataGrid;
}

function SaveAuthLocStr(m_DataGrid){
	var rowData=m_DataGrid.datagrid("getSelected");
	if (!rowData){
		$.messager.alert("提示","请先选择行");
		return false;
	}
	if (!rowData.LinkRowid) {
		$.messager.alert("提示","请先保存关联数据");
		return false;
	}
	var LinkRowid=rowData.LinkRowid;
	var AuthLocStr=rowData.AuthLocStr;
	var HospitalId=$HUI.combogrid('#_HospList').getValue();
	websys_showModal({
		url:"dhcdoc.util.tablelist.csp?TableName=CT_Loc&IDList="+AuthLocStr+"&HospDr="+HospitalId+"&DisplayType=Select",
		title:'科室授权',
		width:400,height:610,
		closable:false,
		CallBackFunc:function(result){
			websys_showModal("close");
			if ((typeof result==="undefined")||(result===false)){
				return;
			}
			var rtn=tkMakeServerCall("DHCDoc.Interface.AccessManage","UpdateAuthLocStr",LinkRowid,result)
			if (rtn=="0"){
				$.messager.show({title:"提示",msg:"授权成功"});
				m_DataGrid.datagrid("reload");
				if (m_DataGrid==PageLogicObj.m_CompanyLinkTabDataGrid) {
					PageLogicObj.m_ModuleLinkTabDataGrid.datagrid("reload");
				}
			}else{
				$.messager.alert('提示',"授权失败:"+value+",请稍后重试")
			}
		}
	})
}

function SaveLinkExt(m_DataGrid){
	var rowData=m_DataGrid.datagrid("getSelected");
	if (!rowData){
		$.messager.alert("提示","请先选择行");
		return false;
	}
	if (!rowData.LinkRowid) {
		$.messager.alert("提示","请先保存关联数据");
		return false;
	}
	PageLogicObj.LinkRowid=rowData.LinkRowid;
	$("#LinkExt-dialog").dialog("open").dialog("setTitle","关联扩展维护(厂家:"+rowData.CompanyDesc+",模块:"+rowData.ModuleDesc+")");
	if (PageLogicObj.m_LinkExtTabDataGrid=="") {
		PageLogicObj.m_LinkExtTabDataGrid=InitLinkExtTabDataGrid();
	}else{
		PageLogicObj.m_LinkExtTabDataGrid.datagrid("reload");
	}
}

function InitLinkExtTabDataGrid(){
	var ExtColumns=[[
		{field:'ExtRowid',title:'扩展id',width:1,hidden:true},
		{field:'ExtCode',title:'代码',width:150,editor:{type:'text',options:{}}},
		{field:'ExtDesc',title:'描述',width:200,
			editor:{
				type:'text',
				options:{}
			},
			formatter: function(value,row,index){
				return '<a href="#" id="'+row["ExtRowid"]+'" class="hisui-tooltip" title="'+value+'" >'+value+'</a>';
			}
		},
		{field:'ExtValue',title:'值',width:150,editor:{type:'text',options:{}}},
		{field:'ExtModuleFlag',title:'模块级',align:'center',
			editor:{
				type:'icheckbox',
				options : {
					on : 'Y',
					off : ''
				}
			},
			styler: function(value,row,index){
				if (value=="Y"){
					return 'color:#21ba45;';
				}else{
					return 'color:#f16e57;';
				}
			},
			formatter:function(value,record){
				if (value=="Y") return "是";
				else  return "否";
			}
		}
    ]];
	var ExtToolBar=[{
        text: '增加',
        iconCls: 'icon-add',
        handler: function() {
			PageLogicObj.m_LinkExtTabDataGrid.datagrid("insertRow", {
                index: 0,
                row: {}
            });
            PageLogicObj.m_LinkExtTabDataGrid.datagrid("beginEdit", 0);
        }
	},{
		text: '删除',
		iconCls: 'icon-cancel',
		handler: function() {
			var rowData=PageLogicObj.m_LinkExtTabDataGrid.datagrid("getSelected");
			if (!rowData){
				$.messager.alert("提示", "请选择需要删除的数据");
				return false;
			}
			if (rowData.ExtRowid) {
				//模块级扩展数据不允许删除
				if (rowData.ExtModuleFlag=="Y") {
					$.messager.alert("提示", "模块级扩展数据不允许删除");
					return false;
				}
				$.messager.confirm("提示", "确定要删除扩展节点:"+rowData.ExtDesc+"吗?", function(r) {
	                if (r) {
	                    var rtn=$.cm({
							ClassName:"DHCDoc.Interface.AccessManage", 
							MethodName:"DeleteAccessLinkExt",
							dataType:'text',
							ExtRowid:rowData.ExtRowid
						},false);
				        if(rtn=="0"){
					        $.messager.show({title:"提示",msg:"删除成功"});
							PageLogicObj.m_LinkExtTabDataGrid.datagrid('unselectAll').datagrid('reload');
				        }else{
					       $.messager.alert('提示',"删除失败:"+rtn);
					       return false;
				        }
	                }
				});
			}else{
				var index=PageLogicObj.m_LinkExtTabDataGrid.datagrid('getRowIndex',rowData);
				PageLogicObj.m_LinkExtTabDataGrid.datagrid('deleteRow',index);
			}
		}
	},{
		text: '保存',
		iconCls: 'icon-save',
		handler: function() {
			var SaveRows=new Array();
			var rows=PageLogicObj.m_LinkExtTabDataGrid.datagrid('getRows');
			for(var i=rows.length-1;i>=0;i--){
				var ExtRowid=rows[i].ExtRowid;
				if (!ExtRowid) ExtRowid="";
				var editors=PageLogicObj.m_LinkExtTabDataGrid.datagrid('getEditors',i);
				if(!editors.length) continue;
				var ExtCode=editors[0].target.val();
				if (!ExtCode) {
					$.messager.alert("提示","请填写代码");
	            	return false;
				}
				var ExtDesc=editors[1].target.val();
				if (!ExtDesc) {
					$.messager.alert("提示","请填写描述");
	            	return false;
				}
				var ExtValue=editors[2].target.val();
				if (!ExtValue) ExtValue="";
				var ExtModuleFlag="";
				var selected=editors[3].target.is(':checked');
				if (selected) ExtModuleFlag="Y";

				var SaveRow=new Object();
				SaveRow.ExtRowid=ExtRowid;
				SaveRow.ExtCode=ExtCode;
				SaveRow.ExtDesc=ExtDesc;
				SaveRow.ExtValue=ExtValue;
				SaveRow.ExtModuleFlag=ExtModuleFlag;
				//
				SaveRows.push(SaveRow);
			}
			if(!SaveRows.length){
				$.messager.popover({msg:"没有需要保存的数据",type:'alert'});
				return false;
			}
			var rtn=$.cm({
				ClassName:'DHCDoc.Interface.AccessManage',
				MethodName:'SaveAccessLinkExt',
				dataType:'text',
				LinkRowid:PageLogicObj.LinkRowid,
				ExtJson:JSON.stringify(SaveRows)
			},false);
			if(rtn=='0'){
				$.messager.show({title:"提示",msg:"保存成功"});
				PageLogicObj.m_LinkExtTabDataGrid.datagrid('unselectAll').datagrid('reload');
			}else{
				$.messager.alert('提示','保存失败:'+rtn);
       			return false;
       		}
		}
	},{
        text: '取消编辑',
        iconCls: 'icon-redo',
        handler: function() {
            PageLogicObj.m_LinkExtTabDataGrid.datagrid("unselectAll").datagrid("rejectChanges");
        }
    }];
    LinkExtTabDataGrid=$('#LinkExtTab').datagrid({  
		fit: true,
		width: 'auto',
		border: false,
		striped: true,
		singleSelect: true,
		fitColumns: false,
		autoRowHeight: false,
		url:$URL+"?ClassName=DHCDoc.Interface.AccessManage&QueryName=QryAccessLinkExt&rows=9999",
		loadMsg: '加载中..',
		pagination: false,
		idField: "ExtRowid",
		columns: ExtColumns,
		toolbar: ExtToolBar,
		onBeforeLoad: function(queryParams){
			$.extend(queryParams,{
				LinkRowid:PageLogicObj.LinkRowid
			});
			$(this).datagrid("unselectAll");
			//手工结束编辑,不知道为啥,再次双击不管用
			var rows=$(this).datagrid('getRows');
			for(var i=0;i<rows.length;i++) {
				var editors=$(this).datagrid('getEditors',i);
				if(!editors.length) continue;
				$(this).datagrid('endEdit', i);
			}
		},
		onLoadSuccess:function(data){
			//
		},
		onDblClickRow: function(rowIndex, rowData){
			if (PageLogicObj.LinkRowid=="") {
				$.messager.alert('提示',"请先保存关联数据");
		 		return false;
			}
			PageLogicObj.m_LinkExtTabDataGrid.datagrid("beginEdit",rowIndex);
			//模块级扩展数据只允许填写值,其它不允许修改
			var editors=PageLogicObj.m_LinkExtTabDataGrid.datagrid('getEditors',rowIndex);
			if ((editors.length>0)&&(rowData.ExtRowid!="")&&(rowData.ExtModuleFlag=="Y")) {
				editors[0].target.attr("disabled", true);
				editors[1].target.attr("disabled", true);
				editors[3].target.attr("disabled", true);
			}
		}
	});
	return LinkExtTabDataGrid;
}

function AccessSortOpen() {
	var rowData=PageLogicObj.m_ProductTabDataGrid.datagrid("getSelected");
	if (!rowData){
		$.messager.alert("提示","请先选择行");
		return false;
	}
	if (!rowData.BaseRowid) {
		$.messager.alert("提示","请先保存行数据");
		return false;
	}
	PageLogicObj.ProductRowid=rowData.BaseRowid;
	$("#AccessSort-dialog").dialog("open").dialog("setTitle","接入排序(业务域:"+rowData.BaseDesc+")");
	if (PageLogicObj.m_AccessSortTabDataGrid=="") {
		PageLogicObj.m_AccessSortTabDataGrid=InitAccessSortTabDataGrid();
	}else{
		PageLogicObj.m_AccessSortTabDataGrid.datagrid("reload");
	}
}

function InitAccessSortTabDataGrid(){
	var SortColumns=[[
		{field:'LinkRowid',title:'关联id',width:1,hidden:true},
		{field:'CompanyDesc',title:'厂家',width:200},
		{field:'ModuleDesc',title:'模块',width:200},
		{field:'ActiveFlag',title:'是否启用',width:80},
		{field:'SortId',title:'排序id',width:1,hidden:true},
		{field:'SortNum',title:'顺序号',width:100,editor:{type:'text',options:{}}}
    ]];
	var SortToolBar=[{
		text: '保存',
		iconCls: 'icon-save',
		handler: function() {
			var SaveRows=new Array();
			var rows=PageLogicObj.m_AccessSortTabDataGrid.datagrid('getRows');
			for(var i=0;i<rows.length;i++) {
				var editors=PageLogicObj.m_AccessSortTabDataGrid.datagrid('getEditors',i);
				if(!editors.length) continue;
				var LinkRowid=rows[i].LinkRowid;
				var SortId=rows[i].SortId;
				var SortNum=editors[0].target.val();

				var SaveRow=new Object();
				SaveRow.LinkRowid=LinkRowid;
				SaveRow.SortId=SortId;
				SaveRow.SortNum=SortNum;
				//
				SaveRows.push(SaveRow);
			}
			if(!SaveRows.length){
				$.messager.popover({msg:"没有需要保存的数据",type:'alert'});
				return false;
			}
			var rtn=$.cm({
				ClassName:'DHCDoc.Interface.AccessManage',
				MethodName:'SaveAccessSort',
				dataType:'text',
				ProductDr:PageLogicObj.ProductRowid,
				SortJson:JSON.stringify(SaveRows)
			},false);
			if(rtn=='0'){
				$.messager.show({title:"提示",msg:"保存成功"});
				PageLogicObj.m_AccessSortTabDataGrid.datagrid('unselectAll').datagrid('reload');
			}else{
				$.messager.alert('提示','保存失败:'+rtn);
       			return false;
       		}
		}
	},{
        text: '取消编辑',
        iconCls: 'icon-redo',
        handler: function() {
            PageLogicObj.m_AccessSortTabDataGrid.datagrid("unselectAll").datagrid("rejectChanges");
        }
    }];
    AccessSortTabDataGrid=$('#AccessSortTab').datagrid({  
		fit: true,
		width: 'auto',
		border: false,
		striped: true,
		singleSelect: true,
		fitColumns: false,
		autoRowHeight: false,
		url:$URL+"?ClassName=DHCDoc.Interface.AccessManage&QueryName=QryLinkInfo&rows=9999",
		loadMsg: '加载中..',
		pagination: false,
		idField: "LinkRowid",
		columns: SortColumns,
		toolbar: SortToolBar,
		onBeforeLoad: function(queryParams){
			$.extend(queryParams,{
				SearchProduct:PageLogicObj.ProductRowid,
				HospitalId:$HUI.combogrid('#_HospList').getValue()
			});
			$(this).datagrid("unselectAll");
			//手工结束编辑,不知道为啥,再次双击不管用
			var rows=$(this).datagrid('getRows');
			for(var i=0;i<rows.length;i++) {
				var editors=$(this).datagrid('getEditors',i);
				if(!editors.length) continue;
				$(this).datagrid('endEdit', i);
			}
		},
		onDblClickRow: function(rowIndex, rowData){
			if (PageLogicObj.ProductRowid=="") {
				$.messager.alert('提示',"请先选择业务域");
		 		return false;
			}
			PageLogicObj.m_AccessSortTabDataGrid.datagrid("beginEdit",rowIndex);
		}
	});
	return AccessSortTabDataGrid;
}