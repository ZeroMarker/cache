var AddAttrCode="JobData";
var LifeCycleData="LifeCycleData";
var IP=ClientIPAdd
var editRow=0,editsubRow=0;editsubRow2=0;editsubRow3=0;
var ActiveArray = [{"value":"��","text":'��'}, {"value":"��","text":'��'}];
/// ҳ���ʼ������
function initPageDefault(){
	//InitButton();		// ��ť��Ӧ�¼���ʼ��
	InitDataList();		// ҳ��DataGrid��ʼ������
	InitButton();
	InitDataJurisdiction();
	InitDatalife();
}
	

/// ҳ��DataGrid��ʼ����ͨ��������λ�ֵ����ƣ�
function InitDataList(){
						
	// �༭��
	var texteditor={
		type: 'text',//���ñ༭��ʽ
		options: {
			required: false //���ñ༭��������
		}
	}
	
	/*// ְ��
	var Roleeditor={type:'combobox',
				  	 options:{
						valueField:'value',
						textField:'text',
						mode:'remote',
						enterNullValueClear:false,
						blurValidValue:true,
						onSelect:function(option) {
							var ed=$("#diclist").datagrid('getEditor',{index:editsubRow,field:'post'});
							$(ed.target).combobox('setValue', option.text);
							var ed=$("#diclist").datagrid('getEditor',{index:editsubRow,field:'postID'});
							$(ed.target).val(option.value);
						},
				  		onShowPanel:function(){
							var ed=$("#diclist").datagrid('getEditor',{index:editsubRow,field:'post'}) ;
							var unitUrl=$URL+"?ClassName=web.DHCCKBPosLifeCycle&MethodName=QueryValue&AddAttrCode="+AddAttrCode;
							$(ed.target).combobox('reload',unitUrl) ;
				    	}	  
					}
	}*/
	
	// ����columns
	var columns=[[   
			{field:'ID',title:'ID',width:80,hidden:true},
			{field:'postID',title:'��λID',width:80,editor:texteditor,hidden:true},
			{field:'encoded',title:'����',width:80,hidden:false,editor:texteditor},
			{field:'post',title:'��λ',width:80,hidden:false,editor:texteditor},
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
 		onClickRow:function(rowIndex,rowData){ 	
            InitDatalife()
		}, 
		onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
      		if (editsubRow != ""||editsubRow == 0) { 
                $("#diclist").datagrid('endEdit', editsubRow); 
            } 
            $("#diclist").datagrid('beginEdit', rowIndex); 
            editsubRow = rowIndex;
        },
		  
	}
	var uniturl = $URL+"?ClassName=web.DHCCKBPosLifeCycle&MethodName=Queryposlifecycle&AddAttrCode="+AddAttrCode;
	new ListComponent('diclist', columns, uniturl, option).Init();
	
}

///��ʼ������б�
function InitDataJurisdiction(){
	// ����columns
	var columns=[[  
			{field:'code',title:'������',width:80,hidden:true},
			{field:'type',title:'���',width:80,hidden:false}
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
		toolbar:[],
		pageList:[30,60,90],		
 		onClickRow:function(rowIndex,rowData){ 
		  if (editsubRow2 != ""||editsubRow2 == 0) { 
                $("#predictList").datagrid('endEdit', editsubRow2); 
            } 
            $("#predictList").datagrid('beginEdit', rowIndex); 
            
            editsubRow2 = rowIndex;
            InitDatalife(); 
		}, 
		onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
          
        },
		  
	}
	var uniturl = $URL+"?ClassName=web.DHCCKBPosLifeCycle&MethodName=Querylist";
	new ListComponent('predictList', columns, uniturl, option).Init();
	
	
	
	}

///��ʼ�����������б�
function InitDatalife(){
	
	// �༭��
	var texteditor={
		type: 'text',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}
	// �Ƿ���Ȩ
	var Roleeditornew={type:'combobox',
	  	 options:{
		  	data:ActiveArray,
			valueField:'value',
			textField:'text',
			mode:'remote',
			enterNullValueClear:false,
			blurValidValue:true,
			onSelect:function(option) {
				var ed=$("#tabooListnew").datagrid('getEditor',{index:editsubRow3,field:'authorization'});
				$(ed.target).combobox('setValue', option.value);  //����Desc
			},
	  		onShowPanel:function(){
				
	    	}	  
		}
	}
		
// ����columns
	var columns=[[ 
			{field:'id',title:'rowid',hidden:true},
			{field:'num',title:'˳���',width:80,hidden:true},
			{field:'Result',title:'˳���',width:80,hidden:true},
			{field:'lifecycle',title:'�������ڽڵ�',width:250,hidden:false},
			{field:'authorization',title:'�Ƿ���Ȩ',width:300,hidden:false,editor:Roleeditornew},
			{field:'order',title:'˳��',width:350,formatter:function(value,rec,index){
			var a = '<a href="#" class="icon icon-up" style="color:#000;display:inline-block;width:16px;height:16px" mce_href="#" onclick="upclick(\''+ index + '\')"></a> ';
			var b = '<a href="#" class="icon icon-down" style="color:#000;display:inline-block;width:16px;height:16px" mce_href="#" onclick="downclick(\''+ index + '\')"></a> ';
			return a+b;  
        		}  ,hidden:false},
        	{field:'code',title:'code',width:80,hidden:true} 
		 ]]
	var option={	
		bordr:false,
		fit:true,
		fitColumns:false,
		singleSelect:true,	
		nowrap: false,
		striped: true, 
		pagination:true,
		rownumbers:true,
		toolbar:[],
		pageSize:30,
		pageList:[30,60,90],		
 		onClickRow:function(rowIndex,rowData){ 
		   
		}, 
		onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
          if (editsubRow3 != ""||editsubRow3 == 0) { 
                $("#tabooListnew").datagrid('endEdit', editsubRow3); 
            } 
            $("#tabooListnew").datagrid('beginEdit', rowIndex); 
            
            editsubRow3 = rowIndex; 
        },
		  
	}
	var rowsData = $("#diclist").datagrid("getSelected");
	var rowData = $("#predictList").datagrid("getSelected");
	var id =""
	if(rowsData!=null){
		var id=rowsData.ID
		
		}
	var type=""
	if(rowData!=null){
		var type=rowData.code
		
		}
	var param=id+"^"+LifeCycleData+"^"+type
	var uniturl = $URL+"?ClassName=web.DHCCKBPosLifeCycle&MethodName=QuerylifeValue&param="+param;
	new ListComponent('tabooListnew', columns, uniturl, option).Init();	
}


/// ��ť��Ӧ�¼���ʼ��
function InitButton(){
	
	$("#insert").bind("click",InsertRow);	        // ���Ӹ�λ
	$("#savedata").bind("click",saveRow);		// �����޸ĸ�λ
	$("#delete").bind("click",DeleteRow);	// ��λɾ��
	$("#savedatabt").bind("click",saveRowbt);		// ��Ȩ�����޸�
	$("#deletebt").bind("click",DeleteRowbt);	// ȡ����Ȩ
}

// ���Ӹ�λ
function InsertRow(){
	//debugger;
	if(editsubRow>="0"){
		$("#diclist").datagrid('endEdit', editsubRow);		//�����༭������֮ǰ�༭����
	}
	$("#diclist").datagrid('insertRow', {
		index: 0, // ������0��ʼ����
		/* row: {ID:'', Code:'', Desc:'',Type:"",TypeDr:""} */
		row: {}
	});
	$("#diclist").datagrid('beginEdit', 0);				//�����༭������Ҫ�༭����
	editsubRow=0;
}

/// �����޸ĸ�λ
function saveRow(){
	
	if(editsubRow>="0"){
		$("#diclist").datagrid('endEdit', editsubRow);
	}

	var rowsData = $("#diclist").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!","info");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if((rowsData[i].encoded=="")||(rowsData[i].post=="")){
			$.messager.alert("��ʾ","������λ����Ϊ��!","info"); 
			return false;
		}
	
		var tmp=($g(rowsData[i].ID)) +"^"+ ($g(rowsData[i].encoded)) +"^"+ ($g(rowsData[i].post)) +"^"+AddAttrCode 
		dataList.push(tmp);
	} 
	var params=dataList.join("&&");
	var attrData = "";
	
	//�������� 
	runClassMethod("web.DHCCKBPosLifeCycle","SaveUpdatenew",{"params":params},function(jsonString){
		
		if (jsonString >= 0){
			$.messager.alert('��ʾ','����ɹ���','info');
			$('#diclist').datagrid('reload'); //���¼���
		}else if(jsonString == -100){
			$.messager.alert('��ʾ','����ʧ��,����͸�λ�ظ�','warning');
			
		}else if(jsonString == -99){
			$.messager.alert('��ʾ','����ʧ��,������λ����Ϊ�գ�','warning');

		}else{
			$.messager.alert('��ʾ','����ʧ�ܣ�','warning');
		}
	});
}

/// ��Ȩ�����޸�
function saveRowbt(){
	
	if(editsubRow>="0"){
		$("#tabooListnew").datagrid('endEdit', editsubRow3);
	}

	var rowsData = $("#diclist").datagrid("getSelected");
	var rowData = $("#predictList").datagrid("getSelected");
	var rowDatanew = $("#tabooListnew").datagrid("getSelected");
	var rowDatanewnoe = $("#tabooListnew").datagrid('getChanges');

	if(rowDatanewnoe.length<=0){
		$.messager.alert("��ʾ","û�д���������!","info");
		return;
	}
	if(rowData==null){
		$.messager.alert("��ʾ","��ѡ��Ȩ�����!","info");
		return;
		}

	var dataList = [];
	for(var i=0;i<rowDatanewnoe.length;i++){
		
		var tmp=rowsData.ID  +"^"+rowData.code  +"^"+ $g(rowDatanewnoe[i].authorization)+"^"+$g(rowDatanewnoe[i].lifecycle)
		dataList.push(tmp);
	}
	var params=dataList.join("&&");
	
	//��������
	runClassMethod("web.DHCCKBPosLifeCycle","SaveUpdate",{"params":params},function(jsonString){
		if (jsonString >= 0){
			$.messager.alert('��ʾ','����ɹ���','info');
		}else if(jsonString == -99){
			$.messager.alert('��ʾ','����ʧ��,�Ѵ��ڸ�������','warning');
		}else if(jsonString == -100){
			$.messager.alert('��ʾ','����ʧ��,û�д���������','warning');
		}else{
			$.messager.alert('��ʾ','����ʧ�ܣ�','warning');
		}
		//InitPageInfo();		
		$('#tabooListnew').datagrid('reload'); //���¼���
	});
}



/// ��λɾ��
function DeleteRow(){
	 
	var rowsData = $("#diclist").datagrid('getSelected'); 						// ѡ��Ҫɾ������
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {	// ��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCCKBPosLifeCycle","DeleteDic",{"RowID":rowsData.ID},function(jsonString){
					if (jsonString == 0){
						$('#diclist').datagrid('reload'); //���¼���
					}else{
						 $.messager.alert('��ʾ','ɾ��ʧ��.ʧ�ܴ���'+jsonString,'warning');
					}					
				})
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}
//ȡ����Ȩ
function DeleteRowbt(){
	
	var rowsDatanew = $("#diclist").datagrid("getSelected");
	var rowData = $("#predictList").datagrid("getSelected");  
	var rowsData = $("#tabooListnew").datagrid('getSelected'); 						// ѡ��Ҫɾ������
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {	// ��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCCKBPosLifeCycle","DeleteDicnew",{"RowID":rowsDatanew.ID,"type":rowData.code,"authorization":rowsData.authorization,"lifecycle":rowsData.lifecycle},function(jsonString){
					if (jsonString == 0){
						$('#tabooListnew').datagrid('reload'); //���¼���
					}else{
						 $.messager.alert('��ʾ','ɾ��ʧ��.ʧ�ܴ���'+jsonString,'warning');
					}					
				})
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}

//���� 
function upclick(index)
{
	
	
	var newrow=parseInt(index)-1     
	var curr=$("#tabooListnew").datagrid('getData').rows[index];
	var currowid=curr.id;
	var currordnum=curr.Result;
	var up =$("#tabooListnew").datagrid('getData').rows[newrow];
	var uprowid=up.id;
	var upordnum=up.Result;

	var input=currowid+"^"+upordnum+"^"+uprowid+"^"+currordnum ;
	SaveUp(input);
	mysort(index, 'up', 'tabooListnew');
	
}
//����  
function downclick(index)
{
	
	
	var newrow=parseInt(index)+1 ;
	var curr=$("#tabooListnew").datagrid('getData').rows[index];
	var currowid=curr.id;
	var currordnum=curr.Result;
	var down =$("#tabooListnew").datagrid('getData').rows[newrow];
	var downrowid=down.id;
	var downordnum=down.Result;

	var input=currowid+"^"+downordnum+"^"+downrowid+"^"+currordnum ;
	SaveUp(input);
	mysort(index, 'down', 'tabooListnew');
}

function SaveUp(input,datas)
{
	runClassMethod("web.DHCCKBPosLifeCycle","UpdExpFieldNum",{"input":input},
	function(ret){
		$('#tabooListnew').datagrid('reload'); //���¼��� 
	},'text');
	 
}

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
