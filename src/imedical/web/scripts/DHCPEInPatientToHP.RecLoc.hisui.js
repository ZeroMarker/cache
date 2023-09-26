
//����	DHCPEInPatientToHP.RecLoc.hisui.js
//����	����ѽ��տ�������
//����	2019.05.06
//������  xy

$(function(){
		
	InitCombobox();
	
	InitIPToHPRecLocDataGrid();
      
    //�������Ա
	$("#BSaveGenConUser").click(function() {	
		BSaveGenConUser_click();		
        });
    
    //���տ���
	$("#BSaveRecLoc").click(function() {	
		BSaveRecLoc_click();		
        });
        
   
})

//�������Ա
function BSaveGenConUser_click()
{
	var LocID=session['LOGON.CTLOCID'];
	var UserID=$("#GenConUser").combogrid('getValue');
	if (($("#GenConUser").combogrid('getValue')==undefined)||($("#GenConUser").combogrid('getValue')=="")){var UserID="";}
	var reg = /^[0-9]+.?[0-9]*$/;
    if((!(reg.test(UserID)))&&(UserID!="")){var UserID=$("#GenConUserID").val();}

	if ( UserID==""){
		//$.messager.alert("��ʾ","��ѡ���ܼ�������Ա","info");
		//return false;
	}
	var ret=tkMakeServerCall("web.DHCPE.OtherPatientToHPBaseSet","SetGenConUser",LocID,UserID);
	$("#IPToHPRecLocQueryTab").datagrid('load',{
			ClassName:"web.DHCPE.OtherPatientToHPBaseSet",
			QueryName:"FindStation",
		});
		$.messager.alert("��ʾ","�ܼ�������Ա���óɹ�","success");
	
	
}

//���տ���
function BSaveRecLoc_click()
{
	
	
	var LocID=session['LOGON.CTLOCID'];
	var StationID=$("#ID").val();
	if (StationID==""){
		$.messager.alert("��ʾ","��ѡ��վ�㣬Ȼ�󱣴�����","info");
		return false;
	}
	var RecLocID=$("#RecLocDesc").combogrid('getValue');
	//alert(RecLocID)
	if (($("#RecLocDesc").combogrid('getValue')==undefined)||($("#RecLocDesc").combogrid('getValue')=="")){var RecLocID="";}

	var DefaultDocID=$("#DefaultDoc").combogrid('getValue');
	if (($("#DefaultDoc").combogrid('getValue')==undefined)||($("#DefaultDoc").combogrid('getValue')=="")){var DefaultDocID="";}
      
     var reg = /^[0-9]+.?[0-9]*$/;
    if((!(reg.test(RecLocID)))&&(RecLocID!="")){var RecLocID=$("#RecLocID").val();}
    if((!(reg.test(DefaultDocID)))&&(DefaultDocID!="")){var DefaultDocID=$("#DefaultDocID").val();}
	//alert(RecLocID+"^"+DefaultDocID)


	var ret=tkMakeServerCall("web.DHCPE.OtherPatientToHPBaseSet","SetStationConRecLoc",LocID,StationID,RecLocID+"^"+DefaultDocID);
	$("#IPToHPRecLocQueryTab").datagrid('load',{
			ClassName:"web.DHCPE.OtherPatientToHPBaseSet",
			QueryName:"FindStation",
		});
		$.messager.alert("��ʾ","���տ������óɹ�","success");	
}
 
 


function InitCombobox()
{
	  //Ĭ���ܼ�����
	   var OPNameObj = $HUI.combogrid("#GenConUser",{
		panelWidth:470,
		url:$URL+"?ClassName=web.DHCPE.Report.DoctorWorkStatistic&QueryName=SearchUSERSXT",
		mode:'remote',
		delay:200,
		idField:'DocDr',
		textField:'DocName',
		onBeforeLoad:function(param){
			param.Desc = param.q;
		},
		columns:[[
		    {field:'DocDr',title:'ID',width:40},
		    {field:'Initials',title:'����',width:200},
			{field:'DocName',title:'����',width:200},	
				
		]]
		});
		
		 //Ĭ��ҽ��
	   var OPNameObj = $HUI.combogrid("#DefaultDoc",{
		panelWidth:470,
		url:$URL+"?ClassName=web.DHCPE.Report.DoctorWorkStatistic&QueryName=SearchUSERSXT",
		mode:'remote',
		delay:200,
		idField:'DocDr',
		textField:'DocName',
		onBeforeLoad:function(param){
			param.Desc = param.q;
		},
		columns:[[
		    {field:'DocDr',title:'ID',width:40},
		    {field:'Initials',title:'����',width:200},
			{field:'DocName',title:'����',width:200},
				
		]]
		});
		 //���տ���
	   var OPNameObj = $HUI.combogrid("#RecLocDesc",{
		panelWidth:470,
		url:$URL+"?ClassName=web.DHCPE.Public.SettingEdit&QueryName=Querytest",
		mode:'remote',
		delay:200,
		idField:'CTLOCID',
		textField:'Desc',
		onBeforeLoad:function(param){
			param.ctlocdesc= param.q;
		},
		columns:[[
		    {field:'CTLOCID',title:'ID',width:40},
		    {field:'Desc',title:'����',width:200},
			{field:'CTLOCCODE',title:'����',width:200},
				
		]]
		});
		
}

function InitIPToHPRecLocDataGrid()
{
	$HUI.datagrid("#IPToHPRecLocQueryTab",{
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
			ClassName:"web.DHCPE.OtherPatientToHPBaseSet",
			QueryName:"FindStation",
		},
		columns:[[
	
		    {field:'StationID',title:'StationID',hidden: true},
			{field:'ReclocID',title:'StationID',hidden: true},
		    {field:'UserID',title:'StationID',hidden: true},
			{field:'StationDesc',width:'250',title:'վ������'},
			{field:'RecLocDesc',width:'250',title:'���տ���'},
			{field:'DefaultDoc',width:'250',title:'Ĭ��ҽ��'},
			{field:'GenConUserDesc',width:'250',title:'�ܼ�������Ա'},
			
			
		
		]],
		onSelect: function (rowIndex, rowData) {
			    
				$("#ID").val(rowData.StationID);
				$("#DefaultDocID").val(rowData.ReclocID);
				$("#RecLocID").val(rowData.UserID);
				$("#StationDesc").val(rowData.StationDesc);
				$("#RecLocDesc").combogrid('setValue',rowData.RecLocDesc);
				$("#DefaultDoc").combogrid('setValue',rowData.DefaultDoc);
				$("#GenConUser").combogrid('setValue',rowData.GenConUserDesc); 
				$("#GenConUserID").val(rowData.GenConUserID);

					
		}
		
			
	})

}


