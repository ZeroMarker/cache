//ICU调查登记表查询
function InitRepqryWinEvent(obj) {
    //初始化信息
    obj.LoadEvent = function () {
        obj.cboHospital = Common_ComboToSSHosp("cboHospital", $.LOGON.HOSPID);  //初始化医院
        obj.dtDateFrom = $('#dtDateFrom').datebox('setValue', Common_GetDate(new Date()));  // 开始日期赋值
        obj.dtDateTo = $('#dtDateTo').datebox('setValue', Common_GetDate(new Date()));  // 结束日期赋值
    }
    //院区改变事件
    $HUI.combobox('#cboHospital', {
        onSelect: function () {
            obj.refreshICULoc();   //更新科室
        }
    });
    //开始日期改变事件
    $HUI.datebox('#dtDateFrom', {
        onChange: function (newValue, oldValue) {
	        if (!oldValue) return ;
           	obj.refreshgridNICULogs();  //刷新NICU登记表表格
        }
    })
    //结束日期改变事件
    $HUI.datebox('#dtDateTo', {
        onChange: function (newValue, oldValue) {
	        if (!oldValue) return;
            obj.refreshgridNICULogs();  //刷新NICU登记表表格
        }
    })
    //病区改变事件
    $HUI.combobox('#cboLocal', {
        onSelect: function (rowData) {
            obj.IsNICU = rowData['IsNICU'];
            obj.refreshgridNICULogs();  //刷新NICU登记表表格
        }
    });
    //插管类型改变事件
    $HUI.combobox('#cboTubeType', {
        onSelect: function () {
            obj.refreshgridNICULogs();  //刷新NICU登记表表格
        }
    });
    //在-出院改变事件
    $HUI.radio("[name='chkAdmStatus']", {
        onChecked:function(e,value){
           obj.refreshgridNICULogs();  //刷新NICU登记表表格
        },
        onUnchecked:function(e,value){
           obj.refreshgridNICULogs();  //刷新NICU登记表表格
        }
    });
    //NICU调查登记表导出事件
    $('#btnNICUExport').on('click', function () {
	    var rows = obj.gridNICULogs.getRows();  //返回当前页的所有行
        if(rows.length==0){
	        $.messager.alert("错误","当前界面没有数据，无法导出!", 'info');
			return;
	    }
        $('#gridNICULogs').datagrid('toExcel', 'NICU调查登记表.xls'); 
    });
    //NICU调查登记表检索框
    $('#searchNICUbox').searchbox({
        searcher: function (value, name) {
            searchText($("#gridNICULogs"), value);
        }
    });
    //刷新NICU登记表
    obj.refreshgridNICULogs = function () {
        $('#LayerICULogs').hide();
        $('#LayerNICULogs').show();

        var aHospID = $('#cboHospital').combobox('getValue');   //院区
        var aDateFrom = $('#dtDateFrom').datebox('getValue'); //开始时间
        var aDateTo = $('#dtDateTo').datebox('getValue');   //结束时间
        var aLocID = $('#cboLocal').combobox('getValue');       //ICU科室ID
        var aTubeType = $('#cboTubeType').combobox('getValue'); //插管类型
        var aAdmSatus = Common_CheckboxValue('chkAdmStatus');   //病人状态(住院/出院)
        if ((aDateFrom == "") || (aDateTo == "")) return;
        if (aDateFrom > aDateTo) {
            $.messager.alert("提示", "开始日期不能大于结束日期!", 'info');
            return;
        }
        if (aDateFrom > Common_GetDate(new Date())) {
            $.messager.alert("提示", "开始日期不能大于当前日期!", 'info');
            return;
        }
        $("#gridNICULogs").datagrid("loading"); //加载中提示信息
        $cm({
            ClassName: 'DHCHAI.IRS.INFICUPICCSrv',
            QueryName: 'QryICUAdmByStatus',
            ResultSetType: "array",
            aSttDate: aDateFrom,
            aEndDate: aDateTo,
            aLocDr: aLocID,
            aStatus: aAdmSatus,
            aType: 3,
            aIntuType: aTubeType,
            aEpisodeID: EpisodeID,
            page: 1,
            rows: 200
        }, function (rs) {
            $('#gridNICULogs').datagrid({ loadFilter: pagerFilter }).datagrid('loadData', rs);
        });
    }
    //打开
    obj.OpenICUReport = function (Paadm, RepID) {
        var LocDr = $('#cboLocal').combobox('getValue');
        //打开NICU调查登记表
       	var strUrl = "./dhcma.hai.ir.nicu.report.csp?aLocDr=" + LocDr + "&aPaadm=" + Paadm + "&aRepID=" + RepID;
       	websys_showModal({
       		url: strUrl,
       		title: 'NICU调查表填写',
       		iconCls: 'icon-w-epr',
            width: 1320,
          	height: '90%',
          	onBeforeClose: function () {
            	obj.refreshgridNICULogs();
          	}
    	});
    }
    //刷新NICU病区
    obj.refreshICULoc = function () {
        var cbox = $HUI.combobox("#cboLocal", {
            url: $URL,
            editable: true,
            allowNull: true,
            defaultFilter: 4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
            valueField: 'ID',
            textField: 'LocDesc2',
            IsNICUField: 'IsNICU',
            onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
                param.ClassName = 'DHCHAI.BTS.LocationSrv';
                param.QueryName = 'QryICULoc';
                param.aHospIDs = $('#cboHospital').combobox('getValue');
                param.aLocID = "";
                param.aTypeID=2;
                param.ResultSetType = 'array';
            },
            onLoadSuccess: function () {   //初始加载赋值--默认第一个科室
                var data = $(this).combobox('getData');
                if (data != "") {
                    $(this).combobox('select', data[0]['ID']);
                }
            }
        });
    }
}