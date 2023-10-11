//ҳ��ȫ�ֱ���
var PageLogicObj = {
	m_CompanyTabDataGrid:"",
	m_ModuleLinkTabDataGrid:"",
	m_ModuleTabDataGrid:"",
	m_ProductTabDataGrid:"",
	m_CompanyLinkTabDataGrid:"",
	m_LinkExtTabDataGrid:"",
	m_AccessSortTabDataGrid:"",
	LinkRowid:"",	//���뵽��չ�趨����
	ModuleRowid:"",	//���뵽ѡ��ģ��,�򿪵Ĺ������ҽ���
	ProductRowid:""	//���뵽ѡ��ҵ����,�򿪵Ľ����������
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
		{field:'BaseRowid',title:'����id',width:1,hidden:true},
		{field:'BaseCode',title:'���Ҵ���',width:200},
		{field:'BaseDesc',title:'��������',width:200,editor:{type:'text',options:{}}}
    ]];
	var CompanyToolBar=[{
        text: '����',
        iconCls: 'icon-add',
        handler: function() {
			PageLogicObj.m_CompanyTabDataGrid.datagrid("insertRow", {
                index: 0,
                row: {}
            });
            PageLogicObj.m_CompanyTabDataGrid.datagrid("beginEdit", 0);
        }
	},{
		text: 'ɾ��',
		iconCls: 'icon-cancel',
		handler: function() {
			var rowData=PageLogicObj.m_CompanyTabDataGrid.datagrid("getSelected");
			if (!rowData){
				$.messager.alert("��ʾ", "��ѡ����Ҫɾ��������");
				return false;
			}
			if (rowData.BaseRowid) {
				$.messager.confirm("��ʾ", "ȷ��Ҫɾ������:"+rowData.BaseDesc+"��?", function(r) {
	                if (r) {
	                    var rtn=$.cm({
							ClassName:"DHCDoc.Interface.AccessManage", 
							MethodName:"DeleteAccessBase",
							dataType:'text',
							BaseRowid:rowData.BaseRowid,
							BaseType:"Company"
						},false);
				        if(rtn=="0"){
					        $.messager.show({title:"��ʾ",msg:"ɾ���ɹ�"});
							PageLogicObj.m_CompanyTabDataGrid.datagrid('unselectAll').datagrid('reload');
				        }else{
					       $.messager.alert('��ʾ',"ɾ��ʧ��:"+rtn);
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
		text: '����',
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
					$.messager.alert("��ʾ","����д��������");
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
				$.messager.popover({msg:"û����Ҫ���������",type:'alert'});
				return false;
			}
			var rtn=$.cm({
				ClassName:'DHCDoc.Interface.AccessManage',
				MethodName:'SaveAccessCompany',
				dataType:'text',
				CompanyJson:JSON.stringify(SaveRows)
			},false);
			if(rtn=='0'){
				$.messager.show({title:"��ʾ",msg:"����ɹ�"});
				PageLogicObj.m_CompanyTabDataGrid.datagrid('unselectAll').datagrid('reload');
			}else{
				$.messager.alert('��ʾ','����ʧ��:'+rtn);
       			return false;
       		}
		}
	}/*,{
        text: 'ȡ���༭',
        iconCls: 'icon-redo',
        handler: function() {
            PageLogicObj.m_CompanyTabDataGrid.datagrid("unselectAll").datagrid("rejectChanges");
        }
    }*/,'-',{
        text: 'ģ��ά��',
        iconCls: 'icon-edit',
        handler: function() {
            ModuleDialogOpen();
        }
    },{
        text: 'ҵ����ά��',
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
		loadMsg: '������..',
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
		{field:'ModuleRowid',title:'ģ��id',width:1,hidden:true},
		{field:'ModuleCode',title:'ģ�����',width:1,hidden:true},
		{field:'ModuleDesc',title:'ģ������',width:200,
			formatter:function(v,rec){
				return '<a href="#" id='+rec.ModuleCode+' class="editcls1" onmouseover=ShowLinkInfo("'+rec.ModuleCode+'") onclick=CompanyLinkDialogOpen("'+rec.ModuleRowid+'","'+rec.ModuleDesc+'")>'+v+'</a>';
			}
		},
		//{field:'LinkClass',title:'��Ӧ��̨���ļ�',width:400,editor:{type:'text',options:{}}},
		{field:'ReferenceJS',title:'������JS',width:300,editor:{type:'text',options:{}}},
		{field:'ProductDomain',title:'ҵ����id',width:1,hidden:true},
		{field:'ProductDomainStr',title:'ҵ����',width:200,
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
		{field:'AuthLocStr',title:'��Ȩ����id',width:1,hidden:true},
		{field:'ActiveFlag',title:'�Ƿ�����',align:'center',
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
				if (value=="Y") return "��";
				else  return "��";
			}
		}
    ]];
	var LinkToolBar=[{
        text: '�����������',
        iconCls: 'icon-save',
        handler: function() {
			SaveLinkInfo("Module");
        }
	},{
        text: '������Ȩ',
        iconCls: 'icon-key',
        handler: function() {
            SaveAuthLocStr(PageLogicObj.m_ModuleLinkTabDataGrid);
        }
    },{
        text: '��չ�趨',
        iconCls: 'icon-all-screen',
        handler: function() {
            SaveLinkExt(PageLogicObj.m_ModuleLinkTabDataGrid);
        }
    },'-',{
	    id:'tip',
	    iconCls: 'icon-help',
	    text:'ʹ��˵��',
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
		loadMsg: '������..',
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
				$.messager.alert('��ʾ',"����ѡ�񳧼�");
		 		return false;
			}
			return true;
		},
		onDblClickRow:function(rowIndex, rowData){
			var CompanyRowid=GetCompanyRowid();
			if (CompanyRowid=="") {
				$.messager.alert('��ʾ',"����ѡ�񳧼�");
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
	//����id+ģ��id+��̨���ļ�+ҵ����+�Ƿ�����+Ժ��id+�û�id
	var UserID=session['LOGON.USERID'];
	var HospitalId=$HUI.combogrid('#_HospList').getValue();
	var SaveRows=new Array();
	if (Type=="Module") {
		var CompanyRowid=GetCompanyRowid();
		if (CompanyRowid=="") {
			$.messager.alert('��ʾ',"����ѡ�񳧼�");
	 		return false;
		}
		var rows=PageLogicObj.m_ModuleLinkTabDataGrid.datagrid('getRows');
	}else if (Type=="Company") {
		if (ModuleRowid=="") {
			$.messager.alert('��ʾ',"����ѡ��ģ��");
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
		$.messager.popover({msg:"û����Ҫ���������",type:'alert'});
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
			$.messager.show({title:"��ʾ",msg:"����ɹ�"});
		}else{
			$.messager.alert("��ʾ", "����ɹ�������"+"<br>"+rtn.split("^")[1]);
		}
		if (Type=="Module") {
			PageLogicObj.m_ModuleLinkTabDataGrid.datagrid('unselectAll').datagrid('reload');
		}else if (Type=="Company") {
			PageLogicObj.m_CompanyLinkTabDataGrid.datagrid('unselectAll').datagrid('reload');
			PageLogicObj.m_ModuleLinkTabDataGrid.datagrid('unselectAll').datagrid('reload');
		}
	}else{
		$.messager.alert('��ʾ',rtn.split("^")[1]);
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
		{field:'BaseRowid',title:'ģ��id',width:1,hidden:true},
		{field:'BaseCode',title:'ģ�����',width:200,editor:{type:'text',options:{}}},
		{field:'BaseDesc',title:'ģ������',width:200,editor:{type:'text',options:{}}}
    ]];
	var ModuleToolBar=[{
        text: '����',
        iconCls: 'icon-add',
        handler: function() {
			PageLogicObj.m_ModuleTabDataGrid.datagrid("insertRow", {
                index: 0,
                row: {}
            });
            PageLogicObj.m_ModuleTabDataGrid.datagrid("beginEdit", 0);
        }
	},{
		text: 'ɾ��',
		iconCls: 'icon-cancel',
		handler: function() {
			var rowData=PageLogicObj.m_ModuleTabDataGrid.datagrid("getSelected");
			if (!rowData){
				$.messager.alert("��ʾ", "��ѡ����Ҫɾ��������");
				return false;
			}
			if (rowData.BaseRowid) {
				$.messager.confirm("��ʾ", "ȷ��Ҫɾ��ģ��:"+rowData.BaseDesc+"��?", function(r) {
	                if (r) {
	                    var rtn=$.cm({
							ClassName:"DHCDoc.Interface.AccessManage", 
							MethodName:"DeleteAccessBase",
							dataType:'text',
							BaseRowid:rowData.BaseRowid,
							BaseType:"Module"
						},false);
				        if(rtn=="0"){
					        $.messager.show({title:"��ʾ",msg:"ɾ���ɹ�"});
							PageLogicObj.m_ModuleTabDataGrid.datagrid('unselectAll').datagrid('reload');
				        	PageLogicObj.m_ModuleLinkTabDataGrid.datagrid("reload");
				        }else{
					       $.messager.alert('��ʾ',"ɾ��ʧ��:"+rtn);
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
		text: '����',
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
					$.messager.alert("��ʾ","����дģ�����");
	            	return false;
				}
				var ModuleDesc=editors[1].target.val();
				if (!ModuleDesc) {
					$.messager.alert("��ʾ","����дģ������");
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
				$.messager.popover({msg:"û����Ҫ���������",type:'alert'});
				return false;
			}
			var rtn=$.cm({
				ClassName:'DHCDoc.Interface.AccessManage',
				MethodName:'SaveAccessModule',
				dataType:'text',
				ModuleJson:JSON.stringify(SaveRows)
			},false);
			if(rtn=='0'){
				$.messager.show({title:"��ʾ",msg:"����ɹ�"});
				PageLogicObj.m_ModuleTabDataGrid.datagrid('unselectAll').datagrid('reload');
				PageLogicObj.m_ModuleLinkTabDataGrid.datagrid("reload");
			}else{
				$.messager.alert('��ʾ','����ʧ��:'+rtn);
       			return false;
       		}
		}
	},{
        text: 'ȡ���༭',
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
		loadMsg: '������..',
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
		{field:'BaseRowid',title:'ҵ����id',width:1,hidden:true},
		{field:'BaseCode',title:'ҵ�������',width:150,editor:{type:'text',options:{}}},
		{field:'BaseDesc',title:'ҵ��������',width:150,editor:{type:'text',options:{}}},
		{field:'ReferenceJS',title:'������JS',width:290,showTip:true,editor:{type:'text',options:{}}}
    ]];
	var ProductToolBar=[{
        text: '����',
        iconCls: 'icon-add',
        handler: function() {
			PageLogicObj.m_ProductTabDataGrid.datagrid("insertRow", {
                index: 0,
                row: {}
            });
            PageLogicObj.m_ProductTabDataGrid.datagrid("beginEdit", 0);
        }
	}/*,{
		text: 'ɾ��',
		iconCls: 'icon-cancel',
		handler: function() {
			var rowData=PageLogicObj.m_ProductTabDataGrid.datagrid("getSelected");
			if (!rowData){
				$.messager.alert("��ʾ", "��ѡ����Ҫɾ��������");
				return false;
			}
			if (rowData.BaseRowid) {
				$.messager.confirm("��ʾ", "ȷ��Ҫɾ����ҵ����ͬʱ��ɾ�����������еĴ�ҵ���򣩣�"+rowData.BaseDesc+"��?", function(r) {
	                if (r) {
	                    var rtn=$.cm({
							ClassName:"DHCDoc.Interface.AccessManage", 
							MethodName:"DeleteAccessBase",
							dataType:'text',
							BaseRowid:rowData.BaseRowid,
							BaseType:"Product"
						},false);
				        if(rtn=="0"){
					        $.messager.show({title:"��ʾ",msg:"ɾ���ɹ�"});
							PageLogicObj.m_ProductTabDataGrid.datagrid('unselectAll').datagrid('reload');
				        	PageLogicObj.m_ModuleLinkTabDataGrid.datagrid("reload");
				        }else{
					       $.messager.alert('��ʾ',"ɾ��ʧ��:"+rtn);
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
		text: '����',
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
					$.messager.alert("��ʾ","����дҵ�������");
	            	return false;
				}
				var ProductDesc=editors[1].target.val();
				if (!ProductDesc) {
					$.messager.alert("��ʾ","����дҵ��������");
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
				$.messager.popover({msg:"û����Ҫ���������",type:'alert'});
				return false;
			}
			var rtn=$.cm({
				ClassName:'DHCDoc.Interface.AccessManage',
				MethodName:'SaveAccessProduct',
				dataType:'text',
				ProductJson:JSON.stringify(SaveRows)
			},false);
			if(rtn=='0'){
				$.messager.show({title:"��ʾ",msg:"����ɹ�"});
				PageLogicObj.m_ProductTabDataGrid.datagrid('unselectAll').datagrid('reload');
			}else{
				$.messager.alert('��ʾ','����ʧ��:'+rtn);
       			return false;
       		}
		}
	},{
        text: 'ȡ���༭',
        iconCls: 'icon-redo',
        handler: function() {
            PageLogicObj.m_ProductTabDataGrid.datagrid("unselectAll").datagrid("rejectChanges");
        }
    },{
        text: '��������',
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
		loadMsg: '������..',
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
			$.messager.alert("��ʾ","ҵ�����޸Ŀ��ܻ�Ӱ������ҵ������ʹ�ã�����ϵ��������!");
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
	$("#CompanyLink-dialog").dialog("open").dialog("setTitle","��������-ģ��:"+ModuleDesc);
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
		{field:'CompanyRowid',title:'����id',width:1,hidden:true},
		{field:'CompanyCode',title:'���Ҵ���',width:1,hidden:true},
		{field:'CompanyDesc',title:'��������',width:200},
		//{field:'LinkClass',title:'��Ӧ��̨���ļ�',width:400,editor:{type:'text',options:{}}},
		{field:'ReferenceJS',title:'������JS',width:400,editor:{type:'text',options:{}}},
		{field:'ProductDomain',title:'ҵ����id',width:1,hidden:true},
		{field:'ProductDomainStr',title:'ҵ����',width:200,
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
		{field:'AuthLocStr',title:'��Ȩ����id',width:1,hidden:true},
		{field:'ActiveFlag',title:'�Ƿ�����',align:'center',
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
				if (value=="Y") return "��";
				else  return "��";
			}
		}
    ]];
	var LinkToolBar=[{
        text: '�����������',
        iconCls: 'icon-save',
        handler: function() {
			SaveLinkInfo("Company",PageLogicObj.ModuleRowid);
        }
	},{
        text: '������Ȩ',
        iconCls: 'icon-key',
        handler: function() {
            SaveAuthLocStr(PageLogicObj.m_CompanyLinkTabDataGrid);
        }
    },{
        text: '��չ�趨',
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
		loadMsg: '������..',
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
				$.messager.alert('��ʾ',"����ѡ��ģ��");
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
		$.messager.alert("��ʾ","����ѡ����");
		return false;
	}
	if (!rowData.LinkRowid) {
		$.messager.alert("��ʾ","���ȱ����������");
		return false;
	}
	var LinkRowid=rowData.LinkRowid;
	var AuthLocStr=rowData.AuthLocStr;
	var HospitalId=$HUI.combogrid('#_HospList').getValue();
	websys_showModal({
		url:"dhcdoc.util.tablelist.csp?TableName=CT_Loc&IDList="+AuthLocStr+"&HospDr="+HospitalId+"&DisplayType=Select",
		title:'������Ȩ',
		width:400,height:610,
		closable:false,
		CallBackFunc:function(result){
			websys_showModal("close");
			if ((typeof result==="undefined")||(result===false)){
				return;
			}
			var rtn=tkMakeServerCall("DHCDoc.Interface.AccessManage","UpdateAuthLocStr",LinkRowid,result)
			if (rtn=="0"){
				$.messager.show({title:"��ʾ",msg:"��Ȩ�ɹ�"});
				m_DataGrid.datagrid("reload");
				if (m_DataGrid==PageLogicObj.m_CompanyLinkTabDataGrid) {
					PageLogicObj.m_ModuleLinkTabDataGrid.datagrid("reload");
				}
			}else{
				$.messager.alert('��ʾ',"��Ȩʧ��:"+value+",���Ժ�����")
			}
		}
	})
}

function SaveLinkExt(m_DataGrid){
	var rowData=m_DataGrid.datagrid("getSelected");
	if (!rowData){
		$.messager.alert("��ʾ","����ѡ����");
		return false;
	}
	if (!rowData.LinkRowid) {
		$.messager.alert("��ʾ","���ȱ����������");
		return false;
	}
	PageLogicObj.LinkRowid=rowData.LinkRowid;
	$("#LinkExt-dialog").dialog("open").dialog("setTitle","������չά��(����:"+rowData.CompanyDesc+",ģ��:"+rowData.ModuleDesc+")");
	if (PageLogicObj.m_LinkExtTabDataGrid=="") {
		PageLogicObj.m_LinkExtTabDataGrid=InitLinkExtTabDataGrid();
	}else{
		PageLogicObj.m_LinkExtTabDataGrid.datagrid("reload");
	}
}

function InitLinkExtTabDataGrid(){
	var ExtColumns=[[
		{field:'ExtRowid',title:'��չid',width:1,hidden:true},
		{field:'ExtCode',title:'����',width:150,editor:{type:'text',options:{}}},
		{field:'ExtDesc',title:'����',width:200,
			editor:{
				type:'text',
				options:{}
			},
			formatter: function(value,row,index){
				return '<a href="#" id="'+row["ExtRowid"]+'" class="hisui-tooltip" title="'+value+'" >'+value+'</a>';
			}
		},
		{field:'ExtValue',title:'ֵ',width:150,editor:{type:'text',options:{}}},
		{field:'ExtModuleFlag',title:'ģ�鼶',align:'center',
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
				if (value=="Y") return "��";
				else  return "��";
			}
		}
    ]];
	var ExtToolBar=[{
        text: '����',
        iconCls: 'icon-add',
        handler: function() {
			PageLogicObj.m_LinkExtTabDataGrid.datagrid("insertRow", {
                index: 0,
                row: {}
            });
            PageLogicObj.m_LinkExtTabDataGrid.datagrid("beginEdit", 0);
        }
	},{
		text: 'ɾ��',
		iconCls: 'icon-cancel',
		handler: function() {
			var rowData=PageLogicObj.m_LinkExtTabDataGrid.datagrid("getSelected");
			if (!rowData){
				$.messager.alert("��ʾ", "��ѡ����Ҫɾ��������");
				return false;
			}
			if (rowData.ExtRowid) {
				//ģ�鼶��չ���ݲ�����ɾ��
				if (rowData.ExtModuleFlag=="Y") {
					$.messager.alert("��ʾ", "ģ�鼶��չ���ݲ�����ɾ��");
					return false;
				}
				$.messager.confirm("��ʾ", "ȷ��Ҫɾ����չ�ڵ�:"+rowData.ExtDesc+"��?", function(r) {
	                if (r) {
	                    var rtn=$.cm({
							ClassName:"DHCDoc.Interface.AccessManage", 
							MethodName:"DeleteAccessLinkExt",
							dataType:'text',
							ExtRowid:rowData.ExtRowid
						},false);
				        if(rtn=="0"){
					        $.messager.show({title:"��ʾ",msg:"ɾ���ɹ�"});
							PageLogicObj.m_LinkExtTabDataGrid.datagrid('unselectAll').datagrid('reload');
				        }else{
					       $.messager.alert('��ʾ',"ɾ��ʧ��:"+rtn);
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
		text: '����',
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
					$.messager.alert("��ʾ","����д����");
	            	return false;
				}
				var ExtDesc=editors[1].target.val();
				if (!ExtDesc) {
					$.messager.alert("��ʾ","����д����");
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
				$.messager.popover({msg:"û����Ҫ���������",type:'alert'});
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
				$.messager.show({title:"��ʾ",msg:"����ɹ�"});
				PageLogicObj.m_LinkExtTabDataGrid.datagrid('unselectAll').datagrid('reload');
			}else{
				$.messager.alert('��ʾ','����ʧ��:'+rtn);
       			return false;
       		}
		}
	},{
        text: 'ȡ���༭',
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
		loadMsg: '������..',
		pagination: false,
		idField: "ExtRowid",
		columns: ExtColumns,
		toolbar: ExtToolBar,
		onBeforeLoad: function(queryParams){
			$.extend(queryParams,{
				LinkRowid:PageLogicObj.LinkRowid
			});
			$(this).datagrid("unselectAll");
			//�ֹ������༭,��֪��Ϊɶ,�ٴ�˫��������
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
				$.messager.alert('��ʾ',"���ȱ����������");
		 		return false;
			}
			PageLogicObj.m_LinkExtTabDataGrid.datagrid("beginEdit",rowIndex);
			//ģ�鼶��չ����ֻ������дֵ,�����������޸�
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
		$.messager.alert("��ʾ","����ѡ����");
		return false;
	}
	if (!rowData.BaseRowid) {
		$.messager.alert("��ʾ","���ȱ���������");
		return false;
	}
	PageLogicObj.ProductRowid=rowData.BaseRowid;
	$("#AccessSort-dialog").dialog("open").dialog("setTitle","��������(ҵ����:"+rowData.BaseDesc+")");
	if (PageLogicObj.m_AccessSortTabDataGrid=="") {
		PageLogicObj.m_AccessSortTabDataGrid=InitAccessSortTabDataGrid();
	}else{
		PageLogicObj.m_AccessSortTabDataGrid.datagrid("reload");
	}
}

function InitAccessSortTabDataGrid(){
	var SortColumns=[[
		{field:'LinkRowid',title:'����id',width:1,hidden:true},
		{field:'CompanyDesc',title:'����',width:200},
		{field:'ModuleDesc',title:'ģ��',width:200},
		{field:'ActiveFlag',title:'�Ƿ�����',width:80},
		{field:'SortId',title:'����id',width:1,hidden:true},
		{field:'SortNum',title:'˳���',width:100,editor:{type:'text',options:{}}}
    ]];
	var SortToolBar=[{
		text: '����',
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
				$.messager.popover({msg:"û����Ҫ���������",type:'alert'});
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
				$.messager.show({title:"��ʾ",msg:"����ɹ�"});
				PageLogicObj.m_AccessSortTabDataGrid.datagrid('unselectAll').datagrid('reload');
			}else{
				$.messager.alert('��ʾ','����ʧ��:'+rtn);
       			return false;
       		}
		}
	},{
        text: 'ȡ���༭',
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
		loadMsg: '������..',
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
			//�ֹ������༭,��֪��Ϊɶ,�ٴ�˫��������
			var rows=$(this).datagrid('getRows');
			for(var i=0;i<rows.length;i++) {
				var editors=$(this).datagrid('getEditors',i);
				if(!editors.length) continue;
				$(this).datagrid('endEdit', i);
			}
		},
		onDblClickRow: function(rowIndex, rowData){
			if (PageLogicObj.ProductRowid=="") {
				$.messager.alert('��ʾ',"����ѡ��ҵ����");
		 		return false;
			}
			PageLogicObj.m_AccessSortTabDataGrid.datagrid("beginEdit",rowIndex);
		}
	});
	return AccessSortTabDataGrid;
}