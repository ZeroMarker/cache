//页面gui
var objScreen = new Object();
function InitviewScreen(){
	var obj = objScreen;	
    $.parser.parse(); // 解析整个页面
	//初始查询条件
    obj.cboSSHosp = Common_ComboToSSHosp("cboSSHosp",SSHospCode,"DTH");  /*参数有问题*/
    //医院科室联动
	$HUI.combobox('#cboSSHosp',{
	    onSelect:function(rows){
		    var HospID=rows["CTHospID"];
			obj.cboLoc = $HUI.combobox('#cboLoc', {              
				url: $URL,
				editable: true,
				allowNull:true,
				defaultFilter:4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
				valueField: 'LocRowId',
				textField: 'LocDesc',
				onBeforeLoad: function (param) {
					param.ClassName = 'DHCMed.SSService.HospitalSrv';
					param.QueryName = 'QueryLoction';
					param.aAlias = '';
					param.aDepGroup = '';
					param.aLinkLoc = "";
					param.aLocType = "E";
					param.aAdmType = "";
					param.aHospitalIDs =HospID;
					param.ResultSetType = 'array';
				},
				onSelect:function(record){
						obj.LocRowId=record["LocRowId"]
						var param=$("#gridRepNoList").datagrid("options").queryParams;
						param.aLoc=obj.LocRowId;
						$("#gridRepNoList").datagrid("reload");
				},
				onChange:function(newdata,olddata){
					if(!newdata){
					obj.ProCode=""
					var param=$("#gridRepNoList").datagrid("options").queryParams;
						param.aLoc=obj.LocRowId;
						$("#gridRepNoList").datagrid("reload");
					}
				}
			});
	    }
    });
 
	obj.gridRepNoList =$HUI.datagrid("#gridRepNoList",{
		fit: true,
		title: "报告编号管理",
		headerCls:'panel-header-gray',
		iconCls:'icon-add-note',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect:false,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
	    url:$URL,
	    queryParams:{
		    ClassName:"DHCMed.DTHService.RepNoSrv",
			QueryName:"QryRepNobyLocID",
			aLoc:obj.LocRowId,
			aHosp:$('#cboSSHosp').combobox("getValue")
	    },
		columns:[[
			{field:'ReportNo',title:'死亡证明书编号',width:'200'},
			{field:'Loc',title:'分配科室',width:'210'},
			{field:'StoraUser',title:'操作人',width:'150'},
			{field:'storaDate',title:'操作日期',width:'150'},
			{field:'storaTime',title:'操作时间',width:'150'}
		]]
	});
	
	
	InitviewScreenEvent(obj);
	obj.LoadEvent(arguments);	
	return obj;
}