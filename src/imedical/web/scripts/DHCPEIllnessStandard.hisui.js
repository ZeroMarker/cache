
//����	DHCPEIllnessStandard.hisui.js
//����	����ά��
//����	2019.06.05
//������  xy

$(function(){
		
	InitCombobox();
	
	InitIllnessFindDataGrid();
   
    //��ѯ
	$("#BFind").click(function() {	
		BFind_click();		
        });
      
    //����
	$("#BClear").click(function() {	
		BClear_click();		
        });
        
    //����
    $('#add_btn').click(function(e){
    	AddData();
    });
    
    //�޸�
    $('#update_btn').click(function(){
    	UpdateData();
    });
    
    //����ά��
     $('#Alias_btn').click(function(){
    	Alias_Click();
    });
    
    //�����뽨�����
     $('#ILLED_btn').click(function(){
    	ILLED_Click();
    });
    
    //��������
     $('#IllExplain_btn').click(function(){
    	IllExplain_Click();
    });
    
    //�˶�ָ��
     $('#IllSportGuide_btn').click(function(){
    	IllSportGuide_Click();
    });
    
   //��ʳָ��
	$('#IllDietGuide_btn').click(function(){
    	IllDietGuide_Click();
    });
    
    // IllCondition_btn ����ָ��
  	$('#IllCondition_btn').click(function(){
    	IllCondition_Click();
    });
  
      
})

function IllCondition_Click(){
	
	var ID=$("#ILLSRowId").val();
	var Desc=$("#ILLSDesc").val();
	//alert(ID)
	//alert(Desc)
	lnk="dhcpeillnesscondition.hisui.csp"+"?ParrefRowId="+ID+"&Desc="+Desc;
					
	websys_lu(lnk,false,'iconCls=icon-w-edit,width=1280,height=600,hisui=true,title=����ָ��ά��-'+Desc);
	
}

//��������
function IllExplain_Click(){
	ILLEDSave_Click("1");
}

//�˶�ָ��
function IllSportGuide_Click(){
	ILLEDSave_Click("2");
}

//��ʳָ��
function IllDietGuide_Click(){
	ILLEDSave_Click("3");
}

function ILLEDSave_Click(Type){
	var ID=$("#ILLSRowId").val();
	var Desc=$("#ILLSDesc").val();
	$("#ILLSName").val(Desc);
	if(ID==""){
		$.messager.alert('��ʾ','��ѡ���ά���ļ�¼',"info");
	     return false;
	}
	if(Type=="1"){ 
		var title="��������-"+Desc;
		document.getElementById("TIllExplain").innerHTML="��������";
	}
	if(Type=="2"){ 
		var title="�˶�ָ��-"+Desc;
		
		document.getElementById("TIllExplain").innerHTML="�˶�ָ��";
	}
	if(Type=="3"){ 
		var title="��ʳָ��-"+Desc;
		document.getElementById("TIllExplain").innerHTML="��ʳָ��";
	}
	
	
	var IllEStr=tkMakeServerCall("web.DHCPE.IllnessStandard","GetIllInfo",ID,Type);
		   var ILLEList=IllEStr.split("@@");
		   $("#IllExplain").val(ILLEList[0]);
		   
		   if(ILLEList[1]=="Y"){
			    $("#PrintFlag").checkbox('setValue',true);
		   }else{
			   $("#PrintFlag").checkbox('setValue',false);
		   }
		  
		   
	$("#IllExplainWin").show();
	 
		var myWin = $HUI.dialog("#IllExplainWin",{
			iconCls:'icon-w-save',
			resizable:true,
			title:title,
			modal:true,
			buttonAlign : 'center',
			buttons:[{
				text:'����',
				id:'saveILLE_btn',
				handler:function(){
					SaveILLEForm(ID,Type)
				}
			},{
				text:'�ر�',
				handler:function(){
					myWin.close();
				}
			}]
		});
		
}
SaveILLEForm=function(ID,Type)
{ 
    
	var IllExplain=$("#IllExplain").val();
	var iPrintFlag="N"
  	var PrintFlag=$("#PrintFlag").checkbox('getValue');
	if(PrintFlag) {iPrintFlag="Y";}
    
    var Instring=ID+"^"+IllExplain+"^"+Type+"^"+iPrintFlag;
    //alert(Instring)
    var flag=tkMakeServerCall("web.DHCPE.IllnessStandard","SaveIllExplain",Instring);
	 if(flag==0){
		    $.messager.popover({msg: '����ɹ���',type:'success',timeout: 1000});
		    $("#IllnessFindGrid").datagrid('load',{
			   ClassName:"web.DHCPE.IllnessStandard",
				QueryName:"QueryED",
				Code:$("#Code").val(),
		   	 	DiagnoseConclusion:$("#DiagnoseConclusion").val(),
				Alias:$("#Alias").val(),
			    }); 
			$('#IllExplainWin').dialog('close'); 
	    }else{
		    $.messager.alert('��ʾ',"����ʧ��:  "+flag,"error");
	    }
		
	}
	
//�����뽨�����
function ILLED_Click(){
		var record = $("#IllnessFindGrid").datagrid("getSelected"); 
	
			if (!(record)) {
				$.messager.alert('��ʾ','��ѡ���ά���ļ�¼!',"warning");
				return;
			} else {  
				var illDesc=record.ED_DiagnoseConclusion
				var illRowId=record.ED_RowId
				/*
				$("#myWinILLED").show();  
				var myWinGuideImage = $HUI.window("#myWinILLED",{
					resizable:true,
					collapsible:false,
					minimizable:false,
					iconCls:'icon-w-paper',
					title:"�����뽨�����-"+illDesc,
					modal:true,
					content:'<iframe id="timeline" frameborder="0" src="dhcpeilledrelate.hisui.csp?selectrow='+illRowId+'&selectrowDesc='+illDesc+'" width="100%" height="99%" ></iframe>'
				});	
				*/
				lnk="dhcpeilledrelate.hisui.csp"+"?selectrow="+illRowId+"&selectrowDesc="+illDesc;
					
				websys_lu(lnk,false,'iconCls=icon-w-edit,width=880,height=400,hisui=true,title=�����뽨�����-'+illDesc);

			}
}

	
//����ά��
function Alias_Click(){
	
	var record = $("#IllnessFindGrid").datagrid("getSelected"); 
	
			if (!(record)) {
				$.messager.alert('��ʾ','��ѡ���ά���ļ�¼!',"warning");
				return;
			} else {  
				var illDesc=record.ED_DiagnoseConclusion
				var illRowId=record.ED_RowId
				/*
				$("#myWinAlias").show();  
				var myWinGuideImage = $HUI.window("#myWinAlias",{
					resizable:true,
					collapsible:false,
					minimizable:false,
					iconCls:'icon-w-paper',
					title:"����ά��-"+illDesc,
					modal:true,
					content:'<iframe id="timeline" frameborder="0" src="dhcpeillsalias.hisui.csp?selectrow='+illRowId+'&selectrowDesc='+illDesc+'" width="100%" height="99%" ></iframe>'
				});	
				*/
				lnk="dhcpeillsalias.hisui.csp"+"?selectrow="+illRowId+"&selectrowDesc="+illDesc;
					
				websys_lu(lnk,false,'iconCls=icon-w-edit,width=800,height=400,hisui=true,title=����ά��-'+illDesc);

				
			}
}

//����
function AddData()
{
	
	$("#myWin").show();
	 
		var myWin = $HUI.dialog("#myWin",{
			iconCls:'icon-w-add',
			resizable:true,
			title:'����',
			modal:true,
			buttonAlign : 'center',
			buttons:[{
				text:'����',
				id:'save_btn',
				handler:function(){
					SaveForm("")
				}
			},{
				text:'�ر�',
				handler:function(){
					myWin.close();
				}
			}]
		});
		$('#form-save').form("clear");
		var MaxCode=tkMakeServerCall("web.DHCPE.IllnessStandard","GetMaxCode");
	    $("#IllCode").val(MaxCode);
		//Ĭ��ѡ��
		//$HUI.checkbox("#CommonIllness").setValue(true);	
	
}

SaveForm=function(id)
{
	 var UserId=session['LOGON.USERID'];
	
	var Code=$("#IllCode").val();
	 
	 if (""==Code){
		$("#IllCode").focus();
	
		 $.messager.alert('��ʾ','������Ų���Ϊ��',"info");
		return false
  	} 
  	
  	var Illness="N";
  	var iCommonIllness="N"
  	var CommonIllness=$("#CommonIllness").checkbox('getValue');
	if(CommonIllness) {iCommonIllness="Y";}
  	
  	var iIfCompare="N"
  	var CommonIllness=$("#IfCompare").checkbox('getValue');
	if(CommonIllness) {iIfCompare="Y";}
 	
  	var DiagnoseConclusion=$("#IllDesc").val();
	if (""==DiagnoseConclusion){
		$("#IllDesc").focus();
		
		$.messager.alert('��ʾ','�������Ʋ���Ϊ��',"info");
		return false
  	} 
  	
	var InsertType=""
	
  	var EDAlias=$("#IllAlias").val();
  	
  	
  	var Detail=$("#IllDetail").val()
	if (""==Detail){
		
		$.messager.alert('��ʾ','�������鲻��Ϊ��',"info");
		return false
  	} 
	  	
    var ToReport=0;
    var SexDR=$("#Sex").combobox('getValue');
    if (($('#Sex').combobox('getValue')==undefined)||($('#Sex').combobox('getValue')=="")){var SexDR="";}
	var Type=$("#Type").combobox('getValue');
	if (($('#Type').combobox('getValue')==undefined)||($('#Type').combobox('getValue')=="")){var Type="";}
	
	var TypeNew=$("#TypeNew").combobox('getValue');
	if (($('#TypeNew').combobox('getValue')==undefined)||($('#TypeNew').combobox('getValue')=="")){var TypeNew="";}
	
	var ILLSStation=$("#ILLSStation").combobox('getValue');
	if (($('#ILLSStation').combobox('getValue')==undefined)||($('#ILLSStation').combobox('getValue')=="")){var ILLSStation="";}
	
	var FatherIll=$("#FatherIll").combobox('getValue');
	if (($('#FatherIll').combobox('getValue')==undefined)||($('#FatherIll').combobox('getValue')=="")){var FatherIll="";}
	
	var note=$("#IllNote").val();
	
		
	if(id==""){
		var Instring=Code+"^"+DiagnoseConclusion+"^"+Detail+"^"+Illness+"^"+iCommonIllness+"^"+UserId+"^"+InsertType+"^"+EDAlias+"^"+ToReport+"^"+SexDR+"^^"+Type+"^"+TypeNew+"^"+ILLSStation+"^"+FatherIll+"^"+note+"^"+iIfCompare;
		var ReturnStr=tkMakeServerCall("web.DHCPE.IllnessStandard","InsertED",Instring);
		var flag=ReturnStr.split("^")[0];
		
	}else{
		
		var InString=Code+"^"+DiagnoseConclusion+"^"+Detail+"^^^"+Illness+"^"+iCommonIllness+"^"+ToReport+"^"+SexDR+"^^"+Type+"^"+TypeNew+"^"+ILLSStation+"^"+FatherIll+"^"+note+"^"+iIfCompare;  
		 //alert(InString)
		 var flag=tkMakeServerCall("web.DHCPE.IllnessStandard","UpdateED",id,InString);
		   
	   }
	    if(flag==0){
		    $.messager.popover({msg: '����ɹ���',type:'success',timeout: 1000});
		    $("#IllnessFindGrid").datagrid('load',{
			   ClassName:"web.DHCPE.IllnessStandard",
				QueryName:"QueryED",
				Code:$("#Code").val(),
		   	 	DiagnoseConclusion:$("#DiagnoseConclusion").val(),
				Alias:$("#Alias").val(),
			    }); 
			$('#myWin').dialog('close'); 
	    }else{
		    $.messager.alert('��ʾ',"����ʧ��","error");
	    }
		
	}
	
function UpdateData()
{
	var ID=$("#ILLSRowId").val();
	if(ID==""){
		$.messager.alert('��ʾ',"��ѡ����޸ĵļ�¼","info");
		return
	}
	if(ID!="")
	{	
	      var EDStr=tkMakeServerCall("web.DHCPE.IllnessStandard","InitED",ID);
		   var EDList=EDStr.split("^");
		   $("#IllCode").val(EDList[0]);
		   $("#IllDesc").val(EDList[1]);
		   $("#IllDetail").val(EDList[2]);
		 
		   if(EDList[6]=="Y"){
			    $("#CommonIllness").checkbox('setValue',true);
		   }else{
			   $("#CommonIllness").checkbox('setValue',false);
		   }
		   $("#Sex").combobox('setValue',EDList[8]);
		   $("#Type").combobox('setValue',EDList[10]);
		   $("#TypeNew").combobox('setValue',EDList[11]);
		   $("#ILLSStation").combobox('setValue',EDList[12]);
		   $("#FatherIll").combobox('setValue',EDList[13]);
		   $("#IllNote").val(EDList[14]);
		  // alert(EDList[15])
		   if(EDList[15]=="Y"){
			    $("#IfCompare").checkbox('setValue',true);
		   }else{
			   
			   $("#IfCompare").checkbox('setValue',false);
		   }
		   
			$("#myWin").show();
			
			var myWin = $HUI.dialog("#myWin",{
				iconCls:'icon-w-edit',
				resizable:true,
				title:'�޸�',
				modal:true,
				buttons:[{
					text:'����',
					id:'save_btn',
					handler:function(){
						SaveForm(ID)
					}
				},{
					text:'�ر�',
					handler:function(){
						myWin.close();
					}
				}]
			});							
	}
}

//��ѯ
function BFind_click(){
	$("#IllnessFindGrid").datagrid('clearSelections');
	$("#IllnessFindGrid").datagrid('load',{
			ClassName:"web.DHCPE.IllnessStandard",
			QueryName:"QueryED",
			Code:$("#Code").val(),
		    DiagnoseConclusion:$("#DiagnoseConclusion").val(),
			Alias:$("#Alias").val(),
		});	
		
		$("#ILLSRowId").val("");
		$("#ILLSDesc").val("");

}

//����
function BClear_click(){
	$("#Code,#DiagnoseConclusion,#Alias").val("");
	BFind_click();
}

/// TypeNew,ILLSStation,FatherIll,Note,TypeNewDesc,ILLSStationDesc,FatherIllDesc
function InitIllnessFindDataGrid(){
	$HUI.datagrid("#IllnessFindGrid",{
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
			ClassName:"web.DHCPE.IllnessStandard",
			QueryName:"QueryED",
			Code:$("#Code").val(),
		    DiagnoseConclusion:$("#DiagnoseConclusion").val(),
			Alias:$("#Alias").val(),
		    
		},
		frozenColumns:[[
			{field:'ED_Code',width:'100',title:'���'},
			{field:'ED_DiagnoseConclusion',width:'150',title:'��������'},
		]],
		columns:[[
		    {field:'ED_RowId',title:'ID',hidden: true},
			{field:'ED_CommonIllness',width:'40',title:'������'},
			{field:'TSex',width:'40',title:'�Ա�'},
			{field:'TType',width:'100',title:'����'},
			{field:'ED_Detail',width:'650',title:'����'},
			{field:'TypeNewDesc',width:'50',title:'���'},
			{field:'ILLSStationDesc',width:'80',title:'վ��'},
			{field:'FatherIllDesc',width:'80',title:'�������'},
			{field:'IfCompare',width:'50',title:'�Ա�'},
			{field:'TNote',width:'600',title:'��ע'}
		
		]],
		onSelect: function (rowIndex, rowData) {
			   
				$("#ILLSRowId").val(rowData.ED_RowId);
				$("#ILLSDesc").val(rowData.ED_DiagnoseConclusion);
				
					
		}
		
			
	})
}


function InitCombobox(){
	
	// ���
	var SexObj = $HUI.combobox("#TypeNew",{
		valueField:'id',
		textField:'text',
		panelHeight:'100',
		data:[
            {id:'1',text:'����'},
            {id:'2',text:'����'},
            {id:'3',text:'��Ŀ'},
           
        ]

		});
		
	// վ��
	var SexObj = $HUI.combobox("#ILLSStation",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindStationBase&ResultSetType=array",
		valueField:'id',
		textField:'desc'

		});
	// �������
	var SexObj = $HUI.combobox("#FatherIll",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindIllness&ResultSetType=array",
		valueField:'id',
		textField:'desc'

		});
	
	//�Ա�
	var SexObj = $HUI.combobox("#Sex",{
		valueField:'id',
		textField:'text',
		panelHeight:'100',
		data:[
            {id:'M',text:'��'},
            {id:'F',text:'Ů'},
            {id:'N',text:'����'},
           
        ]

		});
		
	//����
	var TypeObj = $HUI.combobox("#Type",{
		valueField:'id',
		textField:'text',
		panelHeight:'100',
		data:[
            {id:'1',text:'���屨��'},
            {id:'2',text:'����ͳ��'},
            {id:'3',text:'����ͳ��'},
            
        ]

		});
}

