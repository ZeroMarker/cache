//zhouxin 2016-04-19
var HospID=""
$(function(){ 
	var hospStr=session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']
	var hospComp = GenHospComp("Doc_APP_Otheropt",hospStr);
	hospComp.jdata.options.onSelect   = function(){
		HospID=$HUI.combogrid('#_HospList').getValue();
		$('#datagrid').datagrid('load',{AOCode:"",AODesc:"",HospId:HospID}); 
		} 
	//ѡ���ϼ���λ
	$('#datagrid').datagrid({    
		 onClickRow:function(rowIndex, rowData){
	            $("#AOIOptParRef").val(rowData.ID);
	            
	            Initsubdatagrid(rowData.AOType) 
				
				 setTimeout(function(){
					 $('#subdatagrid').datagrid('load', {    
					    AOIOptParRef: rowData.ID  
					});
					 },500)
         },onBeforeEdit:function(rowIndex,rowData){
	         setTimeout(function(){reLoadReq();},200)
	     }
	});
	HospID=$HUI.combogrid('#_HospList').getValue();
	$('#datagrid').datagrid('load',{AOCode:"",AODesc:"",HospId:HospID}); 
	Initsubdatagrid("Check");
});

//����commonQuery �� commonReload ˵��
//<a class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true" onclick="javascript:commonQuery({'datagrid':'#datagrid','formid':'#queryForm'})">��ѯ</a> 

//������ʾ��csp�и���ťע�� �����¼�
//commonQuery �� commonReload ����ζ��� json�ַ���,��ʽΪ {'datagrid':'#datagrid','formid':'#queryForm'}
// ����datagrid ��datagrid��id
 // formid ��<form>��id �����form�����������в�ѯ�����ĸ����������в�ѯ�����������������������
 // <input type="text" name="AOCode" class="textParent"></input>
 //���в�ѯ������Ӧ����name���ԣ���������Ժͺ�̨����������ͬ
 // ���������������������commonQuery({'datagrid':'#datagrid','formid':'#queryForm'})
 // ���#queryForm ��������б�Ԫ���ύ��datagrid ����ĺ�̨�෽���������෽����������ͱ�Ԫ�ص�nameһֱ
 //  commonReload ����ͬ commonQuery ,ֻ��������ղ�ѯ��������

//������λ�ֵ�����һ��
//commonAddRow ����˵��
//��һ������ datagrid ����Ҫ����һ�е�datagrid��id
//�ڶ������� value �������и���ʼֵ
//���û����Ҫ��ʼ��ֵ���Բ����ڶ�������
function addRow(){
	commonAddRow({'datagrid':'#datagrid',value:{'AORequired':'Y','AOType':'Input'}})
}
//������λ�ֵ�˫���༭
//������������˫����datagrid��id����
function onClickRow(index,row){
	CommonRowClick(index,row,"#datagrid");
}
//������λ����
//"web.DHCAPPOtherOpt" ����
//"save"   			  ������
//"#datagrid"          Ҫ�����datagrid��id
// �˷����Զ���datagrid�еı༭�Ĵ���������ݴ����̨
// һ������֮���� "^" �ָ�
// ��������֮���� "$$" �ָ�
// �ύ ����̨�Ĳ������� params
// ���ĸ������Ǻ�ִ̨����Ļص�����

function save(){
	saveByDataGridNew("web.DHCAPPOtherOpt","save","#datagrid",function(data){
			if(data==0){
				$.messager.alert('��ʾ','����ɹ�')			
			}else if(data==-10){
				$.messager.alert('��ʾ','�����ظ�')	
			}else{
				$.messager.alert('��ʾ','����ʧ��:'+data)
			}
			$("#datagrid").datagrid('reload')
		});	
}
function saveByDataGridNew(className,methodName,gridid,handle,datatype){
	if(!endEditing(gridid)){
		$.messager.alert("��ʾ","��༭��������!");
		return;
	}
	var rowsData = $(gridid).datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		var rowData=[];
		var fileds=$(gridid).datagrid('getColumnFields')
		for(var j=0;j<fileds.length;j++){
			rowData.push(typeof(rowsData[i][fileds[j]]) == "undefined"?0:rowsData[i][fileds[j]])
		}
		dataList.push(rowData.join("^"));
	} 
	var params=dataList.join("$$");
	//alert(params)
	var HospID=$HUI.combogrid('#_HospList').getValue();
	runClassMethod(className,methodName,{'params':params,HospID:HospID},handle,datatype)
}
function addRowSub(){
	if($("#AOIOptParRef").val() == ""){
		$.messager.alert('��ʾ','����ѡ��������Ŀ�ֵ�')
		return;
	}
	commonAddRow({'datagrid':'#subdatagrid',value:{AOIOptParRef:$("#AOIOptParRef").val()}})
	subdataEditRow = 0;
}
function onClickRowSub(index,row){
	CommonRowClick(index,row,"#subdatagrid");
	subdataEditRow=index
}
function saveSub(){
	saveByDataGrid("web.DHCAPPOtherOpt","saveSub","#subdatagrid",function(data){
		if(data == 0){     //qunianpeng 2016-07-15
			$.messager.alert('��ʾ','��ӳɹ�');
		}else if(data == -10){
			$.messager.alert('��ʾ','���벻���ظ�');
		}else{
			$.messager.alert('��ʾ','���ʧ��:'+data);
		}		
		$("#subdatagrid").datagrid('reload');
	});	

}

function cancelSub(){
	
	if ($("#subdatagrid").datagrid('getSelections').length != 1) {
		$.messager.alert('��ʾ','��ѡһ��ɾ��');
		return;
	}
	$.messager.confirm('ȷ��','��ȷ����Ҫɾ����¼��',function(r){    
    if (r){
	    var row =$("#subdatagrid").datagrid('getSelected');     
		 runClassMethod("web.DHCAPPOtherOpt","removeSub",{'Id':row.ID},function(data){ $('#subdatagrid').datagrid('load'); })
    }    
}); 
}

function cancel(){
	
	if ($("#datagrid").datagrid('getSelections').length != 1) {
		$.messager.alert('��ʾ','��ѡһ��ɾ��');
		return;
	}
	$.messager.confirm('ȷ��','��ȷ����Ҫɾ����¼��',function(r){    
    if (r){
	    var row =$("#datagrid").datagrid('getSelected');     
		 runClassMethod("web.DHCAPPOtherOpt","remove",{'Id':row.ID},function(data){
			  if(data==1){     //lvpeng  2016/7/13
				$.messager.alert("��ʾ��","�����ѱ����ã��޷�ɾ��");	 
			 }else{
				$.messager.alert("��ʾ��","ɾ���ɹ�");	 
		     }
			  $('#datagrid').datagrid('load'); })
    }    
}); 
}

///sufan ������commonQuery,commonReload����
function commonQuery()
{
	var code=$("#code").val();
	var desc=$("#desc").val();
	var HospID=$HUI.combogrid('#_HospList').getValue();
	$('#datagrid').datagrid('load',{AOCode:code,AODesc:desc,HospId:HospID}); 
}

function commonReload()
{
	$("#code").val("");
	$("#desc").val("");
	commonQuery();
}

/// ����ѡ���������á��Ƿ��������б�
function reLoadReq(){
	
	var ed=$("#datagrid").datagrid('getEditor',{index:editIndex,field:'AOType'});
	if ($(ed.target).combobox("getValue")== "Check"){
		var ed=$("#datagrid").datagrid('getEditor',{index:editIndex,field:'AORequired'});
		$(ed.target).combobox("clear");
		$(ed.target).combobox("loadData",[{"value":"N","text":'��'}]);
		$(ed.target).combobox('setValue',"N");
	}else{
		var ed=$("#datagrid").datagrid('getEditor',{index:editIndex,field:'AORequired'});
		$(ed.target).combobox("loadData",[{"value":"N","text":'��'},{"value":"Y","text":'��'}]);
	}
	
}
var subdataEditRow=""
function Initsubdatagrid(Type){
	if (Type=="Order"){
		 var Columns=[[   
			{ field: 'AOIOptParRef', title: 'AOIOptParRef', width: 10,hidden:true },
			{ field: 'ID', title: 'ID', width: 10,hidden:true },
			{ field: 'ARCIMDesc', title: 'ҽ������', width: 20,
            	editor:{
              		type:'combogrid',
                    options:{
	                    enterNullValueClear:false,
						required: true,
						panelWidth:450,
						panelHeight:350,
						delay:500,
						idField:'ArcimRowID',
						textField:'ArcimDesc',
						value:'',//ȱʡֵ 
						mode:'remote',
						pagination : true,//�Ƿ��ҳ   
						rownumbers:true,//���   
						collapsible:false,//�Ƿ���۵���   
						fit: true,//�Զ���С   
						pageSize: 10,//ÿҳ��ʾ�ļ�¼������Ĭ��Ϊ10   
						pageList: [10],//��������ÿҳ��¼�������б�  
						url:$URL+"?ClassName=DHCDoc.DHCDocConfig.ArcItemConfig&QueryName=FindAllItem",
                        columns:[[
                            {field:'ArcimDesc',title:'����',width:310,sortable:true},
			                {field:'ArcimRowID',title:'ID',width:100,sortable:true},
			                {field:'selected',title:'ID',width:120,sortable:true,hidden:true}
                         ]],
						onSelect: function (rowIndex, rowData){
							var rows=$('#subdatagrid').datagrid("selectRow",subdataEditRow).datagrid("getSelected");
							rows.ARCIMRowid=rowData.ArcimRowID
						},
						onClickRow: function (rowIndex, rowData){
							var rows=$('#subdatagrid').datagrid("selectRow",subdataEditRow).datagrid("getSelected");
							rows.ARCIMRowid=rowData.ArcimRowID
						},
						onLoadSuccess:function(data){
							$(this).next('span').find('input').focus();
						},
						onBeforeLoad:function(param){
							if (param['q']) {
								var desc=param['q'];
							}
							param = $.extend(param,{Alias:desc,HospId:$HUI.combogrid('#_HospList').getValue()});
						}
            		}
    			  }
			},
			{ field: 'Number', title: '����', width: 20,editor : {type : 'text',options : {}}},
			{ field: 'ARCIMRowid', title: 'ARCIMRowid', width: 10,hidden:true }
			
		 ]];
		}else{
		var Columns=[[   
			{ field: 'AOIOptParRef', title: 'AOIOptParRef', width: 10,hidden:true },
			{ field: 'ID', title: 'ID', width: 10,hidden:true },
			{ field: 'AOICode', title: '����', width: 50,editor : {type : 'text',options : {required:true}}},
			{ field: 'AOIDesc', title: '����', width: 150,editor : {type : 'text',options : {required:true}}
			}
		 ]];
		}
		$('#subdatagrid').datagrid({  
			headerCls:'panel-header-gray',
			iconCls:'icon-paper',
			title:"������Ŀ����ά��",
			toolbar:'#subtoolbar',
			columns :Columns,
		    rownumbers:true,
		    method:'get',
		    fitColumns:true,
		    singleSelect:true,
		    pagination:true,
		    nowrap: false,
		    onDblClickRow:onClickRowSub,
			url:'dhcapp.broker.csp?ClassName=web.DHCAPPOtherOpt&MethodName=listSub',
			onClickRow:function(rowIndex, rowData){
			}
	});
	}
