var selSSGroupID = "";
var selHospID = "";

$(function(){
	initBTN(); 
	document.onkeydown = documentOnKeyDown;
	if (sysOption.IsOnMulityHospMgr == "1")
    {
		var hospComp = GenHospComp("CA.ConfigSSGroup",logonInfo.UserID+'^'+logonInfo.GroupID+'^'+logonInfo.CTLocID+'^');  
		hospComp.options().onSelect = function(){
			selHospID = hospComp.getValue()
			if (!getIsCAOnBySsgroup(selHospID)){
				return;
			}
			initSSGroupGrid(selHospID);
		}
		hospComp.options().onLoadSuccess = function(){
			selHospID = hospComp.getValue()
			if (!getIsCAOnBySsgroup(selHospID)){
				return;
			}
			initSSGroupGrid(selHospID);
		}
	}
	else
	{
		$("#hospDiv").hide();
		$('#hospDiv').panel('resize', {height: 0});
		$('body').layout('resize');
		selHospID = logonInfo.HospID;
		if (!getIsCAOnBySsgroup(selHospID)){
			return;
		}
		initSSGroupGrid(selHospID);
	}
})

function initBTN(){
	$("#btnStartSSGroup").click(function(){startSSGroup();});
	$("#btnStopSSGroup").click(function(){stopSSGroup();});
	$("#btnQuerySSGroup").click(function(){querySSGroup();});
}

function getIsCAOnBySsgroup(selHospID) {
	var result = false;
	var errmsg = "";
    var data = ajaxDATA('String', 'CA.BL.Config', 'GetCfgCommon',selHospID);
    ajaxPOSTSync(data, function (ret) {
        if (ret != "")
        {
            var arr = $.parseJSON(ret);
            if (arr["IsCAOnBySsgroup"] !== "1")
            {
	        	errmsg = "当前院区配置中未开启【是否开启安全组管理】，当前页面不可用！"
	        }
	        else if (arr["AllCAOn"] == "1")
	        {
		    	errmsg = "当前院区已配置【全院开启医护签名】，所有安全组都为启用状态！"
		    }
		    else
		    {
			    result = true;
			}
        }else
        {
            $.messager.alert("提示","获取通用配置数据错误!");
        }
    }, function (ret) {
        $.messager.alert("提示","CA.BL.Config.GetCfgCommon Error:" + ret);
    });

    if (!result){
		$.messager.alert("提示",errmsg);
		setEnable(false,errmsg);    
	}else {
		setEnable(true);
	}
    return result;
}

function setEnable(enable,errmsg) {	
	if (enable) {
		$("#SSGroup").show();
		$("#caTip").hide();
	}else {
		$("#SSGroup").hide();
		$("#caTip").show();
		document.getElementById("caTip").innerText = errmsg;
	}
}

function querySSGroup() {
	var SSGroupDesc = $("#SSGroupDesc").val();
	var signStatus = $HUI.combobox('#SSGroupStatus').getValue();
	
	var para = "";
	if ((SSGroupDesc != "")||(signStatus != "")) {
		var obj = {SSGroupDesc:SSGroupDesc,SignStatus:signStatus,HospID:selHospID};
		para = JSON.stringify(obj);
	}
	
	$('#dgSSGroup').datagrid('load',{
        p1:para
    });
}


function startSSGroup() {
	selSSGroupID = selSSGroupID || "";
	if (selSSGroupID == "") {
		$.messager.alert("提示","请选中要开启的安全组");
		return;
	}
	
	var data = ajaxDATA('String', 'CA.BL.Config', 'StartSSGroup', selSSGroupID);
    ajaxPOSTSync(data, function (ret) {
        var d = $.parseJSON(ret);
        if (d.retCode == "0") {
	        querySSGroup();
	        $.messager.popover({msg: d.retMsg,type: 'success',timeout: 3000,showType: 'show',style: {top: 200,left:(window.screen.width/2)-220}});
	    }
	    else {
        	$.messager.alert("提示",d.retMsg);
	    }
    }, function (ret) {
        $.messager.alert("提示","StartSSGroup error:" + ret);
    });
}

function stopSSGroup() {
	selSSGroupID = selSSGroupID || "";
	if (selSSGroupID == "") {
		$.messager.alert("提示","请选中要停用的安全组");
		return;
	}
	
	var data = ajaxDATA('String', 'CA.BL.Config', 'StopSSGroup', selSSGroupID);
    ajaxPOSTSync(data, function (ret) {
        var d = $.parseJSON(ret);
        if (d.retCode == "0") {
	        querySSGroup();
	        $.messager.popover({msg: d.retMsg,type: 'success',timeout: 3000,showType: 'show',style: {top: 200,left:(window.screen.width/2)-220}});
	    }
	    else {
        	$.messager.alert("提示",d.retMsg);
	    }
    }, function (ret) {
        $.messager.alert("提示","StopSSGroup error:" + ret);
    });
}

function initSSGroupGrid(selHospID) {
	var json = JSON.stringify({SignStatus:"ALL",HospID:selHospID});
	var param = {p1:json};
	
	$('#dgSSGroup').datagrid({
		fit:true,
		border:false,
		fitColumns:false,
		toolbar:'#tbSSGroup',
		url: "../CA.Ajax.Cfg.cls?OutputType=String&Class=CA.BL.Config&Method=GetSSGroupList",
		queryParams: param,
		idField:'SSGroupID',
		singleSelect:true,
		pagination:true,
		rownumbers:true,
		pageSize:50,
		pageList:[2,10,30,50],
		beforePageText:'第',
		afterPageText:'页, 共{pages}页',
		displayMsg:'显示 {from} 到 {to} ,共 {total} 条记录',
		columns:[[
			{field:'SSGroupID',title:'安全组ID'},
			{field:'SSGroupDesc',title:'安全组名称',width:200},
			{
				field:'IsCAOn',
				title:'是否已开启医护签名',
				align: 'center',
				formatter: function(value,row,index) 
				{
					if (value == "1") {
                        return "<span style='color:green'>已开启</span>";
                    } else {
                        return "<span style='color:red'>未开启</span>";
                    }
                }
            }
		]],
		onLoadError:function() {
			$.messager.alert("提示","安全组列表加载失败");
		},
		onSelect:function(rowIndex,row){
			selSSGroupID = row.SSGroupID;
			if (row.IsCAOn == 1){
				$("#btnStartSSGroup").linkbutton('disable');
				$("#btnStopSSGroup").linkbutton('enable');
			} else {
				$("#btnStopSSGroup").linkbutton('disable');
				$("#btnStartSSGroup").linkbutton('enable');
			}
		},
		onLoadSuccess:function(data){
			$("#dgSSGroup").datagrid("clearSelections");
			$("#btnStartSSGroup").linkbutton('disable');
			$("#btnStopSSGroup").linkbutton('disable');
			selSSGroupID = "";
		}
	});
}

function documentOnKeyDown(e) {
	if (window.event){
		var keyCode=window.event.keyCode;
	}else{
		var keyCode=e.which;
	}
	
	if (keyCode==13) {
		querySSGroup();
	}
	
}
