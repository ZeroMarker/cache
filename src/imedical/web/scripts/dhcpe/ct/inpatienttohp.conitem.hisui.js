
//����	dhcpe/ct/inpatienttohp.conitem.hisui.js
//����	��������� ��Ժ��
//����	2021.08.12
//������  sxt
var lastIndex = "";
var EditIndex = -1;

var tableName = "DHC_PE_OthPatToHPBase";

var DetailtableName = "DHC_PE_OthPatToHPBaseCPT";


var SessionStr =session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']

$(function(){
		
	GetLocComp(SessionStr);
	
	InitCombobox();
	
	InitIPToHPConItemDataGrid();
      
    
    
    //������Ŀ
	$("#BSaveItem").click(function() {	
		BSaveItem_click();		
        });
        
       // ��ѯ
	$("#BFind").click(function() {
		var Active=$("#ActiveFlag").checkbox('getValue');
		if (Active) Active="Y";
		else Active="N";
		$("#IPToHPConItemQueryTab").datagrid('load',{
			ClassName:"web.DHCPE.CT.OtherPatientToHPBaseSet",
			QueryName:"FindCarPrvTp",
			curLoc:$("#LocList").combobox('getValue'),
			Active:Active
		});		
        });
        
    $("#BClear").click(function() {	
		BClear_click();		
        }); 
    
    $("#LocList").combobox({
		onSelect: function(rowData)
		{
			var Active=$("#ActiveFlag").checkbox('getValue');
			if (Active) Active="Y";
			else Active="N";
			$("#IPToHPConItemQueryTab").datagrid('load',{
			ClassName:"web.DHCPE.CT.OtherPatientToHPBaseSet",
			QueryName:"FindCarPrvTp",
			curLoc:$("#LocList").combobox('getValue'),
			Active:Active
		});	
		}
		
	})
    
    //$("#BGenRelateLoc").linkbutton('disable');
    //$("#BRelateLoc").linkbutton('disable');
     
   
})


function BClear_click(){
	$("#ID").val("");
	$(".hisui-combogrid").combogrid('setValue',"");
	$("#ActiveFlag").checkbox('setValue',true);
	var Active=$("#ActiveFlag").checkbox('getValue');
	if (Active) Active="Y";
	else Active="N";
	
	$("#IPToHPConItemQueryTab").datagrid('load',{
			ClassName:"web.DHCPE.CT.OtherPatientToHPBaseSet",
			QueryName:"FindCarPrvTp",
			curLoc: $("#LocList").combobox("getValue"),
			Active:Active
			
		});	
}





//������Ŀ
function BSaveItem_click()
{
	
	var LocID=$("#LocList").combobox('getValue'); //session['LOGON.CTLOCID'];
	var ID=$("#ID").val();
	if (ID==""){
		//$.messager.alert("��ʾ","��ѡ�����ݣ�Ȼ�󱣴�����","info");
		//return false;
	}
	
	var HPBUser=$("#HPBUser").combogrid('getValue');
	if ((HPBUser==undefined)||($("#HPBUser").combogrid('getText')=="")){var HPBUser="";}
	if(HPBUser==""){
	    $.messager.alert("��ʾ","��ѡ��ҽ����","info");
		return false;
	    
    }

	var ItemID=$("#ItemDesc").combogrid('getValue');
	if ((ItemID==undefined)||($("#ItemDesc").combogrid('getText')=="")){var ItemID="";}
	if(ItemID==""){
	    $.messager.alert("��ʾ","��ѡ����Ŀ��","info");
		return false;
	    
    }
    
	var CarPrvTp=$("#CarPrvTpDesc").combogrid('getValue');
   if ((CarPrvTp==undefined)||($("#CarPrvTpDesc").combogrid('getText')=="")){var CarPrvTp="";}
    if(CarPrvTp==""){
	    $.messager.alert("��ʾ","��ѡ��ҽ����Ա���ͣ�","info");
		return false;
	    
    }

	var iActiveFlag="N";
	var ActiveFlag=$("#ActiveFlag").checkbox('getValue');
	if(ActiveFlag) iActiveFlag="Y";
    if (($("#ItemDesc").combogrid('getValue')==undefined)||($("#ItemDesc").combogrid('getValue')=="")){var ItemID="";}
	
	var SessionUserID=session['LOGON.USERID'];
	
	var ret=tkMakeServerCall("web.DHCPE.CT.OtherPatientToHPBaseSet","SetCarPrvTpConOrder",CarPrvTp,LocID,ItemID,iActiveFlag,HPBUser,ID,SessionUserID);

	if(ret.split("^")[0]=="-1"){
		$.messager.alert("��ʾ",ret.split("^")[1],"error");
		
		}
	else{
		var Active=$("#ActiveFlag").checkbox('getValue');
		if (Active) Active="Y";
		else Active="N";
		
	 $("#IPToHPConItemQueryTab").datagrid('load',{
			ClassName:"web.DHCPE.CT.OtherPatientToHPBaseSet",
			QueryName:"FindCarPrvTp",
			curLoc:$("#LocList").combobox('getValue'),
			Active:Active
		});
		$.messager.alert("��ʾ","������Ŀ�ɹ�","success");
	}
}
 
 


function InitCombobox()
{
	     //ҽ������
	   var DefaultItemObj = $HUI.combogrid("#DefaultItemDesc",{
		url:$URL+"?ClassName=web.DHCPE.StationOrder&QueryName=ArcItmmastList",
		mode:'remote',
		delay:200,
		idField:'STORD_ARCIM_DR',
		textField:'STORD_ARCIM_Desc',
		onBeforeLoad:function(param){
			param.Desc = param.q;
			param.LocID=session['LOGON.CTLOCID'];
			param.hospId = session['LOGON.HOSPID'];
		},
		columns:[[
		    {field:'STORD_ARCIM_DR',title:'ID',width:40},
			{field:'STORD_ARCIM_Desc',title:'ҽ������',width:200},
			{field:'STORD_ARCIM_Code',title:'ҽ������',width:150}
			
				
		]]
		});
		
		
		
		//��Ŀ����
	var ArcimDescObj =$HUI.combogrid("#ItemDesc", {
		panelWidth:500,
		url:$URL+"?ClassName=web.DHCPE.StationOrder&QueryName=StationOrderList",
		mode:'remote',
		delay:200,
		idField:'STORD_ARCIM_DR',
		textField:'STORD_ARCIM_Desc',
		onBeforeLoad:function(param){
			param.Item = param.q;
			param.LocID = $("#LocList").combobox('getValue');
			param.hospId = tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","GetHospIDByLocID",$("#LocList").combobox('getValue'));
			
		},
		columns:[[
		
			{field:'STORD_ARCIM_DR',title:'ID',width:40},
			
			{field:'STORD_ARCIM_Code',title:'ҽ������',width:150},
			{field:'STORD_ARCIM_Desc',title:'ҽ������',width:200}
		
		    	
		]]
	});
		/*
		 //ҽ������
		var ItemObj = $HUI.combogrid("#ItemDesc",{
		panelWidth:470,
		url:$URL+"?ClassName=web.DHCPE.StationOrder&QueryName=ArcItmmastList",
		mode:'remote',
		delay:200,
		idField:'STORD_ARCIM_DR',
		textField:'STORD_ARCIM_Desc',
		onBeforeLoad:function(param){
			param.Desc = param.q;
			param.LocID=session['LOGON.CTLOCID'];
			param.hospId = session['LOGON.HOSPID'];
		},
		columns:[[
		    {field:'STORD_ARCIM_DR',title:'ID',width:40},
			{field:'STORD_ARCIM_Desc',title:'ҽ������',width:200},
			{field:'STORD_ARCIM_Code',title:'ҽ������',width:150}
					
		]]
		});
		
		*/
		//Ĭ��ҽ��
	    var OPNameObj = $HUI.combogrid("#HPBUser",{
		panelWidth:470,
		panelHeight:260,
		url:$URL+"?ClassName=web.DHCPE.Report.DoctorWorkStatistic&QueryName=SearchUSERSXT",
		mode:'remote',
		delay:200,
		minQueryLen:1,
        rownumbers:true,//��� 
		fit: true,
		pagination:true,
		pageSize: 20,
		pageList: [20,50,100],
		idField:'DocDr',
		textField:'DocName',
		onBeforeLoad:function(param){
			param.Desc = param.q;
			param.Type="B";
			param.LocID=session['LOGON.CTLOCID'];
			param.hospId = session['LOGON.HOSPID'];

		},
		columns:[[
		    {field:'DocDr',title:'ID',width:50},
			{field:'DocName',title:'����',width:200},
			{field:'Initials',title:'����',width:190} 
				
		]]

		});
		
		
		// ҽ����Ա����
	    var OPNameObj = $HUI.combogrid("#CarPrvTpDesc",{
		panelWidth:470,
		panelHeight:260,
		url:$URL+"?ClassName=web.DHCPE.CT.OtherPatientToHPBaseSet&QueryName=FindCarPrvTpNew",
		mode:'remote',
		delay:200,
		minQueryLen:1,
        rownumbers:true,//��� 
		fit: true,
		pagination:true,
		pageSize: 20,
		pageList: [20,50,100],
		idField:'CarPrvTpID',
		textField:'Desc',
		onBeforeLoad:function(param){
			/*
			param.Desc = param.q;
			param.Type="B";
			param.LocID=session['LOGON.CTLOCID'];
			param.hospId = session['LOGON.HOSPID'];
			*/

		},
		columns:[[
		    {field:'CarPrvTpID',title:'ID',width:50},
			{field:'Desc',title:'����',width:200}
				
		]]

		});

		

}

function InitIPToHPConItemDataGrid()
{
	
	  var LocID=session['LOGON.CTLOCID']
	  var LocListID=$("#LocList").combobox('getValue');
	  if(LocListID!=""){var LocID=LocListID; }
	  var Active=$("#ActiveFlag").checkbox('getValue');
	  if (Active) Active="Y";
	  else Active="N";
	$HUI.datagrid("#IPToHPConItemQueryTab",{
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
			ClassName:"web.DHCPE.CT.OtherPatientToHPBaseSet",
			QueryName:"FindCarPrvTp",
			curLoc:LocID,
			Active:Active
		},
		columns:[[
		
		    {field:'RowID',title:'CarPrvTpID',hidden: true},
			{field:'TypeDesc',width:'250',title:'ҽ����Ա����'},
			{field:'ARCIMID',title:'ARCIMID',hidden: true},
			{field:'ARCIMDesc',width:'300',title:'��Ŀ'},
			{field:'RealUserID',title:'RealUserID',hidden: true},
			{field:'Type',title:'Type',hidden: true},
			{field:'UserName',width:'120',title:'ҽ��'},
			{field:'CurActiveDesc',width:'80',title:'����',align:'center',
				formatter: function (value, rec, rowIndex) {
					if(value=="��"){
						return '<input type="checkbox" checked="checked" disabled/>';
					}else{
						return '<input type="checkbox" value="" disabled/>';
					}
			 }
			}	
		
		]],
		onSelect: function (rowIndex, rowData) {
			   
			   ///debugger; //	
				$("#ID").val(rowData.RowID);
				$('#CarPrvTpDesc').combogrid('grid').datagrid('reload',{'q':rowData.TypeDesc});
				$("#CarPrvTpDesc").combogrid('setValue',rowData.Type);
				$("#ItemDesc").combogrid("grid").datagrid("reload",{"q":rowData.ARCIMDesc});
				//alert(rowData.ARCIMID)
				//alert(rowData.ARCIMDesc)
				$("#ItemDesc").combogrid('setValue',rowData.ARCIMID);
				//alert(rowData.ARCIMDesc)
				$("#HPBUser").combogrid("grid").datagrid("reload",{"q":rowData.UserName});
				$("#HPBUser").combogrid('setValue',rowData.RealUserID);
				if(rowData.CurActiveDesc=="��"){
					$("#ActiveFlag").checkbox('setValue',true);
				}
				else{
					$("#ActiveFlag").checkbox('setValue',false);
					}
    			
					
					
		}
		
			
	})

}


