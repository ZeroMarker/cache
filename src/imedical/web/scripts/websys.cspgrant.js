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
	$("#subWin").show().dialog({title:'【'+parentDesc+'】子界面列表',width:600,height:500,modal:true});
	if (renderSubGrid){
		renderSubGrid = false;
		createDatagridEdit({
			key:"pageSub",
			className:"websys.dto.DHCCspGrant",
			title:"",
		activeColName:"TCGActive",
			columns:[[
			//state：是否展开 open,closed//checked：是否选中（用于复选框）
			{field:'TCGDesc',title:'描述',width:150,editor:{type:'text'}},
			{field:'TCGName',title:'CSP名称',width:200,editor:{type:'text'}},
			{field:'TCGParam',title:'请求参数',width:230,editor:{type:'text'}},
			{field:'TCGActive',title:"激活状态",width:60,formatter:function(v){if (v=="0"){ return "禁用"}return "启用"; },editor:{type:'icheckbox',options:{on:'1',off:'0'}}}
			]],
		beforeToolbar:[{
				iconCls: 'icon-search',
				text:'查询',
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
						$.messager.popover({msg:"名称不能为空！",type:'info'});
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
				$('#pageSubGrid').datagrid('acceptChanges'); //前端提交getChanges方法
				$cm(param,defaultCallBack);
			},
			delHandler:function(row){
				var _t = this;
				$.messager.confirm("删除", "确定删除【"+row.TCGName+"】的配置?", function (r) {
					if (r) {
						$.extend(_t.delReq,{"dto.cspGrant.id":row.TCGRowId});
						$cm(_t.delReq,defaultCallBack);
					}
				});
			}
		});
		$('<td><input id="CSPNameDescSub" onkeydown="CSPNameDescSubKeyUp();" placeholder="描述或名称"  style="margin: 0 5px" autocomplete="off" class="textbox"></td>').prependTo(".window .datagrid-toolbar table tr");

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
		title:'安全组授权列表',
		url:$URL+"?ClassName=websys.dto.DHCCspGrant&QueryName=FindGroup",
		toolbar:[{
				iconCls: 'icon-search',
				text:'查询',
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
			{field:'TGroupDesc',title:'描述',width:100},
			{field:'TSelect',title:'授权',width:50,
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
		title:"界面列表",
		activeColName:"TCGActive",
		columns:[[
			//state：是否展开 open,closed//checked：是否选中（用于复选框）
			{field:'TCGDesc',title:'描述',width:150,editor:{type:'text'}},
			{field:'TCGName',title:'CSP名称',width:200,editor:{type:'text'}},
			{field:'TCGParam',title:'请求参数',width:230,editor:{type:'text'}},
			{field:'TCGActive',title:"激活状态",width:60,formatter:function(v){if (v=="0"){ return "禁用"}return "启用"; },editor:{type:'icheckbox',options:{on:'1',off:'0'}}},
			{field:'TCGBtn',title:'操作',width:80,formatter:function(v,r){
				if (r.TCGRowId){
					return '<a href="#" onclick="openSubWin(\''+r.TCGRowId+'\',\''+r.TCGDesc+'\');">维护子界面</a>';	
				}
				return '';
			}}
		]],
		beforeToolbar:[{
				iconCls: 'icon-search',
				text:'查询',
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
					$.messager.popover({msg:"名称不能为空！",type:'info'});
					return ;
				}
				param = $.extend(this.insReq,{"dto.cspGrant.id":""});
			}else{
				param = $.extend(this.updReq,{"dto.cspGrant.id":row.TCGRowId});
			}
			$.extend(param,{"dto.cspGrant.CGDesc":row.TCGDesc,"dto.cspGrant.CGName":row.TCGName,"dto.cspGrant.CGParent":"","dto.cspGrant.CGActive":row.TCGActive,"dto.cspGrant.CGParam":row.TCGParam});
			$('#pageGrid').datagrid('acceptChanges'); //前端提交getChanges方法
			$cm(param,defaultCallBack);
		},
		delHandler:function(row){
			var _t = this;
			$.messager.confirm("删除", "确定删除【"+row.TCGName+"】的配置?", function (r) {
				if (r) {
					$.extend(_t.delReq,{"dto.cspGrant.id":row.TCGRowId});
					$cm(_t.delReq,defaultCallBack);
				}
			});
		}
	});
	$('<td><input style="margin: 0 5px" id="CSPNameDesc" onkeydown="CSPNameDescKeyUp();" placeholder="描述或名称" autocomplete="off" class="textbox"></td>').prependTo(".layout-panel-center .datagrid-toolbar table tr");
	$('<td><label>安全组</label><input  style="margin: 0 5px" id="GroupDesc" onkeydown="GroupDescKeyUp();" placeholder="安全组名称" autocomplete="off" class="textbox"></td>').prependTo('.layout-panel-east .datagrid-toolbar table tr');
	
});