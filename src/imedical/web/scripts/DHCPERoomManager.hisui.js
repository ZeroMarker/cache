
//����	DHCPERoomManager.hisui.js
//����	�������ά��
//����	2019.0.07
//������  xy

$(function(){
		
	InitCombobox();
	
	InitAreaGrid();
     
    InitRoomGrid();
       
    //�޸�(����ά��)
	$("#BUpdate").click(function() {	
		BUpdate_click();		
        });
        
     //����(����ά��)
	$("#BAdd").click(function() {	
		BAdd_click();		
        });  
    
    
    //����(����ά��)
	$("#BClear").click(function() {	
		BClear_click();		
        });
        
    //����λ��(����ά��)
     $("#BRoomPlace").click(function() {	
		BRoomPlace_click();		
        });  
     
      //�޸�(����ά��)
	$("#BRUpdate").click(function() {	
		BRUpdate_click();		
        });
        
     //����(����ά��)
	$("#BRAdd").click(function() {	
		BRAdd_click();		
        });  
    
    
    //����(����ά��)
	$("#BRClear").click(function() {	
		BRClear_click();		
        });
   
   //�걾ά��
   $("#BSpecimen").click(function() {	
		 BSpecimen_click();		
        });
        
   //����IPά��
   $("#BComIP").click(function() {	
		 BComIP_click();		
        });
  
  //ǰ������
  $("#BRoomSR").click(function() {	
		 BRoomSR_click();		
        });
   
  
  //����λ��
  $("#BRoomRP").click(function() {	
		 BRoomRP_click();		
        });
  
   //����Ĭ��ֵ
   SetDefault()
})


/******************************����ά������start********************/

//ǰ������
function BRoomSR_click(){
	var record = $("#RoomGrid").datagrid("getSelected"); 
	
			if (!(record)) {
				$.messager.alert('��ʾ','��ѡ���ά���ļ�¼!',"warning");
				return;
			} else {  
				var Desc=record.TDesc
				var RowId=record.TID
				var RoomType="SR"
				/*
				$("#myWin").show();  
				var myWinGuideImage = $HUI.window("#myWin",{
					resizable:true,
					collapsible:false,
					minimizable:false,
					iconCls:'icon-w-paper',
					title:"ǰ������ά��-"+Desc,
					modal:true,
					content:'<iframe id="timeline" frameborder="0" src="dhcperoomspecimen.hisui.csp?selectrow='+RowId+'&selectrowDesc='+Desc+'&RoomType='+RoomType+'" width="100%" height="99%" ></iframe>'
				});	
				*/
			lnk="dhcperoomspecimen.hisui.csp"+"?selectrow="+RowId+"&selectrowDesc="+Desc+"&RoomType="+RoomType	
			websys_lu(lnk,false,'width=710,height=400,hisui=true,title=ǰ������ά��-'+Desc)
					
			}
}

//����λ��
function BRoomRP_click(){
	var record = $("#RoomGrid").datagrid("getSelected"); 
	
			if (!(record)) {
				$.messager.alert('��ʾ','��ѡ���ά���ļ�¼!',"warning");
				return;
			} else {  
				var Desc=record.TDesc
				var RowId=record.TID
				var RoomType="RP"
				/*
				$("#myWin").show(); 
				 
				var myWinGuideImage = $HUI.window("#myWin",{
					resizable:true,
					collapsible:false,
					minimizable:false,
					iconCls:'icon-w-paper',
					title:"����λ��ά��-"+Desc,
					modal:true,
					content:'<iframe id="timeline" frameborder="0" src="dhcperoomspecimen.hisui.csp?selectrow='+RowId+'&selectrowDesc='+Desc+'&RoomType='+RoomType+'" width="100%" height="99%" ></iframe>'
				});	
				*/
			lnk="dhcperoomspecimen.hisui.csp"+"?selectrow="+RowId+"&selectrowDesc="+Desc+"&RoomType="+RoomType	
			websys_lu(lnk,false,'width=710,height=400,hisui=true,title=����λ��ά��-'+Desc)
					
			}
}
//����IPά��
function BComIP_click(){
	var record = $("#RoomGrid").datagrid("getSelected"); 
	
			if (!(record)) {
				$.messager.alert('��ʾ','��ѡ���ά���ļ�¼!',"warning");
				return;
			} else {  
				var Desc=record.TDesc
				var RowId=record.TID
				var RoomType="IP"
				/*
				$("#myWin").show();  
				var myWinGuideImage = $HUI.window("#myWin",{
					resizable:true,
					collapsible:false,
					minimizable:false,
					iconCls:'icon-w-paper',
					title:"���ҵ���IPά��-"+Desc,
					modal:true,
					content:'<iframe id="timeline" frameborder="0" src="dhcperoomspecimen.hisui.csp?selectrow='+RowId+'&selectrowDesc='+Desc+'&RoomType='+RoomType+'" width="100%" height="99%" ></iframe>'
				});	
				*/
			lnk="dhcperoomcomponent.hisui.csp"+"?selectrow="+RowId+"&selectrowDesc="+Desc+"&RoomType="+RoomType	
			websys_lu(lnk,false,'width=710,height=400,hisui=true,title=���ҵ���IPά��-'+Desc)
					
			}
}
//�걾ά��
function BSpecimen_click(){
		var record = $("#RoomGrid").datagrid("getSelected"); 
	
			if (!(record)) {
				$.messager.alert('��ʾ','��ѡ���ά���ļ�¼!',"warning");
				return;
			} else { 
			
				var Desc=record.TDesc
				var RowId=record.TID
				var RoomType="SP"
				/*
				$("#myWin").show();  
				var myWinGuideImage = $HUI.window("#myWin",{
					resizable:true,
					collapsible:false,
					minimizable:false,
					iconCls:'icon-w-paper',
					title:"���ұ걾ά��-"+Desc,
					modal:true,
					content:'<iframe id="timeline" frameborder="0" src="dhcperoomspecimen.hisui.csp?selectrow='+RowId+'&selectrowDesc='+Desc+'&RoomType='+RoomType+'" width="100%" height="100%" ></iframe>'
				});	
				*/
				lnk="dhcperoomspecimen.hisui.csp"+"?selectrow="+RowId+"&selectrowDesc="+Desc+"&RoomType="+RoomType	
				websys_lu(lnk,false,'width=710,height=400,hisui=true,title=���ұ걾ά��-'+Desc)
				
				
			}
}

//����Ĭ��ֵ
function SetDefault(){
	  $("#Sex").combobox('setValue',"N");
	  $("#Diet").combobox('setValue',"N");
	  $("#Emiction").combobox('setValue',"N");
  }
//�޸�(����ά��)
function BRUpdate_click(){
	 BRSave_click("1");
}

//����(����ά��)
function BRAdd_click(){
	 BRSave_click("0");
}

function BRSave_click(Type)
{

	 var Parref=$("#AreaID").val();
	 if(Parref==""){
		 $.messager.alert("��ʾ","����ѡ�����ҷ���","info");
			return false;
	 }

	var RoomID=$("#RoomID").val();
	if(Type=="1"){
		if(RoomID==""){
			$.messager.alert("��ʾ","��ѡ����޸ĵļ�¼","info");
			return false;
		}
	}
	
	if(Type=="0"){
	    if(RoomID!=""){
		    	$.messager.alert("��ʾ","�������ݲ���ѡ�м�¼,�����������������","info");
		    	return false;
		    }
	}
	
	var Code=$("#RoomCode").val();
	if (""==Code) {
		$("#RoomCode").focus();
		var valbox = $HUI.validatebox("#RoomCode", {
			required: true,
	    });
		$.messager.alert("��ʾ","���Ҵ��벻��Ϊ��","info");
		return false;
	}
	var Desc=$("#RoomDesc").val();
	if (""==Desc) {
		$("#RoomDesc").focus();
		var valbox = $HUI.validatebox("#RoomDesc", {
			required: true,
	    });
		$.messager.alert("��ʾ","������������Ϊ��","info");
		return false;
	}
	

	var Sort=$("#RoomSort").val();
	if (""==Sort) {
		$("#RoomSort").focus();
		var valbox = $HUI.validatebox("#RoomSort", {
			required: true,
	    });
		$.messager.alert("��ʾ","��Ų���Ϊ��","info");
		return false;
	}
	
	var Sex=$("#Sex").combobox('getValue');
	if (($("#Sex").combobox('getValue')==undefined)||($("#Sex").combobox('getValue')=="")){var Sex="";}

	var Diet=$("#Diet").combobox('getValue');
	if (($("#Diet").combobox('getValue')==undefined)||($("#Diet").combobox('getValue')=="")){var Diet="";}

	var Emiction=$("#Emiction").combobox('getValue');
	if (($("#Emiction").combobox('getValue')==undefined)||($("#Emiction").combobox('getValue')=="")){var Emiction="";}

	var Station=$("#Station").combobox('getValue');
	if (($("#Station").combobox('getValue')==undefined)||($("#Station").combobox('getValue')=="")){var Station="";}

	
	var Remark=$("#Remark").val();
	var Minute=$("#Minute").val();
	var ShowNum=$("#ShowNum").val();
	var Parref=$("#AreaID").val();
	var DoctorDR=$("#DocName").combogrid('getValue');
	if (($("#DocName").combogrid('getValue')==undefined)||($("#DocName").combogrid('getValue')=="")){var DoctorDR="";}

	
	var iActiveFlag="Y";
	var ActiveFlag=$("#ActiveFlag").checkbox('getValue');
	if (!ActiveFlag) iActiveFlag="N";
	var iBangdingFlag="N";
	var IFBangding=$("#IFBangding").checkbox('getValue');
	if (IFBangding) {iBangdingFlag="Y";}
	else{iBangdingFlag="N";}
	var VIPLevel="";
	
	var MainManager=$("#MainManager").combobox('getValue');
	
	var PriorNum=$("#PriorNum").val();
	
	if (($("#MainManager").combobox('getValue')==undefined)||($("#MainManager").combobox('getValue')=="")){var MainManager="";}
  
	var Str=Parref+"^"+Code+"^"+Desc+"^"+Sort+"^"+Sex+"^"+Diet+"^"+Emiction+"^"+Station+"^"+Remark+"^"+Minute+"^"+DoctorDR+"^"+iActiveFlag+"^"+ShowNum+"^"+iBangdingFlag+"^"+VIPLevel+"^"+MainManager+"^"+PriorNum;
	//debugger; // 2
	
	var rtn=tkMakeServerCall("web.DHCPE.RoomManager","UpdateRoom",RoomID,Str);
	var Arr=rtn.split("^");
	if (Arr[0]=="-1"){
		if(Type=="1"){$.messager.alert("��ʾ","�޸�ʧ��:"+Arr[1],"error");}
		if(Type=="0"){$.messager.alert("��ʾ","����ʧ��:"+Arr[1],"error");}		
	}else{
		
		BRClear_click();
		if(Type=="1"){$.messager.alert("��ʾ","�޸ĳɹ�","success");}
		if(Type=="0"){$.messager.alert("��ʾ","�����ɹ�","success");}	
	} 	
	
	
} 
//����(����ά��)
function BRClear_click(){
	$("#RoomID,#RoomCode,#RoomDesc,#RoomSort,#ShowNum,#Minute").val("");
	$(".hisui-checkbox").checkbox('setValue',false);
	$(".hisui-combobox").combobox('setValue',"");
	$(".hisui-combogrid").combogrid('setValue',"");
	var valbox = $HUI.validatebox("#RoomCode,#RoomDesc,#RoomSort", {
			required: false,
	    });
	$("#RoomGrid").datagrid('load',{
			ClassName:"web.DHCPE.RoomManager",
			QueryName:"FindRoom",
			Parref: $("#AreaID").val(),
		});	
	
  
   SetDefault();	
}


function InitRoomGrid(){
	$HUI.datagrid("#RoomGrid",{
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
		selectOnCheck: true,
		queryParams:{
			ClassName:"web.DHCPE.RoomManager",
			QueryName:"FindRoom",
		},
		columns:[[
		    {field:'TID',title:'ID',hidden: true},
			{field:'TCode',width:'80',title:'���Ҵ���'},
			{field:'TDesc',width:'150',title:'��������'},
			{field:'TSort',width:'40',title:'���'},
			{field:'TSex',width:'40',hidden:true},
			{field:'TSexDesc',width:'40',title:'�Ա�'},
			{field:'TDiet',width:'50',title:'�Ͳ�'},
			{field:'TEmiction',width:'50',title:'����'},
			{field:'TStation',width:'80',title:'վ��'},
			{field:'TActiveFlag',width:'50',align:'center',title:'����',
				formatter: function (value, rec, rowIndex) {
						if(value=="Y"){
							return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
						}else{
							return '<input type="checkbox" value="" disabled/>';
						}
                        
                    },
			},
			{field:'TShowNum',width:'80',title:'��ʾ����'},
			{field:'TIFBangding',width:'80',align:'center',title:'�Ƿ��',
				formatter: function (value, rec, rowIndex) {
						if(value=="Y"){
							return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
						}else{
							return '<input type="checkbox" value="" disabled/>';
						}
                        
                    },
			},
			{field:'TMinute',width:'80',title:'ʱ��'},
			{field:'TDoctorDesc',width:'100',title:'ҽ��'},
			{field:'TMainManagerRoom',hidden: true},
			{field:'TMainManagerRoomDesc',width:'100',title:'������'},
			{field:'TPriorNum',width:'100',title:'��������'},
			{field:'TRemark',width:'100',title:'��ע'}
				
		]],
		onSelect: function (rowIndex, rowData) {
			   
				$("#RoomID").val(rowData.TID);
				$("#RoomCode").val(rowData.TCode);
				$("#RoomDesc").val(rowData.TDesc);
				$("#RoomSort").val(rowData.TSort);
				$("#Sex").combobox('setValue',rowData.TSex);
				$("#Diet").combobox('setValue',rowData.TDietFlag);
				$("#Emiction").combobox('setValue',rowData.TEmictionFlag);
				$("#Station").combobox('setValue',rowData.TStationID);
				$("#ShowNum").val(rowData.TShowNum);
				$("#Minute").val(rowData.TMinute);
				$("#DocName").combogrid('setValue',rowData.TDoctorID);
				$("#Remark").val(rowData.TRemark);
				if(rowData.TIFBangding=="Y"){
					$("#IFBangding").checkbox('setValue',true);
				}else{
					$("#IFBangding").checkbox('setValue',false);
				}			
				if(rowData.TActiveFlag=="Y"){
					$("#ActiveFlag").checkbox('setValue',true);
				}else{
					$("#ActiveFlag").checkbox('setValue',false);
				}			
				//alert(rowData.TMainManagerRoom)
				$("#MainManager").combobox('setValue',rowData.TMainManagerRoom);
				$("#PriorNum").val(rowData.TPriorNum);				
					
		}

			
	})
}



function loadRoomList(rowData){
	$('#RoomGrid').datagrid('load', {
		ClassName:"web.DHCPE.RoomManager",
		QueryName:"FindRoom",
		Parref: rowData.TID
		
	});
	//$('#InvPrtId').val(row.TRowId);
}
/******************************����ά������end********************/

/******************************����ά������start********************/

//����λ��
function BRoomPlace_click(){
	lnk="dhcperoomplace.hisui.csp";	
	websys_lu(lnk,false,'width=900,height=600,hisui=true,title=����λ��');

	
}
 //�޸�(����ά��)
 function BUpdate_click(){
	 BSave_click("1");
 }
 
 //����(����ά��)
function BAdd_click(){
	BSave_click("0");
}

function BSave_click(Type)
{
	var AreaID=$("#AreaID").val();
	if(Type=="1"){
		
		if(AreaID==""){
			$.messager.alert("��ʾ","��ѡ����޸ĵļ�¼","info");
			return false;
		}
	}
	
	if(Type=="0"){
	    if(AreaID!=""){
		    	$.messager.alert("��ʾ","�������ݲ���ѡ�м�¼,�����������������","info");
		    	return false;
		    }
	}
	
	var Code=$("#AreaCode").val();
	if (""==Code) {
		$("#AreaCode").focus();
		var valbox = $HUI.validatebox("#AreaCode", {
			required: true,
	    });
		$.messager.alert("��ʾ","�������벻��Ϊ��","info");
		return false;
	}
	var Desc=$("#AreaDesc").val();
	if (""==Desc) {
		$("#AreaDesc").focus();
		var valbox = $HUI.validatebox("#AreaDesc", {
			required: true,
	    });
		$.messager.alert("��ʾ","������������Ϊ��","info");
		return false;
	}
	

	var Sort=$("#AreaSort").val();
	if (""==Sort) {
		$("#AreaSort").focus();
		var valbox = $HUI.validatebox("#AreaSort", {
			required: true,
	    });
		$.messager.alert("��ʾ","��Ų���Ϊ��","info");
		return false;
	}
	
	var LocID=session['LOGON.CTLOCID']
	var iAreaFlag="0";
	var AreaFlag=$("#AreaFlag").checkbox('getValue');
	if(AreaFlag) iAreaFlag="1";
	
	var Str=Code+"^"+Desc+"^"+Sort+"^"+LocID+"^"+""+"^"+iAreaFlag;
	
	var rtn=tkMakeServerCall("web.DHCPE.RoomManager","UpdateArea",AreaID,Str);
	var Arr=rtn.split("^");
	if (Arr[0]=="-1"){
		if(Type=="1"){$.messager.alert("��ʾ","�޸�ʧ��"+Arr[1],"error");}
		if(Type=="0"){$.messager.alert("��ʾ","����ʧ��"+Arr[1],"error");}		
	}else{
		
		BClear_click();
		if(Type=="1"){$.messager.alert("��ʾ","�޸ĳɹ�","success");}
		if(Type=="0"){$.messager.alert("��ʾ","�����ɹ�","success");}	
	} 	
	
	
}
//����(����ά��)
function BClear_click(){
	$("#AreaID,#AreaCode,#AreaDesc,#AreaSort").val("");
	$(".hisui-checkbox").checkbox('setValue',false);
	var valbox = $HUI.validatebox("#AreaCode,#AreaDesc,#AreaSort", {
			required: false,
	    });
	$("#AreaGrid").datagrid('load',{
			ClassName:"web.DHCPE.RoomManager",
			QueryName:"FindArea",
		});	
}
function InitAreaGrid(){
	$HUI.datagrid("#AreaGrid",{
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
		selectOnCheck: true,
		queryParams:{
			ClassName:"web.DHCPE.RoomManager",
			QueryName:"FindArea",
		},
		columns:[[
	
		    {field:'TID',title:'ID',hidden: true},
			{field:'TCode',width:'100',title:'��������'},
			{field:'TDesc',width:'150',title:'��������'},
			{field:'TSort',width:'60',title:'���'},
			{field:'TAreaFlag',width:'70',align:'center',title:'�����Ŷ�',
				formatter: function (value, rec, rowIndex) {
						if(value=="��"){
							return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
						}else{
							return '<input type="checkbox" value="" disabled/>';
						}
                        
                    },
			},
			
			
		]],
		onSelect: function (rowIndex, rowData) {
			$("#AreaCode").val(rowData.TCode);
			$("#AreaDesc").val(rowData.TDesc);
			$("#AreaSort").val(rowData.TSort);
			$("#AreaID").val(rowData.TID);
			if(rowData.TAreaFlag=="��"){
					$("#AreaFlag").checkbox('setValue',true);
				}else{
					$("#AreaFlag").checkbox('setValue',false);
				}			
			
			$('#RoomGrid').datagrid('loadData', {
				total: 0,
				rows: []
			});
			loadRoomList(rowData);
		}
		
			
	})
}

/******************************����ά������end********************/


function InitCombobox(){
	//����
	var EmictionObj = $HUI.combobox("#Emiction",{
		valueField:'id',
		textField:'text',
		panelHeight:'100',
		data:[
            {id:'N',text:'����'},
            {id:'HE',text:'����'},
            {id:'EE',text:'����'},
           
        ]

	});
	
	//�Ͳ�
	var DietObj = $HUI.combobox("#Diet",{
		valueField:'id',
		textField:'text',
		panelHeight:'100',
		data:[
            {id:'N',text:'����'},
            {id:'PRE',text:'��ǰ'},
            {id:'POST',text:'�ͺ�'},
           
        ]

	});
	
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
	
		
	//վ��
	var StationObj = $HUI.combobox("#Station",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindStationBase&ResultSetType=array",
		valueField:'id',
		textField:'desc'
		})
		
	// ������
	var StationObj = $HUI.combobox("#MainManager",{
		url:$URL+"?ClassName=web.DHCPE.RoomManager&QueryName=FindRoomNew&ResultSetType=array",
		valueField:'TID',
		textField:'TDesc'
		})
			
	
	//ҽ��
	   var DocNameObj = $HUI.combogrid("#DocName",{
		panelWidth:270,
		url:$URL+"?ClassName=web.DHCPE.Report.DoctorWorkStatistic&QueryName=SearchUSERSXT",
		mode:'remote',
		delay:200,
		idField:'DocDr',
		textField:'DocName',
		onBeforeLoad:function(param){
			param.Desc = param.q;
			param.LocID=session['LOGON.CTLOCID'];
			param.hospId=session['LOGON.HOSPID'];

		},
		columns:[[
		    {field:'DocDr',title:'ID',width:40},
			{field:'DocName',title:'����',width:200}
				
		]]
		})
	
	
}

