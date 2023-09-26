/// Creator: congyue
/// CreateDate: 2016-03-24
//  Descript: ҽ�Ʋ����¼��������

var editRow=""; //��ǰ�༭�к�
var url="dhcadv.repaction.csp";
var Active = [{"value":"Y","text":'��'}, {"value":"N","text":'��'}];
var Levelrowid="";
var level=0,parentid="";
$(function(){
	var params="";
 	$('#tree').tree({
	 	type: 'get',
		url: url+"?action=QueryMrcInfo&params"+params,
		loadFilter: function(MrcInfo){
				var data=eval(MrcInfo);
				var json=GetJson(data,Levelrowid);
				return json;
		},
	 	onClick: function(node){
			level=node.Level;
			level++;
			parentid=node.ID;
			ChildrenInfo(parentid);
			/* $('#mrcdg').datagrid({
				url:url+'?action=QueryMedRepCat',	
				queryParams:{
					params:parentid
				}
			
			});	 */
		},
		onLoadSuccess:function(node){
			
				var node=$('#tree').tree('getRoot');
				parentid=node.ID;
				level=node.Level;
				level++;
				$('#tree').tree('select', node.target);
			
			ChildrenInfo(parentid);
			/* $('#mrcdg').datagrid({
				url:url+'?action=QueryMedRepCat',	
				queryParams:{
					params:parentid
				}
			
			}); */
			}
	 
 	});
	
InitMedRepCat();
});

function GetJson(data,Levelrowid){
    var result = [] , temp;//����temp�м����
    for(var i in data){
        if(data[i].Levelrowid==Levelrowid){
            result.push(data[i]);
            temp = GetJson(data,data[i].ID); // ����temp          
            if(temp.length>0){
                data[i].children=temp; //��data[i]���children���Բ���ֵ
            }           
        }       
    }
    return result;
}

function ChildrenInfo()
{
	$('#mrcdg').datagrid({
				url:url+'?action=QueryMedRepCat',	
				queryParams:{
					params:parentid
				}
			
			});
}



// �༭��
var texteditor={
	type: 'validatebox',//���ñ༭��ʽ
	options: {
		required: true //���ñ༭��������
	}
}

function InitMedRepCat()
{
		
	//�Ƿ���ñ�־
	var activeEditor={  //������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
		options: {
			data:Active,
			valueField: "value", 
			textField: "text",
			required:true,
			panelHeight:"auto"  //���������߶��Զ�����
			
		}
	}

	// ����columns
	var columns=[[
		{field:'Code',title:'����',width:150,editor:texteditor},
		{field:"Desc",title:'����',width:150,editor:texteditor},
		{field:'Level',title:'����',width:50,hidden:false},
		{field:"Levelrowid",title:'��һ�����rowid',width:100,hidden:false},
		{field:'Active',title:'�Ƿ����',width:60,formatter:formatLink,editor:activeEditor},
		{field:"ID",title:'ID',width:50,align:'center',hidden:false}
	]];
	
	// ����datagrid
	$('#mrcdg').datagrid({
		title:'ҽ�Ʋ����¼��������',
		url:'',
		fit:true,
		rownumbers:true,
		columns:columns,
		order:'asc',
		pageSize:40,        // ÿҳ��ʾ�ļ�¼����
		pageList:[40,80],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true,
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
			if ((editRow != "")||(editRow == "0")) {
            	 $("#mrcdg").datagrid('endEdit', editRow); 
			}            
            $("#mrcdg").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex; 
        }
       
	});
	$('#mrcdg').datagrid({
		url:url+'?action=QueryMedRepCat',	
		queryParams:{
			params:Levelrowid}
			
	});	
	
initScroll("#mrcdg");//��ʼ����ʾ���������
	
	//��ť���¼�
    $('#insmrc').bind('click',insmrcRow); 
    $('#delmrc').bind('click',delmrcRow);
    $('#savmrc').bind('click',savmrcRow);
	

}
// ��������
function insmrcRow()
{
	if( editRow>="0"){
		$("#mrcdg").datagrid('endEdit',  editRow);//�����༭������֮ǰ�༭����
	}
	
	var rows = $("#mrcdg").datagrid('getChanges');
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].Code=="")||(rows[i].Desc=="")){
			$.messager.alert("��ʾ","�������������Ϊ��!"); 
			return false;
		}
	} 
	
	$("#mrcdg").datagrid('insertRow', {//��ָ����������ݣ�appendRow�������һ���������
		index: 0, // ������0��ʼ����
		row: {ID: '',Code:'',Desc: '',Level:level,Levelrowid: parentid,Active: 'Y'}
	});
	$("#mrcdg").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	 editRow=0;
}

// ɾ��ѡ����
function delmrcRow()
{
	var rows = $("#mrcdg").datagrid('getSelections'); //ѡ��Ҫɾ������
	if (rows.length > 0) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				$.post(url+'?action=DelMedRepCat',{"params":rows[0].ID}, function(data){
                    if(data==0){
						$.messager.alert('��ʾ','ɾ���ɹ�');	
					}else if((data == -1)||(data == -2)){
						$.messager.alert('��ʾ','�����ݴ���ʹ����Ϣ������ɾ��');	
					}else{
						$.messager.alert('��ʾ','ɾ��ʧ��');
					}


					$('#mrcdg').datagrid('reload'); //���¼���
					$('#tree').tree('reload'); //���¼���
				});
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}

// ����༭��
function savmrcRow()
{
	if( editRow>="0"){
		$("#mrcdg").datagrid('endEdit',  editRow);
	}
	var rows = $("#mrcdg").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].Code=="")||(rows[i].Desc=="")){
			$.messager.alert("��ʾ","�������������Ϊ��!"); 
			return false;
		}
		var tmp=rows[i].ID+"^"+rows[i].Code+"^"+rows[i].Desc+"^"+rows[i].Level+"^"+rows[i].Levelrowid+"^"+rows[i].Active;
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("&&");
	//��������
	$.post(url+'?action=SaveMedRepCat',{"params":rowstr},function(data){
		if(data==0){
			$.messager.alert('��ʾ','�����ɹ�');
		}else if ((data == -1)||((data == -2))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ������','warning');
			//return;	//2017-03-17 ����ʧ�ܣ�ˢ���ֵ��
		}else {
			$.messager.alert('��ʾ','����ʧ��','warning');
			//return;	//2017-03-17 ����ʧ�ܣ�ˢ���ֵ��
		}
		$('#mrcdg').datagrid('reload'); //���¼���
		$('#tree').tree('reload'); //���¼���
	});
}
 
//YNת���Ƿ�
function formatLink(value,row,index){
	if (value=='Y'){
		return '��';
	} else {
		return '��';
	}
}
