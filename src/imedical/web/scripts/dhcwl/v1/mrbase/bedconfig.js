var globalID="";
var globalName="";
var globalCode="";

function linkHisBedFun(value,row,index) {
	/*return "<a href='javascript:void(0)' onclick='locHisBedFun(\""+row.ID+"\")' title='查看科室历史床位信息'>\
			"+value+"\
			</a>";*/
	return "<a href='javascript:void(0)' onclick='locHisBedFun(\""+row.ID+"\")' title='查看历史床位信息'>\
			"+"<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/apply_check.png' />"+"\
			</a>";
}
var init = function(){
	
	/*--主界面科室表格配置--*/
	var locListObj = $HUI.datagrid("#locList",{
		url:$URL,  //固定写法
		queryParams:{
			ClassName:"web.DHCWL.V1.MRBase.BedConfig", //query或者方法路径
			QueryName:"GetLocListQuery",  //query名
			locType:"Loc" //类型
		},
		fitColumns:true,  //列充满表格
		//striped:true,     //斑马线效果
		pagination:true,  //支持分页
		pageSize:15,      //当前分页每页显示条数
	    pageList:[5,10,15,20,50,100]   //页面可选展示条数
	});
	
	
	/*--科室新增界面的表格显示--*/
	var locAddGridObj = $HUI.datagrid("#locAddGrid",{
		url:$URL,  //URL 固定写法
		queryParams:{
			ClassName:"web.DHCWL.V1.MRBase.BedConfig",  //方法或者query名
			QueryName:"GetAllLocQuery"  //query名
		},
		pagination:true,  //是否支持分页
		//striped:true,     //斑马线效果
		fitColumns:true,
		pageSize:15,      //当前页面每页展示条数
	    pageList:[5,10,15,20,50,100],  //支持选择的每页展示条数 
		toolbar:'#loctb'  //toolbar工具栏
	})
	
	
	/*--响应新增按钮点击事件--*/
	$("#locAddButton").click(function (argument) {
    	saveHandler();
    });
    
    
	/*--点击科室新增按钮时调用的方法--*/
	var saveHandler = function(){
        var checkedRadioJObj = $("input[name='locType']:checked");  // 获得单选框选中的对象
		var type=checkedRadioJObj.val();  //获取选中的单选框的值
		if (type==""){  
			return;
		}
		$("#locAddDlg").show();  //弹出框对应的div需要show一下
		$('#searchLocText').searchbox('setValue', '');
		locAddGridObj.load({ClassName:"web.DHCWL.V1.MRBase.BedConfig",QueryName:"GetAllLocQuery",LocOrWard:type});  //新增科室表格加载数据
		var locAddDlgObj = $HUI.dialog("#locAddDlg",{  //定义弹出框的样式
			iconCls:'icon-w-add',
			resizable:true,
			modal:true,  //该弹出框打开后用户不能操作后面的主页面
			buttons:[{
				text:'下一步',
				handler:function(){
					var row = locAddGridObj.getSelected();
					if (!row){
						$.messager.alert("提示","请先选择一条记录");
						return;
					}
					globalID=row.id;  //将选中的一条表格信息的id,name,code赋值给全局变量
					globalName=row.name;
					globalCode=row.code;
					locAddDlgObj.close();  //弹出框关闭
					modifyHandler();  //打开下一个界面，填写科室对应的床位信息
					$('#myAddInforForm').form('clear');  //清空弹出框信息
					$('#locDesc').attr("disabled",true); //将弹出框的科室信息一栏设置为不编辑
    				$("#locDesc").val(globalName);  //为弹出框的科室信息一栏设置值
				}
			},{
				text:'取消',
				handler:function(){
					locAddDlgObj.close();  //点击取消按钮关闭弹出框
				}
			}]
		});	
	}
	
	 //响应科室床位信息修改按钮点击事件
	$("#locModifyButton").click(function (argument) {
		var row = locListObj.getSelected();
		if (!row){
			$.messager.alert("提示","请先选择一条记录");
			return;
		}
		globalID=row.ID;  //点击后将选中的记录信息保存到全局变量中
		globalName=row.name;
		globalCode=row.code;
    	modifyHandler();  //调用方法，弹出修改信息窗口
    	$('#myAddInforForm').form('clear'); //清空弹出窗口表单数据
    	$('#locDesc').attr("disabled",true); //设置科室描述单元格不可用
    	$("#locDesc").val(globalName);  //设置科室描述单元格的值
    });
	
	
	/*--用户点击修改床位数按钮或者点击新增科室弹出框的下一步按钮时调用的方法--*/
	var modifyHandler = function(){
		$("#locModifyDlg").show();   //先将弹框所在的div "show"一下
		var locModifyDlgObj = $HUI.dialog("#locModifyDlg",{  //绘制弹出框的样式
			iconCls:'icon-w-edit',
			resizable:true,
			modal:true,  //设置为true即为弹框在打开状态时不能操作主界面
			buttons:[{
				text:'保存',
				handler:function(){
					var flag = $("#myAddInforForm").form('validate');
					if (!flag){
						myMsg("请按照提示填写内容");
						return;
					}
					$.messager.confirm('提示', '您确认对当前选中的记录进行床位更新么?', function(r){
						if (r){
							var locID=globalID;  //将全局变量中的值赋给局部变量
							var locCode=globalCode;
							var locName=globalName;
							var startDate=$('#date').datebox('getValue');  //获取弹框中的值
							var GDNum=$("#GDNum").val();
							var SYNum=$("#SYNum").val();
							var BZNum=$("#BZNum").val();
							var checkedRadioJObj = $("input[name='locType']:checked"); //获取选中的单选框对象
							var type=checkedRadioJObj.val(); //获取选中单选框的值
							if (type==""){
								return;
							}
							var data = $.m({ClassName:"web.DHCWL.V1.MRBase.BedConfig",MethodName:"SaveBedInfor",  //调用后台方法的固定写法
										"locType":type,"locCode":locCode, "locDesc":locName, "startDate":startDate, "GDNum":GDNum, "SYNum":SYNum,"BZNum":BZNum
							},function(btn){
								if (btn=="ok"){ 
									locListObj.load(); //保存成功时，刷新主界面表格数据
									locModifyDlgObj.close(); //关闭弹框
								}else{
									$.messager.alert("提示",btn); //保存失败时，弹出错误信息
								}
							})
						}
					})
				}
			},{
				text:'关闭',
				handler:function(){
					locModifyDlgObj.close(); //点击关闭按钮，关闭弹窗
				}
			}]
		});	
	}
	
	
	/*--科室历史维护床位信息表格--*/
	var locHisBedListObj = $HUI.datagrid("#locHisBedGrid",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCWL.V1.MRBase.BedConfig",
			QueryName:"GetLocListQuery",
			locType:"Loc"
		}//,
		//striped:true
	});
	
	/*--响应主界面科室编码链接的点击事件--*/
	this.locHisBedFun=function(value) {
		var checkedRadioJObj = $("input[name='locType']:checked");  //获取选中的单选框的对象
		var type=checkedRadioJObj.val();  //获取选中的单选框的值
		if (type==""){
			return;
		}
		locHisBedListObj.load({ClassName:"web.DHCWL.V1.MRBase.BedConfig",QueryName:"GetLocHisBedListQuery",locType:type,locID:value});   //加载科室对应的历史床位信息
		$("#locHisShow").show();  //弹出框依赖的div这里需要show一下
		var iconsDlgObj = $HUI.dialog("#locHisShow",{  //定义弹出框的样式
			iconCls:'icon-w-list',
			resizable:true,
			modal:true
		});
	}
	
	
	/*--主界面检索框在回车或者点击检索图标时会调用该方法--*/
	$('#searchText').searchbox({
    	searcher:function(value,name){
    		var checkedRadioJObj = $("input[name='locType']:checked");  //--获取选中的单选框对象
			var type=checkedRadioJObj.val();  //--获取选中单选框的值
			if (type==""){
				return;
			}
			locListObj.load({ClassName:"web.DHCWL.V1.MRBase.BedConfig",QueryName:"GetLocListQuery",locType:type,filterValue:value}); //主界面表格数据加载
    	}
	});
    
    
    //监听单选框点击变化
	$HUI.radio("[name='locType']",{
    	onChecked:function(e,value){
        	var type=$(e.target).attr("value");  //获取当前选中的label值
        	locListObj.load({ClassName:"web.DHCWL.V1.MRBase.BedConfig",QueryName:"GetLocListQuery",locType:type}); //主界面表单数据需要根据单选框的选择变化而变化
        }
    });
    
    /*--科室新增界面查询框的回车或者点击检索按钮响应事件--*/
	$('#searchLocText').searchbox({
		searcher:function(value,name){
			var checkedRadioJObj = $("input[name='locType']:checked");  //获取选中的单选框对象
			var type=checkedRadioJObj.val();  //获取选中的单选框的值
			if (type==""){
				return;
			}
			locAddGridObj.load({ClassName:"web.DHCWL.V1.MRBase.BedConfig",QueryName:"GetAllLocQuery",LocOrWard:type,filterLoc:value});  //重新加载表格数据
		}
	});
};
$(init);
