/**
 * ����:	 ��������-�����������
 * ��д��:	 dinghongying
 * ��д����: 2019-05-17
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
// �¼�
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

// �ֵ�
function InitDict() {
	// ��ʼ��-����
	var today = new Date() ;
	PHA.DateBox("conStartDate", {});
	PHA.DateBox("conEndDate", {});
}

/// ������Ϣ��ʼ��
function InitSetDefVal() {
	//��������
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
            { field: "pcntNo", title: '����',width: 120, },
            { field: 'pcntDate', title: '����', width: 100},
            { field: "pcntTime", title: 'ʱ��' ,width: 100},
            { field: "pcntUserName", title: '�Ƶ���',width: 120  },
            { field: "typeDesc", title: '����',width: 80, },
            { field: 'wayDesc', title: '��ʽ', width: 120},
            { field: "itmNum", title: '������ϸ����' ,width: 120},
            { field: 'unAllotNum', title: '�ɷ�������', width: 100},
            { field: "pcntText", title: '��ѯ����' ,width: 120, hidden:true}
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
            { field: "phaId", title: '����ҩʦId',width: 100, hidden: true },
			{ field: "phaUserId", title: 'ҩʦUserId',width: 100, hidden: true },
			{ field: "phaGroup", title: 'ҩʦ����',width: 120},
			{ field: "phaCode", title: 'ҩʦ����',width: 120},
            { field: "phaDesc", title: 'ҩʦ����',width: 120},
            { field: "prescNum", 
				title: '��������',
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
        	{ field: "phaUserGroup", title: 'ҩʦ����',width: 120 },
            { field: "phaUserName", title: 'ҩʦ����', width: 120 },
            { field: "allotNum", title: '�ѷ�������',width: 200 }
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
		$.messager.alert('��ʾ',"����ѡ�е�����!","info");
		return;
	}
	var pcntId=gridSelect.pcntId;
	if (pcntId==''){
		$.messager.alert('��ʾ',"û�л�ȡ��������Id��������ѡ�������!","info");
		return;
	}
	$('#gridPha').datagrid('endEditing');
	var gridChanges = $('#gridPha').datagrid('getChanges');
	var gridChangeLen = gridChanges.length;
	if (gridChangeLen == 0) {
		PHA.Popover({
			msg: "û����Ҫ���������",
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
			var errMsg = '����ҩʦ��'+phaDesc+' �ķ����������Ϸ�!'
			PHA.Alert('��ʾ', errMsg, '');
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
		PHA.Alert('��ʾ', saveInfo, 'warning');
		return;
	} else {
		PHA.Popover({
			msg: '����ɹ�',
			type: 'success'
		});
	$("#gridPhaDetail").datagrid("reload") ;
	$("#gridComment").datagrid("reload") ;
	$("#gridPha").datagrid("reload") ;
	}
	
}