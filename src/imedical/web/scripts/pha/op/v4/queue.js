var hisPatNoLen=""; //�ǼǺų���
var Com_Pid="";
$(function () {
	GetPhaHisCommonParmas();	//�ǼǺų���
	InitDict();
	InitWaitRepQueue();
	$("#btnFind").on("click", Query);
	$("#btnReadCard").on("click", BtnReadCardHandler);
	$("#btnReport").on("click", RepQueue);
	$("#btnClean").on("click", Clean);
	$('#conPatNo').on('keypress', function (event) {
		if (window.event.keyCode == "13") {
			var patno = $.trim($("#conPatNo").val());
			if (patno != "") {
				var newpatno = NumZeroPadding(patno, hisPatNoLen);
				$(this).val(newpatno);
				if(newpatno==""){return;}
				Query();
			}
		}
	});
	$('#conCardNo').on('keypress', function (event) {
		if (window.event.keyCode == "13") {
			var cardNo = $.trim($("#conCardNo").val());
			if (cardNo != "") {
				BtnReadCardHandler();
			}
		}
	});

})
function InitDict(){
	$('#conPhStDate').datebox('setValue', 't-1');
    $('#conPhEndDate').datebox('setValue', 't');


}
function InitWaitRepQueue(){
	var columns = [[
		{field: 'PapmiId',title: 'AdmId',width: 100,hidden: true},
		{field: 'AdmId',title: 'AdmId',width: 100,hidden: true},
		{field: 'PatNo',title: '�ǼǺ�',width: 100},
		{field: 'PatName',title: '����',width: 100},
		{field: 'PrtDate',title: '�շ�����',width: 100},
		{field: 'PrescNo',title: '������',width: 100},
		{field: 'phwId',title: '����id',width: 100,hidden: true},
		{field: 'phwDesc',title: '���ں�',width: 100},
		{field: 'PatAge',title: '����',width: 100,hidden: true},
		{field: 'PatSex',title: '�Ա�',width: 100,hidden: true},
		{field: 'DiagDesc',title: '���',width: 100},
        {field: 'PrescItmArr',title: 'ҩƷ����',width: 250,formatter: PHA_OP.Grid.Formatter.InciGroup},
        {field: 'Qty',title: '����',width: 60,formatter: PHA_OP.Grid.Formatter.QtyUomGroup},
        {field: 'InstDesc',title: '�÷�',width: 60,formatter: PHA_OP.Grid.Formatter.InstGroup},
        {field: 'DoseQty',title: '����',width: 60,formatter: PHA_OP.Grid.Formatter.DosageGroup},
        {field: 'FreqDesc',title: 'Ƶ��',width: 60,formatter: PHA_OP.Grid.Formatter.FreqGroup},
        {field: 'Pid',title:'����id',width: 80,hidden:true} //
    ]];
    var dataGridOption = {
	    url: $URL,
        queryParams: {            
            ClassName: 'PHA.OP.Queue.Query',
            QueryName: 'QueryPresc',
            pJsonStr: JSON.stringify({ hospId: PHA_COM.Session.HOSPID }),
            rows: 999
        },
        columns: columns,
        singleSelect: true,
	    selectOnCheck: false,
	    checkOnSelect: false,
        rownumbers:true,
        fitColumns: true,
        pagination: false,
        onRowContextMenu:"",
        pageSize:9999,
        toolbar: '#gridPhWinLogBar',
        onLoadSuccess: function(data) {
        }
        
    };
    PHA.Grid('gridWaitRepQueue', dataGridOption);
}

function Query(){
	var pJson = {};
	pJson.locId = session['LOGON.CTLOCID'];	
	pJson.startDate =  $("#conPhStDate").datebox("getValue")|| ""; ;
	pJson.endDate =  $("#conPhEndDate").datebox("getValue")|| ""; ;	
	pJson.patNo =  $("#conPatNo").val() || "";
	$("#gridWaitRepQueue").datagrid("query",{
		pJsonStr: JSON.stringify(pJson),
	});  

}
function RepQueue(){
	var gridData=$("#gridWaitRepQueue").datagrid("getData").rows;
	var dataRows=gridData.length;
	if(dataRows==0){ PHA.Popover({
            msg: 'û������',
            type: 'alert'
        });
        return;
    }

	var prescNoStr=""
    for (var i = 0; i < dataRows; i++) {
        var rowData = gridData[i];
        var prescNo=rowData.PrescNo;
        if(prescNoStr==""){
	        prescNoStr=prescNo;
	    }else{
		    prescNoStr=prescNoStr+"!!"+prescNo;
		}
    }

	var retInfo=tkMakeServerCall("PHA.OP.Queue.OperTab","CreatQueue",prescNoStr,"2",session['LOGON.USERID']);
	PHA.Popover({
        msg: retInfo,
        type: 'alert',
        timeout: 5000
    });
    //PrintQueueLab(retInfo)


}
//����
function BtnReadCardHandler() {
	var readcardoptions = {
		CardTypeId: "",
		CardNoId: "conCardNo",
		PatNoId: "conPatNo"
	}
	PHA_COM.ReadCard(readcardoptions, Query) ; 
}
function Clean(){
	//$("#conPhLoc").combobox("setValue", session['LOGON.CTLOCID']);
	$('#conPhStDate').datebox('setValue', 't-1');
    $('#conPhEndDate').datebox('setValue', 't');
	$("#conPatNo").val('')
	$("#conCardNo").val('')
	$('#gridWaitRepQueue').datagrid('clear');
	
	
}
function PrintQueueLab(QueueInfo)
{
	if(QueueInfo==""){return;}
	var queueArr=QueueInfo.split("!!")
	var len=queueArr.length;
	var arr=[];
	for(var i=0;i<len;i++){
		var rowData=queueArr[i];
		var rowArr=rowData.split("^");
		var iJson = {
	  		locDesc:rowArr[0],
            winDesc: rowArr[1],
            queueNo:rowArr[2]
               
        };
		arr.push(iJson)
	}
	
	var List=JSON.stringify(arr)
	
	PRINTCOM.XML({
		printBy: 'lodop',
		XMLTemplate: 'PHAOPQueueLab',
		data: {
			List: List
		},
		listBorder: {style:4, startX:1, endX:180},
	});

}