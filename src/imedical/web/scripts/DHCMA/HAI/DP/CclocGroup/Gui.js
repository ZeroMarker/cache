
//左侧工作组Gui
function InitCCLocGroupLocWin(){
   
    obj={
        LocID:"",
        SysUserID:"",
        LocGrpID:"",
        UserID:"",
        UserDesc:"",
        PhoneNum:"",
        type:""
    }
    //工作组类型
    obj.cboLocGrpType = $HUI.combobox("#cboLocGrpType,#cboLocGrpTypeT", {
        url:$URL,
        editable: true,       
        defaultFilter:4,     
        valueField: 'ID',
        textField: 'DicDesc',
        onBeforeLoad: function (param) {
            param.ClassName = 'DHCHAI.BTS.DictionarySrv';
            param.QueryName = 'QryDic';
            param.aTypeCode = 'CCLocGroupType';
            param.aActive = '1';
            param.ResultSetType = 'array'
        },
        onLoadSuccess:function(){  
            var data=$(this).combobox('getData');
            if (data.length>0){
                $(this).combobox('select',data[0]['ID']);
            }
        }
    });
    //医院
	obj.cboHospital = $HUI.combobox("#cboHospital,#cboHospitalT", {
		editable: true,       
		defaultFilter:4,     
		valueField: 'ID',
		textField: 'BTDesc',
		onShowPanel: function () {
			var url=$URL+"?ClassName=DHCHAI.BTS.HospitalSrv&QueryName=QryHospital&ResultSetType=array";
		   	$(this).combobox('reload',url);
		}
	});
    obj.gridLocation = $HUI.datagrid("#gridLocation",{
		fit: true,
		headerCls:'panel-header-gray',
		iconCls:'icon-resort',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		loadMsg:'数据加载中...',
		loading:true,
		pageSize: 20,
		pageList : [20,50,100,200],
        url:$URL,
		queryParams:{
		    ClassName:'DHCHAI.IRS.CCLocGroupSrv',
			QueryName:'QryLoc',
			aHospIDs:$("#cboHospital").combobox('getValue'),
			aGrpType:$("#cboLocGrpType").combobox('getValue'),
			aAlias:$('#searchbox').searchbox('getValue'), 
			aLocCate:"",
			aLocType:"",
			aIsActive:""
		},
		columns:[[
			{field:'LocDesc',title:'科室名称',width:160},
			{field:'LocTypeDesc',title:'科室类型',width:80},
			{field:'LocCateDesc',title:'就诊类型',width:80},
			{field:'HospDesc',title:'医院',width:200},
			{field:'IsOPER',title:'手术科室',width:80},
			{field:'IsICU',title:'重症病房',width:80},
			{field:'IsNICU',title:'新生儿病房',width:80},
			{field:'ICUTpDesc',title:'ICU分类',width:80},
	        {field:'IsActive',title:'是否有效',width:80}
		]],
        onSelect:function(rindex,rowData){
			if (rindex>-1) {
                if (rowData["ID"] == obj.LocID) {
                    obj.LocID="";
                    $("#btnAdd").linkbutton("disable");
                    obj.gridLocation.clearSelections();
                } else {
                    obj.LocID=rowData["ID"]
                    $("#btnAdd").linkbutton("enable");
                }
				obj.gridUserLoad();
			}
		}
	});

	 obj.gridSysUser = $HUI.datagrid("#gridSysUser",{
		fit: true,
		headerCls:'panel-header-gray',
		iconCls:'icon-resort',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
        url:$URL,
		queryParams:{
		    ClassName:'DHCHAI.BTS.SysUserSrv',
			QueryName:'QrySysUserList',
			aLocID:"", 
			aTypeID:"", 
			aUserName:"",
			aUserCode:"", 
			aIsActive:"",
			aHospIDs:$("#cboHospital").combobox('getValue')
		},
		columns:[[
			{field:'ID',title:'ID',width:80},
			{field:'UserCode',title:'用户工号',width:100},
			{field:'UserDesc',title:'用户名称',width:120},
			{field:'LocDesc',title:'科室名称',width:180},
			{field:'TypeDesc',title:'医护类型',width:100},
		    {field:'PhoneNo',title:'手机号',width:135},
	        {field:'ActiveDesc',title:'是否有效',width:80}
		]],
        onSelect:function(rindex,rowData){
			if (rindex>-1) {
                if (rowData["ID"] == obj.SysUserID) {
                    obj.SysUserID="";
                    obj.UserDesc="";
					obj.PhoneNum="";
                    $("#btnEditT").linkbutton("disable");
                    $("#btnAdd").linkbutton("disable");
                    obj.gridSysUser.clearSelections();
                } else {
                    obj.SysUserID=rowData["ID"];
                    obj.UserDesc=rowData["UserDesc"];
					obj.PhoneNum=rowData["PhoneNo"];
                    $("#btnEditT").linkbutton("enable");
                    $("#btnAdd").linkbutton("enable");
                }
                obj.gridLocLoad();
			}
		},
		onLoadSuccess:function(data){
            if (obj.SysUserID=="") {
                $("#btnEditT").linkbutton("disable");
                $("#btnEdit").linkbutton("disable");
            }else{
                $("#btnEditT").linkbutton("enable");
                $("#btnEdit").linkbutton("enable");
            }
			$("#btnEdit").linkbutton("disable");
            $("#btnDelete").linkbutton("disable");
		}
	});
	
    //加载用户公共方法
	$("#cboUser").lookup({
		panelWidth:238,
		url:$URL,
		editable: true,
		mode:'remote',      //当设置为 'remote' 模式时，用户输入的值将会被作为名为 'q' 的 http 请求参数发送到服务器，以获取新的数据。
		valueField: 'ID',
		textField: 'UserDesc',
		queryParams:{
			ClassName: 'DHCHAI.BTS.SysUserSrv',
			QueryName: 'QrySysUserList',
			aIsActive: 1
		},
		columns:[[  
			{field:'UserCode',title:$g('工号'),width:90},
			{field:'UserDesc',title:$g('姓名'),width:100}			
		]],
		onBeforeLoad:function(param){
			var desc=param['q']; 
			param = $.extend(param,{aUserName:desc}); //将参数q转换为类中的参数
		},
		onSelect:function(index,rowData){
			 obj.UserID=rowData['ID'];
		},
		pagination:true,
	    showPageList:false, showRefresh:false,displayMsg:'',
		loadMsg:'正在查询',
		isCombo:true,             //是否输入字符即触发事件，进行搜索
		minQueryLen:1             //isCombo为true时，可以搜索要求的字符最小长度
	});

    InitCCLocGroupLocWinEvent(obj);
    return obj;
}
function loadgridUser(){
	var TabDataGrid = $HUI.datagrid("#gridUser",{
		fit: true,
		title: '责任人维护',
		headerCls:'panel-header-gray',
		iconCls:'icon-resort',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		loadMsg:'数据加载中...',
		loading:true,
		pageSize: 20,
		pageList : [20,50,100,200],
        url:$URL,
		queryParams:{
		    ClassName:'DHCHAI.IRS.CCLocGroupSrv',
			QueryName:'QryUser',
			aGrpType:$("#cboLocGrpType").combobox('getValue'),
			aLocID:"",
            aAlias:$('#searchbox').searchbox('getValue'), 
			aIsActive:""
		},
		columns:[[
			{field:'UserCode',title:'用户工号',width:100},
            {field:'UserDesc',title:'用户名称',width:120},
            {field:'PhoneNo',title:'手机号',width:135},
            {field:'BTEffectDate',title:'生效日期',width:100},
            {field:'BTExpiryDate',title:'截止日期',width:100},
			{field:'IsActive',title:'是否有效',width:80},
            {field:'UpdateDate',title:'更新日期',width:120},
			{field:'UpdateUser',title:'更新人员',width:100}
			
		]],
        onSelect:function(rindex,rowData){
			if (rindex>-1) {
                if (rowData["ID"] == obj.LocGrpID) {
                    obj.LocGrpID="";
                    $("#btnAdd").linkbutton("enable");
                    $("#btnEdit").linkbutton("disable");
                    $("#btnDelete").linkbutton("disable");
                    $('#gridUser').datagrid('clearSelections');
                } else {
                    obj.LocGrpID=rowData["ID"];
                    $("#btnAdd").linkbutton("disable");
                    $("#btnEdit").linkbutton("enable");
                    $("#btnDelete").linkbutton("enable");
                }
				
			}
		},
		onLoadSuccess:function(data){
            if ((obj.LocID=="")&&(obj.SysUserID=="")) {
                $("#btnAdd").linkbutton("disable");
            }else{
                $("#btnAdd").linkbutton("enable");
            }
			$("#btnEdit").linkbutton("disable");
            $("#btnDelete").linkbutton("disable");
		}
	});
}

function loadgridLoc(){
	var TabDataGrid = $HUI.datagrid("#gridUser",{
		fit: true,
		title: '责任科室维护',
		headerCls:'panel-header-gray',
		iconCls:'icon-resort',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		loadMsg:'数据加载中...',
		loading:true,
		pageSize: 20,
		pageList : [20,50,100,200],
        url:$URL,
		queryParams:{
		    ClassName:'DHCHAI.IRS.CCLocGroupSrv',
			QueryName:'QryUserLocGroup',
			aHospIDs:$("#cboHospitalT").combobox('getValue'),
			aGrpType:$("#cboLocGrpTypeT").combobox('getValue'),
			aUserID: obj.SysUserID
		},
		columns:[[
			{field:'ID',title:'ID',width:80},
            {field:'LocCode',title:'科室代码',width:120},
            {field:'LocDesc',title:'科室名称',width:135},
            {field:'LocTypeDesc',title:'科室类型',width:100},
            {field:'LocCateDesc',title:'就诊类型',width:100},
            {field:'EffectDate',title:'生效日期',width:120},
			{field:'ExpiryDate',title:'截止日期',width:120},
			{field:'IsActDesc',title:'是否有效',width:80}
		]],
        onSelect:function(rindex,rowData){
			if (rindex>-1) {
                if (rowData["ID"] == obj.LocGrpID) {
                    obj.LocGrpID="";
                    $("#btnAdd").linkbutton("enable");
                    $("#btnEdit").linkbutton("disable");
                    $("#btnDelete").linkbutton("disable");
                    $('#gridUser').datagrid('clearSelections');
                } else {
                    obj.LocGrpID=rowData["ID"];
                    $("#btnAdd").linkbutton("disable");
                    $("#btnEdit").linkbutton("enable");
                    $("#btnDelete").linkbutton("enable");
                }
			}
		},
		onLoadSuccess:function(data){
            if ((obj.LocID=="")&&(obj.SysUserID=="")) {
                $("#btnAdd").linkbutton("disable");
            }else{
                $("#btnAdd").linkbutton("enable");
            }
			$("#btnEdit").linkbutton("disable");
            $("#btnDelete").linkbutton("disable");
		}
	});
}


$(function(){
    InitCCLocGroupLocWin();
    loadgridUser();

})

