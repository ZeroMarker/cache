//手术切口调查表[Gui]
var obj = new Object();
function InitLocUserWin() {
	obj.RecRowID="";
	//obj.cboHospital = Common_ComboToSSHosp("cboHospital",$.LOGON.HOSPID);
	//字典
	obj.cboIncision = Common_ComboDicID('cboIncision', 'CuteType');
	//科室
	obj.cboLoction = Common_ComboToLoc('cboLoc',"");
	//用户
	$HUI.combobox("#cboUser", {
        url: $URL,
        editable: true,
        //allowNull: true, 
        defaultFilter:4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
        valueField: 'ID',
        textField: 'UserDesc',
        onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
            param.ClassName = 'DHCHAI.BTS.SysUserSrv';
            param.QueryName = 'QrySysUser';
            param.aActive = 1;
            param.ResultSetType = 'array';
        }
    });
	 
	
    obj.gridLocUser = $HUI.datagrid("#gridLocUser", {
		fit:true,
        title:'科室联络员查询',
        headerCls:'panel-header-gray',
        iconCls:'icon-resort',
        pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
        singleSelect: true,
		rownumbers: false, //如果为true, 则显示一个行号列
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
        loadMsg:'数据加载中...',
		loading:true,
		//是否是服务器对数据排序
		sortOrder:'asc',
		remoteSort:false,
		pageSize: 50,
		pageList : [50,100,200,1000,10000],
		//xID,xLocID,LocDesc2,UserID,UserCode,UserName,UserType,PhoneNo,EffectDate,ExpiryDate,IsActive,ActDate,ActTime,ActUserID,ActUserName
        columns: [[
            { field: 'LocDesc2', title: '科室名称', width: 200, align: 'left',sortable:true},
			{ field: 'UserCode', title: '用户工号', width: 200, align: 'left',showTip:true,sortable:true},
			{ field: 'UserName', title: '用户名称', width: 200, align: 'left',showTip:true,sortable:true},
            { field: 'PhoneNo', title: '手机号', width: 150, align: 'left',sortable:true},
            { field: 'EffectDate', title: '生效日期', width: 100, align: 'left',sortable:true,sorter:Sort_int},
			{ field: 'ExpiryDate', title: '截止日期', width: 100, align: 'left',sortable:true,sorter:Sort_int},
            { field: 'IsActive', title: '是否有效', width: 80, align: 'left',sortable:true},
            { field: 'ActDate', title: '更新日期', width:100, align: 'left',sortable:true},
            { field: 'ActUserName', title: '更新人员', width:150, align: 'left',sortable:true}
		]],	
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridLocUser_onSelect();
			}
		},
		ondblclick:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridLocUser_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //隐藏效果
		}
	});
	
    InitLocUserEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}
$(function(){
	InitLocUserWin();
})