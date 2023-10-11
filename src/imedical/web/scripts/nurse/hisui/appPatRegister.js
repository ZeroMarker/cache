/**
 * @author songchao 
 * @description 预约登记界面 20180627
 */
var GV={
    IPBookInfo:{}
}
/*-----------------------------------------------------------*/
var init = function () {
    initSearchCondition();
    initEvent();
    initData();
}
$(init)
/*-----------------------------------------------------------*/
/**
 * @description 元素绑定事件
 */
function initEvent() {
    $('#findBookListBtn').bind('click', findBookPat);
    $('#getPatByBookNoBtn').bind('click', getPatByBookNo);
    $('#appointBtn').bind('click', appointBtnClick);
    $('#cancelAppBtn').bind('click', cancelAppBtnClick);
    $('#voidAppBtn').bind('click', voidAppBtnClick);
    $('#clearAppointBtn').bind('click', clearAppointBtnClick);
    $('#bookPatGrid').datagrid({ onClickRow: bookPatGridClickRow });
    $('#bookNoInput').bind('keydown', function (e) {
        if (e.keyCode == 13) {
            getPatByBookNo();
        }
    });
    $('#appStatusSwitch').switchbox('options').onSwitchChange = findBookPat;
}
/**
 * @description 初始化数据
 */
function initData() {
    findBookPat();
	
}
/**
 * @description 初始化住院证列表查询条件
 */
function initSearchCondition() {
    $('#bookStartDate').datebox('setValue', dateCalculate(new Date(), -3));
    $('#bookEndDate').datebox('setValue', formatDate(new Date()));
    $('#bookDocBox').combobox({
        valueField: 'ID',
        textField: 'name',
    });
    $('#bookLocBox').combobox({
        valueField: 'ID',
        textField: 'desc',
        url: $URL + '?ClassName=Nur.InService.AppPatRegister&MethodName=getLocs&locType=E&HospID='+session['LOGON.HOSPID'],
        onSelect: function (record) {
			$('#bookDocBox').combobox('setValue','');
            $('#bookDocBox').combobox('options').url = $URL + '?ClassName=Nur.InService.AppPatRegister&MethodName=getMainDoctors&locID=' + record.ID;
            $('#bookDocBox').combobox('reload');
        },
		onChange:function(desc,val){
			if(!desc&&val==""){
				$('#bookDocBox').combobox('clear');
				$('#bookDocBox').combobox('loadData', {});//清空option选项   
				
			}
		},
		filter: function (q, row) {
			var opts = $(this).combobox('options');
			var text = row[opts.textField]; //下拉的对应选项的汉字
			var pyjp =getPinyin(text).toLowerCase(); //根据选项名字转换对应的拼音首字母并转换为小写
			if (row[opts.textField].indexOf(q) > -1 || pyjp.indexOf(q.toLowerCase()) > -1) {
				return true;
			}
			return false;
		}
    });
    $('#bookWardBox').combobox({
        valueField: 'ID',
        textField: 'desc',
        url: $URL + '?ClassName=Nur.InService.AppPatRegister&MethodName=getLocs&locType=W&HospID='+session['LOGON.HOSPID'],
		filter: function (q, row) {
			var opts = $(this).combobox('options');
			var text = row[opts.textField]; //下拉的对应选项的汉字
			var pyjp =getPinyin(text).toLowerCase(); //根据选项名字转换对应的拼音首字母并转换为小写
			if (row[opts.textField].indexOf(q) > -1 || pyjp.indexOf(q.toLowerCase()) > -1) {
				return true;
			}
			return false;
		}
    });
	 $('#WardDescBookI').combobox({
        valueField: 'LOCID',
        textField: 'desc',
	 	url: $URL + '?ClassName=Nur.InService.AppPatRegister&MethodName=getLocs&locType=W&HospID='+session['LOGON.HOSPID'],
	 	filter: function (q, row) {
	 		var opts = $(this).combobox('options');
	 		var text = row[opts.textField]; //下拉的对应选项的汉字
	 		var pyjp = getPinyin(text).toLowerCase(); //根据选项名字转换对应的拼音首字母并转换为小写
	 		if (row[opts.textField].indexOf(q) > -1 || pyjp.indexOf(q.toLowerCase()) > -1) {
	 			return true;
	 		}
	 		return false;
	 	}
	 });

}
/**
 * @description 查询住院证列表
 */
function findBookPat() {
    clearAppointBtnClick();
    var startDate = $('#bookStartDate').datebox('getValue');
    var endDate = $('#bookEndDate').datebox('getValue');
    var bookLoc = $('#bookLocBox').combobox('getValue');
    var bookWard = $('#bookWardBox').combobox('getValue');
    var bookDoctor = $('#bookDocBox').combobox('getValue');
    var patName = $('#patName').val();
    var appStatusSwitch = $('#appStatusSwitch').switchbox('getValue');
	
	$('#bookPatGrid').datagrid({
			url: $URL,
			queryParams: {
				ClassName: 'Nur.InService.AppPatRegister',
				QueryName: 'FindInBookList',
				StartDate: startDate,
				EndDate: endDate,
				BookLoc: bookLoc,
				BookWard: bookWard,
				BookDoctor: bookDoctor,
				PatName: patName,
                IPAppStatus: appStatusSwitch,
                HospID:session['LOGON.HOSPID']
			},
			pagination: true,
			pageSize: 15,
			pageList: [15,30,60,120]
		});
	/*
    $cm({
        ClassName: "Nur.InService.AppPatRegister",
        MethodName: "getInBookList",
        StartDate: startDate,
        EndDate: endDate,
        BookLoc: bookLoc,
        BookWard: bookWard,
        BookDoctor: bookDoctor,
        PatName: patName,
        IPAppStatus: appStatusSwitch
    }, function (jsonData) {
        $('#bookPatGrid').datagrid({ data: jsonData })
    })*/
}
/**
 * @description 根据住院证号查询患者
 */
function getPatByBookNo() {
    var bookNO = $('#bookNoInput').val();
    $cm({
        ClassName: "Nur.InService.AppPatRegister",
        MethodName: "getPatByBookNo",
        BookNO: bookNO
    }, function (jsonData) {
        if (String(jsonData.success) === '0') {
            GV.IPBookInfo=jsonData;
            setPatInfo(jsonData.PatInfo);
            setBookInfo(jsonData.BookInfo);
        } else {
            $.messager.show({
                title: '查询失败',
                msg: jsonData.errInfo,
                timeout: 5000,
                showType: 'slide'
            });
        }
    });
}
/**
 * @description 设置页面患者信息值
 * @param {} patInfo :患者信息json对象
 */
function setPatInfo(patInfo) {
    for (var item in patInfo) {
        var domID = "#" + item + "PatI";
        $(domID).val(patInfo[item]);
    }
}
/**
 * @description 设置页面预约信息值
 * @param {} bookInfo :预约信息json对象
 */
function setBookInfo(bookInfo) {
    for (var item in bookInfo) {
        var domID = "#" + item + "BookI";
        if (item == "WardDesc") {
			var loadUrl=$URL + '?ClassName=Nur.InService.AppointPatManage&MethodName=getLocLinkWard&cLoc=' 
			+ bookInfo.LocID + '&WardFlag=' + bookInfo.WardType+"&BookID="+bookInfo.IPBookID;
			$('#WardDescBookI').combobox('reload',loadUrl);
            $(domID).combobox('select', bookInfo.WardLocID);
        } else {
            $(domID).val(bookInfo[item]);
        }
    }
    $('#CollectDateBookI').datebox('setValue', formatDate(new Date()));
}
/**
 * @description 预约患者列表双击查询
 * @param {*} rowIndex 
 * @param {*} rowData 
 */
function bookPatGridClickRow(rowIndex, rowData) {
    $('#bookNoInput').val(rowData.IPBookNo);
    $('#WardDescBookI').combobox({
        valueField: 'LOCID',
        textField: 'desc',
        url: $URL + '?ClassName=Nur.InService.AppointPatManage&MethodName=getLocLinkWard&cLoc=' + rowData.CTLocID + '&WardFlag=' + rowData.WardType+"&BookID="+rowData.IPBookID
    });
    getPatByBookNo();    
}
/**
 *@description 预约按钮操作
 */
function appointBtnClick() {
    var wardLocID = $('#WardDescBookI').combobox('getValue');
    var bookNO = $('#bookNoInput').val();
    var appDate = $('#BookingDateBookI').val();
    var userID = session['LOGON.USERID'];
    if (bookNO !=""&&appDate!= "") {
    	$cm({
    		ClassName: "Nur.InService.AppPatRegister",
    		MethodName: "saveIPAppointmentInfo",
    		BookNO: bookNO,
    		WardLocID: wardLocID,
    		AppDate: appDate,
    		UserID: userID
    	}, function (jsonData) {
    		if ((!jsonData.msg) && String(jsonData.success) === '0') {
    			$.messager.popover({
    				msg: '预约登记成功!',
    				type: 'success'
    			});
    			findBookPat();
    			clearAppointBtnClick();
    		} else {
    			$.messager.show({
    				title: '登记失败',
    				msg: jsonData.msg ? jsonData.msg : jsonData.errInfo,
    				timeout: 5000,
    				showType: 'slide'
    			});
    		}
    	});
    }
	else{
		$.messager.popover({msg:'请选择或输入要登记患者的信息!',type:'alert'});
	}
}
/**
 *@description 清除登记表单
 */
function clearAppointBtnClick() {
    $('#registerForm').form('clear');
    GV.IPBookInfo={};
}
/**
 * @description  弹出作废对话框
 */
function voidAppBtnClick(){
    if(GV.IPBookInfo.BookInfo){
        $('#voidAppDlg').dialog('open');
        $('#voidReasonBox').combobox({ 
            valueField: 'id',
            textField: 'desc',
            url: $URL + '?ClassName=Nur.InService.AppPatRegister&MethodName=findCancelReason&HospID='+session['LOGON.HOSPID']});
        $('#confirmVoidBtn').bind('click',confirmVoidBtnClick);   
        $('#closeDlgBtn').bind('click',function(){$('#voidAppDlg').dialog('close');});   
    }else{
        $.messager.popover({msg:"未选择有效信息!",type:"alert"});
    }
}

function confirmVoidBtnClick(){
    var bookID=GV.IPBookInfo.BookInfo.IPBookID;
    var userID=session['LOGON.USERID'];
    var cancleID= $('#voidReasonBox').combobox('getValue');
	//设置弹窗
	if(cancleID =='') {
    	$.messager.popover({msg:"作废原因不能为空:请选择作废原因!",type:"error"});
    	return;
    }
    //
    $m({
        ClassName: "Nur.InService.AppPatRegister",
        MethodName: "voidApp",
        IPBookID:bookID,
        CancleID:cancleID,
        UserID:userID
    },function(txtData){
        if(txtData=="0"){
            $('#voidAppDlg').dialog('close');
            $.messager.popover({msg:"作废成功",type:"success"});
            findBookPat();
            clearAppointBtnClick();
        }
        else{
            $('#voidAppDlg').dialog('close');
            $.messager.popover({msg:"作废失败:"+txtData,type:"error"});
        }
    })
}

function cancelAppBtnClick(){
    var bookID=GV.IPBookInfo.BookInfo.IPBookID;
    var userID=session['LOGON.USERID'];
    $m({
        ClassName: "Nur.InService.AppPatRegister",
        MethodName: "cancelApp",
        IPBookID:bookID,
        UserID:userID
    },function(txtData){
        if(txtData=="0"){
            $.messager.popover({msg:"取消登记成功",type:"success"});
            findBookPat();
            clearAppointBtnClick();
        }
        else{
            $.messager.popover({msg:"取消登记失败:"+txtData,type:"error"});
        }
    })
}