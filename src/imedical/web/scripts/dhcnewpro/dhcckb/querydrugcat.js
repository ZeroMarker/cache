/**
  *qunianpeng 
  *2020-09-14
  *分类查询 
  *
 **/

var catType = "";
var ruleUse = "";
var hospID = "";
var catTypeArr =[{value:"all",text:"全部分类"},{value:"other",text:"其他分类"},{value:"five",text:"新编药物学分类"},{value:"notin",text:"非其他非新编药物学分类"}]
/// 页面初始化函数
function initPageDefault(){

	InitCombobox();		/// 初始化combobox
	
	InitBlButton(); 	/// 页面 Button 绑定事件

	InitDataGrid();		/// 初始化DataGrid
}

/// 初始化combobox
function InitCombobox(){
	
	 $HUI.combobox("#catType",{
	     valueField:'value',
						textField:'text',
						data:catTypeArr,
						panelHeight:"150",
						mode:'remote',
						onSelect:function(option){
								catType = option.value;
						}
	   });
	   
	   // 院区
    var uniturl = $URL+"?ClassName=web.DHCCKBCommonUtil&MethodName=QueryHospList"  
    $HUI.combobox("#hospId",{
	     url:uniturl,
	     valueField:'value',
						textField:'text',
						panelHeight:"150",
						mode:'remote',
						onSelect:function(option){
								hospID = option.value;
						}
	   })
	   
	   // 规则引用
	   $HUI.combobox("#ruleUse",{
	     valueField:'value',
						textField:'text',
						data:[
							{value:"Y",text:"是"},
							{value:"N",text:"否"}
						],
						panelHeight:"150",
						mode:'remote',
						onSelect:function(option){
								ruleUse = option.value;
						}
	   });

}

/// 页面 Button 绑定事件
function InitBlButton(){
	
	///  查询
	$('#search').bind("click",SearchData);	
	
	/// 	重置
	$('#reset').bind("click",RefreshData);
	
	//回车事件绑定
	$('#queryText').bind("keyup",function(event){
		if(event.keyCode == "13"){
			SearchData();
		}
	});
}

/// 初始化DataGrid
function InitDataGrid(){
	
	//初始化HIS表
	/**
	 * 定义HIS表的columns
	 */
	var hiscolumns=[[
		{field:'f1',title:'1级',width:250,sortable:true},
	 {field:'f2',title:'2级',width:250,sortable:true},
	 {field:'f3',title:'3级',width:250,sortable:true},  
	 {field:'f4',title:'4级',width:250,sortable:true},  
		{field:'f5',title:'5级',width:250,sortable:true},  
		{field:'f6',title:'6级',width:250,sortable:true},  
		{field:'f7',title:'7级',width:150,sortable:true},  
		{field:'f8',title:'8级',width:150,sortable:true},  
		{field:'f9',title:'9级',width:150,sortable:true},  
		{field:'f10',title:'10级',width:150,sortable:true}
	]];
	
	/**
	 * 定义HIS表的datagrid
	 */
		var hisGrid = $HUI.datagrid("#catlist",{
								//toolbar:'#toolbar',
        url:$URL,
        queryParams:{
	        ClassName:"web.DHCCKBComExportUtil", 	// qunianpeng 替换类 2020/3/29
         QueryName:"ExportDrugCat",
         catType:catType,
        	hospID:hospID,
        	ruleUse:ruleUse,
        	input:$("#queryText").val()
	    },
	    columns: hiscolumns,  //列信息
	    pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
	    pageSize:20,
	    pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
	    remoteSort:false,
	    //idField:'RowId',
	    singleSelect:true,
	    rownumbers:true,    //设置为 true，则显示带有行号的列。
	    fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
	    onClickRow:function(index,row) {   	
	    },	
	    onLoadSuccess:function(data){
						//	$(this).prev().find('div.datagrid-body').prop('scrollTop',0);
	    },
	     onBeforeLoad: function (param) {
         /*    var firstLoad = $(this).attr("firstLoad");
            if (firstLoad == "false" || typeof (firstLoad) == "undefined")
            {
                $(this).attr("firstLoad","true");
                return false;
            }
            return true; */
        }	   
   });
   $('#catlist').datagrid('loadData',{total:0,rows:[]});  // 用空数据填充datagrid
}

/// 查询方法
function SearchData(){
 
	$('#catlist').datagrid('load',  {
   ClassName:"web.DHCCKBComExportUtil", 
   QueryName:"ExportDrugCat",
   catType:catType,
  	hospID:hospID,
  	ruleUse:ruleUse,
  	input:$("#queryText").val()
  });
	$('#catlist').datagrid('unselectAll');  // 清空列表选中数据 
}

/// 清空数据
function RefreshData(){
	
		$HUI.combobox("#catType").setValue("");
		$HUI.combobox("#hospId").setValue("");
		$HUI.combobox("#ruleUse").setValue("");
		catType ="";
		hospID = "";
		ruleUse = "";
		$("#queryText").val("");
		SearchData();
	}

/// JQuery 初始化页面
$(function(){ initPageDefault(); })