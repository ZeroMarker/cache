/**
 * @Title:版本管理
 * @Author: 汪凯-DHCWL
 * @Description:版本管理界面设计
 * @Created on 2018-01-10
 */
 
 var param = window.location.href;
 var r = window.location.search.substr(1);
 var p = r.split("&");
/*--鼠标悬停备注单元格响应方法--*/
 function formatCellTooltip(value){  
        return "<span id='verylongText' title='" + value + "'>" + value + "</span>";  
    }
 /*--将产品名称列制成链接，点击后弹出产品对应的历史维护信息--*/
 function linkHisVerGrid(value,row,index){
	 /*return "<a href='javascript:void(0)' onclick='verHisInforFun(\""+row.vmDr+"\")' title='查看产品历史维护信息'>\
			"+value+"\
			</a>";*/
		return "<a href='javascript:void(0)' onclick='verHisInforFun(\""+row.vmDr+"\")' title='查看产品历史维护信息'>\
			"+"<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/apply_check.png' />"+"\
			</a>";
 }
var init = function(){
	
	/*--版本管理主界面展示--*/
	var verManageGridObj = $HUI.datagrid("#verManageGrid",{
		url:$URL,  //固定写法
		queryParams:{
			ClassName:"DHCWL.VerManagement.DefaultInOutService", //方法或者query路径
			QueryName:"GetVersion" //query名
		},
		pagination:true, //允许用户通过翻页导航数据
		//striped:true, //斑马线效果
		pageSize:15,  //设置首次界面展示时每页加载条数
	    pageList:[10,15,20,50,100], //设置分页可选展示条数
		fitColumns:true //列填充满datagrid
	})
	
	/*--产品历史维护信息展示--*/
	var verHisGridObj = $HUI.datagrid("#verHisGrid",{
		url:$URL,
		queryParams:{
			ClassName:"DHCWL.VerManagement.DefaultInOutService", //方法或者query路径
			QueryName:"GetHisByRowID"  //query名
		},
		striped:true
	})
	
	
	/**
	 *点击产品链接后的响应方法(固定模式)
	 *1、首先弹出界面表格对象(这里是verHisGridObj)加载数据
	 *2、弹出窗口的div加载
	 *3、定义弹出窗口的展示界面样式
	*/
	this.verHisInforFun=function(value) {
		verHisGridObj.load({ClassName:"DHCWL.VerManagement.DefaultInOutService",QueryName:"GetHisByRowID",rowid:value}); 
		$("#verHisDlg").show();
		var iconsDlgObj = $HUI.dialog("#verHisDlg",{
			iconCls:'icon-w-add',
			resizable:true,
			modal:true
		});
	}
}
$(init);