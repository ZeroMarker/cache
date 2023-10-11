/*
ģ��:		סԺ��ҩ��
��ģ��:		סԺ��ҩ��-��ҩҩ��װ��
Creator:	hulihua
CreateDate:	2018-01-16
*/
var tmpSplit=DHCPHA_CONSTANT.VAR.MSPLIT;
var phboxnum="";
$(function(){
	/* ��ʼ����� start*/
	//$("#date-daterange").dhcphaDateRange();
	//�����ڿؼ�����ʼ��ֵ��
	//startdate=FormatDateT("t-3");
	//$("#date-daterange").data('daterangepicker').setStartDate(startdate);
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
	var startdate = FormatDateT("t-3") ;
	var enddate = FormatDateT("t") ;
    //var starttime = '00:00:00';
    //var endtime = '23:59:59';
    $('#date-start').data('daterangepicker').setStartDate(startdate);		// + ' ' + starttime
    $('#date-start').data('daterangepicker').setEndDate(startdate);			// + ' ' + starttime
    $('#date-end').data('daterangepicker').setStartDate(enddate);			// + ' ' + endtime
    $('#date-end').data('daterangepicker').setEndDate(enddate);				// + ' ' + endtime
	InitPhaWard();
	InitMedBatNo();				//��ҩ����
	InitMedBoxNum();
    InitPackBatNoList();
    InitPackBatNoDetList();

	//�������лس��¼�
	$("button").on("keypress",function(e){
		if(window.event.keyCode == "13"){
			return false;
		}
	})
	
	$("#chk-haspackbox").on("ifChanged",function(){
		//QueryGridBroPack();
	})
	
	InitPhBoxNumModal();
	ResizeGrid();
})

window.onload=function(){
	setTimeout("QueryGridBroPack()",500);
}

//��ʼ����ҩ����
function InitMedBatNo(){
	var data = [
		{ id: "", text: '' },
		{ id: 1, text: '��һ��' },
		{ id: 2, text: '�ڶ���' }
	 ];
	var selectoption={
	  data: data,
      width:'8em',
      allowClear:true,
      minimumResultsForSearch: Infinity
	};
	$("#sel-medbatno").dhcphaSelect(selectoption);
	$("#sel-medbatno").on('select2:select', function (event) { 
		QueryGridBroPack();
	})			
}

//��ʼ������ѡ��
function InitMedBoxNum(){
	var data = [
		{ id: 1, text: 'һ��' },
		{ id: 2, text: '����' },
		{ id: 3, text: '����' },
		{ id: 4, text: '����' },
		{ id: 5, text: '����' }
	 ];
	var selectoption={
	  data: data,
      width:'16em',
      allowClear:false,
      minimumResultsForSearch: Infinity
	};
	$("#sel-phboxnum").dhcphaSelect(selectoption);			
}

//����׷�ٲ�ѯ
function PrescNoTrackQuery(){
	$td = $(event.target).closest("td");
	var rowid=$td.closest("tr.jqgrow").attr("id");
	var selectdata=$('#grid-brobatnodetail').jqGrid('getRowData',rowid);
	var prescNo=selectdata.TPrescNo;
	var TAdm=selectdata.TAdm;
	var prescNo=$.jgrid.stripHtml(prescNo);
	var lnk="dhcpha/dhcpha.inpha.hmpresctimeline.csp?gPrescNo="+prescNo;
	window.open(lnk,"_target","width="+(window.screen.availWidth/2+100)+",height="+(window.screen.availHeight-50)+ ",menubar=no,status=yes,toolbar=no,resizable=yes,top='0',left='110',location=no") ;
	//var lnk="dhcpha/dhcpha.inpha.hmprescnotrack.csp?gPrescNo="+prescNo+"&Adm="+TAdm;
	//window.open(lnk,"_target","width="+(window.screen.availWidth-50)+",height="+(window.screen.availHeight-100)+ ",menubar=no,status=yes,toolbar=no,resizable=yes,top='0',left='110',location=no") ;

}

//��ʼ����ҩ�����б�
function InitPackBatNoList(){
	//����columns
	var columns=[
		{header:'TPid',index:'TPid',name:'TPid',width:30,hidden:true},
		{header:'TWardLocDr',index:'TWardLocDr',name:'TWardLocDr',width:30,hidden:true},
		{header:'TPhmbiStr',index:'TPhmbiStr',name:'TPhmbiStr',width:30,hidden:true},
		{header:'����',index:'TWardLoc',name:'TWardLoc',width:120,align:'left'},
		{header:'����',index:'TBrothBatNo',name:'TBrothBatNo',width:20},
		{header:'����',index:'TActUnPocNum',name:'TActUnPocNum',width:40}
    ];
         
    var jqOptions={
	    colModel: columns, //��
		url:LINK_CSP+'?ClassName=web.DHCINPHA.HMMedBroth.MedBrothDispQuery&MethodName=GetBrothPackList',
		shrinkToFit:false,
		rownumbers: true,
		height:GridCanUseHeight(1)*0.45,
		onSelectRow:function(id,status){
			QueryBroPackDetail();
		},
		loadComplete: function(){ 
			var grid_records = $(this).getGridParam('records');
			if (grid_records==0){
				$("#grid-brobatno").clearJqGrid();
			}else{
				$(this).jqGrid('setSelection',1);
			}
		}
	} 
   //����datagrid	
   $('#grid-brobatno').dhcphaJqGrid(jqOptions);
}

//��ʼ����ҩ������ϸ�б�
function InitPackBatNoDetList(){
	//����columns
	var columns=[
		{header:'TphmbiId',index:'TphmbiId',name:'TphmbiId',width:5,hidden:true},
		{header:'����',index:'TWardLoc',name:'TWardLoc',width:100,align:'left'},
		{header:'��������',index:'TPatName',name:'TPatName',width:100},
		{header:'������',index:'TPrescNo',name:'TPrescNo',width:80
		/*
			formatter:function(cellvalue, options, rowObject){
			    return "<a onclick=\"PrescNoTrackQuery()\" style='text-decoration:underline;'>"+cellvalue+"</a>";
			}
			*/
		},
		{header:'��ҩ����',index:'TBrothDate',name:'TBrothDate',width:100},
		{header:'����',index:'TActUnPocNum',name:'TActUnPocNum',width:80},
		{header:'����',index:'TJarNum',name:'TJarNum',width:80,hidden:true},
	    {header:'��ҩ��',index:'TBrothName',name:'TBrothName',width:80},
		{header:'��ҩ����',index:'TActBrothDate',name:'TActBrothDate',width:100},
		{header:'ҩ����ǰ״̬',index:'TBrothStatue',name:'TBrothStatue',width:60},
		{header:'��ע',index:'TRemark',name:'TRemark',width:80},
		{header:'TAdm',index:'TAdm',name:'TAdm',width:80,hidden:false}
    ];        
    var dataGridOption={
	    colModel: columns, //��
		url:ChangeCspPathToAll(LINK_CSP)+'?ClassName=web.DHCINPHA.HMMedBroth.MedBrothDispQuery&MethodName=GetBroPackDetList',
		height:GridCanUseHeight(1)*0.39,
		shrinkToFit:false,
		rownumbers: true,
		autoScroll:true
	} 
   //����datagrid	
   $('#grid-brobatnodetail').dhcphaJqGrid(dataGridOption);
}

///��ѯ��Ҫװ��Ľ�ҩ�����б�
function QueryGridBroPack()
{
	KillDetailTmp();
	$("#grid-brobatnodetail").jqGrid("clearGridData");
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
	var medbatno=$('#sel-medbatno').val();
	if (medbatno==null){medbatno=""};
	var packboxflag="N"
	if($("#chk-haspackbox").is(':checked')){
		packboxflag="Y";
	}	
	var params=startdate+tmpSplit+enddate+tmpSplit+wardLoc+tmpSplit+medbatno+tmpSplit+packboxflag
	+tmpSplit+DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID;

	$("#grid-brobatno").setGridParam({
		postData:{
			'params':params
		}
	}).trigger("reloadGrid");
}

///��ѯ��ϸ
function QueryBroPackDetail(){
	var selectid = $("#grid-brobatno").jqGrid('getGridParam', 'selrow');
	if(selectid==null){
		return;	
	}
	var selrowdata = $("#grid-brobatno").jqGrid('getRowData', selectid);
	var pid=selrowdata.TPid;
	if((pid==null)||(pid=="")){
		return;
	}
	var wardlocdr=selrowdata.TWardLocDr;
	var brothbatno=selrowdata.TBrothBatNo;
	var params=pid+tmpSplit+wardlocdr+tmpSplit+brothbatno;
	$("#grid-brobatnodetail").setGridParam({
		postData:{
			'params':params
		}
	}).trigger("reloadGrid");
}

//������Աѡ��
function InitPhBoxNumModal(){
	$("#btn-boxnum-sure").on("click",function(){
		var phboxnum=$('#sel-phboxnum').val();
		if ((phboxnum=="")||(phboxnum==null)){
			dhcphaMsgBox.alert("��������Ϊ��!");
			return;
		}
		$('#modal-boxnum').modal('hide');
		var dispoptions={
			phboxnum:phboxnum
		}
		SavePackBoxUp(dispoptions);
	});	
}

///ȷ��װ��
function ConfirmPackBoxUp(){
	var selectid = $("#grid-brobatno").jqGrid('getGridParam', 'selrow');
	var selrowdata = $("#grid-brobatno").jqGrid('getRowData', selectid);
	var phmbistr=selrowdata.TPhmbiStr;
	var wardlocdesc=selrowdata.TWardLoc;
	var brobatno=selrowdata.TBrothBatNo;
	if ((phmbistr=="")||(phmbistr==null)){
		dhcphaMsgBox.alert("����ѡ����Ҫװ���������Ϣ��");
		return;
	}
	$('#modal-boxnum').modal('show');
	$('#wardinfo').text(wardlocdesc);
	$('#batnoinfo').text("��"+brobatno+"��");
}

///װ�����
function SavePackBoxUp(dispoptions){
	var selectid = $("#grid-brobatno").jqGrid('getGridParam', 'selrow');
	var selrowdata = $("#grid-brobatno").jqGrid('getRowData', selectid);
	var phmbistr=selrowdata.TPhmbiStr;
	var brothbatno=selrowdata.TBrothBatNo;
	var wardlocdr=selrowdata.TWardLocDr;
	var boxnum=dispoptions.phboxnum;
	var SaveDataStr=brothbatno+tmpSplit+gLocId+tmpSplit+wardlocdr+tmpSplit+gUserID+tmpSplit+boxnum;
	var resultStr=tkMakeServerCall("web.DHCINPHA.HMMedBroth.MedBrothDispQuery","SavePackBoxUpData",phmbistr,SaveDataStr);
	var resultArr=resultStr.split("^");
	var ret=resultArr[0];
	if(ret!=0){
		dhcphaMsgBox.alert("װ��ʧ��,"+resultArr[1]);
		return;
	}else{
		var phboxid=resultArr[1];
		KillDetailTmp();
		PrintHmPhBoxLabelL(phboxid,"");		//��ӡ����ǩ
		QueryGridBroPack();
	}
}

///���
function ClearConditions(){
	KillDetailTmp();
	$("#date-start").data('daterangepicker').setStartDate(FormatDateT("t-3"));
	$("#date-start").data('daterangepicker').setEndDate(FormatDateT("t-3"));
	$("#date-end").data('daterangepicker').setStartDate(FormatDateT("t"));
	$("#date-end").data('daterangepicker').setEndDate(FormatDateT("t"));
	$('#chk-haspackbox').iCheck('uncheck');
	$("#sel-phaward").empty();
	$("#sel-medbatno").select2('val','""')
	$('#grid-brobatno').clearJqGrid();
	$('#grid-brobatnodetail').clearJqGrid();
}

///�����ʱglobal
function KillDetailTmp(){
	var Pid="";
	if ($("#grid-brobatno").getGridParam('records')>0){
		var firstrowdata = $("#grid-brobatno").jqGrid("getRowData", 1);
		Pid=firstrowdata.TPid;
	}			
	if (Pid!=""){
		var killret=tkMakeServerCall("web.DHCINPHA.HMMedBroth.MedBrothDispQuery","KillDetailTmp",Pid);
	}
}

///�쳣�ر�
window.onbeforeunload = function (){
	KillDetailTmp();
}

window.onresize = ResizeGrid;

function ResizeGrid() {
	var winWidth=$(window).width()
	var gridWidth=winWidth-22
	$("#grid-brobatno").setGridWidth(gridWidth);
	//$("#grid-brobatno").setGridHeight(detailHeight);
	$("#grid-brobatnodetail").setGridWidth(gridWidth);
	//$("#grid-brobatnodetail").setGridHeight(detailHeight);
}
