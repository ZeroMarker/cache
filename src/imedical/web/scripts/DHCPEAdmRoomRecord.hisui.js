
//����	DHCPEAdmRoomRecord.hisui.js
//����	������ҵ���
//����	2020.12.1
//������  xy
$(function(){
			
	InitCombobox();
	
	InitAdmRoomRecordGrid(); 
	
	
	//������Ϣ
	$("#BFindRoomInfo").click(function() {	
		BFindRoomInfo_click();		
        }); 
       
	//����
	$("#BUpdate").click(function() {	
		BUpdate_click();		
        });  
   
	//ȡ���Ŷ� 
	$("#BStopRoom").click(function() {	
		BStopRoom_click();		
        });  
	
	//��ͣ�Ŷ�
	$("#BPauseRoom").click(function() {	
		BPauseRoom_click();		
        });  

	//����ѡ������
	$("#BRefuseSelect").click(function() {	
		BRefuseSelect_click();		
        });  
	
	//�ָ�����
	$("#BResumeRoom").click(function() {	
		ResumeRoom_click();		
        });  
	
	 $("#Name").keydown(function(e) {	
		if(e.keyCode==13){
			FindDetail();
			}
	});
	
	 $("#RegNo").keydown(function(e) {	
		if(e.keyCode==13){
			RegNo_change();
			}
	});
	
    
})


//������Ϣ
function BFindRoomInfo_click(){
	//alert($("#PAADM").val())
	$("#AdmRoomRecordGrid").datagrid('load', {
			ClassName:"web.DHCPE.RoomManager",
			QueryName:"AdmNeedRoom",
			PAADM:$("#PAADM").val()
		
	});
}

//����ѡ������
function BRefuseSelect_click()
{
	var PAADM=$("#PAADM").val();
	 if(PAADM==""){
	   $.messager.alert("��ʾ","�����������������Ա","info");
	    return false;
	   }
	   
	var selectrow = $("#AdmRoomRecordGrid").datagrid("getChecked");//��ȡ�������飬��������
    if(selectrow.length<1){
	    $.messager.alert("��ʾ","��ѡ���������¼","info");
		return false;
    }
	 
	
	var IfHadChecked=0;
	for (var i=0;i<selectrow.length;i++){
	
		    IfHadChecked=1
	
		    var RoomID=selectrow[i].TRoomID;
			var ret=tkMakeServerCall("web.DHCPE.AdmRefuseRoom","Refuse",PAADM,RoomID)
     		$.messager.alert("��ʾ",ret.split("^")[1],"info");	
     		if(ret.split("^")[0]==0)
     		{
	     		// ������
	     		$("#RoomRecordID").val(ret.split("^")[2]);
	     		
	     		} 
    	     
	}
	if(IfHadChecked==1){
		//BFindRoomInfo_click();
		RegNo_change();
	}
	
}


//�ָ�����
function ResumeRoom_click()
{ 
	var PAADM=$("#PAADM").val();
	 if(PAADM==""){
	   $.messager.alert("��ʾ","�����������������Ա","info");
	    return false;
	   }
	
	var selectrow = $("#AdmRoomRecordGrid").datagrid("getChecked");//��ȡ�������飬��������
    if(selectrow.length<1){
	    $.messager.alert("��ʾ","��ѡ����ָ����ҵļ�¼","info");
		return false;
    }
   	var IfHadChecked=0;
	for(var i=0;i<selectrow.length;i++){
		 var RoomID=selectrow[i].TRoomID;
		 var RSID=tkMakeServerCall("web.DHCPE.AdmRefuseRoom","GetResumeRoomButtonID",PAADM,RoomID);
		  if(RSID==""){
			     $.messager.alert("��ʾ","�Ѿ��ָ�","info");
			     return false;
			}
			    
		   var ret=tkMakeServerCall("web.DHCPE.AdmRefuseRoom","Resume",RSID);
		   $.messager.alert("��ʾ",ret.split("^")[1],"info");
		   IfHadChecked=1;
		     
		 
		
	}
	
	if(IfHadChecked==1){
		
		RegNo_change();
	}
	
}
//��ͣ�Ŷ�
function BPauseRoom_click()
{
	var ButtonText=$("#BPauseRoom").linkbutton("options").text;
	
	if(ButtonText=="�ָ��Ŷ�"){
		var PAADM=$("#PAADM").val();
		if (PAADM==""){
				$.messager.alert("��ʾ","��������ָ��Ŷӵ���Ա","info");
				return false;
		}
	}
	if(ButtonText=="�Ŷ�"){
		var PAADM=$("#PAADM").val();
		if (PAADM==""){
				$.messager.alert("��ʾ","����������ͣ�Ŷӵ���Ա","info");
				return false;
		}
	}
	if(ButtonText=="��ͣ�Ŷ�"){
		var PAADM=$("#PAADM").val();
		if (PAADM==""){
				$.messager.alert("��ʾ","����������ͣ�Ŷӵ���Ա","info");
				return false;
		}
	}

	var ID=$("#RoomRecordID").val();
	
	if (ID!=""){
		
		$.messager.confirm("������ʾ", "�Ƿ���Ҫ��ԭ�����ң��������·���������?", function (data) {
            		if (data) {
	          
	               var rtn=tkMakeServerCall("web.DHCPE.RoomManager","StopCurRoomInfo",ID);
	        		
					var rtn=tkMakeServerCall("web.DHCPE.RoomManager","PauseRoom",$("#PAADM").val());
					if(rtn.split("^")[0]=="0"){
						$.messager.alert("��ʾ","���óɹ�","info");
					}
					//$("#BPauseRoom").linkbutton({text:'�ָ��Ŷ�'})
				
					RegNo_change();
					
					
	        		}
            		else {
	            		
	            		var rtn=tkMakeServerCall("web.DHCPE.RoomManager","PauseRoom",$("#PAADM").val());
						if(rtn.split("^")[0]=="0"){
							$.messager.alert("��ʾ","���óɹ�","info");
						}
	
						RegNo_change();
                		
            		}
        			});	
		
	}else{
		
		var rtn=tkMakeServerCall("web.DHCPE.RoomManager","PauseRoom",$("#PAADM").val());
		if(rtn.split("^")[0]=="0"){
				$.messager.alert("��ʾ","���óɹ�","info");
			}
			
		RegNo_change();
		
	}
	
	
	
	
	
		
	
}

//ȡ���Ŷ�
function BStopRoom_click()
{
	var PAADM=$("#PAADM").val();
	if (PAADM==""){
		$.messager.alert("��ʾ","���������ȡ���Ŷӵ���Ա","info");
		return false;
	}
	var ID=$("#RoomRecordID").val();
	if (ID==""){
		$.messager.alert("��ʾ","ԭ���Ҳ�����,����ȡ���Ŷ�","info");
		return false;
	}

	var rtn=tkMakeServerCall("web.DHCPE.RoomManager","StopCurRoomInfo",ID);
	if (rtn.split("^")[0]=="-1"){
			$.messager.alert("��ʾ","ȡ���Ŷ�ʧ��:"+rtn.split("^")[1],"info");
		
	}else{
		//BFindRoomInfo_click();
		$.messager.alert("��ʾ","ȡ���Ŷӳɹ�","info");
		RegNo_change();
	}
	
}




//����
function BUpdate_click()
{
	var ID=$("#RoomRecordID").val();
	if (ID==""){
		$.messager.alert("��ʾ","ԭ���Ҳ�����,���ܵ���","info");
		return false;
	}
	var RoomID=$("#RoomDesc").combogrid("getValue");
	if (($("#RoomDesc").combogrid("getValue")==undefined)||($("#RoomDesc").combogrid("getValue")=="")){var RoomID="";}
	if (RoomID==""){
		$.messager.alert("��ʾ","����Ϊ���Ҳ�����,���ܵ���","info");
		return false;
	}
	
	var selectrow = $("#AdmRoomRecordGrid").datagrid("getChecked");//��ȡ�������飬��������
    if(selectrow.length>1){
	    $.messager.alert("��ʾ","�������ң�ֻ��ѡ��һ����¼","info");
		return false;
    }
    
	for(var i=0;i<selectrow.length;i++){
		var RefuseRoom=selectrow[i].TRefuseRoom;
		if (RefuseRoom=="����"){
			$.messager.alert("��ʾ","�������ѷ���,���ܵ�����������","info");
			return false;
		}
	}

		//alert(ID+"^"+RoomID)
	var rtn=tkMakeServerCall("web.DHCPE.RoomManager","UpdateAdmRoomRecord",ID,RoomID,1);

	if (rtn.split("^")[0]=="-1"){
			$.messager.alert("��ʾ","����ʧ��:"+rtn.split("^")[1],"info");
		
	}else{
		//BFindRoomInfo_click();
		RegNo_change();
		$("#AreaDesc").combogrid('setValue',"");
		$("#RoomDesc").combogrid('setValue',"");

	}
}



function RegNo_change()
{
	var iRegNo=$("#RegNo").val();
	if (iRegNo==""){
		var Info="0^^^^^^^^^^^^";
	}else if(iRegNo!="") {
	 	var iRegNo=$.m({
			"ClassName":"web.DHCPE.DHCPECommon",
			"MethodName":"RegNoMask",
            "RegNo":iRegNo
		}, false);
		
			$("#RegNo").val(iRegNo);
			var Info=tkMakeServerCall("web.DHCPE.RoomManager","GetAdmRecordInfo",iRegNo);
	} 
	
	//alert(Info)
	var Char_1=String.fromCharCode(1);
	var Arr=Info.split(Char_1);
	var BaseInfo=Arr[0];
	var BaseArr=BaseInfo.split("^");
	var PAADM="";
	var PauseFlag=0;
	
	if (BaseArr[0]=="0"){
		var RoomInfo=Arr[1];
		var RoomArr=RoomInfo.split("^");
		$("#Name").val(BaseArr[1]);
		$("#RegNo").val(BaseArr[5]);
		$("#Sex").val(BaseArr[2]);
		$("#Dob").val(BaseArr[3]);
		$("#IDCard").val(BaseArr[4]);
		$("#PAADM").val(BaseArr[10]);
		$("#RoomRecordID").val(RoomArr[0]);
		$("#CurRoomInfo").val(RoomArr[1]);
		
		PAADM=BaseArr[10];
		PauseFlag=BaseArr[11];
	}else{
		
		 $.messager.popover({msg: BaseArr[1], type: "info"});
		 $("#Name,#Sex,#Dob,#IDCard,#PAADM").val("");
		$("#RoomRecordID").val("");
		$("#CurRoomInfo").val("");
		
	}
	
	if (PauseFlag!="0"){
		
		SetCElement("BPauseRoom","�ָ��Ŷ�");
		
	}else{
		SetCElement("BPauseRoom","��ͣ�Ŷ�");
	
		
	}
	
	$("#AdmRoomRecordGrid").datagrid('load', {
			ClassName:"web.DHCPE.RoomManager",
			QueryName:"AdmNeedRoom",
			PAADM:$("#PAADM").val()
		
	});
	
}
function InitAdmRoomRecordGrid()
{

$HUI.datagrid("#AdmRoomRecordGrid",{
		url:$URL,
		fit : true,
		border : false,
		striped : false,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true, 
		pageSize: 20,
		pageList : [20,100,200],
		singleSelect: false,
		checkOnSelect: true, //���Ϊfalse, ���û����ڵ���ø�ѡ���ʱ��Żᱻѡ�л�ȡ��
		selectOnCheck: true,
		queryParams:{
			ClassName:"web.DHCPE.RoomManager",
			QueryName:"AdmNeedRoom",
			PAADM:$("#PAADM").val()
		
		},
		
		columns:[[
			{title: 'ѡ��',field: 'Select',width: 60,checkbox:true},
			{field:'TRoomID',title:'RoomID',hidden: true},
			{field:'TPAADM',title:'PAADM',hidden: true},
			{field:'TAreaDesc',width:300,title:'����'},
			{field:'TAreaID',title:'AreaID',hidden: true},
			{field:'TRoomDesc',width:300,title:'����'},
			{field:'TWaitNum',width:120,title:'�Ⱥ�����'},
			{field:'TWaitMinute',width:120,title:'�ȵ�ʱ��'},
			{field:'TRefuseRoom',width:100,title:'����'},	
			
		]],
		onSelect: function (rowIndex, rowData) {
			  
			  	$("#AreaDesc").combogrid('setValue',rowData.TAreaID);
				//$("#RoomDesc").combogrid('setValue',rowData.TRoomID);
				$('#RoomDesc').combogrid('grid').datagrid('reload',{'q':rowData.TRoomID});
				$("#RoomDesc").combogrid('setValue',rowData.TRoomID);
							
		}
			
	});
}

function InitCombobox(){
	
	//������Ϣ
     var AreaDescObj = $HUI.combogrid("#AreaDesc",{    
        panelWidth:390,
        url:$URL+"?ClassName=web.DHCPE.RoomManager&QueryName=FindArea",
        mode:'remote',
        delay:200,
          pagination : true, 
		pageSize: 20,
		pageList : [20,100,200],

        idField:'TID',
        textField:'TDesc',
        onBeforeLoad:function(param){
            //param.Parref = param.q;
        },
         onChange:function()
        {
            RoomDescObj.clear();
           
        },
        columns:[[
            {field:'TID',title:'ID',width:40},
            {field:'TCode',title:'����',width:80},
            {field:'TDesc',title:'����',width:100},
            {field:'TSort',title:'���',width:60},
            {field:'TAreaFlag',title:'�����Ŷ�',width:80}
        ]]
        })
	  
	
	//����
		 var RoomDescObj = $HUI.combogrid("#RoomDesc",{
        panelWidth:650,
        url:$URL+"?ClassName=web.DHCPE.RoomManager&QueryName=FindRoomNew",
        mode:'remote',
        delay:200,
        pagination : true, 
		pageSize: 20,
		pageList : [20,100,200],
        idField:'TID',
        textField:'TDesc',
        onBeforeLoad:function(param){
	       
	        var AreaId=$("#AreaDesc").combogrid("getValue");
            param.Parref =AreaId;
           
        },
        onShowPanel:function()
        {
            $('#RoomDesc').combogrid('grid').datagrid('reload');
        },
        columns:[[
            {field:'TID',title:'ID',width:60},
            {field:'TCode',title:'����',width:60},
            {field:'TDesc',title:'����',width:100},
            {field:'TSort',title:'���',width:50},
            {field:'TSex',title:'�Ա�',width:50},
            {field:'TActiveFlag',title:'����',width:50},
            {field:'TVIPLevelDesc',title:'VIP�ȼ�',width:60},
            {field:'TShowNum',title:'��ʾ����',width:80},
            {field:'TDoctorDesc',title:'ҽ��',width:100}
  

        ]]
        });
	
	
	
}
