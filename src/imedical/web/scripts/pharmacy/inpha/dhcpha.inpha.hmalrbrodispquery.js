/*
ģ��:		סԺ��ҩ��
��ģ��:		סԺ��ҩ��-�ѽ�ҩ��ѯ
Creator:	hulihua
CreateDate:	2017-11-24
*/
var tmpSplit=DHCPHA_CONSTANT.VAR.MSPLIT;
$(function(){
	/* ��ʼ����� start*/
	//$("#date-daterange").dhcphaDateRange();
	var daterangeoptions = {
        timePicker: false,
        timePickerIncrement: 1,
        timePicker24Hour: true,
        timePickerSeconds: true,
        singleDatePicker: true,
        locale: {
            format: DHCPHA_CONSTANT.PLUGINS.DATEFMT		//+ ' HH:mm:ss'
        }
    };
    $('#date-start').dhcphaDateRange(daterangeoptions);
    $('#date-end').dhcphaDateRange(daterangeoptions);
	var startdate = FormatDateT("t") ;
	var enddate = FormatDateT("t") ;
    //var starttime = '00:00:00';
    //var endtime = '23:59:59';
    $('#date-start').data('daterangepicker').setStartDate(startdate);		// + ' ' + starttime
    $('#date-start').data('daterangepicker').setEndDate(startdate);			// + ' ' + starttime
    $('#date-end').data('daterangepicker').setStartDate(enddate);			// + ' ' + endtime
    $('#date-end').data('daterangepicker').setEndDate(enddate);				// + ' ' + endtime
    
	InitPhaWard();
    InitBroDispList();
    InitBroDispDetList();
    //�ǼǺŻس��¼�
	$('#txt-regno').on('keypress',function(event){
		if(window.event.keyCode == "13"){
			var patno=$.trim($("#txt-regno").val());
			if (patno!=""){
				var newpatno=NumZeroPadding(patno,DHCPHA_CONSTANT.DEFAULT.PATNOLEN);
				$(this).val(newpatno);
				QueryGridBroPre();
			}	
		}
	});
	
	//�������лس��¼�
	$("input[type=text]").on("keypress",function(e){
		if(window.event.keyCode == "13"){
			return false;
		}
	})
	ResizeDispQuery() ;
})

//��ʼ���ѽ�ҩ�����б�
function InitBroDispList(){
	//����columns
	var columns=[
		{header:'TPid',index:'TPid',name:'TPid',width:30,hidden:true},
		{header:'TPhmbId',index:'TPhmbId',name:'TPhmbId',width:30,hidden:true},
		{header:'�ǼǺ�',index:'TPatNo',name:'TPatNo',width:30},
		{header:'����',index:'TBedNo',name:'TBedNo',width:20},
		{header:'����',index:'TPatName',name:'TPatName',width:40},
		{header:'������',index:'TPrescNo',name:'TPrescNo',width:30},
		{header:'����',index:'TFactor',name:'TFactor',width:15},
		{header:'����',index:'TPrescForm',name:'TPrescForm',width:20},
		{header:'�÷�',index:'TInstruc',name:'TInstruc',width:30},
		{header:'�������',index:'TDocLoc',name:'TDocLoc',width:30},
		{header:'�ύ״̬',index:'TSeekType',name:'TSeekType',width:30},
		{header:'�ύ��ʿ',index:'TSeekUserName',name:'TSeekUserName',width:30},
		{header:'�ύʱ��',index:'TSeekDate',name:'TSeekDate',width:40}
    ];
         
    var jqOptions={
	    colModel: columns, //��
		url:ChangeCspPathToAll(LINK_CSP)+'?ClassName=PHA.MS.AlrBroth.Query&MethodName=GetBroDispPreList',
		shrinkToFit:false,
		rownumbers: true,
		height:GridCanUseHeight(1)*0.3+32,
		pager: "#jqGridPager", //��ҳ�ؼ���id
		onSelectRow:function(id,status){
			SelectQueryBroDetail();
			//$("#txt-regno").val("");
		},
		loadComplete: function(){ 
			var grid_records = $(this).getGridParam('records');
			if (grid_records==0){
				$("#grid-brodisppres").clearJqGrid();
			}else{
				$(this).jqGrid('setSelection',1);
			}
		}
	} 
   //����datagrid	
   $('#grid-brodisppres').dhcphaJqGrid(jqOptions);
}

//��ʼ���ѽ�ҩ��ϸ��Ϣ�б�
function InitBroDispDetList(){
	//����columns
	var columns=[
		{header:'Ӧ��ҩ����',index:'TBrothDate',name:'TBrothDate',width:30},
		{header:'��ҩ��',index:'TBrothName',name:'TBrothName',width:30},
		{header:'��ҩ����',index:'TActUnPocNum',name:'TActUnPocNum',width:30},
		{header:'ʵ�ʽ�ҩʱ��',index:'TActBrothDate',name:'TActBrothDate',width:30},
		{header:'״̬',index:'TBrothStatue',name:'TBrothStatue',width:30},
		{header:'����ʱ��',index:'TNurCheckDate',name:'TNurCheckDate',width:30},
		{header:'������',index:'TNurCheckUser',name:'TNurCheckUser',width:30},
		{header:'���տ���',index:'TWardLoc',name:'TWardLoc',width:80,align:'left'}
    ];        
    var dataGridOption={
	    colModel: columns, //��
		url:ChangeCspPathToAll(LINK_CSP)+'?ClassName=PHA.MS.AlrBroth.Query&MethodName=GetBroDispDetList',
		height:GridCanUseHeight(1)*0.4,
		shrinkToFit:false,
		rownumbers: true,
		autoScroll:true
	} 
   //����datagrid	
   $('#grid-brodispdetail').dhcphaJqGrid(dataGridOption);
}

///��ѯ��ҩ������Ϣ
function QueryGridBroPre()
{
	var params=GetComCodtion();
	$("#grid-brodisppres").setGridParam({
		postData:{
			'params':params
		}
	}).trigger("reloadGrid");
}

///��ѯ��ϸ
function SelectQueryBroDetail(){
	var selectid = $("#grid-brodisppres").jqGrid('getGridParam', 'selrow');
	if(selectid==null){
		return;	
	}
	var selrowdata = $("#grid-brodisppres").jqGrid('getRowData', selectid);
	var phmbid=selrowdata.TPhmbId;
	if((phmbid==null)||(phmbid=="")){
		return;
	}
	var params=GetComCodtion()+tmpSplit+phmbid;
	$("#grid-brodispdetail").setGridParam({
		postData:{
			'params':params
		}
	}).trigger("reloadGrid");
}

//��ȡ����Ĺ���������Ϣ
function GetComCodtion(){
	$("#grid-brodispdetail").jqGrid("clearGridData");
	/*
	var daterange=$("#date-daterange").val();
	daterange=FormatDateRangePicker(daterange);
 	var startdate=daterange.split(" - ")[0];
	var enddate=daterange.split(" - ")[1];
	*/
	var startdate = $('#date-start').val();
    var enddate = $('#date-end').val();
	var wardLoc=$("#sel-phaward").val();
	if (wardLoc==null){
		wardLoc="";
	}
	var patno=$("#txt-regno").val();	
	var params=startdate+tmpSplit+enddate+tmpSplit+wardLoc+tmpSplit+patno;
	return params;
}

//���
function ClearConditions(){
	$("#date-start").data('daterangepicker').setStartDate(FormatDateT("t"));
	$("#date-start").data('daterangepicker').setEndDate(FormatDateT("t"));
	$("#date-end").data('daterangepicker').setStartDate(FormatDateT("t"));
	$("#date-end").data('daterangepicker').setEndDate(FormatDateT("t"));
	$("#sel-phaward").empty();
	$("#txt-regno").val("");
	$('#grid-brodisppres').clearJqGrid();
	$('#grid-brodispdetail').clearJqGrid();
}

window.onresize = ResizeDispQuery;

function ResizeDispQuery() {
    var prestitleheight=$("#gview_grid-brodisppres .ui-jqgrid-hbox").height();
    var gridheight=DhcphaJqGridHeight(2,1)-prestitleheight;
	var winWidth=$(window).width()
	var gridWidth=winWidth-20
	var detailHeight=gridheight*0.5-20
	$("#grid-brodisppres").setGridWidth(gridWidth);
	$("#grid-brodisppres").setGridHeight(detailHeight);
	$("#grid-brodispdetail").setGridWidth(gridWidth);
	$("#grid-brodispdetail").setGridHeight(detailHeight);
}
