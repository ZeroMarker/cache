
//名称	DHCPETeamCopy.hisui.js
//功能	复制分组
//创建	2020.12.22
//创建人  xy

$(function(){

	InitCombobox();
	
	InitCopyTeamDataGrid();
	
	InitCopyTeamItemDataGrid();
		
	//查询
	$("#BFind").click(function() {	
		BFind_Click();		
        });
        
        
       //复制
	$("#BCopyTeam").click(function() {	
		BModifyRoom_Click();		
        });

	
})

function BFind_Click(){
	var LocID=session['LOGON.CTLOCID'];
	var iGBID=$("#GBDesc").combogrid('getValue');
	if (($("#GBDesc").combogrid('getValue')==undefined)||($("#GBDesc").combogrid('getValue')=="")){var iGBID="";} 
	
	$("#CopyTeamGrid").datagrid('load',{
			ClassName:"web.DHCPE.PreGTeam",
			QueryName:"GetGTeamTempSet",
			GBID:iGBID,
			LocID:LocID
			})
	 
}

function BModifyRoom_Click(){
	
	if (ToGID==""){
		$.messager.alert("提示","复制到的团体ID为空","info");
		return false;
	}
	
	var selectrow = $("#CopyTeamGrid").datagrid("getChecked");//获取的是数组，多行数据
	if(selectrow.length=="0"){
		$.messager.alert("提示","未选择待复制的分组","info");
		return false;
	}
	var j=0
	for(var i=0;i<selectrow.length;i++){
		var TeamID=selectrow[i].TTeamID;
		if (TeamID=="") continue
		var ret=tkMakeServerCall("web.DHCPE.PreGTeam","CopyTeamData",TeamID,ToGID);
		j=j+1;
	}
	
	if(j==selectrow.length){
		$.messager.alert("提示","复制完成","info");
		return false;
	}
	
}


function InitCopyTeamDataGrid(){
	var LocID=session['LOGON.CTLOCID'];
	$HUI.datagrid("#CopyTeamGrid",{
		url: $URL,
		fit : true,
		border : false,
		striped : false,//是否显示斑马线效果
		fitColumns : false,
		autoRowHeight : false,
		rownumbers : true, //如果为true, 则显示一个行号列 
		pagination : true, //如果为true, 则在DataGrid控件底部显示分页工具栏 
		pageSize: 10,
		pageList : [10,20,30],
		singleSelect: false,
		checkOnSelect: true, //如果为false, 当用户仅在点击该复选框的时候才会被选中或取消
		selectOnCheck: true,
		
		queryParams:{
			ClassName:"web.DHCPE.PreGTeam",
			QueryName:"GetGTeamTempSet",
			LocID:LocID
			
		},
	
		columns:[[
			{title: '选择',field: 'Select',width: 60,checkbox:true},
			{field:'TID',title:'ID',hidden:true},
			{field:'TTeamID',title:'TeamID',hidden:true},
			{field:'GDesc',width:'120',title:'团体名称'},
			{field:'GTeamDesc',width:'100',title:'分组名称'},
			{field:'TAgeRange',width:'70',title:'年龄范围'},
			{field:'TTeamSex',width:'40',title:'性别'},
			{field:'TMarried',width:'70',title:'婚姻状况'},
			{field:'TAmt',width:'80',title:'金额',align:'right'}
	
		]],
		onSelect: function (rowIndex, rowData) {
			  
				loadCopyTeamItem(rowData);			
					
		},
		onUnselect:function (rowIndex, rowData) {
			  
				loadCopyTeamItem(""); 
					
		}

		
	})
}

function loadCopyTeamItem(rowData)
{
	$('#CopyTeamItemGrid').datagrid('load', {
			ClassName:"web.DHCPE.Query.PreItemList",
			QueryName:"QueryPreItemList", 
		    AdmType:"TEAM",
			AdmId:rowData.TTeamID,
			PreOrAdd:"PRE"
		
	});
}
function InitCopyTeamItemDataGrid(){
	
	$HUI.datagrid("#CopyTeamItemGrid",{
		url: $URL,
		toolbar:[],//配置项toolbar为空时,会在标题与列头产生间距",
		fit : true,
		border : false,
		striped : false,//是否显示斑马线效果
		fitColumns : false,
		autoRowHeight : false,
		rownumbers : true, //如果为true, 则显示一个行号列 
		pagination : true, //如果为true, 则在DataGrid控件底部显示分页工具栏 
		pageSize: 10,
		pageList : [10,20,30],
		singleSelect: true,
		selectOnCheck: false,
		autoRowHeight: false,
		queryParams:{
			ClassName:"web.DHCPE.Query.PreItemList",
			QueryName:"QueryPreItemList"	
			
		},
		columns:[[
			{field:'OrderEntId',title:'OrderEntId',hidden:true},
			{field:'ItemDesc',width:'100',title:'项目名称'},
			{field:'ItemSetDesc',width:'90',title:'套餐'},
			{field:'TAccountAmount',width:'90',title:'应收金额',align:'right'},
			{field:'TFactAmount',width:'90',title:'优惠金额',align:'right'},
			{field:'TRecLocDesc',width:'90',title:'接收科室'}	
		
		]]	
	
	})
}


function InitCombobox(){
	
	//团体
	var GBDescObj = $HUI.combogrid("#GBDesc",{
		panelWidth:430,
		url:$URL+"?ClassName=web.DHCPE.PreGBaseInfo&QueryName=SearchGListByDesc",
		mode: 'remote',  
		delay:200,
		pagination : true, 
		pageSize: 20,
		pageList : [20,50,100],
		idField:'GBI_RowId',
		textField:'GBI_Desc',
		onBeforeLoad:function(param){
			param.GBIDesc = param.q;
		},
		onShowPanel:function()
		{
			$('#Name').combogrid('grid').datagrid('reload');
		},
		columns:[[
			{field:'GBI_RowId',title:'ID',width:50},
			{field:'GBI_Desc',title:'名称',width:250},
			{field:'GBI_Code',title:'编码',width:100}
					
		]]
		});
}
