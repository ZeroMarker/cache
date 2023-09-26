//����	DHCPERoomRecordDetail.hisui.js
//����  ���ҵ����Ⱥ�����
//����	2018.09.19
//������  xy

var Height="470"
$(function(){
	
	//�ֱ���
    var userAgent = navigator.userAgent;
	var isChrome =  navigator.userAgent.indexOf('Chrome') > -1
	
	if(isChrome){
     	if((screen.width=="1440")&&(screen.height=="900"))
     	{
	     	Height="610";
     	}
	}else{
		if((screen.width=="1440")&&(screen.height=="900"))
     	{
	     	Height="565";
     	}
	}



		InitRoomRecordDetailDataGrid();
	
})


function InitRoomRecordDetailDataGrid(){
	
	$HUI.datagrid("#dhcperoomrecorddetail",{
		height:Height,
		striped: true, //�Ƿ���ʾ������Ч��
		singleSelect: true,
		selectOnCheck: false,
		autoRowHeight: false,
		showFooter: true,
		nowrap:false,
		url: $URL,
		loadMsg: 'Loading...',
		pagination: true, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
		rownumbers: true, //���Ϊtrue, ����ʾһ���к���
		pageSize: 10,
		pageList: [10, 20, 40, 40],
		queryParams:{
			ClassName:"web.DHCPE.RoomManager",
			QueryName:"FindRoomPersonDetail", 
			RoomID:RoomID,
			
		},
		toolbar:[{
		id:"BReload",
		text: 'ˢ��',
		iconCls: 'icon-reload',
		handler: function(){Reflesh();}
		},{
		id:"BModifyRoom",
		text: '������Ϣ����',
		iconCls: 'icon-edit',
		handler: function(){BModifyRoom_Click();}
		}],
		columns:[[
			{field:'TIND',width:'60',title:'���'},
			{field:'TRegNo',width:'120',title:'�ǼǺ�'},
			{field:'TName',width:'120',title:'����'},
			{field:'TSex',width:'60',title:'�Ա�'},
			{field:'TBirth',width:'120',title:'��������'},
			{field:'TTel',width:'120',title:'��ϵ�绰'},
			{field:'TRecordID',title:'�ŶӲ���',width:'180',
			formatter:function(value,row,index){
				if(value!=""){
			
					return '<a><img style="padding:0 10px 0px 0px" src="../scripts_lib/hisui-0.1.0/dist/css/icons/stamp.png" title="�����Ŷ�" border="0" onclick="NewCurRoom('+value+')"></a>\
					<a><img style="cursor:pointer" src="../scripts_lib/hisui-0.1.0/dist/css/icons/stamp_cancel.png" title="ȡ���Ŷ�" border="0" onclick="StopCurRoom('+value+')"></a>';
			
					}
				}},
			{field:'TStatus',title:'�кŲ���',width:'180',
			formatter:function(value,rowData,rowIndex){
				if(value!=""){
					return '<a><img style="padding:0 10px 0px 0px" src="../scripts_lib/hisui-0.1.0/dist/css/icons/stamp.png" title="�к�" border="0" onclick="CallCurRoom('+rowData.TRecordID+"^"+rowData.TStatus+"^"+rowData.TRegNo+')"></a>\
					<a><img style="padding:0 10px 0px 0px" src="../scripts_lib/hisui-0.1.0/dist/css/icons/stamp_cancel.png" title="˳��" border="0" onclick="DelayCurRoom('+rowData.TRecordID+')"></a>\
					<a><img style="cursor:pointer" src="../scripts_lib/hisui-0.1.0/dist/css/icons/stamp_pass.png" title="����" border="0" onclick="PassCurRoom('+rowData.TRecordID+')"></a>'
					
					;
			
				}
				}}
		]]
		
		
	
	})
}

//�����Ŷ�
function NewCurRoom(RecordID)
{
	var ID=RecordID;
	
	if (ID==""){
		$.messager.alert("��ʾ","ԭ���Ҳ�����,���ܵ���");
		return false;
	}
	var rtn=$.m({
			"ClassName":"web.DHCPE.RoomManager",
			"MethodName":"ReSetCurRoomInfoNew",
			"CurRoomID":ID

		}, false);
	
    // alert(rtn)
	var Arr=rtn.split("^");
	
	if (Arr[0]!="0"){
		$.messager.alert('��ʾ',Arr[1],"info");
		//alert(Arr[1]);
	}else if (Arr[0]=="0"){
		$.messager.alert('��ʾ',Arr[1],"info");

		//alert(Arr[1]);
	}
	window.location.reload();
	
	
}
//ȡ���Ŷ�
function StopCurRoom(RecordID)
{
	var ID=RecordID;
	if (ID==""){
		$.messager.alert("��ʾ","ԭ���Ҳ�����,���ܵ���","info");
		return false;
	}
	var rtn=$.m({
			"ClassName":"web.DHCPE.RoomManager",
			"MethodName":"StopCurRoomInfo",
			"CurRoomID":ID

		}, false);
	
	
	var Arr=rtn.split("^");
	if (Arr[0]!="0"){
		$.messager.alert('��ʾ',Arr[1],"info");
		//alert(Arr[1]);
	}else if (Arr[0]=="0"){
		$.messager.alert('��ʾ',Arr[1],"info");
		//alert(Arr[1]);
	}
	window.location.reload();
	if (opener){
		if (opener.document.getElementById("SpecNo"))
		{
			opener.vRoomRecordID="";
			
		
		}else{
			opener.parent.vRoomRecordID="";
			
		}
	}
}


//�к�  ���ýӿ�  ARR_StatusDetail����ΪC
function CallCurRoom(ID)
{
	var Arr=ID.split("^");
	var Status=Arr[1];
	var RegNo=Arr[2];
	var RecordID=Arr[0];
	if (RecordID==""){
		$.messager.alert("��ʾ","ԭ���Ҳ�����,���ܵ���","info");
		return false;
	}
	 
	if (opener){
		var OldRecord="";
		if (opener.document.getElementById("SpecNo"))
		{
			OldRecord=opener.vRoomRecordID;
			
			//opener.websys_setfocus("SpecNo");
		}else{
			OldRecord=opener.parent.vRoomRecordID;
			//opener.websys_setfocus("RegNo");
		}
		if ((OldRecord!=RecordID)&&(OldRecord!=""))
		{
			if (!confirm("��ǰ�����,��û�����,�Ƿ�ʼ��һ��?")){
				return false;
			}
		}
	}
	var rtn=$.m({
			"ClassName":"web.DHCPE.RoomManager",
			"MethodName":"CallCurRoom",
			"CurRoomID":RecordID

		}, false);
		var Arr=rtn.split("^");
	
	if (Arr[0]!="0"){
		$.messager.alert('��ʾ',Arr[1],"info");
		//alert(Arr[1]);
	}else if (Arr[0]=="0"){
		$.messager.alert('��ʾ',Arr[1],"info");
		//alert(Arr[1]);
	}
	
	if (opener){
		if (opener.document.getElementById("SpecNo"))
		{
			opener.vRoomRecordID=RecordID;
			opener.websys_setfocus("SpecNo");
		}else{
			opener.parent.vRoomRecordID=RecordID;
			opener.websys_setfocus("RegNo");
		}
	}
	//���ýкŽӿ�
}

//˳��  ��λ
function DelayCurRoom(RecordID)
{
	var ID=RecordID;
	
	if (ID==""){
		$.messager.alert("��ʾ","ԭ���Ҳ�����,���ܵ���","info");
		return false;
	}
	var rtn=$.m({
			"ClassName":"web.DHCPE.RoomManager",
			"MethodName":"DelayCurRoomInfo",
			"CurRoomID":ID

		}, false);
	
    // alert(rtn)
	var Arr=rtn.split("^");
	if (Arr[0]!="0"){
		$.messager.alert('��ʾ',Arr[1],"info");
	}else if (Arr[0]=="0"){
		$.messager.alert('��ʾ',Arr[1],"info");
		//alert(Arr[1]);
	}
	if (opener){
		if (opener.document.getElementById("SpecNo"))
		{
			opener.vRoomRecordID="";
			
			
		}else{
			opener.parent.vRoomRecordID="";
			
		}
	}
}

//����  ����Ϊ����״̬
function PassCurRoom(RecordID)
{
	var ID=RecordID;
	
	if (ID==""){
		$.messager.alert("��ʾ","ԭ���Ҳ�����,���ܵ���","info");
		return false;
	}
	var rtn=$.m({
			"ClassName":"web.DHCPE.RoomManager",
			"MethodName":"PassCurRoomInfo",
			"CurRoomID":ID

		}, false);
	
    // alert(rtn)
	var Arr=rtn.split("^");
	if (Arr[0]!="0"){
		$.messager.alert('��ʾ',Arr[1],"info");
		//alert(Arr[1]);
	}else if (Arr[0]=="0"){
		$.messager.alert('��ʾ',Arr[1],"info");
		//alert(Arr[1]);
	}
	window.location.reload();
	
	if (opener){
		if (opener.document.getElementById("SpecNo"))
		{
			opener.vRoomRecordID="";
			
			
		}else{
			opener.parent.vRoomRecordID="";
		
		}
	}
}

function Reflesh(){
	window.location.reload();
	
}

function BModifyRoom_Click()
{

	var str = "websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPERoomModify&RoomID="+RoomID;
	var wwidth=400;
	var wheight=220;

	var xposition = (screen.width - wwidth) / 2;
	var yposition = ((screen.height - wheight) / 2)-10;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	var cwin=window.open(str,"_blank",nwin) 
	
}