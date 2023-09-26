
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
// underscore ����
function debounce(func, wait, immediate) {

    var timeout, result;

    var debounced = function () {
        var context = this;
        var args = arguments;

        if (timeout) clearTimeout(timeout);
        if (immediate) {
            // ����Ѿ�ִ�й�������ִ��
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
GV.CVTypeJson=[{id:"1",text:"����"},{id:"2",text:"����"},{id:"3",text:"�ĵ�"},{id:"4",text:"����"},{id:"5",text:"�ھ�"},{id:"6",text:"����"}];
GV.AdmType={"O":"����","I":"סԺ","E":"����","H":"���"};
GV.DaysOfWeekMap={"0":"����","1":"��һ","2":"�ܶ�","3":"����","4":"����","5":"����","6":"����"};
GV.DaysOfWeekJson=[];
$.each(GV.DaysOfWeekMap,function(id,text){
	GV.DaysOfWeekJson.push({id:id,text:text})
})

///��ʾĳ����һ�ε�������Ϣ
GV.showOneTimeInfo=function(node){
	var hosp=$('#_HospList').combogrid('getValue');
	var hospDesc=$('#_HospList').combogrid('getText');
	if (node){
		var arr=node.id.split("-");
		var type=arr[0],loc=arr[1],times=arr[2];
		var pnode=$('#left_tree').tree('getParent',node.target);
		$('#cfg_list').datagrid('load',{AdmType:type,AdmLoc:loc,SendTimes:times,HospId:hosp});
		$('#cfg_list').datagrid('getPanel').panel('setTitle',hospDesc+' '+GV.AdmType[type]+' '+ pnode.text+' '+node.text+'��������');
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
		$('#cfg_list').datagrid('getPanel').panel('setTitle',hospDesc+' ��������');
	}

}

GV.debounce_showOneTimeInfo=debounce(GV.showOneTimeInfo,300);
function doCheck1045(){
	//��� ��Ϣƽ̨�� Σ��ֵ��1000��������
	$.m({ClassName:'web.DHCAntCVMsgCfg',MethodName:'CheckMsgAction',ActionTypeCode:'1045'},function(rtn){
		if (rtn=="-1"){
			$.messager.alert("��ʾ","��Ϣƽ̨��δά��Σ��ֵ�ط�(1045)��Ϣ����,��ǰ��ά��",'info');
		}else if(rtn=="-2"){
			$.messager.confirm("��ʾ","��Ϣƽ̨��Σ��ֵ�ط�(1045)��Ϣ���ͽ��ն���Ϊ�գ���Ҫ�ÿգ��Ƿ�ֱ���ÿգ�",function(r){
				if(r){
					$.m({ClassName:'web.DHCAntCVMsgCfg',MethodName:'FixMsgAction',ActionTypeCode:'1045'},function(rtn){
						if(rtn==1) $.messager.popover({msg: '����ɹ���',type:'success',timeout: 1000});
					});
				}
			});
		}
	})
}
var init=function(){
	//��� ��Ϣƽ̨�� Σ��ֵ��1000��������
	$.m({ClassName:'web.DHCAntCVMsgCfg',MethodName:'CheckMsgAction'},function(rtn){
		if (rtn=="-1"){
			$.messager.alert("��ʾ","��Ϣƽ̨��δά��Σ��ֵ(1000)��Ϣ����,��ǰ��ά��");
		}else if(rtn=="-2"){
			$.messager.confirm("��ʾ","��Ϣƽ̨��Σ��ֵ(1000)��Ϣ���ͽ��ն���Ϊ�գ���Ҫ�ÿգ��Ƿ�ֱ���ÿգ�",function(r){
				if(r){
					$.m({ClassName:'web.DHCAntCVMsgCfg',MethodName:'FixMsgAction'},function(rtn){
						if(rtn==1) $.messager.popover({msg: '����ɹ���',type:'success',timeout: 1000});
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
		columns:[[{field:'HOSPDesc',title:'ҽԺ����',width:200},{field:'HOSPCode',title:'ҽԺ����',width:200}]],
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
			//��ֹ������Ĳ˵���
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
//				///Ĭ�ϵĲ���ɾ��
//				if (id.split("-")[1]==0) $('#left_tree_mm').menu('disableItem',$('#mm_delete')[0]);
//				else  $('#left_tree_mm').menu('enableItem',$('#mm_delete')[0]);
//				
//				$('#tb_mm_insertLoc').linkbutton('enable');
//				$('#tb_mm_insertTimes').linkbutton('enable');
//				$('#tb_mm_delete').linkbutton(id.split("-")[1]==0?'disable':'enable');
//			}else{
//				$('#left_tree_mm').menu('enableItem',$('#mm_insertTimes')[0]);
//				$('#left_tree_mm').menu('disableItem',$('#mm_insertLoc')[0]);
//				///��һ�εĲ���ɾ��ɾ�˾�û������
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
				///Ĭ�ϵĲ���ɾ��
				if (id.split("-")[1]==0) $('#left_tree_mm').menu('disableItem',$('#mm_delete')[0]);
				else  $('#left_tree_mm').menu('enableItem',$('#mm_delete')[0]);
				
				$('#tb_mm_insertLoc').linkbutton('enable');
				$('#tb_mm_insertTimes').linkbutton('enable');
				$('#tb_mm_delete').linkbutton(id.split("-")[1]==0?'disable':'enable');
			}else{
				$('#left_tree_mm').menu('enableItem',$('#mm_insertTimes')[0]);
				$('#left_tree_mm').menu('disableItem',$('#mm_insertLoc')[0]);
				///��һ�εĲ���ɾ��ɾ�˾�û������
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
		title:'��������',
		url:$URL+"?ClassName=web.DHCAntCVMsgCfg&QueryName=Find",
		lazy:true,
		fit:true,
		//TId,TAdmLoc,TAdmType,TCVTypes,TEndTime,TReceiveCode,TSendInterval,TSendTimes,TStartTime,TCVTypesDesc,TReceiveDesc
		columns:[[
			{field:"TCVTypesDesc",title:"Σ��ֵ����",width:240},
			{field:"TSendInterval",title:"���(����)",width:80},
			{field:"TDaysOfWeek",title:"����",width:180,formatter:function(val){
				var arr=val.split(',');
				for (var i=0,len=arr.length;i<len;i++){
					arr[i]=GV.DaysOfWeekMap[arr[i]];
				}
				return arr.join(',');
			}},
			{field:"TStartTime",title:"��ʼʱ��",width:80},
			{field:"TEndTime",title:"����ʱ��",width:80},
			{field:"TReceiveDesc",title:"��Ϣ������",width:150}
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
				text:'����',
				iconCls:'icon-add',
				disabled:true,
				id:'cfg_list_tb_add',
				handler:function(){
					GV.setEditVal();
					$('#cfg_edit_win').dialog('open');	
				}
				
			},{
				text:'�޸�',
				iconCls:'icon-edit',
				disabled:true,
				id:'cfg_list_tb_edit',
				handler:function(){
					var row=$('#cfg_list').datagrid('getSelected')
					if (!row) {
						$.messager.alert("��ʾ","��ѡ����")	;
						return ;
					}
					GV.setEditVal(row);
					$('#cfg_edit_win').dialog('open');	
				}
				
			},{
				text:'ɾ��',
				iconCls:'icon-remove',
				disabled:true,
				id:'cfg_list_tb_remove',
				handler:function(){
					var row=$('#cfg_list').datagrid('getSelected')
					if (!row) {
						$.messager.alert("��ʾ","��ѡ����")	;
						return ;
					}
					$.messager.confirm("ȷ��","ȷ��ɾ���������ü�¼��",function(r){
						if(r){
							var data={ClassName:"web.DHCAntCVMsgCfg",MethodName:'Delete'};
							data.Id=row.TId;
							$.m(data,function(rtn){
								if (rtn>0){
									$.messager.alert("�ɹ�","ɾ���ɹ�",'success');
									$('#cfg_list').datagrid('reload');
								}else{
									$.messager.alert("ʧ��","ɾ��ʧ��<br>"+rtn.split("^")[1]||rtn,'error')	
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
			text:'����',
			handler:function(){
				GV.save();
			}
		},{
			text:'�ر�',
			handler:function(){
				$('#cfg_edit_win').dialog('close');
			}
		}],
		width:350
		
	})
	$('#TAdmType').combobox({
		data:[{id:'O',text:'����'},{id:'E',text:'����'},{id:'I',text:'סԺ'},{id:'H',text:'���'}],
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
		columns:[[{field:'LocDesc',title:'��������',width:200},{field:'LocCode',title:'���Ҵ���',width:200}]],
		pagination:true
	})
	$('#TSendTimes').numberbox({min:1,max:5});
	$("#TSendInterval").numberbox({min:0,max:60*24-1,required:true});
	//ȡ���õ�Σ��ֵ����
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
	$('#TDaysOfWeek').combobox({ //����
		data:GV.DaysOfWeekJson,
		valueField:'id',textField:'text',editable:false,multiple:true,panelHeight:'auto'
	})
	$("#TStartTime").timespinner({width:200,showSeconds:true});
	$("#TEndTime").timespinner({width:200,showSeconds:true});
	$('#TReceiveType').combobox({
		data:[{id:'M',text:'��Ϣƽ̨���ն���'},{id:'L',text:'����'},{id:'U',text:'�û�'}],
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
		columns:[[{field:'Code',title:'����',width:200},{field:'Desc',title:'����',width:200}]],
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
			$('#TDaysOfWeek').combobox('setValues',row.TDaysOfWeek?row.TDaysOfWeek.split(","):[]); //����
			$("#TStartTime").timespinner('setValue',row.TStartTime);
			$("#TEndTime").timespinner('setValue',row.TEndTime);
			var TReceiveCode=row.TReceiveCode;
			var TReceiveDesc=row.TReceiveDesc;
			var RTypeVal=TReceiveCode.split("-")[0],
				RObjVal=TReceiveCode.split("-")[1],
				RObjDesc=TReceiveDesc.split("-")[1];
			if (RTypeVal=='M') RObjDesc=TReceiveDesc; //��Ϣƽ̨���ն�����ʾ��textû��- ֻ������
			
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
			$('#TDaysOfWeek').combobox('setValues',[]); //����
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
		if (!$('#TSendInterval').numberbox('isValid')){$.messager.popover({msg:'�����뷢�ͼ��(����)',type:'alert'});return;}
		var CVTypes=$('#TCVTypes').combobox('getValues');
		if (CVTypes) data.CVTypes=CVTypes.join(",");
		if (!$('#TCVTypes').combobox('isValid')) {$.messager.popover({msg:'��ѡ��Σ��ֵ����',type:'alert'});return;}
		var DaysOfWeek=$('#TDaysOfWeek').combobox('getValues'); //����
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
				$.messager.alert("�ɹ�","����ɹ�",'success');
				$('#cfg_edit_win').dialog('close');
				$('#cfg_list').datagrid('reload');
			}else{
				$.messager.alert("ʧ��","����ʧ��<br>"+rtn.split("^")[1]||rtn,'error')	
			}
		})
	}
	
}
///��ʼ���Ҽ��˵��õ���һЩ������
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
		columns:[[{field:'LocDesc',title:'��������',width:200},{field:'LocCode',title:'���Ҵ���',width:200}]],
		pagination:true
	})
	$('#insert_loc_win').dialog({
		buttons:[{
			text:'����',
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
						$.messager.alert("�ɹ�","����ɹ�",'success');
						$('#insert_loc_win').dialog('close');
						if (node.id.length==1) {$('#left_tree').tree('reload',node.target);}
						else  {
							var pnode=$('#left_tree').tree('getParent',node.target);
							$('#left_tree').tree('reload',pnode.target);
						}
						
					}else{
						$.messager.alert("ʧ��","����ʧ��<br>"+rtn.split("^")[1]||rtn,'error')	
					}
				})
			}
		},{
			text:'�ر�',
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
		$.messager.confirm("ȷ��","ȷ����ӵ�"+(times+1)+"�η�������ô?",function(r){
			if(r){
				var data={ClassName:"web.DHCAntCVMsgCfg",MethodName:'Save'};
				data.AdmType=arr[0];
				data.AdmLoc=arr[1];
				data.SendTimes=times+1;
				data.HospId=hosp;
				$.m(data,function(rtn){
					console.log(rtn)	
					if (rtn>0){
						$.messager.alert("�ɹ�","����ɹ�",'success');
						if (arr.length==2) {$('#left_tree').tree('reload',node.target);}
						else  {
							var pnode=$('#left_tree').tree('getParent',node.target);
							$('#left_tree').tree('reload',pnode.target);
						}
						
					}else{
						$.messager.alert("ʧ��","����ʧ��<br>"+rtn.split("^")[1]||rtn,'error')	
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
			var msg="ȷ��ɾ��"+hospDesc+' '+GV.AdmType[arr[0]]+" "+node.text+" ��������ô��"
		}else if(arr.length==3){
			var pnode=$('#left_tree').tree('getParent',node.target);
			var msg="ȷ��ɾ��"+hospDesc+' '+GV.AdmType[arr[0]]+" "+pnode.text+" ��"+arr[2]+"�η�������ô��"
		}else{return;}

		$.messager.confirm("ȷ��",msg,function(r){
			if(r){
				var data={ClassName:"web.DHCAntCVMsgCfg",MethodName:'DeleteByAdmTypeLocTimes'};
				data.key=node.id;
				data.HospId=hosp;
				$.m(data,function(rtn){
					if (rtn>0){
						$.messager.alert("�ɹ�","ɾ���ɹ�",'success');
						var pnode=$('#left_tree').tree('getParent',node.target);
						$('#left_tree').tree('reload',pnode.target);
						GV.showOneTimeInfo() ; //�ұ�Ҳ���¼���
					}else{
						$.messager.alert("ʧ��","ɾ��ʧ��<br>"+rtn.split("^")[1]||rtn,'error');
					}
				})	
			}

		})
	}
}


$(init);