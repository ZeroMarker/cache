//页面gui
var objScreen = new Object();
function InitviewScreen(){
	var obj = objScreen;
	obj.editIndex=undefined;
    $.parser.parse(); // 解析整个页面
    $HUI.combobox('#chkLocation',
	    {
			url:$URL+'?ClassName=DHCMA.Util.EPS.LocationSrv&QueryName=QryHosLocInfo&ResultSetType=Array',
			valueField:'OID',
			textField:'Desc',
			multiple:true,
			//rowStyle:'checkbox', //显示成勾选行形式
			panelHeight:300,
			editable:true   		    
	    })
	obj.gridQcEntity =$HUI.datagrid("#gridQcEntity",{
		fit: true,
		title: "质控病种维护",
		iconCls:"icon-resort",
		headerCls:'panel-header-gray',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		//rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		autoRowHeight: false, 
		loadMsg:'数据加载中...',
		pageSize: 10,
		pageList : [10,20,50,100],
	    url:$URL,
	    nowrap:false,
	    sortName : 'BTIndNo',
	    sortOrder : 'ASC',
	    queryParams:{
		    ClassName:"DHCMA.CPW.SDS.QCEntitySrv",
			QueryName:"QryQCEntity"		
	    },
		columns:[[
			{field:'BTID',title:'ID',width:'40'},
			{field:'BTCode',title:'项目编码',width:'150',sortable:true},
			{field:'BTDesc',title:'项目名称',width:'250',sortable:true},
			{field:'BTAbbrev',title:'缩写',width:'150',sortable:true},
			{field:'BTURL',title:'接口地址',width:'250',sortable:true},
			{field:'BTOperKey',title:'手术关键字',width:'200',sortable:true},
			{field:'BTIsActive',title:'是否<br>有效',width:'70',align:'center'},
			{field:'BTIndNo',title:'排序码',width:'80',sortable:true},
			{field:'BTPubdate',title:'发布时间',width:'150'},
			{field:'BTLocation',title:'关联科室',width:'250',
				formatter:function(value,row,index){
					if (value.indexOf(",")>-1){
						var reg = new RegExp( ',' , "g" )
						return value.replace(reg,"<br>")
					}else{
						return value
					}
				}
			}
			//{field:'BTID',title:'RowID',hidden:true}	
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridQcEntity_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){			
				obj.gridQcEntity_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	
	InitviewScreenEvent(obj);
	obj.LoadEvent(arguments);	
	return obj;
}