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
	/*$("body").delegate('a',"click",function(){
		var id=$(this).attr("orgid");
		var pid=$(this).attr("pid");
		$.messager.confirm('��ʾ��Ϣ' , 'ȷ��ɾ��?'+id+","+pid , function(r){
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
	});	*/
	var findTableHeight=parseInt($("#PageContent>table").css('height'));
	var theight=500;var twidth=1140;
	if (document.documentElement && document.documentElement.clientHeight && document.documentElement.clientWidth){
		var winHeight = document.documentElement.clientHeight;
		var winWidth = document.documentElement.clientWidth;
		theight=winHeight-findTableHeight-5;
		twidth=winWidth+10;
	}
	$('#tDHCMessageOrgMgr').treegrid({     //treegrid����lazyload�ķ�ʽ��������
		width:twidth,
		height:theight,
		pageSize:10,
		rownumbers: true,
		pagination: true,
		pageList: [10,20],
		queryParams: { desc:Adesc,code:Acode},
		url:'jquery.easyui.querydatatrans.csp?ClassName=websys.DHCMessageOrgMgr&QueryName=Find',		
		idField:'OrgId',				//���ݱ��Ҫ������	
		treeField:'ODesc',			//treegrid ���νṹ���� text
		//fitColumns :true, 
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
						+"<a href='#' onclick='delItem(this);' name='delete' orgid='"+row.OrgId+"' pid='"+row._parentId+"'>ɾ��</a>"
				return str;
			}}
		]],
		onBeforeLoad:function(row, param){
			if(row){
				if(row.OrgId!=undefined){
					param.page=1;
					param.rows=999;
					param.desc=Adesc;
					param.code=Acode;
				}
			}else{
				param.id=0;
			}
			return true;
		},

		onLoadSuccess:function(param){
			//delete $(this).treegrid('options').queryParams['id'];
			/*$('a[name="add"]').click(function(){
				$('#mydialog').dialog({
					title:'����' 
				});
				$('#myform').get(0).reset();
				$('#oid').val("");
				$('#mydialog').dialog('open');
			});*/
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
			//$('a[name="delete"]').click(function(){
					
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
		//$('#tDHCMessageOrgMgr').treegrid('load');
		//$('#test').treegrid({
		//	url:'jquery.easyui.querydatatrans.csp?ClassName=websys.DHCMessageOrgMgr&QueryName=AllLoadFind&desc='+Adesc+'&code='+Acode
		//	
		//});
	});
	$('#Clear').click(function(){
		$('#OrgCode').val("");
		$('#OrgDesc').val("");
		$('#Find').click();
	});	
	
	
	
	$('#Add').click(function(){
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
		
	});
	$('#Add2').click(function(){
		$('#mydialog2').dialog({
			title:'������֯' 
		});
		$('#mydialog2').dialog('open');
	});
	
	

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
		width:450,
		editable:false,
		onSelect:function(){
			$('#oobj').combogrid("clear");
			var otype = $('#otype').combobox('getValue');
			var clsname="",QueryName="",columns=[];
			switch(otype){
				case "H":
					clsname="web.CTHospital";
					QueryName="LookUp";
					columns=[[{field:'Description',title:'ҽԺ',width:215},{field:'Code',title:'Code',align:'right',width:215},{field:'HIDDEN',title:'HIDDEN',align:'right',hidden:true,width:0}]];
					break;
				case "G":				
					clsname="websys.DHCMessageOrgMgr";
					QueryName="LookUpGroup";
					columns=[[{field:'Description',title:'��ȫ��',width:430},{field:'HIDDEN',title:'HIDDEN',align:'right',hidden:true,width:0}]];
					break;	
				case "L":				
					clsname="websys.DHCMessageOrgMgr";
					QueryName="LookUpLoc";
					columns=[[{field:'Description',title:'����',width:215},{field:'Code',title:'Code',align:'right',width:215},{field:'HIDDEN',title:'HIDDEN',align:'right',hidden:true,width:0}]];
					break;	
				case "U":				
					clsname="websys.DHCMessageOrgMgr";
					QueryName="LookUpUser";
					columns=[[{field:'Description',title:'����',width:215},{field:'Code',title:'Code',align:'right',width:215},{field:'HIDDEN',title:'HIDDEN',align:'right',hidden:true,width:0}]];
					break;	
			}
			$('#oobj').combogrid({
				url: 'jquery.easyui.querydatatrans.csp?ClassName='+clsname+'&QueryName='+QueryName+'&desc=""',
				columns:columns
			});			
		}
	});

	$('#oobj').combogrid({
		required:true,
		width:450,
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
		columns: [[{field:'Description',title:'Desc',width:200},{field:'Code',title:'Code',align:'right',width:200},{field:'HIDDEN',title:'HIDDEN',align:'right',hidden:true,width:0}]],
		pagination: true , 
		pageSize: 10 
	});
	$('#oorg').combogrid({
		required:true,
		width:450,
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
		columns: [[{field:'ODesc',title:'Desc',width:215},{field:'OCode',title:'Code',align:'right',width:215},{field:'OrgId',title:'HIDDEN',align:'right',hidden:true,width:0}]],
		pagination: true , 
		pageSize: 10 
	});	
	$('#ok1').click(function(){
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
						$.messager.alert('�ɹ�','�����ɹ�!');
						if(oldpid!=""&&oldpid!=pid){
							$('#tDHCMessageOrgMgr').treegrid('reload' , oldpid);
							oldpid="";
						}
						$('#tDHCMessageOrgMgr').treegrid('reload' , pid);
						$('#mydialog').dialog('close');
					}else{
						$.messager.alert('ʧ��','����ʧ����!');
						$('#mydialog').dialog('close');
						
					}
				}
			);
		}
		
	});
	$('#ok2').click(function(){
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
						$.messager.alert('�ɹ�','�����ɹ�!');
						$('#tDHCMessageOrgMgr').treegrid('reload');
						$('#mydialog2').dialog('close');
					}else{
						$.messager.alert('ʧ��','����ʧ����!');
						$('#mydialog2').dialog('close');
						
					}
				}
			);
		}
		
	});
	
	$('#cancle1').click(function(){        
		$('#mydialog').dialog('close');
		oldpid="";
	});	
	$('#cancle2').click(function(){
		$('#mydialog2').dialog('close');
	});	
	
	$('#mydialog').dialog({
		onClose:function(){
			$('#myform').get(0).reset();
			$('#oid').val("");
		}
	});
	$('#mydialog2').dialog({
		onClose:function(){
			$('#myform2').get(0).reset();
			$('#oid2').val("");
			$('#oorg').combogrid('grid').datagrid('load');
		}
	});	
	
	$('#ocode,#odesc,#onote').css({  
		"width":"450px"
	}) ;
	$('#ocode2,#odesc2,#onote2').css({  
		"width":"200px"
	}) ;	
	//����ȫ���صķ�ʽ����treegrid�����ݣ��޸ĺ����ӵ�reload����Ҫ�޸�
	/*
	$('#test').treegrid({     //treegrid����lazyload�ķ�ʽ��������
		width:1140,
		height:547,
		pageSize:1000,
		pagination: true,
		pageList: [1000],
		//queryParams: { ClassName:"websys.DHCMessageOrgMgr",QueryName:"Find"},
		url:'jquery.easyui.querydatatrans.csp?ClassName=websys.DHCMessageOrgMgr&QueryName=AllLoadFind&desc='+Adesc+'&code='+Acode,		
		idField:'OrgId',				//���ݱ��Ҫ������	
		treeField:'ODesc',			//treegrid ���νṹ���� text
		//fitColumns :true, 
		columns:[[
			{field:'ODesc',title:'��֯����',width:250} ,
			{field:'OCode',title:'��֯����',width:100} ,
			{field:'OrgId',title:'��֯ID',hidden:true} ,
			{field:'ONote',title:'��֯˵��',width:200} ,
			{field:'OObjId',title:'��Աid',hidden:true} ,
			{field:'OObjType',title:'����',width:100,hidden:false,formatter: function(value,row,index){
				var str="������";
				switch(value){
					case "H":
						str="ҽԺweb.CTHospital";
						break;
					case "G":				
						str="��ȫ��web.SSGroup";
						break;
					case "L":				
						str="����web.CTLoc";
						break;
					case "U":				
						str="�û�web.SSUser";
						break;	
				}
				return str;
			}} ,
			{field:'OObjName',title:'��Ա����',width:150} ,
			{field:'_parentId',title:'�ϼ�id',hidden:true} ,
			{field:'crud',title:'����',width:100,formatter: function(value,row,index){
				//"<a href='#' name='add' orgid='"+row.OrgId+"' pid='"+row._parentId+"'>����</a>&nbsp;&nbsp;"+
				var str="<a href='#' name='update' orgid='"+row.OrgId+"' pid='"+row._parentId+"'>�޸�</a>&nbsp;&nbsp;"
						+"<a href='#' name='delete' orgid='"+row.OrgId+"' pid='"+row._parentId+"'>ɾ��</a>"
				return str;
			}}
		]],
		onLoadSuccess:function(param){
			delete $(this).treegrid('options').queryParams['id'];
			$('a[name="update"]').click(function(){
				//alert("����");
				var  node  = $('#test').treegrid('find',$(this).attr("orgid"));
				$('#mydialog').dialog({
					title:'�޸�' 
				});
				$('#myform').get(0).reset();
				$('#oid').val(node.OrgId);
				$('#odesc').val(node.ODesc);
				$('#ocode').val(node.OCode);
				$('#onote').val(node.ONote);
				$('#otype').combobox("setValue",node.OObjType);
				$('#oobj').combogrid("setValue",node.OObjId);
				$('#oobj').combogrid("setText",node.OObjName);	
				$('#oorg').combogrid("setValue",node._parentId);	
				$('#mydialog').dialog('open');
				if($('#otype').combobox("getValue")=="N"){     //�����µ��Ǹ���ʱ������Ϊ�����ͣ�����͸���ֱ�Ӳ��ܱ༭���Լ�����Ҳ���ܱ༭,�ڸ�����ɺ����͸�Ϊ�ɱ༭״̬��
					$("#otype").combobox({ 
						disabled:true
					});
					$('#otype').combobox("setValue","N");
					$('#otype').combobox("setText","������");
					$('#oobj').combogrid({
						disabled:true
					});
					$('#oobj').combogrid("setValue","0");
					$('#oobj').combogrid("setText","�޶���");	
					$('#oorg').combogrid({
						disabled:true
					});
					$('#oorg').combogrid("setValue","0");
					$('#oorg').combogrid("setText","���ϼ�");	
				}
				
			});		
			$('a[name="delete"]').click(function(){
				var id=$(this).attr("orgid");
				var pid=$(this).attr("pid");
				$.messager.confirm('��ʾ��Ϣ' , 'ȷ��ɾ��?' , function(r){
					if(r){
						//return true;
						$.ajaxRunServerMethod({
							ClassName:"websys.DHCMessageOrgMgr",MethodName:"Delete",
							Id:id
							},
							function(data,textStatus){
								if(data>0){
									$.messager.alert('�ɹ�','ɾ���ɹ�!');
									$('#test').treegrid('reload');
									
								}else{
									$.messager.alert('�ɹ�','ɾ��ʧ��!');
								}
							}
						);
					} else {
						return false;
					}
				});				
			});			
		}

	});
	*/
		
});
//{"OrgId":"14","OCode":"������","ODesc":"������","ONote":"����������","OObjId":"600","OObjType":"�û�","OObjName":"������","OOrgDr":"5"}
// $('#cc').combogrid('grid').datagrid('reload'); 