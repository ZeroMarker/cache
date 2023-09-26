/*
ģ��:		��ҩ��
��ģ��:		��ҩ��-�ֹ���¼��������ѯ
Creator:	hulihua
CreateDate:	2018-03-01
*/
var tmpSplit=DHCPHA_CONSTANT.VAR.MSPLIT;
$(function(){
	/* ��ʼ����� start*/
	$("#date-daterange").dhcphaDateRange();
	//�������лس��¼�
	$("input[type=text]").on("keypress",function(e){
		if(window.event.keyCode == "13"){
			return false;
		}
	})
	InitPhaLoc(); 				//ҩ������
	InitDecCond();				//״̬
    InitRecordWorkList();
	$("#recordworkdg").closest(".panel-body").height(GridCanUseHeight(1));
})

//��ʼ����ҩ�������б�
function InitRecordWorkList(){
	//����columns
	var columns=[
		{header:'������',index:'TPrescNo',name:'TPrescNo',width:80},
		{header:'ζ��',index:'TPrescNoCount',name:'TPrescNoCount',width:15},
		{header:'����',index:'TFactor',name:'TFactor',width:15},
		{header:'����',index:'TPrescForm',name:'TPrescForm',width:60},
		{header:'��ҩ��ʽ',index:'TCoookType',name:'TCoookType',width:30},
		{header:'״̬��¼��',index:'TOperator',name:'TOperator',width:100},
		{header:'״̬��¼ʱ��',index:'TOperatorDate',name:'TOperatorDate',width:120}
    ];
         
    var jqOptions={
	    colModel: columns, //��
		url:ChangeCspPathToAll(LINK_CSP)+'?ClassName=web.DHCINPHA.HMRecordWorkLoad.RecordWorkLoadQuery&MethodName=GetRecordWorkList',
		shrinkToFit:false,
		rownumbers: true,
		height:GridCanUseHeight(1)-100,
		pager: "#jqGridPager", 	//��ҳ�ؼ���id
		loadComplete: function(){
			var grid_records = $(this).getGridParam('records');
			if (grid_records!=0){
				var RecordInfo=tkMakeServerCall("web.DHCINPHA.HMRecordWorkLoad.RecordWorkLoadQuery","GetRecordInfo",gUserID);
				$('#recordinfo').text(RecordInfo);
			}else{
				$('#recordinfo').text("");
			}
		} 
	} 
   //����datagrid	
   $('#recordworkdg').dhcphaJqGrid(jqOptions);
}

///��ѯ
function QueryGridRecord()
{
	var daterange=$("#date-daterange").val();
	daterange=FormatDateRangePicker(daterange);
 	var startdate=daterange.split(" - ")[0];
	var enddate=daterange.split(" - ")[1];
	var phaLoc=$("#sel-phaloc").val();
	if (phaLoc==null){
		dhcphaMsgBox.alert("��ѡ�����!");
		return;
	}
	var deccondesc=$.trim($('#sel-deccond option:checked').text());
	var decconid=$('#sel-deccond').val();
	if ((decconid=="")||(decconid==null)){
		dhcphaMsgBox.alert("��¼״̬����Ϊ��!");
		return false;
	}
	var params=startdate+tmpSplit+enddate+tmpSplit+phaLoc+tmpSplit+deccondesc+tmpSplit+gUserID;
	$("#recordworkdg").setGridParam({
		postData:{
			'params':params
		}
	}).trigger("reloadGrid");

}
