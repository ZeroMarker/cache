
//����	DHCPEDocPatientList.hisui.js
//����	����б�	
//����	2021.12.01
//������  xy

$(function(){
	
	
	InitCombobox();
	
	//��ʼ���б�
	InitDocPatientListGrid();
	

	$("#RegNo").keydown(function(e) {		
		if(e.keyCode==13){
			BFind_click();
		}
			
       });
        
     $("#Name").keydown(function(e) {		
		if(e.keyCode==13){
			BFind_click();
		}
			
       });
	
	
	 $("#CardNo").keydown(function(e) {		
		if(e.keyCode==13){
			CardNo_Change();
		}
			
        });
        
     $("#CardNo").change(function(){
  			CardNo_Change();
		}); 
	
	//��ѯ
	$("#BFind").click(function() {	
		BFind_click();		
        });
      
     
     //����
	$("#BReadCard").click(function() {	
		ReadCardClickHandle();		
        });
        
     //����
	$("#BClear").click(function() {	
		BClear_click();		
        });
      
         
})

//����
function BClear_click(){
	$("#RegNo,#Name,#CardNo,#CardTypeNew,#CardTypeRowID").val('');
	$("#StartDate,#EndDate").datebox('setValue','');
	$("#GroupDesc").combogrid('setValue','');
	$("#TeamDesc").combogrid('setValue','');
	$('#IncludeCompleted,#IsCanSumResult,#MainDoctor,#LocAudited').checkbox('setValue',false);
	BFind_click();
};


//��ѯ
function BFind_click(){
	
	  $("#DocPatientListGrid").datagrid('load',{
			ClassName:"web.DHCPE.DocPatientList",
			QueryName:"FindDocCurrentAdm",
			PatientNo:$("#RegNo").val(),
			SurName:$("#Name").val(),
			StartDate:$("#StartDate").datebox('getValue'),
			EndDate:$("#EndDate").datebox('getValue'),
			CardNo:$("#CardNo").val(),
		    GroupID:$("#GroupDesc").combogrid('getValue'),
		    TeamID:$("#TeamDesc").combogrid('getValue'),
		    IncludeCompleted:$HUI.checkbox('#IncludeCompleted').getValue() ? "on" : "", 
		    IsCanSumResult:$HUI.checkbox('#IsCanSumResult').getValue() ? "on" : "", 
			MainDoctor:$HUI.checkbox('#MainDoctor').getValue() ? "on" : "", 
			LocAudited:$HUI.checkbox('#LocAudited').getValue() ? "on" : "", 
			UserID:session['LOGON.USERID'],
			LocID:session['LOGON.CTLOCID'],
			CSPName:"dhcpedocpatientlist.hisui.csp"
			
			
		})
	
	
}


function InitDocPatientListGrid(){
	
	
	$HUI.datagrid("#DocPatientListGrid",{
		url:$URL,
		fit : true,
		border : false,
		striped : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		singleSelect: true,
		selectOnCheck: false,
		queryParams:{
			ClassName:"web.DHCPE.DocPatientList",
			QueryName:"FindDocCurrentAdm",
			PatientNo:$("#RegNo").val(),
			SurName:$("#Name").val(),
			StartDate:$("#StartDate").datebox('getValue'),
			EndDate:$("#EndDate").datebox('getValue'),
			CardNo:$("#CardNo").val(),
		    GroupID:$("#GroupDesc").combogrid('getValue'),
		    TeamID:$("#TeamDesc").combogrid('getValue'),
		    IncludeCompleted:$HUI.checkbox('#IncludeCompleted').getValue() ? "on" : "", 
		    IsCanSumResult:$HUI.checkbox('#IsCanSumResult').getValue() ? "on" : "", 
			MainDoctor:$HUI.checkbox('#MainDoctor').getValue() ? "on" : "", 
			LocAudited:$HUI.checkbox('#LocAudited').getValue() ? "on" : "", 
			UserID:session['LOGON.USERID'],
			LocID:session['LOGON.CTLOCID'],
			CSPName:"dhcpedocpatientlist.hisui.csp"
						
		},
		columns:[[       
		    {field:'EpisodeID',title:'PAADM',hidden: true},
			{field:'PAPMINO',width:'110',title:'�ǼǺ�'},
			{field:'PAPMIName',width:'110',title:'����'},	
			{field:'PAPMIDOB',width:'100',title:'��������'},
			{field:'PAPMISex',width:'60',title:'�Ա�'},
			{field:'PAAdmReason',width:'80',title:'����'},
			{field:'PAAdmDate',width:'100',title:'��������'},
			{field:'Group',width:'150',title:'����'},
			{field:'Team',width:'80',title:'����'},
			{field:'PAAdmDepCodeDR',width:'90',title:'������'},
			{field:'TReason',width:'250',title:'�����ܼ�ԭ��'},
			{field:'TReCheck',width:'90',title:'��Ժ���'},
			{field:'TSex',width:'100',title:'֤����'},
			{field:'TDepName',width:'80',title:'����'},
			{field:'TAge',width:'50',title:'����'}

					
		]],
		onDblClickRow: function (rowIndex, rowData) {
			var lnk="dhcpedocpatient.hisui.csp"+"?PAADM="+rowData.EpisodeID;
			var wwidth=screen.width-10;
			var wheight=screen.height-10;
			var xposition = (screen.width - wwidth) / 2;
			var yposition = (screen.height - wheight) / 2;
			var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,titlebar=yes,'
					+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
			var cwin=window.open(PEURLAddToken(lnk),"_blank",nwin)	

		}
			
	})
	
}

function InitCombobox(){

	//����
	var GADMDescObj = $HUI.combogrid("#GroupDesc",{
		panelWidth:450,
		url:$URL+"?ClassName=web.DHCPE.DHCPEGAdm&QueryName=GADMList",
		mode:'remote',
		delay:200,
		pagination : true, 
		pageSize: 20,
		pageList : [20,50,100],
		idField:'TRowId',
		textField:'TGDesc',
		onBeforeLoad:function(param){
			param.GBIDesc = param.q;
			param.ShowPersonGroup="1";
		},
		onChange:function()
        {
            TeamObj.clear();
        },
		onShowPanel:function()
		{
			$('#GroupDesc').combogrid('grid').datagrid('reload');
		},
		columns:[[
			{field:'TRowId',title:'ID',hidden: true},
			{field:'TGDesc',title:'��������',width:200},
			{field:'TGStatus',title:'״̬',width:100},
			{field:'TAdmDate',title:'ʱ��',width:100},
				
		]]
		});
	
	//����
	var TeamObj = $HUI.combogrid("#TeamDesc",{
        panelWidth:400,
       	url:$URL+"?ClassName=web.DHCPE.DHCPEGAdm&QueryName=DHCPEGItemList",
        mode:'remote',
        delay:200,
		pagination : true, 
		pageSize: 20,
		pageList : [20,50,100],
        idField:'GT_RowId',
        textField:'GT_Desc',
        onBeforeLoad:function(param){
            var PreGId=$("#GroupDesc").combogrid("getValue");
            param.GID = PreGId;
        },
       
        onShowPanel:function()
        {
            $('#TeamDesc').combogrid('grid').datagrid('reload');
        },
        columns:[[
            {field:'GT_RowId',hidden:true},
            {field:'GT_Desc',title:'��������',width:240},   
           
        ]]
        });
}


function CardNo_Change()
{
	var myCardNo=$("#CardNo").val();
	if (myCardNo=="") return;
	var myrtn=DHCACC_GetAccInfo("",myCardNo,"","PatInfo",CardTypeCallBack);
	//alert("myrtn:"+myrtn)
	return false;
	

}

function CardNoKeyDownCallBack(myrtn){
	var CardNo=$("#CardNo").val();
	var CardTypeNew=$("#CardTypeNew").val();
	$(".textbox").val('');
	$("#CardTypeNew").val(CardTypeNew);
   var myary=myrtn.split("^");
   var rtn=myary[0];
   if ((rtn=="0")||(rtn=="-201")){
		var PatientID=myary[4];
		var PatientNo=myary[5];
		var CardNo=myary[1];
		$("#CardTypeRowID").val(myary[8]);
		$("#CardNo").focus().val(CardNo);
		$("#RegNo").val(PatientNo);
		BFind_click();
	}else if(rtn=="-200"){
		$.messager.popover({msg: "����Ч!", type: "info"});
		$("#CardNo").focus().val(CardNo);
		return false;
	}
}
function CardTypeCallBack(myrtn){
   var myary=myrtn.split("^");
   var rtn=myary[0];
	switch (rtn){
		case "0": //����Ч���ʻ�
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1]
			$("#CardNo").focus().val(CardNo);
			$("#PatientNo").val(PatientNo);
			Find_click();
			event.keyCode=13; 
			break;
		case "-200": //����Ч
			$.messager.alert("��ʾ","����Ч","info",function(){$("#CardNo").focus();});
			break;
		case "-201": //����Ч���ʻ�
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1];
			$("#CardNo").focus().val(CardNo);
			$("#PatientNo").val(PatientNo);
			Find_click();
			event.keyCode=13;
			break;
		default:
	}
}


//����
function ReadCardClickHandle(){
	DHCACC_GetAccInfo7(CardNoKeyDownCallBack);
}


