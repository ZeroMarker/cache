/**
 * @author songchao 
 * @description ��λԤԼ���� 20180703
 */
var GV = {
    ClassName: "Nur.InService.AppointPatManage"
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
 * @description Ԫ�ذ��¼�
 */
function initEvent() {
    $('#findAppPatListBtn').bind('click', findAppPatList);;
    $('#appPatGrid').datagrid({
        onClickRow: appPatGridClickRow,
        onLoadSuccess: appPatGridLoadSuccess,
        rowStyler: function(index,row){
            if (row.IsDayFlag=="DaySurg"){
                return 'color:red;';
            }
        }
    });
    $('#bookNoInput').bind('keydown', function (e) {
        if (e.keyCode == 13) {
            getAppInfo();
        }
    });
	$('#regNO').bind('keydown', function (e) {
        if (e.keyCode == 13) {
			var regNO=$('#regNO').val();
			if (regNO.length<10) {
				for (var i=(10-regNO.length-1); i>=0; i--) {
					regNO="0"+regNO;
				}
			}
			$('#regNO').val(regNO);
			findAppPatList(true);
        }
    });
    $('#appStatusSwitch').switchbox('options').onSwitchChange = findAppPatList;
    $('#wardSearchbox').searchbox({ searcher: wardSearcher });
    $('#wardGrid').datagrid({ onClickRow: wardGridClickRow });
    initBedGrid();   
    $('#AppDateAppI').datebox({ onSelect: appDateAppIClick });
	$HUI.radio("[name='bedSexRadio']",{
            onChecked:bedSexRadioCheckChange
        });
}

/**
 * @description ��ʼ������
 */
function initData() {
    findAppPatList(false);
    $('#WardDescBookI').combobox({
        valueField: 'ID',
        textField: 'desc',
        url: $URL + '?ClassName=Nur.InService.AppPatRegister&MethodName=getLocs&locType=W&HospID='+session['LOGON.HOSPID'],
    })
}
/**
 * @description ��λ�б��в�����ť(����,ȡ������)
 * @param {} val 
 * @param {*} row 
 * @param {*} index 
 */
function bedGridRowOper(val, row, index) {
    var appStatusSwitch = $('#appStatusSwitch').switchbox('getValue');
    if (appStatusSwitch) {
        btns = '<a href="#" class="allotBtn" onclick="allotBtnClick(\'' + String(row.BedId) + '\')"></a>'; //+ '\',\'' + String(row.TransCount) 
    } else {
        btns = '<a href="#" class="cancleBtn" onclick="cancleBtnClick(\'' + String(GV.IPAppID) + '\')"></a>';
    }
    return btns;
}

/**
 *@description ��ʼ��bedGrid��ť�������¼�������
 *
 */
function initBedGrid() {
    $('#bedGrid').datagrid('getColumnOption', 'Operate').formatter = bedGridRowOper;
    $('#bedGrid').datagrid({
        onLoadSuccess: function () {
            $('.allotBtn').linkbutton({ plain: true, iconCls: 'icon-bed' });
            $('.cancleBtn').linkbutton({ plain: true, iconCls: 'icon-remove' });
        }
    });
}

/**
 * @description ��ʼ��ԤԼ�Ǽ��б��ѯ����
 */
function initSearchCondition() {

    $('#appStartDate').datebox('setValue', dateCalculate(new Date(), -10));
    $('#appEndDate').datebox('setValue', formatDate(new Date()));
    $('#bookDocBox').combobox({
        valueField: 'ID',
        textField: 'name',
    });
    $('#appLocBox').combobox({
        valueField: 'ID',
        textField: 'desc',
        url: $URL + '?ClassName=Nur.InService.AppPatRegister&MethodName=getLocs&locType=E&HospID='+session['LOGON.HOSPID'],
        onSelect: function (record) {
			$('#bookDocBox').combobox('clear');
            $('#bookDocBox').combobox('options').url = $URL + '?ClassName=Nur.InService.AppPatRegister&MethodName=getMainDoctors&locID=' + record.ID;
            $('#bookDocBox').combobox('reload');
        },
		onChange:function(desc,val){
			if(!desc&&val==""){
				$('#bookDocBox').combobox('clear');
				$('#bookDocBox').combobox('loadData', {});//���optionѡ��   
				
			}
		},
		filter: function (q, row) {
			var opts = $(this).combobox('options');
			var text = row[opts.textField]; //�����Ķ�Ӧѡ��ĺ���
			var pyjp =getPinyin(text).toLowerCase(); //����ѡ������ת����Ӧ��ƴ������ĸ��ת��ΪСд
			if (row[opts.textField].indexOf(q) > -1 || pyjp.indexOf(q.toLowerCase()) > -1) {
				return true;
			}
			return false;
		}
    });
    $('#appWardBox').combobox({
        valueField: 'ID',
        textField: 'desc',
        url: $URL + '?ClassName=Nur.InService.AppPatRegister&MethodName=getLocs&locType=W&HospID='+session['LOGON.HOSPID'],
		filter: function (q, row) {
			var opts = $(this).combobox('options');
			var text = row[opts.textField]; //�����Ķ�Ӧѡ��ĺ���
			var pyjp =getPinyin(text).toLowerCase(); //����ѡ������ת����Ӧ��ƴ������ĸ��ת��ΪСд
			if (row[opts.textField].indexOf(q) > -1 || pyjp.indexOf(q.toLowerCase()) > -1) {
				return true;
			}
			return false;
		}
    })

}
/**
 * @description ��ѯסԺ֤�б�
 */
function findAppPatList(showErr) {
    var bookNO = $('#bookNO').val();
    var regNO = $('#regNO').val();
    var startDate = $('#appStartDate').datebox('getValue');
    var endDate = $('#appEndDate').datebox('getValue');
    var appLoc = $('#appLocBox').combobox('getValue');
    var appWard = $('#appWardBox').combobox('getValue');
    var appDoctor = $('#bookDocBox').combobox('getValue');
    var patName = $('#patName').val();
    var appStatusSwitch = $('#appStatusSwitch').switchbox('getValue');
    $cm({
        ClassName: GV.ClassName,
        MethodName: "getAppPatList",
        BookNO: bookNO,
        RegNO: regNO,
        StartDate: startDate,
        EndDate: endDate,
        AppLoc: appLoc,
        AppWard: appWard,
        AppDoc: appDoctor,
        PatName: patName,
        AppState: appStatusSwitch,
		HospID: session['LOGON.HOSPID']
    }, function (jsonData) {
        clearScrean();
        $('#appPatGrid').datagrid({ data: jsonData });
		if(showErr&&jsonData.length<1){
			$.messager.popover({msg:'δ��ѯ�����������Ļ�����Ϣ!',type:'alert'});
		}
    })
}
/**
 * @description ����סԺ֤�Ų�ѯ����
 */
function getAppInfo(bookNO) {
    $cm({
        ClassName: GV.ClassName,
        MethodName: "getAppInfo",
        BookNO: bookNO
    }, function (jsonData) {
        if (String(jsonData.success) === '0') {
            setPatInfo(jsonData.PatInfo);
            setAppInfo(jsonData.AppInfo);
        } else {
            $.messager.show({
                title: '��ѯʧ��',
                msg: jsonData.errInfo,
                timeout: 5000,
                showType: 'slide'
            });
        }
    });
}
/**
 * @description ����ҳ�滼����Ϣֵ
 * @param {} patInfo :������Ϣjson����
 */
function setPatInfo(patInfo) {
    if (patInfo) {
        $('#pbarDiv').show();
    }
    for (var item in patInfo) {
        var domID = "#pbar" + item;
        $(domID).html(patInfo[item]);
    }
}
/**
 * @description ����ҳ��ԤԼ��Ϣֵ
 * @param {} appInfo :ԤԼ��Ϣjson����
 */
function setAppInfo(appInfo) {
    for (var item in appInfo) {
        var domID = "#" + item + "AppI";
        if (domID === '#AppDateAppI') {
            $(domID).datebox('setValue', appInfo[item])
        } else {
            $(domID).val(appInfo[item]);
        }

    }
}
/**
 * @description ԤԼ�����б�����ѯ
 * @param {*} rowIndex 
 * @param {*} rowData 
 */
function appPatGridClickRow(rowIndex, rowData) {
    GV.IPAppID = rowData.IPAppID;
    var bookNO = rowData.BookNO;
    getAppInfo(bookNO);
    findWardBedSummery(rowData.AppLocID, rowData.WardFlag, rowData.AppDate, '', rowData.IPAppID);
}
/**
 * @description �����б�ˢ��ʱ,��������ʹ�λ�б�
 */
function appPatGridLoadSuccess() {
    $('#wardGrid').datagrid({ data: [] });
    $('#bedGrid').datagrid({ data: [] });
}
/**
 * @description ��ȡ������λ��Ҫ��Ϣ
 * @param {*} LocID 
 * @param {*} WardFlag 
 * @param {*} AppDate
 */
function findWardBedSummery(LocID, WardFlag, AppDate, wardCode, IPAppID) {
    $cm({
        ClassName: GV.ClassName,
        QueryName: "findWardBedSummery",
        ResultSetType: "array",
        LocID: LocID,
        WardFlag: WardFlag,
        AppDate: AppDate,
        WardCode: wardCode,
        IPAppID: IPAppID
    }, function (jsonData) {
        $('#wardGrid').datagrid({ data: jsonData });
    });
}
/**
 * @description ����ɸѡ�����
 * @param {*} value 
 * @param {*} name 
 */
function wardSearcher(value, name) {	
	//if(value=="") return;
    var rowData = $('#appPatGrid').datagrid('getSelected');
    findWardBedSummery(rowData.AppLocID, rowData.WardFlag, rowData.AppDate, value, GV.IPAppID);
}
/**
 * @description �����б����¼�
 * @param {*} rowIndex 
 * @param {*} rowData 
 */
function wardGridClickRow(rowIndex, rowData) {
	$cm({
        ClassName: GV.ClassName,
        MethodName: "ifUncontrollableWardLoc",
        WardID:rowData.WardID
    }, function (jsonData) {
        if (String(jsonData.success) === '0') {
            var selBedSex = $("input[name='bedSexRadio']:checked").val();
			if(!selBedSex){
				$HUI.radio("#allBedRadio").setValue(true);
				selBedSex="A";
			}
			var appData = $('#appPatGrid').datagrid('getSelected');
			var appDate = $('#AppDateAppI').datebox('getValue');
			$('#bedGrid').datagrid({
				url:$URL,
				queryParams:{
					ClassName: GV.ClassName,
					QueryName: "FindAvailableBed",
					ResultSetType: 'array',
					WardID: rowData.WardID,
					SelBedSex: selBedSex,
					AppDate: appDate,
					IPAppID: appData.IPAppID
				}
			});
        } else {
            $.messager.show({
                title: '�������ܿ���',
                msg: jsonData.errInfo ? jsonData.errInfo: jsonData.msg ,//: jsonData.errInfo,
                timeout: 5000,
                showType: 'slide'
            });
        }
    });
}

function findAvailableBed(wardID,selBedSex,appDate,appID){
	$('#bedGrid').datagrid('load', {
		ClassName: GV.ClassName,
		QueryName: "FindAvailableBed",
		ResultSetType: 'array',
		WardID: wardID,
		SelBedSex: selBedSex,
		AppDate: appDate,
		IPAppID: appID
	});
}
/**
 *@description ��λ���䰴ť����
 */
function allotBtnClick(bedID) {
    var appDate = $('#AppDateAppI').datebox('getValue');
    var appPatData = $('#appPatGrid').datagrid('getSelected');
    var userID=session['LOGON.USERID'];
    $cm({
        ClassName: GV.ClassName,
        MethodName: "allotAppoitmentBed",
        IPAppID: appPatData.IPAppID,
        BedID: bedID,
        AppDate: appDate,
        AppTime: '23:59:59',
        UserID:userID
    }, function (jsonData) {
        if ((!jsonData.msg) && (String(jsonData.success) === '0')) {
            findAppPatList(false)
            $.messager.show({
                title: '�ɹ���ʾ:',
                msg: "����ɹ�!",
                timeout: 5000,
                showType: 'slide'
            });
        } else {
            $.messager.show({
                title: '����ʧ��',
                msg: jsonData.errInfo ? jsonData.errInfo: jsonData.msg ,//: jsonData.errInfo,
                timeout: 5000,
                showType: 'slide'
            });
        }
    });
}
/**
 * @description ȡ������
 * @param {*} IPAppID 
 */
function cancleBtnClick(IPAppID) {
    var userID = session['LOGON.USERID'];
    $cm({
        ClassName: GV.ClassName,
        MethodName: "cancleAllotBed",
        IPAppID: IPAppID,
        UserID:userID
    }, function (jsonData) {
        if ((!jsonData.msg) && (String(jsonData.success) === '0')) {
            findAppPatList(false);
            $.messager.show({
                title: '�ɹ���ʾ:',
                msg: "ȡ������ɹ�!",
                timeout: 5000,
                showType: 'slide'
            });
        } else {
            $.messager.show({
                title: 'ȡ������ʧ��',
                msg: jsonData.msg ? jsonData.msg : jsonData.errInfo,
                timeout: 5000,
                showType: 'slide'
            });
        }
    });
}


function appDateAppIClick(date) {
    var appDate = formatDate(date);
    var appData = $('#appPatGrid').datagrid('getSelected');
    findWardBedSummery(appData.AppLocID, appData.WardFlag, appDate, '', appData.IPAppID)
}

/**
 * @description ��λ�Ա����
 */
function bedSexRadioCheckChange(e, value) {
	var selBedSex = $(e.target).val();
	var rowData = $('#wardGrid').datagrid('getSelected');
	var appData = $('#appPatGrid').datagrid('getSelected');
	var appDate = $('#AppDateAppI').datebox('getValue');
	if(rowData){
		findAvailableBed(rowData.WardID, selBedSex, appDate, appData.IPAppID);
	}else{
		$.messager.show({
                title: '��ʾ',
                msg: '<font color="red">����ѡ������</font>',
                timeout: 5000,
                showType: 'slide'
            });
	}
	
}


/**
 *@description ����ǼǱ�
 */
function clearScrean() {
    setPatInfo({"AdmType": "",
                "Age": "",
                "PatName": "",
                "RegNO": "",
                "Sex": ""});
    setAppInfo({"AppCash": "",
                "AppDate": "",
                "AppDocName": "",
                "AppDocID": "",
                "AppLocDesc": "",
                "AppLocID": "",
                "AppWardDesc": "",
                "AppWardID": "",
                "BookDoc": "",
                "BookLoc": "",
                "CreateUser": "",
                "Diagnosis": "",
                "IPStatus": "",
                "LinkMan": "",
                "LinkPhone": "",
                "OperDate": "",
                "OperName": "",
                "RegDate": ""});
}