var PageLogicObj = {
    m_PreGroupData: "",
    m_AuthInit: 0,
    m_AuthFlag: tkMakeServerCall("DHCDoc.Interface.Inside.InvokeAuth", "GetSwitch"), //权力系统启用
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
        prompt:'请输入项目别名...',
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
			{field:'text',title:'安全组',width:200},
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
			text:'增加',
			iconCls:'icon-add',
			handler:AddOrdListMenu
		},{
			text:'编辑',
			iconCls:'icon-edit',
			handler:EditOrdListMenu
		}],
		columns:[[
			{field:'ID',hidden:true},
			{field:'EMParentCode',hidden:true},
			{field:'EMCode',title:'代码',width:100,editor:{type:'text'}},
			{field:'EMText',title:'权限描述',width:100,editor:{type:'text'}},
			{field:'EMHandler',title:'处理函数',width:100,editor:{type:'text'}},
			{field:'EMDisplayHandler',title:'显示函数',width:100,editor:{type:'text'}},
			{field:'CheckFlag',title:'是否显示',width:80,
				editor:{
					type: 'icheckbox',
                    options:{
                        on:'1',
                        off:'0'
                    }
				},
				formatter:function(value,row,index){
					return value==1?'是':'否';
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
		$.messager.popover({msg:'请先选择菜单类型',type:'alert'});
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
		$.messager.popover({msg:'请先选中需要修改的选项',type:'alert'});
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
		$.messager.popover({msg:'请先选中需要授权的安全组',type:'alert'});
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
		$.messager.popover({msg:"保存成功",type:'success'});
	}else{
		$.messager.alert('提示','保存失败:'+ret);
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
		content:"<ul class='tip_class'><li style='font-weight:bold'>医嘱补录说明</li>" + 
		"<li style='color:#008FF0;'>一、添加医嘱控制</li>" + 
		"<li>1、不允许重复录入的子类、相同通用名的医嘱</li>" +
		"<li>2、如果是有一天最大量设置的医嘱门诊患者同一次就诊不能出现两条、急诊或住院患者同一天不能出现两条</li>" +
		"<li>3、存在相同的医嘱?确认是否要增加</li>" + 
		"<li>4、非药品的重复医嘱提示；重复检验标本提示；重复当日已开医嘱(门诊)</li>" +
		"<li>5、住院急诊流观押金控制</li>"+
		"<li>6、医嘱项提示强制不弹出窗口，走医嘱录入界面上方《提示消息》</li>"+ 
		"<li style='color:#008FF0;'>二、医保限制用药</li>" + 
		"<li>1、受病种诊断限制用药，只能开自费；</li>" + 
		"<li>2、已经开过相同的医嘱且在疗程内,不允许再开；</li>"+
		"<li>3、特病项目,请在特病处方内开医嘱；医保适应症提示及控制</li>" +
		"<li style='color:#008FF0;'>三、点击审核按钮的控制</li>" + 
		"<li>1、临床路径检查、押金不足</li>"
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
	if(title=='诊疗页面设置'){
		InitCustomSetting(GroupID);
		$panel.hideMask();
	}else if(title=='代码模块授权'){
		LoadCTDefineConfig(GroupID);
		$panel.hideMask();
	}else{
		if(title=='门诊医生站'){
			$("#NewDocGotoWhere").datagrid("reload");
		}else if(title=='住院医生站'){
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
		$.messager.popover({msg: '请先选择需要授权的安全组',type:'alert'});
		return false;
	}
	var GroupID=selected.id;
	var tab=$('#tabCat').tabs('getSelected');
	if(!tab) return false;
	var $panel=tab.panel('body');
	var data=$panel.getFormData();
	var title=tab.panel('options').title;
	if(title=='住院医生站'){
		data.tabOrdListMenu=$("#tabOrdListMenu").datagrid('getEditRows');
	}
	if(title=='门诊医生站'){
		data.NewDocGotoWhere=$("#NewDocGotoWhere").datagrid('getEditRows');
	}
    var AuthObj={};
    if (PageLogicObj.m_AuthFlag == 1) {
        //以后考虑改写为通过对象属性获取需配置点
        if (title == '医嘱录入设置') {
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
        $.messager.popover({ msg: '保存成功!', type: 'success' });
        if (title == '住院医生站') {
            $("#tabOrdListMenu").datagrid('reload');
        }
        if (title == '门诊医生站') {
            $("#NewDocGotoWhere").datagrid('reload');
        }
    } else {
        $.messager.alert('提示', '保存失败:' + ret);
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
        $.messager.alert("提示", Arr[1], "info", function() {
            LoadAuthHtml();
        });
    }
    //应该刷新一下界面数据，避免权力系统数据不对
    SetTabData();
}
/// 初始化诊疗默认跳转页签表格
function InitNewDocGotoWhere(){
	$("#NewDocGotoWhere").datagrid({
		idField:'SeqNo',
		width:800,
		height:300,
		fit : false,
		columns:[[
			{field:'SeqNo',hidden:true},
			{field:'CatID',hidden:true,title:'工作流分类ID'},
			{field:'CatDesc',hidden:false,title:'工作流分类',width:100},
			{field:'LocID',hidden:true,title:'科室ID'},
			{field:'Desc',hidden:false,title:'授权科室',width:100},
			{field:'NewDocGotoWhere',hidden:true,title:'项目ID'},
			{field:'NewDocGotoWhereName',hidden:false,title:'默认跳转工作流项目',width:100,valueField:'NewDocGotoWhere',
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
