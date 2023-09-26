
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
		{field:"EpisodeID",title:'EpisodeID',width:90,hidden:true},
		{field:"oeori",title:'oeori',width:90,hidden:true},
		{field:"LabTestSetRow",title:'LabTestSetRow',width:90,hidden:true},
		{field:'arcitmcode',title:'����',width:100},
		{field:'arcitmdesc',title:'����',width:300},
		{field:'SpecName',title:'��������',width:200},
		{field:'recdate',title:'��������',width:100},
		{field:'rectime',title:'����ʱ��',width:100},
		//{field:'HisResult',title:'���ν��',width:80,formatter:frameHisResult}
	]];
	
	$('#Lab').datagrid({
		url:'',
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:40,        // ÿҳ��ʾ�ļ�¼����
		pageList:[40,80],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...',
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
			var LabDate=rowData.recdate;
			///����columns
			var columns=[[
				{field:"itmcode",title:'��Ŀ���',width:80},
				{field:"itmname",title:'��Ŀ����',width:200},
				{field:'units',title:'��λ',width:70},
				{field:'itmval',title:'����ֵ',width:80,formatter:SetCellColor},
				{field:'ItmRange',title:'�ο���Χ',width:100},
				{field:'AbnorFlag',title:'�쳣���',width:90,hidden:true},
				{field:'ItemRes',title:'������',width:220,hidden:true},
				{field:'AddSign',title:'��ӱ�־',width:80,align:'center'}
			]];

			$('#ddv-'+index).datagrid({
				//title:'����ֵ',    
				url:'',
				border:false,
				rownumbers:true,
				columns:columns,
			    singleSelect:true,
				loadMsg: '���ڼ�����Ϣ...',
			    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
			    var text=LabDate+" "+rowData.itmname+":"+rowData.itmval+" "+rowData.units+"["+rowData.ItmRange+"]";
			            callBack(text);
		            $("tr[datagrid-row-index="+rowIndex+"]"+" "+"td[field=AddSign]"+" "+"div").html("<img src='../scripts/dhcpha/images/accept.png' border=0/>");
		        },
				rowStyler:function(rowIndex,rowData){
					if (rowData.AbnorFlag!="N"){
						return 'color:red;font-weight:bold;';
					}
				}
			});
			///�Զ�����
			$('#ddv-'+index).datagrid({
				url:url+'?action=LabItmsValue',
				queryParams:{
					LabTestSetRow:rowData.LabTestSetRow,
					rows:"100",
					page:'1'
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
		width:870,
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
		url:url+'?action=GetPatLabList',
		queryParams:{
			EpisodeID:AdmDr,
			param:""
		}
	});
	//initScroll("#Lab");  liyarong 2016-09-21
	$('#Lab').datagrid('loadData', {total:0,rows:[]});  //sufan 2016/09/21
}

//��������ɫ  formatter="SetCellColor"
function SetCellColor(value, rowData, rowIndex)
{
	var color="";
	if(rowData.AbnorFlag=="N"){
		color="green";
	}else{
		color="red";}
	return '<span style="font-weight:bold;color:'+color+'">'+value+'</span>';
}

/// ���μ�����
function  frameHisResult(value,rowData,rowIndex){
   // return "<a href='#' mce_href='#' onclick='showHisResultWin("+rowIndex+");'>���ν��</a>";  
}

function showHisResultWin(rowIndex)
{
	var oeori=$("tr[datagrid-row-index="+rowIndex+"] "+"td[field=oeori]").text();
	window.open("dhclabviewoldresult.csp?PatientBanner=1&OrderID="+oeori+"&StartDate=",'','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,width=1250,height=670,left=80,top=10');
}