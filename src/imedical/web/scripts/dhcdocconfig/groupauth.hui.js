var PageLogicObj = {
    m_PreGroupData: "",
    m_AuthInit: 0,
    m_AuthFlag: tkMakeServerCall("DHCDoc.Interface.Inside.InvokeAuth", "GetSwitch"), //Ȩ��ϵͳ����
};
$(function(){
    $.extend(GenHospComp("SS_Group").jdata.options,{
        onSelect:function(index,row){
			$('#SearchGroup').searchbox('setValue','');
            $('#tabGroupList').datagrid('load');
        },
        onLoadSuccess:function(data){
			InitTabs();
            InitSearchBox();
            InitGroupGrid();
			InitOrdListMenuType();
			InitNewDocGotoWhere();
			InitCTDefineTree();
			InitShowTabs();
            InitTip();
            InitEvent();
            LoadAuthHtml();
        }
    });
});
function InitEvent(){
	$('#AuthSave').click(SaveCTDefineConfig);
}
function InitTabs(){
	$('#tabCat').tabs({
		onSelect:function(title,index){
			SetTabData();
		}
	});
}
function InitSearchBox()
{
	var SearchTimer=null;
    $('#SearchGroup').searchbox({
        prompt:'��������Ŀ����...',
    }).searchbox('textbox').keyup(function(e){
		clearTimeout(SearchTimer);
		SearchTimer=setTimeout(function(){
			var desc=$(e.target).val().toUpperCase();
			var GroupData=$('#tabGroupList').datagrid('getRows');
			var trObj=$('#tabGroupList').datagrid('getPanel').find('.datagrid-view2').find('table.datagrid-btable').find('tr');
			var maxIndex=-1;
			for(var i=0;i<GroupData.length;i++){
				if((GroupData[i].alias.toUpperCase().indexOf(desc)==-1)&&(GroupData[i].text.toUpperCase().indexOf(desc)==-1)){
					trObj.eq(i).hide();
				}else{
					trObj.eq(i).show();
					maxIndex++;
				}
			}
			$('#tabGroupList').datagrid('getPanel').find('.datagrid-view1').find('table.datagrid-btable').find('tr').each(function(index){
				if(index<=maxIndex) $(this).show();
				else  $(this).hide();
			});
		},300);
	});
}
function InitGroupGrid(){
	$("#tabGroupList").datagrid({
		queryParams:{ClassName : "DHCDoc.DHCDocConfig.Group",QueryName : "QueryGroup"},
		columns :[[
			{field:'text',title:'��ȫ��',width:200},
			{field:'id',hidden:true}
		]],
		onBeforeLoad:function(param){
			param.HospID=$('#_HospList').getValue();
		},
		onSelect:function(index, row) {
			SetTabData();
		}
	});
}
function InitOrdListMenuType(){
	$('#OrdListMenuType').combobox({
		editable:false,
		valueField:'EMCode',
		textField:'EMText',
		onBeforeLoad:function(param){
			param.ClassName='DHCDoc.DHCDocConfig.Group';
			param.QueryName='QueryOrdRightMenu';
			param.ParNode='';
			param.GroupID='';
		},
		onSelect:function(rec){
			if(rec){
				$("#tabOrdListMenu").datagrid('reload');
			}
		}
	});
}
function InitOrdListMenu(GroupID){
	$("#tabOrdListMenu").datagrid({
		idField:'ID',
		toolbar:[{
			text:'����',
			iconCls:'icon-add',
			handler:AddOrdListMenu
		},{
			text:'�༭',
			iconCls:'icon-edit',
			handler:EditOrdListMenu
		}],
		columns:[[
			{field:'ID',hidden:true},
			{field:'EMParentCode',hidden:true},
			{field:'EMCode',title:'����',width:100,editor:{type:'text'}},
			{field:'EMText',title:'Ȩ������',width:100,editor:{type:'text'}},
			{field:'EMHandler',title:'������',width:100,editor:{type:'text'}},
			{field:'EMDisplayHandler',title:'��ʾ����',width:100,editor:{type:'text'}},
			{field:'CheckFlag',title:'�Ƿ���ʾ',width:80,
				editor:{
					type: 'icheckbox',
                    options:{
                        on:'1',
                        off:'0'
                    }
				},
				formatter:function(value,row,index){
					return value==1?'��':'��';
				},
				styler: function(value,row,index){
                    return value==1?'color:#21ba45;':'color:#f16e57;';
                }
			}
		]],
		onDblClickRow:function(index,row){
			$(this).datagrid('beginEdit',index);
		},
		onBeginEdit:function(index,row){
			$(this).treegrid('scrollTo',index);
			var ed=$(this).treegrid('getEditor',{index:index,field:'EMCode'});
			if(ed) $(ed.target).select();
		},
		onBeforeLoad:function(param){
			var parentNode=$('#OrdListMenuType').getValue();
			if(!parentNode){
				$(this).setValue([]);
				return false;
			}
			param.ClassName='DHCDoc.DHCDocConfig.Group';
			param.QueryName='QueryOrdRightMenu';
			param.ParNode=parentNode;
			param.GroupID=GroupID;
		}
	});
}
function AddOrdListMenu(){
	var parentNode=$('#OrdListMenuType').getValue();
	if(!parentNode){
		$.messager.popover({msg:'����ѡ��˵�����',type:'alert'});
		return false;
	}
	$('#tabOrdListMenu').datagrid('appendRow',{EMParentCode:parentNode,ID:''});
	var rows=$('#tabOrdListMenu').datagrid('getRows');
	var index=rows.length-1;
	$('#tabOrdListMenu').datagrid('beginEdit',index);
}
function EditOrdListMenu(){
	var selected=$("#tabOrdListMenu").datagrid('getSelected');
	if(!selected){
		$.messager.popover({msg:'����ѡ����Ҫ�޸ĵ�ѡ��',type:'alert'});
		return;
	}
	var index=$("#tabOrdListMenu").datagrid('getRowIndex',selected);
	$('#tabOrdListMenu').datagrid('beginEdit',index);
}
function InitCTDefineTree()
{
    $('#tCTDefine').tree({
        url:'websys.Broker.cls?ClassName=DHCDoc.DHCDocConfig.CodeTable&MethodName=GetCTDefineJSON',
    	animate:true,	
		checkbox:true,
    	cascadeCheck:false,		
    	lines:true,
		dnd:true,
		onClick:function(node){
			if(node.checked){
				$('#tCTDefine').tree('uncheck',node.target);
			}else{
				$('#tCTDefine').tree('check',node.target);
			}
		}
    });
}
function LoadCTDefineConfig(GroupID)
{
	var AuthData=$.cm({
		ClassName:'DHCDoc.DHCDocConfig.CodeTable',
		MethodName:'GetGroupAuth',
		GroupID:GroupID,
		HospID:$('#_HospList').getValue()
	},false);
	TraversalData($('#tCTDefine').tree('getRoots'));
	function TraversalData(TreeData){
		for(var i=0;i<TreeData.length;i++){
			var id=TreeData[i].id;
			var node=$('#tCTDefine').tree('find',id);
			if(AuthData.indexOf(id)>-1){
				$('#tCTDefine').tree('check',node.target);
			}else{
				$('#tCTDefine').tree('uncheck',node.target);
			}
			if(TreeData[i].children){
				TraversalData(TreeData[i].children);
			}
		}
	}
}
function SaveCTDefineConfig()
{
	var selected=$("#tabGroupList").datagrid('getSelected');
	if(!selected){
		$.messager.popover({msg:'����ѡ����Ҫ��Ȩ�İ�ȫ��',type:'alert'});
		return;
	}
	var GroupID=selected.id;
	var SaveArr=new Array();
	var nodes = $('#tCTDefine').tree('getChecked');
	for(var i=0;i<nodes.length;i++){
		SaveArr.push(nodes[i].id);
	}
	var ret=$.cm({
		ClassName:'DHCDoc.DHCDocConfig.CodeTable',
		MethodName:'SaveGroupAuth',
		dataType:'text',
		GroupID:GroupID,
		AuthData:JSON.stringify(SaveArr),
		HospID:$('#_HospList').getValue()
	},false);
	if(ret=='0'){
		$.messager.popover({msg:"����ɹ�",type:'success'});
	}else{
		$.messager.alert('��ʾ','����ʧ��:'+ret);
	}
}
function InitShowTabs()
{
	if(ServerObj.ShowTabs.length){
		var selIndex="";
		var tabs=$('#tabCat').tabs('tabs');
		for(var i=0;i<tabs.length;i++){
			var title=tabs[i].panel('options').title;
			if(ServerObj.ShowTabs.indexOf(title)==-1){
				$('#tabCat').tabs('disableTab',i);
			}else{
				if(selIndex=="") selIndex=i;
			}
		}
		if(selIndex!="") $('#tabCat').tabs('select',selIndex);
	}
}
function InitTip()
{
	$('#SupplementMode').next().after($('<a></a>').linkbutton({
        plain:true,
        iconCls:'icon-help'
    }).tooltip({
		content:"<ul class='tip_class'><li style='font-weight:bold'>ҽ����¼˵��</li>" + 
		"<li style='color:#008FF0;'>һ�����ҽ������</li>" + 
		"<li>1���������ظ�¼������ࡢ��ͬͨ������ҽ��</li>" +
		"<li>2���������һ����������õ�ҽ�����ﻼ��ͬһ�ξ��ﲻ�ܳ��������������סԺ����ͬһ�첻�ܳ�������</li>" +
		"<li>3��������ͬ��ҽ��?ȷ���Ƿ�Ҫ����</li>" + 
		"<li>4����ҩƷ���ظ�ҽ����ʾ���ظ�����걾��ʾ���ظ������ѿ�ҽ��(����)</li>" +
		"<li>5��סԺ��������Ѻ�����</li>"+
		"<li>6��ҽ������ʾǿ�Ʋ��������ڣ���ҽ��¼������Ϸ�����ʾ��Ϣ��</li>"+ 
		"<li style='color:#008FF0;'>����ҽ��������ҩ</li>" + 
		"<li>1���ܲ������������ҩ��ֻ�ܿ��Էѣ�</li>" + 
		"<li>2���Ѿ�������ͬ��ҽ�������Ƴ���,�������ٿ���</li>"+
		"<li>3���ز���Ŀ,�����ز������ڿ�ҽ����ҽ����Ӧ֢��ʾ������</li>" +
		"<li style='color:#008FF0;'>���������˰�ť�Ŀ���</li>" + 
		"<li>1���ٴ�·����顢Ѻ����</li>"
	}));
}
function InitCustomSetting(GroupID){
	var HospID=$('#_HospList').getValue();
	var lnk = "dhcdoc.custom.setting.csp?GroupRowId=" + GroupID+"&HospID="+HospID;
	$("#fTreatSet").attr("src",lnk);
}
function SetTabData(){
	var selected=$("#tabGroupList").datagrid('getSelected');
	if(!selected) return false;
	var GroupID=selected.id;
	var tab=$('#tabCat').tabs('getSelected');
	if(!tab) return false;
	var $panel=tab.panel('body');
	$panel.showMask();
	var title=tab.panel('options').title;
	if(title=='����ҳ������'){
		InitCustomSetting(GroupID);
		$panel.hideMask();
	}else if(title=='����ģ����Ȩ'){
		LoadCTDefineConfig(GroupID);
		$panel.hideMask();
	}else{
		if(title=='����ҽ��վ'){
			$("#NewDocGotoWhere").datagrid("reload");
		}else if(title=='סԺҽ��վ'){
			InitOrdListMenu(GroupID);
		}
		var keys=$panel.getFormKeys();
		if(keys.length){
			$.cm({
				ClassName:'DHCDoc.DHCDocConfig.Group',
				MethodName:'GetMulDocConfig1',
				NodeStr:JSON.stringify(keys), 
				SubNode:GroupID, 
				HospID:$('#_HospList').getValue()
			},function(data){
				$panel.setFormData(data);
				$panel.hideMask();
                PageLogicObj.m_PreGroupData = data;
			});
		}else{
			$panel.hideMask();
		}
	}
}
function SaveTabData(){
	var selected=$("#tabGroupList").datagrid('getSelected');
	if(!selected){
		$.messager.popover({msg: '����ѡ����Ҫ��Ȩ�İ�ȫ��',type:'alert'});
		return false;
	}
	var GroupID=selected.id;
	var tab=$('#tabCat').tabs('getSelected');
	if(!tab) return false;
	var $panel=tab.panel('body');
	var data=$panel.getFormData();
	var title=tab.panel('options').title;
	if(title=='סԺҽ��վ'){
		data.tabOrdListMenu=$("#tabOrdListMenu").datagrid('getEditRows');
	}
	if(title=='����ҽ��վ'){
		data.NewDocGotoWhere=$("#NewDocGotoWhere").datagrid('getEditRows');
	}
    var AuthObj={};
    if (PageLogicObj.m_AuthFlag == 1) {
        //�Ժ��Ǹ�дΪͨ���������Ի�ȡ�����õ�
        if (title == 'ҽ��¼������') {
            AuthObj.NoAdmValidDaysLimit = data.NoAdmValidDaysLimit;
            data.NoAdmValidDaysLimit = PageLogicObj.m_PreGroupData.NoAdmValidDaysLimit;
        }
    }
    var ret = $.cm({
        ClassName: 'DHCDoc.DHCDocConfig.Group',
        MethodName: 'SaveMulDocConfig1',
        InputStr: JSON.stringify(data),
        GroupID: GroupID,
        HospID: $('#_HospList').getValue(),
        dataType: 'text'
    }, false);
    if (ret == '0') {
        $.messager.popover({ msg: '����ɹ�!', type: 'success' });
        if (title == 'סԺҽ��վ') {
            $("#tabOrdListMenu").datagrid('reload');
        }
        if (title == '����ҽ��վ') {
            $("#NewDocGotoWhere").datagrid('reload');
        }
    } else {
        $.messager.alert('��ʾ', '����ʧ��:' + ret);
        return false;
    }
    var AuthStr = JSON.stringify(AuthObj);
    if (AuthStr != "{}") {
        var Rtn = $.cm({
            ClassName: 'DHCDoc.Interface.Inside.InvokeAuth',
            MethodName: 'InvokeDocGroupAuth',
            InputStr: AuthStr,
            GroupID: GroupID,
            HospID: $('#_HospList').getValue(),
            ExptStr: session["LOGON.USERID"] + "^" + title,
            dataType: 'text'
        }, false);
        var Arr = Rtn.split("^");
        $.messager.alert("��ʾ", Arr[1], "info", function() {
            LoadAuthHtml();
        });
    }
    //Ӧ��ˢ��һ�½������ݣ�����Ȩ��ϵͳ���ݲ���
    SetTabData();
}
/// ��ʼ������Ĭ����תҳǩ���
function InitNewDocGotoWhere(){
	$("#NewDocGotoWhere").datagrid({
		idField:'SeqNo',
		width:800,
		height:300,
		fit : false,
		columns:[[
			{field:'SeqNo',hidden:true},
			{field:'CatID',hidden:true,title:'����������ID'},
			{field:'CatDesc',hidden:false,title:'����������',width:100},
			{field:'LocID',hidden:true,title:'����ID'},
			{field:'Desc',hidden:false,title:'��Ȩ����',width:100},
			{field:'NewDocGotoWhere',hidden:true,title:'��ĿID'},
			{field:'NewDocGotoWhereName',hidden:false,title:'Ĭ����ת��������Ŀ',width:100,valueField:'NewDocGotoWhere',
				editor:{
					type:'combobox',  
					options:{
						valueField:'ID',
						textField:'Name',
						onBeforeLoad:function(param){
							param.ClassName='DHCDoc.OPDoc.Workflow';
							param.QueryName='QueryCatItem';
							var EditRow=GetDGEditRowIndex(this);
							param.CatID=$("#NewDocGotoWhere").datagrid("getRows")[EditRow].CatID;
						},
						loadFilter:function(data){
							for(var i=data.length-1;i>=0;i--){
								if((data[i].Active!=true)&&(data[i].Active!=1)){
									data.splice(i,1);
								}
							}
							return data;
						},
						onLoadSuccess:function(){
							var EditRow=GetDGEditRowIndex(this);
							var NewDocGotoWhere=$("#NewDocGotoWhere").datagrid("getRows")[EditRow].NewDocGotoWhere;
							$(this).combobox('setValue',NewDocGotoWhere);
						}
					}
				}
			}
		]],
		onDblClickRow:function(index,row){
			$(this).datagrid('beginEdit',index);
		},
		onBeforeLoad:function(param){
			var selected=$("#tabGroupList").datagrid('getSelected');
			if(!selected){
				$(this).datagrid('loadData',[]);
				return false;
			}
			param.ClassName='DHCDoc.OPDoc.Workflow';
			param.QueryName='QueryCatListForGroup';
			param.HospID=$('#_HospList').getValue();
			param.GroupID=selected.id;
		}
	});
}

function LoadAuthHtml() {
    if ((PageLogicObj.m_AuthFlag != 1) || (PageLogicObj.m_AuthInit == 1)) return;
    $m({
        ClassName: "BSP.SYS.SRV.AuthItemApply",
        MethodName: "GetStatusHtml",
        AuthCode: "HIS-DOC-GROUPAUTH"
    }, function(rtn) {
        if (rtn != "") {
            PageLogicObj.m_AuthInit = 1;
            $(rtn).insertAfter("[for='NoAdmValidDaysLimit']");
        }
    })
}
