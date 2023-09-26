//����	DHCPEGSDUnitRecord.hisui.js
//����	�����ϲ�
//����	2020.05.09
//������  xy
$(function(){
	//�ֱ���
     if((screen.width=="1440")&&(screen.height=="900"))
     {
	     Height="340";
     }
	InitGSDUnitRecordGrid();  
         
})

//����
function CancelUnitRecord(UnitRecordID)
{
	
	var ret=tkMakeServerCall("web.DHCPE.GSDUnitRecord","CancelUnit",UnitRecordID)
	var Arr=ret.split("^");
	
	if (Arr[0]==0) {  
	  if (parent){
		parent.$('#UnitRecordWin').window('close');   
		parent.location.reload();
		}
	}
	
}
var Height="400"
function InitGSDUnitRecordGrid(){
	$HUI.datagrid("#GSDUnitRecordGrid",{
		url: $URL,
		height: Height,
		striped: true, //�Ƿ���ʾ������Ч��
		singleSelect: true,
		selectOnCheck: false,
		autoRowHeight: false,
		showFooter: true,
		nowrap:false,
		loadMsg: 'Loading...',
		pagination: true, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
		rownumbers: true, //���Ϊtrue, ����ʾһ���к���
		pageSize: 10,
		pageList: [10, 20, 40, 40],
		queryParams:{
			ClassName:"web.DHCPE.GSDUnitRecord",
			QueryName:"FindUnitRecord",
            GSID:GSID,
		},
		columns:[[
			{field:'TURID',title:'URID',hidden: true},
			{field:'THoldJL',width:130,title:'����'},
			{field:'TUnitDate',width:100,title:'����'},
			{field:'TUnitTime',width:100,title:'ʱ��'},
			{field:'CancelUnit',title:'����',width:'80',align:'center',
				formatter:function(value,rowData,rowIndex){
					if(rowData.TURID!=""){
						return '<a><img style="padding:0 10px 0px 0px" src="../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png"  title="����" border="0" onclick="CancelUnitRecord('+rowData.TURID+')"></a>';
					
					}
				}},
				
			
		]],
			
	});
}


