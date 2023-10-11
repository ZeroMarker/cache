var selDeptID = "";
var selHospID = "";
var isHidenPatCAOn = false;
var isHidenCAOn = false;

$(function(){
	initBTN(); 
	document.onkeydown = documentOnKeyDown;
	
	if (sysOption.IsOnMulityHospMgr == "1")
    {
		var hospComp = GenHospComp("CA.ConfigCTLoc",logonInfo.UserID+'^'+logonInfo.GroupID+'^'+logonInfo.CTLocID+'^');  
		hospComp.options().onSelect = function(){
            selHospID = hospComp.getValue()
			if (!isShow(selHospID)){
				return;
			}
			initDeptGrid(selHospID);
		}
		hospComp.options().onLoadSuccess = function(){
            selHospID = hospComp.getValue()
			if (!isShow(selHospID)){
				return;
			}
			initDeptGrid(selHospID);
		}
	}
	else
	{
		$("#hospDiv").hide();
		$('#hospDiv').panel('resize', {height: 0});
		$('body').layout('resize');
		selHospID = logonInfo.HospID;
		if (!isShow(selHospID)){
			return;
		}
		initDeptGrid(selHospID);
	}
})

function initBTN(){
	$("#btnStartDept").click(function(){startDept("CA");});
	$("#btnStopDept").click(function(){stopDept("CA");});
	
	$("#btnQueryDept").click(function(){queryDept();});
	
	$("#btnStartPatDept").click(function(){startDept("PATCA");});
	$("#btnStopPatDept").click(function(){stopDept("PATCA");});
}

function isShow(selHospID) {
	var result = false;
	var errmsg = "";
    var data = ajaxDATA('String', 'CA.BL.Config', 'GetCfgCommon',selHospID);
    ajaxPOSTSync(data, function (ret) {
        if (ret != "")
        {
            var arr = $.parseJSON(ret);
            if ((arr["IsCAOn"] != "1")&&(arr["IsHandSignCAON"] != "1"))
	        {
		    	errmsg = "当前院区未开启【医护签名】和【患者签名】，无需维护签名科室！"
		    	
				//setEnable(true);
				isHidenCAOn = true;
				isHidenPatCAOn = true;
				$("#btnStartDept").hide();
			    $("#btnStopDept").hide();
			    $("#btnStartPatDept").hide();
			    $("#btnStopPatDept").hide();
			    
			    result = true;
		    }
		    else
		    {
	            if (arr["IsCAOn"] != "1")
			    {
					isHidenCAOn = true;
					$("#btnStartDept").hide();
			    	$("#btnStopDept").hide();
			    	if ((arr["IsHandSignCAON"] == "1")&&(arr["AllPatCAOn"] == "1"))
			    		errmsg = setMessage("当前院区未开启【医护签名】，无需开关[医护签名]科室！",errmsg);
				}
				else 
				{
					if (arr["AllCAOn"] == "1")
				    {
				    	isHidenCAOn = true;
				    	//$.messager.alert("提示",errmsg);
				    	$("#btnStartDept").hide();
				    	$("#btnStopDept").hide();
						//setEnable(true);
						errmsg = setMessage("当前院区已配置【全院开启医护签名】，所有科室[医护签名]都为启用状态！",errmsg);
				    }
				}
	            
	            if (arr["IsHandSignCAON"] != "1")
			    {
					isHidenPatCAOn = true;
					$("#btnStartPatDept").hide();
			    	$("#btnStopPatDept").hide();
			    	if ((arr["IsCAOn"] == "1")&&(arr["AllCAOn"] == "1"))
			    		errmsg = setMessage("当前院区未开启【患者签名】，无需开关[患者签名]科室！",errmsg);
				}
				else 
				{
					if (arr["AllPatCAOn"] == "1")
				    {
				    	
				    	isHidenPatCAOn = true;
				    	//$.messager.alert("提示",errmsg);
				    	$("#btnStartPatDept").hide();
				    	$("#btnStopPatDept").hide();
						//setEnable(true);
						errmsg = setMessage("当前院区已配置【全院开启患者签名】，所有科室[患者签名]都为启用状态！",errmsg)
				    }
				}
		    }
		    if (errmsg != "")
		    	$.messager.alert("提示",errmsg);
			result = true;
        }
        else
        {
            $.messager.alert("提示","获取通用配置数据错误!");
        }
    }, function (ret) {
        $.messager.alert("提示","CA.BL.Config.GetCfgCommon Error:" + ret);
    });
    return result;
}

function setMessage(msg,errmsg) {
	if (errmsg != "") 
		errmsg = errmsg + "<br/>";
	errmsg = errmsg + msg;
	return errmsg;
}


/*function setEnable(enable,errmsg) {
	if (enable) {
		$("#Dept").show();
		$("#caTip").hide();
	}else {
		$("#Dept").hide();
		$("#caTip").show();
		document.getElementById("caTip").innerText = errmsg;
	}
}*/

function queryDept() {
	var deptDesc = $("#DeptDesc").val();
	var signStatus = $HUI.combobox('#DeptStatus').getValue();
	
	var para = "";
	if ((deptDesc != "")||(signStatus != "")) {
		var obj = {DeptDesc:deptDesc,SignStatus:signStatus,HospID:selHospID};
		para = JSON.stringify(obj);
	}
	
	$('#dgDept').datagrid('load',{
        p1:para
    });
}


function startDept(Type) {
	selDeptID = selDeptID || "";
	if (selDeptID == "") {
		$.messager.alert("提示","请选中要开启的科室");
		return;
	}
	
	var data = ajaxDATA('String', 'CA.BL.Config', 'StartDept', selDeptID, Type);
    ajaxPOSTSync(data, function (ret) {
        var d = $.parseJSON(ret);
        if (d.retCode == "0") {
	        queryDept();
	        $.messager.popover({msg: d.retMsg,type: 'success',timeout: 3000,showType: 'show',style: {top: 200,left:(window.screen.width/2)-220}});
	    }
	    else {
        	$.messager.alert("提示",d.retMsg);
	    }
    }, function (ret) {
        $.messager.alert("提示","StartDept error:" + ret);
    });
}

function stopDept(Type) {
	selDeptID = selDeptID || "";
	if (selDeptID == "") {
		$.messager.alert("提示","请选中要停用的科室");
		return;
	}
	
	var data = ajaxDATA('String', 'CA.BL.Config', 'StopDept', selDeptID, Type);
    ajaxPOSTSync(data, function (ret) {
        var d = $.parseJSON(ret);
        if (d.retCode == "0") {
	        queryDept();
	        $.messager.popover({msg: d.retMsg,type: 'success',timeout: 3000,showType: 'show',style: {top: 200,left:(window.screen.width/2)-220}});
	    }
	    else {
		    $.messager.alert("提示",d.retMsg);
		}
    }, function (ret) {
        $.messager.alert("提示","StopDept error:" + ret);
    });
}

function initDeptGrid(selHospID) {
	var json = JSON.stringify({SignStatus:"ALL",HospID:selHospID});
	var param = {p1:json};
	
	$('#dgDept').datagrid({
		fit:true,
		border:false,
		fitColumns:false,
		toolbar:'#tbDept',
		url: "../CA.Ajax.Cfg.cls?OutputType=String&Class=CA.BL.Config&Method=GetDeptList",
		queryParams: param,
		idField:'CTLocID',
		singleSelect:true,
		pagination:true,
		rownumbers:true,
		pageSize:50,
		pageList:[2,10,30,50],
		beforePageText:'第',
		afterPageText:'页, 共{pages}页',
		displayMsg:'显示 {from} 到 {to} ,共 {total} 条记录',
		columns:[[
			{field:'CTLocID',title:'科室ID'},
			{field:'CTLocCode',title:'科室代码',width:130},
			{field:'CTLocDesc',title:'科室名称',width:200},
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
                },
                hidden: isHidenCAOn
            },
            {
				field:'IsPatCAOn',
				title:'是否已开启患者签名',
				align: 'center',
				formatter: function(value,row,index) 
				{
					if (value == "1") {
                        return "<span style='color:green'>已开启</span>";
                    } else {
                        return "<span style='color:red'>未开启</span>";
                    }
                },
                hidden: isHidenPatCAOn
            }
		]],
		onLoadError:function() {
			$.messager.alert("提示","科室列表加载失败");
		},
		onSelect:function(rowIndex,row){
			selDeptID = row.CTLocID;
			if (row.IsCAOn == 1){
				$("#btnStartDept").linkbutton('disable');
				$("#btnStopDept").linkbutton('enable');
			} else {
				$("#btnStopDept").linkbutton('disable');
				$("#btnStartDept").linkbutton('enable');
			}
			
			if (row.IsPatCAOn == 1){
				$("#btnStartPatDept").linkbutton('disable');
				$("#btnStopPatDept").linkbutton('enable');
			} else {
				$("#btnStopPatDept").linkbutton('disable');
				$("#btnStartPatDept").linkbutton('enable');
			}
		},
		onLoadSuccess:function(data){
			$("#dgDept").datagrid("clearSelections");
			$("#btnStartDept").linkbutton('disable');
			$("#btnStopDept").linkbutton('disable');
			$("#btnStartPatDept").linkbutton('disable');
			$("#btnStopPatDept").linkbutton('disable');
			selDeptID = "";
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
		queryDept();
	}
	
}
