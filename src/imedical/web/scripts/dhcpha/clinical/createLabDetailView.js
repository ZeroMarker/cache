
/// Creator:    bianshuai
/// CreateDate: 2015-05-05
/// Descript:   ������ϸ��ͼ

function createLabDetailView(callBack)
{
	var LabIndex="";
	if($('#LabWin').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�

	$('body').append('<div id="LabWin"></div>');
	$('#LabWin').append('<div id="Lab"></div>');

	///����columns
	var columns=[[
		{field:"oneReportDR",title:$g('����ID')},
		{field:"OrdRowIds",title:'OrdRowIds',hidden:true},
		{field:"LabTestSetRow",title:'LabTestSetRow',hidden:true},
		{field:'LabEpisode',title:$g('�����')},
		{field:'OrdNames',title:$g('ҽ������')},
		{field:'SpecName',title:$g('��������')},
		{field:'ReqDateTime',title:$g('��������')},
		{field:'AuthDateTime',title:$g('��������')}
	]];
	
	$('#Lab').datagrid({
		url:'',
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:40,        // ÿҳ��ʾ�ļ�¼����
		pageList:[40,80],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
		loadMsg: $g('���ڼ�����Ϣ...'),
		pagination:true,
		onDblClickRow:function(rowIndex, rowData){
			$('#Lab').window('close');
		},
		view: detailview,
		detailFormatter: function(rowIndex, rowData){
			return '<div style="padding:2px;border:2px solid #95B8E7;"><div id="ddv-' + rowIndex + '" style="height:150px;border-bottom:1px solid #95B8E7;"></div></div>';
		},
		onExpandRow:function(index,rowData){
			///�۵���
			if(LabIndex!=""){
				$('#Lab').datagrid('collapseRow',LabIndex);
			}
			LabIndex = index;
			var LabDate=rowData.AuthDateTime;
			///����columns
			var columns=[[
				{field:"TestCodeCode",title:$g('��Ŀ���')},
				{field:"TestCodeName",title:$g('��Ŀ����')},
				{field:'Result',title:$g('���'),formatter:SetCellColor},
				{field:'Units',title:$g('��λ')},
				{field:'RefRanges',title:$g('�ο���Χ')},
				{field:'AbFlag',title:$g('�쳣��ʾ')},
				{field:'AddSign',title:$g('��ӱ�־'),align:'center'}
			]];

			$('#ddv-'+index).datagrid({
				//title:'����ֵ',    
				url:'',
				border:false,
				rownumbers:true,
				columns:columns,
			    singleSelect:true,
				loadMsg: $g('���ڼ�����Ϣ...'),
			    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
			    var text=LabDate+" "+rowData.TestCodeName+":"+rowData.Result+" "+rowData.Units+"["+rowData.RefRanges+"]"+";  ";
			            callBack(text);
		            $("tr[datagrid-row-index="+rowIndex+"]"+" "+"td[field=AddSign]"+" "+"div").html("<img src='../scripts/dhcpha/images/accept.png' border=0/>");
		        },
				rowStyler:function(rowIndex,rowData){
					if (rowData.AbFlag!="N"){
						return 'color:red;font-weight:bold;';
					}
				}
			});
			///�Զ�����
			$('#ddv-'+index).datagrid({
				url:'dhcapp.broker.csp',
		        queryParams:{
	     		    ClassName: 'PHA.CPW.Com.OutInterfance',
	     			MethodName: 'LabItmsValue',
					oneReportDR:rowData.oneReportDR,
		        }
			});
		}
	});

	//initScroll();//��ʼ����ʾ���������

	$('#LabWin').window({
		title:'�����б�',    
		collapsible:true,
		border:true,
		closed:"true",
		width:800,
		height:450,
		minimizable:false,						/// ������С����ť(qunianpeng 2018/3/15)
		//maximized:true,						/// ���
		//modal:true,
		onClose:function(){
			$('#LabWin').remove();  //���ڹر�ʱ�Ƴ�win��DIV��ǩ
			}
	}); 
	$('#LabWin').window('open');
	
	///�Զ�����
	$('#Lab').datagrid({
		url:'dhcapp.broker.csp',
		queryParams:{
	     		ClassName: 'PHA.CPW.Com.OutInterfance',
	     		MethodName: 'GetPatLabList',
				EpisodeID: AdmDr
			},
	});
	//initScroll("#Lab");  liyarong 2016-09-21
	$('#Lab').datagrid('loadData', {total:0,rows:[]});  //sufan 2016/09/21
}

//��������ɫ  formatter="SetCellColor"
function SetCellColor(value, rowData, rowIndex)
{
	var color="";
	if(rowData.AbFlag=="N"){
		color="green";
	}else{
		color="red";}
	return '<span style="font-weight:bold;color:'+color+'">'+value+'</span>';
}

/// ���μ�����
/*function  frameHisResult(value,rowData,rowIndex){
   // return "<a href='#' mce_href='#' onclick='showHisResultWin("+rowIndex+");'>���ν��</a>";  
}

function showHisResultWin(rowIndex)
{
	var oeori=$("tr[datagrid-row-index="+rowIndex+"] "+"td[field=oeori]").text();
	window.open("dhclabviewoldresult.csp?PatientBanner=1&OrderID="+oeori+"&StartDate=",'','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,width=1250,height=670,left=80,top=10');
}*/