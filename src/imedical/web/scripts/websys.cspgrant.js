/*websys.cspgrant.js*/
var renderSubGrid=true;
var currOnclickParentId = 0;
function FindByGroupDesc(){
	var GroupDesc = $("#GroupDesc").val();
	$("#groupGrid").trigger("load",{GroupDesc:GroupDesc});
}
function GroupDescKeyUp(){
	if (window.event.keyCode==13){
		FindByGroupDesc();
	};
}
function CSPNameDescKeyUp(){
	if (window.event.keyCode==13){
		FindByCSPNameDesc();
	};
}
function FindByCSPNameDesc(){
	$("#pageGrid").datagrid("load");
}

function CSPNameDescSubKeyUp(){
	if (window.event.keyCode==13){
		FindByCSPNameDescSub();
	};
}
function FindByCSPNameDescSub(){
	$("#pageSubGrid").datagrid("load");
}
function openSubWin(parentId,parentDesc){
	currOnclickParentId = parentId;
	$("#subWin").show().dialog({title:'��'+parentDesc+'���ӽ����б�',width:600,height:500,modal:true});
	if (renderSubGrid){
		renderSubGrid = false;
		createDatagridEdit({
			key:"pageSub",
			className:"websys.dto.DHCCspGrant",
			title:"",
		activeColName:"TCGActive",
			columns:[[
			//state���Ƿ�չ�� open,closed//checked���Ƿ�ѡ�У����ڸ�ѡ��
			{field:'TCGDesc',title:'����',width:150,editor:{type:'text'}},
			{field:'TCGName',title:'CSP����',width:200,editor:{type:'text'}},
			{field:'TCGParam',title:'�������',width:230,editor:{type:'text'}},
			{field:'TCGActive',title:"����״̬",width:60,formatter:function(v){if (v=="0"){ return "����"}return "����"; },editor:{type:'icheckbox',options:{on:'1',off:'0'}}}
			]],
		beforeToolbar:[{
				iconCls: 'icon-search',
				text:'��ѯ',
				handler:FindByCSPNameDescSub
			},'-'],
			onBeforeLoad:function(param){
				//var selectedParentId = $("#pageGrid").datagrid("getSelected");
				//if(selectedParentId){ selectedParentId.TCGRowId
				var CSPNameDesc = $("#CSPNameDescSub").val();
				if (currOnclickParentId>0){
					$.extend(param,{CGName:CSPNameDesc, CGDesc:"",ParentId:currOnclickParentId});
				}
			},
			onLoadSuccess:function(data){
				if (data && data.rows && data.rows.length>0){
					$(this).datagrid("selectRow",0);
				}
			},
			getNewRecord:function(){
				var selectedParentId = $("#pageGrid").datagrid("getSelected");
				if (selectedParentId){
					return {TCGRowId:"",TCGDesc:"",TCGName:"",TCGParent:selectedParentId.TCGRowId,TCGActive:1,TCGParam:""};
				}
			},
			insOrUpdHandler:function(row){
				var param ;
				if (row.TCGRowId==""){
					if (!row.TCGName){
						$.messager.popover({msg:"���Ʋ���Ϊ�գ�",type:'info'});
						return ;
					}
					param = $.extend(this.insReq,{"dto.cspGrant.id":""});
				}else{
					param = $.extend(this.updReq,{"dto.cspGrant.id":row.TCGRowId});
				}
				$.extend(param,{
					"dto.cspGrant.CGDesc":row.TCGDesc,
					"dto.cspGrant.CGName":row.TCGName,
					"dto.cspGrant.CGParent":row.TCGParent,
					"dto.cspGrant.CGActive":row.TCGActive,
					"dto.cspGrant.CGParam":row.TCGParam
				});
				$('#pageSubGrid').datagrid('acceptChanges'); //ǰ���ύgetChanges����
				$cm(param,defaultCallBack);
			},
			delHandler:function(row){
				var _t = this;
				$.messager.confirm("ɾ��", "ȷ��ɾ����"+row.TCGName+"��������?", function (r) {
					if (r) {
						$.extend(_t.delReq,{"dto.cspGrant.id":row.TCGRowId});
						$cm(_t.delReq,defaultCallBack);
					}
				});
			}
		});
		$('<td><input id="CSPNameDescSub" onkeydown="CSPNameDescSubKeyUp();" placeholder="����������"  style="margin: 0 5px" autocomplete="off" class="textbox"></td>').prependTo(".window .datagrid-toolbar table tr");

	}else{
		$("#pageSubGrid").datagrid("load");
	}
}
$(function(){
	$("#groupGrid").on("load",function(event,row){
		$("#GroupDesc").val(row.GroupDesc||"");
		var n = {};
		var p = $(this).datagrid("options").queryParams;
		$.extend(n,p,row)
		$(this).datagrid('load',n);
	}).datagrid({
		headerCls:'panel-header-gray',bodyCls:'panel-body-gray',
		rownumbers:true,singleSelect:true,pagination:true,showPageList:false,pageSize:50,
		fitColumns:true,fit:true,border:true,
		iconCls:'icon-lock',
		title:'��ȫ����Ȩ�б�',
		url:$URL+"?ClassName=websys.dto.DHCCspGrant&QueryName=FindGroup",
		toolbar:[{
				iconCls: 'icon-search',
				text:'��ѯ',
				handler:FindByGroupDesc
			}],
		onBeforeLoad:function(q){		
			if (!q.TCGRowId) return false;
		},
		onClickCell:function(rowIndex,field,value){
			if (event.target.tagName=='INPUT'){
				var rowData = $(this).datagrid('getRows');
				var row = rowData[rowIndex];
				var qp = $(this).datagrid("options").queryParams;
				if (qp && qp['TCGRowId']){
					var param = {ClassName:"websys.dto.DHCCspGrant",MethodName:"DelGroup",
						"dto.cspGrant.id":qp['TCGRowId'],"dto.GroupDr":row.TGroupDr};
					if (event.target.checked){
						$.extend(param,{MethodName:"InsertGroup"});
					}
					$cm(param,defaultCallBack);
				}
			}
		},
		columns:[[
			{field:'TGroupDesc',title:'����',width:100},
			{field:'TSelect',title:'��Ȩ',width:50,
				formatter:function(v,row){
					if (v==1){
						return '<input type="checkbox" checked>';
					}else{
						return '<input type="checkbox">';
					}
				}
			}
		]]
	});
	createDatagridEdit({
		key:"page",
		className:"websys.dto.DHCCspGrant",
		title:"�����б�",
		activeColName:"TCGActive",
		columns:[[
			//state���Ƿ�չ�� open,closed//checked���Ƿ�ѡ�У����ڸ�ѡ��
			{field:'TCGDesc',title:'����',width:150,editor:{type:'text'}},
			{field:'TCGName',title:'CSP����',width:200,editor:{type:'text'}},
			{field:'TCGParam',title:'�������',width:230,editor:{type:'text'}},
			{field:'TCGActive',title:"����״̬",width:60,formatter:function(v){if (v=="0"){ return "����"}return "����"; },editor:{type:'icheckbox',options:{on:'1',off:'0'}}},
			{field:'TCGBtn',title:'����',width:80,formatter:function(v,r){
				if (r.TCGRowId){
					return '<a href="#" onclick="openSubWin(\''+r.TCGRowId+'\',\''+r.TCGDesc+'\');">ά���ӽ���</a>';	
				}
				return '';
			}}
		]],
		beforeToolbar:[{
				iconCls: 'icon-search',
				text:'��ѯ',
				handler:FindByCSPNameDesc
			},'-'],
		onBeforeLoad:function(q){
			var CSPNameDesc = $("#CSPNameDesc").val();
			q.CGName = CSPNameDesc;
		},
		onClickRow:function(rowIndex,rowData){
			$("#groupGrid").trigger("load",rowData);
		},
		onLoadSuccess:function(data){
			if (data && data.rows && data.rows.length>0){
				$(this).datagrid("selectRow",0);
				$("#groupGrid").trigger("load",$(this).datagrid("getRows")[0]);
			}
		},
		getNewRecord:function(){
			return {TCGRowId:"",TCGDesc:"",TCGName:"",TCGParent:"",TCGActive:1,TCGParam:""};
		},
		insOrUpdHandler:function(row){
			var param ;
			if (row.TCGRowId==""){
				if (!row.TCGName){
					$.messager.popover({msg:"���Ʋ���Ϊ�գ�",type:'info'});
					return ;
				}
				param = $.extend(this.insReq,{"dto.cspGrant.id":""});
			}else{
				param = $.extend(this.updReq,{"dto.cspGrant.id":row.TCGRowId});
			}
			$.extend(param,{"dto.cspGrant.CGDesc":row.TCGDesc,"dto.cspGrant.CGName":row.TCGName,"dto.cspGrant.CGParent":"","dto.cspGrant.CGActive":row.TCGActive,"dto.cspGrant.CGParam":row.TCGParam});
			$('#pageGrid').datagrid('acceptChanges'); //ǰ���ύgetChanges����
			$cm(param,defaultCallBack);
		},
		delHandler:function(row){
			var _t = this;
			$.messager.confirm("ɾ��", "ȷ��ɾ����"+row.TCGName+"��������?", function (r) {
				if (r) {
					$.extend(_t.delReq,{"dto.cspGrant.id":row.TCGRowId});
					$cm(_t.delReq,defaultCallBack);
				}
			});
		}
	});
	$('<td><input style="margin: 0 5px" id="CSPNameDesc" onkeydown="CSPNameDescKeyUp();" placeholder="����������" autocomplete="off" class="textbox"></td>').prependTo(".layout-panel-center .datagrid-toolbar table tr");
	$('<td><label>��ȫ��</label><input  style="margin: 0 5px" id="GroupDesc" onkeydown="GroupDescKeyUp();" placeholder="��ȫ������" autocomplete="off" class="textbox"></td>').prependTo('.layout-panel-east .datagrid-toolbar table tr');
	
});