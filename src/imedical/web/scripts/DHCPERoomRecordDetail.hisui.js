
//����	DHCPERoomRecordDetail.hisui.js
//����  ���ҵ����Ⱥ�����
//����	2018.09.19
//������  xy


$(function(){

	InitCombobox();

	InitRoomRecordDetailDataGrid();
		
		//ˢ��
	$("#BReload").click(function() {	
		Reflesh();		
        });
        
        
        //������Ϣ����
	$("#BModifyRoom").click(function() {	
		BModifyRoom_Click();		
        });
			
	//�޸�
     $("#BModify").click(function() {	
		BModify_click();		
        });
	
})

function InitRoomRecordDetailDataGrid(){
	
	$HUI.datagrid("#dhcperoomrecorddetail",{
		url: $URL,
		fit : true,
		border : false,
		striped : false,//�Ƿ���ʾ������Ч��
		fitColumns : false,
		autoRowHeight : false,
		rownumbers : true, //���Ϊtrue, ����ʾһ���к��� 
		pagination : true, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������ 
		pageSize: 10,
		pageList : [10,20,30],
		singleSelect: true,
		selectOnCheck: false,
		autoRowHeight: false,
		queryParams:{
			ClassName:"web.DHCPE.RoomManager",
			QueryName:"FindRoomPersonDetail", 
			RoomID:RoomID,
			
		},
		frozenColumns:[[
			{field:'TIND',width:'40',title:'���'},
			{field:'TRegNo',width:'120',title:'�ǼǺ�'}
		]],
		columns:[[
			{field:'TStatus',title:'״̬',hidden:true},
			{field:'TRecordID',title:'RecordID',hidden:true},
			{field:'TName',width:'120',title:'����'},
			{field:'TSex',width:'50',title:'�Ա�'},
			{field:'TBirth',width:'100',title:'��������'},
			{field:'TTel',width:'100',title:'��ϵ�绰'},
			{field:'TRoomList',title:'�ŶӲ���',width:'130',
				formatter:function(value,rowData,index){
				if(rowData.TRecordID!=""){
					
					
					if (("undefined"==typeof HISUIStyleCode)||(HISUIStyleCode==null)){
						return "<span style='cursor:pointer;' class='icon-init' title='�����Ŷ�' onclick='NewCurRoom("+rowData.TRecordID+")'>&nbsp;&nbsp;&nbsp;&nbsp;</span>&nbsp;&nbsp;&nbsp;&nbsp;"+
						"<span style='cursor:pointer;' class='icon-cancel' title='ȡ���Ŷ�' onclick='StopCurRoom("+rowData.TRecordID+")'>&nbsp;&nbsp;&nbsp;&nbsp;</span>";
					
					}else{
						if(HISUIStyleCode=="lite") {
							return "<span style='cursor:pointer;' class='icon-init' title='�����Ŷ�' onclick='NewCurRoom("+rowData.TRecordID+")'></span>"+
							"<span style='padding-left:10px;cursor:pointer;' class='icon-cancel' title='ȡ���Ŷ�' onclick='StopCurRoom("+rowData.TRecordID+")'></span>";
					
						}else{
							return "<span style='cursor:pointer;' class='icon-init' title='�����Ŷ�' onclick='NewCurRoom("+rowData.TRecordID+")'>&nbsp;&nbsp;&nbsp;&nbsp;</span>&nbsp;&nbsp;&nbsp;&nbsp;"+
							"<span style='cursor:pointer;' class='icon-cancel' title='ȡ���Ŷ�' onclick='StopCurRoom("+rowData.TRecordID+")'>&nbsp;&nbsp;&nbsp;&nbsp;</span>";
					
						}
					}
					
					
					
					/*
					return '<a><img style="padding:0 10px 0px 0px" src="../scripts_lib/hisui-0.1.0/dist/css/icons/stamp.png" title="�����Ŷ�" border="0" onclick="NewCurRoom('+rowData.TRecordID+')"></a>\
					<a><img style="cursor:pointer" src="../scripts_lib/hisui-0.1.0/dist/css/icons/stamp_cancel.png" title="ȡ���Ŷ�" border="0" onclick="StopCurRoom('+rowData.TRecordID+')"></a>';
					*/
					}
				}},
			{field:'TCallList',title:'�кŲ���',width:'150',
				formatter:function(value,rowData,rowIndex){
				if((rowData.TRecordID!="")&&(rowData.TStatus=="N")){
					
					if (("undefined"==typeof HISUIStyleCode)||(HISUIStyleCode==null)){
							return "<span style='cursor:pointer;' class='icon-stamp' title='�к�' onclick='CallCurRoom("+rowIndex+")'>&nbsp;&nbsp;&nbsp;&nbsp;</span>&nbsp;&nbsp;&nbsp;&nbsp;"+
							"<span style='cursor:pointer;' class='icon-stamp-pass' title='˳��' onclick='DelayCurRoom("+rowData.TRecordID+")'>&nbsp;&nbsp;&nbsp;&nbsp;</span>&nbsp;&nbsp;&nbsp;&nbsp;"+
							"<span style='cursor:pointer;' class='icon-stamp-cancel' title='����' onclick='StopCurRoom("+rowData.TRecordID+")'>&nbsp;&nbsp;&nbsp;&nbsp;</span>";
					
					
					}else{
						if(HISUIStyleCode=="lite") {
								return "<span style='cursor:pointer;' class='icon-stamp' title='�к�' onclick='CallCurRoom("+rowIndex+")'></span>"+
								"<span style='padding-left:10px;cursor:pointer;' class='icon-stamp-pass' title='˳��' onclick='DelayCurRoom("+rowData.TRecordID+")'></span>"+
								"<span style='padding-left:10px;cursor:pointer;' class='icon-stamp-cancel' title='����' onclick='StopCurRoom("+rowData.TRecordID+")'></span>";
					
						}else{
							return "<span style='cursor:pointer;' class='icon-stamp' title='�к�' onclick='CallCurRoom("+rowIndex+")'>&nbsp;&nbsp;&nbsp;&nbsp;</span>&nbsp;&nbsp;&nbsp;&nbsp;"+
							"<span style='cursor:pointer;' class='icon-stamp-pass' title='˳��' onclick='DelayCurRoom("+rowData.TRecordID+")'>&nbsp;&nbsp;&nbsp;&nbsp;</span>&nbsp;&nbsp;&nbsp;&nbsp;"+
							"<span style='cursor:pointer;' class='icon-stamp-cancel' title='����' onclick='StopCurRoom("+rowData.TRecordID+")'>&nbsp;&nbsp;&nbsp;&nbsp;</span>";
					
					
						}
					}
					
					
					
					
				
					/*
					return '<a><img style="padding:0 10px 0px 0px" src="../scripts_lib/hisui-0.1.0/dist/css/icons/stamp.png" title="�к�" border="0" onclick="CallCurRoom('+rowIndex+')"></a>\
					<a><img style="padding:0 10px 0px 0px" src="../scripts_lib/hisui-0.1.0/dist/css/icons/stamp_cancel.png" title="˳��" border="0" onclick="DelayCurRoom('+rowData.TRecordID+')"></a>\
					<a><img style="cursor:pointer" src="../scripts_lib/hisui-0.1.0/dist/css/icons/stamp_pass.png" title="����" border="0" onclick="PassCurRoom('+rowData.TRecordID+')"></a>'
					
					;
					*/
			
				}
				if((rowData.TRecordID!="")&&(rowData.TStatus=="P")){
					
					return '<a><img style="padding:0 10px 0px 0px" src="../scripts_lib/hisui-0.1.0/dist/css/icons/stamp.png" title="�к�" border="0" onclick="CallCurRoom('+rowIndex+')"></a>\
					<a><img style="padding:0 10px 0px 0px" src="../scripts_lib/hisui-0.1.0/dist/css/icons/stamp_cancel.png" title="˳��" border="0" onclick="DelayCurRoom('+rowData.TRecordID+')"></a>\
					<a><img style="cursor:pointer" src="../scripts_lib/hisui-0.1.0/dist/css/icons/stamp_pass.png" title="��������" border="0" onclick="RePassCurRoom('+rowData.TRecordID+')"></a>'
					
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
	
	$.messager.confirm("������ʾ", "�Ƿ�ȷ�������Ŷ�", function (data) {
            		if (data) {
	          
	             		var rtn=tkMakeServerCall("web.DHCPE.RoomManager","ReSetCurRoomInfoNew",ID);
						var Arr=rtn.split("^");
	
						if (Arr[0]!="0"){
								$.messager.alert('��ʾ',Arr[1],"info");
						}else if (Arr[0]=="0"){
								$.messager.alert('��ʾ',Arr[1],"info");
						}
						Reflesh();

	        		}
            		else {
	            		return false;	
                		
            		}
        	});	


}
//ȡ���Ŷ�
function StopCurRoom(RecordID)
{
	var ID=RecordID;
	if (ID==""){
		$.messager.alert("��ʾ","ԭ���Ҳ�����,���ܵ���","info");
		return false;
	}
	
	
	$.messager.confirm("������ʾ", "�Ƿ�ȷ��ȡ���Ŷ�", function (data) {
    	if (data) {
	          
	    	var rtn=tkMakeServerCall("web.DHCPE.RoomManager","StopCurRoomInfo",ID);
			var Arr=rtn.split("^");
			if (Arr[0]!="0"){
					$.messager.alert('��ʾ',Arr[1],"info");
			}else if (Arr[0]=="0"){
					$.messager.alert('��ʾ',Arr[1],"info");
			}
			Reflesh();
			if (opener){
				if (opener.document.getElementById("SpecNo"))
				{
					opener.vRoomRecordID="";
				}else{
				opener.parent.vRoomRecordID="";
			
				}
			}

	      }else {
		      return false;	
      	}
     })	
        	
	
}


//�к�  ���ýӿ�  ARR_StatusDetail����ΪC
function CallCurRoom(rowIndex)
{
	var rows=$("#dhcperoomrecorddetail").datagrid('getRows');
	var rowData = rows[rowIndex];
	var Status=rowData.TStatus;
	var RegNo=rowData.TRegNo;
	var RecordID=rowData.TRecordID;
	
	
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
	
	var rtn=tkMakeServerCall("web.DHCPE.RoomManager","CallCurRoom",RecordID);
	var Arr=rtn.split("^");
	if (Arr[0]!="0"){
		$.messager.alert('��ʾ',Arr[1],"info");
	}else if (Arr[0]=="0"){
		$.messager.alert('��ʾ',Arr[1],"info");
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
	
   var rtn=tkMakeServerCall("web.DHCPE.RoomManager","DelayCurRoomInfo",ID);
	var Arr=rtn.split("^");
	if (Arr[0]!="0"){
		$.messager.alert('��ʾ',Arr[1],"info");
	}else if (Arr[0]=="0"){
		$.messager.alert('��ʾ',Arr[1],"info");
	
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


//��������
function RePassCurRoom(RecordID)
{
	var ID=RecordID;
	
	if (ID==""){
		$.messager.alert("��ʾ","ԭ���Ҳ�����,���ܹ�������","info");
		return false;
	}
	$.messager.confirm("������ʾ", "�Ƿ�ȷ�Ϲ�������", function (data) {
    	if (data) {
	          
	    	var rtn=tkMakeServerCall("web.DHCPE.RoomManager","ReStartCurRoomInfo",ID);
			var Arr=rtn.split("^");
			if (Arr[0]!="0"){
				$.messager.alert('��ʾ',Arr[1],"info");
			}else if (Arr[0]=="0"){
				$.messager.alert('��ʾ',Arr[1],"info");
			}
			Reflesh();
	
			if (opener){
				if (opener.document.getElementById("SpecNo"))
				{
					opener.vRoomRecordID="";
				}else{
					opener.parent.vRoomRecordID="";
		
				}
			}

	      }else {
		      return false;	
      	}
     })	
}

//����  ����Ϊ����״̬
function PassCurRoom(RecordID)
{
	var ID=RecordID;
	
	if (ID==""){
		$.messager.alert("��ʾ","ԭ���Ҳ�����,���ܹ���","info");
		return false;
	}
	
	$.messager.confirm("������ʾ", "�Ƿ�ȷ�Ϲ���", function (data) {
    	if (data) {
	          
	    	var rtn=tkMakeServerCall("web.DHCPE.RoomManager","PassCurRoomInfo",ID);
			var Arr=rtn.split("^");
			if (Arr[0]!="0"){
				$.messager.alert('��ʾ',Arr[1],"info");
			}else if (Arr[0]=="0"){
				$.messager.alert('��ʾ',Arr[1],"info");
			}
			Reflesh();
	
			if (opener){
				if (opener.document.getElementById("SpecNo"))
				{
					opener.vRoomRecordID="";
				}else{
					opener.parent.vRoomRecordID="";
		
				}
			}

	      }else {
		      return false;	
      	}
     })	
	
    
}

function Reflesh(){
	$("#dhcperoomrecorddetail").datagrid('load', {
			ClassName:"web.DHCPE.RoomManager",
			QueryName:"FindRoomPersonDetail", 
			RoomID:RoomID,
		
	});

}
/*
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
*/
function InitCombobox(){

	 //�Ա�   
	var SexObj = $HUI.combobox("#Sex",{
		valueField:'id',
		textField:'text',
		panelHeight:'100',
		data:[
            {id:'N',text:'����'},
            {id:'M',text:'��'},
            {id:'F',text:'Ů'},
           
        ]

	});
	
	
}


//������Ϣ����
function BModifyRoom_Click()
{
	
 
  $("#RoomModifyWin").show();
  
   $HUI.window("#RoomModifyWin", {
        title: "������Ϣ����",
        iconCls: "icon-w-edit",
        collapsible: false,
        minimizable: false,
        maximizable: false,
        modal: true,
        width: 240,
        height: 256,
       
    });
    
    var ret=tkMakeServerCall("web.DHCPE.RoomManager","GetOneRoomInfo",RoomID);
 	 var sex=ret.split("^")[3];
  	var Minute=ret.split("^")[12];
  	var ActiveFlag=ret.split("^")[15];
    $("#RoomDesc").val(RoomDesc);
    $("#Sex").combobox('setValue',sex); 
    $("#RMinute").val(Minute);
    if(ActiveFlag=="Y"){
    	$("#RActiveFlag").checkbox('setValue',true);
    }else{
	    $("#RActiveFlag").checkbox('setValue',false);
    }
	
}

//�޸�
function BModify_click(){
	
	var RMinute=$("#RMinute").val();
	var Sex=$("#Sex").combobox('getValue');
	var RActiveFlag="Y";
	var RActiveFlag=$("#RActiveFlag").checkbox('getValue');
	if(RActiveFlag) {RActiveFlag="Y";}
	var Str=Sex+"^"+RMinute+"^"+RActiveFlag;
	//alert(Str)
	var rtn=tkMakeServerCall("web.DHCPE.RoomManager","ModifyRoom",RoomID,Str);
	if (rtn.split("^")[0]=="-1"){
		$.messager.alert("��ʾ","����ʧ��"+rtn.split("^")[1],"error");
	}else{
		$.messager.alert("��ʾ","���³ɹ�","success");
		$('#RoomModifyWin').window('close'); 
	}
}