/*
 * FileName: dhcpe/ct/orderdetailrelatecom.js
 * Author: xy
 * Date: 2021-08-14
 * Description: �����ϸ����չ�ϵά��
 */
 
var odrtableName = "DHC_PE_OrderDetailRelate"; //�����ϸ����չ�ϵ
var tableName ="DHC_PE_StationOrder";  //վ�����Ŀ��ϱ�
var SessionStr =session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']

$(function(){
	
	//��ȡ���������б�
	GetLocComp(SessionStr)

	//���������б�change
	$("#LocList").combobox({
	 onSelect:function(){
		 BFind_click();
		 $("#OrderID,#ARCIMDesc").val('');
		 BAFind_click();
		BClear_click();
	       	    		 
	 }
	})

	InitCombobox();
		
	//��ʼ�� վ��Grid 
	InitStationGrid()
	 
	//��ѯ��վ�㣩
	$("#BFind").click(function() {	
		BFind_click()		
	})
 
	$("#Desc").keydown(function(e) {	
		if(e.keyCode==13){
			BFind_click()
		}
	})
  
	//��ʼ����ĿGrid 
	InitLocOrderGrid()

	//��ѯ����Ŀ��
	$("#BAFind").click(function() {	
		BAFind_click()	
	})
 
	$("#ARCDesc").keydown(function(e) {	
		if(e.keyCode==13){
			BAFind_click()
		}
	})

	//��ʼ��ϸ�����Grid 
	InitODRelateComDataGrid()

	//����
	$("#BClear").click(function(e){
		BClear_click();
	});
	     
	//����
	$("#BAdd").click(function(e){
		BAdd_click();
	});
    
	//�޸�
	$("#BUpdate").click(function(){
	BUpdate_click();
	});
    
	//ɾ��
	$("#BDelete").click(function(e){
		BDelete_click();
	}); 
 
	$('#NoActive').checkbox({
		onCheckChange:function(e,vaule){
			LoadODRelateComDatalist();
			
		}
			
	});  

	//����LIS��Ŀ
	$("#BImport").click(function(e){
	 BImport_click();
	 }); 
    
	iniForm(); 

	//��Ȩ����
	$("#BRelateLoc").click(function(){
		BRelateLoc_click();
	})
	
})

function iniForm(){
	
	var StationID=$("#StationID").val();
	
	var globalLoc = $("#LocList").combobox("getValue");
	var LocID= globalLoc != "" ? globalLoc : session["LOGON.CTLOCID"];
	
	var StationType = tkMakeServerCall("web.DHCPE.CT.HISUICommon","GetStationTypeByID",StationID,LocID);
	
    if(StationType=="LIS"){
        $("#BImport").linkbutton('enable');
    }else{
        $("#BImport").linkbutton('disable');
    }
	
}

//����
function BImport_click()
{
	var UserID=session['LOGON.USERID'];
	
    var globalLoc = $("#LocList").combobox("getValue");
	var LocID= globalLoc != "" ? globalLoc : session["LOGON.CTLOCID"];
	
	var StationID=$("#StationID").val();
	
	var ARCIMDr=$("#ARCIMDR").val(); 
	if(ARCIMDr==""){
		$.messager.alert("��ʾ","��ѡ��ҽ���","info");
		return false;	
	 }
	
	var OrderDR=$("#OrderID").val();
	
	var LocGrpID=tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","GetLocGrpByLocID",LocID);
	if(LocGrpID.split("^")[0]=="-1"){
		$.messager.alert("��ʾ","�ÿ���û��ά����Ӧ��Ĭ�Ͽ��ң�","info");
		return false;
		
	}
	var LocStr=tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","GetLocIDByLocGrp",LocGrpID);
	if(LocStr.split("^")[0]=="-1"){
		$.messager.alert("��ʾ","��������û�ж�Ӧ�Ŀ���ID��","info");
		return false;
		
	}
    
	var flag=tkMakeServerCall("web.DHCPE.TransOrderDetail","MainNew",ARCIMDr,StationID,OrderDR,LocID,UserID,LocStr);
	
	BClear_click();
	
}
/**********************ϸ����� start************************************/
/*
//������Ȩ/ȡ����Ȩ
function BPower_click(){
	var DateID=$("#ODRRowId").val()
	if (DateID==""){
		$.messager.alert("��ʾ","��ѡ����Ҫ������Ȩ�ļ�¼","info"); 
		return false;
	}
	var selected = $('#ODRelateComGrid').datagrid('getSelected');
	if(selected){
	
		//������Ȩ 
		var iEmpower="N";
		var Empower=$("#Empower").checkbox('getValue');
		if(Empower) iEmpower="Y";
		var LocID=$("#LocList").combobox('getValue');
		var UserID=session['LOGON.USERID'];
	    var rtn=tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","SaveDataToPowerControl",odrtableName,DateID,LocID,UserID,iEmpower)
		var rtnArr=rtn.split("^");
		if(rtnArr[0]=="-1"){
			$.messager.alert("��ʾ","��Ȩʧ��","error");
		}else{
			$.messager.alert("��ʾ","��Ȩ�ɹ�","success");
			 $("#ODRelateComGrid").datagrid('reload');
		}		
	}	
}
    
*/

//��Ȩ����
function BRelateLoc_click()
{
	var DateID=$("#ODRRowId").val()
	if (DateID==""){
		$.messager.alert("��ʾ","��ѡ����Ҫ��Ȩ�ļ�¼","info"); 
		return false;
	}
   var LocID=$("#LocList").combobox('getValue');
   //alert("LocID:"+LocID)
   OpenLocWin(odrtableName,DateID,SessionStr,LocID,InitODRelateComDataGrid);
   
}


//����
function BAdd_click(){
	BSave_click("0");
} 

//�޸�
function BUpdate_click(){
	BSave_click("1");
}

function BSave_click(Type){
	
	if(Type=="1"){
		var ID=$("#ODRRowId").val();
		if(ID==""){
			$.messager.alert("��ʾ","��ѡ����޸ĵļ�¼","info");
			return false;
		}
	}
	
	if(Type=="0"){
		if($("#OrderID").val()==""){
		    	$.messager.alert("��ʾ","����ѡ����Ŀ","info");
		    	return false;
		    }
	    if($("#ODRRowId").val()!=""){
		    	$.messager.alert("��ʾ","�������ݲ���ѡ�м�¼,�����������������","info");
		    	return false;
		    }
		var ID="";
	}
	
	 var iRowId=$("#ODRRowId").val(); 
	 
	var iARCIMDR=$("#ARCIMDR").val();  

   //ϸ������
	var iODDR=$("#ODDRName").combogrid('getValue');
	if (($("#ODDRName").combogrid('getValue')==undefined)||($("#ODDRName").combogrid('getValue')=="")){var iODDR="";}
	if (""==iODDR) {
		$("#ODDRName").focus();
		var valbox = $HUI.combogrid("#ODDRName", {
			required: true,
	    });
		$.messager.alert("��ʾ","��ѡ��ϸ������,ϸ�����Ʋ���Ϊ��","info");
		return false;
	}
	
	 if(iRowId!=""){var iODDR=$("#ODRowId").val();}
	 if(iODDR!="")
	 {
		 var flag=tkMakeServerCall("web.DHCPE.OrderDetailRelate","IsOrderDetailFlag",iODDR);
		 if(flag=="0"){
			 $.messager.alert("��ʾ","������ѡ��ϸ��","info");
			return false;
		 }
	 }

	
	
	//˳���
	var iSequence=$("#Sequence").val(); 
	if (""==iSequence) {
		$("#Sequence").focus();
		var valbox = $HUI.validatebox("#Sequence", {
			required: true,
	    });
		$.messager.alert("��ʾ","˳��Ų���Ϊ��","info");
		return false;
	}
	if((!(isInteger(iSequence)))||(iSequence<=0)) 
		   {
			   $.messager.alert("��ʾ","˳���ֻ����������","info");
			    return false; 
		   }


	//�Ƿ������
	var iRequired="N";
	var Required=$("#Required").checkbox('getValue');
	if(Required) iRequired="Y";
		
	// ����
	var iParentDR=$("#Parent_DR_Name").combogrid('getValue');
	if (($("#Parent_DR_Name").combogrid('getValue')==undefined)||($("#Parent_DR_Name").combogrid('getValue')=="")){var iParentDR="";}
	 
	// ���
	var iCascade=$("#Cascade").val();
	if ("1"==iCascade) { iParentDR=""; }

	if((iCascade!="1")&&(iCascade!="")&&(iParentDR=="")){
		$.messager.alert("��ʾ","��ѡ����","info");
		return false;
		
	}
	
	// �����бȶ�
	/*
	var iHistory="N";
	var HistoryFlag=$("#HistoryFlag").checkbox('getValue');
	if(HistoryFlag) iHistory="Y";
	*/
	
	//����
	var iNoActive="N";
	var NoActive=$("#NoActive").checkbox('getValue');
	if(NoActive) iNoActive="Y";
	
	var OrderID=$("#OrderID").val();
	
	//������Ȩ 
	var iEmpower="N";
	var Empower=$("#Empower").checkbox('getValue');
	if(Empower) iEmpower="Y";
		
	var Instring=$.trim(iRowId)	         //�����ϸ��Ŀ��������ID		
				+"^"+$.trim(iARCIMDR)	 //ҽ����ID	
				+"^"+$.trim(iODDR)	     //ϸ��ID	
				+"^"+$.trim(iSequence)	
				+"^"+$.trim(iRequired)	
				+"^"+$.trim(iParentDR)	
				+"^"+$.trim(iCascade)
				+"^"+iNoActive	
				+"^"+OrderID	          //վ�����Ŀ���ID
				+"^"+iEmpower			
				;
	
	var LocID=$("#LocList").combobox('getValue');
	var UserID=session['LOGON.USERID'];
	
	//alert(Instring)
	 /*****************************�ж���Ŀ�Ƿ��Ѷ���ϸ�� start ****************************************************/
	 var ret=tkMakeServerCall("web.DHCPE.CT.OrderDetailRelate","GetODRelateInfo",iRowId);
	 var Info=ret.split("^");
	 var ODRODDR=Info[1]; //ϸ��ID
	 if(ODRODDR==undefined){var ODRODDR="";}
     if(ODRODDR!=iODDR){
		var IsExsistFlag=tkMakeServerCall("web.DHCPE.CT.OrderDetailRelate","IsExsistODRelate",OrderID,iODDR,LocID);
		if(IsExsistFlag=="1"){
			$.messager.alert('��ʾ', '��Ŀ�Ѷ��ո�ϸ��벻Ҫ�ظ����գ�' ,'info');
			return false;	
		}
	}
	/*****************************�ж���Ŀ�Ƿ��Ѷ���ϸ�� end ****************************************************/
	

	var rtn=tkMakeServerCall("web.DHCPE.CT.OrderDetailRelate","SaveOrderDetailRelate",Instring,odrtableName,UserID,LocID);
	var rtnArr=rtn.split("^");
	if(rtnArr[0]=="-1"){
		$.messager.alert('��ʾ', $g('����ʧ��:')+ rtnArr[1], 'error');	
	}else{
		if(Type=="1"){$.messager.alert("������ʾ","�޸ĳɹ�","success");}
		if(Type=="0"){$.messager.alert("������ʾ","�����ɹ�","success");}
		BClear_click();
	}
	
}

//ɾ��
function BDelete_click(){
	var LocID=$("#LocList").combobox('getValue');
	var UserID=session['LOGON.USERID'];
	var ID=$("#ODRRowId").val();
	
	if(ID==""){
			$.messager.alert("��ʾ","��ѡ���ɾ���ļ�¼","info");
			return false;
		}
			
	$.messager.confirm("ȷ��", "ȷ��Ҫɾ���ü�¼��", function(r){
		if (r){
			
			$.m({ ClassName:"web.DHCPE.CT.OrderDetailRelate", MethodName:"DeleteODRelate",RowID:ID,UserID:UserID,LocID:LocID},function(ReturnValue){
				var rtnArr=ReturnValue.split("^");
				if (rtnArr[0]=='-1') {
					$.messager.alert("��ʾ","ɾ��ʧ��","error");  
				}else{
					$.messager.popover({msg: 'ɾ���ɹ���',type:'success',timeout: 1000});
					BClear_click();
				
				}
			});	
		}
	});
}


//����
function BClear_click(){
	
	var globalLoc = $("#LocList").combobox("getValue");
	var locId = globalLoc != "" ? globalLoc : session["LOGON.CTLOCID"];
	
	$("#ODRRowId,#ODRowId,#Sequence,#Cascade").val("");
	$("#ODDRName").combogrid('setValue',"");
	$("#Parent_DR_Name").combogrid('setValue',"");
	$(".hisui-checkbox").checkbox('setValue',false);
	$("#NoActive").checkbox('setValue',true);
	
	var valbox = $HUI.combogrid("#ODDRName", {
			required: false,
	    });
	var valbox = $HUI.validatebox("#Sequence", {
			required: false,
	    });

	$("#ODRelateComGrid").datagrid('load', {
			ClassName:"web.DHCPE.CT.OrderDetailRelate",
			QueryName:"FindOrderDetailRelate",
			ODROrderDR:$("#OrderID").val(),
			tableName:odrtableName, 
			LocID:locId
		
	});
}

function InitODRelateComDataGrid()
{
	var globalLoc = $("#LocList").combobox("getValue");
	var locId = globalLoc != "" ? globalLoc : session["LOGON.CTLOCID"];

	$HUI.datagrid("#ODRelateComGrid",{
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
			ClassName:"web.DHCPE.CT.OrderDetailRelate",
			QueryName:"FindOrderDetailRelate",
			ODROrderDR:$("#OrderID").val(),
			tableName:odrtableName, 
			LocID:locId
		},
		frozenColumns:[[
			{field:'ODR_OD_DR_Name',width:'150',title:'ϸ������'},
		    {field:'ODR_OD_DR_Code',width:'100',title:'ϸ�����'},
			 
		]],
		columns:[[
		    {field:'ODR_RowId',title:'ODRRowId',hidden: true},
		    {field:'ODR_ARCIM_DR',title:'ARCIMDR',hidden: true},
		    {field:'ODR_OD_DR',title:'ODRowId',hidden: true},
		    {field:'ODR_ARCIM_DR_Name',title:'ARCIMDesc',hidden: true},
			{field:'ODR_Sequence',width:'80',title:'˳���'},
			{field:'ODR_Required',width:'120',title:'�Ƿ������',align:'center',
				formatter: function (value, rec, rowIndex) {
					if(value=="Y"){
						return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
					}else{
						return '<input type="checkbox" value="" disabled/>';
					}
                        
       			}
			},
			//{field:'THistoryFlag',width:'120',title:'�����бȶ�'},
			{field:'ODR_Cascade',width:'80',title:'���'},
			{field:'ODR_Parent_DR_Name',width:'100',title:'����'},
			{field:'TNoActive',width:80,title:'����',align:'center',
				formatter: function (value, rec, rowIndex) {
					if(value=="Y"){
						return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
					}else{
						return '<input type="checkbox" value="" disabled/>';
					}
                        
       			}
			},
			{field:'TEmpower',width:80,title:'������Ȩ',align:'center',
				formatter: function (value, rec, rowIndex) {
					if(value=="Y"){
						return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
					}else{
						return '<input type="checkbox" value="" disabled/>';
					}
                        
       			}
			},{ field:'TEffPowerFlag',width:100,align:'center',title:'��ǰ������Ȩ',
				formatter: function (value, rec, rowIndex) {
					if(value=="Y"){
						return '<input type="checkbox" checked="checked" disabled/>';
					}else{
						return '<input type="checkbox" value="" disabled/>';
					}
				}
			},
			{field:'TUpdateDate',width:120,title:'��������'},	
			{field:'TUpdateTime',width:120,title:'����ʱ��'},	
			{field:'TUserName',width:120,title:'������'}
			
		]],
		onSelect: function (rowIndex, rowData) {
			
			if(rowData.TEmpower=="Y"){
				
				$("#BRelateLoc").linkbutton('enable');
				$("#Empower").checkbox('setValue',true);
				$("#BPower").linkbutton({text:$g('ȡ����Ȩ')});
			}else{
				if(rowData.TNoActive=="Y")	{
					$("#BRelateLoc").linkbutton('disable');
					$("#BPower").linkbutton('enable');
					$("#Empower").checkbox('setValue',false);
					$("#BPower").linkbutton({text:$g('������Ȩ')})
					
				}else{
					$("#BRelateLoc").linkbutton('disable');
					$("#BPower").linkbutton('disable');	
					
				}
			}
			$("#ODRRowId").val(rowData.ODR_RowId);
			$("#ARCIMDR").val(rowData.ODR_ARCIM_DR);
			$("#ODRowId").val(rowData.ODR_OD_DR);
			$("#ODDRName").combogrid('setValue',rowData.ODR_OD_DR_Name);
			$("#Sequence").val(rowData.ODR_Sequence);
			$("#Cascade").val(rowData.ODR_Cascade);
			$("#Parent_DR_Name").combogrid('setValue',rowData.ODR_Parent_DR_Name);
			
			if(rowData.ODR_Required=="Y"){
				$("#Required").checkbox('setValue',true);
			}else{
				$("#Required").checkbox('setValue',false);
			}
			
			if(rowData.TNoActive=="Y"){
				$("#NoActive").checkbox('setValue',true);
			}else{
				$("#NoActive").checkbox('setValue',false);
			}
			if(rowData.ODR_Cascade=="1"){
			$("#Parent_DR_Name").combogrid("disable");
			}else{
			$("#Parent_DR_Name").combogrid("enable");
			}
		
		}
		
			
	})
}


function LoadODRelateComDatalist()
{	
    var LocID=$("#LocList").combobox('getValue');
    
	$("#ODRelateComGrid").datagrid('load', {
			ClassName:"web.DHCPE.CT.OrderDetailRelate",
			QueryName:"FindOrderDetailRelate",
			ODROrderDR:$("#OrderID").val(),
			NoActiveFlag:$("#NoActive").checkbox('getValue') ? "Y" : "N",
			tableName:odrtableName,
			LocID:LocID
			
				
	});	
	
}
/**********************ϸ����� end************************************/



/**********************��Ŀ start************************************/

//��ʼ����ĿGrid 
function InitLocOrderGrid(){
	
	var LocID=session['LOGON.CTLOCID']
	var LocListID=$("#LocList").combobox('getValue');
	if(LocListID!=""){var LocID=LocListID; }
	var hospId = tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","GetHospIDByLocID",LocID);
	
	$('#LocOrderGrid').datagrid({
		url:$URL,
		fit : true,
		border : false,
		striped : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,
		pageSize: 20,
		pageList : [20,100,200], 
		//displayMsg:"",//���ط�ҳ���������"��ʾ��ҳ����ҳ,������������" 
		rownumbers : true,  
		singleSelect: true,
		selectOnCheck: true,
		columns:[[
			{field:'TOrderID',title:'TOrderID',hidden: true},
		 	{field:'TARCIMDR',title:'TARCIMDR',hidden: true},
		 	{field:'TARCIMDesc',width:190,title:'��Ŀ����'},
		 	{field:'TARCIMCode',width:130,title:'����'}	    
		 	
		]],
		queryParams:{
			ClassName:"web.DHCPE.CT.StationOrder",
			QueryName:"FindStationOrder",
			ARCIMDesc:"",
			Type:"B",
			LocID:LocID,
			hospId:hospId,
			tableName:tableName
			
		},
		onSelect: function (rowIndex,rowData) {
	
		$("#OrderID").val(rowData.TOrderID);
		$("#ARCIMDR").val(rowData.TARCIMDR);
		
		$("#ARCIMDesc").val(rowData.TARCIMDesc);
		$('#ODRelateComGrid').datagrid('loadData', {
				total: 0,
				rows: []
			});
		LoadODRelateComDatalist(rowData);
		 
		},
		onLoadSuccess: function (data) {
			
		}
	})
}


//��ѯ(��Ŀ)
function BAFind_click(){
	
var LocID=$("#LocList").combobox('getValue');
var hospId = tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","GetHospIDByLocID",LocID);

$("#LocOrderGrid").datagrid('load', {
	ClassName:"web.DHCPE.CT.StationOrder",
	QueryName:"FindStationOrder",
	StationID:$("#StationID").val(),
	ARCIMDesc:$("#ARCDesc").val(),
	Type:"B",
	LocID:LocID,
	hospId:hospId,
	tableName:tableName
})
}

/**********************��Ŀ  end************************************/


/**********************վ�� start************************************/
// ��ʼ��վ��ά��DataGrid
function InitStationGrid()
{
	var LocID=session['LOGON.CTLOCID']
	var LocListID=$("#LocList").combobox('getValue');
	if(LocListID!=""){var LocID=LocListID; }
	
	$('#StaionGrid').datagrid({
		url:$URL,
		fit : true,
		border : false,
		striped : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,
		pageSize: 20,
		pageList : [20,100,200], 
		displayMsg:"",//���ط�ҳ���������"��ʾ��ҳ����ҳ,������������" 
		rownumbers : true,  
		singleSelect: true,
		selectOnCheck: true,
		columns:[[
		
		    {field:'TStationID',title:'ID',hidden: true},
			{field:'TStationCode',title:'����',width: 70},
			{field:'TStationDesc',title:'����',width: 180},
		]],
		queryParams:{
			ClassName:"web.DHCPE.CT.Station",
			QueryName:"FindStationSet",
			LocID:LocID,
			STActive:"Y"
			
		},
		onSelect: function (rowIndex,rowData) {
			
			$("#StationID").val(rowData.TStationID);
			$("#OrderID,#ARCIMDesc").val('');
			 BAFind_click();
			 BClear_click();
			 iniForm();
			/*$("#ODDesc").val('');
		
		
			$('#OrderDetailTab').datagrid('loadData', {
				total: 0,
				rows: []
			});
			
			BODFind_click();
			$("#ODRowID,#ODSDesc,#ODType").val('');
			BClear_click();
			$('#ODStandardComGrid').datagrid('loadData', {
				total: 0,
				rows: []
			});
			*/
		
		},
		onLoadSuccess: function (data) {		 
			
		}
	});
	
}

//��ѯ��վ�㣩
function BFind_click(){
	
	var LocID=$("#LocList").combobox('getValue');
	
	$("#StaionGrid").datagrid('load',{
		ClassName:"web.DHCPE.CT.Station",
		QueryName:"FindStationSet",
		LocID:LocID,
		Desc:$("#Desc").val(),
		STActive:"Y"
	});	
	
}

/**********************վ�� end************************************/

function InitCombobox()
{
	var LocID=session['LOGON.CTLOCID']
	var LocListID=$("#LocList").combobox('getValue');
	if(LocListID!=""){var LocID=LocListID; }
	//var hospId = tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","GetHospIDByLocID",LocID);
	
	//ϸ������
	var ODObj = $HUI.combogrid("#ODDRName",{
		panelWidth:350,
		url:$URL+"?ClassName=web.DHCPE.CT.StatOrderDetail&QueryName=FindOrderDetail",
		mode:'remote',
		delay:200,
		idField:'TODID',
		textField:'TODDesc',
		onBeforeLoad:function(param){
			param.StationID = $("#StationID").val();
			param.Desc = param.q;
			param.LocID=LocID;
			param.tableName="DHC_PE_OrderDetail";
		},
		onShowPanel:function()
		{
			$('#ODDRName').combogrid('grid').datagrid('reload');
		},
		columns:[[
		    {field:'TODID',title:'ID',hidden: true},
		    {field:'TODDesc',title:'����',width:150},
		    {field:'TODCode',title:'����',width:100},  	    	
					
		]],
		onLoadSuccess:function(){
			
			
		},

		});
		
	//����
	var OrdObj = $HUI.combogrid("#Parent_DR_Name",{
		panelWidth:249,
		url:$URL+"?ClassName=web.DHCPE.OrderDetailRelate&QueryName=SearchParentOrderDetailRelate",
		mode:'remote',
		delay:200,
		idField:'ID',
		textField:'Desc',
		onBeforeLoad:function(param){
			param.ARCIMDR = $("#ARCIMDR").val();
			param.Desc = param.q;
		},
		onShowPanel:function()
		{
			$('#Parent_DR_Name').combogrid('grid').datagrid('reload');
		},
		columns:[[
		    {field:'ID',title:'ID',width:80},
		    {field:'Desc',title:'����',width:140}, 
		
					
		]]
		});
	
}



 function isInteger(num) {
      if (!isNaN(num) && num % 1 === 0) {
        return true;
      } else {
        return false;
      }
}
