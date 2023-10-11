//var Columns=getCurColumnsInfo('Plat.G.TreeClass','','','');
var rowIndexToSave="";
$(function () {
		BodyLoadHandler();
		initDepartmentGrid();
		initDepartmentGridRight();
		initButtonWidth();//btn����������
		jQuery('#BDelete').on("click", BDelete_Clicked); 
		jQuery('#BFind').on("click", BFind_Clicked)
		jQuery('#BSave').on("click", BSave_Clicked);
		jQuery('#BLoc').on("click", BLoc_Clicked);
		jQuery('#BExport').on("click", BExport_Clicked); 
		
		//�Ƿ�������Ҳ㼶combobox��ʼ��
		$HUI.combobox("#DeptLevel",{ 
		valueField:'id',
		textField:'text',
        panelHeight:"auto",
        data:[
        {id:'3',text:'ȫ��'},
		{id:'1',text:'��'},
		{id:'2',text:'��'},	
		],
        editable:false,
        onLoadSuccess:function(){
		$('#DeptLevel').combobox('setValue','2'); //����Ĭ��ֵ
        }}
        
        )
})
function BodyLoadHandler()
{
	$("#treeviewarea").html("<ul id='tDHCEQCTreeMap' class='hisui-tree'></ul>")
	initTree()
}

//������
function initTree()
{
	var EquipeCatTree =$.m({
		ClassName:"web.DHCEQ.Plat.LIBTree",
		MethodName:"GetTreeMapTreeStr",
		isShow:'0'
		},false)
	$('#treeviewarea').tree({
		data:JSON.parse(EquipeCatTree),
		onClick: function (node) {
			NodeClickHandler(node);//���������ӽڵ�
			
		},
		lines:false,	//����������ʾ��ʽ
	})
}

//�л����鿴�ڵ�--�м���
function NodeClickHandler(node)
{
	setElement("ParDept",node.text);	// MZY0150	3124586,3124682,3124714		2023-01-29
	var nodeChildren=node.children
	if(nodeChildren){
		$('#DHCEQTreeChildren').datagrid('loadData', { total: 0, rows: [] });
		initDepartmentGrid(nodeChildren);
	}
	var noNodeChildren=''
	if(nodeChildren==undefined){
		$('#DHCEQTreeChildren').datagrid('loadData', { total: 0, rows: [] });
		initDepartmentGrid(noNodeChildren);
	}
}

//�м���չʾ--���⴦��
//����Ҫ���м����ڵ���������ڽ�����Ӳ���ʱˢ���������Խ��ӽڵ���Ϊ��������
//��������Ҽ������ڵ���м���ʾ�ýڵ���ӽڵ��б�(List)��
//�б��Ϸ���ɾ����ť������ѡ�в����ɾ��û���ӽڵ�Ŀ������ڵ㣬
function initDepartmentGrid(nodeChildren)
{
	 $HUI.datagrid("#DHCEQTreeChildren",{
		border:false,
	    fit:true,
		fitColumns:true,
	    singleSelect:true,
	    rownumbers: true,
	    //multiple: true,
	    columns:[[
	    	{field:'id',title:'TRowID',width:50,hidden:true},
	        {field:'text',title:'��������',width:150},
	    ]],
	    toolbar:[{	// MZY0150	3124586,3124682,3124714		2023-01-29
                iconCls: 'icon-cancel',
                text:'ɾ��',
				id:'delete',
                handler: function(){
                     BDelete_Clicked();
                }
        }],
	    data:nodeChildren,
		pagination:true,
		pageSize:10,
		pageNumber:1,
		pageList:[10,20,30,40,50],
	}); 
}
//ɾ���¼�
function BDelete_Clicked()
{	
	var obj=$('#DHCEQTreeChildren');
	var node=obj.datagrid("getSelected");  //��ǰѡ����
	if(node == null)  { $.messager.alert("����ʾ", "��ѡ��һ�н���ɾ������", 'info');  return}
	var TreeID=node.id
	var nodeChildren=node.children;
	if(nodeChildren)
	{$.messager.alert("����ʾ", node.text+'�ڵ�����ӽڵ㣬������ѡ��', 'info');	return }
	if(nodeChildren == undefined){
		$.messager.confirm('��ȷ��', '��ȷ��Ҫɾ����ѡ���У�', function (b) { 
		if (b==false){return;}
    	else
    	{
			var jsonData=tkMakeServerCall("web.DHCEQ.Plat.LIBTree","SaveData",TreeID,"1");
			jsonData=JSON.parse(jsonData)
			console.log(jsonData,TreeID)
			if (jsonData.SQLCODE==0)
			{
			alertShow("ɾ���ɹ�");
			initTree()
			jQuery('#DHCEQTreeChildren').datagrid('loadData',{total:0,rows:[]}) //����м���
			}
			else{
				alertShow("������Ϣ:"+jsonData.Data);
				return
			}
    	}       
  		})
	}
}
//�Ҳ���
function initDepartmentGridRight()
{	
	//var DeptLevel=$("#DeptLevel").combobox("getValue") //�Ƿ�������Ҳ㼶Value����
	$HUI.datagrid("#DHCEQCDepartment",{
		url:$URL,
		queryParams:
		{ClassName:"web.DHCEQ.Plat.LIBTree",
		QueryName:"GetLocList",
		DeptLevel:"2",
		},
		border:false,
	    fit:true,
		fitColumns:true,
	    rownumbers: true,
	    singleSelect:true,
	    columns:[[
	    	{field:'TRowID',title:'TRowID',width:50,hidden:true},
	    	{field:'TCode',title:'���Ҵ���',width:50,},
	        {field:'TDesc',title:'��������',width:50},
	        {field:'TParCode',title:'�����Ҵ���',width:50},
	        {field:'TParDesc',title:'����������',width:50},
	    ]],
	    
		pagination:true,
		pageSize:10,
		pageNumber:1,
		pageList:[10,20,30,40,50],
		onLoadSuccess:function(data){
       $(".datagrid-header-check").html("");//ȥ����ͷ��ѡ��
		},
		onSelect:function(rowIndex,rowData){ //����ѡ�У��ٵ����ѡ�� begin
			
			
			if(rowIndexToSave!==""){
				//modify by cjc 20230220 begin
				if((rowIndexToSave !=rowIndex)){
					rowIndexToSave="";
					$('#Dept').val(rowData.TDesc)
				}else{
				rowIndexToSave="";
				$("#DHCEQCDepartment").datagrid("unselectRow",rowIndex);
				$('#Dept').val("")
				$('#ParDept').val("")

				}//modify by cjc 20230220 END
			}else{
				
				rowIndexToSave=rowIndex;
				$('#Dept').val(rowData.TDesc)
				$('#ParDept').val(rowData.TParDesc)
			}

			}//����ѡ�У��ٵ����ѡ�� end
	}); 
}
//��λ����
//���Ҳ��б�ѡ��һ���и��ڵ�Ŀ��Һ󣬵����λ��ť�����ģ���Զ���λ��������
//�������м�ģ����ʾ�ÿ��Ҹ��ڵ��µ����п��ҡ�
function BLoc_Clicked()
{
	initTree();		// MZY0150	3124586,3124682,3124714		2023-01-29
	var rowData=$("#DHCEQCDepartment").datagrid("getSelected");//ѡ����
	if (rowData==undefined) { $.messager.alert("����ʾ", "����ѡ��һ�����ҽ��ж�λ����", 'info');return}
	var treeID=rowData.TRowID;//��ȡrowid
	var treeNode =$('#treeviewarea').tree('find',treeID);//���ҿ��Ҽ�������id��������
	if (treeNode == null) {$.messager.alert("����ʾ", "��ѡ�е����ݲ��ڿ��Ҽ������У�����Ӻ�����", 'info');return}
	var expandToTree=$('#treeviewarea').tree('expandTo',treeNode.target);//չ����
	var treeDomli=$(treeNode.target)[0].parentNode;//��ȡli
	$(treeDomli).addClass("tree-node-selected");
	$(treeDomli).siblings().removeClass("tree-node-selected");//��Ҫ��������
	var parDom=$('#treeviewarea').tree('getParent',treeNode.target);//��ȡ��Ԫ��DOMԪ��
	initDepartmentGrid(parDom.children);//�����ӽڵ�
	
}


//Ĭ����ʾ����δ�ڼ������ڵĿ��ң����Բ�ѯloctypeΪ���ҵ����п���
//(��ѯ������1.���ң�2.�����ң�3.�Ƿ���ڿ��Ҳ㼶(��,��,ȫ��)   
//�У�1.���,2.���Ҵ��룬3.�������ƣ�4.�����Ҵ��룬5.���������ơ��б��Ϸ�����ӣ���λ������ť)
function BFind_Clicked()
{	
	var DeptLevel=$("#DeptLevel").combobox("getValue") //�Ƿ�������Ҳ㼶Value����
	$HUI.datagrid("#DHCEQCDepartment",{
		url:$URL,
		queryParams:
		{ClassName:"web.DHCEQ.Plat.LIBTree",
		QueryName:"GetLocList",
		isNode:'Y',
		Dept:getElementValue('Dept'),
		ParDept:getElementValue('ParDept'),
		DeptLevel:DeptLevel,
		},
		border:false,
	    fit:true,
		fitColumns:true,
	    rownumbers: true,
	    singleSelect:true,
	    columns:[[
	    	{field:'TRowID',title:'TRowID',width:50,hidden:true},
	    	{field:'TCode',title:'���Ҵ���',width:50,},
	        {field:'TDesc',title:'��������',width:50},
	        {field:'TParCode',title:'�����Ҵ���',width:50},
	        {field:'TParDesc',title:'����������',width:50},
	    ]],
	    
		pagination:true,
		pageSize:10,
		pageNumber:1,
		pageList:[10,20,30,40,50],});
		
}

//��ӹ���
//����ͨ����༶�����ڵ���ڵ���Ϊ���ڵ㣬�Ҳ��б���ѡ��һ�����ң������Ӱ�ť��
//���ÿ�����ӵ��������ĸýڵ��¡�����ÿ��Ҵ��ڸ��ڵ㣬���е�����ʾȷ�ϡ�
function BSave_Clicked()
{
	if (checkMustItemNull()) return;
	var treeAsParNode=$('#treeviewarea').tree('getSelected');
	if (treeAsParNode == undefined)  { $.messager.alert("����ʾ", "��ѡ����༶�����ڵ���ڵ���Ϊ���ڵ�", 'info');return}
	var data=$("#DHCEQCDepartment").datagrid("getSelected")//ѡ����
	if (data == undefined)  { $.messager.alert("����ʾ", "����ѡ��һ�����ҽ�����Ӳ���", 'info');return}
	if(data.TParDesc !='') { $.messager.alert("����ʾ", "�ÿ��Ҵ��ڸ��ڵ㣬�޷�������Ӳ���", 'info');return}
	data["TMTreeID"]=data.TRowID; //treeid��ֵ
	data["TMParTreeID"]=treeAsParNode.id//���ڵ�treeid��ֵ
	//
	
	for(var key in data){
		if((key.toString().indexOf("TM") == -1)){ //���˲�����'TM'�ַ�������
			delete data[key]
			}
	}
	
	data["TMSourceType"]="CT_Loc";//�̶�ֵ����
	data["TMType"]="1";//�̶�ֵ����
	data=JSON.stringify(data);
    var jsonData=tkMakeServerCall("web.DHCEQ.Plat.LIBTree","SaveData",data,"0");
	jsonData=JSON.parse(jsonData)
	if ((jsonData.SQLCODE==0))
	{
		alertShow("����ɹ�");
		initTree()
		initDepartmentGridRight()
		jQuery('#DHCEQTreeChildren').datagrid('loadData',{total:0,rows:[]}) //����м���
		$('#Dept').val("")//��������
		$('#ParDept').val("")//��������
		
	}
	else{
		alertShow("������Ϣ:"+jsonData.Data);
		return
	}
}
//��������
function BExport_Clicked()
{	var Date=getElementValue('Date')
	var ObjTJob=$('#DHCEQCDepartment').datagrid('getData');
	if (ObjTJob.rows[0]["TJob"])  var TJob=ObjTJob.rows[0]["TJob"];
	if (TJob=="")  return;
	
	var PrintFlag=tkMakeServerCall("web.DHCEQCommon","GetSysInfo",'990062');
	if (PrintFlag=="1")
	{	
		if (!CheckColset("Department"))
		{
			messageShow('popover','alert','��ʾ',"����������δ����!")
			return ;
		}
		var url="dhccpmrunqianreport.csp?reportName=DHCEQDepartListExport.raq&CurTableName=Department&CurUserID="+session['LOGON.USERID']+"&CurGroupID="+session['LOGON.GROUPID']+"&Job="+TJob+"&Node=Department"+"&Date="+Date;
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
			str += "&MWToken="+websys_getMWToken()
		}
    	window.open(url,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0');
	}
		else
	{
		PrintDHCEQEquipNew("Department",1,TJob,getElementValue("vData"))
	}
	return
	
}
