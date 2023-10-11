//页面Gui
var aflg="";
var obj=new Object();
$(function(){
	obj.ParentId='';
	InitAreaMapWin();
})
function InitAreaMapWin(){
	
	var IsCheckFlag=false;
	obj.gridAreaMap = $HUI.datagrid("#gridAreaMap",{
		fit: true,
		title: "省市县乡数据对照",
		headerCls:'panel-header-gray',
		iconCls:'icon-resort',
		pagination: true,//如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		nowrap:true,
		fitColumns: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList: [20,50,100,200],		
		url:$URL,
		queryParams:{
			ClassName:"DHCMA.Util.BTS.AreaIODicMapSrv",
			QueryName:"QryAreaIODicMap",
			aSource:$('#cboSource').combobox('getText'),
			aAlias:$('#txtAlias').searchbox('getValue'),
			aIsActive:'',
			aIsMap:''
		},
		columns:[[
			{field:'Code',title:'地址代码',width:100},
			{field:'Desc',title:'地址名称',width:300},
			{field:'SrcCode',title:'对照代码',width:100},
			{field:'SrcDesc',title:'简称',width:120},
			{field:'IsActDesc',title:'是否有效',width:80}
		]]
	});
	
	//数据来源
	obj.cboSource = $HUI.combobox('#cboSource', {
		url: $URL,
		editable: true,
		defaultFilter:4,
		valueField: 'ind',
		textField: 'Source',
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCMA.Util.BTS.AreaIODicMapSrv';
			param.QueryName = 'QryAreaSource';
			param.ResultSetType = 'array';
		},
		onSelect:function(row){
			 obj.gridAreaMapLoad();			
		},onLoadSuccess:function(){   //初始加载赋值
			var data=$(this).combobox('getData');
			if (data.length>0){
				$(this).combobox('select',data[0]['ind']);
			}
		}

	});
	
    //省市县乡字典
    obj.gridAreaDic = $HUI.datagrid("#gridAreaDic",{
		fit: true,
		title: "省市县乡字典",
		headerCls:'panel-header-gray',
		iconCls:'icon-resort',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		nowrap:true,
		fitColumns: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList: [20,50,100,200],
		url:$URL,
		queryParams:{
			ClassName:"DHCMed.SSService.AreaDicSrv",
			QueryName:"QryAreaDic",
			aParentID:obj.ParentId
		},
		columns:[[
			{field:'Code',title:'代码',width:100},
			{field:'ShortDesc',title:'名称',width:100},
			{field:'LongDesc',title:'全名',width:300},
			{field:'IsActiveDesc',title:'是否有效',width:80}
		]]
	});
	
	
	//省
	obj.cboProvince = $HUI.combobox('#cboProvince', {
		editable: true,
		defaultFilter:4,
		valueField: 'ID',
		textField: 'ShortDesc',
		onShowPanel: function () {
			var url=$URL+"?ClassName=DHCMed.SS.AreaDic&QueryName=QryArea&ResultSetType=array&aParentId=1";
			$('#cboProvince').combobox('reload',url);
		},
		onSelect:function(row){
			obj.ParentId = row["ID"];
			var param=$("#gridAreaDic").datagrid("options").queryParams;
			param.aParentID=obj.ParentId;
			$("#gridAreaDic").datagrid("reload");			
		},	 
		onChange:function(newValue,oldValue){		
			$('#cboCity').combobox('clear');
			$('#cboCounty').combobox('clear');
		}
	});

	//市
	obj.cboCity = $HUI.combobox('#cboCity', {
		editable: true,
		defaultFilter:4,
		valueField: 'ID',
		textField: 'ShortDesc',
		onShowPanel: function () {
			var url=$URL+"?ClassName=DHCMed.SS.AreaDic&QueryName=QryArea&ResultSetType=array&aParentId="+$('#cboProvince').combobox('getValue');
			$('#cboCity').combobox('reload',url);
		},onSelect:function(row){
			obj.ParentId = row["ID"];
			var param=$("#gridAreaDic").datagrid("options").queryParams;
			param.aParentID=obj.ParentId;
			$("#gridAreaDic").datagrid("reload");			
		},onChange:function(newValue,oldValue){
			$('#cboCounty').combobox('clear');
		}
	});	
	//县
	obj.cboCounty = $HUI.combobox('#cboCounty', {
		editable: true,
		defaultFilter:4,
		valueField: 'ID',
		textField: 'ShortDesc',
		onShowPanel: function () {
			var url=$URL+"?ClassName=DHCMed.SS.AreaDic&QueryName=QryArea&ResultSetType=array&aParentId="+$('#cboCity').combobox('getValue');
			$('#cboCounty').combobox('reload',url);
		}, onSelect:function(row){
			obj.ParentId = row["ID"];
			var param=$("#gridAreaDic").datagrid("options").queryParams;
			param.aParentID=obj.ParentId;
			$("#gridAreaDic").datagrid("reload");			
		}
	});
	
	InitAreaMapWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}