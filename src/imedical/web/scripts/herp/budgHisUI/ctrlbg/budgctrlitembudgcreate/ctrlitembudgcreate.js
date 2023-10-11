/*
Creator: Liu XiaoMing
CreatDate: 2018-03-29
Description: 控制项管理-控制项生成
CSPName: herp.budg.hisui.ctrlitembudgcreate.csp
ClassName: herp.budg.hisui.udata.uCtrlItemBudgCreate
、herp.budg.udata.uCtrlItemBudgCreate
 */


var hospid = session['LOGON.HOSPID'];
var userid = session['LOGON.USERID'];

//年度预算样式
function ItemValueStyle(value, row, index){
	var rows = $('#CItemBgGrid').datagrid('getRows');
	var row = rows[index];
	if ((row != null)&&(value!='')&&(value!=null)) {
		value=(parseFloat(value).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
		}
	if (row.isEco==1) {
		return '<a href="#" class="grid-td-text" >' + value + '</a>';
		} else {
		return value;
		}
	} 

//年度下拉框加载前事件
function YearBefLoad(param) {
	param.flag = '';
}
//年度下拉框onselect事件
function onSelectYear(rec){
	$('#itemcb').combogrid('grid').datagrid('options').url = $URL + '?ClassName=herp.budg.hisui.udata.uCtrlItemBudgCreate&MethodName=GetItem';
	$('#itemcb').combogrid('grid').datagrid('reload');

	$('#CItemBgGrid').datagrid('load', {
		ClassName: "herp.budg.hisui.udata.uCtrlItemBudgCreate",
		MethodName: "ListMain",
		hospid: hospid,
		userid: userid,
		year: $('#yearcb').combobox('getValue'),
		itemcode: "",
		deptId: ""
	});
	}

//科目下拉框加载前事件
function ItemBefLoad(param) {
	param.hospid = hospid;
	param.userdr = userid;
	param.year = $('#yearcb').combobox('getValue');
	param.flag = '1^3';
	param.type = '02';
	param.level = '';
	param.supercode = '';
	param.str = param.q;
}
//科目下拉框onselect事件
function onSelectItem(rec){
	var itemGridObj = $('#itemcb').combogrid('grid');	// 获取数据表格对象
	var itemRowObj= itemGridObj.datagrid('getSelected');	// 获取选择的行
	if($('#deptcb').combobox('getValue')){
		var deptid=$("#deptcb").combobox("getValue");
		}
	$('#CItemBgGrid').datagrid('load', {
		ClassName: "herp.budg.hisui.udata.uCtrlItemBudgCreate",
		MethodName: "ListMain",
		hospid: hospid,
		userid: userid,
		year: $('#yearcb').combobox('getValue'),
		itemcode: itemRowObj.code,
		deptId: deptid
	});
	}

//科室下拉框加载前事件触发方法
function DeptBefLoad(param) {
	param.hospid = hospid;
	param.userdr = userid;
	param.flag = '1';
	param.str = '';
}
//科室下拉框onselect事件
function onSelectDept(rec){
	if($('#itemcb').combobox('getValue')){
	    var itemGridObj = $('#itemcb').combogrid('grid');	// 获取数据表格对象
	    var itemRowObj= itemGridObj.datagrid('getSelected');	// 获取选择的行
	    var CCode=itemRowObj.code
	}else{
		var CCode=""		 
		    }
	$('#CItemBgGrid').datagrid('load', {
		ClassName: "herp.budg.hisui.udata.uCtrlItemBudgCreate",
		MethodName: "ListMain",
		hospid: hospid,
		userid: userid,
		year: $('#yearcb').combobox('getValue'),
		itemcode:CCode ,
		deptId: rec.rowid
	});
	}

//获取文本框值方法：$('#hisui-validatebox').val()
//获取下拉框值方法：$('#hisui-combobox').combobox('getValue')

//查询按钮方法
function Search() {
	var itemGridObj = $('#itemcb').combogrid('grid');	// 获取数据表格对象
	var itemRowObj= itemGridObj.datagrid('getSelected');	// 获取选择的行
	
	
	$('#CItemBgGrid').datagrid('load', {
		ClassName: "herp.budg.hisui.udata.uCtrlItemBudgCreate",
		MethodName: "ListMain",
		hospid: hospid,
		userid: userid,
		year: $('#yearcb').combobox('getValue'),
		itemcode: itemRowObj==null ? '' : itemRowObj.code,
		deptId: $('#deptcb').combobox('getValue')
	});
}
//单元格点击事件
function onClickCeYear(index,field){
	var rows = $('#CItemBgGrid').datagrid('getRows');
	var row = rows[index];
	if(row.isEco==1){
		if(field=="ybudgtotal"){
			FYDetailGridShow(hospid, 
							$('#yearcb').combobox('getValue'),
							row.itemcode,
							row.deptdr,
							row.isGov
							)
				}}
	}
	

//采集按钮方法
function Collect() {
	if ($('#yearcb').combobox('getValue')) {
		//弹出遮罩层
		$.messager.progress({
			　　title: '提示',
			　　msg: '预算采集中，请稍候……',
			　　text: ''
		});
		//执行采集预算方法
		$.m({
			ClassName: "herp.budg.hisui.udata.uCtrlItemBudgCreate",
			MethodName: "BgValGen",
			hospid: hospid,
			userid: userid,
			year: $('#yearcb').combobox('getValue')
		},
		 function (rtn) {
			//关闭遮罩层
			$.messager.progress('close');
			if (rtn == 0) {
				//加载页面
				Search();
			} else {
				$.messager.alert('提示', '采集失败' + rtn, 'erro');
			}
		});
	} else {
		$.messager.alert('提示', '请先选择年度！', 'info');
	}
}
