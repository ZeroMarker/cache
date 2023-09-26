/**
 * ģ��:		ҩ��
 * ��ģ��:		ҩƷ��Ϣά��(�ּ�),�༭�����¼�
 * createdate:	2017-06-21
 * creator:		yunhaibao
 * description: ��ɾ��İ�ť������ķ���
 */
 
/// ҩѧ����
function PhcCatEdit(btnId){
	var title="ҩѧ����";
	var modifyType=DHCSTEASYUI.GetModifyType(btnId);
	var treeSelected=$('#phcCatTreeGrid').treegrid('getSelected');
	var phcCatRowId="";
	if (treeSelected){
		phcCatRowId=treeSelected.phcCatRowId;
	}
	if (modifyType=="A"){
		title=title+"����";
		if (phcCatRowId==""){
			$.messager.confirm('ȷ����ʾ',"δѡ��ҩѧ����,�����1��ҩѧ����?",function(r){
				if (r){
					var urlParams="dhcst.easyui.phccat.modify.csp?"+"actionType="+modifyType+"&"+"phcCatRowId="+phcCatRowId;
					var editOptions={
						title:title,
						width:400,
						height:160,
						src:urlParams
					}
					DrugMainTainEditShow(editOptions);
				}
			    return;
			});
		}
		else{
			var urlParams="dhcst.easyui.phccat.modify.csp?"+"actionType="+modifyType+"&"+"phcCatRowId="+phcCatRowId;
			var editOptions={
				title:title,
				width:400,
				height:160,
				src:urlParams
			}
			DrugMainTainEditShow(editOptions)

		}
	}else if (modifyType=="U"){
		title=title+"�޸�";
		if (!treeSelected){
			$.messager.alert("��ʾ","��ѡ����Ҫ�޸ĵ�ҩѧ����!",'warning');
			return;
		}
		var urlParams="dhcst.easyui.phccat.modify.csp?"+"actionType="+modifyType+"&"+"phcCatRowId="+phcCatRowId;
			var editOptions={
				title:title,
				width:400,
				height:160,
				src:urlParams
			}
			DrugMainTainEditShow(editOptions)
	}else if (modifyType=="D"){
		if (!treeSelected){
			$.messager.alert('��ʾ','��ѡ����Ҫɾ����ҩѧ����!','warning');
			return;
		}
		var delRet=tkMakeServerCall("web.DHCST.PHCCATMAINTAIN","Delete",phcCatRowId)
		if(delRet==0){
			$.messager.alert("�ɹ���ʾ","ɾ���ɹ�!",'info');
			ReloadPhcCatTreeById(phcCatRowId);
			$('#phcCatTreeGrid').treegrid('remove', phcCatRowId);
		}else{
			var delRet=delRet.split("^");
			$.messager.alert("������ʾ",delRet[1],'error');
		}
		return;
	}
	
}

/// ��ѧͨ����
function PhcChemicalEdit(btnId){
	var title="��ѧͨ����";
	var modifyType=DHCSTEASYUI.GetModifyType(btnId);
	var treeSelected=$('#phcCatTreeGrid').treegrid('getSelected');
	var dataSelected=$('#phcChemicalGrid').datagrid('getSelected');
	var phcCatRowId="",phcChemicalId="";
	if (treeSelected){
		phcCatRowId=treeSelected.phcCatRowId;
	}
	if (dataSelected){
		phcChemicalId=dataSelected.chemicalId;
	}
	if (modifyType=="A"){
		phcChemicalId="";
		title=title+"����";
		if (phcCatRowId==""){
			$.messager.confirm('ȷ����ʾ', 'û��ѡ��ҩѧ����,���������ֵ��¼,�޷����й���!</br>�Ƿ����?', function(r){
				if (r){
					var urlParams="dhcst.easyui.phcchemical.modify.csp?"+"actionType="+modifyType+"&phcCatRowId="+phcCatRowId+"&phcChemicalId="+"";
					var editOptions={
						title:title,
						width:400,
						height:160,
						src:urlParams
					}
					DrugMainTainEditShow(editOptions);
				}
			});
			return;
		}
	}else if (modifyType=="U"){
		title=title+"�޸�";
		if (phcChemicalId==""){
			$.messager.alert("��ʾ","��ѡ����Ҫ�޸ĵĻ�ѧͨ����!",'warning');
			return;
		}
		phcCatRowId=dataSelected.phcCatId;
	}else if (modifyType=="L"){	
		if (phcChemicalId==""){
			$.messager.alert("��ʾ","��ѡ����Ҫ�����Ļ�ѧͨ����!",'warning');
			return;
		}
		if (phcCatRowId==""){
			$.messager.alert("��ʾ","��ѡ����Ҫ������ҩѧ����!",'warning');
			return;
		}
		$.messager.confirm('����ҩѧ����', '�Ƿ���� '+treeSelected.phcCatDesc+'?', function(r){
			if (r){
				var linkRet=tkMakeServerCall("web.DHCST.DrugLink","ChemicalLinkPhcCat",phcCatRowId,phcChemicalId);
				if(linkRet>0){
					$.messager.alert("�ɹ���ʾ","�����ɹ�!",'info');
					QueryPHCChemicalGrid();
				}else{
					var linkArr=linkRet.split("^");
					$.messager.alert("������ʾ",linkRet[1],'error');
				}	
				return;
			}
		});
		return;	
	}
	if (modifyType=="D"){
		if (phcChemicalId==""){
			$.messager.alert("��ʾ","��ѡ����Ҫɾ���Ļ�ѧͨ����!","warning");
			return;
		}
		var delRet=tkMakeServerCall("web.DHCST.PHCChemical","Delete",phcChemicalId)
		if(delRet==0){
			$.messager.alert("�ɹ���ʾ","ɾ���ɹ�!","info");
			QueryPHCChemicalGrid();
		}else{
			var delRet=delRet.split("^");
			$.messager.alert("������ʾ",delRet[1],"error");
		}
		return;
	}
	var urlParams="dhcst.easyui.phcchemical.modify.csp?"+"actionType="+modifyType+"&phcCatRowId="+phcCatRowId+"&phcChemicalId="+phcChemicalId;
	var editOptions={
		title:title,
		width:400,
		height:160,
		src:urlParams
	}
	DrugMainTainEditShow(editOptions);
}

/// ����ͨ����
function PhcGenericEdit(btnId){
	var title="����ͨ����";
	var modifyType=DHCSTEASYUI.GetModifyType(btnId);
	var chemicalSelected=$('#phcChemicalGrid').datagrid('getSelected');
	var genericSelected=$('#phcGenericGrid').datagrid('getSelected');
	var phcGenericId="",phcChemicalId="";
	if (genericSelected){
		phcGenericId=genericSelected.genericId;
	}
	if (chemicalSelected){
		phcChemicalId=chemicalSelected.chemicalId;
	}
	if (modifyType=="A"){
		title=title+"����";		
		var urlParams="dhcst.easyui.phcgeneric.modify.csp?"+"actionType="+modifyType+"&phcChemicalId="+phcChemicalId+"&phcGenericId="+"";
		var editOptions={
			title:title,
			width:350,
			height:430,
			src:urlParams
		}
		DrugMainTainEditShow(editOptions);
		return;
		
	}else if (modifyType=="U"){
		title=title+"�޸�";
		if (phcGenericId==""){
			$.messager.alert("��ʾ","��ѡ����Ҫ�޸ĵĴ���ͨ����!","warning");
			return;
		}
		phcChemicalId=genericSelected.chemicalId;
	}else if (modifyType=="L"){	
		if (phcGenericId==""){
			$.messager.alert("��ʾ","��ѡ����Ҫ�����Ĵ���ͨ��������!","warning");
			return;
		}
		$('#linkWin').window('open');
		$('#linkWin').panel({title:'��ѧͨ����'});
		var chemicalId=genericSelected.chemicalId||"";
		var LoadTimes=0;
		var tmpOptions={
			ClassName:"web.DHCST.Util.DrugUtilQuery",
			QueryName:"GetChemical",
			StrParams:"|@|"+chemicalId,
	    	columns: [[
				{field:'RowId',title:'RowId',width:100,sortable:true,hidden:true},
				{field:'Description',title:'��ѧͨ��������',width:200,sortable:true}
		    ]],
			idField:'RowId',
			textField:'Description',
			mode:"remote",
			pageSize:30, 
			pageList:[30,50,100],  
			pagination:true,
			onLoadSuccess:function(data) {
				LoadTimes=LoadTimes+1;
				if (LoadTimes==1){
					if (chemicalId!=""){
						$("#cmbLinkDict").combogrid("setValue",chemicalId);
					}else{
						$("#cmbLinkDict").combogrid("clear");
					}
				}
			}	
	    };
		$("#cmbLinkDict").dhcstcombogrideu(tmpOptions);
		return;
	}
	if (modifyType=="D"){
		if (phcGenericId==""){
			$.messager.alert("��ʾ","��ѡ����Ҫɾ���Ĵ���ͨ����!","warning");
			return;
		}
		var delRet=tkMakeServerCall("web.DHCST.PHCGeneric","Delete",phcGenericId)
		if(delRet==0){
			$.messager.alert("�ɹ���ʾ","ɾ���ɹ�!","info");
			QueryPHCGenericGrid();
		}else{
			var delRet=delRet.split("^");
			$.messager.alert("������ʾ",delRet[1],"error");
		}
		return;
	}
	var urlParams="dhcst.easyui.phcgeneric.modify.csp?"+"actionType="+modifyType+"&phcChemicalId="+phcChemicalId+"&phcGenericId="+phcGenericId;
	var editOptions={
		title:title,
		width:350,
		height:430,
		src:urlParams
	}
	DrugMainTainEditShow(editOptions);
}

/// ҽ����
function ArcItmEdit(btnId){
	var title="ҽ����";
	var modifyType=DHCSTEASYUI.GetModifyType(btnId);
	var arcItmSelected=$('#arcItmGrid').datagrid('getSelected');
	var genericSelected=$('#phcGenericGrid').datagrid('getSelected');
	var phcGenericId="",arcItmRowId="";
	if (genericSelected){
		phcGenericId=genericSelected.genericId;
	}
	if (arcItmSelected){
		arcItmRowId=arcItmSelected.arcItmRowId;
	}
	if (modifyType=="A"){
		title=title+"����";
		if (phcGenericId==""){
			$.messager.confirm('ȷ����ʾ', 'û��ѡ�񴦷�ͨ����,���������ֵ��¼,�޷����й���!</br>�Ƿ����?', function(r){
				if (r){
					var urlParams="dhcst.easyui.arcitm.modify.csp?"+"actionType="+modifyType+"&arcItmRowId="+arcItmRowId+"&phcGenericId="+phcGenericId;
					var editOptions={
						title:title,
						width:1100,
						height:500,
						src:urlParams
					}
					DrugMainTainEditShow(editOptions);
				}
			});
			return;
		}
	}else if (modifyType=="U"){
		title=title+"�޸�";
		if (arcItmRowId==""){
			$.messager.alert("��ʾ","��ѡ����Ҫ�޸ĵ�ҽ����!","warning");
			return;
		}
		phcGenericId=arcItmSelected.genericId;
	}else if (modifyType=="L"){
		if (arcItmRowId==""){
			$.messager.alert("��ʾ","��ѡ����Ҫ������ҽ����!","warning");
			return;
		}
		$('#linkWin').window('open');
		$('#linkWin').panel({title:'����ͨ����'});
		var genericId=arcItmSelected.genericId||"";
		var LoadTimes=0;
		var tmpOptions={
			ClassName:"web.DHCST.Util.DrugUtilQuery",
			QueryName:"GetPhcGeneric",
			StrParams:"|@|"+genericId,
	    	columns: [[
				{field:'RowId',title:'RowId',width:100,sortable:true,hidden:true},
				{field:'Description',title:'����ͨ��������',width:200,sortable:true}
		    ]],
			idField:'RowId',
			textField:'Description',
			mode:"remote",
			pageSize:30, 
			pageList:[30,50,100],  
			pagination:true,
			onLoadSuccess:function(data) {
				LoadTimes=LoadTimes+1;
				if (LoadTimes==1){
					if (genericId!=""){
						$("#cmbLinkDict").combogrid("setValue",genericId);
					}else{
						$("#cmbLinkDict").combogrid('clear');
					}
				}
			}
	    };
		$("#cmbLinkDict").dhcstcombogrideu(tmpOptions);
		return;
	}
	if (modifyType=="D"){
		if (arcItmRowId==""){
			$.messager.alert("��ʾ","��ѡ����Ҫɾ����ҽ����!","warning");
			return;
		}
		$.messager.confirm('ȷ����ʾ', 'ҽ�������ݲ�����ɾ��!</br>���Ƿ����?', function(r){
			if (r){
				var delRet=tkMakeServerCall("web.DHCST.ARCITMMAST","Delete",arcItmRowId)
				if(delRet==0){
					$.messager.alert("�ɹ���ʾ","ɾ���ɹ�!","info");
					QueryARCItmGrid();
				}else{
					var delRet=delRet.split("^");
					$.messager.alert("������ʾ",delRet[1],"error");
				}
				return;
			}
		});
		return;
	}
	var urlParams="dhcst.easyui.arcitm.modify.csp?"+"actionType="+modifyType+"&arcItmRowId="+arcItmRowId+"&phcGenericId="+phcGenericId;
	var editOptions={
		title:title,
		width:1100,
		height:500,
		src:urlParams
	}
	DrugMainTainEditShow(editOptions);
}

/// �����
function IncItmEdit(btnId){
	var title="�����";
	var modifyType=DHCSTEASYUI.GetModifyType(btnId);
	var arcItmSelected=$('#arcItmGrid').datagrid('getSelected');
	var incItmSelected=$('#incItmGrid').datagrid('getSelected');
	var incItmId="",arcItmRowId="";
	if (incItmSelected){
		incItmId=incItmSelected.incRowId;
	}
	if (arcItmSelected){
		arcItmRowId=arcItmSelected.arcItmRowId;
	}
	if (modifyType=="A"){
		title=title+"����";
		if (arcItmRowId==""){
			$.messager.confirm('ȷ����ʾ', 'û��ѡ��ҽ����,���������ֵ��¼,�޷����й���!</br>�Ƿ����?', function(r){
				if (r){
					var urlParams="dhcst.easyui.incitm.modify.csp?"+"actionType="+modifyType+"&arcItmRowId="+arcItmRowId+"&incItmRowId="+incItmId;
					var editOptions={
						title:title,
						width:1200,
						height:500,
						src:urlParams
					}
					DrugMainTainEditShow(editOptions);
				}
			});
			return;
		}
	}else if (modifyType=="U"){
		title=title+"�޸�";
		if (incItmId==""){
			$.messager.alert("��ʾ","��ѡ����Ҫ�޸ĵĿ����!","warning");
			return;
		}
		arcItmRowId=incItmSelected.arcItmRowId;
	}else if (modifyType=="L"){
		if (incItmId==""){
			$.messager.alert("��ʾ","��ѡ����Ҫ�����Ŀ����!","warning");
			return;
		}
		$('#linkWin').window('open');
		$('#linkWin').panel({title:'ҽ����'});
		var arcItmRowId=incItmSelected.arcItmRowId||"";
		var LoadTimes=0;
	    var tmpOptions={
		    ClassName:"web.DHCST.ARCITMMAST",
			QueryName:"GetArcItmMast",
			StrParams:"|@|"+arcItmRowId,
		    columns: [[
				{field:'arcItmRowId',title:'arcItmRowId',width:100,sortable:true,hidden:true},
				{field:'arcItmCode',title:'ҽ�������',width:100,sortable:true},
				{field:'arcItmDesc',title:'ҽ��������',width:200,sortable:true}
		    ]],
			idField:'arcItmRowId',
			textField:'arcItmDesc',
			mode:"remote",
			pageSize:30, 
			pageList:[30,50,100],  
			pagination:true,
			onLoadSuccess:function(data) {
				LoadTimes=LoadTimes+1;
				if (LoadTimes==1){
					if (arcItmRowId!=""){
						$("#cmbLinkDict").combogrid("setValue",arcItmRowId);
					}else{
						$("#cmbLinkDict").combogrid("clear");
					}
				}
			}
	    }
		$("#cmbLinkDict").dhcstcombogrideu(tmpOptions);
		return;
	}
	if (modifyType=="D"){
		if (incItmId==""){
			$.messager.alert("��ʾ","��ѡ����Ҫɾ���Ŀ����!","warning");
			return;
		}
		$.messager.confirm('ȷ����ʾ', '��������ݲ�����ɾ��!</br>���Ƿ����?', function(r){
			if (r){
				var delRet=tkMakeServerCall("web.DHCST.INCITM","Delete",incItmId)
				if(delRet==0){
					$.messager.alert("�ɹ���ʾ","ɾ���ɹ�!","info");
					QueryINCItmGrid();
				}else{
					var delRet=delRet.split("^");
					$.messager.alert("������ʾ",delRet[1],"error");
				}
				return;
			}
		});
		return;
	}
	var urlParams="dhcst.easyui.incitm.modify.csp?"+"actionType="+modifyType+"&arcItmRowId="+arcItmRowId+"&incItmRowId="+incItmId;
	var editOptions={
		title:title,
		width:1200,
		height:500,
		src:urlParams
	}
	DrugMainTainEditShow(editOptions);
}
/// �������
function LinkSave(btnId){
	var $linWin=$("#linkWin")
	var modifyType=DHCSTEASYUI.GetModifyType(btnId);
	if (modifyType=="C"){
		$linWin.window('close');
		return;
	}
	if (modifyType=="S"){
		var panelTitle=$linWin.panel('options').title;
		if (panelTitle=="��ѧͨ����"){
			var genericSelected=$('#phcGenericGrid').datagrid('getSelected');
			var phcGenericId="";
			if (genericSelected){
				phcGenericId=genericSelected.genericId;
			}
			if (phcGenericId==""){
				$.messager.alert("��ʾ","��ѡ����Ҫ�����Ĵ���ͨ����!","warning");
				return;	
			}
			var phcChemicalId=$("#cmbLinkDict").combogrid('getValue');
			if (phcChemicalId==""){
				$.messager.alert("��ʾ","��ѡ��ѧͨ����!","warning");
				return;
			}
			var linkRet=tkMakeServerCall("web.DHCST.DrugLink","GenericLinkChemical",phcChemicalId,phcGenericId);
			if(linkRet>0){
				QueryPHCGenericGrid();
			}
		}else if (panelTitle=="����ͨ����"){
			var arcItmSelected=$('#arcItmGrid').datagrid('getSelected');
			var arcItmRowId="";
			if (arcItmSelected){
				arcItmRowId=arcItmSelected.arcItmRowId;
			}
			if (arcItmRowId==""){
				$.messager.alert("��ʾ","��ѡ����Ҫ������ҽ����!","warning");
				return;	
			}
			var phcGenericId=$("#cmbLinkDict").combogrid('getValue');
			if (phcGenericId==""){
				$.messager.alert("��ʾ","��ѡ�񴦷�ͨ����!","warning");
				return;
			}
			var linkRet=tkMakeServerCall("web.DHCST.DrugLink","ArcItmLinkGeneric",arcItmRowId,phcGenericId);
			if(linkRet>0){
				QueryARCItmGrid();
			}
		}	
		if (panelTitle=="ҽ����"){
			var incItmSelected=$('#incItmGrid').datagrid('getSelected');
			var incItmId="";
			if (incItmSelected){
				incItmId=incItmSelected.incRowId;
			}
			if (incItmId==""){
				$.messager.alert("��ʾ","��ѡ����Ҫ�����Ŀ����!","warning");
				return;	
			}
			var arcItmId=$("#cmbLinkDict").combogrid('getValue');
			if (arcItmId==""){
				$.messager.alert("��ʾ","��ѡ��ҽ����!","warning");
				return;
			}
			var linkRet=tkMakeServerCall("web.DHCST.DrugLink","IncItmLinkArcItm",incItmId,arcItmId);
			if(linkRet>0){
				QueryINCItmGrid();
			}
		}
		if(linkRet>0){
			$linWin.window('close');
			$.messager.alert("�ɹ���ʾ","����ɹ�!","info");
		}else{
			var linkArr=linkRet.split("^");
			$.messager.alert("������ʾ",linkArr[1],"error");
		}
		
	}
}

/// �����շ���
function IncLinkTar(){
	var title="�����շ���   <span style='color:#E30000;font-weight:bold'>��ȷ�����ڷ�Χ�ڽ�����Ψһ��Ч��¼</span>";
	var incItmSelected=$('#incItmGrid').datagrid('getSelected')||"";
	if (incItmSelected==""){
		$.messager.alert("��ʾ","����ѡ�������¼","warning");
		return;
	}
	var incItmId=incItmSelected.incRowId;
	var urlParams="dhcst.easyui.inclinktar.modify.csp?"+"urlIncItmId="+incItmId;
	var editOptions={
		title:title,
		width:800,
		height:400,
		src:urlParams
	}
	DrugMainTainEditShow(editOptions)
}

/// �༭����
function DrugMainTainEditShow(_options){
	var options={
		title: 'ά��',
	    width: 400,
	    height: 160,
	    shadow: true,
	    modal: true,
	    border:false,
	    iconCls: 'icon-edit',
	    closed: true,
	    minimizable: false,
	    maximizable: true,
	    collapsible: true,
	    top:null,
	    left:null,
        onBeforeClose: function () { 
        	$("#ifrmMainTain").empty();
        }
	}
	var optionsNew = $.extend({},options, _options);
	var $modifyWin;
	$modifyWin = $('#maintainWin').window(optionsNew);
	$modifyWin.window('open');
    $.messager.progress({ 
      title: '��ʾ', 
      msg: '�����ĵȴ�,������...', 
      text: '' 
    });
	//$modifyWin.window('refresh',_options.src);  
	$("#ifrmMainTain").attr("src",_options.src);
	$("#ifrmMainTain").load(function(){                             //  ��iframe�������  
		$.messager.progress('close');
	});
}

function DrugMainTainEditClose(){
	$('#maintainWin').window('close');
}

function EditArcFromInc(arcItmId){
	if(arcItmId==""){
		return;
	}
	$.messager.confirm('ȷ����ʾ', 'ȷ���޸�ҽ����?', function(r){
		if (r){	
			var title="ҽ�����޸�";
			var urlParams="dhcst.easyui.arcitm.modify.csp?"+"actionType="+"U"+"&arcItmRowId="+arcItmId;
			var editOptions={
				title:title,
				width:1100,
				height:500,
				src:urlParams
			}
			DrugMainTainEditShow(editOptions);			
		}
	});
}

/// ��������
function IncItmSaveAs(){
	var title="��������";
	var incItmSelected=$('#incItmGrid').datagrid('getSelected')||"";
	if(incItmSelected==""){
		$.messager.alert("��ʾ","����ѡ�������¼","warning");
		return;
	}
	var incItmId=incItmSelected.incRowId;
	var arcItmRowId=incItmSelected.arcItmRowId;
	var urlParams="dhcst.easyui.incitm.modify.csp?"+"actionType="+"U"+"&arcItmRowId="+arcItmRowId+"&incItmRowId="+incItmId+"&saveAs=Y";
	var editOptions={
		title:title,
		width:1200,
		height:500,
		src:urlParams
	}
	DrugMainTainEditShow(editOptions);
	
}

/// ҽ�������
function ArcItmSaveAs(){
	var title="ҽ�������";
	var arcItmSelected=$('#arcItmGrid').datagrid('getSelected')||"";
	if(arcItmSelected==""){
		$.messager.alert("��ʾ","����ѡ��ҽ�����¼","warning");
		return;
	}
	var arcItmRowId=arcItmSelected.arcItmRowId;
	var urlParams="dhcst.easyui.arcitm.modify.csp?"+"actionType="+"U"+"&arcItmRowId="+arcItmRowId+"&saveAs=Y";
	var editOptions={
		title:title,
		width:1100,
		height:500,
		src:urlParams
	}
	DrugMainTainEditShow(editOptions);	
}