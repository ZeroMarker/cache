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
	$.messager.confirm('��ʾ��Ϣ' , 'ȷ��ɾ��?', function(r){
		if(r){
			//return true;
			$.ajaxRunServerMethod({
				ClassName:"websys.DHCMessageOrgMgr",MethodName:"Delete",
				Id:id
				},
				function(data,textStatus){
					if(data>0){
						$.messager.alert('�ɹ�','ɾ���ɹ�!');
						if(pid==0){
							$('#tDHCMessageOrgMgr').treegrid('reload');
							$('#oorg').combogrid('grid').datagrid('load');
						}else{
							$('#tDHCMessageOrgMgr').treegrid('reload' , pid);
						}
					}else{
						$.messager.alert('�ɹ�','ɾ��ʧ��!');
					}
				}
			);
		} else {
			return false;
		}
	});		
};
$(function(){
	$('#tDHCMessageOrgMgr').treegrid({     //treegrid����lazyload�ķ�ʽ��������
		bodyCls:'panel-body-gray',
		fit:true,
		pageSize:10,
		rownumbers: true,
		pagination: true,
		pageList: [10,20],
		queryParams: { desc:Adesc,code:Acode},
		url:'jquery.easyui.querydatatrans.csp?ClassName=websys.DHCMessageOrgMgr&QueryName=Find',		
		idField:'OrgId',				//���ݱ��Ҫ������	
		treeField:'ODesc',			//treegrid ���νṹ���� text
		toolbar:[{
			iconCls:'icon-add',
			text:'������֯',
			handler:function(){
				addOrg();
			}
		},{
			iconCls:'icon-add',
			text:'���ӳ�Ա',
			handler:function(){
				addMember();
			}
		}],
		columns:[[
			{field:'ODesc',title:'��֯����',width:250} ,
			{field:'OCode',title:'��֯����',width:100} ,
			{field:'OrgId',title:'��֯ID',hidden:true} ,
			{field:'ONote',title:'��֯˵��',width:200} ,
			{field:'OObjId',title:'��Աid',hidden:true} ,
			{field:'OObjType',title:'����',width:100,hidden:false,formatter: function(value,row,index){
				var str="";
				switch(value){
					case "H":
						str="ҽԺ";
						break;
					case "G":				
						str="��ȫ��";
						break;
					case "L":				
						str="����";
						break;
					case "U":				
						str="�û�";
						break;	
				}
				return str;
			}} ,
			{field:'OObjName',title:'��Ա����',width:150} ,
			{field:'_parentId',title:'�ϼ�id',hidden:true} ,
			{field:'crud',title:'����',width:100,formatter: function(value,row,index){
				//"<a href='#' name='add' orgid='"+row.OrgId+"' pid='"+row._parentId+"'>����</a>&nbsp;&nbsp;"+
				var str="<a href='#' name='update' orgid='"+row.OrgId+"' pid='"+row._parentId+"'>�޸�</a>&nbsp;&nbsp;"
					+"<a href='#' onclick='delItem(this);' name='delete' orgid='"+row.OrgId+"' pid='"+row._parentId+"'>ɾ��</a>";
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
				//alert("����");
				var  node  = $('#tDHCMessageOrgMgr').treegrid('find',$(this).attr("orgid"));
				if(node._parentId==""){
					$('#mydialog2').dialog({
						title:'�޸���֯' 
					});
					$('#oid2').val(node.OrgId);
					$('#odesc2').val(node.ODesc);
					$('#ocode2').val(node.OCode);
					$('#onote2').val(node.ONote);	
					$('#mydialog2').dialog('open');					
				}else{
					$('#mydialog').dialog({
						title:'�޸ĳ�Ա' 
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
			if (param===null) { //�����ѯ
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
			title:'������Ա' 
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
			title:'������֯' 
		});
		$('#mydialog2').dialog('open');
	};
	
	

	$("#otype").combobox({ 
		required:true,
		data: [
			{Code:"H",Desc:"ҽԺ"},
			{Code:"G",Desc:"��ȫ��"},
			{Code:"L",Desc:"����"},
			{Code:"U",Desc:"�û�"}
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
					columns=[[{field:'Description',title:'ҽԺ',width:215},{field:'Code',title:'����',width:185},{field:'HIDDEN',title:'HIDDEN',align:'right',hidden:true,width:0}]];
					break;
				case "G":				
					clsname="websys.DHCMessageOrgMgr";
					QueryName="LookUpGroup";
					columns=[[{field:'Description',title:'��ȫ��',width:400},{field:'HIDDEN',title:'HIDDEN',hidden:true,width:0}]];
					break;	
				case "L":				
					clsname="websys.DHCMessageOrgMgr";
					QueryName="LookUpLoc";
					columns=[[{field:'Description',title:'����',width:215},{field:'Code',title:'����',width:185},{field:'HIDDEN',title:'HIDDEN',align:'right',hidden:true,width:0}]];
					break;	
				case "U":				
					clsname="websys.DHCMessageOrgMgr";
					QueryName="LookUpUser";
					columns=[[{field:'Description',title:'����',width:215},{field:'Code',title:'����',width:185},{field:'HIDDEN',title:'HIDDEN',align:'right',hidden:true,width:0}]];
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
		columns: [[{field:'Description',title:'��֯����',width:215},{field:'Code',title:'��֯����',align:'right',width:185},{field:'HIDDEN',title:'HIDDEN',align:'right',hidden:true,width:0}]],
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
				$.messager.alert('ʧ��','��ͨ��ѡ��ķ�ʽѡ��������֯!');
				return false;
			}
			row=$('#oobj').combogrid("grid").datagrid("getSelected");
			if(row&&(row.HIDDEN>0)){
				var ObjId=row.HIDDEN;
			}else{
				$.messager.alert('ʧ��','��ͨ��ѡ��ķ�ʽѡ���Ա����!');
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
						$.messager.popover({msg:'�����ɹ�!',type:'success'});
						if(oldpid!=""&&oldpid!=pid){
							$('#tDHCMessageOrgMgr').treegrid('reload' , oldpid);
							oldpid="";
						}
						clearSearchInputAndVars();
						$('#tDHCMessageOrgMgr').treegrid('reload' , pid);
						$('#mydialog').dialog('close');
					}else{
						$.messager.alert('ʧ��','����ʧ����!','error');
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
						$.messager.popover({msg:'����ɹ�',type:'success'});
						$('#Clear').click();
						$('#mydialog2').dialog('close');
					}else{
						$.messager.alert('ʧ��','����ʧ����!','error');
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
			text:'����',
			handler:function(){
				saveMember();
			}
		},{
			text:'�ر�',
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
			text:'����',
			handler:function(){
				saveOrg();
			}
		},{
			text:'�ر�',
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
