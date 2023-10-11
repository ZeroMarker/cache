//var Columns=getCurColumnsInfo('Plat.G.TreeClass','','','');
var rowIndexToSave="";
$(function () {
		BodyLoadHandler();
		initDepartmentGrid();
		initDepartmentGridRight();
		initButtonWidth();//btn公共处理方法
		jQuery('#BDelete').on("click", BDelete_Clicked); 
		jQuery('#BFind').on("click", BFind_Clicked)
		jQuery('#BSave').on("click", BSave_Clicked);
		jQuery('#BLoc').on("click", BLoc_Clicked);
		jQuery('#BExport').on("click", BExport_Clicked); 
		
		//是否包含科室层级combobox初始化
		$HUI.combobox("#DeptLevel",{ 
		valueField:'id',
		textField:'text',
        panelHeight:"auto",
        data:[
        {id:'3',text:'全部'},
		{id:'1',text:'是'},
		{id:'2',text:'否'},	
		],
        editable:false,
        onLoadSuccess:function(){
		$('#DeptLevel').combobox('setValue','2'); //设置默认值
        }}
        
        )
})
function BodyLoadHandler()
{
	$("#treeviewarea").html("<ul id='tDHCEQCTreeMap' class='hisui-tree'></ul>")
	initTree()
}

//加载树
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
			NodeClickHandler(node);//传入树的子节点
			
		},
		lines:false,	//设置树的显示方式
	})
}

//切换树查看节点--中间表格
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

//中间表格展示--特殊处理
//需求要求中间表格在点击树或是在进行添加操作时刷新树，所以将子节点作为参数传入
//点击左侧科室级别树节点后，中间显示该节点的子节点列表(List)，
//列表上方有删除按钮，可以选中并点击删除没有子节点的科室树节点，
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
	        {field:'text',title:'科室名称',width:150},
	    ]],
	    toolbar:[{	// MZY0150	3124586,3124682,3124714		2023-01-29
                iconCls: 'icon-cancel',
                text:'删除',
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
//删除事件
function BDelete_Clicked()
{	
	var obj=$('#DHCEQTreeChildren');
	var node=obj.datagrid("getSelected");  //当前选中行
	if(node == null)  { $.messager.alert("简单提示", "请选中一行进行删除操作", 'info');  return}
	var TreeID=node.id
	var nodeChildren=node.children;
	if(nodeChildren)
	{$.messager.alert("简单提示", node.text+'节点包含子节点，请重新选择', 'info');	return }
	if(nodeChildren == undefined){
		$.messager.confirm('请确认', '您确定要删除所选的行？', function (b) { 
		if (b==false){return;}
    	else
    	{
			var jsonData=tkMakeServerCall("web.DHCEQ.Plat.LIBTree","SaveData",TreeID,"1");
			jsonData=JSON.parse(jsonData)
			console.log(jsonData,TreeID)
			if (jsonData.SQLCODE==0)
			{
			alertShow("删除成功");
			initTree()
			jQuery('#DHCEQTreeChildren').datagrid('loadData',{total:0,rows:[]}) //清空中间表格
			}
			else{
				alertShow("错误信息:"+jsonData.Data);
				return
			}
    	}       
  		})
	}
}
//右侧表格
function initDepartmentGridRight()
{	
	//var DeptLevel=$("#DeptLevel").combobox("getValue") //是否包含科室层级Value传入
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
	    	{field:'TCode',title:'科室代码',width:50,},
	        {field:'TDesc',title:'科室名称',width:50},
	        {field:'TParCode',title:'父科室代码',width:50},
	        {field:'TParDesc',title:'父科室名称',width:50},
	    ]],
	    
		pagination:true,
		pageSize:10,
		pageNumber:1,
		pageList:[10,20,30,40,50],
		onLoadSuccess:function(data){
       $(".datagrid-header-check").html("");//去除表头复选框
		},
		onSelect:function(rowIndex,rowData){ //单击选中，再点击不选中 begin
			
			
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

			}//单击选中，再点击不选中 end
	}); 
}
//定位功能
//在右侧列表选中一个有父节点的科室后，点击定位按钮后，左侧模块自动定位级别树，
//并且在中间模块显示该科室父节点下的所有科室。
function BLoc_Clicked()
{
	initTree();		// MZY0150	3124586,3124682,3124714		2023-01-29
	var rowData=$("#DHCEQCDepartment").datagrid("getSelected");//选中行
	if (rowData==undefined) { $.messager.alert("简单提示", "请先选中一个科室进行定位操作", 'info');return}
	var treeID=rowData.TRowID;//提取rowid
	var treeNode =$('#treeviewarea').tree('find',treeID);//查找科室级别树中id，关联树
	if (treeNode == null) {$.messager.alert("简单提示", "您选中的数据不在科室级别树中，请添加后重试", 'info');return}
	var expandToTree=$('#treeviewarea').tree('expandTo',treeNode.target);//展开树
	var treeDomli=$(treeNode.target)[0].parentNode;//获取li
	$(treeDomli).addClass("tree-node-selected");
	$(treeDomli).siblings().removeClass("tree-node-selected");//需要高亮处理
	var parDom=$('#treeviewarea').tree('getParent',treeNode.target);//获取父元素DOM元素
	initDepartmentGrid(parDom.children);//传入子节点
	
}


//默认显示所有未在级别树内的科室，可以查询loctype为科室的所有科室
//(查询条件，1.科室，2.父科室，3.是否存在科室层级(是,否,全部)   
//列：1.序号,2.科室代码，3.科室名称，4.父科室代码，5.父科室名称。列表上方有添加，定位两个按钮)
function BFind_Clicked()
{	
	var DeptLevel=$("#DeptLevel").combobox("getValue") //是否包含科室层级Value传入
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
	    	{field:'TCode',title:'科室代码',width:50,},
	        {field:'TDesc',title:'科室名称',width:50},
	        {field:'TParCode',title:'父科室代码',width:50},
	        {field:'TParDesc',title:'父科室名称',width:50},
	    ]],
	    
		pagination:true,
		pageSize:10,
		pageNumber:1,
		pageList:[10,20,30,40,50],});
		
}

//添加功能
//可以通过左侧级别树内点击节点作为父节点，右侧列表内选中一个科室，点击添加按钮，
//将该科室添加到级别树的该节点下。如果该科室存在父节点，进行弹窗提示确认。
function BSave_Clicked()
{
	if (checkMustItemNull()) return;
	var treeAsParNode=$('#treeviewarea').tree('getSelected');
	if (treeAsParNode == undefined)  { $.messager.alert("简单提示", "请选择左侧级别树内点击节点作为父节点", 'info');return}
	var data=$("#DHCEQCDepartment").datagrid("getSelected")//选中行
	if (data == undefined)  { $.messager.alert("简单提示", "请先选中一个科室进行添加操作", 'info');return}
	if(data.TParDesc !='') { $.messager.alert("简单提示", "该科室存在父节点，无法进行添加操作", 'info');return}
	data["TMTreeID"]=data.TRowID; //treeid赋值
	data["TMParTreeID"]=treeAsParNode.id//父节点treeid赋值
	//
	
	for(var key in data){
		if((key.toString().indexOf("TM") == -1)){ //过滤不包含'TM'字符得数据
			delete data[key]
			}
	}
	
	data["TMSourceType"]="CT_Loc";//固定值传入
	data["TMType"]="1";//固定值传入
	data=JSON.stringify(data);
    var jsonData=tkMakeServerCall("web.DHCEQ.Plat.LIBTree","SaveData",data,"0");
	jsonData=JSON.parse(jsonData)
	if ((jsonData.SQLCODE==0))
	{
		alertShow("保存成功");
		initTree()
		initDepartmentGridRight()
		jQuery('#DHCEQTreeChildren').datagrid('loadData',{total:0,rows:[]}) //清空中间表格
		$('#Dept').val("")//清空输入框
		$('#ParDept').val("")//清空输入框
		
	}
	else{
		alertShow("错误信息:"+jsonData.Data);
		return
	}
}
//导出功能
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
			messageShow('popover','alert','提示',"导出数据列未设置!")
			return ;
		}
		var url="dhccpmrunqianreport.csp?reportName=DHCEQDepartListExport.raq&CurTableName=Department&CurUserID="+session['LOGON.USERID']+"&CurGroupID="+session['LOGON.GROUPID']+"&Job="+TJob+"&Node=Department"+"&Date="+Date;
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
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
