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
		    obj.cboLoc = Common_ComboToLoc("cboLoc","E","","",HospID);
	    }
    });
	//状态下拉框
	obj.cboStatus = Common_ComboToDic('cboStatus','DTHCurrencyState');
	obj.gridPaperNo =$HUI.datagrid("#gridPaperNo",{
		fit: true,
		title: "纸单号管理",
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
		    ClassName:"DHCMed.DTHService.PaperNoSrv",
			QueryName:"QryPaperNo",
			aHosp:$('#cboSSHosp').combobox("getValue")
	    },
		columns:[[
			//{field:'checkOrd',checkbox:'true',align:'center',width:30,auto:false},
			{field:'PaperNo',title:'纸单号',width:'110'},
			{field:'Status',title:'状态',width:'80'},
			{field:'StLoc',title:'入库科室',width:'120'},
			{field:'StDoctor',title:'入库人',width:'120'},
			{field:'StDate',title:'操作日期',width:'120'},
			{field:'StTime',title:'操作时间',width:'90'},
			{field:'AllocLoc',title:'使用科室',width:'120'},
			{field:'OneFlag',title:'首联',width:'80'},
			{field:'ThreeFlag',title:'三联',width:'80'}
		]],
   onLoadSuccess:function(){
      $(this).datagrid("fixRownumber");
   }	
	});
	$.extend($.fn.datagrid.methods, {
    fixRownumber : function (jq) {
        return jq.each(function () {
            var panel = $(this).datagrid("getPanel");
            //获取最后一行的number容器,并拷贝一份
            var clone = $(".datagrid-cell-rownumber", panel).last().clone();
            //由于在某些浏览器里面,是不支持获取隐藏元素的宽度,所以取巧一下
            clone.css({
                "position" : "absolute",
                left : -1000
            }).appendTo("body");
            var width = clone.width("auto").width();
            //默认宽度是25,所以只有大于25的时候才进行fix
            if (width > 25) {
                //多加5个像素,保持一点边距
                $(".datagrid-header-rownumber,.datagrid-cell-rownumber", panel).width(width + 5);
                //修改了宽度之后,需要对容器进行重新计算,所以调用resize
                $(this).datagrid("resize");
                //一些清理工作
                clone.remove();
                clone = null;
            } else {
                //还原成默认状态
                $(".datagrid-header-rownumber,.datagrid-cell-rownumber", panel).removeAttr("style");
            }
        });
    }
});
	InitviewScreenEvent(obj);
	obj.LoadEvent(arguments);	
	return obj;
}