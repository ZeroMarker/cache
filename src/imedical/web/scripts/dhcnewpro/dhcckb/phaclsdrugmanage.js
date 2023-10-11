var nodeId = "";
var type = "";
var parentId = "";
var grandPatId = "";
var grandGrandPatId = "";
/// ҳ���ʼ������
function initPageDefault()
{
	initPhaCatTree();
	initDrugList();
	initButton();
}

function initPhaCatTree()
{
	$('#itemCat').tree({
    	url:$URL+"?ClassName=web.DHCCKBPhaClsDrugManage&MethodName=QueryClsLinkDrugsTree&id="+catId +(("undefined"!==typeof websys_getMWToken)?"&MWToken="+websys_getMWToken():""),
    	lines:true,
		animate:true,
		dnd:true,
		checkbox:true,
		onContextMenu: function(e, node){			
			
		},
		onClick:function(node, checked){
			nodeId = node.id;
			type = node.type;
			parentId = "";
			grandPatId = "";
			grandGrandPatId = "";
			if(type == "GenerNameFormProp"){
				var parent = $('#itemCat').tree('getParent', node.target);
				parentId = parent.id;
				var grandPat = $('#itemCat').tree('getParent', parent.target);
				grandPatId = grandPat.id;
				var grandGrand = $('#itemCat').tree('getParent', grandPat.target);
				grandGrandPatId = grandGrand.id;
			}
			
			if(type == "IngredientCode"){
				var grandPat = $('#itemCat').tree('getParent', node.target);
				grandPatId = grandPat.id;
				var grandGrand = $('#itemCat').tree('getParent', grandPat.target);
				grandGrandPatId = grandGrand.id;
			}
			
			if(type == "GenerNameProp"){
				var grandGrand = $('#itemCat').tree('getParent', node.target);
				grandGrandPatId = grandGrand.id;
			}
			
			
			var catstr = parentId +"^"+ grandPatId +"^"+ grandGrandPatId +"^"+ type;
			$("#itemlist").datagrid("load",{"Id":node.id,"catstr":catstr});
	    },
        onLoadSuccess:function(node,data){	      
	    }
	});
}

function initDrugList()
{
	/// �ı��༭��
	var textEditor={
		type: 'text',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}
	
	///  ����columns
	var columns=[[
		{field:'drugId',title:'drugId',width:20,editor:textEditor,hidden:true},
		{field:'operateKnow',title:'֪ʶά��',width:80,formatter:linkKnowUrl},
		{field:'operateRule',title:'����ά��',width:80,formatter:linkRuleUrl},
		{field:'drugCode',title:'ҩƷ����',width:380,editor:textEditor,hidden:true},
		{field:'drugDesc',title:'ҩƷ����',width:420},
		{field:'parentId',title:'ҩƷ�ֵ�id',width:60,hidden:true},		
		{field:'prop',title:'���',width:80},
		{field:'formType',title:'����',width:80},
		{field:'proName',title:'��Ʒ��',width:150,hidden:true},
		{field:'generFromName',title:'ͨ����',width:150},
		{field:'generName',title:'��ѧ��',width:120},
		{field:'facturer',title:'��������',width:150}
	
		
	]];
	
	///  ����datagrid
	var option = {
		rownumbers : true,
		singleSelect : true,
		showPageList : false,
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
            
        }
	};
	
	var uniturl = LINK_CSP+"?ClassName=web.DHCCKBPhaClsDrugManage&MethodName=QueryDrugList&Id=";;
	new ListComponent('itemlist', columns, uniturl, option).Init();
}

function linkKnowUrl(value, rowData, rowIndex)
{
	var html = "<a onclick=\"OpenKonwWin('"+rowData.drugId+"','"+rowData.parentId+"')\">֪ʶά��</a>" ;
	return html;

}

function linkRuleUrl(value, rowData, rowIndex)
{
	var html = "<a onclick=\"OpenRuleWin('"+rowData.drugId+"')\">����ά��</a>" 
	return html;

}

function OpenKonwWin(drugId,parentId)
{
	var dicParref = serverCall("web.DHCCKBDrugRuleMaintain","GetEntyId",{"DrugId":drugId});
	var linkUrl="dhcckb.editprop.csp"
	var openUrl = '<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="'+linkUrl+'?parref='+drugId+'&dicParref='+dicParref+'&parentId='+parentId+'&dialogFlag=1'+'"></iframe>';
	if ("undefined"!==typeof websys_getMWToken){
		openUrl = '<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="'+linkUrl+'?parref='+drugId+'&dicParref='+dicParref+'&parentId='+parentId+'&dialogFlag=1'+"&MWToken="+websys_getMWToken()+'"></iframe>'; 
	}	
	if($('#win').is(":visible")){
		$("#win").remove();
	}
	if($('#winmodel').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�
	$('body').append('<div id="winmodel"></div>');
	$('#winmodel').window({
		title:'ʵ��֪ʶά��',
		iconCls:'icon-w-save',
		collapsible:true,
		border:false,
		closed:"true",
		modal:true,
		//maximized:true,
		maximizable:true,
		minimizable:false,		
		width:$(window).width()-50, //800,
		height:$(window).height()-50,//500
	});	

	$('#winmodel').html(openUrl);
	$('#winmodel').window('open');
}

function OpenRuleWin(drugId)
{
	var url="dhcckb.rule.indexdir.csp?ModelDic="+drugId+"&LoginInfo="+LoginInfo+"&ruleID="+""+"&drugID="+drugId;
	if ("undefined"!==typeof websys_getMWToken){
		url += "&MWToken="+websys_getMWToken();
	}
	var openUrl = '<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="'+url+'"></iframe>';		
	if($('#rulewin').is(":visible")){
		$("#rulewin").remove();
	}
	if($('#rulewin').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�
	$('body').append('<div id="rulewin"></div>');
	$('#rulewin').window({
		title:'����ά��',
		iconCls:'icon-w-save',
		collapsible:true,
		border:false,
		closed:"true",
		modal:true,
		//maximized:true,
		maximizable:true,
		minimizable:false,		
		width:$(window).width()-50, //800,
		height:$(window).height()-50,//500
	});	

	$('#rulewin').html(openUrl);
	$('#rulewin').window('open');

}
function initButton()
{
	$('#find').bind("click",search);
	
	$('#reset').bind("click",reset);
	
}
function search()
{
	var drugname = $("#drugname").val();
	var gename = $("#gename").val();
	var manfname = $("#manfname").val();
	var params = drugname +"^"+ gename +"^"+ manfname;
	var catstr = parentId +"^"+ grandPatId +"^"+ grandGrandPatId +"^"+ type;
	$("#itemlist").datagrid("load",{"Id":nodeId,"params":params,"catstr":catstr});
	
}

function reset()
{
	$("#drugname").val("");
	$("#gename").val("");
	$("#manfname").val("");
	var params = "";
	var catstr = parentId +"^"+ grandPatId +"^"+ grandGrandPatId +"^"+ type;
	$("#itemlist").datagrid("load",{"Id":nodeId,"params":params,"catstr":catstr});
}
/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
1