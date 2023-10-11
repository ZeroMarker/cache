;(function ($) {
	$.fn.combogrid.methods.setRemoteValue=function (jq,param) {
    	return jq.each(function(){
	    	if (typeof param=="string"){
		    	$(this).combogrid('setValue',param);
		    }else{
			    var val=param['value']||'';
			    var text=param['text']||'';
			    $(this).combogrid('options').keyHandler.query.call(this,text);
				$(this).combogrid('setValue',val).combogrid('setText',text);
			}
	    });
    };
})(jQuery);

var Acode="",Adesc="",oldpid="";
var delItem = function(that){
	var id=$(that).attr("orgid");
	var pid=$(that).attr("pid");
	$.messager.confirm('提示信息' , '确认删除?', function(r){
		if(r){
			//return true;
			$.ajaxRunServerMethod({
				ClassName:"websys.DHCMessageOrgMgr",MethodName:"Delete",
				Id:id
				},
				function(data,textStatus){
					if(data>0){
						$.messager.alert('成功','删除成功!');
						if(pid==0){
							$('#tDHCMessageOrgMgr').treegrid('reload');
							$('#oorg').combogrid('grid').datagrid('load');
						}else{
							$('#tDHCMessageOrgMgr').treegrid('reload' , pid);
						}
					}else{
						$.messager.alert('成功','删除失败!');
					}
				}
			);
		} else {
			return false;
		}
	});		
};
$(function(){
	$('#tDHCMessageOrgMgr').treegrid({     //treegrid采用lazyload的方式加载数据
		bodyCls:'panel-body-gray',
		fit:true,
		pageSize:10,
		rownumbers: true,
		pagination: true,
		pageList: [10,20],
		queryParams: { desc:Adesc,code:Acode},
		url:'jquery.easyui.querydatatrans.csp?ClassName=websys.DHCMessageOrgMgr&QueryName=Find',		
		idField:'OrgId',				//数据表格要有主键	
		treeField:'ODesc',			//treegrid 树形结构主键 text
		toolbar:[{
			iconCls:'icon-add',
			text:'增加组织',
			handler:function(){
				addOrg();
			}
		},{
			iconCls:'icon-add',
			text:'增加成员',
			handler:function(){
				addMember();
			}
		}],
		columns:[[
			{field:'ODesc',title:'组织描述',width:250} ,
			{field:'OCode',title:'组织代码',width:100} ,
			{field:'OrgId',title:'组织ID',hidden:true} ,
			{field:'ONote',title:'组织说明',width:200} ,
			{field:'OObjId',title:'成员id',hidden:true} ,
			{field:'OObjType',title:'类型',width:100,hidden:false,formatter: function(value,row,index){
				var str="";
				switch(value){
					case "H":
						str="医院";
						break;
					case "G":				
						str="安全组";
						break;
					case "L":				
						str="科室";
						break;
					case "U":				
						str="用户";
						break;	
				}
				return str;
			}} ,
			{field:'OObjName',title:'成员对象',width:150} ,
			{field:'_parentId',title:'上级id',hidden:true} ,
			{field:'crud',title:'操作',width:100,formatter: function(value,row,index){
				//"<a href='#' name='add' orgid='"+row.OrgId+"' pid='"+row._parentId+"'>增加</a>&nbsp;&nbsp;"+
				var str="<a href='#' name='update' orgid='"+row.OrgId+"' pid='"+row._parentId+"'>修改</a>&nbsp;&nbsp;"
					+"<a href='#' onclick='delItem(this);' name='delete' orgid='"+row.OrgId+"' pid='"+row._parentId+"'>删除</a>";
				return str;
			}}
		]],
		onBeforeLoad:function(row, param){
			if(row){
				if(row.OrgId!=undefined ){
					param.page=1;
					param.rows=999;
					if (row.OnlyChildMatch==1) {
						param.desc=Adesc;
						param.code=Acode;
					}else{
						param.desc='';
						param.code='';
					}

				}
			}else{
				param.id=0;
			}
			return true;
		},

		onLoadSuccess:function(param){
			
			$('a[name="update"]').click(function(){
				//alert("更新");
				var  node  = $('#tDHCMessageOrgMgr').treegrid('find',$(this).attr("orgid"));
				if(node._parentId==""){
					$('#mydialog2').dialog({
						title:'修改组织' 
					});
					$('#oid2').val(node.OrgId);
					$('#odesc2').val(node.ODesc);
					$('#ocode2').val(node.OCode);
					$('#onote2').val(node.ONote);	
					$('#mydialog2').dialog('open');					
				}else{
					$('#mydialog').dialog({
						title:'修改成员' 
					});
					$('#oid').val(node.OrgId);
					$('#odesc').val(node.ODesc);
					$('#ocode').val(node.OCode);
					$('#onote').val(node.ONote);
					//$('#otype').combobox("setValue",node.OObjType);
					$('#otype').combobox("select",node.OObjType);
					
					$('#oobj').combogrid("grid").datagrid("load",{desc:node.OObjName});
					$('#oobj').combogrid("setValue",node.OObjId);
					$('#oobj').combogrid("setText",node.OObjName);	
					
					var porgdesc=$('#tDHCMessageOrgMgr').treegrid('find',node._parentId).ODesc;
					$('#oorg').combogrid("grid").datagrid("load",{ClassName:'websys.DHCMessageOrgMgr',QueryName: 'Find',desc:porgdesc});
					$('#oorg').combogrid("setText",porgdesc);	
					$('#oorg').combogrid("setValue",node._parentId);
					$('#mydialog').dialog('open');		
					oldpid=node._parentId;				
				}

			});		
			if (param===null) { //点击查询
				$('#tDHCMessageOrgMgr').treegrid('clearSelections');
			}
			
		}
	});
	$('#Find').click(function(){
		Acode=$('#OrgCode').val();
		Adesc=$('#OrgDesc').val();
		$('#tDHCMessageOrgMgr').treegrid({
			pageNumber:1,
			queryParams: { desc:Adesc,code:Acode},
			url:'jquery.easyui.querydatatrans.csp?ClassName=websys.DHCMessageOrgMgr&QueryName=Find'
			
		});
	});
	$('#Clear').click(function(){
		$('#OrgCode').val("");
		$('#OrgDesc').val("");
		$('#tDHCMessageOrgMgr').treegrid('clearSelections');
		$('#Find').click();
	});	
	
	var clearSearchInputAndVars=function(){
		$('#OrgCode').val("");
		$('#OrgDesc').val("");
		Acode='';
		Adesc='';
	}
	
	
	var addMember=function(){
		$('#mydialog').dialog({
			title:'新增成员' 
		});
		
		var SelectNode=$('#tDHCMessageOrgMgr').treegrid('getSelected');
		if(SelectNode==null){
			
			$('#oorg').combogrid("setValue","");
			//$('#oorg').combogrid("setText","");
			//alert("****");
		}else{
			//alert(SelectNode.ODesc);
			if(SelectNode._parentId==""){
				$('#oorg').combogrid("setValue",SelectNode.OrgId);
				$('#oorg').combogrid("setText",SelectNode.ODesc);
			}else{
				$('#oorg').combogrid("setValue",SelectNode._parentId);
				$('#oorg').combogrid("setText",$('#tDHCMessageOrgMgr').treegrid('find',SelectNode._parentId).ODesc);
			}
		}
		$('#mydialog').dialog('open');
		
	};
	var addOrg=function(){
		$('#mydialog2').dialog({
			title:'新增组织' 
		});
		$('#mydialog2').dialog('open');
	};
	
	

	$("#otype").combobox({ 
		required:true,
		data: [
			{Code:"H",Desc:"医院"},
			{Code:"G",Desc:"安全组"},
			{Code:"L",Desc:"科室"},
			{Code:"U",Desc:"用户"}
		], 
		valueField:'Code', 
		textField:"Desc",
		width:300,
		editable:false,
		onSelect:function(){
			$('#oobj').combogrid("clear");
			var otype = $('#otype').combobox('getValue');
			var clsname="",QueryName="",columns=[];
			switch(otype){
				case "H":
					clsname="web.CTHospital";
					QueryName="LookUp";
					columns=[[{field:'Description',title:'医院',width:215},{field:'Code',title:'代码',width:185},{field:'HIDDEN',title:'HIDDEN',align:'right',hidden:true,width:0}]];
					break;
				case "G":				
					clsname="websys.DHCMessageOrgMgr";
					QueryName="LookUpGroup";
					columns=[[{field:'Description',title:'安全组',width:400},{field:'HIDDEN',title:'HIDDEN',hidden:true,width:0}]];
					break;	
				case "L":				
					clsname="websys.DHCMessageOrgMgr";
					QueryName="LookUpLoc";
					columns=[[{field:'Description',title:'科室',width:215},{field:'Code',title:'代码',width:185},{field:'HIDDEN',title:'HIDDEN',align:'right',hidden:true,width:0}]];
					break;	
				case "U":				
					clsname="websys.DHCMessageOrgMgr";
					QueryName="LookUpUser";
					columns=[[{field:'Description',title:'姓名',width:215},{field:'Code',title:'代码',width:185},{field:'HIDDEN',title:'HIDDEN',align:'right',hidden:true,width:0}]];
					break;	
			}
			$('#oobj').combogrid({
				url: 'jquery.easyui.querydatatrans.csp?ClassName='+clsname+'&QueryName='+QueryName+'&desc=',
				columns:columns
				
			});	
			//$('#oobj').combogrid('setRemoteValue',{text:'',value:''});
			
		}
	});

	$('#oobj').combogrid({
		required:true,
		rownumbers:true,
		width:300,
		disabled:false,		
		delay: 500,
		panelWidth:450,
		panelHeight:340,
		mode: 'remote',
		//url: 'jquery.easyui.querydatatrans.csp?ClassName=web.SSUser&QueryName=LookUp&desc=',
		idField: 'HIDDEN',
		textField: 'Description',
		onBeforeLoad:function(param){
			param = $.extend(param,{desc:param.q});
			return true;
		},
		columns: [[{field:'Description',title:'组织名称',width:215},{field:'Code',title:'组织代码',align:'right',width:185},{field:'HIDDEN',title:'HIDDEN',align:'right',hidden:true,width:0}]],
		pagination: true , 
		pageSize: 10 
	});
	$('#oorg').combogrid({
		required:true,
		width:300,
		disabled:false,		
		delay: 500,
		panelWidth:450,
		panelHeight:340,
		mode: 'remote',
		queryParams:{ClassName:'websys.DHCMessageOrgMgr',QueryName: 'Find',desc:""},
		url: 'jquery.easyui.querydatatrans.csp',
		idField: 'OrgId',
		textField: 'ODesc',
		onBeforeLoad:function(param){
			param = $.extend(param,{desc:param.q});
			return true;
		},
		columns: [[{field:'ODesc',title:'Desc',width:215},{field:'OCode',title:'Code',width:185},{field:'OrgId',title:'HIDDEN',align:'right',hidden:true,width:0}]],
		pagination: true , 
		pageSize: 10 
	});	
	$('#ocode,#odesc,#onote').outerWidth(300);
	var saveMember=function(){
		if($('#myform').form('validate')){
			//var pid=$('#oorg').combogrid("getValue");
			var row=$('#oorg').combogrid("grid").datagrid("getSelected");
			if(row&&(row.OrgId>0)){
				var pid=row.OrgId;
			}else{
				$.messager.alert('失败','请通过选择的方式选择所属组织!');
				return false;
			}
			row=$('#oobj').combogrid("grid").datagrid("getSelected");
			if(row&&(row.HIDDEN>0)){
				var ObjId=row.HIDDEN;
			}else{
				$.messager.alert('失败','请通过选择的方式选择成员对象!');
				return false;
			}
			$.ajaxRunServerMethod({
				ClassName:"websys.DHCMessageOrgMgr",MethodName:"Save",
				Id:$('#oid').val(), 
				Code:$('#ocode').val(), 
				Desc:$('#odesc').val(), 
				Note:$('#onote').val(), 
				ObjType:$('#otype').combobox("getValue"), 
				ObjId:ObjId, 
				OrgDr:pid
				},
				function(data,textStatus){
					if(data>0){
						$.messager.popover({msg:'操作成功!',type:'success'});
						if(oldpid!=""&&oldpid!=pid){
							$('#tDHCMessageOrgMgr').treegrid('reload' , oldpid);
							oldpid="";
						}
						clearSearchInputAndVars();
						$('#tDHCMessageOrgMgr').treegrid('reload' , pid);
						$('#mydialog').dialog('close');
					}else{
						$.messager.alert('失败','操作失败了!','error');
						$('#mydialog').dialog('close');
						
					}
				}
			);
		}
		
	};
	var saveOrg=function(){
		if($('#myform2').form('validate')){
			$.ajaxRunServerMethod({
				ClassName:"websys.DHCMessageOrgMgr",MethodName:"Save",
				Id:$('#oid2').val(), 
				Code:$('#ocode2').val(), 
				Desc:$('#odesc2').val(), 
				Note:$('#onote2').val(), 
				ObjType:"N",
				ObjId:"0",
				OrgDr:"0"
				},
				function(data,textStatus){
					if(data>0){
						$.messager.popover({msg:'保存成功',type:'success'});
						$('#Clear').click();
						$('#mydialog2').dialog('close');
					}else{
						$.messager.alert('失败','操作失败了!','error');
						$('#mydialog2').dialog('close');
						
					}
				}
			);
		}
		
	};
	
	var closeMember=function(){        
		$('#mydialog').dialog('close');
		oldpid="";
	};	
	var closeOrg=function(){
		$('#mydialog2').dialog('close');
	};	
	
	$('#mydialog').dialog({
		buttons:[{
			text:'保存',
			handler:function(){
				saveMember();
			}
		},{
			text:'关闭',
			handler:function(){
				closeMember();
			}
		}],
		iconCls:'icon-w-paper',
		onClose:function(){
			$('#myform').get(0).reset();
			$('#oid').val("");
			$('#otype').combobox("setValue",'');
			$('#oobj').combogrid('setRemoteValue',{text:'',value:''});
			$('#oorg').combogrid('setRemoteValue',{text:'',value:''});
		},
		onOpen:function(){
			$('#myform').form('validate')	;
		}
	});
	$('#mydialog2').dialog({
		buttons:[{
			text:'保存',
			handler:function(){
				saveOrg();
			}
		},{
			text:'关闭',
			handler:function(){
				closeOrg();
			}
		}],
		iconCls:'icon-w-paper',
		onClose:function(){
			$('#myform2').get(0).reset();
			$('#oid2').val("");
			$('#oorg').combogrid('grid').datagrid('load');
		},
		onOpen:function(){
			$('#myform2').form('validate')	;
		}
	});	
		
});
