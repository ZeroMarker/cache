/*
 * FileName: dhcpe/ct/excludearcitem.js
 * Author: xy
 * Date: 2021-08-16
 * Description: �ų���Ŀά��
 */
 
var lastIndex = "";
 
var EditIndex = -1;

var tableName ="DHC_PE_StationOrder";  //վ�����Ŀ��ϱ�

var extableName ="DHC_PE_ExcludeArcItem";//�ų���Ŀ��

var SessionStr =session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']

$(function(){
	
//��ȡ���������б�
GetLocComp(SessionStr)

//���������б�change
$("#LocList").combobox({
  onSelect:function(){
	  
	  BFind_click();
	  
	  BAFind_click();
	  
	  $("#ARCIMRowID").val('');
	  
	  var LocID=session['LOGON.CTLOCID']
	  var LocListID=$("#LocList").combobox('getValue');
	  if(LocListID!=""){var LocID=LocListID; }
	 
	  $("#ExcludeArcItemGrid").datagrid('load', {
			ClassName:"web.DHCPE.CT.ExcludeArcItem",
			QueryName:"FindExcludeArcItem",
			ARCIMID:$("#ARCIMRowID").val(),
			LocID:LocID,
			tableName:extableName
		
	});
	       	    		 
  }
})

		
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

//��ʼ���ų���ĿGrid				
InitExcludeArcItemGrid();

//����
$("#BAdd").click(function(e){
   BAdd_click();
 });
		
//�޸�
$("#BUpdate").click(function(e){
    BUpdate_click();
});
 
//����
$("#BSave").click(function(e){
   BSave_click();
 });
	   
//ɾ��
$("#BDelete").click(function(e){
    BDelete_click();
 });
      
//��Ȩ����
$("#BRelateLoc").click(function(){
   BRelateLoc_click();
 })
	
})

/************************�ų���Ŀ start****************/

//���ݹ�������
function BRelateLoc_click()
{
	var DateID=$("#ID").val()
	if (DateID==""){
		$.messager.alert("��ʾ","��ѡ����Ҫ��Ȩ�ļ�¼","info"); 
		return false;
	}
   
   var LocID=$("#LocList").combobox('getValue')
   //alert("LocID:"+LocID)
    OpenLocWin(extableName,DateID,SessionStr,LocID,LoadExcludeArcItemGrid)
   
   $("#ExcludeArcItemGrid").datagrid('reload');
   $("#BRelateLoc").linkbutton('disable');
   
}

//ɾ��
function BDelete_click()
{
	var UserID=session['LOGON.USERID'];

	var RowId=$("#ID").val();
	
	if (RowId=="")
	{
		$.messager.alert("��ʾ","����ѡ���ɾ���ļ�¼","info");	
		return false;
	}
	$.messager.confirm("ȷ��", "ȷ��Ҫɾ���ü�¼��", function(r){
		if (r){
			
			$.m({ ClassName:"web.DHCPE.CT.ExcludeArcItem", MethodName:"DeleteExcludeArcItem",ID:RowId,UserID:UserID},function(ReturnValue){
				if (ReturnValue.split("^")[0]=='-1') {
					$.messager.alert("��ʾ","ɾ��ʧ��","error");  
				}else{
					$.messager.popover({msg: 'ɾ���ɹ���',type:'success',timeout: 1000});
					$("#ExcludeArcItemGrid").datagrid('reload');
				}
			});	
		}
	});
	
		
}

//����
function BAdd_click()
 {
	var ARCIMRowID=$("#ARCIMRowID").val();
	if(ARCIMRowID==""){
		$.messager.alert('��ʾ', "����ѡ���ά������Ŀ", 'info');
		return;	
	}
	lastIndex = $('#ExcludeArcItemGrid').datagrid('getRows').length - 1;
	$('#ExcludeArcItemGrid').datagrid('selectRow', lastIndex);
	var selected = $('#ExcludeArcItemGrid').datagrid('getSelected');
	
	if (selected) {
		if (selected.TID == "") {
			$.messager.alert('��ʾ', "����ͬʱ��Ӷ���!", 'info');
			return;
		}
	}
	if ((EditIndex >= 0)) {
		$.messager.alert('��ʾ', "һ��ֻ���޸�һ����¼", 'info');
		return;
	}
	$('#ExcludeArcItemGrid').datagrid('appendRow', {
		TID: '',
		TExArcItemDesc:'',
		TUpdateDate:'',
		TUpdateTime:'',
		TUpdateUser:'',
		TEmpower:'',
		TEffPowerFlag:''
	});
	lastIndex = $('#ExcludeArcItemGrid').datagrid('getRows').length - 1;
	$('#ExcludeArcItemGrid').datagrid('selectRow', lastIndex);
	$('#ExcludeArcItemGrid').datagrid('beginEdit', lastIndex);
	EditIndex = lastIndex;
	
 }
 
 //�޸�
 function BUpdate_click()
 {
	var selected = $('#ExcludeArcItemGrid').datagrid('getSelected');
	if (selected==null){
			$.messager.alert('��ʾ', "��ѡ����޸ĵļ�¼", 'info');
			return;
	}
	if (selected) {
		var thisIndex = $('#ExcludeArcItemGrid').datagrid('getRowIndex', selected);
		if ((EditIndex != -1) && (EditIndex != thisIndex)) {
			$.messager.alert('��ʾ', "һ��ֻ���޸�һ����¼", 'info');
			return;
		}
		$('#ExcludeArcItemGrid').datagrid('beginEdit', thisIndex);
		$('#ExcludeArcItemGrid').datagrid('selectRow', thisIndex);
		EditIndex = thisIndex;
		var selected = $('#ExcludeArcItemGrid').datagrid('getSelected'); 
		 
		var thisEd = $('#ExcludeArcItemGrid').datagrid('getEditor', {
				index: EditIndex,
				field: 'TExArcItemDesc'  
			});
		
		$(thisEd.target).combobox('select', selected.TExArcItemDR);
		
	}
 }

//����
function BSave_click()
{
	var LocID=$("#LocList").combobox('getValue');
	var UserID=session['LOGON.USERID'];
	var ARCIMID=$("#ARCIMRowID").val();
	
	$('#ExcludeArcItemGrid').datagrid('acceptChanges');
	var selected = $('#ExcludeArcItemGrid').datagrid('getSelected');
	if (selected) {
		if (selected.TID == "") {
			if ((selected.TExArcItemDesc == "undefined") || (selected.TExArcItemDesc == "")) {
				$.messager.alert('��ʾ', "����Ϊ��,���������", 'info');
				$("#ExcludeArcItemGrid").datagrid('reload');
				return;
			}
			var ID=selected.TID;
			var ExArcItemID=selected.TExArcItemDesc;
			var Empower=selected.TEmpower;
			var InfoStr=ID+"^"+ARCIMID+"^"+ExArcItemID+"^"+Empower+"^"+LocID+"^"+UserID;
			
			if(ARCIMID==ExArcItemID){
				$.messager.alert("��ʾ","�ų����Ŀ��ά����Ŀ��������ͬ","info");
				$("#ExcludeArcItemGrid").datagrid('reload');
				return false;
			}

			var flag=tkMakeServerCall("web.DHCPE.CT.ExcludeArcItem","IsExcludeArcItem",ARCIMID,ExArcItemID,LocID);
			if(flag=="1"){
				$.messager.alert("��ʾ","�Ѵ��ڸ��ų���Ŀ","info");
				$("#ExcludeArcItemGrid").datagrid('reload');
				return false;
		
			}

			//alert(InfoStr)
			$.m({
				ClassName: "web.DHCPE.CT.ExcludeArcItem",
				MethodName: "SaveExcludeArcItem",
				InfoStr:InfoStr,
				tableName:extableName
			     
			}, function (rtn) {
				var rtnArr=rtn.split("^");
				if(rtnArr[0]=="-1"){
					
					$.messager.alert('��ʾ', $g('����ʧ��:')+ rtnArr[1], 'error');
					
				}else{
					$.messager.popover({msg: '����ɹ�',type:'success',timeout: 1000});
				}	
				$("#ExcludeArcItemGrid").datagrid('reload');
			});
		} else {
			$('#ExcludeArcItemGrid').datagrid('selectRow', EditIndex);
			var selected = $('#ExcludeArcItemGrid').datagrid('getSelected');
			if ((selected.TExArcItemDesc == "undefined") || (selected.TExArcItemDesc == "")) {
				$.messager.alert('��ʾ', "����Ϊ��,�������޸�", 'info');
				$("#ExcludeArcItemGrid").datagrid('reload');
				return;
			}
			var ID=selected.TID;
			var ExArcItemID=selected.TExArcItemDesc;
			if((ExArcItemID != "") && (ExArcItemID.split("||").length < 2)) {
				$.messager.alert("��ʾ","��ѡ���ų���Ŀ","info");
				return false;
			}
			if (ExArcItemID != "") {
				var ret = tkMakeServerCall("web.DHCPE.DHCPECommon","IsArcItem",ExArcItemID);
				if (ret == "0") {
					$.messager.alert("��ʾ","��ѡ���ų���Ŀ","info");
					return false;
				}
			}
			if(ARCIMID==ExArcItemID){
				$.messager.alert("��ʾ","�ų����Ŀ��ά����Ŀ��������ͬ","info");
				$("#ExcludeArcItemGrid").datagrid('reload');
				return false;
			}
           	
            if(selected.TExArcItemDR!=ExArcItemID){
				var flag=tkMakeServerCall("web.DHCPE.CT.ExcludeArcItem","IsExcludeArcItem",ARCIMID,ExArcItemID,LocID);
				if(flag=="1"){
					$.messager.alert("��ʾ","�Ѵ��ڸ��ų���Ŀ","info");
					$("#ExcludeArcItemGrid").datagrid('reload');
					return false;
		
				}
            }
			

			var Empower=selected.TEmpower;
			var InfoStr=ID+"^"+ARCIMID+"^"+ExArcItemID+"^"+Empower+"^"+LocID+"^"+UserID;
			//alert(InfoStr)

			$.m({
				ClassName: "web.DHCPE.CT.ExcludeArcItem",
				MethodName: "SaveExcludeArcItem",
				InfoStr:InfoStr,
				tableName:extableName
				
			}, function (rtn) {
				var rtnArr=rtn.split("^");
				if(rtnArr[0]=="-1"){	
					$.messager.alert('��ʾ', $g('�޸�ʧ��:')+ rtnArr[1], 'error');
					
				}else{	
					$.messager.popover({msg: '�޸ĳɹ�',type:'success',timeout: 1000});
					
				}
			
				$("#ExcludeArcItemGrid").datagrid('reload');
			});
		}
	}
}

function LoadExcludeArcItemGrid(rowData)
{
	if(rowData!=undefined){
		$("#ARCIMRowID").val(rowData.TARCIMDR);	
	}
	var LocID=session['LOGON.CTLOCID']
	var LocListID=$("#LocList").combobox('getValue');
	if(LocListID!=""){var LocID=LocListID; }

	$("#ExcludeArcItemGrid").datagrid('load', {
			ClassName:"web.DHCPE.CT.ExcludeArcItem",
			QueryName:"FindExcludeArcItem",
			ARCIMID:$("#ARCIMRowID").val(),
			LocID:LocID,
			tableName:extableName
		
	});
	
}
//��ʼ���ų���ĿGrid
function InitExcludeArcItemGrid()
{	
	var LocID=session['LOGON.CTLOCID']
	var LocListID=$("#LocList").combobox('getValue');
	if(LocListID!=""){var LocID=LocListID; }
	var hospId = tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","GetHospIDByLocID",LocID); 
				
	$('#ExcludeArcItemGrid').datagrid({
		url:$URL,
		fit : true,
		border : false,
		striped : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		singleSelect: true,
		selectOnCheck: true,
		columns:[[
		{
				field: 'TID',
				title: 'ID',
				hidden: true
			}, {
				field: 'TArcItemDR',
				title: 'ArcItemDR',  
				hidden: true
			},{
				field: 'TExArcItemDR',
				title: 'ExArcItemDR',
				hidden: true
			}, {
				field: 'TExArcItemDesc',
				title: '�ų���Ŀ',
				width: 230,
			    formatter:function(value,row){
                    return row.TExArcItemDesc;
                },
				 editor:{
                    type:'combobox',
                    options:{
	                    required: true,
                        valueField:'TARCIMDR',
                        textField:'TARCIMDesc',
                        method:'get',
                        url:$URL+"?ClassName=web.DHCPE.CT.StationOrder&QueryName=FindLocAllOrder&ResultSetType=array",
                        onBeforeLoad:function(param){   
			                param.ARCIMDesc = param.q;
							param.Type="B";
							param.LocID=LocID;
							param.hospId = hospId;
							param.tableName=tableName
                            
                           }
                        
                    }
                }
			},{
				field: 'TEmpower',
				width: 80,
				title: '������Ȩ',
				align:'center',
				editor: {
					type: 'checkbox',
					options: {
							on:'Y',
						off:'N'
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
			}, {
				field: 'TUpdateDate',
				width: '120',
				title: '��������'
			}, {
				field: 'TUpdateTime',
				width: '120',
				title: '����ʱ��'
			}, {
				field: 'TUpdateUser',
				width: '120',
				title: '������'
			}
		]],
		queryParams:{
			ClassName:"web.DHCPE.CT.ExcludeArcItem",
			QueryName:"FindExcludeArcItem",
			ARCIMID:"",
			LocID:LocID,
			tableName:extableName

		},
		onSelect: function (rowIndex, rowData) {
			if(rowData!=undefined){
				$("#ID").val(rowData.TID);
				if(rowData.TEmpower=="Y"){		
					$("#BRelateLoc").linkbutton('enable');
				}else{
					$("#BRelateLoc").linkbutton('disable');
				}
			}
				
		},
		onLoadSuccess: function (data) {
			EditIndex = -1;
		}
	});
	
}


/**********************�ų���Ŀ end************************************/

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
		displayMsg:"",//���ط�ҳ���������"��ʾ��ҳ����ҳ,������������" 
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

		   $('#ExcludeArcItemGrid').datagrid('loadData', {
				total: 0,
				rows: []
			});
			LoadExcludeArcItemGrid(rowData);
		 
		},
		onLoadSuccess: function (data) {
			
		}
	})
}


//��ѯ(��Ŀ)
function BAFind_click(){

	var LocID=session['LOGON.CTLOCID']
	var LocListID=$("#LocList").combobox('getValue');
	if(LocListID!=""){var LocID=LocListID; }
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
			LocID:session['LOGON.CTLOCID'],
			STActive:"Y"
			
		},
		onSelect: function (rowIndex,rowData) {
			
			$("#StationID").val(rowData.TStationID);
			BAFind_click();
			$('#ExcludeArcItemGrid').datagrid('loadData', {
				total: 0,
				rows: []
			});

		},
		onLoadSuccess: function (data) {		 
			
		}
	});
	
}

//��ѯ��վ�㣩
function BFind_click(){
	$("#StaionGrid").datagrid('load',{
		ClassName:"web.DHCPE.CT.Station",
		QueryName:"FindStationSet",
		LocID:$("#LocList").combobox('getValue'),
		Desc:$("#Desc").val(),
		STActive:"Y"
	});	
	
}

/**********************վ�� end************************************/
