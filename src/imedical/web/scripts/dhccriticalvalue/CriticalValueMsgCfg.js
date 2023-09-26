
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
// underscore 防抖
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
var GV={};
GV.CVTypeJson=[{id:"1",text:"检验"},{id:"2",text:"病理"},{id:"3",text:"心电"},{id:"4",text:"超声"},{id:"5",text:"内镜"},{id:"6",text:"放射"}];
GV.AdmType={"O":"门诊","I":"住院","E":"急诊","H":"体检"};
GV.DaysOfWeekMap={"0":"周日","1":"周一","2":"周二","3":"周三","4":"周四","5":"周五","6":"周六"};
GV.DaysOfWeekJson=[];
$.each(GV.DaysOfWeekMap,function(id,text){
	GV.DaysOfWeekJson.push({id:id,text:text})
})

///显示某科室一次的配置信息
GV.showOneTimeInfo=function(node){
	var hosp=$('#_HospList').combogrid('getValue');
	var hospDesc=$('#_HospList').combogrid('getText');
	if (node){
		var arr=node.id.split("-");
		var type=arr[0],loc=arr[1],times=arr[2];
		var pnode=$('#left_tree').tree('getParent',node.target);
		$('#cfg_list').datagrid('load',{AdmType:type,AdmLoc:loc,SendTimes:times,HospId:hosp});
		$('#cfg_list').datagrid('getPanel').panel('setTitle',hospDesc+' '+GV.AdmType[type]+' '+ pnode.text+' '+node.text+'发送配置');
		GV.current={
			node:node,
			type:type,
			loc:loc,
			times:times,
			locdesc:pnode.text	
			,hosp:hosp
			,hospDesc:hospDesc
			
		}
	}else{
		GV.current={};
		$('#cfg_list').datagrid('load',{HospId:hosp});
		$('#cfg_list').datagrid('getPanel').panel('setTitle',hospDesc+' 发送配置');
	}

}

GV.debounce_showOneTimeInfo=debounce(GV.showOneTimeInfo,300);
function doCheck1045(){
	//检查 消息平台处 危急值（1000）的配置
	$.m({ClassName:'web.DHCAntCVMsgCfg',MethodName:'CheckMsgAction',ActionTypeCode:'1045'},function(rtn){
		if (rtn=="-1"){
			$.messager.alert("提示","消息平台尚未维护危急值重发(1045)消息类型,请前往维护",'info');
		}else if(rtn=="-2"){
			$.messager.confirm("提示","消息平台处危急值重发(1045)消息类型接收对象不为空，需要置空，是否直接置空？",function(r){
				if(r){
					$.m({ClassName:'web.DHCAntCVMsgCfg',MethodName:'FixMsgAction',ActionTypeCode:'1045'},function(rtn){
						if(rtn==1) $.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
					});
				}
			});
		}
	})
}
var init=function(){
	//检查 消息平台处 危急值（1000）的配置
	$.m({ClassName:'web.DHCAntCVMsgCfg',MethodName:'CheckMsgAction'},function(rtn){
		if (rtn=="-1"){
			$.messager.alert("提示","消息平台尚未维护危急值(1000)消息类型,请前往维护");
		}else if(rtn=="-2"){
			$.messager.confirm("提示","消息平台处危急值(1000)消息类型接收对象不为空，需要置空，是否直接置空？",function(r){
				if(r){
					$.m({ClassName:'web.DHCAntCVMsgCfg',MethodName:'FixMsgAction'},function(rtn){
						if(rtn==1) $.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
						doCheck1045();
					});
				}else{
					doCheck1045();	
				}
			});
		}else{
			doCheck1045();	
		}
	})
	GenHospComp('DHC_AntCVMsgCfg');
	$('#_HospList').combogrid('options').onSelect=function(row){
		//console.log("onSelect",row);	
		debounced_reInit();
	}
	$('#_HospList').combogrid('options').onLoadSuccess=function(data){
		$('#_HospList').combogrid('setValue',data.rows[0].HOSPRowId);
		debounced_reInit();
	}	
	
	/*$('#_HospList').combogrid({
		width:250,
		panelWidth:450,
		delay: 500,
		mode: 'remote',
		url:$URL+"?ClassName=web.CTHospital&QueryName=List",
		onBeforeLoad:function(param){
			param.desc=param.q;
			return true;
		},
		onSelect:function(row){
			console.log("onSelect",row);	
			debounced_reInit();
		},
		onLoadSuccess:function(data){
			$('#_HospList').combogrid('setValue',data.rows[0].HOSPRowId);
			debounced_reInit();
		},
		idField:"HOSPRowId",textField:"HOSPDesc",
		columns:[[{field:'HOSPDesc',title:'医院名称',width:200},{field:'HOSPCode',title:'医院代码',width:200}]],
		pagination:true
	})
	*/
	var reInit=function(){
		var hosp=$('#_HospList').combogrid('getValue');
		hosp=parseInt(hosp)>0?parseInt(hosp):'';
		$('#left_tree').tree('options').url=$URL+"?ClassName=web.DHCAntCVMsgCfg&MethodName=LazyTree&HospId="+hosp;
		$('#left_tree').tree('reload');
		//$('#cfg_list').datagrid('loadData',{total:0,rows:[]});
		$('#InsertLoc,#TAdmLoc,#TReceiveObj').combogrid('setRemoteValue',{value:'',text:''});
		GV.showOneTimeInfo();
	}
	var debounced_reInit=debounce(reInit,200);
	
	initEditWin();
	initMM();
	
	$('#left_tree').tree({
		url:$URL+"?ClassName=web.DHCAntCVMsgCfg&MethodName=LazyTree",
		lines:true,
		animate:true,
		onContextMenu: function(e,node){
			e.preventDefault();
			//禁止浏览器的菜单打开
			$(this).tree('select',node.target);
//			var id=node.id
//			if (id.split("-").length==1 ){
//				$('#left_tree_mm').menu('enableItem',$('#mm_insertLoc')[0]);
//				$('#left_tree_mm').menu('disableItem',$('#mm_insertTimes')[0]);
//				$('#left_tree_mm').menu('disableItem',$('#mm_delete')[0]);
//				
//				$('#tb_mm_insertLoc').linkbutton('enable');
//				$('#tb_mm_insertTimes').linkbutton('disable');
//				$('#tb_mm_delete').linkbutton('disable');
//			}else if( id.split("-").length==2  ){
//				$('#left_tree_mm').menu('enableItem',$('#mm_insertLoc')[0]);
//				$('#left_tree_mm').menu('enableItem',$('#mm_insertTimes')[0]);
//				///默认的不能删，
//				if (id.split("-")[1]==0) $('#left_tree_mm').menu('disableItem',$('#mm_delete')[0]);
//				else  $('#left_tree_mm').menu('enableItem',$('#mm_delete')[0]);
//				
//				$('#tb_mm_insertLoc').linkbutton('enable');
//				$('#tb_mm_insertTimes').linkbutton('enable');
//				$('#tb_mm_delete').linkbutton(id.split("-")[1]==0?'disable':'enable');
//			}else{
//				$('#left_tree_mm').menu('enableItem',$('#mm_insertTimes')[0]);
//				$('#left_tree_mm').menu('disableItem',$('#mm_insertLoc')[0]);
//				///第一次的不能删，删了就没意义了
//				if (id.split("-")[2]==1) $('#left_tree_mm').menu('disableItem',$('#mm_delete')[0]);
//				else  $('#left_tree_mm').menu('enableItem',$('#mm_delete')[0]);
//				
//				$('#tb_mm_insertLoc').linkbutton('disable');
//				$('#tb_mm_insertTimes').linkbutton('enable');
//				$('#tb_mm_delete').linkbutton(id.split("-")[2]==1?'disable':'enable');
//			}
			$('#left_tree_mm').menu('show', {
				left: e.pageX,
				top: e.pageY
			});
		},	
		onClick:function(node){
			if($(this).tree('isLeaf',node.target)){
				GV.debounce_showOneTimeInfo(node);
			}
		},
		onSelect:function(node){
			var id=node.id
			if (id.split("-").length==1 ){
				$('#left_tree_mm').menu('enableItem',$('#mm_insertLoc')[0]);
				$('#left_tree_mm').menu('disableItem',$('#mm_insertTimes')[0]);
				$('#left_tree_mm').menu('disableItem',$('#mm_delete')[0]);
				
				$('#tb_mm_insertLoc').linkbutton('enable');
				$('#tb_mm_insertTimes').linkbutton('disable');
				$('#tb_mm_delete').linkbutton('disable');
			}else if( id.split("-").length==2  ){
				$('#left_tree_mm').menu('enableItem',$('#mm_insertLoc')[0]);
				$('#left_tree_mm').menu('enableItem',$('#mm_insertTimes')[0]);
				///默认的不能删，
				if (id.split("-")[1]==0) $('#left_tree_mm').menu('disableItem',$('#mm_delete')[0]);
				else  $('#left_tree_mm').menu('enableItem',$('#mm_delete')[0]);
				
				$('#tb_mm_insertLoc').linkbutton('enable');
				$('#tb_mm_insertTimes').linkbutton('enable');
				$('#tb_mm_delete').linkbutton(id.split("-")[1]==0?'disable':'enable');
			}else{
				$('#left_tree_mm').menu('enableItem',$('#mm_insertTimes')[0]);
				$('#left_tree_mm').menu('disableItem',$('#mm_insertLoc')[0]);
				///第一次的不能删，删了就没意义了
				if (id.split("-")[2]==1) $('#left_tree_mm').menu('disableItem',$('#mm_delete')[0]);
				else  $('#left_tree_mm').menu('enableItem',$('#mm_delete')[0]);
				
				$('#tb_mm_insertLoc').linkbutton('disable');
				$('#tb_mm_insertTimes').linkbutton('enable');
				$('#tb_mm_delete').linkbutton(id.split("-")[2]==1?'disable':'enable');
			}
		},
		onLoadSuccess:function(){
			var sel=$('#left_tree').tree('getSelected');
			if (!sel){
				$('#tb_mm_insertLoc').linkbutton('disable');
				$('#tb_mm_insertTimes').linkbutton('disable');
				$('#tb_mm_delete').linkbutton('disable');
			}
		}
	});
	$('#left_tree_mm').contextmenu(function(e){
		e.preventDefault();
	});
	
	$('#cfg_list').datagrid({
		headerCls:'panel-header-gray',
		title:'发送配置',
		url:$URL+"?ClassName=web.DHCAntCVMsgCfg&QueryName=Find",
		lazy:true,
		fit:true,
		//TId,TAdmLoc,TAdmType,TCVTypes,TEndTime,TReceiveCode,TSendInterval,TSendTimes,TStartTime,TCVTypesDesc,TReceiveDesc
		columns:[[
			{field:"TCVTypesDesc",title:"危急值类型",width:240},
			{field:"TSendInterval",title:"间隔(分钟)",width:80},
			{field:"TDaysOfWeek",title:"星期",width:180,formatter:function(val){
				var arr=val.split(',');
				for (var i=0,len=arr.length;i<len;i++){
					arr[i]=GV.DaysOfWeekMap[arr[i]];
				}
				return arr.join(',');
			}},
			{field:"TStartTime",title:"开始时间",width:80},
			{field:"TEndTime",title:"结束时间",width:80},
			{field:"TReceiveDesc",title:"消息接收者",width:150}
		]],
		pagination:true,
		pageSize:20,
		pageList:[20,50,100],
		rownumbers:true,
		striped:true,
		singleSelect:true,
		onLoadSuccess:function(){
			$('#cfg_list').datagrid('clearSelections');
			if (GV.current && GV.current.times>0){
				$('#cfg_list_tb_add').linkbutton('enable');
			}else{
				$('#cfg_list_tb_add').linkbutton('disable');
			}
			$('#cfg_list_tb_edit,#cfg_list_tb_remove').linkbutton('disable');
		},
		onSelect:function(){
			$('#cfg_list_tb_edit,#cfg_list_tb_remove').linkbutton('enable');
		},
		toolbar:[
			{
				text:'新增',
				iconCls:'icon-add',
				disabled:true,
				id:'cfg_list_tb_add',
				handler:function(){
					GV.setEditVal();
					$('#cfg_edit_win').dialog('open');	
				}
				
			},{
				text:'修改',
				iconCls:'icon-edit',
				disabled:true,
				id:'cfg_list_tb_edit',
				handler:function(){
					var row=$('#cfg_list').datagrid('getSelected')
					if (!row) {
						$.messager.alert("提示","请选择行")	;
						return ;
					}
					GV.setEditVal(row);
					$('#cfg_edit_win').dialog('open');	
				}
				
			},{
				text:'删除',
				iconCls:'icon-remove',
				disabled:true,
				id:'cfg_list_tb_remove',
				handler:function(){
					var row=$('#cfg_list').datagrid('getSelected')
					if (!row) {
						$.messager.alert("提示","请选择行")	;
						return ;
					}
					$.messager.confirm("确定","确定删除此条配置记录吗？",function(r){
						if(r){
							var data={ClassName:"web.DHCAntCVMsgCfg",MethodName:'Delete'};
							data.Id=row.TId;
							$.m(data,function(rtn){
								if (rtn>0){
									$.messager.alert("成功","删除成功",'success');
									$('#cfg_list').datagrid('reload');
								}else{
									$.messager.alert("失败","删除失败<br>"+rtn.split("^")[1]||rtn,'error')	
								}
							})
						}
					})
				}
				
			}
		]
	});
	//$('#Loading').fadeOut('fast');

}

var initEditWin=function(){
	$('#cfg_edit_win').dialog({
		buttons:[{
			text:'保存',
			handler:function(){
				GV.save();
			}
		},{
			text:'关闭',
			handler:function(){
				$('#cfg_edit_win').dialog('close');
			}
		}],
		width:350
		
	})
	$('#TAdmType').combobox({
		data:[{id:'O',text:'门诊'},{id:'E',text:'急诊'},{id:'I',text:'住院'},{id:'H',text:'体检'}],
		valueField:'id',textField:'text',editable:false,panelHeight:'auto'
	})
	$('#TAdmLoc').combogrid({
		panelWidth:450,
		delay: 500,
		mode: 'remote',
		url:$URL+"?ClassName=web.DHCAntCVMsgCfg&QueryName=FindLoc",
		onBeforeLoad:function(param){
			param.desc=param.q;
			var hosp=$('#_HospList').combogrid('getValue');
			hosp=parseInt(hosp)>0?parseInt(hosp):'';
			param.HospId=hosp;
			return true;
		},
		idField:"LocId",textField:"LocDesc",
		columns:[[{field:'LocDesc',title:'科室名称',width:200},{field:'LocCode',title:'科室代码',width:200}]],
		pagination:true
	})
	$('#TSendTimes').numberbox({min:1,max:5});
	$("#TSendInterval").numberbox({min:0,max:60*24-1,required:true});
	//取配置的危急值类型
	$.q({
		ClassName:'web.DHCAntCVOptions',QueryName:'Find',OptsType:'CVType'
	},function(ret){
		if (ret && ret.rows ){
			GV.CVTypeJson=[];
			$.each(ret.rows,function(ind,item){
				GV.CVTypeJson.push({id:item.TCode,text:item.TDesc});
			})
		}
		$('#TCVTypes').combobox({
			data:GV.CVTypeJson,
			valueField:'id',textField:'text',editable:false,multiple:true,panelHeight:'auto',
			required:true
		})
	})
	$('#TDaysOfWeek').combobox({ //星期
		data:GV.DaysOfWeekJson,
		valueField:'id',textField:'text',editable:false,multiple:true,panelHeight:'auto'
	})
	$("#TStartTime").timespinner({width:200,showSeconds:true});
	$("#TEndTime").timespinner({width:200,showSeconds:true});
	$('#TReceiveType').combobox({
		data:[{id:'M',text:'消息平台接收对象'},{id:'L',text:'科室'},{id:'U',text:'用户'}],
		valueField:'id',textField:'text',editable:false,
		onChange:function(nv,ov){
			//ReInitTReceiveObj(nv);
			$('#TReceiveObj').combogrid('setValue','')
			$('#TReceiveObj').combogrid({
				queryParams:{rectype:nv}	
			})
		},
		value:"M"
	})
	$('#TReceiveObj').combogrid({
		panelWidth:450,
		delay: 500,
		mode: 'remote',
		url:$URL+"?ClassName=web.DHCAntCVMsgCfg&QueryName=FindReceiveObj",
		onBeforeLoad:function(param){
			param.desc=param.q;
			param.rectype=$('#TReceiveType').combobox('getValue');
			var hosp=$('#_HospList').combogrid('getValue');
			hosp=parseInt(hosp)>0?parseInt(hosp):'';
			param.HospId=hosp;
			return true;
		},
		idField:"ID",textField:"Desc",
		columns:[[{field:'Code',title:'代码',width:200},{field:'Desc',title:'名称',width:200}]],
		pagination:true
	})

	
	GV.setEditVal=function(row){
		if (row){
			$('#TId').val(row.TId);
			$('#TAdmType').combobox('setValue',GV.current.type);
			
			if (GV.current.loc>0){
				//$('#TAdmLoc').combogrid('grid').datagrid('reload',{'q':GV.current.locdesc});
				//$('#TAdmLoc').combogrid('setValue',GV.current.loc);
				$('#TAdmLoc').combogrid('setRemoteValue',{value:GV.current.loc,text:GV.current.locdesc});
			}else{
				$('#TAdmLoc').combogrid('setRemoteValue',{value:'',text:''});
			}
			
			$('#TSendTimes').numberbox('setValue',GV.current.times);
			$("#TSendInterval").numberbox('setValue',row.TSendInterval);
			$('#TCVTypes').combobox('setValues',row.TCVTypes.split(","));
			$('#TDaysOfWeek').combobox('setValues',row.TDaysOfWeek?row.TDaysOfWeek.split(","):[]); //星期
			$("#TStartTime").timespinner('setValue',row.TStartTime);
			$("#TEndTime").timespinner('setValue',row.TEndTime);
			var TReceiveCode=row.TReceiveCode;
			var TReceiveDesc=row.TReceiveDesc;
			var RTypeVal=TReceiveCode.split("-")[0],
				RObjVal=TReceiveCode.split("-")[1],
				RObjDesc=TReceiveDesc.split("-")[1];
			if (RTypeVal=='M') RObjDesc=TReceiveDesc; //消息平台接收对象显示的text没有- 只是描述
			
			$('#TReceiveType').combobox('setValue',RTypeVal);
			//ReInitTReceiveObj(RTypeVal);
			//$('#TReceiveObj').combogrid('options').queryParams.rectype=RTypeVal;
			//$('#TReceiveObj').combogrid('grid').datagrid('reload',{'q':RObjDesc});
			//$('#TReceiveObj').combogrid('setValue',RObjVal);
			$('#TReceiveObj').combogrid('setRemoteValue',{value:RObjVal,text:RObjDesc});
			
		}else{
			$('#TId').val('');
			$('#TAdmType').combobox('setValue',GV.current.type);
			if (GV.current.loc>0){
				//$('#TAdmLoc').combogrid('grid').datagrid('reload',{'q':GV.current.locdesc});
				//$('#TAdmLoc').combogrid('setValue',GV.current.loc);
				$('#TAdmLoc').combogrid('setRemoteValue',{value:GV.current.loc,text:GV.current.locdesc});
			}else{
				$('#TAdmLoc').combogrid('setValue','');
			}

			
			$('#TSendTimes').numberbox('setValue',GV.current.times);
			$("#TSendInterval").numberbox('setValue','');
			$('#TCVTypes').combobox('setValues',[]);
			$('#TDaysOfWeek').combobox('setValues',[]); //星期
			$("#TStartTime").timespinner('setValue','');
			$("#TEndTime").timespinner('setValue','');
			$('#TReceiveType').combobox('setValue','');
			$('#TReceiveObj').combogrid({queryParams:{rectype:""}});
			$('#TReceiveObj').combogrid('setValue','');
		}
		$('#TAdmType').combobox('disable');
		$('#TAdmLoc').combogrid('disable');
		$('#TSendTimes').numberbox('disable');
		if (GV.current.times==1){
			$("#TSendInterval").numberbox('options').min=0;
			$("#TSendInterval").numberbox('setValue',0).numberbox('validate').numberbox('disable');
		}else{
			$("#TSendInterval").numberbox('options').min=1;
			$("#TSendInterval").numberbox('enable').numberbox('validate');
		}
	}
	GV.save=function(){
		
		
		var data={ClassName:"web.DHCAntCVMsgCfg",MethodName:'Save'};
		data.Id=$('#TId').val();
		data.AdmType=$('#TAdmType').combobox('getValue');
		data.AdmLoc=$('#TAdmLoc').combogrid('getValue');
		data.SendTimes=$('#TSendTimes').numberbox('getValue');
		data.SendInterval=$('#TSendInterval').numberbox('getValue');
		if (!$('#TSendInterval').numberbox('isValid')){$.messager.popover({msg:'请输入发送间隔(分钟)',type:'alert'});return;}
		var CVTypes=$('#TCVTypes').combobox('getValues');
		if (CVTypes) data.CVTypes=CVTypes.join(",");
		if (!$('#TCVTypes').combobox('isValid')) {$.messager.popover({msg:'请选择危急值类型',type:'alert'});return;}
		var DaysOfWeek=$('#TDaysOfWeek').combobox('getValues'); //星期
		if (DaysOfWeek) data.DaysOfWeek=DaysOfWeek.join(",");	
		data.StartTime=$("#TStartTime").timespinner('getValue');
		data.EndTime=$("#TEndTime").timespinner('getValue');
		var ReceiveType= $('#TReceiveType').combobox('getValue');
		var TReceiveObj=$('#TReceiveObj').combogrid('getValue');
		data.ReceiveCode=ReceiveType+"-"+TReceiveObj;
		
		
		var hosp=$('#_HospList').combogrid('getValue');
		hosp=parseInt(hosp)>0?parseInt(hosp):'';
		data.HospId=hosp;
		
		
		//console.log(data);

		$.m(data,function(rtn){
			console.log(rtn)	
			if (rtn>0){
				$.messager.alert("成功","保存成功",'success');
				$('#cfg_edit_win').dialog('close');
				$('#cfg_list').datagrid('reload');
			}else{
				$.messager.alert("失败","保存失败<br>"+rtn.split("^")[1]||rtn,'error')	
			}
		})
	}
	
}
///初始化右键菜单用到的一些方法等
var initMM=function(){
	$('#InsertLoc').combogrid({
		panelWidth:450,
		delay: 500,
		mode: 'remote',
		url:$URL+"?ClassName=web.DHCAntCVMsgCfg&QueryName=FindLoc&exceptexist=1",
		onBeforeLoad:function(param){
			var hosp=$('#_HospList').combogrid('getValue');
			hosp=parseInt(hosp)>0?parseInt(hosp):'';
			param.HospId=hosp;
			param.desc=param.q;
			return true;
		},
		idField:"LocId",textField:"LocDesc",
		columns:[[{field:'LocDesc',title:'科室名称',width:200},{field:'LocCode',title:'科室代码',width:200}]],
		pagination:true
	})
	$('#insert_loc_win').dialog({
		buttons:[{
			text:'保存',
			handler:function(){
				var node=$('#left_tree').tree('getSelected');
				var data={ClassName:"web.DHCAntCVMsgCfg",MethodName:'Save'};

				data.AdmType=node.id.split("-")[0];
				data.AdmLoc=$('#InsertLoc').combogrid('getValue');
				data.SendTimes=1;
				data.SendInterval=0;
				var hosp=$('#_HospList').combogrid('getValue');
				hosp=parseInt(hosp)>0?parseInt(hosp):'';
				data.HospId=hosp;
				
				$.m(data,function(rtn){
					console.log(rtn)	
					if (rtn>0){
						$.messager.alert("成功","保存成功",'success');
						$('#insert_loc_win').dialog('close');
						if (node.id.length==1) {$('#left_tree').tree('reload',node.target);}
						else  {
							var pnode=$('#left_tree').tree('getParent',node.target);
							$('#left_tree').tree('reload',pnode.target);
						}
						
					}else{
						$.messager.alert("失败","保存失败<br>"+rtn.split("^")[1]||rtn,'error')	
					}
				})
			}
		},{
			text:'关闭',
			handler:function(){
				$('#insert_loc_win').dialog('close');
			}
		}],
		width:350,
		onOpen:function(){
			var node=$('#left_tree').tree('getSelected');
			var AdmType=node.id.split("-")[0];
			$('#InsertLoc').combogrid('options').queryParams.admType=AdmType;
			$('#InsertLoc').combogrid('setValue','');
			$('#InsertLoc').combogrid('options').keyHandler.query.call($('#InsertLoc')[0],'');
			
		}
	})
	GV.mm_insertLoc=function(){
		$('#insert_loc_win').dialog('open');
	}
	GV.mm_insertTimes=function(){
		var node=$('#left_tree').tree('getSelected');
		var arr=node.id.split("-");
		var hosp=$('#_HospList').combogrid('getValue');
		hosp=parseInt(hosp)>0?parseInt(hosp):'';
		
		var times=$.m({ClassName:'web.DHCAntCVMsgCfg',MethodName:'GetLocTimes',type:arr[0],loc:arr[1],HospId:hosp},false);
		times=parseInt(times);
		$.messager.confirm("确定","确定添加第"+(times+1)+"次发送配置么?",function(r){
			if(r){
				var data={ClassName:"web.DHCAntCVMsgCfg",MethodName:'Save'};
				data.AdmType=arr[0];
				data.AdmLoc=arr[1];
				data.SendTimes=times+1;
				data.HospId=hosp;
				$.m(data,function(rtn){
					console.log(rtn)	
					if (rtn>0){
						$.messager.alert("成功","保存成功",'success');
						if (arr.length==2) {$('#left_tree').tree('reload',node.target);}
						else  {
							var pnode=$('#left_tree').tree('getParent',node.target);
							$('#left_tree').tree('reload',pnode.target);
						}
						
					}else{
						$.messager.alert("失败","保存失败<br>"+rtn.split("^")[1]||rtn,'error')	
					}
				})	
			}
		})
	}
	
	GV.mm_delete=function(){
		var hosp=$('#_HospList').combogrid('getValue');
		var hospDesc=$('#_HospList').combogrid('getText');
	
		var node=$('#left_tree').tree('getSelected');
		var arr=node.id.split("-");
		if (arr.length==2){
			var msg="确定删除"+hospDesc+' '+GV.AdmType[arr[0]]+" "+node.text+" 发送配置么？"
		}else if(arr.length==3){
			var pnode=$('#left_tree').tree('getParent',node.target);
			var msg="确定删除"+hospDesc+' '+GV.AdmType[arr[0]]+" "+pnode.text+" 第"+arr[2]+"次发送配置么？"
		}else{return;}

		$.messager.confirm("确定",msg,function(r){
			if(r){
				var data={ClassName:"web.DHCAntCVMsgCfg",MethodName:'DeleteByAdmTypeLocTimes'};
				data.key=node.id;
				data.HospId=hosp;
				$.m(data,function(rtn){
					if (rtn>0){
						$.messager.alert("成功","删除成功",'success');
						var pnode=$('#left_tree').tree('getParent',node.target);
						$('#left_tree').tree('reload',pnode.target);
						GV.showOneTimeInfo() ; //右边也重新加载
					}else{
						$.messager.alert("失败","删除失败<br>"+rtn.split("^")[1]||rtn,'error');
					}
				})	
			}

		})
	}
}


$(init);