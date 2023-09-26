/**
*
* websys.sensitiveprops.js
*/
function debounce(func, wait, immediate) {
    var timeout, result;
    var debounced = function () {
        var context = this;
        var args = arguments;

        if (timeout) clearTimeout(timeout);
        if (immediate) {
            // 如果已经执行过，不再执行
            var callNow = !timeout;
            timeout = setTimeout(function(){
                timeout = null;
            }, wait)
            if (callNow) result = func.apply(context, args)
        }
        else {
            timeout = setTimeout(function(){
                func.apply(context, args)
            }, wait);
        }
        return result;
    };
    debounced.cancel = function() {
        clearTimeout(timeout);
        timeout = null;
    };
    return debounced;
}
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
	    })
    }
})(jQuery);

var GV={};

///授权页签
var initAuth=function(){
	
	GV.showAddWin=function(){
		$('#win').dialog({
			iconCls:'icon-w-add',
			title:'新增'
		}).dialog('open');
		$('#TId').val('');
	};
	GV.showEidtWin=function(){
		//debugger;
		var row=$('#list').datagrid('getSelected');
		if (row && row.myPrefId){
			$('#win').dialog({
				iconCls:'icon-w-edit',
				title:'修改'
			}).dialog('open');
			$('#TId').val(row.myPrefId);
			$('input[name="objectType"]').each(function(){
				if ($(this).val()==row.myobjectType){
					//$(this).prop('checked',true);
					//$(this).trigger('change');
					$(this).radio('check');
					return false;
				}	
			})
			var id=$('input[name="objectType"]:checked').attr('id');
			/*
			var oldOnLoadSuccess=$('#i-'+id).combogrid('options').onLoadSuccess;
			$('#i-'+id).combogrid('options').onLoadSuccess=function(){
				$('#i-'+id).combogrid('setValue',row.myobjectRef);
				oldOnLoadSuccess.apply(this,arguments);
				$('#i-'+id).combogrid('options').onLoadSuccess=oldOnLoadSuccess;
			}*/

			if(id != "objectType-site"){
				//$('#i-'+id).combogrid('options').keyHandler.query.call($('#i-'+id)[0],row.mydesc);
				//$('#i-'+id).combogrid('setValue',row.myobjectRef);
				//$('#i-'+id).combogrid('setText',row.mydesc);
				$('#i-'+id).combogrid('setRemoteValue',{value:row.myobjectRef,text:row.mydesc});
			}
			
			$('#sensitiveProps').combogrid('setValues',row.myData.split('-'));
			
		}else{
			//$.messager.alert("错误","请选择行");
			$.messager.popover({msg:'请选择行',type:'alert'});
		}
	}
	GV.showDelWin=function(){
		var row=$('#list').datagrid('getSelected');
		if (row && row.myPrefId){
			$.messager.confirm("提示","确认删除？",function(r){
				if(r){
					$.ajaxRunServerMethod({
						ClassName:'websys.DHCPreferences',
						MethodName:'DeleteById',
						prefId:row.myPrefId
					},function(rtn){
						if (rtn>0){
							//$.messager.alert("成功","删除成功");
							$.messager.popover({msg:'删除成功',type:'success'});
							$('#list').datagrid('reload');
						}else{
							$.messager.alert("成功","删除失败<br>"+(rtn.split("^")[1]||""),'error');
						}
					})
					
				}	
			})
		}else{
			//$.messager.alert("错误","请选择行");
			$.messager.popover({msg:'请选择行',type:'alert'});
		}
	}

	function loadBasicData(after){
		GV.objectTypeCode2Desc={
			"SITE":"站点",
			"User.SSGroup":"安全组",
			"User.SSUser":"用户"
		}
		GV.sensitivePropsCode2Desc={};
		/// 敏感词的数据
		$.ajaxRunServerQuery({
			ClassName:'websys.SensitiveProps',
			QueryName:'Find',
			rows:999
		},function(rtn){
			GV.sensitivePropsData=rtn.rows;
			$.each(rtn.rows,function(){
				if (this.TCode!="") GV.sensitivePropsCode2Desc[this.TCode]=this.TDesc;
				
			})
			if (typeof after=='function')after();
		})
	
	}
	loadBasicData(function(){ //授权界面元素的初始话放在加载数据之后
		$('#list').datagrid({
			fit:true,
			border:false,
			pagination: true,
		    pageSize:30,
		    pageList:[30,50,100],
			striped:true,
			singleSelect:true,
			idField:'myPrefId',
			rownumbers:true,
			columns:[[
				{field:'myobjectType',title:'级别',width:100,formatter:function(v){
					return GV.objectTypeCode2Desc[v]||v;
				}},
				{field:'mydesc',title:'对象',width:150},
				{field:'myData',title:'敏感字段',width:300,formatter:function(v){
					var arr=v.split('-');
					return $.map(arr,function(n){
						return GV.sensitivePropsCode2Desc[n]||n;
					}).join('-');
				}}
			]],
			toolbar:[{iconCls:'icon-add',text:'新增',handler:GV.showAddWin},
				{iconCls:'icon-edit',text:'修改',handler:GV.showEidtWin},
				{iconCls:'icon-remove',text:'删除',handler:GV.showDelWin}
			],
			url:'jquery.easyui.querydatatrans.csp?ClassName=websys.DHCPreferences&QueryName=CommonFind&appKey=Sensitive&appSubKey=websys.SensitiveProps'
		});
		$('#ss').searchbox({
			searcher:function(v){
				$('#list').datagrid('load',{desc:v})	;
				
			}	,
			'prompt':'用户、安全组、站点...',
			width:200
		});
		var objectTypeChangeHandler=function(){
			var id=$("input[name='objectType']:checked").attr('id');
			$('.tr-objectType').hide();
			$('#tr-'+id).show();
			console.log($("input[name='objectType']:checked").length)
		}
		var debounce_objectTypeChangeHandler=debounce(objectTypeChangeHandler,200);
		//$("input[name='objectType']").change(debounce_objectTypeChangeHandler);
		$("input[name='objectType']").each(function(){
			$(this).radio({
				onChecked:debounce_objectTypeChangeHandler	
			})
		})
		
		$('#i-objectType-group').combogrid({
			panelWidth:450,
			panelHeight:300,
			showHeader:true,
			disabled:false,
			delay: 500,
			mode: 'remote',
			idField: 'HIDDEN',
			textField: 'Description',
			onBeforeLoad:function(param){
				param = $.extend(param,{desc:param.q});
				return true;
			},
			url:'jquery.easyui.querydatatrans.csp?ClassName=websys.DHCMessageOrgMgr&QueryName=LookUpGroup',
			columns: [[{field:'Description',title:'安全组',width:400},{field:'HIDDEN',title:'HIDDEN',align:'right',hidden:true,width:0}]]
			,pagination:true
			,lazy:true
		})
		
		$('#i-objectType-user').combogrid({
			panelWidth:450,
			panelHeight:300,
			disabled:false,
			delay: 500,
			mode: 'remote',
			idField: 'HIDDEN',
			textField: 'Description',
			onBeforeLoad:function(param){
				param = $.extend(param,{desc:param.q});
				return true;
			},
			url:'jquery.easyui.querydatatrans.csp?ClassName=websys.DHCMessageOrgMgr&QueryName=LookUpUser',
			columns: [[{field:'Description',title:'用户名',width:150},{field:'Code',title:'工号',width:110},{field:'HIDDEN',title:'HIDDEN',align:'right',hidden:true,width:0}]]
			,pagination:true
			,lazy:true
		});

		$('#sensitiveProps').combogrid({
			panelWidth:470,
			panelHeight:'200',
			idField: 'TCode',
			textField: 'TDesc',
			columns: [[{field:'TCode',title:'代码',width:100},{field:'TDesc',title:'描述',width:100},{field:'TProps',title:'字段',width:250}]]
			,data:GV.sensitivePropsData,
			separator:'-',
			multiple:true,
			editable:false
		})
		
		$('#win').dialog({
			onClose:function(){
				$("input[name='objectType']").eq(0).radio('check')
				//$('input[type="objectType"]').eq(0).prop('checked',true);
				//$('input[type="objectType"]').eq(0).trigger('change');
				$('#i-objectType-user').combogrid('clear');
				$('#i-objectType-user').combogrid('setRemoteValue',{value:'',text:''});
				//$('#i-objectType-user').combogrid('options').keyHandler.query.call($('#i-objectType-user')[0],'');
				$('#i-objectType-group').combogrid('clear');
				//$('#i-objectType-group').combogrid('options').keyHandler.query.call($('#i-objectType-group')[0],'');
				$('#i-objectType-group').combogrid('setRemoteValue',{value:'',text:''});
				$('#sensitiveProps').combogrid('clear');
			},
			buttons:[{
				text:'保存',
				handler:function(){
					var prefId=$('#TId').val();
					var objectType=$("input[name='objectType']:checked").val();
					var objectReference="";
					if(objectType=="SITE"){
						objectReference=$('#i-objectType-site').val();
					}else if(objectType=="User.SSGroup"){
						objectReference=$('#i-objectType-group').combogrid('getValue');
					}else if(objectType=="User.SSUser"){
						objectReference=$('#i-objectType-user').combogrid('getValue');
					}
					var sensitiveProps=$('#sensitiveProps').combogrid('getValues').join('-');
					
					var data={
						ClassName:'websys.DHCPreferences',
						MethodName:'CommonSave',
						prefId:prefId,
						objectType:objectType,
						objectReference:objectReference,
						Data:sensitiveProps,
						appKey:'Sensitive',
						appSubKey:'websys.SensitiveProps'
					}
					$.ajaxRunServerMethod(data,function(rtn){
						if (rtn>0){
							//$.messager.alert("成功","保存成功");
							$.messager.popover({msg:'保存成功',type:'success'});
							$('#win').dialog('close');
							$('#list').datagrid('reload');
						}else{
							$.messager.alert("失败","保存失败<br>"+(rtn.split("^")[1]||""),'error');
						}
					})
				}
			},{
				text:'关闭',
				handler:function(){
					$('#win').dialog('close');
				}
			}]
		})

	})


	///重新加载授权界面
	GV.reloadAuth=function(){
		///重新获取敏感字段数据 重新加载授权界面部分数据
		loadBasicData(function(){ 
			$('#list').datagrid('reload');
			$('#sensitiveProps').combogrid('grid').datagrid('loadData',GV.sensitivePropsData);
		})
	}

}


var initProps=function(){
	$('#i-props-cls').combogrid({
		panelWidth:450,
		panelHeight:300,
		showHeader:true,
		disabled:false,
		delay: 500,
		mode: 'remote',
		idField: 'clsName',
		textField: 'clsName',
		onBeforeLoad:function(param){
			param.desc = param.q;
			return true;
		},
		url:$URL,
		queryParams:{ClassName:'websys.SensitiveProps',QueryName:'QrySPClass'},
		columns: [[{field:'clsName',title:'类名',width:400}]]
		,pagination:true
		,lazy:true
		,onChange:function(){
			$('#i-props-prop').combogrid('clear');
			$('#i-props-prop').combogrid('setRemoteValue',{text:'',value:''});
		}
	})
	$('#i-props-prop').combogrid({
		panelWidth:550,
		panelHeight:300,
		showHeader:true,
		disabled:false,
		delay: 500,
		mode: 'remote',
		idField: 'propName',
		textField: 'propName',
		onBeforeLoad:function(param){
			param.clsName = $('#i-props-cls').combogrid('getValue');
			param.desc = param.q;
			return true;
		},
		url:$URL,
		queryParams:{ClassName:'websys.SensitiveProps',QueryName:'QrySPClassProps'},
		//propName,propSqlFieldName,propType
		columns: [[{field:'propName',title:'属性名',width:200},{field:'propSqlFieldName',title:'SQL字段名',width:200},{field:'propType',title:'类型',width:120}]]
		,pagination:true
		,lazy:true
	})
	
	$('#win-props').dialog({
		onClose:function(){
			$('#TId-props,#i-props-code,#i-props-desc,#i-props-format').val('');
			$('#i-props-cls,#i-props-prop').combogrid('clear');
			$('#i-props-cls,#i-props-prop').combogrid('setRemoteValue',{value:'',text:''});
		},
		buttons:[{
			text:'保存',
			handler:function(){
				var Id=$('#TId-props').val();
				var Code=$('#i-props-code').val();
				if ($.trim(Code)=='') {$.messager.popover({msg:'代码不能为空',type:'alert'});$('#i-props-code').foucs();return;}
				var Desc=$('#i-props-desc').val();
				if ($.trim(Desc)=='') {$.messager.popover({msg:'描述不能为空',type:'alert'});$('#i-props-desc').foucs();return;}
				var Format=$('#i-props-format').val();
				if ($.trim(Format)=='') {$.messager.popover({msg:'格式不能为空',type:'alert'});$('#i-props-format').foucs();return;}
				var cls=$('#i-props-cls').combogrid('getValue'),prop=$('#i-props-prop').combogrid('getValue');
				if ($.trim(cls)=='' || $.trim(prop)=='') {$.messager.popover({msg:'请选择正确的字段',type:'alert'});return;}
				var Props=cls+'-'+prop;
				var data={
					ClassName:'websys.SensitiveProps',
					MethodName:'Save',
					Id:Id,Code:Code,Desc:Desc,Format:Format,Props:Props
				}
				$.ajaxRunServerMethod(data,function(rtn){
					if (rtn>0){
						//$.messager.alert("成功","保存成功");
						$.messager.popover({msg:'保存成功',type:'success'});
						$('#win-props').dialog('close');
						$('#list-props').datagrid('reload');
						GV.reloadAuth(); //重新加载授权页面
					}else{
						$.messager.alert("失败","保存失败<br>"+(rtn.split("^")[1]||""),'error');
					}
				})
			}
		},{
			text:'关闭',
			handler:function(){
				$('#win-props').dialog('close');
			}
		}]
	})
	
	GV.showAddWin_props=function(){
		$('#win-props').dialog({
			iconCls:'icon-w-add',
			title:'新增'
		}).dialog('open');
		$('#TId-props').val('');
	};
	GV.showEidtWin_props=function(){
		//debugger;
		var row=$('#list-props').datagrid('getSelected');
		if (row && row.TId){
			$('#win-props').dialog({
				iconCls:'icon-w-edit',
				title:'修改'
			}).dialog('open');
			$('#TId-props').val(row.TId);
			$('#i-props-code').val(row.TCode);
			$('#i-props-desc').val(row.TDesc);
			$('#i-props-format').val(row.TFormat);
			var cls=row.TProps.split('-')[0],prop=row.TProps.split('-')[1]||'';
			$('#i-props-cls').combogrid('setRemoteValue',{value:cls,text:cls});
			$('#i-props-prop').combogrid('setRemoteValue',{value:prop,text:prop});
			
		}else{
			//$.messager.alert("错误","请选择行");
			$.messager.popover({msg:'请选择行',type:'alert'});
		}
	}
	GV.showDelWin_props=function(){
		var row=$('#list-props').datagrid('getSelected');
		if (row && row.TId){
			$.messager.confirm("提示","确认删除？",function(r){
				if(r){
					$.ajaxRunServerMethod({
						ClassName:'websys.SensitiveProps',
						MethodName:'Delete',
						Id:row.TId
					},function(rtn){
						if (rtn>0){
							//$.messager.alert("成功","删除成功");
							$.messager.popover({msg:'删除成功',type:'success'});
							$('#list-props').datagrid('reload');
							GV.reloadAuth(); //重新加载授权页面
						}else{
							$.messager.alert("成功","删除失败<br>"+(rtn.split("^")[1]||""),'error');
						}
					})
					
				}	
			})
		}else{
			//$.messager.alert("错误","请选择行");
			$.messager.popover({msg:'请选择行',type:'alert'});
		}
	}
	
	
	
	
	$('#list-props').datagrid({
		fit:true,
		border:false,
		pagination: true,
	    pageSize:30,
	    pageList:[30,50,100],
		striped:true,
		singleSelect:true,
		idField:'TId',
		rownumbers:true,
		columns:[[
			{field:'TCode',title:'代码',width:150},
			{field:'TDesc',title:'描述',width:150},
			{field:'TProps',title:'字段',width:250},
			{field:'TFormat',title:'格式',width:250}
		]],
		toolbar:[{iconCls:'icon-add',text:'新增',handler:GV.showAddWin_props},
			{iconCls:'icon-edit',text:'修改',handler:GV.showEidtWin_props},
			{iconCls:'icon-remove',text:'删除',handler:GV.showDelWin_props}
		],
		url:$URL,
		queryParams:{
			ClassName:'websys.SensitiveProps',
			QueryName:'Find',
			desc:''
		}
	});
	$('#ss-props').searchbox({
		searcher:function(v){
			$('#list-props').datagrid('load',{ClassName:'websys.SensitiveProps',QueryName:'Find',desc:v})	;
			
		}	,
		'prompt':'代码或描述',
		width:200
	});
	

}


var init=function(){

	initAuth();
	
	initProps();
};
$(function(){
	init();
});