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
				desc:'宽(如1000或80%)'
			},{
				key:'dialogHeight',
				desc:'高(如500或80%)'
			},{
				key:'target',
				desc:'_blank新窗口<br>其它HISUI模态'
			},{
				key:'level',
				desc:'H此配置高于OtherInfoJson'
			},{
				key:'noDetailsId',
				desc:'为1不拼接消息明细记录ID参数'
			},{
				key:'execMsgOnOpen',
				desc:'弹窗时直接处理消息：<br>All处理全部,One处理自己'
			},{
				key:'clientPath',
				desc:'客户程序端路径，用于调用其它客户端'
			},{
				key:'autoOpen',
				desc:'为1时展示消息详情时自动打开业务处理界面或业务详情查看界面'
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
		keyTitle:'CSS属性名',
		keyTitle:'CSS属性值'
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
				desc:'文字颜色'
			},{
				key:'background-color',
				desc:'背景颜色'
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



/// 初始化锁定条件相关内容
function initExecTimeLimit(){
	var map={'DEF':'不区分就诊类型','O':'门诊','EO':'急诊流水','EI':'急诊留观','I':'住院','H':'体检'};

    for(var admType in map) {
        var content='<table cellspacing="0" cellpadding="0" border="0" class="elt-form-table"> \
        <tr><td class="r-label">是否锁定</td><td><input type="checkbox" class="hisui-checkbox etl-ck etl-ck-lock" id="etl-item-lock-'+admType+'" /></td></tr>\
        <tr><td class="r-label">锁定时间</td><td><input type="text" class="textbox etl-tb" id="etl-item-minute-'+admType+'" style="width:40px;margin-right:5px;padding-right:5px;"/>分钟不处理则锁定</td></tr>\
        <tr><td class="r-label">锁定临床类型</td><td><input type="checkbox" class="hisui-checkbox etl-ck" id="etl-item-clinic-'+admType+'-yes" label="临床" /><input type="checkbox" class="hisui-checkbox etl-ck" id="etl-item-clinic-'+admType+'-no" label="非临床" /></td></tr>\
        <tr><td class="r-label">锁定人员类型</td><td><input type="checkbox" class="hisui-checkbox etl-ck" id="etl-item-cpt-'+admType+'-DOCTOR" label="医生" /><input type="checkbox" class="hisui-checkbox etl-ck" id="etl-item-cpt-'+admType+'-NURSE" label="护士" /><input type="checkbox" class="hisui-checkbox etl-ck" id="etl-item-cpt-'+admType+'-OTHER" label="其他" /></td></tr>\
        <tr><td class="r-label">锁定特殊人员</td><td><input type="checkbox" class="hisui-checkbox etl-ck" id="etl-item-role-'+admType+'-OrdDoc" label="开单医生" /><input type="checkbox" class="hisui-checkbox etl-ck" id="etl-item-role-'+admType+'-AdmDoc" label="主管医生" /></td></tr>\
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
        /// 标版仍然考虑保留和之前项目实现兼容的结构
        /// 就诊类型:限制分钟:人员类型:特殊角色(AdmDoc/OrdDoc):最大时长:就诊科室:是否临床科室
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
		{PCode:"COMPUTER_NAME",PDesc:"电脑名"},
		{PCode:"LOGON.CTLOCDESC",PDesc:"登录科室名称"},
		{PCode:"LOGON.CTLOCID",PDesc:"登录科室ID"},
		{PCode:"LOGON.GROUPDESC",PDesc:"登录安全组名称"},
		{PCode:"LOGON.GROUPID",PDesc:"登录安全组ID"},
		{PCode:"LOGON.HOSPDESC",PDesc:"登录院区名称"},
		{PCode:"LOGON.HOSPID",PDesc:"登录院区ID"},
		{PCode:"LOGON.LANGCODE",PDesc:"语言代码"},
		{PCode:"LOGON.LANGID",PDesc:"语言ID"},
		{PCode:"LOGON.SSUSERLOGINID",PDesc:"登录日志ID"},
		{PCode:"LOGON.USERCODE",PDesc:"登录用户工号"},
		{PCode:"LOGON.USERID",PDesc:"登录用户ID"},
		{PCode:"LOGON.USERNAME",PDesc:"登录用户姓名"},
		{PCode:"LOGON.WARDDESC",PDesc:"登录病区名称"},
		{PCode:"LOGON.WARDID",PDesc:"登录病区ID"},
		
		{PCode:"DetailsId",PDesc:"消息明细记录ID"},
		{PCode:"PatientId",PDesc:"患者ID"},
		{PCode:"EpisodeId",PDesc:"就诊ID"},
		{PCode:"OEOrdItemId",PDesc:"医嘱ID"},
		{PCode:"SendUserDesc",PDesc:"发送用户"},
		{PCode:"Content",PDesc:"消息内容"},
		{PCode:"SendDate",PDesc:"发送日期"},
		{PCode:"SendTime",PDesc:"发送时间"},
		{PCode:"ActionCode",PDesc:"消息类型代码"},
		{PCode:"ActionDesc",PDesc:"消息类型名称"},
		{PCode:"TReadFlag",PDesc:"阅读标志"},
		{PCode:"TExecFlag",PDesc:"处理标志"},
		{PCode:"BedNo",PDesc:"床号"},
		{PCode:"AdmLoc",PDesc:"就诊科室"},
		{PCode:"PatName",PDesc:"患者姓名"},
		{PCode:"AdmDoctor",PDesc:"主管医生"},
		{PCode:"AdmPapmiNo",PDesc:"患者登记号"},
		{PCode:"Age",PDesc:"年龄"},
		{PCode:"ContentId",PDesc:"消息内容ID"},
		{PCode:"Context",PDesc:"消息内容"},
		{PCode:"CreateLoc",PDesc:"发送科室"},
		{PCode:"Diagnosis",PDesc:"诊断"},
		{PCode:"Name",PDesc:"患者姓名"},
		{PCode:"SendUser",PDesc:"发送用户"},
		{PCode:"Sex",PDesc:"性别"},
		{PCode:"SexZH",PDesc:"性别(中)"}
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
			{field:'PCode',title:'占位符',width:200},
			{field:'PDesc',title:'说明',width:200}
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
		columns:[[{field:'DHCReceiveDesc',title:'描述',width:200},{field:'DHCReceiveCode',title:'代码',width:200}]],
		pagination:true
	});
	GV.SendModeJson=$.cm({ClassName:'websys.DHCMessageActionTypeMgr',MethodName:'OutSendModeJSON'},false)
	GV.LevelTypeJson = [{Code:"G",Desc:"一般消息"},{Code:"I",Desc:"重要消息"},{Code:"V",Desc:"非常重要"},{Code:"D",Desc:"紧急消息"}];
	GV.TeamExecJson = [{Code:"N",Desc:"消息相互独立,读后自己消息不显示"},{Code:"Y",Desc:"需要处理"}];
	GV.ToolItemsJson = [{id:"E",text:"执行按钮"},{id:"EMRView",text:"病历浏览"}]; //,{id:"R",text:"回复按钮"}
	GV.CatgoryJson=[{value:'B',text:'业务类'},{value:'N',text:'通知类'}];
	
	$('#TSendModeCode').combobox({
		valueField:'id',
		textField:'text',
		multiple:true,
		rowStyle:'checkbox', //显示成勾选行形式
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
		rowStyle:'checkbox', //显示成勾选行形式
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
		title:'新增',
		iconCls:'icon-w-paper',
		buttons:[{
			text:'确定',
			handler:function(){
				var data=GV.getEditVal();
				if (!data.isValid) {
					$.messager.popover({msg:'数据验证失败',type:'error'});
					return;}
				delete data.isValid;
				$.extend(data,{ClassName:'websys.DHCMessageActionTypeMgr',MethodName:'Save'});
				
				
				$.m(data,function(ret){
					if (ret>0) {
						$.messager.popover({msg:'保存成功',type:'success'});
						$('#win').dialog('close');
						$('#tDHCMessageActionType').datagrid('reload');
					}else{
						$.messager.popover({msg:'保存失败'+ret.split('^')[1]||ret,type:'error'});
					}
				})
			}	
		},{
			text:'取消',
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
	    	{field:'TCode',title:'动作代码',width:80,hidden:false},
	    	{field:'TDesc',title:'动作描述',width:120,hidden:false},
	    	{field:'TReceiveTypeDr',title:'接收对象类型',width:100,align:'left',hidden:true},
	    	{field:'TLevelType',title:'重要性等级',width:100,align:'left',hidden:false},
	    	{field:'TSendMode',title:'消息发送方式',width:100,align:'left',hidden:false},
	    	{field:'TActionId',title:'动作主键',width:100,align:'left',hidden:true},
	    	{field:'TReceiveTypeDesc',title:'接收对象类型描述',width:120,hidden:false},
	    	{field:'ReceiveCfg',title:'高级接收对象配置',formatter:function(val,row,ind){
				if (row.THasAdvancedCfg && row.THasAdvancedCfg=="1") {
					return '<a href="javascript:void(0);" data-key="'+row.TCode+'" data-desc="'+row.TDesc+'" class="rec-cfg-btn">'+row.TCode+'</a>'
				}else{
					return '<a href="javascript:void(0);" data-key="'+row.TCode+'" data-desc="'+row.TDesc+'" class="rec-cfg-btn">增加配置</a>'
				}
			},width:100},
	    	{field:'TActive',title:'启用',width:50,hidden:false},
	    	{field:'TCC',title:'抄送人',width:100,align:'left',hidden:false,formatter:function(val,row,ind){
		    	if(val) {
			    	return '<a href="javascript:void(0);" data-ind="'+ind+'" class="act-cc-btn">'+val+'</a>';
			    }
		    	return '<a href="javascript:void(0);" data-ind="'+ind+'" class="act-cc-btn">添加抄送人</a>';
		    }},
	    	{field:'TCCRowIds',title:'抄送人rowids',width:100,align:'left',hidden:true},
	    	{field:'TTeamExec',title:'多人一人执行',width:100,align:'left',hidden:false},
	    	{field:'TExecMethod',title:'执行完成判断方法',width:100,align:'left',hidden:true},
	    	{field:'TExecLink',title:'消息处理链接',width:100,align:'left',hidden:false},
	    	{field:'TToolbarItems',title:'详细消息界面按钮组',width:100,align:'left',hidden:false},
	    	{field:'TOnlySameLocFlag',title:'需登录科室',width:100,align:'left',hidden:false},
	    	{field:'TEffectiveDays',title:'有效天数',width:100,align:'left',hidden:false},
	    	{field:'TNote',title:'备注',width:100,align:'left',hidden:false},
	    	{field:'TReadCallbackMethod',title:'读消息回调方法',width:100,align:'left',hidden:false},
	    	{field:'TDischAutoExec',title:'病人出院自动处理',width:100,align:'left',hidden:false},
	    	{field:'TSendModeCode',title:'TSendModeCode',width:100,align:'left',hidden:true},
	    	{field:'THideSendUser',title:'隐藏发送人',width:100,align:'left',hidden:false},
	    	{field:'THideReceiveUser',title:'隐藏接收人',width:100,align:'left',hidden:false},
	    	{field:'TPopupInterval',title:'弹出间隔(分钟)',width:100,align:'left',hidden:false},
	    	{field:'TAudioName',title:'音频文件',width:100,align:'left',hidden:false},
	    	{field:'TDialogStyle',title:'弹出样式',width:100,align:'left',hidden:false},
	    	{field:'THasAdvancedCfg',title:'THasAdvancedCfg',width:100,align:'left',hidden:true},
	    	{field:'TMarqueeShow',title:'跑马灯显示',width:100,align:'left',hidden:true},
	    	{field:'TAllowReply',title:'允许回复',width:100,align:'left',hidden:false},
	    	{field:'THideExp',title:'超过有效期不显示',width:100,align:'left',hidden:false},
	    	{field:'TAudioContent',title:'音频提示内容',width:100,align:'left',hidden:false},
	    	{field:'TBizExecMethod',title:'业务处理方法',width:100,align:'left',hidden:false},
	    	{field:'TSequence',title:'顺序',width:100,align:'left',hidden:false}
	    	,{field:'TCatgoryDesc',title:'消息大类',width:100,align:'left',hidden:false}
	    	,{field:'TExecTimeLimit',title:'锁定条件',width:100,align:'left',hidden:false,formatter:function(val){return val==''?'不锁定':'<span style="color:red;">有</span>'; }}
	    	,{field:'TCellContentStyle',title:'内容单元格样式',width:100,align:'left',formatter:function(){
		    	return '消息内容消息内容'	
		    },styler:function(val,row,ind){
				var css="cursor:pointer;"  
				if (row.TLevelType=='紧急消息' || row.TLevelType=='非常重要') {
					css+='color:red;'	
				} 
				if (val) css+=val;
				return css;
			}}
	    ]],
	    toolbar:[{
			id:'tb-add',
			iconCls:'icon-add',
			text:'新增',
			handler:function(){
				$('#win').dialog('open').dialog('setTitle','新增');
				GV.setEditVal();
			} 
		},{
			id:'tb-edit',
			iconCls:'icon-edit',
			text:'修改',
			handler:function(){
				var row=$('#tDHCMessageActionType').datagrid('getSelected');
				if(row && row.TActionId) {
					$('#win').dialog('open').dialog('setTitle','修改');
					GV.setEditVal(row)
				}else{
					$.messager.popover({msg:'请选择一条记录',type:'alert'})	
				}
				
			} 
		},{
			id:'tb-remove',
			iconCls:'icon-remove',
			text:'删除',
			handler:function(){
				var row=$('#tDHCMessageActionType').datagrid('getSelected');
				if(row && row.TActionId) {
					$.messager.confirm('提示','确认删除此条记录么？',function(r){
						if(r){
							$.m({ClassName:'websys.DHCMessageActionTypeMgr',MethodName:'Delete',Id:row.TActionId},function(ret){
								if (ret>0) {
									$.messager.popover({msg:'删除成功',type:'success'});
									$('#tDHCMessageActionType').datagrid('reload');
								}else{
									$.messager.popover({msg:'删除失败'+ret.split('^')[1]||ret,type:'error'});
								}
							})	
						}	
					})
				}else{
					$.messager.popover({msg:'请选择一条记录',type:'alert'})	
				}
			} 
		},{
			id:'tb-cc',
			iconCls:'icon-person',
			text:'维护抄送人',
			handler:function(){
				var row=$('#tDHCMessageActionType').datagrid('getSelected');
				if(row && row.TActionId) {
					openCCWin(row);
				}else{
					$.messager.popover({msg:'请选择一条记录',type:'alert'})	
				}
				
			} 
		},{
			id:'tb-rec-cfg',
			iconCls:'icon-person',
			text:'维护高级接收对象',
			handler:function(){
				var row=$('#tDHCMessageActionType').datagrid('getSelected');
				if(row && row.TActionId) {
					openRecCfgWin(row.TCode,row.TDesc);
				}else{
					$.messager.popover({msg:'请选择一条记录',type:'alert'})	
				}
				
			} 
		},{
			id:'tb-tmpl',
			iconCls:'icon-template',
			text:'模板绑定',
			handler:function(){
				var row=$('#tDHCMessageActionType').datagrid('getSelected');
				if(row && row.TActionId) {
					openTmplWin(row.TCode,row.TDesc);
				}else{
					$.messager.popover({msg:'请选择一条记录',type:'alert'})	
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
		easyModal('【'+desc+'】的高级接收对象配置','dhcmessage.receivecfg.csp?BizModel='+code+'','90%','90%',function(){
			$('#tDHCMessageActionType').datagrid('reload')
		});
	}
	function openTmplWin(code,desc){
		easyModal('【'+desc+'】模板绑定','dhcmessage.actiontmpl.csp?ActionCode='+code+'','90%','90%',function(){
			
		});
	}
	function openCCWin(rowData){
		if (document.getElementById('#ccwin')){
			
		}else{
			$(document.body).append("<div id='ccwin'></div>");
		}
		$('#ccwin').window({
			iconCls:'icon-w-paper',
			title:"抄送人员-"+rowData.TDesc,
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
		data:[{text:'全部',value:'ALL'},{text:'启用',value:'Y'},{text:'未启用',value:'N'}],
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