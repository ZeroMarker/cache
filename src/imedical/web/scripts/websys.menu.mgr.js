function calMenuEditWinSize(){
	GV.maxHeight=$(window).height()||550;
	GV.maxWidth=$(window).width()||1366;
	var maxWidth=GV.maxWidth-20;
	var bestWidth=1250;
	var maxHeight=GV.maxHeight-40;
	if(0&&$('form').find('#edit-sep-text').text()=='��ʾ����'){
		var bestHeight=$('form').find('.i-searchbox').height()+$('form').find('#edit-sep').height()+107;
	}else{
		var bestHeight=maxHeight;
	}
	//console.log('MenuEditWinSize',{width:Math.min(maxWidth,bestWidth),height:Math.min(maxHeight,bestHeight)});
	return {width:Math.min(maxWidth,bestWidth),height:Math.min(maxHeight,bestHeight)};
	
}
(function($){
	$.fn.combogrid.defaults.height=30;
	///�˵��༭���ڵĴ�
	$.fn.dialog.methods.open2=function(jq){
		return jq.each(function(){
			//ID 
			if($('#ID').val()=="" || $('#ID').val()>=50000){
				$('#edit-win-buttons-save').show();
			}else{
				$('#edit-win-buttons-save').hide();
			}
			$(this).dialog('open').dialog('resize',calMenuEditWinSize()).dialog('center');
		})
	};
	

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
    };
    
    $.fn.searchbox.methods._search=function (jq,param) {
    	return jq.each(function(){
	    	$.data(this, "searchbox").searchbox.find(".searchbox-button").click();
	    })
    };
	
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
var GV={}  ;//���ȫ�ֱ���
var init=function(){
	var HUI_HospList=GenHospComp('websys.Menu');
	GV.getSelectHospId=function(){
		return $("#_HospList").combogrid('getValue');
	}
	GV.selectHospId=GV.getSelectHospId();
	HUI_HospList.options().onSelect=function(){
		debounced_onHospSelect();
	}
	
	
	function onHospSelect(){ 
		var selectHospId=GV.getSelectHospId();
		if (GV.selectHospId!=selectHospId) { //��ѡ��ҽԺʱ ��Ҫ�ı�һϵ�е�ֵ
			//alert('debounced_onHospSelect and hospChanged');
			GV.selectHospId=GV.getSelectHospId();
			//1.�˵�ҳǩ
			$('#menu-submenuof').combogrid('setRemoteValue',{}); //�˵����Ժ���й�
			$('#menu-search').click(); //����һ�β�ѯ
			//2.�˵��༭
			$('#SubMenuOf').combogrid('setRemoteValue',{}); //�˵����Ժ���й�
			$('#AuthGroup').combogrid('setRemoteValue',{}); //�����˵���ʾ�İ�ȫ��
			//3.����ȫ��ά��ҳǩ
			$('#group-search').searchbox('_search');
			//4.�˵���ȫ����Ȩ
			$('#security-group-search').searchbox('_search');
			
			
		}

		
		
	}
	var debounced_onHospSelect=debounce(onHospSelect,200);
	
	
	
	GV.maxHeight=$(window).height()||550;
	GV.maxWidth=$(window).width()||1366;
	$('#Loading').fadeOut('fast');
	initTabMenu();
	initTabGroup();
	initTabSecurity();
	setTimeout(function(){
		$('body').append($('#my-html-wins').html());
		$.parser.parse('#edit-win');
		$.parser.parse('#menu-security-win');
		initMenuEditWin();
		initMenuSecurityWin();
		initMenuExport(); //�����б��ʼ��
	},200)
}
var closeHospWinCallback = function(obj){
	$("#menu-list").datagrid("load");
}
//======��ʼ�����˵�ά��ҳǩ=========================================================================================================
var initTabMenu=function(){
	//��� Name:%String,ClassName:%String,QueryName:%String,HIDDEN
	$('#menu-component').combogrid({
		panelWidth:540,
		panelHeight:300,
		pagination:true,
		delay: 500,
		mode: 'remote',
		queryParams:{ClassName:"websys.Component",QueryName: "LookUpByName",name:""},
		url: 'websys.Broker.cls',
		idField: 'Name', //'HIDDEN',  HIDDENʵ�������� ����id
		textField: 'Name',
		onBeforeLoad:function(param){
			param = $.extend(param,{name:param.q});
			return true;
		},
		columns: [[{field:'Name',title:'�����',width:250},{field:'ClassName',title:'������',width:130},{field:'QueryName',title:'����Query',width:130},{field:'HIDDEN',title:'HIDDEN',align:'right',hidden:true}]]
		,lazy:true
	})
	//�˵��� Name:%String,Caption:%String
	$('#menu-submenuof').combogrid({
		panelWidth:500,
		panelHeight:300,
		pagination:true,displayMsg:'',
		delay: 500,
		mode: 'remote',
		queryParams:{ClassName:"websys.Menu",QueryName: "Find",onlyMenuGroup:'1'}, //{ClassName:"websys.Menu",QueryName: "FindByLinkUrl",name:""},
		url: 'websys.Broker.cls',
		idField: 'Name',
		textField: 'Name',
		onBeforeLoad:function(param){
			//param = $.extend(param,{name:param.q});
			param = $.extend(param,{caption:param.q});
			param.HospId=GV.getSelectHospId(); //add ��ǰѡ��Ժ�� 2020-06-13
			return true;
		},
		columns: [[{field:'Name',title:'����',width:220},{field:'Caption',title:'����',width:220}]]
		,lazy:true

	})

	//������ Description:%String,HIDDEN:%String,Code:%String
	$('#menu-workflow').combogrid({
		panelWidth:830,
		panelHeight:300,
		pagination:true,
		delay: 500,
		mode: 'remote',
		queryParams:{ClassName:"websys.WorkFlow",QueryName: "LookUp",desc:""},
		url: 'websys.Broker.cls',
		idField: 'HIDDEN',
		textField: 'Description',
		onBeforeLoad:function(param){
			param = $.extend(param,{desc:param.q});
			return true;
		},
		columns: [[{field:'Description',title:'����',width:400},{field:'Code',title:'����',width:400},{field:'HIDDEN',title:'HIDDEN',hidden:true}]]
		,lazy:true
	})
	GV.menu_list=$HUI.datagrid('#menu-list',{
		//width:GV.maxWidth-25,
		//height:GV.maxHeight-100,
		fit:true,
		border:false,
		singleSelect:true,
		pagination:true,
		pageSize:30,
		columns:[[
			{field:'Caption',title:'����',width:200,formatter:function(value,row,index){
				return "<a href='javascript:void(0);' onclick='GV.showMenuEditWin("+row.ID+",\"datagrid\")'>"+value+"</a>";
			}},
			{field:'Name',title:'����',width:200},
			{field:'SubMenuOfName',title:'�˵���',width:200,formatter:function(value,row,index){
				return "<a href='javascript:void(0);' onclick='GV.showMenuEditWin("+row.SubMenuOf+",\"datagrid\")'>"+value+"</a>";
			}},
			{field:'Workflow',title:'������',width:200},
			{field:'ID',title:'ID',hidden:true},
			{field:'Security',title:'����ͨ��',formatter:function(value,row,index){
				return "<span onclick='GV.showMenuSecurityWin("+row.ID+",\""+row.Name+"\",\""+row.Caption+"\")' class='icon-security'>&nbsp;</span>";
			}},
			{field:'HospsDesc',title:'�ɼ�ҽԺ',width:200}
			,{field:'OpExport',title:'����',width:50,formatter:function(value,row,index){
				return "<span style='display:inline-block;width:30px;cursor:pointer;' class='icon-export' onclick='GV.addToExportList("+row.ID+",\""+row.Name+"\",\""+row.Caption+"\")'>&nbsp;</span>";
			}}
		]],
		idField:'ID',
		url:"",data:[],
		toolbar:'#menu-list-tb',
		onBeforeLoad:function(){
			if(GV.menu_list){
				GV.menu_list.unselectAll();
				fixtb();
			}
		},
		onClickRow:function(index,row){
			fixtb(row.ID);
		},
		onDblClickRow : function(rowIndex, rowData){
			GenHospWin("websys.Menu",rowData["ID"],closeHospWinCallback);
		}
	})
	//��ʼ��ʱurl���գ���ȥ���أ�Ȼ���ٸ�ֵ����ͨ��ˢ�¿��Լ���
	GV.menu_list.options().url="websys.Broker.cls";
	GV.menu_list.options().queryParams=$.extend(GV.menu_list.options().queryParams,{ClassName:'websys.Menu',QueryName:'Find'});
	var menuSearchHandler=function(){
		GV.menu_list.options().url="websys.Broker.cls";
		GV.menu_list.load({
			ClassName:'websys.Menu',
			QueryName:'Find',
			caption:$('#menu-caption').val(),
			name:$('#menu-name').val(),
			submenuof:$('#menu-submenuof').combogrid('getText'),
			Component:$('#menu-component').combogrid('getText'),
			workflow:$('#menu-workflow').combogrid('getText'),
			filterMenuGroupOnly:0 //�˵��鲻Ϊ��ʱ���Ƿ�ֻ���˵����ѯ������ѯ
			,HospId:GV.getSelectHospId()
		})
	}
	$('#menu-search').click(menuSearchHandler);
	$('#menu-caption,#menu-name').on('keyup',debounce(function(e){
		if (e.keyCode == 13) {
			menuSearchHandler();
		}
	},200));
	$('#menu-more-btn').click(function(){
		var t=$(this);
		if (t.find('.l-btn-text').text()=="����"){
			//GV.menu_list.resize({height:GV.maxHeight-100-41});
			$('#layout-tab-menu').layout('panel','north').panel('resize',{height:90});
			$('#layout-tab-menu').layout('resize');
			t.find('.l-btn-text').text("����");
			$('#menu-more-div').slideDown("fast");
			
		}else{
			$('#menu-more-div').slideUp('fast',function(){
				//GV.menu_list.resize({height:GV.maxHeight-100});
				$('#layout-tab-menu').layout('panel','north').panel('resize',{height:50});
				$('#layout-tab-menu').layout('resize');
				t.find('.l-btn-text').text("����");
				//����ʱ �����������ÿ�
				$('#menu-workflow').combogrid('clear');
				$('#menu-submenuof').combogrid('clear');
			});

		}
	})
	function fixtb(id){
		if (id>0) $('#menu-list-tb-copy').linkbutton('enable');
		else  $('#menu-list-tb-copy').linkbutton('disable');
		if(id && id>=50000){
			$('#menu-list-tb-edit').linkbutton('enable');
			$('#menu-list-tb-remove').linkbutton('enable');
		}else{
			$('#menu-list-tb-edit').linkbutton('disable');
			$('#menu-list-tb-remove').linkbutton('disable');
		}
	};


	$('#menu-list-tb-add').click(function(){
		if(!$(this).hasClass('l-btn-disabled')){
			GV.fillMenuEditWin({ID:""},'nomore');
			GV.showMenuEidtGuide();
			//$('#edit-win').dialog('setTitle','����').dialog('open2');
		}
	})
	$('#menu-list-tb-edit').click(function(){
		if(!$(this).hasClass('l-btn-disabled')){
			var row=GV.menu_list.getSelected();
			if(row && row.ID) {
				GV.showMenuEditWin(row.ID,"datagrid");
			}else{
				//$.messager.alert("����","��ѡ����");
				$.messager.popover({msg:'��ѡ����',type:'alert'});
			}
		}
	})
	$('#menu-list-tb-remove').click(function(){
		if(!$(this).hasClass('l-btn-disabled')){
			var row=GV.menu_list.getSelected();
			if(row && row.ID) {
				$.messager.confirm("ɾ��","ȷ��Ҫɾ���˵���"+row.Caption+"����",function(r){
					if(r){
						GV.deleteMenu(row.ID,function(){
							GV.menu_list.reload();
						});
					}
				})
			}else{
				$.messager.popover({msg:'��ѡ����',type:'alert'});
				//$.messager.alert("����","��ѡ����");
			}
		}
	})
	$('#menu-list-tb-copy').click(function(){
		if(!$(this).hasClass('l-btn-disabled')){
			var row=GV.menu_list.getSelected();
			if(row && row.ID) {
				GV.copyMenu(row.ID,'datagrid');
				
			}else{
				$.messager.popover({msg:'��ѡ����',type:'alert'});
			}
		}
	})
	$('#menu-list-tb-import').click(function(){ //�˵�����
		GV.showMenuImportWin();	
	})
	GV.deleteMenu=function(id,fn){
		$.m({ClassName:'websys.Menu',MethodName:'DeleteById',Id:id},function(rtn){
			if(rtn>0){
				//$.messager.alert("�ɹ�","ɾ���ɹ�");
				$.messager.popover({msg:'ɾ���ɹ�',type:'success'});
				if(typeof fn=="function") fn();
			}else{
				//$.messager.alert("ʧ��",rtn.split("^")[1]||"ɾ��ʧ��,ԭ��δ֪");
				$.messager.popover({msg:rtn.split("^")[1]||"ɾ��ʧ��,ԭ��δ֪",type:'error'});
			}
		})
	}
	$.m({ClassName:'BSP.GRPHOSP.SRV.Interface',MethodName:'IsSuperAdmin'},function(ret){
		if (ret==1){
			initInitHospGrant();
		}	
	})
};   //end initTabMenu============================================================

var initInitHospGrant=function(){
	window.opClick=function(type,that){
		var hospid=$(that).data('id');
		var hospDesc=$(that).data('hosp');
		if (type==1){
			$.messager.prompt('��Ȩ','�����в˵�����ȨҽԺ��>=���Ĳ˵���Ȩ����'+hospDesc+'��',function(r){
				if(parseInt(r)>=0) {
					$.m({ClassName:'websys.Menu',MethodName:'GrantAllMenu',HospId:hospid,RefHospCount:parseInt(r)},function(){
						$.messager.popover({msg:'��Ȩ�ɹ�',type:'success'})	;
						$('#menu-hosp-grant-win-dg').datagrid('reload');
					})	
				}else{
					$.messager.popover({msg:'��ѡ����ȡ��������Ĳ�����ȷ������',type:'error'})	;
				}
			})	
		}
	}
	$('#menu-more-btn').parent().append('<a id="menu-hosp-grant" style="margin-left:20px;" href="javascript:void(0);">�˵�ҽԺ��Ȩ</a>');
	$('#menu-hosp-grant').linkbutton({
		onClick:function(){
			if ($('#menu-hosp-grant-win').length==0){
				$('<div id="menu-hosp-grant-win" style="padding:10px;"><table id="menu-hosp-grant-win-dg"></table></div>').appendTo('body');
				$('#menu-hosp-grant-win').dialog({
					iconCls:'icon-w-paper',
					title:'�˵�ҽԺ��Ȩ',
					width:800,
					height:500	,
					modal:true
				})
				$('#menu-hosp-grant-win-dg').datagrid({
					bodyCls:'panel-header-gray',
					fit:true,
					rownumbers:true,
					url:$URL,
					pagination:true,
					pageSize:20,
					queryParams:{
						ClassName:'BSP.GRPHOSP.SRV.Interface'	,
						QueryName:'LookUpHospGrantCount',
						ObjectType:'websys.Menu'
					},
					fitColumns:true,
					idField:'HospId',
					singleSelect:true,
					columns:[[
						{field:'HospDesc',title:'ҽԺ����',width:250},
						{field:'RefCount',title:'����Ȩ�˵�����',width:150},
						{field:'Op',title:'����',width:250,formatter:function(val,row,ind){
							var op='<a onClick="opClick(1,this)" href="javascript:void(0);" data-id="'+row.HospId+'" data-hosp="'+row.HospDesc+'">��Ȩ���в˵�</a>';
							return op;
						}}
					]]
				})
			}
			$('#menu-hosp-grant-win').dialog('open');
		}
	})
}
//=====�༭����=============================================================================================
var initMenuEditWin=function(){

	$('#edit-win').dialog({
		width:1100,height:400,
		buttons:[
			{
				id:'edit-win-buttons-save',
				text:'����',
				handler:edit_win_save_handler
			},
			{
				text:'�ر�',
				handler:function(){
					$('#edit-win').dialog('close');
				}	
			}
		]
	});
	
	///У������Ƿ����
	$.extend($.fn.validatebox.defaults.rules, {
		checkCodeExist:{
		    validator: function(value){
				var url=$URL;  
				var data={ClassName:'websys.Menu',MethodName:'CheckCodeExist',Id:$('#ID').val(),Code:value};
				var rtn=$.ajax({ url: url, async: false, cache: false, type: "post" ,data:data}).responseText;
				return rtn==0;
			},
			message: '�˵������Ѵ���'
		}
	});
	$('#Name').validatebox({
		required:true,
		validType:['checkCodeExist']
	})
	$('#Caption').validatebox({
		required:true
	})
	
	//��� Name:%String,ClassName:%String,QueryName:%String,HIDDEN
	$('#LinkComponent').combogrid({
		panelWidth:540,
		panelHeight:300,
		width:200,
		pagination:true,
		delay: 500,
		mode: 'remote',
		queryParams:{ClassName:"websys.Component",QueryName: "LookUpByName",name:""},
		url: $URL,
		idField: 'Name', //'HIDDEN',  HIDDENʵ�������Ͳ���id
		textField: 'Name',
		onBeforeLoad:function(param){
			param = $.extend(param,{name:param.q});
			return true;
		},
		columns: [[{field:'Name',title:'�����',width:250},{field:'ClassName',title:'������',width:130},{field:'QueryName',title:'����Query',width:130},{field:'HIDDEN',title:'HIDDEN',align:'right',hidden:true}]]
		,lazy:true
	})
	//�˵��� Name:%String,Caption:%String
	$('#SubMenuOf').combogrid({
		panelWidth:500,
		panelHeight:300,
		width:200,
		pagination:true,
		delay: 500,
		mode: 'remote',
		queryParams:{ClassName:"websys.Menu",QueryName: "Find",onlyMenuGroup:"1"}, //{ClassName:"websys.Menu",QueryName: "FindByLinkUrl",name:""},
		url: $URL,
		idField: 'Name',
		textField: 'Name',
		onBeforeLoad:function(param){
			//param = $.extend(param,{name:param.q});
			param = $.extend(param,{caption:param.q});
			param.HospId=GV.getSelectHospId(); //add ��ǰѡ��Ժ�� 2020-06-13
			return true;
		},
		columns: [[{field:'Name',title:'����',width:220},{field:'Caption',title:'����',width:220}]]
		,lazy:true
	})

	//������ Description:%String,HIDDEN:%String,Code:%String
	$('#WorkFlow').combogrid({
		panelWidth:830,
		panelHeight:300,
		width:200,
		pagination:true,
		delay: 500,
		mode: 'remote',
		queryParams:{ClassName:"websys.WorkFlow",QueryName: "LookUp",desc:""},
		url: $URL,
		idField: 'HIDDEN',
		textField: 'Description',
		onBeforeLoad:function(param){
			param = $.extend(param,{desc:param.q});
			return true;
		},
		columns: [[{field:'Description',title:'����',width:400},{field:'Code',title:'����',width:400},{field:'HIDDEN',title:'HIDDEN',hidden:true}]]
		,lazy:true
	})
	//�����б� Description:%String,HIDDEN:%String,Code:%String
	$('#Worklist').combogrid({
		panelWidth:500,
		panelHeight:300,
		width:200,
		pagination:true,
		delay: 500,
		mode: 'remote',
		queryParams:{ClassName:"epr.Worklist",QueryName: "LookUp",desc:""},
		url: $URL,
		idField: 'HIDDEN',
		textField: 'Description',
		onBeforeLoad:function(param){
			param = $.extend(param,{desc:param.q});
			return true;
		},
		columns: [[{field:'Description',title:'����',width:220},{field:'Code',title:'����',width:220},{field:'HIDDEN',title:'HIDDEN',hidden:true}]]
		,lazy:true
	})
	//ͼ�� Description:%String,HIDDEN:%String,Code:%String
	$('#Chart').combogrid({
		panelWidth:500,
		panelHeight:300,
		width:200,
		pagination:true,
		delay: 500,
		mode: 'remote',
		queryParams:{ClassName:"epr.Chart",QueryName: "LookUp",desc:""},
		url: $URL,
		idField: 'HIDDEN',
		textField: 'Description',
		onBeforeLoad:function(param){
			param = $.extend(param,{desc:param.q});
			return true;
		},
		columns: [[{field:'Description',title:'����',width:220},{field:'Code',title:'����',width:220},{field:'HIDDEN',title:'HIDDEN',hidden:true}]]
		,lazy:true
	})
	//ͼ���� Description:%String,HIDDEN:%String,Code:%String
	$('#ChartBook').combogrid({
		panelWidth:500,
		panelHeight:300,
		width:200,
		pagination:true,
		delay: 500,
		mode: 'remote',
		queryParams:{ClassName:"epr.ChartBook",QueryName: "LookUp",desc:""},
		url: $URL,
		idField: 'HIDDEN',
		textField: 'Description',
		onBeforeLoad:function(param){
			param = $.extend(param,{desc:param.q});
			return true;
		},
		columns: [[{field:'Description',title:'����',width:220},{field:'Code',title:'����',width:130},{field:'HIDDEN',title:'HIDDEN',hidden:true}]]
		,lazy:true
	})
	//��˵��� MenuGroup  Description:%String,HIDDEN:%String,Code:%String
	$('#MenuGroup').combogrid({
		panelWidth:500,
		panelHeight:300,
		width:200,
		pagination:true,
		delay: 500,
		mode: 'remote',
		queryParams:{ClassName:"websys.MenuGroup",QueryName: "LookUp",desc:""},
		url: $URL,
		idField: 'HIDDEN',
		textField: 'Description',
		onBeforeLoad:function(param){
			param = $.extend(param,{desc:param.q});
			return true;
		},
		columns: [[{field:'Description',title:'����',width:220},{field:'Code',title:'����',width:130},{field:'HIDDEN',title:'HIDDEN',hidden:true}]]
		,lazy:true
	})
	$('#IsXhrRefresh').checkbox({});
	
	///���������� ��ť
	initDic();
	
	function edit_win_save_handler(){
		//linkbutton('disable')
		if ($(this).hasClass('l-btn-disabled')) return;
		
		if (!$('#JavascriptFunction').is(':visible') && $('#IfLinkAdm').closest('.ele-toggle').is(':visible')){	
			$('#JavascriptFunction').val($('#IfLinkAdm').checkbox('getValue')?'linkAdmExp':'linkSysExp');
		}
		var temp={};
		///���±��水ť
		$('#edit-win .textbox').each(function(){
			var key=this.id;
			temp[key]=this.value;
		})
		if (!$('#Caption').validatebox('isValid')){
			$.messager.popover({msg:'������֤��ͨ��',type:'error'});
			$('#Caption').closest('div').scrollTop(0);
			return;
		}
		if (!$('#Name').validatebox('isValid')){
			$.messager.popover({msg:'������֤��ͨ��',type:'error'});
			$('#Name').closest('div').scrollTop(0);
			return;
		}
		


		var arr=["LinkComponent","SubMenuOf","WorkFlow","Worklist","Chart","ChartBook","MenuGroup"];
		$.each(arr,function(i,v){
			temp[v]=$('#'+v).combogrid('getValue');
			temp[v+'Text']=$('#'+v).combogrid('getText');
		})
		temp["IsXhrRefresh"]=$('#IsXhrRefresh').checkbox('getValue')?1:0;
		var infoarr=["Caption","Name","LinkUrl","Sequence",   //1-4
					 "Image","Method","ShortcutKey","ShowInNewWindow",   //5-8
					 "ValueExpression","ConditionalExpression","JavascriptFunction","JavascriptFileName",   //9-12
					 "Target","HelpCode","HelpStyle",    //13,14,15
					 "LinkComponent","LinkComponentText","SubMenuOf","SubMenuOfText",  //16-17-18-19
					 "WorkFlow","WorkFlowText","Worklist","WorklistText",  //20-21-22-23
					 "Chart","ChartText","ChartBook","ChartBookText"  //24-25-26-27
					 ,"MenuGroup","MenuGroupText","IsXhrRefresh"  //28-29-30
					]
		$.each(infoarr,function(i,v){
			infoarr[i]=typeof temp[v]=="undefined"?"":temp[v];
		})
		//����ʱͬʱ��ȡ����Ȩ��Ϣ
		var authinfo="";
		$('.authgroup').each(function(i){
			if(i==0) authinfo=$(this).data('id');
			else  authinfo=authinfo+"^"+$(this).data('id');
		})
		
		var data={ClassName:'websys.Menu',MethodName:'Save',ID:temp.ID,info:infoarr.join('$^$'),authinfo:authinfo};
		data.HospId=GV.getSelectHospId(); //����ʱ��Ȩ����ǰѡ��ҽԺ  2020-06-13
		$.m(data,function(rtn){
			if(rtn>0){
				if(temp.ID>0){
					$.messager.popover({msg:'�޸ĳɹ�',type:'success'});
					//$.messager.alert("�ɹ�","�޸ĳɹ�");		
					$('#edit-win').dialog('close');		
				}else{
					$.messager.popover({msg:'�����ɹ�',type:'success'});
					//$.messager.alert("�ɹ�","���ӳɹ�");	
					$('#edit-win').dialog('close');
				}
				if(GV.editFrom=="tree" && GV.editPNode){
					GV.group_menu_tree.reload(GV.editPNode.target);
				}else if(GV.editFrom=="datagrid"){
					GV.menu_list.reload();
				}
			}else{
				//$.messager.alert("ʧ��",rtn.split("^")[1]||"δ֪ԭ��");
				$.messager.popover({msg:rtn.split("^")[1]||"δ֪ԭ��",type:'error'});
			}
		})

	}
	$('#edit-win-save').click(edit_win_save_handler);
	$('#edit-sep-text').click(function(){
		if($(this).text()=="��ʾ����"){
			$(this).text('���ظ���');
			$('#edit-sep').removeClass('active');
			$('#edit-more').slideDown('normal');
		}else{
			$(this).text('��ʾ����');
			$('#edit-sep').addClass('active');
			$('#edit-more').slideUp('normal');
		}
		//$('#edit-win').dialog('resize',calMenuEditWinSize()).dialog('center');
	})
	//��ȫ����Ȩ
	var recItemTmpl='\
		<div class="authgroup" title="��Ȩ����ȫ��[${desc}]" data-id="${id}" id="authgroup-${id}"><span>${desc}</span><span class="Delete" title="�Ƴ�">&times;</span></div>\
	';
	$.template('template', recItemTmpl);
	$('#auth-groups').on('click','.Delete',function(){
		$(this).parent().remove();
	})
	$('#AuthGroup').combogrid({
		width:200,
		panelWidth:230,
		panelHeight:300,
		showHeader:false,
		disabled:false,
		delay: 500,
		mode: 'remote',
		queryParams:{ClassName:"BSP.GRPHOSP.SRV.SSGroup",QueryName: "LookUpGroup",desc:""},  //��ΪBSP.GRPHOSP.SRV.SSGroup
		url: $URL,
		idField: 'HIDDEN',
		textField: 'Description',
		onBeforeLoad:function(param){
			param = $.extend(param,{desc:param.q});
			param.HospId=GV.getSelectHospId(); //add ��ǰѡ��Ժ�� 2020-06-13
			return true;
		},
		onHidePanel:function(){
			var row=$('#AuthGroup').combogrid("grid").datagrid("getSelected");
			if(row&&(row.HIDDEN>0)){
				var temp={id:row.HIDDEN,desc:row.Description};
				insertAuthGroup(temp);
				$('#AuthGroup').combogrid('clear');
			}
		},	
		columns: [[{field:'Description',title:'��ȫ��',width:210},{field:'HIDDEN',title:'HIDDEN',align:'right',hidden:true,width:0}]],
		pagination:false
		,lazy:true
	});
	function insertAuthGroup(obj){
		if($("#authgroup-"+obj.id).length>0) return;
		$.tmpl('template', obj).appendTo('#auth-groups');
	}
	GV.showMenuEditWin=function(id,from){
		$.ajaxRunServerMethod({ClassName:'websys.Menu',MethodName:'Menu2Json',menuid:id},function(rtn){
			var obj=$.parseJSON(rtn);
			//console.log(obj);
			GV.fillMenuEditWin(obj);
			
			GV.editFrom=from;   //���¼�¼ ���Ĵ򿪱༭
			if(from=="tree") {
				var t=GV.group_menu_tree.getSelected();
				var pnode=GV.group_menu_tree.getParent(t.target);
				GV.editPNode=pnode;
			}
			//console.log({width:GV.maxWidth-20,height:GV.maxHeight-20})
			GV.toggleMenuEditForm('other');//�޸�ʱȫ��ʾ
			$('#edit-win').dialog('setTitle',id>=50000?'�޸�':'�鿴').dialog('open2');
		})
	};	
	GV.fillMenuEditWin=function(obj,type){
		$('#auth-groups').empty();
		if (obj.ID>0){
			$('#authtr').hide();
		}else{
			$('#authtr').show();
			if (obj.AuthGroup){
				for (var i=0;i<obj.AuthGroup.length;i++){
					insertAuthGroup(obj.AuthGroup[i]);		
				}	
			}
		}
		$('#edit-win .textbox').each(function(){
			var key=this.id;
			this.value=obj[key]||"";
			if (obj.ID!="" && obj.ID<50000){
				this.disabled='disabled';
			}else{
				this.disabled=false;
			}
		})
		var arr=["LinkComponent","SubMenuOf","WorkFlow","Worklist","Chart","ChartBook","MenuGroup"];
		$.each(arr,function(i,v){
			$('#'+v).combogrid('setValue',obj[v]||"").combogrid('setText',obj[v+'Text']||"");
			if (obj.ID!="" && obj.ID<50000){
				$('#'+v).combogrid('disable');
			}else{
				$('#'+v).combogrid('enable');
			}
		})
		$('#IsXhrRefresh').checkbox('setValue',obj["IsXhrRefresh"]==1);
		if (obj.ID!="" && obj.ID<50000){
			$('#IsXhrRefresh').checkbox('disable');
		}else{
			$('#IsXhrRefresh').checkbox('enable');
		}
		if(type=="more"){   //��ʾ�˸���
			$('#edit-sep-text').text('��ʾ����').click();
		}else if(type=="nomore"){
			$('#edit-sep-text').text('���ظ���').click();
		}
		if (obj.ID!="" && obj.ID<50000){
			disableDic();
		}else{
			enableDic();
		}
		
		if (obj.ID!="" && obj.ID<50000){
			$('#edit-win-save').linkbutton('disable');
		}else{
			$('#edit-win-save').linkbutton('enable');
		}
		
		//����� ��֤Code �� Name
		$('#Name').validatebox('validate');
		$('#Caption').validatebox('validate');
	}
	GV.copyMenu=function(id,from){
		$.ajaxRunServerMethod({ClassName:'websys.Menu',MethodName:'Menu2Json',menuid:id},function(rtn){
			var obj=$.parseJSON(rtn);
			obj.ID=""; //,obj.SubMenuOf="",obj.SubMenuOfText="",obj.Name=obj.Name+"_COPY"
			GV.fillMenuEditWin(obj);
			GV.editFrom=from;  
			GV.toggleMenuEditForm('other'); //����ʱ�൱���޸� Ҳȫ��ʾ
			$('#edit-win').dialog('setTitle','����').dialog('open2');
			$('#Name').focus();
		})
	}
	///��ʾ�˵��༭�� �������˵�ʱ����
	GV.showMenuEidtGuide=function(){
		if ($('#edit-guide-win').length==0){
			$('<div id="edit-guide-win" style="padding:0 10px; 10px 10px"><div id="edit-guide-win-kw"></div></div>').appendTo('body');
			$('#edit-guide-win').dialog({
				width:500,
				height:250,
				title:'��ѡ��Ҫ���ӵĲ˵���������',
				iconCls:'icon-w-paper',
				closed:true,
				onOpen:function(){
					$('#edit-guide-win-kw').keywords('clearAllSelected');	
				}
			})
			$('#edit-guide-win-kw').keywords({
				onClick:function(v){
					var type=v.id.split('-').pop();
					GV.toggleMenuEditForm(type);
					$('#edit-win').dialog('setTitle','����').dialog('open2');
					$('#edit-guide-win').dialog('close');
				},
                items:[
                    {
                        text:'iMedicalϵͳ��',type:"chapter",items:[
                            {text:'CSP����',id:"g-kw-csp"},{text:'�������',id:"g-kw-comp"},{text:'�߼�',id:"g-kw-other"}
                        ]
                    },
                    {
                        text:"iMedicalϵͳ��",type:'chapter',items:[
                            {text:'����������',id:"g-kw-url"},{text:'clickonce',id:"g-kw-clickonce"},{text:'exe����',id:"g-kw-exe"}
                        ]
                    }
                ],
                singleSelect:true
		            
			})
		}
		$('#edit-guide-win').dialog('open');
		
	}
	GV.toggleMenuEditForm=function(type){
		
		if("url,exe,clickonce".indexOf(type)>-1) {
			$('#edit-sep-text').text('��ʾ����').click();
		}
		$('.ele-toggle').each(function(){
			if($(this).data('toggle').indexOf(type)>-1) {
				$(this).show();
			}else{
				$(this).hide();
			}
		})
	}

}; //end  initMenuEditWin

//====��Ȩ����============================================================================
var initMenuSecurityWin=function(){
	var winH=GV.maxHeight-100;
	var winW=430;
	$('#menu-security-win').dialog({
		height:winH,
		width:winW,
		title:'�˵���Ȩ',
		buttons:[
			{
				text:'����',
				handler:saveMenuSecurity
			},
			{
				text:'�ر�',
				handler:function(){
					$('#menu-security-win').dialog('close');
				}	
			}
		]
	});
	$('#menu-security-win-search').searchbox({
		width:winW-20-10,
		searcher:function(value){
			var MenuID=$('#menu-security-win-id').val();
			$('#menu-security-win-list').datagrid('load',{ClassName:'epr.GroupSettings',QueryName:'FindMenuAccessGroups',MenuID:MenuID,GroupDesc:value
				,HospId:GV.getSelectHospId() //add ��ǰѡ��Ժ�� 2020-06-13
			}); 
		}
	})
	$('#menu-security-win-list').datagrid({
		width:winW-20,
		height:winH-207+50,
		bodyCls:'panel-header-gray',
		singleSelect:true,
		pagination:true,
		pageSize:30,
		columns:[[
			{field:'SSGroupDesc',title:'��ȫ��',width:300},
			
			{field:'HasMenuAccess',title:'�˵���Ȩ',width:80,align:'center',formatter:function(value,row,index){
				return "<label class='checkbox-label'><input type='checkbox' data-id='"+row.SSGroupID+"'  "+(value=="1"?"checked":"")+"/> </label>";
			}},
			{field:'SSGroupID',title:'ID',hidden:true}
		]],
		idField:'SSGroupID',
		url:"",
		lazy:true,
		toolbar:'#menu-security-win-list-tb'
	})
	function saveMenuSecurity(){
		var MenuID=$('#menu-security-win-id').val();
		var data={ClassName:'epr.GroupSettings',MethodName:'SaveMenuAccessGroups',MenuID:MenuID};
		$('#menu-security-win .checkbox-label>input').each(function(i){
			data["SSGroupIDz"+i]=$(this).data('id');
			//if($(this).attr('checked')=='checked'){
			if($(this).is(':checked')){      //������attr('checked')=='checked' �ж�
				data["HasMenuAccessz"+i]='on';
			}
		})
		$.m(data,function(rtn){
			if(rtn>0){
				$.messager.popover({msg:'��Ȩ����ɹ�',type:'success',timeout:1000});
				//$.messager.alert("�ɹ�","������Ȩ�ɹ�");
				//$('#menu-security-win').dialog('close');
			}
		})
	}
	GV.showMenuSecurityWin=function(id,name,caption){
		
		$('#menu-security-win-search').searchbox('setValue','');
		//$('#menu-security-win').find('.i-searchbox tr').eq(0).find('input').val(caption);
		$('#menu-security-win-caption').text(caption);
		//$('#menu-security-win').find('.i-searchbox tr').eq(1).find('input').val(name);
		$('#menu-security-win-name').text(name);
		$('#menu-security-win-id').val(id);
		$('#menu-security-win-list').datagrid('options').url='websys.Broker.cls';
		$('#menu-security-win-list').datagrid('unselectAll').datagrid('load',{ClassName:'epr.GroupSettings',QueryName:'FindMenuAccessGroups',MenuID:id,GroupDesc:''
			,HospId:GV.getSelectHospId() //add ��ǰѡ��Ժ�� 2020-06-13
		}); 
		$('#menu-security-win').dialog('open');
	}
	
};// end initMenuSecurityWin =========================================================

//========�˵����뵼��=================================================================================================
var initMenuExport=function(){
	GV.exportList=[];
	GV.addToExportList=function(id,name,caption){
		if($('#menu-export-win').length==0){
			var maxWidth=$('#tab-menu').width(),dialogWidth=450;
			$('<div id="menu-export-win" style="padding:10px 10px 0 10px;"><table id="menu-export-list"></table><div>').appendTo('#tab-menu');
			$('#menu-export-win').dialog({
				title:'�������б�',iconCls:'icon-w-list',width:dialogWidth,height:600,left:maxWidth-dialogWidth-20,top:100,inline:true,
				buttons:[{
					text:'����',
					handler:function(){
						var rows=$('#menu-export-list').datagrid('getSelections');
						if(rows && rows.length){
							var arr=[];
							$.each(rows,function(){arr.push(this.id);})
							var menuIds=arr.join('^');
							//alert(rows.length);
							$.messager.prompt('����','�����뵼���ļ���',function(r){
								if(r && $.trim(r)){
									$.m({
										ClassName:'web.Util.MenuService',MethodName:'AjaxExport',MenuIds:menuIds,fileName:$.trim(r)
									},function(ret){
										try{
											ret=$.parseJSON(ret);	
										}catch(e){
											ret={success:0,msg:e.message}
										}
										if (ret.success==1){ //�����ɹ�
											window.location.href=ret.url
										}else{
											$.messager.alert('����ʧ��',ret.msg,'error');	
										}
											
									})
								}
							})
						}else{
							$.messager.popover({msg:'��ѡ��Ҫ�����Ĳ˵�',type:'alert'});	
						}
					}	
				},{
					text:'���',
					handler:function(){
						GV.exportList=[];
						$('#menu-export-list').datagrid('clearSelections').datagrid('loadData',GV.exportList);
					}	
				},{
					text:'�ر�',
					handler:function(){
						$('#menu-export-win').dialog('close');
					}	
				}]
			})
			$('#menu-export-list').datagrid({
				fit:true,
				fitColumns:true,
				bodyCls:'panel-header-gray',
				singleSelect:false,
				//pagination:true,
				rownumbers:true,
				pageSize:1000,
				pageList:[1000],
				columns:[[
					{field:'ck',checkbox:true},
					{field:'desc',title:'�˵�',width:300,formatter:function(val,row){
						return val+'['+row.code+']';
					}}
				]],
				idField:'id',
				url:"",
				data:[]
			})
		}
		$('#menu-export-win').dialog('open');
		var idx=$.hisui.indexOfArray(GV.exportList,'id',id);
		if (idx==-1){
			GV.exportList.push({id:id,code:name,desc:caption});
			$('#menu-export-list').datagrid('loadData',GV.exportList);
			idx=GV.exportList.length-1;
		}
		$('#menu-export-list').datagrid('selectRow',idx);
		
		
	}
	//��ʾ���봰��
	GV.showMenuImportWin=function(){
		if($('#menu-import-win').length==0){
			$('<div id="menu-import-win" style="padding:10px 10px 0 10px;"><table id="menu-import-list"></table><div>').appendTo('body');
			$('<div id="menu-import-list-tb" style="padding:5px 10px;"><input type="file" class="hisui-filebox" id="menu-import-list-tb-file" name="menu-import-list-tb-file" data-options="width:280,buttonText:\'\',buttonIcon:\'icon-folder\',plain:true" accept="text/xml" />'
				+'<span style="display:inline-block;width:15px;height:1px;"></span>'
				+'<a class="hisui-linkbutton" id="menu-import-list-tb-open">��</a>'
				+'<span style="display:inline-block;width:15px;height:1px;"></span>'
				+'<input type="checkbox" class="hisui-checkbox" label="���ǵ���" id="menu-import-list-tb-ov"/>'
				+'</div>').appendTo('#menu-import-win');
			$('#menu-import-win').dialog({
				title:'����˵�',iconCls:'icon-w-paper',width:500,height:600,modal:true,draggable:false,
				buttons:[{
					text:'����',
					handler:function(){
						var rows=$('#menu-import-list').datagrid('getSelections');
						if(rows && rows.length){
							var arr=[];
							$.each(rows,function(){arr.push(this.code);})
							$.m({
								ClassName:'web.Util.MenuService',MethodName:'AjaxImport'
								,MenuNames:arr.join('^')
								,overwrite:$('#menu-import-list-tb-ov').checkbox('getValue')?1:0
								,fileName:GV.menuImportFileName
								,HospId:GV.getSelectHospId()
							},function(ret){
								try{
									ret=$.parseJSON(ret);	
								}catch(e){
									ret={success:0,msg:e.message}
								}
								if (ret.success==1){ //�����ɹ�
									if (ret.data.length>0){
										var msg='<div style="max-height:300px;overflow-y:auto;">�ɹ�����'+ret.data.length+'����<br>';
										$.each(ret.data,function(){msg+=this.desc+'['+this.code+']<br>';})
										msg+='</div>'
										$.messager.alert('����ɹ�',msg,'success');
									}else{
										$.messager.alert('��ʾ','����0��','info');
									}

								}else{
									$.messager.alert('����ʧ��',ret.msg,'error');	
								}
								
							})
						}else{
							$.messager.popover({msg:'��ѡ��Ҫ�����Ĳ˵�',type:'alert'});	
						}
					}	
				},{
					text:'�ر�',
					handler:function(){
						$('#menu-import-win').dialog('close');
					}	
				}],
				onClose:function(){
					$('#menu-import-list-tb-file').filebox('clear');
					$('#menu-import-list-tb-ov').checkbox('setValue',false);
					$('#menu-import-list').datagrid('clearSelections').datagrid('loadData',[]);
					GV.menuImportFileName='';
					
					GV.menu_list.reload();
				}
			})
			$.parser.parse('#menu-import-list-tb');
			$('#menu-import-list-tb-file').filebox('options').onChange=function(newVal,oldVal){
				//console.log(newVal,oldVal)
			}
			$('#menu-import-list-tb-open').click(function(){
				var files=$('#menu-import-list-tb-file').filebox('files');
				if(files && files[0]) {
					var formData = new FormData();
					formData.append('FileStream', files[0]);
					formData.append('ClassName','web.Util.MenuService');
					formData.append('MethodName','AjaxParseMenuXml');
					$.ajax({
					    url: $URL,
					    type: 'POST',
					    cache: false,
					    dataType:'text',
					    data: formData,
					    processData: false,
					    contentType: false
					}).done(function(ret) {
						try{
							ret=$.parseJSON(ret);	
						}catch(e){
							ret={success:0,msg:e.message}
						}
						if (ret.success==1){ //�ϴ��ɹ�
							//console.log(ret);
							$('#menu-import-list').datagrid('clearSelections').datagrid('loadData',ret.data);
							GV.menuImportFileName=ret.fileName; //�浽��̨���ļ���
						}else{
							$.messager.alert('�ļ��ϴ�ʧ��',ret.msg,'error');	
						}
					}).fail(function(res) {
						//console.log(res);
						$.messager.popover({msg:'�ļ��ϴ�ʧ��',type:'error'});
					});
				}else{
					$.messager.popover({msg:'��ѡ���ļ�',type:'alert'});	
				}

			})
			$('#menu-import-list').datagrid({
				fit:true,
				fitColumns:true,
				bodyCls:'panel-header-gray',
				singleSelect:false,
				//pagination:true,
				rownumbers:true,
				pageSize:1000,
				pageList:[1000],
				columns:[[
					{field:'ck',checkbox:true},
					{field:'desc',title:'�˵�',width:300,formatter:function(val,row){
						return val+'['+row.code+']';
					}},
					{field:'exists',title:'����',width:50,align:'center',fixed:true,formatter:function(val,row){
						return val==1?'��':'��';
					}}
				]],
				idField:'code',
				url:"",
				data:[],
				toolbar:'#menu-import-list-tb'
			})
			
		}
		$('#menu-import-win').dialog('open');
	}
	
	
} // end initMenuExport




//====����ȫ��ά��============================================================================
var initTabGroup=function(){
	$('#group-layout').layout('panel','center').panel('options').onResize=function(w,h){
		$('#group-menu-tree-container').height(h-77-10);
	}
	$('#group-layout').layout('panel','west').panel('options').onResize=function(w,h){
		$('#group-search').searchbox('resize',w-15);
	};
	//$('#group-menu-tree-container').height(GV.maxHeight-110);
	$('#group-search').searchbox({
		width:285,//200,
		searcher:function(value){
				$('#group-list').datagrid('clearSelections').datagrid('load',{ClassName:'BSP.GRPHOSP.SRV.SSGroup',QueryName:'LookUpGroup',desc:value
					,HospId:GV.getSelectHospId() //add ��ǰѡ��Ժ�� 2020-06-13
				});
				loadtree('');
		}
	})
	GV.group_list=$HUI.datagrid('#group-list',{
		//width:295,
		//height:GV.maxHeight-80,
		fit:true,
		border:false,
		url:'websys.Broker.cls',
		queryParams:{ClassName:'BSP.GRPHOSP.SRV.SSGroup',QueryName:'LookUpGroup'
			,HospId:GV.getSelectHospId() //add ��ǰѡ��Ժ�� 2020-06-13
		},
		columns:[[
			{field:'ck',checkbox:true},  
			{field:"Description",width:'220',title:'��ȫ��'},
			{filed:'HIDDEN',hidden:true}
		]],
		idField:'HIDDEN',
		pagination:true,
		pageSize:30,
		singleSelect:true,
		mode:'remote',
		toolbar:'#group-list-tb',
		displayMsg:'',
		onClickRow:function(index,row){
			//����onSelect
		},onSelect:function(index,row){
			loadtree(row.HIDDEN);
		}
	});
	var loadtree=debounce(function(id){
		//var type=$('#group-menu-tree-tools-type').switchbox('getValue')?"H":"SG";    //Hͷ�˵�  ��˵�SG �Ӳ�˵������ �������1����S 
		var selectedTab=$('#group-menu-tree-tools-type').keywords('getSelected');
		var type=selectedTab[0].id.split('-')[1];
		var auth=$('#group-menu-tree-tools-auth').checkbox('getValue')?"1":"0";
		GV.group_menu_tree.options().url='websys.Broker.cls?ClassName=websys.Menu&MethodName=TreeJson&GroupId='+id+'&id=0&type='+type+'&Authorize='+auth
										+'&HospId='+GV.getSelectHospId() //add ��ǰѡ��Ժ�� 2020-06-13 ;
		GV.group_menu_tree.reload();
	},500)
	GV.group_menu_tree=$HUI.tree('#group-menu-tree',{
		//url:'jquery.easyui.broker.csp?ClassName=websys.Menu&MethodName=TreeJson&GroupId='+groupid+'&id='+sideMenuId,      
		animate:true,
		//dnd:enableEdit,
		//lines:true,
		onContextMenu: function(e,node){
			e.preventDefault();
			//��ֹ������Ĳ˵���
			$(this).tree('select',node.target);
			if($(this).tree('isLeaf',node.target)){
				$('#group-menu-tree-mm').menu('disableItem',$('#appendTNode')[0]);
			}else{
				$('#group-menu-tree-mm').menu('enableItem',$('#appendTNode')[0]);
			}
			if(	$(this).tree('getParent' ,node.target) ){
				$('#group-menu-tree-mm').menu('enableItem',$('#insertTNode')[0]);
			}else{
				$('#group-menu-tree-mm').menu('disableItem',$('#insertTNode')[0]);
			}
			if(node.attributes.Authorize==1){
				$('#group-menu-tree-mm').menu('setText', {
					target: $('#toggleAuth')[0],
					text: 'ȡ����Ȩ'
				});
			}else{
				$('#group-menu-tree-mm').menu('setText', {
					target: $('#toggleAuth')[0],
					text: '��Ȩ'
				});
			}
			$('#group-menu-tree-mm').menu('show', {
				left: e.pageX,
				top: e.pageY
			});
		},
		onDblClick:function(node){
			GV.showMenuEditWin(node.id,"tree");
		},
		formatter:function(node){
			if(node.attributes.Authorize==1){
				return node.text+' ['+node.attributes.Name+']';
			}else{
				return '<span style="color:gray;">'+node.text+' ['+node.attributes.Name+']'+'</span>';
			}
		},
		onLoadSuccess:function(node,data){
			if(node===null && data.length==1){
				var root=GV.group_menu_tree.getRoot();
				if(root) GV.group_menu_tree.expand(root.target);
				
				$('#group-menu-tree-tools-append,#group-menu-tree-tools-insert,#group-menu-tree-tools-toggleAuth,#group-menu-tree-tools-edit').linkbutton('disable');
			}
		},onSelect:function(node){
			//���� ����������ť�Ľ��� ����״̬
			if($(this).tree('isLeaf',node.target)){ //Ҷ�ӽڵ� ���ܲ����ӽڵ�
				$('#group-menu-tree-tools-append').linkbutton('disable');
			}else{
				$('#group-menu-tree-tools-append').linkbutton('enable');
			}
			
			if(	$(this).tree('getParent' ,node.target) ){  
				$('#group-menu-tree-tools-insert').linkbutton('enable');
			}else{  //û�и��ڵ� ����ͬ������
				$('#group-menu-tree-tools-insert').linkbutton('disable');
			}
			
			if(node.attributes.Authorize==1){
				$('#group-menu-tree-tools-toggleAuth').find('.l-btn-text').text("ȡ����Ȩ");
			}else{
				$('#group-menu-tree-tools-toggleAuth').find('.l-btn-text').text("��Ȩ");
			}
			$('#group-menu-tree-tools-toggleAuth').linkbutton('enable');
			if(node.id>=50000){
				$('#group-menu-tree-tools-edit').linkbutton('enable');
			}else{
				$('#group-menu-tree-tools-edit').linkbutton('disable');
			}
			
			
			
		}
	})
	$('#group-menu-tree-mm').contextmenu(function(e){
		e.preventDefault();
	})
	
	//�����Ӳ˵�
	GV.appendTNode=function(){
		var t=GV.group_menu_tree.getSelected();
		var row=GV.group_list.getSelected();
		var AuthGroup=[{
			id:row.HIDDEN,
			desc:row.Description
		}];
		//GlobalPNode=t;
		GV.fillMenuEditWin({ID:"",SubMenuOf:t.attributes.Name,SubMenuOfText:t.attributes.Name,AuthGroup:AuthGroup},'nomore');
		GV.editFrom='tree',GV.editPNode=t;   //���¼�¼ �Ǵ�tree������ ���ڵ�ΪGV.editPNode
		GV.showMenuEidtGuide()
		//$('#edit-win').dialog('setTitle','����').dialog('open2');
		//$('#MenuItemEdit').attr('src','websys.default.csp?WEBSYS.TCOMPONENT=websys.Menu.Edit&ParentID='+t.id+'&DefaultAccessGroup='+groupid);	
	}
	//ͬ������
	GV.insertTNode=function(){
		var row=GV.group_list.getSelected();
		var AuthGroup=[{
			id:row.HIDDEN,
			desc:row.Description
		}];
		var t=GV.group_menu_tree.getSelected();
		var pnode=GV.group_menu_tree.getParent(t.target);    //$('#tt').tree('getParent' ,t.target);
		if(pnode&&pnode.id){
			//GlobalPNode=pnode;
			GV.fillMenuEditWin({ID:"",SubMenuOf:pnode.attributes.Name,SubMenuOfText:pnode.attributes.Name,AuthGroup:AuthGroup},'nomore');
			GV.editFrom='tree',GV.editPNode=pnode;   //���¼�¼ �Ǵ�tree������ ���ڵ�ΪGV.editPNode
			GV.showMenuEidtGuide()
			//$('#edit-win').dialog('setTitle','����').dialog('open2');
		}

	}
	GV.toggleAuth=function(){
		var t=GV.group_menu_tree.getSelected();
		var row=GV.group_list.getSelected();
		var data={ClassName:'epr.GroupSettings',MethodName:'SaveGroupMenuSecurity',groupid:row.HIDDEN};
		if(t.attributes.Authorize==1){
			data['menuid0']=t.id;
		}else{
			data['menuid1']=t.id;
		}
		//console.log(data);
		$.m(data,function(rtn){
			if (rtn>0){
				if(t.attributes.Authorize==1){
					t.attributes.Authorize=0;
					//$(t.target).find('.tree-title').html('<span style="color:gray;">'+t.text+'</span>');
					GV.group_menu_tree.update(t);
					$('#group-menu-tree-tools-toggleAuth').find('.l-btn-text').text("��Ȩ");
					
					
				}else{
					t.attributes.Authorize=1;
					//$(t.target).find('.tree-title').html(t.text);
					GV.group_menu_tree.update(t);
					$('#group-menu-tree-tools-toggleAuth').find('.l-btn-text').text("ȡ����Ȩ");
				}
			}
		});
	}
	GV.editTNode=function(){
		var t=GV.group_menu_tree.getSelected();

		GV.showMenuEditWin(t.id,"tree");
	}
	$('#group-menu-tree-tools-type').keywords({
	    singleSelect:true,
	    items:[
	        {text:'ͷ�˵�',id:'tab-H',selected:true},
	        {text:'��˵�',id:'tab-S'}
	    ],
	    onClick:function(v){
		    //console.log(v)
		    var type=v.id.split("tab-")[1];
		    var lasttype=$('#group-menu-tree-tools-type').data('menutype')||"H";
		    if(type!=lasttype){
			    var row=GV.group_list.getSelected();
				loadtree(row.HIDDEN);
				$('#group-menu-tree-tools-type').data('menutype',type);
			}
		},
	})
	/*
	$('#group-menu-tree-tools-type').switchbox({
		onText:'ͷ�˵�',
		offText:'��˵�',
		onClass:'info',
		offClass:'success',
		onSwitchChange:function(e,value){
			var row=GV.group_list.getSelected();
			loadtree(row.HIDDEN);
		},
		size:'small'
	})*/
	$('#group-menu-tree-tools-auth').checkbox({
		onCheckChange:function(e,value){
			var row=GV.group_list.getSelected();
			loadtree(row.HIDDEN);
		}
	})
	
	$('#group-menu-tree-tools-append').linkbutton({
		iconCls:'icon-add',
		plain:true,
		onClick:function(){
			GV.appendTNode();
		},
		disabled:true
	})
	$('#group-menu-tree-tools-insert').linkbutton({
		iconCls:'icon-add',
		plain:true,
		onClick:function(){
			GV.insertTNode();
		},
		disabled:true	
	})
	$('#group-menu-tree-tools-toggleAuth').linkbutton({
		iconCls:'icon-add',
		plain:true,
		onClick:function(){
			GV.toggleAuth();
		},
		disabled:true	
	})
	$('#group-menu-tree-tools-edit').linkbutton({
		iconCls:'icon-edit',
		plain:true,
		onClick:function(){
			var t=GV.group_menu_tree.getSelected();
			if (t && t.id){
				GV.showMenuEditWin(t.id,"tree");
			}
		},
		disabled:true		
	})
	
	
} ;//initTabGroup  end=========================================

//�˵���Ȩ=========================================================================
//====����ȫ��ά��============================================================================
var initTabSecurity=function(){
	$('#security-layout').layout('panel','west').panel('options').onResize=function(w,h){
		$('#security-group-search').searchbox('resize',w-15);
	};
	$('#security-group-search').searchbox({
		width:285,
		searcher:function(value){
			$('#security-group-list').datagrid('clearSelections').datagrid('load',{ClassName:'BSP.GRPHOSP.SRV.SSGroup',QueryName:'LookUpGroup',desc:value
				,HospId:GV.getSelectHospId() //add ��ǰѡ��Ժ�� 2020-06-13
			});
			loadsecurity('');
		}
	})
	GV.security_group_list=$HUI.datagrid('#security-group-list',{
		//width:295,
		//height:GV.maxHeight-80,
		fit:true,
		border:false,
		url:'websys.Broker.cls',
		queryParams:{ClassName:'BSP.GRPHOSP.SRV.SSGroup',QueryName:'LookUpGroup'
			,HospId:GV.getSelectHospId() //add ��ǰѡ��Ժ�� 2020-06-13
		},
		columns:[[
			{field:'ck',checkbox:true},  
			{field:"Description",width:'220',title:'��ȫ��'},
			{filed:'HIDDEN',hidden:true}
		]],
		idField:'HIDDEN',
		pagination:true,
		pageSize:30,
		singleSelect:true,
		mode:'remote',
		toolbar:'#security-group-list-tb',
		displayMsg:'',
		onClickRow:function(index,row){
			//����onSelect
		},onSelect:function(index,row){
			loadsecurity(row.HIDDEN);
		}
	});
	var loadsecurity=debounce(function(groupid){
		if (!groupid) {$('#security-iframe').attr('src','about:blank');return;}
		$('#security-iframe').attr('src','websys.menu.security.csp?GroupDR='+groupid
								+'&HospId='+GV.getSelectHospId() //add ��ǰѡ��Ժ�� 2020-06-13
								);
		/*$.messager.show({
			title:'��ȫ��',
			msg:groupid+''+ GV.security_group_list.getSelected().Description
		});*/
	},500);
};// end  initTabSecurity===================================================


$(init)
