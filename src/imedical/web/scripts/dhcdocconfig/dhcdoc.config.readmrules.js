var PageLogicObj;
$(function() {
    Init();
    InitPage();
    InitEvent();
});

function InitCache() {
    var hasCache = $.DHCDoc.ConfigHasCache();
    if (hasCache != 1) {
        $.DHCDoc.CacheConfigPage();
        $.DHCDoc.storageConfigPageCache();
    }
}

function Init() {
    PageLogicObj={
        ReAdmRulesDataGrid:""
    }
}

function InitEvent(){
    $("#BFind").click(LoadLocRulesList);
    $("#BSetRules").click(SetConfigWin);
    $("#Combo_Rules").blur(function(e){
        var desc = $(e.target).lookup('getText');
	    if(!desc){
		  	$(e.target).lookup('clear');
		}
	});
    InitPOPMark();
}

function InitPOPMark(){
    var MarkHtml="1.�жϸ����������� �Һ� �� ¼�����<br/>"
    MarkHtml+="2.�������¼�ж�:<br/>"
    MarkHtml+="&nbsp;&nbsp;�Һ�ʱ���ж����õ��������Ƿ��йҺſ��ҵ���Ч����,<br/>"
    MarkHtml+="&nbsp;&nbsp;&nbsp;&nbsp;- ������Ĭ��Ϊ���︴�ﻼ��,<br/>"
    MarkHtml+="&nbsp;&nbsp;&nbsp;&nbsp;- ������������¼��ҳ��ʱ���� ������չ����->���¼�����û�б����Ǿ����Ƿ�Ĭ�ϳ��� ���ж��Ƿ�ѡ�г���<br/>"
    MarkHtml+="&nbsp;&nbsp;¼�����ʱ�����ж�<br/>"
    MarkHtml+="3.����ϼ�¼�ж�:<br/>"
    MarkHtml+="&nbsp;&nbsp;�Һ�ʱ���������־,�������¼����� ������չ����->���¼�����û�б����Ҿ����Ƿ�Ĭ�ϳ��� ���ж��Ƿ�ѡ�г���<br/>"
    MarkHtml+="&nbsp;&nbsp;¼�����ʱ,�жϻ������(���кͽ���):<br/>"
    MarkHtml+="&nbsp;&nbsp;&nbsp;&nbsp;- �ж�����:���������ڵľ����������Ƿ��ж�Ӧ��ʷ���(�ɿ����),�������޼�¼�ж��ǳ��ﻹ�Ǹ���  <br/>"
    MarkHtml+="&nbsp;&nbsp;&nbsp;&nbsp;- ��ʾǰ��:�жϽ����ҳ��ѡ������һ��ʱ,�������ʾ<br/>"
    MarkHtml+="&nbsp;&nbsp;&nbsp;&nbsp;- ��ʾ����:ҳ��δѡ���κ�״̬ �жϽ��Ϊ����-ҳ��ѡ�����︴����Ժ���� �жϽ��Ϊ����-ҳ��ѡ�г���<br/>"
    MarkHtml+="&nbsp;&nbsp;&nbsp;&nbsp;- ��ʾ����:�״���ʾ��,��ѡ���޸�״̬,�����¼����Ͻ�������ʾ"
    $("#Mark").popover({title:'˵��',content:MarkHtml,placement:'auto-bottom',trigger:'hover'});
}


function InitPage(){
    InitHospList();
    InitComboLoc();
    InitComboRules();
    InitReAdmRulesDataGrid();
    InitCache();
}

function InitHospList() 
{
    var hospComp = GenHospComp("Doc_BaseConfig_ReAdmRules");
    hospComp.jdata.options.onSelect = function(e, t) {
	    InitComboLoc();
	    ClearSearch();
	    LoadLocRulesList();
    }
    hospComp.jdata.options.onLoadSuccess = function(data) {
    }
}

function InitComboLoc() 
{
    var HospID = $HUI.combogrid('#_HospList').getValue();
    $HUI.combobox("#Combo_Loc", {
        url: $URL + "?ClassName=DHCDoc.DHCDocConfig.CommonFunction&QueryName=QueryLoc&depname=&UserID=&LogHospId=" + HospID + "&ResultSetType=array",
        valueField: 'id',
        textField: 'name',
        mode: "local",
        filter: function(q, row) {
            var ops = $(this).combobox('options');
            var mCode = false;
            if (row.ContactName) {
                mCode = row.ContactName.toUpperCase().indexOf(q.toUpperCase()) >= 0
            }
            var mValue = row[ops.textField].indexOf(q) >= 0;
            return mCode || mValue;
        },
        onChange:function(newCode,oldCode){
        },
    });
}

function InitComboRules(){
    $("#Combo_Rules").lookup({
		url:$URL,
        fitColumns:true,
		mode:'remote',
		pagination:true,
        width:200,
        panelWidth:400,
        delay:500,
		idField:'RuleRowId',
		textField:'RuleTitle',
        queryParams:{ClassName: 'DHCDoc.DHCDocConfig.ReAdmRulesSet',QueryName: 'RuleList'},
        onBeforeLoad:function(param){
	        var Desc=param['q'];
            var HospID=$HUI.combogrid('#_HospList').getValue();
			param = $.extend(param,{HospId:HospID,Desc:Desc});
	    },
		columns:[[
            {field:'RuleRowId',title:'����ID',width:50 },
            {field:'RuleTitle',title:'��������',width:150 },
            {field:'RuleByCode',title:'�ж����ݱ���',width:100, hidden:true},
            {field:'RuleByDesc',title:'�ж�����',width:100, hidden:true},
            {field:'RuleDays',title:'�ж�����',width:100 ,hidden:true},
            {field:'RuleMainDiagFlag',title:'���������',width:100,hidden:true}
		]],
		selectRowRender:function(row){
			if (!row) return;
            var RuleDesc='<div style="padding:5px">'
            RuleDesc+='<strong>�ж�����</strong>: <span style="color:red">' + row.RuleByDesc + '</span><br>';
            RuleDesc+='<strong>�ж�����</strong>: <span style="color:red">' + row.RuleDays + ' ��</span><br>';
            if(row.RuleByCode=="DIA"){
                RuleDesc+='<strong>���������</strong>: <span style="color:red">'  + (row.RuleMainDiagFlag=="Y"?"��":"��") + '</span><br>';
            }
            RuleDesc+="</div>"
            return RuleDesc;
		}
	});
}

function InitReAdmRulesDataGrid(){
    var ReAdmRulesBar = [{
        text: '����',
        iconCls: 'icon-add',
        handler:function(){
	        $("#LocRuleRowId").val("");
            Save()
        }
    },{
        text: '�޸�',
        iconCls: 'icon-save',
        handler:function(){
            Modify()
        }
    },{
        text: 'ɾ��',
        iconCls: 'icon-cancel',
        handler:function(){
            Delete()
        }
    },{
        text: '˵��',
        iconCls: 'icon-tip',
        id:"Mark",
        handler:function(){
        }
    }];

    var ReAdmRulesColumns=[[
        {field:'LocRuleId',title:'',hidden:true},
        {field:'LocId',title:'',hidden:true},
        {field:'LocDesc',title:'����',width:100 , align: 'center'},
        {field:'RuleRowId',title:'',hidden:true},
        {field:'RuleTitle',title:'��������',width:100 , align: 'center'},
        {field:'RuleByCode',title:'�ж����ݱ���',width:100,hidden:true},
        {field:'RuleByDesc',title:'�ж�����',width:100 , align: 'center'},
        {field:'RuleDays',title:'�ж�����',width:100 , align: 'center'},
        {field:'RuleMainDiagFlag',title:'���������',width:100 , align: 'center',
            formatter:function(val){
                return val=="Y"?"��":"��";
            }
        }
    ]];
    PageLogicObj.ReAdmRulesDataGrid=$("#tabItmRules").datagrid({  
        fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		url:$URL,
		loadMsg : '������..',  
		pagination : true,
		rownumbers : true, 
        idField:"LocRuleId",
        pageSize:15,
        pageList:[15,50,100,200],
        columns :ReAdmRulesColumns,
        toolbar :ReAdmRulesBar,
        loadBeforeClearSelect:true,
        onBeforeLoad:function(param){
            var FindLoc = $("#Combo_Loc").combo('getValue'); 
            var FindRuleID = $('#Combo_Rules').lookup('getValue');
            var HospID=$HUI.combogrid('#_HospList').getValue();
            param.ClassName ='DHCDoc.DHCDocConfig.ReAdmRules';
            param.QueryName ='LocRuleList';
            param.LocID =FindLoc;
            param.RuleID =FindRuleID;
            param.HospID=HospID;
        },
        onSelect:function(rowIndex, rowData){
            $("#Combo_Loc").combobox("setValue",rowData['LocId'])
            $("#Combo_Rules").lookup("setValue",rowData['RuleRowId'])
            $("#Combo_Rules").lookup("setText",rowData['RuleTitle'])
			$("#LocRuleRowId").val(rowData['LocRuleId']);
		},
		onUnselect:function(){
			ClearSearch();
		}
    });
}

/**ˢ���б� */
function LoadLocRulesList(){
    if(!PageLogicObj.ReAdmRulesDataGrid) return;
    PageLogicObj.ReAdmRulesDataGrid.datagrid("reload");
    return ;
}

/**�����������ҳ�� */
function SetConfigWin(){
	var HospID=$HUI.combogrid('#_HospList').getValue();
	if (HospID == "") {
		$.messager.alert("��ʾ","��ѡ��ҽԺ��","info")
		return false;
	}
	var URL = "dhcdoc.config.readmrulesset.hui.csp?HospID="+HospID;
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-edit',
		title:'��������',
		width:950,height:500
	})

}

/**���� */
function Save(){
    var HospID=$HUI.combogrid('#_HospList').getValue();
    var LocID = $("#Combo_Loc").combo('getValue'); 
    var RuleID = $('#Combo_Rules').lookup('getValue');
    
    var LocRuleID=$("#LocRuleRowId").val()
    
    var DataObj={
        LocRuleID:LocRuleID,
        LocID:LocID,
        RuleID:RuleID,
        HospID:HospID
    }

    var CheckValObj={
        HospID:"��ѡ��ҽԺ!",
        LocID:"��ѡ�����!",
        RuleID:"��ѡ�������!"
    }
    for (var key in CheckValObj){
        if(!DataObj[key]){
            $.messager.alert("��ʾ",CheckValObj[key])
            return;
        }
    }

    var DataStr=JSON.stringify (DataObj);
    var Rtn=$.m({
        ClassName:"DHCDoc.DHCDocConfig.ReAdmRules",
        MethodName:"Save",
        inPara:DataStr
    },false)

    var RtnArr=Rtn.split("^")
    $.messager.alert('��ʾ',RtnArr[1]);
    if(RtnArr[0]>=0){
	    ClearSearch();
        LoadLocRulesList();
        return true;
    }else{
        return false;
    }
}

/**�޸� */
function Modify(){
    var LocRuleID=$("#LocRuleRowId").val()
    if(LocRuleID==""){
        $.messager.alert("��ʾ","��ѡ�����޸ļ�¼")
        return;
    }
    var LocID = $("#Combo_Loc").combo('getValue'); 
    var row=PageLogicObj.ReAdmRulesDataGrid.datagrid("getSelected");
    if(row.LocId!=LocID){
	    $.messager.alert("��ʾ","ѡ���޸ļ�¼�Ŀ����뵱ǰѡ��Ŀ��Ҳ�һ��,��ѡ����ĵĿ��ҹ����¼�����޸�!")
    	PageLogicObj.ReAdmRulesDataGrid.datagrid("unselectAll");
        return;
	}
    Save();
}

/**ɾ�� */
function Delete(){
    var LocRuleID=$("#LocRuleRowId").val()
    if(LocRuleID==""){
        $.messager.alert("��ʾ","��ѡ����ɾ����¼")
        return;
    }
    $.messager.confirm("��ʾ", "��ȷ��Ҫɾ����?",
    function(r) {
        if (!r) return;
	    var Rtn=$.m({
	        ClassName:"DHCDoc.DHCDocConfig.ReAdmRules",
	        MethodName:"Delete",
	        LocRuleID:LocRuleID
	    },false)

	    if(Rtn=="0"){
	        $.messager.alert("��ʾ","ɾ���ɹ�")
	        ClearSearch();
	        LoadLocRulesList();
	    }else{
	        $.messager.alert("��ʾ","ɾ��ʧ��")
	    }
	    return;
    });


}

/*���ѡ��*/
function ClearSearch(){
	$("#Combo_Loc").combobox("select","");
	$('#Combo_Rules').lookup("clear");
	$("#LocRuleRowId").val("");
}
