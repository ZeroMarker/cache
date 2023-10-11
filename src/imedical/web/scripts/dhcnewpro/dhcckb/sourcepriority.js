//===========================================================================================
// Author��      lidong
// Date:		 2022-11-15
// Description:	 ֪ʶ��Դ����
//===========================================================================================
var editaddRow="";
var CatId = getParam("catalogueid");
var nodeArr=[];	
function initPageDefault(){
	InitButton();			// ��ť��Ӧ�¼���ʼ��
	InitDataList();			// ʵ��DataGrid��ʼ������
	
}

/// ��ť��Ӧ�¼���ʼ��
function InitButton(){

	/* $("#insert").bind("click",insertRow);	// �������� */
	
	$("#save").bind("click",saveRow);		// ����
	
	/* $("#delete").bind("click",DeleteRow);	// ɾ�� */
	$("#find").bind("click",QueryKnowList);	// ��ѯ
	
	$("#reset").bind("click",InitPageInfo);	// ����
	
	/// ����.������ѯ
	$('#queryName').searchbox({
	    searcher:function(value,name){
	   		QueryKnowList();
	    }	   
	});	
	
}
/// ʵ��DataGrid��ʼ����ͨ����
function InitDataList(){
	/// �ı��༭��
	var textEditor={
		type: 'text',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}
	/* // ֪ʶ��Դ
	var KnowSourceeditor={
					type:'combobox',
				  	 options:{
					  	valueField:'value',
						textField:'text',
						mode:'remote',
						enterNullValueClear:false,
						blurValidValue:true,
						onSelect:function(option){
							var ed=$("#KnowList").datagrid('getEditor',{index:editaddRow,field:'KnowSource'});
							$(ed.target).combobox('setValue', option.text);
							var ed=$("#KnowList").datagrid('getEditor',{index:editaddRow,field:'KnowSourceId'});
							$(ed.target).val(option.value);
						},
				  		onShowPanel:function(){
							var ed=$("#KnowList").datagrid('getEditor',{index:editaddRow,field:'KnowSource'});
							var unitUrl=$URL+"?ClassName=web.DHCCKBSourcePriority&MethodName=GetKnowSourceComboxData&q="+'';
							$(ed.target).combobox('reload',unitUrl);	
				    			}	  
							
				  	 	}
				  	 
				 } */
	// �Ƿ�����
	/* var IsEnableeditor={
					type:'switchbox',
				  	 options:{
					  	onText:'��',
        				offText:'��',
        				onClass:'primary',
        				offClass:'gray',
        				animated:'true',
        				size:'small',
        				onSwitchChange:function(e,obj){
            				console.log(e);
            				console.log(obj);
        					}	  
							
				  	 	}
		 } */
		 
	// �߼���ϵ
	var Relationeditor={type:'combobox',
				  	 options:{
					  	valueField:'value',
						textField:'text',
						mode:'remote',
						enterNullValueClear:false,
						blurValidValue:true,
						onSelect:function(option){
							var ed=$("#KnowList").datagrid('getEditor',{index:editaddRow,field:'Relation'});
							$(ed.target).combobox('setValue', option.text);
						},
				  		onShowPanel:function(){
							var data=[{"value":"and","text":"and"},{"value":"or","text":"or"}];
							var ed=$("#KnowList").datagrid('getEditor',{index:editaddRow,field:'Relation'});
							$(ed.target).combobox('loadData',data);	
				    			}	  
							
				  	 	}
		 }
	// ����columns
	var columns=[[   	 
			{field:'RowID',title:'RowID',hidden:true},
			{field:'KnowSourceId',title:'֪ʶ��ԴID',align:'center',hidden:true},
			{field:'KnowSource',title:'֪ʶ��Դ',width:100,align:'left',hidden:false},
			{field:'IsEnableId',title:'�Ƿ�����ID',align:'center',editor:textEditor,hidden:true},
			{field:'IsEnable',title:'�Ƿ�����',width:100,align:'center',
			formatter:function(value,row,index){
				 if (value === 'Y') {//��Ч
                            return "<div id='" + row.KnowSourceId + "' class='hisui-switchbox switchBtn1' RowID='" + row.RowID + "' Relation='" + row.Relation + "' Num='" + row.Num + "' ></div>"
                        } else if (value === 'N') {//����Ч
                            return "<div id='" + row.KnowSourceId + "' class='hisui-switchbox switchBtn2' RowID='" + row.RowID + "' Relation='" + row.Relation + "' Num='" + row.Num + "' ></div>"
                        }
				}
			,hidden:false},
			{field:'Relation',title:'�߼���ϵ',width:100,align:'center',editor:Relationeditor,hidden:false},
			{field:'Num',title:'˳�����',width:100,align:'center',editor:textEditor,hidden:false},
			{field:'pri',title:'���ȼ�',width:100,align:'center',
			formatter:function(value,rec,index){
			var a = '<a href="#" mce_href="#" onclick="upclick(\''+ index + '\')">'+'<img border="0" src="../scripts_lib/hisui-0.1.0/dist/css/icons/up.png"/>'+'</a> ';
			var b = '<a href="#" mce_href="#" onclick="downclick(\''+ index + '\')">'+'<img border="0" src="../scripts_lib/hisui-0.1.0/dist/css/icons/down.png"/>'+'</a> ';
			return a+b;  
        		}  
			,hidden:false},
						
		 ]]

	var option={	
		bordr:false,
		fit:true,
		fitColumns:true,
		singleSelect:true,	
		nowrap: false,
		striped: true, 
		pagination:true,
		rownumbers:true,
		pageSize:30,
		pageList:[30,60,90],
		onLoadSuccess: function (data) {
			 $(".switchBtn1").switchbox({
				 	onText:'��',
        			offText:'��',
        			onClass:'primary',
        			offClass:'gray',
        			animated:'true',
        			size:'small',
        			checked:true,
        			onSwitchChange:function(e,obj){
	        			/* var ed=$("#KnowList").datagrid('getEditor',{index:editaddRow,field:'IsEnableId'}); 
            			$(ed.target).val(obj.value); */
						console.log(e);
            			console.log(obj);
            			if((CatId=="")||(CatId==undefined)){
	            		var CheckVal=obj.value;
	            		var RowId= $(this).attr("RowID");
            			var CataLogId="";
            			var KnowSourceId=$(this).attr("id");
            			var Relation=$(this).attr("Relation");
            			if (CheckVal==false){
	            			var Active="N";
	            		};
	            		if(CheckVal==true){
		            		var Active="Y";
		            	};
		            	var Num=$(this).attr("Num");
		            	var Type="Global";
		            	var TypeDr="";
		            	var tmp=RowId+"^"+CataLogId+"^"+KnowSourceId+"^"+Relation+"^"+Active+"^"+Num+"^"+Type+"^"+TypeDr;
	            		SaveNew(tmp);
	            		}else{
		            	var CheckVal=obj.value;
		            	var RowId= $(this).attr("RowID");
            			var CataLogId=CatId;
            			var KnowSourceId=$(this).attr("id");
            			var Relation=$(this).attr("Relation");
            			if (CheckVal==false){
	            			var Active="N";
	            		};
	            		if(CheckVal==true){
		            		var Active="Y";
		            	};
		            	var Num=$(this).attr("Num");
		            	var Type="Lib";
		            	var TypeDr="";
		            	var tmp=RowId+"^"+CataLogId+"^"+KnowSourceId+"^"+Relation+"^"+Active+"^"+Num+"^"+Type+"^"+TypeDr;	
		            	SaveNew(tmp);
		            		}
            			
            			}
				 }),
			$(".switchBtn2").switchbox({
				 	onText:'��',
        			offText:'��',
        			onClass:'primary',
        			offClass:'gray',
        			animated:'true',
        			size:'small',
        			checked:false,
        			onSwitchChange:function(e,obj){
            			/* var ed=$("#KnowList").datagrid('getEditor',{index:editaddRow,field:'IsEnableId'}); 
            			$(ed.target).val(obj.value); */
						console.log(e);
            			console.log(obj);
            			
            			if((CatId=="")||(CatId==undefined)){
	            		var CheckVal=obj.value;
	            		var RowId= $(this).attr("RowID");
            			var CataLogId="";
            			var KnowSourceId=$(this).attr("id");
            			var Relation=$(this).attr("Relation");
            			if (CheckVal==false){
	            			var Active="N";
	            		};
	            		if(CheckVal==true){
		            		var Active="Y";
		            	};
		            	var Num=$(this).attr("Num");
		            	var Type="Global";
		            	var TypeDr="";
		            	var tmp=RowId+"^"+CataLogId+"^"+KnowSourceId+"^"+Relation+"^"+Active+"^"+Num+"^"+Type+"^"+TypeDr;
	            		SaveNew(tmp);
	            		}else{
		            	var CheckVal=obj.value;
		            	var RowId= $(this).attr("RowID");
            			var CataLogId=CatId;
            			var KnowSourceId=$(this).attr("id");
            			var Relation=$(this).attr("Relation");
            			if (CheckVal==false){
	            			var Active="N";
	            		};
	            		if(CheckVal==true){
		            		var Active="Y";
		            	};
		            	var Num=$(this).attr("Num");
		            	var Type="Lib";
		            	var TypeDr="";
		            	var tmp=RowId+"^"+CataLogId+"^"+KnowSourceId+"^"+Relation+"^"+Active+"^"+Num+"^"+Type+"^"+TypeDr;	
		            	SaveNew(tmp);
		            		}
            			
            			}
				 })
			},		
 		onClickRow:function(rowIndex,rowData){
	 		editaddRow=rowIndex; 	
 		 }, 
		onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
			editaddRow=rowIndex;
			if (editaddRow != ""||editaddRow == 0) { 
                $("#KnowList").datagrid('endEdit', editaddRow); 
            } 
            $("#KnowList").datagrid('beginEdit', rowIndex); 
             var editors = $('#KnowList').datagrid('getEditors', rowIndex);    //wangxuejian 2021-05-19 ʧȥ����رձ༭��                
            /*for (var i = 0; i < editors.length; i++)   
            {  
                var e = editors[i];
                 
              	$(e.target).bind("blur",function()
              	  {  
                    $("#KnowList").datagrid('endEdit', rowIndex);
                  });   
                  
            }  */
             
        }
		  
	}
	/* var uniturl = $URL+"?ClassName=web.DHCCKBSourcePriority&MethodName=GetKnowListByKnow&KnowSource=&CatalogueID="+CatId; */
	 if((CatId=="")||CatId==undefined){
	var uniturl = $URL+"?ClassName=web.DHCCKBSourcePriority&MethodName=GetKnowListByKnow&KnowSource=&CatalogueID="+CatId;
	}
	if(CatId!=""){
		var uniturl = $URL+"?ClassName=web.DHCCKBSourcePriority&MethodName=GetKnowListByKnownew&KnowSource=&CatalogueID="+CatId;
		} 
	new ListComponent('KnowList', columns, uniturl, option).Init();
	
}
/// ʵ��datagrid��ѯ
function QueryKnowList()
{
	var params = $HUI.searchbox("#queryName").getValue();
	$('#KnowList').datagrid('load',{
		CatalogueID:CatId,
		KnowSource:params
	})
	
}

/// ʵ��datagrid����
function InitPageInfo(){	

	$HUI.searchbox('#queryName').setValue("");
	QueryKnowList();	

}


/// ����༭��
function saveRow(){
	var CatId = getParam("catalogueid");
	if(editaddRow>="0"){
		$("#KnowList").datagrid('endEdit', editaddRow);
	}
	var rowsData = $("#KnowList").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	} 
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		if((CatId=="")||(CatId==undefined)){
		var RowId=$g(rowsData[i].RowID);
		var CataLogId="";
		var KnowSourceId=$g(rowsData[i].KnowSourceId);
		var Relation=$g(rowsData[i].Relation);
		var IsEnableId=$g(rowsData[i].IsEnableId);
		if(IsEnableId=="false"){
			var IsEnable="N"
		}else{
			var IsEnable="Y"
			};
		var Num=$g(rowsData[i].Num);
		var Type="Global"
		var TypeDr=""
		var tmp=RowId+"^"+CataLogId+"^"+KnowSourceId+"^"+Relation+"^"+IsEnable+"^"+Num+"^"+Type+"^"+TypeDr;
		dataList.push(tmp);
		}else{
		var RowId=$g(rowsData[i].RowID);
		var CataLogId=CatId;
		var KnowSourceId=$g(rowsData[i].KnowSourceId);
		var Relation=$g(rowsData[i].Relation);
		var IsEnableId=$g(rowsData[i].IsEnableId);
		if(IsEnableId=="false"){
			var IsEnable="N"
		}else{
			var IsEnable="Y"
			};
		var Num=$g(rowsData[i].Num);
		var Type="Lib"
		var TypeDr=""
		var tmp=RowId+"^"+CataLogId+"^"+KnowSourceId+"^"+Relation+"^"+IsEnable+"^"+Num+"^"+Type+"^"+TypeDr;
		dataList.push(tmp);
			}
	} 
	var params=dataList.join("&&");
	
	//��������
	runClassMethod("web.DHCCKBSourcePriority","SaveUpdate",{"params":params},function(jsonString){
		if (jsonString >= 0){
			$.messager.alert('��ʾ','����ɹ���','info');
		}else if(jsonString == -100){
			$.messager.alert('��ʾ','����ʧ��,�Ѵ��ڸ������ݣ�','warning');
		}else{
			$.messager.alert('��ʾ','����ʧ�ܣ�','warning');
		}
		InitPageInfo();		
		
	});
}
function SaveNew(tmp){
	runClassMethod("web.DHCCKBSourcePriority","SaveUpdate",{"params":tmp},function(jsonString){
		if (jsonString >= 0){
			$.messager.alert('��ʾ','����ɹ���','info');
		}else{
			$.messager.alert('��ʾ','����ʧ�ܣ�','warning');
		}
		InitPageInfo();		
	});
}

//���� lidong
function upclick(index)
{
	var newrow=parseInt(index)-1     
	var curr=$("#KnowList").datagrid('getData').rows[index];
	var currowid=curr.RowID;
	var currordnum=curr.Num;
	var up =$("#KnowList").datagrid('getData').rows[newrow];
	var uprowid=up.RowID;
	var upordnum=up.Num;

	var input=currowid+"^"+upordnum+"^"+uprowid+"^"+currordnum ;
	SaveUp(input);
	mysort(index, 'up', 'KnowList');
	
}
//����  lidong
function downclick(index)
{
	
	
	var newrow=parseInt(index)+1 ;
	var curr=$("#KnowList").datagrid('getData').rows[index];
	var currowid=curr.RowID;
	var currordnum=curr.Num;
	var down =$("#KnowList").datagrid('getData').rows[newrow];
	var downrowid=down.RowID;
	var downordnum=down.Num;

	var input=currowid+"^"+downordnum+"^"+downrowid+"^"+currordnum ;
	SaveUp(input);
	mysort(index, 'down', 'KnowList');
}
// lidong
function SaveUp(input,datas)
{
	runClassMethod("web.DHCCKBSourcePriority","UpdExpFieldNum",{"input":input},
	function(ret){
		$('#KnowList').datagrid('reload'); //���¼��� 
	},'text');
	 
}
// lidong
function mysort(index, type, gridname) {

    if ("up" == type) {

        if (index != 0) {
			var nextrow=parseInt(index)-1 ;
			var lastrow=parseInt(index);
            var toup = $('#' + gridname).datagrid('getData').rows[lastrow];
            var todown = $('#' + gridname).datagrid('getData').rows[index - 1];
            $('#' + gridname).datagrid('getData').rows[lastrow] = todown;
            $('#' + gridname).datagrid('getData').rows[nextrow] = toup;
            $('#' + gridname).datagrid('refreshRow', lastrow);
            $('#' + gridname).datagrid('refreshRow', nextrow);
            $('#' + gridname).datagrid('selectRow', nextrow);
        }
    } else if ("down" == type) {
        var rows = $('#' + gridname).datagrid('getRows').length;
        if (index != rows - 1) {
		    var nextrow=parseInt(index)+1 ;
			var lastrow=parseInt(index);
            var todown = $('#' + gridname).datagrid('getData').rows[lastrow];
            var toup = $('#' + gridname).datagrid('getData').rows[nextrow];
            $('#' + gridname).datagrid('getData').rows[nextrow] = todown;              
            $('#' + gridname).datagrid('getData').rows[lastrow] = toup;
            $('#' + gridname).datagrid('refreshRow', lastrow);
            $('#' + gridname).datagrid('refreshRow', nextrow);
            $('#' + gridname).datagrid('selectRow', nextrow);
        }
    }
}
/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
