/// author:    huanghongping
/// date:      2021-07-20
/// descript:  人员信息字典维护

var editRow = ""; editDRow = ""; editPRow = "";
/// 页面初始化函数
function initPageDefault() {

    //初始化人员信息管理
    InitMainList();




}



///初始化字典类型列表
function InitMainList() {

	/**
	 * 文本编辑格
	 */
    var textEditor = {
        type: 'text',//设置编辑格式
        options: {
            required: true, //设置编辑规则属性
            editable: false
        }
    }

	/**
	 * 定义columns
	 */
    var columns = [[
        { field: 'checkbox', checkbox: true },
        { field: 'RowId', title: 'ID', hidden: true, align: 'center' },
        { field: 'HosDesc', title: '所属机构', align: 'center' },
        { field: 'LoginId', title: '登录名', align: 'center' },
        { field: 'LoginName', title: '用户姓名', hidden: false, align: 'center' },
        { field: 'CtStr', title: '监测科室', align: 'center' },
    ]];

	/**
	 * 定义datagrid
	 */
    var option = {
        title: '药师列表',
        //nowrap:false,
        headerCls: 'panel-header-gray',
        rownumbers: true,
        singleSelect: false,
        iconCls: 'icon-paper',
        fitColumns: true,
        onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑

        },
        onClickRow: function (rowIndex, rowData) {

        }
    };

    var uniturl = $URL + "?ClassName=web.DHCPRESCDicScheme&QueryName=GetAllPLCtLoc&SearchString=";
    new ListComponent('main', columns, uniturl, option).Init();
}



/// JQuery 初始化页面
$(function () {
    initPageDefault();

    /// 检索 
    $("#ManageSearch").click(function () {
        //	    var startDate=$("#Code").datebox('getValue')
        //	    var endDate=$("#Name").datebox('getValue')
        //	    var sort = $("#switch").switchbox('getValue') 
        var SearchString = $("#Code").val()
        $("#main").datagrid('load', { SearchString: SearchString })
    });

    $("#echarts").click(function () {
        var datas = $("#main").datagrid("getSelections");
        var datasArry = []
        for (i in datas) {
            var tempData = datas[i].RowId
            datasArry.push(tempData)
        }

        if(datas.length<1){
	      $.messager.confirm("提示","未选择药师！将默认为登录人自己选择科室，是否继续？",function(e){
		      if(e==true){
			      OpenConsWin();
			      var url = "dhcpresc.dicscheme.csp?datas="+datasArry;
			      if ('undefined'!==typeof websys_getMWToken){
					url += "&MWToken="+websys_getMWToken();
				  }
	      		  $("#newWinFrame").attr("src",url);
			      
			  }
			  else{
				  return;  
			  }    
		      
		  } );	    
	      }
		  else{
			  OpenConsWin();
			  var url = "dhcpresc.dicscheme.csp?datas="+datasArry;
			  if ('undefined'!==typeof websys_getMWToken){
				url += "&MWToken="+websys_getMWToken();
			  }
	      	  $("#newWinFrame").attr("src",url);
			  
		 }	
		  
	      
})
      

    /// 打卡MDT填写页面
    function OpenConsWin() {
        var option = {
            collapsible: false,
            minimizable: false,
            maximizable: false,
            border: true,
            closed: "true",
            iconCls: 'icon-w-card',
            onBeforeClose: function () {
                $("#main").datagrid('reload')
            }

        };
        new WindowUX('科室分配', 'ConsWin', '1250', '500', option).Init();
    }

    $("#tempLink").click(function () {
        var url = "dhcpresc.loctemp.csp";
        websys_createWindow(url, true, "status=1,scrollbars=1,top=0,left=0,width=1200,height=700");

    })
})


