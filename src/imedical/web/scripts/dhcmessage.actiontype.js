var GV={}


function initDialogStyle(){
	var target=$('#TDialogStyle')[0];
	initKeyValueBox(target,{
		panelWidth:650,
		panelHeight:250,
		parseValue:parseValue,
		formatValue:formatValue
	});
	function formatValue(o){
		var arr=[];
		$.each(o,function(){
			console.log(this);
			if(this.key!=""&&this.value!=""){
				arr.push(this.key+"="+this.value)	;
			} 
		})
		return arr.join(',');
	}
	function parseShowInNewWindow(str){
		var arr=str.split(",");
		var o={};
		$.each(arr,function(){
			if (this.indexOf("=")>-1){
				var key=this.split("=")[0];
				var value=this.split("=")[1];
				if(key!="" && value!="") o[key]=value;
			}
		})
		return o;
	}
	function parseValue(str){
		var DialogStyleDIC=[
			{
				key:'dialogWidth',
				desc:'��(��1000��80%)'
			},{
				key:'dialogHeight',
				desc:'��(��500��80%)'
			},{
				key:'target',
				desc:'_blank�´���<br>����HISUIģ̬'
			},{
				key:'level',
				desc:'H�����ø���OtherInfoJson'
			},{
				key:'noDetailsId',
				desc:'Ϊ1��ƴ����Ϣ��ϸ��¼ID����'
			},{
				key:'execMsgOnOpen',
				desc:'����ʱֱ�Ӵ�����Ϣ��<br>All����ȫ��,One�����Լ�'
			},{
				key:'clientPath',
				desc:'�ͻ������·�������ڵ��������ͻ���'
			},{
				key:'autoOpen',
				desc:'Ϊ1ʱչʾ��Ϣ����ʱ�Զ���ҵ��������ҵ������鿴����'
			}

		]
		var o=parseShowInNewWindow(str);
		var all=[];
		if(DialogStyleDIC){
			$.each(DialogStyleDIC,function(){
				var key=this.key;
				if (typeof o[key]=="string"){
					all.push({key:key,value:o[key],desc:this.desc})
					delete o[key];
				}else{
					all.push({key:key,value:'',desc:this.desc})
				}
				
			})
		}
		$.each(o,function(i,v){
			all.push({key:i,value:v,custom:true,desc:''})
		})
		all.push({key:'',value:'',desc:'',custom:true});
		return all;
	}
}



function initCellContentStyle(){
	var target=$('#TCellContentStyle')[0];
	initKeyValueBox(target,{
		panelWidth:650,
		panelHeight:250,
		parseValue:parseValue,
		formatValue:formatValue,
		keyTitle:'CSS������',
		keyTitle:'CSS����ֵ'
	});
	function formatValue(o){
		var arr=[];
		$.each(o,function(){
			console.log(this);
			if(this.key!=""&&this.value!=""){
				arr.push(this.key+":"+this.value+';')	;
			} 
		})
		return arr.join('');
	}
	function parseCss(str){
		var arr=str.split(";");
		var o={};
		$.each(arr,function(){
			if (this.indexOf(":")>-1){
				var key=this.split(":")[0];
				var value=this.split(":")[1];
				if(key!="" && value!="") o[key]=value;
			}
		})
		return o;
	}
	function parseValue(str){
		var CSSStyleDIC=[
			{
				key:'color',
				desc:'������ɫ'
			},{
				key:'background-color',
				desc:'������ɫ'
			}

		]
		var o=parseCss(str);
		var all=[];
		if(CSSStyleDIC){
			$.each(CSSStyleDIC,function(){
				var key=this.key;
				if (typeof o[key]=="string"){
					all.push({key:key,value:o[key],desc:this.desc})
					delete o[key];
				}else{
					all.push({key:key,value:'',desc:this.desc})
				}
				
			})
		}
		$.each(o,function(i,v){
			all.push({key:i,value:v,custom:true,desc:''})
		})
		all.push({key:'',value:'',desc:'',custom:true});
		return all;
	}
}



/// ��ʼ�����������������
function initExecTimeLimit(){
	var map={'DEF':'�����־�������','O':'����','EO':'������ˮ','EI':'��������','I':'סԺ','H':'���'};

    for(var admType in map) {
        var content='<table cellspacing="0" cellpadding="0" border="0" class="elt-form-table"> \
        <tr><td class="r-label">�Ƿ�����</td><td><input type="checkbox" class="hisui-checkbox etl-ck etl-ck-lock" id="etl-item-lock-'+admType+'" /></td></tr>\
        <tr><td class="r-label">����ʱ��</td><td><input type="text" class="textbox etl-tb" id="etl-item-minute-'+admType+'" style="width:40px;margin-right:5px;padding-right:5px;"/>���Ӳ�����������</td></tr>\
        <tr><td class="r-label">�����ٴ�����</td><td><input type="checkbox" class="hisui-checkbox etl-ck" id="etl-item-clinic-'+admType+'-yes" label="�ٴ�" /><input type="checkbox" class="hisui-checkbox etl-ck" id="etl-item-clinic-'+admType+'-no" label="���ٴ�" /></td></tr>\
        <tr><td class="r-label">������Ա����</td><td><input type="checkbox" class="hisui-checkbox etl-ck" id="etl-item-cpt-'+admType+'-DOCTOR" label="ҽ��" /><input type="checkbox" class="hisui-checkbox etl-ck" id="etl-item-cpt-'+admType+'-NURSE" label="��ʿ" /><input type="checkbox" class="hisui-checkbox etl-ck" id="etl-item-cpt-'+admType+'-OTHER" label="����" /></td></tr>\
        <tr><td class="r-label">����������Ա</td><td><input type="checkbox" class="hisui-checkbox etl-ck" id="etl-item-role-'+admType+'-OrdDoc" label="����ҽ��" /><input type="checkbox" class="hisui-checkbox etl-ck" id="etl-item-role-'+admType+'-AdmDoc" label="����ҽ��" /></td></tr>\
        </table>';

        $('#ExecTimeLimit-Wrap').tabs('add',{
            title:map[admType],
            selected:true,
            id:'etl-tab-p-'+admType,
            content:content
        })
        
        $('#ExecTimeLimit-Wrap').tabs('select',0);
        
		$('#etl-item-lock-'+admType).checkbox('options').onCheckChange=function(e,val){
			//console.log(e,val)	
			setEtlItemStatus(  $(this).closest('.elt-form-table') , !val);
		}
        setEtlItemStatus(  $('#etl-item-lock-'+admType).closest('.elt-form-table') ,true);
    }
    
    function setEtlItemStatus(formTable,disabled){
	    if (disabled) {
		    formTable.find('.etl-ck').not('.etl-ck-lock').checkbox('disable');
		    formTable.find('.etl-tb').attr('disabled','disabled');
		}else{
		    formTable.find('.etl-ck').not('.etl-ck-lock').checkbox('enable');
		    formTable.find('.etl-tb').removeAttr('disabled');
		}
	    
	}

	
    GV.getExecTimeLimit=function(){
        /// �����Ȼ���Ǳ�����֮ǰ��Ŀʵ�ּ��ݵĽṹ
        /// ��������:���Ʒ���:��Ա����:�����ɫ(AdmDoc/OrdDoc):���ʱ��:�������:�Ƿ��ٴ�����
        /// 1       :2       :3       :4                      :5       :6       :7
        var arr=[];
        for(var admType in map) {
            var islock=$('#etl-item-lock-'+admType).checkbox('getValue');
            if (!islock) continue;
            var itemArr=[admType,'','','','','',''];

            var minute=parseFloat($('#etl-item-minute-'+admType).val())||0;
            itemArr[1]=minute;

            var clinicArr=[];
            if ( $('#etl-item-clinic-'+admType+'-yes').checkbox('getValue')  ) {
                clinicArr.push('CLI');
            }
            if ( $('#etl-item-clinic-'+admType+'-no').checkbox('getValue')  ) {
                clinicArr.push('NOTCLI');
            }
            var clinic=clinicArr.join('^');
            itemArr[6]=clinic;

            var cptArr=[];
            if ( $('#etl-item-cpt-'+admType+'-DOCTOR').checkbox('getValue')  ) {
                cptArr.push('DOCTOR');
            }
            if ( $('#etl-item-cpt-'+admType+'-NURSE').checkbox('getValue')  ) {
                cptArr.push('NURSE');
            }
            if ( $('#etl-item-cpt-'+admType+'-OTHER').checkbox('getValue')  ) {
                cptArr.push('OTHER');
            }
            var cpt=cptArr.join('^');
            itemArr[2]=cpt;

            var roleArr=[];
            if ( $('#etl-item-role-'+admType+'-OrdDoc').checkbox('getValue')  ) {
                roleArr.push('OrdDoc');
            }
            if ( $('#etl-item-role-'+admType+'-AdmDoc').checkbox('getValue')  ) {
                roleArr.push('AdmDoc');
            }
            var role=roleArr.join('^');
            itemArr[3]=role;

            var item=itemArr.join(':');
            arr.push( item );
        }
        return arr.join(',');
    }
	GV.setExecTimeLimit=function(str){
        $('.etl-tb').val('');
        $('input.etl-ck').checkbox('setValue',false);
        var arr=str.split(',');
        for (var i=0,len=arr.length;i<len;i++) {
            var item=arr[i];
            var itemArr=item.split(':');
            var admType=itemArr[0]||'';
            if (admType=='') continue;

            $('#etl-item-lock-'+admType).checkbox('setValue',true);

            var minute=itemArr[1]||'';
            $('#etl-item-minute-'+admType).val(minute);

            var clinic=itemArr[6]||''
            if(('^'+clinic+'^').indexOf('^CLI^')>-1) $('#etl-item-clinic-'+admType+'-yes').checkbox('setValue',true); 
            if(('^'+clinic+'^').indexOf('^NOTCLI^')>-1) $('#etl-item-clinic-'+admType+'-no').checkbox('setValue',true); 

            var cpt=itemArr[2]||'';
            if (('^'+cpt+'^').indexOf('^DOCTOR^')>-1)  $('#etl-item-cpt-'+admType+'-DOCTOR').checkbox('setValue',true); 
            if (('^'+cpt+'^').indexOf('^NURSE^')>-1)  $('#etl-item-cpt-'+admType+'-NURSE').checkbox('setValue',true); 
            if (('^'+cpt+'^').indexOf('^OTHER^')>-1)  $('#etl-item-cpt-'+admType+'-OTHER').checkbox('setValue',true); 

            var role=itemArr[3]||'';
            if (('^'+role+'^').indexOf('^OrdDoc^')>-1)  $('#etl-item-role-'+admType+'-OrdDoc').checkbox('setValue',true);
            if (('^'+role+'^').indexOf('^AdmDoc^')>-1)  $('#etl-item-role-'+admType+'-AdmDoc').checkbox('setValue',true);



        }


    }
	
	
}

function initExecLink(){
	var data=[
		{PCode:"COMPUTER_NAME",PDesc:"������"},
		{PCode:"LOGON.CTLOCDESC",PDesc:"��¼��������"},
		{PCode:"LOGON.CTLOCID",PDesc:"��¼����ID"},
		{PCode:"LOGON.GROUPDESC",PDesc:"��¼��ȫ������"},
		{PCode:"LOGON.GROUPID",PDesc:"��¼��ȫ��ID"},
		{PCode:"LOGON.HOSPDESC",PDesc:"��¼Ժ������"},
		{PCode:"LOGON.HOSPID",PDesc:"��¼Ժ��ID"},
		{PCode:"LOGON.LANGCODE",PDesc:"���Դ���"},
		{PCode:"LOGON.LANGID",PDesc:"����ID"},
		{PCode:"LOGON.SSUSERLOGINID",PDesc:"��¼��־ID"},
		{PCode:"LOGON.USERCODE",PDesc:"��¼�û�����"},
		{PCode:"LOGON.USERID",PDesc:"��¼�û�ID"},
		{PCode:"LOGON.USERNAME",PDesc:"��¼�û�����"},
		{PCode:"LOGON.WARDDESC",PDesc:"��¼��������"},
		{PCode:"LOGON.WARDID",PDesc:"��¼����ID"},
		
		{PCode:"DetailsId",PDesc:"��Ϣ��ϸ��¼ID"},
		{PCode:"PatientId",PDesc:"����ID"},
		{PCode:"EpisodeId",PDesc:"����ID"},
		{PCode:"OEOrdItemId",PDesc:"ҽ��ID"},
		{PCode:"SendUserDesc",PDesc:"�����û�"},
		{PCode:"Content",PDesc:"��Ϣ����"},
		{PCode:"SendDate",PDesc:"��������"},
		{PCode:"SendTime",PDesc:"����ʱ��"},
		{PCode:"ActionCode",PDesc:"��Ϣ���ʹ���"},
		{PCode:"ActionDesc",PDesc:"��Ϣ��������"},
		{PCode:"TReadFlag",PDesc:"�Ķ���־"},
		{PCode:"TExecFlag",PDesc:"�����־"},
		{PCode:"BedNo",PDesc:"����"},
		{PCode:"AdmLoc",PDesc:"�������"},
		{PCode:"PatName",PDesc:"��������"},
		{PCode:"AdmDoctor",PDesc:"����ҽ��"},
		{PCode:"AdmPapmiNo",PDesc:"���ߵǼǺ�"},
		{PCode:"Age",PDesc:"����"},
		{PCode:"ContentId",PDesc:"��Ϣ����ID"},
		{PCode:"Context",PDesc:"��Ϣ����"},
		{PCode:"CreateLoc",PDesc:"���Ϳ���"},
		{PCode:"Diagnosis",PDesc:"���"},
		{PCode:"Name",PDesc:"��������"},
		{PCode:"SendUser",PDesc:"�����û�"},
		{PCode:"Sex",PDesc:"�Ա�"},
		{PCode:"SexZH",PDesc:"�Ա�(��)"}
	]	
	$('#TExecLink').templateprompt({
		mode:'locale',
		pagination:false,
		idField: 'PCode', 
		onBeforeLoad:function(param){
			param = $.extend(param,{q:param.q});
			param.tmplId=$('#TId').val();
			return true;
		},
		panelWidth:430,
		panelHeight:200,
		columns:[[
			{field:'PCode',title:'ռλ��',width:200},
			{field:'PDesc',title:'˵��',width:200}
		]],
		data:data,
		textField:'PDesc',
		filter:function(q,row){
			if(row.PCode.indexOf(q)>-1) return true;
			if(row.PDesc.indexOf(q)>-1) return true;
		}
	});
}

function initEidtWin(){
	
	GV.arr=[
		'TActionId','TCode','TDesc'
		,{id:'TReceiveTypeDr',text:'TReceiveTypeDesc',type:'combogrid'}
		,{id:'TActive',type:'checkbox',on:'Y',off:'N'}
		,{id:'TSendModeCode',type:'combobox',multiple:true}
		
		,{id:'TLevelType',type:'combobox'}
		,'TEffectiveDays'
		,{id:'TOnlySameLocFlag',type:'checkbox',on:'Y',off:'N'}
		
		,{id:'TTeamExec',type:'combobox'}
		,'TExecLink'
		,{id:'TDischAutoExec',type:'checkbox',on:'Y',off:'N'}
		
		,{id:'TToolbarItems',type:'combobox',multiple:true}
		,'TPopupInterval'
		,'TAudioName'
		,{id:'THideExp',type:'checkbox',on:'Y',off:'N'}
		
		,'TReadCallbackMethod'
		,'TDialogStyle'
		,{id:'THideSendUser',type:'checkbox',on:'Y',off:'N'}
		
		,'TSequence'
		,{id:'THideReceiveUser',type:'checkbox',on:'Y',off:'N'}
		
		,'TAudioContent'
		,'TBizExecMethod'
		,{id:'TAllowReply',type:'checkbox',on:'Y',off:'N'}
		
		,'TNote'
		
		,{id:'TCatgory',type:'combobox'}
		,'TCellContentStyle'
	]
	
	$('#TReceiveTypeDr').combogrid({
		panelWidth:450,
		delay: 500,
		mode: 'remote',
		url:$URL,
		queryParams:{ClassName: 'websys.DHCMessageReceiveTypeMgr',QueryName: 'FindAll'},
		onBeforeLoad:function(param){
			param.Desc=param.q;
			return true;
		},
		idField:"DHCReceiveRowId",textField:"DHCReceiveDesc",
		columns:[[{field:'DHCReceiveDesc',title:'����',width:200},{field:'DHCReceiveCode',title:'����',width:200}]],
		pagination:true
	});
	GV.SendModeJson=$.cm({ClassName:'websys.DHCMessageActionTypeMgr',MethodName:'OutSendModeJSON'},false)
	GV.LevelTypeJson = [{Code:"G",Desc:"һ����Ϣ"},{Code:"I",Desc:"��Ҫ��Ϣ"},{Code:"V",Desc:"�ǳ���Ҫ"},{Code:"D",Desc:"������Ϣ"}];
	GV.TeamExecJson = [{Code:"N",Desc:"��Ϣ�໥����,�����Լ���Ϣ����ʾ"},{Code:"Y",Desc:"��Ҫ����"}];
	GV.ToolItemsJson = [{id:"E",text:"ִ�а�ť"},{id:"EMRView",text:"�������"}]; //,{id:"R",text:"�ظ���ť"}
	GV.CatgoryJson=[{value:'B',text:'ҵ����'},{value:'N',text:'֪ͨ��'}];
	
	$('#TSendModeCode').combobox({
		valueField:'id',
		textField:'text',
		multiple:true,
		rowStyle:'checkbox', //��ʾ�ɹ�ѡ����ʽ
		selectOnNavigation:false,
		panelHeight:"auto",
		editable:false,
		data:GV.SendModeJson
	})
	
	$('#TLevelType').combobox({ data:GV.LevelTypeJson, valueField:'Code', textField:"Desc",panelHeight:'auto'});
	$('#TTeamExec').combobox({ data:GV.TeamExecJson, valueField:'Code', textField:"Desc",panelHeight:'auto'});
	
	$('#TCatgory').combobox({ data:GV.CatgoryJson,panelHeight:'auto'});
	
	$('#TToolbarItems').combobox({
		valueField:'id',
		textField:'text',
		multiple:true,
		rowStyle:'checkbox', //��ʾ�ɹ�ѡ����ʽ
		selectOnNavigation:false,
		panelHeight:"auto",
		editable:false,
		data:GV.ToolItemsJson
	})
	LoadCombo2Css(30);
	initDialogStyle();
	initCellContentStyle();
	
	initExecLink();

	
	
	
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
				$.extend(data,{ClassName:'websys.DHCMessageActionTypeMgr',MethodName:'Save'});
				
				
				$.m(data,function(ret){
					if (ret>0) {
						$.messager.popover({msg:'����ɹ�',type:'success'});
						$('#win').dialog('close');
						$('#tDHCMessageActionType').datagrid('reload');
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
	
	
	GV.setEditVal=function(row){
		if(row){
			
			var leveType='G'
			$.each(GV.LevelTypeJson,function(){
				if (this.Desc==row.TLevelType) leveType=this.Code;
			})
			row.TLevelType=leveType;
			
			common.setData(GV.arr,'',row);
			
			GV.setExecTimeLimit(row.TExecTimeLimit||'') ;
			
			
		}else{
			common.setData(GV.arr,'',{TActive:'Y',TAllowReply:'Y',TDischAutoExec:'Y',TCatgory:'B'});
			GV.setExecTimeLimit('');
		}
		common.validate(GV.arr);
	}
	GV.getEditVal=function(){
		var data=common.getData(GV.arr,'T');
		data.Id=data.ActionId;
		if (data.ReceiveTypeDr>0) {
			data.ReceiveTypeDesc=$('#TReceiveTypeDr').combogrid('getText');
		}else{
			data.ReceiveTypeDesc='';
		}
		data.SendMode=data.SendModeCode;
		
		data.ExecTimeLimit=GV.getExecTimeLimit();
		
		var isValid=common.validate(GV.arr);
		data.isValid=isValid;
		return data;
	}
	
	initExecTimeLimit()
}


var init=function(){
	initEidtWin();
	
	
	
	$('#tDHCMessageActionType').datagrid({
		border:false,
		headerCls:'panel-header-gray',
        pagination: true,
        pageSize:20,
        pageList:[10,15,20,30,50,100,200,1000],
        striped:true,
        singleSelect:true,
        idField:'TActionId',
        rownumbers:true,
        url:$URL,
        queryParams:{
	        ClassName:'websys.DHCMessageActionTypeMgr',
	        QueryName:'LookUp',
	        Active:'Y'
	    },
	    fit:true,
	    fitColumns:false,
	    //TActionId:%String,TCode:%String,TDesc:%String,TReceiveTypeDr:%String,TReceiveTypeDesc:%String,TLevelType:%String,TSendMode:%String,TActive:%String,TSendModeCode:%String,TCC:%String,TCCRowIds:%String,TTeamExec:%String,TExecMethod:%String,TExecLink:%String,TToolbarItems:%String,TOnlySameLocFlag:%String,TEffectiveDays:%String,TNote:%String,TReadCallbackMethod:%String,TDischAutoExec:%String,THideSendUser,THideReceiveUser,TPopupInterval,TAudioName,TDialogStyle,THasAdvancedCfg,TMarqueeShow,TAllowReply,THideExp,TAudioContent,TBizExecMethod,TSequence
	    columns:[[
	    	{field:'TCode',title:'��������',width:80,hidden:false},
	    	{field:'TDesc',title:'��������',width:120,hidden:false},
	    	{field:'TReceiveTypeDr',title:'���ն�������',width:100,align:'left',hidden:true},
	    	{field:'TLevelType',title:'��Ҫ�Եȼ�',width:100,align:'left',hidden:false},
	    	{field:'TSendMode',title:'��Ϣ���ͷ�ʽ',width:100,align:'left',hidden:false},
	    	{field:'TActionId',title:'��������',width:100,align:'left',hidden:true},
	    	{field:'TReceiveTypeDesc',title:'���ն�����������',width:120,hidden:false},
	    	{field:'ReceiveCfg',title:'�߼����ն�������',formatter:function(val,row,ind){
				if (row.THasAdvancedCfg && row.THasAdvancedCfg=="1") {
					return '<a href="javascript:void(0);" data-key="'+row.TCode+'" data-desc="'+row.TDesc+'" class="rec-cfg-btn">'+row.TCode+'</a>'
				}else{
					return '<a href="javascript:void(0);" data-key="'+row.TCode+'" data-desc="'+row.TDesc+'" class="rec-cfg-btn">��������</a>'
				}
			},width:100},
	    	{field:'TActive',title:'����',width:50,hidden:false},
	    	{field:'TCC',title:'������',width:100,align:'left',hidden:false,formatter:function(val,row,ind){
		    	if(val) {
			    	return '<a href="javascript:void(0);" data-ind="'+ind+'" class="act-cc-btn">'+val+'</a>';
			    }
		    	return '<a href="javascript:void(0);" data-ind="'+ind+'" class="act-cc-btn">��ӳ�����</a>';
		    }},
	    	{field:'TCCRowIds',title:'������rowids',width:100,align:'left',hidden:true},
	    	{field:'TTeamExec',title:'����һ��ִ��',width:100,align:'left',hidden:false},
	    	{field:'TExecMethod',title:'ִ������жϷ���',width:100,align:'left',hidden:true},
	    	{field:'TExecLink',title:'��Ϣ��������',width:100,align:'left',hidden:false},
	    	{field:'TToolbarItems',title:'��ϸ��Ϣ���水ť��',width:100,align:'left',hidden:false},
	    	{field:'TOnlySameLocFlag',title:'���¼����',width:100,align:'left',hidden:false},
	    	{field:'TEffectiveDays',title:'��Ч����',width:100,align:'left',hidden:false},
	    	{field:'TNote',title:'��ע',width:100,align:'left',hidden:false},
	    	{field:'TReadCallbackMethod',title:'����Ϣ�ص�����',width:100,align:'left',hidden:false},
	    	{field:'TDischAutoExec',title:'���˳�Ժ�Զ�����',width:100,align:'left',hidden:false},
	    	{field:'TSendModeCode',title:'TSendModeCode',width:100,align:'left',hidden:true},
	    	{field:'THideSendUser',title:'���ط�����',width:100,align:'left',hidden:false},
	    	{field:'THideReceiveUser',title:'���ؽ�����',width:100,align:'left',hidden:false},
	    	{field:'TPopupInterval',title:'�������(����)',width:100,align:'left',hidden:false},
	    	{field:'TAudioName',title:'��Ƶ�ļ�',width:100,align:'left',hidden:false},
	    	{field:'TDialogStyle',title:'������ʽ',width:100,align:'left',hidden:false},
	    	{field:'THasAdvancedCfg',title:'THasAdvancedCfg',width:100,align:'left',hidden:true},
	    	{field:'TMarqueeShow',title:'�������ʾ',width:100,align:'left',hidden:true},
	    	{field:'TAllowReply',title:'����ظ�',width:100,align:'left',hidden:false},
	    	{field:'THideExp',title:'������Ч�ڲ���ʾ',width:100,align:'left',hidden:false},
	    	{field:'TAudioContent',title:'��Ƶ��ʾ����',width:100,align:'left',hidden:false},
	    	{field:'TBizExecMethod',title:'ҵ������',width:100,align:'left',hidden:false},
	    	{field:'TSequence',title:'˳��',width:100,align:'left',hidden:false}
	    	,{field:'TCatgoryDesc',title:'��Ϣ����',width:100,align:'left',hidden:false}
	    	,{field:'TExecTimeLimit',title:'��������',width:100,align:'left',hidden:false,formatter:function(val){return val==''?'������':'<span style="color:red;">��</span>'; }}
	    	,{field:'TCellContentStyle',title:'���ݵ�Ԫ����ʽ',width:100,align:'left',formatter:function(){
		    	return '��Ϣ������Ϣ����'	
		    },styler:function(val,row,ind){
				var css="cursor:pointer;"  
				if (row.TLevelType=='������Ϣ' || row.TLevelType=='�ǳ���Ҫ') {
					css+='color:red;'	
				} 
				if (val) css+=val;
				return css;
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
				var row=$('#tDHCMessageActionType').datagrid('getSelected');
				if(row && row.TActionId) {
					$('#win').dialog('open').dialog('setTitle','�޸�');
					GV.setEditVal(row)
				}else{
					$.messager.popover({msg:'��ѡ��һ����¼',type:'alert'})	
				}
				
			} 
		},{
			id:'tb-remove',
			iconCls:'icon-remove',
			text:'ɾ��',
			handler:function(){
				var row=$('#tDHCMessageActionType').datagrid('getSelected');
				if(row && row.TActionId) {
					$.messager.confirm('��ʾ','ȷ��ɾ��������¼ô��',function(r){
						if(r){
							$.m({ClassName:'websys.DHCMessageActionTypeMgr',MethodName:'Delete',Id:row.TActionId},function(ret){
								if (ret>0) {
									$.messager.popover({msg:'ɾ���ɹ�',type:'success'});
									$('#tDHCMessageActionType').datagrid('reload');
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
		},{
			id:'tb-cc',
			iconCls:'icon-person',
			text:'ά��������',
			handler:function(){
				var row=$('#tDHCMessageActionType').datagrid('getSelected');
				if(row && row.TActionId) {
					openCCWin(row);
				}else{
					$.messager.popover({msg:'��ѡ��һ����¼',type:'alert'})	
				}
				
			} 
		},{
			id:'tb-rec-cfg',
			iconCls:'icon-person',
			text:'ά���߼����ն���',
			handler:function(){
				var row=$('#tDHCMessageActionType').datagrid('getSelected');
				if(row && row.TActionId) {
					openRecCfgWin(row.TCode,row.TDesc);
				}else{
					$.messager.popover({msg:'��ѡ��һ����¼',type:'alert'})	
				}
				
			} 
		},{
			id:'tb-tmpl',
			iconCls:'icon-template',
			text:'ģ���',
			handler:function(){
				var row=$('#tDHCMessageActionType').datagrid('getSelected');
				if(row && row.TActionId) {
					openTmplWin(row.TCode,row.TDesc);
				}else{
					$.messager.popover({msg:'��ѡ��һ����¼',type:'alert'})	
				}
				
			} 
		}],
		onLoadSuccess:function(){
			$('.rec-cfg-btn').off('click.msg').on('click.msg',function(){
				var key=$(this).data('key'),desc=$(this).data('desc');
				openRecCfgWin(key,desc);
			})
			
			$('.act-cc-btn').off('click.msg').on('click.msg',function(){
				var ind=$(this).data('ind');
				var row=$('#tDHCMessageActionType').datagrid('getRows')[ind];
				openCCWin(row);
				
			})
			
		}
	})
	function openRecCfgWin(code,desc){
		easyModal('��'+desc+'���ĸ߼����ն�������','dhcmessage.receivecfg.csp?BizModel='+code+'','90%','90%',function(){
			$('#tDHCMessageActionType').datagrid('reload')
		});
	}
	function openTmplWin(code,desc){
		easyModal('��'+desc+'��ģ���','dhcmessage.actiontmpl.csp?ActionCode='+code+'','90%','90%',function(){
			
		});
	}
	function openCCWin(rowData){
		if (document.getElementById('#ccwin')){
			
		}else{
			$(document.body).append("<div id='ccwin'></div>");
		}
		$('#ccwin').window({
			iconCls:'icon-w-paper',
			title:"������Ա-"+rowData.TDesc,
			href:"dhcmessageucc.csp?IsHISUI=1&TCCRowIds="+rowData["TCCRowIds"]+"&ActionId="+rowData["TActionId"],  
		    cache:true,
		    width:500,  
		    height:420,  
		    minimizable:false,maximizable:false,draggable:false,resizable:false,collapsible:false,
		    modal:true
		})
		$("#ccwin").data('ActionId',rowData.TActionId);
	}
	
	
	$('#Active').combobox({
		data:[{text:'ȫ��',value:'ALL'},{text:'����',value:'Y'},{text:'δ����',value:'N'}],
		panelHeight:'auto',value:'Y',editable:false
	})
	
	$('#search').click(function(){
		var code=$('#Code').val();
		var desc=$('#Desc').val();
		var active=$('#Active').combobox('getValue');
		$('#tDHCMessageActionType').datagrid('load',{
	        ClassName:'websys.DHCMessageActionTypeMgr',
	        QueryName:'LookUp',
	        Active:active,
	        Code:code,
	        Desc:desc
	    })
	})
	$('#Code,#Desc').on('keyup',function(e){
		if(e.keyCode==13) {
			$('#search').click();
		}	
	})
}






$(init);