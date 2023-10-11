//名称	DHCPEComplain.Find.hisui.js
//功能	体检投诉管理	
//创建	2023.02.06
//创建人  ln

$(function(){
	 
	//下拉列表框
	InitCombobox();
	
	//初始化列表
	InitComplainGrid();
	
	//查询
	$("#BFind").click(function() {	
		BFind_click();		
     });
    
	//清屏
	$("#BClear").click(function() {	
		BClear_click();		
     });
     
    //新增
    $("#BNew").click(function() {	
		BNew_click();		
     });
     
     //修改
    $("#BUpdate").click(function() {	
		BUpdate_click();		
     });
     
     //处理
    $("#BProposal").click(function() {	
		BProposal_click();		
     });
     
     //默认类型为"投诉"
	$("#Type").combobox('setValue', "C");
})


//清屏
function BClear_click(){
	$("#BeginDate,#EndDate").datebox('setValue')
	$("#Type").combobox('setValue',"C");
	BFind_click();
}

//查询
function BFind_click(){
	
	var BeginDate="",EndDate="",Type="C";
	
	var CTLocID=session['LOGON.CTLOCID'];
	
	var BeginDate=$("#BeginDate").datebox('getValue');
    var EndDate = $("#EndDate").datebox('getValue');
	
	var Type=$("#Type").combobox('getValue');
	var ProStatus=$('input[name="ProStatus"]:checked').val();
		
	$("#ComplainGrid").datagrid('load',{
		ClassName:"web.DHCPE.Complain",
		QueryName:"FindComplainRecord",
		BDate:BeginDate,
		EDate:EndDate,
		Type:Type,
		ProStatus:ProStatus,
		Loc:CTLocID

	});
	
}
var HISUIStyleCode=tkMakeServerCall("websys.StandardTypeItem","GetIdFromCodeOrDescription","websys","HISUIDefVersion");
if(HISUIStyleCode=="blue"){ var Width=555;}
else {var Width=525;}
//新增
function BNew_click()
{	
	$HUI.window("#ComplainEditWin", {
         title: "体检投诉维护",
         iconCls: "icon-w-copy",
         collapsible: false,
         minimizable: false,
         maximizable: false,
         closable: true,
         resizable: false,
         modal: true,
         width: Width,
         height: 625,
         content: '<iframe src="dhcpecomplain.edit.hisui.csp?" width="100%" height="99%" frameborder="0"></iframe>'
     });
}

//修改
function BUpdate_click(){
	var RowId=$("#RowId").val();
	if (RowId=="") {
		 $.messager.alert("提示","请选择待修改的记录","info");
		return false;
	}
	
	$HUI.window("#ComplainEditWin", {
         title: "体检投诉修改",
         iconCls: "icon-w-copy",
         collapsible: false,
         minimizable: false,
         maximizable: false,
         closable: true,
         resizable: false,
         modal: true,
         width: 555,
         height: 625,
         content: '<iframe src="dhcpecomplain.edit.hisui.csp?RowId='+RowId+'" width="100%" height="99%" frameborder="0"></iframe>'
     });
	
}

//处理
function BProposal_click(){
	var RowId=$("#RowId").val();
	if (RowId=="") {
		 $.messager.alert("提示","请选择待处理的记录","info");
		return false;
	}
	
	$HUI.window("#CompdisposeWin", {
         title: "体检投诉处理",
         iconCls: "icon-w-copy",
         collapsible: false,
         minimizable: false,
         maximizable: false,
         closable: true,
         resizable: false,
         modal: true,
         width: 695,
         height: 310,
         content: '<iframe src="dhcpecompdispose.hisui.csp?RowId='+RowId+'" width="100%" height="99%" frameborder="0"></iframe>'
     });
	
}

function InitComplainGrid()
{

	$HUI.datagrid("#ComplainGrid",{
		url:$URL,
		fit : true,
		border : false,
		striped : false,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		singleSelect: true,
		selectOnCheck: false,
		queryParams:{
			ClassName:"web.DHCPE.Complain",
			QueryName:"FindComplainRecord",
			BDate:$("#BeginDate").datebox('getValue'),
			EDate:$("#EndDate").datebox('getValue'),
			Type:$("#Type").combobox('getValue'),
			ProStatus:"",
			Loc:session['LOGON.CTLOCID']
		},
        frozenColumns:[[
        	
			{field:'TCComplainUser',width:130,title:'投诉人'},
			{field:'TStatus',width:130,title:'状态'}
				 
		]],
		columns:[[ 
			
		    {field:'TRowID',title:'TRowID',hidden: true},
			{field:'TTypeDesc',width:80,title:'类型'},
			{field:'TCSource',width:100,title:'事件来源'},
			{field:'TCComplainType',width:100,title:'投诉类型'},
			{field:'TCComplainObject',width:140,title:'投诉对象'},
			{field:'TCComplainContent',width:100,title:'投诉内容'},
			{field:'TCEventTime',width:180,title:'事件时间'},
			{field:'TCComplainCause',width:100,title:'投诉原因'},
			{field:'TCDisProposal',width:100,title:'处置建议'},
			{field:'TCRemark',width:80,title:'备注'}, 
			{field:'TCName',width:100,title:'患者姓名'},
			{field:'TCRegNo',width:100,title:'登记号'},
			{field:'TCIDCard',width:100,title:'身份证号'},
			{field:'TCRecord',title:'就诊记录',hidden: true},
			{field:'TRecordDate',width:100,title:'就诊时间'},
			{field:'TCClaimantName',width:100,title:'申诉人姓名'},
			{field:'TCClaimantNo',width:100,title:'证件号'},
			{field:'TCRelation',width:100,title:'与患者关系'},
			{field:'TCTel',width:100,title:'移动电话'},
			{field:'TCUpdateUser',width:100,title:'更新人'},
			{field:'TCUpdateDate',width:100,title:'更新日期'},
			{field:'TCUpdateTime',width:100,title:'更新时间'},
			{field:'TCLoc',hidden: true}
				
		]],
		onClickRow:function(rowIndex,rowData){
			
			setValueById("RowId",rowData.TRowID);
			selectrow=rowIndex;
	
		},
		onSelect: function (rowIndex, rowData) {	
		
		},
		onLoadSuccess: function(data) {
			
		},
			
	})
}

function InitCombobox()
{	
    //类型	
	var TypeObj = $HUI.combobox("#Type",{
        valueField:'id',
        textField:'text',
        panelHeight:'70',
        data:[
           {id:'C',text:$g('投诉')}  
        ]

    });
}