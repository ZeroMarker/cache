/**
 * ģ��:     �ٹ���������
 * ��д����: 2022-03-31
 * ��д��:   yangshijie
 */

$(function () {
	InitHospCombo();
    InitDict();
    InitGrid();
    QueryBusi();
    InitProData();
});

function InitHospCombo() {
    var genObj = GenHospComp('CF_PHA_IN.Business', '', { width: 230 });
    //����ѡ���¼�
    $('#_HospList').combogrid('options').onSelect = function (index, record) {
        var newHospId = record.HOSPRowId;
        var oldHospId = PHA_COM.Session.HOSPID;
        if (newHospId != oldHospId) {
            PHA_COM.Session.HOSPID = newHospId;
            PHA_COM.Session.ALL = PHA_COM.Session.USERID + '^' + PHA_COM.Session.CTLOCID + '^' + PHA_COM.Session.GROUPID + '^' + PHA_COM.Session.HOSPID;
            Clear();
            InitProData();
        }
    };
}

function InitProData() {
    //��ʼ������
    PHA.CM(
        {
            pClassName : 'PHA.IN.Busiprocess.Api',  
            pMethodName: 'InitBusiData',
            pJson   : JSON.stringify({hospId: PHA_COM.Session.HOSPID}),
        },
        function (retData) {
            //if (PHA.Ret(retData)) {
            //    QueryBusi();
            //} 
            if(retData.code < 0){
	            PHA.Msg('alert', retData.msg);
		    	return false
            }
            QueryBusi();
        }
    );
}

function QueryBusi(){
	$('#gridBusi').datagrid('query', {
        pJson : JSON.stringify({hospId:PHA_COM.Session.HOSPID}),
    });
}

function QueryPro() {
	ClearUser();
    var busiId = GetBusiId();
    if (!busiId) 
    {	
    	ClearProcess();
    	return;
    }
    $('#gridProcess').datagrid('query', {
        pJson : JSON.stringify({busiId:busiId}),
    });
}

function QueryUser() {
	ClearUser();
    var bpId = GetBpId();
    if (!bpId) return;
    $('#gridUser').datagrid('query', {
        pJson : JSON.stringify({bpId:bpId}),
    });
}


function GetBusiId(){
	var gridSelect = $('#gridBusi').datagrid('getSelected') || '';
    if (gridSelect) return gridSelect.busiId;
    return "";
}

function GetBpId(){
	var gridSelect = $('#gridProcess').datagrid('getSelected') || '';
    if (gridSelect) return gridSelect.bpId;
    return "";
}

function Clear()
{
	ClearBusi();
	ClearProcess();
	ClearUser();
}

function ClearBusi(){
    $('#gridBusi').datagrid('loadData', []);
}

function ClearProcess(){
    $('#gridProcess').datagrid('loadData', []);
}

function ClearUser(){
    $('#gridUser').datagrid('loadData', []);
}

function InitDict() {
	$(".icon-help").popover({title:'��ܰ��ʾ',width:"400",content: $g("1.ϵͳ���̲��ɱ༭��<br>2.'����'ָ�Ѿ�ִ�й�������������ȡ����˺󽫵��ݷ�棬�������ٽ����κ��޸Ĳ�����<br>3.'��������'ָ�����̵���ռ��һ��ҵ��������档")});
}

function InitGrid(){
	InitGridBusi();
	InitGridProcess();
	InitGridUser();
}

function InitGridBusi(){
	var columns = [
        [
            // busiId, busiCode, busiCode, shortName, minLevel
            { field: 'busiId', 			title: 'busiId', 		hidden: true },
            { field: 'busiCode', 		title: 'ҵ�����', 		width: 50, 		align: 'left' },
            { field: 'busiDesc', 		title: 'ҵ������', 		width: 80, 		align: 'left' },
            { field: 'shortName', 		title: 'ҵ����', 		width: 50,		align: 'center' },
            { field: 'minLevel', 		title: '��С�ȼ�', 		width: 50,		align: 'center' },
        ]
    ];
    var dataGridOption = {
        url: PHA.$URL,
        queryParams: {
            pClassName : 'PHA.IN.Busiprocess.Api',
            pMethodName: 'QueryBusi',
            pPlug	   : "datagrid",
            pJson   : JSON.stringify({hospId:PHA_COM.Session.HOSPID}),
        },
        exportXls: false,
        fitColumns: true,
        fit: true,
        columns: columns,
        pagination: false,
        //idField: 'busiId',
        toolbar: '#gridBusiBar',
        onClickRow: function (rowIndex, rowData) {
             QueryPro();
        },
        onDblClickRow: function (rowIndex, rowData) {
	        if (rowData) {
                if (rowData.DefaultFlag != 'Y') {
                    $(this).datagrid('beginEditRow', {
                        rowIndex: rowIndex,
                        editField: 'configCode',
                    });
                }
            }
        }
    };
    PHA.Grid('gridBusi', dataGridOption);
}

function InitGridProcess() {
    var columns = [
        [
            // bpId,bpCode,bpDesc,level,defaultFlag,activeFlag,bindOperDesc
            { field: 'bpId', title: 'bpId', hidden: true },
            {
				title: "���̴���",
				field: "bpCode",
				width: 100,
				align: "left",
				editor: PHA_GridEditor.ValidateBox({
					required: true
				})
			},
			{
				title: "��������",
				field: "bpDesc",
				width: 100,
				align: "left",
				editor: PHA_GridEditor.ValidateBox({
					required: true
				})
			},
            { field: 'level', 			title: '���̵ȼ�', 	align: 'center', 	width: 60 	},
            { field: 'bpType',			title: '��������',	align: 'center',	width: 60	,formatter:TypeFormatter}, 
            { field: 'activeFlag',		title: 'ʹ��״̬',	align: 'center',	width: 60,
                editor: PHA_GridEditor.CheckBox({})	,
                formatter: PHA_GridEditor.CheckBoxFormatter
            },
            { field: 'bindOperDesc', 	title: '�󶨲���', 	align: 'center', 	width: 60 	},
            { field: 'standFlag',	 	title: '��������',	align: 'center',	width: 60	,formatter: StandFormatter},  

        ]
    ];
    var dataGridOption = {
        url: PHA.$URL,
        queryParams: {
            pClassName : 'PHA.IN.Busiprocess.Api',
            pMethodName: 'QueryProcess',
            pPlug	   : "datagrid",
            pJson   : JSON.stringify({}),
        },
        gridSave: false,
        exportXls: false,
        fitColumns: true,
        fit: true,
        isCellEdit: false,
        columns: columns,
        pagination: false,
        idField: 'bpId',
        toolbar: '#gridProcessBar',
        onClickRow: function (rowIndex, rowData) {
	        if (!PHA_GridEditor.EndCheck("gridProcess")) return;
            QueryUser();
            if (rowData.standFlag == 'Y') $('#AddUser').linkbutton('disable');
            else $('#AddUser').linkbutton('enable');
        },
        onDblClickRow: function (rowIndex, rowData) {
	        if (rowData) {
		     	if (!PHA_GridEditor.EndCheck("gridProcess")) return;
		        var bpCode = rowData.bpCode 
		        var bpType = rowData.bpType 
		        if(bpType == "CUSTOM"){
			        //$('#gridProcess').datagrid('options').isCellEdit = false;
			        PHA_GridEditor.Edit({
						gridID: "gridProcess",
						index: rowIndex,
						field: "bpCode"
					});
		        }
            }
        }
    };
    PHA.Grid('gridProcess', dataGridOption);
}


function TypeFormatter(value, row, index){
	if (value == 'SYS') {
        return "ϵͳ";
    } else if (value == 'CUSTOM') {
        return "�Զ���";
    }else  if (value == 'SPECIAL') {
        return "����";
    }else {
    	return "";
	}
}


function StandFormatter(value, rowData, rowIndex) {
    //������󴫲���ȥ,ת���ַ����ʹ���ȥ��,��Ӧ��������ȡֵ�ֳ��˶���
	var dataString=JSON.stringify(rowData)
    var IndexString = JSON.stringify(rowIndex)
    var standFlag = rowData.standFlag;
    if (standFlag == 'Y'){
        if (PHA_COM.IsLiteCss) {
            return "<span onclick='addInci("+ dataString +",+"+IndexString+")' class='icon-w-ok'></span>";
        }
        else {
            return "<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/accept.png' border=0/>";
        }
    }
}


function InitGridUser() {
    var columns = [
        [
            { field: 'bpuId', title: 'TDPPI', hidden: true },
            { field: 'userCode', title: '��Ա����',     align: 'left',  width: 150 },
			{ field: 'userId',	title: '��Ա����',		width: 180,	  	descField: 'userName',
                editor: PHA_GridEditor.ComboBox({
					tipPosition: 'top',
					url: PHA_STORE.SSUser().url,
                    width: 180,
				}),
                formatter: function (value, row, index) {
                    return row.userName;
                }
            },
			{ field: 'userName', title: '��Ա����', hidden: true, width: 180 },
        ]
    ];
    var dataGridOption = {
        url: PHA.$URL,
        queryParams: {
            pClassName : 'PHA.IN.Busiprocess.Api',
            pMethodName: 'QueryUser',
            pPlug	   : "datagrid",
            pJson   : JSON.stringify({}),
        },
        //fitColumns: true,
        exportXls: false,
        fit: true,
        columns: columns,
        pagination: true,
        showRefresh: false,
        showPageList: false,
        afterPageText:'',
        beforePageText:'',
        displayMsg:'�� {total} ����¼',
        toolbar: '#gridUserBar',
        onClickRow: function (rowIndex, rowData) {
            if (!rowData.TDPPI) {
                PHA_GridEditor.Edit({
					gridID: "gridUser",
					index: rowIndex,
					field: "userId"
				});
            }
        },
    };
    PHA.Grid('gridUser', dataGridOption);
}

//* ---------������------Start------------*//
// ��������
function AddPro() {
	var busiId = GetBusiId();
	if (!busiId){
	    PHA.Msg('alert' ,"��ѡ��һ��ҵ�����ͣ�");
	    return;
    }
	PHA_GridEditor.Add({
		gridID: 'gridProcess',
		field: 'bpCode',
		checkRow: true,
		rowData:{
			activeFlag:"Y"
		}
	});
}


// ���������
function AddUser() {
	var bpId = GetBpId();
	if (!bpId){
	    PHA.Msg('alert' ,"��ѡ��һ�����̣�");
	    return;
    }
	PHA_GridEditor.Add({
		gridID: 'gridUser',
		field: 'userId',
		checkRow: true
	});
}
//* ---------������------End------------*//

//* ---------����+ɾ��------Start------------*//
// ��������
function SavePro() {
    if (!PHA_GridEditor.EndCheck("gridProcess")) return;
    var gridChanges = $('#gridProcess').datagrid('getChanges');
    var gridChangeLen = gridChanges.length;
    if (!gridChangeLen){
	    PHA.Msg('alert' ,"û����Ҫ��������ݣ�");
	    return;
    }
    var busiId = GetBusiId();
    if (!busiId){
	    PHA.Msg('alert' ,"��ѡ��һ��ҵ�����ͣ�");
	    return;
    }
    var pJson = {
	    hospId: PHA_COM.Session.HOSPID,
	    busiId: busiId,
	    rows  : gridChanges
    }
    PHA.CM(
        {
            pClassName : 'PHA.IN.Busiprocess.Api',  
            pMethodName: 'SavePro',
            pJson   : JSON.stringify(pJson),
        },
        function (retData) {
	        if (PHA.Ret(retData)) {
				QueryPro();
			}
        }
    )
}

function ret(Ret)
{
	if (retData.code < 0)
	{
		PHA.Msg('alert' , retData.msg );
	    return false
	}
	return true;
}

// ɾ������
function DeletePro() {
    var gridSelect = $('#gridProcess').datagrid('getSelected') || "";
    if (!gridSelect) {
        PHA.Msg('alert', "��ѡ��һ������" );
        return;
    }
    var bpId = gridSelect.bpId || '';
    if (bpId == '') {
        var rowIndex = $('#gridProcess').datagrid('getRowIndex', gridSelect);
        $('#gridProcess').datagrid('deleteRow', rowIndex);
        return;
    }
    $.messager.confirm('ȷ�϶Ի���', '��ȷ��ɾ����', function (r) {
        if (r) {
            PHA.CM(
                {
                    pClassName : 'PHA.IN.Busiprocess.Api',  
		            pMethodName: 'DeletePro',
		            pJson   : JSON.stringify({bpId: bpId, hospId: PHA_COM.Session.HOSPID}),
                },
                function (retData) {
	                if (PHA.Ret(retData)) {
		                QueryPro();
		            } 
                }
            );
        }
    });
}

// ���������Ա
function SaveUser() {
    if (!PHA_GridEditor.EndCheck("gridUser")) return;
    var gridChanges = $('#gridUser').datagrid('getChanges');
    var gridChangeLen = gridChanges.length;
    if (!gridChangeLen){
	    PHA.Msg('alert' ,"û����Ҫ��������ݣ�");
	    return;
    }
    var bpId = GetBpId();
    if (!bpId){
	    PHA.Msg('alert' ,"��ѡ��һ�����̣�");
	    return;
    }
    var pJson = {
	    hospId: PHA_COM.Session.HOSPID,
	    bpId  : bpId,
	    rows  : gridChanges
    }
    PHA.CM(
        {
            pClassName : 'PHA.IN.Busiprocess.Api',  
            pMethodName: 'SaveUser',
            pJson   : JSON.stringify(pJson),
        },
        function (retData) {
	        if (PHA.Ret(retData)) {
                QueryUser();
            } 
        }
    )
}

// ɾ�������Ա
function DeleteUser() {
    var gridSelect = $('#gridUser').datagrid('getSelected') || "";
    if (!gridSelect) {
        PHA.Msg('alert' , "��ѡ��һ�������Ա" );
        return;
    }
    var bpuId = gridSelect.bpuId || '';
    if (bpuId == '') {
        var rowIndex = $('#gridUser').datagrid('getRowIndex', gridSelect);
        $('#gridUser').datagrid('deleteRow', rowIndex);
        return;
    }
    $.messager.confirm('ȷ�϶Ի���', '��ȷ��ɾ����', function (r) {
        if (r) {
            PHA.CM(
                {
                    pClassName : 'PHA.IN.Busiprocess.Api',  
		            pMethodName: 'DeleteUser',
		            pJson   : JSON.stringify({bpuId: bpuId, hospId: PHA_COM.Session.HOSPID}),
                },
                function (retData) {
	                if (PHA.Ret(retData)) {
		                QueryUser();
		            }
                }
            );
        }
    });
}
//* ---------����+ɾ��------End------------*//

//* ---------�ƶ�------Start------------*//
function MovePro(MoveType) {
	
	var bpId = GetBpId();
	if (!bpId){
		PHA.Msg('alert', "��ѡ��һ�����̣�");
		return;
	}
	var pJson ={
		bpId: bpId,
		moveType: MoveType,
		hospId: PHA_COM.Session.HOSPID
	}
    PHA.CM(
        {
            pClassName : 'PHA.IN.Busiprocess.Api',  
            pMethodName: 'MovePro',
            pJson   : JSON.stringify(pJson),
        },
        function (retData) {
	        if (PHA.Ret(retData)) {
                QueryPro();
            }
        }
    )
}


//* ---------�ƶ�------End------------*//