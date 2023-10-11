;(function ($) {
	$.fn.combogrid.methods.setRemoteValue=function (jq,param) {
    	return jq.each(function(){
	    	if (typeof param=="string"){
		    	$(this).combogrid('setValue',param);
		    }else{
			    var val=param['value']||'';
			    var text=param['text']||'';
			    var tempOnLoadSuccess=$(this).combogrid('options').onLoadSuccess;
			    
			    var that=this;
			    $(this).combogrid('options').onLoadSuccess=function(data){
				    $(that).combogrid('setValue',val).combogrid('setText',text);
				    
					if(typeof param.callback=='function') {
						param.callback(data,{value:val,text:text})
					}   
					tempOnLoadSuccess.call(this,data);
					$(that).combogrid('options').onLoadSuccess=tempOnLoadSuccess;
				}
			    
			    $(this).combogrid('options').keyHandler.query.call(this,text);
				$(this).combogrid('setValue',val).combogrid('setText',text);
			}
	    })
    }
})(jQuery);

//^((2(5[0-5]|[0-4]\d))|[0-1]?\d{1,2})(\.((2(5[0-5]|[0-4]\d))|[0-1]?\d{1,2})){3}$
$.extend($.fn.validatebox.defaults.rules, {
    ipOrDN: {
		validator: function(value,param){
			return (/^((2(5[0-5]|[0-4]\d))|[0-1]?\d{1,2})(\.((2(5[0-5]|[0-4]\d))|[0-1]?\d{1,2})){3}$/.test(value))
					||
					(/^(?=^.{3,255}$)[a-zA-Z0-9][-a-zA-Z0-9]{0,62}(\.[a-zA-Z0-9][-a-zA-Z0-9]{0,62})+$/.test(value));
					
		},
		message: 'IP��������ʽ����ȷ'
    }
    ,jsonstr:{
		validator: function(value,param){
			if (value=='') return true;
			var flag=false;
			try{
				var o=JSON.parse(value);  
				flag=(typeof o=='object');	 //����1 ֱ��parse�����쳣
			}catch(e){}
			return flag;
					
		},
		message: 'Jsonģ�����Ϊ��׼JSON�ַ������߿�'
	    
	}
});

var debounce=function(func, wait, immediate) {
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

var GV={}
var init=function(){
	GV.arr=[
		'TId','TReqCode','TReqDesc','TServerIP','TServerPort','TServerUrl','TConstParams',{id:'TTPSServerName',type:'combogrid',text:'TTPSServerDesc'}
		,{id:'TIsHttps',type:'checkbox',on:'1',off:'0'},'THttpsCfgName',{id:'TSSLCheckServerIdentity',type:'checkbox',on:'1',off:'0'}
		,{id:'TMethodType',type:'combobox'},{id:'TContentType',type:'combobox'}
		,{id:'TActive',type:'checkbox',on:'Y',off:'N'}
		,{id:'TTimeout',type:'numberbox'},'TNote','TTestParams','TJsonTmpl'
	]
	$('#list').datagrid({
		title:'�����б�',
		headerCls:'panel-header-gray',
        pagination: true,
        striped:true,
        singleSelect:true,
        idField:'TId',
        rownumbers:true,
        toolbar:[],
        url:$URL,
        queryParams:{
	        ClassName:'CF.BSP.SYS.BL.Request',
	        QueryName:'Find',
	        q:''
	    },
	    fit:true,
	    pageSize:20,
	    fitColumns:true,
	    //TId:%String,TActive:%String,TConstParams:%String,TContentType:%String,THttpsCfgName:%String,TIsHttps:%String,TMethodType:%String,TNote:%String,TReqCode:%String,TReqDesc:%String,TServerIP:%String,TServerPort:%String,TServerUrl:%String,TTestParams:%String
	    columns:[[
	    	{field:'TReqCode',title:'�������',width:120},
	    	{field:'TReqDesc',title:'��������',width:120},
	    	{field:'TTPSServerName',title:'������������',width:100,formatter:function(val,row){
		    	return row.TPSServerDesc||val;
		    }},
			{field:'TServerIP',title:'����IP/����',width:120},
			{field:'TServerPort',title:'����˿�',width:60},
			{field:'TServerUrl',title:'����Url',width:150},
			{field:'TTPSServerParam',title:'�����������',width:150},
			{field:'TConstParams',title:'�̶�����',width:150},
			{field:'TIsHttps',title:'�Ƿ�HTTPS',width:60},
			{field:'THttpsCfgName',title:'HTTPS������',width:120},
			{field:'TSSLCheckServerIdentity',title:'��֤���������',width:120},
			{field:'TMethodType',title:'HTTP����',width:60},
			{field:'TContentType',title:'��������',width:80},
			{field:'TActive',title:'����',width:60},
			{field:'TTimeout',title:'��ʱ(��)',width:60},
			{field:'TNote',title:'��ע',width:100},
			{field:'TTestParams',title:'���Բ���',width:150},
			{field:'TJsonTmpl',title:'Jsonģ��',width:80,formatter:function(val,row,ind){
				return '<a href="javascript:void(0);" class="op-json-tmpl" data-ind="'+ind+'">'+(val?'�޸�':'����')+'</a>'
			}},
			{field:'OPTest',title:'����',width:60,formatter:function(val,row,ind){
				return '<a href="javascript:void(0);" class="op-test" data-ind="'+ind+'">����</a>'
			}}
	    ]],
	    toolbar:[{
			id:'tb-add',
			iconCls:'icon-add',
			text:'����',
			handler:function(){
				$('#win').dialog('open').dialog('setTitle','����');
				GV.setEditVal();
			} 
		},{
			id:'tb-edit',
			iconCls:'icon-edit',
			text:'�޸�',
			handler:function(){
				var row=$('#list').datagrid('getSelected');
				if(row && row.TId) {
					$('#win').dialog('open').dialog('setTitle','�޸�');
					GV.setEditVal(row)
				}else{
					$.messager.popover({msg:'��ѡ��һ����¼',type:'alert'})	
				}
				
			} 
		},{
			id:'tb-copy',
			iconCls:'icon-copy',
			text:'����',
			handler:function(){
				var row=$('#list').datagrid('getSelected');
				if(row && row.TId) {
					$('#win').dialog('open').dialog('setTitle','����-����');
					var myrow=$.extend({},row,{TId:''});
					GV.setEditVal(myrow);
				}else{
					$.messager.popover({msg:'��ѡ��һ����¼',type:'alert'})	
				}
				
			} 
		},{
			id:'tb-remove',
			iconCls:'icon-remove',
			text:'ɾ��',
			handler:function(){
				var row=$('#list').datagrid('getSelected');
				if(row && row.TId) {
					$.messager.confirm('��ʾ','ȷ��ɾ��������¼ô��',function(r){
						if(r){
							$.m({ClassName:'CF.BSP.SYS.BL.Request',MethodName:'Delete',Id:row.TId},function(ret){
								if (ret>0) {
									$.messager.popover({msg:'ɾ���ɹ�',type:'success'});
									$('#list').datagrid('reload');
								}else{
									$.messager.popover({msg:'ɾ��ʧ��'+ret.split('^')[1]||ret,type:'error'});
								}
							})	
						}	
					})
				}else{
					$.messager.popover({msg:'��ѡ��һ����¼',type:'alert'})	
				}
			} 
		}],
		onLoadSuccess:function(){
			$('.op-test').off('click').on('click',function(){
				var ind=$(this).data('ind');
				var row=$('#list').datagrid('getRows')[ind];
				showTestWin(row,ind);
			})	
			$('.op-json-tmpl').off('click').on('click',function(){
				var ind=$(this).data('ind');
				var row=$('#list').datagrid('getRows')[ind];
				showJsonTmplWin(row,ind);
			})	
		}
	})
	$('#search').searchbox({
		prompt:'���롢������IP',
		searcher:function(val){
			$('#list').datagrid('load',{ClassName:'CF.BSP.SYS.BL.Request',QueryName:'Find',q:val})
		}
	})
	
	$('#TMethodType').combobox('options').onSelect=function(o){
		if(o.value!='POST') {
			$('#TContentType').combobox('setValue','form-urlencoded').combobox('disable').combobox('isValid');
		}else{
			$('#TContentType').combobox('enable');
		}
	}
	
	
	$('#win').dialog({
		title:'����',
		iconCls:'icon-w-paper',
		buttons:[{
			text:'ȷ��',
			handler:function(){
				var data=GV.getEditVal();
				if (!data.isValid) {
					$.messager.popover({msg:'������֤ʧ��',type:'error'});
					return;}
				delete data.isValid;
				$.extend(data,{ClassName:'CF.BSP.SYS.BL.Request',MethodName:'Save'});
				
				$.m(data,function(ret){
					if (ret>0) {
						$.messager.popover({msg:'����ɹ�',type:'success'});
						$('#win').dialog('close');
						$('#list').datagrid('reload');
					}else{
						$.messager.popover({msg:'����ʧ��'+ret.split('^')[1]||ret,type:'error'});
					}
				})
			}	
		},{
			text:'ȡ��',
			handler:function(){
				$('#win').dialog('close');
			}
		}]
	})
	
	$('#TIP').validatebox({
		required:true,
		validType:['ipOrDN']	
	})
	

	
	LoadCombo2Css(30);
	initParamsStyle('TConstParams');
	initParamsStyle('TTestParams');
	
	GV.setEditVal=function(row){
		if(row){
			common.setData(GV.arr,'',row);
		}else{
			common.setData(GV.arr,'',{TIsHttps:'0',TActive:'Y',TTimeout:5,TSSLCheckServerIdentity:'1'});
		}
		if($('#TMethodType').combobox('getValue') !='POST') {
			$('#TContentType').combobox('setValue','form-urlencoded').combobox('disable').combobox('isValid');
		}else{
			$('#TContentType').combobox('enable');
		}
		common.validate(GV.arr);
	}
	GV.getEditVal=function(){
		var data=common.getData(GV.arr,'T');
		var isValid=common.validate(GV.arr);
		data.isValid=isValid;
		return data;
	}
	
	
	$('#TJsonTmpl,#oneJsonTmpl').validatebox({
		required:false,
		validType:['jsonstr']	
	})
	
	
	function isCodeOrTextContains(code,text,q){
		q=q||'';
		q=$.trim(q);
		text=text||'';
		code=code||'';
		
		var qL=q.toLowerCase();
		var codeL=code.toLowerCase();
		var textL=text.toLowerCase();
		if (codeL.indexOf(qL)>-1 || textL.indexOf(qL)>-1) return true;
		
		///��ƴ����
		var spellArr=$.hisui.getChineseSpellArray(text);
        var len=spellArr.length;        
        var spellMatch=false;
        for (var i=0;i<len;i++){
            var spellL=(spellArr[i]||'').toLowerCase();
            var spellIndex=spellL.indexOf(qL);
            if(spellIndex>-1) {
                spellMatch=true;
                break;
            }
        }
        return spellMatch;
		
	}
	
	var tmplPromptLoader=function(dataArr,param,success){
		
		var arr=[];
		for (var i=0;i<dataArr.length;i++) {
			var tArr,tStr=dataArr[i];
			
			try{
				tArr=$.parseJSON(tStr);
				if(!(tArr instanceof Array)) tArr=[];
			}catch(e){
				tArr=[];
			}
			
			arr=arr.concat(tArr);
		}
		
		arr=$.grep(arr,function(item){
			return isCodeOrTextContains(item.key,item.desc,param.q)
		})
		
		var data={rows:arr,total:arr.length}
		success(data) ; 

	}
	
	
	/// ���з���url�ֶ�
	$('#TServerUrl').templateprompt({
		url:$URL,
		mode:'remote',
		pagination:true,
		pageSize:1000,
		pageList:[1000],
		idField: 'key', 
		loader:function(param,success,error){
			var str1=$('#TConstParams').val(),
				str2=$('#TTestParams').val(),
				str3=url2ParamsJson($('#TTPSServerParam').val());

			tmplPromptLoader([str3,str1,str2],param,success); //
		},
		panelWidth:430,
		panelHeight:200,
		columns:[[
			{field:'key',title:'ռλ��',width:200},
			{field:'desc',title:'˵��',width:200}
		]]
	}).on('focus',function(){$(this).templateprompt('clearPreviousValue')});
	
	
	/// ���е�Jsonģ���ֶ�
	$('#TJsonTmpl').templateprompt({
		url:$URL,
		mode:'remote',
		pagination:true,
		pageSize:1000,
		pageList:[1000],
		idField: 'key', 
		loader:function(param,success,error){
			var str1=$('#TConstParams').val(),
				str2=$('#TTestParams').val(),
				str3=url2ParamsJson($('#TTPSServerParam').val());
			tmplPromptLoader([str3,str1,str2],param,success); //
			
		},
		panelWidth:430,
		panelHeight:200,
		columns:[[
			{field:'key',title:'ռλ��',width:200},
			{field:'desc',title:'˵��',width:200}
		]]
	}).on('focus',function(){$(this).templateprompt('clearPreviousValue')});
	
	
	/// ������jsonģ��ά��
	$('#oneJsonTmpl').templateprompt({
		url:$URL,
		mode:'remote',
		pagination:true,
		pageSize:1000,
		pageList:[1000],
		idField: 'key', 
		loader:function(param,success,error){
			var rowind=$('#json-tmpl-win').data('rowind');
			rowind=parseInt(rowind);
			
			var row=$('#list').datagrid('getRows')[rowind];
			if(row) {
				var str1=row.TConstParams,
					str2=row.TTestParams,
					str3=url2ParamsJson(row.TTPSServerParam);
				tmplPromptLoader([str3,str1,str2],param,success); //
			}
			
		},
		panelWidth:430,
		panelHeight:200,
		columns:[[
			{field:'key',title:'ռλ��',width:200},
			{field:'desc',title:'˵��',width:200}
		]]
	}).on('focus',function(){$(this).templateprompt('clearPreviousValue')});
	
	var url2ParamsJson=function(urlstr){
		
		var t=[];
		
		var arr=urlstr.split('&');
		for (var i=0;i<arr.length;i++) {
			var item=arr[i];
			var key=item.split('=')[0]||'',
				value=item.split('=')[1]||'';
			
			if(key) {
				t.push({key:key,value:value,desc:key})
				
			}
		}
		return JSON.stringify(t)
	}
	
	var mergeParams=function(jsonstr, urlstr){
		var tArr;
		try{
			tArr=$.parseJSON(tStr);
			if(!(tArr instanceof Array)) jsonstr=[];
		}catch(e){
			tArr=[];
		}
		
		var t={}
		for (var i=0;i<tArr.length;i++) {
			var item=tArr[i];
			var key=item.key||'',
				value=item.value||'',
				desc=item.desc||'';
			if (key) {
				map[key]={
					v:value,d:desc	
				}	
			}
		}
		
		var arr=urlstr.split('&');
		for (var i=0;i<arr.length;i++) {
			var item=arr[i];
			var key=item.split('=')[0]||'',
				value=item.split('=')[1]||'';
			
			if(key) {
				if(map[key]){
					 map[key].v=value;	
				}else{
					map[key]={
						v:value,d:''	
					}
				}
				
			}
		}
		
		var arr=[];
		for (var key in map) {
				
			arr.push( {key:key,value:map[key].v,desc:map[key].d||''} )
		}
		
		return JSON.stringify(arr)
		
	}
	var setTPSServerState=function(row){
		if(row && row.TPSSCode) {
			$('#TServerIP,#TServerPort').attr('disabled','disabled');
			$('#TServerIP').val(row.TPSSIP).validatebox('validate');
			$('#TServerPort').val(row.TPSSPort).validatebox('validate');
			$('#TIsHttps').checkbox('setValue',row.TPSSProtocol.toLowerCase()=='https')
			$('#TIsHttps').checkbox('disable');
			//var cstparams=$('#TConstParams').val()
			$('#TTPSServerParam').val(row.TPSSParam);
			
			
		}else{
			$('#TServerIP,#TServerPort').removeAttr('disabled');
			$('#TServerIP').validatebox('validate');
			$('#TServerPort').validatebox('validate');
			$('#TIsHttps').checkbox('enable');
			$('#TTPSServerParam').val('');
		}
	}
	debounce_setTPSServerState=debounce(setTPSServerState,200);
	$('#TTPSServerName').combogrid({
		panelWidth:750,
		delay: 500,
		mode: 'remote',
		url:$URL,
		queryParams:{
			ClassName:'CF.BSP.SYS.BL.ThirdPartySystemServer',
			QueryName:'Find',
			Protocol:"http,https"
		},
		onBeforeLoad:function(param){
			return true;
		},
		onSelect:function(ind,row){
			debounce_setTPSServerState(row)
		},
		onChange:function(val){
			if(val=='') {
				debounce_setTPSServerState('');
			}
		},
		idField:"TPSSCode",textField:"TPSSName",
		columns:[[{field:'TPSSName',title:'��������',width:120},{field:'TPSSCode',title:'�������',width:120},{field:'TPSSIP',title:'����IP',width:120},{field:'TPSSPort',title:'����˿�',width:120},{field:'TPSSProtocol',title:'Э��',width:120},{field:'TPSSParam',title:'����',width:120}]],
		pagination:true
		
	})
	
	
	$('#json-tmpl-win').dialog({
			iconCls:'icon-w-paper',title:'JSONģ��',
			modal:true,
			buttons:[
				{text:'����',handler:function(){
					if ($('#oneJsonTmpl').validatebox('isValid')) {
						
						$.messager.confirm('ȷ��','ȷ��������',function(r){
							if(r) {
								var Id=$('#reqid').val()
								var tmpl=$('#oneJsonTmpl').val();
								$m({ClassName:'CF.BSP.SYS.BL.Request',MethodName:'SaveJsonTmpl',Id:Id,JsonTmpl:tmpl},function(ret){
									if (ret>0) {
										$.messager.popover({msg:'����ɹ�',type:'success'});
										$('#json-tmpl-win').dialog('close');
										$('#list').datagrid('reload');
									}else{
										$.messager.popover({msg:'����ʧ��'+ret.split('^')[1]||ret,type:'error'});
									}
								})
							}
							
						})
						

						
					}else{
						$.messager.popover({msg:'Jsonģ������׼JSON�ַ������'+ret.split('^')[1]||ret,type:'error'});
					}
					
				}}
				,{
					text:'ȡ��',handler:function(){
						$('#json-tmpl-win').dialog('close');
					}
				}
			]
	})
	
	
	
}

function initParamsStyle(id){
	var target=$('#'+id)[0];
	initKeyValueBox(target,{
		panelWidth:650,
		panelHeight:250,
		parseValue:parseValue,
		formatValue:formatValue
		,descEditor:'text'
	});
	function formatValue(o){
		var arr=[];
		$.each(o,function(){
			if(this.key!=""){
				arr.push({key:this.key,value:this.value,desc:this.desc})	;
			} 
		})
		return JSON.stringify(arr);
	}
	function parseValue(str){
		try{
			var arr=$.parseJSON(str);
		}catch(e){
			var arr=[];	
		}
		var all=[];
		$.each(arr,function(){
			all.push({key:this.key,value:this.value,desc:this.desc,custom:true})
		})
		if (all.length==0) all.push({key:'',desc:'',value:'',custom:true});
		all.push({key:'',desc:'',value:'',custom:true});
		return all;
	}
}

function showTestWin(row,ind){
	function getFormTableValue(){
		var arr=[];
		$('#win-test').find('.form-table').find('.test-input').each(function(){
			var key=$(this).data('key');
			if (key) arr.push({key:key,value:$(this).val()})
		})
		return arr;
	}
	
	if ($('#win-test').length>0) {
		$('#win-test').find('.form-table').empty();
	}else{
		$('<div id="win-test" style="overflow:auto;word-break:break-all;padding:10px;"><table style="" class="form-table"></table></div>').appendTo('body');
		$('#win-test').dialog({
			width:650,
			height:500,	
			iconCls:'icon-w-paper',
			modal:true,
			buttons:[
				{text:'����',handler:function(){
					var str=JSON.stringify(getFormTableValue());
					var ReqCode=$('#win-test').find('.form-table').data('for');
					$m({ClassName:'CF.BSP.SYS.BL.Request',MethodName:'SendTest',ReqCode:ReqCode,jsonArrStr:str},function(ret){
						//alert(ret)	
						showPreText(ret);
					})
				}}
			]
		})
	}
	var formTable=$('#win-test').find('.form-table');
	formTable.data('ind',ind);
	formTable.data('for',row.TReqCode);
	try{
		var arr=$.parseJSON(row.TTestParams);
	}catch(e){
		var arr=[];	
	}
	$.each(arr,function(){
		$('<tr><td class="r-label" style="padding:10px;">'+this.key+'</td><td><input class="test-input textbox" style="width:300px;" data-key="'+this.key+'" value="'+this.value+'"/></td><td style="padding:10px;">'+this.desc+'</td></tr>').appendTo(formTable);
	})
	if (arr.length==0) {
		$('<tr><td colspan="3" style="padding:10px;">δ���ò��Բ���</td></tr>').appendTo(formTable)
	}
	$('#win-test').dialog('open').dialog('setTitle','���ԣ�'+row.TReqDesc+'['+row.TReqCode+']');
}
function showPreText(text){
	if ($('#win-pretext').length>0) {
		$('#win-pretext').find('.pretext').empty();
	}else{
		$('<div id="win-pretext" style="overflow:auto;word-break:break-all;"><pre class="pretext"></pre></div>').appendTo('body');
		$('#win-pretext').dialog({
			title:'���ý��',
			width:600,
			height:400,	
			iconCls:'icon-w-paper',
			modal:true
		})
	}
	$('#win-pretext').find('.pretext').text(text);
	$('#win-pretext').dialog('open');
}


function showJsonTmplWin(row,ind){
	$('#oneJsonTmpl').val(row.TJsonTmpl);
	$('#reqid').val(row.TId);
	$('#json-tmpl-win').dialog('open');
	$('#json-tmpl-win').data('rowind',ind+'');
}
$(init);