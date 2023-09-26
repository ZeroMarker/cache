/**
 * 模块:		药库
 * 子模块:		药品信息维护(分级),编辑弹框事件
 * createdate:	2017-06-21
 * creator:		yunhaibao
 * description: 增删查改按钮触发后的方法
 */
 
/// 药学分类
function PhcCatEdit(btnId){
	var title="药学分类";
	var modifyType=DHCSTEASYUI.GetModifyType(btnId);
	var treeSelected=$('#phcCatTreeGrid').treegrid('getSelected');
	var phcCatRowId="";
	if (treeSelected){
		phcCatRowId=treeSelected.phcCatRowId;
	}
	if (modifyType=="A"){
		title=title+"增加";
		if (phcCatRowId==""){
			$.messager.confirm('确认提示',"未选中药学分类,将添加1级药学分类?",function(r){
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
		title=title+"修改";
		if (!treeSelected){
			$.messager.alert("提示","请选中需要修改的药学分类!",'warning');
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
			$.messager.alert('提示','请选择需要删除的药学分类!','warning');
			return;
		}
		var delRet=tkMakeServerCall("web.DHCST.PHCCATMAINTAIN","Delete",phcCatRowId)
		if(delRet==0){
			$.messager.alert("成功提示","删除成功!",'info');
			ReloadPhcCatTreeById(phcCatRowId);
			$('#phcCatTreeGrid').treegrid('remove', phcCatRowId);
		}else{
			var delRet=delRet.split("^");
			$.messager.alert("错误提示",delRet[1],'error');
		}
		return;
	}
	
}

/// 化学通用名
function PhcChemicalEdit(btnId){
	var title="化学通用名";
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
		title=title+"增加";
		if (phcCatRowId==""){
			$.messager.confirm('确认提示', '没有选择药学分类,将仅增加字典记录,无法进行关联!</br>是否继续?', function(r){
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
		title=title+"修改";
		if (phcChemicalId==""){
			$.messager.alert("提示","请选中需要修改的化学通用名!",'warning');
			return;
		}
		phcCatRowId=dataSelected.phcCatId;
	}else if (modifyType=="L"){	
		if (phcChemicalId==""){
			$.messager.alert("提示","请选中需要关联的化学通用名!",'warning');
			return;
		}
		if (phcCatRowId==""){
			$.messager.alert("提示","请选中需要关联的药学分类!",'warning');
			return;
		}
		$.messager.confirm('关联药学分类', '是否关联 '+treeSelected.phcCatDesc+'?', function(r){
			if (r){
				var linkRet=tkMakeServerCall("web.DHCST.DrugLink","ChemicalLinkPhcCat",phcCatRowId,phcChemicalId);
				if(linkRet>0){
					$.messager.alert("成功提示","关联成功!",'info');
					QueryPHCChemicalGrid();
				}else{
					var linkArr=linkRet.split("^");
					$.messager.alert("错误提示",linkRet[1],'error');
				}	
				return;
			}
		});
		return;	
	}
	if (modifyType=="D"){
		if (phcChemicalId==""){
			$.messager.alert("提示","请选中需要删除的化学通用名!","warning");
			return;
		}
		var delRet=tkMakeServerCall("web.DHCST.PHCChemical","Delete",phcChemicalId)
		if(delRet==0){
			$.messager.alert("成功提示","删除成功!","info");
			QueryPHCChemicalGrid();
		}else{
			var delRet=delRet.split("^");
			$.messager.alert("错误提示",delRet[1],"error");
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

/// 处方通用名
function PhcGenericEdit(btnId){
	var title="处方通用名";
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
		title=title+"增加";		
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
		title=title+"修改";
		if (phcGenericId==""){
			$.messager.alert("提示","请选中需要修改的处方通用名!","warning");
			return;
		}
		phcChemicalId=genericSelected.chemicalId;
	}else if (modifyType=="L"){	
		if (phcGenericId==""){
			$.messager.alert("提示","请选中需要关联的处方通用名分类!","warning");
			return;
		}
		$('#linkWin').window('open');
		$('#linkWin').panel({title:'化学通用名'});
		var chemicalId=genericSelected.chemicalId||"";
		var LoadTimes=0;
		var tmpOptions={
			ClassName:"web.DHCST.Util.DrugUtilQuery",
			QueryName:"GetChemical",
			StrParams:"|@|"+chemicalId,
	    	columns: [[
				{field:'RowId',title:'RowId',width:100,sortable:true,hidden:true},
				{field:'Description',title:'化学通用名名称',width:200,sortable:true}
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
			$.messager.alert("提示","请选中需要删除的处方通用名!","warning");
			return;
		}
		var delRet=tkMakeServerCall("web.DHCST.PHCGeneric","Delete",phcGenericId)
		if(delRet==0){
			$.messager.alert("成功提示","删除成功!","info");
			QueryPHCGenericGrid();
		}else{
			var delRet=delRet.split("^");
			$.messager.alert("错误提示",delRet[1],"error");
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

/// 医嘱项
function ArcItmEdit(btnId){
	var title="医嘱项";
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
		title=title+"增加";
		if (phcGenericId==""){
			$.messager.confirm('确认提示', '没有选择处方通用名,将仅增加字典记录,无法进行关联!</br>是否继续?', function(r){
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
		title=title+"修改";
		if (arcItmRowId==""){
			$.messager.alert("提示","请选中需要修改的医嘱项!","warning");
			return;
		}
		phcGenericId=arcItmSelected.genericId;
	}else if (modifyType=="L"){
		if (arcItmRowId==""){
			$.messager.alert("提示","请选中需要关联的医嘱项!","warning");
			return;
		}
		$('#linkWin').window('open');
		$('#linkWin').panel({title:'处方通用名'});
		var genericId=arcItmSelected.genericId||"";
		var LoadTimes=0;
		var tmpOptions={
			ClassName:"web.DHCST.Util.DrugUtilQuery",
			QueryName:"GetPhcGeneric",
			StrParams:"|@|"+genericId,
	    	columns: [[
				{field:'RowId',title:'RowId',width:100,sortable:true,hidden:true},
				{field:'Description',title:'处方通用名名称',width:200,sortable:true}
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
			$.messager.alert("提示","请选中需要删除的医嘱项!","warning");
			return;
		}
		$.messager.confirm('确认提示', '医嘱项数据不建议删除!</br>您是否继续?', function(r){
			if (r){
				var delRet=tkMakeServerCall("web.DHCST.ARCITMMAST","Delete",arcItmRowId)
				if(delRet==0){
					$.messager.alert("成功提示","删除成功!","info");
					QueryARCItmGrid();
				}else{
					var delRet=delRet.split("^");
					$.messager.alert("错误提示",delRet[1],"error");
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

/// 库存项
function IncItmEdit(btnId){
	var title="库存项";
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
		title=title+"增加";
		if (arcItmRowId==""){
			$.messager.confirm('确认提示', '没有选择医嘱项,将仅增加字典记录,无法进行关联!</br>是否继续?', function(r){
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
		title=title+"修改";
		if (incItmId==""){
			$.messager.alert("提示","请选中需要修改的库存项!","warning");
			return;
		}
		arcItmRowId=incItmSelected.arcItmRowId;
	}else if (modifyType=="L"){
		if (incItmId==""){
			$.messager.alert("提示","请选中需要关联的库存项!","warning");
			return;
		}
		$('#linkWin').window('open');
		$('#linkWin').panel({title:'医嘱项'});
		var arcItmRowId=incItmSelected.arcItmRowId||"";
		var LoadTimes=0;
	    var tmpOptions={
		    ClassName:"web.DHCST.ARCITMMAST",
			QueryName:"GetArcItmMast",
			StrParams:"|@|"+arcItmRowId,
		    columns: [[
				{field:'arcItmRowId',title:'arcItmRowId',width:100,sortable:true,hidden:true},
				{field:'arcItmCode',title:'医嘱项代码',width:100,sortable:true},
				{field:'arcItmDesc',title:'医嘱项描述',width:200,sortable:true}
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
			$.messager.alert("提示","请选中需要删除的库存项!","warning");
			return;
		}
		$.messager.confirm('确认提示', '库存项数据不建议删除!</br>您是否继续?', function(r){
			if (r){
				var delRet=tkMakeServerCall("web.DHCST.INCITM","Delete",incItmId)
				if(delRet==0){
					$.messager.alert("成功提示","删除成功!","info");
					QueryINCItmGrid();
				}else{
					var delRet=delRet.split("^");
					$.messager.alert("错误提示",delRet[1],"error");
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
/// 级别关联
function LinkSave(btnId){
	var $linWin=$("#linkWin")
	var modifyType=DHCSTEASYUI.GetModifyType(btnId);
	if (modifyType=="C"){
		$linWin.window('close');
		return;
	}
	if (modifyType=="S"){
		var panelTitle=$linWin.panel('options').title;
		if (panelTitle=="化学通用名"){
			var genericSelected=$('#phcGenericGrid').datagrid('getSelected');
			var phcGenericId="";
			if (genericSelected){
				phcGenericId=genericSelected.genericId;
			}
			if (phcGenericId==""){
				$.messager.alert("提示","请选中需要关联的处方通用名!","warning");
				return;	
			}
			var phcChemicalId=$("#cmbLinkDict").combogrid('getValue');
			if (phcChemicalId==""){
				$.messager.alert("提示","请选择化学通用名!","warning");
				return;
			}
			var linkRet=tkMakeServerCall("web.DHCST.DrugLink","GenericLinkChemical",phcChemicalId,phcGenericId);
			if(linkRet>0){
				QueryPHCGenericGrid();
			}
		}else if (panelTitle=="处方通用名"){
			var arcItmSelected=$('#arcItmGrid').datagrid('getSelected');
			var arcItmRowId="";
			if (arcItmSelected){
				arcItmRowId=arcItmSelected.arcItmRowId;
			}
			if (arcItmRowId==""){
				$.messager.alert("提示","请选中需要关联的医嘱项!","warning");
				return;	
			}
			var phcGenericId=$("#cmbLinkDict").combogrid('getValue');
			if (phcGenericId==""){
				$.messager.alert("提示","请选择处方通用名!","warning");
				return;
			}
			var linkRet=tkMakeServerCall("web.DHCST.DrugLink","ArcItmLinkGeneric",arcItmRowId,phcGenericId);
			if(linkRet>0){
				QueryARCItmGrid();
			}
		}	
		if (panelTitle=="医嘱项"){
			var incItmSelected=$('#incItmGrid').datagrid('getSelected');
			var incItmId="";
			if (incItmSelected){
				incItmId=incItmSelected.incRowId;
			}
			if (incItmId==""){
				$.messager.alert("提示","请选中需要关联的库存项!","warning");
				return;	
			}
			var arcItmId=$("#cmbLinkDict").combogrid('getValue');
			if (arcItmId==""){
				$.messager.alert("提示","请选择医嘱项!","warning");
				return;
			}
			var linkRet=tkMakeServerCall("web.DHCST.DrugLink","IncItmLinkArcItm",incItmId,arcItmId);
			if(linkRet>0){
				QueryINCItmGrid();
			}
		}
		if(linkRet>0){
			$linWin.window('close');
			$.messager.alert("成功提示","保存成功!","info");
		}else{
			var linkArr=linkRet.split("^");
			$.messager.alert("错误提示",linkArr[1],"error");
		}
		
	}
}

/// 关联收费项
function IncLinkTar(){
	var title="关联收费项   <span style='color:#E30000;font-weight:bold'>请确保日期范围内仅存在唯一有效记录</span>";
	var incItmSelected=$('#incItmGrid').datagrid('getSelected')||"";
	if (incItmSelected==""){
		$.messager.alert("提示","请先选择库存项记录","warning");
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

/// 编辑弹窗
function DrugMainTainEditShow(_options){
	var options={
		title: '维护',
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
      title: '提示', 
      msg: '请耐心等待,加载中...', 
      text: '' 
    });
	//$modifyWin.window('refresh',_options.src);  
	$("#ifrmMainTain").attr("src",_options.src);
	$("#ifrmMainTain").load(function(){                             //  等iframe加载完毕  
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
	$.messager.confirm('确认提示', '确认修改医嘱项?', function(r){
		if (r){	
			var title="医嘱项修改";
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

/// 库存项另存
function IncItmSaveAs(){
	var title="库存项另存";
	var incItmSelected=$('#incItmGrid').datagrid('getSelected')||"";
	if(incItmSelected==""){
		$.messager.alert("提示","请先选择库存项记录","warning");
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

/// 医嘱项另存
function ArcItmSaveAs(){
	var title="医嘱项另存";
	var arcItmSelected=$('#arcItmGrid').datagrid('getSelected')||"";
	if(arcItmSelected==""){
		$.messager.alert("提示","请先选择医嘱项记录","warning");
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