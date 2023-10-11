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
    var MarkHtml="1.判断复诊有两个点 挂号 和 录入诊断<br/>"
    MarkHtml+="2.按就诊记录判断:<br/>"
    MarkHtml+="&nbsp;&nbsp;挂号时会判断设置的天数内是否有挂号科室的有效就诊,<br/>"
    MarkHtml+="&nbsp;&nbsp;&nbsp;&nbsp;- 若有则默认为门诊复诊患者,<br/>"
    MarkHtml+="&nbsp;&nbsp;&nbsp;&nbsp;- 若无则进入诊断录入页面时根据 科室扩展设置->诊断录入检索没有本科是就诊是否默认初诊 来判断是否选中初诊<br/>"
    MarkHtml+="&nbsp;&nbsp;录入诊断时不做判断<br/>"
    MarkHtml+="3.按诊断记录判断:<br/>"
    MarkHtml+="&nbsp;&nbsp;挂号时不做复诊标志,进入诊断录入根据 科室扩展设置->诊断录入检索没有本科室就诊是否默认初诊 来判断是否选中初诊<br/>"
    MarkHtml+="&nbsp;&nbsp;录入诊断时,判断患者诊断(已有和将开):<br/>"
    MarkHtml+="&nbsp;&nbsp;&nbsp;&nbsp;- 判断条件:设置天数内的就诊日期中是否有对应历史诊断(可跨科室),根据有无记录判断是初诊还是复诊  <br/>"
    MarkHtml+="&nbsp;&nbsp;&nbsp;&nbsp;- 提示前提:判断结果与页面选择结果不一致时,会进行提示<br/>"
    MarkHtml+="&nbsp;&nbsp;&nbsp;&nbsp;- 提示条件:页面未选中任何状态 判断结果为初诊-页面选中门诊复诊或出院复诊 判断结果为复诊-页面选中初诊<br/>"
    MarkHtml+="&nbsp;&nbsp;&nbsp;&nbsp;- 提示规则:首次提示后,若选择不修改状态,则后续录入诊断将不再提示"
    $("#Mark").popover({title:'说明',content:MarkHtml,placement:'auto-bottom',trigger:'hover'});
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
            {field:'RuleRowId',title:'规则ID',width:50 },
            {field:'RuleTitle',title:'规则名称',width:150 },
            {field:'RuleByCode',title:'判断依据编码',width:100, hidden:true},
            {field:'RuleByDesc',title:'判断依据',width:100, hidden:true},
            {field:'RuleDays',title:'判断天数',width:100 ,hidden:true},
            {field:'RuleMainDiagFlag',title:'依据主诊断',width:100,hidden:true}
		]],
		selectRowRender:function(row){
			if (!row) return;
            var RuleDesc='<div style="padding:5px">'
            RuleDesc+='<strong>判断依据</strong>: <span style="color:red">' + row.RuleByDesc + '</span><br>';
            RuleDesc+='<strong>判断天数</strong>: <span style="color:red">' + row.RuleDays + ' 天</span><br>';
            if(row.RuleByCode=="DIA"){
                RuleDesc+='<strong>依据主诊断</strong>: <span style="color:red">'  + (row.RuleMainDiagFlag=="Y"?"是":"否") + '</span><br>';
            }
            RuleDesc+="</div>"
            return RuleDesc;
		}
	});
}

function InitReAdmRulesDataGrid(){
    var ReAdmRulesBar = [{
        text: '新增',
        iconCls: 'icon-add',
        handler:function(){
	        $("#LocRuleRowId").val("");
            Save()
        }
    },{
        text: '修改',
        iconCls: 'icon-save',
        handler:function(){
            Modify()
        }
    },{
        text: '删除',
        iconCls: 'icon-cancel',
        handler:function(){
            Delete()
        }
    },{
        text: '说明',
        iconCls: 'icon-tip',
        id:"Mark",
        handler:function(){
        }
    }];

    var ReAdmRulesColumns=[[
        {field:'LocRuleId',title:'',hidden:true},
        {field:'LocId',title:'',hidden:true},
        {field:'LocDesc',title:'科室',width:100 , align: 'center'},
        {field:'RuleRowId',title:'',hidden:true},
        {field:'RuleTitle',title:'规则名称',width:100 , align: 'center'},
        {field:'RuleByCode',title:'判断依据编码',width:100,hidden:true},
        {field:'RuleByDesc',title:'判断依据',width:100 , align: 'center'},
        {field:'RuleDays',title:'判断天数',width:100 , align: 'center'},
        {field:'RuleMainDiagFlag',title:'依据主诊断',width:100 , align: 'center',
            formatter:function(val){
                return val=="Y"?"是":"否";
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
		loadMsg : '加载中..',  
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

/**刷新列表 */
function LoadLocRulesList(){
    if(!PageLogicObj.ReAdmRulesDataGrid) return;
    PageLogicObj.ReAdmRulesDataGrid.datagrid("reload");
    return ;
}

/**复诊规则配置页面 */
function SetConfigWin(){
	var HospID=$HUI.combogrid('#_HospList').getValue();
	if (HospID == "") {
		$.messager.alert("提示","请选择医院！","info")
		return false;
	}
	var URL = "dhcdoc.config.readmrulesset.hui.csp?HospID="+HospID;
	websys_showModal({
		url:URL,
		iconCls: 'icon-w-edit',
		title:'规则配置',
		width:950,height:500
	})

}

/**新增 */
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
        HospID:"请选择医院!",
        LocID:"请选择科室!",
        RuleID:"请选择复诊规则!"
    }
    for (var key in CheckValObj){
        if(!DataObj[key]){
            $.messager.alert("提示",CheckValObj[key])
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
    $.messager.alert('提示',RtnArr[1]);
    if(RtnArr[0]>=0){
	    ClearSearch();
        LoadLocRulesList();
        return true;
    }else{
        return false;
    }
}

/**修改 */
function Modify(){
    var LocRuleID=$("#LocRuleRowId").val()
    if(LocRuleID==""){
        $.messager.alert("提示","请选择需修改记录")
        return;
    }
    var LocID = $("#Combo_Loc").combo('getValue'); 
    var row=PageLogicObj.ReAdmRulesDataGrid.datagrid("getSelected");
    if(row.LocId!=LocID){
	    $.messager.alert("提示","选定修改记录的科室与当前选择的科室不一致,请选定需改的科室规则记录进行修改!")
    	PageLogicObj.ReAdmRulesDataGrid.datagrid("unselectAll");
        return;
	}
    Save();
}

/**删除 */
function Delete(){
    var LocRuleID=$("#LocRuleRowId").val()
    if(LocRuleID==""){
        $.messager.alert("提示","请选择需删除记录")
        return;
    }
    $.messager.confirm("提示", "你确定要删除吗?",
    function(r) {
        if (!r) return;
	    var Rtn=$.m({
	        ClassName:"DHCDoc.DHCDocConfig.ReAdmRules",
	        MethodName:"Delete",
	        LocRuleID:LocRuleID
	    },false)

	    if(Rtn=="0"){
	        $.messager.alert("提示","删除成功")
	        ClearSearch();
	        LoadLocRulesList();
	    }else{
	        $.messager.alert("提示","删除失败")
	    }
	    return;
    });


}

/*清除选项*/
function ClearSearch(){
	$("#Combo_Loc").combobox("select","");
	$('#Combo_Rules').lookup("clear");
	$("#LocRuleRowId").val("");
}
