var trigger = 0;                    //用于判断简单或高级查询触发
//var simpleSelectedNode = null;      //选中的简单查询检索分类            // 高级查询和简单查询的检索分类合二为一  edit by 牛才才
var SelectedNode = null;    //选中的查询检索分类

//Desc:     客户端验证简单查询条件
//Params:   submitValues为简单查询条件键值对
//Return:   一个数组（第一项代表是否合法，第二项为错误信息）
function validateSimpleRequest(submitValues) {
    //debugger;
    var result = [];
    var isValid = true;
    var errMessage = "";

    var patientName = submitValues["txtPatientName"];
    var regNo = submitValues["txtRegNo"];
	var MedicareNo = submitValues["MedicareNo"];
    var episodeNo = submitValues["txtEpisodeNo"];
	var diagnose = submitValues["txtEpisodeNo"];
    var admBeginDate = submitValues["dtAdmBeginDate"];
    var admEndDate = submitValues["dtAdmEndDate"];
    var disBeginDate = submitValues["dtDisBeginDate"];
    var disEndDate = submitValues["dtDisEndDate"];
    
    if (patientName == "" && regNo == "" && MedicareNo == "" && episodeNo == "" && admBeginDate == "" && admEndDate == "" && disBeginDate == "" && disEndDate == "" && diagnose == "") {
        isValid = false;
        errMessage = "至少指定一个或一组查询条件!";
    } else if (patientName == "" && regNo == "" && MedicareNo == "" && episodeNo == "" && diagnose == "") {
        var isUseAdmit = (admBeginDate != ""&&admEndDate != "")||(admBeginDate == "" && admEndDate == "");
        var isUseDisch = (disBeginDate != ""&&disEndDate != "")||(disBeginDate == "" && disEndDate == "");
        if (!(isUseAdmit && isUseDisch)) {
            isValid = false;
            errMessage = "入院或出院起始截止日期必须成对出现!";
        }
    }
    
    if (admBeginDate != "" && !regDate(admBeginDate)) {
        isValid = false;
        errMessage = "入院起始日期格式不正确，正确格式为YYYY-MM-DD";
    }
    if (admEndDate != "" && !regDate(admEndDate)) {
        isValid = false;
        errMessage = "入院起始日期格式不正确，正确格式为YYYY-MM-DD";
    }
    if (admBeginDate != "" && admEndDate != "") {
		if (DateCompare(admEndDate, admBeginDate) == false) {
            isValid = false;
            errMessage = "入院截止日期不能小于入院起始日期";
        }
        else if (DateDiff(admEndDate, admBeginDate) > queryDateGap) {
            isValid = false;
            errMessage = "入院日期间隔不能超过系统指定的" + queryDateGap + "天";
        }
    }
    
    if (disBeginDate != "" && !regDate(disBeginDate)) {
        isValid = false;
        errMessage = "出院起始日期格式不正确，正确格式为YYYY-MM-DD";
    }
    if (disEndDate != "" && !regDate(disEndDate)) {
        isValid = false;
        errMessage = "出院起始日期格式不正确，正确格式为YYYY-MM-DD";
    }
    if (disBeginDate != "" && disEndDate != "") {
		if (DateCompare(disEndDate, disBeginDate) == false) {
            isValid = false;
            errMessage = "出院截止日期不能小于出院起始日期";
        }
        else if (DateDiff(disEndDate, disBeginDate) > queryDateGap) {
            isValid = false;
            errMessage = "出院日期间隔不能超过系统指定的" + queryDateGap + "天";
        }
    }
    
    result[0] = isValid;
    result[1] = errMessage;
    return result;
}

//Desc: 移除简单查询结果列（暂时未用）
function removeSimpleResultCols() {
    var divSimpleResultCols = Ext.get('divSimpleResultCols');
    if (divSimpleResultCols) {
        /*
        var count = 0;
        var items = Ext.fly("divSimpleResultCols").select("input[type=checkbox]", true);
        Ext.each(items.elements, function(item) {
            if (!item.dom.disabled && item.dom.checked) {
                count = count + 1;
                items.elements.remove(item);
            }
        });
        if (count > 0) {
            divSimpleResultCols.dom.innerHTML = "";
            Ext.each(items.elements, function(item) {
                debugger;
                return;
                var checkboxModule = new Ext.form.Checkbox({
                    name: "chkItems",
                    boxLabel: item.dom.nextSibling.innerText,
                    labelSeparator: "",  
                    inputValue: item.dom.value,
                    checked: true,
                    disabled: true
                }).render(divSimpleResultCols);
            });
        }
        */
        //var pnlSimpleCols = Ext.getCmp('pnlSimpleCols');
		var frmSimpleCols = Ext.getCmp('frmSimpleCols');
        //Ext.each(pnlSimpleCols.findByType('checkbox'), function(item, index, allItems) {
		Ext.each(frmSimpleCols.findByType('checkbox'), function(item, index, allItems) {
            //debugger;
            alert(item.id);
        }, this);
		//var items = pnlSimpleCols.findByType('checkbox');
        var items = frmSimpleCols.findByType('checkbox');
        for (var i = 0; i < items.length; i++) {
            //debugger;
            var item = items[i];
            if (!item.disabled && item.checked) { 
            
            }
        }
    }
}

//Desc: 重新配置简单查询结果网格
function reConfigSimpleGridCM() {
    //debugger;
    var grid = Ext.getCmp("resultGrid");
    var result = getResultCMAndFields("divSimpleResultCols");
    var fields = result[0];
    var columnModel = result[1];
    var cm = new Ext.grid.ColumnModel(eval("[" + columnModel + "]"));
    store = new Ext.data.JsonStore({
        url: '../web.eprajax.query.basicquery.cls',
        fields: eval("[" + fields + "]")
    });
    //store.load({ params: { start: 0, limit: queryPageSize} });
    grid.reconfigure(store, cm);

	//重置页码显示 by YHY
	Ext.getCmp('pagingToolbar').bind(store);
	store.load({ params: { start: 0, limit: 0} });
}

//Desc: 重新配置高级查询结果网格
function reConfigAdvancedGridCM() {
    var grid = Ext.getCmp("resultGrid");
    var result = getResultCMAndFields("divAdvancedResultCols");
    var fields = result[0];
    var columnModel = result[1];
    var cm = new Ext.grid.ColumnModel(eval("[" + columnModel + "]"));
    store = new Ext.data.JsonStore({
        url: '../web.eprajax.query.advancedquery.cls',
        fields: eval("[" + fields + "]")
    });
    //store.load({ params: { start: 0, limit: queryPageSize} });
    grid.reconfigure(store, cm);

	//重置页码显示 by YHY
	Ext.getCmp('pagingToolbar').bind(store);
	store.load({ params: { start: 0, limit: 0} });
}

//Desc: 页面初始化，在页面加载完毕后执行
function init() {
    //初始化简单查询结果列
    loadSimpleDefaultHISItems();
    
    //初始化高级查询结果列
    loadAdvancedDefaultHISItems();
    
    //初始化高级查询条件
    initAdvancedConditons();
}

//Desc: 初始化简单查询结果列
function loadSimpleDefaultHISItems() {
    //debugger;
    var divSimpleResultCols = Ext.get('divSimpleResultCols');
    divSimpleResultCols.dom.innerHTML = "";
    if (divSimpleResultCols) {
        Ext.Ajax.request({
            url: '../web.eprajax.query.basicsetting.cls',
            params: { Action: 'getDefaultHISItems' },
            success: function(response, opts) {
                var arrItems = eval(response.responseText);
                for (var i = 0; i < arrItems.length; i++) {
					//就诊指针和就诊号是必须的结果列，不支持用户自定义选择需要显示的结果列，故加载时做判断  2012-08-03 by niucaicai
					if (arrItems[i]["Code"].split('^')[2] == 'EpisodeNo' || arrItems[i]["Code"].split('^')[2] == 'EpisodeID')
					{
						var checkboxModule = new Ext.form.Checkbox({
							id: arrItems[i]["ID"],
							name: "chkItems",
							boxLabel: arrItems[i]["Title"],
							labelSeparator: "",
							inputValue: arrItems[i]["Code"],
							checked: true,
							disabled: true,   
							renderTo: divSimpleResultCols
						});
						//}).render(divSimpleResultCols);
					}
					else {
						var checkboxModule = new Ext.form.Checkbox({
							id: arrItems[i]["ID"],
							name: "chkItems",
							boxLabel: arrItems[i]["Title"],
							labelSeparator: "",
							inputValue: arrItems[i]["Code"],
							checked: true,
							//disabled: true,    //将条目设为可操作的，支持用户自定义选择需要查看的结果列  2012-08-03 by niucaicai
							renderTo: divSimpleResultCols
						});
						//}).render(divSimpleResultCols);
					}
                }
            },
            failure: function(response, opts) {
                alert(response.responseText);
            }
        });
    }
}

//Desc: 简单查询中“定义结果设置”重置按钮 
// add by 牛才才
function divSimpleResultColsReset(){
	var divSimpleResultCols = Ext.get('divSimpleResultCols');
    if (divSimpleResultCols) {
		var descStr = '';
		var valueStr = '';
		var descDisabledStr = '';
		var valueDisabledStr = '';
        var items = Ext.fly("divSimpleResultCols").select("input[type=checkbox]", true);
        Ext.each(items.elements, function(item) {
			if (item.dom.disabled && item.dom.checked) {
				descDisabledStr = descDisabledStr + '^' + item.dom.nextSibling.innerText;
				valueDisabledStr = valueDisabledStr + '$' + item.dom.value;
            }
            if (!item.dom.disabled && item.dom.checked) {
				descStr = descStr + '^' + item.dom.nextSibling.innerText;
				valueStr = valueStr + '$' + item.dom.value;
            }
        });
		var arrItemsDesc = descStr.split('^');
		var arrItemsValue = valueStr.split('$');
		var arrItemsDisabledDesc = descDisabledStr.split('^');
		var arrItemsDisabledValue = valueDisabledStr.split('$');
    }
	divSimpleResultCols.dom.innerHTML = "";
	for (var i = 1; i < arrItemsDisabledDesc.length; i++) {
		var checkboxModule = new Ext.form.Checkbox({
			name: "chkItems",
			boxLabel: arrItemsDisabledDesc[i],
			labelSeparator: "",
			inputValue: arrItemsDisabledValue[i],
			checked: true,
			disabled: true,
			renderTo: divSimpleResultCols				//此种方式 IE8 能显示，IE6 能显示
		});
		//}).render(divSimpleResultCols);				//此种方式 IE8 能显示，IE6 不能显示，报错“运行时间错误、缺少对象”等等
	}
	for (var i = 1; i < arrItemsDesc.length; i++) {
		var checkboxModule = new Ext.form.Checkbox({
			name: "chkItems",
			boxLabel: arrItemsDesc[i],
			labelSeparator: "",
			inputValue: arrItemsValue[i],
			checked: true,
			renderTo: divSimpleResultCols
		});
		//}).render(divSimpleResultCols);
	}
}

// 添加"简单查询"结果列前获取Grid数据 
// add by 牛才才
function befaddSimpleResultCols(eprIQaddGrid,eprIQaddWin){

	var selections = eprIQaddGrid.getSelectionModel().getSelections();
	if (selections.length == 0) {
			alert("请选择检索项目!");
			return;
	}
	else{
		for (var i=0; i<selections.length; i++)
		{
			var record = selections[i];
			var ItemName=record.get("Title");
			var ItemCode=record.get("Code");
			addSimpleResultCols(ItemCode,ItemName,eprIQaddWin);
		}
	}
	//关闭弹出窗口前，重置CategoryID、PageToolbarPageSize的值为初始值；
	CategoryID = "-1";
	PageToolbarPageSize = 15;
	eprIQaddWin.close();
	reConfigSimpleGridCM();						//添加完成后自动提交结果列

	//添加完结果列后，将简单查询Panel组件设为焦点，支持直接回车进行查询； add by niucaicai 2013-12-13
	var frmSimpleColsObj = Ext.getCmp("frmSimpleCols");
	frmSimpleColsObj.focus();
}

// Desc: 添加简单查询结果列并返回 
// add by 牛才才
function addSimpleResultCols(ItemCode,ItemName,eprIQaddWin) {
    var divColumns = Ext.get("divSimpleResultCols");
    var scopeCode = SelectedNode.attributes.rcode;
    var scopeName = Ext.get("cbxScope").getValue();
    var itemCode = ItemCode;
    var itemName = ItemName;
    var curName = scopeName + "." + itemName;
    var curValue = scopeCode + "^" + itemCode;
    var existed = false;
    var items = Ext.fly("divSimpleResultCols").select("input[type=checkbox]", true);

	// 判断添加的此条结果列是否已经存在
    Ext.each(items.elements, function(item) {
        if (curValue == item.dom.value) {
            existed = true;
            alert(curName+" 已存在！");
        }
    });
	
    if (existed == false) {
        var checkboxModule = new Ext.form.Checkbox({
            name: "chkItems",
            boxLabel: curName,
            labelSeparator: "",
            inputValue: curValue,
            checked: true,
            disabled: false
        }).render(divColumns);
    }
	
}

//Desc: 初始化高级查询结果列
function loadAdvancedDefaultHISItems() {
    var divAdvancedResultCols = Ext.get('divAdvancedResultCols');
    divAdvancedResultCols.dom.innerHTML = "";
    if (divAdvancedResultCols) {
        Ext.Ajax.request({
            url: '../web.eprajax.query.basicsetting.cls',
            params: { Action: 'getDefaultHISItems' },
            success: function(response, opts) {
                var arrItems = eval(response.responseText);
                for (var i = 0; i < arrItems.length; i++) {
					//就诊指针和就诊号是必须的结果列，不支持用户自定义选择需要显示的结果列，故加载时做判断  2012-08-03 by niucaicai
					if (arrItems[i]["Code"].split('^')[2] == 'EpisodeNo' || arrItems[i]["Code"].split('^')[2] == 'EpisodeID')
					{
						var checkboxModule = new Ext.form.Checkbox({
							id: arrItems[i]["ID"],
							name: "chkItems",
							boxLabel: arrItems[i]["Title"],
							labelSeparator: "",
							inputValue: arrItems[i]["Code"],
							checked: true,
							disabled: true,   
							renderTo: divAdvancedResultCols
						});
						//}).render(divAdvancedResultCols);
					}
					else {
						var checkboxModule = new Ext.form.Checkbox({
							id: arrItems[i]["ID"],
							name: "chkItems",
							boxLabel: arrItems[i]["Title"],
							labelSeparator: "",
							inputValue: arrItems[i]["Code"],
							checked: true,
							//disabled: true,    //将条目设为可操作的，支持用户自定义选择需要查看的结果列  2012-08-03 by niucaicai
							renderTo: divAdvancedResultCols
						});
						//}).render(divAdvancedResultCols);
					}
                }
            },
            failure: function(response, opts) {
                alert(response.responseText);
            }
        });
    }
}

// Desc: 高级查询中“定义结果设置”重置按钮
// add by 牛才才
function divAdvancedResultColsReset(){
	var divAdvancedResultCols = Ext.get('divAdvancedResultCols');
    if (divAdvancedResultCols) {
		var descStr = '';
		var valueStr = '';
		var descDisabledStr = '';
		var valueDisabledStr = '';
        var items = Ext.fly("divAdvancedResultCols").select("input[type=checkbox]", true);
		//alert(items);
        Ext.each(items.elements, function(item) {
			if (item.dom.disabled && item.dom.checked) {
				descDisabledStr = descDisabledStr + '^' + item.dom.nextSibling.innerText;
				valueDisabledStr = valueDisabledStr + '$' + item.dom.value;
            }
            if (!item.dom.disabled && item.dom.checked) {
				descStr = descStr + '^' + item.dom.nextSibling.innerText;
				valueStr = valueStr + '$' + item.dom.value;
            }
        });
		var arrItemsDesc = descStr.split('^');
		var arrItemsValue = valueStr.split('$');
		var arrItemsDisabledDesc = descDisabledStr.split('^');
		var arrItemsDisabledValue = valueDisabledStr.split('$');
    }
	divAdvancedResultCols.dom.innerHTML = "";
	for (var i = 1; i < arrItemsDisabledDesc.length; i++) {
		var checkboxModule = new Ext.form.Checkbox({
			name: "chkItems",
			boxLabel: arrItemsDisabledDesc[i],
			labelSeparator: "",
			inputValue: arrItemsDisabledValue[i],
			checked: true,
			disabled: true,
			renderTo: divAdvancedResultCols
		});
		//}).render(divAdvancedResultCols);
	}
	for (var i = 1; i < arrItemsDesc.length; i++) {
		var checkboxModule = new Ext.form.Checkbox({
			name: "chkItems",
			boxLabel: arrItemsDesc[i],
			labelSeparator: "",
			inputValue: arrItemsValue[i],
			checked: true,
			renderTo: divAdvancedResultCols
		});
		//}).render(divAdvancedResultCols);
	}
}

// 添加"高级查询"结果列前获取Grid数据 
// add by 牛才才
function befaddAdvancedResultCols(eprIQaddGrid,eprIQaddWin){
	var selections = eprIQaddGrid.getSelectionModel().getSelections();
	if (selections.length == 0) {
			alert("请选择检索项目!");
			return;
	}
	else{
		for (var i=0; i<selections.length; i++)
		{
			var record = selections[i];
			var ItemName=record.get("Title");
			var ItemCode=record.get("Code");
			addAdvancedResultCols(ItemCode,ItemName);
		}
	}
	//关闭弹出窗口前，重置CategoryID、PageToolbarPageSize的值为初始值；
	CategoryID = "-1";
	PageToolbarPageSize = 15;
	eprIQaddWin.close();
	reConfigAdvancedGridCM();                  //添加完成后自动提交结果列
}

// Desc: 添加高级查询结果列并返回结果列 
// add by 牛才才
function addAdvancedResultCols(ItemCode,ItemName) {
    var divColumns = Ext.get("divAdvancedResultCols");
    var scopeCode = SelectedNode.attributes.rcode;
    var scopeName = Ext.get("cbxScope").getValue();
    var itemCode = ItemCode;
    var itemName = ItemName;
    var curName = scopeName + "." + itemName;
    var curValue = scopeCode + "^" + itemCode;
    var existed = false;
    var items = Ext.fly("divAdvancedResultCols").select("input[type=checkbox]", true);
	
    Ext.each(items.elements, function(item) {
        if (curValue == item.dom.value) {
            existed = true;
            alert(curName+" 已存在！");
            return false;
        }
    });
	
    if (!existed) {
        var checkboxModule = new Ext.form.Checkbox({
            name: "chkItems",
            boxLabel: curName,
            labelSeparator: "",
            inputValue: curValue,
            checked: true,
            disabled: false
        }).render(divColumns);
    }
}

//Desc: 初始化高级查询条件 and 获取重置信息 -- ncc
function initAdvancedConditons() {
    var table = Ext.get("tblCondition");
    if (table) {
        var length = table.dom.rows.length;

		// 获取重置信息  start
		if (length>2)
		{
			var ORCodeStr = "start";
			var ORNameStr = "start";
			var ItemCodeStr = "start";
			var ItemNameStr = "start";
			var OPCodeStr = "start";
			var OPNameStr = "start";
			var txtValueStr = "start";
			var count = 0;
			for (var i = 2; i < length ; i++) {
				var row = table.dom.rows[i];
				var children = row.children;
				var ORCode = "",ORName = "", ItemCode = "",ItemName = "", OPCode = "", OPName = "", txtValue = "", checkboxCode = "";
				checkboxCode = document.getElementById("checkbox" + i).checked;
				if (checkboxCode == true)
				{
					ORCode = Ext.get("relation" + i).getValue();
					ItemCode = document.getElementById("column" + i).getAttribute('code');
					ItemName = document.getElementById("column" + i).innerText;
					OPCode = Ext.get("op" + i).getValue();
					txtValue = Ext.get("txtValue" + i).getValue();
					ORCodeStr = ORCodeStr + "^" + ORCode;
					ItemCodeStr = ItemCodeStr + "$" + ItemCode;
					ItemNameStr = ItemNameStr + "^" + ItemName;
					OPCodeStr = OPCodeStr + "^" + OPCode;
					txtValueStr = txtValueStr + "^" + txtValue;
					count = count+1;
				}
			}
			for (var j = 2; j < length; j++) {
                table.dom.deleteRow(2);
            }
			for (var k = 1; k <= count; k++) {
                var setORCode = ORCodeStr.split("^")[k];
				var setItemCode = ItemCodeStr.split("$")[k];
				var setItemName = ItemNameStr.split("^")[k];
				var setOPCode = OPCodeStr.split("^")[k];
				var settxtValue = txtValueStr.split("^")[k];
				resetConditions(setItemCode,setItemName,setOPCode,settxtValue,setORCode);
            }
		}
		
		// modify By niucaicai 2012-10-18 将默认的查询日期修改为可选项，用户可以选择按照  入院日期/出院日期  进行查询
		// 初始化查询条件  start
		else if(length == 0) {
			var scheme = '<td width="7%" class="checkbox"><input type="checkbox" name="checkbox" id="{checkboxId}" value="{idList}" checked="true" disabled>{checkbox}</td>';
            var scheme = scheme + '<td class="relation"><label id="{relationId}" code="{relationCode}" style="white-space:nowrap;">{relation}</label></td>';
            var scheme = scheme + '<td class="colname"><select id="{columnId}" code="{columnCode}" style="white-space:nowrap;">{col}'+'<OPTION VALUE= "' + "EPR^AdmDate^AdmDate^date^1" + '" >' + "入院日期" + '<OPTION VALUE= "' + "EPR^DischDate^DischDate^date^1" + '">' + "出院日期" + '<OPTION VALUE= "' + "EPR^AdmDate^AdmDate^date^1" + '" >' + "就诊日期" + '</select></td>';
            var scheme = scheme + '<td class="op"><label id="{opId}" code="{opCode}" style="white-space:nowrap;">{op}</label></td>';
            var scheme = scheme + '<td class="value"><input type="text" id="{txtValue}" format: "Y-m-d" /></td>';
			
            var trTemplate0 = Ext.DomHelper.createTemplate({ tag: 'tr', html: scheme });
            var trTemplate1 = Ext.DomHelper.createTemplate({ tag: 'tr', html: scheme });
			trTemplate0.append("tblCondition", { checkboxId: 'checkbox0', relationId: 'relation0', relationCode: '', relation: "", columnId: 'column0', opId: 'op0', opCode: '>', op: '大于', txtValue: 'txtValue0' });
            trTemplate1.append("tblCondition", { checkboxId: 'checkbox1', relationId: 'relation1', relationCode: '&&&', relation: "并且", columnId: 'column1', opId: 'op1', opCode: '<', op: '小于', txtValue: 'txtValue1' });
            //add by niucaicai 2012-10-19 默认查询条件显示为“出院日期”
			document.getElementById("column0").value = "EPR^DischDate^DischDate^date^1";
			document.getElementById("column1").value = "EPR^DischDate^DischDate^date^1";

			showInitDate("txtValue0");
			showInitDate("txtValue1");
		}
		// 初始化查询条件  end
    }
}

// Desc: 高级查询--查询条件“重置”后返回新的查询条件 
// add by 牛才才
function resetConditions(setItemCode,setItemName,setOPCode,settxtValue,setORCode) {
    var table = Ext.get("tblCondition");
    if (table) {
        var curIndex = table.dom.rows.length;
		var itemCode = setItemCode;
        var itemName = setItemName;
        var info = itemCode.split("^");
        var opCode = setOPCode;
		var orCode = setORCode;
		var value = settxtValue;
		var checked = true;
		var itemType = info[3];
		var dicNum = info[4];

		var scheme = '<td class="checkbox" width="3%"><input type="checkbox"  name="checkbox" id="checkbox' + curIndex+ '"  checked="checked"></td>';
		var scheme = scheme + '<td class="relation"><select id="relation' + curIndex+ '" value="' + orCode + '">{relation}'+'<OPTION VALUE= "' + "" + '" >' + "" + '<OPTION VALUE= "' + "&&&" + '">' + "并且" + '<OPTION VALUE="' + "|||" + '">'+ "或者" + '</select></td>';
		var scheme = scheme + '<td class="colname"><label id="column' + curIndex + '" code="' + itemCode + '" >{col}</label></td>';
		var scheme = scheme + '<td class="op"><select id="op'+curIndex+'" code="' + opCode + '">{op}'+'<OPTION VALUE= "' + "" + '" >' + "" + '<OPTION VALUE= "' + ">" + '">' + "大于" + '<OPTION VALUE="' + "<" + '">'+ "小于" + '<OPTION VALUE="' + "=" + '">'+ "等于" + '<OPTION VALUE="' + "<>" + '">'+ "不等于" +'<OPTION VALUE="' + "<=" + '">'+ "不大于" + '<OPTION VALUE="' + ">=" + '">'+ "不小于" + '<OPTION VALUE="' + "like" + '">'+ "包含" + '<OPTION VALUE="' + "notlike" + '">'+ "不包含" + '</select></td>';
		var scheme = scheme + '<td class="value"><input type="text" id="txtValue' + curIndex + '" value="' + value + '" style="width:92%;" /></td>';
		buildTemplate(scheme,itemName,itemType,dicNum,orCode,opCode,curIndex);
    }
	return;
}

// 高级查询——添加查询条件前获取要添加的数据 
// add by 牛才才
function befaddAdvancedConditions(eprIQaddGrid,eprIQaddWin){
	
	var selections = eprIQaddGrid.getSelectionModel().getSelections();
	if (selections.length == 0) {
			alert("请选择检索项目!");
			return;
	}
	for (var i=0; i<selections.length; i++)
	{
		//debugger;
		var record = selections[i];
		var ItemName=record.get("Title");
		var ItemCode=record.get("Code");
		addAdvancedConditions(ItemCode,ItemName);
	}
	//关闭弹出窗口前，重置CategoryID、PageToolbarPageSize的值为初始值；
	CategoryID = "-1";
	PageToolbarPageSize = 15;
	eprIQaddWin.close();
}

// Desc: 将获取到的数据添加为高级查询条件 
// add bu 牛才才
function addAdvancedConditions(ItemCode,ItemName) {
    //debugger;
    var table = Ext.get("tblCondition");
    if (table) {
        //debugger;
        var curIndex = table.dom.rows.length;
        var scopeCode = SelectedNode.attributes.rcode;
        var itemName = ItemName;
        var info = ItemCode.split("^");
		var checked = true;
        var itemDetailCode = scopeCode + "^" + info[0] + "^" + info[1] + "^" + info[3] + "^" + info[4];
		var itemType = info[3];
		var dicNum = info[4];
		var orCode = "" , opCode = "";

		var scheme = '<td class="checkbox" width="3%"><input type="checkbox"  name="checkbox" id="checkbox' + curIndex+ '"  checked="checked"></td>';
		var scheme = scheme + '<td class="relation"><select id="relation' + curIndex+ '" >{relation}'+'<OPTION VALUE= "' + "" + '" SELECTED>' + "" + '<OPTION VALUE= "' + "&&&" + '">' + "并且" + '<OPTION VALUE="' + "|||" + '">'+ "或者" + '</select></td>';
		var scheme = scheme + '<td class="colname"><label id="column' + curIndex + '" code="' + itemDetailCode + '" >{col}</label></td>';
		var scheme = scheme + '<td class="op"><select id="op' + curIndex+ '" >{op}'+'<OPTION VALUE= "' + "" + '" SELECTED >' + "" + '<OPTION VALUE= "' + ">" + '">' + "大于" + '<OPTION VALUE="' + "<" + '">'+ "小于" + '<OPTION VALUE="' + "=" + '">'+ "等于" + '<OPTION VALUE="' + "<>" + '">'+ "不等于" + '<OPTION VALUE="' + "<=" + '">'+ "不大于" + '<OPTION VALUE="' + ">=" + '">'+ "不小于" + '<OPTION VALUE="' + "like" + '">'+ "包含" + '<OPTION VALUE="' + "notlike" + '">'+ "不包含" + '</select></td>';
		var scheme = scheme + '<td class="value"><input type="text" id="txtValue' + curIndex + '" style="width:92%;" /></td>';
		buildTemplate(scheme,itemName,itemType,dicNum,orCode,opCode,curIndex);
    }
	return;
}

// 构造高级查询条件表 
// add by 牛才才
function buildTemplate(scheme,itemName,itemType,dicNum,orCode,opCode,curIndex){
	var trTemplate = Ext.DomHelper.createTemplate({ tag: 'tr', html: scheme });
	trTemplate.append("tblCondition", { col: itemName});
	document.getElementById("relation" + curIndex).value = orCode;
	document.getElementById("op" + curIndex).value = opCode;
	var txtValueID = "txtValue" + curIndex;
	// 判断高级查询条件表中字段“值”的类型，并做相应的数据加载
	if (dicNum==1)
	{
		switch(itemType)
		{
			case 'str' : showText(txtValueID);break;
			case 'date': showDate(txtValueID);break;
			case 'time': showTime(txtValueID);break;
		}
	}
	else 
	{
		getDic(txtValueID,dicNum)
	}
}

// “值”的编辑插件  start  
// add by 牛才才
function showInitDate(txtValue){
	var date = new Ext.form.DateField({
		id: 'date',
		width: 78,
		applyTo: txtValue,
		emptyText: '请选择日期',
		format: 'Y-m-d'
	});
}

function showDate(txtValueID){
	var date = new Ext.form.DateField({
		id: 'date',
		width: 91,
		applyTo: txtValueID,
		emptyText: '请选择日期',
		format: 'Y-m-d'
	});
}

function showTime(txtValueID){
	var time = new Ext.form.TimeField({
		id: 'time',
		width: 91,
		applyTo: txtValueID,
		emptyText: '请选择时间',
		format: 'H:i:s',
		increment: 30
	});
}

function showText(txtValueID){
	var text = new Ext.form.TextField({
		id: 'text',
		width: 91,
		applyTo: txtValueID,
		emptyText: '请输入信息'
	});
}

function getDic(txtValueID,dicNum){
	var store = new Ext.data.JsonStore({
		    url: '../web.eprajax.query.getDicList.cls',
		    fields: ['ID', 'DicAlias', 'DicCode', 'DicDesc'],
			root: 'data',
			totalProperty: 'TotalCount',
			baseParams: { start: 0, limit: 12},
			listeners: {
				'beforeload': function() {
					var txtValueText = Ext.get(txtValueID).getValue();
					store.removeAll();
					store.baseParams = { DicCode: dicNum, DicQuery: txtValueText};
				}
			}
	    });
	var dicDeptCox = new Ext.form.ComboBox({
		id: 'dicDeptCox',
		name: 'dicDeptCox',
		width: 91,
		listWidth: 235,
		minChars: 1,
		mode: 'remote',
		store: store,
		hiddenName: 'locID',
		displayField: 'DicDesc',
		valueField: 'ID',
		triggerAction: 'all',
		selectOnFocus: true,
		emptyText: '请选择',
		applyTo: txtValueID,
		listWidth: 240,
		pageSize: 12,
		listeners:{
			'expand': function(){
				store.load();
			}
		}
	});
}
//“值”的编辑插件  end  

//Desc: 获取高级查询条件
//edit by Candyxu
function getAdvancedConditions() {
    //debugger;
    var success = true;
    var errMessage = "";
    
    var table = Ext.get("tblCondition");
    var ResulstContion = new Array();
    if (table) {
        var SelectGap = 3;
        var length = table.dom.rows.length; 
        var fromDate = "", toDate = "";
        fromDate = document.getElementById("txtValue0").value
        toDate = document.getElementById("txtValue1").value
        
        var gap = DateDiff(toDate, fromDate)
        if (gap > queryDateGap) {
            success = false;
            errMessage = "入院日期间隔不能超过系统指定的" + queryDateGap + "天";
        } else{
            var ReusultsCheck = CheckValue(table,fromDate,toDate,length);
			success = ReusultsCheck[0];
            errMessage = ReusultsCheck[1];
			if (success){
			    ResulstContion[2] = new Array();
                var iEnd = parseInt(gap/SelectGap);
                var TempfromDate = "";
                var i = 0;
                while(i<iEnd-1){
                   tempfromDate = fromDate;
                   fromDate = StringDateAdd(fromDate,SelectGap-1);
                   ResulstContion[2][i] = Getcondition(table,tempfromDate,fromDate,length);
                   fromDate = StringDateAdd(fromDate,1);
                   i = i + 1;
                }
                ResulstContion[2][i] = Getcondition(table,fromDate,toDate,length);
			}
       }
    }      
    ResulstContion[0] = success;
    ResulstContion[1] = errMessage;
    return ResulstContion;
}
//Desc: 验证值
//Creator: Candyxu
function CheckValue(table,TfromDate,TtoDate,length){
	var arrReusultCheck = new Array();
	var success = true;
	var errMessage = "";
	for (var i = 0; i < length; i++) {
	   //获得查询条件时若第一列复选框未选中则跳过该行 刘仲皖
	   if(!document.getElementById("checkbox" + i).checked) continue;
       var column = "";
       var row = table.dom.rows[i];
       var children = row.children;
       var txtValue = "",itemCode = "", itemType = "";
	   itemCode = document.getElementById("column" + i).getAttribute("code");
	   if (i == 0) {txtValue = TfromDate; } else if (i==1){txtValue = TtoDate;  } else {txtValue = Ext.get("txtValue" + i).getValue();}
       var label = children[1].innerText;
       if (txtValue == "" || txtValue =="请输入信息" || txtValue == "请选择日期" || txtValue == "请选择"  ) {
         success = false;
         errMessage = label + "值域不能为空!";
         break;
       }
         //转换约定的空值
         if (txtValue == "NULL") {
            txtValue = "";
         }
         if (!regSpecial(txtValue)) {
            success = false;
            errMessage = label + "中有特殊字符!";
            break;
         }
         itemType = itemCode.split("^")[3];
         if (itemType == "date" && !regDate(txtValue)) {
            success = false;
            errMessage = label + "不合法或格式不正确，必须为YYYY-MM-DD格式!";
            break;
         }
         if (itemType == "time" && !regTime(txtValue)) {
            success = false;
            errMessage = label + "不合法或格式不正确，必须为HH:MM:SS格式!";
            break;
         }
	}
    arrReusultCheck[0] = success;
    arrReusultCheck[1] = errMessage;
    return arrReusultCheck;
}

//Desc:添加高级查询条件-获得查询条件
//Creator: Candyxu
function Getcondition(table,TfromDate,TtoDate,length){ 
    var strCondition = "";    
    for (var i = 0; i < length; i++) {
	   //获得查询条件时若第一列复选框未选中则跳过该行 刘仲皖
	   if(!document.getElementById("checkbox" + i).checked) continue;
       var column = "";
       var row = table.dom.rows[i];
       var children = row.children;
       var relationCode = "", itemCode = "", opCode = "", txtValue = "", itemType = "";
	   // 由于 查询条件Table 中前两个默认的条件和后面添加的条件在格式上不是一个类型，所以在取值时应该分开对待  start
	   // edit by 牛才才
	   if (i == 0 || i ==1 ){
			relationCode = document.getElementById("relation" + i).getAttribute("code");
			opCode = document.getElementById("op" + i).getAttribute("code");
		}else if ( i > 1 ){
			relationCode = Ext.get("relation" + i).getValue();
			opCode = Ext.get("op" + i).getValue();
		}
       itemCode = document.getElementById("column" + i).getAttribute("code");

       if (i == 0) {txtValue = TfromDate; } else if (i==1){txtValue = TtoDate;  } else {txtValue = Ext.get("txtValue" + i).getValue();}
	   // 由于 查询条件Table 中前两个默认的条件和后面添加的条件在格式上不是一个类型，所以在取值时应该分开对待  end
         if (i == 0) {
            strCondition = itemCode + "$" + opCode + "$" + txtValue;
         } else if (i == 1) {
            strCondition = strCondition + relationCode + itemCode + "$" + opCode + "$" + txtValue;
         } else {
            strCondition = strCondition + relationCode + itemCode + "$" + opCode + "$" + txtValue;
         }
     }
    return strCondition 
}

//Desc: 日期增加天数
//Creator: Candyxu
function StringDateAdd(strValue,Adddata ){     
    var arr = strValue.split("-");   
    var newdt = new Date(Number(arr[0]),Number(arr[1])-1,Number(arr[2])+ Adddata);   
    repnewdt = newdt.getFullYear() + "-" +   (newdt.getMonth()+1) + "-" + newdt.getDate();   
    return repnewdt;   
}  

//Desc: 正则表达式判断是否包含特殊字符
function regSpecial(ctrlValue) {
    var reg = /[@#\$%\^&\*]+/g;
    if (reg.test(ctrlValue)) {
        return false;
    }
    return true;
}

//Desc: 正则表达式判断日期是否合法
function regDate(ctrlValue) {
    var reg = /^((((1[6-9]|[2-9]\d)\d{2})-(0?[13578]|1[02])-(0?[1-9]|[12]\d|3[01]))|(((1[6-9]|[2-9]\d)\d{2})-(0?[13456789]|1[012])-(0?[1-9]|[12]\d|30))|(((1[6-9]|[2-9]\d)\d{2})-0?2-(0?[1-9]|1\d|2[0-8]))|(((1[6-9]|[2-9]\d)(0[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00))-0?2-29))$/;
    if (reg.test(ctrlValue)) 
        return true;
    return false;
}

//Desc: 正则表达式判断时间是否合法
function regTime(ctrlValue) {
    var reg = /^([0-1][0-9]|(2[0-3])):([0-5][0-9]):([0-5][0-9])$/;
    if (reg.test(ctrlValue))
        return true;
    return false;
}

//Desc:     判断两个日期之间的间隔天数
//Params:   sDate1和sDate2是2002-12-18格式
function DateDiff(sDate1, sDate2) {               
    var aDate, oDate1, oDate2, iDays
    aDate = sDate1.split("-")
    oDate1 = new Date(aDate[1] + '-' + aDate[2] + '-' + aDate[0])               //转换为12-18-2002格式      
    aDate = sDate2.split("-")
    oDate2 = new Date(aDate[1] + '-' + aDate[2] + '-' + aDate[0])
    iDays = parseInt(Math.abs(oDate1 - oDate2) / 1000 / 60 / 60 / 24)           //把相差的毫秒数转换为天数
    if (iDays < 0) {
        return -iDays;
    } 
    return iDays
}  
	
//Desc:     判断两个日期大小关系，
//返回true：Date1晚于或等于Date2
//返回false：Date1早于Date2
//Params:   Date1和Date2是2002-12-18格式
function DateCompare(Date1, Date2) {
    var aDate, bDate
    aDate = Date1.split("-");
	bDate = Date2.split("-");
	if ((aDate[0] - bDate[0]) < 0)
	{
		return false;
	}
	else if ((aDate[0] - bDate[0]) == 0)
	{
		if ((aDate[1] - bDate[1]) < 0)
		{
			return false;
		}
		else if ((aDate[1] - bDate[1]) == 0)
		{
			if ((aDate[2] - bDate[2]) < 0)
			{
				return false;
			}
			else
			{
				return true;
			}
		}
		else
		{
			return true;
		}
	}
	else
	{
		return true;
	}

}  

//Desc: 提交高级查询
//Edit by Candyxu 2012-01-08
function commitAdvancedRequest() {
    trigger = 1;
	// modify by niucaicai 2012-10-18 增加queryType变量，判断两个默认查询条件是否成对出现；
	var queryType = "";
	var table = Ext.get("tblCondition");
    if (table) {
        var queryType0 = "",queryType1 = "";
		queryType0 = document.getElementById("column0").value.split("^")[1];
		queryType1 = document.getElementById("column1").value.split("^")[1];
		if (queryType0 == queryType1)
		{
			queryType = queryType0;
			Ext.getCmp('btnAdvancedCommit').disable();
			var arrAdvancedCondition = getAdvancedConditions();
			if (!arrAdvancedCondition[0]) {
				//alert(arrAdvancedCondition[1]);
				Ext.getCmp('btnAdvancedCommit').enable();
				return;
			} else {
				arrAdvancedCondition[3] = queryType;  //add by niucaicai 2012-10-18  将“入院日期”或者“出院日期”作为查询参数queryType来区分查询；
				var msgBox = Ext.MessageBox.show({title:'提示',modal: true,width:300,progress:true,progressText:'0%'});
				GetFind(msgBox,arrAdvancedCondition);
			}
		}
		else
		{
			alert("查询条件前两个必须成对出现！");
			return;
		}
	}
}
//Desc:提交高级查询-查询数据
//Add by Candyxu      
function GetFind(msgBox,arrAdvancedCondition){
	var ReslutFields = getResultCMAndFields("divAdvancedResultCols");
	var advancedFields = ReslutFields[0];    
	var advancedColModel = ReslutFields[1];       
	var advancedResultCols = ReslutFields[2];
	var ReslutLength = arrAdvancedCondition[2].length;
	//add by niucaicai 2012-10-18  将“入院日期”或者“出院日期”作为查询参数queryType来区分查询；
	var queryType = arrAdvancedCondition[3];
	var TempGUID = "";
	Ext.Ajax.request({ 
		url: '../web.eprajax.query.advancedquery.cls',
		params: { action: 'getGUID', hiddenGUID: Ext.get("hiddenAdvancedGUID").getValue(),canViewAllLoc:canViewAllLoc},
		success: function(response, options){
			var responseArray = Ext.util.JSON.decode(response.responseText); 
			if (responseArray.GUID != ""){
				Ext.get("hiddenAdvancedGUID").dom.value = responseArray.GUID; 
				TempGUID = responseArray.GUID;
				var k=0;       
				var curnum=0;  
				var msgtext="";
				/*
				for (var i = 0; i < ReslutLength; i++){
					Ext.Ajax.request({
						timeout: 60000,
						url: '../web.eprajax.query.advancedquery.cls',
						params: { action: 'querydata', hiddenGUID: TempGUID, conditions: arrAdvancedCondition[2][i], hiddenCols: advancedResultCols},
						callback: function(options, success, response){
						k = k + 1;
						if (k >= ReslutLength){
							GetRusultStore(TempGUID ,advancedResultCols,advancedFields,advancedColModel);
							msgBox.hide();
							}
						curnum =k/ReslutLength; 
						msgtext = Math.round(curnum*100) +"%"; 
						msgBox.updateProgress(curnum,msgtext);
						}
					})
				}
				*/
				// modify by niucaicai 2010-08-07
				QuerydataToTempGlobal(queryType,k,TempGUID,arrAdvancedCondition,advancedResultCols,ReslutLength,advancedFields,advancedColModel,msgBox,msgtext,curnum);
			}
		}
	})
}
// 将 Ext.Ajax.request 请求单独写成一个方法，可以递归调用  add by niucaicia 2012-08-07
function QuerydataToTempGlobal(queryType,k,TempGUID,arrAdvancedCondition,advancedResultCols,ReslutLength,advancedFields,advancedColModel,msgBox,msgtext,curnum){
	//alert(k);
	Ext.Ajax.request({
		timeout: 60000,
		url: '../web.eprajax.query.advancedquery.cls',
		//modify by niucaicai 2012-10-18  将“入院日期”或者“出院日期”作为查询参数queryType来区分查询；
		params: { action: 'querydata', hiddenGUID: TempGUID, conditions: arrAdvancedCondition[2][k],hiddenCols: advancedResultCols,queryType: queryType,canViewAllLoc:canViewAllLoc},
		callback: function(options, success, response){
			//response.responseText = 'WriteTempGlobalOver';
			//alert(response.responseText);
			//判断当前部分数据是否写入临时Global完毕
			if (response.responseText == 'WriteTempGlobalOver')
			{
				k = k + 1;
				if (k < ReslutLength){
					curnum =k/ReslutLength; 
					msgtext = Math.round(curnum*100) +"%"; 
					msgBox.updateProgress(curnum,msgtext);
					//当前部分数据是否写入临时Global完毕,写入下一部分
					QuerydataToTempGlobal(queryType,k,TempGUID,arrAdvancedCondition,advancedResultCols,ReslutLength,advancedFields,advancedColModel,msgBox,msgtext,curnum);
					
				}
				//全部数据写入后台临时Global完成后，开始加载数据到页面
				else{
					GetRusultStore(TempGUID ,advancedResultCols,advancedFields,advancedColModel);
					msgBox.hide();
				}
			}
			else{
				alert("新方法出错！请刷新页面重新操作！");
				return;
			}
		}
	})
}

//Desc:提交高级查询-结果store
//Add by Candyxu  
function GetRusultStore(TempGUID,advancedResultCols,advancedFields,advancedColModel){
	store = new Ext.data.JsonStore({
		autoLoad: false,
		url: '../web.eprajax.query.advancedquery.cls',
		method: 'GET',
		baseParams: { action: 'fetchdata', hiddenGUID: TempGUID, hiddenCols: advancedResultCols },
		fields: eval("[" + advancedFields + "]"),
		root: 'data',
		totalProperty: 'TotalCount'
	});
	Ext.getCmp('resultGrid').reconfigure(store, new Ext.grid.ColumnModel(eval("["+"new Ext.grid.RowNumbererA()," + advancedColModel + "]")));
	//ie11非兼容模式添加ext-ie类，使表格显示正常 刘仲皖
	if('IE11.0'==isIE()){
		Ext.getCmp('resultGrid').addClass('ext-ie');
	}
	Ext.getCmp('pagingToolbar').bind(store);

	store.on('load', function() {
		changeRowBackgroundColor(Ext.getCmp('resultGrid'));
	});

	store.load({ params: { start: 0, limit: queryPageSize} });
	Ext.getCmp('btnAdvancedCommit').enable();

}

//Desc: 获取返回结果列
function getResultCMAndFields(obj) {
    //debugger;
    var count = 0;
    var fields = "";
    var columnModel = "";
    var resultColumns = "";
    var result = [];
    var items = Ext.fly(obj).select("input[type=checkbox]", true);
    Ext.each(items.elements, function(item) {
        if (item.dom.checked) {
            if (count > 0) {
                fields = fields + ",";
                columnModel = columnModel + ",";
                resultColumns = resultColumns + "&";
            }
            var code = item.dom.value;
            var info = code.split("^");
            var catCode = info[0];
            var itemName = info[1];
            var itemCode = info[2];
            var itemTitle = info[3];
            var itemTypeCode = info[4];

            fields = fields + "{name:'" + itemName + "'}";
            columnModel = columnModel + "{header:'" + itemTitle + "',dataIndex:'" + itemName + "',width: 80,sortable:true}";
            resultColumns = resultColumns + catCode + "^" + itemName + "^" + itemCode + "^" + itemTypeCode;

            count = count + 1;
        }
    });
    result[0] = fields;
    result[1] = columnModel;
    result[2] = resultColumns;
    return result;
}
// 保存方案弹出框中 添加可见科室
// edit by 牛才才
function addCtLocBtnClick(){
	var selections = Ext.getCmp('CTLocGrid').getSelectionModel().getSelections();
	if (selections.length == 0) {
			alert("请选择要添加的科室!");
			return;
	}
	else{
		for (var i=0; i<selections.length; i++)
		{
			var record = selections[i];
			var ID=record.get("ID");
			var Name=record.get("Name");
			var existed = false;
			for (var j = 0;j<Ext.getCmp('CTLocCRPanelGrid').store.getCount();j++ )
			{
				var existedID = Ext.getCmp('CTLocCRPanelGrid').store.getAt(j).get("ID");
				if (existedID == ID)
				{
					existed = true;
					alert(Name+' 已存在！');
					break;
				}
			}
			if (existed==false)
			{
				Ext.getCmp('CTLocCRPanelGrid').store.loadData([{ID:ID,Name:Name}],true);
			}
		}
	}
}
// 保存方案弹出框中 删除可见科室
// edit by 牛才才
function deleteCtLocBtnClick(){
	var selections = Ext.getCmp('CTLocCRPanelGrid').getSelectionModel().getSelections();
	if (selections.length == 0) {
			alert("请选择要删除的科室!");
			return;
	}
	else{
		for (var i=0; i<selections.length; i++)
		{
			var record = selections[i];
			Ext.getCmp('CTLocCRPanelGrid').store.remove(record);
		}
	}
}
// 保存方案弹出框中 添加可见安全组
// edit by 牛才才
function addGroupBtnClick(){
	var selections = Ext.getCmp('GroupGrid').getSelectionModel().getSelections();
	if (selections.length == 0) {
			alert("请选择要添加的安全组!");
			return;
	}
	else{
		for (var i=0; i<selections.length; i++)
		{
			var record = selections[i];
			var ID=record.get("ID");
			var Desc=record.get("Desc");
			var existed = false;
			for (var j = 0;j<Ext.getCmp('GroupCRPanelGrid').store.getCount();j++ )
			{
				var existedID = Ext.getCmp('GroupCRPanelGrid').store.getAt(j).get("ID");
				if (existedID == ID)
				{
					existed = true;
					alert(Desc+' 已存在！');
					break;
				}
			}
			if (existed==false)
			{
				Ext.getCmp('GroupCRPanelGrid').store.loadData([{ID:ID,Desc:Desc}],true);
			}
		}
	}
}
// 保存方案弹出框中 删除可见安全组
// edit by 牛才才
function deleteGroupBtnClick(){
	var selections = Ext.getCmp('GroupCRPanelGrid').getSelectionModel().getSelections();
	if (selections.length == 0) {
			alert("请选择要删除的安全组!");
			return;
	}
	else{
		for (var i=0; i<selections.length; i++)
		{
			var record = selections[i];
			Ext.getCmp('GroupCRPanelGrid').store.remove(record);
		}
	}
}

// 构造将要 保存/修改后保存 的查询方案
// edit by 牛才才
function buildQueryCase(caseSaveWin,saveType)
{
	//检测方案名称是否合法 start
	var QueryCaseName = Ext.getCmp('caseNameField').getRawValue();
	if (QueryCaseName == '')
	{
		alert("方案名称不能为空！");
		return;
	}
	else if (QueryCaseName.indexOf("@") != -1 || QueryCaseName.indexOf("#") != -1 || QueryCaseName.indexOf("$") != -1 || QueryCaseName.indexOf("%") != -1 || QueryCaseName.indexOf("^") != -1 || QueryCaseName.indexOf("&") != -1 || QueryCaseName.indexOf("*") != -1 || QueryCaseName.indexOf(",") != -1 || QueryCaseName.indexOf("，") != -1 )
	{
		alert("含有非法字符，请重新输入！");
		return;
	}
	
	//检测方案名称是否合法 end

	//搜集查询条件 start
	var table = Ext.get("tblCondition");
	if (table) {
		var length = table.dom.rows.length;
		var ConditionArr = new Array();
		//for (var i = 2,j = 0; i < length ; i++,j++) {
		for (var i = 0,j = 0; i < length ; i++,j++) {
			ConditionArr[j] = new Array();
			var row = table.dom.rows[i];
			var children = row.children;
			var ORCode = "",ORName = "", ItemCode = "",ItemName = "", OPCode = "", OPName = "", txtValue = "", checkboxCode = "";
			checkboxCode = document.getElementById("checkbox" + i).checked;
			if (checkboxCode == true)
			{
				ORCode = Ext.get("relation" + i).getValue();
				//add by niucaicai 2012-10-19 获取前两行的ItemCode、ItemName方式和后续其他行的获取方式不一样，故增加判断方法；
				if (i<2)
				{
					ItemCode = Ext.get("column" + i).getValue();
					if (ItemCode == "EPR^AdmDate^AdmDate^date^1")
					{
						ItemName = "入院日期";
					}
					else if (ItemCode == "EPR^DischDate^DischDate^date^1")
					{
						ItemName = "出院日期";
					}
				}
				else 
				{
					ItemCode = document.getElementById("column" + i).getAttribute("code");
					ItemName = document.getElementById("column" + i).innerText;
				}
				OPCode = Ext.get("op" + i).getValue();
				txtValue = Ext.get("txtValue" + i).getValue();
				if ( txtValue.indexOf(",") != -1 || txtValue.indexOf("，") != -1 )
				{
					alert("查询条件 " + ItemName + " 中不能含有逗号！");
					return;
				}
				ConditionArr[j][0] = ORCode;
				ConditionArr[j][1] = ItemCode;
				ConditionArr[j][2] = ItemName;
				ConditionArr[j][3] = OPCode;
				ConditionArr[j][4] = txtValue;
			}
		}
		var dataCondition = escape(ConditionArr);
	}
	//搜集查询条件 end

	//搜集结果列 start
	var divAdvancedResultCols = Ext.get('divAdvancedResultCols');
	if (divAdvancedResultCols) {
		var items = Ext.fly("divAdvancedResultCols").select("input[type=checkbox]", true);
		var k = 0;
		var UnDisabledCount = 0;
		var ResultColsArr = new Array();
		Ext.each(items.elements, function(item) {
			if (item.dom.checked) {
				if (item.dom.disabled)
				{
					var IsDisabled = 'Y';
					var ResultColsName = item.dom.nextSibling.innerText;
					var ResultColsCode = item.dom.value;
				}
				else if (!item.dom.disabled)
				{
					var IsDisabled = 'N';
					var ResultColsName = item.dom.nextSibling.innerText;
					var ResultColsCode = item.dom.value;
					UnDisabledCount = UnDisabledCount + 1;
				}
				ResultColsArr[k] = new Array();
				ResultColsArr[k][0] = IsDisabled;
				ResultColsArr[k][1] = ResultColsName;
				ResultColsArr[k][2] = ResultColsCode;
				k = k+1;
			}
		});
		var dataResultCols = escape(ResultColsArr);
	}
	//搜集结果列 end
	
	//得到可见科室Code start
	var CanReadCTLocNum = Ext.getCmp('CTLocCRPanelGrid').store.getCount();
	var CTLocIDStr = '';
	for (var t = 0; t< CanReadCTLocNum; t++)
	{
		var ID = Ext.getCmp('CTLocCRPanelGrid').store.getAt(t).get("ID");
		if (t == 0)
		{
			CTLocIDStr = ID;
		}
		else if (t > 0)
		{
			CTLocIDStr = CTLocIDStr + '^' + ID;
		}
	}
	//得到可见科室Code end
	//得到可见安全组Code start
	var CanReadGroupNum = Ext.getCmp('GroupCRPanelGrid').store.getCount();
	var GroupIDStr = '';
	for (var p = 0; p< CanReadGroupNum; p++)
	{
		var ID = Ext.getCmp('GroupCRPanelGrid').store.getAt(p).get("ID");
		if (p == 0)
		{
			GroupIDStr = ID;
		}
		else if (p > 0)
		{
			GroupIDStr = GroupIDStr + '^' + ID;
		}
	}
	//得到可见安全组Code end
	//保存方案 start
	//{
	if (saveType == 'save')
	{
		Ext.Ajax.request({
			url: '../web.eprajax.query.savequerycase.cls',
			params: { action: 'SaveCase', SaveUserID: userID, SaveUserName: userName, CTLocIDStr: CTLocIDStr, GroupIDStr: GroupIDStr, QueryCaseName: QueryCaseName, ConditionArr: dataCondition, ResultColsArr: dataResultCols},
			success: function(response, options){
				var ret = response.responseText;
				if (ret == -2)
				{
					alert("名称已存在，请重新输入！");
					return;
				}
				else if (ret == -1)
				{
					alert("保存失败！");
					return;
				}
				else if (ret > 0)
				{
					caseSaveWin.close();
					alert("保存成功！");
					var queryType = Ext.getCmp('queryCaseTabPanel').getActiveTab().getId();
					loadCaseName(queryType);
				}
			} 
		})
	}
	else if (saveType == 'modify')
	{
		var caseID = tempStore.getAt(0).get("ID");
		Ext.Ajax.request({
			url: '../web.eprajax.query.savequerycase.cls',
			params: { action: 'ModifyCase', CaseID:caseID, SaveUserID: userID, SaveUserName: userName, CTLocIDStr: CTLocIDStr, GroupIDStr: GroupIDStr, QueryCaseName: QueryCaseName, ConditionArr: dataCondition, ResultColsArr: dataResultCols},
			success: function(response, options){
				var ret = response.responseText;
				if (ret == -2)
				{
					alert("名称已存在，请重新输入！");
					return;
				}
				else if (ret == -1)
				{
					alert("修改失败！");
					return;
				}
				else if (ret > 0)
				{
					caseSaveWin.close();
					alert("修改成功！");
					var queryType = Ext.getCmp('queryCaseTabPanel').getActiveTab().getId();
					loadCaseName(queryType);
				}
			} 
		})
		tempStore.loadData([{ID:caseID,Desc:QueryCaseName,SaveUserID:userID,SaveUserName:userName}]);	     //修改完毕后，更新全局的临时Store ，目前作用为：记录最新的方案，为“修改方案”提供信息
	}
	//保存方案 end
}

//加载“查询方案设置”中的Grid
//edit by 牛才才
function loadCaseName(queryType){
	if (queryType=='readCaseByUserID')
	{
		var QueryAreaStr = "userID" + "^" + userID;
	}
	else if (queryType=='readCaseByCtLocID')
	{
		var QueryAreaStr = "ctLocID" + "^" + ctLocID;
	}
	else if (queryType=='readCaseByGroupID')
	{
		var QueryAreaStr = "groupID" + "^" + ssGroupID;
	}
	//var dataQueryAreaStr = escape(QueryAreaStr);                         //若有特殊符号及汉字，应先编码后再作为参数传入
	readCaseStore.baseParams = { action: 'getCaseName', QueryAreaStr: QueryAreaStr, desc: Ext.getCmp("putinText").getRawValue()};
	readCaseStore.reload({});
}

//读取已有查询方案到页面
//edit by 牛才才
function readQueryCase(){
	var ReadCaseGrid = Ext.getCmp('ReadCaseGrid');
	if (ReadCaseGrid.getSelectionModel().getSelected()){
		var caseID=ReadCaseGrid.getSelectionModel().getSelected().get('ID');
		var caseDesc=ReadCaseGrid.getSelectionModel().getSelected().get('Desc');
		var SaveUserID=ReadCaseGrid.getSelectionModel().getSelected().get('SaveUserID');
		var SaveUserName=ReadCaseGrid.getSelectionModel().getSelected().get('SaveUserName');
		tempStore.loadData([{ID:caseID,Desc:caseDesc,SaveUserID:SaveUserID,SaveUserName:SaveUserName}]);		// 记录当前添加的方案，为“修改方案”提供信息
		Ext.Ajax.request({
			url: '../web.eprajax.query.getquerycase.cls',
			method: 'POST',
			params: { action: 'getCaseConditionInfo', CaseID: caseID },
			success: function(response, options){
				// 读取成功后，删除页面当前显示的查询条件，添加读取到的查询条件
				var table = Ext.get("tblCondition");
				if (table) {
					var length = table.dom.rows.length;
					for (var x = 0; x < length; x++) {
						table.dom.deleteRow(0);
					}
				}
				var conditionStr = response.responseText;
				var conditionNum = conditionStr.split(",")[0];
				var i=1,j=2,k=3,m=4,n=5;
				for (i=1; i<=conditionNum;i=i+5)
				{
					// 读取第一个和第二个查询条件（入院起始日期和入院结束日期）
					if (i==1 || i==6)
					{
						var setItemCode = conditionStr.split(",")[j];
						var setItemName = conditionStr.split(",")[k];
						var settxtValue = conditionStr.split(",")[n];

						var scheme = '<td width="7%" class="checkbox"><input type="checkbox" name="checkbox" id="{checkboxId}" value="{idList}" checked="true" disabled>{checkbox}</td>';
						var scheme = scheme + '<td class="relation"><label id="{relationId}" code="{relationCode}" style="white-space:nowrap;">{relation}</label></td>';
						//将colname这一列设为可选的  modify by niucaicai 2012-10-19
						//var scheme = scheme + '<td class="colname"><label id="{columnId}" code="{columnCode}" style="white-space:nowrap;">{col}</label></td>';
						var scheme = scheme + '<td class="colname"><select id="{columnId}" code="'+ setItemCode +'" style="white-space:nowrap;">'+ setItemName +'<OPTION VALUE= "' + "EPR^AdmDate^AdmDate^date^1" + '" >' + "入院日期" + '<OPTION VALUE= "' + "EPR^DischDate^DischDate^date^1" + '">' + "出院日期"+ '</select></td>';
						var scheme = scheme + '<td class="op"><label id="{opId}" code="{opCode}" style="white-space:nowrap;">{op}</label></td>';
						var scheme = scheme + '<td class="value"><input type="text" id="{txtValue}" value=' + settxtValue + ' /></td>';
						var trTemplate = Ext.DomHelper.createTemplate({ tag: 'tr', html: scheme });
						if (i==1)
						{
							trTemplate.append("tblCondition", { checkboxId: 'checkbox0', relationId: 'relation0', relationCode: '', relation: "", columnId: 'column0', opId: 'op0', opCode: '>', op: '大于', txtValue: 'txtValue0' });
							document.getElementById("column0").value = setItemCode;
							showDate("txtValue0");
						}
						else if (i==6)
						{
							trTemplate.append("tblCondition", { checkboxId: 'checkbox1', relationId: 'relation1', relationCode: '&&&', relation: "并且", columnId: 'column1', opId: 'op1', opCode: '<', op: '小于', txtValue: 'txtValue1' });
							document.getElementById("column1").value = setItemCode;
							showDate("txtValue1");
						}
					}
					else if (i>10)
					{
						var setORCode = conditionStr.split(",")[i];
						var setItemCode = conditionStr.split(",")[j];
						var setItemName = conditionStr.split(",")[k];
						var setOPCode = conditionStr.split(",")[m];
						var settxtValue = conditionStr.split(",")[n];
						resetConditions(setItemCode,setItemName,setOPCode,settxtValue,setORCode);
					}
					j=j+5,k=k+5,m=m+5,n=n+5;
				}
			}
		});
		Ext.Ajax.request({
			url: '../web.eprajax.query.getquerycase.cls',
			method: 'POST',
			params: { action: 'getCaseResultColsInfo', CaseID: caseID },
			success: function(response, options){
				// 读取成功后，删除页面当前显示的结果列，添加读取到的结果列
				var divAdvancedResultCols = Ext.get('divAdvancedResultCols');
				divAdvancedResultCols.dom.innerHTML = "";
				var ResultColsStr = response.responseText;
				var ResultColsNum = ResultColsStr.split(",")[0];
				var i=1,j=2,k=3;
				for (i=1; i<=ResultColsNum;i=i+3)
				{
					var IsDisabled = ResultColsStr.split(",")[i];
					var ColsName = ResultColsStr.split(",")[j];
					var ColsCode = ResultColsStr.split(",")[k];
					if (IsDisabled=='Y')
					{
						var checkboxModule = new Ext.form.Checkbox({
							name: "chkItems",
							boxLabel: ColsName,
							labelSeparator: "",
							inputValue: ColsCode,
							checked: true,
							disabled: true,
							renderTo: divAdvancedResultCols                 //此种方式 IE8 能显示，IE6 能显示
						});
						//}).render(divAdvancedResultCols);                 //此种方式 IE8 能显示，IE6 不能显示，报错“运行时间错误、缺少对象”等等
					}
					else if (IsDisabled=='N')
					{
						var checkboxModule = new Ext.form.Checkbox({
							name: "chkItems",
							boxLabel: ColsName,
							labelSeparator: "",
							inputValue: ColsCode,
							checked: true,
							renderTo: divAdvancedResultCols
						});
						//}).render(divAdvancedResultCols);
					}
					j=j+3,k=k+3;
				}
			}
		});
	}
	else
	{
		alert("请选择要读取的方案！");
		return;
	}
}

//删除查询方案
//edit by 牛才才
function deleteQueryCase(){
	if (ReadCaseGrid.getSelectionModel().getSelected())
	{
		var SaveUserID=ReadCaseGrid.getSelectionModel().getSelected().get('SaveUserID');
		if (userID == SaveUserID)
		{
			Ext.MessageBox.confirm('提示', '确定要删除这条项目?', function(btn,text){
			if(btn=="yes"){
					try{
						var DeleteCaseID=ReadCaseGrid.getSelectionModel().getSelected().get('ID');
						Ext.Ajax.request({
							url: '../web.eprajax.query.getquerycase.cls',
							method: 'POST',
							params: { action: 'DeleteCase', DeleteCaseID: DeleteCaseID },
							success: function(response, options){
								var ret = response.responseText;
								if (ret == 0)
								{
									alert("删除成功！");
									// 删除成功后重新加载方案列表
									var queryType = Ext.getCmp('queryCaseTabPanel').getActiveTab().getId();
									loadCaseName(queryType);
								}
							}
						});
					}catch(err){
						Ext.MessageBox.alert('报错', '删除操作出现错误！', Ext.MessageBox.ERROR);
					}
					return;
				}
			});
		}
		else
		{
			alert("您不是该方案的保存者，不能删除此方案！");
			return;
		}
	}
	else
	{
		alert("请选择要删除的方案！");
		return;
	}
}

//对病历版本进行判断
function GetEPRorEMR(grid, rowindex, e, type)
{
	var record = grid.getStore().getAt(rowindex);
    var episodeID = record.get("EpisodeID");
	var admType = record.get("AdmType");

	Ext.Ajax.request({
		url: '../web.eprajax.query.getEPRorEMRInfo.cls',
		method: 'POST',
		params: { Action: 'getEPRorEMRByEID', EpisodeID: episodeID },
		success: function (response,options){
			var DHCEMR = response.responseText;
			if (type == "Write")
			{
				goEPRWrite(episodeID,admType,DHCEMR);
			}
			else if (type == "Browse")
			{
				goEPRBrowse(episodeID,admType,DHCEMR);
			}
			else if (type == "Print")
			{
				goEPROnePrint(episodeID,admType,DHCEMR);
			}
			else if (type == "CentralizedPrint")
			{
				goEPRCentralizedPrint(episodeID,admType,DHCEMR);
			}
		
		},
		failure : function (response,options){
			alert("请求数据报错,请重试！");
		}
	});
}

//Desc: 弹出病历书写
function goEPRWrite(episodeID,admType,DHCEMR) {
    //debugger;
    //var record = grid.getStore().getAt(rowindex);
    //var episodeID = record.get("EpisodeID");
	//var admType = record.get("AdmType");
    
    if (admType == "I") {
		//对病历版本进行判断，调用不同的病历书写页面；
		var html = '<iframe id="eprWrite" scrolling="no" frameborder="0"  style="width:100%; height:100%;" src="dhceprredirect.csp?EpisodeID=' + episodeID + '"></iframe>';
		if (DHCEMR == 1)
		{
			var PatientID = "";
			Ext.Ajax.request({
				url: '../web.eprajax.query.getEPRorEMRInfo.cls',
				method: 'POST',
				params: { Action: 'getPatientIDByEID', EpisodeID: episodeID },
				success: function(response, options){
					var ret = response.responseText;
					PatientID = ret;
				}
			});
			html = '<iframe id="eprWrite" scrolling="no" frameborder="0"  style="width:100%; height:100%;" src="emr.record.csp?EpisodeID=' + episodeID + '&PatientID=' + PatientID + '"></iframe>';
		}

        var win = new Ext.Window({
            id: 'winWrite',
            layout: 'fit', 	//自动适应Window大小 
            title: '电子病历书写',
            //broder: false,
            frame: true,
            width: 1200,
            height: 640,
            shim: false,
            //closeAction:'hide',    
            animCollapse: false,
            constrainHeader: true,
            resizable: true,
            modal: true,
            maximizable: true,
            raggable: true, //不可拖动
            items: [
		        {
		            //border: false, 
		            html: html
		        }
	        ]
	        /*
	        bbar: ["->", {
	            text: '关闭',
	            cls: 'x-btn-text-icon',
	            icon: '../scripts/epr/Pics/btnClose.gif',
	            pressed: false,
	            handler: function(win) {
	                var curWindow = Ext.getCmp("winWrite");
	                if (curWindow) {
	                    curWindow.close();
	                }
	            }
            }]
            */
        });
        win.show();
    }
}

//Desc: 弹出病历浏览
function goEPRBrowse(episodeID,admType,DHCEMR) {
	if (admType == "I"||admType == "O") {
		//对病历版本进行判断，调用不同的病历书写页面；
		var src = "epr.newfw.episodelistbrowser.csp";
		if (DHCEMR == 1)
		{
			src = "emr.interface.browse.episode.csp";
		}

        var win = new Ext.Window({
            id: 'winBrowse',
            layout: 'fit', 	//自动适应Window大小 
            title: '电子病历浏览',
            //broder: false,
            frame: true,
            width: 1200,
            height: 640,
            shim: false,
            //closeAction:'hide',    
            animCollapse: false,
            constrainHeader: true,
            resizable: true,
            modal: true,
            maximizable: true,
            raggable: true, //不可拖动
            items: [
		        {
		            //border: false,
		            //html: '<iframe id="eprWrite" scrolling="no" frameborder="0" style="width:100%; height:100%;" src="epr.newfw.episodelistbrowser.csp?EpisodeID=' + episodeID + '"></iframe>'
					html: '<iframe id="eprWrite" scrolling="no" frameborder="0" style="width:100%; height:100%;" src="'+ src +'?EpisodeID=' + episodeID + '"></iframe>'
		        }
	        ]
	        /*
	        bbar: ["->", {
	            text: '关闭',
	            cls: 'x-btn-text-icon',
	            icon: '../scripts/epr/Pics/btnClose.gif',
	            pressed: false,
	            handler: function(win) {
	                var curWindow = Ext.getCmp("winBrowse");
	                if (curWindow) {
	                    curWindow.close();
	                }
	            }
            }]
            */
        });
        win.show();
		win.maximize();
    }
}

//Desc: 弹出病历一键打印
function goEPROnePrint(episodeID,admType,DHCEMR) {
	//对病历版本进行判断，调用不同的病历书写页面；
	if (DHCEMR == 1)
	{
		alert("此就诊未写病历,或者是已写三版病历,暂不支持一键打印！");
		return;
	}

    if (admType == "I") {
        var win = new Ext.Window({
            id: 'winOnePrint',
            layout: 'fit', 	//自动适应Window大小 
            title: '电子病历一键打印',
            //broder: false,
            frame: true,
            width: 1200,
            height: 640,
            shim: false,
            //closeAction:'hide',    
            animCollapse: false,
            constrainHeader: true,
            resizable: true,
            modal: true,
            maximizable: true,
            raggable: true, //不可拖动
            items: [
		        {
		            //border: false,
		            html: '<iframe id="eprWrite" scrolling="no" frameborder="0" style="width:100%; height:100%;" src="dhc.epr.onestepprint.csp?EpisodeID=' + episodeID + '"></iframe>'
		        }
	        ]
            /*
            bbar: ["->", {
            text: '关闭',
            cls: 'x-btn-text-icon',
            icon: '../scripts/epr/Pics/btnClose.gif',
            pressed: false,
            handler: function(win) {
            var curWindow = Ext.getCmp("winOnePrint");
            if (curWindow) {
            curWindow.close();
            }
            }
            }]
            */
        });
        win.show();
    }
}

//Desc: 弹出病历集中打印
//add by yang 2012-10-24
function goEPRCentralizedPrint(episodeID,admType,DHCEMR) {
	//对病历版本进行判断，调用不同的病历书写页面；
	if (DHCEMR == 1)
	{
		alert("此就诊未写病历,或者是已写三版病历,暂不支持集中打印！");
		return;
	}

    if (admType == "I") {
        var win = new Ext.Window({
            id: 'winCentralizedPrint',
            layout: 'fit', 	//自动适应Window大小 
            title: '电子病历集中打印',
            //broder: false,
            frame: true,
            width: 1200,
            height: 640,
            shim: false,
            //closeAction:'hide',    
            animCollapse: false,
            constrainHeader: true,
            resizable: true,
            modal: true,
            maximizable: true,
            raggable: true, //不可拖动
            items: [
		        {
		            //border: false,
		            html: '<iframe id="eprCentralizedPrint" scrolling="no" frameborder="0" style="width:100%; height:100%;" src="dhc.epr.centralizedprintiframe.csp?EpisodeID=' + episodeID + '"></iframe>'
		        }
	        ]
            /*
            bbar: ["->", {
            text: '关闭',
            cls: 'x-btn-text-icon',
            icon: '../scripts/epr/Pics/btnClose.gif',
            pressed: false,
            handler: function(win) {
            var curWindow = Ext.getCmp("winOnePrint");
            if (curWindow) {
            curWindow.close();
            }
            }
            }]
            */
        });
        win.show();
    }
}

//Desc: 导出查询结果(Flag 为1时导出当前页，否则导出全部)
//Edit by Candyxu  
function doExport(grid,Flag) {
    try {
        //debugger;
		var store = grid.getStore();
   		var recordCount = store.getCount();
   		if (recordCount == 0)
   		{
	   		alert("没有数据，不能执行导出操作！");
	   		return;
	   	}
	   	
        var xls = new ActiveXObject("Excel.Application");
        xls.visible = true; //设置excel为可见    
        var xlBook = xls.Workbooks.Add;
        var xlSheet = xlBook.Worksheets(1);
        xlSheet.name = grid.title;
        var cm = grid.getColumnModel();
        var colCount = cm.getColumnCount();
        var temp_obj = [];
        //只下载没有隐藏的列(isHidden()为true表示隐藏,其他都为显示)    
        //临时数组,存放所有当前显示列的下标    
        for (i = 0; i < colCount; i++) {
            if (cm.getColumnHeader(i) == "" || cm.isHidden(i) == true) {   
                //不下载CheckBox列和隐藏列  
            } else {
                temp_obj.push(i);
            }
        }
        for (i = 1; i <= temp_obj.length; i++) {
            //显示列的列标题    
            xlSheet.Cells(1, i).Value = cm.getColumnHeader(temp_obj[i - 1]);
            xlSheet.Cells(1, i).Interior.ColorIndex = 15;
            xlSheet.Cells(1, i).Font.Bold = true;
            //设置导出的列格式，解决字符串在导出到excel中变成数值型    
            var fld = grid.getStore().recordType.prototype.fields.get(cm.getDataIndex(i));
            if (fld.type == "auto") {
                xlSheet.Columns(i).NumberFormatLocal = "@";
            }
        }
		
        if(Flag == 1){ 
			ExportCurrentPage(grid,xlSheet,temp_obj,xlBook,xls) 
		}
        else{ 
			var k=0;
			//屏蔽导出过程中可能引起 grid 变化的按钮（简单、高级查询的“提交查询”、“添加结果列”、“结果列重置”按钮）
			Ext.getCmp("btnCommit").disabled = true;
			Ext.getCmp("btnSimpleColReset").disabled = true;
			Ext.getCmp("btnAddSimpleCol").disabled = true;
			Ext.getCmp("btnAdvancedCommit").disabled = true;
			Ext.getCmp("btnAdvancedColReset").disabled = true;
			Ext.getCmp("btnAddAdvancedCol").disabled = true; 
			ExportAllPage(grid,xlSheet,temp_obj,xlBook,xls,k) 
		}
		
    } catch (e) {
        //alert("要打印该表，您必须安装Excel电子表格软件，同时浏览器须使用“ActiveX 控件”，您的浏览器须允许执行控件。 请点击【帮助】了解浏览器设置方法！");
        Ext.Msg.show({
            title: '提示',
            msg: '请设置IE的菜单\'工具\'->Internet选项->安全->自定义级别->\'对没有标记为可安全执行脚本ActiveX控件初始化并执行脚本\'->选择[启用]&nbsp;&nbsp;就可以生成Excel',
            buttons: Ext.Msg.OK,
            icon: Ext.Msg.INFO
        });
    }
}
//Desc:导出当前页
//add by Candyxu
function ExportCurrentPage(grid,xlSheet,temp_obj,xlBook,xls){
   var store = grid.getStore();
   var recordCount = store.getCount();
   if (recordCount > 0) {
      var view = grid.getView();
      for (i = 1; i <= recordCount; i++) {
          for (j = 1; j <= temp_obj.length; j++)  { 
			  xlSheet.Cells(i + 1, j).Value = view.getCell(i - 1, temp_obj[j - 1]).innerText;
		  }
      }
   }
   xlSheet.Columns.AutoFit;
   xls.ActiveWindow.Zoom = 100;
   xls.UserControl = true; //很重要,不能省略,不然会出问题 意思是excel交由用户控制
   xls = null;
   xlBook = null;
   xlSheet = null;
}
/*
//Desc:导出所有
//add by Candyxu
function ExportAllPage(grid,xlSheet,temp_obj,xlBook,xls){
   var gstore = grid.getStore();
   var storeAll = new Ext.data.JsonStore({
       autoLoad: true,
       url: gstore.url,                                   //'../web.eprajax.query.advancedquery.cls',
       baseParams: { action: 'ForExcell',hiddenGUID: gstore.baseParams.hiddenGUID,hiddenCols: gstore.baseParams.hiddenCols },
       fields: gstore.reader.meta.fields,     
       root: 'data'     
   })
   storeAll.on("load",function(store, records, options){
       var recordCount = store.getCount();
       if (recordCount > 0) {
          for (i = 1; i <= recordCount; i++){
             for (j = 1; j <= temp_obj.length; j++){xlSheet.Cells(i + 1, j).Value = store.getAt(i-1).get(store.fields.keys[j-1])}
          }
       }
       xlSheet.Columns.AutoFit;
       xls.ActiveWindow.Zoom = 100;
       xls.UserControl = true; //很重要,不能省略,不然会出问题 意思是excel交由用户控制
       xls = null;
       xlBook = null;
       xlSheet = null;
   })
}
*/

//Desc:导出所有，实现按页动态导出数据
//add by niucaicai
function ExportAllPage(grid,xlSheet,temp_obj,xlBook,xls,k){
	var gstore = grid.getStore();
	gstore.load({ 
		//分页加载数据
		params: { start: k*25, limit: queryPageSize},
		callback:function(r,options,success){
			var recordCount = gstore.getCount();
			//判断当前页是否有数据，若有则导出，并进行下一页；若无则说明最后一页已经导出完毕，返回第一页数据；
			if (recordCount==0)
			{
				//恢复导出过程中被屏蔽掉的按钮（简单、高级查询的“提交查询”、“添加结果列”、“结果列重置”按钮）
				Ext.getCmp("btnCommit").disabled = false;
				Ext.getCmp("btnSimpleColReset").disabled = false;
				Ext.getCmp("btnAddSimpleCol").disabled = false;
				Ext.getCmp("btnAdvancedCommit").disabled = false;
				Ext.getCmp("btnAdvancedColReset").disabled = false;
				Ext.getCmp("btnAddAdvancedCol").disabled = false;
				gstore.load({ params: { start: 0, limit: queryPageSize} });
				return;
			}
			else 
			{
				var view = grid.getView();
				for (i = 1+k*25,n=1; i <= k*25+recordCount,n<=recordCount; i++,n++) {
					for (j = 1; j <= temp_obj.length; j++) { 
						xlSheet.Cells(i + 1, j).Value = view.getCell(n - 1, temp_obj[j - 1]).innerText;
					}
				}
				k=k+1;
				//递归调用方法本身，进行下一页数据的导出
				ExportAllPage(grid,xlSheet,temp_obj,xlBook,xls,k);
				xlSheet.Columns.AutoFit;
				xls.ActiveWindow.Zoom = 100;
				xls.UserControl = true; //很重要,不能省略,不然会出问题 意思是excel交由用户控制
				xls = null;
				xlBook = null;
				xlSheet = null;	
			}
		},
		scope:gstore
	});
}
//add by cyy 2013-4-18
function EnterEvent(){
	var m_RegNoLength=10
	//var obj=document.getElementById('txtRegNo');
	/*
	if (obj.value!='') 
	{
		if ((obj.value.length<m_RegNoLength)&&(m_RegNoLength!=0)) 
		{
			for (var i=(m_RegNoLength-obj.value.length-1); i>=0; i--)
			{
				obj.value="0"+obj.value;
			}
		}
	}
	*/
	//modify by niucaicai 2013-12-13,2014-01-03
	//回车支持登记号自动补零和回车查询；
	var txtRegNoString = Ext.getCmp('txtRegNo').getRawValue();
	var obj=document.getElementById('txtRegNo');
	
	if ((txtRegNoString!='') && (txtRegNoString.length<m_RegNoLength) && (m_RegNoLength!=0)) 
	{
		for (var i=(m_RegNoLength-txtRegNoString.length-1); i>=0; i--)
		{
			obj.value="0"+obj.value;
		}
	}
	else
	{
		var btnobj=document.getElementById('btnCommit');
		btnobj.click();
	}
}


function changeRowBackgroundColor(grid) {
    var store = grid.getStore(grid);
    var total = store.getCount();
    for (var i = 0; i < total; i++) {
        var AdmType = store.getAt(i).data['AdmType'];
        if ("I" == AdmType) {
            grid.getView().getCell(i, 1).style.backgroundColor = "#00ff00";
        }
    }
}

// 简单查询
function SimpleCommit()
{
	var thisForm = frmSimple.getForm();
	if (thisForm.isValid()) {
		trigger = 0;
		
		//得到结果列，赋给hiddenCols
		var ResultField = getResultCMAndFields("divSimpleResultCols"); 
		var simpleFields = ResultField[0];
		var simpleColModel = ResultField[1];
		var simpleResultCols = ResultField[2];
		Ext.getCmp('hiddenCols').setValue(simpleResultCols);
		var submitValues = thisForm.getValues();
		//判断submitValues中的各个Field是否为空
		for (var param in submitValues) {
			if (thisForm.findField(param) && thisForm.findField(param).emptyText == submitValues[param]) {
				submitValues[param] = '';
			}
			if (Ext.getCmp("cbxLoc").getRawValue()=='')
			{
				submitValues["locID"] = '';
			}
			if (Ext.getCmp("cbxWard").getRawValue()=='')
			{
				submitValues["wardID"] = '';
			}
		}
		//在submitValues的最后加上一个 Field，名为action，值为querydata
		submitValues["action"] = "querydata";
		submitValues["canViewAllLoc"] = canViewAllLoc;
		//如果是按照号串查询，将号串的值赋给submitValues 里面相应的字段
		if (Ext.getCmp('SimpleConditionTab').getActiveTab().id == 'SimpleNoStr')
		{
			submitValues["txtPatientName"] = '';
			submitValues["txtRegNo"] = '';
			submitValues["MedicareNo"] = '';
			submitValues["txtEpisodeNo"] = '';
			submitValues["txtDiagnose"] = '';
			submitValues["dtAdmBeginDate"] = '';
			submitValues["dtAdmEndDate"] = '';
			submitValues["dtDisBeginDate"] = '';
			submitValues["dtDisEndDate"] = '';
			submitValues["cbxRegType"] = '';
			submitValues["locID"] = '';
			submitValues["wardID"] = '';

			var EpisodeNoStr = Ext.getCmp('NoStrEpisodeNoStrArea').getValue();
			if (EpisodeNoStr == "" || EpisodeNoStr == undefined)
			{
				alert("号串内容不能为空！");
				return;
			}

			var NoStrcbxNoType = Ext.getCmp('NoStrcbxNoType').getValue();
			if (NoStrcbxNoType == "" || NoStrcbxNoType == undefined)
			{
				alert("号串类型不能为空！");
				return;
			}

			if (NoStrcbxNoType == "admNo")
			{
				submitValues["txtEpisodeNo"] = EpisodeNoStr;
			}
			else if (NoStrcbxNoType == "patNo")
			{
				submitValues["txtRegNo"] = EpisodeNoStr;
			}
			else if (NoStrcbxNoType == "medNo")
			{
				submitValues["MedicareNo"] = EpisodeNoStr;
			}
			
			Ext.getCmp('NoStrbtnCommit').disable();   //将按钮置为无效
		}
		else if (Ext.getCmp('SimpleConditionTab').getActiveTab().id == 'SimpleCondition')
		{
			Ext.getCmp('btnCommit').disable();   //将按钮置为无效
		}
		//检验submitValues中的值是否合法
		var customValidInfo = validateSimpleRequest(submitValues);
		var isCustomValid = customValidInfo[0];
		if (!isCustomValid) {
			alert(customValidInfo[1]);
			Ext.getCmp('btnCommit').enable();
			Ext.getCmp('NoStrbtnCommit').enable();
			return;
		}
		thisForm.submit({
			url: '../web.eprajax.query.basicquery.cls',
			method: 'POST',
			timeout: 10000,
			params: submitValues,
			success: function(form, action) {
				Ext.getCmp('hiddenSimpleGUID').setValue(action.result.GUID);
				store = new Ext.data.JsonStore({
					autoLoad: false,
					url: '../web.eprajax.query.basicquery.cls',
					method: 'GET',
					baseParams: { action: 'fetchdata', hiddenGUID: action.result.GUID, hiddenCols: simpleResultCols },
					fields: eval("[" + simpleFields + "]"),
					root: 'data',
					totalProperty: 'TotalCount'
				});
				Ext.getCmp('resultGrid').reconfigure(store, new Ext.grid.ColumnModel(eval("["+"new Ext.grid.RowNumbererA(),"  + simpleColModel + "]")));
				//ie11非兼容模式添加ext-ie类，使表格显示正常 刘仲皖
								if('IE11.0'==isIE()){
									Ext.getCmp('resultGrid').addClass('ext-ie');
								}
				Ext.getCmp('pagingToolbar').bind(store);

				store.on('load', function() {
					changeRowBackgroundColor(Ext.getCmp('resultGrid'));
				});

				store.load({ params: { start: 0, limit: queryPageSize} });

				Ext.getCmp('btnCommit').enable();
				Ext.getCmp('NoStrbtnCommit').enable();
			},
			failure: function(form, action) {
				//debugger;
				alert("01-查询失败!");
				Ext.getCmp('btnCommit').enable();
				Ext.getCmp('NoStrbtnCommit').enable();
			},
			waitTitle: '检索数据',
			waitMsg: '正在处理数据，请稍后……'
		});
	} else {

	}
}

function ReadExcel(filePath)
{   
	Ext.getCmp('vpEPRQuery').getEl().mask('数据导入中，请稍等')
	var NoStr = "";
    //var filePath = "C:\\测试数据.xls";
    var oXL = new ActiveXObject("Excel.application"); 
    var oWB = oXL.Workbooks.open(filePath);
    //oWB.worksheets(1).select(); 
    var oSheet = oWB.ActiveSheet;
	try{     
		for(var i=1;;i++)	
		{
			if (oSheet.Cells(i,1).value == "" || oSheet.Cells(i,2).value == "null" || oSheet.Cells(i,1).value == undefined)
			{
				break;
			}
			else
			{
				if (NoStr == "")
				{
					NoStr = NoStr + oSheet.Cells(i,1).value;
				}
				else
				{
					NoStr = NoStr + "#" + oSheet.Cells(i,1).value;
				}
			}
			//var a = oSheet.Cells(i,1).value.toString()=="undefined"?"":oSheet.Cells(i,1).value;
		}     
	}catch(e)     
	{     
		Ext.getCmp("NoStrEpisodeNoStrArea").setValue(NoStr);
	}

	Ext.getCmp("NoStrEpisodeNoStrArea").setValue(NoStr);

	oXL.Quit();

	Ext.getCmp('vpEPRQuery').getEl().unmask('数据导入完毕！')
} 

function isIE(){
	var userAgent = navigator.userAgent, 
	rMsie = /(msie\s|trident.*rv:)([\w.]+)/; 
	var browser; 
	var version; 
	var ua = userAgent.toLowerCase(); 
	function uaMatch(ua){ 
		var match = rMsie.exec(ua); 
		if(match != null){ 
 			return { browser : "IE", version : match[2] || "0" }; 
		}
	} 
	var browserMatch = uaMatch(userAgent.toLowerCase()); 
	if (browserMatch.browser){ 
 		browser = browserMatch.browser; 
 		version = browserMatch.version; 
	} 
	return(browser+version);
}