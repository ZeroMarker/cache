/**
 * 名称:	 处方点评-分配点评任务
 * 编写人:	 dinghongying
 * 编写日期: 2019-05-17
 */
PHA_COM.App.Csp = "pha.prc.v2.create.allot.csp";
PHA_COM.App.Name = "PRC.Create.Allot";
PHA_COM.App.Load = "";
var logonLocId = session['LOGON.CTLOCID'];
var logonUserId = session['LOGON.USERID'];
$(function () {
	InitDict();
	InitGridComment();
	InitGridPha();
	InitGridPhaDetail();
	InitEvents();
	InitSetDefVal();
});
// 事件
function InitEvents() {
	$("#btnFind").on("click", Query);
	$("#btnSave").on("click", Save);
	$('#conGroup').on('keypress', function(event) {
    if (window.event.keyCode == "13") {
        var groupDesc = $.trim($("#conGroup").val());
        //if (groupDesc != "") {
				$("#gridPha").datagrid("query", {
					input: '',
					groupDesc:groupDesc
				});
           // }
        }
    });
}

// 字典
function InitDict() {
	// 初始化-日期
	var today = new Date() ;
	PHA.DateBox("conStartDate", {});
	PHA.DateBox("conEndDate", {});
}

/// 界面信息初始化
function InitSetDefVal() {
	//界面配置
	$.cm({
		ClassName: "PHA.PRC.Com.Util",
		MethodName: "GetAppProp",
		UserId: logonUserId ,
		LocId: logonLocId ,
		SsaCode: "PRC.COMMON"
	}, function (jsonColData) {
		$("#conStartDate").datebox("setValue", jsonColData.ComStartDate);
		$("#conEndDate").datebox("setValue", jsonColData.ComEndDate);
	});

}

function InitGridComment() {
    var columns = [
        [
            { field: "pcntId", title: 'rowid',width: 100, hidden: true },
            { field: "pcntNo", title: '单号',width: 120, },
            { field: 'pcntDate', title: '日期', width: 100},
            { field: "pcntTime", title: '时间' ,width: 100},
            { field: "pcntUserName", title: '制单人',width: 120  },
            { field: "typeDesc", title: '类型',width: 80, },
            { field: 'wayDesc', title: '方式', width: 120},
            { field: "itmNum", title: '所抽明细数量' ,width: 120},
            { field: 'unAllotNum', title: '可分配数量', width: 100},
            { field: "pcntText", title: '查询条件' ,width: 120, hidden:true}
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.PRC.Create.Main',
            QueryName: 'SelectComments',
			findFlag: '',
			stDate: $("#conStartDate").datebox('getValue'),
			endDate: $("#conEndDate").datebox('getValue'),
			parStr: '^^^',
			logonLocId: logonLocId,
			searchFlag: '0'
        },
        columns: columns,
        toolbar: "#gridCommentBar",
        onClickRow:function(rowIndex,rowData){
			$("#gridPhaDetail").datagrid("query", {
				pcntId: rowData.pcntId
			});
		}   
    };
    PHA.Grid("gridComment", dataGridOption);
}


function InitGridPha() {
    var columns = [
        [
            { field: "phaId", title: '点评药师Id',width: 100, hidden: true },
			{ field: "phaUserId", title: '药师UserId',width: 100, hidden: true },
			{ field: "phaGroup", title: '药师分组',width: 120},
			{ field: "phaCode", title: '药师代码',width: 120},
            { field: "phaDesc", title: '药师姓名',width: 120},
            { field: "prescNum", 
				title: '分配数量',
				width: 200 ,
				editor: {
					type: 'validatebox',
					options: {
						required: false
					}
				}
			}
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.PRC.ConFig.Pharmacist',
            QueryName: 'SelectPharmacist',
			input: '',
			groupDesc:''
        },
        columns: columns,
        toolbar: "#gridPhaBar",
		enableDnd: false,
        onClickRow: function (rowIndex, rowData) {
			$(this).datagrid('endEditing');
		},
		onDblClickCell: function (rowIndex, field, value) {
			$(this).datagrid('beginEditCell', {
				index: rowIndex,
				field: field
			});
		}  
    };
    PHA.Grid("gridPha", dataGridOption);
}

function InitGridPhaDetail() {
    var columns = [
        [
        	{ field: "phaUserGroup", title: '药师分组',width: 120 },
            { field: "phaUserName", title: '药师姓名', width: 120 },
            { field: "allotNum", title: '已分配数量',width: 200 }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.PRC.Create.Allot',
            QueryName: 'SelectAllotDetail',
			pcntId: ''
        },
        columns: columns,
        onClickRow:function(rowIndex,rowData){
	        
		}   
    };
    PHA.Grid("gridPhaDetail", dataGridOption);
}

function Query(){
	var stDate = $("#conStartDate").datebox('getValue');
	var endDate = $("#conEndDate").datebox('getValue');
	var parStr = "^^^"
	$("#gridComment").datagrid("query", {
		findFlag: '',
		stDate: stDate,
		endDate: endDate,
		parStr: parStr,
		logonLocId: logonLocId,
		searchFlag: '0'
	});
	
	
}

function Save(){
	var gridSelect = $("#gridComment").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert('提示',"请先选中点评单!","info");
		return;
	}
	var pcntId=gridSelect.pcntId;
	if (pcntId==''){
		$.messager.alert('提示',"没有获取到点评单Id，请重新选择后重试!","info");
		return;
	}
	$('#gridPha').datagrid('endEditing');
	var gridChanges = $('#gridPha').datagrid('getChanges');
	var gridChangeLen = gridChanges.length;
	if (gridChangeLen == 0) {
		PHA.Popover({
			msg: "没有需要保存的数据",
			type: 'alert'
		});
		return;
	}
	var inputStrArr = [];
	for (var counter = 0; counter < gridChangeLen; counter++) {
		var allotData = gridChanges[counter];
		var allotNum = allotData.prescNum || "" ;
		var phaUserId = allotData.phaUserId || ""
		//alert("allotNum:"+allotNum)
		if ((allotNum<0)||(allotNum%1>0)){
			var phaDesc = allotData.phaDesc
			var errMsg = '点评药师：'+phaDesc+' 的分配数量不合法!'
			PHA.Alert('提示', errMsg, '');
			return ;
		}
		if (allotNum!="")
		{
			var params = phaUserId + "^" + allotNum ;
			inputStrArr.push(params)
		}
		
	}
	var inputStrArr = inputStrArr.toString() ;
	var saveRet = $.cm({
		ClassName: 'PHA.PRC.Create.Allot',
		MethodName: 'SaveAllotData',
		pcntId: pcntId,
		InputStr: inputStrArr,
		dataType: 'text'
	}, false);
	var saveArr = saveRet.split('^');
	var saveVal = saveArr[0];
	var saveInfo = saveArr[1];
	if (saveVal < 0) {
		PHA.Alert('提示', saveInfo, 'warning');
		return;
	} else {
		PHA.Popover({
			msg: '保存成功',
			type: 'success'
		});
	$("#gridPhaDetail").datagrid("reload") ;
	$("#gridComment").datagrid("reload") ;
	$("#gridPha").datagrid("reload") ;
	}
	
}