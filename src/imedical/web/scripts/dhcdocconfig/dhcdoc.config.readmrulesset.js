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
        ReAdmRulesListDataGrid:"",
        editRow:undefined
    }
}

function InitEvent(){
    
}


function InitPage(){
    InitHospList();
    InitReAdmRulesListDataGrid();
    InitCache();
}

function InitHospList() 
{
    var hospComp = GenHospComp("Doc_BaseConfig_ReAdmRules");
    hospComp.jdata.options.onSelect = function(e, t) {
        LoadRulesList();
    }
    hospComp.jdata.options.onLoadSuccess = function(data) {
    }
}

/**��ʼ����������б� */
function InitReAdmRulesListDataGrid(){
    var ReAdmRulesBar = [{
        text: '����',
        iconCls: 'icon-add',
        handler: function() { 
            PageLogicObj.editRow = undefined;
            if(PageLogicObj.ReAdmRulesListDataGrid=="") return;
            PageLogicObj.ReAdmRulesListDataGrid.datagrid("rejectChanges");
            PageLogicObj.ReAdmRulesListDataGrid.datagrid("unselectAll");

            if (PageLogicObj.editRow != undefined) {
                PageLogicObj.ReAdmRulesListDataGrid.datagrid("endEdit", PageLogicObj.editRow);
                return;
            }else{
                PageLogicObj.ReAdmRulesListDataGrid.datagrid("insertRow", {
                    index: 0,
                    row: {
                    }
                });
                PageLogicObj.ReAdmRulesListDataGrid.datagrid("beginEdit", 0);
                PageLogicObj.editRow = 0;
                PageLogicObj.ReAdmRulesListDataGrid.datagrid('selectRow', PageLogicObj.editRow)
            }
          
        }
    },{
        text: 'ɾ��',
        iconCls: 'icon-cancel',
        handler: function() {
            if(PageLogicObj.ReAdmRulesListDataGrid=="") return;
            var rows = PageLogicObj.ReAdmRulesListDataGrid.datagrid("getSelections");
            if (rows.length > 0) {
                $.messager.confirm("��ʾ", "��ȷ��Ҫɾ����?",
                function(r) {
                    if (r) {
                        Delete();
                        PageLogicObj.editRow = undefined;
                    }
                });
            } else {
                $.messager.alert("��ʾ", "��ѡ��Ҫɾ������", "error");
            }
        }
    },{
        text: '����',
        iconCls: 'icon-save',
        handler: function() {
            if(PageLogicObj.ReAdmRulesListDataGrid=="") return;
            Save();
        } 
    },{
        text: 'ȡ���༭',
        iconCls: 'icon-redo',
        handler: function() {
            PageLogicObj.editRow = undefined;
            if(PageLogicObj.ReAdmRulesListDataGrid=="") return;
            PageLogicObj.ReAdmRulesListDataGrid.datagrid("rejectChanges");
            PageLogicObj.ReAdmRulesListDataGrid.datagrid("unselectAll");
        }
    }];
    var ReAdmRulesColumns=[[
        {field:'RuleRowId',title:'',hidden:true},
        {field:'RuleTitle',title:'��������',width:120 , align: 'center',
            editor : {
                type : 'validatebox',
                options:{
                	required:true
                }
            }
        },
        {field:'RuleByCode',title:'�ж�����',width:80 , align: 'center',
            formatter:function(value,row){
                return row.RuleByDesc;
            },
            editor:{
                type:'combobox',
                options:{
                    valueField:'Code',
                    textField:'Desc',
                    panelHeight:"auto",
                    editable:false,
					blurValidValue:true,
					required: true,
                    data:[
                        {Code:'ADM',Desc:'�����¼'},
                        {Code:'DIA',Desc:'�������'}
                    ],
                    onChange:function(newCode,oldCode){
	                    MainDiagFlagAble();
                    }
                }
            }
        },
        {field:'RuleIsDefault',title:'Ĭ��',width:80 , align: 'center',
            formatter:function(value,row){
                return value=="Y"?"��":"��";
            },
            editor:{
                type:'icheckbox',
                options:{on:'Y',off:'N'}
            }
        },
        {field:'RuleDays',title:'�ж�����',width:80 , align: 'center',
            editor:{
                type:'numberbox',
                options:{
                	required:true
                }
            }
        },
        {field:'RuleMainDiagFlag',title:'���������',width:80 , align: 'center',
            formatter:function(value,row){
                return value=="Y"?"��":"��";
            },
            editor:{
                type:'icheckbox',
                options:{on:'Y',off:'N'}
            }
        }
    ]];
    PageLogicObj.ReAdmRulesListDataGrid=$("#ReAdmRuleList").datagrid({  
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
        idField:"RulesRowid",
        pageSize:15,
        pageList:[15,50,100,200],
        columns :ReAdmRulesColumns,
        toolbar :ReAdmRulesBar,
        loadBeforeClearSelect:true,
        onDblClickRow:function(rowIndex, rowData){
			if (PageLogicObj.editRow != undefined) {
				$.messager.alert("��ʾ", "�����ڱ༭���У����ȵ������", "error");
		        return false;
			}
			PageLogicObj.ReAdmRulesListDataGrid.datagrid("beginEdit", rowIndex);
			PageLogicObj.editRow=rowIndex;
			MainDiagFlagAble();
		},
        onBeforeLoad:function(param){
            var HospID=$HUI.combogrid('#_HospList').getValue();
            param.ClassName ='DHCDoc.DHCDocConfig.ReAdmRulesSet';
            param.QueryName ='RuleList';
            param.HospId=HospID;
        }
    });
}

function MainDiagFlagAble(){
	if(PageLogicObj.editRow==undefined)return;
	var RuleMainDiagFlagED = PageLogicObj.ReAdmRulesListDataGrid.datagrid('getEditor', {index:PageLogicObj.editRow,field:'RuleMainDiagFlag'});
    if(!RuleMainDiagFlagED) return;
    var RuleByCodeED = PageLogicObj.ReAdmRulesListDataGrid.datagrid('getEditor', {index:PageLogicObj.editRow,field:'RuleByCode'});
    var RuleByCode=RuleByCodeED.target.combobox("getValue");
    
    if(RuleByCode=="DIA"){
        $(RuleMainDiagFlagED.target).checkbox("enable");
    }else{
        $(RuleMainDiagFlagED.target).checkbox("uncheck").checkbox("disable");
    }
}



/**������������ */
function Save(){
    if (PageLogicObj.editRow == undefined) return;
    
    var rows=PageLogicObj.ReAdmRulesListDataGrid.datagrid('selectRow', PageLogicObj.editRow).datagrid("getSelected");
    var HospId=$("#_HospList").combobox("getValue");
    var DataObj={
		RuleRowId:rows.RuleRowId?rows.RuleRowId:"",
		RuleHosp:HospId
	};
	
	var editors = PageLogicObj.ReAdmRulesListDataGrid.datagrid('getEditors', PageLogicObj.editRow);
	if(editors.length==0) {
		PageLogicObj.editRow =undefined
		return;
	}
	
	for(var i=0;i<editors.length;i++){
		var TarType=editors[i]["type"];
		if(TarType=="combobox"){
			DataObj[editors[i]["field"]]=editors[i].target.combobox('getValue');
		}else if(TarType=="icheckbox"){
			DataObj[editors[i]["field"]]=editors[i].target.checkbox('getValue')?"Y":"N";
		}else{
			DataObj[editors[i]["field"]]=editors[i].target.val();
		}
	}
	if(DataObj.RuleByCode!="DIA"){
	    DataObj.RuleMainDiagFlag="";
	}
    if(!DataObj.RuleTitle){
        $.messager.alert("��ʾ","�������Ʋ���Ϊ��");
        return false;
    }
    if(!DataObj.RuleByCode){
        $.messager.alert("��ʾ","�ж����ݲ���Ϊ��");
        return false;
    }
    if(!DataObj.RuleDays){
        $.messager.alert("��ʾ","�ж���������Ϊ��");
        return false;
    }

	if(DataObj.RuleDays<1){
		$.messager.alert("��ʾ","�ж�����ֻ���Ǵ���0��������");
        return false;
	}

    var DataStr=JSON.stringify (DataObj);
    var Rtn=$.m({
        ClassName:"DHCDoc.DHCDocConfig.ReAdmRulesSet",
        MethodName:"Save",
        inPara:DataStr
    },false)
    var RtnArr=Rtn.split("^")
    $.messager.alert('��ʾ',RtnArr[1]);
    if(RtnArr[0]>=0){
        LoadRulesList();
        return true;
    }else{
        return false;
    }

}

function Delete(){
    var row=PageLogicObj.ReAdmRulesListDataGrid.datagrid('getSelected');
    if(!row){
        $.messager.alert("��ʾ","��ѡ����ɾ����¼");
        return;
    }

    var RuleID=row["RuleRowId"];
    if (RuleID==undefined){
        PageLogicObj.editRow = undefined;
        PageLogicObj.ReAdmRulesListDataGrid.datagrid("rejectChanges");
        PageLogicObj.ReAdmRulesListDataGrid.datagrid("unselectAll");
        return false;
    }
    var Rtn=$.m({
        ClassName:"DHCDoc.DHCDocConfig.ReAdmRulesSet",
        MethodName:"Delete",
        RuleID:RuleID
    },false)

    if(Rtn=="0"){
        $.messager.alert("��ʾ","ɾ���ɹ�")
        LoadRulesList();
    }else{
        $.messager.alert("��ʾ",Rtn)
    }
    return;
}


/**���ع����б� */
function LoadRulesList(){
    PageLogicObj.editRow = undefined;
    if(PageLogicObj.ReAdmRulesListDataGrid=="") return;
    PageLogicObj.ReAdmRulesListDataGrid.datagrid('load');
}