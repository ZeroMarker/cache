
//����   DHCPEIADMResultContrast.hisui.js
//����	����ȶ�hisui
//����	2021.01.21
//������  xy

$(function(){
		
	
	InitIADMResultContrastGrid();
	    
     //��ѯ
	$("#BFind").click(function() {	
		BFind_click();		
        });
        
           
     //����
	$("#BClear").click(function() {	
		BClear_click();		
        });  
          
        

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
	
	//����Ա�
	$("#BReaultContrast").click(function() {	
		BReaultContrast_Click();		
        });  
          
	
	//�Ա��б�
	$("#BResultContrastList").click(function() {	
		BResultContrastList_Click();		
        });  

	
})

//����Ա�
function BReaultContrast_Click()
{
	var ShowAbnormal="N";
	var IADM="",IADMStr="";
	
	
	var RegNo=$("#RegNo").val();
	/*
	if(RegNo==""){
		$.messager.alert("��ʾ","������ǼǺ�","info");
    	return false;
	}*/
	
	var DateFrom=$("#StartDate").datebox('getValue');
	var DateTo=$("#EndDate").datebox('getValue');
	var RegNo="",Flag=0;
	var selectrow = $("#IADMResultContrastGrid").datagrid("getChecked");//��ȡ�������飬��������
  	for(var i=0;i<selectrow.length;i++){
	  	var IADM=selectrow[i].RPT_PAADM_DR;
	  	if (IADMStr==""){IADMStr=IADM;}
			 else {IADMStr=IADMStr+"^"+IADM;}
			 if((RegNo!="")&&(selectrow[i].RPT_RegNo!=RegNo)) Flag=1;
             RegNo=selectrow[i].RPT_RegNo;
  	}
	if(Flag==1){
         $.messager.alert("��ʾ","ֻ�ܱȽϱ�������¼","info");
         return false;
    }
	if(IADMStr.split("^").length>3){
	     $.messager.alert("��ʾ","�����¼���ܳ�������","info");
    	return false;
    }
	if(IADMStr.split("^").length==1){
         $.messager.alert("��ʾ","����ѡ��2������¼","info");
        return false;
    }
    if (IADMStr==""){
	    $.messager.alert("��ʾ","��ѡ��Աȵľ����¼","info");
    	return false;
    	}
	var lnk="dhcpepatresulthistory.csp?AdmId="+IADMStr+"&RegNo="+RegNo+"&DateFrom="+DateFrom+"&DateTo="+DateTo+"&ShowAbnormal="+ShowAbnormal;
	//websys_lu(lnk,false,'width=1300,height=650,hisui=true,title=����Ա�')
	$HUI.window("#ReaultContrastWin", {
        title: "����Ա�",
        iconCls: "icon-w-edit",
        collapsible: false,
        minimizable: false,
        maximizable: false,
        resizable: false,
        closable: true,
        modal: true,
        width: 1300,
        height: 750,
        content: '<iframe src="' + PEURLAddToken(lnk) + '" width="100%" height="100%" frameborder="0"></iframe>'
    });
	
}

//�Ա��б�
function BResultContrastList_Click()
{
	
	var RegNo=$("#RegNo").val();
	/*
	if(RegNo==""){
		$.messager.alert("��ʾ","������ǼǺ�","info");
    	return false;
	}
	*/
	var lnk="dhcpepatresulthistorylist.csp?&RegNo="+RegNo;
	//websys_lu(lnk,false,'width=800,height=550,hisui=true,title=�Ա��б�')
	$HUI.window("#ResultContrastListWin", {
        title: "�Ա��б�",
        collapsible: false,
        minimizable: false,
        maximizable: false,
        resizable: false,
        closable: true,
        modal: true,
        width: 800,
        height: 550,
        content: '<iframe src="' + PEURLAddToken(lnk) + '" width="100%" height="100%" frameborder="0"></iframe>'
    });

}

function BClear_click()
{
	$("#RegNo,#Name").val("");
	$("#StartDate").datebox('setValue',"");
	$("#EndDate").datebox('setValue',"");
	BFind_click();
}


//��ѯ
function BFind_click(){
	
	var CTLocID=session['LOGON.CTLOCID'];
	var iRegNo=$("#RegNo").val(); 
	if(iRegNo!="") {
	 	var iRegNo=$.m({
			"ClassName":"web.DHCPE.DHCPECommon",
			"MethodName":"RegNoMask",
            "RegNo":iRegNo,
            "CTLocID":CTLocID
            
		}, false);
		
			$("#RegNo").val(iRegNo)
		}	
	$("#IADMResultContrastGrid").datagrid('load',{
			ClassName:"web.DHCPE.Report",
			QueryName:"SearchIADM",
			DateFrom:$("#StartDate").datebox('getValue'),
			DateTo:$("#EndDate").datebox('getValue'),
			RegNo:$("#RegNo").val(),
			PatName:$("#Name").val()
			
			})
	
}


function InitIADMResultContrastGrid()
{
	$HUI.datagrid("#IADMResultContrastGrid",{
		url:$URL,
		fit : true,
		border : false,
		striped : false,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		singleSelect: false,
		checkOnSelect: true, //���Ϊfalse, ���û����ڵ���ø�ѡ���ʱ��Żᱻѡ�л�ȡ��
		selectOnCheck: true,
		queryParams:{
			ClassName:"web.DHCPE.Report",
			QueryName:"SearchIADM",
			DateFrom:$("#StartDate").datebox('getValue'),
			DateTo:$("#EndDate").datebox('getValue'),
			RegNo:$("#RegNo").val(),
			PatName:$("#Name").val()
			
			
		},
		columns:[[
		    {field:'RPT_RowId',title:'RPTRowId',hidden: true},
		    {field:'RPT_IADM_DR',title:'IADM',hidden: true},
		    {field:'RPT_PAADM_DR',title:'PAADM',hidden: true},
		    {title: 'ѡ��',field: 'Select',width: 60,checkbox:true},
		    {field:'RPT_RegNo',width:150,title:'�ǼǺ�'},
		    {field:'RPT_IADM_DR_Name',width:180,title:'����'},
			{field:'RPT_IADM_RegDate',width:120,title:'�Ǽ�����'},
			{field:'RPT_GADM_DR_Name',width:450,title:'��λ'},
			{field:'RPT_IADM_Sex',width:70,title:'�Ա�'},
			{field:'RPT_IADM_Age',width:100,title:'����'},
			{field:'RPT_IADM_DOB',width:120,title:'��������'},
			{field:'THPNO',width:150,title:'����'} 
		
			
		]],
		onSelect: function (rowIndex, rowData) {
			  						
		}
		
			
	})
}

