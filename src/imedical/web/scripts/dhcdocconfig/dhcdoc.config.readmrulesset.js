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

/**初始化复诊规则列表 */
function InitReAdmRulesListDataGrid(){
    var ReAdmRulesBar = [{
        text: '增加',
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
        text: '删除',
        iconCls: 'icon-cancel',
        handler: function() {
            if(PageLogicObj.ReAdmRulesListDataGrid=="") return;
            var rows = PageLogicObj.ReAdmRulesListDataGrid.datagrid("getSelections");
            if (rows.length > 0) {
                $.messager.confirm("提示", "你确定要删除吗?",
                function(r) {
                    if (r) {
                        Delete();
                        PageLogicObj.editRow = undefined;
                    }
                });
            } else {
                $.messager.alert("提示", "请选择要删除的行", "error");
            }
        }
    },{
        text: '保存',
        iconCls: 'icon-save',
        handler: function() {
            if(PageLogicObj.ReAdmRulesListDataGrid=="") return;
            Save();
        } 
    },{
        text: '取消编辑',
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
        {field:'RuleTitle',title:'规则名称',width:120 , align: 'center',
            editor : {
                type : 'validatebox',
                options:{
                	required:true
                }
            }
        },
        {field:'RuleByCode',title:'判断依据',width:80 , align: 'center',
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
                        {Code:'ADM',Desc:'就诊记录'},
                        {Code:'DIA',Desc:'诊断数据'}
                    ],
                    onChange:function(newCode,oldCode){
	                    MainDiagFlagAble();
                    }
                }
            }
        },
        {field:'RuleIsDefault',title:'默认',width:80 , align: 'center',
            formatter:function(value,row){
                return value=="Y"?"是":"否";
            },
            editor:{
                type:'icheckbox',
                options:{on:'Y',off:'N'}
            }
        },
        {field:'RuleDays',title:'判断天数',width:80 , align: 'center',
            editor:{
                type:'numberbox',
                options:{
                	required:true
                }
            }
        },
        {field:'RuleMainDiagFlag',title:'依据主诊断',width:80 , align: 'center',
            formatter:function(value,row){
                return value=="Y"?"是":"否";
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
		loadMsg : '加载中..',  
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
				$.messager.alert("提示", "有正在编辑的行，请先点击保存", "error");
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



/**保存配置数据 */
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
        $.messager.alert("提示","规则名称不可为空");
        return false;
    }
    if(!DataObj.RuleByCode){
        $.messager.alert("提示","判断依据不可为空");
        return false;
    }
    if(!DataObj.RuleDays){
        $.messager.alert("提示","判断天数不可为空");
        return false;
    }

	if(DataObj.RuleDays<1){
		$.messager.alert("提示","判断天数只能是大于0的正整数");
        return false;
	}

    var DataStr=JSON.stringify (DataObj);
    var Rtn=$.m({
        ClassName:"DHCDoc.DHCDocConfig.ReAdmRulesSet",
        MethodName:"Save",
        inPara:DataStr
    },false)
    var RtnArr=Rtn.split("^")
    $.messager.alert('提示',RtnArr[1]);
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
        $.messager.alert("提示","请选择需删除记录");
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
        $.messager.alert("提示","删除成功")
        LoadRulesList();
    }else{
        $.messager.alert("提示",Rtn)
    }
    return;
}


/**加载规则列表 */
function LoadRulesList(){
    PageLogicObj.editRow = undefined;
    if(PageLogicObj.ReAdmRulesListDataGrid=="") return;
    PageLogicObj.ReAdmRulesListDataGrid.datagrid('load');
}