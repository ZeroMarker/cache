/*������Ȩ*/
var currEditRow="";currEditID="";currPointer="";
var currLibDr="";	/// ֪ʶ�������
var extraAttr = "KnowType";			// ֪ʶ����(��������)
var extraAttrValue = "ModelFlag" 	// ʵ����(��������ֵ)
var selectEle="";

function initPageDefault(){
	
	//InitPageComponent();	/// ��ʼ������ؼ�
	InitPageDataGrid();		/// ��ʼ������Datagrid
	InitButton();			/// ��ʼ��������水ť��Ӧ

}
// ��ʼ������ؼ�
function InitPageComponent()
{
	/// ֪ʶ������
	var option = {
		panelHeight:"auto",       
	    onLoadSuccess: function () { //���ݼ�������¼�
	    	$("#libcombo").combobox('setValue',5)
        },
        onSelect:function(option){
	        currLibDr = option.value;
	    }
	};
	var url = $URL+"?ClassName=web.DHCCKBDiction&MethodName=GetDicComboboxList&extraAttr="+extraAttr +"&extraAttrValue="+extraAttrValue;
	new ListCombobox("libcombo",url,'',option).init();
}
// ��ʼ������DataGrid
function InitPageDataGrid(){

	/// ҽԺ
	///  ����columns
	var hospcolumns=[[
	
		{field:'desc',title:'ҽԺ',width:300}, 
		{field:'activeflag',title:'����',width:60,align:'left',formatter:SetCellUrl,hidden:true}, 
		{field:'permisflag',title:'��Ȩ',width:60,align:'left',formatter:PermisCellUrl}, 
		{field:'rowid',title:'rowid',hidden:true}
	]];
	
	///  ����datagrid
	var hospoption = {
		fitColumn:true,
		rownumbers : false,
		singleSelect : true,
		fit : false,
		pageSize : [30],
		pageList : [30,60,90],
		toolbar:[],	
		pagination: false,
	    onClickRow: function (rowIndex, rowData) {
		    // if (currLibDr !== ""){
				var pointer=rowData.rowid;
		   		var input=currLibDr+"^"+pointer+"^"+"D";
		   		selectEle = currLibDr +"^"+ "D" +"^"+ pointer;
		   		QueryAccitm(input);
			//}else{
				//$.messager.alert('������ʾ','֪ʶ�ⲻ��Ϊ��!',"error");
				//return;			
			//}           
        }
	    
	};
	var uniturl = $URL+"?ClassName=web.DHCCKBGrantAuth&MethodName=QueryHospList&rows=100&page=1";
	new ListComponent('hospgrid', hospcolumns, uniturl, hospoption).Init();
	
	
	///ְ��
	var ctpcolumns=[[  
		{field:'desc',title:'ְ��',width:300},
		{field:'activeflag',title:'����',width:60,align:'left',formatter:SetCellUrl,hidden:true},
		{field:'permisflag',title:'��Ȩ',width:60,align:'left',formatter:PermisCellUrl}, 
		{field:'rowid',title:'rowid',hidden:true}
	]];
	var ctpoption = {
		fitColumn:true,
		rownumbers : false,
		singleSelect : true,
		fit : false,
		pageSize : [30],
		pageList : [30,60,90],
		pagination: true,
		toolbar: [],
		onClickRow: function (rowIndex, rowData) {
		    //if (currLibDr !== ""){
				var pointer=rowData.rowid;
		   		var input=currLibDr+"^"+pointer+"^"+"C";
		   		selectEle = currLibDr +"^"+ "C" +"^"+ pointer;
		   		QueryAccitm(input);
			//}else{
				//$.messager.alert('������ʾ','֪ʶ�ⲻ��Ϊ��!',"error");
				//return;			
			//}           
        }
	};
	var uniturl = $URL+"?ClassName=web.DHCCKBGrantAuth&MethodName=QueryCtCptList";
	new ListComponent('cptgrid', ctpcolumns, uniturl, ctpoption).Init();
	
	
	///ҽ������
	var docloccolumns=[[  
		{field:'code',title:'����',width:200,hidden:true},
		{field:'desc',title:'����',align:'left',width:300}, //qunianpeng 2017/10/9
		{field:'activeflag',title:'����',width:60,align:'left',formatter:SetCellUrl,hidden:true},
		{field:'permisflag',title:'��Ȩ',width:60,align:'left',formatter:PermisCellUrl}, 
		{field:'rowid',title:'rowid',hidden:true}
	]];	
	var doclocoption = {
		fitColumn:true,
		rownumbers : false,
		singleSelect : true,
		fit : false,
		pageSize : [30],
		pageList : [30,60,90],
		pagination: true,
		toolbar:'#doclocbar',
		onClickRow: function (rowIndex, rowData) {
		    //if (currLibDr !== ""){
				var pointer=rowData.rowid;
		   		var input=currLibDr+"^"+pointer+"^"+"L";
		   		selectEle = currLibDr +"^"+ "L" +"^"+ pointer;
		   		QueryAccitm(input);
			//}else{
				//$.messager.alert('������ʾ','֪ʶ�ⲻ��Ϊ��!',"error");
				//return;			
			//}           
        }	   
	};
	var uniturl = $URL+"?ClassName=web.DHCCKBGrantAuth&MethodName=QueryDocLocList&Input=&HospId="+LgHospID;
	new ListComponent('doclocgrid', docloccolumns, uniturl, doclocoption).Init();

	///ҽ��
	var doccolumns=[[  
		{field:'desc',title:'ҽ��',width:150,align:'left',},
		{field:'code',title:'����',width:150,align:'left',},
		{field:'activeflag',title:'����',width:60,align:'left',formatter:SetCellUrl,hidden:true},
		{field:'permisflag',title:'��Ȩ',width:60,align:'left',formatter:PermisCellUrl}, 
		{field:'rowid',title:'rowid',hidden:true}
	]];
	var docoption = {
		fitColumn:true,
		rownumbers : false,
		singleSelect : true,
		fit : false,
		pageSize : [30],
		pageList : [30,60,90],
		pagination: true,
		toolbar:'#doctorbar',
		onClickRow: function (rowIndex, rowData) {
		    //if (currLibDr !== ""){
				var pointer=rowData.rowid;
		   		var input=currLibDr+"^"+pointer+"^"+"U";
		   		selectEle = currLibDr +"^"+ "U" +"^"+ pointer;
		   		QueryAccitm(input);
			//}else{
				//$.messager.alert('������ʾ','֪ʶ�ⲻ��Ϊ��!',"error");
				//return;			
			//}           
        }	   
	};
	var uniturl = $URL+"?ClassName=web.DHCCKBGrantAuth&MethodName=QueryAccDocList&rows=100&page=1&input=";
	new ListComponent('docgrid',doccolumns, uniturl, docoption).Init();
	
	
	/// Ȩ���б�
	var accitmclumns=[[ 
		{field:'desc',title:'����',width:580}, 
		{field:'libdr',title:'libdr',hidden:true}, 
		{field:'lib',title:'֪ʶ��',width:80,hidden:true}, 
		{field:'ralation',title:'��ϵ',hidden:true},   
		{field:'rowid',title:'rowid',hidden:true},
		{field:'id',title:'id',hidden:true},
		{field:'_parentId',title:'parentId',hidden:true},
		{field:'contrl',title:'����',hidden:true},
		{field:'chk',title:'ѡ��',hidden:true},
		{field:'dataType',title:'�ֵ������',hidden:true}
	]];	
	var accoption = {
		fitColumn:true,
		rownumbers : false,
		singleSelect : true,
		//fit : false,
		toolbar:'#btntoolbar',
		pageSize : [800],
		pageList : [800,1600,2400,3200,4000,4800],
		pagination: true,
		onLoadSuccess: function (index,data) { //���ݼ�������¼�
           $.each(data.rows,function(tmpindex,obj){
	           if (obj._parentId == ""){
		       		return true;		// �˳�����ѭ��
		       }
		       if(obj.chk == "Y"){
			   		$HUI.treegrid("#accitmgrid").checkNode(obj.id);	
			   }
	       })
        },
        uncheckNode:function(){
	        
	        
	    }	
			   
	};
	var uniturl = $URL+"?ClassName=web.DHCCKBGrantAuth&MethodName=QueryLibAccMenu";
	new ListTreeGrid('accitmgrid', accitmclumns, uniturl, accoption).Init();
}
/// ��ѯ��Ȩ��Ŀ
function QueryAccitm(input){
	
	currPointer = input;
	$('#accitmgrid').treegrid('load',{
		Input:input
	
	}); 
}
/// ��ʼ�����水ť��Ӧ
function InitButton(){

	// ���һس��¼�
	$('#doclocbarid').bind('keydown',function(event){
		 if(event.keyCode == "13"){			 
			var Input=$.trim($("#doclocbarid").val());
			$('#doclocgrid').datagrid('load',  {  
				Input:Input	
			});
		 }
	});
	
	// ҽ���س��¼�
	$('#doctorno').bind('keydown',function(event){
		 if(event.keyCode == "13") {			 
			 var input=$.trim($("#doctorno").val());  			
			$('#docgrid').datagrid('load',  {  
				input:input	
			});
		 }
�� });

	$("#btnSave").click(function(){
	   	SaveAcc();
    })
}

//������Ȩ
function SaveAcc()
{
	/*
	if (currPointer == ""){
		$.messager.alert("��ʾ","��ѡ��֪ʶ�����Ȩ����!","info");
		return ;
	}
	*/
	
	var input="";
    var allCheck = $HUI.treegrid('#accitmgrid').getCheckedNodes();
	/* if ((allCheck == "")||(allCheck == null)){
		$.messager.alert("��ʾ","��ѡ����Ҫ��Ȩ����Ŀ����б���!","info");
	    return;
	  
	} */
	var exitFlag = 0;
	if ((allCheck == "")||(allCheck == null)){
		$.messager.confirm('��ʾ', '����ѡ����Ŀ����ʱ�����������ǰ�û�����Ȩ����<br/>ȷ�������?', function(r){
			if (r){					
				SaveTemp();  				
			}
			else{
				return;
			}
		});	
	}else{
		SaveTemp();
	}		
    
 }

/// ����ǰ��֯��������
function SaveTemp(){
	
	var allCheck = $HUI.treegrid('#accitmgrid').getCheckedNodes();
	var tmpPar = "",ParArr=[],ParInfo ="",checkInfoArr = [];							
	for (var i=0; i<allCheck.length; i++){
		if (allCheck[i]._parentId == ""){	// �ϲ�ڵ�			
			continue;
		}
		else{			
			var checkInfo = allCheck[i].id +":"+allCheck[i].dataType ;	// ��ѡ���ӽڵ�;
			var parRowID = allCheck[i]._parentId;	// ���ڵ�			
			if (ParArr.indexOf(parRowID)==-1){	// ���ڵ��Ѿ��洢��
				ParArr.push(parRowID);
				if (ParInfo == ""){
					ParInfo = parRowID+":DHC_CKBCommonDiction" +"^"+ checkInfo;		
				}else{
					ParInfo = ParInfo +"!"+ parRowID+":DHC_CKBCommonDiction" +"^"+ checkInfo;	
				}
				checkInfoArr.push(allCheck[i].id);				
			}
			else{
				if (checkInfoArr.indexOf(allCheck[i].id)!=-1){
					continue;
				}			
				ParInfo = ParInfo +"^"+ checkInfo;	
				checkInfoArr.push(allCheck[i].id);				
			}			
		}
	}
	//		selectEle(֪ʶ������+"^"+������+"^"+������ֵ)   +"^"+ �����û� +"^"+ �ͻ���ip    +"@"+ ��Ŀid:�ֵ�����^��Ŀid:�ֵ�����!��Ŀid:�ֵ�����
 	input = selectEle +"^"+ LgUserID +"^"+ ClientIPAdd +"@"+ ParInfo; 
	
	Save(input); 

}
 
function Save(ListData){
					
	runClassMethod("web.DHCCKBGrantAuth","SaveAccItm",{"ListData":ListData},function(jsonString){
		if(jsonString != 0){
			$.messager.alert("��ʾ","����ʧ��:"+jsonString,"error");
		}else{
			$.messager.alert("��ʾ","����ɹ�","info");
			ReloadData();
		}
	},'text',false)
}

/// ȫѡ ȫ��
function trsCheck(isCheckFlag){

	var data = $HUI.treegrid('#accitmgrid').getRoots();
	$.each(data, function(index, obj){
		if (isCheckFlag){
			$HUI.treegrid("#accitmgrid").checkNode(obj.id);
		}else{
			$HUI.treegrid("#accitmgrid").uncheckNode(obj.id);
		}
	})
}

/// ����
function SetCellUrl(value, rowData, rowIndex){
	
	var Type = rowData.type;
	var ID = rowData.rowid;
	var UseFlag = "";
	var html = "";
	if (value == "Y"){
		UseFlag = "N";
		html = "<a href='#' onclick=\"modFlag('"+ Type +"','"+ ID +"','"+ UseFlag +"')\"><img src='../scripts_lib/hisui-0.1.0/dist/css/icons/ok.png'/></a>";
	}else{
		UseFlag = "Y";
		html += "<a href='#' onclick=\"modFlag('"+ Type +"','"+ ID +"','"+ UseFlag +"')\"><img src='../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png'/></a>";
	
	}
	return html;
}

/// �޸�
function modFlag(Type, PointDr, UseFlag){
	
	runClassMethod("web.DHCCKBGrantAuth","InsUse",{"PointType":Type, "PointDr":PointDr, "IsUseFlag":UseFlag},function(jsonString){
		
		if(jsonString != 0){
			$.messager.alert("��ʾ","�޸�ʧ��:"+jsonString,"error");
		}else{
			$.messager.alert("��ʾ","�޸ĳɹ�","info");
			var ID = "";
			if (Type == "D") ID = "hospgrid";
			if (Type == "L") ID = "doclocgrid";
			if (Type == "C") ID = "cptgrid";
			if (Type == "U") ID = "docgrid";
			$HUI.datagrid("#"+ ID).reload();
		}
	},'text',false)
}

/// �Ƿ�����Ȩ
function PermisCellUrl(value, rowData, rowIndex){
	
	var Type = rowData.type;
	var ID = rowData.rowid;
	var UseFlag = "";
	var html = "";
	value = (value=="Y")?"��":"��";
	if (value == "��"){	
		html = "<span style='color:green'>"+ value +"</span>";
	}else{	
		html += "<span style='color:red'>"+ value +"</span>";
	
	}
	return html;
}

function ReloadData(){
	//	$('#attrlist').datagrid('reload'); //���¼���
	$("#hospgrid").datagrid("reload");
	$("#cptgrid").datagrid("reload");
	$("#doclocgrid").datagrid("reload");
	$("#docgrid").datagrid("reload");
}

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
