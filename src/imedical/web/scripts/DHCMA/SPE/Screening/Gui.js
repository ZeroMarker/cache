//页面gui
var objScreen = new Object();
function InitviewScreen(){
	var obj = objScreen;
	obj.editIndex=undefined;
    $.parser.parse(); // 解析整个页面
    
    var Userdata=$cm({
			ClassName:'DHCHAI.BT.SysUser',
			MethodName:'GetObjByXCode',
			aSCode:"HIS01",
			aXCode:session['LOGON.USERID']
		},false)
	LogonUserID=Userdata.ID;
    
    //特殊患者分类
    $HUI.combobox('#txtPatType',
	    {
			url:$URL+'?ClassName=DHCMed.SPEService.PatType&QueryName=QryPatType&ResultSetType=Array',
			valueField:'PTID',
			textField:'PTDesc',
			//rowStyle:'checkbox', //显示成勾选行形式
			editable:false,
			onSelect:function(rec){
				
				$HUI.combobox('#txtPatSubType',{
					url:$URL+'?ClassName=DHCMed.SPEService.PatTypeSub&QueryName=QryPatTypeSub&ResultSetType=Array&ParRef='+rec.PTID,
					valueField:'PTSID',
					textField:'PTSDesc',
					editable:false 
				});
			} 
	    })
	    

	    
	
	obj.gridScreening =$HUI.datagrid("#gridScreening",{
		fit: true,
		title: "重点病人筛查条件维护",
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
	    queryParams:{
		    ClassName:"DHCMed.SPEService.Screening",
			QueryName:"QueryScreening"		
	    },
		columns:[[
			{field:'ID',title:'ID',width:'40'},
			{field:'Code',title:'代码',width:'150',sortable:true},
			{field:'Desc',title:'描述',width:'250',sortable:true},
			{field:'PatTypeID',title:'患者类型ID',width:'150',sortable:true},
			{field:'PatTypeCode',title:'患者类型代码',width:'250',sortable:true},
			{field:'PatTypeDesc',title:'患者类型描述',width:'200',sortable:true},
			{field:'ActiveDesc',title:'是否<br>有效',width:'70',align:'center'},
			
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridScreening_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){			
				obj.gridScreening_onDbselect(rowData);
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