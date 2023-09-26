/**
 * ģ��:		ҩ��
 * ��ģ��:		ҩƷ��Ϣά��(�ּ�)
 * createdate:	2017-06-20
 * creator:		yunhaibao
 */
var mtUrl = "dhcst.easyui.drugmaintain.action.csp";
var gLocId=session['LOGON.CTLOCID'];
var gUserId=session['LOGON.USERID'];
var gGroupId=session['LOGON.GROUPID']; 
$(function(){
	InitSearchBox();
	InitPHCCatTreeGrid();
	InitPHCChemicalGrid();
	InitPHCGenericGrid();
	InitARCItmGrid();
	InitINCItmGrid();
	DHCSTEASYUI.Authorize();
	document.onkeypress = DHCSTEASYUI.BanBackspace;
	document.onkeydown = DHCSTEASYUI.BanBackspace;
});

/// ��ʼ��ҩѧ������
function InitPHCCatTreeGrid(){
	var treeColumns=[[  
		{field:'phcCatDesc',title:'ҩѧ����',width:250}, 
		{field:'phcCatLevel',title:'����',width:20,align:'center',hidden:false},
		{field:'phcCatCode',title:'����',width:80,hidden:true},
		{field:'phcCatRowId',title:'phcCatRowId',hidden:true},
		{field:'_parentId',title:'parentId',hidden:true}
	]];
	$('#phcCatTreeGrid').treegrid({  
		toolbar:'#barPhcCat',
		animate:true,
		border:false,
		fit:true,
		nowrap:true,
		fitColumns:true,
		singleSelect:true,
		idField:'phcCatRowId', 
		treeField:'phcCatDesc',
		striped: true, 
		//pagination:true,
		rownumbers:false,//�к� 
		//pageSize:150,
		//pageList:[150,300],
		columns:treeColumns,
		url:mtUrl,
		queryParams: {
			action:'QueryPhcCatTree'
		},
		onDblClickRow:function(rowData){
			var selTabObj=$("#detail-tabs").tabs("getSelected");
			var selTabTitle=selTabObj.panel('options').title;
			// ˫��ҩѧ�����������������ѡ��
			$('#searArcItm,#searChemical,#searGeneric,#searIncItm').searchbox('clear');
			switch (selTabTitle){
				case "��ѧͨ����":
					QueryPHCChemicalGrid(1);
					break;
				case "����ͨ����":
					QueryPHCGenericGrid(1);
					break;
				case "ҽ����":
					QueryARCItmGrid(1);
					break;
				case "�����":
					QueryINCItmGrid(1);
					break;
				default:
					break;
				
			}
			
		},         
		onBeforeExpand:function(row){  
 
        },
        onExpand : function(row){ 
        },
        onLoadSuccess : function(row, data	){
	       //$(this).treegrid('collapseAll')
	    },
		onContextMenu: function(e, row) { //�Ҽ�ʱ�����¼�
	  		if ($("#easyui-rightmenu").html()==undefined){
		  		return;
		  	}
		  	var _treegrid_id=$(this).attr("id");
	        e.preventDefault(); //��ֹ����������Ҽ��¼�
	        $("#easyui-rightmenu #menu-export").unbind().bind("click",function(){
		    	ExportPhcCatToExcel(_treegrid_id);  
		    })
	        $('#easyui-rightmenu').menu('show', {
	            left: e.pageX,
	            top: e.pageY
	        });
	      }
	  });
}
function ReloadPhcCatTreeById(phcCatId){
	if ((phcCatId!=undefined)&&(phcCatId!="")){
		var parentObj=$('#phcCatTreeGrid').treegrid('getParent',phcCatId);
		if (parentObj==null){
			$('#phcCatTreeGrid').treegrid('reload');
		}else{
			needLoadId=parentObj.phcCatRowId;
			if (needLoadId){
				$('#phcCatTreeGrid').treegrid('reload',needLoadId);
			}	
		}
		return;
	}
	var selectNode = $("#phcCatTreeGrid").treegrid('getSelected');
	if(selectNode==null){
		$('#phcCatTreeGrid').treegrid('reload');
		return;
	}
	var selectId=selectNode.phcCatRowId;
	var needLoadId=selectId;
	var childLen=$('#phcCatTreeGrid').treegrid('getChildren',selectId).length;
	if (childLen==0){
		needLoadId=$('#phcCatTreeGrid').treegrid('getParent',selectId).phcCatRowId;
	}
	$('#phcCatTreeGrid').treegrid('reload',needLoadId);
}

/// ��ʼ����ѧͨ�����б�
function InitPHCChemicalGrid(){
	var gridColumns=[[  
		{field:'chemicalDesc',title:'��ѧͨ������',width:300,sortable:true,
            styler: function(value, row, index) {
	            if (row.phcCatId==""){
		        	return 'color:#0085FF;font-weight:bold;';
		        }
            }
        }, 
		{field:'chemicalCode',title:'��ѧͨ�ô���',width:150,sortable:true},
		{field:'phcCatDesc',title:'ҩѧ����',width:250,sortable:true},
		{field:'phcCatId',title:'ҩѧ����ID',width:80,hidden:true},
		{field:'chemicalId',title:'chemicalId',hidden:true}
	]];
	var options={
		ClassName:'web.DHCST.PHCChemical',
		QueryName:'Query',
		queryParams:{
			StrParams:'needNull' 
		},
	    toolbar:'#barChemical',
        columns:gridColumns,
        onDblClickRow:function(rowIndex,rowData){
	        $('#searGeneric').searchbox('clear');
			QueryPHCGenericGrid();
			$("#detail-tabs").tabs("select","����ͨ����");
			$("#span-chemicalDesc").text(rowData.chemicalDesc);
			$("#span-chemicalId").text(rowData.chemicalId);
		},
		onClickRow:function(rowIndex,rowData){
			/*
			if (rowData){
				$("#span-chemicalDesc").text(rowData.chemicalDesc);
				$("#span-chemicalId").text(rowData.chemicalId);
			}*/
		},
		onLoadSuccess:function(data){
			$("#span-chemicalDesc").text("ȫ��");
			$("#span-chemicalId").text("");
		} 
	}
	$('#phcChemicalGrid').dhcstgrideu(options);
}

/// ��ʼ������ͨ�����б�
function InitPHCGenericGrid(){
	var gridColumns=[[  
		{field:'genericDesc',title:'����ͨ������',width:300,sortable:true,
            styler: function(value, row, index) {
	            if (row.chemicalId==""){
		        	return 'color:#0085FF;font-weight:bold;';
		        }
            }
        },
		{field:'genericCode',title:'����ͨ�ô���',width:150,sortable:true},
		{field:'genericStDate',title:'��ʼ����',width:150,hidden:true},
		{field:'genericEdDate',title:'��������',width:150,hidden:true},
		{field:'genericId',title:'genericId',width:80,hidden:true},
		{field:'chemicalId',title:'chemicalId',width:150,hidden:true},
		{field:'chemicalDesc',title:'��ѧͨ����',width:150,hidden:false,sortable:true},
		{field:'formDesc',title:'����',width:150,hidden:false,sortable:true}
	]];
	var options={
		ClassName:'web.DHCST.PHCGeneric',
		QueryName:'Query',
		queryParams:{
			StrParams:'needNull' 
		},
	    toolbar:'#barGeneric',
        columns:gridColumns,
		onDblClickRow:function(rowIndex,rowData){
			$('#searArcItm').searchbox('clear');
		    QueryARCItmGrid();
		    $("#detail-tabs").tabs("select","ҽ����");
			$("#span-genericDesc").text(rowData.genericDesc);
			$("#span-genericId").text(rowData.genericId);
		},
		onClickRow:function(rowIndex,rowData){
			/*
			if (rowData){
				$("#span-genericDesc").text(rowData.genericDesc);
				$("#span-genericId").text(rowData.genericId);
			}*/
		},
		onLoadSuccess:function(data){
			$("#span-genericDesc").text("ȫ��");
			$("#span-genericId").text("");
		}   
	}
	$('#phcGenericGrid').dhcstgrideu(options);
}

function renderAsIcon(value,row,index){
	if (value=="Y"){
		return '<img src="../scripts/dhcpha/img/ok.png" border=0/>';
	}else{
    	return '';
    }
}
/// ��ʼ��ҽ�����б�
function InitARCItmGrid(){
	var gridColumns=[[  
		{field:'arcItmRowId',title:'ҽ����ID',width:100,hidden:true}, 
		{field:'arcItmDesc',title:'ҽ��������',width:300,sortable:true,
            styler: function(value, row, index) {
	            if (row.genericId==""){
		        	return 'color:#0085FF;font-weight:bold;';
		        }
            }
        },
		{field:'arcItmCode',title:'ҽ�������',width:150,sortable:true},
		{field:'billUom',title:'�Ƽ۵�λ',width:80,sortable:true,hidden:true},
		{field:'ordCategory',title:'ҽ������',width:100,sortable:true},
		{field:'arcItmCat',title:'ҽ������',width:150,sortable:true},
		{field:'phcForm',title:'����',width:100,sortable:true},
		{field:'phcInstu',title:'�÷�',width:100,sortable:true},
		{field:'phcDura',title:'�Ƴ�',width:100,sortable:true},
		{field:'phcFreq',title:'Ƶ��',width:100,sortable:true},
		{field:'phcManf',title:'����',width:200,sortable:true},
		{field:'phcPoison',title:'���Ʒ���',width:150,sortable:true},
		{field:'phcBasicDrug',title:'����ҩ��',width:65,align:'center',formatter:renderAsIcon,sortable:true},
		{field:'genericDesc',title:'����ͨ����',width:150,sortable:true},
		{field:'genericId',title:'����ͨ����ID',width:150,hidden:true},
		{field:'arcItmStopDate',title:'��ֹ����',align:'center',width:85,sortable:true},
	]];
	var options={
		ClassName:'web.DHCST.ARCITMMAST',
		QueryName:'QueryArcItmMast',
	    toolbar:'#barArcItm',
		queryParams:{
			StrParams:'needNull' 
		},
        columns:gridColumns,
		onDblClickRow:function(rowIndex,rowData){
			$('#searIncItm').searchbox('clear');
		    QueryINCItmGrid();
		    $("#detail-tabs").tabs("select","�����");
			$("#span-arcDesc").text(rowData.arcItmDesc);
			$("#span-arcId").text(rowData.arcItmRowId);
		},
		onClickRow:function(rowIndex,rowData){
			/*
			if (rowData){
				$("#span-arcDesc").text(rowData.arcItmDesc);
				$("#span-arcId").text(rowData.arcItmRowId);
			}*/
		},
		onLoadSuccess:function(data){
			$("#span-arcDesc").text("ȫ��");
			$("#span-arcId").text("");
		}    
	}
	$('#arcItmGrid').dhcstgrideu(options);

}

/// ��ʼ��������б�
function InitINCItmGrid(){
	var gridColumns=[[  
		{field:'incRowId',title:'ID',width:80,hidden:true},
		{field:'arcItmDesc',title:'ҽ��������',width:200,hidden:false,sortable:true,
			formatter: function(value,row,index){
        		return '<a style="text-decoration: underline" onclick=\'EditArcFromInc("'+row.arcItmRowId+'")\'>'+value+'</a>';
     		}
		},
		{field:'incDesc',title:'���������',width:200,sortable:true,
            styler: function(value, row, index) {
	            if (row.arcItmRowId==""){
		        	return 'color:#0085FF;font-weight:bold;';
		        }
            }
        }, 
		{field:'incCode',title:'��������',width:150,sortable:true},
		{field:'incSpec',title:'���',width:100,sortable:true},
		{field:'incBUom',title:'������λ',width:100,sortable:true},
		{field:'incRp',title:'����',align:'right',width:100,sortable:true},
		{field:'incSp',title:'�ۼ�',align:'right',width:100,sortable:true},
		{field:'incRemark',title:'��׼�ĺ�',width:100,sortable:true},
		{field:'incStkCat',title:'������',width:150,hidden:false,sortable:true},
		{field:'incNotUse',title:'������',align:'center',width:50,formatter:renderAsIcon,sortable:true},
		{field:'arcItmRowId',title:'ҽ����ID',hidden:true},
		{field:'genericDesc',title:'����ͨ����',width:150,sortable:true},
		{field:'chemicalDesc',title:'��ѧͨ����',width:150,sortable:true}
	]];
	var options={
		ClassName:'web.DHCST.INCITM',
		QueryName:'QueryIncItm',
		queryParams:{
			StrParams:'needNull' 
		},
	    toolbar:'#barIncItm',
        columns:gridColumns,
		onDblClickRow:function(rowIndex,rowData){
		    //QueryINCItmGrid();
		}  
	}
	$('#incItmGrid').dhcstgrideu(options);
}

/// ��ʼ������searchBox
function InitSearchBox(){
	var searchSelHtml=
	'<div data-options='+"name:'alias',iconCls:''"+'>'+'����'+'</div>'+
	'<div name="code" data-options='+"name:'code',iconCls:''"+'>'+'����'+'</div>'+
	'<div name="desc" data-options='+"name:'desc',iconCls:''"+'>'+'����'+'</div>';
	$(".dhcphaSearchBox").append(searchSelHtml);
	$('#searPhcCat').searchbox({
	    searcher:function(value,name){
		    QueryPHCCatTreeGrid();
	    },
	    menu:'#mPhcCat',
	    width:'340',
	    prompt:'ҩѧ����...'
	});
	$('#searChemical').searchbox({
	    searcher:function(value,name){
			QueryPHCChemicalGrid(2);
	    },
	    menu:"#mChemical",
	    width:'340',
	    prompt:'��ѧͨ����...'
	});
	//$('#searChemical').searchbox('selectName','desc');
	$('#searGeneric').searchbox({
	    searcher:function(value,name){
			QueryPHCGenericGrid(2);
	    },
	    menu:'#mGeneric',
	    width:'340',
	    prompt:'����ͨ����...'
	});
	$('#searArcItm').searchbox({
	    searcher:function(value,name){
			QueryARCItmGrid(2);
	    },
	    menu:'#mArcItm',
	    width:'340',
	    prompt:'ҽ����...'
	});
	$('#searIncItm').searchbox({
	    searcher:function(value,name){
			QueryINCItmGrid(2);
	    },
	    menu:'#mIncItm',
	    width:'340',
	    prompt:'�����...'
	});
	$('#searTarItm').searchbox({
	    searcher:function(value,name){
			QueryTARItmGrid();
	    },
	    menu:'#mTarItm',
	    width:'340',
	    prompt:'�շ���...'
	});
}
/// ��ѯҩѧ������
function QueryPHCCatTreeGrid(){
	var params=GetSearchBoxParams("searPhcCat");
	$('#phcCatTreeGrid').treegrid('load',  {  
			action: 'QueryPhcCatTree',
			strParams: params					
	});
}
/// ��ѯ��ѧͨ�����б�
function QueryPHCChemicalGrid(queryType){
	if(queryType==undefined){
		queryType="";
	}
	var params=GetSearchBoxParams("searChemical");
	var selected=$('#phcCatTreeGrid').treegrid('getSelected');
	var phcCatId="";
	if (selected){
		phcCatId=selected.phcCatRowId;
	}
	if (queryType=="2"){
		phcCatId="";
	}
	params=phcCatId+"^"+params;
	$('#phcChemicalGrid').datagrid({
     	queryParams:{
			StrParams:params 
		}
	});
}

/// ��ѯ����ͨ�����б�
function QueryPHCGenericGrid(queryType){
	if(queryType==undefined){
		queryType="";
	}
	if (queryType!=""){
		$('#phcChemicalGrid').datagrid('clearSelections');
	}
	var params=GetSearchBoxParams("searGeneric");
	var selected=$('#phcChemicalGrid').datagrid('getSelected');
	var chemicalId="";
	if (selected){
		chemicalId=selected.chemicalId;
	}
	var selectedPhcCat=$('#phcCatTreeGrid').treegrid('getSelected');
	var phcCatId="";
	if (selectedPhcCat){
		phcCatId=selectedPhcCat.phcCatRowId;
	}
	if (queryType=="1"){
		chemicalId="";
		$("#span-chemicalDesc").text("ȫ��");
		$("#span-chemicalId").text("");
	}
	if (queryType=="2"){
		chemicalId="";
		phcCatId="";
		$("#span-chemicalDesc").text("ȫ��");
		$("#span-chemicalId").text("");
	}
	if (chemicalId!=""){
		phcCatId="";
	}
	params=chemicalId+"^"+params+"^"+phcCatId;
	$('#phcGenericGrid').datagrid({
     	queryParams:{
			StrParams:params 
		}
	});
}

/// ��ѯҽ�����б� 
function QueryARCItmGrid(queryType){
	if(queryType==undefined){
		queryType="";
	}
	if (queryType=="1"){
		$('#phcGenericGrid').datagrid('clearSelections');
	}
	var params=GetSearchBoxParams("searArcItm");
	var selected=$('#phcGenericGrid').datagrid('getSelected');
	var genericId="";
	if (selected){
		genericId=selected.genericId;
	}
	var selectedPhcCat=$('#phcCatTreeGrid').treegrid('getSelected');
	var phcCatId="";
	if (selectedPhcCat){
		phcCatId=selectedPhcCat.phcCatRowId;
	}
	if (queryType=="1"){
		genericId="";
		$("#span-genericDesc").text("ȫ��");
		$("#span-genericId").text("");
	}
	if (queryType=="2"){
		genericId="";
		phcCatId="";
		$("#span-genericDesc").text("ȫ��");
		$("#span-genericId").text("");
	}
	if (genericId!=""){
		phcCatId="";
	}
	params=genericId+"^"+params+"^"+phcCatId;
	$('#arcItmGrid').datagrid({
     	queryParams:{
			StrParams:params 
		}
	});
}

/// ��ѯ������б� 
function QueryINCItmGrid(queryType){
	if(queryType==undefined){
		queryType="";
	}
	if (queryType=="1"){
		$('#arcItmGrid').datagrid('clearSelections');
	}
	var params=GetSearchBoxParams("searIncItm");
	var selected=$('#arcItmGrid').datagrid('getSelected');
	var arcItmId="";
	if (selected){
		arcItmId=selected.arcItmRowId;
	}
	var selectedPhcCat=$('#phcCatTreeGrid').treegrid('getSelected');
	var phcCatId="";
	if (selectedPhcCat){
		phcCatId=selectedPhcCat.phcCatRowId;
	}
	if (queryType=="1"){
		arcItmId="";
		$("#span-arcDesc").text("ȫ��");
		$("#span-arcId").text("");

	}
	if (queryType=="2"){
		phcCatId="";
		arcItmId="";
		$("#span-arcDesc").text("ȫ��");
		$("#span-arcId").text("");
	}
	if (arcItmId!=""){
		phcCatId="";
	}
	params=arcItmId+"^"+params+"^"+phcCatId;
	$('#incItmGrid').datagrid({
     	queryParams:{
			StrParams:params 
		}
	});
}

/// ��ѯ�շ����б� 
function QueryTARItmGrid(){
}
/// ��֤�Ƿ�Ϊfunction
function CheckIfFunction(funName){
	try{
		if (typeof(eval(funName)=="function")){
			return true;
		}
		return false;
	}catch(e){
		return false;
	}
}
/// ��ȡsearchboxƴ����ķ���ֵ
function GetSearchBoxParams(searId){
	var name=$('#'+searId).searchbox("getName")
	var value=$('#'+searId).searchbox("getValue")
	var code="",desc="",alias="";
	if (name=="code"){
		code=value;
	}
	if (name=="desc"){
		desc=value;
	}
	if (name=="alias"){
		alias=value;
	}
	return code+"^"+desc+"^"+alias;
}

/// ����ҩѧ����
function ExportPhcCatToExcel(treeGridId){
	try{
		var xlApp=new ActiveXObject("Excel.Application");
	}
	catch (e){
		$.messager.alert("��ʾ","���밲װexcel��ͬʱ���������ִ��ActiveX�ؼ�","warning");
		return "";
	}
	xlApp.Visible=false;
	xlApp.DisplayAlerts = false;
	var xlBook=xlApp.Workbooks.Add();
	var xlSheet=xlBook.Worksheets(1);
    var treeRoots=$('#'+treeGridId).treegrid('getRoots');
    var children=$('#'+treeGridId).treegrid('getChildren',treeRoots.target);
    var row=1;tmpLevel="",maxCol=0
    for(j=0;j<children.length;j++){
	    var childData=children[j];
		var phcCatLevel=childData.phcCatLevel;
		var phcCatDesc=childData.phcCatDesc;
		var phcCatRowId=childData.phcCatRowId;
		var levelNum=parseInt(phcCatLevel);
		var tmpChild=$('#'+treeGridId).treegrid('getChildren',phcCatRowId);
		tmpLevel=phcCatLevel;
		xlSheet.Cells(row,levelNum).value =phcCatDesc;
		if(tmpChild==""){
			if (row>1){
				for (var ni=1;ni<levelNum;ni++){			
					var xlSheetVal=xlSheet.Cells(row,ni).value || '';
					if (xlSheetVal==""){
						xlSheet.Cells(row,ni).value=xlSheet.Cells(row-1,ni).value;	
					}
				}
			}
			row++;
		}
		if (levelNum>maxCol){
			maxCol=levelNum;
		}
		
    }	 
	try{
		var fileName = xlApp.Application.GetSaveAsFilename("*.xls", "Excel Spreadsheets (*.xls), *.xls");
 		var ss = xlBook.SaveAs(fileName);  
	 	if (ss==false){
			$.messager.alert('������ʾ','���ʧ�ܣ�','warning') ;
		}		
	}
	catch(e){
		 $.messager.alert('������ʾ','���ʧ�ܣ�','warning') ;
	}		
	xlSheet=null;
    xlBook.Close (savechanges=false);
    xlBook=null;
    xlApp.Quit();
    xlApp=null;
}