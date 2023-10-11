/// 名称:数据使用频次展示界面查询
/// 编写者: 基础数据平台组-陈莹
/// 编写日期: 2018-06-19
var init = function(){
	
	$('#TextTableName').keyup(function(event){
		if(event.keyCode == 13) {
		  SearchFunLib();
		}
		if(event.keyCode == 27) {
		  ClearFunLib();
		}
	    
	});
	$('#TextDesc').keyup(function(event){
		if(event.keyCode == 13) {
		  SearchFunLib();
		}
		if(event.keyCode == 27) {
		  ClearFunLib();
		}
	    
	});
	//科室查询下拉框--石萧伟18-11-12
	$("#TextLoc").combobox({
        url:$URL+"?ClassName=web.DHCBL.MKB.MKBLocContrast&QueryName=GetList&ResultSetType=array",
        valueField:'CTLOCRowID',
        textField:'CTLOCDesc',
        panelWidth:250		
	});
	//获取登陆科室的id--石萧伟18-11-12
	var LocId=session['LOGON.CTLOCID'];
	
	//查询下拉框默认当前登陆科室--石萧伟18-11-12
	$("#TextLoc").combobox('setValue',LocId);
	
	//默认表名--石萧伟18-11-12
	$("#TextTableName").val("User.SDSStructDiagnos");
	
	//查询按钮
	$("#btnSearch").click(function (e) { 

			SearchFunLib();
	 })  
	 
	//重置按钮
	$("#btnRefresh").click(function (e) { 

			ClearFunLib();
	 }) 
 

	 //查询方法
	SearchFunLib=function (){
		$('#mygrid').datagrid('load',  { 
			ClassName:"web.DHCBL.BDP.BDPDataFrequency",
			QueryName:"GetNewList",
			tablename:$.trim($("#TextTableName").val()),	
			desc:$.trim($('#TextDesc').val()),
			loc:$("#TextLoc").combobox('getValue')
		});
		$('#mygrid').datagrid('unselectAll');
	}
	
	//重置方法
	ClearFunLib=function ()
	{
		$("#TextTableName").val("");
		$("#TextDesc").val("");
		$('#mygrid').datagrid('load',  { 
			ClassName:"web.DHCBL.BDP.BDPDataFrequency",
			QueryName:"GetNewList",
			loc:LocId,
			tablename:"User.SDSStructDiagnos"
		});
		//查询下拉框默认当前登陆科室--石萧伟18-11-12
		$("#TextLoc").combobox('setValue',LocId);
		
		//默认表名--石萧伟18-11-12
		$("#TextTableName").val("User.SDSStructDiagnos");		
		$('#mygrid').datagrid('unselectAll');
	}
	function fixWidth(percent)  
	{  
	    return document.body.clientWidth * percent ;//根据自身情况更改

	}  
	var columns =[[  
				
				  {field:'ID',title:'ID',width:80,sortable:true,hidden:true},	  
				  {field:'BDPDAFTableName',title:'表名',width:90},
				  //{field:'BDPDAFDataReference',title:'数据ID',width:120},
				  {field:'BDPDAFDesc',title:'数据描述',width:120},
				  {field:'BDPDAFFrequency',title:'频次',width:60,sortable:true},
				  {field:'BDPDAFUserID',title:'用户',width:80},
				  {field:'BDPCTLocDR',title:'科室',width:120}
	 ]];
	var mygrid = $HUI.datagrid("#mygrid",{
		url:$URL,
		remoteSort:true, //远程排序
		queryParams:{
			ClassName:"web.DHCBL.BDP.BDPDataFrequency",         ///调用Query时
			QueryName:"GetNewList",
			tablename:"User.SDSStructDiagnos",
			loc:LocId
			
		},
		ClassTableName:'User.BDPDataFrequency',
		SQLTableName:'BDP_DataFrequency',
		autoSizeColumn:true,
		remoteSort:true,  //定义是否从服务器排序数据。true
		idField:'ID',
		columns: columns,  //列信息
		pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
		pageSize:PageSizeMain,
		pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000], 
		singleSelect:true,
		fixRowNumber:true, //列号 自适应宽度
		rownumbers:true,    //设置为 true，则显示带有行号的列。
		fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		onLoadSuccess:function(data){
	        $(this).prev().find('div.datagrid-body').prop('scrollTop',0);  //如果有滚动条，滚动到最上面
        	$(this).datagrid('columnMoving'); //列可以拖拽改变顺序
        }
	});
	ShowUserHabit('mygrid');
	

};
$(init);