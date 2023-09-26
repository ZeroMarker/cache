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
GV.SendModelJson=[{id:"I",text:"��Ϣϵͳ"},{id:"S",text:"�ֻ�����"},{id:"E",text:"��������"},{id:"ENS",text:"����ƽ̨"}];
GV.AdmTypeJson=[{id:"O",text:"����"},{id:"E",text:"����"},{id:"I",text:"סԺ"},{id:"H",text:"���"}];
GV.TargetRoleTypeJson=[{id:'',text:'�Զ��ж�'},{id:'AdmLoc',text:'�������'},{id:'OrdLoc',text:'��ҽ������'},{id:'Any',text:'�κν�ɫ'},{id:'Other',text:'����'}];
GV.ReceiveTypeJson=[{id:'M',text:'��Ϣƽ̨���ն���'},{id:'L',text:'����(��¼)'},{id:'LCP',text:'������Ա'},{id:'LCPD',text:'����ҽ��'},{id:'LCPN',text:'���һ�ʿ'},{id:'U',text:'�û�'},{id:'G',text:'��ȫ��'}];
GV.current={};
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
		}]
		
	})
	$('#AdmHospital').combogrid({
		panelWidth:450,
		delay: 500,
		mode: 'remote',
		url:$URL,
		queryParams:{ClassName:'websys.DHCMessageReceiveCfgMgr',QueryName:'FindHospital'},
		onBeforeLoad:function(param){
			param.desc=param.q;
			return true;
		},
		idField:"TId",textField:"TDesc",
		columns:[[{field:'TDesc',title:'ҽԺ����',width:200},{field:'TCode',title:'ҽԺ����',width:200}]],
		pagination:true
		,onChange:function(nv,ov){
			$('#AdmLoc').combogrid('setRemoteValue',{value:'',text:''})
		}
	})
	$('#AdmType').combobox({
		data:[{id:'',text:'Ĭ��'}].concat(GV.AdmTypeJson),
		valueField:'id',textField:'text',editable:false,panelHeight:'auto'
		,onChange:function(nv,ov){
			$('#AdmLoc').combogrid('setRemoteValue',{value:'',text:''})
		},
		value:''
	})
	$('#AdmLoc').combogrid({
		panelWidth:450,
		delay: 500,
		mode: 'remote',
		url:$URL+"?ClassName=websys.DHCMessageReceiveCfgMgr&QueryName=FindLoc",
		onBeforeLoad:function(param){
			param.desc=param.q;
			param.admType=$('#AdmType').combobox('getValue');
			param.admHospital=$('#AdmHospital').combogrid('getValue');
			return true;
		},
		idField:"LocId",textField:"LocDesc",
		columns:[[{field:'LocDesc',title:'��������',width:200},{field:'LocCode',title:'���Ҵ���',width:200}]],
		pagination:true
	})
	$('#SendModel').combobox({
		data:GV.SendModelJson,
		valueField:'id',textField:'text',editable:false,panelHeight:'auto'
	})

	
	$("#TimeStart").timespinner({showSeconds:true});
	$("#TimeEnd").timespinner({showSeconds:true});
	
	$('#ReceiveType').combobox({
		data:GV.ReceiveTypeJson,
		valueField:'id',textField:'text',editable:false,panelHeight:'auto',
		onChange:function(nv,ov){
			$('#ReceiveObj').combogrid('options').queryParams={rectype:nv}
			$('#ReceiveObj').combogrid('setRemoteValue',{value:'',text:''})
		},
		value:"M"
	})
	$('#ReceiveObj').combogrid({
		panelWidth:450,
		delay: 500,
		mode: 'remote',
		url:$URL+"?ClassName=websys.DHCMessageReceiveCfgMgr&QueryName=FindReceiveObj",
		onBeforeLoad:function(param){
			param.desc=param.q;
			param.rectype=$('#ReceiveType').combobox('getValue');
			return true;
		},
		idField:"ID",textField:"Desc",
		columns:[[{field:'Desc',title:'����',width:200},{field:'Code',title:'����',width:200}]],
		pagination:true
	})
	
	$('#TragetRoleType').combobox({
		data:GV.TargetRoleTypeJson,
		valueField:'id',textField:'text',editable:false,panelHeight:'auto',
		onChange:function(nv,ov){
			if (nv=="Other"){
				$('#TragetRoleLoc').combogrid('enable');
				$('#TragetRoleGroup').combogrid('enable');
			}else if(ov=="Other"){
				$('#TragetRoleLoc').combogrid('disable');
				$('#TragetRoleGroup').combogrid('disable');
			}
		},
		value:""
	})
	
	$('#TragetRoleLoc').combogrid({
		panelWidth:450,
		delay: 500,
		mode: 'remote',
		url:$URL+"?ClassName=websys.DHCMessageReceiveCfgMgr&QueryName=FindReceiveObj",
		onBeforeLoad:function(param){
			param.desc=param.q;
			param.rectype='L';
			return true;
		},
		idField:"ID",textField:"Desc",
		columns:[[{field:'Desc',title:'��������',width:200},{field:'Code',title:'���Ҵ���',width:200}]],
		pagination:true,
		disabled:true
	})
	$('#TragetRoleGroup').combogrid({
		panelWidth:450,
		delay: 500,
		mode: 'remote',
		url:$URL+"?ClassName=websys.DHCMessageReceiveCfgMgr&QueryName=FindReceiveObj",
		onBeforeLoad:function(param){
			param.desc=param.q;
			param.rectype='G';
			return true;
		},
		idField:"ID",textField:"Desc",
		columns:[[{field:'Desc',title:'��ȫ������',width:200},{field:'Code',title:'����',width:200}]],
		pagination:true,
		disabled:true
		
	})
	
	

	
	GV.setEditVal=function(row){
		if (row){
			$('#Id').val(row.TId);
			$('#BizModel').val(row.TBizModel);
			if (row.TAdmHospital==0){
				$('#AdmHospital').combogrid('setRemoteValue',{value:'',text:''});	
			}else{
				$('#AdmHospital').combogrid('setRemoteValue',{value:row.TAdmHospital,text:row.TAdmHospitalDesc});
			}
			
			if (row.TAdmType==0){
				$('#AdmType').combobox('setValue','');	
			}else{
				$('#AdmType').combobox('setValue',row.TAdmType);
			}
			
			if (row.TAdmLoc==0){
				$('#AdmLoc').combogrid('setRemoteValue',{value:'',text:''});	
			}else{
				$('#AdmLoc').combogrid('setRemoteValue',{value:row.TAdmLoc,text:row.TAdmLocDesc});
			}
			
			$("#TimeStart").timespinner('setValue',row.TTimeStart);
			$("#TimeEnd").timespinner('setValue',row.TTimeEnd);
			
			$('#SendModel').combobox('setValue',row.TSendModel);
			
			var TReceiveCode=row.TReceiveCode;
			var TReceiveDesc=row.TReceiveDesc;
			var RTypeVal=TReceiveCode.split("-")[0],
				RObjVal=TReceiveCode.split("-")[1],
				RObjDesc=TReceiveDesc.split("-")[RTypeVal=='M'?0:1];
			$('#ReceiveType').combobox('setValue',RTypeVal);
			$('#ReceiveObj').combogrid('options').queryParams.rectype=RTypeVal;
			$('#ReceiveObj').combogrid('setRemoteValue',{value:RObjVal,text:RObjDesc});
			
			if ($.hisui.indexOfArray(GV.TargetRoleTypeJson,'id',row.TTargetRole)>-1){
				$('#TragetRoleType').combobox('setValue',row.TTargetRole);
				$('#TragetRoleLoc').combogrid('setRemoteValue',{value:'',text:''});
				$('#TragetRoleGroup').combogrid('setRemoteValue',{value:'',text:''});
			}else{
				$('#TragetRoleType').combobox('setValue','Other');
				var loc="",group="";
				if (row.TTargetRole.indexOf('L')>-1) loc=(parseInt(row.TTargetRole.split('L')[1])||'')+'';
				if (row.TTargetRole.indexOf('G')>-1) group=(parseInt(row.TTargetRole.split('G')[1])||'')+'';
				$('#TragetRoleLoc').combogrid('setRemoteValue',{value:loc,text:loc==''?'':(row.TTargetRoleDesc.split(',')[0]||'')});
				$('#TragetRoleGroup').combogrid('setRemoteValue',{value:loc,text:group==''?'':(row.TTargetRoleDesc.split(',')[loc==''?0:1]||'')});
			}
			
			$('#Note').val(row.TNote);
		}else{
			$('#Id').val('');
			$('#BizModel').val(GV.current.bizModel||BizModel||'');
			if (GV.current.admHospital==0){
				$('#AdmHospital').combogrid('setRemoteValue',{value:'',text:''});	
			}else{
				$('#AdmHospital').combogrid('setRemoteValue',{value:GV.current.admHospital,text:GV.current.admHospitalDesc});
			}
			
			if (GV.current.admType==0){
				$('#AdmType').combobox('setValue','');	
			}else{
				$('#AdmType').combobox('setValue',GV.current.admType);
			}
			
			if (GV.current.admLoc==0){
				$('#AdmLoc').combogrid('setRemoteValue',{value:'',text:''});	
			}else{
				$('#AdmLoc').combogrid('setRemoteValue',{value:GV.current.admLoc,text:GV.current.admLocDesc});
			}
			
			$("#TimeStart").timespinner('setValue','');
			$("#TimeEnd").timespinner('setValue','');
			
			$('#SendModel').combobox('setValue','');
			$('#ReceiveType').combobox('setValue','');
			$('#ReceiveObj').combogrid('options').queryParams.rectype='';
			$('#ReceiveObj').combogrid('setRemoteValue',{value:'',text:''});
			
			$('#TragetRoleType').combobox('setValue','')
			$('#TragetRoleLoc').combogrid('setRemoteValue',{value:'',text:''});
			$('#TragetRoleGroup').combogrid('setRemoteValue',{value:'',text:''});
			$('#Note').val('');
		}
		if (GV.current.bizModel || BizModel) $('#BizModel').attr('disabled','disabled');
		else  $('#BizModel').removeAttr('disabled');
		
		if (GV.current.admHospital) $('#AdmHospital').combogrid('disable');
		else  $('#AdmHospital').combogrid('enable');
		
		if (GV.current.admType) $('#AdmType').combobox('disable');
		else  $('#AdmType').combobox('enable');
		
		if (GV.current.admLoc) $('#AdmLoc').combogrid('disable');
		else  $('#AdmLoc').combogrid('enable');
		
	}
	GV.save=function(){
		var data={ClassName:"websys.DHCMessageReceiveCfgMgr",MethodName:'Save'};
		data.Id=$('#Id').val();
		data.BizModel=$('#BizModel').val();
		if (data.BizModel==''){
			$.messager.alert("ʧ��","���벻��Ϊ��");
		}
		
		data.AdmHospital=$('#AdmHospital').combogrid('getValue');
		if (data.AdmHospital=='') data.AdmHospital=0;
		
		data.AdmType=$('#AdmType').combobox('getValue');
		if (data.AdmType=='') data.AdmType=0;
		
		data.AdmLoc=$('#AdmLoc').combogrid('getValue');
		if (data.AdmLoc=='') data.AdmLoc=0;
		
		data.SendModel=$('#SendModel').combobox('getValue');
		if (data.SendModel=='') {data.SendModel='I';$('#SendModel').combobox('setValue','I');}
		
		
		data.TimeStart=$("#TimeStart").timespinner('getValue');
		if (data.TimeStart=='') {data.TimeStart='00:00:00';$("#TimeStart").timespinner('setValue','00:00:00');}
		
		data.TimeEnd=$("#TimeEnd").timespinner('getValue');
		if (data.TimeEnd=='') {data.TimeEnd='23:59:59';$("#TimeEnd").timespinner('setValue','23:59:59');}
		
		var ReceiveType= $('#ReceiveType').combobox('getValue');
		var TReceiveObj=$('#ReceiveObj').combogrid('getValue');
		data.ReceiveCode=ReceiveType+"-"+TReceiveObj;
		
		var TargetRole=$('#TragetRoleType').combobox('getValue');
		if (TargetRole=="Other"){
			TargetRole='';
			var loc=$('#TragetRoleLoc').combogrid('getValue');
			var group=$('#TragetRoleGroup').combogrid('getValue');
			if (loc>0) TargetRole=TargetRole+'L'+loc;
			if (group>0) TargetRole=TargetRole+'G'+group;
		}
		data.TargetRole=TargetRole;
		data.Note=$('#Note').val();
		
		console.log(data);

		$.m(data,function(rtn){
			console.log(rtn)	
			if (rtn>0){
				$.messager.alert("�ɹ�","����ɹ�");
				$('#cfg_edit_win').dialog('close');
				$('#cfg_list').datagrid('reload');
				GV.reloadTreeCurrentNode();
			}else{
				$.messager.alert("ʧ��","����ʧ��<br>"+rtn.split("^")[1]||rtn)	
			}
		})
	}
	
}
var init=function(){
	initEditWin();
	GV.SendModelJsonIndex={};
	$.each(GV.SendModelJson,function(){
		GV.SendModelJsonIndex[this.id]=this.text;
	})
	var showCfgList=function(node){
		var arr=node.id.split("-"),len=arr.length;
		var bizModel=arr[0],admHospital=arr[1]||'',admType=arr[2]||'',admLoc=arr[3]||'';
		var pnode=$('#left_tree').tree('getParent',node.target);
		if (pnode) var ppnode=$('#left_tree').tree('getParent',pnode.target);
		var title="",admLocDesc="",admHospitalDesc=""
		if (len==4) {
			title='['+bizModel+']'+' '+ ppnode.text+' '+ pnode.text+' '+node.text+' ��������';
			admLocDesc=node.text;
			admHospitalDesc=ppnode.text;
		}else if (len==3) {
			title='['+bizModel+']'+' '+ pnode.text+' '+node.text+' ��������';
			admHospitalDesc=pnode.text;
		}else if (len==2) {
			title='['+bizModel+']'+' '+node.text+' ��������';
			admHospitalDesc=node.text;
		}else if (len==1) {
			title='['+bizModel+']'+' ��������';
		}
		
		$('#cfg_list').datagrid('load',{BizModel:bizModel,AdmHospital:admHospital,AdmType:admType,AdmLoc:admLoc});
		$('#cfg_list').datagrid('getPanel').panel('setTitle',title);
		GV.current={
			node:node,
			bizModel:bizModel,admHospital:admHospital,admType:admType,admLoc:admLoc,admLocDesc:admLocDesc,admHospitalDesc:admHospitalDesc
		}
	};
	debounce_showCfgList=debounce(showCfgList,200);
	$('#left_tree').tree({
		url:$URL+"?ClassName=websys.DHCMessageReceiveCfgMgr&MethodName=TreeJson&id="+BizModel,
		lines:true,
		animate:true,	
		onClick:function(node){
			debounce_showCfgList(node);
		},
		onBeforeLoad:function(node,param){
			if(!node) param.isRoot=1
			return true;
		},onDblClick:function(node){
			if(!$(this).tree('isLeaf',node.target)){
				$('#left_tree').tree('reload',node.target);
			}
		}
	});
	GV.reloadTreeCurrentNode=function(){
		var tar;
		if (GV.current && GV.current.node) tar=GV.current.node.target
		if (tar) $('#left_tree').tree('reload',tar);
	}
	var dgTitle='��������';
	if (BizModel!="") dgTitle='['+BizModel+'] '+dgTitle;
	//TId:%String,TAdmHospital:%String,TAdmLoc:%String,TAdmType:%String,TBizModel:%String,TNote:%String,TReceiveCode:%String,TSendModel:%String,TTargetRole:%String,TTimeEnd:%String,TTimeStart:%String,TAdmHospitalDesc,TAdmTypeDesc,TAdmLocDesc,TReceiveDesc,TTargetRoleDesc
	$('#cfg_list').datagrid({
		headerCls:'panel-header-gray',
		title:dgTitle,
		url:$URL+"?ClassName=websys.DHCMessageReceiveCfgMgr&QueryName=Find",
		lazy:true,
		fit:true,
		//TId:%String,TAdmHospital:%String,TAdmLoc:%String,TAdmType:%String,TBizModel:%String,TNote:%String,TReceiveCode:%String,TSendModel:%String,TTargetRole:%String,TTimeEnd:%String,TTimeStart:%String
		columns:[[
			{field:"TBizModel",title:"��Ϣ����",width:80},
			{field:"TAdmHospitalDesc",title:"ҽԺ",width:120},
			{field:"TAdmTypeDesc",title:"��������",width:120},
			{field:"TAdmLocDesc",title:"����",width:120},
			{field:"TSendModel",title:"���ͷ�ʽ",width:120,formatter:function(val){
				return GV.SendModelJsonIndex[val]||'';
			}},
			{field:"TTimeStart",title:"����ʱ��",width:160,formatter:function(val,row){
				return val+'-'+row['TTimeEnd'];
			}},
			{field:"TReceiveDesc",title:"��Ϣ������",width:150}
			,{field:"TTargetRoleDesc",title:"Ŀ���ɫ",width:150}
			,{field:"TNote",title:"��ע",width:150}
		]],
		queryParams:{BizModel:BizModel},
		pagination:true,
		pageSize:20,
		pageList:[20,50,100],
		rownumbers:true,
		striped:true,
		singleSelect:true,
		toolbar:[
			{
				text:'����',
				iconCls:'icon-add',
				handler:function(){
					GV.setEditVal();
					$('#cfg_edit_win').dialog('open');	
				}
				
			},{
				text:'�޸�',
				iconCls:'icon-edit',
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
				handler:function(){
					var row=$('#cfg_list').datagrid('getSelected')
					if (!row) {
						$.messager.alert("��ʾ","��ѡ����")	;
						return ;
					}
					$.messager.confirm("ȷ��","ȷ��ɾ���������ü�¼��",function(r){
						if(r){
							var data={ClassName:"websys.DHCMessageReceiveCfgMgr",MethodName:'Delete'};
							data.Id=row.TId;
							$.m(data,function(rtn){
								if (rtn>0){
									$.messager.alert("�ɹ�","ɾ���ɹ�");
									$('#cfg_list').datagrid('reload');
									GV.reloadTreeCurrentNode();
								}else{
									$.messager.alert("ʧ��","ɾ��ʧ��<br>"+rtn.split("^")[1]||rtn)	
								}
							})
						}
					})
				}
				
			}
		]
	});
}

$(function(){
	$.m({ClassName:'websys.DHCMessageReceiveCfgMgr',MethodName:'HasCfg',BizModel:BizModel},function(ret){
		if (ret>0){
			init();
		}else{
			$.messager.confirm('��ʾ','�Ƿ��ʼ����'+BizModel+'���߼����ն�������',function(r){
				if(r){
					$.m({ClassName:'websys.DHCMessageReceiveCfgMgr',MethodName:'InitOneBizModel',BizModel:BizModel},function(ret){
						if(ret>0){
							$.messager.alert('��ʾ','��ʼ���ɹ�','info');
							init();
						}else{
							$.messager.alert('��ʾ','��ʼ��ʧ��','error');
						}
					})
				}
			})	
		}
	})
})