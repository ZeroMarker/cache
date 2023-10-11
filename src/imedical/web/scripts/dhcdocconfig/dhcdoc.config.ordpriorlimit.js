$(function(){
    $('body').layout('panel','west').panel('resize',{width:$('body').innerWidth()/2-5});
	$('body').layout('resize');
	var hospComp = GenHospComp("Doc_BaseConfig_OrdPriorLimit");
	hospComp.jdata.options.onSelect = function(e,t){
		$('#tabCatPriorLimit,#tabOrdPriorLimit').datagrid('unselectAll').datagrid('reload');
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		InitCatLimitList()
		InitOrdLimitList();
		$("#Radio_OnlyShortPriority,#Radio_OnlyLongPriority").radio({
			requiredSel:true,
			onChecked:function(e,value){
				UpdatePanelTitle(e.target.id);
				$('#tabCatPriorLimit,#tabOrdPriorLimit').datagrid('unselectAll').datagrid('reload');
			}
		});
		$('#BSave').click(SaveExceptPrior);
	}
});
function InitCatLimitList()
{
	$('#tabCatPriorLimit').datagrid({
		idField:'id',
		singleSelect:false,
		rownumbers:false,
		bodyCls:'panel-body-gray',
		columns:[[
			{field:'checkbox',checkbox:true},
			{field:'id',hidden:true},
            {field:'text',title:'子类',width:200},
			{field:'exceptPrior',title:'例外医嘱类型',width:200,align:'center',
				formatter:function(value,rec){  
					if(!value) value='增加';
					return '<a href="#" onclick="ExceptPriorShow(\'Cat\',\''+rec.id+'\')">'+value+'</a>';
				}
			}
		]],
		toolbar:[{
			text:'保存',
			iconCls: 'icon-save',
			handler: function(){
				var PriorCode= GetPriorCode();
				if (!PriorCode) {
					$.messager.alert("提示","请选择限制医嘱类型!");
					return false;
				}
				var SelCatIDArr=new Array();
				var CheckRows=$('#tabCatPriorLimit').datagrid('getSelections');
				$.each(CheckRows,function(index,row){
					SelCatIDArr.push(row.id);
				});
				var value=$.m({
					ClassName:"DHCDoc.DHCDocConfig.ItemPrior",
					MethodName:"SavePriorLimitConfig",
					Value:GetNodeValue(),
					PriorCode:PriorCode,
					ItemCatS:SelCatIDArr.join('^'),
					HospId:$('#_HospList').getValue()
				},false);
				if (value ==0) {
					$.messager.popover({msg:"保存成功!",type:'success'});
				}else{
					$.messager.alert("提示",value);
				}
			}
		}],
		onBeforeLoad:function(param){
			param.ClassName='DHCDoc.DHCDocConfig.ItemPrior';
			param.QueryName='FindCatListPrior';
			param.PriorCode=GetPriorCode();
			param.value=GetNodeValue();
			param.HospId=$('#_HospList').getValue();
		},
		onLoadSuccess:function(data){
			$.each(data.rows,function(index,row){
				if(row.selected){
					$('#tabCatPriorLimit').datagrid('selectRow',index);
				}
			});
		}
	});
}
function InitOrdLimitList(){
	$('#tabOrdPriorLimit').datagrid({
		singleSelect:false,
		rownumbers:false,
		bodyCls:'panel-body-gray',
		columns:[[
			{field:'checkbox',checkbox:true},
			{field:'Index',hidden:true},
			{field:'ArcimDr',hidden:true},
            {field:'ArcimDesc',title:'医嘱项',width:200,valueField:'ArcimDr',
				editor:{
					type:'lookup',
					options:{
						url:$URL,
						mode:'remote',
						method:"Get",
						idField:'ArcimRowID',
						textField:'ARCIMDesc',
						columns:[[  
							{field:'ARCIMDesc',title:'名称',width:320,sortable:true},
							{field:'ArcimRowID',title:'ID',width:70,sortable:true}
						]],
						pagination:true,
						panelWidth:400,
						panelHeight:400,
						isCombo:true,
						minQueryLen:2,
						delay:'500',
						queryOnSameQueryString:true,
						queryParams:{ClassName: 'web.DHCARCOrdSets',QueryName: 'LookUpItem'},
						onBeforeLoad:function(param){
							param = $.extend(param,{Item:param['q'],GroupID:'',OrderPrescType:"Other",HospID:$('#_HospList').getValue()});
						}
					}
				}
			},
			{field:'exceptPrior',title:'例外医嘱类型',width:200,align:'center',
				formatter:function(value,rec){  
					if(!rec.Index) return '';
					if(!value) value='增加';
					return '<a href="#" onclick="ExceptPriorShow(\'Item\',\''+rec.Index+'\')">'+value+'</a>';
				}
			}
		]],
		toolbar:[{
			text:'增加',
			iconCls: 'icon-add',
			handler: function(){
				var row={};
				$('#tabOrdPriorLimit').datagrid('appendRow',row);
				var rows= $('#tabOrdPriorLimit').datagrid('getRows');
				$('#tabOrdPriorLimit').datagrid('beginEdit',rows.length-1).datagrid('scrollTo',rows.length-1);
			}
		},'-',{
			text:'修改',
			iconCls: 'icon-edit',
			handler: function(){
				var Selected= $('#tabOrdPriorLimit').datagrid('getSelected');
				if(!Selected){
					$.messager.popover({msg:"请选择需要修改项目",type:'alert'});
					return;
				}
				var index= $('#tabOrdPriorLimit').datagrid('getRowIndex',Selected);
				$('#tabOrdPriorLimit').datagrid('beginEdit',index);
			}
		},'-',{
			text:'保存',
			iconCls: 'icon-save',
			handler: function(){
				var PriorCode= GetPriorCode();
				if (!PriorCode) {
					$.messager.alert("提示","请选择限制医嘱类型!");
					return false;
				}
				var SaveRows=$('#tabOrdPriorLimit').datagrid('getEditRows');
				if(!SaveRows.length){
					$.messager.popover({msg:"没有需要保存的数据",type:'alert'});
					return;
				}
				var ArcimArr=new Array();
				$.each(SaveRows,function(index,row){
					ArcimArr.push(row.ArcimDr);
				});
				var value=$.m({
					ClassName:"DHCDoc.DHCDocConfig.ItemPrior",
					MethodName:"SaveOrdPriorLimit",
					Value:GetNodeValue(),
					PriorCode:PriorCode,
					Info:ArcimArr.join('^'),
					HospId:$('#_HospList').getValue()
				},false);
				if (value==0) {
					$.messager.popover({msg:"保存成功!",type:'success'});
					$('#tabOrdPriorLimit').datagrid('reload');
				}else{
					$.messager.alert("提示",value);
				}
			}
		},'-',{
			text:'删除',
			iconCls: 'icon-remove',
			handler: function(){
				var CheckRows=$('#tabOrdPriorLimit').datagrid('getSelections');
				if(!CheckRows.length){
					$.messager.popover({msg:"请选择需要删除项目",type:'alert'});
					return;
				}
				var delIndex=new Array();
				$.each(CheckRows,function(index,row){
					if(row.Index){
						delIndex.push(row.Index);
					}else{
						var rowIndex=$('#tabOrdPriorLimit').datagrid('getRowIndex',row);
						$('#tabOrdPriorLimit').datagrid('deleteRow',rowIndex);
					}
				});
				if(delIndex.length){
					$.messager.confirm('提示','确定删除所选医嘱',function(r){
						if(r){
							var value=$.m({
								ClassName:"DHCDoc.DHCDocConfig.ItemPrior",
								MethodName:"DelPriorLimit",
								Value:GetNodeValue(),
								PriorCode:GetPriorCode(),
								IndexS:delIndex.join('^'),
								HospId:$('#_HospList').getValue()
						   },false);
						   if(value=="0"){
								$('#tabOrdPriorLimit').datagrid('unselectAll').datagrid('reload');
								$.messager.popover({msg:"删除成功!",type:'success'});
						   }else{
							  $.messager.alert('提示',"删除失败:"+value);
							  return false;
						   }
						}
					});
				}
			}
		}],
		onDblClickRow:function(index, row){
			$(this).datagrid('beginEdit',index);
		},
		onBeforeLoad:function(param){
			param.ClassName='DHCDoc.DHCDocConfig.ItemPrior';
			param.QueryName='FindOrdPriorLimit';
			param.PriorCode=GetPriorCode();
			param.Value=GetNodeValue();
			param.HospId=$('#_HospList').getValue();
		}
	});
}
function GetPriorCode(){
	var PriorCode="";
	if ($("#Radio_OnlyShortPriority").radio('getValue')) {
		var PriorCode="NORM";
	}else if ($("#Radio_OnlyLongPriority").radio('getValue')){
		var PriorCode="S";
	}
	return PriorCode;
}
function GetNodeValue(){
	if ($("#Radio_OnlyShortPriority").radio('getValue')) {
		var NodeValue="OnlyNORMItemCat";
	}else if ($("#Radio_OnlyLongPriority").radio('getValue')){
		var NodeValue="OnlyLongItemCat"
	}
	return NodeValue;
}
function UpdatePanelTitle(id){
	if (id =="Radio_OnlyShortPriority") {
		$("#westPanel").panel('setTitle','仅可开临时的医嘱子类')
		$("#eastPanel").panel('setTitle','仅可开临时的医嘱项目')
	}else if(id =="Radio_OnlyLongPriority"){
		$("#westPanel").panel('setTitle','仅可开长期的医嘱子类')
		$("#eastPanel").panel('setTitle','仅可开长期的医嘱项目')
	}
}
function ExceptPriorShow(ItemType,ItemValue)
{
	var PriorCode= GetPriorCode();
	if (!PriorCode) {
		$.messager.alert("提示","请选择限制医嘱类型!");
		return websys_cancel();
	}
	$('#dialog-prior').dialog('options').ItemType=ItemType;
	$('#dialog-prior').dialog('options').ItemValue=ItemValue;
	$('#dialog-prior').dialog('open');
	$('#PriorList').empty();
	$.cm({
		ClassName:'DHCDoc.DHCDocConfig.ItemPrior',
		QueryName:'QueryPrior',
		ItemType:ItemType,
		ItemValue:ItemValue,
		Value:GetNodeValue(),
		PriorCode:GetPriorCode(),
		HospId:$('#_HospList').getValue()
	},function(data){
		$.each(data.rows,function(index,row){
			var $option=$("<option value='"+row.id+"'>"+row.text+"</option>");
			if(row.selected) $option.attr('selected',true);
			$('#PriorList').append($option);
		});
	});
	return websys_cancel();
}
function SaveExceptPrior()
{
	var PriorStr="";
	$('#PriorList option:selected').each(function(){
		if(PriorStr=='') PriorStr=$(this).val();
		else PriorStr+='^'+$(this).val();
	});
	var ItemType=$('#dialog-prior').dialog('options').ItemType;
	var ItemValue=$('#dialog-prior').dialog('options').ItemValue;
	var ret=$.m({
		ClassName:'DHCDoc.DHCDocConfig.ItemPrior',
		MethodName:'SaveExceptPrior',
		ItemType:ItemType,
		ItemValue:ItemValue,
		Value:GetNodeValue(),
		PriorCode:GetPriorCode(),
		PriorStr:PriorStr,
		HospId:$('#_HospList').getValue()
	},false);
	if(ret=="0"){
		$('#dialog-prior').dialog('close');
		$('#tabCatPriorLimit,#tabOrdPriorLimit').datagrid('reload');
		$.messager.popover({msg:"保存成功!",type:'success'});
   }else{
	  $.messager.alert('提示',"保存失败:"+ret);
	  return false;
   }
}