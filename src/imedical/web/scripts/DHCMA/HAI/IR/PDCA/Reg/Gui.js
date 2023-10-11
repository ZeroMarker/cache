//页面Gui
var objScreen = new Object();
function InitPARegWin() {
	
    var obj = objScreen;
    //获取用户是否管理员
    obj.AdminPower = '0';
    if (typeof tDHCMedMenuOper != 'undefined') {
        if (typeof tDHCMedMenuOper['Admin'] != 'undefined') {
            obj.AdminPower = tDHCMedMenuOper['Admin'];
        }
    }
    //获取标题
    if( obj.AdminPower!='1')obj.Title=$g("PDCA项目登记");
    //权限控制
    $("#custtb").append('<div style="padding: 7px 0 9px 7px;"><input class="hisui-searchbox" id="searchbox" style="width:260px;" data-options="prompt:\''+$g("搜索")+'\'" /></div>');	  
    $("#custtb").append('<span class="line" style="display: block;border-bottom: 1px dashed rgb(204, 204, 204);margin: 1px 0px;clear: both;/* padding-bottom: 5px; */"></span>');
    if (obj.AdminPower=="1"){
	   	//加载头部链接
   		var ModList = $cm({
        	ClassName: "DHCHAI.IRS.PDCAModSrv",
        	QueryName: "QryPDCAModBase",
        	aIsActive: 1
   	 	}, false);
    	for(var ind=0;ind<ModList.total;ind++){
    		var ModData=ModList.rows[ind];
    		if(ModData=="")continue;
    	
    		var ModName=ModData.ModName;
    		$("#custtb").append('<a class="hisui-linkbutton" data-options="iconCls:\'icon-add\',plain:true,stopAllEventOnDisabled:true" text="' + ModData.ModID + '"  href="#">登记'+ModName+'</a>');
    	}	
	}
    $("#custtb").append('<a class="hisui-linkbutton" text="btnExport" data-options="iconCls:\'icon-export\',plain:true">导出</a>');
    $.parser.parse("#custtb"); // 解析整个页面
    //获取查询方式(按整改科室/用户)
    var RegType = $m({ 
		ClassName: "DHCHAI.BT.Config",
		MethodName: "GetValByCode",
		aCode: "PDCARegByType"
	}, false);
	//获取是否护士长/科主任
    obj.GroupDesc = session['LOGON.GROUPDESC'];
    var SupNurFlg = 0;
    var SupDocFlg = 0;
    if (obj.GroupDesc.indexOf('护士长') > -1) {
        SupNurFlg = 1;      //护士长
    }
    if (obj.GroupDesc.indexOf('主任') > -1) {
        SupDocFlg = 1       //科主任·
    }
    
    //加载登录科室+登录用户
    //1.管理员查看所有PDCA报告
    //2.按'科室'查询时,只能查询本科室数据
    //3.按'用户'查询时,只能查询本人数据(科主任/护士长除外)
    if (obj.AdminPower=="1"){
		obj.aLocID="";
		obj.aUserID="";
	}
	else{
		if (RegType=="1"){				
	    	obj.aLocID=$.LOGON.LOCID;	
			obj.aUserID="";
		}
		else{
			if((SupNurFlg==1)||(SupDocFlg==1)){
				obj.aLocID=$.LOGON.LOCID;
				obj.aUserID="";
			}
			else{
				obj.aLocID=$.LOGON.LOCID;
				obj.aUserID=$.LOGON.USERID;
			}
		}
	}
    
    //PDCA项目登记
    obj.gridPAReg = $HUI.datagrid("#gridPAReg", {
	    title:obj.Title,
		fit: true,
		iconCls:"icon-resort",
		headerCls:'panel-header-gray',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false,//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		ClassTableName:'DHCHAI.IR.PDCAReg',
		pageSize: 20,
		pageList : [20,50,100],
		columns:[[
			{ field: 'RepID', title: 'ID', width: 50},
			{ field: 'ItemType', title: '项目类型', width: 200,},
			{ field: 'ItemDesc', title: '项目名称', width: 200},
			{ field: 'IndexDesc', title: '指标名称', width: 200},
            { field: 'RegDate', title: '登记日期', width: 120},
            { field: 'RegLocDesc', title: '登记科室', width: 120},
            { field: 'RegUserDesc', title: '登记人', width: 100},
			{ field: 'TargetVal', title: '目标值', width: 100},
            { field: 'PlanLocDesc', title: '整改科室', width: 150},
            {
                field: 'PALocStatus', title: '状态', width: 100,
                formatter: function (value, row, index) {
                    return "<a href='#' onclick='objScreen.OpenPDCARep(\"" + row.ModTypeID + "\"," + "\"" + row.RepID + "\","+ "\"" + row.SubID + "\"," + "\"" +  obj.AdminPower+"\");'>" + $g(value) + "</a>";
                }
            },
			{ field: 'PlanAdminUserDesc', title: '院感科责任人', width: 120},
            { field: 'PlanLocUserDesc', title: '整改科室责任人', width: 120},
            { field: 'DoASttDate', title: '整改实际开始日期', width: 130},
            { field: 'DoPEndDate', title: '整改预计结束日期', width: 130},
            { field: 'DoUserDesc', title: '提交人', width: 120},
            { field: 'DoAEndDate', title: '整改实际结束日期', width: 130},
            { field: 'AssessDesc', title: '效果评价', width: 120},
		]],
		onDblClickRow: function (rowIndex, rowData) {
			if(rowIndex>-1){
			    var aModTypeID = rowData.ModTypeID;
			    var aReportID = rowData.RepID;

			    obj.OpenPDCARep(aModTypeID,aReportID,obj.AdminPower);   //打开PDCA报告
			}
		},
        onLoadSuccess: function (data) {
	        $(this).prev().find('div.datagrid-body').prop('scrollTop',0);  //如果有滚动条，滚动到最上面
        	$(this).datagrid('columnMoving'); //列可以拖拽改变顺序
        	
	        if (data.total > 0) {
	        	dispalyEasyUILoad(); 			//隐藏效果
             	//合并单元格实现表格样式
	    	 	$(this).datagrid("autoMergeCellAndCells", ['RepID','ItemType','ItemDesc','IndexDesc','RegDate']);    	//合并行
            }
        }
	});
	ShowUserHabit('gridPAReg');
	
	InitPARegWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}