/**
 * @author SongChao
 * @version 20180801
 * @description ��ʿִ�м��
 * @name nur.execmornitor.js
 */
var GV = {
    ClassName: "Nur.DHCADTDischarge",
    episodeID: "",
    _WARDID:session["LOGON.WARDID"],
	_CTLOCID : session['LOGON.CTLOCID']
};
var init = function () {
    initPageDom();
}
$(init)
function initPageDom() {	
    initPatSearchbox();
    initPatTable();
    initOrderGrid();
}

/**
 *@description ��ʼ�������б�
 */
function initPatTable() {
    var wardID =GV._WARDID ;//session["LOGON.WARDID"];
    var locID =GV._CTLOCID;//  session['LOGON.CTLOCID'];
    $('#patTable').datagrid({
    	url: $URL,
    	queryParams: {
    		ClassName: GV.ClassName,
    		MethodName: 'getWardOrderErrorTimePatArray',
    		wardID: wardID,
    		locID: locID,
    		searchStr: ''
    	},
    	onSelect: function (rowIndex, rowData) {
    		setPatInfo(rowData);
    		GV.episodeID = rowData.EpisodeID;
    		orderGridReload();
    	},
    	autoSizeColumn: false,
    	fitColumns: true,
    	columns: [[{
    				field: 'BedCode',
    				title: '����',
    				width: 80,
    				styler: removeGridBorder
    			}, {
    				field: 'PatName',
    				title: '����',
    				width: 150,
    				styler: removeGridBorder
    			}, {
    				field: 'RegNo',
    				title: '�ǼǺ�',
    				width: 110,
    				styler: removeGridBorder
    			}
    		]],
    	idField: 'EpisodeID',
    	singleSelect: true,
    	width: 200,
    	showHeader: false
    });
}
/**
 * @description ȥ��grid�߿�
 * @param {*} value 
 * @param {*} row 
 * @param {*} index 
 */
function removeGridBorder(value, row, index) {
    return 'border:0;';
}
/**
 * @description ����ҳ�滼����Ϣֵ
 * @param {} patInfo :������Ϣjson����
 */
function setPatInfo(patInfo) {
    if (patInfo) {
        $('#pbarDiv').show();
    }
    for (var item in patInfo) {
        var domID = "#pbar" + item;
        $(domID).html(patInfo[item]);
    }
}

/**
 * @description ��ʼ��ҽ���б�
 */
function initOrderGrid() {
    $("#orderGrid").datagrid({
        url: $URL,
        fit: true,       
        border: false,
        autoRowHeight: false,
        showFooter: true,
        pagination: true, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
        rownumbers: true, //���Ϊtrue, ����ʾһ���к���
        pageSize: 2000,
        pageList: [2000, 4000, 6000, 8000],
        queryParams: {
            ClassName: 'Nur.DHCADTDischarge',
            MethodName: 'getWrongTimeOrderList',
            EpisodeID: GV.episodeID
        }
    });
}
/**
 *@description ҽ���б�ˢ��
 */
function orderGridReload() {
    $("#orderGrid").datagrid('reload', {
        ClassName: 'Nur.DHCADTDischarge',
        MethodName: 'getWrongTimeOrderList',
        EpisodeID: GV.episodeID
    });
}

/**
 *@description ��ʼ��������
 */
function initPatSearchbox() {
	$('#wardBox').combobox({
        valueField: 'wardID',
        textField: 'desc',
        url: $URL + '?ClassName=Nur.CommonInterface.Ward&MethodName=getAllWard',
		defaultFilter:4,
		onLoadSuccess:function(){
			var wardID = session["LOGON.WARDID"];
			if(wardID!="") {
				$('#wardBox').combobox('setValue', wardID);				
			}
		},
		onSelect:function(rec){
			GV._WARDID=rec.wardID;
			GV._CTLOCID=rec.ctLocID;
			$('#patTable').datagrid('reload', {
        		ClassName: GV.ClassName,
        		MethodName: 'getWardOrderErrorTimePatArray',
        		wardID: GV._WARDID,
        		locID: GV._CTLOCID,
        		searchStr: ''
        	});
		}
    })
	if(session["LOGON.WARDID"]!=""){
		$("#wardBox").combobox({ disabled: true });
	}
    $('#patSearchbox').searchbox({
        searcher: function (value) {
            var wardID = GV._WARDID; //session["LOGON.WARDID"];
            var locID = GV._CTLOCID; //session['LOGON.CTLOCID'];
            
			$('#patTable').datagrid('reload', {
        		ClassName: GV.ClassName,
        		MethodName: 'getWardOrderErrorTimePatArray',
        		wardID: wardID,
        		locID: locID,
        		searchStr: value
        	});
        },
        prompt: '�������ǼǺš�����'
    });
}