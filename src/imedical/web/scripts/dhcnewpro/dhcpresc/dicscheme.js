/// Creator: huanghongping
/// CreateDate: 2021-9-22
//  Descript:审方中心科室维护

$(function () {

    initParams();

    initBindMethod();

    initDatagrid();
	
})

function initParams() {

    formNameID = "";

    editRow = "";

    inputEditor = { type: 'validatebox', options: { required: true } };
    
    if(HISUIStyleCode==="lite"){
	    $(".keyscat").css({"color":"#339eff"});
	    $(".keysbyt").css({"border-color":"#339eff"});
	}else{
		$(".keyscat").css({"color":"#017bce"});
	    $(".keysbyt").css({"border-color":"#017bce"});
	}
}

function initBindMethod() {
    $("a:contains('批量添加')").bind('click', addItm);
    $("a:contains('删除元素')").bind('click', delItm);
    $("#saveAll").click(function () { saveAll() });
    $("#allItmTable").on("click", ".checkbox", function(){selectExaItem(this)});   //绑定复选框点击事件
    $("#DrugItmTable").on("click", ".checkbox", function(){selectExaItem(this)});   //绑定药品复选框点击事件
    $("#deDrug").on("click", ".checkbox", function(){selectExaItem(this)});   //绑定处方类型复选框点击事件
    
    $HUI.radio("[name='handle']",{
        onChecked:function(e,value){
            reloadLocList();
        }
    });
    
    $HUI.radio("[name='selallck']",{
        onChecked:function(e,value){
            selAll();
        }
    });
    
    $HUI.radio("[name='selcatall']",{		
        onChecked:function(e,value){
            selcatAll();
        }
    });
    
    
    $HUI.radio("[name='seltypeall']",{		
        onChecked:function(e,value){
            seltypeAll();
        }
    });
    //$("#selall").bind('click',selAll);
    //$("#selcatall").bind('click',selcatAll);
    //$("#seltypeall").bind('click',seltypeAll);

}

function initDatagrid() {

    //$("#allItmTable").html('<tr style="height:0px;"><td style="width:20px;height:0px"></td><td></td><td style="width:20px;height:0px"></td><td></td><td style="width:20px;height:0px"></td><td></td><td style="width:20px;height:0px"></td><td></td><td style="width:20px;height:0px"></td><td></td></tr>');

    runClassMethod("web.DHCPRESCDicScheme", "GetAllCTLoc", {"Value": "" , "Hosp": LgHospID}, function (jsonString) {

        if (jsonString != "") {
            var jsonObjArr = jsonString;
            InitCheckItemRegion(jsonObjArr);
        }
    }, 'json', false)

    runClassMethod("web.DHCPRESCDicScheme", "ListDrugItem", { rows: 9999, page: 1 }, function (jsonString) {

        if (jsonString != "") {
            var jsonObjArr = jsonString.rows;
            InitCheckDrugItem(jsonObjArr);
        }
    }, 'json', false)
    var setcolumns = [[
        { field: 'id', title: 'id', width: 80, hidden: true },
        { field: 'LogUserName', title: '监测人', width: 80 },
        { field: 'ctlocCode', title: '代码', width: 100 },
        { field: 'ctlocName', title: '名称', width: 180 },
        { field: ' ', title: '操作', width: 70, formatter: formNumber },
    ]];

    $("#setItmTable").datagrid({
        title: '已选条件',
        url: $URL + "?ClassName=web.DHCPRESCDicScheme&MethodName=GetSetFiel&ForNameID=" + LgUserID,
        fit: true,
        rownumbers: true,
        columns: setcolumns,
        checkOnSelect: false,
        loadMsg: '正在加载信息...',
        //showHeader:false,
        rownumbers: false,
        pagination: false,
        onSelect: function (rowIndex, rowData) {

        },
        onClickRow: function (rowIndex, rowData) {
            $(this).datagrid('unselectRow', rowIndex);     //禁止选中行
        },
        onLoadSuccess: function (data) {
            for (i in data.rows) {
                $("input[type='checkbox']").each(function () {

                    if (this.value == data.rows[i].ctlocCode) {
                        $(this).attr("checked", true)
                    }
                })
            }

        }
    });
    //$('#setItmTable').datagrid('loadData', { total: 0, rows: [] });


    var tempcolumns = [[
        { field: 'id', title: 'ID', width: 50, hidden: true, align: 'center' },
        { field: 'Code', title: '代码', width: 200, hidden: false, align: 'center' },
        { field: 'Desc', title: '描述', width: 300, align: 'center' },

    ]];
    //    $("#DrugItmTable").datagrid({
    //        title: '<font color=red font-weight=bold font-size=12pt >【点击一项添加到右侧】</font>',
    //        url: $URL +"?ClassName=web.DHCPRESCDicScheme&MethodName=ListDrugItem",
    //        fit: true,
    //        rownumbers: true,
    //        columns: tempcolumns,
    //		pageSize: 30,
    //		pageList: [30, 60, 90],
    //		pagination: true,
    //        checkOnSelect: false,
    //        loadMsg: '正在加载信息...',
    //        //showHeader:false,
    //        rownumbers: false,
    //        iconCls: 'icon-paper',
    //		headerCls: 'panel-header-gray', 
    //        onLoadSuccess:function(data){
    //	        console.log(data)
    //	        },
    //        onSelect: function (rowIndex, rowData) {
    //
    //        },
    //        onClickRow: function (rowIndex, rowData) {
    //            $(this).datagrid('unselectRow', rowIndex);     //禁止选中行
    //        },
    //        onDblClickRow: function (rowIndex, rowData) {		
    //        }
    //    });
    //

    //	reloadAllItmTable(formNameID);
    reloadSetFielTable();


}

/// 检查方法列表
function InitCheckItemRegion(itemobj) {
    /// 标题行 <label style="margin:0px 5px;">项目检索</label><input id="item" style="width:245px;border:1px solid #95B8E7;margin:2px 3px;height:25px;" placeholder='请输入名称/拼音码'/>
    var htmlstr = '';
    //	htmlstr = '<tr style="height:0px"><td colspan="4" class=" tb_td_required" style="border:0px solid #ccc;">'+ "监测科室列表" +'</td></tr>';

    /// 项目
    var itemhtmlArr = []; itemhtmlstr = "";
    for (var j = 1; j <= itemobj.length; j++) {

        itemhtmlArr.push('<td style="width:20px"><input id="' + itemobj[j - 1].id + '" name="' + itemobj[j - 1].ctloc + '" type="checkbox" class="checkbox" value="' + itemobj[j - 1].ctcode + '"></input></td><td style="margin-top:10px;">' + itemobj[j - 1].ctloc + '</td>');
        if (j % 5 == 0) {
            itemhtmlstr = itemhtmlstr + '<tr>' + itemhtmlArr.join("") + '</tr>';
            itemhtmlArr = [];
        }
    }
    if ((j - 1) % 5 != 0) {
        itemhtmlstr = itemhtmlstr + '<tr>' + itemhtmlArr.join("") + '<td style="width:20px"></td><td></td></tr>';
        itemhtmlArr = [];
    }
    $("#allItmTable").append(htmlstr + itemhtmlstr);
}

/// 药品目录列表
function InitCheckDrugItem(itemobj) {
    var htmlstr = '';
    var itemhtmlArr = []; itemhtmlstr = "";
    //htmlstr = '<tr style="height:0px"><td style="width:30px"></td><td colspan="10" class=" tb_td_required" style="border:0px solid #ccc;width:30px">'+ "药品目录列表" +'</td></tr>';
    for (var j = 1; j <= itemobj.length; j++) {

        itemhtmlArr.push('<td style="width:20px"><input id="' + itemobj[j - 1].id + '" name="' + itemobj[j - 1].Desc + '" type="checkbox" class="checkbox" value="' + itemobj[j - 1].Code + '"></input></td><td>' + itemobj[j - 1].Desc + '</td>');
        if (j % 5 == 0) {
            itemhtmlstr = itemhtmlstr + '<tr>' + itemhtmlArr.join("") + '</tr>';
            itemhtmlArr = [];
        }
    }
    if ((j - 1) % 5 != 0) {
        itemhtmlstr = itemhtmlstr + '<tr>' + itemhtmlArr.join("") + '<td style="width:20px"></td><td></td></tr>';
        itemhtmlArr = [];
    }
    $("#DrugItmTable").append(htmlstr + itemhtmlstr);
}
///添加元素
function addItm() {
    var datas = $("#allItmTable").datagrid("getSelections");
    var objectDatas = $("#setItmTable").datagrid("getRows");
    if (datas.length < 1) {
        $.messager.alert("提示", "未选中左侧数据！","warning");
        return;
    }
    for (i in datas) {
        for (x in objectDatas) {
            if (objectDatas[x].ctlocCode == datas[i].ctcode) {
                $.messager.alert("提示", "新增失败！选中科室中有的已经添加过","error");
                return;
            }
        }
        $("#setItmTable").datagrid('insertRow', { row: { id: datas[i].id, ctlocCode: datas[i].ctcode, ctlocName: datas[i].ctloc } })
    }
}
function addItmd() {
    var datas = $("#allItmTable").datagrid("getSelections");
    if (datas.length < 1) {
        $.messager.alert("提示", "未选中左侧数据！","warning");
        return;
    }
    var dataArray = [], param = "";
    for (x in datas) {
        param = datas[x].id;
        dataArray.push(param);
    }
    //var a = LgUserID
    var params = dataArray.join("&&");
    runClassMethod("web.DHCPRESCDicScheme", "SaveExpField", { "Params": params, "LgUserID": LgUserID },
        function (ret) {
            if (ret == "0") {
                $.messager.alert("提示", "新增成功！","info");
                reloadTopTable();
            }
            else {
                $.messager.alert("提示", "新增失败！选中科室中有的已经添加过","error");
                reloadTopTable();
            }
        }, 'text');


}
function delItm() {
    var datas = $("#setItmTable").datagrid("getSelections");
    if (datas.length < 1) {
        $.messager.alert("提示", "未选中右侧数据！","warning");
        return;
    }
    var dataArray = [], param = "";
    for (x in datas) {
        param = datas[x].id;
        dataArray.push(param);
    }

    var params = dataArray.join("&&");
    runClassMethod("web.DHCPRESCDicScheme", "DelExpField", { "Params": params },
        function (ret) {
            if (ret == "0") {
                $.messager.alert("提示", "删除成功！","info");
                reloadTopTable();
            }
        }, 'text');
}


function reloadSetFielTable() {

    $("#setItmTable").datagrid('load', {
        ForNameID: LgUserID
    })
}


///刷新 field和fieldVal
function reloadTopTable() {
    reloadSetFielTable();
    //reloadAllItmTable(formNameID);
}
//搜索
function doSearch(value) {

    $("#allItmTable").datagrid('reload', { Value: value })

}
function formNumber(row, value, index) {
	
    return '<a href="#" class="icon icon-cancel" onclick="ShowConsultDetail(\'' + row + '\',\'' + value.ctlocCode + '\',\'' + index + '\')" style="color:#000;display:inline-block;width:16px;height:16px"></a>';
}

function ShowConsultDetail(row, value, index) {
	$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
		if (res) {
		    runClassMethod("web.DHCPRESCDicScheme", "deleteItemCtloc",
		        {
		            ctlocCode: value, userID: LgUserID
		        },
		        function (data) {

		            $("#setItmTable").datagrid('deleteRow', index);
		            var rows = $('#setItmTable').datagrid("getRows");
		            $('#setItmTable').datagrid("loadData", rows);
		            $("input[type='checkbox']").each(function () {

		                if (this.value == value) {
		                    $(this).attr("checked", false)
		                }


		            })


		        })
		}
	});

}
function saveAll() {
    var all = $("#setItmTable").datagrid("getRows");
    // var datas = getParam("datas");
    var userIDs = LgUserID;
    //    if (datas) {
    //        userIDs = datas;
    //        
    //    }
    if (all.length < 1) {
        $.messager.alert("提示", "请先选择科室！","warning");
        return;
    }


    var allArray = []
    for (i in all) {
        var temp = all[i].ctlocName + "^" + all[i].ctlocCode;
        allArray.push(temp);
    }
    var Params = allArray.join("&&");
    runClassMethod("web.DHCPRESCDicScheme", "SaveExpField", { "Params": Params, "UserId": userIDs },
        function (data) {
            if (data == 0) {
                $.messager.alert('提示', '保存成功',"info");
                reloadSetFielTable();
            }
        })
}

/// 选中检查项目
function selectExaItem(chksel) {
    
    var id = chksel.id;
    var value = chksel.value;
    var name = chksel.name;
    if ($(chksel).is(':checked')) {
        var datas = $("#setItmTable").datagrid("getRows");
        if (datas.length < 1) {
            //return;
        } else {
	       console.log($(chksel).is(':checked'))
            for (x in datas) {
                if (value == datas[x].ctlocCode) {
	                $.messager.popover({
						msg: '新增失败！该科室右侧已存在!',
						type: 'error',
						timeout: 2500, 		
						showType: 'slide' 
					});
                    $(chksel).prop("checked", false);
                    return;
                }
            }
        }

        $("#setItmTable").datagrid('insertRow', { row: { id: chksel.id, ctlocCode: chksel.value, ctlocName: chksel.name, LogUserName: LgUserName } })
    }
    else {
	
        var selItems = $("#setItmTable").datagrid('getRows');
        $.each(selItems, function (rowIndex, selItem) {
	       
            if ((selItem.ctlocCode == value)) {
	           
                /// 删除行
                //runClassMethod("web.DHCPRESCDicScheme", "deleteItemCtloc",
                //    {
                //        ctlocCode: value, userID: LgUserID
                //    },
                //    function (data) {
                        $("#setItmTable").datagrid('deleteRow', rowIndex);
                //    })


            }
        })

    }
}



function saveSelectItem() {
    var flag = "true";
    var message = "";
    var ID = $("#main").datagrid("getSelected")
    if (ID == null) {
        $.messager.alert("提示", "未选择模板",'warning');
        return;
    }
    if (ID.PLTFlag == "否") {
        $.messager.alert("提示", "当前模板不可用",'warning');
        return;

    }

    var objectDatas = $("#setItmTable").datagrid("getRows");
    $.cm({
        ClassName: "web.DHCPRESCLocTemp",
        QueryName: "GetAllPLCtLoc",
        mID: ID.RowID
    },
        function (datas) {
            if (datas.total < 1) {
                $.messager.alert("提示", "新增失败！该模板还没有关联科室",'warning');
                return;
            }

            for (i in datas.rows) {
                var a = 0
                if (objectDatas.length > 0) {

                    for (x in objectDatas) {
                        if (objectDatas[x].ctlocCode == datas.rows[i].LocCode) {
                            message = message + objectDatas[x].ctlocName + ",";
                            a = 1;
                            flag = "false";
                            break;
                        }
                    }
                }
                if (a == 1) {
                    continue;
                }
                $("#setItmTable").datagrid('insertRow', { row: { LogUserName: LgUserName, id: datas.rows[i].ID, ctlocCode: datas.rows[i].LocCode, ctlocName: datas.rows[i].LocName } });
            }
            if (flag == "false") {
                //	            	message=message.slice(0,message.length-1)+"。"
                $.messager.alert("提示", "已选科室与科室模板有重复,已为您过滤重复科室","warning")
            }
            if (objectDatas.length > 0) {
                for (j in objectDatas) {
                    $("input[type='checkbox']").each(function () {

                        if (this.value == objectDatas[j].ctlocCode) {
                            $(this).prop("checked", true);
                            // $(this).attr("checked",true);
                        }
                    })

                }
            }




        });
}
/// 搜索 
function DoSearchItem(value) {
    //$("#allItmTable").html('<tr style="height:0;"><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td></tr>');
    $("#allItmTable").html('')
    runClassMethod("web.DHCPRESCDicScheme", "GetAllCTLoc", { "Value": value , "Hosp": LgHospID}, function (jsonString) {

        if (jsonString != "") {
            var jsonObjArr = jsonString;
            InitCheckItemRegion(jsonObjArr);
        }
    }, 'json', false)
    /// 设置每次搜索结果复选框勾选状态
    var objectDatas = $("#setItmTable").datagrid("getRows");
    if (objectDatas.length > 0) {
        for (j in objectDatas) {
            $("input[type='checkbox']").each(function () {

                if (this.value == objectDatas[j].ctlocCode) {
                    $(this).prop("checked", true);
                    // $(this).attr("checked",true);
                }
            })

        }
    }

}

///根据单选框检索
function reloadLocList()
{
	var handStaus = $("input[name='handle']:checked").val();
	handStaus = (handStaus == undefined) ? "" : handStaus;
	var locDesc = $HUI.searchbox("#locsearch").getValue();
	$("#allItmTable").html('')
    runClassMethod("web.DHCPRESCDicScheme", "GetAllCTLoc", { "Value": locDesc , "Hosp": LgHospID,"handStaus":handStaus}, function (jsonString) {

        if (jsonString != "") {
            var jsonObjArr = jsonString;
            InitCheckItemRegion(jsonObjArr);
        }
    }, 'json', false)
    /// 设置每次搜索结果复选框勾选状态
    var objectDatas = $("#setItmTable").datagrid("getRows");
    if (objectDatas.length > 0) {
        for (j in objectDatas) {
            $("input[type='checkbox']").each(function () {

                if (this.value == objectDatas[j].ctlocCode) {
                    $(this).prop("checked", true);
                    // $(this).attr("checked",true);
                }
            })

        }
    }
}

function selAll()
{
	var ckval = $("input[name='selallck']:checked").val();
	ckval = (ckval == undefined) ? "" : ckval;
	if(ckval==1){
		var cheArr = $("#allItmTable .checkbox");
		for(var i=0;i<cheArr.length;i++){
			if ($(cheArr[i]).is(':checked')){continue;}
			$(cheArr[i]).prop("checked",true);
			selectExaItem(cheArr[i]);
		
		}
	}else{
		var cheArr = $("#allItmTable .checkbox");
		for(var i=0;i<cheArr.length;i++){
			var value =  cheArr[i].value;
			$(cheArr[i]).attr("checked",false)
			var selItems = $("#setItmTable").datagrid('getRows');
			for(var j=0;j<selItems.length;j++){
				 if ((selItems[j].ctlocCode == value)) {
					 $("#setItmTable").datagrid('deleteRow', j);
				 }
			}
		}
	}
	

}

function selcatAll()
{
	var ckval = $("input[name='selcatall']:checked").val();
	ckval = (ckval == undefined) ? "" : ckval;
	if(ckval==1){
		var cheArr = $("#DrugItmTable .checkbox");
		for(var i=0;i<cheArr.length;i++){
			if ($(cheArr[i]).is(':checked')){continue;}
			$(cheArr[i]).prop("checked",true);
			selectExaItem(cheArr[i]);
		
		}
	}else{
		var cheArr = $("#DrugItmTable .checkbox");
		for(var i=0;i<cheArr.length;i++){
			var value =  cheArr[i].value;
			$(cheArr[i]).attr("checked",false)
			var selItems = $("#setItmTable").datagrid('getRows');
			for(var j=0;j<selItems.length;j++){
				 if ((selItems[j].ctlocCode == value)) {
					 $("#setItmTable").datagrid('deleteRow', j);
				 }
			}
		}
	}
}
function seltypeAll()
{
	
	var ckval = $("input[name='seltypeall']:checked").val();
	ckval = (ckval == undefined) ? "" : ckval;
	if(ckval==1){
		var cheArr = $("#deDrug .checkbox");
		for(var i=0;i<cheArr.length;i++){
			if ($(cheArr[i]).is(':checked')){continue;}
			$(cheArr[i]).prop("checked",true);
			selectExaItem(cheArr[i]);
		
		}
	}else{
		var cheArr = $("#deDrug .checkbox");
		for(var i=0;i<cheArr.length;i++){
			var value =  cheArr[i].value;
			$(cheArr[i]).attr("checked",false)
			var selItems = $("#setItmTable").datagrid('getRows');
			for(var j=0;j<selItems.length;j++){
				 if ((selItems[j].ctlocCode == value)) {
					 $("#setItmTable").datagrid('deleteRow', j);
				 }
			}
		}
	}
}