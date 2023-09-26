var cureItemDataGrid; //����ȫ�ֱ���datagrid
$(function(){
	$('#btnFind').bind("click",function(){
		loadCureItemDataGrid();	
	})
	$('#btnSave').bind("click",function(){
		SaveCureItemDetail();	
	})
	//�����б�
    $('#CureItemCat').combobox({      
    	valueField:'ItemCatId',   
    	textField:'ItemCatDesc',
    	url:"./dhcdoc.cure.query.combo.easyui.csp",
    	onBeforeLoad:function(param){
						param.ClassName = 'DHCDoc.DHCDocCure.CureItemSet';
						param.QueryName = 'FindCureItemCat'
						param.ArgCnt =0;
		},
		onSelect:function(record){
				loadCureItemDataGrid();	
		}  
	});
	//�������б�
    $('#ServiceGroup').combobox({      
    	valueField:'Rowid',   
    	textField:'Desc',
    	url:"./dhcdoc.cure.query.combo.easyui.csp",
    	onBeforeLoad:function(param){
						param.ClassName = 'DHCDoc.DHCDocCure.RBCServiceGroupSet';
						param.QueryName = 'QueryServiceGroup'
						param.ArgCnt =0;
		}
	});
   var  cureItemColumns=[[    
        			{ field: 'ArcimDesc', title: '��Ŀ����', width: 200, align: 'center', sortable: true, resizable: true  
        			},
        			{ field: 'ActiveFlag', title: '�Ƿ񼤻�', width: 50, align: 'center', sortable: true, resizable: true  
        			},
        			{ field: 'ItemRowid', title: 'ItemRowid', width: 1, align: 'center', sortable: true, resizable: true,hidden:true  
        			},
					{ field: 'Rowid', title: 'Rowid', width: 1, align: 'center', sortable: true, resizable: true,hidden:true}	
    			 ]];
     // �б�Grid
	cureItemDataGrid=$('#tabCureItemSet').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		//scrollbarSize : '40px',
		url : './dhcdoc.cure.query.grid.easyui.csp',
		loadMsg : '������..',  
		pagination : true,  //
		rownumbers : true,  //
		idField:"LocId",
		pageList : [15,50,100,200],
		//frozenColumns : FrozenCateColumns,
		columns :cureItemColumns,
		onSelect : function(rowIndex, rowData) {
		},
		onLoadSuccess:function(data){  
		},
		onClickRow:function(rowIndex, rowData){
			cureItemDataGrid.datagrid('selectRow',rowIndex);
			var selected=cureItemDataGrid.datagrid('getRows'); 
			var Rowid=selected[rowIndex].Rowid;
			var ItemRowid=selected[rowIndex].ItemRowid;
			loadCureItemDetail(Rowid,ItemRowid);
		}
	});
});
function loadCureItemDetail(Rowid,ItemRowid)
{
	var ret=tkMakeServerCall("DHCDoc.DHCDocCure.CureItemSet","GetCureItemSet",Rowid,ItemRowid);
	if (ret=="") return;
	var TempArr=ret.split("^");
	var ArcimCode=TempArr[0];
	var ArcimDesc=TempArr[1];
	var ShortName=TempArr[2];
	var ServiceGroupDR=TempArr[3];
	var AutoAppFlag=TempArr[4];
	var Effect=TempArr[5];
	var Indication=TempArr[6];
	var Avoid=TempArr[7];
	if(AutoAppFlag=="Y")
	{
	   var AutoApp=true
	}else{
	   var AutoApp=false
	}
	$("#DDCISRowid").val(Rowid);
	$("#ItemRowid").val(ItemRowid);
	$("#ArcimCode").prop("innerText",ArcimCode);
	$("#ArcimDesc").prop("innerText",ArcimDesc);
	$("#ShortName").val(ShortName);
	$('#ServiceGroup').combobox('setValue',ServiceGroupDR);
	$("#AutoApp").attr('checked',AutoApp);
	$("#Effect").val(Effect);
	$("#Indication").val(Indication);
	$("#Avoid").val(Avoid);
	
}
function loadCureItemDataGrid()
{
	var CureItemCat=$('#CureItemCat').combobox('getValue');
	var CureItemDesc=$('#CureItemDesc').val();
	var queryParams = new Object();
	queryParams.ClassName ='DHCDoc.DHCDocCure.CureItemSet';
	queryParams.QueryName ='FindCureItem';
	queryParams.Arg1 =CureItemCat;
	queryParams.Arg2 =CureItemDesc;	
	queryParams.ArgCnt =2;
	var opts = cureItemDataGrid.datagrid("options");
	opts.url = "./dhcdoc.cure.query.grid.easyui.csp"
	cureItemDataGrid.datagrid('load', queryParams);
	cureItemDataGrid.datagrid("unselectAll")
}
function CheckData(){
    var ItemRowid=$('#ItemRowid').val();
    var ServiceGroupDR=$('#ServiceGroup').combobox('getValue');
	if(ItemRowid=="")
	{
		 $.messager.alert("����", "���벻��Ϊ��", 'error')
        return false;
	}
	if(ServiceGroupDR=="")
	{
		$.messager.alert('Warning','�����鲻��Ϊ��');   
        return false;
	}
	return true;
}
function SaveCureItemDetail()
{
    if(!CheckData()) return false; 
    var DDCISRowid=$('#DDCISRowid').val();
    var ItemRowid=$('#ItemRowid').val();
    var ShortName=$('#ShortName').val();
    var ServiceGroupDR=$('#ServiceGroup').combobox('getValue');
    var AutoAppFlag="";
	    if ($("#AutoApp").is(":checked")) {
		         AutoAppFlag="Y";
	}
	var Effect=$("#Effect").val();
	var Indication=$("#Indication").val();
	var Avoid=$("#Avoid").val();
	var InputPara=DDCISRowid+"^"+ItemRowid+"^"+ShortName+"^"+ServiceGroupDR+"^"+AutoAppFlag+"^"+Effect+"^"+Indication+"^"+Avoid;
    //alert(InputPara)
		 $.dhc.util.runServerMethod("DHCDoc.DHCDocCure.CureItemSet","SaveCureItemSet","false",function testget(value){
		if(value=="0"){
			$.messager.show({title:"��ʾ",msg:"����ɹ�"});
			loadCureItemDataGrid();		
		}else{
			return false;
		}
	   },"","",InputPara);
}


