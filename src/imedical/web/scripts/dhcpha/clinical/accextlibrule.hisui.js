/*
Creator:LiangQiang
CreatDate:2014-11-26
Description:������Ŀά��
*/

var currEditRow="";currEditID="";currPointer="";
var currLibDr="";	/// ֪ʶ�������

$(function(){

	InitPageComponent();	/// ��ʼ������ؼ�
	InitPageDataGrid();		/// ��ʼ������Datagrid
	InitButton();			/// ��ʼ��������水ť��Ӧ

});


// ��ʼ������ؼ�
function InitPageComponent(){
	
		/// ֪ʶ������
	var option = {
		panelHeight:"auto",       
	    onLoadSuccess: function () { //���ݼ�������¼�
        },
        onSelect:function(option){
	        currLibDr = option.value;
	    }
	};
	var url = $URL+"?ClassName=web.DHCSTPHCMADDEXTLIB&MethodName=QueryLibComboListNew";
	new ListCombobox("libcombo",url,'',option).init();

}


// ��ʼ������DataGrid
function InitPageDataGrid(){

	/// ҽԺ
	///  ����columns
	var hospcolumns=[[
		{field:'desc',title:'ҽԺ',width:400}, 
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
		pagination: false,
	    onClickRow: function (rowIndex, rowData) {
		    if (currLibDr !== ""){
				var pointer=rowData.rowid;
		   		var input=currLibDr+"^"+pointer+"^"+"hosp";
		   		QueryAccitm(input);
			}else{
				$.messager.alert('������ʾ','֪ʶ�ⲻ��Ϊ��!',"error");
				return;			
			}           
        }
	    
	};
	var uniturl = $URL+"?ClassName=web.DHCSTPHCMADDEXTLIB&MethodName=QueryHospList&rows=100&page=1";
	new ListComponent('hospgrid', hospcolumns, uniturl, hospoption).Init();
	
	
	///ְ��
	var ctpcolumns=[[  
		{field:'desc',title:'ְ��',width:400}, 
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
		onClickRow: function (rowIndex, rowData) {
		    if (currLibDr !== ""){
				var pointer=rowData.rowid;
		   		var input=currLibDr+"^"+pointer+"^"+"cpt";
		   		QueryAccitm(input);
			}else{
				$.messager.alert('������ʾ','֪ʶ�ⲻ��Ϊ��!',"error");
				return;			
			}           
        }
	};
	var uniturl = $URL+"?ClassName=web.DHCSTPHCMADDEXTLIB&MethodName=QueryCtCptList&rows=100&page=1";
	new ListComponent('cptgrid', ctpcolumns, uniturl, ctpoption).Init();
	
	
	///ҽ������
	var docloccolumns=[[  
		{field:'code',title:'����',width:200,hidden:true}, 
		{field:'desc',title:'����',width:400}, //qunianpeng 2017/10/9
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
		    if (currLibDr !== ""){
				var pointer=rowData.rowid;
		   		var input=currLibDr+"^"+pointer+"^"+"docloc";
		   		QueryAccitm(input);
			}else{
				$.messager.alert('������ʾ','֪ʶ�ⲻ��Ϊ��!',"error");
				return;			
			}           
        }	   
	};
	var uniturl = $URL+"?ClassName=web.DHCSTPHCMADDEXTLIB&MethodName=QueryDocLocList&rows=100&page=1&input=";
	new ListComponent('doclocgrid', docloccolumns, uniturl, doclocoption).Init();
	
	///ҽ��
	var doccolumns=[[  
		{field:'desc',title:'ҽ��',width:200},
		{field:'code',title:'����',width:200},  
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
		    if (currLibDr !== ""){
				var pointer=rowData.rowid;
		   		var input=currLibDr+"^"+pointer+"^"+"doc";
		   		QueryAccitm(input);
			}else{
				$.messager.alert('������ʾ','֪ʶ�ⲻ��Ϊ��!',"error");
				return;			
			}           
        }	   
	};
	var uniturl = $URL+"?ClassName=web.DHCSTPHCMADDEXTLIB&MethodName=QueryAccDocList&rows=100&page=1&input=";
	new ListComponent('docgrid',doccolumns, uniturl, docoption).Init();
	
	
	/// Ȩ���б�
	var accitmclumns=[[ 
		{field:'desc',title:'����',width:580}, 
		{field:'libdr',title:'libdr',hidden:true}, 
		{field:'lib',title:'֪ʶ��',width:80}, 
		{field:'ralation',title:'��ϵ',hidden:true},   
		{field:'rowid',title:'rowid',hidden:true},
		{field:'id',title:'id',hidden:true},
		{field:'_parentId',title:'parentId',hidden:true},
		{field:'contrl',title:'����',hidden:true},
		{field:'chk',title:'ѡ��',hidden:true}
	]];	
	var accoption = {
		fitColumn:true,
		rownumbers : false,
		singleSelect : true,
		//fit : false,
		toolbar:'#toolbar',
		pageSize : [150],
		pageList : [150,300,450],
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
        }		
			   
	};
	var uniturl = $URL+"?ClassName=web.DHCSTPHCMADDEXTLIB&MethodName=QueryLibAccMenu";
	new ListTreeGrid('accitmgrid', accitmclumns, uniturl, accoption).Init();
}


/// ��ʼ�����水ť��Ӧ
function InitButton(){

	// ���һس��¼�
	$('#doclocbarid').bind('keydown',function(event){
		 if(event.keyCode == "13"){			 
			var input=$.trim($("#doclocbarid").val());
			$('#doclocgrid').datagrid('load',  {  
				input:input	
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

/// ��ѯ��Ȩ��Ŀ
function QueryAccitm(input){
	
	currPointer = input;
	$('#accitmgrid').treegrid('load',{
		input:input
	
	}); 
}


//������Ȩ
function SaveAcc()
{
	if (currPointer == ""){
		$.messager.alert("��ʾ","��ѡ��֪ʶ�����Ȩ����!","info");
		return ;
	}
	
    var input="";
    var allCheck = $HUI.treegrid('#accitmgrid').getCheckedNodes();
	if ((allCheck == "")||(allCheck == null)){
		$.messager.alert("��ʾ","��ѡ����Ҫ��Ȩ����Ŀ����б��棡!","info");
	    return;
	  
	}
    var tmpPar = "";
	for (var i=0; i<allCheck.length; i++){
		if (allCheck[i]._parentId == ""){
			continue; 
		}
		else{
			if(tmpPar == allCheck[i]._parentId){
				continue;
			}
			tmpPar = allCheck[i]._parentId;
			var checkInfo = "";
			var parRowID = "";
			for(var j=0;j<allCheck.length;j++){
				if (allCheck[j]._parentId != allCheck[i]._parentId){				
					continue;
				}
				if (checkInfo == ""){
					checkInfo = allCheck[j].rowid + ":" + "Y"	;
				}else{
					checkInfo = checkInfo +"^"+ allCheck[j].rowid + ":" + "Y"	;
				}	
				parRowID = 	allCheck[j].rowid.split("||")[0];		
			}
			if (input == ""){
				input = parRowID +":"+ "Y" + "^"+ checkInfo;
			}else{
				input = input + "!" +parRowID +":"+ "Y" + "^"+ checkInfo;
			}			
				
		}
	}
	input = currPointer+"@"+input; 
	Save(input);   
 }
 
function Save(input){
	runClassMethod("web.DHCSTPHCMADDEXTLIB","SaveAccItm",{"input":input},function(jsonString){
		if(jsonString != 0){
			$.messager.alert("��ʾ","����ʧ��:"+jsonString,"error");
		}else{
			$.messager.alert("��ʾ","����ɹ�","info");
		}
	},'text',false)

}
 
